Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754192AbaIQIMO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Sep 2014 04:12:14 -0400
Received: from cn.fujitsu.com ([59.151.112.132]:8624 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751895AbaIQIMM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Sep 2014 04:12:12 -0400
X-IronPort-AV: E=Sophos;i="5.04,539,1406563200"; 
   d="scan'208";a="36069859"
Message-ID: <541942B5.6000907@cn.fujitsu.com>
Date: Wed, 17 Sep 2014 16:13:41 +0800
From: Tang Chen <tangchen@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.1.0
MIME-Version: 1.0
To: Paolo Bonzini <pbonzini@redhat.com>, <gleb@kernel.org>,
        <mtosatti@redhat.com>, <nadav.amit@gmail.com>, <jan.kiszka@web.de>
CC: <kvm@vger.kernel.org>, <laijs@cn.fujitsu.com>,
        <isimatu.yasuaki@jp.fujitsu.com>, <guz.fnst@cn.fujitsu.com>,
        <linux-kernel@vger.kernel.org>, <tangchen@cn.fujitsu.com>
Subject: Re: [PATCH v6 4/6] kvm, mem-hotplug: Reload L1' apic access page
 on migration in vcpu_enter_guest().
References: <1410864122-12434-1-git-send-email-tangchen@cn.fujitsu.com> <1410864122-12434-5-git-send-email-tangchen@cn.fujitsu.com> <54181DE1.3040502@redhat.com>
In-Reply-To: <54181DE1.3040502@redhat.com>
Content-Type: text/plain; charset="ISO-8859-15"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On 09/16/2014 07:24 PM, Paolo Bonzini wrote:
> Il 16/09/2014 12:42, Tang Chen ha scritto:
>> diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
>> index 33712fb..0df82c1 100644
>> --- a/virt/kvm/kvm_main.c
>> +++ b/virt/kvm/kvm_main.c
>> @@ -210,6 +210,11 @@ void kvm_make_scan_ioapic_request(struct kvm *kvm)
>>   	make_all_cpus_request(kvm, KVM_REQ_SCAN_IOAPIC);
>>   }
>>   
>> +void kvm_reload_apic_access_page(struct kvm *kvm)
>> +{
>> +	make_all_cpus_request(kvm, KVM_REQ_APIC_PAGE_RELOAD);
>> +}
>> +
>>   int kvm_vcpu_init(struct kvm_vcpu *vcpu, struct kvm *kvm, unsigned id)
>>   {
>>   	struct page *page;
>> @@ -294,6 +299,13 @@ static void kvm_mmu_notifier_invalidate_page(struct mmu_notifier *mn,
>>   	if (need_tlb_flush)
>>   		kvm_flush_remote_tlbs(kvm);
>>   
>> +	/*
>> +	 * The physical address of apic access page is stored in VMCS.
>> +	 * Update it when it becomes invalid.
>> +	 */
>> +	if (address == gfn_to_hva(kvm, APIC_DEFAULT_PHYS_BASE >> PAGE_SHIFT))
>> +		kvm_reload_apic_access_page(kvm);
> This cannot be in the generic code.  It is architecture-specific.

Yes.

> Please add a new function kvm_arch_mmu_notifier_invalidate_page, and
> call it outside the mmu_lock.

Then I think we need a macro to control the calling of this arch function
since other architectures do not have it.

>
> kvm_reload_apic_access_page need not be in virt/kvm/kvm_main.c, either.

Since kvm_reload_apic_access_page() only calls make_all_cpus_request(),
and make_all_cpus_request() is static, I'd like to make it non-static, 
rename
it to kvm_make_all_cpus_request() and call it directly in 
kvm_arch_mmu_notifier_invalidate_page().
we don't need kvm_reload_apic_access_page() actually.

Thanks.

