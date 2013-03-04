Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755352Ab3CDFnI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Mar 2013 00:43:08 -0500
Received: from mga11.intel.com ([192.55.52.93]:13505 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755019Ab3CDFnF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Mar 2013 00:43:05 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,777,1355126400"; 
   d="log'?scan'208";a="294336607"
Date: Mon, 4 Mar 2013 13:42:54 +0800
From: Fengguang Wu <fengguang.wu@intel.com>
To: Jan Kara <jack@suse.cz>
Cc: Johannes Weiner <hannes@cmpxchg.org>, linux-kernel@vger.kernel.org
Subject: [printk A-A deadlock] possible reason: unannotated irqs-on
Message-ID: <20130304054254.GA21630@localhost>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="LZvS9be/3tNcYl/X"
Content-Disposition: inline
User-Agent: Heirloom mailx 12.5 6/20/10
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--LZvS9be/3tNcYl/X
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Greetings,

I got the below oops and the first bad commit is

commit 0c2e1aacdc87c3ecf16cf26e8b3476c6203d03e2
Author: Jan Kara <jack@suse.cz>
Date:   Sat Mar 2 00:02:38 2013 +0000

    printk: avoid softlockups in console_unlock()
    
    A CPU can be caught in console_unlock() for a long time (tens of seconds
    are reported by our customers) when other CPUs are using printk heavily
    and serial console makes printing slow.  Despite serial console drivers
    are calling touch_nmi_watchdog() this triggers softlockup warnings because
    interrupts are effectively disabled for the whole time printing takes
    place.  Thus IPIs cannot be processed and other CPUs get stuck spinning in
    calls like smp_call_function_many().  Also RCU eventually starts reporting
    lockups.
    
    In my artifical testing I also managed to trigger a situation when disk
    disappeared from the system apparently because commands to / from it could
    not be delivered for long enough.  This is why just silencing watchdogs
    isn't a reliable solution to the problem.
    
    One part of fixing the issue is changing vprintk_emit() to call
    console_unlock() with interrupts enabled (this isn't perfect as printk()
    itself can be called with interrupts disabled but it improves the
    situation in lots of cases).  Another part is limiting the time we spend
    in console_unlock() printing loop to watchdog_thresh() / 4.  Then we
    release console_sem and wait for watchdog_thresh() / 4 to give a chance to
    other printk() users to get the semaphore and start printing.  If printk()
    was called with interrupts enabled, it also gives CPU a chance to process
    blocked interrupts.  Then we recheck if there's still anything to print,
    try to grab console_sem again and if we succeed, we go on with printing.
    
    Signed-off-by: Jan Kara <jack@suse.cz>
    Cc: "Paul E. McKenney" <paulmck@us.ibm.com>
    Cc: Steven Rostedt <rostedt@goodmis.org>
    Cc: Ingo Molnar <mingo@elte.hu>
    Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
    Cc: Frederic Weisbecker <fweisbec@gmail.com>
    Signed-off-by: Andrew Morton <akpm@linux-foundation.org>

[    0.000000]                      A-A deadlock:possible reason: unannotated irqs-on.
[    0.000000] irq event stamp: 378
[    0.000000] hardirqs last  enabled at (377): [<ffffffff810bb15c>] debug_check_no_locks_freed+0x1f8/0x224
[    0.000000] hardirqs last disabled at (378): [<ffffffff8104ae9c>] vprintk_emit+0xb3/0x88f
[    0.000000] softirqs last  enabled at (0): [<          (null)>]           (null)
[    0.000000] softirqs last disabled at (0): [<          (null)>]           (null)

git bisect start 1eea8bb261e8d43492c91d516d97cf96cdac7a3b 19f949f52599ba7c3f67a5897ac6be14bfcb1200 --
git bisect good 09bca78e81d0ba702b601e09fd887e20c32fc7af  #  1000  2013-03-02 15:21:54  block: restore /proc/partitions to not display non-partitionable removable devices
git bisect good b4a2adc2b273b37274b5a74fc0995927f44fe773  #  1001  2013-03-02 18:55:30  mm/dmapool.c: fix null dev in dma_pool_create()
git bisect  bad 0c2e1aacdc87c3ecf16cf26e8b3476c6203d03e2  #     0  2013-03-02 18:59:08  printk: avoid softlockups in console_unlock()
git bisect good 641feee3e6eeb680efcf5c6f625bb2cb4fcfc52c  #  1000  2013-03-02 22:33:52  early_printk: consolidate random copies of identical code
git bisect good 8a7d64347f4144f2e93745ba971809ca843887ae  #  1002  2013-03-03 02:13:19  include/linux/fs.h: disable preempt when acquire i_size_seqcount write lock
git bisect good 6e1078c01b2e145140e7e8ce341c427b8be1eec3  #  1000  2013-03-03 05:52:33  kernel/smp.c: cleanups
git bisect good 6e1078c01b2e145140e7e8ce341c427b8be1eec3  #  3005  2013-03-03 16:30:52  kernel/smp.c: cleanups
git bisect  bad 67e51ff72caec0de0c3673303c0e7ee935ef80d8  #     0  2013-03-03 16:34:47  add a refcount check in dput()
git bisect good 52efcaa3b551117572315f73c5e787f65c734493  #  3002  2013-03-04 02:57:11  Revert "printk: avoid softlockups in console_unlock()"
git bisect good 106edea2fe051df65a1a6231e9ffa2876cc391cc  #  3001  2013-03-04 13:34:26  Add linux-next specific files for 20130301

Thanks,
Fengguang

--LZvS9be/3tNcYl/X
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="dmesg-kvm-waimea-6943-2013-03-02-09-24-46-3.8.0-mm1-00066-g1eea8bb-252"

[    0.000000] Linux version 3.8.0-mm1-00066-g1eea8bb (kbuild@snb) (gcc version 4.7.2 (Debian 4.7.2-4) ) #252 SMP PREEMPT Sat Mar 2 09:21:27 CST 2013
[    0.000000] Command line: hung_task_panic=1 rcutree.rcu_cpu_stall_timeout=100 branch=mmotm/master log_buf_len=8M ignore_loglevel debug sched_debug apic=debug dynamic_printk sysrq_always_enabled panic=10  prompt_ramdisk=0 console=ttyS0,115200 console=tty0 vga=normal  root=/dev/ram0 rw link=vmlinuz-2013-03-02-09-22-20-mmotm:master:67e51ff72caec0de0c3673303c0e7ee935ef80d8-1eea8bb261e8d43492c91d516d97cf96cdac7a3b-x86_64-randconfig-s007-0225-1-waimea BOOT_IMAGE=/kernel/x86_64-randconfig-s007-0225/1eea8bb261e8d43492c91d516d97cf96cdac7a3b/vmlinuz-3.8.0-mm1-00066-g1eea8bb
[    0.000000] e820: BIOS-provided physical RAM map:
[    0.000000] BIOS-e820: [mem 0x0000000000000000-0x0000000000093bff] usable
[    0.000000] BIOS-e820: [mem 0x0000000000093c00-0x000000000009ffff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000000f0000-0x00000000000fffff] reserved
[    0.000000] BIOS-e820: [mem 0x0000000000100000-0x000000000fffdfff] usable
[    0.000000] BIOS-e820: [mem 0x000000000fffe000-0x000000000fffffff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000feffc000-0x00000000feffffff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000fffc0000-0x00000000ffffffff] reserved
[    0.000000] debug: ignoring loglevel setting.
[    0.000000] NX (Execute Disable) protection: active
[    0.000000] Hypervisor detected: KVM
[    0.000000] e820: update [mem 0x00000000-0x00000fff] usable ==> reserved
[    0.000000] e820: remove [mem 0x000a0000-0x000fffff] usable
[    0.000000] No AGP bridge found
[    0.000000] e820: last_pfn = 0xfffe max_arch_pfn = 0x400000000
[    0.000000] Scan for SMP in [mem 0x00000000-0x000003ff]
[    0.000000] Scan for SMP in [mem 0x0009fc00-0x0009ffff]
[    0.000000] Scan for SMP in [mem 0x000f0000-0x000fffff]
[    0.000000] found SMP MP-table at [mem 0x000fdab0-0x000fdabf] mapped at [ffff8800000fdab0]
[    0.000000]   mpc: fdac0-fdbe4
[    0.000000] Base memory trampoline at [ffff88000008d000] 8d000 size 24576
[    0.000000] init_memory_mapping: [mem 0x00000000-0x000fffff]
[    0.000000]  [mem 0x00000000-0x000fffff] page 4k
[    0.000000] BRK [0x02986000, 0x02986fff] PGTABLE
[    0.000000] BRK [0x02987000, 0x02987fff] PGTABLE
[    0.000000] BRK [0x02988000, 0x02988fff] PGTABLE
[    0.000000] init_memory_mapping: [mem 0x0e800000-0x0e8d5fff]
[    0.000000]  [mem 0x0e800000-0x0e8d5fff] page 4k
[    0.000000] BRK [0x02989000, 0x02989fff] PGTABLE
[    0.000000] init_memory_mapping: [mem 0x0c000000-0x0e7fffff]
[    0.000000]  [mem 0x0c000000-0x0e7fffff] page 4k
[    0.000000] BRK [0x0298a000, 0x0298afff] PGTABLE
[    0.000000] init_memory_mapping: [mem 0x00100000-0x0bffffff]
[    0.000000]  [mem 0x00100000-0x0bffffff] page 4k
[    0.000000] init_memory_mapping: [mem 0x0e8d6000-0x0fffdfff]
[    0.000000]  [mem 0x0e8d6000-0x0fffdfff] page 4k
[    0.000000] log_buf_len: 8388608
[    0.000000] early log buf free: 128104(97%)
[    0.000000] RAMDISK: [mem 0x0e8d6000-0x0ffeffff]
[    0.000000] ACPI: RSDP 00000000000fd920 00014 (v00 BOCHS )
[    0.000000] ACPI: RSDT 000000000fffe550 00038 (v01 BOCHS  BXPCRSDT 00000001 BXPC 00000001)
[    0.000000] ACPI: FACP 000000000fffff80 00074 (v01 BOCHS  BXPCFACP 00000001 BXPC 00000001)
[    0.000000] ACPI: DSDT 000000000fffe590 01121 (v01   BXPC   BXDSDT 00000001 INTL 20100528)
[    0.000000] ACPI: FACS 000000000fffff40 00040
[    0.000000] ACPI: SSDT 000000000ffffe40 000FF (v01 BOCHS  BXPCSSDT 00000001 BXPC 00000001)
[    0.000000] ACPI: APIC 000000000ffffd50 00080 (v01 BOCHS  BXPCAPIC 00000001 BXPC 00000001)
[    0.000000] ACPI: HPET 000000000ffffd10 00038 (v01 BOCHS  BXPCHPET 00000001 BXPC 00000001)
[    0.000000] ACPI: SSDT 000000000ffff6c0 00644 (v01   BXPC BXSSDTPC 00000001 INTL 20100528)
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] mapped APIC to ffffffffff5fa000 (        fee00000)
[    0.000000] No NUMA configuration found
[    0.000000] Faking a node at [mem 0x0000000000000000-0x000000000fffdfff]
[    0.000000] Initmem setup node 0 [mem 0x00000000-0x0fffdfff]
[    0.000000]   NODE_DATA [mem 0x0fff9000-0x0fffdfff]
[    0.000000] kvm-clock: Using msrs 4b564d01 and 4b564d00
[    0.000000] kvm-clock: cpu 0, msr 0:fff8001, boot clock
[    0.000000] Zone ranges:
[    0.000000]   DMA      [mem 0x00001000-0x00ffffff]
[    0.000000]   DMA32    [mem 0x01000000-0xffffffff]
[    0.000000]   Normal   empty
[    0.000000] Movable zone start for each node
[    0.000000] Early memory node ranges
[    0.000000]   node   0: [mem 0x00001000-0x00092fff]
[    0.000000]   node   0: [mem 0x00100000-0x0fffdfff]
[    0.000000] On node 0 totalpages: 65424
[    0.000000]   DMA zone: 64 pages used for memmap
[    0.000000]   DMA zone: 21 pages reserved
[    0.000000]   DMA zone: 3986 pages, LIFO batch:0
[    0.000000]   DMA32 zone: 960 pages used for memmap
[    0.000000]   DMA32 zone: 61438 pages, LIFO batch:15
[    0.000000] ACPI: PM-Timer IO Port: 0xb008
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] mapped APIC to ffffffffff5fa000 (        fee00000)
[    0.000000] ACPI: LAPIC (acpi_id[0x00] lapic_id[0x00] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x01] lapic_id[0x01] enabled)
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0xff] dfl dfl lint[0x1])
[    0.000000] ACPI: IOAPIC (id[0x02] address[0xfec00000] gsi_base[0])
[    0.000000] IOAPIC[0]: apic_id 2, version 17, address 0xfec00000, GSI 0-23
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 00, APIC ID 2, APIC INT 02
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 5 global_irq 5 high level)
[    0.000000] Int: type 0, pol 1, trig 3, bus 00, IRQ 05, APIC ID 2, APIC INT 05
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 high level)
[    0.000000] Int: type 0, pol 1, trig 3, bus 00, IRQ 09, APIC ID 2, APIC INT 09
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 10 global_irq 10 high level)
[    0.000000] Int: type 0, pol 1, trig 3, bus 00, IRQ 0a, APIC ID 2, APIC INT 0a
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 11 global_irq 11 high level)
[    0.000000] Int: type 0, pol 1, trig 3, bus 00, IRQ 0b, APIC ID 2, APIC INT 0b
[    0.000000] ACPI: IRQ0 used by override.
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 01, APIC ID 2, APIC INT 01
[    0.000000] ACPI: IRQ2 used by override.
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 03, APIC ID 2, APIC INT 03
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 04, APIC ID 2, APIC INT 04
[    0.000000] ACPI: IRQ5 used by override.
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 06, APIC ID 2, APIC INT 06
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 07, APIC ID 2, APIC INT 07
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 08, APIC ID 2, APIC INT 08
[    0.000000] ACPI: IRQ9 used by override.
[    0.000000] ACPI: IRQ10 used by override.
[    0.000000] ACPI: IRQ11 used by override.
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 0c, APIC ID 2, APIC INT 0c
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 0d, APIC ID 2, APIC INT 0d
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 0e, APIC ID 2, APIC INT 0e
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 0f, APIC ID 2, APIC INT 0f
[    0.000000] Using ACPI (MADT) for SMP configuration information
[    0.000000] ACPI: HPET id: 0x8086a201 base: 0xfed00000
[    0.000000] smpboot: Allowing 2 CPUs, 0 hotplug CPUs
[    0.000000] mapped IOAPIC to ffffffffff5f9000 (fec00000)
[    0.000000] nr_irqs_gsi: 40
[    0.000000] e820: [mem 0x10000000-0xfeffbfff] available for PCI devices
[    0.000000] Booting paravirtualized kernel on KVM
[    0.000000] setup_percpu: NR_CPUS:8 nr_cpumask_bits:8 nr_cpu_ids:2 nr_node_ids:1
[    0.000000] PERCPU: Embedded 25 pages/cpu @ffff88000dc00000 s77888 r0 d24512 u1048576
[    0.000000] pcpu-alloc: s77888 r0 d24512 u1048576 alloc=1*2097152
[    0.000000] pcpu-alloc: [0] 0 1 
[    0.000000] kvm-clock: cpu 0, msr 0:fff8001, primary cpu clock
[    0.000000] KVM setup async PF for cpu 0
[    0.000000] kvm-stealtime: cpu 0, msr dc0cbc0
[    0.000000] Built 1 zonelists in Node order, mobility grouping on.  Total pages: 64379
[    0.000000] Policy zone: DMA32
[    0.000000] Kernel command line: hung_task_panic=1 rcutree.rcu_cpu_stall_timeout=100 branch=mmotm/master log_buf_len=8M ignore_loglevel debug sched_debug apic=debug dynamic_printk sysrq_always_enabled panic=10  prompt_ramdisk=0 console=ttyS0,115200 console=tty0 vga=normal  root=/dev/ram0 rw link=vmlinuz-2013-03-02-09-22-20-mmotm:master:67e51ff72caec0de0c3673303c0e7ee935ef80d8-1eea8bb261e8d43492c91d516d97cf96cdac7a3b-x86_64-randconfig-s007-0225-1-waimea BOOT_IMAGE=/kernel/x86_64-randconfig-s007-0225/1eea8bb261e8d43492c91d516d97cf96cdac7a3b/vmlinuz-3.8.0-mm1-00066-g1eea8bb
[    0.000000] sysrq: sysrq always enabled.
[    0.000000] PID hash table entries: 1024 (order: 1, 8192 bytes)
[    0.000000] __ex_table already sorted, skipping sort
[    0.000000] Checking aperture...
[    0.000000] No AGP bridge found
[    0.000000] Memory: 198192k/262136k available (5605k kernel code, 440k absent, 63504k reserved, 7083k data, 1032k init)
[    0.000000] SLUB: HWalign=64, Order=0-3, MinObjects=0, CPUs=2, Nodes=1
[    0.000000] Preemptible hierarchical RCU implementation.
[    0.000000] 
[    0.000000] 
[    0.000000] 
[    0.000000] 
[    0.000000] NR_IRQS:4352 nr_irqs:512 16
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
[    0.000000] ------------------------
[    0.000000] | Locking API testsuite:
[    0.000000] ----------------------------------------------------------------------------
[    0.000000]                                  | spin |wlock |rlock |mutex | wsem | rsem |
[    0.000000]   --------------------------------------------------------------------------
[    0.000000]                      A-A deadlock:possible reason: unannotated irqs-on.
[    0.000000] irq event stamp: 378
[    0.000000] hardirqs last  enabled at (377): [<ffffffff810bb15c>] debug_check_no_locks_freed+0x1f8/0x224
[    0.000000] hardirqs last disabled at (378): [<ffffffff8104ae9c>] vprintk_emit+0xb3/0x88f
[    0.000000] softirqs last  enabled at (0): [<          (null)>]           (null)
[    0.000000] softirqs last disabled at (0): [<          (null)>]           (null)
[    0.000000]   ok  |  ok  |  ok  |  ok  |  ok  |  ok  |
[    0.000000]                  A-B-B-A deadlock:possible reason: unannotated irqs-on.
[    0.000000] irq event stamp: 392
[    0.000000] hardirqs last  enabled at (391): [<ffffffff8156b671>] dotest+0x69e/0x6ff
[    0.000000] hardirqs last disabled at (392): [<ffffffff8104ae9c>] vprintk_emit+0xb3/0x88f
[    0.000000] softirqs last  enabled at (0): [<          (null)>]           (null)
[    0.000000] softirqs last disabled at (0): [<          (null)>]           (null)
[    0.000000]   ok  |  ok  |  ok  |  ok  |  ok  |  ok  |
[    0.000000]              A-B-B-C-C-A deadlock:possible reason: unannotated irqs-on.
[    0.000000] irq event stamp: 414
[    0.000000] hardirqs last  enabled at (413): [<ffffffff8156b671>] dotest+0x69e/0x6ff
[    0.000000] hardirqs last disabled at (414): [<ffffffff8104ae9c>] vprintk_emit+0xb3/0x88f
[    0.000000] softirqs last  enabled at (0): [<          (null)>]           (null)
[    0.000000] softirqs last disabled at (0): [<          (null)>]           (null)
[    0.000000]   ok  |  ok  |  ok  |  ok  |  ok  |  ok  |
[    0.000000]              A-B-C-A-B-C deadlock:possible reason: unannotated irqs-on.
[    0.000000] irq event stamp: 444
[    0.000000] hardirqs last  enabled at (443): [<ffffffff8156b671>] dotest+0x69e/0x6ff
[    0.000000] hardirqs last disabled at (444): [<ffffffff8104ae9c>] vprintk_emit+0xb3/0x88f
[    0.000000] softirqs last  enabled at (0): [<          (null)>]           (null)
[    0.000000] softirqs last disabled at (0): [<          (null)>]           (null)
[    0.000000]   ok  |  ok  |  ok  |  ok  |  ok  |  ok  |
[    0.000000]          A-B-B-C-C-D-D-A deadlock:possible reason: unannotated irqs-on.
[    0.000000] irq event stamp: 474
[    0.000000] hardirqs last  enabled at (473): [<ffffffff8156b671>] dotest+0x69e/0x6ff
[    0.000000] hardirqs last disabled at (474): [<ffffffff8104ae9c>] vprintk_emit+0xb3/0x88f
[    0.000000] softirqs last  enabled at (0): [<          (null)>]           (null)
[    0.000000] softirqs last disabled at (0): [<          (null)>]           (null)
[    0.000000]   ok  |  ok  |  ok  |  ok  |  ok  |  ok  |
[    0.000000]          A-B-C-D-B-D-D-A deadlock:possible reason: unannotated irqs-on.
[    0.000000] irq event stamp: 512
[    0.000000] hardirqs last  enabled at (511): [<ffffffff8156b671>] dotest+0x69e/0x6ff
[    0.000000] hardirqs last disabled at (512): [<ffffffff8104ae9c>] vprintk_emit+0xb3/0x88f
[    0.000000] softirqs last  enabled at (0): [<          (null)>]           (null)
[    0.000000] softirqs last disabled at (0): [<          (null)>]           (null)
[    0.000000]   ok  |  ok  |  ok  |  ok  |  ok  |  ok  |
[    0.000000]          A-B-C-D-B-C-D-A deadlock:possible reason: unannotated irqs-on.
[    0.000000] irq event stamp: 550
[    0.000000] hardirqs last  enabled at (549): [<ffffffff8156b671>] dotest+0x69e/0x6ff
[    0.000000] hardirqs last disabled at (550): [<ffffffff8104ae9c>] vprintk_emit+0xb3/0x88f
[    0.000000] softirqs last  enabled at (0): [<          (null)>]           (null)
[    0.000000] softirqs last disabled at (0): [<          (null)>]           (null)
[    0.000000]   ok  |  ok  |  ok  |  ok  |  ok  |  ok  |
[    0.000000]                     double unlock:possible reason: unannotated irqs-on.
[    0.000000] irq event stamp: 588
[    0.000000] hardirqs last  enabled at (587): [<ffffffff8156b671>] dotest+0x69e/0x6ff
[    0.000000] hardirqs last disabled at (588): [<ffffffff8104ae9c>] vprintk_emit+0xb3/0x88f
[    0.000000] softirqs last  enabled at (0): [<          (null)>]           (null)
[    0.000000] softirqs last disabled at (0): [<          (null)>]           (null)
[    0.000000]   ok  |  ok  |  ok  |  ok  |  ok  |  ok  |
[    0.000000]                   initialize held:possible reason: unannotated irqs-on.
[    0.000000] irq event stamp: 604
[    0.000000] hardirqs last  enabled at (603): [<ffffffff8156b671>] dotest+0x69e/0x6ff
[    0.000000] hardirqs last disabled at (604): [<ffffffff8104ae9c>] vprintk_emit+0xb3/0x88f
[    0.000000] softirqs last  enabled at (0): [<          (null)>]           (null)
[    0.000000] softirqs last disabled at (0): [<          (null)>]           (null)
[    0.000000]   ok  |  ok  |  ok  |  ok  |  ok  |  ok  |
[    0.000000]                  bad unlock order:possible reason: unannotated irqs-on.
[    0.000000] irq event stamp: 620
[    0.000000] hardirqs last  enabled at (619): [<ffffffff8156b671>] dotest+0x69e/0x6ff
[    0.000000] hardirqs last disabled at (620): [<ffffffff8104ae9c>] vprintk_emit+0xb3/0x88f
[    0.000000] softirqs last  enabled at (0): [<          (null)>]           (null)
[    0.000000] softirqs last disabled at (0): [<          (null)>]           (null)
[    0.000000] FAILED|Pid: 0, comm: swapper/0 Not tainted 3.8.0-mm1-00066-g1eea8bb #252
[    0.000000] Call Trace:
[    0.000000]  [<ffffffff8156b08f>] dotest+0xbc/0x6ff
[    0.000000]  [<ffffffff8124b5fe>] locking_selftest+0x862/0x2744
[    0.000000]  [<ffffffff81c7d0c8>] start_kernel+0x44b/0x72b
[    0.000000]  [<ffffffff81c7c8b1>] ? repair_env_string+0x7d/0x7d
[    0.000000]  [<ffffffff81c7c54a>] x86_64_start_reservations+0x46/0x4f
[    0.000000]  [<ffffffff81c7c678>] x86_64_start_kernel+0x125/0x139
[    0.000000]   ok  |  ok  |  ok  |  ok  |  ok  |
[    0.000000]   --------------------------------------------------------------------------
[    0.000000]               recursive read-lock:             |possible reason: unannotated irqs-on.
[    0.000000] irq event stamp: 640
[    0.000000] hardirqs last  enabled at (639): [<ffffffff8156b671>] dotest+0x69e/0x6ff
[    0.000000] hardirqs last disabled at (640): [<ffffffff8104ae9c>] vprintk_emit+0xb3/0x88f
[    0.000000] softirqs last  enabled at (0): [<          (null)>]           (null)
[    0.000000] softirqs last disabled at (0): [<          (null)>]           (null)
[    0.000000] FAILED|Pid: 0, comm: swapper/0 Not tainted 3.8.0-mm1-00066-g1eea8bb #252
[    0.000000] Call Trace:
[    0.000000]  [<ffffffff8156b08f>] dotest+0xbc/0x6ff
[    0.000000]  [<ffffffff8124b707>] locking_selftest+0x96b/0x2744
[    0.000000]  [<ffffffff81c7d0c8>] start_kernel+0x44b/0x72b
[    0.000000]  [<ffffffff81c7c8b1>] ? repair_env_string+0x7d/0x7d
[    0.000000]  [<ffffffff81c7c54a>] x86_64_start_reservations+0x46/0x4f
[    0.000000]  [<ffffffff81c7c678>] x86_64_start_kernel+0x125/0x139
[    0.000000]              |possible reason: unannotated irqs-on.
[    0.000000] irq event stamp: 642
[    0.000000] hardirqs last  enabled at (641): [<ffffffff8156b671>] dotest+0x69e/0x6ff
[    0.000000] hardirqs last disabled at (642): [<ffffffff8104ae9c>] vprintk_emit+0xb3/0x88f
[    0.000000] softirqs last  enabled at (0): [<          (null)>]           (null)
[    0.000000] softirqs last disabled at (0): [<          (null)>]           (null)
[    0.000000]   ok  |
[    0.000000]            recursive read-lock #2:             |possible reason: unannotated irqs-on.
[    0.000000] irq event stamp: 644
[    0.000000] hardirqs last  enabled at (643): [<ffffffff8156b671>] dotest+0x69e/0x6ff
[    0.000000] hardirqs last disabled at (644): [<ffffffff8104ae9c>] vprintk_emit+0xb3/0x88f
[    0.000000] softirqs last  enabled at (0): [<          (null)>]           (null)
[    0.000000] softirqs last disabled at (0): [<          (null)>]           (null)
[    0.000000] FAILED|Pid: 0, comm: swapper/0 Not tainted 3.8.0-mm1-00066-g1eea8bb #252
[    0.000000] Call Trace:
[    0.000000]  [<ffffffff8156b08f>] dotest+0xbc/0x6ff
[    0.000000]  [<ffffffff8124b799>] locking_selftest+0x9fd/0x2744
[    0.000000]  [<ffffffff81c7d0c8>] start_kernel+0x44b/0x72b
[    0.000000]  [<ffffffff81c7c8b1>] ? repair_env_string+0x7d/0x7d
[    0.000000]  [<ffffffff81c7c54a>] x86_64_start_reservations+0x46/0x4f
[    0.000000]  [<ffffffff81c7c678>] x86_64_start_kernel+0x125/0x139
[    0.000000]              |possible reason: unannotated irqs-on.
[    0.000000] irq event stamp: 646
[    0.000000] hardirqs last  enabled at (645): [<ffffffff8156b671>] dotest+0x69e/0x6ff
[    0.000000] hardirqs last disabled at (646): [<ffffffff8104ae9c>] vprintk_emit+0xb3/0x88f
[    0.000000] softirqs last  enabled at (0): [<          (null)>]           (null)
[    0.000000] softirqs last disabled at (0): [<          (null)>]           (null)
[    0.000000]   ok  |
[    0.000000]             mixed read-write-lock:             |possible reason: unannotated irqs-on.
[    0.000000] irq event stamp: 648
[    0.000000] hardirqs last  enabled at (647): [<ffffffff8156b671>] dotest+0x69e/0x6ff
[    0.000000] hardirqs last disabled at (648): [<ffffffff8104ae9c>] vprintk_emit+0xb3/0x88f
[    0.000000] softirqs last  enabled at (0): [<          (null)>]           (null)
[    0.000000] softirqs last disabled at (0): [<          (null)>]           (null)
[    0.000000]   ok  |             |possible reason: unannotated irqs-on.
[    0.000000] irq event stamp: 650
[    0.000000] hardirqs last  enabled at (649): [<ffffffff8156b671>] dotest+0x69e/0x6ff
[    0.000000] hardirqs last disabled at (650): [<ffffffff8104ae9c>] vprintk_emit+0xb3/0x88f
[    0.000000] softirqs last  enabled at (0): [<          (null)>]           (null)
[    0.000000] softirqs last disabled at (0): [<          (null)>]           (null)
[    0.000000]   ok  |
[    0.000000]             mixed write-read-lock:             |possible reason: unannotated irqs-on.
[    0.000000] irq event stamp: 652
[    0.000000] hardirqs last  enabled at (651): [<ffffffff8156b671>] dotest+0x69e/0x6ff
[    0.000000] hardirqs last disabled at (652): [<ffffffff8104ae9c>] vprintk_emit+0xb3/0x88f
[    0.000000] softirqs last  enabled at (0): [<          (null)>]           (null)
[    0.000000] softirqs last disabled at (0): [<          (null)>]           (null)
[    0.000000]   ok  |             |possible reason: unannotated irqs-on.
[    0.000000] irq event stamp: 654
[    0.000000] hardirqs last  enabled at (653): [<ffffffff8156b671>] dotest+0x69e/0x6ff
[    0.000000] hardirqs last disabled at (654): [<ffffffff8104ae9c>] vprintk_emit+0xb3/0x88f
[    0.000000] softirqs last  enabled at (0): [<          (null)>]           (null)
[    0.000000] softirqs last disabled at (0): [<          (null)>]           (null)
[    0.000000]   ok  |
[    0.000000]   --------------------------------------------------------------------------
[    0.000000]      hard-irqs-on + irq-safe-A/12:  ok  |  ok  |  ok  |
[    0.000000]      soft-irqs-on + irq-safe-A/12:  ok  |  ok  |  ok  |
[    0.000000]      hard-irqs-on + irq-safe-A/21:possible reason: unannotated irqs-on.
[    0.000000] irq event stamp: 692
[    0.000000] hardirqs last  enabled at (691): [<ffffffff8156b671>] dotest+0x69e/0x6ff
[    0.000000] hardirqs last disabled at (692): [<ffffffff8104ae9c>] vprintk_emit+0xb3/0x88f
[    0.000000] softirqs last  enabled at (688): [<ffffffff8123cc4c>] irqsafe1_soft_rlock_12+0x10b/0x13d
[    0.000000] softirqs last disabled at (684): [<ffffffff8123cb54>] irqsafe1_soft_rlock_12+0x13/0x13d
[    0.000000]   ok  |  ok  |  ok  |
[    0.000000]      soft-irqs-on + irq-safe-A/21:possible reason: unannotated irqs-on.
[    0.000000] irq event stamp: 700
[    0.000000] hardirqs last  enabled at (699): [<ffffffff8156b671>] dotest+0x69e/0x6ff
[    0.000000] hardirqs last disabled at (700): [<ffffffff8104ae9c>] vprintk_emit+0xb3/0x88f
[    0.000000] softirqs last  enabled at (688): [<ffffffff8123cc4c>] irqsafe1_soft_rlock_12+0x10b/0x13d
[    0.000000] softirqs last disabled at (684): [<ffffffff8123cb54>] irqsafe1_soft_rlock_12+0x13/0x13d
[    0.000000]   ok  |  ok  |  ok  |
[    0.000000]        sirq-safe-A => hirqs-on/12:  ok  |  ok  |  ok  |
[    0.000000]        sirq-safe-A => hirqs-on/21:  ok  |  ok  |  ok  |
[    0.000000]          hard-safe-A + irqs-on/12:  ok  |  ok  |  ok  |
[    0.000000]          soft-safe-A + irqs-on/12:  ok  |  ok  |  ok  |
[    0.000000]          hard-safe-A + irqs-on/21:  ok  |  ok  |  ok  |
[    0.000000]          soft-safe-A + irqs-on/21:possible reason: unannotated irqs-on.
[    0.000000] irq event stamp: 826
[    0.000000] hardirqs last  enabled at (824): [<ffffffff8156b671>] dotest+0x69e/0x6ff
[    0.000000] hardirqs last disabled at (825): [<ffffffff8104ae9c>] vprintk_emit+0xb3/0x88f
[    0.000000] softirqs last  enabled at (807): [<ffffffff8123c177>] irqsafe2B_soft_rlock_12+0x136/0x155
[    0.000000] softirqs last disabled at (826): [<ffffffff8123c1a9>] irqsafe2B_soft_spin_21+0x13/0x155
[    0.000000]   ok  |  ok  |  ok  |
[    0.000000]     hard-safe-A + unsafe-B #1/123:possible reason: unannotated irqs-on.
[    0.000000] irq event stamp: 847
[    0.000000] hardirqs last  enabled at (846): [<ffffffff8156b671>] dotest+0x69e/0x6ff
[    0.000000] hardirqs last disabled at (847): [<ffffffff8104ae9c>] vprintk_emit+0xb3/0x88f
[    0.000000] softirqs last  enabled at (843): [<ffffffff8123c035>] irqsafe2B_soft_rlock_21+0x149/0x155
[    0.000000] softirqs last disabled at (839): [<ffffffff8123bf3d>] irqsafe2B_soft_rlock_21+0x51/0x155
[    0.000000]   ok  |  ok  |  ok  |
[    0.000000]     soft-safe-A + unsafe-B #1/123:possible reason: unannotated irqs-on.
[    0.000000] irq event stamp: 855
[    0.000000] hardirqs last  enabled at (854): [<ffffffff8156b671>] dotest+0x69e/0x6ff
[    0.000000] hardirqs last disabled at (855): [<ffffffff8104ae9c>] vprintk_emit+0xb3/0x88f
[    0.000000] softirqs last  enabled at (843): [<ffffffff8123c035>] irqsafe2B_soft_rlock_21+0x149/0x155
[    0.000000] softirqs last disabled at (839): [<ffffffff8123bf3d>] irqsafe2B_soft_rlock_21+0x51/0x155
[    0.000000]   ok  |  ok  |  ok  |
[    0.000000]     hard-safe-A + unsafe-B #1/132:possible reason: unannotated irqs-on.
[    0.000000] irq event stamp: 868
[    0.000000] hardirqs last  enabled at (867): [<ffffffff8156b671>] dotest+0x69e/0x6ff
[    0.000000] hardirqs last disabled at (868): [<ffffffff8104ae9c>] vprintk_emit+0xb3/0x88f
[    0.000000] softirqs last  enabled at (864): [<ffffffff8123b5aa>] irqsafe3_soft_rlock_123+0x17d/0x189
[    0.000000] softirqs last disabled at (860): [<ffffffff8123b4b2>] irqsafe3_soft_rlock_123+0x85/0x189
[    0.000000]   ok  |  ok  |  ok  |
[    0.000000]     soft-safe-A + unsafe-B #1/132:possible reason: unannotated irqs-on.
[    0.000000] irq event stamp: 876
[    0.000000] hardirqs last  enabled at (875): [<ffffffff8156b671>] dotest+0x69e/0x6ff
[    0.000000] hardirqs last disabled at (876): [<ffffffff8104ae9c>] vprintk_emit+0xb3/0x88f
[    0.000000] softirqs last  enabled at (864): [<ffffffff8123b5aa>] irqsafe3_soft_rlock_123+0x17d/0x189
[    0.000000] softirqs last disabled at (860): [<ffffffff8123b4b2>] irqsafe3_soft_rlock_123+0x85/0x189
[    0.000000]   ok  |  ok  |  ok  |
[    0.000000]     hard-safe-A + unsafe-B #1/213:possible reason: unannotated irqs-on.
[    0.000000] irq event stamp: 889
[    0.000000] hardirqs last  enabled at (888): [<ffffffff8156b671>] dotest+0x69e/0x6ff
[    0.000000] hardirqs last disabled at (889): [<ffffffff8104ae9c>] vprintk_emit+0xb3/0x88f
[    0.000000] softirqs last  enabled at (885): [<ffffffff8123b3fb>] irqsafe3_soft_rlock_132+0x157/0x189
[    0.000000] softirqs last disabled at (881): [<ffffffff8123b303>] irqsafe3_soft_rlock_132+0x5f/0x189
[    0.000000]   ok  |  ok  |  ok  |
[    0.000000]     soft-safe-A + unsafe-B #1/213:possible reason: unannotated irqs-on.
[    0.000000] irq event stamp: 897
[    0.000000] hardirqs last  enabled at (896): [<ffffffff8156b671>] dotest+0x69e/0x6ff
[    0.000000] hardirqs last disabled at (897): [<ffffffff8104ae9c>] vprintk_emit+0xb3/0x88f
[    0.000000] softirqs last  enabled at (885): [<ffffffff8123b3fb>] irqsafe3_soft_rlock_132+0x157/0x189
[    0.000000] softirqs last disabled at (881): [<ffffffff8123b303>] irqsafe3_soft_rlock_132+0x5f/0x189
[    0.000000]   ok  |  ok  |  ok  |
[    0.000000]     hard-safe-A + unsafe-B #1/231:possible reason: unannotated irqs-on.
[    0.000000] irq event stamp: 910
[    0.000000] hardirqs last  enabled at (909): [<ffffffff8156b671>] dotest+0x69e/0x6ff
[    0.000000] hardirqs last disabled at (910): [<ffffffff8104ae9c>] vprintk_emit+0xb3/0x88f
[    0.000000] softirqs last  enabled at (906): [<ffffffff8123b298>] irqsafe3_soft_rlock_213+0x17d/0x189
[    0.000000] softirqs last disabled at (902): [<ffffffff8123b1a0>] irqsafe3_soft_rlock_213+0x85/0x189
[    0.000000]   ok  |  ok  |  ok  |
[    0.000000]     soft-safe-A + unsafe-B #1/231:possible reason: unannotated irqs-on.
[    0.000000] irq event stamp: 920
[    0.000000] hardirqs last  enabled at (919): [<ffffffff8156b671>] dotest+0x69e/0x6ff
[    0.000000] hardirqs last disabled at (920): [<ffffffff8104ae9c>] vprintk_emit+0xb3/0x88f
[    0.000000] softirqs last  enabled at (906): [<ffffffff8123b298>] irqsafe3_soft_rlock_213+0x17d/0x189
[    0.000000] softirqs last disabled at (902): [<ffffffff8123b1a0>] irqsafe3_soft_rlock_213+0x85/0x189
[    0.000000]   ok  |  ok  |  ok  |
[    0.000000]     hard-safe-A + unsafe-B #1/312:  ok  |  ok  |  ok  |
[    0.000000]     soft-safe-A + unsafe-B #1/312:  ok  |  ok  |  ok  |
[    0.000000]     hard-safe-A + unsafe-B #1/321:  ok  |  ok  |  ok  |
[    0.000000]     soft-safe-A + unsafe-B #1/321:  ok  |  ok  |  ok  |
[    0.000000]     hard-safe-A + unsafe-B #2/123:  ok  |  ok  |  ok  |
[    0.000000]     soft-safe-A + unsafe-B #2/123:possible reason: unannotated irqs-on.
[    0.000000] irq event stamp: 1025
[    0.000000] hardirqs last  enabled at (1023): [<ffffffff8156b671>] dotest+0x69e/0x6ff
[    0.000000] hardirqs last disabled at (1024): [<ffffffff8104ae9c>] vprintk_emit+0xb3/0x88f
[    0.000000] softirqs last  enabled at (1006): [<ffffffff8123ad8b>] irqsafe3_soft_rlock_321+0x10b/0x189
[    0.000000] softirqs last disabled at (1025): [<ffffffff8123aaf2>] irqsafe4_soft_spin_123+0x13/0x1a1
[    0.000000]   ok  |  ok  |  ok  |
[    0.000000]     hard-safe-A + unsafe-B #2/132:  ok  |  ok  |  ok  |
[    0.000000]     soft-safe-A + unsafe-B #2/132:possible reason: unannotated irqs-on.
[    0.000000] irq event stamp: 1065
[    0.000000] hardirqs last  enabled at (1063): [<ffffffff8156b671>] dotest+0x69e/0x6ff
[    0.000000] hardirqs last disabled at (1064): [<ffffffff8104ae9c>] vprintk_emit+0xb3/0x88f
[    0.000000] softirqs last  enabled at (1042): [<ffffffff8123a2ae>] irqsafe4_soft_rlock_123+0x195/0x1a1
[    0.000000] softirqs last disabled at (1065): [<ffffffff8123a951>] irqsafe4_soft_spin_132+0x13/0x1a1
[    0.000000]   ok  |  ok  |  ok  |
[    0.000000]     hard-safe-A + unsafe-B #2/213:possible reason: unannotated irqs-on.
[    0.000000] irq event stamp: 1091
[    0.000000] hardirqs last  enabled at (1090): [<ffffffff8156b671>] dotest+0x69e/0x6ff
[    0.000000] hardirqs last disabled at (1091): [<ffffffff8104ae9c>] vprintk_emit+0xb3/0x88f
[    0.000000] softirqs last  enabled at (1087): [<ffffffff8123a0e7>] irqsafe4_soft_rlock_132+0x16f/0x1a1
[    0.000000] softirqs last disabled at (1083): [<ffffffff81239fef>] irqsafe4_soft_rlock_132+0x77/0x1a1
[    0.000000]   ok  |  ok  |  ok  |
[    0.000000]     soft-safe-A + unsafe-B #2/213:possible reason: unannotated irqs-on.
[    0.000000] irq event stamp: 1103
[    0.000000] hardirqs last  enabled at (1102): [<ffffffff8156b671>] dotest+0x69e/0x6ff
[    0.000000] hardirqs last disabled at (1103): [<ffffffff8104ae9c>] vprintk_emit+0xb3/0x88f
[    0.000000] softirqs last  enabled at (1087): [<ffffffff8123a0e7>] irqsafe4_soft_rlock_132+0x16f/0x1a1
[    0.000000] softirqs last disabled at (1083): [<ffffffff81239fef>] irqsafe4_soft_rlock_132+0x77/0x1a1
[    0.000000]   ok  |  ok  |  ok  |
[    0.000000]     hard-safe-A + unsafe-B #2/231:possible reason: unannotated irqs-on.
[    0.000000] irq event stamp: 1124
[    0.000000] hardirqs last  enabled at (1123): [<ffffffff8156b671>] dotest+0x69e/0x6ff
[    0.000000] hardirqs last disabled at (1124): [<ffffffff8104ae9c>] vprintk_emit+0xb3/0x88f
[    0.000000] softirqs last  enabled at (1120): [<ffffffff81239f6c>] irqsafe4_soft_rlock_213+0x195/0x1a1
[    0.000000] softirqs last disabled at (1116): [<ffffffff81239e74>] irqsafe4_soft_rlock_213+0x9d/0x1a1
[    0.000000]   ok  |  ok  |  ok  |
[    0.000000]     soft-safe-A + unsafe-B #2/231:possible reason: unannotated irqs-on.
[    0.000000] irq event stamp: 1136
[    0.000000] hardirqs last  enabled at (1135): [<ffffffff8156b671>] dotest+0x69e/0x6ff
[    0.000000] hardirqs last disabled at (1136): [<ffffffff8104ae9c>] vprintk_emit+0xb3/0x88f
[    0.000000] softirqs last  enabled at (1120): [<ffffffff81239f6c>] irqsafe4_soft_rlock_213+0x195/0x1a1
[    0.000000] softirqs last disabled at (1116): [<ffffffff81239e74>] irqsafe4_soft_rlock_213+0x9d/0x1a1
[    0.000000]   ok  |  ok  |  ok  |
[    0.000000]     hard-safe-A + unsafe-B #2/312:  ok  |  ok  |  ok  |
[    0.000000]     soft-safe-A + unsafe-B #2/312:  ok  |  ok  |  ok  |
[    0.000000]     hard-safe-A + unsafe-B #2/321:  ok  |  ok  |  ok  |
[    0.000000]     soft-safe-A + unsafe-B #2/321:  ok  |  ok  |  ok  |
[    0.000000]       hard-irq lock-inversion/123:  ok  |  ok  |  ok  |
[    0.000000]       soft-irq lock-inversion/123:possible reason: unannotated irqs-on.
[    0.000000] irq event stamp: 1272
[    0.000000] hardirqs last  enabled at (1270): [<ffffffff8156b671>] dotest+0x69e/0x6ff
[    0.000000] hardirqs last disabled at (1271): [<ffffffff8104ae9c>] vprintk_emit+0xb3/0x88f
[    0.000000] softirqs last  enabled at (1253): [<ffffffff81239a89>] irqsafe4_soft_rlock_321+0x195/0x1a1
[    0.000000] softirqs last disabled at (1272): [<ffffffff8123f55c>] irq_inversion_soft_spin_123+0x13/0x1a1
[    0.000000]   ok  |  ok  |  ok  |
[    0.000000]       hard-irq lock-inversion/132:  ok  |  ok  |  ok  |
[    0.000000]       soft-irq lock-inversion/132:possible reason: unannotated irqs-on.
[    0.000000] irq event stamp: 1312
[    0.000000] hardirqs last  enabled at (1310): [<ffffffff8156b671>] dotest+0x69e/0x6ff
[    0.000000] hardirqs last disabled at (1311): [<ffffffff8104ae9c>] vprintk_emit+0xb3/0x88f
[    0.000000] softirqs last  enabled at (1289): [<ffffffff8123ed18>] irq_inversion_soft_rlock_123+0x195/0x1a1
[    0.000000] softirqs last disabled at (1312): [<ffffffff8123f3bb>] irq_inversion_soft_spin_132+0x13/0x1a1
[    0.000000]   ok  |  ok  |  ok  |
[    0.000000]       hard-irq lock-inversion/213:possible reason: unannotated irqs-on.
[    0.000000] irq event stamp: 1338
[    0.000000] hardirqs last  enabled at (1337): [<ffffffff8156b671>] dotest+0x69e/0x6ff
[    0.000000] hardirqs last disabled at (1338): [<ffffffff8104ae9c>] vprintk_emit+0xb3/0x88f
[    0.000000] softirqs last  enabled at (1334): [<ffffffff8123eb51>] irq_inversion_soft_rlock_132+0x16f/0x1a1
[    0.000000] softirqs last disabled at (1330): [<ffffffff8123ea59>] irq_inversion_soft_rlock_132+0x77/0x1a1
[    0.000000]   ok  |  ok  |  ok  |
[    0.000000]       soft-irq lock-inversion/213:possible reason: unannotated irqs-on.
[    0.000000] irq event stamp: 1350
[    0.000000] hardirqs last  enabled at (1349): [<ffffffff8156b671>] dotest+0x69e/0x6ff
[    0.000000] hardirqs last disabled at (1350): [<ffffffff8104ae9c>] vprintk_emit+0xb3/0x88f
[    0.000000] softirqs last  enabled at (1334): [<ffffffff8123eb51>] irq_inversion_soft_rlock_132+0x16f/0x1a1
[    0.000000] softirqs last disabled at (1330): [<ffffffff8123ea59>] irq_inversion_soft_rlock_132+0x77/0x1a1
[    0.000000]   ok  |  ok  |  ok  |
[    0.000000]       hard-irq lock-inversion/231:possible reason: unannotated irqs-on.
[    0.000000] irq event stamp: 1371
[    0.000000] hardirqs last  enabled at (1370): [<ffffffff8156b671>] dotest+0x69e/0x6ff
[    0.000000] hardirqs last disabled at (1371): [<ffffffff8104ae9c>] vprintk_emit+0xb3/0x88f
[    0.000000] softirqs last  enabled at (1367): [<ffffffff8123e9d6>] irq_inversion_soft_rlock_213+0x195/0x1a1
[    0.000000] softirqs last disabled at (1363): [<ffffffff8123e8de>] irq_inversion_soft_rlock_213+0x9d/0x1a1
[    0.000000]   ok  |  ok  |  ok  |
[    0.000000]       soft-irq lock-inversion/231:possible reason: unannotated irqs-on.
[    0.000000] irq event stamp: 1383
[    0.000000] hardirqs last  enabled at (1382): [<ffffffff8156b671>] dotest+0x69e/0x6ff
[    0.000000] hardirqs last disabled at (1383): [<ffffffff8104ae9c>] vprintk_emit+0xb3/0x88f
[    0.000000] softirqs last  enabled at (1367): [<ffffffff8123e9d6>] irq_inversion_soft_rlock_213+0x195/0x1a1
[    0.000000] softirqs last disabled at (1363): [<ffffffff8123e8de>] irq_inversion_soft_rlock_213+0x9d/0x1a1
[    0.000000]   ok  |  ok  |  ok  |
[    0.000000]       hard-irq lock-inversion/312:  ok  |  ok  |  ok  |
[    0.000000]       soft-irq lock-inversion/312:  ok  |  ok  |  ok  |
[    0.000000]       hard-irq lock-inversion/321:  ok  |  ok  |  ok  |
[    0.000000]       soft-irq lock-inversion/321:  ok  |  ok  |  ok  |
[    0.000000]       hard-irq read-recursion/123:  ok  |
[    0.000000]       soft-irq read-recursion/123:possible reason: unannotated irqs-on.
[    0.000000] irq event stamp: 1511
[    0.000000] hardirqs last  enabled at (1509): [<ffffffff8156b671>] dotest+0x69e/0x6ff
[    0.000000] hardirqs last disabled at (1510): [<ffffffff8104ae9c>] vprintk_emit+0xb3/0x88f
[    0.000000] softirqs last  enabled at (1500): [<ffffffff8123e4f3>] irq_inversion_soft_rlock_321+0x195/0x1a1
[    0.000000] softirqs last disabled at (1511): [<ffffffff8123d80a>] irq_read_recursion_soft_123+0x13/0x1a1
[    0.000000] FAILED|Pid: 0, comm: swapper/0 Not tainted 3.8.0-mm1-00066-g1eea8bb #252
[    0.000000] Call Trace:
[    0.000000]  [<ffffffff8156b08f>] dotest+0xbc/0x6ff
[    0.000000]  [<ffffffff8124d0f3>] locking_selftest+0x2357/0x2744
[    0.000000]  [<ffffffff81c7d0c8>] start_kernel+0x44b/0x72b
[    0.000000]  [<ffffffff81c7c8b1>] ? repair_env_string+0x7d/0x7d
[    0.000000]  [<ffffffff81c7c54a>] x86_64_start_reservations+0x46/0x4f
[    0.000000]  [<ffffffff81c7c678>] x86_64_start_kernel+0x125/0x139
[    0.000000] 
[    0.000000]       hard-irq read-recursion/132:  ok  |
[    0.000000]       soft-irq read-recursion/132:possible reason: unannotated irqs-on.
[    0.000000] irq event stamp: 1520
[    0.000000] hardirqs last  enabled at (1518): [<ffffffff8156b671>] dotest+0x69e/0x6ff
[    0.000000] hardirqs last disabled at (1519): [<ffffffff8104ae9c>] vprintk_emit+0xb3/0x88f
[    0.000000] softirqs last  enabled at (1500): [<ffffffff8123e4f3>] irq_inversion_soft_rlock_321+0x195/0x1a1
[    0.000000] softirqs last disabled at (1520): [<ffffffff8123d669>] irq_read_recursion_soft_132+0x13/0x1a1
[    0.000000] FAILED|Pid: 0, comm: swapper/0 Not tainted 3.8.0-mm1-00066-g1eea8bb #252
[    0.000000] Call Trace:
[    0.000000]  [<ffffffff8156b08f>] dotest+0xbc/0x6ff
[    0.000000]  [<ffffffff8124d18f>] locking_selftest+0x23f3/0x2744
[    0.000000]  [<ffffffff81c7d0c8>] start_kernel+0x44b/0x72b
[    0.000000]  [<ffffffff81c7c8b1>] ? repair_env_string+0x7d/0x7d
[    0.000000]  [<ffffffff81c7c54a>] x86_64_start_reservations+0x46/0x4f
[    0.000000]  [<ffffffff81c7c678>] x86_64_start_kernel+0x125/0x139
[    0.000000] 
[    0.000000]       hard-irq read-recursion/213:possible reason: unannotated irqs-on.
[    0.000000] irq event stamp: 1522
[    0.000000] hardirqs last  enabled at (1521): [<ffffffff8156b671>] dotest+0x69e/0x6ff
[    0.000000] hardirqs last disabled at (1522): [<ffffffff8104ae9c>] vprintk_emit+0xb3/0x88f
[    0.000000] softirqs last  enabled at (1500): [<ffffffff8123e4f3>] irq_inversion_soft_rlock_321+0x195/0x1a1
[    0.000000] softirqs last disabled at (1520): [<ffffffff8123d669>] irq_read_recursion_soft_132+0x13/0x1a1
[    0.000000] FAILED|Pid: 0, comm: swapper/0 Not tainted 3.8.0-mm1-00066-g1eea8bb #252
[    0.000000] Call Trace:
[    0.000000]  [<ffffffff8156b08f>] dotest+0xbc/0x6ff
[    0.000000]  [<ffffffff8124d1dd>] locking_selftest+0x2441/0x2744
[    0.000000]  [<ffffffff81c7d0c8>] start_kernel+0x44b/0x72b
[    0.000000]  [<ffffffff81c7c8b1>] ? repair_env_string+0x7d/0x7d
[    0.000000]  [<ffffffff81c7c54a>] x86_64_start_reservations+0x46/0x4f
[    0.000000]  [<ffffffff81c7c678>] x86_64_start_kernel+0x125/0x139
[    0.000000] 
[    0.000000]       soft-irq read-recursion/213:possible reason: unannotated irqs-on.
[    0.000000] irq event stamp: 1524
[    0.000000] hardirqs last  enabled at (1523): [<ffffffff8156b671>] dotest+0x69e/0x6ff
[    0.000000] hardirqs last disabled at (1524): [<ffffffff8104ae9c>] vprintk_emit+0xb3/0x88f
[    0.000000] softirqs last  enabled at (1500): [<ffffffff8123e4f3>] irq_inversion_soft_rlock_321+0x195/0x1a1
[    0.000000] softirqs last disabled at (1520): [<ffffffff8123d669>] irq_read_recursion_soft_132+0x13/0x1a1
[    0.000000] FAILED|Pid: 0, comm: swapper/0 Not tainted 3.8.0-mm1-00066-g1eea8bb #252
[    0.000000] Call Trace:
[    0.000000]  [<ffffffff8156b08f>] dotest+0xbc/0x6ff
[    0.000000]  [<ffffffff8124d22b>] locking_selftest+0x248f/0x2744
[    0.000000]  [<ffffffff81c7d0c8>] start_kernel+0x44b/0x72b
[    0.000000]  [<ffffffff81c7c8b1>] ? repair_env_string+0x7d/0x7d
[    0.000000]  [<ffffffff81c7c54a>] x86_64_start_reservations+0x46/0x4f
[    0.000000]  [<ffffffff81c7c678>] x86_64_start_kernel+0x125/0x139
[    0.000000] 
[    0.000000]       hard-irq read-recursion/231:possible reason: unannotated irqs-on.
[    0.000000] irq event stamp: 1526
[    0.000000] hardirqs last  enabled at (1525): [<ffffffff8156b671>] dotest+0x69e/0x6ff
[    0.000000] hardirqs last disabled at (1526): [<ffffffff8104ae9c>] vprintk_emit+0xb3/0x88f
[    0.000000] softirqs last  enabled at (1500): [<ffffffff8123e4f3>] irq_inversion_soft_rlock_321+0x195/0x1a1
[    0.000000] softirqs last disabled at (1520): [<ffffffff8123d669>] irq_read_recursion_soft_132+0x13/0x1a1
[    0.000000] FAILED|Pid: 0, comm: swapper/0 Not tainted 3.8.0-mm1-00066-g1eea8bb #252
[    0.000000] Call Trace:
[    0.000000]  [<ffffffff8156b08f>] dotest+0xbc/0x6ff
[    0.000000]  [<ffffffff8124d279>] locking_selftest+0x24dd/0x2744
[    0.000000]  [<ffffffff81c7d0c8>] start_kernel+0x44b/0x72b
[    0.000000]  [<ffffffff81c7c8b1>] ? repair_env_string+0x7d/0x7d
[    0.000000]  [<ffffffff81c7c54a>] x86_64_start_reservations+0x46/0x4f
[    0.000000]  [<ffffffff81c7c678>] x86_64_start_kernel+0x125/0x139
[    0.000000] 
[    0.000000]       soft-irq read-recursion/231:possible reason: unannotated irqs-on.
[    0.000000] irq event stamp: 1528
[    0.000000] hardirqs last  enabled at (1527): [<ffffffff8156b671>] dotest+0x69e/0x6ff
[    0.000000] hardirqs last disabled at (1528): [<ffffffff8104ae9c>] vprintk_emit+0xb3/0x88f
[    0.000000] softirqs last  enabled at (1500): [<ffffffff8123e4f3>] irq_inversion_soft_rlock_321+0x195/0x1a1
[    0.000000] softirqs last disabled at (1520): [<ffffffff8123d669>] irq_read_recursion_soft_132+0x13/0x1a1
[    0.000000] FAILED|Pid: 0, comm: swapper/0 Not tainted 3.8.0-mm1-00066-g1eea8bb #252
[    0.000000] Call Trace:
[    0.000000]  [<ffffffff8156b08f>] dotest+0xbc/0x6ff
[    0.000000]  [<ffffffff8124d2c7>] locking_selftest+0x252b/0x2744
[    0.000000]  [<ffffffff81c7d0c8>] start_kernel+0x44b/0x72b
[    0.000000]  [<ffffffff81c7c8b1>] ? repair_env_string+0x7d/0x7d
[    0.000000]  [<ffffffff81c7c54a>] x86_64_start_reservations+0x46/0x4f
[    0.000000]  [<ffffffff81c7c678>] x86_64_start_kernel+0x125/0x139
[    0.000000] 
[    0.000000]       hard-irq read-recursion/312:  ok  |
[    0.000000]       soft-irq read-recursion/312:  ok  |
[    0.000000]       hard-irq read-recursion/321:  ok  |
[    0.000000]       soft-irq read-recursion/321:  ok  |
[    0.000000] -----------------------------------------------------------------
[    0.000000] BUG:   9 unexpected failures (out of 218) - debugging disabled! |
[    0.000000] -----------------------------------------------------------------
[    0.000000] ODEBUG: 11 of 11 active objects replaced
[    0.000000] ODEBUG: selftest passed
[    0.000000] hpet clockevent registered
[    0.000000] tsc: Detected 3300.108 MHz processor
[    0.020000] Calibrating delay loop (skipped) preset value.. 6600.21 BogoMIPS (lpj=33001080)
[    0.020000] pid_max: default: 32768 minimum: 301
[    0.020000] Dentry cache hash table entries: 32768 (order: 6, 262144 bytes)
[    0.020000] Inode-cache hash table entries: 16384 (order: 5, 131072 bytes)
[    0.020000] Mount-cache hash table entries: 256
[    0.020000] numa_add_cpu cpu 0 node 0: mask now 0
[    0.020000] Last level iTLB entries: 4KB 0, 2MB 0, 4MB 0
[    0.020000] Last level dTLB entries: 4KB 0, 2MB 0, 4MB 0
[    0.020000] tlb_flushall_shift: 6
[    0.020000] debug: unmapping init [mem 0xffffffff81d6a000-0xffffffff81d6cfff]
[    0.020453] ACPI: Core revision 20130117
[    0.022477] ACPI: All ACPI Tables successfully acquired
[    0.023145] ftrace: allocating 16261 entries in 64 pages
[    0.030122] Getting VERSION: 50014
[    0.030525] Getting VERSION: 50014
[    0.030929] Getting ID: 0
[    0.031240] Getting ID: ff000000
[    0.031615] Getting LVT0: 8700
[    0.031978] Getting LVT1: 8400
[    0.032362] enabled ExtINT on CPU#0
[    0.033271] ENABLING IO-APIC IRQs
[    0.040008] init IO_APIC IRQs
[    0.040363]  apic 2 pin 0 not connected
[    0.040806] IOAPIC[0]: Set routing entry (2-1 -> 0x31 -> IRQ 1 Mode:0 Active:0 Dest:1)
[    0.041712] IOAPIC[0]: Set routing entry (2-2 -> 0x30 -> IRQ 0 Mode:0 Active:0 Dest:1)
[    0.042612] IOAPIC[0]: Set routing entry (2-3 -> 0x33 -> IRQ 3 Mode:0 Active:0 Dest:1)
[    0.043510] IOAPIC[0]: Set routing entry (2-4 -> 0x34 -> IRQ 4 Mode:0 Active:0 Dest:1)
[    0.044414] IOAPIC[0]: Set routing entry (2-5 -> 0x35 -> IRQ 5 Mode:1 Active:0 Dest:1)
[    0.045313] IOAPIC[0]: Set routing entry (2-6 -> 0x36 -> IRQ 6 Mode:0 Active:0 Dest:1)
[    0.046209] IOAPIC[0]: Set routing entry (2-7 -> 0x37 -> IRQ 7 Mode:0 Active:0 Dest:1)
[    0.047109] IOAPIC[0]: Set routing entry (2-8 -> 0x38 -> IRQ 8 Mode:0 Active:0 Dest:1)
[    0.048005] IOAPIC[0]: Set routing entry (2-9 -> 0x39 -> IRQ 9 Mode:1 Active:0 Dest:1)
[    0.048913] IOAPIC[0]: Set routing entry (2-10 -> 0x3a -> IRQ 10 Mode:1 Active:0 Dest:1)
[    0.049833] IOAPIC[0]: Set routing entry (2-11 -> 0x3b -> IRQ 11 Mode:1 Active:0 Dest:1)
[    0.050019] IOAPIC[0]: Set routing entry (2-12 -> 0x3c -> IRQ 12 Mode:0 Active:0 Dest:1)
[    0.050942] IOAPIC[0]: Set routing entry (2-13 -> 0x3d -> IRQ 13 Mode:0 Active:0 Dest:1)
[    0.051864] IOAPIC[0]: Set routing entry (2-14 -> 0x3e -> IRQ 14 Mode:0 Active:0 Dest:1)
[    0.052797] IOAPIC[0]: Set routing entry (2-15 -> 0x3f -> IRQ 15 Mode:0 Active:0 Dest:1)
[    0.053738]  apic 2 pin 16 not connected
[    0.054190]  apic 2 pin 17 not connected
[    0.054635]  apic 2 pin 18 not connected
[    0.055081]  apic 2 pin 19 not connected
[    0.055532]  apic 2 pin 20 not connected
[    0.055979]  apic 2 pin 21 not connected
[    0.056433]  apic 2 pin 22 not connected
[    0.056877]  apic 2 pin 23 not connected
[    0.057477] ..TIMER: vector=0x30 apic1=0 pin1=2 apic2=-1 pin2=-1
[    0.058330] smpboot: CPU0: Intel Common KVM processor (fam: 0f, model: 06, stepping: 01)
[    0.060230] Using local APIC timer interrupts.
[    0.060230] calibrating APIC timer ...
[    0.070000] ... lapic delta = 6250032
[    0.070000] ... PM-Timer delta = 357970
[    0.070000] ... PM-Timer result ok
[    0.070000] ..... delta 6250032
[    0.070000] ..... mult: 268436830
[    0.070000] ..... calibration result: 10000051
[    0.070000] ..... CPU clock speed is 3300.2510 MHz.
[    0.070000] ..... host bus clock speed is 1000.0051 MHz.
[    0.070000] Performance Events: unsupported Netburst CPU model 6 no PMU driver, software events only.
[    0.100310] ftrace: Allocated trace_printk buffers
[    0.103824] Testing tracer nop: PASSED
[    0.104669] SMP alternatives: lockdep: fixing up alternatives
[    0.105457] smpboot: Booting Node   0, Processors  #1 OK
[    0.020000] kvm-clock: cpu 1, msr 0:fff8041, secondary cpu clock
[    0.020000] masked ExtINT on CPU#1
[    0.020000] numa_add_cpu cpu 1 node 0: mask now 0-1
[    0.130120] Brought up 2 CPUs
[    0.130086] KVM setup async PF for cpu 1
[    0.130086] kvm-stealtime: cpu 1, msr dd0cbc0
[    0.131389] smpboot: Total of 2 processors activated (13200.43 BogoMIPS)
[    0.140692] devtmpfs: initialized
[    0.141112] device: 'platform': device_add
[    0.141599] bus: 'platform': registered
[    0.142064] bus: 'cpu': registered
[    0.142455] device: 'cpu': device_add
[    0.142898] bus: 'memory': registered
[    0.143315] device: 'memory': device_add
[    0.143777] device: 'memory0': device_add
[    0.144243] bus: 'memory': add device memory0
[    0.144754] device: 'memory1': device_add
[    0.145217] bus: 'memory': add device memory1
[    0.230013] Testing tracer function: PASSED
[    0.451342] Testing dynamic ftrace: PASSED
[    0.760120] Testing dynamic ftrace ops #1: (1 0 1 1 0) (1 1 2 1 0) (2 1 3 1 9) (2 2 4 1 101) PASSED
[    0.842382] Testing dynamic ftrace ops #2: (1 0 1 9 0) (1 1 2 108 0) (2 1 3 1 9) (2 2 4 100 107) PASSED
[    0.926937] Testing ftrace recursion: PASSED
[    0.936251] Testing ftrace recursion safe: PASSED
[    0.945664] Testing ftrace regs: PASSED
[    1.150018] Testing tracer irqsoff: PASSED
[    1.521529] Testing tracer wakeup: ret = 0
[    1.810018] ftrace-test (24) used greatest stack depth: 6584 bytes left
[    1.911625] PASSED
[    2.001403] Testing tracer wakeup_rt: ret = 0
[    2.391791] PASSED
[    2.392401] atomic64 test passed for x86-64 platform with CX8 and with SSE
[    2.393249] bus: 'virtio': registered
[    2.393713] device class 'regulator': registering
[    2.394279] Registering platform device 'reg-dummy'. Parent at platform
[    2.395067] device: 'reg-dummy': device_add
[    2.395616] bus: 'platform': add device reg-dummy
[    2.396169] bus: 'platform': add driver reg-dummy
[    2.396773] bus: 'platform': driver_probe_device: matched device reg-dummy with driver reg-dummy
[    2.397824] bus: 'platform': really_probe: probing driver reg-dummy with device reg-dummy
[    2.398819] device: 'regulator.0': device_add
[    2.399352] regulator-dummy: no parameters
[    2.399898] driver: 'reg-dummy': driver_bound: bound to device 'reg-dummy'
[    2.400007] bus: 'platform': really_probe: bound device reg-dummy to driver reg-dummy
[    2.401027] NET: Registered protocol family 16
[    2.401761] device class 'bdi': registering
[    2.402268] device class 'pci_bus': registering
[    2.402861] bus: 'pci': registered
[    2.403271] device: 'rapidio': device_add
[    2.403779] bus: 'rapidio': registered
[    2.404222] device class 'backlight': registering
[    2.404801] device class 'tty': registering
[    2.405308] bus: 'node': registered
[    2.405736] device: 'node': device_add
[    2.406204] bus: 'hsi': registered
[    2.406623] bus: 'i2c': registered
[    2.407046] bus: 'i2c': add driver dummy
[    2.490239] ACPI: bus type pci registered
[    2.490712] device class 'dma': registering
[    2.491236] PCI: Using configuration type 1 for base access
[    2.492007] device: 'node0': device_add
[    2.492454] bus: 'node': add device node0
[    2.492943] device: 'cpu0': device_add
[    2.493373] bus: 'cpu': add device cpu0
[    2.493840] device: 'cpu1': device_add
[    2.494269] bus: 'cpu': add device cpu1
[    2.496152] device: 'default': device_add
[    2.496805] device class 'graphics': registering
[    2.497353] ACPI: Added _OSI(Module Device)
[    2.497837] ACPI: Added _OSI(Processor Device)
[    2.498334] ACPI: Added _OSI(3.0 _SCP Extensions)
[    2.498892] ACPI: Added _OSI(Processor Aggregator Device)
[    2.500549] ACPI: EC: Look up EC in DSDT
[    2.504038] ACPI: Interpreter enabled
[    2.504459] ACPI: (supports S0 S5)
[    2.504896] ACPI: Using IOAPIC for interrupt routing
[    2.505471] bus: 'acpi': registered
[    2.505869] PCI: Using host bridge windows from ACPI; if necessary, use "pci=nocrs" and report a bug
[    2.506894] device: 'LNXSYSTM:00': device_add
[    2.507392] bus: 'acpi': add device LNXSYSTM:00
[    2.507983] device: 'LNXSYBUS:00': device_add
[    2.508503] bus: 'acpi': add device LNXSYBUS:00
[    2.509094] device: 'PNP0A03:00': device_add
[    2.509587] bus: 'acpi': add device PNP0A03:00
[    2.510355] device: 'device:00': device_add
[    2.510839] bus: 'acpi': add device device:00
[    2.511404] device: 'device:01': device_add
[    2.511880] bus: 'acpi': add device device:01
[    2.512433] device: 'PNP0B00:00': device_add
[    2.512921] bus: 'acpi': add device PNP0B00:00
[    2.513507] device: 'PNP0303:00': device_add
[    2.513993] bus: 'acpi': add device PNP0303:00
[    2.514577] device: 'PNP0F13:00': device_add
[    2.515063] bus: 'acpi': add device PNP0F13:00
[    2.515651] device: 'PNP0700:00': device_add
[    2.516138] bus: 'acpi': add device PNP0700:00
[    2.516800] device: 'PNP0400:00': device_add
[    2.517289] bus: 'acpi': add device PNP0400:00
[    2.517941] device: 'PNP0501:00': device_add
[    2.518468] bus: 'acpi': add device PNP0501:00
[    2.519069] device: 'device:02': device_add
[    2.519555] bus: 'acpi': add device device:02
[    2.520072] device: 'device:03': device_add
[    2.520563] bus: 'acpi': add device device:03
[    2.521119] device: 'device:04': device_add
[    2.521602] bus: 'acpi': add device device:04
[    2.522160] device: 'device:05': device_add
[    2.522643] bus: 'acpi': add device device:05
[    2.523206] device: 'device:06': device_add
[    2.523690] bus: 'acpi': add device device:06
[    2.524252] device: 'device:07': device_add
[    2.524737] bus: 'acpi': add device device:07
[    2.525299] device: 'device:08': device_add
[    2.525788] bus: 'acpi': add device device:08
[    2.526353] device: 'device:09': device_add
[    2.526830] bus: 'acpi': add device device:09
[    2.527399] device: 'device:0a': device_add
[    2.527878] bus: 'acpi': add device device:0a
[    2.528471] device: 'device:0b': device_add
[    2.528946] bus: 'acpi': add device device:0b
[    2.529517] device: 'device:0c': device_add
[    2.530008] bus: 'acpi': add device device:0c
[    2.530573] device: 'device:0d': device_add
[    2.531051] bus: 'acpi': add device device:0d
[    2.531625] device: 'device:0e': device_add
[    2.532105] bus: 'acpi': add device device:0e
[    2.532671] device: 'device:0f': device_add
[    2.533148] bus: 'acpi': add device device:0f
[    2.533729] device: 'device:10': device_add
[    2.534207] bus: 'acpi': add device device:10
[    2.534770] device: 'device:11': device_add
[    2.535245] bus: 'acpi': add device device:11
[    2.535817] device: 'device:12': device_add
[    2.536297] bus: 'acpi': add device device:12
[    2.536863] device: 'device:13': device_add
[    2.537347] bus: 'acpi': add device device:13
[    2.537910] device: 'device:14': device_add
[    2.538425] bus: 'acpi': add device device:14
[    2.538980] device: 'device:15': device_add
[    2.539464] bus: 'acpi': add device device:15
[    2.540077] device: 'device:16': device_add
[    2.540566] bus: 'acpi': add device device:16
[    2.541129] device: 'device:17': device_add
[    2.541613] bus: 'acpi': add device device:17
[    2.542174] device: 'device:18': device_add
[    2.542662] bus: 'acpi': add device device:18
[    2.543222] device: 'device:19': device_add
[    2.543706] bus: 'acpi': add device device:19
[    2.544272] device: 'device:1a': device_add
[    2.544758] bus: 'acpi': add device device:1a
[    2.545315] device: 'device:1b': device_add
[    2.545796] bus: 'acpi': add device device:1b
[    2.546367] device: 'device:1c': device_add
[    2.546843] bus: 'acpi': add device device:1c
[    2.547407] device: 'device:1d': device_add
[    2.547882] bus: 'acpi': add device device:1d
[    2.548481] device: 'device:1e': device_add
[    2.548960] bus: 'acpi': add device device:1e
[    2.549525] device: 'device:1f': device_add
[    2.550008] bus: 'acpi': add device device:1f
[    2.550578] device: 'device:20': device_add
[    2.551054] bus: 'acpi': add device device:20
[    2.551625] device: 'device:21': device_add
[    2.552101] bus: 'acpi': add device device:21
[    2.552825] device: 'PNP0103:00': device_add
[    2.553313] bus: 'acpi': add device PNP0103:00
[    2.553991] device: 'PNP0C0F:00': device_add
[    2.554488] bus: 'acpi': add device PNP0C0F:00
[    2.555131] device: 'PNP0C0F:01': device_add
[    2.555625] bus: 'acpi': add device PNP0C0F:01
[    2.556262] device: 'PNP0C0F:02': device_add
[    2.556755] bus: 'acpi': add device PNP0C0F:02
[    2.557407] device: 'PNP0C0F:03': device_add
[    2.557891] bus: 'acpi': add device PNP0C0F:03
[    2.558570] device: 'PNP0C0F:04': device_add
[    2.559056] bus: 'acpi': add device PNP0C0F:04
[    2.559648] device: 'LNXCPU:00': device_add
[    2.560008] bus: 'acpi': add device LNXCPU:00
[    2.560582] device: 'LNXCPU:01': device_add
[    2.561059] bus: 'acpi': add device LNXCPU:01
[    2.561628] device: 'LNXSYBUS:01': device_add
[    2.562125] bus: 'acpi': add device LNXSYBUS:01
[    2.562707] ACPI: PCI Root Bridge [PCI0] (domain 0000 [bus 00-ff])
[    2.563407] acpi PNP0A03:00: Unable to request _OSC control (_OSC support mask: 0x08)
[    2.564302] device: 'pci0000:00': device_add
[    2.564807] device: '0000:00': device_add
[    2.565293] PCI host bridge to bus 0000:00
[    2.565758] pci_bus 0000:00: root bus resource [bus 00-ff]
[    2.566376] pci_bus 0000:00: root bus resource [io  0x0000-0x0cf7]
[    2.567060] pci_bus 0000:00: root bus resource [io  0x0d00-0xffff]
[    2.567752] pci_bus 0000:00: root bus resource [mem 0x000a0000-0x000bffff]
[    2.568566] pci_bus 0000:00: root bus resource [mem 0xe0000000-0xfebfffff]
[    2.569366] pci_bus 0000:00: scanning bus
[    2.570045] pci 0000:00:00.0: [8086:1237] type 00 class 0x060000
[    2.570748] pci 0000:00:00.0: calling quirk_mmio_always_on+0x0/0x16
[    2.571756] device: '0000:00:00.0': device_add
[    2.572407] bus: 'pci': add device 0000:00:00.0
[    2.573015] pci 0000:00:01.0: [8086:7000] type 00 class 0x060100
[    2.574143] device: '0000:00:01.0': device_add
[    2.574690] bus: 'pci': add device 0000:00:01.0
[    2.575297] pci 0000:00:01.1: [8086:7010] type 00 class 0x010180
[    2.577491] pci 0000:00:01.1: reg 20: [io  0xc1c0-0xc1cf]
[    2.578763] device: '0000:00:01.1': device_add
[    2.579376] bus: 'pci': add device 0000:00:01.1
[    2.580067] pci 0000:00:01.3: [8086:7113] type 00 class 0x068000
[    2.580754] pci 0000:00:01.3: calling acpi_pm_check_blacklist+0x0/0x59
[    2.581888] pci 0000:00:01.3: calling quirk_piix4_acpi+0x0/0x1cb
[    2.582575] pci 0000:00:01.3: quirk: [io  0xb000-0xb03f] claimed by PIIX4 ACPI
[    2.583380] pci 0000:00:01.3: quirk: [io  0xb100-0xb10f] claimed by PIIX4 SMB
[    2.584217] pci 0000:00:01.3: calling pci_fixup_piix4_acpi+0x0/0x1c
[    2.584978] device: '0000:00:01.3': device_add
[    2.585512] bus: 'pci': add device 0000:00:01.3
[    2.586127] pci 0000:00:02.0: [1013:00b8] type 00 class 0x030000
[    2.588535] pci 0000:00:02.0: reg 10: [mem 0xfc000000-0xfdffffff pref]
[    2.590066] pci 0000:00:02.0: reg 14: [mem 0xfebf4000-0xfebf4fff]
[    2.594028] pci 0000:00:02.0: reg 30: [mem 0xfebe0000-0xfebeffff pref]
[    2.594903] device: '0000:00:02.0': device_add
[    2.595529] bus: 'pci': add device 0000:00:02.0
[    2.596183] pci 0000:00:03.0: [8086:100e] type 00 class 0x020000
[    2.597405] pci 0000:00:03.0: reg 10: [mem 0xfeba0000-0xfebbffff]
[    2.598597] pci 0000:00:03.0: reg 14: [io  0xc000-0xc03f]
[    2.601715] pci 0000:00:03.0: reg 30: [mem 0xfebc0000-0xfebdffff pref]
[    2.602503] device: '0000:00:03.0': device_add
[    2.603042] bus: 'pci': add device 0000:00:03.0
[    2.603679] pci 0000:00:04.0: [8086:2668] type 00 class 0x040300
[    2.604668] pci 0000:00:04.0: reg 10: [mem 0xfebf0000-0xfebf3fff]
[    2.607127] device: '0000:00:04.0': device_add
[    2.607669] bus: 'pci': add device 0000:00:04.0
[    2.608284] pci 0000:00:05.0: [1af4:1001] type 00 class 0x010000
[    2.609557] pci 0000:00:05.0: reg 10: [io  0xc040-0xc07f]
[    2.610500] pci 0000:00:05.0: reg 14: [mem 0xfebf5000-0xfebf5fff]
[    2.613784] device: '0000:00:05.0': device_add
[    2.614335] bus: 'pci': add device 0000:00:05.0
[    2.614944] pci 0000:00:06.0: [1af4:1001] type 00 class 0x010000
[    2.616153] pci 0000:00:06.0: reg 10: [io  0xc080-0xc0bf]
[    2.617247] pci 0000:00:06.0: reg 14: [mem 0xfebf6000-0xfebf6fff]
[    2.620641] device: '0000:00:06.0': device_add
[    2.621182] bus: 'pci': add device 0000:00:06.0
[    2.621802] pci 0000:00:07.0: [1af4:1001] type 00 class 0x010000
[    2.623008] pci 0000:00:07.0: reg 10: [io  0xc0c0-0xc0ff]
[    2.624102] pci 0000:00:07.0: reg 14: [mem 0xfebf7000-0xfebf7fff]
[    2.627361] device: '0000:00:07.0': device_add
[    2.627916] bus: 'pci': add device 0000:00:07.0
[    2.628562] pci 0000:00:08.0: [1af4:1001] type 00 class 0x010000
[    2.629795] pci 0000:00:08.0: reg 10: [io  0xc100-0xc13f]
[    2.630491] pci 0000:00:08.0: reg 14: [mem 0xfebf8000-0xfebf8fff]
[    2.633750] device: '0000:00:08.0': device_add
[    2.634308] bus: 'pci': add device 0000:00:08.0
[    2.634924] pci 0000:00:09.0: [1af4:1001] type 00 class 0x010000
[    2.636139] pci 0000:00:09.0: reg 10: [io  0xc140-0xc17f]
[    2.637239] pci 0000:00:09.0: reg 14: [mem 0xfebf9000-0xfebf9fff]
[    2.640893] device: '0000:00:09.0': device_add
[    2.641457] bus: 'pci': add device 0000:00:09.0
[    2.642067] pci 0000:00:0a.0: [1af4:1001] type 00 class 0x010000
[    2.643277] pci 0000:00:0a.0: reg 10: [io  0xc180-0xc1bf]
[    2.644383] pci 0000:00:0a.0: reg 14: [mem 0xfebfa000-0xfebfafff]
[    2.647690] device: '0000:00:0a.0': device_add
[    2.648252] bus: 'pci': add device 0000:00:0a.0
[    2.648881] pci 0000:00:0b.0: [8086:25ab] type 00 class 0x088000
[    2.650005] pci 0000:00:0b.0: reg 10: [mem 0xfebfb000-0xfebfb00f]
[    2.652327] device: '0000:00:0b.0': device_add
[    2.652899] bus: 'pci': add device 0000:00:0b.0
[    2.653631] pci_bus 0000:00: fixups for bus
[    2.654102] pci_bus 0000:00: bus scan returning with max=00
[    2.654731] ACPI _OSC control for PCIe not granted, disabling ASPM
[    2.656110] ACPI: PCI Interrupt Link [LNKA] (IRQs 5 *10 11)
[    2.656979] ACPI: PCI Interrupt Link [LNKB] (IRQs 5 *10 11)
[    2.657840] ACPI: PCI Interrupt Link [LNKC] (IRQs 5 10 *11)
[    2.658724] ACPI: PCI Interrupt Link [LNKD] (IRQs 5 10 *11)
[    2.659580] ACPI: PCI Interrupt Link [LNKS] (IRQs 9) *0
[    2.660313] device: 'LNXPWRBN:00': device_add
[    2.660820] bus: 'acpi': add device LNXPWRBN:00
[    2.661566] ACPI: Enabled 16 GPEs in block 00 to 0F
[    2.662152] acpi root: \_SB_.PCI0 notify handler is installed
[    2.662841] Found 1 acpi root devices
[    2.663260] bus: 'acpi': add driver ec
[    2.663783] bus: 'pnp': registered
[    2.664181] bus: 'platform': add driver reg-fixed-voltage
[    2.664821] bus: 'i2c': add driver isl6271a
[    2.665307] bus: 'i2c': add driver lp3972
[    2.665780] bus: 'i2c': add driver max8952
[    2.666255] bus: 'i2c': add driver max8973
[    2.666736] bus: 'platform': add driver max8997-pmic
[    2.667310] bus: 'platform': add driver mc13892-regulator
[    2.667929] bus: 'platform': add driver palmas-pmic
[    2.668533] bus: 'platform': add driver tps6105x-regulator
[    2.669159] bus: 'i2c': add driver tps62360
[    2.669652] device class 'misc': registering
[    2.670028] bus: 'i2c': add driver tc3589x
[    2.670513] bus: 'i2c': add driver wm8350
[    2.670976] bus: 'i2c': add driver tps6105x
[    2.671466] bus: 'i2c': add driver mc13xxx
[    2.671939] bus: 'i2c': add driver da9052
[    2.672418] bus: 'i2c': add driver lp8788
[    2.672883] bus: 'i2c': add driver max8907
[    2.673369] bus: 'i2c': add driver max8997
[    2.673842] bus: 'i2c': add driver pcf50633
[    2.674332] bus: 'i2c': add driver tps6586x
[    2.674813] bus: 'i2c': add driver palmas
[    2.675282] bus: 'i2c': add driver as3711
[    2.675755] device class 'pcmcia_socket': registering
[    2.676349] bus: 'serio': registered
[    2.676790] bus: 'gameport': registered
[    2.677233] device class 'input': registering
[    2.677730] device class 'rtc': registering
[    2.678207] device class 'pps': registering
[    2.678719] pps_core: LinuxPPS API ver. 1 registered
[    2.679281] pps_core: Software ver. 5.3.6 - Copyright 2005-2007 Rodolfo Giometti <giometti@linux.it>
[    2.680004] device class 'ptp': registering
[    2.680484] PTP clock support registered
[    2.680939] device class 'power_supply': registering
[    2.681500] bus: 'platform': add driver max8997-battery
[    2.682102] device class 'hwmon': registering
[    2.682601] EDAC MC: Ver: 3.0.0
[    2.683210] bus: 'edac': registered
[    2.683609] device: 'edac': device_add
[    2.684053] device: 'mc': device_add
[    2.684461] bus: 'edac': add device mc
[    2.685136] bus: 'mmc': registered
[    2.685534] device class 'mmc_host': registering
[    2.686089] bus: 'sdio': registered
[    2.686489] device class 'leds': registering
[    2.686991] PCI: Using ACPI for IRQ routing
[    2.687470] PCI: pci_cache_line_size set to 64 bytes
[    2.688086] pci 0000:00:01.1: BAR 0: reserving [io  0x01f0-0x01f7 flags 0x110] (d=0, p=0)
[    2.688999] pci 0000:00:01.1: BAR 1: reserving [io  0x03f6 flags 0x110] (d=0, p=0)
[    2.690006] pci 0000:00:01.1: BAR 2: reserving [io  0x0170-0x0177 flags 0x110] (d=0, p=0)
[    2.690915] pci 0000:00:01.1: BAR 3: reserving [io  0x0376 flags 0x110] (d=0, p=0)
[    2.691752] pci 0000:00:01.1: BAR 4: reserving [io  0xc1c0-0xc1cf flags 0x40101] (d=0, p=0)
[    2.692693] pci 0000:00:02.0: BAR 0: reserving [mem 0xfc000000-0xfdffffff flags 0x42208] (d=0, p=0)
[    2.693694] pci 0000:00:02.0: BAR 1: reserving [mem 0xfebf4000-0xfebf4fff flags 0x40200] (d=0, p=0)
[    2.694702] pci 0000:00:03.0: BAR 0: reserving [mem 0xfeba0000-0xfebbffff flags 0x40200] (d=0, p=0)
[    2.695705] pci 0000:00:03.0: BAR 1: reserving [io  0xc000-0xc03f flags 0x40101] (d=0, p=0)
[    2.696640] pci 0000:00:04.0: BAR 0: reserving [mem 0xfebf0000-0xfebf3fff flags 0x40200] (d=0, p=0)
[    2.697646] pci 0000:00:05.0: BAR 0: reserving [io  0xc040-0xc07f flags 0x40101] (d=0, p=0)
[    2.698600] pci 0000:00:05.0: BAR 1: reserving [mem 0xfebf5000-0xfebf5fff flags 0x40200] (d=0, p=0)
[    2.699612] pci 0000:00:06.0: BAR 0: reserving [io  0xc080-0xc0bf flags 0x40101] (d=0, p=0)
[    2.700931] pci 0000:00:06.0: BAR 1: reserving [mem 0xfebf6000-0xfebf6fff flags 0x40200] (d=0, p=0)
[    2.701939] pci 0000:00:07.0: BAR 0: reserving [io  0xc0c0-0xc0ff flags 0x40101] (d=0, p=0)
[    2.702867] pci 0000:00:07.0: BAR 1: reserving [mem 0xfebf7000-0xfebf7fff flags 0x40200] (d=0, p=0)
[    2.703875] pci 0000:00:08.0: BAR 0: reserving [io  0xc100-0xc13f flags 0x40101] (d=0, p=0)
[    2.704804] pci 0000:00:08.0: BAR 1: reserving [mem 0xfebf8000-0xfebf8fff flags 0x40200] (d=0, p=0)
[    2.705814] pci 0000:00:09.0: BAR 0: reserving [io  0xc140-0xc17f flags 0x40101] (d=0, p=0)
[    2.706741] pci 0000:00:09.0: BAR 1: reserving [mem 0xfebf9000-0xfebf9fff flags 0x40200] (d=0, p=0)
[    2.707760] pci 0000:00:0a.0: BAR 0: reserving [io  0xc180-0xc1bf flags 0x40101] (d=0, p=0)
[    2.708713] pci 0000:00:0a.0: BAR 1: reserving [mem 0xfebfa000-0xfebfafff flags 0x40200] (d=0, p=0)
[    2.709722] pci 0000:00:0b.0: BAR 0: reserving [mem 0xfebfb000-0xfebfb00f flags 0x40200] (d=0, p=0)
[    2.710120] e820: reserve RAM buffer [mem 0x00093c00-0x0009ffff]
[    2.710804] e820: reserve RAM buffer [mem 0x0fffe000-0x0fffffff]
[    2.711485] device class 'net': registering
[    2.712021] device: 'lo': device_add
[    2.712814] Switching to clocksource kvm-clock
[    2.713705] Warning: could not register annotated branches stats
[    2.718231] bus: 'pnp': add driver system
[    2.718702] pnp: PnP ACPI init
[    2.719066] device: 'pnp0': device_add
[    2.719492] ACPI: bus type pnp registered
[    2.719492] IOAPIC[0]: Set routing entry (2-8 -> 0x38 -> IRQ 8 Mode:0 Active:0 Dest:3)
[    2.719492] device: '00:00': device_add
[    2.719492] bus: 'pnp': add device 00:00
[    2.719492] pnp 00:00: Plug and Play ACPI device, IDs PNP0b00 (active)
[    2.719492] IOAPIC[0]: Set routing entry (2-1 -> 0x31 -> IRQ 1 Mode:0 Active:0 Dest:3)
[    2.720192] device: '00:01': device_add
[    2.720647] bus: 'pnp': add device 00:01
[    2.721117] pnp 00:01: Plug and Play ACPI device, IDs PNP0303 (active)
[    2.721889] IOAPIC[0]: Set routing entry (2-12 -> 0x3c -> IRQ 12 Mode:0 Active:0 Dest:3)
[    2.722812] device: '00:02': device_add
[    2.723260] bus: 'pnp': add device 00:02
[    2.723732] pnp 00:02: Plug and Play ACPI device, IDs PNP0f13 (active)
[    2.724505] IOAPIC[0]: Set routing entry (2-6 -> 0x36 -> IRQ 6 Mode:0 Active:0 Dest:3)
[    2.725439] pnp 00:03: [dma 2]
[    2.725799] device: '00:03': device_add
[    2.726243] bus: 'pnp': add device 00:03
[    2.726720] pnp 00:03: Plug and Play ACPI device, IDs PNP0700 (active)
[    2.727530] IOAPIC[0]: Set routing entry (2-7 -> 0x37 -> IRQ 7 Mode:0 Active:0 Dest:3)
[    2.728433] device: '00:04': device_add
[    2.728877] bus: 'pnp': add device 00:04
[    2.729336] pnp 00:04: Plug and Play ACPI device, IDs PNP0400 (active)
[    2.730175] IOAPIC[0]: Set routing entry (2-4 -> 0x34 -> IRQ 4 Mode:0 Active:0 Dest:3)
[    2.731077] device: '00:05': device_add
[    2.731531] bus: 'pnp': add device 00:05
[    2.732001] pnp 00:05: Plug and Play ACPI device, IDs PNP0501 (active)
[    2.732947] device: '00:06': device_add
[    2.733407] bus: 'pnp': add device 00:06
[    2.733878] pnp 00:06: Plug and Play ACPI device, IDs PNP0103 (active)
[    2.734806] pnp: PnP ACPI: found 7 devices
[    2.735269] ACPI: ACPI bus type pnp unregistered
[    2.735795] INFO_MDMA: LNW DMA Driver Version 1.1.0
[    2.736339] bus: 'pci': add driver Intel MID DMA
[    2.736897] device class 'mem': registering
[    2.737387] device: 'mem': device_add
[    2.737979] device: 'null': device_add
[    2.738564] device: 'port': device_add
[    2.739130] device: 'zero': device_add
[    2.739686] device: 'full': device_add
[    2.740267] device: 'random': device_add
[    2.740863] device: 'urandom': device_add
[    2.741448] device: 'kmsg': device_add
[    2.741989] device: 'tty': device_add
[    2.742544] device: 'console': device_add
[    2.743130] bus: 'pcmcia': registered
[    2.743560] device class 'thermal': registering
[    2.748721] pci_bus 0000:00: resource 4 [io  0x0000-0x0cf7]
[    2.749342] pci_bus 0000:00: resource 5 [io  0x0d00-0xffff]
[    2.749967] pci_bus 0000:00: resource 6 [mem 0x000a0000-0x000bffff]
[    2.750708] pci_bus 0000:00: resource 7 [mem 0xe0000000-0xfebfffff]
[    2.751438] NET: Registered protocol family 1
[    2.751946] pci 0000:00:00.0: calling quirk_natoma+0x0/0x45
[    2.752584] pci 0000:00:00.0: Limiting direct PCI/PCI transfers
[    2.753243] pci 0000:00:00.0: calling quirk_passive_release+0x0/0xb5
[    2.753963] pci 0000:00:01.0: PIIX3: Enabling Passive Release
[    2.754630] pci 0000:00:01.0: calling quirk_isa_dma_hangs+0x0/0x48
[    2.755311] pci 0000:00:01.0: Activating ISA DMA hang workarounds
[    2.756025] pci 0000:00:02.0: calling pci_fixup_video+0x0/0xdd
[    2.756697] pci 0000:00:02.0: Boot video device
[    2.757215] pci 0000:00:03.0: calling quirk_e100_interrupt+0x0/0x1d2
[    2.758007] PCI: CLS 0 bytes, default 64
[    2.758562] Unpacking initramfs...
[    3.350469] debug: unmapping init [mem 0xffff88000e8d6000-0xffff88000ffeffff]
[    3.374323] DMA-API: preallocated 65536 debug entries
[    3.374921] DMA-API: debugging enabled by kernel config
[    3.375909] device class 'cpuid': registering
[    3.376486] device: 'cpu0': device_add
[    3.377116] device: 'cpu1': device_add
[    3.377776] Registering platform device 'microcode'. Parent at platform
[    3.378666] device: 'microcode': device_add
[    3.379224] bus: 'platform': add device microcode

