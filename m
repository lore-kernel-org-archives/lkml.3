Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751129Ab3KJKRJ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Nov 2013 05:17:09 -0500
Received: from mga11.intel.com ([192.55.52.93]:26820 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750964Ab3KJKQ7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Nov 2013 05:16:59 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.93,671,1378882800"; 
   d="log'?scan'208";a="425062642"
Date: Sun, 10 Nov 2013 18:16:12 +0800
From: Fengguang Wu <fengguang.wu@intel.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Ingo Molnar <mingo@kernel.org>, linux-kernel@vger.kernel.org,
        Michael wang <wangyun@linux.vnet.ibm.com>
Subject: [sched/get_online_cpus] INFO: task swapper/0:1 blocked for more than
 120 seconds.
Message-ID: <20131110101612.GC21916@localhost>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="CblX+4bnyfN0pR09"
Content-Disposition: inline
User-Agent: Heirloom mailx 12.5 6/20/10
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--CblX+4bnyfN0pR09
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Greetings,

I got the below dmesg and the first bad commit is

commit 6acce3ef84520537f8a09a12c9ddbe814a584dd2
Author: Peter Zijlstra <peterz@infradead.org>
Date:   Fri Oct 11 14:38:20 2013 +0200

    sched: Remove get_online_cpus() usage
    
    Remove get_online_cpus() usage from the scheduler; there's 4 sites that
    use it:
    
     - sched_init_smp(); where its completely superfluous since we're in
       'early' boot and there simply cannot be any hotplugging.
    
     - sched_getaffinity(); we already take a raw spinlock to protect the
       task cpus_allowed mask, this disables preemption and therefore
       also stabilizes cpu_online_mask as that's modified using
       stop_machine. However switch to active mask for symmetry with
       sched_setaffinity()/set_cpus_allowed_ptr(). We guarantee active
       mask stability by inserting sync_rcu/sched() into _cpu_down.
    
     - sched_setaffinity(); we don't appear to need get_online_cpus()
       either, there's two sites where hotplug appears relevant:
        * cpuset_cpus_allowed(); for the !cpuset case we use possible_mask,
          for the cpuset case we hold task_lock, which is a spinlock and
          thus for mainline disables preemption (might cause pain on RT).
        * set_cpus_allowed_ptr(); Holds all scheduler locks and thus has
          preemption properly disabled; also it already deals with hotplug
          races explicitly where it releases them.
    
     - migrate_swap(); we can make stop_two_cpus() do the heavy lifting for
       us with a little trickery. By adding a sync_sched/rcu() after the
       CPU_DOWN_PREPARE notifier we can provide preempt/rcu guarantees for
       cpu_active_mask. Use these to validate that both our cpus are active
       when queueing the stop work before we queue the stop_machine works
       for take_cpu_down().
    
    Signed-off-by: Peter Zijlstra <peterz@infradead.org>
    Cc: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
    Cc: Paul McKenney <paulmck@linux.vnet.ibm.com>
    Cc: Mel Gorman <mgorman@suse.de>
    Cc: Rik van Riel <riel@redhat.com>
    Cc: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
    Cc: Andrea Arcangeli <aarcange@redhat.com>
    Cc: Johannes Weiner <hannes@cmpxchg.org>
    Cc: Linus Torvalds <torvalds@linux-foundation.org>
    Cc: Andrew Morton <akpm@linux-foundation.org>
    Cc: Steven Rostedt <rostedt@goodmis.org>
    Cc: Oleg Nesterov <oleg@redhat.com>
    Link: http://lkml.kernel.org/r/20131011123820.GV3081@twins.programming.kicks-ass.net
    Signed-off-by: Ingo Molnar <mingo@kernel.org>

===================================================
PARENT COMMIT NOT CLEAN. LOOK OUT FOR WRONG BISECT!
===================================================

+------------------------------------------------------------------------------------+--------------+--------------+
|                                                                                    | 746023159c40 | 1918664d0b2b |
+------------------------------------------------------------------------------------+--------------+--------------+
| good_boots                                                                         | 594          | 7            |
| has_kernel_error_warning                                                           | 6            | 12           |
| BUG:kernel_early_hang_without_any_printk_output                                    | 6            |              |
| INFO:task_blocked_for_more_than_seconds                                            | 0            | 12           |
| INFO:NMI_handler(arch_trigger_all_cpu_backtrace_handler)took_too_long_to_run:msecs | 0            | 12           |
| Kernel_panic-not_syncing:hung_task:blocked_tasks                                   | 0            | 12           |
+------------------------------------------------------------------------------------+--------------+--------------+

[   10.410377] EDD information not available.
[   10.412866] Unregister pv shared memory for cpu 0
[   10.499606] input: ImExPS/2 Generic Explorer Mouse as /devices/platform/i8042/serio1/input/input3
[  241.206735] INFO: task swapper/0:1 blocked for more than 120 seconds.
[  241.209244]       Not tainted 3.12.0-02098-g1918664 #98
[  241.211290] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
[  241.214286] swapper/0       D ffff88000ec9e040     0     1      0 0x00000000
[  241.217142]  ffff88000eca1c10 0000000000000046 ffffffff826aca60 ffff88000ec9e040
[  241.220200]  ffff88000eca1fd8 0000000000012a00 0000000000012a00 ffff88000c9927c0
[  241.223196]  ffff88000ec9e040 ffff88000ec9e040 ffff88000eca1b60 0000000000000002
[  241.226835] Call Trace:
[  241.227813]  [<ffffffff8110e544>] ? __lock_acquire+0x1e74/0x1ef0
[  241.230123]  [<ffffffff8110e544>] ? __lock_acquire+0x1e74/0x1ef0
[  241.232400]  [<ffffffff81d39ea5>] schedule+0x55/0x60
[  241.234345]  [<ffffffff81d38efb>] schedule_timeout+0x2b/0x200
[  241.236533]  [<ffffffff8110a88e>] ? mark_held_locks+0x12e/0x150
[  241.238845]  [<ffffffff81d3e577>] ? _raw_spin_unlock_irq+0x27/0x60
[  241.241356]  [<ffffffff810f753d>] ? get_parent_ip+0xd/0x50
[  241.243790]  [<ffffffff810f7603>] ? preempt_count_sub+0x33/0x50
[  241.246273]  [<ffffffff81d3a9c7>] wait_for_common+0x167/0x1b0
[  241.248715]  [<ffffffff810f9470>] ? try_to_wake_up+0x330/0x330
[  241.251291]  [<ffffffff81124df0>] ? __call_rcu.constprop.42+0x3d0/0x3d0
[  241.254145]  [<ffffffff81d3ab48>] wait_for_completion+0x18/0x20
[  241.256756]  [<ffffffff8111ed16>] wait_rcu_gp+0x46/0x50
[  241.259000]  [<ffffffff8111eb30>] ? ftrace_raw_output_rcu_barrier+0x70/0x70
[  241.262012]  [<ffffffff811263dc>] synchronize_rcu+0x2c/0x30
[  241.264437]  [<ffffffff81d1bd82>] _cpu_down+0x2b2/0x340
[  241.266760]  [<ffffffff81d3afea>] ? mutex_lock_nested+0x3da/0x400
[  241.269311]  [<ffffffff8106c832>] ? cpu_hotplug_driver_lock+0x12/0x20
[  241.272113]  [<ffffffff81d1bec1>] cpu_down+0x31/0x50
[  241.274282]  [<ffffffff81d1aaa7>] _debug_hotplug_cpu+0x47/0xb0
[  241.276853]  [<ffffffff824251f3>] ? pci_iommu_alloc+0x6c/0x6c
[  241.279183]  [<ffffffff82425200>] debug_hotplug_cpu+0xd/0x11
[  241.281679]  [<ffffffff8241ce54>] do_one_initcall+0x7e/0x11b
[  241.284140]  [<ffffffff810e9a1d>] ? parse_args+0x1dd/0x300
[  241.286665]  [<ffffffff8241cfed>] kernel_init_freeable+0xfc/0x18d
[  241.289336]  [<ffffffff8241c7ec>] ? do_early_param+0x8a/0x8a
[  241.291894]  [<ffffffff81d1a8e0>] ? rest_init+0xc0/0xc0
[  241.294233]  [<ffffffff81d1a8e9>] kernel_init+0x9/0x180
[  241.296494]  [<ffffffff81d3f9cc>] ret_from_fork+0x7c/0xb0
[  241.298917]  [<ffffffff81d1a8e0>] ? rest_init+0xc0/0xc0
[  241.303393] 3 locks held by swapper/0/1:
[  241.305121]  #0:  (x86_cpu_hotplug_driver_mutex){+.+.+.}, at: [<ffffffff8106c832>] cpu_hotplug_driver_lock+0x12/0x20
[  241.309967]  #1:  (cpu_add_remove_lock){+.+.+.}, at: [<ffffffff81d1bead>] cpu_down+0x1d/0x50
[  241.314045]  #2:  (cpu_hotplug.lock){+.+.+.}, at: [<ffffffff810cca86>] cpu_hotplug_begin+0x26/0x60
[  241.318328] sending NMI to all CPUs:
[  241.319960] NMI backtrace for cpu 1
[  241.321503] CPU: 1 PID: 29 Comm: khungtaskd Not tainted 3.12.0-02098-g1918664 #98
[  241.321618] Hardware name: Bochs Bochs, BIOS Bochs 01/01/2011
[  241.321618] task: ffff88000cf8e780 ti: ffff88000cf90000 task.ti: ffff88000cf90000
[  241.321618] RIP: 0010:[<ffffffff8107377d>]  [<ffffffff8107377d>] flat_send_IPI_mask+0x8d/0xd0
[  241.321618] RSP: 0000:ffff88000cf91db8  EFLAGS: 00010046
[  241.321618] RAX: 0000000003000000 RBX: 0000000000000002 RCX: 0000000000000007
[  241.321618] RDX: 0000000000000c00 RSI: 0000000000000001 RDI: 0000000000000300
[  241.321618] RBP: ffff88000cf91dd8 R08: 0000000000000000 R09: 0000000000000000
[  241.321618] R10: 0000000000000001 R11: 0000000000000001 R12: 0000000000000246
[  241.321618] R13: 0000000000000c00 R14: 0000000000000003 R15: 00000000000003ff
[  241.321618] FS:  0000000000000000(0000) GS:ffff88000f100000(0000) knlGS:0000000000000000
[  241.321618] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[  241.321618] CR2: 00000000ffffffff CR3: 0000000002206000 CR4: 00000000000006a0
[  241.321618] Stack:
[  241.321618]  0000000000002710 ffff88000ec9e040 0000000000007fff ffff88000ec9e040
[  241.321618]  ffff88000cf91de8 ffffffff810737da ffff88000cf91e00 ffffffff81070a3f
[  241.321618]  0000000000000078 ffff88000cf91e68 ffffffff8113e1a8 ffffffff8113df4b
[  241.321618] Call Trace:
[  241.321618]  [<ffffffff810737da>] flat_send_IPI_all+0x1a/0x70
[  241.321618]  [<ffffffff81070a3f>] arch_trigger_all_cpu_backtrace+0x5f/0xb0
[  241.321618]  [<ffffffff8113e1a8>] watchdog+0x2d8/0x3d0
[  241.321618]  [<ffffffff8113df4b>] ? watchdog+0x7b/0x3d0
[  241.321618]  [<ffffffff8113ded0>] ? hung_task_panic+0x20/0x20
[  241.321618]  [<ffffffff810eb431>] kthread+0xd1/0xe0
[  241.321618]  [<ffffffff81d3e577>] ? _raw_spin_unlock_irq+0x27/0x60
[  241.321618]  [<ffffffff810eb360>] ? __kthread_unpark+0x50/0x50
[  241.321618]  [<ffffffff81d3f9cc>] ret_from_fork+0x7c/0xb0
[  241.321618]  [<ffffffff810eb360>] ? __kthread_unpark+0x50/0x50
[  241.321618] Code: e6 10 75 f2 44 89 f0 c1 e0 18 89 04 25 10 b3 57 ff 89 da 44 09 ea 41 81 cd 00 04 00 00 83 fb 02 41 0f 44 d5 89 14 25 00 b3 57 ff <41> f7 c4 00 02 00 00 75 1a 4c 89 e7 57 9d 0f 1f 44 00 00 e8 8b 

git bisect start 1918664d0b2b6b2ad6b180e7c04a42872beb6691 d8524ae9d6f492a9c6db9f4d89c5f9b8782fa2d5 --
git bisect good 4d9218daae2b00379b2bb81eaf4fe5143f372db1  # 11:54     27+      0  Merge tag 'perf-core-for-mingo' of git://git.kernel.org/pub/scm/linux/kernel/git/acme/linux into perf/core
git bisect good f05ef3f6f78e6b97f5664a8290f1ac0717b1a1b0  # 12:09     27+      2  kvm tools: Switch to using an enum for disk image types
git bisect good 3784592e0c0f224e399605cfa2d1570f79c0cc29  # 12:17     27+      6  config: fix make kvmconfig
git bisect  bad 9c028f0df729ba4958fe7b142d8521b66ee154d9  # 12:31      6-      4  Merge branch 'sched/core'
git bisect good 04bb2f9475054298f0c67a89ca92cade42d3fe5e  # 12:45     50+      0  sched/numa: Adjust scan rate in task_numa_placement
git bisect good ecf1f014325ba60f4df35edae1a357c67c5d4eb1  # 12:56     50+      3  Merge branch 'core/rcu' into core/locking, to prepare the kernel/locking/ file move
git bisect  bad 01768b42dc97a67b4fb33a2535c49fc1969880df  # 13:08     21-     18  locking: Move the mutex code to kernel/locking/
git bisect  bad c2d816443ef305aba8eaf0bf368f4d3d87494f06  # 13:22      4-      7  sched/wait: Introduce prepare_to_wait_event()
git bisect good ec0ad3d01f99d5e5b56a99a58f7003b99250dc65  # 14:11     50+      9  Merge branch 'core/urgent' into sched/core
git bisect good 7c3f2ab7b844f1a859afbc3d41925e8a0faba5fa  # 14:50     50+      4  sched/rt: Add missing rmb()
git bisect  bad 6acce3ef84520537f8a09a12c9ddbe814a584dd2  # 14:55     13-      3  sched: Remove get_online_cpus() usage
git bisect good 746023159c40c523b08a3bc3d213dac212385895  # 15:33    150+      6  sched: Fix race in migrate_swap_stop()
git bisect good 746023159c40c523b08a3bc3d213dac212385895  # 16:04    450+      6  sched: Fix race in migrate_swap_stop()
git bisect  bad 1918664d0b2b6b2ad6b180e7c04a42872beb6691  # 16:04      0-     12  Merge branch 'x86/intel-mid'
git bisect good 1ae1820bfe3f0964cf4bc3c5628055330e3cc538  # 16:47    450+      0  Revert "sched: Remove get_online_cpus() usage"
git bisect good 6c86ae2928f9e4cbf0d5844f5fcfd549e3450b8c  # 17:26    450+     63  Merge tag 'ftrace-urgent-3.12-v2' of git://git.kernel.org/pub/scm/linux/kernel/git/rostedt/linux-trace
git bisect  bad bad570d77024cba808126d68a2072f6f8ce64c27  # 17:37     32-     16  Add linux-next specific files for 20131108
git bisect  bad 1918664d0b2b6b2ad6b180e7c04a42872beb6691  # 17:37      0-     12  Merge branch 'x86/intel-mid'

Thanks,
Fengguang

--CblX+4bnyfN0pR09
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="dmesg-yocto-jaketown-20:20131108223032:x86_64-randconfig-x4-1108:3.12.0-02098-g1918664:98"
Content-Transfer-Encoding: quoted-printable

[    0.000000] Initializing cgroup subsys cpu
[    0.000000] Linux version 3.12.0-02098-g1918664 (kbuild@xian) (gcc versi=
on 4.8.1 (Debian 4.8.1-8) ) #98 SMP PREEMPT Fri Nov 8 22:25:22 CST 2013
[    0.000000] Command line: hung_task_panic=3D1 rcutree.rcu_cpu_stall_time=
out=3D100 log_buf_len=3D8M ignore_loglevel debug sched_debug apic=3Ddebug d=
ynamic_printk sysrq_always_enabled panic=3D10  prompt_ramdisk=3D0 console=
=3DttyS0,115200 console=3Dtty0 vga=3Dnormal  root=3D/dev/ram0 rw link=3D/ke=
rnel-tests/run-queue/kvm/x86_64-randconfig-x4-1108/tip:master/.vmlinuz-1918=
664d0b2b6b2ad6b180e7c04a42872beb6691-20131108222605-7-jaketown branch=3Dtip=
/master BOOT_IMAGE=3D/kernel/x86_64-randconfig-x4-1108/1918664d0b2b6b2ad6b1=
80e7c04a42872beb6691/vmlinuz-3.12.0-02098-g1918664
[    0.000000] e820: BIOS-provided physical RAM map:
[    0.000000] BIOS-e820: [mem 0x0000000000000000-0x000000000009fbff] usable
[    0.000000] BIOS-e820: [mem 0x000000000009fc00-0x000000000009ffff] reser=
ved
[    0.000000] BIOS-e820: [mem 0x00000000000f0000-0x00000000000fffff] reser=
ved
[    0.000000] BIOS-e820: [mem 0x0000000000100000-0x000000000fffdfff] usable
[    0.000000] BIOS-e820: [mem 0x000000000fffe000-0x000000000fffffff] reser=
ved
[    0.000000] BIOS-e820: [mem 0x00000000feffc000-0x00000000feffffff] reser=
ved
[    0.000000] BIOS-e820: [mem 0x00000000fffc0000-0x00000000ffffffff] reser=
ved
[    0.000000] debug: ignoring loglevel setting.
[    0.000000] NX (Execute Disable) protection: active
[    0.000000] SMBIOS 2.4 present.
[    0.000000] DMI: Bochs Bochs, BIOS Bochs 01/01/2011
[    0.000000] Hypervisor detected: KVM
[    0.000000] e820: update [mem 0x00000000-0x00000fff] usable =3D=3D> rese=
rved
[    0.000000] e820: remove [mem 0x000a0000-0x000fffff] usable
[    0.000000] e820: last_pfn =3D 0xfffe max_arch_pfn =3D 0x400000000
[    0.000000] MTRR default type: write-back
[    0.000000] MTRR fixed ranges enabled:
[    0.000000]   00000-9FFFF write-back
[    0.000000]   A0000-BFFFF uncachable
[    0.000000]   C0000-FFFFF write-protect
[    0.000000] MTRR variable ranges enabled:
[    0.000000]   0 base 0080000000 mask FF80000000 uncachable
[    0.000000]   1 disabled
[    0.000000]   2 disabled
[    0.000000]   3 disabled
[    0.000000]   4 disabled
[    0.000000]   5 disabled
[    0.000000]   6 disabled
[    0.000000]   7 disabled
[    0.000000] x86 PAT enabled: cpu 0, old 0x70406, new 0x7010600070106
[    0.000000] Base memory trampoline at [ffff880000099000] 99000 size 24576
[    0.000000] init_memory_mapping: [mem 0x00000000-0x000fffff]
[    0.000000]  [mem 0x00000000-0x000fffff] page 4k
[    0.000000] BRK [0x02e99000, 0x02e99fff] PGTABLE
[    0.000000] BRK [0x02e9a000, 0x02e9afff] PGTABLE
[    0.000000] BRK [0x02e9b000, 0x02e9bfff] PGTABLE
[    0.000000] init_memory_mapping: [mem 0x0fa00000-0x0fbfffff]
[    0.000000]  [mem 0x0fa00000-0x0fbfffff] page 2M
[    0.000000] init_memory_mapping: [mem 0x0c000000-0x0f9fffff]
[    0.000000]  [mem 0x0c000000-0x0f9fffff] page 2M
[    0.000000] init_memory_mapping: [mem 0x00100000-0x0bffffff]
[    0.000000]  [mem 0x00100000-0x001fffff] page 4k
[    0.000000]  [mem 0x00200000-0x0bffffff] page 2M
[    0.000000] init_memory_mapping: [mem 0x0fc00000-0x0fffdfff]
[    0.000000]  [mem 0x0fc00000-0x0fdfffff] page 2M
[    0.000000]  [mem 0x0fe00000-0x0fffdfff] page 4k
[    0.000000] BRK [0x02e9c000, 0x02e9cfff] PGTABLE
[    0.000000] log_buf_len: 8388608
[    0.000000] early log buf free: 127696(97%)
[    0.000000] RAMDISK: [mem 0x0fd0b000-0x0ffeffff]
[    0.000000] ACPI: RSDP 00000000000fd950 00014 (v00 BOCHS )
[    0.000000] ACPI: RSDT 000000000fffe450 00034 (v01 BOCHS  BXPCRSDT 00000=
001 BXPC 00000001)
[    0.000000] ACPI: FACP 000000000fffff80 00074 (v01 BOCHS  BXPCFACP 00000=
001 BXPC 00000001)
[    0.000000] ACPI: DSDT 000000000fffe490 011A9 (v01   BXPC   BXDSDT 00000=
001 INTL 20100528)
[    0.000000] ACPI: FACS 000000000fffff40 00040
[    0.000000] ACPI: SSDT 000000000ffff7a0 00796 (v01 BOCHS  BXPCSSDT 00000=
001 BXPC 00000001)
[    0.000000] ACPI: APIC 000000000ffff680 00080 (v01 BOCHS  BXPCAPIC 00000=
001 BXPC 00000001)
[    0.000000] ACPI: HPET 000000000ffff640 00038 (v01 BOCHS  BXPCHPET 00000=
001 BXPC 00000001)
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] mapped APIC to ffffffffff57b000 (        fee00000)
[    0.000000] kvm-clock: Using msrs 4b564d01 and 4b564d00
[    0.000000] kvm-clock: cpu 0, msr 0:f48b001, boot clock
[    0.000000]  [ffffea0000000000-ffffea00003fffff] PMD -> [ffff88000e80000=
0-ffff88000ebfffff] on node 0
[    0.000000] Zone ranges:
[    0.000000]   DMA      [mem 0x00001000-0x00ffffff]
[    0.000000]   DMA32    [mem 0x01000000-0xffffffff]
[    0.000000]   Normal   empty
[    0.000000] Movable zone start for each node
[    0.000000] Early memory node ranges
[    0.000000]   node   0: [mem 0x00001000-0x0009efff]
[    0.000000]   node   0: [mem 0x00100000-0x0fffdfff]
[    0.000000] On node 0 totalpages: 65436
[    0.000000]   DMA zone: 56 pages used for memmap
[    0.000000]   DMA zone: 21 pages reserved
[    0.000000]   DMA zone: 3998 pages, LIFO batch:0
[    0.000000]   DMA32 zone: 840 pages used for memmap
[    0.000000]   DMA32 zone: 61438 pages, LIFO batch:15
[    0.000000] ACPI: PM-Timer IO Port: 0xb008
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] mapped APIC to ffffffffff57b000 (        fee00000)
[    0.000000] ACPI: LAPIC (acpi_id[0x00] lapic_id[0x00] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x01] lapic_id[0x01] enabled)
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0xff] dfl dfl lint[0x1])
[    0.000000] ACPI: IOAPIC (id[0x00] address[0xfec00000] gsi_base[0])
[    0.000000] IOAPIC[0]: apic_id 0, version 17, address 0xfec00000, GSI 0-=
23
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 00, APIC ID 0, APIC =
INT 02
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 5 global_irq 5 high level)
[    0.000000] Int: type 0, pol 1, trig 3, bus 00, IRQ 05, APIC ID 0, APIC =
INT 05
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 high level)
[    0.000000] Int: type 0, pol 1, trig 3, bus 00, IRQ 09, APIC ID 0, APIC =
INT 09
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 10 global_irq 10 high level)
[    0.000000] Int: type 0, pol 1, trig 3, bus 00, IRQ 0a, APIC ID 0, APIC =
INT 0a
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 11 global_irq 11 high level)
[    0.000000] Int: type 0, pol 1, trig 3, bus 00, IRQ 0b, APIC ID 0, APIC =
INT 0b
[    0.000000] ACPI: IRQ0 used by override.
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 01, APIC ID 0, APIC =
INT 01
[    0.000000] ACPI: IRQ2 used by override.
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 03, APIC ID 0, APIC =
INT 03
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 04, APIC ID 0, APIC =
INT 04
[    0.000000] ACPI: IRQ5 used by override.
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 06, APIC ID 0, APIC =
INT 06
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 07, APIC ID 0, APIC =
INT 07
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 08, APIC ID 0, APIC =
INT 08
[    0.000000] ACPI: IRQ9 used by override.
[    0.000000] ACPI: IRQ10 used by override.
[    0.000000] ACPI: IRQ11 used by override.
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 0c, APIC ID 0, APIC =
INT 0c
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 0d, APIC ID 0, APIC =
INT 0d
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 0e, APIC ID 0, APIC =
INT 0e
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 0f, APIC ID 0, APIC =
INT 0f
[    0.000000] Using ACPI (MADT) for SMP configuration information
[    0.000000] ACPI: HPET id: 0x8086a201 base: 0xfed00000
[    0.000000] smpboot: Allowing 2 CPUs, 0 hotplug CPUs
[    0.000000] mapped IOAPIC to ffffffffff57a000 (fec00000)
[    0.000000] nr_irqs_gsi: 40
[    0.000000] e820: [mem 0x10000000-0xfeffbfff] available for PCI devices
[    0.000000] Booting paravirtualized kernel on KVM
[    0.000000] setup_percpu: NR_CPUS:8192 nr_cpumask_bits:2 nr_cpu_ids:2 nr=
_node_ids:1
[    0.000000] PERCPU: Embedded 25 pages/cpu @ffff88000f000000 s79496 r0 d2=
2904 u1048576
[    0.000000] pcpu-alloc: s79496 r0 d22904 u1048576 alloc=3D1*2097152
[    0.000000] pcpu-alloc: [0] 0 1=20
[    0.000000] kvm-clock: cpu 0, msr 0:f48b001, primary cpu clock
[    0.000000] KVM setup async PF for cpu 0
[    0.000000] kvm-stealtime: cpu 0, msr f00cb80
[    0.000000] Built 1 zonelists in Zone order, mobility grouping on.  Tota=
l pages: 64519
[    0.000000] Kernel command line: hung_task_panic=3D1 rcutree.rcu_cpu_sta=
ll_timeout=3D100 log_buf_len=3D8M ignore_loglevel debug sched_debug apic=3D=
debug dynamic_printk sysrq_always_enabled panic=3D10  prompt_ramdisk=3D0 co=
nsole=3DttyS0,115200 console=3Dtty0 vga=3Dnormal  root=3D/dev/ram0 rw link=
=3D/kernel-tests/run-queue/kvm/x86_64-randconfig-x4-1108/tip:master/.vmlinu=
z-1918664d0b2b6b2ad6b180e7c04a42872beb6691-20131108222605-7-jaketown branch=
=3Dtip/master BOOT_IMAGE=3D/kernel/x86_64-randconfig-x4-1108/1918664d0b2b6b=
2ad6b180e7c04a42872beb6691/vmlinuz-3.12.0-02098-g1918664
[    0.000000] PID hash table entries: 1024 (order: 1, 8192 bytes)
[    0.000000] Dentry cache hash table entries: 32768 (order: 6, 262144 byt=
es)
[    0.000000] Inode-cache hash table entries: 16384 (order: 5, 131072 byte=
s)
[    0.000000] Memory: 213348K/261744K available (13579K kernel code, 2099K=
 rwdata, 4820K rodata, 1168K init, 9608K bss, 48396K reserved)
[    0.000000] Preemptible hierarchical RCU implementation.
[    0.000000]=20
[    0.000000]=20
[    0.000000]=20
[    0.000000]=20
[    0.000000] NR_IRQS:524544 nr_irqs:56 16
[    0.000000] console [ttyS0] enabled
[    0.000000] Lock dependency validator: Copyright (c) 2006 Red Hat, Inc.,=
 Ingo Molnar
[    0.000000] ... MAX_LOCKDEP_SUBCLASSES:  8
[    0.000000] ... MAX_LOCK_DEPTH:          48
[    0.000000] ... MAX_LOCKDEP_KEYS:        8191
[    0.000000] ... CLASSHASH_SIZE:          4096
[    0.000000] ... MAX_LOCKDEP_ENTRIES:     16384
[    0.000000] ... MAX_LOCKDEP_CHAINS:      32768
[    0.000000] ... CHAINHASH_SIZE:          16384
[    0.000000]  memory used by lock dependency info: 5855 kB
[    0.000000]  per task-struct memory footprint: 1920 bytes
[    0.000000] hpet clockevent registered
[    0.000000] tsc: Detected 1600.055 MHz processor
[    0.009999] Calibrating delay loop (skipped) preset value.. 3201.44 Bogo=
MIPS (lpj=3D5333516)
[    0.013361] pid_max: default: 4096 minimum: 301
[    0.016910] Mount-cache hash table entries: 256
[    0.020474] Last level iTLB entries: 4KB 0, 2MB 0, 4MB 0
[    0.020474] Last level dTLB entries: 4KB 0, 2MB 0, 4MB 0
[    0.020474] tlb_flushall_shift: 6
[    0.023812] Freeing SMP alternatives memory: 40K (ffffffff8252c000 - fff=
fffff82536000)
[    0.042723] ACPI: Core revision 20130725
[    0.053234] ACPI: All ACPI Tables successfully acquired
[    0.056738] Getting VERSION: 50014
[    0.058316] Getting VERSION: 50014
[    0.059889] Getting ID: 0
[    0.060056] Getting ID: ff000000
[    0.061677] Getting LVT0: 8700
[    0.063372] Getting LVT1: 8400
[    0.065146] enabled ExtINT on CPU#0
[    0.072109] ENABLING IO-APIC IRQs
[    0.073372] init IO_APIC IRQs
[    0.074873]  apic 0 pin 0 not connected
[    0.076786] IOAPIC[0]: Set routing entry (0-1 -> 0x31 -> IRQ 1 Mode:0 Ac=
tive:0 Dest:1)
[    0.080106] IOAPIC[0]: Set routing entry (0-2 -> 0x30 -> IRQ 0 Mode:0 Ac=
tive:0 Dest:1)
[    0.083435] IOAPIC[0]: Set routing entry (0-3 -> 0x33 -> IRQ 3 Mode:0 Ac=
tive:0 Dest:1)
[    0.086763] IOAPIC[0]: Set routing entry (0-4 -> 0x34 -> IRQ 4 Mode:0 Ac=
tive:0 Dest:1)
[    0.090093] IOAPIC[0]: Set routing entry (0-5 -> 0x35 -> IRQ 5 Mode:1 Ac=
tive:0 Dest:1)
[    0.093426] IOAPIC[0]: Set routing entry (0-6 -> 0x36 -> IRQ 6 Mode:0 Ac=
tive:0 Dest:1)
[    0.096777] IOAPIC[0]: Set routing entry (0-7 -> 0x37 -> IRQ 7 Mode:0 Ac=
tive:0 Dest:1)
[    0.100112] IOAPIC[0]: Set routing entry (0-8 -> 0x38 -> IRQ 8 Mode:0 Ac=
tive:0 Dest:1)
[    0.103428] IOAPIC[0]: Set routing entry (0-9 -> 0x39 -> IRQ 9 Mode:1 Ac=
tive:0 Dest:1)
[    0.106760] IOAPIC[0]: Set routing entry (0-10 -> 0x3a -> IRQ 10 Mode:1 =
Active:0 Dest:1)
[    0.110092] IOAPIC[0]: Set routing entry (0-11 -> 0x3b -> IRQ 11 Mode:1 =
Active:0 Dest:1)
[    0.113429] IOAPIC[0]: Set routing entry (0-12 -> 0x3c -> IRQ 12 Mode:0 =
Active:0 Dest:1)
[    0.116760] IOAPIC[0]: Set routing entry (0-13 -> 0x3d -> IRQ 13 Mode:0 =
Active:0 Dest:1)
[    0.120118] IOAPIC[0]: Set routing entry (0-14 -> 0x3e -> IRQ 14 Mode:0 =
Active:0 Dest:1)
[    0.123429] IOAPIC[0]: Set routing entry (0-15 -> 0x3f -> IRQ 15 Mode:0 =
Active:0 Dest:1)
[    0.126747]  apic 0 pin 16 not connected
[    0.128643]  apic 0 pin 17 not connected
[    0.130018]  apic 0 pin 18 not connected
[    0.131913]  apic 0 pin 19 not connected
[    0.133351]  apic 0 pin 20 not connected
[    0.136685]  apic 0 pin 21 not connected
[    0.140018]  apic 0 pin 22 not connected
[    0.141899]  apic 0 pin 23 not connected
[    0.143581] ..TIMER: vector=3D0x30 apic1=3D0 pin1=3D2 apic2=3D-1 pin2=3D=
-1
[    0.146683] smpboot: CPU0: Intel Common KVM processor (fam: 0f, model: 0=
6, stepping: 01)
[    0.154346] Using local APIC timer interrupts.
[    0.154346] calibrating APIC timer ...
[    0.159999] ... lapic delta =3D 6249471
[    0.159999] ... PM-Timer delta =3D 357947
[    0.159999] ... PM-Timer result ok
[    0.159999] ..... delta 6249471
[    0.159999] ..... mult: 268412762
[    0.159999] ..... calibration result: 3333051
[    0.159999] ..... CPU clock speed is 1600.0279 MHz.
[    0.159999] ..... host bus clock speed is 1000.0051 MHz.
[    0.160277] Performance Events: unsupported Netburst CPU model 6 no PMU =
driver, software events only.
[    0.183456] ftrace: Allocated trace_printk buffers
[    0.196853] x86: Booting SMP configuration:
[    0.200038] .... node  #0, CPUs:      #1
[    0.187780] kvm-clock: cpu 1, msr 0:f48b041, secondary cpu clock
[    0.187780] masked ExtINT on CPU#1

[    0.223487] KVM setup async PF for cpu 1
[    0.223633] x86: Booted up 1 node, 2 CPUs
[    0.223650] ----------------
[    0.223652] | NMI testsuite:
[    0.223653] --------------------
[    0.223487] kvm-stealtime: cpu 1, msr f10cb80
[    0.223655]   remote IPI:  ok  |
[    0.238470]    local IPI:  ok  |
[    0.260068] --------------------
[    0.261676] Good, all   2 testcases passed! |
[    0.263349] ---------------------------------
[    0.265448] smpboot: Total of 2 processors activated (6402.89 BogoMIPS)
[    0.282075] pinctrl core: initialized pinctrl subsystem
[    0.284300] regulator-dummy: no parameters
[    0.287485] NET: Registered protocol family 16
[    0.292095] ACPI: bus type PCI registered
[    0.293431] dca service started, version 1.12.1
[    0.296790] PCI: Using configuration type 1 for base access
[    0.301487] bio: create slab <bio-0> at 0
[    0.304842] ACPI: Added _OSI(Module Device)
[    0.306684] ACPI: Added _OSI(Processor Device)
[    0.308736] ACPI: Added _OSI(3.0 _SCP Extensions)
[    0.310019] ACPI: Added _OSI(Processor Aggregator Device)
[    0.319693] ACPI: EC: Look up EC in DSDT
[    0.339287] ACPI: Interpreter enabled
[    0.340031] ACPI Exception: AE_NOT_FOUND, While evaluating Sleep State [=
\_S1_] (20130725/hwxface-571)
[    0.344396] ACPI Exception: AE_NOT_FOUND, While evaluating Sleep State [=
\_S2_] (20130725/hwxface-571)
[    0.349295] ACPI: (supports S0 S3 S5)
[    0.350015] ACPI: Using IOAPIC for interrupt routing
[    0.353435] PCI: Using host bridge windows from ACPI; if necessary, use =
"pci=3Dnocrs" and report a bug
[    0.394223] ACPI: PCI Root Bridge [PCI0] (domain 0000 [bus 00-ff])
[    0.396707] acpi PNP0A03:00: Unable to request _OSC control (_OSC suppor=
t mask: 0x08)
[    0.401701] PCI host bridge to bus 0000:00
[    0.403358] pci_bus 0000:00: root bus resource [bus 00-ff]
[    0.406707] pci_bus 0000:00: root bus resource [io  0x0000-0x0cf7]
[    0.409464] pci_bus 0000:00: root bus resource [io  0x0d00-0xffff]
[    0.410024] pci_bus 0000:00: root bus resource [mem 0x000a0000-0x000bfff=
f]
[    0.413354] pci_bus 0000:00: root bus resource [mem 0x80000000-0xfebffff=
f]
[    0.416961] pci 0000:00:00.0: [8086:1237] type 00 class 0x060000
[    0.424045] pci 0000:00:01.0: [8086:7000] type 00 class 0x060100
[    0.429429] pci 0000:00:01.1: [8086:7010] type 00 class 0x010180
[    0.440961] pci 0000:00:01.1: reg 0x20: [io  0xc040-0xc04f]
[    0.448953] pci 0000:00:01.3: [8086:7113] type 00 class 0x068000
[    0.453596] pci 0000:00:01.3: quirk: [io  0xb000-0xb03f] claimed by PIIX=
4 ACPI
[    0.456727] pci 0000:00:01.3: quirk: [io  0xb100-0xb10f] claimed by PIIX=
4 SMB
[    0.461520] pci 0000:00:02.0: [1013:00b8] type 00 class 0x030000
[    0.468683] pci 0000:00:02.0: reg 0x10: [mem 0xfc000000-0xfdffffff pref]
[    0.475356] pci 0000:00:02.0: reg 0x14: [mem 0xfebf0000-0xfebf0fff]
[    0.498687] pci 0000:00:02.0: reg 0x30: [mem 0xfebe0000-0xfebeffff pref]
[    0.503353] pci 0000:00:03.0: [8086:100e] type 00 class 0x020000
[    0.508389] pci 0000:00:03.0: reg 0x10: [mem 0xfeba0000-0xfebbffff]
[    0.515100] pci 0000:00:03.0: reg 0x14: [io  0xc000-0xc03f]
[    0.535050] pci 0000:00:03.0: reg 0x30: [mem 0xfebc0000-0xfebdffff pref]
[    0.538028] pci 0000:00:04.0: [8086:25ab] type 00 class 0x088000
[    0.544298] pci 0000:00:04.0: reg 0x10: [mem 0xfebf1000-0xfebf100f]
[    0.560017] pci_bus 0000:00: on NUMA node 0
[    0.566101] ACPI: PCI Interrupt Link [LNKA] (IRQs 5 *10 11)
[    0.570031] ACPI: PCI Interrupt Link [LNKB] (IRQs 5 *10 11)
[    0.574231] ACPI: PCI Interrupt Link [LNKC] (IRQs 5 10 *11)
[    0.578361] ACPI: PCI Interrupt Link [LNKD] (IRQs 5 10 *11)
[    0.581343] ACPI: PCI Interrupt Link [LNKS] (IRQs *9)
[    0.587634] ACPI: Enabled 16 GPEs in block 00 to 0F
[    0.590044] ACPI: \_SB_.PCI0: notify handler is installed
[    0.592901] Found 1 acpi root devices
[    0.594354] vgaarb: device added: PCI:0000:00:02.0,decodes=3Dio+mem,owns=
=3Dio+mem,locks=3Dnone
[    0.596688] vgaarb: loaded
[    0.600014] vgaarb: bridge control possible 0000:00:02.0
[    0.604345] SCSI subsystem initialized
[    0.606130] ACPI: bus type USB registered
[    0.606745] usbcore: registered new interface driver usbfs
[    0.610046] usbcore: registered new interface driver hub
[    0.613441] usbcore: registered new device driver usb
[    0.616881] pps_core: LinuxPPS API ver. 1 registered
[    0.619199] pps_core: Software ver. 5.3.6 - Copyright 2005-2007 Rodolfo =
Giometti <giometti@linux.it>
[    0.620038] PTP clock support registered
[    0.622012] wmi: Mapper loaded
[    0.623602] PCI: Using ACPI for IRQ routing
[    0.625553] PCI: pci_cache_line_size set to 64 bytes
[    0.627143] e820: reserve RAM buffer [mem 0x0009fc00-0x0009ffff]
[    0.630029] e820: reserve RAM buffer [mem 0x0fffe000-0x0fffffff]
[    0.633938] Bluetooth: Core ver 2.16
[    0.636731] NET: Registered protocol family 31
[    0.638797] Bluetooth: HCI device and connection manager initialized
[    0.640057] Bluetooth: HCI socket layer initialized
[    0.643351] Bluetooth: L2CAP socket layer initialized
[    0.646751] Bluetooth: SCO socket layer initialized
[    0.649100] NET: Registered protocol family 8
[    0.650015] NET: Registered protocol family 20
[    0.653516] nfc: nfc_init: NFC Core ver 0.1
[    0.655670] NET: Registered protocol family 39
[    0.657640] hpet0: at MMIO 0xfed00000, IRQs 2, 8, 0
[    0.660712] hpet0: 3 comparators, 64-bit 100.000000 MHz counter
[    0.670252] Switched to clocksource kvm-clock
[    0.740735] FS-Cache: Loaded
[    0.742227] pnp: PnP ACPI init
[    0.743800] ACPI: bus type PNP registered
[    0.745880] IOAPIC[0]: Set routing entry (0-8 -> 0x38 -> IRQ 8 Mode:0 Ac=
tive:0 Dest:3)
[    0.749794] pnp 00:00: Plug and Play ACPI device, IDs PNP0b00 (active)
[    0.753029] IOAPIC[0]: Set routing entry (0-1 -> 0x31 -> IRQ 1 Mode:0 Ac=
tive:0 Dest:3)
[    0.756902] pnp 00:01: Plug and Play ACPI device, IDs PNP0303 (active)
[    0.759997] IOAPIC[0]: Set routing entry (0-12 -> 0x3c -> IRQ 12 Mode:0 =
Active:0 Dest:3)
[    0.763884] pnp 00:02: Plug and Play ACPI device, IDs PNP0f13 (active)
[    0.767148] IOAPIC[0]: Set routing entry (0-6 -> 0x36 -> IRQ 6 Mode:0 Ac=
tive:0 Dest:3)
[    0.770892] pnp 00:03: [dma 2]
[    0.772399] pnp 00:03: Plug and Play ACPI device, IDs PNP0700 (active)
[    0.775719] IOAPIC[0]: Set routing entry (0-7 -> 0x37 -> IRQ 7 Mode:0 Ac=
tive:0 Dest:3)
[    0.779505] pnp 00:04: Plug and Play ACPI device, IDs PNP0400 (active)
[    0.782825] IOAPIC[0]: Set routing entry (0-4 -> 0x34 -> IRQ 4 Mode:0 Ac=
tive:0 Dest:3)
[    0.786663] pnp 00:05: Plug and Play ACPI device, IDs PNP0501 (active)
[    0.790981] pnp 00:06: Plug and Play ACPI device, IDs PNP0103 (active)
[    0.794930] pnp: PnP ACPI: found 7 devices
[    0.796885] ACPI: bus type PNP unregistered
[    0.804697] pci_bus 0000:00: resource 4 [io  0x0000-0x0cf7]
[    0.807354] pci_bus 0000:00: resource 5 [io  0x0d00-0xffff]
[    0.809843] pci_bus 0000:00: resource 6 [mem 0x000a0000-0x000bffff]
[    0.812730] pci_bus 0000:00: resource 7 [mem 0x80000000-0xfebfffff]
[    0.816284] NET: Registered protocol family 2
[    0.820289] TCP established hash table entries: 2048 (order: 3, 32768 by=
tes)
[    0.823583] TCP bind hash table entries: 2048 (order: 5, 131072 bytes)
[    0.827033] TCP: Hash tables configured (established 2048 bind 2048)
[    0.830156] TCP: reno registered
[    0.831707] UDP hash table entries: 128 (order: 2, 20480 bytes)
[    0.834543] UDP-Lite hash table entries: 128 (order: 2, 20480 bytes)
[    0.838275] NET: Registered protocol family 1
[    0.842273] RPC: Registered named UNIX socket transport module.
[    0.845103] RPC: Registered udp transport module.
[    0.847292] RPC: Registered tcp transport module.
[    0.849353] RPC: Registered tcp NFSv4.1 backchannel transport module.
[    0.852269] pci 0000:00:00.0: Limiting direct PCI/PCI transfers
[    0.855103] pci 0000:00:01.0: PIIX3: Enabling Passive Release
[    0.858031] pci 0000:00:01.0: Activating ISA DMA hang workarounds
[    0.861048] pci 0000:00:02.0: Boot video device
[    0.863198] PCI: CLS 0 bytes, default 64
[    0.865727] Unpacking initramfs...
[    1.147274] Freeing initrd memory: 2964K (ffff88000fd0b000 - ffff88000ff=
f0000)
[    1.151646] kvm: no hardware support
[    1.153491] has_svm: not amd
[    1.154874] kvm: no hardware support
[    1.157474] microcode: CPU0 sig=3D0xf61, pf=3D0x1, revision=3D0x1
[    1.160215] microcode: CPU1 sig=3D0xf61, pf=3D0x1, revision=3D0x1
[    1.162622] microcode: Microcode Update Driver: v2.00 <tigran@aivazian.f=
snet.co.uk>, Peter Oruba
[    1.168568] camellia-x86_64: performance on this CPU would be suboptimal=
: disabling camellia-x86_64.
[    1.172869] blowfish-x86_64: performance on this CPU would be suboptimal=
: disabling blowfish-x86_64.
[    1.177620] twofish-x86_64-3way: performance on this CPU would be subopt=
imal: disabling twofish-x86_64-3way.
[    1.182623] sha1_ssse3: Neither AVX nor SSSE3 is available/usable.
[    1.185648] PCLMULQDQ-NI instructions are not detected.
[    1.188140] sha256_ssse3: Neither AVX nor SSSE3 is available/usable.
[    1.191189] AVX or AES-NI instructions are not detected.
[    1.193793] AVX instructions are not detected.
[    1.195901] AVX instructions are not detected.
[    1.198126] AVX instructions are not detected.
[    1.200297] AVX instructions are not detected.
[    1.208337] zbud: loaded
[    1.209992] VFS: Disk quotas dquot_6.5.2
[    1.212116] Dquot-cache hash table entries: 512 (order 0, 4096 bytes)
[    1.218481] Installing knfsd (copyright (C) 1996 okir@monad.swb.de).
[    1.222101] NTFS driver 2.1.30 [Flags: R/W].
[    1.224813] EFS: 1.0a - http://aeschi.ch.eu.org/efs/
[    1.228631] QNX6 filesystem 1.0.0 registered.
[    1.230964] fuse init (API version 7.22)
[    1.233260] 9p: Installing v9fs 9p2000 file system support
[    1.236450] NILFS version 2 loaded
[    1.238175] BeFS version: 0.9.3
[    1.242133] GFS2 installed
[    1.244449] FS-Cache: Netfs 'ceph' registered for caching
[    1.246803] ceph: loaded (mds proto 32)
[    1.383595] NET: Registered protocol family 38
[    1.385632] Key type asymmetric registered
[    1.387654] Block layer SCSI generic (bsg) driver version 0.4 loaded (ma=
jor 250)
[    1.393449] io scheduler noop registered
[    1.395120] io scheduler deadline registered (default)
[    1.402945] list_sort_test: start testing list_sort()
[    1.407315] crc32: CRC_LE_BITS =3D 64, CRC_BE BITS =3D 64
[    1.409478] crc32: self tests passed, processed 225944 bytes in 460538 n=
sec
[    1.412960] crc32c: CRC_LE_BITS =3D 64
[    1.414558] crc32c: self tests passed, processed 225944 bytes in 227826 =
nsec
[    1.417619] rbtree testing
[    2.160390] tsc: Refined TSC clocksource calibration: 1599.931 MHz
 -> 18462 cycles
[    2.643905] augmented rbtree testing -> 26103 cycles
[    4.379361] vmlfb: initializing
[    4.381045] Could not find Carillo Ranch MCH device.
[    4.383543] no IO addresses supplied
[    4.387315] cirrusfb 0000:00:02.0: Cirrus Logic chipset on PCI bus, RAM =
(4096 kB) at 0xfc000000
[    4.391935] usbcore: registered new interface driver udlfb
[    4.394606] usbcore: registered new interface driver smscufx
[    4.397468] ipmi message handler version 39.2
[    4.399510] ipmi device interface
[    4.401321] IPMI System Interface driver.
[    4.403344] ipmi_si: Adding default-specified kcs state machine
[    4.406243] ipmi_si: Trying default-specified kcs state machine at i/o a=
ddress 0xca2, slave address 0x0, irq 0
[    4.410956] ipmi_si: Interface detection failed
[    5.346862] ipmi_si: Adding default-specified smic state machine
[    5.349905] ipmi_si: Trying default-specified smic state machine at i/o =
address 0xca9, slave address 0x0, irq 0
[    5.356802] ipmi_si: Interface detection failed
[    6.346811] ipmi_si: Adding default-specified bt state machine
[    6.349740] ipmi_si: Trying default-specified bt state machine at i/o ad=
dress 0xe4, slave address 0x0, irq 0
[    6.356814] ipmi_si: Interface detection failed
[    7.346997] ipmi_si: Unable to find any System Interface(s)
[    7.349924] IPMI Watchdog: driver initialized
[    7.352287] Copyright (C) 2004 MontaVista Software - IPMI Powerdown via =
sys_reboot.
[    7.356830] input: Power Button as /devices/LNXSYSTM:00/LNXPWRBN:00/inpu=
t/input0
[    7.360703] ACPI: Power Button [PWRF]
[    7.363243] ioatdma: Intel(R) QuickData Technology Driver 4.00
[    7.382321] Serial: 8250/16550 driver, 4 ports, IRQ sharing disabled
[    7.420102] 00:05: ttyS0 at I/O 0x3f8 (irq =3D 4, base_baud =3D 115200) =
is a 16550A
[    7.425110] Applicom driver: $Id: ac.c,v 1.30 2000/03/22 16:03:57 dwmw2 =
Exp $
[    7.428844] ac.o: No PCI boards found.
[    7.430859] ac.o: For an ISA board you must supply memory and irq parame=
ters.
[    7.434931] Non-volatile memory driver v1.3
[    7.437277] ppdev: user-space parallel port driver
[    7.439714] Linux agpgart interface v0.103
[    7.443703] Hangcheck: starting hangcheck timer 0.9.1 (tick is 180 secon=
ds, margin is 60 seconds).
[    7.448256] Hangcheck: Using getrawmonotonic().
[    7.450369] [drm] Initialized drm 1.1.0 20060810
[    7.452790] [drm] radeon kernel modesetting enabled.
[    7.455740] usbcore: registered new interface driver udl
[    7.458396] intelfb: Framebuffer driver for Intel(R) 830M/845G/852GM/855=
GM/865G/915G/915GM/945G/945GM/945GME/965G/965GM chipsets
[    7.463830] intelfb: Version 0.9.6
[    7.468430] parport_pc 00:04: reported by Plug and Play ACPI
[    7.471479] parport0: PC-style at 0x378, irq 7 [PCSPP(,...)]
[    7.488378] MM: desc_per_page =3D 128
[    7.491529] nbd: registered device at major 43
[    7.497334] rbd: loaded rbd (rados block device)
[    7.499501] mtip32xx Version 1.2.6os3
[    7.501980] ibmasm: IBM ASM Service Processor Driver version 1.0 loaded
[    7.505333] Phantom Linux Driver, version n0.9.8, init OK
[    7.508108] Silicon Labs C2 port support v. 0.51.0 - (C) 2007 Rodolfo Gi=
ometti
[    7.511908] c2port c2port0: C2 port uc added
[    7.513976] c2port c2port0: uc flash has 30 blocks x 512 bytes (15360 by=
tes total)
[    7.518149] usbcore: registered new interface driver viperboard
[    7.521490] Uniform Multi-Platform E-IDE driver
[    7.524119] piix 0000:00:01.1: IDE controller (0x8086:0x7010 rev 0x00)
[    7.527530] piix 0000:00:01.1: not 100% native mode: will probe irqs lat=
er
[    7.532212] PIIX_IDE 0000:00:01.1: setting latency timer to 64
[    7.535008]     ide0: BM-DMA at 0xc040-0xc047
[    7.537221]     ide1: BM-DMA at 0xc048-0xc04f
[    7.539264] Probing IDE interface ide0...
[    8.083714] Probing IDE interface ide1...
[    8.787012] hdc: QEMU DVD-ROM, ATAPI CD/DVD-ROM drive
[    9.427013] hdc: host max PIO4 wanted PIO255(auto-tune) selected PIO0
[    9.430488] hdc: MWDMA2 mode selected
[    9.432858] ide0 at 0x1f0-0x1f7,0x3f6 on irq 14
[    9.435237] ide1 at 0x170-0x177,0x376 on irq 15
[    9.439951] ide-cd driver 5.00
[    9.444658] ide-cd: hdc: ATAPI 4X DVD-ROM drive, 512kB Cache
[    9.447648] cdrom: Uniform CD-ROM driver Revision: 3.20
[    9.464861] Loading iSCSI transport class v2.0-870.
[    9.470411] st: Version 20101219, fixed bufsize 32768, s/g segs 256
[    9.474961] SCSI Media Changer driver v0.25=20
[    9.477182] osd: LOADED open-osd 0.2.1
[    9.479051] ipddp.c:v0.01 8/28/97 Bradford W. Johnson <johns393@maroon.t=
c.umn.edu>
[    9.482980] ipddp0: Appletalk-IP Encap. mode by Bradford W. Johnson <joh=
ns393@maroon.tc.umn.edu>
[    9.487233] vcan: Virtual CAN interface driver
[    9.489334] I2O subsystem v1.325
[    9.490915] i2o: max drivers =3D 8
[    9.499970] I2O Configuration OSM v1.323
[    9.502037] I2O SCSI Peripheral OSM v1.316
[    9.504062] Fusion MPT base driver 3.04.20
[    9.505989] Copyright (c) 1999-2008 LSI Corporation
[    9.510092] Fusion MPT SPI Host driver 3.04.20
[    9.512315] Fusion MPT FC Host driver 3.04.20
[    9.514500] Fusion MPT SAS Host driver 3.04.20
[    9.516647] Fusion MPT misc device (ioctl) driver 3.04.20
[    9.519332] mptctl: Registered with Fusion MPT base driver
[    9.521976] mptctl: /dev/mptctl @ (major,minor=3D10,220)
[    9.526835] aoe: AoE v85 initialised.
[    9.528796] paride: aten registered as protocol 0
[    9.531089] paride: bpck registered as protocol 1
[    9.533288] paride: comm registered as protocol 2
[    9.535651] paride: k951 registered as protocol 3
[    9.537983] paride: k971 registered as protocol 4
[    9.540286] paride: epat registered as protocol 5
[    9.542474] paride: frpw registered as protocol 6
[    9.544763] paride: friq registered as protocol 7
[    9.547029] paride: fit2 registered as protocol 8
[    9.549221] paride: on20 registered as protocol 9
[    9.551627] pd: pd version 1.05, major 45, cluster 64, nice 0
[    9.554377] parport0: no more devices allowed
[    9.556416] parport0: no more devices allowed
[    9.558388] parport0: no more devices allowed
[    9.560502] parport0: no more devices allowed
[    9.562491] parport0: no more devices allowed
[    9.564540] parport0: no more devices allowed
[    9.566587] parport0: no more devices allowed
[    9.568701] parport0: no more devices allowed
[    9.570832] parport0: no more devices allowed
[    9.572875] parport0: no more devices allowed
[    9.574983] pda: Autoprobe failed
[    9.576535] pd: no valid drive found
[    9.578785] pcd: pcd version 1.07, major 46, nice 0
[    9.581248] parport0: no more devices allowed
[    9.583472] parport0: no more devices allowed
[    9.585516] parport0: no more devices allowed
[    9.587705] parport0: no more devices allowed
[    9.589759] parport0: no more devices allowed
[    9.591928] parport0: no more devices allowed
[    9.594047] parport0: no more devices allowed
[    9.596101] parport0: no more devices allowed
[    9.598194] parport0: no more devices allowed
[    9.600322] parport0: no more devices allowed
[    9.602359] pcd0: Autoprobe failed
[    9.604102] pcd: No CD-ROM drive found
[    9.605972] pt: pt version 1.04, major 96
[    9.608090] parport0: no more devices allowed
[    9.610274] parport0: no more devices allowed
[    9.612351] parport0: no more devices allowed
[    9.614558] parport0: no more devices allowed
[    9.616570] parport0: no more devices allowed
[    9.620101] parport0: no more devices allowed
[    9.622208] parport0: no more devices allowed
[    9.624396] parport0: no more devices allowed
[    9.626286] parport0: no more devices allowed
[    9.628502] parport0: no more devices allowed
[    9.630579] pt0: Autoprobe failed
[    9.632153] pt: No ATAPI tape drive detected
[    9.634496] usbcore: registered new interface driver hwa-rc
[    9.637183] usbcore: registered new interface driver i1480-dfu-usb
[    9.640465] ohci_hcd: USB 1.1 'Open' Host Controller (OHCI) Driver
[    9.643356] ohci-platform: OHCI generic platform driver
[    9.646370] usbcore: registered new interface driver hwa-hc
[    9.649137] fusbh200_hcd: FUSBH200 Host Controller (EHCI) Driver
[    9.652038] Warning! fusbh200_hcd should always be loaded before uhci_hc=
d and ohci_hcd, not after
[    9.656269] fotg210_hcd: FOTG210 Host Controller (EHCI) Driver
[    9.659052]=20
[    9.663774] usbcore: registered new interface driver wusb-cbaf
[    9.666584] usbcore: registered new interface driver usblp
[    9.669429] usbcore: registered new interface driver cdc_wdm
[    9.672088] usbcore: registered new interface driver usb-storage
[    9.674864] usbcore: registered new interface driver ums-datafab
[    9.677803] usbcore: registered new interface driver ums_eneub6250
[    9.680752] usbcore: registered new interface driver ums-freecom
[    9.683639] usbcore: registered new interface driver ums-isd200
[    9.686422] usbcore: registered new interface driver ums-jumpshot
[    9.689342] usbcore: registered new interface driver ums-onetouch
[    9.692280] usbcore: registered new interface driver ums-realtek
[    9.695164] usbcore: registered new interface driver ums-usbat
[    9.697972] usbcore: registered new interface driver microtekX6
[    9.700813] usbcore: registered new interface driver adutux
[    9.703788] usbcore: registered new interface driver appledisplay
[    9.706620] usbcore: registered new interface driver emi26 - firmware lo=
ader
[    9.710131] usbcore: registered new interface driver emi62 - firmware lo=
ader
[    9.713474] usbcore: registered new interface driver isight_firmware
[    9.716451] usbcore: registered new interface driver usblcd
[    9.719194] usbcore: registered new interface driver usbled
[    9.721901] usbcore: registered new interface driver legousbtower
[    9.724781] usbcore: registered new interface driver usbtest
[    9.727560] usbcore: registered new interface driver usb_ehset_test
[    9.730610] usbcore: registered new interface driver trancevibrator
[    9.733627] usbcore: registered new interface driver usbsevseg
[    9.736356] usbcore: registered new interface driver yurex
[    9.739234] usbcore: registered new interface driver cxacru
[    9.741931] usbcore: registered new interface driver speedtch
[    9.744699] usbcore: registered new interface driver ueagle-atm
[    9.747535] xusbatm: malformed module parameters
[    9.749896] i8042: PNP: PS/2 Controller [PNP0303:KBD,PNP0f13:MOU] at 0x6=
0,0x64 irq 1,12
[    9.756993] serio: i8042 KBD port at 0x60,0x64 irq 1
[    9.759749] serio: i8042 AUX port at 0x60,0x64 irq 12
[    9.762326] parport0: no more devices allowed
[    9.764976] mousedev: PS/2 mouse device common for all mice
[    9.768441] usbcore: registered new interface driver appletouch
[    9.771609] usbcore: registered new interface driver bcm5974
[    9.775651] usbcore: registered new interface driver synaptics_usb
[    9.778879] input: AT Translated Set 2 keyboard as /devices/platform/i80=
42/serio0/input/input1
[    9.783583] usbcore: registered new interface driver ati_remote2
[    9.786438] cm109: Keymap for Komunikate KIP1000 phone loaded
[    9.789275] usbcore: registered new interface driver cm109
[    9.792508] cm109: CM109 phone driver: 20080805 (C) Alfred E. Heggestad
[    9.796149] usbcore: registered new interface driver powermate
[    9.799399] usbcore: registered new interface driver yealink
[    9.802342] i2c /dev entries driver
[    9.806449] usbcore: registered new interface driver i2c-diolan-u2c
[    9.809636] i2c-parport: adapter type unspecified
[    9.812093] usbcore: registered new interface driver i2c-tiny-usb
[    9.815269] pps_parport: parallel port PPS client
[    9.817572] parport0: no more devices allowed
[    9.819686] pps_parport: couldn't register with parport0
[    9.822371] Driver for 1-wire Dallas network protocol.
[    9.825042] usbcore: registered new interface driver DS9490R
[    9.827905] 1-Wire driver for the DS2760 battery monitor  chip  - (c) 20=
04-2005, Szabolcs Gyurko
[    9.832760] power_supply test_ac: power_supply_changed
[    9.836662] power_supply test_ac: power_supply_changed_work
[    9.839447] power_supply test_ac: power_supply_update_gen_leds 1
[    9.844807] power_supply test_battery: power_supply_changed
[    9.847671] power_supply test_battery: power_supply_changed_work
[    9.850690] power_supply test_battery: power_supply_update_bat_leds 2
[    9.853640] power_supply test_usb: power_supply_changed
[    9.856974] applesmc: supported laptop not found!
[    9.859172] applesmc: driver init failed (ret=3D-19)!
[    9.861535] power_supply test_usb: power_supply_changed_work
[    9.864298] power_supply test_usb: power_supply_update_gen_leds 1
[    9.869044] pc87360: PC8736x not detected, module not inserted
[    9.872158] intel_powerclamp: Intel powerclamp does not run on family 15=
 model 6
[    9.875586] usbcore: registered new interface driver pcwd_usb
[    9.878418] advantechwdt: WDT driver for Advantech single board computer=
 initialising
[    9.882387] advantechwdt: initialized. timeout=3D60 sec (nowayout=3D1)
[    9.885409] alim7101_wdt: Steve Hill <steve@navaho.co.uk>
[    9.888044] alim7101_wdt: ALi M7101 PMU not present - WDT not set
[    9.891353] geodewdt: No timers were available
[    9.893457] ib700wdt: WDT driver for IB700 single board computer initial=
ising
[    9.896760] ib700wdt: START method I/O 443 is not available
[    9.899241] ib700wdt: probe of ib700wdt failed with error -5
[    9.902033] wafer5823wdt: WDT driver for Wafer 5823 single board compute=
r initialising
[    9.905854] wafer5823wdt: I/O address 0x0443 already in use
[    9.908607] i6300esb: Intel 6300ESB WatchDog Timer Driver v0.05
[    9.912112] i6300esb: cannot register miscdev on minor=3D130 (err=3D-16)
[    9.915201] i6300ESB timer: probe of 0000:00:04.0 failed with error -16
[    9.918347] iTCO_wdt: Intel TCO WatchDog Timer Driver v1.10
[    9.921129] it87_wdt: no device
[    9.922463] nv_tco: NV TCO WatchDog Timer Driver v0.01
[    9.925075] sbc60xxwdt: I/O address 0x0443 already in use
[    9.927621] cpu5wdt: misc_register failed
[    9.929560] smsc37b787_wdt: SMsC 37B787 watchdog component driver 1.1 in=
itialising...
[    9.934681] smsc37b787_wdt: Unable to register miscdev on minor 130
[    9.937733] w83627hf_wdt: WDT driver for the Winbond(TM) W83627HF/THF/HG=
/DHG Super I/O chip initialising
[    9.942202] w83627hf_wdt: Watchdog already running. Resetting timeout to=
 60 sec
[    9.945574] w83627hf_wdt: cannot register miscdev on minor=3D130 (err=3D=
-16)
[    9.948452] sbc_epx_c3: cannot register miscdev on minor=3D130 (err=3D-1=
6)
[    9.953136] device-mapper: ioctl: 4.26.0-ioctl (2013-08-15) initialised:=
 dm-devel@redhat.com
[    9.958059] device-mapper: multipath: version 1.5.1 loaded
[    9.960455] device-mapper: multipath round-robin: version 1.0.0 loaded
[    9.963172] device-mapper: multipath service-time: version 0.2.0 loaded
[    9.966347] Bluetooth: Virtual HCI driver ver 1.3
[    9.968465] usbcore: registered new interface driver btusb
[    9.973437] usbcore: registered new interface driver ath3k
[    9.976087] leds_ss4200: no LED devices found
[    9.978152] ledtrig-cpu: registered to indicate activity on CPUs
[    9.993992] dcdbas dcdbas: Dell Systems Management Base Driver (version =
5.6.0-3.2)
[    9.997423] cs5535-clockevt: Could not allocate MFGPT timer
[   10.004515] usbcore: registered new interface driver usbhid
[   10.007224] usbhid: USB HID core driver
[   10.009373] dell_wmi: No known WMI GUID found
[   10.011544] dell_wmi_aio: No known WMI GUID found
[   10.013868] acer_wmi: Acer Laptop ACPI-WMI Extras
[   10.016098] acer_wmi: No or unsupported WMI interface, unable to load
[   10.020093] acerhdf: Acer Aspire One Fan driver, v.0.5.26
[   10.022651] acerhdf: unknown (unsupported) BIOS version Bochs/Bochs/Boch=
s, please report, aborting!
[   10.027098] hdaps: supported laptop not found!
[   10.029244] hdaps: driver init failed (ret=3D-19)!
[   10.031588] msi_wmi: This machine doesn't have neither MSI-hotkeys nor b=
acklight through WMI
[   10.036860]  fake-fmc-carrier: mezzanine 0
[   10.038842]       Manufacturer: fake-vendor
[   10.040906]       Product name: fake-design-for-testing
[   10.043584] fmc fake-design-for-testing-f001: Driver has no ID: matches =
all
[   10.046947] fmc_write_eeprom fake-design-for-testing-f001: fmc_write_eep=
rom: no busid passed, refusing all cards
[   10.051964] fmc fake-design-for-testing-f001: Driver has no ID: matches =
all
[   10.057762] fmc_chardev fake-design-for-testing-f001: Created misc devic=
e "fake-design-for-testing-f001"
[   10.064303] drop_monitor: Initializing network drop monitor service
[   10.067665] GACT probability NOT on
[   10.069337] Mirror/redirect action on
[   10.070943] netem: version 1.3
[   10.072440] ipip: IPv4 over IPv4 tunneling driver
[   10.074952] IPv4 over IPSec tunneling driver
[   10.077274] TCP: cubic registered
[   10.078877] Initializing XFRM netlink socket
[   10.081656] NET: Registered protocol family 10
[   10.085207] mip6: Mobile IPv6
[   10.086883] ip6_gre: GRE over IPv6 tunneling driver
[   10.089252] NET: Registered protocol family 17
[   10.091535] NET: Registered protocol family 15
[   10.093956] NET: Registered protocol family 4
[   10.096040] NET: Registered protocol family 5
[   10.098312] can: controller area network core (rev 20120528 abi 9)
[   10.101599] can: failed to create /proc/net/can . CONFIG_PROC_FS missing?
[   10.104982] NET: Registered protocol family 29
[   10.106930] can: broadcast manager protocol (rev 20120528 t)
[   10.109498] can: netlink gateway (rev 20130117) max_hops=3D1
[   10.112618] Bluetooth: RFCOMM socket layer initialized
[   10.115263] Bluetooth: RFCOMM ver 1.11
[   10.117099] Bluetooth: HIDP (Human Interface Emulation) ver 1.2
[   10.119792] Bluetooth: HIDP socket layer initialized
[   10.122246] RPC: Registered rdma transport module.
[   10.127346] NET: Registered protocol family 33
[   10.129461] Key type rxrpc registered
[   10.131112] Key type rxrpc_s registered
[   10.137102] RxRPC: Registered security type 2 'rxkad'
[   10.139307] lec:lane_module_init: lec.c: initialized
[   10.141530] mpoa:atm_mpoa_init: mpc.c: initialized
[   10.146790] l2tp_core: L2TP core driver, V2.0
[   10.148830] l2tp_ip: L2TP IP encapsulation support (L2TPv3)
[   10.151340] l2tp_netlink: L2TP netlink interface
[   10.153549] l2tp_eth: L2TP ethernet pseudowire support (L2TPv3)
[   10.156306] l2tp_ip6: L2TP IP encapsulation support for IPv6 (L2TPv3)
[   10.159476] NET4: DECnet for Linux: V.2.5.68s (C) 1995-2003 Linux DECnet=
 Project Team
[   10.163675] DECnet: Routing cache hash table of 256 buckets, 16Kbytes
[   10.167041] NET: Registered protocol family 12
[   10.169027] 8021q: 802.1Q VLAN Support v1.8
[   10.172091] DCCP: Activated CCID 2 (TCP-like)
[   10.175509] sctp: Hash tables configured (established 1024 bind 1024)
[   10.178822] tipc: Activated (version 2.0.0)
[   10.204099] NET: Registered protocol family 30
[   10.207221] tipc: Started in single node mode
[   10.209101] 9pnet: Installing 9P2000 support
[   10.211197] NET: Registered protocol family 37
[   10.213602] NET: Registered protocol family 36
[   10.216029] Key type dns_resolver registered
[   10.218209] Key type ceph registered
[   10.220496] libceph: loaded (mon/osd proto 15/24)
[   10.222710] openvswitch: Open vSwitch switching datapath
[   10.226391]=20
[   10.226391] printing PIC contents
[   10.228866] ... PIC  IMR: ffff
[   10.230342] ... PIC  IRR: 9013
[   10.231749] ... PIC  ISR: 0000
[   10.233050] ... PIC ELCR: 0c00
[   10.234532] printing local APIC contents on CPU#0/0:
[   10.236798] ... APIC ID:      00000000 (0)
[   10.237762] ... APIC VERSION: 00050014
[   10.237762] ... APIC TASKPRI: 00000000 (00)
[   10.237762] ... APIC PROCPRI: 00000000
[   10.237762] ... APIC LDR: 01000000
[   10.237762] ... APIC DFR: ffffffff
[   10.237762] ... APIC SPIV: 000001ff
[   10.237762] ... APIC ISR field:
[   10.237762] 000000000000000000000000000000000000000000000000000000000000=
0000
[   10.237762] ... APIC TMR field:
[   10.237762] 000000000200000000000000000000000000000000000000000000000000=
0000
[   10.237762] ... APIC IRR field:
[   10.237762] 000000000000000000000000000000000000000000000000000000000000=
8000
[   10.237762] ... APIC ESR: 00000000
[   10.237762] ... APIC ICR: 000008fd
[   10.237762] ... APIC ICR2: 02000000
[   10.237762] ... APIC LVTT: 000000ef
[   10.237762] ... APIC LVTPC: 00010000
[   10.237762] ... APIC LVT0: 00010700
[   10.237762] ... APIC LVT1: 00000400
[   10.237762] ... APIC LVTERR: 000000fe
[   10.237762] ... APIC TMICT: 00021fac
[   10.237762] ... APIC TMCCT: 00000000
[   10.237762] ... APIC TDCR: 00000003
[   10.237762]=20
[   10.283819] number of MP IRQ sources: 15.
[   10.286075] number of IO-APIC #0 registers: 24.
[   10.288732] testing the IO APIC.......................
[   10.293859] IO APIC #0......
[   10.295254] .... register #00: 00000000
[   10.297165] .......    : physical APIC id: 00
[   10.299251] .......    : Delivery Type: 0
[   10.301228] .......    : LTS          : 0
[   10.303160] .... register #01: 00170011
[   10.305077] .......     : max redirection entries: 17
[   10.307507] .......     : PRQ implemented: 0
[   10.309512] .......     : IO APIC version: 11
[   10.311637] .... register #02: 00000000
[   10.313546] .......     : arbitration: 00
[   10.315449] .... IRQ redirection table:
[   10.317366] 1    0    0   0   0    0    0    00
[   10.319601] 0    0    0   0   0    1    1    31
[   10.321910] 0    0    0   0   0    1    1    30
[   10.324154] 0    0    0   0   0    1    1    33
[   10.326288] 1    0    0   0   0    1    1    34
[   10.328453] 1    1    0   0   0    1    1    35
[   10.330608] 0    0    0   0   0    1    1    36
[   10.332758] 0    0    0   0   0    1    1    37
[   10.334996] 0    0    0   0   0    1    1    38
[   10.336998] 0    1    0   0   0    1    1    39
[   10.339142] 1    1    0   0   0    1    1    3A
[   10.341309] 1    1    0   0   0    1    1    3B
[   10.343468] 0    0    0   0   0    1    1    3C
[   10.345552] 0    0    0   0   0    1    1    3D
[   10.347762] 0    0    0   0   0    1    1    3E
[   10.349871] 0    0    0   0   0    1    1    3F
[   10.352091] 1    0    0   0   0    0    0    00
[   10.354473] 1    0    0   0   0    0    0    00
[   10.356593] 1    0    0   0   0    0    0    00
[   10.358777] 1    0    0   0   0    0    0    00
[   10.360967] 1    0    0   0   0    0    0    00
[   10.363087] 1    0    0   0   0    0    0    00
[   10.365259] 1    0    0   0   0    0    0    00
[   10.367434] 1    0    0   0   0    0    0    00
[   10.369551] IRQ to pin mappings:
[   10.371222] IRQ0 -> 0:2
[   10.372547] IRQ1 -> 0:1
[   10.373972] IRQ3 -> 0:3
[   10.375298] IRQ4 -> 0:4
[   10.376627] IRQ5 -> 0:5
[   10.377989] IRQ6 -> 0:6
[   10.379274] IRQ7 -> 0:7
[   10.380613] IRQ8 -> 0:8
[   10.381922] IRQ9 -> 0:9
[   10.383196] IRQ10 -> 0:10
[   10.384695] IRQ11 -> 0:11
[   10.386049] IRQ12 -> 0:12
[   10.387466] IRQ13 -> 0:13
[   10.388847] IRQ14 -> 0:14
[   10.390318] IRQ15 -> 0:15
[   10.391660] .................................... done.
[   10.394832] registered taskstats version 1
[   10.398193] Key type trusted registered
[   10.400788] RIO: rio_register_scan for mport_id=3D-1
[   10.403329] dmaengine: __dma_request_channel: fail ((null))
[   10.407328] BIOS EDD facility v0.16 2004-Jun-25, 0 devices found
[   10.410377] EDD information not available.
[   10.412866] Unregister pv shared memory for cpu 0
[   10.499606] input: ImExPS/2 Generic Explorer Mouse as /devices/platform/=
i8042/serio1/input/input3
[  241.206735] INFO: task swapper/0:1 blocked for more than 120 seconds.
[  241.209244]       Not tainted 3.12.0-02098-g1918664 #98
[  241.211290] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables =
this message.
[  241.214286] swapper/0       D ffff88000ec9e040     0     1      0 0x0000=
0000
[  241.217142]  ffff88000eca1c10 0000000000000046 ffffffff826aca60 ffff8800=
0ec9e040
[  241.220200]  ffff88000eca1fd8 0000000000012a00 0000000000012a00 ffff8800=
0c9927c0
[  241.223196]  ffff88000ec9e040 ffff88000ec9e040 ffff88000eca1b60 00000000=
00000002
[  241.226835] Call Trace:
[  241.227813]  [<ffffffff8110e544>] ? __lock_acquire+0x1e74/0x1ef0
[  241.230123]  [<ffffffff8110e544>] ? __lock_acquire+0x1e74/0x1ef0
[  241.232400]  [<ffffffff81d39ea5>] schedule+0x55/0x60
[  241.234345]  [<ffffffff81d38efb>] schedule_timeout+0x2b/0x200
[  241.236533]  [<ffffffff8110a88e>] ? mark_held_locks+0x12e/0x150
[  241.238845]  [<ffffffff81d3e577>] ? _raw_spin_unlock_irq+0x27/0x60
[  241.241356]  [<ffffffff810f753d>] ? get_parent_ip+0xd/0x50
[  241.243790]  [<ffffffff810f7603>] ? preempt_count_sub+0x33/0x50
[  241.246273]  [<ffffffff81d3a9c7>] wait_for_common+0x167/0x1b0
[  241.248715]  [<ffffffff810f9470>] ? try_to_wake_up+0x330/0x330
[  241.251291]  [<ffffffff81124df0>] ? __call_rcu.constprop.42+0x3d0/0x3d0
[  241.254145]  [<ffffffff81d3ab48>] wait_for_completion+0x18/0x20
[  241.256756]  [<ffffffff8111ed16>] wait_rcu_gp+0x46/0x50
[  241.259000]  [<ffffffff8111eb30>] ? ftrace_raw_output_rcu_barrier+0x70/0=
x70
[  241.262012]  [<ffffffff811263dc>] synchronize_rcu+0x2c/0x30
[  241.264437]  [<ffffffff81d1bd82>] _cpu_down+0x2b2/0x340
[  241.266760]  [<ffffffff81d3afea>] ? mutex_lock_nested+0x3da/0x400
[  241.269311]  [<ffffffff8106c832>] ? cpu_hotplug_driver_lock+0x12/0x20
[  241.272113]  [<ffffffff81d1bec1>] cpu_down+0x31/0x50
[  241.274282]  [<ffffffff81d1aaa7>] _debug_hotplug_cpu+0x47/0xb0
[  241.276853]  [<ffffffff824251f3>] ? pci_iommu_alloc+0x6c/0x6c
[  241.279183]  [<ffffffff82425200>] debug_hotplug_cpu+0xd/0x11
[  241.281679]  [<ffffffff8241ce54>] do_one_initcall+0x7e/0x11b
[  241.284140]  [<ffffffff810e9a1d>] ? parse_args+0x1dd/0x300
[  241.286665]  [<ffffffff8241cfed>] kernel_init_freeable+0xfc/0x18d
[  241.289336]  [<ffffffff8241c7ec>] ? do_early_param+0x8a/0x8a
[  241.291894]  [<ffffffff81d1a8e0>] ? rest_init+0xc0/0xc0
[  241.294233]  [<ffffffff81d1a8e9>] kernel_init+0x9/0x180
[  241.296494]  [<ffffffff81d3f9cc>] ret_from_fork+0x7c/0xb0
[  241.298917]  [<ffffffff81d1a8e0>] ? rest_init+0xc0/0xc0
[  241.303393] 3 locks held by swapper/0/1:
[  241.305121]  #0:  (x86_cpu_hotplug_driver_mutex){+.+.+.}, at: [<ffffffff=
8106c832>] cpu_hotplug_driver_lock+0x12/0x20
[  241.309967]  #1:  (cpu_add_remove_lock){+.+.+.}, at: [<ffffffff81d1bead>=
] cpu_down+0x1d/0x50
[  241.314045]  #2:  (cpu_hotplug.lock){+.+.+.}, at: [<ffffffff810cca86>] c=
pu_hotplug_begin+0x26/0x60
[  241.318328] sending NMI to all CPUs:
[  241.319960] NMI backtrace for cpu 1
[  241.321503] CPU: 1 PID: 29 Comm: khungtaskd Not tainted 3.12.0-02098-g19=
18664 #98
[  241.321618] Hardware name: Bochs Bochs, BIOS Bochs 01/01/2011
[  241.321618] task: ffff88000cf8e780 ti: ffff88000cf90000 task.ti: ffff880=
00cf90000
[  241.321618] RIP: 0010:[<ffffffff8107377d>]  [<ffffffff8107377d>] flat_se=
nd_IPI_mask+0x8d/0xd0
[  241.321618] RSP: 0000:ffff88000cf91db8  EFLAGS: 00010046
[  241.321618] RAX: 0000000003000000 RBX: 0000000000000002 RCX: 00000000000=
00007
[  241.321618] RDX: 0000000000000c00 RSI: 0000000000000001 RDI: 00000000000=
00300
[  241.321618] RBP: ffff88000cf91dd8 R08: 0000000000000000 R09: 00000000000=
00000
[  241.321618] R10: 0000000000000001 R11: 0000000000000001 R12: 00000000000=
00246
[  241.321618] R13: 0000000000000c00 R14: 0000000000000003 R15: 00000000000=
003ff
[  241.321618] FS:  0000000000000000(0000) GS:ffff88000f100000(0000) knlGS:=
0000000000000000
[  241.321618] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[  241.321618] CR2: 00000000ffffffff CR3: 0000000002206000 CR4: 00000000000=
006a0
[  241.321618] Stack:
[  241.321618]  0000000000002710 ffff88000ec9e040 0000000000007fff ffff8800=
0ec9e040
[  241.321618]  ffff88000cf91de8 ffffffff810737da ffff88000cf91e00 ffffffff=
81070a3f
[  241.321618]  0000000000000078 ffff88000cf91e68 ffffffff8113e1a8 ffffffff=
8113df4b
[  241.321618] Call Trace:
[  241.321618]  [<ffffffff810737da>] flat_send_IPI_all+0x1a/0x70
[  241.321618]  [<ffffffff81070a3f>] arch_trigger_all_cpu_backtrace+0x5f/0x=
b0
[  241.321618]  [<ffffffff8113e1a8>] watchdog+0x2d8/0x3d0
[  241.321618]  [<ffffffff8113df4b>] ? watchdog+0x7b/0x3d0
[  241.321618]  [<ffffffff8113ded0>] ? hung_task_panic+0x20/0x20
[  241.321618]  [<ffffffff810eb431>] kthread+0xd1/0xe0
[  241.321618]  [<ffffffff81d3e577>] ? _raw_spin_unlock_irq+0x27/0x60
[  241.321618]  [<ffffffff810eb360>] ? __kthread_unpark+0x50/0x50
[  241.321618]  [<ffffffff81d3f9cc>] ret_from_fork+0x7c/0xb0
[  241.321618]  [<ffffffff810eb360>] ? __kthread_unpark+0x50/0x50
[  241.321618] Code: e6 10 75 f2 44 89 f0 c1 e0 18 89 04 25 10 b3 57 ff 89 =
da 44 09 ea 41 81 cd 00 04 00 00 83 fb 02 41 0f 44 d5 89 14 25 00 b3 57 ff =
<41> f7 c4 00 02 00 00 75 1a 4c 89 e7 57 9d 0f 1f 44 00 00 e8 8b=20
[  241.321618] INFO: NMI handler (arch_trigger_all_cpu_backtrace_handler) t=
ook too long to run: 91.555 msecs
[  241.320025] NMI backtrace for cpu 0
[  241.320025] CPU: 0 PID: 30 Comm: rb_consumer Not tainted 3.12.0-02098-g1=
918664 #98
[  241.320025] Hardware name: Bochs Bochs, BIOS Bochs 01/01/2011
[  241.320025] task: ffff88000c9927c0 ti: ffff88000c994000 task.ti: ffff880=
00c994000
[  241.320025] RIP: 0010:[<ffffffff81413f39>]  [<ffffffff81413f39>] find_ne=
xt_bit+0xc9/0xd0
[  241.320025] RSP: 0000:ffff88000c995df0  EFLAGS: 00000246
[  241.320025] RAX: 0000000000000002 RBX: 0000000000000002 RCX: 00000000000=
00001
[  241.320025] RDX: 0000000000000002 RSI: 0000000000000002 RDI: ffffffff824=
00880
[  241.320025] RBP: ffff88000c995e68 R08: 0000000000000001 R09: 00000000000=
00000
[  241.320025] R10: 0000000000000000 R11: 0000000000000000 R12: 00000000000=
00001
[  241.320025] R13: 0000000000000000 R14: 0000000000000001 R15: 00000000000=
00ff0
[  241.320025] FS:  0000000000000000(0000) GS:ffff88000f000000(0000) knlGS:=
0000000000000000
[  241.320025] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[  241.320025] CR2: 0000000000000000 CR3: 0000000002206000 CR4: 00000000000=
006b0
[  241.320025] Stack:
[  241.320025]  ffffffff81145de9 ffff88000c9927c0 ffff88000c9927c0 ffff8800=
0c9927c0
[  241.320025]  ffff88000c9927c0 0000000000000001 000000000c995e40 00000000=
00000000
[  241.320025]  0000000000000000 000c57c00cabc889 ffff88000eca1db8 00000000=
00000000
[  241.320025] Call Trace:
[  241.320025]  [<ffffffff81145de9>] ? ring_buffer_consumer_thread+0x429/0x=
5f0
[  241.320025]  [<ffffffff811459c0>] ? ring_buffer_producer_thread+0x560/0x=
560
[  241.320025]  [<ffffffff810eb431>] kthread+0xd1/0xe0
[  241.320025]  [<ffffffff81d3e577>] ? _raw_spin_unlock_irq+0x27/0x60
[  241.320025]  [<ffffffff810eb360>] ? __kthread_unpark+0x50/0x50
[  241.320025]  [<ffffffff81d3f9cc>] ret_from_fork+0x7c/0xb0
[  241.320025]  [<ffffffff810eb360>] ? __kthread_unpark+0x50/0x50
[  241.320025] Code: 74 28 48 8b 02 b9 40 00 00 00 48 c7 c2 ff ff ff ff 29 =
f1 48 d3 ea 48 21 d0 75 07 48 8d 04 37 eb 09 90 f3 48 0f bc c0 48 01 f8 5d =
<c3> 66 0f 1f 44 00 00 55 48 39 f2 48 89 f0 48 89 e5 0f 83 cb 00=20
[  241.320025] INFO: NMI handler (arch_trigger_all_cpu_backtrace_handler) t=
ook too long to run: 91.820 msecs
[  241.503450] Kernel panic - not syncing: hung_task: blocked tasks
[  241.506161] CPU: 1 PID: 29 Comm: khungtaskd Not tainted 3.12.0-02098-g19=
18664 #98
[  241.506682] Hardware name: Bochs Bochs, BIOS Bochs 01/01/2011
[  241.506682]  ffff88000ec9e040 ffff88000cf91d88 ffffffff81d28798 ffffffff=
820ba710
[  241.506682]  ffff88000cf91e00 ffffffff81d2438b 0000000000000008 ffff8800=
0cf91e10
[  241.506682]  ffff88000cf91db0 0000000000000246 0000000000000002 00000000=
00000003
[  241.506682] Call Trace:
[  241.506682]  [<ffffffff81d28798>] dump_stack+0x4f/0x7b
[  241.506682]  [<ffffffff81d2438b>] panic+0xc8/0x1cb
[  241.506682]  [<ffffffff8113e1b6>] watchdog+0x2e6/0x3d0
[  241.506682]  [<ffffffff8113df4b>] ? watchdog+0x7b/0x3d0
[  241.506682]  [<ffffffff8113ded0>] ? hung_task_panic+0x20/0x20
[  241.506682]  [<ffffffff810eb431>] kthread+0xd1/0xe0
[  241.506682]  [<ffffffff81d3e577>] ? _raw_spin_unlock_irq+0x27/0x60
[  241.506682]  [<ffffffff810eb360>] ? __kthread_unpark+0x50/0x50
[  241.506682]  [<ffffffff81d3f9cc>] ret_from_fork+0x7c/0xb0
[  241.506682]  [<ffffffff810eb360>] ? __kthread_unpark+0x50/0x50
[  241.506682] Kernel Offset: 0x0 from 0xffffffff81000000 (relocation range=
: 0xffffffff80000000-0xffffffff9fffffff)

Elapsed time: 250
qemu-system-x86_64 -cpu kvm64 -enable-kvm -kernel /kernel/x86_64-randconfig=
-x4-1108/1918664d0b2b6b2ad6b180e7c04a42872beb6691/vmlinuz-3.12.0-02098-g191=
8664 -append 'hung_task_panic=3D1 rcutree.rcu_cpu_stall_timeout=3D100 log_b=
uf_len=3D8M ignore_loglevel debug sched_debug apic=3Ddebug dynamic_printk s=
ysrq_always_enabled panic=3D10  prompt_ramdisk=3D0 console=3DttyS0,115200 c=
onsole=3Dtty0 vga=3Dnormal  root=3D/dev/ram0 rw link=3D/kernel-tests/run-qu=
eue/kvm/x86_64-randconfig-x4-1108/tip:master/.vmlinuz-1918664d0b2b6b2ad6b18=
0e7c04a42872beb6691-20131108222605-7-jaketown branch=3Dtip/master BOOT_IMAG=
E=3D/kernel/x86_64-randconfig-x4-1108/1918664d0b2b6b2ad6b180e7c04a42872beb6=
691/vmlinuz-3.12.0-02098-g1918664'  -initrd /kernel-tests/initrd/yocto-mini=
mal-x86_64.cgz -m 256M -smp 2 -net nic,vlan=3D1,model=3De1000 -net user,vla=
n=3D1 -boot order=3Dnc -no-reboot -watchdog i6300esb -pidfile /dev/shm/kboo=
t/pid-yocto-jaketown-20 -serial file:/dev/shm/kboot/serial-yocto-jaketown-2=
0 -daemonize -display none -monitor null=20

--CblX+4bnyfN0pR09
Content-Type: application/octet-stream
Content-Disposition: attachment; filename="bisect-1918664d0b2b6b2ad6b180e7c04a42872beb6691-x86_64-randconfig-x4-1108-Kernel-panic---not-syncing:-hung_task:-blocked-tasks-112033.log"
Content-Transfer-Encoding: base64

Z2l0IGNoZWNrb3V0IGQ4NTI0YWU5ZDZmNDkyYTljNmRiOWY0ZDg5YzVmOWI4NzgyZmEyZDUK
UHJldmlvdXMgSEVBRCBwb3NpdGlvbiB3YXMgMTkxODY2NC4uLiBNZXJnZSBicmFuY2ggJ3g4
Ni9pbnRlbC1taWQnCkhFQUQgaXMgbm93IGF0IGQ4NTI0YWUuLi4gTWVyZ2UgYnJhbmNoICdk
cm0tZml4ZXMnIG9mIGdpdDovL3Blb3BsZS5mcmVlZGVza3RvcC5vcmcvfmFpcmxpZWQvbGlu
dXgKbHMgLWEgL2tlcm5lbC10ZXN0cy9ydW4tcXVldWUva3ZtL3g4Nl82NC1yYW5kY29uZmln
LXg0LTExMDgvdGlwOm1hc3RlcjpkODUyNGFlOWQ2ZjQ5MmE5YzZkYjlmNGQ4OWM1ZjliODc4
MmZhMmQ1OmJpc2VjdC1zb3VuZAoKMjAxMy0xMS0wOS0xMToxMTozMCBkODUyNGFlOWQ2ZjQ5
MmE5YzZkYjlmNGQ4OWM1ZjliODc4MmZhMmQ1IGNvbXBpbGluZwo5NDMgcmVhbCAgMTgwMiB1
c2VyICAxODAgc3lzICAyMTAuMzIlIGNwdSAJeDg2XzY0LXJhbmRjb25maWcteDQtMTEwOAoK
MjAxMy0xMS0wOS0xMTozNDoxNCBkZXRlY3RpbmcgYm9vdCBzdGF0ZSAzLjEyLjAtcmMxLTEw
MDAyLWdkODUyNGFlLi4uCTIuLi4JMy4uLi4uLi4uCTQuCTUuCTYuCTgJMTAJMTIJMTUJMTcJ
MTkJMjMJMjUJMjcgU1VDQ0VTUwoKYmlzZWN0OiBnb29kIGNvbW1pdCBkODUyNGFlOWQ2ZjQ5
MmE5YzZkYjlmNGQ4OWM1ZjliODc4MmZhMmQ1CmdpdCBiaXNlY3Qgc3RhcnQgMTkxODY2NGQw
YjJiNmIyYWQ2YjE4MGU3YzA0YTQyODcyYmViNjY5MSBkODUyNGFlOWQ2ZjQ5MmE5YzZkYjlm
NGQ4OWM1ZjliODc4MmZhMmQ1IC0tClByZXZpb3VzIEhFQUQgcG9zaXRpb24gd2FzIGQ4NTI0
YWUuLi4gTWVyZ2UgYnJhbmNoICdkcm0tZml4ZXMnIG9mIGdpdDovL3Blb3BsZS5mcmVlZGVz
a3RvcC5vcmcvfmFpcmxpZWQvbGludXgKSEVBRCBpcyBub3cgYXQgYzFiZTVhNS4uLiBMaW51
eCAzLjkKQmlzZWN0aW5nOiAxNzg1IHJldmlzaW9ucyBsZWZ0IHRvIHRlc3QgYWZ0ZXIgdGhp
cyAocm91Z2hseSAxMSBzdGVwcykKWzRkOTIxOGRhYWUyYjAwMzc5YjJiYjgxZWFmNGZlNTE0
M2YzNzJkYjFdIE1lcmdlIHRhZyAncGVyZi1jb3JlLWZvci1taW5nbycgb2YgZ2l0Oi8vZ2l0
Lmtlcm5lbC5vcmcvcHViL3NjbS9saW51eC9rZXJuZWwvZ2l0L2FjbWUvbGludXggaW50byBw
ZXJmL2NvcmUKZ2l0IGJpc2VjdCBydW4gL2Mva2VybmVsLXRlc3RzL2Jpc2VjdC10ZXN0LWJv
b3QtZmFpbHVyZS5zaCAvaG9tZS93Zmcvc291bmQvb2JqLWJpc2VjdApydW5uaW5nIC9jL2tl
cm5lbC10ZXN0cy9iaXNlY3QtdGVzdC1ib290LWZhaWx1cmUuc2ggL2hvbWUvd2ZnL3NvdW5k
L29iai1iaXNlY3QKbHMgLWEgL2tlcm5lbC10ZXN0cy9ydW4tcXVldWUva3ZtL3g4Nl82NC1y
YW5kY29uZmlnLXg0LTExMDgvdGlwOm1hc3Rlcjo0ZDkyMThkYWFlMmIwMDM3OWIyYmI4MWVh
ZjRmZTUxNDNmMzcyZGIxOmJpc2VjdC1zb3VuZAoKMjAxMy0xMS0wOS0xMTo1MDoyMyA0ZDky
MThkYWFlMmIwMDM3OWIyYmI4MWVhZjRmZTUxNDNmMzcyZGIxIHJldXNlIC9rZXJuZWwveDg2
XzY0LXJhbmRjb25maWcteDQtMTEwOC80ZDkyMThkYWFlMmIwMDM3OWIyYmI4MWVhZjRmZTUx
NDNmMzcyZGIxL3ZtbGludXotMy4xMi4wLTAwMzEyLWc0ZDkyMThkCgoyMDEzLTExLTA5LTEx
OjUwOjI0IGRldGVjdGluZyBib290IHN0YXRlIC4uLgkxNAkxNwkxOAkxOQkyNAkyNyBTVUND
RVNTCgpCaXNlY3Rpbmc6IDg5MiByZXZpc2lvbnMgbGVmdCB0byB0ZXN0IGFmdGVyIHRoaXMg
KHJvdWdobHkgMTAgc3RlcHMpCltmMDVlZjNmNmY3OGU2Yjk3ZjU2NjRhODI5MGYxYWMwNzE3
YjFhMWIwXSBrdm0gdG9vbHM6IFN3aXRjaCB0byB1c2luZyBhbiBlbnVtIGZvciBkaXNrIGlt
YWdlIHR5cGVzCnJ1bm5pbmcgL2Mva2VybmVsLXRlc3RzL2Jpc2VjdC10ZXN0LWJvb3QtZmFp
bHVyZS5zaCAvaG9tZS93Zmcvc291bmQvb2JqLWJpc2VjdApscyAtYSAva2VybmVsLXRlc3Rz
L3J1bi1xdWV1ZS9rdm0veDg2XzY0LXJhbmRjb25maWcteDQtMTEwOC90aXA6bWFzdGVyOmYw
NWVmM2Y2Zjc4ZTZiOTdmNTY2NGE4MjkwZjFhYzA3MTdiMWExYjA6YmlzZWN0LXNvdW5kCgoy
MDEzLTExLTA5LTExOjU1OjE1IGYwNWVmM2Y2Zjc4ZTZiOTdmNTY2NGE4MjkwZjFhYzA3MTdi
MWExYjAgY29tcGlsaW5nCjQ2NiByZWFsICAxMTMwIHVzZXIgIDEwOCBzeXMgIDI2NS44MyUg
Y3B1IAl4ODZfNjQtcmFuZGNvbmZpZy14NC0xMTA4CgoyMDEzLTExLTA5LTEyOjA1OjA2IGRl
dGVjdGluZyBib290IHN0YXRlIDMuMC4wLXJjNS0wMDg5My1nZjA1ZWYzZi4uLgkzCTE0CTIy
CTI2CTI3IFNVQ0NFU1MKCkJpc2VjdGluZzogNDQ2IHJldmlzaW9ucyBsZWZ0IHRvIHRlc3Qg
YWZ0ZXIgdGhpcyAocm91Z2hseSA5IHN0ZXBzKQpbMzc4NDU5MmUwYzBmMjI0ZTM5OTYwNWNm
YTJkMTU3MGY3OWMwY2MyOV0gY29uZmlnOiBmaXggbWFrZSBrdm1jb25maWcKcnVubmluZyAv
Yy9rZXJuZWwtdGVzdHMvYmlzZWN0LXRlc3QtYm9vdC1mYWlsdXJlLnNoIC9ob21lL3dmZy9z
b3VuZC9vYmotYmlzZWN0CmxzIC1hIC9rZXJuZWwtdGVzdHMvcnVuLXF1ZXVlL2t2bS94ODZf
NjQtcmFuZGNvbmZpZy14NC0xMTA4L3RpcDptYXN0ZXI6Mzc4NDU5MmUwYzBmMjI0ZTM5OTYw
NWNmYTJkMTU3MGY3OWMwY2MyOTpiaXNlY3Qtc291bmQKCjIwMTMtMTEtMDktMTI6MDk6MTgg
Mzc4NDU5MmUwYzBmMjI0ZTM5OTYwNWNmYTJkMTU3MGY3OWMwY2MyOSBjb21waWxpbmcKMjEx
IHJlYWwgIDE0MTQgdXNlciAgMTQ0IHN5cyAgNzM1LjQzJSBjcHUgCXg4Nl82NC1yYW5kY29u
ZmlnLXg0LTExMDgKCjIwMTMtMTEtMDktMTI6MTM6MjAgZGV0ZWN0aW5nIGJvb3Qgc3RhdGUg
My43LjAtcmMxLTAxMzM5LWczNzg0NTkyLi4JMQk3CTE2CTIzCTI2CTI3IFNVQ0NFU1MKCkJp
c2VjdGluZzogMjQ0IHJldmlzaW9ucyBsZWZ0IHRvIHRlc3QgYWZ0ZXIgdGhpcyAocm91Z2hs
eSA4IHN0ZXBzKQpbOWMwMjhmMGRmNzI5YmE0OTU4ZmU3YjE0MmQ4NTIxYjY2ZWUxNTRkOV0g
TWVyZ2UgYnJhbmNoICdzY2hlZC9jb3JlJwpydW5uaW5nIC9jL2tlcm5lbC10ZXN0cy9iaXNl
Y3QtdGVzdC1ib290LWZhaWx1cmUuc2ggL2hvbWUvd2ZnL3NvdW5kL29iai1iaXNlY3QKbHMg
LWEgL2tlcm5lbC10ZXN0cy9ydW4tcXVldWUva3ZtL3g4Nl82NC1yYW5kY29uZmlnLXg0LTEx
MDgvdGlwOm1hc3Rlcjo5YzAyOGYwZGY3MjliYTQ5NThmZTdiMTQyZDg1MjFiNjZlZTE1NGQ5
OmJpc2VjdC1zb3VuZAoKMjAxMy0xMS0wOS0xMjoxNzoyOSA5YzAyOGYwZGY3MjliYTQ5NThm
ZTdiMTQyZDg1MjFiNjZlZTE1NGQ5IGNvbXBpbGluZwo1MzEgcmVhbCAgMTk0OSB1c2VyICAx
ODggc3lzICA0MDIuMzQlIGNwdSAJeDg2XzY0LXJhbmRjb25maWcteDQtMTEwOAoKMjAxMy0x
MS0wOS0xMjoyNzoyNSBkZXRlY3RpbmcgYm9vdCBzdGF0ZSAzLjEyLjAtMTE5MjUtZzljMDI4
ZjAuLgkxLi4uLgk2LiBURVNUIEZBSUxVUkUKWyAgIDEyLjY4MjY4N10gRUREIGluZm9ybWF0
aW9uIG5vdCBhdmFpbGFibGUuClsgICAxMi42ODM1NjVdIFVucmVnaXN0ZXIgcHYgc2hhcmVk
IG1lbW9yeSBmb3IgY3B1IDAKWyAgIDEyLjg1MjQyM10gaW5wdXQ6IEltRXhQUy8yIEdlbmVy
aWMgRXhwbG9yZXIgTW91c2UgYXMgL2RldmljZXMvcGxhdGZvcm0vaTgwNDIvc2VyaW8xL2lu
cHV0L2lucHV0MwpbICAyNDIuNTgzMzkwXSBJTkZPOiB0YXNrIHN3YXBwZXIvMDoxIGJsb2Nr
ZWQgZm9yIG1vcmUgdGhhbiAxMjAgc2Vjb25kcy4KWyAgMjQyLjU4NDQ5NV0gICAgICAgTm90
IHRhaW50ZWQgMy4xMi4wLTExOTI1LWc5YzAyOGYwICM0MDIKWyAgMjQyLjU4NTM3MV0gImVj
aG8gMCA+IC9wcm9jL3N5cy9rZXJuZWwvaHVuZ190YXNrX3RpbWVvdXRfc2VjcyIgZGlzYWJs
ZXMgdGhpcyBtZXNzYWdlLgpbICAyNDIuNTg2NjQyXSBzd2FwcGVyLzAgICAgICAgRCBmZmZm
ODgwMDBkODhhMDQwICAgICAwICAgICAxICAgICAgMCAweDAwMDAwMDAwClsgIDI0Mi41ODc4
NzRdICBmZmZmODgwMDBkODhkYzEwIDAwMDAwMDAwMDAwMDAwNDYgZmZmZmZmZmY4MjYxZDI2
MCBmZmZmODgwMDBkODhhMDQwClsgIDI0Mi41ODkxODhdICBmZmZmODgwMDBkODhkZmQ4IDAw
MDAwMDAwMDAwMTJhMDAgMDAwMDAwMDAwMDAxMmEwMCBmZmZmZmZmZjgyMWZmNGMwClsgIDI0
Mi41OTA1MDldICBmZmZmODgwMDBkODhhMDQwIGZmZmY4ODAwMGQ4OGEwNDAgZmZmZjg4MDAw
ZDg4MDA2ZiAwMDAwMDAwMDAwMDAwMDAyClsgIDI0Mi41OTE4MDldIENhbGwgVHJhY2U6Clsg
IDI0Mi41OTIyNDRdICBbPGZmZmZmZmZmODExMGU1OTQ+XSA/IF9fbG9ja19hY3F1aXJlKzB4
MWU4NC8weDFmMDAKWyAgMjQyLjU5MzIyOF0gIFs8ZmZmZmZmZmY4MTEwZTU5ND5dID8gX19s
b2NrX2FjcXVpcmUrMHgxZTg0LzB4MWYwMApbICAyNDIuNTk0MjQ1XSAgWzxmZmZmZmZmZjgx
ZDM5Mjc1Pl0gc2NoZWR1bGUrMHg1NS8weDYwClsgIDI0Mi41OTUwNjldICBbPGZmZmZmZmZm
ODFkMzgyY2I+XSBzY2hlZHVsZV90aW1lb3V0KzB4MmIvMHgyMDAKWyAgMjQyLjU5NjAxMl0g
IFs8ZmZmZmZmZmY4MTEwYThjZT5dID8gbWFya19oZWxkX2xvY2tzKzB4MTJlLzB4MTUwClsg
IDI0Mi41OTcwMDNdICBbPGZmZmZmZmZmODFkM2Q5NDc+XSA/IF9yYXdfc3Bpbl91bmxvY2tf
aXJxKzB4MjcvMHg2MApbICAyNDIuNTk4MDE0XSAgWzxmZmZmZmZmZjgxMGY3NTZkPl0gPyBn
ZXRfcGFyZW50X2lwKzB4ZC8weDUwClsgIDI0Mi41OTg5MDBdICBbPGZmZmZmZmZmODEwZjc2
MzM+XSA/IHByZWVtcHRfY291bnRfc3ViKzB4MzMvMHg1MApbICAyNDIuNTk5ODc5XSAgWzxm
ZmZmZmZmZjgxZDM5ZDk3Pl0gd2FpdF9mb3JfY29tbW9uKzB4MTY3LzB4MWIwClsgIDI0Mi42
MDA4NjldICBbPGZmZmZmZmZmODEwZjk0YTA+XSA/IHRyeV90b193YWtlX3VwKzB4MzMwLzB4
MzMwClsgIDI0Mi42MTk5MzZdICBbPGZmZmZmZmZmODExMjRlNTA+XSA/IF9fY2FsbF9yY3Uu
Y29uc3Rwcm9wLjQyKzB4M2QwLzB4M2QwClsgIDI0Mi42MjEwNjNdICBbPGZmZmZmZmZmODFk
MzlmMTg+XSB3YWl0X2Zvcl9jb21wbGV0aW9uKzB4MTgvMHgyMApbICAyNDIuNjIyMDMzXSAg
WzxmZmZmZmZmZjgxMTFlZDc2Pl0gd2FpdF9yY3VfZ3ArMHg0Ni8weDUwClsgIDI0Mi42MjI4
ODJdICBbPGZmZmZmZmZmODExMWViOTA+XSA/IGZ0cmFjZV9yYXdfb3V0cHV0X3JjdV9iYXJy
aWVyKzB4NzAvMHg3MApbICAyNDIuNjI0MDU0XSAgWzxmZmZmZmZmZjgxMTI2NDNjPl0gc3lu
Y2hyb25pemVfcmN1KzB4MmMvMHgzMApbICAyNDIuNjI0OTYwXSAgWzxmZmZmZmZmZjgxZDFi
MWMyPl0gX2NwdV9kb3duKzB4MmIyLzB4MzQwClsgIDI0Mi42MjU4MzRdICBbPGZmZmZmZmZm
ODFkM2EzYmE+XSA/IG11dGV4X2xvY2tfbmVzdGVkKzB4M2RhLzB4NDAwClsgIDI0Mi42MjY4
NDhdICBbPGZmZmZmZmZmODEwNmM5YjI+XSA/IGNwdV9ob3RwbHVnX2RyaXZlcl9sb2NrKzB4
MTIvMHgyMApbICAyNDIuNjI3OTEyXSAgWzxmZmZmZmZmZjgxZDFiMzAxPl0gY3B1X2Rvd24r
MHgzMS8weDUwClsgIDI0Mi42NDk4NThdICBbPGZmZmZmZmZmODFkMTllZTc+XSBfZGVidWdf
aG90cGx1Z19jcHUrMHg0Ny8weGIwClsgIDI0Mi42NTA4NTNdICBbPGZmZmZmZmZmODIzYmYx
NzQ+XSA/IHBjaV9pb21tdV9hbGxvYysweDZjLzB4NmMKWyAgMjQyLjY1MTc4NF0gIFs8ZmZm
ZmZmZmY4MjNiZjE4MT5dIGRlYnVnX2hvdHBsdWdfY3B1KzB4ZC8weDExClsgIDI0Mi42NTI2
OThdICBbPGZmZmZmZmZmODIzYjZlNTQ+XSBkb19vbmVfaW5pdGNhbGwrMHg3ZS8weDExYgpb
ICAyNDIuNjUzNjM0XSAgWzxmZmZmZmZmZjgxMGU5YTVkPl0gPyBwYXJzZV9hcmdzKzB4MWRk
LzB4MzAwClsgIDI0Mi42NTQ1MjFdICBbPGZmZmZmZmZmODIzYjZmZWQ+XSBrZXJuZWxfaW5p
dF9mcmVlYWJsZSsweGZjLzB4MThkClsgIDI0Mi42NTU1MDRdICBbPGZmZmZmZmZmODIzYjY3
ZWM+XSA/IGRvX2Vhcmx5X3BhcmFtKzB4OGEvMHg4YQpbICAyNDIuNjU2NDE5XSAgWzxmZmZm
ZmZmZjgxZDE5ZDIwPl0gPyByZXN0X2luaXQrMHhjMC8weGMwClsgIDI0Mi42NTcyOTddICBb
PGZmZmZmZmZmODFkMTlkMjk+XSBrZXJuZWxfaW5pdCsweDkvMHgxODAKWyAgMjQyLjY3MTI4
MV0gIFs8ZmZmZmZmZmY4MWQzZWQ4Yz5dIHJldF9mcm9tX2ZvcmsrMHg3Yy8weGIwClsgIDI0
Mi42NzIxNTddICBbPGZmZmZmZmZmODFkMTlkMjA+XSA/IHJlc3RfaW5pdCsweGMwLzB4YzAK
WyAgMjQyLjY3MzAyOF0gMyBsb2NrcyBoZWxkIGJ5IHN3YXBwZXIvMC8xOgpbICAyNDIuNjcz
NzMzXSAgIzA6ICAoeDg2X2NwdV9ob3RwbHVnX2RyaXZlcl9tdXRleCl7Ky4rLisufSwgYXQ6
IFs8ZmZmZmZmZmY4MTA2YzliMj5dIGNwdV9ob3RwbHVnX2RyaXZlcl9sb2NrKzB4MTIvMHgy
MApbICAyNDIuNjc1NTMyXSAgIzE6ICAoY3B1X2FkZF9yZW1vdmVfbG9jayl7Ky4rLisufSwg
YXQ6IFs8ZmZmZmZmZmY4MWQxYjJlZD5dIGNwdV9kb3duKzB4MWQvMHg1MApbICAyNDIuNjc3
MDM1XSAgIzI6ICAoY3B1X2hvdHBsdWcubG9jayl7Ky4rLisufSwgYXQ6IFs8ZmZmZmZmZmY4
MTBjY2IwNj5dIGNwdV9ob3RwbHVnX2JlZ2luKzB4MjYvMHg2MApbICAyNDIuNjc4NTkwXSBz
ZW5kaW5nIE5NSSB0byBhbGwgQ1BVczoKWyAgMjQyLjY3OTE5N10gTk1JIGJhY2t0cmFjZSBm
b3IgY3B1IDEKWyAgMjQyLjY3OTc3M10gQ1BVOiAxIFBJRDogMzAgQ29tbToga2h1bmd0YXNr
ZCBOb3QgdGFpbnRlZCAzLjEyLjAtMTE5MjUtZzljMDI4ZjAgIzQwMgpbICAyNDIuNjgwMzU3
XSBIYXJkd2FyZSBuYW1lOiBCb2NocyBCb2NocywgQklPUyBCb2NocyAwMS8wMS8yMDExClsg
IDI0Mi42ODAzNTddIHRhc2s6IGZmZmY4ODAwMDczZGU3YzAgdGk6IGZmZmY4ODAwMDczZWEw
MDAgdGFzay50aTogZmZmZjg4MDAwNzNlYTAwMApbICAyNDIuNjgwMzU3XSBSSVA6IDAwMTA6
WzxmZmZmZmZmZjgxMDczN2ZkPl0gIFs8ZmZmZmZmZmY4MTA3MzdmZD5dIGZsYXRfc2VuZF9J
UElfbWFzaysweDhkLzB4ZDAKWyAgMjQyLjY4MDM1N10gUlNQOiAwMDAwOmZmZmY4ODAwMDcz
ZWJkYjggIEVGTEFHUzogMDAwMDAwNDYKWyAgMjQyLjY4MDM1N10gUkFYOiAwMDAwMDAwMDAz
MDAwMDAwIFJCWDogMDAwMDAwMDAwMDAwMDAwMiBSQ1g6IDAwMDAwMDAwMDAwMDAwMDcKWyAg
MjQyLjY4MDM1N10gUkRYOiAwMDAwMDAwMDAwMDAwYzAwIFJTSTogMDAwMDAwMDAwMDAwMDAw
MSBSREk6IDAwMDAwMDAwMDAwMDAzMDAKWyAgMjQyLjY4MDM1N10gUkJQOiBmZmZmODgwMDA3
M2ViZGQ4IFIwODogMDAwMDAwMDAwMDAwMDAwMCBSMDk6IDAwMDAwMDAwMDAwMDAwMDAKWyAg
MjQyLjY4MDM1N10gUjEwOiAwMDAwMDAwMDAwMDAwMDAxIFIxMTogMDAwMDAwMDAwMDAwMDAw
MSBSMTI6IDAwMDAwMDAwMDAwMDAyNDYKWyAgMjQyLjY4MDM1N10gUjEzOiAwMDAwMDAwMDAw
MDAwYzAwIFIxNDogMDAwMDAwMDAwMDAwMDAwMyBSMTU6IDAwMDAwMDAwMDAwMDAzZmYKWyAg
MjQyLjY4MDM1N10gRlM6ICAwMDAwMDAwMDAwMDAwMDAwKDAwMDApIEdTOmZmZmY4ODAwMGRm
MDAwMDAoMDAwMCkga25sR1M6MDAwMDAwMDAwMDAwMDAwMApbICAyNDIuNjgwMzU3XSBDUzog
IDAwMTAgRFM6IDAwMDAgRVM6IDAwMDAgQ1IwOiAwMDAwMDAwMDgwMDUwMDNiClsgIDI0Mi42
ODAzNTddIENSMjogMDAwMDAwMDBmZmZmZmZmZiBDUjM6IDAwMDAwMDAwMDIxZmEwMDAgQ1I0
OiAwMDAwMDAwMDAwMDAwNmEwClsgIDI0Mi42ODAzNTddIFN0YWNrOgpbICAyNDIuNjgwMzU3
XSAgMDAwMDAwMDAwMDAwMjcxMCBmZmZmODgwMDBkODhhMDQwIDAwMDAwMDAwMDAwMDdmZmYg
ZmZmZjg4MDAwZDg4YTA0MApbICAyNDIuNjgwMzU3XSAgZmZmZjg4MDAwNzNlYmRlOCBmZmZm
ZmZmZjgxMDczODVhIGZmZmY4ODAwMDczZWJlMDAgZmZmZmZmZmY4MTA3MGFiZgpbICAyNDIu
NjgwMzU3XSAgMDAwMDAwMDAwMDAwMDA3OCBmZmZmODgwMDA3M2ViZTY4IGZmZmZmZmZmODEx
M2UxYjggZmZmZmZmZmY4MTEzZGY1YgpbICAyNDIuNjgwMzU3XSBDYWxsIFRyYWNlOgpbICAy
NDIuNjgwMzU3XSAgWzxmZmZmZmZmZjgxMDczODVhPl0gZmxhdF9zZW5kX0lQSV9hbGwrMHgx
YS8weDcwClsgIDI0Mi42ODAzNTddICBbPGZmZmZmZmZmODEwNzBhYmY+XSBhcmNoX3RyaWdn
ZXJfYWxsX2NwdV9iYWNrdHJhY2UrMHg1Zi8weGIwClsgIDI0Mi42ODAzNTddICBbPGZmZmZm
ZmZmODExM2UxYjg+XSB3YXRjaGRvZysweDJkOC8weDNkMApbICAyNDIuNjgwMzU3XSAgWzxm
ZmZmZmZmZjgxMTNkZjViPl0gPyB3YXRjaGRvZysweDdiLzB4M2QwClsgIDI0Mi42ODAzNTdd
ICBbPGZmZmZmZmZmODExM2RlZTA+XSA/IGh1bmdfdGFza19wYW5pYysweDIwLzB4MjAKWyAg
MjQyLjY4MDM1N10gIFs8ZmZmZmZmZmY4MTBlYjQ2MT5dIGt0aHJlYWQrMHhkMS8weGUwClsg
IDI0Mi42ODAzNTddICBbPGZmZmZmZmZmODEwZWIzOTA+XSA/IF9fa3RocmVhZF91bnBhcmsr
MHg1MC8weDUwClsgIDI0Mi42ODAzNTddICBbPGZmZmZmZmZmODFkM2VkOGM+XSByZXRfZnJv
bV9mb3JrKzB4N2MvMHhiMApbICAyNDIuNjgwMzU3XSAgWzxmZmZmZmZmZjgxMGViMzkwPl0g
PyBfX2t0aHJlYWRfdW5wYXJrKzB4NTAvMHg1MApbICAyNDIuNjgwMzU3XSBDb2RlOiBlNiAx
MCA3NSBmMiA0NCA4OSBmMCBjMSBlMCAxOCA4OSAwNCAyNSAxMCBiMyA1YiBmZiA4OSBkYSA0
NCAwOSBlYSA0MSA4MSBjZCAwMCAwNCAwMCAwMCA4MyBmYiAwMiA0MSAwZiA0NCBkNSA4OSAx
NCAyNSAwMCBiMyA1YiBmZiA8NDE+IGY3IGM0IDAwIDAyIDAwIDAwIDc1IDFhIDRjIDg5IGU3
IDU3IDlkIDBmIDFmIDQ0IDAwIDAwIGU4IDRiIAova2VybmVsL3g4Nl82NC1yYW5kY29uZmln
LXg0LTExMDgvOWMwMjhmMGRmNzI5YmE0OTU4ZmU3YjE0MmQ4NTIxYjY2ZWUxNTRkOS9kbWVz
Zy1xdWFudGFsLWxrcC1zdDAxLTg6MjAxMzExMDkyMDI3MTc6eDg2XzY0LXJhbmRjb25maWct
eDQtMTEwODozLjEyLjAtMTE5MjUtZzljMDI4ZjA6NDAyCi9rZXJuZWwveDg2XzY0LXJhbmRj
b25maWcteDQtMTEwOC85YzAyOGYwZGY3MjliYTQ5NThmZTdiMTQyZDg1MjFiNjZlZTE1NGQ5
L2RtZXNnLXF1YW50YWwtcm9hbS0xOjIwMTMxMTA5MTIzMTUxOng4Nl82NC1yYW5kY29uZmln
LXg0LTExMDg6My4xMi4wLTExOTI1LWc5YzAyOGYwOjQwMgo0OjI6NCBhbGxfZ29vZDpiYWQ6
YWxsX2JhZCBib290cwobWzE7MzVtUkVQRUFUIENPVU5UOiA1MCAgIyAvY2Mvd2ZnL3NvdW5k
LWJpc2VjdC8ucmVwZWF0G1swbQoKQmlzZWN0aW5nOiAxMDAgcmV2aXNpb25zIGxlZnQgdG8g
dGVzdCBhZnRlciB0aGlzIChyb3VnaGx5IDcgc3RlcHMpClswNGJiMmY5NDc1MDU0Mjk4ZjBj
NjdhODljYTkyY2FkZTQyZDNmZTVlXSBzY2hlZC9udW1hOiBBZGp1c3Qgc2NhbiByYXRlIGlu
IHRhc2tfbnVtYV9wbGFjZW1lbnQKcnVubmluZyAvYy9rZXJuZWwtdGVzdHMvYmlzZWN0LXRl
c3QtYm9vdC1mYWlsdXJlLnNoIC9ob21lL3dmZy9zb3VuZC9vYmotYmlzZWN0CmxzIC1hIC9r
ZXJuZWwtdGVzdHMvcnVuLXF1ZXVlL2t2bS94ODZfNjQtcmFuZGNvbmZpZy14NC0xMTA4L3Rp
cDptYXN0ZXI6MDRiYjJmOTQ3NTA1NDI5OGYwYzY3YTg5Y2E5MmNhZGU0MmQzZmU1ZTpiaXNl
Y3Qtc291bmQKCjIwMTMtMTEtMDktMTI6MzI6MDIgMDRiYjJmOTQ3NTA1NDI5OGYwYzY3YTg5
Y2E5MmNhZGU0MmQzZmU1ZSBjb21waWxpbmcKMjU4IHJlYWwgIDE5NDEgdXNlciAgMTk4IHN5
cyAgODI4LjUzJSBjcHUgCXg4Nl82NC1yYW5kY29uZmlnLXg0LTExMDgKCjIwMTMtMTEtMDkt
MTI6Mzk6NDYgZGV0ZWN0aW5nIGJvb3Qgc3RhdGUgMy4xMi4wLXJjNC0xMDc3Ny1nMDRiYjJm
OS4uCTEJMTAJMTMJMTgJMjIJMjYJMzQJNDMJNDkJNTAgU1VDQ0VTUwoKQmlzZWN0aW5nOiA1
OSByZXZpc2lvbnMgbGVmdCB0byB0ZXN0IGFmdGVyIHRoaXMgKHJvdWdobHkgNiBzdGVwcykK
W2VjZjFmMDE0MzI1YmE2MGY0ZGYzNWVkYWUxYTM1N2M2N2M1ZDRlYjFdIE1lcmdlIGJyYW5j
aCAnY29yZS9yY3UnIGludG8gY29yZS9sb2NraW5nLCB0byBwcmVwYXJlIHRoZSBrZXJuZWwv
bG9ja2luZy8gZmlsZSBtb3ZlCnJ1bm5pbmcgL2Mva2VybmVsLXRlc3RzL2Jpc2VjdC10ZXN0
LWJvb3QtZmFpbHVyZS5zaCAvaG9tZS93Zmcvc291bmQvb2JqLWJpc2VjdApscyAtYSAva2Vy
bmVsLXRlc3RzL3J1bi1xdWV1ZS9rdm0veDg2XzY0LXJhbmRjb25maWcteDQtMTEwOC90aXA6
bWFzdGVyOmVjZjFmMDE0MzI1YmE2MGY0ZGYzNWVkYWUxYTM1N2M2N2M1ZDRlYjE6YmlzZWN0
LXNvdW5kCgoyMDEzLTExLTA5LTEyOjQ1OjQ4IGVjZjFmMDE0MzI1YmE2MGY0ZGYzNWVkYWUx
YTM1N2M2N2M1ZDRlYjEgY29tcGlsaW5nCjI4MCByZWFsICAxOTM1IHVzZXIgIDE5NiBzeXMg
IDc1OS4yOSUgY3B1IAl4ODZfNjQtcmFuZGNvbmZpZy14NC0xMTA4CgoyMDEzLTExLTA5LTEy
OjUzOjQ2IGRldGVjdGluZyBib290IHN0YXRlIDMuMTIuMC0xMTQ2MC1nZWNmMWYwMS4JMQk0
CTI5CTQ2CTUwIFNVQ0NFU1MKCkJpc2VjdGluZzogMjkgcmV2aXNpb25zIGxlZnQgdG8gdGVz
dCBhZnRlciB0aGlzIChyb3VnaGx5IDUgc3RlcHMpClswMTc2OGI0MmRjOTdhNjdiNGZiMzNh
MjUzNWM0OWZjMTk2OTg4MGRmXSBsb2NraW5nOiBNb3ZlIHRoZSBtdXRleCBjb2RlIHRvIGtl
cm5lbC9sb2NraW5nLwpydW5uaW5nIC9jL2tlcm5lbC10ZXN0cy9iaXNlY3QtdGVzdC1ib290
LWZhaWx1cmUuc2ggL2hvbWUvd2ZnL3NvdW5kL29iai1iaXNlY3QKbHMgLWEgL2tlcm5lbC10
ZXN0cy9ydW4tcXVldWUva3ZtL3g4Nl82NC1yYW5kY29uZmlnLXg0LTExMDgvdGlwOm1hc3Rl
cjowMTc2OGI0MmRjOTdhNjdiNGZiMzNhMjUzNWM0OWZjMTk2OTg4MGRmOmJpc2VjdC1zb3Vu
ZAoKMjAxMy0xMS0wOS0xMjo1Njo0NyAwMTc2OGI0MmRjOTdhNjdiNGZiMzNhMjUzNWM0OWZj
MTk2OTg4MGRmIGNvbXBpbGluZwozMTMgcmVhbCAgMTk0NyB1c2VyICAxOTYgc3lzICA2ODQu
NTclIGNwdSAJeDg2XzY0LXJhbmRjb25maWcteDQtMTEwOAoKMjAxMy0xMS0wOS0xMzowNDox
MiBkZXRlY3RpbmcgYm9vdCBzdGF0ZSAzLjEyLjAtMTE1OTEtZzAxNzY4YjQuCTQJOAkxNgky
MAkyMS4uLiBURVNUIEZBSUxVUkUKQlVHOiBrZXJuZWwgZWFybHkgaGFuZyB3aXRob3V0IGFu
eSBwcmludGsgb3V0cHV0CkNvbW1hbmQgbGluZTogaHVuZ190YXNrX3BhbmljPTEgcmN1dHJl
ZS5yY3VfY3B1X3N0YWxsX3RpbWVvdXQ9MTAwIGxvZ19idWZfbGVuPThNIGlnbm9yZV9sb2ds
ZXZlbCBkZWJ1ZyBzY2hlZF9kZWJ1ZyBhcGljPWRlYnVnIGR5bmFtaWNfcHJpbnRrIHN5c3Jx
X2Fsd2F5c19lbmFibGVkIHBhbmljPTEwICBwcm9tcHRfcmFtZGlzaz0wIGNvbnNvbGU9dHR5
UzAsMTE1MjAwIGNvbnNvbGU9dHR5MCB2Z2E9bm9ybWFsICByb290PS9kZXYvcmFtMCBydyBs
aW5rPS9rZXJuZWwtdGVzdHMvcnVuLXF1ZXVlL2t2bS94ODZfNjQtcmFuZGNvbmZpZy14NC0x
MTA4L3RpcDptYXN0ZXI6MDE3NjhiNDJkYzk3YTY3YjRmYjMzYTI1MzVjNDlmYzE5Njk4ODBk
ZjpiaXNlY3Qtc291bmQvLnZtbGludXotMDE3NjhiNDJkYzk3YTY3YjRmYjMzYTI1MzVjNDlm
YzE5Njk4ODBkZi0yMDEzMTEwOTEzMDQwNi0xOS1hbnQgYnJhbmNoPXRpcC9tYXN0ZXIgQk9P
VF9JTUFHRT0va2VybmVsL3g4Nl82NC1yYW5kY29uZmlnLXg0LTExMDgvMDE3NjhiNDJkYzk3
YTY3YjRmYjMzYTI1MzVjNDlmYzE5Njk4ODBkZi92bWxpbnV6LTMuMTIuMC0xMTU5MS1nMDE3
NjhiNCBub2FwaWMgbm9sYXBpYyBub2h6PW9mZgpFYXJseSBoYW5nIGtlcm5lbDogdm1saW51
ei0zLjEyLjAtMTE1OTEtZzAxNzY4YjQgMy4xMi4wLTExNTkxLWcwMTc2OGI0ICM0MDUKRWxh
cHNlZCB0aW1lOiAzNQova2VybmVsL3g4Nl82NC1yYW5kY29uZmlnLXg0LTExMDgvMDE3Njhi
NDJkYzk3YTY3YjRmYjMzYTI1MzVjNDlmYzE5Njk4ODBkZi9kbWVzZy1xdWFudGFsLWNhaXJv
LTE4OjIwMTMxMTA5MTMwODIwOng4Nl82NC1yYW5kY29uZmlnLXg0LTExMDg6My4xMi4wLTEx
NTkxLWcwMTc2OGI0OjQwNQova2VybmVsL3g4Nl82NC1yYW5kY29uZmlnLXg0LTExMDgvMDE3
NjhiNDJkYzk3YTY3YjRmYjMzYTI1MzVjNDlmYzE5Njk4ODBkZi9kbWVzZy1xdWFudGFsLWlu
bi0zNzoyMDEzMTEwOTEzMDgyMTp4ODZfNjQtcmFuZGNvbmZpZy14NC0xMTA4OjMuMTIuMC0x
MTU5MS1nMDE3NjhiNDo0MDUKL2tlcm5lbC94ODZfNjQtcmFuZGNvbmZpZy14NC0xMTA4LzAx
NzY4YjQyZGM5N2E2N2I0ZmIzM2EyNTM1YzQ5ZmMxOTY5ODgwZGYvZG1lc2cteW9jdG8taW5u
LTY6MjAxMzExMDkxMzA4MTU6eDg2XzY0LXJhbmRjb25maWcteDQtMTEwODozLjEyLjAtMTE1
OTEtZzAxNzY4YjQ6NDA1Ci9rZXJuZWwveDg2XzY0LXJhbmRjb25maWcteDQtMTEwOC8wMTc2
OGI0MmRjOTdhNjdiNGZiMzNhMjUzNWM0OWZjMTk2OTg4MGRmL2RtZXNnLXlvY3RvLXN0b2Fr
bGV5LTU6MjAxMzExMDkxMzA4MjI6eDg2XzY0LXJhbmRjb25maWcteDQtMTEwODozLjEyLjAt
MTE1OTEtZzAxNzY4YjQ6NDA1Ci9rZXJuZWwveDg2XzY0LXJhbmRjb25maWcteDQtMTEwOC8w
MTc2OGI0MmRjOTdhNjdiNGZiMzNhMjUzNWM0OWZjMTk2OTg4MGRmL2RtZXNnLXlvY3RvLWlu
bi03OjIwMTMxMTA5MTMwODI3Ong4Nl82NC1yYW5kY29uZmlnLXg0LTExMDg6My4xMi4wLTEx
NTkxLWcwMTc2OGI0OjQwNQova2VybmVsL3g4Nl82NC1yYW5kY29uZmlnLXg0LTExMDgvMDE3
NjhiNDJkYzk3YTY3YjRmYjMzYTI1MzVjNDlmYzE5Njk4ODBkZi9kbWVzZy1xdWFudGFsLWlu
bi0zNToyMDEzMTEwOTEzMDgyOTp4ODZfNjQtcmFuZGNvbmZpZy14NC0xMTA4OjMuMTIuMC0x
MTU5MS1nMDE3NjhiNDo0MDUKL2tlcm5lbC94ODZfNjQtcmFuZGNvbmZpZy14NC0xMTA4LzAx
NzY4YjQyZGM5N2E2N2I0ZmIzM2EyNTM1YzQ5ZmMxOTY5ODgwZGYvZG1lc2ctcXVhbnRhbC1q
YWtldG93bi05OjIwMTMxMTA5MTMwODMwOng4Nl82NC1yYW5kY29uZmlnLXg0LTExMDg6My4x
Mi4wLTExNTkxLWcwMTc2OGI0OjQwNQova2VybmVsL3g4Nl82NC1yYW5kY29uZmlnLXg0LTEx
MDgvMDE3NjhiNDJkYzk3YTY3YjRmYjMzYTI1MzVjNDlmYzE5Njk4ODBkZi9kbWVzZy15b2N0
by1pbm4tMTI6MjAxMzExMDkxMzA4Mjc6eDg2XzY0LXJhbmRjb25maWcteDQtMTEwODozLjEy
LjAtMTE1OTEtZzAxNzY4YjQ6NDA1Ci9rZXJuZWwveDg2XzY0LXJhbmRjb25maWcteDQtMTEw
OC8wMTc2OGI0MmRjOTdhNjdiNGZiMzNhMjUzNWM0OWZjMTk2OTg4MGRmL2RtZXNnLXlvY3Rv
LWlubi0yOjIwMTMxMTA5MTMwODI4Ong4Nl82NC1yYW5kY29uZmlnLXg0LTExMDg6My4xMi4w
LTExNTkxLWcwMTc2OGI0OjQwNQova2VybmVsL3g4Nl82NC1yYW5kY29uZmlnLXg0LTExMDgv
MDE3NjhiNDJkYzk3YTY3YjRmYjMzYTI1MzVjNDlmYzE5Njk4ODBkZi9kbWVzZy15b2N0by1z
dG9ha2xleS0zOjIwMTMxMTA5MTMwODMyOng4Nl82NC1yYW5kY29uZmlnLXg0LTExMDg6My4x
Mi4wLTExNTkxLWcwMTc2OGI0OjQwNQoxMjoxMDoxOCBhbGxfZ29vZDpiYWQ6YWxsX2JhZCBi
b290cwoKQmlzZWN0aW5nOiAxNCByZXZpc2lvbnMgbGVmdCB0byB0ZXN0IGFmdGVyIHRoaXMg
KHJvdWdobHkgNCBzdGVwcykKW2MyZDgxNjQ0M2VmMzA1YWJhOGVhZjBiZjM2OGY0ZDNkODc0
OTRmMDZdIHNjaGVkL3dhaXQ6IEludHJvZHVjZSBwcmVwYXJlX3RvX3dhaXRfZXZlbnQoKQpy
dW5uaW5nIC9jL2tlcm5lbC10ZXN0cy9iaXNlY3QtdGVzdC1ib290LWZhaWx1cmUuc2ggL2hv
bWUvd2ZnL3NvdW5kL29iai1iaXNlY3QKbHMgLWEgL2tlcm5lbC10ZXN0cy9ydW4tcXVldWUv
a3ZtL3g4Nl82NC1yYW5kY29uZmlnLXg0LTExMDgvdGlwOm1hc3RlcjpjMmQ4MTY0NDNlZjMw
NWFiYThlYWYwYmYzNjhmNGQzZDg3NDk0ZjA2OmJpc2VjdC1zb3VuZAoKMjAxMy0xMS0wOS0x
MzowODo0NyBjMmQ4MTY0NDNlZjMwNWFiYThlYWYwYmYzNjhmNGQzZDg3NDk0ZjA2IGNvbXBp
bGluZwozMjUgcmVhbCAgMTkwNCB1c2VyICAxODggc3lzICA2NDIuNjIlIGNwdSAJeDg2XzY0
LXJhbmRjb25maWcteDQtMTEwOAoKMjAxMy0xMS0wOS0xMzoxNzowNSBkZXRlY3RpbmcgYm9v
dCBzdGF0ZSAzLjEyLjAtcmM0LTEwODU1LWdjMmQ4MTY0Li4uCTIJMwk0Li4uLiBURVNUIEZB
SUxVUkUKQlVHOiBrZXJuZWwgZWFybHkgaGFuZyB3aXRob3V0IGFueSBwcmludGsgb3V0cHV0
CkNvbW1hbmQgbGluZTogaHVuZ190YXNrX3BhbmljPTEgcmN1dHJlZS5yY3VfY3B1X3N0YWxs
X3RpbWVvdXQ9MTAwIGxvZ19idWZfbGVuPThNIGlnbm9yZV9sb2dsZXZlbCBkZWJ1ZyBzY2hl
ZF9kZWJ1ZyBhcGljPWRlYnVnIGR5bmFtaWNfcHJpbnRrIHN5c3JxX2Fsd2F5c19lbmFibGVk
IHBhbmljPTEwICBwcm9tcHRfcmFtZGlzaz0wIGNvbnNvbGU9dHR5UzAsMTE1MjAwIGNvbnNv
bGU9dHR5MCB2Z2E9bm9ybWFsICByb290PS9kZXYvcmFtMCBydyBsaW5rPS9rZXJuZWwtdGVz
dHMvcnVuLXF1ZXVlL2t2bS94ODZfNjQtcmFuZGNvbmZpZy14NC0xMTA4L3RpcDptYXN0ZXI6
YzJkODE2NDQzZWYzMDVhYmE4ZWFmMGJmMzY4ZjRkM2Q4NzQ5NGYwNjpiaXNlY3Qtc291bmQv
LnZtbGludXotYzJkODE2NDQzZWYzMDVhYmE4ZWFmMGJmMzY4ZjRkM2Q4NzQ5NGYwNi0yMDEz
MTEwOTEzMTcwMi0zMS1hbnQgYnJhbmNoPXRpcC9tYXN0ZXIgQk9PVF9JTUFHRT0va2VybmVs
L3g4Nl82NC1yYW5kY29uZmlnLXg0LTExMDgvYzJkODE2NDQzZWYzMDVhYmE4ZWFmMGJmMzY4
ZjRkM2Q4NzQ5NGYwNi92bWxpbnV6LTMuMTIuMC1yYzQtMTA4NTUtZ2MyZDgxNjQgbm9hcGlj
IG5vbGFwaWMgbm9oej1vZmYKRWFybHkgaGFuZyBrZXJuZWw6IHZtbGludXotMy4xMi4wLXJj
NC0xMDg1NS1nYzJkODE2NCAzLjEyLjAtcmM0LTEwODU1LWdjMmQ4MTY0ICM0MDYKRWxhcHNl
ZCB0aW1lOiAzNQova2VybmVsL3g4Nl82NC1yYW5kY29uZmlnLXg0LTExMDgvYzJkODE2NDQz
ZWYzMDVhYmE4ZWFmMGJmMzY4ZjRkM2Q4NzQ5NGYwNi9kbWVzZy15b2N0by1yb2FtLTQ3OjIw
MTMxMTA5MTMyMTIyOng4Nl82NC1yYW5kY29uZmlnLXg0LTExMDg6My4xMi4wLXJjNC0xMDg1
NS1nYzJkODE2NDo0MDYKL2tlcm5lbC94ODZfNjQtcmFuZGNvbmZpZy14NC0xMTA4L2MyZDgx
NjQ0M2VmMzA1YWJhOGVhZjBiZjM2OGY0ZDNkODc0OTRmMDYvZG1lc2cteW9jdG8tcm9hbS00
MzoyMDEzMTEwOTEzMjEzNzp4ODZfNjQtcmFuZGNvbmZpZy14NC0xMTA4OjMuMTIuMC1yYzQt
MTA4NTUtZ2MyZDgxNjQ6NDA2Ci9rZXJuZWwveDg2XzY0LXJhbmRjb25maWcteDQtMTEwOC9j
MmQ4MTY0NDNlZjMwNWFiYThlYWYwYmYzNjhmNGQzZDg3NDk0ZjA2L2RtZXNnLXF1YW50YWwt
YXRoZW5zLTIxOjIwMTMxMTA5MTMyMjAyOng4Nl82NC1yYW5kY29uZmlnLXg0LTExMDg6My4x
Mi4wLXJjNC0xMDg1NS1nYzJkODE2NDo0MDYKMDozOjcgYWxsX2dvb2Q6YmFkOmFsbF9iYWQg
Ym9vdHMKCkJpc2VjdGluZzogNyByZXZpc2lvbnMgbGVmdCB0byB0ZXN0IGFmdGVyIHRoaXMg
KHJvdWdobHkgMyBzdGVwcykKW2VjMGFkM2QwMWY5OWQ1ZTViNTZhOTlhNThmNzAwM2I5OTI1
MGRjNjVdIE1lcmdlIGJyYW5jaCAnY29yZS91cmdlbnQnIGludG8gc2NoZWQvY29yZQpydW5u
aW5nIC9jL2tlcm5lbC10ZXN0cy9iaXNlY3QtdGVzdC1ib290LWZhaWx1cmUuc2ggL2hvbWUv
d2ZnL3NvdW5kL29iai1iaXNlY3QKbHMgLWEgL2tlcm5lbC10ZXN0cy9ydW4tcXVldWUva3Zt
L3g4Nl82NC1yYW5kY29uZmlnLXg0LTExMDgvdGlwOm1hc3RlcjplYzBhZDNkMDFmOTlkNWU1
YjU2YTk5YTU4ZjcwMDNiOTkyNTBkYzY1OmJpc2VjdC1zb3VuZAoKMjAxMy0xMS0wOS0xMzoy
MjowOCBlYzBhZDNkMDFmOTlkNWU1YjU2YTk5YTU4ZjcwMDNiOTkyNTBkYzY1IGNvbXBpbGlu
ZwoyMjYgcmVhbCAgMTkzMiB1c2VyICAxODkgc3lzICA5MzguNTMlIGNwdSAJeDg2XzY0LXJh
bmRjb25maWcteDQtMTEwOAoKMjAxMy0xMS0wOS0xMzoyNjozNiBkZXRlY3RpbmcgYm9vdCBz
dGF0ZSAzLjEyLjAtcmM0LTEwODQ3LWdlYzBhZDNkLi4JMwk2CTEwCTExLi4uLgkxMgkxNAkx
NQkxNgkxNy4JMTkJMjAJMjEuLi4JMjMuLi4JMjQuLi4uLi4uLi4uLi4JMjUuLi4uLi4JMjcu
Li4JMjgJMjkJMzAuLi4uLgkzMS4uCTMyLi4uCTMzCTM0Li4uLi4uLi4uLi4uCTM4CTQwLi4J
NDIJNDcuCTQ4CTQ5CTUwIFNVQ0NFU1MKCkJpc2VjdGluZzogMyByZXZpc2lvbnMgbGVmdCB0
byB0ZXN0IGFmdGVyIHRoaXMgKHJvdWdobHkgMiBzdGVwcykKWzdjM2YyYWI3Yjg0NGYxYTg1
OWFmYmMzZDQxOTI1ZThhMGZhYmE1ZmFdIHNjaGVkL3J0OiBBZGQgbWlzc2luZyBybWIoKQpy
dW5uaW5nIC9jL2tlcm5lbC10ZXN0cy9iaXNlY3QtdGVzdC1ib290LWZhaWx1cmUuc2ggL2hv
bWUvd2ZnL3NvdW5kL29iai1iaXNlY3QKbHMgLWEgL2tlcm5lbC10ZXN0cy9ydW4tcXVldWUv
a3ZtL3g4Nl82NC1yYW5kY29uZmlnLXg0LTExMDgvdGlwOm1hc3Rlcjo3YzNmMmFiN2I4NDRm
MWE4NTlhZmJjM2Q0MTkyNWU4YTBmYWJhNWZhOmJpc2VjdC1zb3VuZAoKMjAxMy0xMS0wOS0x
NDoxMToxMCA3YzNmMmFiN2I4NDRmMWE4NTlhZmJjM2Q0MTkyNWU4YTBmYWJhNWZhIGNvbXBp
bGluZwoyMzQgcmVhbCAgMTg4MCB1c2VyICAxODQgc3lzICA4ODAuMjglIGNwdSAJeDg2XzY0
LXJhbmRjb25maWcteDQtMTEwOAoKMjAxMy0xMS0wOS0xNDoxNToxNyBkZXRlY3RpbmcgYm9v
dCBzdGF0ZSAzLjEyLjAtcmM0LTEwODUxLWc3YzNmMmFiLi4uCTEJMgkzLi4uCTQJNQk4CTku
CTEwLgkxMQkxMgkxMy4JMTQJMTcJMTguLi4uCTE5Li4uLi4uLi4uLgkyMC4uLi4uLi4uLi4u
Li4JMjEuCTIyCTI0CTI1LgkyNi4JMjcJMjkJMzAJMzIJMzUJNDAJNDQJNDYuCTUwIFNVQ0NF
U1MKCkJpc2VjdGluZzogMSByZXZpc2lvbiBsZWZ0IHRvIHRlc3QgYWZ0ZXIgdGhpcyAocm91
Z2hseSAxIHN0ZXApCls2YWNjZTNlZjg0NTIwNTM3ZjhhMDlhMTJjOWRkYmU4MTRhNTg0ZGQy
XSBzY2hlZDogUmVtb3ZlIGdldF9vbmxpbmVfY3B1cygpIHVzYWdlCnJ1bm5pbmcgL2Mva2Vy
bmVsLXRlc3RzL2Jpc2VjdC10ZXN0LWJvb3QtZmFpbHVyZS5zaCAvaG9tZS93Zmcvc291bmQv
b2JqLWJpc2VjdApscyAtYSAva2VybmVsLXRlc3RzL3J1bi1xdWV1ZS9rdm0veDg2XzY0LXJh
bmRjb25maWcteDQtMTEwOC90aXA6bWFzdGVyOjZhY2NlM2VmODQ1MjA1MzdmOGEwOWExMmM5
ZGRiZTgxNGE1ODRkZDI6YmlzZWN0LXNvdW5kCgoyMDEzLTExLTA5LTE0OjUwOjE5IDZhY2Nl
M2VmODQ1MjA1MzdmOGEwOWExMmM5ZGRiZTgxNGE1ODRkZDIgY29tcGlsaW5nCjM3IHJlYWwg
IDc2IHVzZXIgIDQ5IHN5cyAgMzM1LjY2JSBjcHUgCXg4Nl82NC1yYW5kY29uZmlnLXg0LTEx
MDgKCjIwMTMtMTEtMDktMTQ6NTE6MDcgZGV0ZWN0aW5nIGJvb3Qgc3RhdGUgMy4xMi4wLXJj
NC0xMDg1My1nNmFjY2UzZS4uLgk1Li4JOAkxMQkxMyBURVNUIEZBSUxVUkUKQlVHOiBrZXJu
ZWwgZWFybHkgaGFuZyB3aXRob3V0IGFueSBwcmludGsgb3V0cHV0CkNvbW1hbmQgbGluZTog
aHVuZ190YXNrX3BhbmljPTEgcmN1dHJlZS5yY3VfY3B1X3N0YWxsX3RpbWVvdXQ9MTAwIGxv
Z19idWZfbGVuPThNIGlnbm9yZV9sb2dsZXZlbCBkZWJ1ZyBzY2hlZF9kZWJ1ZyBhcGljPWRl
YnVnIGR5bmFtaWNfcHJpbnRrIHN5c3JxX2Fsd2F5c19lbmFibGVkIHBhbmljPTEwICBwcm9t
cHRfcmFtZGlzaz0wIGNvbnNvbGU9dHR5UzAsMTE1MjAwIGNvbnNvbGU9dHR5MCB2Z2E9bm9y
bWFsICByb290PS9kZXYvcmFtMCBydyBsaW5rPS9rZXJuZWwtdGVzdHMvcnVuLXF1ZXVlL2t2
bS94ODZfNjQtcmFuZGNvbmZpZy14NC0xMTA4L3RpcDptYXN0ZXI6NmFjY2UzZWY4NDUyMDUz
N2Y4YTA5YTEyYzlkZGJlODE0YTU4NGRkMjpiaXNlY3Qtc291bmQvLnZtbGludXotNmFjY2Uz
ZWY4NDUyMDUzN2Y4YTA5YTEyYzlkZGJlODE0YTU4NGRkMi0yMDEzMTEwOTE0NTEwNC0zMi1h
bnQgYnJhbmNoPXRpcC9tYXN0ZXIgQk9PVF9JTUFHRT0va2VybmVsL3g4Nl82NC1yYW5kY29u
ZmlnLXg0LTExMDgvNmFjY2UzZWY4NDUyMDUzN2Y4YTA5YTEyYzlkZGJlODE0YTU4NGRkMi92
bWxpbnV6LTMuMTIuMC1yYzQtMTA4NTMtZzZhY2NlM2Ugbm9hcGljIG5vbGFwaWMgbm9oej1v
ZmYKRWFybHkgaGFuZyBrZXJuZWw6IHZtbGludXotMy4xMi4wLXJjNC0xMDg1My1nNmFjY2Uz
ZSAzLjEyLjAtcmM0LTEwODUzLWc2YWNjZTNlICM0MDkKRWxhcHNlZCB0aW1lOiAzNQova2Vy
bmVsL3g4Nl82NC1yYW5kY29uZmlnLXg0LTExMDgvNmFjY2UzZWY4NDUyMDUzN2Y4YTA5YTEy
YzlkZGJlODE0YTU4NGRkMi9kbWVzZy15b2N0by14Z3dvLTU6MjAxMzExMDkyMjUyMzA6eDg2
XzY0LXJhbmRjb25maWcteDQtMTEwODozLjEyLjAtcmM0LTEwODUzLWc2YWNjZTNlOjQwOQox
MToxOjMgYWxsX2dvb2Q6YmFkOmFsbF9iYWQgYm9vdHMKG1sxOzM1bVJFUEVBVCBDT1VOVDog
MTUwICAjIC9jYy93Zmcvc291bmQtYmlzZWN0Ly5yZXBlYXQbWzBtCgpCaXNlY3Rpbmc6IDAg
cmV2aXNpb25zIGxlZnQgdG8gdGVzdCBhZnRlciB0aGlzIChyb3VnaGx5IDAgc3RlcHMpCls3
NDYwMjMxNTljNDBjNTIzYjA4YTNiYzNkMjEzZGFjMjEyMzg1ODk1XSBzY2hlZDogRml4IHJh
Y2UgaW4gbWlncmF0ZV9zd2FwX3N0b3AoKQpydW5uaW5nIC9jL2tlcm5lbC10ZXN0cy9iaXNl
Y3QtdGVzdC1ib290LWZhaWx1cmUuc2ggL2hvbWUvd2ZnL3NvdW5kL29iai1iaXNlY3QKbHMg
LWEgL2tlcm5lbC10ZXN0cy9ydW4tcXVldWUva3ZtL3g4Nl82NC1yYW5kY29uZmlnLXg0LTEx
MDgvdGlwOm1hc3Rlcjo3NDYwMjMxNTljNDBjNTIzYjA4YTNiYzNkMjEzZGFjMjEyMzg1ODk1
OmJpc2VjdC1zb3VuZAoKMjAxMy0xMS0wOS0xNDo1NTozOSA3NDYwMjMxNTljNDBjNTIzYjA4
YTNiYzNkMjEzZGFjMjEyMzg1ODk1IGNvbXBpbGluZwozNiByZWFsICA3MCB1c2VyICA0OSBz
eXMgIDMyNi44NCUgY3B1IAl4ODZfNjQtcmFuZGNvbmZpZy14NC0xMTA4CgoyMDEzLTExLTA5
LTE0OjU2OjQ5IGRldGVjdGluZyBib290IHN0YXRlIDMuMTIuMC1yYzQtMTA4NTItZzc0NjAy
MzEuLgkxCTkJMTAJMTMJMTUJMTgJMjAJMjUJMjkJMzEJMzUJMzYJMzcJMzkuCTQzCTQ0Lgk0
Ngk0OAk0OQk1Mwk1NS4JNTYuLgk1OC4uLgk2MQk2Mi4uLi4JNjMJNjQJNjUuCTY2Lgk2OAk2
OQk3MS4JNzIJNzUuCTc2Lgk3OC4uCTgxCTgzCTg0CTg5CTkxCTkzCTk1CTk5CTEwMwkxMDcJ
MTEwCTExNAkxMTkJMTI4CTEzNAkxNDYJMTUwIFNVQ0NFU1MKCjZhY2NlM2VmODQ1MjA1Mzdm
OGEwOWExMmM5ZGRiZTgxNGE1ODRkZDIgaXMgdGhlIGZpcnN0IGJhZCBjb21taXQKY29tbWl0
IDZhY2NlM2VmODQ1MjA1MzdmOGEwOWExMmM5ZGRiZTgxNGE1ODRkZDIKQXV0aG9yOiBQZXRl
ciBaaWpsc3RyYSA8cGV0ZXJ6QGluZnJhZGVhZC5vcmc+CkRhdGU6ICAgRnJpIE9jdCAxMSAx
NDozODoyMCAyMDEzICswMjAwCgogICAgc2NoZWQ6IFJlbW92ZSBnZXRfb25saW5lX2NwdXMo
KSB1c2FnZQogICAgCiAgICBSZW1vdmUgZ2V0X29ubGluZV9jcHVzKCkgdXNhZ2UgZnJvbSB0
aGUgc2NoZWR1bGVyOyB0aGVyZSdzIDQgc2l0ZXMgdGhhdAogICAgdXNlIGl0OgogICAgCiAg
ICAgLSBzY2hlZF9pbml0X3NtcCgpOyB3aGVyZSBpdHMgY29tcGxldGVseSBzdXBlcmZsdW91
cyBzaW5jZSB3ZSdyZSBpbgogICAgICAgJ2Vhcmx5JyBib290IGFuZCB0aGVyZSBzaW1wbHkg
Y2Fubm90IGJlIGFueSBob3RwbHVnZ2luZy4KICAgIAogICAgIC0gc2NoZWRfZ2V0YWZmaW5p
dHkoKTsgd2UgYWxyZWFkeSB0YWtlIGEgcmF3IHNwaW5sb2NrIHRvIHByb3RlY3QgdGhlCiAg
ICAgICB0YXNrIGNwdXNfYWxsb3dlZCBtYXNrLCB0aGlzIGRpc2FibGVzIHByZWVtcHRpb24g
YW5kIHRoZXJlZm9yZQogICAgICAgYWxzbyBzdGFiaWxpemVzIGNwdV9vbmxpbmVfbWFzayBh
cyB0aGF0J3MgbW9kaWZpZWQgdXNpbmcKICAgICAgIHN0b3BfbWFjaGluZS4gSG93ZXZlciBz
d2l0Y2ggdG8gYWN0aXZlIG1hc2sgZm9yIHN5bW1ldHJ5IHdpdGgKICAgICAgIHNjaGVkX3Nl
dGFmZmluaXR5KCkvc2V0X2NwdXNfYWxsb3dlZF9wdHIoKS4gV2UgZ3VhcmFudGVlIGFjdGl2
ZQogICAgICAgbWFzayBzdGFiaWxpdHkgYnkgaW5zZXJ0aW5nIHN5bmNfcmN1L3NjaGVkKCkg
aW50byBfY3B1X2Rvd24uCiAgICAKICAgICAtIHNjaGVkX3NldGFmZmluaXR5KCk7IHdlIGRv
bid0IGFwcGVhciB0byBuZWVkIGdldF9vbmxpbmVfY3B1cygpCiAgICAgICBlaXRoZXIsIHRo
ZXJlJ3MgdHdvIHNpdGVzIHdoZXJlIGhvdHBsdWcgYXBwZWFycyByZWxldmFudDoKICAgICAg
ICAqIGNwdXNldF9jcHVzX2FsbG93ZWQoKTsgZm9yIHRoZSAhY3B1c2V0IGNhc2Ugd2UgdXNl
IHBvc3NpYmxlX21hc2ssCiAgICAgICAgICBmb3IgdGhlIGNwdXNldCBjYXNlIHdlIGhvbGQg
dGFza19sb2NrLCB3aGljaCBpcyBhIHNwaW5sb2NrIGFuZAogICAgICAgICAgdGh1cyBmb3Ig
bWFpbmxpbmUgZGlzYWJsZXMgcHJlZW1wdGlvbiAobWlnaHQgY2F1c2UgcGFpbiBvbiBSVCku
CiAgICAgICAgKiBzZXRfY3B1c19hbGxvd2VkX3B0cigpOyBIb2xkcyBhbGwgc2NoZWR1bGVy
IGxvY2tzIGFuZCB0aHVzIGhhcwogICAgICAgICAgcHJlZW1wdGlvbiBwcm9wZXJseSBkaXNh
YmxlZDsgYWxzbyBpdCBhbHJlYWR5IGRlYWxzIHdpdGggaG90cGx1ZwogICAgICAgICAgcmFj
ZXMgZXhwbGljaXRseSB3aGVyZSBpdCByZWxlYXNlcyB0aGVtLgogICAgCiAgICAgLSBtaWdy
YXRlX3N3YXAoKTsgd2UgY2FuIG1ha2Ugc3RvcF90d29fY3B1cygpIGRvIHRoZSBoZWF2eSBs
aWZ0aW5nIGZvcgogICAgICAgdXMgd2l0aCBhIGxpdHRsZSB0cmlja2VyeS4gQnkgYWRkaW5n
IGEgc3luY19zY2hlZC9yY3UoKSBhZnRlciB0aGUKICAgICAgIENQVV9ET1dOX1BSRVBBUkUg
bm90aWZpZXIgd2UgY2FuIHByb3ZpZGUgcHJlZW1wdC9yY3UgZ3VhcmFudGVlcyBmb3IKICAg
ICAgIGNwdV9hY3RpdmVfbWFzay4gVXNlIHRoZXNlIHRvIHZhbGlkYXRlIHRoYXQgYm90aCBv
dXIgY3B1cyBhcmUgYWN0aXZlCiAgICAgICB3aGVuIHF1ZXVlaW5nIHRoZSBzdG9wIHdvcmsg
YmVmb3JlIHdlIHF1ZXVlIHRoZSBzdG9wX21hY2hpbmUgd29ya3MKICAgICAgIGZvciB0YWtl
X2NwdV9kb3duKCkuCiAgICAKICAgIFNpZ25lZC1vZmYtYnk6IFBldGVyIFppamxzdHJhIDxw
ZXRlcnpAaW5mcmFkZWFkLm9yZz4KICAgIENjOiAiU3JpdmF0c2EgUy4gQmhhdCIgPHNyaXZh
dHNhLmJoYXRAbGludXgudm5ldC5pYm0uY29tPgogICAgQ2M6IFBhdWwgTWNLZW5uZXkgPHBh
dWxtY2tAbGludXgudm5ldC5pYm0uY29tPgogICAgQ2M6IE1lbCBHb3JtYW4gPG1nb3JtYW5A
c3VzZS5kZT4KICAgIENjOiBSaWsgdmFuIFJpZWwgPHJpZWxAcmVkaGF0LmNvbT4KICAgIENj
OiBTcmlrYXIgRHJvbmFtcmFqdSA8c3Jpa2FyQGxpbnV4LnZuZXQuaWJtLmNvbT4KICAgIENj
OiBBbmRyZWEgQXJjYW5nZWxpIDxhYXJjYW5nZUByZWRoYXQuY29tPgogICAgQ2M6IEpvaGFu
bmVzIFdlaW5lciA8aGFubmVzQGNtcHhjaGcub3JnPgogICAgQ2M6IExpbnVzIFRvcnZhbGRz
IDx0b3J2YWxkc0BsaW51eC1mb3VuZGF0aW9uLm9yZz4KICAgIENjOiBBbmRyZXcgTW9ydG9u
IDxha3BtQGxpbnV4LWZvdW5kYXRpb24ub3JnPgogICAgQ2M6IFN0ZXZlbiBSb3N0ZWR0IDxy
b3N0ZWR0QGdvb2RtaXMub3JnPgogICAgQ2M6IE9sZWcgTmVzdGVyb3YgPG9sZWdAcmVkaGF0
LmNvbT4KICAgIExpbms6IGh0dHA6Ly9sa21sLmtlcm5lbC5vcmcvci8yMDEzMTAxMTEyMzgy
MC5HVjMwODFAdHdpbnMucHJvZ3JhbW1pbmcua2lja3MtYXNzLm5ldAogICAgU2lnbmVkLW9m
Zi1ieTogSW5nbyBNb2xuYXIgPG1pbmdvQGtlcm5lbC5vcmc+Cgo6MDQwMDAwIDA0MDAwMCA5
Zjc0NDczOTM2YmQ0ZTYyMTExNWIyOTZiYjc0N2RmNTM2MGEwM2IyIGFkMTllYTkwMDVhNWFl
OTkyOWY2NGE3N2Q1ZTg4ODMyMDc3ODhkMzQgTQlrZXJuZWwKYmlzZWN0IHJ1biBzdWNjZXNz
CmxzIC1hIC9rZXJuZWwtdGVzdHMvcnVuLXF1ZXVlL2t2bS94ODZfNjQtcmFuZGNvbmZpZy14
NC0xMTA4L3RpcDptYXN0ZXI6NzQ2MDIzMTU5YzQwYzUyM2IwOGEzYmMzZDIxM2RhYzIxMjM4
NTg5NTpiaXNlY3Qtc291bmQKCjIwMTMtMTEtMDktMTU6MzM6NTcgNzQ2MDIzMTU5YzQwYzUy
M2IwOGEzYmMzZDIxM2RhYzIxMjM4NTg5NSByZXVzZSAva2VybmVsL3g4Nl82NC1yYW5kY29u
ZmlnLXg0LTExMDgvNzQ2MDIzMTU5YzQwYzUyM2IwOGEzYmMzZDIxM2RhYzIxMjM4NTg5NS92
bWxpbnV6LTMuMTIuMC1yYzQtMTA4NTItZzc0NjAyMzEKCjIwMTMtMTEtMDktMTU6MzM6NTgg
ZGV0ZWN0aW5nIGJvb3Qgc3RhdGUgLi4JMQkzLgk0CTUuCTEwCTExCTIyCTI3CTM0CTM4CTUw
CTYzCTc3CTgwCTkyCTEwNQkxMTIJMTE4CTEyOQkxNDIJMTU3CTE2MwkxNzQJMTk0CTIwMgky
MDYuCTIxMgkyMTMJMjE2CTIyMAkyMjgJMjI5CTIzNwkyNDAJMjQ3CTI1MQkyNTMJMjYyCTI2
OQkyNzEJMjg3CTMwMQkzMTIJMzMxCTM0NQkzNTUJMzY2CTM4MAkzOTIJMzk3CTQxMAk0MzAJ
NDM3CTQ0NQk0NDkJNDUwIFNVQ0NFU1MKCmxzIC1hIC9rZXJuZWwtdGVzdHMvcnVuLXF1ZXVl
L2t2bS94ODZfNjQtcmFuZGNvbmZpZy14NC0xMTA4L3RpcDptYXN0ZXI6MTkxODY2NGQwYjJi
NmIyYWQ2YjE4MGU3YzA0YTQyODcyYmViNjY5MTpiaXNlY3Qtc291bmQKIFRFU1QgRkFJTFVS
RQpbICAgIDQuOTQxMDkxXSBFREQgaW5mb3JtYXRpb24gbm90IGF2YWlsYWJsZS4KWyAgICA0
Ljk0MTg3MV0gVW5yZWdpc3RlciBwdiBzaGFyZWQgbWVtb3J5IGZvciBjcHUgMApbICAgIDUu
MzI1MzYzXSBpbnB1dDogSW1FeFBTLzIgR2VuZXJpYyBFeHBsb3JlciBNb3VzZSBhcyAvZGV2
aWNlcy9wbGF0Zm9ybS9pODA0Mi9zZXJpbzEvaW5wdXQvaW5wdXQ0ClsgIDI0MS4zMDMzNjBd
IElORk86IHRhc2sgc3dhcHBlci8wOjEgYmxvY2tlZCBmb3IgbW9yZSB0aGFuIDEyMCBzZWNv
bmRzLgpbICAyNDEuMzA0NTUwXSAgICAgICBOb3QgdGFpbnRlZCAzLjEyLjAtMDIwOTgtZzE5
MTg2NjQgIzk4ClsgIDI0MS4zMDU0OTJdICJlY2hvIDAgPiAvcHJvYy9zeXMva2VybmVsL2h1
bmdfdGFza190aW1lb3V0X3NlY3MiIGRpc2FibGVzIHRoaXMgbWVzc2FnZS4KWyAgMjQxLjMw
NjkxNl0gc3dhcHBlci8wICAgICAgIEQgZmZmZjg4MDAwZDhhMjA0MCAgICAgMCAgICAgMSAg
ICAgIDAgMHgwMDAwMDAwMApbICAyNDEuMzA4MjkwXSAgZmZmZjg4MDAwZDhhNWMxMCAwMDAw
MDAwMDAwMDAwMDQ2IGZmZmZmZmZmODI2YWNhNjAgZmZmZjg4MDAwZDhhMjA0MApbICAyNDEu
MzA5NzI4XSAgZmZmZjg4MDAwZDhhNWZkOCAwMDAwMDAwMDAwMDEyYTAwIDAwMDAwMDAwMDAw
MTJhMDAgZmZmZjg4MDAwZmEwYzdjMApbICAyNDEuMzExMjA2XSAgZmZmZjg4MDAwZDhhMjA0
MCBmZmZmODgwMDBkOGEyMDQwIGZmZmY4ODAwMGQ4YTViNjAgMDAwMDAwMDAwMDAwMDAwMgpb
ICAyNDEuMzEyNjQyXSBDYWxsIFRyYWNlOgpbICAyNDEuMzEzMTExXSAgWzxmZmZmZmZmZjgx
MTBlNTQ0Pl0gPyBfX2xvY2tfYWNxdWlyZSsweDFlNzQvMHgxZWYwClsgIDI0MS4zMTQyMjFd
ICBbPGZmZmZmZmZmODExMGU1NDQ+XSA/IF9fbG9ja19hY3F1aXJlKzB4MWU3NC8weDFlZjAK
WyAgMjQxLjMxNTMwN10gIFs8ZmZmZmZmZmY4MWQzOWVhNT5dIHNjaGVkdWxlKzB4NTUvMHg2
MApbICAyNDEuMzE2MjEwXSAgWzxmZmZmZmZmZjgxZDM4ZWZiPl0gc2NoZWR1bGVfdGltZW91
dCsweDJiLzB4MjAwClsgIDI0MS4zMTczMjBdICBbPGZmZmZmZmZmODExMGE4OGU+XSA/IG1h
cmtfaGVsZF9sb2NrcysweDEyZS8weDE1MApbICAyNDEuMzE4MzkwXSAgWzxmZmZmZmZmZjgx
ZDNlNTc3Pl0gPyBfcmF3X3NwaW5fdW5sb2NrX2lycSsweDI3LzB4NjAKWyAgMjQxLjMxOTUw
OF0gIFs8ZmZmZmZmZmY4MTBmNzUzZD5dID8gZ2V0X3BhcmVudF9pcCsweGQvMHg1MApbICAy
NDEuMzIwNTE3XSAgWzxmZmZmZmZmZjgxMGY3NjAzPl0gPyBwcmVlbXB0X2NvdW50X3N1Yisw
eDMzLzB4NTAKWyAgMjQxLjMyMTU3Nl0gIFs8ZmZmZmZmZmY4MWQzYTljNz5dIHdhaXRfZm9y
X2NvbW1vbisweDE2Ny8weDFiMApbICAyNDEuMzIyNjEyXSAgWzxmZmZmZmZmZjgxMGY5NDcw
Pl0gPyB0cnlfdG9fd2FrZV91cCsweDMzMC8weDMzMApbICAyNDEuMzIzNjkzXSAgWzxmZmZm
ZmZmZjgxMTI0ZGYwPl0gPyBfX2NhbGxfcmN1LmNvbnN0cHJvcC40MisweDNkMC8weDNkMApb
ICAyNDEuMzI0ODkzXSAgWzxmZmZmZmZmZjgxZDNhYjQ4Pl0gd2FpdF9mb3JfY29tcGxldGlv
bisweDE4LzB4MjAKWyAgMjQxLjMyNTk2NV0gIFs8ZmZmZmZmZmY4MTExZWQxNj5dIHdhaXRf
cmN1X2dwKzB4NDYvMHg1MApbICAyNDEuMzI2OTM3XSAgWzxmZmZmZmZmZjgxMTFlYjMwPl0g
PyBmdHJhY2VfcmF3X291dHB1dF9yY3VfYmFycmllcisweDcwLzB4NzAKWyAgMjQxLjMyODIy
OF0gIFs8ZmZmZmZmZmY4MTEyNjNkYz5dIHN5bmNocm9uaXplX3JjdSsweDJjLzB4MzAKWyAg
MjQxLjMyOTIzNF0gIFs8ZmZmZmZmZmY4MWQxYmQ4Mj5dIF9jcHVfZG93bisweDJiMi8weDM0
MApbICAyNDEuMzMwMjEzXSAgWzxmZmZmZmZmZjgxZDNhZmVhPl0gPyBtdXRleF9sb2NrX25l
c3RlZCsweDNkYS8weDQwMApbICAyNDEuMzMxMzE5XSAgWzxmZmZmZmZmZjgxMDZjODMyPl0g
PyBjcHVfaG90cGx1Z19kcml2ZXJfbG9jaysweDEyLzB4MjAKWyAgMjQxLjMzMjQ3OF0gIFs8
ZmZmZmZmZmY4MWQxYmVjMT5dIGNwdV9kb3duKzB4MzEvMHg1MApbICAyNDEuMzMzNDA3XSAg
WzxmZmZmZmZmZjgxZDFhYWE3Pl0gX2RlYnVnX2hvdHBsdWdfY3B1KzB4NDcvMHhiMApbICAy
NDEuMzM0NDU5XSAgWzxmZmZmZmZmZjgyNDI1MWYzPl0gPyBwY2lfaW9tbXVfYWxsb2MrMHg2
Yy8weDZjClsgIDI0MS4zMzU0ODJdICBbPGZmZmZmZmZmODI0MjUyMDA+XSBkZWJ1Z19ob3Rw
bHVnX2NwdSsweGQvMHgxMQpbICAyNDEuMzM2NTEwXSAgWzxmZmZmZmZmZjgyNDFjZTU0Pl0g
ZG9fb25lX2luaXRjYWxsKzB4N2UvMHgxMWIKWyAgMjQxLjMzNzYwNl0gIFs8ZmZmZmZmZmY4
MTBlOWExZD5dID8gcGFyc2VfYXJncysweDFkZC8weDMwMApbICAyNDEuMzM4NjA0XSAgWzxm
ZmZmZmZmZjgyNDFjZmVkPl0ga2VybmVsX2luaXRfZnJlZWFibGUrMHhmYy8weDE4ZApbICAy
NDEuMzM5NzAwXSAgWzxmZmZmZmZmZjgyNDFjN2VjPl0gPyBkb19lYXJseV9wYXJhbSsweDhh
LzB4OGEKWyAgMjQxLjM0MDc2MF0gIFs8ZmZmZmZmZmY4MWQxYThlMD5dID8gcmVzdF9pbml0
KzB4YzAvMHhjMApbICAyNDEuMzQxNjk1XSAgWzxmZmZmZmZmZjgxZDFhOGU5Pl0ga2VybmVs
X2luaXQrMHg5LzB4MTgwClsgIDI0MS4zNDI2NThdICBbPGZmZmZmZmZmODFkM2Y5Y2M+XSBy
ZXRfZnJvbV9mb3JrKzB4N2MvMHhiMApbICAyNDEuMzQzNjU3XSAgWzxmZmZmZmZmZjgxZDFh
OGUwPl0gPyByZXN0X2luaXQrMHhjMC8weGMwClsgIDI0MS4zNDY2NzZdIDMgbG9ja3MgaGVs
ZCBieSBzd2FwcGVyLzAvMToKWyAgMjQxLjM0NzQxMF0gICMwOiAgKHg4Nl9jcHVfaG90cGx1
Z19kcml2ZXJfbXV0ZXgpeysuKy4rLn0sIGF0OiBbPGZmZmZmZmZmODEwNmM4MzI+XSBjcHVf
aG90cGx1Z19kcml2ZXJfbG9jaysweDEyLzB4MjAKWyAgMjQxLjM0OTQzMl0gICMxOiAgKGNw
dV9hZGRfcmVtb3ZlX2xvY2speysuKy4rLn0sIGF0OiBbPGZmZmZmZmZmODFkMWJlYWQ+XSBj
cHVfZG93bisweDFkLzB4NTAKWyAgMjQxLjM1MTA5OF0gICMyOiAgKGNwdV9ob3RwbHVnLmxv
Y2speysuKy4rLn0sIGF0OiBbPGZmZmZmZmZmODEwY2NhODY+XSBjcHVfaG90cGx1Z19iZWdp
bisweDI2LzB4NjAKWyAgMjQxLjM1Mjg0N10gc2VuZGluZyBOTUkgdG8gYWxsIENQVXM6Clsg
IDI0MS4zNTM1NDRdIE5NSSBiYWNrdHJhY2UgZm9yIGNwdSAxClsgIDI0MS4zNTQyMTBdIENQ
VTogMSBQSUQ6IDI5IENvbW06IGtodW5ndGFza2QgTm90IHRhaW50ZWQgMy4xMi4wLTAyMDk4
LWcxOTE4NjY0ICM5OApbICAyNDEuMzU1NjA1XSBIYXJkd2FyZSBuYW1lOiBCb2NocyBCb2No
cywgQklPUyBCb2NocyAwMS8wMS8yMDExClsgIDI0MS4zNTY2OTldIHRhc2s6IGZmZmY4ODAw
MDczZmU3ODAgdGk6IGZmZmY4ODAwMGY4MGEwMDAgdGFzay50aTogZmZmZjg4MDAwZjgwYTAw
MApbICAyNDEuMzU2ODQ2XSBSSVA6IDAwMTA6WzxmZmZmZmZmZjgxMDczNzdkPl0gIFs8ZmZm
ZmZmZmY4MTA3Mzc3ZD5dIGZsYXRfc2VuZF9JUElfbWFzaysweDhkLzB4ZDAKWyAgMjQxLjM1
Njg0Nl0gUlNQOiAwMDAwOmZmZmY4ODAwMGY4MGJkYjggIEVGTEFHUzogMDAwMTAwNDYKWyAg
MjQxLjM1Njg0Nl0gUkFYOiAwMDAwMDAwMDAzMDAwMDAwIFJCWDogMDAwMDAwMDAwMDAwMDAw
MiBSQ1g6IDAwMDAwMDAwMDAwMDAwMDcKWyAgMjQxLjM1Njg0Nl0gUkRYOiAwMDAwMDAwMDAw
MDAwYzAwIFJTSTogMDAwMDAwMDAwMDAwMDAwMSBSREk6IDAwMDAwMDAwMDAwMDAzMDAKWyAg
MjQxLjM1Njg0Nl0gUkJQOiBmZmZmODgwMDBmODBiZGQ4IFIwODogMDAwMDAwMDAwMDAwMDAw
MCBSMDk6IDAwMDAwMDAwMDAwMDAwMDAKWyAgMjQxLjM1Njg0Nl0gUjEwOiAwMDAwMDAwMDAw
MDAwMDAxIFIxMTogMDAwMDAwMDAwMDAwMDAwMSBSMTI6IDAwMDAwMDAwMDAwMDAyNDYKWyAg
MjQxLjM1Njg0Nl0gUjEzOiAwMDAwMDAwMDAwMDAwYzAwIFIxNDogMDAwMDAwMDAwMDAwMDAw
MyBSMTU6IDAwMDAwMDAwMDAwMDAzZmYKWyAgMjQxLjM1Njg0Nl0gRlM6ICAwMDAwMDAwMDAw
MDAwMDAwKDAwMDApIEdTOmZmZmY4ODAwMGRkMDAwMDAoMDAwMCkga25sR1M6MDAwMDAwMDAw
MDAwMDAwMApbICAyNDEuMzU2ODQ2XSBDUzogIDAwMTAgRFM6IDAwMDAgRVM6IDAwMDAgQ1Iw
OiAwMDAwMDAwMDgwMDUwMDNiClsgIDI0MS4zNTY4NDZdIENSMjogMDAwMDAwMDBmZmZmZmZm
ZiBDUjM6IDAwMDAwMDAwMDIyMDYwMDAgQ1I0OiAwMDAwMDAwMDAwMDAwNmEwClsgIDI0MS4z
NTY4NDZdIFN0YWNrOgpbICAyNDEuMzU2ODQ2XSAgMDAwMDAwMDAwMDAwMjcxMCBmZmZmODgw
MDBkOGEyMDQwIDAwMDAwMDAwMDAwMDdmZmYgZmZmZjg4MDAwZDhhMjA0MApbICAyNDEuMzU2
ODQ2XSAgZmZmZjg4MDAwZjgwYmRlOCBmZmZmZmZmZjgxMDczN2RhIGZmZmY4ODAwMGY4MGJl
MDAgZmZmZmZmZmY4MTA3MGEzZgpbICAyNDEuMzU2ODQ2XSAgMDAwMDAwMDAwMDAwMDA3OCBm
ZmZmODgwMDBmODBiZTY4IGZmZmZmZmZmODExM2UxYTggZmZmZmZmZmY4MTEzZGY0YgpbICAy
NDEuMzU2ODQ2XSBDYWxsIFRyYWNlOgpbICAyNDEuMzU2ODQ2XSAgWzxmZmZmZmZmZjgxMDcz
N2RhPl0gZmxhdF9zZW5kX0lQSV9hbGwrMHgxYS8weDcwClsgIDI0MS4zNTY4NDZdICBbPGZm
ZmZmZmZmODEwNzBhM2Y+XSBhcmNoX3RyaWdnZXJfYWxsX2NwdV9iYWNrdHJhY2UrMHg1Zi8w
eGIwClsgIDI0MS4zNTY4NDZdICBbPGZmZmZmZmZmODExM2UxYTg+XSB3YXRjaGRvZysweDJk
OC8weDNkMApbICAyNDEuMzU2ODQ2XSAgWzxmZmZmZmZmZjgxMTNkZjRiPl0gPyB3YXRjaGRv
ZysweDdiLzB4M2QwClsgIDI0MS4zNTY4NDZdICBbPGZmZmZmZmZmODExM2RlZDA+XSA/IGh1
bmdfdGFza19wYW5pYysweDIwLzB4MjAKWyAgMjQxLjM1Njg0Nl0gIFs8ZmZmZmZmZmY4MTBl
YjQzMT5dIGt0aHJlYWQrMHhkMS8weGUwClsgIDI0MS4zNTY4NDZdICBbPGZmZmZmZmZmODFk
M2U1Nzc+XSA/IF9yYXdfc3Bpbl91bmxvY2tfaXJxKzB4MjcvMHg2MApbICAyNDEuMzU2ODQ2
XSAgWzxmZmZmZmZmZjgxMGViMzYwPl0gPyBfX2t0aHJlYWRfdW5wYXJrKzB4NTAvMHg1MApb
ICAyNDEuMzU2ODQ2XSAgWzxmZmZmZmZmZjgxZDNmOWNjPl0gcmV0X2Zyb21fZm9yaysweDdj
LzB4YjAKWyAgMjQxLjM1Njg0Nl0gIFs8ZmZmZmZmZmY4MTBlYjM2MD5dID8gX19rdGhyZWFk
X3VucGFyaysweDUwLzB4NTAKWyAgMjQxLjM1Njg0Nl0gQ29kZTogZTYgMTAgNzUgZjIgNDQg
ODkgZjAgYzEgZTAgMTggODkgMDQgMjUgMTAgYjMgNTcgZmYgODkgZGEgNDQgMDkgZWEgNDEg
ODEgY2QgMDAgMDQgMDAgMDAgODMgZmIgMDIgNDEgMGYgNDQgZDUgODkgMTQgMjUgMDAgYjMg
NTcgZmYgPDQxPiBmNyBjNCAwMCAwMiAwMCAwMCA3NSAxYSA0YyA4OSBlNyA1NyA5ZCAwZiAx
ZiA0NCAwMCAwMCBlOCA4YiAKL2tlcm5lbC94ODZfNjQtcmFuZGNvbmZpZy14NC0xMTA4LzE5
MTg2NjRkMGIyYjZiMmFkNmIxODBlN2MwNGE0Mjg3MmJlYjY2OTEvZG1lc2cteW9jdG8tamFr
ZXRvd24tMjA6MjAxMzExMDgyMjMwMzI6eDg2XzY0LXJhbmRjb25maWcteDQtMTEwODozLjEy
LjAtMDIwOTgtZzE5MTg2NjQ6OTgKL2tlcm5lbC94ODZfNjQtcmFuZGNvbmZpZy14NC0xMTA4
LzE5MTg2NjRkMGIyYjZiMmFkNmIxODBlN2MwNGE0Mjg3MmJlYjY2OTEvZG1lc2cteW9jdG8t
c3RvYWtsZXktNDoyMDEzMTEwODIyMzA1MTp4ODZfNjQtcmFuZGNvbmZpZy14NC0xMTA4OjMu
MTIuMC0wMjA5OC1nMTkxODY2NDo5OAova2VybmVsL3g4Nl82NC1yYW5kY29uZmlnLXg0LTEx
MDgvMTkxODY2NGQwYjJiNmIyYWQ2YjE4MGU3YzA0YTQyODcyYmViNjY5MS9kbWVzZy15b2N0
by1yb2FtLTM6MjAxMzExMDkxMTEwNTc6eDg2XzY0LXJhbmRjb25maWcteDQtMTEwODozLjEy
LjAtMDIwOTgtZzE5MTg2NjQ6OTgKL2tlcm5lbC94ODZfNjQtcmFuZGNvbmZpZy14NC0xMTA4
LzE5MTg2NjRkMGIyYjZiMmFkNmIxODBlN2MwNGE0Mjg3MmJlYjY2OTEvZG1lc2cteW9jdG8t
d2FpbWVhLTE6MjAxMzExMDkxOTA4MDM6eDg2XzY0LXJhbmRjb25maWcteDQtMTEwODozLjEy
LjAtMDIwOTgtZzE5MTg2NjQ6OTgKL2tlcm5lbC94ODZfNjQtcmFuZGNvbmZpZy14NC0xMTA4
LzE5MTg2NjRkMGIyYjZiMmFkNmIxODBlN2MwNGE0Mjg3MmJlYjY2OTEvZG1lc2cteW9jdG8t
c3RvYWtsZXktNjoyMDEzMTEwODIyMzA1NDp4ODZfNjQtcmFuZGNvbmZpZy14NC0xMTA4OjMu
MTIuMC0wMjA5OC1nMTkxODY2NDo5OAova2VybmVsL3g4Nl82NC1yYW5kY29uZmlnLXg0LTEx
MDgvMTkxODY2NGQwYjJiNmIyYWQ2YjE4MGU3YzA0YTQyODcyYmViNjY5MS9kbWVzZy15b2N0
by1zdG9ha2xleS0yOjIwMTMxMTA4MjIzNTE0Ong4Nl82NC1yYW5kY29uZmlnLXg0LTExMDg6
My4xMi4wLTAyMDk4LWcxOTE4NjY0Ojk4Ci9rZXJuZWwveDg2XzY0LXJhbmRjb25maWcteDQt
MTEwOC8xOTE4NjY0ZDBiMmI2YjJhZDZiMTgwZTdjMDRhNDI4NzJiZWI2NjkxL2RtZXNnLXF1
YW50YWwtbGtwLXR0MDItMTU6MjAxMzExMDkwMjAxMDY6eDg2XzY0LXJhbmRjb25maWcteDQt
MTEwODozLjEyLjAtMDIwOTgtZzE5MTg2NjQ6OTgKL2tlcm5lbC94ODZfNjQtcmFuZGNvbmZp
Zy14NC0xMTA4LzE5MTg2NjRkMGIyYjZiMmFkNmIxODBlN2MwNGE0Mjg3MmJlYjY2OTEvZG1l
c2ctcXVhbnRhbC1hdGhlbnMtMzU6MjAxMzExMDkxMTA5NDY6eDg2XzY0LXJhbmRjb25maWct
eDQtMTEwODozLjEyLjAtMDIwOTgtZzE5MTg2NjQ6OTgKL2tlcm5lbC94ODZfNjQtcmFuZGNv
bmZpZy14NC0xMTA4LzE5MTg2NjRkMGIyYjZiMmFkNmIxODBlN2MwNGE0Mjg3MmJlYjY2OTEv
ZG1lc2ctcXVhbnRhbC14cHMtNToyMDEzMTEwOTA2MzM0Mjp4ODZfNjQtcmFuZGNvbmZpZy14
NC0xMTA4OjMuMTIuMC0wMjA5OC1nMTkxODY2NDo5OAova2VybmVsL3g4Nl82NC1yYW5kY29u
ZmlnLXg0LTExMDgvMTkxODY2NGQwYjJiNmIyYWQ2YjE4MGU3YzA0YTQyODcyYmViNjY5MS9k
bWVzZy15b2N0by1zdG9ha2xleS0yOjIwMTMxMTA4MjIzMDQ0Ong4Nl82NC1yYW5kY29uZmln
LXg0LTExMDg6My4xMi4wLTAyMDk4LWcxOTE4NjY0Ojk4Ci9rZXJuZWwveDg2XzY0LXJhbmRj
b25maWcteDQtMTEwOC8xOTE4NjY0ZDBiMmI2YjJhZDZiMTgwZTdjMDRhNDI4NzJiZWI2Njkx
L2RtZXNnLXF1YW50YWwtc3RvYWtsZXktNjoyMDEzMTEwODIyMzMzMjp4ODZfNjQtcmFuZGNv
bmZpZy14NC0xMTA4OjMuMTIuMC0wMjA5OC1nMTkxODY2NDo5OAova2VybmVsL3g4Nl82NC1y
YW5kY29uZmlnLXg0LTExMDgvMTkxODY2NGQwYjJiNmIyYWQ2YjE4MGU3YzA0YTQyODcyYmVi
NjY5MS9kbWVzZy15b2N0by1sa3Atc3QwMS01OjIwMTMxMTA5MDYyNjE5Ong4Nl82NC1yYW5k
Y29uZmlnLXg0LTExMDg6My4xMi4wLTAyMDk4LWcxOTE4NjY0Ojk4Cjc6MTI6MTIgYWxsX2dv
b2Q6YmFkOmFsbF9iYWQgYm9vdHMKCltkZXRhY2hlZCBIRUFEIDFhZTE4MjBdIFJldmVydCAi
c2NoZWQ6IFJlbW92ZSBnZXRfb25saW5lX2NwdXMoKSB1c2FnZSIKIDMgZmlsZXMgY2hhbmdl
ZCwgMTUgaW5zZXJ0aW9ucygrKSwgNDggZGVsZXRpb25zKC0pCmxzIC1hIC9rZXJuZWwtdGVz
dHMvcnVuLXF1ZXVlL2t2bS94ODZfNjQtcmFuZGNvbmZpZy14NC0xMTA4L3RpcDptYXN0ZXI6
MWFlMTgyMGJmZTNmMDk2NGNmNGJjM2M1NjI4MDU1MzMwZTNjYzUzODpiaXNlY3Qtc291bmQK
CjIwMTMtMTEtMDktMTY6MDQ6MzIgMWFlMTgyMGJmZTNmMDk2NGNmNGJjM2M1NjI4MDU1MzMw
ZTNjYzUzOCBjb21waWxpbmcKCjIwMTMtMTEtMDktMTY6MDg6NDUgZGV0ZWN0aW5nIGJvb3Qg
c3RhdGUgMy4xMi4wLTEzNTE4LWcxYWUxODIwLi4uCTMuLgk2CTcJMTYJMjQJMzYJNTYJNzgJ
OTgJMTE4CTE0MAkxNjMJMTgxCTE5OAkyMTIJMjM0CTI1MQkyNzAJMjc3CTI4MgkyOTcJMzEy
CTMxNwkzMjMJMzI2CTMzMAkzMzIuCTM0MQkzNDIJMzQ0CTM0NS4uCTM0NgkzNDgJMzUwCTM1
MQkzNTMuCTM1NS4JMzU3CTM2MAkzNjIJMzY1CTM2NgkzNjcJMzY4CTM3MAkzNzEJMzczLgkz
NzQJMzc2CTM3NwkzNzgJMzgxLgkzODIJMzg0CTM4NQkzOTAJMzkxCTM5Nwk0MDAJNDAzCTQw
OQk0MTMJNDIyCTQzNAk0NDIJNDUwIFNVQ0NFU1MKCgo9PT09PT09PT0gdXBzdHJlYW0gPT09
PT09PT09CkZldGNoaW5nIGxpbnVzCmxzIC1hIC9rZXJuZWwtdGVzdHMvcnVuLXF1ZXVlL2t2
bS94ODZfNjQtcmFuZGNvbmZpZy14NC0xMTA4L3RpcDptYXN0ZXI6NmM4NmFlMjkyOGY5ZTRj
YmYwZDU4NDRmNWZjZmQ1NDllMzQ1MGI4YzpiaXNlY3Qtc291bmQKCjIwMTMtMTEtMDktMTY6
NDc6NTEgNmM4NmFlMjkyOGY5ZTRjYmYwZDU4NDRmNWZjZmQ1NDllMzQ1MGI4YyBjb21waWxp
bmcKCjIwMTMtMTEtMDktMTY6NTE6NTIgZGV0ZWN0aW5nIGJvb3Qgc3RhdGUgMy4xMi4wLTEz
MzM0LWc2Yzg2YWUyLi4JMQk1CTkJMTQuCTI5CTMzCTM2CTM3CTQyCTQ5CTU2CTY2CTcyCTg3
CTk2CTEwNwkxMDgJMTEzCTEyNQkxMzMJMTM5CTE1MAkxNjAJMTY3CTE3NAkxNzgJMTgzCTE5
MgkxOTYJMjA3CTIwOQkyMjMJMjI5CTIzNgkyNDUJMjU4CTI2NQkyNzUJMjgxCTI5MAkyOTgJ
MzA5CTMxOAkzMjIJMzI1CTMzMgkzMzUJMzQxCTM0NgkzNDkJMzUwCTM1MgkzNTMuCTM1NC4J
MzYyCTM3MAkzNzcJMzk0CTQwMgk0MTMJNDI3CTQzNAk0MzcJNDQzCTQ1MCBTVUNDRVNTCgoK
PT09PT09PT09IGxpbnV4LW5leHQgPT09PT09PT09CkZldGNoaW5nIG5leHQKbHMgLWEgL2tl
cm5lbC10ZXN0cy9ydW4tcXVldWUva3ZtL3g4Nl82NC1yYW5kY29uZmlnLXg0LTExMDgvdGlw
Om1hc3RlcjpiYWQ1NzBkNzcwMjRjYmE4MDgxMjZkNjhhMjA3MmY2ZjhjZTY0YzI3OmJpc2Vj
dC1zb3VuZAoKMjAxMy0xMS0wOS0xNzoyNzoyOSBiYWQ1NzBkNzcwMjRjYmE4MDgxMjZkNjhh
MjA3MmY2ZjhjZTY0YzI3IGNvbXBpbGluZwoKMjAxMy0xMS0wOS0xNzozMjowMyBkZXRlY3Rp
bmcgYm9vdCBzdGF0ZSAzLjEyLjAtbmV4dC0yMDEzMTEwOC0yMjAyMC1nYmFkNTcwZC4uCTIJ
Mwk5CTEyCTE2CTIxCTI2CTMyIFRFU1QgRkFJTFVSRQpCVUc6IGtlcm5lbCBlYXJseSBoYW5n
IHdpdGhvdXQgYW55IHByaW50ayBvdXRwdXQKQ29tbWFuZCBsaW5lOiBodW5nX3Rhc2tfcGFu
aWM9MSByY3V0cmVlLnJjdV9jcHVfc3RhbGxfdGltZW91dD0xMDAgbG9nX2J1Zl9sZW49OE0g
aWdub3JlX2xvZ2xldmVsIGRlYnVnIHNjaGVkX2RlYnVnIGFwaWM9ZGVidWcgZHluYW1pY19w
cmludGsgc3lzcnFfYWx3YXlzX2VuYWJsZWQgcGFuaWM9MTAgIHByb21wdF9yYW1kaXNrPTAg
Y29uc29sZT10dHlTMCwxMTUyMDAgY29uc29sZT10dHkwIHZnYT1ub3JtYWwgIHJvb3Q9L2Rl
di9yYW0wIHJ3IGxpbms9L2tlcm5lbC10ZXN0cy9ydW4tcXVldWUva3ZtL3g4Nl82NC1yYW5k
Y29uZmlnLXg0LTExMDgvdGlwOm1hc3RlcjpiYWQ1NzBkNzcwMjRjYmE4MDgxMjZkNjhhMjA3
MmY2ZjhjZTY0YzI3OmJpc2VjdC1zb3VuZC8udm1saW51ei1iYWQ1NzBkNzcwMjRjYmE4MDgx
MjZkNjhhMjA3MmY2ZjhjZTY0YzI3LTIwMTMxMTA5MTczMTU5LTIyMS1hbnQgYnJhbmNoPXRp
cC9tYXN0ZXIgQk9PVF9JTUFHRT0va2VybmVsL3g4Nl82NC1yYW5kY29uZmlnLXg0LTExMDgv
YmFkNTcwZDc3MDI0Y2JhODA4MTI2ZDY4YTIwNzJmNmY4Y2U2NGMyNy92bWxpbnV6LTMuMTIu
MC1uZXh0LTIwMTMxMTA4LTIyMDIwLWdiYWQ1NzBkIG5vYXBpYyBub2xhcGljIG5vaHo9b2Zm
CkVhcmx5IGhhbmcga2VybmVsOiB2bWxpbnV6LTMuMTIuMC1uZXh0LTIwMTMxMTA4LTIyMDIw
LWdiYWQ1NzBkIDMuMTIuMC1uZXh0LTIwMTMxMTA4LTIyMDIwLWdiYWQ1NzBkICM0MTMKRWxh
cHNlZCB0aW1lOiAzNQova2VybmVsL3g4Nl82NC1yYW5kY29uZmlnLXg0LTExMDgvYmFkNTcw
ZDc3MDI0Y2JhODA4MTI2ZDY4YTIwNzJmNmY4Y2U2NGMyNy9kbWVzZy1xdWFudGFsLWlubi0y
NzoyMDEzMTEwOTE3MzY1NTp4ODZfNjQtcmFuZGNvbmZpZy14NC0xMTA4OjMuMTIuMC1uZXh0
LTIwMTMxMTA4LTIyMDIwLWdiYWQ1NzBkOjQxMwoxNzoxOjE2IGFsbF9nb29kOmJhZDphbGxf
YmFkIGJvb3RzCgoKPT09PT09PT09IHRpcC9tYXN0ZXIgPT09PT09PT09CkZldGNoaW5nIHRp
cApscyAtYSAva2VybmVsLXRlc3RzL3J1bi1xdWV1ZS9rdm0veDg2XzY0LXJhbmRjb25maWct
eDQtMTEwOC90aXA6bWFzdGVyOjE5MTg2NjRkMGIyYjZiMmFkNmIxODBlN2MwNGE0Mjg3MmJl
YjY2OTE6YmlzZWN0LXNvdW5kCiBURVNUIEZBSUxVUkUKWyAgICA0Ljk0MTA5MV0gRUREIGlu
Zm9ybWF0aW9uIG5vdCBhdmFpbGFibGUuClsgICAgNC45NDE4NzFdIFVucmVnaXN0ZXIgcHYg
c2hhcmVkIG1lbW9yeSBmb3IgY3B1IDAKWyAgICA1LjMyNTM2M10gaW5wdXQ6IEltRXhQUy8y
IEdlbmVyaWMgRXhwbG9yZXIgTW91c2UgYXMgL2RldmljZXMvcGxhdGZvcm0vaTgwNDIvc2Vy
aW8xL2lucHV0L2lucHV0NApbICAyNDEuMzAzMzYwXSBJTkZPOiB0YXNrIHN3YXBwZXIvMDox
IGJsb2NrZWQgZm9yIG1vcmUgdGhhbiAxMjAgc2Vjb25kcy4KWyAgMjQxLjMwNDU1MF0gICAg
ICAgTm90IHRhaW50ZWQgMy4xMi4wLTAyMDk4LWcxOTE4NjY0ICM5OApbICAyNDEuMzA1NDky
XSAiZWNobyAwID4gL3Byb2Mvc3lzL2tlcm5lbC9odW5nX3Rhc2tfdGltZW91dF9zZWNzIiBk
aXNhYmxlcyB0aGlzIG1lc3NhZ2UuClsgIDI0MS4zMDY5MTZdIHN3YXBwZXIvMCAgICAgICBE
IGZmZmY4ODAwMGQ4YTIwNDAgICAgIDAgICAgIDEgICAgICAwIDB4MDAwMDAwMDAKWyAgMjQx
LjMwODI5MF0gIGZmZmY4ODAwMGQ4YTVjMTAgMDAwMDAwMDAwMDAwMDA0NiBmZmZmZmZmZjgy
NmFjYTYwIGZmZmY4ODAwMGQ4YTIwNDAKWyAgMjQxLjMwOTcyOF0gIGZmZmY4ODAwMGQ4YTVm
ZDggMDAwMDAwMDAwMDAxMmEwMCAwMDAwMDAwMDAwMDEyYTAwIGZmZmY4ODAwMGZhMGM3YzAK
WyAgMjQxLjMxMTIwNl0gIGZmZmY4ODAwMGQ4YTIwNDAgZmZmZjg4MDAwZDhhMjA0MCBmZmZm
ODgwMDBkOGE1YjYwIDAwMDAwMDAwMDAwMDAwMDIKWyAgMjQxLjMxMjY0Ml0gQ2FsbCBUcmFj
ZToKWyAgMjQxLjMxMzExMV0gIFs8ZmZmZmZmZmY4MTEwZTU0ND5dID8gX19sb2NrX2FjcXVp
cmUrMHgxZTc0LzB4MWVmMApbICAyNDEuMzE0MjIxXSAgWzxmZmZmZmZmZjgxMTBlNTQ0Pl0g
PyBfX2xvY2tfYWNxdWlyZSsweDFlNzQvMHgxZWYwClsgIDI0MS4zMTUzMDddICBbPGZmZmZm
ZmZmODFkMzllYTU+XSBzY2hlZHVsZSsweDU1LzB4NjAKWyAgMjQxLjMxNjIxMF0gIFs8ZmZm
ZmZmZmY4MWQzOGVmYj5dIHNjaGVkdWxlX3RpbWVvdXQrMHgyYi8weDIwMApbICAyNDEuMzE3
MzIwXSAgWzxmZmZmZmZmZjgxMTBhODhlPl0gPyBtYXJrX2hlbGRfbG9ja3MrMHgxMmUvMHgx
NTAKWyAgMjQxLjMxODM5MF0gIFs8ZmZmZmZmZmY4MWQzZTU3Nz5dID8gX3Jhd19zcGluX3Vu
bG9ja19pcnErMHgyNy8weDYwClsgIDI0MS4zMTk1MDhdICBbPGZmZmZmZmZmODEwZjc1M2Q+
XSA/IGdldF9wYXJlbnRfaXArMHhkLzB4NTAKWyAgMjQxLjMyMDUxN10gIFs8ZmZmZmZmZmY4
MTBmNzYwMz5dID8gcHJlZW1wdF9jb3VudF9zdWIrMHgzMy8weDUwClsgIDI0MS4zMjE1NzZd
ICBbPGZmZmZmZmZmODFkM2E5Yzc+XSB3YWl0X2Zvcl9jb21tb24rMHgxNjcvMHgxYjAKWyAg
MjQxLjMyMjYxMl0gIFs8ZmZmZmZmZmY4MTBmOTQ3MD5dID8gdHJ5X3RvX3dha2VfdXArMHgz
MzAvMHgzMzAKWyAgMjQxLjMyMzY5M10gIFs8ZmZmZmZmZmY4MTEyNGRmMD5dID8gX19jYWxs
X3JjdS5jb25zdHByb3AuNDIrMHgzZDAvMHgzZDAKWyAgMjQxLjMyNDg5M10gIFs8ZmZmZmZm
ZmY4MWQzYWI0OD5dIHdhaXRfZm9yX2NvbXBsZXRpb24rMHgxOC8weDIwClsgIDI0MS4zMjU5
NjVdICBbPGZmZmZmZmZmODExMWVkMTY+XSB3YWl0X3JjdV9ncCsweDQ2LzB4NTAKWyAgMjQx
LjMyNjkzN10gIFs8ZmZmZmZmZmY4MTExZWIzMD5dID8gZnRyYWNlX3Jhd19vdXRwdXRfcmN1
X2JhcnJpZXIrMHg3MC8weDcwClsgIDI0MS4zMjgyMjhdICBbPGZmZmZmZmZmODExMjYzZGM+
XSBzeW5jaHJvbml6ZV9yY3UrMHgyYy8weDMwClsgIDI0MS4zMjkyMzRdICBbPGZmZmZmZmZm
ODFkMWJkODI+XSBfY3B1X2Rvd24rMHgyYjIvMHgzNDAKWyAgMjQxLjMzMDIxM10gIFs8ZmZm
ZmZmZmY4MWQzYWZlYT5dID8gbXV0ZXhfbG9ja19uZXN0ZWQrMHgzZGEvMHg0MDAKWyAgMjQx
LjMzMTMxOV0gIFs8ZmZmZmZmZmY4MTA2YzgzMj5dID8gY3B1X2hvdHBsdWdfZHJpdmVyX2xv
Y2srMHgxMi8weDIwClsgIDI0MS4zMzI0NzhdICBbPGZmZmZmZmZmODFkMWJlYzE+XSBjcHVf
ZG93bisweDMxLzB4NTAKWyAgMjQxLjMzMzQwN10gIFs8ZmZmZmZmZmY4MWQxYWFhNz5dIF9k
ZWJ1Z19ob3RwbHVnX2NwdSsweDQ3LzB4YjAKWyAgMjQxLjMzNDQ1OV0gIFs8ZmZmZmZmZmY4
MjQyNTFmMz5dID8gcGNpX2lvbW11X2FsbG9jKzB4NmMvMHg2YwpbICAyNDEuMzM1NDgyXSAg
WzxmZmZmZmZmZjgyNDI1MjAwPl0gZGVidWdfaG90cGx1Z19jcHUrMHhkLzB4MTEKWyAgMjQx
LjMzNjUxMF0gIFs8ZmZmZmZmZmY4MjQxY2U1ND5dIGRvX29uZV9pbml0Y2FsbCsweDdlLzB4
MTFiClsgIDI0MS4zMzc2MDZdICBbPGZmZmZmZmZmODEwZTlhMWQ+XSA/IHBhcnNlX2FyZ3Mr
MHgxZGQvMHgzMDAKWyAgMjQxLjMzODYwNF0gIFs8ZmZmZmZmZmY4MjQxY2ZlZD5dIGtlcm5l
bF9pbml0X2ZyZWVhYmxlKzB4ZmMvMHgxOGQKWyAgMjQxLjMzOTcwMF0gIFs8ZmZmZmZmZmY4
MjQxYzdlYz5dID8gZG9fZWFybHlfcGFyYW0rMHg4YS8weDhhClsgIDI0MS4zNDA3NjBdICBb
PGZmZmZmZmZmODFkMWE4ZTA+XSA/IHJlc3RfaW5pdCsweGMwLzB4YzAKWyAgMjQxLjM0MTY5
NV0gIFs8ZmZmZmZmZmY4MWQxYThlOT5dIGtlcm5lbF9pbml0KzB4OS8weDE4MApbICAyNDEu
MzQyNjU4XSAgWzxmZmZmZmZmZjgxZDNmOWNjPl0gcmV0X2Zyb21fZm9yaysweDdjLzB4YjAK
WyAgMjQxLjM0MzY1N10gIFs8ZmZmZmZmZmY4MWQxYThlMD5dID8gcmVzdF9pbml0KzB4YzAv
MHhjMApbICAyNDEuMzQ2Njc2XSAzIGxvY2tzIGhlbGQgYnkgc3dhcHBlci8wLzE6ClsgIDI0
MS4zNDc0MTBdICAjMDogICh4ODZfY3B1X2hvdHBsdWdfZHJpdmVyX211dGV4KXsrLisuKy59
LCBhdDogWzxmZmZmZmZmZjgxMDZjODMyPl0gY3B1X2hvdHBsdWdfZHJpdmVyX2xvY2srMHgx
Mi8weDIwClsgIDI0MS4zNDk0MzJdICAjMTogIChjcHVfYWRkX3JlbW92ZV9sb2NrKXsrLisu
Ky59LCBhdDogWzxmZmZmZmZmZjgxZDFiZWFkPl0gY3B1X2Rvd24rMHgxZC8weDUwClsgIDI0
MS4zNTEwOThdICAjMjogIChjcHVfaG90cGx1Zy5sb2NrKXsrLisuKy59LCBhdDogWzxmZmZm
ZmZmZjgxMGNjYTg2Pl0gY3B1X2hvdHBsdWdfYmVnaW4rMHgyNi8weDYwClsgIDI0MS4zNTI4
NDddIHNlbmRpbmcgTk1JIHRvIGFsbCBDUFVzOgpbICAyNDEuMzUzNTQ0XSBOTUkgYmFja3Ry
YWNlIGZvciBjcHUgMQpbICAyNDEuMzU0MjEwXSBDUFU6IDEgUElEOiAyOSBDb21tOiBraHVu
Z3Rhc2tkIE5vdCB0YWludGVkIDMuMTIuMC0wMjA5OC1nMTkxODY2NCAjOTgKWyAgMjQxLjM1
NTYwNV0gSGFyZHdhcmUgbmFtZTogQm9jaHMgQm9jaHMsIEJJT1MgQm9jaHMgMDEvMDEvMjAx
MQpbICAyNDEuMzU2Njk5XSB0YXNrOiBmZmZmODgwMDA3M2ZlNzgwIHRpOiBmZmZmODgwMDBm
ODBhMDAwIHRhc2sudGk6IGZmZmY4ODAwMGY4MGEwMDAKWyAgMjQxLjM1Njg0Nl0gUklQOiAw
MDEwOls8ZmZmZmZmZmY4MTA3Mzc3ZD5dICBbPGZmZmZmZmZmODEwNzM3N2Q+XSBmbGF0X3Nl
bmRfSVBJX21hc2srMHg4ZC8weGQwClsgIDI0MS4zNTY4NDZdIFJTUDogMDAwMDpmZmZmODgw
MDBmODBiZGI4ICBFRkxBR1M6IDAwMDEwMDQ2ClsgIDI0MS4zNTY4NDZdIFJBWDogMDAwMDAw
MDAwMzAwMDAwMCBSQlg6IDAwMDAwMDAwMDAwMDAwMDIgUkNYOiAwMDAwMDAwMDAwMDAwMDA3
ClsgIDI0MS4zNTY4NDZdIFJEWDogMDAwMDAwMDAwMDAwMGMwMCBSU0k6IDAwMDAwMDAwMDAw
MDAwMDEgUkRJOiAwMDAwMDAwMDAwMDAwMzAwClsgIDI0MS4zNTY4NDZdIFJCUDogZmZmZjg4
MDAwZjgwYmRkOCBSMDg6IDAwMDAwMDAwMDAwMDAwMDAgUjA5OiAwMDAwMDAwMDAwMDAwMDAw
ClsgIDI0MS4zNTY4NDZdIFIxMDogMDAwMDAwMDAwMDAwMDAwMSBSMTE6IDAwMDAwMDAwMDAw
MDAwMDEgUjEyOiAwMDAwMDAwMDAwMDAwMjQ2ClsgIDI0MS4zNTY4NDZdIFIxMzogMDAwMDAw
MDAwMDAwMGMwMCBSMTQ6IDAwMDAwMDAwMDAwMDAwMDMgUjE1OiAwMDAwMDAwMDAwMDAwM2Zm
ClsgIDI0MS4zNTY4NDZdIEZTOiAgMDAwMDAwMDAwMDAwMDAwMCgwMDAwKSBHUzpmZmZmODgw
MDBkZDAwMDAwKDAwMDApIGtubEdTOjAwMDAwMDAwMDAwMDAwMDAKWyAgMjQxLjM1Njg0Nl0g
Q1M6ICAwMDEwIERTOiAwMDAwIEVTOiAwMDAwIENSMDogMDAwMDAwMDA4MDA1MDAzYgpbICAy
NDEuMzU2ODQ2XSBDUjI6IDAwMDAwMDAwZmZmZmZmZmYgQ1IzOiAwMDAwMDAwMDAyMjA2MDAw
IENSNDogMDAwMDAwMDAwMDAwMDZhMApbICAyNDEuMzU2ODQ2XSBTdGFjazoKWyAgMjQxLjM1
Njg0Nl0gIDAwMDAwMDAwMDAwMDI3MTAgZmZmZjg4MDAwZDhhMjA0MCAwMDAwMDAwMDAwMDA3
ZmZmIGZmZmY4ODAwMGQ4YTIwNDAKWyAgMjQxLjM1Njg0Nl0gIGZmZmY4ODAwMGY4MGJkZTgg
ZmZmZmZmZmY4MTA3MzdkYSBmZmZmODgwMDBmODBiZTAwIGZmZmZmZmZmODEwNzBhM2YKWyAg
MjQxLjM1Njg0Nl0gIDAwMDAwMDAwMDAwMDAwNzggZmZmZjg4MDAwZjgwYmU2OCBmZmZmZmZm
ZjgxMTNlMWE4IGZmZmZmZmZmODExM2RmNGIKWyAgMjQxLjM1Njg0Nl0gQ2FsbCBUcmFjZToK
WyAgMjQxLjM1Njg0Nl0gIFs8ZmZmZmZmZmY4MTA3MzdkYT5dIGZsYXRfc2VuZF9JUElfYWxs
KzB4MWEvMHg3MApbICAyNDEuMzU2ODQ2XSAgWzxmZmZmZmZmZjgxMDcwYTNmPl0gYXJjaF90
cmlnZ2VyX2FsbF9jcHVfYmFja3RyYWNlKzB4NWYvMHhiMApbICAyNDEuMzU2ODQ2XSAgWzxm
ZmZmZmZmZjgxMTNlMWE4Pl0gd2F0Y2hkb2crMHgyZDgvMHgzZDAKWyAgMjQxLjM1Njg0Nl0g
IFs8ZmZmZmZmZmY4MTEzZGY0Yj5dID8gd2F0Y2hkb2crMHg3Yi8weDNkMApbICAyNDEuMzU2
ODQ2XSAgWzxmZmZmZmZmZjgxMTNkZWQwPl0gPyBodW5nX3Rhc2tfcGFuaWMrMHgyMC8weDIw
ClsgIDI0MS4zNTY4NDZdICBbPGZmZmZmZmZmODEwZWI0MzE+XSBrdGhyZWFkKzB4ZDEvMHhl
MApbICAyNDEuMzU2ODQ2XSAgWzxmZmZmZmZmZjgxZDNlNTc3Pl0gPyBfcmF3X3NwaW5fdW5s
b2NrX2lycSsweDI3LzB4NjAKWyAgMjQxLjM1Njg0Nl0gIFs8ZmZmZmZmZmY4MTBlYjM2MD5d
ID8gX19rdGhyZWFkX3VucGFyaysweDUwLzB4NTAKWyAgMjQxLjM1Njg0Nl0gIFs8ZmZmZmZm
ZmY4MWQzZjljYz5dIHJldF9mcm9tX2ZvcmsrMHg3Yy8weGIwClsgIDI0MS4zNTY4NDZdICBb
PGZmZmZmZmZmODEwZWIzNjA+XSA/IF9fa3RocmVhZF91bnBhcmsrMHg1MC8weDUwClsgIDI0
MS4zNTY4NDZdIENvZGU6IGU2IDEwIDc1IGYyIDQ0IDg5IGYwIGMxIGUwIDE4IDg5IDA0IDI1
IDEwIGIzIDU3IGZmIDg5IGRhIDQ0IDA5IGVhIDQxIDgxIGNkIDAwIDA0IDAwIDAwIDgzIGZi
IDAyIDQxIDBmIDQ0IGQ1IDg5IDE0IDI1IDAwIGIzIDU3IGZmIDw0MT4gZjcgYzQgMDAgMDIg
MDAgMDAgNzUgMWEgNGMgODkgZTcgNTcgOWQgMGYgMWYgNDQgMDAgMDAgZTggOGIgCi9rZXJu
ZWwveDg2XzY0LXJhbmRjb25maWcteDQtMTEwOC8xOTE4NjY0ZDBiMmI2YjJhZDZiMTgwZTdj
MDRhNDI4NzJiZWI2NjkxL2RtZXNnLXlvY3RvLWpha2V0b3duLTIwOjIwMTMxMTA4MjIzMDMy
Ong4Nl82NC1yYW5kY29uZmlnLXg0LTExMDg6My4xMi4wLTAyMDk4LWcxOTE4NjY0Ojk4Ci9r
ZXJuZWwveDg2XzY0LXJhbmRjb25maWcteDQtMTEwOC8xOTE4NjY0ZDBiMmI2YjJhZDZiMTgw
ZTdjMDRhNDI4NzJiZWI2NjkxL2RtZXNnLXlvY3RvLXN0b2FrbGV5LTQ6MjAxMzExMDgyMjMw
NTE6eDg2XzY0LXJhbmRjb25maWcteDQtMTEwODozLjEyLjAtMDIwOTgtZzE5MTg2NjQ6OTgK
L2tlcm5lbC94ODZfNjQtcmFuZGNvbmZpZy14NC0xMTA4LzE5MTg2NjRkMGIyYjZiMmFkNmIx
ODBlN2MwNGE0Mjg3MmJlYjY2OTEvZG1lc2cteW9jdG8tcm9hbS0zOjIwMTMxMTA5MTExMDU3
Ong4Nl82NC1yYW5kY29uZmlnLXg0LTExMDg6My4xMi4wLTAyMDk4LWcxOTE4NjY0Ojk4Ci9r
ZXJuZWwveDg2XzY0LXJhbmRjb25maWcteDQtMTEwOC8xOTE4NjY0ZDBiMmI2YjJhZDZiMTgw
ZTdjMDRhNDI4NzJiZWI2NjkxL2RtZXNnLXlvY3RvLXdhaW1lYS0xOjIwMTMxMTA5MTkwODAz
Ong4Nl82NC1yYW5kY29uZmlnLXg0LTExMDg6My4xMi4wLTAyMDk4LWcxOTE4NjY0Ojk4Ci9r
ZXJuZWwveDg2XzY0LXJhbmRjb25maWcteDQtMTEwOC8xOTE4NjY0ZDBiMmI2YjJhZDZiMTgw
ZTdjMDRhNDI4NzJiZWI2NjkxL2RtZXNnLXlvY3RvLXN0b2FrbGV5LTY6MjAxMzExMDgyMjMw
NTQ6eDg2XzY0LXJhbmRjb25maWcteDQtMTEwODozLjEyLjAtMDIwOTgtZzE5MTg2NjQ6OTgK
L2tlcm5lbC94ODZfNjQtcmFuZGNvbmZpZy14NC0xMTA4LzE5MTg2NjRkMGIyYjZiMmFkNmIx
ODBlN2MwNGE0Mjg3MmJlYjY2OTEvZG1lc2cteW9jdG8tc3RvYWtsZXktMjoyMDEzMTEwODIy
MzUxNDp4ODZfNjQtcmFuZGNvbmZpZy14NC0xMTA4OjMuMTIuMC0wMjA5OC1nMTkxODY2NDo5
OAova2VybmVsL3g4Nl82NC1yYW5kY29uZmlnLXg0LTExMDgvMTkxODY2NGQwYjJiNmIyYWQ2
YjE4MGU3YzA0YTQyODcyYmViNjY5MS9kbWVzZy1xdWFudGFsLWxrcC10dDAyLTE1OjIwMTMx
MTA5MDIwMTA2Ong4Nl82NC1yYW5kY29uZmlnLXg0LTExMDg6My4xMi4wLTAyMDk4LWcxOTE4
NjY0Ojk4Ci9rZXJuZWwveDg2XzY0LXJhbmRjb25maWcteDQtMTEwOC8xOTE4NjY0ZDBiMmI2
YjJhZDZiMTgwZTdjMDRhNDI4NzJiZWI2NjkxL2RtZXNnLXF1YW50YWwtYXRoZW5zLTM1OjIw
MTMxMTA5MTEwOTQ2Ong4Nl82NC1yYW5kY29uZmlnLXg0LTExMDg6My4xMi4wLTAyMDk4LWcx
OTE4NjY0Ojk4Ci9rZXJuZWwveDg2XzY0LXJhbmRjb25maWcteDQtMTEwOC8xOTE4NjY0ZDBi
MmI2YjJhZDZiMTgwZTdjMDRhNDI4NzJiZWI2NjkxL2RtZXNnLXF1YW50YWwteHBzLTU6MjAx
MzExMDkwNjMzNDI6eDg2XzY0LXJhbmRjb25maWcteDQtMTEwODozLjEyLjAtMDIwOTgtZzE5
MTg2NjQ6OTgKL2tlcm5lbC94ODZfNjQtcmFuZGNvbmZpZy14NC0xMTA4LzE5MTg2NjRkMGIy
YjZiMmFkNmIxODBlN2MwNGE0Mjg3MmJlYjY2OTEvZG1lc2cteW9jdG8tc3RvYWtsZXktMjoy
MDEzMTEwODIyMzA0NDp4ODZfNjQtcmFuZGNvbmZpZy14NC0xMTA4OjMuMTIuMC0wMjA5OC1n
MTkxODY2NDo5OAova2VybmVsL3g4Nl82NC1yYW5kY29uZmlnLXg0LTExMDgvMTkxODY2NGQw
YjJiNmIyYWQ2YjE4MGU3YzA0YTQyODcyYmViNjY5MS9kbWVzZy1xdWFudGFsLXN0b2FrbGV5
LTY6MjAxMzExMDgyMjMzMzI6eDg2XzY0LXJhbmRjb25maWcteDQtMTEwODozLjEyLjAtMDIw
OTgtZzE5MTg2NjQ6OTgKL2tlcm5lbC94ODZfNjQtcmFuZGNvbmZpZy14NC0xMTA4LzE5MTg2
NjRkMGIyYjZiMmFkNmIxODBlN2MwNGE0Mjg3MmJlYjY2OTEvZG1lc2cteW9jdG8tbGtwLXN0
MDEtNToyMDEzMTEwOTA2MjYxOTp4ODZfNjQtcmFuZGNvbmZpZy14NC0xMTA4OjMuMTIuMC0w
MjA5OC1nMTkxODY2NDo5OAo3OjEyOjEyIGFsbF9nb29kOmJhZDphbGxfYmFkIGJvb3RzCgo=

--CblX+4bnyfN0pR09
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="config-3.12.0-02098-g1918664"

#
# Automatically generated file; DO NOT EDIT.
# Linux/x86_64 3.12.0 Kernel Configuration
#
CONFIG_64BIT=y
CONFIG_X86_64=y
CONFIG_X86=y
CONFIG_INSTRUCTION_DECODER=y
CONFIG_OUTPUT_FORMAT="elf64-x86-64"
CONFIG_ARCH_DEFCONFIG="arch/x86/configs/x86_64_defconfig"
CONFIG_LOCKDEP_SUPPORT=y
CONFIG_STACKTRACE_SUPPORT=y
CONFIG_HAVE_LATENCYTOP_SUPPORT=y
CONFIG_MMU=y
CONFIG_NEED_DMA_MAP_STATE=y
CONFIG_NEED_SG_DMA_LENGTH=y
CONFIG_GENERIC_BUG=y
CONFIG_GENERIC_BUG_RELATIVE_POINTERS=y
CONFIG_GENERIC_HWEIGHT=y
CONFIG_RWSEM_XCHGADD_ALGORITHM=y
CONFIG_GENERIC_CALIBRATE_DELAY=y
CONFIG_ARCH_HAS_CPU_RELAX=y
CONFIG_ARCH_HAS_CACHE_LINE_SIZE=y
CONFIG_ARCH_HAS_CPU_AUTOPROBE=y
CONFIG_HAVE_SETUP_PER_CPU_AREA=y
CONFIG_NEED_PER_CPU_EMBED_FIRST_CHUNK=y
CONFIG_NEED_PER_CPU_PAGE_FIRST_CHUNK=y
CONFIG_ARCH_HIBERNATION_POSSIBLE=y
CONFIG_ARCH_SUSPEND_POSSIBLE=y
CONFIG_ARCH_WANT_HUGE_PMD_SHARE=y
CONFIG_ARCH_WANT_GENERAL_HUGETLB=y
CONFIG_ZONE_DMA32=y
CONFIG_AUDIT_ARCH=y
CONFIG_ARCH_SUPPORTS_OPTIMIZED_INLINING=y
CONFIG_ARCH_SUPPORTS_DEBUG_PAGEALLOC=y
CONFIG_X86_64_SMP=y
CONFIG_X86_HT=y
CONFIG_ARCH_HWEIGHT_CFLAGS="-fcall-saved-rdi -fcall-saved-rsi -fcall-saved-rdx -fcall-saved-rcx -fcall-saved-r8 -fcall-saved-r9 -fcall-saved-r10 -fcall-saved-r11"
CONFIG_ARCH_CPU_PROBE_RELEASE=y
CONFIG_ARCH_SUPPORTS_UPROBES=y
CONFIG_DEFCONFIG_LIST="/lib/modules/$UNAME_RELEASE/.config"
CONFIG_IRQ_WORK=y
CONFIG_BUILDTIME_EXTABLE_SORT=y

#
# General setup
#
CONFIG_INIT_ENV_ARG_LIMIT=32
CONFIG_CROSS_COMPILE=""
CONFIG_COMPILE_TEST=y
CONFIG_LOCALVERSION=""
CONFIG_LOCALVERSION_AUTO=y
CONFIG_HAVE_KERNEL_GZIP=y
CONFIG_HAVE_KERNEL_BZIP2=y
CONFIG_HAVE_KERNEL_LZMA=y
CONFIG_HAVE_KERNEL_XZ=y
CONFIG_HAVE_KERNEL_LZO=y
CONFIG_HAVE_KERNEL_LZ4=y
# CONFIG_KERNEL_GZIP is not set
CONFIG_KERNEL_BZIP2=y
# CONFIG_KERNEL_LZMA is not set
# CONFIG_KERNEL_XZ is not set
# CONFIG_KERNEL_LZO is not set
# CONFIG_KERNEL_LZ4 is not set
CONFIG_DEFAULT_HOSTNAME="(none)"
CONFIG_SWAP=y
# CONFIG_SYSVIPC is not set
CONFIG_POSIX_MQUEUE=y
CONFIG_FHANDLE=y
# CONFIG_AUDIT is not set

#
# IRQ subsystem
#
CONFIG_GENERIC_IRQ_PROBE=y
CONFIG_GENERIC_IRQ_SHOW=y
CONFIG_GENERIC_PENDING_IRQ=y
CONFIG_IRQ_DOMAIN=y
# CONFIG_IRQ_DOMAIN_DEBUG is not set
CONFIG_IRQ_FORCED_THREADING=y
CONFIG_SPARSE_IRQ=y
CONFIG_CLOCKSOURCE_WATCHDOG=y
CONFIG_ARCH_CLOCKSOURCE_DATA=y
CONFIG_GENERIC_TIME_VSYSCALL=y
CONFIG_GENERIC_CLOCKEVENTS=y
CONFIG_GENERIC_CLOCKEVENTS_BUILD=y
CONFIG_GENERIC_CLOCKEVENTS_BROADCAST=y
CONFIG_GENERIC_CLOCKEVENTS_MIN_ADJUST=y
CONFIG_GENERIC_CMOS_UPDATE=y

#
# Timers subsystem
#
CONFIG_TICK_ONESHOT=y
CONFIG_HZ_PERIODIC=y
# CONFIG_NO_HZ_IDLE is not set
# CONFIG_NO_HZ_FULL is not set
# CONFIG_NO_HZ is not set
CONFIG_HIGH_RES_TIMERS=y

#
# CPU/Task time and stats accounting
#
CONFIG_VIRT_CPU_ACCOUNTING=y
# CONFIG_TICK_CPU_ACCOUNTING is not set
CONFIG_VIRT_CPU_ACCOUNTING_GEN=y
# CONFIG_IRQ_TIME_ACCOUNTING is not set
# CONFIG_BSD_PROCESS_ACCT is not set
CONFIG_TASKSTATS=y
CONFIG_TASK_DELAY_ACCT=y
# CONFIG_TASK_XACCT is not set

#
# RCU Subsystem
#
CONFIG_TREE_PREEMPT_RCU=y
CONFIG_PREEMPT_RCU=y
CONFIG_RCU_STALL_COMMON=y
CONFIG_CONTEXT_TRACKING=y
# CONFIG_RCU_USER_QS is not set
# CONFIG_CONTEXT_TRACKING_FORCE is not set
CONFIG_RCU_FANOUT=64
CONFIG_RCU_FANOUT_LEAF=16
CONFIG_RCU_FANOUT_EXACT=y
CONFIG_TREE_RCU_TRACE=y
CONFIG_RCU_BOOST=y
CONFIG_RCU_BOOST_PRIO=1
CONFIG_RCU_BOOST_DELAY=500
# CONFIG_RCU_NOCB_CPU is not set
CONFIG_IKCONFIG=y
CONFIG_LOG_BUF_SHIFT=17
CONFIG_HAVE_UNSTABLE_SCHED_CLOCK=y
CONFIG_ARCH_SUPPORTS_NUMA_BALANCING=y
CONFIG_ARCH_WANTS_PROT_NUMA_PROT_NONE=y
CONFIG_CGROUPS=y
# CONFIG_CGROUP_DEBUG is not set
# CONFIG_CGROUP_FREEZER is not set
# CONFIG_CGROUP_DEVICE is not set
# CONFIG_CPUSETS is not set
# CONFIG_CGROUP_CPUACCT is not set
# CONFIG_RESOURCE_COUNTERS is not set
# CONFIG_CGROUP_PERF is not set
CONFIG_CGROUP_SCHED=y
CONFIG_FAIR_GROUP_SCHED=y
# CONFIG_CFS_BANDWIDTH is not set
# CONFIG_RT_GROUP_SCHED is not set
# CONFIG_BLK_CGROUP is not set
CONFIG_CHECKPOINT_RESTORE=y
# CONFIG_NAMESPACES is not set
# CONFIG_UIDGID_STRICT_TYPE_CHECKS is not set
CONFIG_SCHED_AUTOGROUP=y
# CONFIG_RELAY is not set
CONFIG_BLK_DEV_INITRD=y
CONFIG_INITRAMFS_SOURCE=""
CONFIG_RD_GZIP=y
CONFIG_RD_BZIP2=y
# CONFIG_RD_LZMA is not set
# CONFIG_RD_XZ is not set
# CONFIG_RD_LZO is not set
CONFIG_RD_LZ4=y
# CONFIG_CC_OPTIMIZE_FOR_SIZE is not set
CONFIG_ANON_INODES=y
CONFIG_SYSCTL_EXCEPTION_TRACE=y
CONFIG_HAVE_PCSPKR_PLATFORM=y
CONFIG_EXPERT=y
CONFIG_KALLSYMS=y
CONFIG_KALLSYMS_ALL=y
CONFIG_PRINTK=y
CONFIG_BUG=y
# CONFIG_ELF_CORE is not set
# CONFIG_PCSPKR_PLATFORM is not set
# CONFIG_BASE_FULL is not set
CONFIG_FUTEX=y
CONFIG_EPOLL=y
CONFIG_SIGNALFD=y
# CONFIG_TIMERFD is not set
CONFIG_EVENTFD=y
# CONFIG_SHMEM is not set
CONFIG_AIO=y
CONFIG_PCI_QUIRKS=y
CONFIG_EMBEDDED=y
CONFIG_HAVE_PERF_EVENTS=y
CONFIG_PERF_USE_VMALLOC=y

#
# Kernel Performance Events And Counters
#
CONFIG_PERF_EVENTS=y
CONFIG_DEBUG_PERF_USE_VMALLOC=y
# CONFIG_VM_EVENT_COUNTERS is not set
# CONFIG_COMPAT_BRK is not set
CONFIG_SLAB=y
# CONFIG_SLUB is not set
# CONFIG_SLOB is not set
# CONFIG_PROFILING is not set
CONFIG_TRACEPOINTS=y
CONFIG_HAVE_OPROFILE=y
CONFIG_OPROFILE_NMI_TIMER=y
# CONFIG_JUMP_LABEL is not set
CONFIG_UPROBES=y
# CONFIG_HAVE_64BIT_ALIGNED_ACCESS is not set
CONFIG_HAVE_EFFICIENT_UNALIGNED_ACCESS=y
CONFIG_ARCH_USE_BUILTIN_BSWAP=y
CONFIG_USER_RETURN_NOTIFIER=y
CONFIG_HAVE_IOREMAP_PROT=y
CONFIG_HAVE_KPROBES=y
CONFIG_HAVE_KRETPROBES=y
CONFIG_HAVE_OPTPROBES=y
CONFIG_HAVE_KPROBES_ON_FTRACE=y
CONFIG_HAVE_ARCH_TRACEHOOK=y
CONFIG_HAVE_DMA_ATTRS=y
CONFIG_USE_GENERIC_SMP_HELPERS=y
CONFIG_GENERIC_SMP_IDLE_THREAD=y
CONFIG_HAVE_REGS_AND_STACK_ACCESS_API=y
CONFIG_HAVE_CLK=y
CONFIG_HAVE_DMA_API_DEBUG=y
CONFIG_HAVE_HW_BREAKPOINT=y
CONFIG_HAVE_MIXED_BREAKPOINTS_REGS=y
CONFIG_HAVE_USER_RETURN_NOTIFIER=y
CONFIG_HAVE_PERF_EVENTS_NMI=y
CONFIG_HAVE_PERF_REGS=y
CONFIG_HAVE_PERF_USER_STACK_DUMP=y
CONFIG_HAVE_ARCH_JUMP_LABEL=y
CONFIG_ARCH_HAVE_NMI_SAFE_CMPXCHG=y
CONFIG_HAVE_CMPXCHG_LOCAL=y
CONFIG_HAVE_CMPXCHG_DOUBLE=y
CONFIG_HAVE_ARCH_SECCOMP_FILTER=y
CONFIG_HAVE_CONTEXT_TRACKING=y
CONFIG_HAVE_VIRT_CPU_ACCOUNTING_GEN=y
CONFIG_HAVE_IRQ_TIME_ACCOUNTING=y
CONFIG_HAVE_ARCH_TRANSPARENT_HUGEPAGE=y
CONFIG_HAVE_ARCH_SOFT_DIRTY=y
CONFIG_MODULES_USE_ELF_RELA=y
CONFIG_HAVE_IRQ_EXIT_ON_IRQ_STACK=y

#
# GCOV-based kernel profiling
#
# CONFIG_GCOV_KERNEL is not set
# CONFIG_HAVE_GENERIC_DMA_COHERENT is not set
CONFIG_RT_MUTEXES=y
CONFIG_BASE_SMALL=1
# CONFIG_MODULES is not set
CONFIG_STOP_MACHINE=y
CONFIG_BLOCK=y
CONFIG_BLK_DEV_BSG=y
CONFIG_BLK_DEV_BSGLIB=y
# CONFIG_BLK_DEV_INTEGRITY is not set
CONFIG_BLK_CMDLINE_PARSER=y

#
# Partition Types
#
# CONFIG_PARTITION_ADVANCED is not set
CONFIG_MSDOS_PARTITION=y
CONFIG_EFI_PARTITION=y

#
# IO Schedulers
#
CONFIG_IOSCHED_NOOP=y
CONFIG_IOSCHED_DEADLINE=y
# CONFIG_IOSCHED_CFQ is not set
CONFIG_DEFAULT_DEADLINE=y
# CONFIG_DEFAULT_NOOP is not set
CONFIG_DEFAULT_IOSCHED="deadline"
CONFIG_PREEMPT_NOTIFIERS=y
CONFIG_PADATA=y
CONFIG_UNINLINE_SPIN_UNLOCK=y
CONFIG_FREEZER=y

#
# Processor type and features
#
CONFIG_ZONE_DMA=y
CONFIG_SMP=y
# CONFIG_X86_MPPARSE is not set
# CONFIG_X86_EXTENDED_PLATFORM is not set
CONFIG_X86_INTEL_LPSS=y
# CONFIG_SCHED_OMIT_FRAME_POINTER is not set
# CONFIG_KVMTOOL_TEST_ENABLE is not set
CONFIG_HYPERVISOR_GUEST=y
CONFIG_PARAVIRT=y
# CONFIG_PARAVIRT_DEBUG is not set
# CONFIG_PARAVIRT_SPINLOCKS is not set
# CONFIG_XEN is not set
# CONFIG_XEN_PRIVILEGED_GUEST is not set
CONFIG_KVM_GUEST=y
# CONFIG_KVM_DEBUG_FS is not set
# CONFIG_PARAVIRT_TIME_ACCOUNTING is not set
CONFIG_PARAVIRT_CLOCK=y
CONFIG_NO_BOOTMEM=y
# CONFIG_MEMTEST is not set
# CONFIG_MK8 is not set
# CONFIG_MPSC is not set
# CONFIG_MCORE2 is not set
# CONFIG_MATOM is not set
CONFIG_GENERIC_CPU=y
CONFIG_X86_INTERNODE_CACHE_SHIFT=6
CONFIG_X86_L1_CACHE_SHIFT=6
CONFIG_X86_TSC=y
CONFIG_X86_CMPXCHG64=y
CONFIG_X86_CMOV=y
CONFIG_X86_MINIMUM_CPU_FAMILY=64
CONFIG_X86_DEBUGCTLMSR=y
# CONFIG_PROCESSOR_SELECT is not set
CONFIG_CPU_SUP_INTEL=y
CONFIG_CPU_SUP_AMD=y
CONFIG_CPU_SUP_CENTAUR=y
CONFIG_HPET_TIMER=y
CONFIG_DMI=y
# CONFIG_GART_IOMMU is not set
# CONFIG_CALGARY_IOMMU is not set
CONFIG_SWIOTLB=y
CONFIG_IOMMU_HELPER=y
CONFIG_MAXSMP=y
CONFIG_NR_CPUS=8192
CONFIG_SCHED_SMT=y
# CONFIG_SCHED_MC is not set
# CONFIG_PREEMPT_NONE is not set
# CONFIG_PREEMPT_VOLUNTARY is not set
CONFIG_PREEMPT=y
CONFIG_PREEMPT_COUNT=y
CONFIG_X86_LOCAL_APIC=y
CONFIG_X86_IO_APIC=y
CONFIG_X86_REROUTE_FOR_BROKEN_BOOT_IRQS=y
# CONFIG_X86_MCE is not set
CONFIG_I8K=y
CONFIG_MICROCODE=y
CONFIG_MICROCODE_INTEL=y
# CONFIG_MICROCODE_AMD is not set
CONFIG_MICROCODE_OLD_INTERFACE=y
CONFIG_MICROCODE_INTEL_LIB=y
# CONFIG_MICROCODE_INTEL_EARLY is not set
# CONFIG_MICROCODE_AMD_EARLY is not set
# CONFIG_MICROCODE_EARLY is not set
CONFIG_X86_MSR=y
CONFIG_X86_CPUID=y
CONFIG_ARCH_PHYS_ADDR_T_64BIT=y
CONFIG_ARCH_DMA_ADDR_T_64BIT=y
CONFIG_DIRECT_GBPAGES=y
# CONFIG_NUMA is not set
CONFIG_ARCH_SPARSEMEM_ENABLE=y
CONFIG_ARCH_SPARSEMEM_DEFAULT=y
CONFIG_ARCH_SELECT_MEMORY_MODEL=y
CONFIG_ARCH_MEMORY_PROBE=y
CONFIG_ILLEGAL_POINTER_VALUE=0xdead000000000000
CONFIG_SELECT_MEMORY_MODEL=y
CONFIG_SPARSEMEM_MANUAL=y
CONFIG_SPARSEMEM=y
CONFIG_HAVE_MEMORY_PRESENT=y
CONFIG_SPARSEMEM_EXTREME=y
CONFIG_SPARSEMEM_VMEMMAP_ENABLE=y
CONFIG_SPARSEMEM_ALLOC_MEM_MAP_TOGETHER=y
CONFIG_SPARSEMEM_VMEMMAP=y
CONFIG_HAVE_MEMBLOCK=y
CONFIG_HAVE_MEMBLOCK_NODE_MAP=y
CONFIG_ARCH_DISCARD_MEMBLOCK=y
CONFIG_MEMORY_ISOLATION=y
# CONFIG_HAVE_BOOTMEM_INFO_NODE is not set
CONFIG_MEMORY_HOTPLUG=y
CONFIG_MEMORY_HOTPLUG_SPARSE=y
# CONFIG_MEMORY_HOTREMOVE is not set
CONFIG_PAGEFLAGS_EXTENDED=y
CONFIG_SPLIT_PTLOCK_CPUS=999999
# CONFIG_COMPACTION is not set
CONFIG_MIGRATION=y
CONFIG_PHYS_ADDR_T_64BIT=y
CONFIG_ZONE_DMA_FLAG=1
CONFIG_BOUNCE=y
CONFIG_VIRT_TO_BUS=y
CONFIG_MMU_NOTIFIER=y
CONFIG_KSM=y
CONFIG_DEFAULT_MMAP_MIN_ADDR=4096
# CONFIG_TRANSPARENT_HUGEPAGE is not set
# CONFIG_CROSS_MEMORY_ATTACH is not set
# CONFIG_CLEANCACHE is not set
CONFIG_FRONTSWAP=y
CONFIG_CMA=y
CONFIG_CMA_DEBUG=y
CONFIG_ZBUD=y
CONFIG_ZSWAP=y
CONFIG_MEM_SOFT_DIRTY=y
# CONFIG_X86_CHECK_BIOS_CORRUPTION is not set
CONFIG_X86_RESERVE_LOW=64
CONFIG_MTRR=y
CONFIG_MTRR_SANITIZER=y
CONFIG_MTRR_SANITIZER_ENABLE_DEFAULT=0
CONFIG_MTRR_SANITIZER_SPARE_REG_NR_DEFAULT=1
CONFIG_X86_PAT=y
CONFIG_ARCH_USES_PG_UNCACHED=y
# CONFIG_ARCH_RANDOM is not set
CONFIG_X86_SMAP=y
# CONFIG_EFI is not set
# CONFIG_SECCOMP is not set
# CONFIG_CC_STACKPROTECTOR is not set
# CONFIG_HZ_100 is not set
# CONFIG_HZ_250 is not set
CONFIG_HZ_300=y
# CONFIG_HZ_1000 is not set
CONFIG_HZ=300
CONFIG_SCHED_HRTICK=y
# CONFIG_KEXEC is not set
# CONFIG_CRASH_DUMP is not set
CONFIG_PHYSICAL_START=0x1000000
CONFIG_RELOCATABLE=y
# CONFIG_RANDOMIZE_BASE is not set
CONFIG_PHYSICAL_ALIGN=0x1000000
CONFIG_HOTPLUG_CPU=y
CONFIG_BOOTPARAM_HOTPLUG_CPU0=y
CONFIG_DEBUG_HOTPLUG_CPU0=y
# CONFIG_CMDLINE_BOOL is not set
CONFIG_ARCH_ENABLE_MEMORY_HOTPLUG=y
CONFIG_ARCH_ENABLE_MEMORY_HOTREMOVE=y

#
# Power management and ACPI options
#
CONFIG_SUSPEND=y
CONFIG_SUSPEND_FREEZER=y
# CONFIG_HIBERNATION is not set
CONFIG_PM_SLEEP=y
CONFIG_PM_SLEEP_SMP=y
# CONFIG_PM_AUTOSLEEP is not set
CONFIG_PM_WAKELOCKS=y
CONFIG_PM_WAKELOCKS_LIMIT=100
# CONFIG_PM_WAKELOCKS_GC is not set
# CONFIG_PM_RUNTIME is not set
CONFIG_PM=y
# CONFIG_PM_DEBUG is not set
CONFIG_PM_CLK=y
# CONFIG_WQ_POWER_EFFICIENT_DEFAULT is not set
CONFIG_ACPI=y
CONFIG_ACPI_SLEEP=y
# CONFIG_ACPI_EC_DEBUGFS is not set
CONFIG_ACPI_AC=y
# CONFIG_ACPI_BATTERY is not set
CONFIG_ACPI_BUTTON=y
CONFIG_ACPI_VIDEO=y
CONFIG_ACPI_FAN=y
# CONFIG_ACPI_DOCK is not set
# CONFIG_ACPI_PROCESSOR is not set
# CONFIG_ACPI_IPMI is not set
# CONFIG_ACPI_CUSTOM_DSDT is not set
# CONFIG_ACPI_INITRD_TABLE_OVERRIDE is not set
CONFIG_ACPI_BLACKLIST_YEAR=0
CONFIG_ACPI_DEBUG=y
CONFIG_X86_PM_TIMER=y
CONFIG_ACPI_CONTAINER=y
CONFIG_ACPI_HOTPLUG_MEMORY=y
CONFIG_ACPI_SBS=y
CONFIG_ACPI_HED=y
CONFIG_ACPI_CUSTOM_METHOD=y
# CONFIG_ACPI_APEI is not set
CONFIG_SFI=y

#
# CPU Frequency scaling
#
CONFIG_CPU_FREQ=y
CONFIG_CPU_FREQ_TABLE=y
CONFIG_CPU_FREQ_GOV_COMMON=y
CONFIG_CPU_FREQ_STAT=y
# CONFIG_CPU_FREQ_STAT_DETAILS is not set
# CONFIG_CPU_FREQ_DEFAULT_GOV_PERFORMANCE is not set
# CONFIG_CPU_FREQ_DEFAULT_GOV_POWERSAVE is not set
CONFIG_CPU_FREQ_DEFAULT_GOV_USERSPACE=y
# CONFIG_CPU_FREQ_DEFAULT_GOV_ONDEMAND is not set
# CONFIG_CPU_FREQ_DEFAULT_GOV_CONSERVATIVE is not set
CONFIG_CPU_FREQ_GOV_PERFORMANCE=y
CONFIG_CPU_FREQ_GOV_POWERSAVE=y
CONFIG_CPU_FREQ_GOV_USERSPACE=y
CONFIG_CPU_FREQ_GOV_ONDEMAND=y
# CONFIG_CPU_FREQ_GOV_CONSERVATIVE is not set

#
# x86 CPU frequency scaling drivers
#
CONFIG_X86_INTEL_PSTATE=y
# CONFIG_X86_P4_CLOCKMOD is not set

#
# shared options
#
# CONFIG_X86_SPEEDSTEP_LIB is not set

#
# CPU Idle
#
# CONFIG_CPU_IDLE is not set
# CONFIG_ARCH_NEEDS_CPU_IDLE_COUPLED is not set

#
# Memory power savings
#
CONFIG_I7300_IDLE_IOAT_CHANNEL=y
CONFIG_I7300_IDLE=y

#
# Bus options (PCI etc.)
#
CONFIG_PCI=y
CONFIG_PCI_DIRECT=y
# CONFIG_PCI_MMCONFIG is not set
CONFIG_PCI_DOMAINS=y
# CONFIG_PCI_CNB20LE_QUIRK is not set
# CONFIG_PCIEPORTBUS is not set
# CONFIG_PCI_MSI is not set
# CONFIG_PCI_DEBUG is not set
# CONFIG_PCI_REALLOC_ENABLE_AUTO is not set
CONFIG_PCI_STUB=y
# CONFIG_HT_IRQ is not set
CONFIG_PCI_ATS=y
CONFIG_PCI_IOV=y
# CONFIG_PCI_PRI is not set
# CONFIG_PCI_PASID is not set
# CONFIG_PCI_IOAPIC is not set
CONFIG_PCI_LABEL=y

#
# PCI host controller drivers
#
# CONFIG_ISA_DMA_API is not set
CONFIG_AMD_NB=y
# CONFIG_PCCARD is not set
CONFIG_RAPIDIO=y
CONFIG_RAPIDIO_DISC_TIMEOUT=30
CONFIG_RAPIDIO_ENABLE_RX_TX_PORTS=y
CONFIG_RAPIDIO_DMA_ENGINE=y
CONFIG_RAPIDIO_DEBUG=y
CONFIG_RAPIDIO_ENUM_BASIC=y

#
# RapidIO Switch drivers
#
CONFIG_RAPIDIO_TSI57X=y
# CONFIG_RAPIDIO_CPS_XX is not set
CONFIG_RAPIDIO_TSI568=y
# CONFIG_RAPIDIO_CPS_GEN2 is not set
CONFIG_X86_SYSFB=y

#
# Executable file formats / Emulations
#
CONFIG_BINFMT_ELF=y
CONFIG_ARCH_BINFMT_ELF_RANDOMIZE_PIE=y
CONFIG_BINFMT_SCRIPT=y
# CONFIG_HAVE_AOUT is not set
CONFIG_BINFMT_MISC=y
CONFIG_COREDUMP=y
# CONFIG_IA32_EMULATION is not set
CONFIG_X86_DEV_DMA_OPS=y
CONFIG_NET=y

#
# Networking options
#
CONFIG_PACKET=y
CONFIG_PACKET_DIAG=y
CONFIG_UNIX=y
# CONFIG_UNIX_DIAG is not set
CONFIG_XFRM=y
CONFIG_XFRM_ALGO=y
CONFIG_XFRM_USER=y
CONFIG_XFRM_SUB_POLICY=y
# CONFIG_XFRM_MIGRATE is not set
CONFIG_XFRM_IPCOMP=y
CONFIG_NET_KEY=y
# CONFIG_NET_KEY_MIGRATE is not set
CONFIG_INET=y
# CONFIG_IP_MULTICAST is not set
# CONFIG_IP_ADVANCED_ROUTER is not set
# CONFIG_IP_PNP is not set
CONFIG_NET_IPIP=y
# CONFIG_NET_IPGRE_DEMUX is not set
CONFIG_NET_IP_TUNNEL=y
# CONFIG_SYN_COOKIES is not set
CONFIG_NET_IPVTI=y
# CONFIG_INET_AH is not set
CONFIG_INET_ESP=y
CONFIG_INET_IPCOMP=y
CONFIG_INET_XFRM_TUNNEL=y
CONFIG_INET_TUNNEL=y
# CONFIG_INET_XFRM_MODE_TRANSPORT is not set
CONFIG_INET_XFRM_MODE_TUNNEL=y
# CONFIG_INET_XFRM_MODE_BEET is not set
CONFIG_INET_LRO=y
# CONFIG_INET_DIAG is not set
# CONFIG_TCP_CONG_ADVANCED is not set
CONFIG_TCP_CONG_CUBIC=y
CONFIG_DEFAULT_TCP_CONG="cubic"
CONFIG_TCP_MD5SIG=y
CONFIG_IPV6=y
# CONFIG_IPV6_PRIVACY is not set
# CONFIG_IPV6_ROUTER_PREF is not set
CONFIG_IPV6_OPTIMISTIC_DAD=y
# CONFIG_INET6_AH is not set
# CONFIG_INET6_ESP is not set
CONFIG_INET6_IPCOMP=y
CONFIG_IPV6_MIP6=y
CONFIG_INET6_XFRM_TUNNEL=y
CONFIG_INET6_TUNNEL=y
CONFIG_INET6_XFRM_MODE_TRANSPORT=y
# CONFIG_INET6_XFRM_MODE_TUNNEL is not set
# CONFIG_INET6_XFRM_MODE_BEET is not set
CONFIG_INET6_XFRM_MODE_ROUTEOPTIMIZATION=y
# CONFIG_IPV6_SIT is not set
CONFIG_IPV6_TUNNEL=y
CONFIG_IPV6_GRE=y
CONFIG_IPV6_MULTIPLE_TABLES=y
# CONFIG_IPV6_SUBTREES is not set
CONFIG_IPV6_MROUTE=y
# CONFIG_IPV6_MROUTE_MULTIPLE_TABLES is not set
CONFIG_IPV6_PIMSM_V2=y
# CONFIG_NETWORK_SECMARK is not set
# CONFIG_NETWORK_PHY_TIMESTAMPING is not set
# CONFIG_NETFILTER is not set
CONFIG_IP_DCCP=y

#
# DCCP CCIDs Configuration
#
# CONFIG_IP_DCCP_CCID2_DEBUG is not set
# CONFIG_IP_DCCP_CCID3 is not set

#
# DCCP Kernel Hacking
#
CONFIG_IP_DCCP_DEBUG=y
CONFIG_IP_SCTP=y
# CONFIG_SCTP_DEFAULT_COOKIE_HMAC_MD5 is not set
# CONFIG_SCTP_DEFAULT_COOKIE_HMAC_SHA1 is not set
CONFIG_SCTP_DEFAULT_COOKIE_HMAC_NONE=y
CONFIG_SCTP_COOKIE_HMAC_MD5=y
CONFIG_SCTP_COOKIE_HMAC_SHA1=y
# CONFIG_RDS is not set
CONFIG_TIPC=y
CONFIG_TIPC_PORTS=8191
CONFIG_ATM=y
CONFIG_ATM_CLIP=y
# CONFIG_ATM_CLIP_NO_ICMP is not set
CONFIG_ATM_LANE=y
CONFIG_ATM_MPOA=y
CONFIG_ATM_BR2684=y
CONFIG_ATM_BR2684_IPFILTER=y
CONFIG_L2TP=y
# CONFIG_L2TP_DEBUGFS is not set
CONFIG_L2TP_V3=y
CONFIG_L2TP_IP=y
CONFIG_L2TP_ETH=y
CONFIG_STP=y
CONFIG_BRIDGE=y
CONFIG_BRIDGE_IGMP_SNOOPING=y
# CONFIG_BRIDGE_VLAN_FILTERING is not set
CONFIG_VLAN_8021Q=y
# CONFIG_VLAN_8021Q_GVRP is not set
# CONFIG_VLAN_8021Q_MVRP is not set
CONFIG_DECNET=y
CONFIG_DECNET_ROUTER=y
CONFIG_LLC=y
# CONFIG_LLC2 is not set
CONFIG_IPX=y
# CONFIG_IPX_INTERN is not set
CONFIG_ATALK=y
CONFIG_DEV_APPLETALK=y
CONFIG_IPDDP=y
CONFIG_IPDDP_ENCAP=y
# CONFIG_X25 is not set
CONFIG_LAPB=y
# CONFIG_PHONET is not set
CONFIG_IEEE802154=y
CONFIG_IEEE802154_6LOWPAN=y
CONFIG_MAC802154=y
CONFIG_NET_SCHED=y

#
# Queueing/Scheduling
#
CONFIG_NET_SCH_CBQ=y
# CONFIG_NET_SCH_HTB is not set
CONFIG_NET_SCH_HFSC=y
CONFIG_NET_SCH_ATM=y
CONFIG_NET_SCH_PRIO=y
CONFIG_NET_SCH_MULTIQ=y
CONFIG_NET_SCH_RED=y
CONFIG_NET_SCH_SFB=y
CONFIG_NET_SCH_SFQ=y
# CONFIG_NET_SCH_TEQL is not set
# CONFIG_NET_SCH_TBF is not set
CONFIG_NET_SCH_GRED=y
CONFIG_NET_SCH_DSMARK=y
CONFIG_NET_SCH_NETEM=y
# CONFIG_NET_SCH_DRR is not set
# CONFIG_NET_SCH_MQPRIO is not set
CONFIG_NET_SCH_CHOKE=y
CONFIG_NET_SCH_QFQ=y
# CONFIG_NET_SCH_CODEL is not set
CONFIG_NET_SCH_FQ_CODEL=y
CONFIG_NET_SCH_FQ=y
CONFIG_NET_SCH_INGRESS=y
# CONFIG_NET_SCH_PLUG is not set

#
# Classification
#
CONFIG_NET_CLS=y
# CONFIG_NET_CLS_BASIC is not set
CONFIG_NET_CLS_TCINDEX=y
# CONFIG_NET_CLS_ROUTE4 is not set
CONFIG_NET_CLS_FW=y
# CONFIG_NET_CLS_U32 is not set
# CONFIG_NET_CLS_RSVP is not set
# CONFIG_NET_CLS_RSVP6 is not set
# CONFIG_NET_CLS_FLOW is not set
# CONFIG_NET_CLS_CGROUP is not set
CONFIG_NET_EMATCH=y
CONFIG_NET_EMATCH_STACK=32
CONFIG_NET_EMATCH_CMP=y
CONFIG_NET_EMATCH_NBYTE=y
# CONFIG_NET_EMATCH_U32 is not set
CONFIG_NET_EMATCH_META=y
CONFIG_NET_EMATCH_TEXT=y
CONFIG_NET_EMATCH_CANID=y
CONFIG_NET_CLS_ACT=y
CONFIG_NET_ACT_POLICE=y
CONFIG_NET_ACT_GACT=y
# CONFIG_GACT_PROB is not set
CONFIG_NET_ACT_MIRRED=y
# CONFIG_NET_ACT_NAT is not set
CONFIG_NET_ACT_PEDIT=y
# CONFIG_NET_ACT_SIMP is not set
CONFIG_NET_ACT_SKBEDIT=y
# CONFIG_NET_ACT_CSUM is not set
# CONFIG_NET_CLS_IND is not set
CONFIG_NET_SCH_FIFO=y
# CONFIG_DCB is not set
CONFIG_DNS_RESOLVER=y
# CONFIG_BATMAN_ADV is not set
CONFIG_OPENVSWITCH=y
CONFIG_VSOCKETS=y
CONFIG_NETLINK_MMAP=y
# CONFIG_NETLINK_DIAG is not set
# CONFIG_NET_MPLS_GSO is not set
CONFIG_XPS=y
# CONFIG_NETPRIO_CGROUP is not set
CONFIG_NET_RX_BUSY_POLL=y

#
# Network testing
#
CONFIG_NET_DROP_MONITOR=y
# CONFIG_HAMRADIO is not set
CONFIG_CAN=y
# CONFIG_CAN_RAW is not set
CONFIG_CAN_BCM=y
CONFIG_CAN_GW=y

#
# CAN Device Drivers
#
CONFIG_CAN_VCAN=y
# CONFIG_CAN_SLCAN is not set
# CONFIG_CAN_DEV is not set
# CONFIG_CAN_DEBUG_DEVICES is not set
# CONFIG_IRDA is not set
CONFIG_BT=y
CONFIG_BT_RFCOMM=y
# CONFIG_BT_RFCOMM_TTY is not set
# CONFIG_BT_BNEP is not set
CONFIG_BT_HIDP=y

#
# Bluetooth device drivers
#
CONFIG_BT_HCIBTUSB=y
# CONFIG_BT_HCIUART is not set
# CONFIG_BT_HCIBCM203X is not set
# CONFIG_BT_HCIBPA10X is not set
# CONFIG_BT_HCIBFUSB is not set
CONFIG_BT_HCIVHCI=y
# CONFIG_BT_MRVL is not set
CONFIG_BT_ATH3K=y
CONFIG_AF_RXRPC=y
# CONFIG_AF_RXRPC_DEBUG is not set
CONFIG_RXKAD=y
CONFIG_FIB_RULES=y
# CONFIG_WIRELESS is not set
CONFIG_WIMAX=y
CONFIG_WIMAX_DEBUG_LEVEL=8
# CONFIG_RFKILL is not set
CONFIG_RFKILL_REGULATOR=y
CONFIG_NET_9P=y
# CONFIG_NET_9P_VIRTIO is not set
CONFIG_NET_9P_RDMA=y
# CONFIG_NET_9P_DEBUG is not set
CONFIG_CAIF=y
CONFIG_CAIF_DEBUG=y
CONFIG_CAIF_NETDEV=y
CONFIG_CAIF_USB=y
CONFIG_CEPH_LIB=y
# CONFIG_CEPH_LIB_PRETTYDEBUG is not set
CONFIG_CEPH_LIB_USE_DNS_RESOLVER=y
CONFIG_NFC=y
CONFIG_NFC_NCI=y
# CONFIG_NFC_HCI is not set

#
# Near Field Communication (NFC) devices
#
# CONFIG_NFC_PN533 is not set
CONFIG_NFC_SIM=y
CONFIG_HAVE_BPF_JIT=y

#
# Device Drivers
#

#
# Generic Driver Options
#
CONFIG_UEVENT_HELPER_PATH=""
# CONFIG_DEVTMPFS is not set
CONFIG_STANDALONE=y
# CONFIG_PREVENT_FIRMWARE_BUILD is not set
CONFIG_FW_LOADER=y
# CONFIG_FIRMWARE_IN_KERNEL is not set
CONFIG_EXTRA_FIRMWARE=""
CONFIG_FW_LOADER_USER_HELPER=y
# CONFIG_DEBUG_DRIVER is not set
CONFIG_DEBUG_DEVRES=y
# CONFIG_SYS_HYPERVISOR is not set
# CONFIG_GENERIC_CPU_DEVICES is not set
CONFIG_REGMAP=y
CONFIG_REGMAP_I2C=y
CONFIG_REGMAP_MMIO=y
CONFIG_REGMAP_IRQ=y
CONFIG_DMA_SHARED_BUFFER=y

#
# Bus devices
#
CONFIG_CONNECTOR=y
# CONFIG_PROC_EVENTS is not set
# CONFIG_MTD is not set
CONFIG_PARPORT=y
CONFIG_PARPORT_PC=y
# CONFIG_PARPORT_SERIAL is not set
# CONFIG_PARPORT_PC_FIFO is not set
CONFIG_PARPORT_PC_SUPERIO=y
# CONFIG_PARPORT_GSC is not set
# CONFIG_PARPORT_AX88796 is not set
# CONFIG_PARPORT_1284 is not set
CONFIG_PNP=y
CONFIG_PNP_DEBUG_MESSAGES=y

#
# Protocols
#
CONFIG_PNPACPI=y
CONFIG_BLK_DEV=y
CONFIG_PARIDE=y

#
# Parallel IDE high-level drivers
#
CONFIG_PARIDE_PD=y
CONFIG_PARIDE_PCD=y
# CONFIG_PARIDE_PF is not set
CONFIG_PARIDE_PT=y
# CONFIG_PARIDE_PG is not set

#
# Parallel IDE protocol modules
#
CONFIG_PARIDE_ATEN=y
CONFIG_PARIDE_BPCK=y
CONFIG_PARIDE_COMM=y
# CONFIG_PARIDE_DSTR is not set
CONFIG_PARIDE_FIT2=y
# CONFIG_PARIDE_FIT3 is not set
CONFIG_PARIDE_EPAT=y
CONFIG_PARIDE_EPATC8=y
# CONFIG_PARIDE_EPIA is not set
CONFIG_PARIDE_FRIQ=y
CONFIG_PARIDE_FRPW=y
CONFIG_PARIDE_KBIC=y
# CONFIG_PARIDE_KTTI is not set
CONFIG_PARIDE_ON20=y
# CONFIG_PARIDE_ON26 is not set
CONFIG_BLK_DEV_PCIESSD_MTIP32XX=y
# CONFIG_BLK_CPQ_DA is not set
# CONFIG_BLK_CPQ_CISS_DA is not set
CONFIG_BLK_DEV_DAC960=y
CONFIG_BLK_DEV_UMEM=y
# CONFIG_BLK_DEV_COW_COMMON is not set
# CONFIG_BLK_DEV_LOOP is not set

#
# DRBD disabled because PROC_FS or INET not selected
#
CONFIG_BLK_DEV_NBD=y
CONFIG_BLK_DEV_NVME=y
CONFIG_BLK_DEV_OSD=y
CONFIG_BLK_DEV_SX8=y
# CONFIG_BLK_DEV_RAM is not set
# CONFIG_CDROM_PKTCDVD is not set
CONFIG_ATA_OVER_ETH=y
CONFIG_VIRTIO_BLK=y
# CONFIG_BLK_DEV_HD is not set
CONFIG_BLK_DEV_RBD=y
CONFIG_BLK_DEV_RSXX=y

#
# Misc devices
#
CONFIG_SENSORS_LIS3LV02D=y
# CONFIG_ATMEL_PWM is not set
# CONFIG_DUMMY_IRQ is not set
CONFIG_IBM_ASM=y
CONFIG_PHANTOM=y
# CONFIG_INTEL_MID_PTI is not set
# CONFIG_SGI_IOC4 is not set
# CONFIG_TIFM_CORE is not set
CONFIG_ICS932S401=y
CONFIG_ATMEL_SSC=y
# CONFIG_ENCLOSURE_SERVICES is not set
CONFIG_CS5535_MFGPT=y
CONFIG_CS5535_MFGPT_DEFAULT_IRQ=7
CONFIG_CS5535_CLOCK_EVENT_SRC=y
CONFIG_HP_ILO=y
CONFIG_APDS9802ALS=y
CONFIG_ISL29020=y
CONFIG_SENSORS_BH1770=y
CONFIG_SENSORS_APDS990X=y
CONFIG_HMC6352=y
CONFIG_DS1682=y
# CONFIG_VMWARE_BALLOON is not set
# CONFIG_PCH_PHUB is not set
CONFIG_USB_SWITCH_FSA9480=y
CONFIG_SRAM=y
CONFIG_C2PORT=y
CONFIG_C2PORT_DURAMAR_2150=y

#
# EEPROM support
#
CONFIG_EEPROM_MAX6875=y
CONFIG_EEPROM_93CX6=y
# CONFIG_CB710_CORE is not set

#
# Texas Instruments shared transport line discipline
#
# CONFIG_SENSORS_LIS3_I2C is not set

#
# Altera FPGA firmware download module
#
CONFIG_ALTERA_STAPL=y
CONFIG_INTEL_MEI=y
CONFIG_INTEL_MEI_ME=y
# CONFIG_VMWARE_VMCI is not set
CONFIG_HAVE_IDE=y
CONFIG_IDE=y

#
# Please see Documentation/ide/ide.txt for help/info on IDE drives
#
CONFIG_IDE_XFER_MODE=y
CONFIG_IDE_TIMINGS=y
CONFIG_IDE_ATAPI=y
CONFIG_BLK_DEV_IDE_SATA=y
# CONFIG_IDE_GD is not set
CONFIG_BLK_DEV_IDECD=y
CONFIG_BLK_DEV_IDECD_VERBOSE_ERRORS=y
CONFIG_BLK_DEV_IDETAPE=y
# CONFIG_BLK_DEV_IDEACPI is not set
# CONFIG_IDE_TASK_IOCTL is not set

#
# IDE chipset support/bugfixes
#
# CONFIG_IDE_GENERIC is not set
CONFIG_BLK_DEV_PLATFORM=y
CONFIG_BLK_DEV_CMD640=y
# CONFIG_BLK_DEV_CMD640_ENHANCED is not set
CONFIG_BLK_DEV_IDEPNP=y
CONFIG_BLK_DEV_IDEDMA_SFF=y

#
# PCI IDE chipsets support
#
CONFIG_BLK_DEV_IDEPCI=y
# CONFIG_IDEPCI_PCIBUS_ORDER is not set
CONFIG_BLK_DEV_OFFBOARD=y
CONFIG_BLK_DEV_GENERIC=y
# CONFIG_BLK_DEV_OPTI621 is not set
CONFIG_BLK_DEV_RZ1000=y
CONFIG_BLK_DEV_IDEDMA_PCI=y
CONFIG_BLK_DEV_AEC62XX=y
CONFIG_BLK_DEV_ALI15X3=y
# CONFIG_BLK_DEV_AMD74XX is not set
CONFIG_BLK_DEV_ATIIXP=y
# CONFIG_BLK_DEV_CMD64X is not set
CONFIG_BLK_DEV_TRIFLEX=y
# CONFIG_BLK_DEV_CS5520 is not set
# CONFIG_BLK_DEV_CS5530 is not set
# CONFIG_BLK_DEV_HPT366 is not set
CONFIG_BLK_DEV_JMICRON=y
CONFIG_BLK_DEV_SC1200=y
CONFIG_BLK_DEV_PIIX=y
# CONFIG_BLK_DEV_IT8172 is not set
CONFIG_BLK_DEV_IT8213=y
CONFIG_BLK_DEV_IT821X=y
CONFIG_BLK_DEV_NS87415=y
CONFIG_BLK_DEV_PDC202XX_OLD=y
CONFIG_BLK_DEV_PDC202XX_NEW=y
CONFIG_BLK_DEV_SVWKS=y
CONFIG_BLK_DEV_SIIMAGE=y
CONFIG_BLK_DEV_SIS5513=y
CONFIG_BLK_DEV_SLC90E66=y
CONFIG_BLK_DEV_TRM290=y
CONFIG_BLK_DEV_VIA82CXXX=y
CONFIG_BLK_DEV_TC86C001=y
CONFIG_BLK_DEV_IDEDMA=y

#
# SCSI device support
#
CONFIG_SCSI_MOD=y
CONFIG_RAID_ATTRS=y
CONFIG_SCSI=y
CONFIG_SCSI_DMA=y
# CONFIG_SCSI_TGT is not set
CONFIG_SCSI_NETLINK=y

#
# SCSI support type (disk, tape, CD-ROM)
#
CONFIG_BLK_DEV_SD=y
CONFIG_CHR_DEV_ST=y
# CONFIG_CHR_DEV_OSST is not set
# CONFIG_BLK_DEV_SR is not set
CONFIG_CHR_DEV_SG=y
CONFIG_CHR_DEV_SCH=y
# CONFIG_SCSI_MULTI_LUN is not set
# CONFIG_SCSI_CONSTANTS is not set
CONFIG_SCSI_LOGGING=y
# CONFIG_SCSI_SCAN_ASYNC is not set

#
# SCSI Transports
#
CONFIG_SCSI_SPI_ATTRS=y
CONFIG_SCSI_FC_ATTRS=y
CONFIG_SCSI_ISCSI_ATTRS=y
CONFIG_SCSI_SAS_ATTRS=y
CONFIG_SCSI_SAS_LIBSAS=y
CONFIG_SCSI_SAS_HOST_SMP=y
CONFIG_SCSI_SRP_ATTRS=y
# CONFIG_SCSI_LOWLEVEL is not set
# CONFIG_SCSI_DH is not set
CONFIG_SCSI_OSD_INITIATOR=y
CONFIG_SCSI_OSD_ULD=y
CONFIG_SCSI_OSD_DPRINT_SENSE=1
CONFIG_SCSI_OSD_DEBUG=y
# CONFIG_ATA is not set
CONFIG_MD=y
# CONFIG_BLK_DEV_MD is not set
CONFIG_BCACHE=y
# CONFIG_BCACHE_DEBUG is not set
CONFIG_BCACHE_EDEBUG=y
# CONFIG_BCACHE_CLOSURES_DEBUG is not set
CONFIG_BLK_DEV_DM=y
# CONFIG_DM_DEBUG is not set
CONFIG_DM_BUFIO=y
CONFIG_DM_BIO_PRISON=y
CONFIG_DM_PERSISTENT_DATA=y
# CONFIG_DM_CRYPT is not set
CONFIG_DM_SNAPSHOT=y
CONFIG_DM_THIN_PROVISIONING=y
# CONFIG_DM_DEBUG_BLOCK_STACK_TRACING is not set
# CONFIG_DM_CACHE is not set
CONFIG_DM_MIRROR=y
# CONFIG_DM_RAID is not set
# CONFIG_DM_LOG_USERSPACE is not set
CONFIG_DM_ZERO=y
CONFIG_DM_MULTIPATH=y
# CONFIG_DM_MULTIPATH_QL is not set
CONFIG_DM_MULTIPATH_ST=y
CONFIG_DM_DELAY=y
# CONFIG_DM_UEVENT is not set
CONFIG_DM_FLAKEY=y
CONFIG_DM_VERITY=y
CONFIG_DM_SWITCH=y
# CONFIG_TARGET_CORE is not set
CONFIG_FUSION=y
CONFIG_FUSION_SPI=y
CONFIG_FUSION_FC=y
CONFIG_FUSION_SAS=y
CONFIG_FUSION_MAX_SGE=128
CONFIG_FUSION_CTL=y
CONFIG_FUSION_LOGGING=y

#
# IEEE 1394 (FireWire) support
#
# CONFIG_FIREWIRE is not set
CONFIG_FIREWIRE_NOSY=y
CONFIG_I2O=y
CONFIG_I2O_LCT_NOTIFY_ON_CHANGES=y
CONFIG_I2O_EXT_ADAPTEC=y
CONFIG_I2O_EXT_ADAPTEC_DMA64=y
CONFIG_I2O_CONFIG=y
CONFIG_I2O_CONFIG_OLD_IOCTL=y
# CONFIG_I2O_BUS is not set
# CONFIG_I2O_BLOCK is not set
CONFIG_I2O_SCSI=y
# CONFIG_I2O_PROC is not set
CONFIG_MACINTOSH_DRIVERS=y
# CONFIG_NETDEVICES is not set
CONFIG_VHOST_NET=y
CONFIG_VHOST_RING=y
CONFIG_VHOST=y

#
# Input device support
#
CONFIG_INPUT=y
CONFIG_INPUT_FF_MEMLESS=y
CONFIG_INPUT_POLLDEV=y
CONFIG_INPUT_SPARSEKMAP=y
CONFIG_INPUT_MATRIXKMAP=y

#
# Userland interfaces
#
CONFIG_INPUT_MOUSEDEV=y
CONFIG_INPUT_MOUSEDEV_PSAUX=y
CONFIG_INPUT_MOUSEDEV_SCREEN_X=1024
CONFIG_INPUT_MOUSEDEV_SCREEN_Y=768
CONFIG_INPUT_JOYDEV=y
CONFIG_INPUT_EVDEV=y
# CONFIG_INPUT_EVBUG is not set

#
# Input Device Drivers
#
CONFIG_INPUT_KEYBOARD=y
# CONFIG_KEYBOARD_ADP5520 is not set
# CONFIG_KEYBOARD_ADP5588 is not set
# CONFIG_KEYBOARD_ADP5589 is not set
CONFIG_KEYBOARD_ATKBD=y
# CONFIG_KEYBOARD_QT1070 is not set
# CONFIG_KEYBOARD_QT2160 is not set
# CONFIG_KEYBOARD_LKKBD is not set
# CONFIG_KEYBOARD_TCA6416 is not set
# CONFIG_KEYBOARD_TCA8418 is not set
# CONFIG_KEYBOARD_LM8323 is not set
# CONFIG_KEYBOARD_LM8333 is not set
# CONFIG_KEYBOARD_MAX7359 is not set
# CONFIG_KEYBOARD_MCS is not set
# CONFIG_KEYBOARD_MPR121 is not set
# CONFIG_KEYBOARD_NEWTON is not set
# CONFIG_KEYBOARD_OPENCORES is not set
# CONFIG_KEYBOARD_SAMSUNG is not set
# CONFIG_KEYBOARD_STOWAWAY is not set
# CONFIG_KEYBOARD_SUNKBD is not set
# CONFIG_KEYBOARD_STMPE is not set
# CONFIG_KEYBOARD_XTKBD is not set
CONFIG_INPUT_MOUSE=y
CONFIG_MOUSE_PS2=y
CONFIG_MOUSE_PS2_ALPS=y
# CONFIG_MOUSE_PS2_LOGIPS2PP is not set
CONFIG_MOUSE_PS2_SYNAPTICS=y
CONFIG_MOUSE_PS2_CYPRESS=y
# CONFIG_MOUSE_PS2_LIFEBOOK is not set
# CONFIG_MOUSE_PS2_TRACKPOINT is not set
# CONFIG_MOUSE_PS2_ELANTECH is not set
# CONFIG_MOUSE_PS2_SENTELIC is not set
CONFIG_MOUSE_PS2_TOUCHKIT=y
# CONFIG_MOUSE_SERIAL is not set
CONFIG_MOUSE_APPLETOUCH=y
CONFIG_MOUSE_BCM5974=y
CONFIG_MOUSE_CYAPA=y
# CONFIG_MOUSE_VSXXXAA is not set
# CONFIG_MOUSE_SYNAPTICS_I2C is not set
CONFIG_MOUSE_SYNAPTICS_USB=y
# CONFIG_INPUT_JOYSTICK is not set
# CONFIG_INPUT_TABLET is not set
# CONFIG_INPUT_TOUCHSCREEN is not set
CONFIG_INPUT_MISC=y
CONFIG_INPUT_88PM860X_ONKEY=y
# CONFIG_INPUT_AD714X is not set
CONFIG_INPUT_BMA150=y
# CONFIG_INPUT_MC13783_PWRBUTTON is not set
CONFIG_INPUT_MMA8450=y
CONFIG_INPUT_MPU3050=y
# CONFIG_INPUT_APANEL is not set
# CONFIG_INPUT_ATLAS_BTNS is not set
CONFIG_INPUT_ATI_REMOTE2=y
# CONFIG_INPUT_KEYSPAN_REMOTE is not set
# CONFIG_INPUT_KXTJ9 is not set
CONFIG_INPUT_POWERMATE=y
CONFIG_INPUT_YEALINK=y
CONFIG_INPUT_CM109=y
CONFIG_INPUT_RETU_PWRBUTTON=y
CONFIG_INPUT_TWL6040_VIBRA=y
CONFIG_INPUT_UINPUT=y
# CONFIG_INPUT_PCF50633_PMU is not set
# CONFIG_INPUT_PCF8574 is not set
# CONFIG_INPUT_DA9052_ONKEY is not set
CONFIG_INPUT_ADXL34X=y
# CONFIG_INPUT_ADXL34X_I2C is not set
# CONFIG_INPUT_IMS_PCU is not set
# CONFIG_INPUT_CMA3000 is not set
# CONFIG_INPUT_IDEAPAD_SLIDEBAR is not set

#
# Hardware I/O ports
#
CONFIG_SERIO=y
CONFIG_SERIO_I8042=y
CONFIG_SERIO_SERPORT=y
CONFIG_SERIO_CT82C710=y
CONFIG_SERIO_PARKBD=y
CONFIG_SERIO_PCIPS2=y
CONFIG_SERIO_LIBPS2=y
# CONFIG_SERIO_RAW is not set
# CONFIG_SERIO_ALTERA_PS2 is not set
# CONFIG_SERIO_PS2MULT is not set
CONFIG_SERIO_ARC_PS2=y
CONFIG_GAMEPORT=y
# CONFIG_GAMEPORT_NS558 is not set
CONFIG_GAMEPORT_L4=y
CONFIG_GAMEPORT_EMU10K1=y
CONFIG_GAMEPORT_FM801=y

#
# Character devices
#
CONFIG_TTY=y
# CONFIG_VT is not set
CONFIG_UNIX98_PTYS=y
# CONFIG_DEVPTS_MULTIPLE_INSTANCES is not set
CONFIG_LEGACY_PTYS=y
CONFIG_LEGACY_PTY_COUNT=256
# CONFIG_SERIAL_NONSTANDARD is not set
# CONFIG_NOZOMI is not set
# CONFIG_N_GSM is not set
# CONFIG_TRACE_SINK is not set
# CONFIG_DEVKMEM is not set

#
# Serial drivers
#
CONFIG_SERIAL_8250=y
CONFIG_SERIAL_8250_DEPRECATED_OPTIONS=y
CONFIG_SERIAL_8250_PNP=y
CONFIG_SERIAL_8250_CONSOLE=y
CONFIG_FIX_EARLYCON_MEM=y
CONFIG_SERIAL_8250_DMA=y
CONFIG_SERIAL_8250_PCI=y
CONFIG_SERIAL_8250_NR_UARTS=4
CONFIG_SERIAL_8250_RUNTIME_UARTS=4
# CONFIG_SERIAL_8250_EXTENDED is not set
# CONFIG_SERIAL_8250_DW is not set

#
# Non-8250 serial port support
#
# CONFIG_SERIAL_MFD_HSU is not set
CONFIG_SERIAL_CORE=y
CONFIG_SERIAL_CORE_CONSOLE=y
# CONFIG_SERIAL_JSM is not set
# CONFIG_SERIAL_SCCNXP is not set
# CONFIG_SERIAL_TIMBERDALE is not set
# CONFIG_SERIAL_ALTERA_JTAGUART is not set
# CONFIG_SERIAL_ALTERA_UART is not set
# CONFIG_SERIAL_PCH_UART is not set
# CONFIG_SERIAL_ARC is not set
# CONFIG_SERIAL_RP2 is not set
# CONFIG_SERIAL_FSL_LPUART is not set
# CONFIG_SERIAL_ST_ASC is not set
# CONFIG_TTY_PRINTK is not set
# CONFIG_PRINTER is not set
CONFIG_PPDEV=y
# CONFIG_VIRTIO_CONSOLE is not set
CONFIG_IPMI_HANDLER=y
CONFIG_IPMI_PANIC_EVENT=y
# CONFIG_IPMI_PANIC_STRING is not set
CONFIG_IPMI_DEVICE_INTERFACE=y
CONFIG_IPMI_SI=y
CONFIG_IPMI_WATCHDOG=y
CONFIG_IPMI_POWEROFF=y
# CONFIG_HW_RANDOM is not set
CONFIG_NVRAM=y
# CONFIG_R3964 is not set
CONFIG_APPLICOM=y
# CONFIG_MWAVE is not set
# CONFIG_RAW_DRIVER is not set
CONFIG_HPET=y
# CONFIG_HPET_MMAP is not set
CONFIG_HANGCHECK_TIMER=y
CONFIG_TCG_TPM=y
CONFIG_TCG_TIS=y
CONFIG_TCG_TIS_I2C_INFINEON=y
CONFIG_TCG_NSC=y
CONFIG_TCG_ATMEL=y
CONFIG_TCG_INFINEON=y
# CONFIG_TELCLOCK is not set
CONFIG_DEVPORT=y
CONFIG_I2C=y
CONFIG_I2C_BOARDINFO=y
CONFIG_I2C_COMPAT=y
CONFIG_I2C_CHARDEV=y
CONFIG_I2C_MUX=y

#
# Multiplexer I2C Chip support
#
CONFIG_I2C_MUX_PCA9541=y
CONFIG_I2C_MUX_PCA954x=y
CONFIG_I2C_MUX_PINCTRL=y
# CONFIG_I2C_HELPER_AUTO is not set
CONFIG_I2C_SMBUS=y

#
# I2C Algorithms
#
CONFIG_I2C_ALGOBIT=y
# CONFIG_I2C_ALGOPCF is not set
CONFIG_I2C_ALGOPCA=y

#
# I2C Hardware Bus support
#

#
# PC SMBus host controller drivers
#
# CONFIG_I2C_ALI1535 is not set
CONFIG_I2C_ALI1563=y
# CONFIG_I2C_ALI15X3 is not set
CONFIG_I2C_AMD756=y
CONFIG_I2C_AMD756_S4882=y
# CONFIG_I2C_AMD8111 is not set
CONFIG_I2C_I801=y
CONFIG_I2C_ISCH=y
CONFIG_I2C_ISMT=y
# CONFIG_I2C_PIIX4 is not set
CONFIG_I2C_NFORCE2=y
CONFIG_I2C_NFORCE2_S4985=y
# CONFIG_I2C_SIS5595 is not set
CONFIG_I2C_SIS630=y
CONFIG_I2C_SIS96X=y
CONFIG_I2C_VIA=y
CONFIG_I2C_VIAPRO=y

#
# ACPI drivers
#
CONFIG_I2C_SCMI=y

#
# I2C system bus drivers (mostly embedded / system-on-chip)
#
CONFIG_I2C_DESIGNWARE_CORE=y
# CONFIG_I2C_DESIGNWARE_PLATFORM is not set
CONFIG_I2C_DESIGNWARE_PCI=y
CONFIG_I2C_EG20T=y
CONFIG_I2C_KEMPLD=y
CONFIG_I2C_OCORES=y
# CONFIG_I2C_PCA_PLATFORM is not set
# CONFIG_I2C_PXA_PCI is not set
CONFIG_I2C_SIMTEC=y
CONFIG_I2C_XILINX=y

#
# External I2C/SMBus adapter drivers
#
CONFIG_I2C_DIOLAN_U2C=y
CONFIG_I2C_PARPORT=y
# CONFIG_I2C_PARPORT_LIGHT is not set
# CONFIG_I2C_TAOS_EVM is not set
CONFIG_I2C_TINY_USB=y
CONFIG_I2C_VIPERBOARD=y

#
# Other I2C/SMBus bus drivers
#
# CONFIG_I2C_DEBUG_CORE is not set
# CONFIG_I2C_DEBUG_ALGO is not set
# CONFIG_I2C_DEBUG_BUS is not set
# CONFIG_SPI is not set
CONFIG_HSI=y
CONFIG_HSI_BOARDINFO=y

#
# HSI clients
#
# CONFIG_HSI_CHAR is not set

#
# PPS support
#
CONFIG_PPS=y
# CONFIG_PPS_DEBUG is not set
CONFIG_NTP_PPS=y

#
# PPS clients support
#
# CONFIG_PPS_CLIENT_KTIMER is not set
# CONFIG_PPS_CLIENT_LDISC is not set
CONFIG_PPS_CLIENT_PARPORT=y
CONFIG_PPS_CLIENT_GPIO=y

#
# PPS generators support
#

#
# PTP clock support
#
CONFIG_PTP_1588_CLOCK=y

#
# Enable PHYLIB and NETWORK_PHY_TIMESTAMPING to see the additional clocks.
#
CONFIG_PTP_1588_CLOCK_PCH=y
CONFIG_PINCTRL=y

#
# Pin controllers
#
CONFIG_PINMUX=y
# CONFIG_PINCONF is not set
# CONFIG_DEBUG_PINCTRL is not set
CONFIG_ARCH_WANT_OPTIONAL_GPIOLIB=y
CONFIG_GPIO_DEVRES=y
# CONFIG_GPIOLIB is not set
CONFIG_W1=y
CONFIG_W1_CON=y

#
# 1-wire Bus Masters
#
# CONFIG_W1_MASTER_MATROX is not set
CONFIG_W1_MASTER_DS2490=y
CONFIG_W1_MASTER_DS2482=y
# CONFIG_W1_MASTER_DS1WM is not set

#
# 1-wire Slaves
#
CONFIG_W1_SLAVE_THERM=y
# CONFIG_W1_SLAVE_SMEM is not set
# CONFIG_W1_SLAVE_DS2408 is not set
CONFIG_W1_SLAVE_DS2413=y
# CONFIG_W1_SLAVE_DS2423 is not set
CONFIG_W1_SLAVE_DS2431=y
# CONFIG_W1_SLAVE_DS2433 is not set
CONFIG_W1_SLAVE_DS2760=y
CONFIG_W1_SLAVE_DS2780=y
CONFIG_W1_SLAVE_DS2781=y
# CONFIG_W1_SLAVE_DS28E04 is not set
CONFIG_W1_SLAVE_BQ27000=y
CONFIG_POWER_SUPPLY=y
CONFIG_POWER_SUPPLY_DEBUG=y
# CONFIG_PDA_POWER is not set
CONFIG_GENERIC_ADC_BATTERY=y
CONFIG_WM8350_POWER=y
CONFIG_TEST_POWER=y
CONFIG_BATTERY_88PM860X=y
CONFIG_BATTERY_DS2760=y
CONFIG_BATTERY_DS2780=y
CONFIG_BATTERY_DS2781=y
CONFIG_BATTERY_DS2782=y
CONFIG_BATTERY_SBS=y
# CONFIG_BATTERY_BQ27x00 is not set
CONFIG_BATTERY_DA9052=y
CONFIG_BATTERY_MAX17040=y
# CONFIG_BATTERY_MAX17042 is not set
CONFIG_CHARGER_88PM860X=y
# CONFIG_CHARGER_PCF50633 is not set
CONFIG_CHARGER_ISP1704=y
CONFIG_CHARGER_MAX8903=y
# CONFIG_CHARGER_LP8727 is not set
CONFIG_CHARGER_MAX8997=y
CONFIG_CHARGER_BQ2415X=y
# CONFIG_CHARGER_SMB347 is not set
CONFIG_BATTERY_GOLDFISH=y
# CONFIG_POWER_RESET is not set
CONFIG_POWER_AVS=y
CONFIG_HWMON=y
CONFIG_HWMON_VID=y
# CONFIG_HWMON_DEBUG_CHIP is not set

#
# Native drivers
#
CONFIG_SENSORS_ABITUGURU=y
# CONFIG_SENSORS_ABITUGURU3 is not set
CONFIG_SENSORS_AD7414=y
# CONFIG_SENSORS_AD7418 is not set
CONFIG_SENSORS_ADM1021=y
CONFIG_SENSORS_ADM1025=y
# CONFIG_SENSORS_ADM1026 is not set
CONFIG_SENSORS_ADM1029=y
# CONFIG_SENSORS_ADM1031 is not set
CONFIG_SENSORS_ADM9240=y
# CONFIG_SENSORS_ADT7410 is not set
CONFIG_SENSORS_ADT7411=y
# CONFIG_SENSORS_ADT7462 is not set
# CONFIG_SENSORS_ADT7470 is not set
CONFIG_SENSORS_ADT7475=y
CONFIG_SENSORS_ASC7621=y
CONFIG_SENSORS_K8TEMP=y
CONFIG_SENSORS_K10TEMP=y
# CONFIG_SENSORS_FAM15H_POWER is not set
CONFIG_SENSORS_ASB100=y
CONFIG_SENSORS_ATXP1=y
CONFIG_SENSORS_DS620=y
CONFIG_SENSORS_DS1621=y
CONFIG_SENSORS_DA9052_ADC=y
CONFIG_SENSORS_I5K_AMB=y
CONFIG_SENSORS_F71805F=y
CONFIG_SENSORS_F71882FG=y
CONFIG_SENSORS_F75375S=y
CONFIG_SENSORS_FSCHMD=y
CONFIG_SENSORS_G760A=y
CONFIG_SENSORS_G762=y
CONFIG_SENSORS_GL518SM=y
CONFIG_SENSORS_GL520SM=y
CONFIG_SENSORS_HIH6130=y
CONFIG_SENSORS_HTU21=y
CONFIG_SENSORS_CORETEMP=y
CONFIG_SENSORS_IBMAEM=y
CONFIG_SENSORS_IBMPEX=y
# CONFIG_SENSORS_IIO_HWMON is not set
CONFIG_SENSORS_IT87=y
# CONFIG_SENSORS_JC42 is not set
CONFIG_SENSORS_LINEAGE=y
# CONFIG_SENSORS_LM63 is not set
# CONFIG_SENSORS_LM73 is not set
CONFIG_SENSORS_LM75=y
# CONFIG_SENSORS_LM77 is not set
# CONFIG_SENSORS_LM78 is not set
CONFIG_SENSORS_LM80=y
CONFIG_SENSORS_LM83=y
CONFIG_SENSORS_LM85=y
CONFIG_SENSORS_LM87=y
CONFIG_SENSORS_LM90=y
CONFIG_SENSORS_LM92=y
CONFIG_SENSORS_LM93=y
# CONFIG_SENSORS_LTC4151 is not set
CONFIG_SENSORS_LTC4215=y
CONFIG_SENSORS_LTC4245=y
CONFIG_SENSORS_LTC4261=y
# CONFIG_SENSORS_LM95234 is not set
CONFIG_SENSORS_LM95241=y
CONFIG_SENSORS_LM95245=y
CONFIG_SENSORS_MAX16065=y
# CONFIG_SENSORS_MAX1619 is not set
CONFIG_SENSORS_MAX1668=y
# CONFIG_SENSORS_MAX197 is not set
CONFIG_SENSORS_MAX6639=y
# CONFIG_SENSORS_MAX6642 is not set
# CONFIG_SENSORS_MAX6650 is not set
# CONFIG_SENSORS_MAX6697 is not set
CONFIG_SENSORS_MCP3021=y
# CONFIG_SENSORS_NCT6775 is not set
CONFIG_SENSORS_PC87360=y
# CONFIG_SENSORS_PC87427 is not set
# CONFIG_SENSORS_PCF8591 is not set
CONFIG_PMBUS=y
CONFIG_SENSORS_PMBUS=y
CONFIG_SENSORS_ADM1275=y
CONFIG_SENSORS_LM25066=y
# CONFIG_SENSORS_LTC2978 is not set
# CONFIG_SENSORS_MAX16064 is not set
# CONFIG_SENSORS_MAX34440 is not set
CONFIG_SENSORS_MAX8688=y
# CONFIG_SENSORS_UCD9000 is not set
CONFIG_SENSORS_UCD9200=y
# CONFIG_SENSORS_ZL6100 is not set
# CONFIG_SENSORS_SHT21 is not set
CONFIG_SENSORS_SIS5595=y
CONFIG_SENSORS_SMM665=y
# CONFIG_SENSORS_DME1737 is not set
# CONFIG_SENSORS_EMC1403 is not set
CONFIG_SENSORS_EMC2103=y
CONFIG_SENSORS_EMC6W201=y
# CONFIG_SENSORS_SMSC47M1 is not set
CONFIG_SENSORS_SMSC47M192=y
CONFIG_SENSORS_SMSC47B397=y
# CONFIG_SENSORS_SCH56XX_COMMON is not set
# CONFIG_SENSORS_SCH5627 is not set
# CONFIG_SENSORS_SCH5636 is not set
CONFIG_SENSORS_ADS1015=y
CONFIG_SENSORS_ADS7828=y
# CONFIG_SENSORS_AMC6821 is not set
CONFIG_SENSORS_INA209=y
CONFIG_SENSORS_INA2XX=y
CONFIG_SENSORS_THMC50=y
CONFIG_SENSORS_TMP102=y
CONFIG_SENSORS_TMP401=y
CONFIG_SENSORS_TMP421=y
# CONFIG_SENSORS_VIA_CPUTEMP is not set
# CONFIG_SENSORS_VIA686A is not set
CONFIG_SENSORS_VT1211=y
# CONFIG_SENSORS_VT8231 is not set
CONFIG_SENSORS_W83781D=y
CONFIG_SENSORS_W83791D=y
# CONFIG_SENSORS_W83792D is not set
CONFIG_SENSORS_W83793=y
CONFIG_SENSORS_W83795=y
CONFIG_SENSORS_W83795_FANCTRL=y
# CONFIG_SENSORS_W83L785TS is not set
CONFIG_SENSORS_W83L786NG=y
CONFIG_SENSORS_W83627HF=y
# CONFIG_SENSORS_W83627EHF is not set
CONFIG_SENSORS_WM8350=y
CONFIG_SENSORS_APPLESMC=y
CONFIG_SENSORS_MC13783_ADC=y

#
# ACPI drivers
#
CONFIG_SENSORS_ACPI_POWER=y
CONFIG_SENSORS_ATK0110=y
CONFIG_THERMAL=y
CONFIG_THERMAL_HWMON=y
CONFIG_THERMAL_DEFAULT_GOV_STEP_WISE=y
# CONFIG_THERMAL_DEFAULT_GOV_FAIR_SHARE is not set
# CONFIG_THERMAL_DEFAULT_GOV_USER_SPACE is not set
CONFIG_THERMAL_GOV_FAIR_SHARE=y
CONFIG_THERMAL_GOV_STEP_WISE=y
CONFIG_THERMAL_GOV_USER_SPACE=y
CONFIG_CPU_THERMAL=y
CONFIG_THERMAL_EMULATION=y
CONFIG_INTEL_POWERCLAMP=y

#
# Texas Instruments thermal drivers
#
CONFIG_WATCHDOG=y
CONFIG_WATCHDOG_CORE=y
CONFIG_WATCHDOG_NOWAYOUT=y

#
# Watchdog Device Drivers
#
# CONFIG_SOFT_WATCHDOG is not set
CONFIG_DA9052_WATCHDOG=y
# CONFIG_WM8350_WATCHDOG is not set
CONFIG_RETU_WATCHDOG=y
# CONFIG_ACQUIRE_WDT is not set
CONFIG_ADVANTECH_WDT=y
# CONFIG_ALIM1535_WDT is not set
CONFIG_ALIM7101_WDT=y
CONFIG_F71808E_WDT=y
# CONFIG_SP5100_TCO is not set
CONFIG_GEODE_WDT=y
# CONFIG_SC520_WDT is not set
CONFIG_SBC_FITPC2_WATCHDOG=y
# CONFIG_EUROTECH_WDT is not set
CONFIG_IB700_WDT=y
# CONFIG_IBMASR is not set
CONFIG_WAFER_WDT=y
CONFIG_I6300ESB_WDT=y
CONFIG_IE6XX_WDT=y
CONFIG_ITCO_WDT=y
# CONFIG_ITCO_VENDOR_SUPPORT is not set
# CONFIG_IT8712F_WDT is not set
CONFIG_IT87_WDT=y
# CONFIG_HP_WATCHDOG is not set
# CONFIG_KEMPLD_WDT is not set
# CONFIG_SC1200_WDT is not set
# CONFIG_PC87413_WDT is not set
CONFIG_NV_TCO=y
CONFIG_60XX_WDT=y
# CONFIG_SBC8360_WDT is not set
CONFIG_CPU5_WDT=y
# CONFIG_SMSC_SCH311X_WDT is not set
CONFIG_SMSC37B787_WDT=y
CONFIG_VIA_WDT=y
CONFIG_W83627HF_WDT=y
# CONFIG_W83697HF_WDT is not set
# CONFIG_W83697UG_WDT is not set
# CONFIG_W83877F_WDT is not set
# CONFIG_W83977F_WDT is not set
# CONFIG_MACHZ_WDT is not set
CONFIG_SBC_EPX_C3_WATCHDOG=y

#
# PCI-based Watchdog Cards
#
CONFIG_PCIPCWATCHDOG=y
CONFIG_WDTPCI=y

#
# USB-based Watchdog Cards
#
CONFIG_USBPCWATCHDOG=y
CONFIG_SSB_POSSIBLE=y

#
# Sonics Silicon Backplane
#
CONFIG_SSB=y
CONFIG_SSB_PCIHOST_POSSIBLE=y
# CONFIG_SSB_PCIHOST is not set
# CONFIG_SSB_SILENT is not set
# CONFIG_SSB_DEBUG is not set
CONFIG_BCMA_POSSIBLE=y

#
# Broadcom specific AMBA
#
CONFIG_BCMA=y
CONFIG_BCMA_HOST_PCI_POSSIBLE=y
CONFIG_BCMA_HOST_PCI=y
# CONFIG_BCMA_HOST_SOC is not set
CONFIG_BCMA_DRIVER_GMAC_CMN=y
CONFIG_BCMA_DEBUG=y

#
# Multifunction device drivers
#
CONFIG_MFD_CORE=y
CONFIG_MFD_CS5535=y
# CONFIG_MFD_AS3711 is not set
CONFIG_PMIC_ADP5520=y
# CONFIG_MFD_CROS_EC is not set
# CONFIG_PMIC_DA903X is not set
CONFIG_PMIC_DA9052=y
CONFIG_MFD_DA9052_I2C=y
# CONFIG_MFD_DA9055 is not set
# CONFIG_MFD_DA9063 is not set
CONFIG_MFD_MC13783=y
CONFIG_MFD_MC13XXX=y
CONFIG_MFD_MC13XXX_I2C=y
CONFIG_HTC_PASIC3=y
CONFIG_LPC_ICH=y
CONFIG_LPC_SCH=y
CONFIG_MFD_JANZ_CMODIO=y
CONFIG_MFD_KEMPLD=y
# CONFIG_MFD_88PM800 is not set
CONFIG_MFD_88PM805=y
CONFIG_MFD_88PM860X=y
CONFIG_MFD_MAX77686=y
# CONFIG_MFD_MAX77693 is not set
CONFIG_MFD_MAX8907=y
# CONFIG_MFD_MAX8925 is not set
CONFIG_MFD_MAX8997=y
# CONFIG_MFD_MAX8998 is not set
CONFIG_MFD_VIPERBOARD=y
CONFIG_MFD_RETU=y
CONFIG_MFD_PCF50633=y
CONFIG_PCF50633_ADC=y
# CONFIG_PCF50633_GPIO is not set
CONFIG_MFD_RDC321X=y
CONFIG_MFD_RTSX_PCI=y
CONFIG_MFD_RC5T583=y
# CONFIG_MFD_SEC_CORE is not set
CONFIG_MFD_SI476X_CORE=y
# CONFIG_MFD_SM501 is not set
# CONFIG_MFD_SMSC is not set
CONFIG_ABX500_CORE=y
# CONFIG_AB3100_CORE is not set
CONFIG_MFD_STMPE=y

#
# STMicroelectronics STMPE Interface Drivers
#
CONFIG_STMPE_I2C=y
CONFIG_MFD_SYSCON=y
# CONFIG_MFD_TI_AM335X_TSCADC is not set
# CONFIG_MFD_LP8788 is not set
CONFIG_MFD_PALMAS=y
# CONFIG_TPS6105X is not set
# CONFIG_TPS6507X is not set
# CONFIG_MFD_TPS65090 is not set
CONFIG_MFD_TPS65217=y
# CONFIG_MFD_TPS6586X is not set
# CONFIG_MFD_TPS80031 is not set
# CONFIG_TWL4030_CORE is not set
CONFIG_TWL6040_CORE=y
CONFIG_MFD_WL1273_CORE=y
# CONFIG_MFD_LM3533 is not set
# CONFIG_MFD_TC3589X is not set
# CONFIG_MFD_TMIO is not set
CONFIG_MFD_VX855=y
CONFIG_MFD_ARIZONA=y
CONFIG_MFD_ARIZONA_I2C=y
CONFIG_MFD_WM5102=y
CONFIG_MFD_WM5110=y
# CONFIG_MFD_WM8997 is not set
# CONFIG_MFD_WM8400 is not set
# CONFIG_MFD_WM831X_I2C is not set
CONFIG_MFD_WM8350=y
CONFIG_MFD_WM8350_I2C=y
CONFIG_MFD_WM8994=y
CONFIG_REGULATOR=y
CONFIG_REGULATOR_DEBUG=y
# CONFIG_REGULATOR_DUMMY is not set
CONFIG_REGULATOR_FIXED_VOLTAGE=y
# CONFIG_REGULATOR_VIRTUAL_CONSUMER is not set
CONFIG_REGULATOR_USERSPACE_CONSUMER=y
# CONFIG_REGULATOR_88PM8607 is not set
CONFIG_REGULATOR_AD5398=y
CONFIG_REGULATOR_ANATOP=y
CONFIG_REGULATOR_DA9052=y
CONFIG_REGULATOR_DA9210=y
# CONFIG_REGULATOR_FAN53555 is not set
CONFIG_REGULATOR_ISL6271A=y
CONFIG_REGULATOR_LP3971=y
# CONFIG_REGULATOR_LP3972 is not set
CONFIG_REGULATOR_LP872X=y
CONFIG_REGULATOR_LP8755=y
CONFIG_REGULATOR_MAX1586=y
# CONFIG_REGULATOR_MAX8649 is not set
CONFIG_REGULATOR_MAX8660=y
# CONFIG_REGULATOR_MAX8907 is not set
CONFIG_REGULATOR_MAX8952=y
CONFIG_REGULATOR_MAX8973=y
CONFIG_REGULATOR_MAX8997=y
# CONFIG_REGULATOR_MAX77686 is not set
CONFIG_REGULATOR_MC13XXX_CORE=y
CONFIG_REGULATOR_MC13783=y
CONFIG_REGULATOR_MC13892=y
# CONFIG_REGULATOR_PALMAS is not set
# CONFIG_REGULATOR_PCF50633 is not set
CONFIG_REGULATOR_PFUZE100=y
# CONFIG_REGULATOR_RC5T583 is not set
CONFIG_REGULATOR_TPS51632=y
# CONFIG_REGULATOR_TPS62360 is not set
CONFIG_REGULATOR_TPS65023=y
CONFIG_REGULATOR_TPS6507X=y
# CONFIG_REGULATOR_TPS65217 is not set
CONFIG_REGULATOR_WM8350=y
CONFIG_REGULATOR_WM8994=y
# CONFIG_MEDIA_SUPPORT is not set

#
# Graphics support
#
CONFIG_AGP=y
CONFIG_AGP_AMD64=y
CONFIG_AGP_INTEL=y
CONFIG_AGP_SIS=y
# CONFIG_AGP_VIA is not set
CONFIG_VGA_ARB=y
CONFIG_VGA_ARB_MAX_GPUS=16
# CONFIG_VGA_SWITCHEROO is not set
CONFIG_DRM=y
CONFIG_DRM_USB=y
CONFIG_DRM_KMS_HELPER=y
# CONFIG_DRM_LOAD_EDID_FIRMWARE is not set
CONFIG_DRM_TTM=y

#
# I2C encoder or helper chips
#
# CONFIG_DRM_I2C_CH7006 is not set
CONFIG_DRM_I2C_SIL164=y
CONFIG_DRM_I2C_NXP_TDA998X=y
# CONFIG_DRM_TDFX is not set
CONFIG_DRM_R128=y
CONFIG_DRM_RADEON=y
CONFIG_DRM_RADEON_UMS=y
CONFIG_DRM_NOUVEAU=y
CONFIG_NOUVEAU_DEBUG=5
CONFIG_NOUVEAU_DEBUG_DEFAULT=3
CONFIG_DRM_NOUVEAU_BACKLIGHT=y
# CONFIG_DRM_I915 is not set
CONFIG_DRM_MGA=y
CONFIG_DRM_SIS=y
# CONFIG_DRM_VIA is not set
CONFIG_DRM_SAVAGE=y
# CONFIG_DRM_VMWGFX is not set
# CONFIG_DRM_GMA500 is not set
CONFIG_DRM_UDL=y
# CONFIG_DRM_AST is not set
# CONFIG_DRM_MGAG200 is not set
CONFIG_DRM_CIRRUS_QEMU=y
CONFIG_DRM_QXL=y
CONFIG_VGASTATE=y
CONFIG_VIDEO_OUTPUT_CONTROL=y
CONFIG_HDMI=y
CONFIG_FB=y
CONFIG_FIRMWARE_EDID=y
CONFIG_FB_DDC=y
CONFIG_FB_BOOT_VESA_SUPPORT=y
CONFIG_FB_CFB_FILLRECT=y
CONFIG_FB_CFB_COPYAREA=y
CONFIG_FB_CFB_IMAGEBLIT=y
# CONFIG_FB_CFB_REV_PIXELS_IN_BYTE is not set
CONFIG_FB_SYS_FILLRECT=y
CONFIG_FB_SYS_COPYAREA=y
CONFIG_FB_SYS_IMAGEBLIT=y
# CONFIG_FB_FOREIGN_ENDIAN is not set
CONFIG_FB_SYS_FOPS=y
CONFIG_FB_DEFERRED_IO=y
CONFIG_FB_HECUBA=y
CONFIG_FB_SVGALIB=y
# CONFIG_FB_MACMODES is not set
CONFIG_FB_BACKLIGHT=y
CONFIG_FB_MODE_HELPERS=y
CONFIG_FB_TILEBLITTING=y

#
# Frame buffer hardware drivers
#
CONFIG_FB_CIRRUS=y
# CONFIG_FB_PM2 is not set
CONFIG_FB_CYBER2000=y
# CONFIG_FB_CYBER2000_DDC is not set
CONFIG_FB_ARC=y
# CONFIG_FB_ASILIANT is not set
# CONFIG_FB_IMSTT is not set
# CONFIG_FB_VGA16 is not set
# CONFIG_FB_UVESA is not set
# CONFIG_FB_VESA is not set
CONFIG_FB_N411=y
# CONFIG_FB_HGA is not set
CONFIG_FB_S1D13XXX=y
CONFIG_FB_NVIDIA=y
# CONFIG_FB_NVIDIA_I2C is not set
# CONFIG_FB_NVIDIA_DEBUG is not set
CONFIG_FB_NVIDIA_BACKLIGHT=y
CONFIG_FB_RIVA=y
CONFIG_FB_RIVA_I2C=y
# CONFIG_FB_RIVA_DEBUG is not set
# CONFIG_FB_RIVA_BACKLIGHT is not set
CONFIG_FB_I740=y
CONFIG_FB_LE80578=y
CONFIG_FB_CARILLO_RANCH=y
CONFIG_FB_INTEL=y
# CONFIG_FB_INTEL_DEBUG is not set
# CONFIG_FB_INTEL_I2C is not set
CONFIG_FB_MATROX=y
CONFIG_FB_MATROX_MILLENIUM=y
CONFIG_FB_MATROX_MYSTIQUE=y
CONFIG_FB_MATROX_G=y
# CONFIG_FB_MATROX_I2C is not set
CONFIG_FB_RADEON=y
CONFIG_FB_RADEON_I2C=y
# CONFIG_FB_RADEON_BACKLIGHT is not set
CONFIG_FB_RADEON_DEBUG=y
CONFIG_FB_ATY128=y
# CONFIG_FB_ATY128_BACKLIGHT is not set
CONFIG_FB_ATY=y
CONFIG_FB_ATY_CT=y
# CONFIG_FB_ATY_GENERIC_LCD is not set
CONFIG_FB_ATY_GX=y
CONFIG_FB_ATY_BACKLIGHT=y
CONFIG_FB_S3=y
# CONFIG_FB_S3_DDC is not set
CONFIG_FB_SAVAGE=y
# CONFIG_FB_SAVAGE_I2C is not set
# CONFIG_FB_SAVAGE_ACCEL is not set
CONFIG_FB_SIS=y
CONFIG_FB_SIS_300=y
CONFIG_FB_SIS_315=y
# CONFIG_FB_VIA is not set
CONFIG_FB_NEOMAGIC=y
# CONFIG_FB_KYRO is not set
# CONFIG_FB_3DFX is not set
# CONFIG_FB_VOODOO1 is not set
CONFIG_FB_VT8623=y
# CONFIG_FB_TRIDENT is not set
CONFIG_FB_ARK=y
CONFIG_FB_PM3=y
CONFIG_FB_CARMINE=y
CONFIG_FB_CARMINE_DRAM_EVAL=y
# CONFIG_CARMINE_DRAM_CUSTOM is not set
CONFIG_FB_GEODE=y
# CONFIG_FB_GEODE_LX is not set
CONFIG_FB_GEODE_GX=y
CONFIG_FB_GEODE_GX1=y
CONFIG_FB_TMIO=y
# CONFIG_FB_TMIO_ACCELL is not set
CONFIG_FB_SMSCUFX=y
CONFIG_FB_UDL=y
# CONFIG_FB_GOLDFISH is not set
# CONFIG_FB_VIRTUAL is not set
CONFIG_FB_METRONOME=y
CONFIG_FB_MB862XX=y
CONFIG_FB_MB862XX_PCI_GDC=y
# CONFIG_FB_MB862XX_I2C is not set
# CONFIG_FB_BROADSHEET is not set
# CONFIG_FB_AUO_K190X is not set
# CONFIG_FB_SIMPLE is not set
CONFIG_EXYNOS_VIDEO=y
CONFIG_BACKLIGHT_LCD_SUPPORT=y
# CONFIG_LCD_CLASS_DEVICE is not set
CONFIG_BACKLIGHT_CLASS_DEVICE=y
CONFIG_BACKLIGHT_GENERIC=y
CONFIG_BACKLIGHT_DA9052=y
CONFIG_BACKLIGHT_APPLE=y
# CONFIG_BACKLIGHT_SAHARA is not set
CONFIG_BACKLIGHT_ADP5520=y
# CONFIG_BACKLIGHT_ADP8860 is not set
CONFIG_BACKLIGHT_ADP8870=y
CONFIG_BACKLIGHT_88PM860X=y
CONFIG_BACKLIGHT_PCF50633=y
# CONFIG_BACKLIGHT_LM3630 is not set
# CONFIG_BACKLIGHT_LM3639 is not set
CONFIG_BACKLIGHT_LP855X=y
# CONFIG_BACKLIGHT_TPS65217 is not set
CONFIG_BACKLIGHT_LV5207LP=y
CONFIG_BACKLIGHT_BD6107=y
# CONFIG_LOGO is not set
CONFIG_SOUND=y
CONFIG_SOUND_OSS_CORE=y
CONFIG_SOUND_OSS_CORE_PRECLAIM=y
# CONFIG_SND is not set
CONFIG_SOUND_PRIME=y

#
# HID support
#
CONFIG_HID=y
# CONFIG_HID_BATTERY_STRENGTH is not set
# CONFIG_HIDRAW is not set
CONFIG_UHID=y
CONFIG_HID_GENERIC=y

#
# Special HID drivers
#
# CONFIG_HID_A4TECH is not set
CONFIG_HID_ACRUX=y
# CONFIG_HID_ACRUX_FF is not set
# CONFIG_HID_APPLE is not set
CONFIG_HID_APPLEIR=y
CONFIG_HID_AUREAL=y
CONFIG_HID_BELKIN=y
CONFIG_HID_CHERRY=y
# CONFIG_HID_CHICONY is not set
CONFIG_HID_CYPRESS=y
CONFIG_HID_DRAGONRISE=y
CONFIG_DRAGONRISE_FF=y
CONFIG_HID_EMS_FF=y
CONFIG_HID_ELECOM=y
CONFIG_HID_ELO=y
# CONFIG_HID_EZKEY is not set
# CONFIG_HID_HOLTEK is not set
CONFIG_HID_HUION=y
CONFIG_HID_KEYTOUCH=y
# CONFIG_HID_KYE is not set
CONFIG_HID_UCLOGIC=y
# CONFIG_HID_WALTOP is not set
# CONFIG_HID_GYRATION is not set
CONFIG_HID_ICADE=y
CONFIG_HID_TWINHAN=y
CONFIG_HID_KENSINGTON=y
# CONFIG_HID_LCPOWER is not set
# CONFIG_HID_LENOVO_TPKBD is not set
CONFIG_HID_LOGITECH=y
CONFIG_HID_LOGITECH_DJ=y
CONFIG_LOGITECH_FF=y
CONFIG_LOGIRUMBLEPAD2_FF=y
# CONFIG_LOGIG940_FF is not set
CONFIG_LOGIWHEELS_FF=y
# CONFIG_HID_MAGICMOUSE is not set
# CONFIG_HID_MICROSOFT is not set
# CONFIG_HID_MONTEREY is not set
# CONFIG_HID_MULTITOUCH is not set
# CONFIG_HID_NTRIG is not set
CONFIG_HID_ORTEK=y
# CONFIG_HID_PANTHERLORD is not set
CONFIG_HID_PETALYNX=y
CONFIG_HID_PICOLCD=y
CONFIG_HID_PICOLCD_FB=y
CONFIG_HID_PICOLCD_BACKLIGHT=y
CONFIG_HID_PICOLCD_LEDS=y
CONFIG_HID_PRIMAX=y
CONFIG_HID_ROCCAT=y
# CONFIG_HID_SAITEK is not set
CONFIG_HID_SAMSUNG=y
# CONFIG_HID_SONY is not set
# CONFIG_HID_SPEEDLINK is not set
CONFIG_HID_STEELSERIES=y
# CONFIG_HID_SUNPLUS is not set
# CONFIG_HID_GREENASIA is not set
CONFIG_HID_SMARTJOYPLUS=y
CONFIG_SMARTJOYPLUS_FF=y
CONFIG_HID_TIVO=y
CONFIG_HID_TOPSEED=y
CONFIG_HID_THINGM=y
CONFIG_HID_THRUSTMASTER=y
# CONFIG_THRUSTMASTER_FF is not set
CONFIG_HID_WACOM=y
CONFIG_HID_WIIMOTE=y
CONFIG_HID_XINMO=y
CONFIG_HID_ZEROPLUS=y
CONFIG_ZEROPLUS_FF=y
CONFIG_HID_ZYDACRON=y
CONFIG_HID_SENSOR_HUB=y

#
# USB HID support
#
CONFIG_USB_HID=y
# CONFIG_HID_PID is not set
CONFIG_USB_HIDDEV=y

#
# I2C HID support
#
CONFIG_I2C_HID=y
CONFIG_USB_OHCI_LITTLE_ENDIAN=y
CONFIG_USB_SUPPORT=y
CONFIG_USB_COMMON=y
CONFIG_USB_ARCH_HAS_HCD=y
CONFIG_USB=y
# CONFIG_USB_DEBUG is not set
# CONFIG_USB_ANNOUNCE_NEW_DEVICES is not set

#
# Miscellaneous USB options
#
# CONFIG_USB_DEFAULT_PERSIST is not set
CONFIG_USB_DYNAMIC_MINORS=y
# CONFIG_USB_OTG_WHITELIST is not set
# CONFIG_USB_OTG_BLACKLIST_HUB is not set
CONFIG_USB_MON=y
CONFIG_USB_WUSB=y
CONFIG_USB_WUSB_CBAF=y
CONFIG_USB_WUSB_CBAF_DEBUG=y

#
# USB Host Controller Drivers
#
CONFIG_USB_C67X00_HCD=y
CONFIG_USB_XHCI_HCD=y
# CONFIG_USB_EHCI_HCD is not set
CONFIG_USB_OXU210HP_HCD=y
# CONFIG_USB_ISP116X_HCD is not set
CONFIG_USB_ISP1760_HCD=y
CONFIG_USB_ISP1362_HCD=y
CONFIG_USB_FUSBH200_HCD=y
CONFIG_USB_FOTG210_HCD=y
CONFIG_USB_OHCI_HCD=y
# CONFIG_USB_OHCI_HCD_PCI is not set
# CONFIG_USB_OHCI_HCD_SSB is not set
CONFIG_USB_OHCI_HCD_PLATFORM=y
# CONFIG_USB_UHCI_HCD is not set
# CONFIG_USB_SL811_HCD is not set
CONFIG_USB_R8A66597_HCD=y
CONFIG_USB_WHCI_HCD=y
CONFIG_USB_HWA_HCD=y
# CONFIG_USB_HCD_BCMA is not set
CONFIG_USB_HCD_SSB=y
# CONFIG_USB_HCD_TEST_MODE is not set

#
# USB Device Class drivers
#
# CONFIG_USB_ACM is not set
CONFIG_USB_PRINTER=y
CONFIG_USB_WDM=y
# CONFIG_USB_TMC is not set

#
# NOTE: USB_STORAGE depends on SCSI but BLK_DEV_SD may
#

#
# also be needed; see USB_STORAGE Help for more info
#
CONFIG_USB_STORAGE=y
# CONFIG_USB_STORAGE_DEBUG is not set
CONFIG_USB_STORAGE_REALTEK=y
CONFIG_USB_STORAGE_DATAFAB=y
CONFIG_USB_STORAGE_FREECOM=y
CONFIG_USB_STORAGE_ISD200=y
CONFIG_USB_STORAGE_USBAT=y
# CONFIG_USB_STORAGE_SDDR09 is not set
# CONFIG_USB_STORAGE_SDDR55 is not set
CONFIG_USB_STORAGE_JUMPSHOT=y
# CONFIG_USB_STORAGE_ALAUDA is not set
CONFIG_USB_STORAGE_ONETOUCH=y
# CONFIG_USB_STORAGE_KARMA is not set
# CONFIG_USB_STORAGE_CYPRESS_ATACB is not set
CONFIG_USB_STORAGE_ENE_UB6250=y

#
# USB Imaging devices
#
# CONFIG_USB_MDC800 is not set
CONFIG_USB_MICROTEK=y
# CONFIG_USB_DWC3 is not set

#
# USB port drivers
#
# CONFIG_USB_USS720 is not set
# CONFIG_USB_SERIAL is not set

#
# USB Miscellaneous drivers
#
CONFIG_USB_EMI62=y
CONFIG_USB_EMI26=y
CONFIG_USB_ADUTUX=y
CONFIG_USB_SEVSEG=y
# CONFIG_USB_RIO500 is not set
CONFIG_USB_LEGOTOWER=y
CONFIG_USB_LCD=y
CONFIG_USB_LED=y
# CONFIG_USB_CYPRESS_CY7C63 is not set
# CONFIG_USB_CYTHERM is not set
# CONFIG_USB_IDMOUSE is not set
# CONFIG_USB_FTDI_ELAN is not set
CONFIG_USB_APPLEDISPLAY=y
# CONFIG_USB_LD is not set
CONFIG_USB_TRANCEVIBRATOR=y
# CONFIG_USB_IOWARRIOR is not set
CONFIG_USB_TEST=y
CONFIG_USB_EHSET_TEST_FIXTURE=y
CONFIG_USB_ISIGHTFW=y
CONFIG_USB_YUREX=y
CONFIG_USB_EZUSB_FX2=y
CONFIG_USB_HSIC_USB3503=y
CONFIG_USB_ATM=y
CONFIG_USB_SPEEDTOUCH=y
CONFIG_USB_CXACRU=y
CONFIG_USB_UEAGLEATM=y
CONFIG_USB_XUSBATM=y

#
# USB Physical Layer drivers
#
CONFIG_USB_PHY=y
CONFIG_NOP_USB_XCEIV=y
CONFIG_OMAP_CONTROL_USB=y
CONFIG_OMAP_USB3=y
CONFIG_AM335X_CONTROL_USB=y
CONFIG_AM335X_PHY_USB=y
CONFIG_SAMSUNG_USBPHY=y
CONFIG_SAMSUNG_USB2PHY=y
CONFIG_SAMSUNG_USB3PHY=y
# CONFIG_USB_ISP1301 is not set
CONFIG_USB_RCAR_PHY=y
# CONFIG_USB_GADGET is not set
CONFIG_UWB=y
CONFIG_UWB_HWA=y
CONFIG_UWB_WHCI=y
CONFIG_UWB_I1480U=y
# CONFIG_MMC is not set
# CONFIG_MEMSTICK is not set
CONFIG_NEW_LEDS=y
CONFIG_LEDS_CLASS=y

#
# LED drivers
#
CONFIG_LEDS_88PM860X=y
# CONFIG_LEDS_LM3530 is not set
CONFIG_LEDS_LM3642=y
CONFIG_LEDS_PCA9532=y
# CONFIG_LEDS_LP3944 is not set
CONFIG_LEDS_LP55XX_COMMON=y
# CONFIG_LEDS_LP5521 is not set
CONFIG_LEDS_LP5523=y
CONFIG_LEDS_LP5562=y
CONFIG_LEDS_LP8501=y
# CONFIG_LEDS_CLEVO_MAIL is not set
CONFIG_LEDS_PCA955X=y
CONFIG_LEDS_PCA963X=y
# CONFIG_LEDS_WM8350 is not set
CONFIG_LEDS_DA9052=y
CONFIG_LEDS_REGULATOR=y
CONFIG_LEDS_BD2802=y
CONFIG_LEDS_INTEL_SS4200=y
CONFIG_LEDS_ADP5520=y
# CONFIG_LEDS_DELL_NETBOOKS is not set
CONFIG_LEDS_MC13783=y
CONFIG_LEDS_TCA6507=y
CONFIG_LEDS_MAX8997=y
CONFIG_LEDS_LM355x=y
CONFIG_LEDS_OT200=y
CONFIG_LEDS_BLINKM=y

#
# LED Triggers
#
CONFIG_LEDS_TRIGGERS=y
# CONFIG_LEDS_TRIGGER_TIMER is not set
# CONFIG_LEDS_TRIGGER_ONESHOT is not set
CONFIG_LEDS_TRIGGER_HEARTBEAT=y
CONFIG_LEDS_TRIGGER_BACKLIGHT=y
CONFIG_LEDS_TRIGGER_CPU=y
CONFIG_LEDS_TRIGGER_DEFAULT_ON=y

#
# iptables trigger is under Netfilter config (LED target)
#
CONFIG_LEDS_TRIGGER_TRANSIENT=y
# CONFIG_LEDS_TRIGGER_CAMERA is not set
# CONFIG_ACCESSIBILITY is not set
CONFIG_INFINIBAND=y
CONFIG_INFINIBAND_USER_MAD=y
# CONFIG_INFINIBAND_USER_ACCESS is not set
CONFIG_INFINIBAND_ADDR_TRANS=y
CONFIG_INFINIBAND_MTHCA=y
# CONFIG_INFINIBAND_MTHCA_DEBUG is not set
CONFIG_INFINIBAND_QIB=y
# CONFIG_INFINIBAND_QIB_DCA is not set
# CONFIG_INFINIBAND_AMSO1100 is not set
CONFIG_INFINIBAND_NES=y
CONFIG_INFINIBAND_NES_DEBUG=y
CONFIG_INFINIBAND_SRP=y
# CONFIG_INFINIBAND_ISER is not set
# CONFIG_EDAC is not set
CONFIG_RTC_LIB=y
# CONFIG_RTC_CLASS is not set
CONFIG_DMADEVICES=y
CONFIG_DMADEVICES_DEBUG=y
# CONFIG_DMADEVICES_VDEBUG is not set

#
# DMA Devices
#
# CONFIG_INTEL_MID_DMAC is not set
CONFIG_INTEL_IOATDMA=y
CONFIG_DW_DMAC_CORE=y
CONFIG_DW_DMAC=y
CONFIG_DW_DMAC_PCI=y
CONFIG_TIMB_DMA=y
CONFIG_PCH_DMA=y
CONFIG_DMA_ENGINE=y
CONFIG_DMA_ACPI=y

#
# DMA Clients
#
CONFIG_NET_DMA=y
CONFIG_ASYNC_TX_DMA=y
CONFIG_DMATEST=y
CONFIG_DCA=y
CONFIG_AUXDISPLAY=y
CONFIG_KS0108=y
CONFIG_KS0108_PORT=0x378
CONFIG_KS0108_DELAY=2
# CONFIG_CFAG12864B is not set
# CONFIG_UIO is not set
CONFIG_VIRT_DRIVERS=y
CONFIG_VIRTIO=y

#
# Virtio drivers
#
CONFIG_VIRTIO_PCI=y
# CONFIG_VIRTIO_BALLOON is not set
# CONFIG_VIRTIO_MMIO is not set

#
# Microsoft Hyper-V guest support
#
# CONFIG_HYPERV is not set
# CONFIG_STAGING is not set
CONFIG_X86_PLATFORM_DEVICES=y
CONFIG_ACER_WMI=y
CONFIG_ACERHDF=y
CONFIG_ASUS_LAPTOP=y
CONFIG_CHROMEOS_LAPTOP=y
# CONFIG_DELL_LAPTOP is not set
CONFIG_DELL_WMI=y
CONFIG_DELL_WMI_AIO=y
# CONFIG_FUJITSU_LAPTOP is not set
# CONFIG_FUJITSU_TABLET is not set
CONFIG_HP_ACCEL=y
# CONFIG_HP_WMI is not set
CONFIG_PANASONIC_LAPTOP=y
CONFIG_THINKPAD_ACPI=y
# CONFIG_THINKPAD_ACPI_DEBUGFACILITIES is not set
CONFIG_THINKPAD_ACPI_DEBUG=y
# CONFIG_THINKPAD_ACPI_UNSAFE_LEDS is not set
CONFIG_THINKPAD_ACPI_VIDEO=y
# CONFIG_THINKPAD_ACPI_HOTKEY_POLL is not set
CONFIG_SENSORS_HDAPS=y
CONFIG_ACPI_WMI=y
CONFIG_MSI_WMI=y
CONFIG_TOPSTAR_LAPTOP=y
# CONFIG_ACPI_TOSHIBA is not set
# CONFIG_TOSHIBA_BT_RFKILL is not set
# CONFIG_ACPI_CMPC is not set
# CONFIG_INTEL_IPS is not set
# CONFIG_IBM_RTL is not set
CONFIG_XO15_EBOOK=y
CONFIG_SAMSUNG_LAPTOP=y
CONFIG_MXM_WMI=y
CONFIG_SAMSUNG_Q10=y
# CONFIG_APPLE_GMUX is not set
# CONFIG_INTEL_RST is not set
# CONFIG_INTEL_SMARTCONNECT is not set
CONFIG_PVPANIC=y
CONFIG_CLKDEV_LOOKUP=y
CONFIG_HAVE_CLK_PREPARE=y
CONFIG_COMMON_CLK=y

#
# Common Clock Framework
#
CONFIG_COMMON_CLK_DEBUG=y
CONFIG_COMMON_CLK_MAX77686=y
CONFIG_COMMON_CLK_SI5351=y
CONFIG_CLK_TWL6040=y

#
# Hardware Spinlock drivers
#
CONFIG_CLKEVT_I8253=y
CONFIG_CLKBLD_I8253=y
# CONFIG_ARM_ARCH_TIMER_EVTSTREAM is not set
# CONFIG_MAILBOX is not set
CONFIG_IOMMU_SUPPORT=y
# CONFIG_AMD_IOMMU is not set

#
# Remoteproc drivers
#
CONFIG_REMOTEPROC=y
CONFIG_STE_MODEM_RPROC=y

#
# Rpmsg drivers
#
CONFIG_PM_DEVFREQ=y

#
# DEVFREQ Governors
#
CONFIG_DEVFREQ_GOV_SIMPLE_ONDEMAND=y
CONFIG_DEVFREQ_GOV_PERFORMANCE=y
# CONFIG_DEVFREQ_GOV_POWERSAVE is not set
# CONFIG_DEVFREQ_GOV_USERSPACE is not set

#
# DEVFREQ Drivers
#
CONFIG_EXTCON=y

#
# Extcon Device Drivers
#
CONFIG_EXTCON_ADC_JACK=y
CONFIG_EXTCON_MAX8997=y
# CONFIG_EXTCON_PALMAS is not set
# CONFIG_MEMORY is not set
CONFIG_IIO=y
CONFIG_IIO_BUFFER=y
CONFIG_IIO_BUFFER_CB=y
CONFIG_IIO_KFIFO_BUF=y
CONFIG_IIO_TRIGGERED_BUFFER=y
CONFIG_IIO_TRIGGER=y
CONFIG_IIO_CONSUMERS_PER_TRIGGER=2

#
# Accelerometers
#
# CONFIG_BMA180 is not set
# CONFIG_HID_SENSOR_ACCEL_3D is not set

#
# Analog to digital converters
#
# CONFIG_MAX1363 is not set
# CONFIG_NAU7802 is not set
# CONFIG_TI_ADC081C is not set
# CONFIG_VIPERBOARD_ADC is not set

#
# Amplifiers
#

#
# Hid Sensor IIO Common
#
CONFIG_HID_SENSOR_IIO_COMMON=y
CONFIG_HID_SENSOR_IIO_TRIGGER=y
CONFIG_HID_SENSOR_ENUM_BASE_QUIRKS=y

#
# Digital to analog converters
#
# CONFIG_AD5064 is not set
CONFIG_AD5380=y
CONFIG_AD5446=y
CONFIG_MAX517=y
CONFIG_MCP4725=y

#
# Frequency Synthesizers DDS/PLL
#

#
# Clock Generator/Distribution
#

#
# Phase-Locked Loop (PLL) frequency synthesizers
#

#
# Digital gyroscope sensors
#
CONFIG_HID_SENSOR_GYRO_3D=y
# CONFIG_ITG3200 is not set

#
# Inertial measurement units
#

#
# Light sensors
#
CONFIG_ADJD_S311=y
CONFIG_APDS9300=y
CONFIG_HID_SENSOR_ALS=y
CONFIG_SENSORS_TSL2563=y
# CONFIG_VCNL4000 is not set

#
# Magnetometer sensors
#
# CONFIG_HID_SENSOR_MAGNETOMETER_3D is not set

#
# Triggers - standalone
#
CONFIG_IIO_INTERRUPT_TRIGGER=y

#
# Pressure sensors
#

#
# Temperature sensors
#
# CONFIG_TMP006 is not set
CONFIG_NTB=y
CONFIG_VME_BUS=y

#
# VME Bridge Drivers
#
CONFIG_VME_CA91CX42=y
CONFIG_VME_TSI148=y

#
# VME Board Drivers
#
CONFIG_VMIVME_7805=y

#
# VME Device Drivers
#
# CONFIG_PWM is not set
CONFIG_IPACK_BUS=y
CONFIG_BOARD_TPCI200=y
# CONFIG_SERIAL_IPOCTAL is not set
CONFIG_RESET_CONTROLLER=y
CONFIG_FMC=y
CONFIG_FMC_FAKEDEV=y
# CONFIG_FMC_TRIVIAL is not set
CONFIG_FMC_WRITE_EEPROM=y
CONFIG_FMC_CHARDEV=y

#
# Firmware Drivers
#
CONFIG_EDD=y
CONFIG_EDD_OFF=y
CONFIG_FIRMWARE_MEMMAP=y
CONFIG_DELL_RBU=y
CONFIG_DCDBAS=y
# CONFIG_DMIID is not set
# CONFIG_ISCSI_IBFT_FIND is not set
# CONFIG_GOOGLE_FIRMWARE is not set

#
# File systems
#
CONFIG_DCACHE_WORD_ACCESS=y
CONFIG_EXT2_FS=y
CONFIG_EXT2_FS_XATTR=y
CONFIG_EXT2_FS_POSIX_ACL=y
CONFIG_EXT2_FS_SECURITY=y
CONFIG_EXT2_FS_XIP=y
CONFIG_EXT3_FS=y
# CONFIG_EXT3_DEFAULTS_TO_ORDERED is not set
# CONFIG_EXT3_FS_XATTR is not set
# CONFIG_EXT4_FS is not set
CONFIG_FS_XIP=y
CONFIG_JBD=y
CONFIG_JBD_DEBUG=y
CONFIG_FS_MBCACHE=y
CONFIG_REISERFS_FS=y
# CONFIG_REISERFS_CHECK is not set
# CONFIG_REISERFS_FS_XATTR is not set
# CONFIG_JFS_FS is not set
# CONFIG_XFS_FS is not set
CONFIG_GFS2_FS=y
# CONFIG_BTRFS_FS is not set
CONFIG_NILFS2_FS=y
CONFIG_FS_POSIX_ACL=y
CONFIG_EXPORTFS=y
CONFIG_FILE_LOCKING=y
# CONFIG_FSNOTIFY is not set
# CONFIG_DNOTIFY is not set
# CONFIG_INOTIFY_USER is not set
# CONFIG_FANOTIFY is not set
CONFIG_QUOTA=y
CONFIG_QUOTA_NETLINK_INTERFACE=y
# CONFIG_PRINT_QUOTA_WARNING is not set
# CONFIG_QUOTA_DEBUG is not set
CONFIG_QUOTA_TREE=y
# CONFIG_QFMT_V1 is not set
CONFIG_QFMT_V2=y
CONFIG_QUOTACTL=y
CONFIG_AUTOFS4_FS=y
CONFIG_FUSE_FS=y
CONFIG_CUSE=y

#
# Caches
#
CONFIG_FSCACHE=y
# CONFIG_FSCACHE_DEBUG is not set
# CONFIG_CACHEFILES is not set

#
# CD-ROM/DVD Filesystems
#
CONFIG_ISO9660_FS=y
# CONFIG_JOLIET is not set
# CONFIG_ZISOFS is not set
CONFIG_UDF_FS=y
CONFIG_UDF_NLS=y

#
# DOS/FAT/NT Filesystems
#
CONFIG_FAT_FS=y
CONFIG_MSDOS_FS=y
# CONFIG_VFAT_FS is not set
CONFIG_FAT_DEFAULT_CODEPAGE=437
CONFIG_NTFS_FS=y
# CONFIG_NTFS_DEBUG is not set
CONFIG_NTFS_RW=y

#
# Pseudo filesystems
#
# CONFIG_PROC_FS is not set
CONFIG_PROC_PAGE_MONITOR=y
# CONFIG_SYSFS is not set
# CONFIG_HUGETLBFS is not set
# CONFIG_HUGETLB_PAGE is not set
# CONFIG_CONFIGFS_FS is not set
CONFIG_MISC_FILESYSTEMS=y
CONFIG_ADFS_FS=y
CONFIG_ADFS_FS_RW=y
# CONFIG_AFFS_FS is not set
CONFIG_ECRYPT_FS=y
CONFIG_ECRYPT_FS_MESSAGING=y
CONFIG_HFS_FS=y
# CONFIG_HFSPLUS_FS is not set
CONFIG_BEFS_FS=y
# CONFIG_BEFS_DEBUG is not set
# CONFIG_BFS_FS is not set
CONFIG_EFS_FS=y
CONFIG_LOGFS=y
# CONFIG_CRAMFS is not set
# CONFIG_SQUASHFS is not set
# CONFIG_VXFS_FS is not set
CONFIG_MINIX_FS=y
CONFIG_OMFS_FS=y
CONFIG_HPFS_FS=y
# CONFIG_QNX4FS_FS is not set
CONFIG_QNX6FS_FS=y
# CONFIG_QNX6FS_DEBUG is not set
# CONFIG_ROMFS_FS is not set
CONFIG_PSTORE=y
# CONFIG_PSTORE_CONSOLE is not set
CONFIG_PSTORE_RAM=y
CONFIG_SYSV_FS=y
CONFIG_UFS_FS=y
CONFIG_UFS_FS_WRITE=y
# CONFIG_UFS_DEBUG is not set
# CONFIG_EXOFS_FS is not set
CONFIG_F2FS_FS=y
CONFIG_F2FS_STAT_FS=y
CONFIG_F2FS_FS_XATTR=y
CONFIG_F2FS_FS_POSIX_ACL=y
# CONFIG_F2FS_FS_SECURITY is not set
CONFIG_NETWORK_FILESYSTEMS=y
# CONFIG_NFS_FS is not set
CONFIG_NFSD=y
CONFIG_NFSD_V3=y
# CONFIG_NFSD_V3_ACL is not set
CONFIG_LOCKD=y
CONFIG_LOCKD_V4=y
CONFIG_NFS_COMMON=y
CONFIG_SUNRPC=y
CONFIG_SUNRPC_GSS=y
CONFIG_SUNRPC_XPRT_RDMA=y
CONFIG_RPCSEC_GSS_KRB5=y
CONFIG_CEPH_FS=y
CONFIG_CEPH_FSCACHE=y
# CONFIG_CIFS is not set
CONFIG_NCP_FS=y
CONFIG_NCPFS_PACKET_SIGNING=y
# CONFIG_NCPFS_IOCTL_LOCKING is not set
# CONFIG_NCPFS_STRONG is not set
CONFIG_NCPFS_NFS_NS=y
CONFIG_NCPFS_OS2_NS=y
CONFIG_NCPFS_SMALLDOS=y
# CONFIG_NCPFS_NLS is not set
CONFIG_NCPFS_EXTRAS=y
# CONFIG_CODA_FS is not set
# CONFIG_AFS_FS is not set
CONFIG_9P_FS=y
# CONFIG_9P_FSCACHE is not set
CONFIG_9P_FS_POSIX_ACL=y
# CONFIG_9P_FS_SECURITY is not set
CONFIG_NLS=y
CONFIG_NLS_DEFAULT="iso8859-1"
CONFIG_NLS_CODEPAGE_437=y
CONFIG_NLS_CODEPAGE_737=y
CONFIG_NLS_CODEPAGE_775=y
CONFIG_NLS_CODEPAGE_850=y
CONFIG_NLS_CODEPAGE_852=y
CONFIG_NLS_CODEPAGE_855=y
CONFIG_NLS_CODEPAGE_857=y
# CONFIG_NLS_CODEPAGE_860 is not set
CONFIG_NLS_CODEPAGE_861=y
CONFIG_NLS_CODEPAGE_862=y
CONFIG_NLS_CODEPAGE_863=y
CONFIG_NLS_CODEPAGE_864=y
# CONFIG_NLS_CODEPAGE_865 is not set
CONFIG_NLS_CODEPAGE_866=y
# CONFIG_NLS_CODEPAGE_869 is not set
# CONFIG_NLS_CODEPAGE_936 is not set
CONFIG_NLS_CODEPAGE_950=y
CONFIG_NLS_CODEPAGE_932=y
# CONFIG_NLS_CODEPAGE_949 is not set
CONFIG_NLS_CODEPAGE_874=y
CONFIG_NLS_ISO8859_8=y
CONFIG_NLS_CODEPAGE_1250=y
CONFIG_NLS_CODEPAGE_1251=y
# CONFIG_NLS_ASCII is not set
# CONFIG_NLS_ISO8859_1 is not set
# CONFIG_NLS_ISO8859_2 is not set
CONFIG_NLS_ISO8859_3=y
CONFIG_NLS_ISO8859_4=y
CONFIG_NLS_ISO8859_5=y
# CONFIG_NLS_ISO8859_6 is not set
# CONFIG_NLS_ISO8859_7 is not set
# CONFIG_NLS_ISO8859_9 is not set
# CONFIG_NLS_ISO8859_13 is not set
# CONFIG_NLS_ISO8859_14 is not set
CONFIG_NLS_ISO8859_15=y
CONFIG_NLS_KOI8_R=y
CONFIG_NLS_KOI8_U=y
CONFIG_NLS_MAC_ROMAN=y
CONFIG_NLS_MAC_CELTIC=y
# CONFIG_NLS_MAC_CENTEURO is not set
CONFIG_NLS_MAC_CROATIAN=y
CONFIG_NLS_MAC_CYRILLIC=y
CONFIG_NLS_MAC_GAELIC=y
CONFIG_NLS_MAC_GREEK=y
CONFIG_NLS_MAC_ICELAND=y
CONFIG_NLS_MAC_INUIT=y
CONFIG_NLS_MAC_ROMANIAN=y
CONFIG_NLS_MAC_TURKISH=y
CONFIG_NLS_UTF8=y

#
# Kernel hacking
#
CONFIG_TRACE_IRQFLAGS_SUPPORT=y

#
# printk and dmesg options
#
CONFIG_PRINTK_TIME=y
CONFIG_DEFAULT_MESSAGE_LOGLEVEL=4
# CONFIG_BOOT_PRINTK_DELAY is not set
# CONFIG_DYNAMIC_DEBUG is not set

#
# Compile-time checks and compiler options
#
# CONFIG_DEBUG_INFO is not set
# CONFIG_ENABLE_WARN_DEPRECATED is not set
# CONFIG_ENABLE_MUST_CHECK is not set
CONFIG_FRAME_WARN=2048
CONFIG_STRIP_ASM_SYMS=y
CONFIG_READABLE_ASM=y
# CONFIG_UNUSED_SYMBOLS is not set
CONFIG_DEBUG_FS=y
# CONFIG_HEADERS_CHECK is not set
CONFIG_DEBUG_SECTION_MISMATCH=y
CONFIG_ARCH_WANT_FRAME_POINTERS=y
CONFIG_FRAME_POINTER=y
# CONFIG_DEBUG_FORCE_WEAK_PER_CPU is not set
# CONFIG_MAGIC_SYSRQ is not set
CONFIG_DEBUG_KERNEL=y

#
# Memory Debugging
#
# CONFIG_DEBUG_PAGEALLOC is not set
# CONFIG_DEBUG_OBJECTS is not set
# CONFIG_DEBUG_SLAB is not set
CONFIG_HAVE_DEBUG_KMEMLEAK=y
# CONFIG_DEBUG_KMEMLEAK is not set
# CONFIG_DEBUG_STACK_USAGE is not set
CONFIG_DEBUG_VM=y
CONFIG_DEBUG_VM_RB=y
CONFIG_DEBUG_VIRTUAL=y
CONFIG_DEBUG_MEMORY_INIT=y
CONFIG_DEBUG_PER_CPU_MAPS=y
CONFIG_HAVE_DEBUG_STACKOVERFLOW=y
CONFIG_DEBUG_STACKOVERFLOW=y
CONFIG_HAVE_ARCH_KMEMCHECK=y
# CONFIG_KMEMCHECK is not set
CONFIG_DEBUG_SHIRQ=y

#
# Debug Lockups and Hangs
#
# CONFIG_LOCKUP_DETECTOR is not set
CONFIG_DETECT_HUNG_TASK=y
CONFIG_DEFAULT_HUNG_TASK_TIMEOUT=120
CONFIG_BOOTPARAM_HUNG_TASK_PANIC=y
CONFIG_BOOTPARAM_HUNG_TASK_PANIC_VALUE=1
# CONFIG_PANIC_ON_OOPS is not set
CONFIG_PANIC_ON_OOPS_VALUE=0
# CONFIG_DEBUG_PREEMPT is not set

#
# Lock Debugging (spinlocks, mutexes, etc...)
#
CONFIG_DEBUG_RT_MUTEXES=y
CONFIG_DEBUG_PI_LIST=y
# CONFIG_RT_MUTEX_TESTER is not set
CONFIG_DEBUG_SPINLOCK=y
CONFIG_DEBUG_MUTEXES=y
# CONFIG_DEBUG_WW_MUTEX_SLOWPATH is not set
CONFIG_DEBUG_LOCK_ALLOC=y
CONFIG_PROVE_LOCKING=y
CONFIG_LOCKDEP=y
# CONFIG_LOCK_STAT is not set
CONFIG_DEBUG_LOCKDEP=y
CONFIG_DEBUG_ATOMIC_SLEEP=y
# CONFIG_DEBUG_LOCKING_API_SELFTESTS is not set
CONFIG_TRACE_IRQFLAGS=y
CONFIG_STACKTRACE=y
# CONFIG_DEBUG_KOBJECT is not set
CONFIG_DEBUG_BUGVERBOSE=y
CONFIG_DEBUG_WRITECOUNT=y
# CONFIG_DEBUG_LIST is not set
# CONFIG_DEBUG_SG is not set
# CONFIG_DEBUG_NOTIFIERS is not set
CONFIG_DEBUG_CREDENTIALS=y

#
# RCU Debugging
#
# CONFIG_PROVE_RCU is not set
# CONFIG_PROVE_RCU_DELAY is not set
# CONFIG_SPARSE_RCU_POINTER is not set
# CONFIG_RCU_TORTURE_TEST is not set
CONFIG_RCU_CPU_STALL_TIMEOUT=21
# CONFIG_RCU_CPU_STALL_VERBOSE is not set
# CONFIG_RCU_CPU_STALL_INFO is not set
CONFIG_RCU_TRACE=y
# CONFIG_DEBUG_BLOCK_EXT_DEVT is not set
# CONFIG_NOTIFIER_ERROR_INJECTION is not set
# CONFIG_FAULT_INJECTION is not set
CONFIG_ARCH_HAS_DEBUG_STRICT_USER_COPY_CHECKS=y
# CONFIG_DEBUG_STRICT_USER_COPY_CHECKS is not set
CONFIG_USER_STACKTRACE_SUPPORT=y
CONFIG_NOP_TRACER=y
CONFIG_HAVE_FUNCTION_TRACER=y
CONFIG_HAVE_FUNCTION_GRAPH_TRACER=y
CONFIG_HAVE_FUNCTION_GRAPH_FP_TEST=y
CONFIG_HAVE_FUNCTION_TRACE_MCOUNT_TEST=y
CONFIG_HAVE_DYNAMIC_FTRACE=y
CONFIG_HAVE_DYNAMIC_FTRACE_WITH_REGS=y
CONFIG_HAVE_FTRACE_MCOUNT_RECORD=y
CONFIG_HAVE_SYSCALL_TRACEPOINTS=y
CONFIG_HAVE_FENTRY=y
CONFIG_HAVE_C_RECORDMCOUNT=y
CONFIG_TRACER_MAX_TRACE=y
CONFIG_TRACE_CLOCK=y
CONFIG_RING_BUFFER=y
CONFIG_EVENT_TRACING=y
CONFIG_CONTEXT_SWITCH_TRACER=y
CONFIG_RING_BUFFER_ALLOW_SWAP=y
CONFIG_TRACING=y
CONFIG_GENERIC_TRACER=y
CONFIG_TRACING_SUPPORT=y
CONFIG_FTRACE=y
# CONFIG_FUNCTION_TRACER is not set
# CONFIG_IRQSOFF_TRACER is not set
CONFIG_PREEMPT_TRACER=y
CONFIG_SCHED_TRACER=y
# CONFIG_FTRACE_SYSCALLS is not set
CONFIG_TRACER_SNAPSHOT=y
CONFIG_TRACER_SNAPSHOT_PER_CPU_SWAP=y
CONFIG_BRANCH_PROFILE_NONE=y
# CONFIG_PROFILE_ANNOTATED_BRANCHES is not set
# CONFIG_PROFILE_ALL_BRANCHES is not set
# CONFIG_STACK_TRACER is not set
CONFIG_UPROBE_EVENT=y
CONFIG_PROBE_EVENTS=y
# CONFIG_FTRACE_STARTUP_TEST is not set
CONFIG_MMIOTRACE=y
CONFIG_RING_BUFFER_BENCHMARK=y
# CONFIG_RING_BUFFER_STARTUP_TEST is not set

#
# Runtime Testing
#
# CONFIG_LKDTM is not set
CONFIG_TEST_LIST_SORT=y
# CONFIG_BACKTRACE_SELF_TEST is not set
CONFIG_RBTREE_TEST=y
# CONFIG_ATOMIC64_SELFTEST is not set
# CONFIG_TEST_STRING_HELPERS is not set
CONFIG_TEST_KSTRTOX=y
# CONFIG_PROVIDE_OHCI1394_DMA_INIT is not set
# CONFIG_DMA_API_DEBUG is not set
# CONFIG_SAMPLES is not set
CONFIG_HAVE_ARCH_KGDB=y
# CONFIG_KGDB is not set
CONFIG_STRICT_DEVMEM=y
CONFIG_X86_VERBOSE_BOOTUP=y
# CONFIG_EARLY_PRINTK is not set
# CONFIG_X86_PTDUMP is not set
# CONFIG_DEBUG_RODATA is not set
CONFIG_DOUBLEFAULT=y
CONFIG_DEBUG_TLBFLUSH=y
# CONFIG_IOMMU_STRESS is not set
CONFIG_HAVE_MMIOTRACE_SUPPORT=y
CONFIG_IO_DELAY_TYPE_0X80=0
CONFIG_IO_DELAY_TYPE_0XED=1
CONFIG_IO_DELAY_TYPE_UDELAY=2
CONFIG_IO_DELAY_TYPE_NONE=3
# CONFIG_IO_DELAY_0X80 is not set
# CONFIG_IO_DELAY_0XED is not set
# CONFIG_IO_DELAY_UDELAY is not set
CONFIG_IO_DELAY_NONE=y
CONFIG_DEFAULT_IO_DELAY_TYPE=3
# CONFIG_DEBUG_BOOT_PARAMS is not set
# CONFIG_CPA_DEBUG is not set
# CONFIG_OPTIMIZE_INLINING is not set
CONFIG_DEBUG_NMI_SELFTEST=y
# CONFIG_X86_DEBUG_STATIC_CPU_HAS is not set

#
# Security options
#
CONFIG_KEYS=y
CONFIG_TRUSTED_KEYS=y
# CONFIG_ENCRYPTED_KEYS is not set
# CONFIG_KEYS_DEBUG_PROC_KEYS is not set
CONFIG_SECURITY_DMESG_RESTRICT=y
CONFIG_SECURITYFS=y
CONFIG_DEFAULT_SECURITY_DAC=y
CONFIG_DEFAULT_SECURITY=""
CONFIG_CRYPTO=y

#
# Crypto core or helper
#
CONFIG_CRYPTO_ALGAPI=y
CONFIG_CRYPTO_ALGAPI2=y
CONFIG_CRYPTO_AEAD=y
CONFIG_CRYPTO_AEAD2=y
CONFIG_CRYPTO_BLKCIPHER=y
CONFIG_CRYPTO_BLKCIPHER2=y
CONFIG_CRYPTO_HASH=y
CONFIG_CRYPTO_HASH2=y
CONFIG_CRYPTO_RNG=y
CONFIG_CRYPTO_RNG2=y
CONFIG_CRYPTO_PCOMP=y
CONFIG_CRYPTO_PCOMP2=y
CONFIG_CRYPTO_MANAGER=y
CONFIG_CRYPTO_MANAGER2=y
CONFIG_CRYPTO_USER=y
CONFIG_CRYPTO_MANAGER_DISABLE_TESTS=y
CONFIG_CRYPTO_GF128MUL=y
CONFIG_CRYPTO_NULL=y
CONFIG_CRYPTO_PCRYPT=y
CONFIG_CRYPTO_WORKQUEUE=y
CONFIG_CRYPTO_CRYPTD=y
CONFIG_CRYPTO_AUTHENC=y
CONFIG_CRYPTO_ABLK_HELPER_X86=y
CONFIG_CRYPTO_GLUE_HELPER_X86=y

#
# Authenticated Encryption with Associated Data
#
CONFIG_CRYPTO_CCM=y
CONFIG_CRYPTO_GCM=y
CONFIG_CRYPTO_SEQIV=y

#
# Block modes
#
CONFIG_CRYPTO_CBC=y
CONFIG_CRYPTO_CTR=y
CONFIG_CRYPTO_CTS=y
CONFIG_CRYPTO_ECB=y
CONFIG_CRYPTO_LRW=y
CONFIG_CRYPTO_PCBC=y
CONFIG_CRYPTO_XTS=y

#
# Hash modes
#
# CONFIG_CRYPTO_CMAC is not set
CONFIG_CRYPTO_HMAC=y
# CONFIG_CRYPTO_XCBC is not set
CONFIG_CRYPTO_VMAC=y

#
# Digest
#
CONFIG_CRYPTO_CRC32C=y
# CONFIG_CRYPTO_CRC32C_INTEL is not set
CONFIG_CRYPTO_CRC32=y
CONFIG_CRYPTO_CRC32_PCLMUL=y
CONFIG_CRYPTO_CRCT10DIF=y
CONFIG_CRYPTO_CRCT10DIF_PCLMUL=y
CONFIG_CRYPTO_GHASH=y
CONFIG_CRYPTO_MD4=y
CONFIG_CRYPTO_MD5=y
# CONFIG_CRYPTO_MICHAEL_MIC is not set
CONFIG_CRYPTO_RMD128=y
CONFIG_CRYPTO_RMD160=y
CONFIG_CRYPTO_RMD256=y
CONFIG_CRYPTO_RMD320=y
CONFIG_CRYPTO_SHA1=y
CONFIG_CRYPTO_SHA1_SSSE3=y
CONFIG_CRYPTO_SHA256_SSSE3=y
# CONFIG_CRYPTO_SHA512_SSSE3 is not set
CONFIG_CRYPTO_SHA256=y
CONFIG_CRYPTO_SHA512=y
# CONFIG_CRYPTO_TGR192 is not set
# CONFIG_CRYPTO_WP512 is not set
CONFIG_CRYPTO_GHASH_CLMUL_NI_INTEL=y

#
# Ciphers
#
CONFIG_CRYPTO_AES=y
CONFIG_CRYPTO_AES_X86_64=y
CONFIG_CRYPTO_AES_NI_INTEL=y
CONFIG_CRYPTO_ANUBIS=y
CONFIG_CRYPTO_ARC4=y
CONFIG_CRYPTO_BLOWFISH=y
CONFIG_CRYPTO_BLOWFISH_COMMON=y
CONFIG_CRYPTO_BLOWFISH_X86_64=y
CONFIG_CRYPTO_CAMELLIA=y
CONFIG_CRYPTO_CAMELLIA_X86_64=y
CONFIG_CRYPTO_CAMELLIA_AESNI_AVX_X86_64=y
CONFIG_CRYPTO_CAMELLIA_AESNI_AVX2_X86_64=y
CONFIG_CRYPTO_CAST_COMMON=y
CONFIG_CRYPTO_CAST5=y
CONFIG_CRYPTO_CAST5_AVX_X86_64=y
CONFIG_CRYPTO_CAST6=y
CONFIG_CRYPTO_CAST6_AVX_X86_64=y
CONFIG_CRYPTO_DES=y
CONFIG_CRYPTO_FCRYPT=y
CONFIG_CRYPTO_KHAZAD=y
CONFIG_CRYPTO_SALSA20=y
CONFIG_CRYPTO_SALSA20_X86_64=y
CONFIG_CRYPTO_SEED=y
CONFIG_CRYPTO_SERPENT=y
# CONFIG_CRYPTO_SERPENT_SSE2_X86_64 is not set
CONFIG_CRYPTO_SERPENT_AVX_X86_64=y
CONFIG_CRYPTO_SERPENT_AVX2_X86_64=y
# CONFIG_CRYPTO_TEA is not set
CONFIG_CRYPTO_TWOFISH=y
CONFIG_CRYPTO_TWOFISH_COMMON=y
CONFIG_CRYPTO_TWOFISH_X86_64=y
CONFIG_CRYPTO_TWOFISH_X86_64_3WAY=y
CONFIG_CRYPTO_TWOFISH_AVX_X86_64=y

#
# Compression
#
CONFIG_CRYPTO_DEFLATE=y
CONFIG_CRYPTO_ZLIB=y
CONFIG_CRYPTO_LZO=y
CONFIG_CRYPTO_LZ4=y
# CONFIG_CRYPTO_LZ4HC is not set

#
# Random Number Generation
#
CONFIG_CRYPTO_ANSI_CPRNG=y
CONFIG_CRYPTO_USER_API=y
CONFIG_CRYPTO_USER_API_HASH=y
CONFIG_CRYPTO_USER_API_SKCIPHER=y
CONFIG_CRYPTO_HW=y
CONFIG_CRYPTO_DEV_PADLOCK=y
CONFIG_CRYPTO_DEV_PADLOCK_AES=y
# CONFIG_CRYPTO_DEV_PADLOCK_SHA is not set
CONFIG_ASYMMETRIC_KEY_TYPE=y
# CONFIG_ASYMMETRIC_PUBLIC_KEY_SUBTYPE is not set
CONFIG_HAVE_KVM=y
CONFIG_HAVE_KVM_IRQCHIP=y
CONFIG_HAVE_KVM_IRQ_ROUTING=y
CONFIG_HAVE_KVM_EVENTFD=y
CONFIG_KVM_APIC_ARCHITECTURE=y
CONFIG_KVM_MMIO=y
CONFIG_KVM_ASYNC_PF=y
CONFIG_HAVE_KVM_MSI=y
CONFIG_HAVE_KVM_CPU_RELAX_INTERCEPT=y
CONFIG_VIRTUALIZATION=y
CONFIG_KVM=y
CONFIG_KVM_INTEL=y
CONFIG_KVM_AMD=y
# CONFIG_KVM_MMU_AUDIT is not set
CONFIG_BINARY_PRINTF=y

#
# Library routines
#
CONFIG_BITREVERSE=y
CONFIG_RATIONAL=y
CONFIG_GENERIC_STRNCPY_FROM_USER=y
CONFIG_GENERIC_STRNLEN_USER=y
CONFIG_GENERIC_NET_UTILS=y
CONFIG_GENERIC_FIND_FIRST_BIT=y
CONFIG_GENERIC_PCI_IOMAP=y
CONFIG_GENERIC_IOMAP=y
CONFIG_GENERIC_IO=y
CONFIG_PERCPU_RWSEM=y
CONFIG_ARCH_USE_CMPXCHG_LOCKREF=y
CONFIG_CRC_CCITT=y
CONFIG_CRC16=y
CONFIG_CRC_T10DIF=y
CONFIG_CRC_ITU_T=y
CONFIG_CRC32=y
CONFIG_CRC32_SELFTEST=y
CONFIG_CRC32_SLICEBY8=y
# CONFIG_CRC32_SLICEBY4 is not set
# CONFIG_CRC32_SARWATE is not set
# CONFIG_CRC32_BIT is not set
CONFIG_CRC7=y
CONFIG_LIBCRC32C=y
CONFIG_CRC8=y
CONFIG_ZLIB_INFLATE=y
CONFIG_ZLIB_DEFLATE=y
CONFIG_LZO_COMPRESS=y
CONFIG_LZO_DECOMPRESS=y
CONFIG_LZ4_COMPRESS=y
CONFIG_LZ4_DECOMPRESS=y
CONFIG_XZ_DEC=y
CONFIG_XZ_DEC_X86=y
# CONFIG_XZ_DEC_POWERPC is not set
CONFIG_XZ_DEC_IA64=y
CONFIG_XZ_DEC_ARM=y
# CONFIG_XZ_DEC_ARMTHUMB is not set
# CONFIG_XZ_DEC_SPARC is not set
CONFIG_XZ_DEC_BCJ=y
# CONFIG_XZ_DEC_TEST is not set
CONFIG_DECOMPRESS_GZIP=y
CONFIG_DECOMPRESS_BZIP2=y
CONFIG_DECOMPRESS_LZ4=y
CONFIG_GENERIC_ALLOCATOR=y
CONFIG_REED_SOLOMON=y
CONFIG_REED_SOLOMON_ENC8=y
CONFIG_REED_SOLOMON_DEC8=y
CONFIG_TEXTSEARCH=y
CONFIG_TEXTSEARCH_KMP=y
CONFIG_TEXTSEARCH_BM=y
CONFIG_TEXTSEARCH_FSM=y
CONFIG_BTREE=y
CONFIG_HAS_IOMEM=y
CONFIG_HAS_IOPORT=y
CONFIG_HAS_DMA=y
CONFIG_CHECK_SIGNATURE=y
CONFIG_CPUMASK_OFFSTACK=y
CONFIG_NLATTR=y
CONFIG_ARCH_HAS_ATOMIC64_DEC_IF_POSITIVE=y
CONFIG_AVERAGE=y
CONFIG_CORDIC=y
# CONFIG_DDR is not set
CONFIG_OID_REGISTRY=y

--CblX+4bnyfN0pR09
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

_______________________________________________
LKP mailing list
LKP@linux.intel.com

--CblX+4bnyfN0pR09--
