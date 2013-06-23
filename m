Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751416Ab3FWEUS (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Jun 2013 00:20:18 -0400
Received: from mga14.intel.com ([143.182.124.37]:59509 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750713Ab3FWEUO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Jun 2013 00:20:14 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,922,1363158000"; 
   d="log'?scan'208";a="354209012"
Date: Sun, 23 Jun 2013 12:19:59 +0800
From: Fengguang Wu <fengguang.wu@intel.com>
To: fengguang.wu@intel.com, linux-kernel@vger.kernel.org
Cc: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Steven Rostedt <rostedt@goodmis.org>
Subject: [tracing/rcu] WARNING: at kernel/lockdep.c:3537 check_flags()
Message-ID: <20130623041959.GA19722@localhost>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="Kj7319i9nmIyA2yE"
Content-Disposition: inline
User-Agent: Heirloom mailx 12.5 6/20/10
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--Kj7319i9nmIyA2yE
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Greetings,

I find the below dmesg in upstream and linux-next.

[    2.456884] Testing tracer branch: 
[    2.458281] ------------[ cut here ]------------
[    2.459813] WARNING: at /c/kernel-tests/src/tip/kernel/lockdep.c:3537 check_flags+0xb7/0x1b0()
[    2.460000] Hardware name: Bochs
[    2.460000] Pid: 3, comm: ksoftirqd/0 Not tainted 3.9.0-rc4-03252-g8b473e1 #58
[    2.460000] Call Trace:

[    2.460000]  [<ffffffff81073cdf>] warn_slowpath_common+0xaf/0xd0
[    2.460000]  [<ffffffff81073dda>] warn_slowpath_null+0x1a/0x20
[    2.460000]  [<ffffffff810e14f7>] check_flags+0xb7/0x1b0
[    2.460000]  [<ffffffff810e2682>] lock_is_held+0x62/0xc0
[    2.460000]  [<ffffffff810c938c>] __might_sleep+0x3c/0x3b0
[    2.460000]  [<ffffffff81082404>] run_ksoftirqd+0xd4/0x130
[    2.460000]  [<ffffffff810bec5c>] smpboot_thread_fn+0x25c/0x2e0
[    2.460000]  [<ffffffff810bea00>] ? lg_global_unlock+0x40/0x40
[    2.460000]  [<ffffffff810b210b>] kthread+0xfb/0x110
[    2.460000]  [<ffffffff810b2010>] ? insert_kthread_work+0x120/0x120
[    2.460000]  [<ffffffff81825c7a>] ret_from_fork+0x7a/0xb0
[    2.460000]  [<ffffffff810b2010>] ? insert_kthread_work+0x120/0x120
[    2.460000] ---[ end trace 3af7e87d98c6254d ]---

Bisecting for "__might_sleep" and the first bad commit is

commit 965a002b4f1a458c5dcb334ec29f48a0046faa25
Author: Paul E. McKenney <paul.mckenney@linaro.org>
Date:   Sat Jun 18 09:55:39 2011 -0700

    rcu: Make TINY_RCU also use softirq for RCU_BOOST=n
    
    This patch #ifdefs TINY_RCU kthreads out of the kernel unless RCU_BOOST=y,
    thus eliminating context-switch overhead if RCU priority boosting has
    not been configured.
    
    Signed-off-by: Paul E. McKenney <paul.mckenney@linaro.org>
    Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>

But note that its parent commit 385680a9487d2f85382ad6d74e2a15837e47bfd9
is not really clean and has this dmesg instead:

[    2.592748] Testing tracer wakeup_rt: PASSED
[    2.936495] Testing tracer branch: 
[    2.940281] ------------[ cut here ]------------
[    2.941194] WARNING: at /c/wfg/mm/kernel/lockdep.c:3363 check_flags.part.31+0xaf/0x1c0()
[    2.942593] Hardware name: Bochs
[    2.943199] Pid: 0, comm: swapper Not tainted 3.1.0-rc8-00019-g385680a #99
[    2.944234] Call Trace:
[    2.944234]  <IRQ>  [<ffffffff81050b9e>] warn_slowpath_common+0x9e/0xd0
[    2.944234]  [<ffffffff81050caa>] warn_slowpath_null+0x1a/0x20
[    2.944234]  [<ffffffff8109fddf>] check_flags.part.31+0xaf/0x1c0
[    2.944234]  [<ffffffff810a49a9>] lock_acquire+0x119/0x230
[    2.944234]  [<ffffffff810657c7>] run_timer_softirq+0x217/0x8a0
[    2.944234]  [<ffffffff81065751>] ? run_timer_softirq+0x1a1/0x8a0
[    2.944234]  [<ffffffff810655a0>] ? ftrace_raw_output_itimer_expire+0x160/0x160
[    2.944234]  [<ffffffff8105c190>] __do_softirq+0x1c0/0x5c0
[    2.944234]  [<ffffffff815b8f7a>] call_softirq+0x1a/0x30
[    2.944234]  [<ffffffff81006465>] do_softirq+0x165/0x290
[    2.944234]  [<ffffffff8105c967>] irq_exit+0xb7/0x130
[    2.944234]  [<ffffffff810237d7>] smp_apic_timer_interrupt+0x77/0xb0
[    2.944234]  [<ffffffff815b8971>] apic_timer_interrupt+0x71/0x80
[    2.944234]  <EOI>  [<ffffffff810e1e75>] ? ftrace_likely_update+0xc5/0x230
[    2.944234]  [<ffffffff810a045d>] ? trace_hardirqs_off+0xd/0x10
[    2.944234]  [<ffffffff8102bdab>] ? native_safe_halt+0xb/0x10
[    2.944234]  [<ffffffff8100f893>] default_idle+0x7d3/0x810
[    2.944234]  [<ffffffff8100131c>] cpu_idle+0x14c/0x160
[    2.944234]  [<ffffffff815922f3>] rest_init+0xe7/0xf4
[    2.944234]  [<ffffffff8159220c>] ? csum_partial_copy_generic+0x16c/0x16c
[    2.944234]  [<ffffffff81c33f15>] start_kernel+0x4f4/0x4ff
[    2.944234]  [<ffffffff81c33000>] ? vsyscall_gtod_data+0xf80/0xf80
[    2.944234]  [<ffffffff81c33000>] ? vsyscall_gtod_data+0xf80/0xf80
[    2.944234]  [<ffffffff81c33169>] x86_64_start_reservations+0x166/0x16a
[    2.944234]  [<ffffffff81c333dd>] x86_64_start_kernel+0x270/0x27f
[    2.944234] ---[ end trace 6d450e935ee1897c ]---
[    2.944234] possible reason: unannotated irqs-on.
[    2.944234] irq event stamp: 10085
[    2.944234] hardirqs last  enabled at (10084): [<ffffffff815b6892>] _raw_spin_unlock_irq+0x32/0x80
[    2.944234] hardirqs last disabled at (10085): [<ffffffff810e1e37>] ftrace_likely_update+0x87/0x230
[    2.944234] softirqs last  enabled at (10076): [<ffffffff8105c8a7>] irq_enter+0x87/0x90
[    2.944234] softirqs last disabled at (10077): [<ffffffff815b8f7a>] call_softirq+0x1a/0x30
[    3.040274] PASSED
[    3.041998] HugeTLB registered 2 MB page size, pre-allocated 0 pages


git bisect start v3.2 v3.1 --
git bisect  bad 68d99b2c8efcb6ed3807a55569300c53b5f88be5  # 10:10      0-  Merge branch 'for-linus' of git://git.kernel.org/pub/scm/linux/kernel/git/tiwai/sound
git bisect good efb8d21b2c6db3497655cc6a033ae8a9883e4063  # 10:18     27+  Merge branch 'tty-next' of git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/tty
git bisect  bad 8686a0e200419322654a75155e2e6f80346a1297  # 10:22      0-  Merge branch 'perf-urgent-for-linus' of git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip
git bisect good 33bc95513c801b1637b6fb925155fb794b5da4f0  # 10:27     27+  staging: brcm80211: remove 'default n' from Kconfig
git bisect good 4d8daa6b77d0697ea19b9c4f704be9b26d76fb36  # 10:34     27+  staging: brcm80211: cleaned up struct brcms_bss_cfg
git bisect good 982653009b883ef1529089e3e6f1ae2fee41cbe2  # 10:38     27+  Merge branch 'core-iommu-for-linus' of git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip
git bisect good 47724df3375bf0cf652039ab6b7ded29fe877de6  # 10:43     27+  Merge branch 'tip/perf/core' of git://git.kernel.org/pub/scm/linux/kernel/git/rostedt/linux-trace into perf/core
git bisect  bad 048b718029033af117870d3da47da12995be14a3  # 10:52      0-  Merge branch 'rcu/next' of git://github.com/paulmckrcu/linux into core/rcu
git bisect  bad e5177ec77d503636d0b609671c9d408b981add17  # 10:56      0-  rcu: Not necessary to pass rcu_read_lock_held() to rcu_dereference_protected()
git bisect good 8008e129dc90ff4f7a56cb033d6bd042afe3ed52  # 11:00     27+  rcu: Drive configuration directly from SMP and PREEMPT
git bisect good e0f23060adfa3f27beaa7918eff70258b88471b6  # 11:04     27+  rcu: Update comments to reflect softirqs vs. kthreads
git bisect  bad 965a002b4f1a458c5dcb334ec29f48a0046faa25  # 11:10      0-  rcu: Make TINY_RCU also use softirq for RCU_BOOST=n
git bisect good 385680a9487d2f85382ad6d74e2a15837e47bfd9  # 11:20     27+  rcu: Add event-trace markers to TREE_RCU kthreads
git bisect good 385680a9487d2f85382ad6d74e2a15837e47bfd9  # 11:24     81+  rcu: Add event-trace markers to TREE_RCU kthreads
git bisect  bad 1d995963014cc2a847f9e18d972a9e845b5c27cd  # 11:24      0-  Merge remote-tracking branch 'stable/master'
git bisect  bad 9e895ace5d82df8929b16f58e9f515f6d54ab82d  # 11:24      0-  Linux 3.10-rc7
git bisect  bad e1a86578747376f08985627c84df088a5d0d1e92  # 11:27      9-  Add linux-next specific files for 20130621

Thanks,
Fengguang

--Kj7319i9nmIyA2yE
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="dmesg-kvm-athens-47639-20130622083515-3.9.0-rc4-03252-g8b473e1-58"

[    0.000000] Initializing cgroup subsys cpu
[    0.000000] Linux version 3.9.0-rc4-03252-g8b473e1 (kbuild@xian) (gcc version 4.8.1 (Debian 4.8.1-3) ) #58 Sat Jun 22 07:55:03 CST 2013
[    0.000000] Command line: hung_task_panic=1 rcutree.rcu_cpu_stall_timeout=100 log_buf_len=8M ignore_loglevel debug sched_debug apic=debug dynamic_printk sysrq_always_enabled panic=10  prompt_ramdisk=0 console=ttyS0,115200 console=tty0 vga=normal  root=/dev/ram0 rw link=/kernel-tests/run-queue/kvm/x86_64-randconfig-x07-0621/sound-unstable:master/.vmlinuz-8b473e1a916c6f379e041de0e7efb4422c65f650-20130622083243-8-athens branch=sound-unstable/master  BOOT_IMAGE=/kernel/x86_64-randconfig-x07-0621/8b473e1a916c6f379e041de0e7efb4422c65f650/vmlinuz-3.9.0-rc4-03252-g8b473e1
[    0.000000] KERNEL supported cpus:
[    0.000000]   Intel GenuineIntel
[    0.000000]   Centaur CentaurHauls
[    0.000000] e820: BIOS-provided physical RAM map:
[    0.000000] BIOS-e820: [mem 0x0000000000000000-0x000000000009fbff] usable
[    0.000000] BIOS-e820: [mem 0x000000000009fc00-0x000000000009ffff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000000f0000-0x00000000000fffff] reserved
[    0.000000] BIOS-e820: [mem 0x0000000000100000-0x000000000fffdfff] usable
[    0.000000] BIOS-e820: [mem 0x000000000fffe000-0x000000000fffffff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000feffc000-0x00000000feffffff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000fffc0000-0x00000000ffffffff] reserved
[    0.000000] debug: ignoring loglevel setting.
[    0.000000] NX (Execute Disable) protection: active
[    0.000000] SMBIOS 2.4 present.
[    0.000000] DMI: Bochs Bochs, BIOS Bochs 01/01/2011
[    0.000000] Hypervisor detected: KVM
[    0.000000] e820: update [mem 0x00000000-0x00000fff] usable ==> reserved
[    0.000000] e820: remove [mem 0x000a0000-0x000fffff] usable
[    0.000000] e820: last_pfn = 0xfffe max_arch_pfn = 0x400000000
[    0.000000] Scan for SMP in [mem 0x00000000-0x000003ff]
[    0.000000] Scan for SMP in [mem 0x0009fc00-0x0009ffff]
[    0.000000] Scan for SMP in [mem 0x000f0000-0x000fffff]
[    0.000000] found SMP MP-table at [mem 0x000fdab0-0x000fdabf] mapped at [ffff8800000fdab0]
[    0.000000]   mpc: fdac0-fdbe4
[    0.000000] Base memory trampoline at [ffff880000099000] 99000 size 24576
[    0.000000] init_memory_mapping: [mem 0x00000000-0x000fffff]
[    0.000000]  [mem 0x00000000-0x000fffff] page 4k
[    0.000000] BRK [0x02b52000, 0x02b52fff] PGTABLE
[    0.000000] BRK [0x02b53000, 0x02b53fff] PGTABLE
[    0.000000] BRK [0x02b54000, 0x02b54fff] PGTABLE
[    0.000000] init_memory_mapping: [mem 0x0e600000-0x0e7fffff]
[    0.000000]  [mem 0x0e600000-0x0e7fffff] page 4k
[    0.000000] BRK [0x02b55000, 0x02b55fff] PGTABLE
[    0.000000] init_memory_mapping: [mem 0x0c000000-0x0e5fffff]
[    0.000000]  [mem 0x0c000000-0x0e5fffff] page 4k
[    0.000000] BRK [0x02b56000, 0x02b56fff] PGTABLE
[    0.000000] init_memory_mapping: [mem 0x00100000-0x0bffffff]
[    0.000000]  [mem 0x00100000-0x0bffffff] page 4k
[    0.000000] init_memory_mapping: [mem 0x0e800000-0x0fffdfff]
[    0.000000]  [mem 0x0e800000-0x0fffdfff] page 4k
[    0.000000] log_buf_len: 8388608
[    0.000000] early log buf free: 127896(97%)
[    0.000000] RAMDISK: [mem 0x0e8d6000-0x0ffeffff]
[    0.000000] ACPI: RSDP 00000000000fd920 00014 (v00 BOCHS )
[    0.000000] ACPI: RSDT 000000000fffe450 00034 (v01 BOCHS  BXPCRSDT 00000001 BXPC 00000001)
[    0.000000] ACPI: FACP 000000000fffff80 00074 (v01 BOCHS  BXPCFACP 00000001 BXPC 00000001)
[    0.000000] ACPI: DSDT 000000000fffe490 011A9 (v01   BXPC   BXDSDT 00000001 INTL 20100528)
[    0.000000] ACPI: FACS 000000000fffff40 00040
[    0.000000] ACPI: SSDT 000000000ffff7a0 00796 (v01 BOCHS  BXPCSSDT 00000001 BXPC 00000001)
[    0.000000] ACPI: APIC 000000000ffff680 00080 (v01 BOCHS  BXPCAPIC 00000001 BXPC 00000001)
[    0.000000] ACPI: HPET 000000000ffff640 00038 (v01 BOCHS  BXPCHPET 00000001 BXPC 00000001)
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] mapped APIC to ffffffffff5fa000 (        fee00000)
[    0.000000] kvm-clock: Using msrs 4b564d01 and 4b564d00
[    0.000000] kvm-clock: cpu 0, msr 0:fffd001, boot clock
[    0.000000]  [ffffea0000000000-ffffea00003fffff] PMD -> [ffff88000d200000-ffff88000d5fffff] on node 0
[    0.000000] Zone ranges:
[    0.000000]   DMA      [mem 0x00001000-0x00ffffff]
[    0.000000]   DMA32    [mem 0x01000000-0xffffffff]
[    0.000000]   Normal   empty
[    0.000000] Movable zone start for each node
[    0.000000] Early memory node ranges
[    0.000000]   node   0: [mem 0x00001000-0x0009efff]
[    0.000000]   node   0: [mem 0x00100000-0x0fffdfff]
[    0.000000] On node 0 totalpages: 65436
[    0.000000]   DMA zone: 64 pages used for memmap
[    0.000000]   DMA zone: 21 pages reserved
[    0.000000]   DMA zone: 3998 pages, LIFO batch:0
[    0.000000]   DMA32 zone: 960 pages used for memmap
[    0.000000]   DMA32 zone: 61438 pages, LIFO batch:15
[    0.000000] ACPI: PM-Timer IO Port: 0xb008
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] mapped APIC to ffffffffff5fa000 (        fee00000)
[    0.000000] ACPI: LAPIC (acpi_id[0x00] lapic_id[0x00] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x01] lapic_id[0x01] enabled)
[    0.000000] ACPI: NR_CPUS/possible_cpus limit of 1 reached.  Processor 1/0x1 ignored.
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0xff] dfl dfl lint[0x1])
[    0.000000] ACPI: IOAPIC (id[0x00] address[0xfec00000] gsi_base[0])
[    0.000000] IOAPIC[0]: apic_id 0, version 17, address 0xfec00000, GSI 0-23
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 00, APIC ID 0, APIC INT 02
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 5 global_irq 5 high level)
[    0.000000] Int: type 0, pol 1, trig 3, bus 00, IRQ 05, APIC ID 0, APIC INT 05
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 high level)
[    0.000000] Int: type 0, pol 1, trig 3, bus 00, IRQ 09, APIC ID 0, APIC INT 09
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 10 global_irq 10 high level)
[    0.000000] Int: type 0, pol 1, trig 3, bus 00, IRQ 0a, APIC ID 0, APIC INT 0a
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 11 global_irq 11 high level)
[    0.000000] Int: type 0, pol 1, trig 3, bus 00, IRQ 0b, APIC ID 0, APIC INT 0b
[    0.000000] ACPI: IRQ0 used by override.
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 01, APIC ID 0, APIC INT 01
[    0.000000] ACPI: IRQ2 used by override.
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 03, APIC ID 0, APIC INT 03
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 04, APIC ID 0, APIC INT 04
[    0.000000] ACPI: IRQ5 used by override.
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 06, APIC ID 0, APIC INT 06
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 07, APIC ID 0, APIC INT 07
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 08, APIC ID 0, APIC INT 08
[    0.000000] ACPI: IRQ9 used by override.
[    0.000000] ACPI: IRQ10 used by override.
[    0.000000] ACPI: IRQ11 used by override.
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 0c, APIC ID 0, APIC INT 0c
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 0d, APIC ID 0, APIC INT 0d
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 0e, APIC ID 0, APIC INT 0e
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 0f, APIC ID 0, APIC INT 0f
[    0.000000] Using ACPI (MADT) for SMP configuration information
[    0.000000] ACPI: HPET id: 0x8086a201 base: 0xfed00000
[    0.000000] mapped IOAPIC to ffffffffff5f9000 (fec00000)
[    0.000000] nr_irqs_gsi: 40
[    0.000000] KVM setup async PF for cpu 0
[    0.000000] kvm-stealtime: cpu 0, msr 1ca4080
[    0.000000] e820: [mem 0x10000000-0xfeffbfff] available for PCI devices
[    0.000000] Booting paravirtualized kernel on KVM
[    0.000000] pcpu-alloc: s0 r0 d32768 u32768 alloc=1*32768
[    0.000000] pcpu-alloc: [0] 0 
[    0.000000] Built 1 zonelists in Zone order, mobility grouping on.  Total pages: 64391
[    0.000000] Kernel command line: hung_task_panic=1 rcutree.rcu_cpu_stall_timeout=100 log_buf_len=8M ignore_loglevel debug sched_debug apic=debug dynamic_printk sysrq_always_enabled panic=10  prompt_ramdisk=0 console=ttyS0,115200 console=tty0 vga=normal  root=/dev/ram0 rw link=/kernel-tests/run-queue/kvm/x86_64-randconfig-x07-0621/sound-unstable:master/.vmlinuz-8b473e1a916c6f379e041de0e7efb4422c65f650-20130622083243-8-athens branch=sound-unstable/master  BOOT_IMAGE=/kernel/x86_64-randconfig-x07-0621/8b473e1a916c6f379e041de0e7efb4422c65f650/vmlinuz-3.9.0-rc4-03252-g8b473e1
[    0.000000] sysrq: sysrq always enabled.
[    0.000000] PID hash table entries: 1024 (order: 1, 8192 bytes)
[    0.000000] Dentry cache hash table entries: 32768 (order: 6, 262144 bytes)
[    0.000000] Inode-cache hash table entries: 16384 (order: 5, 131072 bytes)
[    0.000000] __ex_table already sorted, skipping sort
[    0.000000] Memory: 196192k/262136k available (8354k kernel code, 392k absent, 65552k reserved, 8831k data, 1032k init)
[    0.000000] SLUB: Genslabs=15, HWalign=64, Order=0-3, MinObjects=0, CPUs=1, Nodes=1
[    0.000000] NR_IRQS:4352 nr_irqs:256 16
[    0.000000] console [ttyS0] enabled
[    0.000000] Lock dependency validator: Copyright (c) 2006 Red Hat, Inc., Ingo Molnar
[    0.000000] ... MAX_LOCKDEP_SUBCLASSES:  8
[    0.000000] ... MAX_LOCK_DEPTH:          48
[    0.000000] ... MAX_LOCKDEP_KEYS:        8191
[    0.000000] ... CLASSHASH_SIZE:          4096
[    0.000000] ... MAX_LOCKDEP_ENTRIES:     16384
[    0.000000] ... MAX_LOCKDEP_CHAINS:      32768
[    0.000000] ... CHAINHASH_SIZE:          16384
[    0.000000]  memory used by lock dependency info: 5855 kB
[    0.000000]  per task-struct memory footprint: 1920 bytes
[    0.000000] ODEBUG: 3 of 3 active objects replaced
[    0.000000] ODEBUG: selftest passed
[    0.000000] hpet clockevent registered
[    0.000000] tsc: Detected 2892.988 MHz processor
[    0.012000] Calibrating delay loop (skipped) preset value.. 5785.97 BogoMIPS (lpj=11571952)
[    0.014059] pid_max: default: 4096 minimum: 301
[    0.016264] Mount-cache hash table entries: 256
[    0.021254] Initializing cgroup subsys devices
[    0.024036] Initializing cgroup subsys net_cls
[    0.028020] Initializing cgroup subsys perf_event
[    0.032034] Initializing cgroup subsys net_prio
[    0.036210] Last level iTLB entries: 4KB 0, 2MB 0, 4MB 0
[    0.036210] Last level dTLB entries: 4KB 0, 2MB 0, 4MB 0
[    0.036210] tlb_flushall_shift: 6
[    0.040020] CPU: Intel Common KVM processor (fam: 0f, model: 06, stepping: 01)
[    0.064971] ACPI: Core revision 20130117
[    0.074846] ACPI: All ACPI Tables successfully acquired
[    0.080222] ftrace: allocating 18637 entries in 73 pages
[    0.096322] Performance Events: unsupported Netburst CPU model 6 no PMU driver, software events only.
[    0.100632] Testing tracer nop: PASSED
[    0.103175] Getting VERSION: 50014
[    0.104039] Getting VERSION: 50014
[    0.108025] Getting ID: 0
[    0.112034] Getting ID: ff000000
[    0.115168] Getting LVT0: 8700
[    0.116026] Getting LVT1: 8400
[    0.117193] enabled ExtINT on CPU#0
[    0.125498] ENABLING IO-APIC IRQs
[    0.126702] init IO_APIC IRQs
[    0.127742]  apic 0 pin 0 not connected
[    0.128054] IOAPIC[0]: Set routing entry (0-1 -> 0x31 -> IRQ 1 Mode:0 Active:0 Dest:1)
[    0.132060] IOAPIC[0]: Set routing entry (0-2 -> 0x30 -> IRQ 0 Mode:0 Active:0 Dest:1)
[    0.136054] IOAPIC[0]: Set routing entry (0-3 -> 0x33 -> IRQ 3 Mode:0 Active:0 Dest:1)
[    0.140057] IOAPIC[0]: Set routing entry (0-4 -> 0x34 -> IRQ 4 Mode:0 Active:0 Dest:1)
[    0.144056] IOAPIC[0]: Set routing entry (0-5 -> 0x35 -> IRQ 5 Mode:1 Active:0 Dest:1)
[    0.148045] IOAPIC[0]: Set routing entry (0-6 -> 0x36 -> IRQ 6 Mode:0 Active:0 Dest:1)
[    0.150662] IOAPIC[0]: Set routing entry (0-7 -> 0x37 -> IRQ 7 Mode:0 Active:0 Dest:1)
[    0.152065] IOAPIC[0]: Set routing entry (0-8 -> 0x38 -> IRQ 8 Mode:0 Active:0 Dest:1)
[    0.156053] IOAPIC[0]: Set routing entry (0-9 -> 0x39 -> IRQ 9 Mode:1 Active:0 Dest:1)
[    0.160052] IOAPIC[0]: Set routing entry (0-10 -> 0x3a -> IRQ 10 Mode:1 Active:0 Dest:1)
[    0.164068] IOAPIC[0]: Set routing entry (0-11 -> 0x3b -> IRQ 11 Mode:1 Active:0 Dest:1)
[    0.168047] IOAPIC[0]: Set routing entry (0-12 -> 0x3c -> IRQ 12 Mode:0 Active:0 Dest:1)
[    0.172054] IOAPIC[0]: Set routing entry (0-13 -> 0x3d -> IRQ 13 Mode:0 Active:0 Dest:1)
[    0.176046] IOAPIC[0]: Set routing entry (0-14 -> 0x3e -> IRQ 14 Mode:0 Active:0 Dest:1)
[    0.179015] IOAPIC[0]: Set routing entry (0-15 -> 0x3f -> IRQ 15 Mode:0 Active:0 Dest:1)
[    0.180091]  apic 0 pin 16 not connected
[    0.181469]  apic 0 pin 17 not connected
[    0.184009]  apic 0 pin 18 not connected
[    0.186114]  apic 0 pin 19 not connected
[    0.188012]  apic 0 pin 20 not connected
[    0.189342]  apic 0 pin 21 not connected
[    0.192012]  apic 0 pin 22 not connected
[    0.193721]  apic 0 pin 23 not connected
[    0.196271] ..TIMER: vector=0x30 apic1=0 pin1=2 apic2=-1 pin2=-1
[    0.200012] Using local APIC timer interrupts.
[    0.200012] calibrating APIC timer ...
[    0.208000] ... lapic delta = 6250043
[    0.208000] ... PM-Timer delta = 357969
[    0.208000] ... PM-Timer result ok
[    0.208000] ..... delta 6250043
[    0.208000] ..... mult: 268437302
[    0.208000] ..... calibration result: 4000027
[    0.208000] ..... CPU clock speed is 2893.0789 MHz.
[    0.208000] ..... host bus clock speed is 1000.0027 MHz.
[    0.209309] devtmpfs: initialized
[    0.215712] Testing tracer function: PASSED
[    0.484805] Testing dynamic ftrace: PASSED
[    0.832335] Testing dynamic ftrace ops #1: (1 0 1 1 0) (1 1 2 1 0) (2 1 3 1 3) (2 2 4 1 81) PASSED
[    1.090913] Testing dynamic ftrace ops #2: (1 0 1 3 0) (1 1 2 81 0) (2 1 3 1 3) (2 2 4 79 81) PASSED
[    1.407158] Testing ftrace recursion: PASSED
[    1.427393] Testing ftrace recursion safe: PASSED
[    1.453840] Testing ftrace regs: PASSED
[    1.497411] Testing tracer irqsoff: PASSED
[    1.755494] Testing tracer wakeup: ret = 0
[    2.064335] PASSED
[    2.065249] Testing tracer wakeup_rt: ret = 0
[    2.456190] PASSED
[    2.456884] Testing tracer branch: 
[    2.458281] ------------[ cut here ]------------
[    2.459813] WARNING: at /c/kernel-tests/src/tip/kernel/lockdep.c:3537 check_flags+0xb7/0x1b0()
[    2.460000] Hardware name: Bochs
[    2.460000] Pid: 3, comm: ksoftirqd/0 Not tainted 3.9.0-rc4-03252-g8b473e1 #58
[    2.460000] Call Trace:

