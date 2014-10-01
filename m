Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752201AbaJAUVZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Oct 2014 16:21:25 -0400
Received: from aserp1040.oracle.com ([141.146.126.69]:21582 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751165AbaJAUVV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Oct 2014 16:21:21 -0400
Date: Wed, 1 Oct 2014 16:18:44 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: Arianna Avanzini <avanzini.arianna@gmail.com>
Cc: boris.ostrovsky@oracle.com, david.vrabel@citrix.com,
        xen-devel@lists.xenproject.org, linux-kernel@vger.kernel.org,
        hch@infradead.org, bob.liu@oracle.com, felipe.franciosi@citrix.com,
        axboe@fb.com
Subject: Re: [PATCH RFC v2 4/5] xen, blkback: introduce support for multiple
 block rings
Message-ID: <20141001201844.GA12581@laptop.dumpdata.com>
References: <1410479844-2864-1-git-send-email-avanzini.arianna@gmail.com>
 <1410479844-2864-5-git-send-email-avanzini.arianna@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1410479844-2864-5-git-send-email-avanzini.arianna@gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
X-Source-IP: ucsinet22.oracle.com [156.151.31.94]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 12, 2014 at 01:57:23AM +0200, Arianna Avanzini wrote:
> This commit adds to xen-blkback the support to map and make use
> of a variable number of ringbuffers. The number of rings to be
> mapped is forcedly set to one.

Please add:
 - An explanation the 'xen_blkif_ring' and 'xen_blkif' split as well.
 - The addition of the 'stats_lock' (which really should be a seperate
   patch). Please remember: One logical change per patch./

> 
> Signed-off-by: Arianna Avanzini <avanzini.arianna@gmail.com>
> ---
>  drivers/block/xen-blkback/blkback.c | 377 ++++++++++++++++---------------
>  drivers/block/xen-blkback/common.h  | 110 +++++----
>  drivers/block/xen-blkback/xenbus.c  | 432 +++++++++++++++++++++++-------------
>  3 files changed, 548 insertions(+), 371 deletions(-)
> 
> diff --git a/drivers/block/xen-blkback/blkback.c b/drivers/block/xen-blkback/blkback.c
> index 64c60ed..b31acfb 100644
> --- a/drivers/block/xen-blkback/blkback.c
> +++ b/drivers/block/xen-blkback/blkback.c
> @@ -80,6 +80,9 @@ module_param_named(max_persistent_grants, xen_blkif_max_pgrants, int, 0644);
>  MODULE_PARM_DESC(max_persistent_grants,
>                   "Maximum number of grants to map persistently");
>

A bit fat comment here please :-)
  
> +#define XEN_RING_MAX_PGRANTS(nr_rings) \
> +	(max((int)(xen_blkif_max_pgrants / nr_rings), 16))
> +

