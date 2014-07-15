Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758940AbaGOMKq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jul 2014 08:10:46 -0400
Received: from cn.fujitsu.com ([59.151.112.132]:34901 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1758321AbaGOMKo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jul 2014 08:10:44 -0400
X-IronPort-AV: E=Sophos;i="5.00,896,1396972800"; 
   d="scan'208";a="33292353"
Message-ID: <53C51A7E.4010508@cn.fujitsu.com>
Date: Tue, 15 Jul 2014 20:11:42 +0800
From: Tang Chen <tangchen@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:12.0) Gecko/20120430 Thunderbird/12.0.1
MIME-Version: 1.0
To: Jan Kiszka <jan.kiszka@web.de>
CC: Gleb Natapov <gleb@kernel.org>, <mtosatti@redhat.com>,
        <nadav.amit@gmail.com>, <kvm@vger.kernel.org>, <laijs@cn.fujitsu.com>,
        <isimatu.yasuaki@jp.fujitsu.com>, <guz.fnst@cn.fujitsu.com>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2 5/5] kvm, mem-hotplug: Do not pin apic access page
 in memory.
References: <1404824492-30095-1-git-send-email-tangchen@cn.fujitsu.com> <1404824492-30095-6-git-send-email-tangchen@cn.fujitsu.com> <20140712080442.GH4399@minantech.com> <53C38D55.2040307@cn.fujitsu.com> <20140714145822.GK4399@minantech.com> <53C51608.4080109@web.de>
In-Reply-To: <53C51608.4080109@web.de>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.167.226.99]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/15/2014 07:52 PM, Jan Kiszka wrote:
> On 2014-07-14 16:58, Gleb Natapov wrote:
......
>>>>> +	struct page *page = gfn_to_page_no_pin(vcpu->kvm,
>>>>> +					APIC_DEFAULT_PHYS_BASE>>   PAGE_SHIFT);
>>>> If you do not use kvm->arch.apic_access_page to get current address why not drop it entirely?
>>>>
>>>
>>> I should also update kvm->arch.apic_access_page here. It is used in other
>>> places
>>> in kvm, so I don't think we should drop it. Will update the patch.
>> What other places? The only other place I see is in nested kvm code and you can call
>> gfn_to_page_no_pin() there instead of using kvm->arch.apic_access_page directly. But
>> as far as I see nested kvm code cannot handle change of APIC_ACCESS_ADDR phys address.
>> If APIC_ACCESS_ADDR changes during nested guest run, non nested vmcs will still have old
>> physical address. One way to fix that is to set KVM_REQ_APIC_PAGE_RELOAD during nested exit.
>

Hi Jan,

Thanks for the reply. Please see below.

> I cannot follow your concerns yet. Specifically, how should
> APIC_ACCESS_ADDR (the VMCS field, right?) change while L2 is running? We
> currently pin/unpin on L1->L2/L2->L1, respectively. Or what do you mean?
>

Currently, we pin the nested apic page in memory. And as a result, the page
cannot be migrated/hot-removed, Just like the apic page for L1 vm.

What we want to do here is DO NOT ping the page in memory. When it is 
migrated,
we track the hpa of the page and update the VMCS field at proper time.

Please refer to patch 5/5, I have done this for the L1 vm. The solution is:
1. When apic page is migrated, invalidate ept entry of the apic page in 
mmu_notifier
    registered by kvm, which is kvm_mmu_notifier_invalidate_page() here.
2. Introduce a new vcpu request named KVM_REQ_APIC_PAGE_RELOAD, and 
enforce all the
    vcpu to exit from guest mode, make this request to all the vcpus.
3. In the request handler, use GUP function to find back the new apic 
page, and
    update the VMCS field.

I think Gleb is trying to say that we have to face the same problem in 
nested vm.

Thanks.
