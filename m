Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753639AbaIVJbl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Sep 2014 05:31:41 -0400
Received: from mail-wi0-f169.google.com ([209.85.212.169]:35916 "EHLO
	mail-wi0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753079AbaIVJbj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Sep 2014 05:31:39 -0400
Message-ID: <541FEC79.40209@redhat.com>
Date: Mon, 22 Sep 2014 11:31:37 +0200
From: Paolo Bonzini <pbonzini@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.0
MIME-Version: 1.0
To: Tang Chen <tangchen@cn.fujitsu.com>, gleb@kernel.org, mtosatti@redhat.com,
        nadav.amit@gmail.com, jan.kiszka@web.de
CC: kvm@vger.kernel.org, laijs@cn.fujitsu.com, isimatu.yasuaki@jp.fujitsu.com,
        guz.fnst@cn.fujitsu.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v7 8/9] kvm, mem-hotplug: Add arch specific mmu notifier
 to handle apic access migration.
References: <1411210071-14727-1-git-send-email-tangchen@cn.fujitsu.com> <1411210071-14727-9-git-send-email-tangchen@cn.fujitsu.com>
In-Reply-To: <1411210071-14727-9-git-send-email-tangchen@cn.fujitsu.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Il 20/09/2014 12:47, Tang Chen ha scritto:
> We are handling "L1 and L2 share one apic access page" situation when migrating
> apic access page. We should do some handling when migration happens in the
> following situations:
> 
>    1) when L0 is running: Update L1's vmcs in the next L0->L1 entry and L2's
>       vmcs in the next L1->L2 entry.
> 
>    2) when L1 is running: Force a L1->L0 exit, update L1's vmcs in the next
>       L0->L1 entry and L2's vmcs in the next L1->L2 entry.
> 
>    3) when L2 is running: Force a L2->L0 exit, update L2's vmcs in the next
>       L0->L2 entry and L1's vmcs in the next L2->L1 exit.
> 
> This patch force a L1->L0 exit or L2->L0 exit when shared apic access page is
> migrated using mmu notifier. Since apic access page is only used on intel x86,
> this is arch specific code.
> 
> Signed-off-by: Tang Chen <tangchen@cn.fujitsu.com>
> ---
>  arch/x86/kvm/x86.c       | 11 +++++++++++
>  include/linux/kvm_host.h | 14 +++++++++++++-
>  virt/kvm/kvm_main.c      |  3 +++
>  3 files changed, 27 insertions(+), 1 deletion(-)
> 
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index 2ae2dc7..7dd4179 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -6011,6 +6011,17 @@ void kvm_vcpu_reload_apic_access_page(struct kvm_vcpu *vcpu)
>  }
>  EXPORT_SYMBOL_GPL(kvm_vcpu_reload_apic_access_page);
>  
> +void kvm_arch_mmu_notifier_invalidate_page(struct kvm *kvm,
> +					   unsigned long address)
> +{
> +	/*
> +	 * The physical address of apic access page is stored in VMCS.
> +	 * Update it when it becomes invalid.
> +	 */
> +	if (address == gfn_to_hva(kvm, APIC_DEFAULT_PHYS_BASE >> PAGE_SHIFT))
> +		kvm_make_all_cpus_request(kvm, KVM_REQ_APIC_PAGE_RELOAD);
> +}
> +
>  /*
>   * Returns 1 to let __vcpu_run() continue the guest execution loop without
>   * exiting to the userspace.  Otherwise, the value will be returned to the
> diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
> index 73de13c..b6e4d38 100644
> --- a/include/linux/kvm_host.h
> +++ b/include/linux/kvm_host.h
> @@ -917,7 +917,19 @@ static inline int mmu_notifier_retry(struct kvm *kvm, unsigned long mmu_seq)
>  		return 1;
>  	return 0;
>  }
> -#endif
> +
> +#ifdef _ASM_X86_KVM_HOST_H
> +void kvm_arch_mmu_notifier_invalidate_page(struct kvm *kvm,
> +					   unsigned long address);
> +#else /* _ASM_X86_KVM_HOST_H */
> +inline void kvm_arch_mmu_notifier_invalidate_page(struct kvm *kvm,
> +						  unsigned long address)

This needs to be static.

However, do not add it here.  Instead, touch all
arch/*/include/asm/kvm_host.h files, adding either the prototype or the
inline function.

Apart from this, the patch looks good.

Paolo

> +{
> +	return;
> +}
> +#endif /* _ASM_X86_KVM_HOST_H */
> +
> +#endif /* CONFIG_MMU_NOTIFIER & KVM_ARCH_WANT_MMU_NOTIFIER */
>  
>  #ifdef CONFIG_HAVE_KVM_IRQ_ROUTING
>  
> diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
> index 0f8b6f6..5427973d 100644
> --- a/virt/kvm/kvm_main.c
> +++ b/virt/kvm/kvm_main.c
> @@ -295,6 +295,9 @@ static void kvm_mmu_notifier_invalidate_page(struct mmu_notifier *mn,
>  		kvm_flush_remote_tlbs(kvm);
>  
>  	spin_unlock(&kvm->mmu_lock);
> +
> +	kvm_arch_mmu_notifier_invalidate_page(kvm, address);
> +
>  	srcu_read_unlock(&kvm->srcu, idx);
>  }
>  
> 

