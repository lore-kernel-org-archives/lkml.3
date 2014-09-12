Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754092AbaILDbb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Sep 2014 23:31:31 -0400
Received: from cn.fujitsu.com ([59.151.112.132]:33322 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751530AbaILDb3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Sep 2014 23:31:29 -0400
X-IronPort-AV: E=Sophos;i="5.04,509,1406563200"; 
   d="scan'208";a="35851003"
Message-ID: <5412695F.6080407@cn.fujitsu.com>
Date: Fri, 12 Sep 2014 11:32:47 +0800
From: tangchen <tangchen@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.1.0
MIME-Version: 1.0
To: Gleb Natapov <gleb@kernel.org>, Paolo Bonzini <pbonzini@redhat.com>
CC: <mtosatti@redhat.com>, <nadav.amit@gmail.com>, <jan.kiszka@web.de>,
        <kvm@vger.kernel.org>, <laijs@cn.fujitsu.com>,
        <isimatu.yasuaki@jp.fujitsu.com>, <guz.fnst@cn.fujitsu.com>,
        <linux-kernel@vger.kernel.org>, <tangchen@cn.fujitsu.com>
Subject: Re: [PATCH v5 4/7] kvm, mem-hotplug: Reload L1' apic access page
 on migration in vcpu_enter_guest().
References: <20140911101200.GF25317@minantech.com> <54117DB4.307@redhat.com> <20140911113051.GG25317@minantech.com> <54119E01.9000908@redhat.com> <20140911135956.GC26540@minantech.com> <5411AC82.4080005@redhat.com> <20140911142121.GD26540@minantech.com> <5411B084.7030800@redhat.com> <20140911143123.GE26540@minantech.com> <5411B3B3.900@redhat.com> <20140911144716.GF26540@minantech.com>
In-Reply-To: <20140911144716.GF26540@minantech.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Gleb, Paolo,

On 09/11/2014 10:47 PM, Gleb Natapov wrote:
> On Thu, Sep 11, 2014 at 04:37:39PM +0200, Paolo Bonzini wrote:
>> Il 11/09/2014 16:31, Gleb Natapov ha scritto:
>>>>> What if the page being swapped out is L1's APIC access page?  We don't
>>>>> run prepare_vmcs12 in that case because it's an L2->L0->L2 entry, so we
>>>>> need to "do something".
>>> We will do something on L2->L1 exit. We will call kvm_reload_apic_access_page().
>>> That is what patch 5 of this series is doing.
>> Sorry, I meant "the APIC access page prepared by L1" for L2's execution.
>>
>> You wrote:
>>
>>> if (!is_guest_mode() || !(vmcs12->secondary_vm_exec_control & ECONDARY_EXEC_VIRTUALIZE_APIC_ACCESSES))
>>>      write(PIC_ACCESS_ADDR)
>>>
>>> In other words if L2 shares L1 apic access page then reload, otherwise do nothing.
>> but in that case you have to redo nested_get_page, so "do nothing"
>> doesn't work.
>>
> Ah, 7/7 is new in this submission. Before that this page was still
> pinned.  Looking at 7/7 now I do not see how it can work since it has no
> code for mmu notifier to detect that it deals with such page and call
> kvm_reload_apic_access_page().

Since L1 and L2 share one apic page, if the page is unmapped, 
mmu_notifier will
be called, and :

  - if vcpu is in L1, a L1->L0 exit is rised. apic page's pa will be 
updated in the next
    L0->L1 entry by making vcpu request.

  - if vcpu is in L2 (is_guest_mode, right?), a L2->L0 exit is rised. 
nested_vmx_vmexit()
    will not be called since it is called in L2->L1 exit. It returns 
from vmx_vcpu_run()
    directly, right ? So we should update apic page in L0->L2 entry. 
This is also done
    by making vcpu request, right ?.

    prepare_vmcs02() is called in L1->L2 entry, and nested_vmx_vmexit() 
is called in
    L2->L1 exit. So we also need to update L1's vmcs in 
nested_vmx_vmexit() in patch 5/7.

IIUC, I think patch 1~6 has done such things.

And yes, the is_guest_mode() check is not needed.

> I said to Tang previously that nested
> kvm has a bunch of pinned page that are hard to deal with and suggested
> to iron out non nested case first :(

Yes, and maybe adding patch 7 is not a good idea for now.

Thanks.
