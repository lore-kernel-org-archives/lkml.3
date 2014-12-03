Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752107AbaLCTaE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Dec 2014 14:30:04 -0500
Received: from mail-lb0-f180.google.com ([209.85.217.180]:39097 "EHLO
	mail-lb0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751393AbaLCTaC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Dec 2014 14:30:02 -0500
MIME-Version: 1.0
In-Reply-To: <65CD3FC07F3BF942ABE211646D72D770356ECDFD@IRSMSX110.ger.corp.intel.com>
References: <65CD3FC07F3BF942ABE211646D72D770356EACA5@IRSMSX110.ger.corp.intel.com>
 <1417099205-13309-1-git-send-email-emmanuel.berthier@intel.com>
 <alpine.DEB.2.11.1411271609510.3961@nanos> <CALCETrWKiTdzSQ6kKPaufHoW2aTjPtqkQy9cyq_YiBwoowe-+g@mail.gmail.com>
 <65CD3FC07F3BF942ABE211646D72D770356EB2B2@IRSMSX110.ger.corp.intel.com>
 <CALCETrWO5jVaXrvtMmxEtV0-9husbwFrm=FLWUvEJJev25KXmg@mail.gmail.com>
 <65CD3FC07F3BF942ABE211646D72D770356EC658@IRSMSX110.ger.corp.intel.com>
 <CALCETrWxXm_Cvu+3dakCFX1GSN2KcaoxC+qbTr8Z7ha2CtEEXw@mail.gmail.com>
 <alpine.DEB.2.11.1412022044410.16275@nanos> <CALCETrW1hsmUrrG9KzfAujFuGcF1g1b8m++hJkxSGxketobUHw@mail.gmail.com>
 <65CD3FC07F3BF942ABE211646D72D770356ECDFD@IRSMSX110.ger.corp.intel.com>
From: Andy Lutomirski <luto@amacapital.net>
Date: Wed, 3 Dec 2014 11:29:39 -0800
Message-ID: <CALCETrVk6XiFeAPKU4bM_ZFFSRmQQvDS=Ascs17qcRM3503ETQ@mail.gmail.com>
Subject: Re: [PATCH v2] [LBR] Dump LBRs on Exception
To: "Berthier, Emmanuel" <emmanuel.berthier@intel.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
        X86 ML <x86@kernel.org>, "Jarzmik, Robert" <robert.jarzmik@intel.com>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 3, 2014 at 10:25 AM, Berthier, Emmanuel
<emmanuel.berthier@intel.com> wrote:
>> From: Andy Lutomirski [mailto:luto@amacapital.net]
>> Sent: Tuesday, December 2, 2014 9:12 PM
>> To: Thomas Gleixner
>> Cc: Berthier, Emmanuel; H. Peter Anvin; X86 ML; Jarzmik, Robert; LKML
>> Subject: Re: [PATCH v2] [LBR] Dump LBRs on Exception
>>
>> On Tue, Dec 2, 2014 at 11:56 AM, Thomas Gleixner <tglx@linutronix.de>
>> wrote:
>> > On Tue, 2 Dec 2014, Andy Lutomirski wrote:
>> >> TBH, I'm wondering whether this is actually a good idea.  It might be
>> >> more valuable and less scary to try to make this work for BUG instead.
>> >> To get the most impact, it might be worth allocating a new exception
>> >> vector for BUG and using 'int 0xwhatever', and the prologue to that
>> >> could read out all the MSRs without any branches.
>> >
>> > BUG is pretty uninteresting. We usually know how we got there. Now
>> > where LBR might be useful is if you have stack corruption and branch
>> > into nirvana or access random crap via a few hoops. There the LBR data
>> > might help, because the corrupted stack does not tell anything.
>
> Right, I remember some strange Panic where the register content was not coherent with the EIP.
> That's what I call "jump into space".
>
>> > So yes, this is a corner case debugging scenario, but given the
>> > complexity of coordination with perf and the possible intrusiveness in
>> > the low level entry path, we really need to see a few real world
>> > examples where this helps, aside of the constructed case.
>
> Here is such "jump into space":
>
> <1>[  533.394885] BUG: unable to handle kernel paging request at c12329c0
> <1>[  533.394930] IP: [<c12329ed>] s0ix_complete+0x2d/0x30
> <4>[  533.394973] *pde = 362c8063 *pte = 01232161
> <4>[  533.395001] Oops: 0003 [#1] PREEMPT SMP
> <4>[  533.395030] Modules linked in: atomisp lm3554 mt9m114 ov8830 tty_hci wl12xx_sdio(O) wl12xx(O) mac80211(O) cfg80211(O) compat(O) rmi4(C) st_drv videobuf_vmalloc videobuf_core matrix(C) sgx(C)
> <4>[  533.395120]
> <4>[  533.395135] Pid: 0, comm: swapper/1 Tainted: G         C O 3.4.21-183401-g34a7d6b #1 Intel Corporation CloverTrail/FFRD
> <4>[  533.395165] EIP: 0060:[<c12329ed>] EFLAGS: 00011ed6 CPU: 1
> <4>[  533.395184] EIP is at s0ix_complete+0x2d/0x30
> <4>[  533.395198] EAX: c12329c0 EBX: c1d120a0 ECX: 00000001 EDX: 00000000
> <4>[  533.395211] ESI: e0d26b2b EDI: 12e6492c EBP: f60a9eec ESP: f60a9ef0
> <4>[  533.395225]  DS: 007b ES: 007b FS: 00d8 GS: 0000 SS: 0068
> <4>[  533.395239] CR0: 8005003b CR2: c12329c0 CR3: 01dfe000 CR4: 000007d0
> <4>[  533.395253] DR0: 00000000 DR1: 00000000 DR2: 00000000 DR3: 00000000
> <4>[  533.395265] DR6: ffff0ff0 DR7: 00000400
> <0>[  533.395279] Process swapper/1 (pid: 0, ti=f60a8000 task=f607b520 task.ti=f60a8000)
> <0>[  533.395290] Stack:
> <4>[  533.395299]  c1230b36 f60a9f40 c153d73a 00000767 f60a9f10 c123b908 f60a9f0c 00000000
> <4>[  533.395342]  00000052 00000006 f67eb45c 00000001 00000007 00000000 c1d120a0 00000052
> <4>[  533.395384]  00000001 c1d120a0 00000214 f67eb45c f60a9f50 c174ccd5 fffffff0 00000001
> <0>[  533.395427] Call Trace:
> <4>[  533.395445]  [<c1230b36>] pmu_set_s0ix_complete+0x16/0x20
> <4>[  533.395468]  [<c153d73a>] ? soc_s0ix_idle+0x13a/0x4b0
> <4>[  533.395488]  [<c123b908>] ? ns_to_timespec+0x28/0x40
> <4>[  533.395510]  [<c174ccd5>] ? cpuidle_enter+0x15/0x20
> <4>[  533.395529]  [<c174d2ef>] ? cpuidle_idle_call+0x9f/0x320
> <4>[  533.395549]  [<c1209795>] ? cpu_idle+0x75/0xd0
> <4>[  533.395569]  [<c19955bd>] ? start_secondary+0x23c/0x23e
> <0>[  533.395583] Code: e5 3e 8d 74 26 00 a1 44 91 e0 c1 8b 90 38 0a 00 00 85 d2 75 02 5d c3 8b 90 34 1d 00 00 31 c0 89 42 58 5d c3 8d 76 00 8d bc 27 00 <00> 00 00 55 89 e5 53 3e 8d 74 26 00 89 c1 31 c0 83 f9 3f 77 24
> <0>[  533.395862] EIP: [<c12329ed>] s0ix_complete+0x2d/0x30 SS:ESP 0068:f60a9ef0
> <4>[  533.395888] CR2: 00000000c12329c0
>
> Analysis:
>
> After replaying the game with T32 in normal situation and comparing the snapshots,  it appears that to get the same call stack, we come from pmu_set_s0ix_complete():
>
>                     |void pmu_set_s0ix_complete(void)
>                 437 |{
>                 438 |        if (pmu_ops->set_s0ix_complete)
>    NP:0000:C1230B28 |A14071E0C1                mov        eax,[0xC1E07140]   ; eax,pmu_ops
>    NP:0000:C1230B2D |8B401C                    mov        eax,[eax+0x1C]
>    NP:0000:C1230B30 |85C0                      test       eax,eax
>    NP:0000:C1230B32 |7402                      je         0xC1230B36
>                 439 |                pmu_ops->set_s0ix_complete();
>    NP:0000:C1230B34 |FFD0                      call       eax
>                 440 |}
>    NP:0000:C1230B36 |5D                        pop        ebp
>    NP:0000:C1230B37 |C3                        ret
>
> and we have not yet executed the beginning of s0ix_complete() as EBP is not yet stored in the stack and EAX has not be modified:
>
>                    |void s0ix_complete(void)
>                257 |{
>   NP:0000:C12329C0 |55______________s0ix_com.:push_______ebp
>   NP:0000:C12329C1 |89E5                      mov        ebp,esp
>   NP:0000:C12329C3 |3E8D742600                lea        esi,ds:[esi+0x0]
>                    |
>                    |void s0ix_complete(void)
>                257 |{
>                258 |        if (unlikely(mid_pmu_cxt->s0ix_entered))
>   NP:0000:C12329C8 |A14471E0C1                mov        eax,[0xC1E07144]   ; eax,mid_pmu_cxt
>   NP:0000:C12329CD |8B90380A0000              mov        edx,[eax+0xA38]
>   NP:0000:C12329D3 |85D2                      test       edx,edx
>   NP:0000:C12329D5 |7502                      jne        0xC12329D9
>                260 |}
>   NP:0000:C12329D7 |5D                        pop        ebp
>   NP:0000:C12329D8 |C3                        ret
>                259 |                writel(0, &mid_pmu_cxt->pmu_reg->pm_msic);
>   NP:0000:C12329D9 |8B90341D0000              mov        edx,[eax+0x1D34]
>                 63 |build_mmio_write(writel, "l", unsigned int, "r", :"memory")
>   NP:0000:C12329DF |31C0                      xor        eax,eax
>   NP:0000:C12329E1 |894258                    mov        [edx+0x58],eax
>                260 |}
>   NP:0000:C12329E4 |5D                        pop        ebp
>   NP:0000:C12329E5 |C3                        ret
>   NP:0000:C12329E6 |8D7600                    lea        esi,[esi+0x0]
>   NP:0000:C12329E9 |8DBC2700000000            lea        edi,[edi+0x0]
>
> So, the execution of "call eax" has jumped directly to eax+2d.
>
>> One option would be to treat this as the debugging feature that it is.
>
> Agree.
>
>> Don't change the exception entry code at all.  Instead add a run-time switch
>> that will ask perf to set up the LBR stuff appropriately and will change the IDT
>> entries to stubs that first use rdmsr to copy all the LBRs to some per-cpu, per-
>> vector area and then jump to the real entry point.
>>
>> Yes, performance will suck, and there will be some artifacts if the exception
>> nests inside itself before reporting the error (which can happen for page
>> faults, I think), but this isn't the end of the world if it's an opt-in feature.
>>
>> And the whole pile of rdmsrs can be generated at run-time to match the
>> running CPU.
>
> The final patch will bypass the new code in case of UserSpace page fault, so performance impact will be very low.
> LBRs copy takes much more time than LBR stop/start.
>
> The simple is the better:
>
> .macro STOP_LBR
> #ifdef CONFIG_LBR_DUMP_ON_EXCEPTION
>         testl $3,CS(%rsp)               /* Kernel Space? */
>         jnz 1f
>         testl $3, PER_CPU_VAR(lbr_dump_state) /* Disabled? */
>         jnz 1f

But that just wasted two of your LBR slots.

>         push %rax
>         push %rcx
>         push %rdx
>         movl $MSR_IA32_DEBUGCTLMSR, %ecx
>         rdmsr
>         and $~1, %eax   /* Disable LBR recording */
>         wrmsr
>         pop %rdx
>         pop %rcx
>         pop %rax

And the general problem with this approach (even ignoring the
performance hit, and kernel faults on user addresses really do happen
in real workloads) is that you're not saving and restoring
MSR_IA32_DEBUGCTL.  It may be that the rest of your patch does
whatever magic is needed to make this work, but from just this code
it's not at all obvious that this is correct.

Hence my suggestion for rdmsr -- if you're willing to enable this and
take the performance hit, you can simplify it a lot and save some
branch slots by unconditionally doing the rdmsrs if you've enabled the
LBR tracing IDT entry.  The simplification from using rdmsr isn't that
the save code is simplified -- it's that there's no state change on
exception entry, so you don't need to worry about restoring state
correctly on the way out or during a context switch.  And you can
enable/disable the whole thing just by writing to the IDT, so there's
no performance hit at all in the disabled case.

--Andy

> 1:
> #endif
> .endm
>
> Thx,
>
> Emmanuel.



-- 
Andy Lutomirski
AMA Capital Management, LLC
