Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755368AbaCZQN4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Mar 2014 12:13:56 -0400
Received: from mail-pd0-f172.google.com ([209.85.192.172]:51539 "EHLO
	mail-pd0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750956AbaCZQNy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Mar 2014 12:13:54 -0400
Date: Wed, 26 Mar 2014 09:13:37 -0700
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: linux-input@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] Input: mousedev - fix race when creating mixed device
Message-ID: <20140326161321.GA3847@core.coreip.homeip.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We should not be using static variable mousedev_mix in methods that can be
called before that singleton gets assigned. While at it let's add open and
close methods to mousedev structure so that we do not need to test if we
are dealing with multiplexor or normal device and simply call appropriate
method directly.

Reported-by: depasquale.giulio@gmail.com
Signed-off-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>
---
 drivers/input/mousedev.c | 73 ++++++++++++++++++++++++++++--------------------
 1 file changed, 42 insertions(+), 31 deletions(-)

diff --git a/drivers/input/mousedev.c b/drivers/input/mousedev.c
index 4c842c3..b604564 100644
--- a/drivers/input/mousedev.c
+++ b/drivers/input/mousedev.c
@@ -67,7 +67,6 @@ struct mousedev {
 	struct device dev;
 	struct cdev cdev;
 	bool exist;
-	bool is_mixdev;
 
 	struct list_head mixdev_node;
 	bool opened_by_mixdev;
@@ -77,6 +76,9 @@ struct mousedev {
 	int old_x[4], old_y[4];
 	int frac_dx, frac_dy;
 	unsigned long touch;
+
+	int (*open_device)(struct mousedev *mousedev);
+	void (*close_device)(struct mousedev *mousedev);
 };
 
 enum mousedev_emul {
@@ -116,9 +118,6 @@ static unsigned char mousedev_imex_seq[] = { 0xf3, 200, 0xf3, 200, 0xf3, 80 };
 static struct mousedev *mousedev_mix;
 static LIST_HEAD(mousedev_mix_list);
 
-static void mixdev_open_devices(void);
-static void mixdev_close_devices(void);
-
 #define fx(i)  (mousedev->old_x[(mousedev->pkt_count - (i)) & 03])
 #define fy(i)  (mousedev->old_y[(mousedev->pkt_count - (i)) & 03])
 
@@ -428,9 +427,7 @@ static int mousedev_open_device(struct mousedev *mousedev)
 	if (retval)
 		return retval;
 
-	if (mousedev->is_mixdev)
-		mixdev_open_devices();
-	else if (!mousedev->exist)
+	if (!mousedev->exist)
 		retval = -ENODEV;
 	else if (!mousedev->open++) {
 		retval = input_open_device(&mousedev->handle);
@@ -446,9 +443,7 @@ static void mousedev_close_device(struct mousedev *mousedev)
 {
 	mutex_lock(&mousedev->mutex);
 
-	if (mousedev->is_mixdev)
-		mixdev_close_devices();
-	else if (mousedev->exist && !--mousedev->open)
+	if (mousedev->exist && !--mousedev->open)
 		input_close_device(&mousedev->handle);
 
 	mutex_unlock(&mousedev->mutex);
@@ -459,21 +454,29 @@ static void mousedev_close_device(struct mousedev *mousedev)
  * stream. Note that this function is called with mousedev_mix->mutex
  * held.
  */
-static void mixdev_open_devices(void)
+static int mixdev_open_devices(struct mousedev *mixdev)
 {
-	struct mousedev *mousedev;
+	int error;
+
+	error = mutex_lock_interruptible(&mixdev->mutex);
+	if (error)
+		return error;
 
-	if (mousedev_mix->open++)
-		return;
+	if (!mixdev->open++) {
+		struct mousedev *mousedev;
 
-	list_for_each_entry(mousedev, &mousedev_mix_list, mixdev_node) {
-		if (!mousedev->opened_by_mixdev) {
-			if (mousedev_open_device(mousedev))
-				continue;
+		list_for_each_entry(mousedev, &mousedev_mix_list, mixdev_node) {
+			if (!mousedev->opened_by_mixdev) {
+				if (mousedev_open_device(mousedev))
+					continue;
 
-			mousedev->opened_by_mixdev = true;
+				mousedev->opened_by_mixdev = true;
+			}
 		}
 	}
+
+	mutex_unlock(&mixdev->mutex);
+	return 0;
 }
 
 /*
@@ -481,19 +484,22 @@ static void mixdev_open_devices(void)
  * device. Note that this function is called with mousedev_mix->mutex
  * held.
  */
-static void mixdev_close_devices(void)
+static void mixdev_close_devices(struct mousedev *mixdev)
 {
-	struct mousedev *mousedev;
+	mutex_lock(&mixdev->mutex);
 
-	if (--mousedev_mix->open)
-		return;
+	if (!--mixdev->open) {
+		struct mousedev *mousedev;
 
-	list_for_each_entry(mousedev, &mousedev_mix_list, mixdev_node) {
-		if (mousedev->opened_by_mixdev) {
-			mousedev->opened_by_mixdev = false;
-			mousedev_close_device(mousedev);
+		list_for_each_entry(mousedev, &mousedev_mix_list, mixdev_node) {
+			if (mousedev->opened_by_mixdev) {
+				mousedev->opened_by_mixdev = false;
+				mousedev_close_device(mousedev);
+			}
 		}
 	}
+
+	mutex_unlock(&mixdev->mutex);
 }
 
 
@@ -522,7 +528,7 @@ static int mousedev_release(struct inode *inode, struct file *file)
 	mousedev_detach_client(mousedev, client);
 	kfree(client);
 
-	mousedev_close_device(mousedev);
+	mousedev->close_device(mousedev);
 
 	return 0;
 }
@@ -550,7 +556,7 @@ static int mousedev_open(struct inode *inode, struct file *file)
 	client->mousedev = mousedev;
 	mousedev_attach_client(mousedev, client);
 
-	error = mousedev_open_device(mousedev);
+	error = mousedev->open_device(mousedev);
 	if (error)
 		goto err_free_client;
 
@@ -861,16 +867,21 @@ static struct mousedev *mousedev_create(struct input_dev *dev,
 
 	if (mixdev) {
 		dev_set_name(&mousedev->dev, "mice");
+
+		mousedev->open_device = mixdev_open_devices;
+		mousedev->close_device = mixdev_close_devices;
 	} else {
 		int dev_no = minor;
 		/* Normalize device number if it falls into legacy range */
 		if (dev_no < MOUSEDEV_MINOR_BASE + MOUSEDEV_MINORS)
 			dev_no -= MOUSEDEV_MINOR_BASE;
 		dev_set_name(&mousedev->dev, "mouse%d", dev_no);
+
+		mousedev->open_device = mousedev_open_device;
+		mousedev->close_device = mousedev_close_device;
 	}
 
 	mousedev->exist = true;
-	mousedev->is_mixdev = mixdev;
 	mousedev->handle.dev = input_get_device(dev);
 	mousedev->handle.name = dev_name(&mousedev->dev);
 	mousedev->handle.handler = handler;
@@ -919,7 +930,7 @@ static void mousedev_destroy(struct mousedev *mousedev)
 	device_del(&mousedev->dev);
 	mousedev_cleanup(mousedev);
 	input_free_minor(MINOR(mousedev->dev.devt));
-	if (!mousedev->is_mixdev)
+	if (mousedev != mousedev_mix)
 		input_unregister_handle(&mousedev->handle);
 	put_device(&mousedev->dev);
 }
-- 
1.8.5.3


-- 
Dmitry
