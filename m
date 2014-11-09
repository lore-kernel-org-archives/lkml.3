Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752074AbaKIMXD (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Nov 2014 07:23:03 -0500
Received: from mx4-phx2.redhat.com ([209.132.183.25]:36830 "EHLO
	mx4-phx2.redhat.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751568AbaKIMXB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Nov 2014 07:23:01 -0500
Date: Sun, 9 Nov 2014 07:22:27 -0500 (EST)
From: Rodrigo Freire <rfreire@redhat.com>
To: linux-mtd@lists.infradead.org, linux-kernel@vger.kernel.org
Cc: =?utf-8?B?SsO2cm4=?= Engel <joern@logfs.org>,
        Felix Fietkau <nbd@openwrt.org>, dwmw2@infradead.org,
        Herton Krzesinski <hkrzesin@redhat.com>,
        Brian Norris <computersforpeace@gmail.com>
Message-ID: <2138224172.7454780.1415535747241.JavaMail.zimbra@redhat.com>
In-Reply-To: <2086372266.7454667.1415535533979.JavaMail.zimbra@redhat.com>
References: <371358190.34795877.1410204429882.JavaMail.zimbra@redhat.com> <1444809468.34812041.1410206680931.JavaMail.zimbra@redhat.com> <20140909170231.GA14429@logfs.org> <1807144344.40128259.1410985683342.JavaMail.zimbra@redhat.com> <20141105202303.GN23619@ld-irv-0074> <2086372266.7454667.1415535533979.JavaMail.zimbra@redhat.com>
Subject: [PATCH v3 2/3] mtd: block2mtd: Adds a mtd name and a block device
 timeout option
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.5.82.11]
X-Mailer: Zimbra 8.0.6_GA_5922 (ZimbraWebClient - FF24 (Linux)/8.0.6_GA_5922)
Thread-Topic: block2mtd: wait for device enumeration, add name support
Thread-Index: PMeTZNEFdw+DidHIeFmVdhF00sSfjBbw7IGN
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Felix Fietkau <nbd@openwrt.org>

mtd: block2mtd: Adds a mtd name and a block device timeout option

This patch adds support to a block2mtd MTD name and allows to specify
a block device timeout when adding a block2mtd MTD drive.
Usage: block2mtd=<dev>[,<erasesize>[,<name>[,<timeout>]]]
The devices will be identified the following way:
[root@server01 ~]# cat /proc/mtd
dev:    size   erasesize  name
mtd0: a0000000 00010000 "rootfs"
mtd1: 265080000 00010000 "anothername"
mtd2: acd00000 00010000 "/dev/mmcblk0p2"
Notice that the device mtd2 was added without specifying a name.

Signed-off-by: Felix Fietkau <nbd@openwrt.org>
Signed-off-by: Rodrigo Freire <rfreire@redhat.com>
Signed-off-by: Herton Krzesinski <herton@redhat.com>
---
V3: Separated on a single patch
--- a/drivers/mtd/devices/block2mtd.c	2014-11-07 17:16:11.711479312 -0200
+++ b/drivers/mtd/devices/block2mtd.c	2014-11-07 17:15:14.255464054 -0200
@@ -25,6 +25,7 @@
 #include <linux/list.h>
 #include <linux/init.h>
 #include <linux/mtd/mtd.h>
+#include <linux/mtd/partitions.h>
 #include <linux/mutex.h>
 #include <linux/mount.h>
 #include <linux/slab.h>
@@ -218,7 +219,7 @@ static void block2mtd_free_device(struct
 
 
 static struct block2mtd_dev *add_device(char *devname, int erase_size,
-		int timeout)
+		const char *mtdname, int timeout)
 {
 #ifndef MODULE
 	int i;
@@ -226,6 +227,7 @@ static struct block2mtd_dev *add_device(
 	const fmode_t mode = FMODE_READ | FMODE_WRITE | FMODE_EXCL;
 	struct block_device *bdev = ERR_PTR(-ENODEV);
 	struct block2mtd_dev *dev;
+	struct mtd_partition *part;
 	char *name;
 
 	if (!devname)
@@ -282,7 +284,9 @@ static struct block2mtd_dev *add_device(
 
 	/* Setup the MTD structure */
 	/* make the name contain the block device in */
-	name = kasprintf(GFP_KERNEL, "block2mtd: %s", devname);
+	if (!mtdname)
+		mtdname = devname;
+	name = kstrdup(mtdname, GFP_KERNEL);
 	if (!name)
 		goto err_destroy_mutex;
 
@@ -301,7 +305,11 @@ static struct block2mtd_dev *add_device(
 	dev->mtd.priv = dev;
 	dev->mtd.owner = THIS_MODULE;
 
-	if (mtd_device_register(&dev->mtd, NULL, 0)) {
+	part = kzalloc(sizeof(struct mtd_partition), GFP_KERNEL);
+	part->name = name;
+	part->offset = 0;
+	part->size = dev->mtd.size;
+	if (mtd_device_register(&dev->mtd, part, 1)) {
 		/* Device didn't get added, so free the entry */
 		goto err_destroy_mutex;
 	}
@@ -309,8 +317,7 @@ static struct block2mtd_dev *add_device(
 	list_add(&dev->list, &blkmtd_device_list);
 	pr_info("mtd%d: [%s] erase_size = %dKiB [%d]\n",
 		dev->mtd.index,
-		dev->mtd.name + strlen("block2mtd: "),
-		dev->mtd.erasesize >> 10, dev->mtd.erasesize);
+		mtdname, dev->mtd.erasesize >> 10, dev->mtd.erasesize);
 	return dev;
 
 err_destroy_mutex:
@@ -383,7 +390,7 @@ static int block2mtd_setup2(const char *
 	/* 80 for device, 12 for erase size, 80 for name, 8 for timeout */
 	char buf[80 + 12 + 80 + 8];
 	char *str = buf;
-	char *token[2];
+	char *token[4];
 	char *name;
 	size_t erase_size = PAGE_SIZE;
 	unsigned long timeout = MTD_DEFAULT_TIMEOUT;
@@ -397,7 +404,7 @@ static int block2mtd_setup2(const char *
 	strcpy(str, val);
 	kill_final_newline(str);
 
-	for (i = 0; i < 2; i++)
+	for (i = 0; i < 4; i++)
 		token[i] = strsep(&str, ",");
 
 	if (str) {
@@ -424,7 +431,13 @@ static int block2mtd_setup2(const char *
 		}
 	}
 
-	add_device(name, erase_size, timeout);
+	if (token[2] && (strlen(token[2]) + 1 > 80))
+		pr_err("mtd device name too long");
+
+
+	if (token[3] && kstrtoul(token[3], 0, &timeout))
+		pr_err("invalid timeout");
+	add_device(name, erase_size, token[2], timeout);
 
 	return 0;
 }
@@ -458,7 +471,7 @@ static int block2mtd_setup(const char *v
 
 
 module_param_call(block2mtd, block2mtd_setup, NULL, NULL, 0200);
-MODULE_PARM_DESC(block2mtd, "Device to use. \"block2mtd=<dev>[,<erasesize>]\"");
+MODULE_PARM_DESC(block2mtd, "Device to use. \"block2mtd=<dev>[,<erasesize>[,<name>[,<timeout>]]]\"");
 
 static int __init block2mtd_init(void)
 {
---
1.7.1