--LZvS9be/3tNcYl/X
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="1eea8bb261e8d43492c91d516d97cf96cdac7a3b-bisect.log"
Content-Transfer-Encoding: quoted-printable

git checkout 19f949f52599ba7c3f67a5897ac6be14bfcb1200
Previous HEAD position was 1eea8bb... i2o: check copy_from_user() size para=
meter
HEAD is now at 19f949f... Linux 3.8

2013-03-02-10:53:31 19f949f52599ba7c3f67a5897ac6be14bfcb1200 compiling
/home/wfg/tip

2013-03-02-10:58:25 detecting boot state 3.8.0-bisect2 #59 	5..	15	16.	18	2=
6	27.	31	37	38	39	45	48	49	53	58	60.	65	69	71	73	78	80	82	85	91.	93	98	102.=
	106	110	113.	118	121	124	125	130	134	135.	141	146.	148	152	156	157	159	165=
	166	167	172	177.	178	184	188.	190	195	198	199	203	207	209	211	215	219	220	=
222	227	230	231	235	238	241	242	246	250	252	253	258	263.	265	270	273	274	27=
7	281	284	286	288	293	295	296	302	305	306	308	313	316	317	320	324	327	330	3=
33	338.	341	345	349.	352	356	360	361	364	368	371	373	376	381	382	384	388	39=
2	393	395	400	403	405	408	412	414	416	419	424	425	427	432	435	436	439	443	4=
46	447	450	456	457	459	462	467	468	470	474	478	479	482	485	488	490	493	498	=
499	502	506	510	511	512	517	520	522	525	529	531	534	537	541	542	544	549	552=
	554	556	561	563	566	568	573	574	577	580	585.	588	591	596	598	600	604	607	6=
