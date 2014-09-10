Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753153AbaIJSRa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Sep 2014 14:17:30 -0400
Received: from mail-pd0-f173.google.com ([209.85.192.173]:33176 "EHLO
	mail-pd0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752958AbaIJSR3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Sep 2014 14:17:29 -0400
Message-ID: <541095C1.2040500@kernel.dk>
Date: Wed, 10 Sep 2014 12:17:37 -0600
From: Jens Axboe <axboe@kernel.dk>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.0
MIME-Version: 1.0
To: Robert Elliott <relliott@beardog.cce.hp.com>, elliott@hp.com, hch@lst.de,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] block: return error if too many reserved tags are
 requested
References: <20140910001417.9294.40414.stgit@beardog.cce.hp.com> <20140910001806.9294.35884.stgit@beardog.cce.hp.com>
In-Reply-To: <20140910001806.9294.35884.stgit@beardog.cce.hp.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/09/2014 06:18 PM, Robert Elliott wrote:
> From: Robert Elliott <elliott@hp.com>
> 
> Make blk_mq_alloc_tag_set return an error if set->reserved_tags
> is greater than BLK_MQ_MAX_DEPTH minus the minimum number of
> tags, since:
> * set->queue_depth is truncated to that value
> * set->reserved_tags needs to be less than set->queue_depth
> 
> Signed-off-by: Robert Elliott <elliott@hp.com>
> ---
>  block/blk-mq.c |    8 +++++---
>  1 files changed, 5 insertions(+), 3 deletions(-)
> 
> diff --git a/block/blk-mq.c b/block/blk-mq.c
> index c49fe00..dc2970d 100644
> --- a/block/blk-mq.c
> +++ b/block/blk-mq.c
> @@ -1936,16 +1936,18 @@ int blk_mq_alloc_tag_set(struct blk_mq_tag_set *set)
>  		return -EINVAL;
>  	if (!set->queue_depth)
>  		return -EINVAL;
> +	if (set->reserved_tags > BLK_MQ_MAX_DEPTH - BLK_MQ_TAG_MIN)
> +		return -EINVAL;
>  	if (set->queue_depth < set->reserved_tags + BLK_MQ_TAG_MIN)
>  		return -EINVAL;
>  
>  	if (!set->nr_hw_queues || !set->ops->queue_rq || !set->ops->map_queue)
>  		return -EINVAL;
>  
> -	if (set->queue_depth > BLK_MQ_MAX_DEPTH) {
> +	if (set->queue_depth > BLK_MQ_MAX_DEPTH - set->reserved_tags) {

This is harder to read than:

	if (set->queue_depth + set->reserved_tags > BLK_MQ_MAX_DEPTH) {

which more clearly expresses the same thing. But set->queue_depth is the
total pool, reserved tags come out of that pool. So I don't think this
is correct.

-- 
Jens Axboe

