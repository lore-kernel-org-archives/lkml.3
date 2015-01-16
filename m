Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756685AbbAPSg0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Jan 2015 13:36:26 -0500
Received: from mx1.redhat.com ([209.132.183.28]:47389 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751720AbbAPSgZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Jan 2015 13:36:25 -0500
Date: Fri, 16 Jan 2015 19:36:11 +0100
From: Radim =?utf-8?B?S3LEjW3DocWZ?= <rkrcmar@redhat.com>
To: Li Kaihang <li.kaihang@zte.com.cn>
Cc: gleb@kernel.org, pbonzini@redhat.com, tglx@linutronix.de, mingo@redhat.com,
        hpa@zytor.com, x86@kernel.org, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/1] arch/x86/kvm/vmx.c: Fix external interrupts inject
 directly bug with guestos RFLAGS.IF=0
Message-ID: <20150116183611.GB1283@potion.brq.redhat.com>
References: <OF9FB4191F.311C876C-ON48257DCE.003C223F-48257DCE.0044DE9C@zte.com.cn>
 <20150115180911.GB1298@potion.brq.redhat.com>
 <OFDF2356C5.36A499FB-ON48257DCF.002B5B04-48257DCF.002C4489@zte.com.cn>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <OFDF2356C5.36A499FB-ON48257DCF.002B5B04-48257DCF.002C4489@zte.com.cn>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2015-01-16 16:07+0800, Li Kaihang:
> > GuestOS is running and handling some interrupt with RFLAGS.IF = 0 while a external interrupt coming,
> > then can lead to a vm exit,in this case,we must avoid inject this external interrupt or it will generate
> > a processor hardware exception causing virtual machine crash.
> 
> What is the source of this exception?  (Is there a reproducer?)
> 
> Li Kaihang: exception is produced by intel processor hardware because injecting a external interrupt vector is forbidden by intel processor when GuestOS RFLAGS.IF = 0,
>             this need to be ensured by hypervisor software according to Intel 64 and IA-32 Architectures Software Developer's Manual Volume 3.

(Found it, happens on VMENTRY ... 26.3.1.4 Checks on Guest RIP and RFLAGS
   The IF flag (RFLAGS[bit 9]) must be 1 if the valid bit (bit 31) in the
   VM-entry interruption-information field is 1 and the interruption type
   (bits 10:8) is external interrupt.)

>             This bug has a certain probability, if code is designed to be very short between cli and sti in a guestos's interrupt processing, probability of occurrence
>             is very low, this event is like moving trap, bug is produced that guestos is running between cli and sti instruction while a external interrupt coming, it
>             may be verified by constructing a special guestos interrupt code. General OS running on kvm vm has also probability to hit this bug.

Is APICv enabled?  (Does togging it avoid the bug?)

> > Step 1:
> >      a ext intr gen a vm_exit --> vmx_complete_interrupts --> __vmx_complete_interrupts --> case INTR_TYPE_EXT_INR: kvm_queue_interrupt(vcpu, vector, type == INTR_TYPE_SOFT_INTR);
> >
> > Step 2:
> >      kvm_x86_ops->handle_external_intr(vcpu);
> > for the above steps, step 4 and 5 will be a processor hardware exception if step1 happen while guestos RFLAGS.IF = 0, that is to say, guestos interrupt is disabled.
> > So we should add a logic to judge in step 1 whether a external interrupt need to be pended then inject directly, in the process, we don't need to worry about
> > this external interrupt lost because the next Step 2 will handle and choose a best chance to inject it by virtual interrupt controller.
> 
> Can you explain the relation between vectored events (Step 1) and
> external interrupts (Step 2)?
> (The bug happens when external interrupt arrives during event delivery?)
> 
> Li Kaihang: a external interrupt to running vm can trigger a vm_exit event handled in step 1, then this interrupt vector can be processed in step2
>             kvm_x86_ops->handle_external_intr(vcpu) and this function can jump to HOSTOS IDT to complete external interrupt handling,external interrupt handler in HOSTOS
>             IDT may inject the external interrupt into virtual interrupt controller if it has been registered to be needed by virtual machine.

Proposed non-accidental relation between first two steps confuses me ...

1) External interrupt in Step 1 should be from incomplete event delivery
   to the guest,
2) External interrupt in Step 2 from an interrupt for the host.
3) Interrupts should be unrelated, because if not, then we either
   deliver host's interrupts directly to the guest, or the other way
   around.  (Both cases are buggy, regardless of CLI.)
   - What is stored in "VM-exit interruption information" (Step 2) and
     "IDT-vectoring information" (Step 1)?

=> Interrupts in first two steps are independent and we have interrupted
   external interrupt delivery to the guest.

Can you provide a KVM trace of what is happening before the crash?
(Or just point out where I made a mistake.)

Thank you.

>             The Bug has never happened in step 1 and 2, but vcpu->arch.interrupt.pending is set in step 1, if this pending should not be injected, it also will be passed
>             to step4 to complete the dangerous external interrupt injecting. Please see the above answer about what is "pending should not be injected"? Our solution
>             is that clearing invalid external interrupt pending to prevent error inject pass by adding a logical judge in step 1.

(I agree that we shouldn't inject events that fail VMENTRY,
 I'm just not sure that this solution is correct.)

> Why isn't the delivered event lost?
> (It should be different from the external interrupt.)
> 
> Li Kaihang: please refer to the above answer, a external interrupt in step1 only can get to case INTR_TYPE_EXT_INR branch in patch code, so it should not affect other

(It is the same type of interrupt, but with a different meaning ...
 You don't save the incomplete event delivery in Step 1, so it has to be
 recorded somewhere, otherwise it is lost -- where is it?)

>             type events delivering, but there is another possibility that the external interrupt needed by running vm is not registered in hostos idt handler chain,of
>             course, this situation is another problem, even so it is dangerous action to inject the external interrupt directly if not judge current guestos RFLAGS.IF
>             state.

(This would be a major blunder -- does it happen?)

> > Signed-off-by: Li kaihang <li.kaihang@zte.com.cn>
> > ---
> > diff --git a/arch/x86/kvm/vmx.c b/arch/x86/kvm/vmx.c
> > index d4c58d8..e8311ee 100644
> > --- a/arch/x86/kvm/vmx.c
> > +++ b/arch/x86/kvm/vmx.c
> > @@ -7711,10 +7711,26 @@ static void __vmx_complete_interrupts(struct kvm_vcpu *vcpu,
[...]
> > +       case INTR_TYPE_EXT_INTR:
> > +               /*
> > +               * GuestOS is running and handling some interrupt with
> > +               * RFLAGS.IF = 0 while a external interrupt coming,
> > +               * then can lead a vm exit getting here,in this case,
> > +               * we must avoid inject this external interrupt or it will
> > +               * generate a processor hardware exception causing vm crash.
> > +               */
> > +               if (kvm_x86_ops->interrupt_allowed(vcpu))

(I missed this on the first reading ...
 in vmx.c, it is better to use vmx_interrupt_allowed() directly.)
