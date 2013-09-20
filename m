Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755820Ab3ITUcl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Sep 2013 16:32:41 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:41383 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753461Ab3ITUKC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Sep 2013 16:10:02 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Manoj Chourasia <mchourasia@nvidia.com>, Jiri Kosina <jkosina@suse.cz>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 05/93] HID: hidraw: correctly deallocate memory on device disconnect
Date: Fri, 20 Sep 2013 13:08:00 -0700
Message-Id: <1379707768-1804-6-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1379707768-1804-1-git-send-email-kamal@canonical.com>
References: <1379707768-1804-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8.13.10 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Manoj Chourasia <mchourasia@nvidia.com>

commit 212a871a3934beccf43431608c27ed2e05a476ec upstream.

This changes puts the commit 4fe9f8e203f back in place
with the fixes for slab corruption because of the commit.

When a device is unplugged, wait for all processes that
have opened the device to close before deallocating the device.

This commit was solving kernel crash because of the corruption in
rb tree of vmalloc. The rootcause was the device data pointer was
geting excessed after the memory associated with hidraw was freed.

The commit 4fe9f8e203f was buggy as it was also freeing the hidraw
first and then calling delete operation on the list associated with
that hidraw leading to slab corruption.

Signed-off-by: Manoj Chourasia <mchourasia@nvidia.com>
Tested-by: Peter Wu <lekensteyn@gmail.com>
Signed-off-by: Jiri Kosina <jkosina@suse.cz>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 drivers/hid/hidraw.c | 60 ++++++++++++++++++++++------------------------------
 1 file changed, 25 insertions(+), 35 deletions(-)

diff --git a/drivers/hid/hidraw.c b/drivers/hid/hidraw.c
index 413a731..cfe5288 100644
--- a/drivers/hid/hidraw.c
+++ b/drivers/hid/hidraw.c
@@ -113,7 +113,7 @@ static ssize_t hidraw_send_report(struct file *file, const char __user *buffer,
 	__u8 *buf;
 	int ret = 0;
 
-	if (!hidraw_table[minor]) {
+	if (!hidraw_table[minor] || !hidraw_table[minor]->exist) {
 		ret = -ENODEV;
 		goto out;
 	}
@@ -261,7 +261,7 @@ static int hidraw_open(struct inode *inode, struct file *file)
 	}
 
 	mutex_lock(&minors_lock);
-	if (!hidraw_table[minor]) {
+	if (!hidraw_table[minor] || !hidraw_table[minor]->exist) {
 		err = -ENODEV;
 		goto out_unlock;
 	}
@@ -302,39 +302,38 @@ static int hidraw_fasync(int fd, struct file *file, int on)
 	return fasync_helper(fd, file, on, &list->fasync);
 }
 
+static void drop_ref(struct hidraw *hidraw, int exists_bit)
+{
+	if (exists_bit) {
+		hid_hw_close(hidraw->hid);
+		hidraw->exist = 0;
+		if (hidraw->open)
+			wake_up_interruptible(&hidraw->wait);
+	} else {
+		--hidraw->open;
+	}
+
+	if (!hidraw->open && !hidraw->exist) {
+		device_destroy(hidraw_class, MKDEV(hidraw_major, hidraw->minor));
+		hidraw_table[hidraw->minor] = NULL;
+		kfree(hidraw);
+	}
+}
+
 static int hidraw_release(struct inode * inode, struct file * file)
 {
 	unsigned int minor = iminor(inode);
-	struct hidraw *dev;
 	struct hidraw_list *list = file->private_data;
-	int ret;
-	int i;
 
 	mutex_lock(&minors_lock);
-	if (!hidraw_table[minor]) {
-		ret = -ENODEV;
-		goto unlock;
-	}
 
 	list_del(&list->node);
-	dev = hidraw_table[minor];
-	if (!--dev->open) {
-		if (list->hidraw->exist) {
-			hid_hw_power(dev->hid, PM_HINT_NORMAL);
-			hid_hw_close(dev->hid);
-		} else {
-			kfree(list->hidraw);
-		}
-	}
-
-	for (i = 0; i < HIDRAW_BUFFER_SIZE; ++i)
-		kfree(list->buffer[i].value);
 	kfree(list);
-	ret = 0;
-unlock:
-	mutex_unlock(&minors_lock);
 
-	return ret;
+	drop_ref(hidraw_table[minor], 0);
+
+	mutex_unlock(&minors_lock);
+	return 0;
 }
 
 static long hidraw_ioctl(struct file *file, unsigned int cmd,
@@ -539,18 +538,9 @@ void hidraw_disconnect(struct hid_device *hid)
 	struct hidraw *hidraw = hid->hidraw;
 
 	mutex_lock(&minors_lock);
-	hidraw->exist = 0;
-
-	device_destroy(hidraw_class, MKDEV(hidraw_major, hidraw->minor));
 
-	hidraw_table[hidraw->minor] = NULL;
+	drop_ref(hidraw, 1);
 
-	if (hidraw->open) {
-		hid_hw_close(hid);
-		wake_up_interruptible(&hidraw->wait);
-	} else {
-		kfree(hidraw);
-	}
 	mutex_unlock(&minors_lock);
 }
 EXPORT_SYMBOL_GPL(hidraw_disconnect);
-- 
1.8.1.2

