Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758670AbaGXDIw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jul 2014 23:08:52 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:52724 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758463AbaGXDIv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jul 2014 23:08:51 -0400
MIME-Version: 1.0
In-Reply-To: <1406156130-15575-10-git-send-email-ming.lei@canonical.com>
References: <1406156130-15575-1-git-send-email-ming.lei@canonical.com>
	<1406156130-15575-10-git-send-email-ming.lei@canonical.com>
Date: Thu, 24 Jul 2014 11:08:48 +0800
Message-ID: <CACVXFVMW81TksDkM+cyQnbAcjJd=Vc2u4g0QNAeNbO6ZYQpy=w@mail.gmail.com>
Subject: Re: [PATCH 9/9] block: loop: support to submit I/O via kernel aio based
From: Ming Lei <ming.lei@canonical.com>
To: Jens Axboe <axboe@kernel.dk>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, Zach Brown <zab@zabbo.net>,
        Dave Kleikamp <dave.kleikamp@oracle.com>,
        Benjamin LaHaise <bcrl@kvack.org>, Ming Lei <ming.lei@canonical.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 24, 2014 at 6:55 AM, Ming Lei <ming.lei@canonical.com> wrote:
> Part of the patch is based on Dave's previous post.
>
> It is easy to observe that loop block device thoughput
> can be increased by > 100% in single job randread,
> libaio engine, direct I/O fio test.
>
> Cc: Zach Brown <zab@zabbo.net>
> Cc: Dave Kleikamp <dave.kleikamp@oracle.com>
> Cc: Benjamin LaHaise <bcrl@kvack.org>
> Signed-off-by: Ming Lei <ming.lei@canonical.com>
> ---
>  drivers/block/loop.c      |  128 ++++++++++++++++++++++++++++++++++++++++++---
>  drivers/block/loop.h      |    1 +
>  include/uapi/linux/loop.h |    1 +
>  3 files changed, 122 insertions(+), 8 deletions(-)
>
> diff --git a/drivers/block/loop.c b/drivers/block/loop.c
> index 96a8913..2279d26 100644
> --- a/drivers/block/loop.c
> +++ b/drivers/block/loop.c

> +static int lo_rw_aio(struct loop_device *lo, struct loop_cmd *cmd,
> +                    bool write, loff_t pos)
> +{
> +       struct file *file = lo->lo_backing_file;
> +       struct request *rq = cmd->rq;
> +       struct kiocb *iocb;
> +       unsigned int op, i = 0;
> +       struct iov_iter iter;
> +       struct bio_vec *bvec, bv;
> +       size_t nr_segs = 0;
> +       struct req_iterator r_iter;
> +       int ret = -EIO;
> +
> +       /* how many segments */
> +       rq_for_each_segment(bv, rq, r_iter)
> +               nr_segs++;
> +
> +       iocb = aio_kernel_alloc(GFP_NOIO, nr_segs * sizeof(*bvec));
> +       if (!iocb) {
> +               ret = -ENOMEM;
> +               goto failed;
> +       }
> +
> +       cmd->iocb = iocb;
> +       bvec = (struct bio_vec *)(iocb + 1);
> +       rq_for_each_segment(bv, rq, r_iter)
> +               bvec[i++] = bv;
> +
> +       if (write)
> +               op = IOCB_CMD_WRITE_ITER;
> +       else
> +               op = IOCB_CMD_READ_ITER;
> +
> +       iter.type = ITER_BVEC | (write ? WRITE : 0);
> +       iter.bvec = bvec;
> +       iter.nr_segs = nr_segs;
> +       iter.count = blk_rq_bytes(rq);
> +       iter.iov_offset = 0;
> +
> +       aio_kernel_init_rw(iocb, file, iov_iter_count(&iter), pos,
> +                          lo_rw_aio_complete, (u64)(uintptr_t)cmd);
> +       ret = aio_kernel_submit(iocb, op, &iter);
> +
> +       /*
> +        * use same policy with userspace aio, req may have been
> +        * completed already, so relase it by aio completion.
> +        */
> +       if (ret != -EIOCBQUEUED)
> +               lo_rw_aio_complete((u64)cmd, ret);

The above stuff should have been put inside aio_kernel_submit(),
will do it in V1.

Thanks,
