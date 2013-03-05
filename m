Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758476Ab3CESKK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Mar 2013 13:10:10 -0500
Received: from smtp.eu.citrix.com ([46.33.159.39]:56755 "EHLO
	SMTP.EU.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752826Ab3CESKI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Mar 2013 13:10:08 -0500
X-IronPort-AV: E=Sophos;i="4.84,788,1355097600"; 
   d="scan'208";a="2201738"
Message-ID: <513634FC.7000401@citrix.com>
Date: Tue, 5 Mar 2013 19:10:04 +0100
From: =?ISO-8859-1?Q?Roger_Pau_Monn=E9?= <roger.pau@citrix.com>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.7; rv:17.0) Gecko/20130216 Thunderbird/17.0.3
MIME-Version: 1.0
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "xen-devel@lists.xen.org" <xen-devel@lists.xen.org>
Subject: Re: [PATCH RFC 06/12] xen-blkback: implement LRU mechanism for persistent
 grants
References: <1362047335-26402-1-git-send-email-roger.pau@citrix.com> <1362047335-26402-7-git-send-email-roger.pau@citrix.com> <20130304201044.GJ15386@phenom.dumpdata.com>
In-Reply-To: <20130304201044.GJ15386@phenom.dumpdata.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/03/13 21:10, Konrad Rzeszutek Wilk wrote:
> On Thu, Feb 28, 2013 at 11:28:49AM +0100, Roger Pau Monne wrote:
>> This mechanism allows blkback to change the number of grants
>> persistently mapped at run time.
>>
>> The algorithm uses a simple LRU mechanism that removes (if needed) the
>> persistent grants that have not been used since the last LRU run, or
>> if all grants have been used it removes the first grants in the list
>> (that are not in use).
>>
>> The algorithm has several parameters that can be tuned by the user
>> from sysfs:
>>
>>  * max_persistent_grants: maximum number of grants that will be
>>    persistently mapped.
>>  * lru_interval: minimum interval (in ms) at which the LRU should be
>>    run
>>  * lru_num_clean: number of persistent grants to remove when executing
>>    the LRU.
>>
>> Signed-off-by: Roger Pau Monné <roger.pau@citrix.com>
>> Cc: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
>> Cc: xen-devel@lists.xen.org
>> ---
>>  drivers/block/xen-blkback/blkback.c |  207 +++++++++++++++++++++++++++--------
>>  drivers/block/xen-blkback/common.h  |    4 +
>>  drivers/block/xen-blkback/xenbus.c  |    1 +
>>  3 files changed, 166 insertions(+), 46 deletions(-)
> 
> You also should add a Documentation/sysfs/ABI/stable/sysfs-bus-xen-backend

OK

>>
>> diff --git a/drivers/block/xen-blkback/blkback.c b/drivers/block/xen-blkback/blkback.c
>> index 415a0c7..c14b736 100644
>> --- a/drivers/block/xen-blkback/blkback.c
>> +++ b/drivers/block/xen-blkback/blkback.c
>> @@ -63,6 +63,44 @@ static int xen_blkif_reqs = 64;
>>  module_param_named(reqs, xen_blkif_reqs, int, 0);
>>  MODULE_PARM_DESC(reqs, "Number of blkback requests to allocate");
>>
>> +/*
>> + * Maximum number of grants to map persistently in blkback. For maximum
>> + * performance this should be the total numbers of grants that can be used
>> + * to fill the ring, but since this might become too high, specially with
>> + * the use of indirect descriptors, we set it to a value that provides good
>> + * performance without using too much memory.
>> + *
>> + * When the list of persistent grants is full we clean it using a LRU
>> + * algorithm.
>> + */
>> +
>> +static int xen_blkif_max_pgrants = 352;
> 
> And a little blurb saying why 352.

Yes, this is (as you probably already realized) RING_SIZE *
BLKIF_MAX_SEGMENTS_PER_REQUEST

