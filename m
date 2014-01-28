Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755441AbaA1RoD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Jan 2014 12:44:03 -0500
Received: from smtp.citrix.com ([66.165.176.89]:1813 "EHLO SMTP.CITRIX.COM"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755279AbaA1RoA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Jan 2014 12:44:00 -0500
X-IronPort-AV: E=Sophos;i="4.95,737,1384300800"; 
   d="scan'208";a="97353085"
From: Roger Pau Monne <roger.pau@citrix.com>
To: <xen-devel@lists.xenproject.org>, <linux-kernel@vger.kernel.org>
CC: Roger Pau Monne <roger.pau@citrix.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        David Vrabel <david.vrabel@citrix.com>,
        Boris Ostrovsky <boris.ostrovsky@oracle.com>,
        Matt Rushton <mrushton@amazon.com>, Matt Wilson <msw@amazon.com>,
        Ian Campbell <Ian.Campbell@citrix.com>
Subject: [PATCH 3/3] xen-blkback: fix shutdown race
Date: Tue, 28 Jan 2014 18:43:35 +0100
Message-ID: <1390931015-5490-4-git-send-email-roger.pau@citrix.com>
X-Mailer: git-send-email 1.7.7.5 (Apple Git-26)
In-Reply-To: <1390931015-5490-1-git-send-email-roger.pau@citrix.com>
References: <1390931015-5490-1-git-send-email-roger.pau@citrix.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-DLP: MIA1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Move the call to xen_blkif_put after we have freed the request,
otherwise we have a race between the release of the request and the
cleanup done in xen_blkif_free.

Signed-off-by: Roger Pau Monné <roger.pau@citrix.com>
Cc: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Cc: David Vrabel <david.vrabel@citrix.com>
Cc: Boris Ostrovsky <boris.ostrovsky@oracle.com>
Cc: Matt Rushton <mrushton@amazon.com>
Cc: Matt Wilson <msw@amazon.com>
Cc: Ian Campbell <Ian.Campbell@citrix.com>
---
 drivers/block/xen-blkback/blkback.c |   28 +++++++++++++++++++++-------
 1 files changed, 21 insertions(+), 7 deletions(-)

diff --git a/drivers/block/xen-blkback/blkback.c b/drivers/block/xen-blkback/blkback.c
index dcfe49f..8200aa0 100644
--- a/drivers/block/xen-blkback/blkback.c
+++ b/drivers/block/xen-blkback/blkback.c
@@ -985,17 +985,31 @@ static void __end_block_io_op(struct pending_req *pending_req, int error)
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
+		xen_blkif_put(blkif);
+		if (atomic_read(&blkif->refcnt) <= 2) {
+			if (atomic_read(&blkif->drain))
+				complete(&blkif->drain_complete);
 		}
-		free_req(pending_req->blkif, pending_req);
 	}
 }
 
-- 
1.7.7.5 (Apple Git-26)

