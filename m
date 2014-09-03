Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756598AbaICUfd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Sep 2014 16:35:33 -0400
Received: from mail-pa0-f44.google.com ([209.85.220.44]:54754 "EHLO
	mail-pa0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932109AbaICUf3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Sep 2014 16:35:29 -0400
Message-ID: <54077B91.5040408@kernel.dk>
Date: Wed, 03 Sep 2014 14:35:29 -0600
From: Jens Axboe <axboe@kernel.dk>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.0
MIME-Version: 1.0
To: Alexander Gordeev <agordeev@redhat.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/3] blk-mq: Cleanup blk_mq_tag_busy() and blk_mq_tag_idle()
References: <cover.1409775956.git.agordeev@redhat.com> <1860c570e5efa8ece323a7ba20f3597bd5e99d25.1409775956.git.agordeev@redhat.com>
In-Reply-To: <1860c570e5efa8ece323a7ba20f3597bd5e99d25.1409775956.git.agordeev@redhat.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/03/2014 02:33 PM, Alexander Gordeev wrote:
> Signed-off-by: Alexander Gordeev <agordeev@redhat.com>
> Cc: Jens Axboe <axboe@kernel.dk>
> ---
>  block/blk-mq-tag.c |  4 +---
>  block/blk-mq-tag.h | 17 ++++++++---------
>  2 files changed, 9 insertions(+), 12 deletions(-)
> 
> diff --git a/block/blk-mq-tag.c b/block/blk-mq-tag.c
> index c1b9242..4953b64 100644
> --- a/block/blk-mq-tag.c
> +++ b/block/blk-mq-tag.c
> @@ -58,13 +58,11 @@ static inline void bt_index_atomic_inc(atomic_t *index)
>  /*
>   * If a previously inactive queue goes active, bump the active user count.
>   */
> -bool __blk_mq_tag_busy(struct blk_mq_hw_ctx *hctx)
> +void __blk_mq_tag_busy(struct blk_mq_hw_ctx *hctx)
>  {
>  	if (!test_bit(BLK_MQ_S_TAG_ACTIVE, &hctx->state) &&
>  	    !test_and_set_bit(BLK_MQ_S_TAG_ACTIVE, &hctx->state))
>  		atomic_inc(&hctx->tags->active_queues);
> -
> -	return true;
>  }

This is obviously a good idea.

> diff --git a/block/blk-mq-tag.h b/block/blk-mq-tag.h
> index 6206ed1..795ec3f 100644
> --- a/block/blk-mq-tag.h
> +++ b/block/blk-mq-tag.h
> @@ -66,23 +66,22 @@ enum {
>  	BLK_MQ_TAG_MAX		= BLK_MQ_TAG_FAIL - 1,
>  };
>  
> -extern bool __blk_mq_tag_busy(struct blk_mq_hw_ctx *);
> +extern void __blk_mq_tag_busy(struct blk_mq_hw_ctx *);
>  extern void __blk_mq_tag_idle(struct blk_mq_hw_ctx *);
>  
>  static inline bool blk_mq_tag_busy(struct blk_mq_hw_ctx *hctx)
>  {
> -	if (!(hctx->flags & BLK_MQ_F_TAG_SHARED))
> -		return false;
> -
> -	return __blk_mq_tag_busy(hctx);
> +	if (hctx->flags & BLK_MQ_F_TAG_SHARED) {
> +		__blk_mq_tag_busy(hctx);
> +		return true;
> +	}
> +	return false;
>  }

The normal/fast path here is the flag NOT being set, which is why it was
coded that way to put the fast path inline.

>  
>  static inline void blk_mq_tag_idle(struct blk_mq_hw_ctx *hctx)
>  {
> -	if (!(hctx->flags & BLK_MQ_F_TAG_SHARED))
> -		return;
> -
> -	__blk_mq_tag_idle(hctx);
> +	if (hctx->flags & BLK_MQ_F_TAG_SHARED)
> +		__blk_mq_tag_idle(hctx);
>  }

Ditto


-- 
Jens Axboe

