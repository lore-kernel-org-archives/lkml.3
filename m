Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754768Ab3JUJbx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Oct 2013 05:31:53 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:39324 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753296Ab3JUIuc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Oct 2013 04:50:32 -0400
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC: akpm@linux-foundation.org, "Peter Wu" <lekensteyn@gmail.com>,
        "Manoj Chourasia" <mchourasia@nvidia.com>,
        "Jiri Kosina" <jkosina@suse.cz>
Date: Mon, 21 Oct 2013 09:46:28 +0100
Message-ID: <lsq.1382345188.889841883@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [PATCH 3.2 018/149] HID: hidraw: correctly deallocate memory on
 device disconnect
In-Reply-To: <lsq.1382345187.199780875@decadent.org.uk>
X-SA-Exim-Connect-IP: 212.20.242.100
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2.52-rc1 review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/hid/hidraw.c | 60 ++++++++++++++++++++++------------------------------
 1 file changed, 25 insertions(+), 35 deletions(-)

--- a/drivers/hid/hidraw.c
+++ b/drivers/hid/hidraw.c
@@ -113,7 +113,7 @@ static ssize_t hidraw_send_report(struct
 	__u8 *buf;
 	int ret = 0;
 
-	if (!hidraw_table[minor]) {
+	if (!hidraw_table[minor] || !hidraw_table[minor]->exist) {
 		ret = -ENODEV;
 		goto out;
 	}
@@ -261,7 +261,7 @@ static int hidraw_open(struct inode *ino
 	}
 
 	mutex_lock(&minors_lock);
-	if (!hidraw_table[minor]) {
+	if (!hidraw_table[minor] || !hidraw_table[minor]->exist) {
 		err = -ENODEV;
 		goto out_unlock;
 	}
@@ -295,39 +295,38 @@ out:
 
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
@@ -531,18 +530,9 @@ void hidraw_disconnect(struct hid_device
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

