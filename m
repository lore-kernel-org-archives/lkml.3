Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751415AbaEZDpE (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 May 2014 23:45:04 -0400
Received: from mga02.intel.com ([134.134.136.20]:51326 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750829AbaEZDpB convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 May 2014 23:45:01 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.98,909,1392192000"; 
   d="scan'208";a="517623011"
From: "Zhang, Yang Z" <yang.z.zhang@intel.com>
To: Paolo Bonzini <pbonzini@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
CC: "mtosatti@redhat.com" <mtosatti@redhat.com>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>
Subject: RE: [PATCH] KVM: lapic: sync highest ISR to hardware apic on EOI
Thread-Topic: [PATCH] KVM: lapic: sync highest ISR to hardware apic on EOI
Thread-Index: AQHPdpaiz0U4PEBytESNOv6ntY3j3ptSOodg
Date: Mon, 26 May 2014 03:44:53 +0000
Message-ID: <A9667DDFB95DB7438FA9D7D576C3D87E0AAD347A@SHSMSX104.ccr.corp.intel.com>
References: <1400856713-18628-1-git-send-email-pbonzini@redhat.com>
In-Reply-To: <1400856713-18628-1-git-send-email-pbonzini@redhat.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.239.127.40]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Paolo Bonzini wrote on 2014-05-23:
> When Hyper-V enlightenments are in effect, Windows prefers to issue an
> Hyper-V MSR write to issue an EOI rather than an x2apic MSR write.
> The Hyper-V MSR write is not handled by the processor, and besides
> being slower, this also causes bugs with APIC virtualization.  The
> reason is that on EOI the processor will modify the highest in-service
> interrupt (SVI) field of the VMCS, as explained in section 29.1.4 of
> the SDM.
> 

Not only SVI update. It also includes ISR and PPR update. During PPR update, a new pending interrupt may be recognized and inject to guest.

> We need to do the same, and be careful not to muck with the isr_count
> and highest_isr_cache fields that are unused when virtual interrupt
> delivery is enabled.
> 
> Cc: stable@vger.kernel.org
> Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
> ---
>  arch/x86/kvm/lapic.c |   62
> ++++++++++++++++++++++++++++++++++---------------
>  1 files changed, 43 insertions(+), 19 deletions(-)
> 
> diff --git a/arch/x86/kvm/lapic.c b/arch/x86/kvm/lapic.c
> index 9736529..0069118 100644
> --- a/arch/x86/kvm/lapic.c
> +++ b/arch/x86/kvm/lapic.c
> @@ -360,6 +360,8 @@ static inline void apic_clear_irr(int vec, struct
> kvm_lapic *apic)
> 
>  static inline void apic_set_isr(int vec, struct kvm_lapic *apic)
>  {
> +	/* Note that we never get here with APIC virtualization enabled.  */
> +
>  	if (!__apic_test_and_set_vector(vec, apic->regs + APIC_ISR))
>  		++apic->isr_count;
>  	BUG_ON(apic->isr_count > MAX_APIC_VECTOR);
> @@ -371,12 +373,48 @@ static inline void apic_set_isr(int vec, struct
> kvm_lapic *apic)
>  	apic->highest_isr_cache = vec;
>  }
> 
> +static inline int apic_find_highest_isr(struct kvm_lapic *apic)
> +{
> +	int result;
> +
> +	/*
> +	 * Note that isr_count is always 1, and highest_isr_cache
> +	 * is always -1, with APIC virtualization enabled.
> +	 */
> +	if (!apic->isr_count)
> +		return -1;
> +	if (likely(apic->highest_isr_cache != -1))
> +		return apic->highest_isr_cache;
> +
> +	result = find_highest_vector(apic->regs + APIC_ISR);
> +	ASSERT(result == -1 || result >= 16);
> +
> +	return result;
> +}
> +
>  static inline void apic_clear_isr(int vec, struct kvm_lapic *apic)
>  {
> -	if (__apic_test_and_clear_vector(vec, apic->regs + APIC_ISR))
> +	struct kvm_vcpu *vcpu;
> +	if (!__apic_test_and_clear_vector(vec, apic->regs + APIC_ISR))
> +		return;
> +
> +	vcpu = apic->vcpu;
> +
> +	/*
> +	 * We do get here for APIC virtualization enabled if the guest
> +	 * uses the Hyper-V APIC enlightenment.  In this case we may need
> +	 * to trigger a new interrupt delivery by writing the SVI field;
> +	 * on the other hand isr_count and highest_isr_cache are unused
> +	 * and must be left alone.
> +	 */
> +	if (unlikely(kvm_apic_vid_enabled(vcpu->kvm)))
> +		kvm_x86_ops->hwapic_isr_update(vcpu->kvm,
> +					       apic_find_highest_isr(apic));

If there is a pending interrupt, will it be recognized? I am not looking into the Hyper-V enlightenments code, not sure whether it already covers interrupt recognition. But if it doesn't do it, then we need to do it.

> +	else {
>  		--apic->isr_count;
> -	BUG_ON(apic->isr_count < 0);
> -	apic->highest_isr_cache = -1;
> +		BUG_ON(apic->isr_count < 0);
> +		apic->highest_isr_cache = -1;
> +	}
>  }
> 
>  int kvm_lapic_find_highest_irr(struct kvm_vcpu *vcpu)
> @@ -456,22 +494,6 @@ static void pv_eoi_clr_pending(struct kvm_vcpu
> *vcpu)
>  	__clear_bit(KVM_APIC_PV_EOI_PENDING, &vcpu->arch.apic_attention);
>  }
> 
> -static inline int apic_find_highest_isr(struct kvm_lapic *apic)
> -{
> -	int result;
> -
> -	/* Note that isr_count is always 1 with vid enabled */
> -	if (!apic->isr_count)
> -		return -1;
> -	if (likely(apic->highest_isr_cache != -1))
> -		return apic->highest_isr_cache;
> -
> -	result = find_highest_vector(apic->regs + APIC_ISR);
> -	ASSERT(result == -1 || result >= 16);
> -
> -	return result;
> -}
> -
>  void kvm_apic_update_tmr(struct kvm_vcpu *vcpu, u32 *tmr)
>  {
>  	struct kvm_lapic *apic = vcpu->arch.apic;
> @@ -1605,6 +1627,8 @@ int kvm_get_apic_interrupt(struct kvm_vcpu *vcpu)
>  	int vector = kvm_apic_has_interrupt(vcpu);
>  	struct kvm_lapic *apic = vcpu->arch.apic;
> 
> +	/* Note that we never get here with APIC virtualization enabled.  */
> +
>  	if (vector == -1)
>  		return -1;
> 
> --
> 1.7.1


Best regards,
Yang


