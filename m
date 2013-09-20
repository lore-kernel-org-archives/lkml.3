Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753606Ab3ITS2K (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Sep 2013 14:28:10 -0400
Received: from david.siemens.de ([192.35.17.14]:21753 "EHLO david.siemens.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751936Ab3ITS2I (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Sep 2013 14:28:08 -0400
Message-ID: <523C93AF.5060109@siemens.com>
Date: Fri, 20 Sep 2013 20:27:59 +0200
From: Jan Kiszka <jan.kiszka@siemens.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); de; rv:1.8.1.12) Gecko/20080226 SUSE/2.0.0.12-1.1 Thunderbird/2.0.0.12 Mnenhy/0.7.5.666
MIME-Version: 1.0
To: Paul Gortmaker <paul.gortmaker@windriver.com>
CC: Paolo Bonzini <pbonzini@redhat.com>, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, gleb@redhat.com, linux-rt-users@vger.kernel.org,
        Alex Williamson <alex.williamson@redhat.com>,
        "Michael S. Tsirkin" <mst@redhat.com>
Subject: Re: [PATCH 0/3] KVM: Make kvm_lock non-raw
References: <1379340373-5135-1-git-send-email-pbonzini@redhat.com> <5237824E.5090802@windriver.com> <20130920175150.GA24770@windriver.com> <523C8E23.4080904@siemens.com> <523C9172.8070509@windriver.com>
In-Reply-To: <523C9172.8070509@windriver.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2013-09-20 20:18, Paul Gortmaker wrote:
> On 13-09-20 02:04 PM, Jan Kiszka wrote:
>> On 2013-09-20 19:51, Paul Gortmaker wrote:
>>> [Re: [PATCH 0/3] KVM: Make kvm_lock non-raw] On 16/09/2013 (Mon 18:12) Paul Gortmaker wrote:
>>>
>>>> On 13-09-16 10:06 AM, Paolo Bonzini wrote:
>>>>> Paul Gortmaker reported a BUG on preempt-rt kernels, due to taking the
>>>>> mmu_lock within the raw kvm_lock in mmu_shrink_scan.  He provided a
>>>>> patch that shrunk the kvm_lock critical section so that the mmu_lock
>>>>> critical section does not nest with it, but in the end there is no reason
>>>>> for the vm_list to be protected by a raw spinlock.  Only manipulations
>>>>> of kvm_usage_count and the consequent hardware_enable/disable operations
>>>>> are not preemptable.
>>>>>
>>>>> This small series thus splits the kvm_lock in the "raw" part and the
>>>>> "non-raw" part.
>>>>>
>>>>> Paul, could you please provide your Tested-by?
>>>>
>>>> Sure, I'll go back and see if I can find what triggered it in the
>>>> original report, and give the patches a spin on 3.4.x-rt (and probably
>>>> 3.10.x-rt, since that is where rt-current is presently).
>>>
>>> Seems fine on 3.4-rt.  On 3.10.10-rt7 it looks like there are other
>>> issues, probably not explicitly related to this patchset (see below).
>>>
>>> Paul.
>>> --
>>>
>>> e1000e 0000:00:19.0 eth1: removed PHC
>>> assign device 0:0:19.0
>>> pci 0000:00:19.0: irq 43 for MSI/MSI-X
>>> pci 0000:00:19.0: irq 43 for MSI/MSI-X
>>> pci 0000:00:19.0: irq 43 for MSI/MSI-X
>>> pci 0000:00:19.0: irq 43 for MSI/MSI-X
>>> BUG: sleeping function called from invalid context at /home/paul/git/linux-rt/kernel/rtmutex.c:659
>>> in_atomic(): 1, irqs_disabled(): 1, pid: 0, name: swapper/0
>>> 2 locks held by swapper/0/0:
>>>  #0:  (rcu_read_lock){.+.+.+}, at: [<ffffffff8100998a>] kvm_set_irq_inatomic+0x2a/0x4a0
>>>  #1:  (rcu_read_lock){.+.+.+}, at: [<ffffffff81038800>] kvm_irq_delivery_to_apic_fast+0x60/0x3d0
>>> irq event stamp: 6121390
>>> hardirqs last  enabled at (6121389): [<ffffffff819f9ae0>] restore_args+0x0/0x30
>>> hardirqs last disabled at (6121390): [<ffffffff819f9a2a>] common_interrupt+0x6a/0x6f
>>> softirqs last  enabled at (0): [<          (null)>]           (null)
>>> softirqs last disabled at (0): [<          (null)>]           (null)
>>> Preemption disabled at:[<ffffffff810ebb9a>] cpu_startup_entry+0x1ba/0x430
>>>
>>> CPU: 0 PID: 0 Comm: swapper/0 Not tainted 3.10.10-rt7 #2
>>> Hardware name: Dell Inc. OptiPlex 990/0VNP2H, BIOS A17 03/14/2013
>>>  ffffffff8201c440 ffff880223603cf0 ffffffff819f177d ffff880223603d18
>>>  ffffffff810c90d3 ffff880214a50110 0000000000000001 0000000000000001
>>>  ffff880223603d38 ffffffff819f89a4 ffff880214a50110 ffff880214a50110
>>> Call Trace:
>>>  <IRQ>  [<ffffffff819f177d>] dump_stack+0x19/0x1b
>>>  [<ffffffff810c90d3>] __might_sleep+0x153/0x250
>>>  [<ffffffff819f89a4>] rt_spin_lock+0x24/0x60
>>>  [<ffffffff810ccdd6>] __wake_up+0x36/0x70
>>>  [<ffffffff81003bbb>] kvm_vcpu_kick+0x3b/0xd0
>>
>> -rt lacks an atomic waitqueue for triggering VCPU wakeups on MSIs from
>> assigned devices directly from the host IRQ handler. We need to disable
>> this fast-path in -rt or introduce such an abstraction (I did this once
>> over 2.6.33-rt).
> 
> Ah, right -- the simple wait queue support (currently -rt specific)
> would have to be used here.  It is on the todo list to get that moved
> from -rt into mainline.

Oh, it's there in -rt already - perfect! If there is a good reason for
upstream, kvm can switch of course.

Jan

-- 
Siemens AG, Corporate Technology, CT RTC ITP SES-DE
Corporate Competence Center Embedded Linux
