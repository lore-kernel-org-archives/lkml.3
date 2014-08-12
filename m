Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754805AbaHLS5o (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Aug 2014 14:57:44 -0400
Received: from mail-wi0-f179.google.com ([209.85.212.179]:38217 "EHLO
	mail-wi0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754138AbaHLS5j (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Aug 2014 14:57:39 -0400
From: David Herrmann <dh.herrmann@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>, Tejun Heo <tj@kernel.org>,
        Al Viro <viro@zeniv.linux.org.uk>, linux-fsdevel@vger.kernel.org,
        Theodore Tso <tytso@mit.edu>, Christoph Hellwig <hch@infradead.org>,
        David Herrmann <dh.herrmann@gmail.com>
Subject: [PATCH RFC 3/4] Input: evdev - switch to revoke helpers
Date: Tue, 12 Aug 2014 20:54:07 +0200
Message-Id: <1407869648-1449-4-git-send-email-dh.herrmann@gmail.com>
X-Mailer: git-send-email 2.0.4
In-Reply-To: <1407869648-1449-1-git-send-email-dh.herrmann@gmail.com>
References: <1407869648-1449-1-git-send-email-dh.herrmann@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Evdev currently protectes all f_op->xy() callbacks with a mutex. We need
that to allow synchronous device removal. Once an input device is
unplugged, we mark it as dead and thus all further file-operations will
fail. The same logic is used for EVIOCREVOKE to revoke file access on a
single file-description.

By using the generic revoke() helpers, we can drop all those protections
and instead use synchronous revoke_file() and revoke_device(). As a bonus,
we no longer leave open files around after a device is dead. We can
synchronously drain the file and thus free all our file contexts and
disconnect from the dead parent device.

Signed-off-by: David Herrmann <dh.herrmann@gmail.com>
---
 drivers/input/evdev.c | 154 +++++++++++++++++++-------------------------------
 1 file changed, 57 insertions(+), 97 deletions(-)

diff --git a/drivers/input/evdev.c b/drivers/input/evdev.c
index 48b7216..0cab144 100644
--- a/drivers/input/evdev.c
+++ b/drivers/input/evdev.c
@@ -26,6 +26,7 @@
 #include <linux/major.h>
 #include <linux/device.h>
 #include <linux/cdev.h>
+#include <linux/revoke.h>
 #include "input-compat.h"
 
 struct evdev {
@@ -37,7 +38,7 @@ struct evdev {
 	struct mutex mutex;
 	struct device dev;
 	struct cdev cdev;
-	bool exist;
+	struct revokable_device revoke;
 };
 
 struct evdev_client {
@@ -49,7 +50,6 @@ struct evdev_client {
 	struct evdev *evdev;
 	struct list_head node;
 	int clkid;
-	bool revoked;
 	unsigned int bufsize;
 	struct input_event buffer[];
 };
@@ -165,9 +165,6 @@ static void evdev_pass_values(struct evdev_client *client,
 	struct input_event event;
 	bool wakeup = false;
 
-	if (client->revoked)
-		return;
-
 	event.time = ktime_to_timeval(client->clkid == CLOCK_MONOTONIC ?
 				      mono : real);
 
@@ -237,28 +234,8 @@ static int evdev_fasync(int fd, struct file *file, int on)
 static int evdev_flush(struct file *file, fl_owner_t id)
 {
 	struct evdev_client *client = file->private_data;
-	struct evdev *evdev = client->evdev;
-	int retval;
-
-	retval = mutex_lock_interruptible(&evdev->mutex);
-	if (retval)
-		return retval;
-
-	if (!evdev->exist || client->revoked)
-		retval = -ENODEV;
-	else
-		retval = input_flush_device(&evdev->handle, file);
-
-	mutex_unlock(&evdev->mutex);
-	return retval;
-}
 
-static void evdev_free(struct device *dev)
-{
-	struct evdev *evdev = container_of(dev, struct evdev, dev);
-
-	input_put_device(evdev->handle.dev);
-	kfree(evdev);
+	return input_flush_device(&client->evdev->handle, file);
 }
 
 /*
@@ -304,7 +281,7 @@ static int evdev_release(struct inode *inode, struct file *file)
 	mutex_lock(&evdev->mutex);
 	evdev_ungrab(evdev, client);
 	list_del_rcu(&client->node);
-	if (evdev->exist && !--evdev->open)
+	if (!--evdev->open)
 		input_close_device(&evdev->handle);
 	mutex_unlock(&evdev->mutex);
 
@@ -352,11 +329,6 @@ static int evdev_open(struct inode *inode, struct file *file)
 
 	list_add_tail_rcu(&client->node, &evdev->client_list);
 
-	if (!evdev->exist) {
-		error = -ENODEV;
-		goto err_unlink;
-	}
-
 	if (!evdev->open++) {
 		error = input_open_device(&evdev->handle);
 		if (error) {
@@ -365,13 +337,19 @@ static int evdev_open(struct inode *inode, struct file *file)
 		}
 	}
 
-	mutex_unlock(&evdev->mutex);
-
 	file->private_data = client;
 	nonseekable_open(inode, file);
 
+	error = make_revokable(&evdev->revoke, file);
+	if (error)
+		goto err_close;
+
+	mutex_unlock(&evdev->mutex);
 	return 0;
 
+err_close:
+	if (!--evdev->open)
+		input_close_device(&evdev->handle);
 err_unlink:
 	list_del_rcu(&client->node);
 	mutex_unlock(&evdev->mutex);
@@ -392,29 +370,15 @@ static ssize_t evdev_write(struct file *file, const char __user *buffer,
 	if (count != 0 && count < input_event_size())
 		return -EINVAL;
 
-	retval = mutex_lock_interruptible(&evdev->mutex);
-	if (retval)
-		return retval;
-
-	if (!evdev->exist || client->revoked) {
-		retval = -ENODEV;
-		goto out;
-	}
-
 	while (retval + input_event_size() <= count) {
+		if (input_event_from_user(buffer + retval, &event))
+			return -EFAULT;
 
-		if (input_event_from_user(buffer + retval, &event)) {
-			retval = -EFAULT;
-			goto out;
-		}
 		retval += input_event_size();
-
 		input_inject_event(&evdev->handle,
 				   event.type, event.code, event.value);
 	}
 
- out:
-	mutex_unlock(&evdev->mutex);
 	return retval;
 }
 
@@ -449,7 +413,7 @@ static ssize_t evdev_read(struct file *file, char __user *buffer,
 		return -EINVAL;
 
 	for (;;) {
-		if (!evdev->exist || client->revoked)
+		if (device_is_revoked(&evdev->revoke))
 			return -ENODEV;
 
 		if (client->packet_head == client->tail &&
@@ -478,7 +442,7 @@ static ssize_t evdev_read(struct file *file, char __user *buffer,
 		if (!(file->f_flags & O_NONBLOCK)) {
 			error = wait_event_interruptible(evdev->wait,
 					client->packet_head != client->tail ||
-					!evdev->exist || client->revoked);
+					device_is_revoked(&evdev->revoke));
 			if (error)
 				return error;
 		}
@@ -496,11 +460,7 @@ static unsigned int evdev_poll(struct file *file, poll_table *wait)
 
 	poll_wait(file, &evdev->wait, wait);
 
-	if (evdev->exist && !client->revoked)
-		mask = POLLOUT | POLLWRNORM;
-	else
-		mask = POLLHUP | POLLERR;
-
+	mask = POLLOUT | POLLWRNORM;
 	if (client->packet_head != client->tail)
 		mask |= POLLIN | POLLRDNORM;
 
@@ -748,17 +708,6 @@ static int evdev_handle_mt_request(struct input_dev *dev,
 	return 0;
 }
 
-static int evdev_revoke(struct evdev *evdev, struct evdev_client *client,
-			struct file *file)
-{
-	client->revoked = true;
-	evdev_ungrab(evdev, client);
-	input_flush_device(&evdev->handle, file);
-	wake_up_interruptible(&evdev->wait);
-
-	return 0;
-}
-
 static long evdev_do_ioctl(struct file *file, unsigned int cmd,
 			   void __user *p, int compat_mode)
 {
@@ -821,12 +770,6 @@ static long evdev_do_ioctl(struct file *file, unsigned int cmd,
 		else
 			return evdev_ungrab(evdev, client);
 
-	case EVIOCREVOKE:
-		if (p)
-			return -EINVAL;
-		else
-			return evdev_revoke(evdev, client, file);
-
 	case EVIOCSCLOCKID:
 		if (copy_from_user(&i, p, sizeof(unsigned int)))
 			return -EFAULT;
@@ -963,6 +906,17 @@ static long evdev_do_ioctl(struct file *file, unsigned int cmd,
 	return -EINVAL;
 }
 
+static int evdev_revoke(struct evdev *evdev, struct evdev_client *client,
+			struct file *file)
+{
+	revoke_file(file);
+	wake_up_interruptible(&evdev->wait);
+	kill_fasync(&client->fasync, SIGIO, POLL_HUP);
+	drain_file_self(file);
+
+	return 0;
+}
+
 static long evdev_ioctl_handler(struct file *file, unsigned int cmd,
 				void __user *p, int compat_mode)
 {
@@ -970,19 +924,21 @@ static long evdev_ioctl_handler(struct file *file, unsigned int cmd,
 	struct evdev *evdev = client->evdev;
 	int retval;
 
-	retval = mutex_lock_interruptible(&evdev->mutex);
-	if (retval)
-		return retval;
-
-	if (!evdev->exist || client->revoked) {
-		retval = -ENODEV;
-		goto out;
+	/* unlocked ioctls */
+	switch (cmd) {
+	case EVIOCREVOKE:
+		if (p)
+			return -EINVAL;
+		else
+			return evdev_revoke(evdev, client, file);
 	}
 
-	retval = evdev_do_ioctl(file, cmd, p, compat_mode);
+	retval = mutex_lock_interruptible(&evdev->mutex);
+	if (!retval) {
+		retval = evdev_do_ioctl(file, cmd, p, compat_mode);
+		mutex_unlock(&evdev->mutex);
+	}
 
- out:
-	mutex_unlock(&evdev->mutex);
 	return retval;
 }
 
@@ -1015,9 +971,16 @@ static const struct file_operations evdev_fops = {
 	.llseek		= no_llseek,
 };
 
+static void evdev_free(struct device *dev)
+{
+	struct evdev *evdev = container_of(dev, struct evdev, dev);
+
+	input_put_device(evdev->handle.dev);
+	kfree(evdev);
+}
+
 static void evdev_cleanup(struct evdev *evdev)
 {
-	struct input_handle *handle = &evdev->handle;
 	struct evdev_client *client;
 
 	/*
@@ -1025,21 +988,18 @@ static void evdev_cleanup(struct evdev *evdev)
 	 * Then wake up running users that wait for I/O so they can disconnect
 	 * from the dead device.
 	 */
-	mutex_lock(&evdev->mutex);
-	evdev->exist = false;
-	list_for_each_entry(client, &evdev->client_list, node)
+
+	cdev_del(&evdev->cdev);
+	revoke_device(&evdev->revoke);
+
+	rcu_read_lock();
+	list_for_each_entry_rcu(client, &evdev->client_list, node)
 		kill_fasync(&client->fasync, SIGIO, POLL_HUP);
-	mutex_unlock(&evdev->mutex);
+	rcu_read_unlock();
 
 	wake_up_interruptible(&evdev->wait);
 
-	cdev_del(&evdev->cdev);
-
-	/* evdev is marked dead so no one else accesses evdev->open */
-	if (evdev->open) {
-		input_flush_device(handle, NULL);
-		input_close_device(handle);
-	}
+	drain_device(&evdev->revoke);
 }
 
 /*
@@ -1070,7 +1030,7 @@ static int evdev_connect(struct input_handler *handler, struct input_dev *dev,
 	INIT_LIST_HEAD(&evdev->client_list);
 	mutex_init(&evdev->mutex);
 	init_waitqueue_head(&evdev->wait);
-	evdev->exist = true;
+	init_revokable_device(&evdev->revoke);
 
 	dev_no = minor;
 	/* Normalize device number if it falls into legacy range */
-- 
2.0.4

