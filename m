Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754529Ab3FRMpy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Jun 2013 08:45:54 -0400
Received: from mail-pd0-f178.google.com ([209.85.192.178]:37959 "EHLO
	mail-pd0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752400Ab3FRMpw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Jun 2013 08:45:52 -0400
Date: Tue, 18 Jun 2013 15:43:01 +0300
From: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
To: Nitin Gupta <ngupta@vflare.org>
Cc: Minchan Kim <minchan@kernel.org>, Jerome Marchand <jmarchan@redhat.com>,
        Seth Jennings <sjenning@linux.vnet.ibm.com>,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: [PATCH] staging: zram: remove zram_sysfs
Message-ID: <20130618124301.GA2313@swordfish.minsk.epam.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Zram sysfs needs to operate with zram devices (stats, sysfs attributes,
etc.). In order to make it possible zram_drv header externs struct
zram_devices and several internal functions, e.g. zram_meta_alloc/free().

Move zram sysfs code to zram drv and remove zram_sysfs.c file.
This gives ability to hide exported previously struct zram_devices
(along with other structs) and make a number of zram functions, used
from zram sysfs, static. e.g. zram_reset_device(), etc., thus zram_drv
header file becomes cleaner. We also can drop several zram_drv wrapper
functions, used from zram sysfs, e.g.
zram_reset_device()/__zram_reset_device() pair.

Signed-off-by: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>

---
 drivers/staging/zram/Makefile     |   2 +-
 drivers/staging/zram/zram_drv.c   | 454 +++++++++++++++++++++++++++-----------
 drivers/staging/zram/zram_drv.h   |  12 -
 drivers/staging/zram/zram_sysfs.c | 227 -------------------
 4 files changed, 326 insertions(+), 369 deletions(-)

diff --git a/drivers/staging/zram/Makefile b/drivers/staging/zram/Makefile
index 7f4a301..cb0f9ce 100644
--- a/drivers/staging/zram/Makefile
+++ b/drivers/staging/zram/Makefile
@@ -1,3 +1,3 @@
-zram-y	:=	zram_drv.o zram_sysfs.o
+zram-y	:=	zram_drv.o
 
 obj-$(CONFIG_ZRAM)	+=	zram.o
diff --git a/drivers/staging/zram/zram_drv.c b/drivers/staging/zram/zram_drv.c
index e34e3fe..319fb30 100644
--- a/drivers/staging/zram/zram_drv.c
+++ b/drivers/staging/zram/zram_drv.c
@@ -37,11 +37,18 @@
 
 /* Globals */
 static int zram_major;
-struct zram *zram_devices;
+static struct zram *zram_devices;
 
 /* Module params (documentation at end) */
 static unsigned int num_devices = 1;
 
+module_param(num_devices, uint, 0);
+MODULE_PARM_DESC(num_devices, "Number of zram devices");
+
+MODULE_LICENSE("Dual BSD/GPL");
+MODULE_AUTHOR("Nitin Gupta <ngupta@vflare.org>");
+MODULE_DESCRIPTION("Compressed RAM Block Device");
+
 static void zram_stat64_add(struct zram *zram, u64 *v, u64 inc)
 {
 	spin_lock(&zram->stat64_lock);
@@ -61,6 +68,121 @@ static void zram_stat64_inc(struct zram *zram, u64 *v)
 	zram_stat64_add(zram, v, 1);
 }
 
+static u64 zram_stat64_read(struct zram *zram, u64 *v)
+{
+	u64 val;
+
+	spin_lock(&zram->stat64_lock);
+	val = *v;
+	spin_unlock(&zram->stat64_lock);
+
+	return val;
+}
+
+static struct zram *dev_to_zram(struct device *dev)
+{
+	int i;
+	struct zram *zram = NULL;
+
+	for (i = 0; i < num_devices; i++) {
+		zram = &zram_devices[i];
+		if (disk_to_dev(zram->disk) == dev)
+			break;
+	}
+	return zram;
+}
+
+static ssize_t disksize_show(struct device *dev,
+		struct device_attribute *attr, char *buf)
+{
+	struct zram *zram = dev_to_zram(dev);
+
+	return sprintf(buf, "%llu\n", zram->disksize);
+}
+
+static ssize_t initstate_show(struct device *dev,
+		struct device_attribute *attr, char *buf)
+{
+	struct zram *zram = dev_to_zram(dev);
+
+	return sprintf(buf, "%u\n", zram->init_done);
+}
+
+static ssize_t num_reads_show(struct device *dev,
+		struct device_attribute *attr, char *buf)
+{
+	struct zram *zram = dev_to_zram(dev);
+
+	return sprintf(buf, "%llu\n",
+		zram_stat64_read(zram, &zram->stats.num_reads));
+}
+
+static ssize_t num_writes_show(struct device *dev,
+		struct device_attribute *attr, char *buf)
+{
+	struct zram *zram = dev_to_zram(dev);
+
+	return sprintf(buf, "%llu\n",
+		zram_stat64_read(zram, &zram->stats.num_writes));
+}
+
+static ssize_t invalid_io_show(struct device *dev,
+		struct device_attribute *attr, char *buf)
+{
+	struct zram *zram = dev_to_zram(dev);
+
+	return sprintf(buf, "%llu\n",
+		zram_stat64_read(zram, &zram->stats.invalid_io));
+}
+
+static ssize_t notify_free_show(struct device *dev,
+		struct device_attribute *attr, char *buf)
+{
+	struct zram *zram = dev_to_zram(dev);
+
+	return sprintf(buf, "%llu\n",
+		zram_stat64_read(zram, &zram->stats.notify_free));
+}
+
+static ssize_t zero_pages_show(struct device *dev,
+		struct device_attribute *attr, char *buf)
+{
+	struct zram *zram = dev_to_zram(dev);
+
+	return sprintf(buf, "%u\n", zram->stats.pages_zero);
+}
+
+static ssize_t orig_data_size_show(struct device *dev,
+		struct device_attribute *attr, char *buf)
+{
+	struct zram *zram = dev_to_zram(dev);
+
+	return sprintf(buf, "%llu\n",
+		(u64)(zram->stats.pages_stored) << PAGE_SHIFT);
+}
+
+static ssize_t compr_data_size_show(struct device *dev,
+		struct device_attribute *attr, char *buf)
+{
+	struct zram *zram = dev_to_zram(dev);
+
+	return sprintf(buf, "%llu\n",
+		zram_stat64_read(zram, &zram->stats.compr_size));
+}
+
+static ssize_t mem_used_total_show(struct device *dev,
+		struct device_attribute *attr, char *buf)
+{
+	u64 val = 0;
+	struct zram *zram = dev_to_zram(dev);
+	struct zram_meta *meta = zram->meta;
+
+	if (zram->init_done)
+		val = zs_get_total_size_bytes(meta->mem_pool);
+
+	return sprintf(buf, "%llu\n", val);
+}
+
 static int zram_test_flag(struct zram_meta *meta, u32 index,
 			enum zram_pageflags flag)
 {
@@ -79,6 +201,176 @@ static void zram_clear_flag(struct zram_meta *meta, u32 index,
 	meta->table[index].flags &= ~BIT(flag);
 }
 
+static void zram_meta_free(struct zram_meta *meta)
+{
+	zs_destroy_pool(meta->mem_pool);
+	kfree(meta->compress_workmem);
+	free_pages((unsigned long)meta->compress_buffer, 1);
+	vfree(meta->table);
+	kfree(meta);
+}
+
+static struct zram_meta *zram_meta_alloc(u64 disksize)
+{
+	size_t num_pages;
+	struct zram_meta *meta = kmalloc(sizeof(*meta), GFP_KERNEL);
+	if (!meta)
+		goto out;
+
+	meta->compress_workmem = kzalloc(LZO1X_MEM_COMPRESS, GFP_KERNEL);
+	if (!meta->compress_workmem)
+		goto free_meta;
+
+	meta->compress_buffer =
+		(void *)__get_free_pages(GFP_KERNEL | __GFP_ZERO, 1);
+	if (!meta->compress_buffer) {
+		pr_err("Error allocating compressor buffer space\n");
+		goto free_workmem;
+	}
+
+	num_pages = disksize >> PAGE_SHIFT;
+	meta->table = vzalloc(num_pages * sizeof(*meta->table));
+	if (!meta->table) {
+		pr_err("Error allocating zram address table\n");
+		goto free_buffer;
+	}
+
+	meta->mem_pool = zs_create_pool(GFP_NOIO | __GFP_HIGHMEM);
+	if (!meta->mem_pool) {
+		pr_err("Error creating memory pool\n");
+		goto free_table;
+	}
+
+	return meta;
+
+free_table:
+	vfree(meta->table);
+free_buffer:
+	free_pages((unsigned long)meta->compress_buffer, 1);
+free_workmem:
+	kfree(meta->compress_workmem);
+free_meta:
+	kfree(meta);
+	meta = NULL;
+out:
+	return meta;
+}
+
+static void zram_reset_device(struct zram *zram)
+{
+	size_t index;
+	struct zram_meta *meta;
+
+	down_write(&zram->init_lock);
+	if (!zram->init_done)
+		return;
+
+	meta = zram->meta;
+	zram->init_done = 0;
+
+	/* Free all pages that are still in this zram device */
+	for (index = 0; index < zram->disksize >> PAGE_SHIFT; index++) {
+		unsigned long handle = meta->table[index].handle;
+		if (!handle)
+			continue;
+
+		zs_free(meta->mem_pool, handle);
+	}
+
+	zram_meta_free(zram->meta);
+	zram->meta = NULL;
+	/* Reset stats */
+	memset(&zram->stats, 0, sizeof(zram->stats));
+
+	zram->disksize = 0;
+	set_capacity(zram->disk, 0);
+	up_write(&zram->init_lock);
+}
+
+static void zram_init_device(struct zram *zram, struct zram_meta *meta)
+{
+	if (zram->disksize > 2 * (totalram_pages << PAGE_SHIFT)) {
+		pr_info(
+		"There is little point creating a zram of greater than "
+		"twice the size of memory since we expect a 2:1 compression "
+		"ratio. Note that zram uses about 0.1%% of the size of "
+		"the disk when not in use so a huge zram is "
+		"wasteful.\n"
+		"\tMemory Size: %lu kB\n"
+		"\tSize you selected: %llu kB\n"
+		"Continuing anyway ...\n",
+		(totalram_pages << PAGE_SHIFT) >> 10, zram->disksize >> 10
+		);
+	}
+
+	/* zram devices sort of resembles non-rotational disks */
+	queue_flag_set_unlocked(QUEUE_FLAG_NONROT, zram->disk->queue);
+
+	zram->meta = meta;
+	zram->init_done = 1;
+
+	pr_debug("Initialization done!\n");
+}
+
+static ssize_t disksize_store(struct device *dev,
+		struct device_attribute *attr, const char *buf, size_t len)
+{
+	u64 disksize;
+	struct zram_meta *meta;
+	struct zram *zram = dev_to_zram(dev);
+
+	disksize = memparse(buf, NULL);
+	if (!disksize)
+		return -EINVAL;
+
+	disksize = PAGE_ALIGN(disksize);
+	meta = zram_meta_alloc(disksize);
+	down_write(&zram->init_lock);
+	if (zram->init_done) {
+		up_write(&zram->init_lock);
+		zram_meta_free(meta);
+		pr_info("Cannot change disksize for initialized device\n");
+		return -EBUSY;
+	}
+
+	zram->disksize = disksize;
+	set_capacity(zram->disk, zram->disksize >> SECTOR_SHIFT);
+	zram_init_device(zram, meta);
+	up_write(&zram->init_lock);
+
+	return len;
+}
+
+static ssize_t reset_store(struct device *dev,
+		struct device_attribute *attr, const char *buf, size_t len)
+{
+	int ret;
+	unsigned short do_reset;
+	struct zram *zram;
+	struct block_device *bdev;
+
+	zram = dev_to_zram(dev);
+	bdev = bdget_disk(zram->disk, 0);
+
+	/* Do not reset an active device! */
+	if (bdev->bd_holders)
+		return -EBUSY;
+
+	ret = kstrtou16(buf, 10, &do_reset);
+	if (ret)
+		return ret;
+
+	if (!do_reset)
+		return -EINVAL;
+
+	/* Make sure all pending I/O is finished */
+	if (bdev)
+		fsync_bdev(bdev);
+
+	zram_reset_device(zram);
+	return len;
+}
+
 static int page_zero_filled(void *ptr)
 {
 	unsigned int pos;
@@ -460,122 +752,6 @@ error:
 	bio_io_error(bio);
 }
 
-static void __zram_reset_device(struct zram *zram)
-{
-	size_t index;
-	struct zram_meta *meta;
-
-	if (!zram->init_done)
-		return;
-
-	meta = zram->meta;
-	zram->init_done = 0;
-
-	/* Free all pages that are still in this zram device */
-	for (index = 0; index < zram->disksize >> PAGE_SHIFT; index++) {
-		unsigned long handle = meta->table[index].handle;
-		if (!handle)
-			continue;
-
-		zs_free(meta->mem_pool, handle);
-	}
-
-	zram_meta_free(zram->meta);
-	zram->meta = NULL;
-	/* Reset stats */
-	memset(&zram->stats, 0, sizeof(zram->stats));
-
-	zram->disksize = 0;
-	set_capacity(zram->disk, 0);
-}
-
-void zram_reset_device(struct zram *zram)
-{
-	down_write(&zram->init_lock);
-	__zram_reset_device(zram);
-	up_write(&zram->init_lock);
-}
-
-void zram_meta_free(struct zram_meta *meta)
-{
-	zs_destroy_pool(meta->mem_pool);
-	kfree(meta->compress_workmem);
-	free_pages((unsigned long)meta->compress_buffer, 1);
-	vfree(meta->table);
-	kfree(meta);
-}
-
-struct zram_meta *zram_meta_alloc(u64 disksize)
-{
-	size_t num_pages;
-	struct zram_meta *meta = kmalloc(sizeof(*meta), GFP_KERNEL);
-	if (!meta)
-		goto out;
-
-	meta->compress_workmem = kzalloc(LZO1X_MEM_COMPRESS, GFP_KERNEL);
-	if (!meta->compress_workmem)
-		goto free_meta;
-
-	meta->compress_buffer =
-		(void *)__get_free_pages(GFP_KERNEL | __GFP_ZERO, 1);
-	if (!meta->compress_buffer) {
-		pr_err("Error allocating compressor buffer space\n");
-		goto free_workmem;
-	}
-
-	num_pages = disksize >> PAGE_SHIFT;
-	meta->table = vzalloc(num_pages * sizeof(*meta->table));
-	if (!meta->table) {
-		pr_err("Error allocating zram address table\n");
-		goto free_buffer;
-	}
-
-	meta->mem_pool = zs_create_pool(GFP_NOIO | __GFP_HIGHMEM);
-	if (!meta->mem_pool) {
-		pr_err("Error creating memory pool\n");
-		goto free_table;
-	}
-
-	return meta;
-
-free_table:
-	vfree(meta->table);
-free_buffer:
-	free_pages((unsigned long)meta->compress_buffer, 1);
-free_workmem:
-	kfree(meta->compress_workmem);
-free_meta:
-	kfree(meta);
-	meta = NULL;
-out:
-	return meta;
-}
-
-void zram_init_device(struct zram *zram, struct zram_meta *meta)
-{
-	if (zram->disksize > 2 * (totalram_pages << PAGE_SHIFT)) {
-		pr_info(
-		"There is little point creating a zram of greater than "
-		"twice the size of memory since we expect a 2:1 compression "
-		"ratio. Note that zram uses about 0.1%% of the size of "
-		"the disk when not in use so a huge zram is "
-		"wasteful.\n"
-		"\tMemory Size: %lu kB\n"
-		"\tSize you selected: %llu kB\n"
-		"Continuing anyway ...\n",
-		(totalram_pages << PAGE_SHIFT) >> 10, zram->disksize >> 10
-		);
-	}
-
-	/* zram devices sort of resembles non-rotational disks */
-	queue_flag_set_unlocked(QUEUE_FLAG_NONROT, zram->disk->queue);
-
-	zram->meta = meta;
-	zram->init_done = 1;
-
-	pr_debug("Initialization done!\n");
-}
-
 static void zram_slot_free_notify(struct block_device *bdev,
 				unsigned long index)
 {
@@ -586,6 +762,38 @@ static void zram_slot_free_notify(struct block_device *bdev,
 	zram_stat64_inc(zram, &zram->stats.notify_free);
 }
 
+static DEVICE_ATTR(disksize, S_IRUGO | S_IWUSR,
+		disksize_show, disksize_store);
+static DEVICE_ATTR(initstate, S_IRUGO, initstate_show, NULL);
+static DEVICE_ATTR(reset, S_IWUSR, NULL, reset_store);
+static DEVICE_ATTR(num_reads, S_IRUGO, num_reads_show, NULL);
+static DEVICE_ATTR(num_writes, S_IRUGO, num_writes_show, NULL);
+static DEVICE_ATTR(invalid_io, S_IRUGO, invalid_io_show, NULL);
+static DEVICE_ATTR(notify_free, S_IRUGO, notify_free_show, NULL);
+static DEVICE_ATTR(zero_pages, S_IRUGO, zero_pages_show, NULL);
+static DEVICE_ATTR(orig_data_size, S_IRUGO, orig_data_size_show, NULL);
+static DEVICE_ATTR(compr_data_size, S_IRUGO, compr_data_size_show, NULL);
+static DEVICE_ATTR(mem_used_total, S_IRUGO, mem_used_total_show, NULL);
+
+static struct attribute *zram_disk_attrs[] = {
+	&dev_attr_disksize.attr,
+	&dev_attr_initstate.attr,
+	&dev_attr_reset.attr,
+	&dev_attr_num_reads.attr,
+	&dev_attr_num_writes.attr,
+	&dev_attr_invalid_io.attr,
+	&dev_attr_notify_free.attr,
+	&dev_attr_zero_pages.attr,
+	&dev_attr_orig_data_size.attr,
+	&dev_attr_compr_data_size.attr,
+	&dev_attr_mem_used_total.attr,
+	NULL,
+};
+
+static struct attribute_group zram_disk_attr_group = {
+	.attrs = zram_disk_attrs,
+};
+
 static const struct block_device_operations zram_devops = {
 	.swap_slot_free_notify = zram_slot_free_notify,
 	.owner = THIS_MODULE
@@ -669,11 +877,6 @@ static void destroy_device(struct zram *zram)
 		blk_cleanup_queue(zram->queue);
 }
 
-unsigned int zram_get_num_devices(void)
-{
-	return num_devices;
-}
-
 static int __init zram_init(void)
 {
 	int ret, dev_id;
@@ -737,12 +940,5 @@ static void __exit zram_exit(void)
 	pr_debug("Cleanup done!\n");
 }
 
-module_param(num_devices, uint, 0);
-MODULE_PARM_DESC(num_devices, "Number of zram devices");
-
 module_init(zram_init);
 module_exit(zram_exit);
-
-MODULE_LICENSE("Dual BSD/GPL");
-MODULE_AUTHOR("Nitin Gupta <ngupta@vflare.org>");
-MODULE_DESCRIPTION("Compressed RAM Block Device");
diff --git a/drivers/staging/zram/zram_drv.h b/drivers/staging/zram/zram_drv.h
index 2d1a3f1..dc1661b 100644
--- a/drivers/staging/zram/zram_drv.h
+++ b/drivers/staging/zram/zram_drv.h
@@ -108,16 +108,4 @@ struct zram {
 
 	struct zram_stats stats;
 };
-
-extern struct zram *zram_devices;
-unsigned int zram_get_num_devices(void);
-#ifdef CONFIG_SYSFS
-extern struct attribute_group zram_disk_attr_group;
-#endif
-
-extern void zram_reset_device(struct zram *zram);
-extern struct zram_meta *zram_meta_alloc(u64 disksize);
-extern void zram_meta_free(struct zram_meta *meta);
-extern void zram_init_device(struct zram *zram, struct zram_meta *meta);
-
 #endif
diff --git a/drivers/staging/zram/zram_sysfs.c b/drivers/staging/zram/zram_sysfs.c
deleted file mode 100644
index e6a929d..0000000
--- a/drivers/staging/zram/zram_sysfs.c
+++ /dev/null
@@ -1,227 +0,0 @@
-/*
- * Compressed RAM block device
- *
- * Copyright (C) 2008, 2009, 2010  Nitin Gupta
- *
- * This code is released using a dual license strategy: BSD/GPL
- * You can choose the licence that better fits your requirements.
- *
- * Released under the terms of 3-clause BSD License
- * Released under the terms of GNU General Public License Version 2.0
- *
- * Project home: http://compcache.googlecode.com/
- */
-
-#include <linux/device.h>
-#include <linux/genhd.h>
-#include <linux/mm.h>
-#include <linux/kernel.h>
-
-#include "zram_drv.h"
-
-static u64 zram_stat64_read(struct zram *zram, u64 *v)
-{
-	u64 val;
-
-	spin_lock(&zram->stat64_lock);
-	val = *v;
-	spin_unlock(&zram->stat64_lock);
-
-	return val;
-}
-
-static struct zram *dev_to_zram(struct device *dev)
-{
-	int i;
-	struct zram *zram = NULL;
-
-	for (i = 0; i < zram_get_num_devices(); i++) {
-		zram = &zram_devices[i];
-		if (disk_to_dev(zram->disk) == dev)
-			break;
-	}
-
-	return zram;
-}
-
-static ssize_t disksize_show(struct device *dev,
-		struct device_attribute *attr, char *buf)
-{
-	struct zram *zram = dev_to_zram(dev);
-
-	return sprintf(buf, "%llu\n", zram->disksize);
-}
-
-static ssize_t disksize_store(struct device *dev,
-		struct device_attribute *attr, const char *buf, size_t len)
-{
-	u64 disksize;
-	struct zram_meta *meta;
-	struct zram *zram = dev_to_zram(dev);
-
-	disksize = memparse(buf, NULL);
-	if (!disksize)
-		return -EINVAL;
-
-	disksize = PAGE_ALIGN(disksize);
-	meta = zram_meta_alloc(disksize);
-	down_write(&zram->init_lock);
-	if (zram->init_done) {
-		up_write(&zram->init_lock);
-		zram_meta_free(meta);
-		pr_info("Cannot change disksize for initialized device\n");
-		return -EBUSY;
-	}
-
-	zram->disksize = disksize;
-	set_capacity(zram->disk, zram->disksize >> SECTOR_SHIFT);
-	zram_init_device(zram, meta);
-	up_write(&zram->init_lock);
-
-	return len;
-}
-
-static ssize_t initstate_show(struct device *dev,
-		struct device_attribute *attr, char *buf)
-{
-	struct zram *zram = dev_to_zram(dev);
-
-	return sprintf(buf, "%u\n", zram->init_done);
-}
-
-static ssize_t reset_store(struct device *dev,
-		struct device_attribute *attr, const char *buf, size_t len)
-{
-	int ret;
-	unsigned short do_reset;
-	struct zram *zram;
-	struct block_device *bdev;
-
-	zram = dev_to_zram(dev);
-	bdev = bdget_disk(zram->disk, 0);
-
-	/* Do not reset an active device! */
-	if (bdev->bd_holders)
-		return -EBUSY;
-
-	ret = kstrtou16(buf, 10, &do_reset);
-	if (ret)
-		return ret;
-
-	if (!do_reset)
-		return -EINVAL;
-
-	/* Make sure all pending I/O is finished */
-	if (bdev)
-		fsync_bdev(bdev);
-
-	zram_reset_device(zram);
-	return len;
-}
-
-static ssize_t num_reads_show(struct device *dev,
-		struct device_attribute *attr, char *buf)
-{
-	struct zram *zram = dev_to_zram(dev);
-
-	return sprintf(buf, "%llu\n",
-		zram_stat64_read(zram, &zram->stats.num_reads));
-}
-
-static ssize_t num_writes_show(struct device *dev,
-		struct device_attribute *attr, char *buf)
-{
-	struct zram *zram = dev_to_zram(dev);
-
-	return sprintf(buf, "%llu\n",
-		zram_stat64_read(zram, &zram->stats.num_writes));
-}
-
-static ssize_t invalid_io_show(struct device *dev,
-		struct device_attribute *attr, char *buf)
-{
-	struct zram *zram = dev_to_zram(dev);
-
-	return sprintf(buf, "%llu\n",
-		zram_stat64_read(zram, &zram->stats.invalid_io));
-}
-
-static ssize_t notify_free_show(struct device *dev,
-		struct device_attribute *attr, char *buf)
-{
-	struct zram *zram = dev_to_zram(dev);
-
-	return sprintf(buf, "%llu\n",
-		zram_stat64_read(zram, &zram->stats.notify_free));
-}
-
-static ssize_t zero_pages_show(struct device *dev,
-		struct device_attribute *attr, char *buf)
-{
-	struct zram *zram = dev_to_zram(dev);
-
-	return sprintf(buf, "%u\n", zram->stats.pages_zero);
-}
-
-static ssize_t orig_data_size_show(struct device *dev,
-		struct device_attribute *attr, char *buf)
-{
-	struct zram *zram = dev_to_zram(dev);
-
-	return sprintf(buf, "%llu\n",
-		(u64)(zram->stats.pages_stored) << PAGE_SHIFT);
-}
-
-static ssize_t compr_data_size_show(struct device *dev,
-		struct device_attribute *attr, char *buf)
-{
-	struct zram *zram = dev_to_zram(dev);
-
-	return sprintf(buf, "%llu\n",
-		zram_stat64_read(zram, &zram->stats.compr_size));
-}
-
-static ssize_t mem_used_total_show(struct device *dev,
-		struct device_attribute *attr, char *buf)
-{
-	u64 val = 0;
-	struct zram *zram = dev_to_zram(dev);
-	struct zram_meta *meta = zram->meta;
-
-	if (zram->init_done)
-		val = zs_get_total_size_bytes(meta->mem_pool);
-
-	return sprintf(buf, "%llu\n", val);
-}
-
-static DEVICE_ATTR(disksize, S_IRUGO | S_IWUSR,
-		disksize_show, disksize_store);
-static DEVICE_ATTR(initstate, S_IRUGO, initstate_show, NULL);
-static DEVICE_ATTR(reset, S_IWUSR, NULL, reset_store);
-static DEVICE_ATTR(num_reads, S_IRUGO, num_reads_show, NULL);
-static DEVICE_ATTR(num_writes, S_IRUGO, num_writes_show, NULL);
-static DEVICE_ATTR(invalid_io, S_IRUGO, invalid_io_show, NULL);
-static DEVICE_ATTR(notify_free, S_IRUGO, notify_free_show, NULL);
-static DEVICE_ATTR(zero_pages, S_IRUGO, zero_pages_show, NULL);
-static DEVICE_ATTR(orig_data_size, S_IRUGO, orig_data_size_show, NULL);
-static DEVICE_ATTR(compr_data_size, S_IRUGO, compr_data_size_show, NULL);
-static DEVICE_ATTR(mem_used_total, S_IRUGO, mem_used_total_show, NULL);
-
-static struct attribute *zram_disk_attrs[] = {
-	&dev_attr_disksize.attr,
-	&dev_attr_initstate.attr,
-	&dev_attr_reset.attr,
-	&dev_attr_num_reads.attr,
-	&dev_attr_num_writes.attr,
-	&dev_attr_invalid_io.attr,
-	&dev_attr_notify_free.attr,
-	&dev_attr_zero_pages.attr,
-	&dev_attr_orig_data_size.attr,
-	&dev_attr_compr_data_size.attr,
-	&dev_attr_mem_used_total.attr,
-	NULL,
-};
-
-struct attribute_group zram_disk_attr_group = {
-	.attrs = zram_disk_attrs,
-};

