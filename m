Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752402AbaGGIpK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jul 2014 04:45:10 -0400
Received: from mga11.intel.com ([192.55.52.93]:58399 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751857AbaGGIpH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jul 2014 04:45:07 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,862,1389772800"; 
   d="scan'208";a="359837861"
Date: Mon, 7 Jul 2014 16:46:05 +0800
From: Wanpeng Li <wanpeng.li@linux.intel.com>
To: Bandan Das <bsd@redhat.com>, Paolo Bonzini <pbonzini@redhat.com>
Cc: Jan Kiszka <jan.kiszka@siemens.com>, Gleb Natapov <gleb@kernel.org>,
        Hu Robert <robert.hu@intel.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] KVM: nVMX: Fix IRQs inject to L2 which belong to L1
 since race
Message-ID: <20140707084605.GA2904@kernel>
Reply-To: Wanpeng Li <wanpeng.li@linux.intel.com>
References: <1404284054-51863-1-git-send-email-wanpeng.li@linux.intel.com>
 <53B3CA6A.4050902@siemens.com>
 <jpgy4wb9g5t.fsf@redhat.com>
 <20140704061701.GB3453@kernel>
 <jpg1ttyhtqw.fsf@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <jpg1ttyhtqw.fsf@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jul 06, 2014 at 08:56:07PM -0400, Bandan Das wrote:
[...]
>>
>> How about revert commit b6b8a1451 and try if the bug which you mentioned
>> is still there?
>
>Sorry, didn't get time at all to look at this over the weekend but thought of 
>putting down what I have so far..
>
>So, as mentioned in http://www.spinics.net/linux/lists/kvm/msg105316.html,
>I have two tests - one is just booting up L2 with enable_shadow_vmcs=0 and 
>ept=0 and the other is compiling the Linux kernel in L2.
>
>Starting *without* your patch, let's apply this change -
>diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
>index f32a025..c28730d 100644
>--- a/arch/x86/kvm/x86.c
>+++ b/arch/x86/kvm/x86.c
>@@ -5887,6 +5887,7 @@ static int inject_pending_event(struct kvm_vcpu *vcpu, bool req_int_win)
> 			kvm_x86_ops->set_nmi(vcpu);
> 		}
> 	} else if (kvm_cpu_has_injectable_intr(vcpu)) {
>+		WARN_ON(is_guest_mode(vcpu));
> 		if (kvm_x86_ops->interrupt_allowed(vcpu)) {
> 			kvm_queue_interrupt(vcpu, kvm_cpu_get_interrupt(vcpu),
> 					    false);
>
>This will trigger a warning if we encounter a race (IIUC). Now, when booting L2,
>sure enough, I encounter the following in L0. Also, L2 hangs, so the next test
>(compiling the kernel) is not applicable anymore.
>[139132.361063] Call Trace:
>[139132.361070]  [<ffffffff816c0d31>] dump_stack+0x45/0x56
>[139132.361075]  [<ffffffff81084a7d>] warn_slowpath_common+0x7d/0xa0
>[139132.361077]  [<ffffffff81084b5a>] warn_slowpath_null+0x1a/0x20
>[139132.361093]  [<ffffffffa0437697>] kvm_arch_vcpu_ioctl_run+0xf77/0x1130 [kvm]
>[139132.361100]  [<ffffffffa04331ee>] ? kvm_arch_vcpu_load+0x4e/0x1e0 [kvm]
>[139132.361106]  [<ffffffffa0421bf2>] kvm_vcpu_ioctl+0x2b2/0x590 [kvm]
>[139132.361109]  [<ffffffff811eca08>] do_vfs_ioctl+0x2d8/0x4b0
>[139132.361111]  [<ffffffff811ecc61>] SyS_ioctl+0x81/0xa0
>[139132.361115]  [<ffffffff81114fd6>] ? __audit_syscall_exit+0x1f6/0x2a0
>[139132.361118]  [<ffffffff816c7ee9>] system_call_fastpath+0x16/0x1b
>
>The next step is to apply this change -
>diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
>index f32a025..432aa25 100644
>--- a/arch/x86/kvm/x86.c
>+++ b/arch/x86/kvm/x86.c
>@@ -5887,6 +5887,12 @@ static int inject_pending_event(struct kvm_vcpu *vcpu, bool req_int_win)
> 			kvm_x86_ops->set_nmi(vcpu);
> 		}
> 	} else if (kvm_cpu_has_injectable_intr(vcpu)) {
>+		if (is_guest_mode(vcpu) && kvm_x86_ops->check_nested_events) {
>+			r = kvm_x86_ops->check_nested_events(vcpu, req_int_win);
>+			if (r != 0)
>+				return r;
>+		}
>+		WARN_ON(is_guest_mode(vcpu));
> 		if (kvm_x86_ops->interrupt_allowed(vcpu)) {
> 			kvm_queue_interrupt(vcpu, kvm_cpu_get_interrupt(vcpu),
> 					    false);
>
>This will presumably avoid the race (assuming only interrupts) in all 
>cases.
>
>And, sure enough, booting up L2 comes up fine. The next test compiling the 
>kernel goes fine too.
>
>Finally, let's apply your patch on top of these changes. With your change, L2
>boots up fine, and when compiling the kernel in L2, I finally encounter a 
>hang after some time. (In my last test it took around 22 minutes and I was 
>compiling a kernel with everything enabled). The WARN() that we added doesn't
>get hit, so it doesn't seem like the same race.

Agreed.

>
>The only thing I can think of at this point is that since this patch 
>sets REQ_EVENT only for certain conditions, it's exposing a bug for a certain 
>event which apparently, setting REQ_EVENT for all cases hides. Note that 
>I do think this patch is doing the right thing, but it's just exposing another 
>bug somewhere else :)

Agreed. 

Hi Paolo, 

Is it ok for you to apply this patch and then more effort should be taken
to figure out the other bug which don't have any relationship with the race 
that this patch fixed?

Regards,
Wanpeng Li 


>
>Bandan
