Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757954Ab3LWQYs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Dec 2013 11:24:48 -0500
Received: from bombadil.infradead.org ([198.137.202.9]:36761 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757625Ab3LWQYp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Dec 2013 11:24:45 -0500
Date: Mon, 23 Dec 2013 08:24:42 -0800
From: Christoph Hellwig <hch@infradead.org>
To: Ming Lei <tom.leiming@gmail.com>
Cc: Jens Axboe <axboe@kernel.dk>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/4] block: blk-mq: support draining mq queue
Message-ID: <20131223162442.GA9383@infradead.org>
References: <1387815539-12257-1-git-send-email-tom.leiming@gmail.com>
 <1387815539-12257-2-git-send-email-tom.leiming@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1387815539-12257-2-git-send-email-tom.leiming@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 24, 2013 at 12:18:56AM +0800, Ming Lei wrote:
> blk_mq_drain_queue() is introduced so that we can drain
> mq queue during cleanup queue.
> 
> Also don't accept new requests any more if queue is marked
> as dying.

blk_cleanup_queue is a call from the LLDD, there is no need to make
it handle the MQ case.  However given that there might be a lot of
code shared between blk_cleanup_queue and blk_mq_cleanup_queue an
internal helper might be useful.

> +	if (q->mq_ops) {
> +		blk_mq_drain_queue(q);
> +	} else {
> +		spin_lock_irq(lock);
> +		__blk_drain_queue(q, true);
> +		queue_flag_set(QUEUE_FLAG_DEAD, q);
> +		spin_unlock_irq(lock);
> +	}

Why doesn't the mq case set QUEUE_FLAG_DEAD here?

> -static void blk_mq_freeze_queue(struct request_queue *q)
> +static void __blk_mq_freeze_queue(struct request_queue *q,
> +		bool force_drain)
>  {
>  	bool drain;
>  
> +	if (force_drain)
> +		goto do_drain;
> +
>  	spin_lock_irq(q->queue_lock);
>  	drain = !q->bypass_depth++;
>  	queue_flag_set(QUEUE_FLAG_BYPASS, q);
> @@ -134,6 +141,7 @@ static void blk_mq_freeze_queue(struct request_queue *q)
>  	if (!drain)
>  		return;
>  
> + do_drain:
>  	while (true) {
>  		s64 count;

This begs to be split into two functions, one that forces the drain, and
once that wraps it.

Also blk_execute_rq_nowait now needs to check the dying case for MQ as
well.
