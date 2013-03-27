Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751303Ab3C0LNz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Mar 2013 07:13:55 -0400
Received: from smtp.eu.citrix.com ([46.33.159.39]:22412 "EHLO
	SMTP.EU.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752135Ab3C0LM0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Mar 2013 07:12:26 -0400
X-IronPort-AV: E=Sophos;i="4.84,917,1355097600"; 
   d="scan'208";a="2955626"
From: Roger Pau Monne <roger.pau@citrix.com>
To: <linux-kernel@vger.kernel.org>, <xen-devel@lists.xen.org>
CC: Roger Pau Monne <roger.pau@citrix.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Subject: [PATCH v1 6/7] xen-blkback: expand map/unmap functions
Date: Wed, 27 Mar 2013 12:10:42 +0100
Message-ID: <1364382643-3711-7-git-send-email-roger.pau@citrix.com>
X-Mailer: git-send-email 1.7.7.5 (Apple Git-26)
In-Reply-To: <1364382643-3711-1-git-send-email-roger.pau@citrix.com>
References: <1364382643-3711-1-git-send-email-roger.pau@citrix.com>
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
 drivers/block/xen-blkback/blkback.c |  133 ++++++++++++++++++++++-------------
 1 files changed, 84 insertions(+), 49 deletions(-)

diff --git a/drivers/block/xen-blkback/blkback.c b/drivers/block/xen-blkback/blkback.c
index a1c9dad..f8c838e 100644
--- a/drivers/block/xen-blkback/blkback.c
+++ b/drivers/block/xen-blkback/blkback.c
@@ -181,10 +181,6 @@ static inline void shrink_free_pagepool(struct xen_blkif *blkif, int num)
 
 #define vaddr(page) ((unsigned long)pfn_to_kaddr(page_to_pfn(page)))
 
-#define pending_handle(_req, _seg) \
-	(_req->grant_handles[_seg])
-
-
 static int do_block_io_op(struct xen_blkif *blkif);
 static int dispatch_rw_block_io(struct xen_blkif *blkif,
 				struct blkif_request *req,
@@ -643,50 +639,57 @@ struct seg_buf {
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
 	int i, j;
-	int nseg = req->u.rw.nr_segments;
 	int segs_to_map = 0;
 	int ret = 0;
+	int last_map = 0, map_until = 0;
 	int use_persistent_gnts;
 
 	use_persistent_gnts = (blkif->vbd.feature_gnt_persistent);
@@ -696,13 +699,14 @@ static int xen_blkbk_map(struct blkif_request *req,
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
@@ -718,13 +722,15 @@ static int xen_blkbk_map(struct blkif_request *req,
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
@@ -737,22 +743,20 @@ static int xen_blkbk_map(struct blkif_request *req,
 	 * so that when we access vaddr(pending_req,i) it has the contents of
 	 * the page from the other domain.
 	 */
-	for (i = 0, j = 0; i < nseg; i++) {
+	for (i = last_map, j = 0; i < map_until; i++) {
 		if (!persistent_gnts[i]) {
 			/* This is a newly mapped grant */
 			BUG_ON(j >= segs_to_map);
 			if (unlikely(map[j].status != 0)) {
 				pr_debug(DRV_PFX "invalid buffer -- could not remap it\n");
-				pending_handle(pending_req, i) =
-					BLKBACK_INVALID_HANDLE;
+				handles[i] = BLKBACK_INVALID_HANDLE;
 				ret |= 1;
-				j++;
-				continue;
+				goto next;
 			}
-			pending_handle(pending_req, i) = map[j].handle;
+			handles[i] = map[j].handle;
 		}
 		if (persistent_gnts[i])
-			goto next;
+			continue;
 		if (use_persistent_gnts &&
 		    blkif->persistent_gnt_c < xen_blkif_max_pgrants) {
 			/*
@@ -767,7 +771,6 @@ static int xen_blkbk_map(struct blkif_request *req,
 				 * allocate the persistent_gnt struct
 				 * map this grant non-persistenly
 				 */
-				j++;
 				goto next;
 			}
 			persistent_gnt->gnt = map[j].ref;
@@ -776,14 +779,12 @@ static int xen_blkbk_map(struct blkif_request *req,
 			if (add_persistent_gnt(blkif,
 			                       persistent_gnt)) {
 				kfree(persistent_gnt);
-				j++;
 				goto next;
 			}
 			persistent_gnts[i] = persistent_gnt;
 			pr_debug(DRV_PFX " grant %u added to the tree of persistent grants, using %u/%u\n",
 				 persistent_gnt->gnt, blkif->persistent_gnt_c,
 				 xen_blkif_max_pgrants);
-			j++;
 			goto next;
 		}
 		if (use_persistent_gnts && !blkif->vbd.overflow_max_grants) {
@@ -791,10 +792,14 @@ static int xen_blkbk_map(struct blkif_request *req,
 			pr_debug(DRV_PFX " domain %u, device %#x is using maximum number of persistent grants\n",
 			         blkif->domid, blkif->vbd.handle);
 		}
-		j++;
 next:
-		seg[i].offset = (req->u.rw.seg[i].first_sect << 9);
+		j++;
 	}
+	segs_to_map = 0;
+	last_map = map_until;
+	if (map_until != num)
+		goto again;
+
 	return ret;
 
 out_of_memory:
@@ -803,6 +808,31 @@ out_of_memory:
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
@@ -889,7 +919,10 @@ static void __end_block_io_op(struct pending_req *pending_req, int error)
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
@@ -1111,7 +1144,7 @@ static int dispatch_rw_block_io(struct xen_blkif *blkif,
 	 * the hypercall to unmap the grants - that is all done in
 	 * xen_blkbk_unmap.
 	 */
-	if (xen_blkbk_map(req, pending_req, seg, pages))
+	if (xen_blkbk_map_seg(req, pending_req, seg, pages))
 		goto fail_flush;
 
 	/*
@@ -1172,7 +1205,9 @@ static int dispatch_rw_block_io(struct xen_blkif *blkif,
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

