Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752047AbaHTBXb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Aug 2014 21:23:31 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:53837 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751728AbaHTBX3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Aug 2014 21:23:29 -0400
MIME-Version: 1.0
In-Reply-To: <53F3B89D.6070703@kernel.dk>
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
Date: Wed, 20 Aug 2014 09:23:26 +0800
Message-ID: <CACVXFVP_q2MfZtjPAgXrjMJS2K6H2fTFtAe3ZJXBW83uEovqkQ@mail.gmail.com>
Subject: Re: [PATCH v1 5/9] block: loop: convert to blk-mq
From: Ming Lei <ming.lei@canonical.com>
To: Jens Axboe <axboe@kernel.dk>
Cc: Christoph Hellwig <hch@infradead.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Dave Kleikamp <dave.kleikamp@oracle.com>, Zach Brown <zab@zabbo.net>,
        Benjamin LaHaise <bcrl@kvack.org>, Kent Overstreet <kmo@daterainc.com>,
        "open list:AIO <linux-aio@kvack.org>, Linux FS Devel
	<linux-fsdevel@vger.kernel.org>, Dave Chinner" <david@fromorbit.com>,
        Tejun Heo <tj@kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 20, 2014 at 4:50 AM, Jens Axboe <axboe@kernel.dk> wrote:
> On 2014-08-18 06:53, Ming Lei wrote:
>>
>> On Mon, Aug 18, 2014 at 9:22 AM, Ming Lei <ming.lei@canonical.com> wrote:
>>>
>>> On Mon, Aug 18, 2014 at 1:48 AM, Jens Axboe <axboe@kernel.dk> wrote:
>>>>
>>>> On 2014-08-16 02:06, Ming Lei wrote:
>>>>>
>>>>>
>>>>> On 8/16/14, Jens Axboe <axboe@kernel.dk> wrote:
>>>>>>
>>>>>>
>>>>>> On 08/15/2014 10:36 AM, Jens Axboe wrote:
>>>>>>>
>>>>>>>
>>>>>>> On 08/15/2014 10:31 AM, Christoph Hellwig wrote:
>>>>>>>>>
>>>>>>>>>
>>>>>>>>> +static void loop_queue_work(struct work_struct *work)
>>>>>>>>
>>>>>>>>
>>>>>>>>
>>>>>>>> Offloading work straight to a workqueue dosn't make much sense
>>>>>>>> in the blk-mq model as we'll usually be called from one.  If you
>>>>>>>> need to avoid the cases where we are called directly a flag for
>>>>>>>> the blk-mq code to always schedule a workqueue sounds like a much
>>>>>>>> better plan.
>>>>>>>
>>>>>>>
>>>>>>>
>>>>>>> That's a good point - would clean up this bit, and be pretty close to
>>>>>>> a
>>>>>>> one-liner to support in blk-mq for the drivers that always need
>>>>>>> blocking
>>>>>>> context.
>>>>>>
>>>>>>
>>>>>>
>>>>>> Something like this should do the trick - totally untested. But with
>>>>>> that, loop would just need to add BLK_MQ_F_WQ_CONTEXT to it's tag set
>>>>>> flags and it could always do the work inline from ->queue_rq().
>>>>>
>>>>>
>>>>>
>>>>> I think it is a good idea.
>>>>>
>>>>> But for loop, there may be two problems:
>>>>>
>>>>> - default max_active for bound workqueue is 256, which means several
>>>>> slow
>>>>> loop devices might slow down whole block system. With kernel AIO, it
>>>>> won't
>>>>> be a big deal, but some block/fs may not support direct I/O and still
>>>>> fallback to
>>>>> workqueue
>>>>>
>>>>> - 6. Guidelines of Documentation/workqueue.txt
>>>>> If there is dependency among multiple work items used during memory
>>>>> reclaim, they should be queued to separate wq each with WQ_MEM_RECLAIM.
>>>>
>>>>
>>>>
>>>> Both are good points. But I think this mainly means that we should
>>>> support
>>>> this through a potentially per-dispatch queue workqueue, separate from
>>>> kblockd. There's no reason blk-mq can't support this with a per-hctx
>>>> workqueue, for drivers that need it.
>>>
>>>
>>> Good idea, and per-device workqueue should be enough if
>>> BLK_MQ_F_WQ_CONTEXT flag is set.
>>
>>
>> Maybe for most of cases per-device class(driver) workqueue should be
>> enough since dependency between devices driven by same driver
>> isn't common, for example, loop over loop is absolutely insane.
>
>
> It's insane, but it can happen. And given how cheap it is to do a workqueue,

Workqueue with WQ_MEM_RECLAIM need to create a standalone kthread
for the queue, so at default there will be 8 kthreads created even no one
uses loop at all.  From current implementation the per-device thread is
created only when one file or blk device is attached to the loop device, which
may not be possible when blk-mq supports per-device workqueue.

> I don't see a reason why we should not. Loop over loop might seem nutty, but
> it's not that far out into the realm of nutty things that people end up
> doing.

Another reason I am still not sure if workqueue is good for loop, though I
do really like workqueue for sake of simplicity, :-)

- sequential read becomes a bit slow with workqueue, especially for some
fast block(such as null_blk)

- random read becomes a bit slow too for some fast devices(such as null_blk)
in some environment(It is reproduced in my server, but can't in my laptop) even
it can improve throughout quite much for common devices(HDD., SSD,..)

>From my investigation, context switch increases almost 50% with
workqueue compared with kthread in loop in a quad-core VM. With
kthread, requests may be handled as batch in cases which won't be
blocked in read()/write()(like null_blk, tmpfs, ...), but it is impossible with
workqueue any more.  Also block plug&unplug should have been used
with kthread to optimize the case, especially when kernel AIO is applied,
still impossible with work queue too.

So looks kthread with kernel AIO is still not bad for the blk-mq conversion,
which can improve throughput much too.  Or other ideas?


Thanks

>
>
>> I will keep the work queue in loop-mq V2, and it should be easy to switch
>> to the mechanism once it is ready.
>
>
> Reworked a bit more:
>
> http://git.kernel.dk/?p=linux-block.git;a=commit;h=a323185a761b9a54dc340d383695b4205ea258b6
>
> Lets base loop-mq on the blk-mq workqueues, it would simplify it quite a bit
> and I don't think there's much point in doing v1 and then ripping it out for
> v2. Especially since it isn't queued up for 3.18 yet.
