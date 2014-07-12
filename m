Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751946AbaGLHoe (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Jul 2014 03:44:34 -0400
Received: from mail-wi0-f174.google.com ([209.85.212.174]:42357 "EHLO
	mail-wi0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751785AbaGLHoc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Jul 2014 03:44:32 -0400
Date: Sat, 12 Jul 2014 10:44:25 +0300
From: Gleb Natapov <gleb@kernel.org>
To: Tang Chen <tangchen@cn.fujitsu.com>
Cc: mtosatti@redhat.com, nadav.amit@gmail.com, kvm@vger.kernel.org,
        laijs@cn.fujitsu.com, isimatu.yasuaki@jp.fujitsu.com,
        guz.fnst@cn.fujitsu.com, linux-kernel@vger.kernel.org
Subject: Re: [RESEND PATCH v2 4/5] kvm: Remove ept_identity_pagetable from
 struct kvm_arch.
Message-ID: <20140712074425.GG4399@minantech.com>
References: <1404824492-30095-5-git-send-email-tangchen@cn.fujitsu.com>
 <1404871683-27293-1-git-send-email-tangchen@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1404871683-27293-1-git-send-email-tangchen@cn.fujitsu.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 09, 2014 at 10:08:03AM +0800, Tang Chen wrote:
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
> Signed-off-by: Tang Chen <tangchen@cn.fujitsu.com>
> ---
>  arch/x86/include/asm/kvm_host.h |  1 -
>  arch/x86/kvm/vmx.c              | 25 +++++++++++--------------
>  2 files changed, 11 insertions(+), 15 deletions(-)
> 
> diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
> index 4931415..62f973e 100644
> --- a/arch/x86/include/asm/kvm_host.h
> +++ b/arch/x86/include/asm/kvm_host.h
> @@ -578,7 +578,6 @@ struct kvm_arch {
>  
>  	gpa_t wall_clock;
>  
> -	struct page *ept_identity_pagetable;
>  	bool ept_identity_pagetable_done;
>  	gpa_t ept_identity_map_addr;
>  
> diff --git a/arch/x86/kvm/vmx.c b/arch/x86/kvm/vmx.c
> index 0918635e..fe2e5f4 100644
> --- a/arch/x86/kvm/vmx.c
> +++ b/arch/x86/kvm/vmx.c
> @@ -741,6 +741,7 @@ static void vmx_sync_pir_to_irr_dummy(struct kvm_vcpu *vcpu);
>  static void copy_vmcs12_to_shadow(struct vcpu_vmx *vmx);
>  static void copy_shadow_to_vmcs12(struct vcpu_vmx *vmx);
>  static bool vmx_mpx_supported(void);
> +static int alloc_identity_pagetable(struct kvm *kvm);
>  
>  static DEFINE_PER_CPU(struct vmcs *, vmxarea);
>  static DEFINE_PER_CPU(struct vmcs *, current_vmcs);
> @@ -3921,21 +3922,21 @@ out:
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
> -	}
>  	if (likely(kvm->arch.ept_identity_pagetable_done))
>  		return 1;
> -	ret = 0;
>  	identity_map_pfn = kvm->arch.ept_identity_map_addr >> PAGE_SHIFT;
> +
> +	mutex_lock(&kvm->slots_lock);
Why move this out of alloc_identity_pagetable()?

> +	r = alloc_identity_pagetable(kvm);
> +	if (r)
> +		goto out2;
> +
>  	idx = srcu_read_lock(&kvm->srcu);
>  	r = kvm_clear_guest_page(kvm, identity_map_pfn, 0, PAGE_SIZE);
>  	if (r < 0)
> @@ -3953,6 +3954,9 @@ static int init_rmode_identity_map(struct kvm *kvm)
>  	ret = 1;
>  out:
>  	srcu_read_unlock(&kvm->srcu, idx);
> +
> +out2:
> +	mutex_unlock(&kvm->slots_lock);
>  	return ret;
>  }
>  
> @@ -4006,9 +4010,6 @@ static int alloc_identity_pagetable(struct kvm *kvm)
>  	struct kvm_userspace_memory_region kvm_userspace_mem;
>  	int r = 0;
>  
> -	mutex_lock(&kvm->slots_lock);
> -	if (kvm->arch.ept_identity_pagetable)
> -		goto out;
>  	kvm_userspace_mem.slot = IDENTITY_PAGETABLE_PRIVATE_MEMSLOT;
>  	kvm_userspace_mem.flags = 0;
>  	kvm_userspace_mem.guest_phys_addr =
> @@ -4025,9 +4026,7 @@ static int alloc_identity_pagetable(struct kvm *kvm)
>  		goto out;
>  	}
>  
> -	kvm->arch.ept_identity_pagetable = page;
I think we can drop gfn_to_page() above too now. Why would we need it?

>  out:
> -	mutex_unlock(&kvm->slots_lock);
>  	return r;
>  }
>  
> @@ -7583,8 +7582,6 @@ static struct kvm_vcpu *vmx_create_vcpu(struct kvm *kvm, unsigned int id)
>  			kvm->arch.ept_identity_map_addr =
>  				VMX_EPT_IDENTITY_PAGETABLE_ADDR;
>  		err = -ENOMEM;
> -		if (alloc_identity_pagetable(kvm) != 0)
> -			goto free_vmcs;
>  		if (!init_rmode_identity_map(kvm))
>  			goto free_vmcs;
>  	}
> -- 
> 1.8.3.1
> 

--
			Gleb.
