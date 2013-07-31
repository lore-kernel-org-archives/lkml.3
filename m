Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759501Ab3GaKAl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Jul 2013 06:00:41 -0400
Received: from mx1.redhat.com ([209.132.183.28]:28453 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756116Ab3GaKAg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Jul 2013 06:00:36 -0400
Date: Wed, 31 Jul 2013 13:00:30 +0300
From: Gleb Natapov <gleb@redhat.com>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Subject: Re: [PATCH 2/3] KVM: x86: handle hardware breakpoints during
 emulation
Message-ID: <20130731100030.GF7484@redhat.com>
References: <1375197096-2454-1-git-send-email-pbonzini@redhat.com>
 <1375197096-2454-3-git-send-email-pbonzini@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1375197096-2454-3-git-send-email-pbonzini@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 30, 2013 at 05:11:35PM +0200, Paolo Bonzini wrote:
> This lets debugging work better during emulation of invalid
> guest state.
> 
> The check is done before emulating the instruction, and (in the case
> of guest debugging) reuses EMULATE_DO_MMIO to exit with KVM_EXIT_DEBUG.
> 
Not EMULATE_DO_MMIO any more. Otherwise looks good.

> Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
> ---
>  arch/x86/kvm/x86.c | 66 ++++++++++++++++++++++++++++++++++++++++++++++++++++++
>  1 file changed, 66 insertions(+)
> 
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index c2a0674..1368cf5 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -4956,6 +4956,62 @@ static bool retry_instruction(struct x86_emulate_ctxt *ctxt,
>  static int complete_emulated_mmio(struct kvm_vcpu *vcpu);
>  static int complete_emulated_pio(struct kvm_vcpu *vcpu);
>  
> +static int kvm_vcpu_check_hw_bp(unsigned long addr, u32 type, u32 dr7,
> +				unsigned long *db)
> +{
> +	u32 dr6 = 0;
> +	int i;
> +	u32 enable, rwlen;
> +
> +	enable = dr7;
> +	rwlen = dr7 >> 16;
> +	for (i = 0; i < 4; i++, enable >>= 2, rwlen >>= 4)
> +		if ((enable & 3) && (rwlen & 15) == type && db[i] == addr)
> +			dr6 |= (1 << i);
> +	return dr6;
> +}
> +
> +static bool kvm_vcpu_check_breakpoint(struct kvm_vcpu *vcpu, int *r)
> +{
> +	struct kvm_run *kvm_run = vcpu->run;
> +	unsigned long eip = vcpu->arch.emulate_ctxt.eip;
> +	u32 dr6 = 0;
> +
> +	if (unlikely(vcpu->guest_debug & KVM_GUESTDBG_USE_HW_BP) &&
> +	    (vcpu->arch.guest_debug_dr7 & DR7_BP_EN_MASK)) {
> +		dr6 = kvm_vcpu_check_hw_bp(eip, 0,
> +					   vcpu->arch.guest_debug_dr7,
> +					   vcpu->arch.eff_db);
> +
> +		if (dr6 != 0) {
> +			kvm_run->debug.arch.dr6 = dr6 | DR6_FIXED_1;
> +			kvm_run->debug.arch.pc = kvm_rip_read(vcpu) +
> +				get_segment_base(vcpu, VCPU_SREG_CS);
> +
> +			kvm_run->debug.arch.exception = DB_VECTOR;
> +			kvm_run->exit_reason = KVM_EXIT_DEBUG;
> +			*r = EMULATE_USER_EXIT;
> +			return true;
> +		}
> +	}
> +
> +	if (unlikely(vcpu->arch.dr7 & DR7_BP_EN_MASK)) {
> +		dr6 = kvm_vcpu_check_hw_bp(eip, 0,
> +					   vcpu->arch.dr7,
> +					   vcpu->arch.db);
> +
> +		if (dr6 != 0) {
> +			vcpu->arch.dr6 &= ~15;
> +			vcpu->arch.dr6 |= dr6;
> +			kvm_queue_exception(vcpu, DB_VECTOR);
> +			*r = EMULATE_DONE;
> +			return true;
> +		}
> +	}
> +
> +	return false;
> +}
> +
>  int x86_emulate_instruction(struct kvm_vcpu *vcpu,
>  			    unsigned long cr2,
>  			    int emulation_type,
> @@ -4976,6 +5032,16 @@ int x86_emulate_instruction(struct kvm_vcpu *vcpu,
>  
>  	if (!(emulation_type & EMULTYPE_NO_DECODE)) {
>  		init_emulate_ctxt(vcpu);
> +
> +		/*
> +		 * We will reenter on the same instruction since
> +		 * we do not set complete_userspace_io.  This does not
> +		 * handle watchpoints yet, those would be handled in
> +		 * the emulate_ops.
> +		 */
> +		if (kvm_vcpu_check_breakpoint(vcpu, &r))
> +			return r;
> +
>  		ctxt->interruptibility = 0;
>  		ctxt->have_exception = false;
>  		ctxt->perm_ok = false;
> -- 
> 1.8.1.4
> 

--
			Gleb.
