Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752012Ab3LOUR0 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Dec 2013 15:17:26 -0500
Received: from mail-ve0-f178.google.com ([209.85.128.178]:61931 "EHLO
	mail-ve0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750821Ab3LOURY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Dec 2013 15:17:24 -0500
MIME-Version: 1.0
In-Reply-To: <1386690638-8717-1-git-send-email-m@bjorling.me>
References: <1386690638-8717-1-git-send-email-m@bjorling.me>
Date: Sun, 15 Dec 2013 12:17:24 -0800
X-Google-Sender-Auth: GOKgSStlc2EuagEcVjMrBunwL0g
Message-ID: <CA+55aFzFuRoPZmqZ_7GW1SLHvXN90G8pyadJBZfjkKwbNC1ONg@mail.gmail.com>
Subject: Re: [PATCH] null_blk: mem garbage on NUMA systems during init
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Matias Bjorling <m@bjorling.me>
Cc: Jens Axboe <axboe@kernel.dk>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jens, ping?

Patch looks fine, and it looks completely bogus to set

     null_mq_reg.nr_hw_queues

to 'nr_online_nodes', when we've potentially done "setup_queues()"
with just a single queue.

So I'm going to apply this as-is, I'm just wondering why I haven't
heard anything from you..

                     Linus


On Tue, Dec 10, 2013 at 7:50 AM, Matias Bjorling <m@bjorling.me> wrote:
> For NUMA systems, initializing the blk-mq layer and using per node hctx. We
> initialize submit queues to 1, while blk-mq nr_hw_queues is initialized to the
> number of NUMA nodes.
>
> This makes the null_init_hctx function overwrite memory outside of what it
> allocated. In my case it lead to writing garbage into struct request_queue's
> mq_map.
>
> Signed-off-by: Matias Bjorling <m@bjorling.me>
> ---
>  drivers/block/null_blk.c | 8 ++++----
>  1 file changed, 4 insertions(+), 4 deletions(-)
>
> diff --git a/drivers/block/null_blk.c b/drivers/block/null_blk.c
> index ea192ec..f370fc1 100644
> --- a/drivers/block/null_blk.c
> +++ b/drivers/block/null_blk.c
> @@ -495,23 +495,23 @@ static int null_add_dev(void)
>
>         spin_lock_init(&nullb->lock);
>
> +       if (queue_mode == NULL_Q_MQ && use_per_node_hctx)
> +               submit_queues = nr_online_nodes;
> +
>         if (setup_queues(nullb))
>                 goto err;
>
>         if (queue_mode == NULL_Q_MQ) {
>                 null_mq_reg.numa_node = home_node;
>                 null_mq_reg.queue_depth = hw_queue_depth;
> +               null_mq_reg.nr_hw_queues = submit_queues;
>
>                 if (use_per_node_hctx) {
>                         null_mq_reg.ops->alloc_hctx = null_alloc_hctx;
>                         null_mq_reg.ops->free_hctx = null_free_hctx;
> -
> -                       null_mq_reg.nr_hw_queues = nr_online_nodes;
>                 } else {
>                         null_mq_reg.ops->alloc_hctx = blk_mq_alloc_single_hw_queue;
>                         null_mq_reg.ops->free_hctx = blk_mq_free_single_hw_queue;
> -
> -                       null_mq_reg.nr_hw_queues = submit_queues;
>                 }
>
>                 nullb->q = blk_mq_init_queue(&null_mq_reg, nullb);
> --
> 1.8.3.2
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
