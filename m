Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753612AbaHUDPQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Aug 2014 23:15:16 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:60750 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751779AbaHUDPO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Aug 2014 23:15:14 -0400
MIME-Version: 1.0
In-Reply-To: <CACVXFVNEuEOXphJK5XGbAGRC9tL7iTv=PE_v+Dnw3CReAEkonw@mail.gmail.com>
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
	<CACVXFVP_q2MfZtjPAgXrjMJS2K6H2fTFtAe3ZJXBW83uEovqkQ@mail.gmail.com>
	<53F4C835.7030407@kernel.dk>
	<CACVXFVPxXrYi+m0bC7tEcfvDzhQ=Xnapkd+yGRXbKCktgi3Ofw@mail.gmail.com>
	<53F5605C.2010304@kernel.dk>
	<CACVXFVNEuEOXphJK5XGbAGRC9tL7iTv=PE_v+Dnw3CReAEkonw@mail.gmail.com>
Date: Thu, 21 Aug 2014 11:15:12 +0800
Message-ID: <CACVXFVPBLvSbDRPtAYAq_+bR-hfxFL_WPgxWZrywr2wQMD=rjA@mail.gmail.com>
Subject: Re: [PATCH v1 5/9] block: loop: convert to blk-mq
From: Ming Lei <ming.lei@canonical.com>
To: Jens Axboe <axboe@kernel.dk>
Cc: Christoph Hellwig <hch@infradead.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Dave Kleikamp <dave.kleikamp@oracle.com>, Zach Brown <zab@zabbo.net>,
        Benjamin LaHaise <bcrl@kvack.org>, Kent Overstreet <kmo@daterainc.com>,
        "open list:AIO <linux-aio@kvack.org>, Linux FS Devel
	<linux-fsdevel@vger.kernel.org>, Dave Chinner <david@fromorbit.com>,
	Tejun Heo" <tj@kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 21, 2014 at 11:13 AM, Ming Lei <ming.lei@canonical.com> wrote:
> On Thu, Aug 21, 2014 at 10:58 AM, Jens Axboe <axboe@kernel.dk> wrote:
>> On 2014-08-20 21:54, Ming Lei wrote:
>>>>>
>>>>>   From my investigation, context switch increases almost 50% with
>>>>> workqueue compared with kthread in loop in a quad-core VM. With
>>>>> kthread, requests may be handled as batch in cases which won't be
>>>>> blocked in read()/write()(like null_blk, tmpfs, ...), but it is
>>>>> impossible
>>>>> with
>>>>> workqueue any more.  Also block plug&unplug should have been used
>>>>> with kthread to optimize the case, especially when kernel AIO is
>>>>> applied,
>>>>> still impossible with work queue too.
>>>>
>>>>
>>>>
>>>> OK, that one is actually a good point, since one need not do per-item
>>>> queueing. We could handle different units, though. And we should have
>>>> proper
>>>> marking of the last item in a chain of stuff, so we might even be able to
>>>> offload based on that instead of doing single items. It wont help the
>>>> sync
>>>> case, but for that, workqueue and kthread would be identical.
>>>
>>>
>>> We may do that by introducing callback of queue_rq_list in blk_mq_ops,
>>> and I will figure out one patch today to see if it can help the case.
>>
>>
>> I don't think we should add to the interface, I prefer keeping it clean like
>> it is right now. At least not if we can get around it. My point is that the
>> driver already knows when the chain is complete, when REQ_LAST is set. So
>> before that event triggers, it need not kick off IO, or at least i could do
>> it in batches before that. That may not be fully reliable in case of
>> queueing errors, but if REQ_LAST or 'error return' is used as the way to
>> kick off pending IO, then that should be good enough. Haven't audited this
>> in a while, but at least that is the intent of REQ_LAST.
>
> Yes, I thought of too, but driver need another context for handling that,
> either workqueue or kthread, which may cause the introduced per-device
> workqueue useless.

Hmmm, a list should be enough, will do that.

Thanks,
