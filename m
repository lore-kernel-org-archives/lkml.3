Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754084Ab3JFSKR (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Oct 2013 14:10:17 -0400
Received: from merlin.infradead.org ([205.233.59.134]:48615 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754012Ab3JFSKP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Oct 2013 14:10:15 -0400
Date: Sun, 6 Oct 2013 12:10:13 -0600
From: Jens Axboe <axboe@kernel.dk>
To: Christoph Hellwig <hch@infradead.org>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] blk-mq: fix blk_mq_start_stopped_hw_queues from irq
 context
Message-ID: <20131006181013.GE8252@kernel.dk>
References: <20131006170956.GA30544@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131006170956.GA30544@infradead.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Oct 06 2013, Christoph Hellwig wrote:
> The only caller of blk_mq_start_stopped_hw_queues is in irq context,
> leading to lockdep splat when it actually gets called.  Fix this by
> deferring the hw queue run to workqueue context.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> 
> diff --git a/block/blk-mq.c b/block/blk-mq.c
> index 2b85029..923e9e1 100644
> --- a/block/blk-mq.c
> +++ b/block/blk-mq.c
> @@ -686,7 +686,8 @@ void blk_mq_start_stopped_hw_queues(struct request_queue *q)
>  		if (!test_bit(BLK_MQ_S_STOPPED, &hctx->state))
>  			continue;
>  
> -		blk_mq_start_hw_queue(hctx);
> +		clear_bit(BLK_MQ_S_STOPPED, &hctx->state);
> +		blk_mq_run_hw_queue(hctx, true);
>  	}
>  }
>  EXPORT_SYMBOL(blk_mq_start_stopped_hw_queues);

Thanks, applied. Might not be a bad idea to just mimic the run queue
API, and provide a blk_mq_start_hw_queue(hctx, is_async) instead.

-- 
Jens Axboe

