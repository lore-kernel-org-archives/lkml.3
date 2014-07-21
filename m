Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754798AbaGUMFW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jul 2014 08:05:22 -0400
Received: from mx1.redhat.com ([209.132.183.28]:5717 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753965AbaGUMFV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jul 2014 08:05:21 -0400
Message-ID: <53CD01EE.40804@redhat.com>
Date: Mon, 21 Jul 2014 14:05:02 +0200
From: Paolo Bonzini <pbonzini@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Nadav Amit <namit@cs.technion.ac.il>
CC: tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com, x86@kernel.org,
        gleb@kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 4/7] KVM: vmx: set rflags.rf during fault injection
References: <1405942650-22589-1-git-send-email-namit@cs.technion.ac.il> <1405942650-22589-5-git-send-email-namit@cs.technion.ac.il>
In-Reply-To: <1405942650-22589-5-git-send-email-namit@cs.technion.ac.il>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Il 21/07/2014 13:37, Nadav Amit ha scritto:
> VMX does not automatically set rflags.rf during event injection. This patch
> does partial job, setting rflags.rf upon fault injection.  It also marks that
> injection of trap/interrupt during rep-string instruction is not properly
> emulated. It is unclear how to do it efficiently without decoding the guest
> instruction before interrupt injection.
> 
> Signed-off-by: Nadav Amit <namit@cs.technion.ac.il>

Nothing in this patch is VMX-specific, right?

So it should be done in x86.c.

> ---
>  arch/x86/kvm/vmx.c | 11 ++++++++++-
>  1 file changed, 10 insertions(+), 1 deletion(-)
> 
> diff --git a/arch/x86/kvm/vmx.c b/arch/x86/kvm/vmx.c
> index 0c9569b..8edb785 100644
> --- a/arch/x86/kvm/vmx.c
> +++ b/arch/x86/kvm/vmx.c
> @@ -2006,6 +2006,7 @@ static void vmx_queue_exception(struct kvm_vcpu *vcpu, unsigned nr,
>  				bool reinject)
>  {
>  	struct vcpu_vmx *vmx = to_vmx(vcpu);
> +	unsigned long rflags;
>  	u32 intr_info = nr | INTR_INFO_VALID_MASK;
>  
>  	if (!reinject && is_guest_mode(vcpu) &&
> @@ -2017,6 +2018,12 @@ static void vmx_queue_exception(struct kvm_vcpu *vcpu, unsigned nr,
>  		intr_info |= INTR_INFO_DELIVER_CODE_MASK;
>  	}
>  
> +	rflags = vmx_get_rflags(vcpu);
> +	if (kvm_exception_type(nr) == EXCPT_FAULT)
> +		vmx_set_rflags(vcpu, rflags | X86_EFLAGS_RF);
> +
> +	/* TODO: Set rflags.rf on trap during rep-string */

For vmexits happening during a rep string operation that isn't emulated,
the processor should set RF correctly ("If the VM exit is caused
directly by an event that would normally be delivered through the IDT,
the value saved is that which would appear in the saved RFLAGS image had
the event been delivered through the IDT").

Perhaps the emulator could set RF to 1 after executing the first
iteration, and clear it after executing the last?

Paolo

> +
>  	if (vmx->rmode.vm86_active) {
>  		int inc_eip = 0;
>  		if (kvm_exception_is_soft(nr))
> @@ -4631,8 +4638,10 @@ static void vmx_inject_irq(struct kvm_vcpu *vcpu)
>  		intr |= INTR_TYPE_SOFT_INTR;
>  		vmcs_write32(VM_ENTRY_INSTRUCTION_LEN,
>  			     vmx->vcpu.arch.event_exit_inst_len);
> -	} else
> +	} else {
> +		/* TODO: Set rflags.rf during rep-string */
>  		intr |= INTR_TYPE_EXT_INTR;
> +	}
>  	vmcs_write32(VM_ENTRY_INTR_INFO_FIELD, intr);
>  }
>  
> 