09	613	617	618	620	624	628	629	632	636	639	642	646	649	650	653	657	660	661	=
664	669	672	673	677	682	683	684	688	693	694	696	700	704	705	708	712	715	717=
	720	725	727	729	732	737.	740	744	747	749	753	757	758	760	764	768	769	772	7=
76	779	780	783	788	790	791	795	799	801	804	808	810	812	814	819	822	823	827	=
831	833	835	838	842	844	846	849	853	854	859	862	864	866	870	873	875	877	881=
	885	886	891	892	896	897	902	905	907	909	913	916	918	920	924	927	929	933	93=
6	939	940	945	947	950	952	956	959	961	964	969	970	971	976	980	982.	987	991	=
993	996	998	1002	1003 SUCCESS
bisect: good commit 19f949f52599ba7c3f67a5897ac6be14bfcb1200
git bisect start 1eea8bb261e8d43492c91d516d97cf96cdac7a3b 19f949f52599ba7c3=
f67a5897ac6be14bfcb1200 --
Previous HEAD position was 19f949f... Linux 3.8
HEAD is now at 3c0eee3... Linux 2.6.37
Bisecting: 32 revisions left to test after this (roughly 5 steps)
[09bca78e81d0ba702b601e09fd887e20c32fc7af] block: restore /proc/partitions =
to not display non-partitionable removable devices
git bisect run /c/kernel-tests/bisect-test-boot-failure.sh obj-bisect-x86_64
running /c/kernel-tests/bisect-test-boot-failure.sh obj-bisect-x86_64

