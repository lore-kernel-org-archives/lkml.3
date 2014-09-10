Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752301AbaIJN6o (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Sep 2014 09:58:44 -0400
Received: from mail-wg0-f50.google.com ([74.125.82.50]:60217 "EHLO
	mail-wg0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751760AbaIJN6m (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Sep 2014 09:58:42 -0400
Date: Wed, 10 Sep 2014 16:58:38 +0300
From: Gleb Natapov <gleb@kernel.org>
To: Tang Chen <tangchen@cn.fujitsu.com>
Cc: mtosatti@redhat.com, nadav.amit@gmail.com, jan.kiszka@web.de,
        kvm@vger.kernel.org, laijs@cn.fujitsu.com,
        isimatu.yasuaki@jp.fujitsu.com, guz.fnst@cn.fujitsu.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v4 2/6] kvm: Remove ept_identity_pagetable from struct
 kvm_arch.
Message-ID: <20140910135838.GD25317@minantech.com>
References: <1409134661-27916-1-git-send-email-tangchen@cn.fujitsu.com>
 <1409134661-27916-3-git-send-email-tangchen@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1409134661-27916-3-git-send-email-tangchen@cn.fujitsu.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 27, 2014 at 06:17:37PM +0800, Tang Chen wrote:
> kvm_arch->ept_identity_pagetable holds the ept identity pagetable page. But
> it is never used to refer to the page at all.
> 
> In vcpu initialization, it indicates two things:
> 1. indicates if ept page is allocated
> 2. indicates if a memory slot for identity page is initialized
> 
> Actually, kvm_arch->ept_identity_pagetable_done is enough to tell if the ept
> identity pagetable is initialized. So we can remove ept_identity_pagetable.
> 
> NOTE: In the original code, ept identity pagetable page is pinned in memroy.
>       As a result, it cannot be migrated/hot-removed. After this patch, since
>       kvm_arch->ept_identity_pagetable is removed, ept identity pagetable page
>       is no longer pinned in memory. And it can be migrated/hot-removed.
Reviewed-by: Gleb Natapov <gleb@kernel.org>

> 
> Signed-off-by: Tang Chen <tangchen@cn.fujitsu.com>
> ---
>  arch/x86/include/asm/kvm_host.h |  1 -
>  arch/x86/kvm/vmx.c              | 50 ++++++++++++++++++++---------------------
>  arch/x86/kvm/x86.c              |  2 --
>  3 files changed, 25 insertions(+), 28 deletions(-)
> 
> diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
> index 7c492ed..35171c7 100644
> --- a/arch/x86/include/asm/kvm_host.h
> +++ b/arch/x86/include/asm/kvm_host.h
> @@ -580,7 +580,6 @@ struct kvm_arch {
>  
>  	gpa_t wall_clock;
>  
> -	struct page *ept_identity_pagetable;
>  	bool ept_identity_pagetable_done;
>  	gpa_t ept_identity_map_addr;
>  
> diff --git a/arch/x86/kvm/vmx.c b/arch/x86/kvm/vmx.c
> index 4b80ead..953d529 100644
> --- a/arch/x86/kvm/vmx.c
> +++ b/arch/x86/kvm/vmx.c
> @@ -743,6 +743,7 @@ static u32 vmx_segment_access_rights(struct kvm_segment *var);
>  static void vmx_sync_pir_to_irr_dummy(struct kvm_vcpu *vcpu);
>  static void copy_vmcs12_to_shadow(struct vcpu_vmx *vmx);
>  static void copy_shadow_to_vmcs12(struct vcpu_vmx *vmx);
> +static int alloc_identity_pagetable(struct kvm *kvm);
>  
>  static DEFINE_PER_CPU(struct vmcs *, vmxarea);
>  static DEFINE_PER_CPU(struct vmcs *, current_vmcs);
> @@ -3938,21 +3939,27 @@ out:
>  
>  static int init_rmode_identity_map(struct kvm *kvm)
>  {
> -	int i, idx, r, ret;
> +	int i, idx, r, ret = 0;
>  	pfn_t identity_map_pfn;
>  	u32 tmp;
>  
>  	if (!enable_ept)
>  		return 1;
> -	if (unlikely(!kvm->arch.ept_identity_pagetable)) {
> -		printk(KERN_ERR "EPT: identity-mapping pagetable "
> -			"haven't been allocated!\n");
> -		return 0;
> +
> +	/* Protect kvm->arch.ept_identity_pagetable_done. */
> +	mutex_lock(&kvm->slots_lock);
> +
> +	if (likely(kvm->arch.ept_identity_pagetable_done)) {
> +		ret = 1;
> +		goto out2;
>  	}
> -	if (likely(kvm->arch.ept_identity_pagetable_done))
> -		return 1;
> -	ret = 0;
> +
>  	identity_map_pfn = kvm->arch.ept_identity_map_addr >> PAGE_SHIFT;
> +
> +	r = alloc_identity_pagetable(kvm);
> +	if (r)
> +		goto out2;
> +
>  	idx = srcu_read_lock(&kvm->srcu);
>  	r = kvm_clear_guest_page(kvm, identity_map_pfn, 0, PAGE_SIZE);
>  	if (r < 0)
> @@ -3970,6 +3977,9 @@ static int init_rmode_identity_map(struct kvm *kvm)
>  	ret = 1;
>  out:
>  	srcu_read_unlock(&kvm->srcu, idx);
> +
> +out2:
> +	mutex_unlock(&kvm->slots_lock);
>  	return ret;
>  }
>  
> @@ -4019,31 +4029,23 @@ out:
>  
>  static int alloc_identity_pagetable(struct kvm *kvm)
>  {
> -	struct page *page;
> +	/*
> +	 * In init_rmode_identity_map(), kvm->arch.ept_identity_pagetable_done
> +	 * is checked before calling this function and set to true after the
> +	 * calling. The access to kvm->arch.ept_identity_pagetable_done should
> +	 * be protected by kvm->slots_lock.
> +	 */
> +
>  	struct kvm_userspace_memory_region kvm_userspace_mem;
>  	int r = 0;
>  
> -	mutex_lock(&kvm->slots_lock);
> -	if (kvm->arch.ept_identity_pagetable)
> -		goto out;
>  	kvm_userspace_mem.slot = IDENTITY_PAGETABLE_PRIVATE_MEMSLOT;
>  	kvm_userspace_mem.flags = 0;
>  	kvm_userspace_mem.guest_phys_addr =
>  		kvm->arch.ept_identity_map_addr;
>  	kvm_userspace_mem.memory_size = PAGE_SIZE;
>  	r = __kvm_set_memory_region(kvm, &kvm_userspace_mem);
> -	if (r)
> -		goto out;
>  
> -	page = gfn_to_page(kvm, kvm->arch.ept_identity_map_addr >> PAGE_SHIFT);
> -	if (is_error_page(page)) {
> -		r = -EFAULT;
> -		goto out;
> -	}
> -
> -	kvm->arch.ept_identity_pagetable = page;
> -out:
> -	mutex_unlock(&kvm->slots_lock);
>  	return r;
>  }
>  
> @@ -7643,8 +7645,6 @@ static struct kvm_vcpu *vmx_create_vcpu(struct kvm *kvm, unsigned int id)
>  			kvm->arch.ept_identity_map_addr =
>  				VMX_EPT_IDENTITY_PAGETABLE_ADDR;
>  		err = -ENOMEM;
> -		if (alloc_identity_pagetable(kvm) != 0)
> -			goto free_vmcs;
>  		if (!init_rmode_identity_map(kvm))
>  			goto free_vmcs;
>  	}
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index 8f1e22d..e05bd58 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -7239,8 +7239,6 @@ void kvm_arch_destroy_vm(struct kvm *kvm)
>  	kvm_free_vcpus(kvm);
>  	if (kvm->arch.apic_access_page)
>  		put_page(kvm->arch.apic_access_page);
> -	if (kvm->arch.ept_identity_pagetable)
> -		put_page(kvm->arch.ept_identity_pagetable);
>  	kfree(rcu_dereference_check(kvm->arch.apic_map, 1));
>  }
>  
> -- 
> 1.8.3.1
> 

--
			Gleb.
