Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752811AbaGGA4Y (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Jul 2014 20:56:24 -0400
Received: from mx1.redhat.com ([209.132.183.28]:16754 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752187AbaGGA4W (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Jul 2014 20:56:22 -0400
From: Bandan Das <bsd@redhat.com>
To: Wanpeng Li <wanpeng.li@linux.intel.com>
Cc: Jan Kiszka <jan.kiszka@siemens.com>, Paolo Bonzini <pbonzini@redhat.com>,
        Gleb Natapov <gleb@kernel.org>, Hu Robert <robert.hu@intel.com>,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] KVM: nVMX: Fix IRQs inject to L2 which belong to L1 since race
References: <1404284054-51863-1-git-send-email-wanpeng.li@linux.intel.com>
	<53B3CA6A.4050902@siemens.com> <jpgy4wb9g5t.fsf@redhat.com>
	<20140704061701.GB3453@kernel>
Date: Sun, 06 Jul 2014 20:56:07 -0400
In-Reply-To: <20140704061701.GB3453@kernel> (Wanpeng Li's message of "Fri, 4
	Jul 2014 14:17:01 +0800")
Message-ID: <jpg1ttyhtqw.fsf@redhat.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Wanpeng Li <wanpeng.li@linux.intel.com> writes:

> On Thu, Jul 03, 2014 at 01:15:26AM -0400, Bandan Das wrote:
>>Jan Kiszka <jan.kiszka@siemens.com> writes:
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
>>Ugh! I think I am hitting another one but this one's probably because 
>>we are not setting KVM_REQ_EVENT for something we should.
>>
>>Before this patch, I was able to hit this bug everytime with 
>>"modprobe kvm_intel ept=0 nested=1 enable_shadow_vmcs=0" and then booting 
>>L2. I can verify that I was indeed hitting the race in inject_pending_event.
>>
>>After this patch, I believe I am hitting another bug - this happens 
>>after I boot L2, as above, and then start a Linux kernel compilation
>>and then wait and watch :) It's a pain to debug because this happens
>>almost once in three times; it never happens if I run with ept=1, however,
>>I think that's only because the test completes sooner. But I can confirm
>>that I don't see it if I always set REQ_EVENT if nested_run_pending is set instead of
>>the approach this patch takes.
>>(Any debug hints help appreciated!)
>>
>>So, I am not sure if this is the right fix. Rather, I think the safer thing
>>to do is to have the interrupt pending check for injection into L1 at
>>the "same site" as the call to kvm_queue_interrupt() just like we had before 
>>commit b6b8a1451fc40412c57d1. Is there any advantage to having all the 
>>nested events checks together ?
>>
>
> How about revert commit b6b8a1451 and try if the bug which you mentioned
> is still there?

Sorry, didn't get time at all to look at this over the weekend but thought of 
putting down what I have so far..

So, as mentioned in http://www.spinics.net/linux/lists/kvm/msg105316.html,
I have two tests - one is just booting up L2 with enable_shadow_vmcs=0 and 
ept=0 and the other is compiling the Linux kernel in L2.

Starting *without* your patch, let's apply this change -
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index f32a025..c28730d 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -5887,6 +5887,7 @@ static int inject_pending_event(struct kvm_vcpu *vcpu, bool req_int_win)
 			kvm_x86_ops->set_nmi(vcpu);
 		}
 	} else if (kvm_cpu_has_injectable_intr(vcpu)) {
+		WARN_ON(is_guest_mode(vcpu));
 		if (kvm_x86_ops->interrupt_allowed(vcpu)) {
 			kvm_queue_interrupt(vcpu, kvm_cpu_get_interrupt(vcpu),
 					    false);

This will trigger a warning if we encounter a race (IIUC). Now, when booting L2,
sure enough, I encounter the following in L0. Also, L2 hangs, so the next test
(compiling the kernel) is not applicable anymore.
[139132.361063] Call Trace:
[139132.361070]  [<ffffffff816c0d31>] dump_stack+0x45/0x56
[139132.361075]  [<ffffffff81084a7d>] warn_slowpath_common+0x7d/0xa0
[139132.361077]  [<ffffffff81084b5a>] warn_slowpath_null+0x1a/0x20
[139132.361093]  [<ffffffffa0437697>] kvm_arch_vcpu_ioctl_run+0xf77/0x1130 [kvm]
[139132.361100]  [<ffffffffa04331ee>] ? kvm_arch_vcpu_load+0x4e/0x1e0 [kvm]
[139132.361106]  [<ffffffffa0421bf2>] kvm_vcpu_ioctl+0x2b2/0x590 [kvm]
[139132.361109]  [<ffffffff811eca08>] do_vfs_ioctl+0x2d8/0x4b0
[139132.361111]  [<ffffffff811ecc61>] SyS_ioctl+0x81/0xa0
[139132.361115]  [<ffffffff81114fd6>] ? __audit_syscall_exit+0x1f6/0x2a0
[139132.361118]  [<ffffffff816c7ee9>] system_call_fastpath+0x16/0x1b

The next step is to apply this change -
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index f32a025..432aa25 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -5887,6 +5887,12 @@ static int inject_pending_event(struct kvm_vcpu *vcpu, bool req_int_win)
 			kvm_x86_ops->set_nmi(vcpu);
 		}
 	} else if (kvm_cpu_has_injectable_intr(vcpu)) {
+		if (is_guest_mode(vcpu) && kvm_x86_ops->check_nested_events) {
+			r = kvm_x86_ops->check_nested_events(vcpu, req_int_win);
+			if (r != 0)
+				return r;
+		}
+		WARN_ON(is_guest_mode(vcpu));
 		if (kvm_x86_ops->interrupt_allowed(vcpu)) {
 			kvm_queue_interrupt(vcpu, kvm_cpu_get_interrupt(vcpu),
 					    false);

This will presumably avoid the race (assuming only interrupts) in all 
cases.

And, sure enough, booting up L2 comes up fine. The next test compiling the 
kernel goes fine too.

Finally, let's apply your patch on top of these changes. With your change, L2
boots up fine, and when compiling the kernel in L2, I finally encounter a 
hang after some time. (In my last test it took around 22 minutes and I was 
compiling a kernel with everything enabled). The WARN() that we added doesn't
get hit, so it doesn't seem like the same race.

The only thing I can think of at this point is that since this patch 
sets REQ_EVENT only for certain conditions, it's exposing a bug for a certain 
event which apparently, setting REQ_EVENT for all cases hides. Note that 
I do think this patch is doing the right thing, but it's just exposing another 
bug somewhere else :)

Bandan