[    2.460000]  [<ffffffff81073cdf>] warn_slowpath_common+0xaf/0xd0
[    2.460000]  [<ffffffff81073dda>] warn_slowpath_null+0x1a/0x20
[    2.460000]  [<ffffffff810e14f7>] check_flags+0xb7/0x1b0
[    2.460000]  [<ffffffff810e2682>] lock_is_held+0x62/0xc0
[    2.460000]  [<ffffffff810c938c>] __might_sleep+0x3c/0x3b0
[    2.460000]  [<ffffffff81082404>] run_ksoftirqd+0xd4/0x130
[    2.460000]  [<ffffffff810bec5c>] smpboot_thread_fn+0x25c/0x2e0
[    2.460000]  [<ffffffff810bea00>] ? lg_global_unlock+0x40/0x40
[    2.460000]  [<ffffffff810b210b>] kthread+0xfb/0x110
[    2.460000]  [<ffffffff810b2010>] ? insert_kthread_work+0x120/0x120
[    2.460000]  [<ffffffff81825c7a>] ret_from_fork+0x7a/0xb0
[    2.460000]  [<ffffffff810b2010>] ? insert_kthread_work+0x120/0x120
[    2.460000] ---[ end trace 3af7e87d98c6254d ]---
[    2.460000] possible reason: unannotated irqs-on.
[    2.460000] irq event stamp: 404
[    2.460000] hardirqs last  enabled at (403): [<ffffffff810823bb>] run_ksoftirqd+0x8b/0x130
[    2.460000] hardirqs last disabled at (404): [<ffffffff8112dd1c>] ftrace_likely_update+0x6c/0x230
[    2.460000] softirqs last  enabled at (402): [<ffffffff810821e9>] __do_softirq+0x5b9/0x700
[    2.460000] softirqs last disabled at (307): [<ffffffff810823ac>] run_ksoftirqd+0x7c/0x130
[    2.560246] PASSED
[    2.562815] NET: Registered protocol family 16
[    2.564491] ACPI: bus type PCI registered
[    2.565992] PCI: Using configuration type 1 for base access
[    2.568518] ACPI: Added _OSI(Module Device)
[    2.572013] ACPI: Added _OSI(Processor Device)
[    2.576016] ACPI: Added _OSI(3.0 _SCP Extensions)
[    2.584018] ACPI: Added _OSI(Processor Aggregator Device)
[    2.594700] ACPI: EC: Look up EC in DSDT
[    2.615292] ACPI: Interpreter enabled
[    2.616025] ACPI: (supports S0 S5)
[    2.620009] ACPI: Using IOAPIC for interrupt routing
[    2.624052] PCI: Using host bridge windows from ACPI; if necessary, use "pci=nocrs" and report a bug
[    2.653727] ACPI: PCI Root Bridge [PCI0] (domain 0000 [bus 00-ff])
[    2.656026] acpi PNP0A03:00: Unable to request _OSC control (_OSC support mask: 0x08)
[    2.664033] PCI host bridge to bus 0000:00
[    2.668015] pci_bus 0000:00: root bus resource [bus 00-ff]
[    2.672000] pci_bus 0000:00: root bus resource [io  0x0000-0x0cf7]
[    2.672000] pci_bus 0000:00: root bus resource [io  0x0d00-0xffff]
[    2.676019] pci_bus 0000:00: root bus resource [mem 0x000a0000-0x000bffff]
[    2.680018] pci_bus 0000:00: root bus resource [mem 0x80000000-0xfebfffff]
[    2.684147] pci 0000:00:00.0: [8086:1237] type 00 class 0x060000
[    2.697734] pci 0000:00:01.0: [8086:7000] type 00 class 0x060100
[    2.701832] pci 0000:00:01.1: [8086:7010] type 00 class 0x010180
[    2.704000] pci 0000:00:01.1: reg 20: [io  0xc1e0-0xc1ef]
[    2.704422] pci 0000:00:01.3: [8086:7113] type 00 class 0x068000
[    2.713412] pci 0000:00:01.3: quirk: [io  0xb000-0xb03f] claimed by PIIX4 ACPI
[    2.716041] pci 0000:00:01.3: quirk: [io  0xb100-0xb10f] claimed by PIIX4 SMB
[    2.720477] pci 0000:00:02.0: [1013:00b8] type 00 class 0x030000
[    2.729353] pci 0000:00:02.0: reg 10: [mem 0xfc000000-0xfdffffff pref]
[    2.737905] pci 0000:00:02.0: reg 14: [mem 0xfebe0000-0xfebe0fff]
[    2.760257] pci 0000:00:02.0: reg 30: [mem 0xfebc0000-0xfebcffff pref]
[    2.765270] pci 0000:00:03.0: [1af4:1000] type 00 class 0x020000
[    2.773535] pci 0000:00:03.0: reg 10: [io  0xc1c0-0xc1df]
[    2.777993] pci 0000:00:03.0: reg 14: [mem 0xfebe1000-0xfebe1fff]
[    2.805532] pci 0000:00:03.0: reg 30: [mem 0xfebd0000-0xfebdffff pref]
[    2.815207] pci 0000:00:04.0: [8086:100e] type 00 class 0x020000
[    2.824085] pci 0000:00:04.0: reg 10: [mem 0xfeb80000-0xfeb9ffff]
[    2.837100] pci 0000:00:04.0: reg 14: [io  0xc000-0xc03f]
[    2.848022] pci 0000:00:04.0: reg 30: [mem 0xfeba0000-0xfebbffff pref]
[    2.856890] pci 0000:00:05.0: [1af4:1001] type 00 class 0x010000
[    2.868080] pci 0000:00:05.0: reg 10: [io  0xc040-0xc07f]
[    2.880042] pci 0000:00:05.0: reg 14: [mem 0xfebe2000-0xfebe2fff]
[    2.903268] pci 0000:00:06.0: [1af4:1001] type 00 class 0x010000
[    2.912050] pci 0000:00:06.0: reg 10: [io  0xc080-0xc0bf]
[    2.920025] pci 0000:00:06.0: reg 14: [mem 0xfebe3000-0xfebe3fff]
[    2.953273] pci 0000:00:07.0: [1af4:1001] type 00 class 0x010000
[    2.961241] pci 0000:00:07.0: reg 10: [io  0xc0c0-0xc0ff]
[    2.969134] pci 0000:00:07.0: reg 14: [mem 0xfebe4000-0xfebe4fff]
[    2.998202] pci 0000:00:08.0: [1af4:1001] type 00 class 0x010000
[    3.009451] pci 0000:00:08.0: reg 10: [io  0xc100-0xc13f]
[    3.021534] pci 0000:00:08.0: reg 14: [mem 0xfebe5000-0xfebe5fff]
[    3.039430] pci 0000:00:09.0: [1af4:1001] type 00 class 0x010000
[    3.041887] pci 0000:00:09.0: reg 10: [io  0xc140-0xc17f]
[    3.045790] pci 0000:00:09.0: reg 14: [mem 0xfebe6000-0xfebe6fff]
[    3.060779] pci 0000:00:0a.0: [1af4:1001] type 00 class 0x010000
[    3.068940] pci 0000:00:0a.0: reg 10: [io  0xc180-0xc1bf]
[    3.073835] pci 0000:00:0a.0: reg 14: [mem 0xfebe7000-0xfebe7fff]
[    3.076000] pci 0000:00:0b.0: [8086:25ab] type 00 class 0x088000
[    3.076000] pci 0000:00:0b.0: reg 10: [mem 0xfebe8000-0xfebe800f]
[    3.076544] pci_bus 0000:00: on NUMA node 0
[    3.080033] ACPI _OSC control for PCIe not granted, disabling ASPM
[    3.089497] ACPI: PCI Interrupt Link [LNKA] (IRQs 5 *10 11)
[    3.096249] ACPI: PCI Interrupt Link [LNKB] (IRQs 5 *10 11)
[    3.101129] ACPI: PCI Interrupt Link [LNKC] (IRQs 5 10 *11)
[    3.105590] ACPI: PCI Interrupt Link [LNKD] (IRQs 5 10 *11)
[    3.109472] ACPI: PCI Interrupt Link [LNKS] (IRQs *9)
[    3.113954] ACPI: Enabled 16 GPEs in block 00 to 0F
[    3.116035] acpi root: \_SB_.PCI0 notify handler is installed
[    3.120129] Found 1 acpi root devices
[    3.125068] vgaarb: device added: PCI:0000:00:02.0,decodes=io+mem,owns=io+mem,locks=none
[    3.128020] vgaarb: loaded
[    3.129812] vgaarb: bridge control possible 0000:00:02.0
[    3.132347] Linux video capture interface: v2.00
[    3.136074] pps_core: LinuxPPS API ver. 1 registered
[    3.140015] pps_core: Software ver. 5.3.6 - Copyright 2005-2007 Rodolfo Giometti <giometti@linux.it>
[    3.144033] PTP clock support registered
[    3.148271] PCI: Using ACPI for IRQ routing
[    3.152027] PCI: pci_cache_line_size set to 64 bytes
[    3.156398] e820: reserve RAM buffer [mem 0x0009fc00-0x0009ffff]
[    3.160024] e820: reserve RAM buffer [mem 0x0fffe000-0x0fffffff]
[    3.164718] NET: Registered protocol family 23
[    3.168906] cfg80211: Calling CRDA to update world regulatory domain
[    3.172310] nfc: nfc_init: NFC Core ver 0.1
[    3.175039] NET: Registered protocol family 39
[    3.176546] Switching to clocksource kvm-clock
[    3.180950] Warning: could not register all branches stats
[    3.184627] Warning: could not register annotated branches stats
[    3.238150] pnp: PnP ACPI init
[    3.240129] ACPI: bus type PNP registered
[    3.244462] IOAPIC[0]: Set routing entry (0-8 -> 0x38 -> IRQ 8 Mode:0 Active:0 Dest:1)
[    3.272462] pnp 00:00: Plug and Play ACPI device, IDs PNP0b00 (active)
[    3.276609] IOAPIC[0]: Set routing entry (0-1 -> 0x31 -> IRQ 1 Mode:0 Active:0 Dest:1)
[    3.287290] pnp 00:01: Plug and Play ACPI device, IDs PNP0303 (active)
[    3.291658] IOAPIC[0]: Set routing entry (0-12 -> 0x3c -> IRQ 12 Mode:0 Active:0 Dest:1)
[    3.305034] pnp 00:02: Plug and Play ACPI device, IDs PNP0f13 (active)
[    3.309105] IOAPIC[0]: Set routing entry (0-6 -> 0x36 -> IRQ 6 Mode:0 Active:0 Dest:1)
[    3.323779] pnp 00:03: [dma 2]
[    3.325584] pnp 00:03: Plug and Play ACPI device, IDs PNP0700 (active)
[    3.329761] IOAPIC[0]: Set routing entry (0-7 -> 0x37 -> IRQ 7 Mode:0 Active:0 Dest:1)
[    3.336751] pnp 00:04: Plug and Play ACPI device, IDs PNP0400 (active)
[    3.343346] IOAPIC[0]: Set routing entry (0-4 -> 0x34 -> IRQ 4 Mode:0 Active:0 Dest:1)
[    3.349778] pnp 00:05: Plug and Play ACPI device, IDs PNP0501 (active)
[    3.354947] pnp 00:06: Plug and Play ACPI device, IDs PNP0103 (active)
[    3.360164] pnp: PnP ACPI: found 7 devices
[    3.363169] ACPI: bus type PNP unregistered
[    3.372590] pci_bus 0000:00: resource 4 [io  0x0000-0x0cf7]
[    3.376852] pci_bus 0000:00: resource 5 [io  0x0d00-0xffff]
[    3.380813] pci_bus 0000:00: resource 6 [mem 0x000a0000-0x000bffff]
[    3.384815] pci_bus 0000:00: resource 7 [mem 0x80000000-0xfebfffff]
[    3.389625] NET: Registered protocol family 1
[    3.392937] pci 0000:00:00.0: Limiting direct PCI/PCI transfers
[    3.397204] pci 0000:00:01.0: PIIX3: Enabling Passive Release
[    3.401414] pci 0000:00:01.0: Activating ISA DMA hang workarounds
[    3.406796] pci 0000:00:02.0: Boot video device
[    3.410848] PCI: CLS 0 bytes, default 64
[    3.415757] Unpacking initramfs...
[    5.551229] debug: unmapping init [mem 0xffff88000e8d6000-0xffff88000ffeffff]
[    5.564224] microcode: CPU0 sig=0xf61, pf=0x1, revision=0x1
[    5.571500] microcode: Microcode Update Driver: v2.00 <tigran@aivazian.fsnet.co.uk>, Peter Oruba
[    5.585115] camellia-x86_64: performance on this CPU would be suboptimal: disabling camellia-x86_64.
[    5.590378] AVX or AES-NI instructions are not detected.
[    5.593586] AVX instructions are not detected.
[    5.596334] twofish-x86_64-3way: performance on this CPU would be suboptimal: disabling twofish-x86_64-3way.
[    5.602715] AVX instructions are not detected.
[    5.605834] sha1_ssse3: Neither AVX nor SSSE3 is available/usable.
[    5.610098] PCLMULQDQ-NI instructions are not detected.
[    5.614048] audit: initializing netlink socket (disabled)
[    5.617932] type=2000 audit(1371861233.616:1): initialized
[    5.622343] HugeTLB registered 2 MB page size, pre-allocated 0 pages
[    5.631836] NET: Registered protocol family 38
[    5.634988] Key type asymmetric registered
[    5.639056] xz_dec_test: module loaded
[    5.641721] xz_dec_test: Create a device node with 'mknod xz_dec_test c 250 0' and write .xz files to it.
[    5.648512] ipmi message handler version 39.2
[    5.651520] IPMI System Interface driver.
[    5.654142] ipmi_si: Adding default-specified kcs state machine
[    5.657624] ipmi_si: Trying default-specified kcs state machine at i/o address 0xca2, slave address 0x0, irq 0
[    5.663567] ipmi_si: Interface detection failed
[    5.666476] ipmi_si: Adding default-specified smic state machine
[    5.670188] ipmi_si: Trying default-specified smic state machine at i/o address 0xca9, slave address 0x0, irq 0
[    5.676184] ipmi_si: Interface detection failed
[    5.679217] ipmi_si: Adding default-specified bt state machine
[    5.682976] ipmi_si: Trying default-specified bt state machine at i/o address 0xe4, slave address 0x0, irq 0
[    5.689294] ipmi_si: Interface detection failed
[    5.692522] ipmi_si: Unable to find any System Interface(s)
[    5.696451] IPMI Watchdog: driver initialized
[    5.699420] Copyright (C) 2004 MontaVista Software - IPMI Powerdown via sys_reboot.
[    5.705920] input: Power Button as /devices/LNXSYSTM:00/LNXPWRBN:00/input/input0
[    5.712047] ACPI: Power Button [PWRF]
[    5.715825] r3964: Philips r3964 Driver $Revision: 1.10 $
[    5.719551] Serial: 8250/16550 driver, 4 ports, IRQ sharing disabled
[    5.771819] 00:05: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
[    5.776745] lp: driver loaded but no devices found
[    5.779933] Non-volatile memory driver v1.3
[    5.782932] ppdev: user-space parallel port driver
[    5.786544] smapi::smapi_init, ERROR invalid usSmapiID
[    5.799117] mwave: tp3780i::tp3780I_InitializeBoardData: Error: SMAPI is not available on this machine
[    5.805403] mwave: mwavedd::mwave_init: Error: Failed to initialize board data
[    5.810311] mwave: mwavedd::mwave_init: Error: Failed to initialize
[    5.814570] Hangcheck: starting hangcheck timer 0.9.1 (tick is 180 seconds, margin is 60 seconds).
[    5.820682] Hangcheck: Using getrawmonotonic().
[    5.824523] ipddp.c:v0.01 8/28/97 Bradford W. Johnson <johns393@maroon.tc.umn.edu>
[    5.829730] ipddp0: Appletalk-IP Decap. mode by Jay Schulist <jschlst@samba.org>
[    5.835646] AX.25: 6pack driver, Revision: 0.3.0
[    5.838794] YAM driver version 0.8 by F1OAT/F6FBB
[    5.842294] AX.25: bpqether driver version 004
[    5.845377] baycom_ser_fdx: (C) 1996-2000 Thomas Sailer, HB9JNX/AE4WA
[    5.845377] baycom_ser_fdx: version 0.10
[    5.852812] hdlcdrv: (C) 1996-2000 Thomas Sailer HB9JNX/AE4WA
[    5.858090] hdlcdrv: version 0.8
[    5.860107] baycom_ser_hdx: (C) 1996-2000 Thomas Sailer, HB9JNX/AE4WA
[    5.860107] baycom_ser_hdx: version 0.10
[    5.867287] baycom_par: (C) 1996-2000 Thomas Sailer, HB9JNX/AE4WA
[    5.867287] baycom_par: version 0.9
[    5.873850] PPP generic driver version 2.4.2
[    5.876812] PPP BSD Compression module registered
[    5.879556] PPP Deflate Compression module registered
[    5.882887] PPP MPPE Compression module registered
[    5.886167] NET: Registered protocol family 24
[    5.888951] SLIP: version 0.8.4-NET3.019-NEWTTY (dynamic channels, max=256) (6 bit encapsulation enabled).
[    5.895305] hdlc: HDLC support module revision 1.22
[    5.899108] DLCI driver v0.35, 4 Jan 1997, mike.mclagan@linux.org.
[    5.903296] Broadcom 43xx-legacy driver loaded [ Features: PI ]
[    5.907362] i8042: PNP: PS/2 Controller [PNP0303:KBD,PNP0f13:MOU] at 0x60,0x64 irq 1,12
[    5.914916] serio: i8042 KBD port at 0x60,0x64 irq 1
[    5.917985] serio: i8042 AUX port at 0x60,0x64 irq 12
[    5.921280] parkbd: no such parport
[    6.124781] mk712: device not present
[    6.127439] lirc_dev: IR Remote Control driver registered, major 246 
[    6.133641] IR NEC protocol handler initialized
[    6.136665] IR RC5(x) protocol handler initialized
[    6.139736] IR JVC protocol handler initialized
[    6.142983] IR Sony protocol handler initialized
[    6.146123] IR RC5 (streamzap) protocol handler initialized
[    6.149934] IR SANYO protocol handler initialized
[    6.169887] IR MCE Keyboard/mouse protocol handler initialized
[    6.177768] IR LIRC bridge handler initialized
[    6.185815] input: AT Translated Set 2 keyboard as /devices/platform/i8042/serio0/input/input1
[    6.198190] pps pps0: new PPS source ktimer
[    6.205164] pps pps0: ktimer PPS source registered
[    6.208445] pps_ldisc: PPS line discipline registered
[    6.215837] pps_parport: parallel port PPS client
[    6.219656] pc87360: PC8736x not detected, module not inserted
[    6.223797] sch56xx_common: Unsupported device id: 0xff
[    6.227404] sch56xx_common: Unsupported device id: 0xff
[    6.231294] intel_powerclamp: Intel powerclamp does not run on family 15 model 6
[    6.236173] acquirewdt: WDT driver for Acquire single board computer initialising
[    6.241490] acquirewdt: I/O address 0x0043 already in use
[    6.245249] acquirewdt: probe of acquirewdt failed with error -5
[    6.249332] advantechwdt: WDT driver for Advantech single board computer initialising
[    6.254946] advantechwdt: initialized. timeout=60 sec (nowayout=1)
[    6.259509] sc520_wdt: cannot register miscdev on minor=130 (err=-16)
[    6.264073] wafer5823wdt: WDT driver for Wafer 5823 single board computer initialising
[    6.269602] wafer5823wdt: I/O address 0x0443 already in use
[    6.273676] it87_wdt: no device
[    6.275828] sc1200wdt: build 20020303
[    6.278701] sc1200wdt: io parameter must be specified
[    6.282257] sbc60xxwdt: I/O address 0x0443 already in use
[    6.285331] sbc8360: failed to register misc device
[    6.288705] cpu5wdt: misc_register failed
[    6.291600] smsc37b787_wdt: SMsC 37B787 watchdog component driver 1.1 initialising...
[    6.298156] smsc37b787_wdt: Unable to register miscdev on minor 130
[    6.302533] w83877f_wdt: I/O address 0x0443 already in use
[    6.306379] w83977f_wdt: driver v1.00
[    6.309031] w83977f_wdt: cannot register miscdev on minor=130 (err=-16)
[    6.313556] machzwd: MachZ ZF-Logic Watchdog driver initializing
[    6.317877] machzwd: no ZF-Logic found
[    6.320476] sbc_epx_c3: cannot register miscdev on minor=130 (err=-16)
[    6.324930] cpuidle: using governor ladder
[    6.327628] cpuidle: using governor menu
[    6.330484] dcdbas dcdbas: Dell Systems Management Base Driver (version 5.6.0-3.2)
[    6.336072] NET: Registered protocol family 26
[    6.339133] GACT probability NOT on
[    6.341868] u32 classifier
[    6.343742]     Performance counters on
[    6.346300]     input device check on
[    6.348894]     Actions configured
[    6.351311] NET: Registered protocol family 15
[    6.354470] Ebtables v2.0 registered
[    6.357221] NET: Registered protocol family 5
[    6.360260] NET: Registered protocol family 9
[    6.364468] X.25 for Linux Version 0.2
[    6.366840] NET: Registered protocol family 3
[    6.370235] IrCOMM protocol (Dag Brattli)
[    6.374530] NET4: DECnet for Linux: V.2.5.68s (C) 1995-2003 Linux DECnet Project Team
[    6.379969] DECnet: Routing cache hash table of 128 buckets, 8Kbytes
[    6.384607] NET: Registered protocol family 12
[    6.387750] lib80211: common routines for IEEE802.11 drivers
[    6.391809] lib80211_crypt: registered algorithm 'NULL'
[    6.395482] lib80211_crypt: registered algorithm 'WEP'
[    6.399189] lib80211_crypt: registered algorithm 'CCMP'
[    6.402899] lib80211_crypt: registered algorithm 'TKIP'
[    6.406674] 9pnet: Installing 9P2000 support
[    6.409822] NET: Registered protocol family 36
[    6.413093] Key type dns_resolver registered
[    6.416249] 
[    6.416249] printing PIC contents
[    6.419677] ... PIC  IMR: ffff
[    6.420019] ... PIC  IRR: 1013
[    6.424154] ... PIC  ISR: 0000
[    6.426312] ... PIC ELCR: 0c00
[    6.428533] printing local APIC contents on CPU#0/0:
[    6.431918] ... APIC ID:      00000000 (0)
[    6.432499] ... APIC VERSION: 00050014
[    6.432499] ... APIC TASKPRI: 00000000 (00)
[    6.432499] ... APIC PROCPRI: 00000000
[    6.432499] ... APIC LDR: 01000000
[    6.432499] ... APIC DFR: ffffffff
[    6.432499] ... APIC SPIV: 000001ff
[    6.432499] ... APIC ISR field:
[    6.432499] 0000000000000000000000000000000000000000000000000000000000000000
[    6.432499] ... APIC TMR field:
[    6.432499] 0000000000000000000000000000000000000000000000000000000000000000
[    6.432499] ... APIC IRR field:
[    6.432499] 0000000000000000000000000000000000000000000000000000000000008000
[    6.432499] ... APIC ESR: 00000000
[    6.432499] ... APIC ICR: 00000831
[    6.432499] ... APIC ICR2: 01000000
[    6.432499] ... APIC LVTT: 000000ef
[    6.432499] ... APIC LVTPC: 00010000
[    6.432499] ... APIC LVT0: 00010700
[    6.432499] ... APIC LVT1: 00000400
[    6.432499] ... APIC LVTERR: 000000fe
[    6.432499] ... APIC TMICT: 000355df
[    6.432499] ... APIC TMCCT: 00000000
[    6.432499] ... APIC TDCR: 00000003
[    6.432499] 
[    6.495951] number of MP IRQ sources: 15.
[    6.498557] number of IO-APIC #0 registers: 24.
[    6.501569] testing the IO APIC.......................
[    6.504858] IO APIC #0......
[    6.506596] .... register #00: 00000000
[    6.509097] .......    : physical APIC id: 00
[    6.511884] .......    : Delivery Type: 0
[    6.514540] .......    : LTS          : 0
[    6.517268] .... register #01: 00170011
[    6.519605] .......     : max redirection entries: 17
[    6.522929] .......     : PRQ implemented: 0
[    6.525499] .......     : IO APIC version: 11
[    6.529154] .... register #02: 00000000
[    6.532534] .......     : arbitration: 00
[    6.535141] .... IRQ redirection table:
[    6.542907] 1    0    0   0   0    0    0    00
[    6.545738] 0    0    0   0   0    1    1    31
[    6.548796] 0    0    0   0   0    1    1    30
[    6.551573] 0    0    0   0   0    1    1    33
[    6.554696] 1    0    0   0   0    1    1    34
[    6.557600] 1    1    0   0   0    1    1    35
[    6.560822] 0    0    0   0   0    1    1    36
[    6.563552] 0    0    0   0   0    1    1    37
[    6.566328] 0    0    0   0   0    1    1    38
[    6.569308] 0    1    0   0   0    1    1    39
[    6.571938] 1    1    0   0   0    1    1    3A
[    6.574730] 1    1    0   0   0    1    1    3B
[    6.577444] 0    0    0   0   0    1    1    3C
[    6.580541] 0    0    0   0   0    1    1    3D
[    6.583737] 0    0    0   0   0    1    1    3E
[    6.587201] 0    0    0   0   0    1    1    3F
[    6.590450] 1    0    0   0   0    0    0    00
[    6.594386] 1    0    0   0   0    0    0    00
[    6.597590] 1    0    0   0   0    0    0    00
[    6.600708] 1    0    0   0   0    0    0    00
[    6.603728] 1    0    0   0   0    0    0    00
[    6.606893] 1    0    0   0   0    0    0    00
[    6.610206] 1    0    0   0   0    0    0    00
[    6.613422] 1    0    0   0   0    0    0    00
[    6.618173] IRQ to pin mappings:
[    6.620519] IRQ0 -> 0:2
[    6.622398] IRQ1 -> 0:1
[    6.624309] IRQ3 -> 0:3
[    6.626229] IRQ4 -> 0:4
[    6.628087] IRQ5 -> 0:5
[    6.630047] IRQ6 -> 0:6
[    6.632093] IRQ7 -> 0:7
[    6.634001] IRQ8 -> 0:8
[    6.635791] IRQ9 -> 0:9
[    6.637726] IRQ10 -> 0:10
[    6.639643] IRQ11 -> 0:11
[    6.641859] IRQ12 -> 0:12
[    6.643816] IRQ13 -> 0:13
[    6.645970] IRQ14 -> 0:14
[    6.647897] IRQ15 -> 0:15
[    6.649994] .................................... done.
[    6.654810] tsc: Refined TSC clocksource calibration: 2893.033 MHz
[    6.659539] registered taskstats version 1
[    6.662432] Running tests on trace events:
[    6.665388] Testing event 9p_client_req: OK
[    6.676540] Testing event 9p_client_res: OK
[    6.684395] Testing event 9p_protocol_dump: OK
[    6.692458] Testing event drv_return_void: OK
[    6.700412] Testing event drv_return_int: OK
[    6.708402] Testing event drv_return_bool: OK
[    6.716423] Testing event drv_return_u64: OK
[    6.724411] Testing event drv_start: OK
[    6.732635] Testing event drv_get_et_strings: OK
[    6.740446] Testing event drv_get_et_sset_count: OK
[    6.748409] Testing event drv_get_et_stats: OK
[    6.760378] Testing event drv_suspend: OK
[    6.768403] Testing event drv_resume: OK
[    6.776933] Testing event drv_set_wakeup: OK
[    6.784430] Testing event drv_stop: OK
[    6.792428] Testing event drv_add_interface: OK
[    6.800427] Testing event drv_change_interface: OK
[    6.808458] Testing event drv_remove_interface: OK
[    6.816451] Testing event drv_config: OK
[    6.824452] Testing event drv_bss_info_changed: OK
[    6.832449] Testing event drv_prepare_multicast: OK
[    6.840412] Testing event drv_configure_filter: OK
[    6.848470] Testing event drv_set_tim: OK
[    6.856415] Testing event drv_set_key: OK
[    6.866141] Testing event drv_update_tkip_key: OK
[    6.872436] Testing event drv_hw_scan: OK
[    6.880413] Testing event drv_cancel_hw_scan: OK
[    6.888436] Testing event drv_sched_scan_start: OK
[    6.896492] Testing event drv_sched_scan_stop: OK
[    6.904483] Testing event drv_sw_scan_start: OK
[    6.915170] Testing event drv_sw_scan_complete: OK
[    6.924429] Testing event drv_get_stats: OK
[    6.932407] Testing event drv_get_tkip_seq: OK
[    6.940411] Testing event drv_set_frag_threshold: OK
[    6.948421] Testing event drv_set_rts_threshold: OK
[    6.956433] Testing event drv_set_coverage_class: OK
[    6.964400] Testing event drv_sta_notify: OK
[    6.972396] Testing event drv_sta_state: OK
[    6.980413] Testing event drv_sta_rc_update: OK
[    6.988405] Testing event drv_sta_add: OK
[    6.996386] Testing event drv_sta_remove: OK
[    7.004409] Testing event drv_conf_tx: OK
[    7.012437] Testing event drv_get_tsf: OK
[    7.020481] Testing event drv_set_tsf: OK
[    7.028496] Testing event drv_reset_tsf: OK
[    7.036441] Testing event drv_tx_last_beacon: OK
[    7.044429] Testing event drv_ampdu_action: OK
[    7.052425] Testing event drv_get_survey: OK
[    7.060446] Testing event drv_flush: OK
[    7.068382] Testing event drv_channel_switch: OK
[    7.076458] Testing event drv_set_antenna: OK
[    7.084395] Testing event drv_get_antenna: OK
[    7.092409] Testing event drv_remain_on_channel: OK
[    7.100398] Testing event drv_cancel_remain_on_channel: OK
[    7.108451] Testing event drv_set_ringparam: OK
[    7.116388] Testing event drv_get_ringparam: OK
[    7.124362] Testing event drv_tx_frames_pending: OK
[    7.132422] Testing event drv_offchannel_tx_cancel_wait: OK
[    7.140444] Testing event drv_set_bitrate_mask: OK
[    7.148428] Testing event drv_set_rekey_data: OK
[    7.156457] Testing event drv_rssi_callback: OK
[    7.171146] Testing event drv_release_buffered_frames: OK
[    7.184984] Testing event drv_allow_buffered_frames: OK
[    7.198639] Testing event drv_get_rssi: OK
[    7.217056] Testing event drv_mgd_prepare_tx: OK
[    7.229037] Testing event drv_add_chanctx: OK
[    7.240990] Testing event drv_remove_chanctx: OK
[    7.260993] Testing event drv_change_chanctx: OK
[    7.281384] Testing event drv_assign_vif_chanctx: OK
[    7.296421] Testing event drv_unassign_vif_chanctx: OK
[    7.304416] Testing event drv_start_ap: OK
[    7.312444] Testing event drv_stop_ap: OK
[    7.320408] Testing event drv_restart_complete: OK
[    7.328738] Testing event api_start_tx_ba_session: OK
[    7.336403] Testing event api_start_tx_ba_cb: OK
[    7.344409] Testing event api_stop_tx_ba_session: OK
[    7.352420] Testing event api_stop_tx_ba_cb: OK
[    7.360394] Testing event api_restart_hw: OK
[    7.368423] Testing event api_beacon_loss: OK
[    7.376401] Testing event api_connection_loss: OK
[    7.384432] Testing event api_cqm_rssi_notify: OK
[    7.392412] Testing event api_scan_completed: OK
[    7.400396] Testing event api_sched_scan_results: OK
[    7.408405] Testing event api_sched_scan_stopped: OK
[    7.416420] Testing event api_sta_block_awake: OK
[    7.424415] Testing event api_chswitch_done: OK
[    7.432413] Testing event api_ready_on_channel: OK
[    7.440403] Testing event api_remain_on_channel_expired: OK
[    7.448416] Testing event api_gtk_rekey_notify: OK
[    7.456412] Testing event api_enable_rssi_reports: OK
[    7.464403] Testing event api_eosp: OK
[    7.472412] Testing event wake_queue: OK
[    7.480396] Testing event stop_queue: OK
[    7.488401] Testing event drv_set_default_unicast_key: OK
[    7.496401] Testing event api_radar_detected: OK
[    7.504571] Testing event rdev_suspend: OK
[    7.512402] Testing event rdev_return_int: OK
[    7.520404] Testing event rdev_scan: OK
[    7.528408] Testing event rdev_resume: OK
[    7.536402] Testing event rdev_return_void: OK
[    7.544402] Testing event rdev_get_ringparam: OK
[    7.552413] Testing event rdev_get_antenna: OK
[    7.560403] Testing event rdev_rfkill_poll: OK
[    7.568403] Testing event rdev_set_wakeup: OK
[    7.576406] Testing event rdev_add_virtual_intf: OK
[    7.584408] Testing event rdev_return_wdev: OK
[    7.592408] Testing event rdev_del_virtual_intf: OK
[    7.600399] Testing event rdev_change_virtual_intf: OK
[    7.608404] Testing event rdev_add_key: OK
[    7.616408] Testing event rdev_get_key: OK
[    7.624413] Testing event rdev_del_key: OK
[    7.632406] Testing event rdev_set_default_key: OK
[    7.641060] Testing event rdev_set_default_mgmt_key: OK
[    7.648401] Testing event rdev_start_ap: OK
[    7.656423] Testing event rdev_change_beacon: OK
[    7.664408] Testing event rdev_stop_ap: OK
[    7.672420] Testing event rdev_get_et_stats: OK
[    7.680391] Testing event rdev_sched_scan_stop: OK
[    7.688418] Testing event rdev_set_rekey_data: OK
[    7.696410] Testing event rdev_get_mesh_config: OK
[    7.704414] Testing event rdev_leave_mesh: OK
[    7.721201] Testing event rdev_leave_ibss: OK
[    7.728583] Testing event rdev_flush_pmksa: OK
[    7.736421] Testing event rdev_add_station: OK
[    7.744405] Testing event rdev_change_station: OK
[    7.752416] Testing event rdev_del_station: OK
[    7.760403] Testing event rdev_get_station: OK
[    7.768407] Testing event rdev_del_mpath: OK
[    7.776475] Testing event rdev_set_wds_peer: OK
[    7.784488] Testing event rdev_dump_station: OK
[    7.792435] Testing event rdev_return_int_station_info: OK
[    7.800407] Testing event rdev_add_mpath: OK
[    7.808415] Testing event rdev_change_mpath: OK
[    7.816450] Testing event rdev_get_mpath: OK
[    7.824447] Testing event rdev_dump_mpath: OK
[    7.832472] Testing event rdev_return_int_mpath_info: OK
[    7.840457] Testing event rdev_return_int_mesh_config: OK
[    7.848465] Testing event rdev_update_mesh_config: OK
[    7.856459] Testing event rdev_join_mesh: OK
[    7.864464] Testing event rdev_change_bss: OK
[    7.872463] Testing event rdev_set_txq_params: OK
[    7.880476] Testing event rdev_libertas_set_mesh_channel: OK
[    7.888454] Testing event rdev_set_monitor_channel: OK
[    7.896468] Testing event rdev_auth: OK
[    7.904448] Testing event rdev_assoc: OK
[    7.912458] Testing event rdev_deauth: OK
[    7.920453] Testing event rdev_disassoc: OK
[    7.928444] Testing event rdev_mgmt_tx_cancel_wait: OK
[    7.936475] Testing event rdev_set_power_mgmt: OK
[    7.944472] Testing event rdev_connect: OK
[    7.952510] Testing event rdev_set_cqm_rssi_config: OK
[    7.960467] Testing event rdev_set_cqm_txe_config: OK
[    7.968469] Testing event rdev_disconnect: OK
[    7.976461] Testing event rdev_join_ibss: OK
[    7.984480] Testing event rdev_set_wiphy_params: OK
[    7.992478] Testing event rdev_get_tx_power: OK
[    8.000463] Testing event rdev_set_tx_power: OK
[    8.008449] Testing event rdev_return_int_int: OK
[    8.016496] Testing event rdev_set_bitrate_mask: OK
[    8.024460] Testing event rdev_mgmt_frame_register: OK
[    8.032482] Testing event rdev_return_int_tx_rx: OK
[    8.040443] Testing event rdev_return_void_tx_rx: OK
[    8.048475] Testing event rdev_set_ringparam: OK
[    8.056482] Testing event rdev_set_antenna: OK
[    8.064495] Testing event rdev_sched_scan_start: OK
[    8.072399] Testing event rdev_tdls_mgmt: OK
[    8.080450] Testing event rdev_dump_survey: OK
[    8.088426] Testing event rdev_return_int_survey_info: OK
[    8.096431] Testing event rdev_tdls_oper: OK
[    8.104414] Testing event rdev_probe_client: OK
[    8.112409] Testing event rdev_set_pmksa: OK
[    8.120404] Testing event rdev_del_pmksa: OK
[    8.128410] Testing event rdev_remain_on_channel: OK
[    8.136412] Testing event rdev_return_int_cookie: OK
[    8.144420] Testing event rdev_cancel_remain_on_channel: OK
[    8.152422] Testing event rdev_mgmt_tx: OK
[    8.160403] Testing event rdev_set_noack_map: OK
[    8.168470] Testing event rdev_get_et_sset_count: OK
[    8.176462] Testing event rdev_get_et_strings: OK
[    8.184474] Testing event rdev_get_channel: OK
[    8.192484] Testing event rdev_return_chandef: OK
[    8.200447] Testing event rdev_start_p2p_device: OK
[    8.208468] Testing event rdev_stop_p2p_device: OK
[    8.216448] Testing event rdev_set_mac_acl: OK
[    8.224468] Testing event cfg80211_return_bool: OK
[    8.232414] Testing event cfg80211_notify_new_peer_candidate: OK
[    8.240471] Testing event cfg80211_send_rx_auth: OK
[    8.248407] Testing event cfg80211_send_rx_assoc: OK
[    8.256469] Testing event __cfg80211_send_deauth: OK
[    8.264911] Testing event __cfg80211_send_disassoc: OK
[    8.272472] Testing event cfg80211_send_unprot_deauth: OK
[    8.280459] Testing event cfg80211_send_unprot_disassoc: OK
[    8.288469] Testing event cfg80211_send_auth_timeout: OK
[    8.296441] Testing event cfg80211_send_assoc_timeout: OK
[    8.304490] Testing event cfg80211_michael_mic_failure: OK
[    8.312465] Testing event cfg80211_ready_on_channel: OK
[    8.320433] Testing event cfg80211_ready_on_channel_expired: OK
[    8.328396] Testing event cfg80211_new_sta: OK
[    8.336410] Testing event cfg80211_del_sta: OK
[    8.344492] Testing event cfg80211_rx_mgmt: OK
[    8.352414] Testing event cfg80211_mgmt_tx_status: OK
[    8.360412] Testing event cfg80211_cqm_rssi_notify: OK
[    8.368414] Testing event cfg80211_reg_can_beacon: OK
[    8.376411] Testing event cfg80211_chandef_dfs_required: OK
[    8.384409] Testing event cfg80211_ch_switch_notify: OK
[    8.392410] Testing event cfg80211_radar_event: OK
[    8.400486] Testing event cfg80211_cac_event: OK
[    8.408458] Testing event cfg80211_ibss_joined: OK
[    8.416468] Testing event cfg80211_rx_spurious_frame: OK
[    8.424484] Testing event cfg80211_rx_unexpected_4addr_frame: OK
[    8.432431] Testing event cfg80211_probe_status: OK
[    8.440419] Testing event cfg80211_cqm_pktloss_notify: OK
[    8.448465] Testing event cfg80211_gtk_rekey_notify: OK
[    8.459071] Testing event cfg80211_pmksa_candidate_notify: OK
[    8.468414] Testing event cfg80211_report_obss_beacon: OK
[    8.476421] Testing event cfg80211_tdls_oper_request: OK
[    8.484416] Testing event cfg80211_scan_done: OK
[    8.492425] Testing event cfg80211_sched_scan_results: OK
[    8.500422] Testing event cfg80211_sched_scan_stopped: OK
[    8.508411] Testing event cfg80211_get_bss: OK
[    8.516449] Testing event cfg80211_inform_bss_frame: OK
[    8.524426] Testing event cfg80211_return_bss: OK
[    8.532436] Testing event cfg80211_return_uint: OK
[    8.540416] Testing event cfg80211_return_u32: OK
[    8.548421] Testing event cfg80211_report_wowlan_wakeup: OK
[    8.556404] Testing event kfree_skb: OK
[    8.564427] Testing event consume_skb: OK
[    8.572422] Testing event skb_copy_datagram_iovec: OK
[    8.580390] Testing event net_dev_xmit: OK
[    8.588416] Testing event net_dev_queue: OK
[    8.596406] Testing event netif_receive_skb: OK
[    8.604806] Testing event netif_rx: OK
[    8.612420] Testing event napi_poll: OK
[    8.620406] Testing event sock_rcvqueue_full: OK
[    8.628418] Testing event sock_exceed_buf_limit: OK
[    8.636449] Testing event udp_fail_queue_rcv_skb: OK
[    8.644461] Testing event regmap_reg_write: OK
[    8.652422] Testing event regmap_reg_read: OK
[    8.660412] Testing event regmap_reg_read_cache: OK
[    8.668411] Testing event regmap_hw_read_start: OK
[    8.676486] Testing event regmap_hw_read_done: OK
[    8.684445] Testing event regmap_hw_write_start: OK
[    8.692386] Testing event regmap_hw_write_done: OK
[    8.700397] Testing event regcache_sync: OK
[    8.708388] Testing event regmap_cache_only: OK
[    8.716389] Testing event regmap_cache_bypass: OK
[    8.724389] Testing event mix_pool_bytes: OK
[    8.732425] Testing event mix_pool_bytes_nolock: OK
[    8.740408] Testing event credit_entropy_bits: OK
[    8.748386] Testing event get_random_bytes: OK
[    8.756403] Testing event extract_entropy: OK
[    8.764458] Testing event extract_entropy_user: OK
[    8.772461] Testing event writeback_dirty_page: OK
[    8.780468] Testing event writeback_dirty_inode_start: OK
[    8.788467] Testing event writeback_dirty_inode: OK
[    8.796461] Testing event writeback_write_inode_start: OK
[    8.804470] Testing event writeback_write_inode: OK
[    8.812455] Testing event writeback_nothread: OK
[    8.820472] Testing event writeback_queue: OK
[    8.828455] Testing event writeback_exec: OK
[    8.836459] Testing event writeback_start: OK
[    8.844453] Testing event writeback_written: OK
[    8.852480] Testing event writeback_wait: OK
[    8.860441] Testing event writeback_pages_written: OK
[    8.868481] Testing event writeback_nowork: OK
[    8.876445] Testing event writeback_wake_background: OK
[    8.884467] Testing event writeback_wake_thread: OK
[    8.892449] Testing event writeback_wake_forker_thread: OK
[    8.900459] Testing event writeback_bdi_register: OK
[    8.908466] Testing event writeback_bdi_unregister: OK
[    8.916436] Testing event writeback_thread_start: OK
[    8.924468] Testing event writeback_thread_stop: OK
[    8.932445] Testing event wbc_writepage: OK
[    8.940455] Testing event writeback_queue_io: OK
[    8.948459] Testing event global_dirty_state: OK
[    8.956405] Testing event bdi_dirty_ratelimit: OK
[    8.964388] Testing event balance_dirty_pages: OK
[    8.972392] Testing event writeback_sb_inodes_requeue: OK
[    8.980382] Testing event writeback_congestion_wait: OK
[    8.988394] Testing event writeback_wait_iff_congested: OK
[    8.996378] Testing event writeback_single_inode_start: OK
[    9.004390] Testing event writeback_single_inode: OK
[    9.012406] Testing event mm_migrate_pages: OK
[    9.020446] Testing event mm_compaction_isolate_migratepages: OK
[    9.028470] Testing event mm_compaction_isolate_freepages: OK
[    9.036432] Testing event mm_compaction_migratepages: OK
[    9.044545] Testing event kmalloc: OK
[    9.052444] Testing event kmem_cache_alloc: OK
[    9.060403] Testing event kmalloc_node: OK
[    9.068395] Testing event kmem_cache_alloc_node: OK
[    9.076381] Testing event kfree: OK
[    9.084449] Testing event kmem_cache_free: OK
[    9.092443] Testing event mm_page_free: OK
[    9.100443] Testing event mm_page_free_batched: OK
[    9.108436] Testing event mm_page_alloc: OK
[    9.116459] Testing event mm_page_alloc_zone_locked: OK
[    9.124444] Testing event mm_page_pcpu_drain: OK
[    9.132464] Testing event mm_page_alloc_extfrag: OK
[    9.140440] Testing event mm_vmscan_kswapd_sleep: OK
[    9.148459] Testing event mm_vmscan_kswapd_wake: OK
[    9.156445] Testing event mm_vmscan_wakeup_kswapd: OK
[    9.164456] Testing event mm_vmscan_direct_reclaim_begin: OK
[    9.172443] Testing event mm_vmscan_memcg_reclaim_begin: OK
[    9.180455] Testing event mm_vmscan_memcg_softlimit_reclaim_begin: OK
[    9.188449] Testing event mm_vmscan_direct_reclaim_end: OK
[    9.196458] Testing event mm_vmscan_memcg_reclaim_end: OK
[    9.204496] Testing event mm_vmscan_memcg_softlimit_reclaim_end: OK
[    9.212462] Testing event mm_shrink_slab_start: OK
[    9.220443] Testing event mm_shrink_slab_end: OK
[    9.228463] Testing event mm_vmscan_lru_isolate: OK
[    9.236443] Testing event mm_vmscan_memcg_isolate: OK
[    9.244466] Testing event mm_vmscan_writepage: OK
[    9.252445] Testing event mm_vmscan_lru_shrink_inactive: OK
[    9.260465] Testing event oom_score_adj_update: OK
[    9.268447] Testing event cpu_idle: OK
[    9.276463] Testing event cpu_frequency: OK
[    9.284450] Testing event machine_suspend: OK
[    9.292466] Testing event wakeup_source_activate: OK
[    9.300443] Testing event wakeup_source_deactivate: OK
[    9.309796] Testing event clock_enable: OK
[    9.316395] Testing event clock_disable: OK
[    9.324512] Testing event clock_set_rate: OK
[    9.332371] Testing event power_domain_target: OK
[    9.340365] Testing event ftrace_test_filter: OK
[    9.348409] Testing event lock_acquire: OK
[    9.356456] Testing event lock_release: OK
[    9.364422] Testing event sched_kthread_stop: OK
[    9.372422] Testing event sched_kthread_stop_ret: OK
[    9.380388] Testing event sched_wakeup: OK
[    9.388386] Testing event sched_wakeup_new: OK
[    9.396386] Testing event sched_switch: OK
[    9.404459] Testing event sched_migrate_task: OK
[    9.412450] Testing event sched_process_free: OK
[    9.420454] Testing event sched_process_exit: OK
[    9.428461] Testing event sched_wait_task: OK
[    9.436464] Testing event sched_process_wait: OK
[    9.444454] Testing event sched_process_fork: OK
[    9.452454] Testing event sched_process_exec: OK
[    9.460497] Testing event sched_stat_wait: OK
[    9.468423] Testing event sched_stat_sleep: OK
[    9.476471] Testing event sched_stat_iowait: OK
[    9.484455] Testing event sched_stat_blocked: OK
[    9.492461] Testing event sched_stat_runtime: OK
[    9.500445] Testing event sched_pi_setprio: OK
[    9.508434] Testing event rcu_utilization: OK
[    9.516414] Testing event rcu_dyntick: OK
[    9.524431] Testing event rcu_prep_idle: OK
[    9.532417] Testing event rcu_callback: OK
[    9.540432] Testing event rcu_kfree_callback: OK
[    9.548423] Testing event rcu_batch_start: OK
[    9.556421] Testing event rcu_invoke_callback: OK
[    9.564430] Testing event rcu_invoke_kfree_callback: OK
[    9.572423] Testing event rcu_batch_end: OK
[    9.580426] Testing event rcu_torture_read: OK
[    9.588416] Testing event rcu_barrier: OK
[    9.596393] Testing event workqueue_queue_work: OK
[    9.604396] Testing event workqueue_activate_work: OK
[    9.612386] Testing event workqueue_execute_start: OK
[    9.620398] Testing event workqueue_execute_end: OK
[    9.628394] Testing event signal_generate: OK
[    9.636392] Testing event signal_deliver: OK
[    9.644441] Testing event timer_init: OK
[    9.652509] Testing event timer_start: OK
[    9.660457] Testing event timer_expire_entry: OK
[    9.668411] Testing event timer_expire_exit: OK
[    9.676415] Testing event timer_cancel: OK
[    9.684402] Testing event hrtimer_init: OK
[    9.692410] Testing event hrtimer_start: OK
[    9.700402] Testing event hrtimer_expire_entry: OK
[    9.708391] Testing event hrtimer_expire_exit: OK
[    9.716455] Testing event hrtimer_cancel: OK
[    9.724401] Testing event itimer_state: OK
[    9.732388] Testing event itimer_expire: OK
[    9.740392] Testing event irq_handler_entry: OK
[    9.749174] Testing event irq_handler_exit: OK
[    9.756393] Testing event softirq_entry: OK
[    9.769404] Testing event softirq_exit: OK
[    9.776412] Testing event softirq_raise: OK
[    9.784412] Testing event console: OK
[    9.797484] Testing event task_newtask: OK
[    9.808477] Testing event task_rename: OK
[    9.816482] Testing event sys_enter: OK
[    9.824457] Testing event sys_exit: OK
[    9.832566] Testing event emulate_vsyscall: OK
[    9.844449] Running tests on trace event systems:
[    9.845887] Testing event system vsyscall: OK
[    9.852794] Testing event system raw_syscalls: OK
[    9.864745] Testing event system task: OK
[    9.872752] Testing event system printk: OK
[    9.888449] Testing event system irq: OK
[    9.897586] Testing event system timer: OK
[    9.908878] Testing event system signal: OK
[    9.916451] Testing event system workqueue: OK
[    9.925528] Testing event system rcu: OK
[    9.932794] Testing event system sched: OK
[    9.941095] Testing event system lock: OK
[    9.948558] Testing event system test: OK
[    9.956420] Testing event system power: OK
[    9.964749] Testing event system oom: OK
[    9.972420] Testing event system vmscan: OK
[    9.980959] Testing event system kmem: OK
[    9.988860] Testing event system compaction: OK
[    9.999319] Testing event system migrate: OK
[   10.008472] Testing event system writeback: OK
[   10.017584] Testing event system random: OK
[   10.028770] Testing event system regmap: OK
[   10.036825] Testing event system syscalls: OK
[   10.045006] Testing event system udp: OK
[   10.052613] Testing event system sock: OK
[   10.061307] Testing event system napi: OK
[   10.076605] Testing event system net: OK
[   10.084652] Testing event system skb: OK
[   10.092633] Testing event system cfg80211: OK
[   10.137659] Testing event system mac80211: OK
[   10.166571] Testing event system 9p: OK
[   10.176733] Running tests on all trace events:
[   10.179207] Testing all events: OK
[   10.571501] Running tests again, along with the function tracer
[   10.579597] Running tests on trace events:
[   10.584896] Testing event 9p_client_req: OK
[   10.605486] Testing event 9p_client_res: OK
[   10.617448] Testing event 9p_protocol_dump: OK
[   10.629607] Testing event drv_return_void: OK
[   10.641785] Testing event drv_return_int: OK
[   10.653400] Testing event drv_return_bool: OK
[   10.665972] Testing event drv_return_u64: OK
[   10.677201] Testing event drv_start: OK
[   10.685458] Testing event drv_get_et_strings: OK
[   10.697186] Testing event drv_get_et_sset_count: OK
[   10.705401] Testing event drv_get_et_stats: OK
[   10.717218] Testing event drv_suspend: OK
[   10.725418] Testing event drv_resume: OK
[   10.737317] Testing event drv_set_wakeup: OK
[   10.745240] Testing event drv_stop: OK
[   10.753372] Testing event drv_add_interface: OK
[   10.765604] Testing event drv_change_interface: OK
[   10.777259] Testing event drv_remove_interface: OK
[   10.789385] Testing event drv_config: OK
[   10.801387] Testing event drv_bss_info_changed: OK
[   10.813466] Testing event drv_prepare_multicast: OK
[   10.825271] Testing event drv_configure_filter: OK
[   10.837356] Testing event drv_set_tim: OK
[   10.849220] Testing event drv_set_key: OK
[   10.861500] Testing event drv_update_tkip_key: OK
[   10.873346] Testing event drv_hw_scan: OK
[   10.885315] Testing event drv_cancel_hw_scan: OK
[   10.897249] Testing event drv_sched_scan_start: OK
[   10.905314] Testing event drv_sched_scan_stop: OK
[   10.913240] Testing event drv_sw_scan_start: OK
[   10.925297] Testing event drv_sw_scan_complete: OK
[   10.937249] Testing event drv_get_stats: OK
[   10.945309] Testing event drv_get_tkip_seq: OK
[   10.957214] Testing event drv_set_frag_threshold: OK
[   10.969480] Testing event drv_set_rts_threshold: OK
[   10.981457] Testing event drv_set_coverage_class: OK
[   10.996146] Testing event drv_sta_notify: OK
[   11.007597] Testing event drv_sta_state: OK
[   11.017377] Testing event drv_sta_rc_update: OK
[   11.029220] Testing event drv_sta_add: OK
[   11.041274] Testing event drv_sta_remove: OK
[   11.053280] Testing event drv_conf_tx: OK
[   11.069200] Testing event drv_get_tsf: OK
[   11.081338] Testing event drv_set_tsf: OK
[   11.091992] Testing event drv_reset_tsf: OK
[   11.101513] Testing event drv_tx_last_beacon: OK
[   11.113377] Testing event drv_ampdu_action: OK
[   11.125479] Testing event drv_get_survey: OK
[   11.137451] Testing event drv_flush: OK
[   11.150183] Testing event drv_channel_switch: OK
[   11.165421] Testing event drv_set_antenna: OK
[   11.177345] Testing event drv_get_antenna: OK
[   11.189392] Testing event drv_remain_on_channel: OK
[   11.201298] Testing event drv_cancel_remain_on_channel: OK
[   11.213351] Testing event drv_set_ringparam: OK
[   11.221293] Testing event drv_get_ringparam: OK
[   11.233314] Testing event drv_tx_frames_pending: OK
[   11.241300] Testing event drv_offchannel_tx_cancel_wait: OK
[   11.253375] Testing event drv_set_bitrate_mask: OK
[   11.265313] Testing event drv_set_rekey_data: OK
[   11.273309] Testing event drv_rssi_callback: OK
[   11.281283] Testing event drv_release_buffered_frames: OK
[   11.293317] Testing event drv_allow_buffered_frames: OK
[   11.301356] Testing event drv_get_rssi: OK
[   11.313365] Testing event drv_mgd_prepare_tx: OK
[   11.325309] Testing event drv_add_chanctx: OK
[   11.333395] Testing event drv_remove_chanctx: OK
[   11.341317] Testing event drv_change_chanctx: OK
[   11.349263] Testing event drv_assign_vif_chanctx: OK
[   11.357193] Testing event drv_unassign_vif_chanctx: OK
[   11.365316] Testing event drv_start_ap: OK
[   11.373226] Testing event drv_stop_ap: OK
[   11.381319] Testing event drv_restart_complete: OK
[   11.389302] Testing event api_start_tx_ba_session: OK
[   11.401337] Testing event api_start_tx_ba_cb: OK
[   11.413192] Testing event api_stop_tx_ba_session: OK
[   11.425400] Testing event api_stop_tx_ba_cb: OK
[   11.433288] Testing event api_restart_hw: OK
[   11.441354] Testing event api_beacon_loss: OK
[   11.449291] Testing event api_connection_loss: OK
[   11.457231] Testing event api_cqm_rssi_notify: OK
[   11.465240] Testing event api_scan_completed: OK
[   11.477300] Testing event api_sched_scan_results: OK
[   11.489363] Testing event api_sched_scan_stopped: OK
[   11.501544] Testing event api_sta_block_awake: OK
[   11.513360] Testing event api_chswitch_done: OK
[   11.525463] Testing event api_ready_on_channel: OK
[   11.549767] Testing event api_remain_on_channel_expired: OK
[   11.567340] Testing event api_gtk_rekey_notify: OK
[   11.589448] Testing event api_enable_rssi_reports: OK
[   11.605553] Testing event api_eosp: OK
[   11.632211] Testing event wake_queue: OK
[   11.670429] Testing event stop_queue: OK
[   11.686572] Testing event drv_set_default_unicast_key: OK
[   11.708511] Testing event api_radar_detected: OK
[   11.726096] Testing event rdev_suspend: OK
[   11.766774] Testing event rdev_return_int: OK
[   11.777332] Testing event rdev_scan: OK
[   11.789371] Testing event rdev_resume: OK
[   11.801323] Testing event rdev_return_void: OK
[   11.809354] Testing event rdev_get_ringparam: OK
[   11.822081] Testing event rdev_get_antenna: OK
[   11.833765] Testing event rdev_rfkill_poll: OK
[   11.845434] Testing event rdev_set_wakeup: OK
[   11.859217] Testing event rdev_add_virtual_intf: OK
[   11.875236] Testing event rdev_return_wdev: OK
[   11.889273] Testing event rdev_del_virtual_intf: OK
[   11.901193] Testing event rdev_change_virtual_intf: OK
[   11.909328] Testing event rdev_add_key: OK
[   11.917206] Testing event rdev_get_key: OK
[   11.925224] Testing event rdev_del_key: OK
[   11.933215] Testing event rdev_set_default_key: OK
[   11.941254] Testing event rdev_set_default_mgmt_key: OK
[   11.953195] Testing event rdev_start_ap: OK
[   11.961310] Testing event rdev_change_beacon: OK
[   11.969239] Testing event rdev_stop_ap: OK
[   11.977203] Testing event rdev_get_et_stats: OK
[   11.985342] Testing event rdev_sched_scan_stop: OK
[   11.993166] Testing event rdev_set_rekey_data: OK
[   12.001375] Testing event rdev_get_mesh_config: OK
[   12.013118] Testing event rdev_leave_mesh: OK
[   12.021352] Testing event rdev_leave_ibss: OK
[   12.029250] Testing event rdev_flush_pmksa: OK
[   12.037209] Testing event rdev_add_station: OK
[   12.045233] Testing event rdev_change_station: OK
[   12.053219] Testing event rdev_del_station: OK
[   12.061227] Testing event rdev_get_station: OK
[   12.069214] Testing event rdev_del_mpath: OK
[   12.077236] Testing event rdev_set_wds_peer: OK
[   12.085306] Testing event rdev_dump_station: OK
[   12.093207] Testing event rdev_return_int_station_info: OK
[   12.101225] Testing event rdev_add_mpath: OK
[   12.109322] Testing event rdev_change_mpath: OK
[   12.117353] Testing event rdev_get_mpath: OK
[   12.129391] Testing event rdev_dump_mpath: OK
[   12.137305] Testing event rdev_return_int_mpath_info: OK
[   12.149238] Testing event rdev_return_int_mesh_config: OK
[   12.157252] Testing event rdev_update_mesh_config: OK
[   12.169353] Testing event rdev_join_mesh: OK
[   12.181424] Testing event rdev_change_bss: OK
[   12.193334] Testing event rdev_set_txq_params: OK
[   12.205191] Testing event rdev_libertas_set_mesh_channel: OK
[   12.213331] Testing event rdev_set_monitor_channel: OK
[   12.225164] Testing event rdev_auth: OK
[   12.233339] Testing event rdev_assoc: OK
[   12.241275] Testing event rdev_deauth: OK
[   12.249237] Testing event rdev_disassoc: OK
[   12.257266] Testing event rdev_mgmt_tx_cancel_wait: OK
[   12.269213] Testing event rdev_set_power_mgmt: OK
[   12.277175] Testing event rdev_connect: OK
[   12.285364] Testing event rdev_set_cqm_rssi_config: OK
[   12.297783] Testing event rdev_set_cqm_txe_config: OK
[   12.309433] Testing event rdev_disconnect: OK
[   12.321356] Testing event rdev_join_ibss: OK
[   12.333346] Testing event rdev_set_wiphy_params: OK
[   12.345357] Testing event rdev_get_tx_power: OK
[   12.357455] Testing event rdev_set_tx_power: OK
[   12.369298] Testing event rdev_return_int_int: OK
[   12.381367] Testing event rdev_set_bitrate_mask: OK
[   12.393332] Testing event rdev_mgmt_frame_register: OK
[   12.405347] Testing event rdev_return_int_tx_rx: OK
[   12.417277] Testing event rdev_return_void_tx_rx: OK
[   12.429441] Testing event rdev_set_ringparam: OK
[   12.441332] Testing event rdev_set_antenna: OK
[   12.453718] Testing event rdev_sched_scan_start: OK
[   12.469258] Testing event rdev_tdls_mgmt: OK
[   12.488504] Testing event rdev_dump_survey: OK
[   12.505612] Testing event rdev_return_int_survey_info: OK
[   12.517409] Testing event rdev_tdls_oper: OK
[   12.529359] Testing event rdev_probe_client: OK
[   12.545325] Testing event rdev_set_pmksa: OK
[   12.565149] Testing event rdev_del_pmksa: OK
[   12.590454] Testing event rdev_remain_on_channel: OK
[   12.614009] Testing event rdev_return_int_cookie: OK
[   12.633611] Testing event rdev_cancel_remain_on_channel: OK
[   12.647196] Testing event rdev_mgmt_tx: OK
[   12.670827] Testing event rdev_set_noack_map: OK
[   12.686045] Testing event rdev_get_et_sset_count: OK
[   12.702162] Testing event rdev_get_et_strings: OK
[   12.713298] Testing event rdev_get_channel: OK
[   12.721376] Testing event rdev_return_chandef: OK
[   12.733289] Testing event rdev_start_p2p_device: OK
[   12.745302] Testing event rdev_stop_p2p_device: OK
[   12.753237] Testing event rdev_set_mac_acl: OK
[   12.761436] Testing event cfg80211_return_bool: OK
[   12.773371] Testing event cfg80211_notify_new_peer_candidate: OK
[   12.785455] Testing event cfg80211_send_rx_auth: OK
[   12.797452] Testing event cfg80211_send_rx_assoc: OK
[   12.809340] Testing event __cfg80211_send_deauth: OK
[   12.821388] Testing event __cfg80211_send_disassoc: OK
[   12.844035] Testing event cfg80211_send_unprot_deauth: OK
[   12.870971] Testing event cfg80211_send_unprot_disassoc: OK
[   12.885558] Testing event cfg80211_send_auth_timeout: OK
[   12.897430] Testing event cfg80211_send_assoc_timeout: OK
[   12.909621] Testing event cfg80211_michael_mic_failure: OK
[   12.925434] Testing event cfg80211_ready_on_channel: OK
[   12.937289] Testing event cfg80211_ready_on_channel_expired: OK
[   12.949310] Testing event cfg80211_new_sta: OK
[   12.957256] Testing event cfg80211_del_sta: OK
[   12.965326] Testing event cfg80211_rx_mgmt: OK
[   12.973141] Testing event cfg80211_mgmt_tx_status: OK
[   12.981264] Testing event cfg80211_cqm_rssi_notify: OK
[   12.989178] Testing event cfg80211_reg_can_beacon: OK
[   12.997240] Testing event cfg80211_chandef_dfs_required: OK
[   13.005167] Testing event cfg80211_ch_switch_notify: OK
[   13.017285] Testing event cfg80211_radar_event: OK
[   13.025243] Testing event cfg80211_cac_event: OK
[   13.037326] Testing event cfg80211_ibss_joined: OK
[   13.049180] Testing event cfg80211_rx_spurious_frame: OK
[   13.061355] Testing event cfg80211_rx_unexpected_4addr_frame: OK
[   13.073240] Testing event cfg80211_probe_status: OK
[   13.085291] Testing event cfg80211_cqm_pktloss_notify: OK
[   13.097200] Testing event cfg80211_gtk_rekey_notify: OK
[   13.105252] Testing event cfg80211_pmksa_candidate_notify: OK
[   13.113186] Testing event cfg80211_report_obss_beacon: OK
[   13.121259] Testing event cfg80211_tdls_oper_request: OK
[   13.129227] Testing event cfg80211_scan_done: OK
[   13.137169] Testing event cfg80211_sched_scan_results: OK
[   13.145250] Testing event cfg80211_sched_scan_stopped: OK
[   13.157401] Testing event cfg80211_get_bss: OK
[   13.165300] Testing event cfg80211_inform_bss_frame: OK
[   13.177302] Testing event cfg80211_return_bss: OK
[   13.185200] Testing event cfg80211_return_uint: OK
[   13.193468] Testing event cfg80211_return_u32: OK
[   13.205332] Testing event cfg80211_report_wowlan_wakeup: OK
[   13.213385] Testing event kfree_skb: OK
[   13.225289] Testing event consume_skb: OK
[   13.233193] Testing event skb_copy_datagram_iovec: OK
[   13.245179] Testing event net_dev_xmit: OK
[   13.253268] Testing event net_dev_queue: OK
[   13.261246] Testing event netif_receive_skb: OK
[   13.269246] Testing event netif_rx: OK
[   13.277154] Testing event napi_poll: OK
[   13.285288] Testing event sock_rcvqueue_full: OK
[   13.293236] Testing event sock_exceed_buf_limit: OK
[   13.301261] Testing event udp_fail_queue_rcv_skb: OK
[   13.309206] Testing event regmap_reg_write: OK
[   13.317225] Testing event regmap_reg_read: OK
[   13.325216] Testing event regmap_reg_read_cache: OK
[   13.333389] Testing event regmap_hw_read_start: OK
[   13.345241] Testing event regmap_hw_read_done: OK
[   13.357462] Testing event regmap_hw_write_start: OK
[   13.369288] Testing event regmap_hw_write_done: OK
[   13.381399] Testing event regcache_sync: OK
[   13.393215] Testing event regmap_cache_only: OK
[   13.405352] Testing event regmap_cache_bypass: OK
[   13.417202] Testing event mix_pool_bytes: OK
[   13.425303] Testing event mix_pool_bytes_nolock: OK
[   13.437268] Testing event credit_entropy_bits: OK
[   13.449352] Testing event get_random_bytes: OK
[   13.461284] Testing event extract_entropy: OK
[   13.473255] Testing event extract_entropy_user: OK
[   13.485444] Testing event writeback_dirty_page: OK
[   13.497257] Testing event writeback_dirty_inode_start: OK
[   13.509258] Testing event writeback_dirty_inode: OK
[   13.521388] Testing event writeback_write_inode_start: OK
[   13.533263] Testing event writeback_write_inode: OK
[   13.545291] Testing event writeback_nothread: OK
[   13.557339] Testing event writeback_queue: OK
[   13.569284] Testing event writeback_exec: OK
[   13.581453] Testing event writeback_start: OK
[   13.593264] Testing event writeback_written: OK
[   13.605330] Testing event writeback_wait: OK
[   13.617300] Testing event writeback_pages_written: OK
[   13.629379] Testing event writeback_nowork: OK
[   13.641295] Testing event writeback_wake_background: OK
[   13.653412] Testing event writeback_wake_thread: OK
[   13.665275] Testing event writeback_wake_forker_thread: OK
[   13.677364] Testing event writeback_bdi_register: OK
[   13.689216] Testing event writeback_bdi_unregister: OK
[   13.701321] Testing event writeback_thread_start: OK
[   13.713219] Testing event writeback_thread_stop: OK
[   13.721335] Testing event wbc_writepage: OK
[   13.729198] Testing event writeback_queue_io: OK
[   13.737261] Testing event global_dirty_state: OK
[   13.745136] Testing event bdi_dirty_ratelimit: OK
[   13.753332] Testing event balance_dirty_pages: OK
[   13.765260] Testing event writeback_sb_inodes_requeue: OK
[   13.777259] Testing event writeback_congestion_wait: OK
[   13.785222] Testing event writeback_wait_iff_congested: OK
[   13.797594] Testing event writeback_single_inode_start: OK
[   13.809203] Testing event writeback_single_inode: OK
[   13.821343] Testing event mm_migrate_pages: OK
[   13.829304] Testing event mm_compaction_isolate_migratepages: OK
[   13.841352] Testing event mm_compaction_isolate_freepages: OK
[   13.853319] Testing event mm_compaction_migratepages: OK
[   13.865350] Testing event kmalloc: OK
[   13.877381] Testing event kmem_cache_alloc: OK
[   13.889307] Testing event kmalloc_node: OK
[   13.901430] Testing event kmem_cache_alloc_node: OK
[   13.913186] Testing event kfree: OK
[   13.921336] Testing event kmem_cache_free: OK
[   13.935136] Testing event mm_page_free: OK
[   13.949740] Testing event mm_page_free_batched: OK
[   13.962176] Testing event mm_page_alloc: OK
[   13.975407] Testing event mm_page_alloc_zone_locked: OK
[   13.995171] Testing event mm_page_pcpu_drain: OK
[   14.011311] Testing event mm_page_alloc_extfrag: OK
[   14.022362] Testing event mm_vmscan_kswapd_sleep: OK
[   14.042186] Testing event mm_vmscan_kswapd_wake: OK
[   14.053296] Testing event mm_vmscan_wakeup_kswapd: OK
[   14.065466] Testing event mm_vmscan_direct_reclaim_begin: OK
[   14.077259] Testing event mm_vmscan_memcg_reclaim_begin: OK
[   14.089354] Testing event mm_vmscan_memcg_softlimit_reclaim_begin: OK
[   14.101302] Testing event mm_vmscan_direct_reclaim_end: OK
[   14.113426] Testing event mm_vmscan_memcg_reclaim_end: OK
[   14.125304] Testing event mm_vmscan_memcg_softlimit_reclaim_end: OK
[   14.137334] Testing event mm_shrink_slab_start: OK
[   14.164344] Testing event mm_shrink_slab_end: OK
[   14.173422] Testing event mm_vmscan_lru_isolate: OK
[   14.185402] Testing event mm_vmscan_memcg_isolate: OK
[   14.208555] Testing event mm_vmscan_writepage: OK
[   14.221427] Testing event mm_vmscan_lru_shrink_inactive: OK
[   14.245371] Testing event oom_score_adj_update: OK
[   14.265653] Testing event cpu_idle: OK
[   14.281445] Testing event cpu_frequency: OK
[   14.301174] Testing event machine_suspend: OK
[   14.321495] Testing event wakeup_source_activate: OK
[   14.333405] Testing event wakeup_source_deactivate: OK
[   14.345317] Testing event clock_enable: OK
[   14.357344] Testing event clock_disable: OK
[   14.373467] Testing event clock_set_rate: OK
[   14.385186] Testing event power_domain_target: OK
[   14.402278] Testing event ftrace_test_filter: OK
[   14.413251] Testing event lock_acquire: OK
[   14.425517] Testing event lock_release: OK
[   14.437274] Testing event sched_kthread_stop: OK
[   14.449378] Testing event sched_kthread_stop_ret: OK
[   14.461298] Testing event sched_wakeup: OK
[   14.473352] Testing event sched_wakeup_new: OK
[   14.485241] Testing event sched_switch: OK
[   14.497300] Testing event sched_migrate_task: OK
[   14.505670] Testing event sched_process_free: OK
[   14.517236] Testing event sched_process_exit: OK
[   14.525151] Testing event sched_wait_task: OK
[   14.533237] Testing event sched_process_wait: OK
[   14.541234] Testing event sched_process_fork: OK
[   14.549176] Testing event sched_process_exec: OK
[   14.557155] Testing event sched_stat_wait: OK
[   14.565275] Testing event sched_stat_sleep: OK
[   14.577260] Testing event sched_stat_iowait: OK
[   14.585235] Testing event sched_stat_blocked: OK
[   14.593245] Testing event sched_stat_runtime: OK
[   14.601332] Testing event sched_pi_setprio: OK
[   14.613150] Testing event rcu_utilization: OK
[   14.621270] Testing event rcu_dyntick: OK
[   14.629165] Testing event rcu_prep_idle: OK
[   14.637190] Testing event rcu_callback: OK
[   14.645180] Testing event rcu_kfree_callback: OK
[   14.653322] Testing event rcu_batch_start: OK
[   14.665266] Testing event rcu_invoke_callback: OK
[   14.677241] Testing event rcu_invoke_kfree_callback: OK
[   14.685146] Testing event rcu_batch_end: OK
[   14.693204] Testing event rcu_torture_read: OK
[   14.701228] Testing event rcu_barrier: OK
[   14.709184] Testing event workqueue_queue_work: OK
[   14.721320] Testing event workqueue_activate_work: OK
[   14.733115] Testing event workqueue_execute_start: OK
[   14.745331] Testing event workqueue_execute_end: OK
[   14.757243] Testing event signal_generate: OK
[   14.769331] Testing event signal_deliver: OK
[   14.781359] Testing event timer_init: OK
[   14.793364] Testing event timer_start: OK
[   14.801238] Testing event timer_expire_entry: OK
[   14.809294] Testing event timer_expire_exit: OK
[   14.817178] Testing event timer_cancel: OK
[   14.825247] Testing event hrtimer_init: OK
[   14.833217] Testing event hrtimer_start: OK
[   14.841264] Testing event hrtimer_expire_entry: OK
[   14.853171] Testing event hrtimer_expire_exit: OK
[   14.861129] Testing event hrtimer_cancel: OK
[   14.869227] Testing event itimer_state: OK
[   14.877145] Testing event itimer_expire: OK
[   14.885174] Testing event irq_handler_entry: OK
[   14.893169] Testing event irq_handler_exit: OK
[   14.901222] Testing event softirq_entry: OK
[   14.909128] Testing event softirq_exit: OK
[   14.929123] Testing event softirq_raise: OK
[   14.941521] Testing event console: OK
[   14.949280] Testing event task_newtask: OK
[   14.957288] Testing event task_rename: OK
[   14.965401] Testing event sys_enter: OK
[   14.977281] Testing event sys_exit: OK
[   14.985190] Testing event emulate_vsyscall: OK
[   14.993243] Running tests on trace event systems:
[   14.995005] Testing event system vsyscall: OK
[   15.005721] Testing event system raw_syscalls: OK
[   15.018366] Testing event system task: OK
[   15.029898] Testing event system printk: OK
[   15.061709] Testing event system irq: OK
[   15.078812] Testing event system timer: OK
[   15.095678] Testing event system signal: OK
[   15.109782] Testing event system workqueue: OK
[   15.122911] Testing event system rcu: OK
[   15.139162] Testing event system sched: OK
[   15.157678] Testing event system lock: OK
[   15.173786] Testing event system test: OK
[   15.186027] Testing event system power: OK
[   15.199640] Testing event system oom: OK
[   15.229922] Testing event system vmscan: OK
[   15.264900] Testing event system kmem: OK
[   15.294173] Testing event system compaction: OK
[   15.312717] Testing event system migrate: OK
[   15.325418] Testing event system writeback: OK
[   15.347457] Testing event system random: OK
[   15.380870] Testing event system regmap: OK
[   15.405523] Testing event system syscalls: OK
[   15.444967] Testing event system udp: OK
[   15.481144] Testing event system sock: OK
[   15.493400] Testing event system napi: OK
[   15.501306] Testing event system net: OK
[   15.513707] Testing event system skb: OK
[   15.525721] Testing event system cfg80211: OK
[   15.626607] Testing event system mac80211: OK
[   15.709002] Testing event system 9p: OK
[   15.722458] Running tests on all trace events:
[   15.725607] Testing all events: OK
[   16.391494] Testing ftrace filter: OK
[   16.395930] Key type trusted registered
[   16.398687] Key type encrypted registered
[   16.402342] BIOS EDD facility v0.16 2004-Jun-25, 6 devices found
[   16.406733] debug: unmapping init [mem 0xffffffff820ca000-0xffffffff821cbfff]
/bin/sh: /proc/self/fd/9: No such file or directory
/bin/sh: /proc/self/fd/9: No such file or directory
/bin/sh: /proc/self/fd/9: No such file or directory
[   35.584087] CPA self-test:
[   35.591354]  4k 65534 large 0 gb 0 x 1[ffff88000009a000-ffff88000009a000] miss 0
[   35.615663]  4k 65534 large 0 gb 0 x 1[ffff88000009a000-ffff88000009a000] miss 0
[   35.638475]  4k 65534 large 0 gb 0 x 1[ffff88000009a000-ffff88000009a000] miss 0
[   35.653419] ok.
 * Asking all remaining processes to terminate...       
