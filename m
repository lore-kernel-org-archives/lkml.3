Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964840Ab3BFUHR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Feb 2013 15:07:17 -0500
Received: from mail-ia0-f173.google.com ([209.85.210.173]:53715 "EHLO
	mail-ia0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964780Ab3BFTt4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Feb 2013 14:49:56 -0500
From: Tejun Heo <tj@kernel.org>
To: akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, Tejun Heo <tj@kernel.org>
Subject: [PATCH 22/77] block: convert to idr_alloc()
Date: Wed,  6 Feb 2013 11:39:54 -0800
Message-Id: <1360179649-22465-23-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.8.1
In-Reply-To: <1360179649-22465-1-git-send-email-tj@kernel.org>
References: <1360179649-22465-1-git-send-email-tj@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Convert to the much saner new idr interface.  Both bsg and genhd
protect idr w/ mutex making preloading unnecessary.

Signed-off-by: Tejun Heo <tj@kernel.org>
Acked-by: Jens Axboe <axboe@kernel.dk>
---
 block/bsg.c   | 26 +++++++++-----------------
 block/genhd.c | 21 ++++++---------------
 2 files changed, 15 insertions(+), 32 deletions(-)

diff --git a/block/bsg.c b/block/bsg.c
index ff64ae3..3ca92eb 100644
--- a/block/bsg.c
+++ b/block/bsg.c
@@ -997,7 +997,7 @@ int bsg_register_queue(struct request_queue *q, struct device *parent,
 {
 	struct bsg_class_device *bcd;
 	dev_t dev;
-	int ret, minor;
+	int ret;
 	struct device *class_dev = NULL;
 	const char *devname;
 
@@ -1017,23 +1017,16 @@ int bsg_register_queue(struct request_queue *q, struct device *parent,
 
 	mutex_lock(&bsg_mutex);
 
-	ret = idr_pre_get(&bsg_minor_idr, GFP_KERNEL);
-	if (!ret) {
-		ret = -ENOMEM;
-		goto unlock;
-	}
-
-	ret = idr_get_new(&bsg_minor_idr, bcd, &minor);
-	if (ret < 0)
+	ret = idr_alloc(&bsg_minor_idr, bcd, 0, BSG_MAX_DEVS, GFP_KERNEL);
+	if (ret < 0) {
+		if (ret == -ENOSPC) {
+			printk(KERN_ERR "bsg: too many bsg devices\n");
+			ret = -EINVAL;
+		}
 		goto unlock;
-
-	if (minor >= BSG_MAX_DEVS) {
-		printk(KERN_ERR "bsg: too many bsg devices\n");
-		ret = -EINVAL;
-		goto remove_idr;
 	}
 
-	bcd->minor = minor;
+	bcd->minor = ret;
 	bcd->queue = q;
 	bcd->parent = get_device(parent);
 	bcd->release = release;
@@ -1059,8 +1052,7 @@ unregister_class_dev:
 	device_unregister(class_dev);
 put_dev:
 	put_device(parent);
-remove_idr:
-	idr_remove(&bsg_minor_idr, minor);
+	idr_remove(&bsg_minor_idr, bcd->minor);
 unlock:
 	mutex_unlock(&bsg_mutex);
 	return ret;
diff --git a/block/genhd.c b/block/genhd.c
index b1f34d0..bd509e3 100644
--- a/block/genhd.c
+++ b/block/genhd.c
@@ -411,7 +411,7 @@ static int blk_mangle_minor(int minor)
 int blk_alloc_devt(struct hd_struct *part, dev_t *devt)
 {
 	struct gendisk *disk = part_to_disk(part);
-	int idx, rc;
+	int idx;
 
 	/* in consecutive minor range? */
 	if (part->partno < disk->minors) {
@@ -420,20 +420,11 @@ int blk_alloc_devt(struct hd_struct *part, dev_t *devt)
 	}
 
 	/* allocate ext devt */
-	do {
-		if (!idr_pre_get(&ext_devt_idr, GFP_KERNEL))
-			return -ENOMEM;
-		mutex_lock(&ext_devt_mutex);
-		rc = idr_get_new(&ext_devt_idr, part, &idx);
-		if (!rc && idx >= NR_EXT_DEVT) {
-			idr_remove(&ext_devt_idr, idx);
-			rc = -EBUSY;
-		}
-		mutex_unlock(&ext_devt_mutex);
-	} while (rc == -EAGAIN);
-
-	if (rc)
-		return rc;
+	mutex_lock(&ext_devt_mutex);
+	idx = idr_alloc(&ext_devt_idr, part, 0, NR_EXT_DEVT, GFP_KERNEL);
+	mutex_unlock(&ext_devt_mutex);
+	if (idx < 0)
+		return idx == -ENOSPC ? -EBUSY : idx;
 
 	*devt = MKDEV(BLOCK_EXT_MAJOR, blk_mangle_minor(idx));
 	return 0;
-- 
1.8.1

