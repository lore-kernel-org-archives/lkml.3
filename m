Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753861AbaLBI72 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Dec 2014 03:59:28 -0500
Received: from mga11.intel.com ([192.55.52.93]:42474 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750907AbaLBI71 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Dec 2014 03:59:27 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.07,499,1413270000"; 
   d="scan'208";a="641219755"
Date: Tue, 2 Dec 2014 16:38:38 +0800
From: Wanpeng Li <wanpeng.li@linux.intel.com>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 2/2] kvm: vmx: enable intel xsaves for guest
Message-ID: <20141202083838.GA19534@kernel>
Reply-To: Wanpeng Li <wanpeng.li@linux.intel.com>
References: <1417500894-7604-1-git-send-email-wanpeng.li@linux.intel.com>
 <1417500894-7604-2-git-send-email-wanpeng.li@linux.intel.com>
 <547D7D8A.2090008@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <547D7D8A.2090008@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Paolo,
On Tue, Dec 02, 2014 at 09:51:22AM +0100, Paolo Bonzini wrote:
>
>
>On 02/12/2014 07:14, Wanpeng Li wrote:
>> Expose intel xsaves feature to guest.
>> 
>> Signed-off-by: Wanpeng Li <wanpeng.li@linux.intel.com>
>> ---
>> v1 -> v2:
>>  *auto switch msr ia32_xss if this msr is present
>> 
>>  arch/x86/include/asm/kvm_host.h |  1 +
>>  arch/x86/include/asm/vmx.h      |  3 +++
>>  arch/x86/include/uapi/asm/vmx.h |  6 +++++-
>>  arch/x86/kvm/vmx.c              | 35 ++++++++++++++++++++++++++++++++++-
>>  4 files changed, 43 insertions(+), 2 deletions(-)
>> 
>> diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
>> index 2896dbc..95dde42 100644
>> --- a/arch/x86/include/asm/kvm_host.h
>> +++ b/arch/x86/include/asm/kvm_host.h
>> @@ -362,6 +362,7 @@ struct kvm_vcpu_arch {
>>  	int mp_state;
>>  	u64 ia32_misc_enable_msr;
>>  	bool tpr_access_reporting;
>> +	u64 ia32_xss;
>
>The patch is not getting/setting ia32_xss when the guest does
>RDMSR/WRMSR.  You also need a QEMU patch to migrate XSS.

Will do.

>
>>  	/*
>>  	 * Paging state of the vcpu
>> diff --git a/arch/x86/include/asm/vmx.h b/arch/x86/include/asm/vmx.h
>> index bcbfade..bdb79ef 100644
>> --- a/arch/x86/include/asm/vmx.h
>> +++ b/arch/x86/include/asm/vmx.h
>> @@ -69,6 +69,7 @@
>>  #define SECONDARY_EXEC_PAUSE_LOOP_EXITING	0x00000400
>>  #define SECONDARY_EXEC_ENABLE_INVPCID		0x00001000
>>  #define SECONDARY_EXEC_SHADOW_VMCS              0x00004000
>> +#define SECONDARY_EXEC_XSAVES			0x00100000
>>  
>>  
>>  #define PIN_BASED_EXT_INTR_MASK                 0x00000001
>> @@ -159,6 +160,8 @@ enum vmcs_field {
>>  	EOI_EXIT_BITMAP3_HIGH           = 0x00002023,
>>  	VMREAD_BITMAP                   = 0x00002026,
>>  	VMWRITE_BITMAP                  = 0x00002028,
>> +	XSS_EXIT_BIMTAP                 = 0x0000202C,
>> +	XSS_EXIT_BIMTAP_HIGH            = 0x0000202D,
>
>s/BIMTAP/BITMAP/

Ok.

>
>>  	GUEST_PHYSICAL_ADDRESS          = 0x00002400,
>>  	GUEST_PHYSICAL_ADDRESS_HIGH     = 0x00002401,
>>  	VMCS_LINK_POINTER               = 0x00002800,
>> diff --git a/arch/x86/include/uapi/asm/vmx.h b/arch/x86/include/uapi/asm/vmx.h
>> index 990a2fe..b813bf9 100644
>> --- a/arch/x86/include/uapi/asm/vmx.h
>> +++ b/arch/x86/include/uapi/asm/vmx.h
>> @@ -72,6 +72,8 @@
>>  #define EXIT_REASON_XSETBV              55
>>  #define EXIT_REASON_APIC_WRITE          56
>>  #define EXIT_REASON_INVPCID             58
>> +#define EXIT_REASON_XSAVES              63
>> +#define EXIT_REASON_XRSTORS             64
>>  
>>  #define VMX_EXIT_REASONS \
>>  	{ EXIT_REASON_EXCEPTION_NMI,         "EXCEPTION_NMI" }, \
>> @@ -116,6 +118,8 @@
>>  	{ EXIT_REASON_INVALID_STATE,         "INVALID_STATE" }, \
>>  	{ EXIT_REASON_INVD,                  "INVD" }, \
>>  	{ EXIT_REASON_INVVPID,               "INVVPID" }, \
>> -	{ EXIT_REASON_INVPCID,               "INVPCID" }
>> +	{ EXIT_REASON_INVPCID,               "INVPCID" }, \
>> +	{ EXIT_REASON_XSAVES,                "XSAVES" }, \
>> +	{ EXIT_REASON_XRSTORS,               "XRSTORS" }
>>  
>>  #endif /* _UAPIVMX_H */
>> diff --git a/arch/x86/kvm/vmx.c b/arch/x86/kvm/vmx.c
>> index 6a951d8..b87b5b8 100644
>> --- a/arch/x86/kvm/vmx.c
>> +++ b/arch/x86/kvm/vmx.c
>> @@ -1045,6 +1045,12 @@ static inline bool cpu_has_vmx_invpcid(void)
>>  		SECONDARY_EXEC_ENABLE_INVPCID;
>>  }
>>  
>> +static inline bool cpu_has_xss_exit_bitmap(void)
>> +{
>> +	return vmcs_config.cpu_based_2nd_exec_ctrl &
>> +		SECONDARY_EXEC_XSAVES;
>> +}
>> +
>>  static inline bool cpu_has_virtual_nmis(void)
>>  {
>>  	return vmcs_config.pin_based_exec_ctrl & PIN_BASED_VIRTUAL_NMIS;
>> @@ -1773,6 +1779,14 @@ static void vmx_save_host_state(struct kvm_vcpu *vcpu)
>>  		kvm_set_shared_msr(vmx->guest_msrs[i].index,
>>  				   vmx->guest_msrs[i].data,
>>  				   vmx->guest_msrs[i].mask);
>> +
>> +	if (cpu_has_xsaves) {
>> +		u64 host_xss;
>> +
>> +		rdmsrl(MSR_IA32_XSS, host_xss);
>
>Is this host value fixed?  If so, please load it just once in
>setup_vmcs_config.

Will do.

>
>> +		add_atomic_switch_msr(vmx, MSR_IA32_XSS,
>> +				vcpu->arch.ia32_xss, host_xss);
>
>Also, if host_xss is fixed you can do this add_atomic_switch_msr at
>WRMSR time rather than here, and only if vcpu->arch.ia32_xss !=
>host_xss.  If the two XSS values match, do clear_atomic_switch_msr instead.

Agreed.

>
>> +	}
>>  }
>>  
>>  static void __vmx_load_host_state(struct vcpu_vmx *vmx)
>> @@ -2895,7 +2909,8 @@ static __init int setup_vmcs_config(struct vmcs_config *vmcs_conf)
>>  			SECONDARY_EXEC_ENABLE_INVPCID |
>>  			SECONDARY_EXEC_APIC_REGISTER_VIRT |
>>  			SECONDARY_EXEC_VIRTUAL_INTR_DELIVERY |
>> -			SECONDARY_EXEC_SHADOW_VMCS;
>> +			SECONDARY_EXEC_SHADOW_VMCS |
>> +			SECONDARY_EXEC_XSAVES;
>>  		if (adjust_vmx_controls(min2, opt2,
>>  					MSR_IA32_VMX_PROCBASED_CTLS2,
>>  					&_cpu_based_2nd_exec_control) < 0)
>> @@ -4346,6 +4361,7 @@ static int vmx_vcpu_setup(struct vcpu_vmx *vmx)
>>  	unsigned long a;
>>  #endif
>>  	int i;
>> +	u64 xss = 0;
>
>#define VMX_XSS_EXIT_BITMAP	0
>

