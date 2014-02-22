Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751947AbaBVOzk (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Feb 2014 09:55:40 -0500
Received: from mx1.redhat.com ([209.132.183.28]:6739 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751868AbaBVOzX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Feb 2014 09:55:23 -0500
Message-ID: <5308BA54.2040807@redhat.com>
Date: Sat, 22 Feb 2014 15:55:16 +0100
From: Paolo Bonzini <pbonzini@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: "Liu, Jinsong" <jinsong.liu@intel.com>
CC: "gleb@redhat.com" <gleb@redhat.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "qemu-devel@nongnu.org" <qemu-devel@nongnu.org>
Subject: Re: [PATCH] KVM: x86: Fix xsave cpuid exposing bug
References: <DE8DF0795D48FD4CA783C40EC829233501509B5F@SHSMSX101.ccr.corp.intel.com>
In-Reply-To: <DE8DF0795D48FD4CA783C40EC829233501509B5F@SHSMSX101.ccr.corp.intel.com>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Il 21/02/2014 18:39, Liu, Jinsong ha scritto:
> From 00c920c96127d20d4c3bb790082700ae375c39a0 Mon Sep 17 00:00:00 2001
> From: Liu Jinsong <jinsong.liu@intel.com>
> Date: Fri, 21 Feb 2014 23:47:18 +0800
> Subject: [PATCH] KVM: x86: Fix xsave cpuid exposing bug
>
> EBX of cpuid(0xD, 0) is dynamic per XCR0 features enable/disable.
> Bit 63 of XCR0 is reserved for future expansion.
>
> Signed-off-by: Liu Jinsong <jinsong.liu@intel.com>
> ---
>  arch/x86/include/asm/xsave.h |    2 ++
>  arch/x86/kvm/cpuid.c         |    6 +++---
>  arch/x86/kvm/x86.c           |    7 +++++--
>  3 files changed, 10 insertions(+), 5 deletions(-)
>
> diff --git a/arch/x86/include/asm/xsave.h b/arch/x86/include/asm/xsave.h
> index 5547389..dcd047b 100644
> --- a/arch/x86/include/asm/xsave.h
> +++ b/arch/x86/include/asm/xsave.h
> @@ -13,6 +13,8 @@
>  #define XSTATE_BNDCSR	0x10
>
>  #define XSTATE_FPSSE	(XSTATE_FP | XSTATE_SSE)
> +/* Bit 63 of XCR0 is reserved for future expansion */
> +#define XSTATE_EXTEND_MASK	(~(XSTATE_FPSSE | (1ULL << 63)))
>
>  #define FXSAVE_SIZE	512
>
> diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
> index a951ae4..b241325 100644
> --- a/arch/x86/kvm/cpuid.c
> +++ b/arch/x86/kvm/cpuid.c
> @@ -28,7 +28,7 @@ static u32 xstate_required_size(u64 xstate_bv)
>  	int feature_bit = 0;
>  	u32 ret = XSAVE_HDR_SIZE + XSAVE_HDR_OFFSET;
>
> -	xstate_bv &= ~XSTATE_FPSSE;
> +	xstate_bv &= XSTATE_EXTEND_MASK;
>  	while (xstate_bv) {
>  		if (xstate_bv & 0x1) {
>  		        u32 eax, ebx, ecx, edx;
> @@ -74,8 +74,8 @@ void kvm_update_cpuid(struct kvm_vcpu *vcpu)
>  		vcpu->arch.guest_supported_xcr0 =
>  			(best->eax | ((u64)best->edx << 32)) &
>  			host_xcr0 & KVM_SUPPORTED_XCR0;
> -		vcpu->arch.guest_xstate_size =
> -			xstate_required_size(vcpu->arch.guest_supported_xcr0);
> +		vcpu->arch.guest_xstate_size = best->ebx =
> +			xstate_required_size(vcpu->arch.xcr0);
>  	}
>
>  	kvm_pmu_cpuid_update(vcpu);
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index 39c28f0..7c52acb 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -595,13 +595,13 @@ static void kvm_put_guest_xcr0(struct kvm_vcpu *vcpu)
>
>  int __kvm_set_xcr(struct kvm_vcpu *vcpu, u32 index, u64 xcr)
>  {
> -	u64 xcr0;
> +	u64 xcr0 = xcr;
> +	u64 old_xcr0 = vcpu->arch.xcr0;
>  	u64 valid_bits;
>
>  	/* Only support XCR_XFEATURE_ENABLED_MASK(xcr0) now  */
>  	if (index != XCR_XFEATURE_ENABLED_MASK)
>  		return 1;
> -	xcr0 = xcr;
>  	if (!(xcr0 & XSTATE_FP))
>  		return 1;
>  	if ((xcr0 & XSTATE_YMM) && !(xcr0 & XSTATE_SSE))
> @@ -618,6 +618,9 @@ int __kvm_set_xcr(struct kvm_vcpu *vcpu, u32 index, u64 xcr)
>
>  	kvm_put_guest_xcr0(vcpu);
>  	vcpu->arch.xcr0 = xcr0;
> +
> +	if ((xcr0 ^ old_xcr0) & XSTATE_EXTEND_MASK)
> +		kvm_update_cpuid(vcpu);
>  	return 0;
>  }
>
>

Applied to kvm/queue, thanks.

Paolo

