Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758920Ab3GaJqx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Jul 2013 05:46:53 -0400
Received: from mx1.redhat.com ([209.132.183.28]:37655 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750775Ab3GaJqv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Jul 2013 05:46:51 -0400
Date: Wed, 31 Jul 2013 12:46:49 +0300
From: Gleb Natapov <gleb@redhat.com>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Subject: Re: [PATCH 3/3] KVM: x86: handle singlestep during emulation
Message-ID: <20130731094649.GE7484@redhat.com>
References: <1375197096-2454-1-git-send-email-pbonzini@redhat.com>
 <1375197096-2454-4-git-send-email-pbonzini@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1375197096-2454-4-git-send-email-pbonzini@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 30, 2013 at 05:11:36PM +0200, Paolo Bonzini wrote:
> This lets debugging work better during emulation of invalid
> guest state.
> 
> This time the check is done after emulation, but before writeback
> of the flags; we need to check the flags *before* execution of the
> instruction, we cannot check singlestep_rip because the CS base may
> have already been modified.
> 
> Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
> ---
>  arch/x86/kvm/x86.c | 39 ++++++++++++++++++++++++++++++++++++++-
>  1 file changed, 38 insertions(+), 1 deletion(-)
> 
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index 1368cf5..9805cfd 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -4971,6 +4971,41 @@ static int kvm_vcpu_check_hw_bp(unsigned long addr, u32 type, u32 dr7,
>  	return dr6;
>  }
>  
> +static void kvm_vcpu_check_singlestep(struct kvm_vcpu *vcpu, int *r)
> +{
> +	struct kvm_run *kvm_run = vcpu->run;
> +
> +	/*
> +	 * Use the "raw" value to see if TF was passed to the processor.
> +	 * Note that the new value of the flags has not been saved yet.
> +	 *
> +	 * This is correct even for TF set by the guest, because "the
> +	 * processor will not generate this exception after the instruction
> +	 * that sets the TF flag".
> +	 */
> +	unsigned long rflags = kvm_x86_ops->get_rflags(vcpu);
> +
> +	if (unlikely(rflags & X86_EFLAGS_TF)) {
> +		if (vcpu->guest_debug & KVM_GUESTDBG_SINGLESTEP) {
> +			kvm_run->debug.arch.dr6 = DR6_BS | DR6_FIXED_1;
> +			kvm_run->debug.arch.pc = vcpu->arch.singlestep_rip;
> +			kvm_run->debug.arch.exception = DB_VECTOR;
> +			kvm_run->exit_reason = KVM_EXIT_DEBUG;
> +			*r = EMULATE_USER_EXIT;
> +		} else {
> +			vcpu->arch.emulate_ctxt.eflags &= ~X86_EFLAGS_TF;
> +			/*
> +			 * "Certain debug exceptions may clear bit 0-3.  The
> +			 * remaining contents of the DR6 register are never
> +			 * cleared by the processor".
> +			 */
> +			vcpu->arch.dr6 &= ~15;
> +			vcpu->arch.dr6 |= DR6_BS;
> +			kvm_queue_exception(vcpu, DB_VECTOR);
> +		}
> +	}
> +}
> +
>  static bool kvm_vcpu_check_breakpoint(struct kvm_vcpu *vcpu, int *r)
>  {
>  	struct kvm_run *kvm_run = vcpu->run;
> @@ -5117,10 +5152,12 @@ restart:
>  
>  	if (writeback) {
>  		toggle_interruptibility(vcpu, ctxt->interruptibility);
> -		kvm_set_rflags(vcpu, ctxt->eflags);
>  		kvm_make_request(KVM_REQ_EVENT, vcpu);
>  		vcpu->arch.emulate_regs_need_sync_to_vcpu = false;
>  		kvm_rip_write(vcpu, ctxt->eip);
> +		if (r == EMULATE_DONE)
Single step will not work for mmio write and pio out, we never return
into emulator for those instructions.

> +			kvm_vcpu_check_singlestep(vcpu, &r);
> +		kvm_set_rflags(vcpu, ctxt->eflags);
>  	} else
>  		vcpu->arch.emulate_regs_need_sync_to_vcpu = true;
>  
> -- 
> 1.8.1.4

--
			Gleb.
