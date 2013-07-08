Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752931Ab3GHTmF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Jul 2013 15:42:05 -0400
Received: from aserp1040.oracle.com ([141.146.126.69]:22171 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752735Ab3GHTmC convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Jul 2013 15:42:02 -0400
Date: Mon, 8 Jul 2013 15:41:52 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: Roger Pau Monne <roger.pau@citrix.com>
Cc: xen-devel@lists.xen.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH RFC 4/4] xen-block: introduce a new request type to unmap
 grants
Message-ID: <20130708194152.GJ4927@phenom.dumpdata.com>
References: <1373288607-1876-1-git-send-email-roger.pau@citrix.com>
 <1373288607-1876-5-git-send-email-roger.pau@citrix.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <1373288607-1876-5-git-send-email-roger.pau@citrix.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Content-Transfer-Encoding: 8BIT
X-Source-IP: ucsinet22.oracle.com [156.151.31.94]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 08, 2013 at 03:03:27PM +0200, Roger Pau Monne wrote:
> Right now blkfront has no way to unmap grant refs, if using persistent
> grants once a grant is used blkfront cannot assure if blkback will
> have this grant mapped or not. To solve this problem, a new request
> type (BLKIF_OP_UNMAP) that allows requesting blkback to unmap certain
> grants is introduced.

I don't think this is the right way of doing it. It is a new operation
(BLKIF_OP_UNMAP) that has nothing to do with READ/WRITE. All it is
is just some way for the frontend to say: unmap this grant if you can.

As such I would think a better mechanism would be to have a new
grant mechanism that can say: 'I am done with this grant you can
remove it' - that is called to the hypervisor. The hypervisor
can then figure out whether it is free or not and lazily delete it.
(And the guest would be notified when it is freed).

I would presume that this problem would also exist with netback/netfront
if it started using persisten grants, right?