killall5[943]: mount returned non-zero exit status
killall5[943]: /proc not mounted, failed to mount.

mount: proc has wrong device number or fs type proc not supported
killall5[951]: mount returned non-zero exit status
killall5[951]: /proc not mounted, failed to mount.
 * All processes ended within 1 seconds....       
/etc/rc6.d/S40umountfs: line 20: /proc/mounts: No such file or directory
cat: /proc/1/maps: No such file or directory
cat: /proc/1/maps: No such file or directory
cat: /proc/1/maps: No such file or directory
cat: /proc/1/maps: No such file or directory
cat: /proc/1/maps: No such file or directory
cat: /proc/1/maps: No such file or directory
umount: /var/run: not mounted
umount: /var/lock: not mounted
umount: /dev/shm: not mounted
 * Will now restart
[   82.502176] Unregister pv shared memory for cpu 0
[   82.505661] Restarting system.
[   82.507404] reboot: machine restart
Elapsed time: 90

--Kj7319i9nmIyA2yE
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="bisect-8b473e1a916c6f379e041de0e7efb4422c65f650-x86_64-randconfig-x07-0621-__might_sleep-49307.log"

git checkout 8b473e1a916c6f379e041de0e7efb4422c65f650
HEAD is now at 8b473e1... Merge remote-tracking branch 'stable/master'
ls -a /kernel-tests/run-queue/kvm/x86_64-randconfig-x07-0621/sound-unstable:master:8b473e1a916c6f379e041de0e7efb4422c65f650:bisect-mm
 TEST FAILURE
