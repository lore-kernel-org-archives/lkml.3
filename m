Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751331AbaGGGQs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jul 2014 02:16:48 -0400
Received: from cn.fujitsu.com ([59.151.112.132]:21289 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750799AbaGGGQn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jul 2014 02:16:43 -0400
X-IronPort-AV: E=Sophos;i="5.00,847,1396972800"; 
   d="scan'208";a="32920483"
Message-ID: <53BA3B75.3090801@cn.fujitsu.com>
Date: Mon, 7 Jul 2014 14:17:25 +0800
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

Thanks for all the advices. Please see below.

On 07/04/2014 06:13 PM, Gleb Natapov wrote:
......
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

Do you mean when vm_need_virtualize_apic_accesses() is false, it should 
not be called ?
It has to be true ?

......
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

So, setting VMCS APIC_ACCESS_ADDR pointer to zero will not stop vcpu to 
access
apic access page, right ?

If so, all the vcpus have to stop till apic page finishes its migration, 
and new
value is set in each vcpu, which means we should stop guest, right ?

Thanks.



