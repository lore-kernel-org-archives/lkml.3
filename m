Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751506AbaAYKoD (ORCPT <rfc822;w@1wt.eu>);
	Sat, 25 Jan 2014 05:44:03 -0500
Received: from mailrelay003.isp.belgacom.be ([195.238.6.53]:7101 "EHLO
	mailrelay003.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750970AbaAYKoA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 25 Jan 2014 05:44:00 -0500
X-Belgacom-Dynamic: yes
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: ArMhAFOU41JXQwn9/2dsb2JhbABaKIJkOKdGlVMCAoEIF3SCUxMcIxiBAjeICQHJKo0QgX0dhCIEiUaOYAGKTodQgzov
Date: Sat, 25 Jan 2014 10:45:08 +0800
From: Fabian Frederick <fabf@skynet.be>
To: linux-mtd@lists.infradead.org
Cc: akpm@linux-foundation.org, rdunlap@infradead.org, joern@lazybastard.org,
        linux-kernel@vger.kernel.org, ezequiel.garcia@free-electrons.com
Subject: [PATCH v2] mtd: block2mtd: Add mutex_destroy
Message-Id: <20140125104508.c562066b2276aad0cb3934ee@skynet.be>
X-Mailer: Sylpheed 3.3.0 (GTK+ 2.24.10; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

mutex_destroy added on each device in block2mtd_exit and add_device failure

Signed-off-by: Fabian Frederick <fabf@skynet.be>
---
 drivers/mtd/devices/block2mtd.c | 13 ++++++++-----
 1 file changed, 8 insertions(+), 5 deletions(-)

diff --git a/drivers/mtd/devices/block2mtd.c b/drivers/mtd/devices/block2mtd.c
index d9fd87a..3e12234 100644
--- a/drivers/mtd/devices/block2mtd.c
+++ b/drivers/mtd/devices/block2mtd.c
@@ -240,13 +240,13 @@ static struct block2mtd_dev *add_device(char *devname, int erase_size)
 
 	if (IS_ERR(bdev)) {
 		pr_err("error: cannot open device %s\n", devname);
-		goto devinit_err;
+		goto err_free_block2mtd;
 	}
 	dev->blkdev = bdev;
 
 	if (MAJOR(bdev->bd_dev) == MTD_BLOCK_MAJOR) {
 		pr_err("attempting to use an MTD device as a block device\n");
-		goto devinit_err;
+		goto err_free_block2mtd;
 	}
 
 	mutex_init(&dev->write_mutex);
@@ -255,7 +255,7 @@ static struct block2mtd_dev *add_device(char *devname, int erase_size)
 	/* make the name contain the block device in */
 	name = kasprintf(GFP_KERNEL, "block2mtd: %s", devname);
 	if (!name)
-		goto devinit_err;
+		goto err_destroy_mutex;
 
 	dev->mtd.name = name;
 
@@ -274,7 +274,7 @@ static struct block2mtd_dev *add_device(char *devname, int erase_size)
 
 	if (mtd_device_register(&dev->mtd, NULL, 0)) {
 		/* Device didn't get added, so free the entry */
-		goto devinit_err;
+		goto err_destroy_mutex;
 	}
 	list_add(&dev->list, &blkmtd_device_list);
 	pr_info("mtd%d: [%s] erase_size = %dKiB [%d]\n",
@@ -283,7 +283,9 @@ static struct block2mtd_dev *add_device(char *devname, int erase_size)
 		dev->mtd.erasesize >> 10, dev->mtd.erasesize);
 	return dev;
 
-devinit_err:
+err_destroy_mutex:
+	mutex_destroy(&dev->write_mutex);
+err_free_block2mtd:
 	block2mtd_free_device(dev);
 	return NULL;
 }
@@ -448,6 +450,7 @@ static void block2mtd_exit(void)
 		struct block2mtd_dev *dev = list_entry(pos, typeof(*dev), list);
 		block2mtd_sync(&dev->mtd);
 		mtd_device_unregister(&dev->mtd);
+		mutex_destroy(&dev->write_mutex);
 		pr_info("mtd%d: [%s] removed\n",
 			dev->mtd.index,
 			dev->mtd.name + strlen("block2mtd: "));
-- 
1.8.1.4

