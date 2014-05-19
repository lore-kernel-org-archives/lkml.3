Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752500AbaESA0R (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 May 2014 20:26:17 -0400
Received: from mail-vc0-f171.google.com ([209.85.220.171]:55911 "EHLO
	mail-vc0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752152AbaESA0L (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 May 2014 20:26:11 -0400
MIME-Version: 1.0
In-Reply-To: <8761l6lbzi.fsf@rustcorp.com.au>
References: <1400157181-17800-1-git-send-email-tom.leiming@gmail.com>
	<8761l6lbzi.fsf@rustcorp.com.au>
Date: Mon, 19 May 2014 08:26:10 +0800
Message-ID: <CACVXFVNnQmJ6J3U4xTmKbBQfuYQBxXA4djNL_s7dD3jC1CGhhg@mail.gmail.com>
Subject: Re: [PATCH] virtio_blk: fix race between start and stop queue
From: Ming Lei <tom.leiming@gmail.com>
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: Jens Axboe <axboe@kernel.dk>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 16, 2014 at 9:59 AM, Rusty Russell <rusty@rustcorp.com.au> wrote:
> Ming Lei <tom.leiming@gmail.com> writes:
>> When there isn't enough vring descriptor for adding to vq,
>> blk-mq will be put as stopped state until some of pending
>> descriptors are completed & freed.
>>
>> Unfortunately, the vq's interrupt may come just before
>> blk-mq's BLK_MQ_S_STOPPED flag is set, so the blk-mq will
>> still be kept as stopped even though lots of descriptors
>> are completed and freed in the interrupt handler. The worst
>> case is that all pending descriptors are freed in the
>> interrupt handler, and the queue is kept as stopped forever.
>>
>> This patch fixes the problem by starting/stopping blk-mq
>> with holding vq_lock.
>
> OK, but why the flag?  Isn't moving the
>         blk_mq_start_stopped_hw_queues(vblk->disk->queue, true);
>
> inside the lock sufficient?

The flag has been removed in v1. I introduced the flag just for
avoiding unnecessary calling blk_mq_start_stopped_hw_queues()
at most of time, but it isn't a big deal.

Thanks,
-- 
Ming Lei
