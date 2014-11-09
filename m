Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752043AbaKIMV7 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Nov 2014 07:21:59 -0500
Received: from mx6-phx2.redhat.com ([209.132.183.39]:58669 "EHLO
	mx6-phx2.redhat.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751846AbaKIMV6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Nov 2014 07:21:58 -0500
Date: Sun, 9 Nov 2014 07:21:13 -0500 (EST)
From: Rodrigo Freire <rfreire@redhat.com>
To: linux-mtd@lists.infradead.org, linux-kernel@vger.kernel.org
Cc: =?utf-8?B?SsO2cm4=?= Engel <joern@logfs.org>,
        Felix Fietkau <nbd@openwrt.org>, dwmw2@infradead.org,
        Herton Krzesinski <hkrzesin@redhat.com>,
        Brian Norris <computersforpeace@gmail.com>
Message-ID: <573958808.7454775.1415535673904.JavaMail.zimbra@redhat.com>
In-Reply-To: <2086372266.7454667.1415535533979.JavaMail.zimbra@redhat.com>
References: <371358190.34795877.1410204429882.JavaMail.zimbra@redhat.com> <1444809468.34812041.1410206680931.JavaMail.zimbra@redhat.com> <20140909170231.GA14429@logfs.org> <1807144344.40128259.1410985683342.JavaMail.zimbra@redhat.com> <20141105202303.GN23619@ld-irv-0074> <2086372266.7454667.1415535533979.JavaMail.zimbra@redhat.com>
Subject: [PATCH v3 1/3] mtd: block2mtd: Ensure that block2mtd is triggered
 after block devices are presented.
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.5.82.11]
X-Mailer: Zimbra 8.0.6_GA_5922 (ZimbraWebClient - FF24 (Linux)/8.0.6_GA_5922)
Thread-Topic: block2mtd: wait for device enumeration, add name support
Thread-Index: PMeTZNEFdw+DidHIeFmVdhF00sSfjNYP53WJ
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Felix Fietkau <nbd@openwrt.org>

mtd: block2mtd: Ensure that block2mtd is triggered after block devices are presented.

Ensures that block2mtd is triggered after the block devices are enumerated
at boot time.
This issue is seen on BCM2835 (Raspberry Pi) systems when mounting JFFS2
block2mtd filesystems, probably because of the delay on enumerating a USB
MMC card reader.

Signed-off-by: Felix Fietkau <nbd@openwrt.org>
Signed-off-by: Rodrigo Freire <rfreire@redhat.com>
Signed-off-by: Herton Krzesinski <herton@redhat.com>
---
V3: Separated on a single patch, fixes a compiling warning, cosmethic changes
V2: Uses kstrdup, removed PAGE_MASK.
--- a/drivers/mtd/devices/block2mtd.c	2014-11-07 16:40:14.638676860 -0200
+++ b/drivers/mtd/devices/block2mtd.c	2014-11-07 17:44:45.277769924 -0200
@@ -9,7 +9,15 @@
 
 #define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
 
+/*
+ * When the first attempt at device initialization fails, we may need to
+ * wait a little bit and retry. This timeout, by default 3 seconds, gives
+ * device time to start up. Required on BCM2708 and a few other chipsets.
+ */
+#define MTD_DEFAULT_TIMEOUT	3
+
 #include <linux/module.h>
+#include <linux/delay.h>
 #include <linux/fs.h>
 #include <linux/blkdev.h>
 #include <linux/bio.h>
@@ -209,10 +217,14 @@ static void block2mtd_free_device(struct
 }
 
 
-static struct block2mtd_dev *add_device(char *devname, int erase_size)
+static struct block2mtd_dev *add_device(char *devname, int erase_size,
+		int timeout)
 {
+#ifndef MODULE
+	int i;
+#endif
 	const fmode_t mode = FMODE_READ | FMODE_WRITE | FMODE_EXCL;
-	struct block_device *bdev;
+	struct block_device *bdev = ERR_PTR(-ENODEV);
 	struct block2mtd_dev *dev;
 	char *name;
 
@@ -225,15 +237,28 @@ static struct block2mtd_dev *add_device(
 
 	/* Get a handle on the device */
 	bdev = blkdev_get_by_path(devname, mode, dev);
-#ifndef MODULE
-	if (IS_ERR(bdev)) {
 
-		/* We might not have rootfs mounted at this point. Try
-		   to resolve the device name by other means. */
+#ifndef MODULE
+/*
+ * We might not have the root device mounted at this point.
+ * Try to resolve the device name by other means.
+ */
+	for (i = 0; IS_ERR(bdev) && i <= timeout; i++) {
+		dev_t devt;
 
-		dev_t devt = name_to_dev_t(devname);
-		if (devt)
-			bdev = blkdev_get_by_dev(devt, mode, dev);
+		if (i)
+			/*
+			 * Calling wait_for_device_probe in the first loop
+			 * was not enough, sleep for a bit in subsequent
+			 * go-arounds.
+			 */
+			msleep(1000);
+		wait_for_device_probe();
+
+		devt = name_to_dev_t(devname);
+		if (!devt)
+			continue;
+		bdev = blkdev_get_by_dev(devt, mode, dev);
 	}
 #endif
 
@@ -280,6 +305,7 @@ static struct block2mtd_dev *add_device(
 		/* Device didn't get added, so free the entry */
 		goto err_destroy_mutex;
 	}
+
 	list_add(&dev->list, &blkmtd_device_list);
 	pr_info("mtd%d: [%s] erase_size = %dKiB [%d]\n",
 		dev->mtd.index,
@@ -348,16 +374,19 @@ static inline void kill_final_newline(ch
 
 #ifndef MODULE
 static int block2mtd_init_called = 0;
-static char block2mtd_paramline[80 + 12]; /* 80 for device, 12 for erase size */
+/* 80 for device, 12 for erase size */
+static char block2mtd_paramline[80 + 12];
 #endif
 
 static int block2mtd_setup2(const char *val)
 {
-	char buf[80 + 12]; /* 80 for device, 12 for erase size */
+	/* 80 for device, 12 for erase size, 80 for name, 8 for timeout */
+	char buf[80 + 12 + 80 + 8];
 	char *str = buf;
 	char *token[2];
 	char *name;
 	size_t erase_size = PAGE_SIZE;
+	unsigned long timeout = MTD_DEFAULT_TIMEOUT;
 	int i, ret;
 
 	if (strnlen(val, sizeof(buf)) >= sizeof(buf)) {
@@ -395,7 +424,7 @@ static int block2mtd_setup2(const char *
 		}
 	}
 
-	add_device(name, erase_size);
+	add_device(name, erase_size, timeout);
 
 	return 0;
 }
@@ -463,8 +492,7 @@ static void block2mtd_exit(void)
 	}
 }
 
-
-module_init(block2mtd_init);
+late_initcall(block2mtd_init);
 module_exit(block2mtd_exit);
 
 MODULE_LICENSE("GPL");
---
1.7.1