Ok.

>>  
>>  	/* I/O */
>>  	vmcs_write64(IO_BITMAP_A, __pa(vmx_io_bitmap_a));
>> @@ -4446,6 +4462,9 @@ static int vmx_vcpu_setup(struct vcpu_vmx *vmx)
>>  	vmcs_writel(CR0_GUEST_HOST_MASK, ~0UL);
>>  	set_cr4_guest_host_mask(vmx);
>>  
>> +	if (cpu_has_xss_exit_bitmap())
>> +		vmcs_write64(XSS_EXIT_BIMTAP, xss);
>> +
>>  	return 0;
>>  }
>>  
>> @@ -5334,6 +5353,18 @@ static int handle_xsetbv(struct kvm_vcpu *vcpu)
>>  	return 1;
>>  }
>>  
>> +static int handle_xsaves(struct kvm_vcpu *vcpu)
>> +{
>> +	skip_emulated_instruction(vcpu);
>> +	return 1;
>
>Please WARN(), this should never happen.

Ok.

>
>> +}
>> +
>> +static int handle_xrstors(struct kvm_vcpu *vcpu)
>> +{
>> +	skip_emulated_instruction(vcpu);
>> +	return 1;
>
>Same here.
>
>> +}
>> +
>>  static int handle_apic_access(struct kvm_vcpu *vcpu)
>>  {
>>  	if (likely(fasteoi)) {
>> @@ -6951,6 +6982,8 @@ static int (*const kvm_vmx_exit_handlers[])(struct kvm_vcpu *vcpu) = {
>>  	[EXIT_REASON_MONITOR_INSTRUCTION]     = handle_monitor,
>>  	[EXIT_REASON_INVEPT]                  = handle_invept,
>>  	[EXIT_REASON_INVVPID]                 = handle_invvpid,
>> +	[EXIT_REASON_XSAVES]                  = handle_xsaves,
>> +	[EXIT_REASON_XRSTORS]                 = handle_xrstors,
>>  };
>>  
>>  static const int kvm_vmx_max_exit_handlers =
>> 

Thanks for your review, I fix these issues in next version.

Regards,
Wanpeng Li 
