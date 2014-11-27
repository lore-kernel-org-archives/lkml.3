Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754608AbaK0Iqs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Nov 2014 03:46:48 -0500
Received: from mail.kernel.org ([198.145.19.201]:41376 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754542AbaK0Iqq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Nov 2014 03:46:46 -0500
From: lizf@kernel.org
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Keith Busch <keith.busch@intel.com>,
        Jens Axboe <axboe@fb.com>, Zefan Li <lizefan@huawei.com>
Subject: [PATCH 3.4 20/91] block: Fix dev_t minor allocation lifetime
Date: Thu, 27 Nov 2014 16:42:03 +0800
Message-Id: <1417077794-9299-20-git-send-email-lizf@kernel.org>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1417077368-9217-1-git-send-email-lizf@kernel.org>
References: <1417077368-9217-1-git-send-email-lizf@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Keith Busch <keith.busch@intel.com>

3.4.105-rc1 review patch.  If anyone has any objections, please let me know.

------------------


commit 2da78092dda13f1efd26edbbf99a567776913750 upstream.

Releases the dev_t minor when all references are closed to prevent
another device from acquiring the same major/minor.

Since the partition's release may be invoked from call_rcu's soft-irq
context, the ext_dev_idr's mutex had to be replaced with a spinlock so
as not so sleep.

Signed-off-by: Keith Busch <keith.busch@intel.com>
Signed-off-by: Jens Axboe <axboe@fb.com>
[lizf: Backported to 3.4:
 - adjust context
 - remove idr_preload() and idr_preload_end()]
Signed-off-by: Zefan Li <lizefan@huawei.com>
---
 block/genhd.c             | 18 +++++++++---------
 block/partition-generic.c |  2 +-
 2 files changed, 10 insertions(+), 10 deletions(-)

diff --git a/block/genhd.c b/block/genhd.c
index d815a0f..54867f4 100644
--- a/block/genhd.c
+++ b/block/genhd.c
@@ -27,10 +27,10 @@ struct kobject *block_depr;
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
@@ -420,13 +420,13 @@ int blk_alloc_devt(struct hd_struct *part, dev_t *devt)
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
@@ -453,9 +453,9 @@ void blk_free_devt(dev_t devt)
 		return;
 
 	if (MAJOR(devt) == BLOCK_EXT_MAJOR) {
-		mutex_lock(&ext_devt_mutex);
+		spin_lock(&ext_devt_lock);
 		idr_remove(&ext_devt_idr, blk_mangle_minor(MINOR(devt)));
-		mutex_unlock(&ext_devt_mutex);
+		spin_unlock(&ext_devt_lock);
 	}
 }
 
@@ -662,7 +662,6 @@ void del_gendisk(struct gendisk *disk)
 	if (!sysfs_deprecated)
 		sysfs_remove_link(block_depr, dev_name(disk_to_dev(disk)));
 	device_del(disk_to_dev(disk));
-	blk_free_devt(disk_to_dev(disk)->devt);
 }
 EXPORT_SYMBOL(del_gendisk);
 
@@ -687,13 +686,13 @@ struct gendisk *get_gendisk(dev_t devt, int *partno)
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
@@ -1101,6 +1100,7 @@ static void disk_release(struct device *dev)
 {
 	struct gendisk *disk = dev_to_disk(dev);
 
+	blk_free_devt(dev->devt);
 	disk_release_events(disk);
 	kfree(disk->random);
 	disk_replace_part_tbl(disk, NULL);
diff --git a/block/partition-generic.c b/block/partition-generic.c
index 7b8b8d1..daafc85 100644
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
1.9.1

