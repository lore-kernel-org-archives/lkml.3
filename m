Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751514AbbASHrW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Jan 2015 02:47:22 -0500
Received: from mx5.zte.com.cn ([63.217.80.70]:45031 "EHLO mx5.zte.com.cn"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751066AbbASHrU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Jan 2015 02:47:20 -0500
In-Reply-To: <20150116183611.GB1283@potion.brq.redhat.com>
References: <OF9FB4191F.311C876C-ON48257DCE.003C223F-48257DCE.0044DE9C@zte.com.cn> <20150115180911.GB1298@potion.brq.redhat.com> <OFDF2356C5.36A499FB-ON48257DCF.002B5B04-48257DCF.002C4489@zte.com.cn> <20150116183611.GB1283@potion.brq.redhat.com>
Subject: Re: [PATCH 1/1] arch/x86/kvm/vmx.c: Fix external interrupts inject directly
 bug with guestos RFLAGS.IF=0
X-KeepSent: 7C5575E5:A23EA478-48257DD2:000DC6AF;
 type=4; name=$KeepSent
To: =?ISO-8859-2?Q?Radim_Kr=E8m=E1=F8?= <rkrcmar@redhat.com>
Cc: gleb@kernel.org, pbonzini@redhat.com, tglx@linutronix.de, mingo@redhat.com,
        hpa@zytor.com, x86@kernel.org, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
X-Mailer: Lotus Notes Release 8.5.3 September 15, 2011
Message-ID: <OF7C5575E5.A23EA478-ON48257DD2.000DC6AF-48257DD2.002A5833@zte.com.cn>
From: "Li Kaihang" <li.kaihang@zte.com.cn>
Date: Mon, 19 Jan 2015 15:46:35 +0800
X-MIMETrack: Serialize by Router on notes_smtp/zte_ltd(Release 8.5.3FP6|November 21, 2013) at
 2015-01-19 15:46:28
MIME-Version: 1.0
Content-type: text/plain; charset=UTF-8
X-MAIL: mse01.zte.com.cn t0J7keuh087676
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by nfs id t0J7lTIV001275




From:	Radim KrÄmÃ¡Å™ <rkrcmar@redhat.com>
To:	Li Kaihang <li.kaihang@zte.com.cn>,
Cc:	gleb@kernel.org, pbonzini@redhat.com, tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com, x86@kernel.org, kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Date:	2015-01-17 ä¸Šåˆ 02:36
Subject:	Re: [PATCH 1/1] arch/x86/kvm/vmx.c: Fix external interrupts inject directly bug with guestos RFLAGS.IF=0



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

Li kaihang: APICv doesn't completely solve the problem. Firstly, interrupts delivered by APICv must be recognized by virtual apic controller. Secondly, APIC sw is
            enabled. We know that some interrupts are not recognized by virtual apic controller(those may be what vm need or not),and some hardware interrupts emuluated
            by QEMU are needed by virtual bios before guestos starts, at this stage APIC sw is disabled. Thirdly, APICv is only supported by intel ivybridge or
            processors after it, it is not before that.

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

Li kaihang: There exist two cases:
            First, external interrupts registered by vm, such as timer,shared devices,pci passthrough devices interrupts, are handled by host idt to notify one virtual
            apic interrupt controller which manages all general interrupts owned by a vm, inject_pending_event will complete a interrupt vector injecting, if virtual
            interrupt delivery on APICv not supported, after virtual apic interrupt controller updating and computing. This code is looked at inject_pending_event
            fragment below:

            else if (kvm_cpu_has_injectable_intr(vcpu)) {              ==>  find a injecting vector from virtual apic interrupt controller
		/*
		 * Because interrupts can be injected asynchronously, we are
		 * calling check_nested_events again here to avoid a race condition.
		 * See https://lkml.org/lkml/2014/7/2/60 for discussion about this
		 * proposal and current concerns.  Perhaps we should be setting
		 * KVM_REQ_EVENT only on certain events and not unconditionally?
		 */
		if (is_guest_mode(vcpu) && kvm_x86_ops->check_nested_events) {
			r = kvm_x86_ops->check_nested_events(vcpu, req_int_win);
			if (r != 0)
				return r;
		}
		if (kvm_x86_ops->interrupt_allowed(vcpu)) {         ==>  inject the vector if current guestos RFLAGS.IF = 1, else do not.
			kvm_queue_interrupt(vcpu, kvm_cpu_get_interrupt(vcpu),
					    false);
			kvm_x86_ops->set_irq(vcpu);
		}
	    }

           Second, external interrupts needed by vm are not registered in host idt (this may be a wrong or some older interrupts are not recognized by host idt virtual
           apic interrupt controller), in this case, external interrupts handling have no relations between Step 1 and Step 2,but injecting a external interrupt vector
           also must judge current guestos RFLAGS.IF state like above.

           And this bug will be happened under certain probability condition,so it is difficult to use a very accurate model to reproduce that, we may construct a
           special interrupt code to test it. I show a possible steps:

           1. Emulate a A interrupt vector to inject to guestos:

           2. A interrupt handler test part in guestos:

              cli

              do enough waits or delays to not enter next step sti for RFLAGS.IF = 0

              sti

           3. Send a B interrupt to guestos in runing A interrupt handler with RFLAGS.IF = 0 by a hardware device or another way

           4. Bug will appear if all goes well

Thank you.

>             The Bug has never happened in step 1 and 2, but vcpu->arch.interrupt.pending is set in step 1, if this pending should not be injected, it also will be passed
>             to step4 to complete the dangerous external interrupt injecting. Please see the above answer about what is "pending should not be injected"? Our solution
>             is that clearing invalid external interrupt pending to prevent error inject pass by adding a logical judge in step 1.

(I agree that we shouldn't inject events that fail VMENTRY,
 I'm just not sure that this solution is correct.)

Li kaihang: Your consideration is reasonable, in fact we may add a judge in step 4, below, but there are not only pendings on external interrupt here,also including
            software interrupt, and it is not safe in somewhere else, so we consider add a judge in step 1.

            Step 4:
            if (vcpu->arch.interrupt.pending) {
 		 		 kvm_x86_ops->set_irq(vcpu);
 		 		 return 0;
 		 }

> Why isn't the delivered event lost?
> (It should be different from the external interrupt.)
>
> Li Kaihang: please refer to the above answer, a external interrupt in step1 only can get to case INTR_TYPE_EXT_INR branch in patch code, so it should not affect other

(It is the same type of interrupt, but with a different meaning ...
 You don't save the incomplete event delivery in Step 1, so it has to be
 recorded somewhere, otherwise it is lost -- where is it?)

 Li kaihang: To this problem, we should first establish a basic rule in hypervisor design that all interrupts needed by vm must come from virtual interrupt controller
             just like real hardware interrupt controller behavior, then injecting it or not to a vm is decided by whether the external interrupt are recognized by
             virtual interrupt controller(it may be invalid one or not defined to current vm if not recognized) to be notified by host idt handler in step2, even if
             there are different meanings with same type interrupt, those are recognized by virtual interrupt controller in step2. Unfortunately, virtual
             interrupt controller can't do that, some interrupts needed by vm may not be still recognized by virtual interrupt controller so we must pend those interrupt
             flag in step 1 then inject it in step 4 in case of loss, these interrupt bypass virtual interrupt controller checking and bug is hidden in the process.

>             type events delivering, but there is another possibility that the external interrupt needed by running vm is not registered in hostos idt handler chain,of
>             course, this situation is another problem, even so it is dangerous action to inject the external interrupt directly if not judge current guestos RFLAGS.IF
>             state.

(This would be a major blunder -- does it happen?)

Li kaihang: Same as above, it must be guaranteed in virtual interrupt controller design, a external interrupt not recognized by virtual interrupt controller should not
            be injected to guestos. Just like if no virtualization, Should a interrupt not recognized by hard interrupt controller be responded by os?
            We consider solve vm injecting exception with RFLAGS.IF = 0 at first.

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

Li kaihang: OK--------------------------------------------------------
ZTE Information Security Notice: The information contained in this mail (and any attachment transmitted herewith) is privileged and confidential and is intended for the exclusive use of the addressee(s).  If you are not an intended recipient, any disclosure, reproduction, distribution or other dissemination or use of the information contained is strictly prohibited.  If you have received this mail in error, please delete it and notify us immediately.
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
