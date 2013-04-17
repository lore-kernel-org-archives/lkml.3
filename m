Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966574Ab3DQSVn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Apr 2013 14:21:43 -0400
Received: from smtp.eu.citrix.com ([46.33.159.39]:56484 "EHLO
	SMTP.EU.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S966419Ab3DQSUY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Apr 2013 14:20:24 -0400
X-IronPort-AV: E=Sophos;i="4.87,495,1363132800"; 
   d="scan'208";a="3662953"
From: Roger Pau Monne <roger.pau@citrix.com>
To: <linux-kernel@vger.kernel.org>, <xen-devel@lists.xen.org>
CC: Roger Pau Monne <roger.pau@citrix.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Subject: [PATCH v2 6/7] xen-blkback: expand map/unmap functions
Date: Wed, 17 Apr 2013 20:19:00 +0200
Message-ID: <1366222741-39902-7-git-send-email-roger.pau@citrix.com>
X-Mailer: git-send-email 1.7.7.5 (Apple Git-26)
In-Reply-To: <1366222741-39902-1-git-send-email-roger.pau@citrix.com>
References: <1366222741-39902-1-git-send-email-roger.pau@citrix.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Preparatory change for implementing indirect descriptors. Change
xen_blkbk_{map/unmap} in order to be able to map/unmap a random amount
of grants (previously it was limited to
BLKIF_MAX_SEGMENTS_PER_REQUEST). Also, remove the usage of pending_req
in the map/unmap functions, so we can map/unmap grants without needing
to pass a pending_req.

Signed-off-by: Roger Pau Monné <roger.pau@citrix.com>
Cc: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Cc: xen-devel@lists.xen.org
---
 drivers/block/xen-blkback/blkback.c |  141 +++++++++++++++++++++--------------
 1 files changed, 86 insertions(+), 55 deletions(-)

diff --git a/drivers/block/xen-blkback/blkback.c b/drivers/block/xen-blkback/blkback.c
index 90a5755..356722f 100644
--- a/drivers/block/xen-blkback/blkback.c
+++ b/drivers/block/xen-blkback/blkback.c
@@ -163,10 +163,6 @@ static inline void shrink_free_pagepool(struct xen_blkif *blkif, int num)
 
 #define vaddr(page) ((unsigned long)pfn_to_kaddr(page_to_pfn(page)))
 
-#define pending_handle(_req, _seg) \
-	(_req->grant_handles[_seg])
-
-
 static int do_block_io_op(struct xen_blkif *blkif);
 static int dispatch_rw_block_io(struct xen_blkif *blkif,
 				struct blkif_request *req,
@@ -648,50 +644,57 @@ struct seg_buf {
  * Unmap the grant references, and also remove the M2P over-rides
  * used in the 'pending_req'.
  */
-static void xen_blkbk_unmap(struct pending_req *req)
+static void xen_blkbk_unmap(struct xen_blkif *blkif,
+                            grant_handle_t handles[],
+                            struct page *pages[],
+                            struct persistent_gnt *persistent_gnts[],
+                            int num)
 {
 	struct gnttab_unmap_grant_ref unmap[BLKIF_MAX_SEGMENTS_PER_REQUEST];
-	struct page *pages[BLKIF_MAX_SEGMENTS_PER_REQUEST];
+	struct page *unmap_pages[BLKIF_MAX_SEGMENTS_PER_REQUEST];
 	unsigned int i, invcount = 0;
-	grant_handle_t handle;
-	struct xen_blkif *blkif = req->blkif;
 	int ret;
 
-	for (i = 0; i < req->nr_pages; i++) {
-		if (req->persistent_gnts[i] != NULL) {
-			put_persistent_gnt(blkif, req->persistent_gnts[i]);
+	for (i = 0; i < num; i++) {
+		if (persistent_gnts[i] != NULL) {
+			put_persistent_gnt(blkif, persistent_gnts[i]);
 			continue;
 		}
-		handle = pending_handle(req, i);
-		pages[invcount] = req->pages[i];
-		if (handle == BLKBACK_INVALID_HANDLE)
+		if (handles[i] == BLKBACK_INVALID_HANDLE)
 			continue;
-		gnttab_set_unmap_op(&unmap[invcount], vaddr(pages[invcount]),
-				    GNTMAP_host_map, handle);
-		pending_handle(req, i) = BLKBACK_INVALID_HANDLE;
-		invcount++;
+		unmap_pages[invcount] = pages[i];
+		gnttab_set_unmap_op(&unmap[invcount], vaddr(pages[i]),
+				    GNTMAP_host_map, handles[i]);
+		handles[i] = BLKBACK_INVALID_HANDLE;
+		if (++invcount == BLKIF_MAX_SEGMENTS_PER_REQUEST) {
+			ret = gnttab_unmap_refs(unmap, NULL, unmap_pages,
+			                        invcount);
+			BUG_ON(ret);
+			put_free_pages(blkif, unmap_pages, invcount);
+			invcount = 0;
+		}
+	}
+	if (invcount) {
+		ret = gnttab_unmap_refs(unmap, NULL, unmap_pages, invcount);
+		BUG_ON(ret);
+		put_free_pages(blkif, unmap_pages, invcount);
 	}
-
-	ret = gnttab_unmap_refs(unmap, NULL, pages, invcount);
-	BUG_ON(ret);
-	put_free_pages(blkif, pages, invcount);
 }
 
-static int xen_blkbk_map(struct blkif_request *req,
-			 struct pending_req *pending_req,
-			 struct seg_buf seg[],
-			 struct page *pages[])
+static int xen_blkbk_map(struct xen_blkif *blkif, grant_ref_t grefs[],
+			 struct persistent_gnt *persistent_gnts[],
+			 grant_handle_t handles[],
+			 struct page *pages[],
+			 int num, bool ro)
 {
 	struct gnttab_map_grant_ref map[BLKIF_MAX_SEGMENTS_PER_REQUEST];
 	struct page *pages_to_gnt[BLKIF_MAX_SEGMENTS_PER_REQUEST];
-	struct persistent_gnt **persistent_gnts = pending_req->persistent_gnts;
 	struct persistent_gnt *persistent_gnt = NULL;
-	struct xen_blkif *blkif = pending_req->blkif;
 	phys_addr_t addr = 0;
 	int i, seg_idx, new_map_idx;
-	int nseg = req->u.rw.nr_segments;
 	int segs_to_map = 0;
 	int ret = 0;
+	int last_map = 0, map_until = 0;
 	int use_persistent_gnts;
 
 	use_persistent_gnts = (blkif->vbd.feature_gnt_persistent);
@@ -701,13 +704,14 @@ static int xen_blkbk_map(struct blkif_request *req,
 	 * assign map[..] with the PFN of the page in our domain with the
 	 * corresponding grant reference for each page.
 	 */
-	for (i = 0; i < nseg; i++) {
+again:
+	for (i = map_until; i < num; i++) {
 		uint32_t flags;
 
 		if (use_persistent_gnts)
 			persistent_gnt = get_persistent_gnt(
 				blkif,
-				req->u.rw.seg[i].gref);
+				grefs[i]);
 
 		if (persistent_gnt) {
 			/*
@@ -723,13 +727,15 @@ static int xen_blkbk_map(struct blkif_request *req,
 			pages_to_gnt[segs_to_map] = pages[i];
 			persistent_gnts[i] = NULL;
 			flags = GNTMAP_host_map;
-			if (!use_persistent_gnts &&
-			    (pending_req->operation != BLKIF_OP_READ))
+			if (!use_persistent_gnts && ro)
 				flags |= GNTMAP_readonly;
 			gnttab_set_map_op(&map[segs_to_map++], addr,
-					  flags, req->u.rw.seg[i].gref,
+					  flags, grefs[i],
 					  blkif->domid);
 		}
+		map_until = i + 1;
+		if (segs_to_map == BLKIF_MAX_SEGMENTS_PER_REQUEST)
+			break;
 	}
 
 	if (segs_to_map) {
@@ -742,26 +748,19 @@ static int xen_blkbk_map(struct blkif_request *req,
 	 * so that when we access vaddr(pending_req,i) it has the contents of
 	 * the page from the other domain.
 	 */
-	for (seg_idx = 0, new_map_idx = 0; seg_idx < nseg; seg_idx++) {
+	for (seg_idx = last_map, new_map_idx = 0; seg_idx < map_until; seg_idx++) {
 		if (!persistent_gnts[seg_idx]) {
 			/* This is a newly mapped grant */
 			BUG_ON(new_map_idx >= segs_to_map);
 			if (unlikely(map[new_map_idx].status != 0)) {
 				pr_debug(DRV_PFX "invalid buffer -- could not remap it\n");
-				pending_handle(pending_req, seg_idx) = BLKBACK_INVALID_HANDLE;
+				handles[seg_idx] = BLKBACK_INVALID_HANDLE;
 				ret |= 1;
-				new_map_idx++;
-				/*
-				 * No need to set unmap_seg bit, since
-				 * we can not unmap this grant because
-				 * the handle is invalid.
-				 */
-				continue;
+				goto next;
 			}
-			pending_handle(pending_req, seg_idx) = map[new_map_idx].handle;
+			handles[seg_idx] = map[new_map_idx].handle;
 		} else {
-			/* This grant is persistent and already mapped */
-			goto next;
+			continue;
 		}
 		if (use_persistent_gnts &&
 		    blkif->persistent_gnt_c < xen_blkif_max_pgrants) {
@@ -777,7 +776,7 @@ static int xen_blkbk_map(struct blkif_request *req,
 				 * allocate the persistent_gnt struct
 				 * map this grant non-persistenly
 				 */
-				goto next_unmap;
+				goto next;
 			}
 			persistent_gnt->gnt = map[new_map_idx].ref;
 			persistent_gnt->handle = map[new_map_idx].handle;
@@ -786,13 +785,12 @@ static int xen_blkbk_map(struct blkif_request *req,
 			                       persistent_gnt)) {
 				kfree(persistent_gnt);
 				persistent_gnt = NULL;
-				goto next_unmap;
+				goto next;
 			}
 			persistent_gnts[seg_idx] = persistent_gnt;
 			pr_debug(DRV_PFX " grant %u added to the tree of persistent grants, using %u/%u\n",
 				 persistent_gnt->gnt, blkif->persistent_gnt_c,
 				 xen_blkif_max_pgrants);
-			new_map_idx++;
 			goto next;
 		}
 		if (use_persistent_gnts && !blkif->vbd.overflow_max_grants) {
@@ -800,15 +798,18 @@ static int xen_blkbk_map(struct blkif_request *req,
 			pr_debug(DRV_PFX " domain %u, device %#x is using maximum number of persistent grants\n",
 			         blkif->domid, blkif->vbd.handle);
 		}
-next_unmap:
 		/*
 		 * We could not map this grant persistently, so use it as
 		 * a non-persistent grant.
 		 */
-		new_map_idx++;
 next:
-		seg[seg_idx].offset = (req->u.rw.seg[seg_idx].first_sect << 9);
+		new_map_idx++;
 	}
+	segs_to_map = 0;
+	last_map = map_until;
+	if (map_until != num)
+		goto again;
+
 	return ret;
 
 out_of_memory:
@@ -817,6 +818,31 @@ out_of_memory:
 	return -ENOMEM;
 }
 
+static int xen_blkbk_map_seg(struct blkif_request *req,
+			     struct pending_req *pending_req,
+			     struct seg_buf seg[],
+			     struct page *pages[])
+{
+	int i, rc;
+	grant_ref_t grefs[BLKIF_MAX_SEGMENTS_PER_REQUEST];
+
+	for (i = 0; i < req->u.rw.nr_segments; i++)
+		grefs[i] = req->u.rw.seg[i].gref;
+
+	rc = xen_blkbk_map(pending_req->blkif, grefs,
+	                   pending_req->persistent_gnts,
+	                   pending_req->grant_handles, pending_req->pages,
+	                   req->u.rw.nr_segments,
+	                   (pending_req->operation != BLKIF_OP_READ));
+	if (rc)
+		return rc;
+
+	for (i = 0; i < req->u.rw.nr_segments; i++)
+		seg[i].offset = (req->u.rw.seg[i].first_sect << 9);
+
+	return 0;
+}
+
 static int dispatch_discard_io(struct xen_blkif *blkif,
 				struct blkif_request *req)
 {
@@ -903,7 +929,10 @@ static void __end_block_io_op(struct pending_req *pending_req, int error)
 	 * the proper response on the ring.
 	 */
 	if (atomic_dec_and_test(&pending_req->pendcnt)) {
-		xen_blkbk_unmap(pending_req);
+		xen_blkbk_unmap(pending_req->blkif, pending_req->grant_handles,
+		                pending_req->pages,
+		                pending_req->persistent_gnts,
+		                pending_req->nr_pages);
 		make_response(pending_req->blkif, pending_req->id,
 			      pending_req->operation, pending_req->status);
 		xen_blkif_put(pending_req->blkif);
@@ -1125,7 +1154,7 @@ static int dispatch_rw_block_io(struct xen_blkif *blkif,
 	 * the hypercall to unmap the grants - that is all done in
 	 * xen_blkbk_unmap.
 	 */
-	if (xen_blkbk_map(req, pending_req, seg, pages))
+	if (xen_blkbk_map_seg(req, pending_req, seg, pages))
 		goto fail_flush;
 
 	/*
@@ -1186,7 +1215,9 @@ static int dispatch_rw_block_io(struct xen_blkif *blkif,
 	return 0;
 
  fail_flush:
-	xen_blkbk_unmap(pending_req);
+	xen_blkbk_unmap(blkif, pending_req->grant_handles,
+	                pending_req->pages, pending_req->persistent_gnts,
+	                pending_req->nr_pages);
  fail_response:
 	/* Haven't submitted any bio's yet. */
 	make_response(blkif, req->u.rw.id, req->operation, BLKIF_RSP_ERROR);
-- 
1.7.7.5 (Apple Git-26)

