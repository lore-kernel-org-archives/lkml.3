Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751717AbaFELYP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jun 2014 07:24:15 -0400
Received: from mail-lb0-f172.google.com ([209.85.217.172]:37614 "EHLO
	mail-lb0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750907AbaFELYO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jun 2014 07:24:14 -0400
Date: Thu, 5 Jun 2014 13:24:09 +0200
From: Christoffer Dall <christoffer.dall@linaro.org>
To: Eric Auger <eric.auger@linaro.org>
Cc: eric.auger@st.com, marc.zyngier@arm.com,
        linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org, patches@linaro.org,
        christophe.barnichon@st.com
Subject: Re: [PATCH v2] ARM: KVM: Unmap IPA on memslot delete/move
Message-ID: <20140605112409.GD3994@lvm>
References: <1401889674-10067-1-git-send-email-eric.auger@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1401889674-10067-1-git-send-email-eric.auger@linaro.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 04, 2014 at 03:47:54PM +0200, Eric Auger wrote:
> Currently when a KVM region is deleted or moved after
> KVM_SET_USER_MEMORY_REGION ioctl, the corresponding
> intermediate physical memory is not unmapped.
> 
> This patch corrects this and unmaps the region's IPA range
> in kvm_arch_commit_memory_region using unmap_stage2_range.
> 
> The patch was tested with QEMU using the VFIO platform
> device. In a specific IRQ handling case, the device regularly
> deletes/creates some RAM regions.
> 
> Changes v1 -> v2
> - KVM_MR_MOVE case also handled and tested using a QEMU hack
> - memslot and memory_region stubs moved from arm.c to mmu.c
>   following Marc Zyngier recommendations.
> 
> Signed-off-by: Eric Auger <eric.auger@linaro.org>
> ---
>  arch/arm/kvm/arm.c | 37 -------------------------------------
>  arch/arm/kvm/mmu.c | 46 ++++++++++++++++++++++++++++++++++++++++++++++
>  2 files changed, 46 insertions(+), 37 deletions(-)
> 
> diff --git a/arch/arm/kvm/arm.c b/arch/arm/kvm/arm.c
> index f0e50a0..bcc2929 100644
> --- a/arch/arm/kvm/arm.c
> +++ b/arch/arm/kvm/arm.c
> @@ -155,16 +155,6 @@ int kvm_arch_vcpu_fault(struct kvm_vcpu *vcpu, struct vm_fault *vmf)
>  	return VM_FAULT_SIGBUS;
>  }
>  
> -void kvm_arch_free_memslot(struct kvm *kvm, struct kvm_memory_slot *free,
> -			   struct kvm_memory_slot *dont)
> -{
> -}
> -
> -int kvm_arch_create_memslot(struct kvm *kvm, struct kvm_memory_slot *slot,
> -			    unsigned long npages)
> -{
> -	return 0;
> -}
>  
>  /**
>   * kvm_arch_destroy_vm - destroy the VM data structure
> @@ -224,33 +214,6 @@ long kvm_arch_dev_ioctl(struct file *filp,
>  	return -EINVAL;
>  }
>  
> -void kvm_arch_memslots_updated(struct kvm *kvm)
> -{
> -}
> -
> -int kvm_arch_prepare_memory_region(struct kvm *kvm,
> -				   struct kvm_memory_slot *memslot,
> -				   struct kvm_userspace_memory_region *mem,
> -				   enum kvm_mr_change change)
> -{
> -	return 0;
> -}
> -
> -void kvm_arch_commit_memory_region(struct kvm *kvm,
> -				   struct kvm_userspace_memory_region *mem,
> -				   const struct kvm_memory_slot *old,
> -				   enum kvm_mr_change change)
> -{
> -}
> -
> -void kvm_arch_flush_shadow_all(struct kvm *kvm)
> -{
> -}
> -
> -void kvm_arch_flush_shadow_memslot(struct kvm *kvm,
> -				   struct kvm_memory_slot *slot)
> -{
> -}
>  
>  struct kvm_vcpu *kvm_arch_vcpu_create(struct kvm *kvm, unsigned int id)
>  {
> diff --git a/arch/arm/kvm/mmu.c b/arch/arm/kvm/mmu.c
> index 16f8049..921245c 100644
> --- a/arch/arm/kvm/mmu.c
> +++ b/arch/arm/kvm/mmu.c
> @@ -1100,3 +1100,49 @@ out:
>  	free_hyp_pgds();
>  	return err;
>  }
> +
> +void kvm_arch_commit_memory_region(struct kvm *kvm,
> +				   struct kvm_userspace_memory_region *mem,
> +				   const struct kvm_memory_slot *old,
> +				   enum kvm_mr_change change)
> +{
> +	gpa_t gpa = old->base_gfn << PAGE_SHIFT;
> +	u64 size = old->npages << PAGE_SHIFT;

phys_addr_t instead of u64?

> +	if (change == KVM_MR_DELETE || change == KVM_MR_MOVE) {
> +		spin_lock(&kvm->mmu_lock);
> +		unmap_stage2_range(kvm, gpa, size);
> +		spin_unlock(&kvm->mmu_lock);
> +	}
> +}
> +
> +int kvm_arch_prepare_memory_region(struct kvm *kvm,
> +				   struct kvm_memory_slot *memslot,
> +				   struct kvm_userspace_memory_region *mem,
> +				   enum kvm_mr_change change)
> +{
> +	return 0;
> +}
> +
> +void kvm_arch_free_memslot(struct kvm *kvm, struct kvm_memory_slot *free,
> +			   struct kvm_memory_slot *dont)
> +{
> +}
> +
> +int kvm_arch_create_memslot(struct kvm *kvm, struct kvm_memory_slot *slot,
> +			    unsigned long npages)
> +{
> +	return 0;
> +}
> +
> +void kvm_arch_memslots_updated(struct kvm *kvm)
> +{
> +}
> +
> +void kvm_arch_flush_shadow_all(struct kvm *kvm)
> +{
> +}
> +
> +void kvm_arch_flush_shadow_memslot(struct kvm *kvm,
> +				   struct kvm_memory_slot *slot)
> +{
> +}
> -- 
> 1.9.1
> 

Otherwise, this looks pretty straight forward:

Acked-by: Christoffer Dall <christoffer.dall@linaro.org>