2013-03-02-13:54:27 09bca78e81d0ba702b601e09fd887e20c32fc7af compiling
/home/wfg/tip

2013-03-02-14:24:32 detecting boot state 3.8.0-bisect2-00033-g09bca78 #60 	=
6	14	22	31	42	50	60	67	74	83	93	103	111	120	126	136	145	155	166	173	182	189=
	198	209	219	228	236	243	252	262	271	281	288	295	303	314	324	333	343	351	35=
9	369	378	388	399	409	415	423	434	444	455	464	472	481	490	500	509	519	530	5=
37	545	553	563	572	581	589	599	605	613	623	630	640	648	655	663	670	679	688	=
696	704	711	718	728	735	745	753	762	769	777	786	795	803	812	820	829	836	844=
	854	863	872	881	891	900	912	922	932	942	948	955	965	975	985	993 SUCCESS
Bisecting: 16 revisions left to test after this (roughly 4 steps)
[b4a2adc2b273b37274b5a74fc0995927f44fe773] mm/dmapool.c: fix null dev in dm=
a_pool_create()
running /c/kernel-tests/bisect-test-boot-failure.sh obj-bisect-x86_64

2013-03-02-15:22:03 b4a2adc2b273b37274b5a74fc0995927f44fe773 compiling
/home/wfg/tip

2013-03-02-15:27:12 detecting boot state 3.8.0-mm1-bisect2-00049-gb4a2adc #=
61 	3..	9	13.	14	21	23.	27	31	33.	39	41	43	44	50	51	53	55	61.	63	67	71.	73	=
79	81	82	85	90	91	92	96	101.	102	107	111..	119	121..	130	131.	132	141..	146=
	151..	156	161..	166	171.	172	178	181.	185	189	191.	196	199	201	203	207	209=
	210	213	218	219.	224	229..	234	239.	241	247	249.	251	257	259.	262	267	269.=
	272	277	278	280	284	287.	292	295	297.	301	307..	310	316	317	318	323	326	32=
7	329	333	335	336	340	345.	346	349	355.	356	361	364	365	367	371	373	375	378=
	382	383	384	388	393.	394	398	403.	405	410	413.	416	421	423.	427	431	432	43=
4	437	441	442	445	448	450	451	454	458	459	460	464	467	468	469	472	476	477	4=
78	481	484	485	488	492	493	495	496	502.	503	507	511.	512	516	520	521.	525	5=
28	530	531	536.	539	541	545.	548	552	554.	558	561	563.	567	571	572.	574	581=
=2E.	585	589	590.	595	597.	601	604	606.	609	614	615.	618	623	624.	627	631	6=
33	634	638	640	642	644	648	649	650	653	658.	660	663	667.	668	673	676.	678	6=
82	684	685	687	692	693.	697	701.	702	708	710.	711	716	719.	721	726	727	728	=
732	735	736	738	742	744.	746	751	753.	756	761	762.	765	769	771.	775	777	780=
	781	785	787	788	791	794	796.	800	805..	810	814.	815	820	823.	825	828	832.	=
835	839.	841	845	848.	849	855	857.	858	865	866.	870	874	875.	879	884.	885	8=
88	893.	895	897	901	902	906	908	910	911	915	918	920	921	924	927	929	931	934=
	936	939	941	944	945	948	950	954.	958	960	963.	967	969	972.	976	979	981	982=
	985	989	990	992	995	999.	1002 SUCCESS
Bisecting: 8 revisions left to test after this (roughly 3 steps)
[0c2e1aacdc87c3ecf16cf26e8b3476c6203d03e2] printk: avoid softlockups in con=
sole_unlock()
running /c/kernel-tests/bisect-test-boot-failure.sh obj-bisect-x86_64

2013-03-02-18:55:32 0c2e1aacdc87c3ecf16cf26e8b3476c6203d03e2 compiling
/home/wfg/tip

2013-03-02-18:58:38 detecting boot state 3.8.0-mm1-bisect2-00057-g0c2e1aa #=
62  TEST FAILURE
Bisecting: 3 revisions left to test after this (roughly 2 steps)
[641feee3e6eeb680efcf5c6f625bb2cb4fcfc52c] early_printk: consolidate random=
 copies of identical code
running /c/kernel-tests/bisect-test-boot-failure.sh obj-bisect-x86_64

2013-03-02-18:59:09 641feee3e6eeb680efcf5c6f625bb2cb4fcfc52c compiling
/home/wfg/tip

2013-03-02-19:01:28 detecting boot state 3.8.0-mm1-bisect2-00053-g641feee #=
63 	2..	11..	13	20..	28	29.	31	38..	44	47.	49	55	56.	59	64	65.	71	73	74	76	=
80	81	83	85	90.	92	96	99	100	101	106	108	109	111	117.	118	121	126.	127	133	=
135.	137	143	144.	147	152	153.	157	162..	168	171..	179	180..	189..	192	198.=
=2E	202	207..	214	216.	217	225..	228	234..	238	242	243	244	249	252.	253	258=
	261.	265	267	270.	275	277	279	280	285	286	288	289	294	295	297	299	304.	306=
	310	313.	315	321	322.	324	330	331.	333	339	340.	344	349.	350	356	358.	359	=
365	367.	368	375	376.	378	384	385	386	390	393	394	395	400	403.	404	410	412	=
413	414	420	421	422	428	430.	432	437	439.	442	446	448	449	455	456	457	458	4=
64	465	466	468	473	474	476	479	482	484	485	491.	493	495	500.	502	505	509.	5=
11	515	518	519	521	526	527.	530	536..	541	545..	552	554.	555	563..	564	572.=
=2E	576	581..	585	590.	591	596	599.	602	606	608.	612	615	617.	622	624	626.	=
631	633	635	639	641	643	644	648	651	652	653	657	660	661	663	667	669	670	674=
	677	678	679	684	687.	688	693	696.	697	703	705.	708	712	714.	718	722	723.	7=
29	732..	738	741.	743	747	750.	753	756	758	759	763	765	766	768	773	775.	778=
	782	784.	787	791	793.	797	800	802.	806	808	811	814	816	818	819	823	826	827=
	829	833	835	836	838	842	844	845	848	853	854.	857	862	863.	866	871	872	873	=
877	880	881	883	887	889	890	893	896	899.	903	905	908	909	912	914	917	919	92=
2	923	926	929	932	934	935	939	941	943	945	948	950	951	954	958	959	960	964	9=
68	969.	973	976	978.	982	985	987	989	993	994	996	998 SUCCESS
Bisecting: 1 revision left to test after this (roughly 1 step)
[8a7d64347f4144f2e93745ba971809ca843887ae] include/linux/fs.h: disable pree=
mpt when acquire i_size_seqcount write lock
running /c/kernel-tests/bisect-test-boot-failure.sh obj-bisect-x86_64

2013-03-02-22:33:53 8a7d64347f4144f2e93745ba971809ca843887ae compiling
/home/wfg/tip

