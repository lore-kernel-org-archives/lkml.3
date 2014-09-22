Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753887AbaIVJuf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Sep 2014 05:50:35 -0400
Received: from mail-wg0-f49.google.com ([74.125.82.49]:62651 "EHLO
	mail-wg0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750914AbaIVJub (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Sep 2014 05:50:31 -0400
Message-ID: <541FF0E4.2090103@redhat.com>
Date: Mon, 22 Sep 2014 11:50:28 +0200
From: Paolo Bonzini <pbonzini@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.0
MIME-Version: 1.0
To: Tang Chen <tangchen@cn.fujitsu.com>, gleb@kernel.org, mtosatti@redhat.com,
        nadav.amit@gmail.com, jan.kiszka@web.de
CC: kvm@vger.kernel.org, laijs@cn.fujitsu.com, isimatu.yasuaki@jp.fujitsu.com,
        guz.fnst@cn.fujitsu.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v7 4/9] kvm: Add interface to check if secondary exec
 virtualzed apic accesses is enabled.
References: <1411210071-14727-1-git-send-email-tangchen@cn.fujitsu.com> <1411210071-14727-5-git-send-email-tangchen@cn.fujitsu.com>
In-Reply-To: <1411210071-14727-5-git-send-email-tangchen@cn.fujitsu.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Il 20/09/2014 12:47, Tang Chen ha scritto:
> We wants to migrate apic access page pinned by guest (L1 and L2) to make memory
> hotplug available.
> 
> There are two situations need to be handled for apic access page used by L2 vm:
> 1. L1 prepares a separate apic access page for L2.
> 
>    L2 pins a lot of pages in memory. Even if we can migrate apic access page,
>    memory hotplug is not available when L2 is running. So do not handle this
>    now. Migrate apic access page only.
> 
> 2. L1 and L2 share one apic access page.
> 
>    Since we will migrate L1's apic access page, we should do some handling when
>    migration happens in the following situations:
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
> Since we don't handle L1 ans L2 have separate apic access pages situation,
> when we update vmcs, we need to check if we are in L2 and if L2's secondary
> exec virtualzed apic accesses is enabled.
> 
> This patch adds an interface to check if L2's secondary exec virtualzed apic
> accesses is enabled, because vmx cannot be accessed outside vmx.c.
> 
> Signed-off-by: Tang Chen <tangchen@cn.fujitsu.com>
> ---
>  arch/x86/include/asm/kvm_host.h | 1 +
>  arch/x86/kvm/svm.c              | 6 ++++++
>  arch/x86/kvm/vmx.c              | 9 +++++++++
>  3 files changed, 16 insertions(+)
> 
> diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
> index 35171c7..69fe032 100644
> --- a/arch/x86/include/asm/kvm_host.h
> +++ b/arch/x86/include/asm/kvm_host.h
> @@ -739,6 +739,7 @@ struct kvm_x86_ops {
>  	void (*hwapic_isr_update)(struct kvm *kvm, int isr);
>  	void (*load_eoi_exitmap)(struct kvm_vcpu *vcpu, u64 *eoi_exit_bitmap);
>  	void (*set_virtual_x2apic_mode)(struct kvm_vcpu *vcpu, bool set);
> +	bool (*has_secondary_apic_access)(struct kvm_vcpu *vcpu);
>  	void (*deliver_posted_interrupt)(struct kvm_vcpu *vcpu, int vector);
>  	void (*sync_pir_to_irr)(struct kvm_vcpu *vcpu);
>  	int (*set_tss_addr)(struct kvm *kvm, unsigned int addr);
> diff --git a/arch/x86/kvm/svm.c b/arch/x86/kvm/svm.c
> index 1d941ad..9c8ae32 100644
> --- a/arch/x86/kvm/svm.c
> +++ b/arch/x86/kvm/svm.c
> @@ -3619,6 +3619,11 @@ static void svm_set_virtual_x2apic_mode(struct kvm_vcpu *vcpu, bool set)
>  	return;
>  }
>  
> +static bool svm_has_secondary_apic_access(struct kvm_vcpu *vcpu)
> +{
> +	return false;
> +}
> +
>  static int svm_vm_has_apicv(struct kvm *kvm)
>  {
>  	return 0;
> @@ -4373,6 +4378,7 @@ static struct kvm_x86_ops svm_x86_ops = {
>  	.enable_irq_window = enable_irq_window,
>  	.update_cr8_intercept = update_cr8_intercept,
>  	.set_virtual_x2apic_mode = svm_set_virtual_x2apic_mode,
> +	.has_secondary_apic_access = svm_has_secondary_apic_access,
>  	.vm_has_apicv = svm_vm_has_apicv,
>  	.load_eoi_exitmap = svm_load_eoi_exitmap,
>  	.hwapic_isr_update = svm_hwapic_isr_update,
> diff --git a/arch/x86/kvm/vmx.c b/arch/x86/kvm/vmx.c
> index 72a0470..0b541d9 100644
> --- a/arch/x86/kvm/vmx.c
> +++ b/arch/x86/kvm/vmx.c
> @@ -7090,6 +7090,14 @@ static void vmx_set_virtual_x2apic_mode(struct kvm_vcpu *vcpu, bool set)
>  	vmx_set_msr_bitmap(vcpu);
>  }
>  
> +static bool vmx_has_secondary_apic_access(struct kvm_vcpu *vcpu)
> +{
> +	struct vcpu_vmx *vmx = to_vmx(vcpu);
> +
> +	return (vmx->nested.current_vmcs12->secondary_vm_exec_control &
> +		SECONDARY_EXEC_VIRTUALIZE_APIC_ACCESSES);
> +}
> +
>  static void vmx_hwapic_isr_update(struct kvm *kvm, int isr)
>  {
>  	u16 status;
> @@ -8909,6 +8917,7 @@ static struct kvm_x86_ops vmx_x86_ops = {
>  	.enable_irq_window = enable_irq_window,
>  	.update_cr8_intercept = update_cr8_intercept,
>  	.set_virtual_x2apic_mode = vmx_set_virtual_x2apic_mode,
> +	.has_secondary_apic_access = vmx_has_secondary_apic_access,
>  	.vm_has_apicv = vmx_vm_has_apicv,
>  	.load_eoi_exitmap = vmx_load_eoi_exitmap,
>  	.hwapic_irr_update = vmx_hwapic_irr_update,
> 

I don't think you need two hooks.  You can just do the gfn_to_page
unconditionally in kvm_vcpu_reload_apic_access_page, like

	vcpu->kvm->arch.apic_access_page = gfn_to_page(vcpu->kvm,
			APIC_DEFAULT_PHYS_BASE >> PAGE_SHIFT);
	if (vcpu->kvm->arch.apic_access_page)
		kvm_x86_ops->set_apic_access_page_addr(vcpu->kvm,
			page_to_phys(vcpu->kvm->arch.apic_access_page));
	/* The last patch adds put_page here.  */

and check is_guest_mode etc. in vmx.c.  The extra gfn_to_page/put_page
is rare enough that you can just do it unconditionally.

Another small change; you shouldn't run this code unless the APIC page
is in use.  So you can add

	if (!kvm_x86_ops->set_apic_access_page_addr)
		return;

and in the vmx.c file, please also add this change:

-	if (!cpu_has_vmx_flexpriority())
+	if (!cpu_has_vmx_flexpriority()) {
		flexpriority_enabled = 0;
+		kvm_x86_ops->set_apic_access_page_addr = NULL;
+	}

so that the callback is skipped correctly for old processors that lack
the APIC_ACCESS_ADDR field.

Paolo
