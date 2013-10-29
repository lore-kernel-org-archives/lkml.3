Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758622Ab3J2Rbo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Oct 2013 13:31:44 -0400
Received: from smtp.citrix.com ([66.165.176.89]:41521 "EHLO SMTP.CITRIX.COM"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754017Ab3J2Rbn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Oct 2013 13:31:43 -0400
X-IronPort-AV: E=Sophos;i="4.93,594,1378857600"; 
   d="scan'208";a="68535771"
From: Roger Pau Monne <roger.pau@citrix.com>
To: <xen-devel@lists.xenproject.org>, <linux-kernel@vger.kernel.org>
CC: Roger Pau Monne <roger.pau@citrix.com>,
        Felipe Franciosi <felipe.franciosi@citrix.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        David Vrabel <david.vrabel@citrix.com>
Subject: [PATCH] xen-blkfront: restore the non-persistent data path
Date: Tue, 29 Oct 2013 18:31:14 +0100
Message-ID: <1383067874-4684-1-git-send-email-roger.pau@citrix.com>
X-Mailer: git-send-email 1.7.7.5 (Apple Git-26)
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-DLP: MIA2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When persistent grants were added they were always used, even if the
backend doesn't have this feature (there's no harm in always using the
same set of pages). This restores the old data path when the backend
doesn't have persistent grants, removing the burden of doing a memcpy
when it is not actually needed.

Signed-off-by: Roger Pau Monné <roger.pau@citrix.com>
Reported-by: Felipe Franciosi <felipe.franciosi@citrix.com>
Cc: Felipe Franciosi <felipe.franciosi@citrix.com>
Cc: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Cc: David Vrabel <david.vrabel@citrix.com>
---
 drivers/block/xen-blkfront.c |  124 ++++++++++++++++++++++++++++++++++--------
 1 files changed, 100 insertions(+), 24 deletions(-)

diff --git a/drivers/block/xen-blkfront.c b/drivers/block/xen-blkfront.c
index 6553133..bffddf4 100644
--- a/drivers/block/xen-blkfront.c
+++ b/drivers/block/xen-blkfront.c
@@ -121,7 +121,8 @@ struct blkfront_info
 	struct work_struct work;
 	struct gnttab_free_callback callback;
 	struct blk_shadow shadow[BLK_RING_SIZE];
-	struct list_head persistent_gnts;
+	struct list_head grants;
+	struct list_head indirect_pages;
 	unsigned int persistent_gnts_c;
 	unsigned long shadow_free;
 	unsigned int feature_flush;
@@ -200,15 +201,17 @@ static int fill_grant_buffer(struct blkfront_info *info, int num)
 		if (!gnt_list_entry)
 			goto out_of_memory;
 
-		granted_page = alloc_page(GFP_NOIO);
-		if (!granted_page) {
-			kfree(gnt_list_entry);
-			goto out_of_memory;
+		if (info->feature_persistent) {
+			granted_page = alloc_page(GFP_NOIO);
+			if (!granted_page) {
+				kfree(gnt_list_entry);
+				goto out_of_memory;
+			}
+			gnt_list_entry->pfn = page_to_pfn(granted_page);
 		}
 
-		gnt_list_entry->pfn = page_to_pfn(granted_page);
 		gnt_list_entry->gref = GRANT_INVALID_REF;
-		list_add(&gnt_list_entry->node, &info->persistent_gnts);
+		list_add(&gnt_list_entry->node, &info->grants);
 		i++;
 	}
 
@@ -216,9 +219,10 @@ static int fill_grant_buffer(struct blkfront_info *info, int num)
 
 out_of_memory:
 	list_for_each_entry_safe(gnt_list_entry, n,
-	                         &info->persistent_gnts, node) {
+	                         &info->grants, node) {
 		list_del(&gnt_list_entry->node);
-		__free_page(pfn_to_page(gnt_list_entry->pfn));
+		if (info->feature_persistent)
+			__free_page(pfn_to_page(gnt_list_entry->pfn));
 		kfree(gnt_list_entry);
 		i--;
 	}
