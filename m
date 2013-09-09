Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755531Ab3IIQ6K (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Sep 2013 12:58:10 -0400
Received: from mx1.redhat.com ([209.132.183.28]:36569 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755654Ab3IIQ56 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Sep 2013 12:57:58 -0400
Date: Mon, 9 Sep 2013 19:57:55 +0300
From: Gleb Natapov <gleb@redhat.com>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Subject: Re: [PATCH] KVM: x86: prevent setting unsupported XSAVE states
Message-ID: <20130909165755.GA4008@redhat.com>
References: <1378383714-9723-2-git-send-email-pbonzini@redhat.com>
 <20130908095446.GE17294@redhat.com>
 <522DD6AB.1030303@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <522DD6AB.1030303@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 09, 2013 at 04:09:47PM +0200, Paolo Bonzini wrote:
> Il 08/09/2013 11:54, Gleb Natapov ha scritto:
> > On Thu, Sep 05, 2013 at 02:21:54PM +0200, Paolo Bonzini wrote:
> >> A guest can still attempt to save and restore XSAVE states even if they
> >> have been masked in CPUID leaf 0Dh.  This usually is not visible to
> >> the guest, but is still wrong: "Any attempt to set a reserved bit (as
> >> determined by the contents of EAX and EDX after executing CPUID with
> >> EAX=0DH, ECX= 0H) in XCR0 for a given processor will result in a #GP
> >> exception".
> >>
> >> The patch also performs the same checks as __kvm_set_xcr in KVM_SET_XSAVE.
> >> This catches migration from newer to older kernel/processor before the
> >> guest starts running.
> >>
> >> Cc: kvm@vger.kernel.org
> >> Cc: Gleb Natapov <gleb@redhat.com>
> >> Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
> >> ---
> >>  arch/x86/kvm/cpuid.c |  2 +-
> >>  arch/x86/kvm/x86.c   | 10 ++++++++--
> >>  arch/x86/kvm/x86.h   |  1 +
> >>  3 files changed, 10 insertions(+), 3 deletions(-)
> >>
> >> diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
> >> index a20ecb5..d7c465d 100644
> >> --- a/arch/x86/kvm/cpuid.c
> >> +++ b/arch/x86/kvm/cpuid.c
> >> @@ -182,7 +182,7 @@ static bool supported_xcr0_bit(unsigned bit)
> >>  {
> >>  	u64 mask = ((u64)1 << bit);
> >>  
> >> -	return mask & (XSTATE_FP | XSTATE_SSE | XSTATE_YMM) & host_xcr0;
> >> +	return mask & KVM_SUPPORTED_XCR0 & host_xcr0;
> >>  }
> >>  
> >>  #define F(x) bit(X86_FEATURE_##x)
> >> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> >> index 3625798..801a882 100644
> >> --- a/arch/x86/kvm/x86.c
> >> +++ b/arch/x86/kvm/x86.c
> >> @@ -586,6 +586,8 @@ int __kvm_set_xcr(struct kvm_vcpu *vcpu, u32 index, u64 xcr)
> >>  		return 1;
> >>  	if ((xcr0 & XSTATE_YMM) && !(xcr0 & XSTATE_SSE))
> >>  		return 1;
> >> +	if (xcr0 & ~KVM_SUPPORTED_XCR0)
> >> +		return 1;
> > Shouldn't we check guest's cpuid here?
> 
> Yes.
> 
> >>  	if (xcr0 & ~host_xcr0)
> >>  		return 1;
> >>  	kvm_put_guest_xcr0(vcpu);
> >> @@ -2980,10 +2982,14 @@ static int kvm_vcpu_ioctl_x86_set_xsave(struct kvm_vcpu *vcpu,
> >>  	u64 xstate_bv =
> >>  		*(u64 *)&guest_xsave->region[XSAVE_HDR_OFFSET / sizeof(u32)];
> >>  
> >> -	if (cpu_has_xsave)
> >> +	if (cpu_has_xsave) {
> >> +		if (xstate_bv & ~KVM_SUPPORTED_XCR0)
> >> +			return -EINVAL;
> >> +		if (xstate_bv & ~host_xcr0)
> >> +			return -EINVAL;
> > And here?
> 
> Here it'd be nice, but we cannot due to backwards compatibility.  We
> agreed to change KVM_GET_XSAVE and make it only report states that are
> included in CPUID, but we still need to do migration from old kernels
> that report all states.
> 
> If we change KVM_SET_XSAVE to look at CPUID, and the CPUID does not
> include AVX, migration will fail from old kernel (KVM_GET_XSAVE reports
> all states) to new kernel (KVM_SET_XSAVES checks against CPUID).
> 
Yeah :(

--
			Gleb.
