Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754003AbaGHPPt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jul 2014 11:15:49 -0400
Received: from mail-qc0-f182.google.com ([209.85.216.182]:40875 "EHLO
	mail-qc0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751709AbaGHPPq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jul 2014 11:15:46 -0400
Date: Tue, 8 Jul 2014 11:15:43 -0400
From: "Gabriel L. Somlo" <gsomlo@gmail.com>
To: KVM <kvm@vger.kernel.org>
Cc: "Michael S. Tsirkin" <mst@redhat.com>, Gleb Natapov <gleb@kernel.org>,
        Eric Northup <digitaleric@google.com>,
        Nadav Amit <namit@cs.technion.ac.il>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        the arch/x86 maintainers <x86@kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        nadav.amit@gmail.com, joro@8bytes.org, agraf@suse.de
Subject: Ping: Re: [PATCH] Revert "kvm: x86: emulate monitor and mwait
 instructions as nop"
Message-ID: <20140708151542.GF1688@ERROL.INI.CMU.EDU>
References: <20140619135935.GG1695@ERROL.INI.CMU.EDU>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140619135935.GG1695@ERROL.INI.CMU.EDU>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Any decision on this ? If we're going to revert monitor/mwait as nop,
it's hopefully not too late to avoid having it show up in an official
(3.16 ?) kernel release...

Thanks,
--Gabriel

On Thu, Jun 19, 2014 at 09:59:35AM -0400, Gabriel L. Somlo wrote:
> This reverts commit 87c00572ba05aa8c9db118da75c608f47eb10b9e.
> 
> OS X <= 10.7.* are the only known guests which realistically required
> this functionality. As it turns out, OS X can be told to forego using
> monitor/mwait by passing it "idlehalt=0" as a kernel argument, so we're
> better off removing this hack from KVM altogether, at least for now.
> 
> Signed-off-by: Gabriel L. Somlo <somlo@cmu.edu>
> Acked-by: Michael S. Tsirkin <mst@redhat.com>
> ---
> 
> OK, here's the formal proposal to revert my original monitor/mwait hack...
> I wish I knew about the "idlehalt=0" before I submitted it, but such is life.
> Depending on how those of you higher up the food chain feel, I can tolerate
> leaving the hack in if it's never on by default (i.e. no CPUID advertisement),
> but would feel better if we could simply undo this until we have a better
> solution, something less controversial...
> 
> Thanks, and sorry for all the noise,
>   Gabriel
> 
>  arch/x86/kvm/cpuid.c |  2 --
>  arch/x86/kvm/svm.c   | 28 ++++++++--------------------
>  arch/x86/kvm/vmx.c   | 20 ++++----------------
>  3 files changed, 12 insertions(+), 38 deletions(-)
> 
> diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
> index 38a0afe..17b42fa 100644
> --- a/arch/x86/kvm/cpuid.c
> +++ b/arch/x86/kvm/cpuid.c
> @@ -283,8 +283,6 @@ static inline int __do_cpuid_ent(struct kvm_cpuid_entry2 *entry, u32 function,
>  		0 /* Reserved */ | f_lm | F(3DNOWEXT) | F(3DNOW);
>  	/* cpuid 1.ecx */
>  	const u32 kvm_supported_word4_x86_features =
> -		/* NOTE: MONITOR (and MWAIT) are emulated as NOP,
> -		 * but *not* advertised to guests via CPUID ! */
>  		F(XMM3) | F(PCLMULQDQ) | 0 /* DTES64, MONITOR */ |
>  		0 /* DS-CPL, VMX, SMX, EST */ |
>  		0 /* TM2 */ | F(SSSE3) | 0 /* CNXT-ID */ | 0 /* Reserved */ |
> diff --git a/arch/x86/kvm/svm.c b/arch/x86/kvm/svm.c
> index ec8366c..6b88b6a 100644
> --- a/arch/x86/kvm/svm.c
> +++ b/arch/x86/kvm/svm.c
> @@ -2763,6 +2763,12 @@ static int xsetbv_interception(struct vcpu_svm *svm)
>  	return 1;
>  }
>  
> +static int invalid_op_interception(struct vcpu_svm *svm)
> +{
> +	kvm_queue_exception(&svm->vcpu, UD_VECTOR);
> +	return 1;
> +}
> +
>  static int task_switch_interception(struct vcpu_svm *svm)
>  {
>  	u16 tss_selector;
> @@ -3274,24 +3280,6 @@ static int pause_interception(struct vcpu_svm *svm)
>  	return 1;
>  }
>  
> -static int nop_interception(struct vcpu_svm *svm)
> -{
> -	skip_emulated_instruction(&(svm->vcpu));
> -	return 1;
> -}
> -
> -static int monitor_interception(struct vcpu_svm *svm)
> -{
> -	printk_once(KERN_WARNING "kvm: MONITOR instruction emulated as NOP!\n");
> -	return nop_interception(svm);
> -}
> -
> -static int mwait_interception(struct vcpu_svm *svm)
> -{
> -	printk_once(KERN_WARNING "kvm: MWAIT instruction emulated as NOP!\n");
> -	return nop_interception(svm);
> -}
> -
>  static int (*const svm_exit_handlers[])(struct vcpu_svm *svm) = {
>  	[SVM_EXIT_READ_CR0]			= cr_interception,
>  	[SVM_EXIT_READ_CR3]			= cr_interception,
> @@ -3349,8 +3337,8 @@ static int (*const svm_exit_handlers[])(struct vcpu_svm *svm) = {
>  	[SVM_EXIT_CLGI]				= clgi_interception,
>  	[SVM_EXIT_SKINIT]			= skinit_interception,
>  	[SVM_EXIT_WBINVD]                       = emulate_on_interception,
> -	[SVM_EXIT_MONITOR]			= monitor_interception,
> -	[SVM_EXIT_MWAIT]			= mwait_interception,
> +	[SVM_EXIT_MONITOR]			= invalid_op_interception,
> +	[SVM_EXIT_MWAIT]			= invalid_op_interception,
>  	[SVM_EXIT_XSETBV]			= xsetbv_interception,
>  	[SVM_EXIT_NPF]				= pf_interception,
>  };
> diff --git a/arch/x86/kvm/vmx.c b/arch/x86/kvm/vmx.c
> index 801332e..163958f 100644
> --- a/arch/x86/kvm/vmx.c
> +++ b/arch/x86/kvm/vmx.c
> @@ -5672,24 +5672,12 @@ static int handle_pause(struct kvm_vcpu *vcpu)
>  	return 1;
>  }
>  
> -static int handle_nop(struct kvm_vcpu *vcpu)
> +static int handle_invalid_op(struct kvm_vcpu *vcpu)
>  {
> -	skip_emulated_instruction(vcpu);
> +	kvm_queue_exception(vcpu, UD_VECTOR);
>  	return 1;
>  }
>  
> -static int handle_mwait(struct kvm_vcpu *vcpu)
> -{
> -	printk_once(KERN_WARNING "kvm: MWAIT instruction emulated as NOP!\n");
> -	return handle_nop(vcpu);
> -}
> -
> -static int handle_monitor(struct kvm_vcpu *vcpu)
> -{
> -	printk_once(KERN_WARNING "kvm: MONITOR instruction emulated as NOP!\n");
> -	return handle_nop(vcpu);
> -}
> -
>  /*
>   * To run an L2 guest, we need a vmcs02 based on the L1-specified vmcs12.
>   * We could reuse a single VMCS for all the L2 guests, but we also want the
> @@ -6651,8 +6639,8 @@ static int (*const kvm_vmx_exit_handlers[])(struct kvm_vcpu *vcpu) = {
>  	[EXIT_REASON_EPT_VIOLATION]	      = handle_ept_violation,
>  	[EXIT_REASON_EPT_MISCONFIG]           = handle_ept_misconfig,
>  	[EXIT_REASON_PAUSE_INSTRUCTION]       = handle_pause,
> -	[EXIT_REASON_MWAIT_INSTRUCTION]	      = handle_mwait,
> -	[EXIT_REASON_MONITOR_INSTRUCTION]     = handle_monitor,
> +	[EXIT_REASON_MWAIT_INSTRUCTION]	      = handle_invalid_op,
> +	[EXIT_REASON_MONITOR_INSTRUCTION]     = handle_invalid_op,
>  	[EXIT_REASON_INVEPT]                  = handle_invept,
>  };
>  
> -- 
> 1.9.3
> 