/kernel/x86_64-randconfig-x07-0621/8b473e1a916c6f379e041de0e7efb4422c65f650/dmesg-kvm-athens-47639-20130622083515-3.9.0-rc4-03252-g8b473e1-58
/kernel/x86_64-randconfig-x07-0621/8b473e1a916c6f379e041de0e7efb4422c65f650/dmesg-kvm-athens-55325-20130622083542-3.9.0-rc4-03252-g8b473e1-58
/kernel/x86_64-randconfig-x07-0621/8b473e1a916c6f379e041de0e7efb4422c65f650/dmesg-kvm-athens-55832-20130622083504-3.9.0-rc4-03252-g8b473e1-58
/kernel/x86_64-randconfig-x07-0621/8b473e1a916c6f379e041de0e7efb4422c65f650/dmesg-kvm-athens-9556-20130622083512-3.9.0-rc4-03252-g8b473e1-58
/kernel/x86_64-randconfig-x07-0621/8b473e1a916c6f379e041de0e7efb4422c65f650/dmesg-kvm-bens-3228-20130622090149-3.9.0-rc4-03252-g8b473e1-58
/kernel/x86_64-randconfig-x07-0621/8b473e1a916c6f379e041de0e7efb4422c65f650/dmesg-kvm-bens-3561-20130623091401-3.9.0-rc4-03252-g8b473e1-58
/kernel/x86_64-randconfig-x07-0621/8b473e1a916c6f379e041de0e7efb4422c65f650/dmesg-kvm-bens-3760-20130622090155-3.9.0-rc4-03252-g8b473e1-58
/kernel/x86_64-randconfig-x07-0621/8b473e1a916c6f379e041de0e7efb4422c65f650/dmesg-kvm-bens-3886-20130622090135-3.9.0-rc4-03252-g8b473e1-58
/kernel/x86_64-randconfig-x07-0621/8b473e1a916c6f379e041de0e7efb4422c65f650/dmesg-kvm-lkp-nex04-1015-20130623091627-3.9.0-rc4-03252-g8b473e1-58
/kernel/x86_64-randconfig-x07-0621/8b473e1a916c6f379e041de0e7efb4422c65f650/dmesg-kvm-lkp-nex04-14327-20130623091627-3.9.0-rc4-03252-g8b473e1-58
/kernel/x86_64-randconfig-x07-0621/8b473e1a916c6f379e041de0e7efb4422c65f650/dmesg-kvm-lkp-nex04-14995-20130622180411-3.9.0-rc4-03252-g8b473e1-58
/kernel/x86_64-randconfig-x07-0621/8b473e1a916c6f379e041de0e7efb4422c65f650/dmesg-kvm-lkp-nex04-17185-20130623091625-3.9.0-rc4-03252-g8b473e1-58
/kernel/x86_64-randconfig-x07-0621/8b473e1a916c6f379e041de0e7efb4422c65f650/dmesg-kvm-lkp-nex04-25983-20130623091626-3.9.0-rc4-03252-g8b473e1-58
/kernel/x86_64-randconfig-x07-0621/8b473e1a916c6f379e041de0e7efb4422c65f650/dmesg-kvm-lkp-nex04-30210-20130623091626-3.9.0-rc4-03252-g8b473e1-58
/kernel/x86_64-randconfig-x07-0621/8b473e1a916c6f379e041de0e7efb4422c65f650/dmesg-kvm-lkp-nex04-45780-20130623091627-3.9.0-rc4-03252-g8b473e1-58
/kernel/x86_64-randconfig-x07-0621/8b473e1a916c6f379e041de0e7efb4422c65f650/dmesg-kvm-lkp-nex04-63092-20130623091625-3.9.0-rc4-03252-g8b473e1-58
/kernel/x86_64-randconfig-x07-0621/8b473e1a916c6f379e041de0e7efb4422c65f650/dmesg-kvm-lkp-sbx04-20506-20130623131904-3.9.0-rc4-03252-g8b473e1-58
/kernel/x86_64-randconfig-x07-0621/8b473e1a916c6f379e041de0e7efb4422c65f650/dmesg-kvm-roam-11727-20130622083455-3.9.0-rc4-03252-g8b473e1-58
/kernel/x86_64-randconfig-x07-0621/8b473e1a916c6f379e041de0e7efb4422c65f650/dmesg-kvm-roam-13045-20130622075614-3.9.0-rc4-03252-g8b473e1-58
/kernel/x86_64-randconfig-x07-0621/8b473e1a916c6f379e041de0e7efb4422c65f650/dmesg-kvm-roam-20415-20130622075628-3.9.0-rc4-03252-g8b473e1-58
/kernel/x86_64-randconfig-x07-0621/8b473e1a916c6f379e041de0e7efb4422c65f650/dmesg-kvm-roam-960-20130622075649-3.9.0-rc4-03252-g8b473e1-58
/kernel/x86_64-randconfig-x07-0621/8b473e1a916c6f379e041de0e7efb4422c65f650/dmesg-kvm-snb-13201-20130622080125-3.9.0-rc4-03252-g8b473e1-58
/kernel/x86_64-randconfig-x07-0621/8b473e1a916c6f379e041de0e7efb4422c65f650/dmesg-kvm-snb-15359-20130622080115-3.9.0-rc4-03252-g8b473e1-58
/kernel/x86_64-randconfig-x07-0621/8b473e1a916c6f379e041de0e7efb4422c65f650/dmesg-kvm-snb-18976-20130622080122-3.9.0-rc4-03252-g8b473e1-58
/kernel/x86_64-randconfig-x07-0621/8b473e1a916c6f379e041de0e7efb4422c65f650/dmesg-kvm-snb-21520-20130622080120-3.9.0-rc4-03252-g8b473e1-58
/kernel/x86_64-randconfig-x07-0621/8b473e1a916c6f379e041de0e7efb4422c65f650/dmesg-kvm-stoakley-1398-20130623091439-3.9.0-rc4-03252-g8b473e1-58
/kernel/x86_64-randconfig-x07-0621/8b473e1a916c6f379e041de0e7efb4422c65f650/dmesg-kvm-stoakley-29599-20130623091441-3.9.0-rc4-03252-g8b473e1-58
/kernel/x86_64-randconfig-x07-0621/8b473e1a916c6f379e041de0e7efb4422c65f650/dmesg-kvm-stoakley-5839-20130623091441-3.9.0-rc4-03252-g8b473e1-58
/kernel/x86_64-randconfig-x07-0621/8b473e1a916c6f379e041de0e7efb4422c65f650/dmesg-kvm-stoakley-6290-20130623091438-3.9.0-rc4-03252-g8b473e1-58
/kernel/x86_64-randconfig-x07-0621/8b473e1a916c6f379e041de0e7efb4422c65f650/dmesg-kvm-vp-11691-20130622083652-3.9.0-rc4-03252-g8b473e1-58
/kernel/x86_64-randconfig-x07-0621/8b473e1a916c6f379e041de0e7efb4422c65f650/dmesg-kvm-vp-11691-20130622090431-3.9.0-rc4-03252-g8b473e1-58
/kernel/x86_64-randconfig-x07-0621/8b473e1a916c6f379e041de0e7efb4422c65f650/dmesg-kvm-vp-14805-20130622083708-3.9.0-rc4-03252-g8b473e1-58
/kernel/x86_64-randconfig-x07-0621/8b473e1a916c6f379e041de0e7efb4422c65f650/dmesg-kvm-vp-15622-20130623091632-3.9.0-rc4-03252-g8b473e1-58
/kernel/x86_64-randconfig-x07-0621/8b473e1a916c6f379e041de0e7efb4422c65f650/dmesg-kvm-vp-19368-20130622083711-3.9.0-rc4-03252-g8b473e1-58
/kernel/x86_64-randconfig-x07-0621/8b473e1a916c6f379e041de0e7efb4422c65f650/dmesg-kvm-vp-23561-20130622180359-3.9.0-rc4-03252-g8b473e1-58
/kernel/x86_64-randconfig-x07-0621/8b473e1a916c6f379e041de0e7efb4422c65f650/dmesg-kvm-vp-28163-20130622090233-3.9.0-rc4-03252-g8b473e1-58
/kernel/x86_64-randconfig-x07-0621/8b473e1a916c6f379e041de0e7efb4422c65f650/dmesg-kvm-vp-4996-20130622090431-3.9.0-rc4-03252-g8b473e1-58
/kernel/x86_64-randconfig-x07-0621/8b473e1a916c6f379e041de0e7efb4422c65f650/dmesg-kvm-vp-6294-20130622090427-3.9.0-rc4-03252-g8b473e1-58
/kernel/x86_64-randconfig-x07-0621/8b473e1a916c6f379e041de0e7efb4422c65f650/dmesg-kvm-vp-6436-20130622083657-3.9.0-rc4-03252-g8b473e1-58
/kernel/x86_64-randconfig-x07-0621/8b473e1a916c6f379e041de0e7efb4422c65f650/dmesg-kvm-vp-9012-20130623091631-3.9.0-rc4-03252-g8b473e1-58
/kernel/x86_64-randconfig-x07-0621/8b473e1a916c6f379e041de0e7efb4422c65f650/dmesg-kvm-waimea-8652-20130622090426-3.9.0-rc4-03252-g8b473e1-58
/kernel/x86_64-randconfig-x07-0621/8b473e1a916c6f379e041de0e7efb4422c65f650/dmesg-kvm-xbm-32677-20130622090411-3.9.0-rc4-03252-g8b473e1-58
/kernel/x86_64-randconfig-x07-0621/8b473e1a916c6f379e041de0e7efb4422c65f650/dmesg-kvm-xgwo-9509-20130623091426-3.9.0-rc4-03252-g8b473e1-58

