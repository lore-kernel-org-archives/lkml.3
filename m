Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755188AbaA1PhY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Jan 2014 10:37:24 -0500
Received: from userp1040.oracle.com ([156.151.31.81]:21609 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754631AbaA1PhV convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Jan 2014 10:37:21 -0500
Date: Tue, 28 Jan 2014 10:37:10 -0500
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: Roger Pau =?iso-8859-1?Q?Monn=E9?= <roger.pau@citrix.com>
Cc: xen-devel@lists.xenproject.org, linux-kernel@vger.kernel.org,
        David Vrabel <david.vrabel@citrix.com>,
        Boris Ostrovsky <boris.ostrovsky@oracle.com>,
        Matt Rushton <mrushton@amazon.com>, Matt Wilson <msw@amazon.com>,
        Ian Campbell <Ian.Campbell@citrix.com>
Subject: Re: [PATCH] xen-blkback: fix memory leaks
Message-ID: <20140128153710.GC4308@phenom.dumpdata.com>
References: <1390817621-12031-1-git-send-email-roger.pau@citrix.com>
 <20140127212146.GA32007@phenom.dumpdata.com>
 <52E7A635.2090108@citrix.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <52E7A635.2090108@citrix.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Content-Transfer-Encoding: 8BIT
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 28, 2014 at 01:44:37PM +0100, Roger Pau Monné wrote:
> On 27/01/14 22:21, Konrad Rzeszutek Wilk wrote:
> > On Mon, Jan 27, 2014 at 11:13:41AM +0100, Roger Pau Monne wrote:
> >> I've at least identified two possible memory leaks in blkback, both
> >> related to the shutdown path of a VBD:
> >>
> >> - We don't wait for any pending purge work to finish before cleaning
> >>   the list of free_pages. The purge work will call put_free_pages and
> >>   thus we might end up with pages being added to the free_pages list
> >>   after we have emptied it.
> >> - We don't wait for pending requests to end before cleaning persistent
> >>   grants and the list of free_pages. Again this can add pages to the
> >>   free_pages lists or persistent grants to the persistent_gnts
> >>   red-black tree.
> >>
> >> Also, add some checks in xen_blkif_free to make sure we are cleaning
> >> everything.
> >>
> >> Signed-off-by: Roger Pau Monné <roger.pau@citrix.com>
> >> Cc: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
> >> Cc: David Vrabel <david.vrabel@citrix.com>
> >> Cc: Boris Ostrovsky <boris.ostrovsky@oracle.com>
> >> Cc: Matt Rushton <mrushton@amazon.com>
> >> Cc: Matt Wilson <msw@amazon.com>
> >> Cc: Ian Campbell <Ian.Campbell@citrix.com>
> >> ---
> >> This should be applied after the patch:
> >>
> >> xen-blkback: fix memory leak when persistent grants are used
> >>
> >> >From Matt Rushton & Matt Wilson and backported to stable.
> >>
> >> I've been able to create and destroy ~4000 guests while doing heavy IO
> >> operations with this patch on a 512M Dom0 without problems.
> >> ---
> >>  drivers/block/xen-blkback/blkback.c |   29 +++++++++++++++++++----------
> >>  drivers/block/xen-blkback/xenbus.c  |    9 +++++++++
> >>  2 files changed, 28 insertions(+), 10 deletions(-)
> >>
> >> diff --git a/drivers/block/xen-blkback/blkback.c b/drivers/block/xen-blkback/blkback.c
> >> index 30ef7b3..19925b7 100644
> >> --- a/drivers/block/xen-blkback/blkback.c
> >> +++ b/drivers/block/xen-blkback/blkback.c
> >> @@ -169,6 +169,7 @@ static int dispatch_rw_block_io(struct xen_blkif *blkif,
> >>  				struct pending_req *pending_req);
> >>  static void make_response(struct xen_blkif *blkif, u64 id,
> >>  			  unsigned short op, int st);
> >> +static void xen_blk_drain_io(struct xen_blkif *blkif, bool force);
> >>  
> >>  #define foreach_grant_safe(pos, n, rbtree, node) \
> >>  	for ((pos) = container_of(rb_first((rbtree)), typeof(*(pos)), node), \
> >> @@ -625,6 +626,12 @@ purge_gnt_list:
> >>  			print_stats(blkif);
> >>  	}
> >>  
> >> +	/* Drain pending IO */
> >> +	xen_blk_drain_io(blkif, true);
> >> +
> >> +	/* Drain pending purge work */
> >> +	flush_work(&blkif->persistent_purge_work);
> >> +
> > 
> > I think this means we can eliminate the refcnt usage - at least when
> > it comes to xen_blkif_disconnect where if we would initiate the shutdown, and
> > there is
> > 
> > 239         atomic_dec(&blkif->refcnt);                                             
> > 240         wait_event(blkif->waiting_to_free, atomic_read(&blkif->refcnt) == 0);   
> > 241         atomic_inc(&blkif->refcnt);                                             
> > 242                                                                                 
> > 
> > which is done _after_ the thread is done executing. That check won't
> > be needed anymore as the xen_blk_drain_io, flush_work, and free_persistent_gnts
> > has pretty much drained every I/O out - so the moment the thread exits
> > there should be no need for waiting_to_free. I think.
> 
> I've reworked this patch a bit, so we don't drain the in-flight requests
> here, and instead moved all the cleanup code to xen_blkif_free. I've
> also split the xen_blkif_put race fix into a separate patch.
> 
> > 
> >>  	/* Free all persistent grant pages */
> >>  	if (!RB_EMPTY_ROOT(&blkif->persistent_gnts))
> >>  		free_persistent_gnts(blkif, &blkif->persistent_gnts,
> >> @@ -930,7 +937,7 @@ static int dispatch_other_io(struct xen_blkif *blkif,
> >>  	return -EIO;
> >>  }
> >>  
> >> -static void xen_blk_drain_io(struct xen_blkif *blkif)
> >> +static void xen_blk_drain_io(struct xen_blkif *blkif, bool force)
> >>  {
> >>  	atomic_set(&blkif->drain, 1);
> >>  	do {
> >> @@ -943,7 +950,7 @@ static void xen_blk_drain_io(struct xen_blkif *blkif)
> >>  
> >>  		if (!atomic_read(&blkif->drain))
> >>  			break;
> >> -	} while (!kthread_should_stop());
> >> +	} while (!kthread_should_stop() || force);
> >>  	atomic_set(&blkif->drain, 0);
> >>  }
> >>  
> >> @@ -976,17 +983,19 @@ static void __end_block_io_op(struct pending_req *pending_req, int error)
> >>  	 * the proper response on the ring.
> >>  	 */
> >>  	if (atomic_dec_and_test(&pending_req->pendcnt)) {
> >> -		xen_blkbk_unmap(pending_req->blkif,
> >> +		struct xen_blkif *blkif = pending_req->blkif;
> >> +
> >> +		xen_blkbk_unmap(blkif,
> >>  		                pending_req->segments,
> >>  		                pending_req->nr_pages);
> >> -		make_response(pending_req->blkif, pending_req->id,
> >> +		make_response(blkif, pending_req->id,
> >>  			      pending_req->operation, pending_req->status);
> >> -		xen_blkif_put(pending_req->blkif);
> >> -		if (atomic_read(&pending_req->blkif->refcnt) <= 2) {
> >> -			if (atomic_read(&pending_req->blkif->drain))
> >> -				complete(&pending_req->blkif->drain_complete);
> >> +		free_req(blkif, pending_req);
> >> +		xen_blkif_put(blkif);
> >> +		if (atomic_read(&blkif->refcnt) <= 2) {
> >> +			if (atomic_read(&blkif->drain))
> >> +				complete(&blkif->drain_complete);
> >>  		}
> >> -		free_req(pending_req->blkif, pending_req);
> > 
> > I keep coming back to this and I am not sure what to think - especially
> > in the context of WRITE_BARRIER and disconnecting the vbd.
> > 
> > You moved the 'free_req' to be done before you do atomic_read/dec.
> > 
> > Which means that we do:
> > 
> > 	list_add(&req->free_list, &blkif->pending_free);
> > 	wake_up(&blkif->pending_free_wq);
> > 
> > 	atomic_dec
> > 	if atomic_read <= 2 poke thread that is waiting for drain.
> > 
> > 
> > while in the past we did:
> > 
> > 	atomic_dec
> > 	if atomic_read <= 2 poke thread that is waiting for drain.
> > 
> > 	list_add(&req->free_list, &blkif->pending_free);
> > 	wake_up(&blkif->pending_free_wq);
> > 
> > which means that we are giving the 'req' _before_ we decrement
> > the refcnts.
> > 
> > Could that mean that __do_block_io_op takes it for a spin - oh
> > wait it won't as it is sitting on a WRITE_BARRIER and waiting:
> > 
> > 1226         if (drain)                                                              
> > 1227                 xen_blk_drain_io(pending_req->blkif);  
> > 
> > But still that feels 'wrong'?
> 
> Mmmm, the wake_up call in free_req in the context of WRITE_BARRIER is
> harmless since the thread is waiting on drain_complete as you say, but I
> take your point that it's all confusing. Do you think it will feel
> better if we gate the call to wake_up in free_req with this condition:
> 
> if (was_empty && !atomic_read(&blkif->drain))
> 
> Or is this just going to make it even messier?

My head spins around when thinking about the refcnt, drain, the two or
three workqueues. 

> 
> Maybe just adding a comment in free_req saying that the wake_up call is
> going to be ignored in the context of a WRITE_BARRIER, since the thread
> is already waiting on drain_complete is enough.

Perhaps. You do pass in the 'force' bool flag and we could piggyback
on that. Meaning you could do

/* a comment about what we just mentioned */

if (!force) {
	// do it the old way
} else {

	/* A comment mentioning _why_ we need the code reshuffled */

	// do it the new way
}

It would be a bit messy - but:
 - We won't have to worry about breaking WRITE_BARRIER as the old
   logic would be preserved. So less worry about regressions.
 - The bug-fix would be easy to backport as it would inject code for
   just the usage you want - that is to drain all I/Os.
 - It would make a nice distinction and allows us to refactor
   this in future patches.
The cons are that:
 - It would add extra path for just the use-case of shutting down
   without using the existing one.
 - It would be messy


But I think when it comes to fixes like these that are
candidates for backports - messy is OK and if they don't have any
posibility of introducing regressions on existing other behaviors -
then we should stick with that.


Then in the future we can refactor this to use less of these
workqueues, refcnt and atomics we have. It is getting confusing.

Thoughts?
