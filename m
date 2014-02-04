Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754071AbaBDK0k (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Feb 2014 05:26:40 -0500
Received: from smtp.citrix.com ([66.165.176.89]:37501 "EHLO SMTP.CITRIX.COM"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752859AbaBDK0b (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Feb 2014 05:26:31 -0500
X-IronPort-AV: E=Sophos;i="4.95,778,1384300800"; 
   d="scan'208";a="99579773"
From: Roger Pau Monne <roger.pau@citrix.com>
To: <xen-devel@lists.xenproject.org>, <linux-kernel@vger.kernel.org>
CC: Roger Pau Monne <roger.pau@citrix.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        David Vrabel <david.vrabel@citrix.com>,
        Boris Ostrovsky <boris.ostrovsky@oracle.com>,
        Matt Rushton <mrushton@amazon.com>, Matt Wilson <msw@amazon.com>,
        Ian Campbell <Ian.Campbell@citrix.com>
Subject: [PATCH v2 3/4] xen-blkback: fix shutdown race
Date: Tue, 4 Feb 2014 11:26:14 +0100
Message-ID: <1391509575-3949-4-git-send-email-roger.pau@citrix.com>
X-Mailer: git-send-email 1.7.7.5 (Apple Git-26)
In-Reply-To: <1391509575-3949-1-git-send-email-roger.pau@citrix.com>
References: <1391509575-3949-1-git-send-email-roger.pau@citrix.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-DLP: MIA2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Introduce a new variable to keep track of the number of in-flight
requests. We need to make sure that when xen_blkif_put is called the
request has already been freed and we can safely free xen_blkif, which
was not the case before.

Signed-off-by: Roger Pau Monné <roger.pau@citrix.com>
Cc: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Cc: David Vrabel <david.vrabel@citrix.com>
Cc: Boris Ostrovsky <boris.ostrovsky@oracle.com>
Cc: Matt Rushton <mrushton@amazon.com>
Cc: Matt Wilson <msw@amazon.com>
Cc: Ian Campbell <Ian.Campbell@citrix.com>
---
 drivers/block/xen-blkback/blkback.c |   32 ++++++++++++++++++++++----------
 drivers/block/xen-blkback/common.h  |    1 +
 drivers/block/xen-blkback/xenbus.c  |    1 +
 3 files changed, 24 insertions(+), 10 deletions(-)

diff --git a/drivers/block/xen-blkback/blkback.c b/drivers/block/xen-blkback/blkback.c
index dcfe49f..394fa2e 100644
--- a/drivers/block/xen-blkback/blkback.c
+++ b/drivers/block/xen-blkback/blkback.c
@@ -943,9 +943,7 @@ static void xen_blk_drain_io(struct xen_blkif *blkif)
 {
 	atomic_set(&blkif->drain, 1);
 	do {
-		/* The initial value is one, and one refcnt taken at the
-		 * start of the xen_blkif_schedule thread. */
-		if (atomic_read(&blkif->refcnt) <= 2)
+		if (atomic_read(&blkif->inflight) == 0)
 			break;
 		wait_for_completion_interruptible_timeout(
 				&blkif->drain_complete, HZ);
@@ -985,17 +983,30 @@ static void __end_block_io_op(struct pending_req *pending_req, int error)
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
+		/*
+		 * Make sure the request is freed before releasing blkif,
+		 * or there could be a race between free_req and the
+		 * cleanup done in xen_blkif_free during shutdown.
+		 *
+		 * NB: The fact that we might try to wake up pending_free_wq
+		 * before drain_complete (in case there's a drain going on)
+		 * it's not a problem with our current implementation
+		 * because we can assure there's no thread waiting on
+		 * pending_free_wq if there's a drain going on, but it has
+		 * to be taken into account if the current model is changed.
+		 */
+		if (atomic_dec_and_test(&blkif->inflight) && atomic_read(&blkif->drain)) {
+			complete(&blkif->drain_complete);
 		}
-		free_req(pending_req->blkif, pending_req);
+		xen_blkif_put(blkif);
 	}
 }
 
@@ -1249,6 +1260,7 @@ static int dispatch_rw_block_io(struct xen_blkif *blkif,
 	 * below (in "!bio") if we are handling a BLKIF_OP_DISCARD.
 	 */
 	xen_blkif_get(blkif);
+	atomic_inc(&blkif->inflight);
 
 	for (i = 0; i < nseg; i++) {
 		while ((bio == NULL) ||
diff --git a/drivers/block/xen-blkback/common.h b/drivers/block/xen-blkback/common.h
index f733d76..e40326a 100644
--- a/drivers/block/xen-blkback/common.h
+++ b/drivers/block/xen-blkback/common.h
@@ -278,6 +278,7 @@ struct xen_blkif {
 	/* for barrier (drain) requests */
 	struct completion	drain_complete;
 	atomic_t		drain;
+	atomic_t		inflight;
 	/* One thread per one blkif. */
 	struct task_struct	*xenblkd;
 	unsigned int		waiting_reqs;
diff --git a/drivers/block/xen-blkback/xenbus.c b/drivers/block/xen-blkback/xenbus.c
index 8afef67..84973c6 100644
--- a/drivers/block/xen-blkback/xenbus.c
+++ b/drivers/block/xen-blkback/xenbus.c
@@ -128,6 +128,7 @@ static struct xen_blkif *xen_blkif_alloc(domid_t domid)
 	INIT_LIST_HEAD(&blkif->persistent_purge_list);
 	blkif->free_pages_num = 0;
 	atomic_set(&blkif->persistent_gnt_in_use, 0);
+	atomic_set(&blkif->inflight, 0);
 
 	INIT_LIST_HEAD(&blkif->pending_free);
 
-- 
1.7.7.5 (Apple Git-26)

