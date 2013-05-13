Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751709Ab3EMNUf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 May 2013 09:20:35 -0400
Received: from userp1040.oracle.com ([156.151.31.81]:50190 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751314Ab3EMNUd convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 May 2013 09:20:33 -0400
Date: Mon, 13 May 2013 09:20:23 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: Roger Pau Monne <roger.pau@citrix.com>
Cc: xen-devel@lists.xen.org, linux-kernel@vger.kernel.org,
        David Vrabel <david.vrabel@citrix.com>
Subject: Re: [PATCH v3] xen-blkback: allocate list of pending reqs in small
 chunks
Message-ID: <20130513132023.GE6811@phenom.dumpdata.com>
References: <1367482877-1460-1-git-send-email-roger.pau@citrix.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <1367482877-1460-1-git-send-email-roger.pau@citrix.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Content-Transfer-Encoding: 8BIT
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 02, 2013 at 10:21:17AM +0200, Roger Pau Monne wrote:
> Allocate pending requests in smaller chunks instead of allocating them
> all at the same time.
> 
> This change also removes the global array of pending_reqs, it is no
> longer necessay.
> 
> Variables related to the grant mapping have been grouped into a struct
> called "grant_page", this allows to allocate them in smaller chunks,
> and also improves memory locality.

Applied.
> 
> Signed-off-by: Roger Pau Monné <roger.pau@citrix.com>
> Reported-by: Sander Eikelenboom <linux@eikelenboom.it>
> Tested-by: Sander Eikelenboom <linux@eikelenboom.it>
> Reviewed-by: David Vrabel <david.vrabel@citrix.com>
> Cc: David Vrabel <david.vrabel@citrix.com>
> Cc: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
> ---
> Changes since v2:
>  * Add Sander Tested-by.
> Changes since v1:
>  * Remove stray pr_alert.
> ---
>  drivers/block/xen-blkback/blkback.c |   92 +++++++++++++++--------------------
>  drivers/block/xen-blkback/common.h  |   18 +++---
>  drivers/block/xen-blkback/xenbus.c  |   74 +++++++++++++++++++++------
>  3 files changed, 106 insertions(+), 78 deletions(-)
> 
> diff --git a/drivers/block/xen-blkback/blkback.c b/drivers/block/xen-blkback/blkback.c
> index 1ebc0aa..e79ab45 100644
> --- a/drivers/block/xen-blkback/blkback.c
> +++ b/drivers/block/xen-blkback/blkback.c
> @@ -641,9 +641,7 @@ purge_gnt_list:
>   * used in the 'pending_req'.
>   */
>  static void xen_blkbk_unmap(struct xen_blkif *blkif,
> -                            grant_handle_t handles[],
> -                            struct page *pages[],
> -                            struct persistent_gnt *persistent_gnts[],
> +                            struct grant_page *pages[],
>                              int num)
>  {
>  	struct gnttab_unmap_grant_ref unmap[BLKIF_MAX_SEGMENTS_PER_REQUEST];
> @@ -652,16 +650,16 @@ static void xen_blkbk_unmap(struct xen_blkif *blkif,
>  	int ret;
>  
>  	for (i = 0; i < num; i++) {
> -		if (persistent_gnts[i] != NULL) {
> -			put_persistent_gnt(blkif, persistent_gnts[i]);
> +		if (pages[i]->persistent_gnt != NULL) {
> +			put_persistent_gnt(blkif, pages[i]->persistent_gnt);
>  			continue;
>  		}
> -		if (handles[i] == BLKBACK_INVALID_HANDLE)
> +		if (pages[i]->handle == BLKBACK_INVALID_HANDLE)
>  			continue;
> -		unmap_pages[invcount] = pages[i];
> -		gnttab_set_unmap_op(&unmap[invcount], vaddr(pages[i]),
> -				    GNTMAP_host_map, handles[i]);
> -		handles[i] = BLKBACK_INVALID_HANDLE;
> +		unmap_pages[invcount] = pages[i]->page;
> +		gnttab_set_unmap_op(&unmap[invcount], vaddr(pages[i]->page),
> +				    GNTMAP_host_map, pages[i]->handle);
> +		pages[i]->handle = BLKBACK_INVALID_HANDLE;
>  		if (++invcount == BLKIF_MAX_SEGMENTS_PER_REQUEST) {
>  			ret = gnttab_unmap_refs(unmap, NULL, unmap_pages,
>  			                        invcount);
> @@ -677,10 +675,8 @@ static void xen_blkbk_unmap(struct xen_blkif *blkif,
>  	}
>  }
>  
> -static int xen_blkbk_map(struct xen_blkif *blkif, grant_ref_t grefs[],
> -			 struct persistent_gnt *persistent_gnts[],
> -			 grant_handle_t handles[],
> -			 struct page *pages[],
> +static int xen_blkbk_map(struct xen_blkif *blkif,
> +			 struct grant_page *pages[],
>  			 int num, bool ro)
>  {
>  	struct gnttab_map_grant_ref map[BLKIF_MAX_SEGMENTS_PER_REQUEST];
> @@ -707,26 +703,26 @@ again:
>  		if (use_persistent_gnts)
>  			persistent_gnt = get_persistent_gnt(
>  				blkif,
> -				grefs[i]);
> +				pages[i]->gref);
>  
>  		if (persistent_gnt) {
>  			/*
>  			 * We are using persistent grants and
>  			 * the grant is already mapped
>  			 */
> -			pages[i] = persistent_gnt->page;
> -			persistent_gnts[i] = persistent_gnt;
> +			pages[i]->page = persistent_gnt->page;
> +			pages[i]->persistent_gnt = persistent_gnt;
>  		} else {
> -			if (get_free_page(blkif, &pages[i]))
> +			if (get_free_page(blkif, &pages[i]->page))
>  				goto out_of_memory;
> -			addr = vaddr(pages[i]);
> -			pages_to_gnt[segs_to_map] = pages[i];
> -			persistent_gnts[i] = NULL;
> +			addr = vaddr(pages[i]->page);
> +			pages_to_gnt[segs_to_map] = pages[i]->page;
> +			pages[i]->persistent_gnt = NULL;
>  			flags = GNTMAP_host_map;
>  			if (!use_persistent_gnts && ro)
>  				flags |= GNTMAP_readonly;
>  			gnttab_set_map_op(&map[segs_to_map++], addr,
> -					  flags, grefs[i],
> +					  flags, pages[i]->gref,
>  					  blkif->domid);
>  		}
>  		map_until = i + 1;
> @@ -745,16 +741,16 @@ again:
>  	 * the page from the other domain.
>  	 */
>  	for (seg_idx = last_map, new_map_idx = 0; seg_idx < map_until; seg_idx++) {
> -		if (!persistent_gnts[seg_idx]) {
> +		if (!pages[seg_idx]->persistent_gnt) {
>  			/* This is a newly mapped grant */
>  			BUG_ON(new_map_idx >= segs_to_map);
>  			if (unlikely(map[new_map_idx].status != 0)) {
>  				pr_debug(DRV_PFX "invalid buffer -- could not remap it\n");
> -				handles[seg_idx] = BLKBACK_INVALID_HANDLE;
> +				pages[seg_idx]->handle = BLKBACK_INVALID_HANDLE;
>  				ret |= 1;
>  				goto next;
>  			}
> -			handles[seg_idx] = map[new_map_idx].handle;
> +			pages[seg_idx]->handle = map[new_map_idx].handle;
>  		} else {
>  			continue;
>  		}
> @@ -776,14 +772,14 @@ again:
>  			}
>  			persistent_gnt->gnt = map[new_map_idx].ref;
>  			persistent_gnt->handle = map[new_map_idx].handle;
> -			persistent_gnt->page = pages[seg_idx];
> +			persistent_gnt->page = pages[seg_idx]->page;
>  			if (add_persistent_gnt(blkif,
>  			                       persistent_gnt)) {
>  				kfree(persistent_gnt);
>  				persistent_gnt = NULL;
>  				goto next;
>  			}
> -			persistent_gnts[seg_idx] = persistent_gnt;
> +			pages[seg_idx]->persistent_gnt = persistent_gnt;
>  			pr_debug(DRV_PFX " grant %u added to the tree of persistent grants, using %u/%u\n",
>  				 persistent_gnt->gnt, blkif->persistent_gnt_c,
>  				 xen_blkif_max_pgrants);
> @@ -814,15 +810,11 @@ out_of_memory:
>  	return -ENOMEM;
>  }
>  
> -static int xen_blkbk_map_seg(struct pending_req *pending_req,
> -			     struct seg_buf seg[],
> -			     struct page *pages[])
> +static int xen_blkbk_map_seg(struct pending_req *pending_req)
>  {
>  	int rc;
>  
> -	rc = xen_blkbk_map(pending_req->blkif, pending_req->grefs,
> -	                   pending_req->persistent_gnts,
> -	                   pending_req->grant_handles, pending_req->pages,
> +	rc = xen_blkbk_map(pending_req->blkif, pending_req->segments,
>  			   pending_req->nr_pages,
>  	                   (pending_req->operation != BLKIF_OP_READ));
>  
> @@ -834,9 +826,7 @@ static int xen_blkbk_parse_indirect(struct blkif_request *req,
>  				    struct seg_buf seg[],
>  				    struct phys_req *preq)
>  {
> -	struct persistent_gnt **persistent =
> -		pending_req->indirect_persistent_gnts;
> -	struct page **pages = pending_req->indirect_pages;
> +	struct grant_page **pages = pending_req->indirect_pages;
>  	struct xen_blkif *blkif = pending_req->blkif;
>  	int indirect_grefs, rc, n, nseg, i;
>  	struct blkif_request_segment_aligned *segments = NULL;
> @@ -845,9 +835,10 @@ static int xen_blkbk_parse_indirect(struct blkif_request *req,
>  	indirect_grefs = INDIRECT_PAGES(nseg);
>  	BUG_ON(indirect_grefs > BLKIF_MAX_INDIRECT_PAGES_PER_REQUEST);
>  
> -	rc = xen_blkbk_map(blkif, req->u.indirect.indirect_grefs,
> -			   persistent, pending_req->indirect_handles,
> -			   pages, indirect_grefs, true);
> +	for (i = 0; i < indirect_grefs; i++)
> +		pages[i]->gref = req->u.indirect.indirect_grefs[i];
> +
> +	rc = xen_blkbk_map(blkif, pages, indirect_grefs, true);
>  	if (rc)
>  		goto unmap;
>  
> @@ -856,10 +847,10 @@ static int xen_blkbk_parse_indirect(struct blkif_request *req,
>  			/* Map indirect segments */
>  			if (segments)
>  				kunmap_atomic(segments);
> -			segments = kmap_atomic(pages[n/SEGS_PER_INDIRECT_FRAME]);
> +			segments = kmap_atomic(pages[n/SEGS_PER_INDIRECT_FRAME]->page);
>  		}
>  		i = n % SEGS_PER_INDIRECT_FRAME;
> -		pending_req->grefs[n] = segments[i].gref;
> +		pending_req->segments[n]->gref = segments[i].gref;
>  		seg[n].nsec = segments[i].last_sect -
>  			segments[i].first_sect + 1;
>  		seg[n].offset = (segments[i].first_sect << 9);
> @@ -874,8 +865,7 @@ static int xen_blkbk_parse_indirect(struct blkif_request *req,
>  unmap:
>  	if (segments)
>  		kunmap_atomic(segments);
> -	xen_blkbk_unmap(blkif, pending_req->indirect_handles,
> -			pages, persistent, indirect_grefs);
> +	xen_blkbk_unmap(blkif, pages, indirect_grefs);
>  	return rc;
>  }
>  
> @@ -965,9 +955,8 @@ static void __end_block_io_op(struct pending_req *pending_req, int error)
>  	 * the proper response on the ring.
>  	 */
>  	if (atomic_dec_and_test(&pending_req->pendcnt)) {
> -		xen_blkbk_unmap(pending_req->blkif, pending_req->grant_handles,
> -		                pending_req->pages,
> -		                pending_req->persistent_gnts,
> +		xen_blkbk_unmap(pending_req->blkif,
> +		                pending_req->segments,
>  		                pending_req->nr_pages);
>  		make_response(pending_req->blkif, pending_req->id,
>  			      pending_req->operation, pending_req->status);
> @@ -1104,7 +1093,7 @@ static int dispatch_rw_block_io(struct xen_blkif *blkif,
>  	int operation;
>  	struct blk_plug plug;
>  	bool drain = false;
> -	struct page **pages = pending_req->pages;
> +	struct grant_page **pages = pending_req->segments;
>  	unsigned short req_operation;
>  
>  	req_operation = req->operation == BLKIF_OP_INDIRECT ?
> @@ -1165,7 +1154,7 @@ static int dispatch_rw_block_io(struct xen_blkif *blkif,
>  		preq.dev               = req->u.rw.handle;
>  		preq.sector_number     = req->u.rw.sector_number;
>  		for (i = 0; i < nseg; i++) {
> -			pending_req->grefs[i] = req->u.rw.seg[i].gref;
> +			pages[i]->gref = req->u.rw.seg[i].gref;
>  			seg[i].nsec = req->u.rw.seg[i].last_sect -
>  				req->u.rw.seg[i].first_sect + 1;
>  			seg[i].offset = (req->u.rw.seg[i].first_sect << 9);
> @@ -1216,7 +1205,7 @@ static int dispatch_rw_block_io(struct xen_blkif *blkif,
>  	 * the hypercall to unmap the grants - that is all done in
>  	 * xen_blkbk_unmap.
>  	 */
> -	if (xen_blkbk_map_seg(pending_req, seg, pages))
> +	if (xen_blkbk_map_seg(pending_req))
>  		goto fail_flush;
>  
>  	/*
> @@ -1228,7 +1217,7 @@ static int dispatch_rw_block_io(struct xen_blkif *blkif,
>  	for (i = 0; i < nseg; i++) {
>  		while ((bio == NULL) ||
>  		       (bio_add_page(bio,
> -				     pages[i],
> +				     pages[i]->page,
>  				     seg[i].nsec << 9,
>  				     seg[i].offset) == 0)) {
>  
> @@ -1277,8 +1266,7 @@ static int dispatch_rw_block_io(struct xen_blkif *blkif,
>  	return 0;
>  
>   fail_flush:
> -	xen_blkbk_unmap(blkif, pending_req->grant_handles,
> -	                pending_req->pages, pending_req->persistent_gnts,
> +	xen_blkbk_unmap(blkif, pending_req->segments,
>  	                pending_req->nr_pages);
>   fail_response:
>  	/* Haven't submitted any bio's yet. */
> diff --git a/drivers/block/xen-blkback/common.h b/drivers/block/xen-blkback/common.h
> index 1ac53da..c6b4cb9 100644
> --- a/drivers/block/xen-blkback/common.h
> +++ b/drivers/block/xen-blkback/common.h
> @@ -297,8 +297,6 @@ struct xen_blkif {
>  	int			free_pages_num;
>  	struct list_head	free_pages;
>  
> -	/* Allocation of pending_reqs */
> -	struct pending_req	*pending_reqs;
>  	/* List of all 'pending_req' available */
>  	struct list_head	pending_free;
>  	/* And its spinlock. */
> @@ -323,6 +321,13 @@ struct seg_buf {
>  	unsigned int nsec;
>  };
>  
> +struct grant_page {
> +	struct page 		*page;
> +	struct persistent_gnt	*persistent_gnt;
> +	grant_handle_t		handle;
> +	grant_ref_t		gref;
> +};
> +
>  /*
>   * Each outstanding request that we've passed to the lower device layers has a
>   * 'pending_req' allocated to it. Each buffer_head that completes decrements
> @@ -337,14 +342,9 @@ struct pending_req {
>  	unsigned short		operation;
>  	int			status;
>  	struct list_head	free_list;
> -	struct page		*pages[MAX_INDIRECT_SEGMENTS];
> -	struct persistent_gnt	*persistent_gnts[MAX_INDIRECT_SEGMENTS];
> -	grant_handle_t		grant_handles[MAX_INDIRECT_SEGMENTS];
> -	grant_ref_t		grefs[MAX_INDIRECT_SEGMENTS];
> +	struct grant_page	*segments[MAX_INDIRECT_SEGMENTS];
>  	/* Indirect descriptors */
> -	struct persistent_gnt	*indirect_persistent_gnts[MAX_INDIRECT_PAGES];
> -	struct page		*indirect_pages[MAX_INDIRECT_PAGES];
> -	grant_handle_t		indirect_handles[MAX_INDIRECT_PAGES];
> +	struct grant_page	*indirect_pages[MAX_INDIRECT_PAGES];
>  	struct seg_buf		seg[MAX_INDIRECT_SEGMENTS];
>  	struct bio		*biolist[MAX_INDIRECT_SEGMENTS];
>  };
> diff --git a/drivers/block/xen-blkback/xenbus.c b/drivers/block/xen-blkback/xenbus.c
> index afab208..4a4749c 100644
> --- a/drivers/block/xen-blkback/xenbus.c
> +++ b/drivers/block/xen-blkback/xenbus.c
> @@ -105,7 +105,8 @@ static void xen_update_blkif_status(struct xen_blkif *blkif)
>  static struct xen_blkif *xen_blkif_alloc(domid_t domid)
>  {
>  	struct xen_blkif *blkif;
> -	int i;
> +	struct pending_req *req, *n;
> +	int i, j;
>  
>  	BUILD_BUG_ON(MAX_INDIRECT_PAGES > BLKIF_MAX_INDIRECT_PAGES_PER_REQUEST);
>  
> @@ -127,22 +128,51 @@ static struct xen_blkif *xen_blkif_alloc(domid_t domid)
>  	blkif->free_pages_num = 0;
>  	atomic_set(&blkif->persistent_gnt_in_use, 0);
>  
> -	blkif->pending_reqs = kcalloc(XEN_BLKIF_REQS,
> -	                              sizeof(blkif->pending_reqs[0]),
> -	                              GFP_KERNEL);
> -	if (!blkif->pending_reqs) {
> -		kmem_cache_free(xen_blkif_cachep, blkif);
> -		return ERR_PTR(-ENOMEM);
> -	}
>  	INIT_LIST_HEAD(&blkif->pending_free);
> +
> +	for (i = 0; i < XEN_BLKIF_REQS; i++) {
> +		req = kzalloc(sizeof(*req), GFP_KERNEL);
> +		if (!req)
> +			goto fail;
> +		list_add_tail(&req->free_list,
> +		              &blkif->pending_free);
> +		for (j = 0; j < MAX_INDIRECT_SEGMENTS; j++) {
> +			req->segments[j] = kzalloc(sizeof(*req->segments[0]),
> +			                           GFP_KERNEL);
> +			if (!req->segments[j])
> +				goto fail;
> +		}
> +		for (j = 0; j < MAX_INDIRECT_PAGES; j++) {
> +			req->indirect_pages[j] = kzalloc(sizeof(*req->indirect_pages[0]),
> +			                                 GFP_KERNEL);
> +			if (!req->indirect_pages[j])
> +				goto fail;
> +		}
> +	}
>  	spin_lock_init(&blkif->pending_free_lock);
>  	init_waitqueue_head(&blkif->pending_free_wq);
>  
> -	for (i = 0; i < XEN_BLKIF_REQS; i++)
> -		list_add_tail(&blkif->pending_reqs[i].free_list,
> -			      &blkif->pending_free);
> -
>  	return blkif;
> +
> +fail:
> +	list_for_each_entry_safe(req, n, &blkif->pending_free, free_list) {
> +		list_del(&req->free_list);
> +		for (j = 0; j < MAX_INDIRECT_SEGMENTS; j++) {
> +			if (!req->segments[j])
> +				break;
> +			kfree(req->segments[j]);
> +		}
> +		for (j = 0; j < MAX_INDIRECT_PAGES; j++) {
> +			if (!req->indirect_pages[j])
> +				break;
> +			kfree(req->indirect_pages[j]);
> +		}
> +		kfree(req);
> +	}
> +
> +	kmem_cache_free(xen_blkif_cachep, blkif);
> +
> +	return ERR_PTR(-ENOMEM);
>  }
>  
>  static int xen_blkif_map(struct xen_blkif *blkif, unsigned long shared_page,
> @@ -221,18 +251,28 @@ static void xen_blkif_disconnect(struct xen_blkif *blkif)
>  
>  static void xen_blkif_free(struct xen_blkif *blkif)
>  {
> -	struct pending_req *req;
> -	int i = 0;
> +	struct pending_req *req, *n;
> +	int i = 0, j;
>  
>  	if (!atomic_dec_and_test(&blkif->refcnt))
>  		BUG();
>  
>  	/* Check that there is no request in use */
> -	list_for_each_entry(req, &blkif->pending_free, free_list)
> +	list_for_each_entry_safe(req, n, &blkif->pending_free, free_list) {
> +		list_del(&req->free_list);
> +
> +		for (j = 0; j < MAX_INDIRECT_SEGMENTS; j++)
> +			kfree(req->segments[j]);
> +
> +		for (j = 0; j < MAX_INDIRECT_PAGES; j++)
> +			kfree(req->indirect_pages[j]);
> +
> +		kfree(req);
>  		i++;
> -	BUG_ON(i != XEN_BLKIF_REQS);
> +	}
> +
> +	WARN_ON(i != XEN_BLKIF_REQS);
>  
> -	kfree(blkif->pending_reqs);
>  	kmem_cache_free(xen_blkif_cachep, blkif);
>  }
>  
> -- 
> 1.7.7.5 (Apple Git-26)
> 
