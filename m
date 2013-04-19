Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752603Ab3DSR7h (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Apr 2013 13:59:37 -0400
Received: from perches-mx.perches.com ([206.117.179.246]:51571 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751642Ab3DSR7g (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Apr 2013 13:59:36 -0400
Message-ID: <1366394375.3901.36.camel@joe-AO722>
Subject: [PATCH] mtd: Convert logging messages
From: Joe Perches <joe@perches.com>
To: Joern Engel <joern@lazybastard.org>
Cc: David Woodhouse <dwmw2@infradead.org>, linux-mtd@lists.infradead.org,
        LKML <linux-kernel@vger.kernel.org>
Date: Fri, 19 Apr 2013 10:59:35 -0700
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.6.2-0ubuntu0.1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use a more current logging style.

Convert homegrown ERROR/INFO macros to pr_<level>.
Convert homegrown parse_err macros to pr_err and
expand hidden flow control.

Signed-off-by: Joe Perches <joe@perches.com>
---
 drivers/mtd/devices/block2mtd.c | 58 ++++++++++++++++++++++-------------------
 1 file changed, 31 insertions(+), 27 deletions(-)

diff --git a/drivers/mtd/devices/block2mtd.c b/drivers/mtd/devices/block2mtd.c
index e081bfe..5cb4c04 100644
--- a/drivers/mtd/devices/block2mtd.c
+++ b/drivers/mtd/devices/block2mtd.c
@@ -6,6 +6,9 @@
  *
  * Licence: GPL
  */
+
+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+
 #include <linux/module.h>
 #include <linux/fs.h>
 #include <linux/blkdev.h>
@@ -18,10 +21,6 @@
 #include <linux/mount.h>
 #include <linux/slab.h>
 
-#define ERROR(fmt, args...) printk(KERN_ERR "block2mtd: " fmt "\n" , ## args)
-#define INFO(fmt, args...) printk(KERN_INFO "block2mtd: " fmt "\n" , ## args)
-
-
 /* Info for the block device */
 struct block2mtd_dev {
 	struct list_head list;
@@ -84,7 +83,7 @@ static int block2mtd_erase(struct mtd_info *mtd, struct erase_info *instr)
 	err = _block2mtd_erase(dev, from, len);
 	mutex_unlock(&dev->write_mutex);
 	if (err) {
-		ERROR("erase failed err = %d", err);
+		pr_err("erase failed err = %d\n", err);
 		instr->state = MTD_ERASE_FAILED;
 	} else
 		instr->state = MTD_ERASE_DONE;
@@ -239,13 +238,13 @@ static struct block2mtd_dev *add_device(char *devname, int erase_size)
 #endif
 
 	if (IS_ERR(bdev)) {
-		ERROR("error: cannot open device %s", devname);
+		pr_err("error: cannot open device %s\n", devname);
 		goto devinit_err;
 	}
 	dev->blkdev = bdev;
 
 	if (MAJOR(bdev->bd_dev) == MTD_BLOCK_MAJOR) {
-		ERROR("attempting to use an MTD device as a block device");
+		pr_err("attempting to use an MTD device as a block device\n");
 		goto devinit_err;
 	}
 
@@ -277,9 +276,10 @@ static struct block2mtd_dev *add_device(char *devname, int erase_size)
 		goto devinit_err;
 	}
 	list_add(&dev->list, &blkmtd_device_list);
-	INFO("mtd%d: [%s] erase_size = %dKiB [%d]", dev->mtd.index,
-			dev->mtd.name + strlen("block2mtd: "),
-			dev->mtd.erasesize >> 10, dev->mtd.erasesize);
+	pr_info("mtd%d: [%s] erase_size = %dKiB [%d]\n",
+		dev->mtd.index,
+		dev->mtd.name + strlen("block2mtd: "),
+		dev->mtd.erasesize >> 10, dev->mtd.erasesize);
 	return dev;
 
 devinit_err:
@@ -339,17 +339,11 @@ static inline void kill_final_newline(char *str)
 }
 
 
-#define parse_err(fmt, args...) do {	\
-	ERROR(fmt, ## args);		\
-	return 0;			\
-} while (0)
-
 #ifndef MODULE
 static int block2mtd_init_called = 0;
 static char block2mtd_paramline[80 + 12]; /* 80 for device, 12 for erase size */
 #endif
 
-
 static int block2mtd_setup2(const char *val)
 {
 	char buf[80 + 12]; /* 80 for device, 12 for erase size */
@@ -359,8 +353,10 @@ static int block2mtd_setup2(const char *val)
 	size_t erase_size = PAGE_SIZE;
 	int i, ret;
 
-	if (strnlen(val, sizeof(buf)) >= sizeof(buf))
-		parse_err("parameter too long");
+	if (strnlen(val, sizeof(buf)) >= sizeof(buf)) {
+		pr_err("parameter too long\n");
+		return 0;
+	}
 
 	strcpy(str, val);
 	kill_final_newline(str);
@@ -368,20 +364,27 @@ static int block2mtd_setup2(const char *val)
 	for (i = 0; i < 2; i++)
 		token[i] = strsep(&str, ",");
 
-	if (str)
-		parse_err("too many arguments");
+	if (str) {
+		pr_err("too many arguments\n");
+		return 0;
+	}
 
-	if (!token[0])
-		parse_err("no argument");
+	if (!token[0]) {
+		pr_err("no argument\n");
+		return 0;
+	}
 
 	name = token[0];
-	if (strlen(name) + 1 > 80)
-		parse_err("device name too long");
+	if (strlen(name) + 1 > 80) {
+		pr_err("device name too long\n");
+		return 0;
+	}
 
 	if (token[1]) {
 		ret = parse_num(&erase_size, token[1]);
 		if (ret) {
-			parse_err("illegal erase size");
+			pr_err("illegal erase size\n");
+			return 0;
 		}
 	}
 
@@ -444,8 +447,9 @@ static void block2mtd_exit(void)
 		struct block2mtd_dev *dev = list_entry(pos, typeof(*dev), list);
 		block2mtd_sync(&dev->mtd);
 		mtd_device_unregister(&dev->mtd);
-		INFO("mtd%d: [%s] removed", dev->mtd.index,
-				dev->mtd.name + strlen("block2mtd: "));
+		pr_info("mtd%d: [%s] removed\n",
+			dev->mtd.index,
+			dev->mtd.name + strlen("block2mtd: "));
 		list_del(&dev->list);
 		block2mtd_free_device(dev);
 	}


