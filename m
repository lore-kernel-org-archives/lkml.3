Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754798AbaHFGjY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Aug 2014 02:39:24 -0400
Received: from mga03.intel.com ([143.182.124.21]:7622 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751981AbaHFGjW convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Aug 2014 02:39:22 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.01,810,1400050800"; 
   d="scan'208";a="465482932"
From: "Zhang, Yang Z" <yang.z.zhang@intel.com>
To: Paolo Bonzini <pbonzini@redhat.com>,
        Wanpeng Li <wanpeng.li@linux.intel.com>,
        Jan Kiszka <jan.kiszka@siemens.com>
CC: Marcelo Tosatti <mtosatti@redhat.com>, Gleb Natapov <gleb@kernel.org>,
        Bandan Das <bsd@redhat.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH v3] KVM: nVMX: nested TPR shadow/threshold emulation
Thread-Topic: [PATCH v3] KVM: nVMX: nested TPR shadow/threshold emulation
Thread-Index: AQHPr9MOWFa0yRHIzU+2SsbexogLsJvBkH2w///Cj4CAAc1D8A==
Date: Wed, 6 Aug 2014 06:38:06 +0000
Message-ID: <A9667DDFB95DB7438FA9D7D576C3D87E0AB516FF@SHSMSX104.ccr.corp.intel.com>
References: <1407149907-13483-1-git-send-email-wanpeng.li@linux.intel.com>
 <A9667DDFB95DB7438FA9D7D576C3D87E0AB505AB@SHSMSX104.ccr.corp.intel.com>
 <53E0B931.7010309@redhat.com>
