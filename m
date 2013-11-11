Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752850Ab3KKHr1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Nov 2013 02:47:27 -0500
Received: from e28smtp09.in.ibm.com ([122.248.162.9]:34278 "EHLO
	e28smtp09.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750979Ab3KKHrV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Nov 2013 02:47:21 -0500
Message-ID: <52808B7F.6000309@linux.vnet.ibm.com>
Date: Mon, 11 Nov 2013 15:47:11 +0800
From: Michael wang <wangyun@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.1.0
MIME-Version: 1.0
To: Fengguang Wu <fengguang.wu@intel.com>,
        Peter Zijlstra <peterz@infradead.org>
CC: Ingo Molnar <mingo@kernel.org>, linux-kernel@vger.kernel.org
Subject: Re: [sched/get_online_cpus] INFO: task swapper/0:1 blocked for more
 than 120 seconds.
References: <20131110101612.GC21916@localhost>
In-Reply-To: <20131110101612.GC21916@localhost>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13111107-2674-0000-0000-00000B703A0C
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi, Fengguang

On 11/10/2013 06:16 PM, Fengguang Wu wrote:
> Greetings,
> 
> I got the below dmesg and the first bad commit is

I guess this will disappear when '!CONFIG_RCU_BOOST'...

AFAIK, if the rsp was in boost mode, we count on smpboot-thread
'rcu_cpu_thread_spec' to finish the callback, which will be
parked before do sync-rcu inside _cpu_down(), if that was true,
then the sync will never finish...

May be some brainless fix like this?



diff --git a/kernel/cpu.c b/kernel/cpu.c
index 63aa50d..aa24338 100644
--- a/kernel/cpu.c
+++ b/kernel/cpu.c
@@ -306,7 +306,6 @@ static int __ref _cpu_down(unsigned int cpu, int tasks_frozen)
                                __func__, cpu);
                goto out_release;
        }
-       smpboot_park_threads(cpu);
 
        /*
         * By now we've cleared cpu_active_mask, wait for all preempt-disabled
@@ -321,6 +320,8 @@ static int __ref _cpu_down(unsigned int cpu, int tasks_frozen)
 #endif
        synchronize_rcu();
 
+       smpboot_park_threads(cpu);
+
        /*
         * So now all preempt/rcu users must observe !cpu_active().
         */

Regards,
Michael Wang

