Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757898AbbAIROK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Jan 2015 12:14:10 -0500
Received: from mx1.redhat.com ([209.132.183.28]:36417 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751761AbbAIROG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Jan 2015 12:14:06 -0500
Message-ID: <54B00C39.1070809@redhat.com>
Date: Fri, 09 Jan 2015 22:43:29 +0530
From: Pratyush Anand <panand@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.3.0
MIME-Version: 1.0
To: Will Deacon <will.deacon@arm.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
CC: William Cohen <wcohen@redhat.com>, Steve Capper <steve.capper@linaro.org>,
        David Long <dave.long@linaro.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Oleg Nesterov <oleg@redhat.com>
Subject: Re: Query: ARM64: Behavior of el1_dbg exception while executing el0_dbg
References: <54AE830E.1090000@redhat.com> <20150108162312.GO11583@arm.com> <54AEBE45.9080203@redhat.com> <20150109154635.GG11258@arm.com>
In-Reply-To: <20150109154635.GG11258@arm.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Friday 09 January 2015 09:16 PM, Will Deacon wrote:
> On Thu, Jan 08, 2015 at 05:28:37PM +0000, Pratyush Anand wrote:
>> On Thursday 08 January 2015 09:53 PM, Will Deacon wrote:
>>> On Thu, Jan 08, 2015 at 01:15:58PM +0000, Pratyush Anand wrote:
>>>> I am trying to test following scenario, which seems valid to me. But I
>>>> am very new to ARM64 as well as to debugging tools, so seeking expert's
>>>> comment here.
>>>>
>>>> -- I have inserted a kprobe to the function uprobe_breakpoint_handler
>>>> which is called from elo_dbg
>>>> (el0_dbg->do_debug_exception->brk_handler->call_break_hook->uprobe_breakpoint_handler)
>>>>
>>>> -- kprobe is enabled.
>>>>
>>>> -- an uprobe is inserted into a test application and enabled.
>>>>
>>>> So, when uprobe is enabled and test code execution reaches to probe
>>>> instruction, it executes uprobe breakpoint instruction and el0_dbg
>>>> exception is raised.
>>>>
>>>> When control reaches to start of uprobe_breakpoint_handler and it
>>>> executes first instruction (which has been replaced with a kprobe
>>>> breakpoint instruction), el1_dbg exception is raised.
>>>
>>> Hmm, debug exceptions should be masked at this point so I don't see why
>>> you're taking the second debug exception.
>>>
>>
>> So, you mean to say that when an exception which has been taken from
>> lower exception level (EL0) is being executed, then we keep masked also
>> the exception from current exception level (EL1)...
>
> Yeah, if you look at entry.S then you'll see that neither el0_dbg or el1_dbg
> re-enable debug exceptions (masked automatically by the CPU after taking the
> exception) until *after* the handling has completed. This is to prevent
> recursive debug exceptions, which I don't see how we can reasonable handle.

May be I am missing something, but my observation on silicon is 
different. Please have a look at git log of HEAD of following branch, 
which says that el1_dbg exception has been raised while el0_dbg was 
executing. Do not know what I am missing..

https://github.com/pratyushanand/linux/tree/ml_arm64_uprobe_devel_debug_kprobe_insertion_at_uprobe_breakpoint_handler



>
>> If, so then how to handle it. One way is that I assign a __kprobe
>> qualifier to uprobe_breakpoint_handler and uprobe_single_step_handler,
>> so that an user can not insert a kprobe there. But, that does not seem
>> to be a good idea, because it will only prevent these two functions to
>> be probed. What about the functions which is being called by these
>> functions like uprobe_pre_sstep_notifier & uprobe_post_sstep_notifier
>> which lie in generic kernel code. So, may be we need something in
>> debug-monitor, which handles this situation, no?
>
> I'm not sure how to solve it, but we certainly can't allow debug exceptions
> to trigger on the debug exception handling path. The first thing to do would
> be finding out where they are getting re-enabled.

As of now I will put uprobe_breakpoint_handler and 
uprobe_single_step_handler symbols under NOKPROBE_SYMBOL.

Other than these, we should also put functions like brk_handler, 
do_dbg_exception (all those which comes in debug exception handling 
path) under NOKPROBE_SYMBOL, as they have been done in 
arch/x86/kernel/traps.c

In my opinion uprobe_pre_sstep_notifier and uprobe_post_sstep_notifier 
should also be put under NOKPROBE_SYMBOL. Adding linux-kernel to comment.

~Pratyush
>
> Will
>
