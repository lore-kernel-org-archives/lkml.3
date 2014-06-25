Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754888AbaFYBvp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jun 2014 21:51:45 -0400
Received: from mail-ve0-f180.google.com ([209.85.128.180]:46216 "EHLO
	mail-ve0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752271AbaFYBvo convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jun 2014 21:51:44 -0400
MIME-Version: 1.0
In-Reply-To: <1403651531-24891-2-git-send-email-m@bjorling.me>
References: <1403651531-24891-1-git-send-email-m@bjorling.me>
	<1403651531-24891-2-git-send-email-m@bjorling.me>
Date: Wed, 25 Jun 2014 09:51:43 +0800
Message-ID: <CACVXFVPHQXZoBGGpivjEX15_UfvZHoVYLDUwYeyhjffkJss53A@mail.gmail.com>
Subject: Re: [PATCH v9] NVMe: Convert to blk-mq
From: Ming Lei <tom.leiming@gmail.com>
To: =?UTF-8?Q?Matias_Bj=C3=B8rling?= <m@bjorling.me>
Cc: Matthew Wilcox <willy@linux.intel.com>,
        Keith Busch <keith.busch@intel.com>,
        "Sam Bradshaw (sbradshaw)" <sbradshaw@micron.com>,
        Jens Axboe <axboe@fb.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-nvme <linux-nvme@lists.infradead.org>,
        Christoph Hellwig <hch@infradead.org>, rlnelson@google.com
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 25, 2014 at 7:12 AM, Matias Bjørling <m@bjorling.me> wrote:
> This converts the current NVMe driver to utilize the blk-mq layer.
>
> Contributions in this patch from:
>
>   Sam Bradshaw <sbradshaw@micron.com>
>   Jens Axboe <axboe@kernel.dk>
>   Keith Busch <keith.busch@intel.com>
>   Christoph Hellwig <hch@infradead.org>
>   Robert Nelson <rlnelson@google.com>
>
> Acked-by: Keith Busch <keith.busch@intel.com>
> Acked-by: Jens Axboe <axboe@fb.com>
> Signed-off-by: Matias Bjørling <m@bjorling.me>
> ---
>  drivers/block/nvme-core.c | 1204 ++++++++++++++++++---------------------------
>  drivers/block/nvme-scsi.c |    8 +-
>  include/linux/nvme.h      |   15 +-
>  3 files changed, 489 insertions(+), 738 deletions(-)
>
> diff --git a/drivers/block/nvme-core.c b/drivers/block/nvme-core.c
> index 6e8ce4f..ecbf5dd 100644
> --- a/drivers/block/nvme-core.c
> +++ b/drivers/block/nvme-core.c

> -static void bio_completion(struct nvme_queue *nvmeq, void *ctx,
> +static void req_completion(struct nvme_queue *nvmeq, void *ctx,
>                                                 struct nvme_completion *cqe)
>  {
>         struct nvme_iod *iod = ctx;
> -       struct bio *bio = iod->private;
> +       struct request *req = iod->private;
> +       struct nvme_cmd_info *cmd_rq = blk_mq_rq_to_pdu(req);
> +
>         u16 status = le16_to_cpup(&cqe->status) >> 1;
> -       int error = 0;
>
>         if (unlikely(status)) {
> -               if (!(status & NVME_SC_DNR ||
> -                               bio->bi_rw & REQ_FAILFAST_MASK) &&
> -                               (jiffies - iod->start_time) < IOD_TIMEOUT) {
> -                       if (!waitqueue_active(&nvmeq->sq_full))
> -                               add_wait_queue(&nvmeq->sq_full,
> -                                                       &nvmeq->sq_cong_wait);
> -                       list_add_tail(&iod->node, &nvmeq->iod_bio);
> -                       wake_up(&nvmeq->sq_full);
> +               if (!(status & NVME_SC_DNR || blk_noretry_request(req))
> +                   && (jiffies - req->start_time) < req->timeout) {
> +                       blk_mq_requeue_request(req);

You need to call blk_mq_kick_requeue_list() following
blk_mq_requeue_request(), otherwise the request won't
be scheduled to hw queue.

Thanks,
--
Ming Lei
