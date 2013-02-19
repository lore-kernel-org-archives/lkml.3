Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932494Ab3BSI6e (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Feb 2013 03:58:34 -0500
Received: from e23smtp02.au.ibm.com ([202.81.31.144]:60724 "EHLO
	e23smtp02.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932426Ab3BSI6c (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Feb 2013 03:58:32 -0500
Message-ID: <51233EAC.5080001@linux.vnet.ibm.com>
Date: Tue, 19 Feb 2013 16:58:20 +0800
From: Michael Wang <wangyun@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:16.0) Gecko/20121011 Thunderbird/16.0.1
MIME-Version: 1.0
To: Sasha Levin <sasha.levin@oracle.com>
CC: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <peterz@infradead.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Dave Jones <davej@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: sched: circular dependency between sched_domains_mutex and oom_notify_list
References: <51206DAB.7030701@oracle.com> <5123040C.4070302@linux.vnet.ibm.com>
In-Reply-To: <5123040C.4070302@linux.vnet.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13021908-5490-0000-0000-000002FCC816
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/19/2013 12:48 PM, Michael Wang wrote:
> On 02/17/2013 01:42 PM, Sasha Levin wrote:
>> Hi all,
>>
>> I was fuzzing with trinity inside a KVM tools guest, with today's -next kernel
>> when I've hit the following spew.
>>
>> I suspect it's the result of adding the new rcu_oom_notify, but that happened
>> about half a year ago so I'm not sure why this showed up only now.
> 
> Hi, Sasha
> 
> This is a rarely one, isn't it? require 2 conditions:
> 1. system is oom.
> 2. rebooting.
> 
> The possible dead lock related to oom_notify_list I suppose is:
> 
> 	CONTEXT A			CONTEXT B
> 
> 1	oom				reboot
> 
> 2	LOCK oom_notify_list		cpu_down()
> 
> 3	rcu_oom_notify()		LOCK cpu_hotplug.lock
> 
> 4	get_online_cpus()		partition_sched_domains()
> 
> 5	LOCK cpu_hotplug.lock		__sdt_alloc()		
> 
> 6					oom
> 
> 7					LOCK oom_notify_list
> 
> 	DEAD LOCK
> 
> So rcu_oom_notify() trying to lock cpu_hotplug.lock with oom_notify_list
> locked, and __sdt_alloc() trying to lock oom_notify_list with
> cpu_hotplug.lock locked, a circular locking case.
> 
> But I'm not sure why the log show the "sched_domains_mutex" as a target,
> so is your system really dead lock or it's just a fake report?

Oh, may be I use the wrong word here, the fake report means, you know,
some times there will be WARN, but it's fake, just like the case when
different lock have the same key/class...

Regards,
Michael Wang

> 
> Regards,
> Michael Wang
> 
>>
>> [ 1039.634183] ======================================================
>> [ 1039.635717] [ INFO: possible circular locking dependency detected ]
>> [ 1039.637255] 3.8.0-rc7-next-20130215-sasha-00003-gea816fa #286 Tainted: G        W
>> [ 1039.639104] -------------------------------------------------------
>> [ 1039.640579] init/1 is trying to acquire lock:
>> [ 1039.641224]  ((oom_notify_list).rwsem){.+.+..}, at: [<ffffffff81141c8f>] __blocking_notifier_call_chain+0x7f/0xc0
>> [ 1039.641224]
>> [ 1039.641224] but task is already holding lock:
>> [ 1039.641224]  (sched_domains_mutex){+.+.+.}, at: [<ffffffff811522d8>] partition_sched_domains+0x28/0x3f0
>> [ 1039.641224]
>> [ 1039.641224] which lock already depends on the new lock.
>> [ 1039.641224]
>> [ 1039.641224]
>> [ 1039.641224] the existing dependency chain (in reverse order) is:
>> [ 1039.641224]
>> -> #2 (sched_domains_mutex){+.+.+.}:
>> [ 1039.641224]        [<ffffffff8118013a>] check_prevs_add+0xba/0x1a0
>> [ 1039.641224]        [<ffffffff811808c0>] validate_chain.isra.21+0x6a0/0x7b0
>> [ 1039.641224]        [<ffffffff81183b43>] __lock_acquire+0xa13/0xb00
>> [ 1039.641224]        [<ffffffff8118451a>] lock_acquire+0x1ca/0x270
>> [ 1039.641224]        [<ffffffff83d8a19a>] __mutex_lock_common+0x5a/0x560
>> [ 1039.641224]        [<ffffffff83d8a7cf>] mutex_lock_nested+0x3f/0x50
>> [ 1039.641224]        [<ffffffff811522d8>] partition_sched_domains+0x28/0x3f0
>> [ 1039.641224]        [<ffffffff8115274b>] cpuset_cpu_inactive+0x3b/0x50
>> [ 1039.641224]        [<ffffffff83d9174e>] notifier_call_chain+0xee/0x130
>> [ 1039.641224]        [<ffffffff81141b09>] __raw_notifier_call_chain+0x9/0x10
>> [ 1039.641224]        [<ffffffff8110dd1b>] __cpu_notify+0x1b/0x30
>> [ 1039.641224]        [<ffffffff83ce34ef>] _cpu_down+0xaf/0x350
>> [ 1039.641224]        [<ffffffff8110e164>] disable_nonboot_cpus+0x84/0x1c0
>> [ 1039.641224]        [<ffffffff811288f6>] kernel_restart+0x16/0x60
>> [ 1039.641224]        [<ffffffff81128ab1>] sys_reboot+0x161/0x2b0
>> [ 1039.641224]        [<ffffffff83d96198>] tracesys+0xe1/0xe6
>> [ 1039.641224]
>> -> #1 (cpu_hotplug.lock){+.+.+.}:
>> [ 1039.641224]        [<ffffffff8118013a>] check_prevs_add+0xba/0x1a0
>> [ 1039.641224]        [<ffffffff811808c0>] validate_chain.isra.21+0x6a0/0x7b0
>> [ 1039.641224]        [<ffffffff81183b43>] __lock_acquire+0xa13/0xb00
>> [ 1039.641224]        [<ffffffff8118451a>] lock_acquire+0x1ca/0x270
>> [ 1039.641224]        [<ffffffff83d8a19a>] __mutex_lock_common+0x5a/0x560
>> [ 1039.641224]        [<ffffffff83d8a7cf>] mutex_lock_nested+0x3f/0x50
>> [ 1039.641224]        [<ffffffff8110de77>] get_online_cpus+0x37/0x50
>> [ 1039.641224]        [<ffffffff811d01b4>] rcu_oom_notify+0x94/0x150
>> [ 1039.641224]        [<ffffffff83d9174e>] notifier_call_chain+0xee/0x130
>> [ 1039.641224]        [<ffffffff81141ca8>] __blocking_notifier_call_chain+0x98/0xc0
>> [ 1039.641224]        [<ffffffff81141ce1>] blocking_notifier_call_chain+0x11/0x20
>> [ 1039.641224]        [<ffffffff81212155>] out_of_memory+0x45/0x1f0
>> [ 1039.641224]        [<ffffffff812184dd>] __alloc_pages_nodemask+0x83d/0xbf0
>> [ 1039.641224]        [<ffffffff8125d6ac>] alloc_pages_vma+0xfc/0x150
>> [ 1039.641224]        [<ffffffff812509f0>] read_swap_cache_async+0x90/0x220
>> [ 1039.641224]        [<ffffffff81250c1e>] swapin_readahead+0x9e/0xf0
>> [ 1039.641224]        [<ffffffff8123af57>] do_swap_page.isra.41+0x107/0x5a0
>> [ 1039.641224]        [<ffffffff8123d056>] handle_pte_fault+0x126/0x200
>> [ 1039.641224]        [<ffffffff8123e4a7>] handle_mm_fault+0x397/0x3e0
>> [ 1039.641224]        [<ffffffff8123e9d8>] __get_user_pages+0x418/0x5f0
>> [ 1039.641224]        [<ffffffff81240563>] __mlock_vma_pages_range+0xb3/0xc0
>> [ 1039.641224]        [<ffffffff81240a74>] __mm_populate+0xf4/0x170
>> [ 1039.641224]        [<ffffffff81240e10>] sys_mlockall+0x160/0x1a0
>> [ 1039.641224]        [<ffffffff83d96198>] tracesys+0xe1/0xe6
>> [ 1039.641224]
>> -> #0 ((oom_notify_list).rwsem){.+.+..}:
>> [ 1039.641224]        [<ffffffff8117fb55>] check_prev_add+0x115/0x640
>> [ 1039.641224]        [<ffffffff8118013a>] check_prevs_add+0xba/0x1a0
>> [ 1039.641224]        [<ffffffff811808c0>] validate_chain.isra.21+0x6a0/0x7b0
>> [ 1039.641224]        [<ffffffff81183b43>] __lock_acquire+0xa13/0xb00
>> [ 1039.641224]        [<ffffffff8118451a>] lock_acquire+0x1ca/0x270
>> [ 1039.641224]        [<ffffffff83d8adb7>] down_read+0x47/0x8e
>> [ 1039.641224]        [<ffffffff81141c8f>] __blocking_notifier_call_chain+0x7f/0xc0
>> [ 1039.641224]        [<ffffffff81141ce1>] blocking_notifier_call_chain+0x11/0x20
>> [ 1039.641224]        [<ffffffff81212155>] out_of_memory+0x45/0x1f0
>> [ 1039.641224]        [<ffffffff812184dd>] __alloc_pages_nodemask+0x83d/0xbf0
>> [ 1039.641224]        [<ffffffff8126629a>] allocate_slab+0x13a/0x1f0
>> [ 1039.641224]        [<ffffffff8126637b>] new_slab+0x2b/0x1b0
>> [ 1039.641224]        [<ffffffff83d030e1>] __slab_alloc.isra.34+0x1c5/0x31f
>> [ 1039.641224]        [<ffffffff81268e14>] kmem_cache_alloc_node_trace+0x114/0x390
>> [ 1039.641224]        [<ffffffff8114b567>] __sdt_alloc+0x137/0x1f0
>> [ 1039.641224]        [<ffffffff81151d2c>] build_sched_domains+0x2c/0x4e0
>> [ 1039.641224]        [<ffffffff81152603>] partition_sched_domains+0x353/0x3f0
>> [ 1039.641224]        [<ffffffff8115274b>] cpuset_cpu_inactive+0x3b/0x50
>> [ 1039.641224]        [<ffffffff83d9174e>] notifier_call_chain+0xee/0x130
>> [ 1039.641224]        [<ffffffff81141b09>] __raw_notifier_call_chain+0x9/0x10
>> [ 1039.641224]        [<ffffffff8110dd1b>] __cpu_notify+0x1b/0x30
>> [ 1039.641224]        [<ffffffff83ce34ef>] _cpu_down+0xaf/0x350
>> [ 1039.641224]        [<ffffffff8110e164>] disable_nonboot_cpus+0x84/0x1c0
>> [ 1039.641224]        [<ffffffff811288f6>] kernel_restart+0x16/0x60
>> [ 1039.641224]        [<ffffffff81128ab1>] sys_reboot+0x161/0x2b0
>> [ 1039.641224]        [<ffffffff83d96198>] tracesys+0xe1/0xe6
>> [ 1039.641224]
>> [ 1039.641224] other info that might help us debug this:
>> [ 1039.641224]
>> [ 1039.641224] Chain exists of:
>>   (oom_notify_list).rwsem --> cpu_hotplug.lock --> sched_domains_mutex
>>
>> [ 1039.641224]  Possible unsafe locking scenario:
>> [ 1039.641224]
>> [ 1039.641224]        CPU0                    CPU1
>> [ 1039.641224]        ----                    ----
>> [ 1039.641224]   lock(sched_domains_mutex);
>> [ 1039.641224]                                lock(cpu_hotplug.lock);
>> [ 1039.641224]                                lock(sched_domains_mutex);
>> [ 1039.641224]   lock((oom_notify_list).rwsem);
>> [ 1039.641224]
>> [ 1039.641224]  *** DEADLOCK ***
>> [ 1039.641224]
>> [ 1039.641224] 4 locks held by init/1:
>> [ 1039.641224]  #0:  (reboot_mutex){+.+.+.}, at: [<ffffffff81128a2e>] sys_reboot+0xde/0x2b0
>> [ 1039.641224]  #1:  (cpu_add_remove_lock){+.+.+.}, at: [<ffffffff8110dea2>] cpu_maps_update_begin+0x12/0x20
>> [ 1039.641224]  #2:  (cpu_hotplug.lock){+.+.+.}, at: [<ffffffff8110dd87>] cpu_hotplug_begin+0x27/0x60
>> [ 1039.641224]  #3:  (sched_domains_mutex){+.+.+.}, at: [<ffffffff811522d8>] partition_sched_domains+0x28/0x3f0
>> [ 1039.641224]
>> [ 1039.641224] stack backtrace:
>> [ 1039.641224] Pid: 1, comm: init Tainted: G        W    3.8.0-rc7-next-20130215-sasha-00003-gea816fa #286
>> [ 1039.641224] Call Trace:
>> [ 1039.641224]  [<ffffffff83cff50f>] print_circular_bug+0xd3/0xe4
>> [ 1039.641224]  [<ffffffff8117fb55>] check_prev_add+0x115/0x640
>> [ 1039.641224]  [<ffffffff8118013a>] check_prevs_add+0xba/0x1a0
>> [ 1039.641224]  [<ffffffff81074ef5>] ? sched_clock+0x15/0x20
>> [ 1039.641224]  [<ffffffff811808c0>] validate_chain.isra.21+0x6a0/0x7b0
>> [ 1039.641224]  [<ffffffff81183b43>] __lock_acquire+0xa13/0xb00
>> [ 1039.641224]  [<ffffffff81074ef5>] ? sched_clock+0x15/0x20
>> [ 1039.641224]  [<ffffffff810a1258>] ? kvm_clock_read+0x38/0x70
>> [ 1039.641224]  [<ffffffff8118451a>] lock_acquire+0x1ca/0x270
>> [ 1039.641224]  [<ffffffff81141c8f>] ? __blocking_notifier_call_chain+0x7f/0xc0
>> [ 1039.641224]  [<ffffffff83d8adb7>] down_read+0x47/0x8e
>> [ 1039.641224]  [<ffffffff81141c8f>] ? __blocking_notifier_call_chain+0x7f/0xc0
>> [ 1039.641224]  [<ffffffff81141c8f>] __blocking_notifier_call_chain+0x7f/0xc0
>> [ 1039.641224]  [<ffffffff81141ce1>] blocking_notifier_call_chain+0x11/0x20
>> [ 1039.641224]  [<ffffffff81212155>] out_of_memory+0x45/0x1f0
>> [ 1039.641224]  [<ffffffff812184dd>] __alloc_pages_nodemask+0x83d/0xbf0
>> [ 1039.641224]  [<ffffffff8126629a>] allocate_slab+0x13a/0x1f0
>> [ 1039.641224]  [<ffffffff8126637b>] new_slab+0x2b/0x1b0
>> [ 1039.641224]  [<ffffffff83d030e1>] __slab_alloc.isra.34+0x1c5/0x31f
>> [ 1039.641224]  [<ffffffff81182492>] ? __lock_is_held+0x52/0x80
>> [ 1039.641224]  [<ffffffff8114b567>] ? __sdt_alloc+0x137/0x1f0
>> [ 1039.641224]  [<ffffffff81268e14>] kmem_cache_alloc_node_trace+0x114/0x390
>> [ 1039.641224]  [<ffffffff8123349b>] ? pcpu_alloc+0x32b/0x3e0
>> [ 1039.641224]  [<ffffffff8114b52b>] ? __sdt_alloc+0xfb/0x1f0
>> [ 1039.641224]  [<ffffffff8114b567>] ? __sdt_alloc+0x137/0x1f0
>> [ 1039.641224]  [<ffffffff8114b567>] __sdt_alloc+0x137/0x1f0
>> [ 1039.641224]  [<ffffffff811524d0>] ? partition_sched_domains+0x220/0x3f0
>> [ 1039.641224]  [<ffffffff81151d2c>] build_sched_domains+0x2c/0x4e0
>> [ 1039.641224]  [<ffffffff81152603>] partition_sched_domains+0x353/0x3f0
>> [ 1039.641224]  [<ffffffff81152397>] ? partition_sched_domains+0xe7/0x3f0
>> [ 1039.641224]  [<ffffffff8115274b>] cpuset_cpu_inactive+0x3b/0x50
>> [ 1039.641224]  [<ffffffff83d9174e>] notifier_call_chain+0xee/0x130
>> [ 1039.641224]  [<ffffffff81141b09>] __raw_notifier_call_chain+0x9/0x10
>> [ 1039.641224]  [<ffffffff8110dd1b>] __cpu_notify+0x1b/0x30
>> [ 1039.641224]  [<ffffffff83ce34ef>] _cpu_down+0xaf/0x350
>> [ 1039.641224]  [<ffffffff83cfd6b8>] ? printk+0x5c/0x5e
>> [ 1039.641224]  [<ffffffff8110e164>] disable_nonboot_cpus+0x84/0x1c0
>> [ 1039.641224]  [<ffffffff811288f6>] kernel_restart+0x16/0x60
>> [ 1039.641224]  [<ffffffff81128ab1>] sys_reboot+0x161/0x2b0
>> [ 1039.641224]  [<ffffffff811d5dc4>] ? rcu_eqs_exit_common+0x64/0x340
>> [ 1039.641224]  [<ffffffff811d7146>] ? rcu_eqs_enter_common+0x306/0x3a0
>> [ 1039.641224]  [<ffffffff8120cac5>] ? user_exit+0xa5/0xd0
>> [ 1039.641224]  [<ffffffff811813e8>] ? trace_hardirqs_on_caller+0x128/0x160
>> [ 1039.641224]  [<ffffffff8118142d>] ? trace_hardirqs_on+0xd/0x10
>> [ 1039.641224]  [<ffffffff8107ad34>] ? syscall_trace_enter+0x24/0x2e0
>> [ 1039.641224]  [<ffffffff811813e8>] ? trace_hardirqs_on_caller+0x128/0x160
>> [ 1039.641224]  [<ffffffff83d96198>] tracesys+0xe1/0xe6
>>
>>
>> Thanks,
>> Sasha
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>> Please read the FAQ at  http://www.tux.org/lkml/
>>
> 

