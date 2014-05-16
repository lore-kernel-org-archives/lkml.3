Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754443AbaEPPpa (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 May 2014 11:45:30 -0400
Received: from mail-ig0-f173.google.com ([209.85.213.173]:63811 "EHLO
	mail-ig0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753817AbaEPPp2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 May 2014 11:45:28 -0400
Message-ID: <53763294.7020501@kernel.dk>
Date: Fri, 16 May 2014 09:45:24 -0600
From: Jens Axboe <axboe@kernel.dk>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
MIME-Version: 1.0
To: Ming Lei <tom.leiming@gmail.com>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Rusty Russell <rusty@rustcorp.com.au>
Subject: Re: [PATCH v1] virtio_blk: fix race between start and stop queue
References: <1400254281-11294-1-git-send-email-tom.leiming@gmail.com>	<53762FA5.6040203@kernel.dk> <CACVXFVNki7os1BAS-vARmiGXuWktr_-U5T_6N6f8u_COMp9CLw@mail.gmail.com>
In-Reply-To: <CACVXFVNki7os1BAS-vARmiGXuWktr_-U5T_6N6f8u_COMp9CLw@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2014-05-16 09:43, Ming Lei wrote:
> On Fri, May 16, 2014 at 11:32 PM, Jens Axboe <axboe@kernel.dk> wrote:
>> On 2014-05-16 09:31, Ming Lei wrote:
>>>
>>> When there isn't enough vring descriptor for adding to vq,
>>> blk-mq will be put as stopped state until some of pending
>>> descriptors are completed & freed.
>>>
>>> Unfortunately, the vq's interrupt may come just before
>>> blk-mq's BLK_MQ_S_STOPPED flag is set, so the blk-mq will
>>> still be kept as stopped even though lots of descriptors
>>> are completed and freed in the interrupt handler. The worst
>>> case is that all pending descriptors are freed in the
>>> interrupt handler, and the queue is kept as stopped forever.
>>>
>>> This patch fixes the problem by starting/stopping blk-mq
>>> with holding vq_lock.
>>
>>
>> Thanks, this looks good, I'll apply it for 3.16 (with a stable marker, even
>> if it is an unlikely event).
>
> Thanks.
>
> It shouldn't be very difficult to happen in case of
> non-indirect descriptor, and it is easy to reproduce
> when module parameter of 'virtblk_queue_depth'
> is bigger than vq->num_free for non-indirect case.

I agree, it can definitely be setup so that it would not be hard to 
trigger. But I don't recall seeing any hang bugs since 3.13 was 
released, which would seem to indicate that it doesn't happen a lot in 
the wild with default settings.

-- 
Jens Axboe

