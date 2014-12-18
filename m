Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752161AbaLRIkM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Dec 2014 03:40:12 -0500
Received: from plane.gmane.org ([80.91.229.3]:46451 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751844AbaLRIkJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Dec 2014 03:40:09 -0500
X-Injected-Via-Gmane: http://gmane.org/
To: linux-kernel@vger.kernel.org
From: Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: [v3 24/26] KVM: Update Posted-Interrupts Descriptor when vCPU
 is blocked
Date: Thu, 18 Dec 2014 09:37:20 +0100
Message-ID: <54929240.6050306@redhat.com>
References: <1418397300-10870-1-git-send-email-feng.wu@intel.com>	<1418397300-10870-25-git-send-email-feng.wu@intel.com>	<5491B8DD.5020000@redhat.com> <E959C4978C3B6342920538CF579893F002307C7B@SHSMSX104.ccr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
X-Complaints-To: usenet@ger.gmane.org
Cc: iommu@lists.linux-foundation.org, kvm@vger.kernel.org
X-Gmane-NNTP-Posting-Host: net-2-35-193-40.cust.vodafonedsl.it
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.3.0
In-Reply-To: <E959C4978C3B6342920538CF579893F002307C7B@SHSMSX104.ccr.corp.intel.com>
Cc: linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On 18/12/2014 04:16, Wu, Feng wrote:
>>> pre-block:
>>> - Add the vCPU to the blocked per-CPU list
>>> - Clear 'SN'
>>
>> Should SN be already clear (and NV set to POSTED_INTR_VECTOR)? 
> 
> I think the SN bit should be clear here, Adding it here is just to make sure
> SN is clear when vCPU is blocked, so it can receive wakeup notification event later.

Then, please, WARN if the SN bit is set inside the if (vcpu->blocked).
Inside that if you can just add the vCPU to the blocked list on vcpu_put.

>> Can it
>> happen that you go from sched-out to blocked without doing a sched-in first?
>>
> 
> I cannot imagine this scenario, can you please be more specific? Thanks a lot!

I cannot either. :)  But it would be the case where SN is not cleared.
So we agree that it cannot happen.

>> In fact, if this is possible, what happens if vcpu->preempted &&
>> vcpu->blocked?
> 
> In fact, vcpu->preempted && vcpu->blocked happens sometimes, but I think there is
> no issues. Please refer to the following case:

I agree that there should be no issues.  But if it can happen, it's better:

1) to separate the handling of preemption and blocking: preemption
handles SN/NV/NDST, blocking handles the wakeup list.

2) to change this

+		} else if (vcpu->blocked) {
+			/*
+			 * The vcpu is blocked on the wait queue.
+			 * Store the blocked vCPU on the list of the
+			 * vcpu->wakeup_cpu, which is the destination
+			 * of the wake-up notification event.

to just

		}
		if (vcpu->blocked) {
			...
		}
> kvm_vcpu_block() 
> 	-> vcpu->blocked = true;
> 	-> prepare_to_wait(&vcpu->wq, &wait, TASK_INTERRUPTIBLE);
> 
> 	before schedule() is called, this vcpu is woken up by another guy, so
> 	the state of the vcpu associated thread is changed to TASK_RUNNING,
> 	then preemption happens after interrupts or the following schedule() is
> 	hit, this will call kvm_sched_out(), in which current->state == TASK_RUNNING
> 	and vcpu->preempted is set to true. So now vcpu->preempted and vcpu->blocked
> 	are both true. In vmx_vcpu_put(), we will check vcpu->preempted first, so
> 	the vCPU will not be blocked, and the vcpu->blocked will be set the false in
> 	vmx_vcpu_load().
> 
> 	But maybe I need do a little change to the vmx_vcpu_load() like below:
> 
>                 /*
>                  * Delete the vCPU from the related wakeup queue
>                  * if we are resuming from blocked state
>                  */
>                 if (vcpu->blocked) {
>                         vcpu->blocked = false;
> +						/* if wakeup_cpu == -1, the vcpu is currently not blocked on any
> +						  pCPU, don't need dequeue here */
> +						if (vcpu->wakeup_cpu != -1) {
>                		         spin_lock_irqsave(&per_cpu(blocked_vcpu_on_cpu_lock,
>                                 vcpu->wakeup_cpu), flags);
>                     	     list_del(&vcpu->blocked_vcpu_list);
>                         	 spin_unlock_irqrestore(&per_cpu(blocked_vcpu_on_cpu_lock,
>                                 vcpu->wakeup_cpu), flags);
>                         	 vcpu->wakeup_cpu = -1;
> +						}
>                 }

Good idea.

Paolo

> Any ideas about this? Thanks a lot!
> 
> Thanks,
> Feng
> 
> 
> 	-> schedule();
> 
> 
>>
>>> - Set 'NV' to POSTED_INTR_WAKEUP_VECTOR
>>>
>>> post-block:
>>> - Remove the vCPU from the per-CPU list
>>
>> Paolo
>>
>>> Signed-off-by: Feng Wu <feng.wu@intel.com>
>> --
>> To unsubscribe from this list: send the line "unsubscribe kvm" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html

