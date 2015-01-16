Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752363AbbAPHsR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Jan 2015 02:48:17 -0500
Received: from mx7.zte.com.cn ([202.103.147.169]:60566 "EHLO zte.com.cn"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751871AbbAPHsQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Jan 2015 02:48:16 -0500
X-Greylist: delayed 979 seconds by postgrey-1.27 at vger.kernel.org; Fri, 16 Jan 2015 02:48:15 EST
In-Reply-To: <20150115180911.GB1298@potion.brq.redhat.com>
References: <OF9FB4191F.311C876C-ON48257DCE.003C223F-48257DCE.0044DE9C@zte.com.cn> <20150115180911.GB1298@potion.brq.redhat.com>
Subject: Re: [PATCH 1/1] arch/x86/kvm/vmx.c: Fix external interrupts inject directly
 bug with guestos RFLAGS.IF=0
X-KeepSent: B0881CAF:42461D8F-48257DCF:0014A45C;
 type=4; name=$KeepSent
To: =?ISO-8859-2?Q?Radim_Kr=E8m=E1=F8?= <rkrcmar@redhat.com>
Cc: gleb@kernel.org, pbonzini@redhat.com, tglx@linutronix.de, mingo@redhat.com,
        hpa@zytor.com, x86@kernel.org, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
X-Mailer: Lotus Notes Release 8.5.3 September 15, 2011
Message-ID: <OFB0881CAF.42461D8F-ON48257DCF.0014A45C-48257DCF.0028F400@zte.com.cn>
From: "Li Kaihang" <li.kaihang@zte.com.cn>
Date: Fri, 16 Jan 2015 15:31:26 +0800
X-MIMETrack: Serialize by Router on notes_smtp/zte_ltd(Release 8.5.3FP6|November 21, 2013) at
 2015-01-16 15:31:26
MIME-Version: 1.0
Content-type: text/plain; charset=UTF-8
X-MAIL: mse01.zte.com.cn t0G7VPd4086107
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by nfs id t0G7mRvW020780

Hello, please see the answer below blue:



From:	Radim KrÄmÃ¡Å™ <rkrcmar@redhat.com>
To:	Li Kaihang <li.kaihang@zte.com.cn>,
Cc:	gleb@kernel.org, pbonzini@redhat.com, tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com, x86@kernel.org, kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Date:	2015-01-16 ä¸Šåˆ 02:09
Subject:	Re: [PATCH 1/1] arch/x86/kvm/vmx.c: Fix external interrupts inject directly bug with guestos RFLAGS.IF=0



2015-01-15 20:36+0800, Li Kaihang:
> This patch fix a external interrupt injecting bug in linux 3.19-rc4.

Was the bug introduced in earlier 3.19 release candidate?

Li Kaihang: Yes, we also find this problem in 2.6.

> GuestOS is running and handling some interrupt with RFLAGS.IF = 0 while a external interrupt coming,
> then can lead to a vm exit,in this case,we must avoid inject this external interrupt or it will generate
> a processor hardware exception causing virtual machine crash.

What is the source of this exception?  (Is there a reproducer?)

Li Kaihang: exception is produced by intel processor hardware because injecting a external interrupt vector is forbidden by intel processor when GuestOS RFLAGS.IF = 0,
            this need to be ensured by hypervisor software according to Intel 64 and IA-32 Architectures Software Developer's Manual Volume 3.
            This bug has a certain probability, if code is designed to be very short between cli and sti in a guestos's interrupt processing, probability of occurrence
            is very low, this event is like moving trap, bug is produced that guestos is running between cli and sti instruction while a external interrupt coming, it
            may be verified by constructing a special guestos interrupt code. General OS running on kvm vm has also probability to hit this bug.

> Now, I show more details about this problem:
>
> A general external interrupt processing for a running virtual machine is shown in the following:
>
> Step 1:
>      a ext intr gen a vm_exit --> vmx_complete_interrupts --> __vmx_complete_interrupts --> case INTR_TYPE_EXT_INR: kvm_queue_interrupt(vcpu, vector, type == INTR_TYPE_SOFT_INTR);
>
> Step 2:
>      kvm_x86_ops->handle_external_intr(vcpu);
>
> Step 3:
>      get back to vcpu_enter_guest after a while cycle,then run inject_pending_event
>
> Step 4:
>      if (vcpu->arch.interrupt.pending) {
> 		 		 kvm_x86_ops->set_irq(vcpu);
> 		 		 return 0;
> 		 }
>
> Step 5:
>      kvm_x86_ops->run(vcpu) --> vm_entry inject vector to guestos IDT
>
> for the above steps, step 4 and 5 will be a processor hardware exception if step1 happen while guestos RFLAGS.IF = 0, that is to say, guestos interrupt is disabled.
> So we should add a logic to judge in step 1 whether a external interrupt need to be pended then inject directly, in the process, we don't need to worry about
> this external interrupt lost because the next Step 2 will handle and choose a best chance to inject it by virtual interrupt controller.

Can you explain the relation between vectored events (Step 1) and
external interrupts (Step 2)?
(The bug happens when external interrupt arrives during event delivery?)

Li Kaihang: a external interrupt to running vm can trigger a vm_exit event handled in step 1, then this interrupt vector can be processed in step2
            kvm_x86_ops->handle_external_intr(vcpu) and this function can jump to HOSTOS IDT to complete external interrupt handling,external interrupt handler in HOSTOS
            IDT may inject the external interrupt into virtual interrupt controller if it has been registered to be needed by virtual machine.
            The Bug has never happened in step 1 and 2, but vcpu->arch.interrupt.pending is set in step 1, if this pending should not be injected, it also will be passed
            to step4 to complete the dangerous external interrupt injecting. Please see the above answer about what is "pending should not be injected"? Our solution
            is that clearing invalid external interrupt pending to prevent error inject pass by adding a logical judge in step 1.

Why isn't the delivered event lost?
(It should be different from the external interrupt.)

Li Kaihang: please refer to the above answer, a external interrupt in step1 only can get to case INTR_TYPE_EXT_INR branch in patch code, so it should not affect other
            type events delivering, but there is another possibility that the external interrupt needed by running vm is not registered in hostos idt handler chain,of
            course, this situation is another problem, even so it is dangerous action to inject the external interrupt directly if not judge current guestos RFLAGS.IF
            state

Thanks.

>
>
> Signed-off-by: Li kaihang <li.kaihang@zte.com.cn>
> ---
>  arch/x86/kvm/vmx.c |   20 ++++++++++++++++++--
>  1 files changed, 18 insertions(+), 2 deletions(-)
>
> diff --git a/arch/x86/kvm/vmx.c b/arch/x86/kvm/vmx.c
> index d4c58d8..e8311ee 100644
> --- a/arch/x86/kvm/vmx.c
> +++ b/arch/x86/kvm/vmx.c
> @@ -7711,10 +7711,26 @@ static void __vmx_complete_interrupts(struct kvm_vcpu *vcpu,
>                 break;
>         case INTR_TYPE_SOFT_INTR:
>                 vcpu->arch.event_exit_inst_len = vmcs_read32(instr_len_field);
> -               /* fall through */
> -       case INTR_TYPE_EXT_INTR:
> +               /*
> +               * As software and external interrupts may all get here,
> +               * we should separate soft intr from ext intr code,and this
> +               * will ensure that software interrupts handling process is not
> +               * affected by solving external interrupt invalid injecting.
> +               */
>                 kvm_queue_interrupt(vcpu, vector, type == INTR_TYPE_SOFT_INTR);

(No need for 'type == INTR_TYPE_SOFT_INTR', we know it is true.)
 Li Kaihang: I agree
>                 break;
> +       case INTR_TYPE_EXT_INTR:
> +               /*
> +               * GuestOS is running and handling some interrupt with
> +               * RFLAGS.IF = 0 while a external interrupt coming,
> +               * then can lead a vm exit getting here,in this case,
> +               * we must avoid inject this external interrupt or it will
> +               * generate a processor hardware exception causing vm crash.
> +               */
> +               if (kvm_x86_ops->interrupt_allowed(vcpu))
> +                       kvm_queue_interrupt(vcpu, vector,
> +                                       type == INTR_TYPE_SOFT_INTR);

(And false here.)
Li Kaihang: I agree--------------------------------------------------------
ZTE Information Security Notice: The information contained in this mail (and any attachment transmitted herewith) is privileged and confidential and is intended for the exclusive use of the addressee(s).  If you are not an intended recipient, any disclosure, reproduction, distribution or other dissemination or use of the information contained is strictly prohibited.  If you have received this mail in error, please delete it and notify us immediately.
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
