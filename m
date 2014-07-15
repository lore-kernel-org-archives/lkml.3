Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758692AbaGOKib (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jul 2014 06:38:31 -0400
Received: from cn.fujitsu.com ([59.151.112.132]:30314 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1758183AbaGOKi0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jul 2014 06:38:26 -0400
X-IronPort-AV: E=Sophos;i="5.00,895,1396972800"; 
   d="scan'208";a="33289539"
Message-ID: <53C504DD.3040504@cn.fujitsu.com>
Date: Tue, 15 Jul 2014 18:39:25 +0800
From: Tang Chen <tangchen@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:12.0) Gecko/20120430 Thunderbird/12.0.1
MIME-Version: 1.0
To: Gleb Natapov <gleb@kernel.org>
CC: <mtosatti@redhat.com>, <nadav.amit@gmail.com>, <kvm@vger.kernel.org>,
        <laijs@cn.fujitsu.com>, <isimatu.yasuaki@jp.fujitsu.com>,
        <guz.fnst@cn.fujitsu.com>, <linux-kernel@vger.kernel.org>
Subject: Re: [RESEND PATCH v2 4/5] kvm: Remove ept_identity_pagetable from
 struct kvm_arch.
References: <1404824492-30095-5-git-send-email-tangchen@cn.fujitsu.com> <1404871683-27293-1-git-send-email-tangchen@cn.fujitsu.com> <20140712074425.GG4399@minantech.com> <53C3A010.6000405@cn.fujitsu.com> <20140714142730.GJ4399@minantech.com>
In-Reply-To: <20140714142730.GJ4399@minantech.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.167.226.99]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/14/2014 10:27 PM, Gleb Natapov wrote:
......
>>>>   	if (likely(kvm->arch.ept_identity_pagetable_done))
>>>>   		return 1;
>>>> -	ret = 0;
>>>>   	identity_map_pfn = kvm->arch.ept_identity_map_addr>>   PAGE_SHIFT;
>>>> +
>>>> +	mutex_lock(&kvm->slots_lock);
>>> Why move this out of alloc_identity_pagetable()?
>>>
>>
>> Referring to the original code, I think mutex_lock(&kvm->slots_lock) is used
>> to protect kvm->arch.ept_identity_pagetable. If two or more threads try to
>> modify it at the same time, the mutex ensures that the identity table is
>> only
>> allocated once.
>>
>> Now, we dropped kvm->arch.ept_identity_pagetable. And use
>> kvm->arch.ept_identity_pagetable_done
>> to check if the identity table is allocated and initialized. So we should
>> protect
>> memory slot operation in alloc_identity_pagetable() and
>> kvm->arch.ept_identity_pagetable_done
>> with this mutex.
>>
>> Of course, I can see that the name "slots_lock" indicates that it may be
>> used
>> to protect the memory slot operation only. Maybe move it out here is not
>> suitable.
>>
>> If I'm wrong, please tell me.
>>
> No, you are right that besides memory slot creation slots_lock protects checking
> of ept_identity_pagetable here, but after you patch ept_identity_pagetable_done is
> tested outside of slots_lock so the allocation can happen twice, no?

Oh, yes. Will fix it in the next version.

Thanks.
