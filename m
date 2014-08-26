Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758417AbaHZPIR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Aug 2014 11:08:17 -0400
Received: from mga01.intel.com ([192.55.52.88]:28243 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753020AbaHZPIQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Aug 2014 11:08:16 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.04,405,1406617200"; 
   d="scan'208";a="581890761"
From: Keith Busch <keith.busch@intel.com>
To: linux-nvme@lists.infradead.org, linux-kernel@vger.kernel.org
Cc: axboe@kernel.dk, Keith Busch <keith.busch@intel.com>
Subject: [PATCHv2] block: Fix dev_t minor allocation lifetime
Date: Tue, 26 Aug 2014 09:05:36 -0600
Message-Id: <1409065536-7062-1-git-send-email-keith.busch@intel.com>
X-Mailer: git-send-email 1.7.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Releases the dev_t minor when all references are closed to prevent
another device from acquiring the same major/minor.

Since the partition's release may be invoked from call_rcu's soft-irq
context, the ext_dev_idr's mutex had to be replaced with a spinlock so
as not so sleep.

Signed-off-by: Keith Busch <keith.busch@intel.com>
---
v1->v2:

  Applied comments from Willy: fixed gfp mask in idr_alloc to not wait,
  and preload.

 block/genhd.c             |   24 ++++++++++++++----------
 block/partition-generic.c |    2 +-
 2 files changed, 15 insertions(+), 11 deletions(-)

diff --git a/block/genhd.c b/block/genhd.c
index 791f419..09da5e4 100644
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
@@ -420,9 +420,13 @@ int blk_alloc_devt(struct hd_struct *part, dev_t *devt)
 	}
 
 	/* allocate ext devt */
-	mutex_lock(&ext_devt_mutex);
-	idx = idr_alloc(&ext_devt_idr, part, 0, NR_EXT_DEVT, GFP_KERNEL);
-	mutex_unlock(&ext_devt_mutex);
+	idr_preload(GFP_KERNEL);
+
+	spin_lock(&ext_devt_lock);
+	idx = idr_alloc(&ext_devt_idr, part, 0, NR_EXT_DEVT, GFP_NOWAIT);
+	spin_unlock(&ext_devt_lock);
+
+	idr_preload_end();
 	if (idx < 0)
 		return idx == -ENOSPC ? -EBUSY : idx;
 
@@ -447,9 +451,9 @@ void blk_free_devt(dev_t devt)
 		return;
 
 	if (MAJOR(devt) == BLOCK_EXT_MAJOR) {
-		mutex_lock(&ext_devt_mutex);
+		spin_lock(&ext_devt_lock);
 		idr_remove(&ext_devt_idr, blk_mangle_minor(MINOR(devt)));
-		mutex_unlock(&ext_devt_mutex);
+		spin_unlock(&ext_devt_lock);
 	}
 }
 
@@ -665,7 +669,6 @@ void del_gendisk(struct gendisk *disk)
 		sysfs_remove_link(block_depr, dev_name(disk_to_dev(disk)));
 	pm_runtime_set_memalloc_noio(disk_to_dev(disk), false);
 	device_del(disk_to_dev(disk));
-	blk_free_devt(disk_to_dev(disk)->devt);
 }
 EXPORT_SYMBOL(del_gendisk);
 
@@ -690,13 +693,13 @@ struct gendisk *get_gendisk(dev_t devt, int *partno)
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
@@ -1098,6 +1101,7 @@ static void disk_release(struct device *dev)
 {
 	struct gendisk *disk = dev_to_disk(dev);
 
+	blk_free_devt(dev->devt);
 	disk_release_events(disk);
 	kfree(disk->random);
 	disk_replace_part_tbl(disk, NULL);
diff --git a/block/partition-generic.c b/block/partition-generic.c
index 789cdea..0d9e5f9 100644
--- a/block/partition-generic.c
+++ b/block/partition-generic.c
@@ -211,6 +211,7 @@ static const struct attribute_group *part_attr_groups[] = {
 static void part_release(struct device *dev)
 {
 	struct hd_struct *p = dev_to_part(dev);
+	blk_free_devt(dev->devt);
 	free_part_stats(p);
 	free_part_info(p);
 	kfree(p);
@@ -253,7 +254,6 @@ void delete_partition(struct gendisk *disk, int partno)
 	rcu_assign_pointer(ptbl->last_lookup, NULL);
 	kobject_put(part->holder_dir);
 	device_del(part_to_dev(part));
-	blk_free_devt(part_devt(part));
 
 	hd_struct_put(part);
 }
-- 
1.7.10.4

