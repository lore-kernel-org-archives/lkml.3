Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752105AbbASP32 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Jan 2015 10:29:28 -0500
Received: from mx1.redhat.com ([209.132.183.28]:49913 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750728AbbASP31 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Jan 2015 10:29:27 -0500
Message-ID: <54BD22CB.902@redhat.com>
Date: Mon, 19 Jan 2015 16:29:15 +0100
From: Paolo Bonzini <pbonzini@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.3.0
MIME-Version: 1.0
To: Li Kaihang <li.kaihang@zte.com.cn>, gleb@kernel.org
CC: tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com, x86@kernel.org,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/1] arch/x86/kvm/vmx.c: Fix external interrupts inject
 directly bug with guestos RFLAGS.IF=0
References: <OF9FB4191F.311C876C-ON48257DCE.003C223F-48257DCE.0044DE9C@zte.com.cn>
In-Reply-To: <OF9FB4191F.311C876C-ON48257DCE.003C223F-48257DCE.0044DE9C@zte.com.cn>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On 15/01/2015 13:36, Li Kaihang wrote:
> This patch fix a external interrupt injecting bug in linux 3.19-rc4.
> 
> GuestOS is running and handling some interrupt with RFLAGS.IF = 0 while a external interrupt coming,
> then can lead to a vm exit,in this case,we must avoid inject this external interrupt or it will generate
> a processor hardware exception causing virtual machine crash.

I do not understand what is happening here.

Between the time the processor starts delivering an external interrupt
to the VM, and the time it decides to do a vm exit because of an
external interrupt in the host, IF becomes 0.

What is the cause of the external interrupt?  Why does IF become 0?

> Now, I show more details about this problem:
> 
> A general external interrupt processing for a running virtual machine is shown in the following:
> 
> Step 1:
>      a ext intr gen a vm_exit

How did the external interrupt cause the IDT-vectoring information field
to be set?  External interrupts for the host are not among the causes
listed in "27.2.3 Information for VM Exits During Event Delivery".

> --> vmx_complete_interrupts --> __vmx_complete_interrupts --> case INTR_TYPE_EXT_INR: kvm_queue_interrupt(vcpu, vector, type == INTR_TYPE_SOFT_INTR);
> 
> Step 2:
>      kvm_x86_ops->handle_external_intr(vcpu);

Why is this relevant?  The external interrupt is a vectored event, so it
sets VM-exit interruption information (27.2.2 Information for VM Exits
Due to Vectored Events).  It doesn't set the IDT-vectoring information
field.

Paolo

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
