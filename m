Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757015Ab3FERgO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Jun 2013 13:36:14 -0400
Received: from aserp1040.oracle.com ([141.146.126.69]:30267 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756721Ab3FERgM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Jun 2013 13:36:12 -0400
Date: Wed, 5 Jun 2013 13:35:41 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: Jan Beulich <JBeulich@suse.com>
Cc: david.vrabel@citrix.com, roger.pau@citrix.com,
        xen-devel <xen-devel@lists.xen.org>, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org
Subject: Re: [PATCH] xen/blkback: Check for insane amounts of request on the
 ring.
Message-ID: <20130605173541.GA12812@phenom.dumpdata.com>
References: <1370375826-7311-1-git-send-email-konrad.wilk@oracle.com>
 <51AF7A7502000078000DB95C@nat28.tlf.novell.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <51AF7A7502000078000DB95C@nat28.tlf.novell.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > Looking at the code, one would expect that the existing check
> 
> The "expect ..." here doesn't really seem to have a proper
> termination later in the sentence (or I'm having problems parsing
> the whole construct), so if I didn't know what the patch is about
> I would have a hard time following.

Oh gosh, that is very badly worded.

.. snip..

I took the advice and altered the patch and hopefully fixed
the commit description to make more sense:


>From 8aa353ba3eb706e89a311645a3eeff9e27b61e33 Mon Sep 17 00:00:00 2001
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Date: Wed, 23 Jan 2013 16:54:32 -0500
Subject: [PATCH] xen/blkback: Check for insane amounts of request on the ring.

Check that the ring does not have an insane amount of requests
(more than there could fit on the ring).

If we detect this case we will stop processing the requests
and wait until the XenBus disconnects the ring.

The existing check RING_REQUEST_CONS_OVERFLOW which checks for how
many responses we have created in the past (rsp_prod_pvt) vs
requests consumed (req_cons) and whether said difference is greater or
equal to the size of the ring, does not catch this case.

Wha the condition does check if there is a need to process more
as we still have a backlog of responses to finish. Note that both
of those values (rsp_prod_pvt and req_cons) are not exposed on the
shared ring.

To understand this problem a mini crash course in ring protocol
response/request updates is in place.

There are four entries: req_prod and rsp_prod; req_event and rsp_event
to track the ring entries. We are only concerned about the first two -
which set the tone of this bug.

The req_prod is a value incremented by frontend for each request put
on the ring. Conversely the rsp_prod is a value incremented by the backend
for each response put on the ring (rsp_prod gets set by rsp_prod_pvt when
pushing the responses on the ring).  Both values can
wrap and are modulo the size of the ring (in block case that is 32).
Please see RING_GET_REQUEST and RING_GET_RESPONSE for the more details.

The culprit here is that if the difference between the
req_prod and req_cons is greater than the ring size we have a problem.
Fortunately for us, the '__do_block_io_op' loop:

	rc = blk_rings->common.req_cons;
	rp = blk_rings->common.sring->req_prod;

	while (rc != rp) {

		..
		blk_rings->common.req_cons = ++rc; /* before make_response() */

	}

will loop up to the point when rc == rp. The macros inside of the
loop (RING_GET_REQUEST) is smart and is indexing based on the modulo
of the ring size. If the frontend has provided a bogus req_prod value
we will loop until the 'rc == rp' - which means we could be processing
already processed requests (or responses) often.

The reason the RING_REQUEST_CONS_OVERFLOW is not helping here is
b/c it only tracks how many responses we have internally produced
and whether we would should process more. The astute reader will
notice that the macro RING_REQUEST_CONS_OVERFLOW provides two
arguments - more on this later.

For example, if we were to enter this function with these values:

       	blk_rings->common.sring->req_prod =  X+31415 (X is the value from
		the last time __do_block_io_op was called).
        blk_rings->common.req_cons = X
        blk_rings->common.rsp_prod_pvt = X

The RING_REQUEST_CONS_OVERFLOW(&blk_rings->common, blk_rings->common.req_cons)
is doing:

	req_cons - sring->rsp_prod_pvt >= 32

Which is,
	X - X >= 32 or 0 >= 32

And that is false, so we continue on looping (this bug).

If we re-use said macro RING_REQUEST_CONS_OVERFLOW and pass in the rp
instead (sring->req_prod) of rc, the this macro can do the check:

     req_prod - sring->rsp_prov_pvt >= 32

Which is,
       X + 31415 - X >= 32 , or 31415 >= 32

which is true, so we can error out and break out of the function.

Cc: stable@vger.kernel.org
[v1: Move the check outside the loop]
[v2: Add a pr_warn as suggested by David]
[v3: Use RING_REQUEST_CONS_OVERFLOW as suggested by Jan]
Signed-off-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Reviewed-by: Jan Beulich <jbeulich@suse.com>
---
 drivers/block/xen-blkback/blkback.c | 13 ++++++++++++-
 drivers/block/xen-blkback/common.h  |  2 ++
 drivers/block/xen-blkback/xenbus.c  |  2 ++
 3 files changed, 16 insertions(+), 1 deletion(-)

diff --git a/drivers/block/xen-blkback/blkback.c b/drivers/block/xen-blkback/blkback.c
index 4119bcd..11ca405 100644
--- a/drivers/block/xen-blkback/blkback.c
+++ b/drivers/block/xen-blkback/blkback.c
@@ -571,6 +571,7 @@ int xen_blkif_schedule(void *arg)
 	struct xen_blkif *blkif = arg;
 	struct xen_vbd *vbd = &blkif->vbd;
 	unsigned long timeout;
+	int ret;
 
 	xen_blkif_get(blkif);
 
@@ -599,8 +600,12 @@ int xen_blkif_schedule(void *arg)
 		blkif->waiting_reqs = 0;
 		smp_mb(); /* clear flag *before* checking for work */
 
-		if (do_block_io_op(blkif))
+		ret = do_block_io_op(blkif);
+		if (ret > 0)
 			blkif->waiting_reqs = 1;
+		if (ret == -EACCES)
+			wait_event_interruptible(blkif->shutdown_wq,
+						 kthread_should_stop());
 
 purge_gnt_list:
 		if (blkif->vbd.feature_gnt_persistent &&
@@ -1009,6 +1014,12 @@ __do_block_io_op(struct xen_blkif *blkif)
 	rp = blk_rings->common.sring->req_prod;
 	rmb(); /* Ensure we see queued requests up to 'rp'. */
 
+	/* N.B. 'rp', not 'rc'. */
+	if (RING_REQUEST_CONS_OVERFLOW(&blk_rings->common, rp)) {
+		pr_warn(DRV_PFX "Frontend provided bogus ring requests (%d - %d = %d). Halting ring processing on dev=%04x\n",
+			rp, rc, rp - rc, blkif->vbd.pdevice);
+		return -EACCES;
+	}
 	while (rc != rp) {
 
 		if (RING_REQUEST_CONS_OVERFLOW(&blk_rings->common, rc))
diff --git a/drivers/block/xen-blkback/common.h b/drivers/block/xen-blkback/common.h
index c6b4cb9..8d88075 100644
--- a/drivers/block/xen-blkback/common.h
+++ b/drivers/block/xen-blkback/common.h
@@ -314,6 +314,8 @@ struct xen_blkif {
 	unsigned long long			st_wr_sect;
 
 	wait_queue_head_t	waiting_to_free;
+	/* Thread shutdown wait queue. */
+	wait_queue_head_t	shutdown_wq;
 };
 
 struct seg_buf {
diff --git a/drivers/block/xen-blkback/xenbus.c b/drivers/block/xen-blkback/xenbus.c
index 4a4749c..c9695fe 100644
--- a/drivers/block/xen-blkback/xenbus.c
+++ b/drivers/block/xen-blkback/xenbus.c
@@ -151,6 +151,7 @@ static struct xen_blkif *xen_blkif_alloc(domid_t domid)
 	}
 	spin_lock_init(&blkif->pending_free_lock);
 	init_waitqueue_head(&blkif->pending_free_wq);
+	init_waitqueue_head(&blkif->shutdown_wq);
 
 	return blkif;
 
@@ -230,6 +231,7 @@ static int xen_blkif_map(struct xen_blkif *blkif, unsigned long shared_page,
 static void xen_blkif_disconnect(struct xen_blkif *blkif)
 {
 	if (blkif->xenblkd) {
+		wake_up(&blkif->shutdown_wq);
 		kthread_stop(blkif->xenblkd);
 		blkif->xenblkd = NULL;
 	}
-- 
1.8.1.4

