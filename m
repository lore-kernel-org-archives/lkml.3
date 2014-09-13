Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752165AbaIMTaE (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Sep 2014 15:30:04 -0400
Received: from bombadil.infradead.org ([198.137.202.9]:35181 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752112AbaIMTaC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Sep 2014 15:30:02 -0400
Date: Sat, 13 Sep 2014 12:29:58 -0700
From: Christoph Hellwig <hch@infradead.org>
To: Arianna Avanzini <avanzini.arianna@gmail.com>
Cc: konrad.wilk@oracle.com, boris.ostrovsky@oracle.com,
        david.vrabel@citrix.com, xen-devel@lists.xenproject.org,
        linux-kernel@vger.kernel.org, hch@infradead.org, bob.liu@oracle.com,
        felipe.franciosi@citrix.com, axboe@fb.com
Subject: Re: [PATCH RFC v2 1/5] xen, blkfront: port to the the multi-queue
 block layer API
Message-ID: <20140913192958.GA31744@infradead.org>
References: <1410479844-2864-1-git-send-email-avanzini.arianna@gmail.com>
 <1410479844-2864-2-git-send-email-avanzini.arianna@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1410479844-2864-2-git-send-email-avanzini.arianna@gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> +static int blkfront_queue_rq(struct blk_mq_hw_ctx *hctx, struct request *req)
>  {
> +	struct blkfront_info *info = req->rq_disk->private_data;
>  
> +	spin_lock_irq(&info->io_lock);
> +	if (RING_FULL(&info->ring))
> +		goto wait;
>  
> -		blk_start_request(req);
> +	if ((req->cmd_type != REQ_TYPE_FS) ||
> +			((req->cmd_flags & (REQ_FLUSH | REQ_FUA)) &&
> +			 !info->flush_op)) {
> +		req->errors = -EIO;
> +		blk_mq_complete_request(req);
> +		spin_unlock_irq(&info->io_lock);
> +		return BLK_MQ_RQ_QUEUE_ERROR;

As mentioned during the last round this should only return
BLK_MQ_RQ_QUEUE_ERROR, and not also set req->errors and complete the
request.

> +	}
>  
> +	if (blkif_queue_request(req)) {
> +		blk_mq_requeue_request(req);
> +		goto wait;

Same here, this should only return BLK_MQ_RQ_QUEUE_BUSY after the wait
label, but not also requeue the request.  While the error case above
is harmless due to the double completion protection in blk-mq, this one
actually is actively harmful.

>  wait:
> +	/* Avoid pointless unplugs. */
> +	blk_mq_stop_hw_queue(hctx);
> +	spin_unlock_irq(&info->io_lock);

In general you should try to do calls into the blk_mq code without holding
your locks to simplify the locking hierachy and reduce lock hold times.

> -static void kick_pending_request_queues(struct blkfront_info *info)
> +static void kick_pending_request_queues(struct blkfront_info *info,
> +					unsigned long *flags)
>  {
>  	if (!RING_FULL(&info->ring)) {
> -		/* Re-enable calldowns. */
> -		blk_start_queue(info->rq);
> -		/* Kick things off immediately. */
> -		do_blkif_request(info->rq);
> +		spin_unlock_irqrestore(&info->io_lock, *flags);
> +		blk_mq_start_stopped_hw_queues(info->rq, 0);
> +		spin_lock_irqsave(&info->io_lock, *flags);
>  	}

The second paramter to blk_mq_start_stopped_hw_queues is a bool,
so you should pass false instead of 0 here.

Also the locking in this area seems wrong as most callers immediately
acquire and/or release the io_lock, so it seems more useful in general
to expect this function to be called without it.

>  static void blkif_restart_queue(struct work_struct *work)
>  {
>  	struct blkfront_info *info = container_of(work, struct blkfront_info, work);
> +	unsigned long flags;
>  
> -	spin_lock_irq(&info->io_lock);
> +	spin_lock_irqsave(&info->io_lock, flags);

There shouldn't be any need to ever take a lock as _irqsave from a work
queue handler.

Note that you might be able to get rid of your own workqueue here by
simply using blk_mq_start_stopped_hw_queues with the async paramter set
to true.

>  
> -		error = (bret->status == BLKIF_RSP_OKAY) ? 0 : -EIO;
> +		error = req->errors = (bret->status == BLKIF_RSP_OKAY) ? 0 : -EIO;

I don't think you need the error variable any more as blk-mq always uses
req->errors to pass the errno value.

> -	kick_pending_request_queues(info);
> +	kick_pending_request_queues(info, &flags);
>  
>  	list_for_each_entry_safe(req, n, &requests, queuelist) {
>  		/* Requeue pending requests (flush or discard) */
>  		list_del_init(&req->queuelist);
>  		BUG_ON(req->nr_phys_segments > segs);
> -		blk_requeue_request(info->rq, req);
> +		blk_mq_requeue_request(req);

Note that blk_mq_requeue_request calls will need a
blk_mq_kick_requeue_list call to be actually requeued.  It should be
fine to have one past this loop here.

