Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751599AbaHRLxe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Aug 2014 07:53:34 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:43840 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750709AbaHRLxc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Aug 2014 07:53:32 -0400
MIME-Version: 1.0
In-Reply-To: <CACVXFVO3CrD2CoHiBOZ8GNMXrT2pJ=t2BzmAHksqRTmgrpsaaQ@mail.gmail.com>
References: <1408031441-31156-1-git-send-email-ming.lei@canonical.com>
	<1408031441-31156-6-git-send-email-ming.lei@canonical.com>
	<20140815163111.GA16652@infradead.org>
	<53EE370D.1060106@kernel.dk>
	<53EE3966.60609@kernel.dk>
	<CACVXFVO+3SHy0=zESJqG3ZB68AZaeK5_QK2CVmZWzZ7oBWDGwg@mail.gmail.com>
	<53F0EAEC.9040505@kernel.dk>
	<CACVXFVO3CrD2CoHiBOZ8GNMXrT2pJ=t2BzmAHksqRTmgrpsaaQ@mail.gmail.com>
Date: Mon, 18 Aug 2014 19:53:29 +0800
Message-ID: <CACVXFVN6W-AAQ6g4LXHOyvMzU+EAmj_YYBEuYRnoSB+VqCJg8A@mail.gmail.com>
Subject: Re: [PATCH v1 5/9] block: loop: convert to blk-mq
From: Ming Lei <ming.lei@canonical.com>
To: Jens Axboe <axboe@kernel.dk>
Cc: Christoph Hellwig <hch@infradead.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Dave Kleikamp <dave.kleikamp@oracle.com>, Zach Brown <zab@zabbo.net>,
        Benjamin LaHaise <bcrl@kvack.org>, Kent Overstreet <kmo@daterainc.com>,
        "open list:AIO" <linux-aio@kvack.org>,
        Linux FS Devel <linux-fsdevel@vger.kernel.org>,
        Dave Chinner <david@fromorbit.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 18, 2014 at 9:22 AM, Ming Lei <ming.lei@canonical.com> wrote:
> On Mon, Aug 18, 2014 at 1:48 AM, Jens Axboe <axboe@kernel.dk> wrote:
>> On 2014-08-16 02:06, Ming Lei wrote:
>>>
>>> On 8/16/14, Jens Axboe <axboe@kernel.dk> wrote:
>>>>
>>>> On 08/15/2014 10:36 AM, Jens Axboe wrote:
>>>>>
>>>>> On 08/15/2014 10:31 AM, Christoph Hellwig wrote:
>>>>>>>
>>>>>>> +static void loop_queue_work(struct work_struct *work)
>>>>>>
>>>>>>
>>>>>> Offloading work straight to a workqueue dosn't make much sense
>>>>>> in the blk-mq model as we'll usually be called from one.  If you
>>>>>> need to avoid the cases where we are called directly a flag for
>>>>>> the blk-mq code to always schedule a workqueue sounds like a much
>>>>>> better plan.
>>>>>
>>>>>
>>>>> That's a good point - would clean up this bit, and be pretty close to a
>>>>> one-liner to support in blk-mq for the drivers that always need blocking
>>>>> context.
>>>>
>>>>
>>>> Something like this should do the trick - totally untested. But with
>>>> that, loop would just need to add BLK_MQ_F_WQ_CONTEXT to it's tag set
>>>> flags and it could always do the work inline from ->queue_rq().
>>>
>>>
>>> I think it is a good idea.
>>>
>>> But for loop, there may be two problems:
>>>
>>> - default max_active for bound workqueue is 256, which means several slow
>>> loop devices might slow down whole block system. With kernel AIO, it won't
>>> be a big deal, but some block/fs may not support direct I/O and still
>>> fallback to
>>> workqueue
>>>
>>> - 6. Guidelines of Documentation/workqueue.txt
>>> If there is dependency among multiple work items used during memory
>>> reclaim, they should be queued to separate wq each with WQ_MEM_RECLAIM.
>>
>>
>> Both are good points. But I think this mainly means that we should support
>> this through a potentially per-dispatch queue workqueue, separate from
>> kblockd. There's no reason blk-mq can't support this with a per-hctx
>> workqueue, for drivers that need it.
>
> Good idea, and per-device workqueue should be enough if
> BLK_MQ_F_WQ_CONTEXT flag is set.

Maybe for most of cases per-device class(driver) workqueue should be
enough since dependency between devices driven by same driver
isn't common, for example, loop over loop is absolutely insane.

I will keep the work queue in loop-mq V2, and it should be easy to switch
to the mechanism once it is ready.

Thanks,
