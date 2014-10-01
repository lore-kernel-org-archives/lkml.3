Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751696AbaJAUT0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Oct 2014 16:19:26 -0400
Received: from aserp1040.oracle.com ([141.146.126.69]:20822 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750901AbaJAUTY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Oct 2014 16:19:24 -0400
Date: Wed, 1 Oct 2014 16:18:57 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: Arianna Avanzini <avanzini.arianna@gmail.com>
Cc: boris.ostrovsky@oracle.com, david.vrabel@citrix.com,
        xen-devel@lists.xenproject.org, linux-kernel@vger.kernel.org,
        hch@infradead.org, bob.liu@oracle.com, felipe.franciosi@citrix.com,
        axboe@fb.com
Subject: Re: [PATCH RFC v2 3/5] xen, blkfront: negotiate the number of block
 rings with the backend
Message-ID: <20141001201857.GD12581@laptop.dumpdata.com>
References: <1410479844-2864-1-git-send-email-avanzini.arianna@gmail.com>
 <1410479844-2864-4-git-send-email-avanzini.arianna@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1410479844-2864-4-git-send-email-avanzini.arianna@gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
X-Source-IP: ucsinet22.oracle.com [156.151.31.94]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 12, 2014 at 01:57:22AM +0200, Arianna Avanzini wrote:
> This commit implements the negotiation of the number of block rings
> to be used; as a default, the number of rings is decided by the
> frontend driver and is equal to the number of hardware queues that
> the backend makes available. In case of guest migration towards a
> host whose devices expose a different number of hardware queues, the
> number of I/O rings used by the frontend driver remains the same;
> XenStore keys may vary if the frontend needs to be compatible with
> a host not having multi-queue support.
> 
> Signed-off-by: Arianna Avanzini <avanzini.arianna@gmail.com>
> ---
>  drivers/block/xen-blkfront.c | 95 +++++++++++++++++++++++++++++++++++++++-----
>  1 file changed, 84 insertions(+), 11 deletions(-)
> 
> diff --git a/drivers/block/xen-blkfront.c b/drivers/block/xen-blkfront.c
> index 9282df1..77e311d 100644
> --- a/drivers/block/xen-blkfront.c
> +++ b/drivers/block/xen-blkfront.c
> @@ -137,7 +137,7 @@ struct blkfront_info
>  	int vdevice;
>  	blkif_vdev_t handle;
>  	enum blkif_state connected;
> -	unsigned int nr_rings;
> +	unsigned int nr_rings, old_nr_rings;
>  	struct blkfront_ring_info *rinfo;
>  	struct request_queue *rq;
>  	unsigned int feature_flush;
> @@ -147,6 +147,7 @@ struct blkfront_info
>  	unsigned int discard_granularity;
>  	unsigned int discard_alignment;
>  	unsigned int feature_persistent:1;
> +	unsigned int hardware_queues;
>  	unsigned int max_indirect_segments;
>  	int is_ready;
>  	/* Block layer tags. */
> @@ -669,7 +670,7 @@ static int xlvbd_init_blk_queue(struct gendisk *gd, u16 sector_size,
>  
>  	memset(&info->tag_set, 0, sizeof(info->tag_set));
>  	info->tag_set.ops = &blkfront_mq_ops;
> -	info->tag_set.nr_hw_queues = 1;
> +	info->tag_set.nr_hw_queues = info->hardware_queues ? : 1;
>  	info->tag_set.queue_depth = BLK_RING_SIZE;
>  	info->tag_set.numa_node = NUMA_NO_NODE;
>  	info->tag_set.flags = BLK_MQ_F_SHOULD_MERGE | BLK_MQ_F_SG_MERGE;
> @@ -938,6 +939,7 @@ static void xlvbd_release_gendisk(struct blkfront_info *info)
>  	info->gd = NULL;
>  }
>  
> +/* Must be called with io_lock held */
>  static void kick_pending_request_queues(struct blkfront_ring_info *rinfo,
>  					unsigned long *flags)
>  {
> @@ -1351,10 +1353,24 @@ again:
>  		goto destroy_blkring;
>  	}
>  
> +	/* Advertise the number of rings */
> +	err = xenbus_printf(xbt, dev->nodename, "nr_blk_rings",
> +			    "%u", info->nr_rings);
> +	if (err) {
> +		xenbus_dev_fatal(dev, err, "advertising number of rings");
> +		goto abort_transaction;


Not sure I understand the purpose of this?

The 'hardware_queues' is gathered via the 'nr_supported_hw_queues' which is what the
backend advertise. Then you tell the backend how many you are going to use using
a different XenStore value?


I would simplify this by having one key: 'multi-queue-max-queues' or such. The backend
would write in its directory (/local/domain/0/backend/drivers/<front domaind>/vbd/<id>/multi-queue-max-queues)
it's max.

The frontend would then write in the its in directory the 'multi-queue-num-queues'. The value
it writes MUST be less or equal to what the backend says. 

And of course if we don't get the value we assume '1'.

This is following xen-netfront does.

That also would simplifiy this code as we could just assume that 'nr_rings == hardware_queues'
througout the code. And in 'blkfront_gather_hw_queues' you can add:

 unsigned int val;

 int err = xenbus_gather(..)
 if (err)
	/* Backend too old. One ring */
	return 1;
  return max(nr_online_cpus(), val);

And then in 'talk_to_blkback' you can write that 'ring->nr_rings' value in 'feature-nr-rings'.

If the backend is deaf (too old) it will ignore it. If it is newer, it will do the
right thing.

> +	}
> +
>  	for (i = 0 ; i < info->nr_rings ; i++) {
> -		BUG_ON(i > 0);
> -		snprintf(ring_ref_s, 64, "ring-ref");
> -		snprintf(evtchn_s, 64, "event-channel");

Instead of 64, I would do an macro for the value. And I think you can
do 19 + 13 = 32 (19 to represent 2^64 value, and 13 for 'event-channel'.

> +		if (!info->hardware_queues) {
> +			BUG_ON(i > 0);
> +			/* Support old XenStore keys */
> +			snprintf(ring_ref_s, 64, "ring-ref");
> +			snprintf(evtchn_s, 64, "event-channel");
> +		} else {
> +			snprintf(ring_ref_s, 64, "ring-ref-%d", i);
> +			snprintf(evtchn_s, 64, "event-channel-%d", i);
> +		}
>  		err = xenbus_printf(xbt, dev->nodename,
>  				    ring_ref_s, "%u", info->rinfo[i].ring_ref);

That looks actually odd. %u is for unsigned int, but 'ring_ref' is int. Hm, another bug.

>  		if (err) {
> @@ -1403,6 +1419,14 @@ again:
>  	return err;
>  }
>  
> +static inline int blkfront_gather_hw_queues(struct blkfront_info *info,
> +					    unsigned int *nr_queues)
> +{
> +	return xenbus_gather(XBT_NIL, info->xbdev->otherend,
> +			     "nr_supported_hw_queues", "%u", nr_queues,
> +			     NULL);
> +}
> +

See above about my comment.

Oh, and also this patch should have a blurb in the blkif.h about this.
>  /**
>   * Entry point to this code when a new device is created.  Allocate the basic
>   * structures and the ring buffer for communication with the backend, and
> @@ -1414,6 +1438,7 @@ static int blkfront_probe(struct xenbus_device *dev,
>  {
>  	int err, vdevice, i, r;
>  	struct blkfront_info *info;
> +	unsigned int nr_queues;
>  
>  	/* FIXME: Use dynamic device id if this is not set. */
>  	err = xenbus_scanf(XBT_NIL, dev->nodename,
> @@ -1472,10 +1497,19 @@ static int blkfront_probe(struct xenbus_device *dev,
>  	info->handle = simple_strtoul(strrchr(dev->nodename, '/')+1, NULL, 0);
>  	dev_set_drvdata(&dev->dev, info);
>  
> -	/* Allocate the correct number of rings. */
> -	info->nr_rings = 1;
> -	pr_info("blkfront: %s: %d rings\n",
> -		info->gd->disk_name, info->nr_rings);
> +	/* Gather the number of hardware queues as soon as possible */
> +	err = blkfront_gather_hw_queues(info, &nr_queues);
> +	if (err)
> +		info->hardware_queues = 0;
> +	else
> +		info->hardware_queues = nr_queues;
> +	/*
> +	 * The backend has told us the number of hw queues he wants.
> +	 * Allocate the correct number of rings.
> +	 */
> +	info->nr_rings = info->hardware_queues ? : 1;
> +	pr_info("blkfront: %s: %d hardware queues, %d rings\n",
> +		info->gd->disk_name, info->hardware_queues, info->nr_rings);

pr_debug

>  
>  	info->rinfo = kzalloc(info->nr_rings *
>  				sizeof(struct blkfront_ring_info),
> @@ -1556,7 +1590,7 @@ static int blkif_recover(struct blkfront_info *info)
>  
>  	segs = blkfront_gather_indirect(info);
>  
> -	for (r = 0 ; r < info->nr_rings ; r++) {
> +	for (r = 0 ; r < info->old_nr_rings ; r++) {

I would stash 'old_nr_rings' as an parameter for 'blkif_recover'.

But that means the caller of 'blkif_recover' has to get this (talk_to_blkback).


>  		rc |= blkif_setup_shadow(&info->rinfo[r], &copy);
>  		rc |= blkfront_setup_indirect(&info->rinfo[r], segs);
>  		if (rc) {
> @@ -1599,7 +1633,7 @@ static int blkif_recover(struct blkfront_info *info)
>  	/* Now safe for us to use the shared ring */
>  	info->connected = BLKIF_STATE_CONNECTED;
>  
> -	for (i = 0 ; i < info->nr_rings ; i++) {
> +	for (i = 0 ; i < info->old_nr_rings ; i++) {
>  		spin_lock_irqsave(&info->rinfo[i].io_lock, flags);
>  		/* Kick any other new requests queued since we resumed */
>  		kick_pending_request_queues(&info->rinfo[i], &flags);
> @@ -1659,11 +1693,46 @@ static int blkfront_resume(struct xenbus_device *dev)
>  {
>  	struct blkfront_info *info = dev_get_drvdata(&dev->dev);
>  	int err;
> +	unsigned int nr_queues, prev_nr_queues;
> +	bool mq_to_rq_transition;
>  
>  	dev_dbg(&dev->dev, "blkfront_resume: %s\n", dev->nodename);
>  
> +	prev_nr_queues = info->hardware_queues;
> +
> +	err = blkfront_gather_hw_queues(info, &nr_queues);
> +	if (err < 0)
> +		nr_queues = 0;

Or you could have set 'nr_queues' when defining the value.

Anyhow with my idea of making blkfront_gather_hw_queues set
your ring->nr_ring to the value from the backend or set to
one for old backends, this means your code here:
> +	mq_to_rq_transition = prev_nr_queues && !nr_queues;

Will require that you do:
	mq_to_rq_transition = info->nr_shadow_rings != info->nr_rings;

> +
> +	if (prev_nr_queues != nr_queues) {
> +		printk(KERN_INFO "blkfront: %s: hw queues %u -> %u\n",
> +		       info->gd->disk_name, prev_nr_queues, nr_queues);

pr_info. Or pr_debug.

> +		if (mq_to_rq_transition) {

OK, so if we transition to _less_ than what we had we assume one ring.

Why not just negotiate:
	max(info->nr_shadows_rings, info->nr_rings);

And we assume that nr_shadows_rings will be set on the first allocation
to info->nr_rings. That should make it possible to use up to maximum
amount of contexts we had when we initially started the driver.

Granted once we migrate once more the nr_shadows_rings gets updated
to a new value and the info->nr_rings too .. so eventually that might
go down to one and stay there. Even if we migrate back to the initial
guest that has 32 queues or such.

I think we might need three members in 'info':

 'shadow_nr_ring' - used by the blkif_recover only. Is reset to zero once
     that code is done. Is set to some value in 'blkif_resume'

 'init_nr_ring' - the initial value of contexts we want. Perhaps ignore the
    XenBus state and just base it on the number of CPUs we booted with? That
    way we have ample room. And if migrate to old backends we just use one
    ring, and if we migrate between different hosts that have different
    amount of hardware contexts we just use up to 'init_nr_ring'.

    Oh, and this should probably be gated by some module parameter for
    adventerous users to tweak.

 'nr_ring' - the currently negotiated amount of rings. Can fluctuare between
   migration, but will always be equal or below 'init_nr_ring'. When migrating
   its value will be written to 'shadow_nr_ring' to figure out how many
   rings to iterate through.
 
> +			struct blk_mq_hw_ctx *hctx;
> +			unsigned int i;
> +			/*
> +			 * Switch from multi-queue to single-queue:
> +			 * update hctx-to-ring mapping before
> +			 * resubmitting any requests
> +			 */
> +			queue_for_each_hw_ctx(info->rq, hctx, i)
> +				hctx->driver_data = &info->rinfo[0];
> +		}
> +		info->hardware_queues = nr_queues;
> +	}
> +
>  	blkif_free(info, info->connected == BLKIF_STATE_CONNECTED);
>  
> +	/* Free with old number of rings, but rebuild with new */
> +	info->old_nr_rings = info->nr_rings;
> +	/*
> +	 * Must not update if transition didn't happen, we're keeping
> +	 * the old number of rings.
> +	 */
> +	if (mq_to_rq_transition)
> +		info->nr_rings = 1;
> +
>  	err = talk_to_blkback(dev, info);
>  
>  	/*
> @@ -1863,6 +1932,10 @@ static void blkfront_connect(struct blkfront_info *info)
>  		 * supports indirect descriptors, and how many.
>  		 */
>  		blkif_recover(info);
> +		info->rinfo = krealloc(info->rinfo,
> +				       info->nr_rings * sizeof(struct blkfront_ring_info),
> +				       GFP_KERNEL);
> +

David already mentioned it, but we need to also deal with the case of this
giving us -ENOMEM and scalling back (perhaps to just one ring)?

>  		return;
>  
>  	default:
> -- 
> 2.1.0
> 