bisect: bad commit 8b473e1a916c6f379e041de0e7efb4422c65f650
git checkout v3.8
Previous HEAD position was 8b473e1... Merge remote-tracking branch 'stable/master'
HEAD is now at 19f949f... Linux 3.8
ls -a /kernel-tests/run-queue/kvm/x86_64-randconfig-x07-0621/sound-unstable:master:19f949f52599ba7c3f67a5897ac6be14bfcb1200:bisect-mm

2013-06-23-09:17:03 19f949f52599ba7c3f67a5897ac6be14bfcb1200 compiling
289 real  1231 user  90 sys  457.57% cpu 	x86_64-randconfig-x07-0621

2013-06-23-09:22:53 detecting boot state 3.8.0... TEST FAILURE
dmesg-kvm-xbm-32676-20130623092720-3.8.0-79
dmesg-kvm-xbm-32677-20130623092721-3.8.0-79

bisect: bad commit v3.8
git checkout v3.7
Previous HEAD position was 19f949f... Linux 3.8
HEAD is now at 2959440... Linux 3.7
ls -a /kernel-tests/run-queue/kvm/x86_64-randconfig-x07-0621/sound-unstable:master:29594404d7fe73cd80eaa4ee8c43dcc53970c60e:bisect-mm

2013-06-23-09:24:27 29594404d7fe73cd80eaa4ee8c43dcc53970c60e compiling
104 real  1157 user  81 sys  1187.31% cpu 	x86_64-randconfig-x07-0621

2013-06-23-09:26:21 detecting boot state 3.7.0.... TEST FAILURE
dmesg-kvm-lkp-sbx04-55544-20130623133207-3.7.0-80
dmesg-kvm-lkp-sbx04-5767-20130623133207-3.7.0-80
dmesg-kvm-lkp-sbx04-60761-20130623133205-3.7.0-80
dmesg-kvm-lkp-sbx04-61357-20130623133208-3.7.0-80
dmesg-kvm-lkp-sbx04-62004-20130623133205-3.7.0-80
dmesg-kvm-vp-10660-20130623092929-3.7.0-80
dmesg-kvm-vp-13036-20130623092934-3.7.0-80
dmesg-kvm-vp-13289-20130623092924-3.7.0-80
dmesg-kvm-vp-15883-20130623092932-3.7.0-80
dmesg-kvm-vp-23811-20130623092932-3.7.0-80
dmesg-kvm-vp-24180-20130623092932-3.7.0-80
dmesg-kvm-vp-27549-20130623092924-3.7.0-80
dmesg-kvm-lkp-nex04-40601-20130623092920-3.7.0-80
dmesg-kvm-lkp-nex04-58716-20130623092916-3.7.0-80
dmesg-kvm-vp-6576-20130623092934-3.7.0-80
dmesg-kvm-vp-7835-20130623092933-3.7.0-80
dmesg-kvm-vp-8662-20130623092933-3.7.0-80
dmesg-kvm-lkp-sbx04-10820-20130623133206-3.7.0-80
dmesg-kvm-lkp-sbx04-12054-20130623133206-3.7.0-80
dmesg-kvm-lkp-sbx04-15200-20130623133207-3.7.0-80
dmesg-kvm-lkp-sbx04-18239-20130623133205-3.7.0-80
dmesg-kvm-lkp-sbx04-37066-20130623133207-3.7.0-80
dmesg-kvm-lkp-sbx04-43349-20130623133206-3.7.0-80
dmesg-kvm-lkp-sbx04-47133-20130623133208-3.7.0-80
dmesg-kvm-lkp-sbx04-49445-20130623133204-3.7.0-80

bisect: bad commit v3.7
git checkout v3.6
Previous HEAD position was 2959440... Linux 3.7
HEAD is now at a0d271c... Linux 3.6
ls -a /kernel-tests/run-queue/kvm/x86_64-randconfig-x07-0621/sound-unstable:master:a0d271cbfed1dd50278c6b06bead3d00ba0a88f9:bisect-mm

2013-06-23-09:28:27 a0d271cbfed1dd50278c6b06bead3d00ba0a88f9 compiling
110 real  1132 user  78 sys  1093.03% cpu 	x86_64-randconfig-x07-0621

2013-06-23-09:30:30 detecting boot state 3.6.0... TEST FAILURE
dmesg-kvm-lkp-sbx04-7205-20130623133600-3.6.0-81
dmesg-kvm-vp-10660-20130623093326-3.6.0-81
dmesg-kvm-vp-25480-20130623093326-3.6.0-81
dmesg-kvm-vp-5112-20130623093326-3.6.0-81
dmesg-kvm-inn-19208-20130623093146-3.6.0-81
dmesg-kvm-inn-5702-20130623093147-3.6.0-81
dmesg-kvm-inn-64309-20130623093147-3.6.0-81
dmesg-kvm-vp-15345-20130623093326-3.6.0-81
dmesg-kvm-inn-25421-20130623093147-3.6.0-81
dmesg-kvm-inn-29783-20130623093147-3.6.0-81
dmesg-kvm-inn-30729-20130623093147-3.6.0-81
dmesg-kvm-lkp-sbx04-49445-20130623133600-3.6.0-81
dmesg-kvm-inn-32319-20130623093147-3.6.0-81
dmesg-kvm-inn-49525-20130623093147-3.6.0-81
dmesg-kvm-inn-8693-20130623093147-3.6.0-81
dmesg-kvm-vp-26744-20130623093327-3.6.0-81
dmesg-kvm-lkp-nex04-10414-20130623093321-3.6.0-81
dmesg-kvm-lkp-nex04-12568-20130623093321-3.6.0-81
dmesg-kvm-lkp-nex04-1329-20130623093321-3.6.0-81
dmesg-kvm-lkp-nex04-22469-20130623093321-3.6.0-81
dmesg-kvm-lkp-nex04-3844-20130623093322-3.6.0-81
dmesg-kvm-lkp-nex04-47760-20130623093321-3.6.0-81
dmesg-kvm-lkp-nex04-50757-20130623093321-3.6.0-81
dmesg-kvm-lkp-nex04-55700-20130623093321-3.6.0-81
dmesg-kvm-lkp-nex04-59917-20130623093322-3.6.0-81
dmesg-kvm-lkp-nex04-64110-20130623093322-3.6.0-81
dmesg-kvm-lkp-nex04-7152-20130623093322-3.6.0-81

bisect: bad commit v3.6
git checkout v3.5
Previous HEAD position was a0d271c... Linux 3.6
HEAD is now at 28a33cb... Linux 3.5
ls -a /kernel-tests/run-queue/kvm/x86_64-randconfig-x07-0621/sound-unstable:master:28a33cbc24e4256c143dce96c7d93bf423229f92:bisect-mm

2013-06-23-09:32:05 28a33cbc24e4256c143dce96c7d93bf423229f92 compiling
107 real  1105 user  78 sys  1105.13% cpu 	x86_64-randconfig-x07-0621

2013-06-23-09:34:01 detecting boot state 3.5.0... TEST FAILURE
dmesg-kvm-lkp-nex04-10789-20130623093655-3.5.0-82
dmesg-kvm-lkp-nex04-11259-20130623093654-3.5.0-82
dmesg-kvm-lkp-nex04-12359-20130623093654-3.5.0-82
dmesg-kvm-lkp-nex04-12568-20130623093656-3.5.0-82
dmesg-kvm-lkp-nex04-14638-20130623093653-3.5.0-82
dmesg-kvm-lkp-nex04-18378-20130623093655-3.5.0-82
dmesg-kvm-lkp-nex04-24012-20130623093653-3.5.0-82
dmesg-kvm-lkp-nex04-3334-20130623093656-3.5.0-82
dmesg-kvm-lkp-nex04-35185-20130623093654-3.5.0-82
dmesg-kvm-lkp-nex04-35594-20130623093653-3.5.0-82
dmesg-kvm-lkp-nex04-37672-20130623093654-3.5.0-82
dmesg-kvm-lkp-nex04-44786-20130623093654-3.5.0-82
dmesg-kvm-lkp-nex04-47760-20130623093656-3.5.0-82
dmesg-kvm-lkp-nex04-50142-20130623093653-3.5.0-82
dmesg-kvm-lkp-nex04-51691-20130623093655-3.5.0-82
dmesg-kvm-lkp-nex04-53525-20130623093653-3.5.0-82
dmesg-kvm-lkp-nex04-54913-20130623093653-3.5.0-82
dmesg-kvm-lkp-nex04-58328-20130623093653-3.5.0-82
dmesg-kvm-lkp-nex04-5846-20130623093656-3.5.0-82
dmesg-kvm-lkp-nex04-60659-20130623093654-3.5.0-82
dmesg-kvm-lkp-nex04-62778-20130623093655-3.5.0-82
dmesg-kvm-lkp-nex04-8089-20130623093653-3.5.0-82
dmesg-kvm-lkp-nex04-8361-20130623093655-3.5.0-82
dmesg-kvm-lkp-nex04-8753-20130623093653-3.5.0-82
dmesg-kvm-lkp-nex04-9444-20130623093654-3.5.0-82
dmesg-kvm-lkp-sbx04-13991-20130623133933-3.5.0-82
dmesg-kvm-vp-7686-20130623093658-3.5.0-82

bisect: bad commit v3.5
git checkout v3.4
Previous HEAD position was 28a33cb... Linux 3.5
HEAD is now at 76e10d1... Linux 3.4
ls -a /kernel-tests/run-queue/kvm/x86_64-randconfig-x07-0621/sound-unstable:master:76e10d158efb6d4516018846f60c2ab5501900bc:bisect-mm

2013-06-23-09:35:35 76e10d158efb6d4516018846f60c2ab5501900bc compiling
122 real  1080 user  75 sys  939.94% cpu 	x86_64-randconfig-x07-0621

2013-06-23-09:38:02 detecting boot state 3.4.0..... TEST FAILURE
dmesg-kvm-lkp-sbx04-6974-20130623134351-3.4.0-83
dmesg-kvm-xbm-32337-20130623094320-3.4.0-83
dmesg-kvm-xbm-4401-20130623094313-3.4.0-83
dmesg-kvm-lkp-sbx04-7505-20130623134355-3.4.0-83
dmesg-kvm-xgwo-14769-20130623093917-3.4.0-83
dmesg-kvm-lkp-sbx04-31937-20130623134353-3.4.0-83

bisect: bad commit v3.4
git checkout v3.3
Previous HEAD position was 76e10d1... Linux 3.4
HEAD is now at c16fa4f... Linux 3.3
ls -a /kernel-tests/run-queue/kvm/x86_64-randconfig-x07-0621/sound-unstable:master:c16fa4f2ad19908a47c63d8fa436a1178438c7e7:bisect-mm

2013-06-23-09:40:43 c16fa4f2ad19908a47c63d8fa436a1178438c7e7 compiling
155 real  1107 user  77 sys  761.83% cpu 	x86_64-randconfig-x07-0621

2013-06-23-09:46:28 detecting boot state 3.3.0... TEST FAILURE
dmesg-kvm-inn-12623-20130623094752-3.3.0-84
dmesg-kvm-inn-35123-20130623094752-3.3.0-84
dmesg-kvm-inn-36980-20130623094753-3.3.0-84
dmesg-kvm-inn-51893-20130623094755-3.3.0-84
dmesg-kvm-lkp-sbx04-14292-20130623135209-3.3.0-84
dmesg-kvm-lkp-sbx04-31937-20130623135205-3.3.0-84
dmesg-kvm-lkp-sbx04-37042-20130623135206-3.3.0-84
dmesg-kvm-lkp-sbx04-41939-20130623135205-3.3.0-84
dmesg-kvm-lkp-sbx04-5226-20130623135209-3.3.0-84
dmesg-kvm-lkp-sbx04-6582-20130623135207-3.3.0-84
dmesg-kvm-vp-22633-20130623094932-3.3.0-84
dmesg-kvm-lkp-nex04-34681-20130623094927-3.3.0-84
dmesg-kvm-lkp-nex04-36195-20130623094927-3.3.0-84

bisect: bad commit v3.3
git checkout v3.2
Previous HEAD position was c16fa4f... Linux 3.3
HEAD is now at 805a6af... Linux 3.2
ls -a /kernel-tests/run-queue/kvm/x86_64-randconfig-x07-0621/sound-unstable:master:805a6af8dba5dfdd35ec35dc52ec0122400b2610:bisect-mm

2013-06-23-09:48:10 805a6af8dba5dfdd35ec35dc52ec0122400b2610 compiling
132 real  1049 user  74 sys  851.14% cpu 	x86_64-randconfig-x07-0621

2013-06-23-09:52:50 detecting boot state 3.2.0..... TEST FAILURE
dmesg-kvm-inn-8693-20130623095420-3.2.0-85
dmesg-kvm-roam-15017-20130623095328-3.2.0-85
dmesg-kvm-lkp-sbx04-27675-20130623135832-3.2.0-85
dmesg-kvm-lkp-nex04-36662-20130623095603-3.2.0-85
dmesg-kvm-kbuild-51240-20130623094952-3.2.0-85
dmesg-kvm-lkp-nex04-36776-20130623095557-3.2.0-85
dmesg-kvm-inn-30729-20130623095419-3.2.0-85
dmesg-kvm-lkp-sbx04-16537-20130623135833-3.2.0-85
dmesg-kvm-roam-18581-20130623095330-3.2.0-85
dmesg-kvm-kbuild-54521-20130623094955-3.2.0-85
dmesg-kvm-vp-28163-20130623095605-3.2.0-85
dmesg-kvm-lkp-sbx04-10086-20130623135845-3.2.0-85
dmesg-kvm-lkp-nex04-48446-20130623095558-3.2.0-85
dmesg-kvm-xgwo-18410-20130623095357-3.2.0-85
dmesg-kvm-lkp-sbx04-18846-20130623135839-3.2.0-85
dmesg-kvm-lkp-sbx04-19510-20130623135835-3.2.0-85
dmesg-kvm-lkp-sbx04-11449-20130623135835-3.2.0-85

bisect: bad commit v3.2
git checkout v3.1
Previous HEAD position was 805a6af... Linux 3.2
HEAD is now at c3b92c8... Linux 3.1
ls -a /kernel-tests/run-queue/kvm/x86_64-randconfig-x07-0621/sound-unstable:master:c3b92c8787367a8bb53d57d9789b558f1295cc96:bisect-mm

2013-06-23-09:55:29 c3b92c8787367a8bb53d57d9789b558f1295cc96 compiling
242 real  988 user  69 sys  435.84% cpu 	x86_64-randconfig-x07-0621

2013-06-23-10:00:19 detecting boot state 3.1.0..	1	27 SUCCESS

bisect: good commit v3.1
git bisect start v3.2 v3.1 --
Previous HEAD position was c3b92c8... Linux 3.1
HEAD is now at 3c0eee3... Linux 2.6.37
Bisecting: 6189 revisions left to test after this (roughly 13 steps)
[68d99b2c8efcb6ed3807a55569300c53b5f88be5] Merge branch 'for-linus' of git://git.kernel.org/pub/scm/linux/kernel/git/tiwai/sound
git bisect run /c/kernel-tests/bisect-test-boot-failure.sh /home/wfg/mm/obj-bisect
running /c/kernel-tests/bisect-test-boot-failure.sh /home/wfg/mm/obj-bisect
ls -a /kernel-tests/run-queue/kvm/x86_64-randconfig-x07-0621/sound-unstable:master:68d99b2c8efcb6ed3807a55569300c53b5f88be5:bisect-mm

2013-06-23-10:03:03 68d99b2c8efcb6ed3807a55569300c53b5f88be5 compiling
162 real  1001 user  72 sys  662.05% cpu 	x86_64-randconfig-x07-0621

2013-06-23-10:08:06 detecting boot state 3.1.0-06495-g68d99b2.... TEST FAILURE
dmesg-kvm-inn-32319-20130623100939-3.1.0-06495-g68d99b2-87
dmesg-kvm-roam-1718-20130623100845-3.1.0-06495-g68d99b2-87
dmesg-kvm-inn-4641-20130623100938-3.1.0-06495-g68d99b2-87
dmesg-kvm-vp-5112-20130623101121-3.1.0-06495-g68d99b2-87
dmesg-kvm-inn-1390-20130623100935-3.1.0-06495-g68d99b2-87
dmesg-kvm-roam-4459-20130623100841-3.1.0-06495-g68d99b2-87
dmesg-kvm-inn-1566-20130623100935-3.1.0-06495-g68d99b2-87
dmesg-kvm-lkp-sbx04-41939-20130623141355-3.1.0-06495-g68d99b2-87
dmesg-kvm-inn-60288-20130623100933-3.1.0-06495-g68d99b2-87
dmesg-kvm-roam-7493-20130623100847-3.1.0-06495-g68d99b2-87
dmesg-kvm-inn-30550-20130623100939-3.1.0-06495-g68d99b2-87
dmesg-kvm-xgwo-11439-20130623100913-3.1.0-06495-g68d99b2-87

Bisecting: 3558 revisions left to test after this (roughly 12 steps)
[efb8d21b2c6db3497655cc6a033ae8a9883e4063] Merge branch 'tty-next' of git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/tty
running /c/kernel-tests/bisect-test-boot-failure.sh /home/wfg/mm/obj-bisect
ls -a /kernel-tests/run-queue/kvm/x86_64-randconfig-x07-0621/sound-unstable:master:efb8d21b2c6db3497655cc6a033ae8a9883e4063:bisect-mm

2013-06-23-10:10:09 efb8d21b2c6db3497655cc6a033ae8a9883e4063 compiling
211 real  1017 user  71 sys  515.77% cpu 	x86_64-randconfig-x07-0621

2013-06-23-10:15:51 detecting boot state 3.1.0-02946-gefb8d21...	18	27 SUCCESS

Bisecting: 1793 revisions left to test after this (roughly 11 steps)
[8686a0e200419322654a75155e2e6f80346a1297] Merge branch 'perf-urgent-for-linus' of git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip
running /c/kernel-tests/bisect-test-boot-failure.sh /home/wfg/mm/obj-bisect
ls -a /kernel-tests/run-queue/kvm/x86_64-randconfig-x07-0621/sound-unstable:master:8686a0e200419322654a75155e2e6f80346a1297:bisect-mm

2013-06-23-10:18:24 8686a0e200419322654a75155e2e6f80346a1297 compiling
106 real  1007 user  70 sys  1014.26% cpu 	x86_64-randconfig-x07-0621

2013-06-23-10:20:26 detecting boot state 3.1.0-04711-g8686a0e.... TEST FAILURE
dmesg-kvm-inn-4435-20130623102146-3.1.0-04711-g8686a0e-89
dmesg-kvm-inn-4641-20130623102146-3.1.0-04711-g8686a0e-89
dmesg-kvm-inn-24230-20130623102147-3.1.0-04711-g8686a0e-89
dmesg-kvm-inn-51352-20130623102147-3.1.0-04711-g8686a0e-89
dmesg-kvm-lkp-sbx04-7632-20130623142603-3.1.0-04711-g8686a0e-89
dmesg-kvm-roam-12376-20130623102058-3.1.0-04711-g8686a0e-89
dmesg-kvm-vp-28467-20130623102331-3.1.0-04711-g8686a0e-89
dmesg-kvm-lkp-sbx04-21947-20130623142609-3.1.0-04711-g8686a0e-89
dmesg-kvm-vp-6174-20130623102337-3.1.0-04711-g8686a0e-89
dmesg-kvm-vp-11691-20130623102341-3.1.0-04711-g8686a0e-89
dmesg-kvm-vp-13289-20130623102337-3.1.0-04711-g8686a0e-89

Bisecting: 882 revisions left to test after this (roughly 10 steps)
[33bc95513c801b1637b6fb925155fb794b5da4f0] staging: brcm80211: remove 'default n' from Kconfig
running /c/kernel-tests/bisect-test-boot-failure.sh /home/wfg/mm/obj-bisect
ls -a /kernel-tests/run-queue/kvm/x86_64-randconfig-x07-0621/sound-unstable:master:33bc95513c801b1637b6fb925155fb794b5da4f0:bisect-mm

2013-06-23-10:22:29 33bc95513c801b1637b6fb925155fb794b5da4f0 compiling
85 real  955 user  68 sys  1196.70% cpu 	x86_64-randconfig-x07-0621

2013-06-23-10:24:03 detecting boot state 3.1.0-rc4-00882-g33bc955...	3	10	27 SUCCESS

Bisecting: 441 revisions left to test after this (roughly 9 steps)
[4d8daa6b77d0697ea19b9c4f704be9b26d76fb36] staging: brcm80211: cleaned up struct brcms_bss_cfg
running /c/kernel-tests/bisect-test-boot-failure.sh /home/wfg/mm/obj-bisect
ls -a /kernel-tests/run-queue/kvm/x86_64-randconfig-x07-0621/sound-unstable:master:4d8daa6b77d0697ea19b9c4f704be9b26d76fb36:bisect-mm

2013-06-23-10:27:08 4d8daa6b77d0697ea19b9c4f704be9b26d76fb36 compiling
50 real  41 user  4 sys  91.34% cpu 	x86_64-randconfig-x07-0621

2013-06-23-10:31:13 detecting boot state 3.1.0-rc4-01323-g4d8daa6...	20	26	27 SUCCESS

Bisecting: 218 revisions left to test after this (roughly 8 steps)
[982653009b883ef1529089e3e6f1ae2fee41cbe2] Merge branch 'core-iommu-for-linus' of git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip
running /c/kernel-tests/bisect-test-boot-failure.sh /home/wfg/mm/obj-bisect
ls -a /kernel-tests/run-queue/kvm/x86_64-randconfig-x07-0621/sound-unstable:master:982653009b883ef1529089e3e6f1ae2fee41cbe2:bisect-mm

2013-06-23-10:34:17 982653009b883ef1529089e3e6f1ae2fee41cbe2 compiling
76 real  1015 user  72 sys  1414.24% cpu 	x86_64-randconfig-x07-0621

2013-06-23-10:35:47 detecting boot state 3.1.0-04492-g9826530..	1	24	27 SUCCESS

Bisecting: 108 revisions left to test after this (roughly 7 steps)
[47724df3375bf0cf652039ab6b7ded29fe877de6] Merge branch 'tip/perf/core' of git://git.kernel.org/pub/scm/linux/kernel/git/rostedt/linux-trace into perf/core
running /c/kernel-tests/bisect-test-boot-failure.sh /home/wfg/mm/obj-bisect
ls -a /kernel-tests/run-queue/kvm/x86_64-randconfig-x07-0621/sound-unstable:master:47724df3375bf0cf652039ab6b7ded29fe877de6:bisect-mm

2013-06-23-10:38:20 47724df3375bf0cf652039ab6b7ded29fe877de6 compiling
106 real  987 user  66 sys  993.25% cpu 	x86_64-randconfig-x07-0621

2013-06-23-10:40:33 detecting boot state 3.1.0-rc9-00110-g47724df...	14	26	27 SUCCESS

Bisecting: 62 revisions left to test after this (roughly 6 steps)
[048b718029033af117870d3da47da12995be14a3] Merge branch 'rcu/next' of git://github.com/paulmckrcu/linux into core/rcu
running /c/kernel-tests/bisect-test-boot-failure.sh /home/wfg/mm/obj-bisect
ls -a /kernel-tests/run-queue/kvm/x86_64-randconfig-x07-0621/sound-unstable:master:048b718029033af117870d3da47da12995be14a3:bisect-mm

2013-06-23-10:43:36 048b718029033af117870d3da47da12995be14a3 compiling
382 real  954 user  70 sys  268.12% cpu 	x86_64-randconfig-x07-0621

2013-06-23-10:50:54 detecting boot state 3.1.0-rc8-00106-g048b718.... TEST FAILURE
dmesg-kvm-lkp-nex04-41962-20130623105402-3.1.0-rc8-00106-g048b718-94
dmesg-kvm-vp-17172-20130623105406-3.1.0-rc8-00106-g048b718-94
dmesg-kvm-vp-17509-20130623105406-3.1.0-rc8-00106-g048b718-94
dmesg-kvm-lkp-nex04-33765-20130623105400-3.1.0-rc8-00106-g048b718-94
dmesg-kvm-lkp-sbx04-5645-20130623145637-3.1.0-rc8-00106-g048b718-94
dmesg-kvm-lkp-sbx04-11838-20130623145638-3.1.0-rc8-00106-g048b718-94
dmesg-kvm-lkp-nex04-33927-20130623105400-3.1.0-rc8-00106-g048b718-94
dmesg-kvm-lkp-nex04-34205-20130623105356-3.1.0-rc8-00106-g048b718-94
dmesg-kvm-lkp-nex04-34867-20130623105358-3.1.0-rc8-00106-g048b718-94
dmesg-kvm-lkp-nex04-46239-20130623105401-3.1.0-rc8-00106-g048b718-94
dmesg-kvm-lkp-sbx04-8220-20130623145638-3.1.0-rc8-00106-g048b718-94
dmesg-kvm-lkp-sbx04-8598-20130623145639-3.1.0-rc8-00106-g048b718-94
dmesg-kvm-vp-26744-20130623105403-3.1.0-rc8-00106-g048b718-94
dmesg-kvm-lkp-sbx04-23998-20130623145637-3.1.0-rc8-00106-g048b718-94
dmesg-kvm-lkp-sbx04-25293-20130623145639-3.1.0-rc8-00106-g048b718-94

Bisecting: 22 revisions left to test after this (roughly 5 steps)
[e5177ec77d503636d0b609671c9d408b981add17] rcu: Not necessary to pass rcu_read_lock_held() to rcu_dereference_protected()
running /c/kernel-tests/bisect-test-boot-failure.sh /home/wfg/mm/obj-bisect
ls -a /kernel-tests/run-queue/kvm/x86_64-randconfig-x07-0621/sound-unstable:master:e5177ec77d503636d0b609671c9d408b981add17:bisect-mm

2013-06-23-10:52:58 e5177ec77d503636d0b609671c9d408b981add17 compiling
94 real  963 user  66 sys  1086.60% cpu 	x86_64-randconfig-x07-0621

2013-06-23-10:54:59 detecting boot state 3.1.0-rc8-00023-ge5177ec.... TEST FAILURE
dmesg-kvm-bay-8678-20130623105859-3.1.0-rc8-00023-ge5177ec-95
dmesg-kvm-xgwo-21657-20130623105600-3.1.0-rc8-00023-ge5177ec-95

Bisecting: 11 revisions left to test after this (roughly 4 steps)
[8008e129dc90ff4f7a56cb033d6bd042afe3ed52] rcu: Drive configuration directly from SMP and PREEMPT
running /c/kernel-tests/bisect-test-boot-failure.sh /home/wfg/mm/obj-bisect
ls -a /kernel-tests/run-queue/kvm/x86_64-randconfig-x07-0621/sound-unstable:master:8008e129dc90ff4f7a56cb033d6bd042afe3ed52:bisect-mm