In-Reply-To: <53E0B931.7010309@redhat.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.239.127.40]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Paolo Bonzini wrote on 2014-08-05:
> Il 05/08/2014 09:56, Zhang, Yang Z ha scritto:
>> Wanpeng Li wrote on 2014-08-04:
>>> This patch fix bug
>>> https://bugzilla.kernel.org/show_bug.cgi?id=61411
>>> 
>>> TPR shadow/threshold feature is important to speed up the Windows guest.
>>> Besides, it is a must feature for certain VMM.
>>> 
>>> We map virtual APIC page address and TPR threshold from L1 VMCS. If
>>> TPR_BELOW_THRESHOLD VM exit is triggered by L2 guest and L1
>>> interested in, we inject it into L1 VMM for handling.
>>> 
>>> Signed-off-by: Wanpeng Li <wanpeng.li@linux.intel.com>
>>> ---
>>> v2 -> v3:
>>>  * nested vm entry failure if both tpr shadow and cr8 exiting bits
>>> are not set
>>> v1 -> v2:
>>>  * don't take L0's "virtualize APIC accesses" setting into account *
>>>  virtual_apic_page do exactly the same thing that is done for
>>>  apic_access_page * add the tpr threshold field to the read-write
>>>  fields for shadow
>>> VMCS
>>> 
>>>  arch/x86/kvm/vmx.c | 38 ++++++++++++++++++++++++++++++++++++--
>>>  1 file changed, 36 insertions(+), 2 deletions(-)
>>> diff --git a/arch/x86/kvm/vmx.c b/arch/x86/kvm/vmx.c index
>>> c604f3c..7a56e2c 100644
>>> --- a/arch/x86/kvm/vmx.c
>>> +++ b/arch/x86/kvm/vmx.c
>>> @@ -379,6 +379,7 @@ struct nested_vmx {
>>>  	 * we must keep them pinned while L2 runs. 	 */ 	struct page
>>>  *apic_access_page; +	struct page *virtual_apic_page; 	u64
>>>  msr_ia32_feature_control;
>>>  
>>>  	struct hrtimer preemption_timer; @@ -533,6 +534,7 @@ static int
>>>  max_shadow_read_only_fields = 	ARRAY_SIZE(shadow_read_only_fields);
>>>  
>>>  static unsigned long shadow_read_write_fields[] = { +	TPR_THRESHOLD,
>>>  	GUEST_RIP, 	GUEST_RSP, 	GUEST_CR0,
>>> @@ -2330,7 +2332,7 @@ static __init void
>>> nested_vmx_setup_ctls_msrs(void)
>>>  		CPU_BASED_MOV_DR_EXITING | CPU_BASED_UNCOND_IO_EXITING |
>>>  		CPU_BASED_USE_IO_BITMAPS | CPU_BASED_MONITOR_EXITING |
>>>  		CPU_BASED_RDPMC_EXITING | CPU_BASED_RDTSC_EXITING |
>>> -		CPU_BASED_PAUSE_EXITING |
>>> +		CPU_BASED_PAUSE_EXITING | CPU_BASED_TPR_SHADOW |
>>>  		CPU_BASED_ACTIVATE_SECONDARY_CONTROLS; 	/* 	 * We can allow some
>>>  features even when not supported by the @@ -6148,6 +6150,10 @@ static
>>>  void free_nested(struct vcpu_vmx *vmx)
>>>  		nested_release_page(vmx->nested.apic_access_page);
>>>  		vmx->nested.apic_access_page = 0; 	}
>>> +	if (vmx->nested.virtual_apic_page) {
>>> +		nested_release_page(vmx->nested.virtual_apic_page);
>>> +		vmx->nested.virtual_apic_page = 0;
>>> +	}
>>> 
>>>  	nested_free_all_saved_vmcss(vmx);  } @@ -6936,7 +6942,7 @@ static
>>>  bool nested_vmx_exit_handled(struct kvm_vcpu *vcpu) 	case
>>>  EXIT_REASON_MCE_DURING_VMENTRY: 		return 0; 	case
>>>  EXIT_REASON_TPR_BELOW_THRESHOLD:
>>> -		return 1;
>>> +		return nested_cpu_has(vmcs12, CPU_BASED_TPR_SHADOW);
>>>  	case EXIT_REASON_APIC_ACCESS:
>>>  		return nested_cpu_has2(vmcs12,
>>>  			SECONDARY_EXEC_VIRTUALIZE_APIC_ACCESSES);
>>> @@ -7057,6 +7063,9 @@ static int vmx_handle_exit(struct kvm_vcpu
>>> *vcpu)
>>> 
>>>  static void update_cr8_intercept(struct kvm_vcpu *vcpu, int tpr,
>>> int
>>> irr)  {
>>> +	if (is_guest_mode(vcpu))
>>> +		return;
>>> +
>>>  	if (irr == -1 || tpr < irr) {
>>>  		vmcs_write32(TPR_THRESHOLD, 0);
>>>  		return;
>>> @@ -8024,6 +8033,27 @@ static void prepare_vmcs02(struct kvm_vcpu
>>> *vcpu, struct vmcs12 *vmcs12)
>>>  	exec_control &= ~CPU_BASED_VIRTUAL_NMI_PENDING;
>>>  	exec_control &= ~CPU_BASED_TPR_SHADOW;
>>>  	exec_control |= vmcs12->cpu_based_vm_exec_control;
>>> +
>>> +	if (exec_control & CPU_BASED_TPR_SHADOW) {
>>> +		if (vmx->nested.virtual_apic_page)
>>> +			nested_release_page(vmx->nested.virtual_apic_page);
>>> +		vmx->nested.virtual_apic_page =
>>> +		   nested_get_page(vcpu, vmcs12->virtual_apic_page_addr);
>>> +		if (!vmx->nested.virtual_apic_page)
>>> +			exec_control &=
>>> +				~CPU_BASED_TPR_SHADOW;
>>> +		else
>>> +			vmcs_write64(VIRTUAL_APIC_PAGE_ADDR,
>>> +				page_to_phys(vmx->nested.virtual_apic_page));
>>> +
>>> +		if (!(exec_control & CPU_BASED_TPR_SHADOW) &&
>>> +			!((exec_control & CPU_BASED_CR8_LOAD_EXITING) &&
>>> +				(exec_control & CPU_BASED_CR8_STORE_EXITING)))
>>> +			nested_vmx_failValid(vcpu,
>>> VMXERR_ENTRY_INVALID_CONTROL_FIELD);
>> 
>> I think this is not correct. The vmx->nested.virtual_apic_page may not
>> valid due to two reasons: 1. The virtual_apic_page_addr is not a valid
>> gfn. In this case, the vmx failure
> must be injected to L1 unconditionally regardless of the setting of
> CR8 load/store exiting.
> 
> You're right that accesses to the APIC-access page may also end up
> writing to the virtual-APIC page.  Hence, if the "virtualize APIC
> accesses" setting is 1 in the secondary exec controls, you also have to fail the vmentry.
> 
> Doing it unconditionally is not correct, but it is the simplest thing

Why not correct?

> to do and it would be okay with a comment, I think.
> 
>> 2. The virtual_apic_page is swapped by L0. In this case, we should
>> not inject
> failure to L1.
> 
> This cannot happen, nested_get_page ends up calling hva_to_pfn with
> atomic==false, so the page would be swapped in and pinned.
> 
>>> +
>>> +		vmcs_write32(TPR_THRESHOLD, vmcs12->tpr_threshold);
>>> +	}
>> 
>> Miss else here:
>> If L2 owns the APIC and doesn't use TPR_SHADOW, we need to setup the
>> vmcs02 based on vmcs01. For example, if vmcs01 is using TPR_SHADOW,
>> then
>> vmcs02 must set it. Also, we need to use vmcs01's virtual_apic_page
>> and TPR_THRESHOLD for vmcs02.
> 
> What do you mean by "owns the APIC"?

Means if L2 touch L1's APIC directly, for example, if L2 not using TPR_SHADOW, then move to/from CR8 will touch L1's TPR directly. And in this case, L0 should aware of L1's TRP change.

> 
> Paolo


Best regards,
Yang


