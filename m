Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754611AbaLDORO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Dec 2014 09:17:14 -0500
Received: from mail-wi0-f178.google.com ([209.85.212.178]:46206 "EHLO
	mail-wi0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754030AbaLDORM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Dec 2014 09:17:12 -0500
Message-ID: <54806CDF.50609@redhat.com>
Date: Thu, 04 Dec 2014 15:17:03 +0100
From: Paolo Bonzini <pbonzini@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
Newsgroups: gmane.linux.kernel,gmane.comp.emulators.kvm.devel
To: Wanpeng Li <wanpeng.li@linux.intel.com>
CC: Nadav Amit <nadav.amit@gmail.com>, rkrcmar@redhat.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 1/4] kvm: vmx: add nested virtualization support for
 xsaves
References: <1417691470-5221-1-git-send-email-wanpeng.li@linux.intel.com>
In-Reply-To: <1417691470-5221-1-git-send-email-wanpeng.li@linux.intel.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On 04/12/2014 12:11, Wanpeng Li wrote:
> Add nested virtualization support for xsaves.
> 
> Signed-off-by: Wanpeng Li <wanpeng.li@linux.intel.com>
> ---
>  arch/x86/kvm/vmx.c | 17 ++++++++++++++++-
>  1 file changed, 16 insertions(+), 1 deletion(-)
> 
> diff --git a/arch/x86/kvm/vmx.c b/arch/x86/kvm/vmx.c
> index 6e3a448..e5bc349 100644
> --- a/arch/x86/kvm/vmx.c
> +++ b/arch/x86/kvm/vmx.c
> @@ -216,6 +216,7 @@ struct __packed vmcs12 {
>  	u64 virtual_apic_page_addr;
>  	u64 apic_access_addr;
>  	u64 ept_pointer;
> +	u64 xss_exit_bitmap;
>  	u64 guest_physical_address;
>  	u64 vmcs_link_pointer;
>  	u64 guest_ia32_debugctl;
> @@ -618,6 +619,7 @@ static const unsigned short vmcs_field_to_offset_table[] = {
>  	FIELD64(VIRTUAL_APIC_PAGE_ADDR, virtual_apic_page_addr),
>  	FIELD64(APIC_ACCESS_ADDR, apic_access_addr),
>  	FIELD64(EPT_POINTER, ept_pointer),
> +	FIELD64(XSS_EXIT_BITMAP, xss_exit_bitmap),
>  	FIELD64(GUEST_PHYSICAL_ADDRESS, guest_physical_address),
>  	FIELD64(VMCS_LINK_POINTER, vmcs_link_pointer),
>  	FIELD64(GUEST_IA32_DEBUGCTL, guest_ia32_debugctl),
> @@ -1104,6 +1106,12 @@ static inline int nested_cpu_has_ept(struct vmcs12 *vmcs12)
>  	return nested_cpu_has2(vmcs12, SECONDARY_EXEC_ENABLE_EPT);
>  }
>  
> +static inline bool nested_cpu_has_xsaves(struct vmcs12 *vmcs12)
> +{
> +	return nested_cpu_has2(vmcs12, SECONDARY_EXEC_XSAVES) &&
> +		vmx_xsaves_supported();
> +}
> +
>  static inline bool is_exception(u32 intr_info)
>  {
>  	return (intr_info & (INTR_INFO_INTR_TYPE_MASK | INTR_INFO_VALID_MASK))
> @@ -2392,7 +2400,8 @@ static __init void nested_vmx_setup_ctls_msrs(void)
>  	nested_vmx_secondary_ctls_high &=
>  		SECONDARY_EXEC_VIRTUALIZE_APIC_ACCESSES |
>  		SECONDARY_EXEC_UNRESTRICTED_GUEST |
> -		SECONDARY_EXEC_WBINVD_EXITING;
> +		SECONDARY_EXEC_WBINVD_EXITING |
> +		SECONDARY_EXEC_XSAVES;
>  
>  	if (enable_ept) {
>  		/* nested EPT: emulate EPT also to L1 */
> @@ -7285,6 +7294,8 @@ static bool nested_vmx_exit_handled(struct kvm_vcpu *vcpu)
>  		return nested_cpu_has2(vmcs12, SECONDARY_EXEC_WBINVD_EXITING);
>  	case EXIT_REASON_XSETBV:
>  		return 1;
> +	case EXIT_REASON_XSAVES: case EXIT_REASON_XRSTORS:
> +		return nested_cpu_has2(vmcs12, SECONDARY_EXEC_XSAVES);

This assumes that we do not set any bit in the XSS exit bitmap in the
host, and/or that we do not allow setting any bit in the XSS msr itself.
 Otherwise we'd have to check the XSS MSR of the L2 guest against the
exit bitmap of the guest.

I'll add a FIXME here.

Paolo

>  	default:
>  		return 1;
>  	}
> @@ -8341,6 +8352,8 @@ static void prepare_vmcs02(struct kvm_vcpu *vcpu, struct vmcs12 *vmcs12)
>  	vmcs_writel(GUEST_SYSENTER_ESP, vmcs12->guest_sysenter_esp);
>  	vmcs_writel(GUEST_SYSENTER_EIP, vmcs12->guest_sysenter_eip);
>  
> +	if (nested_cpu_has_xsaves(vmcs12))
> +		vmcs_write64(XSS_EXIT_BITMAP, vmcs12->xss_exit_bitmap);
>  	vmcs_write64(VMCS_LINK_POINTER, -1ull);
>  
>  	exec_control = vmcs12->pin_based_vm_exec_control;
> @@ -8981,6 +8994,8 @@ static void prepare_vmcs12(struct kvm_vcpu *vcpu, struct vmcs12 *vmcs12,
>  	vmcs12->guest_sysenter_eip = vmcs_readl(GUEST_SYSENTER_EIP);
>  	if (vmx_mpx_supported())
>  		vmcs12->guest_bndcfgs = vmcs_read64(GUEST_BNDCFGS);
> +	if (nested_cpu_has_xsaves(vmcs12))
> +		vmcs12->xss_exit_bitmap = vmcs_read64(XSS_EXIT_BITMAP);
>  
>  	/* update exit information fields: */
>  
> 
