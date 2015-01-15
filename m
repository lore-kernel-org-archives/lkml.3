Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753346AbbAOSJa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Jan 2015 13:09:30 -0500
Received: from mx1.redhat.com ([209.132.183.28]:45933 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751147AbbAOSJ3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Jan 2015 13:09:29 -0500
Date: Thu, 15 Jan 2015 19:09:12 +0100
From: Radim =?utf-8?B?S3LEjW3DocWZ?= <rkrcmar@redhat.com>
To: Li Kaihang <li.kaihang@zte.com.cn>
Cc: gleb@kernel.org, pbonzini@redhat.com, tglx@linutronix.de, mingo@redhat.com,
        hpa@zytor.com, x86@kernel.org, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/1] arch/x86/kvm/vmx.c: Fix external interrupts inject
 directly bug with guestos RFLAGS.IF=0
Message-ID: <20150115180911.GB1298@potion.brq.redhat.com>
References: <OF9FB4191F.311C876C-ON48257DCE.003C223F-48257DCE.0044DE9C@zte.com.cn>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <OF9FB4191F.311C876C-ON48257DCE.003C223F-48257DCE.0044DE9C@zte.com.cn>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2015-01-15 20:36+0800, Li Kaihang:
> This patch fix a external interrupt injecting bug in linux 3.19-rc4.

Was the bug introduced in earlier 3.19 release candidate?

> GuestOS is running and handling some interrupt with RFLAGS.IF = 0 while a external interrupt coming,
> then can lead to a vm exit,in this case,we must avoid inject this external interrupt or it will generate
> a processor hardware exception causing virtual machine crash.

What is the source of this exception?  (Is there a reproducer?)

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
> 		kvm_x86_ops->set_irq(vcpu);
> 		return 0;
> 	}
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

Why isn't the delivered event lost?
(It should be different from the external interrupt.)

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
