Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752347AbaKZMIK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Nov 2014 07:08:10 -0500
Received: from mx1.redhat.com ([209.132.183.28]:43841 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750895AbaKZMII (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Nov 2014 07:08:08 -0500
Date: Wed, 26 Nov 2014 13:07:57 +0100
From: Radim =?utf-8?B?S3LEjW3DocWZ?= <rkrcmar@redhat.com>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        wanpeng.li@linux.intel.com, namit@cs.technion.ac.il,
        hpa@linux.intel.com, Fenghua Yu <fenghua.yu@intel.com>
Subject: Re: [CFT PATCH v2 2/2] KVM: x86: support XSAVES usage in the host
Message-ID: <20141126120753.GA31982@potion.redhat.com>
References: <1416847414-22253-1-git-send-email-pbonzini@redhat.com>
 <1416847414-22253-3-git-send-email-pbonzini@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1416847414-22253-3-git-send-email-pbonzini@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2014-11-24 17:43+0100, Paolo Bonzini:
> Userspace is expecting non-compacted format for KVM_GET_XSAVE, but
> struct xsave_struct might be using the compacted format.  Convert
> in order to preserve userspace ABI.
> 
> Likewise, userspace is passing non-compacted format for KVM_SET_XSAVE
> but the kernel will pass it to XRSTORS, and we need to convert back.

Future instructions might force us to calling xsave/xrstor directly, so
we could do that even now and save the explicit conversion ...

What I mean is:  we could be using the native xsave.*/xrstor.* while in
kernel and use xsave/xrstor for communication with userspace.
Hardware would take care of everything in the conversion.

get_xsave = native_xrstor(guest_xsave);  xsave(aligned_userspace_buffer)
set_xsave = xrstor(aligned_userspace_buffer);  native_xsave(guest_xsave)

Could that work?

> Fixes: f31a9f7c71691569359fa7fb8b0acaa44bce0324
> Cc: Fenghua Yu <fenghua.yu@intel.com>
> Cc: H. Peter Anvin <hpa@linux.intel.com>
> Cc: Nadav Amit <namit@cs.technion.ac.il>
> Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
> ---
>  arch/x86/kvm/x86.c | 87 +++++++++++++++++++++++++++++++++++++++++++++++++-----
>  1 file changed, 80 insertions(+), 7 deletions(-)
> 
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index 08b5657e57ed..373b0ab9a32e 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -3132,15 +3132,89 @@ static int kvm_vcpu_ioctl_x86_set_debugregs(struct kvm_vcpu *vcpu,
>  	return 0;
>  }
>  
> +#define XSTATE_COMPACTION_ENABLED (1ULL << 63)

(arch/x86/include/asm/xsave.h)

> +
> +static void fill_xsave(u8 *dest, struct kvm_vcpu *vcpu)
> +{
> +	struct xsave_struct *xsave = &vcpu->arch.guest_fpu.state->xsave;
> +	u64 xstate_bv = vcpu->arch.guest_supported_xcr0 | XSTATE_FPSSE;

(I don't think this is necessary.  We haven't modified it before and
 userspace worked, so we can save explicit copying of initialized data.)

> +	u64 valid;
> +
> +	/*
> +	 * Copy legacy XSAVE area, to avoid complications with CPUID
> +	 * leaves 0 and 1 in the loop below.
> +	 */
> +	memcpy(dest, xsave, XSAVE_HDR_OFFSET);

(Yeah, there is an exception for SSE;  I don't see any effect it has on
 restore though, so we could probably ignore it as well.)

> +
> +	/* Set XSTATE_BV */
> +	*(u64 *)(dest + XSAVE_HDR_OFFSET) = xstate_bv;
> +
> +	/*
> +	 * Copy each region from the possibly compacted offset to the
> +	 * non-compacted offset.
> +	 */
> +	valid = xstate_bv & ~XSTATE_FPSSE;

(We could read xstate_bv from xsave and & it with supported.)

> +	while (valid) {
> +		u64 feature = valid & -valid;
> +		int index = fls64(feature) - 1;
> +		void *src = get_xsave_addr(xsave, feature);

(xcomp_bv never changes, so it works for compacted xsave.)

> +
> +		if (src) {
> +			u32 size, offset, ecx, edx;
> +			cpuid_count(XSTATE_CPUID, index,
> +				    &size, &offset, &ecx, &edx);

(ok, setup_xstate_features() has the same code.)

> +			memcpy(dest + offset, src, size);
> +		}
> +
> +		valid -= feature;
> +	}
> +}
> +
> +static void load_xsave(struct kvm_vcpu *vcpu, u8 *src)
> +{
> +	struct xsave_struct *xsave = &vcpu->arch.guest_fpu.state->xsave;
> +	u64 xstate_bv = *(u64 *)(src + XSAVE_HDR_OFFSET);
> +	u64 valid;
> +
> +	/*
> +	 * Copy legacy XSAVE area, to avoid complications with CPUID
> +	 * leaves 0 and 1 in the loop below.
> +	 */
> +	memcpy(xsave, src, XSAVE_HDR_OFFSET);
> +
> +	/* Set XSTATE_BV and possibly XCOMP_BV.  */
> +	xsave->xsave_hdr.xstate_bv = xstate_bv;
> +	if (cpu_has_xsaves)
> +		xsave->xsave_hdr.xcomp_bv = host_xcr0 | XSTATE_COMPACTION_ENABLED;

Userspace can trigger a #GP if it passes xstate_bv bit that isn't in
xcomp_bv, so we could & them back into xstate_bv as well.

(Linux probably won't start using IA32_XSS, so using just xcr0 is fine.)

> +
> +	/*
> +	 * Copy each region from the non-compacted offset to the
> +	 * possibly compacted offset.
> +	 */
> +	valid = xstate_bv & ~XSTATE_FPSSE;
> +	while (valid) {
> +		u64 feature = valid & -valid;
> +		int index = fls64(feature) - 1;
> +		void *dest = get_xsave_addr(xsave, feature);
> +
> +		if (dest) {
> +			u32 size, offset, ecx, edx;
> +			cpuid_count(XSTATE_CPUID, index,
> +				    &size, &offset, &ecx, &edx);
> +			memcpy(dest, src + offset, size);
> +		} else
> +			WARN_ON_ONCE(1);
> +
> +		valid -= feature;
> +	}
> +}
> +
>  static void kvm_vcpu_ioctl_x86_get_xsave(struct kvm_vcpu *vcpu,
>  					 struct kvm_xsave *guest_xsave)
>  {
>  	if (cpu_has_xsave) {
> -		memcpy(guest_xsave->region,
> -			&vcpu->arch.guest_fpu.state->xsave,
> -			vcpu->arch.guest_xstate_size);
> -		*(u64 *)&guest_xsave->region[XSAVE_HDR_OFFSET / sizeof(u32)] &=
> -			vcpu->arch.guest_supported_xcr0 | XSTATE_FPSSE;
> +		memset(guest_xsave, 0, sizeof(struct kvm_xsave));
> +		fill_xsave((u8 *) guest_xsave->region, vcpu);
>  	} else {
>  		memcpy(guest_xsave->region,
>  			&vcpu->arch.guest_fpu.state->fxsave,
> @@ -3164,8 +3238,7 @@ static int kvm_vcpu_ioctl_x86_set_xsave(struct kvm_vcpu *vcpu,
>  		 */
>  		if (xstate_bv & ~kvm_supported_xcr0())
>  			return -EINVAL;
> -		memcpy(&vcpu->arch.guest_fpu.state->xsave,
> -			guest_xsave->region, vcpu->arch.guest_xstate_size);
> +		load_xsave(vcpu, (u8 *)guest_xsave->region);
>  	} else {
>  		if (xstate_bv & ~XSTATE_FPSSE)
>  			return -EINVAL;

Likely works,

Reviewed-by: Radim Krčmář <rkrcmar@redhat.com>