2013-03-02-22:35:35 detecting boot state 3.8.0-mm1-bisect2-00055-g8a7d643 #=
64 	1	3	7	10	11	12	17	19	20.	26	28	29	31	34	38.	41	43	46	47	51	53	55	57	60	=
62	64	66	70	72.	76	80	81	82	88	89	90	91	97	98	99	102	106	108.	113	115	117	1=
18	124	125	126	127	133	135.	139	143	144.	149	152	153	154	158	162.	164	167	1=
71.	175	177	180.	185	186	189	190	194	195	198	201	203	204	205	211	213	214	21=
5	221	222	223	224	228	231	232	233	237	240	241	244	246	248	250	255.	257	259	=
264	265	266	267	273	274	275	279	281	283	284	289	290	293.	298	299	302	303	30=
7	308	309	314	317.	318	325	326	327.	333	335	336.	341	344	345	347	351.	354	3=
59	360.	363	368	369	370.	377	378	379	380	386	387	388	392	395	396	397	402	40=
3	405	407	411	412	413	416	420	421	422	429	430.	431	437	439.	440	445	448.	45=
0	455	457.	460	464	466	467	472	473	475	476	481	482.	485	491..	496	500.	501	=
508	509.	510	516	518.	520	527..	530	536.	537	542	545.	547	551	554.	557	561	=
563	564	567	570	572	573	578	579	581	583	588.	589	593	597.	598	605	606.	607	=
612	615.	617	621	622	624	627	631.	633	638	640.	642	648	649.	652	657	658.	66=
1	666	667.	672	675	676	678	682	683	685	688	691	692	694	697	700	701	703	706	=
710.	712	718	719.	723	727	728.	732	737..	742	746.	748	750	754	755	758	761	7=
62	763	767	770	771	773	776	780.	782	785	789.	793	794	798.	801	805	806	808	8=
10	815.	818	820	823	824	828	829	833.	837	839	842.	847	850.	853	855	859.	863=
	864	868.	872	873	877.	881	884	885	888	891	894	895	897	900	903	904	907	910	=
912	914	917	920	921	924	926	929	930	933	935	938	939	942	945	947	949	952	956=
=2E	958	961	965.	969	970	974.	978	979	983	984	988.	992	994	997	1000	1001	10=
04	1006 SUCCESS
Bisecting: 0 revisions left to test after this (roughly 0 steps)
[6e1078c01b2e145140e7e8ce341c427b8be1eec3] kernel/smp.c: cleanups
running /c/kernel-tests/bisect-test-boot-failure.sh obj-bisect-x86_64

2013-03-03-02:13:24 6e1078c01b2e145140e7e8ce341c427b8be1eec3 compiling
/home/wfg/tip

2013-03-03-02:17:55 detecting boot state 3.8.0-mm1-bisect2-00056-g6e1078c #=
65 	2	5	7	10	11	14	18	19	22	23	27	28	32	33	37.	41	42	46.	50	53	55	56	59	63	=
64	65	69	72	73	76	78	81	82	86	89	90	92	94	99.	102	103	108.	111	113	117.	121=
	124	126.	130	134	135	136	140	143	144	146	149	152	153	156	161	162	163	166	1=
70	171	173	175	179	180	182	184	188	189	192	195	197	199	202	204	206	209	211	=
214	215	218	221	223	224	227	231	232	235	238	240	241	244	247	249	250	253	257=
	259.	262	266	268	269	272	275	277	279	282	285	286	288	292	295.	297	301	304.=
	307	311	313	315	317	321	322	324	326	330	331	333	336	339	340	343	347	348	35=
0	352	356	357	360	362	365	367	369	373	374	376	380	383	384	386	389	392	393	3=
96	400	401	404.	410.	413	414	419.	421	423	427	428	430	435	436	438	440	445.	=
448	449	454.	457	459	463.	466	471	472	473	475	480	481	483	485	489	490	492	4=
94	498.	501	504	507.	510	514	516	517	520	524	525	526	529	533	535	536	540	54=
3	544	545	550	552	553	554	559	562	563	566	569	571	572	576	578	580	581	586	5=
87	589	591	595	596	599	602	605.	608	612	614	615	617	621	623	625	627	630	632=
	634	636	640	641	644	648	649	650	654	657	658	660	663	667.	669	673	676.	679	=
684	685	686	688	694.	695	698	703.	705	709	712	713	716	721.	722	725	730.	734=
	737	739	740	743	747.	749	751	756.	758	761	765.	767	771	774	775	778	781	782=
	784	786	791.	793	797	800.	802	806	809.	813	815	818	819	822	826.	828	831	83=
5	836	837	841	844.	847	850	852	853	857	860	861	863	867	870.	872	876	879	880=
	882	885	888	890	891	895	896	899	901	904.	908	911	913.	916	921	922	923	927	=
931.	933	935	939	940	942	944	947	949	951	954	956	959	961	964	965	967	971	97=
4.	976	980	983.	986	990	992	994	995	1000	1001	1003 SUCCESS
0c2e1aacdc87c3ecf16cf26e8b3476c6203d03e2 is the first bad commit
commit 0c2e1aacdc87c3ecf16cf26e8b3476c6203d03e2
Author: Jan Kara <jack@suse.cz>
Date:   Sat Mar 2 00:02:38 2013 +0000

    printk: avoid softlockups in console_unlock()
   =20
    A CPU can be caught in console_unlock() for a long time (tens of seconds
    are reported by our customers) when other CPUs are using printk heavily
    and serial console makes printing slow.  Despite serial console drivers
    are calling touch_nmi_watchdog() this triggers softlockup warnings beca=
use
    interrupts are effectively disabled for the whole time printing takes
    place.  Thus IPIs cannot be processed and other CPUs get stuck spinning=
 in
    calls like smp_call_function_many().  Also RCU eventually starts report=
ing
    lockups.
   =20
    In my artifical testing I also managed to trigger a situation when disk
    disappeared from the system apparently because commands to / from it co=
uld
    not be delivered for long enough.  This is why just silencing watchdogs
    isn't a reliable solution to the problem.
   =20
    One part of fixing the issue is changing vprintk_emit() to call
    console_unlock() with interrupts enabled (this isn't perfect as printk()
    itself can be called with interrupts disabled but it improves the
    situation in lots of cases).  Another part is limiting the time we spend
    in console_unlock() printing loop to watchdog_thresh() / 4.  Then we
    release console_sem and wait for watchdog_thresh() / 4 to give a chance=
 to
    other printk() users to get the semaphore and start printing.  If print=
k()
    was called with interrupts enabled, it also gives CPU a chance to proce=
ss
    blocked interrupts.  Then we recheck if there's still anything to print,
    try to grab console_sem again and if we succeed, we go on with printing.
   =20
    Signed-off-by: Jan Kara <jack@suse.cz>
    Cc: "Paul E. McKenney" <paulmck@us.ibm.com>
    Cc: Steven Rostedt <rostedt@goodmis.org>
    Cc: Ingo Molnar <mingo@elte.hu>
    Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
    Cc: Frederic Weisbecker <fweisbec@gmail.com>
    Signed-off-by: Andrew Morton <akpm@linux-foundation.org>

:040000 040000 ffde7b97e814777db334b9d14a72ff41a1612b1d d83648edef86c15175d=
484ef5526cdd52d0c92e7 M	include
:040000 040000 0c1b4cc9e75164ffbc3608b3996a9781ebc1f3ef 2bd172270dee9f350ac=
cd890afd3b07f78412274 M	kernel
bisect run success

2013-03-03-05:52:39 6e1078c01b2e145140e7e8ce341c427b8be1eec3 compiling
/home/wfg/tip

2013-03-03-05:55:51 detecting boot state 3.8.0-mm1-bisect2-00056-g6e1078c #=
65 	2	5	8	9	12	14	18	19	21	23	26	28	31	33	35	38	41	43.	48	50	52	53	57	59	61=
	63	66	68	70	72	74	77	79	82	84	86	89	91	93	95	98	101	102	104	106	111.	113	1=
16	119	120	124	126	127	131	133	135	136	138	143	145.	147	152	154	155	156	162=
	163	165	167	171	172	174	177	179	181	183	186	188	192.	196	197	201	202	205	2=
06	209	213	214	215	217	222	224	225	226	231	233	235	237	239	242	244	247	248	=
252	253	256	257	260	263	265	267	269	274.	276	278	281	285.	289	290	294	295	2=
98	299	303	305	307	308	310	314	316	319.	323	326	328	330	332	334	337	339	341=
	343	346	348	350	353	356	358	360	362	365	368	369	371	373	376	378	380	382	38=
5	389	390	392	395	398	400	402	404	407	409	411	414	416	418	421	424	426	429	4=
30	433	435	438	439	442	444	448.	451	453	457	459	461	464	466	468	470	473	474=
	477	479	482	484	486	488	491	494	497	498	501	503	506	508	510	513	514	517	52=
0	523	524	526	529	532	534	536	539	541	543	546	548	550	552	556	558	559	561	5=
65	567	570	571	575	576	579	582	584	585	588	591	594	596	598	600	603	605	608	=
610	612	614	617	619	621	623	627	629	632	633	637	638	641	643	646	647	650	652=
	655	657	660	661	664	667	669	671	674	676	679	680	683	685	688	690	693	694	69=
8	699	703	704	708.	712	715	717	720	721	725	726	730	732	734	735	739	742	743	=
745	749	751	753	757	759	761	762	766	768	771	773	775	778	780	782	785	787	789=
	792	795	797	798	801	804	806	809	810	814	815	818	821	824	825	828	830	833	83=
5	837	839	842	845	847	849	851	854	856	859	860	863	866	868	869	873	876	877	8=
79	882	886.	888	891	895.	898	902	904.	908	912	913	914	917	922.	924	926	930	=
931	933	937	939	940	942	947	948	950	952	956	957	960	962	965	966	969	971	974=
	975	978	983.	984	987	992.	994	997	1001.	1003	1007	1010.	1013	1019.	1020	10=
22	1028.	1030	1032	1037.	1039	1044	1046	1047	1049	1053	1055	1056	1058	1063	=
1064	1067	1069	1072	1074	1076	1079	1081	1084	1085	1089	1090	1094.	1098	1100=
	1103	1105	1107	1110	1112	1115	1116	1120	1121	1124	1125	1129	1131	1134.	113=
8	1140	1143	1145	1146	1150	1152	1154	1155	1159	1161	1164	1166	1169	1170	117=
3	1175	1178	1181	1183	1184	1187	1190	1192	1194	1197	1199	1202	1203	1206	120=
9	1211	1214	1216	1219	1221	1223	1225	1229	1231	1232	1236	1238	1240	1241	124=
5	1247	1249	1251	1256	1257	1258	1261	1265	1266	1267	1271	1274	1276.	1280	12=
83	1285.	1291	1292	1294	1296	1299	1302	1303	1306	1308	1312.	1315	1319	1321	=
1322	1326	1328	1330	1332	1335	1338	1339	1342	1344	1347	1348	1351	1354	1356	=
1358	1360	1363	1366	1368	1371	1373	1375	1378	1380	1383	1384	1387	1390	1392	=
1395	1398	1401.	1405	1408	1410	1413	1414	1417	1419	1422	1425	1428.	1431	143=
5	1436	1438	1440	1445.	1448	1450	1454.	1457	1459	1463.	1467	1471	1472	1474	=
1476	1480	1481	1483	1486	1489	1490	1492	1495	1498	1499	1502	1504	1507	1509	=
1512	1514	1516	1519	1521	1524	1525	1527	1530	1533.	1538	1541	1542.	1547	155=
0	1551	1553	1556	1559	1560	1563	1564	1568.	1572	1573	1576	1577	1582	1584	15=
85	1588	1591	1594.	1598	1600	1603.	1607	1609	1612	1614	1617	1619	1621	1623	=
1626	1629	1630	1633	1635	1638	1640	1642	1644	1647	1648	1652	1653	1656	1658	=
1661	1662	1665	1668	1670	1673	1674	1678.	1682	1684	1686	1688	1691	1694	1695=
	1699.	1703	1704	1707	1709	1712	1714	1716	1717	1721	1722	1725	1728	1730	173=
2	1733	1737	1738	1742.	1747.	1751	1752	1756	1757	1760	1764	1765	1767	1769	1=
773	1774	1778.	1783.	1786	1788	1792	1793	1795	1799	1801	1804.	1809	1810	181=
3.	1818	1819	1822	1823	1827	1828	1831	1833	1836	1839	1840	1844	1845	1848	18=
49	1853	1855	1857	1858	1862	1864	1866	1869	1871	1875.	1879	1881	1884.	1889	=
1891	1893	1894	1898	1900	1902	1905	1907	1911.	1915	1917	1920.	1925	1926	192=
9.	1934	1937	1938	1941	1944	1946	1947	1950	1953	1955	1956	1960	1963	1964	19=
68	1969	1973.	1977	1980	1982	1984	1987	1989	1991	1995	1997	1999	2000	2004	2=
006	2009	2010	2015.	2018	2021	2024	2025	2027	2030	2033	2034	2036	2039	2042	=
2044	2046	2050	2052	2053	2056	2059	2061	2062	2065	2068	2070	2071	2075	2077	=
2080	2082	2085	2086	2089	2091	2095.	2098	2100	2104	2106	2108	2109	2112	2115=
	2118	2120	2121	2124	2126	2130	2131	2132	2135	2138	2140	2142	2145	2147	2149=
	2152	2154	2157	2158	2161	2164	2166	2168	2171	2173	2175	2177	2180	2182	2185=
	2187	2190	2192	2195	2196	2200	2201	2204	2206	2209	2212	2213	2216	2218	2221=
	2223	2225	2227	2231	2233	2235	2237	2240	2242	2245	2246	2249	2251	2254	2256=
	2260	2262	2264	2266	2269	2271	2273	2275	2278	2280	2282	2284	2287	2289	2293=
	2294	2296	2298	2302	2304	2307	2308	2311	2313	2316	2317	2320	2322	2325	2326=
	2330	2332	2335	2337	2340	2341	2344	2346	2349	2351	2353	2356	2358	2360	2362=
	2365	2367	2370	2372	2376	2377	2379	2381	2385	2387	2389	2392	2394	2396	2398=
	2401	2403	2405	2407	2411	2412	2415	2418	2420	2422	2425	2428	2430	2432	2434=
	2437	2439	2442	2443	2447	2448	2451	2454	2456	2458	2461	2463	2465	2468	2470=
	2473	2475	2478	2480	2483	2485	2487	2489	2492	2494	2496	2499	2501	2503	2505=
	2509	2510	2513	2515	2518	2519	2523	2524	2528	2529	2532	2534	2537	2539	2541=
	2544	2546	2549	2551	2554	2555	2558	2560	2564	2565	2568	2570	2573	2576	2578=
	2582	2583	2585	2588	2591	2592	2595	2597	2600	2601	2605	2606	2609	2611	2614=
	2616	2619	2621	2623	2625	2628	2630	2633	2635	2637	2640	2642	2645	2647	2649=
	2651	2654	2656	2658	2659	2663	2665	2667	2668	2672	2674	2677	2678	2681	2684=
	2685	2688	2692	2693	2694	2698	2700	2702	2703	2707	2709	2712.	2717	2718	272=
1	2722	2726	2729	2730	2732	2736	2738	2739	2742	2745	2748.	2753	2754	2757	27=
58	2763	2764	2766	2767	2772	2773	2775	2776	2781	2784.	2786	2790	2792	2793	2=
798	2799	2801	2802	2807	2809	2810	2812	2816	2818	2819	2822	2825	2828.	2833	=
2835	2837	2838	2843	2844	2846	2847	2852	2853	2855	2856	2861	2864	2865	2868	=
2871	2873	2874	2879	2880	2882	2883	2888	2889	2892	2896	2898	2899	2901	2906	=
2907	2910.	2915	2916	2919	2922	2925	2926	2928	2933	2934	2936	2937	2942	2943=
	2946.	2952.	2955	2956	2961.	2964	2969	2970.	2973	2978	2979	2980	2982 SUCCE=
SS

2013-03-03-16:30:57 67e51ff72caec0de0c3673303c0e7ee935ef80d8 compiling
/home/wfg/tip

2013-03-03-16:33:47 detecting boot state 3.8.0-mm1-bisect2-00187-g67e51ff #=
66 	2 TEST FAILURE
ERROR# 1: /c/kernel-tests/bisect:58: main: $BISECT_TEST $KBUILD_OUTPUT
[detached HEAD 52efcaa] Revert "printk: avoid softlockups in console_unlock=
()"
 2 files changed, 6 insertions(+), 56 deletions(-)

2013-03-03-16:34:48 52efcaa3b551117572315f73c5e787f65c734493 compiling
/home/wfg/tip

2013-03-03-16:35:54 detecting boot state 3.8.0-mm1-bisect2-00188-g52efcaa #=
67 	3..	11	12..	20	21.	22	29	30.	36	38	39.	46	47	48.	55	56	57	58	64	65	66	7=
2	73	75.	82	83	84	85	91	92	93	98	100	102.	108	109	111.	118	119	120	121	127	=
128	129	133	136	137	138	144	145	147.	154	155	156	158	163	164	165	167	172	17=
4.	178	181	183	184	190	191	192	194	199	200	201	204	208	209	211	213	217	218	=
221	224	227.	230	234	236	237	239	243	245	247	250	253	254	257	260	262	264	26=
6	270	272	273	278	280	282	284	288	290	291	293	298	299	300	305	307	308	309	3=
15	317.	320	325	326	327	329	334	335	336	340	343	344	345	352.	353	356	361.	3=
62	365	370.	371	377	379.	380	388.	389	391	397.	398	401	406.	407	412	415.	41=
6	423	424.	426	432	433	434	437	442	443.	449	451	452	455	460.	461	467	469	47=
0	473	478	479.	485	487	488	490	496.	497	503	505	506	507	513	514	515	519	523=
	524.	531	532	533	534	540	541	542	545	550	551.	556	559	560.	566	568	569	571=
	575	577	578	580	585	586	587	592	594	595	596	602	603	604	606	611	613.	616	6=
20	622.	627	629	631	632	637	639	640	642	647	648	649	652	656	657	658	662	665=
	666	667	672	674	675	677	682	684.	688	692	693	694	698	702.	705	709	711	712	=
718	720.	722	727	729.	733	737	738	739	742	746	747	748	753	756.	757	762	765.=
	768	772	774.	777	782	783.	789	792.	793	798	801.	803	807	810.	814	817	819.	=
824	826	828.	834	837.	841	843	846.	851	853	855.	860	862	864	865	870	871	873=
	878	880	882	883	888	889	891	895	898	899	901	906	907	908	913	915	917	918	92=
3	925	926	928	932	934	935	938	942	943	944	950	951	952	954	959	960	961	964	9=
69	970.	974	978	979	981	984	987	988	990	994	997.	999	1005	1006.	1008	1014	1=
015	1016	1018	1023	1024	1025	1030	1033.	1035	1040	1042.	1044	1049	1051	1052=
	1056	1059	1060	1061	1065	1068	1069	1070	1075	1078.	1082	1084	1087	1088	109=
2	1094	1096	1097	1102	1104	1106.	1111	1114	1115	1117	1120	1123	1124	1127	11=
30	1132	1133	1137	1140	1141	1142	1147	1149	1151	1152	1156	1158	1160	1162	11=
65	1168	1169	1171	1175	1178.	1181	1185	1187	1188	1192	1194	1196	1198	1201	1=
203	1205	1207	1210	1212	1214	1217	1220	1222	1225	1226	1230	1231	1234	1236	1=
238	1240	1244	1245	1247	1249	1253	1255	1256	1260	1263	1265.	1269	1272	1274	=
1275	1278	1281	1283	1287	1288	1291	1292	1296	1298	1301	1302	1305	1307	1310	=
1312	1314	1317	1319	1322	1324	1327	1329	1332	1334	1337	1339	1341	1344	1347	=
1349	1351	1355	1357	1358	1361	1364	1366	1368	1370	1373	1375	1378	1381	1383	=
1384	1387	1390	1393	1394	1397	1400	1402	1405	1406	1409	1411	1414	1416	1419	=
1420	1423	1426	1429.	1432	1435	1438	1439	1442	1445	1447	1448	1452	1455	1456=
	1458	1462	1464	1465	1468	1471	1474	1475	1480	1481	1483	1485	1489	1491	1492=
	1494	1498	1500	1501	1507	1509.	1512	1516	1518	1519	1522	1525	1527	1528	153=
3	1535	1536	1537	1542	1545.	1547	1552	1554.	1558	1561	1563	1564	1569	1572.	=
1573	1578	1581.	1583	1588	1590.	1593	1597	1599.	1605	1608.	1609	1614	1617.	=
1619	1623	1626.	1631	1633	1635	1636	1641	1643	1644	1645	1650	1653.	1656	165=
9	1662.	1668.	1671.	1677	1679	1680	1682	1686	1689.	1693	1695	1698.	1704	170=
5	1707	1708	1713	1715	1716	1717	1722	1725.	1729	1732	1734	1735	1739	1741	17=
43	1744	1748	1751	1752	1755	1757	1760	1762	1765	1767	1769	1771	1774	1777	17=
79	1780	1784	1787	1789	1790	1793	1796	1798	1801	1804	1805	1807	1811	1813	18=
15	1816	1820	1822	1824	1827	1829	1831	1833	1837	1839	1841	1842	1846	1848	18=
50	1852	1855	1858	1860	1862	1865	1867	1869	1872	1875	1876	1878	1881	1884	18=
86	1887	1891	1894	1895	1898	1902	1903	1905	1909	1911	1913	1917	1920	1921	19=
22	1926	1929	1930	1932	1937	1938	1940	1943	1946	1947	1949	1953	1955	1957	19=
58	1962	1965	1966	1969	1972	1974	1976	1980	1982	1984	1985	1989	1991	1993	19=
96	1998	2001	2003	2006	2008	2011	2012	2016	2018	2020	2021	2025	2028	2029	20=
31	2034	2038	2039	2043	2046	2047	2049	2052	2056	2057	2061	2064	2065	2068	20=
71	2074	2075	2078	2082	2084	2086	2089	2092	2094	2097	2101	2102	2104	2108	21=
10	2113	2116	2119	2120	2124	2127	2128	2131	2134	2137	2138	2142	2145	2147	21=
49	2153	2155	2157	2161	2164	2165	2168	2171	2173	2176	2180	2182	2183	2187	21=
91.	2194	2198	2200	2202	2205	2209	2210	2213	2216	2218	2220	2224	2227	2228	2=
232	2234	2236	2239	2242	2245	2246	2250	2253	2254	2257	2261	2263	2265	2269	2=
272	2273	2275	2279	2281	2284	2287	2290	2291	2295	2297	2299	2302	2305	2307	2=
309	2312	2314	2316	2318	2322	2324	2326	2328	2331	2334	2336	2338	2341	2343	2=
345	2348	2351	2352	2354	2357	2360	2361	2364	2368	2369	2372	2374	2377	2378	2=
381	2384	2387	2388	2391	2394	2396	2398	2400	2405.	2408	2410	2414.	2418	2420=
	2423.	2427	2430	2432	2434	2436	2439	2441	2444	2447	2450.	2454	2456	2459	24=
60	2463	2466	2468	2471	2472	2476	2477	2481	2482	2486.	2490	2493	2495	2496	2=
499	2502	2504	2507	2509	2512	2513	2517	2521	2522	2526	2527	2530	2531	2535	2=
539	2540	2544	2547	2549	2550	2553	2557	2558	2562	2565	2567	2569	2573	2575	2=
576	2580	2583	2585	2588	2591	2593	2594	2598	2600	2603	2604	2607	2610	2612	2=
615	2618	2620	2621	2625	2628	2630	2632	2635	2638	2639	2642	2645	2648	2649	2=
652	2654	2657	2659	2662	2664	2666	2669	2671	2674	2675	2678	2680	2683	2685	2=
688	2689	2693	2695	2698	2700	2702	2704	2707	2710	2711	2713	2716	2720.	2724	=
2725	2729	2731	2733	2737	2738	2740	2743	2746	2747	2751	2752	2756	2757	2760	=
2763	2765	2767	2770	2773	2774	2776	2779	2782	2783	2786	2788	2791	2792	2795	=
2799	2800	2803	2805	2809.	2812	2814	2818.	2822	2823	2827	2828	2832	2835	283=
6	2837	2841	2845.	2849	2850	2854	2855	2857	2860	2863	2864	2868	2871	2872	28=
73	2877	2880	2881	2883	2887	2890.	2894	2897	2899	2900	2903	2906	2908	2909	2=
912	2916	2917	2918	2923	2925	2926	2928	2933	2935	2936	2939	2942	2944	2945	2=
948	2951	2953	2954	2960	2961	2962	2964	2969	2970	2971	2975	2978	2979	2980	2=
985	2988	2989	2990	2995	2997	2998	3001 SUCCESS

=3D=3D=3D=3D=3D=3D=3D=3D=3D linux-next =3D=3D=3D=3D=3D=3D=3D=3D=3D
Fetching next

2013-03-04-02:57:27 106edea2fe051df65a1a6231e9ffa2876cc391cc compiling
/home/wfg/tip

2013-03-04-03:00:53 detecting boot state 3.8.0-bisect2-next-20130301 #68 	2=
	3	6	9	11	13	16	20.	22	27	29	30	32	36	38	39	43	46	47	48	53	56	57	58	63	65	6=
6	69	72	74	75	79	82	83	84	88	91	92	94	99	100	101	106	109.	111	118.	119	123	=
127.	128	133	136.	138	144	145	146	148	154.	155	160	163.	164	171	172.	174	18=
1..	184	190..	195	199.	200	207	208.	210	217..	221	226..	231	235..	242	244..=
	253..	255	262..	267	271..	280..	282	289..	297	298..	307..	308	316..	319	32=
5..	333	334..	343..	344	352..	356	361..	367	370.	371	379..	382	388..	392	39=
7.	398	403	406.	407	413	415.	418	424.	425	428	433.	434	440	442.	443	449	451=
=2E	455	458	460	461	464	468	469	472	476	478.	482	485	487.	491	494	496	498	5=
01	505.	508	512	514.	518	521	523	524	527	530	532	535	537	539	541	544	548.	5=
51	553	557.	562	563	566	568	571	574	575	578	580	584.	588	589	593.	598	601	6=
02.	607	611.	612	616	620.	625.	629.	634	636	638.	642	647.	649	650	656.	659.=
	665.	668	672	674	675	677	681	683	685	686	690	692	695	696	699	702	704	706	7=
08	711	713	717.	722	723	726	727	731	732	735	738	740	742	744	749.	753.	756	7=
59	762	763	765	769	771	774.	780.	783.	789	790	792	793	798	799	801	805	807	8=
09	810	816.	818	819	825	826	828	830	834	835	837	839	843	846.	850	853	855	85=
7	861	862	864	867	870	871	873	876	880	882	883	886	889	891	894	895	898	900	9=
03	905	908	909	912	916	917	918	921	925	927	930	931	934	936	939	941	944	945	=
948	950	953	954	957	961	963	965	967	971	972	975	977	980	981	984	987	990.	99=
3	997	999	1001	1003	1006	1008	1011	1012	1015	1017	1020	1023	1026.	1029	1033=
	1035	1037	1039	1042	1044	1047	1048	1051	1053	1056	1057	1062	1063	1065	1067=
	1071	1072	1074	1077	1080	1082	1084	1088	1089	1092	1093	1098.	1101	1102	110=
