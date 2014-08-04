Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752753AbaHDMxe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Aug 2014 08:53:34 -0400
Received: from mail-we0-f177.google.com ([74.125.82.177]:62186 "EHLO
	mail-we0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751249AbaHDMxc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Aug 2014 08:53:32 -0400
Message-ID: <53DF8243.4070706@redhat.com>
Date: Mon, 04 Aug 2014 14:53:23 +0200
From: Paolo Bonzini <pbonzini@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Wanpeng Li <wanpeng.li@linux.intel.com>,
        Jan Kiszka <jan.kiszka@siemens.com>
CC: Marcelo Tosatti <mtosatti@redhat.com>, Gleb Natapov <gleb@kernel.org>,
        Bandan Das <bsd@redhat.com>, Zhang Yang <yang.z.zhang@intel.com>,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3] KVM: nVMX: nested TPR shadow/threshold emulation
References: <1407149907-13483-1-git-send-email-wanpeng.li@linux.intel.com>
In-Reply-To: <1407149907-13483-1-git-send-email-wanpeng.li@linux.intel.com>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Il 04/08/2014 12:58, Wanpeng Li ha scritto:
> This patch fix bug https://bugzilla.kernel.org/show_bug.cgi?id=61411
> 
> TPR shadow/threshold feature is important to speed up the Windows guest.
> Besides, it is a must feature for certain VMM.
> 
> We map virtual APIC page address and TPR threshold from L1 VMCS. If
> TPR_BELOW_THRESHOLD VM exit is triggered by L2 guest and L1 interested
> in, we inject it into L1 VMM for handling.
> 
> Signed-off-by: Wanpeng Li <wanpeng.li@linux.intel.com>
> ---
> v2 -> v3:
>  * nested vm entry failure if both tpr shadow and cr8 exiting bits are not set 
> v1 -> v2:
>  * don't take L0's "virtualize APIC accesses" setting into account
>  * virtual_apic_page do exactly the same thing that is done for apic_access_page
>  * add the tpr threshold field to the read-write fields for shadow VMCS
> 
>  arch/x86/kvm/vmx.c | 38 ++++++++++++++++++++++++++++++++++++--
>  1 file changed, 36 insertions(+), 2 deletions(-)
> 
> diff --git a/arch/x86/kvm/vmx.c b/arch/x86/kvm/vmx.c
> index c604f3c..7a56e2c 100644
> --- a/arch/x86/kvm/vmx.c
> +++ b/arch/x86/kvm/vmx.c
> @@ -379,6 +379,7 @@ struct nested_vmx {
>  	 * we must keep them pinned while L2 runs.
>  	 */
>  	struct page *apic_access_page;
> +	struct page *virtual_apic_page;
>  	u64 msr_ia32_feature_control;
>  
>  	struct hrtimer preemption_timer;
> @@ -533,6 +534,7 @@ static int max_shadow_read_only_fields =
>  	ARRAY_SIZE(shadow_read_only_fields);
>  
>  static unsigned long shadow_read_write_fields[] = {
> +	TPR_THRESHOLD,
>  	GUEST_RIP,
>  	GUEST_RSP,
>  	GUEST_CR0,
> @@ -2330,7 +2332,7 @@ static __init void nested_vmx_setup_ctls_msrs(void)
>  		CPU_BASED_MOV_DR_EXITING | CPU_BASED_UNCOND_IO_EXITING |
>  		CPU_BASED_USE_IO_BITMAPS | CPU_BASED_MONITOR_EXITING |
>  		CPU_BASED_RDPMC_EXITING | CPU_BASED_RDTSC_EXITING |
> -		CPU_BASED_PAUSE_EXITING |
> +		CPU_BASED_PAUSE_EXITING | CPU_BASED_TPR_SHADOW |
>  		CPU_BASED_ACTIVATE_SECONDARY_CONTROLS;
>  	/*
>  	 * We can allow some features even when not supported by the
> @@ -6148,6 +6150,10 @@ static void free_nested(struct vcpu_vmx *vmx)
>  		nested_release_page(vmx->nested.apic_access_page);
>  		vmx->nested.apic_access_page = 0;
>  	}
> +	if (vmx->nested.virtual_apic_page) {
> +		nested_release_page(vmx->nested.virtual_apic_page);
> +		vmx->nested.virtual_apic_page = 0;
> +	}
>  
>  	nested_free_all_saved_vmcss(vmx);
>  }
> @@ -6936,7 +6942,7 @@ static bool nested_vmx_exit_handled(struct kvm_vcpu *vcpu)
>  	case EXIT_REASON_MCE_DURING_VMENTRY:
>  		return 0;
>  	case EXIT_REASON_TPR_BELOW_THRESHOLD:
> -		return 1;
> +		return nested_cpu_has(vmcs12, CPU_BASED_TPR_SHADOW);
>  	case EXIT_REASON_APIC_ACCESS:
>  		return nested_cpu_has2(vmcs12,
>  			SECONDARY_EXEC_VIRTUALIZE_APIC_ACCESSES);
> @@ -7057,6 +7063,9 @@ static int vmx_handle_exit(struct kvm_vcpu *vcpu)
>  
>  static void update_cr8_intercept(struct kvm_vcpu *vcpu, int tpr, int irr)
>  {
> +	if (is_guest_mode(vcpu))
> +		return;
> +
>  	if (irr == -1 || tpr < irr) {
>  		vmcs_write32(TPR_THRESHOLD, 0);
>  		return;
> @@ -8024,6 +8033,27 @@ static void prepare_vmcs02(struct kvm_vcpu *vcpu, struct vmcs12 *vmcs12)
>  	exec_control &= ~CPU_BASED_VIRTUAL_NMI_PENDING;
>  	exec_control &= ~CPU_BASED_TPR_SHADOW;
>  	exec_control |= vmcs12->cpu_based_vm_exec_control;
> +
> +	if (exec_control & CPU_BASED_TPR_SHADOW) {
> +		if (vmx->nested.virtual_apic_page)
> +			nested_release_page(vmx->nested.virtual_apic_page);
> +		vmx->nested.virtual_apic_page =
> +		   nested_get_page(vcpu, vmcs12->virtual_apic_page_addr);
> +		if (!vmx->nested.virtual_apic_page)
> +			exec_control &=
> +				~CPU_BASED_TPR_SHADOW;
> +		else
> +			vmcs_write64(VIRTUAL_APIC_PAGE_ADDR,
> +				page_to_phys(vmx->nested.virtual_apic_page));
> +
> +		if (!(exec_control & CPU_BASED_TPR_SHADOW) &&
> +			!((exec_control & CPU_BASED_CR8_LOAD_EXITING) &&
> +				(exec_control & CPU_BASED_CR8_STORE_EXITING)))
> +			nested_vmx_failValid(vcpu, VMXERR_ENTRY_INVALID_CONTROL_FIELD);
> +
> +		vmcs_write32(TPR_THRESHOLD, vmcs12->tpr_threshold);
> +	}
> +
>  	/*
>  	 * Merging of IO and MSR bitmaps not currently supported.
>  	 * Rather, exit every time.
> @@ -8802,6 +8832,10 @@ static void nested_vmx_vmexit(struct kvm_vcpu *vcpu, u32 exit_reason,
>  		nested_release_page(vmx->nested.apic_access_page);
>  		vmx->nested.apic_access_page = 0;
>  	}
> +	if (vmx->nested.virtual_apic_page) {
> +		nested_release_page(vmx->nested.virtual_apic_page);
> +		vmx->nested.virtual_apic_page = 0;
> +	}
>  
>  	/*
>  	 * Exiting from L2 to L1, we're now back to L1 which thinks it just
> 

Reviewed-by: Paolo Bonzini <pbonzini@redhat.com>

I will apply this for 3.18.  Thanks,

Paolo
