Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751608AbaBAIGq (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Feb 2014 03:06:46 -0500
Received: from ozlabs.org ([203.10.76.45]:52884 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751283AbaBAIGJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Feb 2014 03:06:09 -0500
From: Rusty Russell <rusty@rustcorp.com.au>
To: Heinz Graalfs <graalfs@linux.vnet.ibm.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/6] virtio_blk: don't crash, report error if virtqueue is broken.
In-Reply-To: <52EA16CD.7070807@linux.vnet.ibm.com>
References: <1389753371-26469-1-git-send-email-rusty@rustcorp.com.au> <1389753371-26469-2-git-send-email-rusty@rustcorp.com.au> <52EA16CD.7070807@linux.vnet.ibm.com>
User-Agent: Notmuch/0.15.2 (http://notmuchmail.org) Emacs/23.4.1 (x86_64-pc-linux-gnu)
Date: Fri, 31 Jan 2014 15:30:26 +1030
Message-ID: <871tzowxsl.fsf@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Heinz Graalfs <graalfs@linux.vnet.ibm.com> writes:
> On 15/01/14 03:36, Rusty Russell wrote:
>> A bad implementation of virtio might cause us to mark the virtqueue
>> broken: we'll dev_err() in that case, and the device is useless, but
>> let's not BUG_ON().
>>
>> ENOMEM or ENOSPC implies the ring is full, and we should try again
>> later (-ENOMEM is documented to happen, but doesn't, as we fall
>> through to ENOSPC).
>>
>> EIO means it's broken.
>>
>> Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
>> ---
>>   drivers/block/virtio_blk.c | 10 ++++++++--
>>   1 file changed, 8 insertions(+), 2 deletions(-)
>>
>> diff --git a/drivers/block/virtio_blk.c b/drivers/block/virtio_blk.c
>> index 6a680d4de7f1..704d6c814c17 100644
>> --- a/drivers/block/virtio_blk.c
>> +++ b/drivers/block/virtio_blk.c
>> @@ -158,6 +158,7 @@ static int virtio_queue_rq(struct blk_mq_hw_ctx *hctx, struct request *req)
>>   	unsigned long flags;
>>   	unsigned int num;
>>   	const bool last = (req->cmd_flags & REQ_END) != 0;
>> +	int err;
>>
>>   	BUG_ON(req->nr_phys_segments + 2 > vblk->sg_elems);
>>
>> @@ -198,11 +199,16 @@ static int virtio_queue_rq(struct blk_mq_hw_ctx *hctx, struct request *req)
>>   	}
>>
>>   	spin_lock_irqsave(&vblk->vq_lock, flags);
>> -	if (__virtblk_add_req(vblk->vq, vbr, vbr->sg, num) < 0) {
>> +	err = __virtblk_add_req(vblk->vq, vbr, vbr->sg, num);
>> +	if (err) {
>>   		virtqueue_kick(vblk->vq);
>
> the kick might fail here after a request was successfully added.

It could, but it we're already in the error path, so we can't do
anything about it.

>>   		spin_unlock_irqrestore(&vblk->vq_lock, flags);
>>   		blk_mq_stop_hw_queue(hctx);
>> -		return BLK_MQ_RQ_QUEUE_BUSY;
>> +		/* Out of mem doesn't actually happen, since we fall back
>> +		 * to direct descriptors */
>> +		if (err == -ENOMEM || err == -ENOSPC)
>> +			return BLK_MQ_RQ_QUEUE_BUSY;
>> +		return BLK_MQ_RQ_QUEUE_ERROR;
>>   	}
>>
>>   	if (last)
>>

Cheers,
Rusty.
