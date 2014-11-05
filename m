Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755018AbaKEOE7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Nov 2014 09:04:59 -0500
Received: from mail-wi0-f170.google.com ([209.85.212.170]:37195 "EHLO
	mail-wi0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754866AbaKEOE4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Nov 2014 09:04:56 -0500
Message-ID: <545A2E84.5070307@plexistor.com>
Date: Wed, 05 Nov 2014 16:04:52 +0200
From: Boaz Harrosh <boaz@plexistor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: Jens Axboe <axboe@fb.com>, Matthew Wilcox <willy@linux.intel.com>,
        Dmitry Monakhov <dmonakhov@openvz.org>
CC: linux-kernel <linux-kernel@vger.kernel.org>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>
Subject: [PATCH 3/5] brd: Fix all partitions BUGs
References: <545A2D69.8090003@plexistor.com>
In-Reply-To: <545A2D69.8090003@plexistor.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Boaz Harrosh <boaz@plexistor.com>

This patch fixes up brd's partitions scheme, now enjoying all worlds.

The MAIN fix here is that currently, if one fdisks some partitions,
a BAD bug will make all partitions point to the same start-end sector
ie: 0 - brd_size And an mkfs of any partition would trash the partition
table and the other partition.

Another fix is that "mount -U uuid" will not work if show_part was not
specified, because of the GENHD_FL_SUPPRESS_PARTITION_INFO flag.
We now always load without it and remove the show_part parameter.

[We remove Dmitry's new module-param part_show it is now always
 show]

So NOW the logic goes like this:
* max_part - Just says how many minors to reserve between ramX
  devices. In any way, there can be as many partition as requested.
  If minors between devices ends, then dynamic 259-major ids will
  be allocated on the fly.
  The default is now max_part=1, which means all partitions devt(s)
  will be from the dynamic (259) major-range.
  (If persistent partition minors is needed use max_part=X)
  For example with /dev/sdX max_part is hard coded 16.

* Creation of new devices on the fly still/always work:
  mknod /path/devnod b 1 X
  fdisk -l /path/devnod
  Will create a new device if [X / max_part] was not already
  created before. (Just as before)

  partitions on the dynamically created device will work as well
  Same logic applies with minors as with the pre-created ones.

TODO: dynamic grow of device size. So each device can have it's
      own size.

CC: Dmitry Monakhov <dmonakhov@openvz.org>
Tested-by: Ross Zwisler <ross.zwisler@linux.intel.com>
Signed-off-by: Boaz Harrosh <boaz@plexistor.com>
---
 drivers/block/brd.c | 100 ++++++++++++++++++++--------------------------------
 1 file changed, 38 insertions(+), 62 deletions(-)

diff --git a/drivers/block/brd.c b/drivers/block/brd.c
index 89e90ec..a7463c959 100644
--- a/drivers/block/brd.c
+++ b/drivers/block/brd.c
@@ -438,19 +438,18 @@ static const struct block_device_operations brd_fops = {
 /*
  * And now the modules code and kernel interface.
  */
-static int rd_nr;
-int rd_size = CONFIG_BLK_DEV_RAM_SIZE;
-static int max_part;
-static int part_shift;
-static int part_show = 0;
+static int rd_nr = CONFIG_BLK_DEV_RAM_COUNT;
 module_param(rd_nr, int, S_IRUGO);
 MODULE_PARM_DESC(rd_nr, "Maximum number of brd devices");
+
+int rd_size = CONFIG_BLK_DEV_RAM_SIZE;
 module_param(rd_size, int, S_IRUGO);
 MODULE_PARM_DESC(rd_size, "Size of each RAM disk in kbytes.");
+
+static int max_part = 1;
 module_param(max_part, int, S_IRUGO);
-MODULE_PARM_DESC(max_part, "Maximum number of partitions per RAM disk");
-module_param(part_show, int, S_IRUGO);
-MODULE_PARM_DESC(part_show, "Control RAM disk visibility in /proc/partitions");
+MODULE_PARM_DESC(max_part, "Num Minors to reserve between devices");
+
 MODULE_LICENSE("GPL");
 MODULE_ALIAS_BLOCKDEV_MAJOR(RAMDISK_MAJOR);
 MODULE_ALIAS("rd");
@@ -496,16 +495,15 @@ static struct brd_device *brd_alloc(int i)
 	brd->brd_queue->limits.discard_zeroes_data = 1;
 	queue_flag_set_unlocked(QUEUE_FLAG_DISCARD, brd->brd_queue);
 
-	disk = brd->brd_disk = alloc_disk(1 << part_shift);
+	disk = brd->brd_disk = alloc_disk(max_part);
 	if (!disk)
 		goto out_free_queue;
 	disk->major		= RAMDISK_MAJOR;
-	disk->first_minor	= i << part_shift;
+	disk->first_minor	= i * max_part;
 	disk->fops		= &brd_fops;
 	disk->private_data	= brd;
 	disk->queue		= brd->brd_queue;
-	if (!part_show)
-		disk->flags |= GENHD_FL_SUPPRESS_PARTITION_INFO;
+	disk->flags		= GENHD_FL_EXT_DEVT;
 	sprintf(disk->disk_name, "ram%d", i);
 	set_capacity(disk, rd_size * 2);
 
@@ -527,10 +525,11 @@ static void brd_free(struct brd_device *brd)
 	kfree(brd);
 }
 
-static struct brd_device *brd_init_one(int i)
+static struct brd_device *brd_init_one(int i, bool *new)
 {
 	struct brd_device *brd;
 
+	*new = false;
 	list_for_each_entry(brd, &brd_devices, brd_list) {
 		if (brd->brd_number == i)
 			goto out;
@@ -541,6 +540,7 @@ static struct brd_device *brd_init_one(int i)
 		add_disk(brd->brd_disk);
 		list_add_tail(&brd->brd_list, &brd_devices);
 	}
+	*new = true;
 out:
 	return brd;
 }
@@ -556,70 +556,46 @@ static struct kobject *brd_probe(dev_t dev, int *part, void *data)
 {
 	struct brd_device *brd;
 	struct kobject *kobj;
+	bool new;
 
 	mutex_lock(&brd_devices_mutex);
-	brd = brd_init_one(MINOR(dev) >> part_shift);
+	brd = brd_init_one(MINOR(dev) / max_part, &new);
 	kobj = brd ? get_disk(brd->brd_disk) : NULL;
 	mutex_unlock(&brd_devices_mutex);
 
-	*part = 0;
+	if (new)
+		*part = 0;
+
 	return kobj;
 }
 
 static int __init brd_init(void)
 {
-	int i, nr;
-	unsigned long range;
 	struct brd_device *brd, *next;
+	int i;
 
 	/*
 	 * brd module now has a feature to instantiate underlying device
 	 * structure on-demand, provided that there is an access dev node.
-	 * However, this will not work well with user space tool that doesn't
-	 * know about such "feature".  In order to not break any existing
-	 * tool, we do the following:
 	 *
-	 * (1) if rd_nr is specified, create that many upfront, and this
-	 *     also becomes a hard limit.
-	 * (2) if rd_nr is not specified, create CONFIG_BLK_DEV_RAM_COUNT
-	 *     (default 16) rd device on module load, user can further
-	 *     extend brd device by create dev node themselves and have
-	 *     kernel automatically instantiate actual device on-demand.
+	 * (1) if rd_nr is specified, create that many upfront. else
+	 *     it defaults to CONFIG_BLK_DEV_RAM_COUNT
+	 * (2) User can further extend brd devices by create dev node themselves
+	 *     and have kernel automatically instantiate actual device
+	 *     on-demand. Example:
+	 *		mknod /path/devnod_name b 1 X	# 1 is the rd major
+	 *		fdisk -l /path/devnod_name
+	 *	If (X / max_part) was not already created it will be created
+	 *	dynamically.
 	 */
 
-	part_shift = 0;
-	if (max_part > 0) {
-		part_shift = fls(max_part);
-
-		/*
-		 * Adjust max_part according to part_shift as it is exported
-		 * to user space so that user can decide correct minor number
-		 * if [s]he want to create more devices.
-		 *
-		 * Note that -1 is required because partition 0 is reserved
-		 * for the whole disk.
-		 */
-		max_part = (1UL << part_shift) - 1;
-	}
-
-	if ((1UL << part_shift) > DISK_MAX_PARTS)
-		return -EINVAL;
-
-	if (rd_nr > 1UL << (MINORBITS - part_shift))
-		return -EINVAL;
-
-	if (rd_nr) {
-		nr = rd_nr;
-		range = rd_nr << part_shift;
-	} else {
-		nr = CONFIG_BLK_DEV_RAM_COUNT;
-		range = 1UL << MINORBITS;
-	}
-
 	if (register_blkdev(RAMDISK_MAJOR, "ramdisk"))
 		return -EIO;
 
-	for (i = 0; i < nr; i++) {
+	if (unlikely(!max_part))
+		max_part = 1;
+
+	for (i = 0; i < rd_nr; i++) {
 		brd = brd_alloc(i);
 		if (!brd)
 			goto out_free;
@@ -631,10 +607,10 @@ static int __init brd_init(void)
 	list_for_each_entry(brd, &brd_devices, brd_list)
 		add_disk(brd->brd_disk);
 
-	blk_register_region(MKDEV(RAMDISK_MAJOR, 0), range,
+	blk_register_region(MKDEV(RAMDISK_MAJOR, 0), 1UL << MINORBITS,
 				  THIS_MODULE, brd_probe, NULL, NULL);
 
-	printk(KERN_INFO "brd: module loaded\n");
+	pr_info("brd: module loaded\n");
 	return 0;
 
 out_free:
@@ -644,21 +620,21 @@ out_free:
 	}
 	unregister_blkdev(RAMDISK_MAJOR, "ramdisk");
 
+	pr_info("brd: module NOT loaded !!!\n");
 	return -ENOMEM;
 }
 
 static void __exit brd_exit(void)
 {
-	unsigned long range;
 	struct brd_device *brd, *next;
 
-	range = rd_nr ? rd_nr << part_shift : 1UL << MINORBITS;
-
 	list_for_each_entry_safe(brd, next, &brd_devices, brd_list)
 		brd_del_one(brd);
 
-	blk_unregister_region(MKDEV(RAMDISK_MAJOR, 0), range);
+	blk_unregister_region(MKDEV(RAMDISK_MAJOR, 0), 1UL << MINORBITS);
 	unregister_blkdev(RAMDISK_MAJOR, "ramdisk");
+
+	pr_info("brd: module unloaded\n");
 }
 
 module_init(brd_init);
-- 
1.9.3


