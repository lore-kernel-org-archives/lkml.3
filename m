Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753995AbaHUIHH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Aug 2014 04:07:07 -0400
Received: from mga14.intel.com ([192.55.52.115]:45599 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753625AbaHUIG7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Aug 2014 04:06:59 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.01,907,1400050800"; 
   d="scan'208";a="579757414"
Date: Thu, 21 Aug 2014 16:08:33 +0800
From: Wanpeng Li <wanpeng.li@linux.intel.com>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: Marcelo Tosatti <mtosatti@redhat.com>, Gleb Natapov <gleb@kernel.org>,
        Zhang Yang <yang.z.zhang@intel.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v5 2/2] KVM: nVMX: introduce
 apic_access_and_virtual_page_valid
Message-ID: <20140821080833.GB30303@kernel>
Reply-To: Wanpeng Li <wanpeng.li@linux.intel.com>
References: <1408527905-11705-1-git-send-email-wanpeng.li@linux.intel.com>
 <1408527905-11705-2-git-send-email-wanpeng.li@linux.intel.com>
 <53F47D7E.1080306@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <53F47D7E.1080306@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Paolo,
On Wed, Aug 20, 2014 at 12:50:38PM +0200, Paolo Bonzini wrote:
>Il 20/08/2014 11:45, Wanpeng Li ha scritto:
>> Introduce apic_access_and_virtual_page_valid() to check the valid 
>> of nested apic access page and virtual apic page earlier.
>> 
>> Signed-off-by: Wanpeng Li <wanpeng.li@linux.intel.com>
>> ---
>>  arch/x86/kvm/vmx.c | 82 ++++++++++++++++++++++++++++++------------------------
>>  1 file changed, 46 insertions(+), 36 deletions(-)
>> 
>> diff --git a/arch/x86/kvm/vmx.c b/arch/x86/kvm/vmx.c
>> index caf239d..02bc07d 100644
>> --- a/arch/x86/kvm/vmx.c
>> +++ b/arch/x86/kvm/vmx.c
>> @@ -7838,6 +7838,50 @@ static void vmx_inject_page_fault_nested(struct kvm_vcpu *vcpu,
>>  		kvm_inject_page_fault(vcpu, fault);
>>  }
>>  
>> +static bool apic_access_and_virtual_page_valid(struct kvm_vcpu *vcpu,
>> +						struct vmcs12 *vmcs12)
>> +{
>> +	struct vcpu_vmx *vmx = to_vmx(vcpu);
>> +
>> +	if (nested_cpu_has2(vmcs12, SECONDARY_EXEC_VIRTUALIZE_APIC_ACCESSES)) {
>> +		if (!PAGE_ALIGNED(vmcs12->apic_access_addr))
>> +			/*TODO: Also verify bits beyond physical address width are 0*/
>> +			return false;
>> +
>> +		/*
>> +		 * Translate L1 physical address to host physical
>> +		 * address for vmcs02. Keep the page pinned, so this
>> +		 * physical address remains valid. We keep a reference
>> +		 * to it so we can release it later.
>> +		 */
>> +		if (vmx->nested.apic_access_page) /* shouldn't happen */
>> +			nested_release_page(vmx->nested.apic_access_page);
>> +		vmx->nested.apic_access_page =
>> +			nested_get_page(vcpu, vmcs12->apic_access_addr);
>> +	}
>> +
>> +	if (nested_cpu_has(vmcs12, CPU_BASED_TPR_SHADOW)) {
>> +		if (vmx->nested.virtual_apic_page) /* shouldn't happen */
>> +			nested_release_page(vmx->nested.virtual_apic_page);
>> +		vmx->nested.virtual_apic_page =
>> +			nested_get_page(vcpu, vmcs12->virtual_apic_page_addr);
>> +
>> +		/*
>> +		 * Failing the vm entry is _not_ what the processor does
>> +		 * but it's basically the only possibility we have.
>> +		 * We could still enter the guest if CR8 load exits are
>> +		 * enabled, CR8 store exits are enabled, and virtualize APIC
>> +		 * access is disabled; in this case the processor would never
>> +		 * use the TPR shadow and we could simply clear the bit from
>> +		 * the execution control.  But such a configuration is useless,
>> +		 * so let's keep the code simple.
>> +		 */
>> +		if (!vmx->nested.virtual_apic_page)
>> +			return false;
>> +	}
>> +	return true;
>> +}
>> +
>>  static void vmx_start_preemption_timer(struct kvm_vcpu *vcpu)
>>  {
>>  	u64 preemption_timeout = get_vmcs12(vcpu)->vmx_preemption_timer_value;
>> @@ -7984,16 +8028,6 @@ static void prepare_vmcs02(struct kvm_vcpu *vcpu, struct vmcs12 *vmcs12)
>>  
>>  		if (exec_control & SECONDARY_EXEC_VIRTUALIZE_APIC_ACCESSES) {
>>  			/*
>> -			 * Translate L1 physical address to host physical
>> -			 * address for vmcs02. Keep the page pinned, so this
>> -			 * physical address remains valid. We keep a reference
>> -			 * to it so we can release it later.
>> -			 */
>> -			if (vmx->nested.apic_access_page) /* shouldn't happen */
>> -				nested_release_page(vmx->nested.apic_access_page);
>> -			vmx->nested.apic_access_page =
>> -				nested_get_page(vcpu, vmcs12->apic_access_addr);
>> -			/*
>>  			 * If translation failed, no matter: This feature asks
>>  			 * to exit when accessing the given address, and if it
>>  			 * can never be accessed, this feature won't do
>> @@ -8040,30 +8074,8 @@ static void prepare_vmcs02(struct kvm_vcpu *vcpu, struct vmcs12 *vmcs12)
>>  	exec_control |= vmcs12->cpu_based_vm_exec_control;
>>  
>>  	if (exec_control & CPU_BASED_TPR_SHADOW) {
>> -		if (vmx->nested.virtual_apic_page)
>> -			nested_release_page(vmx->nested.virtual_apic_page);
>> -		vmx->nested.virtual_apic_page =
>> -		   nested_get_page(vcpu, vmcs12->virtual_apic_page_addr);
>> -		if (!vmx->nested.virtual_apic_page)
>> -			exec_control &=
>> -				~CPU_BASED_TPR_SHADOW;
>> -		else
>> -			vmcs_write64(VIRTUAL_APIC_PAGE_ADDR,
>> +		vmcs_write64(VIRTUAL_APIC_PAGE_ADDR,
>>  				page_to_phys(vmx->nested.virtual_apic_page));
>> -
>> -		/*
>> -		 * Failing the vm entry is _not_ what the processor does
>> -		 * but it's basically the only possibility we have.
>> -		 * We could still enter the guest if CR8 load exits are
>> -		 * enabled, CR8 store exits are enabled, and virtualize APIC
>> -		 * access is disabled; in this case the processor would never
>> -		 * use the TPR shadow and we could simply clear the bit from
>> -		 * the execution control.  But such a configuration is useless,
>> -		 * so let's keep the code simple.
>> -		 */
>> -		if (!vmx->nested.virtual_apic_page)
>> -			nested_vmx_failValid(vcpu, VMXERR_ENTRY_INVALID_CONTROL_FIELD);
>> -
>>  		vmcs_write32(TPR_THRESHOLD, vmcs12->tpr_threshold);
>>  	} else if (vm_need_tpr_shadow(vmx->vcpu.kvm))
>>  		vmcs_write64(VIRTUAL_APIC_PAGE_ADDR,
>> @@ -8230,9 +8242,7 @@ static int nested_vmx_run(struct kvm_vcpu *vcpu, bool launch)
>>  		return 1;
>>  	}
>>  
>> -	if (nested_cpu_has2(vmcs12, SECONDARY_EXEC_VIRTUALIZE_APIC_ACCESSES) &&
>> -			!PAGE_ALIGNED(vmcs12->apic_access_addr)) {
>> -		/*TODO: Also verify bits beyond physical address width are 0*/
>> +	if (!apic_access_and_virtual_page_valid(vcpu, vmcs12)) {
>>  		nested_vmx_failValid(vcpu, VMXERR_ENTRY_INVALID_CONTROL_FIELD);
>>  		return 1;
>>  	}
>> 
>
>Thanks Wanpeng.  The code now looks good.  Just one thing: please swap
>them, so that the series remains bisectable.
>

Do you mean the first patch introduce nested_get_vmcs12_pages() and the
second patch implement nested TPR shadow/threshold emulation?

>Also, I think nested_get_vmcs12_pages would be a better name for the
>function.  apic_access_and_virtual_page_valid doesn't hint at the side
>effects of the function (for example calling nested_get_page).
>

Will do.

Regards,
Wanpeng Li 

>The way I swap patches is by using "git checkout -p" like this:
>
> git branch  tpr-shadow-old
> git reset --hard HEAD^^
> git checkout -p tpr-shadow-old
>     ... pick hunks related to the second patch ...
> git commit -c tpr-shadow-old
>     ... edit commit message if needed ...
> git checkout -p tpr-shadow-old
>     ... pick hunks related to the first patch ...
> git commit -C tpr-shadow-old^
>     ... edit commit message if needed ...
> git diff tpr-shadow-old HEAD
>
>Paolo
