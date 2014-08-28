Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965025AbaH1CG2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Aug 2014 22:06:28 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:46924 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933884AbaH1CG0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Aug 2014 22:06:26 -0400
MIME-Version: 1.0
In-Reply-To: <53FE029B.1030200@parallels.com>
References: <1408031441-31156-1-git-send-email-ming.lei@canonical.com>
	<1408031441-31156-6-git-send-email-ming.lei@canonical.com>
	<20140815163111.GA16652@infradead.org>
	<53EE370D.1060106@kernel.dk>
	<53EE3966.60609@kernel.dk>
	<CACVXFVO+3SHy0=zESJqG3ZB68AZaeK5_QK2CVmZWzZ7oBWDGwg@mail.gmail.com>
	<53F0EAEC.9040505@kernel.dk>
	<CACVXFVO3CrD2CoHiBOZ8GNMXrT2pJ=t2BzmAHksqRTmgrpsaaQ@mail.gmail.com>
	<CACVXFVN6W-AAQ6g4LXHOyvMzU+EAmj_YYBEuYRnoSB+VqCJg8A@mail.gmail.com>
	<53F3B89D.6070703@kernel.dk>
	<CACVXFVOR0mzMWo+iPtU8jUvYgH+non=hQ0XaP0Z1Fu0qiSbJNA@mail.gmail.com>
	<53FE029B.1030200@parallels.com>
Date: Thu, 28 Aug 2014 10:06:23 +0800
Message-ID: <CACVXFVOx6n88kFhCk60YOfVa22qw1B3Gs0+Mj_ng2T5zy1Wb3A@mail.gmail.com>
Subject: Re: [PATCH v1 5/9] block: loop: convert to blk-mq
From: Ming Lei <ming.lei@canonical.com>
To: Maxim Patlasov <mpatlasov@parallels.com>
Cc: Jens Axboe <axboe@kernel.dk>, Christoph Hellwig <hch@infradead.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Dave Kleikamp <dave.kleikamp@oracle.com>, Zach Brown <zab@zabbo.net>,
        Benjamin LaHaise <bcrl@kvack.org>, Kent Overstreet <kmo@daterainc.com>,
        AIO <linux-aio@kvack.org>,
        Linux FS Devel <linux-fsdevel@vger.kernel.org>,
        Dave Chinner <david@fromorbit.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 8/28/14, Maxim Patlasov <mpatlasov@parallels.com> wrote:
> On 08/21/2014 09:44 AM, Ming Lei wrote:
>> On Wed, Aug 20, 2014 at 4:50 AM, Jens Axboe <axboe@kernel.dk> wrote:
>>
>>>
>>> Reworked a bit more:
>>>
>>> http://git.kernel.dk/?p=linux-block.git;a=commit;h=a323185a761b9a54dc340d383695b4205ea258b6
>> One big problem of the commit is that it is basically a serialized
>> workqueue
>> because of single &hctx->run_work, and per-req work_struct has to be
>> used for concurrent implementation.  So looks the approach isn't flexible
>> enough compared with doing that in driver, or any idea about how to fix
>> that?
>>
>
> I'm interested what's the price of handling requests in a separate
> thread at large. I used the following fio script:
>
>      [global]
>      direct=1
>      bsrange=512-512
>      timeout=10
>      numjobs=1
>      ioengine=sync
>
>      filename=/dev/loop0 # or /dev/nullb0
>
>      [f1]
>      rw=randwrite
>
> to compare the performance of:
>
> 1) /dev/loop0 of 3.17.0-rc1 with Ming's patches applied -- 11K iops

If you enable BLK_MQ_F_WQ_CONTEXT, it isn't strange to see this
result since blk-mq implements a serialized workqueue.

> 2) the same as above, but call loop_queue_work() directly from
> loop_queue_rq() -- 270K iops
> 3) /dev/nullb0 of 3.17.0-rc1 -- 380K iops

In my recent investigation and discussion with Jens, using workqueue
may introduce some regression for cases like loop over null_blk, tmpfs.

And 270K vs. 380K is a bit similar with my result, and it was observed that
context switch is increased by more than 50% with introducing workqueue.

I will post V3 which will use previous kthread, with blk-mq & kernel aio, which
should make full use of blk-mq and kernel aio, and won't introduce regression
for cases like above.

> Taking into account so big difference (11K vs. 270K), would it be worthy
> to implement pure non-blocking version of aio_kernel_submit() returning
> error if blocking needed? Then loop driver (or any other in-kernel user)

The kernel aio submit is very similar with user space's implementation,
except for block plug&unplug usage in user space aio submit path.

If it is blocked in aio_kernel_submit(), you should observe similar thing
with io_submit() too.

Thanks,
-- 
Ming Lei
