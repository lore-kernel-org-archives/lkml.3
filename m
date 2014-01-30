Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752630AbaA3JJo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Jan 2014 04:09:44 -0500
Received: from e06smtp15.uk.ibm.com ([195.75.94.111]:47586 "EHLO
	e06smtp15.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751027AbaA3JJk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Jan 2014 04:09:40 -0500
Message-ID: <52EA16CD.7070807@linux.vnet.ibm.com>
Date: Thu, 30 Jan 2014 10:09:33 +0100
From: Heinz Graalfs <graalfs@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Rusty Russell <rusty@rustcorp.com.au>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/6] virtio_blk: don't crash, report error if virtqueue
 is broken.
References: <1389753371-26469-1-git-send-email-rusty@rustcorp.com.au> <1389753371-26469-2-git-send-email-rusty@rustcorp.com.au>
In-Reply-To: <1389753371-26469-2-git-send-email-rusty@rustcorp.com.au>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14013009-0342-0000-0000-00000799C9BE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 15/01/14 03:36, Rusty Russell wrote:
> A bad implementation of virtio might cause us to mark the virtqueue
> broken: we'll dev_err() in that case, and the device is useless, but
> let's not BUG_ON().
>
> ENOMEM or ENOSPC implies the ring is full, and we should try again
> later (-ENOMEM is documented to happen, but doesn't, as we fall
> through to ENOSPC).
>
> EIO means it's broken.
>
> Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
> ---
>   drivers/block/virtio_blk.c | 10 ++++++++--
>   1 file changed, 8 insertions(+), 2 deletions(-)
>
> diff --git a/drivers/block/virtio_blk.c b/drivers/block/virtio_blk.c
> index 6a680d4de7f1..704d6c814c17 100644
> --- a/drivers/block/virtio_blk.c
> +++ b/drivers/block/virtio_blk.c
> @@ -158,6 +158,7 @@ static int virtio_queue_rq(struct blk_mq_hw_ctx *hctx, struct request *req)
>   	unsigned long flags;
>   	unsigned int num;
>   	const bool last = (req->cmd_flags & REQ_END) != 0;
> +	int err;
>
>   	BUG_ON(req->nr_phys_segments + 2 > vblk->sg_elems);
>
> @@ -198,11 +199,16 @@ static int virtio_queue_rq(struct blk_mq_hw_ctx *hctx, struct request *req)
>   	}
>
>   	spin_lock_irqsave(&vblk->vq_lock, flags);
> -	if (__virtblk_add_req(vblk->vq, vbr, vbr->sg, num) < 0) {
> +	err = __virtblk_add_req(vblk->vq, vbr, vbr->sg, num);
> +	if (err) {
>   		virtqueue_kick(vblk->vq);

the kick might fail here after a request was successfully added.

>   		spin_unlock_irqrestore(&vblk->vq_lock, flags);
>   		blk_mq_stop_hw_queue(hctx);
> -		return BLK_MQ_RQ_QUEUE_BUSY;
> +		/* Out of mem doesn't actually happen, since we fall back
> +		 * to direct descriptors */
> +		if (err == -ENOMEM || err == -ENOSPC)
> +			return BLK_MQ_RQ_QUEUE_BUSY;
> +		return BLK_MQ_RQ_QUEUE_ERROR;
>   	}
>
>   	if (last)
>

