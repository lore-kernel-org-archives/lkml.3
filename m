Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758840Ab3CDUW5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Mar 2013 15:22:57 -0500
Received: from aserp1040.oracle.com ([141.146.126.69]:36862 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757555Ab3CDUW4 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Mar 2013 15:22:56 -0500
Date: Mon, 4 Mar 2013 15:22:48 -0500
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: Roger Pau Monne <roger.pau@citrix.com>
Cc: linux-kernel@vger.kernel.org, xen-devel@lists.xen.org
Subject: Re: [PATCH RFC 08/12] xen-blkback: use balloon pages for all mappings
Message-ID: <20130304202248.GK15386@phenom.dumpdata.com>
References: <1362047335-26402-1-git-send-email-roger.pau@citrix.com>
 <1362047335-26402-9-git-send-email-roger.pau@citrix.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <1362047335-26402-9-git-send-email-roger.pau@citrix.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Content-Transfer-Encoding: 8BIT
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 28, 2013 at 11:28:51AM +0100, Roger Pau Monne wrote:
> Using balloon pages for all granted pages allows us to simplify the
> logic in blkback, specially in the xen_blkbk_map function, since now

especially

> we can decide if we want to map a grant persistently or not after we
> have actually mapped it. This could not be done before because
> persistent grants used ballooned pages, and non-persistent grants used
                                          ^^^whereas
> pages from the kernel.
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
> ---
>  drivers/block/xen-blkback/blkback.c |  278 +++++++++++++++++++----------------
>  drivers/block/xen-blkback/common.h  |    5 +
>  drivers/block/xen-blkback/xenbus.c  |    3 +

You also need a Documentation/ABI/sysfs-stable/... file.

>  3 files changed, 159 insertions(+), 127 deletions(-)
> 
> diff --git a/drivers/block/xen-blkback/blkback.c b/drivers/block/xen-blkback/blkback.c
> index b5e7495..ba27fc3 100644
> --- a/drivers/block/xen-blkback/blkback.c
> +++ b/drivers/block/xen-blkback/blkback.c
> @@ -101,6 +101,21 @@ module_param_named(lru_num_clean, xen_blkif_lru_num_clean, int, 0644);
>  MODULE_PARM_DESC(lru_num_clean,
>  "Number of persistent grants to unmap when the list is full");
>  
> +/*
> + * Maximum number of unused free pages to keep in the internal buffer.
> + * Setting this to a value too low will reduce memory used in each backend,
> + * but can have a performance penalty.
> + *
> + * A sane value is xen_blkif_reqs * BLKIF_MAX_SEGMENTS_PER_REQUEST, but can

Should that value be default value then?

> + * be set to a lower value that might degrade performance on some intensive
> + * IO workloads.
> + */
> +
> +static int xen_blkif_max_buffer_pages = 1024;
> +module_param_named(max_buffer_pages, xen_blkif_max_buffer_pages, int, 0644);
> +MODULE_PARM_DESC(max_buffer_pages,
> +"Maximum number of free pages to keep in each block backend buffer");
> +
>  /* Run-time switchable: /sys/module/blkback/parameters/ */
>  static unsigned int log_stats;
>  module_param(log_stats, int, 0644);
> @@ -120,6 +135,7 @@ struct pending_req {
>  	int			status;
>  	struct list_head	free_list;
>  	struct persistent_gnt	*persistent_gnts[BLKIF_MAX_SEGMENTS_PER_REQUEST];
> +	struct page		*pages[BLKIF_MAX_SEGMENTS_PER_REQUEST];
>  };
>  
>  #define BLKBACK_INVALID_HANDLE (~0)
> @@ -131,8 +147,6 @@ struct xen_blkbk {
>  	/* And its spinlock. */
>  	spinlock_t		pending_free_lock;
>  	wait_queue_head_t	pending_free_wq;
> -	/* The list of all pages that are available. */
> -	struct page		**pending_pages;
>  	/* And the grant handles that are available. */
>  	grant_handle_t		*pending_grant_handles;
>  };
> @@ -151,14 +165,66 @@ static inline int vaddr_pagenr(struct pending_req *req, int seg)
>  		BLKIF_MAX_SEGMENTS_PER_REQUEST + seg;
>  }
>  
> -#define pending_page(req, seg) pending_pages[vaddr_pagenr(req, seg)]
> +static inline int get_free_page(struct xen_blkif *blkif, struct page **page)
> +{
> +	unsigned long flags;
> +
> +	spin_lock_irqsave(&blkif->free_pages_lock, flags);
> +	if (list_empty(&blkif->free_pages)) {
> +		BUG_ON(blkif->free_pages_num != 0);
> +		spin_unlock_irqrestore(&blkif->free_pages_lock, flags);
> +		return alloc_xenballooned_pages(1, page, false);
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
> +static inline void remove_free_pages(struct xen_blkif *blkif, int num)

Perhaps 'shrink_free_pagepool'?

>  {
> -	unsigned long pfn = page_to_pfn(blkbk->pending_page(req, seg));
> -	return (unsigned long)pfn_to_kaddr(pfn);
> +	/* Remove requested pages in batches of 10 */
> +	struct page *page[10];

Hrmp. #define!

> +	unsigned long flags;
> +	int num_pages = 0;

unsigned int

> +
> +	spin_lock_irqsave(&blkif->free_pages_lock, flags);
> +	while (blkif->free_pages_num > num) {
> +		BUG_ON(list_empty(&blkif->free_pages));
> +		page[num_pages] = list_first_entry(&blkif->free_pages,
> +		                                   struct page, lru);
> +		list_del(&page[num_pages]->lru);
> +		blkif->free_pages_num--;
> +		if (++num_pages == 10) {
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
> @@ -178,7 +244,7 @@ static void make_response(struct xen_blkif *blkif, u64 id,
>  	     (n) = (&(pos)->node != NULL) ? rb_next(&(pos)->node) : NULL)
>  
>  
> -static void add_persistent_gnt(struct rb_root *root,
> +static int add_persistent_gnt(struct rb_root *root,
>  			       struct persistent_gnt *persistent_gnt)
>  {
>  	struct rb_node **new = &(root->rb_node), *parent = NULL;
> @@ -194,14 +260,15 @@ static void add_persistent_gnt(struct rb_root *root,
>  		else if (persistent_gnt->gnt > this->gnt)
>  			new = &((*new)->rb_right);
>  		else {
> -			pr_alert(DRV_PFX " trying to add a gref that's already in the tree\n");
> -			BUG();
> +			pr_alert_ratelimited(DRV_PFX " trying to add a gref that's already in the tree\n");
> +			return -EINVAL;

That looks like a seperate bug-fix patch? Especially the pr_alert_ratelimited
part?

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
> @@ -223,7 +290,8 @@ static struct persistent_gnt *get_persistent_gnt(struct rb_root *root,
>  	return NULL;
>  }
>  
> -static void free_persistent_gnts(struct rb_root *root, unsigned int num)
> +static void free_persistent_gnts(struct xen_blkif *blkif, struct rb_root *root,
> +                                 unsigned int num)
>  {
>  	struct gnttab_unmap_grant_ref unmap[BLKIF_MAX_SEGMENTS_PER_REQUEST];
>  	struct page *pages[BLKIF_MAX_SEGMENTS_PER_REQUEST];
> @@ -248,7 +316,7 @@ static void free_persistent_gnts(struct rb_root *root, unsigned int num)
>  			ret = gnttab_unmap_refs(unmap, NULL, pages,
>  				segs_to_unmap);
>  			BUG_ON(ret);
> -			free_xenballooned_pages(segs_to_unmap, pages);
> +			put_free_pages(blkif, pages, segs_to_unmap);
>  			segs_to_unmap = 0;
>  		}
>  
> @@ -259,7 +327,8 @@ static void free_persistent_gnts(struct rb_root *root, unsigned int num)
>  	BUG_ON(num != 0);
>  }
>  
> -static int purge_persistent_gnt(struct rb_root *root, int num)
> +static int purge_persistent_gnt(struct xen_blkif *blkif, struct rb_root *root,
> +                                int num)
>  {
>  	struct gnttab_unmap_grant_ref unmap[BLKIF_MAX_SEGMENTS_PER_REQUEST];
>  	struct page *pages[BLKIF_MAX_SEGMENTS_PER_REQUEST];
> @@ -294,7 +363,7 @@ purge_list:
>  			ret = gnttab_unmap_refs(unmap, NULL, pages,
>  				segs_to_unmap);
>  			BUG_ON(ret);
> -			free_xenballooned_pages(segs_to_unmap, pages);
> +			put_free_pages(blkif, pages, segs_to_unmap);
>  			segs_to_unmap = 0;
>  		}
>  
> @@ -317,7 +386,7 @@ finished:
>  	if (segs_to_unmap > 0) {
>  		ret = gnttab_unmap_refs(unmap, NULL, pages, segs_to_unmap);
>  		BUG_ON(ret);
> -		free_xenballooned_pages(segs_to_unmap, pages);
> +		put_free_pages(blkif, pages, segs_to_unmap);
>  	}
>  	/* Finally remove the "used" flag from all the persistent grants */
>  	foreach_grant_safe(persistent_gnt, n, root, node) {
> @@ -521,7 +590,7 @@ purge_gnt_list:
>  				           xen_blkif_lru_num_clean;
>  				rq_purge = rq_purge > blkif->persistent_gnt_c ?
>  				           blkif->persistent_gnt_c : rq_purge;
> -				purged = purge_persistent_gnt(
> +				purged = purge_persistent_gnt(blkif,
>  					  &blkif->persistent_gnts, rq_purge);
>  				if (purged != rq_purge)
>  					pr_debug(DRV_PFX " unable to meet persistent grants purge requirements for device %#x, domain %u, requested %d done %d\n",
> @@ -535,13 +604,17 @@ purge_gnt_list:
>  			        msecs_to_jiffies(xen_blkif_lru_interval);
>  		}
>  
> +		remove_free_pages(blkif, xen_blkif_max_buffer_pages);
> +
>  		if (log_stats && time_after(jiffies, blkif->st_print))
>  			print_stats(blkif);
>  	}
>  
> +	remove_free_pages(blkif, 0);

What purpose does that have?

> +
>  	/* Free all persistent grant pages */
>  	if (!RB_EMPTY_ROOT(&blkif->persistent_gnts))
> -		free_persistent_gnts(&blkif->persistent_gnts,
> +		free_persistent_gnts(blkif, &blkif->persistent_gnts,
>  			blkif->persistent_gnt_c);
>  
>  	BUG_ON(!RB_EMPTY_ROOT(&blkif->persistent_gnts));
> @@ -571,6 +644,7 @@ static void xen_blkbk_unmap(struct pending_req *req)
>  	struct persistent_gnt *persistent_gnt;
>  	unsigned int i, invcount = 0;
>  	grant_handle_t handle;
> +	struct xen_blkif *blkif = req->blkif;
>  	int ret;
>  
>  	for (i = 0; i < req->nr_pages; i++) {
> @@ -581,17 +655,18 @@ static void xen_blkbk_unmap(struct pending_req *req)
>  			continue;
>  		}
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
> @@ -606,7 +681,6 @@ static int xen_blkbk_map(struct blkif_request *req,
>  	struct xen_blkif *blkif = pending_req->blkif;
>  	phys_addr_t addr = 0;
>  	int i, j;
> -	bool new_map;
>  	int nseg = req->u.rw.nr_segments;
>  	int segs_to_map = 0;
>  	int ret = 0;
> @@ -632,69 +706,17 @@ static int xen_blkbk_map(struct blkif_request *req,
>  			 * We are using persistent grants and
>  			 * the grant is already mapped
>  			 */
> -			new_map = false;
>  			persistent_gnt->flags |= PERSISTENT_GNT_ACTIVE;
> -		} else if (use_persistent_gnts &&
> -			   blkif->persistent_gnt_c < xen_blkif_max_pgrants) {
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
> -			persistent_gnt->flags = PERSISTENT_GNT_ACTIVE;
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
> -				 xen_blkif_max_pgrants);
> -		} else {
> -			/*
> -			 * We are either using persistent grants and
> -			 * hit the maximum limit of grants mapped,
> -			 * or we are not using persistent grants.
> -			 */
> -			if (use_persistent_gnts &&
> -				!blkif->vbd.overflow_max_grants) {
> -				blkif->vbd.overflow_max_grants = 1;
> -				pr_debug(DRV_PFX " domain %u, device %#x is using maximum number of persistent grants\n",
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
> @@ -714,54 +736,71 @@ static int xen_blkbk_map(struct blkif_request *req,
>  	 * the page from the other domain.
>  	 */
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
>  			}
> +			pending_handle(pending_req, i) = map[j].handle;
>  		}
> -		if (persistent_gnts[i]) {
> -			if (persistent_gnts[i]->handle ==
> -			    BLKBACK_INVALID_HANDLE) {
> +		if (persistent_gnts[i])
> +			goto next;
> +		if (use_persistent_gnts &&
> +		    blkif->persistent_gnt_c < xen_blkif_max_pgrants) {
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
> -			}
> -			pending_handle(pending_req, i) =
> -				persistent_gnts[i]->handle;
> -
> -			if (ret)
> -				continue;
> -
> -			seg[i].buf = pfn_to_mfn(page_to_pfn(
> -				persistent_gnts[i]->page)) << PAGE_SHIFT |
> -				(req->u.rw.seg[i].first_sect << 9);
> -		} else {
> -			pending_handle(pending_req, i) = map[j].handle;
> -
> -			if (ret) {
>  				j++;
> -				continue;
> +				goto next;
>  			}
> -
> -			seg[i].buf = map[j++].dev_bus_addr |
> -				(req->u.rw.seg[i].first_sect << 9);
> +			persistent_gnt->gnt = map[j].ref;
> +			persistent_gnt->handle = map[j].handle;
> +			persistent_gnt->flags = PERSISTENT_GNT_ACTIVE;
> +			persistent_gnt->page = pages[i];
> +			if (add_persistent_gnt(&blkif->persistent_gnts,
> +			                       persistent_gnt)) {
> +				kfree(persistent_gnt);
> +				goto next;
> +			}
> +			blkif->persistent_gnt_c++;
> +			persistent_gnts[i] = persistent_gnt;
> +			pr_debug(DRV_PFX " grant %u added to the tree of persistent grants, using %u/%u\n",
> +				 persistent_gnt->gnt, blkif->persistent_gnt_c,
> +				 xen_blkif_max_pgrants);
> +			j++;
> +			goto next;
> +		}
> +		if (use_persistent_gnts && !blkif->vbd.overflow_max_grants) {
> +			blkif->vbd.overflow_max_grants = 1;
> +			pr_debug(DRV_PFX " domain %u, device %#x is using maximum number of persistent grants\n",
> +			         blkif->domid, blkif->vbd.handle);
>  		}
> +		j++;
> +next:
> +		seg[i].buf = pfn_to_mfn(page_to_pfn(pages[i])) << PAGE_SHIFT |
> +		             (req->u.rw.seg[i].first_sect << 9);
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
> @@ -962,7 +1001,7 @@ static int dispatch_rw_block_io(struct xen_blkif *blkif,
>  	int operation;
>  	struct blk_plug plug;
>  	bool drain = false;
> -	struct page *pages[BLKIF_MAX_SEGMENTS_PER_REQUEST];
> +	struct page **pages = pending_req->pages;
>  
>  	switch (req->operation) {
>  	case BLKIF_OP_READ:
> @@ -1193,22 +1232,14 @@ static int __init xen_blkif_init(void)
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
> @@ -1233,13 +1264,6 @@ static int __init xen_blkif_init(void)
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
> index bd44d75..604bd30 100644
> --- a/drivers/block/xen-blkback/common.h
> +++ b/drivers/block/xen-blkback/common.h
> @@ -209,6 +209,11 @@ struct xen_blkif {
>  	unsigned int		persistent_gnt_c;
>  	unsigned long		next_lru;
>  
> +	/* buffer of free pages to map grant refs */
> +	spinlock_t		free_pages_lock;
> +	int			free_pages_num;
> +	struct list_head	free_pages;
> +
>  	/* statistics */
>  	unsigned long		st_print;
>  	int			st_rd_req;
> diff --git a/drivers/block/xen-blkback/xenbus.c b/drivers/block/xen-blkback/xenbus.c
> index abb399a..d7926ec 100644
> --- a/drivers/block/xen-blkback/xenbus.c
> +++ b/drivers/block/xen-blkback/xenbus.c
> @@ -119,6 +119,9 @@ static struct xen_blkif *xen_blkif_alloc(domid_t domid)
>  	blkif->next_lru = jiffies;
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