> 
> commit 6acce3ef84520537f8a09a12c9ddbe814a584dd2
> Author: Peter Zijlstra <peterz@infradead.org>
> Date:   Fri Oct 11 14:38:20 2013 +0200
> 
>     sched: Remove get_online_cpus() usage
>     
>     Remove get_online_cpus() usage from the scheduler; there's 4 sites that
>     use it:
>     
>      - sched_init_smp(); where its completely superfluous since we're in
>        'early' boot and there simply cannot be any hotplugging.
>     
>      - sched_getaffinity(); we already take a raw spinlock to protect the
>        task cpus_allowed mask, this disables preemption and therefore
>        also stabilizes cpu_online_mask as that's modified using
>        stop_machine. However switch to active mask for symmetry with
>        sched_setaffinity()/set_cpus_allowed_ptr(). We guarantee active
>        mask stability by inserting sync_rcu/sched() into _cpu_down.
>     
>      - sched_setaffinity(); we don't appear to need get_online_cpus()
>        either, there's two sites where hotplug appears relevant:
>         * cpuset_cpus_allowed(); for the !cpuset case we use possible_mask,
>           for the cpuset case we hold task_lock, which is a spinlock and
>           thus for mainline disables preemption (might cause pain on RT).
>         * set_cpus_allowed_ptr(); Holds all scheduler locks and thus has
>           preemption properly disabled; also it already deals with hotplug
>           races explicitly where it releases them.
>     
>      - migrate_swap(); we can make stop_two_cpus() do the heavy lifting for
>        us with a little trickery. By adding a sync_sched/rcu() after the
>        CPU_DOWN_PREPARE notifier we can provide preempt/rcu guarantees for
>        cpu_active_mask. Use these to validate that both our cpus are active
>        when queueing the stop work before we queue the stop_machine works
>        for take_cpu_down().
>     
>     Signed-off-by: Peter Zijlstra <peterz@infradead.org>
>     Cc: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
>     Cc: Paul McKenney <paulmck@linux.vnet.ibm.com>
>     Cc: Mel Gorman <mgorman@suse.de>
>     Cc: Rik van Riel <riel@redhat.com>
>     Cc: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
>     Cc: Andrea Arcangeli <aarcange@redhat.com>
>     Cc: Johannes Weiner <hannes@cmpxchg.org>
>     Cc: Linus Torvalds <torvalds@linux-foundation.org>
>     Cc: Andrew Morton <akpm@linux-foundation.org>
>     Cc: Steven Rostedt <rostedt@goodmis.org>
>     Cc: Oleg Nesterov <oleg@redhat.com>
>     Link: http://lkml.kernel.org/r/20131011123820.GV3081@twins.programming.kicks-ass.net
>     Signed-off-by: Ingo Molnar <mingo@kernel.org>
> 
> ===================================================
> PARENT COMMIT NOT CLEAN. LOOK OUT FOR WRONG BISECT!
> ===================================================
> 
> +------------------------------------------------------------------------------------+--------------+--------------+
> |                                                                                    | 746023159c40 | 1918664d0b2b |
> +------------------------------------------------------------------------------------+--------------+--------------+
> | good_boots                                                                         | 594          | 7            |
> | has_kernel_error_warning                                                           | 6            | 12           |
> | BUG:kernel_early_hang_without_any_printk_output                                    | 6            |              |
> | INFO:task_blocked_for_more_than_seconds                                            | 0            | 12           |
> | INFO:NMI_handler(arch_trigger_all_cpu_backtrace_handler)took_too_long_to_run:msecs | 0            | 12           |
> | Kernel_panic-not_syncing:hung_task:blocked_tasks                                   | 0            | 12           |
> +------------------------------------------------------------------------------------+--------------+--------------+
> 
> [   10.410377] EDD information not available.
> [   10.412866] Unregister pv shared memory for cpu 0
> [   10.499606] input: ImExPS/2 Generic Explorer Mouse as /devices/platform/i8042/serio1/input/input3
> [  241.206735] INFO: task swapper/0:1 blocked for more than 120 seconds.
> [  241.209244]       Not tainted 3.12.0-02098-g1918664 #98
> [  241.211290] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
> [  241.214286] swapper/0       D ffff88000ec9e040     0     1      0 0x00000000
> [  241.217142]  ffff88000eca1c10 0000000000000046 ffffffff826aca60 ffff88000ec9e040
> [  241.220200]  ffff88000eca1fd8 0000000000012a00 0000000000012a00 ffff88000c9927c0
> [  241.223196]  ffff88000ec9e040 ffff88000ec9e040 ffff88000eca1b60 0000000000000002
> [  241.226835] Call Trace:
> [  241.227813]  [<ffffffff8110e544>] ? __lock_acquire+0x1e74/0x1ef0
> [  241.230123]  [<ffffffff8110e544>] ? __lock_acquire+0x1e74/0x1ef0
> [  241.232400]  [<ffffffff81d39ea5>] schedule+0x55/0x60
> [  241.234345]  [<ffffffff81d38efb>] schedule_timeout+0x2b/0x200
> [  241.236533]  [<ffffffff8110a88e>] ? mark_held_locks+0x12e/0x150
> [  241.238845]  [<ffffffff81d3e577>] ? _raw_spin_unlock_irq+0x27/0x60
> [  241.241356]  [<ffffffff810f753d>] ? get_parent_ip+0xd/0x50
> [  241.243790]  [<ffffffff810f7603>] ? preempt_count_sub+0x33/0x50
> [  241.246273]  [<ffffffff81d3a9c7>] wait_for_common+0x167/0x1b0
> [  241.248715]  [<ffffffff810f9470>] ? try_to_wake_up+0x330/0x330
> [  241.251291]  [<ffffffff81124df0>] ? __call_rcu.constprop.42+0x3d0/0x3d0
> [  241.254145]  [<ffffffff81d3ab48>] wait_for_completion+0x18/0x20
> [  241.256756]  [<ffffffff8111ed16>] wait_rcu_gp+0x46/0x50
> [  241.259000]  [<ffffffff8111eb30>] ? ftrace_raw_output_rcu_barrier+0x70/0x70
> [  241.262012]  [<ffffffff811263dc>] synchronize_rcu+0x2c/0x30
> [  241.264437]  [<ffffffff81d1bd82>] _cpu_down+0x2b2/0x340
> [  241.266760]  [<ffffffff81d3afea>] ? mutex_lock_nested+0x3da/0x400
> [  241.269311]  [<ffffffff8106c832>] ? cpu_hotplug_driver_lock+0x12/0x20
> [  241.272113]  [<ffffffff81d1bec1>] cpu_down+0x31/0x50
> [  241.274282]  [<ffffffff81d1aaa7>] _debug_hotplug_cpu+0x47/0xb0
> [  241.276853]  [<ffffffff824251f3>] ? pci_iommu_alloc+0x6c/0x6c
> [  241.279183]  [<ffffffff82425200>] debug_hotplug_cpu+0xd/0x11
> [  241.281679]  [<ffffffff8241ce54>] do_one_initcall+0x7e/0x11b
> [  241.284140]  [<ffffffff810e9a1d>] ? parse_args+0x1dd/0x300
> [  241.286665]  [<ffffffff8241cfed>] kernel_init_freeable+0xfc/0x18d
> [  241.289336]  [<ffffffff8241c7ec>] ? do_early_param+0x8a/0x8a
> [  241.291894]  [<ffffffff81d1a8e0>] ? rest_init+0xc0/0xc0
> [  241.294233]  [<ffffffff81d1a8e9>] kernel_init+0x9/0x180
> [  241.296494]  [<ffffffff81d3f9cc>] ret_from_fork+0x7c/0xb0
> [  241.298917]  [<ffffffff81d1a8e0>] ? rest_init+0xc0/0xc0
> [  241.303393] 3 locks held by swapper/0/1:
> [  241.305121]  #0:  (x86_cpu_hotplug_driver_mutex){+.+.+.}, at: [<ffffffff8106c832>] cpu_hotplug_driver_lock+0x12/0x20
> [  241.309967]  #1:  (cpu_add_remove_lock){+.+.+.}, at: [<ffffffff81d1bead>] cpu_down+0x1d/0x50
> [  241.314045]  #2:  (cpu_hotplug.lock){+.+.+.}, at: [<ffffffff810cca86>] cpu_hotplug_begin+0x26/0x60
> [  241.318328] sending NMI to all CPUs:
> [  241.319960] NMI backtrace for cpu 1
> [  241.321503] CPU: 1 PID: 29 Comm: khungtaskd Not tainted 3.12.0-02098-g1918664 #98
> [  241.321618] Hardware name: Bochs Bochs, BIOS Bochs 01/01/2011
> [  241.321618] task: ffff88000cf8e780 ti: ffff88000cf90000 task.ti: ffff88000cf90000
> [  241.321618] RIP: 0010:[<ffffffff8107377d>]  [<ffffffff8107377d>] flat_send_IPI_mask+0x8d/0xd0
> [  241.321618] RSP: 0000:ffff88000cf91db8  EFLAGS: 00010046
> [  241.321618] RAX: 0000000003000000 RBX: 0000000000000002 RCX: 0000000000000007
> [  241.321618] RDX: 0000000000000c00 RSI: 0000000000000001 RDI: 0000000000000300
> [  241.321618] RBP: ffff88000cf91dd8 R08: 0000000000000000 R09: 0000000000000000
> [  241.321618] R10: 0000000000000001 R11: 0000000000000001 R12: 0000000000000246
> [  241.321618] R13: 0000000000000c00 R14: 0000000000000003 R15: 00000000000003ff
> [  241.321618] FS:  0000000000000000(0000) GS:ffff88000f100000(0000) knlGS:0000000000000000
> [  241.321618] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
> [  241.321618] CR2: 00000000ffffffff CR3: 0000000002206000 CR4: 00000000000006a0
> [  241.321618] Stack:
> [  241.321618]  0000000000002710 ffff88000ec9e040 0000000000007fff ffff88000ec9e040
> [  241.321618]  ffff88000cf91de8 ffffffff810737da ffff88000cf91e00 ffffffff81070a3f
> [  241.321618]  0000000000000078 ffff88000cf91e68 ffffffff8113e1a8 ffffffff8113df4b
> [  241.321618] Call Trace:
> [  241.321618]  [<ffffffff810737da>] flat_send_IPI_all+0x1a/0x70
> [  241.321618]  [<ffffffff81070a3f>] arch_trigger_all_cpu_backtrace+0x5f/0xb0
> [  241.321618]  [<ffffffff8113e1a8>] watchdog+0x2d8/0x3d0
> [  241.321618]  [<ffffffff8113df4b>] ? watchdog+0x7b/0x3d0
> [  241.321618]  [<ffffffff8113ded0>] ? hung_task_panic+0x20/0x20
> [  241.321618]  [<ffffffff810eb431>] kthread+0xd1/0xe0
> [  241.321618]  [<ffffffff81d3e577>] ? _raw_spin_unlock_irq+0x27/0x60
> [  241.321618]  [<ffffffff810eb360>] ? __kthread_unpark+0x50/0x50
> [  241.321618]  [<ffffffff81d3f9cc>] ret_from_fork+0x7c/0xb0
> [  241.321618]  [<ffffffff810eb360>] ? __kthread_unpark+0x50/0x50
> [  241.321618] Code: e6 10 75 f2 44 89 f0 c1 e0 18 89 04 25 10 b3 57 ff 89 da 44 09 ea 41 81 cd 00 04 00 00 83 fb 02 41 0f 44 d5 89 14 25 00 b3 57 ff <41> f7 c4 00 02 00 00 75 1a 4c 89 e7 57 9d 0f 1f 44 00 00 e8 8b 
> 
> git bisect start 1918664d0b2b6b2ad6b180e7c04a42872beb6691 d8524ae9d6f492a9c6db9f4d89c5f9b8782fa2d5 --
> git bisect good 4d9218daae2b00379b2bb81eaf4fe5143f372db1  # 11:54     27+      0  Merge tag 'perf-core-for-mingo' of git://git.kernel.org/pub/scm/linux/kernel/git/acme/linux into perf/core
> git bisect good f05ef3f6f78e6b97f5664a8290f1ac0717b1a1b0  # 12:09     27+      2  kvm tools: Switch to using an enum for disk image types
> git bisect good 3784592e0c0f224e399605cfa2d1570f79c0cc29  # 12:17     27+      6  config: fix make kvmconfig
> git bisect  bad 9c028f0df729ba4958fe7b142d8521b66ee154d9  # 12:31      6-      4  Merge branch 'sched/core'
> git bisect good 04bb2f9475054298f0c67a89ca92cade42d3fe5e  # 12:45     50+      0  sched/numa: Adjust scan rate in task_numa_placement
> git bisect good ecf1f014325ba60f4df35edae1a357c67c5d4eb1  # 12:56     50+      3  Merge branch 'core/rcu' into core/locking, to prepare the kernel/locking/ file move
> git bisect  bad 01768b42dc97a67b4fb33a2535c49fc1969880df  # 13:08     21-     18  locking: Move the mutex code to kernel/locking/
> git bisect  bad c2d816443ef305aba8eaf0bf368f4d3d87494f06  # 13:22      4-      7  sched/wait: Introduce prepare_to_wait_event()
> git bisect good ec0ad3d01f99d5e5b56a99a58f7003b99250dc65  # 14:11     50+      9  Merge branch 'core/urgent' into sched/core
> git bisect good 7c3f2ab7b844f1a859afbc3d41925e8a0faba5fa  # 14:50     50+      4  sched/rt: Add missing rmb()
> git bisect  bad 6acce3ef84520537f8a09a12c9ddbe814a584dd2  # 14:55     13-      3  sched: Remove get_online_cpus() usage
> git bisect good 746023159c40c523b08a3bc3d213dac212385895  # 15:33    150+      6  sched: Fix race in migrate_swap_stop()
> git bisect good 746023159c40c523b08a3bc3d213dac212385895  # 16:04    450+      6  sched: Fix race in migrate_swap_stop()
> git bisect  bad 1918664d0b2b6b2ad6b180e7c04a42872beb6691  # 16:04      0-     12  Merge branch 'x86/intel-mid'
> git bisect good 1ae1820bfe3f0964cf4bc3c5628055330e3cc538  # 16:47    450+      0  Revert "sched: Remove get_online_cpus() usage"
> git bisect good 6c86ae2928f9e4cbf0d5844f5fcfd549e3450b8c  # 17:26    450+     63  Merge tag 'ftrace-urgent-3.12-v2' of git://git.kernel.org/pub/scm/linux/kernel/git/rostedt/linux-trace
> git bisect  bad bad570d77024cba808126d68a2072f6f8ce64c27  # 17:37     32-     16  Add linux-next specific files for 20131108
> git bisect  bad 1918664d0b2b6b2ad6b180e7c04a42872beb6691  # 17:37      0-     12  Merge branch 'x86/intel-mid'
> 
> Thanks,
> Fengguang
> 
> 
> 
> _______________________________________________
> LKP mailing list
> LKP@linux.intel.com
> 

