Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753973AbaILKqx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Sep 2014 06:46:53 -0400
Received: from smtp02.citrix.com ([66.165.176.63]:29811 "EHLO
	SMTP02.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752835AbaILKqw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Sep 2014 06:46:52 -0400
X-IronPort-AV: E=Sophos;i="5.04,512,1406592000"; 
   d="scan'208";a="171712295"
Message-ID: <5412CF19.4020400@citrix.com>
Date: Fri, 12 Sep 2014 11:46:49 +0100
From: David Vrabel <david.vrabel@citrix.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Icedove/24.5.0
MIME-Version: 1.0
To: Arianna Avanzini <avanzini.arianna@gmail.com>, <konrad.wilk@oracle.com>,
        <boris.ostrovsky@oracle.com>, <xen-devel@lists.xenproject.org>,
        <linux-kernel@vger.kernel.org>
CC: <hch@infradead.org>, <bob.liu@oracle.com>, <felipe.franciosi@citrix.com>,
        <axboe@fb.com>
Subject: Re: [PATCH RFC v2 3/5] xen, blkfront: negotiate the number of block
 rings with the backend
References: <1410479844-2864-1-git-send-email-avanzini.arianna@gmail.com> <1410479844-2864-4-git-send-email-avanzini.arianna@gmail.com>
In-Reply-To: <1410479844-2864-4-git-send-email-avanzini.arianna@gmail.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-DLP: MIA2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/09/14 00:57, Arianna Avanzini wrote:
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

I don't think you need old_nr_rings.  nr_rings is the current number of
rings and you should only update nr_rings to a new number after tearing
down all the old rings.

>  	struct blkfront_ring_info *rinfo;
>  	struct request_queue *rq;
>  	unsigned int feature_flush;
> @@ -147,6 +147,7 @@ struct blkfront_info
>  	unsigned int discard_granularity;
>  	unsigned int discard_alignment;
>  	unsigned int feature_persistent:1;
> +	unsigned int hardware_queues;

hardware_queues seems to have the same purpose as nr_rings and isn't
needed.  nr_rings == 1 can mean write old keys for non-multi-queue
capable backends (or a mq capable one that only wants 1 queue).

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
> +	}
> +
>  	for (i = 0 ; i < info->nr_rings ; i++) {
> -		BUG_ON(i > 0);
> -		snprintf(ring_ref_s, 64, "ring-ref");
> -		snprintf(evtchn_s, 64, "event-channel");
> +		if (!info->hardware_queues) {

   if (info->nr_rings == 1)

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
>  		if (err) {
[...]
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
> +	mq_to_rq_transition = prev_nr_queues && !nr_queues;
> +
> +	if (prev_nr_queues != nr_queues) {
> +		printk(KERN_INFO "blkfront: %s: hw queues %u -> %u\n",
> +		       info->gd->disk_name, prev_nr_queues, nr_queues);
> +		if (mq_to_rq_transition) {
> +			struct blk_mq_hw_ctx *hctx;
> +			unsigned int i;
> +			/*
> +			 * Switch from multi-queue to single-queue:
> +			 * update hctx-to-ring mapping before
> +			 * resubmitting any requests
> +			 */
> +			queue_for_each_hw_ctx(info->rq, hctx, i)
> +				hctx->driver_data = &info->rinfo[0];

I think this does give a mechanism to change (reduce) the number of
rings used if the backend supports fewer.  You don't need to map all
hctxs to one ring.  You can distribute them amongst the available rings.

> @@ -1863,6 +1932,10 @@ static void blkfront_connect(struct blkfront_info *info)
>  		 * supports indirect descriptors, and how many.
>  		 */
>  		blkif_recover(info);
> +		info->rinfo = krealloc(info->rinfo,
> +				       info->nr_rings * sizeof(struct blkfront_ring_info),
> +				       GFP_KERNEL);
> +

You don't check for allocation failure here.

David
