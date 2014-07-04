Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759966AbaGDCv4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jul 2014 22:51:56 -0400
Received: from mga09.intel.com ([134.134.136.24]:9025 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759791AbaGDCvy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jul 2014 22:51:54 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.01,598,1400050800"; 
   d="scan'208";a="568203978"
Date: Fri, 4 Jul 2014 10:52:50 +0800
From: Wanpeng Li <wanpeng.li@linux.intel.com>
To: Bandan Das <bsd@redhat.com>
Cc: Jan Kiszka <jan.kiszka@siemens.com>, Paolo Bonzini <pbonzini@redhat.com>,
        Gleb Natapov <gleb@kernel.org>, Hu Robert <robert.hu@intel.com>,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] KVM: nVMX: Fix IRQs inject to L2 which belong to L1
 since race
Message-ID: <20140704025250.GA2849@kernel>
Reply-To: Wanpeng Li <wanpeng.li@linux.intel.com>
References: <1404284054-51863-1-git-send-email-wanpeng.li@linux.intel.com>
 <53B3CA6A.4050902@siemens.com>
 <jpgy4wb9g5t.fsf@redhat.com>
 <20140703065955.GA4236@kernel>
 <jpgk37u8iae.fsf@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <jpgk37u8iae.fsf@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 03, 2014 at 01:27:05PM -0400, Bandan Das wrote:
[...]
># modprobe kvm_intel ept=0 nested=1 enable_shadow_vmcs=0
>
>The Host CPU - Intel(R) Core(TM) i7-4770 CPU @ 3.40GHz
>qemu cmd to run L1 - 
># qemu-system-x86_64 -drive file=level1.img,if=virtio,id=disk0,format=raw,cache=none,werror=stop,rerror=stop,aio=threads -drive file=level2.img,if=virtio,id=disk1,format=raw,cache=none,werror=stop,rerror=stop,aio=threads -vnc :2 --enable-kvm -monitor stdio -m 4G -net nic,macaddr=00:23:32:45:89:10 -net tap,ifname=tap0,script=/etc/qemu-ifup,downscript=no -smp 4 -cpu Nehalem,+vmx -serial pty
>
>qemu cmd to run L2 -
># sudo qemu-system-x86_64 -hda VM/level2.img -vnc :0 --enable-kvm -monitor stdio -m 2G -smp 2 -cpu Nehalem -redir tcp:5555::22
>
>Additionally,
>L0 is FC19 with 3.16-rc3
>L1 and L2 are Ubuntu 14.04 with 3.13.0-24-generic
>
>Then start a kernel compilation inside L2 with "make -j3"
>
>There's no call trace on L0, both L0 and L1 are hung (or rather really slow) and
>L1 serial spews out CPU softlock up errors. Enabling panic on softlockup on L1 will give
>a trace with smp_call_function_many() I think the corresponding code in kernel/smp.c that
>triggers this is
> 
>WARN_ON_ONCE(cpu_online(this_cpu) && irqs_disabled()
>                      && !oops_in_progress && !early_boot_irqs_disabled);
>
>I know in most cases this is usually harmless, but in this specific case,
>it seems it's stuck here forever.
>
>Sorry, I don't have a L1 call trace handy atm, I can post that if you are interested.
>
>Note that this can take as much as 30 to 40 minutes to appear but once it does,
>you will know because both L1 and L2 will be stuck with the serial messages as I mentioned
>before. From my side, let me try this on another system to rule out any machine specific
>weirdness going on..
>

Thanks for your pointing out. 

>Please let me know if you need any further information.
>

I just run kvm-unit-tests w/ vmx.flat and eventinj.flat.


w/ vmx.flat and w/o my patch applied 

[...]

Test suite : interrupt
FAIL: direct interrupt while running guest
PASS: intercepted interrupt while running guest
FAIL: direct interrupt + hlt
FAIL: intercepted interrupt + hlt
FAIL: direct interrupt + activity state hlt
FAIL: intercepted interrupt + activity state hlt
PASS: running a guest with interrupt acknowledgement set
SUMMARY: 69 tests, 6 failures

w/ vmx.flat and w/ my patch applied 

[...]

Test suite : interrupt
PASS: direct interrupt while running guest
PASS: intercepted interrupt while running guest
PASS: direct interrupt + hlt
FAIL: intercepted interrupt + hlt
PASS: direct interrupt + activity state hlt
PASS: intercepted interrupt + activity state hlt
PASS: running a guest with interrupt acknowledgement set

SUMMARY: 69 tests, 2 failures 


w/ eventinj.flat and w/o my patch applied 

SUMMARY: 13 tests, 0 failures

w/ eventinj.flat and w/ my patch applied 

SUMMARY: 13 tests, 0 failures


I'm not sure if the bug you mentioned has any relationship with "Fail:
intercepted interrupt + hlt" which has already present before my patch.

Regards,
Wanpeng Li 

>Thanks
>Bandan
>
>> Regards,
>> Wanpeng Li 
>>
>>>almost once in three times; it never happens if I run with ept=1, however,
>>>I think that's only because the test completes sooner. But I can confirm
>>>that I don't see it if I always set REQ_EVENT if nested_run_pending is set instead of
>>>the approach this patch takes.
>>>(Any debug hints help appreciated!)
>>>
>>>So, I am not sure if this is the right fix. Rather, I think the safer thing
>>>to do is to have the interrupt pending check for injection into L1 at
>>>the "same site" as the call to kvm_queue_interrupt() just like we had before 
>>>commit b6b8a1451fc40412c57d1. Is there any advantage to having all the 
>>>nested events checks together ?
>>>
>>>PS - Actually, a much easier fix (or rather hack) is to return 1 in 
>>>vmx_interrupt_allowed() (as I mentioned elsewhere) only if 
>>>!is_guest_mode(vcpu) That way, the pending interrupt interrupt 
>>>can be taken care of correctly during the next vmexit.
>>>
>>>Bandan
>>>
>>>> Jan
>>>>
>> [...]