> 
>> +module_param_named(max_persistent_grants, xen_blkif_max_pgrants, int, 0644);
>> +MODULE_PARM_DESC(max_persistent_grants,
>> +                 "Maximum number of grants to map persistently");
>> +
>> +/*
>> + * The LRU mechanism to clean the lists of persistent grants needs to
>> + * be executed periodically. The time interval between consecutive executions
>> + * of the purge mechanism is set in ms.
>> + */
>> +
>> +static int xen_blkif_lru_interval = 100;
> 
> So every second? What is the benefit of having the user modify this? Would
> it better if there was an watermark system in xen-blkfront to automatically
> figure this out? (This could be a TODO of course)

Every 100ms, so every 0.1 seconds. This can have an impact on
performance as implemented right now (if we move the purge to a separate
thread, it's not going to have such an impact), but anyway I feel we can
let the user tune it.

>> +module_param_named(lru_interval, xen_blkif_lru_interval, int, 0644);
>> +MODULE_PARM_DESC(lru_interval,
>> +"Execution interval (in ms) of the LRU mechanism to clean the list of persistent grants");
>> +
>> +/*
>> + * When the persistent grants list is full we will remove unused grants
>> + * from the list. The number of grants to be removed at each LRU execution
>> + * can be set dynamically.
>> + */
>> +
>> +static int xen_blkif_lru_num_clean = BLKIF_MAX_SEGMENTS_PER_REQUEST;
>> +module_param_named(lru_num_clean, xen_blkif_lru_num_clean, int, 0644);
>> +MODULE_PARM_DESC(lru_num_clean,
>> +"Number of persistent grants to unmap when the list is full");
> 
> Again, what does that mean to the system admin? Why would they need to modify
> the contents of that value?
> 

Well if you set the maximum number of grants to 1024 you might want to
increase this to 64 maybe, or on the other hand, if you set the maximum
number of grants to 10, you may wish to set this to 1, so I think it is
indeed relevant for system admins.

> Now if this is a debug related one for developing, then this could all be
> done in DebugFS.
> 
>> +
>>  /* Run-time switchable: /sys/module/blkback/parameters/ */
>>  static unsigned int log_stats;
>>  module_param(log_stats, int, 0644);
>> @@ -81,7 +119,7 @@ struct pending_req {
>>       unsigned short          operation;
>>       int                     status;
>>       struct list_head        free_list;
>> -     DECLARE_BITMAP(unmap_seg, BLKIF_MAX_SEGMENTS_PER_REQUEST);
>> +     struct persistent_gnt   *persistent_gnts[BLKIF_MAX_SEGMENTS_PER_REQUEST];
>>  };
>>
>>  #define BLKBACK_INVALID_HANDLE (~0)
>> @@ -102,36 +140,6 @@ struct xen_blkbk {
>>  static struct xen_blkbk *blkbk;
>>
>>  /*
>> - * Maximum number of grant pages that can be mapped in blkback.
>> - * BLKIF_MAX_SEGMENTS_PER_REQUEST * RING_SIZE is the maximum number of
>> - * pages that blkback will persistently map.
>> - * Currently, this is:
>> - * RING_SIZE = 32 (for all known ring types)
>> - * BLKIF_MAX_SEGMENTS_PER_REQUEST = 11
>> - * sizeof(struct persistent_gnt) = 48
>> - * So the maximum memory used to store the grants is:
>> - * 32 * 11 * 48 = 16896 bytes
>> - */
>> -static inline unsigned int max_mapped_grant_pages(enum blkif_protocol protocol)
>> -{
>> -     switch (protocol) {
>> -     case BLKIF_PROTOCOL_NATIVE:
>> -             return __CONST_RING_SIZE(blkif, PAGE_SIZE) *
>> -                        BLKIF_MAX_SEGMENTS_PER_REQUEST;
>> -     case BLKIF_PROTOCOL_X86_32:
>> -             return __CONST_RING_SIZE(blkif_x86_32, PAGE_SIZE) *
>> -                        BLKIF_MAX_SEGMENTS_PER_REQUEST;
>> -     case BLKIF_PROTOCOL_X86_64:
>> -             return __CONST_RING_SIZE(blkif_x86_64, PAGE_SIZE) *
>> -                        BLKIF_MAX_SEGMENTS_PER_REQUEST;
>> -     default:
>> -             BUG();
>> -     }
>> -     return 0;
>> -}
>> -
>> -
>> -/*
>>   * Little helpful macro to figure out the index and virtual address of the
>>   * pending_pages[..]. For each 'pending_req' we have have up to
>>   * BLKIF_MAX_SEGMENTS_PER_REQUEST (11) pages. The seg would be from 0 through
>> @@ -251,6 +259,76 @@ static void free_persistent_gnts(struct rb_root *root, unsigned int num)
>>       BUG_ON(num != 0);
>>  }
>>
>> +static int purge_persistent_gnt(struct rb_root *root, int num)
>> +{
>> +     struct gnttab_unmap_grant_ref unmap[BLKIF_MAX_SEGMENTS_PER_REQUEST];
>> +     struct page *pages[BLKIF_MAX_SEGMENTS_PER_REQUEST];
>> +     struct persistent_gnt *persistent_gnt;
>> +     struct rb_node *n;
>> +     int ret, segs_to_unmap = 0;
>> +     int requested_num = num;
>> +     int preserve_used = 1;
> 
> Boolean? And perhaps 'scan_dirty' ?

Sure

> 
> 
>> +
>> +     pr_debug("Requested the purge of %d persistent grants\n", num);
>> +
>> +purge_list:
> 
> This could be written a bit differently to also run outside the xen_blkif_schedule
> (so a new thread). This would require using the lock mechanism and converting
> this big loop to two smaller loops:
>  1) - one quick that holds the lock - to take the items of the list,
>  2) second one to do the grant_set_unmap_op operations and all the heavy
>     free_xenballooned_pages call.

Yes, I could add a list_head to persistent_gnt, so we can take them out
of the red-black tree and queue them in a list to be processed (unmap +
free) after we have looped thought the list, without holding the lock.

> 
> .. As this function ends up (presumarily?) causing xen_blkif_schedule to be doing
> this for some time every second. Irregardless of how utilized the ring is - so
> if we are 100% busy - we should not need to call this function. But if we do,
> then we end up walking the persistent_gnt twice - once with preserve_used set
> to true, and the other with it set to false.
> 
> We don't really want that - so is there a way for xen_blkif_schedule to
> do a quick determintion of this caliber:
> 
> 
>         if (RING_HAS_UNCONSUMED_REQUESTS(x) >= some_value)
>                 wait_up(blkif->purgarator)

It's not possible to tell if all grants will be in use just by looking
at the number of active requests, since all requests might just be using
one segment, and thus the list of persistent grants could be purged
without problems. We could keep a count of the number of active grants
at each time and use that to check if we can kick the purge or not.

if (grants_in_use > (persistent_gnt_c - num_purge))
	wait(...)

> And the thread would just sit there until kicked in action?

And when a request frees some grants it could be kicked back to action.

> 
> 
>> +     foreach_grant_safe(persistent_gnt, n, root, node) {
>> +             BUG_ON(persistent_gnt->handle ==
>> +                     BLKBACK_INVALID_HANDLE);
>> +
>> +             if (persistent_gnt->flags & PERSISTENT_GNT_ACTIVE)
>> +                     continue;
>> +             if (preserve_used &&
>> +                 (persistent_gnt->flags & PERSISTENT_GNT_USED))
> 
> Is that similar to DIRTY on pagetables?

Well, not exactly. This is a very simple LRU scheme, so I just mark this
grant as "USED", this way when we execute the LRU we check for grants
not marked as "USED", and after cleaning unused grants we clean the
"USED" bit from all remaining persistent grants. Rudimentary, but still
provides a good hit ratio.

> 
>> +                     continue;
>> +
>> +             gnttab_set_unmap_op(&unmap[segs_to_unmap],
>> +                     (unsigned long) pfn_to_kaddr(page_to_pfn(
>> +                             persistent_gnt->page)),
>> +                     GNTMAP_host_map,
>> +                     persistent_gnt->handle);
>> +
>> +             pages[segs_to_unmap] = persistent_gnt->page;
>> +
>> +             if (++segs_to_unmap == BLKIF_MAX_SEGMENTS_PER_REQUEST) {
>> +                     ret = gnttab_unmap_refs(unmap, NULL, pages,
>> +                             segs_to_unmap);
>> +                     BUG_ON(ret);
>> +                     free_xenballooned_pages(segs_to_unmap, pages);
>> +                     segs_to_unmap = 0;
>> +             }
>> +
>> +             rb_erase(&persistent_gnt->node, root);
>> +             kfree(persistent_gnt);
>> +             if (--num == 0)
>> +                     goto finished;
>> +     }
>> +     /*
>> +      * If we get here it means we also need to start cleaning
>> +      * grants that were used since last purge in order to cope
>> +      * with the requested num
>> +      */
>> +     if (preserve_used) {
>> +             pr_debug("Still missing %d purged frames\n", num);
>> +             preserve_used = 0;
>> +             goto purge_list;
>> +     }
>> +finished:
>> +     if (segs_to_unmap > 0) {
>> +             ret = gnttab_unmap_refs(unmap, NULL, pages, segs_to_unmap);
>> +             BUG_ON(ret);
>> +             free_xenballooned_pages(segs_to_unmap, pages);
>> +     }
>> +     /* Finally remove the "used" flag from all the persistent grants */
>> +     foreach_grant_safe(persistent_gnt, n, root, node) {
>> +             BUG_ON(persistent_gnt->handle ==
>> +                     BLKBACK_INVALID_HANDLE);
>> +             persistent_gnt->flags &= ~PERSISTENT_GNT_USED;
>> +     }
>> +     pr_debug("Purged %d/%d\n", (requested_num - num), requested_num);
>> +     return (requested_num - num);
>> +}
>> +
>>  /*
>>   * Retrieve from the 'pending_reqs' a free pending_req structure to be used.
>>   */
>> @@ -397,6 +475,8 @@ int xen_blkif_schedule(void *arg)
>>  {
>>       struct xen_blkif *blkif = arg;
>>       struct xen_vbd *vbd = &blkif->vbd;
>> +     int rq_purge, purged;
>> +     unsigned long timeout;
>>
>>       xen_blkif_get(blkif);
>>
>> @@ -406,13 +486,21 @@ int xen_blkif_schedule(void *arg)
>>               if (unlikely(vbd->size != vbd_sz(vbd)))
>>                       xen_vbd_resize(blkif);
>>
>> -             wait_event_interruptible(
>> +             timeout = msecs_to_jiffies(xen_blkif_lru_interval);
>> +
>> +             timeout = wait_event_interruptible_timeout(
>>                       blkif->wq,
>> -                     blkif->waiting_reqs || kthread_should_stop());
>> -             wait_event_interruptible(
>> +                     blkif->waiting_reqs || kthread_should_stop(),
>> +                     timeout);
>> +             if (timeout == 0)
>> +                     goto purge_gnt_list;
>> +             timeout = wait_event_interruptible_timeout(
>>                       blkbk->pending_free_wq,
>>                       !list_empty(&blkbk->pending_free) ||
>> -                     kthread_should_stop());
>> +                     kthread_should_stop(),
>> +                     timeout);
>> +             if (timeout == 0)
>> +                     goto purge_gnt_list;
>>
>>               blkif->waiting_reqs = 0;
>>               smp_mb(); /* clear flag *before* checking for work */
>> @@ -420,6 +508,32 @@ int xen_blkif_schedule(void *arg)
>>               if (do_block_io_op(blkif))
>>                       blkif->waiting_reqs = 1;
>>
>> +purge_gnt_list:
>> +             if (blkif->vbd.feature_gnt_persistent &&
>> +                 time_after(jiffies, blkif->next_lru)) {
>> +                     /* Clean the list of persistent grants */
>> +                     if (blkif->persistent_gnt_c > xen_blkif_max_pgrants ||
>> +                         (blkif->persistent_gnt_c == xen_blkif_max_pgrants &&
>> +                          blkif->vbd.overflow_max_grants)) {
>> +                             rq_purge = blkif->persistent_gnt_c -
>> +                                        xen_blkif_max_pgrants +
>> +                                        xen_blkif_lru_num_clean;
> 
> You can make this more than 80 lines.

OK, good to know :)

>> +                             rq_purge = rq_purge > blkif->persistent_gnt_c ?
>> +                                        blkif->persistent_gnt_c : rq_purge;
>> +                             purged = purge_persistent_gnt(
>> +                                       &blkif->persistent_gnts, rq_purge);
>> +                             if (purged != rq_purge)
>> +                                     pr_debug(DRV_PFX " unable to meet persistent grants purge requirements for device %#x, domain %u, requested %d done %d\n",
>> +                                              blkif->domid,
>> +                                              blkif->vbd.handle,
>> +                                              rq_purge, purged);
>> +                             blkif->persistent_gnt_c -= purged;
>> +                             blkif->vbd.overflow_max_grants = 0;
>> +                     }
>> +                     blkif->next_lru = jiffies +
>> +                             msecs_to_jiffies(xen_blkif_lru_interval);
>> +             }
>> +
>>               if (log_stats && time_after(jiffies, blkif->st_print))
>>                       print_stats(blkif);
>>       }
>> @@ -453,13 +567,18 @@ static void xen_blkbk_unmap(struct pending_req *req)
>>  {
>>       struct gnttab_unmap_grant_ref unmap[BLKIF_MAX_SEGMENTS_PER_REQUEST];
>>       struct page *pages[BLKIF_MAX_SEGMENTS_PER_REQUEST];
>> +     struct persistent_gnt *persistent_gnt;
>>       unsigned int i, invcount = 0;
>>       grant_handle_t handle;
>>       int ret;
>>
>>       for (i = 0; i < req->nr_pages; i++) {
>> -             if (!test_bit(i, req->unmap_seg))
>> +             if (req->persistent_gnts[i] != NULL) {
>> +                     persistent_gnt = req->persistent_gnts[i];
>> +                     persistent_gnt->flags |= PERSISTENT_GNT_USED;
>> +                     persistent_gnt->flags &= ~PERSISTENT_GNT_ACTIVE;
>>                       continue;
>> +             }
>>               handle = pending_handle(req, i);
>>               if (handle == BLKBACK_INVALID_HANDLE)
>>                       continue;
>> @@ -480,8 +599,8 @@ static int xen_blkbk_map(struct blkif_request *req,
>>                        struct page *pages[])
>>  {
>>       struct gnttab_map_grant_ref map[BLKIF_MAX_SEGMENTS_PER_REQUEST];
>> -     struct persistent_gnt *persistent_gnts[BLKIF_MAX_SEGMENTS_PER_REQUEST];
>>       struct page *pages_to_gnt[BLKIF_MAX_SEGMENTS_PER_REQUEST];
>> +     struct persistent_gnt **persistent_gnts = pending_req->persistent_gnts;
>>       struct persistent_gnt *persistent_gnt = NULL;
>>       struct xen_blkif *blkif = pending_req->blkif;
>>       phys_addr_t addr = 0;
>> @@ -494,9 +613,6 @@ static int xen_blkbk_map(struct blkif_request *req,
>>
>>       use_persistent_gnts = (blkif->vbd.feature_gnt_persistent);
>>
>> -     BUG_ON(blkif->persistent_gnt_c >
>> -                max_mapped_grant_pages(pending_req->blkif->blk_protocol));
>> -
>>       /*
>>        * Fill out preq.nr_sects with proper amount of sectors, and setup
>>        * assign map[..] with the PFN of the page in our domain with the
>> @@ -516,9 +632,9 @@ static int xen_blkbk_map(struct blkif_request *req,
>>                        * the grant is already mapped
>>                        */
>>                       new_map = false;
>> +                     persistent_gnt->flags |= PERSISTENT_GNT_ACTIVE;
>>               } else if (use_persistent_gnts &&
>> -                        blkif->persistent_gnt_c <
>> -                        max_mapped_grant_pages(blkif->blk_protocol)) {
>> +                        blkif->persistent_gnt_c < xen_blkif_max_pgrants) {
>>                       /*
>>                        * We are using persistent grants, the grant is
>>                        * not mapped but we have room for it
>> @@ -536,6 +652,7 @@ static int xen_blkbk_map(struct blkif_request *req,
>>                       }
>>                       persistent_gnt->gnt = req->u.rw.seg[i].gref;
>>                       persistent_gnt->handle = BLKBACK_INVALID_HANDLE;
>> +                     persistent_gnt->flags = PERSISTENT_GNT_ACTIVE;
>>
>>                       pages_to_gnt[segs_to_map] =
>>                               persistent_gnt->page;
>> @@ -547,7 +664,7 @@ static int xen_blkbk_map(struct blkif_request *req,
>>                       blkif->persistent_gnt_c++;
>>                       pr_debug(DRV_PFX " grant %u added to the tree of persistent grants, using %u/%u\n",
>>                                persistent_gnt->gnt, blkif->persistent_gnt_c,
>> -                              max_mapped_grant_pages(blkif->blk_protocol));
>> +                              xen_blkif_max_pgrants);
>>               } else {
>>                       /*
>>                        * We are either using persistent grants and
>> @@ -557,7 +674,7 @@ static int xen_blkbk_map(struct blkif_request *req,
>>                       if (use_persistent_gnts &&
>>                               !blkif->vbd.overflow_max_grants) {
>>                               blkif->vbd.overflow_max_grants = 1;
>> -                             pr_alert(DRV_PFX " domain %u, device %#x is using maximum number of persistent grants\n",
>> +                             pr_debug(DRV_PFX " domain %u, device %#x is using maximum number of persistent grants\n",
>>                                        blkif->domid, blkif->vbd.handle);
>>                       }
>>                       new_map = true;
>> @@ -595,7 +712,6 @@ static int xen_blkbk_map(struct blkif_request *req,
>>        * so that when we access vaddr(pending_req,i) it has the contents of
>>        * the page from the other domain.
>>        */
>> -     bitmap_zero(pending_req->unmap_seg, BLKIF_MAX_SEGMENTS_PER_REQUEST);
>>       for (i = 0, j = 0; i < nseg; i++) {
>>               if (!persistent_gnts[i] ||
>>                   persistent_gnts[i]->handle == BLKBACK_INVALID_HANDLE) {
>> @@ -634,7 +750,6 @@ static int xen_blkbk_map(struct blkif_request *req,
>>                               (req->u.rw.seg[i].first_sect << 9);
>>               } else {
>>                       pending_handle(pending_req, i) = map[j].handle;
>> -                     bitmap_set(pending_req->unmap_seg, i, 1);
>>
>>                       if (ret) {
>>                               j++;
>> diff --git a/drivers/block/xen-blkback/common.h b/drivers/block/xen-blkback/common.h
>> index f338f8a..bd44d75 100644
>> --- a/drivers/block/xen-blkback/common.h
>> +++ b/drivers/block/xen-blkback/common.h
>> @@ -167,11 +167,14 @@ struct xen_vbd {
>>
>>  struct backend_info;
>>
>> +#define PERSISTENT_GNT_ACTIVE        0x1
>> +#define PERSISTENT_GNT_USED          0x2
>>
>>  struct persistent_gnt {
>>       struct page *page;
>>       grant_ref_t gnt;
>>       grant_handle_t handle;
>> +     uint8_t flags;
>>       struct rb_node node;
>>  };
>>
>> @@ -204,6 +207,7 @@ struct xen_blkif {
>>       /* tree to store persistent grants */
>>       struct rb_root          persistent_gnts;
>>       unsigned int            persistent_gnt_c;
>> +     unsigned long           next_lru;
>>
>>       /* statistics */
>>       unsigned long           st_print;
>> diff --git a/drivers/block/xen-blkback/xenbus.c b/drivers/block/xen-blkback/xenbus.c
>> index 5e237f6..abb399a 100644
>> --- a/drivers/block/xen-blkback/xenbus.c
>> +++ b/drivers/block/xen-blkback/xenbus.c
>> @@ -116,6 +116,7 @@ static struct xen_blkif *xen_blkif_alloc(domid_t domid)
>>       init_completion(&blkif->drain_complete);
>>       atomic_set(&blkif->drain, 0);
>>       blkif->st_print = jiffies;
>> +     blkif->next_lru = jiffies;
>>       init_waitqueue_head(&blkif->waiting_to_free);
>>       blkif->persistent_gnts.rb_node = NULL;
>>
>> --
>> 1.7.7.5 (Apple Git-26)
>>

