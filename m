Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759363AbaGCR1P (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jul 2014 13:27:15 -0400
Received: from mx1.redhat.com ([209.132.183.28]:25953 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753041AbaGCR1O (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jul 2014 13:27:14 -0400
From: Bandan Das <bsd@redhat.com>
To: Wanpeng Li <wanpeng.li@linux.intel.com>
Cc: Jan Kiszka <jan.kiszka@siemens.com>, Paolo Bonzini <pbonzini@redhat.com>,
        Gleb Natapov <gleb@kernel.org>, Hu Robert <robert.hu@intel.com>,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] KVM: nVMX: Fix IRQs inject to L2 which belong to L1 since race
References: <1404284054-51863-1-git-send-email-wanpeng.li@linux.intel.com>
	<53B3CA6A.4050902@siemens.com> <jpgy4wb9g5t.fsf@redhat.com>
	<20140703065955.GA4236@kernel>
Date: Thu, 03 Jul 2014 13:27:05 -0400
In-Reply-To: <20140703065955.GA4236@kernel> (Wanpeng Li's message of "Thu, 3
	Jul 2014 14:59:55 +0800")
Message-ID: <jpgk37u8iae.fsf@redhat.com>
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
>
> I have already try several times with "modprobe kvm_intel ept=0 nested=1
> enable_shadow_vmcs=0" and still can't reproduce the bug you mentioned.
> Could you give me more details such like L1 and L2 which one hang or panic? 
> In addition, if you can post the call trace is appreciated. 

# modprobe kvm_intel ept=0 nested=1 enable_shadow_vmcs=0

The Host CPU - Intel(R) Core(TM) i7-4770 CPU @ 3.40GHz
qemu cmd to run L1 - 
# qemu-system-x86_64 -drive file=level1.img,if=virtio,id=disk0,format=raw,cache=none,werror=stop,rerror=stop,aio=threads -drive file=level2.img,if=virtio,id=disk1,format=raw,cache=none,werror=stop,rerror=stop,aio=threads -vnc :2 --enable-kvm -monitor stdio -m 4G -net nic,macaddr=00:23:32:45:89:10 -net tap,ifname=tap0,script=/etc/qemu-ifup,downscript=no -smp 4 -cpu Nehalem,+vmx -serial pty

qemu cmd to run L2 -
# sudo qemu-system-x86_64 -hda VM/level2.img -vnc :0 --enable-kvm -monitor stdio -m 2G -smp 2 -cpu Nehalem -redir tcp:5555::22

Additionally,
L0 is FC19 with 3.16-rc3
L1 and L2 are Ubuntu 14.04 with 3.13.0-24-generic

Then start a kernel compilation inside L2 with "make -j3"

There's no call trace on L0, both L0 and L1 are hung (or rather really slow) and
L1 serial spews out CPU softlock up errors. Enabling panic on softlockup on L1 will give
a trace with smp_call_function_many() I think the corresponding code in kernel/smp.c that
triggers this is
 
WARN_ON_ONCE(cpu_online(this_cpu) && irqs_disabled()
                      && !oops_in_progress && !early_boot_irqs_disabled);

I know in most cases this is usually harmless, but in this specific case,
it seems it's stuck here forever.

Sorry, I don't have a L1 call trace handy atm, I can post that if you are interested.

Note that this can take as much as 30 to 40 minutes to appear but once it does,
you will know because both L1 and L2 will be stuck with the serial messages as I mentioned
before. From my side, let me try this on another system to rule out any machine specific
weirdness going on..

Please let me know if you need any further information.

Thanks
Bandan

> Regards,
> Wanpeng Li 
>
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
>>PS - Actually, a much easier fix (or rather hack) is to return 1 in 
>>vmx_interrupt_allowed() (as I mentioned elsewhere) only if 
>>!is_guest_mode(vcpu) That way, the pending interrupt interrupt 
>>can be taken care of correctly during the next vmexit.
>>
>>Bandan
>>
>>> Jan
>>>
> [...]
