Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752358AbaIGKc2 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Sep 2014 06:32:28 -0400
Received: from mail-vc0-f176.google.com ([209.85.220.176]:59993 "EHLO
	mail-vc0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751151AbaIGKc1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Sep 2014 06:32:27 -0400
MIME-Version: 1.0
In-Reply-To: <1410044994-14943-1-git-send-email-hch@lst.de>
References: <1410044994-14943-1-git-send-email-hch@lst.de>
Date: Sun, 7 Sep 2014 18:32:26 +0800
Message-ID: <CACVXFVMRqgEh7EFQ0cDEatsqtxsgBrbSQNH9b6UZTsSD+=OWdA@mail.gmail.com>
Subject: Re: [PATCH] virtio_blk: merge S/G list entries by default
From: Ming Lei <tom.leiming@gmail.com>
To: Christoph Hellwig <hch@lst.de>
Cc: Rusty Russell <rusty@rustcorp.com.au>,
        "Michael S. Tsirkin" <mst@redhat.com>, Jens Axboe <axboe@kernel.dk>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux Virtualization <virtualization@lists.linux-foundation.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Sep 7, 2014 at 7:09 AM, Christoph Hellwig <hch@lst.de> wrote:
> Most virtio setups have a fairly limited number of ring entries available.
> Enable S/G entry merging by default to fit into less of them.  This restores
> the behavior at time of the virtio-blk blk-mq conversion, which was changed
> by commit "block: add queue flag for disabling SG merging" which made the
> behavior optional, but didn't update the existing drivers to keep their
> previous behavior.

It is a good idea to disable SG merge for vq incapable of indirect because
there are very limited direct descriptors.

For vq capable of indirect, it should be better to not do SG merge at default
because:

- from hypervisor view, no matter how many segments one req has, all are
submitted to host kernel by one syscall, such as readv/io_submit

- host kernel still need to do the same merge again

>From my test(virtio-blk over null_blk), looks enabling SG merge may cause
throughput a little drop(~3%).

>
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---
>  drivers/block/virtio_blk.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/drivers/block/virtio_blk.c b/drivers/block/virtio_blk.c
> index 0a58140..311b857 100644
> --- a/drivers/block/virtio_blk.c
> +++ b/drivers/block/virtio_blk.c
> @@ -634,7 +634,7 @@ static int virtblk_probe(struct virtio_device *vdev)
>         vblk->tag_set.ops = &virtio_mq_ops;
>         vblk->tag_set.queue_depth = virtblk_queue_depth;
>         vblk->tag_set.numa_node = NUMA_NO_NODE;
> -       vblk->tag_set.flags = BLK_MQ_F_SHOULD_MERGE;
> +       vblk->tag_set.flags = BLK_MQ_F_SHOULD_MERGE | BLK_MQ_F_SG_MERGE;
>         vblk->tag_set.cmd_size =
>                 sizeof(struct virtblk_req) +
>                 sizeof(struct scatterlist) * sg_elems;
> --
> 1.9.1
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/


Thanks,
-- 
Ming Lei
