Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933290AbaJ2Mu6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Oct 2014 08:50:58 -0400
Received: from mail.sigma-star.at ([95.130.255.111]:14402 "EHLO
	mail.sigma-star.at" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932886AbaJ2MqU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Oct 2014 08:46:20 -0400
From: Richard Weinberger <richard@nod.at>
To: dedekind1@gmail.com
Cc: linux-mtd@lists.infradead.org, linux-kernel@vger.kernel.org,
        tlinder@codeaurora.org, Richard Weinberger <richard@nod.at>
Subject: [PATCH 20/35] UBI: Fastmap: Remove eba_orphans logic
Date: Wed, 29 Oct 2014 13:45:43 +0100
Message-Id: <1414586758-9972-21-git-send-email-richard@nod.at>
X-Mailer: git-send-email 1.8.4.5
In-Reply-To: <1414586758-9972-1-git-send-email-richard@nod.at>
References: <1414586758-9972-1-git-send-email-richard@nod.at>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This logic is in vain as we treat protected PEBs also as used, so this
case must not happen.
If a PEB is found which is in the EBA table but not known as used
has to be issued as fatal error.

Signed-off-by: Richard Weinberger <richard@nod.at>
---
 drivers/mtd/ubi/fastmap.c | 80 ++++++-----------------------------------------
 1 file changed, 9 insertions(+), 71 deletions(-)

diff --git a/drivers/mtd/ubi/fastmap.c b/drivers/mtd/ubi/fastmap.c
index 98d141e..ad3655c 100644
--- a/drivers/mtd/ubi/fastmap.c
+++ b/drivers/mtd/ubi/fastmap.c
@@ -440,7 +440,6 @@ static void unmap_peb(struct ubi_attach_info *ai, int pnum)
  * @pebs: an array of all PEB numbers in the to be scanned pool
  * @pool_size: size of the pool (number of entries in @pebs)
  * @max_sqnum: pointer to the maximal sequence number
- * @eba_orphans: list of PEBs which need to be scanned
  * @free: list of PEBs which are most likely free (and go into @ai->free)
  *
  * Returns 0 on success, if the pool is unusable UBI_BAD_FASTMAP is returned.
@@ -448,12 +447,12 @@ static void unmap_peb(struct ubi_attach_info *ai, int pnum)
  */
 static int scan_pool(struct ubi_device *ubi, struct ubi_attach_info *ai,
 		     int *pebs, int pool_size, unsigned long long *max_sqnum,
-		     struct list_head *eba_orphans, struct list_head *free)
+		     struct list_head *free)
 {
 	struct ubi_vid_hdr *vh;
 	struct ubi_ec_hdr *ech;
-	struct ubi_ainf_peb *new_aeb, *tmp_aeb;
-	int i, pnum, err, found_orphan, ret = 0;
+	struct ubi_ainf_peb *new_aeb;
+	int i, pnum, err, ret = 0;
 
 	ech = kzalloc(ubi->ec_hdr_alsize, GFP_KERNEL);
 	if (!ech)
@@ -521,18 +520,6 @@ static int scan_pool(struct ubi_device *ubi, struct ubi_attach_info *ai,
 			if (err == UBI_IO_BITFLIPS)
 				scrub = 1;
 
-			found_orphan = 0;
-			list_for_each_entry(tmp_aeb, eba_orphans, u.list) {
-				if (tmp_aeb->pnum == pnum) {
-					found_orphan = 1;
-					break;
-				}
-			}
-			if (found_orphan) {
-				list_del(&tmp_aeb->u.list);
-				kmem_cache_free(ai->aeb_slab_cache, tmp_aeb);
-			}
-
 			new_aeb = kmem_cache_alloc(ai->aeb_slab_cache,
 						   GFP_KERNEL);
 			if (!new_aeb) {
@@ -607,7 +594,7 @@ static int ubi_attach_fastmap(struct ubi_device *ubi,
 			      struct ubi_attach_info *ai,
 			      struct ubi_fastmap_layout *fm)
 {
-	struct list_head used, eba_orphans, free;
+	struct list_head used, free;
 	struct ubi_ainf_volume *av;
 	struct ubi_ainf_peb *aeb, *tmp_aeb, *_tmp_aeb;
 	struct ubi_ec_hdr *ech;
@@ -624,7 +611,6 @@ static int ubi_attach_fastmap(struct ubi_device *ubi,
 
 	INIT_LIST_HEAD(&used);
 	INIT_LIST_HEAD(&free);
-	INIT_LIST_HEAD(&eba_orphans);
 	ai->min_ec = UBI_MAX_ERASECOUNTER;
 
 	fmsb = (struct ubi_fm_sb *)(fm_raw);
@@ -793,28 +779,9 @@ static int ubi_attach_fastmap(struct ubi_device *ubi,
 				}
 			}
 
-			/* This can happen if a PEB is already in an EBA known
-			 * by this fastmap but the PEB itself is not in the used
-			 * list.
-			 * In this case the PEB can be within the fastmap pool
-			 * or while writing the fastmap it was in the protection
-			 * queue.
-			 */
 			if (!aeb) {
-				aeb = kmem_cache_alloc(ai->aeb_slab_cache,
-						       GFP_KERNEL);
-				if (!aeb) {
-					ret = -ENOMEM;
-
-					goto fail;
-				}
-
-				aeb->lnum = j;
-				aeb->pnum = be32_to_cpu(fm_eba->pnum[j]);
-				aeb->ec = -1;
-				aeb->scrub = aeb->copy_flag = aeb->sqnum = 0;
-				list_add_tail(&aeb->u.list, &eba_orphans);
-				continue;
+				ubi_err("PEB %i is in EBA but not in used list", pnum);
+				goto fail_bad;
 			}
 
 			aeb->lnum = j;
@@ -831,45 +798,17 @@ static int ubi_attach_fastmap(struct ubi_device *ubi,
 		ech = kzalloc(ubi->ec_hdr_alsize, GFP_KERNEL);
 		if (!ech) {
 			ret = -ENOMEM;
-			goto fail;
-		}
-
-		list_for_each_entry_safe(tmp_aeb, _tmp_aeb, &eba_orphans,
-					 u.list) {
-			int err;
-
-			if (ubi_io_is_bad(ubi, tmp_aeb->pnum)) {
-				ubi_err("bad PEB in fastmap EBA orphan list");
-				ret = UBI_BAD_FASTMAP;
-				kfree(ech);
-				goto fail;
-			}
-
-			err = ubi_io_read_ec_hdr(ubi, tmp_aeb->pnum, ech, 0);
-			if (err && err != UBI_IO_BITFLIPS) {
-				ubi_err("unable to read EC header! PEB:%i " \
-					"err:%i", tmp_aeb->pnum, err);
-				ret = err > 0 ? UBI_BAD_FASTMAP : err;
-				kfree(ech);
-
-				goto fail;
-			} else if (err == UBI_IO_BITFLIPS)
-				tmp_aeb->scrub = 1;
-
-			tmp_aeb->ec = be64_to_cpu(ech->ec);
-			assign_aeb_to_av(ai, tmp_aeb, av);
+			goto fail_bad;
 		}
 
 		kfree(ech);
 	}
 
-	ret = scan_pool(ubi, ai, fmpl1->pebs, pool_size, &max_sqnum,
-			&eba_orphans, &free);
+	ret = scan_pool(ubi, ai, fmpl1->pebs, pool_size, &max_sqnum, &free);
 	if (ret)
 		goto fail;
 
-	ret = scan_pool(ubi, ai, fmpl2->pebs, wl_pool_size, &max_sqnum,
-			&eba_orphans, &free);
+	ret = scan_pool(ubi, ai, fmpl2->pebs, wl_pool_size, &max_sqnum, &free);
 	if (ret)
 		goto fail;
 
@@ -882,7 +821,6 @@ static int ubi_attach_fastmap(struct ubi_device *ubi,
 	list_for_each_entry_safe(tmp_aeb, _tmp_aeb, &used, u.list)
 		list_move_tail(&tmp_aeb->u.list, &ai->erase);
 
-	ubi_assert(list_empty(&eba_orphans));
 	ubi_assert(list_empty(&free));
 
 	/*
-- 
1.8.4.5