.. Giant snip ..
>  static int __init xen_blkif_init(void)
> diff --git a/drivers/block/xen-blkback/common.h b/drivers/block/xen-blkback/common.h
> index f65b807..6f074ce 100644
> --- a/drivers/block/xen-blkback/common.h
> +++ b/drivers/block/xen-blkback/common.h
> @@ -226,6 +226,7 @@ struct xen_vbd {
>  	struct block_device	*bdev;
>  	/* Cached size parameter. */
>  	sector_t		size;
> +	unsigned int		nr_supported_hw_queues;

nr_rings

would do
>  	unsigned int		flush_support:1;
>  	unsigned int		discard_secure:1;
>  	unsigned int		feature_gnt_persistent:1;
> @@ -246,6 +247,7 @@ struct backend_info;
>  
>  /* Number of requests that we can fit in a ring */
>  #define XEN_BLKIF_REQS			32
> +#define XEN_RING_REQS(nr_rings)	(max((int)(XEN_BLKIF_REQS / nr_rings), 8))

Bit giant comment here please.
>  
>  struct persistent_gnt {
>  	struct page *page;
> @@ -256,32 +258,29 @@ struct persistent_gnt {
>  	struct list_head remove_node;
>  };
>  
> -struct xen_blkif {
> -	/* Unique identifier for this interface. */
> -	domid_t			domid;
> -	unsigned int		handle;
> +struct xen_blkif_ring {
> +	union blkif_back_rings	blk_rings;
>  	/* Physical parameters of the comms window. */
>  	unsigned int		irq;
> -	/* Comms information. */
> -	enum blkif_protocol	blk_protocol;
> -	union blkif_back_rings	blk_rings;
> -	void			*blk_ring;
> -	/* The VBD attached to this interface. */
> -	struct xen_vbd		vbd;
> -	/* Back pointer to the backend_info. */
> -	struct backend_info	*be;
> -	/* Private fields. */
> -	spinlock_t		blk_ring_lock;
> -	atomic_t		refcnt;
>  
>  	wait_queue_head_t	wq;
> -	/* for barrier (drain) requests */
> -	struct completion	drain_complete;
> -	atomic_t		drain;
> -	atomic_t		inflight;
>  	/* One thread per one blkif. */
>  	struct task_struct	*xenblkd;
>  	unsigned int		waiting_reqs;
> +	void			*blk_ring;
> +	spinlock_t		blk_ring_lock;
> +
> +	struct work_struct	free_work;
> +	/* Thread shutdown wait queue. */
> +	wait_queue_head_t	shutdown_wq;
> +
> +	/* buffer of free pages to map grant refs */
> +	spinlock_t		free_pages_lock;
> +	int			free_pages_num;
> +
> +	/* used by the kworker that offload work from the persistent purge */
> +	struct list_head	persistent_purge_list;
> +	struct work_struct	persistent_purge_work;
>  
>  	/* tree to store persistent grants */
>  	struct rb_root		persistent_gnts;
> @@ -289,13 +288,6 @@ struct xen_blkif {
>  	atomic_t		persistent_gnt_in_use;
>  	unsigned long           next_lru;
>  
> -	/* used by the kworker that offload work from the persistent purge */
> -	struct list_head	persistent_purge_list;
> -	struct work_struct	persistent_purge_work;
> -
> -	/* buffer of free pages to map grant refs */
> -	spinlock_t		free_pages_lock;
> -	int			free_pages_num;
>  	struct list_head	free_pages;
>  
>  	/* List of all 'pending_req' available */
> @@ -303,20 +295,54 @@ struct xen_blkif {
>  	/* And its spinlock. */
>  	spinlock_t		pending_free_lock;
>  	wait_queue_head_t	pending_free_wq;
> +	atomic_t		inflight;
> +
> +	/* Private fields. */
> +	atomic_t		refcnt;
> +
> +	struct xen_blkif	*blkif;
> +	unsigned		ring_index;


>  
> +	spinlock_t		stats_lock;
>  	/* statistics */
>  	unsigned long		st_print;
> -	unsigned long long			st_rd_req;
> -	unsigned long long			st_wr_req;
> -	unsigned long long			st_oo_req;
> -	unsigned long long			st_f_req;
> -	unsigned long long			st_ds_req;
> -	unsigned long long			st_rd_sect;
> -	unsigned long long			st_wr_sect;
> +	unsigned long long	st_rd_req;
> +	unsigned long long	st_wr_req;
> +	unsigned long long	st_oo_req;
> +	unsigned long long	st_f_req;
> +	unsigned long long	st_ds_req;
> +	unsigned long long	st_rd_sect;
> +	unsigned long long	st_wr_sect;
> +};
>  
> -	struct work_struct	free_work;
> -	/* Thread shutdown wait queue. */
> -	wait_queue_head_t	shutdown_wq;
> +struct xen_blkif {
> +	/* Unique identifier for this interface. */
> +	domid_t			domid;
> +	unsigned int		handle;
> +	/* Comms information. */
> +	enum blkif_protocol	blk_protocol;
> +	/* The VBD attached to this interface. */
> +	struct xen_vbd		vbd;
> +	/* Rings for this device */
> +	struct xen_blkif_ring	*rings;
> +	unsigned int		nr_rings;
> +	/* Back pointer to the backend_info. */
> +	struct backend_info	*be;
> +
> +	/* for barrier (drain) requests */
> +	struct completion	drain_complete;
> +	atomic_t		drain;
> +
> +	atomic_t		refcnt;
> +
> +	/* statistics */
> +	unsigned long long	st_rd_req;
> +	unsigned long long	st_wr_req;
> +	unsigned long long	st_oo_req;
> +	unsigned long long	st_f_req;
> +	unsigned long long	st_ds_req;
> +	unsigned long long	st_rd_sect;
> +	unsigned long long	st_wr_sect;


Can those go now that they are in xen_blkif_ring?
[edit: I see that in VBD_SHOW why you use them]

Perhaps change 'statistics' to 'full device statistics - including all of the rings values'

Or you could have each ring just increment the 'blkif' counters
instead of doing it per ring?

But there is something usefull about having those values per ring too.
Lets leave it as is then.

>  };
>  
>  struct seg_buf {
> @@ -338,7 +364,7 @@ struct grant_page {
>   * response queued for it, with the saved 'id' passed back.
>   */
>  struct pending_req {
> -	struct xen_blkif	*blkif;
> +	struct xen_blkif_ring	*ring;
>  	u64			id;
>  	int			nr_pages;
>  	atomic_t		pendcnt;
> @@ -357,11 +383,11 @@ struct pending_req {
>  			 (_v)->bdev->bd_part->nr_sects : \
>  			  get_capacity((_v)->bdev->bd_disk))
>  
> -#define xen_blkif_get(_b) (atomic_inc(&(_b)->refcnt))
> -#define xen_blkif_put(_b)				\
> +#define xen_ring_get(_r) (atomic_inc(&(_r)->refcnt))
> +#define xen_ring_put(_r)				\
>  	do {						\
> -		if (atomic_dec_and_test(&(_b)->refcnt))	\
> -			schedule_work(&(_b)->free_work);\
> +		if (atomic_dec_and_test(&(_r)->refcnt))	\
> +			schedule_work(&(_r)->free_work);\
>  	} while (0)
>  
>  struct phys_req {
> @@ -377,7 +403,7 @@ int xen_blkif_xenbus_init(void);
>  irqreturn_t xen_blkif_be_int(int irq, void *dev_id);
>  int xen_blkif_schedule(void *arg);
>  int xen_blkif_purge_persistent(void *arg);
> -void xen_blkbk_free_caches(struct xen_blkif *blkif);
> +void xen_blkbk_free_caches(struct xen_blkif_ring *ring);
>  
>  int xen_blkbk_flush_diskcache(struct xenbus_transaction xbt,
>  			      struct backend_info *be, int state);
> diff --git a/drivers/block/xen-blkback/xenbus.c b/drivers/block/xen-blkback/xenbus.c
> index 3a8b810..a4f13cc 100644
> --- a/drivers/block/xen-blkback/xenbus.c
> +++ b/drivers/block/xen-blkback/xenbus.c
> @@ -35,7 +35,7 @@ static void connect(struct backend_info *);
>  static int connect_ring(struct backend_info *);
>  static void backend_changed(struct xenbus_watch *, const char **,
>  			    unsigned int);
> -static void xen_blkif_free(struct xen_blkif *blkif);
> +static void xen_ring_free(struct xen_blkif_ring *ring);
>  static void xen_vbd_free(struct xen_vbd *vbd);
>  
>  struct xenbus_device *xen_blkbk_xenbus(struct backend_info *be)
> @@ -45,17 +45,17 @@ struct xenbus_device *xen_blkbk_xenbus(struct backend_info *be)
>  
>  /*
>   * The last request could free the device from softirq context and
> - * xen_blkif_free() can sleep.
> + * xen_ring_free() can sleep.
>   */
> -static void xen_blkif_deferred_free(struct work_struct *work)
> +static void xen_ring_deferred_free(struct work_struct *work)
>  {
> -	struct xen_blkif *blkif;
> +	struct xen_blkif_ring *ring;
>  
> -	blkif = container_of(work, struct xen_blkif, free_work);
> -	xen_blkif_free(blkif);
> +	ring = container_of(work, struct xen_blkif_ring, free_work);
> +	xen_ring_free(ring);
>  }
>  
> -static int blkback_name(struct xen_blkif *blkif, char *buf)
> +static int blkback_name(struct xen_blkif *blkif, char *buf, bool save_space)
>  {
>  	char *devpath, *devname;
>  	struct xenbus_device *dev = blkif->be->dev;
> @@ -70,7 +70,10 @@ static int blkback_name(struct xen_blkif *blkif, char *buf)
>  	else
>  		devname  = devpath;
>  
> -	snprintf(buf, TASK_COMM_LEN, "blkback.%d.%s", blkif->domid, devname);
> +	if (save_space)
> +		snprintf(buf, TASK_COMM_LEN, "blkbk.%d.%s", blkif->domid, devname);
> +	else
> +		snprintf(buf, TASK_COMM_LEN, "blkback.%d.%s", blkif->domid, devname);
>  	kfree(devpath);
>  
>  	return 0;
> @@ -78,11 +81,15 @@ static int blkback_name(struct xen_blkif *blkif, char *buf)
>  
>  static void xen_update_blkif_status(struct xen_blkif *blkif)
>  {
> -	int err;
> -	char name[TASK_COMM_LEN];
> +	int i, err;
> +	char name[TASK_COMM_LEN], per_ring_name[TASK_COMM_LEN];
> +	struct xen_blkif_ring *ring;
>  
> -	/* Not ready to connect? */
> -	if (!blkif->irq || !blkif->vbd.bdev)
> +	/*
> +	 * Not ready to connect? Check irq of first ring as the others
> +	 * should all be the same.
> +	 */
> +	if (!blkif->rings || !blkif->rings[0].irq || !blkif->vbd.bdev)
>  		return;
>  
>  	/* Already connected? */
> @@ -94,7 +101,7 @@ static void xen_update_blkif_status(struct xen_blkif *blkif)
>  	if (blkif->be->dev->state != XenbusStateConnected)
>  		return;
>  
> -	err = blkback_name(blkif, name);
> +	err = blkback_name(blkif, name, blkif->vbd.nr_supported_hw_queues);
>  	if (err) {
>  		xenbus_dev_error(blkif->be->dev, err, "get blkback dev name");
>  		return;
> @@ -107,20 +114,96 @@ static void xen_update_blkif_status(struct xen_blkif *blkif)
>  	}
>  	invalidate_inode_pages2(blkif->vbd.bdev->bd_inode->i_mapping);
>  
> -	blkif->xenblkd = kthread_run(xen_blkif_schedule, blkif, "%s", name);
> -	if (IS_ERR(blkif->xenblkd)) {
> -		err = PTR_ERR(blkif->xenblkd);
> -		blkif->xenblkd = NULL;
> -		xenbus_dev_error(blkif->be->dev, err, "start xenblkd");
> -		return;
> +	for (i = 0 ; i < blkif->nr_rings ; i++) {
> +		ring = &blkif->rings[i];
> +		if (blkif->vbd.nr_supported_hw_queues)
> +			snprintf(per_ring_name, TASK_COMM_LEN, "%s-%d", name, i);
> +		else {
> +			BUG_ON(i != 0);
> +			snprintf(per_ring_name, TASK_COMM_LEN, "%s", name);
> +		}
> +		ring->xenblkd = kthread_run(xen_blkif_schedule, ring, "%s", per_ring_name);
> +		if (IS_ERR(ring->xenblkd)) {
> +			err = PTR_ERR(ring->xenblkd);
> +			ring->xenblkd = NULL;
> +			xenbus_dev_error(blkif->be->dev, err, "start %s", per_ring_name);
> +			return;

That looks to be dangerous. We could not start one of the threads and just return.
The caller doesn't care about the error so we continue on our way. The frontend
thinks it is OK but when it tries to put I/Os on one of the rings - it is silent.

Perhaps what we should do is:
 1). Return an error.
 2). The callers of it ('xen_update_blkif_status' and 'frontend_changed')
     can take steps to either call 'xenbus_dev_fatal' (that will move the state
     of the driver to Closed) or also call 'xen_blkif_disconnect'. Before
     doing all of that reset the nr_rings we can support to 'i' value.

> +		}
>  	}
>  }
>  
> +static struct xen_blkif_ring *xen_blkif_ring_alloc(struct xen_blkif *blkif,
> +						   int nr_rings)
> +{
> +	int r, i, j;
> +	struct xen_blkif_ring *rings;
> +	struct pending_req *req;
> +
> +	rings = kzalloc(nr_rings * sizeof(struct xen_blkif_ring),
> +			GFP_KERNEL);
> +	if (!rings)
> +		return NULL;
> +
> +	for (r = 0 ; r < nr_rings ; r++) {
> +		struct xen_blkif_ring *ring = &rings[r];
> +
> +		spin_lock_init(&ring->blk_ring_lock);
> +
> +		init_waitqueue_head(&ring->wq);
> +		init_waitqueue_head(&ring->shutdown_wq);
> +
> +		ring->persistent_gnts.rb_node = NULL;
> +		spin_lock_init(&ring->free_pages_lock);
> +		INIT_LIST_HEAD(&ring->free_pages);
> +		INIT_LIST_HEAD(&ring->persistent_purge_list);
> +		ring->free_pages_num = 0;
> +		atomic_set(&ring->persistent_gnt_in_use, 0);
> +		atomic_set(&ring->refcnt, 1);
> +		atomic_set(&ring->inflight, 0);
> +		INIT_WORK(&ring->persistent_purge_work, xen_blkbk_unmap_purged_grants);
> +		spin_lock_init(&ring->pending_free_lock);
> +		init_waitqueue_head(&ring->pending_free_wq);
> +		INIT_LIST_HEAD(&ring->pending_free);
> +		for (i = 0; i < XEN_RING_REQS(nr_rings); i++) {
> +			req = kzalloc(sizeof(*req), GFP_KERNEL);
> +			if (!req)
> +				goto fail;
> +			list_add_tail(&req->free_list,
> +				      &ring->pending_free);
> +			for (j = 0; j < MAX_INDIRECT_SEGMENTS; j++) {
> +				req->segments[j] = kzalloc(sizeof(*req->segments[0]),
> +				                           GFP_KERNEL);
> +				if (!req->segments[j])
> +					goto fail;
> +			}
> +			for (j = 0; j < MAX_INDIRECT_PAGES; j++) {
> +				req->indirect_pages[j] = kzalloc(sizeof(*req->indirect_pages[0]),
> +				                                 GFP_KERNEL);
> +				if (!req->indirect_pages[j])
> +					goto fail;
> +			}
> +		}
> +
> +		INIT_WORK(&ring->free_work, xen_ring_deferred_free);
> +		ring->blkif = blkif;
> +		ring->ring_index = r;
> +
> +		spin_lock_init(&ring->stats_lock);
> +		ring->st_print = jiffies;
> +
> +		atomic_inc(&blkif->refcnt);
> +	}
> +
> +	return rings;
> +
> +fail:
> +	kfree(rings);

Uh, what about the req->segments[i], req->indirect_pages[j] freeing?


> +	return NULL;
> +}
> +

Like it was before:
> -
> -fail:
> -	list_for_each_entry_safe(req, n, &blkif->pending_free, free_list) {
> -		list_del(&req->free_list);
> -		for (j = 0; j < MAX_INDIRECT_SEGMENTS; j++) {
> -			if (!req->segments[j])
> -				break;
> -			kfree(req->segments[j]);
> -		}
> -		for (j = 0; j < MAX_INDIRECT_PAGES; j++) {
> -			if (!req->indirect_pages[j])
> -				break;
> -			kfree(req->indirect_pages[j]);
> -		}
> -		kfree(req);
> -	}
> -
> -	kmem_cache_free(xen_blkif_cachep, blkif);
> -
> -	return ERR_PTR(-ENOMEM);

And that return above should stay in.

>  }
>  
> -static int xen_blkif_map(struct xen_blkif *blkif, unsigned long shared_page,
> -			 unsigned int evtchn)
> +static int xen_blkif_map(struct xen_blkif_ring *ring, unsigned long shared_page,
> +			 unsigned int evtchn, unsigned int ring_idx)
>  {
>  	int err;
> +	struct xen_blkif *blkif;
> +	char dev_name[64];
>  
>  	/* Already connected through? */
> -	if (blkif->irq)
> +	if (ring->irq)
>  		return 0;
>  
> -	err = xenbus_map_ring_valloc(blkif->be->dev, shared_page, &blkif->blk_ring);
> +	blkif = ring->blkif;
> +
> +	err = xenbus_map_ring_valloc(ring->blkif->be->dev, shared_page, &ring->blk_ring);
>  	if (err < 0)
>  		return err;
>  
> @@ -210,64 +239,73 @@ static int xen_blkif_map(struct xen_blkif *blkif, unsigned long shared_page,
>  	case BLKIF_PROTOCOL_NATIVE:
>  	{
>  		struct blkif_sring *sring;
> -		sring = (struct blkif_sring *)blkif->blk_ring;
> -		BACK_RING_INIT(&blkif->blk_rings.native, sring, PAGE_SIZE);
> +		sring = (struct blkif_sring *)ring->blk_ring;
> +		BACK_RING_INIT(&ring->blk_rings.native, sring, PAGE_SIZE);
>  		break;
>  	}
>  	case BLKIF_PROTOCOL_X86_32:
>  	{
>  		struct blkif_x86_32_sring *sring_x86_32;
> -		sring_x86_32 = (struct blkif_x86_32_sring *)blkif->blk_ring;
> -		BACK_RING_INIT(&blkif->blk_rings.x86_32, sring_x86_32, PAGE_SIZE);
> +		sring_x86_32 = (struct blkif_x86_32_sring *)ring->blk_ring;
> +		BACK_RING_INIT(&ring->blk_rings.x86_32, sring_x86_32, PAGE_SIZE);
>  		break;
>  	}
>  	case BLKIF_PROTOCOL_X86_64:
>  	{
>  		struct blkif_x86_64_sring *sring_x86_64;
> -		sring_x86_64 = (struct blkif_x86_64_sring *)blkif->blk_ring;
> -		BACK_RING_INIT(&blkif->blk_rings.x86_64, sring_x86_64, PAGE_SIZE);
> +		sring_x86_64 = (struct blkif_x86_64_sring *)ring->blk_ring;
> +		BACK_RING_INIT(&ring->blk_rings.x86_64, sring_x86_64, PAGE_SIZE);
>  		break;
>  	}
>  	default:
>  		BUG();
>  	}
>  
> +	if (blkif->vbd.nr_supported_hw_queues)
> +		snprintf(dev_name, 64, "blkif-backend-%d", ring_idx);
> +	else
> +		snprintf(dev_name, 64, "blkif-backend");
>  	err = bind_interdomain_evtchn_to_irqhandler(blkif->domid, evtchn,
>  						    xen_blkif_be_int, 0,
> -						    "blkif-backend", blkif);
> +						    dev_name, ring);
>  	if (err < 0) {
> -		xenbus_unmap_ring_vfree(blkif->be->dev, blkif->blk_ring);
> -		blkif->blk_rings.common.sring = NULL;
> +		xenbus_unmap_ring_vfree(blkif->be->dev, ring->blk_ring);
> +		ring->blk_rings.common.sring = NULL;
>  		return err;
>  	}
> -	blkif->irq = err;
> +	ring->irq = err;
>  
>  	return 0;
>  }
>  
>  static int xen_blkif_disconnect(struct xen_blkif *blkif)
>  {
> -	if (blkif->xenblkd) {
> -		kthread_stop(blkif->xenblkd);
> -		wake_up(&blkif->shutdown_wq);
> -		blkif->xenblkd = NULL;
> -	}
> +	int i;
> +
> +	for (i = 0 ; i < blkif->nr_rings ; i++) {
> +		struct xen_blkif_ring *ring = &blkif->rings[i];
> +		if (ring->xenblkd) {
> +			kthread_stop(ring->xenblkd);
> +			wake_up(&ring->shutdown_wq);
> +			ring->xenblkd = NULL;
> +		}
>  
> -	/* The above kthread_stop() guarantees that at this point we
> -	 * don't have any discard_io or other_io requests. So, checking
> -	 * for inflight IO is enough.
> -	 */
> -	if (atomic_read(&blkif->inflight) > 0)
> -		return -EBUSY;
> +		/* The above kthread_stop() guarantees that at this point we
> +		 * don't have any discard_io or other_io requests. So, checking
> +		 * for inflight IO is enough.
> +		 */
> +		if (atomic_read(&ring->inflight) > 0)
> +			return -EBUSY;
>  
> -	if (blkif->irq) {
> -		unbind_from_irqhandler(blkif->irq, blkif);
> -		blkif->irq = 0;
> -	}
> +		if (ring->irq) {
> +			unbind_from_irqhandler(ring->irq, ring);
> +			ring->irq = 0;
> +		}
>  
> -	if (blkif->blk_rings.common.sring) {
> -		xenbus_unmap_ring_vfree(blkif->be->dev, blkif->blk_ring);
> -		blkif->blk_rings.common.sring = NULL;
> +		if (ring->blk_rings.common.sring) {
> +			xenbus_unmap_ring_vfree(blkif->be->dev, ring->blk_ring);
> +			ring->blk_rings.common.sring = NULL;
> +		}
>  	}
>  
>  	return 0;
> @@ -275,40 +313,52 @@ static int xen_blkif_disconnect(struct xen_blkif *blkif)
>  
>  static void xen_blkif_free(struct xen_blkif *blkif)
>  {
> -	struct pending_req *req, *n;
> -	int i = 0, j;
>  
>  	xen_blkif_disconnect(blkif);
>  	xen_vbd_free(&blkif->vbd);
>  
> +	kfree(blkif->rings);
> +
> +	kmem_cache_free(xen_blkif_cachep, blkif);
> +}
> +
> +static void xen_ring_free(struct xen_blkif_ring *ring)
> +{
> +	struct pending_req *req, *n;
> +	int i, j;
> +
>  	/* Remove all persistent grants and the cache of ballooned pages. */
> -	xen_blkbk_free_caches(blkif);
> +	xen_blkbk_free_caches(ring);
>  
>  	/* Make sure everything is drained before shutting down */
> -	BUG_ON(blkif->persistent_gnt_c != 0);
> -	BUG_ON(atomic_read(&blkif->persistent_gnt_in_use) != 0);
> -	BUG_ON(blkif->free_pages_num != 0);
> -	BUG_ON(!list_empty(&blkif->persistent_purge_list));
> -	BUG_ON(!list_empty(&blkif->free_pages));
> -	BUG_ON(!RB_EMPTY_ROOT(&blkif->persistent_gnts));
> -
> +	BUG_ON(ring->persistent_gnt_c != 0);
> +	BUG_ON(atomic_read(&ring->persistent_gnt_in_use) != 0);
> +	BUG_ON(ring->free_pages_num != 0);
> +	BUG_ON(!list_empty(&ring->persistent_purge_list));
> +	BUG_ON(!list_empty(&ring->free_pages));
> +	BUG_ON(!RB_EMPTY_ROOT(&ring->persistent_gnts));
> +
> +	i = 0;
>  	/* Check that there is no request in use */
> -	list_for_each_entry_safe(req, n, &blkif->pending_free, free_list) {
> +	list_for_each_entry_safe(req, n, &ring->pending_free, free_list) {
>  		list_del(&req->free_list);
> -
> -		for (j = 0; j < MAX_INDIRECT_SEGMENTS; j++)
> +		for (j = 0; j < MAX_INDIRECT_SEGMENTS; j++) {
> +			if (!req->segments[j])
> +				break;
>  			kfree(req->segments[j]);
> -
> -		for (j = 0; j < MAX_INDIRECT_PAGES; j++)
> +		}
> +		for (j = 0; j < MAX_INDIRECT_PAGES; j++) {
> +			if (!req->segments[j])
> +				break;
>  			kfree(req->indirect_pages[j]);
> -
> +		}
>  		kfree(req);
>  		i++;
>  	}
> +	WARN_ON(i != XEN_RING_REQS(ring->blkif->nr_rings));
>  
> -	WARN_ON(i != XEN_BLKIF_REQS);
> -
> -	kmem_cache_free(xen_blkif_cachep, blkif);
> +	if (atomic_dec_and_test(&ring->blkif->refcnt))
> +		xen_blkif_free(ring->blkif);
>  }
>  
>  int __init xen_blkif_interface_init(void)
> @@ -333,6 +383,29 @@ int __init xen_blkif_interface_init(void)
>  	{								\
>  		struct xenbus_device *dev = to_xenbus_device(_dev);	\
>  		struct backend_info *be = dev_get_drvdata(&dev->dev);	\
> +		struct xen_blkif *blkif = be->blkif;			\
> +		struct xen_blkif_ring *ring;				\
> +		int i;							\
> +									\
> +		blkif->st_oo_req = 0;					\
> +		blkif->st_rd_req = 0;					\
> +		blkif->st_wr_req = 0;					\
> +		blkif->st_f_req = 0;					\
> +		blkif->st_ds_req = 0;					\
> +		blkif->st_rd_sect = 0;					\
> +		blkif->st_wr_sect = 0;					\
> +		for (i = 0 ; i < blkif->nr_rings ; i++) {		\
> +			ring = &blkif->rings[i];			\
> +			spin_lock_irq(&ring->stats_lock);		\
> +			blkif->st_oo_req += ring->st_oo_req;		\
> +			blkif->st_rd_req += ring->st_rd_req;		\
> +			blkif->st_wr_req += ring->st_wr_req;		\
> +			blkif->st_f_req += ring->st_f_req;		\
> +			blkif->st_ds_req += ring->st_ds_req;		\
> +			blkif->st_rd_sect += ring->st_rd_sect;		\
> +			blkif->st_wr_sect += ring->st_wr_sect;		\
> +			spin_unlock_irq(&ring->stats_lock);		\
> +		}							\


Ah, that is why you had extra statistics! Please mention that
in the commit description

Could we make this macro a bit smarter and just add for the appropiate
value that is asked? 

Right now if I just want to see ds_req I end up computing for 'st_ds_req'
but also for the rest of them?

But making this code be nicely in this macro for this would be ugly.

Perhaps you can use offsetof?

Like so:

struct vbd_stats_offset {
	unsigned int global;
	unsigned int per_ring;
}

static const struct vbd_status_offset vbd_offsets[] = {
	{offsetof(struct xen_blkif, st_oo_req), offsetof(struct xen_blkif_ring, st_oo_req)}
	...
	};

And in the VBD macro:

	unsigned long long val = 0;
	unsigned int offset = offsetof(struct xen_blkif, ##args);

	unsigned int i;	
	for (i = 0; i < ARRAY_SIZE(vbd_offset); i++) {
		struct vbd_stats_offset *offsets = vbd_offsets[i];
		if (offsets->global == offset)
		{
			for (i = 0; i < blkif->nr_rings; i++) {
				unsigned long *ring = (unsigned long *)&blkif->rings[i];
				val += *(ring + offsets->per_ring);
			}
			break;
		}
		snprintf(bug, format, val);	

Minus any bugs in the above code..

Which should make it:
 - Faster (as we would be taking the lock only when looking in the ring)
 - No need to have the extra global statistics as we compute them on demand.

>  									\
>  		return sprintf(buf, format, ##args);			\
>  	}								\
> @@ -453,6 +526,7 @@ static int xen_vbd_create(struct xen_blkif *blkif, blkif_vdev_t handle,
>  		handle, blkif->domid);
>  	return 0;
>  }
> +

Spurious change.
>  static int xen_blkbk_remove(struct xenbus_device *dev)
>  {
>  	struct backend_info *be = dev_get_drvdata(&dev->dev);
> @@ -468,13 +542,14 @@ static int xen_blkbk_remove(struct xenbus_device *dev)
>  		be->backend_watch.node = NULL;
>  	}
>  
> -	dev_set_drvdata(&dev->dev, NULL);
> -
>  	if (be->blkif) {
> +		int i = 0;
>  		xen_blkif_disconnect(be->blkif);
> -		xen_blkif_put(be->blkif);
> +		for (; i < be->blkif->nr_rings ; i++)

Lets do the 'i = 0' in the loop in case somebody in the future
modifies it and does some operation on 'i' before the loop.

> +			xen_ring_put(&be->blkif->rings[i]);
>  	}
>  
> +	dev_set_drvdata(&dev->dev, NULL);

How come you move it _after_ ?

>  	kfree(be->mode);
>  	kfree(be);
>  	return 0;
> @@ -851,21 +926,46 @@ again:
>  static int connect_ring(struct backend_info *be)
