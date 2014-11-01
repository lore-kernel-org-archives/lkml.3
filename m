Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752188AbaKAWkq (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Nov 2014 18:40:46 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:60348 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751855AbaKAWjf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Nov 2014 18:39:35 -0400
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC: akpm@linux-foundation.org, "Keith Busch" <keith.busch@intel.com>,
        "Jens Axboe" <axboe@fb.com>
Date: Sat, 01 Nov 2014 22:28:03 +0000
Message-ID: <lsq.1414880883.370330013@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [PATCH 3.2 023/102] block: Fix dev_t minor allocation lifetime
In-Reply-To: <lsq.1414880882.522510247@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.249
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2.64-rc1 review patch.  If anyone has any objections, please let me know.

------------------

From: Keith Busch <keith.busch@intel.com>

commit 2da78092dda13f1efd26edbbf99a567776913750 upstream.

Releases the dev_t minor when all references are closed to prevent
another device from acquiring the same major/minor.

Since the partition's release may be invoked from call_rcu's soft-irq
context, the ext_dev_idr's mutex had to be replaced with a spinlock so
as not so sleep.

Signed-off-by: Keith Busch <keith.busch@intel.com>
Signed-off-by: Jens Axboe <axboe@fb.com>
[bwh: Backported to 3.2:
 - Adjust filename
 - idr insertion API is different, and blk_alloc_devt() is preallocating
   a node in a different way]
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
--- a/block/genhd.c
+++ b/block/genhd.c
@@ -28,10 +28,10 @@ struct kobject *block_depr;
 /* for extended dynamic devt allocation, currently only one major is used */
 #define NR_EXT_DEVT		(1 << MINORBITS)
 
-/* For extended devt allocation.  ext_devt_mutex prevents look up
+/* For extended devt allocation.  ext_devt_lock prevents look up
  * results from going away underneath its user.
  */
-static DEFINE_MUTEX(ext_devt_mutex);
+static DEFINE_SPINLOCK(ext_devt_lock);
 static DEFINE_IDR(ext_devt_idr);
 
 static struct device_type disk_type;
@@ -421,13 +421,13 @@ int blk_alloc_devt(struct hd_struct *par
 	do {
 		if (!idr_pre_get(&ext_devt_idr, GFP_KERNEL))
 			return -ENOMEM;
-		mutex_lock(&ext_devt_mutex);
+		spin_lock(&ext_devt_lock);
 		rc = idr_get_new(&ext_devt_idr, part, &idx);
 		if (!rc && idx >= NR_EXT_DEVT) {
 			idr_remove(&ext_devt_idr, idx);
 			rc = -EBUSY;
 		}
-		mutex_unlock(&ext_devt_mutex);
+		spin_unlock(&ext_devt_lock);
 	} while (rc == -EAGAIN);
 
 	if (rc)
@@ -454,9 +454,9 @@ void blk_free_devt(dev_t devt)
 		return;
 
 	if (MAJOR(devt) == BLOCK_EXT_MAJOR) {
-		mutex_lock(&ext_devt_mutex);
+		spin_lock(&ext_devt_lock);
 		idr_remove(&ext_devt_idr, blk_mangle_minor(MINOR(devt)));
-		mutex_unlock(&ext_devt_mutex);
+		spin_unlock(&ext_devt_lock);
 	}
 }
 
@@ -663,7 +663,6 @@ void del_gendisk(struct gendisk *disk)
 	if (!sysfs_deprecated)
 		sysfs_remove_link(block_depr, dev_name(disk_to_dev(disk)));
 	device_del(disk_to_dev(disk));
-	blk_free_devt(disk_to_dev(disk)->devt);
 }
 EXPORT_SYMBOL(del_gendisk);
 
@@ -688,13 +687,13 @@ struct gendisk *get_gendisk(dev_t devt,
 	} else {
 		struct hd_struct *part;
 
-		mutex_lock(&ext_devt_mutex);
+		spin_lock(&ext_devt_lock);
 		part = idr_find(&ext_devt_idr, blk_mangle_minor(MINOR(devt)));
 		if (part && get_disk(part_to_disk(part))) {
 			*partno = part->partno;
 			disk = part_to_disk(part);
 		}
-		mutex_unlock(&ext_devt_mutex);
+		spin_unlock(&ext_devt_lock);
 	}
 
 	return disk;
@@ -1102,6 +1101,7 @@ static void disk_release(struct device *
 {
 	struct gendisk *disk = dev_to_disk(dev);
 
+	blk_free_devt(dev->devt);
 	disk_release_events(disk);
 	kfree(disk->random);
 	disk_replace_part_tbl(disk, NULL);
--- a/fs/partitions/check.c
+++ b/fs/partitions/check.c
@@ -361,6 +361,7 @@ static const struct attribute_group *par
 static void part_release(struct device *dev)
 {
 	struct hd_struct *p = dev_to_part(dev);
+	blk_free_devt(dev->devt);
 	free_part_stats(p);
 	free_part_info(p);
 	kfree(p);
@@ -403,7 +404,6 @@ void delete_partition(struct gendisk *di
 	rcu_assign_pointer(ptbl->last_lookup, NULL);
 	kobject_put(part->holder_dir);
 	device_del(part_to_dev(part));
-	blk_free_devt(part_devt(part));
 
 	hd_struct_put(part);
 }

