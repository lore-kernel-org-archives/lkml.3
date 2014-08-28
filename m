Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752509AbaH1VLT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Aug 2014 17:11:19 -0400
Received: from mail-pa0-f44.google.com ([209.85.220.44]:40523 "EHLO
	mail-pa0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752017AbaH1VLR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Aug 2014 17:11:17 -0400
MIME-Version: 1.0
In-Reply-To: <1408401967-27211-2-git-send-email-dmatlack@google.com>
References: <1408401967-27211-1-git-send-email-dmatlack@google.com> <1408401967-27211-2-git-send-email-dmatlack@google.com>
From: David Matlack <dmatlack@google.com>
Date: Thu, 28 Aug 2014 14:10:56 -0700
Message-ID: <CALzav=fCgNRbfPBxzYR7RL0f8w3qU8h3ZQTRU=P9-djo7fRJ3g@mail.gmail.com>
Subject: Re: [PATCH 2/2] kvm: x86: fix stale mmio cache bug
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: gleb@redhat.com, linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        Avi Kivity <avi.kivity@gmail.com>, mtosatti@redhat.com,
        David Matlack <dmatlack@google.com>, stable@vger.kernel.org,
        Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 18, 2014 at 3:46 PM, David Matlack <dmatlack@google.com> wrote:
> The following events can lead to an incorrect KVM_EXIT_MMIO bubbling
> up to userspace:
>
> (1) Guest accesses gpa X without a memory slot. The gfn is cached in
> struct kvm_vcpu_arch (mmio_gfn). On Intel EPT-enabled hosts, KVM sets
> the SPTE write-execute-noread so that future accesses cause
> EPT_MISCONFIGs.
>
> (2) Host userspace creates a memory slot via KVM_SET_USER_MEMORY_REGION
> covering the page just accessed.
>
> (3) Guest attempts to read or write to gpa X again. On Intel, this
> generates an EPT_MISCONFIG. The memory slot generation number that
> was incremented in (2) would normally take care of this but we fast
> path mmio faults through quickly_check_mmio_pf(), which only checks
> the per-vcpu mmio cache. Since we hit the cache, KVM passes a
> KVM_EXIT_MMIO up to userspace.
>
> This patch fixes the issue by using the memslot generation number
> to validate the mmio cache.
>
> [ xiaoguangrong: adjust the code to make it simpler for stable-tree fix. ]
>
> Cc: stable@vger.kernel.org
> Signed-off-by: David Matlack <dmatlack@google.com>
> Signed-off-by: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
> ---

Paolo,
It seems like this patch ("[PATCH 2/2] kvm: x86: fix stale mmio cache")
is ready to go. Is there anything blocking it from being merged?

(It should be fine to merge this on its own, independent of the fix
discussed in "[PATCH 1/2] KVM: fix cache stale memslot info with
correct mmio generation number", https://lkml.org/lkml/2014/8/14/62.)

>  arch/x86/include/asm/kvm_host.h |  1 +
>  arch/x86/kvm/mmu.c              |  4 ++--
>  arch/x86/kvm/mmu.h              |  2 ++
>  arch/x86/kvm/x86.h              | 21 ++++++++++++++++-----
>  4 files changed, 21 insertions(+), 7 deletions(-)
>
> diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
> index 49205d0..f518d14 100644
> --- a/arch/x86/include/asm/kvm_host.h
> +++ b/arch/x86/include/asm/kvm_host.h
> @@ -479,6 +479,7 @@ struct kvm_vcpu_arch {
>         u64 mmio_gva;
>         unsigned access;
>         gfn_t mmio_gfn;
> +       unsigned int mmio_gen;
>
>         struct kvm_pmu pmu;
>
> diff --git a/arch/x86/kvm/mmu.c b/arch/x86/kvm/mmu.c
> index 9314678..e00fbfe 100644
> --- a/arch/x86/kvm/mmu.c
> +++ b/arch/x86/kvm/mmu.c
> @@ -234,7 +234,7 @@ static unsigned int get_mmio_spte_generation(u64 spte)
>         return gen;
>  }
>
> -static unsigned int kvm_current_mmio_generation(struct kvm *kvm)
> +unsigned int kvm_current_mmio_generation(struct kvm *kvm)
>  {
>         /*
>          * Init kvm generation close to MMIO_MAX_GEN to easily test the
> @@ -3163,7 +3163,7 @@ static void mmu_sync_roots(struct kvm_vcpu *vcpu)
>         if (!VALID_PAGE(vcpu->arch.mmu.root_hpa))
>                 return;
>
> -       vcpu_clear_mmio_info(vcpu, ~0ul);
> +       vcpu_clear_mmio_info(vcpu, MMIO_GVA_ANY);
>         kvm_mmu_audit(vcpu, AUDIT_PRE_SYNC);
>         if (vcpu->arch.mmu.root_level == PT64_ROOT_LEVEL) {
>                 hpa_t root = vcpu->arch.mmu.root_hpa;
> diff --git a/arch/x86/kvm/mmu.h b/arch/x86/kvm/mmu.h
> index b982112..e2d902a 100644
> --- a/arch/x86/kvm/mmu.h
> +++ b/arch/x86/kvm/mmu.h
> @@ -76,6 +76,8 @@ enum {
>  };
>
>  int handle_mmio_page_fault_common(struct kvm_vcpu *vcpu, u64 addr, bool direct);
> +unsigned int kvm_current_mmio_generation(struct kvm *kvm);
> +
>  void kvm_init_shadow_mmu(struct kvm_vcpu *vcpu, struct kvm_mmu *context);
>  void kvm_init_shadow_ept_mmu(struct kvm_vcpu *vcpu, struct kvm_mmu *context,
>                 bool execonly);
> diff --git a/arch/x86/kvm/x86.h b/arch/x86/kvm/x86.h
> index 8c97bac..ae7006d 100644
> --- a/arch/x86/kvm/x86.h
> +++ b/arch/x86/kvm/x86.h
> @@ -3,6 +3,7 @@
>
>  #include <linux/kvm_host.h>
>  #include "kvm_cache_regs.h"
> +#include "mmu.h"
>
>  static inline void kvm_clear_exception_queue(struct kvm_vcpu *vcpu)
>  {
> @@ -78,15 +79,23 @@ static inline void vcpu_cache_mmio_info(struct kvm_vcpu *vcpu,
>         vcpu->arch.mmio_gva = gva & PAGE_MASK;
>         vcpu->arch.access = access;
>         vcpu->arch.mmio_gfn = gfn;
> +       vcpu->arch.mmio_gen = kvm_current_mmio_generation(vcpu->kvm);
> +}
> +
> +static inline bool vcpu_match_mmio_gen(struct kvm_vcpu *vcpu)
> +{
> +       return vcpu->arch.mmio_gen == kvm_current_mmio_generation(vcpu->kvm);
>  }
>
>  /*
> - * Clear the mmio cache info for the given gva,
> - * specially, if gva is ~0ul, we clear all mmio cache info.
> + * Clear the mmio cache info for the given gva. If gva is MMIO_GVA_ANY, we
> + * clear all mmio cache info.
>   */
> +#define MMIO_GVA_ANY (~(gva_t)0)
> +
>  static inline void vcpu_clear_mmio_info(struct kvm_vcpu *vcpu, gva_t gva)
>  {
> -       if (gva != (~0ul) && vcpu->arch.mmio_gva != (gva & PAGE_MASK))
> +       if (gva != MMIO_GVA_ANY && vcpu->arch.mmio_gva != (gva & PAGE_MASK))
>                 return;
>
>         vcpu->arch.mmio_gva = 0;
> @@ -94,7 +103,8 @@ static inline void vcpu_clear_mmio_info(struct kvm_vcpu *vcpu, gva_t gva)
>
>  static inline bool vcpu_match_mmio_gva(struct kvm_vcpu *vcpu, unsigned long gva)
>  {
> -       if (vcpu->arch.mmio_gva && vcpu->arch.mmio_gva == (gva & PAGE_MASK))
> +       if (vcpu_match_mmio_gen(vcpu) && vcpu->arch.mmio_gva &&
> +             vcpu->arch.mmio_gva == (gva & PAGE_MASK))
>                 return true;
>
>         return false;
> @@ -102,7 +112,8 @@ static inline bool vcpu_match_mmio_gva(struct kvm_vcpu *vcpu, unsigned long gva)
>
>  static inline bool vcpu_match_mmio_gpa(struct kvm_vcpu *vcpu, gpa_t gpa)
>  {
> -       if (vcpu->arch.mmio_gfn && vcpu->arch.mmio_gfn == gpa >> PAGE_SHIFT)
> +       if (vcpu_match_mmio_gen(vcpu) && vcpu->arch.mmio_gfn &&
> +             vcpu->arch.mmio_gfn == gpa >> PAGE_SHIFT)
>                 return true;
>
>         return false;
> --
> 2.1.0.rc2.206.gedb03e5
>
