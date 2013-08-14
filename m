Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932770Ab3HNK4y (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Aug 2013 06:56:54 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:34454 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932315Ab3HNKhc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Aug 2013 06:37:32 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 19/75] xen/blkback: Check for insane amounts of request on the ring (v6).
Date: Wed, 14 Aug 2013 11:36:08 +0100
Message-Id: <1376476624-10011-20-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1376476624-10011-1-git-send-email-luis.henriques@canonical.com>
References: <1376476624-10011-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.19 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>

commit 8e3f8755545cc4a7f4da8e9ef76d6d32e0dca576 upstream.

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

	req_cons - rsp_prod_pvt >= 32

Which is,
	X - X >= 32 or 0 >= 32

And that is false, so we continue on looping (this bug).

If we re-use said macro RING_REQUEST_CONS_OVERFLOW and pass in the rp
instead (sring->req_prod) of rc, the this macro can do the check:

     req_prod - rsp_prov_pvt >= 32

Which is,
       X + 31415 - X >= 32 , or 31415 >= 32

which is true, so we can error out and break out of the function.

Unfortunatly the difference between rsp_prov_pvt and req_prod can be
at 32 (which would error out in the macro). This condition exists when
the backend is lagging behind with the responses and still has not finished
responding to all of them (so make_response has not been called), and
the rsp_prov_pvt + 32 == req_cons. This ends up with us not being able
to use said macro.

Hence introducing a new macro called RING_REQUEST_PROD_OVERFLOW which does
a simple check of:

    req_prod - rsp_prod_pvt > RING_SIZE

And with the X values from above:

   X + 31415 - X > 32

Returns true. Also not that if the ring is full (which is where
the RING_REQUEST_CONS_OVERFLOW triggered), we would not hit the
same condition:

   X + 32 - X > 32

Which is false.

Lets use that macro.
Note that in v5 of this patchset the macro was different - we used an
earlier version.

[v1: Move the check outside the loop]
[v2: Add a pr_warn as suggested by David]
[v3: Use RING_REQUEST_CONS_OVERFLOW as suggested by Jan]
[v4: Move wake_up after kthread_stop as suggested by Jan]
[v5: Use RING_REQUEST_PROD_OVERFLOW instead]
[v6: Use RING_REQUEST_PROD_OVERFLOW - Jan's version]
Signed-off-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Reviewed-by: Jan Beulich <jbeulich@suse.com>
[ luis: backported to 3.5: adjusted context ]
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/block/xen-blkback/blkback.c | 13 ++++++++++++-
 drivers/block/xen-blkback/common.h  |  2 ++
 drivers/block/xen-blkback/xenbus.c  |  2 ++
 3 files changed, 16 insertions(+), 1 deletion(-)

diff --git a/drivers/block/xen-blkback/blkback.c b/drivers/block/xen-blkback/blkback.c
index 4ed7bf9..b83b40e 100644
--- a/drivers/block/xen-blkback/blkback.c
+++ b/drivers/block/xen-blkback/blkback.c
@@ -274,6 +274,7 @@ int xen_blkif_schedule(void *arg)
 {
 	struct xen_blkif *blkif = arg;
 	struct xen_vbd *vbd = &blkif->vbd;
+	int ret;
 
 	xen_blkif_get(blkif);
 
@@ -294,8 +295,12 @@ int xen_blkif_schedule(void *arg)
 		blkif->waiting_reqs = 0;
 		smp_mb(); /* clear flag *before* checking for work */
 
-		if (do_block_io_op(blkif))
+		ret = do_block_io_op(blkif);
+		if (ret > 0)
 			blkif->waiting_reqs = 1;
+		if (ret == -EACCES)
+			wait_event_interruptible(blkif->shutdown_wq,
+						 kthread_should_stop());
 
 		if (log_stats && time_after(jiffies, blkif->st_print))
 			print_stats(blkif);
@@ -530,6 +535,12 @@ __do_block_io_op(struct xen_blkif *blkif)
 	rp = blk_rings->common.sring->req_prod;
 	rmb(); /* Ensure we see queued requests up to 'rp'. */
 
+	if (RING_REQUEST_PROD_OVERFLOW(&blk_rings->common, rp)) {
+		rc = blk_rings->common.rsp_prod_pvt;
+		pr_warn(DRV_PFX "Frontend provided bogus ring requests (%d - %d = %d). Halting ring processing on dev=%04x\n",
+			rp, rc, rp - rc, blkif->vbd.pdevice);
+		return -EACCES;
+	}
 	while (rc != rp) {
 
 		if (RING_REQUEST_CONS_OVERFLOW(&blk_rings->common, rc))
diff --git a/drivers/block/xen-blkback/common.h b/drivers/block/xen-blkback/common.h
index fc2a486..933adc5 100644
--- a/drivers/block/xen-blkback/common.h
+++ b/drivers/block/xen-blkback/common.h
@@ -216,6 +216,8 @@ struct xen_blkif {
 	int			st_wr_sect;
 
 	wait_queue_head_t	waiting_to_free;
+	/* Thread shutdown wait queue. */
+	wait_queue_head_t	shutdown_wq;
 };
 
 
diff --git a/drivers/block/xen-blkback/xenbus.c b/drivers/block/xen-blkback/xenbus.c
index a155254..5a0062f 100644
--- a/drivers/block/xen-blkback/xenbus.c
+++ b/drivers/block/xen-blkback/xenbus.c
@@ -118,6 +118,7 @@ static struct xen_blkif *xen_blkif_alloc(domid_t domid)
 	atomic_set(&blkif->drain, 0);
 	blkif->st_print = jiffies;
 	init_waitqueue_head(&blkif->waiting_to_free);
+	init_waitqueue_head(&blkif->shutdown_wq);
 
 	return blkif;
 }
@@ -178,6 +179,7 @@ static void xen_blkif_disconnect(struct xen_blkif *blkif)
 {
 	if (blkif->xenblkd) {
 		kthread_stop(blkif->xenblkd);
+		wake_up(&blkif->shutdown_wq);
 		blkif->xenblkd = NULL;
 	}
 
-- 
1.8.3.2

