Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755470AbaGCG7E (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jul 2014 02:59:04 -0400
Received: from mga09.intel.com ([134.134.136.24]:61896 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754252AbaGCG7C (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jul 2014 02:59:02 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.01,593,1400050800"; 
   d="scan'208";a="567684141"
Date: Thu, 3 Jul 2014 14:59:55 +0800
From: Wanpeng Li <wanpeng.li@linux.intel.com>
To: Bandan Das <bsd@redhat.com>
Cc: Jan Kiszka <jan.kiszka@siemens.com>, Paolo Bonzini <pbonzini@redhat.com>,
        Gleb Natapov <gleb@kernel.org>, Hu Robert <robert.hu@intel.com>,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] KVM: nVMX: Fix IRQs inject to L2 which belong to L1
 since race
Message-ID: <20140703065955.GA4236@kernel>
Reply-To: Wanpeng Li <wanpeng.li@linux.intel.com>
References: <1404284054-51863-1-git-send-email-wanpeng.li@linux.intel.com>
 <53B3CA6A.4050902@siemens.com>
 <jpgy4wb9g5t.fsf@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <jpgy4wb9g5t.fsf@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 03, 2014 at 01:15:26AM -0400, Bandan Das wrote:
>Jan Kiszka <jan.kiszka@siemens.com> writes:
>
>> On 2014-07-02 08:54, Wanpeng Li wrote:
>>> This patch fix bug https://bugzilla.kernel.org/show_bug.cgi?id=72381 
>>> 
>>> If we didn't inject a still-pending event to L1 since nested_run_pending,
>>> KVM_REQ_EVENT should be requested after the vmexit in order to inject the 
>>> event to L1. However, current log blindly request a KVM_REQ_EVENT even if 
>>> there is no still-pending event to L1 which blocked by nested_run_pending. 
>>> There is a race which lead to an interrupt will be injected to L2 which 
>>> belong to L1 if L0 send an interrupt to L1 during this window. 
>>> 
>>>                VCPU0                               another thread 
>>> 
>>> L1 intr not blocked on L2 first entry
>>> vmx_vcpu_run req event 
>>> kvm check request req event 
>>> check_nested_events don't have any intr 
>>> not nested exit 
>>>                                             intr occur (8254, lapic timer etc)
>>> inject_pending_event now have intr 
>>> inject interrupt 
>>> 
>>> This patch fix this race by introduced a l1_events_blocked field in nested_vmx 
>>> which indicates there is still-pending event which blocked by nested_run_pending, 
>>> and smart request a KVM_REQ_EVENT if there is a still-pending event which blocked 
>>> by nested_run_pending.
>>
>> There are more, unrelated reasons why KVM_REQ_EVENT could be set. Why
>> aren't those able to trigger this scenario?
>>
>> In any case, unconditionally setting KVM_REQ_EVENT seems strange and
>> should be changed.
>
>
>Ugh! I think I am hitting another one but this one's probably because 
>we are not setting KVM_REQ_EVENT for something we should.
>
>Before this patch, I was able to hit this bug everytime with 
>"modprobe kvm_intel ept=0 nested=1 enable_shadow_vmcs=0" and then booting 
>L2. I can verify that I was indeed hitting the race in inject_pending_event.
>
>After this patch, I believe I am hitting another bug - this happens 
>after I boot L2, as above, and then start a Linux kernel compilation
>and then wait and watch :) It's a pain to debug because this happens

I have already try several times with "modprobe kvm_intel ept=0 nested=1
enable_shadow_vmcs=0" and still can't reproduce the bug you mentioned.
Could you give me more details such like L1 and L2 which one hang or panic? 
In addition, if you can post the call trace is appreciated. 

Regards,
Wanpeng Li 

>almost once in three times; it never happens if I run with ept=1, however,
>I think that's only because the test completes sooner. But I can confirm
>that I don't see it if I always set REQ_EVENT if nested_run_pending is set instead of
>the approach this patch takes.
>(Any debug hints help appreciated!)
>
>So, I am not sure if this is the right fix. Rather, I think the safer thing
>to do is to have the interrupt pending check for injection into L1 at
>the "same site" as the call to kvm_queue_interrupt() just like we had before 
>commit b6b8a1451fc40412c57d1. Is there any advantage to having all the 
>nested events checks together ?
>
>PS - Actually, a much easier fix (or rather hack) is to return 1 in 
>vmx_interrupt_allowed() (as I mentioned elsewhere) only if 
>!is_guest_mode(vcpu) That way, the pending interrupt interrupt 
>can be taken care of correctly during the next vmexit.
>
>Bandan
>
>> Jan
>>
[...]