2013-06-23-10:57:00 8008e129dc90ff4f7a56cb033d6bd042afe3ed52 compiling
79 real  965 user  69 sys  1298.28% cpu 	x86_64-randconfig-x07-0621

2013-06-23-10:58:28 detecting boot state 3.1.0-rc8-00011-g8008e12..	7	27 SUCCESS

Bisecting: 5 revisions left to test after this (roughly 3 steps)
[e0f23060adfa3f27beaa7918eff70258b88471b6] rcu: Update comments to reflect softirqs vs. kthreads
running /c/kernel-tests/bisect-test-boot-failure.sh /home/wfg/mm/obj-bisect
ls -a /kernel-tests/run-queue/kvm/x86_64-randconfig-x07-0621/sound-unstable:master:e0f23060adfa3f27beaa7918eff70258b88471b6:bisect-mm

2013-06-23-11:00:29 e0f23060adfa3f27beaa7918eff70258b88471b6 compiling
83 real  963 user  68 sys  1235.04% cpu 	x86_64-randconfig-x07-0621

2013-06-23-11:02:20 detecting boot state 3.1.0-rc8-00017-ge0f2306..	1	24	27 SUCCESS

Bisecting: 2 revisions left to test after this (roughly 2 steps)
[965a002b4f1a458c5dcb334ec29f48a0046faa25] rcu: Make TINY_RCU also use softirq for RCU_BOOST=n
running /c/kernel-tests/bisect-test-boot-failure.sh /home/wfg/mm/obj-bisect
ls -a /kernel-tests/run-queue/kvm/x86_64-randconfig-x07-0621/sound-unstable:master:965a002b4f1a458c5dcb334ec29f48a0046faa25:bisect-mm

2013-06-23-11:04:53 965a002b4f1a458c5dcb334ec29f48a0046faa25 compiling
80 real  978 user  71 sys  1307.77% cpu 	x86_64-randconfig-x07-0621

2013-06-23-11:08:50 detecting boot state 3.1.0-rc8-00020-g965a002... TEST FAILURE
dmesg-kvm-athens-37998-20130623111021-3.1.0-rc8-00020-g965a002-98
dmesg-kvm-lkp-nex04-33966-20130623111135-3.1.0-rc8-00020-g965a002-98
dmesg-kvm-lkp-nex04-34312-20130623111135-3.1.0-rc8-00020-g965a002-98
dmesg-kvm-lkp-nex04-40084-20130623111135-3.1.0-rc8-00020-g965a002-98
dmesg-kvm-lkp-nex04-41560-20130623111135-3.1.0-rc8-00020-g965a002-98
dmesg-kvm-lkp-nex04-41690-20130623111138-3.1.0-rc8-00020-g965a002-98
dmesg-kvm-lkp-nex04-46219-20130623111135-3.1.0-rc8-00020-g965a002-98
dmesg-kvm-lkp-nex04-48792-20130623111135-3.1.0-rc8-00020-g965a002-98
dmesg-kvm-lkp-sbx04-23208-20130623151422-3.1.0-rc8-00020-g965a002-98
dmesg-kvm-lkp-sbx04-23615-20130623151419-3.1.0-rc8-00020-g965a002-98
dmesg-kvm-lkp-sbx04-38667-20130623151420-3.1.0-rc8-00020-g965a002-98
dmesg-kvm-lkp-sbx04-57659-20130623151420-3.1.0-rc8-00020-g965a002-98
dmesg-kvm-lkp-sbx04-64867-20130623151422-3.1.0-rc8-00020-g965a002-98
dmesg-kvm-lkp-sbx04-8841-20130623151419-3.1.0-rc8-00020-g965a002-98
dmesg-kvm-lkp-sbx04-9541-20130623151420-3.1.0-rc8-00020-g965a002-98
dmesg-kvm-lkp-sbx04-9921-20130623151419-3.1.0-rc8-00020-g965a002-98
dmesg-kvm-stoakley-4146-20130623110953-3.1.0-rc8-00020-g965a002-98
dmesg-kvm-stoakley-4516-20130623110956-3.1.0-rc8-00020-g965a002-98
dmesg-kvm-stoakley-4693-20130623110956-3.1.0-rc8-00020-g965a002-98
dmesg-kvm-vp-24521-20130623111144-3.1.0-rc8-00020-g965a002-98

Bisecting: 0 revisions left to test after this (roughly 1 step)
[385680a9487d2f85382ad6d74e2a15837e47bfd9] rcu: Add event-trace markers to TREE_RCU kthreads
running /c/kernel-tests/bisect-test-boot-failure.sh /home/wfg/mm/obj-bisect
ls -a /kernel-tests/run-queue/kvm/x86_64-randconfig-x07-0621/sound-unstable:master:385680a9487d2f85382ad6d74e2a15837e47bfd9:bisect-mm

2013-06-23-11:10:24 385680a9487d2f85382ad6d74e2a15837e47bfd9 compiling
361 real  959 user  69 sys  284.92% cpu 	x86_64-randconfig-x07-0621

2013-06-23-11:17:43 detecting boot state 3.1.0-rc8-00019-g385680a...	25	27 SUCCESS

965a002b4f1a458c5dcb334ec29f48a0046faa25 is the first bad commit
commit 965a002b4f1a458c5dcb334ec29f48a0046faa25
Author: Paul E. McKenney <paul.mckenney@linaro.org>
Date:   Sat Jun 18 09:55:39 2011 -0700

    rcu: Make TINY_RCU also use softirq for RCU_BOOST=n
    
    This patch #ifdefs TINY_RCU kthreads out of the kernel unless RCU_BOOST=y,
    thus eliminating context-switch overhead if RCU priority boosting has
    not been configured.
    
    Signed-off-by: Paul E. McKenney <paul.mckenney@linaro.org>
    Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>

:040000 040000 27b097c9fc2a35edcc9e409333c395461e371282 f62fcc30f9171a55010089eaa2634b0b05c43774 M	include
:040000 040000 c449cf5ab090bea5364884f270cced91f8cc2390 6bb1fa236918029a0290a2a892134f4dd6dd96b9 M	kernel
bisect run success
ls -a /kernel-tests/run-queue/kvm/x86_64-randconfig-x07-0621/sound-unstable:master:385680a9487d2f85382ad6d74e2a15837e47bfd9:bisect-mm

2013-06-23-11:20:14 385680a9487d2f85382ad6d74e2a15837e47bfd9 reuse /kernel/x86_64-randconfig-x07-0621/385680a9487d2f85382ad6d74e2a15837e47bfd9/vmlinuz-3.1.0-rc8-00019-g385680a

2013-06-23-11:20:14 detecting boot state ...	28	65	80.	81 SUCCESS

ls -a /kernel-tests/run-queue/kvm/x86_64-randconfig-x07-0621/sound-unstable:master:1d995963014cc2a847f9e18d972a9e845b5c27cd:bisect-mm
 TEST FAILURE
/kernel/x86_64-randconfig-x07-0621/1d995963014cc2a847f9e18d972a9e845b5c27cd/dmesg-kvm-inn-11480-20130622071025-3.10.0-rc6-03425-g1d99596-56
/kernel/x86_64-randconfig-x07-0621/1d995963014cc2a847f9e18d972a9e845b5c27cd/dmesg-kvm-inn-20520-20130622071024-3.10.0-rc6-03425-g1d99596-56
/kernel/x86_64-randconfig-x07-0621/1d995963014cc2a847f9e18d972a9e845b5c27cd/dmesg-kvm-snb-11102-20130622071519-3.10.0-rc6-03425-g1d99596-56
/kernel/x86_64-randconfig-x07-0621/1d995963014cc2a847f9e18d972a9e845b5c27cd/dmesg-kvm-snb-24199-20130622071502-3.10.0-rc6-03425-g1d99596-56
/kernel/x86_64-randconfig-x07-0621/1d995963014cc2a847f9e18d972a9e845b5c27cd/dmesg-kvm-snb-26793-20130622071507-3.10.0-rc6-03425-g1d99596-56
/kernel/x86_64-randconfig-x07-0621/1d995963014cc2a847f9e18d972a9e845b5c27cd/dmesg-kvm-snb-32116-20130622071402-3.10.0-rc6-03425-g1d99596-56
/kernel/x86_64-randconfig-x07-0621/1d995963014cc2a847f9e18d972a9e845b5c27cd/dmesg-kvm-stoakley-4146-20130622071021-3.10.0-rc6-03425-g1d99596-56

HEAD is now at 1d99596 Merge remote-tracking branch 'stable/master'

========= upstream =========
Fetching linus
ls -a /kernel-tests/run-queue/kvm/x86_64-randconfig-x07-0621/sound-unstable:master:9e895ace5d82df8929b16f58e9f515f6d54ab82d:bisect-mm
 TEST FAILURE
/kernel/x86_64-randconfig-x07-0621/9e895ace5d82df8929b16f58e9f515f6d54ab82d/dmesg-kvm-lkp-nex04-37028-20130623111720-3.10.0-rc7-210
/kernel/x86_64-randconfig-x07-0621/9e895ace5d82df8929b16f58e9f515f6d54ab82d/dmesg-kvm-lkp-nex04-42077-20130623111720-3.10.0-rc7-210
/kernel/x86_64-randconfig-x07-0621/9e895ace5d82df8929b16f58e9f515f6d54ab82d/dmesg-kvm-vp-23113-20130623111730-3.10.0-rc7-210


========= linux-next =========
Fetching next
ls -a /kernel-tests/run-queue/kvm/x86_64-randconfig-x07-0621/sound-unstable:master:e1a86578747376f08985627c84df088a5d0d1e92:bisect-mm

2013-06-23-11:25:09 e1a86578747376f08985627c84df088a5d0d1e92 reuse /kernel/x86_64-randconfig-x07-0621/e1a86578747376f08985627c84df088a5d0d1e92/vmlinuz-3.10.0-rc6-next-20130621

2013-06-23-11:25:10 detecting boot state ..... TEST FAILURE
dmesg-kvm-lkp-nex04-44016-20130623112834-3.10.0-rc6-next-20130621-35
dmesg-kvm-lkp-nex04-36464-20130623112831-3.10.0-rc6-next-20130621-35
dmesg-kvm-bay-8700-20130623112921-3.10.0-rc6-next-20130621-35
dmesg-kvm-lkp-nex04-44531-20130623112828-3.10.0-rc6-next-20130621-35
dmesg-kvm-bens-3121-20130623112601-3.10.0-rc6-next-20130621-35
dmesg-kvm-lkp-nex04-36629-20130623112834-3.10.0-rc6-next-20130621-35
dmesg-kvm-lkp-nex04-44757-20130623112833-3.10.0-rc6-next-20130621-35
dmesg-kvm-lkp-nex04-36741-20130623112827-3.10.0-rc6-next-20130621-35
dmesg-kvm-lkp-nex04-44975-20130623112830-3.10.0-rc6-next-20130621-35
dmesg-kvm-lkp-nex04-36776-20130623112834-3.10.0-rc6-next-20130621-35
dmesg-kvm-lkp-nex04-45899-20130623112831-3.10.0-rc6-next-20130621-35
dmesg-kvm-lkp-nex04-46352-20130623112835-3.10.0-rc6-next-20130621-35
dmesg-kvm-lkp-nex04-37028-20130623112827-3.10.0-rc6-next-20130621-35
dmesg-kvm-lkp-nex04-37070-20130623112832-3.10.0-rc6-next-20130621-35
dmesg-kvm-lkp-nex04-37288-20130623112828-3.10.0-rc6-next-20130621-35
dmesg-kvm-lkp-nex04-37314-20130623112831-3.10.0-rc6-next-20130621-35
dmesg-kvm-lkp-nex04-47967-20130623112828-3.10.0-rc6-next-20130621-35
dmesg-kvm-lkp-nex04-48150-20130623112827-3.10.0-rc6-next-20130621-35
dmesg-kvm-lkp-nex04-48210-20130623112828-3.10.0-rc6-next-20130621-35
dmesg-kvm-bens-3760-20130623112610-3.10.0-rc6-next-20130621-35
dmesg-kvm-lkp-nex04-39610-20130623112833-3.10.0-rc6-next-20130621-35


--Kj7319i9nmIyA2yE
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename=".config-bisect"

#
# Automatically generated file; DO NOT EDIT.
# Linux/x86_64 3.9.0-rc4 Kernel Configuration
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
CONFIG_ARCH_HAS_DEFAULT_IDLE=y
CONFIG_ARCH_HAS_CACHE_LINE_SIZE=y
CONFIG_ARCH_HAS_CPU_AUTOPROBE=y
CONFIG_HAVE_SETUP_PER_CPU_AREA=y
CONFIG_NEED_PER_CPU_EMBED_FIRST_CHUNK=y
CONFIG_NEED_PER_CPU_PAGE_FIRST_CHUNK=y
CONFIG_ARCH_HIBERNATION_POSSIBLE=y
CONFIG_ARCH_SUSPEND_POSSIBLE=y
CONFIG_ZONE_DMA32=y
CONFIG_AUDIT_ARCH=y
CONFIG_ARCH_SUPPORTS_OPTIMIZED_INLINING=y
CONFIG_ARCH_SUPPORTS_DEBUG_PAGEALLOC=y
CONFIG_ARCH_HWEIGHT_CFLAGS="-fcall-saved-rdi -fcall-saved-rsi -fcall-saved-rdx -fcall-saved-rcx -fcall-saved-r8 -fcall-saved-r9 -fcall-saved-r10 -fcall-saved-r11"
CONFIG_ARCH_SUPPORTS_UPROBES=y
CONFIG_DEFCONFIG_LIST="/lib/modules/$UNAME_RELEASE/.config"
CONFIG_CONSTRUCTORS=y
CONFIG_IRQ_WORK=y
CONFIG_BUILDTIME_EXTABLE_SORT=y

#
# General setup
#
CONFIG_BROKEN_ON_SMP=y
CONFIG_INIT_ENV_ARG_LIMIT=32
CONFIG_CROSS_COMPILE=""
CONFIG_LOCALVERSION=""
CONFIG_LOCALVERSION_AUTO=y
CONFIG_HAVE_KERNEL_GZIP=y
CONFIG_HAVE_KERNEL_BZIP2=y
CONFIG_HAVE_KERNEL_LZMA=y
CONFIG_HAVE_KERNEL_XZ=y
CONFIG_HAVE_KERNEL_LZO=y
# CONFIG_KERNEL_GZIP is not set
# CONFIG_KERNEL_BZIP2 is not set
# CONFIG_KERNEL_LZMA is not set
CONFIG_KERNEL_XZ=y
# CONFIG_KERNEL_LZO is not set
CONFIG_DEFAULT_HOSTNAME="(none)"
# CONFIG_SYSVIPC is not set
# CONFIG_POSIX_MQUEUE is not set
CONFIG_FHANDLE=y
CONFIG_AUDIT=y
# CONFIG_AUDITSYSCALL is not set
# CONFIG_AUDIT_LOGINUID_IMMUTABLE is not set
CONFIG_HAVE_GENERIC_HARDIRQS=y

#
# IRQ subsystem
#
CONFIG_GENERIC_HARDIRQS=y
CONFIG_GENERIC_IRQ_PROBE=y
CONFIG_GENERIC_IRQ_SHOW=y
CONFIG_IRQ_DOMAIN=y
# CONFIG_IRQ_DOMAIN_DEBUG is not set
CONFIG_IRQ_FORCED_THREADING=y
CONFIG_SPARSE_IRQ=y
CONFIG_CLOCKSOURCE_WATCHDOG=y
CONFIG_ARCH_CLOCKSOURCE_DATA=y
CONFIG_ALWAYS_USE_PERSISTENT_CLOCK=y
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
CONFIG_NO_HZ=y
# CONFIG_HIGH_RES_TIMERS is not set

#
# CPU/Task time and stats accounting
#
CONFIG_VIRT_CPU_ACCOUNTING=y
# CONFIG_TICK_CPU_ACCOUNTING is not set
CONFIG_VIRT_CPU_ACCOUNTING_GEN=y
# CONFIG_IRQ_TIME_ACCOUNTING is not set
# CONFIG_BSD_PROCESS_ACCT is not set
CONFIG_TASKSTATS=y
# CONFIG_TASK_DELAY_ACCT is not set
CONFIG_TASK_XACCT=y
# CONFIG_TASK_IO_ACCOUNTING is not set

#
# RCU Subsystem
#
CONFIG_TINY_RCU=y
# CONFIG_PREEMPT_RCU is not set
CONFIG_RCU_STALL_COMMON=y
CONFIG_CONTEXT_TRACKING=y
# CONFIG_CONTEXT_TRACKING_FORCE is not set
# CONFIG_TREE_RCU_TRACE is not set
CONFIG_IKCONFIG=y
CONFIG_LOG_BUF_SHIFT=17
CONFIG_HAVE_UNSTABLE_SCHED_CLOCK=y
CONFIG_ARCH_SUPPORTS_NUMA_BALANCING=y
CONFIG_ARCH_WANTS_PROT_NUMA_PROT_NONE=y
CONFIG_CGROUPS=y
# CONFIG_CGROUP_DEBUG is not set
# CONFIG_CGROUP_FREEZER is not set
CONFIG_CGROUP_DEVICE=y
# CONFIG_CPUSETS is not set
# CONFIG_CGROUP_CPUACCT is not set
# CONFIG_RESOURCE_COUNTERS is not set
CONFIG_CGROUP_PERF=y
CONFIG_CGROUP_SCHED=y
CONFIG_FAIR_GROUP_SCHED=y
# CONFIG_CFS_BANDWIDTH is not set
CONFIG_RT_GROUP_SCHED=y
CONFIG_CHECKPOINT_RESTORE=y
CONFIG_NAMESPACES=y
# CONFIG_UTS_NS is not set
# CONFIG_USER_NS is not set
CONFIG_PID_NS=y
# CONFIG_NET_NS is not set
CONFIG_UIDGID_CONVERTED=y
CONFIG_UIDGID_STRICT_TYPE_CHECKS=y
CONFIG_SCHED_AUTOGROUP=y
# CONFIG_RELAY is not set
CONFIG_BLK_DEV_INITRD=y
CONFIG_INITRAMFS_SOURCE=""
CONFIG_RD_GZIP=y
CONFIG_RD_BZIP2=y
CONFIG_RD_LZMA=y
CONFIG_RD_XZ=y
CONFIG_RD_LZO=y
# CONFIG_CC_OPTIMIZE_FOR_SIZE is not set
CONFIG_ANON_INODES=y
CONFIG_EXPERT=y
CONFIG_HAVE_UID16=y
# CONFIG_UID16 is not set
CONFIG_SYSCTL_EXCEPTION_TRACE=y
CONFIG_KALLSYMS=y
CONFIG_KALLSYMS_ALL=y
CONFIG_HOTPLUG=y
CONFIG_PRINTK=y
CONFIG_BUG=y
# CONFIG_PCSPKR_PLATFORM is not set
CONFIG_HAVE_PCSPKR_PLATFORM=y
# CONFIG_BASE_FULL is not set
CONFIG_FUTEX=y
CONFIG_EPOLL=y
CONFIG_SIGNALFD=y
CONFIG_TIMERFD=y
CONFIG_EVENTFD=y
CONFIG_SHMEM=y
CONFIG_AIO=y
CONFIG_EMBEDDED=y
CONFIG_HAVE_PERF_EVENTS=y

#
# Kernel Performance Events And Counters
#
CONFIG_PERF_EVENTS=y
# CONFIG_DEBUG_PERF_USE_VMALLOC is not set
CONFIG_VM_EVENT_COUNTERS=y
CONFIG_PCI_QUIRKS=y
# CONFIG_COMPAT_BRK is not set
# CONFIG_SLAB is not set
CONFIG_SLUB=y
# CONFIG_SLOB is not set
CONFIG_PROFILING=y
CONFIG_TRACEPOINTS=y
# CONFIG_OPROFILE is not set
CONFIG_HAVE_OPROFILE=y
CONFIG_OPROFILE_NMI_TIMER=y
# CONFIG_JUMP_LABEL is not set
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
CONFIG_HAVE_ALIGNED_STRUCT_PAGE=y
CONFIG_HAVE_CMPXCHG_LOCAL=y
CONFIG_HAVE_CMPXCHG_DOUBLE=y
CONFIG_ARCH_WANT_COMPAT_IPC_PARSE_VERSION=y
CONFIG_ARCH_WANT_OLD_COMPAT_IPC=y
CONFIG_HAVE_ARCH_SECCOMP_FILTER=y
CONFIG_SECCOMP_FILTER=y
CONFIG_HAVE_CONTEXT_TRACKING=y
CONFIG_HAVE_IRQ_TIME_ACCOUNTING=y
CONFIG_HAVE_ARCH_TRANSPARENT_HUGEPAGE=y
CONFIG_MODULES_USE_ELF_RELA=y
CONFIG_OLD_SIGSUSPEND3=y
CONFIG_COMPAT_OLD_SIGACTION=y

#
# GCOV-based kernel profiling
#
CONFIG_GCOV_KERNEL=y
# CONFIG_GCOV_PROFILE_ALL is not set
# CONFIG_HAVE_GENERIC_DMA_COHERENT is not set
CONFIG_RT_MUTEXES=y
CONFIG_BASE_SMALL=1
# CONFIG_MODULES is not set
# CONFIG_BLOCK is not set
CONFIG_UNINLINE_SPIN_UNLOCK=y
# CONFIG_FREEZER is not set

#
# Processor type and features
#
CONFIG_ZONE_DMA=y
# CONFIG_SMP is not set
CONFIG_X86_MPPARSE=y
CONFIG_X86_EXTENDED_PLATFORM=y
# CONFIG_X86_INTEL_LPSS is not set
# CONFIG_SCHED_OMIT_FRAME_POINTER is not set
CONFIG_PARAVIRT_GUEST=y
# CONFIG_PARAVIRT_TIME_ACCOUNTING is not set
# CONFIG_XEN is not set
# CONFIG_XEN_PRIVILEGED_GUEST is not set
CONFIG_KVM_GUEST=y
CONFIG_PARAVIRT=y
CONFIG_PARAVIRT_CLOCK=y
CONFIG_PARAVIRT_DEBUG=y
CONFIG_NO_BOOTMEM=y
CONFIG_MEMTEST=y
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
CONFIG_PROCESSOR_SELECT=y
CONFIG_CPU_SUP_INTEL=y
# CONFIG_CPU_SUP_AMD is not set
CONFIG_CPU_SUP_CENTAUR=y
CONFIG_HPET_TIMER=y
CONFIG_DMI=y
# CONFIG_CALGARY_IOMMU is not set
CONFIG_SWIOTLB=y
CONFIG_IOMMU_HELPER=y
CONFIG_NR_CPUS=1
CONFIG_PREEMPT_NONE=y
# CONFIG_PREEMPT_VOLUNTARY is not set
# CONFIG_PREEMPT is not set
CONFIG_PREEMPT_COUNT=y
CONFIG_X86_LOCAL_APIC=y
CONFIG_X86_IO_APIC=y
# CONFIG_X86_REROUTE_FOR_BROKEN_BOOT_IRQS is not set
# CONFIG_X86_MCE is not set
CONFIG_I8K=y
CONFIG_MICROCODE=y
CONFIG_MICROCODE_INTEL=y
CONFIG_MICROCODE_AMD=y
CONFIG_MICROCODE_OLD_INTERFACE=y
CONFIG_MICROCODE_INTEL_LIB=y
CONFIG_MICROCODE_INTEL_EARLY=y
CONFIG_MICROCODE_EARLY=y
CONFIG_X86_MSR=y
# CONFIG_X86_CPUID is not set
CONFIG_ARCH_PHYS_ADDR_T_64BIT=y
CONFIG_ARCH_DMA_ADDR_T_64BIT=y
CONFIG_DIRECT_GBPAGES=y
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
# CONFIG_HAVE_BOOTMEM_INFO_NODE is not set
CONFIG_MEMORY_HOTPLUG=y
CONFIG_MEMORY_HOTPLUG_SPARSE=y
# CONFIG_MEMORY_HOTREMOVE is not set
CONFIG_PAGEFLAGS_EXTENDED=y
CONFIG_SPLIT_PTLOCK_CPUS=999999
CONFIG_BALLOON_COMPACTION=y
CONFIG_COMPACTION=y
CONFIG_MIGRATION=y
CONFIG_PHYS_ADDR_T_64BIT=y
CONFIG_ZONE_DMA_FLAG=1
CONFIG_VIRT_TO_BUS=y
CONFIG_KSM=y
CONFIG_DEFAULT_MMAP_MIN_ADDR=4096
CONFIG_TRANSPARENT_HUGEPAGE=y
# CONFIG_TRANSPARENT_HUGEPAGE_ALWAYS is not set
CONFIG_TRANSPARENT_HUGEPAGE_MADVISE=y
CONFIG_CROSS_MEMORY_ATTACH=y
CONFIG_NEED_PER_CPU_KM=y
CONFIG_CLEANCACHE=y
CONFIG_X86_CHECK_BIOS_CORRUPTION=y
# CONFIG_X86_BOOTPARAM_MEMORY_CORRUPTION_CHECK is not set
CONFIG_X86_RESERVE_LOW=64
# CONFIG_MTRR is not set
# CONFIG_ARCH_RANDOM is not set
CONFIG_X86_SMAP=y
# CONFIG_EFI is not set
CONFIG_SECCOMP=y
CONFIG_CC_STACKPROTECTOR=y
# CONFIG_HZ_100 is not set
CONFIG_HZ_250=y
# CONFIG_HZ_300 is not set
# CONFIG_HZ_1000 is not set
CONFIG_HZ=250
# CONFIG_SCHED_HRTICK is not set
CONFIG_KEXEC=y
CONFIG_CRASH_DUMP=y
CONFIG_PHYSICAL_START=0x1000000
CONFIG_RELOCATABLE=y
CONFIG_PHYSICAL_ALIGN=0x1000000
# CONFIG_COMPAT_VDSO is not set
# CONFIG_CMDLINE_BOOL is not set
CONFIG_ARCH_ENABLE_MEMORY_HOTPLUG=y
CONFIG_ARCH_ENABLE_MEMORY_HOTREMOVE=y

#
# Power management and ACPI options
#
# CONFIG_SUSPEND is not set
# CONFIG_PM_RUNTIME is not set
CONFIG_ACPI=y
# CONFIG_ACPI_EC_DEBUGFS is not set
CONFIG_ACPI_AC=y
CONFIG_ACPI_BATTERY=y
CONFIG_ACPI_BUTTON=y
CONFIG_ACPI_FAN=y
# CONFIG_ACPI_DOCK is not set
CONFIG_ACPI_PROCESSOR=y
# CONFIG_ACPI_IPMI is not set
# CONFIG_ACPI_PROCESSOR_AGGREGATOR is not set
CONFIG_ACPI_THERMAL=y
# CONFIG_ACPI_CUSTOM_DSDT is not set
# CONFIG_ACPI_INITRD_TABLE_OVERRIDE is not set
CONFIG_ACPI_BLACKLIST_YEAR=0
# CONFIG_ACPI_DEBUG is not set
CONFIG_X86_PM_TIMER=y
# CONFIG_ACPI_CONTAINER is not set
# CONFIG_ACPI_HOTPLUG_MEMORY is not set
# CONFIG_ACPI_SBS is not set
# CONFIG_ACPI_HED is not set
# CONFIG_ACPI_CUSTOM_METHOD is not set
# CONFIG_ACPI_APEI is not set
# CONFIG_SFI is not set

#
# CPU Frequency scaling
#
# CONFIG_CPU_FREQ is not set
CONFIG_CPU_IDLE=y
CONFIG_CPU_IDLE_MULTIPLE_DRIVERS=y
CONFIG_CPU_IDLE_GOV_LADDER=y
CONFIG_CPU_IDLE_GOV_MENU=y
# CONFIG_ARCH_NEEDS_CPU_IDLE_COUPLED is not set
# CONFIG_INTEL_IDLE is not set

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
CONFIG_ARCH_SUPPORTS_MSI=y
# CONFIG_PCI_MSI is not set
# CONFIG_PCI_DEBUG is not set
# CONFIG_PCI_REALLOC_ENABLE_AUTO is not set
# CONFIG_PCI_STUB is not set
CONFIG_HT_IRQ=y
# CONFIG_PCI_IOV is not set
# CONFIG_PCI_PRI is not set
# CONFIG_PCI_PASID is not set
# CONFIG_PCI_IOAPIC is not set
CONFIG_PCI_LABEL=y
# CONFIG_ISA_DMA_API is not set
# CONFIG_PCCARD is not set
# CONFIG_RAPIDIO is not set