7	1108	1110	1113	1116	1119	1120	1122	1125	1128	1129	1131	1134	1137	1139	114=
3	1146.	1149	1151	1155	1156	1158	1159	1164	1166	1167	1170	1173	1176	1177	11=
80	1182	1185	1186	1189	1191	1194	1196	1198	1202	1204	1206	1208	1212	1213	12=
16	1218	1221	1222	1225	1227	1230	1232	1234	1237	1240	1243.	1248	1249	1252	1=
254	1257	1258	1261	1264	1267	1269	1270	1275	1276	1279.	1284	1285	1288	1289	=
1294	1295	1297	1300	1303	1305	1306	1311	1312	1315.	1320	1322	1324.	1330	133=
2	1333	1336	1339	1342.	1345	1348	1351.	1355	1358	1360	1361	1365	1368	1369	1=
370	1374	1378.	1382	1384	1387	1388	1391	1394	1396	1397	1400	1403	1405	1409	=
1411	1414	1415	1418	1420	1423	1424	1427	1430	1432	1434	1437	1439	1441	1444	=
1447	1449	1451	1454	1457	1459	1460	1464	1466	1468	1470	1474	1475	1477	1480	=
1483	1485	1487	1490	1492	1494	1496	1499	1502	1504	1506	1510	1511	1513	1516	=
1519	1520	1523	1526	1528	1530	1532	1536	1538	1539	1542	1546	1547	1549	1551	=
1555	1557	1558	1562	1564	1566	1567	1571	1574	1575	1577	1581	1582	1585	1586	=
1590	1592	1594	1597	1599	1602	1603	1606	1609	1611	1613	1616	1619	1621	1622	=
1625	1628	1630	1633	1634	1637	1639	1642	1645	1647	1649	1652	1654	1656	1658	=
1661	1664	1666	1669	1670	1673	1676	1678	1680	1683	1685	1688	1689	1692	1695	=
1697	1700	1701	1704	1706	1710	1711	1714	1715	1719	1720	1724	1725	1728	1730	=
1733	1735	1737	1740	1742	1746	1747	1751	1752	1755	1756	1760	1761	1764	1766	=
1769	1771	1774	1777	1778	1781	1783	1787	1788	1790	1792	1796	1798	1801	1802	=
1805	1807	1810	1812	1814	1817	1819	1821	1824	1826	1829	1831	1834	1836	1839	=
1841	1843	1845	1848	1850	1853	1854	1857	1860	1862	1864	1867	1870	1872	1875	=
1876	1879	1881	1884	1885	1889	1890	1894	1896	1898	1901	1903	1905	1908	1910	=
1912	1915	1917	1921.	1925	1926	1930	1932	1935	1936	1939	1941	1944	1946	1948=
	1951	1953	1957.	1962.	1966	1968	1971	1972	1975	1977	1980	1982	1984	1988	19=
89	1992	1993	1998	1999	2002	2003	2007	2009	2011	2014	2016	2019	2021	2023	20=
26	2029	2032	2034	2037	2038	2041	2043	2046	2048	2050	2052	2055	2058	2061	20=
63	2064	2068	2070	2072	2074	2077	2079	2082	2084	2087	2089	2091	2094	2097	20=
99	2101	2103	2106	2109	2110	2112	2115	2118	2121	2123	2126	2127	2130	2133	21=
36.	2139	2142	2145.	2149	2151	2154	2155	2158	2162	2163	2165	2168	2172.	2176=
	2177	2181	2182	2185	2186	2190	2191	2195	2197	2199	2201	2204	2207	2209	2210=
	2214	2216	2218	2221	2223	2225	2227	2231	2234	2236	2239	2241	2243	2245	2248=
	2250	2252	2254	2257	2261.	2263	2267	2270	2271	2273	2276	2279	2280	2284	228=
6	2287	2289	2292	2295	2296	2298	2302	2305	2306	2309	2311	2314	2316	2319	232=
2	2323	2325	2328	2332.	2334	2337	2341	2342	2344	2347	2350	2351	2354	2357	23=
59	2360	2364	2367	2369.	2373	2376	2378	2379	2383	2385	2387	2389	2392	2395	2=
396	2399	2403	2404	2405	2408	2412	2414	2416	2418	2421	2423	2425	2429	2430	2=
432	2434	2438	2440	2441	2444	2448	2449	2450	2454	2457	2458	2461	2465	2466	2=
467	2471	2474	2476.	2481	2483	2485.	2490	2492	2494	2496	2500	2501	2503	2506=
	2510.	2512	2516	2519	2520	2523	2525	2528	2529	2532	2536	2537	2538	2541	254=
5	2546	2547	2551	2554	2556	2557	2562	2563	2565	2569	2572	2574	2575	2579	258=
1	2583	2586	2589	2591	2592	2595	2599	2600	2601	2604	2608	2609	2611	2613	261=
7	2619	2620	2623	2627	2628	2631	2634	2636	2638	2640	2644	2645	2647	2649	265=
3	2655	2657	2659	2663	2664	2667	2670	2672	2674	2677	2680	2682	2684	2687	269=
0	2691	2694	2696	2699	2701	2703	2706	2708	2710	2712	2716	2718	2721	2722	272=
6	2727	2730	2733	2735	2737	2739	2742	2744	2746	2748	2752	2753	2757	2759	276=
2	2763	2766	2769	2771	2772	2775	2778	2780	2784.	2787	2789	2793	2795	2798.	2=
802	2805	2807	2809	2811	2814	2816	2820	2822	2823	2825	2829	2831	2834.	2838	=
2840	2843	2845	2847	2850	2852	2856	2858	2860	2861	2865	2867	2870.	2874	2876=
	2879	2881	2883	2886	2888	2892	2894	2897.	2901	2903	2906	2908	2910	2913	291=
5	2917	2919	2923	2924	2926	2930	2932	2934	2937	2940	2941	2944	2946	2949	295=
0	2953	2955	2959	2960	2963	2966	2968	2970	2972	2975	2977	2979	2981	2984	298=
6	2988	2991	2993	2996	2999	3002	3004	3005 SUCCESS

--LZvS9be/3tNcYl/X
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename=".config-bisect"

#
# Automatically generated file; DO NOT EDIT.
# Linux/x86_64 3.8.0-mm1 Kernel Configuration
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
CONFIG_GENERIC_ISA_DMA=y
CONFIG_GENERIC_BUG=y
CONFIG_GENERIC_BUG_RELATIVE_POINTERS=y
CONFIG_GENERIC_HWEIGHT=y
CONFIG_ARCH_MAY_HAVE_PC_FDC=y
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
CONFIG_X86_64_SMP=y
CONFIG_X86_HT=y
CONFIG_ARCH_HWEIGHT_CFLAGS="-fcall-saved-rdi -fcall-saved-rsi -fcall-saved-rdx -fcall-saved-rcx -fcall-saved-r8 -fcall-saved-r9 -fcall-saved-r10 -fcall-saved-r11"
CONFIG_ARCH_SUPPORTS_UPROBES=y
CONFIG_DEFCONFIG_LIST="/lib/modules/$UNAME_RELEASE/.config"
CONFIG_CONSTRUCTORS=y
CONFIG_IRQ_WORK=y
CONFIG_BUILDTIME_EXTABLE_SORT=y

#
# General setup
#
CONFIG_EXPERIMENTAL=y
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
CONFIG_KERNEL_LZMA=y
# CONFIG_KERNEL_XZ is not set
# CONFIG_KERNEL_LZO is not set
CONFIG_DEFAULT_HOSTNAME="(none)"
CONFIG_SYSVIPC=y
# CONFIG_POSIX_MQUEUE is not set
CONFIG_FHANDLE=y
# CONFIG_AUDIT is not set
CONFIG_HAVE_GENERIC_HARDIRQS=y

#
# IRQ subsystem
#
CONFIG_GENERIC_HARDIRQS=y
CONFIG_GENERIC_IRQ_PROBE=y
CONFIG_GENERIC_IRQ_SHOW=y
CONFIG_GENERIC_PENDING_IRQ=y
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
# CONFIG_NO_HZ is not set
CONFIG_HIGH_RES_TIMERS=y

#
# CPU/Task time and stats accounting
#
CONFIG_VIRT_CPU_ACCOUNTING=y
# CONFIG_TICK_CPU_ACCOUNTING is not set
CONFIG_VIRT_CPU_ACCOUNTING_GEN=y
# CONFIG_IRQ_TIME_ACCOUNTING is not set
CONFIG_BSD_PROCESS_ACCT=y
CONFIG_BSD_PROCESS_ACCT_V3=y
# CONFIG_TASKSTATS is not set

#
# RCU Subsystem
#
CONFIG_TREE_PREEMPT_RCU=y
CONFIG_PREEMPT_RCU=y
CONFIG_RCU_STALL_COMMON=y
CONFIG_CONTEXT_TRACKING=y
# CONFIG_RCU_USER_QS is not set
CONFIG_CONTEXT_TRACKING_FORCE=y
CONFIG_RCU_FANOUT=64
CONFIG_RCU_FANOUT_LEAF=16
CONFIG_RCU_FANOUT_EXACT=y
# CONFIG_TREE_RCU_TRACE is not set
CONFIG_RCU_BOOST=y
CONFIG_RCU_BOOST_PRIO=1
CONFIG_RCU_BOOST_DELAY=500
CONFIG_RCU_NOCB_CPU=y
CONFIG_IKCONFIG=y
CONFIG_LOG_BUF_SHIFT=17
CONFIG_HAVE_UNSTABLE_SCHED_CLOCK=y
CONFIG_ARCH_SUPPORTS_NUMA_BALANCING=y
CONFIG_ARCH_WANTS_PROT_NUMA_PROT_NONE=y
CONFIG_ARCH_USES_NUMA_PROT_NONE=y
# CONFIG_NUMA_BALANCING_DEFAULT_ENABLED is not set
CONFIG_NUMA_BALANCING=y
# CONFIG_CHECKPOINT_RESTORE is not set
CONFIG_NAMESPACES=y
# CONFIG_UTS_NS is not set
# CONFIG_IPC_NS is not set
CONFIG_USER_NS=y
CONFIG_PID_NS=y
CONFIG_NET_NS=y
CONFIG_UIDGID_CONVERTED=y
CONFIG_UIDGID_STRICT_TYPE_CHECKS=y
# CONFIG_SCHED_AUTOGROUP is not set
# CONFIG_SYSFS_DEPRECATED is not set
CONFIG_RELAY=y
CONFIG_BLK_DEV_INITRD=y
CONFIG_INITRAMFS_SOURCE=""
CONFIG_RD_GZIP=y
# CONFIG_RD_BZIP2 is not set
# CONFIG_RD_LZMA is not set
# CONFIG_RD_XZ is not set
# CONFIG_RD_LZO is not set
CONFIG_CC_OPTIMIZE_FOR_SIZE=y
CONFIG_ANON_INODES=y
CONFIG_EXPERT=y
CONFIG_SYSCTL_EXCEPTION_TRACE=y
CONFIG_KALLSYMS=y
CONFIG_KALLSYMS_ALL=y
CONFIG_HOTPLUG=y
CONFIG_PRINTK=y
CONFIG_BUG=y
CONFIG_ELF_CORE=y
# CONFIG_PCSPKR_PLATFORM is not set
CONFIG_HAVE_PCSPKR_PLATFORM=y
CONFIG_BASE_FULL=y
CONFIG_FUTEX=y
# CONFIG_EPOLL is not set
CONFIG_SIGNALFD=y
# CONFIG_TIMERFD is not set
# CONFIG_EVENTFD is not set
CONFIG_SHMEM=y
CONFIG_AIO=y
CONFIG_EMBEDDED=y
CONFIG_HAVE_PERF_EVENTS=y

#
# Kernel Performance Events And Counters
#
CONFIG_PERF_EVENTS=y
# CONFIG_DEBUG_PERF_USE_VMALLOC is not set
# CONFIG_VM_EVENT_COUNTERS is not set
CONFIG_PCI_QUIRKS=y
CONFIG_SLUB_DEBUG=y
# CONFIG_COMPAT_BRK is not set
# CONFIG_SLAB is not set
CONFIG_SLUB=y
# CONFIG_SLOB is not set
# CONFIG_PROFILING is not set
CONFIG_TRACEPOINTS=y
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
CONFIG_USE_GENERIC_SMP_HELPERS=y
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
CONFIG_HAVE_VIRT_TO_BUS=y
CONFIG_HAVE_ARCH_SECCOMP_FILTER=y
CONFIG_SECCOMP_FILTER=y
CONFIG_HAVE_CONTEXT_TRACKING=y
CONFIG_HAVE_IRQ_TIME_ACCOUNTING=y
CONFIG_HAVE_ARCH_TRANSPARENT_HUGEPAGE=y
CONFIG_MODULES_USE_ELF_RELA=y

#
# GCOV-based kernel profiling
#
CONFIG_GCOV_KERNEL=y
CONFIG_GCOV_PROFILE_ALL=y
# CONFIG_HAVE_GENERIC_DMA_COHERENT is not set
CONFIG_RT_MUTEXES=y
CONFIG_BASE_SMALL=0
# CONFIG_SYSTEM_TRUSTED_KEYRING is not set
# CONFIG_MODULES is not set
CONFIG_STOP_MACHINE=y
# CONFIG_BLOCK is not set
CONFIG_UNINLINE_SPIN_UNLOCK=y
# CONFIG_FREEZER is not set

#
# Processor type and features
#
CONFIG_ZONE_DMA=y
CONFIG_SMP=y
CONFIG_X86_MPPARSE=y
# CONFIG_X86_EXTENDED_PLATFORM is not set
# CONFIG_X86_INTEL_LPSS is not set
# CONFIG_SCHED_OMIT_FRAME_POINTER is not set
CONFIG_PARAVIRT_GUEST=y
# CONFIG_PARAVIRT_TIME_ACCOUNTING is not set
# CONFIG_XEN is not set
# CONFIG_XEN_PRIVILEGED_GUEST is not set
CONFIG_KVM_GUEST=y
CONFIG_PARAVIRT=y
# CONFIG_PARAVIRT_SPINLOCKS is not set
CONFIG_PARAVIRT_CLOCK=y
# CONFIG_PARAVIRT_DEBUG is not set
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
# CONFIG_DMI is not set
CONFIG_GART_IOMMU=y
CONFIG_CALGARY_IOMMU=y
# CONFIG_CALGARY_IOMMU_ENABLED_BY_DEFAULT is not set
CONFIG_SWIOTLB=y
CONFIG_IOMMU_HELPER=y
# CONFIG_MAXSMP is not set
CONFIG_NR_CPUS=8
# CONFIG_SCHED_SMT is not set
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
CONFIG_MICROCODE_INTEL_EARLY=y
CONFIG_MICROCODE_EARLY=y
# CONFIG_X86_MSR is not set
CONFIG_X86_CPUID=y
CONFIG_ARCH_PHYS_ADDR_T_64BIT=y
CONFIG_ARCH_DMA_ADDR_T_64BIT=y
CONFIG_DIRECT_GBPAGES=y
CONFIG_NUMA=y
CONFIG_AMD_NUMA=y
CONFIG_X86_64_ACPI_NUMA=y
CONFIG_NODES_SPAN_OTHER_NODES=y
# CONFIG_NUMA_EMU is not set
CONFIG_NODES_SHIFT=6
CONFIG_ARCH_SPARSEMEM_ENABLE=y
CONFIG_ARCH_SPARSEMEM_DEFAULT=y
CONFIG_ARCH_SELECT_MEMORY_MODEL=y
CONFIG_ARCH_MEMORY_PROBE=y
CONFIG_ILLEGAL_POINTER_VALUE=0xdead000000000000
CONFIG_SELECT_MEMORY_MODEL=y
CONFIG_SPARSEMEM_MANUAL=y
CONFIG_SPARSEMEM=y
CONFIG_NEED_MULTIPLE_NODES=y
CONFIG_HAVE_MEMORY_PRESENT=y
CONFIG_SPARSEMEM_EXTREME=y
CONFIG_SPARSEMEM_VMEMMAP_ENABLE=y
CONFIG_SPARSEMEM_ALLOC_MEM_MAP_TOGETHER=y
# CONFIG_SPARSEMEM_VMEMMAP is not set
CONFIG_HAVE_MEMBLOCK=y
CONFIG_HAVE_MEMBLOCK_NODE_MAP=y
CONFIG_ARCH_DISCARD_MEMBLOCK=y
CONFIG_MEMORY_ISOLATION=y
# CONFIG_MOVABLE_NODE is not set
CONFIG_HAVE_BOOTMEM_INFO_NODE=y
CONFIG_MEMORY_HOTPLUG=y
CONFIG_MEMORY_HOTPLUG_SPARSE=y
CONFIG_MEMORY_HOTREMOVE=y
CONFIG_PAGEFLAGS_EXTENDED=y
CONFIG_SPLIT_PTLOCK_CPUS=999999
# CONFIG_COMPACTION is not set
CONFIG_MIGRATION=y
CONFIG_PHYS_ADDR_T_64BIT=y
CONFIG_ZONE_DMA_FLAG=1
CONFIG_VIRT_TO_BUS=y
CONFIG_KSM=y
CONFIG_DEFAULT_MMAP_MIN_ADDR=4096
# CONFIG_TRANSPARENT_HUGEPAGE is not set
# CONFIG_CROSS_MEMORY_ATTACH is not set
# CONFIG_CLEANCACHE is not set
# CONFIG_X86_CHECK_BIOS_CORRUPTION is not set
CONFIG_X86_RESERVE_LOW=64
# CONFIG_MTRR is not set
CONFIG_ARCH_RANDOM=y
# CONFIG_X86_SMAP is not set
# CONFIG_EFI is not set
CONFIG_SECCOMP=y
# CONFIG_CC_STACKPROTECTOR is not set
CONFIG_HZ_100=y
# CONFIG_HZ_250 is not set
# CONFIG_HZ_300 is not set
# CONFIG_HZ_1000 is not set
CONFIG_HZ=100
CONFIG_SCHED_HRTICK=y
# CONFIG_KEXEC is not set
# CONFIG_CRASH_DUMP is not set
CONFIG_PHYSICAL_START=0x1000000
CONFIG_RELOCATABLE=y
CONFIG_PHYSICAL_ALIGN=0x1000000
# CONFIG_HOTPLUG_CPU is not set
# CONFIG_CMDLINE_BOOL is not set
CONFIG_ARCH_ENABLE_MEMORY_HOTPLUG=y
CONFIG_ARCH_ENABLE_MEMORY_HOTREMOVE=y
CONFIG_USE_PERCPU_NUMA_NODE_ID=y

#
# Power management and ACPI options
#
# CONFIG_SUSPEND is not set
CONFIG_PM_RUNTIME=y
CONFIG_PM=y
CONFIG_PM_DEBUG=y
# CONFIG_PM_ADVANCED_DEBUG is not set
CONFIG_ACPI=y
# CONFIG_ACPI_EC_DEBUGFS is not set
CONFIG_ACPI_AC=y
CONFIG_ACPI_BATTERY=y
CONFIG_ACPI_BUTTON=y
CONFIG_ACPI_FAN=y
# CONFIG_ACPI_DOCK is not set
CONFIG_ACPI_I2C=y
CONFIG_ACPI_PROCESSOR=y
# CONFIG_ACPI_IPMI is not set
# CONFIG_ACPI_PROCESSOR_AGGREGATOR is not set
CONFIG_ACPI_THERMAL=y
CONFIG_ACPI_NUMA=y
# CONFIG_ACPI_CUSTOM_DSDT is not set
# CONFIG_ACPI_INITRD_TABLE_OVERRIDE is not set
CONFIG_ACPI_BLACKLIST_YEAR=0
# CONFIG_ACPI_DEBUG is not set
# CONFIG_ACPI_PCI_SLOT is not set
CONFIG_X86_PM_TIMER=y
# CONFIG_ACPI_CONTAINER is not set
# CONFIG_ACPI_HOTPLUG_MEMORY is not set
# CONFIG_ACPI_SBS is not set
# CONFIG_ACPI_HED is not set
# CONFIG_ACPI_CUSTOM_METHOD is not set
# CONFIG_ACPI_APEI is not set
CONFIG_SFI=y

#
# CPU Frequency scaling
#
CONFIG_CPU_FREQ=y
CONFIG_CPU_FREQ_TABLE=y
CONFIG_CPU_FREQ_GOV_COMMON=y
# CONFIG_CPU_FREQ_STAT is not set
# CONFIG_CPU_FREQ_DEFAULT_GOV_PERFORMANCE is not set
# CONFIG_CPU_FREQ_DEFAULT_GOV_POWERSAVE is not set
# CONFIG_CPU_FREQ_DEFAULT_GOV_USERSPACE is not set
CONFIG_CPU_FREQ_DEFAULT_GOV_ONDEMAND=y
# CONFIG_CPU_FREQ_DEFAULT_GOV_CONSERVATIVE is not set
CONFIG_CPU_FREQ_GOV_PERFORMANCE=y
CONFIG_CPU_FREQ_GOV_POWERSAVE=y
CONFIG_CPU_FREQ_GOV_USERSPACE=y
CONFIG_CPU_FREQ_GOV_ONDEMAND=y
# CONFIG_CPU_FREQ_GOV_CONSERVATIVE is not set

#
# x86 CPU frequency scaling drivers
#
# CONFIG_X86_INTEL_PSTATE is not set
# CONFIG_X86_PCC_CPUFREQ is not set
# CONFIG_X86_ACPI_CPUFREQ is not set
# CONFIG_X86_SPEEDSTEP_CENTRINO is not set
# CONFIG_X86_P4_CLOCKMOD is not set

#
# shared options
#
# CONFIG_X86_SPEEDSTEP_LIB is not set
CONFIG_CPU_IDLE=y
# CONFIG_CPU_IDLE_MULTIPLE_DRIVERS is not set
CONFIG_CPU_IDLE_GOV_LADDER=y
# CONFIG_ARCH_NEEDS_CPU_IDLE_COUPLED is not set
# CONFIG_INTEL_IDLE is not set

#
# Memory power savings
#
# CONFIG_I7300_IDLE is not set

#
# Bus options (PCI etc.)
#
CONFIG_PCI=y
CONFIG_PCI_DIRECT=y
# CONFIG_PCI_MMCONFIG is not set
CONFIG_PCI_DOMAINS=y
CONFIG_PCI_CNB20LE_QUIRK=y
# CONFIG_PCIEPORTBUS is not set
CONFIG_ARCH_SUPPORTS_MSI=y
# CONFIG_PCI_MSI is not set
CONFIG_PCI_DEBUG=y
CONFIG_PCI_REALLOC_ENABLE_AUTO=y
# CONFIG_PCI_STUB is not set
CONFIG_HT_IRQ=y
# CONFIG_PCI_ATS is not set
# CONFIG_PCI_IOV is not set
# CONFIG_PCI_PRI is not set
# CONFIG_PCI_PASID is not set
# CONFIG_PCI_IOAPIC is not set
CONFIG_PCI_LABEL=y
CONFIG_ISA_DMA_API=y
CONFIG_AMD_NB=y
CONFIG_PCCARD=y
CONFIG_PCMCIA=y
CONFIG_PCMCIA_LOAD_CIS=y
# CONFIG_CARDBUS is not set

#
# PC-card bridges
#
# CONFIG_YENTA is not set
# CONFIG_PD6729 is not set
# CONFIG_I82092 is not set
CONFIG_HOTPLUG_PCI=y
# CONFIG_HOTPLUG_PCI_ACPI is not set
# CONFIG_HOTPLUG_PCI_CPCI is not set
CONFIG_HOTPLUG_PCI_SHPC=y
CONFIG_RAPIDIO=y
CONFIG_RAPIDIO_DISC_TIMEOUT=30
# CONFIG_RAPIDIO_ENABLE_RX_TX_PORTS is not set
# CONFIG_RAPIDIO_DMA_ENGINE is not set
# CONFIG_RAPIDIO_DEBUG is not set
# CONFIG_RAPIDIO_TSI57X is not set
CONFIG_RAPIDIO_CPS_XX=y
# CONFIG_RAPIDIO_TSI568 is not set
# CONFIG_RAPIDIO_CPS_GEN2 is not set
CONFIG_RAPIDIO_TSI500=y

#
# Executable file formats / Emulations
#
CONFIG_BINFMT_ELF=y
CONFIG_ARCH_BINFMT_ELF_RANDOMIZE_PIE=y
CONFIG_CORE_DUMP_DEFAULT_ELF_HEADERS=y
# CONFIG_HAVE_AOUT is not set
CONFIG_BINFMT_MISC=y
CONFIG_COREDUMP=y
# CONFIG_IA32_EMULATION is not set
CONFIG_HAVE_TEXT_POKE_SMP=y
CONFIG_X86_DEV_DMA_OPS=y
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
CONFIG_RPS=y
CONFIG_RFS_ACCEL=y
CONFIG_XPS=y
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
# CONFIG_RFKILL_REGULATOR is not set
# CONFIG_NET_9P is not set
# CONFIG_CAIF is not set
# CONFIG_NFC is not set
CONFIG_HAVE_BPF_JIT=y

#
# Device Drivers
#

#
# Generic Driver Options
#
CONFIG_UEVENT_HELPER_PATH=""
CONFIG_DEVTMPFS=y
# CONFIG_DEVTMPFS_MOUNT is not set
CONFIG_STANDALONE=y
# CONFIG_PREVENT_FIRMWARE_BUILD is not set
CONFIG_FW_LOADER=y
CONFIG_FIRMWARE_IN_KERNEL=y
CONFIG_EXTRA_FIRMWARE=""
# CONFIG_FW_LOADER_USER_HELPER is not set
CONFIG_DEBUG_DRIVER=y
# CONFIG_DEBUG_DEVRES is not set
# CONFIG_SYS_HYPERVISOR is not set
# CONFIG_GENERIC_CPU_DEVICES is not set
CONFIG_REGMAP=y
CONFIG_REGMAP_I2C=y
CONFIG_REGMAP_IRQ=y
# CONFIG_DMA_SHARED_BUFFER is not set