@@ -227,13 +231,14 @@ out_of_memory:
 }
 
 static struct grant *get_grant(grant_ref_t *gref_head,
+                               unsigned long pfn,
                                struct blkfront_info *info)
 {
 	struct grant *gnt_list_entry;
 	unsigned long buffer_mfn;
 
-	BUG_ON(list_empty(&info->persistent_gnts));
-	gnt_list_entry = list_first_entry(&info->persistent_gnts, struct grant,
+	BUG_ON(list_empty(&info->grants));
+	gnt_list_entry = list_first_entry(&info->grants, struct grant,
 	                                  node);
 	list_del(&gnt_list_entry->node);
 
@@ -245,6 +250,10 @@ static struct grant *get_grant(grant_ref_t *gref_head,
 	/* Assign a gref to this page */
 	gnt_list_entry->gref = gnttab_claim_grant_reference(gref_head);
 	BUG_ON(gnt_list_entry->gref == -ENOSPC);
+	if (!info->feature_persistent) {
+		BUG_ON(!pfn);
+		gnt_list_entry->pfn = pfn;
+	}
 	buffer_mfn = pfn_to_mfn(gnt_list_entry->pfn);
 	gnttab_grant_foreign_access_ref(gnt_list_entry->gref,
 	                                info->xbdev->otherend_id,
@@ -480,22 +489,34 @@ static int blkif_queue_request(struct request *req)
 
 			if ((ring_req->operation == BLKIF_OP_INDIRECT) &&
 			    (i % SEGS_PER_INDIRECT_FRAME == 0)) {
+				unsigned long pfn;
+
 				if (segments)
 					kunmap_atomic(segments);
 
 				n = i / SEGS_PER_INDIRECT_FRAME;
-				gnt_list_entry = get_grant(&gref_head, info);
+				if (!info->feature_persistent) {
+					struct page *indirect_page;
+
+					/* Fetch a pre-allocated page to use for indirect grefs */
+					BUG_ON(list_empty(&info->indirect_pages));
+					indirect_page = list_first_entry(&info->indirect_pages,
+					                                 struct page, lru);
+					list_del(&indirect_page->lru);
+					pfn = page_to_pfn(indirect_page);
+				}
+				gnt_list_entry = get_grant(&gref_head, pfn, info);
 				info->shadow[id].indirect_grants[n] = gnt_list_entry;
 				segments = kmap_atomic(pfn_to_page(gnt_list_entry->pfn));
 				ring_req->u.indirect.indirect_grefs[n] = gnt_list_entry->gref;
 			}
 
-			gnt_list_entry = get_grant(&gref_head, info);
+			gnt_list_entry = get_grant(&gref_head, page_to_pfn(sg_page(sg)), info);
 			ref = gnt_list_entry->gref;
 
 			info->shadow[id].grants_used[i] = gnt_list_entry;
 
-			if (rq_data_dir(req)) {
+			if (rq_data_dir(req) && info->feature_persistent) {
 				char *bvec_data;
 				void *shared_data;
 
@@ -907,21 +928,36 @@ static void blkif_free(struct blkfront_info *info, int suspend)
 		blk_stop_queue(info->rq);
 
 	/* Remove all persistent grants */
-	if (!list_empty(&info->persistent_gnts)) {
+	if (!list_empty(&info->grants)) {
 		list_for_each_entry_safe(persistent_gnt, n,
-		                         &info->persistent_gnts, node) {
+		                         &info->grants, node) {
 			list_del(&persistent_gnt->node);
 			if (persistent_gnt->gref != GRANT_INVALID_REF) {
 				gnttab_end_foreign_access(persistent_gnt->gref,
 				                          0, 0UL);
 				info->persistent_gnts_c--;
 			}
-			__free_page(pfn_to_page(persistent_gnt->pfn));
+			if (info->feature_persistent)
+				__free_page(pfn_to_page(persistent_gnt->pfn));
 			kfree(persistent_gnt);
 		}
 	}
 	BUG_ON(info->persistent_gnts_c != 0);
 
+	/*
+	 * Remove indirect pages, this only happens when using indirect
+	 * descriptors but not persistent grants
+	 */
+	if (!list_empty(&info->indirect_pages)) {
+		struct page *indirect_page, *n;
+
+		BUG_ON(info->feature_persistent);
+		list_for_each_entry_safe(indirect_page, n, &info->indirect_pages, lru) {
+			list_del(&indirect_page->lru);
+			__free_page(indirect_page);
+		}
+	}
+
 	for (i = 0; i < BLK_RING_SIZE; i++) {
 		/*
 		 * Clear persistent grants present in requests already
@@ -936,7 +972,8 @@ static void blkif_free(struct blkfront_info *info, int suspend)
 		for (j = 0; j < segs; j++) {
 			persistent_gnt = info->shadow[i].grants_used[j];
 			gnttab_end_foreign_access(persistent_gnt->gref, 0, 0UL);
-			__free_page(pfn_to_page(persistent_gnt->pfn));
+			if (info->feature_persistent)
+				__free_page(pfn_to_page(persistent_gnt->pfn));
 			kfree(persistent_gnt);
 		}
 
@@ -995,7 +1032,7 @@ static void blkif_completion(struct blk_shadow *s, struct blkfront_info *info,
 	nseg = s->req.operation == BLKIF_OP_INDIRECT ?
 		s->req.u.indirect.nr_segments : s->req.u.rw.nr_segments;
 
-	if (bret->operation == BLKIF_OP_READ) {
+	if (bret->operation == BLKIF_OP_READ && info->feature_persistent) {
 		/*
 		 * Copy the data received from the backend into the bvec.
 		 * Since bv_offset can be different than 0, and bv_len different
@@ -1023,7 +1060,10 @@ static void blkif_completion(struct blk_shadow *s, struct blkfront_info *info,
 			 * we add it at the head of the list, so it will be
 			 * reused first.
 			 */
-			list_add(&s->grants_used[i]->node, &info->persistent_gnts);
+			if (!info->feature_persistent)
+				pr_alert_ratelimited("backed has not unmapped grant: %u\n",
+				                     s->grants_used[i]->gref);
+			list_add(&s->grants_used[i]->node, &info->grants);
 			info->persistent_gnts_c++;
 		} else {
 			/*
@@ -1034,19 +1074,30 @@ static void blkif_completion(struct blk_shadow *s, struct blkfront_info *info,
 			 */
 			gnttab_end_foreign_access(s->grants_used[i]->gref, 0, 0UL);
 			s->grants_used[i]->gref = GRANT_INVALID_REF;
-			list_add_tail(&s->grants_used[i]->node, &info->persistent_gnts);
+			list_add_tail(&s->grants_used[i]->node, &info->grants);
 		}
 	}
 	if (s->req.operation == BLKIF_OP_INDIRECT) {
 		for (i = 0; i < INDIRECT_GREFS(nseg); i++) {
 			if (gnttab_query_foreign_access(s->indirect_grants[i]->gref)) {
-				list_add(&s->indirect_grants[i]->node, &info->persistent_gnts);
+				if (!info->feature_persistent)
+					pr_alert_ratelimited("backed has not unmapped grant: %u\n",
+				                     	     s->indirect_grants[i]->gref);
+				list_add(&s->indirect_grants[i]->node, &info->grants);
 				info->persistent_gnts_c++;
 			} else {
+				struct page *indirect_page;
+
 				gnttab_end_foreign_access(s->indirect_grants[i]->gref, 0, 0UL);
+				/*
+				 * Add the used indirect page back to the list of
+				 * available pages for indirect grefs.
+				 */
+				indirect_page = pfn_to_page(s->indirect_grants[i]->pfn);
+				list_add(&indirect_page->lru, &info->indirect_pages);
 				s->indirect_grants[i]->gref = GRANT_INVALID_REF;
 				list_add_tail(&s->indirect_grants[i]->node,
-				              &info->persistent_gnts);
+				              &info->grants);
 			}
 		}
 	}
@@ -1341,7 +1392,8 @@ static int blkfront_probe(struct xenbus_device *dev,
 	spin_lock_init(&info->io_lock);
 	info->xbdev = dev;
 	info->vdevice = vdevice;
-	INIT_LIST_HEAD(&info->persistent_gnts);
+	INIT_LIST_HEAD(&info->grants);
+	INIT_LIST_HEAD(&info->indirect_pages);
 	info->persistent_gnts_c = 0;
 	info->connected = BLKIF_STATE_DISCONNECTED;
 	INIT_WORK(&info->work, blkif_restart_queue);
@@ -1688,6 +1740,23 @@ static int blkfront_setup_indirect(struct blkfront_info *info)
 	if (err)
 		goto out_of_memory;
 
+	if (!info->feature_persistent && info->max_indirect_segments) {
+		/*
+		 * We are using indirect descriptors but not persistent
+		 * grants, we need to allocate a set of pages that can be
+		 * used for mapping indirect grefs
+		 */
+		int num = INDIRECT_GREFS(segs) * BLK_RING_SIZE;
+
+		BUG_ON(!list_empty(&info->indirect_pages));
+		for (i = 0; i < num; i++) {
+			struct page *indirect_page = alloc_page(GFP_NOIO);
+			if (!indirect_page)
+				goto out_of_memory;
+			list_add(&indirect_page->lru, &info->indirect_pages);
+		}
+	}
+
 	for (i = 0; i < BLK_RING_SIZE; i++) {
 		info->shadow[i].grants_used = kzalloc(
 			sizeof(info->shadow[i].grants_used[0]) * segs,
@@ -1718,6 +1787,13 @@ out_of_memory:
 		kfree(info->shadow[i].indirect_grants);
 		info->shadow[i].indirect_grants = NULL;
 	}
+	if (!list_empty(&info->indirect_pages)) {
+		struct page *indirect_page, *n;
+		list_for_each_entry_safe(indirect_page, n, &info->indirect_pages, lru) {
+			list_del(&indirect_page->lru);
+			__free_page(indirect_page);
+		}
+	}
 	return -ENOMEM;
 }
 
-- 
1.7.7.5 (Apple Git-26)

