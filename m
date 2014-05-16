Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757343AbaEPPRN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 May 2014 11:17:13 -0400
Received: from mail-ie0-f180.google.com ([209.85.223.180]:47688 "EHLO
	mail-ie0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755745AbaEPPRL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 May 2014 11:17:11 -0400
Message-ID: <53762BF4.2040701@kernel.dk>
Date: Fri, 16 May 2014 09:17:08 -0600
From: Jens Axboe <axboe@kernel.dk>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
MIME-Version: 1.0
To: Ming Lei <tom.leiming@gmail.com>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Rusty Russell <rusty@rustcorp.com.au>
Subject: Re: [PATCH] virtio_blk: fix race between start and stop queue
References: <1400157181-17800-1-git-send-email-tom.leiming@gmail.com>	<53762662.2050702@kernel.dk>	<5376275F.8030709@kernel.dk> <CACVXFVP8ZT-eSHMmHnZ2Trx63HW+X2qtekpkLW35NWGXWsJ0GQ@mail.gmail.com>
In-Reply-To: <CACVXFVP8ZT-eSHMmHnZ2Trx63HW+X2qtekpkLW35NWGXWsJ0GQ@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2014-05-16 09:15, Ming Lei wrote:
> On Fri, May 16, 2014 at 10:57 PM, Jens Axboe <axboe@kernel.dk> wrote:
>> On 2014-05-16 08:53, Jens Axboe wrote:
>>>
>>> On 2014-05-15 06:33, Ming Lei wrote:
>>>>
>>>> When there isn't enough vring descriptor for adding to vq,
>>>> blk-mq will be put as stopped state until some of pending
>>>> descriptors are completed & freed.
>>>>
>>>> Unfortunately, the vq's interrupt may come just before
>>>> blk-mq's BLK_MQ_S_STOPPED flag is set, so the blk-mq will
>>>> still be kept as stopped even though lots of descriptors
>>>> are completed and freed in the interrupt handler. The worst
>>>> case is that all pending descriptors are freed in the
>>>> interrupt handler, and the queue is kept as stopped forever.
>>>>
>>>> This patch fixes the problem by starting/stopping blk-mq
>>>> with holding vq_lock.
>>>
>>>
>>> Why not just use blk_mq_start_hw_queues()?
>>
>>
>> Or, if you want to maintain current heuristics, just move the start and stop
>> under the vq_lock. That should prevent the race, as far as I can tell. Not
>> sure what that extra queue_stopped would buy you, seems a lot cleaner to
>> just maintain this state exclusively in the queue.
>
> Yes.
>
> But the flag can avoid to call blk_mq_start_stopped_hw_queues()
> unnecessarily, which needn't at most of times.  Considered that
> the interrupt may happen with very high frequency, I suggest to
> introduce the extra flag.

virtio-blk just has one queue, so the flag is at least pointless for 
now. And since the other code stops all of them anyway, I don't see any 
reason not to just rely on that.

-- 
Jens Axboe

