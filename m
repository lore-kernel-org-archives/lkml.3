Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754257AbaIVOPg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Sep 2014 10:15:36 -0400
Received: from e06smtp10.uk.ibm.com ([195.75.94.106]:59537 "EHLO
	e06smtp10.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753528AbaIVOPe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Sep 2014 10:15:34 -0400
Message-ID: <54202EF8.4080909@de.ibm.com>
Date: Mon, 22 Sep 2014 16:15:20 +0200
From: Christian Borntraeger <borntraeger@de.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.8.0
MIME-Version: 1.0
To: tom.leiming@gmail.com, axboe@kernel.dk
CC: David Hildenbrand <dahi@linux.vnet.ibm.com>, kvm@vger.kernel.org,
        stable@vger.kernel.org, rusty@rustcorp.com.au,
        virtualization@lists.linux-foundation.org, mst@redhat.com,
        linux-kernel@vger.kernel.org, ppinatti@linux.vnet.ibm.com
Subject: Re: [PATCH] blk-mq: Avoid race condition with uninitialized requests
References: <1411031071-40390-1-git-send-email-dahi@linux.vnet.ibm.com> <1411031071-40390-2-git-send-email-dahi@linux.vnet.ibm.com>
In-Reply-To: <1411031071-40390-2-git-send-email-dahi@linux.vnet.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14092214-4966-0000-0000-0000016884B7
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/18/2014 11:04 AM, David Hildenbrand wrote:
> This patch should fix the bug reported in https://lkml.org/lkml/2014/9/11/249.
> 
> We have to initialize at least the atomic_flags and the cmd_flags when
> allocating storage for the requests.
> 
> Otherwise blk_mq_timeout_check() might dereference uninitialized pointers when
> racing with the creation of a request.
> 
> Also move the reset of cmd_flags for the initializing code to the point where a
> request is freed. So we will never end up with pending flush request indicators
> that might trigger dereferences of invalid pointers in blk_mq_timeout_check().
> 
> Cc: stable@vger.kernel.org
> Signed-off-by: David Hildenbrand <dahi@linux.vnet.ibm.com>

Acked-by: Christian Borntraeger <borntraeger@de.ibm.com>

Can you please add
Reported-by: Paulo De Rezende Pinatti <ppinatti@linux.vnet.ibm.com>
Tested-by: Paulo De Rezende Pinatti <ppinatti@linux.vnet.ibm.com>

as Paulo did the testing work?

We thing this patch is fine and should go upstream.



Christian


> ---
>  block/blk-mq.c | 4 +++-
>  1 file changed, 3 insertions(+), 1 deletion(-)
> 
> diff --git a/block/blk-mq.c b/block/blk-mq.c
> index 383ea0c..eed6340 100644
> --- a/block/blk-mq.c
> +++ b/block/blk-mq.c
> @@ -203,7 +203,6 @@ __blk_mq_alloc_request(struct blk_mq_alloc_data *data, int rw)
>  	if (tag != BLK_MQ_TAG_FAIL) {
>  		rq = data->hctx->tags->rqs[tag];
> 
> -		rq->cmd_flags = 0;
>  		if (blk_mq_tag_busy(data->hctx)) {
>  			rq->cmd_flags = REQ_MQ_INFLIGHT;
>  			atomic_inc(&data->hctx->nr_active);
> @@ -258,6 +257,7 @@ static void __blk_mq_free_request(struct blk_mq_hw_ctx *hctx,
> 
>  	if (rq->cmd_flags & REQ_MQ_INFLIGHT)
>  		atomic_dec(&hctx->nr_active);
> +	rq->cmd_flags = 0;
> 
>  	clear_bit(REQ_ATOM_STARTED, &rq->atomic_flags);
>  	blk_mq_put_tag(hctx, tag, &ctx->last_tag);
> @@ -1404,6 +1404,8 @@ static struct blk_mq_tags *blk_mq_init_rq_map(struct blk_mq_tag_set *set,
>  		left -= to_do * rq_size;
>  		for (j = 0; j < to_do; j++) {
>  			tags->rqs[i] = p;
> +			tags->rqs[i]->atomic_flags = 0;
> +			tags->rqs[i]->cmd_flags = 0;
>  			if (set->ops->init_request) {
>  				if (set->ops->init_request(set->driver_data,
>  						tags->rqs[i], hctx_idx, i,
> 

