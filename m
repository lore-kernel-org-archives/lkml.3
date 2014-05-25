Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751476AbaEYXVe (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 May 2014 19:21:34 -0400
Received: from mail-la0-f66.google.com ([209.85.215.66]:65393 "EHLO
	mail-la0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751078AbaEYXVc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 May 2014 19:21:32 -0400
MIME-Version: 1.0
In-Reply-To: <CALeycy_c4P+vvWBXVYts5WaZOB-=-ovMgA1eK+A9Dk1Zs1Sptw@mail.gmail.com>
References: <CALeycy_c4P+vvWBXVYts5WaZOB-=-ovMgA1eK+A9Dk1Zs1Sptw@mail.gmail.com>
Date: Sun, 25 May 2014 18:21:30 -0500
Message-ID: <CALeycy8P0R-+jN2SQKR3tU3y6JWzjK9J4NbY6cuynFOPWN5XNA@mail.gmail.com>
Subject: Re: [PATCH v2 4/4] KVM: x86: get CPL from SS.DPL
From: Wei Huang <huangwei.virt@gmail.com>
To: kvm@vger.kernel.org, pbonzini@redhat.com, linux-kernel@vger.kernel.org,
        jan.kiszka@siemens.com, gleb@kernel.org, avi.kivity@gmail.com
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> CS.RPL is not equal to the CPL in the few instructions between
> setting CR0.PE and reloading CS.  And CS.DPL is also not equal
> to the CPL for conforming code segments.

Out of my curiousity, could you elaborate the problem of this
CPL gap window, such as breaking any VMs or tests? From Linux kernel
code, it seems kernel enables CR0.PE and immediately ljmpl to
CS. This windows is very small and I am curious how severely it could
be.

>
> However, SS.DPL *is* always equal to the CPL except for the weird

Is this specified anywhere in SDM as a requirement for x86 OS? If so,
maybe provide a pointer to support this.

> case of SYSRET on AMD processors, which sets SS.DPL=SS.RPL from the
> value in the STAR MSR, but force CPL=3 (Intel instead forces
> SS.DPL=SS.RPL=CPL=3).

Thinking out loud here... Should we force SYSRET SS.RPL to be 3 when
VM updates STAR MSR? Following the same thought, does it make sense to
check (and force) SS.DPL==3 when STAR MSR is being updated. Will
forcing SYSRET SS.DPL=3 break any OS? I think any reasonable OS would
probably sets SS.RPL=SS.DPL=3.

>
> So this patch:
>
> - modifies SVM to update the CPL from SS.DPL rather than CS.RPL;
> the above case with SYSRET is not broken further, and the way
> to fix it would be to pass the CPL to userspace and back
>
> - modifies VMX to always return the CPL from SS.DPL (except
> forcing it to 0 if we are emulating real mode via vm86 mode;
> in vm86 mode all DPLs have to be 3, but real mode does allow
> privileged instructions).  It also removes the CPL cache,
> which becomes a duplicate of the SS access rights cache.
>
> This fixes doing KVM_IOCTL_SET_SREGS exactly after setting

nit-picking: s/KVM_IOCTL_SET_SREGS/KVM_SET_SREGS IOCTL/, to
match with IOCTL function name exactly.

> CR0.PE=1 but before CS has been reloaded.
>
> Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
> ---
>  arch/x86/include/asm/kvm_host.h |  1 -
>  arch/x86/kvm/svm.c              | 35 ++++++++++++++---------------------
>  arch/x86/kvm/vmx.c              | 24 ++++--------------------
>  3 files changed, 18 insertions(+), 42 deletions(-)
>
> diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
> index e21aee98a5c2..49314155b66c 100644
> --- a/arch/x86/include/asm/kvm_host.h
> +++ b/arch/x86/include/asm/kvm_host.h
> @@ -130,7 +130,6 @@ enum kvm_reg_ex {
>   VCPU_EXREG_PDPTR = NR_VCPU_REGS,
>   VCPU_EXREG_CR3,
>   VCPU_EXREG_RFLAGS,
> - VCPU_EXREG_CPL,
>   VCPU_EXREG_SEGMENTS,
>  };
>
> diff --git a/arch/x86/kvm/svm.c b/arch/x86/kvm/svm.c
> index 0b7d58d0c5fb..ec8366c5cfea 100644
> --- a/arch/x86/kvm/svm.c
> +++ b/arch/x86/kvm/svm.c
> @@ -1338,21 +1338,6 @@ static void svm_vcpu_put(struct kvm_vcpu *vcpu)
>   wrmsrl(host_save_user_msrs[i], svm->host_user_msrs[i]);
>  }
>
> -static void svm_update_cpl(struct kvm_vcpu *vcpu)
> -{
> - struct vcpu_svm *svm = to_svm(vcpu);
> - int cpl;
> -
> - if (!is_protmode(vcpu))
> - cpl = 0;
> - else if (svm->vmcb->save.rflags & X86_EFLAGS_VM)
> - cpl = 3;
> - else
> - cpl = svm->vmcb->save.cs.selector & 0x3;
> -
> - svm->vmcb->save.cpl = cpl;
> -}
> -
>  static unsigned long svm_get_rflags(struct kvm_vcpu *vcpu)
>  {
>   return to_svm(vcpu)->vmcb->save.rflags;
> @@ -1360,11 +1345,12 @@ static unsigned long svm_get_rflags(struct
> kvm_vcpu *vcpu)
>
>  static void svm_set_rflags(struct kvm_vcpu *vcpu, unsigned long rflags)
>  {
> - unsigned long old_rflags = to_svm(vcpu)->vmcb->save.rflags;
> -
> +       /*
> +        * Any change of EFLAGS.VM is accompained by a reload of SS
> +        * (caused by either a task switch or an inter-privilege IRET),
> +        * so we do not need to update the CPL here.
> +        */
>   to_svm(vcpu)->vmcb->save.rflags = rflags;
> - if ((old_rflags ^ rflags) & X86_EFLAGS_VM)
> - svm_update_cpl(vcpu);
>  }
>
>  static void svm_cache_reg(struct kvm_vcpu *vcpu, enum kvm_reg reg)
> @@ -1631,8 +1617,15 @@ static void svm_set_segment(struct kvm_vcpu *vcpu,
>   s->attrib |= (var->db & 1) << SVM_SELECTOR_DB_SHIFT;
>   s->attrib |= (var->g & 1) << SVM_SELECTOR_G_SHIFT;
>   }
> - if (seg == VCPU_SREG_CS)
> - svm_update_cpl(vcpu);
> +
> + /*
> + * This is always accurate, except if SYSRET returned to a segment
> + * with SS.DPL != 3.  Intel does not have this quirk, and always
> + * forces SS.DPL to 3 on sysret, so we ignore that case; fixing it
> + * would entail passing the CPL to userspace and back.
> + */
> + if (seg == VCPU_SREG_SS)
> + svm->vmcb->save.cpl = (s->attrib >> SVM_SELECTOR_DPL_SHIFT) & 3;
>
>   mark_dirty(svm->vmcb, VMCB_SEG);
>  }
> diff --git a/arch/x86/kvm/vmx.c b/arch/x86/kvm/vmx.c
> index 6f7463f53ed9..a267108403f5 100644
> --- a/arch/x86/kvm/vmx.c
> +++ b/arch/x86/kvm/vmx.c
> @@ -414,7 +414,6 @@ struct vcpu_vmx {
>   struct kvm_vcpu       vcpu;
>   unsigned long         host_rsp;
>   u8                    fail;
> - u8                    cpl;
>   bool                  nmi_known_unmasked;
>   u32                   exit_intr_info;
>   u32                   idt_vectoring_info;
> @@ -3150,10 +3149,6 @@ static void enter_pmode(struct kvm_vcpu *vcpu)
>   fix_pmode_seg(vcpu, VCPU_SREG_DS, &vmx->rmode.segs[VCPU_SREG_DS]);
>   fix_pmode_seg(vcpu, VCPU_SREG_FS, &vmx->rmode.segs[VCPU_SREG_FS]);
>   fix_pmode_seg(vcpu, VCPU_SREG_GS, &vmx->rmode.segs[VCPU_SREG_GS]);
> -
> - /* CPL is always 0 when CPU enters protected mode */
> - __set_bit(VCPU_EXREG_CPL, (ulong *)&vcpu->arch.regs_avail);
> - vmx->cpl = 0;
>  }
>
>  static void fix_rmode_seg(int seg, struct kvm_segment *save)
> @@ -3555,22 +3550,14 @@ static int vmx_get_cpl(struct kvm_vcpu *vcpu)
>  {
>   struct vcpu_vmx *vmx = to_vmx(vcpu);
>
> - if (!is_protmode(vcpu))
> + if (unlikely(vmx->rmode.vm86_active))
>   return 0;
> -
> - if (!is_long_mode(vcpu)
> -    && (kvm_get_rflags(vcpu) & X86_EFLAGS_VM)) /* if virtual 8086 */
> - return 3;
> -
> - if (!test_bit(VCPU_EXREG_CPL, (ulong *)&vcpu->arch.regs_avail)) {
> - __set_bit(VCPU_EXREG_CPL, (ulong *)&vcpu->arch.regs_avail);
> - vmx->cpl = vmx_read_guest_seg_selector(vmx, VCPU_SREG_CS) & 3;
> + else {
> + int ar = vmx_read_guest_seg_ar(vmx, VCPU_SREG_SS);
> + return AR_DPL(ar);
>   }
> -
> - return vmx->cpl;
>  }
>
> -
>  static u32 vmx_segment_access_rights(struct kvm_segment *var)
>  {
>   u32 ar;
> @@ -3598,8 +3585,6 @@ static void vmx_set_segment(struct kvm_vcpu *vcpu,
>   const struct kvm_vmx_segment_field *sf = &kvm_vmx_segment_fields[seg];
>
>   vmx_segment_cache_clear(vmx);
> - if (seg == VCPU_SREG_CS)
> - __clear_bit(VCPU_EXREG_CPL, (ulong *)&vcpu->arch.regs_avail);
>
>   if (vmx->rmode.vm86_active && seg != VCPU_SREG_LDTR) {
>   vmx->rmode.segs[seg] = *var;
> @@ -7471,7 +7456,6 @@ static void __noclone vmx_vcpu_run(struct kvm_vcpu *vcpu)
>
>   vcpu->arch.regs_avail = ~((1 << VCPU_REGS_RIP) | (1 << VCPU_REGS_RSP)
>    | (1 << VCPU_EXREG_RFLAGS)
> -  | (1 << VCPU_EXREG_CPL)
>    | (1 << VCPU_EXREG_PDPTR)
>    | (1 << VCPU_EXREG_SEGMENTS)
>    | (1 << VCPU_EXREG_CR3));
