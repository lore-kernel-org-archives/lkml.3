Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752542AbaHDLCK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Aug 2014 07:02:10 -0400
Received: from mga02.intel.com ([134.134.136.20]:25912 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751854AbaHDLCI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Aug 2014 07:02:08 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.01,797,1400050800"; 
   d="scan'208";a="553371427"
Date: Mon, 4 Aug 2014 19:03:08 +0800
From: Wanpeng Li <wanpeng.li@linux.intel.com>
To: Paolo Bonzini <pbonzini@redhat.com>, Jan Kiszka <jan.kiszka@siemens.com>
Cc: Marcelo Tosatti <mtosatti@redhat.com>, Gleb Natapov <gleb@kernel.org>,
        Bandan Das <bsd@redhat.com>, Zhang Yang <yang.z.zhang@intel.com>,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] KVM: nVMX: nested TPR shadow/threshold emulation
Message-ID: <20140804110308.GA10485@kernel>
Reply-To: Wanpeng Li <wanpeng.li@linux.intel.com>
References: <1406880570-9746-1-git-send-email-wanpeng.li@linux.intel.com>
 <53DB5849.2070508@redhat.com>
 <20140804101122.GA9754@kernel>
 <53DF5CB9.5000903@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <53DF5CB9.5000903@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 04, 2014 at 12:13:13PM +0200, Paolo Bonzini wrote:
