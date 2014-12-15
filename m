Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751370AbaLOF6i (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Dec 2014 00:58:38 -0500
Received: from mail4.hitachi.co.jp ([133.145.228.5]:41761 "EHLO
	mail4.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750875AbaLOF6g (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Dec 2014 00:58:36 -0500
Message-ID: <548E7884.2020702@hitachi.com>
Date: Mon, 15 Dec 2014 14:58:28 +0900
From: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Organization: Hitachi, Ltd., Japan
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:13.0) Gecko/20120614 Thunderbird/13.0.1
MIME-Version: 1.0
To: Steve Capper <steve.capper@linaro.org>
Cc: David Long <dave.long@linaro.org>, "Jon Medhurst (Tixy)" <tixy@linaro.org>,
        Russell King <linux@arm.linux.org.uk>,
        Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        Sandeepa Prabhu <sandeepa.prabhu@linaro.org>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will.deacon@arm.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Anil S Keshavamurthy <anil.s.keshavamurthy@intel.com>,
        William Cohen <wcohen@redhat.com>, David Miller <davem@davemloft.net>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH v3 0/5] ARM64: Add kernel probes(Kprobes) support
References: <547F242D.1060705@redhat.com> <547F94B0.1000902@linaro.org> <547FB5DD.901@redhat.com> <547FCB73.1010707@linaro.org> <CAPvkgC3=KKKMa1hWdOYOcV7D7kQSLtnNnXLBB64_P-V+_qUwTw@mail.gmail.com> <54803ADD.2090201@hitachi.com> <CAPvkgC26-CprjLVH55=7z73JtxTumFFZ4W7itevXxMwReVqQ1g@mail.gmail.com> <54804B1F.3020703@hitachi.com> <20141209133340.GA20265@linaro.org> <548706C6.2050105@linaro.org> <20141210163817.GA27500@linaro.org> <548B6F58.6010108@linaro.org> <CAPvkgC3OCbh8s=dp3D3vS+fDDK6qPGLPp=mC8Zoh7Og66Po+Kg@mail.gmail.com>
In-Reply-To: <CAPvkgC3OCbh8s=dp3D3vS+fDDK6qPGLPp=mC8Zoh7Og66Po+Kg@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(2014/12/13 8:10), Steve Capper wrote:
> On 12 December 2014 at 22:42, David Long <dave.long@linaro.org> wrote:
>> On 12/10/14 11:38, Steve Capper wrote:
>>>
>>> On Tue, Dec 09, 2014 at 09:27:18AM -0500, David Long wrote:
>>>>
>>>> On 12/09/14 08:33, Steve Capper wrote:
>>>>>
>>>>> On Thu, Dec 04, 2014 at 08:53:03PM +0900, Masami Hiramatsu wrote:
>>>
>>>
>>> [...]
>>>
>>>>>
>>>>> Not sure if this is helpful, but the following also caused a crash for
>>>>> me:
>>>>>
>>>>> echo "p:trace_event_buffer_lock_reserve trace_event_buffer_lock_reserve"
>>>>>> /sys/kernel/debug/tracing/kprobe_events
>>>>> echo "p:memcpy memcpy" >> /sys/kernel/debug/tracing/kprobe_events
>>>>> echo 1 > /sys/kernel/debug/tracing/events/kprobes/enable
>>>>>
>>>>> [immediate crash]
>>>>>
>>>>> The crash point for me is in the arm64 ASID allocator, it again looks
>>>>> like the interrupts are in an unexpected state.
>>>>> (check_and_switch_context goes down the irqs disabled code path, I
>>>>> think incorrectly).
>>>>>
>>>>> This occurred for me both with and without the proposed irq saving fix.
>>>>>
>>>>> I will do some more digging.
>>>>>
>>>>
>>>> Thanks, more information is good.
>>>>
>>>
>>> Hi,
>>>
>>> Some good news, I think I've fixed the problem I've been experiencing.
>>>
>>> Basically, I've torn out all the interrupt save/restore and have
>>> narrowed the scope to just sandwich the instruction single-step. This
>>> simplifies a lot of logic, and I've now been able to perf record a
>>> kprobe on memcpy (and the trace_event_buffer_lock_reserve + memcpy
>>> test) without any issues on a Juno platform.
>>>
>>> I may have been somewhat over-zealous with the chainsaw, so please do
>>> put this fix through its paces.
>>>
>>> Cheers,
>>> --
>>> Steve
>>>
>>>
>>>  From d3f4d80ce19bec71bd03209beb2fbfd8084d6543 Mon Sep 17 00:00:00 2001
>>> From: Steve Capper <steve.capper@linaro.org>
>>> Date: Mon, 1 Dec 2014 11:30:10 +0000
>>> Subject: [PATCH] Fix the interrupt handling for kprobes
>>>
>>> ---
>>>   arch/arm64/kernel/kprobes.c | 16 ++--------------
>>>   1 file changed, 2 insertions(+), 14 deletions(-)
>>>
>>> diff --git a/arch/arm64/kernel/kprobes.c b/arch/arm64/kernel/kprobes.c
>>> index be7c330..d39d826 100644
>>> --- a/arch/arm64/kernel/kprobes.c
>>> +++ b/arch/arm64/kernel/kprobes.c
>>> @@ -229,10 +229,6 @@ skip_singlestep_missed(struct kprobe_ctlblk *kcb,
>>> struct pt_regs *regs)
>>>   {
>>>         /* set return addr to next pc to continue */
>>>         instruction_pointer(regs) += sizeof(kprobe_opcode_t);
>>> -
>>> -       if (kcb->kprobe_status != KPROBE_REENTER)
>>> -               kprobes_restore_local_irqflag(regs);
>>> -
>>>   }
>>>
>>>   static void __kprobes setup_singlestep(struct kprobe *p,
>>> @@ -259,7 +255,7 @@ static void __kprobes setup_singlestep(struct kprobe
>>> *p,
>>>                         spsr_set_debug_flag(regs, 0);
>>>
>>>                 /* IRQs and single stepping do not mix well. */
>>> -               local_irq_disable();
>>> +               kprobes_save_local_irqflag(regs);
>>>                 kernel_enable_single_step(regs);
>>>                 instruction_pointer(regs) = slot;
>>>         } else  {
>>> @@ -326,7 +322,6 @@ post_kprobe_handler(struct kprobe_ctlblk *kcb, struct
>>> pt_regs *regs)
>>>         }
>>>
>>>         reset_current_kprobe();
>>> -       kprobes_restore_local_irqflag(regs);
>>>   }
>>>
>>>   int __kprobes kprobe_fault_handler(struct pt_regs *regs, unsigned int
>>> fsr)
>>> @@ -380,8 +375,6 @@ int __kprobes kprobe_fault_handler(struct pt_regs
>>> *regs, unsigned int fsr)
>>>                         return 1;
>>>
>>>                 break;
>>> -       default:
>>> -               break;
>>>         }
>>>         return 0;
>>>   }
>>> @@ -446,7 +439,6 @@ void __kprobes kprobe_handler(struct pt_regs *regs)
>>>                  * handling of this interrupt is appropriate.
>>>                  * Return back to original instruction, and continue.
>>>                  */
>>> -               kprobes_restore_local_irqflag(regs);
>>>                 return;
>>>         } else if (cur) {
>>>                 /* We probably hit a jprobe.  Call its break handler. */
>>> @@ -459,7 +451,6 @@ void __kprobes kprobe_handler(struct pt_regs *regs)
>>>                 /* breakpoint is removed, now in a race
>>>                  * Return back to original instruction & continue.
>>>                  */
>>> -               kprobes_restore_local_irqflag(regs);
>>>         }
>>>   }
>>>
>>> @@ -485,6 +476,7 @@ kprobe_single_step_handler(struct pt_regs *regs,
>>> unsigned int esr)
>>>         retval = kprobe_ss_hit(kcb, instruction_pointer(regs));
>>>
>>>         if (retval == DBG_HOOK_HANDLED) {
>>> +               kprobes_restore_local_irqflag(regs);
>>>                 kernel_disable_single_step();
>>>
>>>                 if (kcb->kprobe_status == KPROBE_REENTER)
>>> @@ -499,7 +491,6 @@ kprobe_single_step_handler(struct pt_regs *regs,
>>> unsigned int esr)
>>>   static int __kprobes
>>>   kprobe_breakpoint_handler(struct pt_regs *regs, unsigned int esr)
>>>   {
>>> -       kprobes_save_local_irqflag(regs);
>>>         kprobe_handler(regs);
>>>         return DBG_HOOK_HANDLED;
>>>   }
>>> @@ -563,7 +554,6 @@ int __kprobes longjmp_break_handler(struct kprobe *p,
>>> struct pt_regs *regs)
>>>                 memcpy((void *)stack_addr, kcb->jprobes_stack,
>>>                        MIN_STACK_SIZE(stack_addr));
>>>                 preempt_enable_no_resched();
>>> -               kprobes_restore_local_irqflag(regs);
>>>                 return 1;
>>>         }
>>>         return 0;
>>> @@ -655,8 +645,6 @@ trampoline_probe_handler(struct kprobe *p, struct
>>> pt_regs *regs)
>>>                 kfree(ri);
>>>         }
>>>
>>> -       kprobes_restore_local_irqflag(regs);
>>> -
>>>         /* return 1 so that post handlers not called */
>>>         return 1;
>>>   }
>>>
>>
>> Sorry for the delay in responding.  The assumption with the existing code is
>> that you can't enable single-stepping in MDSCR until you disable interrupts.
>> But since we get to that point (in this case) with debug exceptions masked
>> in daif I suppose this is an unnecessary constraint, as you have
>> demonstrated.  I do actually wonder if we need to set the bit in MDSCR_EL1
>> at all since we're also setting it in the spsr in the regs structure that
>> will be restored when the eret is done, but it looks like
>> kernel_enable_single_step() sets both.
>>
> 
> I do think we need to disable interrupts, but only when we're about to
> single-step.
> (My explanation before was imprecise, apologies).
> The change I posted disables interrupts in __kprobes_single_step, and
> restores them in kprobe_single_step_handler.
> I did try removing the interrupt logic completely, but this then
> resulted in a system hang after a few seconds.

By the way, on ARM64, kprobe handler runs under (normal) interrupts enabled?
On x86, the sw breakpoint interrupt automatically disables interrupts, so
original kprobes is designed as run under local-irq-disabled environment.
Maybe we should consider disabling irq at early stage of kprobe handler if
it is correct.

Thank you,

-- 
Masami HIRAMATSU
Software Platform Research Dept. Linux Technology Research Center
Hitachi, Ltd., Yokohama Research Laboratory
E-mail: masami.hiramatsu.pt@hitachi.com