> 
> This request can only be used with the indirect operation, since if
> not using indirect segments the maximum number of grants used will be
> 352, which is very far from the default maximum number of grants.
> 
> The requested grefs to unmap are placed inside the indirect pages, so
> they can be parsed as an array of grant_ref_t once the indirect pages
> are mapped. This prevents us from introducing a new request struct,
> since we re-use the same struct from the indirect operation.
> 
> Signed-off-by: Roger Pau Monné <roger.pau@citrix.com>
> Cc: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
> ---
>  drivers/block/xen-blkback/blkback.c |  108 +++++++++++++++++-
>  drivers/block/xen-blkback/common.h  |   12 ++-
>  drivers/block/xen-blkback/xenbus.c  |   10 ++
>  drivers/block/xen-blkfront.c        |  223 +++++++++++++++++++++++++++++++----
>  include/xen/interface/io/blkif.h    |   13 ++
>  5 files changed, 337 insertions(+), 29 deletions(-)
> 
> diff --git a/drivers/block/xen-blkback/blkback.c b/drivers/block/xen-blkback/blkback.c
> index bf4b9d2..1def5d2 100644
> --- a/drivers/block/xen-blkback/blkback.c
> +++ b/drivers/block/xen-blkback/blkback.c
> @@ -167,6 +167,9 @@ static int do_block_io_op(struct xen_blkif *blkif);
>  static int dispatch_rw_block_io(struct xen_blkif *blkif,
>  				struct blkif_request *req,
>  				struct pending_req *pending_req);
> +static int dispatch_unmap(struct xen_blkif *blkif,
> +                          struct blkif_request *req,
> +                          struct pending_req *pending_req);
>  static void make_response(struct xen_blkif *blkif, u64 id,
>  			  unsigned short op, int st);
>  
> @@ -841,7 +844,7 @@ static int xen_blkbk_parse_indirect(struct blkif_request *req,
>  	struct blkif_request_segment_aligned *segments = NULL;
>  
>  	nseg = pending_req->nr_pages;
> -	indirect_grefs = INDIRECT_PAGES(nseg);
> +	indirect_grefs = INDIRECT_PAGES(nseg, SEGS_PER_INDIRECT_FRAME);
>  	BUG_ON(indirect_grefs > BLKIF_MAX_INDIRECT_PAGES_PER_REQUEST);
>  
>  	for (i = 0; i < indirect_grefs; i++)
> @@ -1064,10 +1067,18 @@ __do_block_io_op(struct xen_blkif *blkif)
>  		case BLKIF_OP_WRITE:
>  		case BLKIF_OP_WRITE_BARRIER:
>  		case BLKIF_OP_FLUSH_DISKCACHE:
> -		case BLKIF_OP_INDIRECT:
>  			if (dispatch_rw_block_io(blkif, &req, pending_req))
>  				goto done;
>  			break;
> +		case BLKIF_OP_INDIRECT:
> +			if (req.u.indirect.indirect_op == BLKIF_OP_UNMAP) {
> +				if (dispatch_unmap(blkif, &req, pending_req))
> +					goto done;
> +			} else {
> +				if (dispatch_rw_block_io(blkif, &req, pending_req))
> +					goto done;
> +			}
> +			break;
>  		case BLKIF_OP_DISCARD:
>  			free_req(blkif, pending_req);
>  			if (dispatch_discard_io(blkif, &req))
> @@ -1311,7 +1322,100 @@ static int dispatch_rw_block_io(struct xen_blkif *blkif,
>  	return -EIO;
>  }
>  
> +/*
> + * Unmap grefs on request from blkfront. This allows blkfront to securely
> + * free the grefs by making sure blkback no longer has them mapped.
> + */
> +static int dispatch_unmap(struct xen_blkif *blkif,
> +                          struct blkif_request *req,
> +                          struct pending_req *pending_req)
> +{
> +	unsigned int n_grants, n_pages;
> +	int i, n, rc, segs_to_unmap = 0;
> +	struct grant_page **pages = pending_req->indirect_pages;
> +	grant_ref_t *grefs = NULL;
> +	struct gnttab_unmap_grant_ref unmap[BLKIF_MAX_SEGMENTS_PER_REQUEST];
> +	struct page *unmap_pages[BLKIF_MAX_SEGMENTS_PER_REQUEST];
> +	struct persistent_gnt *persistent_gnt;
> +
> +	if ((req->operation != BLKIF_OP_INDIRECT) ||
> +	    (req->u.indirect.indirect_op != BLKIF_OP_UNMAP)) {
> +		pr_debug_ratelimited(DRV_PFX "Invalid indirect operation (%u)\n",
> +		                     req->u.indirect.indirect_op);
> +		rc = -EINVAL;
> +		goto response;
> +	}
>  
> +	n_grants = req->u.indirect.nr_segments;
> +	if (n_grants > (MAX_INDIRECT_PAGES * GREFS_PER_INDIRECT_FRAME)) {
> +		pr_debug_ratelimited(DRV_PFX "Tried to unmap too many grefs: %u limit: %lu\n",
> +		                     n_grants, (MAX_INDIRECT_PAGES * GREFS_PER_INDIRECT_FRAME));
> +		rc = -EINVAL;
> +		goto response;
> +	}
> +
> +	n_pages = INDIRECT_PAGES(n_grants, GREFS_PER_INDIRECT_FRAME);
> +	BUG_ON(n_pages > MAX_INDIRECT_PAGES);
> +	for (i = 0; i < n_pages; i++) {
> +		pages[i]->gref = req->u.indirect.indirect_grefs[i];
> +	}
> +
> +	rc = xen_blkbk_map(blkif, pages, n_pages, true);
> +	if (rc)
> +		goto unmap;
> +
> +	for (n = 0, i = 0; n < n_grants; n++) {
> +		if ((n % GREFS_PER_INDIRECT_FRAME) == 0) {
> +			/* Map indirect segments */
> +			if (grefs)
> +				kunmap_atomic(grefs);
> +			grefs = kmap_atomic(pages[n/GREFS_PER_INDIRECT_FRAME]->page);
> +		}
> +		i = n % GREFS_PER_INDIRECT_FRAME;
> +
> +		persistent_gnt = get_persistent_gnt(blkif, grefs[i]);
> +		if (!persistent_gnt)
> +			continue;
> +
> +		rb_erase(&persistent_gnt->node, &blkif->persistent_gnts);
> +		blkif->persistent_gnt_c--;
> +		atomic_dec(&blkif->persistent_gnt_in_use);
> +
> +		gnttab_set_unmap_op(&unmap[segs_to_unmap],
> +			vaddr(persistent_gnt->page),
> +			GNTMAP_host_map,
> +			persistent_gnt->handle);
> +
> +		unmap_pages[segs_to_unmap] = persistent_gnt->page;
> +
> +		if (++segs_to_unmap == BLKIF_MAX_SEGMENTS_PER_REQUEST) {
> +			rc = gnttab_unmap_refs(unmap, NULL, unmap_pages,
> +				segs_to_unmap);
> +			BUG_ON(rc);
> +			put_free_pages(blkif, unmap_pages, segs_to_unmap);
> +			segs_to_unmap = 0;
> +		}
> +		kfree(persistent_gnt);
> +	}
> +
> +	if (grefs)
> +		kunmap_atomic(grefs);
> +	if (segs_to_unmap > 0) {
> +		rc = gnttab_unmap_refs(unmap, NULL, unmap_pages, segs_to_unmap);
> +		BUG_ON(rc);
> +		put_free_pages(blkif, unmap_pages, segs_to_unmap);
> +	}
> +	rc = 0;
> +
> +unmap:
> +	xen_blkbk_unmap(blkif, pages, n_pages);
> +response:
> +	make_response(blkif, req->u.indirect.id, req->u.indirect.indirect_op,
> +	              rc ? BLKIF_RSP_ERROR : BLKIF_RSP_OKAY);
> +	free_req(blkif, pending_req);
> +
> +	return rc;
> +}
>  
>  /*
>   * Put a response on the ring on how the operation fared.
> diff --git a/drivers/block/xen-blkback/common.h b/drivers/block/xen-blkback/common.h
> index 8d88075..707a2f1 100644
> --- a/drivers/block/xen-blkback/common.h
> +++ b/drivers/block/xen-blkback/common.h
> @@ -58,10 +58,12 @@
>  
>  #define SEGS_PER_INDIRECT_FRAME \
>  	(PAGE_SIZE/sizeof(struct blkif_request_segment_aligned))
> +#define GREFS_PER_INDIRECT_FRAME \
> +	(PAGE_SIZE/sizeof(grant_ref_t))
>  #define MAX_INDIRECT_PAGES \
>  	((MAX_INDIRECT_SEGMENTS + SEGS_PER_INDIRECT_FRAME - 1)/SEGS_PER_INDIRECT_FRAME)
> -#define INDIRECT_PAGES(_segs) \
> -	((_segs + SEGS_PER_INDIRECT_FRAME - 1)/SEGS_PER_INDIRECT_FRAME)
> +#define INDIRECT_PAGES(_segs, _items_per_page) \
> +	((_segs + _items_per_page - 1)/_items_per_page)
>  
>  /* Not a real protocol.  Used to generate ring structs which contain
>   * the elements common to all protocols only.  This way we get a
> @@ -417,7 +419,8 @@ static inline void blkif_get_x86_32_req(struct blkif_request *dst,
>  		dst->u.indirect.id = src->u.indirect.id;
>  		dst->u.indirect.sector_number = src->u.indirect.sector_number;
>  		barrier();
> -		j = min(MAX_INDIRECT_PAGES, INDIRECT_PAGES(dst->u.indirect.nr_segments));
> +		j = min(MAX_INDIRECT_PAGES,
> +		        INDIRECT_PAGES(dst->u.indirect.nr_segments, SEGS_PER_INDIRECT_FRAME));
>  		for (i = 0; i < j; i++)
>  			dst->u.indirect.indirect_grefs[i] =
>  				src->u.indirect.indirect_grefs[i];
> @@ -465,7 +468,8 @@ static inline void blkif_get_x86_64_req(struct blkif_request *dst,
>  		dst->u.indirect.id = src->u.indirect.id;
>  		dst->u.indirect.sector_number = src->u.indirect.sector_number;
>  		barrier();
> -		j = min(MAX_INDIRECT_PAGES, INDIRECT_PAGES(dst->u.indirect.nr_segments));
> +		j = min(MAX_INDIRECT_PAGES,
> +		        INDIRECT_PAGES(dst->u.indirect.nr_segments, SEGS_PER_INDIRECT_FRAME));
>  		for (i = 0; i < j; i++)
>  			dst->u.indirect.indirect_grefs[i] =
>  				src->u.indirect.indirect_grefs[i];
> diff --git a/drivers/block/xen-blkback/xenbus.c b/drivers/block/xen-blkback/xenbus.c
> index 2e5b69d..03829c6 100644
> --- a/drivers/block/xen-blkback/xenbus.c
> +++ b/drivers/block/xen-blkback/xenbus.c
> @@ -759,6 +759,16 @@ again:
>  		dev_warn(&dev->dev, "writing %s/feature-max-indirect-segments (%d)",
>  			 dev->nodename, err);
>  
> +	/*
> +	 * Since we are going to use the same array to store indirect frames
> +	 * we need to calculate how many grefs we can handle based on that
> +	 */
> +	err = xenbus_printf(xbt, dev->nodename, "feature-max-unmap-grefs", "%lu",
> +			    MAX_INDIRECT_PAGES * GREFS_PER_INDIRECT_FRAME);
> +	if (err)
> +		dev_warn(&dev->dev, "writing %s/feature-max-unmap-grefs (%d)",
> +			 dev->nodename, err);
> +
>  	err = xenbus_printf(xbt, dev->nodename, "sectors", "%llu",
>  			    (unsigned long long)vbd_sz(&be->blkif->vbd));
>  	if (err) {
> diff --git a/drivers/block/xen-blkfront.c b/drivers/block/xen-blkfront.c
> index 3d445c0..c4209f1 100644
> --- a/drivers/block/xen-blkfront.c
> +++ b/drivers/block/xen-blkfront.c
> @@ -45,6 +45,9 @@
>  #include <linux/scatterlist.h>
>  #include <linux/bitmap.h>
>  #include <linux/list.h>
> +#include <linux/kthread.h>
> +#include <linux/freezer.h>
> +#include <linux/delay.h>
>  
>  #include <xen/xen.h>
>  #include <xen/xenbus.h>
> @@ -77,6 +80,7 @@ struct blk_shadow {
>  	struct grant **grants_used;
>  	struct grant **indirect_grants;
>  	struct scatterlist *sg;
> +	bool in_use;
>  };
>  
>  struct split_bio {
> @@ -106,6 +110,9 @@ MODULE_PARM_DESC(max, "Maximum amount of segments in indirect requests (default
>   */
>  #define MIN_FREE_GRANTS		512
>  
> +/* Time between requests to unmap persistent grants (in ms) */
> +#define LRU_PURGE_INTERVAL	1000
> +
>  /*
>   * We have one of these per vbd, whether ide, scsi or 'other'.  They
>   * hang in private_data off the gendisk structure. We may end up
> @@ -128,6 +135,7 @@ struct blkfront_info
>  	struct gnttab_free_callback callback;
>  	struct blk_shadow shadow[BLK_RING_SIZE];
>  	struct list_head persistent_gnts;
> +	struct list_head purge_gnts;
>  	unsigned int persistent_gnts_c;
>  	unsigned long shadow_free;
>  	unsigned int feature_flush;
> @@ -138,7 +146,9 @@ struct blkfront_info
>  	unsigned int discard_alignment;
>  	unsigned int feature_persistent:1;
>  	unsigned int max_indirect_segments;
> +	unsigned int max_unmap_grefs;
>  	int is_ready;
> +	struct task_struct *purge_thread;
>  };
>  
>  static unsigned int nr_minors;
> @@ -168,17 +178,31 @@ static DEFINE_SPINLOCK(minor_lock);
>  
>  #define SEGS_PER_INDIRECT_FRAME \
>  	(PAGE_SIZE/sizeof(struct blkif_request_segment_aligned))
> -#define INDIRECT_GREFS(_segs) \
> -	((_segs + SEGS_PER_INDIRECT_FRAME - 1)/SEGS_PER_INDIRECT_FRAME)
> +#define GREFS_PER_INDIRECT_FRAME \
> +	(PAGE_SIZE/sizeof(grant_ref_t))
> +#define INDIRECT_GREFS(_segs, _items_per_page) \
> +	((_segs + _items_per_page - 1)/_items_per_page)
>  
>  static int blkfront_setup_indirect(struct blkfront_info *info);
>  
> +static inline void flush_requests(struct blkfront_info *info)
> +{
> +	int notify;
> +
> +	RING_PUSH_REQUESTS_AND_CHECK_NOTIFY(&info->ring, notify);
> +
> +	if (notify)
> +		notify_remote_via_irq(info->irq);
> +}
> +
>  static int get_id_from_freelist(struct blkfront_info *info)
>  {
>  	unsigned long free = info->shadow_free;
>  	BUG_ON(free >= BLK_RING_SIZE);
> +	BUG_ON(info->shadow[free].in_use);
>  	info->shadow_free = info->shadow[free].req.u.rw.id;
>  	info->shadow[free].req.u.rw.id = 0x0fffffee; /* debug */
> +	info->shadow[free].in_use = true;
>  	return free;
>  }
>  
> @@ -187,8 +211,9 @@ static int add_id_to_freelist(struct blkfront_info *info,
>  {
>  	if (info->shadow[id].req.u.rw.id != id)
>  		return -EINVAL;
> -	if (info->shadow[id].request == NULL)
> +	if (!info->shadow[id].in_use)
>  		return -EINVAL;
> +	info->shadow[id].in_use = false;
>  	info->shadow[id].req.u.rw.id  = info->shadow_free;
>  	info->shadow[id].request = NULL;
>  	info->shadow_free = id;
> @@ -258,6 +283,88 @@ static struct grant *get_grant(grant_ref_t *gref_head,
>  	return gnt_list_entry;
>  }
>  
> +static int blkif_purge_grants(void *arg)
> +{
> +	struct blkfront_info *info = arg;
> +	grant_ref_t *grefs = NULL;
> +	struct grant *gnt, *n;
> +	struct blkif_request *ring_req;
> +	unsigned long id;
> +	int num, i, n_pages;
> +
> +	n_pages = INDIRECT_GREFS(info->max_unmap_grefs, GREFS_PER_INDIRECT_FRAME);
> +
> +	while (!kthread_should_stop()) {
> +		if (try_to_freeze())
> +			continue;
> +
> +		if (msleep_interruptible(LRU_PURGE_INTERVAL))
> +			continue;
> +
> +		spin_lock_irq(&info->io_lock);
> +		if (unlikely(info->connected != BLKIF_STATE_CONNECTED) ||
> +		    RING_FULL(&info->ring) ||
> +		    (info->max_unmap_grefs + n_pages) > info->persistent_gnts_c ||
> +		    !list_empty(&info->purge_gnts)) {
> +			spin_unlock_irq(&info->io_lock);
> +			continue;
> +		}
> +
> +		/* Set up the ring request */
> +		ring_req = RING_GET_REQUEST(&info->ring, info->ring.req_prod_pvt);
> +		id = get_id_from_freelist(info);
> +		ring_req->operation = BLKIF_OP_INDIRECT;
> +		ring_req->u.indirect.indirect_op = BLKIF_OP_UNMAP;
> +		ring_req->u.indirect.handle = info->handle;
> +		ring_req->u.indirect.id = id;
> +
> +		for (i = 0; i < n_pages; i++)
> +			info->shadow[id].indirect_grants[i] = NULL;
> +
> +		num = 0;
> +		BUG_ON(grefs != NULL);
> +		list_for_each_entry_safe_reverse(gnt, n, &info->persistent_gnts, node) {
> +			if (gnt->gref == GRANT_INVALID_REF)
> +				continue;
> +
> +			i = num / GREFS_PER_INDIRECT_FRAME;
> +			if (((num % GREFS_PER_INDIRECT_FRAME) == 0) &&
> +			    (info->shadow[id].indirect_grants[i] == NULL)) {
> +				if (grefs)
> +					kunmap_atomic(grefs);
> +				list_del(&gnt->node);
> +				info->persistent_gnts_c--;
> +				info->shadow[id].indirect_grants[i] = gnt;
> +				grefs = kmap_atomic(pfn_to_page(gnt->pfn));
> +				ring_req->u.indirect.indirect_grefs[i] = gnt->gref;
> +				continue;
> +			}
> +
> +			list_del(&gnt->node);
> +			list_add(&gnt->node, &info->purge_gnts);
> +			info->persistent_gnts_c--;
> +
> +			i = num % GREFS_PER_INDIRECT_FRAME;
> +			grefs[i] = gnt->gref;
> +
> +			if (++num == info->max_unmap_grefs)
> +				break;
> +		}
> +		if (grefs) {
> +			kunmap_atomic(grefs);
> +			grefs = NULL;
> +		}
> +
> +		ring_req->u.indirect.nr_segments = num;
> +		info->ring.req_prod_pvt++;
> +		info->shadow[id].req = *ring_req;
> +		flush_requests(info);
> +
> +		spin_unlock_irq(&info->io_lock);
> +	}
> +	return 0;
> +}
> +
>  static const char *op_name(int op)
>  {
>  	static const char *const names[] = {
> @@ -265,7 +372,9 @@ static const char *op_name(int op)
>  		[BLKIF_OP_WRITE] = "write",
>  		[BLKIF_OP_WRITE_BARRIER] = "barrier",
>  		[BLKIF_OP_FLUSH_DISKCACHE] = "flush",
> -		[BLKIF_OP_DISCARD] = "discard" };
> +		[BLKIF_OP_DISCARD] = "discard",
> +		[BLKIF_OP_INDIRECT] = "indirect",
> +		[BLKIF_OP_UNMAP] = "unmap", };
>  
>  	if (op < 0 || op >= ARRAY_SIZE(names))
>  		return "unknown";
> @@ -412,7 +521,7 @@ static int blkif_queue_request(struct request *req)
>  		 * If we are using indirect segments we need to account
>  		 * for the indirect grefs used in the request.
>  		 */
> -		max_grefs += INDIRECT_GREFS(req->nr_phys_segments);
> +		max_grefs += INDIRECT_GREFS(req->nr_phys_segments, SEGS_PER_INDIRECT_FRAME);
>  
>  	/* Check if we have enough grants to allocate a requests */
>  	if (info->persistent_gnts_c < max_grefs) {
> @@ -556,17 +665,6 @@ static int blkif_queue_request(struct request *req)
>  	return 0;
>  }
>  
> -
> -static inline void flush_requests(struct blkfront_info *info)
> -{
> -	int notify;
> -
> -	RING_PUSH_REQUESTS_AND_CHECK_NOTIFY(&info->ring, notify);
> -
> -	if (notify)
> -		notify_remote_via_irq(info->irq);
> -}
> -
>  /*
>   * do_blkif_request
>   *  read a block; request is in a request queue
> @@ -904,6 +1002,12 @@ static void blkif_free(struct blkfront_info *info, int suspend)
>  	struct grant *n;
>  	int i, j, segs;
>  
> +	/* Remove purge_thread */
> +	if (info->purge_thread) {
> +		kthread_stop(info->purge_thread);
> +		info->purge_thread = NULL;
> +	}
> +
>  	/* Prevent new requests being issued until we fix things up. */
>  	spin_lock_irq(&info->io_lock);
>  	info->connected = suspend ?
> @@ -928,17 +1032,38 @@ static void blkif_free(struct blkfront_info *info, int suspend)
>  	}
>  	BUG_ON(info->persistent_gnts_c != 0);
>  
> +	/* Remove grants waiting for purge */
> +	if (!list_empty(&info->purge_gnts)) {
> +		list_for_each_entry_safe(persistent_gnt, n,
> +		                         &info->purge_gnts, node) {
> +			list_del(&persistent_gnt->node);
> +			BUG_ON(persistent_gnt->gref == GRANT_INVALID_REF);
> +			gnttab_end_foreign_access(persistent_gnt->gref, 0, 0UL);
> +			__free_page(pfn_to_page(persistent_gnt->pfn));
> +			kfree(persistent_gnt);
> +		}
> +	}
> +
>  	for (i = 0; i < BLK_RING_SIZE; i++) {
> +		int n_pages;
>  		/*
>  		 * Clear persistent grants present in requests already
>  		 * on the shared ring
>  		 */
> -		if (!info->shadow[i].request)
> +		if (!info->shadow[i].in_use)
>  			goto free_shadow;
>  
>  		segs = info->shadow[i].req.operation == BLKIF_OP_INDIRECT ?
>  		       info->shadow[i].req.u.indirect.nr_segments :
>  		       info->shadow[i].req.u.rw.nr_segments;
> +
> +		if (info->shadow[i].req.operation == BLKIF_OP_INDIRECT &&
> +		    info->shadow[i].req.u.indirect.indirect_op == BLKIF_OP_UNMAP) {
> +			n_pages = INDIRECT_GREFS(segs, GREFS_PER_INDIRECT_FRAME);
> +			segs = 0;
> +		} else
> +			n_pages = INDIRECT_GREFS(segs, SEGS_PER_INDIRECT_FRAME);
> +
>  		for (j = 0; j < segs; j++) {
>  			persistent_gnt = info->shadow[i].grants_used[j];
>  			gnttab_end_foreign_access(persistent_gnt->gref, 0, 0UL);
> @@ -953,7 +1078,7 @@ static void blkif_free(struct blkfront_info *info, int suspend)
>  			 */
>  			goto free_shadow;
>  
> -		for (j = 0; j < INDIRECT_GREFS(segs); j++) {
> +		for (j = 0; j < n_pages; j++) {
>  			persistent_gnt = info->shadow[i].indirect_grants[j];
>  			gnttab_end_foreign_access(persistent_gnt->gref, 0, 0UL);
>  			__free_page(pfn_to_page(persistent_gnt->pfn));
> @@ -996,10 +1121,16 @@ static void blkif_completion(struct blk_shadow *s, struct blkfront_info *info,
>  	struct scatterlist *sg;
>  	char *bvec_data;
>  	void *shared_data;
> -	int nseg;
> +	int nseg, npages;
>  
>  	nseg = s->req.operation == BLKIF_OP_INDIRECT ?
>  		s->req.u.indirect.nr_segments : s->req.u.rw.nr_segments;
> +	if (bret->operation == BLKIF_OP_UNMAP) {
> +		npages = INDIRECT_GREFS(nseg, GREFS_PER_INDIRECT_FRAME);
> +		nseg = 0;
> +	} else {
> +		npages = INDIRECT_GREFS(nseg, SEGS_PER_INDIRECT_FRAME);
> +	}
>  
>  	if (bret->operation == BLKIF_OP_READ) {
>  		/*
> @@ -1026,7 +1157,7 @@ static void blkif_completion(struct blk_shadow *s, struct blkfront_info *info,
>  		info->persistent_gnts_c++;
>  	}
>  	if (s->req.operation == BLKIF_OP_INDIRECT) {
> -		for (i = 0; i < INDIRECT_GREFS(nseg); i++) {
> +		for (i = 0; i < npages; i++) {
>  			list_add(&s->indirect_grants[i]->node, &info->persistent_gnts);
>  			info->persistent_gnts_c++;
>  		}
> @@ -1041,6 +1172,7 @@ static irqreturn_t blkif_interrupt(int irq, void *dev_id)
>  	unsigned long flags;
>  	struct blkfront_info *info = (struct blkfront_info *)dev_id;
>  	int error;
> +	struct grant *gnt, *n;
>  
>  	spin_lock_irqsave(&info->io_lock, flags);
>  
> @@ -1125,6 +1257,22 @@ static irqreturn_t blkif_interrupt(int irq, void *dev_id)
>  
>  			__blk_end_request_all(req, error);
>  			break;
> +		case BLKIF_OP_UNMAP:
> +			/* Remove access to the grants and add them back to the list */
> +			if (unlikely(bret->status != BLKIF_RSP_OKAY))
> +				pr_warn_ratelimited("blkfront: unmap operation returned !BLKIF_RSP_OKAY");
> +			list_for_each_entry_safe(gnt, n, &info->purge_gnts, node) {
> +				list_del(&gnt->node);
> +				if (bret->status == BLKIF_RSP_OKAY) {
> +					gnttab_end_foreign_access(gnt->gref, 0, 0UL);
> +					gnt->gref = GRANT_INVALID_REF;
> +					list_add_tail(&gnt->node, &info->persistent_gnts);
> +				} else {
> +					list_add(&gnt->node, &info->persistent_gnts);
> +					info->persistent_gnts_c++;
> +				}
> +			}
> +			break;
>  		default:
>  			BUG();
>  		}
> @@ -1323,6 +1471,7 @@ static int blkfront_probe(struct xenbus_device *dev,
>  	info->xbdev = dev;
>  	info->vdevice = vdevice;
>  	INIT_LIST_HEAD(&info->persistent_gnts);
> +	INIT_LIST_HEAD(&info->purge_gnts);
>  	info->persistent_gnts_c = 0;
>  	info->connected = BLKIF_STATE_DISCONNECTED;
>  	INIT_WORK(&info->work, blkif_restart_queue);
> @@ -1650,7 +1799,7 @@ static void blkfront_setup_discard(struct blkfront_info *info)
>  
>  static int blkfront_setup_indirect(struct blkfront_info *info)
>  {
> -	unsigned int indirect_segments, segs;
> +	unsigned int indirect_segments, segs, indirect_unmap;
>  	int err, i;
>  
>  	err = xenbus_gather(XBT_NIL, info->xbdev->otherend,
> @@ -1665,7 +1814,24 @@ static int blkfront_setup_indirect(struct blkfront_info *info)
>  		segs = info->max_indirect_segments;
>  	}
>  
> -	err = fill_grant_buffer(info, (segs + INDIRECT_GREFS(segs)) * BLK_RING_SIZE);
> +	/* Check if backend supports unmapping persistent grants */
> +	err = xenbus_gather(XBT_NIL, info->xbdev->otherend,
> +			    "feature-max-unmap-grefs", "%u", &indirect_unmap,
> +			    NULL);
> +	if (err)
> +		info->max_unmap_grefs = 0;
> +	else
> +		/*
> +		 * Since we don't allocate grants dynamically we need to make
> +		 * sure that the unmap operation doesn't use more grants than
> +		 * a normal indirect operation, or we might exhaust the buffer
> +		 * of pre-allocated grants
> +		 */
> +		info->max_unmap_grefs = min(segs, indirect_unmap);
> +
> +
> +	err = fill_grant_buffer(info, (segs + INDIRECT_GREFS(segs, SEGS_PER_INDIRECT_FRAME)) *
> +	                              BLK_RING_SIZE);
>  	if (err)
>  		goto out_of_memory;
>  
> @@ -1677,7 +1843,7 @@ static int blkfront_setup_indirect(struct blkfront_info *info)
>  		if (info->max_indirect_segments)
>  			info->shadow[i].indirect_grants = kzalloc(
>  				sizeof(info->shadow[i].indirect_grants[0]) *
> -				INDIRECT_GREFS(segs),
> +				INDIRECT_GREFS(segs, SEGS_PER_INDIRECT_FRAME),
>  				GFP_NOIO);
>  		if ((info->shadow[i].grants_used == NULL) ||
>  			(info->shadow[i].sg == NULL) ||
> @@ -1687,6 +1853,17 @@ static int blkfront_setup_indirect(struct blkfront_info *info)
>  		sg_init_table(info->shadow[i].sg, segs);
>  	}
>  
> +	if (info->max_unmap_grefs) {
> +		BUG_ON(info->purge_thread != NULL);
> +		info->purge_thread = kthread_run(blkif_purge_grants, info, "%s/purge",
> +		                                 info->xbdev->nodename);
> +		if (IS_ERR(info->purge_thread)) {
> +			err = PTR_ERR(info->purge_thread);
> +			info->purge_thread = NULL;
> +			pr_alert("unable to start purge thread");
> +			return err;
> +		}
> +	}
>  
>  	return 0;
>  
> diff --git a/include/xen/interface/io/blkif.h b/include/xen/interface/io/blkif.h
> index 65e1209..20fcbfd 100644
> --- a/include/xen/interface/io/blkif.h
> +++ b/include/xen/interface/io/blkif.h
> @@ -127,6 +127,19 @@ typedef uint64_t blkif_sector_t;
>  #define BLKIF_OP_INDIRECT          6
>  
>  /*
> + * Recognized if "feature-max-unmap-grefs" is present in the backend xenbus
> + * info. The "feature-max-unmap-grefs" node contains the maximum number of grefs
> + * allowed by the backend per request.
> + *
> + * This operation can only be used as an indirect operation. blkfront might use
> + * this operation to request blkback to unmap certain grants, so they can be
> + * freed by blkfront. The grants to unmap are placed inside the indirect pages
> + * as an array of grant_ref_t, and nr_segments contains the number of grefs
> + * to unmap.
> + */
> +#define BLKIF_OP_UNMAP             7
> +
> +/*
>   * Maximum scatter/gather segments per request.
>   * This is carefully chosen so that sizeof(struct blkif_ring) <= PAGE_SIZE.
>   * NB. This could be 12 if the ring indexes weren't stored in the same page.
> -- 
> 1.7.7.5 (Apple Git-26)
> 
