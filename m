Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756660AbaGDGQK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Jul 2014 02:16:10 -0400
Received: from mga14.intel.com ([192.55.52.115]:9120 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752917AbaGDGQI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Jul 2014 02:16:08 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.01,599,1400050800"; 
   d="scan'208";a="557337738"
Date: Fri, 4 Jul 2014 14:17:01 +0800
From: Wanpeng Li <wanpeng.li@linux.intel.com>
To: Bandan Das <bsd@redhat.com>
Cc: Jan Kiszka <jan.kiszka@siemens.com>,
        Wanpeng Li <wanpeng.li@linux.intel.com>,
        Paolo Bonzini <pbonzini@redhat.com>, Gleb Natapov <gleb@kernel.org>,
        Hu Robert <robert.hu@intel.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] KVM: nVMX: Fix IRQs inject to L2 which belong to L1
 since race
Message-ID: <20140704061701.GB3453@kernel>
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

How about revert commit b6b8a1451 and try if the bug which you mentioned
is still there?

Regards,
Wanpeng Li 

>PS - Actually, a much easier fix (or rather hack) is to return 1 in 
>vmx_interrupt_allowed() (as I mentioned elsewhere) only if 
>!is_guest_mode(vcpu) That way, the pending interrupt interrupt 
>can be taken care of correctly during the next vmexit.
>
>Bandan
>
>> Jan
>>
>>> 
>>> Signed-off-by: Wanpeng Li <wanpeng.li@linux.intel.com>
>>> ---
>>>  arch/x86/kvm/vmx.c | 20 +++++++++++++++-----
>>>  1 file changed, 15 insertions(+), 5 deletions(-)
>>> 
>>> diff --git a/arch/x86/kvm/vmx.c b/arch/x86/kvm/vmx.c
>>> index f4e5aed..fe69c49 100644
>>> --- a/arch/x86/kvm/vmx.c
>>> +++ b/arch/x86/kvm/vmx.c
>>> @@ -372,6 +372,7 @@ struct nested_vmx {
>>>  	u64 vmcs01_tsc_offset;
>>>  	/* L2 must run next, and mustn't decide to exit to L1. */
>>>  	bool nested_run_pending;
>>> +	bool l1_events_blocked;
>>>  	/*
>>>  	 * Guest pages referred to in vmcs02 with host-physical pointers, so
>>>  	 * we must keep them pinned while L2 runs.
>>> @@ -7380,8 +7381,10 @@ static void __noclone vmx_vcpu_run(struct kvm_vcpu *vcpu)
>>>  	 * we did not inject a still-pending event to L1 now because of
>>>  	 * nested_run_pending, we need to re-enable this bit.
>>>  	 */
>>> -	if (vmx->nested.nested_run_pending)
>>> +	if (to_vmx(vcpu)->nested.l1_events_blocked) {
>>> +		to_vmx(vcpu)->nested.l1_events_blocked = false;
>>>  		kvm_make_request(KVM_REQ_EVENT, vcpu);
>>> +	}
>>>  
>>>  	vmx->nested.nested_run_pending = 0;
>>>  
>>> @@ -8197,15 +8200,20 @@ static int vmx_check_nested_events(struct kvm_vcpu *vcpu, bool external_intr)
>>>  
>>>  	if (nested_cpu_has_preemption_timer(get_vmcs12(vcpu)) &&
>>>  	    vmx->nested.preemption_timer_expired) {
>>> -		if (vmx->nested.nested_run_pending)
>>> +		if (vmx->nested.nested_run_pending) {
>>> +			vmx->nested.l1_events_blocked = true;
>>>  			return -EBUSY;
>>> +		}
>>>  		nested_vmx_vmexit(vcpu, EXIT_REASON_PREEMPTION_TIMER, 0, 0);
>>>  		return 0;
>>>  	}
>>>  
>>>  	if (vcpu->arch.nmi_pending && nested_exit_on_nmi(vcpu)) {
>>> -		if (vmx->nested.nested_run_pending ||
>>> -		    vcpu->arch.interrupt.pending)
>>> +		if (vmx->nested.nested_run_pending) {
>>> +			vmx->nested.l1_events_blocked = true;
>>> +			return -EBUSY;
>>> +		}
>>> +		if (vcpu->arch.interrupt.pending)
>>>  			return -EBUSY;
>>>  		nested_vmx_vmexit(vcpu, EXIT_REASON_EXCEPTION_NMI,
>>>  				  NMI_VECTOR | INTR_TYPE_NMI_INTR |
>>> @@ -8221,8 +8229,10 @@ static int vmx_check_nested_events(struct kvm_vcpu *vcpu, bool external_intr)
>>>  
>>>  	if ((kvm_cpu_has_interrupt(vcpu) || external_intr) &&
>>>  	    nested_exit_on_intr(vcpu)) {
>>> -		if (vmx->nested.nested_run_pending)
>>> +		if (vmx->nested.nested_run_pending) {
>>> +			vmx->nested.l1_events_blocked = true;
>>>  			return -EBUSY;
>>> +		}
>>>  		nested_vmx_vmexit(vcpu, EXIT_REASON_EXTERNAL_INTERRUPT, 0, 0);
>>>  	}
>>>  
>>> 
