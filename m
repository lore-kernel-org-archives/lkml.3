Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753131Ab3ITSE2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Sep 2013 14:04:28 -0400
Received: from goliath.siemens.de ([192.35.17.28]:33802 "EHLO
	goliath.siemens.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752540Ab3ITSE0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Sep 2013 14:04:26 -0400
Message-ID: <523C8E23.4080904@siemens.com>
Date: Fri, 20 Sep 2013 20:04:19 +0200
From: Jan Kiszka <jan.kiszka@siemens.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); de; rv:1.8.1.12) Gecko/20080226 SUSE/2.0.0.12-1.1 Thunderbird/2.0.0.12 Mnenhy/0.7.5.666
MIME-Version: 1.0
To: Paul Gortmaker <paul.gortmaker@windriver.com>
CC: Paolo Bonzini <pbonzini@redhat.com>, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, gleb@redhat.com, linux-rt-users@vger.kernel.org,
        Alex Williamson <alex.williamson@redhat.com>,
        "Michael S. Tsirkin" <mst@redhat.com>
Subject: Re: [PATCH 0/3] KVM: Make kvm_lock non-raw
References: <1379340373-5135-1-git-send-email-pbonzini@redhat.com> <5237824E.5090802@windriver.com> <20130920175150.GA24770@windriver.com>
In-Reply-To: <20130920175150.GA24770@windriver.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2013-09-20 19:51, Paul Gortmaker wrote:
> [Re: [PATCH 0/3] KVM: Make kvm_lock non-raw] On 16/09/2013 (Mon 18:12) Paul Gortmaker wrote:
> 
>> On 13-09-16 10:06 AM, Paolo Bonzini wrote:
>>> Paul Gortmaker reported a BUG on preempt-rt kernels, due to taking the
>>> mmu_lock within the raw kvm_lock in mmu_shrink_scan.  He provided a
>>> patch that shrunk the kvm_lock critical section so that the mmu_lock
>>> critical section does not nest with it, but in the end there is no reason
>>> for the vm_list to be protected by a raw spinlock.  Only manipulations
>>> of kvm_usage_count and the consequent hardware_enable/disable operations
>>> are not preemptable.
>>>
>>> This small series thus splits the kvm_lock in the "raw" part and the
>>> "non-raw" part.
>>>
>>> Paul, could you please provide your Tested-by?
>>
>> Sure, I'll go back and see if I can find what triggered it in the
>> original report, and give the patches a spin on 3.4.x-rt (and probably
>> 3.10.x-rt, since that is where rt-current is presently).
> 
> Seems fine on 3.4-rt.  On 3.10.10-rt7 it looks like there are other
> issues, probably not explicitly related to this patchset (see below).
> 
> Paul.
> --
> 
> e1000e 0000:00:19.0 eth1: removed PHC
> assign device 0:0:19.0
> pci 0000:00:19.0: irq 43 for MSI/MSI-X
> pci 0000:00:19.0: irq 43 for MSI/MSI-X
> pci 0000:00:19.0: irq 43 for MSI/MSI-X
> pci 0000:00:19.0: irq 43 for MSI/MSI-X
> BUG: sleeping function called from invalid context at /home/paul/git/linux-rt/kernel/rtmutex.c:659
> in_atomic(): 1, irqs_disabled(): 1, pid: 0, name: swapper/0
> 2 locks held by swapper/0/0:
>  #0:  (rcu_read_lock){.+.+.+}, at: [<ffffffff8100998a>] kvm_set_irq_inatomic+0x2a/0x4a0
>  #1:  (rcu_read_lock){.+.+.+}, at: [<ffffffff81038800>] kvm_irq_delivery_to_apic_fast+0x60/0x3d0
> irq event stamp: 6121390
> hardirqs last  enabled at (6121389): [<ffffffff819f9ae0>] restore_args+0x0/0x30
> hardirqs last disabled at (6121390): [<ffffffff819f9a2a>] common_interrupt+0x6a/0x6f
> softirqs last  enabled at (0): [<          (null)>]           (null)
> softirqs last disabled at (0): [<          (null)>]           (null)
> Preemption disabled at:[<ffffffff810ebb9a>] cpu_startup_entry+0x1ba/0x430
> 
> CPU: 0 PID: 0 Comm: swapper/0 Not tainted 3.10.10-rt7 #2
> Hardware name: Dell Inc. OptiPlex 990/0VNP2H, BIOS A17 03/14/2013
>  ffffffff8201c440 ffff880223603cf0 ffffffff819f177d ffff880223603d18
>  ffffffff810c90d3 ffff880214a50110 0000000000000001 0000000000000001
>  ffff880223603d38 ffffffff819f89a4 ffff880214a50110 ffff880214a50110
> Call Trace:
>  <IRQ>  [<ffffffff819f177d>] dump_stack+0x19/0x1b
>  [<ffffffff810c90d3>] __might_sleep+0x153/0x250
>  [<ffffffff819f89a4>] rt_spin_lock+0x24/0x60
>  [<ffffffff810ccdd6>] __wake_up+0x36/0x70
>  [<ffffffff81003bbb>] kvm_vcpu_kick+0x3b/0xd0

