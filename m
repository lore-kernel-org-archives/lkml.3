Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752469AbaKCIkx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Nov 2014 03:40:53 -0500
Received: from mail-ob0-f173.google.com ([209.85.214.173]:36499 "EHLO
	mail-ob0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751797AbaKCIks (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Nov 2014 03:40:48 -0500
MIME-Version: 1.0
In-Reply-To: <1415003008-16683-3-git-send-email-hch@lst.de>
References: <1415003008-16683-1-git-send-email-hch@lst.de>
	<1415003008-16683-3-git-send-email-hch@lst.de>
Date: Mon, 3 Nov 2014 16:40:47 +0800
Message-ID: <CACVXFVMrW-GSa1YMuvGx=vvxxP2ePwxvTAKzdyv=ZYh6yf+Z5g@mail.gmail.com>
Subject: Re: [PATCH 2/2] blk-mq: allow direct dispatch to a driver specific workqueue
From: Ming Lei <tom.leiming@gmail.com>
To: Christoph Hellwig <hch@lst.de>
Cc: Jens Axboe <axboe@fb.com>, Richard Weinberger <richard@nod.at>,
        ceph-devel@vger.kernel.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Christoph,

On Mon, Nov 3, 2014 at 4:23 PM, Christoph Hellwig <hch@lst.de> wrote:
> We have various block drivers that need to execute long term blocking
> operations during I/O submission like file system or network I/O.
>
> Currently these drivers just queue up work to an internal workqueue
> from their request_fn.  With blk-mq we can make sure they always get
> called on their own workqueue directly for I/O submission by:
>
>  1) adding a flag to prevent inline submission of I/O, and
>  2) allowing the driver to pass in a workqueue in the tag_set that
>     will be used instead of kblockd.

The above two aren't enough because the big problem is that
drivers need a per-request work structure instead of 'hctx->run_work',
otherwise there are at most NR_CPUS concurrent submissions.

So the per-request work structure should be exposed to blk-mq
too for the kind of usage, such as .blk_mq_req_work(req) callback
in case of BLK_MQ_F_WORKQUEUE.

Thanks,

>
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---
>  block/blk-core.c       |  2 +-
>  block/blk-mq.c         | 12 +++++++++---
>  block/blk.h            |  1 +
>  include/linux/blk-mq.h |  4 ++++
>  4 files changed, 15 insertions(+), 4 deletions(-)
>
> diff --git a/block/blk-core.c b/block/blk-core.c
> index 0421b53..7f7249f 100644
> --- a/block/blk-core.c
> +++ b/block/blk-core.c
> @@ -61,7 +61,7 @@ struct kmem_cache *blk_requestq_cachep;
>  /*
>   * Controlling structure to kblockd
>   */
> -static struct workqueue_struct *kblockd_workqueue;
> +struct workqueue_struct *kblockd_workqueue;
>
>  void blk_queue_congestion_threshold(struct request_queue *q)
>  {
> diff --git a/block/blk-mq.c b/block/blk-mq.c
> index 22e50a5..3d27d22 100644
> --- a/block/blk-mq.c
> +++ b/block/blk-mq.c
> @@ -804,12 +804,13 @@ void blk_mq_run_hw_queue(struct blk_mq_hw_ctx *hctx, bool async)
>         if (unlikely(test_bit(BLK_MQ_S_STOPPED, &hctx->state)))
>                 return;
>
> -       if (!async && cpumask_test_cpu(smp_processor_id(), hctx->cpumask)) {
> +       if (!async && !(hctx->flags & BLK_MQ_F_WORKQUEUE) &&
> +           cpumask_test_cpu(smp_processor_id(), hctx->cpumask)) {
>                 __blk_mq_run_hw_queue(hctx);
>                 return;
>         }
>
> -       kblockd_schedule_delayed_work_on(blk_mq_hctx_next_cpu(hctx),
> +       queue_delayed_work_on(blk_mq_hctx_next_cpu(hctx), hctx->wq,
>                         &hctx->run_work, 0);
>  }
>
> @@ -908,7 +909,7 @@ static void blk_mq_delay_work_fn(struct work_struct *work)
>
>  void blk_mq_delay_queue(struct blk_mq_hw_ctx *hctx, unsigned long msecs)
>  {
> -       kblockd_schedule_delayed_work_on(blk_mq_hctx_next_cpu(hctx),
> +       queue_delayed_work_on(blk_mq_hctx_next_cpu(hctx), hctx->wq,
>                         &hctx->delay_work, msecs_to_jiffies(msecs));
>  }
>  EXPORT_SYMBOL(blk_mq_delay_queue);
> @@ -1581,6 +1582,11 @@ static int blk_mq_init_hctx(struct request_queue *q,
>         hctx->flags = set->flags;
>         hctx->cmd_size = set->cmd_size;
>
> +       if (set->wq)
> +               hctx->wq = set->wq;
> +       else
> +               hctx->wq = kblockd_workqueue;
> +
>         blk_mq_init_cpu_notifier(&hctx->cpu_notifier,
>                                         blk_mq_hctx_notify, hctx);
>         blk_mq_register_cpu_notifier(&hctx->cpu_notifier);
> diff --git a/block/blk.h b/block/blk.h
> index 43b0361..fb46ad0 100644
> --- a/block/blk.h
> +++ b/block/blk.h
> @@ -25,6 +25,7 @@ struct blk_flush_queue {
>         spinlock_t              mq_flush_lock;
>  };
>
> +extern struct workqueue_struct *kblockd_workqueue;
>  extern struct kmem_cache *blk_requestq_cachep;
>  extern struct kmem_cache *request_cachep;
>  extern struct kobj_type blk_queue_ktype;
> diff --git a/include/linux/blk-mq.h b/include/linux/blk-mq.h
> index 5a901d0..ebe4699 100644
> --- a/include/linux/blk-mq.h
> +++ b/include/linux/blk-mq.h
> @@ -37,6 +37,8 @@ struct blk_mq_hw_ctx {
>         unsigned int            queue_num;
>         struct blk_flush_queue  *fq;
>
> +       struct workqueue_struct *wq;
> +
>         void                    *driver_data;
>
>         struct blk_mq_ctxmap    ctx_map;
> @@ -64,6 +66,7 @@ struct blk_mq_hw_ctx {
>
>  struct blk_mq_tag_set {
>         struct blk_mq_ops       *ops;
> +       struct workqueue_struct *wq;
>         unsigned int            nr_hw_queues;
>         unsigned int            queue_depth;    /* max hw supported */
>         unsigned int            reserved_tags;
> @@ -156,6 +159,7 @@ enum {
>         BLK_MQ_F_SG_MERGE       = 1 << 2,
>         BLK_MQ_F_SYSFS_UP       = 1 << 3,
>         BLK_MQ_F_DEFER_ISSUE    = 1 << 4,
> +       BLK_MQ_F_WORKQUEUE      = 1 << 5,
>
>         BLK_MQ_S_STOPPED        = 0,
>         BLK_MQ_S_TAG_ACTIVE     = 1,
> --
> 1.9.1
>



-- 
Ming Lei
