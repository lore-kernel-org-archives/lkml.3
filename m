Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755374Ab3JUJcN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Oct 2013 05:32:13 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:39322 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753085Ab3JUIub (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Oct 2013 04:50:31 -0400
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC: akpm@linux-foundation.org, "Jiri Kosina" <jkosina@suse.cz>
Date: Mon, 21 Oct 2013 09:46:28 +0100
Message-ID: <lsq.1382345188.367165274@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [PATCH 3.2 017/149] HID: hidraw: put old deallocation mechanism
 in place
In-Reply-To: <lsq.1382345187.199780875@decadent.org.uk>
X-SA-Exim-Connect-IP: 212.20.242.100
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2.52-rc1 review patch.  If anyone has any objections, please let me know.

------------------

From: Jiri Kosina <jkosina@suse.cz>

commit df0cfd6990347c20ae031f3f34137cba274f1972 upstream.

This basically reverts commit 4fe9f8e203fda. It causes multiple problems,
namely:

- after rmmod/modprobe cycle of bus driver, the input is not claimed any
  more. This is likely because of misplaced hid_hw_close()
- it causes memory corruption on hidraw_list

As original patch author is not responding to requests to fix his patch,
and the original deallocation mechanism is not exposing any problems, I
am reverting back to it.

Signed-off-by: Jiri Kosina <jkosina@suse.cz>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/hid/hidraw.c | 69 ++++++++++++++++++++++++++++++++--------------------
 1 file changed, 43 insertions(+), 26 deletions(-)

--- a/drivers/hid/hidraw.c
+++ b/drivers/hid/hidraw.c
@@ -42,7 +42,6 @@ static struct cdev hidraw_cdev;
 static struct class *hidraw_class;
 static struct hidraw *hidraw_table[HIDRAW_MAX_DEVICES];
 static DEFINE_MUTEX(minors_lock);
-static void drop_ref(struct hidraw *hid, int exists_bit);
 
 static ssize_t hidraw_read(struct file *file, char __user *buffer, size_t count, loff_t *ppos)
 {
@@ -114,7 +113,7 @@ static ssize_t hidraw_send_report(struct
 	__u8 *buf;
 	int ret = 0;
 
-	if (!hidraw_table[minor] || !hidraw_table[minor]->exist) {
+	if (!hidraw_table[minor]) {
 		ret = -ENODEV;
 		goto out;
 	}
@@ -262,7 +261,7 @@ static int hidraw_open(struct inode *ino
 	}
 
 	mutex_lock(&minors_lock);
-	if (!hidraw_table[minor] || !hidraw_table[minor]->exist) {
+	if (!hidraw_table[minor]) {
 		err = -ENODEV;
 		goto out_unlock;
 	}
@@ -299,12 +298,36 @@ out:
 static int hidraw_release(struct inode * inode, struct file * file)
 {
 	unsigned int minor = iminor(inode);
+	struct hidraw *dev;
 	struct hidraw_list *list = file->private_data;
+	int ret;
+	int i;
+
+	mutex_lock(&minors_lock);
+	if (!hidraw_table[minor]) {
+		ret = -ENODEV;
+		goto unlock;
+	}
 
-	drop_ref(hidraw_table[minor], 0);
 	list_del(&list->node);
+	dev = hidraw_table[minor];
+	if (!--dev->open) {
+		if (list->hidraw->exist) {
+			hid_hw_power(dev->hid, PM_HINT_NORMAL);
+			hid_hw_close(dev->hid);
+		} else {
+			kfree(list->hidraw);
+		}
+	}
+
+	for (i = 0; i < HIDRAW_BUFFER_SIZE; ++i)
+		kfree(list->buffer[i].value);
 	kfree(list);
-	return 0;
+	ret = 0;
+unlock:
+	mutex_unlock(&minors_lock);
+
+	return ret;
 }
 
 static long hidraw_ioctl(struct file *file, unsigned int cmd,
@@ -506,7 +529,21 @@ EXPORT_SYMBOL_GPL(hidraw_connect);
 void hidraw_disconnect(struct hid_device *hid)
 {
 	struct hidraw *hidraw = hid->hidraw;
-	drop_ref(hidraw, 1);
+
+	mutex_lock(&minors_lock);
+	hidraw->exist = 0;
+
+	device_destroy(hidraw_class, MKDEV(hidraw_major, hidraw->minor));
+
+	hidraw_table[hidraw->minor] = NULL;
+
+	if (hidraw->open) {
+		hid_hw_close(hid);
+		wake_up_interruptible(&hidraw->wait);
+	} else {
+		kfree(hidraw);
+	}
+	mutex_unlock(&minors_lock);
 }
 EXPORT_SYMBOL_GPL(hidraw_disconnect);
 
@@ -555,23 +592,3 @@ void hidraw_exit(void)
 	unregister_chrdev_region(dev_id, HIDRAW_MAX_DEVICES);
 
 }
-
-static void drop_ref(struct hidraw *hidraw, int exists_bit)
-{
-	mutex_lock(&minors_lock);
-	if (exists_bit) {
-		hid_hw_close(hidraw->hid);
-		hidraw->exist = 0;
-		if (hidraw->open)
-			wake_up_interruptible(&hidraw->wait);
-	} else {
-		--hidraw->open;
-	}
-
-	if (!hidraw->open && !hidraw->exist) {
-		device_destroy(hidraw_class, MKDEV(hidraw_major, hidraw->minor));
-		hidraw_table[hidraw->minor] = NULL;
-		kfree(hidraw);
-	}
-	mutex_unlock(&minors_lock);
-}

