Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752332AbaAMTJo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Jan 2014 14:09:44 -0500
Received: from smtp02.citrix.com ([66.165.176.63]:42456 "EHLO
	SMTP02.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751577AbaAMTJk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Jan 2014 14:09:40 -0500
X-IronPort-AV: E=Sophos;i="4.95,654,1384300800"; 
   d="scan'208";a="90295300"
From: Zoltan Kiss <zoltan.kiss@citrix.com>
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Boris Ostrovsky <boris.ostrovsky@oracle.com>,
        David Vrabel <david.vrabel@citrix.com>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, <x86@kernel.org>,
        <xen-devel@lists.xenproject.org>, <linux-kernel@vger.kernel.org>,
        =?UTF-8?q?Roger=20Pau=20Monn=C3=A9?= <roger.pau@citrix.com>,
        Jan Beulich <jbeulich@suse.com>,
        Ian Campbell <Ian.Campbell@citrix.com>
CC: Zoltan Kiss <zoltan.kiss@citrix.com>
Subject: [PATCH v2 2/2] xen/grant-table: Remove kmap_ops
Date: Mon, 13 Jan 2014 19:08:39 +0000
Message-ID: <1389640119-7936-3-git-send-email-zoltan.kiss@citrix.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1389640119-7936-1-git-send-email-zoltan.kiss@citrix.com>
References: <1389640119-7936-1-git-send-email-zoltan.kiss@citrix.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.80.2.133]
X-DLP: MIA1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch updates the function prototypes as kmap_ops is no longer needed.

Signed-off-by: Zoltan Kiss <zoltan.kiss@citrix.com>
Suggested-by: David Vrabel <david.vrabel@citrix.com>
---
 drivers/block/xen-blkback/blkback.c |   15 ++++++---------
 drivers/xen/gntdev.c                |    3 +--
 drivers/xen/grant-table.c           |    2 --
 include/xen/grant_table.h           |    2 --
 4 files changed, 7 insertions(+), 15 deletions(-)

diff --git a/drivers/block/xen-blkback/blkback.c b/drivers/block/xen-blkback/blkback.c
index 6620b73..875025f 100644
--- a/drivers/block/xen-blkback/blkback.c
+++ b/drivers/block/xen-blkback/blkback.c
@@ -285,8 +285,7 @@ static void free_persistent_gnts(struct xen_blkif *blkif, struct rb_root *root,
 
 		if (++segs_to_unmap == BLKIF_MAX_SEGMENTS_PER_REQUEST ||
 			!rb_next(&persistent_gnt->node)) {
-			ret = gnttab_unmap_refs(unmap, NULL, pages,
-				segs_to_unmap);
+			ret = gnttab_unmap_refs(unmap, pages, segs_to_unmap);
 			BUG_ON(ret);
 			put_free_pages(blkif, pages, segs_to_unmap);
 			segs_to_unmap = 0;
@@ -321,8 +320,7 @@ static void unmap_purged_grants(struct work_struct *work)
 		pages[segs_to_unmap] = persistent_gnt->page;
 
 		if (++segs_to_unmap == BLKIF_MAX_SEGMENTS_PER_REQUEST) {
-			ret = gnttab_unmap_refs(unmap, NULL, pages,
-				segs_to_unmap);
+			ret = gnttab_unmap_refs(unmap, pages, segs_to_unmap);
 			BUG_ON(ret);
 			put_free_pages(blkif, pages, segs_to_unmap);
 			segs_to_unmap = 0;
@@ -330,7 +328,7 @@ static void unmap_purged_grants(struct work_struct *work)
 		kfree(persistent_gnt);
 	}
 	if (segs_to_unmap > 0) {
-		ret = gnttab_unmap_refs(unmap, NULL, pages, segs_to_unmap);
+		ret = gnttab_unmap_refs(unmap, pages, segs_to_unmap);
 		BUG_ON(ret);
 		put_free_pages(blkif, pages, segs_to_unmap);
 	}
@@ -670,15 +668,14 @@ static void xen_blkbk_unmap(struct xen_blkif *blkif,
 				    GNTMAP_host_map, pages[i]->handle);
 		pages[i]->handle = BLKBACK_INVALID_HANDLE;
 		if (++invcount == BLKIF_MAX_SEGMENTS_PER_REQUEST) {
-			ret = gnttab_unmap_refs(unmap, NULL, unmap_pages,
-			                        invcount);
+			ret = gnttab_unmap_refs(unmap, unmap_pages, invcount);
 			BUG_ON(ret);
 			put_free_pages(blkif, unmap_pages, invcount);
 			invcount = 0;
 		}
 	}
 	if (invcount) {
-		ret = gnttab_unmap_refs(unmap, NULL, unmap_pages, invcount);
+		ret = gnttab_unmap_refs(unmap, unmap_pages, invcount);
 		BUG_ON(ret);
 		put_free_pages(blkif, unmap_pages, invcount);
 	}
@@ -740,7 +737,7 @@ again:
 	}
 
 	if (segs_to_map) {
-		ret = gnttab_map_refs(map, NULL, pages_to_gnt, segs_to_map);
+		ret = gnttab_map_refs(map, pages_to_gnt, segs_to_map);
 		BUG_ON(ret);
 	}
 
