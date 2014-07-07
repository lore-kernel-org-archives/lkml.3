Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752268AbaGGJ7m (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jul 2014 05:59:42 -0400
Received: from nm5-vm9.bullet.mail.ir2.yahoo.com ([212.82.96.116]:31687 "EHLO
	nm5-vm9.bullet.mail.ir2.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751779AbaGGJ7k (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jul 2014 05:59:40 -0400
X-Greylist: delayed 352 seconds by postgrey-1.27 at vger.kernel.org; Mon, 07 Jul 2014 05:59:39 EDT
X-Yahoo-Newman-Id: 683323.8254.bm@smtp140.mail.ir2.yahoo.com
X-Yahoo-Newman-Property: ymail-3
X-YMail-OSG: pFZeBdUVM1mMgHRvkIseezF9emENygN2yOCUD0mAzExpnla
 luEN89dH5xuKHzmJhEocRpHCw4FIKR6ysZk7nW45GuqokvlxvSHBlkVlMZAS
 GVw472Ei6YokcLG1UWPaNAYu9aYcR6wZf8A0irbpkUPFHDjp1WJoBE5c6TaZ
 6.7Li12MbFXPvs0VmEOVhI5uJckZpVWew_VBHcOlrhoZORRsUOvefoxl3QFm
 7X.3E6i8xUZTBMnnc4UKVZlvaL9l0exJAstjD2ADrXB5QMY3D0qJNKmjmnge
 _NUnhlujaUp0b8tkxjcwyn9WcbYU8SF7Uv1fx6C516twF2Am0hRibyKZE6q4
 SI61v7RcJgxBPF5g5egVXANbv6fpibgBSzMZPQbTAWNOibz0vumuCP4UuSxv
 cOcMjRZBm9vUmRYjHeAtH6oOMCnmFawwCFQ6B5rJCi.hHibolzj64EEYDya4
 OMbl9nfZqPHd9PP6FHiNH4iItK0Wul9CuhubUjRNELTsf9dWZ5mtlWrVJT8x
 oN4Y6zRbA7sL3lnM5vFbJXr_M7kyQJGuUJNQ-
X-Yahoo-SMTP: 1rv77aOswBAZXHe.sKY40dUsriU-
X-Rocket-Received: from localhost.localdomain (kieran@92.27.141.186 with plain [188.125.69.59])
        by smtp140.mail.ir2.yahoo.com with SMTP; 07 Jul 2014 09:53:46 +0000 UTC
From: Kieran Kunhya <kieran@kunhya.com>
To: axboe@kernel.dk
Cc: akpm@linux-foundation.org, jmoyer@redhat.com, rdunlap@infradead.org,
        fabf@skynet.be, minchan@kernel.org, linus.walleij@linaro.org,
        abhansali@stec-inc.com, gnomes@lxorguk.ukuu.org.uk, jkosina@suse.cz,
        linux-kernel@vger.kernel.org, Kieran Kunhya <kieran@kunhya.com>
Subject: [PATCH] block: Add support for Sony SxS cards Signed-off-by: Kieran Kunhya <kieran@kunhya.com>
Date: Mon,  7 Jul 2014 10:53:14 +0100
Message-Id: <1404726794-8964-2-git-send-email-kieran@kunhya.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1404726794-8964-1-git-send-email-kieran@kunhya.com>
References: <1404726794-8964-1-git-send-email-kieran@kunhya.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

---
 drivers/block/Kconfig  |    9 +
 drivers/block/Makefile |    1 +
 drivers/block/sxs.c    |  491 ++++++++++++++++++++++++++++++++++++++++++++++++
 3 files changed, 501 insertions(+)
 create mode 100644 drivers/block/sxs.c

diff --git a/drivers/block/Kconfig b/drivers/block/Kconfig
index 014a1cf..50ed13e 100644
--- a/drivers/block/Kconfig
+++ b/drivers/block/Kconfig
@@ -356,6 +356,15 @@ config BLK_DEV_SX8
 
 	  Use devices /dev/sx8/$N and /dev/sx8/$Np$M.
 
+config BLK_DEV_SXS
+        tristate "Sony SxS card support"
+        depends on PCI
+        ---help---
+          Saying Y or M here will enable support for reading
+          from Sony SxS cards.
+
+          It creates a device called /dev/sxs
+
 config BLK_DEV_RAM
 	tristate "RAM block device support"
 	---help---
diff --git a/drivers/block/Makefile b/drivers/block/Makefile
index 02b688d..1e10fb6 100644
--- a/drivers/block/Makefile
+++ b/drivers/block/Makefile
@@ -33,6 +33,7 @@ obj-$(CONFIG_VIRTIO_BLK)	+= virtio_blk.o
 
 obj-$(CONFIG_BLK_DEV_SX8)	+= sx8.o
 obj-$(CONFIG_BLK_DEV_HD)	+= hd.o
+obj-$(CONFIG_BLK_DEV_SXS)       += sxs.o
 
 obj-$(CONFIG_XEN_BLKDEV_FRONTEND)	+= xen-blkfront.o
 obj-$(CONFIG_XEN_BLKDEV_BACKEND)	+= xen-blkback/
diff --git a/drivers/block/sxs.c b/drivers/block/sxs.c
new file mode 100644
index 0000000..fa5588d
--- /dev/null
+++ b/drivers/block/sxs.c
@@ -0,0 +1,491 @@
+/*
+ *  sxs.c: Driver for Sony SxS cards
+ *
+ *  Copyright 2014 Kieran Kunhya
+ *
+ *  Author/maintainer:  Kieran Kunhya <kieran@kunhya.com>
+ *
+ *  This file is subject to the terms and conditions of the GNU General Public
+ *  License.  See the file "COPYING" in the main directory of this archive
+ *  for more details.
+ */
+
+
+#include <linux/kernel.h>
+#include <linux/module.h>
+#include <linux/interrupt.h>
+#include <linux/pci.h>
+#include <linux/init.h>
+#include <linux/delay.h>
+#include <linux/blkdev.h>
+#include <linux/genhd.h>
+#include <linux/hdreg.h>
+#include <linux/bio.h>
+
+#include <linux/completion.h>
+#include <linux/dma-mapping.h>
+#include <linux/log2.h>
+
+#include <asm/byteorder.h>
+
+#define DRV_NAME "sxs"
+
+#define PCI_DEVICE_ID_SXS_81CE 0x81ce
+#define PCI_DEVICE_ID_SXS_905C 0x905c
+
+#define SXS_MASTER_LINK_REG_L 0x10
+#define SXS_MASTER_LINK_REG_H 0x14
+#define SXS_MASTER_ADDR_REG_L 0x18
+#define SXS_MASTER_ADDR_REG_H 0x1c
+#define SXS_MASTER_SIZE_REG   0x20
+#define SXS_ENABLE_REG  0x28
+#define SXS_CONTROL_REG 0x2c
+#define SXS_STATUS_REG  0x6c
+#define SXS_RESPONSE_BUF 0x40
+
+#define KERNEL_SECTOR_SIZE 512
+
+static struct pci_device_id ids[] = {
+	{ PCI_DEVICE(PCI_VENDOR_ID_SONY, PCI_DEVICE_ID_SXS_81CE), },
+	{ PCI_DEVICE(PCI_VENDOR_ID_SONY, PCI_DEVICE_ID_SXS_905C), },
+	{ 0, }
+};
+MODULE_DEVICE_TABLE(pci, ids);
+
+struct sxs_device {
+	struct pci_dev *pci_dev;
+	spinlock_t lock;
+	void __iomem *mmio;
+
+	int    sxs_major;
+	struct gendisk *disk;
+	int    sector_size;
+	int    num_sectors;
+	int    sector_shift;
+	struct request_queue *queue;
+
+	struct completion irq_response;
+};
+
+static int sxs_getgeo(struct block_device *bdev, struct hd_geometry *geo)
+{
+	struct sxs_device *dev = bdev->bd_disk->private_data;
+	long size;
+
+	/* Make something up here */
+	size = dev->num_sectors*(dev->sector_size/KERNEL_SECTOR_SIZE);
+	geo->cylinders = (size & ~0x3f) >> 6;
+	geo->heads = 4;
+	geo->sectors = 16;
+
+	return 0;
+}
+
+static const struct block_device_operations sxs_opts = {
+	.owner          = THIS_MODULE,
+	.getgeo         = sxs_getgeo
+};
+
+static void test_read(struct sxs_device *dev, unsigned long sector,
+		      unsigned long nsect, char *buffer)
+{
+	struct pci_dev *pdev = dev->pci_dev;
+	u32 status;
+	u32 data[4];
+	u16 *tmp;
+	u32 *tmp2;
+
+	void *dma2;
+	dma_addr_t dma2_handle;
+	void *dma3;
+	dma_addr_t dma3_handle;
+
+	sector >>= dev->sector_shift;
+	nsect >>= dev->sector_shift;
+
+	/* Read */
+	dma2 = pci_alloc_consistent(pdev, 8192, &dma2_handle);
+	memset(dma2, 0, 8192);
+
+	dma3 = pci_alloc_consistent(pdev, 8192, &dma3_handle);
+	memset(dma3, 0, 8192);
+
+	tmp = dma2;
+	tmp2 = dma3;
+	tmp2[0] = dma2_handle;
+	tmp2[2] = dma3_handle;
+
+	printk_ratelimited(KERN_DEBUG"CALL %lu %lu\n",
+			   sector & 0xffffffff, nsect & 0xffffffff);
+
+	INIT_COMPLETION(dev->irq_response);
+	status = readl(dev->mmio+SXS_STATUS_REG);
+	data[0] = cpu_to_le32(0x00010028);
+	data[1] = cpu_to_le32(sector & 0xffffffff);
+	data[2] = 0x0;
+	data[3] = cpu_to_le32(nsect & 0xffffffff);
+	memcpy_toio(dev->mmio, data, sizeof(data));
+	writel(0xa0, dev->mmio+SXS_ENABLE_REG);
+	writel(0x80, dev->mmio+SXS_CONTROL_REG);
+
+	if (!wait_for_completion_timeout(&dev->irq_response,
+					 msecs_to_jiffies(5000))) {
+		pr_debug("No IRQ\n");
+	}
+
+	INIT_COMPLETION(dev->irq_response);
+	writel(dma3_handle, dev->mmio+SXS_MASTER_LINK_REG_L);
+	writel(0x0, dev->mmio+SXS_MASTER_LINK_REG_H);
+	writel(0x20, dev->mmio+SXS_CONTROL_REG);
+
+	if (!wait_for_completion_timeout(&dev->irq_response,
+					 msecs_to_jiffies(5000))) {
+		pr_debug("No IRQ\n");
+	}
+
+	/* FIXME: Use DMA properly */
+	memcpy(buffer, dma2, dev->sector_size * nsect);
+
+	printk_ratelimited(KERN_DEBUG"boot-signature %x\n", tmp[255]);
+
+	writel(0, dev->mmio+SXS_ENABLE_REG);
+
+	pci_free_consistent(pdev, 8192, dma3, dma3_handle);
+	pci_free_consistent(pdev, 8192, dma2, dma2_handle);
+}
+
+static void sxs_request(struct request_queue *q, struct bio *bio)
+{
+	int i;
+	struct bio_vec *bvec;
+	char *buffer;
+	unsigned long flags;
+	struct sxs_device *dev = q->queuedata;
+	sector_t sector = bio->bi_sector;
+
+	bio_for_each_segment(bvec, bio, i) {
+		printk_ratelimited(KERN_DEBUG"REQUEST %i %i %i\n",
+				   bio_cur_bytes(bio), bio->bi_vcnt,
+				   bvec->bv_len);
+		buffer = bvec_kmap_irq(bvec, &flags);
+		test_read(dev, sector, bio_cur_bytes(bio) >> 9, buffer);
+		sector += bio_cur_bytes(bio) >> 9;
+		bvec_kunmap_irq(buffer, &flags);
+	}
+
+	bio_endio(bio, 0);
+}
+
+static int setup_disk(struct sxs_device *dev)
+{
+	int ret = 0;
+
+	dev->sxs_major = register_blkdev(0, "sxs");
+	if (!dev->sxs_major) {
+		ret = -EBUSY;
+		goto end;
+	}
+
+	dev->queue = blk_alloc_queue(GFP_KERNEL);
+	if (!dev->queue) {
+		ret = -ENOMEM;
+		goto end;
+	}
+
+	blk_queue_make_request(dev->queue, sxs_request);
+	blk_queue_logical_block_size(dev->queue, dev->sector_size);
+	dev->queue->queuedata = dev;
+
+	/* XXX: can SxS have more partitions? */
+	dev->disk = alloc_disk(4);
+	if (!dev->disk) {
+		pr_notice("could not allocate disk\n");
+		goto end;
+	}
+	dev->disk->major = dev->sxs_major;
+	dev->disk->first_minor = 0;
+	dev->disk->fops = &sxs_opts;
+	dev->disk->queue = dev->queue;
+	dev->disk->private_data = dev;
+	snprintf(dev->disk->disk_name, 32, "sxs");
+	set_capacity(dev->disk, dev->num_sectors*
+				(dev->sector_size/KERNEL_SECTOR_SIZE));
+	add_disk(dev->disk);
+
+end:
+	return ret;
+}
+
+static void read_response_buf(void __iomem *mmio, u32 *output)
+{
+	memcpy_fromio(output, mmio+SXS_RESPONSE_BUF, 4*4);
+}
+
+static int is_write_protected(struct sxs_device *dev)
+{
+	u32 status;
+
+	status = readl(dev->mmio+SXS_STATUS_REG);
+
+	return (status >> 8) & 1;
+}
+
+/* Setup the card exactly as the Windows driver does,
+ * even the strange parts! */
+static int boot_check(struct sxs_device *dev)
+{
+	int i, ret = 0;
+	u32 status;
+	u32 output[4];
+
+	status = readl(dev->mmio+SXS_STATUS_REG);
+	pr_debug("STATUS: %x", status);
+
+	if ((status & 0xa0) != 0xa0) {
+		if ((status & 0xff) != 0x20)
+			writel(1, dev->mmio+SXS_CONTROL_REG);
+
+		for (i = 0; i < 40; i++) {
+			status = readl(dev->mmio+SXS_STATUS_REG);
+			if (status & 0x80)
+				break;
+			msleep(100);
+		}
+		if (i == 40)
+			ret = -EBUSY;
+		else {
+			read_response_buf(dev->mmio, output);
+			/* Not clear what these values mean */
+			pr_debug("Boot Response %x %x %x %x\n",
+				 output[0], output[1],
+				 output[2], output[3]);
+		}
+	}
+
+	return ret;
+}
+
+static irqreturn_t sxs_irq(int irq, void *data)
+{
+	u32 status;
+	irqreturn_t ret = IRQ_HANDLED;
+	struct sxs_device *dev = data;
+	unsigned long flags;
+
+	spin_lock_irqsave(&dev->lock, flags);
+
+	status = readl(dev->mmio+SXS_STATUS_REG);
+
+	if (status != 0x80000000)
+		writel(0x80000000, dev->mmio+SXS_STATUS_REG);
+
+	printk_ratelimited(KERN_DEBUG"IRQ\n");
+
+	spin_unlock_irqrestore(&dev->lock, flags);
+
+	complete(&dev->irq_response);
+
+	return ret;
+}
+
+static void setup_card(struct sxs_device *dev)
+{
+	u32 status;
+	u32 data[4];
+
+	status = readl(dev->mmio+SXS_STATUS_REG);
+	memset(data, 0, sizeof(data));
+
+	memcpy_toio(dev->mmio, data, sizeof(data));
+	writel(0xa0, dev->mmio+SXS_ENABLE_REG);
+	writel(0x80, dev->mmio+SXS_CONTROL_REG);
+
+	if (!wait_for_completion_timeout(&dev->irq_response,
+					 msecs_to_jiffies(1000))) {
+		pr_debug("No IRQ\n");
+	}
+
+	writel(0, dev->mmio+SXS_ENABLE_REG);
+}
+
+static int get_size(struct sxs_device *dev)
+{
+	struct pci_dev *pdev = dev->pci_dev;
+	u32 status;
+	u32 data[4];
+	int ret = 0;
+	u32 *tmp2;
+
+	void *dma;
+	dma_addr_t dma_handle;
+
+	dma = pci_alloc_consistent(pdev, 8192, &dma_handle);
+	memset(dma, 0, 8192);
+
+	INIT_COMPLETION(dev->irq_response);
+	status = readl(dev->mmio+SXS_STATUS_REG);
+	data[0] = cpu_to_le32(0x8);
+	data[1] = 0x0;
+	data[2] = 0x0;
+	data[3] = cpu_to_le32(0x1);
+	memcpy_toio(dev->mmio, data, sizeof(data));
+	writel(0xa0, dev->mmio+SXS_ENABLE_REG);
+	writel(0x80, dev->mmio+SXS_CONTROL_REG);
+
+	if (!wait_for_completion_timeout(&dev->irq_response,
+					 msecs_to_jiffies(1000))) {
+		pr_debug("No IRQ\n");
+		return -EIO;
+	}
+
+	INIT_COMPLETION(dev->irq_response);
+	writel(dma_handle, dev->mmio+SXS_MASTER_ADDR_REG_L);
+	writel(0x0, dev->mmio+SXS_MASTER_ADDR_REG_H);
+	writel(0x800, dev->mmio+SXS_MASTER_SIZE_REG);
+	writel(0x20, dev->mmio+SXS_CONTROL_REG);
+
+	if (!wait_for_completion_timeout(&dev->irq_response,
+					 msecs_to_jiffies(1000))) {
+		pr_debug("No IRQ\n");
+		ret = -EIO;
+		goto error1;
+	}
+
+	tmp2 = dma;
+
+	writel(0, dev->mmio+SXS_ENABLE_REG);
+
+	/* XXX: this might be different for larger disks */
+	dev->sector_size = le32_to_cpu(tmp2[8]) & 0xffff;
+	dev->num_sectors = le32_to_cpu(tmp2[9]) * le32_to_cpu(tmp2[10]);
+	dev->sector_shift = ilog2(dev->sector_size /
+				  KERNEL_SECTOR_SIZE);
+	pr_debug("Sector size: %x Num sectors: %x\n",
+		 dev->sector_size, dev->num_sectors);
+
+error1:
+	pci_free_consistent(pdev, 8192, dma, dma_handle);
+
+	return ret;
+}
+
+static int probe(struct pci_dev *pdev, const struct pci_device_id *id)
+{
+	int error = 0;
+	struct sxs_device *dev;
+
+	dev = kzalloc(sizeof(*dev), GFP_KERNEL);
+	if (!dev)
+		goto error1;
+	spin_lock_init(&dev->lock);
+	dev->pci_dev = pdev;
+
+	error = pci_enable_device(pdev);
+	if (error < 0)
+		goto error2;
+
+	pci_enable_msi(pdev);
+
+	error = pci_set_dma_mask(pdev, DMA_BIT_MASK(32));
+	if (error)
+		goto error3;
+
+	error = pci_request_regions(pdev, DRV_NAME);
+	if (error)
+		goto error3;
+
+	dev->mmio = pci_ioremap_bar(pdev, 0);
+	if (!dev->mmio)
+		goto error4;
+
+	pci_set_master(pdev);
+
+	if (request_irq(pdev->irq, &sxs_irq, IRQF_SHARED, DRV_NAME, dev))
+		goto error5;
+
+	if (boot_check(dev) < 0)
+		goto error6;
+
+	init_completion(&dev->irq_response);
+
+	setup_card(dev);
+
+	if (get_size(dev) < 0)
+		goto error6;
+
+	if (setup_disk(dev) < 0)
+		goto error7;
+
+	pci_set_drvdata(pdev, dev);
+
+	pr_debug("sxs driver successfully loaded\n");
+	return 0;
+
+error7:
+	if (dev->sxs_major)
+		unregister_blkdev(dev->sxs_major, "sxs");
+
+	if (dev->disk) {
+		del_gendisk(dev->disk);
+		put_disk(dev->disk);
+	}
+
+	if (dev->queue)
+		blk_cleanup_queue(dev->queue);
+error6:
+	free_irq(pdev->irq, dev);
+error5:
+	iounmap(dev->mmio);
+error4:
+	pci_release_regions(pdev);
+error3:
+	pci_disable_device(pdev);
+error2:
+	kfree(dev);
+error1:
+	return error;
+}
+
+static void remove(struct pci_dev *pdev)
+{
+	struct sxs_device *dev = pci_get_drvdata(pdev);
+
+	if (dev->sxs_major)
+		unregister_blkdev(dev->sxs_major, "sxs");
+
+	if (dev->disk) {
+		del_gendisk(dev->disk);
+		put_disk(dev->disk);
+	}
+	if (dev->queue)
+		blk_cleanup_queue(dev->queue);
+	free_irq(pdev->irq, dev);
+	iounmap(dev->mmio);
+	pci_release_regions(pdev);
+	pci_disable_msi(pdev);
+	pci_disable_device(pdev);
+	kfree(dev);
+}
+
+static struct pci_driver sxs_driver = {
+	.name = DRV_NAME,
+	.id_table = ids,
+	.probe = probe,
+	.remove = remove,
+};
+
+static int __init sxs_init(void)
+{
+	return pci_register_driver(&sxs_driver);
+}
+
+static void __exit sxs_exit(void)
+{
+	pci_unregister_driver(&sxs_driver);
+}
+
+MODULE_AUTHOR("Kieran Kunhya");
+MODULE_LICENSE("GPL");
+
+module_init(sxs_init);
+module_exit(sxs_exit);
-- 
1.7.9.5

