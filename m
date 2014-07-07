Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752043AbaGGJvb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jul 2014 05:51:31 -0400
Received: from cn.fujitsu.com ([59.151.112.132]:53712 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751409AbaGGJv3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jul 2014 05:51:29 -0400
X-IronPort-AV: E=Sophos;i="5.00,848,1396972800"; 
   d="scan'208";a="32931093"
Message-ID: <53BA6DD3.9040400@cn.fujitsu.com>
Date: Mon, 7 Jul 2014 17:52:19 +0800
From: Tang Chen <tangchen@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:12.0) Gecko/20120430 Thunderbird/12.0.1
MIME-Version: 1.0
To: Gleb Natapov <gleb@kernel.org>
CC: <mtosatti@redhat.com>, <kvm@vger.kernel.org>, <laijs@cn.fujitsu.com>,
        <isimatu.yasuaki@jp.fujitsu.com>, <guz.fnst@cn.fujitsu.com>,
        <linux-kernel@vger.kernel.org>, Tang Chen <tangchen@cn.fujitsu.com>
Subject: Re: [PATCH 4/4] kvm, mem-hotplug: Update apic access page when it
 is migrated.
References: <1404291637-15048-1-git-send-email-tangchen@cn.fujitsu.com> <1404291637-15048-5-git-send-email-tangchen@cn.fujitsu.com> <20140703135507.GM18167@minantech.com> <53B60EF1.6030307@cn.fujitsu.com> <20140704101310.GE4399@minantech.com>
In-Reply-To: <20140704101310.GE4399@minantech.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.167.226.99]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Gleb,

The guest hang problem has been solved.

When mmu_notifier is called, I set VMCS APIC_ACCESS_ADDR to the new value
instead of setting it to 0. And only update kvm->arch.apic_access_page in
the next ept violation.

The guest is running well now.

I'll post the new patches tomorrow. ;)

Thanks.


