Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753443AbaGDHWJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Jul 2014 03:22:09 -0400
Received: from thoth.sbs.de ([192.35.17.2]:59989 "EHLO thoth.sbs.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751167AbaGDHWH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Jul 2014 03:22:07 -0400
Message-ID: <53B6560F.40309@siemens.com>
Date: Fri, 04 Jul 2014 09:21:51 +0200
From: Jan Kiszka <jan.kiszka@siemens.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); de; rv:1.8.1.12) Gecko/20080226 SUSE/2.0.0.12-1.1 Thunderbird/2.0.0.12 Mnenhy/0.7.5.666
MIME-Version: 1.0
To: Wanpeng Li <wanpeng.li@linux.intel.com>, Bandan Das <bsd@redhat.com>
CC: Paolo Bonzini <pbonzini@redhat.com>, Gleb Natapov <gleb@kernel.org>,
        Hu Robert <robert.hu@intel.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] KVM: nVMX: Fix IRQs inject to L2 which belong to L1 since
 race
References: <1404284054-51863-1-git-send-email-wanpeng.li@linux.intel.com> <53B3CA6A.4050902@siemens.com> <jpgy4wb9g5t.fsf@redhat.com> <20140704061701.GB3453@kernel>
In-Reply-To: <20140704061701.GB3453@kernel>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2014-07-04 08:17, Wanpeng Li wrote:
> On Thu, Jul 03, 2014 at 01:15:26AM -0400, Bandan Das wrote:
>> Jan Kiszka <jan.kiszka@siemens.com> writes:
>>
>>> On 2014-07-02 08:54, Wanpeng Li wrote:
>>>> This patch fix bug https://bugzilla.kernel.org/show_bug.cgi?id=72381 
>>>>
>>>> If we didn't inject a still-pending event to L1 since nested_run_pending,
>>>> KVM_REQ_EVENT should be requested after the vmexit in order to inject the 
>>>> event to L1. However, current log blindly request a KVM_REQ_EVENT even if 
>>>> there is no still-pending event to L1 which blocked by nested_run_pending. 
>>>> There is a race which lead to an interrupt will be injected to L2 which 
>>>> belong to L1 if L0 send an interrupt to L1 during this window. 
>>>>
>>>>                VCPU0                               another thread 
>>>>
>>>> L1 intr not blocked on L2 first entry
>>>> vmx_vcpu_run req event 
>>>> kvm check request req event 
>>>> check_nested_events don't have any intr 
>>>> not nested exit 
>>>>                                             intr occur (8254, lapic timer etc)
>>>> inject_pending_event now have intr 
>>>> inject interrupt 
>>>>
>>>> This patch fix this race by introduced a l1_events_blocked field in nested_vmx 
>>>> which indicates there is still-pending event which blocked by nested_run_pending, 
>>>> and smart request a KVM_REQ_EVENT if there is a still-pending event which blocked 
>>>> by nested_run_pending.
>>>
>>> There are more, unrelated reasons why KVM_REQ_EVENT could be set. Why
>>> aren't those able to trigger this scenario?
>>>
>>> In any case, unconditionally setting KVM_REQ_EVENT seems strange and
>>> should be changed.
>>
>>
>> Ugh! I think I am hitting another one but this one's probably because 
>> we are not setting KVM_REQ_EVENT for something we should.
>>
>> Before this patch, I was able to hit this bug everytime with 
>> "modprobe kvm_intel ept=0 nested=1 enable_shadow_vmcs=0" and then booting 
>> L2. I can verify that I was indeed hitting the race in inject_pending_event.
>>
>> After this patch, I believe I am hitting another bug - this happens 
>> after I boot L2, as above, and then start a Linux kernel compilation
>> and then wait and watch :) It's a pain to debug because this happens
>> almost once in three times; it never happens if I run with ept=1, however,
>> I think that's only because the test completes sooner. But I can confirm
>> that I don't see it if I always set REQ_EVENT if nested_run_pending is set instead of
>> the approach this patch takes.
>> (Any debug hints help appreciated!)
>>
>> So, I am not sure if this is the right fix. Rather, I think the safer thing
>> to do is to have the interrupt pending check for injection into L1 at
>> the "same site" as the call to kvm_queue_interrupt() just like we had before 
>> commit b6b8a1451fc40412c57d1. Is there any advantage to having all the 
>> nested events checks together ?
>>
> 
> How about revert commit b6b8a1451 and try if the bug which you mentioned
> is still there?

I suspect you will have to reset back to b6b8a1451^ for this as other
changes depend on this commit now.

Jan

-- 
Siemens AG, Corporate Technology, CT RTC ITP SES-DE
Corporate Competence Center Embedded Linux
