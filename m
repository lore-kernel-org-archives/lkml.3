Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753391Ab3CEVt6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Mar 2013 16:49:58 -0500
Received: from aserp1040.oracle.com ([141.146.126.69]:46776 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752971Ab3CEVt4 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Mar 2013 16:49:56 -0500
Date: Tue, 5 Mar 2013 16:49:50 -0500
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: Roger Pau =?iso-8859-1?Q?Monn=E9?= <roger.pau@citrix.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "xen-devel@lists.xen.org" <xen-devel@lists.xen.org>
Subject: Re: [PATCH RFC 06/12] xen-blkback: implement LRU mechanism for
 persistent grants
Message-ID: <20130305214950.GE8235@phenom.dumpdata.com>
References: <1362047335-26402-1-git-send-email-roger.pau@citrix.com>
 <1362047335-26402-7-git-send-email-roger.pau@citrix.com>
 <20130304201044.GJ15386@phenom.dumpdata.com>
 <513634FC.7000401@citrix.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <513634FC.7000401@citrix.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Content-Transfer-Encoding: 8BIT
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 05, 2013 at 07:10:04PM +0100, Roger Pau Monné wrote:
> On 04/03/13 21:10, Konrad Rzeszutek Wilk wrote:
> > On Thu, Feb 28, 2013 at 11:28:49AM +0100, Roger Pau Monne wrote:
> >> This mechanism allows blkback to change the number of grants
> >> persistently mapped at run time.
> >>
> >> The algorithm uses a simple LRU mechanism that removes (if needed) the
> >> persistent grants that have not been used since the last LRU run, or
> >> if all grants have been used it removes the first grants in the list
> >> (that are not in use).
> >>
> >> The algorithm has several parameters that can be tuned by the user
> >> from sysfs:
> >>
> >>  * max_persistent_grants: maximum number of grants that will be
> >>    persistently mapped.
> >>  * lru_interval: minimum interval (in ms) at which the LRU should be
> >>    run
> >>  * lru_num_clean: number of persistent grants to remove when executing
> >>    the LRU.
> >>
> >> Signed-off-by: Roger Pau Monné <roger.pau@citrix.com>
> >> Cc: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
> >> Cc: xen-devel@lists.xen.org
> >> ---
> >>  drivers/block/xen-blkback/blkback.c |  207 +++++++++++++++++++++++++++--------
> >>  drivers/block/xen-blkback/common.h  |    4 +
> >>  drivers/block/xen-blkback/xenbus.c  |    1 +
> >>  3 files changed, 166 insertions(+), 46 deletions(-)
> > 
> > You also should add a Documentation/sysfs/ABI/stable/sysfs-bus-xen-backend
> 
> OK
> 
> >>
> >> diff --git a/drivers/block/xen-blkback/blkback.c b/drivers/block/xen-blkback/blkback.c
> >> index 415a0c7..c14b736 100644
> >> --- a/drivers/block/xen-blkback/blkback.c
> >> +++ b/drivers/block/xen-blkback/blkback.c
> >> @@ -63,6 +63,44 @@ static int xen_blkif_reqs = 64;
> >>  module_param_named(reqs, xen_blkif_reqs, int, 0);
> >>  MODULE_PARM_DESC(reqs, "Number of blkback requests to allocate");
> >>
> >> +/*
> >> + * Maximum number of grants to map persistently in blkback. For maximum
> >> + * performance this should be the total numbers of grants that can be used
> >> + * to fill the ring, but since this might become too high, specially with
> >> + * the use of indirect descriptors, we set it to a value that provides good
> >> + * performance without using too much memory.
> >> + *
> >> + * When the list of persistent grants is full we clean it using a LRU
> >> + * algorithm.
> >> + */
> >> +
> >> +static int xen_blkif_max_pgrants = 352;
> > 
> > And a little blurb saying why 352.
> 
> Yes, this is (as you probably already realized) RING_SIZE *
> BLKIF_MAX_SEGMENTS_PER_REQUEST
> 
> > 
> >> +module_param_named(max_persistent_grants, xen_blkif_max_pgrants, int, 0644);
> >> +MODULE_PARM_DESC(max_persistent_grants,
> >> +                 "Maximum number of grants to map persistently");
> >> +
> >> +/*
> >> + * The LRU mechanism to clean the lists of persistent grants needs to
> >> + * be executed periodically. The time interval between consecutive executions
> >> + * of the purge mechanism is set in ms.
> >> + */
> >> +
> >> +static int xen_blkif_lru_interval = 100;
> > 
> > So every second? What is the benefit of having the user modify this? Would
> > it better if there was an watermark system in xen-blkfront to automatically
> > figure this out? (This could be a TODO of course)
> 
> Every 100ms, so every 0.1 seconds. This can have an impact on
> performance as implemented right now (if we move the purge to a separate
> thread, it's not going to have such an impact), but anyway I feel we can
> let the user tune it.

Why not automatically tune it in the backend? So it can do this by itself?
> 
> >> +module_param_named(lru_interval, xen_blkif_lru_interval, int, 0644);
> >> +MODULE_PARM_DESC(lru_interval,
> >> +"Execution interval (in ms) of the LRU mechanism to clean the list of persistent grants");
> >> +
> >> +/*
> >> + * When the persistent grants list is full we will remove unused grants
> >> + * from the list. The number of grants to be removed at each LRU execution
> >> + * can be set dynamically.
> >> + */
> >> +
> >> +static int xen_blkif_lru_num_clean = BLKIF_MAX_SEGMENTS_PER_REQUEST;
> >> +module_param_named(lru_num_clean, xen_blkif_lru_num_clean, int, 0644);
> >> +MODULE_PARM_DESC(lru_num_clean,
> >> +"Number of persistent grants to unmap when the list is full");
> > 
> > Again, what does that mean to the system admin? Why would they need to modify
> > the contents of that value?
> > 
> 
> Well if you set the maximum number of grants to 1024 you might want to
> increase this to 64 maybe, or on the other hand, if you set the maximum
> number of grants to 10, you may wish to set this to 1, so I think it is
> indeed relevant for system admins.

So why not make this automatic? A value blkback can automatically
adjust as there are less or more grants. This of course does not have
to be part of this patch.
> 
> > Now if this is a debug related one for developing, then this could all be
> > done in DebugFS.
> > 
> >> +
> >>  /* Run-time switchable: /sys/module/blkback/parameters/ */
> >>  static unsigned int log_stats;
> >>  module_param(log_stats, int, 0644);
> >> @@ -81,7 +119,7 @@ struct pending_req {
> >>       unsigned short          operation;
> >>       int                     status;
> >>       struct list_head        free_list;
> >> -     DECLARE_BITMAP(unmap_seg, BLKIF_MAX_SEGMENTS_PER_REQUEST);
> >> +     struct persistent_gnt   *persistent_gnts[BLKIF_MAX_SEGMENTS_PER_REQUEST];
> >>  };
> >>
> >>  #define BLKBACK_INVALID_HANDLE (~0)
> >> @@ -102,36 +140,6 @@ struct xen_blkbk {
> >>  static struct xen_blkbk *blkbk;
> >>
> >>  /*
> >> - * Maximum number of grant pages that can be mapped in blkback.
> >> - * BLKIF_MAX_SEGMENTS_PER_REQUEST * RING_SIZE is the maximum number of
> >> - * pages that blkback will persistently map.
> >> - * Currently, this is:
> >> - * RING_SIZE = 32 (for all known ring types)
> >> - * BLKIF_MAX_SEGMENTS_PER_REQUEST = 11
> >> - * sizeof(struct persistent_gnt) = 48
> >> - * So the maximum memory used to store the grants is:
> >> - * 32 * 11 * 48 = 16896 bytes
> >> - */
> >> -static inline unsigned int max_mapped_grant_pages(enum blkif_protocol protocol)
> >> -{
> >> -     switch (protocol) {
> >> -     case BLKIF_PROTOCOL_NATIVE:
> >> -             return __CONST_RING_SIZE(blkif, PAGE_SIZE) *
> >> -                        BLKIF_MAX_SEGMENTS_PER_REQUEST;
> >> -     case BLKIF_PROTOCOL_X86_32:
> >> -             return __CONST_RING_SIZE(blkif_x86_32, PAGE_SIZE) *
> >> -                        BLKIF_MAX_SEGMENTS_PER_REQUEST;
> >> -     case BLKIF_PROTOCOL_X86_64:
> >> -             return __CONST_RING_SIZE(blkif_x86_64, PAGE_SIZE) *
> >> -                        BLKIF_MAX_SEGMENTS_PER_REQUEST;
> >> -     default:
> >> -             BUG();
> >> -     }
> >> -     return 0;
> >> -}
> >> -
> >> -
> >> -/*
> >>   * Little helpful macro to figure out the index and virtual address of the
> >>   * pending_pages[..]. For each 'pending_req' we have have up to
> >>   * BLKIF_MAX_SEGMENTS_PER_REQUEST (11) pages. The seg would be from 0 through
> >> @@ -251,6 +259,76 @@ static void free_persistent_gnts(struct rb_root *root, unsigned int num)
> >>       BUG_ON(num != 0);
> >>  }
> >>
> >> +static int purge_persistent_gnt(struct rb_root *root, int num)
> >> +{
> >> +     struct gnttab_unmap_grant_ref unmap[BLKIF_MAX_SEGMENTS_PER_REQUEST];
> >> +     struct page *pages[BLKIF_MAX_SEGMENTS_PER_REQUEST];
> >> +     struct persistent_gnt *persistent_gnt;
> >> +     struct rb_node *n;
> >> +     int ret, segs_to_unmap = 0;
> >> +     int requested_num = num;
> >> +     int preserve_used = 1;
> > 
> > Boolean? And perhaps 'scan_dirty' ?
> 
> Sure
> 
> > 
> > 
> >> +
> >> +     pr_debug("Requested the purge of %d persistent grants\n", num);
> >> +
> >> +purge_list:
> > 
> > This could be written a bit differently to also run outside the xen_blkif_schedule
> > (so a new thread). This would require using the lock mechanism and converting
> > this big loop to two smaller loops:
> >  1) - one quick that holds the lock - to take the items of the list,
> >  2) second one to do the grant_set_unmap_op operations and all the heavy
> >     free_xenballooned_pages call.
> 
> Yes, I could add a list_head to persistent_gnt, so we can take them out
> of the red-black tree and queue them in a list to be processed (unmap +
> free) after we have looped thought the list, without holding the lock.
> 
> > 
> > .. As this function ends up (presumarily?) causing xen_blkif_schedule to be doing
> > this for some time every second. Irregardless of how utilized the ring is - so
> > if we are 100% busy - we should not need to call this function. But if we do,
> > then we end up walking the persistent_gnt twice - once with preserve_used set
> > to true, and the other with it set to false.
> > 
> > We don't really want that - so is there a way for xen_blkif_schedule to
> > do a quick determintion of this caliber:
> > 
> > 
> >         if (RING_HAS_UNCONSUMED_REQUESTS(x) >= some_value)
> >                 wait_up(blkif->purgarator)
> 
> It's not possible to tell if all grants will be in use just by looking
> at the number of active requests, since all requests might just be using
> one segment, and thus the list of persistent grants could be purged
> without problems. We could keep a count of the number of active grants
> at each time and use that to check if we can kick the purge or not.
> 
> if (grants_in_use > (persistent_gnt_c - num_purge))
> 	wait(...)

Sure.
> 
> > And the thread would just sit there until kicked in action?
> 
> And when a request frees some grants it could be kicked back to action.

OK.