#
# Bus devices
#
# CONFIG_CONNECTOR is not set
# CONFIG_MTD is not set
# CONFIG_PARPORT is not set
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
# CONFIG_AD525X_DPOT is not set
CONFIG_IBM_ASM=y
CONFIG_PHANTOM=y
# CONFIG_INTEL_MID_PTI is not set
CONFIG_SGI_IOC4=y
# CONFIG_TIFM_CORE is not set
CONFIG_ICS932S401=y
CONFIG_ATMEL_SSC=y
# CONFIG_ENCLOSURE_SERVICES is not set
CONFIG_HP_ILO=y
CONFIG_APDS9802ALS=y
# CONFIG_ISL29003 is not set
CONFIG_ISL29020=y
CONFIG_SENSORS_TSL2550=y
# CONFIG_SENSORS_BH1780 is not set
CONFIG_SENSORS_BH1770=y
# CONFIG_SENSORS_APDS990X is not set
CONFIG_HMC6352=y
# CONFIG_DS1682 is not set
CONFIG_VMWARE_BALLOON=y
# CONFIG_BMP085_I2C is not set
# CONFIG_PCH_PHUB is not set
CONFIG_USB_SWITCH_FSA9480=y
# CONFIG_C2PORT is not set

#
# EEPROM support
#
CONFIG_EEPROM_AT24=y
CONFIG_EEPROM_LEGACY=y
# CONFIG_EEPROM_MAX6875 is not set
# CONFIG_EEPROM_93CX6 is not set
# CONFIG_CB710_CORE is not set

#
# Texas Instruments shared transport line discipline
#
# CONFIG_SENSORS_LIS3_I2C is not set

#
# Altera FPGA firmware download module
#
CONFIG_ALTERA_STAPL=y
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
CONFIG_FIREWIRE_NOSY=y
CONFIG_I2O=y
# CONFIG_I2O_LCT_NOTIFY_ON_CHANGES is not set
CONFIG_I2O_EXT_ADAPTEC=y
# CONFIG_I2O_EXT_ADAPTEC_DMA64 is not set
CONFIG_I2O_CONFIG=y
CONFIG_I2O_CONFIG_OLD_IOCTL=y
CONFIG_I2O_BUS=y
# CONFIG_I2O_PROC is not set
CONFIG_MACINTOSH_DRIVERS=y
# CONFIG_NETDEVICES is not set

#
# Input device support
#
CONFIG_INPUT=y
CONFIG_INPUT_FF_MEMLESS=y
CONFIG_INPUT_POLLDEV=y
# CONFIG_INPUT_SPARSEKMAP is not set
# CONFIG_INPUT_MATRIXKMAP is not set

#
# Userland interfaces
#
# CONFIG_INPUT_MOUSEDEV is not set
CONFIG_INPUT_JOYDEV=y
# CONFIG_INPUT_EVDEV is not set
CONFIG_INPUT_EVBUG=y

#
# Input Device Drivers
#
CONFIG_INPUT_KEYBOARD=y
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
# CONFIG_KEYBOARD_STOWAWAY is not set
# CONFIG_KEYBOARD_SUNKBD is not set
# CONFIG_KEYBOARD_TC3589X is not set
# CONFIG_KEYBOARD_XTKBD is not set
# CONFIG_INPUT_MOUSE is not set
CONFIG_INPUT_JOYSTICK=y
CONFIG_JOYSTICK_ANALOG=y
# CONFIG_JOYSTICK_A3D is not set
CONFIG_JOYSTICK_ADI=y
CONFIG_JOYSTICK_COBRA=y
# CONFIG_JOYSTICK_GF2K is not set
CONFIG_JOYSTICK_GRIP=y
CONFIG_JOYSTICK_GRIP_MP=y
CONFIG_JOYSTICK_GUILLEMOT=y
# CONFIG_JOYSTICK_INTERACT is not set
CONFIG_JOYSTICK_SIDEWINDER=y
CONFIG_JOYSTICK_TMDC=y
CONFIG_JOYSTICK_IFORCE=y
CONFIG_JOYSTICK_IFORCE_232=y
CONFIG_JOYSTICK_WARRIOR=y
# CONFIG_JOYSTICK_MAGELLAN is not set
CONFIG_JOYSTICK_SPACEORB=y
# CONFIG_JOYSTICK_SPACEBALL is not set
CONFIG_JOYSTICK_STINGER=y
# CONFIG_JOYSTICK_TWIDJOY is not set
# CONFIG_JOYSTICK_ZHENHUA is not set
# CONFIG_JOYSTICK_AS5011 is not set
# CONFIG_JOYSTICK_JOYDUMP is not set
# CONFIG_JOYSTICK_XPAD is not set
CONFIG_INPUT_TABLET=y
# CONFIG_TABLET_USB_ACECAD is not set
# CONFIG_TABLET_USB_AIPTEK is not set
# CONFIG_TABLET_USB_HANWANG is not set
# CONFIG_TABLET_USB_KBTAB is not set
# CONFIG_TABLET_USB_WACOM is not set
CONFIG_INPUT_TOUCHSCREEN=y
# CONFIG_TOUCHSCREEN_AD7879 is not set
# CONFIG_TOUCHSCREEN_ATMEL_MXT is not set
CONFIG_TOUCHSCREEN_BU21013=y
CONFIG_TOUCHSCREEN_CYTTSP_CORE=y
CONFIG_TOUCHSCREEN_CYTTSP_I2C=y
CONFIG_TOUCHSCREEN_DA9052=y
# CONFIG_TOUCHSCREEN_DYNAPRO is not set
CONFIG_TOUCHSCREEN_HAMPSHIRE=y
# CONFIG_TOUCHSCREEN_EETI is not set
# CONFIG_TOUCHSCREEN_FUJITSU is not set
# CONFIG_TOUCHSCREEN_ILI210X is not set
# CONFIG_TOUCHSCREEN_GUNZE is not set
CONFIG_TOUCHSCREEN_ELO=y
# CONFIG_TOUCHSCREEN_WACOM_W8001 is not set
CONFIG_TOUCHSCREEN_WACOM_I2C=y
CONFIG_TOUCHSCREEN_MAX11801=y
CONFIG_TOUCHSCREEN_MCS5000=y
CONFIG_TOUCHSCREEN_MMS114=y
# CONFIG_TOUCHSCREEN_MTOUCH is not set
# CONFIG_TOUCHSCREEN_INEXIO is not set
CONFIG_TOUCHSCREEN_MK712=y
# CONFIG_TOUCHSCREEN_PENMOUNT is not set
# CONFIG_TOUCHSCREEN_EDT_FT5X06 is not set
CONFIG_TOUCHSCREEN_TOUCHRIGHT=y
CONFIG_TOUCHSCREEN_TOUCHWIN=y
CONFIG_TOUCHSCREEN_PIXCIR=y
# CONFIG_TOUCHSCREEN_USB_COMPOSITE is not set
CONFIG_TOUCHSCREEN_MC13783=y
# CONFIG_TOUCHSCREEN_TOUCHIT213 is not set
# CONFIG_TOUCHSCREEN_TSC_SERIO is not set
CONFIG_TOUCHSCREEN_TSC2007=y
# CONFIG_TOUCHSCREEN_ST1232 is not set
CONFIG_TOUCHSCREEN_TPS6507X=y
# CONFIG_INPUT_MISC is not set

#
# Hardware I/O ports
#
CONFIG_SERIO=y
CONFIG_SERIO_I8042=y
CONFIG_SERIO_SERPORT=y
# CONFIG_SERIO_CT82C710 is not set
# CONFIG_SERIO_PCIPS2 is not set
CONFIG_SERIO_LIBPS2=y
# CONFIG_SERIO_RAW is not set
# CONFIG_SERIO_ALTERA_PS2 is not set
# CONFIG_SERIO_PS2MULT is not set
CONFIG_SERIO_ARC_PS2=y
CONFIG_GAMEPORT=y
CONFIG_GAMEPORT_NS558=y
CONFIG_GAMEPORT_L4=y
CONFIG_GAMEPORT_EMU10K1=y
# CONFIG_GAMEPORT_FM801 is not set

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
# CONFIG_TRACE_ROUTER is not set
CONFIG_TRACE_SINK=y
# CONFIG_DEVKMEM is not set

#
# Serial drivers
#
CONFIG_SERIAL_8250=y
CONFIG_SERIAL_8250_PNP=y
CONFIG_SERIAL_8250_CONSOLE=y
CONFIG_FIX_EARLYCON_MEM=y
CONFIG_SERIAL_8250_DMA=y
CONFIG_SERIAL_8250_PCI=y
# CONFIG_SERIAL_8250_CS is not set
CONFIG_SERIAL_8250_NR_UARTS=4
CONFIG_SERIAL_8250_RUNTIME_UARTS=4
# CONFIG_SERIAL_8250_EXTENDED is not set
# CONFIG_SERIAL_8250_DW is not set

#
# Non-8250 serial port support
#
CONFIG_SERIAL_MFD_HSU=y
# CONFIG_SERIAL_MFD_HSU_CONSOLE is not set
CONFIG_SERIAL_CORE=y
CONFIG_SERIAL_CORE_CONSOLE=y
CONFIG_SERIAL_JSM=y
# CONFIG_SERIAL_SCCNXP is not set
CONFIG_SERIAL_TIMBERDALE=y
CONFIG_SERIAL_ALTERA_JTAGUART=y
# CONFIG_SERIAL_ALTERA_JTAGUART_CONSOLE is not set
# CONFIG_SERIAL_ALTERA_UART is not set
# CONFIG_SERIAL_PCH_UART is not set
CONFIG_SERIAL_ARC=y
# CONFIG_SERIAL_ARC_CONSOLE is not set
CONFIG_SERIAL_ARC_NR_PORTS=1
CONFIG_SERIAL_RP2=y
CONFIG_SERIAL_RP2_NR_UARTS=32
# CONFIG_TTY_PRINTK is not set
# CONFIG_VIRTIO_CONSOLE is not set
CONFIG_IPMI_HANDLER=y
CONFIG_IPMI_PANIC_EVENT=y
CONFIG_IPMI_PANIC_STRING=y
# CONFIG_IPMI_DEVICE_INTERFACE is not set
CONFIG_IPMI_SI=y
CONFIG_IPMI_WATCHDOG=y
CONFIG_IPMI_POWEROFF=y
CONFIG_HW_RANDOM=y
CONFIG_HW_RANDOM_TIMERIOMEM=y
# CONFIG_HW_RANDOM_INTEL is not set
# CONFIG_HW_RANDOM_AMD is not set
# CONFIG_HW_RANDOM_VIA is not set
# CONFIG_HW_RANDOM_VIRTIO is not set
# CONFIG_NVRAM is not set
CONFIG_R3964=y
CONFIG_APPLICOM=y

#
# PCMCIA character devices
#
# CONFIG_SYNCLINK_CS is not set
# CONFIG_CARDMAN_4000 is not set
# CONFIG_CARDMAN_4040 is not set
# CONFIG_MWAVE is not set
# CONFIG_HPET is not set
# CONFIG_HANGCHECK_TIMER is not set
# CONFIG_TCG_TPM is not set
# CONFIG_TELCLOCK is not set
CONFIG_DEVPORT=y
CONFIG_I2C=y
CONFIG_I2C_BOARDINFO=y
# CONFIG_I2C_COMPAT is not set
CONFIG_I2C_CHARDEV=y
CONFIG_I2C_MUX=y

#
# Multiplexer I2C Chip support
#
# CONFIG_I2C_MUX_PCA9541 is not set
CONFIG_I2C_MUX_PCA954x=y
# CONFIG_I2C_HELPER_AUTO is not set
# CONFIG_I2C_SMBUS is not set

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
CONFIG_I2C_ALI1535=y
# CONFIG_I2C_ALI1563 is not set
# CONFIG_I2C_ALI15X3 is not set
# CONFIG_I2C_AMD756 is not set
# CONFIG_I2C_AMD8111 is not set
CONFIG_I2C_I801=y
CONFIG_I2C_ISCH=y
# CONFIG_I2C_ISMT is not set
# CONFIG_I2C_PIIX4 is not set
CONFIG_I2C_NFORCE2=y
# CONFIG_I2C_NFORCE2_S4985 is not set
CONFIG_I2C_SIS5595=y
# CONFIG_I2C_SIS630 is not set
# CONFIG_I2C_SIS96X is not set
# CONFIG_I2C_VIA is not set
CONFIG_I2C_VIAPRO=y

#
# ACPI drivers
#
# CONFIG_I2C_SCMI is not set

#
# I2C system bus drivers (mostly embedded / system-on-chip)
#
CONFIG_I2C_DESIGNWARE_CORE=y
CONFIG_I2C_DESIGNWARE_PCI=y
# CONFIG_I2C_EG20T is not set
# CONFIG_I2C_INTEL_MID is not set
# CONFIG_I2C_OCORES is not set
CONFIG_I2C_PCA_PLATFORM=y
# CONFIG_I2C_PXA_PCI is not set
# CONFIG_I2C_SIMTEC is not set
# CONFIG_I2C_XILINX is not set

#
# External I2C/SMBus adapter drivers
#
# CONFIG_I2C_PARPORT_LIGHT is not set
# CONFIG_I2C_TAOS_EVM is not set

#
# Other I2C/SMBus bus drivers
#
# CONFIG_I2C_DEBUG_CORE is not set
# CONFIG_I2C_DEBUG_ALGO is not set
CONFIG_I2C_DEBUG_BUS=y
# CONFIG_SPI is not set
CONFIG_HSI=y
CONFIG_HSI_BOARDINFO=y

#
# HSI clients
#
CONFIG_HSI_CHAR=y

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
# CONFIG_PTP_1588_CLOCK_PCH is not set
CONFIG_ARCH_WANT_OPTIONAL_GPIOLIB=y
CONFIG_GPIO_DEVRES=y
# CONFIG_GPIOLIB is not set
CONFIG_W1=y

#
# 1-wire Bus Masters
#
# CONFIG_W1_MASTER_MATROX is not set
CONFIG_W1_MASTER_DS2482=y
# CONFIG_W1_MASTER_DS1WM is not set

#
# 1-wire Slaves
#
# CONFIG_W1_SLAVE_THERM is not set
# CONFIG_W1_SLAVE_SMEM is not set
# CONFIG_W1_SLAVE_DS2408 is not set
# CONFIG_W1_SLAVE_DS2413 is not set
CONFIG_W1_SLAVE_DS2423=y
CONFIG_W1_SLAVE_DS2431=y
CONFIG_W1_SLAVE_DS2433=y
CONFIG_W1_SLAVE_DS2433_CRC=y
# CONFIG_W1_SLAVE_DS2760 is not set
CONFIG_W1_SLAVE_DS2780=y
# CONFIG_W1_SLAVE_DS2781 is not set
# CONFIG_W1_SLAVE_DS28E04 is not set
CONFIG_W1_SLAVE_BQ27000=y
CONFIG_POWER_SUPPLY=y
CONFIG_POWER_SUPPLY_DEBUG=y
# CONFIG_PDA_POWER is not set
# CONFIG_WM8350_POWER is not set
CONFIG_TEST_POWER=y
CONFIG_BATTERY_DS2780=y
# CONFIG_BATTERY_DS2781 is not set
CONFIG_BATTERY_DS2782=y
# CONFIG_BATTERY_SBS is not set
CONFIG_BATTERY_BQ27x00=y
CONFIG_BATTERY_BQ27X00_I2C=y
# CONFIG_BATTERY_BQ27X00_PLATFORM is not set
CONFIG_BATTERY_DA9052=y
# CONFIG_BATTERY_MAX17040 is not set
CONFIG_BATTERY_MAX17042=y
CONFIG_CHARGER_PCF50633=y
# CONFIG_CHARGER_MAX8903 is not set
CONFIG_CHARGER_LP8727=y
# CONFIG_CHARGER_MANAGER is not set
CONFIG_CHARGER_MAX8997=y
# CONFIG_CHARGER_BQ2415X is not set
CONFIG_CHARGER_SMB347=y
CONFIG_BATTERY_GOLDFISH=y
CONFIG_POWER_RESET=y
# CONFIG_POWER_AVS is not set
CONFIG_HWMON=y
CONFIG_HWMON_VID=y
# CONFIG_HWMON_DEBUG_CHIP is not set

#
# Native drivers
#
CONFIG_SENSORS_AD7414=y
# CONFIG_SENSORS_AD7418 is not set
# CONFIG_SENSORS_ADM1021 is not set
CONFIG_SENSORS_ADM1025=y
CONFIG_SENSORS_ADM1026=y
CONFIG_SENSORS_ADM1029=y
# CONFIG_SENSORS_ADM1031 is not set
CONFIG_SENSORS_ADM9240=y
# CONFIG_SENSORS_ADT7410 is not set
CONFIG_SENSORS_ADT7411=y
CONFIG_SENSORS_ADT7462=y
CONFIG_SENSORS_ADT7470=y
CONFIG_SENSORS_ADT7475=y
# CONFIG_SENSORS_ASC7621 is not set
CONFIG_SENSORS_K8TEMP=y
# CONFIG_SENSORS_K10TEMP is not set
# CONFIG_SENSORS_FAM15H_POWER is not set
# CONFIG_SENSORS_ASB100 is not set
# CONFIG_SENSORS_ATXP1 is not set
# CONFIG_SENSORS_DS620 is not set
# CONFIG_SENSORS_DS1621 is not set
# CONFIG_SENSORS_DA9052_ADC is not set
# CONFIG_SENSORS_I5K_AMB is not set
# CONFIG_SENSORS_F71805F is not set
CONFIG_SENSORS_F71882FG=y
CONFIG_SENSORS_F75375S=y
CONFIG_SENSORS_FSCHMD=y
CONFIG_SENSORS_G760A=y
# CONFIG_SENSORS_GL518SM is not set
# CONFIG_SENSORS_GL520SM is not set
# CONFIG_SENSORS_HIH6130 is not set
# CONFIG_SENSORS_CORETEMP is not set
# CONFIG_SENSORS_IBMAEM is not set
CONFIG_SENSORS_IBMPEX=y
CONFIG_SENSORS_IT87=y
# CONFIG_SENSORS_JC42 is not set
CONFIG_SENSORS_LINEAGE=y
CONFIG_SENSORS_LM63=y
CONFIG_SENSORS_LM73=y
# CONFIG_SENSORS_LM75 is not set
CONFIG_SENSORS_LM77=y
# CONFIG_SENSORS_LM78 is not set
CONFIG_SENSORS_LM80=y
# CONFIG_SENSORS_LM83 is not set
# CONFIG_SENSORS_LM85 is not set
# CONFIG_SENSORS_LM87 is not set
CONFIG_SENSORS_LM90=y
# CONFIG_SENSORS_LM92 is not set
CONFIG_SENSORS_LM93=y
CONFIG_SENSORS_LTC4151=y
# CONFIG_SENSORS_LTC4215 is not set
# CONFIG_SENSORS_LTC4245 is not set
CONFIG_SENSORS_LTC4261=y
CONFIG_SENSORS_LM95241=y
# CONFIG_SENSORS_LM95245 is not set
CONFIG_SENSORS_MAX16065=y
CONFIG_SENSORS_MAX1619=y
# CONFIG_SENSORS_MAX1668 is not set
CONFIG_SENSORS_MAX197=y
CONFIG_SENSORS_MAX6639=y
# CONFIG_SENSORS_MAX6642 is not set
CONFIG_SENSORS_MAX6650=y
CONFIG_SENSORS_MAX6697=y
# CONFIG_SENSORS_MCP3021 is not set
CONFIG_SENSORS_NTC_THERMISTOR=y
# CONFIG_SENSORS_PC87360 is not set
CONFIG_SENSORS_PC87427=y
CONFIG_SENSORS_PCF8591=y
CONFIG_PMBUS=y
CONFIG_SENSORS_PMBUS=y
# CONFIG_SENSORS_ADM1275 is not set
CONFIG_SENSORS_LM25066=y
# CONFIG_SENSORS_LTC2978 is not set
CONFIG_SENSORS_MAX16064=y
CONFIG_SENSORS_MAX34440=y
# CONFIG_SENSORS_MAX8688 is not set
# CONFIG_SENSORS_UCD9000 is not set
# CONFIG_SENSORS_UCD9200 is not set
# CONFIG_SENSORS_ZL6100 is not set
CONFIG_SENSORS_SHT21=y
# CONFIG_SENSORS_SIS5595 is not set
# CONFIG_SENSORS_SMM665 is not set
CONFIG_SENSORS_DME1737=y
# CONFIG_SENSORS_EMC1403 is not set
# CONFIG_SENSORS_EMC2103 is not set
CONFIG_SENSORS_EMC6W201=y
# CONFIG_SENSORS_SMSC47M1 is not set
CONFIG_SENSORS_SMSC47M192=y
CONFIG_SENSORS_SMSC47B397=y
# CONFIG_SENSORS_SCH56XX_COMMON is not set
CONFIG_SENSORS_ADS1015=y
# CONFIG_SENSORS_ADS7828 is not set
CONFIG_SENSORS_AMC6821=y
CONFIG_SENSORS_INA209=y
CONFIG_SENSORS_INA2XX=y
CONFIG_SENSORS_THMC50=y
# CONFIG_SENSORS_TMP102 is not set
# CONFIG_SENSORS_TMP401 is not set
# CONFIG_SENSORS_TMP421 is not set
CONFIG_SENSORS_VIA_CPUTEMP=y
# CONFIG_SENSORS_VIA686A is not set
# CONFIG_SENSORS_VT1211 is not set
# CONFIG_SENSORS_VT8231 is not set
# CONFIG_SENSORS_W83781D is not set
# CONFIG_SENSORS_W83791D is not set
CONFIG_SENSORS_W83792D=y
# CONFIG_SENSORS_W83793 is not set
CONFIG_SENSORS_W83795=y
CONFIG_SENSORS_W83795_FANCTRL=y
# CONFIG_SENSORS_W83L785TS is not set
CONFIG_SENSORS_W83L786NG=y
# CONFIG_SENSORS_W83627HF is not set
CONFIG_SENSORS_W83627EHF=y
CONFIG_SENSORS_WM8350=y
# CONFIG_SENSORS_APPLESMC is not set
CONFIG_SENSORS_MC13783_ADC=y

#
# ACPI drivers
#
# CONFIG_SENSORS_ACPI_POWER is not set
# CONFIG_SENSORS_ATK0110 is not set
CONFIG_THERMAL=y
CONFIG_THERMAL_HWMON=y
# CONFIG_THERMAL_DEFAULT_GOV_STEP_WISE is not set
# CONFIG_THERMAL_DEFAULT_GOV_FAIR_SHARE is not set
CONFIG_THERMAL_DEFAULT_GOV_USER_SPACE=y
# CONFIG_THERMAL_GOV_FAIR_SHARE is not set
# CONFIG_THERMAL_GOV_STEP_WISE is not set
CONFIG_THERMAL_GOV_USER_SPACE=y
CONFIG_CPU_THERMAL=y
# CONFIG_THERMAL_EMULATION is not set
# CONFIG_INTEL_POWERCLAMP is not set
# CONFIG_WATCHDOG is not set
CONFIG_SSB_POSSIBLE=y

#
# Sonics Silicon Backplane
#
# CONFIG_SSB is not set
CONFIG_BCMA_POSSIBLE=y

#
# Broadcom specific AMBA
#
# CONFIG_BCMA is not set

#
# Multifunction device drivers
#
CONFIG_MFD_CORE=y
# CONFIG_MFD_88PM860X is not set
# CONFIG_MFD_88PM800 is not set
# CONFIG_MFD_88PM805 is not set
CONFIG_MFD_SM501=y
CONFIG_MFD_RTSX_PCI=y
# CONFIG_MFD_TI_AM335X_TSCADC is not set
CONFIG_HTC_PASIC3=y
# CONFIG_MFD_LM3533 is not set
CONFIG_TPS6105X=y
# CONFIG_TPS6507X is not set
# CONFIG_MFD_TPS65217 is not set
CONFIG_MFD_TPS6586X=y
# CONFIG_MFD_TPS80031 is not set
# CONFIG_TWL4030_CORE is not set
# CONFIG_TWL6040_CORE is not set
# CONFIG_MFD_STMPE is not set
CONFIG_MFD_TC3589X=y
# CONFIG_MFD_TMIO is not set
CONFIG_MFD_SMSC=y
# CONFIG_PMIC_DA903X is not set
CONFIG_PMIC_DA9052=y
CONFIG_MFD_DA9052_I2C=y
# CONFIG_MFD_DA9055 is not set
# CONFIG_PMIC_ADP5520 is not set
CONFIG_MFD_LP8788=y
# CONFIG_MFD_MAX77686 is not set
# CONFIG_MFD_MAX77693 is not set
CONFIG_MFD_MAX8907=y
# CONFIG_MFD_MAX8925 is not set
CONFIG_MFD_MAX8997=y
# CONFIG_MFD_MAX8998 is not set
# CONFIG_MFD_SEC_CORE is not set
CONFIG_MFD_ARIZONA=y
CONFIG_MFD_ARIZONA_I2C=y
# CONFIG_MFD_WM5102 is not set
CONFIG_MFD_WM5110=y
# CONFIG_MFD_WM8400 is not set
# CONFIG_MFD_WM831X_I2C is not set
CONFIG_MFD_WM8350=y
CONFIG_MFD_WM8350_I2C=y
CONFIG_MFD_WM8994=y
CONFIG_MFD_PCF50633=y
CONFIG_PCF50633_ADC=y
# CONFIG_PCF50633_GPIO is not set
CONFIG_MFD_MC13783=y
CONFIG_MFD_MC13XXX=y
CONFIG_MFD_MC13XXX_I2C=y
# CONFIG_ABX500_CORE is not set
# CONFIG_MFD_CS5535 is not set
CONFIG_LPC_SCH=y
# CONFIG_LPC_ICH is not set
CONFIG_MFD_RDC321X=y
CONFIG_MFD_JANZ_CMODIO=y
CONFIG_MFD_VX855=y
CONFIG_MFD_WL1273_CORE=y
# CONFIG_MFD_TPS65090 is not set
# CONFIG_MFD_RC5T583 is not set
CONFIG_MFD_PALMAS=y
# CONFIG_MFD_RETU is not set
CONFIG_MFD_AS3711=y
CONFIG_REGULATOR=y
# CONFIG_REGULATOR_DEBUG is not set
# CONFIG_REGULATOR_DUMMY is not set
CONFIG_REGULATOR_FIXED_VOLTAGE=y
# CONFIG_REGULATOR_VIRTUAL_CONSUMER is not set
CONFIG_REGULATOR_USERSPACE_CONSUMER=y
# CONFIG_REGULATOR_AD5398 is not set
# CONFIG_REGULATOR_DA9052 is not set
# CONFIG_REGULATOR_FAN53555 is not set
CONFIG_REGULATOR_MC13XXX_CORE=y
# CONFIG_REGULATOR_MC13783 is not set
CONFIG_REGULATOR_MC13892=y
CONFIG_REGULATOR_ISL6271A=y
# CONFIG_REGULATOR_MAX1586 is not set
# CONFIG_REGULATOR_MAX8649 is not set
# CONFIG_REGULATOR_MAX8660 is not set
# CONFIG_REGULATOR_MAX8907 is not set
CONFIG_REGULATOR_MAX8952=y
CONFIG_REGULATOR_MAX8973=y
CONFIG_REGULATOR_MAX8997=y
# CONFIG_REGULATOR_LP3971 is not set
CONFIG_REGULATOR_LP3972=y
CONFIG_REGULATOR_LP872X=y
# CONFIG_REGULATOR_LP8755 is not set
# CONFIG_REGULATOR_LP8788 is not set
# CONFIG_REGULATOR_PCF50633 is not set
CONFIG_REGULATOR_PALMAS=y
# CONFIG_REGULATOR_TPS51632 is not set
CONFIG_REGULATOR_TPS6105X=y
CONFIG_REGULATOR_TPS62360=y
# CONFIG_REGULATOR_TPS65023 is not set
# CONFIG_REGULATOR_TPS6507X is not set
# CONFIG_REGULATOR_TPS6586X is not set
# CONFIG_REGULATOR_WM8350 is not set
# CONFIG_REGULATOR_WM8994 is not set
# CONFIG_REGULATOR_AS3711 is not set
# CONFIG_MEDIA_SUPPORT is not set

