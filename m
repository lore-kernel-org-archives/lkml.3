Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754800Ab3HAMKN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Aug 2013 08:10:13 -0400
Received: from smtp.eu.citrix.com ([46.33.159.39]:18059 "EHLO
	SMTP.EU.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753662Ab3HAMKL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Aug 2013 08:10:11 -0400
X-IronPort-AV: E=Sophos;i="4.89,793,1367971200"; 
   d="scan'208";a="7363119"
From: Roger Pau Monne <roger.pau@citrix.com>
To: <xen-devel@lists.xen.org>, <linux-kernel@vger.kernel.org>
CC: Roger Pau Monne <roger.pau@citrix.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        David Vrabel <david.vrabel@citrix.com>
Subject: [PATCH] xen-blkback: use bigger array for batch gnt operations
Date: Thu, 1 Aug 2013 14:08:54 +0200
Message-ID: <1375358934-6335-1-git-send-email-roger.pau@citrix.com>
X-Mailer: git-send-email 1.7.7.5 (Apple Git-26)
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Right now the maximum number of grant operations that can be batched
in a single request is BLKIF_MAX_SEGMENTS_PER_REQUEST (11). This was
OK before indirect descriptors because the maximum number of segments
in a request was 11, but with the introduction of indirect
descriptors the maximum number of segments in a request has been
increased past 11.

The memory used by the structures that are passed in the hypercall was
allocated from the stack, but if we have to increase the size of the
array we can no longer use stack memory, so we have to pre-allocate
it.

This patch increases the maximum size of batch grant operations and
replaces the use of stack memory with pre-allocated memory, that is
reserved when the blkback instance is initialized.

Signed-off-by: Roger Pau Monné <roger.pau@citrix.com>
Cc: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Cc: David Vrabel <david.vrabel@citrix.com>
---
 drivers/block/xen-blkback/blkback.c |   29 +++++++++++++++++------------
 drivers/block/xen-blkback/common.h  |    8 ++++++++
 drivers/block/xen-blkback/xenbus.c  |   29 +++++++++++++++++++++++++++++
 3 files changed, 54 insertions(+), 12 deletions(-)

diff --git a/drivers/block/xen-blkback/blkback.c b/drivers/block/xen-blkback/blkback.c
index bf4b9d2..0ddf073 100644
--- a/drivers/block/xen-blkback/blkback.c
+++ b/drivers/block/xen-blkback/blkback.c
@@ -301,11 +301,11 @@ static void free_persistent_gnts(struct xen_blkif *blkif, struct rb_root *root,
 
 static void unmap_purged_grants(struct work_struct *work)
 {
-	struct gnttab_unmap_grant_ref unmap[BLKIF_MAX_SEGMENTS_PER_REQUEST];
-	struct page *pages[BLKIF_MAX_SEGMENTS_PER_REQUEST];
+	struct xen_blkif *blkif = container_of(work, typeof(*blkif), persistent_purge_work);
+	struct gnttab_unmap_grant_ref *unmap = blkif->unmap;
+	struct page **pages = blkif->pages_to_gnt;
 	struct persistent_gnt *persistent_gnt;
 	int ret, segs_to_unmap = 0;
-	struct xen_blkif *blkif = container_of(work, typeof(*blkif), persistent_purge_work);
 
 	while(!list_empty(&blkif->persistent_purge_list)) {
 		persistent_gnt = list_first_entry(&blkif->persistent_purge_list,
@@ -320,7 +320,7 @@ static void unmap_purged_grants(struct work_struct *work)
 
 		pages[segs_to_unmap] = persistent_gnt->page;
 
-		if (++segs_to_unmap == BLKIF_MAX_SEGMENTS_PER_REQUEST) {
+		if (++segs_to_unmap == GNT_OPERATIONS_SIZE) {
 			ret = gnttab_unmap_refs(unmap, NULL, pages,
 				segs_to_unmap);
 			BUG_ON(ret);
@@ -651,10 +651,10 @@ purge_gnt_list:
  */
 static void xen_blkbk_unmap(struct xen_blkif *blkif,
                             struct grant_page *pages[],
+                            struct gnttab_unmap_grant_ref *unmap,
+                            struct page **unmap_pages,
                             int num)
 {
-	struct gnttab_unmap_grant_ref unmap[BLKIF_MAX_SEGMENTS_PER_REQUEST];
-	struct page *unmap_pages[BLKIF_MAX_SEGMENTS_PER_REQUEST];
 	unsigned int i, invcount = 0;
 	int ret;
 
@@ -669,7 +669,7 @@ static void xen_blkbk_unmap(struct xen_blkif *blkif,
 		gnttab_set_unmap_op(&unmap[invcount], vaddr(pages[i]->page),
 				    GNTMAP_host_map, pages[i]->handle);
 		pages[i]->handle = BLKBACK_INVALID_HANDLE;
-		if (++invcount == BLKIF_MAX_SEGMENTS_PER_REQUEST) {
+		if (++invcount == GNT_OPERATIONS_SIZE) {
 			ret = gnttab_unmap_refs(unmap, NULL, unmap_pages,
 			                        invcount);
 			BUG_ON(ret);
@@ -686,10 +686,10 @@ static void xen_blkbk_unmap(struct xen_blkif *blkif,
 
 static int xen_blkbk_map(struct xen_blkif *blkif,
 			 struct grant_page *pages[],
+			 struct gnttab_map_grant_ref *map,
+			 struct page **pages_to_gnt,
 			 int num, bool ro)
 {
-	struct gnttab_map_grant_ref map[BLKIF_MAX_SEGMENTS_PER_REQUEST];
-	struct page *pages_to_gnt[BLKIF_MAX_SEGMENTS_PER_REQUEST];
 	struct persistent_gnt *persistent_gnt = NULL;
 	phys_addr_t addr = 0;
 	int i, seg_idx, new_map_idx;
@@ -735,7 +735,7 @@ again:
 					  blkif->domid);
 		}
 		map_until = i + 1;
-		if (segs_to_map == BLKIF_MAX_SEGMENTS_PER_REQUEST)
+		if (segs_to_map == GNT_OPERATIONS_SIZE)
 			break;
 	}
 
@@ -824,6 +824,7 @@ static int xen_blkbk_map_seg(struct pending_req *pending_req)
 	int rc;
 
 	rc = xen_blkbk_map(pending_req->blkif, pending_req->segments,
+	                   pending_req->map, pending_req->pages_to_gnt,
 			   pending_req->nr_pages,
 	                   (pending_req->operation != BLKIF_OP_READ));
 
@@ -847,7 +848,8 @@ static int xen_blkbk_parse_indirect(struct blkif_request *req,
 	for (i = 0; i < indirect_grefs; i++)
 		pages[i]->gref = req->u.indirect.indirect_grefs[i];
 
-	rc = xen_blkbk_map(blkif, pages, indirect_grefs, true);
+	rc = xen_blkbk_map(blkif, pages, pending_req->map, pending_req->pages_to_gnt,
+	                   indirect_grefs, true);
 	if (rc)
 		goto unmap;
 
@@ -874,7 +876,7 @@ static int xen_blkbk_parse_indirect(struct blkif_request *req,
 unmap:
 	if (segments)
 		kunmap_atomic(segments);
-	xen_blkbk_unmap(blkif, pages, indirect_grefs);
+	xen_blkbk_unmap(blkif, pages, pending_req->unmap, pending_req->pages_to_gnt, indirect_grefs);
 	return rc;
 }
 
@@ -977,6 +979,8 @@ static void __end_block_io_op(struct pending_req *pending_req, int error)
 	if (atomic_dec_and_test(&pending_req->pendcnt)) {
 		xen_blkbk_unmap(pending_req->blkif,
 		                pending_req->segments,
+		                pending_req->unmap,
+		                pending_req->pages_to_gnt,
 		                pending_req->nr_pages);
 		make_response(pending_req->blkif, pending_req->id,
 			      pending_req->operation, pending_req->status);
@@ -1294,6 +1298,7 @@ static int dispatch_rw_block_io(struct xen_blkif *blkif,
 
  fail_flush:
 	xen_blkbk_unmap(blkif, pending_req->segments,
+	                pending_req->unmap, pending_req->pages_to_gnt,
 	                pending_req->nr_pages);
  fail_response:
 	/* Haven't submitted any bio's yet. */
diff --git a/drivers/block/xen-blkback/common.h b/drivers/block/xen-blkback/common.h
index 8d88075..c801d9b 100644
--- a/drivers/block/xen-blkback/common.h
+++ b/drivers/block/xen-blkback/common.h
@@ -56,6 +56,8 @@
  */
 #define MAX_INDIRECT_SEGMENTS 256
 
+#define GNT_OPERATIONS_SIZE 32
+
 #define SEGS_PER_INDIRECT_FRAME \
 	(PAGE_SIZE/sizeof(struct blkif_request_segment_aligned))
 #define MAX_INDIRECT_PAGES \
@@ -291,6 +293,8 @@ struct xen_blkif {
 	/* used by the kworker that offload work from the persistent purge */
 	struct list_head	persistent_purge_list;
 	struct work_struct	persistent_purge_work;
+	struct gnttab_unmap_grant_ref	*unmap;
+	struct page		**pages_to_gnt;
 
 	/* buffer of free pages to map grant refs */
 	spinlock_t		free_pages_lock;
@@ -349,6 +353,10 @@ struct pending_req {
 	struct grant_page	*indirect_pages[MAX_INDIRECT_PAGES];
 	struct seg_buf		seg[MAX_INDIRECT_SEGMENTS];
 	struct bio		*biolist[MAX_INDIRECT_SEGMENTS];
+	/* Used to map/unmap grants in bigger batches */
+	struct gnttab_map_grant_ref	*map;
+	struct gnttab_unmap_grant_ref	*unmap;
+	struct page			**pages_to_gnt;
 };
 
 
diff --git a/drivers/block/xen-blkback/xenbus.c b/drivers/block/xen-blkback/xenbus.c
index 2e5b69d..08ad541 100644
--- a/drivers/block/xen-blkback/xenbus.c
+++ b/drivers/block/xen-blkback/xenbus.c
@@ -128,6 +128,13 @@ static struct xen_blkif *xen_blkif_alloc(domid_t domid)
 	blkif->free_pages_num = 0;
 	atomic_set(&blkif->persistent_gnt_in_use, 0);
 
+	blkif->unmap = kcalloc(GNT_OPERATIONS_SIZE, sizeof(blkif->unmap[0]), GFP_KERNEL);
+	if (!blkif->unmap)
+		goto fail;
+	blkif->pages_to_gnt = kcalloc(GNT_OPERATIONS_SIZE, sizeof(blkif->pages_to_gnt[0]), GFP_KERNEL);
+	if (!blkif->pages_to_gnt)
+		goto fail;
+
 	INIT_LIST_HEAD(&blkif->pending_free);
 
 	for (i = 0; i < XEN_BLKIF_REQS; i++) {
@@ -148,6 +155,16 @@ static struct xen_blkif *xen_blkif_alloc(domid_t domid)
 			if (!req->indirect_pages[j])
 				goto fail;
 		}
+		req->map = kcalloc(GNT_OPERATIONS_SIZE, sizeof(req->map[0]), GFP_KERNEL);
+		if (!req->map)
+			goto fail;
+		req->unmap = kcalloc(GNT_OPERATIONS_SIZE, sizeof(req->unmap[0]), GFP_KERNEL);
+		if (!req->unmap)
+			goto fail;
+		req->pages_to_gnt = kcalloc(GNT_OPERATIONS_SIZE, sizeof(req->pages_to_gnt[0]),
+		                            GFP_KERNEL);
+		if (!req->pages_to_gnt)
+			goto fail;
 	}
 	spin_lock_init(&blkif->pending_free_lock);
 	init_waitqueue_head(&blkif->pending_free_wq);
@@ -168,9 +185,15 @@ fail:
 				break;
 			kfree(req->indirect_pages[j]);
 		}
+		kfree(req->map);
+		kfree(req->unmap);
+		kfree(req->pages_to_gnt);
 		kfree(req);
 	}
 
+	kfree(blkif->unmap);
+	kfree(blkif->pages_to_gnt);
+
 	kmem_cache_free(xen_blkif_cachep, blkif);
 
 	return ERR_PTR(-ENOMEM);
@@ -269,12 +292,18 @@ static void xen_blkif_free(struct xen_blkif *blkif)
 		for (j = 0; j < MAX_INDIRECT_PAGES; j++)
 			kfree(req->indirect_pages[j]);
 
+		kfree(req->map);
+		kfree(req->unmap);
+		kfree(req->pages_to_gnt);
 		kfree(req);
 		i++;
 	}
 
 	WARN_ON(i != XEN_BLKIF_REQS);
 
+	kfree(blkif->unmap);
+	kfree(blkif->pages_to_gnt);
+
 	kmem_cache_free(xen_blkif_cachep, blkif);
 }
 
-- 
1.7.7.5 (Apple Git-26)

