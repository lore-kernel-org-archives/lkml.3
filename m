Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932687AbaGUPU4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jul 2014 11:20:56 -0400
Received: from mx1.redhat.com ([209.132.183.28]:21862 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932418AbaGUPUy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jul 2014 11:20:54 -0400
Message-ID: <53CD2FA7.7010203@redhat.com>
Date: Mon, 21 Jul 2014 17:20:07 +0200
From: Paolo Bonzini <pbonzini@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Nadav Amit <namit@cs.technion.ac.il>
CC: gleb@kernel.org, tglx@linutronix.de, mingo@redhat.com, x86@kernel.org,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] KVM: x86: DR6/7.RTM cannot be written
References: <1405435066-8936-1-git-send-email-namit@cs.technion.ac.il>
In-Reply-To: <1405435066-8936-1-git-send-email-namit@cs.technion.ac.il>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Il 15/07/2014 16:37, Nadav Amit ha scritto:
> Haswell and newer Intel CPUs have support for RTM, and in that case DR6.RTM is
> not fixed to 1 and DR7.RTM is not fixed to zero. That is not the case in the
> current KVM implementation. This bug is apparent only if the MOV-DR instruction
> is emulated or the host also debugs the guest.
> 
> This patch is a partial fix which enables DR6.RTM and DR7.RTM to be cleared and
> set respectively. It also sets DR6.RTM upon every debug exception. Obviously,
> it is not a complete fix, as debugging of RTM is still unsupported.
> 
> Signed-off-by: Nadav Amit <namit@cs.technion.ac.il>
> ---
>  arch/x86/include/asm/kvm_host.h |  8 +++++---
>  arch/x86/kvm/cpuid.h            |  8 ++++++++
>  arch/x86/kvm/vmx.c              |  4 ++--
>  arch/x86/kvm/x86.c              | 22 ++++++++++++++++------
>  4 files changed, 31 insertions(+), 11 deletions(-)
> 
> diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
> index b8a4480..a84eaf7 100644
> --- a/arch/x86/include/asm/kvm_host.h
> +++ b/arch/x86/include/asm/kvm_host.h
> @@ -152,14 +152,16 @@ enum {
>  
>  #define DR6_BD		(1 << 13)
>  #define DR6_BS		(1 << 14)
> -#define DR6_FIXED_1	0xffff0ff0
> -#define DR6_VOLATILE	0x0000e00f
> +#define DR6_RTM		(1 << 16)
> +#define DR6_FIXED_1	0xfffe0ff0
> +#define DR6_INIT	0xffff0ff0
> +#define DR6_VOLATILE	0x0001e00f
>  
>  #define DR7_BP_EN_MASK	0x000000ff
>  #define DR7_GE		(1 << 9)
>  #define DR7_GD		(1 << 13)
>  #define DR7_FIXED_1	0x00000400
> -#define DR7_VOLATILE	0xffff23ff
> +#define DR7_VOLATILE	0xffff2bff
>  
>  /* apic attention bits */
>  #define KVM_APIC_CHECK_VAPIC	0
> diff --git a/arch/x86/kvm/cpuid.h b/arch/x86/kvm/cpuid.h
> index f908731..a538059 100644
> --- a/arch/x86/kvm/cpuid.h
> +++ b/arch/x86/kvm/cpuid.h
> @@ -95,4 +95,12 @@ static inline bool guest_cpuid_has_gbpages(struct kvm_vcpu *vcpu)
>  	best = kvm_find_cpuid_entry(vcpu, 0x80000001, 0);
>  	return best && (best->edx & bit(X86_FEATURE_GBPAGES));
>  }
> +
> +static inline bool guest_cpuid_has_rtm(struct kvm_vcpu *vcpu)
> +{
> +	struct kvm_cpuid_entry2 *best;
> +
> +	best = kvm_find_cpuid_entry(vcpu, 7, 0);
> +	return best && (best->ebx & bit(X86_FEATURE_RTM));
> +}
>  #endif
> diff --git a/arch/x86/kvm/vmx.c b/arch/x86/kvm/vmx.c
> index 0c9569b..1fd3598 100644
> --- a/arch/x86/kvm/vmx.c
> +++ b/arch/x86/kvm/vmx.c
> @@ -4892,7 +4892,7 @@ static int handle_exception(struct kvm_vcpu *vcpu)
>  		if (!(vcpu->guest_debug &
>  		      (KVM_GUESTDBG_SINGLESTEP | KVM_GUESTDBG_USE_HW_BP))) {
>  			vcpu->arch.dr6 &= ~15;
> -			vcpu->arch.dr6 |= dr6;
> +			vcpu->arch.dr6 |= dr6 | DR6_RTM;
>  			if (!(dr6 & ~DR6_RESERVED)) /* icebp */
>  				skip_emulated_instruction(vcpu);
>  
> @@ -5151,7 +5151,7 @@ static int handle_dr(struct kvm_vcpu *vcpu)
>  			return 0;
>  		} else {
>  			vcpu->arch.dr7 &= ~DR7_GD;
> -			vcpu->arch.dr6 |= DR6_BD;
> +			vcpu->arch.dr6 |= DR6_BD | DR6_RTM;
>  			vmcs_writel(GUEST_DR7, vcpu->arch.dr7);
>  			kvm_queue_exception(vcpu, DB_VECTOR);
>  			return 1;
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index f750b69..fae064f 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -759,6 +759,15 @@ static void kvm_update_dr7(struct kvm_vcpu *vcpu)
>  		vcpu->arch.switch_db_regs |= KVM_DEBUGREG_BP_ENABLED;
>  }
>  
> +static u64 kvm_dr6_fixed(struct kvm_vcpu *vcpu)
> +{
> +	u64 fixed = DR6_FIXED_1;
> +
> +	if (!guest_cpuid_has_rtm(vcpu))
> +		fixed |= DR6_RTM;
> +	return fixed;
> +}
> +
>  static int __kvm_set_dr(struct kvm_vcpu *vcpu, int dr, unsigned long val)
>  {
>  	switch (dr) {
> @@ -774,7 +783,7 @@ static int __kvm_set_dr(struct kvm_vcpu *vcpu, int dr, unsigned long val)
>  	case 6:
>  		if (val & 0xffffffff00000000ULL)
>  			return -1; /* #GP */
> -		vcpu->arch.dr6 = (val & DR6_VOLATILE) | DR6_FIXED_1;
> +		vcpu->arch.dr6 = (val & DR6_VOLATILE) | kvm_dr6_fixed(vcpu);
>  		kvm_update_dr6(vcpu);
>  		break;
>  	case 5:
> @@ -5115,7 +5124,8 @@ static void kvm_vcpu_check_singlestep(struct kvm_vcpu *vcpu, unsigned long rflag
>  	 */
>  	if (unlikely(rflags & X86_EFLAGS_TF)) {
>  		if (vcpu->guest_debug & KVM_GUESTDBG_SINGLESTEP) {
> -			kvm_run->debug.arch.dr6 = DR6_BS | DR6_FIXED_1;
> +			kvm_run->debug.arch.dr6 = DR6_BS | DR6_FIXED_1 |
> +						  DR6_RTM;
>  			kvm_run->debug.arch.pc = vcpu->arch.singlestep_rip;
>  			kvm_run->debug.arch.exception = DB_VECTOR;
>  			kvm_run->exit_reason = KVM_EXIT_DEBUG;
> @@ -5128,7 +5138,7 @@ static void kvm_vcpu_check_singlestep(struct kvm_vcpu *vcpu, unsigned long rflag
>  			 * cleared by the processor".
>  			 */
>  			vcpu->arch.dr6 &= ~15;
> -			vcpu->arch.dr6 |= DR6_BS;
> +			vcpu->arch.dr6 |= DR6_BS | DR6_RTM;
>  			kvm_queue_exception(vcpu, DB_VECTOR);
>  		}
>  	}
> @@ -5147,7 +5157,7 @@ static bool kvm_vcpu_check_breakpoint(struct kvm_vcpu *vcpu, int *r)
>  					   vcpu->arch.eff_db);
>  
>  		if (dr6 != 0) {
> -			kvm_run->debug.arch.dr6 = dr6 | DR6_FIXED_1;
> +			kvm_run->debug.arch.dr6 = dr6 | DR6_FIXED_1 | DR6_RTM;
>  			kvm_run->debug.arch.pc = kvm_rip_read(vcpu) +
>  				get_segment_base(vcpu, VCPU_SREG_CS);
>  
> @@ -5165,7 +5175,7 @@ static bool kvm_vcpu_check_breakpoint(struct kvm_vcpu *vcpu, int *r)
>  
>  		if (dr6 != 0) {
>  			vcpu->arch.dr6 &= ~15;
> -			vcpu->arch.dr6 |= dr6;
> +			vcpu->arch.dr6 |= dr6 | DR6_RTM;
>  			kvm_queue_exception(vcpu, DB_VECTOR);
>  			*r = EMULATE_DONE;
>  			return true;
> @@ -6863,7 +6873,7 @@ void kvm_vcpu_reset(struct kvm_vcpu *vcpu)
>  	kvm_clear_exception_queue(vcpu);
>  
>  	memset(vcpu->arch.db, 0, sizeof(vcpu->arch.db));
> -	vcpu->arch.dr6 = DR6_FIXED_1;
> +	vcpu->arch.dr6 = DR6_INIT;
>  	kvm_update_dr6(vcpu);
>  	vcpu->arch.dr7 = DR7_FIXED_1;
>  	kvm_update_dr7(vcpu);
> 

Thanks, applying.

Paolo
