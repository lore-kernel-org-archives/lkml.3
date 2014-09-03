Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756479AbaICPIo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Sep 2014 11:08:44 -0400
Received: from mail-we0-f179.google.com ([74.125.82.179]:38893 "EHLO
	mail-we0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752006AbaICPIm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Sep 2014 11:08:42 -0400
Date: Wed, 3 Sep 2014 18:08:36 +0300
From: Gleb Natapov <gleb@kernel.org>
To: Tang Chen <tangchen@cn.fujitsu.com>
Cc: mtosatti@redhat.com, nadav.amit@gmail.com, jan.kiszka@web.de,
        kvm@vger.kernel.org, laijs@cn.fujitsu.com,
        isimatu.yasuaki@jp.fujitsu.com, guz.fnst@cn.fujitsu.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v4 5/6] kvm, mem-hotplug: Reload L1's apic access page on
 migration when L2 is running.
Message-ID: <20140903150836.GK18167@minantech.com>
References: <1409134661-27916-1-git-send-email-tangchen@cn.fujitsu.com>
 <1409134661-27916-6-git-send-email-tangchen@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1409134661-27916-6-git-send-email-tangchen@cn.fujitsu.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 27, 2014 at 06:17:40PM +0800, Tang Chen wrote:
> This patch only handle "L1 and L2 vm share one apic access page" situation.
> 
> When L1 vm is running, if the shared apic access page is migrated, mmu_notifier will
> request all vcpus to exit to L0, and reload apic access page physical address for
> all the vcpus' vmcs (which is done by patch 5/6). And when it enters L2 vm, L2's vmcs
> will be updated in prepare_vmcs02() called by nested_vm_run(). So we need to do
> nothing.
> 
> When L2 vm is running, if the shared apic access page is migrated, mmu_notifier will
> request all vcpus to exit to L0, and reload apic access page physical address for
> all L2 vmcs. And this patch requests apic access page reload in L2->L1 vmexit.
> 
> Signed-off-by: Tang Chen <tangchen@cn.fujitsu.com>
> ---
>  arch/x86/include/asm/kvm_host.h |  1 +
>  arch/x86/kvm/svm.c              |  6 ++++++
>  arch/x86/kvm/vmx.c              | 32 ++++++++++++++++++++++++++++++++
>  arch/x86/kvm/x86.c              |  3 +++
>  virt/kvm/kvm_main.c             |  1 +
>  5 files changed, 43 insertions(+)
> 
> diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
> index 514183e..13fbb62 100644
> --- a/arch/x86/include/asm/kvm_host.h
> +++ b/arch/x86/include/asm/kvm_host.h
> @@ -740,6 +740,7 @@ struct kvm_x86_ops {
>  	void (*load_eoi_exitmap)(struct kvm_vcpu *vcpu, u64 *eoi_exit_bitmap);
>  	void (*set_virtual_x2apic_mode)(struct kvm_vcpu *vcpu, bool set);
>  	void (*set_apic_access_page_addr)(struct kvm *kvm, hpa_t hpa);
> +	void (*set_nested_apic_page_migrated)(struct kvm_vcpu *vcpu, bool set);
>  	void (*deliver_posted_interrupt)(struct kvm_vcpu *vcpu, int vector);
>  	void (*sync_pir_to_irr)(struct kvm_vcpu *vcpu);
>  	int (*set_tss_addr)(struct kvm *kvm, unsigned int addr);
> diff --git a/arch/x86/kvm/svm.c b/arch/x86/kvm/svm.c
> index f2eacc4..da88646 100644
> --- a/arch/x86/kvm/svm.c
> +++ b/arch/x86/kvm/svm.c
> @@ -3624,6 +3624,11 @@ static void svm_set_apic_access_page_addr(struct kvm *kvm, hpa_t hpa)
>  	return;
>  }
>  
> +static void svm_set_nested_apic_page_migrated(struct kvm_vcpu *vcpu, bool set)
> +{
> +	return;
> +}
> +
>  static int svm_vm_has_apicv(struct kvm *kvm)
>  {
>  	return 0;
> @@ -4379,6 +4384,7 @@ static struct kvm_x86_ops svm_x86_ops = {
>  	.update_cr8_intercept = update_cr8_intercept,
>  	.set_virtual_x2apic_mode = svm_set_virtual_x2apic_mode,
>  	.set_apic_access_page_addr = svm_set_apic_access_page_addr,
> +	.set_nested_apic_page_migrated = svm_set_nested_apic_page_migrated,
>  	.vm_has_apicv = svm_vm_has_apicv,
>  	.load_eoi_exitmap = svm_load_eoi_exitmap,
>  	.hwapic_isr_update = svm_hwapic_isr_update,
> diff --git a/arch/x86/kvm/vmx.c b/arch/x86/kvm/vmx.c
> index da6d55d..9035fd1 100644
> --- a/arch/x86/kvm/vmx.c
> +++ b/arch/x86/kvm/vmx.c
> @@ -379,6 +379,16 @@ struct nested_vmx {
>  	 * we must keep them pinned while L2 runs.
>  	 */
>  	struct page *apic_access_page;
> +	/*
> +	 * L1's apic access page can be migrated. When L1 and L2 are sharing
> +	 * the apic access page, after the page is migrated when L2 is running,
> +	 * we have to reload it to L1 vmcs before we enter L1.
> +	 *
> +	 * When the shared apic access page is migrated in L1 mode, we don't
> +	 * need to do anything else because we reload apic access page each
> +	 * time when entering L2 in prepare_vmcs02().
> +	 */
> +	bool apic_access_page_migrated;
>  	u64 msr_ia32_feature_control;
>  
>  	struct hrtimer preemption_timer;
> @@ -7098,6 +7108,12 @@ static void vmx_set_apic_access_page_addr(struct kvm *kvm, hpa_t hpa)
>  	vmcs_write64(APIC_ACCESS_ADDR, hpa);
>  }
>  
> +static void vmx_set_nested_apic_page_migrated(struct kvm_vcpu *vcpu, bool set)
> +{
> +	struct vcpu_vmx *vmx = to_vmx(vcpu);
> +	vmx->nested.apic_access_page_migrated = set;
> +}
> +
>  static void vmx_hwapic_isr_update(struct kvm *kvm, int isr)
>  {
>  	u16 status;
> @@ -8796,6 +8812,21 @@ static void nested_vmx_vmexit(struct kvm_vcpu *vcpu, u32 exit_reason,
>  	}
>  
>  	/*
> +	 * When shared (L1 & L2) apic access page is migrated during L2 is
> +	 * running, mmu_notifier will force to reload the page's hpa for L2
> +	 * vmcs. Need to reload it for L1 before entering L1.
> +	 */
> +	if (vmx->nested.apic_access_page_migrated) {
> +		/*
> +		 * Do not call kvm_reload_apic_access_page() because we are now
> +		 * in L2. We should not call make_all_cpus_request() to exit to
> +		 * L0, otherwise we will reload for L2 vmcs again.
> +		 */
> +		kvm_reload_apic_access_page(vcpu->kvm);
> +		vmx->nested.apic_access_page_migrated = false;
> +	}
I would just call kvm_reload_apic_access_page() unconditionally and only if
it will prove to be performance problem would optimize it further. Vmexit emulation it
pretty heavy, so I doubt one more vmwrite will be noticeable.

--
			Gleb.
