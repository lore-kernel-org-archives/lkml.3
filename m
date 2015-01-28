Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754185AbbA2BUQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jan 2015 20:20:16 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:46618 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752562AbbA2BUL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jan 2015 20:20:11 -0500
MIME-Version: 1.0
In-Reply-To: <54C92A47.2030709@sandisk.com>
References: <54C92A47.2030709@sandisk.com>
Date: Thu, 29 Jan 2015 07:52:14 +0800
Message-ID: <CACVXFVOtOujWH5jLLf16+-MeW--aiP1N14a=4aJP2h2_UVdtsw@mail.gmail.com>
Subject: Re: [PATCH] blk-mq: Fix a recently introduced scsi-mq regression
From: Ming Lei <ming.lei@canonical.com>
To: Bart Van Assche <bart.vanassche@sandisk.com>
Cc: Jens Axboe <axboe@kernel.dk>, Sasha Levin <sasha.levin@oracle.com>,
        Christoph Hellwig <hch@lst.de>,
        linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 29, 2015 at 2:28 AM, Bart Van Assche
<bart.vanassche@sandisk.com> wrote:
> This patch fixes a use-after-free that was introduced via patch
> "blk-mq: fix hctx/ctx kobject use-after-free" (commit
> 76d697d10769; kernel v3.19-rc4) and fixes the following crash:

Sorry, my fault, I shouldn't have linked mq's release with mq_kobj,
which may be released before running blk_cleanup_queue().

Another approach may be to revert the faulty commit and release all
mq stuff in request queue's release handler(blk_release_queue)
which should be more safe and simple.

>
> general protection fault: 0000 [#1] SMP
> Workqueue: srp_remove srp_remove_work [ib_srp]
> task: ffff88083530c880 ti: ffff880835774000 task.ti: ffff880835774000
>  [<ffffffff8125a43c>] blk_mq_tag_wakeup_all+0x1c/0x90
> RDI: 6b6b6b6b6b6b6b6b
> Call Trace:
>  [<ffffffff8125792e>] blk_mq_wake_waiters+0x4e/0x80
>  [<ffffffff81247e86>] blk_set_queue_dying+0x26/0x90
>  [<ffffffff8124abe5>] blk_cleanup_queue+0x35/0x250
>  [<ffffffffa001ce4a>] __scsi_remove_device+0x5a/0xe0 [scsi_mod]
>  [<ffffffffa001b48f>] scsi_forget_host+0x6f/0x80 [scsi_mod]
>  [<ffffffffa000d646>] scsi_remove_host+0x86/0x140 [scsi_mod]
>  [<ffffffffa0884c0b>] srp_remove_work+0x9b/0x210 [ib_srp]
>  [<ffffffff8106ff48>] process_one_work+0x1d8/0x780
>  [<ffffffff8107060b>] worker_thread+0x11b/0x460
>  [<ffffffff81075c8f>] kthread+0xef/0x110
>  [<ffffffff814dbdac>] ret_from_fork+0x7c/0xb0
>
> Signed-off-by: Bart Van Assche <bart.vanassche@sandisk.com>
> Cc: Ming Lei <ming.lei@canonical.com>
> Cc: Sasha Levin <sasha.levin@oracle.com>
> Cc: Christoph Hellwig <hch@lst.de>
> ---
>  block/blk-mq-sysfs.c | 15 +++++----------
>  block/blk-mq.c       | 12 +++++++-----
>  2 files changed, 12 insertions(+), 15 deletions(-)
>
> diff --git a/block/blk-mq-sysfs.c b/block/blk-mq-sysfs.c
> index 6774a0e..921f7cf 100644
> --- a/block/blk-mq-sysfs.c
> +++ b/block/blk-mq-sysfs.c
> @@ -19,6 +19,8 @@ static void blk_mq_sysfs_release(struct kobject *kobj)
>
>         q = container_of(kobj, struct request_queue, mq_kobj);
>         free_percpu(q->queue_ctx);
> +       kfree(q->queue_hw_ctx);
> +       q->queue_hw_ctx = NULL;
>  }
>
>  static void blk_mq_ctx_release(struct kobject *kobj)
> @@ -34,6 +36,7 @@ static void blk_mq_hctx_release(struct kobject *kobj)
>         struct blk_mq_hw_ctx *hctx;
>
>         hctx = container_of(kobj, struct blk_mq_hw_ctx, kobj);
> +       kfree(hctx->ctxs);
>         kfree(hctx);
>  }
>
> @@ -388,21 +391,13 @@ void blk_mq_unregister_disk(struct gendisk *disk)
>  {
>         struct request_queue *q = disk->queue;
>         struct blk_mq_hw_ctx *hctx;
> -       struct blk_mq_ctx *ctx;
> -       int i, j;
> +       int i;
>
> -       queue_for_each_hw_ctx(q, hctx, i) {
> +       queue_for_each_hw_ctx(q, hctx, i)
>                 blk_mq_unregister_hctx(hctx);
>
> -               hctx_for_each_ctx(hctx, ctx, j)
> -                       kobject_put(&ctx->kobj);
> -
> -               kobject_put(&hctx->kobj);
> -       }
> -
>         kobject_uevent(&q->mq_kobj, KOBJ_REMOVE);
>         kobject_del(&q->mq_kobj);
> -       kobject_put(&q->mq_kobj);
>
>         kobject_put(&disk_to_dev(disk)->kobj);
>  }
> diff --git a/block/blk-mq.c b/block/blk-mq.c
> index 9ee3b87..6d007a4 100644
> --- a/block/blk-mq.c
> +++ b/block/blk-mq.c
> @@ -1604,7 +1604,8 @@ static void blk_mq_exit_hctx(struct request_queue *q,
>                 struct blk_mq_tag_set *set,
>                 struct blk_mq_hw_ctx *hctx, unsigned int hctx_idx)
>  {
> -       unsigned flush_start_tag = set->queue_depth;
> +       struct blk_mq_ctx *ctx;
> +       unsigned j, flush_start_tag = set->queue_depth;
>
>         blk_mq_tag_idle(hctx);
>
> @@ -1618,8 +1619,10 @@ static void blk_mq_exit_hctx(struct request_queue *q,
>
>         blk_mq_unregister_cpu_notifier(&hctx->cpu_notifier);
>         blk_free_flush_queue(hctx->fq);
> -       kfree(hctx->ctxs);
>         blk_mq_free_bitmap(&hctx->ctx_map);
> +       hctx_for_each_ctx(hctx, ctx, j)
> +               kobject_put(&ctx->kobj);
> +       kobject_put(&hctx->kobj);
>  }
>
>  static void blk_mq_exit_hw_queues(struct request_queue *q,
> @@ -2000,10 +2003,9 @@ void blk_mq_free_queue(struct request_queue *q)
>
>         percpu_ref_exit(&q->mq_usage_counter);
>
> -       kfree(q->queue_hw_ctx);
> -       kfree(q->mq_map);
> +       kobject_put(&q->mq_kobj);
>
> -       q->queue_hw_ctx = NULL;
> +       kfree(q->mq_map);
>         q->mq_map = NULL;
>
>         mutex_lock(&all_q_mutex);
> --
> 2.1.2
>
