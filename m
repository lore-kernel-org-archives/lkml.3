Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757068Ab3AYSne (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jan 2013 13:43:34 -0500
Received: from aserp1040.oracle.com ([141.146.126.69]:50701 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754778Ab3AYSnb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jan 2013 13:43:31 -0500
Date: Fri, 25 Jan 2013 13:43:23 -0500
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: linux-kernel@vger.kernel.org, xen-devel@lists.xensource.com
Cc: Konrad Rzeszutek Wilk <konrad@kernel.org>, stable@vger.kernel.org
Subject: Re: [PATCH 3/3] xen/blkback: Check for insane amounts of request on
 the ring.
Message-ID: <20130125184323.GC1384@phenom.dumpdata.com>
References: <1359135152-30688-1-git-send-email-konrad.wilk@oracle.com>
 <1359135152-30688-4-git-send-email-konrad.wilk@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1359135152-30688-4-git-send-email-konrad.wilk@oracle.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: ucsinet22.oracle.com [156.151.31.94]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 25, 2013 at 12:32:32PM -0500, Konrad Rzeszutek Wilk wrote:
> Check that the ring does not have an insane amount of requests
> (more than there could fit on the ring).
.. snip..
> diff --git a/drivers/block/xen-blkback/blkback.c b/drivers/block/xen-blkback/blkback.c
> index 2de3da9..4e9b028 100644
> --- a/drivers/block/xen-blkback/blkback.c
> +++ b/drivers/block/xen-blkback/blkback.c
> @@ -395,7 +395,7 @@ int xen_blkif_schedule(void *arg)
>  {
>  	struct xen_blkif *blkif = arg;
>  	struct xen_vbd *vbd = &blkif->vbd;
> -
> +	int rc = 0;
>  	xen_blkif_get(blkif);
>  
>  	while (!kthread_should_stop()) {
> @@ -415,8 +415,12 @@ int xen_blkif_schedule(void *arg)
>  		blkif->waiting_reqs = 0;
>  		smp_mb(); /* clear flag *before* checking for work */
>  
> -		if (do_block_io_op(blkif))
> +		rc = do_block_io_op(blkif);
> +		if (rc > 0)
>  			blkif->waiting_reqs = 1;
> +		if (rc == -EACCES)
> +			wait_event_interruptible(blkif->shutdown_wq,
> +						 kthread_should_stop());
>  
>  		if (log_stats && time_after(jiffies, blkif->st_print))
>  			print_stats(blkif);
> @@ -780,6 +784,9 @@ __do_block_io_op(struct xen_blkif *blkif)
>  		if (RING_REQUEST_CONS_OVERFLOW(&blk_rings->common, rc))
>  			break;
>  
> +		if (RING_REQUEST_PROD_OVERFLOW(&blk_rings->common, rc, rp))
> +			return -EACCES;
> +


With the new patch for RING_REQUEST_PROD_OVERFLOW I realized that the check
can actually be right before the loop, so:

>From c35dd7a41960038c5defbf8b40541a0d7f206d54 Mon Sep 17 00:00:00 2001
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Date: Wed, 23 Jan 2013 16:54:32 -0500
Subject: [PATCH 2/2] xen/blkback: Check for insane amounts of request on the
 ring.

Check that the ring does not have an insane amount of requests
(more than there could fit on the ring).

If we detect this case we will stop processing the requests
and wait until the XenBus disconnects the ring.

Looking at the code, one would expect that the existing check
RING_REQUEST_CONS_OVERFLOW which checks for how many responses we
have created in the past (rsp_prod_pvt) vs requests consumed (req_cons)
and that difference between is greater or equal to the size of the
ring. If that condition is satisfied that means we should not be
processing more requests as we still have a backlog of responses
to finish. Note that both of those values (rsp_prod_pvt and req_cons)
are not exposed on the shared ring.

To understand this problem a mini crash course in ring protocol
response/request updates.

There are four entries: req_prod and rsp_prod; req_event and rsp_event.
We are only concerned about the first two - which set the tone of
this bug. The req_prod is a value incremented by frontend for each
request put on the ring. Conversely the rsp_prod is a value incremented
by the backend for each response put on the ring. Both values can
wrap and are modulo the size of the ring (in block case that is 32).
Look in RING_GET_REQUEST and RING_GET_RESPONSE for the more details.

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
we will loop here until the 'rc == rp' - so we could be processing
already processed requests (or responses) often.

The reason the RING_REQUEST_CONS_OVERFLOW is not helping here is
b/c it only tracks how many responses we have internally produced
and whether we would should process more.

For example, if we were to enter this function with these values:

       	blk_rings->common.sring->req_prod =  X+31415 (X is the value from
		the last time __do_block_io_op was called).
        blk_rings->common.req_cons = X
        blk_rings->common.rsp_prod_pvt = X

The RING_REQUEST_CONS_OVERFLOW is doing:

	req_cons - sring->rsp_prod_pvt >= 32

Which is,
	X - X >= 32 or 0 >= 32

And that is false, so we continue on looping (this bug).

The new macro (RING_REQUEST_PROD_OVERFLOW) will help us determine this
condition, and checks the difference between request consumed and
request produced and whether that difference is greater than the ring size.

	req_cons - sring->req.prod > 32

	X - X+31415 > 32

And that is true, so we break out of the loop.

Cc: stable@vger.kernel.org
[v1: Move the check outside the loop]
Signed-off-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
---
 drivers/block/xen-blkback/blkback.c | 11 +++++++++--
 drivers/block/xen-blkback/common.h  |  2 ++
 drivers/block/xen-blkback/xenbus.c  |  2 ++
 3 files changed, 13 insertions(+), 2 deletions(-)

diff --git a/drivers/block/xen-blkback/blkback.c b/drivers/block/xen-blkback/blkback.c
index 1966a7c..cc9c48f 100644
--- a/drivers/block/xen-blkback/blkback.c
+++ b/drivers/block/xen-blkback/blkback.c
@@ -395,7 +395,7 @@ int xen_blkif_schedule(void *arg)
 {
 	struct xen_blkif *blkif = arg;
 	struct xen_vbd *vbd = &blkif->vbd;
-
+	int rc = 0;
 	xen_blkif_get(blkif);
 
 	while (!kthread_should_stop()) {
@@ -415,8 +415,12 @@ int xen_blkif_schedule(void *arg)
 		blkif->waiting_reqs = 0;
 		smp_mb(); /* clear flag *before* checking for work */
 
-		if (do_block_io_op(blkif))
+		rc = do_block_io_op(blkif);
+		if (rc > 0)
 			blkif->waiting_reqs = 1;
+		if (rc == -EACCES)
+			wait_event_interruptible(blkif->shutdown_wq,
+						 kthread_should_stop());
 
 		if (log_stats && time_after(jiffies, blkif->st_print))
 			print_stats(blkif);
@@ -764,6 +768,9 @@ __do_block_io_op(struct xen_blkif *blkif)
 	rp = blk_rings->common.sring->req_prod;
 	rmb(); /* Ensure we see queued requests up to 'rp'. */
 
+	if (RING_REQUEST_PROD_OVERFLOW(&blk_rings->common, rp, rc))
+		return -EACCES;
+
 	while (rc != rp) {
 
 		if (RING_REQUEST_CONS_OVERFLOW(&blk_rings->common, rc))
diff --git a/drivers/block/xen-blkback/common.h b/drivers/block/xen-blkback/common.h
index ae7951f..8fd211b 100644
--- a/drivers/block/xen-blkback/common.h
+++ b/drivers/block/xen-blkback/common.h
@@ -218,6 +218,8 @@ struct xen_blkif {
 	int			st_wr_sect;
 
 	wait_queue_head_t	waiting_to_free;
+	/* Thread shutdown wait queue. */
+	wait_queue_head_t	shutdown_wq;
 };
 
 
diff --git a/drivers/block/xen-blkback/xenbus.c b/drivers/block/xen-blkback/xenbus.c
index 60558a5..333ebe9 100644
--- a/drivers/block/xen-blkback/xenbus.c
+++ b/drivers/block/xen-blkback/xenbus.c
@@ -119,6 +119,7 @@ static struct xen_blkif *xen_blkif_alloc(domid_t domid)
 	blkif->st_print = jiffies;
 	init_waitqueue_head(&blkif->waiting_to_free);
 	blkif->persistent_gnts.rb_node = NULL;
+	init_waitqueue_head(&blkif->shutdown_wq);
 
 	return blkif;
 }
@@ -178,6 +179,7 @@ static int xen_blkif_map(struct xen_blkif *blkif, unsigned long shared_page,
 static void xen_blkif_disconnect(struct xen_blkif *blkif)
 {
 	if (blkif->xenblkd) {
+		wake_up(&blkif->shutdown_wq);
 		kthread_stop(blkif->xenblkd);
 		blkif->xenblkd = NULL;
 	}
-- 
1.8.0.2

