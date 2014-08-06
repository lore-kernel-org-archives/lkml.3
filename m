Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755870AbaHFL3f (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Aug 2014 07:29:35 -0400
Received: from mail-wi0-f180.google.com ([209.85.212.180]:38373 "EHLO
	mail-wi0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755540AbaHFL3d (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Aug 2014 07:29:33 -0400
Message-ID: <53E2119A.2090803@plexistor.com>
Date: Wed, 06 Aug 2014 14:29:30 +0300
From: Boaz Harrosh <boaz@plexistor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.7.0
MIME-Version: 1.0
To: Jens Axboe <axboe@kernel.dk>, Ross Zwisler <ross.zwisler@linux.intel.com>,
        Matthew Wilcox <willy@linux.intel.com>,
        linux-kernel <linux-kernel@vger.kernel.org>
CC: linux-fsdevel <linux-fsdevel@vger.kernel.org>
Subject: [PATCH 1/4] Change direct_access calling convention
References: <53E21125.9080308@plexistor.com>
In-Reply-To: <53E21125.9080308@plexistor.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Matthew Wilcox <matthew.r.wilcox@intel.com>

In order to support accesses to larger chunks of memory, pass in a
'size' parameter (counted in bytes), and return the amount available at
that address.

Add a new helper function, bdev_direct_access(), to handle common
functionality including partition handling, checking for the sector
being page-aligned, and checking the length of the request does not
pass the end of the partition.

[Boaz] checkpatch fixes, add prints.

Signed-off-by: Matthew Wilcox <matthew.r.wilcox@intel.com>
Reviewed-by: Jan Kara <jack@suse.cz>
Signed-off-by: Boaz Harrosh <boaz@plexistor.com>
---
 Documentation/filesystems/xip.txt | 15 ++++++++------
 arch/powerpc/sysdev/axonram.c     | 17 ++++------------
 drivers/block/brd.c               | 12 +++++------
 drivers/s390/block/dcssblk.c      | 21 ++++++++-----------
 fs/block_dev.c                    | 43 +++++++++++++++++++++++++++++++++++++++
 fs/ext2/xip.c                     | 30 ++++++++++++---------------
 include/linux/blkdev.h            |  6 ++++--
 7 files changed, 87 insertions(+), 57 deletions(-)

diff --git a/Documentation/filesystems/xip.txt b/Documentation/filesystems/xip.txt
index 0466ee5..b62eabf 100644
--- a/Documentation/filesystems/xip.txt
+++ b/Documentation/filesystems/xip.txt
@@ -28,12 +28,15 @@ Implementation
 Execute-in-place is implemented in three steps: block device operation,
 address space operation, and file operations.
 
-A block device operation named direct_access is used to retrieve a
-reference (pointer) to a block on-disk. The reference is supposed to be
-cpu-addressable, physical address and remain valid until the release operation
-is performed. A struct block_device reference is used to address the device,
-and a sector_t argument is used to identify the individual block. As an
-alternative, memory technology devices can be used for this.
+A block device operation named direct_access is used to translate the
+block device sector number to a page frame number (pfn) that identifies
+the physical page for the memory.  It also returns a kernel virtual
+address that can be used to access the memory.
+
+The direct_access method takes a 'size' parameter that indicates the
+number of bytes being requested.  The function should return the number
+of bytes that it can provide, although it must not exceed the number of
+bytes requested.  It may also return a negative errno if an error occurs.
 
 The block device operation is optional, these block devices support it as of
 today:
diff --git a/arch/powerpc/sysdev/axonram.c b/arch/powerpc/sysdev/axonram.c
index 47b6b9f..142892b 100644
--- a/arch/powerpc/sysdev/axonram.c
+++ b/arch/powerpc/sysdev/axonram.c
@@ -139,26 +139,17 @@ axon_ram_make_request(struct request_queue *queue, struct bio *bio)
  * axon_ram_direct_access - direct_access() method for block device
  * @device, @sector, @data: see block_device_operations method
  */
-static int
+static long
 axon_ram_direct_access(struct block_device *device, sector_t sector,
-		       void **kaddr, unsigned long *pfn)
+		       void **kaddr, unsigned long *pfn, long size)
 {
 	struct axon_ram_bank *bank = device->bd_disk->private_data;
-	loff_t offset;
-
-	offset = sector;
-	if (device->bd_part != NULL)
-		offset += device->bd_part->start_sect;
-	offset <<= AXON_RAM_SECTOR_SHIFT;
-	if (offset >= bank->size) {
-		dev_err(&bank->device->dev, "Access outside of address space\n");
-		return -ERANGE;
-	}
+	loff_t offset = (loff_t)sector << AXON_RAM_SECTOR_SHIFT;
 
 	*kaddr = (void *)(bank->ph_addr + offset);
 	*pfn = virt_to_phys(kaddr) >> PAGE_SHIFT;
 
-	return 0;
+	return min_t(long, size, bank->size - offset);
 }
 
 static const struct block_device_operations axon_ram_devops = {
diff --git a/drivers/block/brd.c b/drivers/block/brd.c
index c7d138e..a10a0a9 100644
--- a/drivers/block/brd.c
+++ b/drivers/block/brd.c
@@ -370,25 +370,23 @@ static int brd_rw_page(struct block_device *bdev, sector_t sector,
 }
 
 #ifdef CONFIG_BLK_DEV_XIP
-static int brd_direct_access(struct block_device *bdev, sector_t sector,
-			void **kaddr, unsigned long *pfn)
+static long brd_direct_access(struct block_device *bdev, sector_t sector,
+			void **kaddr, unsigned long *pfn, long size)
 {
 	struct brd_device *brd = bdev->bd_disk->private_data;
 	struct page *page;
 
 	if (!brd)
 		return -ENODEV;
-	if (sector & (PAGE_SECTORS-1))
-		return -EINVAL;
-	if (sector + PAGE_SECTORS > get_capacity(bdev->bd_disk))
-		return -ERANGE;
 	page = brd_insert_page(brd, sector);
 	if (!page)
 		return -ENOSPC;
 	*kaddr = page_address(page);
 	*pfn = page_to_pfn(page);
 
-	return 0;
+	/* Could optimistically check to see if the next page in the
+	 * file is mapped to the next page of physical RAM */
+	return min_t(long, PAGE_SIZE, size);
 }
 #endif
 
diff --git a/drivers/s390/block/dcssblk.c b/drivers/s390/block/dcssblk.c
index 0f47175..2ee5556 100644
--- a/drivers/s390/block/dcssblk.c
+++ b/drivers/s390/block/dcssblk.c
@@ -28,8 +28,8 @@
 static int dcssblk_open(struct block_device *bdev, fmode_t mode);
 static void dcssblk_release(struct gendisk *disk, fmode_t mode);
 static void dcssblk_make_request(struct request_queue *q, struct bio *bio);
-static int dcssblk_direct_access(struct block_device *bdev, sector_t secnum,
-				 void **kaddr, unsigned long *pfn);
+static long dcssblk_direct_access(struct block_device *bdev, sector_t secnum,
+				 void **kaddr, unsigned long *pfn, long size);
 
 static char dcssblk_segments[DCSSBLK_PARM_LEN] = "\0";
 
@@ -866,25 +866,22 @@ fail:
 	bio_io_error(bio);
 }
 
-static int
+static long
 dcssblk_direct_access (struct block_device *bdev, sector_t secnum,
-			void **kaddr, unsigned long *pfn)
+			void **kaddr, unsigned long *pfn, long size)
 {
 	struct dcssblk_dev_info *dev_info;
-	unsigned long pgoff;
+	unsigned long offset, dev_sz;
 
 	dev_info = bdev->bd_disk->private_data;
 	if (!dev_info)
 		return -ENODEV;
-	if (secnum % (PAGE_SIZE/512))
-		return -EINVAL;
-	pgoff = secnum / (PAGE_SIZE / 512);
-	if ((pgoff+1)*PAGE_SIZE-1 > dev_info->end - dev_info->start)
-		return -ERANGE;
-	*kaddr = (void *) (dev_info->start+pgoff*PAGE_SIZE);
+	dev_sz = dev_info->end - dev_info->start;
+	offset = secnum * 512;
+	*kaddr = (void *) (dev_info->start + offset);
 	*pfn = virt_to_phys(*kaddr) >> PAGE_SHIFT;
 
-	return 0;
+	return min_t(long, size, dev_sz - offset);
 }
 
 static void
diff --git a/fs/block_dev.c b/fs/block_dev.c
index 6d72746..002d5d6 100644
--- a/fs/block_dev.c
+++ b/fs/block_dev.c
@@ -427,6 +427,49 @@ int bdev_write_page(struct block_device *bdev, sector_t sector,
 }
 EXPORT_SYMBOL_GPL(bdev_write_page);
 
+/**
+ * bdev_direct_access() - Get the address for directly-accessibly memory
+ * @bdev: The device containing the memory
+ * @sector: The offset within the device
+ * @addr: Where to put the address of the memory
+ * @pfn: The Page Frame Number for the memory
+ * @size: The number of bytes requested
+ *
+ * If a block device is made up of directly addressable memory, this function
+ * will tell the caller the PFN and the address of the memory.  The address
+ * may be directly dereferenced within the kernel without the need to call
+ * ioremap(), kmap() or similar.  THe PFN is suitable for inserting into
+ * page tables.
+ *
+ * Return: negative errno if an error occurs, otherwise the number of bytes
+ * accessible at this address.
+ */
+long bdev_direct_access(struct block_device *bdev, sector_t sector,
+			void **addr, unsigned long *pfn, long size)
+{
+	const struct block_device_operations *ops = bdev->bd_disk->fops;
+
+	if (!ops->direct_access)
+		return -EOPNOTSUPP;
+	if ((sector + DIV_ROUND_UP(size, 512)) >
+					part_nr_sects_read(bdev->bd_part))
+		return -ERANGE;
+	sector += get_start_sect(bdev);
+	if (sector % (PAGE_SIZE / 512)) {
+		if (get_start_sect(bdev) % (PAGE_SIZE / 512)) {
+			pr_err_ratelimited(
+				"%s: [%s:%d,%d] partition not 4K aligned!!!\n",
+				__func__, bdev->bd_disk->disk_name,
+				MAJOR(bdev->bd_dev), MINOR(bdev->bd_dev));
+		}
+		return -EINVAL;
+	}
+
+	size = ops->direct_access(bdev, sector, addr, pfn, size);
+	return size ? size : -ERANGE;
+}
+EXPORT_SYMBOL_GPL(bdev_direct_access);
+
 /*
  * pseudo-fs
  */
diff --git a/fs/ext2/xip.c b/fs/ext2/xip.c
index e98171a..a4d5435 100644
--- a/fs/ext2/xip.c
+++ b/fs/ext2/xip.c
@@ -13,18 +13,13 @@
 #include "ext2.h"
 #include "xip.h"
 
-static inline int
-__inode_direct_access(struct inode *inode, sector_t block,
-		      void **kaddr, unsigned long *pfn)
+static inline long __inode_direct_access(struct inode *inode, sector_t block,
+				void **kaddr, unsigned long *pfn, long size)
 {
 	struct block_device *bdev = inode->i_sb->s_bdev;
-	const struct block_device_operations *ops = bdev->bd_disk->fops;
-	sector_t sector;
-
-	sector = block * (PAGE_SIZE / 512); /* ext2 block to bdev sector */
+	sector_t sector = block * (PAGE_SIZE / 512);
 
-	BUG_ON(!ops->direct_access);
-	return ops->direct_access(bdev, sector, kaddr, pfn);
+	return bdev_direct_access(bdev, sector, kaddr, pfn, size);
 }
 
 static inline int
@@ -53,12 +48,13 @@ ext2_clear_xip_target(struct inode *inode, sector_t block)
 {
 	void *kaddr;
 	unsigned long pfn;
-	int rc;
+	long size;
 
-	rc = __inode_direct_access(inode, block, &kaddr, &pfn);
-	if (!rc)
-		clear_page(kaddr);
-	return rc;
+	size = __inode_direct_access(inode, block, &kaddr, &pfn, PAGE_SIZE);
+	if (size < 0)
+		return size;
+	clear_page(kaddr);
+	return 0;
 }
 
 void ext2_xip_verify_sb(struct super_block *sb)
@@ -77,7 +73,7 @@ void ext2_xip_verify_sb(struct super_block *sb)
 int ext2_get_xip_mem(struct address_space *mapping, pgoff_t pgoff, int create,
 				void **kmem, unsigned long *pfn)
 {
-	int rc;
+	long rc;
 	sector_t block;
 
 	/* first, retrieve the sector number */
@@ -86,6 +82,6 @@ int ext2_get_xip_mem(struct address_space *mapping, pgoff_t pgoff, int create,
 		return rc;
 
 	/* retrieve address of the target data */
-	rc = __inode_direct_access(mapping->host, block, kmem, pfn);
-	return rc;
+	rc = __inode_direct_access(mapping->host, block, kmem, pfn, PAGE_SIZE);
+	return (rc < 0) ? rc : 0;
 }
diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
index 8699bcf..bc5ea9e 100644
--- a/include/linux/blkdev.h
+++ b/include/linux/blkdev.h
@@ -1613,8 +1613,8 @@ struct block_device_operations {
 	int (*rw_page)(struct block_device *, sector_t, struct page *, int rw);
 	int (*ioctl) (struct block_device *, fmode_t, unsigned, unsigned long);
 	int (*compat_ioctl) (struct block_device *, fmode_t, unsigned, unsigned long);
-	int (*direct_access) (struct block_device *, sector_t,
-						void **, unsigned long *);
+	long (*direct_access) (struct block_device *, sector_t,
+					void **, unsigned long *pfn, long size);
 	unsigned int (*check_events) (struct gendisk *disk,
 				      unsigned int clearing);
 	/* ->media_changed() is DEPRECATED, use ->check_events() instead */
@@ -1632,6 +1632,8 @@ extern int __blkdev_driver_ioctl(struct block_device *, fmode_t, unsigned int,
 extern int bdev_read_page(struct block_device *, sector_t, struct page *);
 extern int bdev_write_page(struct block_device *, sector_t, struct page *,
 						struct writeback_control *);
+extern long bdev_direct_access(struct block_device *, sector_t, void **addr,
+						unsigned long *pfn, long size);
 #else /* CONFIG_BLOCK */
 
 struct block_device;
-- 
1.9.3


