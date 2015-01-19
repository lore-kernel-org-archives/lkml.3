Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752183AbbASGKu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Jan 2015 01:10:50 -0500
Received: from mx1.redhat.com ([209.132.183.28]:60176 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751221AbbASGKq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Jan 2015 01:10:46 -0500
Message-ID: <54BC9FC0.2080207@redhat.com>
Date: Mon, 19 Jan 2015 11:40:08 +0530
From: Pratyush Anand <panand@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.3.0
MIME-Version: 1.0
To: Will Deacon <will.deacon@arm.com>
CC: Steve Capper <steve.capper@linaro.org>,
        Catalin Marinas <Catalin.Marinas@arm.com>,
        Oleg Nesterov <oleg@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        David Long <dave.long@linaro.org>, William Cohen <wcohen@redhat.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: Query: ARM64: Behavior of el1_dbg exception while executing el0_dbg
References: <20150108162312.GO11583@arm.com> <54AEBE45.9080203@redhat.com> <20150109154635.GG11258@arm.com> <54B00C39.1070809@redhat.com> <20150112173005.GK13360@arm.com> <54B4BF4C.2030009@redhat.com> <20150113155221.GG16524@e104818-lin.cambridge.arm.com> <54B55B95.1070402@redhat.com> <54B7EF3C.8060909@redhat.com> <54B8FD49.2060503@redhat.com> <20150116162244.GA7091@arm.com>
In-Reply-To: <20150116162244.GA7091@arm.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Friday 16 January 2015 09:52 PM, Will Deacon wrote:
> On Fri, Jan 16, 2015 at 12:00:09PM +0000, Pratyush Anand wrote:
>> On Thursday 15 January 2015 10:17 PM, Pratyush Anand wrote:
>>> On Tuesday 13 January 2015 11:23 PM, Pratyush Anand wrote:
>>>> I will still try to find some way to capture enable_dbg macro path.H
>>>
>>> I did instrumented debug tap points at all the location from where
>>> enable_debug macro is called(see attached debug patch). But, I do not
>>> see that, execution reaches to any of those tap points between el0_dbg
>>> and el1_dbg, and tap points debug log also confirms that el1_dbg is
>>> raised before el0_dbg is returned.
>>
>> Probably we all missed this, ARMv8 specs is very clear about it. In
>> section "D2.1 About debug exceptions" it says:
>>
>> Software Breakpoint Instruction exceptions cannot be masked. The PE
>> takes Software Breakpoint Instruction exceptions regardless of both of
>> the following:
>> • The current Exception level.
>> • The current Security state.
>
> Ah, of course, I completely forgot you were using software breakpoints!
>
>> So, reception of el1_dbg while executing el0_dbg seems perfectly normal
>> to me. If you agree then I am back with the original query which I asked
>> in the beginning of the
>> thread,(http://permalink.gmane.org/gmane.linux.ports.arm.kernel/383672)
>> ie how can instruction_pointer be wrong when second el1_dbg is called
>> recursively(as follows).
>>
>> [1]-> el0_dbg (After executing BRK instruction by user)
>> [2]	-> el1_dbg (when uprobe break handler at [1] executes BRK instruction)
>> 		(At the end of this ELR_EL1 is programmed with fffffdfffc000004)
>> [3]		-> el1_dbg (when kprobe break handler at [2] enables single stepping)
>> 		(Here ELR_EL1 was found fffffe0000092470).So When this el1_dbg was
>> received, then regs->pc  values are not same what was programmed in
>> ELR_EL1 at the return of [2].
>
> Perhaps you're not removing the BRK instruction properly, and so you try to
> single-step a trapping instruction and end up stepping into the exception?
>

No, probably that is not the scenario. One thing I agree, that even if 
AARCH64 specs says that SW BRK exception can not be masked, current 
kernel code is not ready to handle re-entrant software debug exception. 
So, I will keep those part of uprobe code as non-kprobable, and then its 
not so important to get into it for code development perspective.

However, it would be good to understand that what went wrong and caused 
to receive an el1_inval. I still fail to pin point the reason of current 
issue and its not single stepping a trapping instruction (BRK). Sorry, 
but please have a relook at the sequence of events:

1. 1st instruction of uprobe_breakpoint_handler is:
ffffffc00059a628:       a9bf7bfd        stp     x29, x30, [sp,#-16]!
which is replaced by BRK64_OPCODE_KPROBES = 0xD4200080, when Kprobe is 
instrumented.

2. User instruction at address 0x4005d0 is replaced by 
BRK64_OPCODE_UPROBES = 0xD4200100, when uprobe is instrumented.

3. When application executes instruction at 0x4005d0,we receive el0_dbg.

4. In el0_dbg handler we execute kernel code at address 
ffffffc00059a628, so el1_dbg is raised. (I agree here that el0_dbg has 
not been closed properly, which current entry.S code expects, so we will 
need to fix it if we consensus to support re-entrant software debug 
exception, how ever the issue which I see seems unrelated, so...)

5. Now in el1_dbg, we handle kprobe_breakpoint_handler, where we write 
saved instruction (ie a9bf7bfd        stp     x29, x30, [sp,#-16]!) to 
the kmalloc allocated address fffffdfffc000004. kprobe code does 
flush_icache_range on this location. regs->pc is set to 
fffffdfffc000004, so elr_el1 is programmed with fffffdfffc000004 during 
kernel_exit. I have cross checked elr_el1 value just before eret is 
executed in kernel_exit, and it is correct.

So, here we are trying to single step a STP instruction and not BRK 
instruction.

6. Here I am expecting a single step exception, but I receive a el1_inv 
with ESR_EL1(0x86000007) ie EC as "ESR_EL1_EC_IABT_EL1" and IFSC as 
"Translation fault, third level". WHY????

As soon as enable_dbg is called in el1_inv, we receive next single step 
exception, with ELR_EL1 value as next instruction address after 
enable_dbg of el1_inv.

Had we received single step instead of el1_inv with correct elr_el1, 
kprobe_single_step_handler would have executed properly and we would 
have come back to address ffffffc00059a62C (2nd instruction of 
uprobe_breakpoint_handler) after returning from this kprobe single step 
handler. [off-course fix would be needed to correctly come back to this 
address and then also for returning to user space]

~Pratyush


