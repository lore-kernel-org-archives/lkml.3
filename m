Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753260AbaH2LOz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Aug 2014 07:14:55 -0400
Received: from relay.parallels.com ([195.214.232.42]:47546 "EHLO
	relay.parallels.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752085AbaH2LOx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Aug 2014 07:14:53 -0400
Message-ID: <540060A5.1030502@parallels.com>
Date: Fri, 29 Aug 2014 15:14:45 +0400
From: Maxim Patlasov <mpatlasov@parallels.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Ming Lei <ming.lei@canonical.com>
CC: Jens Axboe <axboe@kernel.dk>, Christoph Hellwig <hch@infradead.org>,
        "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Dave Kleikamp <dave.kleikamp@oracle.com>, "Zach Brown" <zab@zabbo.net>,
        Benjamin LaHaise <bcrl@kvack.org>, Kent Overstreet <kmo@daterainc.com>,
        AIO <linux-aio@kvack.org>,
        Linux FS Devel <linux-fsdevel@vger.kernel.org>,
        Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH v1 5/9] block: loop: convert to blk-mq
References: <1408031441-31156-1-git-send-email-ming.lei@canonical.com>	<1408031441-31156-6-git-send-email-ming.lei@canonical.com>	<20140815163111.GA16652@infradead.org>	<53EE370D.1060106@kernel.dk>	<53EE3966.60609@kernel.dk>	<CACVXFVO+3SHy0=zESJqG3ZB68AZaeK5_QK2CVmZWzZ7oBWDGwg@mail.gmail.com>	<53F0EAEC.9040505@kernel.dk>	<CACVXFVO3CrD2CoHiBOZ8GNMXrT2pJ=t2BzmAHksqRTmgrpsaaQ@mail.gmail.com>	<CACVXFVN6W-AAQ6g4LXHOyvMzU+EAmj_YYBEuYRnoSB+VqCJg8A@mail.gmail.com>	<53F3B89D.6070703@kernel.dk>	<CACVXFVOR0mzMWo+iPtU8jUvYgH+non=hQ0XaP0Z1Fu0qiSbJNA@mail.gmail.com>	<53FE029B.1030200@parallels.com> <CACVXFVOx6n88kFhCk60YOfVa22qw1B3Gs0+Mj_ng2T5zy1Wb3A@mail.gmail.com>
In-Reply-To: <CACVXFVOx6n88kFhCk60YOfVa22qw1B3Gs0+Mj_ng2T5zy1Wb3A@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.30.22.200]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/28/2014 06:06 AM, Ming Lei wrote:
> On 8/28/14, Maxim Patlasov <mpatlasov@parallels.com> wrote:
>> On 08/21/2014 09:44 AM, Ming Lei wrote:
>>> On Wed, Aug 20, 2014 at 4:50 AM, Jens Axboe <axboe@kernel.dk> wrote:
>>>
>>>> Reworked a bit more:
>>>>
>>>> http://git.kernel.dk/?p=linux-block.git;a=commit;h=a323185a761b9a54dc340d383695b4205ea258b6
>>> One big problem of the commit is that it is basically a serialized
>>> workqueue
>>> because of single &hctx->run_work, and per-req work_struct has to be
>>> used for concurrent implementation.  So looks the approach isn't flexible
>>> enough compared with doing that in driver, or any idea about how to fix
>>> that?
>>>
>> I'm interested what's the price of handling requests in a separate
>> thread at large. I used the following fio script:
>>
>>       [global]
>>       direct=1
>>       bsrange=512-512
>>       timeout=10
>>       numjobs=1
>>       ioengine=sync
>>
>>       filename=/dev/loop0 # or /dev/nullb0
>>
>>       [f1]
>>       rw=randwrite
>>
>> to compare the performance of:
>>
>> 1) /dev/loop0 of 3.17.0-rc1 with Ming's patches applied -- 11K iops
> If you enable BLK_MQ_F_WQ_CONTEXT, it isn't strange to see this
> result since blk-mq implements a serialized workqueue.

BLK_MQ_F_WQ_CONTEXT is not in 3.17.0-rc1, so I couldn't enable it.

>
>> 2) the same as above, but call loop_queue_work() directly from
>> loop_queue_rq() -- 270K iops
>> 3) /dev/nullb0 of 3.17.0-rc1 -- 380K iops
> In my recent investigation and discussion with Jens, using workqueue
> may introduce some regression for cases like loop over null_blk, tmpfs.
>
> And 270K vs. 380K is a bit similar with my result, and it was observed that
> context switch is increased by more than 50% with introducing workqueue.

The figures are similar, but the comparison is not. Both 270K and 380K 
refer to configurations where no extra context switch involved.

>
> I will post V3 which will use previous kthread, with blk-mq & kernel aio, which
> should make full use of blk-mq and kernel aio, and won't introduce regression
> for cases like above.

That would be great!

>
>> Taking into account so big difference (11K vs. 270K), would it be worthy
>> to implement pure non-blocking version of aio_kernel_submit() returning
>> error if blocking needed? Then loop driver (or any other in-kernel user)
> The kernel aio submit is very similar with user space's implementation,
> except for block plug&unplug usage in user space aio submit path.
>
> If it is blocked in aio_kernel_submit(), you should observe similar thing
> with io_submit() too.

Yes, I agree. My point was that there is a room for optimization as my 
experiments demonstrate. The question is whether it's worthy to 
sophisticate kernel aio (and fs-specific code too) for the sake of that 
optimization.

In fact, in a simple case like block fs on top of loopback device on top 
of a file on another block fs, what kernel aio does for loopback driver 
is a subtle way of converting incoming bio-s to outgoing bio-s. In case 
you know where the image file is placed (e.g. by fiemap), such a 
conversion may be done with zero overhead and anything that makes the 
overhead noticeable is suspicious. And it is easy to imagine other 
use-cases when that extra context switch is avoidable.

Thanks,
Maxim
