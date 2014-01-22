Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755967AbaAVQ1i (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Jan 2014 11:27:38 -0500
Received: from mailrelay007.isp.belgacom.be ([195.238.6.173]:54845 "EHLO
	mailrelay007.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752697AbaAVQ1h (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Jan 2014 11:27:37 -0500
X-Belgacom-Dynamic: yes
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AgYhACfx31JXQzVI/2dsb2JhbABbKIJjOIMCpBuVEwICgRMXdIJTExwjGIECN4gJAcMBjQGBex2EIgSJRY5cAYpOh0qBb4FLLw
Date: Wed, 22 Jan 2014 16:28:43 +0800
From: Fabian Frederick <fabf@skynet.be>
To: linux-mtd@lists.infradead.org
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        rdunlap@infradead.org, joern@lazybastard.org
Subject: [PATCH 1/1 RESEND] mtd: block2mtd: char mtd major and erasesize
 parameter check + mutex_destroy
Message-Id: <20140122162843.15c3fb1e1318346339fcbff4@skynet.be>
X-Mailer: Sylpheed 3.3.0 (GTK+ 2.24.10; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

-Deny use of a char mtd device to map as block device.
-mutex_init when mtd structure is available.
-fixme applied : check device size is a multiple of erasesize.
-mutex_destroy on each device in block2mtd_exit and add_device failure.

Signed-off-by: Fabian Frederick <fabf@skynet.be>
---
 drivers/mtd/devices/block2mtd.c | 18 +++++++++++++-----
 1 file changed, 13 insertions(+), 5 deletions(-)

diff --git a/drivers/mtd/devices/block2mtd.c b/drivers/mtd/devices/block2mtd.c
index d9fd87a..be67731 100644
--- a/drivers/mtd/devices/block2mtd.c
+++ b/drivers/mtd/devices/block2mtd.c
@@ -209,7 +209,6 @@ static void block2mtd_free_device(struct block2mtd_dev *dev)
 }
 
 
-/* FIXME: ensure that mtd->size % erase_size == 0 */
 static struct block2mtd_dev *add_device(char *devname, int erase_size)
 {
 	const fmode_t mode = FMODE_READ | FMODE_WRITE | FMODE_EXCL;
@@ -244,21 +243,27 @@ static struct block2mtd_dev *add_device(char *devname, int erase_size)
 	}
 	dev->blkdev = bdev;
 
-	if (MAJOR(bdev->bd_dev) == MTD_BLOCK_MAJOR) {
+	if ((MAJOR(bdev->bd_dev) == MTD_BLOCK_MAJOR) ||
+	    (MAJOR(bdev->bd_dev) == MTD_CHAR_MAJOR)) {
 		pr_err("attempting to use an MTD device as a block device\n");
 		goto devinit_err;
 	}
 
-	mutex_init(&dev->write_mutex);
 
 	/* Setup the MTD structure */
 	/* make the name contain the block device in */
 	name = kasprintf(GFP_KERNEL, "block2mtd: %s", devname);
+
 	if (!name)
 		goto devinit_err;
+
+	if ((long)dev->blkdev->bd_inode->i_size % erase_size) {
+		pr_err("erasesize must be a divisor of device size\n");
+		goto devinit_err;
+	}
 
+	mutex_init(&dev->write_mutex);
 	dev->mtd.name = name;
-
 	dev->mtd.size = dev->blkdev->bd_inode->i_size & PAGE_MASK;
 	dev->mtd.erasesize = erase_size;
 	dev->mtd.writesize = 1;
@@ -274,7 +279,7 @@ static struct block2mtd_dev *add_device(char *devname, int erase_size)
 
 	if (mtd_device_register(&dev->mtd, NULL, 0)) {
 		/* Device didn't get added, so free the entry */
-		goto devinit_err;
+		goto register_err;
 	}
 	list_add(&dev->list, &blkmtd_device_list);
 	pr_info("mtd%d: [%s] erase_size = %dKiB [%d]\n",
@@ -283,6 +288,8 @@ static struct block2mtd_dev *add_device(char *devname, int erase_size)
 		dev->mtd.erasesize >> 10, dev->mtd.erasesize);
 	return dev;
 
+register_err:
+	mutex_destroy(&dev->write_mutex);
 devinit_err:
 	block2mtd_free_device(dev);
 	return NULL;
@@ -448,6 +455,7 @@ static void block2mtd_exit(void)
 		struct block2mtd_dev *dev = list_entry(pos, typeof(*dev), list);
 		block2mtd_sync(&dev->mtd);
 		mtd_device_unregister(&dev->mtd);
+		mutex_destroy(&dev->write_mutex);
 		pr_info("mtd%d: [%s] removed\n",
 			dev->mtd.index,
 			dev->mtd.name + strlen("block2mtd: "));
-- 
1.8.1.4
