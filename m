Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753442Ab3DONJZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Apr 2013 09:09:25 -0400
Received: from wolverine02.qualcomm.com ([199.106.114.251]:29560 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750864Ab3DONJW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Apr 2013 09:09:22 -0400
X-IronPort-AV: E=Sophos;i="4.87,476,1363158000"; 
   d="scan'208";a="38541678"
Message-ID: <516BFC00.5050700@codeaurora.org>
Date: Mon, 15 Apr 2013 09:09:20 -0400
From: Christopher Covington <cov@codeaurora.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:14.0) Gecko/20120714 Thunderbird/14.0
MIME-Version: 1.0
To: Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <Will.Deacon@arm.com>
CC: "linux-arm-msm@vger.kernel.org" <linux-arm-msm@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2] arm64: Fix task tracing
References: <20130408153132.GQ17476@mudshark.cambridge.arm.com> <1365510814-21343-1-git-send-email-cov@codeaurora.org> <20130415101159.GA25095@localhost.cambridge.arm.com> <20130415104542.GE9827@mudshark.cambridge.arm.com> <20130415105840.GB29528@arm.com> <20130415114307.GC29528@arm.com>
In-Reply-To: <20130415114307.GC29528@arm.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Catalin,

On 04/15/2013 07:43 AM, Catalin Marinas wrote:
> On Mon, Apr 15, 2013 at 11:58:40AM +0100, Catalin Marinas wrote:
>> On Mon, Apr 15, 2013 at 11:45:42AM +0100, Will Deacon wrote:
>>> On Mon, Apr 15, 2013 at 11:11:59AM +0100, Catalin Marinas wrote:
>>>> On Tue, Apr 09, 2013 at 01:33:34PM +0100, Christopher Covington wrote:
>>>>> For accurate accounting pass contextidr_thread_switch the prev
>>>>> task pointer, since cpu_switch_to has at that point changed the
>>>>> the stack pointer.
>>>>>
>>>>> Signed-off-by: Christopher Covington <cov@codeaurora.org>
>>>>> ---
>>>>>  arch/arm64/kernel/process.c | 2 +-
>>>>>  1 file changed, 1 insertion(+), 1 deletion(-)
>>>>>
>>>>> diff --git a/arch/arm64/kernel/process.c b/arch/arm64/kernel/process.c
>>>>> index 0337cdb..a49b25a 100644
>>>>> --- a/arch/arm64/kernel/process.c
>>>>> +++ b/arch/arm64/kernel/process.c
>>>>> @@ -315,7 +315,7 @@ struct task_struct *__switch_to(struct task_struct *prev,
>>>>>  	/* the actual thread switch */
>>>>>  	last = cpu_switch_to(prev, next);
>>>>>  
>>>>> -	contextidr_thread_switch(next);
>>>>> +	contextidr_thread_switch(prev);
>>>>
>>>> The original code was indeed wrong but using prev isn't any better. For
>>>> a newly created thread, prev is probably 0 (if it's in a register,
>>>> cpu_context has been zeroed by copy_thread()) or some random stack
>>>> value.

<nit>
I have to I disagree with the statement that using prev isn't _any_ better.
Even if there are unhandled cases, from my observations, using prev is
_measurably_ better. On the other hand, I agree that 100% accuracy is essential.
</nit>

>>> Really? If prev is NULL in context_switch(...), the scheduler will implode,
>>> and I can't see where else switch_to is called from.
>>>
>>> Which code path are you thinking of?
>>
>> copy_thread() zeros cpu_context which is used by cpu_switch_to() to load
>> the next saved registers. The switch_to() function sets prev to last as
>> returned by __switch_to(), so this is valid but in __switch_to() we
>> don't have a valid prev (nor next) after cpu_switch_to() for newly
>> created threads.
> 
> Correction - newly created threads return to ret_from_fork rather than
> __switch_to(), which means that we miss the first
> contextidr_thread_switch() call for a new thread. I would vote for
> Christopher's original patch moving the call before cpu_switch_to(). The
> alternative is to define finish_arch_switch() and add the call there. If
> you are primarily tracing user space, it doesn't really matter whether
> the stack was switched or not when we set the contextidr. For kernel
> tracking, it could be a problem as we have the next task with the old
> stack. But the same could be said about the prev task with the new
> stack.

I'm fine with using either of my previous patches (or are there still cases
where the second one is suspected to be wrong?) or rolling a new one using
finish_arch_switch(). Let me know if you all would prefer for me to start on
the latter.

Christopher

-- 
Employee of Qualcomm Innovation Center, Inc.
Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum,
hosted by the Linux Foundation.
