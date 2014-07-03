Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757107AbaGCNzY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jul 2014 09:55:24 -0400
Received: from mail-we0-f182.google.com ([74.125.82.182]:57946 "EHLO
	mail-we0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755055AbaGCNzW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jul 2014 09:55:22 -0400
Date: Thu, 3 Jul 2014 16:55:07 +0300
From: Gleb Natapov <gleb@kernel.org>
To: Tang Chen <tangchen@cn.fujitsu.com>
Cc: mtosatti@redhat.com, kvm@vger.kernel.org, laijs@cn.fujitsu.com,
        isimatu.yasuaki@jp.fujitsu.com, guz.fnst@cn.fujitsu.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 4/4] kvm, mem-hotplug: Update apic access page when it is
 migrated.
Message-ID: <20140703135507.GM18167@minantech.com>
References: <1404291637-15048-1-git-send-email-tangchen@cn.fujitsu.com>
 <1404291637-15048-5-git-send-email-tangchen@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1404291637-15048-5-git-send-email-tangchen@cn.fujitsu.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 02, 2014 at 05:00:37PM +0800, Tang Chen wrote:
> apic access page is pinned in memory, and as a result it cannot be
> migrated/hot-removed.
> 
> Actually it doesn't need to be pinned in memory.
> 
> This patch introduces a new vcpu request: KVM_REQ_MIGRATE_EPT. This requet
> will be made when kvm_mmu_notifier_invalidate_page() is called when the page
> is unmapped from the qemu user space to reset APIC_ACCESS_ADDR pointer in
> each online vcpu to 0. And will also be made when ept violation happens to
> reset APIC_ACCESS_ADDR to the new page phys_addr (host phys_addr).
> ---
>  arch/x86/include/asm/kvm_host.h |  2 ++
>  arch/x86/kvm/mmu.c              | 15 +++++++++++++++
>  arch/x86/kvm/vmx.c              |  9 ++++++++-
>  arch/x86/kvm/x86.c              | 20 ++++++++++++++++++++
>  include/linux/kvm_host.h        |  1 +
>  virt/kvm/kvm_main.c             | 15 +++++++++++++++
>  6 files changed, 61 insertions(+), 1 deletion(-)
> 
> diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
> index 8771c0f..f104b87 100644
> --- a/arch/x86/include/asm/kvm_host.h
> +++ b/arch/x86/include/asm/kvm_host.h
> @@ -575,6 +575,7 @@ struct kvm_arch {
>  
>  	unsigned int tss_addr;
>  	struct page *apic_access_page;
> +	bool apic_access_page_migrated;
Better have two requests KVM_REQ_APIC_PAGE_MAP, KVM_REQ_APIC_PAGE_UNMAP IMO.

>  
>  	gpa_t wall_clock;
>  
> @@ -739,6 +740,7 @@ struct kvm_x86_ops {
>  	void (*hwapic_isr_update)(struct kvm *kvm, int isr);
>  	void (*load_eoi_exitmap)(struct kvm_vcpu *vcpu, u64 *eoi_exit_bitmap);
>  	void (*set_virtual_x2apic_mode)(struct kvm_vcpu *vcpu, bool set);
> +	void (*set_apic_access_page_addr)(struct kvm *kvm, hpa_t hpa);
>  	void (*deliver_posted_interrupt)(struct kvm_vcpu *vcpu, int vector);
>  	void (*sync_pir_to_irr)(struct kvm_vcpu *vcpu);
>  	int (*set_tss_addr)(struct kvm *kvm, unsigned int addr);
> diff --git a/arch/x86/kvm/mmu.c b/arch/x86/kvm/mmu.c
> index c0d72f6..a655444 100644
> --- a/arch/x86/kvm/mmu.c
> +++ b/arch/x86/kvm/mmu.c
> @@ -3436,6 +3436,21 @@ static int tdp_page_fault(struct kvm_vcpu *vcpu, gva_t gpa, u32 error_code,
>  		kvm_make_request(KVM_REQ_MIGRATE_EPT, vcpu);
>  	}
>  
> +	if (gpa == VMX_APIC_ACCESS_PAGE_ADDR &&
> +	    vcpu->kvm->arch.apic_access_page_migrated) {
Why check arch.apic_access_page_migrated here? Isn't it enough that the fault is on apic
address.

> +		int i;
> +
> +		vcpu->kvm->arch.apic_access_page_migrated = false;
> +
> +		/*
> +		 * We need update APIC_ACCESS_ADDR pointer in each VMCS of
> +		 * all the online vcpus.
> +		 */
> +		for (i = 0; i < atomic_read(&vcpu->kvm->online_vcpus); i++)
> +			kvm_make_request(KVM_REQ_MIGRATE_APIC,
> +					 vcpu->kvm->vcpus[i]);
make_all_cpus_request(). You need to kick all vcpus from a guest mode.

> +	}
> +
>  	spin_unlock(&vcpu->kvm->mmu_lock);
>  
>  	return r;
> diff --git a/arch/x86/kvm/vmx.c b/arch/x86/kvm/vmx.c
> index c336cb3..abc152f 100644
> --- a/arch/x86/kvm/vmx.c
> +++ b/arch/x86/kvm/vmx.c
> @@ -3988,7 +3988,7 @@ static int alloc_apic_access_page(struct kvm *kvm)
>  	if (r)
>  		goto out;
>  
> -	page = gfn_to_page(kvm, VMX_APIC_ACCESS_PAGE_ADDR >> PAGE_SHIFT);
> +	page = gfn_to_page_no_pin(kvm, VMX_APIC_ACCESS_PAGE_ADDR >> PAGE_SHIFT);
>  	if (is_error_page(page)) {
>  		r = -EFAULT;
>  		goto out;
> @@ -7075,6 +7075,12 @@ static void vmx_set_virtual_x2apic_mode(struct kvm_vcpu *vcpu, bool set)
>  	vmx_set_msr_bitmap(vcpu);
>  }
>  
> +static void vmx_set_apic_access_page_addr(struct kvm *kvm, hpa_t hpa)
> +{
> +	if (vm_need_virtualize_apic_accesses(kvm))
This shouldn't even been called if apic access page is not supported. Nor
mmu_notifier path neither tdp_page_fault path should ever see 0xfee00000
address. BUG() is more appropriate here.


> +		vmcs_write64(APIC_ACCESS_ADDR, hpa);
> +}
> +
>  static void vmx_hwapic_isr_update(struct kvm *kvm, int isr)
>  {
>  	u16 status;
> @@ -8846,6 +8852,7 @@ static struct kvm_x86_ops vmx_x86_ops = {
>  	.enable_irq_window = enable_irq_window,
>  	.update_cr8_intercept = update_cr8_intercept,
>  	.set_virtual_x2apic_mode = vmx_set_virtual_x2apic_mode,
> +	.set_apic_access_page_addr = vmx_set_apic_access_page_addr,
svm needs that too.

>  	.vm_has_apicv = vmx_vm_has_apicv,
>  	.load_eoi_exitmap = vmx_load_eoi_exitmap,
>  	.hwapic_irr_update = vmx_hwapic_irr_update,
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index a26524f..14e7174 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -5943,6 +5943,24 @@ static void vcpu_migrated_page_update_ept(struct kvm_vcpu *vcpu)
>  	}
>  }
>  
> +static void vcpu_migrated_page_update_apic(struct kvm_vcpu *vcpu)
> +{
> +	struct kvm *kvm = vcpu->kvm;
> +
> +	if (kvm->arch.apic_access_page_migrated) {
> +		if (kvm->arch.apic_access_page)
> +			kvm->arch.apic_access_page = pfn_to_page(0);
All vcpus will access apic_access_page without locking here. May be
set kvm->arch.apic_access_page to zero in mmu_notifier and here call
 kvm_x86_ops->set_apic_access_page_addr(kvm, kvm->arch.apic_access_page);


> +		kvm_x86_ops->set_apic_access_page_addr(kvm, 0x0ull);
> +	} else {
> +		struct page *page;
> +		page = gfn_to_page_no_pin(kvm,
> +				VMX_APIC_ACCESS_PAGE_ADDR >> PAGE_SHIFT);
> +		kvm->arch.apic_access_page = page;
Same, set it during tdp fault when page is mapped.

> +		kvm_x86_ops->set_apic_access_page_addr(kvm,
> +						       page_to_phys(page));
> +	}
> +}
> +
>  /*
>   * Returns 1 to let __vcpu_run() continue the guest execution loop without
>   * exiting to the userspace.  Otherwise, the value will be returned to the
> @@ -6005,6 +6023,8 @@ static int vcpu_enter_guest(struct kvm_vcpu *vcpu)
>  			vcpu_scan_ioapic(vcpu);
>  		if (kvm_check_request(KVM_REQ_MIGRATE_EPT, vcpu))
>  			vcpu_migrated_page_update_ept(vcpu);
> +		if (kvm_check_request(KVM_REQ_MIGRATE_APIC, vcpu))
> +			vcpu_migrated_page_update_apic(vcpu);
>  	}
>  
>  	if (kvm_check_request(KVM_REQ_EVENT, vcpu) || req_int_win) {
> diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
> index 4b7e51a..e2ad65e 100644
> --- a/include/linux/kvm_host.h
> +++ b/include/linux/kvm_host.h
> @@ -137,6 +137,7 @@ static inline bool is_error_page(struct page *page)
>  #define KVM_REQ_ENABLE_IBS        23
>  #define KVM_REQ_DISABLE_IBS       24
>  #define KVM_REQ_MIGRATE_EPT       25
> +#define KVM_REQ_MIGRATE_APIC      26
>  
>  #define KVM_USERSPACE_IRQ_SOURCE_ID		0
>  #define KVM_IRQFD_RESAMPLE_IRQ_SOURCE_ID	1
> diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
> index d271e89..f06438c 100644
> --- a/virt/kvm/kvm_main.c
> +++ b/virt/kvm/kvm_main.c
> @@ -54,6 +54,7 @@
>  #include <asm/io.h>
>  #include <asm/uaccess.h>
>  #include <asm/pgtable.h>
> +#include <asm/vmx.h>
>  
>  #include "coalesced_mmio.h"
>  #include "async_pf.h"
> @@ -300,6 +301,20 @@ static void kvm_mmu_notifier_invalidate_page(struct mmu_notifier *mn,
>  		kvm_make_request(KVM_REQ_MIGRATE_EPT, kvm->vcpus[0]);
>  	}
>  
> +	if (address ==
> +	    gfn_to_hva(kvm, VMX_APIC_ACCESS_PAGE_ADDR >> PAGE_SHIFT)) {
> +		int i;
> +
> +		kvm->arch.apic_access_page_migrated = true;
> +
> +		/*
> +		 * We need update APIC_ACCESS_ADDR pointer in each VMCS of
> +		 * all the online vcpus.
> +		 */
> +		for (i = 0; i < atomic_read(&kvm->online_vcpus); i++)
> +			kvm_make_request(KVM_REQ_MIGRATE_APIC, kvm->vcpus[i]);
> +	}
make_all_cpus_request()

Also you need to drop put_page(kvm->arch.apic_access_page); from x86.c
> +
>  	spin_unlock(&kvm->mmu_lock);
>  	srcu_read_unlock(&kvm->srcu, idx);
>  }
> -- 
> 1.8.3.1
> 

--
			Gleb.
