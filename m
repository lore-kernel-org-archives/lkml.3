Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753405Ab3BCBVr (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Feb 2013 20:21:47 -0500
Received: from mail-pb0-f43.google.com ([209.85.160.43]:63549 "EHLO
	mail-pb0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752552Ab3BCBVW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Feb 2013 20:21:22 -0500
From: Tejun Heo <tj@kernel.org>
To: akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, rusty@rustcorp.com.au, bfields@fieldses.org,
        skinsbursky@parallels.com, ebiederm@xmission.com, jmorris@namei.org,
        axboe@kernel.dk, Tejun Heo <tj@kernel.org>, stable@vger.kernel.org
Subject: [PATCH 06/62] block: fix synchronization and limit check in blk_alloc_devt()
Date: Sat,  2 Feb 2013 17:20:07 -0800
Message-Id: <1359854463-2538-7-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.8.1
In-Reply-To: <1359854463-2538-1-git-send-email-tj@kernel.org>
References: <1359854463-2538-1-git-send-email-tj@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

idr allocation in blk_alloc_devt() wasn't synchronized against lookup
and removal, and its limit check was off by one - 1 << MINORBITS is
the number of minors allowed, not the maximum allowed minor.

Add locking and rename MAX_EXT_DEVT to NR_EXT_DEVT and fix limit
checking.

Signed-off-by: Tejun Heo <tj@kernel.org>
Cc: Jens Axboe <axboe@kernel.dk>
Cc: stable@vger.kernel.org
---
 block/genhd.c | 13 +++++++------
 1 file changed, 7 insertions(+), 6 deletions(-)

diff --git a/block/genhd.c b/block/genhd.c
index 9a289d7..49abda1 100644
--- a/block/genhd.c
+++ b/block/genhd.c
@@ -25,7 +25,7 @@ static DEFINE_MUTEX(block_class_lock);
 struct kobject *block_depr;
 
 /* for extended dynamic devt allocation, currently only one major is used */
-#define MAX_EXT_DEVT		(1 << MINORBITS)
+#define NR_EXT_DEVT		(1 << MINORBITS)
 
 /* For extended devt allocation.  ext_devt_mutex prevents look up
  * results from going away underneath its user.
@@ -420,17 +420,18 @@ int blk_alloc_devt(struct hd_struct *part, dev_t *devt)
 	do {
 		if (!idr_pre_get(&ext_devt_idr, GFP_KERNEL))
 			return -ENOMEM;
+		mutex_lock(&ext_devt_mutex);
 		rc = idr_get_new(&ext_devt_idr, part, &idx);
+		if (!rc && idx >= NR_EXT_DEVT) {
+			idr_remove(&ext_devt_idr, idx);
+			rc = -EBUSY;
+		}
+		mutex_unlock(&ext_devt_mutex);
 	} while (rc == -EAGAIN);
 
 	if (rc)
 		return rc;
 
-	if (idx > MAX_EXT_DEVT) {
-		idr_remove(&ext_devt_idr, idx);
-		return -EBUSY;
-	}
-
 	*devt = MKDEV(BLOCK_EXT_MAJOR, blk_mangle_minor(idx));
 	return 0;
 }
-- 
1.8.1

