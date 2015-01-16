Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754153AbbAPNrt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Jan 2015 08:47:49 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:54491 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751314AbbAPNrs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Jan 2015 08:47:48 -0500
MIME-Version: 1.0
In-Reply-To: <1421352518-27220-1-git-send-email-sasha.levin@oracle.com>
References: <1421352518-27220-1-git-send-email-sasha.levin@oracle.com>
Date: Fri, 16 Jan 2015 21:47:45 +0800
Message-ID: <CACVXFVPNo1j2SjzvCyUtuoebSHY-be=kN8P_OC8CzTNbeLKPjg@mail.gmail.com>
Subject: Re: [PATCH] blk-mq: free hctx only when the kobject is released
From: Ming Lei <ming.lei@canonical.com>
To: Sasha Levin <sasha.levin@oracle.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Jens Axboe <axboe@kernel.dk>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 16, 2015 at 4:08 AM, Sasha Levin <sasha.levin@oracle.com> wrote:
> When releasing hctx, we do not know that the embedded kobject has been
> released until it's ->release() callback has been called. It is unsafe
> to unconditionally free the underlying memory until the ->release()
> callback has been called since it may cause use-after-free bugs.
>
> In practice, this patch fixes a use-after-free when destroying devices
> (encountered with loop devices, in my case).

Indeed, it is one bug since driver core can access kobject any time
before it is released.

ctx kobjects has the same problem, and that is a bit tricky
because all ctx share one single per-cpu variable which is associated
with request_queue, one idea is to free q->queue_ctx in release
handler of q->mq_kobj, and let ctx kobject hold ref counter of
q->mq_kobj. Could you fix ctx kobject lifetime in this patch too?

>
> Signed-off-by: Sasha Levin <sasha.levin@oracle.com>
> ---
>  block/blk-mq-sysfs.c |   11 ++++++++++-
>  block/blk-mq.c       |    4 +---
>  2 files changed, 11 insertions(+), 4 deletions(-)
>
> diff --git a/block/blk-mq-sysfs.c b/block/blk-mq-sysfs.c
> index 1630a20..83d4bd8 100644
> --- a/block/blk-mq-sysfs.c
> +++ b/block/blk-mq-sysfs.c
> @@ -17,6 +17,15 @@ static void blk_mq_sysfs_release(struct kobject *kobj)
>  {
>  }
>
> +static void blk_mq_hw_sysfs_release(struct kobject *kobj)
> +{
> +       struct blk_mq_hw_ctx *hctx;
> +
> +       hctx = container_of(kobj, struct blk_mq_hw_ctx, kobj);
> +
> +       kfree(hctx);
> +}
> +
>  struct blk_mq_ctx_sysfs_entry {
>         struct attribute attr;
>         ssize_t (*show)(struct blk_mq_ctx *, char *);
> @@ -324,7 +333,7 @@ static struct kobj_type blk_mq_ctx_ktype = {
>  static struct kobj_type blk_mq_hw_ktype = {
>         .sysfs_ops      = &blk_mq_hw_sysfs_ops,
>         .default_attrs  = default_hw_ctx_attrs,
> -       .release        = blk_mq_sysfs_release,
> +       .release        = blk_mq_hw_sysfs_release,
>  };
>
>  static void blk_mq_unregister_hctx(struct blk_mq_hw_ctx *hctx)
> diff --git a/block/blk-mq.c b/block/blk-mq.c
> index 04caf9f..7701eb2 100644
> --- a/block/blk-mq.c
> +++ b/block/blk-mq.c
> @@ -1593,10 +1593,8 @@ static void blk_mq_free_hw_queues(struct request_queue *q,
>         struct blk_mq_hw_ctx *hctx;
>         unsigned int i;
>
> -       queue_for_each_hw_ctx(q, hctx, i) {
> +       queue_for_each_hw_ctx(q, hctx, i)
>                 free_cpumask_var(hctx->cpumask);
> -               kfree(hctx);
> -       }
>  }
>
>  static int blk_mq_init_hctx(struct request_queue *q,
> --
> 1.7.10.4
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
