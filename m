Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936258Ab3DIOrn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Apr 2013 10:47:43 -0400
Received: from aserp1040.oracle.com ([141.146.126.69]:40249 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762631Ab3DIOrl convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Apr 2013 10:47:41 -0400
Date: Tue, 9 Apr 2013 10:47:33 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: Roger Pau Monne <roger.pau@citrix.com>
Cc: linux-kernel@vger.kernel.org, xen-devel@lists.xen.org
Subject: Re: [PATCH v1 2/7] xen-blkback: use balloon pages for all mappings
Message-ID: <20130409144733.GA3158@phenom.dumpdata.com>
References: <1364382643-3711-1-git-send-email-roger.pau@citrix.com>
 <1364382643-3711-3-git-send-email-roger.pau@citrix.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <1364382643-3711-3-git-send-email-roger.pau@citrix.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Content-Transfer-Encoding: 8BIT
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 27, 2013 at 12:10:38PM +0100, Roger Pau Monne wrote:
> Using balloon pages for all granted pages allows us to simplify the
> logic in blkback, especially in the xen_blkbk_map function, since now
> we can decide if we want to map a grant persistently or not after we
> have actually mapped it. This could not be done before because
> persistent grants used ballooned pages, whereas non-persistent grants
> used pages from the kernel.
> 
> This patch also introduces several changes, the first one is that the
> list of free pages is no longer global, now each blkback instance has
> it's own list of free pages that can be used to map grants. Also, a
> run time parameter (max_buffer_pages) has been added in order to tune
> the maximum number of free pages each blkback instance will keep in
> it's buffer.
> 
> Signed-off-by: Roger Pau Monné <roger.pau@citrix.com>
> Cc: xen-devel@lists.xen.org
> Cc: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>

Sorry for the late review. Some comments.
> ---
> Changes since RFC:
>  * Fix typos in commit message.
>  * Minor fixes in code.
> ---
>  Documentation/ABI/stable/sysfs-bus-xen-backend |    8 +
>  drivers/block/xen-blkback/blkback.c            |  265 +++++++++++++-----------
>  drivers/block/xen-blkback/common.h             |    5 +
>  drivers/block/xen-blkback/xenbus.c             |    3 +
>  4 files changed, 165 insertions(+), 116 deletions(-)
> 
> diff --git a/Documentation/ABI/stable/sysfs-bus-xen-backend b/Documentation/ABI/stable/sysfs-bus-xen-backend
> index 3d5951c..e04afe0 100644
> --- a/Documentation/ABI/stable/sysfs-bus-xen-backend
> +++ b/Documentation/ABI/stable/sysfs-bus-xen-backend
> @@ -73,3 +73,11 @@ KernelVersion:	3.0
>  Contact:	Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
>  Description:
>                  Number of sectors written by the frontend.
> +
> +What:           /sys/module/xen_blkback/parameters/max_buffer_pages
> +Date:           March 2013
> +KernelVersion:  3.10
> +Contact:        Roger Pau Monné <roger.pau@citrix.com>
> +Description:
> +                Maximum number of free pages to keep in each block
> +                backend buffer.
> diff --git a/drivers/block/xen-blkback/blkback.c b/drivers/block/xen-blkback/blkback.c
> index f7526db..8a1892a 100644
> --- a/drivers/block/xen-blkback/blkback.c
> +++ b/drivers/block/xen-blkback/blkback.c
> @@ -63,6 +63,21 @@ static int xen_blkif_reqs = 64;
>  module_param_named(reqs, xen_blkif_reqs, int, 0);
>  MODULE_PARM_DESC(reqs, "Number of blkback requests to allocate");
>  
> +/*
> + * Maximum number of unused free pages to keep in the internal buffer.
> + * Setting this to a value too low will reduce memory used in each backend,
> + * but can have a performance penalty.
> + *
> + * A sane value is xen_blkif_reqs * BLKIF_MAX_SEGMENTS_PER_REQUEST, but can
> + * be set to a lower value that might degrade performance on some intensive
> + * IO workloads.
> + */
> +
> +static int xen_blkif_max_buffer_pages = 704;
> +module_param_named(max_buffer_pages, xen_blkif_max_buffer_pages, int, 0644);
> +MODULE_PARM_DESC(max_buffer_pages,
> +"Maximum number of free pages to keep in each block backend buffer");
> +
>  /* Run-time switchable: /sys/module/blkback/parameters/ */
>  static unsigned int log_stats;
>  module_param(log_stats, int, 0644);
> @@ -82,10 +97,14 @@ struct pending_req {
>  	int			status;
>  	struct list_head	free_list;
>  	DECLARE_BITMAP(unmap_seg, BLKIF_MAX_SEGMENTS_PER_REQUEST);
> +	struct page		*pages[BLKIF_MAX_SEGMENTS_PER_REQUEST];
>  };
>  
>  #define BLKBACK_INVALID_HANDLE (~0)
>  
> +/* Number of free pages to remove on each call to free_xenballooned_pages */
> +#define NUM_BATCH_FREE_PAGES 10
> +
>  struct xen_blkbk {
>  	struct pending_req	*pending_reqs;
>  	/* List of all 'pending_req' available */
> @@ -93,8 +112,6 @@ struct xen_blkbk {
>  	/* And its spinlock. */
>  	spinlock_t		pending_free_lock;
>  	wait_queue_head_t	pending_free_wq;
> -	/* The list of all pages that are available. */
> -	struct page		**pending_pages;
>  	/* And the grant handles that are available. */
>  	grant_handle_t		*pending_grant_handles;
>  };
> @@ -143,14 +160,66 @@ static inline int vaddr_pagenr(struct pending_req *req, int seg)
>  		BLKIF_MAX_SEGMENTS_PER_REQUEST + seg;
>  }
>  
> -#define pending_page(req, seg) pending_pages[vaddr_pagenr(req, seg)]
> +static inline int get_free_page(struct xen_blkif *blkif, struct page **page)
> +{
> +	unsigned long flags;
> +
> +	spin_lock_irqsave(&blkif->free_pages_lock, flags);

I am curious to why you need to use the irqsave variant one here, as
> +	if (list_empty(&blkif->free_pages)) {
> +		BUG_ON(blkif->free_pages_num != 0);
> +		spin_unlock_irqrestore(&blkif->free_pages_lock, flags);
> +		return alloc_xenballooned_pages(1, page, false);

This function is using an mutex.

which would imply it is OK to have an non-irq variant of spinlock?

> +	}
> +	BUG_ON(blkif->free_pages_num == 0);
> +	page[0] = list_first_entry(&blkif->free_pages, struct page, lru);
> +	list_del(&page[0]->lru);
> +	blkif->free_pages_num--;
> +	spin_unlock_irqrestore(&blkif->free_pages_lock, flags);
> +
> +	return 0;
> +}
> +
> +static inline void put_free_pages(struct xen_blkif *blkif, struct page **page,
> +                                  int num)
> +{
> +	unsigned long flags;
> +	int i;
> +
> +	spin_lock_irqsave(&blkif->free_pages_lock, flags);
> +	for (i = 0; i < num; i++)
> +		list_add(&page[i]->lru, &blkif->free_pages);
> +	blkif->free_pages_num += num;
> +	spin_unlock_irqrestore(&blkif->free_pages_lock, flags);
> +}
>  
> -static inline unsigned long vaddr(struct pending_req *req, int seg)
> +static inline void shrink_free_pagepool(struct xen_blkif *blkif, int num)
>  {
> -	unsigned long pfn = page_to_pfn(blkbk->pending_page(req, seg));
> -	return (unsigned long)pfn_to_kaddr(pfn);
> +	/* Remove requested pages in batches of NUM_BATCH_FREE_PAGES */
> +	struct page *page[NUM_BATCH_FREE_PAGES];
> +	unsigned long flags;
> +	unsigned int num_pages = 0;
> +
> +	spin_lock_irqsave(&blkif->free_pages_lock, flags);
> +	while (blkif->free_pages_num > num) {
> +		BUG_ON(list_empty(&blkif->free_pages));
> +		page[num_pages] = list_first_entry(&blkif->free_pages,
> +		                                   struct page, lru);
> +		list_del(&page[num_pages]->lru);
> +		blkif->free_pages_num--;
> +		if (++num_pages == NUM_BATCH_FREE_PAGES) {
> +			spin_unlock_irqrestore(&blkif->free_pages_lock, flags);
> +			free_xenballooned_pages(num_pages, page);
> +			spin_lock_irqsave(&blkif->free_pages_lock, flags);
> +			num_pages = 0;
> +		}
> +	}
> +	spin_unlock_irqrestore(&blkif->free_pages_lock, flags);
> +	if (num_pages != 0)
> +		free_xenballooned_pages(num_pages, page);
>  }
>  
> +#define vaddr(page) ((unsigned long)pfn_to_kaddr(page_to_pfn(page)))
> +
>  #define pending_handle(_req, _seg) \
>  	(blkbk->pending_grant_handles[vaddr_pagenr(_req, _seg)])
>  
> @@ -170,7 +239,7 @@ static void make_response(struct xen_blkif *blkif, u64 id,
>  	     (n) = (&(pos)->node != NULL) ? rb_next(&(pos)->node) : NULL)
>  
>  
> -static void add_persistent_gnt(struct rb_root *root,
> +static int add_persistent_gnt(struct rb_root *root,
>  			       struct persistent_gnt *persistent_gnt)
>  {
>  	struct rb_node **new = &(root->rb_node), *parent = NULL;
> @@ -186,14 +255,15 @@ static void add_persistent_gnt(struct rb_root *root,
>  		else if (persistent_gnt->gnt > this->gnt)
>  			new = &((*new)->rb_right);
>  		else {
> -			pr_alert(DRV_PFX " trying to add a gref that's already in the tree\n");
> -			BUG();
> +			pr_alert_ratelimited(DRV_PFX " trying to add a gref that's already in the tree\n");
> +			return -EINVAL;
>  		}
>  	}
>  
>  	/* Add new node and rebalance tree. */
>  	rb_link_node(&(persistent_gnt->node), parent, new);
>  	rb_insert_color(&(persistent_gnt->node), root);
> +	return 0;
>  }
>  
>  static struct persistent_gnt *get_persistent_gnt(struct rb_root *root,
> @@ -215,7 +285,8 @@ static struct persistent_gnt *get_persistent_gnt(struct rb_root *root,
>  	return NULL;
>  }
>  
> -static void free_persistent_gnts(struct rb_root *root, unsigned int num)
> +static void free_persistent_gnts(struct xen_blkif *blkif, struct rb_root *root,
> +                                 unsigned int num)
>  {
>  	struct gnttab_unmap_grant_ref unmap[BLKIF_MAX_SEGMENTS_PER_REQUEST];
>  	struct page *pages[BLKIF_MAX_SEGMENTS_PER_REQUEST];
> @@ -240,7 +311,7 @@ static void free_persistent_gnts(struct rb_root *root, unsigned int num)
>  			ret = gnttab_unmap_refs(unmap, NULL, pages,
>  				segs_to_unmap);
>  			BUG_ON(ret);
> -			free_xenballooned_pages(segs_to_unmap, pages);
> +			put_free_pages(blkif, pages, segs_to_unmap);
>  			segs_to_unmap = 0;
>  		}
>  
> @@ -422,13 +493,17 @@ int xen_blkif_schedule(void *arg)
>  		if (do_block_io_op(blkif))
>  			blkif->waiting_reqs = 1;
>  
> +		shrink_free_pagepool(blkif, xen_blkif_max_buffer_pages);

That threw me off the first time I saw it. I somehow thought it meant
to shrink all xen_blkif_max_buffer_pages, not the value "above" it.

Might need a comment saying: "/* Shrink if we have more than xen_blkif_max_buffer_pages. */"


> +
>  		if (log_stats && time_after(jiffies, blkif->st_print))
>  			print_stats(blkif);
>  	}
>  
> +	shrink_free_pagepool(blkif, 0);

Add a little comment by the zero please that says: /* All */

> +
>  	/* Free all persistent grant pages */
>  	if (!RB_EMPTY_ROOT(&blkif->persistent_gnts))
> -		free_persistent_gnts(&blkif->persistent_gnts,
> +		free_persistent_gnts(blkif, &blkif->persistent_gnts,
>  			blkif->persistent_gnt_c);
>  
>  	BUG_ON(!RB_EMPTY_ROOT(&blkif->persistent_gnts));
> @@ -457,23 +532,25 @@ static void xen_blkbk_unmap(struct pending_req *req)
>  	struct page *pages[BLKIF_MAX_SEGMENTS_PER_REQUEST];
>  	unsigned int i, invcount = 0;
>  	grant_handle_t handle;
> +	struct xen_blkif *blkif = req->blkif;
>  	int ret;
>  
>  	for (i = 0; i < req->nr_pages; i++) {
>  		if (!test_bit(i, req->unmap_seg))
>  			continue;
>  		handle = pending_handle(req, i);
> +		pages[invcount] = req->pages[i];
>  		if (handle == BLKBACK_INVALID_HANDLE)
>  			continue;
> -		gnttab_set_unmap_op(&unmap[invcount], vaddr(req, i),
> +		gnttab_set_unmap_op(&unmap[invcount], vaddr(pages[invcount]),
>  				    GNTMAP_host_map, handle);
>  		pending_handle(req, i) = BLKBACK_INVALID_HANDLE;
> -		pages[invcount] = virt_to_page(vaddr(req, i));
>  		invcount++;
>  	}
>  
>  	ret = gnttab_unmap_refs(unmap, NULL, pages, invcount);
>  	BUG_ON(ret);
> +	put_free_pages(blkif, pages, invcount);
>  }
>  
>  static int xen_blkbk_map(struct blkif_request *req,
> @@ -488,7 +565,6 @@ static int xen_blkbk_map(struct blkif_request *req,
>  	struct xen_blkif *blkif = pending_req->blkif;
>  	phys_addr_t addr = 0;
>  	int i, j;
> -	bool new_map;
>  	int nseg = req->u.rw.nr_segments;
>  	int segs_to_map = 0;
>  	int ret = 0;
> @@ -517,68 +593,16 @@ static int xen_blkbk_map(struct blkif_request *req,
>  			 * We are using persistent grants and
>  			 * the grant is already mapped
>  			 */
> -			new_map = false;
> -		} else if (use_persistent_gnts &&
> -			   blkif->persistent_gnt_c <
> -			   max_mapped_grant_pages(blkif->blk_protocol)) {
> -			/*
> -			 * We are using persistent grants, the grant is
> -			 * not mapped but we have room for it
> -			 */
> -			new_map = true;
> -			persistent_gnt = kmalloc(
> -				sizeof(struct persistent_gnt),
> -				GFP_KERNEL);
> -			if (!persistent_gnt)
> -				return -ENOMEM;
> -			if (alloc_xenballooned_pages(1, &persistent_gnt->page,
> -			    false)) {
> -				kfree(persistent_gnt);
> -				return -ENOMEM;
> -			}
> -			persistent_gnt->gnt = req->u.rw.seg[i].gref;
> -			persistent_gnt->handle = BLKBACK_INVALID_HANDLE;
> -
> -			pages_to_gnt[segs_to_map] =
> -				persistent_gnt->page;
> -			addr = (unsigned long) pfn_to_kaddr(
> -				page_to_pfn(persistent_gnt->page));
> -
> -			add_persistent_gnt(&blkif->persistent_gnts,
> -				persistent_gnt);
> -			blkif->persistent_gnt_c++;
> -			pr_debug(DRV_PFX " grant %u added to the tree of persistent grants, using %u/%u\n",
> -				 persistent_gnt->gnt, blkif->persistent_gnt_c,
> -				 max_mapped_grant_pages(blkif->blk_protocol));
> -		} else {
> -			/*
> -			 * We are either using persistent grants and
> -			 * hit the maximum limit of grants mapped,
> -			 * or we are not using persistent grants.
> -			 */
> -			if (use_persistent_gnts &&
> -				!blkif->vbd.overflow_max_grants) {
> -				blkif->vbd.overflow_max_grants = 1;
> -				pr_alert(DRV_PFX " domain %u, device %#x is using maximum number of persistent grants\n",
> -					 blkif->domid, blkif->vbd.handle);
> -			}
> -			new_map = true;
> -			pages[i] = blkbk->pending_page(pending_req, i);
> -			addr = vaddr(pending_req, i);
> -			pages_to_gnt[segs_to_map] =
> -				blkbk->pending_page(pending_req, i);
> -		}
> -
> -		if (persistent_gnt) {

Nice :-)

>  			pages[i] = persistent_gnt->page;
>  			persistent_gnts[i] = persistent_gnt;
>  		} else {
> +			if (get_free_page(blkif, &pages[i]))
> +				goto out_of_memory;
> +			addr = vaddr(pages[i]);
> +			pages_to_gnt[segs_to_map] = pages[i];
>  			persistent_gnts[i] = NULL;
> -		}
> -
> -		if (new_map) {
>  			flags = GNTMAP_host_map;
> -			if (!persistent_gnt &&
> +			if (!use_persistent_gnts &&
>  			    (pending_req->operation != BLKIF_OP_READ))
>  				flags |= GNTMAP_readonly;
>  			gnttab_set_map_op(&map[segs_to_map++], addr,
> @@ -599,47 +623,71 @@ static int xen_blkbk_map(struct blkif_request *req,
>  	 */
>  	bitmap_zero(pending_req->unmap_seg, BLKIF_MAX_SEGMENTS_PER_REQUEST);
>  	for (i = 0, j = 0; i < nseg; i++) {
> -		if (!persistent_gnts[i] ||
> -		    persistent_gnts[i]->handle == BLKBACK_INVALID_HANDLE) {
> +		if (!persistent_gnts[i]) {
>  			/* This is a newly mapped grant */
>  			BUG_ON(j >= segs_to_map);
>  			if (unlikely(map[j].status != 0)) {
>  				pr_debug(DRV_PFX "invalid buffer -- could not remap it\n");
> -				map[j].handle = BLKBACK_INVALID_HANDLE;
> +				pending_handle(pending_req, i) =
> +					BLKBACK_INVALID_HANDLE;

You can make that on one line. The 80 character limit is not that ... strict anymore.
Here is what Ingo said about it:
https://lkml.org/lkml/2012/2/3/101

>  				ret |= 1;
> -				if (persistent_gnts[i]) {
> -					rb_erase(&persistent_gnts[i]->node,
> -						 &blkif->persistent_gnts);
> -					blkif->persistent_gnt_c--;
> -					kfree(persistent_gnts[i]);
> -					persistent_gnts[i] = NULL;
> -				}
> +				j++;
> +				continue;

The old code had abit of different logic for the non-persistent error path.
It would do:

 598                 if (!persistent_gnts[i] ||                                      
..
 602                         if (unlikely(map[j].status != 0)) {                     

 605                                 ret |= 1;    
.. then later.. for the !persisten_gnts case:

 634                 } else {                                                        
 635                         pending_handle(pending_req, i) = map[j].handle;         
 636                         bitmap_set(pending_req->unmap_seg, i, 1);               
 637                                                                                 
 638                         if (ret) {                                              
 639                                 j++;                                            
 640                                 continue;                                       
 641                         }                    
>  			}
> +			pending_handle(pending_req, i) = map[j].handle;

Which means that for this code, we skip the 635 (which is OK as you have done the
"pending_handle(pending_req, i) =  BLKBACK_INVALID_HANDLE", but what the 636 case
(that is the bitmap_set)?

It presumarily is OK, as the 'pending_handle(pending_req, i)' ends up being
set to BLKBACK_INVALID_HANDLE, so the loop in xen_blkbk_unmap will still skip
over it?

This I think warrants a little comment saying: "We can skip the bitmap_set' as
xen_blkbk_unmap can handle BLKBACK_INVALID_HANDLE'.

But then that begs the question - why do we even need the bitmap_set code path anymore?

>  		}
> -		if (persistent_gnts[i]) {
> -			if (persistent_gnts[i]->handle ==
> -			    BLKBACK_INVALID_HANDLE) {
> +		if (persistent_gnts[i])
> +			goto next;
> +		if (use_persistent_gnts &&
> +		    blkif->persistent_gnt_c <
> +		    max_mapped_grant_pages(blkif->blk_protocol)) {
> +			/*
> +			 * We are using persistent grants, the grant is
> +			 * not mapped but we have room for it
> +			 */
> +			persistent_gnt = kmalloc(sizeof(struct persistent_gnt),
> +				                 GFP_KERNEL);
> +			if (!persistent_gnt) {
>  				/*
> -				 * If this is a new persistent grant
> -				 * save the handler
> +				 * If we don't have enough memory to
> +				 * allocate the persistent_gnt struct
> +				 * map this grant non-persistenly
>  				 */
> -				persistent_gnts[i]->handle = map[j++].handle;
> +				j++;
> +				goto next;

So you are doing this by assuming that get_persistent_gnt in the earlier loop
failed, which means you have in effect done this:
	map[segs_to_map++]

Doing the next label will set:
  		seg[i].offset = (req->u.rw.seg[i].first_sect << 9);

OK, that sounds right. Is this then:

	bitmap_set(pending_req->unmap_seg, i, 1);

even needed? The "pending_handle(pending_req, i) = map[j].handle;" had already been
done in the  /* This is a newly mapped grant */ if case, so we are set there.

Perhaps you could update the comment from saying 'map this grant' (which
implies doing it NOW as opposed to have done it already), and say:

/*
.. continue using the grant non-persistently. Note that
we mapped it in the earlier loop and the earlier if conditional
sets pending_handle(pending_req, i) = map[j].handle.
*/



>  			}
> -			pending_handle(pending_req, i) =
> -				persistent_gnts[i]->handle;
> -
> -			if (ret)
> -				continue;
> -		} else {
> -			pending_handle(pending_req, i) = map[j++].handle;
> -			bitmap_set(pending_req->unmap_seg, i, 1);
> -
> -			if (ret)
> -				continue;
> +			persistent_gnt->gnt = map[j].ref;
> +			persistent_gnt->handle = map[j].handle;
> +			persistent_gnt->page = pages[i];

Oh boy, that is a confusing. i and j. Keep loosing track which one is which.
It lookis right.

> +			if (add_persistent_gnt(&blkif->persistent_gnts,
> +			                       persistent_gnt)) {
> +				kfree(persistent_gnt);

I would also say 'persisten_gnt = NULL' for extra measure of safety


> +				j++;

Perhaps the 'j' variable can be called 'map_idx' ? By this point I am pretty
sure I know what the 'i' and 'j' variables are used for, but if somebody new
is trying to grok this code they might spend some 5 minutes trying to figure
this out.

> +				goto next;
> +			}
> +			blkif->persistent_gnt_c++;
> +			pr_debug(DRV_PFX " grant %u added to the tree of persistent grants, using %u/%u\n",
> +				 persistent_gnt->gnt, blkif->persistent_gnt_c,
> +				 max_mapped_grant_pages(blkif->blk_protocol));
> +			j++;
> +			goto next;
>  		}
> +		if (use_persistent_gnts && !blkif->vbd.overflow_max_grants) {
> +			blkif->vbd.overflow_max_grants = 1;
> +			pr_debug(DRV_PFX " domain %u, device %#x is using maximum number of persistent grants\n",
> +			         blkif->domid, blkif->vbd.handle);
> +		}
> +		bitmap_set(pending_req->unmap_seg, i, 1);
> +		j++;
> +next:
>  		seg[i].offset = (req->u.rw.seg[i].first_sect << 9);
>  	}
>  	return ret;
> +
> +out_of_memory:
> +	pr_alert(DRV_PFX "%s: out of memory\n", __func__);
> +	put_free_pages(blkif, pages_to_gnt, segs_to_map);
> +	return -ENOMEM;
>  }
>  
>  static int dispatch_discard_io(struct xen_blkif *blkif,
> @@ -863,7 +911,7 @@ static int dispatch_rw_block_io(struct xen_blkif *blkif,
>  	int operation;
>  	struct blk_plug plug;
>  	bool drain = false;
> -	struct page *pages[BLKIF_MAX_SEGMENTS_PER_REQUEST];
> +	struct page **pages = pending_req->pages;
>  
>  	switch (req->operation) {
>  	case BLKIF_OP_READ:
> @@ -1090,22 +1138,14 @@ static int __init xen_blkif_init(void)
>  					xen_blkif_reqs, GFP_KERNEL);
>  	blkbk->pending_grant_handles = kmalloc(sizeof(blkbk->pending_grant_handles[0]) *
>  					mmap_pages, GFP_KERNEL);
> -	blkbk->pending_pages         = kzalloc(sizeof(blkbk->pending_pages[0]) *
> -					mmap_pages, GFP_KERNEL);
>  
> -	if (!blkbk->pending_reqs || !blkbk->pending_grant_handles ||
> -	    !blkbk->pending_pages) {
> +	if (!blkbk->pending_reqs || !blkbk->pending_grant_handles) {
>  		rc = -ENOMEM;
>  		goto out_of_memory;
>  	}
>  
>  	for (i = 0; i < mmap_pages; i++) {
>  		blkbk->pending_grant_handles[i] = BLKBACK_INVALID_HANDLE;
> -		blkbk->pending_pages[i] = alloc_page(GFP_KERNEL);
> -		if (blkbk->pending_pages[i] == NULL) {
> -			rc = -ENOMEM;
> -			goto out_of_memory;
> -		}
>  	}
>  	rc = xen_blkif_interface_init();
>  	if (rc)
> @@ -1130,13 +1170,6 @@ static int __init xen_blkif_init(void)
>   failed_init:
>  	kfree(blkbk->pending_reqs);
>  	kfree(blkbk->pending_grant_handles);
> -	if (blkbk->pending_pages) {
> -		for (i = 0; i < mmap_pages; i++) {
> -			if (blkbk->pending_pages[i])
> -				__free_page(blkbk->pending_pages[i]);
> -		}
> -		kfree(blkbk->pending_pages);
> -	}
>  	kfree(blkbk);
>  	blkbk = NULL;
>  	return rc;
> diff --git a/drivers/block/xen-blkback/common.h b/drivers/block/xen-blkback/common.h
> index 60103e2..6c73c38 100644
> --- a/drivers/block/xen-blkback/common.h
> +++ b/drivers/block/xen-blkback/common.h
> @@ -220,6 +220,11 @@ struct xen_blkif {
>  	struct rb_root		persistent_gnts;
>  	unsigned int		persistent_gnt_c;
>  
> +	/* buffer of free pages to map grant refs */
> +	spinlock_t		free_pages_lock;
> +	int			free_pages_num;
> +	struct list_head	free_pages;
> +
>  	/* statistics */
>  	unsigned long		st_print;
>  	unsigned long long			st_rd_req;
> diff --git a/drivers/block/xen-blkback/xenbus.c b/drivers/block/xen-blkback/xenbus.c
> index 8bfd1bc..24f7f6d 100644
> --- a/drivers/block/xen-blkback/xenbus.c
> +++ b/drivers/block/xen-blkback/xenbus.c
> @@ -118,6 +118,9 @@ static struct xen_blkif *xen_blkif_alloc(domid_t domid)
>  	blkif->st_print = jiffies;
>  	init_waitqueue_head(&blkif->waiting_to_free);
>  	blkif->persistent_gnts.rb_node = NULL;
> +	spin_lock_init(&blkif->free_pages_lock);
> +	INIT_LIST_HEAD(&blkif->free_pages);
> +	blkif->free_pages_num = 0;
>  
>  	return blkif;
>  }
> -- 
> 1.7.7.5 (Apple Git-26)
> 