#
# Executable file formats / Emulations
#
CONFIG_BINFMT_ELF=y
CONFIG_COMPAT_BINFMT_ELF=y
CONFIG_ARCH_BINFMT_ELF_RANDOMIZE_PIE=y
# CONFIG_HAVE_AOUT is not set
# CONFIG_BINFMT_MISC is not set
# CONFIG_COREDUMP is not set
CONFIG_IA32_EMULATION=y
# CONFIG_IA32_AOUT is not set
# CONFIG_X86_X32 is not set
CONFIG_COMPAT=y
CONFIG_COMPAT_FOR_U64_ALIGNMENT=y
CONFIG_KEYS_COMPAT=y
CONFIG_HAVE_TEXT_POKE_SMP=y
CONFIG_X86_DEV_DMA_OPS=y
CONFIG_NET=y
CONFIG_COMPAT_NETLINK_MESSAGES=y

#
# Networking options
#
# CONFIG_PACKET is not set
CONFIG_UNIX=y
# CONFIG_UNIX_DIAG is not set
CONFIG_XFRM=y
CONFIG_XFRM_ALGO=y
# CONFIG_XFRM_SUB_POLICY is not set
# CONFIG_XFRM_MIGRATE is not set
CONFIG_NET_KEY=y
# CONFIG_NET_KEY_MIGRATE is not set
# CONFIG_INET is not set
# CONFIG_NETWORK_SECMARK is not set
CONFIG_NETWORK_PHY_TIMESTAMPING=y
CONFIG_NETFILTER=y
# CONFIG_NETFILTER_DEBUG is not set
CONFIG_NETFILTER_ADVANCED=y
CONFIG_NETFILTER_XTABLES=y

#
# DECnet: Netfilter Configuration
#
CONFIG_DECNET_NF_GRABULATOR=y
CONFIG_BRIDGE_NF_EBTABLES=y
# CONFIG_BRIDGE_EBT_BROUTE is not set
# CONFIG_BRIDGE_EBT_T_FILTER is not set
# CONFIG_BRIDGE_EBT_T_NAT is not set
# CONFIG_BRIDGE_EBT_802_3 is not set
CONFIG_BRIDGE_EBT_AMONG=y
CONFIG_BRIDGE_EBT_ARP=y
CONFIG_BRIDGE_EBT_IP=y
CONFIG_BRIDGE_EBT_LIMIT=y
CONFIG_BRIDGE_EBT_MARK=y
# CONFIG_BRIDGE_EBT_PKTTYPE is not set
CONFIG_BRIDGE_EBT_STP=y
CONFIG_BRIDGE_EBT_VLAN=y
CONFIG_BRIDGE_EBT_DNAT=y
CONFIG_BRIDGE_EBT_MARK_T=y
# CONFIG_BRIDGE_EBT_REDIRECT is not set
CONFIG_BRIDGE_EBT_SNAT=y
CONFIG_BRIDGE_EBT_LOG=y
CONFIG_BRIDGE_EBT_ULOG=y
CONFIG_BRIDGE_EBT_NFLOG=y
# CONFIG_ATM is not set
CONFIG_STP=y
CONFIG_BRIDGE=y
CONFIG_HAVE_NET_DSA=y
CONFIG_NET_DSA=y
CONFIG_NET_DSA_TAG_EDSA=y
CONFIG_NET_DSA_TAG_TRAILER=y
# CONFIG_VLAN_8021Q is not set
CONFIG_DECNET=y
CONFIG_DECNET_ROUTER=y
CONFIG_LLC=y
CONFIG_LLC2=y
# CONFIG_IPX is not set
CONFIG_ATALK=y
CONFIG_DEV_APPLETALK=y
CONFIG_IPDDP=y
# CONFIG_IPDDP_ENCAP is not set
# CONFIG_IPDDP_DECAP is not set
CONFIG_X25=y
CONFIG_LAPB=y
CONFIG_PHONET=y
CONFIG_IEEE802154=y
# CONFIG_MAC802154 is not set
CONFIG_NET_SCHED=y

#
# Queueing/Scheduling
#
CONFIG_NET_SCH_CBQ=y
CONFIG_NET_SCH_HTB=y
# CONFIG_NET_SCH_HFSC is not set
CONFIG_NET_SCH_PRIO=y
CONFIG_NET_SCH_MULTIQ=y
# CONFIG_NET_SCH_RED is not set
CONFIG_NET_SCH_SFB=y
CONFIG_NET_SCH_SFQ=y
CONFIG_NET_SCH_TEQL=y
CONFIG_NET_SCH_TBF=y
CONFIG_NET_SCH_GRED=y
CONFIG_NET_SCH_DSMARK=y
# CONFIG_NET_SCH_NETEM is not set
CONFIG_NET_SCH_DRR=y
# CONFIG_NET_SCH_MQPRIO is not set
CONFIG_NET_SCH_CHOKE=y
CONFIG_NET_SCH_QFQ=y
CONFIG_NET_SCH_CODEL=y
CONFIG_NET_SCH_FQ_CODEL=y
CONFIG_NET_SCH_INGRESS=y
# CONFIG_NET_SCH_PLUG is not set

#
# Classification
#
CONFIG_NET_CLS=y
CONFIG_NET_CLS_BASIC=y
CONFIG_NET_CLS_TCINDEX=y
CONFIG_NET_CLS_FW=y
CONFIG_NET_CLS_U32=y
CONFIG_CLS_U32_PERF=y
# CONFIG_CLS_U32_MARK is not set
CONFIG_NET_CLS_RSVP=y
CONFIG_NET_CLS_RSVP6=y
CONFIG_NET_CLS_FLOW=y
CONFIG_NET_CLS_CGROUP=y
# CONFIG_NET_EMATCH is not set
CONFIG_NET_CLS_ACT=y
CONFIG_NET_ACT_POLICE=y
CONFIG_NET_ACT_GACT=y
# CONFIG_GACT_PROB is not set
# CONFIG_NET_ACT_MIRRED is not set
CONFIG_NET_ACT_NAT=y
CONFIG_NET_ACT_PEDIT=y
# CONFIG_NET_ACT_SIMP is not set
# CONFIG_NET_ACT_SKBEDIT is not set
CONFIG_NET_CLS_IND=y
CONFIG_NET_SCH_FIFO=y
CONFIG_DCB=y
CONFIG_DNS_RESOLVER=y
# CONFIG_BATMAN_ADV is not set
# CONFIG_OPENVSWITCH is not set
CONFIG_VSOCKETS=y
CONFIG_NETPRIO_CGROUP=y

#
# Network testing
#
CONFIG_HAMRADIO=y

#
# Packet Radio protocols
#
CONFIG_AX25=y
CONFIG_AX25_DAMA_SLAVE=y
# CONFIG_NETROM is not set
# CONFIG_ROSE is not set

#
# AX.25 network device drivers
#
# CONFIG_MKISS is not set
CONFIG_6PACK=y
CONFIG_BPQETHER=y
CONFIG_BAYCOM_SER_FDX=y
CONFIG_BAYCOM_SER_HDX=y
CONFIG_BAYCOM_PAR=y
CONFIG_YAM=y
# CONFIG_CAN is not set
CONFIG_IRDA=y

#
# IrDA protocols
#
CONFIG_IRLAN=y
# CONFIG_IRNET is not set
CONFIG_IRCOMM=y
# CONFIG_IRDA_ULTRA is not set

#
# IrDA options
#
# CONFIG_IRDA_CACHE_LAST_LSAP is not set
# CONFIG_IRDA_FAST_RR is not set
# CONFIG_IRDA_DEBUG is not set

#
# Infrared-port device drivers
#

#
# SIR device drivers
#
CONFIG_IRTTY_SIR=y

#
# Dongle support
#
# CONFIG_DONGLE is not set

#
# FIR device drivers
#
# CONFIG_VLSI_FIR is not set
# CONFIG_BT is not set
CONFIG_FIB_RULES=y
CONFIG_WIRELESS=y
CONFIG_WIRELESS_EXT=y
CONFIG_WEXT_CORE=y
CONFIG_WEXT_SPY=y
CONFIG_WEXT_PRIV=y
CONFIG_CFG80211=y
# CONFIG_NL80211_TESTMODE is not set
# CONFIG_CFG80211_DEVELOPER_WARNINGS is not set
CONFIG_CFG80211_REG_DEBUG=y
CONFIG_CFG80211_CERTIFICATION_ONUS=y
# CONFIG_CFG80211_DEFAULT_PS is not set
CONFIG_CFG80211_DEBUGFS=y
# CONFIG_CFG80211_INTERNAL_REGDB is not set
# CONFIG_CFG80211_WEXT is not set
CONFIG_LIB80211=y
CONFIG_LIB80211_CRYPT_WEP=y
CONFIG_LIB80211_CRYPT_CCMP=y
CONFIG_LIB80211_CRYPT_TKIP=y
# CONFIG_LIB80211_DEBUG is not set
CONFIG_MAC80211=y
# CONFIG_MAC80211_RC_PID is not set
# CONFIG_MAC80211_RC_MINSTREL is not set
CONFIG_MAC80211_RC_DEFAULT=""

#
# Some wireless drivers require a rate control algorithm
#
# CONFIG_MAC80211_MESH is not set
# CONFIG_MAC80211_DEBUGFS is not set
# CONFIG_MAC80211_MESSAGE_TRACING is not set
CONFIG_MAC80211_DEBUG_MENU=y
CONFIG_MAC80211_NOINLINE=y
# CONFIG_MAC80211_VERBOSE_DEBUG is not set
CONFIG_MAC80211_MLME_DEBUG=y
# CONFIG_MAC80211_STA_DEBUG is not set
# CONFIG_MAC80211_HT_DEBUG is not set
# CONFIG_MAC80211_IBSS_DEBUG is not set
CONFIG_MAC80211_PS_DEBUG=y
# CONFIG_MAC80211_TDLS_DEBUG is not set
CONFIG_WIMAX=y
CONFIG_WIMAX_DEBUG_LEVEL=8
CONFIG_RFKILL=y
CONFIG_RFKILL_INPUT=y
CONFIG_NET_9P=y
# CONFIG_NET_9P_VIRTIO is not set
# CONFIG_NET_9P_DEBUG is not set
# CONFIG_CAIF is not set
CONFIG_NFC=y
CONFIG_NFC_NCI=y
CONFIG_NFC_HCI=y
CONFIG_NFC_SHDLC=y
# CONFIG_NFC_LLCP is not set

#
# Near Field Communication (NFC) devices
#
CONFIG_NFC_PN544=y
# CONFIG_NFC_MICROREAD is not set
CONFIG_HAVE_BPF_JIT=y

#
# Device Drivers
#

#
# Generic Driver Options
#
CONFIG_UEVENT_HELPER_PATH=""
CONFIG_DEVTMPFS=y
CONFIG_DEVTMPFS_MOUNT=y
CONFIG_STANDALONE=y
CONFIG_PREVENT_FIRMWARE_BUILD=y
CONFIG_FW_LOADER=y
CONFIG_FIRMWARE_IN_KERNEL=y
CONFIG_EXTRA_FIRMWARE=""
# CONFIG_FW_LOADER_USER_HELPER is not set
# CONFIG_DEBUG_DRIVER is not set
CONFIG_DEBUG_DEVRES=y
# CONFIG_SYS_HYPERVISOR is not set
# CONFIG_GENERIC_CPU_DEVICES is not set
CONFIG_REGMAP=y
CONFIG_REGMAP_MMIO=y
# CONFIG_DMA_SHARED_BUFFER is not set

#
# Bus devices
#
CONFIG_CONNECTOR=y
CONFIG_PROC_EVENTS=y
# CONFIG_MTD is not set
CONFIG_PARPORT=y
# CONFIG_PARPORT_PC is not set
# CONFIG_PARPORT_GSC is not set
# CONFIG_PARPORT_AX88796 is not set
# CONFIG_PARPORT_1284 is not set
CONFIG_PNP=y
CONFIG_PNP_DEBUG_MESSAGES=y

#
# Protocols
#
CONFIG_PNPACPI=y

#
# Misc devices
#
# CONFIG_SENSORS_LIS3LV02D is not set
# CONFIG_IBM_ASM is not set
# CONFIG_PHANTOM is not set
# CONFIG_INTEL_MID_PTI is not set
# CONFIG_SGI_IOC4 is not set
# CONFIG_TIFM_CORE is not set
# CONFIG_ATMEL_SSC is not set
CONFIG_ENCLOSURE_SERVICES=y
# CONFIG_HP_ILO is not set
CONFIG_VMWARE_BALLOON=y
# CONFIG_PCH_PHUB is not set
# CONFIG_C2PORT is not set

#
# EEPROM support
#
# CONFIG_EEPROM_93CX6 is not set
# CONFIG_CB710_CORE is not set

#
# Texas Instruments shared transport line discipline
#

#
# Altera FPGA firmware download module
#
# CONFIG_INTEL_MEI is not set
# CONFIG_VMWARE_VMCI is not set
CONFIG_HAVE_IDE=y

#
# SCSI device support
#
CONFIG_SCSI_MOD=y
# CONFIG_SCSI_DMA is not set
# CONFIG_SCSI_NETLINK is not set
# CONFIG_FUSION is not set

#
# IEEE 1394 (FireWire) support
#
# CONFIG_FIREWIRE is not set
# CONFIG_FIREWIRE_NOSY is not set
# CONFIG_I2O is not set
CONFIG_MACINTOSH_DRIVERS=y
CONFIG_NETDEVICES=y
# CONFIG_NET_CORE is not set
# CONFIG_ARCNET is not set

#
# CAIF transport drivers
#

#
# Distributed Switch Architecture drivers
#
CONFIG_NET_DSA_MV88E6XXX=y
CONFIG_NET_DSA_MV88E6060=y
# CONFIG_NET_DSA_MV88E6XXX_NEED_PPU is not set
# CONFIG_NET_DSA_MV88E6131 is not set
CONFIG_NET_DSA_MV88E6123_61_65=y
# CONFIG_ETHERNET is not set
# CONFIG_FDDI is not set
# CONFIG_NET_SB1000 is not set
CONFIG_PHYLIB=y

#
# MII PHY device drivers
#
CONFIG_AT803X_PHY=y
CONFIG_AMD_PHY=y
CONFIG_MARVELL_PHY=y
CONFIG_DAVICOM_PHY=y
# CONFIG_QSEMI_PHY is not set
# CONFIG_LXT_PHY is not set
# CONFIG_CICADA_PHY is not set
CONFIG_VITESSE_PHY=y
CONFIG_SMSC_PHY=y
# CONFIG_BROADCOM_PHY is not set
CONFIG_BCM87XX_PHY=y
CONFIG_ICPLUS_PHY=y
# CONFIG_REALTEK_PHY is not set
CONFIG_NATIONAL_PHY=y
# CONFIG_STE10XP is not set
CONFIG_LSI_ET1011C_PHY=y
# CONFIG_MICREL_PHY is not set
# CONFIG_FIXED_PHY is not set
CONFIG_MDIO_BITBANG=y
CONFIG_PLIP=y
CONFIG_PPP=y
CONFIG_PPP_BSDCOMP=y
CONFIG_PPP_DEFLATE=y
CONFIG_PPP_FILTER=y
CONFIG_PPP_MPPE=y
# CONFIG_PPP_MULTILINK is not set
CONFIG_PPPOE=y
CONFIG_PPP_ASYNC=y
CONFIG_PPP_SYNC_TTY=y
CONFIG_SLIP=y
CONFIG_SLHC=y
CONFIG_SLIP_COMPRESSED=y
# CONFIG_SLIP_SMART is not set
CONFIG_SLIP_MODE_SLIP6=y
CONFIG_WLAN=y
# CONFIG_LIBERTAS_THINFIRM is not set
# CONFIG_ATMEL is not set
# CONFIG_PRISM54 is not set
# CONFIG_RTL8180 is not set
# CONFIG_ADM8211 is not set
# CONFIG_MAC80211_HWSIM is not set
# CONFIG_MWL8K is not set
CONFIG_ATH_CARDS=y
# CONFIG_ATH_DEBUG is not set
# CONFIG_ATH5K is not set
# CONFIG_ATH5K_PCI is not set
# CONFIG_ATH9K is not set
CONFIG_ATH6KL=y
CONFIG_ATH6KL_SDIO=y
CONFIG_ATH6KL_DEBUG=y
CONFIG_ATH6KL_REGDOMAIN=y
# CONFIG_WIL6210 is not set
# CONFIG_B43 is not set
CONFIG_B43LEGACY=y
CONFIG_B43LEGACY_PCI_AUTOSELECT=y
CONFIG_B43LEGACY_PCICORE_AUTOSELECT=y
CONFIG_B43LEGACY_DEBUG=y
CONFIG_B43LEGACY_PIO=y
# CONFIG_B43LEGACY_DMA_AND_PIO_MODE is not set
# CONFIG_B43LEGACY_DMA_MODE is not set
CONFIG_B43LEGACY_PIO_MODE=y
CONFIG_BRCMUTIL=y
# CONFIG_BRCMSMAC is not set
CONFIG_BRCMFMAC=y
CONFIG_BRCMFMAC_SDIO=y
# CONFIG_BRCMFMAC_SDIO_OOB is not set
CONFIG_BRCM_TRACING=y
# CONFIG_BRCMDBG is not set
CONFIG_HOSTAP=y
# CONFIG_HOSTAP_FIRMWARE is not set
# CONFIG_HOSTAP_PLX is not set
# CONFIG_HOSTAP_PCI is not set
# CONFIG_IPW2100 is not set
# CONFIG_IWLWIFI is not set
# CONFIG_IWL4965 is not set
# CONFIG_IWL3945 is not set
# CONFIG_LIBERTAS is not set
CONFIG_P54_COMMON=y
# CONFIG_P54_PCI is not set
CONFIG_RT2X00=y
# CONFIG_RT2400PCI is not set
# CONFIG_RT2500PCI is not set
# CONFIG_RT61PCI is not set
# CONFIG_RT2800PCI is not set
CONFIG_RTLWIFI=y
CONFIG_RTLWIFI_DEBUG=y
# CONFIG_RTL8192CE is not set
# CONFIG_RTL8192SE is not set
# CONFIG_RTL8192DE is not set
# CONFIG_RTL8723AE is not set
# CONFIG_WL_TI is not set
CONFIG_MWIFIEX=y
CONFIG_MWIFIEX_SDIO=y
# CONFIG_MWIFIEX_PCIE is not set

#
# WiMAX Wireless Broadband devices
#

#
# Enable USB support to see WiMAX USB drivers
#
CONFIG_WAN=y
# CONFIG_LANMEDIA is not set
CONFIG_HDLC=y
CONFIG_HDLC_RAW=y
# CONFIG_HDLC_RAW_ETH is not set
CONFIG_HDLC_CISCO=y
CONFIG_HDLC_FR=y
CONFIG_HDLC_PPP=y
# CONFIG_HDLC_X25 is not set
# CONFIG_PCI200SYN is not set
# CONFIG_WANXL is not set
# CONFIG_PC300TOO is not set
# CONFIG_FARSYNC is not set
CONFIG_DLCI=y
CONFIG_DLCI_MAX=8
# CONFIG_LAPBETHER is not set
# CONFIG_X25_ASY is not set
# CONFIG_SBNI is not set
# CONFIG_IEEE802154_DRIVERS is not set
# CONFIG_ISDN is not set

#
# Input device support
#
CONFIG_INPUT=y
CONFIG_INPUT_FF_MEMLESS=y
# CONFIG_INPUT_POLLDEV is not set
CONFIG_INPUT_SPARSEKMAP=y
# CONFIG_INPUT_MATRIXKMAP is not set

#
# Userland interfaces
#
# CONFIG_INPUT_MOUSEDEV is not set
CONFIG_INPUT_JOYDEV=y
# CONFIG_INPUT_EVDEV is not set
# CONFIG_INPUT_EVBUG is not set

#
# Input Device Drivers
#
CONFIG_INPUT_KEYBOARD=y
CONFIG_KEYBOARD_ATKBD=y
# CONFIG_KEYBOARD_LKKBD is not set
# CONFIG_KEYBOARD_NEWTON is not set
# CONFIG_KEYBOARD_OPENCORES is not set
# CONFIG_KEYBOARD_STOWAWAY is not set
# CONFIG_KEYBOARD_SUNKBD is not set
# CONFIG_KEYBOARD_XTKBD is not set
# CONFIG_INPUT_MOUSE is not set
# CONFIG_INPUT_JOYSTICK is not set
# CONFIG_INPUT_TABLET is not set
CONFIG_INPUT_TOUCHSCREEN=y
# CONFIG_TOUCHSCREEN_AD7879 is not set
# CONFIG_TOUCHSCREEN_CYTTSP_CORE is not set
CONFIG_TOUCHSCREEN_DYNAPRO=y
# CONFIG_TOUCHSCREEN_HAMPSHIRE is not set
CONFIG_TOUCHSCREEN_FUJITSU=y
CONFIG_TOUCHSCREEN_GUNZE=y
CONFIG_TOUCHSCREEN_ELO=y
CONFIG_TOUCHSCREEN_WACOM_W8001=y
CONFIG_TOUCHSCREEN_MTOUCH=y
CONFIG_TOUCHSCREEN_INEXIO=y
CONFIG_TOUCHSCREEN_MK712=y
CONFIG_TOUCHSCREEN_PENMOUNT=y
CONFIG_TOUCHSCREEN_TOUCHRIGHT=y
CONFIG_TOUCHSCREEN_TOUCHWIN=y
CONFIG_TOUCHSCREEN_TI_AM335X_TSC=y
# CONFIG_TOUCHSCREEN_USB_COMPOSITE is not set
# CONFIG_TOUCHSCREEN_TOUCHIT213 is not set
CONFIG_TOUCHSCREEN_TSC_SERIO=y
# CONFIG_INPUT_MISC is not set

#
# Hardware I/O ports
#
CONFIG_SERIO=y
CONFIG_SERIO_I8042=y
CONFIG_SERIO_SERPORT=y
CONFIG_SERIO_CT82C710=y
CONFIG_SERIO_PARKBD=y
# CONFIG_SERIO_PCIPS2 is not set
CONFIG_SERIO_LIBPS2=y
# CONFIG_SERIO_RAW is not set
# CONFIG_SERIO_ALTERA_PS2 is not set
# CONFIG_SERIO_PS2MULT is not set
# CONFIG_SERIO_ARC_PS2 is not set
CONFIG_GAMEPORT=y
CONFIG_GAMEPORT_NS558=y
CONFIG_GAMEPORT_L4=y
# CONFIG_GAMEPORT_EMU10K1 is not set
# CONFIG_GAMEPORT_FM801 is not set

#
# Character devices
#
CONFIG_TTY=y
# CONFIG_VT is not set
CONFIG_UNIX98_PTYS=y
# CONFIG_DEVPTS_MULTIPLE_INSTANCES is not set
# CONFIG_LEGACY_PTYS is not set
# CONFIG_SERIAL_NONSTANDARD is not set
# CONFIG_NOZOMI is not set
CONFIG_N_GSM=y
# CONFIG_TRACE_SINK is not set
# CONFIG_DEVKMEM is not set

#
# Serial drivers
#
CONFIG_SERIAL_8250=y
CONFIG_SERIAL_8250_PNP=y
CONFIG_SERIAL_8250_CONSOLE=y
CONFIG_FIX_EARLYCON_MEM=y
CONFIG_SERIAL_8250_PCI=y
CONFIG_SERIAL_8250_NR_UARTS=4
CONFIG_SERIAL_8250_RUNTIME_UARTS=4
# CONFIG_SERIAL_8250_EXTENDED is not set
CONFIG_SERIAL_8250_DW=y

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
CONFIG_SERIAL_ALTERA_UART=y
CONFIG_SERIAL_ALTERA_UART_MAXPORTS=4
CONFIG_SERIAL_ALTERA_UART_BAUDRATE=115200
CONFIG_SERIAL_ALTERA_UART_CONSOLE=y
# CONFIG_SERIAL_PCH_UART is not set
CONFIG_SERIAL_ARC=y
# CONFIG_SERIAL_ARC_CONSOLE is not set
CONFIG_SERIAL_ARC_NR_PORTS=1
# CONFIG_SERIAL_RP2 is not set
# CONFIG_TTY_PRINTK is not set
CONFIG_PRINTER=y
# CONFIG_LP_CONSOLE is not set
CONFIG_PPDEV=y
CONFIG_HVC_DRIVER=y
CONFIG_VIRTIO_CONSOLE=y
CONFIG_IPMI_HANDLER=y
CONFIG_IPMI_PANIC_EVENT=y
CONFIG_IPMI_PANIC_STRING=y
# CONFIG_IPMI_DEVICE_INTERFACE is not set
CONFIG_IPMI_SI=y
CONFIG_IPMI_WATCHDOG=y
CONFIG_IPMI_POWEROFF=y
# CONFIG_HW_RANDOM is not set
CONFIG_NVRAM=y
# CONFIG_RTC is not set
# CONFIG_GEN_RTC is not set
CONFIG_R3964=y
# CONFIG_APPLICOM is not set
CONFIG_MWAVE=y
# CONFIG_HPET is not set
CONFIG_HANGCHECK_TIMER=y
CONFIG_TCG_TPM=y
CONFIG_TCG_TIS=y
CONFIG_TCG_NSC=y
CONFIG_TCG_ATMEL=y
# CONFIG_TCG_INFINEON is not set
# CONFIG_TELCLOCK is not set
CONFIG_DEVPORT=y
# CONFIG_I2C is not set
# CONFIG_SPI is not set
# CONFIG_HSI is not set

#
# PPS support
#
CONFIG_PPS=y
# CONFIG_PPS_DEBUG is not set

#
# PPS clients support
#
CONFIG_PPS_CLIENT_KTIMER=y
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
CONFIG_DP83640_PHY=y
CONFIG_PTP_1588_CLOCK_PCH=y
CONFIG_ARCH_WANT_OPTIONAL_GPIOLIB=y
CONFIG_GPIO_DEVRES=y
# CONFIG_GPIOLIB is not set
# CONFIG_W1 is not set
CONFIG_POWER_SUPPLY=y
# CONFIG_POWER_SUPPLY_DEBUG is not set
# CONFIG_PDA_POWER is not set
# CONFIG_GENERIC_ADC_BATTERY is not set
# CONFIG_TEST_POWER is not set
# CONFIG_BATTERY_DS2780 is not set
# CONFIG_BATTERY_DS2781 is not set
# CONFIG_BATTERY_BQ27x00 is not set
# CONFIG_CHARGER_MAX8903 is not set
# CONFIG_BATTERY_GOLDFISH is not set
# CONFIG_POWER_RESET is not set
CONFIG_POWER_AVS=y
CONFIG_HWMON=y
CONFIG_HWMON_VID=y
CONFIG_HWMON_DEBUG_CHIP=y

#
# Native drivers
#
# CONFIG_SENSORS_ABITUGURU is not set
CONFIG_SENSORS_ABITUGURU3=y
# CONFIG_SENSORS_K8TEMP is not set
# CONFIG_SENSORS_K10TEMP is not set
# CONFIG_SENSORS_FAM15H_POWER is not set
# CONFIG_SENSORS_I5K_AMB is not set
CONFIG_SENSORS_F71805F=y
# CONFIG_SENSORS_F71882FG is not set
CONFIG_SENSORS_CORETEMP=y
CONFIG_SENSORS_IBMAEM=y
# CONFIG_SENSORS_IBMPEX is not set
CONFIG_SENSORS_IT87=y
CONFIG_SENSORS_MAX197=y
# CONFIG_SENSORS_NTC_THERMISTOR is not set
CONFIG_SENSORS_PC87360=y
CONFIG_SENSORS_PC87427=y
# CONFIG_SENSORS_SIS5595 is not set
CONFIG_SENSORS_SMSC47M1=y
CONFIG_SENSORS_SMSC47B397=y
CONFIG_SENSORS_SCH56XX_COMMON=y
CONFIG_SENSORS_SCH5627=y
# CONFIG_SENSORS_SCH5636 is not set
CONFIG_SENSORS_VIA_CPUTEMP=y
# CONFIG_SENSORS_VIA686A is not set
CONFIG_SENSORS_VT1211=y
# CONFIG_SENSORS_VT8231 is not set
CONFIG_SENSORS_W83627HF=y
# CONFIG_SENSORS_W83627EHF is not set
# CONFIG_SENSORS_APPLESMC is not set

