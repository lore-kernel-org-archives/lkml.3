Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755552AbaICG7G (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Sep 2014 02:59:06 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:56685 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755121AbaICG7E (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Sep 2014 02:59:04 -0400
MIME-Version: 1.0
In-Reply-To: <20140903121902.7a9f5a5a@tom-ThinkPad-T410>
References: <1409670180-17352-1-git-send-email-ming.lei@canonical.com>
	<20140902162146.GA28741@infradead.org>
	<5405EF38.60007@kernel.dk>
	<20140903121902.7a9f5a5a@tom-ThinkPad-T410>
Date: Wed, 3 Sep 2014 14:59:01 +0800
Message-ID: <CACVXFVMTZoMf0yyhn5Hm3HWBqBf-bgS_4ANgEqL7fiZ64LmTWg@mail.gmail.com>
Subject: Re: [PATCH] blk-merge: fix blk_recount_segments
From: Ming Lei <ming.lei@canonical.com>
To: Jens Axboe <axboe@kernel.dk>, Rusty Russell <rusty@rustcorp.com.au>
Cc: Christoph Hellwig <hch@infradead.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Kick In <pierre-andre.morey@canonical.com>,
        Chris J Arges <chris.j.arges@canonical.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 3, 2014 at 12:19 PM, Ming Lei <ming.lei@canonical.com> wrote:
> On Tue, 02 Sep 2014 10:24:24 -0600
> Jens Axboe <axboe@kernel.dk> wrote:
>
>> On 09/02/2014 10:21 AM, Christoph Hellwig wrote:
>> > Btw, one thing we should reconsider is where we set
>> > QUEUE_FLAG_NO_SG_MERGE.  At least for virtio-blk it seems to me that
>> > doing the S/G merge should be a lot cheaper than fanning out into the
>> > indirect descriptors.
>
> Indirect is always considered first no matter SG merge is off or on,
> at least from current virtio-blk implementation.
>
> But it is a good idea to try direct descriptor first, the below simple
> change can improve randread(libaio, O_DIRECT, multi-queue) 7% in my test,
> and 77% transfer starts to use direct descriptor, and almost all transfer
> uses indirect descriptor only in current upstream implementation.
>
> From 8803341503dedab282c15f2801fdb6d7420cea6f Mon Sep 17 00:00:00 2001
> From: Ming Lei <ming.lei@canonical.com>
> Date: Wed, 3 Sep 2014 10:42:32 +0800
> Subject: [PATCH] virtio_ring: use direct descriptor as far as possible
>
> Direct descriptor can avoid one kmalloc() and should have
> better cache utilization, so try to use it if there are enough
> free direct descriptors.
>
> Suggested-by: Christoph Hellwig <hch@lst.de>
> Signed-off-by: Ming Lei <ming.lei@canonical.com>
> ---
>  drivers/virtio/virtio_ring.c |   10 +++++++---
>  1 file changed, 7 insertions(+), 3 deletions(-)
>
> diff --git a/drivers/virtio/virtio_ring.c b/drivers/virtio/virtio_ring.c
> index 4d08f45a..c76b7a4 100644
> --- a/drivers/virtio/virtio_ring.c
> +++ b/drivers/virtio/virtio_ring.c
> @@ -224,9 +224,13 @@ static inline int virtqueue_add(struct virtqueue *_vq,
>
>         total_sg = total_in + total_out;
>
> -       /* If the host supports indirect descriptor tables, and we have multiple
> -        * buffers, then go indirect. FIXME: tune this threshold */
> -       if (vq->indirect && total_sg > 1 && vq->vq.num_free) {
> +       /*
> +        * If the host supports indirect descriptor tables, and we have
> +        * multiple buffers, then go indirect only if free descriptors
> +        * are less than 16.
> +        */
> +       if (vq->indirect && total_sg > 1 && vq->vq.num_free &&
> +                       vq->vq.num_free < 16) {

Oops, the above should have been below:

        if (vq->indirect && total_sg > 1 && vq->vq.num_free &&
                        (vq->vq.num_free < 16 ||
                         (vq->vq.num_free < total_sg))) {


Thanks,
