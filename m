Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753001AbbAMRyH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Jan 2015 12:54:07 -0500
Received: from mx1.redhat.com ([209.132.183.28]:42737 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752157AbbAMRyF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Jan 2015 12:54:05 -0500
Message-ID: <54B55B95.1070402@redhat.com>
Date: Tue, 13 Jan 2015 23:23:25 +0530
From: Pratyush Anand <panand@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.3.0
MIME-Version: 1.0
To: Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <Will.Deacon@arm.com>
CC: Steve Capper <steve.capper@linaro.org>, Oleg Nesterov <oleg@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        David Long <dave.long@linaro.org>, William Cohen <wcohen@redhat.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: Query: ARM64: Behavior of el1_dbg exception while executing el0_dbg
References: <54AE830E.1090000@redhat.com> <20150108162312.GO11583@arm.com> <54AEBE45.9080203@redhat.com> <20150109154635.GG11258@arm.com> <54B00C39.1070809@redhat.com> <20150112173005.GK13360@arm.com> <54B4BF4C.2030009@redhat.com> <20150113155221.GG16524@e104818-lin.cambridge.arm.com>
In-Reply-To: <20150113155221.GG16524@e104818-lin.cambridge.arm.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Tuesday 13 January 2015 09:22 PM, Catalin Marinas wrote:
> On Tue, Jan 13, 2015 at 06:46:36AM +0000, Pratyush Anand wrote:
>> On Monday 12 January 2015 11:00 PM, Will Deacon wrote:
>>> On Fri, Jan 09, 2015 at 05:13:29PM +0000, Pratyush Anand wrote:
>>>> On Friday 09 January 2015 09:16 PM, Will Deacon wrote:
>>>>> On Thu, Jan 08, 2015 at 05:28:37PM +0000, Pratyush Anand wrote:
>>>>>> On Thursday 08 January 2015 09:53 PM, Will Deacon wrote:
>>>>>>> On Thu, Jan 08, 2015 at 01:15:58PM +0000, Pratyush Anand wrote:
>>>>>>>> I am trying to test following scenario, which seems valid to me. But I
>>>>>>>> am very new to ARM64 as well as to debugging tools, so seeking expert's
>>>>>>>> comment here.
>>>>>>>>
>>>>>>>> -- I have inserted a kprobe to the function uprobe_breakpoint_handler
>>>>>>>> which is called from elo_dbg
>>>>>>>> (el0_dbg->do_debug_exception->brk_handler->call_break_hook->uprobe_breakpoint_handler)
>>>>>>>>
>>>>>>>> -- kprobe is enabled.
>>>>>>>>
>>>>>>>> -- an uprobe is inserted into a test application and enabled.
>>>>>>>>
>>>>>>>> So, when uprobe is enabled and test code execution reaches to probe
>>>>>>>> instruction, it executes uprobe breakpoint instruction and el0_dbg
>>>>>>>> exception is raised.
>>>>>>>>
>>>>>>>> When control reaches to start of uprobe_breakpoint_handler and it
>>>>>>>> executes first instruction (which has been replaced with a kprobe
>>>>>>>> breakpoint instruction), el1_dbg exception is raised.
>>>>>>>
>>>>>>> Hmm, debug exceptions should be masked at this point so I don't see why
>>>>>>> you're taking the second debug exception.
>>>>>>
>>>>>> So, you mean to say that when an exception which has been taken from
>>>>>> lower exception level (EL0) is being executed, then we keep masked also
>>>>>> the exception from current exception level (EL1)...
>>>>>
>>>>> Yeah, if you look at entry.S then you'll see that neither el0_dbg or el1_dbg
>>>>> re-enable debug exceptions (masked automatically by the CPU after taking the
>>>>> exception) until *after* the handling has completed. This is to prevent
>>>>> recursive debug exceptions, which I don't see how we can reasonable handle.
>>>>
>>>> May be I am missing something, but my observation on silicon is
>>>> different. Please have a look at git log of HEAD of following branch,
>>>> which says that el1_dbg exception has been raised while el0_dbg was
>>>> executing. Do not know what I am missing..
> [...]
>>> Regardless, I think you need to debug further and found out if PSTATE.D is
>>> getting cleared and, if so, who is responsible for that. Somebody could be
>>> enabling IRQs, for example, which will then unmask debug exceptions in
>>> el1_irq.
>>
>> This is what I see for pstate, When el0_dbg exception is raised (ie an
>> exception raised with ESR = ESR_EL1_EC_BRK64 after executing instruction
>> BRK64_OPCODE_UPROBES = 0xD4200100 in EL0, user mode), spsr_el1 value is
>> 0x80000000. Which means, all exceptions are unmasked. Is it expected?
>
> spsr_el1 is the EL0 pstate saved when entering EL1. So it is expected
> that user space always has interrupts enabled.
>

Yes, I was wrong :(
By the way, is there a way to read cpsr or current PSTATE.D?

That would help me to know if PSTATE.D was unmasked just before 
executing BRK64_OPCODE_UPROBES. Actually, print in enable_dbg macro give 
me other issues and does not allow system to boot.

I will still try to find some way to capture enable_dbg macro 
path.However, if I just examine the code flow then I do not see a 
situation where enable_dbg could have been called after receiving 
el0_dbg.(or other than enable_dbg is there some other path too which can 
re-enable debug exception??)

-- Application executes  BRK64_OPCODE_UPROBES.
-- el0_sync is raised.
-- el0_sync
	-> kernel_entry 0
	-> el0_dbg
		-> do_debug_exception
			->brk_handler
				->call_break_hook
					->uprobe_breakpoint_handler

None of the above path seems calling enable_dbg, then how do we receive 
el1_sync when first instruction of uprobe_breakpoint_handler (which has 
been replaced with BRK64_OPCODE_KPROBES) is executed?

~Pratyush