>Il 04/08/2014 12:11, Wanpeng Li ha scritto:
>> Hi Paolo,
>> On Fri, Aug 01, 2014 at 11:05:13AM +0200, Paolo Bonzini wrote:
>>> Il 01/08/2014 10:09, Wanpeng Li ha scritto:
>>>> This patch fix bug https://bugzilla.kernel.org/show_bug.cgi?id=61411
>>>>
>>>> TPR shadow/threshold feature is important to speed up the Windows guest.
>>>> Besides, it is a must feature for certain VMM.
>>>>
>>>> We map virtual APIC page address and TPR threshold from L1 VMCS. If
>>>> TPR_BELOW_THRESHOLD VM exit is triggered by L2 guest and L1 interested
>>>> in, we inject it into L1 VMM for handling.
>>>>
>>>> Signed-off-by: Wanpeng Li <wanpeng.li@linux.intel.com>
>>>> ---
>>>> v1 -> v2:
>>>>  * don't take L0's "virtualize APIC accesses" setting into account
>>>>  * virtual_apic_page do exactly the same thing that is done for apic_access_page
>>>>  * add the tpr threshold field to the read-write fields for shadow VMCS
>>>>
>>>>  arch/x86/kvm/vmx.c | 33 +++++++++++++++++++++++++++++++--
>>>>  1 file changed, 31 insertions(+), 2 deletions(-)
>>>>
>>>> diff --git a/arch/x86/kvm/vmx.c b/arch/x86/kvm/vmx.c
>>>> index a3845b8..0e6e95e 100644
>>>> --- a/arch/x86/kvm/vmx.c
>>>> +++ b/arch/x86/kvm/vmx.c
>>>> @@ -379,6 +379,7 @@ struct nested_vmx {
>>>>  	 * we must keep them pinned while L2 runs.
>>>>  	 */
>>>>  	struct page *apic_access_page;
>>>> +	struct page *virtual_apic_page;
>>>>  	u64 msr_ia32_feature_control;
>>>>  
>>>>  	struct hrtimer preemption_timer;
>>>> @@ -533,6 +534,7 @@ static int max_shadow_read_only_fields =
>>>>  	ARRAY_SIZE(shadow_read_only_fields);
>>>>  
>>>>  static unsigned long shadow_read_write_fields[] = {
>>>> +	TPR_THRESHOLD,
>>>>  	GUEST_RIP,
>>>>  	GUEST_RSP,
>>>>  	GUEST_CR0,
>>>> @@ -2331,7 +2333,7 @@ static __init void nested_vmx_setup_ctls_msrs(void)
>>>>  		CPU_BASED_MOV_DR_EXITING | CPU_BASED_UNCOND_IO_EXITING |
>>>>  		CPU_BASED_USE_IO_BITMAPS | CPU_BASED_MONITOR_EXITING |
>>>>  		CPU_BASED_RDPMC_EXITING | CPU_BASED_RDTSC_EXITING |
>>>> -		CPU_BASED_PAUSE_EXITING |
>>>> +		CPU_BASED_PAUSE_EXITING | CPU_BASED_TPR_SHADOW |
>>>>  		CPU_BASED_ACTIVATE_SECONDARY_CONTROLS;
>>>>  	/*
>>>>  	 * We can allow some features even when not supported by the
>>>> @@ -6149,6 +6151,10 @@ static void free_nested(struct vcpu_vmx *vmx)
>>>>  		nested_release_page(vmx->nested.apic_access_page);
>>>>  		vmx->nested.apic_access_page = 0;
>>>>  	}
>>>> +	if (vmx->nested.virtual_apic_page) {
>>>> +		nested_release_page(vmx->nested.virtual_apic_page);
>>>> +		vmx->nested.virtual_apic_page = 0;
>>>> +	}
>>>>  
>>>>  	nested_free_all_saved_vmcss(vmx);
>>>>  }
>>>> @@ -6937,7 +6943,7 @@ static bool nested_vmx_exit_handled(struct kvm_vcpu *vcpu)
>>>>  	case EXIT_REASON_MCE_DURING_VMENTRY:
>>>>  		return 0;
>>>>  	case EXIT_REASON_TPR_BELOW_THRESHOLD:
>>>> -		return 1;
>>>> +		return nested_cpu_has(vmcs12, CPU_BASED_TPR_SHADOW);
>>>>  	case EXIT_REASON_APIC_ACCESS:
>>>>  		return nested_cpu_has2(vmcs12,
>>>>  			SECONDARY_EXEC_VIRTUALIZE_APIC_ACCESSES);
>>>> @@ -7058,6 +7064,9 @@ static int vmx_handle_exit(struct kvm_vcpu *vcpu)
>>>>  
>>>>  static void update_cr8_intercept(struct kvm_vcpu *vcpu, int tpr, int irr)
>>>>  {
>>>> +	if (is_guest_mode(vcpu))
>>>> +		return;
>>>> +
>>>>  	if (irr == -1 || tpr < irr) {
>>>>  		vmcs_write32(TPR_THRESHOLD, 0);
>>>>  		return;
>>>> @@ -8025,6 +8034,22 @@ static void prepare_vmcs02(struct kvm_vcpu *vcpu, struct vmcs12 *vmcs12)
>>>>  	exec_control &= ~CPU_BASED_VIRTUAL_NMI_PENDING;
>>>>  	exec_control &= ~CPU_BASED_TPR_SHADOW;
>>>>  	exec_control |= vmcs12->cpu_based_vm_exec_control;
>>>> +
>>>> +	if (exec_control & CPU_BASED_TPR_SHADOW) {
>>>> +		if (vmx->nested.virtual_apic_page)
>>>> +			nested_release_page(vmx->nested.virtual_apic_page);
>>>> +		vmx->nested.virtual_apic_page =
>>>> +		   nested_get_page(vcpu, vmcs12->virtual_apic_page_addr);
>>>> +		if (!vmx->nested.virtual_apic_page)
>>>> +			exec_control &=
>>>> +				~CPU_BASED_TPR_SHADOW;
>>>
>>> This will cause L1 to miss exits when L2 writes to CR8.  I think the
>>> only sensible thing to do if this happens is fail the vmentry.
>>>
>>> The problem is that while the APIC access page field is used to trap
>>> reads/writes to the APIC access page itself, here the processor will
>>> read/write the virtual APIC page when L2 does CR8 accesses.
>> 
>> How about add this:
>> 
>> +	if (!(exec_control & CPU_BASED_TPR_SHADOW) &&
>> +		!((exec_control & CPU_BASED_CR8_LOAD_EXITING) &&
>> +			(exec_control & CPU_BASED_CR8_STORE_EXITING)))
>> +				nested_vmx_failValid(vcpu, VMXERR_ENTRY_INVALID_CONTROL_FIELD);
>
>Yes, this is not architecturally correct, but I don't see what else we
>can do.
>

Ok, just send out the new version.

Regards,
Wanpeng Li 

>Paolo
>
>> 
>> Regards,
>> Wanpeng Li 
>> 
>>>
>>> Paolo
>>>> +		else
>>>> +			vmcs_write64(VIRTUAL_APIC_PAGE_ADDR,
>>>> +				page_to_phys(vmx->nested.virtual_apic_page));
>>>> +
>>>> +		vmcs_write32(TPR_THRESHOLD, vmcs12->tpr_threshold);
>>>> +	}
>>>> +
>>>>  	/*
>>>>  	 * Merging of IO and MSR bitmaps not currently supported.
>>>>  	 * Rather, exit every time.
>>>> @@ -8793,6 +8818,10 @@ static void nested_vmx_vmexit(struct kvm_vcpu *vcpu, u32 exit_reason,
>>>>  		nested_release_page(vmx->nested.apic_access_page);
>>>>  		vmx->nested.apic_access_page = 0;
>>>>  	}
>>>> +	if (vmx->nested.virtual_apic_page) {
>>>> +		nested_release_page(vmx->nested.virtual_apic_page);
>>>> +		vmx->nested.virtual_apic_page = 0;
>>>> +	}
>>>>  
>>>>  	/*
>>>>  	 * Exiting from L2 to L1, we're now back to L1 which thinks it just
>>>>
