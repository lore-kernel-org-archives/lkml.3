Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752028AbaJAUTd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Oct 2014 16:19:33 -0400
Received: from aserp1040.oracle.com ([141.146.126.69]:20839 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751956AbaJAUT2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Oct 2014 16:19:28 -0400
Date: Wed, 1 Oct 2014 16:18:54 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: Arianna Avanzini <avanzini.arianna@gmail.com>
Cc: boris.ostrovsky@oracle.com, david.vrabel@citrix.com,
        xen-devel@lists.xenproject.org, linux-kernel@vger.kernel.org,
        hch@infradead.org, bob.liu@oracle.com, felipe.franciosi@citrix.com,
        axboe@fb.com
Subject: Re: [PATCH RFC v2 2/5] xen, blkfront: introduce support for multiple
 block rings
Message-ID: <20141001201854.GC12581@laptop.dumpdata.com>
References: <1410479844-2864-1-git-send-email-avanzini.arianna@gmail.com>
 <1410479844-2864-3-git-send-email-avanzini.arianna@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1410479844-2864-3-git-send-email-avanzini.arianna@gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 12, 2014 at 01:57:21AM +0200, Arianna Avanzini wrote:
> This commit introduces in xen-blkfront actual support for multiple
> block rings. The number of block rings to be used is still forced
> to one.

I would add:

Since this is just a patch hoisting members from 'struct blkinfo_info'
in an 'struct blkfront_ring_info' to allow multiple rings, we do not
introduce any new behavior to take advantage of it. The patch
consists of:
 - Accessing members through 'info->rinfo' instead of previously
   done via just accessing 'info' members.
 - Adding the 'init_ctx' for the MQ API to initialize properly
   the multiple ring support
 - The 'fill_grant_buffer' moved to a different function to deal
   with the filling of that per ring instead of done in the function
   that gathers the count of segments - which is only called once
   - while we need to call 'fill_grant_buffer' per each ring.

That said, some comments:

> +static void blkif_free(struct blkfront_info *info, int suspend)
> +{
> +	struct grant *persistent_gnt;
> +	struct grant *n;
> +	int i;
>  
> -	/* Free resources associated with old device channel. */
> -	if (info->ring_ref != GRANT_INVALID_REF) {
> -		gnttab_end_foreign_access(info->ring_ref, 0,
> -					  (unsigned long)info->ring.sring);
> -		info->ring_ref = GRANT_INVALID_REF;
> -		info->ring.sring = NULL;
> -	}
> -	if (info->irq)
> -		unbind_from_irqhandler(info->irq, info);
> -	info->evtchn = info->irq = 0;
> +	info->connected = suspend ?
> +		BLKIF_STATE_SUSPENDED : BLKIF_STATE_DISCONNECTED;
> +
> +	/*
> +	 * Prevent new requests being issued until we fix things up:
> +	 * no more blkif_request() and no more gnttab callback work.
> +	 */
> +	if (info->rq) {

I would have done it the other way to make it easier to read the code.

That is do:

	if (!info->rq)
		return;

And then you can continue with the code without having to worry about
hitting the StyleGuide issues (the 80 or 120 lines limit or such)

> +		blk_mq_stop_hw_queues(info->rq);
> +
> +		for (i = 0 ; i < info->nr_rings ; i++) {
> +			struct blkfront_ring_info *rinfo = &info->rinfo[i];
> +
> +			spin_lock_irq(&info->rinfo[i].io_lock);
> +			/* Remove all persistent grants */
> +			if (!list_empty(&rinfo->grants)) {
> +				list_for_each_entry_safe(persistent_gnt, n,
> +				                         &rinfo->grants, node) {
> +					list_del(&persistent_gnt->node);
> +					if (persistent_gnt->gref != GRANT_INVALID_REF) {
> +						gnttab_end_foreign_access(persistent_gnt->gref,
> +						                          0, 0UL);
> +						rinfo->persistent_gnts_c--;
> +					}
> +					if (info->feature_persistent)
> +						__free_page(pfn_to_page(persistent_gnt->pfn));
> +					kfree(persistent_gnt);
> +				}
> +			}
> +			BUG_ON(rinfo->persistent_gnts_c != 0);
> +
> +			/*
> +			 * Remove indirect pages, this only happens when using indirect
> +			 * descriptors but not persistent grants
> +			 */
> +			if (!list_empty(&rinfo->indirect_pages)) {
> +				struct page *indirect_page, *n;
> +
> +				BUG_ON(info->feature_persistent);
> +				list_for_each_entry_safe(indirect_page, n, &rinfo->indirect_pages, lru) {
> +					list_del(&indirect_page->lru);
> +					__free_page(indirect_page);
> +				}
> +			}
>  
> +			blkif_free_ring(rinfo, info->feature_persistent);
> +
> +			gnttab_cancel_free_callback(&rinfo->callback);
> +			spin_unlock_irq(&rinfo->io_lock);
> +
> +			/* Flush gnttab callback work. Must be done with no locks held. */
> +			flush_work(&info->rinfo[i].work);
> +
> +			/* Free resources associated with old device channel. */
> +			if (rinfo->ring_ref != GRANT_INVALID_REF) {
> +				gnttab_end_foreign_access(rinfo->ring_ref, 0,
> +							  (unsigned long)rinfo->ring.sring);
> +				rinfo->ring_ref = GRANT_INVALID_REF;
> +				rinfo->ring.sring = NULL;
> +			}
> +			if (rinfo->irq)
> +				unbind_from_irqhandler(rinfo->irq, rinfo);
> +			rinfo->evtchn = rinfo->irq = 0;
> +		}
> +	}
>  }
>  

.. snip..
> @@ -1274,13 +1333,16 @@ static int talk_to_blkback(struct xenbus_device *dev,
>  			   struct blkfront_info *info)
>  {
>  	const char *message = NULL;
> +	char ring_ref_s[64] = "", evtchn_s[64] = "";

Why the usage of these, since:
>  	struct xenbus_transaction xbt;
> -	int err;
> +	int i, err;
>  
> -	/* Create shared ring, alloc event channel. */
> -	err = setup_blkring(dev, info);
> -	if (err)
> -		goto out;
> +	for (i = 0 ; i < info->nr_rings ; i++) {
> +		/* Create shared ring, alloc event channel. */
> +		err = setup_blkring(dev, &info->rinfo[i]);
> +		if (err)
> +			goto out;
> +	}
>  
>  again:
>  	err = xenbus_transaction_start(&xbt);
> @@ -1289,18 +1351,24 @@ again:
>  		goto destroy_blkring;
>  	}
>  
> -	err = xenbus_printf(xbt, dev->nodename,
> -			    "ring-ref", "%u", info->ring_ref);
> -	if (err) {
> -		message = "writing ring-ref";
> -		goto abort_transaction;
> -	}
> -	err = xenbus_printf(xbt, dev->nodename,
> -			    "event-channel", "%u", info->evtchn);
> -	if (err) {
> -		message = "writing event-channel";
> -		goto abort_transaction;
> +	for (i = 0 ; i < info->nr_rings ; i++) {
> +		BUG_ON(i > 0);
> +		snprintf(ring_ref_s, 64, "ring-ref");
> +		snprintf(evtchn_s, 64, "event-channel");

You seem to just writting it with the same value on each iteration? Is that
to prepare when we would use it? I would rather ditch this and keep
it in the patch that would use it.

Also the 64 needs a #define.
> +		err = xenbus_printf(xbt, dev->nodename,
> +				    ring_ref_s, "%u", info->rinfo[i].ring_ref);
> +		if (err) {
> +			message = "writing ring-ref";
> +			goto abort_transaction;
> +		}
> +		err = xenbus_printf(xbt, dev->nodename,
> +				    evtchn_s, "%u", info->rinfo[i].evtchn);
> +		if (err) {
> +			message = "writing event-channel";
> +			goto abort_transaction;
> +		}
>  	}
> +
>  	err = xenbus_printf(xbt, dev->nodename, "protocol", "%s",
>  			    XEN_IO_PROTO_ABI_NATIVE);
>  	if (err) {
> @@ -1344,7 +1412,7 @@ again:
>  static int blkfront_probe(struct xenbus_device *dev,
>  			  const struct xenbus_device_id *id)
>  {
> -	int err, vdevice, i;
> +	int err, vdevice, i, r;
>  	struct blkfront_info *info;
>  
>  	/* FIXME: Use dynamic device id if this is not set. */
> @@ -1396,23 +1464,36 @@ static int blkfront_probe(struct xenbus_device *dev,
>  	}
>  
>  	mutex_init(&info->mutex);
> -	spin_lock_init(&info->io_lock);
>  	info->xbdev = dev;
>  	info->vdevice = vdevice;
> -	INIT_LIST_HEAD(&info->grants);
> -	INIT_LIST_HEAD(&info->indirect_pages);
> -	info->persistent_gnts_c = 0;
>  	info->connected = BLKIF_STATE_DISCONNECTED;
> -	INIT_WORK(&info->work, blkif_restart_queue);
> -
> -	for (i = 0; i < BLK_RING_SIZE; i++)
> -		info->shadow[i].req.u.rw.id = i+1;
> -	info->shadow[BLK_RING_SIZE-1].req.u.rw.id = 0x0fffffff;
>  
>  	/* Front end dir is a number, which is used as the id. */
>  	info->handle = simple_strtoul(strrchr(dev->nodename, '/')+1, NULL, 0);
>  	dev_set_drvdata(&dev->dev, info);
>  
> +	/* Allocate the correct number of rings. */
> +	info->nr_rings = 1;
> +	pr_info("blkfront: %s: %d rings\n",
> +		info->gd->disk_name, info->nr_rings);

pr_debug.


> +
> +	info->rinfo = kzalloc(info->nr_rings *
> +				sizeof(struct blkfront_ring_info),
> +			      GFP_KERNEL);

Something is off with the tabs/spaces.

And please do check if we allocated it in the first place. As in

if (!info->rinfo) {
	err = -ENOMEM;
	goto out;
}

And add the label 'out' ..

> +	for (r = 0 ; r < info->nr_rings ; r++) {
> +		struct blkfront_ring_info *rinfo = &info->rinfo[r];
> +
> +		rinfo->info = info;
> +		rinfo->persistent_gnts_c = 0;
> +		INIT_LIST_HEAD(&rinfo->grants);
> +		INIT_LIST_HEAD(&rinfo->indirect_pages);
> +		INIT_WORK(&rinfo->work, blkif_restart_queue);
> +		spin_lock_init(&rinfo->io_lock);
> +		for (i = 0; i < BLK_RING_SIZE; i++)
> +			rinfo->shadow[i].req.u.rw.id = i+1;
> +		rinfo->shadow[BLK_RING_SIZE-1].req.u.rw.id = 0x0fffffff;
> +	}
> +

==> Right here, 'out:' label :-)

>  	err = talk_to_blkback(dev, info);
>  	if (err) {
>  		kfree(info);
> @@ -1438,88 +1519,100 @@ static void split_bio_end(struct bio *bio, int error)
>  	bio_put(bio);
>  }
>  
> -static int blkif_recover(struct blkfront_info *info)
> +static int blkif_setup_shadow(struct blkfront_ring_info *rinfo,
> +			      struct blk_shadow **copy)
>  {
>  	int i;
> +
> +	/* Stage 1: Make a safe copy of the shadow state. */
> +	*copy = kmemdup(rinfo->shadow, sizeof(rinfo->shadow),
> +		       GFP_NOIO | __GFP_REPEAT | __GFP_HIGH);
> +	if (!*copy)
> +		return -ENOMEM;
> +
> +	/* Stage 2: Set up free list. */
> +	memset(&rinfo->shadow, 0, sizeof(rinfo->shadow));
> +	for (i = 0; i < BLK_RING_SIZE; i++)
> +		rinfo->shadow[i].req.u.rw.id = i+1;
> +	rinfo->shadow_free = rinfo->ring.req_prod_pvt;
> +	rinfo->shadow[BLK_RING_SIZE-1].req.u.rw.id = 0x0fffffff;
> +
> +	return 0;
> +}
> +
> +static int blkif_recover(struct blkfront_info *info)
> +{
> +	int i, r;
>  	struct request *req, *n;
>  	struct blk_shadow *copy;
> -	int rc;
> +	int rc = 0;
>  	struct bio *bio, *cloned_bio;
> -	struct bio_list bio_list, merge_bio;
> +	struct bio_list uninitialized_var(bio_list), merge_bio;
>  	unsigned int segs, offset;
>  	unsigned long flags;
>  	int pending, size;
>  	struct split_bio *split_bio;
>  	struct list_head requests;
>  
> -	/* Stage 1: Make a safe copy of the shadow state. */
> -	copy = kmemdup(info->shadow, sizeof(info->shadow),
> -		       GFP_NOIO | __GFP_REPEAT | __GFP_HIGH);
> -	if (!copy)
> -		return -ENOMEM;
> -
> -	/* Stage 2: Set up free list. */
> -	memset(&info->shadow, 0, sizeof(info->shadow));
> -	for (i = 0; i < BLK_RING_SIZE; i++)
> -		info->shadow[i].req.u.rw.id = i+1;
> -	info->shadow_free = info->ring.req_prod_pvt;
> -	info->shadow[BLK_RING_SIZE-1].req.u.rw.id = 0x0fffffff;
> +	segs = blkfront_gather_indirect(info);
>  
> -	rc = blkfront_setup_indirect(info);
> -	if (rc) {
> -		kfree(copy);
> -		return rc;
> -	}
> +	for (r = 0 ; r < info->nr_rings ; r++) {
> +		rc |= blkif_setup_shadow(&info->rinfo[r], &copy);
> +		rc |= blkfront_setup_indirect(&info->rinfo[r], segs);

Could you add an comment why it is OK to continue working if the
'blkif_setup_shadow' fails (say with -ENOMEM)?
> +		if (rc) {
> +			kfree(copy);
> +			return rc;
> +		}
>  
> -	segs = info->max_indirect_segments ? : BLKIF_MAX_SEGMENTS_PER_REQUEST;
> -	blk_queue_max_segments(info->rq, segs);
> -	bio_list_init(&bio_list);
> -	INIT_LIST_HEAD(&requests);
> -	for (i = 0; i < BLK_RING_SIZE; i++) {
> -		/* Not in use? */
> -		if (!copy[i].request)
> -			continue;
> +		segs = info->max_indirect_segments ? : BLKIF_MAX_SEGMENTS_PER_REQUEST;
> +		blk_queue_max_segments(info->rq, segs);
> +		bio_list_init(&bio_list);
> +		INIT_LIST_HEAD(&requests);
> +		for (i = 0; i < BLK_RING_SIZE; i++) {
> +			/* Not in use? */
> +			if (!copy[i].request)
> +				continue;
>  
> -		/*
> -		 * Get the bios in the request so we can re-queue them.
> -		 */
> -		if (copy[i].request->cmd_flags &
> -		    (REQ_FLUSH | REQ_FUA | REQ_DISCARD | REQ_SECURE)) {
>  			/*
> -			 * Flush operations don't contain bios, so
> -			 * we need to requeue the whole request
> +			 * Get the bios in the request so we can re-queue them.
>  			 */
> -			list_add(&copy[i].request->queuelist, &requests);
> -			continue;
> +			if (copy[i].request->cmd_flags &
> +			    (REQ_FLUSH | REQ_FUA | REQ_DISCARD | REQ_SECURE)) {
> +				/*
> +				 * Flush operations don't contain bios, so
> +				 * we need to requeue the whole request
> +				 */
> +				list_add(&copy[i].request->queuelist, &requests);
> +				continue;
> +			}
> +			merge_bio.head = copy[i].request->bio;
> +			merge_bio.tail = copy[i].request->biotail;
> +			bio_list_merge(&bio_list, &merge_bio);
> +			copy[i].request->bio = NULL;
> +			blk_put_request(copy[i].request);
>  		}
> -		merge_bio.head = copy[i].request->bio;
> -		merge_bio.tail = copy[i].request->biotail;
> -		bio_list_merge(&bio_list, &merge_bio);
> -		copy[i].request->bio = NULL;
> -		blk_put_request(copy[i].request);
> +		kfree(copy);
>  	}
>  
> -	kfree(copy);
> -
>  	xenbus_switch_state(info->xbdev, XenbusStateConnected);
>  
> -	spin_lock_irqsave(&info->io_lock, flags);
> -
>  	/* Now safe for us to use the shared ring */
>  	info->connected = BLKIF_STATE_CONNECTED;
>  
> -	/* Kick any other new requests queued since we resumed */
> -	kick_pending_request_queues(info, &flags);
> +	for (i = 0 ; i < info->nr_rings ; i++) {
> +		spin_lock_irqsave(&info->rinfo[i].io_lock, flags);
> +		/* Kick any other new requests queued since we resumed */
> +		kick_pending_request_queues(&info->rinfo[i], &flags);
>  
> -	list_for_each_entry_safe(req, n, &requests, queuelist) {
> -		/* Requeue pending requests (flush or discard) */
> -		list_del_init(&req->queuelist);
> -		BUG_ON(req->nr_phys_segments > segs);
> -		blk_mq_requeue_request(req);
> +		list_for_each_entry_safe(req, n, &requests, queuelist) {
> +			/* Requeue pending requests (flush or discard) */
> +			list_del_init(&req->queuelist);
> +			BUG_ON(req->nr_phys_segments > segs);
> +			blk_mq_requeue_request(req);
> +		}
> +		spin_unlock_irqrestore(&info->rinfo[i].io_lock, flags);
>  	}
>  
> -	spin_unlock_irqrestore(&info->io_lock, flags);
> -
>  	while ((bio = bio_list_pop(&bio_list)) != NULL) {
>  		/* Traverse the list of pending bios and re-queue them */
>  		if (bio_segments(bio) > segs) {
> @@ -1643,14 +1736,15 @@ static void blkfront_setup_discard(struct blkfront_info *info)
>  		info->feature_secdiscard = !!discard_secure;
>  }
>  
> -static int blkfront_setup_indirect(struct blkfront_info *info)
> +
> +static int blkfront_gather_indirect(struct blkfront_info *info)
>  {
>  	unsigned int indirect_segments, segs;
> -	int err, i;
> +	int err = xenbus_gather(XBT_NIL, info->xbdev->otherend,
> +				"feature-max-indirect-segments", "%u",
> +				&indirect_segments,
> +				NULL);
>  
> -	err = xenbus_gather(XBT_NIL, info->xbdev->otherend,
> -			    "feature-max-indirect-segments", "%u", &indirect_segments,
> -			    NULL);


That looks like an unrellated patch. Could you leave it as it please?

>  	if (err) {
>  		info->max_indirect_segments = 0;
>  		segs = BLKIF_MAX_SEGMENTS_PER_REQUEST;
> @@ -1660,7 +1754,16 @@ static int blkfront_setup_indirect(struct blkfront_info *info)
>  		segs = info->max_indirect_segments;
>  	}
>  
> -	err = fill_grant_buffer(info, (segs + INDIRECT_GREFS(segs)) * BLK_RING_SIZE);
> +	return segs;
> +}
> +
> +static int blkfront_setup_indirect(struct blkfront_ring_info *rinfo,
> +				   unsigned int segs)
> +{
> +	struct blkfront_info *info = rinfo->info;
> +	int err, i;
> +
> +	err = fill_grant_buffer(rinfo, (segs + INDIRECT_GREFS(segs)) * BLK_RING_SIZE);


Can you say a bit about why you are moving it from 'blkfront_gather_indirect' to
'blkfront_setup_indirect'  - preferrably in the commit description.

I presume it would be because in the past we did it in blkfront_gather_indirect
and since it does not iterate over the number of rings (but just gives you the
segment value), we need to move it to the function that will be called for
each ring?

It actually seems that this sort of patch could be done earlier (as an standalone one)
as I think the fill_grant_buffer in blkfront_gather_indirect seems rather ill placed
(it is about gathering data, not setting it up!).

Anyhow, it is OK to have it in this patch - but just please mention that in the commit
description.
>  	if (err)
>  		goto out_of_memory;
>  