#
# Graphics support
#
# CONFIG_AGP is not set
# CONFIG_VGA_ARB is not set
# CONFIG_VGA_SWITCHEROO is not set
# CONFIG_DRM is not set
CONFIG_VGASTATE=y
# CONFIG_VIDEO_OUTPUT_CONTROL is not set
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
CONFIG_FB_FOREIGN_ENDIAN=y
# CONFIG_FB_BOTH_ENDIAN is not set
CONFIG_FB_BIG_ENDIAN=y
# CONFIG_FB_LITTLE_ENDIAN is not set
CONFIG_FB_SYS_FOPS=y
# CONFIG_FB_WMT_GE_ROPS is not set
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
# CONFIG_FB_CIRRUS is not set
# CONFIG_FB_PM2 is not set
# CONFIG_FB_CYBER2000 is not set
CONFIG_FB_ARC=y
# CONFIG_FB_ASILIANT is not set
CONFIG_FB_IMSTT=y
# CONFIG_FB_VGA16 is not set
# CONFIG_FB_VESA is not set
CONFIG_FB_N411=y
# CONFIG_FB_HGA is not set
# CONFIG_FB_S1D13XXX is not set
# CONFIG_FB_NVIDIA is not set
# CONFIG_FB_RIVA is not set
CONFIG_FB_I740=y
CONFIG_FB_LE80578=y
CONFIG_FB_CARILLO_RANCH=y
# CONFIG_FB_MATROX is not set
# CONFIG_FB_RADEON is not set
# CONFIG_FB_ATY128 is not set
CONFIG_FB_ATY=y
# CONFIG_FB_ATY_CT is not set
# CONFIG_FB_ATY_GX is not set
# CONFIG_FB_ATY_BACKLIGHT is not set
# CONFIG_FB_S3 is not set
CONFIG_FB_SAVAGE=y
# CONFIG_FB_SAVAGE_I2C is not set
# CONFIG_FB_SAVAGE_ACCEL is not set
CONFIG_FB_SIS=y
CONFIG_FB_SIS_300=y
CONFIG_FB_SIS_315=y
# CONFIG_FB_VIA is not set
# CONFIG_FB_NEOMAGIC is not set
CONFIG_FB_KYRO=y
# CONFIG_FB_3DFX is not set
CONFIG_FB_VOODOO1=y
# CONFIG_FB_VT8623 is not set
CONFIG_FB_TRIDENT=y
CONFIG_FB_ARK=y
CONFIG_FB_PM3=y
CONFIG_FB_CARMINE=y
CONFIG_FB_CARMINE_DRAM_EVAL=y
# CONFIG_CARMINE_DRAM_CUSTOM is not set
CONFIG_FB_GEODE=y
# CONFIG_FB_GEODE_LX is not set
CONFIG_FB_GEODE_GX=y
# CONFIG_FB_GEODE_GX1 is not set
# CONFIG_FB_TMIO is not set
CONFIG_FB_SM501=y
# CONFIG_FB_GOLDFISH is not set
# CONFIG_FB_VIRTUAL is not set
CONFIG_FB_METRONOME=y
CONFIG_FB_MB862XX=y
CONFIG_FB_MB862XX_PCI_GDC=y
# CONFIG_FB_MB862XX_I2C is not set
# CONFIG_FB_BROADSHEET is not set
# CONFIG_FB_AUO_K190X is not set
CONFIG_EXYNOS_VIDEO=y
CONFIG_BACKLIGHT_LCD_SUPPORT=y
# CONFIG_LCD_CLASS_DEVICE is not set
CONFIG_BACKLIGHT_CLASS_DEVICE=y
# CONFIG_BACKLIGHT_GENERIC is not set
CONFIG_BACKLIGHT_PWM=y
CONFIG_BACKLIGHT_DA9052=y
# CONFIG_BACKLIGHT_APPLE is not set
CONFIG_BACKLIGHT_SAHARA=y
CONFIG_BACKLIGHT_ADP8860=y
CONFIG_BACKLIGHT_ADP8870=y
CONFIG_BACKLIGHT_PCF50633=y
# CONFIG_BACKLIGHT_LM3630 is not set
# CONFIG_BACKLIGHT_LM3639 is not set
CONFIG_BACKLIGHT_LP855X=y
# CONFIG_BACKLIGHT_LP8788 is not set
# CONFIG_BACKLIGHT_AS3711 is not set
# CONFIG_LOGO is not set
# CONFIG_SOUND is not set

#
# HID support
#
# CONFIG_HID is not set

#
# I2C HID support
#
# CONFIG_I2C_HID is not set
CONFIG_USB_ARCH_HAS_OHCI=y
CONFIG_USB_ARCH_HAS_EHCI=y
CONFIG_USB_ARCH_HAS_XHCI=y
CONFIG_USB_SUPPORT=y
CONFIG_USB_ARCH_HAS_HCD=y
# CONFIG_USB is not set
# CONFIG_USB_OTG_WHITELIST is not set
# CONFIG_USB_OTG_BLACKLIST_HUB is not set

#
# NOTE: USB_STORAGE depends on SCSI but BLK_DEV_SD may
#
# CONFIG_USB_HSIC_USB3503 is not set
# CONFIG_OMAP_USB3 is not set
# CONFIG_OMAP_CONTROL_USB is not set
# CONFIG_USB_GADGET is not set

#
# OTG and related infrastructure
#
CONFIG_UWB=y
CONFIG_UWB_WHCI=y
CONFIG_MMC=y
CONFIG_MMC_DEBUG=y
CONFIG_MMC_UNSAFE_RESUME=y
CONFIG_MMC_CLKGATE=y

#
# MMC/SD/SDIO Card Drivers
#
# CONFIG_SDIO_UART is not set
CONFIG_MMC_TEST=y

#
# MMC/SD/SDIO Host Controller Drivers
#
# CONFIG_MMC_SDHCI is not set
# CONFIG_MMC_WBSD is not set
# CONFIG_MMC_TIFM_SD is not set
# CONFIG_MMC_SDRICOH_CS is not set
# CONFIG_MMC_CB710 is not set
CONFIG_MMC_VIA_SDMMC=y
CONFIG_MMC_REALTEK_PCI=y
CONFIG_MEMSTICK=y
# CONFIG_MEMSTICK_DEBUG is not set

#
# MemoryStick drivers
#
CONFIG_MEMSTICK_UNSAFE_RESUME=y

#
# MemoryStick Host Controller Drivers
#
# CONFIG_MEMSTICK_TIFM_MS is not set
CONFIG_MEMSTICK_JMICRON_38X=y
CONFIG_MEMSTICK_R592=y
CONFIG_MEMSTICK_REALTEK_PCI=y
CONFIG_NEW_LEDS=y
CONFIG_LEDS_CLASS=y

#
# LED drivers
#
# CONFIG_LEDS_LM3530 is not set
# CONFIG_LEDS_LM3642 is not set
CONFIG_LEDS_PCA9532=y
# CONFIG_LEDS_LP3944 is not set
# CONFIG_LEDS_LP5521 is not set
# CONFIG_LEDS_LP5523 is not set
# CONFIG_LEDS_LP8788 is not set
CONFIG_LEDS_PCA955X=y
# CONFIG_LEDS_PCA9633 is not set
CONFIG_LEDS_WM8350=y
# CONFIG_LEDS_DA9052 is not set
# CONFIG_LEDS_PWM is not set
# CONFIG_LEDS_REGULATOR is not set
CONFIG_LEDS_BD2802=y
CONFIG_LEDS_MC13783=y
# CONFIG_LEDS_TCA6507 is not set
# CONFIG_LEDS_MAX8997 is not set
CONFIG_LEDS_LM355x=y
# CONFIG_LEDS_OT200 is not set
CONFIG_LEDS_BLINKM=y
# CONFIG_LEDS_TRIGGERS is not set

#
# LED Triggers
#
# CONFIG_ACCESSIBILITY is not set
# CONFIG_INFINIBAND is not set
CONFIG_EDAC=y
# CONFIG_EDAC_LEGACY_SYSFS is not set
# CONFIG_EDAC_DEBUG is not set
CONFIG_EDAC_MM_EDAC=y
# CONFIG_EDAC_E752X is not set
CONFIG_EDAC_I82975X=y
CONFIG_EDAC_I3000=y
# CONFIG_EDAC_I3200 is not set
CONFIG_EDAC_X38=y
# CONFIG_EDAC_I5400 is not set
CONFIG_EDAC_I5000=y
CONFIG_EDAC_I5100=y
CONFIG_EDAC_I7300=y
CONFIG_RTC_LIB=y
CONFIG_RTC_CLASS=y
# CONFIG_RTC_DEBUG is not set

#
# RTC interfaces
#
# CONFIG_RTC_INTF_SYSFS is not set
# CONFIG_RTC_INTF_DEV is not set
CONFIG_RTC_DRV_TEST=y

#
# I2C RTC drivers
#
CONFIG_RTC_DRV_DS1307=y
CONFIG_RTC_DRV_DS1374=y
CONFIG_RTC_DRV_DS1672=y
# CONFIG_RTC_DRV_DS3232 is not set
# CONFIG_RTC_DRV_LP8788 is not set
CONFIG_RTC_DRV_MAX6900=y
CONFIG_RTC_DRV_MAX8907=y
CONFIG_RTC_DRV_MAX8997=y
CONFIG_RTC_DRV_RS5C372=y
CONFIG_RTC_DRV_ISL1208=y
CONFIG_RTC_DRV_ISL12022=y
# CONFIG_RTC_DRV_X1205 is not set
# CONFIG_RTC_DRV_PALMAS is not set
CONFIG_RTC_DRV_PCF8523=y
# CONFIG_RTC_DRV_PCF8563 is not set
CONFIG_RTC_DRV_PCF8583=y
CONFIG_RTC_DRV_M41T80=y
CONFIG_RTC_DRV_M41T80_WDT=y
# CONFIG_RTC_DRV_BQ32K is not set
CONFIG_RTC_DRV_TPS6586X=y
CONFIG_RTC_DRV_S35390A=y
# CONFIG_RTC_DRV_FM3130 is not set
CONFIG_RTC_DRV_RX8581=y
CONFIG_RTC_DRV_RX8025=y
CONFIG_RTC_DRV_EM3027=y
# CONFIG_RTC_DRV_RV3029C2 is not set

#
# SPI RTC drivers
#

#
# Platform RTC drivers
#
# CONFIG_RTC_DRV_CMOS is not set
CONFIG_RTC_DRV_DS1286=y
# CONFIG_RTC_DRV_DS1511 is not set
# CONFIG_RTC_DRV_DS1553 is not set
CONFIG_RTC_DRV_DS1742=y
# CONFIG_RTC_DRV_DA9052 is not set
# CONFIG_RTC_DRV_STK17TA8 is not set
# CONFIG_RTC_DRV_M48T86 is not set
CONFIG_RTC_DRV_M48T35=y
CONFIG_RTC_DRV_M48T59=y
CONFIG_RTC_DRV_MSM6242=y
CONFIG_RTC_DRV_BQ4802=y
# CONFIG_RTC_DRV_RP5C01 is not set
CONFIG_RTC_DRV_V3020=y
CONFIG_RTC_DRV_DS2404=y
# CONFIG_RTC_DRV_WM8350 is not set
# CONFIG_RTC_DRV_PCF50633 is not set

#
# on-CPU RTC drivers
#
# CONFIG_RTC_DRV_MC13XXX is not set

#
# HID Sensor RTC drivers
#
CONFIG_DMADEVICES=y
CONFIG_DMADEVICES_DEBUG=y
# CONFIG_DMADEVICES_VDEBUG is not set

#
# DMA Devices
#
CONFIG_INTEL_MID_DMAC=y
# CONFIG_INTEL_IOATDMA is not set
# CONFIG_DW_DMAC is not set
# CONFIG_TIMB_DMA is not set
CONFIG_PCH_DMA=y
CONFIG_DMA_ENGINE=y

#
# DMA Clients
#
# CONFIG_NET_DMA is not set
CONFIG_ASYNC_TX_DMA=y
CONFIG_DMATEST=y
# CONFIG_AUXDISPLAY is not set
# CONFIG_UIO is not set
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
# CONFIG_FUJITSU_LAPTOP is not set
# CONFIG_FUJITSU_TABLET is not set
# CONFIG_HP_ACCEL is not set
# CONFIG_PANASONIC_LAPTOP is not set
# CONFIG_THINKPAD_ACPI is not set
CONFIG_SENSORS_HDAPS=y
# CONFIG_INTEL_MENLOW is not set
# CONFIG_EEEPC_LAPTOP is not set
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

#
# Hardware Spinlock drivers
#
CONFIG_CLKEVT_I8253=y
CONFIG_CLKBLD_I8253=y
CONFIG_MAILBOX=y
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
CONFIG_VIRT_DRIVERS=y
# CONFIG_PM_DEVFREQ is not set
# CONFIG_EXTCON is not set
# CONFIG_MEMORY is not set
# CONFIG_IIO is not set
CONFIG_NTB=y
# CONFIG_VME_BUS is not set
CONFIG_PWM=y
CONFIG_IPACK_BUS=y
CONFIG_BOARD_TPCI200=y
CONFIG_SERIAL_IPOCTAL=y

#
# Firmware Drivers
#
CONFIG_EDD=y
# CONFIG_EDD_OFF is not set
# CONFIG_FIRMWARE_MEMMAP is not set
# CONFIG_DELL_RBU is not set
# CONFIG_DCDBAS is not set
CONFIG_ISCSI_IBFT_FIND=y
# CONFIG_GOOGLE_FIRMWARE is not set

#
# File systems
#
CONFIG_DCACHE_WORD_ACCESS=y
# CONFIG_FS_POSIX_ACL is not set
CONFIG_EXPORTFS=y
# CONFIG_FILE_LOCKING is not set
CONFIG_FSNOTIFY=y
# CONFIG_DNOTIFY is not set
CONFIG_INOTIFY_USER=y
# CONFIG_FANOTIFY is not set
# CONFIG_QUOTA is not set
# CONFIG_QUOTACTL is not set
# CONFIG_AUTOFS4_FS is not set
CONFIG_FUSE_FS=y
# CONFIG_CUSE is not set

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
# CONFIG_NLS_CODEPAGE_775 is not set
# CONFIG_NLS_CODEPAGE_850 is not set
# CONFIG_NLS_CODEPAGE_852 is not set
# CONFIG_NLS_CODEPAGE_855 is not set
# CONFIG_NLS_CODEPAGE_857 is not set
# CONFIG_NLS_CODEPAGE_860 is not set
# CONFIG_NLS_CODEPAGE_861 is not set
# CONFIG_NLS_CODEPAGE_862 is not set
# CONFIG_NLS_CODEPAGE_863 is not set
# CONFIG_NLS_CODEPAGE_864 is not set
# CONFIG_NLS_CODEPAGE_865 is not set
# CONFIG_NLS_CODEPAGE_866 is not set
# CONFIG_NLS_CODEPAGE_869 is not set
# CONFIG_NLS_CODEPAGE_936 is not set
# CONFIG_NLS_CODEPAGE_950 is not set
# CONFIG_NLS_CODEPAGE_932 is not set
# CONFIG_NLS_CODEPAGE_949 is not set
# CONFIG_NLS_CODEPAGE_874 is not set
# CONFIG_NLS_ISO8859_8 is not set
# CONFIG_NLS_CODEPAGE_1250 is not set
# CONFIG_NLS_CODEPAGE_1251 is not set
# CONFIG_NLS_ASCII is not set
# CONFIG_NLS_ISO8859_1 is not set
# CONFIG_NLS_ISO8859_2 is not set
# CONFIG_NLS_ISO8859_3 is not set
# CONFIG_NLS_ISO8859_4 is not set
# CONFIG_NLS_ISO8859_5 is not set
# CONFIG_NLS_ISO8859_6 is not set
# CONFIG_NLS_ISO8859_7 is not set
# CONFIG_NLS_ISO8859_9 is not set
# CONFIG_NLS_ISO8859_13 is not set
# CONFIG_NLS_ISO8859_14 is not set
# CONFIG_NLS_ISO8859_15 is not set
# CONFIG_NLS_KOI8_R is not set
# CONFIG_NLS_KOI8_U is not set
# CONFIG_NLS_MAC_ROMAN is not set
# CONFIG_NLS_MAC_CELTIC is not set
# CONFIG_NLS_MAC_CENTEURO is not set
# CONFIG_NLS_MAC_CROATIAN is not set
# CONFIG_NLS_MAC_CYRILLIC is not set
# CONFIG_NLS_MAC_GAELIC is not set
# CONFIG_NLS_MAC_GREEK is not set
# CONFIG_NLS_MAC_ICELAND is not set
# CONFIG_NLS_MAC_INUIT is not set
# CONFIG_NLS_MAC_ROMANIAN is not set
# CONFIG_NLS_MAC_TURKISH is not set
# CONFIG_NLS_UTF8 is not set

#
# Kernel hacking
#
CONFIG_TRACE_IRQFLAGS_SUPPORT=y
CONFIG_PRINTK_TIME=y
CONFIG_DEFAULT_MESSAGE_LOGLEVEL=4
# CONFIG_ENABLE_WARN_DEPRECATED is not set
CONFIG_ENABLE_MUST_CHECK=y
CONFIG_FRAME_WARN=2048
CONFIG_MAGIC_SYSRQ=y
CONFIG_STRIP_ASM_SYMS=y
CONFIG_READABLE_ASM=y
CONFIG_UNUSED_SYMBOLS=y
CONFIG_DEBUG_FS=y
# CONFIG_HEADERS_CHECK is not set
# CONFIG_DEBUG_SECTION_MISMATCH is not set
CONFIG_DEBUG_KERNEL=y
# CONFIG_DEBUG_SHIRQ is not set
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
CONFIG_DEBUG_OBJECTS_TIMERS=y
CONFIG_DEBUG_OBJECTS_WORK=y
# CONFIG_DEBUG_OBJECTS_RCU_HEAD is not set
# CONFIG_DEBUG_OBJECTS_PERCPU_COUNTER is not set
CONFIG_DEBUG_OBJECTS_ENABLE_DEFAULT=1
# CONFIG_SLUB_DEBUG_ON is not set
CONFIG_SLUB_STATS=y
CONFIG_HAVE_DEBUG_KMEMLEAK=y
# CONFIG_DEBUG_KMEMLEAK is not set
# CONFIG_DEBUG_PREEMPT is not set
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
CONFIG_DEBUG_LOCKING_API_SELFTESTS=y
CONFIG_STACKTRACE=y
CONFIG_DEBUG_STACK_USAGE=y
# CONFIG_DEBUG_KOBJECT is not set
# CONFIG_DEBUG_BUGVERBOSE is not set
CONFIG_DEBUG_INFO=y
CONFIG_DEBUG_VM=y
# CONFIG_DEBUG_VM_RB is not set
# CONFIG_DEBUG_VIRTUAL is not set
# CONFIG_DEBUG_WRITECOUNT is not set
CONFIG_DEBUG_MEMORY_INIT=y
CONFIG_DEBUG_LIST=y
# CONFIG_TEST_LIST_SORT is not set
# CONFIG_DEBUG_SG is not set
CONFIG_DEBUG_NOTIFIERS=y
# CONFIG_DEBUG_CREDENTIALS is not set
CONFIG_ARCH_WANT_FRAME_POINTERS=y
CONFIG_FRAME_POINTER=y
# CONFIG_BOOT_PRINTK_DELAY is not set

#
# RCU Debugging
#
CONFIG_PROVE_RCU=y
# CONFIG_PROVE_RCU_REPEATEDLY is not set
# CONFIG_PROVE_RCU_DELAY is not set
CONFIG_SPARSE_RCU_POINTER=y
# CONFIG_RCU_TORTURE_TEST is not set
CONFIG_RCU_CPU_STALL_TIMEOUT=21
CONFIG_RCU_CPU_STALL_VERBOSE=y
CONFIG_RCU_CPU_STALL_INFO=y
# CONFIG_RCU_TRACE is not set
# CONFIG_BACKTRACE_SELF_TEST is not set
CONFIG_DEBUG_FORCE_WEAK_PER_CPU=y
CONFIG_DEBUG_PER_CPU_MAPS=y
# CONFIG_NOTIFIER_ERROR_INJECTION is not set
CONFIG_FAULT_INJECTION=y
CONFIG_FAILSLAB=y
CONFIG_FAIL_PAGE_ALLOC=y
CONFIG_FAIL_MMC_REQUEST=y
# CONFIG_FAULT_INJECTION_DEBUG_FS is not set
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
# CONFIG_PREEMPT_TRACER is not set
CONFIG_SCHED_TRACER=y
# CONFIG_FTRACE_SYSCALLS is not set
# CONFIG_TRACER_SNAPSHOT is not set
CONFIG_TRACE_BRANCH_PROFILING=y
# CONFIG_BRANCH_PROFILE_NONE is not set
CONFIG_PROFILE_ANNOTATED_BRANCHES=y
# CONFIG_PROFILE_ALL_BRANCHES is not set
# CONFIG_BRANCH_TRACER is not set
# CONFIG_STACK_TRACER is not set
# CONFIG_UPROBE_EVENT is not set
# CONFIG_PROBE_EVENTS is not set
CONFIG_DYNAMIC_FTRACE=y
CONFIG_DYNAMIC_FTRACE_WITH_REGS=y
CONFIG_FUNCTION_PROFILER=y
CONFIG_FTRACE_MCOUNT_RECORD=y
CONFIG_FTRACE_SELFTEST=y
CONFIG_FTRACE_STARTUP_TEST=y
# CONFIG_EVENT_TRACE_TEST_SYSCALLS is not set
CONFIG_MMIOTRACE=y
CONFIG_RING_BUFFER_BENCHMARK=y
# CONFIG_PROVIDE_OHCI1394_DMA_INIT is not set
# CONFIG_DYNAMIC_DEBUG is not set
CONFIG_DMA_API_DEBUG=y
CONFIG_ATOMIC64_SELFTEST=y
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
CONFIG_DEBUG_RODATA=y
CONFIG_DEBUG_RODATA_TEST=y
# CONFIG_DEBUG_TLBFLUSH is not set
# CONFIG_IOMMU_DEBUG is not set
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
CONFIG_CPA_DEBUG=y
# CONFIG_OPTIMIZE_INLINING is not set
# CONFIG_DEBUG_NMI_SELFTEST is not set

#
# Security options
#
CONFIG_KEYS=y
# CONFIG_ENCRYPTED_KEYS is not set
# CONFIG_KEYS_DEBUG_PROC_KEYS is not set
# CONFIG_SECURITY_DMESG_RESTRICT is not set
# CONFIG_SECURITY is not set
CONFIG_SECURITYFS=y
CONFIG_DEFAULT_SECURITY_DAC=y
CONFIG_DEFAULT_SECURITY=""
# CONFIG_CRYPTO is not set
CONFIG_HAVE_KVM=y
CONFIG_VIRTUALIZATION=y
# CONFIG_KVM is not set
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
# CONFIG_CRC_CCITT is not set
CONFIG_CRC16=y
# CONFIG_CRC_T10DIF is not set
# CONFIG_CRC_ITU_T is not set
CONFIG_CRC32=y
# CONFIG_CRC32_SELFTEST is not set
# CONFIG_CRC32_SLICEBY8 is not set
CONFIG_CRC32_SLICEBY4=y
# CONFIG_CRC32_SARWATE is not set
# CONFIG_CRC32_BIT is not set
CONFIG_CRC7=y
# CONFIG_LIBCRC32C is not set
CONFIG_CRC8=y
CONFIG_ZLIB_INFLATE=y
CONFIG_LZO_COMPRESS=y
CONFIG_LZO_DECOMPRESS=y
# CONFIG_XZ_DEC is not set
# CONFIG_XZ_DEC_BCJ is not set
CONFIG_DECOMPRESS_GZIP=y
CONFIG_HAS_IOMEM=y
CONFIG_HAS_IOPORT=y
CONFIG_HAS_DMA=y
# CONFIG_CPUMASK_OFFSTACK is not set
CONFIG_CPU_RMAP=y
CONFIG_DQL=y
CONFIG_NLATTR=y
CONFIG_ARCH_HAS_ATOMIC64_DEC_IF_POSITIVE=y
# CONFIG_AVERAGE is not set
# CONFIG_CORDIC is not set
CONFIG_DDR=y
# CONFIG_IIO_SIMPLE_DUMMY is not set
# CONFIG_ATA_SFF is not set
# CONFIG_DRM_TTM is not set
# CONFIG_ISDN_DRV_LOOP is not set

--LZvS9be/3tNcYl/X--
