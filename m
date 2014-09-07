Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752578AbaIGLit (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Sep 2014 07:38:49 -0400
Received: from mx1.redhat.com ([209.132.183.28]:60019 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751423AbaIGLir (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Sep 2014 07:38:47 -0400
Date: Sun, 7 Sep 2014 14:41:53 +0300
From: "Michael S. Tsirkin" <mst@redhat.com>
To: Christoph Hellwig <hch@lst.de>
Cc: Rusty Russell <rusty@rustcorp.com.au>, Jens Axboe <axboe@kernel.dk>,
        linux-kernel@vger.kernel.org,
        virtualization@lists.linux-foundation.org
Subject: Re: [PATCH] virtio_blk: merge S/G list entries by default
Message-ID: <20140907114153.GB26569@redhat.com>
References: <1410044994-14943-1-git-send-email-hch@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1410044994-14943-1-git-send-email-hch@lst.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Sep 06, 2014 at 04:09:54PM -0700, Christoph Hellwig wrote:
> Most virtio setups have a fairly limited number of ring entries available.

Seems a bit vague: QEMU at least has pretty large queues.
Which hypervisor do you have in mind?
This could be a gain everywhere if you manage to make descriptors
completely linear, so they fit in a single s/g.
ATM __virtblk_add_req always adds an s/g for the header:
is there a chance linux can pre-allocate a bit of memory
in front of the buffer to stick the header in?

> Enable S/G entry merging by default to fit into less of them.  This restores
> the behavior at time of the virtio-blk blk-mq conversion, which was changed
> by commit "block: add queue flag for disabling SG merging" which made the
> behavior optional, but didn't update the existing drivers to keep their
> previous behavior.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

OK so this is an optimization patch right?
What kind of performance gain is observed with it?

> ---
>  drivers/block/virtio_blk.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/block/virtio_blk.c b/drivers/block/virtio_blk.c
> index 0a58140..311b857 100644
> --- a/drivers/block/virtio_blk.c
> +++ b/drivers/block/virtio_blk.c
> @@ -634,7 +634,7 @@ static int virtblk_probe(struct virtio_device *vdev)
>  	vblk->tag_set.ops = &virtio_mq_ops;
>  	vblk->tag_set.queue_depth = virtblk_queue_depth;
>  	vblk->tag_set.numa_node = NUMA_NO_NODE;
> -	vblk->tag_set.flags = BLK_MQ_F_SHOULD_MERGE;
> +	vblk->tag_set.flags = BLK_MQ_F_SHOULD_MERGE | BLK_MQ_F_SG_MERGE;
>  	vblk->tag_set.cmd_size =
>  		sizeof(struct virtblk_req) +
>  		sizeof(struct scatterlist) * sg_elems;
> -- 
> 1.9.1