#
# ACPI drivers
#
# CONFIG_SENSORS_ACPI_POWER is not set
# CONFIG_SENSORS_ATK0110 is not set
CONFIG_THERMAL=y
CONFIG_THERMAL_HWMON=y
# CONFIG_THERMAL_DEFAULT_GOV_STEP_WISE is not set
CONFIG_THERMAL_DEFAULT_GOV_FAIR_SHARE=y
# CONFIG_THERMAL_DEFAULT_GOV_USER_SPACE is not set
CONFIG_THERMAL_GOV_FAIR_SHARE=y
CONFIG_THERMAL_GOV_STEP_WISE=y
# CONFIG_THERMAL_GOV_USER_SPACE is not set
CONFIG_THERMAL_EMULATION=y
CONFIG_INTEL_POWERCLAMP=y
CONFIG_WATCHDOG=y
CONFIG_WATCHDOG_CORE=y
CONFIG_WATCHDOG_NOWAYOUT=y

#
# Watchdog Device Drivers
#
# CONFIG_SOFT_WATCHDOG is not set
CONFIG_ACQUIRE_WDT=y
CONFIG_ADVANTECH_WDT=y
# CONFIG_ALIM1535_WDT is not set
# CONFIG_ALIM7101_WDT is not set
CONFIG_F71808E_WDT=y
# CONFIG_SP5100_TCO is not set
CONFIG_SC520_WDT=y
# CONFIG_SBC_FITPC2_WATCHDOG is not set
# CONFIG_EUROTECH_WDT is not set
# CONFIG_IB700_WDT is not set
CONFIG_IBMASR=y
CONFIG_WAFER_WDT=y
# CONFIG_I6300ESB_WDT is not set
# CONFIG_IE6XX_WDT is not set
# CONFIG_ITCO_WDT is not set
CONFIG_IT8712F_WDT=y
CONFIG_IT87_WDT=y
# CONFIG_HP_WATCHDOG is not set
CONFIG_SC1200_WDT=y
# CONFIG_PC87413_WDT is not set
# CONFIG_NV_TCO is not set
CONFIG_60XX_WDT=y
CONFIG_SBC8360_WDT=y
CONFIG_CPU5_WDT=y
CONFIG_SMSC_SCH311X_WDT=y
CONFIG_SMSC37B787_WDT=y
# CONFIG_VIA_WDT is not set
# CONFIG_W83627HF_WDT is not set
# CONFIG_W83697HF_WDT is not set
# CONFIG_W83697UG_WDT is not set
CONFIG_W83877F_WDT=y
CONFIG_W83977F_WDT=y
CONFIG_MACHZ_WDT=y
CONFIG_SBC_EPX_C3_WATCHDOG=y

#
# PCI-based Watchdog Cards
#
# CONFIG_PCIPCWATCHDOG is not set
# CONFIG_WDTPCI is not set
CONFIG_SSB_POSSIBLE=y

#
# Sonics Silicon Backplane
#
CONFIG_SSB=y
CONFIG_SSB_SPROM=y
CONFIG_SSB_PCIHOST_POSSIBLE=y
CONFIG_SSB_PCIHOST=y
CONFIG_SSB_B43_PCI_BRIDGE=y
CONFIG_SSB_SDIOHOST_POSSIBLE=y
# CONFIG_SSB_SDIOHOST is not set
# CONFIG_SSB_SILENT is not set
# CONFIG_SSB_DEBUG is not set
CONFIG_SSB_DRIVER_PCICORE_POSSIBLE=y
CONFIG_SSB_DRIVER_PCICORE=y
CONFIG_BCMA_POSSIBLE=y

#
# Broadcom specific AMBA
#
CONFIG_BCMA=y
CONFIG_BCMA_HOST_PCI_POSSIBLE=y
# CONFIG_BCMA_HOST_PCI is not set
# CONFIG_BCMA_DRIVER_GMAC_CMN is not set
# CONFIG_BCMA_DEBUG is not set

#
# Multifunction device drivers
#
CONFIG_MFD_CORE=y
CONFIG_MFD_SM501=y
# CONFIG_MFD_RTSX_PCI is not set
CONFIG_MFD_TI_AM335X_TSCADC=y
# CONFIG_HTC_PASIC3 is not set
# CONFIG_MFD_TMIO is not set
CONFIG_ABX500_CORE=y
# CONFIG_MFD_CS5535 is not set
# CONFIG_LPC_SCH is not set
# CONFIG_LPC_ICH is not set
# CONFIG_MFD_RDC321X is not set
# CONFIG_MFD_JANZ_CMODIO is not set
# CONFIG_MFD_VX855 is not set
# CONFIG_REGULATOR is not set
CONFIG_MEDIA_SUPPORT=y

#
# Multimedia core support
#
CONFIG_MEDIA_CAMERA_SUPPORT=y
CONFIG_MEDIA_ANALOG_TV_SUPPORT=y
# CONFIG_MEDIA_DIGITAL_TV_SUPPORT is not set
# CONFIG_MEDIA_RADIO_SUPPORT is not set
CONFIG_MEDIA_RC_SUPPORT=y
# CONFIG_MEDIA_CONTROLLER is not set
CONFIG_VIDEO_DEV=y
CONFIG_VIDEO_V4L2=y
# CONFIG_VIDEO_ADV_DEBUG is not set
# CONFIG_VIDEO_FIXED_MINOR_RANGES is not set
# CONFIG_VIDEO_V4L2_INT_DEVICE is not set

#
# Media drivers
#
CONFIG_RC_CORE=y
CONFIG_RC_MAP=y
CONFIG_RC_DECODERS=y
CONFIG_LIRC=y
CONFIG_IR_LIRC_CODEC=y
CONFIG_IR_NEC_DECODER=y
CONFIG_IR_RC5_DECODER=y
# CONFIG_IR_RC6_DECODER is not set
CONFIG_IR_JVC_DECODER=y
CONFIG_IR_SONY_DECODER=y
CONFIG_IR_RC5_SZ_DECODER=y
CONFIG_IR_SANYO_DECODER=y
CONFIG_IR_MCE_KBD_DECODER=y
# CONFIG_RC_DEVICES is not set
# CONFIG_MEDIA_PCI_SUPPORT is not set
# CONFIG_V4L_PLATFORM_DRIVERS is not set
# CONFIG_V4L_MEM2MEM_DRIVERS is not set
# CONFIG_V4L_TEST_DRIVERS is not set

#
# Supported MMC/SDIO adapters
#
# CONFIG_MEDIA_PARPORT_SUPPORT is not set

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

#
# RDS decoders
#

#
# Video decoders
#

#
# Video and audio decoders
#

#
# Video encoders
#

#
# Camera sensor devices
#

#
# Flash devices
#

#
# Video improvement chips
#

#
# Miscelaneous helper chips
#

#
# Sensors used on soc_camera driver
#

#
# Customize TV tuners
#

#
# Customise DVB Frontends
#

#
# Tools to develop new frontends
#
# CONFIG_DVB_DUMMY_FE is not set

#
# Graphics support
#
# CONFIG_AGP is not set
CONFIG_VGA_ARB=y
CONFIG_VGA_ARB_MAX_GPUS=16
# CONFIG_VGA_SWITCHEROO is not set
# CONFIG_DRM is not set
# CONFIG_VGASTATE is not set
# CONFIG_VIDEO_OUTPUT_CONTROL is not set
# CONFIG_FB is not set
CONFIG_EXYNOS_VIDEO=y
# CONFIG_BACKLIGHT_LCD_SUPPORT is not set
# CONFIG_SOUND is not set

#
# HID support
#
# CONFIG_HID is not set
CONFIG_USB_ARCH_HAS_OHCI=y
CONFIG_USB_ARCH_HAS_EHCI=y
CONFIG_USB_ARCH_HAS_XHCI=y
CONFIG_USB_SUPPORT=y
CONFIG_USB_ARCH_HAS_HCD=y
# CONFIG_USB is not set
# CONFIG_USB_OTG_WHITELIST is not set
# CONFIG_USB_OTG_BLACKLIST_HUB is not set
# CONFIG_USB_HCD_BCMA is not set
# CONFIG_USB_HCD_SSB is not set

#
# NOTE: USB_STORAGE depends on SCSI but BLK_DEV_SD may
#
# CONFIG_OMAP_USB3 is not set
# CONFIG_OMAP_CONTROL_USB is not set
# CONFIG_USB_GADGET is not set

#
# OTG and related infrastructure
#
# CONFIG_UWB is not set
CONFIG_MMC=y
# CONFIG_MMC_DEBUG is not set
# CONFIG_MMC_UNSAFE_RESUME is not set
# CONFIG_MMC_CLKGATE is not set

#
# MMC/SD/SDIO Card Drivers
#
# CONFIG_SDIO_UART is not set
CONFIG_MMC_TEST=y

#
# MMC/SD/SDIO Host Controller Drivers
#
# CONFIG_MMC_SDHCI is not set
# CONFIG_MMC_TIFM_SD is not set
# CONFIG_MMC_CB710 is not set
# CONFIG_MMC_VIA_SDMMC is not set
# CONFIG_MEMSTICK is not set
CONFIG_NEW_LEDS=y
# CONFIG_LEDS_CLASS is not set

#
# LED drivers
#

#
# LED Triggers
#
CONFIG_ACCESSIBILITY=y
# CONFIG_INFINIBAND is not set
# CONFIG_EDAC is not set
# CONFIG_RTC_CLASS is not set
# CONFIG_DMADEVICES is not set
# CONFIG_AUXDISPLAY is not set
CONFIG_UIO=y
# CONFIG_UIO_CIF is not set
CONFIG_UIO_PDRV=y
CONFIG_UIO_PDRV_GENIRQ=y
CONFIG_UIO_DMEM_GENIRQ=y
# CONFIG_UIO_AEC is not set
# CONFIG_UIO_SERCOS3 is not set
# CONFIG_UIO_PCI_GENERIC is not set
# CONFIG_UIO_NETX is not set
CONFIG_VIRTIO=y

#
# Virtio drivers
#
# CONFIG_VIRTIO_PCI is not set
CONFIG_VIRTIO_BALLOON=y
CONFIG_VIRTIO_MMIO=y
# CONFIG_VIRTIO_MMIO_CMDLINE_DEVICES is not set

#
# Microsoft Hyper-V guest support
#
# CONFIG_HYPERV is not set
# CONFIG_STAGING is not set
# CONFIG_X86_PLATFORM_DEVICES is not set

#
# Hardware Spinlock drivers
#
CONFIG_CLKEVT_I8253=y
CONFIG_CLKBLD_I8253=y
CONFIG_MAILBOX=y
# CONFIG_IOMMU_SUPPORT is not set

#
# Remoteproc drivers
#
CONFIG_REMOTEPROC=y
CONFIG_STE_MODEM_RPROC=y

#
# Rpmsg drivers
#
# CONFIG_VIRT_DRIVERS is not set
# CONFIG_PM_DEVFREQ is not set
CONFIG_EXTCON=y

#
# Extcon Device Drivers
#
# CONFIG_EXTCON_ADC_JACK is not set
# CONFIG_MEMORY is not set
CONFIG_IIO=y
# CONFIG_IIO_BUFFER is not set
CONFIG_IIO_TRIGGER=y
CONFIG_IIO_CONSUMERS_PER_TRIGGER=2

#
# Accelerometers
#

#
# Analog to digital converters
#
CONFIG_TI_AM335X_ADC=y

#
# Amplifiers
#

#
# Hid Sensor IIO Common
#

#
# Digital to analog converters
#

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

#
# Inertial measurement units
#

#
# Light sensors
#

#
# Magnetometer sensors
#
# CONFIG_NTB is not set
# CONFIG_VME_BUS is not set
# CONFIG_PWM is not set
CONFIG_IPACK_BUS=y
# CONFIG_BOARD_TPCI200 is not set
CONFIG_SERIAL_IPOCTAL=y

#
# Firmware Drivers
#
CONFIG_EDD=y
# CONFIG_EDD_OFF is not set
# CONFIG_FIRMWARE_MEMMAP is not set
CONFIG_DELL_RBU=y
CONFIG_DCDBAS=y
CONFIG_DMIID=y
# CONFIG_ISCSI_IBFT_FIND is not set
CONFIG_GOOGLE_FIRMWARE=y

#
# Google Firmware Drivers
#
# CONFIG_GOOGLE_SMI is not set
CONFIG_GOOGLE_MEMCONSOLE=y

#
# File systems
#
CONFIG_DCACHE_WORD_ACCESS=y
# CONFIG_FS_POSIX_ACL is not set
CONFIG_EXPORTFS=y
CONFIG_FILE_LOCKING=y
CONFIG_FSNOTIFY=y
# CONFIG_DNOTIFY is not set
# CONFIG_INOTIFY_USER is not set
CONFIG_FANOTIFY=y
# CONFIG_QUOTA is not set
# CONFIG_QUOTACTL is not set
CONFIG_AUTOFS4_FS=y
# CONFIG_FUSE_FS is not set

#
# Caches
#
# CONFIG_FSCACHE is not set

#
# Pseudo filesystems
#
# CONFIG_PROC_FS is not set
# CONFIG_SYSFS is not set
# CONFIG_TMPFS is not set
CONFIG_HUGETLBFS=y
CONFIG_HUGETLB_PAGE=y
# CONFIG_CONFIGFS_FS is not set
CONFIG_MISC_FILESYSTEMS=y
CONFIG_ECRYPT_FS=y
# CONFIG_ECRYPT_FS_MESSAGING is not set
# CONFIG_PSTORE is not set
CONFIG_NETWORK_FILESYSTEMS=y
CONFIG_NLS=y
CONFIG_NLS_DEFAULT="iso8859-1"
CONFIG_NLS_CODEPAGE_437=y
CONFIG_NLS_CODEPAGE_737=y
CONFIG_NLS_CODEPAGE_775=y
# CONFIG_NLS_CODEPAGE_850 is not set
CONFIG_NLS_CODEPAGE_852=y
CONFIG_NLS_CODEPAGE_855=y
CONFIG_NLS_CODEPAGE_857=y
CONFIG_NLS_CODEPAGE_860=y
CONFIG_NLS_CODEPAGE_861=y
CONFIG_NLS_CODEPAGE_862=y
# CONFIG_NLS_CODEPAGE_863 is not set
CONFIG_NLS_CODEPAGE_864=y
CONFIG_NLS_CODEPAGE_865=y
CONFIG_NLS_CODEPAGE_866=y
CONFIG_NLS_CODEPAGE_869=y
# CONFIG_NLS_CODEPAGE_936 is not set
CONFIG_NLS_CODEPAGE_950=y
# CONFIG_NLS_CODEPAGE_932 is not set
CONFIG_NLS_CODEPAGE_949=y
CONFIG_NLS_CODEPAGE_874=y
CONFIG_NLS_ISO8859_8=y
CONFIG_NLS_CODEPAGE_1250=y
CONFIG_NLS_CODEPAGE_1251=y
CONFIG_NLS_ASCII=y
CONFIG_NLS_ISO8859_1=y
CONFIG_NLS_ISO8859_2=y
CONFIG_NLS_ISO8859_3=y
CONFIG_NLS_ISO8859_4=y
CONFIG_NLS_ISO8859_5=y
# CONFIG_NLS_ISO8859_6 is not set
CONFIG_NLS_ISO8859_7=y
CONFIG_NLS_ISO8859_9=y
CONFIG_NLS_ISO8859_13=y
CONFIG_NLS_ISO8859_14=y
CONFIG_NLS_ISO8859_15=y
CONFIG_NLS_KOI8_R=y
# CONFIG_NLS_KOI8_U is not set
CONFIG_NLS_MAC_ROMAN=y
# CONFIG_NLS_MAC_CELTIC is not set
CONFIG_NLS_MAC_CENTEURO=y
# CONFIG_NLS_MAC_CROATIAN is not set
CONFIG_NLS_MAC_CYRILLIC=y
# CONFIG_NLS_MAC_GAELIC is not set
CONFIG_NLS_MAC_GREEK=y
CONFIG_NLS_MAC_ICELAND=y
CONFIG_NLS_MAC_INUIT=y
CONFIG_NLS_MAC_ROMANIAN=y
CONFIG_NLS_MAC_TURKISH=y
# CONFIG_NLS_UTF8 is not set

#
# Kernel hacking
#
CONFIG_TRACE_IRQFLAGS_SUPPORT=y
CONFIG_PRINTK_TIME=y
CONFIG_DEFAULT_MESSAGE_LOGLEVEL=4
# CONFIG_ENABLE_WARN_DEPRECATED is not set
# CONFIG_ENABLE_MUST_CHECK is not set
CONFIG_FRAME_WARN=2048
CONFIG_MAGIC_SYSRQ=y
# CONFIG_STRIP_ASM_SYMS is not set
CONFIG_READABLE_ASM=y
# CONFIG_UNUSED_SYMBOLS is not set
CONFIG_DEBUG_FS=y
# CONFIG_HEADERS_CHECK is not set
# CONFIG_DEBUG_SECTION_MISMATCH is not set
CONFIG_DEBUG_KERNEL=y
CONFIG_DEBUG_SHIRQ=y
# CONFIG_LOCKUP_DETECTOR is not set
CONFIG_PANIC_ON_OOPS=y
CONFIG_PANIC_ON_OOPS_VALUE=1
CONFIG_DETECT_HUNG_TASK=y
CONFIG_DEFAULT_HUNG_TASK_TIMEOUT=120
CONFIG_BOOTPARAM_HUNG_TASK_PANIC=y
CONFIG_BOOTPARAM_HUNG_TASK_PANIC_VALUE=1
CONFIG_DEBUG_OBJECTS=y
CONFIG_DEBUG_OBJECTS_SELFTEST=y
CONFIG_DEBUG_OBJECTS_FREE=y
# CONFIG_DEBUG_OBJECTS_TIMERS is not set
CONFIG_DEBUG_OBJECTS_WORK=y
CONFIG_DEBUG_OBJECTS_RCU_HEAD=y
CONFIG_DEBUG_OBJECTS_PERCPU_COUNTER=y
CONFIG_DEBUG_OBJECTS_ENABLE_DEFAULT=1
CONFIG_HAVE_DEBUG_KMEMLEAK=y
# CONFIG_DEBUG_KMEMLEAK is not set
# CONFIG_DEBUG_RT_MUTEXES is not set
# CONFIG_RT_MUTEX_TESTER is not set
CONFIG_DEBUG_SPINLOCK=y
CONFIG_DEBUG_MUTEXES=y
CONFIG_DEBUG_LOCK_ALLOC=y
CONFIG_PROVE_LOCKING=y
CONFIG_LOCKDEP=y
# CONFIG_LOCK_STAT is not set
CONFIG_DEBUG_LOCKDEP=y
CONFIG_TRACE_IRQFLAGS=y
CONFIG_DEBUG_ATOMIC_SLEEP=y
# CONFIG_DEBUG_LOCKING_API_SELFTESTS is not set
CONFIG_STACKTRACE=y
# CONFIG_DEBUG_STACK_USAGE is not set
# CONFIG_DEBUG_KOBJECT is not set
CONFIG_DEBUG_BUGVERBOSE=y
CONFIG_DEBUG_INFO=y
CONFIG_DEBUG_VM=y
CONFIG_DEBUG_VM_RB=y
CONFIG_DEBUG_VIRTUAL=y
# CONFIG_DEBUG_WRITECOUNT is not set
CONFIG_DEBUG_MEMORY_INIT=y
# CONFIG_DEBUG_LIST is not set
# CONFIG_TEST_LIST_SORT is not set
CONFIG_DEBUG_SG=y
CONFIG_DEBUG_NOTIFIERS=y
CONFIG_DEBUG_CREDENTIALS=y
CONFIG_ARCH_WANT_FRAME_POINTERS=y
CONFIG_FRAME_POINTER=y
CONFIG_BOOT_PRINTK_DELAY=y

#
# RCU Debugging
#
CONFIG_PROVE_RCU=y
CONFIG_PROVE_RCU_REPEATEDLY=y
# CONFIG_SPARSE_RCU_POINTER is not set
# CONFIG_RCU_TORTURE_TEST is not set
CONFIG_RCU_CPU_STALL_TIMEOUT=21
CONFIG_RCU_TRACE=y
# CONFIG_BACKTRACE_SELF_TEST is not set
# CONFIG_DEBUG_FORCE_WEAK_PER_CPU is not set
CONFIG_NOTIFIER_ERROR_INJECTION=y
CONFIG_MEMORY_NOTIFIER_ERROR_INJECT=y
CONFIG_FAULT_INJECTION=y
CONFIG_FAILSLAB=y
CONFIG_FAIL_PAGE_ALLOC=y
CONFIG_FAIL_MMC_REQUEST=y
CONFIG_DEBUG_PAGEALLOC=y
CONFIG_WANT_PAGE_DEBUG_FLAGS=y
CONFIG_PAGE_GUARD=y
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
CONFIG_FUNCTION_TRACER=y
# CONFIG_FUNCTION_GRAPH_TRACER is not set
CONFIG_IRQSOFF_TRACER=y
CONFIG_SCHED_TRACER=y
CONFIG_FTRACE_SYSCALLS=y
CONFIG_TRACER_SNAPSHOT=y
CONFIG_TRACE_BRANCH_PROFILING=y
# CONFIG_BRANCH_PROFILE_NONE is not set
# CONFIG_PROFILE_ANNOTATED_BRANCHES is not set
CONFIG_PROFILE_ALL_BRANCHES=y
CONFIG_TRACING_BRANCHES=y
CONFIG_BRANCH_TRACER=y
CONFIG_STACK_TRACER=y
# CONFIG_UPROBE_EVENT is not set
# CONFIG_PROBE_EVENTS is not set
CONFIG_DYNAMIC_FTRACE=y
CONFIG_DYNAMIC_FTRACE_WITH_REGS=y
# CONFIG_FUNCTION_PROFILER is not set
CONFIG_FTRACE_MCOUNT_RECORD=y
CONFIG_FTRACE_SELFTEST=y
CONFIG_FTRACE_STARTUP_TEST=y
CONFIG_EVENT_TRACE_TEST_SYSCALLS=y
# CONFIG_MMIOTRACE is not set
# CONFIG_RING_BUFFER_BENCHMARK is not set
# CONFIG_PROVIDE_OHCI1394_DMA_INIT is not set
# CONFIG_DYNAMIC_DEBUG is not set
# CONFIG_DMA_API_DEBUG is not set
# CONFIG_ATOMIC64_SELFTEST is not set
# CONFIG_SAMPLES is not set
CONFIG_HAVE_ARCH_KGDB=y
# CONFIG_KGDB is not set
CONFIG_HAVE_ARCH_KMEMCHECK=y
CONFIG_TEST_KSTRTOX=y
CONFIG_STRICT_DEVMEM=y
# CONFIG_X86_VERBOSE_BOOTUP is not set
# CONFIG_EARLY_PRINTK is not set
# CONFIG_DEBUG_STACKOVERFLOW is not set
# CONFIG_X86_PTDUMP is not set
# CONFIG_DEBUG_RODATA is not set
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
CONFIG_CPA_DEBUG=y
# CONFIG_OPTIMIZE_INLINING is not set
CONFIG_DEBUG_NMI_SELFTEST=y

#
# Security options
#
CONFIG_KEYS=y
CONFIG_TRUSTED_KEYS=y
CONFIG_ENCRYPTED_KEYS=y
CONFIG_KEYS_DEBUG_PROC_KEYS=y
# CONFIG_SECURITY_DMESG_RESTRICT is not set
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
CONFIG_CRYPTO_HMAC=y
CONFIG_CRYPTO_XCBC=y
CONFIG_CRYPTO_VMAC=y

#
# Digest
#
CONFIG_CRYPTO_CRC32C=y
# CONFIG_CRYPTO_CRC32C_INTEL is not set
# CONFIG_CRYPTO_CRC32 is not set
CONFIG_CRYPTO_CRC32_PCLMUL=y
CONFIG_CRYPTO_GHASH=y
CONFIG_CRYPTO_MD4=y
CONFIG_CRYPTO_MD5=y
CONFIG_CRYPTO_MICHAEL_MIC=y
# CONFIG_CRYPTO_RMD128 is not set
CONFIG_CRYPTO_RMD160=y
CONFIG_CRYPTO_RMD256=y
# CONFIG_CRYPTO_RMD320 is not set
CONFIG_CRYPTO_SHA1=y
CONFIG_CRYPTO_SHA1_SSSE3=y
CONFIG_CRYPTO_SHA256=y
# CONFIG_CRYPTO_SHA512 is not set
CONFIG_CRYPTO_TGR192=y
# CONFIG_CRYPTO_WP512 is not set
# CONFIG_CRYPTO_GHASH_CLMUL_NI_INTEL is not set

#
# Ciphers
#
CONFIG_CRYPTO_AES=y
CONFIG_CRYPTO_AES_X86_64=y
# CONFIG_CRYPTO_AES_NI_INTEL is not set
CONFIG_CRYPTO_ANUBIS=y
CONFIG_CRYPTO_ARC4=y
CONFIG_CRYPTO_BLOWFISH=y
CONFIG_CRYPTO_BLOWFISH_COMMON=y
# CONFIG_CRYPTO_BLOWFISH_X86_64 is not set
# CONFIG_CRYPTO_CAMELLIA is not set
CONFIG_CRYPTO_CAMELLIA_X86_64=y
CONFIG_CRYPTO_CAMELLIA_AESNI_AVX_X86_64=y
CONFIG_CRYPTO_CAST_COMMON=y
CONFIG_CRYPTO_CAST5=y
CONFIG_CRYPTO_CAST5_AVX_X86_64=y
CONFIG_CRYPTO_CAST6=y
# CONFIG_CRYPTO_CAST6_AVX_X86_64 is not set
CONFIG_CRYPTO_DES=y
CONFIG_CRYPTO_FCRYPT=y
CONFIG_CRYPTO_KHAZAD=y
CONFIG_CRYPTO_SALSA20=y
# CONFIG_CRYPTO_SALSA20_X86_64 is not set
# CONFIG_CRYPTO_SEED is not set
CONFIG_CRYPTO_SERPENT=y
# CONFIG_CRYPTO_SERPENT_SSE2_X86_64 is not set
# CONFIG_CRYPTO_SERPENT_AVX_X86_64 is not set
CONFIG_CRYPTO_TEA=y
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
# CONFIG_CRYPTO_LZO is not set

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
CONFIG_CRYPTO_DEV_PADLOCK_SHA=y
CONFIG_ASYMMETRIC_KEY_TYPE=y
CONFIG_ASYMMETRIC_PUBLIC_KEY_SUBTYPE=y
CONFIG_PUBLIC_KEY_ALGO_RSA=y
# CONFIG_X509_CERTIFICATE_PARSER is not set
CONFIG_HAVE_KVM=y
CONFIG_VIRTUALIZATION=y
CONFIG_VHOST_NET=y
CONFIG_BINARY_PRINTF=y

#
# Library routines
#
CONFIG_BITREVERSE=y
CONFIG_GENERIC_STRNCPY_FROM_USER=y
CONFIG_GENERIC_STRNLEN_USER=y
CONFIG_GENERIC_FIND_FIRST_BIT=y
CONFIG_GENERIC_PCI_IOMAP=y
CONFIG_GENERIC_IOMAP=y
CONFIG_GENERIC_IO=y
CONFIG_CRC_CCITT=y
# CONFIG_CRC16 is not set
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
CONFIG_ZLIB_INFLATE=y
CONFIG_ZLIB_DEFLATE=y
CONFIG_LZO_COMPRESS=y
CONFIG_LZO_DECOMPRESS=y
CONFIG_XZ_DEC=y
# CONFIG_XZ_DEC_X86 is not set
# CONFIG_XZ_DEC_POWERPC is not set
# CONFIG_XZ_DEC_IA64 is not set
# CONFIG_XZ_DEC_ARM is not set
# CONFIG_XZ_DEC_ARMTHUMB is not set
CONFIG_XZ_DEC_SPARC=y
CONFIG_XZ_DEC_BCJ=y
CONFIG_XZ_DEC_TEST=y
CONFIG_DECOMPRESS_GZIP=y
CONFIG_DECOMPRESS_BZIP2=y
CONFIG_DECOMPRESS_LZMA=y
CONFIG_DECOMPRESS_XZ=y
CONFIG_DECOMPRESS_LZO=y
CONFIG_HAS_IOMEM=y
CONFIG_HAS_IOPORT=y
CONFIG_HAS_DMA=y
CONFIG_NLATTR=y
CONFIG_ARCH_HAS_ATOMIC64_DEC_IF_POSITIVE=y
CONFIG_AVERAGE=y
CONFIG_CLZ_TAB=y
CONFIG_CORDIC=y
# CONFIG_DDR is not set
CONFIG_MPILIB=y
# CONFIG_IIO_SIMPLE_DUMMY is not set
# CONFIG_ATA_SFF is not set
# CONFIG_DRM_TTM is not set
# CONFIG_ISDN_DRV_LOOP is not set
# CONFIG_PCI_ATS is not set

--Kj7319i9nmIyA2yE--
