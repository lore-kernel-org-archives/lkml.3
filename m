Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753556AbaFRQcY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jun 2014 12:32:24 -0400
Received: from mx1.redhat.com ([209.132.183.28]:52555 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753323AbaFRQcV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jun 2014 12:32:21 -0400
Message-ID: <53A1BF03.7080408@redhat.com>
Date: Wed, 18 Jun 2014 18:32:03 +0200
From: Paolo Bonzini <pbonzini@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Nadav Amit <namit@cs.technion.ac.il>
CC: gleb@kernel.org, tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com,
        x86@kernel.org, linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        joro@8bytes.org
Subject: Re: [PATCH 3/3] KVM: x86: correct mwait and monitor emulation
References: <1403101176-23664-1-git-send-email-namit@cs.technion.ac.il> <1403101176-23664-4-git-send-email-namit@cs.technion.ac.il>
In-Reply-To: <1403101176-23664-4-git-send-email-namit@cs.technion.ac.il>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Il 18/06/2014 16:19, Nadav Amit ha scritto:
> mwait and monitor are currently handled as nop. Considering this behavior, they
> should still be handled correctly, i.e., check execution conditions and generate
> exceptions when required. mwait and monitor may also be executed in real-mode
> and are not handled in that case.  This patch performs the emulation of
> monitor-mwait according to Intel SDM (other than checking whether interrupt can
> be used as a break event).
>
> Signed-off-by: Nadav Amit <namit@cs.technion.ac.il>
> ---
>  arch/x86/kvm/emulate.c | 41 +++++++++++++++++++++++++++++++++++++++--
>  arch/x86/kvm/svm.c     | 22 ++--------------------
>  arch/x86/kvm/vmx.c     | 27 +++++++++++----------------
>  3 files changed, 52 insertions(+), 38 deletions(-)
>
> diff --git a/arch/x86/kvm/emulate.c b/arch/x86/kvm/emulate.c
> index ef7a5a0..424b58d 100644
> --- a/arch/x86/kvm/emulate.c
> +++ b/arch/x86/kvm/emulate.c
> @@ -3344,6 +3344,43 @@ static int em_bswap(struct x86_emulate_ctxt *ctxt)
>  	return X86EMUL_CONTINUE;
>  }
>
> +static int em_monitor(struct x86_emulate_ctxt *ctxt)
> +{
> +	int rc;
> +	struct segmented_address addr;
> +	u64 rcx = reg_read(ctxt, VCPU_REGS_RCX);
> +	u64 rax = reg_read(ctxt, VCPU_REGS_RAX);
> +	u8 byte;
> +
> +	if (ctxt->mode != X86EMUL_MODE_PROT64)
> +		rcx = (u32)rcx;
> +	if (rcx != 0)
> +		return emulate_gp(ctxt, 0);
> +
> +	addr.seg = seg_override(ctxt);
> +	addr.ea = ctxt->ad_bytes == 8 ? rax : (u32)rax;
> +	rc = segmented_read(ctxt, addr, &byte, 1);
> +	if (rc != X86EMUL_CONTINUE)
> +		return rc;
> +
> +	printk_once(KERN_WARNING "kvm: MONITOR instruction emulated as NOP!\n");
> +	return X86EMUL_CONTINUE;
> +}
> +
> +static int em_mwait(struct x86_emulate_ctxt *ctxt)
> +{
> +	u64 rcx = reg_read(ctxt, VCPU_REGS_RCX);
> +
> +	if (ctxt->mode != X86EMUL_MODE_PROT64)
> +		rcx = (u32)rcx;
> +	if ((rcx & ~1UL) != 0)
> +		return emulate_gp(ctxt, 0);
> +
> +	/* Accepting interrupt as break event regardless to cpuid */
> +	printk_once(KERN_WARNING "kvm: MWAIT instruction emulated as NOP!\n");
> +	return X86EMUL_CONTINUE;
> +}
> +
>  static bool valid_cr(int nr)
>  {
>  	switch (nr) {
> @@ -3557,8 +3594,8 @@ static int check_perm_out(struct x86_emulate_ctxt *ctxt)
>  		F2bv(((_f) & ~Lock) | DstAcc | SrcImm, _e)
>
>  static const struct opcode group7_rm1[] = {
> -	DI(SrcNone | Priv, monitor),
> -	DI(SrcNone | Priv, mwait),
> +	II(SrcNone | Priv | NoBigReal | UDOnPriv, em_monitor, monitor),
> +	II(SrcNone | Priv | NoBigReal | UDOnPriv, em_mwait, mwait),
>  	N, N, N, N, N, N,
>  };
>
> diff --git a/arch/x86/kvm/svm.c b/arch/x86/kvm/svm.c
> index ec8366c..a524e04 100644
> --- a/arch/x86/kvm/svm.c
> +++ b/arch/x86/kvm/svm.c
> @@ -3274,24 +3274,6 @@ static int pause_interception(struct vcpu_svm *svm)
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
> @@ -3349,8 +3331,8 @@ static int (*const svm_exit_handlers[])(struct vcpu_svm *svm) = {
>  	[SVM_EXIT_CLGI]				= clgi_interception,
>  	[SVM_EXIT_SKINIT]			= skinit_interception,
>  	[SVM_EXIT_WBINVD]                       = emulate_on_interception,
> -	[SVM_EXIT_MONITOR]			= monitor_interception,
> -	[SVM_EXIT_MWAIT]			= mwait_interception,
> +	[SVM_EXIT_MONITOR]			= emulate_on_interception,
> +	[SVM_EXIT_MWAIT]			= emulate_on_interception,
>  	[SVM_EXIT_XSETBV]			= xsetbv_interception,
>  	[SVM_EXIT_NPF]				= pf_interception,
>  };
> diff --git a/arch/x86/kvm/vmx.c b/arch/x86/kvm/vmx.c
> index 801332e..7023e71 100644
> --- a/arch/x86/kvm/vmx.c
> +++ b/arch/x86/kvm/vmx.c
> @@ -5672,22 +5672,17 @@ static int handle_pause(struct kvm_vcpu *vcpu)
>  	return 1;
>  }
>
> -static int handle_nop(struct kvm_vcpu *vcpu)
> +static int handle_emulate(struct kvm_vcpu *vcpu)
>  {
> -	skip_emulated_instruction(vcpu);
> -	return 1;
> -}
> +	int err = emulate_instruction(vcpu, 0);
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
> +	if (err != EMULATE_DONE) {
> +		vcpu->run->exit_reason = KVM_EXIT_INTERNAL_ERROR;
> +		vcpu->run->internal.suberror = KVM_INTERNAL_ERROR_EMULATION;
> +		vcpu->run->internal.ndata = 0;
> +		return 0;
> +	}
> +	return 1;
>  }
>
>  /*
> @@ -6651,8 +6646,8 @@ static int (*const kvm_vmx_exit_handlers[])(struct kvm_vcpu *vcpu) = {
>  	[EXIT_REASON_EPT_VIOLATION]	      = handle_ept_violation,
>  	[EXIT_REASON_EPT_MISCONFIG]           = handle_ept_misconfig,
>  	[EXIT_REASON_PAUSE_INSTRUCTION]       = handle_pause,
> -	[EXIT_REASON_MWAIT_INSTRUCTION]	      = handle_mwait,
> -	[EXIT_REASON_MONITOR_INSTRUCTION]     = handle_monitor,
> +	[EXIT_REASON_MWAIT_INSTRUCTION]	      = handle_emulate,
> +	[EXIT_REASON_MONITOR_INSTRUCTION]     = handle_emulate,
>  	[EXIT_REASON_INVEPT]                  = handle_invept,
>  };
>
>

In VMX, handle_invd can be reused as handle_emulate.

Paolo
