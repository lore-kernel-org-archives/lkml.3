Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932077AbaHLS57 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Aug 2014 14:57:59 -0400
Received: from mail-we0-f176.google.com ([74.125.82.176]:54654 "EHLO
	mail-we0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754784AbaHLS5l (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Aug 2014 14:57:41 -0400
From: David Herrmann <dh.herrmann@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>, Tejun Heo <tj@kernel.org>,
        Al Viro <viro@zeniv.linux.org.uk>, linux-fsdevel@vger.kernel.org,
        Theodore Tso <tytso@mit.edu>, Christoph Hellwig <hch@infradead.org>,
        David Herrmann <dh.herrmann@gmail.com>
Subject: [PATCH RFC 4/4] Input: evdev - drop redundant client_list
Date: Tue, 12 Aug 2014 20:54:08 +0200
Message-Id: <1407869648-1449-5-git-send-email-dh.herrmann@gmail.com>
X-Mailer: git-send-email 2.0.4
In-Reply-To: <1407869648-1449-1-git-send-email-dh.herrmann@gmail.com>
References: <1407869648-1449-1-git-send-email-dh.herrmann@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The client_list of evdev devices keeps the same information as the VFS
revokable_file list. Drop the redundant list and use the VFS core instead.

Signed-off-by: David Herrmann <dh.herrmann@gmail.com>
---
 drivers/input/evdev.c | 31 +++++++++++++++----------------
 1 file changed, 15 insertions(+), 16 deletions(-)

diff --git a/drivers/input/evdev.c b/drivers/input/evdev.c
index 0cab144..f8c305a 100644
--- a/drivers/input/evdev.c
+++ b/drivers/input/evdev.c
@@ -34,7 +34,6 @@ struct evdev {
 	struct input_handle handle;
 	wait_queue_head_t wait;
 	struct evdev_client __rcu *grab;
-	struct list_head client_list;
 	struct mutex mutex;
 	struct device dev;
 	struct cdev cdev;
@@ -48,7 +47,6 @@ struct evdev_client {
 	spinlock_t buffer_lock; /* protects access to buffer, head and tail */
 	struct fasync_struct *fasync;
 	struct evdev *evdev;
-	struct list_head node;
 	int clkid;
 	unsigned int bufsize;
 	struct input_event buffer[];
@@ -195,6 +193,7 @@ static void evdev_events(struct input_handle *handle,
 	struct evdev *evdev = handle->private;
 	struct evdev_client *client;
 	ktime_t time_mono, time_real;
+	unsigned long flags;
 
 	time_mono = ktime_get();
 	time_real = ktime_mono_to_real(time_mono);
@@ -203,12 +202,17 @@ static void evdev_events(struct input_handle *handle,
 
 	client = rcu_dereference(evdev->grab);
 
-	if (client)
+	if (client) {
 		evdev_pass_values(client, vals, count, time_mono, time_real);
-	else
-		list_for_each_entry_rcu(client, &evdev->client_list, node)
+	} else {
+		struct revokable_iter iter = REVOKABLE_ITER_INIT;
+
+		spin_lock_irqsave(&evdev->revoke.lock, flags);
+		for_each_revokable_private(client, &iter, &evdev->revoke)
 			evdev_pass_values(client, vals, count,
 					  time_mono, time_real);
+		spin_unlock_irqrestore(&evdev->revoke.lock, flags);
+	}
 
 	rcu_read_unlock();
 }
@@ -280,7 +284,6 @@ static int evdev_release(struct inode *inode, struct file *file)
 
 	mutex_lock(&evdev->mutex);
 	evdev_ungrab(evdev, client);
-	list_del_rcu(&client->node);
 	if (!--evdev->open)
 		input_close_device(&evdev->handle);
 	mutex_unlock(&evdev->mutex);
@@ -327,13 +330,11 @@ static int evdev_open(struct inode *inode, struct file *file)
 	if (error)
 		goto err_free;
 
-	list_add_tail_rcu(&client->node, &evdev->client_list);
-
 	if (!evdev->open++) {
 		error = input_open_device(&evdev->handle);
 		if (error) {
 			evdev->open--;
-			goto err_unlink;
+			goto err_unlock;
 		}
 	}
 
@@ -350,10 +351,8 @@ static int evdev_open(struct inode *inode, struct file *file)
 err_close:
 	if (!--evdev->open)
 		input_close_device(&evdev->handle);
-err_unlink:
-	list_del_rcu(&client->node);
+err_unlock:
 	mutex_unlock(&evdev->mutex);
-	synchronize_rcu();
 err_free:
 	kfree(client);
 	return error;
@@ -981,6 +980,7 @@ static void evdev_free(struct device *dev)
 
 static void evdev_cleanup(struct evdev *evdev)
 {
+	struct revokable_iter iter = REVOKABLE_ITER_INIT;
 	struct evdev_client *client;
 
 	/*
@@ -992,10 +992,10 @@ static void evdev_cleanup(struct evdev *evdev)
 	cdev_del(&evdev->cdev);
 	revoke_device(&evdev->revoke);
 
-	rcu_read_lock();
-	list_for_each_entry_rcu(client, &evdev->client_list, node)
+	spin_lock_irq(&evdev->revoke.lock);
+	for_each_revokable_private(client, &iter, &evdev->revoke)
 		kill_fasync(&client->fasync, SIGIO, POLL_HUP);
-	rcu_read_unlock();
+	spin_unlock_irq(&evdev->revoke.lock);
 
 	wake_up_interruptible(&evdev->wait);
 
@@ -1027,7 +1027,6 @@ static int evdev_connect(struct input_handler *handler, struct input_dev *dev,
 		goto err_free_minor;
 	}
 
-	INIT_LIST_HEAD(&evdev->client_list);
 	mutex_init(&evdev->mutex);
 	init_waitqueue_head(&evdev->wait);
 	init_revokable_device(&evdev->revoke);
-- 
2.0.4

