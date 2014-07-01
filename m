Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757283AbaGACHM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jun 2014 22:07:12 -0400
Received: from aserp1040.oracle.com ([141.146.126.69]:35719 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752091AbaGACHI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jun 2014 22:07:08 -0400
Message-ID: <53B217E3.2090100@oracle.com>
Date: Tue, 01 Jul 2014 10:07:31 +0800
From: Junxiao Bi <junxiao.bi@oracle.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
CC: axboe@kernel.dk, joe.jin@oracle.com
Subject: Re: [PATCH] block: fix uint overflow when merging io requests
References: <1403853862-16565-1-git-send-email-junxiao.bi@oracle.com>
In-Reply-To: <1403853862-16565-1-git-send-email-junxiao.bi@oracle.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Source-IP: ucsinet22.oracle.com [156.151.31.94]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/27/2014 03:24 PM, Junxiao Bi wrote:
> This uint overflow will cause req->__data_len < req->bio->bi_size,
> this will confuse block layer and device driver.
>
> I watched a panic caused by this when mkfs.ext4 a volume of a large
> virtual disk on vm guest, blkdev_issue_discard() issue two bio with
> a total size over UINT_MAX, but the check in ll_back_merge_fn() didn't
> take affect due to the overflow and they were merged into one request.
> After the request is done, in blk_end_request_all(), BUG_ON(pending)
> was triggered and kernel panic. "pending" is true is because
> blk_update_request() return ture when req->__data_len is less
> than req->bio->bi_size.
Any body help review this patch?
blk_rq_sectors(), bio_sectors(), blk_rq_get_max_sectors() are all uint.

blk_rq_sectors(req) + bio_sectors(bio) > blk_rq_get_max_sectors(req)

This checking is bypassed when overflow happen. It will cause an io
request's
length less than its child bio's size.

Thanks,
Junxiao.
>
> Signed-off-by: Junxiao Bi <junxiao.bi@oracle.com>
> ---
>  block/blk-merge.c |   40 ++++++++++++++++++++++++++++++++++------
>  1 file changed, 34 insertions(+), 6 deletions(-)
>
> diff --git a/block/blk-merge.c b/block/blk-merge.c
> index b3bf0df..340c0a7 100644
> --- a/block/blk-merge.c
> +++ b/block/blk-merge.c
> @@ -325,11 +325,41 @@ no_merge:
>  	return 0;
>  }
>  
> -int ll_back_merge_fn(struct request_queue *q, struct request *req,
> +static inline bool ll_allow_merge_bio(struct request *req,
>  		     struct bio *bio)
>  {
>  	if (blk_rq_sectors(req) + bio_sectors(bio) >
> -	    blk_rq_get_max_sectors(req)) {
> +		blk_rq_get_max_sectors(req))
> +		return false;
> +
> +	/* check uint overflow */
> +	if (blk_rq_sectors(req) + bio_sectors(bio) < blk_rq_sectors(req)
> +		|| blk_rq_sectors(req) + bio_sectors(bio) < bio_sectors(bio))
> +		return false;
> +
> +	return true;
> +}
> +
> +static inline bool ll_allow_merge_req(struct request *req,
> +		     struct request *next)
> +{
> +	if (blk_rq_sectors(req) + blk_rq_sectors(next) >
> +		blk_rq_get_max_sectors(req))
> +		return false;
> +
> +	/* check uint overflow */
> +	if (blk_rq_sectors(req) + blk_rq_sectors(next) < blk_rq_sectors(req)
> +		|| blk_rq_sectors(req) + blk_rq_sectors(next) <
> +		blk_rq_sectors(next))
> +		return false;
> +
> +	return true;
> +}
> +
> +int ll_back_merge_fn(struct request_queue *q, struct request *req,
> +		     struct bio *bio)
> +{
> +	if (!ll_allow_merge_bio(req, bio)) {
>  		req->cmd_flags |= REQ_NOMERGE;
>  		if (req == q->last_merge)
>  			q->last_merge = NULL;
> @@ -346,8 +376,7 @@ int ll_back_merge_fn(struct request_queue *q, struct request *req,
>  int ll_front_merge_fn(struct request_queue *q, struct request *req,
>  		      struct bio *bio)
>  {
> -	if (blk_rq_sectors(req) + bio_sectors(bio) >
> -	    blk_rq_get_max_sectors(req)) {
> +	if (!ll_allow_merge_bio(req, bio)) {
>  		req->cmd_flags |= REQ_NOMERGE;
>  		if (req == q->last_merge)
>  			q->last_merge = NULL;
> @@ -389,8 +418,7 @@ static int ll_merge_requests_fn(struct request_queue *q, struct request *req,
>  	/*
>  	 * Will it become too large?
>  	 */
> -	if ((blk_rq_sectors(req) + blk_rq_sectors(next)) >
> -	    blk_rq_get_max_sectors(req))
> +	if (!ll_allow_merge_req(req, next))
>  		return 0;
>  
>  	total_phys_segments = req->nr_phys_segments + next->nr_phys_segments;

