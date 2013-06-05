Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756618Ab3FEPuw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Jun 2013 11:50:52 -0400
Received: from nat28.tlf.novell.com ([130.57.49.28]:59772 "EHLO
	nat28.tlf.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756589Ab3FEPuu convert rfc822-to-8bit (ORCPT
	<rfc822;groupwise-linux-kernel@vger.kernel.org:4:1>);
	Wed, 5 Jun 2013 11:50:50 -0400
Message-Id: <51AF7A7502000078000DB95C@nat28.tlf.novell.com>
X-Mailer: Novell GroupWise Internet Agent 12.0.2 
Date: Wed, 05 Jun 2013 16:50:45 +0100
From: "Jan Beulich" <JBeulich@suse.com>
To: "Konrad Rzeszutek Wilk" <konrad.wilk@oracle.com>
Cc: <david.vrabel@citrix.com>, <roger.pau@citrix.com>,
        "xen-devel" <xen-devel@lists.xen.org>, <linux-kernel@vger.kernel.org>,
        <stable@vger.kernel.org>
Subject: Re: [PATCH] xen/blkback: Check for insane amounts of request
 on the ring.
References: <1370375826-7311-1-git-send-email-konrad.wilk@oracle.com>
In-Reply-To: <1370375826-7311-1-git-send-email-konrad.wilk@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>> On 04.06.13 at 21:57, Konrad Rzeszutek Wilk <konrad.wilk@oracle.com> wrote:
> Check that the ring does not have an insane amount of requests
> (more than there could fit on the ring).
> 
> If we detect this case we will stop processing the requests
> and wait until the XenBus disconnects the ring.
> 
> Looking at the code, one would expect that the existing check

The "expect ..." here doesn't really seem to have a proper
termination later in the sentence (or I'm having problems parsing
the whole construct), so if I didn't know what the patch is about
I would have a hard time following.

> RING_REQUEST_CONS_OVERFLOW which checks for how many responses we
> have created in the past (rsp_prod_pvt) vs requests consumed (req_cons)
> and that difference between is greater or equal to the size of the
> ring. If that condition is satisfied that means we should not be
> processing more requests as we still have a backlog of responses
> to finish. Note that both of those values (rsp_prod_pvt and req_cons)
> are not exposed on the shared ring.
> 
> To understand this problem a mini crash course in ring protocol
> response/request updates.
> 
> There are four entries: req_prod and rsp_prod; req_event and rsp_event.
> We are only concerned about the first two - which set the tone of
> this bug.
> 
> The req_prod is a value incremented by frontend for each request put
> on the ring. Conversely the rsp_prod is a value incremented by the backend
> for each response put on the ring (rsp_prod gets set by rsp_prod_pvt when
> pushing the responses on the ring).  Both values can
> wrap and are modulo the size of the ring (in block case that is 32).
> Please see RING_GET_REQUEST and RING_GET_RESPONSE for the more details.
> 
> The culprit here is that if the difference between the
> req_prod and req_cons is greater than the ring size we have a problem.
> Fortunately for us, the '__do_block_io_op' loop:
> 
> 	rc = blk_rings->common.req_cons;
> 	rp = blk_rings->common.sring->req_prod;
> 
> 	while (rc != rp) {
> 
> 		..
> 		blk_rings->common.req_cons = ++rc; /* before make_response() */
> 
> 	}
> 
> will loop up to the point when rc == rp. The macros inside of the
> loop (RING_GET_REQUEST) is smart and is indexing based on the modulo
> of the ring size. If the frontend has provided a bogus req_prod value
> we will loop until the 'rc == rp' - which means we could be processing
> already processed requests (or responses) often.
> 
> The reason the RING_REQUEST_CONS_OVERFLOW is not helping here is
> b/c it only tracks how many responses we have internally produced
> and whether we would should process more. The astute reader will
> notice that the macro RING_REQUEST_CONS_OVERFLOW provides two
> arguments - more on this later.
> 
> For example, if we were to enter this function with these values:
> 
>        	blk_rings->common.sring->req_prod =  X+31415 (X is the value from
> 		the last time __do_block_io_op was called).
>         blk_rings->common.req_cons = X
>         blk_rings->common.rsp_prod_pvt = X
> 
> The RING_REQUEST_CONS_OVERFLOW(&blk_rings->common, blk_rings->common.req_cons)
> is doing:
> 
> 	req_cons - sring->rsp_prod_pvt >= 32
> 
> Which is,
> 	X - X >= 32 or 0 >= 32
> 
> And that is false, so we continue on looping (this bug).
> 
> If we re-use said macro RING_REQUEST_CONS_OVERFLOW and pass in the rp
> instead (sring->req_prod) of rc, the this macro can do the check:
> 
>      req_prod - sring->rsp_prov_pvt >= 32
> 
> Which is,
>        X + 31415 - X >= 32 , or 31415 >= 32
> 
> which is true, so we can error out and break out of the function.
> 
> Cc: stable@vger.kernel.org 
> [v1: Move the check outside the loop]
> [v2: Add a pr_warn as suggested by David]
> [v3: Use RING_REQUEST_CONS_OVERFLOW as suggested by Jan]
> Signed-off-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>

Reviewed-by: Jan Beulich <jbeulich@suse.com>

albeit with a minor nit:

> --- a/drivers/block/xen-blkback/blkback.c
> +++ b/drivers/block/xen-blkback/blkback.c
> @@ -397,7 +397,7 @@ int xen_blkif_schedule(void *arg)
>  {
>  	struct xen_blkif *blkif = arg;
>  	struct xen_vbd *vbd = &blkif->vbd;
> -
> +	int rc = 0;
>  	xen_blkif_get(blkif);
>  
>  	while (!kthread_should_stop()) {

Removing the blank line here isn't nice imo, and the initializer is
unnecessary (and admittedly confused me a little when looking at
the hunks further down, thinking the initialization here is to have
"rc" initialized below, until I realized that those are in a different
function).

Jan

> @@ -417,8 +417,12 @@ int xen_blkif_schedule(void *arg)
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
> @@ -778,6 +782,12 @@ __do_block_io_op(struct xen_blkif *blkif)
>  	rp = blk_rings->common.sring->req_prod;
>  	rmb(); /* Ensure we see queued requests up to 'rp'. */
>  
> +	/* N.B. 'rp', not 'rc'. */
> +	if (RING_REQUEST_CONS_OVERFLOW(&blk_rings->common, rp)) {
> +		pr_warn(DRV_PFX "Frontend provided bogus ring requests (%d - %d = %d). 
> Halting ring processing on dev=%04x\n",
> +			rp, rc, rp - rc, blkif->vbd.pdevice);
> +		return -EACCES;
> +	}
>  	while (rc != rp) {
>  
>  		if (RING_REQUEST_CONS_OVERFLOW(&blk_rings->common, rc))

