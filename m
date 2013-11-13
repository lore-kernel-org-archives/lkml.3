Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756058Ab3KMBtN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Nov 2013 20:49:13 -0500
Received: from mail-pb0-f41.google.com ([209.85.160.41]:56069 "EHLO
	mail-pb0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754057Ab3KMBtB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Nov 2013 20:49:01 -0500
From: Anthony Liguori <anthony@codemonkey.ws>
To: xen-devel@lists.xen.org
Cc: Matt Wilson <msw@amazon.com>,
        Stefano Stabellini <stefano.stabellini@eu.citrix.com>,
        David Vrabel <david.vrabel@citrix.com>,
        Roger Pau Monne <roger.pau@citrix.com>, linux-kernel@vger.kernel.org,
        Konrad Wilk <konrad.wilk@oracle.com>,
        Anthony Liguori <aliguori@amazon.com>
Subject: [PATCH] xen-gnttab: do not add m2p override entries for blkback mappings
Date: Tue, 12 Nov 2013 17:48:56 -0800
Message-Id: <1384307336-5328-1-git-send-email-anthony@codemonkey.ws>
X-Mailer: git-send-email 1.8.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Anthony Liguori <aliguori@amazon.com>

Commit 5dc03639 switched blkback to also add m2p override entries
when mapping grant pages but history seems to have forgotten why
this is useful if it ever was.

The blkback driver does not need m2p override entries to exist
and there is significant overhead due to the locking in the m2p
override table.  We see about a 10% improvement in IOP rate with
this patch applied running FIO in the guest.

See http://article.gmane.org/gmane.linux.kernel/1590932 for a full
analysis of current users.

Signed-off-by: Anthony Liguori <aliguori@amazon.com>
---
A backported version of this has been heavily tested but the testing
against the latest Linux tree is light so far.
---
 drivers/block/xen-blkback/blkback.c |   12 ++++-----
 drivers/xen/gntdev.c                |    4 +--
 drivers/xen/grant-table.c           |   49 ++++++++++++++++++++++++++++-------
 include/xen/grant_table.h           |   14 ++++++++--
 4 files changed, 59 insertions(+), 20 deletions(-)

diff --git a/drivers/block/xen-blkback/blkback.c b/drivers/block/xen-blkback/blkback.c
index bf4b9d2..53ea90e 100644
--- a/drivers/block/xen-blkback/blkback.c
+++ b/drivers/block/xen-blkback/blkback.c
@@ -286,7 +286,7 @@ static void free_persistent_gnts(struct xen_blkif *blkif, struct rb_root *root,
 		if (++segs_to_unmap == BLKIF_MAX_SEGMENTS_PER_REQUEST ||
 			!rb_next(&persistent_gnt->node)) {
 			ret = gnttab_unmap_refs(unmap, NULL, pages,
-				segs_to_unmap);
+						segs_to_unmap, 0);
 			BUG_ON(ret);
 			put_free_pages(blkif, pages, segs_to_unmap);
 			segs_to_unmap = 0;
@@ -322,7 +322,7 @@ static void unmap_purged_grants(struct work_struct *work)
 
 		if (++segs_to_unmap == BLKIF_MAX_SEGMENTS_PER_REQUEST) {
 			ret = gnttab_unmap_refs(unmap, NULL, pages,
-				segs_to_unmap);
+						segs_to_unmap, 0);
 			BUG_ON(ret);
 			put_free_pages(blkif, pages, segs_to_unmap);
 			segs_to_unmap = 0;
@@ -330,7 +330,7 @@ static void unmap_purged_grants(struct work_struct *work)
 		kfree(persistent_gnt);
 	}
 	if (segs_to_unmap > 0) {
-		ret = gnttab_unmap_refs(unmap, NULL, pages, segs_to_unmap);
+		ret = gnttab_unmap_refs(unmap, NULL, pages, segs_to_unmap, 0);
 		BUG_ON(ret);
 		put_free_pages(blkif, pages, segs_to_unmap);
 	}
@@ -671,14 +671,14 @@ static void xen_blkbk_unmap(struct xen_blkif *blkif,
 		pages[i]->handle = BLKBACK_INVALID_HANDLE;
 		if (++invcount == BLKIF_MAX_SEGMENTS_PER_REQUEST) {
 			ret = gnttab_unmap_refs(unmap, NULL, unmap_pages,
-			                        invcount);
+			                        invcount, 0);
 			BUG_ON(ret);
 			put_free_pages(blkif, unmap_pages, invcount);
 			invcount = 0;
 		}
 	}
 	if (invcount) {
-		ret = gnttab_unmap_refs(unmap, NULL, unmap_pages, invcount);
+		ret = gnttab_unmap_refs(unmap, NULL, unmap_pages, invcount, 0);
 		BUG_ON(ret);
 		put_free_pages(blkif, unmap_pages, invcount);
 	}
@@ -740,7 +740,7 @@ again:
 	}
 
 	if (segs_to_map) {
-		ret = gnttab_map_refs(map, NULL, pages_to_gnt, segs_to_map);
+		ret = gnttab_map_refs(map, NULL, pages_to_gnt, segs_to_map, 0);
 		BUG_ON(ret);
 	}
 
