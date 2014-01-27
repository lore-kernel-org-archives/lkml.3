Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753852AbaA0KNq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Jan 2014 05:13:46 -0500
Received: from smtp02.citrix.com ([66.165.176.63]:47066 "EHLO
	SMTP02.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753478AbaA0KNo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Jan 2014 05:13:44 -0500
X-IronPort-AV: E=Sophos;i="4.95,728,1384300800"; 
   d="scan'208";a="94730872"
From: Roger Pau Monne <roger.pau@citrix.com>
To: <xen-devel@lists.xenproject.org>, <linux-kernel@vger.kernel.org>
CC: Roger Pau Monne <roger.pau@citrix.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        David Vrabel <david.vrabel@citrix.com>,
        Boris Ostrovsky <boris.ostrovsky@oracle.com>,
        Matt Rushton <mrushton@amazon.com>, Matt Wilson <msw@amazon.com>,
        Ian Campbell <Ian.Campbell@citrix.com>
Subject: [PATCH] xen-blkback: fix memory leaks
Date: Mon, 27 Jan 2014 11:13:41 +0100
Message-ID: <1390817621-12031-1-git-send-email-roger.pau@citrix.com>
X-Mailer: git-send-email 1.7.7.5 (Apple Git-26)
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-DLP: MIA2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I've at least identified two possible memory leaks in blkback, both
related to the shutdown path of a VBD:

- We don't wait for any pending purge work to finish before cleaning
  the list of free_pages. The purge work will call put_free_pages and
  thus we might end up with pages being added to the free_pages list
  after we have emptied it.
- We don't wait for pending requests to end before cleaning persistent
  grants and the list of free_pages. Again this can add pages to the
  free_pages lists or persistent grants to the persistent_gnts
  red-black tree.

Also, add some checks in xen_blkif_free to make sure we are cleaning
everything.

Signed-off-by: Roger Pau Monné <roger.pau@citrix.com>
Cc: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Cc: David Vrabel <david.vrabel@citrix.com>
Cc: Boris Ostrovsky <boris.ostrovsky@oracle.com>
Cc: Matt Rushton <mrushton@amazon.com>
Cc: Matt Wilson <msw@amazon.com>
Cc: Ian Campbell <Ian.Campbell@citrix.com>
---
This should be applied after the patch:

xen-blkback: fix memory leak when persistent grants are used

>From Matt Rushton & Matt Wilson and backported to stable.

I've been able to create and destroy ~4000 guests while doing heavy IO
operations with this patch on a 512M Dom0 without problems.
---
 drivers/block/xen-blkback/blkback.c |   29 +++++++++++++++++++----------
 drivers/block/xen-blkback/xenbus.c  |    9 +++++++++
 2 files changed, 28 insertions(+), 10 deletions(-)

diff --git a/drivers/block/xen-blkback/blkback.c b/drivers/block/xen-blkback/blkback.c
index 30ef7b3..19925b7 100644
--- a/drivers/block/xen-blkback/blkback.c
+++ b/drivers/block/xen-blkback/blkback.c
@@ -169,6 +169,7 @@ static int dispatch_rw_block_io(struct xen_blkif *blkif,
 				struct pending_req *pending_req);
 static void make_response(struct xen_blkif *blkif, u64 id,
 			  unsigned short op, int st);
+static void xen_blk_drain_io(struct xen_blkif *blkif, bool force);
 
 #define foreach_grant_safe(pos, n, rbtree, node) \
 	for ((pos) = container_of(rb_first((rbtree)), typeof(*(pos)), node), \
@@ -625,6 +626,12 @@ purge_gnt_list:
 			print_stats(blkif);
 	}
 
+	/* Drain pending IO */
+	xen_blk_drain_io(blkif, true);
+
+	/* Drain pending purge work */
+	flush_work(&blkif->persistent_purge_work);
+
 	/* Free all persistent grant pages */
 	if (!RB_EMPTY_ROOT(&blkif->persistent_gnts))
 		free_persistent_gnts(blkif, &blkif->persistent_gnts,
@@ -930,7 +937,7 @@ static int dispatch_other_io(struct xen_blkif *blkif,
 	return -EIO;
 }
 
-static void xen_blk_drain_io(struct xen_blkif *blkif)
+static void xen_blk_drain_io(struct xen_blkif *blkif, bool force)
 {
 	atomic_set(&blkif->drain, 1);
 	do {
@@ -943,7 +950,7 @@ static void xen_blk_drain_io(struct xen_blkif *blkif)
 
 		if (!atomic_read(&blkif->drain))
 			break;
-	} while (!kthread_should_stop());
+	} while (!kthread_should_stop() || force);
 	atomic_set(&blkif->drain, 0);
 }
 
@@ -976,17 +983,19 @@ static void __end_block_io_op(struct pending_req *pending_req, int error)
 	 * the proper response on the ring.
 	 */
 	if (atomic_dec_and_test(&pending_req->pendcnt)) {
-		xen_blkbk_unmap(pending_req->blkif,
+		struct xen_blkif *blkif = pending_req->blkif;
+
+		xen_blkbk_unmap(blkif,
 		                pending_req->segments,
 		                pending_req->nr_pages);
-		make_response(pending_req->blkif, pending_req->id,
+		make_response(blkif, pending_req->id,
 			      pending_req->operation, pending_req->status);
-		xen_blkif_put(pending_req->blkif);
-		if (atomic_read(&pending_req->blkif->refcnt) <= 2) {
-			if (atomic_read(&pending_req->blkif->drain))
-				complete(&pending_req->blkif->drain_complete);
+		free_req(blkif, pending_req);
+		xen_blkif_put(blkif);
+		if (atomic_read(&blkif->refcnt) <= 2) {
+			if (atomic_read(&blkif->drain))
+				complete(&blkif->drain_complete);
 		}
-		free_req(pending_req->blkif, pending_req);
 	}
 }
 
@@ -1224,7 +1233,7 @@ static int dispatch_rw_block_io(struct xen_blkif *blkif,
 	 * issue the WRITE_FLUSH.
 	 */
 	if (drain)
-		xen_blk_drain_io(pending_req->blkif);
+		xen_blk_drain_io(pending_req->blkif, false);
 
 	/*
 	 * If we have failed at this point, we need to undo the M2P override,
diff --git a/drivers/block/xen-blkback/xenbus.c b/drivers/block/xen-blkback/xenbus.c
index c2014a0..3c10281 100644
--- a/drivers/block/xen-blkback/xenbus.c
+++ b/drivers/block/xen-blkback/xenbus.c
@@ -125,6 +125,7 @@ static struct xen_blkif *xen_blkif_alloc(domid_t domid)
 	blkif->persistent_gnts.rb_node = NULL;
 	spin_lock_init(&blkif->free_pages_lock);
 	INIT_LIST_HEAD(&blkif->free_pages);
+	INIT_LIST_HEAD(&blkif->persistent_purge_list);
 	blkif->free_pages_num = 0;
 	atomic_set(&blkif->persistent_gnt_in_use, 0);
 
@@ -259,6 +260,14 @@ static void xen_blkif_free(struct xen_blkif *blkif)
 	if (!atomic_dec_and_test(&blkif->refcnt))
 		BUG();
 
+	/* Make sure everything is drained before shutting down */
+	BUG_ON(blkif->persistent_gnt_c != 0);
+	BUG_ON(atomic_read(&blkif->persistent_gnt_in_use) != 0);
+	BUG_ON(blkif->free_pages_num != 0);
+	BUG_ON(!list_empty(&blkif->persistent_purge_list));
+	BUG_ON(!list_empty(&blkif->free_pages));
+	BUG_ON(!RB_EMPTY_ROOT(&blkif->persistent_gnts));
+
 	/* Check that there is no request in use */
 	list_for_each_entry_safe(req, n, &blkif->pending_free, free_list) {
 		list_del(&req->free_list);
-- 
1.7.7.5 (Apple Git-26)

