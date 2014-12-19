Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751844AbaLSCxh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Dec 2014 21:53:37 -0500
Received: from mga01.intel.com ([192.55.52.88]:22008 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751158AbaLSCxg convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Dec 2014 21:53:36 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.07,604,1413270000"; 
   d="scan'208";a="640078944"
From: "Wu, Feng" <feng.wu@intel.com>
To: Paolo Bonzini <pbonzini@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
CC: "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "Wu, Feng" <feng.wu@intel.com>
Subject: RE: [v3 24/26] KVM: Update Posted-Interrupts Descriptor when vCPU
 is blocked
Thread-Topic: [v3 24/26] KVM: Update Posted-Interrupts Descriptor when vCPU
 is blocked
Thread-Index: AQHQGp5lqXFocrs29UygMrg1gFuo+5yWNqoQ
Date: Fri, 19 Dec 2014 02:51:46 +0000
Message-ID: <E959C4978C3B6342920538CF579893F00230ABD1@SHSMSX104.ccr.corp.intel.com>
References: <1418397300-10870-1-git-send-email-feng.wu@intel.com>
	<1418397300-10870-25-git-send-email-feng.wu@intel.com>
	<5491B8DD.5020000@redhat.com>
 <E959C4978C3B6342920538CF579893F002307C7B@SHSMSX104.ccr.corp.intel.com>
 <54929240.6050306@redhat.com>
In-Reply-To: <54929240.6050306@redhat.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.239.127.40]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



> -----Original Message-----
> From: linux-kernel-owner@vger.kernel.org
> [mailto:linux-kernel-owner@vger.kernel.org] On Behalf Of Paolo Bonzini
> Sent: Thursday, December 18, 2014 4:37 PM
> To: linux-kernel@vger.kernel.org
> Cc: iommu@lists.linux-foundation.org; kvm@vger.kernel.org;
> linux-kernel@vger.kernel.org; kvm@vger.kernel.org
> Subject: Re: [v3 24/26] KVM: Update Posted-Interrupts Descriptor when vCPU
> is blocked
> 
> 
> 
> On 18/12/2014 04:16, Wu, Feng wrote:
> >>> pre-block:
> >>> - Add the vCPU to the blocked per-CPU list
> >>> - Clear 'SN'
> >>
> >> Should SN be already clear (and NV set to POSTED_INTR_VECTOR)?
> >
> > I think the SN bit should be clear here, Adding it here is just to make sure
> > SN is clear when vCPU is blocked, so it can receive wakeup notification event
> later.
> 
> Then, please, WARN if the SN bit is set inside the if (vcpu->blocked).
> Inside that if you can just add the vCPU to the blocked list on vcpu_put.
> 
> >> Can it
> >> happen that you go from sched-out to blocked without doing a sched-in
> first?
> >>
> >
> > I cannot imagine this scenario, can you please be more specific? Thanks a lot!
> 
> I cannot either. :)  But it would be the case where SN is not cleared.
> So we agree that it cannot happen.
> 
> >> In fact, if this is possible, what happens if vcpu->preempted &&
> >> vcpu->blocked?
> >
> > In fact, vcpu->preempted && vcpu->blocked happens sometimes, but I think
> there is
> > no issues. Please refer to the following case:
> 
> I agree that there should be no issues.  But if it can happen, it's better:
> 
> 1) to separate the handling of preemption and blocking: preemption
> handles SN/NV/NDST, blocking handles the wakeup list.
> 
Sorry, I don't quite understand this.

I think handling of preemption and blocking is separated in vmx_vcpu_put().
For vmx_vcpu_load(), the handling of SN/NV/NDST is common for preemption
and blocking.

Thanks,
Feng

> 2) to change this
> 
> +		} else if (vcpu->blocked) {
> +			/*
> +			 * The vcpu is blocked on the wait queue.
> +			 * Store the blocked vCPU on the list of the
> +			 * vcpu->wakeup_cpu, which is the destination
> +			 * of the wake-up notification event.
> 
> to just
> 
> 		}
> 		if (vcpu->blocked) {
> 			...
> 		}
> > kvm_vcpu_block()
> > 	-> vcpu->blocked = true;
> > 	-> prepare_to_wait(&vcpu->wq, &wait, TASK_INTERRUPTIBLE);
> >
> > 	before schedule() is called, this vcpu is woken up by another guy, so
> > 	the state of the vcpu associated thread is changed to TASK_RUNNING,
> > 	then preemption happens after interrupts or the following schedule() is
> > 	hit, this will call kvm_sched_out(), in which current->state ==
> TASK_RUNNING
> > 	and vcpu->preempted is set to true. So now vcpu->preempted and
> vcpu->blocked
> > 	are both true. In vmx_vcpu_put(), we will check vcpu->preempted first, so
> > 	the vCPU will not be blocked, and the vcpu->blocked will be set the false in
> > 	vmx_vcpu_load().
> >
> > 	But maybe I need do a little change to the vmx_vcpu_load() like below:
> >
> >                 /*
> >                  * Delete the vCPU from the related wakeup queue
> >                  * if we are resuming from blocked state
> >                  */
> >                 if (vcpu->blocked) {
> >                         vcpu->blocked = false;
> > +						/* if wakeup_cpu == -1, the vcpu is currently not
> blocked on any
> > +						  pCPU, don't need dequeue here */
> > +						if (vcpu->wakeup_cpu != -1) {
> >
> spin_lock_irqsave(&per_cpu(blocked_vcpu_on_cpu_lock,
> >                                 vcpu->wakeup_cpu), flags);
> >                     	     list_del(&vcpu->blocked_vcpu_list);
> >
> spin_unlock_irqrestore(&per_cpu(blocked_vcpu_on_cpu_lock,
> >                                 vcpu->wakeup_cpu), flags);
> >                         	 vcpu->wakeup_cpu = -1;
> > +						}
> >                 }
> 
> Good idea.
> 
> Paolo
> 
> > Any ideas about this? Thanks a lot!
> >
> > Thanks,
> > Feng
> >
> >
> > 	-> schedule();
> >
> >
> >>
> >>> - Set 'NV' to POSTED_INTR_WAKEUP_VECTOR
> >>>
> >>> post-block:
> >>> - Remove the vCPU from the per-CPU list
> >>
> >> Paolo
> >>
> >>> Signed-off-by: Feng Wu <feng.wu@intel.com>
> >> --
> >> To unsubscribe from this list: send the line "unsubscribe kvm" in
> >> the body of a message to majordomo@vger.kernel.org
> >> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