diff --git a/drivers/xen/gntdev.c b/drivers/xen/gntdev.c
index e41c79c..9ab1792 100644
--- a/drivers/xen/gntdev.c
+++ b/drivers/xen/gntdev.c
@@ -285,7 +285,7 @@ static int map_grant_pages(struct grant_map *map)
 
 	pr_debug("map %d+%d\n", map->index, map->count);
 	err = gnttab_map_refs(map->map_ops, use_ptemod ? map->kmap_ops : NULL,
-			map->pages, map->count);
+			      map->pages, map->count, 1);
 	if (err)
 		return err;
 
@@ -317,7 +317,7 @@ static int __unmap_grant_pages(struct grant_map *map, int offset, int pages)
 
 	err = gnttab_unmap_refs(map->unmap_ops + offset,
 			use_ptemod ? map->kmap_ops + offset : NULL, map->pages + offset,
-			pages);
+			pages, 1);
 	if (err)
 		return err;
 
diff --git a/drivers/xen/grant-table.c b/drivers/xen/grant-table.c
index c4d2298..081be8d 100644
--- a/drivers/xen/grant-table.c
+++ b/drivers/xen/grant-table.c
@@ -881,7 +881,8 @@ EXPORT_SYMBOL_GPL(gnttab_batch_copy);
 
 int gnttab_map_refs(struct gnttab_map_grant_ref *map_ops,
 		    struct gnttab_map_grant_ref *kmap_ops,
-		    struct page **pages, unsigned int count)
+		    struct page **pages, unsigned int count,
+		    int override)
 {
 	int i, ret;
 	bool lazy = false;
@@ -918,10 +919,29 @@ int gnttab_map_refs(struct gnttab_map_grant_ref *map_ops,
 		} else {
 			mfn = PFN_DOWN(map_ops[i].dev_bus_addr);
 		}
-		ret = m2p_add_override(mfn, pages[i], kmap_ops ?
-				       &kmap_ops[i] : NULL);
-		if (ret)
-			return ret;
+
+		if (override) {
+			ret = m2p_add_override(mfn, pages[i], kmap_ops ?
+					       &kmap_ops[i] : NULL);
+			if (ret)
+				return ret;
+		} else {
+			unsigned long pfn, old_mfn;
+
+			pfn = page_to_pfn(pages[i]);
+			old_mfn = pfn_to_mfn(pfn);
+
+			/* Save previous MFN in page private*/
+			WARN_ON(PagePrivate(pages[i]));
+			SetPagePrivate(pages[i]);
+			set_page_private(pages[i], old_mfn);
+
+			if (!set_phys_to_machine(pfn, FOREIGN_FRAME(mfn))) {
+				ret = -ENOMEM;
+				break;
+			}
+		}
+			
 	}
 
 	if (lazy)
@@ -933,7 +953,8 @@ EXPORT_SYMBOL_GPL(gnttab_map_refs);
 
 int gnttab_unmap_refs(struct gnttab_unmap_grant_ref *unmap_ops,
 		      struct gnttab_map_grant_ref *kmap_ops,
-		      struct page **pages, unsigned int count)
+		      struct page **pages, unsigned int count,
+		      int override)
 {
 	int i, ret;
 	bool lazy = false;
@@ -951,10 +972,18 @@ int gnttab_unmap_refs(struct gnttab_unmap_grant_ref *unmap_ops,
 	}
 
 	for (i = 0; i < count; i++) {
-		ret = m2p_remove_override(pages[i], kmap_ops ?
-				       &kmap_ops[i] : NULL);
-		if (ret)
-			return ret;
+		if (override) {
+			ret = m2p_remove_override(pages[i], kmap_ops ?
+						  &kmap_ops[i] : NULL);
+			if (ret)
+				return ret;
+		} else {
+			/* Restore saved MFN */
+			WARN_ON(!PagePrivate(pages[i]));
+			set_phys_to_machine(page_to_pfn(pages[i]),
+					    page_private(pages[i]));
+			ClearPagePrivate(pages[i]);
+		}
 	}
 
 	if (lazy)
diff --git a/include/xen/grant_table.h b/include/xen/grant_table.h
index 694dcaf..7fcb960 100644
--- a/include/xen/grant_table.h
+++ b/include/xen/grant_table.h
@@ -183,12 +183,22 @@ unsigned int gnttab_max_grant_frames(void);
 
 #define gnttab_map_vaddr(map) ((void *)(map.host_virt_addr))
 
+/* override is used to add m2p override table entries when mapping the
+ * grant references.  Currently there are only two callers to this function,
+ * blkback and gntdev.  gntdev needs all grant mappings to have corresponding
+ * m2p override table entries but blkback currently doesn't.  This is because
+ * blkback can gracefully handle the case where m2p(p2m(pfn)) fails with
+ * foreign pfns.  If you cannot handle this correctly, you need to set
+ * override 1 when calling the map and unmap functions.
+ */
 int gnttab_map_refs(struct gnttab_map_grant_ref *map_ops,
 		    struct gnttab_map_grant_ref *kmap_ops,
-		    struct page **pages, unsigned int count);
+		    struct page **pages, unsigned int count,
+		    int override);
 int gnttab_unmap_refs(struct gnttab_unmap_grant_ref *unmap_ops,
 		      struct gnttab_map_grant_ref *kunmap_ops,
-		      struct page **pages, unsigned int count);
+		      struct page **pages, unsigned int count,
+		      int override);
 
 /* Perform a batch of grant map/copy operations. Retry every batch slot
  * for which the hypervisor returns GNTST_eagain. This is typically due
-- 
1.7.9.5