On 07/04/2014 06:13 PM, Gleb Natapov wrote:
> On Fri, Jul 04, 2014 at 10:18:25AM +0800, Tang Chen wrote:
>> Hi Gleb,
>>
>> Thanks for the advices. Please see below.
>>
>> On 07/03/2014 09:55 PM, Gleb Natapov wrote:
>> ......
>>>> @@ -575,6 +575,7 @@ struct kvm_arch {
>>>>
>>>>   	unsigned int tss_addr;
>>>>   	struct page *apic_access_page;
>>>> +	bool apic_access_page_migrated;
>>> Better have two requests KVM_REQ_APIC_PAGE_MAP, KVM_REQ_APIC_PAGE_UNMAP IMO.
>>>
>>
>> vcpu->requests is an unsigned long, and we can only has 64 requests. Isn't
>> adding two requests for apic page and another similar two for ept page too
>> many ?  Not sure.
>>
> Lets not worry about that for now. May be it is enough to have only one
> KVM_REQ_APIC_PAGE_RELOAD request set apic_access_page to a new value
> before sending the request and reload whatever is in apic_access_page
> during KVM_REQ_APIC_PAGE_RELOAD processing. Or we can even reload
> apic_access_page as part of mmu reload and reuse KVM_REQ_MMU_RELOAD.
>
>>>>
>>>>   	gpa_t wall_clock;
>>>>
>>>> @@ -739,6 +740,7 @@ struct kvm_x86_ops {
>>>>   	void (*hwapic_isr_update)(struct kvm *kvm, int isr);
>>>>   	void (*load_eoi_exitmap)(struct kvm_vcpu *vcpu, u64 *eoi_exit_bitmap);
>>>>   	void (*set_virtual_x2apic_mode)(struct kvm_vcpu *vcpu, bool set);
>>>> +	void (*set_apic_access_page_addr)(struct kvm *kvm, hpa_t hpa);
>>>>   	void (*deliver_posted_interrupt)(struct kvm_vcpu *vcpu, int vector);
>>>>   	void (*sync_pir_to_irr)(struct kvm_vcpu *vcpu);
>>>>   	int (*set_tss_addr)(struct kvm *kvm, unsigned int addr);
>>>> diff --git a/arch/x86/kvm/mmu.c b/arch/x86/kvm/mmu.c
>>>> index c0d72f6..a655444 100644
>>>> --- a/arch/x86/kvm/mmu.c
>>>> +++ b/arch/x86/kvm/mmu.c
>>>> @@ -3436,6 +3436,21 @@ static int tdp_page_fault(struct kvm_vcpu *vcpu, gva_t gpa, u32 error_code,
>>>>   		kvm_make_request(KVM_REQ_MIGRATE_EPT, vcpu);
>>>>   	}
>>>>
>>>> +	if (gpa == VMX_APIC_ACCESS_PAGE_ADDR&&
>>>> +	    vcpu->kvm->arch.apic_access_page_migrated) {
>>> Why check arch.apic_access_page_migrated here? Isn't it enough that the fault is on apic
>>> address.
>>>
>>
>> True. It's enough. Followed.
>>
>>>> +		int i;
>>>> +
>>>> +		vcpu->kvm->arch.apic_access_page_migrated = false;
>>>> +
>>>> +		/*
>>>> +		 * We need update APIC_ACCESS_ADDR pointer in each VMCS of
>>>> +		 * all the online vcpus.
>>>> +		 */
>>>> +		for (i = 0; i<   atomic_read(&vcpu->kvm->online_vcpus); i++)
>>>> +			kvm_make_request(KVM_REQ_MIGRATE_APIC,
>>>> +					 vcpu->kvm->vcpus[i]);
>>> make_all_cpus_request(). You need to kick all vcpus from a guest mode.
>>>
>>
>> OK, followed. But would you please explain more about this. :)
>> Why need to kick all vcpus from guest mode when making request to all vcpus
>> ?
> Because if you do not force other vcpus from a guest mode they will not reload
> apic_access_page value till next vmexit, but since EPT page table now has a mapping
> for 0xfee00000 access to this address will not cause EPT violation and will not cause
> apic exit either.
>
>>
>>>> +	}
>>>> +
>>>>   	spin_unlock(&vcpu->kvm->mmu_lock);
>>>>
>>>>   	return r;
>>>> diff --git a/arch/x86/kvm/vmx.c b/arch/x86/kvm/vmx.c
>>>> index c336cb3..abc152f 100644
>>>> --- a/arch/x86/kvm/vmx.c
>>>> +++ b/arch/x86/kvm/vmx.c
>>>> @@ -3988,7 +3988,7 @@ static int alloc_apic_access_page(struct kvm *kvm)
>>>>   	if (r)
>>>>   		goto out;
>>>>
>>>> -	page = gfn_to_page(kvm, VMX_APIC_ACCESS_PAGE_ADDR>>   PAGE_SHIFT);
>>>> +	page = gfn_to_page_no_pin(kvm, VMX_APIC_ACCESS_PAGE_ADDR>>   PAGE_SHIFT);
>>>>   	if (is_error_page(page)) {
>>>>   		r = -EFAULT;
>>>>   		goto out;
>>>> @@ -7075,6 +7075,12 @@ static void vmx_set_virtual_x2apic_mode(struct kvm_vcpu *vcpu, bool set)
>>>>   	vmx_set_msr_bitmap(vcpu);
>>>>   }
>>>>
>>>> +static void vmx_set_apic_access_page_addr(struct kvm *kvm, hpa_t hpa)
>>>> +{
>>>> +	if (vm_need_virtualize_apic_accesses(kvm))
>>> This shouldn't even been called if apic access page is not supported. Nor
>>> mmu_notifier path neither tdp_page_fault path should ever see 0xfee00000
>>> address. BUG() is more appropriate here.
>>>
>>
>> I don't quite understand. Why calling this function here will leed to bug ?
>> (Sorry, I'm not quite understand the internal of KVM. Please help.)
> I didn't say that calling this function here will lead to a bug. I am saying that
> if vm_need_virtualize_apic_accesses() is false this function should not be called
> at all, so this check is redundant.
>
>>
>>>
>>>> +		vmcs_write64(APIC_ACCESS_ADDR, hpa);
>>>> +}
>>>> +
>>>>   static void vmx_hwapic_isr_update(struct kvm *kvm, int isr)
>>>>   {
>>>>   	u16 status;
>>>> @@ -8846,6 +8852,7 @@ static struct kvm_x86_ops vmx_x86_ops = {
>>>>   	.enable_irq_window = enable_irq_window,
>>>>   	.update_cr8_intercept = update_cr8_intercept,
>>>>   	.set_virtual_x2apic_mode = vmx_set_virtual_x2apic_mode,
>>>> +	.set_apic_access_page_addr = vmx_set_apic_access_page_addr,
>>> svm needs that too.
>>>
>>
>> OK, will add one for svm.
>>
>>>>   	.vm_has_apicv = vmx_vm_has_apicv,
>>>>   	.load_eoi_exitmap = vmx_load_eoi_exitmap,
>>>>   	.hwapic_irr_update = vmx_hwapic_irr_update,
>>>> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
>>>> index a26524f..14e7174 100644
>>>> --- a/arch/x86/kvm/x86.c
>>>> +++ b/arch/x86/kvm/x86.c
>>>> @@ -5943,6 +5943,24 @@ static void vcpu_migrated_page_update_ept(struct kvm_vcpu *vcpu)
>>>>   	}
>>>>   }
>>>>
>>>> +static void vcpu_migrated_page_update_apic(struct kvm_vcpu *vcpu)
>>>> +{
>>>> +	struct kvm *kvm = vcpu->kvm;
>>>> +
>>>> +	if (kvm->arch.apic_access_page_migrated) {
>>>> +		if (kvm->arch.apic_access_page)
>>>> +			kvm->arch.apic_access_page = pfn_to_page(0);
>>> All vcpus will access apic_access_page without locking here. May be
>>> set kvm->arch.apic_access_page to zero in mmu_notifier and here call
>>>   kvm_x86_ops->set_apic_access_page_addr(kvm, kvm->arch.apic_access_page);
>>>
>>
>> I'm a little confused. apic access page's phys_addr is stored in vmcs, and
>> I think it will be used by vcpu directly to access the physical page.
>> Setting kvm->arch.apic_access_page to zero will not stop it, right ?
>>
> Right, kvm->arch.apic_access_page is just a shadow value for whatever is written
> in vmcs. After setting it all vcpus need to update their vmcs values.
>
>> I'm wondering what happens when apic page is migrated, but the vmcs is still
>> holding its old phys_addr before the vcpu request is handled.
>>
> apic page should not be migrated untill all vpus are forced out of a guest mode and
> instructed to reload new value on a next guest entry. That's what we are trying to
> achieve here.
>
> --
> 			Gleb.
> .
>
