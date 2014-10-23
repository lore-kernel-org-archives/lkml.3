Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751341AbaJWFtU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Oct 2014 01:49:20 -0400
Received: from mga09.intel.com ([134.134.136.24]:19855 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750813AbaJWFtT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Oct 2014 01:49:19 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.04,773,1406617200"; 
   d="scan'208";a="623753599"
Date: Thu, 23 Oct 2014 13:49:13 +0800
From: Chao Peng <chao.p.peng@linux.intel.com>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: gleb@kernel.org, tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com,
        x86@kernel.org, fenghua.yu@intel.com, bp@suse.de,
        qiaowei.ren@intel.com, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org
Subject: Re: [PATCH] KVM: x86: Enable Intel AVX-512 for guest
Message-ID: <20141023054912.GA3135@pengc-linux.bj.intel.com>
Reply-To: Chao Peng <chao.p.peng@linux.intel.com>
References: <1413970524-12845-1-git-send-email-chao.p.peng@linux.intel.com>
 <5447843D.6090102@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5447843D.6090102@redhat.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 22, 2014 at 12:17:33PM +0200, Paolo Bonzini wrote:
> On 10/22/2014 11:35 AM, Chao Peng wrote:
> > Expose Intel AVX-512 feature bits to guest. Also add checks for
> > xcr0 AVX512 related bits according to spec:
> > http://download-software.intel.com/sites/default/files/managed/71/2e/319433-017.pdf
> > 
> > Signed-off-by: Chao Peng <chao.p.peng@linux.intel.com>
> 
> The patch looks good, but you also have to patch QEMU in order to
> save/restore the values of the registers.  IIRC the manual already
> details where the registers are in the XSAVE area, so it should be easy
> to get them in and out.  You can look at the MPX patches for an example.
> 
> In the meanwhile, kernel bits are
> 
> Reviewed-by: Paolo Bonzini <pbonzini@redhat.com>
> 
> Paolo

Thanks Paolo.

QEMU side patch is already sent out to QEMU list in the other thread.
Also accessible from url:
http://lists.nongnu.org/archive/html/qemu-devel/2014-10/msg02681.html

Chao
> 
> > ---
> >  arch/x86/include/asm/xsave.h |    1 +
> >  arch/x86/kvm/cpuid.c         |    3 ++-
> >  arch/x86/kvm/x86.c           |    6 ++++++
> >  arch/x86/kvm/x86.h           |    3 ++-
> >  4 files changed, 11 insertions(+), 2 deletions(-)
> > 
> > diff --git a/arch/x86/include/asm/xsave.h b/arch/x86/include/asm/xsave.h
> > index 7e7a79a..5fa9770 100644
> > --- a/arch/x86/include/asm/xsave.h
> > +++ b/arch/x86/include/asm/xsave.h
> > @@ -16,6 +16,7 @@
> >  #define XSTATE_Hi16_ZMM		0x80
> >  
> >  #define XSTATE_FPSSE	(XSTATE_FP | XSTATE_SSE)
> > +#define XSTATE_AVX512	(XSTATE_OPMASK | XSTATE_ZMM_Hi256 | XSTATE_Hi16_ZMM)
> >  /* Bit 63 of XCR0 is reserved for future expansion */
> >  #define XSTATE_EXTEND_MASK	(~(XSTATE_FPSSE | (1ULL << 63)))
> >  
> > diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
> > index 976e3a5..20d8321 100644
> > --- a/arch/x86/kvm/cpuid.c
> > +++ b/arch/x86/kvm/cpuid.c
> > @@ -317,7 +317,8 @@ static inline int __do_cpuid_ent(struct kvm_cpuid_entry2 *entry, u32 function,
> >  	const u32 kvm_supported_word9_x86_features =
> >  		F(FSGSBASE) | F(BMI1) | F(HLE) | F(AVX2) | F(SMEP) |
> >  		F(BMI2) | F(ERMS) | f_invpcid | F(RTM) | f_mpx | F(RDSEED) |
> > -		F(ADX) | F(SMAP);
> > +		F(ADX) | F(SMAP) | F(AVX512F) | F(AVX512PF) | F(AVX512ER) |
> > +		F(AVX512CD);
> >  
> >  	/* all calls to cpuid_count() should be made on the same cpu */
> >  	get_cpu();
> > diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> > index 5430e4b..3d77b88 100644
> > --- a/arch/x86/kvm/x86.c
> > +++ b/arch/x86/kvm/x86.c
> > @@ -651,6 +651,12 @@ int __kvm_set_xcr(struct kvm_vcpu *vcpu, u32 index, u64 xcr)
> >  	if ((!(xcr0 & XSTATE_BNDREGS)) != (!(xcr0 & XSTATE_BNDCSR)))
> >  		return 1;
> >  
> > +	if (xcr0 & XSTATE_AVX512) {
> > +		if (!(xcr0 & XSTATE_YMM))
> > +			return 1;
> > +		if ((xcr0 & XSTATE_AVX512) != XSTATE_AVX512)
> > +			return 1;
> > +	}
> >  	kvm_put_guest_xcr0(vcpu);
> >  	vcpu->arch.xcr0 = xcr0;
> >  
> > diff --git a/arch/x86/kvm/x86.h b/arch/x86/kvm/x86.h
> > index 7cb9c45..cc1d61a 100644
> > --- a/arch/x86/kvm/x86.h
> > +++ b/arch/x86/kvm/x86.h
> > @@ -162,7 +162,8 @@ int kvm_write_guest_virt_system(struct x86_emulate_ctxt *ctxt,
> >  bool kvm_mtrr_valid(struct kvm_vcpu *vcpu, u32 msr, u64 data);
> >  
> >  #define KVM_SUPPORTED_XCR0     (XSTATE_FP | XSTATE_SSE | XSTATE_YMM \
> > -				| XSTATE_BNDREGS | XSTATE_BNDCSR)
> > +				| XSTATE_BNDREGS | XSTATE_BNDCSR \
> > +				| XSTATE_AVX512)
> >  extern u64 host_xcr0;
> >  
> >  extern u64 kvm_supported_xcr0(void);
> > 
