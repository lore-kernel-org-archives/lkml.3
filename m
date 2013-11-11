Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751138Ab3KKB0b (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Nov 2013 20:26:31 -0500
Received: from mga01.intel.com ([192.55.52.88]:28016 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750904Ab3KKB0W (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Nov 2013 20:26:22 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.93,674,1378882800"; 
   d="log'?scan'208";a="425304795"
Date: Mon, 11 Nov 2013 09:26:16 +0800
From: Fengguang Wu <fengguang.wu@intel.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Michael wang <wangyun@linux.vnet.ibm.com>, Ingo Molnar <mingo@kernel.org>,
        linux-kernel@vger.kernel.org
Subject: Re: [sched/get_online_cpus] INFO: task swapper/0:1 blocked for more
 than 120 seconds.
Message-ID: <20131111012616.GA351@localhost>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="M9NhX3UHpAaciwkO"
Content-Disposition: inline
In-Reply-To: <20131110101612.GC21916@localhost>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--M9NhX3UHpAaciwkO
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Peter,

FYI. Here is another bisect result.

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

+------------------------------------------------------------------------------------+----+
|                                                                                    |    |
+------------------------------------------------------------------------------------+----+
| good_boots                                                                         | 3  |
| has_kernel_error_warning                                                           | 16 |
| INFO:task_blocked_for_more_than_seconds                                            | 16 |
| INFO:NMI_handler(arch_trigger_all_cpu_backtrace_handler)took_too_long_to_run:msecs | 16 |
| Kernel_panic-not_syncing:hung_task:blocked_tasks                                   | 16 |
+------------------------------------------------------------------------------------+----+

[    1.255438] EDD information not available.
[    1.255873] Unregister pv shared memory for cpu 0
[    1.898155] tsc: Refined TSC clocksource calibration: 2892.980 MHz
[  240.910063] INFO: task swapper/0:1 blocked for more than 120 seconds.
[  240.910691]       Not tainted 3.12.0-next-20131108-10601-gbad570d #3
[  240.911284] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
[  240.912017] swapper/0       D 0000ad00  5808     1      0 0x00000000
[  240.912638]  cec29dbc 00000092 c1c3b640 0000ad00 20024160 cec29dc8 c1a252c0 00000008
[  240.913462]  c1937d20 c1a252c0 cec17440 00000000 20024160 00000003 00000000 0000ad00
[  240.914364]  c1c6d500 00000000 cec17848 00000000 cec17440 c1077e17 cf082ab4 00000001
[  240.915212] Call Trace:
[  240.915447]  [<c1077e17>] ? mark_held_locks+0x87/0xf0
[  240.915915]  [<c1621a80>] schedule+0x10/0x20
[  240.916328]  [<c1620fd5>] schedule_timeout+0x125/0x180
[  240.916811]  [<c1625a02>] ? _raw_spin_unlock_irq+0x22/0x50
[  240.917325]  [<c16221f4>] ? wait_for_completion+0x94/0xd0
[  240.917825]  [<c107826b>] ? trace_hardirqs_on+0xb/0x10
[  240.918311]  [<c16221fb>] wait_for_completion+0x9b/0xd0
[  240.918807]  [<c1066aa0>] ? wake_up_state+0x10/0x10
[  240.919270]  [<c108af90>] ? __call_rcu.constprop.61+0x240/0x240
[  240.919823]  [<c108873f>] wait_rcu_gp+0x3f/0x60
[  240.920257]  [<c10885a0>] ? rcu_panic+0x20/0x20
[  240.920687]  [<c108cb9f>] synchronize_rcu+0x1f/0x40
[  240.921149]  [<c160b9a9>] _cpu_down+0x129/0x2c0
[  240.921578]  [<c160bbb2>] ? cpu_down+0x12/0x40
[  240.922006]  [<c12bd9ff>] ? lock_device_hotplug+0xf/0x20
[  240.922518]  [<c160bbc4>] cpu_down+0x24/0x40
[  240.922914]  [<c160b197>] _debug_hotplug_cpu+0x77/0xb0
[  240.923406]  [<c12c2c1e>] ? __platform_driver_register+0x3e/0x40
[  240.923965]  [<c19cae19>] ? pci_iommu_alloc+0x5a/0x5a
[  240.924448]  [<c19cae25>] debug_hotplug_cpu+0xc/0x10
[  240.924932]  [<c19c6b88>] do_one_initcall+0x8d/0x12c
[  240.925405]  [<c117129f>] ? strlen+0xf/0x20
[  240.925813]  [<c1059c93>] ? parameq+0x13/0x70
[  240.926230]  [<c19c6512>] ? repair_env_string+0x12/0x51
[  240.926722]  [<c1059ebf>] ? parse_args+0x1cf/0x320
[  240.927179]  [<c1052b6e>] ? __usermodehelper_set_disable_depth+0x3e/0x50
[  240.927802]  [<c19c6d12>] kernel_init_freeable+0xeb/0x17d
[  240.928310]  [<c19c6500>] ? do_early_param+0x78/0x78
[  240.928789]  [<c160b02b>] kernel_init+0xb/0x100
[  240.929222]  [<c1626cb7>] ret_from_kernel_thread+0x1b/0x28
[  240.929738]  [<c160b020>] ? rest_init+0xc0/0xc0
[  240.930168] 3 locks held by swapper/0/1:
[  240.930541]  #0:  (device_hotplug_lock){+.+.+.}, at: [<c12bd9ff>] lock_device_hotplug+0xf/0x20
[  240.931405]  #1:  (cpu_add_remove_lock){+.+.+.}, at: [<c160bbb2>] cpu_down+0x12/0x40
[  240.932198]  #2:  (cpu_hotplug.lock){+.+.+.}, at: [<c104242d>] cpu_hotplug_begin+0x1d/0x40
[  240.933039] sending NMI to all CPUs:
[  240.933381] NMI backtrace for cpu 1
[  240.933723] CPU: 1 PID: 46 Comm: khungtaskd Not tainted 3.12.0-next-20131108-10601-gbad570d #3
[  240.934031] task: cd645560 ti: cd66a000 task.ti: cd66a000
[  240.934031] EIP: 0060:[<c102c8e5>] EFLAGS: 00010046 CPU: 1
[  240.934031] EIP is at default_send_IPI_mask_logical+0x85/0xf0
[  240.934031] EAX: 00000c00 EBX: 03000000 ECX: fffff000 EDX: fffff000
[  240.934031] ESI: 00000206 EDI: 00000002 EBP: cd66bed4 ESP: cd66bec4
[  240.934031]  DS: 007b ES: 007b FS: 00d8 GS: 00e0 SS: 0068
[  240.934031] CR0: 8005003b CR2: ffffffff CR3: 01a2d000 CR4: 000006f0
[  240.934031] Stack:
[  240.934031]  00000800 00002710 00007fff 000003ff cd66bee0 c102ca18 00002710 cd66bef0
[  240.934031]  c102cc0d c1861994 cec17440 cd66bf30 c10a4632 c1871278 c1a37f6c c1925686
[  240.934031]  00000002 c19256c7 00000078 00000002 cec17534 00007fff cec17440 cec17534
[  240.934031] Call Trace:
[  240.934031]  [<c102ca18>] default_send_IPI_all+0x58/0x60
[  240.934031]  [<c102cc0d>] arch_trigger_all_cpu_backtrace+0x3d/0x70
[  240.934031]  [<c10a4632>] watchdog+0x2e2/0x300
[  240.934031]  [<c10a4350>] ? hung_task_panic+0x20/0x20
[  240.934031]  [<c105b6d7>] kthread+0xa7/0xc0
[  240.934031]  [<c1060000>] ? set_create_files_as+0x10/0x20
[  240.934031]  [<c1626cb7>] ret_from_kernel_thread+0x1b/0x28
[  240.934031]  [<c105b630>] ? __kthread_parkme+0x60/0x60
[  240.934031] Code: 00 b3 ff ff f6 c4 10 75 ed c1 e3 18 89 99 10 b3 ff ff 89 f8 09 d0 80 ce 04 83 ff 02 0f 44 c2 8b 15 04 06 93 c1 89 82 00 b3 ff ff <f7> c6 00 02 00 00 74 1b e8 6e b9 04 00 89 f0 50 9d 8d 74 26 00

git bisect start e1e958029781a5f22a47807f9648ab9d221746f4 v3.12 --
git bisect good 513e72b3ae0e7d35b09b72c360e548781b345fe7  # 18:57     25+      0  Merge remote-tracking branch 'pm/linux-next'
git bisect good a73f39d6bb13cd0eadf566e202dbfd114de2b9bc  # 19:09     25+      0  Merge remote-tracking branch 'virtio/virtio-next'
git bisect good 8d31e8536540635a1d56c9cd4a30eefe7f236644  # 19:23     25+      0  Merge remote-tracking branch 'spi/for-next'
git bisect  bad 47b8d9c8c38a956094e7f6b231371331dd2dd0d9  # 19:42      8-     10  Merge branch 'x86/hyperv'
git bisect good 8a4d0b56b031455adcbe4a9383c3b497456fcfac  # 20:00     28+      0  Merge branch 'uprobes/core' of git://git.kernel.org/pub/scm/linux/kernel/git/oleg/misc into perf/core
git bisect  bad c90423d1de12fbeaf0c898e1db0e962de347302b  # 20:17      8-      3  Merge branch 'sched/core' into core/locking, to prepare the kernel/locking/ file move
git bisect good 90572890d202527c366aa9489b32404e88a7c020  # 20:36     37+      0  mm: numa: Change page last {nid,pid} into {cpu,pid}
git bisect  bad b4145872f7049e429718b40b86e1b46659988398  # 20:53     15-     10  sched: Move wait code from core.c to wait.c
git bisect good 2739d3eef3a93a92c366a3a0bb85a0afe09e8b8c  # 21:08     37+      0  sched/numa: Retry task_numa_migrate() periodically
git bisect  bad 92ec11809565cf6429c75204e99e0f583b5c9d7c  # 21:17     15-     22  sched/wait: Fix build breakage
git bisect good ed1b7732868035990f07aeb532b1d86272ea909e  # 21:33     37+      0  sched/fair: Fix trivial typos in comments
git bisect  bad 6acce3ef84520537f8a09a12c9ddbe814a584dd2  # 21:40     24-     11  sched: Remove get_online_cpus() usage
git bisect good 746023159c40c523b08a3bc3d213dac212385895  # 21:47     41+      0  sched: Fix race in migrate_swap_stop()
git bisect good 746023159c40c523b08a3bc3d213dac212385895  # 21:51    123+      0  sched: Fix race in migrate_swap_stop()
git bisect  bad bad570d77024cba808126d68a2072f6f8ce64c27  # 21:52      0-     16  Add linux-next specific files for 20131108
git bisect good 93e7237f5344949f4fcb395d484ae89fca3c630b  # 22:11    123+      0  Revert "sched: Remove get_online_cpus() usage"
git bisect good 6c86ae2928f9e4cbf0d5844f5fcfd549e3450b8c  # 22:24    123+      0  Merge tag 'ftrace-urgent-3.12-v2' of git://git.kernel.org/pub/scm/linux/kernel/git/rostedt/linux-trace
git bisect  bad bad570d77024cba808126d68a2072f6f8ce64c27  # 22:24      0-     16  Add linux-next specific files for 20131108

Thanks,
Fengguang

--M9NhX3UHpAaciwkO
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="dmesg-yocto-xian-35:20131110140722:i386-randconfig-j3-11101308:3.12.0-next-20131108-10601-gbad570d:3"
Content-Transfer-Encoding: quoted-printable

[    0.000000] Initializing cgroup subsys cpu
[    0.000000] Linux version 3.12.0-next-20131108-10601-gbad570d (kbuild@ja=
ketown) (gcc version 4.8.1 (Debian 4.8.1-8) ) #3 SMP PREEMPT Sun Nov 10 14:=
01:45 CST 2013
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
[    0.000000] Hypervisor detected: KVM
[    0.000000] e820: update [mem 0x00000000-0x00000fff] usable =3D=3D> rese=
rved
[    0.000000] e820: remove [mem 0x000a0000-0x000fffff] usable
[    0.000000] e820: last_pfn =3D 0xfffe max_arch_pfn =3D 0x1000000
[    0.000000] initial memory mapped: [mem 0x00000000-0x023fffff]
[    0.000000] Base memory trampoline at [c009b000] 9b000 size 16384
[    0.000000] init_memory_mapping: [mem 0x00000000-0x000fffff]
[    0.000000]  [mem 0x00000000-0x000fffff] page 4k
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
[    0.000000] BRK [0x01ff2000, 0x01ff2fff] PGTABLE
[    0.000000] BRK [0x01ff3000, 0x01ff5fff] PGTABLE
[    0.000000] BRK [0x01ff6000, 0x01ff6fff] PGTABLE
[    0.000000] BRK [0x01ff7000, 0x01ff7fff] PGTABLE
[    0.000000] log_buf_len: 8388608
[    0.000000] early log buf free: 128856(98%)
[    0.000000] RAMDISK: [mem 0x0fce4000-0x0ffeffff]
[    0.000000] ACPI: RSDP 000fd930 000014 (v00 BOCHS )
[    0.000000] ACPI: RSDT 0fffe450 000034 (v01 BOCHS  BXPCRSDT 00000001 BXP=
C 00000001)
[    0.000000] ACPI: FACP 0fffff80 000074 (v01 BOCHS  BXPCFACP 00000001 BXP=
C 00000001)
[    0.000000] ACPI: DSDT 0fffe490 0011A9 (v01   BXPC   BXDSDT 00000001 INT=
L 20100528)
[    0.000000] ACPI: FACS 0fffff40 000040
[    0.000000] ACPI: SSDT 0ffff7a0 000796 (v01 BOCHS  BXPCSSDT 00000001 BXP=
C 00000001)
[    0.000000] ACPI: APIC 0ffff680 000080 (v01 BOCHS  BXPCAPIC 00000001 BXP=
C 00000001)
[    0.000000] ACPI: HPET 0ffff640 000038 (v01 BOCHS  BXPCHPET 00000001 BXP=
C 00000001)
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] mapped APIC to         ffffa000 (        fee00000)
[    0.000000] 0MB HIGHMEM available.
[    0.000000] 255MB LOWMEM available.
[    0.000000]   mapped low ram: 0 - 0fffe000
[    0.000000]   low ram: 0 - 0fffe000
[    0.000000] kvm-clock: Using msrs 4b564d01 and 4b564d00
[    0.000000] kvm-clock: cpu 0, msr 0:fffd001, boot clock
[    0.000000] Zone ranges:
[    0.000000]   DMA      [mem 0x00001000-0x00ffffff]
[    0.000000]   Normal   [mem 0x01000000-0x0fffdfff]
[    0.000000]   HighMem  empty
[    0.000000] Movable zone start for each node
[    0.000000] Early memory node ranges
[    0.000000]   node   0: [mem 0x00001000-0x0009efff]
[    0.000000]   node   0: [mem 0x00100000-0x0fffdfff]
[    0.000000] On node 0 totalpages: 65436
[    0.000000]   DMA zone: 32 pages used for memmap
[    0.000000]   DMA zone: 0 pages reserved
[    0.000000]   DMA zone: 3998 pages, LIFO batch:0
[    0.000000]   Normal zone: 480 pages used for memmap
[    0.000000]   Normal zone: 61438 pages, LIFO batch:15
[    0.000000] Using APIC driver default
[    0.000000] ACPI: PM-Timer IO Port: 0xb008
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] mapped APIC to         ffffa000 (        fee00000)
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
[    0.000000] mapped IOAPIC to ffff9000 (fec00000)
[    0.000000] nr_irqs_gsi: 40
[    0.000000] e820: [mem 0x10000000-0xfeffbfff] available for PCI devices
[    0.000000] Booting paravirtualized kernel on KVM
[    0.000000] setup_percpu: NR_CPUS:32 nr_cpumask_bits:32 nr_cpu_ids:2 nr_=
node_ids:1
[    0.000000] PERCPU: Embedded 10 pages/cpu @cf080000 s27128 r0 d13832 u40=
960
[    0.000000] pcpu-alloc: s27128 r0 d13832 u40960 alloc=3D10*4096
[    0.000000] pcpu-alloc: [0] 0 [0] 1=20
[    0.000000] kvm-clock: cpu 0, msr 0:fffd001, primary cpu clock
[    0.000000] KVM setup async PF for cpu 0
[    0.000000] kvm-stealtime: cpu 0, msr f082840
[    0.000000] Built 1 zonelists in Zone order, mobility grouping on.  Tota=
l pages: 64924
[    0.000000] Kernel command line: hung_task_panic=3D1 rcutree.rcu_cpu_sta=
ll_timeout=3D100 log_buf_len=3D8M ignore_loglevel debug sched_debug apic=3D=
debug dynamic_printk sysrq_always_enabled panic=3D10  prompt_ramdisk=3D0 co=
nsole=3DttyS0,115200 console=3Dtty0 vga=3Dnormal  root=3D/dev/ram0 rw link=
=3D/kernel-tests/run-queue/kvm/i386-randconfig-j3-11101308/next:master/.vml=
inuz-bad570d77024cba808126d68a2072f6f8ce64c27-20131110140304-6-xian branch=
=3Dnext/master BOOT_IMAGE=3D/kernel/i386-randconfig-j3-11101308/bad570d7702=
4cba808126d68a2072f6f8ce64c27/vmlinuz-3.12.0-next-20131108-10601-gbad570d
[    0.000000] sysrq: sysrq always enabled.
[    0.000000] PID hash table entries: 1024 (order: 0, 4096 bytes)
[    0.000000] Dentry cache hash table entries: 32768 (order: 5, 131072 byt=
es)
[    0.000000] Inode-cache hash table entries: 16384 (order: 4, 65536 bytes)
[    0.000000] Initializing CPU#0
[    0.000000] Initializing HighMem for node 0 (00000000:00000000)
[    0.000000] Memory: 229296K/261744K available (6302K kernel code, 652K r=
wdata, 3044K rodata, 384K init, 5848K bss, 32448K reserved, 0K highmem)
[    0.000000] virtual kernel memory layout:
[    0.000000]     fixmap  : 0xffa95000 - 0xfffff000   (5544 kB)
[    0.000000]     pkmap   : 0xff600000 - 0xff800000   (2048 kB)
[    0.000000]     vmalloc : 0xd07fe000 - 0xff5fe000   ( 750 MB)
[    0.000000]     lowmem  : 0xc0000000 - 0xcfffe000   ( 255 MB)
[    0.000000]       .init : 0xc19c6000 - 0xc1a26000   ( 384 kB)
[    0.000000]       .data : 0xc1627b5f - 0xc19c5240   (3701 kB)
[    0.000000]       .text : 0xc1000000 - 0xc1627b5f   (6302 kB)
[    0.000000] Checking if this processor honours the WP bit even in superv=
isor mode...Ok.
[    0.000000] Preemptible hierarchical RCU implementation.
[    0.000000]=20
[    0.000000] NR_IRQS:2304 nr_irqs:56 16
[    0.000000] CPU 0 irqstacks, hard=3Dcec02000 soft=3Dcec04000
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
[    0.000000]  memory used by lock dependency info: 3567 kB
[    0.000000]  per task-struct memory footprint: 1152 bytes
[    0.000000] ODEBUG: 13 of 13 active objects replaced
[    0.000000] hpet clockevent registered
[    0.000000] tsc: Detected 2893.052 MHz processor
[    0.002000] Calibrating delay loop (skipped) preset value.. 5786.10 Bogo=
MIPS (lpj=3D2893052)
[    0.002283] pid_max: default: 4096 minimum: 301
[    0.003041] Security Framework initialized
[    0.003456] Mount-cache hash table entries: 512
[    0.004306] Initializing cgroup subsys debug
[    0.004742] Initializing cgroup subsys freezer
[    0.005089] mce: CPU supports 10 MCE banks
[    0.005554] Last level iTLB entries: 4KB 0, 2MB 0, 4MB 0
[    0.005554] Last level dTLB entries: 4KB 0, 2MB 0, 4MB 0
[    0.005554] tlb_flushall_shift: 6
[    0.006666] Freeing SMP alternatives memory: 16K (c1a26000 - c1a2a000)
[    0.010716] ACPI: Core revision 20130927
[    0.014075] ACPI: All ACPI Tables successfully acquired
[    0.014728] Getting VERSION: 50014
[    0.015012] Getting VERSION: 50014
[    0.015348] Getting ID: 0
[    0.015614] Getting ID: f000000
[    0.016013] Getting LVT0: 8700
[    0.016318] Getting LVT1: 8400
[    0.016618] Enabling APIC mode:  Flat.  Using 1 I/O APICs
[    0.017079] enabled ExtINT on CPU#0
[    0.018645] ENABLING IO-APIC IRQs
[    0.019008] init IO_APIC IRQs
[    0.019302]  apic 0 pin 0 not connected
[    0.019683] IOAPIC[0]: Set routing entry (0-1 -> 0x31 -> IRQ 1 Mode:0 Ac=
tive:0 Dest:1)
[    0.020030] IOAPIC[0]: Set routing entry (0-2 -> 0x30 -> IRQ 0 Mode:0 Ac=
tive:0 Dest:1)
[    0.021022] IOAPIC[0]: Set routing entry (0-3 -> 0x33 -> IRQ 3 Mode:0 Ac=
tive:0 Dest:1)
[    0.022020] IOAPIC[0]: Set routing entry (0-4 -> 0x34 -> IRQ 4 Mode:0 Ac=
tive:0 Dest:1)
[    0.022796] IOAPIC[0]: Set routing entry (0-5 -> 0x35 -> IRQ 5 Mode:1 Ac=
tive:0 Dest:1)
[    0.023031] IOAPIC[0]: Set routing entry (0-6 -> 0x36 -> IRQ 6 Mode:0 Ac=
tive:0 Dest:1)
[    0.024020] IOAPIC[0]: Set routing entry (0-7 -> 0x37 -> IRQ 7 Mode:0 Ac=
tive:0 Dest:1)
[    0.025020] IOAPIC[0]: Set routing entry (0-8 -> 0x38 -> IRQ 8 Mode:0 Ac=
tive:0 Dest:1)
[    0.026020] IOAPIC[0]: Set routing entry (0-9 -> 0x39 -> IRQ 9 Mode:1 Ac=
tive:0 Dest:1)
[    0.027019] IOAPIC[0]: Set routing entry (0-10 -> 0x3a -> IRQ 10 Mode:1 =
Active:0 Dest:1)
[    0.027808] IOAPIC[0]: Set routing entry (0-11 -> 0x3b -> IRQ 11 Mode:1 =
Active:0 Dest:1)
[    0.028020] IOAPIC[0]: Set routing entry (0-12 -> 0x3c -> IRQ 12 Mode:0 =
Active:0 Dest:1)
[    0.029020] IOAPIC[0]: Set routing entry (0-13 -> 0x3d -> IRQ 13 Mode:0 =
Active:0 Dest:1)
[    0.030020] IOAPIC[0]: Set routing entry (0-14 -> 0x3e -> IRQ 14 Mode:0 =
Active:0 Dest:1)
[    0.031020] IOAPIC[0]: Set routing entry (0-15 -> 0x3f -> IRQ 15 Mode:0 =
Active:0 Dest:1)
[    0.031797]  apic 0 pin 16 not connected
[    0.032003]  apic 0 pin 17 not connected
[    0.032384]  apic 0 pin 18 not connected
[    0.033003]  apic 0 pin 19 not connected
[    0.033376]  apic 0 pin 20 not connected
[    0.033754]  apic 0 pin 21 not connected
[    0.034003]  apic 0 pin 22 not connected
[    0.034378]  apic 0 pin 23 not connected
[    0.035146] ..TIMER: vector=3D0x30 apic1=3D0 pin1=3D2 apic2=3D-1 pin2=3D=
-1
[    0.035810] smpboot: CPU0: Intel Common KVM processor (fam: 0f, model: 0=
6, stepping: 01)
[    0.036656] Using local APIC timer interrupts.
[    0.036656] calibrating APIC timer ...
[    0.038000] ... lapic delta =3D 6250489
[    0.038000] ... PM-Timer delta =3D 358005
[    0.038000] ... PM-Timer result ok
[    0.038000] ..... delta 6250489
[    0.038000] ..... mult: 268456458
[    0.038000] ..... calibration result: 1000078
[    0.038000] ..... CPU clock speed is 2893.0400 MHz.
[    0.038000] ..... host bus clock speed is 1000.0078 MHz.
[    0.038070] Performance Events: unsupported Netburst CPU model 6 no PMU =
driver, software events only.
[    0.047194] CPU 1 irqstacks, hard=3Dcec6a000 soft=3Dcec6c000
[    0.047794] x86: Booting SMP configuration:
[    0.048004] .... node  #0, CPUs:      #1
[    0.001000] Initializing CPU#1
[    0.002000] kvm-clock: cpu 1, msr 0:fffd041, secondary cpu clock
[    0.002000] masked ExtINT on CPU#1

[    0.062103] x86: Booted up 1 node, 2 CPUs
[    0.062066] KVM setup async PF for cpu 1
[    0.062066] kvm-stealtime: cpu 1, msr f08c840
[    0.063004] smpboot: Total of 2 processors activated (11572.20 BogoMIPS)
[    0.065702] EVM: security.capability
[    0.066761] NET: Registered protocol family 16
[    0.068250] cpuidle: using governor ladder
[    0.068651] cpuidle: using governor menu
[    0.069748] ACPI: bus type PCI registered
[    0.070023] dca service started, version 1.12.1
[    0.070572] PCI : PCI BIOS area is rw and x. Use pci=3Dnobios if you wan=
t it NX.
[    0.071004] PCI: PCI BIOS revision 2.10 entry at 0xfc6d5, last bus=3D0
[    0.081430] ACPI: Added _OSI(Module Device)
[    0.081838] ACPI: Added _OSI(Processor Device)
[    0.082005] ACPI: Added _OSI(3.0 _SCP Extensions)
[    0.082448] ACPI: Added _OSI(Processor Aggregator Device)
[    0.090151] ACPI: Interpreter enabled
[    0.090518] ACPI Exception: AE_NOT_FOUND, While evaluating Sleep State [=
\_S1_] (20130927/hwxface-580)
[    0.091223] ACPI Exception: AE_NOT_FOUND, While evaluating Sleep State [=
\_S2_] (20130927/hwxface-580)
[    0.092242] ACPI: (supports S0 S3 S5)
[    0.092594] ACPI: Using IOAPIC for interrupt routing
[    0.093029] PCI: Using host bridge windows from ACPI; if necessary, use =
"pci=3Dnocrs" and report a bug
[    0.104149] ACPI: PCI Root Bridge [PCI0] (domain 0000 [bus 00-ff])
[    0.104739] acpi PNP0A03:00: _OSC: OS supports [ASPM ClockPM Segments]
[    0.105042] acpi PNP0A03:00: _OSC failed (AE_NOT_FOUND); disabling ASPM
[    0.106490] PCI host bridge to bus 0000:00
[    0.106899] pci_bus 0000:00: root bus resource [bus 00-ff]
[    0.107005] pci_bus 0000:00: root bus resource [io  0x0000-0x0cf7]
[    0.108004] pci_bus 0000:00: root bus resource [io  0x0d00-0xffff]
[    0.108583] pci_bus 0000:00: root bus resource [mem 0x000a0000-0x000bfff=
f]
[    0.109004] pci_bus 0000:00: root bus resource [mem 0x80000000-0xfebffff=
f]
[    0.110058] pci 0000:00:00.0: [8086:1237] type 00 class 0x060000
[    0.111185] pci 0000:00:01.0: [8086:7000] type 00 class 0x060100
[    0.112374] pci 0000:00:01.1: [8086:7010] type 00 class 0x010180
[    0.116005] pci 0000:00:01.1: reg 0x20: [io  0xc1c0-0xc1cf]
[    0.118210] pci 0000:00:01.3: [8086:7113] type 00 class 0x068000
[    0.119134] pci 0000:00:01.3: quirk: [io  0xb000-0xb03f] claimed by PIIX=
4 ACPI
[    0.119818] pci 0000:00:01.3: quirk: [io  0xb100-0xb10f] claimed by PIIX=
4 SMB
[    0.120358] pci 0000:00:02.0: [1013:00b8] type 00 class 0x030000
[    0.122670] pci 0000:00:02.0: reg 0x10: [mem 0xfc000000-0xfdffffff pref]
[    0.124661] pci 0000:00:02.0: reg 0x14: [mem 0xfebf0000-0xfebf0fff]
[    0.132011] pci 0000:00:02.0: reg 0x30: [mem 0xfebe0000-0xfebeffff pref]
[    0.133248] pci 0000:00:03.0: [8086:100e] type 00 class 0x020000
[    0.135005] pci 0000:00:03.0: reg 0x10: [mem 0xfeba0000-0xfebbffff]
[    0.136589] pci 0000:00:03.0: reg 0x14: [io  0xc000-0xc03f]
[    0.143005] pci 0000:00:03.0: reg 0x30: [mem 0xfebc0000-0xfebdffff pref]
[    0.144128] pci 0000:00:04.0: [1af4:1001] type 00 class 0x010000
[    0.145598] pci 0000:00:04.0: reg 0x10: [io  0xc040-0xc07f]
[    0.147595] pci 0000:00:04.0: reg 0x14: [mem 0xfebf1000-0xfebf1fff]
[    0.154432] pci 0000:00:05.0: [1af4:1001] type 00 class 0x010000
[    0.156005] pci 0000:00:05.0: reg 0x10: [io  0xc080-0xc0bf]
[    0.158004] pci 0000:00:05.0: reg 0x14: [mem 0xfebf2000-0xfebf2fff]
[    0.165050] pci 0000:00:06.0: [1af4:1001] type 00 class 0x010000
[    0.166596] pci 0000:00:06.0: reg 0x10: [io  0xc0c0-0xc0ff]
[    0.168005] pci 0000:00:06.0: reg 0x14: [mem 0xfebf3000-0xfebf3fff]
[    0.175430] pci 0000:00:07.0: [1af4:1001] type 00 class 0x010000
[    0.177005] pci 0000:00:07.0: reg 0x10: [io  0xc100-0xc13f]
[    0.179005] pci 0000:00:07.0: reg 0x14: [mem 0xfebf4000-0xfebf4fff]
[    0.185423] pci 0000:00:08.0: [1af4:1001] type 00 class 0x010000
[    0.187594] pci 0000:00:08.0: reg 0x10: [io  0xc140-0xc17f]
[    0.189005] pci 0000:00:08.0: reg 0x14: [mem 0xfebf5000-0xfebf5fff]
[    0.196434] pci 0000:00:09.0: [1af4:1001] type 00 class 0x010000
[    0.198005] pci 0000:00:09.0: reg 0x10: [io  0xc180-0xc1bf]
[    0.200005] pci 0000:00:09.0: reg 0x14: [mem 0xfebf6000-0xfebf6fff]
[    0.206376] pci 0000:00:0a.0: [8086:25ab] type 00 class 0x088000
[    0.208005] pci 0000:00:0a.0: reg 0x10: [mem 0xfebf7000-0xfebf700f]
[    0.212738] pci_bus 0000:00: on NUMA node 0
[    0.214204] ACPI: PCI Interrupt Link [LNKA] (IRQs 5 *10 11)
[    0.215047] ACPI: PCI Interrupt Link [LNKB] (IRQs 5 *10 11)
[    0.215854] ACPI: PCI Interrupt Link [LNKC] (IRQs 5 10 *11)
[    0.216384] ACPI: PCI Interrupt Link [LNKD] (IRQs 5 10 *11)
[    0.217276] ACPI: PCI Interrupt Link [LNKS] (IRQs *9)
[    0.218711] ACPI: Enabled 16 GPEs in block 00 to 0F
[    0.219009] ACPI: \_SB_.PCI0: notify handler is installed
[    0.219588] Found 1 acpi root devices
[    0.220154] vgaarb: device added: PCI:0000:00:02.0,decodes=3Dio+mem,owns=
=3Dio+mem,locks=3Dnone
[    0.221007] vgaarb: loaded
[    0.221268] vgaarb: bridge control possible 0000:00:02.0
[    0.222296] ACPI: bus type USB registered
[    0.222714] usbcore: registered new interface driver usbfs
[    0.223048] usbcore: registered new interface driver hub
[    0.223583] usbcore: registered new device driver usb
[    0.224139] media: Linux media interface: v0.10
[    0.225028] Linux video capture interface: v2.00
[    0.225494] pps_core: LinuxPPS API ver. 1 registered
[    0.226003] pps_core: Software ver. 5.3.6 - Copyright 2005-2007 Rodolfo =
Giometti <giometti@linux.it>
[    0.226880] PTP clock support registered
[    0.227126] PCI: Using ACPI for IRQ routing
[    0.227480] PCI: pci_cache_line_size set to 64 bytes
[    0.228188] e820: reserve RAM buffer [mem 0x0009fc00-0x0009ffff]
[    0.229010] e820: reserve RAM buffer [mem 0x0fffe000-0x0fffffff]
[    0.230750] Switched to clocksource kvm-clock
[    0.231000] pnp: PnP ACPI init
[    0.231000] ACPI: bus type PNP registered
[    0.231412] IOAPIC[0]: Set routing entry (0-8 -> 0x38 -> IRQ 8 Mode:0 Ac=
tive:0 Dest:3)
[    0.232274] pnp 00:00: Plug and Play ACPI device, IDs PNP0b00 (active)
[    0.232919] IOAPIC[0]: Set routing entry (0-1 -> 0x31 -> IRQ 1 Mode:0 Ac=
tive:0 Dest:3)
[    0.233738] pnp 00:01: Plug and Play ACPI device, IDs PNP0303 (active)
[    0.234409] IOAPIC[0]: Set routing entry (0-12 -> 0x3c -> IRQ 12 Mode:0 =
Active:0 Dest:3)
[    0.235230] pnp 00:02: Plug and Play ACPI device, IDs PNP0f13 (active)
[    0.235932] IOAPIC[0]: Set routing entry (0-6 -> 0x36 -> IRQ 6 Mode:0 Ac=
tive:0 Dest:3)
[    0.236718] pnp 00:03: [dma 2]
[    0.237082] pnp 00:03: Plug and Play ACPI device, IDs PNP0700 (active)
[    0.237768] IOAPIC[0]: Set routing entry (0-7 -> 0x37 -> IRQ 7 Mode:0 Ac=
tive:0 Dest:3)
[    0.238576] pnp 00:04: Plug and Play ACPI device, IDs PNP0400 (active)
[    0.239278] IOAPIC[0]: Set routing entry (0-4 -> 0x34 -> IRQ 4 Mode:0 Ac=
tive:0 Dest:3)
[    0.240078] pnp 00:05: Plug and Play ACPI device, IDs PNP0501 (active)
[    0.241114] pnp 00:06: Plug and Play ACPI device, IDs PNP0103 (active)
[    0.241951] pnp: PnP ACPI: found 7 devices
[    0.242366] ACPI: bus type PNP unregistered
[    0.242768] INFO_MDMA: LNW DMA Driver Version 1.1.0
[    0.278263] pci_bus 0000:00: resource 4 [io  0x0000-0x0cf7]
[    0.278785] pci_bus 0000:00: resource 5 [io  0x0d00-0xffff]
[    0.279325] pci_bus 0000:00: resource 6 [mem 0x000a0000-0x000bffff]
[    0.279905] pci_bus 0000:00: resource 7 [mem 0x80000000-0xfebfffff]
[    0.280516] NET: Registered protocol family 1
[    0.280945] pci 0000:00:00.0: Limiting direct PCI/PCI transfers
[    0.281535] pci 0000:00:01.0: PIIX3: Enabling Passive Release
[    0.282106] pci 0000:00:01.0: Activating ISA DMA hang workarounds
[    0.282716] pci 0000:00:02.0: Boot video device
[    0.283238] PCI: CLS 0 bytes, default 64
[    0.283793] Unpacking initramfs...
[    0.367436] Freeing initrd memory: 3120K (cfce4000 - cfff0000)
[    0.894507] DMA-API: preallocated 65536 debug entries
[    0.894991] DMA-API: debugging enabled by kernel config
[    0.898136] apm: BIOS not found.
[    0.898580] microcode: CPU0 sig=3D0xf61, pf=3D0x1, revision=3D0x1
[    0.899182] microcode: CPU1 sig=3D0xf61, pf=3D0x1, revision=3D0x1
[    0.900380] microcode: Microcode Update Driver: v2.00 <tigran@aivazian.f=
snet.co.uk>, Peter Oruba
[    0.901631] cryptomgr_test (25) used greatest stack depth: 7252 bytes le=
ft
[    0.903555] cryptomgr_probe (32) used greatest stack depth: 6952 bytes l=
eft
[    0.904450] cryptomgr_test (31) used greatest stack depth: 6276 bytes le=
ft
[    0.906155] The force parameter has not been set to 1. The Iris poweroff=
 handler will not be installed.
[    0.907071] NatSemi SCx200 Driver
[    0.909485] Initializing RT-Tester: OK
[    0.913134] VFS: Disk quotas dquot_6.5.2
[    0.913551] Dquot-cache hash table entries: 1024 (order 0, 4096 bytes)
[    0.931675] alg: No test for crc32 (crc32-table)
[    0.932472] alg: No test for lz4 (lz4-generic)
[    0.933030] alg: No test for lz4hc (lz4hc-generic)
[    0.933619] alg: No test for stdrng (krng)
[    0.939320] cr_bllcd: INTEL CARILLO RANCH LPC not found.
[    0.939853] cr_bllcd: Carillo Ranch Backlight Driver Initialized.
[    0.942416] nvidiafb_setup START
[    0.943471] vmlfb: initializing
[    0.943797] Could not find Carillo Ranch MCH device.
[    0.944348] no IO addresses supplied
[    0.945961] hgafb: HGA card not detected.
[    0.946375] hgafb: probe of hgafb.0 failed with error -22
[    0.947273] cirrusfb 0000:00:02.0: Cirrus Logic chipset on PCI bus, RAM =
(4096 kB) at 0xfc000000
[    0.948907] usbcore: registered new interface driver udlfb
[    0.949464] usbcore: registered new interface driver smscufx
[    0.951590] ioatdma: Intel(R) QuickData Technology Driver 4.00
[    0.954749] ACPI: PCI Interrupt Link [LNKD] enabled at IRQ 11
[    0.955339] IOAPIC[0]: Set routing entry (0-11 -> 0x3b -> IRQ 11 Mode:1 =
Active:0 Dest:3)
[    0.959594] ACPI: PCI Interrupt Link [LNKA] enabled at IRQ 10
[    0.960155] IOAPIC[0]: Set routing entry (0-10 -> 0x3a -> IRQ 10 Mode:1 =
Active:0 Dest:3)
[    0.966360] ACPI: PCI Interrupt Link [LNKB] enabled at IRQ 10
[    0.973793] ACPI: PCI Interrupt Link [LNKC] enabled at IRQ 11
[    1.053326] r3964: Philips r3964 Driver $Revision: 1.10 $
[    1.053846] Serial: 8250/16550 driver, 4 ports, IRQ sharing disabled
[    1.076051] 00:05: ttyS0 at I/O 0x3f8 (irq =3D 4, base_baud =3D 115200) =
is a 16550A
[    1.079999] serial: Freescale lpuart driver
[    1.081169] lp: driver loaded but no devices found
[    1.081648] ppdev: user-space parallel port driver
[    1.082109] scx200_gpio: no SCx200 gpio present
[    1.082571] platform pc8736x_gpio.0: NatSemi pc8736x GPIO Driver Initial=
izing
[    1.083264] platform pc8736x_gpio.0: no device found
[    1.083820] nsc_gpio initializing
[    1.084171] smapi::smapi_init, ERROR invalid usSmapiID
[    1.084673] mwave: tp3780i::tp3780I_InitializeBoardData: Error: SMAPI is=
 not available on this machine
[    1.085549] mwave: mwavedd::mwave_init: Error: Failed to initialize boar=
d data
[    1.086242] mwave: mwavedd::mwave_init: Error: Failed to initialize
[    1.086840] Linux agpgart interface v0.103
[    1.088685] Hangcheck: starting hangcheck timer 0.9.1 (tick is 180 secon=
ds, margin is 60 seconds).
[    1.089540] Hangcheck: Using getrawmonotonic().
[    1.090758] dummy-irq: no IRQ given.  Use irq=3DN
[    1.091249] Phantom Linux Driver, version n0.9.8, init OK
[    1.093767] Guest personality initialized and is inactive
[    1.094350] VMCI host device registered (name=3Dvmci, major=3D10, minor=
=3D61)
[    1.094968] Initialized host personality
[    1.096846] usbcore: registered new interface driver viperboard
[    1.097437] I2O subsystem v1.325
[    1.097744] i2o: max drivers =3D 8
[    1.098865] I2O ProcFS OSM v1.316
[    1.100822] usbcore: registered new interface driver hwa-rc
[    1.102100] ehci_hcd: USB 2.0 'Enhanced' Host Controller (EHCI) Driver
[    1.102717] ehci-pci: EHCI PCI platform driver
[    1.103182] ehci-platform: EHCI generic platform driver
[    1.104336] uhci_hcd: USB Universal Host Controller Interface driver
[    1.105633] usbcore: registered new interface driver hwa-hc
[    1.106201] fotg210_hcd: FOTG210 Host Controller (EHCI) Driver
[    1.106740]=20
[    1.107779] usbcore: registered new interface driver wusb-cbaf
[    1.108924] usbcore: registered new interface driver cdc_acm
[    1.109480] cdc_acm: USB Abstract Control Model driver for USB modems an=
d ISDN adapters
[    1.110262] usbcore: registered new interface driver usblp
[    1.110792] usbcore: registered new interface driver usbtmc
[    1.111359] usbcore: registered new interface driver mdc800
[    1.111883] mdc800: v0.7.5 (30/10/2000):USB Driver for Mustek MDC800 Dig=
ital Camera
[    1.113370] usbcore: registered new interface driver appledisplay
[    1.113963] usbcore: registered new interface driver cypress_cy7c63
[    1.114595] usbcore: registered new interface driver emi26 - firmware lo=
ader
[    1.115281] usbcore: registered new interface driver emi62 - firmware lo=
ader
[    1.115953] usbcore: registered new interface driver idmouse
[    1.116524] usbcore: registered new interface driver iowarrior
[    1.117696] usbcore: registered new interface driver isight_firmware
[    1.118331] usbcore: registered new interface driver ldusb
[    1.118865] usbcore: registered new interface driver usbled
[    1.119422] usbcore: registered new interface driver rio500
[    1.119953] usbcore: registered new interface driver usbtest
[    1.120515] usbcore: registered new interface driver usb_ehset_test
[    1.121732] usbcore: registered new interface driver trancevibrator
[    1.122356] usbcore: registered new interface driver uss720
[    1.122884] uss720: v0.6:USB Parport Cable driver for Cables using the L=
ucent Technologies USS720 Chip
[    1.123762] uss720: NOTE: this is a special purpose driver to allow nons=
tandard
[    1.124468] uss720: protocols (eg. bitbang) over USS720 usb to parallel =
cables
[    1.125161] uss720: If you just want to connect to a printer, use usblp =
instead
[    1.125859] usbcore: registered new interface driver yurex
[    1.126435] usbcore: registered new interface driver sisusb
[    1.128381] i8042: PNP: PS/2 Controller [PNP0303:KBD,PNP0f13:MOU] at 0x6=
0,0x64 irq 1,12
[    1.129943] serio: i8042 KBD port at 0x60,0x64 irq 1
[    1.130540] serio: i8042 AUX port at 0x60,0x64 irq 12
[    1.132146] parkbd: no such parport
[    1.133183] mousedev: PS/2 mouse device common for all mice
[    1.135193] usbcore: registered new interface driver appletouch
[    1.135750] usbcore: registered new interface driver bcm5974
[    1.138369] usbcore: registered new interface driver iforce
[    1.138916] input: AT Translated Set 2 keyboard as /devices/platform/i80=
42/serio0/input/input0
[    1.141886] evbug: Connected device: input0 (AT Translated Set 2 keyboar=
d at isa0060/serio0/input0)
[    1.141909] usbcore: registered new interface driver usb_acecad
[    1.141921] usbcore: registered new interface driver aiptek
[    1.143529] mk712: device not present
[    1.143544] usbcore: registered new interface driver usbtouchscreen
[    1.144311] apanel: Fujitsu BIOS signature 'FJKEYINF' not found...
[    1.144325] cm109: Keymap for Komunikate KIP1000 phone loaded
[    1.144338] usbcore: registered new interface driver cm109
[    1.144339] cm109: CM109 phone driver: 20080805 (C) Alfred E. Heggestad
[    1.144389] usbcore: registered new interface driver keyspan_remote
[    1.145114] wistron_btns: System unknown
[    1.147195] usbcore: registered new interface driver i2c-diolan-u2c
[    1.147196] i2c-parport: adapter type unspecified
[    1.147197] i2c-parport-light: adapter type unspecified
[    1.147210] usbcore: registered new interface driver i2c-tiny-usb
[    1.150750] b2c2-flexcop: B2C2 FlexcopII/II(b)/III digital TV receiver c=
hip loaded successfully
[    1.151623] Marvell M88ALP01 'CAFE' Camera Controller version 2
[    1.152905] vivi-000: V4L2 device registered as video0
[    1.153412] Video Technology Magazine Virtual Video Capture Board ver 0.=
8.1 successfully loaded.
[    1.154304] saa7146: register extension 'budget_patch dvb'
[    1.154835] saa7146: register extension 'av7110'
[    1.155928] Digital Devices PCIE bridge driver, Copyright (C) 2010-11 Di=
gital Devices GmbH
[    1.156762] saa7146: register extension 'Multimedia eXtension Board'
[    1.157394] saa7146: register extension 'hexium gemini'
[    1.157901] Zoran MJPEG board driver version 0.10.1
[    1.158413] Linux video codec intermediate layer: v0.2
[    1.158916] saa7130/34: v4l2 driver version 0, 2, 17 loaded
[    1.160106] usbcore: registered new interface driver ttusb-dec
[    1.160679] usbcore: registered new interface driver ttusb
[    1.161227] usbcore: registered new interface driver smsusb
[    1.161760] usbcore: registered new interface driver b2c2_flexcop_usb
[    1.162396] usbcore: registered new interface driver stkwebcam
[    1.163574] usbcore: registered new interface driver s2255
[    1.164127] usbcore: registered new interface driver uvcvideo
[    1.164675] USB Video Class driver (1.1.1)
[    1.165084] cpia2: V4L-Driver for Vision CPiA2 based cameras v3.0.1
[    1.165688] usbcore: registered new interface driver cpia2
[    1.166240] usbcore: registered new interface driver sn9c102
[    1.166774] au0828 driver loaded
[    1.167108] usbcore: registered new interface driver au0828
[    1.167658] usbcore: registered new interface driver hdpvr
[    1.168807] usbcore: registered new interface driver stk1160
[    1.169376] usbcore: registered new interface driver em28xx
[    1.169914] Em28xx: Initialized (Em28xx dvb Extension) extension
[    1.170518] usbcore: registered new interface driver usbtv
[    1.171043] smssdio: Siano SMS1xxx SDIO driver
[    1.171466] smssdio: Copyright Pierre Ossman
[    1.171899] pps_ldisc: PPS line discipline registered
[    1.172389] pps_parport: parallel port PPS client
[    1.172872] intel_powerclamp: Intel powerclamp does not run on family 15=
 model 6
[    1.174255] usbcore: registered new interface driver pcwd_usb
[    1.174811] acquirewdt: WDT driver for Acquire single board computer ini=
tialising
[    1.175598] acquirewdt: I/O address 0x0043 already in use
[    1.176126] acquirewdt: probe of acquirewdt failed with error -5
[    1.176692] alim7101_wdt: Steve Hill <steve@navaho.co.uk>
[    1.177212] alim7101_wdt: ALi M7101 PMU not present - WDT not set
[    1.177855] sc520_wdt: WDT driver for SC520 initialised. timeout=3D30 se=
c (nowayout=3D0)
[    1.178603] ib700wdt: WDT driver for IB700 single board computer initial=
ising
[    1.179968] ib700wdt: failed to register misc device
[    1.180477] ib700wdt: probe of ib700wdt failed with error -16
[    1.181036] wafer5823wdt: WDT driver for Wafer 5823 single board compute=
r initialising
[    1.181776] wafer5823wdt: cannot register miscdev on minor=3D130 (err=3D=
-16)
[    1.182435] i6300esb: Intel 6300ESB WatchDog Timer Driver v0.05
[    1.183113] i6300esb: cannot register miscdev on minor=3D130 (err=3D-16)
[    1.183728] i6300ESB timer: probe of 0000:00:0a.0 failed with error -16
[    1.184447] pc87413_wdt: Version 1.1 at io 0x2E
[    1.184872] pc87413_wdt: cannot register miscdev on minor=3D130 (err=3D-=
16)
[    1.185509] sbc60xxwdt: cannot register miscdev on minor=3D130 (err=3D-1=
6)
[    1.186128] sbc7240_wdt: timeout set to 30 seconds
[    1.186580] sbc7240_wdt: cannot register miscdev on minor=3D130 (err=3D-=
16)
[    1.187218] cpu5wdt: misc_register failed
[    1.187657] w83627hf_wdt: WDT driver for the Winbond(TM) W83627HF/THF/HG=
/DHG Super I/O chip initialising
[    1.188574] w83627hf_wdt: Watchdog already running. Resetting timeout to=
 60 sec
[    1.189284] w83627hf_wdt: cannot register miscdev on minor=3D130 (err=3D=
-16)
[    1.189900] w83697hf_wdt: WDT driver for W83697HF/HG initializing
[    1.190498] w83697hf_wdt: watchdog not found at address 0x2e
[    1.191032] w83697hf_wdt: No W83697HF/HG could be found
[    1.191520] w83977f_wdt: driver v1.00
[    1.191866] w83977f_wdt: cannot register miscdev on minor=3D130 (err=3D-=
16)
[    1.192501] machzwd: MachZ ZF-Logic Watchdog driver initializing
[    1.193074] machzwd: no ZF-Logic found
[    1.193433] sbc_epx_c3: cannot register miscdev on minor=3D130 (err=3D-1=
6)
[    1.194856] wbsd: Winbond W83L51xD SD/MMC card interface driver
[    1.195429] wbsd: Copyright(c) Pierre Ossman
[    1.196533] VUB300 Driver rom wait states =3D 1C irqpoll timeout =3D 0400
[    1.197515] usbcore: registered new interface driver vub300
[    1.198108] usbcore: registered new interface driver ushc
[    1.200977] dcdbas dcdbas: Dell Systems Management Base Driver (version =
5.6.0-3.2)
[    1.202358] cs5535-clockevt: Could not allocate MFGPT timer
[    1.207859] usbcore: registered new interface driver usbhid
[    1.208406] usbhid: USB HID core driver
[    1.208780] hdaps: supported laptop not found!
[    1.209214] hdaps: driver init failed (ret=3D-19)!
[    1.213866] intel_rapl: driver does not support CPU family 15 model 6
[    1.215799]=20
[    1.215799] printing PIC contents
[    1.216278] ... PIC  IMR: ffff
[    1.216575] ... PIC  IRR: 1013
[    1.216871] ... PIC  ISR: 0000
[    1.217180] ... PIC ELCR: 0c00
[    1.217480] printing local APIC contents on CPU#0/0:
[    1.217946] ... APIC ID:      00000000 (0)
[    1.218168] ... APIC VERSION: 00050014
[    1.218168] ... APIC TASKPRI: 00000000 (00)
[    1.218168] ... APIC PROCPRI: 00000000
[    1.218168] ... APIC LDR: 01000000
[    1.218168] ... APIC DFR: ffffffff
[    1.218168] ... APIC SPIV: 000001ff
[    1.218168] ... APIC ISR field:
[    1.218168] 000000000000000000000000000000000000000000000000000000000000=
0000
[    1.218168] ... APIC TMR field:
[    1.218168] 000000000200000000000000000000000000000000000000000000000000=
0000
[    1.218168] ... APIC IRR field:
[    1.218168] 000000000000000000000000000000000000000000000000000000000000=
8000
[    1.218168] ... APIC ESR: 00000000
[    1.218168] ... APIC ICR: 000008fd
[    1.218168] ... APIC ICR2: 02000000
[    1.218168] ... APIC LVTT: 000000ef
[    1.218168] ... APIC LVTPC: 00010000
[    1.218168] ... APIC LVT0: 00010700
[    1.218168] ... APIC LVT1: 00000400
[    1.218168] ... APIC LVTERR: 000000fe
[    1.218168] ... APIC TMICT: 0000ca8b
[    1.218168] ... APIC TMCCT: 00000000
[    1.218168] ... APIC TDCR: 00000003
[    1.218168]=20
[    1.227602] number of MP IRQ sources: 15.
[    1.227983] number of IO-APIC #0 registers: 24.
[    1.228426] testing the IO APIC.......................
[    1.228924] IO APIC #0......
[    1.229218] .... register #00: 00000000
[    1.229578] .......    : physical APIC id: 00
[    1.229982] .......    : Delivery Type: 0
[    1.230387] .......    : LTS          : 0
[    1.230762] .... register #01: 00170011
[    1.231135] .......     : max redirection entries: 17
[    1.231608] .......     : PRQ implemented: 0
[    1.232023] .......     : IO APIC version: 11
[    1.232436] .... register #02: 00000000
[    1.232795] .......     : arbitration: 00
[    1.233182] .... IRQ redirection table:
[    1.233559] 1    0    0   0   0    0    0    00
[    1.233990] 0    0    0   0   0    1    1    31
[    1.234454] 0    0    0   0   0    1    1    30
[    1.234885] 0    0    0   0   0    1    1    33
[    1.235337] 1    0    0   0   0    1    1    34
[    1.235769] 1    1    0   0   0    1    1    35
[    1.236224] 0    0    0   0   0    1    1    36
[    1.236655] 0    0    0   0   0    1    1    37
[    1.237100] 0    0    0   0   0    1    1    38
[    1.237539] 0    1    0   0   0    1    1    39
[    1.237969] 1    1    0   0   0    1    1    3A
[    1.238428] 1    1    0   0   0    1    1    3B
[    1.238860] 0    0    0   0   0    1    1    3C
[    1.239317] 0    0    0   0   0    1    1    3D
[    1.239751] 0    0    0   0   0    1    1    3E
[    1.240211] 0    0    0   0   0    1    1    3F
[    1.240650] 1    0    0   0   0    0    0    00
[    1.241100] 1    0    0   0   0    0    0    00
[    1.241538] 1    0    0   0   0    0    0    00
[    1.241969] 1    0    0   0   0    0    0    00
[    1.242432] 1    0    0   0   0    0    0    00
[    1.242865] 1    0    0   0   0    0    0    00
[    1.243316] 1    0    0   0   0    0    0    00
[    1.243748] 1    0    0   0   0    0    0    00
[    1.244185] IRQ to pin mappings:
[    1.244504] IRQ0 -> 0:2
[    1.244765] IRQ1 -> 0:1
[    1.245038] IRQ3 -> 0:3
[    1.245306] IRQ4 -> 0:4
[    1.245566] IRQ5 -> 0:5
[    1.245827] IRQ6 -> 0:6
[    1.246102] IRQ7 -> 0:7
[    1.246370] IRQ8 -> 0:8
[    1.246630] IRQ9 -> 0:9
[    1.246889] IRQ10 -> 0:10
[    1.247179] IRQ11 -> 0:11
[    1.247460] IRQ12 -> 0:12
[    1.247735] IRQ13 -> 0:13
[    1.248025] IRQ14 -> 0:14
[    1.248309] IRQ15 -> 0:15
[    1.248582] .................................... done.
[    1.249070] Using IPI No-Shortcut mode
[    1.250856] Key type encrypted registered
[    1.254085] dmaengine: __dma_request_channel: fail ((null))
[    1.254840] BIOS EDD facility v0.16 2004-Jun-25, 0 devices found
[    1.255438] EDD information not available.
[    1.255873] Unregister pv shared memory for cpu 0
[    1.898155] tsc: Refined TSC clocksource calibration: 2892.980 MHz
[  240.910063] INFO: task swapper/0:1 blocked for more than 120 seconds.
[  240.910691]       Not tainted 3.12.0-next-20131108-10601-gbad570d #3
[  240.911284] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables =
this message.
[  240.912017] swapper/0       D 0000ad00  5808     1      0 0x00000000
[  240.912638]  cec29dbc 00000092 c1c3b640 0000ad00 20024160 cec29dc8 c1a25=
2c0 00000008
[  240.913462]  c1937d20 c1a252c0 cec17440 00000000 20024160 00000003 00000=
000 0000ad00
[  240.914364]  c1c6d500 00000000 cec17848 00000000 cec17440 c1077e17 cf082=
ab4 00000001
[  240.915212] Call Trace:
[  240.915447]  [<c1077e17>] ? mark_held_locks+0x87/0xf0
[  240.915915]  [<c1621a80>] schedule+0x10/0x20
[  240.916328]  [<c1620fd5>] schedule_timeout+0x125/0x180
[  240.916811]  [<c1625a02>] ? _raw_spin_unlock_irq+0x22/0x50
[  240.917325]  [<c16221f4>] ? wait_for_completion+0x94/0xd0
[  240.917825]  [<c107826b>] ? trace_hardirqs_on+0xb/0x10
[  240.918311]  [<c16221fb>] wait_for_completion+0x9b/0xd0
[  240.918807]  [<c1066aa0>] ? wake_up_state+0x10/0x10
[  240.919270]  [<c108af90>] ? __call_rcu.constprop.61+0x240/0x240
[  240.919823]  [<c108873f>] wait_rcu_gp+0x3f/0x60
[  240.920257]  [<c10885a0>] ? rcu_panic+0x20/0x20
[  240.920687]  [<c108cb9f>] synchronize_rcu+0x1f/0x40
[  240.921149]  [<c160b9a9>] _cpu_down+0x129/0x2c0
[  240.921578]  [<c160bbb2>] ? cpu_down+0x12/0x40
[  240.922006]  [<c12bd9ff>] ? lock_device_hotplug+0xf/0x20
[  240.922518]  [<c160bbc4>] cpu_down+0x24/0x40
[  240.922914]  [<c160b197>] _debug_hotplug_cpu+0x77/0xb0
[  240.923406]  [<c12c2c1e>] ? __platform_driver_register+0x3e/0x40
[  240.923965]  [<c19cae19>] ? pci_iommu_alloc+0x5a/0x5a
[  240.924448]  [<c19cae25>] debug_hotplug_cpu+0xc/0x10
[  240.924932]  [<c19c6b88>] do_one_initcall+0x8d/0x12c
[  240.925405]  [<c117129f>] ? strlen+0xf/0x20
[  240.925813]  [<c1059c93>] ? parameq+0x13/0x70
[  240.926230]  [<c19c6512>] ? repair_env_string+0x12/0x51
[  240.926722]  [<c1059ebf>] ? parse_args+0x1cf/0x320
[  240.927179]  [<c1052b6e>] ? __usermodehelper_set_disable_depth+0x3e/0x50
[  240.927802]  [<c19c6d12>] kernel_init_freeable+0xeb/0x17d
[  240.928310]  [<c19c6500>] ? do_early_param+0x78/0x78
[  240.928789]  [<c160b02b>] kernel_init+0xb/0x100
[  240.929222]  [<c1626cb7>] ret_from_kernel_thread+0x1b/0x28
[  240.929738]  [<c160b020>] ? rest_init+0xc0/0xc0
[  240.930168] 3 locks held by swapper/0/1:
[  240.930541]  #0:  (device_hotplug_lock){+.+.+.}, at: [<c12bd9ff>] lock_d=
evice_hotplug+0xf/0x20
[  240.931405]  #1:  (cpu_add_remove_lock){+.+.+.}, at: [<c160bbb2>] cpu_do=
wn+0x12/0x40
[  240.932198]  #2:  (cpu_hotplug.lock){+.+.+.}, at: [<c104242d>] cpu_hotpl=
ug_begin+0x1d/0x40
[  240.933039] sending NMI to all CPUs:
[  240.933381] NMI backtrace for cpu 1
[  240.933723] CPU: 1 PID: 46 Comm: khungtaskd Not tainted 3.12.0-next-2013=
1108-10601-gbad570d #3
[  240.934031] task: cd645560 ti: cd66a000 task.ti: cd66a000
[  240.934031] EIP: 0060:[<c102c8e5>] EFLAGS: 00010046 CPU: 1
[  240.934031] EIP is at default_send_IPI_mask_logical+0x85/0xf0
[  240.934031] EAX: 00000c00 EBX: 03000000 ECX: fffff000 EDX: fffff000
[  240.934031] ESI: 00000206 EDI: 00000002 EBP: cd66bed4 ESP: cd66bec4
[  240.934031]  DS: 007b ES: 007b FS: 00d8 GS: 00e0 SS: 0068
[  240.934031] CR0: 8005003b CR2: ffffffff CR3: 01a2d000 CR4: 000006f0
[  240.934031] Stack:
[  240.934031]  00000800 00002710 00007fff 000003ff cd66bee0 c102ca18 00002=
710 cd66bef0
[  240.934031]  c102cc0d c1861994 cec17440 cd66bf30 c10a4632 c1871278 c1a37=
f6c c1925686
[  240.934031]  00000002 c19256c7 00000078 00000002 cec17534 00007fff cec17=
440 cec17534
[  240.934031] Call Trace:
[  240.934031]  [<c102ca18>] default_send_IPI_all+0x58/0x60
[  240.934031]  [<c102cc0d>] arch_trigger_all_cpu_backtrace+0x3d/0x70
[  240.934031]  [<c10a4632>] watchdog+0x2e2/0x300
[  240.934031]  [<c10a4350>] ? hung_task_panic+0x20/0x20
[  240.934031]  [<c105b6d7>] kthread+0xa7/0xc0
[  240.934031]  [<c1060000>] ? set_create_files_as+0x10/0x20
[  240.934031]  [<c1626cb7>] ret_from_kernel_thread+0x1b/0x28
[  240.934031]  [<c105b630>] ? __kthread_parkme+0x60/0x60
[  240.934031] Code: 00 b3 ff ff f6 c4 10 75 ed c1 e3 18 89 99 10 b3 ff ff =
89 f8 09 d0 80 ce 04 83 ff 02 0f 44 c2 8b 15 04 06 93 c1 89 82 00 b3 ff ff =
<f7> c6 00 02 00 00 74 1b e8 6e b9 04 00 89 f0 50 9d 8d 74 26 00
[  240.934031] INFO: NMI handler (arch_trigger_all_cpu_backtrace_handler) t=
ook too long to run: 14.940 msecs
[  240.934028] NMI backtrace for cpu 0
[  240.934028] CPU: 0 PID: 0 Comm: swapper/0 Not tainted 3.12.0-next-201311=
08-10601-gbad570d #3
[  240.934028] task: c1925820 ti: c1922000 task.ti: c1922000
[  240.934028] EIP: 0060:[<c10311c5>] EFLAGS: 00200282 CPU: 0
[  240.934028] EIP is at native_safe_halt+0x5/0x10
[  240.934028] EAX: c1925820 EBX: c1922000 ECX: 00000000 EDX: 00000001
[  240.934028] ESI: c19c33e8 EDI: ffffffff EBP: c1923f80 ESP: c1923f80
[  240.934028]  DS: 007b ES: 007b FS: 00d8 GS: 00e0 SS: 0068
[  240.934028] CR0: 8005003b CR2: 00000000 CR3: 01a2d000 CR4: 000006f0
[  240.934028] Stack:
[  240.934028]  c1923f88 c100994d c1923f90 c100a0c6 c1923fac c108325a 0c2a8=
3ce 97c352c0
[  240.934028]  00000002 00020800 c1a2e800 c1923fc8 c160b010 00000002 00000=
001 00000000
[  240.934028]  c160af60 00000000 c1923fec c19c6af5 00000315 ffffffff fffff=
fff c19c6551
[  240.934028] Call Trace:
[  240.934028]  [<c100994d>] default_idle+0xd/0x10
[  240.934028]  [<c100a0c6>] arch_cpu_idle+0x26/0x30
[  240.934028]  [<c108325a>] cpu_startup_entry+0x13a/0x1c0
[  240.934028]  [<c160b010>] rest_init+0xb0/0xc0
[  240.934028]  [<c160af60>] ? csum_partial_copy_generic+0x104/0x104
[  240.934028]  [<c19c6af5>] start_kernel+0x3db/0x3e1
[  240.934028]  [<c19c6551>] ? repair_env_string+0x51/0x51
[  240.934028]  [<c19c6378>] i386_start_kernel+0x12e/0x131
[  240.934028] Code: bc 27 00 00 00 00 55 89 e5 fa 5d c3 8d 76 00 8d bc 27 =
00 00 00 00 55 89 e5 fb 5d c3 8d 76 00 8d bc 27 00 00 00 00 55 89 e5 fb f4 =
<5d> c3 89 f6 8d bc 27 00 00 00 00 55 89 e5 f4 5d c3 8d 76 00 8d
[  240.934028] INFO: NMI handler (arch_trigger_all_cpu_backtrace_handler) t=
ook too long to run: 14.991 msecs
[  240.962777] Kernel panic - not syncing: hung_task: blocked tasks
[  240.963332] CPU: 1 PID: 46 Comm: khungtaskd Not tainted 3.12.0-next-2013=
1108-10601-gbad570d #3
[  240.963751]  00000000 00000000 cd66bed0 c16137f2 cec17440 cd66bef0 c1611=
3dc c186c630
[  240.963751]  c1a37fa0 cd66bef0 cec17440 00007fff 000003ff cd66bf30 c10a4=
63e c186c250
[  240.963751]  c1a37f6c c1925686 00000002 c19256c7 00000078 00000002 cec17=
534 00007fff
[  240.963751] Call Trace:
[  240.963751]  [<c16137f2>] dump_stack+0x48/0x69
[  240.963751]  [<c16113dc>] panic+0x87/0x175
[  240.963751]  [<c10a463e>] watchdog+0x2ee/0x300
[  240.963751]  [<c10a4350>] ? hung_task_panic+0x20/0x20
[  240.963751]  [<c105b6d7>] kthread+0xa7/0xc0
[  240.963751]  [<c1060000>] ? set_create_files_as+0x10/0x20
[  240.963751]  [<c1626cb7>] ret_from_kernel_thread+0x1b/0x28
[  240.963751]  [<c105b630>] ? __kthread_parkme+0x60/0x60
[  240.963751] Kernel Offset: 0x0 from 0xc1000000 (relocation range: 0xc000=
0000-0xd07fdfff)

Elapsed time: 245
qemu-system-x86_64 -cpu kvm64 -enable-kvm -kernel /kernel/i386-randconfig-j=
3-11101308/bad570d77024cba808126d68a2072f6f8ce64c27/vmlinuz-3.12.0-next-201=
31108-10601-gbad570d -append 'hung_task_panic=3D1 rcutree.rcu_cpu_stall_tim=
eout=3D100 log_buf_len=3D8M ignore_loglevel debug sched_debug apic=3Ddebug =
dynamic_printk sysrq_always_enabled panic=3D10  prompt_ramdisk=3D0 console=
=3DttyS0,115200 console=3Dtty0 vga=3Dnormal  root=3D/dev/ram0 rw link=3D/ke=
rnel-tests/run-queue/kvm/i386-randconfig-j3-11101308/next:master/.vmlinuz-b=
ad570d77024cba808126d68a2072f6f8ce64c27-20131110140304-6-xian branch=3Dnext=
/master BOOT_IMAGE=3D/kernel/i386-randconfig-j3-11101308/bad570d77024cba808=
126d68a2072f6f8ce64c27/vmlinuz-3.12.0-next-20131108-10601-gbad570d'  -initr=
d /kernel-tests/initrd/yocto-minimal-i386.cgz -m 256M -smp 2 -net nic,vlan=
=3D1,model=3De1000 -net user,vlan=3D1 -boot order=3Dnc -no-reboot -watchdog=
 i6300esb -drive file=3D/fs/LABEL=3DKVM/disk0-yocto-xian-35,media=3Ddisk,if=
=3Dvirtio -drive file=3D/fs/LABEL=3DKVM/disk1-yocto-xian-35,media=3Ddisk,if=
=3Dvirtio -drive file=3D/fs/LABEL=3DKVM/disk2-yocto-xian-35,media=3Ddisk,if=
=3Dvirtio -drive file=3D/fs/LABEL=3DKVM/disk3-yocto-xian-35,media=3Ddisk,if=
=3Dvirtio -drive file=3D/fs/LABEL=3DKVM/disk4-yocto-xian-35,media=3Ddisk,if=
=3Dvirtio -drive file=3D/fs/LABEL=3DKVM/disk5-yocto-xian-35,media=3Ddisk,if=
=3Dvirtio -pidfile /dev/shm/kboot/pid-yocto-xian-35 -serial file:/dev/shm/k=
boot/serial-yocto-xian-35 -daemonize -display none -monitor null=20

--M9NhX3UHpAaciwkO
Content-Type: application/octet-stream
Content-Disposition: attachment; filename="bisect-bad570d77024cba808126d68a2072f6f8ce64c27-i386-randconfig-j3-11101308-INFO:-task-swapper-42000.log"
Content-Transfer-Encoding: base64

Z2l0IGNoZWNrb3V0IGUxZTk1ODAyOTc4MWE1ZjIyYTQ3ODA3Zjk2NDhhYjlkMjIxNzQ2ZjQK
UHJldmlvdXMgSEVBRCBwb3NpdGlvbiB3YXMgYmFkNTcwZC4uLiBBZGQgbGludXgtbmV4dCBz
cGVjaWZpYyBmaWxlcyBmb3IgMjAxMzExMDgKSEVBRCBpcyBub3cgYXQgZTFlOTU4MC4uLiBN
ZXJnZSByZW1vdGUtdHJhY2tpbmcgYnJhbmNoICdhaW8vbWFzdGVyJwpscyAtYSAva2VybmVs
LXRlc3RzL3J1bi1xdWV1ZS9rdm0vaTM4Ni1yYW5kY29uZmlnLWozLTExMTAxMzA4L25leHQ6
bWFzdGVyOmUxZTk1ODAyOTc4MWE1ZjIyYTQ3ODA3Zjk2NDhhYjlkMjIxNzQ2ZjQ6YmlzZWN0
LXVzYgoKMjAxMy0xMS0xMC0xODozMjo1MyBlMWU5NTgwMjk3ODFhNWYyMmE0NzgwN2Y5NjQ4
YWI5ZDIyMTc0NmY0IGNvbXBpbGluZwoyNjIgcmVhbCAgOTg5IHVzZXIgIDEwMCBzeXMgIDQx
Ni4wNSUgY3B1IAlpMzg2LXJhbmRjb25maWctajMtMTExMDEzMDgKCjIwMTMtMTEtMTAtMTg6
Mzc6NTQgZGV0ZWN0aW5nIGJvb3Qgc3RhdGUgMy4xMi4wLTEwMTczLWdlMWU5NTgwLi4JMwk2
Li4uLi4gVEVTVCBGQUlMVVJFClsgICAgNS4wNDAxNDRdIEJJT1MgRUREIGZhY2lsaXR5IHYw
LjE2IDIwMDQtSnVuLTI1LCAwIGRldmljZXMgZm91bmQKWyAgICA1LjA0MTUyNF0gRUREIGlu
Zm9ybWF0aW9uIG5vdCBhdmFpbGFibGUuClsgICAgNS4wNDI1MjRdIFVucmVnaXN0ZXIgcHYg
c2hhcmVkIG1lbW9yeSBmb3IgY3B1IDAKWyAgMjQzLjkzNDA0NV0gSU5GTzogdGFzayBzd2Fw
cGVyLzA6MSBibG9ja2VkIGZvciBtb3JlIHRoYW4gMTIwIHNlY29uZHMuClsgIDI0My45MzUz
OTddICAgICAgIE5vdCB0YWludGVkIDMuMTIuMC0xMDE3My1nZTFlOTU4MCAjNzY0ClsgIDI0
My45MzY0OTZdICJlY2hvIDAgPiAvcHJvYy9zeXMva2VybmVsL2h1bmdfdGFza190aW1lb3V0
X3NlY3MiIGRpc2FibGVzIHRoaXMgbWVzc2FnZS4KWyAgMjQzLjkzODA3NV0gc3dhcHBlci8w
ICAgICAgIEQgY2Q0MTc4MzggIDU3NDQgICAgIDEgICAgICAwIDB4MDAwMDAwMDAKWyAgMjQz
LjkzOTQ2MV0gIGNkNDI5ZGMwIDAwMDAwMDgyIGMxYzQ1NDg4IGNkNDE3ODM4IDAwMDBhYjgw
IGNkNDI5ZGNjIGMxYTFlMzQwIDAwMDAwMDA4ClsgIDI0My45NDEyODZdICBjMTkzMWQyMCBj
MWExZTM0MCBjZDQxNzQ0MCAwMDAwMDAwMCBjMWM0NTQ4OCAwMDAwMDAwNCAwMDAwMDAwMCAw
MDAwYWI4MApbICAyNDMuOTQzMDg2XSAgYzFjNjYwYzAgMDAwMDAwMDAgMjAwMjQxNWMgMDAw
MDAwMDAgY2Q0MTc0NDAgYzEwNzdkOTcgY2RhZGRiMzQgMDAwMDAwMDEKWyAgMjQzLjk0NDg5
NF0gQ2FsbCBUcmFjZToKWyAgMjQzLjk0NTQ0NV0gIFs8YzEwNzdkOTc+XSA/IG1hcmtfaGVs
ZF9sb2NrcysweDg3LzB4ZjAKWyAgMjQzLjk0NjQ5N10gIFs8YzE2MWVmNTA+XSBzY2hlZHVs
ZSsweDEwLzB4MjAKWyAgMjQzLjk0NzM5N10gIFs8YzE2MWU0YTU+XSBzY2hlZHVsZV90aW1l
b3V0KzB4MTI1LzB4MTgwClsgIDI0My45NDg0NjBdICBbPGMxNjIyZWQyPl0gPyBfcmF3X3Nw
aW5fdW5sb2NrX2lycSsweDIyLzB4NTAKWyAgMjQzLjk0OTU4N10gIFs8YzE2MWY2YzQ+XSA/
IHdhaXRfZm9yX2NvbXBsZXRpb24rMHg5NC8weGQwClsgIDI0My45NTA2OTldICBbPGMxMDc4
MWViPl0gPyB0cmFjZV9oYXJkaXJxc19vbisweGIvMHgxMApbICAyNDMuOTUxNzYwXSAgWzxj
MTYxZjZjYj5dIHdhaXRfZm9yX2NvbXBsZXRpb24rMHg5Yi8weGQwClsgIDI0My45NTI4MzZd
ICBbPGMxMDY2OWMwPl0gPyB3YWtlX3VwX3N0YXRlKzB4MTAvMHgxMApbICAyNDMuOTUzODU5
XSAgWzxjMTA4YWVlMD5dID8gX19jYWxsX3JjdS5jb25zdHByb3AuNjErMHgyNDAvMHgyNDAK
WyAgMjQzLjk1NTA3M10gIFs8YzEwODg2OGY+XSB3YWl0X3JjdV9ncCsweDNmLzB4NjAKWyAg
MjQzLjk1NTk5MV0gIFs8YzEwODg0ZjA+XSA/IHJjdV9wYW5pYysweDIwLzB4MjAKWyAgMjQz
Ljk1NjkzOV0gIFs8YzEwOGNhZWY+XSBzeW5jaHJvbml6ZV9yY3UrMHgxZi8weDQwClsgIDI0
My45NTgwMzJdICBbPGMxNjA4ZTA5Pl0gX2NwdV9kb3duKzB4MTI5LzB4MmMwClsgIDI0My45
NTkwNDRdICBbPGMxNjA5MDEyPl0gPyBjcHVfZG93bisweDEyLzB4NDAKWyAgMjQzLjk2MDAz
NF0gIFs8YzEyYjk5YmY+XSA/IGxvY2tfZGV2aWNlX2hvdHBsdWcrMHhmLzB4MjAKWyAgMjQz
Ljk2MTIzNF0gIFs8YzE2MDkwMjQ+XSBjcHVfZG93bisweDI0LzB4NDAKWyAgMjQzLjk2MjE0
Nl0gIFs8YzE2MDg1Zjc+XSBfZGVidWdfaG90cGx1Z19jcHUrMHg3Ny8weGIwClsgIDI0My45
NjMyNDldICBbPGMxMmJlYmRlPl0gPyBfX3BsYXRmb3JtX2RyaXZlcl9yZWdpc3RlcisweDNl
LzB4NDAKWyAgMjQzLjk2NDQ4MV0gIFs8YzE5YzNlMWI+XSA/IHBjaV9pb21tdV9hbGxvYysw
eDVhLzB4NWEKWyAgMjQzLjk2NTUzOF0gIFs8YzE5YzNlMjc+XSBkZWJ1Z19ob3RwbHVnX2Nw
dSsweGMvMHgxMApbICAyNDMuOTY2NTkwXSAgWzxjMTliZmI4OD5dIGRvX29uZV9pbml0Y2Fs
bCsweDhkLzB4MTJjClsgIDI0My45Njc2MzNdICBbPGMxMTZmMmFkPl0gPyBzdHJsZW4rMHhk
LzB4MjAKWyAgMjQzLjk2ODUwN10gIFs8YzEwNTljYTM+XSA/IHBhcmFtZXErMHgxMy8weDcw
ClsgIDI0My45Njk0MTddICBbPGMxOWJmNTEyPl0gPyByZXBhaXJfZW52X3N0cmluZysweDEy
LzB4NTEKWyAgMjQzLjk3MDQ5MV0gIFs8YzEwNTllY2Y+XSA/IHBhcnNlX2FyZ3MrMHgxY2Yv
MHgzMjAKWyAgMjQzLjk3MTQ3OF0gIFs8YzEwNTJiOGU+XSA/IF9fdXNlcm1vZGVoZWxwZXJf
c2V0X2Rpc2FibGVfZGVwdGgrMHgzZS8weDUwClsgIDI0My45NzI4MjldICBbPGMxOWJmZDEy
Pl0ga2VybmVsX2luaXRfZnJlZWFibGUrMHhlYi8weDE3ZApbICAyNDMuOTczOTMzXSAgWzxj
MTliZjUwMD5dID8gZG9fZWFybHlfcGFyYW0rMHg3OC8weDc4ClsgIDI0My45NzQ5NjFdICBb
PGMxNjA4NDRiPl0ga2VybmVsX2luaXQrMHhiLzB4MTQwClsgIDI0My45NzU5MTBdICBbPGMx
NjI0MTc3Pl0gcmV0X2Zyb21fa2VybmVsX3RocmVhZCsweDFiLzB4MjgKWyAgMjQzLjk3NzAz
OF0gIFs8YzE2MDg0NDA+XSA/IHJlc3RfaW5pdCsweGMwLzB4YzAKWyAgMjQzLjk3Nzk1N10g
MyBsb2NrcyBoZWxkIGJ5IHN3YXBwZXIvMC8xOgpbICAyNDMuOTc4NzgyXSAgIzA6ICAoZGV2
aWNlX2hvdHBsdWdfbG9jayl7Ky4rLisufSwgYXQ6IFs8YzEyYjk5YmY+XSBsb2NrX2Rldmlj
ZV9ob3RwbHVnKzB4Zi8weDIwClsgIDI0My45ODA2ODhdICAjMTogIChjcHVfYWRkX3JlbW92
ZV9sb2NrKXsrLisuKy59LCBhdDogWzxjMTYwOTAxMj5dIGNwdV9kb3duKzB4MTIvMHg0MApb
ICAyNDMuOTgyNDE4XSAgIzI6ICAoY3B1X2hvdHBsdWcubG9jayl7Ky4rLisufSwgYXQ6IFs8
YzEwNDIzNGQ+XSBjcHVfaG90cGx1Z19iZWdpbisweDFkLzB4NDAKWyAgMjQzLjk4NDI1NF0g
c2VuZGluZyBOTUkgdG8gYWxsIENQVXM6ClsgIDI0My45ODQ5ODFdIE5NSSBiYWNrdHJhY2Ug
Zm9yIGNwdSAxClsgIDI0My45ODUyNDJdIENQVTogMSBQSUQ6IDQ2IENvbW06IGtodW5ndGFz
a2QgTm90IHRhaW50ZWQgMy4xMi4wLTEwMTczLWdlMWU5NTgwICM3NjQKWyAgMjQzLjk4NTI0
Ml0gdGFzazogY2ZhZTkwMDAgdGk6IGNmYWYyMDAwIHRhc2sudGk6IGNmYWYyMDAwClsgIDI0
My45ODUyNDJdIEVJUDogMDA2MDpbPGMxMDJjOTA1Pl0gRUZMQUdTOiAwMDAwMDA0NiBDUFU6
IDEKWyAgMjQzLjk4NTI0Ml0gRUlQIGlzIGF0IGRlZmF1bHRfc2VuZF9JUElfbWFza19sb2dp
Y2FsKzB4ODUvMHhmMApbICAyNDMuOTg1MjQyXSBFQVg6IDAwMDAwYzAwIEVCWDogMDMwMDAw
MDAgRUNYOiBmZmZmZjAwMCBFRFg6IGZmZmZmMDAwClsgIDI0My45ODUyNDJdIEVTSTogMDAw
MDAyMDYgRURJOiAwMDAwMDAwMiBFQlA6IGNmYWYzZWQ0IEVTUDogY2ZhZjNlYzQKWyAgMjQz
Ljk4NTI0Ml0gIERTOiAwMDdiIEVTOiAwMDdiIEZTOiAwMGQ4IEdTOiAwMGUwIFNTOiAwMDY4
ClsgIDI0My45ODUyNDJdIENSMDogODAwNTAwM2IgQ1IyOiAwMDAwMDAwMCBDUjM6IDAxYTI2
MDAwIENSNDogMDAwMDA2ZjAKWyAgMjQzLjk4NTI0Ml0gU3RhY2s6ClsgIDI0My45ODUyNDJd
ICAwMDAwMDgwMCAwMDAwMjcxMCAwMDAwN2ZmZiAwMDAwMDNmZiBjZmFmM2VlMCBjMTAyY2Ez
OCAwMDAwMjcxMCBjZmFmM2VmMApbICAyNDMuOTg1MjQyXSAgYzEwMmNjMmQgYzE4NWU0Nzgg
Y2Q0MTc0NDAgY2ZhZjNmMzAgYzEwYTQ2NDIgYzE4NmQ1NWMgYzFhMzBmNmMgYzE5MWY2ODYK
WyAgMjQzLjk4NTI0Ml0gIDAwMDAwMDA0IGMxOTFmNmM3IDAwMDAwMDc4IDAwMDAwMDA0IGNk
NDE3NTM4IDAwMDA3ZmZmIGNkNDE3NDQwIGNkNDE3NTM4ClsgIDI0My45ODUyNDJdIENhbGwg
VHJhY2U6ClsgIDI0My45ODUyNDJdICBbPGMxMDJjYTM4Pl0gZGVmYXVsdF9zZW5kX0lQSV9h
bGwrMHg1OC8weDYwClsgIDI0My45ODUyNDJdICBbPGMxMDJjYzJkPl0gYXJjaF90cmlnZ2Vy
X2FsbF9jcHVfYmFja3RyYWNlKzB4M2QvMHg3MApbICAyNDMuOTg1MjQyXSAgWzxjMTBhNDY0
Mj5dIHdhdGNoZG9nKzB4MmUyLzB4MzAwClsgIDI0My45ODUyNDJdICBbPGMxMGE0MzYwPl0g
PyBodW5nX3Rhc2tfcGFuaWMrMHgyMC8weDIwClsgIDI0My45ODUyNDJdICBbPGMxMDViNmRh
Pl0ga3RocmVhZCsweDlhLzB4YTAKWyAgMjQzLjk4NTI0Ml0gIFs8YzEwNjAwMDA+XSA/IGNy
ZWRfYWxsb2NfYmxhbmsrMHgyMC8weDYwClsgIDI0My45ODUyNDJdICBbPGMxNjI0MTc3Pl0g
cmV0X2Zyb21fa2VybmVsX3RocmVhZCsweDFiLzB4MjgKWyAgMjQzLjk4NTI0Ml0gIFs8YzEw
NWI2NDA+XSA/IF9fa3RocmVhZF9wYXJrbWUrMHg2MC8weDYwClsgIDI0My45ODUyNDJdIENv
ZGU6IDAwIGIzIGZmIGZmIGY2IGM0IDEwIDc1IGVkIGMxIGUzIDE4IDg5IDk5IDEwIGIzIGZm
IGZmIDg5IGY4IDA5IGQwIDgwIGNlIDA0IDgzIGZmIDAyIDBmIDQ0IGMyIDhiIDE1IDA0IGE2
IDkyIGMxIDg5IDgyIDAwIGIzIGZmIGZmIDxmNz4gYzYgMDAgMDIgMDAgMDAgNzQgMWIgZTgg
Y2UgYjggMDQgMDAgODkgZjAgNTAgOWQgOGQgNzQgMjYgMDAKWyAgMjQzLjk4NTAzMl0gTk1J
IGJhY2t0cmFjZSBmb3IgY3B1IDAKL2tlcm5lbC9pMzg2LXJhbmRjb25maWctajMtMTExMDEz
MDgvZTFlOTU4MDI5NzgxYTVmMjJhNDc4MDdmOTY0OGFiOWQyMjE3NDZmNC9kbWVzZy15b2N0
by1pbm4tMTY6MjAxMzExMTAxODQyMDI6aTM4Ni1yYW5kY29uZmlnLWozLTExMTAxMzA4OjMu
MTIuMC0xMDE3My1nZTFlOTU4MDo3NjQKL2tlcm5lbC9pMzg2LXJhbmRjb25maWctajMtMTEx
MDEzMDgvZTFlOTU4MDI5NzgxYTVmMjJhNDc4MDdmOTY0OGFiOWQyMjE3NDZmNC9kbWVzZy15
b2N0by1pbm4tMzE6MjAxMzExMTAxODQyMDQ6aTM4Ni1yYW5kY29uZmlnLWozLTExMTAxMzA4
OjMuMTIuMC0xMDE3My1nZTFlOTU4MDo3NjQKL2tlcm5lbC9pMzg2LXJhbmRjb25maWctajMt
MTExMDEzMDgvZTFlOTU4MDI5NzgxYTVmMjJhNDc4MDdmOTY0OGFiOWQyMjE3NDZmNC9kbWVz
Zy15b2N0by1pbm4tMzc6MjAxMzExMTAxODQyMDQ6aTM4Ni1yYW5kY29uZmlnLWozLTExMTAx
MzA4OjMuMTIuMC0xMDE3My1nZTFlOTU4MDo3NjQKL2tlcm5lbC9pMzg2LXJhbmRjb25maWct
ajMtMTExMDEzMDgvZTFlOTU4MDI5NzgxYTVmMjJhNDc4MDdmOTY0OGFiOWQyMjE3NDZmNC9k
bWVzZy15b2N0by1pbm4tMjQ6MjAxMzExMTAxODQyMTA6aTM4Ni1yYW5kY29uZmlnLWozLTEx
MTAxMzA4OjMuMTIuMC0xMDE3My1nZTFlOTU4MDo3NjQKL2tlcm5lbC9pMzg2LXJhbmRjb25m
aWctajMtMTExMDEzMDgvZTFlOTU4MDI5NzgxYTVmMjJhNDc4MDdmOTY0OGFiOWQyMjE3NDZm
NC9kbWVzZy15b2N0by1pbm4tNDU6MjAxMzExMTAxODQyMDg6aTM4Ni1yYW5kY29uZmlnLWoz
LTExMTAxMzA4OjMuMTIuMC0xMDE3My1nZTFlOTU4MDo3NjQKL2tlcm5lbC9pMzg2LXJhbmRj
b25maWctajMtMTExMDEzMDgvZTFlOTU4MDI5NzgxYTVmMjJhNDc4MDdmOTY0OGFiOWQyMjE3
NDZmNC9kbWVzZy15b2N0by1zbmItNDU6MjAxMzExMTAxODQyMTQ6aTM4Ni1yYW5kY29uZmln
LWozLTExMTAxMzA4OjMuMTIuMC0xMDE3My1nZTFlOTU4MDo3NjQKL2tlcm5lbC9pMzg2LXJh
bmRjb25maWctajMtMTExMDEzMDgvZTFlOTU4MDI5NzgxYTVmMjJhNDc4MDdmOTY0OGFiOWQy
MjE3NDZmNC9kbWVzZy1xdWFudGFsLWxrcC10dDAyLTE4OjIwMTMxMTEwMDkzMzQ0OmkzODYt
cmFuZGNvbmZpZy1qMy0xMTEwMTMwODozLjEyLjAtMTAxNzMtZ2UxZTk1ODA6NzY0Ci9rZXJu
ZWwvaTM4Ni1yYW5kY29uZmlnLWozLTExMTAxMzA4L2UxZTk1ODAyOTc4MWE1ZjIyYTQ3ODA3
Zjk2NDhhYjlkMjIxNzQ2ZjQvZG1lc2ctcXVhbnRhbC1zbmItMToyMDEzMTExMDE4NDIxNTpp
Mzg2LXJhbmRjb25maWctajMtMTExMDEzMDg6My4xMi4wLTEwMTczLWdlMWU5NTgwOjc2NAov
a2VybmVsL2kzODYtcmFuZGNvbmZpZy1qMy0xMTEwMTMwOC9lMWU5NTgwMjk3ODFhNWYyMmE0
NzgwN2Y5NjQ4YWI5ZDIyMTc0NmY0L2RtZXNnLXF1YW50YWwtc25iLTQ0OjIwMTMxMTEwMTg0
MjI0OmkzODYtcmFuZGNvbmZpZy1qMy0xMTEwMTMwODozLjEyLjAtMTAxNzMtZ2UxZTk1ODA6
NzY0Ci9rZXJuZWwvaTM4Ni1yYW5kY29uZmlnLWozLTExMTAxMzA4L2UxZTk1ODAyOTc4MWE1
ZjIyYTQ3ODA3Zjk2NDhhYjlkMjIxNzQ2ZjQvZG1lc2cteW9jdG8tbGtwLXR0MDItMTg6MjAx
MzExMTAwOTMzMzk6aTM4Ni1yYW5kY29uZmlnLWozLTExMTAxMzA4OjMuMTIuMC0xMDE3My1n
ZTFlOTU4MDo3NjQKL2tlcm5lbC9pMzg2LXJhbmRjb25maWctajMtMTExMDEzMDgvZTFlOTU4
MDI5NzgxYTVmMjJhNDc4MDdmOTY0OGFiOWQyMjE3NDZmNC9kbWVzZy15b2N0by1zbmItMzc6
MjAxMzExMTAxODQyMjI6aTM4Ni1yYW5kY29uZmlnLWozLTExMTAxMzA4OjMuMTIuMC0xMDE3
My1nZTFlOTU4MDo3NjQKNjoxMToxMSBhbGxfZ29vZDpiYWQ6YWxsX2JhZCBib290cwobWzE7
MzVtUkVQRUFUIENPVU5UOiAyNSAgIyAvY2Mvd2ZnL3VzYi1iaXNlY3QvLnJlcGVhdBtbMG0K
CmJpc2VjdDogYmFkIGNvbW1pdCBlMWU5NTgwMjk3ODFhNWYyMmE0NzgwN2Y5NjQ4YWI5ZDIy
MTc0NmY0CmdpdCBjaGVja291dCB2My4xMgpQcmV2aW91cyBIRUFEIHBvc2l0aW9uIHdhcyBl
MWU5NTgwLi4uIE1lcmdlIHJlbW90ZS10cmFja2luZyBicmFuY2ggJ2Fpby9tYXN0ZXInCkhF
QUQgaXMgbm93IGF0IDVlMDFkYzcuLi4gTGludXggMy4xMgpscyAtYSAva2VybmVsLXRlc3Rz
L3J1bi1xdWV1ZS9rdm0vaTM4Ni1yYW5kY29uZmlnLWozLTExMTAxMzA4L25leHQ6bWFzdGVy
OjVlMDFkYzdiMjZkOWYyNGYzOWFiYWNlNWRhOThjY2JkNmE1Y2ViNTI6YmlzZWN0LXVzYgog
U1VDQ0VTUwoKYmlzZWN0OiBnb29kIGNvbW1pdCB2My4xMgpnaXQgYmlzZWN0IHN0YXJ0IGUx
ZTk1ODAyOTc4MWE1ZjIyYTQ3ODA3Zjk2NDhhYjlkMjIxNzQ2ZjQgdjMuMTIgLS0KUHJldmlv
dXMgSEVBRCBwb3NpdGlvbiB3YXMgNWUwMWRjNy4uLiBMaW51eCAzLjEyCkhFQUQgaXMgbm93
IGF0IDZlNDY2NDUuLi4gTGludXggMy4xMQpCaXNlY3Rpbmc6IDUwMjAgcmV2aXNpb25zIGxl
ZnQgdG8gdGVzdCBhZnRlciB0aGlzIChyb3VnaGx5IDEyIHN0ZXBzKQpbNTEzZTcyYjNhZTBl
N2QzNWIwOWI3MmMzNjBlNTQ4NzgxYjM0NWZlN10gTWVyZ2UgcmVtb3RlLXRyYWNraW5nIGJy
YW5jaCAncG0vbGludXgtbmV4dCcKZ2l0IGJpc2VjdCBydW4gL2Mva2VybmVsLXRlc3RzL2Jp
c2VjdC10ZXN0LWJvb3QtZmFpbHVyZS5zaCAvaG9tZS93ZmcvdXNiL29iai1iaXNlY3QKcnVu
bmluZyAvYy9rZXJuZWwtdGVzdHMvYmlzZWN0LXRlc3QtYm9vdC1mYWlsdXJlLnNoIC9ob21l
L3dmZy91c2Ivb2JqLWJpc2VjdApscyAtYSAva2VybmVsLXRlc3RzL3J1bi1xdWV1ZS9rdm0v
aTM4Ni1yYW5kY29uZmlnLWozLTExMTAxMzA4L25leHQ6bWFzdGVyOjUxM2U3MmIzYWUwZTdk
MzViMDliNzJjMzYwZTU0ODc4MWIzNDVmZTc6YmlzZWN0LXVzYgoKMjAxMy0xMS0xMC0xODo0
MzowMiA1MTNlNzJiM2FlMGU3ZDM1YjA5YjcyYzM2MGU1NDg3ODFiMzQ1ZmU3IGNvbXBpbGlu
Zwo2MjAgcmVhbCAgOTk0IHVzZXIgIDk2IHN5cyAgMTc1Ljg3JSBjcHUgCWkzODYtcmFuZGNv
bmZpZy1qMy0xMTEwMTMwOAoKMjAxMy0xMS0xMC0xODo1NTozNCBkZXRlY3RpbmcgYm9vdCBz
dGF0ZSAzLjEyLjAtMDUxNTItZzUxM2U3MmIuLgk3CTI1IFNVQ0NFU1MKCkJpc2VjdGluZzog
MjUyNyByZXZpc2lvbnMgbGVmdCB0byB0ZXN0IGFmdGVyIHRoaXMgKHJvdWdobHkgMTEgc3Rl
cHMpClthNzNmMzlkNmJiMTNjZDBlYWRmNTY2ZTIwMmRiZmQxMTRkZTJiOWJjXSBNZXJnZSBy
ZW1vdGUtdHJhY2tpbmcgYnJhbmNoICd2aXJ0aW8vdmlydGlvLW5leHQnCnJ1bm5pbmcgL2Mv
a2VybmVsLXRlc3RzL2Jpc2VjdC10ZXN0LWJvb3QtZmFpbHVyZS5zaCAvaG9tZS93ZmcvdXNi
L29iai1iaXNlY3QKbHMgLWEgL2tlcm5lbC10ZXN0cy9ydW4tcXVldWUva3ZtL2kzODYtcmFu
ZGNvbmZpZy1qMy0xMTEwMTMwOC9uZXh0Om1hc3RlcjphNzNmMzlkNmJiMTNjZDBlYWRmNTY2
ZTIwMmRiZmQxMTRkZTJiOWJjOmJpc2VjdC11c2IKCjIwMTMtMTEtMTAtMTg6NTc6MzkgYTcz
ZjM5ZDZiYjEzY2QwZWFkZjU2NmUyMDJkYmZkMTE0ZGUyYjliYyBjb21waWxpbmcKMjk5IHJl
YWwgIDEwMDMgdXNlciAgOTkgc3lzICAzNjcuODMlIGNwdSAJaTM4Ni1yYW5kY29uZmlnLWoz
LTExMTAxMzA4CgoyMDEzLTExLTEwLTE5OjA3OjQ0IGRldGVjdGluZyBib290IHN0YXRlIDMu
MTIuMC0wNzY0NS1nYTczZjM5ZC4uCTI0CTI1IFNVQ0NFU1MKCkJpc2VjdGluZzogMTI3OSBy
ZXZpc2lvbnMgbGVmdCB0byB0ZXN0IGFmdGVyIHRoaXMgKHJvdWdobHkgMTAgc3RlcHMpCls4
ZDMxZTg1MzY1NDA2MzVhMWQ1NmM5Y2Q0YTMwZWVmZTdmMjM2NjQ0XSBNZXJnZSByZW1vdGUt
dHJhY2tpbmcgYnJhbmNoICdzcGkvZm9yLW5leHQnCnJ1bm5pbmcgL2Mva2VybmVsLXRlc3Rz
L2Jpc2VjdC10ZXN0LWJvb3QtZmFpbHVyZS5zaCAvaG9tZS93ZmcvdXNiL29iai1iaXNlY3QK
bHMgLWEgL2tlcm5lbC10ZXN0cy9ydW4tcXVldWUva3ZtL2kzODYtcmFuZGNvbmZpZy1qMy0x
MTEwMTMwOC9uZXh0Om1hc3Rlcjo4ZDMxZTg1MzY1NDA2MzVhMWQ1NmM5Y2Q0YTMwZWVmZTdm
MjM2NjQ0OmJpc2VjdC11c2IKCjIwMTMtMTEtMTAtMTk6MDk6NDkgOGQzMWU4NTM2NTQwNjM1
YTFkNTZjOWNkNGEzMGVlZmU3ZjIzNjY0NCBjb21waWxpbmcKNTI5IHJlYWwgIDEwMDAgdXNl
ciAgMTAwIHN5cyAgMjA3LjkzJSBjcHUgCWkzODYtcmFuZGNvbmZpZy1qMy0xMTEwMTMwOAoK
MjAxMy0xMS0xMC0xOToyMDo1MyBkZXRlY3RpbmcgYm9vdCBzdGF0ZSAzLjEyLjAtMDg4OTMt
ZzhkMzFlODUuLgk2CTE3CTI1IFNVQ0NFU1MKCkJpc2VjdGluZzogNjQ1IHJldmlzaW9ucyBs
ZWZ0IHRvIHRlc3QgYWZ0ZXIgdGhpcyAocm91Z2hseSA5IHN0ZXBzKQpbNDdiOGQ5YzhjMzhh
OTU2MDk0ZTdmNmIyMzEzNzEzMzFkZDJkZDBkOV0gTWVyZ2UgYnJhbmNoICd4ODYvaHlwZXJ2
JwpydW5uaW5nIC9jL2tlcm5lbC10ZXN0cy9iaXNlY3QtdGVzdC1ib290LWZhaWx1cmUuc2gg
L2hvbWUvd2ZnL3VzYi9vYmotYmlzZWN0CmxzIC1hIC9rZXJuZWwtdGVzdHMvcnVuLXF1ZXVl
L2t2bS9pMzg2LXJhbmRjb25maWctajMtMTExMDEzMDgvbmV4dDptYXN0ZXI6NDdiOGQ5Yzhj
MzhhOTU2MDk0ZTdmNmIyMzEzNzEzMzFkZDJkZDBkOTpiaXNlY3QtdXNiCgoyMDEzLTExLTEw
LTE5OjIzOjMxIDQ3YjhkOWM4YzM4YTk1NjA5NGU3ZjZiMjMxMzcxMzMxZGQyZGQwZDkgY29t
cGlsaW5nCjgxMyByZWFsICAxMDAzIHVzZXIgIDEwMCBzeXMgIDEzNS43MCUgY3B1IAlpMzg2
LXJhbmRjb25maWctajMtMTExMDEzMDgKCjIwMTMtMTEtMTAtMTk6Mzg6MDUgZGV0ZWN0aW5n
IGJvb3Qgc3RhdGUgMy4xMi4wLTAwNjM0LWc0N2I4ZDljLi4JMwk3CTguLi4uIFRFU1QgRkFJ
TFVSRQpbICAgIDIuNzg2MzI5XSBFREQgaW5mb3JtYXRpb24gbm90IGF2YWlsYWJsZS4KWyAg
ICAyLjc4Njk5NV0gVW5yZWdpc3RlciBwdiBzaGFyZWQgbWVtb3J5IGZvciBjcHUgMApbICAg
IDMuMjM5MTcwXSB0c2M6IFJlZmluZWQgVFNDIGNsb2Nrc291cmNlIGNhbGlicmF0aW9uOiAy
ODkyLjk2MSBNSHoKWyAgMjQyLjI1OTA3NF0gSU5GTzogdGFzayBzd2FwcGVyLzA6MSBibG9j
a2VkIGZvciBtb3JlIHRoYW4gMTIwIHNlY29uZHMuClsgIDI0Mi4yNjAwODBdICAgICAgIE5v
dCB0YWludGVkIDMuMTIuMC0wMDYzNC1nNDdiOGQ5YyAjNzY4ClsgIDI0Mi4yNjA4NzNdICJl
Y2hvIDAgPiAvcHJvYy9zeXMva2VybmVsL2h1bmdfdGFza190aW1lb3V0X3NlY3MiIGRpc2Fi
bGVzIHRoaXMgbWVzc2FnZS4KWyAgMjQyLjI2MjA0N10gc3dhcHBlci8wICAgICAgIEQgY2Q0
MTc4MzggIDU3NDAgICAgIDEgICAgICAwIDB4MDAwMDAwMDAKWyAgMjQyLjI2MzA1N10gIGNk
NDI5ZGMwIDAwMDAwMDgyIGMwZTI5YWYwIGNkNDE3ODM4IDAwMDBhNDgwIGNkNDI5ZGNjIGMw
YzA3MzQwIDAwMDAwMDA4ClsgIDI0Mi4yNjQzOTddICBjMGIxZGRlMCBjMGMwNzM0MCBjZDQx
NzQ0MCAwMDAwMDAwMCBjMGUyOWFmMCAwMDAwMDAwNCAwMDAwMDAwMCAwMDAwYTQ4MApbICAy
NDIuMjY1NzMzXSAgYzBlNGUyZjAgMDAwMDAwMDAgMjQwMjYxNGYgMDAwMDAwMDAgY2Q0MTc0
NDAgYzAyNzdmMjcgY2RhZGRiMzQgMDAwMDAwMDEKWyAgMjQyLjI2NzA4NV0gQ2FsbCBUcmFj
ZToKWyAgMjQyLjI2NzQ5NV0gIFs8YzAyNzdmMjc+XSA/IG1hcmtfaGVsZF9sb2NrcysweDg3
LzB4ZjAKWyAgMjQyLjI2ODI5N10gIFs8YzA4MTIwNDA+XSBzY2hlZHVsZSsweDEwLzB4MjAK
WyAgMjQyLjI2ODkzMF0gIFs8YzA4MTE1OTU+XSBzY2hlZHVsZV90aW1lb3V0KzB4MTI1LzB4
MTgwClsgIDI0Mi4yNjk3MjJdICBbPGMwODE1ZmMyPl0gPyBfcmF3X3NwaW5fdW5sb2NrX2ly
cSsweDIyLzB4NTAKWyAgMjQyLjI3MDU2NF0gIFs8YzA4MTI3YjQ+XSA/IHdhaXRfZm9yX2Nv
bXBsZXRpb24rMHg5NC8weGQwClsgIDI0Mi4yNzEzOTBdICBbPGMwMjc4MzdiPl0gPyB0cmFj
ZV9oYXJkaXJxc19vbisweGIvMHgxMApbICAyNDIuMjcyMTY5XSAgWzxjMDgxMjdiYj5dIHdh
aXRfZm9yX2NvbXBsZXRpb24rMHg5Yi8weGQwClsgIDI0Mi4yNzI5NTBdICBbPGMwMjY2YjUw
Pl0gPyB3YWtlX3VwX3N0YXRlKzB4MTAvMHgxMApbICAyNDIuMjczNzA4XSAgWzxjMDI4YjBl
MD5dID8gX19jYWxsX3JjdS5jb25zdHByb3AuNjErMHgyNDAvMHgyNDAKWyAgMjQyLjI3NDYx
N10gIFs8YzAyODg4OGY+XSB3YWl0X3JjdV9ncCsweDNmLzB4NjAKWyAgMjQyLjI3NTMxOF0g
IFs8YzAyODg2ZjA+XSA/IHJjdV9wYW5pYysweDIwLzB4MjAKWyAgMjQyLjI3NTk4N10gIFs8
YzAyOGNjZWY+XSBzeW5jaHJvbml6ZV9yY3UrMHgxZi8weDQwClsgIDI0Mi4yNzY3NTFdICBb
PGMwN2ZiZTk5Pl0gX2NwdV9kb3duKzB4MTI5LzB4MmMwClsgIDI0Mi4yNzc0ODRdICBbPGMw
N2ZjMGEyPl0gPyBjcHVfZG93bisweDEyLzB4NDAKWyAgMjQyLjI3ODE2NV0gIFs8YzAyMjg5
MmY+XSA/IGNwdV9ob3RwbHVnX2RyaXZlcl9sb2NrKzB4Zi8weDIwClsgIDI0Mi4yNzkwNDJd
ICBbPGMwN2ZjMGI0Pl0gY3B1X2Rvd24rMHgyNC8weDQwClsgIDI0Mi4yNzk2ODJdICBbPGMw
N2ZiNWRmPl0gX2RlYnVnX2hvdHBsdWdfY3B1KzB4NmYvMHhhMApbICAyNDIuMjgwNDgxXSAg
WzxjMDRiYjA4ZT5dID8gX19wbGF0Zm9ybV9kcml2ZXJfcmVnaXN0ZXIrMHgzZS8weDQwClsg
IDI0Mi4yODEzOTZdICBbPGMwYmFkZDc5Pl0gPyBwY2lfaW9tbXVfYWxsb2MrMHg1YS8weDVh
ClsgIDI0Mi4yODIxODldICBbPGMwYmFkZDg1Pl0gZGVidWdfaG90cGx1Z19jcHUrMHhjLzB4
MTAKWyAgMjQyLjI4MjkzMl0gIFs8YzBiYTliNmM+XSBkb19vbmVfaW5pdGNhbGwrMHg4ZC8w
eDEyYwpbICAyNDIuMjgzNzAzXSAgWzxjMDM2ZTdlZj5dID8gc3RybGVuKzB4Zi8weDIwClsg
IDI0Mi4yODQzNTddICBbPGMwMjU5ZTMzPl0gPyBwYXJhbWVxKzB4MTMvMHg3MApbICAyNDIu
Mjg1MDAxXSAgWzxjMGJhOTUxMj5dID8gcmVwYWlyX2Vudl9zdHJpbmcrMHgxMi8weDUxClsg
IDI0Mi4yODU3OThdICBbPGMwMjVhMDVmPl0gPyBwYXJzZV9hcmdzKzB4MWNmLzB4MzIwClsg
IDI0Mi4yODY1NDNdICBbPGMwMjUyZDllPl0gPyBfX3VzZXJtb2RlaGVscGVyX3NldF9kaXNh
YmxlX2RlcHRoKzB4M2UvMHg1MApbICAyNDIuMjg3NTk1XSAgWzxjMGJhOWNmNj5dIGtlcm5l
bF9pbml0X2ZyZWVhYmxlKzB4ZWIvMHgxN2QKWyAgMjQyLjI4ODQyN10gIFs8YzBiYTk1MDA+
XSA/IGRvX2Vhcmx5X3BhcmFtKzB4NzgvMHg3OApbICAyNDIuMjg5MTc5XSAgWzxjMDdmYjQz
Yj5dIGtlcm5lbF9pbml0KzB4Yi8weDE0MApbICAyNDIuMjg5ODYzXSAgWzxjMDgxNzI3Nz5d
IHJldF9mcm9tX2tlcm5lbF90aHJlYWQrMHgxYi8weDI4ClsgIDI0Mi4yOTA3MDldICBbPGMw
N2ZiNDMwPl0gPyByZXN0X2luaXQrMHhjMC8weGMwClsgIDI0Mi4yOTE0MDhdIDMgbG9ja3Mg
aGVsZCBieSBzd2FwcGVyLzAvMToKWyAgMjQyLjI5MTk5NV0gICMwOiAgKHg4Nl9jcHVfaG90
cGx1Z19kcml2ZXJfbXV0ZXgpeysuKy4rLn0sIGF0OiBbPGMwMjI4OTJmPl0gY3B1X2hvdHBs
dWdfZHJpdmVyX2xvY2srMHhmLzB4MjAKWyAgMjQyLjI5MzU5M10gICMxOiAgKGNwdV9hZGRf
cmVtb3ZlX2xvY2speysuKy4rLn0sIGF0OiBbPGMwN2ZjMGEyPl0gY3B1X2Rvd24rMHgxMi8w
eDQwClsgIDI0Mi4yOTQ4NjddICAjMjogIChjcHVfaG90cGx1Zy5sb2NrKXsrLisuKy59LCBh
dDogWzxjMDI0MjU1ZD5dIGNwdV9ob3RwbHVnX2JlZ2luKzB4MWQvMHg0MApbICAyNDIuMjk2
MjI0XSBzZW5kaW5nIE5NSSB0byBhbGwgQ1BVczoKWyAgMjQyLjI5Njc3OV0gTk1JIGJhY2t0
cmFjZSBmb3IgY3B1IDEKWyAgMjQyLjI5NzIxMF0gQ1BVOiAxIFBJRDogNDYgQ29tbToga2h1
bmd0YXNrZCBOb3QgdGFpbnRlZCAzLjEyLjAtMDA2MzQtZzQ3YjhkOWMgIzc2OApbICAyNDIu
Mjk3MjEwXSB0YXNrOiBjZmFjYzAwMCB0aTogY2ZhYzAwMDAgdGFzay50aTogY2ZhYzAwMDAK
WyAgMjQyLjI5NzIxMF0gRUlQOiAwMDYwOls8YzAyMmM5NTU+XSBFRkxBR1M6IDAwMDEwMDQ2
IENQVTogMQpbICAyNDIuMjk3MjEwXSBFSVAgaXMgYXQgZGVmYXVsdF9zZW5kX0lQSV9tYXNr
X2xvZ2ljYWwrMHg4NS8weGYwClsgIDI0Mi4yOTcyMTBdIEVBWDogMDAwMDBjMDAgRUJYOiAw
MzAwMDAwMCBFQ1g6IGZmZmZmMDAwIEVEWDogZmZmZmYwMDAKWyAgMjQyLjI5NzIxMF0gRVNJ
OiAwMDAwMDIwNiBFREk6IDAwMDAwMDAyIEVCUDogY2ZhYzFlZDQgRVNQOiBjZmFjMWVjNApb
ICAyNDIuMjk3MjEwXSAgRFM6IDAwN2IgRVM6IDAwN2IgRlM6IDAwZDggR1M6IDAwZTAgU1M6
IDAwNjgKWyAgMjQyLjI5NzIxMF0gQ1IwOiA4MDA1MDAzYiBDUjI6IGZmZmZmZmZmIENSMzog
MDBjMGYwMDAgQ1I0OiAwMDAwMDZmMApbICAyNDIuMjk3MjEwXSBTdGFjazoKWyAgMjQyLjI5
NzIxMF0gIDAwMDAwODAwIDAwMDAyNzEwIDAwMDA3ZmZmIDAwMDAwM2ZmIGNmYWMxZWUwIGMw
MjJjYTg4IDAwMDAyNzEwIGNmYWMxZWYwClsgIDI0Mi4yOTcyMTBdICBjMDIyY2M3ZCBjMGE0
Yjc4YSBjZDQxNzQ0MCBjZmFjMWYzMCBjMDJhNGE4ZSBjMGE1YTg0NCBjMGMxOWY2YyBjMGIw
YjY0NgpbICAyNDIuMjk3MjEwXSAgMDAwMDAwMDQgYzBiMGI2ODcgMDAwMDAwNzggMDAwMDAw
MDQgY2Q0MTc1MzggMDAwMDdmZmYgY2Q0MTc0NDAgY2Q0MTc1MzgKWyAgMjQyLjI5NzIxMF0g
Q2FsbCBUcmFjZToKWyAgMjQyLjI5NzIxMF0gIFs8YzAyMmNhODg+XSBkZWZhdWx0X3NlbmRf
SVBJX2FsbCsweDU4LzB4NjAKWyAgMjQyLjI5NzIxMF0gIFs8YzAyMmNjN2Q+XSBhcmNoX3Ry
aWdnZXJfYWxsX2NwdV9iYWNrdHJhY2UrMHgzZC8weDcwClsgIDI0Mi4yOTcyMTBdICBbPGMw
MmE0YThlPl0gd2F0Y2hkb2crMHgyZGUvMHgzMDAKWyAgMjQyLjI5NzIxMF0gIFs8YzAyYTQ3
YjA+XSA/IGh1bmdfdGFza19wYW5pYysweDIwLzB4MjAKWyAgMjQyLjI5NzIxMF0gIFs8YzAy
NWI4NmE+XSBrdGhyZWFkKzB4OWEvMHhhMApbICAyNDIuMjk3MjEwXSAgWzxjMDI2MDAwMD5d
ID8gZ2V0X3Rhc2tfY3JlZCsweDUwLzB4YTAKWyAgMjQyLjI5NzIxMF0gIFs8YzA4MTcyNzc+
XSByZXRfZnJvbV9rZXJuZWxfdGhyZWFkKzB4MWIvMHgyOApbICAyNDIuMjk3MjEwXSAgWzxj
MDI1YjdkMD5dID8gX19rdGhyZWFkX3BhcmttZSsweDYwLzB4NjAKWyAgMjQyLjI5NzIxMF0g
Q29kZTogMDAgYjMgZmYgZmYgZjYgYzQgMTAgNzUgZWQgYzEgZTMgMTggODkgOTkgMTAgYjMg
ZmYgZmYgODkgZjggMDkgZDAgODAgY2UgMDQgODMgZmYgMDIgMGYgNDQgYzIgOGIgMTUgYzQg
NjUgYjEgYzAgODkgODIgMDAgYjMgZmYgZmYgPGY3PiBjNiAwMCAwMiAwMCAwMCA3NCAxYiBl
OCAwZSBiYSAwNCAwMCA4OSBmMCA1MCA5ZCA4ZCA3NCAyNiAwMApbICAyNDIuMjk3MDI2XSBO
TUkgYmFja3RyYWNlIGZvciBjcHUgMAova2VybmVsL2kzODYtcmFuZGNvbmZpZy1qMy0xMTEw
MTMwOC80N2I4ZDljOGMzOGE5NTYwOTRlN2Y2YjIzMTM3MTMzMWRkMmRkMGQ5L2RtZXNnLXF1
YW50YWwtd2FpbWVhLTEwOjIwMTMxMTExMDMzODI2OmkzODYtcmFuZGNvbmZpZy1qMy0xMTEw
MTMwODozLjEyLjAtMDA2MzQtZzQ3YjhkOWM6NzY4Ci9rZXJuZWwvaTM4Ni1yYW5kY29uZmln
LWozLTExMTAxMzA4LzQ3YjhkOWM4YzM4YTk1NjA5NGU3ZjZiMjMxMzcxMzMxZGQyZGQwZDkv
ZG1lc2cteW9jdG8taW5uLTE2OjIwMTMxMTEwMTk0MjE1OmkzODYtcmFuZGNvbmZpZy1qMy0x
MTEwMTMwODozLjEyLjAtMDA2MzQtZzQ3YjhkOWM6NzY4Ci9rZXJuZWwvaTM4Ni1yYW5kY29u
ZmlnLWozLTExMTAxMzA4LzQ3YjhkOWM4YzM4YTk1NjA5NGU3ZjZiMjMxMzcxMzMxZGQyZGQw
ZDkvZG1lc2cteW9jdG8taW5uLTE4OjIwMTMxMTEwMTk0MjE0OmkzODYtcmFuZGNvbmZpZy1q
My0xMTEwMTMwODozLjEyLjAtMDA2MzQtZzQ3YjhkOWM6NzY4Ci9rZXJuZWwvaTM4Ni1yYW5k
Y29uZmlnLWozLTExMTAxMzA4LzQ3YjhkOWM4YzM4YTk1NjA5NGU3ZjZiMjMxMzcxMzMxZGQy
ZGQwZDkvZG1lc2cteW9jdG8taW5uLTQ6MjAxMzExMTAxOTQyMTQ6aTM4Ni1yYW5kY29uZmln
LWozLTExMTAxMzA4OjMuMTIuMC0wMDYzNC1nNDdiOGQ5Yzo3NjgKL2tlcm5lbC9pMzg2LXJh
bmRjb25maWctajMtMTExMDEzMDgvNDdiOGQ5YzhjMzhhOTU2MDk0ZTdmNmIyMzEzNzEzMzFk
ZDJkZDBkOS9kbWVzZy15b2N0by1yb2FtLTIzOjIwMTMxMTEwMTk0MjEzOmkzODYtcmFuZGNv
bmZpZy1qMy0xMTEwMTMwODozLjEyLjAtMDA2MzQtZzQ3YjhkOWM6NzY4Ci9rZXJuZWwvaTM4
Ni1yYW5kY29uZmlnLWozLTExMTAxMzA4LzQ3YjhkOWM4YzM4YTk1NjA5NGU3ZjZiMjMxMzcx
MzMxZGQyZGQwZDkvZG1lc2cteW9jdG8tcm9hbS0xMjoyMDEzMTExMDE5NDIyMTppMzg2LXJh
bmRjb25maWctajMtMTExMDEzMDg6My4xMi4wLTAwNjM0LWc0N2I4ZDljOjc2OAova2VybmVs
L2kzODYtcmFuZGNvbmZpZy1qMy0xMTEwMTMwOC80N2I4ZDljOGMzOGE5NTYwOTRlN2Y2YjIz
MTM3MTMzMWRkMmRkMGQ5L2RtZXNnLXF1YW50YWwtcm9hbS0xOToyMDEzMTExMDE5NDIyMzpp
Mzg2LXJhbmRjb25maWctajMtMTExMDEzMDg6My4xMi4wLTAwNjM0LWc0N2I4ZDljOjc2OAov
a2VybmVsL2kzODYtcmFuZGNvbmZpZy1qMy0xMTEwMTMwOC80N2I4ZDljOGMzOGE5NTYwOTRl
N2Y2YjIzMTM3MTMzMWRkMmRkMGQ5L2RtZXNnLXF1YW50YWwtd2FpbWVhLTExOjIwMTMxMTEx
MDMzODQwOmkzODYtcmFuZGNvbmZpZy1qMy0xMTEwMTMwODozLjEyLjAtMDA2MzQtZzQ3Yjhk
OWM6NzY4Ci9rZXJuZWwvaTM4Ni1yYW5kY29uZmlnLWozLTExMTAxMzA4LzQ3YjhkOWM4YzM4
YTk1NjA5NGU3ZjZiMjMxMzcxMzMxZGQyZGQwZDkvZG1lc2cteW9jdG8taW5uLTI4OjIwMTMx
MTEwMTk0MjI4OmkzODYtcmFuZGNvbmZpZy1qMy0xMTEwMTMwODozLjEyLjAtMDA2MzQtZzQ3
YjhkOWM6NzY4Ci9rZXJuZWwvaTM4Ni1yYW5kY29uZmlnLWozLTExMTAxMzA4LzQ3YjhkOWM4
YzM4YTk1NjA5NGU3ZjZiMjMxMzcxMzMxZGQyZGQwZDkvZG1lc2cteW9jdG8tcm9hbS00NToy
MDEzMTExMDE5NDIyODppMzg2LXJhbmRjb25maWctajMtMTExMDEzMDg6My4xMi4wLTAwNjM0
LWc0N2I4ZDljOjc2OAo4OjEwOjEwIGFsbF9nb29kOmJhZDphbGxfYmFkIGJvb3RzChtbMTsz
NW1SRVBFQVQgQ09VTlQ6IDI4ICAjIC9jYy93ZmcvdXNiLWJpc2VjdC8ucmVwZWF0G1swbQoK
QmlzZWN0aW5nOiAzMjkgcmV2aXNpb25zIGxlZnQgdG8gdGVzdCBhZnRlciB0aGlzIChyb3Vn
aGx5IDggc3RlcHMpCls4YTRkMGI1NmIwMzE0NTVhZGNiZTRhOTM4M2MzYjQ5NzQ1NmZjZmFj
XSBNZXJnZSBicmFuY2ggJ3Vwcm9iZXMvY29yZScgb2YgZ2l0Oi8vZ2l0Lmtlcm5lbC5vcmcv
cHViL3NjbS9saW51eC9rZXJuZWwvZ2l0L29sZWcvbWlzYyBpbnRvIHBlcmYvY29yZQpydW5u
aW5nIC9jL2tlcm5lbC10ZXN0cy9iaXNlY3QtdGVzdC1ib290LWZhaWx1cmUuc2ggL2hvbWUv
d2ZnL3VzYi9vYmotYmlzZWN0CmxzIC1hIC9rZXJuZWwtdGVzdHMvcnVuLXF1ZXVlL2t2bS9p
Mzg2LXJhbmRjb25maWctajMtMTExMDEzMDgvbmV4dDptYXN0ZXI6OGE0ZDBiNTZiMDMxNDU1
YWRjYmU0YTkzODNjM2I0OTc0NTZmY2ZhYzpiaXNlY3QtdXNiCgoyMDEzLTExLTEwLTE5OjQy
OjQxIDhhNGQwYjU2YjAzMTQ1NWFkY2JlNGE5MzgzYzNiNDk3NDU2ZmNmYWMgY29tcGlsaW5n
CjQzOCByZWFsICA5OTMgdXNlciAgMTAwIHN5cyAgMjQ5LjU4JSBjcHUgCWkzODYtcmFuZGNv
bmZpZy1qMy0xMTEwMTMwOAoKMjAxMy0xMS0xMC0xOTo1NToyOCBkZXRlY3RpbmcgYm9vdCBz
dGF0ZSAzLjEyLjAtMDAzMDQtZzhhNGQwYjUuLgkxMAkxNgkyNi4uLi4JMjggU1VDQ0VTUwoK
QmlzZWN0aW5nOiAxNTggcmV2aXNpb25zIGxlZnQgdG8gdGVzdCBhZnRlciB0aGlzIChyb3Vn
aGx5IDcgc3RlcHMpCltjOTA0MjNkMWRlMTJmYmVhZjBjODk4ZTFkYjBlOTYyZGUzNDczMDJi
XSBNZXJnZSBicmFuY2ggJ3NjaGVkL2NvcmUnIGludG8gY29yZS9sb2NraW5nLCB0byBwcmVw
YXJlIHRoZSBrZXJuZWwvbG9ja2luZy8gZmlsZSBtb3ZlCnJ1bm5pbmcgL2Mva2VybmVsLXRl
c3RzL2Jpc2VjdC10ZXN0LWJvb3QtZmFpbHVyZS5zaCAvaG9tZS93ZmcvdXNiL29iai1iaXNl
Y3QKbHMgLWEgL2tlcm5lbC10ZXN0cy9ydW4tcXVldWUva3ZtL2kzODYtcmFuZGNvbmZpZy1q
My0xMTEwMTMwOC9uZXh0Om1hc3RlcjpjOTA0MjNkMWRlMTJmYmVhZjBjODk4ZTFkYjBlOTYy
ZGUzNDczMDJiOmJpc2VjdC11c2IKCjIwMTMtMTEtMTAtMjA6MDA6MzIgYzkwNDIzZDFkZTEy
ZmJlYWYwYzg5OGUxZGIwZTk2MmRlMzQ3MzAyYiBjb21waWxpbmcKMjg4IHJlYWwgIDk4NyB1
c2VyICA5NyBzeXMgIDM3NS45NyUgY3B1IAlpMzg2LXJhbmRjb25maWctajMtMTExMDEzMDgK
CjIwMTMtMTEtMTAtMjA6MTI6NDMgZGV0ZWN0aW5nIGJvb3Qgc3RhdGUgMy4xMi4wLTAwMTcx
LWdjOTA0MjNkLi4JMgk2Li4uCTguIFRFU1QgRkFJTFVSRQpbICAgIDEuOTg2OTA1XSBFREQg
aW5mb3JtYXRpb24gbm90IGF2YWlsYWJsZS4KWyAgICAxLjk4NzM2MV0gVW5yZWdpc3RlciBw
diBzaGFyZWQgbWVtb3J5IGZvciBjcHUgMApbICAgIDIuNjA0MTA0XSB0c2M6IFJlZmluZWQg
VFNDIGNsb2Nrc291cmNlIGNhbGlicmF0aW9uOiAyODkyLjk3OSBNSHoKWyAgMjQxLjYxNzA2
NF0gSU5GTzogdGFzayBzd2FwcGVyLzA6MSBibG9ja2VkIGZvciBtb3JlIHRoYW4gMTIwIHNl
Y29uZHMuClsgIDI0MS42MTc2OTFdICAgICAgIE5vdCB0YWludGVkIDMuMTIuMC0wMDE3MS1n
YzkwNDIzZCAjNzcwClsgIDI0MS42MTgxOTddICJlY2hvIDAgPiAvcHJvYy9zeXMva2VybmVs
L2h1bmdfdGFza190aW1lb3V0X3NlY3MiIGRpc2FibGVzIHRoaXMgbWVzc2FnZS4KWyAgMjQx
LjYxODkxOF0gc3dhcHBlci8wICAgICAgIEQgY2Q0MTc4MzggIDU4NDAgICAgIDEgICAgICAw
IDB4MDAwMDAwMDAKWyAgMjQxLjYxOTU1Ml0gIGNkNDI5ZGMwIDAwMDAwMDgyIGMwZTQ5MDgw
IGNkNDE3ODM4IDAwMDBhMDgwIGNkNDI5ZGNjIGMwYzAzMzQwIDAwMDAwMDA4ClsgIDI0MS42
MjAzNzldICBjMGIxOTk2MCBjMGMwMzM0MCBjZDQxNzQ0MCAwMDAwMDAwMCBjMGU0OTA4MCAw
MDAwMDAwNCAwMDAwMDAwMCAwMDAwYTA4MApbICAyNDEuNjIxMjk4XSAgYzBlNmIzNzAgMDAw
MDAwMDAgMjQwMjYxNDcgMDAwMDAwMDAgY2Q0MTc0NDAgYzAyOTAyZjcgMDAwMDAwMDAgMDAw
MDAwMDAKWyAgMjQxLjYyMjE0MV0gQ2FsbCBUcmFjZToKWyAgMjQxLjYyMjM3OF0gIFs8YzAy
OTAyZjc+XSA/IG1hcmtfaGVsZF9sb2NrcysweDg3LzB4ZjAKWyAgMjQxLjYyMjg1MV0gIFs8
YzA4MGY1YjA+XSBzY2hlZHVsZSsweDEwLzB4MjAKWyAgMjQxLjYyMzI2Ml0gIFs8YzA4MGM2
ZTU+XSBzY2hlZHVsZV90aW1lb3V0KzB4MTI1LzB4MTgwClsgIDI0MS42MjM3NDddICBbPGMw
ODExMTIyPl0gPyBfcmF3X3NwaW5fdW5sb2NrX2lycSsweDIyLzB4NTAKWyAgMjQxLjYyNDI2
Nl0gIFs8YzA4MGZkMjQ+XSA/IHdhaXRfZm9yX2NvbXBsZXRpb24rMHg5NC8weGQwClsgIDI0
MS42MjQ3NjddICBbPGMwMjkwNzRiPl0gPyB0cmFjZV9oYXJkaXJxc19vbisweGIvMHgxMApb
ICAyNDEuNjI1MjU0XSAgWzxjMDgwZmQyYj5dIHdhaXRfZm9yX2NvbXBsZXRpb24rMHg5Yi8w
eGQwClsgIDI0MS42MjU3NDNdICBbPGMwMjY2ZDIwPl0gPyB3YWtlX3VwX3N0YXRlKzB4MTAv
MHgxMApbICAyNDEuNjI2MjA1XSAgWzxjMDI4MmIwMD5dID8gX19jYWxsX3JjdS5jb25zdHBy
b3AuNjErMHgyNDAvMHgyNDAKWyAgMjQxLjYyNjc1NV0gIFs8YzAyODAyYWY+XSB3YWl0X3Jj
dV9ncCsweDNmLzB4NjAKWyAgMjQxLjYyNzE4NV0gIFs8YzAyODAxMTA+XSA/IHJjdV9wYW5p
YysweDIwLzB4MjAKWyAgMjQxLjYyNzYxMF0gIFs8YzAyODQ3MGY+XSBzeW5jaHJvbml6ZV9y
Y3UrMHgxZi8weDQwClsgIDI0MS42MjgwNzhdICBbPGMwN2Y3MGI5Pl0gX2NwdV9kb3duKzB4
MTI5LzB4MmMwClsgIDI0MS42Mjg1MDRdICBbPGMwN2Y3MmMyPl0gPyBjcHVfZG93bisweDEy
LzB4NDAKWyAgMjQxLjYyODkyNF0gIFs8YzAyMjg2OWY+XSA/IGNwdV9ob3RwbHVnX2RyaXZl
cl9sb2NrKzB4Zi8weDIwClsgIDI0MS42Mjk0NjRdICBbPGMwN2Y3MmQ0Pl0gY3B1X2Rvd24r
MHgyNC8weDQwClsgIDI0MS42Mjk4NjBdICBbPGMwN2Y2N2ZmPl0gX2RlYnVnX2hvdHBsdWdf
Y3B1KzB4NmYvMHhhMApbICAyNDEuNjMwMzQ4XSAgWzxjMDRiNzI2ZT5dID8gX19wbGF0Zm9y
bV9kcml2ZXJfcmVnaXN0ZXIrMHgzZS8weDQwClsgIDI0MS42MzA5MjBdICBbPGMwYmE5ZDc2
Pl0gPyBwY2lfaW9tbXVfYWxsb2MrMHg1YS8weDVhClsgIDI0MS42MzE0MDZdICBbPGMwYmE5
ZDgyPl0gZGVidWdfaG90cGx1Z19jcHUrMHhjLzB4MTAKWyAgMjQxLjYzMTg4NV0gIFs8YzBi
YTViNmM+XSBkb19vbmVfaW5pdGNhbGwrMHg4ZC8weDEyYwpbICAyNDEuNjMyMzYwXSAgWzxj
MDM2MDBkOD5dID8gaWRyX2dldF9lbXB0eV9zbG90KzB4MmQ4LzB4MzcwClsgIDI0MS42MzI4
ODZdICBbPGMwMjU5OGYzPl0gPyBwYXJhbWVxKzB4MTMvMHg3MApbICAyNDEuNjMzMzAyXSAg
WzxjMGJhNTUxMj5dID8gcmVwYWlyX2Vudl9zdHJpbmcrMHgxMi8weDUxClsgIDI0MS42MzM3
OTBdICBbPGMwMjU5YjFmPl0gPyBwYXJzZV9hcmdzKzB4MWNmLzB4MzIwClsgIDI0MS42MzQy
NDhdICBbPGMwMjUyODVlPl0gPyBfX3VzZXJtb2RlaGVscGVyX3NldF9kaXNhYmxlX2RlcHRo
KzB4M2UvMHg1MApbICAyNDEuNjM0ODY3XSAgWzxjMGJhNWNmNj5dIGtlcm5lbF9pbml0X2Zy
ZWVhYmxlKzB4ZWIvMHgxN2QKWyAgMjQxLjYzNTM4OV0gIFs8YzBiYTU1MDA+XSA/IGRvX2Vh
cmx5X3BhcmFtKzB4NzgvMHg3OApbICAyNDEuNjM1ODYzXSAgWzxjMDdmNjY1Yj5dIGtlcm5l
bF9pbml0KzB4Yi8weDE0MApbICAyNDEuNjM2Mjk2XSAgWzxjMDgxMjNiNz5dIHJldF9mcm9t
X2tlcm5lbF90aHJlYWQrMHgxYi8weDI4ClsgIDI0MS42MzY4MDRdICBbPGMwN2Y2NjUwPl0g
PyByZXN0X2luaXQrMHhjMC8weGMwClsgIDI0MS42MzcyMzRdIDMgbG9ja3MgaGVsZCBieSBz
d2FwcGVyLzAvMToKWyAgMjQxLjYzNzYwMV0gICMwOiAgKHg4Nl9jcHVfaG90cGx1Z19kcml2
ZXJfbXV0ZXgpeysuKy4rLn0sIGF0OiBbPGMwMjI4NjlmPl0gY3B1X2hvdHBsdWdfZHJpdmVy
X2xvY2srMHhmLzB4MjAKWyAgMjQxLjYzODU2N10gICMxOiAgKGNwdV9hZGRfcmVtb3ZlX2xv
Y2speysuKy4rLn0sIGF0OiBbPGMwN2Y3MmMyPl0gY3B1X2Rvd24rMHgxMi8weDQwClsgIDI0
MS42MzkzNDhdICAjMjogIChjcHVfaG90cGx1Zy5sb2NrKXsrLisuKy59LCBhdDogWzxjMDI0
MjFjZD5dIGNwdV9ob3RwbHVnX2JlZ2luKzB4MWQvMHg0MApbICAyNDEuNjQwMTgzXSBzZW5k
aW5nIE5NSSB0byBhbGwgQ1BVczoKWyAgMjQxLjY0MDU0Nl0gTk1JIGJhY2t0cmFjZSBmb3Ig
Y3B1IDEKWyAgMjQxLjY0MDg3M10gQ1BVOiAxIFBJRDogNDYgQ29tbToga2h1bmd0YXNrZCBO
b3QgdGFpbnRlZCAzLjEyLjAtMDAxNzEtZ2M5MDQyM2QgIzc3MApbICAyNDEuNjQxMTc1XSB0
YXNrOiBjZjY2MTAwMCB0aTogY2Y2NGEwMDAgdGFzay50aTogY2Y2NGEwMDAKWyAgMjQxLjY0
MTE3NV0gRUlQOiAwMDYwOls8YzAyMmM1ZTU+XSBFRkxBR1M6IDAwMDEwMDQ2IENQVTogMQpb
ICAyNDEuNjQxMTc1XSBFSVAgaXMgYXQgZGVmYXVsdF9zZW5kX0lQSV9tYXNrX2xvZ2ljYWwr
MHg4NS8weGYwClsgIDI0MS42NDExNzVdIEVBWDogMDAwMDBjMDAgRUJYOiAwMzAwMDAwMCBF
Q1g6IGZmZmZmMDAwIEVEWDogZmZmZmYwMDAKWyAgMjQxLjY0MTE3NV0gRVNJOiAwMDAwMDIw
NiBFREk6IDAwMDAwMDAyIEVCUDogY2Y2NGJlZDQgRVNQOiBjZjY0YmVjNApbICAyNDEuNjQx
MTc1XSAgRFM6IDAwN2IgRVM6IDAwN2IgRlM6IDAwZDggR1M6IDAwZTAgU1M6IDAwNjgKWyAg
MjQxLjY0MTE3NV0gQ1IwOiA4MDA1MDAzYiBDUjI6IGZmZmZmZmZmIENSMzogMDBjMGIwMDAg
Q1I0OiAwMDAwMDZmMApbICAyNDEuNjQxMTc1XSBTdGFjazoKWyAgMjQxLjY0MTE3NV0gIDAw
MDAwODAwIDAwMDAyNzEwIDAwMDA3ZmZmIDAwMDAwM2ZmIGNmNjRiZWUwIGMwMjJjNzE4IDAw
MDAyNzEwIGNmNjRiZWYwClsgIDI0MS42NDExNzVdICBjMDIyYzkwZCBjMGE0NzI3YSBjZDQx
NzQ0MCBjZjY0YmYzMCBjMDJhMmVlZSBjMGE1NjFiYyBjMGMxNWY2YyBjMGIwNzY0NgpbICAy
NDEuNjQxMTc1XSAgMDAwMDAwMDQgYzBiMDc2ODcgMDAwMDAwNzggMDAwMDAwMDQgY2Q0MTc1
MzggMDAwMDdmZmYgY2Q0MTc0NDAgY2Q0MTc1MzgKWyAgMjQxLjY0MTE3NV0gQ2FsbCBUcmFj
ZToKWyAgMjQxLjY0MTE3NV0gIFs8YzAyMmM3MTg+XSBkZWZhdWx0X3NlbmRfSVBJX2FsbCsw
eDU4LzB4NjAKWyAgMjQxLjY0MTE3NV0gIFs8YzAyMmM5MGQ+XSBhcmNoX3RyaWdnZXJfYWxs
X2NwdV9iYWNrdHJhY2UrMHgzZC8weDcwClsgIDI0MS42NDExNzVdICBbPGMwMmEyZWVlPl0g
d2F0Y2hkb2crMHgyZGUvMHgzMDAKWyAgMjQxLjY0MTE3NV0gIFs8YzAyYTJjMTA+XSA/IGh1
bmdfdGFza19wYW5pYysweDIwLzB4MjAKWyAgMjQxLjY0MTE3NV0gIFs8YzAyNWIyZmE+XSBr
dGhyZWFkKzB4OWEvMHhhMApbICAyNDEuNjQxMTc1XSAgWzxjMDI2MDAwMD5dID8gc2V0X3Nl
Y3VyaXR5X292ZXJyaWRlX2Zyb21fY3R4KzB4MTAvMHg0MApbICAyNDEuNjQxMTc1XSAgWzxj
MDgxMjNiNz5dIHJldF9mcm9tX2tlcm5lbF90aHJlYWQrMHgxYi8weDI4ClsgIDI0MS42NDEx
NzVdICBbPGMwMjViMjYwPl0gPyBfX2t0aHJlYWRfcGFya21lKzB4NjAvMHg2MApbICAyNDEu
NjQxMTc1XSBDb2RlOiAwMCBiMyBmZiBmZiBmNiBjNCAxMCA3NSBlZCBjMSBlMyAxOCA4OSA5
OSAxMCBiMyBmZiBmZiA4OSBmOCAwOSBkMCA4MCBjZSAwNCA4MyBmZiAwMiAwZiA0NCBjMiA4
YiAxNSA0NCAyMSBiMSBjMCA4OSA4MiAwMCBiMyBmZiBmZiA8Zjc+IGM2IDAwIDAyIDAwIDAw
IDc0IDFiIGU4IDRlIDQxIDA2IDAwIDg5IGYwIDUwIDlkIDhkIDc0IDI2IDAwCi9rZXJuZWwv
aTM4Ni1yYW5kY29uZmlnLWozLTExMTAxMzA4L2M5MDQyM2QxZGUxMmZiZWFmMGM4OThlMWRi
MGU5NjJkZTM0NzMwMmIvZG1lc2ctcXVhbnRhbC1jYWlyby0zOjIwMTMxMTEwMjAxNzAwOmkz
ODYtcmFuZGNvbmZpZy1qMy0xMTEwMTMwODozLjEyLjAtMDAxNzEtZ2M5MDQyM2Q6NzcwCi9r
ZXJuZWwvaTM4Ni1yYW5kY29uZmlnLWozLTExMTAxMzA4L2M5MDQyM2QxZGUxMmZiZWFmMGM4
OThlMWRiMGU5NjJkZTM0NzMwMmIvZG1lc2cteW9jdG8td2FpbWVhLTg6MjAxMzExMTEwNDEz
MTI6aTM4Ni1yYW5kY29uZmlnLWozLTExMTAxMzA4OjMuMTIuMC0wMDE3MS1nYzkwNDIzZDo3
NzAKL2tlcm5lbC9pMzg2LXJhbmRjb25maWctajMtMTExMDEzMDgvYzkwNDIzZDFkZTEyZmJl
YWYwYzg5OGUxZGIwZTk2MmRlMzQ3MzAyYi9kbWVzZy15b2N0by14aWFuLTQ6MjAxMzExMTAy
MDE3MDU6aTM4Ni1yYW5kY29uZmlnLWozLTExMTAxMzA4OjMuMTIuMC0wMDE3MS1nYzkwNDIz
ZDo3NzAKL2tlcm5lbC9pMzg2LXJhbmRjb25maWctajMtMTExMDEzMDgvYzkwNDIzZDFkZTEy
ZmJlYWYwYzg5OGUxZGIwZTk2MmRlMzQ3MzAyYi9kbWVzZy1xdWFudGFsLWNhaXJvLTE4OjIw
MTMxMTEwMjAxNzA4OmkzODYtcmFuZGNvbmZpZy1qMy0xMTEwMTMwODozLjEyLjAtMDAxNzEt
Z2M5MDQyM2Q6NzcwCjg6NDozIGFsbF9nb29kOmJhZDphbGxfYmFkIGJvb3RzChtbMTszNW1S
RVBFQVQgQ09VTlQ6IDM3ICAjIC9jYy93ZmcvdXNiLWJpc2VjdC8ucmVwZWF0G1swbQoKQmlz
ZWN0aW5nOiA4NSByZXZpc2lvbnMgbGVmdCB0byB0ZXN0IGFmdGVyIHRoaXMgKHJvdWdobHkg
NyBzdGVwcykKWzkwNTcyODkwZDIwMjUyN2MzNjZhYTk0ODliMzI0MDRlODhhN2MwMjBdIG1t
OiBudW1hOiBDaGFuZ2UgcGFnZSBsYXN0IHtuaWQscGlkfSBpbnRvIHtjcHUscGlkfQpydW5u
aW5nIC9jL2tlcm5lbC10ZXN0cy9iaXNlY3QtdGVzdC1ib290LWZhaWx1cmUuc2ggL2hvbWUv
d2ZnL3VzYi9vYmotYmlzZWN0CmxzIC1hIC9rZXJuZWwtdGVzdHMvcnVuLXF1ZXVlL2t2bS9p
Mzg2LXJhbmRjb25maWctajMtMTExMDEzMDgvbmV4dDptYXN0ZXI6OTA1NzI4OTBkMjAyNTI3
YzM2NmFhOTQ4OWIzMjQwNGU4OGE3YzAyMDpiaXNlY3QtdXNiCgoyMDEzLTExLTEwLTIwOjE3
OjIxIDkwNTcyODkwZDIwMjUyN2MzNjZhYTk0ODliMzI0MDRlODhhN2MwMjAgY29tcGlsaW5n
CjcyNCByZWFsICA5OTkgdXNlciAgMTAxIHN5cyAgMTUyLjE5JSBjcHUgCWkzODYtcmFuZGNv
bmZpZy1qMy0xMTEwMTMwOAoKMjAxMy0xMS0xMC0yMDozNDowNiBkZXRlY3RpbmcgYm9vdCBz
dGF0ZSAzLjEyLjAtcmM0LTAwMDg1LWc5MDU3Mjg5Li4JMjIJMzcgU1VDQ0VTUwoKQmlzZWN0
aW5nOiA0MiByZXZpc2lvbnMgbGVmdCB0byB0ZXN0IGFmdGVyIHRoaXMgKHJvdWdobHkgNiBz
dGVwcykKW2I0MTQ1ODcyZjcwNDllNDI5NzE4YjQwYjg2ZTFiNDY2NTk5ODgzOThdIHNjaGVk
OiBNb3ZlIHdhaXQgY29kZSBmcm9tIGNvcmUuYyB0byB3YWl0LmMKcnVubmluZyAvYy9rZXJu
ZWwtdGVzdHMvYmlzZWN0LXRlc3QtYm9vdC1mYWlsdXJlLnNoIC9ob21lL3dmZy91c2Ivb2Jq
LWJpc2VjdApscyAtYSAva2VybmVsLXRlc3RzL3J1bi1xdWV1ZS9rdm0vaTM4Ni1yYW5kY29u
ZmlnLWozLTExMTAxMzA4L25leHQ6bWFzdGVyOmI0MTQ1ODcyZjcwNDllNDI5NzE4YjQwYjg2
ZTFiNDY2NTk5ODgzOTg6YmlzZWN0LXVzYgoKMjAxMy0xMS0xMC0yMDozNjowOCBiNDE0NTg3
MmY3MDQ5ZTQyOTcxOGI0MGI4NmUxYjQ2NjU5OTg4Mzk4IGNvbXBpbGluZwo0OTMgcmVhbCAg
OTkyIHVzZXIgIDEwNiBzeXMgIDIyMy4wMCUgY3B1IAlpMzg2LXJhbmRjb25maWctajMtMTEx
MDEzMDgKCjIwMTMtMTEtMTAtMjA6NDg6MzcgZGV0ZWN0aW5nIGJvb3Qgc3RhdGUgMy4xMi4w
LXJjNy0wMDIwMC1nYjQxNDU4Ny4uCTYJMTMJMTQJMTUuLi4gVEVTVCBGQUlMVVJFClsgICAg
NS4zNDk5NTJdIEJJT1MgRUREIGZhY2lsaXR5IHYwLjE2IDIwMDQtSnVuLTI1LCAwIGRldmlj
ZXMgZm91bmQKWyAgICA1LjM1MDk3MF0gRUREIGluZm9ybWF0aW9uIG5vdCBhdmFpbGFibGUu
ClsgICAgNS4zNTE3NTldIFVucmVnaXN0ZXIgcHYgc2hhcmVkIG1lbW9yeSBmb3IgY3B1IDAK
WyAgMjQ0LjE0NDA2Ml0gSU5GTzogdGFzayBzd2FwcGVyLzA6MSBibG9ja2VkIGZvciBtb3Jl
IHRoYW4gMTIwIHNlY29uZHMuClsgIDI0NC4xNDUxNDBdICAgICAgIE5vdCB0YWludGVkIDMu
MTIuMC1yYzctMDAyMDAtZ2I0MTQ1ODcgIzc3MgpbICAyNDQuMTQ2MDQ0XSAiZWNobyAwID4g
L3Byb2Mvc3lzL2tlcm5lbC9odW5nX3Rhc2tfdGltZW91dF9zZWNzIiBkaXNhYmxlcyB0aGlz
IG1lc3NhZ2UuClsgIDI0NC4xNDcyOTRdIHN3YXBwZXIvMCAgICAgICBEIGNkNDE3ODM4ICA1
Nzk2ICAgICAxICAgICAgMCAweDAwMDAwMDAwClsgIDI0NC4xNDgzNjZdICBjZDQyOWRjMCAw
MDAwMDA4MiBjMGU0OTA0MCBjZDQxNzgzOCAwMDAwYTA4MCBjZDQyOWRjYyBjMGMwMzM0MCAw
MDAwMDAwOApbICAyNDQuMTQ5Nzc3XSAgYzBiMTk5YTAgYzBjMDMzNDAgY2Q0MTc0NDAgMDAw
MDAwMDAgYzBlNDkwNDAgMDAwMDAwMDQgMDAwMDAwMDAgMDAwMGEwODAKWyAgMjQ0LjE1MTIw
N10gIGMwZTZiMzMwIDAwMDAwMDAwIDI0MDI2MTQ3IDAwMDAwMDAwIGNkNDE3NDQwIGMwMjhj
NjA3IDAwMDAwMDAxIDAwMDAwMDAwClsgIDI0NC4xNTI2MjZdIENhbGwgVHJhY2U6ClsgIDI0
NC4xNTMwNzhdICBbPGMwMjhjNjA3Pl0gPyBtYXJrX2hlbGRfbG9ja3MrMHg4Ny8weGYwClsg
IDI0NC4xNTM5MDldICBbPGMwODBmODAwPl0gc2NoZWR1bGUrMHgxMC8weDIwClsgIDI0NC4x
NTQ2MTRdICBbPGMwODBjOGY1Pl0gc2NoZWR1bGVfdGltZW91dCsweDEyNS8weDE4MApbICAy
NDQuMTU1NDQ3XSAgWzxjMDgxMTNhMj5dID8gX3Jhd19zcGluX3VubG9ja19pcnErMHgyMi8w
eDUwClsgIDI0NC4xNTYzMzBdICBbPGMwODBmY2Y0Pl0gPyB3YWl0X2Zvcl9jb21wbGV0aW9u
KzB4OTQvMHhkMApbICAyNDQuMTU3MTkwXSAgWzxjMDI4Y2E1Yj5dID8gdHJhY2VfaGFyZGly
cXNfb24rMHhiLzB4MTAKWyAgMjQ0LjE1Nzk5OF0gIFs8YzA4MGZjZmI+XSB3YWl0X2Zvcl9j
b21wbGV0aW9uKzB4OWIvMHhkMApbICAyNDQuMTU4ODQ5XSAgWzxjMDI2NzgzMD5dID8gd2Fr
ZV91cF9zdGF0ZSsweDEwLzB4MTAKWyAgMjQ0LjE1OTY0N10gIFs8YzAyYTExZDA+XSA/IF9f
Y2FsbF9yY3UuY29uc3Rwcm9wLjYxKzB4MjQwLzB4MjQwClsgIDI0NC4xNjA2MDJdICBbPGMw
MjU4ZmZmPl0gd2FpdF9yY3VfZ3ArMHgzZi8weDYwClsgIDI0NC4xNjEzNDFdICBbPGMwMjU4
ZTcwPl0gPyByY3VfcGFuaWMrMHgyMC8weDIwClsgIDI0NC4xNjIwNjddICBbPGMwMmEzMzRm
Pl0gc3luY2hyb25pemVfcmN1KzB4MWYvMHg0MApbICAyNDQuMTYyODM5XSAgWzxjMDdmNzJh
OT5dIF9jcHVfZG93bisweDEyOS8weDJjMApbICAyNDQuMTYzNTgxXSAgWzxjMDdmNzRiMj5d
ID8gY3B1X2Rvd24rMHgxMi8weDQwClsgIDI0NC4xNjQzMTFdICBbPGMwMjI4NjlmPl0gPyBj
cHVfaG90cGx1Z19kcml2ZXJfbG9jaysweGYvMHgyMApbICAyNDQuMTY1MjE3XSAgWzxjMDdm
NzRjND5dIGNwdV9kb3duKzB4MjQvMHg0MApbICAyNDQuMTY1ODk4XSAgWzxjMDdmNjllZj5d
IF9kZWJ1Z19ob3RwbHVnX2NwdSsweDZmLzB4YTAKWyAgMjQ0LjE2Njc0OF0gIFs8YzA0Yjc0
NWU+XSA/IF9fcGxhdGZvcm1fZHJpdmVyX3JlZ2lzdGVyKzB4M2UvMHg0MApbICAyNDQuMTY3
NzI3XSAgWzxjMGJhOWQ3Nj5dID8gcGNpX2lvbW11X2FsbG9jKzB4NWEvMHg1YQpbICAyNDQu
MTY4NTQ2XSAgWzxjMGJhOWQ4Mj5dIGRlYnVnX2hvdHBsdWdfY3B1KzB4Yy8weDEwClsgIDI0
NC4xNjkzNDhdICBbPGMwYmE1YjZjPl0gZG9fb25lX2luaXRjYWxsKzB4OGQvMHgxMmMKWyAg
MjQ0LjE3MDE0M10gIFs8YzAyNTliMjM+XSA/IHBhcmFtZXErMHgxMy8weDcwClsgIDI0NC4x
NzA4MzddICBbPGMwYmE1NTEyPl0gPyByZXBhaXJfZW52X3N0cmluZysweDEyLzB4NTEKWyAg
MjQ0LjE3MTY4NF0gIFs8YzAyNTlkNGY+XSA/IHBhcnNlX2FyZ3MrMHgxY2YvMHgzMjAKWyAg
MjQ0LjE3MjQ2OV0gIFs8YzAyNTI4NWU+XSA/IF9fdXNlcm1vZGVoZWxwZXJfc2V0X2Rpc2Fi
bGVfZGVwdGgrMHgzZS8weDUwClsgIDI0NC4xNzM1NDRdICBbPGMwYmE1Y2Y2Pl0ga2VybmVs
X2luaXRfZnJlZWFibGUrMHhlYi8weDE3ZApbICAyNDQuMTc0NDE0XSAgWzxjMGJhNTUwMD5d
ID8gZG9fZWFybHlfcGFyYW0rMHg3OC8weDc4ClsgIDI0NC4xNzUyMDldICBbPGMwN2Y2ODRi
Pl0ga2VybmVsX2luaXQrMHhiLzB4MTQwClsgIDI0NC4xNzU5MjldICBbPGMwODEyNjM3Pl0g
cmV0X2Zyb21fa2VybmVsX3RocmVhZCsweDFiLzB4MjgKWyAgMjQ0LjE3NjgxNF0gIFs8YzA3
ZjY4NDA+XSA/IHJlc3RfaW5pdCsweGMwLzB4YzAKWyAgMjQ0LjE3NzU1Ml0gMyBsb2NrcyBo
ZWxkIGJ5IHN3YXBwZXIvMC8xOgpbICAyNDQuMTc4MTg3XSAgIzA6ICAoeDg2X2NwdV9ob3Rw
bHVnX2RyaXZlcl9tdXRleCl7Ky4rLisufSwgYXQ6IFs8YzAyMjg2OWY+XSBjcHVfaG90cGx1
Z19kcml2ZXJfbG9jaysweGYvMHgyMApbICAyNDQuMTc5ODQ0XSAgIzE6ICAoY3B1X2FkZF9y
ZW1vdmVfbG9jayl7Ky4rLisufSwgYXQ6IFs8YzA3Zjc0YjI+XSBjcHVfZG93bisweDEyLzB4
NDAKWyAgMjQ0LjE4MTIwNF0gICMyOiAgKGNwdV9ob3RwbHVnLmxvY2speysuKy4rLn0sIGF0
OiBbPGMwMjQyMWNkPl0gY3B1X2hvdHBsdWdfYmVnaW4rMHgxZC8weDQwClsgIDI0NC4xODI2
MzRdIHNlbmRpbmcgTk1JIHRvIGFsbCBDUFVzOgpbICAyNDQuMTgzMjM1XSBOTUkgYmFja3Ry
YWNlIGZvciBjcHUgMQpbICAyNDQuMTgzODA4XSBDUFU6IDEgUElEOiA0NiBDb21tOiBraHVu
Z3Rhc2tkIE5vdCB0YWludGVkIDMuMTIuMC1yYzctMDAyMDAtZ2I0MTQ1ODcgIzc3MgpbICAy
NDQuMTg0MjA3XSB0YXNrOiBjZjY2MjU2MCB0aTogY2Y2NTAwMDAgdGFzay50aTogY2Y2NTAw
MDAKWyAgMjQ0LjE4NDIwN10gRUlQOiAwMDYwOls8YzAyMmM1ZTU+XSBFRkxBR1M6IDAwMDEw
MDQ2IENQVTogMQpbICAyNDQuMTg0MjA3XSBFSVAgaXMgYXQgZGVmYXVsdF9zZW5kX0lQSV9t
YXNrX2xvZ2ljYWwrMHg4NS8weGYwClsgIDI0NC4xODQyMDddIEVBWDogMDAwMDBjMDAgRUJY
OiAwMzAwMDAwMCBFQ1g6IGZmZmZmMDAwIEVEWDogZmZmZmYwMDAKWyAgMjQ0LjE4NDIwN10g
RVNJOiAwMDAwMDIwNiBFREk6IDAwMDAwMDAyIEVCUDogY2Y2NTFlZDQgRVNQOiBjZjY1MWVj
NApbICAyNDQuMTg0MjA3XSAgRFM6IDAwN2IgRVM6IDAwN2IgRlM6IDAwZDggR1M6IDAwZTAg
U1M6IDAwNjgKWyAgMjQ0LjE4NDIwN10gQ1IwOiA4MDA1MDAzYiBDUjI6IGZmZmZmZmZmIENS
MzogMDBjMGIwMDAgQ1I0OiAwMDAwMDZmMApbICAyNDQuMTg0MjA3XSBTdGFjazoKWyAgMjQ0
LjE4NDIwN10gIDAwMDAwODAwIDAwMDAyNzEwIDAwMDA3ZmZmIDAwMDAwM2ZmIGNmNjUxZWUw
IGMwMjJjNzE4IDAwMDAyNzEwIGNmNjUxZWYwClsgIDI0NC4xODQyMDddICBjMDIyYzkwZCBj
MGE0NzI3MiBjZDQxNzQ0MCBjZjY1MWYzMCBjMDI5ZjFmNiBjMGE1NWUwMCBjMGMxNWY2YyBj
MGIwNzY0NgpbICAyNDQuMTg0MjA3XSAgMDAwMDAwMDQgYzBiMDc2ODcgMDAwMDAwNzggMDAw
MDAwMDQgY2Q0MTc1MzggMDAwMDdmZmYgY2Q0MTc0NDAgY2Q0MTc1MzgKWyAgMjQ0LjE4NDIw
N10gQ2FsbCBUcmFjZToKWyAgMjQ0LjE4NDIwN10gIFs8YzAyMmM3MTg+XSBkZWZhdWx0X3Nl
bmRfSVBJX2FsbCsweDU4LzB4NjAKWyAgMjQ0LjE4NDIwN10gIFs8YzAyMmM5MGQ+XSBhcmNo
X3RyaWdnZXJfYWxsX2NwdV9iYWNrdHJhY2UrMHgzZC8weDcwClsgIDI0NC4xODQyMDddICBb
PGMwMjlmMWY2Pl0gd2F0Y2hkb2crMHgyZDYvMHgzMDAKWyAgMjQ0LjE4NDIwN10gIFs8YzAy
OWVmMjA+XSA/IGh1bmdfdGFza19wYW5pYysweDIwLzB4MjAKWyAgMjQ0LjE4NDIwN10gIFs8
YzAyNWI1MmE+XSBrdGhyZWFkKzB4OWEvMHhhMApbICAyNDQuMTg0MjA3XSAgWzxjMDI2MDAw
MD5dID8gX19hdG9taWNfbm90aWZpZXJfY2FsbF9jaGFpbisweDgwLzB4ODAKWyAgMjQ0LjE4
NDIwN10gIFs8YzA4MTI2Mzc+XSByZXRfZnJvbV9rZXJuZWxfdGhyZWFkKzB4MWIvMHgyOApb
ICAyNDQuMTg0MjA3XSAgWzxjMDI1YjQ5MD5dID8gX19rdGhyZWFkX3BhcmttZSsweDYwLzB4
NjAKWyAgMjQ0LjE4NDIwN10gQ29kZTogMDAgYjMgZmYgZmYgZjYgYzQgMTAgNzUgZWQgYzEg
ZTMgMTggODkgOTkgMTAgYjMgZmYgZmYgODkgZjggMDkgZDAgODAgY2UgMDQgODMgZmYgMDIg
MGYgNDQgYzIgOGIgMTUgNDQgMjEgYjEgYzAgODkgODIgMDAgYjMgZmYgZmYgPGY3PiBjNiAw
MCAwMiAwMCAwMCA3NCAxYiBlOCA1ZSAwNCAwNiAwMCA4OSBmMCA1MCA5ZCA4ZCA3NCAyNiAw
MApbICAyNDQuMTg0MDE3XSBOTUkgYmFja3RyYWNlIGZvciBjcHUgMApbICAyNDQuMTg0MDE3
XSBDUFU6IDAgUElEOiAwIENvbW06IHN3YXBwZXIvMCBOb3QgdGFpbnRlZCAzLjEyLjAtcmM3
LTAwMjAwLWdiNDE0NTg3ICM3NzIKWyAgMjQ0LjE4NDAxN10gdGFzazogYzBiMDc3ZTAgdGk6
IGMwYjA0MDAwIHRhc2sudGk6IGMwYjA0MDAwClsgIDI0NC4xODQwMTddIEVJUDogMDA2MDpb
PGMwMjMwZWI1Pl0gRUZMQUdTOiAwMDIwMDI4MiBDUFU6IDAKWyAgMjQ0LjE4NDAxN10gRUlQ
IGlzIGF0IG5hdGl2ZV9zYWZlX2hhbHQrMHg1LzB4MTAKWyAgMjQ0LjE4NDAxN10gRUFYOiBj
MGIwNzdlMCBFQlg6IGMwYjA0MDAwIEVDWDogMDAwMDAwMDAgRURYOiAwMDAwMDAwMQpbICAy
NDQuMTg0MDE3XSBFU0k6IGMwYmEyNjI4IEVESTogZmZmZmZmZmYgRUJQOiBjMGIwNWY4MCBF
U1A6IGMwYjA1ZjgwClsgIDI0NC4xODQwMTddICBEUzogMDA3YiBFUzogMDA3YiBGUzogMDBk
OCBHUzogMDBlMCBTUzogMDA2OApbICAyNDQuMTg0MDE3XSBDUjA6IDgwMDUwMDNiIENSMjog
MDAwMDAwMDAgQ1IzOiAwMGMwYjAwMCBDUjQ6IDAwMDAwNmYwClsgIDI0NC4xODQwMTddIFN0
YWNrOgpbICAyNDQuMTg0MDE3XSAgYzBiMDVmODggYzAyMDk5Y2QgYzBiMDVmOTAgYzAyMGEx
NDYgYzBiMDVmYWMgYzAyN2I3Y2EgZjg0MTM3ZTUgMTg3YTcxMjQKWyAgMjQ0LjE4NDAxN10g
IDAwMDAwMDAyIDAwMDIwODAwIGMwYzBjODAwIGMwYjA1ZmM4IGMwN2Y2ODMwIDAwMDAwMDAy
IDAwMDAwMDAxIDAwMDAwMDAwClsgIDI0NC4xODQwMTddICBjMDdmNjc4MCAwMDAwMDAwMCBj
MGIwNWZlYyBjMGJhNWFkOSAwMDAwMDMxNSBmZmZmZmZmZiBmZmZmZmZmZiBjMGJhNTU1MQpb
ICAyNDQuMTg0MDE3XSBDYWxsIFRyYWNlOgpbICAyNDQuMTg0MDE3XSAgWzxjMDIwOTljZD5d
IGRlZmF1bHRfaWRsZSsweGQvMHgxMApbICAyNDQuMTg0MDE3XSAgWzxjMDIwYTE0Nj5dIGFy
Y2hfY3B1X2lkbGUrMHgyNi8weDMwClsgIDI0NC4xODQwMTddICBbPGMwMjdiN2NhPl0gY3B1
X3N0YXJ0dXBfZW50cnkrMHgxM2EvMHgxYzAKWyAgMjQ0LjE4NDAxN10gIFs8YzA3ZjY4MzA+
XSByZXN0X2luaXQrMHhiMC8weGMwClsgIDI0NC4xODQwMTddICBbPGMwN2Y2NzgwPl0gPyBf
X3JlYWRfbG9ja19mYWlsZWQrMHgxYy8weDFjClsgIDI0NC4xODQwMTddICBbPGMwYmE1YWQ5
Pl0gc3RhcnRfa2VybmVsKzB4M2JmLzB4M2M1ClsgIDI0NC4xODQwMTddICBbPGMwYmE1NTUx
Pl0gPyByZXBhaXJfZW52X3N0cmluZysweDUxLzB4NTEKWyAgMjQ0LjE4NDAxN10gIFs8YzBi
YTUzNzg+XSBpMzg2X3N0YXJ0X2tlcm5lbCsweDEyZS8weDEzMQpbICAyNDQuMTg0MDE3XSBD
b2RlOiBiYyAyNyAwMCAwMCAwMCAwMCA1NSA4OSBlNSBmYSA1ZCBjMyA4ZCA3NiAwMCA4ZCBi
YyAyNyAwMCAwMCAwMCAwMCA1NSA4OSBlNSBmYiA1ZCBjMyA4ZCA3NiAwMCA4ZCBiYyAyNyAw
MCAwMCAwMCAwMCA1NSA4OSBlNSBmYiBmNCA8NWQ+IGMzIDg5IGY2IDhkIGJjIDI3IDAwIDAw
IDAwIDAwIDU1IDg5IGU1IGY0IDVkIGMzIDhkIDc2IDAwIDhkCi9rZXJuZWwvaTM4Ni1yYW5k
Y29uZmlnLWozLTExMTAxMzA4L2I0MTQ1ODcyZjcwNDllNDI5NzE4YjQwYjg2ZTFiNDY2NTk5
ODgzOTgvZG1lc2ctcXVhbnRhbC1iZW5zLTI6MjAxMzExMTAyMDUyNDk6aTM4Ni1yYW5kY29u
ZmlnLWozLTExMTAxMzA4OjMuMTIuMC1yYzctMDAyMDAtZ2I0MTQ1ODc6NzcyCi9rZXJuZWwv
aTM4Ni1yYW5kY29uZmlnLWozLTExMTAxMzA4L2I0MTQ1ODcyZjcwNDllNDI5NzE4YjQwYjg2
ZTFiNDY2NTk5ODgzOTgvZG1lc2ctcXVhbnRhbC14aWFuLTI1OjIwMTMxMTEwMjA1MjQ1Omkz
ODYtcmFuZGNvbmZpZy1qMy0xMTEwMTMwODozLjEyLjAtcmM3LTAwMjAwLWdiNDE0NTg3Ojc3
Mgova2VybmVsL2kzODYtcmFuZGNvbmZpZy1qMy0xMTEwMTMwOC9iNDE0NTg3MmY3MDQ5ZTQy
OTcxOGI0MGI4NmUxYjQ2NjU5OTg4Mzk4L2RtZXNnLXlvY3RvLWNhaXJvLTE2OjIwMTMxMTEw
MjA1MjQ4OmkzODYtcmFuZGNvbmZpZy1qMy0xMTEwMTMwODozLjEyLjAtcmM3LTAwMjAwLWdi
NDE0NTg3Ojc3Mgova2VybmVsL2kzODYtcmFuZGNvbmZpZy1qMy0xMTEwMTMwOC9iNDE0NTg3
MmY3MDQ5ZTQyOTcxOGI0MGI4NmUxYjQ2NjU5OTg4Mzk4L2RtZXNnLXlvY3RvLWNhaXJvLTMz
OjIwMTMxMTEwMjA1MjQ5OmkzODYtcmFuZGNvbmZpZy1qMy0xMTEwMTMwODozLjEyLjAtcmM3
LTAwMjAwLWdiNDE0NTg3Ojc3Mgova2VybmVsL2kzODYtcmFuZGNvbmZpZy1qMy0xMTEwMTMw
OC9iNDE0NTg3MmY3MDQ5ZTQyOTcxOGI0MGI4NmUxYjQ2NjU5OTg4Mzk4L2RtZXNnLXlvY3Rv
LWlubi00MzoyMDEzMTExMDIwNTI0NTppMzg2LXJhbmRjb25maWctajMtMTExMDEzMDg6My4x
Mi4wLXJjNy0wMDIwMC1nYjQxNDU4Nzo3NzIKL2tlcm5lbC9pMzg2LXJhbmRjb25maWctajMt
MTExMDEzMDgvYjQxNDU4NzJmNzA0OWU0Mjk3MThiNDBiODZlMWI0NjY1OTk4ODM5OC9kbWVz
Zy15b2N0by1yb2FtLTM1OjIwMTMxMTEwMjA1MjQ2OmkzODYtcmFuZGNvbmZpZy1qMy0xMTEw
MTMwODozLjEyLjAtcmM3LTAwMjAwLWdiNDE0NTg3Ojc3Mgova2VybmVsL2kzODYtcmFuZGNv
bmZpZy1qMy0xMTEwMTMwOC9iNDE0NTg3MmY3MDQ5ZTQyOTcxOGI0MGI4NmUxYjQ2NjU5OTg4
Mzk4L2RtZXNnLXlvY3RvLXNuYi05OjIwMTMxMTEwMjA1MjQ0OmkzODYtcmFuZGNvbmZpZy1q
My0xMTEwMTMwODozLjEyLjAtcmM3LTAwMjAwLWdiNDE0NTg3Ojc3Mgova2VybmVsL2kzODYt
cmFuZGNvbmZpZy1qMy0xMTEwMTMwOC9iNDE0NTg3MmY3MDQ5ZTQyOTcxOGI0MGI4NmUxYjQ2
NjU5OTg4Mzk4L2RtZXNnLXlvY3RvLXhpYW4tMjA6MjAxMzExMTAyMDUyNDY6aTM4Ni1yYW5k
Y29uZmlnLWozLTExMTAxMzA4OjMuMTIuMC1yYzctMDAyMDAtZ2I0MTQ1ODc6NzcyCi9rZXJu
ZWwvaTM4Ni1yYW5kY29uZmlnLWozLTExMTAxMzA4L2I0MTQ1ODcyZjcwNDllNDI5NzE4YjQw
Yjg2ZTFiNDY2NTk5ODgzOTgvZG1lc2ctcXVhbnRhbC1jYWlyby0yNDoyMDEzMTExMDIwNTI1
NTppMzg2LXJhbmRjb25maWctajMtMTExMDEzMDg6My4xMi4wLXJjNy0wMDIwMC1nYjQxNDU4
Nzo3NzIKL2tlcm5lbC9pMzg2LXJhbmRjb25maWctajMtMTExMDEzMDgvYjQxNDU4NzJmNzA0
OWU0Mjk3MThiNDBiODZlMWI0NjY1OTk4ODM5OC9kbWVzZy1xdWFudGFsLWlubi0yNToyMDEz
MTExMDIwNTMwNTppMzg2LXJhbmRjb25maWctajMtMTExMDEzMDg6My4xMi4wLXJjNy0wMDIw
MC1nYjQxNDU4Nzo3NzIKL2tlcm5lbC9pMzg2LXJhbmRjb25maWctajMtMTExMDEzMDgvYjQx
NDU4NzJmNzA0OWU0Mjk3MThiNDBiODZlMWI0NjY1OTk4ODM5OC9kbWVzZy1xdWFudGFsLWlu
bi0zOjIwMTMxMTEwMjA1MjUxOmkzODYtcmFuZGNvbmZpZy1qMy0xMTEwMTMwODozLjEyLjAt
cmM3LTAwMjAwLWdiNDE0NTg3Ojc3Mgova2VybmVsL2kzODYtcmFuZGNvbmZpZy1qMy0xMTEw
MTMwOC9iNDE0NTg3MmY3MDQ5ZTQyOTcxOGI0MGI4NmUxYjQ2NjU5OTg4Mzk4L2RtZXNnLXF1
YW50YWwtcm9hbS0xNzoyMDEzMTExMDIwNTMwMzppMzg2LXJhbmRjb25maWctajMtMTExMDEz
MDg6My4xMi4wLXJjNy0wMDIwMC1nYjQxNDU4Nzo3NzIKMTU6MTI6MTAgYWxsX2dvb2Q6YmFk
OmFsbF9iYWQgYm9vdHMKCkJpc2VjdGluZzogMjEgcmV2aXNpb25zIGxlZnQgdG8gdGVzdCBh
ZnRlciB0aGlzIChyb3VnaGx5IDUgc3RlcHMpClsyNzM5ZDNlZWYzYTkzYTkyYzM2NmEzYTBi
Yjg1YTBhZmUwOWU4YjhjXSBzY2hlZC9udW1hOiBSZXRyeSB0YXNrX251bWFfbWlncmF0ZSgp
IHBlcmlvZGljYWxseQpydW5uaW5nIC9jL2tlcm5lbC10ZXN0cy9iaXNlY3QtdGVzdC1ib290
LWZhaWx1cmUuc2ggL2hvbWUvd2ZnL3VzYi9vYmotYmlzZWN0CmxzIC1hIC9rZXJuZWwtdGVz
dHMvcnVuLXF1ZXVlL2t2bS9pMzg2LXJhbmRjb25maWctajMtMTExMDEzMDgvbmV4dDptYXN0
ZXI6MjczOWQzZWVmM2E5M2E5MmMzNjZhM2EwYmI4NWEwYWZlMDllOGI4YzpiaXNlY3QtdXNi
CgoyMDEzLTExLTEwLTIwOjUzOjEwIDI3MzlkM2VlZjNhOTNhOTJjMzY2YTNhMGJiODVhMGFm
ZTA5ZThiOGMgY29tcGlsaW5nCjcwNSByZWFsICA5OTEgdXNlciAgOTcgc3lzICAxNTQuMzIl
IGNwdSAJaTM4Ni1yYW5kY29uZmlnLWozLTExMTAxMzA4CgoyMDEzLTExLTEwLTIxOjA2OjEz
IGRldGVjdGluZyBib290IHN0YXRlIDMuMTIuMC1yYzQtMDAxMDYtZzI3MzlkM2UuLgk4CTM2
CTM3IFNVQ0NFU1MKCkJpc2VjdGluZzogMTAgcmV2aXNpb25zIGxlZnQgdG8gdGVzdCBhZnRl
ciB0aGlzIChyb3VnaGx5IDQgc3RlcHMpCls5MmVjMTE4MDk1NjVjZjY0MjljNzUyMDRlOTll
MGY1ODNiNWM5ZDdjXSBzY2hlZC93YWl0OiBGaXggYnVpbGQgYnJlYWthZ2UKcnVubmluZyAv
Yy9rZXJuZWwtdGVzdHMvYmlzZWN0LXRlc3QtYm9vdC1mYWlsdXJlLnNoIC9ob21lL3dmZy91
c2Ivb2JqLWJpc2VjdApscyAtYSAva2VybmVsLXRlc3RzL3J1bi1xdWV1ZS9rdm0vaTM4Ni1y
YW5kY29uZmlnLWozLTExMTAxMzA4L25leHQ6bWFzdGVyOjkyZWMxMTgwOTU2NWNmNjQyOWM3
NTIwNGU5OWUwZjU4M2I1YzlkN2M6YmlzZWN0LXVzYgoKMjAxMy0xMS0xMC0yMTowODo0NSA5
MmVjMTE4MDk1NjVjZjY0MjljNzUyMDRlOTllMGY1ODNiNWM5ZDdjIGNvbXBpbGluZwoyNTAg
cmVhbCAgOTgzIHVzZXIgIDk0IHN5cyAgNDMwLjYwJSBjcHUgCWkzODYtcmFuZGNvbmZpZy1q
My0xMTEwMTMwOAoKMjAxMy0xMS0xMC0yMToxMzoxOSBkZXRlY3RpbmcgYm9vdCBzdGF0ZSAz
LjEyLjAtcmM0LTAwMTgwLWc5MmVjMTE4Li4JNQkxNS4uLi4uIFRFU1QgRkFJTFVSRQpbICAg
IDIuMDE4NTY1XSBFREQgaW5mb3JtYXRpb24gbm90IGF2YWlsYWJsZS4KWyAgICAyLjAxOTA5
N10gVW5yZWdpc3RlciBwdiBzaGFyZWQgbWVtb3J5IGZvciBjcHUgMApbICAgIDIuNjIwMjMz
XSB0c2M6IFJlZmluZWQgVFNDIGNsb2Nrc291cmNlIGNhbGlicmF0aW9uOiAyODkyLjk1MCBN
SHoKWyAgMjQxLjYzODEwMl0gSU5GTzogdGFzayBzd2FwcGVyLzA6MSBibG9ja2VkIGZvciBt
b3JlIHRoYW4gMTIwIHNlY29uZHMuClsgIDI0MS42MzkxNzBdICAgICAgIE5vdCB0YWludGVk
IDMuMTIuMC1yYzQtMDAxODAtZzkyZWMxMTggIzc3NApbICAyNDEuNjQwMDY2XSAiZWNobyAw
ID4gL3Byb2Mvc3lzL2tlcm5lbC9odW5nX3Rhc2tfdGltZW91dF9zZWNzIiBkaXNhYmxlcyB0
aGlzIG1lc3NhZ2UuClsgIDI0MS42NDEyNDldIHN3YXBwZXIvMCAgICAgICBEIGNkNDE3ODM4
ICA1NzI4ICAgICAxICAgICAgMCAweDAwMDAwMDAwClsgIDI0MS42NDIzMjNdICBjZDQyOWRj
MCAwMDAwMDA4MiBjMGU0MTc2OCBjZDQxNzgzOCAwMDAwOWY4MCBjZDQyOWRjYyBjMGMwMzM0
MCAwMDAwMDAwOApbICAyNDEuNjQzNzAwXSAgYzBiMTk5YTAgYzBjMDMzNDAgY2Q0MTc0NDAg
MDAwMDAwMDAgYzBlNDE3NjggMDAwMDAwMDQgMDAwMDAwMDAgMDAwMDlmODAKWyAgMjQxLjY0
NDY3MV0gIGMwZTZiMTEwIDAwMDAwMDAwIDI0MDI2MTQ1IDAwMDAwMDAwIGNkNDE3NDQwIGMw
MjhjNTE3IDAwMDAwMDAwIDAwMDAwMDAwClsgIDI0MS42NDU1MjddIENhbGwgVHJhY2U6Clsg
IDI0MS42NDU3NzFdICBbPGMwMjhjNTE3Pl0gPyBtYXJrX2hlbGRfbG9ja3MrMHg4Ny8weGYw
ClsgIDI0MS42NDYyODFdICBbPGMwODBmYTMwPl0gc2NoZWR1bGUrMHgxMC8weDIwClsgIDI0
MS42NDY2ODRdICBbPGMwODBjOGM1Pl0gc2NoZWR1bGVfdGltZW91dCsweDEyNS8weDE4MApb
ICAyNDEuNjQ3MjgyXSAgWzxjMDgxMTM5Mj5dID8gX3Jhd19zcGluX3VubG9ja19pcnErMHgy
Mi8weDUwClsgIDI0MS42NDc3OTddICBbPGMwODBmZjI0Pl0gPyB3YWl0X2Zvcl9jb21wbGV0
aW9uKzB4OTQvMHhkMApbICAyNDEuNjQ4MzI0XSAgWzxjMDI4Yzk2Yj5dID8gdHJhY2VfaGFy
ZGlycXNfb24rMHhiLzB4MTAKWyAgMjQxLjY0ODgwMl0gIFs8YzA4MGZmMmI+XSB3YWl0X2Zv
cl9jb21wbGV0aW9uKzB4OWIvMHhkMApbICAyNDEuNjQ5MzEyXSAgWzxjMDI2N2U5MD5dID8g
d2FrZV91cF9zdGF0ZSsweDEwLzB4MTAKWyAgMjQxLjY0OTc2OF0gIFs8YzAyYTEwZDA+XSA/
IF9fY2FsbF9yY3UuY29uc3Rwcm9wLjYxKzB4MjQwLzB4MjQwClsgIDI0MS42NTA2NzNdICBb
PGMwMjU4ZmZmPl0gd2FpdF9yY3VfZ3ArMHgzZi8weDYwClsgIDI0MS42NTEzOTldICBbPGMw
MjU4ZTcwPl0gPyByY3VfcGFuaWMrMHgyMC8weDIwClsgIDI0MS42NTIwOTNdICBbPGMwMmEz
MjRmPl0gc3luY2hyb25pemVfcmN1KzB4MWYvMHg0MApbICAyNDEuNjUyNzUxXSAgWzxjMDdm
NzI3OT5dIF9jcHVfZG93bisweDEyOS8weDJjMApbICAyNDEuNjUzNDY5XSAgWzxjMDdmNzQ4
Mj5dID8gY3B1X2Rvd24rMHgxMi8weDQwClsgIDI0MS42NTM5NDVdICBbPGMwMjI4NjlmPl0g
PyBjcHVfaG90cGx1Z19kcml2ZXJfbG9jaysweGYvMHgyMApbICAyNDEuNjU0NDkzXSAgWzxj
MDdmNzQ5ND5dIGNwdV9kb3duKzB4MjQvMHg0MApbICAyNDEuNjU0OTA2XSAgWzxjMDdmNjli
Zj5dIF9kZWJ1Z19ob3RwbHVnX2NwdSsweDZmLzB4YTAKWyAgMjQxLjY1NTQwN10gIFs8YzA0
Yjc2ZmU+XSA/IF9fcGxhdGZvcm1fZHJpdmVyX3JlZ2lzdGVyKzB4M2UvMHg0MApbICAyNDEu
NjU1OTg1XSAgWzxjMGJhOWQ3Nj5dID8gcGNpX2lvbW11X2FsbG9jKzB4NWEvMHg1YQpbICAy
NDEuNjU2NDcxXSAgWzxjMGJhOWQ4Mj5dIGRlYnVnX2hvdHBsdWdfY3B1KzB4Yy8weDEwClsg
IDI0MS42NTY5NDddICBbPGMwYmE1YjZjPl0gZG9fb25lX2luaXRjYWxsKzB4OGQvMHgxMmMK
WyAgMjQxLjY1NzQyOF0gIFs8YzAzNmFiZjc+XSA/IHN0cmxlbisweDE3LzB4MjAKWyAgMjQx
LjY1NzgzMV0gIFs8YzAyNTliMjM+XSA/IHBhcmFtZXErMHgxMy8weDcwClsgIDI0MS42NTgy
NzVdICBbPGMwYmE1NTEyPl0gPyByZXBhaXJfZW52X3N0cmluZysweDEyLzB4NTEKWyAgMjQx
LjY1ODc2M10gIFs8YzAyNTlkNGY+XSA/IHBhcnNlX2FyZ3MrMHgxY2YvMHgzMjAKWyAgMjQx
LjY1OTIzOV0gIFs8YzAyNTI4NWU+XSA/IF9fdXNlcm1vZGVoZWxwZXJfc2V0X2Rpc2FibGVf
ZGVwdGgrMHgzZS8weDUwClsgIDI0MS42NTk4NjJdICBbPGMwYmE1Y2Y2Pl0ga2VybmVsX2lu
aXRfZnJlZWFibGUrMHhlYi8weDE3ZApbICAyNDEuNjYwMzg3XSAgWzxjMGJhNTUwMD5dID8g
ZG9fZWFybHlfcGFyYW0rMHg3OC8weDc4ClsgIDI0MS42NjA4NTNdICBbPGMwN2Y2ODFiPl0g
a2VybmVsX2luaXQrMHhiLzB4MTQwClsgIDI0MS42NjEzMTFdICBbPGMwODEyNjM3Pl0gcmV0
X2Zyb21fa2VybmVsX3RocmVhZCsweDFiLzB4MjgKWyAgMjQxLjY2MTgyNF0gIFs8YzA3ZjY4
MTA+XSA/IHJlc3RfaW5pdCsweGMwLzB4YzAKWyAgMjQxLjY2MjI3MV0gMyBsb2NrcyBoZWxk
IGJ5IHN3YXBwZXIvMC8xOgpbICAyNDEuNjYyNjQxXSAgIzA6ICAoeDg2X2NwdV9ob3RwbHVn
X2RyaXZlcl9tdXRleCl7Ky4rLisufSwgYXQ6IFs8YzAyMjg2OWY+XSBjcHVfaG90cGx1Z19k
cml2ZXJfbG9jaysweGYvMHgyMApbICAyNDEuNjY0MDk4XSAgIzE6ICAoY3B1X2FkZF9yZW1v
dmVfbG9jayl7Ky4rLisufSwgYXQ6IFs8YzA3Zjc0ODI+XSBjcHVfZG93bisweDEyLzB4NDAK
WyAgMjQxLjY2NTM2N10gICMyOiAgKGNwdV9ob3RwbHVnLmxvY2speysuKy4rLn0sIGF0OiBb
PGMwMjQyMWNkPl0gY3B1X2hvdHBsdWdfYmVnaW4rMHgxZC8weDQwClsgIDI0MS42NjY2NDNd
IHNlbmRpbmcgTk1JIHRvIGFsbCBDUFVzOgpbICAyNDEuNjY3MjE4XSBOTUkgYmFja3RyYWNl
IGZvciBjcHUgMQpbICAyNDEuNjY3NzQ5XSBDUFU6IDEgUElEOiA0NiBDb21tOiBraHVuZ3Rh
c2tkIE5vdCB0YWludGVkIDMuMTIuMC1yYzQtMDAxODAtZzkyZWMxMTggIzc3NApbICAyNDEu
NjY4MTg0XSB0YXNrOiBjZjYzZTAwMCB0aTogY2Y2ODgwMDAgdGFzay50aTogY2Y2ODgwMDAK
WyAgMjQxLjY2ODE4NF0gRUlQOiAwMDYwOls8YzAyMmM1ZTU+XSBFRkxBR1M6IDAwMDEwMDQ2
IENQVTogMQpbICAyNDEuNjY4MTg0XSBFSVAgaXMgYXQgZGVmYXVsdF9zZW5kX0lQSV9tYXNr
X2xvZ2ljYWwrMHg4NS8weGYwClsgIDI0MS42NjgxODRdIEVBWDogMDAwMDBjMDAgRUJYOiAw
MzAwMDAwMCBFQ1g6IGZmZmZmMDAwIEVEWDogZmZmZmYwMDAKWyAgMjQxLjY2ODE4NF0gRVNJ
OiAwMDAwMDIwNiBFREk6IDAwMDAwMDAyIEVCUDogY2Y2ODllZDQgRVNQOiBjZjY4OWVjNApb
ICAyNDEuNjY4MTg0XSAgRFM6IDAwN2IgRVM6IDAwN2IgRlM6IDAwZDggR1M6IDAwZTAgU1M6
IDAwNjgKWyAgMjQxLjY2ODE4NF0gQ1IwOiA4MDA1MDAzYiBDUjI6IGZmZmZmZmZmIENSMzog
MDBjMGIwMDAgQ1I0OiAwMDAwMDZmMApbICAyNDEuNjY4MTg0XSBTdGFjazoKWyAgMjQxLjY2
ODE4NF0gIDAwMDAwODAwIDAwMDAyNzEwIDAwMDA3ZmZmIDAwMDAwM2ZmIGNmNjg5ZWUwIGMw
MjJjNzE4IDAwMDAyNzEwIGNmNjg5ZWYwClsgIDI0MS42NjgxODRdICBjMDIyYzkwZCBjMGE0
NzIxMiBjZDQxNzQ0MCBjZjY4OWYzMCBjMDI5ZjBmNiBjMGE1NWRhMCBjMGMxNWY2YyBjMGIw
NzY0NgpbICAyNDEuNjY4MTg0XSAgMDAwMDAwMDQgYzBiMDc2ODcgMDAwMDAwNzggMDAwMDAw
MDQgY2Q0MTc1MzggMDAwMDdmZmYgY2Q0MTc0NDAgY2Q0MTc1MzgKWyAgMjQxLjY2ODE4NF0g
Q2FsbCBUcmFjZToKWyAgMjQxLjY2ODE4NF0gIFs8YzAyMmM3MTg+XSBkZWZhdWx0X3NlbmRf
SVBJX2FsbCsweDU4LzB4NjAKWyAgMjQxLjY2ODE4NF0gIFs8YzAyMmM5MGQ+XSBhcmNoX3Ry
aWdnZXJfYWxsX2NwdV9iYWNrdHJhY2UrMHgzZC8weDcwClsgIDI0MS42NjgxODRdICBbPGMw
MjlmMGY2Pl0gd2F0Y2hkb2crMHgyZDYvMHgzMDAKWyAgMjQxLjY2ODE4NF0gIFs8YzAyOWVl
MjA+XSA/IGh1bmdfdGFza19wYW5pYysweDIwLzB4MjAKWyAgMjQxLjY2ODE4NF0gIFs8YzAy
NWI1MmE+XSBrdGhyZWFkKzB4OWEvMHhhMApbICAyNDEuNjY4MTg0XSAgWzxjMDI2MDAwMD5d
ID8gY2xlYW51cF9zcmN1X3N0cnVjdCsweDgwLzB4YjAKWyAgMjQxLjY2ODE4NF0gIFs8YzA4
MTI2Mzc+XSByZXRfZnJvbV9rZXJuZWxfdGhyZWFkKzB4MWIvMHgyOApbICAyNDEuNjY4MTg0
XSAgWzxjMDI1YjQ5MD5dID8gX19rdGhyZWFkX3BhcmttZSsweDYwLzB4NjAKWyAgMjQxLjY2
ODE4NF0gQ29kZTogMDAgYjMgZmYgZmYgZjYgYzQgMTAgNzUgZWQgYzEgZTMgMTggODkgOTkg
MTAgYjMgZmYgZmYgODkgZjggMDkgZDAgODAgY2UgMDQgODMgZmYgMDIgMGYgNDQgYzIgOGIg
MTUgNDQgMjEgYjEgYzAgODkgODIgMDAgYjMgZmYgZmYgPGY3PiBjNiAwMCAwMiAwMCAwMCA3
NCAxYiBlOCA2ZSAwMyAwNiAwMCA4OSBmMCA1MCA5ZCA4ZCA3NCAyNiAwMApbICAyNDEuNjY4
MDI5XSBOTUkgYmFja3RyYWNlIGZvciBjcHUgMApbICAyNDEuNjY4MDI5XSBDUFU6IDAgUElE
OiAwIENvbW06IHN3YXBwZXIvMCBOb3QgdGFpbnRlZCAzLjEyLjAtcmM0LTAwMTgwLWc5MmVj
MTE4ICM3NzQKWyAgMjQxLjY2ODAyOV0gdGFzazogYzBiMDc3ZTAgdGk6IGMwYjA0MDAwIHRh
c2sudGk6IGMwYjA0MDAwClsgIDI0MS42NjgwMjldIEVJUDogMDA2MDpbPGMwMjMwZWI1Pl0g
RUZMQUdTOiAwMDIwMDI4MiBDUFU6IDAKWyAgMjQxLjY2ODAyOV0gRUlQIGlzIGF0IG5hdGl2
ZV9zYWZlX2hhbHQrMHg1LzB4MTAKWyAgMjQxLjY2ODAyOV0gRUFYOiBjMGIwNzdlMCBFQlg6
IGMwYjA0MDAwIEVDWDogMDAwMDAwMDAgRURYOiAwMDAwMDAwMQpbICAyNDEuNjY4MDI5XSBF
U0k6IGMwYmEyNTY4IEVESTogZmZmZmZmZmYgRUJQOiBjMGIwNWY4MCBFU1A6IGMwYjA1Zjgw
ClsgIDI0MS42NjgwMjldICBEUzogMDA3YiBFUzogMDA3YiBGUzogMDBkOCBHUzogMDBlMCBT
UzogMDA2OApbICAyNDEuNjY4MDI5XSBDUjA6IDgwMDUwMDNiIENSMjogMDAwMDAwMDAgQ1Iz
OiAwMGMwYjAwMCBDUjQ6IDAwMDAwNmYwClsgIDI0MS42NjgwMjldIFN0YWNrOgpbICAyNDEu
NjY4MDI5XSAgYzBiMDVmODggYzAyMDk5Y2QgYzBiMDVmOTAgYzAyMGExNDYgYzBiMDVmYWMg
YzAyN2I3OWEgYzNmZWY0NjIgNTQwNDkxMWUKWyAgMjQxLjY2ODAyOV0gIDAwMDAwMDAyIDAw
MDIwODAwIGMwYzBjODAwIGMwYjA1ZmM4IGMwN2Y2ODAwIDAwMDAwMDAyIDAwMDAwMDAxIDAw
MDAwMDAwClsgIDI0MS42NjgwMjldICBjMDdmNjc1MCAwMDAwMDAwMCBjMGIwNWZlYyBjMGJh
NWFkOSAwMDAwMDMxNSBmZmZmZmZmZiBmZmZmZmZmZiBjMGJhNTU1MQpbICAyNDEuNjY4MDI5
XSBDYWxsIFRyYWNlOgpbICAyNDEuNjY4MDI5XSAgWzxjMDIwOTljZD5dIGRlZmF1bHRfaWRs
ZSsweGQvMHgxMApbICAyNDEuNjY4MDI5XSAgWzxjMDIwYTE0Nj5dIGFyY2hfY3B1X2lkbGUr
MHgyNi8weDMwClsgIDI0MS42NjgwMjldICBbPGMwMjdiNzlhPl0gY3B1X3N0YXJ0dXBfZW50
cnkrMHgxM2EvMHgxYzAKWyAgMjQxLjY2ODAyOV0gIFs8YzA3ZjY4MDA+XSByZXN0X2luaXQr
MHhiMC8weGMwClsgIDI0MS42NjgwMjldICBbPGMwN2Y2NzUwPl0gPyBfX3JlYWRfbG9ja19m
YWlsZWQrMHgxYy8weDFjClsgIDI0MS42NjgwMjldICBbPGMwYmE1YWQ5Pl0gc3RhcnRfa2Vy
bmVsKzB4M2JmLzB4M2M1ClsgIDI0MS42NjgwMjldICBbPGMwYmE1NTUxPl0gPyByZXBhaXJf
ZW52X3N0cmluZysweDUxLzB4NTEKWyAgMjQxLjY2ODAyOV0gIFs8YzBiYTUzNzg+XSBpMzg2
X3N0YXJ0X2tlcm5lbCsweDEyZS8weDEzMQpbICAyNDEuNjY4MDI5XSBDb2RlOiBiYyAyNyAw
MCAwMCAwMCAwMCA1NSA4OSBlNSBmYSA1ZCBjMyA4ZCA3NiAwMCA4ZCBiYyAyNyAwMCAwMCAw
MCAwMCA1NSA4OSBlNSBmYiA1ZCBjMyA4ZCA3NiAwMCA4ZCBiYyAyNyAwMCAwMCAwMCAwMCA1
NSA4OSBlNSBmYiBmNCA8NWQ+IGMzIDg5IGY2IDhkIGJjIDI3IDAwIDAwIDAwIDAwIDU1IDg5
IGU1IGY0IDVkIGMzIDhkIDc2IDAwIDhkCi9rZXJuZWwvaTM4Ni1yYW5kY29uZmlnLWozLTEx
MTAxMzA4LzkyZWMxMTgwOTU2NWNmNjQyOWM3NTIwNGU5OWUwZjU4M2I1YzlkN2MvZG1lc2ct
cXVhbnRhbC1jYWlyby0yNToyMDEzMTExMDIxMTcyODppMzg2LXJhbmRjb25maWctajMtMTEx
MDEzMDg6My4xMi4wLXJjNC0wMDE4MC1nOTJlYzExODo3NzQKL2tlcm5lbC9pMzg2LXJhbmRj
b25maWctajMtMTExMDEzMDgvOTJlYzExODA5NTY1Y2Y2NDI5Yzc1MjA0ZTk5ZTBmNTgzYjVj
OWQ3Yy9kbWVzZy1xdWFudGFsLXJvYW0tMzA6MjAxMzExMTAyMTE3Mjg6aTM4Ni1yYW5kY29u
ZmlnLWozLTExMTAxMzA4OjMuMTIuMC1yYzQtMDAxODAtZzkyZWMxMTg6Nzc0Ci9rZXJuZWwv
aTM4Ni1yYW5kY29uZmlnLWozLTExMTAxMzA4LzkyZWMxMTgwOTU2NWNmNjQyOWM3NTIwNGU5
OWUwZjU4M2I1YzlkN2MvZG1lc2ctcXVhbnRhbC14aWFuLTQzOjIwMTMxMTEwMjExNzI3Omkz
ODYtcmFuZGNvbmZpZy1qMy0xMTEwMTMwODozLjEyLjAtcmM0LTAwMTgwLWc5MmVjMTE4Ojc3
NAova2VybmVsL2kzODYtcmFuZGNvbmZpZy1qMy0xMTEwMTMwOC85MmVjMTE4MDk1NjVjZjY0
MjljNzUyMDRlOTllMGY1ODNiNWM5ZDdjL2RtZXNnLXlvY3RvLXJvYW0tMTU6MjAxMzExMTAy
MTE3Mjg6aTM4Ni1yYW5kY29uZmlnLWozLTExMTAxMzA4OjMuMTIuMC1yYzQtMDAxODAtZzky
ZWMxMTg6Nzc0Ci9rZXJuZWwvaTM4Ni1yYW5kY29uZmlnLWozLTExMTAxMzA4LzkyZWMxMTgw
OTU2NWNmNjQyOWM3NTIwNGU5OWUwZjU4M2I1YzlkN2MvZG1lc2ctcXVhbnRhbC1pbm4tMjA6
MjAxMzExMTAyMTE3Mjk6aTM4Ni1yYW5kY29uZmlnLWozLTExMTAxMzA4OjMuMTIuMC1yYzQt
MDAxODAtZzkyZWMxMTg6Nzc0Ci9rZXJuZWwvaTM4Ni1yYW5kY29uZmlnLWozLTExMTAxMzA4
LzkyZWMxMTgwOTU2NWNmNjQyOWM3NTIwNGU5OWUwZjU4M2I1YzlkN2MvZG1lc2cteW9jdG8t
YXRoZW5zLTE6MjAxMzExMTAyMTE3Mjk6aTM4Ni1yYW5kY29uZmlnLWozLTExMTAxMzA4OjMu
MTIuMC1yYzQtMDAxODAtZzkyZWMxMTg6Nzc0Ci9rZXJuZWwvaTM4Ni1yYW5kY29uZmlnLWoz
LTExMTAxMzA4LzkyZWMxMTgwOTU2NWNmNjQyOWM3NTIwNGU5OWUwZjU4M2I1YzlkN2MvZG1l
c2ctcXVhbnRhbC14aWFuLTQ6MjAxMzExMTAyMTE3MzE6aTM4Ni1yYW5kY29uZmlnLWozLTEx
MTAxMzA4OjMuMTIuMC1yYzQtMDAxODAtZzkyZWMxMTg6Nzc0Ci9rZXJuZWwvaTM4Ni1yYW5k
Y29uZmlnLWozLTExMTAxMzA4LzkyZWMxMTgwOTU2NWNmNjQyOWM3NTIwNGU5OWUwZjU4M2I1
YzlkN2MvZG1lc2cteW9jdG8td2FpbWVhLTc6MjAxMzExMTEwNTEzMzY6aTM4Ni1yYW5kY29u
ZmlnLWozLTExMTAxMzA4OjMuMTIuMC1yYzQtMDAxODAtZzkyZWMxMTg6Nzc0Ci9rZXJuZWwv
aTM4Ni1yYW5kY29uZmlnLWozLTExMTAxMzA4LzkyZWMxMTgwOTU2NWNmNjQyOWM3NTIwNGU5
OWUwZjU4M2I1YzlkN2MvZG1lc2ctcXVhbnRhbC1hdGhlbnMtMzQ6MjAxMzExMTAyMTE3Mzg6
aTM4Ni1yYW5kY29uZmlnLWozLTExMTAxMzA4OjMuMTIuMC1yYzQtMDAxODAtZzkyZWMxMTg6
Nzc0Ci9rZXJuZWwvaTM4Ni1yYW5kY29uZmlnLWozLTExMTAxMzA4LzkyZWMxMTgwOTU2NWNm
NjQyOWM3NTIwNGU5OWUwZjU4M2I1YzlkN2MvZG1lc2ctcXVhbnRhbC1jYWlyby0yNjoyMDEz
MTExMDIxMTczNzppMzg2LXJhbmRjb25maWctajMtMTExMDEzMDg6My4xMi4wLXJjNC0wMDE4
MC1nOTJlYzExODo3NzQKL2tlcm5lbC9pMzg2LXJhbmRjb25maWctajMtMTExMDEzMDgvOTJl
YzExODA5NTY1Y2Y2NDI5Yzc1MjA0ZTk5ZTBmNTgzYjVjOWQ3Yy9kbWVzZy1xdWFudGFsLWlu
bi0xMzoyMDEzMTExMDIxMTczOTppMzg2LXJhbmRjb25maWctajMtMTExMDEzMDg6My4xMi4w
LXJjNC0wMDE4MC1nOTJlYzExODo3NzQKL2tlcm5lbC9pMzg2LXJhbmRjb25maWctajMtMTEx
MDEzMDgvOTJlYzExODA5NTY1Y2Y2NDI5Yzc1MjA0ZTk5ZTBmNTgzYjVjOWQ3Yy9kbWVzZy1x
dWFudGFsLWlubi0xNToyMDEzMTExMDIxMTczNzppMzg2LXJhbmRjb25maWctajMtMTExMDEz
MDg6My4xMi4wLXJjNC0wMDE4MC1nOTJlYzExODo3NzQKL2tlcm5lbC9pMzg2LXJhbmRjb25m
aWctajMtMTExMDEzMDgvOTJlYzExODA5NTY1Y2Y2NDI5Yzc1MjA0ZTk5ZTBmNTgzYjVjOWQ3
Yy9kbWVzZy1xdWFudGFsLWxrcC10dDAyLTE1OjIwMTMxMTEwMTIwODU4OmkzODYtcmFuZGNv
bmZpZy1qMy0xMTEwMTMwODozLjEyLjAtcmM0LTAwMTgwLWc5MmVjMTE4Ojc3NAova2VybmVs
L2kzODYtcmFuZGNvbmZpZy1qMy0xMTEwMTMwOC85MmVjMTE4MDk1NjVjZjY0MjljNzUyMDRl
OTllMGY1ODNiNWM5ZDdjL2RtZXNnLXF1YW50YWwtd2FpbWVhLTk6MjAxMzExMTEwNTEzNDA6
aTM4Ni1yYW5kY29uZmlnLWozLTExMTAxMzA4OjMuMTIuMC1yYzQtMDAxODAtZzkyZWMxMTg6
Nzc0Ci9rZXJuZWwvaTM4Ni1yYW5kY29uZmlnLWozLTExMTAxMzA4LzkyZWMxMTgwOTU2NWNm
NjQyOWM3NTIwNGU5OWUwZjU4M2I1YzlkN2MvZG1lc2cteW9jdG8tY2Fpcm8tMjk6MjAxMzEx
MTAyMTE3Mzg6aTM4Ni1yYW5kY29uZmlnLWozLTExMTAxMzA4OjMuMTIuMC1yYzQtMDAxODAt
ZzkyZWMxMTg6Nzc0Ci9rZXJuZWwvaTM4Ni1yYW5kY29uZmlnLWozLTExMTAxMzA4LzkyZWMx
MTgwOTU2NWNmNjQyOWM3NTIwNGU5OWUwZjU4M2I1YzlkN2MvZG1lc2cteW9jdG8tY2Fpcm8t
NjoyMDEzMTExMDIxMTczOTppMzg2LXJhbmRjb25maWctajMtMTExMDEzMDg6My4xMi4wLXJj
NC0wMDE4MC1nOTJlYzExODo3NzQKL2tlcm5lbC9pMzg2LXJhbmRjb25maWctajMtMTExMDEz
MDgvOTJlYzExODA5NTY1Y2Y2NDI5Yzc1MjA0ZTk5ZTBmNTgzYjVjOWQ3Yy9kbWVzZy15b2N0
by1jYWlyby05OjIwMTMxMTEwMjExNzM2OmkzODYtcmFuZGNvbmZpZy1qMy0xMTEwMTMwODoz
LjEyLjAtcmM0LTAwMTgwLWc5MmVjMTE4Ojc3NAova2VybmVsL2kzODYtcmFuZGNvbmZpZy1q
My0xMTEwMTMwOC85MmVjMTE4MDk1NjVjZjY0MjljNzUyMDRlOTllMGY1ODNiNWM5ZDdjL2Rt
ZXNnLXlvY3RvLWxrcC1zdDAxLTU6MjAxMzExMTEwNTEyMTU6aTM4Ni1yYW5kY29uZmlnLWoz
LTExMTAxMzA4OjMuMTIuMC1yYzQtMDAxODAtZzkyZWMxMTg6Nzc0Ci9rZXJuZWwvaTM4Ni1y
YW5kY29uZmlnLWozLTExMTAxMzA4LzkyZWMxMTgwOTU2NWNmNjQyOWM3NTIwNGU5OWUwZjU4
M2I1YzlkN2MvZG1lc2cteW9jdG8tbGtwLXR0MDItNjoyMDEzMTExMDEyMDkwNDppMzg2LXJh
bmRjb25maWctajMtMTExMDEzMDg6My4xMi4wLXJjNC0wMDE4MC1nOTJlYzExODo3NzQKL2tl
cm5lbC9pMzg2LXJhbmRjb25maWctajMtMTExMDEzMDgvOTJlYzExODA5NTY1Y2Y2NDI5Yzc1
MjA0ZTk5ZTBmNTgzYjVjOWQ3Yy9kbWVzZy15b2N0by1sa3AtdHQwMi05OjIwMTMxMTEwMTIw
OTA0OmkzODYtcmFuZGNvbmZpZy1qMy0xMTEwMTMwODozLjEyLjAtcmM0LTAwMTgwLWc5MmVj
MTE4Ojc3NAova2VybmVsL2kzODYtcmFuZGNvbmZpZy1qMy0xMTEwMTMwOC85MmVjMTE4MDk1
NjVjZjY0MjljNzUyMDRlOTllMGY1ODNiNWM5ZDdjL2RtZXNnLXlvY3RvLXJvYW0tNDU6MjAx
MzExMTAyMTE3MzI6aTM4Ni1yYW5kY29uZmlnLWozLTExMTAxMzA4OjMuMTIuMC1yYzQtMDAx
ODAtZzkyZWMxMTg6Nzc0Ci9rZXJuZWwvaTM4Ni1yYW5kY29uZmlnLWozLTExMTAxMzA4Lzky
ZWMxMTgwOTU2NWNmNjQyOWM3NTIwNGU5OWUwZjU4M2I1YzlkN2MvZG1lc2cteW9jdG8teGlh
bi0yNjoyMDEzMTExMDIxMTczNzppMzg2LXJhbmRjb25maWctajMtMTExMDEzMDg6My4xMi4w
LXJjNC0wMDE4MC1nOTJlYzExODo3NzQKMTU6MjI6MjIgYWxsX2dvb2Q6YmFkOmFsbF9iYWQg
Ym9vdHMKCkJpc2VjdGluZzogNSByZXZpc2lvbnMgbGVmdCB0byB0ZXN0IGFmdGVyIHRoaXMg
KHJvdWdobHkgMyBzdGVwcykKW2VkMWI3NzMyODY4MDM1OTkwZjA3YWViNTMyYjFkODYyNzJl
YTkwOWVdIHNjaGVkL2ZhaXI6IEZpeCB0cml2aWFsIHR5cG9zIGluIGNvbW1lbnRzCnJ1bm5p
bmcgL2Mva2VybmVsLXRlc3RzL2Jpc2VjdC10ZXN0LWJvb3QtZmFpbHVyZS5zaCAvaG9tZS93
ZmcvdXNiL29iai1iaXNlY3QKbHMgLWEgL2tlcm5lbC10ZXN0cy9ydW4tcXVldWUva3ZtL2kz
ODYtcmFuZGNvbmZpZy1qMy0xMTEwMTMwOC9uZXh0Om1hc3RlcjplZDFiNzczMjg2ODAzNTk5
MGYwN2FlYjUzMmIxZDg2MjcyZWE5MDllOmJpc2VjdC11c2IKCjIwMTMtMTEtMTAtMjE6MTc6
NTMgZWQxYjc3MzI4NjgwMzU5OTBmMDdhZWI1MzJiMWQ4NjI3MmVhOTA5ZSBjb21waWxpbmcK
Njk0IHJlYWwgIDk3MyB1c2VyICA5MSBzeXMgIDE1My4yNSUgY3B1IAlpMzg2LXJhbmRjb25m
aWctajMtMTExMDEzMDgKCjIwMTMtMTEtMTAtMjE6MzA6MDEgZGV0ZWN0aW5nIGJvb3Qgc3Rh
dGUgMy4xMi4wLXJjNC0wMDE3NC1nZWQxYjc3My4uCTI3CTM1Li4JMzcgU1VDQ0VTUwoKQmlz
ZWN0aW5nOiAyIHJldmlzaW9ucyBsZWZ0IHRvIHRlc3QgYWZ0ZXIgdGhpcyAocm91Z2hseSAy
IHN0ZXBzKQpbNmFjY2UzZWY4NDUyMDUzN2Y4YTA5YTEyYzlkZGJlODE0YTU4NGRkMl0gc2No
ZWQ6IFJlbW92ZSBnZXRfb25saW5lX2NwdXMoKSB1c2FnZQpydW5uaW5nIC9jL2tlcm5lbC10
ZXN0cy9iaXNlY3QtdGVzdC1ib290LWZhaWx1cmUuc2ggL2hvbWUvd2ZnL3VzYi9vYmotYmlz
ZWN0CmxzIC1hIC9rZXJuZWwtdGVzdHMvcnVuLXF1ZXVlL2t2bS9pMzg2LXJhbmRjb25maWct
ajMtMTExMDEzMDgvbmV4dDptYXN0ZXI6NmFjY2UzZWY4NDUyMDUzN2Y4YTA5YTEyYzlkZGJl
ODE0YTU4NGRkMjpiaXNlY3QtdXNiCgoyMDEzLTExLTEwLTIxOjMzOjM1IDZhY2NlM2VmODQ1
MjA1MzdmOGEwOWExMmM5ZGRiZTgxNGE1ODRkZDIgY29tcGlsaW5nCjg5IHJlYWwgIDM2IHVz
ZXIgIDkgc3lzICA1MS41MSUgY3B1IAlpMzg2LXJhbmRjb25maWctajMtMTExMDEzMDgKCjIw
MTMtMTEtMTAtMjE6MzY6MTIgZGV0ZWN0aW5nIGJvb3Qgc3RhdGUgMy4xMi4wLXJjNC0wMDE3
Ny1nNmFjY2UzZS4uCTEzCTIxCTIyCTI0Li4uIFRFU1QgRkFJTFVSRQpbICAgIDIuMDIyMTc5
XSBFREQgaW5mb3JtYXRpb24gbm90IGF2YWlsYWJsZS4KWyAgICAyLjAyMjY5MF0gVW5yZWdp
c3RlciBwdiBzaGFyZWQgbWVtb3J5IGZvciBjcHUgMApbICAgIDIuNjI1MjUxXSB0c2M6IFJl
ZmluZWQgVFNDIGNsb2Nrc291cmNlIGNhbGlicmF0aW9uOiAyODkyLjk5MSBNSHoKWyAgMjQx
LjY0MTEyOF0gSU5GTzogdGFzayBzd2FwcGVyLzA6MSBibG9ja2VkIGZvciBtb3JlIHRoYW4g
MTIwIHNlY29uZHMuClsgIDI0MS42NDI2MTFdICAgICAgIE5vdCB0YWludGVkIDMuMTIuMC1y
YzQtMDAxNzctZzZhY2NlM2UgIzc3NgpbICAyNDEuNjQzODM0XSAiZWNobyAwID4gL3Byb2Mv
c3lzL2tlcm5lbC9odW5nX3Rhc2tfdGltZW91dF9zZWNzIiBkaXNhYmxlcyB0aGlzIG1lc3Nh
Z2UuClsgIDI0MS42NDU1MDhdIHN3YXBwZXIvMCAgICAgICBEIGNkNDE3ODM4ICA1ODQwICAg
ICAxICAgICAgMCAweDAwMDAwMDAwClsgIDI0MS42NDcwOTZdICBjZDQyOWRjMCAwMDAwMDA4
MiBjMGU0MTc2OCBjZDQxNzgzOCAwMDAwOWY4MCBjZDQyOWRjYyBjMGMwMzM0MCAwMDAwMDAw
OApbICAyNDEuNjQ5MDU0XSAgYzBiMTk5YTAgYzBjMDMzNDAgY2Q0MTc0NDAgMDAwMDAwMDAg
YzBlNDE3NjggMDAwMDAwMDQgMDAwMDAwMDAgMDAwMDlmODAKWyAgMjQxLjY1MDk1NF0gIGMw
ZTZiMTEwIDAwMDAwMDAwIDI0MDI2MTQ1IDAwMDAwMDAwIGNkNDE3NDQwIGMwMjhjNTU3IDAw
MDAwMDAwIDAwMDAwMDAwClsgIDI0MS42NTI4NzhdIENhbGwgVHJhY2U6ClsgIDI0MS42NTM0
NDJdICBbPGMwMjhjNTU3Pl0gPyBtYXJrX2hlbGRfbG9ja3MrMHg4Ny8weGYwClsgIDI0MS42
NTQ1NTJdICBbPGMwODEwNTYwPl0gc2NoZWR1bGUrMHgxMC8weDIwClsgIDI0MS42NTU0ODdd
ICBbPGMwODBkM2Y1Pl0gc2NoZWR1bGVfdGltZW91dCsweDEyNS8weDE4MApbICAyNDEuNjU2
NjA4XSAgWzxjMDgxMWVjMj5dID8gX3Jhd19zcGluX3VubG9ja19pcnErMHgyMi8weDUwClsg
IDI0MS42NTc2NjddICBbPGMwODEwYTU0Pl0gPyB3YWl0X2Zvcl9jb21wbGV0aW9uKzB4OTQv
MHhkMApbICAyNDEuNjU4MTgxXSAgWzxjMDI4YzlhYj5dID8gdHJhY2VfaGFyZGlycXNfb24r
MHhiLzB4MTAKWyAgMjQxLjY1ODY2NV0gIFs8YzA4MTBhNWI+XSB3YWl0X2Zvcl9jb21wbGV0
aW9uKzB4OWIvMHhkMApbICAyNDEuNjU5MTY2XSAgWzxjMDI2N2UzMD5dID8gd2FrZV91cF9z
dGF0ZSsweDEwLzB4MTAKWyAgMjQxLjY1OTYyOV0gIFs8YzAyYTExMTA+XSA/IF9fY2FsbF9y
Y3UuY29uc3Rwcm9wLjYxKzB4MjQwLzB4MjQwClsgIDI0MS42NjAxODhdICBbPGMwMjU5MDRm
Pl0gd2FpdF9yY3VfZ3ArMHgzZi8weDYwClsgIDI0MS42NjA2MjBdICBbPGMwMjU4ZWMwPl0g
PyByY3VfcGFuaWMrMHgyMC8weDIwClsgIDI0MS42NjEwNTJdICBbPGMwMmEzMmJmPl0gc3lu
Y2hyb25pemVfcmN1KzB4MWYvMHg0MApbICAyNDEuNjYxNTIwXSAgWzxjMDdmN2RhOT5dIF9j
cHVfZG93bisweDEyOS8weDJjMApbICAyNDEuNjYxOTQyXSAgWzxjMDdmN2ZiMj5dID8gY3B1
X2Rvd24rMHgxMi8weDQwClsgIDI0MS42NjIzNzNdICBbPGMwMjI4NmRmPl0gPyBjcHVfaG90
cGx1Z19kcml2ZXJfbG9jaysweGYvMHgyMApbICAyNDEuNjYyOTA1XSAgWzxjMDdmN2ZjND5d
IGNwdV9kb3duKzB4MjQvMHg0MApbICAyNDEuNjYzMzE3XSAgWzxjMDdmNzRlZj5dIF9kZWJ1
Z19ob3RwbHVnX2NwdSsweDZmLzB4YTAKWyAgMjQxLjY2MzgwMl0gIFs8YzA0YjdhN2U+XSA/
IF9fcGxhdGZvcm1fZHJpdmVyX3JlZ2lzdGVyKzB4M2UvMHg0MApbICAyNDEuNjY0Mzc0XSAg
WzxjMGJhOWQ3Nj5dID8gcGNpX2lvbW11X2FsbG9jKzB4NWEvMHg1YQpbICAyNDEuNjY0ODcx
XSAgWzxjMGJhOWQ4Mj5dIGRlYnVnX2hvdHBsdWdfY3B1KzB4Yy8weDEwClsgIDI0MS42NjUz
NDldICBbPGMwYmE1YjZjPl0gZG9fb25lX2luaXRjYWxsKzB4OGQvMHgxMmMKWyAgMjQxLjY2
NTgxOV0gIFs8YzAzNmFkMGY+XSA/IHN0cmxlbisweGYvMHgyMApbICAyNDEuNjY2MjIxXSAg
WzxjMDI1OWI3Mz5dID8gcGFyYW1lcSsweDEzLzB4NzAKWyAgMjQxLjY2NjYzNl0gIFs8YzBi
YTU1MTI+XSA/IHJlcGFpcl9lbnZfc3RyaW5nKzB4MTIvMHg1MQpbICAyNDEuNjY3MTMyXSAg
WzxjMDI1OWQ5Zj5dID8gcGFyc2VfYXJncysweDFjZi8weDMyMApbICAyNDEuNjY3NTk0XSAg
WzxjMDI1Mjg5ZT5dID8gX191c2VybW9kZWhlbHBlcl9zZXRfZGlzYWJsZV9kZXB0aCsweDNl
LzB4NTAKWyAgMjQxLjY2ODIyM10gIFs8YzBiYTVjZjY+XSBrZXJuZWxfaW5pdF9mcmVlYWJs
ZSsweGViLzB4MTdkClsgIDI0MS42Njg3MzJdICBbPGMwYmE1NTAwPl0gPyBkb19lYXJseV9w
YXJhbSsweDc4LzB4NzgKWyAgMjQxLjY2OTIwNV0gIFs8YzA3ZjczNGI+XSBrZXJuZWxfaW5p
dCsweGIvMHgxNDAKWyAgMjQxLjY2OTYzNl0gIFs8YzA4MTMxNzc+XSByZXRfZnJvbV9rZXJu
ZWxfdGhyZWFkKzB4MWIvMHgyOApbICAyNDEuNjcwMTU2XSAgWzxjMDdmNzM0MD5dID8gcmVz
dF9pbml0KzB4YzAvMHhjMApbICAyNDEuNjcwNTg0XSAzIGxvY2tzIGhlbGQgYnkgc3dhcHBl
ci8wLzE6ClsgIDI0MS42NzA5NTBdICAjMDogICh4ODZfY3B1X2hvdHBsdWdfZHJpdmVyX211
dGV4KXsrLisuKy59LCBhdDogWzxjMDIyODZkZj5dIGNwdV9ob3RwbHVnX2RyaXZlcl9sb2Nr
KzB4Zi8weDIwClsgIDI0MS42NzE5MzBdICAjMTogIChjcHVfYWRkX3JlbW92ZV9sb2NrKXsr
LisuKy59LCBhdDogWzxjMDdmN2ZiMj5dIGNwdV9kb3duKzB4MTIvMHg0MApbICAyNDEuNjcy
NzI2XSAgIzI6ICAoY3B1X2hvdHBsdWcubG9jayl7Ky4rLisufSwgYXQ6IFs8YzAyNDIyMGQ+
XSBjcHVfaG90cGx1Z19iZWdpbisweDFkLzB4NDAKWyAgMjQxLjY3MzU2N10gc2VuZGluZyBO
TUkgdG8gYWxsIENQVXM6ClsgIDI0MS42NzM5MTRdIE5NSSBiYWNrdHJhY2UgZm9yIGNwdSAx
ClsgIDI0MS42NzQwNjZdIENQVTogMSBQSUQ6IDQ2IENvbW06IGtodW5ndGFza2QgTm90IHRh
aW50ZWQgMy4xMi4wLXJjNC0wMDE3Ny1nNmFjY2UzZSAjNzc2ClsgIDI0MS42NzQwNjZdIHRh
c2s6IGNmNjQ4MDAwIHRpOiBjZjY4YTAwMCB0YXNrLnRpOiBjZjY4YTAwMApbICAyNDEuNjc0
MDY2XSBFSVA6IDAwNjA6WzxjMDIyYzYyNT5dIEVGTEFHUzogMDAwMTAwNDYgQ1BVOiAxClsg
IDI0MS42NzQwNjZdIEVJUCBpcyBhdCBkZWZhdWx0X3NlbmRfSVBJX21hc2tfbG9naWNhbCsw
eDg1LzB4ZjAKWyAgMjQxLjY3NDA2Nl0gRUFYOiAwMDAwMGMwMCBFQlg6IDAzMDAwMDAwIEVD
WDogZmZmZmYwMDAgRURYOiBmZmZmZjAwMApbICAyNDEuNjc0MDY2XSBFU0k6IDAwMDAwMjA2
IEVESTogMDAwMDAwMDIgRUJQOiBjZjY4YmVkNCBFU1A6IGNmNjhiZWM0ClsgIDI0MS42NzQw
NjZdICBEUzogMDA3YiBFUzogMDA3YiBGUzogMDBkOCBHUzogMDBlMCBTUzogMDA2OApbICAy
NDEuNjc0MDY2XSBDUjA6IDgwMDUwMDNiIENSMjogZmZmZmZmZmYgQ1IzOiAwMGMwYjAwMCBD
UjQ6IDAwMDAwNmYwClsgIDI0MS42NzQwNjZdIFN0YWNrOgpbICAyNDEuNjc0MDY2XSAgMDAw
MDA4MDAgMDAwMDI3MTAgMDAwMDdmZmYgMDAwMDAzZmYgY2Y2OGJlZTAgYzAyMmM3NTggMDAw
MDI3MTAgY2Y2OGJlZjAKWyAgMjQxLjY3NDA2Nl0gIGMwMjJjOTRkIGMwYTQ3MjI2IGNkNDE3
NDQwIGNmNjhiZjMwIGMwMjlmMTM2IGMwYTU1ZGI0IGMwYzE1ZjZjIGMwYjA3NjQ2ClsgIDI0
MS42NzQwNjZdICAwMDAwMDAwNCBjMGIwNzY4NyAwMDAwMDA3OCAwMDAwMDAwNCBjZDQxNzUz
OCAwMDAwN2ZmZiBjZDQxNzQ0MCBjZDQxNzUzOApbICAyNDEuNjc0MDY2XSBDYWxsIFRyYWNl
OgpbICAyNDEuNjc0MDY2XSAgWzxjMDIyYzc1OD5dIGRlZmF1bHRfc2VuZF9JUElfYWxsKzB4
NTgvMHg2MApbICAyNDEuNjc0MDY2XSAgWzxjMDIyYzk0ZD5dIGFyY2hfdHJpZ2dlcl9hbGxf
Y3B1X2JhY2t0cmFjZSsweDNkLzB4NzAKWyAgMjQxLjY3NDA2Nl0gIFs8YzAyOWYxMzY+XSB3
YXRjaGRvZysweDJkNi8weDMwMApbICAyNDEuNjc0MDY2XSAgWzxjMDI5ZWU2MD5dID8gaHVu
Z190YXNrX3BhbmljKzB4MjAvMHgyMApbICAyNDEuNjc0MDY2XSAgWzxjMDI1YjU3YT5dIGt0
aHJlYWQrMHg5YS8weGEwClsgIDI0MS42NzQwNjZdICBbPGMwMjYwMDAwPl0gPyBfX3NyY3Vf
cmVhZF9sb2NrKzB4NDAvMHg3MApbICAyNDEuNjc0MDY2XSAgWzxjMDgxMzE3Nz5dIHJldF9m
cm9tX2tlcm5lbF90aHJlYWQrMHgxYi8weDI4ClsgIDI0MS42NzQwNjZdICBbPGMwMjViNGUw
Pl0gPyBfX2t0aHJlYWRfcGFya21lKzB4NjAvMHg2MApbICAyNDEuNjc0MDY2XSBDb2RlOiAw
MCBiMyBmZiBmZiBmNiBjNCAxMCA3NSBlZCBjMSBlMyAxOCA4OSA5OSAxMCBiMyBmZiBmZiA4
OSBmOCAwOSBkMCA4MCBjZSAwNCA4MyBmZiAwMiAwZiA0NCBjMiA4YiAxNSA0NCAyMSBiMSBj
MCA4OSA4MiAwMCBiMyBmZiBmZiA8Zjc+IGM2IDAwIDAyIDAwIDAwIDc0IDFiIGU4IDZlIDAz
IDA2IDAwIDg5IGYwIDUwIDlkIDhkIDc0IDI2IDAwClsgIDI0MS42NzQwMTZdIE5NSSBiYWNr
dHJhY2UgZm9yIGNwdSAwClsgIDI0MS42NzQwMTZdIENQVTogMCBQSUQ6IDAgQ29tbTogc3dh
cHBlci8wIE5vdCB0YWludGVkIDMuMTIuMC1yYzQtMDAxNzctZzZhY2NlM2UgIzc3NgpbICAy
NDEuNjc0MDE2XSB0YXNrOiBjMGIwNzdlMCB0aTogYzBiMDQwMDAgdGFzay50aTogYzBiMDQw
MDAKWyAgMjQxLjY3NDAxNl0gRUlQOiAwMDYwOls8YzAyMzBlZjU+XSBFRkxBR1M6IDAwMjAw
MjgyIENQVTogMApbICAyNDEuNjc0MDE2XSBFSVAgaXMgYXQgbmF0aXZlX3NhZmVfaGFsdCsw
eDUvMHgxMApbICAyNDEuNjc0MDE2XSBFQVg6IGMwYjA3N2UwIEVCWDogYzBiMDQwMDAgRUNY
OiAwMDAwMDAwMCBFRFg6IDAwMDAwMDAxClsgIDI0MS42NzQwMTZdIEVTSTogYzBiYTI1Njgg
RURJOiBmZmZmZmZmZiBFQlA6IGMwYjA1ZjgwIEVTUDogYzBiMDVmODAKWyAgMjQxLjY3NDAx
Nl0gIERTOiAwMDdiIEVTOiAwMDdiIEZTOiAwMGQ4IEdTOiAwMGUwIFNTOiAwMDY4ClsgIDI0
MS42NzQwMTZdIENSMDogODAwNTAwM2IgQ1IyOiAwMDAwMDAwMCBDUjM6IDAwYzBiMDAwIENS
NDogMDAwMDA2ZjAKWyAgMjQxLjY3NDAxNl0gU3RhY2s6ClsgIDI0MS42NzQwMTZdICBjMGIw
NWY4OCBjMDIwOTljZCBjMGIwNWY5MCBjMDIwYTE0NiBjMGIwNWZhYyBjMDI3YjdiYSBlNWY0
ZmZmOSBkYzE3YjBmYgpbICAyNDEuNjc0MDE2XSAgMDAwMDAwMDIgMDAwMjA4MDAgYzBjMGM4
MDAgYzBiMDVmYzggYzA3ZjczMzAgMDAwMDAwMDIgMDAwMDAwMDEgMDAwMDAwMDAKWyAgMjQx
LjY3NDAxNl0gIGMwN2Y3MjgwIDAwMDAwMDAwIGMwYjA1ZmVjIGMwYmE1YWQ5IDAwMDAwMzE1
IGZmZmZmZmZmIGZmZmZmZmZmIGMwYmE1NTUxClsgIDI0MS42NzQwMTZdIENhbGwgVHJhY2U6
ClsgIDI0MS42NzQwMTZdICBbPGMwMjA5OWNkPl0gZGVmYXVsdF9pZGxlKzB4ZC8weDEwClsg
IDI0MS42NzQwMTZdICBbPGMwMjBhMTQ2Pl0gYXJjaF9jcHVfaWRsZSsweDI2LzB4MzAKWyAg
MjQxLjY3NDAxNl0gIFs8YzAyN2I3YmE+XSBjcHVfc3RhcnR1cF9lbnRyeSsweDEzYS8weDFj
MApbICAyNDEuNjc0MDE2XSAgWzxjMDdmNzMzMD5dIHJlc3RfaW5pdCsweGIwLzB4YzAKWyAg
MjQxLjY3NDAxNl0gIFs8YzA3ZjcyODA+XSA/IF9fcmVhZF9sb2NrX2ZhaWxlZCsweDFjLzB4
MWMKWyAgMjQxLjY3NDAxNl0gIFs8YzBiYTVhZDk+XSBzdGFydF9rZXJuZWwrMHgzYmYvMHgz
YzUKWyAgMjQxLjY3NDAxNl0gIFs8YzBiYTU1NTE+XSA/IHJlcGFpcl9lbnZfc3RyaW5nKzB4
NTEvMHg1MQpbICAyNDEuNjc0MDE2XSAgWzxjMGJhNTM3OD5dIGkzODZfc3RhcnRfa2VybmVs
KzB4MTJlLzB4MTMxClsgIDI0MS42NzQwMTZdIENvZGU6IGJjIDI3IDAwIDAwIDAwIDAwIDU1
IDg5IGU1IGZhIDVkIGMzIDhkIDc2IDAwIDhkIGJjIDI3IDAwIDAwIDAwIDAwIDU1IDg5IGU1
IGZiIDVkIGMzIDhkIDc2IDAwIDhkIGJjIDI3IDAwIDAwIDAwIDAwIDU1IDg5IGU1IGZiIGY0
IDw1ZD4gYzMgODkgZjYgOGQgYmMgMjcgMDAgMDAgMDAgMDAgNTUgODkgZTUgZjQgNWQgYzMg
OGQgNzYgMDAgOGQKL2tlcm5lbC9pMzg2LXJhbmRjb25maWctajMtMTExMDEzMDgvNmFjY2Uz
ZWY4NDUyMDUzN2Y4YTA5YTEyYzlkZGJlODE0YTU4NGRkMi9kbWVzZy15b2N0by14aWFuLTEw
OjIwMTMxMTEwMjE0MDIwOmkzODYtcmFuZGNvbmZpZy1qMy0xMTEwMTMwODozLjEyLjAtcmM0
LTAwMTc3LWc2YWNjZTNlOjc3Ngova2VybmVsL2kzODYtcmFuZGNvbmZpZy1qMy0xMTEwMTMw
OC82YWNjZTNlZjg0NTIwNTM3ZjhhMDlhMTJjOWRkYmU4MTRhNTg0ZGQyL2RtZXNnLXF1YW50
YWwtY2Fpcm8tNDI6MjAxMzExMTAyMTQwMjc6aTM4Ni1yYW5kY29uZmlnLWozLTExMTAxMzA4
OjMuMTIuMC1yYzQtMDAxNzctZzZhY2NlM2U6Nzc2Ci9rZXJuZWwvaTM4Ni1yYW5kY29uZmln
LWozLTExMTAxMzA4LzZhY2NlM2VmODQ1MjA1MzdmOGEwOWExMmM5ZGRiZTgxNGE1ODRkZDIv
ZG1lc2ctcXVhbnRhbC1pbm4tMzc6MjAxMzExMTAyMTQwMzQ6aTM4Ni1yYW5kY29uZmlnLWoz
LTExMTAxMzA4OjMuMTIuMC1yYzQtMDAxNzctZzZhY2NlM2U6Nzc2Ci9rZXJuZWwvaTM4Ni1y
YW5kY29uZmlnLWozLTExMTAxMzA4LzZhY2NlM2VmODQ1MjA1MzdmOGEwOWExMmM5ZGRiZTgx
NGE1ODRkZDIvZG1lc2ctcXVhbnRhbC1sa3Atc3QwMS05OjIwMTMxMTExMDUzNTAzOmkzODYt
cmFuZGNvbmZpZy1qMy0xMTEwMTMwODozLjEyLjAtcmM0LTAwMTc3LWc2YWNjZTNlOjc3Ngov
a2VybmVsL2kzODYtcmFuZGNvbmZpZy1qMy0xMTEwMTMwOC82YWNjZTNlZjg0NTIwNTM3Zjhh
MDlhMTJjOWRkYmU4MTRhNTg0ZGQyL2RtZXNnLXF1YW50YWwtcm9hbS05OjIwMTMxMTEwMjE0
MDI0OmkzODYtcmFuZGNvbmZpZy1qMy0xMTEwMTMwODozLjEyLjAtcmM0LTAwMTc3LWc2YWNj
ZTNlOjc3Ngova2VybmVsL2kzODYtcmFuZGNvbmZpZy1qMy0xMTEwMTMwOC82YWNjZTNlZjg0
NTIwNTM3ZjhhMDlhMTJjOWRkYmU4MTRhNTg0ZGQyL2RtZXNnLXF1YW50YWwtc25iLTI1OjIw
MTMxMTEwMjE0MDI3OmkzODYtcmFuZGNvbmZpZy1qMy0xMTEwMTMwODozLjEyLjAtcmM0LTAw
MTc3LWc2YWNjZTNlOjc3Ngova2VybmVsL2kzODYtcmFuZGNvbmZpZy1qMy0xMTEwMTMwOC82
YWNjZTNlZjg0NTIwNTM3ZjhhMDlhMTJjOWRkYmU4MTRhNTg0ZGQyL2RtZXNnLXF1YW50YWwt
eGlhbi0yMDoyMDEzMTExMDIxNDAzMDppMzg2LXJhbmRjb25maWctajMtMTExMDEzMDg6My4x
Mi4wLXJjNC0wMDE3Ny1nNmFjY2UzZTo3NzYKL2tlcm5lbC9pMzg2LXJhbmRjb25maWctajMt
MTExMDEzMDgvNmFjY2UzZWY4NDUyMDUzN2Y4YTA5YTEyYzlkZGJlODE0YTU4NGRkMi9kbWVz
Zy15b2N0by1jYWlyby04OjIwMTMxMTEwMjE0MDM0OmkzODYtcmFuZGNvbmZpZy1qMy0xMTEw
MTMwODozLjEyLjAtcmM0LTAwMTc3LWc2YWNjZTNlOjc3Ngova2VybmVsL2kzODYtcmFuZGNv
bmZpZy1qMy0xMTEwMTMwOC82YWNjZTNlZjg0NTIwNTM3ZjhhMDlhMTJjOWRkYmU4MTRhNTg0
ZGQyL2RtZXNnLXlvY3RvLWpha2V0b3duLTI5OjIwMTMxMTEwMjE0MDIyOmkzODYtcmFuZGNv
bmZpZy1qMy0xMTEwMTMwODozLjEyLjAtcmM0LTAwMTc3LWc2YWNjZTNlOjc3Ngova2VybmVs
L2kzODYtcmFuZGNvbmZpZy1qMy0xMTEwMTMwOC82YWNjZTNlZjg0NTIwNTM3ZjhhMDlhMTJj
OWRkYmU4MTRhNTg0ZGQyL2RtZXNnLXlvY3RvLXJvYW0tOToyMDEzMTExMDIxNDAzMjppMzg2
LXJhbmRjb25maWctajMtMTExMDEzMDg6My4xMi4wLXJjNC0wMDE3Ny1nNmFjY2UzZTo3NzYK
L2tlcm5lbC9pMzg2LXJhbmRjb25maWctajMtMTExMDEzMDgvNmFjY2UzZWY4NDUyMDUzN2Y4
YTA5YTEyYzlkZGJlODE0YTU4NGRkMi9kbWVzZy15b2N0by1zbmItMjU6MjAxMzExMTAyMTQw
MzE6aTM4Ni1yYW5kY29uZmlnLWozLTExMTAxMzA4OjMuMTIuMC1yYzQtMDAxNzctZzZhY2Nl
M2U6Nzc2CjI0OjExOjExIGFsbF9nb29kOmJhZDphbGxfYmFkIGJvb3RzChtbMTszNW1SRVBF
QVQgQ09VTlQ6IDQxICAjIC9jYy93ZmcvdXNiLWJpc2VjdC8ucmVwZWF0G1swbQoKQmlzZWN0
aW5nOiAwIHJldmlzaW9ucyBsZWZ0IHRvIHRlc3QgYWZ0ZXIgdGhpcyAocm91Z2hseSAxIHN0
ZXApCls3NDYwMjMxNTljNDBjNTIzYjA4YTNiYzNkMjEzZGFjMjEyMzg1ODk1XSBzY2hlZDog
Rml4IHJhY2UgaW4gbWlncmF0ZV9zd2FwX3N0b3AoKQpydW5uaW5nIC9jL2tlcm5lbC10ZXN0
cy9iaXNlY3QtdGVzdC1ib290LWZhaWx1cmUuc2ggL2hvbWUvd2ZnL3VzYi9vYmotYmlzZWN0
CmxzIC1hIC9rZXJuZWwtdGVzdHMvcnVuLXF1ZXVlL2t2bS9pMzg2LXJhbmRjb25maWctajMt
MTExMDEzMDgvbmV4dDptYXN0ZXI6NzQ2MDIzMTU5YzQwYzUyM2IwOGEzYmMzZDIxM2RhYzIx
MjM4NTg5NTpiaXNlY3QtdXNiCgoyMDEzLTExLTEwLTIxOjQwOjQ1IDc0NjAyMzE1OWM0MGM1
MjNiMDhhM2JjM2QyMTNkYWMyMTIzODU4OTUgY29tcGlsaW5nCjc2IHJlYWwgIDMxIHVzZXIg
IDkgc3lzICA1My43NCUgY3B1IAlpMzg2LXJhbmRjb25maWctajMtMTExMDEzMDgKCjIwMTMt
MTEtMTAtMjE6NDU6MjUgZGV0ZWN0aW5nIGJvb3Qgc3RhdGUgMy4xMi4wLXJjNC0wMDE3Ni1n
NzQ2MDIzMS4uCTMwCTM5CTQxIFNVQ0NFU1MKCjZhY2NlM2VmODQ1MjA1MzdmOGEwOWExMmM5
ZGRiZTgxNGE1ODRkZDIgaXMgdGhlIGZpcnN0IGJhZCBjb21taXQKY29tbWl0IDZhY2NlM2Vm
ODQ1MjA1MzdmOGEwOWExMmM5ZGRiZTgxNGE1ODRkZDIKQXV0aG9yOiBQZXRlciBaaWpsc3Ry
YSA8cGV0ZXJ6QGluZnJhZGVhZC5vcmc+CkRhdGU6ICAgRnJpIE9jdCAxMSAxNDozODoyMCAy
MDEzICswMjAwCgogICAgc2NoZWQ6IFJlbW92ZSBnZXRfb25saW5lX2NwdXMoKSB1c2FnZQog
ICAgCiAgICBSZW1vdmUgZ2V0X29ubGluZV9jcHVzKCkgdXNhZ2UgZnJvbSB0aGUgc2NoZWR1
bGVyOyB0aGVyZSdzIDQgc2l0ZXMgdGhhdAogICAgdXNlIGl0OgogICAgCiAgICAgLSBzY2hl
ZF9pbml0X3NtcCgpOyB3aGVyZSBpdHMgY29tcGxldGVseSBzdXBlcmZsdW91cyBzaW5jZSB3
ZSdyZSBpbgogICAgICAgJ2Vhcmx5JyBib290IGFuZCB0aGVyZSBzaW1wbHkgY2Fubm90IGJl
IGFueSBob3RwbHVnZ2luZy4KICAgIAogICAgIC0gc2NoZWRfZ2V0YWZmaW5pdHkoKTsgd2Ug
YWxyZWFkeSB0YWtlIGEgcmF3IHNwaW5sb2NrIHRvIHByb3RlY3QgdGhlCiAgICAgICB0YXNr
IGNwdXNfYWxsb3dlZCBtYXNrLCB0aGlzIGRpc2FibGVzIHByZWVtcHRpb24gYW5kIHRoZXJl
Zm9yZQogICAgICAgYWxzbyBzdGFiaWxpemVzIGNwdV9vbmxpbmVfbWFzayBhcyB0aGF0J3Mg
bW9kaWZpZWQgdXNpbmcKICAgICAgIHN0b3BfbWFjaGluZS4gSG93ZXZlciBzd2l0Y2ggdG8g
YWN0aXZlIG1hc2sgZm9yIHN5bW1ldHJ5IHdpdGgKICAgICAgIHNjaGVkX3NldGFmZmluaXR5
KCkvc2V0X2NwdXNfYWxsb3dlZF9wdHIoKS4gV2UgZ3VhcmFudGVlIGFjdGl2ZQogICAgICAg
bWFzayBzdGFiaWxpdHkgYnkgaW5zZXJ0aW5nIHN5bmNfcmN1L3NjaGVkKCkgaW50byBfY3B1
X2Rvd24uCiAgICAKICAgICAtIHNjaGVkX3NldGFmZmluaXR5KCk7IHdlIGRvbid0IGFwcGVh
ciB0byBuZWVkIGdldF9vbmxpbmVfY3B1cygpCiAgICAgICBlaXRoZXIsIHRoZXJlJ3MgdHdv
IHNpdGVzIHdoZXJlIGhvdHBsdWcgYXBwZWFycyByZWxldmFudDoKICAgICAgICAqIGNwdXNl
dF9jcHVzX2FsbG93ZWQoKTsgZm9yIHRoZSAhY3B1c2V0IGNhc2Ugd2UgdXNlIHBvc3NpYmxl
X21hc2ssCiAgICAgICAgICBmb3IgdGhlIGNwdXNldCBjYXNlIHdlIGhvbGQgdGFza19sb2Nr
LCB3aGljaCBpcyBhIHNwaW5sb2NrIGFuZAogICAgICAgICAgdGh1cyBmb3IgbWFpbmxpbmUg
ZGlzYWJsZXMgcHJlZW1wdGlvbiAobWlnaHQgY2F1c2UgcGFpbiBvbiBSVCkuCiAgICAgICAg
KiBzZXRfY3B1c19hbGxvd2VkX3B0cigpOyBIb2xkcyBhbGwgc2NoZWR1bGVyIGxvY2tzIGFu
ZCB0aHVzIGhhcwogICAgICAgICAgcHJlZW1wdGlvbiBwcm9wZXJseSBkaXNhYmxlZDsgYWxz
byBpdCBhbHJlYWR5IGRlYWxzIHdpdGggaG90cGx1ZwogICAgICAgICAgcmFjZXMgZXhwbGlj
aXRseSB3aGVyZSBpdCByZWxlYXNlcyB0aGVtLgogICAgCiAgICAgLSBtaWdyYXRlX3N3YXAo
KTsgd2UgY2FuIG1ha2Ugc3RvcF90d29fY3B1cygpIGRvIHRoZSBoZWF2eSBsaWZ0aW5nIGZv
cgogICAgICAgdXMgd2l0aCBhIGxpdHRsZSB0cmlja2VyeS4gQnkgYWRkaW5nIGEgc3luY19z
Y2hlZC9yY3UoKSBhZnRlciB0aGUKICAgICAgIENQVV9ET1dOX1BSRVBBUkUgbm90aWZpZXIg
d2UgY2FuIHByb3ZpZGUgcHJlZW1wdC9yY3UgZ3VhcmFudGVlcyBmb3IKICAgICAgIGNwdV9h
Y3RpdmVfbWFzay4gVXNlIHRoZXNlIHRvIHZhbGlkYXRlIHRoYXQgYm90aCBvdXIgY3B1cyBh
cmUgYWN0aXZlCiAgICAgICB3aGVuIHF1ZXVlaW5nIHRoZSBzdG9wIHdvcmsgYmVmb3JlIHdl
IHF1ZXVlIHRoZSBzdG9wX21hY2hpbmUgd29ya3MKICAgICAgIGZvciB0YWtlX2NwdV9kb3du
KCkuCiAgICAKICAgIFNpZ25lZC1vZmYtYnk6IFBldGVyIFppamxzdHJhIDxwZXRlcnpAaW5m
cmFkZWFkLm9yZz4KICAgIENjOiAiU3JpdmF0c2EgUy4gQmhhdCIgPHNyaXZhdHNhLmJoYXRA
bGludXgudm5ldC5pYm0uY29tPgogICAgQ2M6IFBhdWwgTWNLZW5uZXkgPHBhdWxtY2tAbGlu
dXgudm5ldC5pYm0uY29tPgogICAgQ2M6IE1lbCBHb3JtYW4gPG1nb3JtYW5Ac3VzZS5kZT4K
ICAgIENjOiBSaWsgdmFuIFJpZWwgPHJpZWxAcmVkaGF0LmNvbT4KICAgIENjOiBTcmlrYXIg
RHJvbmFtcmFqdSA8c3Jpa2FyQGxpbnV4LnZuZXQuaWJtLmNvbT4KICAgIENjOiBBbmRyZWEg
QXJjYW5nZWxpIDxhYXJjYW5nZUByZWRoYXQuY29tPgogICAgQ2M6IEpvaGFubmVzIFdlaW5l
ciA8aGFubmVzQGNtcHhjaGcub3JnPgogICAgQ2M6IExpbnVzIFRvcnZhbGRzIDx0b3J2YWxk
c0BsaW51eC1mb3VuZGF0aW9uLm9yZz4KICAgIENjOiBBbmRyZXcgTW9ydG9uIDxha3BtQGxp
bnV4LWZvdW5kYXRpb24ub3JnPgogICAgQ2M6IFN0ZXZlbiBSb3N0ZWR0IDxyb3N0ZWR0QGdv
b2RtaXMub3JnPgogICAgQ2M6IE9sZWcgTmVzdGVyb3YgPG9sZWdAcmVkaGF0LmNvbT4KICAg
IExpbms6IGh0dHA6Ly9sa21sLmtlcm5lbC5vcmcvci8yMDEzMTAxMTEyMzgyMC5HVjMwODFA
dHdpbnMucHJvZ3JhbW1pbmcua2lja3MtYXNzLm5ldAogICAgU2lnbmVkLW9mZi1ieTogSW5n
byBNb2xuYXIgPG1pbmdvQGtlcm5lbC5vcmc+Cgo6MDQwMDAwIDA0MDAwMCA5Zjc0NDczOTM2
YmQ0ZTYyMTExNWIyOTZiYjc0N2RmNTM2MGEwM2IyIGFkMTllYTkwMDVhNWFlOTkyOWY2NGE3
N2Q1ZTg4ODMyMDc3ODhkMzQgTQlrZXJuZWwKYmlzZWN0IHJ1biBzdWNjZXNzCmxzIC1hIC9r
ZXJuZWwtdGVzdHMvcnVuLXF1ZXVlL2t2bS9pMzg2LXJhbmRjb25maWctajMtMTExMDEzMDgv
bmV4dDptYXN0ZXI6NzQ2MDIzMTU5YzQwYzUyM2IwOGEzYmMzZDIxM2RhYzIxMjM4NTg5NTpi
aXNlY3QtdXNiCgoyMDEzLTExLTEwLTIxOjQ3OjU4IDc0NjAyMzE1OWM0MGM1MjNiMDhhM2Jj
M2QyMTNkYWMyMTIzODU4OTUgcmV1c2UgL2tlcm5lbC9pMzg2LXJhbmRjb25maWctajMtMTEx
MDEzMDgvNzQ2MDIzMTU5YzQwYzUyM2IwOGEzYmMzZDIxM2RhYzIxMjM4NTg5NS92bWxpbnV6
LTMuMTIuMC1yYzQtMDAxNzYtZzc0NjAyMzEKCjIwMTMtMTEtMTAtMjE6NDc6NTkgZGV0ZWN0
aW5nIGJvb3Qgc3RhdGUgLi4JNjQJMTIwLgkxMjEJMTIyCTEyMyBTVUNDRVNTCgpscyAtYSAv
a2VybmVsLXRlc3RzL3J1bi1xdWV1ZS9rdm0vaTM4Ni1yYW5kY29uZmlnLWozLTExMTAxMzA4
L25leHQ6bWFzdGVyOmJhZDU3MGQ3NzAyNGNiYTgwODEyNmQ2OGEyMDcyZjZmOGNlNjRjMjc6
YmlzZWN0LXVzYgogVEVTVCBGQUlMVVJFClsgICAgMi4wNDc4NjRdIEVERCBpbmZvcm1hdGlv
biBub3QgYXZhaWxhYmxlLgpbICAgIDIuMDQ4MzM4XSBVbnJlZ2lzdGVyIHB2IHNoYXJlZCBt
ZW1vcnkgZm9yIGNwdSAwClsgICAgMi42NjIxNDFdIHRzYzogUmVmaW5lZCBUU0MgY2xvY2tz
b3VyY2UgY2FsaWJyYXRpb246IDI4OTIuOTQzIE1IegpbICAyNDEuNjc2MDg2XSBJTkZPOiB0
YXNrIHN3YXBwZXIvMDoxIGJsb2NrZWQgZm9yIG1vcmUgdGhhbiAxMjAgc2Vjb25kcy4KWyAg
MjQxLjY3NzE5NF0gICAgICAgTm90IHRhaW50ZWQgMy4xMi4wLW5leHQtMjAxMzExMDgtMTA2
MDEtZ2JhZDU3MGQgIzMKWyAgMjQxLjY3ODI2MF0gImVjaG8gMCA+IC9wcm9jL3N5cy9rZXJu
ZWwvaHVuZ190YXNrX3RpbWVvdXRfc2VjcyIgZGlzYWJsZXMgdGhpcyBtZXNzYWdlLgpbICAy
NDEuNjc5NTE5XSBzd2FwcGVyLzAgICAgICAgRCAwMDAwYWQwMCAgNTc1MiAgICAgMSAgICAg
IDAgMHgwMDAwMDAwMApbICAyNDEuNjgwNjE3XSAgY2Q0MjlkYmMgMDAwMDAwOTIgYzFjM2I2
NDAgMDAwMGFkMDAgMjAwMjQxNjAgY2Q0MjlkYzggYzFhMjUyYzAgMDAwMDAwMDgKWyAgMjQx
LjY4MjA5Ml0gIGMxOTM3ZDIwIGMxYTI1MmMwIGNkNDE3NDQwIDAwMDAwMDAwIDIwMDI0MTYw
IDAwMDAwMDAzIDAwMDAwMDAwIDAwMDBhZDAwClsgIDI0MS42ODM1MzldICBjMWM2ZDUwMCAw
MDAwMDAwMCBjZDQxNzg0OCAwMDAwMDAwMCBjZDQxNzQ0MCBjMTA3N2UxNyBjZGFkZGFiNCAw
MDAwMDAwMQpbICAyNDEuNjg0ODczXSBDYWxsIFRyYWNlOgpbICAyNDEuNjg1MzAyXSAgWzxj
MTA3N2UxNz5dID8gbWFya19oZWxkX2xvY2tzKzB4ODcvMHhmMApbICAyNDEuNjg2MTYzXSAg
WzxjMTYyMWE4MD5dIHNjaGVkdWxlKzB4MTAvMHgyMApbICAyNDEuNjg2ODM5XSAgWzxjMTYy
MGZkNT5dIHNjaGVkdWxlX3RpbWVvdXQrMHgxMjUvMHgxODAKWyAgMjQxLjY4NzY4N10gIFs8
YzE2MjVhMDI+XSA/IF9yYXdfc3Bpbl91bmxvY2tfaXJxKzB4MjIvMHg1MApbICAyNDEuNjg4
NjA1XSAgWzxjMTYyMjFmND5dID8gd2FpdF9mb3JfY29tcGxldGlvbisweDk0LzB4ZDAKWyAg
MjQxLjY4OTUwM10gIFs8YzEwNzgyNmI+XSA/IHRyYWNlX2hhcmRpcnFzX29uKzB4Yi8weDEw
ClsgIDI0MS42OTAzNTBdICBbPGMxNjIyMWZiPl0gd2FpdF9mb3JfY29tcGxldGlvbisweDli
LzB4ZDAKWyAgMjQxLjY5MTIxNV0gIFs8YzEwNjZhYTA+XSA/IHdha2VfdXBfc3RhdGUrMHgx
MC8weDEwClsgIDI0MS42OTIwMDNdICBbPGMxMDhhZjkwPl0gPyBfX2NhbGxfcmN1LmNvbnN0
cHJvcC42MSsweDI0MC8weDI0MApbICAyNDEuNjkyOTc4XSAgWzxjMTA4ODczZj5dIHdhaXRf
cmN1X2dwKzB4M2YvMHg2MApbICAyNDEuNjkzNzQ1XSAgWzxjMTA4ODVhMD5dID8gcmN1X3Bh
bmljKzB4MjAvMHgyMApbICAyNDEuNjk0NTIyXSAgWzxjMTA4Y2I5Zj5dIHN5bmNocm9uaXpl
X3JjdSsweDFmLzB4NDAKWyAgMjQxLjY5NTMxNV0gIFs8YzE2MGI5YTk+XSBfY3B1X2Rvd24r
MHgxMjkvMHgyYzAKWyAgMjQxLjY5NjA1M10gIFs8YzE2MGJiYjI+XSA/IGNwdV9kb3duKzB4
MTIvMHg0MApbICAyNDEuNjk2NzI0XSAgWzxjMTJiZDlmZj5dID8gbG9ja19kZXZpY2VfaG90
cGx1ZysweGYvMHgyMApbICAyNDEuNjk3NTY3XSAgWzxjMTYwYmJjND5dIGNwdV9kb3duKzB4
MjQvMHg0MApbICAyNDEuNjk4MjUxXSAgWzxjMTYwYjE5Nz5dIF9kZWJ1Z19ob3RwbHVnX2Nw
dSsweDc3LzB4YjAKWyAgMjQxLjY5OTA1OF0gIFs8YzEyYzJjMWU+XSA/IF9fcGxhdGZvcm1f
ZHJpdmVyX3JlZ2lzdGVyKzB4M2UvMHg0MApbICAyNDEuNjk5OTgwXSAgWzxjMTljYWUxOT5d
ID8gcGNpX2lvbW11X2FsbG9jKzB4NWEvMHg1YQpbICAyNDEuNzAwNzY5XSAgWzxjMTljYWUy
NT5dIGRlYnVnX2hvdHBsdWdfY3B1KzB4Yy8weDEwClsgIDI0MS43MDE1NTJdICBbPGMxOWM2
Yjg4Pl0gZG9fb25lX2luaXRjYWxsKzB4OGQvMHgxMmMKWyAgMjQxLjcwMjM0MV0gIFs8YzEx
NzEyOWQ+XSA/IHN0cmxlbisweGQvMHgyMApbICAyNDEuNzAzMDAxXSAgWzxjMTA1OWM5Mz5d
ID8gcGFyYW1lcSsweDEzLzB4NzAKWyAgMjQxLjcwMzY5MV0gIFs8YzE5YzY1MTI+XSA/IHJl
cGFpcl9lbnZfc3RyaW5nKzB4MTIvMHg1MQpbICAyNDEuNzA0NTE5XSAgWzxjMTA1OWViZj5d
ID8gcGFyc2VfYXJncysweDFjZi8weDMyMApbICAyNDEuNzA1Mjk3XSAgWzxjMTA1MmI2ZT5d
ID8gX191c2VybW9kZWhlbHBlcl9zZXRfZGlzYWJsZV9kZXB0aCsweDNlLzB4NTAKWyAgMjQx
LjcwNjQ1M10gIFs8YzE5YzZkMTI+XSBrZXJuZWxfaW5pdF9mcmVlYWJsZSsweGViLzB4MTdk
ClsgIDI0MS43MDczNTldICBbPGMxOWM2NTAwPl0gPyBkb19lYXJseV9wYXJhbSsweDc4LzB4
NzgKWyAgMjQxLjcwODE4OF0gIFs8YzE2MGIwMmI+XSBrZXJuZWxfaW5pdCsweGIvMHgxMDAK
WyAgMjQxLjcwODkwN10gIFs8YzE2MjZjYjc+XSByZXRfZnJvbV9rZXJuZWxfdGhyZWFkKzB4
MWIvMHgyOApbICAyNDEuNzA5ODAyXSAgWzxjMTYwYjAyMD5dID8gcmVzdF9pbml0KzB4YzAv
MHhjMApbICAyNDEuNzEwNTY0XSAzIGxvY2tzIGhlbGQgYnkgc3dhcHBlci8wLzE6ClsgIDI0
MS43MTEyMjZdICAjMDogIChkZXZpY2VfaG90cGx1Z19sb2NrKXsrLisuKy59LCBhdDogWzxj
MTJiZDlmZj5dIGxvY2tfZGV2aWNlX2hvdHBsdWcrMHhmLzB4MjAKWyAgMjQxLjcxMjc2MF0g
ICMxOiAgKGNwdV9hZGRfcmVtb3ZlX2xvY2speysuKy4rLn0sIGF0OiBbPGMxNjBiYmIyPl0g
Y3B1X2Rvd24rMHgxMi8weDQwClsgIDI0MS43MTQxOTBdICAjMjogIChjcHVfaG90cGx1Zy5s
b2NrKXsrLisuKy59LCBhdDogWzxjMTA0MjQyZD5dIGNwdV9ob3RwbHVnX2JlZ2luKzB4MWQv
MHg0MApbICAyNDEuNzE1NjUyXSBzZW5kaW5nIE5NSSB0byBhbGwgQ1BVczoKWyAgMjQxLjcx
NjMyNF0gTk1JIGJhY2t0cmFjZSBmb3IgY3B1IDEKWyAgMjQxLjcxNjg5OF0gQ1BVOiAxIFBJ
RDogNDYgQ29tbToga2h1bmd0YXNrZCBOb3QgdGFpbnRlZCAzLjEyLjAtbmV4dC0yMDEzMTEw
OC0xMDYwMS1nYmFkNTcwZCAjMwpbICAyNDEuNzE3Mjg3XSB0YXNrOiBjZmIwZjU2MCB0aTog
Y2ZiMDAwMDAgdGFzay50aTogY2ZiMDAwMDAKWyAgMjQxLjcxNzI4N10gRUlQOiAwMDYwOls8
YzEwMmM4ZTU+XSBFRkxBR1M6IDAwMDEwMDQ2IENQVTogMQpbICAyNDEuNzE3Mjg3XSBFSVAg
aXMgYXQgZGVmYXVsdF9zZW5kX0lQSV9tYXNrX2xvZ2ljYWwrMHg4NS8weGYwClsgIDI0MS43
MTcyODddIEVBWDogMDAwMDBjMDAgRUJYOiAwMzAwMDAwMCBFQ1g6IGZmZmZmMDAwIEVEWDog
ZmZmZmYwMDAKWyAgMjQxLjcxNzI4N10gRVNJOiAwMDAwMDIwNiBFREk6IDAwMDAwMDAyIEVC
UDogY2ZiMDFlZDQgRVNQOiBjZmIwMWVjNApbICAyNDEuNzE3Mjg3XSAgRFM6IDAwN2IgRVM6
IDAwN2IgRlM6IDAwZDggR1M6IDAwZTAgU1M6IDAwNjgKWyAgMjQxLjcxNzI4N10gQ1IwOiA4
MDA1MDAzYiBDUjI6IGZmZmZmZmZmIENSMzogMDFhMmQwMDAgQ1I0OiAwMDAwMDZmMApbICAy
NDEuNzE3Mjg3XSBTdGFjazoKWyAgMjQxLjcxNzI4N10gIDAwMDAwODAwIDAwMDAyNzEwIDAw
MDA3ZmZmIDAwMDAwM2ZmIGNmYjAxZWUwIGMxMDJjYTE4IDAwMDAyNzEwIGNmYjAxZWYwClsg
IDI0MS43MTcyODddICBjMTAyY2MwZCBjMTg2MTk5NCBjZDQxNzQ0MCBjZmIwMWYzMCBjMTBh
NDYzMiBjMTg3MTI3OCBjMWEzN2Y2YyBjMTkyNTY4NgpbICAyNDEuNzE3Mjg3XSAgMDAwMDAw
MDIgYzE5MjU2YzcgMDAwMDAwNzggMDAwMDAwMDIgY2Q0MTc1MzQgMDAwMDdmZmYgY2Q0MTc0
NDAgY2Q0MTc1MzQKWyAgMjQxLjcxNzI4N10gQ2FsbCBUcmFjZToKWyAgMjQxLjcxNzI4N10g
IFs8YzEwMmNhMTg+XSBkZWZhdWx0X3NlbmRfSVBJX2FsbCsweDU4LzB4NjAKWyAgMjQxLjcx
NzI4N10gIFs8YzEwMmNjMGQ+XSBhcmNoX3RyaWdnZXJfYWxsX2NwdV9iYWNrdHJhY2UrMHgz
ZC8weDcwClsgIDI0MS43MTcyODddICBbPGMxMGE0NjMyPl0gd2F0Y2hkb2crMHgyZTIvMHgz
MDAKWyAgMjQxLjcxNzI4N10gIFs8YzEwYTQzNTA+XSA/IGh1bmdfdGFza19wYW5pYysweDIw
LzB4MjAKWyAgMjQxLjcxNzI4N10gIFs8YzEwNWI2ZDc+XSBrdGhyZWFkKzB4YTcvMHhjMApb
ICAyNDEuNzE3Mjg3XSAgWzxjMTA2MDAwMD5dID8gc2V0X2NyZWF0ZV9maWxlc19hcysweDEw
LzB4MjAKWyAgMjQxLjcxNzI4N10gIFs8YzE2MjZjYjc+XSByZXRfZnJvbV9rZXJuZWxfdGhy
ZWFkKzB4MWIvMHgyOApbICAyNDEuNzE3Mjg3XSAgWzxjMTA1YjYzMD5dID8gX19rdGhyZWFk
X3BhcmttZSsweDYwLzB4NjAKWyAgMjQxLjcxNzI4N10gQ29kZTogMDAgYjMgZmYgZmYgZjYg
YzQgMTAgNzUgZWQgYzEgZTMgMTggODkgOTkgMTAgYjMgZmYgZmYgODkgZjggMDkgZDAgODAg
Y2UgMDQgODMgZmYgMDIgMGYgNDQgYzIgOGIgMTUgMDQgMDYgOTMgYzEgODkgODIgMDAgYjMg
ZmYgZmYgPGY3PiBjNiAwMCAwMiAwMCAwMCA3NCAxYiBlOCA2ZSBiOSAwNCAwMCA4OSBmMCA1
MCA5ZCA4ZCA3NCAyNiAwMApbICAyNDEuNzE3MDI4XSBOTUkgYmFja3RyYWNlIGZvciBjcHUg
MAova2VybmVsL2kzODYtcmFuZGNvbmZpZy1qMy0xMTEwMTMwOC9iYWQ1NzBkNzcwMjRjYmE4
MDgxMjZkNjhhMjA3MmY2ZjhjZTY0YzI3L2RtZXNnLXlvY3RvLWxrcC1zdDAxLTc6MjAxMzEx
MTEwMjI2MTU6aTM4Ni1yYW5kY29uZmlnLWozLTExMTAxMzA4OjMuMTIuMC1uZXh0LTIwMTMx
MTA4LTEwNjAxLWdiYWQ1NzBkOjMKL2tlcm5lbC9pMzg2LXJhbmRjb25maWctajMtMTExMDEz
MDgvYmFkNTcwZDc3MDI0Y2JhODA4MTI2ZDY4YTIwNzJmNmY4Y2U2NGMyNy9kbWVzZy15b2N0
by1zbmItNzoyMDEzMTExMDE4MzEzNjppMzg2LXJhbmRjb25maWctajMtMTExMDEzMDg6My4x
Mi4wLW5leHQtMjAxMzExMDgtMTA2MDEtZ2JhZDU3MGQ6Mwova2VybmVsL2kzODYtcmFuZGNv
bmZpZy1qMy0xMTEwMTMwOC9iYWQ1NzBkNzcwMjRjYmE4MDgxMjZkNjhhMjA3MmY2ZjhjZTY0
YzI3L2RtZXNnLXlvY3RvLXhpYW4tMzU6MjAxMzExMTAxNDA3MjI6aTM4Ni1yYW5kY29uZmln
LWozLTExMTAxMzA4OjMuMTIuMC1uZXh0LTIwMTMxMTA4LTEwNjAxLWdiYWQ1NzBkOjMKL2tl
cm5lbC9pMzg2LXJhbmRjb25maWctajMtMTExMDEzMDgvYmFkNTcwZDc3MDI0Y2JhODA4MTI2
ZDY4YTIwNzJmNmY4Y2U2NGMyNy9kbWVzZy15b2N0by14cHMtMzoyMDEzMTExMTAyMjkwNDpp
Mzg2LXJhbmRjb25maWctajMtMTExMDEzMDg6My4xMi4wLW5leHQtMjAxMzExMDgtMTA2MDEt
Z2JhZDU3MGQ6Mwova2VybmVsL2kzODYtcmFuZGNvbmZpZy1qMy0xMTEwMTMwOC9iYWQ1NzBk
NzcwMjRjYmE4MDgxMjZkNjhhMjA3MmY2ZjhjZTY0YzI3L2RtZXNnLXlvY3RvLXhpYW4tNDQ6
MjAxMzExMTAxNDA3MTc6aTM4Ni1yYW5kY29uZmlnLWozLTExMTAxMzA4OjMuMTIuMC1uZXh0
LTIwMTMxMTA4LTEwNjAxLWdiYWQ1NzBkOjMKL2tlcm5lbC9pMzg2LXJhbmRjb25maWctajMt
MTExMDEzMDgvYmFkNTcwZDc3MDI0Y2JhODA4MTI2ZDY4YTIwNzJmNmY4Y2U2NGMyNy9kbWVz
Zy15b2N0by1pbm4tMzoyMDEzMTExMDE4MzEzNDppMzg2LXJhbmRjb25maWctajMtMTExMDEz
MDg6My4xMi4wLW5leHQtMjAxMzExMDgtMTA2MDEtZ2JhZDU3MGQ6Mwova2VybmVsL2kzODYt
cmFuZGNvbmZpZy1qMy0xMTEwMTMwOC9iYWQ1NzBkNzcwMjRjYmE4MDgxMjZkNjhhMjA3MmY2
ZjhjZTY0YzI3L2RtZXNnLXF1YW50YWwtYXRoZW5zLTMzOjIwMTMxMTEwMTgzMTMyOmkzODYt
cmFuZGNvbmZpZy1qMy0xMTEwMTMwODozLjEyLjAtbmV4dC0yMDEzMTEwOC0xMDYwMS1nYmFk
NTcwZDozCi9rZXJuZWwvaTM4Ni1yYW5kY29uZmlnLWozLTExMTAxMzA4L2JhZDU3MGQ3NzAy
NGNiYTgwODEyNmQ2OGEyMDcyZjZmOGNlNjRjMjcvZG1lc2ctcXVhbnRhbC1jYWlyby00ODoy
MDEzMTExMDE0MDcyMDppMzg2LXJhbmRjb25maWctajMtMTExMDEzMDg6My4xMi4wLW5leHQt
MjAxMzExMDgtMTA2MDEtZ2JhZDU3MGQ6Mwova2VybmVsL2kzODYtcmFuZGNvbmZpZy1qMy0x
MTEwMTMwOC9iYWQ1NzBkNzcwMjRjYmE4MDgxMjZkNjhhMjA3MmY2ZjhjZTY0YzI3L2RtZXNn
LXF1YW50YWwtaW5uLTMxOjIwMTMxMTEwMTQwNzIxOmkzODYtcmFuZGNvbmZpZy1qMy0xMTEw
MTMwODozLjEyLjAtbmV4dC0yMDEzMTEwOC0xMDYwMS1nYmFkNTcwZDozCi9rZXJuZWwvaTM4
Ni1yYW5kY29uZmlnLWozLTExMTAxMzA4L2JhZDU3MGQ3NzAyNGNiYTgwODEyNmQ2OGEyMDcy
ZjZmOGNlNjRjMjcvZG1lc2cteW9jdG8tYmVucy0zOjIwMTMxMTEwMTQwNzE2OmkzODYtcmFu
ZGNvbmZpZy1qMy0xMTEwMTMwODozLjEyLjAtbmV4dC0yMDEzMTEwOC0xMDYwMS1nYmFkNTcw
ZDozCi9rZXJuZWwvaTM4Ni1yYW5kY29uZmlnLWozLTExMTAxMzA4L2JhZDU3MGQ3NzAyNGNi
YTgwODEyNmQ2OGEyMDcyZjZmOGNlNjRjMjcvZG1lc2ctcXVhbnRhbC1sa3Atc3QwMS01OjIw
MTMxMTExMDIyNjIwOmkzODYtcmFuZGNvbmZpZy1qMy0xMTEwMTMwODozLjEyLjAtbmV4dC0y
MDEzMTEwOC0xMDYwMS1nYmFkNTcwZDozCi9rZXJuZWwvaTM4Ni1yYW5kY29uZmlnLWozLTEx
MTAxMzA4L2JhZDU3MGQ3NzAyNGNiYTgwODEyNmQ2OGEyMDcyZjZmOGNlNjRjMjcvZG1lc2ct
cXVhbnRhbC1sa3AtdHQwMi0yMjoyMDEzMTExMDA5MjMwNTppMzg2LXJhbmRjb25maWctajMt
MTExMDEzMDg6My4xMi4wLW5leHQtMjAxMzExMDgtMTA2MDEtZ2JhZDU3MGQ6Mwova2VybmVs
L2kzODYtcmFuZGNvbmZpZy1qMy0xMTEwMTMwOC9iYWQ1NzBkNzcwMjRjYmE4MDgxMjZkNjhh
MjA3MmY2ZjhjZTY0YzI3L2RtZXNnLXF1YW50YWwtaW5uLTE6MjAxMzExMTAxNDA3MTk6aTM4
Ni1yYW5kY29uZmlnLWozLTExMTAxMzA4OjMuMTIuMC1uZXh0LTIwMTMxMTA4LTEwNjAxLWdi
YWQ1NzBkOjMKL2tlcm5lbC9pMzg2LXJhbmRjb25maWctajMtMTExMDEzMDgvYmFkNTcwZDc3
MDI0Y2JhODA4MTI2ZDY4YTIwNzJmNmY4Y2U2NGMyNy9kbWVzZy1xdWFudGFsLWlubi0xMToy
MDEzMTExMDE4MzEzNzppMzg2LXJhbmRjb25maWctajMtMTExMDEzMDg6My4xMi4wLW5leHQt
MjAxMzExMDgtMTA2MDEtZ2JhZDU3MGQ6Mwova2VybmVsL2kzODYtcmFuZGNvbmZpZy1qMy0x
MTEwMTMwOC9iYWQ1NzBkNzcwMjRjYmE4MDgxMjZkNjhhMjA3MmY2ZjhjZTY0YzI3L2RtZXNn
LXF1YW50YWwtY2Fpcm8tMjY6MjAxMzExMTAxNDA3MjA6aTM4Ni1yYW5kY29uZmlnLWozLTEx
MTAxMzA4OjMuMTIuMC1uZXh0LTIwMTMxMTA4LTEwNjAxLWdiYWQ1NzBkOjMKL2tlcm5lbC9p
Mzg2LXJhbmRjb25maWctajMtMTExMDEzMDgvYmFkNTcwZDc3MDI0Y2JhODA4MTI2ZDY4YTIw
NzJmNmY4Y2U2NGMyNy9kbWVzZy15b2N0by1pbm4tOToyMDEzMTExMDE4MzEzNjppMzg2LXJh
bmRjb25maWctajMtMTExMDEzMDg6My4xMi4wLW5leHQtMjAxMzExMDgtMTA2MDEtZ2JhZDU3
MGQ6MwozOjE2OjE2IGFsbF9nb29kOmJhZDphbGxfYmFkIGJvb3RzCgpbZGV0YWNoZWQgSEVB
RCA5M2U3MjM3XSBSZXZlcnQgInNjaGVkOiBSZW1vdmUgZ2V0X29ubGluZV9jcHVzKCkgdXNh
Z2UiCiAzIGZpbGVzIGNoYW5nZWQsIDE1IGluc2VydGlvbnMoKyksIDQ4IGRlbGV0aW9ucygt
KQpscyAtYSAva2VybmVsLXRlc3RzL3J1bi1xdWV1ZS9rdm0vaTM4Ni1yYW5kY29uZmlnLWoz
LTExMTAxMzA4L25leHQ6bWFzdGVyOjkzZTcyMzdmNTM0NDk0OWY0ZmNiMzk1ZDQ4NGFlODlm
Y2EzYzYzMGI6YmlzZWN0LXVzYgoKMjAxMy0xMS0xMC0yMTo1MjoxMCA5M2U3MjM3ZjUzNDQ5
NDlmNGZjYjM5NWQ0ODRhZTg5ZmNhM2M2MzBiIGNvbXBpbGluZwoKMjAxMy0xMS0xMC0yMjow
Njo1NSBkZXRlY3RpbmcgYm9vdCBzdGF0ZSAzLjEyLjAtbmV4dC0yMDEzMTEwOC0xMDYwMi1n
OTNlNzIzNy4uCTE4CTc1CTExNi4JMTIxCTEyMgkxMjMgU1VDQ0VTUwoKCj09PT09PT09PSB1
cHN0cmVhbSA9PT09PT09PT0KRmV0Y2hpbmcgbGludXMKbHMgLWEgL2tlcm5lbC10ZXN0cy9y
dW4tcXVldWUva3ZtL2kzODYtcmFuZGNvbmZpZy1qMy0xMTEwMTMwOC9uZXh0Om1hc3Rlcjo2
Yzg2YWUyOTI4ZjllNGNiZjBkNTg0NGY1ZmNmZDU0OWUzNDUwYjhjOmJpc2VjdC11c2IKCjIw
MTMtMTEtMTAtMjI6MTE6MzEgNmM4NmFlMjkyOGY5ZTRjYmYwZDU4NDRmNWZjZmQ1NDllMzQ1
MGI4YyBjb21waWxpbmcKCjIwMTMtMTEtMTAtMjI6MjA6MjEgZGV0ZWN0aW5nIGJvb3Qgc3Rh
dGUgMy4xMi4wLTAxOTE1LWc2Yzg2YWUyLi4JMjUJNDkJNjgJOTcJMTE2CTEyMQkxMjMgU1VD
Q0VTUwoKCj09PT09PT09PSBsaW51eC1uZXh0ID09PT09PT09PQpGZXRjaGluZyBuZXh0Cmxz
IC1hIC9rZXJuZWwtdGVzdHMvcnVuLXF1ZXVlL2t2bS9pMzg2LXJhbmRjb25maWctajMtMTEx
MDEzMDgvbmV4dDptYXN0ZXI6YmFkNTcwZDc3MDI0Y2JhODA4MTI2ZDY4YTIwNzJmNmY4Y2U2
NGMyNzpiaXNlY3QtdXNiCiBURVNUIEZBSUxVUkUKWyAgICAyLjA0Nzg2NF0gRUREIGluZm9y
bWF0aW9uIG5vdCBhdmFpbGFibGUuClsgICAgMi4wNDgzMzhdIFVucmVnaXN0ZXIgcHYgc2hh
cmVkIG1lbW9yeSBmb3IgY3B1IDAKWyAgICAyLjY2MjE0MV0gdHNjOiBSZWZpbmVkIFRTQyBj
bG9ja3NvdXJjZSBjYWxpYnJhdGlvbjogMjg5Mi45NDMgTUh6ClsgIDI0MS42NzYwODZdIElO
Rk86IHRhc2sgc3dhcHBlci8wOjEgYmxvY2tlZCBmb3IgbW9yZSB0aGFuIDEyMCBzZWNvbmRz
LgpbICAyNDEuNjc3MTk0XSAgICAgICBOb3QgdGFpbnRlZCAzLjEyLjAtbmV4dC0yMDEzMTEw
OC0xMDYwMS1nYmFkNTcwZCAjMwpbICAyNDEuNjc4MjYwXSAiZWNobyAwID4gL3Byb2Mvc3lz
L2tlcm5lbC9odW5nX3Rhc2tfdGltZW91dF9zZWNzIiBkaXNhYmxlcyB0aGlzIG1lc3NhZ2Uu
ClsgIDI0MS42Nzk1MTldIHN3YXBwZXIvMCAgICAgICBEIDAwMDBhZDAwICA1NzUyICAgICAx
ICAgICAgMCAweDAwMDAwMDAwClsgIDI0MS42ODA2MTddICBjZDQyOWRiYyAwMDAwMDA5MiBj
MWMzYjY0MCAwMDAwYWQwMCAyMDAyNDE2MCBjZDQyOWRjOCBjMWEyNTJjMCAwMDAwMDAwOApb
ICAyNDEuNjgyMDkyXSAgYzE5MzdkMjAgYzFhMjUyYzAgY2Q0MTc0NDAgMDAwMDAwMDAgMjAw
MjQxNjAgMDAwMDAwMDMgMDAwMDAwMDAgMDAwMGFkMDAKWyAgMjQxLjY4MzUzOV0gIGMxYzZk
NTAwIDAwMDAwMDAwIGNkNDE3ODQ4IDAwMDAwMDAwIGNkNDE3NDQwIGMxMDc3ZTE3IGNkYWRk
YWI0IDAwMDAwMDAxClsgIDI0MS42ODQ4NzNdIENhbGwgVHJhY2U6ClsgIDI0MS42ODUzMDJd
ICBbPGMxMDc3ZTE3Pl0gPyBtYXJrX2hlbGRfbG9ja3MrMHg4Ny8weGYwClsgIDI0MS42ODYx
NjNdICBbPGMxNjIxYTgwPl0gc2NoZWR1bGUrMHgxMC8weDIwClsgIDI0MS42ODY4MzldICBb
PGMxNjIwZmQ1Pl0gc2NoZWR1bGVfdGltZW91dCsweDEyNS8weDE4MApbICAyNDEuNjg3Njg3
XSAgWzxjMTYyNWEwMj5dID8gX3Jhd19zcGluX3VubG9ja19pcnErMHgyMi8weDUwClsgIDI0
MS42ODg2MDVdICBbPGMxNjIyMWY0Pl0gPyB3YWl0X2Zvcl9jb21wbGV0aW9uKzB4OTQvMHhk
MApbICAyNDEuNjg5NTAzXSAgWzxjMTA3ODI2Yj5dID8gdHJhY2VfaGFyZGlycXNfb24rMHhi
LzB4MTAKWyAgMjQxLjY5MDM1MF0gIFs8YzE2MjIxZmI+XSB3YWl0X2Zvcl9jb21wbGV0aW9u
KzB4OWIvMHhkMApbICAyNDEuNjkxMjE1XSAgWzxjMTA2NmFhMD5dID8gd2FrZV91cF9zdGF0
ZSsweDEwLzB4MTAKWyAgMjQxLjY5MjAwM10gIFs8YzEwOGFmOTA+XSA/IF9fY2FsbF9yY3Uu
Y29uc3Rwcm9wLjYxKzB4MjQwLzB4MjQwClsgIDI0MS42OTI5NzhdICBbPGMxMDg4NzNmPl0g
d2FpdF9yY3VfZ3ArMHgzZi8weDYwClsgIDI0MS42OTM3NDVdICBbPGMxMDg4NWEwPl0gPyBy
Y3VfcGFuaWMrMHgyMC8weDIwClsgIDI0MS42OTQ1MjJdICBbPGMxMDhjYjlmPl0gc3luY2hy
b25pemVfcmN1KzB4MWYvMHg0MApbICAyNDEuNjk1MzE1XSAgWzxjMTYwYjlhOT5dIF9jcHVf
ZG93bisweDEyOS8weDJjMApbICAyNDEuNjk2MDUzXSAgWzxjMTYwYmJiMj5dID8gY3B1X2Rv
d24rMHgxMi8weDQwClsgIDI0MS42OTY3MjRdICBbPGMxMmJkOWZmPl0gPyBsb2NrX2Rldmlj
ZV9ob3RwbHVnKzB4Zi8weDIwClsgIDI0MS42OTc1NjddICBbPGMxNjBiYmM0Pl0gY3B1X2Rv
d24rMHgyNC8weDQwClsgIDI0MS42OTgyNTFdICBbPGMxNjBiMTk3Pl0gX2RlYnVnX2hvdHBs
dWdfY3B1KzB4NzcvMHhiMApbICAyNDEuNjk5MDU4XSAgWzxjMTJjMmMxZT5dID8gX19wbGF0
Zm9ybV9kcml2ZXJfcmVnaXN0ZXIrMHgzZS8weDQwClsgIDI0MS42OTk5ODBdICBbPGMxOWNh
ZTE5Pl0gPyBwY2lfaW9tbXVfYWxsb2MrMHg1YS8weDVhClsgIDI0MS43MDA3NjldICBbPGMx
OWNhZTI1Pl0gZGVidWdfaG90cGx1Z19jcHUrMHhjLzB4MTAKWyAgMjQxLjcwMTU1Ml0gIFs8
YzE5YzZiODg+XSBkb19vbmVfaW5pdGNhbGwrMHg4ZC8weDEyYwpbICAyNDEuNzAyMzQxXSAg
WzxjMTE3MTI5ZD5dID8gc3RybGVuKzB4ZC8weDIwClsgIDI0MS43MDMwMDFdICBbPGMxMDU5
YzkzPl0gPyBwYXJhbWVxKzB4MTMvMHg3MApbICAyNDEuNzAzNjkxXSAgWzxjMTljNjUxMj5d
ID8gcmVwYWlyX2Vudl9zdHJpbmcrMHgxMi8weDUxClsgIDI0MS43MDQ1MTldICBbPGMxMDU5
ZWJmPl0gPyBwYXJzZV9hcmdzKzB4MWNmLzB4MzIwClsgIDI0MS43MDUyOTddICBbPGMxMDUy
YjZlPl0gPyBfX3VzZXJtb2RlaGVscGVyX3NldF9kaXNhYmxlX2RlcHRoKzB4M2UvMHg1MApb
ICAyNDEuNzA2NDUzXSAgWzxjMTljNmQxMj5dIGtlcm5lbF9pbml0X2ZyZWVhYmxlKzB4ZWIv
MHgxN2QKWyAgMjQxLjcwNzM1OV0gIFs8YzE5YzY1MDA+XSA/IGRvX2Vhcmx5X3BhcmFtKzB4
NzgvMHg3OApbICAyNDEuNzA4MTg4XSAgWzxjMTYwYjAyYj5dIGtlcm5lbF9pbml0KzB4Yi8w
eDEwMApbICAyNDEuNzA4OTA3XSAgWzxjMTYyNmNiNz5dIHJldF9mcm9tX2tlcm5lbF90aHJl
YWQrMHgxYi8weDI4ClsgIDI0MS43MDk4MDJdICBbPGMxNjBiMDIwPl0gPyByZXN0X2luaXQr
MHhjMC8weGMwClsgIDI0MS43MTA1NjRdIDMgbG9ja3MgaGVsZCBieSBzd2FwcGVyLzAvMToK
WyAgMjQxLjcxMTIyNl0gICMwOiAgKGRldmljZV9ob3RwbHVnX2xvY2speysuKy4rLn0sIGF0
OiBbPGMxMmJkOWZmPl0gbG9ja19kZXZpY2VfaG90cGx1ZysweGYvMHgyMApbICAyNDEuNzEy
NzYwXSAgIzE6ICAoY3B1X2FkZF9yZW1vdmVfbG9jayl7Ky4rLisufSwgYXQ6IFs8YzE2MGJi
YjI+XSBjcHVfZG93bisweDEyLzB4NDAKWyAgMjQxLjcxNDE5MF0gICMyOiAgKGNwdV9ob3Rw
bHVnLmxvY2speysuKy4rLn0sIGF0OiBbPGMxMDQyNDJkPl0gY3B1X2hvdHBsdWdfYmVnaW4r
MHgxZC8weDQwClsgIDI0MS43MTU2NTJdIHNlbmRpbmcgTk1JIHRvIGFsbCBDUFVzOgpbICAy
NDEuNzE2MzI0XSBOTUkgYmFja3RyYWNlIGZvciBjcHUgMQpbICAyNDEuNzE2ODk4XSBDUFU6
IDEgUElEOiA0NiBDb21tOiBraHVuZ3Rhc2tkIE5vdCB0YWludGVkIDMuMTIuMC1uZXh0LTIw
MTMxMTA4LTEwNjAxLWdiYWQ1NzBkICMzClsgIDI0MS43MTcyODddIHRhc2s6IGNmYjBmNTYw
IHRpOiBjZmIwMDAwMCB0YXNrLnRpOiBjZmIwMDAwMApbICAyNDEuNzE3Mjg3XSBFSVA6IDAw
NjA6WzxjMTAyYzhlNT5dIEVGTEFHUzogMDAwMTAwNDYgQ1BVOiAxClsgIDI0MS43MTcyODdd
IEVJUCBpcyBhdCBkZWZhdWx0X3NlbmRfSVBJX21hc2tfbG9naWNhbCsweDg1LzB4ZjAKWyAg
MjQxLjcxNzI4N10gRUFYOiAwMDAwMGMwMCBFQlg6IDAzMDAwMDAwIEVDWDogZmZmZmYwMDAg
RURYOiBmZmZmZjAwMApbICAyNDEuNzE3Mjg3XSBFU0k6IDAwMDAwMjA2IEVESTogMDAwMDAw
MDIgRUJQOiBjZmIwMWVkNCBFU1A6IGNmYjAxZWM0ClsgIDI0MS43MTcyODddICBEUzogMDA3
YiBFUzogMDA3YiBGUzogMDBkOCBHUzogMDBlMCBTUzogMDA2OApbICAyNDEuNzE3Mjg3XSBD
UjA6IDgwMDUwMDNiIENSMjogZmZmZmZmZmYgQ1IzOiAwMWEyZDAwMCBDUjQ6IDAwMDAwNmYw
ClsgIDI0MS43MTcyODddIFN0YWNrOgpbICAyNDEuNzE3Mjg3XSAgMDAwMDA4MDAgMDAwMDI3
MTAgMDAwMDdmZmYgMDAwMDAzZmYgY2ZiMDFlZTAgYzEwMmNhMTggMDAwMDI3MTAgY2ZiMDFl
ZjAKWyAgMjQxLjcxNzI4N10gIGMxMDJjYzBkIGMxODYxOTk0IGNkNDE3NDQwIGNmYjAxZjMw
IGMxMGE0NjMyIGMxODcxMjc4IGMxYTM3ZjZjIGMxOTI1Njg2ClsgIDI0MS43MTcyODddICAw
MDAwMDAwMiBjMTkyNTZjNyAwMDAwMDA3OCAwMDAwMDAwMiBjZDQxNzUzNCAwMDAwN2ZmZiBj
ZDQxNzQ0MCBjZDQxNzUzNApbICAyNDEuNzE3Mjg3XSBDYWxsIFRyYWNlOgpbICAyNDEuNzE3
Mjg3XSAgWzxjMTAyY2ExOD5dIGRlZmF1bHRfc2VuZF9JUElfYWxsKzB4NTgvMHg2MApbICAy
NDEuNzE3Mjg3XSAgWzxjMTAyY2MwZD5dIGFyY2hfdHJpZ2dlcl9hbGxfY3B1X2JhY2t0cmFj
ZSsweDNkLzB4NzAKWyAgMjQxLjcxNzI4N10gIFs8YzEwYTQ2MzI+XSB3YXRjaGRvZysweDJl
Mi8weDMwMApbICAyNDEuNzE3Mjg3XSAgWzxjMTBhNDM1MD5dID8gaHVuZ190YXNrX3Bhbmlj
KzB4MjAvMHgyMApbICAyNDEuNzE3Mjg3XSAgWzxjMTA1YjZkNz5dIGt0aHJlYWQrMHhhNy8w
eGMwClsgIDI0MS43MTcyODddICBbPGMxMDYwMDAwPl0gPyBzZXRfY3JlYXRlX2ZpbGVzX2Fz
KzB4MTAvMHgyMApbICAyNDEuNzE3Mjg3XSAgWzxjMTYyNmNiNz5dIHJldF9mcm9tX2tlcm5l
bF90aHJlYWQrMHgxYi8weDI4ClsgIDI0MS43MTcyODddICBbPGMxMDViNjMwPl0gPyBfX2t0
aHJlYWRfcGFya21lKzB4NjAvMHg2MApbICAyNDEuNzE3Mjg3XSBDb2RlOiAwMCBiMyBmZiBm
ZiBmNiBjNCAxMCA3NSBlZCBjMSBlMyAxOCA4OSA5OSAxMCBiMyBmZiBmZiA4OSBmOCAwOSBk
MCA4MCBjZSAwNCA4MyBmZiAwMiAwZiA0NCBjMiA4YiAxNSAwNCAwNiA5MyBjMSA4OSA4MiAw
MCBiMyBmZiBmZiA8Zjc+IGM2IDAwIDAyIDAwIDAwIDc0IDFiIGU4IDZlIGI5IDA0IDAwIDg5
IGYwIDUwIDlkIDhkIDc0IDI2IDAwClsgIDI0MS43MTcwMjhdIE5NSSBiYWNrdHJhY2UgZm9y
IGNwdSAwCi9rZXJuZWwvaTM4Ni1yYW5kY29uZmlnLWozLTExMTAxMzA4L2JhZDU3MGQ3NzAy
NGNiYTgwODEyNmQ2OGEyMDcyZjZmOGNlNjRjMjcvZG1lc2cteW9jdG8tbGtwLXN0MDEtNzoy
MDEzMTExMTAyMjYxNTppMzg2LXJhbmRjb25maWctajMtMTExMDEzMDg6My4xMi4wLW5leHQt
MjAxMzExMDgtMTA2MDEtZ2JhZDU3MGQ6Mwova2VybmVsL2kzODYtcmFuZGNvbmZpZy1qMy0x
MTEwMTMwOC9iYWQ1NzBkNzcwMjRjYmE4MDgxMjZkNjhhMjA3MmY2ZjhjZTY0YzI3L2RtZXNn
LXlvY3RvLXNuYi03OjIwMTMxMTEwMTgzMTM2OmkzODYtcmFuZGNvbmZpZy1qMy0xMTEwMTMw
ODozLjEyLjAtbmV4dC0yMDEzMTEwOC0xMDYwMS1nYmFkNTcwZDozCi9rZXJuZWwvaTM4Ni1y
YW5kY29uZmlnLWozLTExMTAxMzA4L2JhZDU3MGQ3NzAyNGNiYTgwODEyNmQ2OGEyMDcyZjZm
OGNlNjRjMjcvZG1lc2cteW9jdG8teGlhbi0zNToyMDEzMTExMDE0MDcyMjppMzg2LXJhbmRj
b25maWctajMtMTExMDEzMDg6My4xMi4wLW5leHQtMjAxMzExMDgtMTA2MDEtZ2JhZDU3MGQ6
Mwova2VybmVsL2kzODYtcmFuZGNvbmZpZy1qMy0xMTEwMTMwOC9iYWQ1NzBkNzcwMjRjYmE4
MDgxMjZkNjhhMjA3MmY2ZjhjZTY0YzI3L2RtZXNnLXlvY3RvLXhwcy0zOjIwMTMxMTExMDIy
OTA0OmkzODYtcmFuZGNvbmZpZy1qMy0xMTEwMTMwODozLjEyLjAtbmV4dC0yMDEzMTEwOC0x
MDYwMS1nYmFkNTcwZDozCi9rZXJuZWwvaTM4Ni1yYW5kY29uZmlnLWozLTExMTAxMzA4L2Jh
ZDU3MGQ3NzAyNGNiYTgwODEyNmQ2OGEyMDcyZjZmOGNlNjRjMjcvZG1lc2cteW9jdG8teGlh
bi00NDoyMDEzMTExMDE0MDcxNzppMzg2LXJhbmRjb25maWctajMtMTExMDEzMDg6My4xMi4w
LW5leHQtMjAxMzExMDgtMTA2MDEtZ2JhZDU3MGQ6Mwova2VybmVsL2kzODYtcmFuZGNvbmZp
Zy1qMy0xMTEwMTMwOC9iYWQ1NzBkNzcwMjRjYmE4MDgxMjZkNjhhMjA3MmY2ZjhjZTY0YzI3
L2RtZXNnLXlvY3RvLWlubi0zOjIwMTMxMTEwMTgzMTM0OmkzODYtcmFuZGNvbmZpZy1qMy0x
MTEwMTMwODozLjEyLjAtbmV4dC0yMDEzMTEwOC0xMDYwMS1nYmFkNTcwZDozCi9rZXJuZWwv
aTM4Ni1yYW5kY29uZmlnLWozLTExMTAxMzA4L2JhZDU3MGQ3NzAyNGNiYTgwODEyNmQ2OGEy
MDcyZjZmOGNlNjRjMjcvZG1lc2ctcXVhbnRhbC1hdGhlbnMtMzM6MjAxMzExMTAxODMxMzI6
aTM4Ni1yYW5kY29uZmlnLWozLTExMTAxMzA4OjMuMTIuMC1uZXh0LTIwMTMxMTA4LTEwNjAx
LWdiYWQ1NzBkOjMKL2tlcm5lbC9pMzg2LXJhbmRjb25maWctajMtMTExMDEzMDgvYmFkNTcw
ZDc3MDI0Y2JhODA4MTI2ZDY4YTIwNzJmNmY4Y2U2NGMyNy9kbWVzZy1xdWFudGFsLWNhaXJv
LTQ4OjIwMTMxMTEwMTQwNzIwOmkzODYtcmFuZGNvbmZpZy1qMy0xMTEwMTMwODozLjEyLjAt
bmV4dC0yMDEzMTEwOC0xMDYwMS1nYmFkNTcwZDozCi9rZXJuZWwvaTM4Ni1yYW5kY29uZmln
LWozLTExMTAxMzA4L2JhZDU3MGQ3NzAyNGNiYTgwODEyNmQ2OGEyMDcyZjZmOGNlNjRjMjcv
ZG1lc2ctcXVhbnRhbC1pbm4tMzE6MjAxMzExMTAxNDA3MjE6aTM4Ni1yYW5kY29uZmlnLWoz
LTExMTAxMzA4OjMuMTIuMC1uZXh0LTIwMTMxMTA4LTEwNjAxLWdiYWQ1NzBkOjMKL2tlcm5l
bC9pMzg2LXJhbmRjb25maWctajMtMTExMDEzMDgvYmFkNTcwZDc3MDI0Y2JhODA4MTI2ZDY4
YTIwNzJmNmY4Y2U2NGMyNy9kbWVzZy15b2N0by1iZW5zLTM6MjAxMzExMTAxNDA3MTY6aTM4
Ni1yYW5kY29uZmlnLWozLTExMTAxMzA4OjMuMTIuMC1uZXh0LTIwMTMxMTA4LTEwNjAxLWdi
YWQ1NzBkOjMKL2tlcm5lbC9pMzg2LXJhbmRjb25maWctajMtMTExMDEzMDgvYmFkNTcwZDc3
MDI0Y2JhODA4MTI2ZDY4YTIwNzJmNmY4Y2U2NGMyNy9kbWVzZy1xdWFudGFsLWxrcC1zdDAx
LTU6MjAxMzExMTEwMjI2MjA6aTM4Ni1yYW5kY29uZmlnLWozLTExMTAxMzA4OjMuMTIuMC1u
ZXh0LTIwMTMxMTA4LTEwNjAxLWdiYWQ1NzBkOjMKL2tlcm5lbC9pMzg2LXJhbmRjb25maWct
ajMtMTExMDEzMDgvYmFkNTcwZDc3MDI0Y2JhODA4MTI2ZDY4YTIwNzJmNmY4Y2U2NGMyNy9k
bWVzZy1xdWFudGFsLWxrcC10dDAyLTIyOjIwMTMxMTEwMDkyMzA1OmkzODYtcmFuZGNvbmZp
Zy1qMy0xMTEwMTMwODozLjEyLjAtbmV4dC0yMDEzMTEwOC0xMDYwMS1nYmFkNTcwZDozCi9r
ZXJuZWwvaTM4Ni1yYW5kY29uZmlnLWozLTExMTAxMzA4L2JhZDU3MGQ3NzAyNGNiYTgwODEy
NmQ2OGEyMDcyZjZmOGNlNjRjMjcvZG1lc2ctcXVhbnRhbC1pbm4tMToyMDEzMTExMDE0MDcx
OTppMzg2LXJhbmRjb25maWctajMtMTExMDEzMDg6My4xMi4wLW5leHQtMjAxMzExMDgtMTA2
MDEtZ2JhZDU3MGQ6Mwova2VybmVsL2kzODYtcmFuZGNvbmZpZy1qMy0xMTEwMTMwOC9iYWQ1
NzBkNzcwMjRjYmE4MDgxMjZkNjhhMjA3MmY2ZjhjZTY0YzI3L2RtZXNnLXF1YW50YWwtaW5u
LTExOjIwMTMxMTEwMTgzMTM3OmkzODYtcmFuZGNvbmZpZy1qMy0xMTEwMTMwODozLjEyLjAt
bmV4dC0yMDEzMTEwOC0xMDYwMS1nYmFkNTcwZDozCi9rZXJuZWwvaTM4Ni1yYW5kY29uZmln
LWozLTExMTAxMzA4L2JhZDU3MGQ3NzAyNGNiYTgwODEyNmQ2OGEyMDcyZjZmOGNlNjRjMjcv
ZG1lc2ctcXVhbnRhbC1jYWlyby0yNjoyMDEzMTExMDE0MDcyMDppMzg2LXJhbmRjb25maWct
ajMtMTExMDEzMDg6My4xMi4wLW5leHQtMjAxMzExMDgtMTA2MDEtZ2JhZDU3MGQ6Mwova2Vy
bmVsL2kzODYtcmFuZGNvbmZpZy1qMy0xMTEwMTMwOC9iYWQ1NzBkNzcwMjRjYmE4MDgxMjZk
NjhhMjA3MmY2ZjhjZTY0YzI3L2RtZXNnLXlvY3RvLWlubi05OjIwMTMxMTEwMTgzMTM2Omkz
ODYtcmFuZGNvbmZpZy1qMy0xMTEwMTMwODozLjEyLjAtbmV4dC0yMDEzMTEwOC0xMDYwMS1n
YmFkNTcwZDozCjM6MTY6MTYgYWxsX2dvb2Q6YmFkOmFsbF9iYWQgYm9vdHMKCg==

--M9NhX3UHpAaciwkO
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="config-3.12.0-next-20131108-10601-gbad570d"

#
# Automatically generated file; DO NOT EDIT.
# Linux/i386 3.12.0 Kernel Configuration
#
# CONFIG_64BIT is not set
CONFIG_X86_32=y
CONFIG_X86=y
CONFIG_INSTRUCTION_DECODER=y
CONFIG_OUTPUT_FORMAT="elf32-i386"
CONFIG_ARCH_DEFCONFIG="arch/x86/configs/i386_defconfig"
CONFIG_LOCKDEP_SUPPORT=y
CONFIG_STACKTRACE_SUPPORT=y
CONFIG_HAVE_LATENCYTOP_SUPPORT=y
CONFIG_MMU=y
CONFIG_NEED_DMA_MAP_STATE=y
CONFIG_NEED_SG_DMA_LENGTH=y
CONFIG_GENERIC_ISA_DMA=y
CONFIG_GENERIC_BUG=y
CONFIG_GENERIC_HWEIGHT=y
CONFIG_ARCH_MAY_HAVE_PC_FDC=y
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
# CONFIG_ZONE_DMA32 is not set
# CONFIG_AUDIT_ARCH is not set
CONFIG_ARCH_SUPPORTS_OPTIMIZED_INLINING=y
CONFIG_ARCH_SUPPORTS_DEBUG_PAGEALLOC=y
CONFIG_X86_32_SMP=y
CONFIG_X86_HT=y
CONFIG_ARCH_HWEIGHT_CFLAGS="-fcall-saved-ecx -fcall-saved-edx"
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
# CONFIG_KERNEL_UNCOMPRESSED is not set
# CONFIG_KERNEL_GZIP is not set
# CONFIG_KERNEL_BZIP2 is not set
# CONFIG_KERNEL_LZMA is not set
# CONFIG_KERNEL_XZ is not set
CONFIG_KERNEL_LZO=y
# CONFIG_KERNEL_LZ4 is not set
CONFIG_DEFAULT_HOSTNAME="(none)"
# CONFIG_SYSVIPC is not set
# CONFIG_POSIX_MQUEUE is not set
# CONFIG_FHANDLE is not set
# CONFIG_AUDIT is not set

#
# IRQ subsystem
#
CONFIG_GENERIC_IRQ_PROBE=y
CONFIG_GENERIC_IRQ_SHOW=y
CONFIG_GENERIC_PENDING_IRQ=y
CONFIG_GENERIC_IRQ_CHIP=y
CONFIG_IRQ_DOMAIN=y
CONFIG_IRQ_DOMAIN_DEBUG=y
CONFIG_IRQ_FORCED_THREADING=y
CONFIG_SPARSE_IRQ=y
CONFIG_CLOCKSOURCE_WATCHDOG=y
CONFIG_KTIME_SCALAR=y
CONFIG_GENERIC_CLOCKEVENTS=y
CONFIG_GENERIC_CLOCKEVENTS_BUILD=y
CONFIG_GENERIC_CLOCKEVENTS_BROADCAST=y
CONFIG_GENERIC_CLOCKEVENTS_MIN_ADJUST=y
CONFIG_GENERIC_CMOS_UPDATE=y

#
# Timers subsystem
#
CONFIG_TICK_ONESHOT=y
CONFIG_NO_HZ_COMMON=y
# CONFIG_HZ_PERIODIC is not set
CONFIG_NO_HZ_IDLE=y
# CONFIG_NO_HZ is not set
# CONFIG_HIGH_RES_TIMERS is not set

#
# CPU/Task time and stats accounting
#
# CONFIG_TICK_CPU_ACCOUNTING is not set
CONFIG_IRQ_TIME_ACCOUNTING=y
CONFIG_BSD_PROCESS_ACCT=y
# CONFIG_BSD_PROCESS_ACCT_V3 is not set
# CONFIG_TASKSTATS is not set

#
# RCU Subsystem
#
CONFIG_TREE_PREEMPT_RCU=y
CONFIG_PREEMPT_RCU=y
CONFIG_RCU_STALL_COMMON=y
CONFIG_RCU_FANOUT=32
CONFIG_RCU_FANOUT_LEAF=16
# CONFIG_RCU_FANOUT_EXACT is not set
# CONFIG_RCU_FAST_NO_HZ is not set
# CONFIG_TREE_RCU_TRACE is not set
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
CONFIG_CGROUP_DEBUG=y
CONFIG_CGROUP_FREEZER=y
# CONFIG_CGROUP_DEVICE is not set
# CONFIG_CPUSETS is not set
# CONFIG_CGROUP_CPUACCT is not set
# CONFIG_RESOURCE_COUNTERS is not set
# CONFIG_CGROUP_PERF is not set
CONFIG_CGROUP_SCHED=y
CONFIG_FAIR_GROUP_SCHED=y
CONFIG_CFS_BANDWIDTH=y
# CONFIG_RT_GROUP_SCHED is not set
CONFIG_CHECKPOINT_RESTORE=y
CONFIG_NAMESPACES=y
# CONFIG_UTS_NS is not set
# CONFIG_USER_NS is not set
CONFIG_PID_NS=y
CONFIG_NET_NS=y
CONFIG_UIDGID_STRICT_TYPE_CHECKS=y
CONFIG_SCHED_AUTOGROUP=y
# CONFIG_SYSFS_DEPRECATED is not set
CONFIG_RELAY=y
CONFIG_BLK_DEV_INITRD=y
CONFIG_INITRAMFS_SOURCE=""
CONFIG_RD_GZIP=y
# CONFIG_RD_BZIP2 is not set
# CONFIG_RD_LZMA is not set
# CONFIG_RD_XZ is not set
# CONFIG_RD_LZO is not set
# CONFIG_RD_LZ4 is not set
# CONFIG_CC_OPTIMIZE_FOR_SIZE is not set
CONFIG_ANON_INODES=y
CONFIG_HAVE_UID16=y
CONFIG_SYSCTL_EXCEPTION_TRACE=y
CONFIG_HAVE_PCSPKR_PLATFORM=y
CONFIG_EXPERT=y
# CONFIG_UID16 is not set
CONFIG_KALLSYMS=y
CONFIG_KALLSYMS_ALL=y
CONFIG_PRINTK=y
CONFIG_BUG=y
# CONFIG_PCSPKR_PLATFORM is not set
# CONFIG_BASE_FULL is not set
CONFIG_FUTEX=y
CONFIG_EPOLL=y
CONFIG_SIGNALFD=y
CONFIG_TIMERFD=y
CONFIG_EVENTFD=y
CONFIG_SHMEM=y
CONFIG_AIO=y
CONFIG_PCI_QUIRKS=y
CONFIG_EMBEDDED=y
CONFIG_HAVE_PERF_EVENTS=y

#
# Kernel Performance Events And Counters
#
CONFIG_PERF_EVENTS=y
# CONFIG_DEBUG_PERF_USE_VMALLOC is not set
CONFIG_VM_EVENT_COUNTERS=y
# CONFIG_COMPAT_BRK is not set
# CONFIG_SLAB is not set
# CONFIG_SLUB is not set
CONFIG_SLOB=y
# CONFIG_PROFILING is not set
CONFIG_HAVE_OPROFILE=y
CONFIG_OPROFILE_NMI_TIMER=y
CONFIG_JUMP_LABEL=y
# CONFIG_HAVE_64BIT_ALIGNED_ACCESS is not set
CONFIG_HAVE_EFFICIENT_UNALIGNED_ACCESS=y
CONFIG_ARCH_USE_BUILTIN_BSWAP=y
CONFIG_HAVE_IOREMAP_PROT=y
CONFIG_HAVE_KPROBES=y
CONFIG_HAVE_KRETPROBES=y
CONFIG_HAVE_OPTPROBES=y
CONFIG_HAVE_KPROBES_ON_FTRACE=y
CONFIG_HAVE_ARCH_TRACEHOOK=y
CONFIG_HAVE_DMA_ATTRS=y
CONFIG_HAVE_DMA_CONTIGUOUS=y
CONFIG_GENERIC_SMP_IDLE_THREAD=y
CONFIG_HAVE_REGS_AND_STACK_ACCESS_API=y
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
CONFIG_ARCH_WANT_IPC_PARSE_VERSION=y
CONFIG_HAVE_ARCH_SECCOMP_FILTER=y
CONFIG_SECCOMP_FILTER=y
CONFIG_HAVE_IRQ_TIME_ACCOUNTING=y
CONFIG_HAVE_ARCH_TRANSPARENT_HUGEPAGE=y
CONFIG_HAVE_ARCH_SOFT_DIRTY=y
CONFIG_MODULES_USE_ELF_REL=y
CONFIG_CLONE_BACKWARDS=y
CONFIG_OLD_SIGSUSPEND3=y
CONFIG_OLD_SIGACTION=y

#
# GCOV-based kernel profiling
#
# CONFIG_GCOV_KERNEL is not set
CONFIG_HAVE_GENERIC_DMA_COHERENT=y
CONFIG_RT_MUTEXES=y
CONFIG_BASE_SMALL=1
# CONFIG_SYSTEM_TRUSTED_KEYRING is not set
# CONFIG_MODULES is not set
CONFIG_STOP_MACHINE=y
# CONFIG_BLOCK is not set
CONFIG_PADATA=y
CONFIG_UNINLINE_SPIN_UNLOCK=y
CONFIG_FREEZER=y

#
# Processor type and features
#
CONFIG_ZONE_DMA=y
CONFIG_SMP=y
# CONFIG_X86_MPPARSE is not set
CONFIG_X86_BIGSMP=y
# CONFIG_X86_EXTENDED_PLATFORM is not set
# CONFIG_X86_INTEL_LPSS is not set
CONFIG_X86_32_IRIS=y
# CONFIG_SCHED_OMIT_FRAME_POINTER is not set
CONFIG_HYPERVISOR_GUEST=y
CONFIG_PARAVIRT=y
# CONFIG_PARAVIRT_DEBUG is not set
# CONFIG_PARAVIRT_SPINLOCKS is not set
# CONFIG_XEN is not set
# CONFIG_XEN_PRIVILEGED_GUEST is not set
CONFIG_KVM_GUEST=y
# CONFIG_KVM_DEBUG_FS is not set
# CONFIG_LGUEST_GUEST is not set
# CONFIG_PARAVIRT_TIME_ACCOUNTING is not set
CONFIG_PARAVIRT_CLOCK=y
CONFIG_NO_BOOTMEM=y
# CONFIG_MEMTEST is not set
# CONFIG_M486 is not set
# CONFIG_M586 is not set
# CONFIG_M586TSC is not set
# CONFIG_M586MMX is not set
CONFIG_M686=y
# CONFIG_MPENTIUMII is not set
# CONFIG_MPENTIUMIII is not set
# CONFIG_MPENTIUMM is not set
# CONFIG_MPENTIUM4 is not set
# CONFIG_MK6 is not set
# CONFIG_MK7 is not set
# CONFIG_MK8 is not set
# CONFIG_MCRUSOE is not set
# CONFIG_MEFFICEON is not set
# CONFIG_MWINCHIPC6 is not set
# CONFIG_MWINCHIP3D is not set
# CONFIG_MELAN is not set
# CONFIG_MGEODEGX1 is not set
# CONFIG_MGEODE_LX is not set
# CONFIG_MCYRIXIII is not set
# CONFIG_MVIAC3_2 is not set
# CONFIG_MVIAC7 is not set
# CONFIG_MCORE2 is not set
# CONFIG_MATOM is not set
CONFIG_X86_GENERIC=y
CONFIG_X86_INTERNODE_CACHE_SHIFT=6
CONFIG_X86_L1_CACHE_SHIFT=6
# CONFIG_X86_PPRO_FENCE is not set
CONFIG_X86_INTEL_USERCOPY=y
CONFIG_X86_USE_PPRO_CHECKSUM=y
CONFIG_X86_TSC=y
CONFIG_X86_CMPXCHG64=y
CONFIG_X86_CMOV=y
CONFIG_X86_MINIMUM_CPU_FAMILY=5
CONFIG_X86_DEBUGCTLMSR=y
# CONFIG_PROCESSOR_SELECT is not set
CONFIG_CPU_SUP_INTEL=y
CONFIG_CPU_SUP_CYRIX_32=y
CONFIG_CPU_SUP_AMD=y
CONFIG_CPU_SUP_CENTAUR=y
CONFIG_CPU_SUP_TRANSMETA_32=y
CONFIG_CPU_SUP_UMC_32=y
CONFIG_HPET_TIMER=y
# CONFIG_DMI is not set
CONFIG_NR_CPUS=32
# CONFIG_SCHED_SMT is not set
# CONFIG_SCHED_MC is not set
# CONFIG_PREEMPT_NONE is not set
# CONFIG_PREEMPT_VOLUNTARY is not set
CONFIG_PREEMPT=y
CONFIG_PREEMPT_COUNT=y
CONFIG_X86_LOCAL_APIC=y
CONFIG_X86_IO_APIC=y
# CONFIG_X86_REROUTE_FOR_BROKEN_BOOT_IRQS is not set
CONFIG_X86_MCE=y
CONFIG_X86_MCE_INTEL=y
CONFIG_X86_MCE_AMD=y
# CONFIG_X86_ANCIENT_MCE is not set
CONFIG_X86_MCE_THRESHOLD=y
# CONFIG_X86_MCE_INJECT is not set
CONFIG_X86_THERMAL_VECTOR=y
# CONFIG_VM86 is not set
# CONFIG_TOSHIBA is not set
# CONFIG_I8K is not set
# CONFIG_X86_REBOOTFIXUPS is not set
CONFIG_MICROCODE=y
CONFIG_MICROCODE_INTEL=y
# CONFIG_MICROCODE_AMD is not set
CONFIG_MICROCODE_OLD_INTERFACE=y
CONFIG_MICROCODE_INTEL_LIB=y
CONFIG_MICROCODE_INTEL_EARLY=y
# CONFIG_MICROCODE_AMD_EARLY is not set
CONFIG_MICROCODE_EARLY=y
CONFIG_X86_MSR=y
CONFIG_X86_CPUID=y
# CONFIG_NOHIGHMEM is not set
# CONFIG_HIGHMEM4G is not set
CONFIG_HIGHMEM64G=y
CONFIG_VMSPLIT_3G=y
# CONFIG_VMSPLIT_2G is not set
# CONFIG_VMSPLIT_1G is not set
CONFIG_PAGE_OFFSET=0xC0000000
CONFIG_HIGHMEM=y
CONFIG_X86_PAE=y
CONFIG_ARCH_PHYS_ADDR_T_64BIT=y
CONFIG_ARCH_DMA_ADDR_T_64BIT=y
# CONFIG_NUMA is not set
CONFIG_NEED_NODE_MEMMAP_SIZE=y
CONFIG_ARCH_FLATMEM_ENABLE=y
CONFIG_ARCH_SPARSEMEM_ENABLE=y
CONFIG_ARCH_SELECT_MEMORY_MODEL=y
CONFIG_ILLEGAL_POINTER_VALUE=0
CONFIG_SELECT_MEMORY_MODEL=y
# CONFIG_FLATMEM_MANUAL is not set
CONFIG_SPARSEMEM_MANUAL=y
CONFIG_SPARSEMEM=y
CONFIG_HAVE_MEMORY_PRESENT=y
CONFIG_SPARSEMEM_STATIC=y
CONFIG_HAVE_MEMBLOCK=y
CONFIG_HAVE_MEMBLOCK_NODE_MAP=y
CONFIG_ARCH_DISCARD_MEMBLOCK=y
# CONFIG_HAVE_BOOTMEM_INFO_NODE is not set
CONFIG_MEMORY_HOTPLUG=y
CONFIG_MEMORY_HOTPLUG_SPARSE=y
# CONFIG_MEMORY_HOTREMOVE is not set
CONFIG_SPLIT_PTLOCK_CPUS=4
CONFIG_ARCH_ENABLE_SPLIT_PMD_PTLOCK=y
CONFIG_COMPACTION=y
CONFIG_MIGRATION=y
CONFIG_PHYS_ADDR_T_64BIT=y
CONFIG_ZONE_DMA_FLAG=1
CONFIG_VIRT_TO_BUS=y
CONFIG_KSM=y
CONFIG_DEFAULT_MMAP_MIN_ADDR=4096
CONFIG_TRANSPARENT_HUGEPAGE=y
CONFIG_TRANSPARENT_HUGEPAGE_ALWAYS=y
# CONFIG_TRANSPARENT_HUGEPAGE_MADVISE is not set
# CONFIG_CROSS_MEMORY_ATTACH is not set
CONFIG_CLEANCACHE=y
# CONFIG_CMA is not set
# CONFIG_ZBUD is not set
# CONFIG_MEM_SOFT_DIRTY is not set
CONFIG_HIGHPTE=y
CONFIG_X86_CHECK_BIOS_CORRUPTION=y
# CONFIG_X86_BOOTPARAM_MEMORY_CORRUPTION_CHECK is not set
CONFIG_X86_RESERVE_LOW=64
# CONFIG_MATH_EMULATION is not set
# CONFIG_MTRR is not set
CONFIG_ARCH_RANDOM=y
# CONFIG_X86_SMAP is not set
# CONFIG_EFI is not set
CONFIG_SECCOMP=y
CONFIG_CC_STACKPROTECTOR=y
# CONFIG_HZ_100 is not set
# CONFIG_HZ_250 is not set
# CONFIG_HZ_300 is not set
CONFIG_HZ_1000=y
CONFIG_HZ=1000
# CONFIG_SCHED_HRTICK is not set
# CONFIG_KEXEC is not set
# CONFIG_CRASH_DUMP is not set
CONFIG_PHYSICAL_START=0x1000000
CONFIG_RELOCATABLE=y
# CONFIG_RANDOMIZE_BASE is not set
CONFIG_X86_NEED_RELOCS=y
CONFIG_PHYSICAL_ALIGN=0x200000
CONFIG_HOTPLUG_CPU=y
CONFIG_BOOTPARAM_HOTPLUG_CPU0=y
CONFIG_DEBUG_HOTPLUG_CPU0=y
CONFIG_COMPAT_VDSO=y
# CONFIG_CMDLINE_BOOL is not set
CONFIG_ARCH_ENABLE_MEMORY_HOTPLUG=y
CONFIG_ARCH_ENABLE_MEMORY_HOTREMOVE=y

#
# Power management and ACPI options
#
CONFIG_SUSPEND=y
CONFIG_SUSPEND_FREEZER=y
CONFIG_PM_SLEEP=y
CONFIG_PM_SLEEP_SMP=y
CONFIG_PM_AUTOSLEEP=y
CONFIG_PM_WAKELOCKS=y
CONFIG_PM_WAKELOCKS_LIMIT=100
# CONFIG_PM_WAKELOCKS_GC is not set
# CONFIG_PM_RUNTIME is not set
CONFIG_PM=y
# CONFIG_PM_DEBUG is not set
# CONFIG_WQ_POWER_EFFICIENT_DEFAULT is not set
CONFIG_ACPI=y
CONFIG_ACPI_SLEEP=y
# CONFIG_ACPI_EC_DEBUGFS is not set
CONFIG_ACPI_AC=y
CONFIG_ACPI_BATTERY=y
CONFIG_ACPI_BUTTON=y
# CONFIG_ACPI_VIDEO is not set
CONFIG_ACPI_FAN=y
# CONFIG_ACPI_DOCK is not set
CONFIG_ACPI_PROCESSOR=y
CONFIG_ACPI_HOTPLUG_CPU=y
# CONFIG_ACPI_PROCESSOR_AGGREGATOR is not set
CONFIG_ACPI_THERMAL=y
CONFIG_ACPI_CUSTOM_DSDT_FILE=""
# CONFIG_ACPI_CUSTOM_DSDT is not set
# CONFIG_ACPI_INITRD_TABLE_OVERRIDE is not set
CONFIG_ACPI_BLACKLIST_YEAR=0
# CONFIG_ACPI_DEBUG is not set
# CONFIG_ACPI_PCI_SLOT is not set
CONFIG_X86_PM_TIMER=y
CONFIG_ACPI_CONTAINER=y
# CONFIG_ACPI_HOTPLUG_MEMORY is not set
# CONFIG_ACPI_SBS is not set
# CONFIG_ACPI_HED is not set
# CONFIG_ACPI_CUSTOM_METHOD is not set
# CONFIG_ACPI_APEI is not set
# CONFIG_ACPI_EXTLOG is not set
CONFIG_SFI=y
CONFIG_X86_APM_BOOT=y
CONFIG_APM=y
CONFIG_APM_IGNORE_USER_SUSPEND=y
CONFIG_APM_DO_ENABLE=y
# CONFIG_APM_CPU_IDLE is not set
CONFIG_APM_DISPLAY_BLANK=y
# CONFIG_APM_ALLOW_INTS is not set

#
# CPU Frequency scaling
#
# CONFIG_CPU_FREQ is not set

#
# CPU Idle
#
CONFIG_CPU_IDLE=y
# CONFIG_CPU_IDLE_MULTIPLE_DRIVERS is not set
CONFIG_CPU_IDLE_GOV_LADDER=y
CONFIG_CPU_IDLE_GOV_MENU=y
# CONFIG_ARCH_NEEDS_CPU_IDLE_COUPLED is not set
# CONFIG_INTEL_IDLE is not set

#
# Bus options (PCI etc.)
#
CONFIG_PCI=y
CONFIG_PCI_GOBIOS=y
# CONFIG_PCI_GOMMCONFIG is not set
# CONFIG_PCI_GODIRECT is not set
# CONFIG_PCI_GOANY is not set
CONFIG_PCI_BIOS=y
CONFIG_PCI_DOMAINS=y
# CONFIG_PCI_CNB20LE_QUIRK is not set
CONFIG_PCIEPORTBUS=y
CONFIG_PCIEAER=y
CONFIG_PCIE_ECRC=y
CONFIG_PCIEAER_INJECT=y
CONFIG_PCIEASPM=y
CONFIG_PCIEASPM_DEBUG=y
CONFIG_PCIEASPM_DEFAULT=y
# CONFIG_PCIEASPM_POWERSAVE is not set
# CONFIG_PCIEASPM_PERFORMANCE is not set
# CONFIG_PCI_MSI is not set
# CONFIG_PCI_DEBUG is not set
CONFIG_PCI_REALLOC_ENABLE_AUTO=y
# CONFIG_PCI_STUB is not set
# CONFIG_HT_IRQ is not set
CONFIG_PCI_ATS=y
CONFIG_PCI_IOV=y
CONFIG_PCI_PRI=y
CONFIG_PCI_PASID=y
# CONFIG_PCI_IOAPIC is not set
CONFIG_PCI_LABEL=y

#
# PCI host controller drivers
#
CONFIG_ISA_DMA_API=y
# CONFIG_ISA is not set
CONFIG_SCx200=y
CONFIG_SCx200HR_TIMER=y
CONFIG_ALIX=y
CONFIG_NET5501=y
CONFIG_AMD_NB=y
CONFIG_PCCARD=y
CONFIG_PCMCIA=y
# CONFIG_PCMCIA_LOAD_CIS is not set
# CONFIG_CARDBUS is not set

#
# PC-card bridges
#
CONFIG_YENTA=y
# CONFIG_YENTA_O2 is not set
# CONFIG_YENTA_RICOH is not set
# CONFIG_YENTA_TI is not set
# CONFIG_YENTA_TOSHIBA is not set
CONFIG_PD6729=y
CONFIG_I82092=y
CONFIG_PCCARD_NONSTATIC=y
# CONFIG_HOTPLUG_PCI is not set
CONFIG_RAPIDIO=y
# CONFIG_RAPIDIO_TSI721 is not set
CONFIG_RAPIDIO_DISC_TIMEOUT=30
# CONFIG_RAPIDIO_ENABLE_RX_TX_PORTS is not set
CONFIG_RAPIDIO_DMA_ENGINE=y
# CONFIG_RAPIDIO_DEBUG is not set
CONFIG_RAPIDIO_ENUM_BASIC=y

#
# RapidIO Switch drivers
#
CONFIG_RAPIDIO_TSI57X=y
CONFIG_RAPIDIO_CPS_XX=y
CONFIG_RAPIDIO_TSI568=y
CONFIG_RAPIDIO_CPS_GEN2=y
CONFIG_X86_SYSFB=y

#
# Executable file formats / Emulations
#
CONFIG_BINFMT_ELF=y
CONFIG_ARCH_BINFMT_ELF_RANDOMIZE_PIE=y
CONFIG_BINFMT_SCRIPT=y
CONFIG_HAVE_AOUT=y
# CONFIG_BINFMT_AOUT is not set
CONFIG_BINFMT_MISC=y
# CONFIG_COREDUMP is not set
CONFIG_HAVE_ATOMIC_IOMAP=y
CONFIG_NET=y

#
# Networking options
#
# CONFIG_PACKET is not set
CONFIG_UNIX=y
# CONFIG_UNIX_DIAG is not set
# CONFIG_NET_KEY is not set
# CONFIG_INET is not set
# CONFIG_NETWORK_SECMARK is not set
# CONFIG_NETWORK_PHY_TIMESTAMPING is not set
# CONFIG_NETFILTER is not set
# CONFIG_ATM is not set
# CONFIG_BRIDGE is not set
# CONFIG_VLAN_8021Q is not set
# CONFIG_DECNET is not set
# CONFIG_LLC2 is not set
# CONFIG_IPX is not set
# CONFIG_ATALK is not set
# CONFIG_X25 is not set
# CONFIG_LAPB is not set
# CONFIG_PHONET is not set
# CONFIG_IEEE802154 is not set
# CONFIG_NET_SCHED is not set
# CONFIG_DCB is not set
# CONFIG_DNS_RESOLVER is not set
# CONFIG_BATMAN_ADV is not set
# CONFIG_OPENVSWITCH is not set
# CONFIG_VSOCKETS is not set
# CONFIG_NETLINK_MMAP is not set
# CONFIG_NETLINK_DIAG is not set
# CONFIG_NET_MPLS_GSO is not set
# CONFIG_HSR is not set
# CONFIG_NETPRIO_CGROUP is not set
CONFIG_NET_RX_BUSY_POLL=y
CONFIG_BQL=y

#
# Network testing
#
# CONFIG_HAMRADIO is not set
# CONFIG_CAN is not set
# CONFIG_IRDA is not set
# CONFIG_BT is not set
CONFIG_WIRELESS=y
# CONFIG_CFG80211 is not set
# CONFIG_LIB80211 is not set

#
# CFG80211 needs to be enabled for MAC80211
#
# CONFIG_WIMAX is not set
# CONFIG_RFKILL is not set
# CONFIG_NET_9P is not set
# CONFIG_CAIF is not set
# CONFIG_NFC is not set

#
# Device Drivers
#

#
# Generic Driver Options
#
CONFIG_UEVENT_HELPER_PATH=""
# CONFIG_DEVTMPFS is not set
# CONFIG_STANDALONE is not set
# CONFIG_PREVENT_FIRMWARE_BUILD is not set
CONFIG_FW_LOADER=y
CONFIG_FIRMWARE_IN_KERNEL=y
CONFIG_EXTRA_FIRMWARE=""
# CONFIG_FW_LOADER_USER_HELPER is not set
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
# CONFIG_CONNECTOR is not set
# CONFIG_MTD is not set
CONFIG_PARPORT=y
CONFIG_ARCH_MIGHT_HAVE_PC_PARPORT=y
# CONFIG_PARPORT_PC is not set
# CONFIG_PARPORT_GSC is not set
# CONFIG_PARPORT_AX88796 is not set
CONFIG_PARPORT_1284=y
CONFIG_PARPORT_NOT_PC=y
CONFIG_PNP=y
CONFIG_PNP_DEBUG_MESSAGES=y

#
# Protocols
#
CONFIG_PNPACPI=y

#
# Misc devices
#
CONFIG_SENSORS_LIS3LV02D=y
CONFIG_AD525X_DPOT=y
# CONFIG_AD525X_DPOT_I2C is not set
CONFIG_DUMMY_IRQ=y
# CONFIG_IBM_ASM is not set
CONFIG_PHANTOM=y
CONFIG_INTEL_MID_PTI=y
# CONFIG_SGI_IOC4 is not set
CONFIG_TIFM_CORE=y
# CONFIG_TIFM_7XX1 is not set
CONFIG_ICS932S401=y
CONFIG_ATMEL_SSC=y
CONFIG_ENCLOSURE_SERVICES=y
CONFIG_CS5535_MFGPT=y
CONFIG_CS5535_MFGPT_DEFAULT_IRQ=7
CONFIG_CS5535_CLOCK_EVENT_SRC=y
CONFIG_HP_ILO=y
# CONFIG_APDS9802ALS is not set
CONFIG_ISL29003=y
CONFIG_ISL29020=y
CONFIG_SENSORS_TSL2550=y
CONFIG_SENSORS_BH1780=y
CONFIG_SENSORS_BH1770=y
CONFIG_SENSORS_APDS990X=y
CONFIG_HMC6352=y
# CONFIG_DS1682 is not set
# CONFIG_VMWARE_BALLOON is not set
CONFIG_BMP085=y
CONFIG_BMP085_I2C=y
# CONFIG_PCH_PHUB is not set
CONFIG_USB_SWITCH_FSA9480=y
# CONFIG_SRAM is not set
# CONFIG_C2PORT is not set

#
# EEPROM support
#
CONFIG_EEPROM_AT24=y
CONFIG_EEPROM_LEGACY=y
# CONFIG_EEPROM_MAX6875 is not set
CONFIG_EEPROM_93CX6=y
CONFIG_CB710_CORE=y
CONFIG_CB710_DEBUG=y
CONFIG_CB710_DEBUG_ASSUMPTIONS=y

#
# Texas Instruments shared transport line discipline
#
# CONFIG_TI_ST is not set
CONFIG_SENSORS_LIS3_I2C=y

#
# Altera FPGA firmware download module
#
# CONFIG_ALTERA_STAPL is not set
CONFIG_INTEL_MEI=y
# CONFIG_INTEL_MEI_ME is not set
CONFIG_VMWARE_VMCI=y

#
# Intel MIC Host Driver
#

#
# Intel MIC Card Driver
#
CONFIG_HAVE_IDE=y

#
# SCSI device support
#
CONFIG_SCSI_MOD=y
# CONFIG_SCSI_DMA is not set
# CONFIG_SCSI_NETLINK is not set
CONFIG_FUSION=y
CONFIG_FUSION_MAX_SGE=128
# CONFIG_FUSION_LOGGING is not set

#
# IEEE 1394 (FireWire) support
#
CONFIG_FIREWIRE=y
# CONFIG_FIREWIRE_OHCI is not set
CONFIG_FIREWIRE_NOSY=y
CONFIG_I2O=y
CONFIG_I2O_LCT_NOTIFY_ON_CHANGES=y
CONFIG_I2O_EXT_ADAPTEC=y
CONFIG_I2O_EXT_ADAPTEC_DMA64=y
# CONFIG_I2O_CONFIG is not set
# CONFIG_I2O_BUS is not set
CONFIG_I2O_PROC=y
# CONFIG_MACINTOSH_DRIVERS is not set
# CONFIG_NETDEVICES is not set
# CONFIG_VHOST_NET is not set

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
# CONFIG_INPUT_MOUSEDEV_PSAUX is not set
CONFIG_INPUT_MOUSEDEV_SCREEN_X=1024
CONFIG_INPUT_MOUSEDEV_SCREEN_Y=768
CONFIG_INPUT_JOYDEV=y
# CONFIG_INPUT_EVDEV is not set
CONFIG_INPUT_EVBUG=y

#
# Input Device Drivers
#
CONFIG_INPUT_KEYBOARD=y
CONFIG_KEYBOARD_ADP5588=y
# CONFIG_KEYBOARD_ADP5589 is not set
CONFIG_KEYBOARD_ATKBD=y
# CONFIG_KEYBOARD_QT1070 is not set
CONFIG_KEYBOARD_QT2160=y
CONFIG_KEYBOARD_LKKBD=y
CONFIG_KEYBOARD_GPIO=y
CONFIG_KEYBOARD_GPIO_POLLED=y
CONFIG_KEYBOARD_TCA6416=y
CONFIG_KEYBOARD_TCA8418=y
# CONFIG_KEYBOARD_MATRIX is not set
CONFIG_KEYBOARD_LM8323=y
CONFIG_KEYBOARD_LM8333=y
CONFIG_KEYBOARD_MAX7359=y
CONFIG_KEYBOARD_MCS=y
CONFIG_KEYBOARD_MPR121=y
# CONFIG_KEYBOARD_NEWTON is not set
CONFIG_KEYBOARD_OPENCORES=y
CONFIG_KEYBOARD_STOWAWAY=y
CONFIG_KEYBOARD_SUNKBD=y
# CONFIG_KEYBOARD_SH_KEYSC is not set
CONFIG_KEYBOARD_TC3589X=y
# CONFIG_KEYBOARD_TWL4030 is not set
# CONFIG_KEYBOARD_XTKBD is not set
CONFIG_INPUT_LEDS=y
CONFIG_INPUT_MOUSE=y
# CONFIG_MOUSE_PS2 is not set
CONFIG_MOUSE_SERIAL=y
CONFIG_MOUSE_APPLETOUCH=y
CONFIG_MOUSE_BCM5974=y
# CONFIG_MOUSE_CYAPA is not set
CONFIG_MOUSE_VSXXXAA=y
CONFIG_MOUSE_GPIO=y
CONFIG_MOUSE_SYNAPTICS_I2C=y
# CONFIG_MOUSE_SYNAPTICS_USB is not set
CONFIG_INPUT_JOYSTICK=y
CONFIG_JOYSTICK_ANALOG=y
# CONFIG_JOYSTICK_A3D is not set
CONFIG_JOYSTICK_ADI=y
CONFIG_JOYSTICK_COBRA=y
CONFIG_JOYSTICK_GF2K=y
CONFIG_JOYSTICK_GRIP=y
CONFIG_JOYSTICK_GRIP_MP=y
CONFIG_JOYSTICK_GUILLEMOT=y
# CONFIG_JOYSTICK_INTERACT is not set
CONFIG_JOYSTICK_SIDEWINDER=y
# CONFIG_JOYSTICK_TMDC is not set
CONFIG_JOYSTICK_IFORCE=y
CONFIG_JOYSTICK_IFORCE_USB=y
CONFIG_JOYSTICK_IFORCE_232=y
CONFIG_JOYSTICK_WARRIOR=y
CONFIG_JOYSTICK_MAGELLAN=y
CONFIG_JOYSTICK_SPACEORB=y
# CONFIG_JOYSTICK_SPACEBALL is not set
CONFIG_JOYSTICK_STINGER=y
CONFIG_JOYSTICK_TWIDJOY=y
CONFIG_JOYSTICK_ZHENHUA=y
# CONFIG_JOYSTICK_DB9 is not set
CONFIG_JOYSTICK_GAMECON=y
CONFIG_JOYSTICK_TURBOGRAFX=y
CONFIG_JOYSTICK_AS5011=y
# CONFIG_JOYSTICK_JOYDUMP is not set
# CONFIG_JOYSTICK_XPAD is not set
CONFIG_INPUT_TABLET=y
CONFIG_TABLET_USB_ACECAD=y
CONFIG_TABLET_USB_AIPTEK=y
# CONFIG_TABLET_USB_GTCO is not set
# CONFIG_TABLET_USB_HANWANG is not set
# CONFIG_TABLET_USB_KBTAB is not set
# CONFIG_TABLET_USB_WACOM is not set
CONFIG_INPUT_TOUCHSCREEN=y
CONFIG_TOUCHSCREEN_AD7879=y
# CONFIG_TOUCHSCREEN_AD7879_I2C is not set
# CONFIG_TOUCHSCREEN_ATMEL_MXT is not set
CONFIG_TOUCHSCREEN_AUO_PIXCIR=y
# CONFIG_TOUCHSCREEN_BU21013 is not set
CONFIG_TOUCHSCREEN_CY8CTMG110=y
# CONFIG_TOUCHSCREEN_CYTTSP_CORE is not set
# CONFIG_TOUCHSCREEN_CYTTSP4_CORE is not set
CONFIG_TOUCHSCREEN_DA9034=y
# CONFIG_TOUCHSCREEN_DA9052 is not set
CONFIG_TOUCHSCREEN_DYNAPRO=y
CONFIG_TOUCHSCREEN_HAMPSHIRE=y
CONFIG_TOUCHSCREEN_EETI=y
# CONFIG_TOUCHSCREEN_FUJITSU is not set
# CONFIG_TOUCHSCREEN_ILI210X is not set
CONFIG_TOUCHSCREEN_GUNZE=y
CONFIG_TOUCHSCREEN_ELO=y
# CONFIG_TOUCHSCREEN_WACOM_W8001 is not set
CONFIG_TOUCHSCREEN_WACOM_I2C=y
CONFIG_TOUCHSCREEN_MAX11801=y
CONFIG_TOUCHSCREEN_MCS5000=y
CONFIG_TOUCHSCREEN_MMS114=y
# CONFIG_TOUCHSCREEN_MTOUCH is not set
CONFIG_TOUCHSCREEN_INEXIO=y
CONFIG_TOUCHSCREEN_MK712=y
CONFIG_TOUCHSCREEN_PENMOUNT=y
CONFIG_TOUCHSCREEN_EDT_FT5X06=y
CONFIG_TOUCHSCREEN_TOUCHRIGHT=y
# CONFIG_TOUCHSCREEN_TOUCHWIN is not set
# CONFIG_TOUCHSCREEN_TI_AM335X_TSC is not set
# CONFIG_TOUCHSCREEN_PIXCIR is not set
CONFIG_TOUCHSCREEN_WM831X=y
CONFIG_TOUCHSCREEN_USB_COMPOSITE=y
# CONFIG_TOUCHSCREEN_MC13783 is not set
# CONFIG_TOUCHSCREEN_USB_EGALAX is not set
# CONFIG_TOUCHSCREEN_USB_PANJIT is not set
# CONFIG_TOUCHSCREEN_USB_3M is not set
CONFIG_TOUCHSCREEN_USB_ITM=y
CONFIG_TOUCHSCREEN_USB_ETURBO=y
# CONFIG_TOUCHSCREEN_USB_GUNZE is not set
CONFIG_TOUCHSCREEN_USB_DMC_TSC10=y
# CONFIG_TOUCHSCREEN_USB_IRTOUCH is not set
CONFIG_TOUCHSCREEN_USB_IDEALTEK=y
# CONFIG_TOUCHSCREEN_USB_GENERAL_TOUCH is not set
CONFIG_TOUCHSCREEN_USB_GOTOP=y
# CONFIG_TOUCHSCREEN_USB_JASTEC is not set
CONFIG_TOUCHSCREEN_USB_ELO=y
# CONFIG_TOUCHSCREEN_USB_E2I is not set
CONFIG_TOUCHSCREEN_USB_ZYTRONIC=y
CONFIG_TOUCHSCREEN_USB_ETT_TC45USB=y
CONFIG_TOUCHSCREEN_USB_NEXIO=y
CONFIG_TOUCHSCREEN_USB_EASYTOUCH=y
# CONFIG_TOUCHSCREEN_TOUCHIT213 is not set
# CONFIG_TOUCHSCREEN_TSC_SERIO is not set
CONFIG_TOUCHSCREEN_TSC2007=y
CONFIG_TOUCHSCREEN_ST1232=y
CONFIG_TOUCHSCREEN_TPS6507X=y
# CONFIG_TOUCHSCREEN_ZFORCE is not set
CONFIG_INPUT_MISC=y
# CONFIG_INPUT_AD714X is not set
CONFIG_INPUT_BMA150=y
CONFIG_INPUT_MC13783_PWRBUTTON=y
CONFIG_INPUT_MMA8450=y
CONFIG_INPUT_MPU3050=y
CONFIG_INPUT_APANEL=y
CONFIG_INPUT_GP2A=y
CONFIG_INPUT_GPIO_TILT_POLLED=y
CONFIG_INPUT_WISTRON_BTNS=y
# CONFIG_INPUT_ATLAS_BTNS is not set
# CONFIG_INPUT_ATI_REMOTE2 is not set
CONFIG_INPUT_KEYSPAN_REMOTE=y
CONFIG_INPUT_KXTJ9=y
# CONFIG_INPUT_KXTJ9_POLLED_MODE is not set
# CONFIG_INPUT_POWERMATE is not set
# CONFIG_INPUT_YEALINK is not set
CONFIG_INPUT_CM109=y
CONFIG_INPUT_TWL4030_PWRBUTTON=y
CONFIG_INPUT_TWL4030_VIBRA=y
CONFIG_INPUT_UINPUT=y
# CONFIG_INPUT_PCF50633_PMU is not set
# CONFIG_INPUT_PCF8574 is not set
CONFIG_INPUT_GPIO_ROTARY_ENCODER=y
CONFIG_INPUT_DA9052_ONKEY=y
# CONFIG_INPUT_WM831X_ON is not set
# CONFIG_INPUT_ADXL34X is not set
# CONFIG_INPUT_IMS_PCU is not set
# CONFIG_INPUT_CMA3000 is not set
# CONFIG_INPUT_IDEAPAD_SLIDEBAR is not set

#
# Hardware I/O ports
#
CONFIG_SERIO=y
CONFIG_SERIO_I8042=y
CONFIG_SERIO_SERPORT=y
# CONFIG_SERIO_CT82C710 is not set
CONFIG_SERIO_PARKBD=y
# CONFIG_SERIO_PCIPS2 is not set
CONFIG_SERIO_LIBPS2=y
# CONFIG_SERIO_RAW is not set
# CONFIG_SERIO_ALTERA_PS2 is not set
CONFIG_SERIO_PS2MULT=y
# CONFIG_SERIO_ARC_PS2 is not set
CONFIG_GAMEPORT=y
# CONFIG_GAMEPORT_NS558 is not set
# CONFIG_GAMEPORT_L4 is not set
# CONFIG_GAMEPORT_EMU10K1 is not set
CONFIG_GAMEPORT_FM801=y

#
# Character devices
#
CONFIG_TTY=y
# CONFIG_VT is not set
# CONFIG_UNIX98_PTYS is not set
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
CONFIG_SERIAL_8250_CS=y
CONFIG_SERIAL_8250_NR_UARTS=4
CONFIG_SERIAL_8250_RUNTIME_UARTS=4
CONFIG_SERIAL_8250_EXTENDED=y
CONFIG_SERIAL_8250_MANY_PORTS=y
# CONFIG_SERIAL_8250_SHARE_IRQ is not set
# CONFIG_SERIAL_8250_DETECT_IRQ is not set
CONFIG_SERIAL_8250_RSA=y
# CONFIG_SERIAL_8250_DW is not set

#
# Non-8250 serial port support
#
# CONFIG_SERIAL_MFD_HSU is not set
# CONFIG_SERIAL_UARTLITE is not set
CONFIG_SERIAL_CORE=y
CONFIG_SERIAL_CORE_CONSOLE=y
# CONFIG_SERIAL_JSM is not set
CONFIG_SERIAL_SCCNXP=y
# CONFIG_SERIAL_SCCNXP_CONSOLE is not set
CONFIG_SERIAL_TIMBERDALE=y
# CONFIG_SERIAL_ALTERA_JTAGUART is not set
CONFIG_SERIAL_ALTERA_UART=y
CONFIG_SERIAL_ALTERA_UART_MAXPORTS=4
CONFIG_SERIAL_ALTERA_UART_BAUDRATE=115200
# CONFIG_SERIAL_ALTERA_UART_CONSOLE is not set
CONFIG_SERIAL_PCH_UART=y
CONFIG_SERIAL_PCH_UART_CONSOLE=y
# CONFIG_SERIAL_ARC is not set
CONFIG_SERIAL_RP2=y
CONFIG_SERIAL_RP2_NR_UARTS=32
CONFIG_SERIAL_FSL_LPUART=y
# CONFIG_SERIAL_FSL_LPUART_CONSOLE is not set
# CONFIG_SERIAL_ST_ASC is not set
CONFIG_TTY_PRINTK=y
CONFIG_PRINTER=y
# CONFIG_LP_CONSOLE is not set
CONFIG_PPDEV=y
CONFIG_HVC_DRIVER=y
CONFIG_VIRTIO_CONSOLE=y
# CONFIG_IPMI_HANDLER is not set
# CONFIG_HW_RANDOM is not set
# CONFIG_NVRAM is not set
CONFIG_R3964=y
# CONFIG_APPLICOM is not set
# CONFIG_SONYPI is not set

#
# PCMCIA character devices
#
# CONFIG_SYNCLINK_CS is not set
CONFIG_CARDMAN_4000=y
CONFIG_CARDMAN_4040=y
CONFIG_MWAVE=y
CONFIG_SCx200_GPIO=y
CONFIG_PC8736x_GPIO=y
CONFIG_NSC_GPIO=y
# CONFIG_HPET is not set
CONFIG_HANGCHECK_TIMER=y
CONFIG_TCG_TPM=y
CONFIG_TCG_TIS=y
# CONFIG_TCG_TIS_I2C_ATMEL is not set
CONFIG_TCG_TIS_I2C_INFINEON=y
# CONFIG_TCG_TIS_I2C_NUVOTON is not set
CONFIG_TCG_NSC=y
CONFIG_TCG_ATMEL=y
# CONFIG_TCG_INFINEON is not set
CONFIG_TCG_ST33_I2C=y
# CONFIG_TELCLOCK is not set
CONFIG_DEVPORT=y
CONFIG_I2C=y
CONFIG_I2C_BOARDINFO=y
CONFIG_I2C_COMPAT=y
# CONFIG_I2C_CHARDEV is not set
CONFIG_I2C_MUX=y

#
# Multiplexer I2C Chip support
#
# CONFIG_I2C_MUX_GPIO is not set
CONFIG_I2C_MUX_PCA9541=y
CONFIG_I2C_MUX_PCA954x=y
CONFIG_I2C_HELPER_AUTO=y
CONFIG_I2C_SMBUS=y
CONFIG_I2C_ALGOBIT=y
CONFIG_I2C_ALGOPCA=y

#
# I2C Hardware Bus support
#

#
# PC SMBus host controller drivers
#
CONFIG_I2C_ALI1535=y
CONFIG_I2C_ALI1563=y
# CONFIG_I2C_ALI15X3 is not set
# CONFIG_I2C_AMD756 is not set
CONFIG_I2C_AMD8111=y
CONFIG_I2C_I801=y
CONFIG_I2C_ISCH=y
CONFIG_I2C_ISMT=y
# CONFIG_I2C_PIIX4 is not set
CONFIG_I2C_NFORCE2=y
# CONFIG_I2C_NFORCE2_S4985 is not set
# CONFIG_I2C_SIS5595 is not set
CONFIG_I2C_SIS630=y
CONFIG_I2C_SIS96X=y
CONFIG_I2C_VIA=y
CONFIG_I2C_VIAPRO=y

#
# ACPI drivers
#
# CONFIG_I2C_SCMI is not set

#
# I2C system bus drivers (mostly embedded / system-on-chip)
#
CONFIG_I2C_CBUS_GPIO=y
CONFIG_I2C_DESIGNWARE_CORE=y
CONFIG_I2C_DESIGNWARE_PCI=y
CONFIG_I2C_EG20T=y
CONFIG_I2C_GPIO=y
# CONFIG_I2C_KEMPLD is not set
# CONFIG_I2C_OCORES is not set
CONFIG_I2C_PCA_PLATFORM=y
# CONFIG_I2C_PXA_PCI is not set
CONFIG_I2C_SH_MOBILE=y
CONFIG_I2C_SIMTEC=y
# CONFIG_I2C_XILINX is not set
# CONFIG_I2C_RCAR is not set

#
# External I2C/SMBus adapter drivers
#
CONFIG_I2C_DIOLAN_U2C=y
CONFIG_I2C_PARPORT=y
CONFIG_I2C_PARPORT_LIGHT=y
# CONFIG_I2C_TAOS_EVM is not set
CONFIG_I2C_TINY_USB=y
CONFIG_I2C_VIPERBOARD=y

#
# Other I2C/SMBus bus drivers
#
# CONFIG_SCx200_I2C is not set
# CONFIG_SCx200_ACB is not set
# CONFIG_I2C_DEBUG_CORE is not set
# CONFIG_I2C_DEBUG_ALGO is not set
# CONFIG_I2C_DEBUG_BUS is not set
# CONFIG_SPI is not set
# CONFIG_HSI is not set

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
CONFIG_PPS_CLIENT_LDISC=y
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
CONFIG_ARCH_WANT_OPTIONAL_GPIOLIB=y
CONFIG_GPIOLIB=y
CONFIG_GPIO_DEVRES=y
CONFIG_GPIO_ACPI=y
# CONFIG_DEBUG_GPIO is not set
CONFIG_GPIO_SYSFS=y
CONFIG_GPIO_GENERIC=y
CONFIG_GPIO_DA9052=y

#
# Memory mapped GPIO drivers:
#
CONFIG_GPIO_GENERIC_PLATFORM=y
CONFIG_GPIO_IT8761E=y
CONFIG_GPIO_F7188X=y
# CONFIG_GPIO_TS5500 is not set
CONFIG_GPIO_SCH=y
# CONFIG_GPIO_ICH is not set
# CONFIG_GPIO_VX855 is not set
# CONFIG_GPIO_LYNXPOINT is not set

#
# I2C GPIO expanders:
#
CONFIG_GPIO_ARIZONA=y
# CONFIG_GPIO_MAX7300 is not set
CONFIG_GPIO_MAX732X=y
# CONFIG_GPIO_MAX732X_IRQ is not set
# CONFIG_GPIO_PCA953X is not set
CONFIG_GPIO_PCF857X=y
# CONFIG_GPIO_RC5T583 is not set
# CONFIG_GPIO_SX150X is not set
CONFIG_GPIO_TC3589X=y
# CONFIG_GPIO_TWL4030 is not set
CONFIG_GPIO_WM831X=y
CONFIG_GPIO_WM8994=y
# CONFIG_GPIO_ADP5588 is not set

#
# PCI GPIO expanders:
#
CONFIG_GPIO_CS5535=y
CONFIG_GPIO_BT8XX=y
CONFIG_GPIO_AMD8111=y
CONFIG_GPIO_INTEL_MID=y
# CONFIG_GPIO_PCH is not set
CONFIG_GPIO_ML_IOH=y
CONFIG_GPIO_TIMBERDALE=y
# CONFIG_GPIO_RDC321X is not set

#
# SPI GPIO expanders:
#
CONFIG_GPIO_MCP23S08=y

#
# AC97 GPIO expanders:
#

#
# LPC GPIO expanders:
#
CONFIG_GPIO_KEMPLD=y

#
# MODULbus GPIO expanders:
#
CONFIG_GPIO_JANZ_TTL=y
# CONFIG_GPIO_PALMAS is not set
# CONFIG_GPIO_TPS6586X is not set
CONFIG_GPIO_TPS65910=y

#
# USB GPIO expanders:
#
CONFIG_GPIO_VIPERBOARD=y
# CONFIG_W1 is not set
CONFIG_POWER_SUPPLY=y
# CONFIG_POWER_SUPPLY_DEBUG is not set
# CONFIG_PDA_POWER is not set
# CONFIG_GENERIC_ADC_BATTERY is not set
# CONFIG_WM831X_BACKUP is not set
# CONFIG_WM831X_POWER is not set
# CONFIG_TEST_POWER is not set
# CONFIG_BATTERY_DS2780 is not set
# CONFIG_BATTERY_DS2781 is not set
# CONFIG_BATTERY_DS2782 is not set
# CONFIG_BATTERY_SBS is not set
# CONFIG_BATTERY_BQ27x00 is not set
# CONFIG_BATTERY_DA9030 is not set
# CONFIG_BATTERY_DA9052 is not set
# CONFIG_BATTERY_MAX17040 is not set
# CONFIG_BATTERY_MAX17042 is not set
# CONFIG_BATTERY_TWL4030_MADC is not set
# CONFIG_CHARGER_PCF50633 is not set
# CONFIG_BATTERY_RX51 is not set
# CONFIG_CHARGER_ISP1704 is not set
# CONFIG_CHARGER_MAX8903 is not set
# CONFIG_CHARGER_TWL4030 is not set
# CONFIG_CHARGER_LP8727 is not set
# CONFIG_CHARGER_GPIO is not set
# CONFIG_CHARGER_BQ2415X is not set
# CONFIG_CHARGER_BQ24190 is not set
# CONFIG_CHARGER_BQ24735 is not set
# CONFIG_CHARGER_SMB347 is not set
# CONFIG_CHARGER_TPS65090 is not set
# CONFIG_BATTERY_GOLDFISH is not set
# CONFIG_POWER_RESET is not set
CONFIG_POWER_AVS=y
# CONFIG_HWMON is not set
CONFIG_THERMAL=y
# CONFIG_THERMAL_DEFAULT_GOV_STEP_WISE is not set
# CONFIG_THERMAL_DEFAULT_GOV_FAIR_SHARE is not set
CONFIG_THERMAL_DEFAULT_GOV_USER_SPACE=y
# CONFIG_THERMAL_GOV_FAIR_SHARE is not set
CONFIG_THERMAL_GOV_STEP_WISE=y
CONFIG_THERMAL_GOV_USER_SPACE=y
CONFIG_THERMAL_EMULATION=y
CONFIG_INTEL_POWERCLAMP=y
# CONFIG_X86_PKG_TEMP_THERMAL is not set

#
# Texas Instruments thermal drivers
#
CONFIG_WATCHDOG=y
CONFIG_WATCHDOG_CORE=y
# CONFIG_WATCHDOG_NOWAYOUT is not set

#
# Watchdog Device Drivers
#
# CONFIG_SOFT_WATCHDOG is not set
CONFIG_DA9052_WATCHDOG=y
# CONFIG_WM831X_WATCHDOG is not set
CONFIG_TWL4030_WATCHDOG=y
CONFIG_ACQUIRE_WDT=y
# CONFIG_ADVANTECH_WDT is not set
CONFIG_ALIM1535_WDT=y
CONFIG_ALIM7101_WDT=y
CONFIG_F71808E_WDT=y
# CONFIG_SP5100_TCO is not set
# CONFIG_GEODE_WDT is not set
CONFIG_SC520_WDT=y
# CONFIG_SBC_FITPC2_WATCHDOG is not set
# CONFIG_EUROTECH_WDT is not set
CONFIG_IB700_WDT=y
CONFIG_IBMASR=y
CONFIG_WAFER_WDT=y
CONFIG_I6300ESB_WDT=y
CONFIG_IE6XX_WDT=y
# CONFIG_ITCO_WDT is not set
CONFIG_IT8712F_WDT=y
# CONFIG_IT87_WDT is not set
CONFIG_HP_WATCHDOG=y
CONFIG_KEMPLD_WDT=y
# CONFIG_HPWDT_NMI_DECODING is not set
# CONFIG_SC1200_WDT is not set
CONFIG_SCx200_WDT=y
CONFIG_PC87413_WDT=y
# CONFIG_NV_TCO is not set
CONFIG_60XX_WDT=y
# CONFIG_SBC8360_WDT is not set
CONFIG_SBC7240_WDT=y
CONFIG_CPU5_WDT=y
CONFIG_SMSC_SCH311X_WDT=y
# CONFIG_SMSC37B787_WDT is not set
CONFIG_VIA_WDT=y
CONFIG_W83627HF_WDT=y
CONFIG_W83697HF_WDT=y
# CONFIG_W83697UG_WDT is not set
# CONFIG_W83877F_WDT is not set
CONFIG_W83977F_WDT=y
CONFIG_MACHZ_WDT=y
CONFIG_SBC_EPX_C3_WATCHDOG=y
CONFIG_MEN_A21_WDT=y

#
# PCI-based Watchdog Cards
#
# CONFIG_PCIPCWATCHDOG is not set
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
CONFIG_SSB_PCMCIAHOST_POSSIBLE=y
# CONFIG_SSB_PCMCIAHOST is not set
CONFIG_SSB_SDIOHOST_POSSIBLE=y
# CONFIG_SSB_SDIOHOST is not set
# CONFIG_SSB_SILENT is not set
CONFIG_SSB_DEBUG=y
CONFIG_SSB_DRIVER_GPIO=y
CONFIG_BCMA_POSSIBLE=y

#
# Broadcom specific AMBA
#
# CONFIG_BCMA is not set

#
# Multifunction device drivers
#
CONFIG_MFD_CORE=y
CONFIG_MFD_CS5535=y
# CONFIG_MFD_AS3711 is not set
# CONFIG_PMIC_ADP5520 is not set
CONFIG_MFD_AAT2870_CORE=y
# CONFIG_MFD_CROS_EC is not set
CONFIG_PMIC_DA903X=y
CONFIG_PMIC_DA9052=y
CONFIG_MFD_DA9052_I2C=y
# CONFIG_MFD_DA9055 is not set
CONFIG_MFD_DA9063=y
CONFIG_MFD_MC13783=y
CONFIG_MFD_MC13XXX=y
CONFIG_MFD_MC13XXX_I2C=y
# CONFIG_HTC_PASIC3 is not set
CONFIG_HTC_I2CPLD=y
# CONFIG_LPC_ICH is not set
CONFIG_LPC_SCH=y
CONFIG_MFD_JANZ_CMODIO=y
CONFIG_MFD_KEMPLD=y
# CONFIG_MFD_88PM800 is not set
# CONFIG_MFD_88PM805 is not set
# CONFIG_MFD_88PM860X is not set
# CONFIG_MFD_MAX77686 is not set
CONFIG_MFD_MAX77693=y
CONFIG_MFD_MAX8907=y
# CONFIG_MFD_MAX8925 is not set
CONFIG_MFD_MAX8997=y
CONFIG_MFD_MAX8998=y
CONFIG_MFD_VIPERBOARD=y
# CONFIG_MFD_RETU is not set
CONFIG_MFD_PCF50633=y
CONFIG_PCF50633_ADC=y
# CONFIG_PCF50633_GPIO is not set
CONFIG_MFD_RDC321X=y
CONFIG_MFD_RTSX_PCI=y
CONFIG_MFD_RC5T583=y
CONFIG_MFD_SEC_CORE=y
CONFIG_MFD_SI476X_CORE=y
# CONFIG_MFD_SM501 is not set
CONFIG_MFD_SMSC=y
# CONFIG_ABX500_CORE is not set
# CONFIG_MFD_STMPE is not set
# CONFIG_MFD_SYSCON is not set
CONFIG_MFD_TI_AM335X_TSCADC=y
# CONFIG_MFD_LP8788 is not set
CONFIG_MFD_PALMAS=y
# CONFIG_TPS6105X is not set
# CONFIG_TPS65010 is not set
# CONFIG_TPS6507X is not set
CONFIG_MFD_TPS65090=y
CONFIG_MFD_TPS65217=y
CONFIG_MFD_TPS6586X=y
CONFIG_MFD_TPS65910=y
# CONFIG_MFD_TPS65912 is not set
# CONFIG_MFD_TPS65912_I2C is not set
# CONFIG_MFD_TPS80031 is not set
CONFIG_TWL4030_CORE=y
CONFIG_TWL4030_MADC=y
CONFIG_MFD_TWL4030_AUDIO=y
# CONFIG_TWL6040_CORE is not set
# CONFIG_MFD_WL1273_CORE is not set
# CONFIG_MFD_LM3533 is not set
CONFIG_MFD_TIMBERDALE=y
CONFIG_MFD_TC3589X=y
# CONFIG_MFD_TMIO is not set
CONFIG_MFD_VX855=y
CONFIG_MFD_ARIZONA=y
CONFIG_MFD_ARIZONA_I2C=y
# CONFIG_MFD_WM5102 is not set
# CONFIG_MFD_WM5110 is not set
CONFIG_MFD_WM8997=y
# CONFIG_MFD_WM8400 is not set
CONFIG_MFD_WM831X=y
CONFIG_MFD_WM831X_I2C=y
# CONFIG_MFD_WM8350_I2C is not set
CONFIG_MFD_WM8994=y
# CONFIG_REGULATOR is not set
CONFIG_MEDIA_SUPPORT=y

#
# Multimedia core support
#
CONFIG_MEDIA_CAMERA_SUPPORT=y
CONFIG_MEDIA_ANALOG_TV_SUPPORT=y
CONFIG_MEDIA_DIGITAL_TV_SUPPORT=y
# CONFIG_MEDIA_RADIO_SUPPORT is not set
# CONFIG_MEDIA_RC_SUPPORT is not set
CONFIG_MEDIA_CONTROLLER=y
CONFIG_VIDEO_DEV=y
# CONFIG_VIDEO_V4L2_SUBDEV_API is not set
CONFIG_VIDEO_V4L2=y
CONFIG_VIDEO_ADV_DEBUG=y
CONFIG_VIDEO_FIXED_MINOR_RANGES=y
CONFIG_VIDEO_TUNER=y
CONFIG_V4L2_MEM2MEM_DEV=y
CONFIG_VIDEOBUF_GEN=y
CONFIG_VIDEOBUF_DMA_SG=y
CONFIG_VIDEOBUF_VMALLOC=y
CONFIG_VIDEOBUF2_CORE=y
CONFIG_VIDEOBUF2_MEMOPS=y
CONFIG_VIDEOBUF2_DMA_CONTIG=y
CONFIG_VIDEOBUF2_VMALLOC=y
CONFIG_VIDEO_V4L2_INT_DEVICE=y
CONFIG_DVB_CORE=y
CONFIG_TTPCI_EEPROM=y
CONFIG_DVB_MAX_ADAPTERS=8
CONFIG_DVB_DYNAMIC_MINORS=y

#
# Media drivers
#
CONFIG_MEDIA_USB_SUPPORT=y

#
# Webcam devices
#
CONFIG_USB_VIDEO_CLASS=y
CONFIG_USB_VIDEO_CLASS_INPUT_EVDEV=y
# CONFIG_USB_GSPCA is not set
# CONFIG_USB_PWC is not set
CONFIG_VIDEO_CPIA2=y
# CONFIG_USB_ZR364XX is not set
CONFIG_USB_STKWEBCAM=y
CONFIG_USB_S2255=y
CONFIG_USB_SN9C102=y
CONFIG_VIDEO_USBTV=y

#
# Analog TV USB devices
#
# CONFIG_VIDEO_PVRUSB2 is not set
CONFIG_VIDEO_HDPVR=y
# CONFIG_VIDEO_USBVISION is not set
CONFIG_VIDEO_STK1160_COMMON=y
CONFIG_VIDEO_STK1160=y

#
# Analog/digital TV USB devices
#
CONFIG_VIDEO_AU0828=y
CONFIG_VIDEO_AU0828_V4L2=y

#
# Digital TV USB devices
#
# CONFIG_DVB_USB_V2 is not set
CONFIG_DVB_TTUSB_BUDGET=y
CONFIG_DVB_TTUSB_DEC=y
CONFIG_SMS_USB_DRV=y
CONFIG_DVB_B2C2_FLEXCOP_USB=y
CONFIG_DVB_B2C2_FLEXCOP_USB_DEBUG=y

#
# Webcam, TV (analog/digital) USB devices
#
CONFIG_VIDEO_EM28XX=y
CONFIG_VIDEO_EM28XX_DVB=y
CONFIG_MEDIA_PCI_SUPPORT=y

#
# Media capture support
#

#
# Media capture/analog TV support
#
CONFIG_VIDEO_ZORAN=y
# CONFIG_VIDEO_ZORAN_DC30 is not set
CONFIG_VIDEO_ZORAN_ZR36060=y
CONFIG_VIDEO_ZORAN_BUZ=y
CONFIG_VIDEO_ZORAN_DC10=y
# CONFIG_VIDEO_ZORAN_LML33 is not set
# CONFIG_VIDEO_ZORAN_LML33R10 is not set
# CONFIG_VIDEO_ZORAN_AVS6EYES is not set
CONFIG_VIDEO_HEXIUM_GEMINI=y
# CONFIG_VIDEO_HEXIUM_ORION is not set
CONFIG_VIDEO_MXB=y

#
# Media capture/analog/hybrid TV support
#
# CONFIG_VIDEO_CX25821 is not set
CONFIG_VIDEO_SAA7134=y
# CONFIG_VIDEO_SAA7134_DVB is not set
# CONFIG_VIDEO_SAA7164 is not set

#
# Media digital TV PCI Adapters
#
CONFIG_DVB_AV7110=y
CONFIG_DVB_AV7110_OSD=y
CONFIG_DVB_BUDGET_CORE=y
# CONFIG_DVB_BUDGET is not set
# CONFIG_DVB_BUDGET_AV is not set
CONFIG_DVB_BUDGET_PATCH=y
# CONFIG_DVB_B2C2_FLEXCOP_PCI is not set
CONFIG_DVB_PLUTO2=y
CONFIG_DVB_PT1=y
# CONFIG_DVB_NGENE is not set
CONFIG_DVB_DDBRIDGE=y
CONFIG_V4L_PLATFORM_DRIVERS=y
CONFIG_VIDEO_CAFE_CCIC=y
# CONFIG_VIDEO_TIMBERDALE is not set
# CONFIG_SOC_CAMERA is not set
CONFIG_V4L_MEM2MEM_DRIVERS=y
CONFIG_VIDEO_MEM2MEM_DEINTERLACE=y
CONFIG_VIDEO_SH_VEU=y
CONFIG_V4L_TEST_DRIVERS=y
CONFIG_VIDEO_VIVI=y
# CONFIG_VIDEO_MEM2MEM_TESTDEV is not set

#
# Supported MMC/SDIO adapters
#
CONFIG_SMS_SDIO_DRV=y
# CONFIG_MEDIA_PARPORT_SUPPORT is not set

#
# Supported FireWire (IEEE 1394) Adapters
#
CONFIG_DVB_FIREDTV=y
CONFIG_DVB_FIREDTV_INPUT=y
CONFIG_MEDIA_COMMON_OPTIONS=y

#
# common driver options
#
CONFIG_VIDEO_TVEEPROM=y
CONFIG_CYPRESS_FIRMWARE=y
CONFIG_DVB_B2C2_FLEXCOP=y
CONFIG_DVB_B2C2_FLEXCOP_DEBUG=y
CONFIG_VIDEO_SAA7146=y
CONFIG_VIDEO_SAA7146_VV=y
CONFIG_SMS_SIANO_MDTV=y

#
# Media ancillary drivers (tuners, sensors, i2c, frontends)
#
# CONFIG_MEDIA_SUBDRV_AUTOSELECT is not set

#
# Encoders, decoders, sensors and other helper chips
#

#
# Audio decoders, processors and mixers
#
CONFIG_VIDEO_TVAUDIO=y
CONFIG_VIDEO_TDA7432=y
# CONFIG_VIDEO_TDA9840 is not set
CONFIG_VIDEO_TEA6415C=y
CONFIG_VIDEO_TEA6420=y
# CONFIG_VIDEO_MSP3400 is not set
# CONFIG_VIDEO_CS5345 is not set
CONFIG_VIDEO_CS53L32A=y
CONFIG_VIDEO_TLV320AIC23B=y
CONFIG_VIDEO_UDA1342=y
# CONFIG_VIDEO_WM8775 is not set
CONFIG_VIDEO_WM8739=y
# CONFIG_VIDEO_VP27SMPX is not set
# CONFIG_VIDEO_SONY_BTF_MPX is not set

#
# RDS decoders
#
CONFIG_VIDEO_SAA6588=y

#
# Video decoders
#
# CONFIG_VIDEO_ADV7180 is not set
CONFIG_VIDEO_ADV7183=y
CONFIG_VIDEO_BT819=y
CONFIG_VIDEO_BT856=y
CONFIG_VIDEO_BT866=y
CONFIG_VIDEO_KS0127=y
CONFIG_VIDEO_ML86V7667=y
CONFIG_VIDEO_SAA7110=y
CONFIG_VIDEO_SAA711X=y
CONFIG_VIDEO_SAA7191=y
# CONFIG_VIDEO_TVP514X is not set
# CONFIG_VIDEO_TVP5150 is not set
CONFIG_VIDEO_TVP7002=y
CONFIG_VIDEO_TW2804=y
CONFIG_VIDEO_TW9903=y
# CONFIG_VIDEO_TW9906 is not set
CONFIG_VIDEO_VPX3220=y

#
# Video and audio decoders
#
CONFIG_VIDEO_SAA717X=y
# CONFIG_VIDEO_CX25840 is not set

#
# Video encoders
#
# CONFIG_VIDEO_SAA7127 is not set
CONFIG_VIDEO_SAA7185=y
# CONFIG_VIDEO_ADV7170 is not set
CONFIG_VIDEO_ADV7175=y
# CONFIG_VIDEO_ADV7343 is not set
# CONFIG_VIDEO_ADV7393 is not set
# CONFIG_VIDEO_AK881X is not set
CONFIG_VIDEO_THS8200=y

#
# Camera sensor devices
#
CONFIG_VIDEO_OV7640=y
CONFIG_VIDEO_OV7670=y
CONFIG_VIDEO_VS6624=y
CONFIG_VIDEO_MT9V011=y
CONFIG_VIDEO_TCM825X=y
# CONFIG_VIDEO_SR030PC30 is not set

#
# Flash devices
#
# CONFIG_VIDEO_ADP1653 is not set
CONFIG_VIDEO_AS3645A=y
CONFIG_VIDEO_LM3560=y

#
# Video improvement chips
#
CONFIG_VIDEO_UPD64031A=y
CONFIG_VIDEO_UPD64083=y

#
# Miscellaneous helper chips
#
CONFIG_VIDEO_THS7303=y
CONFIG_VIDEO_M52790=y

#
# Sensors used on soc_camera driver
#
CONFIG_MEDIA_TUNER=y

#
# Customize TV tuners
#
CONFIG_MEDIA_TUNER_SIMPLE=y
CONFIG_MEDIA_TUNER_TDA8290=y
CONFIG_MEDIA_TUNER_TDA827X=y
CONFIG_MEDIA_TUNER_TDA18271=y
CONFIG_MEDIA_TUNER_TDA9887=y
CONFIG_MEDIA_TUNER_TEA5761=y
# CONFIG_MEDIA_TUNER_TEA5767 is not set
CONFIG_MEDIA_TUNER_MT20XX=y
# CONFIG_MEDIA_TUNER_MT2060 is not set
CONFIG_MEDIA_TUNER_MT2063=y
# CONFIG_MEDIA_TUNER_MT2266 is not set
CONFIG_MEDIA_TUNER_MT2131=y
CONFIG_MEDIA_TUNER_QT1010=y
CONFIG_MEDIA_TUNER_XC2028=y
CONFIG_MEDIA_TUNER_XC5000=y
# CONFIG_MEDIA_TUNER_XC4000 is not set
CONFIG_MEDIA_TUNER_MXL5005S=y
CONFIG_MEDIA_TUNER_MXL5007T=y
CONFIG_MEDIA_TUNER_MC44S803=y
CONFIG_MEDIA_TUNER_MAX2165=y
CONFIG_MEDIA_TUNER_TDA18218=y
CONFIG_MEDIA_TUNER_FC0011=y
CONFIG_MEDIA_TUNER_FC0012=y
# CONFIG_MEDIA_TUNER_FC0013 is not set
CONFIG_MEDIA_TUNER_TDA18212=y
CONFIG_MEDIA_TUNER_E4000=y
CONFIG_MEDIA_TUNER_FC2580=y
CONFIG_MEDIA_TUNER_TUA9001=y
CONFIG_MEDIA_TUNER_IT913X=y
CONFIG_MEDIA_TUNER_R820T=y

#
# Customise DVB Frontends
#

#
# Multistandard (satellite) frontends
#
CONFIG_DVB_STB0899=y
# CONFIG_DVB_STB6100 is not set
CONFIG_DVB_STV090x=y
CONFIG_DVB_STV6110x=y

#
# Multistandard (cable + terrestrial) frontends
#
CONFIG_DVB_DRXK=y
CONFIG_DVB_TDA18271C2DD=y

#
# DVB-S (satellite) frontends
#
CONFIG_DVB_CX24110=y
CONFIG_DVB_CX24123=y
CONFIG_DVB_MT312=y
CONFIG_DVB_ZL10036=y
# CONFIG_DVB_ZL10039 is not set
CONFIG_DVB_S5H1420=y
# CONFIG_DVB_STV0288 is not set
CONFIG_DVB_STB6000=y
CONFIG_DVB_STV0299=y
CONFIG_DVB_STV6110=y
CONFIG_DVB_STV0900=y
CONFIG_DVB_TDA8083=y
CONFIG_DVB_TDA10086=y
CONFIG_DVB_TDA8261=y
CONFIG_DVB_VES1X93=y
CONFIG_DVB_TUNER_ITD1000=y
CONFIG_DVB_TUNER_CX24113=y
CONFIG_DVB_TDA826X=y
CONFIG_DVB_TUA6100=y
CONFIG_DVB_CX24116=y
# CONFIG_DVB_CX24117 is not set
# CONFIG_DVB_SI21XX is not set
# CONFIG_DVB_TS2020 is not set
CONFIG_DVB_DS3000=y
# CONFIG_DVB_MB86A16 is not set
CONFIG_DVB_TDA10071=y

#
# DVB-T (terrestrial) frontends
#
CONFIG_DVB_SP8870=y
# CONFIG_DVB_SP887X is not set
CONFIG_DVB_CX22700=y
CONFIG_DVB_CX22702=y
CONFIG_DVB_S5H1432=y
CONFIG_DVB_DRXD=y
# CONFIG_DVB_L64781 is not set
CONFIG_DVB_TDA1004X=y
# CONFIG_DVB_NXT6000 is not set
# CONFIG_DVB_MT352 is not set
CONFIG_DVB_ZL10353=y
CONFIG_DVB_DIB3000MB=y
# CONFIG_DVB_DIB3000MC is not set
CONFIG_DVB_DIB7000M=y
CONFIG_DVB_DIB7000P=y
CONFIG_DVB_DIB9000=y
CONFIG_DVB_TDA10048=y
# CONFIG_DVB_AF9013 is not set
CONFIG_DVB_EC100=y
# CONFIG_DVB_HD29L2 is not set
# CONFIG_DVB_STV0367 is not set
# CONFIG_DVB_CXD2820R is not set
CONFIG_DVB_RTL2830=y
CONFIG_DVB_RTL2832=y

#
# DVB-C (cable) frontends
#
CONFIG_DVB_VES1820=y
CONFIG_DVB_TDA10021=y
# CONFIG_DVB_TDA10023 is not set
CONFIG_DVB_STV0297=y

#
# ATSC (North American/Korean Terrestrial/Cable DTV) frontends
#
CONFIG_DVB_NXT200X=y
# CONFIG_DVB_OR51211 is not set
CONFIG_DVB_OR51132=y
# CONFIG_DVB_BCM3510 is not set
# CONFIG_DVB_LGDT330X is not set
# CONFIG_DVB_LGDT3305 is not set
CONFIG_DVB_LG2160=y
CONFIG_DVB_S5H1409=y
CONFIG_DVB_AU8522=y
CONFIG_DVB_AU8522_DTV=y
# CONFIG_DVB_AU8522_V4L is not set
CONFIG_DVB_S5H1411=y

#
# ISDB-T (terrestrial) frontends
#
CONFIG_DVB_S921=y
CONFIG_DVB_DIB8000=y
CONFIG_DVB_MB86A20S=y

#
# Digital terrestrial only tuners/PLL
#
CONFIG_DVB_PLL=y
CONFIG_DVB_TUNER_DIB0070=y
# CONFIG_DVB_TUNER_DIB0090 is not set

#
# SEC control devices for DVB-S
#
CONFIG_DVB_LNBP21=y
CONFIG_DVB_LNBP22=y
CONFIG_DVB_ISL6405=y
CONFIG_DVB_ISL6421=y
# CONFIG_DVB_ISL6423 is not set
CONFIG_DVB_A8293=y
CONFIG_DVB_LGS8GL5=y
CONFIG_DVB_LGS8GXX=y
CONFIG_DVB_ATBM8830=y
# CONFIG_DVB_TDA665x is not set
CONFIG_DVB_IX2505V=y
# CONFIG_DVB_IT913X_FE is not set
# CONFIG_DVB_M88RS2000 is not set
CONFIG_DVB_AF9033=y

#
# Tools to develop new frontends
#
# CONFIG_DVB_DUMMY_FE is not set

#
# Graphics support
#
CONFIG_AGP=y
CONFIG_AGP_ALI=y
CONFIG_AGP_ATI=y
CONFIG_AGP_AMD=y
CONFIG_AGP_AMD64=y
# CONFIG_AGP_INTEL is not set
CONFIG_AGP_NVIDIA=y
CONFIG_AGP_SIS=y
CONFIG_AGP_SWORKS=y
CONFIG_AGP_VIA=y
# CONFIG_AGP_EFFICEON is not set
CONFIG_VGA_ARB=y
CONFIG_VGA_ARB_MAX_GPUS=16
# CONFIG_VGA_SWITCHEROO is not set
# CONFIG_DRM is not set
CONFIG_VGASTATE=y
CONFIG_VIDEO_OUTPUT_CONTROL=y
CONFIG_FB=y
# CONFIG_FIRMWARE_EDID is not set
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
# CONFIG_FB_BACKLIGHT is not set
CONFIG_FB_MODE_HELPERS=y
CONFIG_FB_TILEBLITTING=y

#
# Frame buffer hardware drivers
#
CONFIG_FB_CIRRUS=y
CONFIG_FB_PM2=y
# CONFIG_FB_PM2_FIFO_DISCONNECT is not set
CONFIG_FB_CYBER2000=y
CONFIG_FB_CYBER2000_DDC=y
CONFIG_FB_ARC=y
CONFIG_FB_ASILIANT=y
# CONFIG_FB_IMSTT is not set
# CONFIG_FB_VGA16 is not set
# CONFIG_FB_VESA is not set
CONFIG_FB_N411=y
CONFIG_FB_HGA=y
# CONFIG_FB_S1D13XXX is not set
CONFIG_FB_NVIDIA=y
CONFIG_FB_NVIDIA_I2C=y
CONFIG_FB_NVIDIA_DEBUG=y
# CONFIG_FB_NVIDIA_BACKLIGHT is not set
# CONFIG_FB_RIVA is not set
# CONFIG_FB_I740 is not set
CONFIG_FB_LE80578=y
CONFIG_FB_CARILLO_RANCH=y
CONFIG_FB_MATROX=y
# CONFIG_FB_MATROX_MILLENIUM is not set
CONFIG_FB_MATROX_MYSTIQUE=y
CONFIG_FB_MATROX_G=y
CONFIG_FB_MATROX_I2C=y
CONFIG_FB_MATROX_MAVEN=y
CONFIG_FB_RADEON=y
CONFIG_FB_RADEON_I2C=y
# CONFIG_FB_RADEON_BACKLIGHT is not set
CONFIG_FB_RADEON_DEBUG=y
CONFIG_FB_ATY128=y
# CONFIG_FB_ATY128_BACKLIGHT is not set
CONFIG_FB_ATY=y
CONFIG_FB_ATY_CT=y
CONFIG_FB_ATY_GENERIC_LCD=y
CONFIG_FB_ATY_GX=y
# CONFIG_FB_ATY_BACKLIGHT is not set
CONFIG_FB_S3=y
CONFIG_FB_S3_DDC=y
# CONFIG_FB_SAVAGE is not set
CONFIG_FB_SIS=y
CONFIG_FB_SIS_300=y
CONFIG_FB_SIS_315=y
# CONFIG_FB_VIA is not set
CONFIG_FB_NEOMAGIC=y
# CONFIG_FB_KYRO is not set
CONFIG_FB_3DFX=y
# CONFIG_FB_3DFX_ACCEL is not set
# CONFIG_FB_3DFX_I2C is not set
# CONFIG_FB_VOODOO1 is not set
# CONFIG_FB_VT8623 is not set
# CONFIG_FB_TRIDENT is not set
CONFIG_FB_ARK=y
CONFIG_FB_PM3=y
CONFIG_FB_CARMINE=y
# CONFIG_FB_CARMINE_DRAM_EVAL is not set
CONFIG_CARMINE_DRAM_CUSTOM=y
CONFIG_FB_GEODE=y
CONFIG_FB_GEODE_LX=y
CONFIG_FB_GEODE_GX=y
# CONFIG_FB_GEODE_GX1 is not set
# CONFIG_FB_TMIO is not set
CONFIG_FB_SMSCUFX=y
CONFIG_FB_UDL=y
CONFIG_FB_GOLDFISH=y
CONFIG_FB_VIRTUAL=y
CONFIG_FB_METRONOME=y
CONFIG_FB_MB862XX=y
CONFIG_FB_MB862XX_PCI_GDC=y
CONFIG_FB_MB862XX_I2C=y
# CONFIG_FB_BROADSHEET is not set
CONFIG_FB_AUO_K190X=y
CONFIG_FB_AUO_K1900=y
CONFIG_FB_AUO_K1901=y
CONFIG_FB_SIMPLE=y
CONFIG_EXYNOS_VIDEO=y
CONFIG_BACKLIGHT_LCD_SUPPORT=y
CONFIG_LCD_CLASS_DEVICE=y
CONFIG_LCD_PLATFORM=y
CONFIG_BACKLIGHT_CLASS_DEVICE=y
CONFIG_BACKLIGHT_GENERIC=y
CONFIG_BACKLIGHT_CARILLO_RANCH=y
CONFIG_BACKLIGHT_PWM=y
# CONFIG_BACKLIGHT_DA903X is not set
CONFIG_BACKLIGHT_DA9052=y
# CONFIG_BACKLIGHT_APPLE is not set
CONFIG_BACKLIGHT_SAHARA=y
CONFIG_BACKLIGHT_WM831X=y
# CONFIG_BACKLIGHT_ADP8860 is not set
CONFIG_BACKLIGHT_ADP8870=y
CONFIG_BACKLIGHT_PCF50633=y
CONFIG_BACKLIGHT_AAT2870=y
CONFIG_BACKLIGHT_LM3630A=y
CONFIG_BACKLIGHT_LM3639=y
CONFIG_BACKLIGHT_LP855X=y
CONFIG_BACKLIGHT_OT200=y
# CONFIG_BACKLIGHT_PANDORA is not set
CONFIG_BACKLIGHT_TPS65217=y
CONFIG_BACKLIGHT_GPIO=y
CONFIG_BACKLIGHT_LV5207LP=y
CONFIG_BACKLIGHT_BD6107=y
CONFIG_LOGO=y
# CONFIG_LOGO_LINUX_MONO is not set
CONFIG_LOGO_LINUX_VGA16=y
CONFIG_LOGO_LINUX_CLUT224=y
# CONFIG_SOUND is not set

#
# HID support
#
CONFIG_HID=y
# CONFIG_HID_BATTERY_STRENGTH is not set
# CONFIG_HIDRAW is not set
CONFIG_UHID=y
# CONFIG_HID_GENERIC is not set

#
# Special HID drivers
#
# CONFIG_HID_A4TECH is not set
CONFIG_HID_ACRUX=y
CONFIG_HID_ACRUX_FF=y
CONFIG_HID_APPLE=y
CONFIG_HID_APPLEIR=y
CONFIG_HID_AUREAL=y
CONFIG_HID_BELKIN=y
CONFIG_HID_CHERRY=y
# CONFIG_HID_CHICONY is not set
# CONFIG_HID_CYPRESS is not set
CONFIG_HID_DRAGONRISE=y
CONFIG_DRAGONRISE_FF=y
CONFIG_HID_EMS_FF=y
# CONFIG_HID_ELECOM is not set
# CONFIG_HID_ELO is not set
CONFIG_HID_EZKEY=y
# CONFIG_HID_HOLTEK is not set
CONFIG_HID_HUION=y
CONFIG_HID_KEYTOUCH=y
CONFIG_HID_KYE=y
CONFIG_HID_UCLOGIC=y
CONFIG_HID_WALTOP=y
CONFIG_HID_GYRATION=y
CONFIG_HID_ICADE=y
CONFIG_HID_TWINHAN=y
# CONFIG_HID_KENSINGTON is not set
# CONFIG_HID_LCPOWER is not set
CONFIG_HID_LENOVO_TPKBD=y
# CONFIG_HID_LOGITECH is not set
CONFIG_HID_MAGICMOUSE=y
# CONFIG_HID_MICROSOFT is not set
CONFIG_HID_MONTEREY=y
CONFIG_HID_MULTITOUCH=y
CONFIG_HID_NTRIG=y
# CONFIG_HID_ORTEK is not set
CONFIG_HID_PANTHERLORD=y
CONFIG_PANTHERLORD_FF=y
CONFIG_HID_PETALYNX=y
# CONFIG_HID_PICOLCD is not set
CONFIG_HID_PRIMAX=y
CONFIG_HID_ROCCAT=y
CONFIG_HID_SAITEK=y
CONFIG_HID_SAMSUNG=y
# CONFIG_HID_SONY is not set
CONFIG_HID_SPEEDLINK=y
CONFIG_HID_STEELSERIES=y
CONFIG_HID_SUNPLUS=y
CONFIG_HID_GREENASIA=y
CONFIG_GREENASIA_FF=y
# CONFIG_HID_SMARTJOYPLUS is not set
# CONFIG_HID_TIVO is not set
CONFIG_HID_TOPSEED=y
CONFIG_HID_THINGM=y
CONFIG_HID_THRUSTMASTER=y
CONFIG_THRUSTMASTER_FF=y
# CONFIG_HID_WACOM is not set
# CONFIG_HID_WIIMOTE is not set
CONFIG_HID_XINMO=y
CONFIG_HID_ZEROPLUS=y
# CONFIG_ZEROPLUS_FF is not set
CONFIG_HID_ZYDACRON=y
CONFIG_HID_SENSOR_HUB=y

#
# USB HID support
#
CONFIG_USB_HID=y
# CONFIG_HID_PID is not set
# CONFIG_USB_HIDDEV is not set

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
CONFIG_USB_DEFAULT_PERSIST=y
# CONFIG_USB_DYNAMIC_MINORS is not set
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
CONFIG_USB_XHCI_PLATFORM=y
CONFIG_USB_EHCI_HCD=y
# CONFIG_USB_EHCI_ROOT_HUB_TT is not set
CONFIG_USB_EHCI_TT_NEWSCHED=y
CONFIG_USB_EHCI_PCI=y
CONFIG_USB_EHCI_HCD_PLATFORM=y
CONFIG_USB_OXU210HP_HCD=y
CONFIG_USB_ISP116X_HCD=y
CONFIG_USB_ISP1760_HCD=y
CONFIG_USB_ISP1362_HCD=y
# CONFIG_USB_FUSBH200_HCD is not set
CONFIG_USB_FOTG210_HCD=y
# CONFIG_USB_OHCI_HCD is not set
CONFIG_USB_UHCI_HCD=y
# CONFIG_USB_SL811_HCD is not set
# CONFIG_USB_R8A66597_HCD is not set
CONFIG_USB_WHCI_HCD=y
CONFIG_USB_HWA_HCD=y
CONFIG_USB_HCD_SSB=y
# CONFIG_USB_HCD_TEST_MODE is not set

#
# USB Device Class drivers
#
CONFIG_USB_ACM=y
CONFIG_USB_PRINTER=y
# CONFIG_USB_WDM is not set
CONFIG_USB_TMC=y

#
# NOTE: USB_STORAGE depends on SCSI but BLK_DEV_SD may
#

#
# also be needed; see USB_STORAGE Help for more info
#

#
# USB Imaging devices
#
CONFIG_USB_MDC800=y
CONFIG_USB_DWC3=y
CONFIG_USB_DWC3_HOST=y

#
# Platform Glue Driver Support
#
# CONFIG_USB_DWC3_OMAP is not set
CONFIG_USB_DWC3_EXYNOS=y
CONFIG_USB_DWC3_PCI=y

#
# Debugging features
#
CONFIG_USB_DWC3_DEBUG=y
# CONFIG_USB_DWC3_VERBOSE is not set
CONFIG_USB_CHIPIDEA=y
# CONFIG_USB_CHIPIDEA_HOST is not set
CONFIG_USB_CHIPIDEA_DEBUG=y

#
# USB port drivers
#
CONFIG_USB_USS720=y
# CONFIG_USB_SERIAL is not set

#
# USB Miscellaneous drivers
#
CONFIG_USB_EMI62=y
CONFIG_USB_EMI26=y
# CONFIG_USB_ADUTUX is not set
# CONFIG_USB_SEVSEG is not set
CONFIG_USB_RIO500=y
# CONFIG_USB_LEGOTOWER is not set
# CONFIG_USB_LCD is not set
CONFIG_USB_LED=y
CONFIG_USB_CYPRESS_CY7C63=y
# CONFIG_USB_CYTHERM is not set
CONFIG_USB_IDMOUSE=y
# CONFIG_USB_FTDI_ELAN is not set
CONFIG_USB_APPLEDISPLAY=y
CONFIG_USB_SISUSBVGA=y
CONFIG_USB_LD=y
CONFIG_USB_TRANCEVIBRATOR=y
CONFIG_USB_IOWARRIOR=y
CONFIG_USB_TEST=y
CONFIG_USB_EHSET_TEST_FIXTURE=y
CONFIG_USB_ISIGHTFW=y
CONFIG_USB_YUREX=y
# CONFIG_USB_EZUSB_FX2 is not set
CONFIG_USB_HSIC_USB3503=y

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
CONFIG_USB_GPIO_VBUS=y
CONFIG_USB_ISP1301=y
CONFIG_USB_RCAR_PHY=y
CONFIG_USB_RCAR_GEN2_PHY=y
# CONFIG_USB_GADGET is not set
CONFIG_UWB=y
CONFIG_UWB_HWA=y
CONFIG_UWB_WHCI=y
# CONFIG_UWB_I1480U is not set
CONFIG_MMC=y
CONFIG_MMC_DEBUG=y
# CONFIG_MMC_UNSAFE_RESUME is not set
# CONFIG_MMC_CLKGATE is not set

#
# MMC/SD/SDIO Card Drivers
#
# CONFIG_SDIO_UART is not set
# CONFIG_MMC_TEST is not set

#
# MMC/SD/SDIO Host Controller Drivers
#
# CONFIG_MMC_SDHCI is not set
# CONFIG_MMC_OMAP_HS is not set
CONFIG_MMC_WBSD=y
CONFIG_MMC_TIFM_SD=y
CONFIG_MMC_SDRICOH_CS=y
CONFIG_MMC_CB710=y
CONFIG_MMC_VIA_SDMMC=y
CONFIG_MMC_VUB300=y
CONFIG_MMC_USHC=y
# CONFIG_MMC_REALTEK_PCI is not set
CONFIG_MEMSTICK=y
# CONFIG_MEMSTICK_DEBUG is not set

#
# MemoryStick drivers
#
CONFIG_MEMSTICK_UNSAFE_RESUME=y

#
# MemoryStick Host Controller Drivers
#
CONFIG_MEMSTICK_TIFM_MS=y
CONFIG_MEMSTICK_JMICRON_38X=y
# CONFIG_MEMSTICK_R592 is not set
# CONFIG_MEMSTICK_REALTEK_PCI is not set
CONFIG_NEW_LEDS=y
CONFIG_LEDS_CLASS=y

#
# LED drivers
#
CONFIG_LEDS_LM3530=y
CONFIG_LEDS_LM3642=y
CONFIG_LEDS_NET48XX=y
# CONFIG_LEDS_WRAP is not set
CONFIG_LEDS_PCA9532=y
# CONFIG_LEDS_PCA9532_GPIO is not set
CONFIG_LEDS_GPIO=y
CONFIG_LEDS_LP3944=y
CONFIG_LEDS_LP55XX_COMMON=y
CONFIG_LEDS_LP5521=y
CONFIG_LEDS_LP5523=y
CONFIG_LEDS_LP5562=y
# CONFIG_LEDS_LP8501 is not set
# CONFIG_LEDS_PCA955X is not set
CONFIG_LEDS_PCA963X=y
CONFIG_LEDS_PCA9685=y
CONFIG_LEDS_WM831X_STATUS=y
CONFIG_LEDS_DA903X=y
CONFIG_LEDS_DA9052=y
# CONFIG_LEDS_PWM is not set
CONFIG_LEDS_BD2802=y
CONFIG_LEDS_LT3593=y
# CONFIG_LEDS_MC13783 is not set
CONFIG_LEDS_TCA6507=y
# CONFIG_LEDS_MAX8997 is not set
CONFIG_LEDS_LM355x=y
CONFIG_LEDS_OT200=y
CONFIG_LEDS_BLINKM=y

#
# LED Triggers
#
CONFIG_LEDS_TRIGGERS=y
CONFIG_LEDS_TRIGGER_TIMER=y
# CONFIG_LEDS_TRIGGER_ONESHOT is not set
CONFIG_LEDS_TRIGGER_HEARTBEAT=y
CONFIG_LEDS_TRIGGER_BACKLIGHT=y
# CONFIG_LEDS_TRIGGER_CPU is not set
CONFIG_LEDS_TRIGGER_GPIO=y
# CONFIG_LEDS_TRIGGER_DEFAULT_ON is not set

#
# iptables trigger is under Netfilter config (LED target)
#
# CONFIG_LEDS_TRIGGER_TRANSIENT is not set
CONFIG_LEDS_TRIGGER_CAMERA=y
# CONFIG_ACCESSIBILITY is not set
# CONFIG_INFINIBAND is not set
CONFIG_EDAC=y
# CONFIG_EDAC_LEGACY_SYSFS is not set
# CONFIG_EDAC_DEBUG is not set
CONFIG_EDAC_DECODE_MCE=y
CONFIG_EDAC_MCE_INJ=y
# CONFIG_EDAC_MM_EDAC is not set
CONFIG_RTC_LIB=y
# CONFIG_RTC_CLASS is not set
CONFIG_DMADEVICES=y
CONFIG_DMADEVICES_DEBUG=y
CONFIG_DMADEVICES_VDEBUG=y

#
# DMA Devices
#
CONFIG_INTEL_MID_DMAC=y
CONFIG_INTEL_IOATDMA=y
CONFIG_DW_DMAC_CORE=y
# CONFIG_DW_DMAC is not set
CONFIG_DW_DMAC_PCI=y
# CONFIG_TIMB_DMA is not set
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
# CONFIG_AUXDISPLAY is not set
CONFIG_UIO=y
# CONFIG_UIO_CIF is not set
CONFIG_UIO_PDRV_GENIRQ=y
CONFIG_UIO_DMEM_GENIRQ=y
CONFIG_UIO_AEC=y
# CONFIG_UIO_SERCOS3 is not set
CONFIG_UIO_PCI_GENERIC=y
# CONFIG_UIO_NETX is not set
CONFIG_UIO_MF624=y
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
# CONFIG_ACERHDF is not set
# CONFIG_ASUS_LAPTOP is not set
# CONFIG_DELL_LAPTOP is not set
# CONFIG_FUJITSU_LAPTOP is not set
# CONFIG_FUJITSU_TABLET is not set
# CONFIG_HP_ACCEL is not set
# CONFIG_PANASONIC_LAPTOP is not set
# CONFIG_THINKPAD_ACPI is not set
CONFIG_SENSORS_HDAPS=y
# CONFIG_INTEL_MENLOW is not set
# CONFIG_ACPI_WMI is not set
# CONFIG_TOPSTAR_LAPTOP is not set
# CONFIG_TOSHIBA_BT_RFKILL is not set
# CONFIG_ACPI_CMPC is not set
# CONFIG_INTEL_IPS is not set
CONFIG_IBM_RTL=y
# CONFIG_XO15_EBOOK is not set
CONFIG_SAMSUNG_LAPTOP=y
# CONFIG_SAMSUNG_Q10 is not set
# CONFIG_APPLE_GMUX is not set
# CONFIG_INTEL_RST is not set
# CONFIG_INTEL_SMARTCONNECT is not set
# CONFIG_PVPANIC is not set

#
# Hardware Spinlock drivers
#
CONFIG_CLKSRC_I8253=y
CONFIG_CLKEVT_I8253=y
CONFIG_CLKBLD_I8253=y
CONFIG_ARM_ARCH_TIMER_EVTSTREAM=y
CONFIG_MAILBOX=y
CONFIG_IOMMU_SUPPORT=y

#
# Remoteproc drivers
#
# CONFIG_STE_MODEM_RPROC is not set

#
# Rpmsg drivers
#
CONFIG_PM_DEVFREQ=y

#
# DEVFREQ Governors
#
CONFIG_DEVFREQ_GOV_SIMPLE_ONDEMAND=y
# CONFIG_DEVFREQ_GOV_PERFORMANCE is not set
CONFIG_DEVFREQ_GOV_POWERSAVE=y
CONFIG_DEVFREQ_GOV_USERSPACE=y

#
# DEVFREQ Drivers
#
CONFIG_EXTCON=y

#
# Extcon Device Drivers
#
CONFIG_EXTCON_GPIO=y
CONFIG_EXTCON_ADC_JACK=y
CONFIG_EXTCON_MAX77693=y
CONFIG_EXTCON_MAX8997=y
CONFIG_EXTCON_PALMAS=y
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
CONFIG_BMA180=y
CONFIG_HID_SENSOR_ACCEL_3D=y
CONFIG_IIO_ST_ACCEL_3AXIS=y
CONFIG_IIO_ST_ACCEL_I2C_3AXIS=y

#
# Analog to digital converters
#
CONFIG_MAX1363=y
CONFIG_MCP3422=y
# CONFIG_NAU7802 is not set
CONFIG_TI_ADC081C=y
CONFIG_TI_AM335X_ADC=y
CONFIG_TWL6030_GPADC=y
CONFIG_VIPERBOARD_ADC=y

#
# Amplifiers
#

#
# Hid Sensor IIO Common
#
CONFIG_HID_SENSOR_IIO_COMMON=y
CONFIG_HID_SENSOR_IIO_TRIGGER=y
# CONFIG_HID_SENSOR_ENUM_BASE_QUIRKS is not set
CONFIG_IIO_ST_SENSORS_I2C=y
CONFIG_IIO_ST_SENSORS_CORE=y

#
# Digital to analog converters
#
CONFIG_AD5064=y
# CONFIG_AD5380 is not set
# CONFIG_AD5446 is not set
# CONFIG_MAX517 is not set
# CONFIG_MCP4725 is not set

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
CONFIG_IIO_ST_GYRO_3AXIS=y
CONFIG_IIO_ST_GYRO_I2C_3AXIS=y
# CONFIG_ITG3200 is not set

#
# Inertial measurement units
#
CONFIG_INV_MPU6050_IIO=y

#
# Light sensors
#
CONFIG_ADJD_S311=y
CONFIG_APDS9300=y
# CONFIG_CM36651 is not set
# CONFIG_GP2AP020A00F is not set
# CONFIG_HID_SENSOR_ALS is not set
# CONFIG_TCS3472 is not set
CONFIG_SENSORS_TSL2563=y
CONFIG_TSL4531=y
# CONFIG_VCNL4000 is not set

#
# Magnetometer sensors
#
CONFIG_AK8975=y
CONFIG_MAG3110=y
CONFIG_HID_SENSOR_MAGNETOMETER_3D=y
CONFIG_IIO_ST_MAGN_3AXIS=y
CONFIG_IIO_ST_MAGN_I2C_3AXIS=y

#
# Triggers - standalone
#
CONFIG_IIO_INTERRUPT_TRIGGER=y
# CONFIG_IIO_SYSFS_TRIGGER is not set

#
# Pressure sensors
#
CONFIG_IIO_ST_PRESS=y
CONFIG_IIO_ST_PRESS_I2C=y

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
CONFIG_PWM=y
CONFIG_PWM_SYSFS=y
# CONFIG_PWM_TWL is not set
# CONFIG_PWM_TWL_LED is not set
CONFIG_IPACK_BUS=y
CONFIG_BOARD_TPCI200=y
CONFIG_SERIAL_IPOCTAL=y
# CONFIG_RESET_CONTROLLER is not set
# CONFIG_FMC is not set
CONFIG_POWERCAP=y
CONFIG_INTEL_RAPL=y

#
# PHY Subsystem
#
CONFIG_GENERIC_PHY=y
CONFIG_PHY_EXYNOS_MIPI_VIDEO=y

#
# Firmware Drivers
#
CONFIG_EDD=y
CONFIG_EDD_OFF=y
# CONFIG_FIRMWARE_MEMMAP is not set
# CONFIG_DELL_RBU is not set
CONFIG_DCDBAS=y
# CONFIG_ISCSI_IBFT_FIND is not set
CONFIG_GOOGLE_FIRMWARE=y

#
# Google Firmware Drivers
#

#
# File systems
#
CONFIG_DCACHE_WORD_ACCESS=y
# CONFIG_FS_POSIX_ACL is not set
CONFIG_FILE_LOCKING=y
CONFIG_FSNOTIFY=y
# CONFIG_DNOTIFY is not set
# CONFIG_INOTIFY_USER is not set
CONFIG_FANOTIFY=y
# CONFIG_FANOTIFY_ACCESS_PERMISSIONS is not set
CONFIG_QUOTA=y
# CONFIG_QUOTA_NETLINK_INTERFACE is not set
# CONFIG_PRINT_QUOTA_WARNING is not set
CONFIG_QUOTA_DEBUG=y
CONFIG_QUOTA_TREE=y
CONFIG_QFMT_V1=y
CONFIG_QFMT_V2=y
CONFIG_QUOTACTL=y
# CONFIG_AUTOFS4_FS is not set
# CONFIG_FUSE_FS is not set

#
# Caches
#
# CONFIG_FSCACHE is not set

#
# Pseudo filesystems
#
# CONFIG_PROC_FS is not set
CONFIG_SYSFS=y
# CONFIG_TMPFS is not set
# CONFIG_HUGETLBFS is not set
# CONFIG_HUGETLB_PAGE is not set
CONFIG_CONFIGFS_FS=y
# CONFIG_MISC_FILESYSTEMS is not set
CONFIG_NETWORK_FILESYSTEMS=y
CONFIG_NLS=y
CONFIG_NLS_DEFAULT="iso8859-1"
# CONFIG_NLS_CODEPAGE_437 is not set
# CONFIG_NLS_CODEPAGE_737 is not set
CONFIG_NLS_CODEPAGE_775=y
# CONFIG_NLS_CODEPAGE_850 is not set
# CONFIG_NLS_CODEPAGE_852 is not set
# CONFIG_NLS_CODEPAGE_855 is not set
# CONFIG_NLS_CODEPAGE_857 is not set
# CONFIG_NLS_CODEPAGE_860 is not set
CONFIG_NLS_CODEPAGE_861=y
CONFIG_NLS_CODEPAGE_862=y
# CONFIG_NLS_CODEPAGE_863 is not set
CONFIG_NLS_CODEPAGE_864=y
# CONFIG_NLS_CODEPAGE_865 is not set
# CONFIG_NLS_CODEPAGE_866 is not set
# CONFIG_NLS_CODEPAGE_869 is not set
CONFIG_NLS_CODEPAGE_936=y
CONFIG_NLS_CODEPAGE_950=y
CONFIG_NLS_CODEPAGE_932=y
# CONFIG_NLS_CODEPAGE_949 is not set
CONFIG_NLS_CODEPAGE_874=y
CONFIG_NLS_ISO8859_8=y
CONFIG_NLS_CODEPAGE_1250=y
CONFIG_NLS_CODEPAGE_1251=y
# CONFIG_NLS_ASCII is not set
CONFIG_NLS_ISO8859_1=y
CONFIG_NLS_ISO8859_2=y
# CONFIG_NLS_ISO8859_3 is not set
CONFIG_NLS_ISO8859_4=y
# CONFIG_NLS_ISO8859_5 is not set
# CONFIG_NLS_ISO8859_6 is not set
CONFIG_NLS_ISO8859_7=y
CONFIG_NLS_ISO8859_9=y
# CONFIG_NLS_ISO8859_13 is not set
CONFIG_NLS_ISO8859_14=y
# CONFIG_NLS_ISO8859_15 is not set
CONFIG_NLS_KOI8_R=y
CONFIG_NLS_KOI8_U=y
CONFIG_NLS_MAC_ROMAN=y
# CONFIG_NLS_MAC_CELTIC is not set
CONFIG_NLS_MAC_CENTEURO=y
CONFIG_NLS_MAC_CROATIAN=y
CONFIG_NLS_MAC_CYRILLIC=y
CONFIG_NLS_MAC_GAELIC=y
# CONFIG_NLS_MAC_GREEK is not set
CONFIG_NLS_MAC_ICELAND=y
CONFIG_NLS_MAC_INUIT=y
CONFIG_NLS_MAC_ROMANIAN=y
CONFIG_NLS_MAC_TURKISH=y
# CONFIG_NLS_UTF8 is not set

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
CONFIG_ENABLE_MUST_CHECK=y
CONFIG_FRAME_WARN=1024
# CONFIG_STRIP_ASM_SYMS is not set
# CONFIG_READABLE_ASM is not set
CONFIG_UNUSED_SYMBOLS=y
CONFIG_DEBUG_FS=y
CONFIG_HEADERS_CHECK=y
# CONFIG_DEBUG_SECTION_MISMATCH is not set
CONFIG_ARCH_WANT_FRAME_POINTERS=y
CONFIG_FRAME_POINTER=y
# CONFIG_DEBUG_FORCE_WEAK_PER_CPU is not set
CONFIG_MAGIC_SYSRQ=y
CONFIG_MAGIC_SYSRQ_DEFAULT_ENABLE=0x1
CONFIG_DEBUG_KERNEL=y

#
# Memory Debugging
#
# CONFIG_DEBUG_PAGEALLOC is not set
CONFIG_DEBUG_OBJECTS=y
# CONFIG_DEBUG_OBJECTS_SELFTEST is not set
# CONFIG_DEBUG_OBJECTS_FREE is not set
CONFIG_DEBUG_OBJECTS_TIMERS=y
CONFIG_DEBUG_OBJECTS_WORK=y
# CONFIG_DEBUG_OBJECTS_RCU_HEAD is not set
CONFIG_DEBUG_OBJECTS_PERCPU_COUNTER=y
CONFIG_DEBUG_OBJECTS_ENABLE_DEFAULT=1
CONFIG_HAVE_DEBUG_KMEMLEAK=y
# CONFIG_DEBUG_KMEMLEAK is not set
CONFIG_DEBUG_STACK_USAGE=y
# CONFIG_DEBUG_VM is not set
CONFIG_DEBUG_VIRTUAL=y
# CONFIG_DEBUG_MEMORY_INIT is not set
CONFIG_MEMORY_NOTIFIER_ERROR_INJECT=y
CONFIG_DEBUG_PER_CPU_MAPS=y
CONFIG_DEBUG_HIGHMEM=y
CONFIG_HAVE_DEBUG_STACKOVERFLOW=y
CONFIG_DEBUG_STACKOVERFLOW=y
CONFIG_HAVE_ARCH_KMEMCHECK=y
# CONFIG_DEBUG_SHIRQ is not set

#
# Debug Lockups and Hangs
#
# CONFIG_LOCKUP_DETECTOR is not set
CONFIG_DETECT_HUNG_TASK=y
CONFIG_DEFAULT_HUNG_TASK_TIMEOUT=120
CONFIG_BOOTPARAM_HUNG_TASK_PANIC=y
CONFIG_BOOTPARAM_HUNG_TASK_PANIC_VALUE=1
CONFIG_PANIC_ON_OOPS=y
CONFIG_PANIC_ON_OOPS_VALUE=1
# CONFIG_DEBUG_PREEMPT is not set

#
# Lock Debugging (spinlocks, mutexes, etc...)
#
CONFIG_DEBUG_RT_MUTEXES=y
CONFIG_DEBUG_PI_LIST=y
CONFIG_RT_MUTEX_TESTER=y
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
# CONFIG_DEBUG_KOBJECT_RELEASE is not set
CONFIG_DEBUG_BUGVERBOSE=y
# CONFIG_DEBUG_WRITECOUNT is not set
CONFIG_DEBUG_LIST=y
CONFIG_DEBUG_SG=y
CONFIG_DEBUG_NOTIFIERS=y
CONFIG_DEBUG_CREDENTIALS=y

#
# RCU Debugging
#
# CONFIG_PROVE_RCU is not set
# CONFIG_PROVE_RCU_DELAY is not set
CONFIG_SPARSE_RCU_POINTER=y
# CONFIG_RCU_TORTURE_TEST is not set
CONFIG_RCU_CPU_STALL_TIMEOUT=21
CONFIG_RCU_CPU_STALL_VERBOSE=y
# CONFIG_RCU_CPU_STALL_INFO is not set
# CONFIG_RCU_TRACE is not set
CONFIG_NOTIFIER_ERROR_INJECTION=y
CONFIG_CPU_NOTIFIER_ERROR_INJECT=y
# CONFIG_PM_NOTIFIER_ERROR_INJECT is not set
# CONFIG_FAULT_INJECTION is not set
CONFIG_ARCH_HAS_DEBUG_STRICT_USER_COPY_CHECKS=y
# CONFIG_DEBUG_STRICT_USER_COPY_CHECKS is not set
CONFIG_USER_STACKTRACE_SUPPORT=y
CONFIG_HAVE_FUNCTION_TRACER=y
CONFIG_HAVE_FUNCTION_GRAPH_TRACER=y
CONFIG_HAVE_FUNCTION_GRAPH_FP_TEST=y
CONFIG_HAVE_FUNCTION_TRACE_MCOUNT_TEST=y
CONFIG_HAVE_DYNAMIC_FTRACE=y
CONFIG_HAVE_DYNAMIC_FTRACE_WITH_REGS=y
CONFIG_HAVE_FTRACE_MCOUNT_RECORD=y
CONFIG_HAVE_SYSCALL_TRACEPOINTS=y
CONFIG_HAVE_C_RECORDMCOUNT=y
CONFIG_TRACING_SUPPORT=y
# CONFIG_FTRACE is not set

#
# Runtime Testing
#
# CONFIG_TEST_LIST_SORT is not set
# CONFIG_BACKTRACE_SELF_TEST is not set
# CONFIG_RBTREE_TEST is not set
# CONFIG_ATOMIC64_SELFTEST is not set
# CONFIG_TEST_STRING_HELPERS is not set
CONFIG_TEST_KSTRTOX=y
CONFIG_PROVIDE_OHCI1394_DMA_INIT=y
CONFIG_BUILD_DOCSRC=y
CONFIG_DMA_API_DEBUG=y
# CONFIG_SAMPLES is not set
CONFIG_HAVE_ARCH_KGDB=y
# CONFIG_KGDB is not set
CONFIG_STRICT_DEVMEM=y
CONFIG_X86_VERBOSE_BOOTUP=y
CONFIG_EARLY_PRINTK=y
CONFIG_EARLY_PRINTK_DBGP=y
CONFIG_X86_PTDUMP=y
# CONFIG_DEBUG_RODATA is not set
# CONFIG_DOUBLEFAULT is not set
CONFIG_DEBUG_TLBFLUSH=y
CONFIG_IOMMU_STRESS=y
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
CONFIG_OPTIMIZE_INLINING=y
# CONFIG_DEBUG_NMI_SELFTEST is not set
# CONFIG_X86_DEBUG_STATIC_CPU_HAS is not set

#
# Security options
#
CONFIG_KEYS=y
CONFIG_PERSISTENT_KEYRINGS=y
# CONFIG_TRUSTED_KEYS is not set
CONFIG_ENCRYPTED_KEYS=y
# CONFIG_KEYS_DEBUG_PROC_KEYS is not set
# CONFIG_SECURITY_DMESG_RESTRICT is not set
CONFIG_SECURITY=y
CONFIG_SECURITYFS=y
CONFIG_SECURITY_NETWORK=y
# CONFIG_SECURITY_PATH is not set
# CONFIG_SECURITY_TOMOYO is not set
# CONFIG_SECURITY_APPARMOR is not set
# CONFIG_SECURITY_YAMA is not set
CONFIG_INTEGRITY=y
# CONFIG_INTEGRITY_SIGNATURE is not set
# CONFIG_IMA is not set
CONFIG_EVM=y
CONFIG_EVM_HMAC_VERSION=2
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
# CONFIG_CRYPTO_USER is not set
# CONFIG_CRYPTO_MANAGER_DISABLE_TESTS is not set
CONFIG_CRYPTO_GF128MUL=y
CONFIG_CRYPTO_NULL=y
CONFIG_CRYPTO_PCRYPT=y
CONFIG_CRYPTO_WORKQUEUE=y
CONFIG_CRYPTO_CRYPTD=y
# CONFIG_CRYPTO_AUTHENC is not set
CONFIG_CRYPTO_ABLK_HELPER=y
CONFIG_CRYPTO_GLUE_HELPER_X86=y

#
# Authenticated Encryption with Associated Data
#
# CONFIG_CRYPTO_CCM is not set
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
CONFIG_CRYPTO_CMAC=y
CONFIG_CRYPTO_HMAC=y
# CONFIG_CRYPTO_XCBC is not set
# CONFIG_CRYPTO_VMAC is not set

#
# Digest
#
CONFIG_CRYPTO_CRC32C=y
CONFIG_CRYPTO_CRC32C_INTEL=y
CONFIG_CRYPTO_CRC32=y
# CONFIG_CRYPTO_CRC32_PCLMUL is not set
CONFIG_CRYPTO_CRCT10DIF=y
CONFIG_CRYPTO_GHASH=y
CONFIG_CRYPTO_MD4=y
CONFIG_CRYPTO_MD5=y
CONFIG_CRYPTO_MICHAEL_MIC=y
CONFIG_CRYPTO_RMD128=y
CONFIG_CRYPTO_RMD160=y
CONFIG_CRYPTO_RMD256=y
CONFIG_CRYPTO_RMD320=y
CONFIG_CRYPTO_SHA1=y
CONFIG_CRYPTO_SHA256=y
CONFIG_CRYPTO_SHA512=y
CONFIG_CRYPTO_TGR192=y
# CONFIG_CRYPTO_WP512 is not set

#
# Ciphers
#
CONFIG_CRYPTO_AES=y
# CONFIG_CRYPTO_AES_586 is not set
# CONFIG_CRYPTO_AES_NI_INTEL is not set
CONFIG_CRYPTO_ANUBIS=y
CONFIG_CRYPTO_ARC4=y
CONFIG_CRYPTO_BLOWFISH=y
CONFIG_CRYPTO_BLOWFISH_COMMON=y
# CONFIG_CRYPTO_CAMELLIA is not set
CONFIG_CRYPTO_CAST_COMMON=y
CONFIG_CRYPTO_CAST5=y
# CONFIG_CRYPTO_CAST6 is not set
CONFIG_CRYPTO_DES=y
CONFIG_CRYPTO_FCRYPT=y
# CONFIG_CRYPTO_KHAZAD is not set
CONFIG_CRYPTO_SALSA20=y
CONFIG_CRYPTO_SALSA20_586=y
CONFIG_CRYPTO_SEED=y
CONFIG_CRYPTO_SERPENT=y
CONFIG_CRYPTO_SERPENT_SSE2_586=y
CONFIG_CRYPTO_TEA=y
CONFIG_CRYPTO_TWOFISH=y
CONFIG_CRYPTO_TWOFISH_COMMON=y
# CONFIG_CRYPTO_TWOFISH_586 is not set

#
# Compression
#
CONFIG_CRYPTO_DEFLATE=y
CONFIG_CRYPTO_ZLIB=y
# CONFIG_CRYPTO_LZO is not set
CONFIG_CRYPTO_LZ4=y
CONFIG_CRYPTO_LZ4HC=y

#
# Random Number Generation
#
# CONFIG_CRYPTO_ANSI_CPRNG is not set
# CONFIG_CRYPTO_USER_API_HASH is not set
# CONFIG_CRYPTO_USER_API_SKCIPHER is not set
CONFIG_CRYPTO_HW=y
CONFIG_CRYPTO_DEV_PADLOCK=y
CONFIG_CRYPTO_DEV_PADLOCK_AES=y
CONFIG_CRYPTO_DEV_PADLOCK_SHA=y
CONFIG_CRYPTO_DEV_GEODE=y
# CONFIG_ASYMMETRIC_KEY_TYPE is not set
CONFIG_HAVE_KVM=y
CONFIG_VIRTUALIZATION=y
# CONFIG_LGUEST is not set
# CONFIG_BINARY_PRINTF is not set

#
# Library routines
#
CONFIG_BITREVERSE=y
CONFIG_GENERIC_STRNCPY_FROM_USER=y
CONFIG_GENERIC_STRNLEN_USER=y
CONFIG_GENERIC_NET_UTILS=y
CONFIG_GENERIC_FIND_FIRST_BIT=y
CONFIG_GENERIC_PCI_IOMAP=y
CONFIG_GENERIC_IOMAP=y
CONFIG_GENERIC_IO=y
CONFIG_CRC_CCITT=y
CONFIG_CRC16=y
# CONFIG_CRC_T10DIF is not set
CONFIG_CRC_ITU_T=y
CONFIG_CRC32=y
# CONFIG_CRC32_SELFTEST is not set
# CONFIG_CRC32_SLICEBY8 is not set
# CONFIG_CRC32_SLICEBY4 is not set
# CONFIG_CRC32_SARWATE is not set
CONFIG_CRC32_BIT=y
CONFIG_CRC7=y
CONFIG_LIBCRC32C=y
# CONFIG_CRC8 is not set
# CONFIG_CRC64_ECMA is not set
CONFIG_ZLIB_INFLATE=y
CONFIG_ZLIB_DEFLATE=y
CONFIG_LZO_COMPRESS=y
CONFIG_LZO_DECOMPRESS=y
CONFIG_LZ4_COMPRESS=y
CONFIG_LZ4HC_COMPRESS=y
CONFIG_LZ4_DECOMPRESS=y
CONFIG_XZ_DEC=y
# CONFIG_XZ_DEC_X86 is not set
CONFIG_XZ_DEC_POWERPC=y
# CONFIG_XZ_DEC_IA64 is not set
CONFIG_XZ_DEC_ARM=y
CONFIG_XZ_DEC_ARMTHUMB=y
CONFIG_XZ_DEC_SPARC=y
CONFIG_XZ_DEC_BCJ=y
# CONFIG_XZ_DEC_TEST is not set
CONFIG_DECOMPRESS_GZIP=y
CONFIG_ASSOCIATIVE_ARRAY=y
CONFIG_HAS_IOMEM=y
CONFIG_HAS_IOPORT=y
CONFIG_HAS_DMA=y
CONFIG_CHECK_SIGNATURE=y
# CONFIG_CPUMASK_OFFSTACK is not set
CONFIG_DQL=y
CONFIG_NLATTR=y
CONFIG_ARCH_HAS_ATOMIC64_DEC_IF_POSITIVE=y
# CONFIG_AVERAGE is not set
# CONFIG_CORDIC is not set
CONFIG_DDR=y
CONFIG_FONT_SUPPORT=y
CONFIG_FONT_8x16=y
CONFIG_FONT_AUTOSELECT=y

--M9NhX3UHpAaciwkO
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

_______________________________________________
LKP mailing list
LKP@linux.intel.com

--M9NhX3UHpAaciwkO--