-rt lacks an atomic waitqueue for triggering VCPU wakeups on MSIs from
assigned devices directly from the host IRQ handler. We need to disable
this fast-path in -rt or introduce such an abstraction (I did this once
over 2.6.33-rt).

IIRC, VFIO goes the slower patch via a kernel thread unconditionally,
thus cannot trigger this. Only legacy device assignment is affected.

Jan

>  [<ffffffff810371a2>] __apic_accept_irq+0x2b2/0x3a0
>  [<ffffffff810385f7>] kvm_apic_set_irq+0x27/0x30
>  [<ffffffff8103894e>] kvm_irq_delivery_to_apic_fast+0x1ae/0x3d0
>  [<ffffffff81038800>] ? kvm_irq_delivery_to_apic_fast+0x60/0x3d0
>  [<ffffffff81009a8b>] kvm_set_irq_inatomic+0x12b/0x4a0
>  [<ffffffff8100998a>] ? kvm_set_irq_inatomic+0x2a/0x4a0
>  [<ffffffff8100c5b3>] kvm_assigned_dev_msi+0x23/0x40
>  [<ffffffff8113cb38>] handle_irq_event_percpu+0x88/0x3d0
>  [<ffffffff810ebb7c>] ? cpu_startup_entry+0x19c/0x430
>  [<ffffffff8113cec8>] handle_irq_event+0x48/0x70
>  [<ffffffff8113f9b7>] handle_edge_irq+0x77/0x120
>  [<ffffffff8104c6ae>] handle_irq+0x1e/0x30
>  [<ffffffff81a035ca>] do_IRQ+0x5a/0xd0
>  [<ffffffff819f9a2f>] common_interrupt+0x6f/0x6f
>  <EOI>  [<ffffffff819f9ae0>] ? retint_restore_args+0xe/0xe
>  [<ffffffff810ebb7c>] ? cpu_startup_entry+0x19c/0x430
>  [<ffffffff810ebb38>] ? cpu_startup_entry+0x158/0x430
>  [<ffffffff819db767>] rest_init+0x137/0x140
>  [<ffffffff819db635>] ? rest_init+0x5/0x140
>  [<ffffffff822fde18>] start_kernel+0x3af/0x3bc
>  [<ffffffff822fd870>] ? repair_env_string+0x5e/0x5e
>  [<ffffffff822fd5a5>] x86_64_start_reservations+0x2a/0x2c
>  [<ffffffff822fd673>] x86_64_start_kernel+0xcc/0xcf
> 
> =================================
> [ INFO: inconsistent lock state ]
> 3.10.10-rt7 #2 Not tainted
> ---------------------------------
> inconsistent {HARDIRQ-ON-W} -> {IN-HARDIRQ-W} usage.
> swapper/0/0 [HC1[1]:SC0[0]:HE0:SE1] takes:
>  (&(&(&q->lock)->lock)->wait_lock){?.+.-.}, at: [<ffffffff819f7e98>] rt_spin_lock_slowlock+0x48/0x370
> {HARDIRQ-ON-W} state was registered at:
>   [<ffffffff810fc94d>] __lock_acquire+0x69d/0x20e0
>   [<ffffffff810feaee>] lock_acquire+0x9e/0x1f0
>   [<ffffffff819f9090>] _raw_spin_lock+0x40/0x80
>   [<ffffffff819f7e98>] rt_spin_lock_slowlock+0x48/0x370
>   [<ffffffff819f89ac>] rt_spin_lock+0x2c/0x60
>   [<ffffffff810ccdd6>] __wake_up+0x36/0x70
>   [<ffffffff8109c5ce>] run_timer_softirq+0x1be/0x390
>   [<ffffffff81092a09>] do_current_softirqs+0x239/0x5b0
>   [<ffffffff81092db8>] run_ksoftirqd+0x38/0x60
>   [<ffffffff810c5d7c>] smpboot_thread_fn+0x22c/0x340
>   [<ffffffff810bbf4d>] kthread+0xcd/0xe0
>   [<ffffffff81a019dc>] ret_from_fork+0x7c/0xb0
> irq event stamp: 6121390
> hardirqs last  enabled at (6121389): [<ffffffff819f9ae0>] restore_args+0x0/0x30
> hardirqs last disabled at (6121390): [<ffffffff819f9a2a>] common_interrupt+0x6a/0x6f
> softirqs last  enabled at (0): [<          (null)>]           (null)
> softirqs last disabled at (0): [<          (null)>]           (null)
> 
> other info that might help us debug this:
>  Possible unsafe locking scenario:
> 
>        CPU0
>        ----
>   lock(&(&(&q->lock)->lock)->wait_lock);
>   <Interrupt>
>     lock(&(&(&q->lock)->lock)->wait_lock);
> 
>  *** DEADLOCK ***
> 
> 2 locks held by swapper/0/0:
>  #0:  (rcu_read_lock){.+.+.+}, at: [<ffffffff8100998a>] kvm_set_irq_inatomic+0x2a/0x4a0
>  #1:  (rcu_read_lock){.+.+.+}, at: [<ffffffff81038800>] kvm_irq_delivery_to_apic_fast+0x60/0x3d0
> 
> stack backtrace:
> CPU: 0 PID: 0 Comm: swapper/0 Not tainted 3.10.10-rt7 #2
> Hardware name: Dell Inc. OptiPlex 990/0VNP2H, BIOS A17 03/14/2013
>  ffffffff8262b550 ffff880223603a40 ffffffff819f177d ffff880223603a90
>  ffffffff819ec532 0000000000000000 ffffffff00000000 ffff880200000001
>  0000000000000002 ffffffff8201ccc0 ffffffff810f9040 0000000000000000
> Call Trace:
>  <IRQ>  [<ffffffff819f177d>] dump_stack+0x19/0x1b
>  [<ffffffff819ec532>] print_usage_bug.part.36+0x28b/0x29a
>  [<ffffffff810f9040>] ? check_usage_backwards+0x150/0x150
>  [<ffffffff810f9dab>] mark_lock+0x28b/0x6a0
>  [<ffffffff810fcbf9>] __lock_acquire+0x949/0x20e0
>  [<ffffffff811091f2>] ? __module_text_address+0x12/0x60
>  [<ffffffff8110ea8f>] ? is_module_text_address+0x2f/0x60
>  [<ffffffff810b8408>] ? __kernel_text_address+0x58/0x80
>  [<ffffffff8104dbb2>] ? print_context_stack+0x62/0xf0
>  [<ffffffff810feaee>] lock_acquire+0x9e/0x1f0
>  [<ffffffff819f7e98>] ? rt_spin_lock_slowlock+0x48/0x370
>  [<ffffffff819f9090>] _raw_spin_lock+0x40/0x80
>  [<ffffffff819f7e98>] ? rt_spin_lock_slowlock+0x48/0x370
>  [<ffffffff819f7e98>] rt_spin_lock_slowlock+0x48/0x370
>  [<ffffffff819f89ac>] rt_spin_lock+0x2c/0x60
>  [<ffffffff810ccdd6>] __wake_up+0x36/0x70
>  [<ffffffff81003bbb>] kvm_vcpu_kick+0x3b/0xd0
>  [<ffffffff810371a2>] __apic_accept_irq+0x2b2/0x3a0
>  [<ffffffff810385f7>] kvm_apic_set_irq+0x27/0x30
>  [<ffffffff8103894e>] kvm_irq_delivery_to_apic_fast+0x1ae/0x3d0
>  [<ffffffff81038800>] ? kvm_irq_delivery_to_apic_fast+0x60/0x3d0
>  [<ffffffff81009a8b>] kvm_set_irq_inatomic+0x12b/0x4a0
>  [<ffffffff8100998a>] ? kvm_set_irq_inatomic+0x2a/0x4a0
>  [<ffffffff8100c5b3>] kvm_assigned_dev_msi+0x23/0x40
>  [<ffffffff8113cb38>] handle_irq_event_percpu+0x88/0x3d0
>  [<ffffffff810ebb7c>] ? cpu_startup_entry+0x19c/0x430
>  [<ffffffff8113cec8>] handle_irq_event+0x48/0x70
>  [<ffffffff8113f9b7>] handle_edge_irq+0x77/0x120
>  [<ffffffff8104c6ae>] handle_irq+0x1e/0x30
>  [<ffffffff81a035ca>] do_IRQ+0x5a/0xd0
>  [<ffffffff819f9a2f>] common_interrupt+0x6f/0x6f
>  <EOI>  [<ffffffff819f9ae0>] ? retint_restore_args+0xe/0xe
>  [<ffffffff810ebb7c>] ? cpu_startup_entry+0x19c/0x430
>  [<ffffffff810ebb38>] ? cpu_startup_entry+0x158/0x430
>  [<ffffffff819db767>] rest_init+0x137/0x140
>  [<ffffffff819db635>] ? rest_init+0x5/0x140
>  [<ffffffff822fde18>] start_kernel+0x3af/0x3bc
>  [<ffffffff822fd870>] ? repair_env_string+0x5e/0x5e
>  [<ffffffff822fd5a5>] x86_64_start_reservations+0x2a/0x2c
>  [<ffffffff822fd673>] x86_64_start_kernel+0xcc/0xcf

-- 
Siemens AG, Corporate Technology, CT RTC ITP SES-DE
Corporate Competence Center Embedded Linux