diff --git a/drivers/xen/gntdev.c b/drivers/xen/gntdev.c
index b89aaa2..3a97342 100644
--- a/drivers/xen/gntdev.c
+++ b/drivers/xen/gntdev.c
@@ -287,7 +287,7 @@ static int map_grant_pages(struct grant_map *map)
 	}
 
 	pr_debug("map %d+%d\n", map->index, map->count);
-	err = gnttab_map_refs(map->map_ops, NULL, map->pages, map->count);
+	err = gnttab_map_refs(map->map_ops, map->pages, map->count);
 	if (err)
 		return err;
 
@@ -349,7 +349,6 @@ static int __unmap_grant_pages(struct grant_map *map, int offset, int pages)
 	}
 
 	err = gnttab_unmap_refs(map->unmap_ops + offset,
-				NULL,
 				map->pages + offset,
 				pages);
 	if (err)
diff --git a/drivers/xen/grant-table.c b/drivers/xen/grant-table.c
index ad281e4..1471b5f 100644
--- a/drivers/xen/grant-table.c
+++ b/drivers/xen/grant-table.c
@@ -881,7 +881,6 @@ void gnttab_batch_copy(struct gnttab_copy *batch, unsigned count)
 EXPORT_SYMBOL_GPL(gnttab_batch_copy);
 
 int gnttab_map_refs(struct gnttab_map_grant_ref *map_ops,
-		    struct gnttab_map_grant_ref *kmap_ops,
 		    struct page **pages, unsigned int count)
 {
 	int i, ret;
@@ -930,7 +929,6 @@ int gnttab_map_refs(struct gnttab_map_grant_ref *map_ops,
 EXPORT_SYMBOL_GPL(gnttab_map_refs);
 
 int gnttab_unmap_refs(struct gnttab_unmap_grant_ref *unmap_ops,
-		      struct gnttab_map_grant_ref *kmap_ops,
 		      struct page **pages, unsigned int count)
 {
 	int i, ret;
diff --git a/include/xen/grant_table.h b/include/xen/grant_table.h
index 694dcaf..93d363a 100644
--- a/include/xen/grant_table.h
+++ b/include/xen/grant_table.h
@@ -184,10 +184,8 @@ unsigned int gnttab_max_grant_frames(void);
 #define gnttab_map_vaddr(map) ((void *)(map.host_virt_addr))
 
 int gnttab_map_refs(struct gnttab_map_grant_ref *map_ops,
-		    struct gnttab_map_grant_ref *kmap_ops,
 		    struct page **pages, unsigned int count);
 int gnttab_unmap_refs(struct gnttab_unmap_grant_ref *unmap_ops,
-		      struct gnttab_map_grant_ref *kunmap_ops,
 		      struct page **pages, unsigned int count);
 
 /* Perform a batch of grant map/copy operations. Retry every batch slot
