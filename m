Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759080AbaLKWX2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Dec 2014 17:23:28 -0500
Received: from mail-pd0-f171.google.com ([209.85.192.171]:35269 "EHLO
	mail-pd0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758964AbaLKWX1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Dec 2014 17:23:27 -0500
Message-ID: <548A1962.4040603@kernel.dk>
Date: Thu, 11 Dec 2014 15:23:30 -0700
From: Jens Axboe <axboe@kernel.dk>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.3.0
MIME-Version: 1.0
To: Jeff Moyer <jmoyer@redhat.com>, linux-kernel@vger.kernel.org, shli@fb.com
Subject: Re: [patch] blk-mq: fix plugging in blk_sq_make_request
References: <x49k31xc0ae.fsf@segfault.boston.devel.redhat.com>
In-Reply-To: <x49k31xc0ae.fsf@segfault.boston.devel.redhat.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/11/2014 03:02 PM, Jeff Moyer wrote:
> Hi,
> 
> The following appears in blk_sq_make_request:
> 
> 	/*
> 	 * If we have multiple hardware queues, just go directly to
> 	 * one of those for sync IO.
> 	 */
> 
> We clearly don't have multiple hardware queues, here!  This comment was
> introduced with this commit 07068d5b8e (blk-mq: split make request
> handler for multi and single queue):
> 
>     We want slightly different behavior from them:
>     
>     - On single queue devices, we currently use the per-process plug
>       for deferred IO and for merging.
>     
>     - On multi queue devices, we don't use the per-process plug, but
>       we want to go straight to hardware for SYNC IO.
> 
> The old code had this:
> 
>         use_plug = !is_flush_fua && ((q->nr_hw_queues == 1) || !is_sync);
> 
> and that was converted to:
> 
> 	use_plug = !is_flush_fua && !is_sync;
> 
> which is not equivalent.  For the single queue case, that second half of
> the && expression is always true.  So, what I think was actually inteded
> follows (and this more closely matches what is done in blk_queue_bio).

Good catch! Yes, single queue used to plug on just !is_flush_fua.
Shaohua has a patch in this area too, CC'ing him.

But this looks correct for the single queue case, there _should_ be a
nice win for retaining plugging there. You now added merging for flush
fua though, intentional or an oversight? I'd retain the checks there,
basically just make use_plug !is_flush_fua, perhaps.

Leaving patch below.

> diff --git a/block/blk-mq.c b/block/blk-mq.c
> index 1d016fc..1cd90c0 100644
> --- a/block/blk-mq.c
> +++ b/block/blk-mq.c
> @@ -1208,16 +1208,11 @@ static void blk_sq_make_request(struct request_queue *q, struct bio *bio)
>  {
>  	const int is_sync = rw_is_sync(bio->bi_rw);
>  	const int is_flush_fua = bio->bi_rw & (REQ_FLUSH | REQ_FUA);
> -	unsigned int use_plug, request_count = 0;
> +	struct blk_plug *plug;
> +	unsigned int request_count = 0;
>  	struct blk_map_ctx data;
>  	struct request *rq;
>  
> -	/*
> -	 * If we have multiple hardware queues, just go directly to
> -	 * one of those for sync IO.
> -	 */
> -	use_plug = !is_flush_fua && !is_sync;
> -
>  	blk_queue_bounce(q, &bio);
>  
>  	if (bio_integrity_enabled(bio) && bio_integrity_prep(bio)) {
> @@ -1225,7 +1220,7 @@ static void blk_sq_make_request(struct request_queue *q, struct bio *bio)
>  		return;
>  	}
>  
> -	if (use_plug && !blk_queue_nomerges(q) &&
> +	if (!blk_queue_nomerges(q) &&
>  	    blk_attempt_plug_merge(q, bio, &request_count))
>  		return;
>  
> @@ -1244,21 +1239,18 @@ static void blk_sq_make_request(struct request_queue *q, struct bio *bio)
>  	 * utilize that to temporarily store requests until the task is
>  	 * either done or scheduled away.
>  	 */
> -	if (use_plug) {
> -		struct blk_plug *plug = current->plug;
> -
> -		if (plug) {
> -			blk_mq_bio_to_request(rq, bio);
> -			if (list_empty(&plug->mq_list))
> -				trace_block_plug(q);
> -			else if (request_count >= BLK_MAX_REQUEST_COUNT) {
> -				blk_flush_plug_list(plug, false);
> -				trace_block_plug(q);
> -			}
> -			list_add_tail(&rq->queuelist, &plug->mq_list);
> -			blk_mq_put_ctx(data.ctx);
> -			return;
> +	plug = current->plug;
> +	if (plug) {
> +		blk_mq_bio_to_request(rq, bio);
> +		if (list_empty(&plug->mq_list))
> +			trace_block_plug(q);
> +		else if (request_count >= BLK_MAX_REQUEST_COUNT) {
> +			blk_flush_plug_list(plug, false);
> +			trace_block_plug(q);
>  		}
> +		list_add_tail(&rq->queuelist, &plug->mq_list);
> +		blk_mq_put_ctx(data.ctx);
> +		return;
>  	}
>  
>  	if (!blk_mq_merge_queue_io(data.hctx, data.ctx, rq, bio)) {
> 


-- 
Jens Axboe

