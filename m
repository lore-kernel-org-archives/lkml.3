Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756928AbaFSKKa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jun 2014 06:10:30 -0400
Received: from mail-ve0-f181.google.com ([209.85.128.181]:40442 "EHLO
	mail-ve0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752125AbaFSKK3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jun 2014 06:10:29 -0400
MIME-Version: 1.0
In-Reply-To: <1403104872-22236-2-git-send-email-tj@kernel.org>
References: <1403104872-22236-1-git-send-email-tj@kernel.org>
	<1403104872-22236-2-git-send-email-tj@kernel.org>
Date: Thu, 19 Jun 2014 18:10:28 +0800
Message-ID: <CACVXFVMhkKgvzXO7QnXRup3wqy2Bom-iPWVQoe_EGZkSMcneag@mail.gmail.com>
Subject: Re: [PATCH 1/6] blk-mq: make blk_mq_stop_hw_queue() reliably block
 queue processing
From: Ming Lei <tom.leiming@gmail.com>
To: Tejun Heo <tj@kernel.org>
Cc: Jens Axboe <axboe@kernel.dk>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Kent Overstreet <kmo@daterainc.com>,
        "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 18, 2014 at 11:21 PM, Tejun Heo <tj@kernel.org> wrote:
> blk_mq_stop_hw_queue() has the following two issues.
>
> * BLK_MQ_S_STOPPED should be set before canceling the work items;
>   otherwise, a new instance may proceed beyond STOPPED checking
>   inbetween.
>
> * cancel_delayed_work() doesn't do anything to work instance already
>   executing.  Use cancel_delayed_work_sync() to ensure that the
>   currently in-flight one is finished.
>
> Signed-off-by: Tejun Heo <tj@kernel.org>
> Cc: Jens Axboe <axboe@kernel.dk>
> Cc: Nicholas A. Bellinger <nab@linux-iscsi.org>
> ---
>  block/blk-mq.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
>
> diff --git a/block/blk-mq.c b/block/blk-mq.c
> index e11f5f8..4787c3d 100644
> --- a/block/blk-mq.c
> +++ b/block/blk-mq.c
> @@ -862,9 +862,9 @@ EXPORT_SYMBOL(blk_mq_run_queues);
>
>  void blk_mq_stop_hw_queue(struct blk_mq_hw_ctx *hctx)
>  {
> -       cancel_delayed_work(&hctx->run_work);
> -       cancel_delayed_work(&hctx->delay_work);
>         set_bit(BLK_MQ_S_STOPPED, &hctx->state);
> +       cancel_delayed_work_sync(&hctx->run_work);
> +       cancel_delayed_work_sync(&hctx->delay_work);

The function can be called from atomic context, like virtio-blk.

Currently blk_mq_stop_hw_queue() is called in case of queue
being busy, so looks it is ok with cancel_delayed_work().


Thanks,
-- 
Ming Lei
