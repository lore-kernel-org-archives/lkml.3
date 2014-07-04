Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760007AbaGDGlK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Jul 2014 02:41:10 -0400
Received: from cn.fujitsu.com ([59.151.112.132]:53558 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752175AbaGDGlG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Jul 2014 02:41:06 -0400
X-IronPort-AV: E=Sophos;i="5.00,830,1396972800"; 
   d="scan'208";a="32833660"
Message-ID: <53B64CB5.4080203@cn.fujitsu.com>
Date: Fri, 4 Jul 2014 14:41:57 +0800
From: Tang Chen <tangchen@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:12.0) Gecko/20120430 Thunderbird/12.0.1
MIME-Version: 1.0
To: Gleb Natapov <gleb@kernel.org>
CC: <mtosatti@redhat.com>, <kvm@vger.kernel.org>, <laijs@cn.fujitsu.com>,
        <isimatu.yasuaki@jp.fujitsu.com>, <guz.fnst@cn.fujitsu.com>,
        <linux-kernel@vger.kernel.org>, Tang Chen <tangchen@cn.fujitsu.com>
Subject: Re: [PATCH 0/4] kvm, mem-hotplug: Do not pin ept identity pagetable
 and apic access page.
References: <1404291637-15048-1-git-send-email-tangchen@cn.fujitsu.com> <53B4AF47.1080008@cn.fujitsu.com> <20140703060409.GL18167@minantech.com>
In-Reply-To: <20140703060409.GL18167@minantech.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.167.226.99]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Gleb,

On 07/03/2014 02:04 PM, Gleb Natapov wrote:
> On Thu, Jul 03, 2014 at 09:17:59AM +0800, Tang Chen wrote:
>> Hi Gleb,
>>
>> On 07/02/2014 05:00 PM, Tang Chen wrote:
>>> Hi Gleb, Marcelo,
>>>
>>> Please help to review this patch-set.
>>>
>>> NOTE: This patch-set doesn't work properly.
>>>
>>>
>>> ept identity pagetable and apic access page in kvm are pinned in memory.
>>> As a result, they cannot be migrated/hot-removed.
>>>
>>> But actually they don't need to be pinned in memory.
>>>
>>> This patch-set introduces two new vcpu requests: KVM_REQ_MIGRATE_EPT and KVM_REQ_MIGRATE_APIC.
>>> These two requests are made when the two pages are migrated by the mmu_notifier
>>> to reset the related variable to unusable value. And will also be made when
>>> ept violation happens to reset new pages.
>>>
>>>
>>> [Known problem]
>>> After this patch-set applied, the two pages can be migrated/hot-removed.
>>> But after migrating apic access page, the guest died.
>>>
>>> The host physical address of apic access page is stored in VMCS. I reset
>>> it to 0 to stop guest from accessing it when it is unmapped by
>>> kvm_mmu_notifier_invalidate_page(). And reset it to new page's host physical
>>> address in tdp_page_fault(). But it seems that guest will access apic page
>>> directly by the host physical address.
>>
>> Would you please to give some advice about this problem ?
>>
> I haven't reviewed third patch yet, will do ASAP.
>

I printed some info in the kernel, and I found that mmu_notifier 
unmapped the
apic page and set VMCS APIC_ACCESS_ADDR to 0. But apic page ept 
violation didn't
happen. And the guest stopped running.

I think when guest tried to access apic page, there was no ept violation 
happened.
And as a result, VMCS APIC_ACCESS_ADDR was not correctly set.

Referring to Intel Software Developer's Manuel Vol 3B, when accessing 
apic page
using translation with a large page (2M, 4M, 1G), APIC VM_exit will not 
happen.

How do you think about this ?

Thanks. :)




