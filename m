Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754199Ab3FOCgv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Jun 2013 22:36:51 -0400
Received: from mga14.intel.com ([143.182.124.37]:7458 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753097Ab3FOCgq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Jun 2013 22:36:46 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,870,1363158000"; 
   d="log'?scan'208";a="350158921"
Date: Sat, 15 Jun 2013 10:36:20 +0800
From: Fengguang Wu <fengguang.wu@intel.com>
To: linux-fsdevel@vger.kernel.org
Cc: fengguang.wu@intel.com, Jan Kara <jack@suse.cz>, Ben Myers <bpm@sgi.com>,
        linux-kernel@vger.kernel.org
Subject: XFS (vdb): Corruption detected. Unmount and run xfs_repair
Message-ID: <20130615023620.GA23586@localhost>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="fUYQa+Pmc3FrFX/N"
Content-Disposition: inline
User-Agent: Heirloom mailx 12.5 6/20/10
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--fUYQa+Pmc3FrFX/N
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Greetings,

I got the below dmesg in both upstream and linux-next, and the first
bad commit *might be* commit 211d022c43ca ("xfs: Avoid pathological
backwards allocation").
    
[   74.595386] 
[   74.603826] CPU: 0 PID: 2137 Comm: kworker/0:1H Not tainted 3.10.0-rc1-00031-gade1335 #1508
[   74.609255] Hardware name: Bochs Bochs, BIOS Bochs 01/01/2007
[   74.612498] Workqueue: xfslogd xfs_buf_iodone_work
[   74.615690]  0000000000000001 ffff880016815c68 ffffffff81aa456f ffff880016815c88
[   74.621548]  ffffffff8130b179 ffffffff81309514 0000000000000001 ffff880016815cc8
[   74.627417]  ffffffff8130b1d0 0000000000000000 00000000000002da 0000000000000016
[   74.633321] Call Trace:
[   74.635427]  [<ffffffff81aa456f>] dump_stack+0x19/0x1b
[   74.638412]  [<ffffffff8130b179>] xfs_error_report+0x3d/0x3f
[   74.641627]  [<ffffffff81309514>] ? xfs_buf_iodone_work+0x4a/0x83
[   74.644970]  [<ffffffff8130b1d0>] xfs_corruption_error+0x55/0x71
[   74.648217]  [<ffffffff81352ce1>] xfs_sb_read_verify+0xee/0x105
[   74.651478]  [<ffffffff81309514>] ? xfs_buf_iodone_work+0x4a/0x83
[   74.654820]  [<ffffffff8108045d>] ? ftrace_raw_event_workqueue_execute_start+0x92/0xa1
[   74.659821]  [<ffffffff81309514>] xfs_buf_iodone_work+0x4a/0x83
[   74.663042]  [<ffffffff81082561>] process_one_work+0x26c/0x470
[   74.666296]  [<ffffffff810824bf>] ? process_one_work+0x1ca/0x470
[   74.669647]  [<ffffffff81082ee6>] worker_thread+0x1d0/0x2cb
[   74.672770]  [<ffffffff81082d16>] ? manage_workers.isra.19+0x1c3/0x1c3
[   74.676201]  [<ffffffff8108a590>] kthread+0xd5/0xdd
[   74.679151]  [<ffffffff810bd47c>] ? trace_hardirqs_on+0xd/0xf
[   74.682411]  [<ffffffff8108a4bb>] ? __init_kthread_worker+0x5a/0x5a
[   74.685776]  [<ffffffff81ab74dc>] ret_from_fork+0x7c/0xb0
[   74.688798]  [<ffffffff8108a4bb>] ? __init_kthread_worker+0x5a/0x5a
[   74.692206] XFS (vdb): Corruption detected. Unmount and run xfs_repair
[   74.696000] XFS (vdb): SB validate failed with error 22.

I'm not sure whether it's the first bad commit because

- the parent commit f722406faae2d073cc1d01063d1123c35425939e reliably
  crashes in a slightly earlier boot stage (2nd dmesg)

- the error is still there after reverting the patch

The bisect log does indicate that the error is introduced somewhere
after v3.10-rc1.

git bisect start ade1335afef556df6538eb02e8c0dc91fbd9cc37 f722406faae2d073cc1d01063d1123c35425939e --
git bisect  bad d4c712bcf26a25c2b67c90e44e0b74c7993b5334  # 06:21      0-  xfs: fully initialise temp leaf in xfs_attr3_leaf_compact
git bisect  bad b38958d715316031fe9ea0cc6c22043072a55f49  # 06:27      0-  xfs: xfs_attr_shortform_allfit() does not handle attr3 format.
git bisect  bad 28ca489c63e9aceed8801d2f82d731b3c9aa50f5  # 06:35      1-  xfs: fix rounding in xfs_free_file_space
git bisect  bad 49b137cbbcc836ef231866c137d24f42c42bb483  # 06:41      0-  xfs: fix sub-page blocksize data integrity writes
git bisect  bad 211d022c43cac3aecbe967fcaf9b10156bfa63ad  # 06:47      0-  xfs: Avoid pathological backwards allocation
git bisect good f722406faae2d073cc1d01063d1123c35425939e  # 09:52    300+  Linux 3.10-rc1
git bisect  bad ade1335afef556df6538eb02e8c0dc91fbd9cc37  # 09:52      0-  xfs: ensure btree root split sets blkno correctly
git bisect  bad 7872bbb055d8070cdd8e7691d7a4181fbfa43caa  # 09:59      2-  Revert "xfs: Avoid pathological backwards allocation"
git bisect  bad a2648ebb7ed69ef209d9c8a76fadeb3252d9a023  # 10:03      9-  Merge branch 'for-linus' of git://git.kernel.org/pub/scm/linux/kernel/git/mason/linux-btrfs
git bisect  bad c04efed734409f5a44715b54a6ca1b54b0ccf215  # 10:06      0-  Add linux-next specific files for 20130607

Thanks,
Fengguang

--fUYQa+Pmc3FrFX/N
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="dmesg-kvm-kbuild-31646-20130615005640-3.10.0-rc1-00031-gade1335-1508"

[    0.000000] Initializing cgroup subsys cpuset
[    0.000000] Initializing cgroup subsys cpu
[    0.000000] Linux version 3.10.0-rc1-00031-gade1335 (kbuild@inn) (gcc version 4.7.1 (Debian 4.7.1-6) ) #1508 SMP Fri Jun 14 21:57:44 CST 2013
[    0.000000] Command line: hung_task_panic=1 rcutree.rcu_cpu_stall_timeout=100 log_buf_len=8M ignore_loglevel debug sched_debug apic=debug dynamic_printk sysrq_always_enabled panic=10 load_ramdisk=2 prompt_ramdisk=0 console=ttyS0,115200 console=tty0 vga=normal ip=::::kvm::dhcp nfsroot=192.168.1.1:/nfsroot/wfg,tcp,v3,nocto,actimeo=600,nolock,rsize=524288,wsize=524288 rw link=/kernel-tests/run-queue/kvm/x86_64-nfsroot/xfs:for-next/.vmlinuz-ade1335afef556df6538eb02e8c0dc91fbd9cc37-20130614215817-9-kbuild branch=xfs/for-next  BOOT_IMAGE=/kernel/x86_64-nfsroot/ade1335afef556df6538eb02e8c0dc91fbd9cc37/vmlinuz-3.10.0-rc1-00031-gade1335
[    0.000000] KERNEL supported cpus:
[    0.000000]   Intel GenuineIntel
[    0.000000]   Centaur CentaurHauls
[    0.000000] e820: BIOS-provided physical RAM map:
[    0.000000] BIOS-e820: [mem 0x0000000000000000-0x0000000000093bff] usable
[    0.000000] BIOS-e820: [mem 0x0000000000093c00-0x000000000009ffff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000000f0000-0x00000000000fffff] reserved
[    0.000000] BIOS-e820: [mem 0x0000000000100000-0x000000001fffdfff] usable
[    0.000000] BIOS-e820: [mem 0x000000001fffe000-0x000000001fffffff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000feffc000-0x00000000feffffff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000fffc0000-0x00000000ffffffff] reserved
[    0.000000] debug: ignoring loglevel setting.
[    0.000000] NX (Execute Disable) protection: active
[    0.000000] SMBIOS 2.4 present.
[    0.000000] DMI: Bochs Bochs, BIOS Bochs 01/01/2007
[    0.000000] e820: update [mem 0x00000000-0x00000fff] usable ==> reserved
[    0.000000] e820: remove [mem 0x000a0000-0x000fffff] usable
[    0.000000] e820: last_pfn = 0x1fffe max_arch_pfn = 0x400000000
[    0.000000] MTRR default type: write-back
[    0.000000] MTRR fixed ranges enabled:
[    0.000000]   00000-9FFFF write-back
[    0.000000]   A0000-BFFFF uncachable
[    0.000000]   C0000-FFFFF write-protect
[    0.000000] MTRR variable ranges enabled:
[    0.000000]   0 base 00E0000000 mask FFE0000000 uncachable
[    0.000000]   1 disabled
[    0.000000]   2 disabled
[    0.000000]   3 disabled
[    0.000000]   4 disabled
[    0.000000]   5 disabled
[    0.000000]   6 disabled
[    0.000000]   7 disabled
[    0.000000] x86 PAT enabled: cpu 0, old 0x70406, new 0x7010600070106
[    0.000000] Scan for SMP in [mem 0x00000000-0x000003ff]
[    0.000000] Scan for SMP in [mem 0x0009fc00-0x0009ffff]
[    0.000000] Scan for SMP in [mem 0x000f0000-0x000fffff]
[    0.000000] found SMP MP-table at [mem 0x000fdab0-0x000fdabf] mapped at [ffff8800000fdab0]
[    0.000000]   mpc: fdac0-fdbe4
[    0.000000] Scanning 1 areas for low memory corruption
[    0.000000] Base memory trampoline at [ffff88000008d000] 8d000 size 24576
[    0.000000] init_memory_mapping: [mem 0x00000000-0x000fffff]
[    0.000000]  [mem 0x00000000-0x000fffff] page 4k
[    0.000000] BRK [0x02fa1000, 0x02fa1fff] PGTABLE
[    0.000000] BRK [0x02fa2000, 0x02fa2fff] PGTABLE
[    0.000000] BRK [0x02fa3000, 0x02fa3fff] PGTABLE
[    0.000000] init_memory_mapping: [mem 0x1fc00000-0x1fdfffff]
[    0.000000]  [mem 0x1fc00000-0x1fdfffff] page 2M
[    0.000000] init_memory_mapping: [mem 0x1c000000-0x1fbfffff]
[    0.000000]  [mem 0x1c000000-0x1fbfffff] page 2M
[    0.000000] init_memory_mapping: [mem 0x00100000-0x1bffffff]
[    0.000000]  [mem 0x00100000-0x001fffff] page 4k
[    0.000000]  [mem 0x00200000-0x1bffffff] page 2M
[    0.000000] init_memory_mapping: [mem 0x1fe00000-0x1fffdfff]
[    0.000000]  [mem 0x1fe00000-0x1fffdfff] page 4k
[    0.000000] BRK [0x02fa4000, 0x02fa4fff] PGTABLE
[    0.000000] log_buf_len: 8388608
[    0.000000] early log buf free: 258228(98%)
[    0.000000] ACPI: RSDP 00000000000fd920 00014 (v00 BOCHS )
[    0.000000] ACPI: RSDT 000000001fffe550 00038 (v01 BOCHS  BXPCRSDT 00000001 BXPC 00000001)
[    0.000000] ACPI: FACP 000000001fffff80 00074 (v01 BOCHS  BXPCFACP 00000001 BXPC 00000001)
[    0.000000] ACPI: DSDT 000000001fffe590 01121 (v01   BXPC   BXDSDT 00000001 INTL 20100528)
[    0.000000] ACPI: FACS 000000001fffff40 00040
[    0.000000] ACPI: SSDT 000000001ffffe40 000FF (v01 BOCHS  BXPCSSDT 00000001 BXPC 00000001)
[    0.000000] ACPI: APIC 000000001ffffd50 00080 (v01 BOCHS  BXPCAPIC 00000001 BXPC 00000001)
[    0.000000] ACPI: HPET 000000001ffffd10 00038 (v01 BOCHS  BXPCHPET 00000001 BXPC 00000001)
[    0.000000] ACPI: SSDT 000000001ffff6c0 00644 (v01   BXPC BXSSDTPC 00000001 INTL 20100528)
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] mapped APIC to ffffffffff5fb000 (        fee00000)
[    0.000000] No NUMA configuration found
[    0.000000] Faking a node at [mem 0x0000000000000000-0x000000001fffdfff]
[    0.000000] Initmem setup node 0 [mem 0x00000000-0x1fffdfff]
[    0.000000]   NODE_DATA [mem 0x1f7f9000-0x1f7fdfff]
[    0.000000]  [ffffea0000000000-ffffea00007fffff] PMD -> [ffff88001e600000-ffff88001edfffff] on node 0
[    0.000000] Zone ranges:
[    0.000000]   DMA      [mem 0x00001000-0x00ffffff]
[    0.000000]   DMA32    [mem 0x01000000-0xffffffff]
[    0.000000]   Normal   empty
[    0.000000] Movable zone start for each node
[    0.000000] Early memory node ranges
[    0.000000]   node   0: [mem 0x00001000-0x00092fff]
[    0.000000]   node   0: [mem 0x00100000-0x1fffdfff]
[    0.000000] On node 0 totalpages: 130960
[    0.000000]   DMA zone: 64 pages used for memmap
[    0.000000]   DMA zone: 21 pages reserved
[    0.000000]   DMA zone: 3986 pages, LIFO batch:0
[    0.000000]   DMA32 zone: 1984 pages used for memmap
[    0.000000]   DMA32 zone: 126974 pages, LIFO batch:31
[    0.000000] ACPI: PM-Timer IO Port: 0xb008
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] mapped APIC to ffffffffff5fb000 (        fee00000)
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
[    0.000000] mapped IOAPIC to ffffffffff5fa000 (fec00000)
[    0.000000] nr_irqs_gsi: 40
[    0.000000] PM: Registered nosave memory: 0000000000093000 - 0000000000094000
[    0.000000] PM: Registered nosave memory: 0000000000094000 - 00000000000a0000
[    0.000000] PM: Registered nosave memory: 00000000000a0000 - 00000000000f0000
[    0.000000] PM: Registered nosave memory: 00000000000f0000 - 0000000000100000
[    0.000000] e820: [mem 0x20000000-0xfeffbfff] available for PCI devices
[    0.000000] setup_percpu: NR_CPUS:64 nr_cpumask_bits:64 nr_cpu_ids:2 nr_node_ids:1
[    0.000000] PERCPU: Embedded 476 pages/cpu @ffff88001e200000 s1920384 r8192 d21120 u2097152
[    0.000000] pcpu-alloc: s1920384 r8192 d21120 u2097152 alloc=1*2097152
[    0.000000] pcpu-alloc: [0] 0 [0] 1 
[    0.000000] Built 1 zonelists in Node order, mobility grouping on.  Total pages: 128891
[    0.000000] Policy zone: DMA32
[    0.000000] Kernel command line: hung_task_panic=1 rcutree.rcu_cpu_stall_timeout=100 log_buf_len=8M ignore_loglevel debug sched_debug apic=debug dynamic_printk sysrq_always_enabled panic=10 load_ramdisk=2 prompt_ramdisk=0 console=ttyS0,115200 console=tty0 vga=normal ip=::::kvm::dhcp nfsroot=192.168.1.1:/nfsroot/wfg,tcp,v3,nocto,actimeo=600,nolock,rsize=524288,wsize=524288 rw link=/kernel-tests/run-queue/kvm/x86_64-nfsroot/xfs:for-next/.vmlinuz-ade1335afef556df6538eb02e8c0dc91fbd9cc37-20130614215817-9-kbuild branch=xfs/for-next  BOOT_IMAGE=/kernel/x86_64-nfsroot/ade1335afef556df6538eb02e8c0dc91fbd9cc37/vmlinuz-3.10.0-rc1-00031-gade1335
[    0.000000] sysrq: sysrq always enabled.
[    0.000000] PID hash table entries: 2048 (order: 2, 16384 bytes)
[    0.000000] Memory: 470388k/524280k available (10995k kernel code, 440k absent, 53452k reserved, 6671k data, 3208k init)
[    0.000000] SLUB: HWalign=64, Order=0-3, MinObjects=0, CPUs=2, Nodes=1
[    0.000000] Hierarchical RCU implementation.
[    0.000000] 
[    0.000000] 
[    0.000000] 
[    0.000000] NR_IRQS:4352 nr_irqs:512 16
[    0.000000] Console: colour VGA+ 80x25
[    0.000000] console [tty0] enabled
[    0.000000] console [ttyS0] enabled
[    0.000000] Lock dependency validator: Copyright (c) 2006 Red Hat, Inc., Ingo Molnar
[    0.000000] ... MAX_LOCKDEP_SUBCLASSES:  8
[    0.000000] ... MAX_LOCK_DEPTH:          48
[    0.000000] ... MAX_LOCKDEP_KEYS:        8191
[    0.000000] ... CLASSHASH_SIZE:          4096
[    0.000000] ... MAX_LOCKDEP_ENTRIES:     16384
[    0.000000] ... MAX_LOCKDEP_CHAINS:      32768
[    0.000000] ... CHAINHASH_SIZE:          16384
[    0.000000]  memory used by lock dependency info: 6367 kB
[    0.000000]  per task-struct memory footprint: 2688 bytes
[    0.000000] ------------------------
[    0.000000] | Locking API testsuite:
[    0.000000] ----------------------------------------------------------------------------
[    0.000000]                                  | spin |wlock |rlock |mutex | wsem | rsem |
[    0.000000]   --------------------------------------------------------------------------
[    0.000000]                      A-A deadlock:  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |
[    0.000000]                  A-B-B-A deadlock:  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |
[    0.000000]              A-B-B-C-C-A deadlock:  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |
[    0.000000]              A-B-C-A-B-C deadlock:  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |
[    0.000000]          A-B-B-C-C-D-D-A deadlock:  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |
[    0.000000]          A-B-C-D-B-D-D-A deadlock:  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |
[    0.000000]          A-B-C-D-B-C-D-A deadlock:  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |
[    0.000000]                     double unlock:  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |
[    0.000000]                   initialize held:  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |
[    0.000000]                  bad unlock order:  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |
[    0.000000]   --------------------------------------------------------------------------
[    0.000000]               recursive read-lock:             |  ok  |             |  ok  |
[    0.000000]            recursive read-lock #2:             |  ok  |             |  ok  |
[    0.000000]             mixed read-write-lock:             |  ok  |             |  ok  |
[    0.000000]             mixed write-read-lock:             |  ok  |             |  ok  |
[    0.000000]   --------------------------------------------------------------------------
[    0.000000]      hard-irqs-on + irq-safe-A/12:  ok  |  ok  |  ok  |
[    0.000000]      soft-irqs-on + irq-safe-A/12:  ok  |  ok  |  ok  |
[    0.000000]      hard-irqs-on + irq-safe-A/21:  ok  |  ok  |  ok  |
[    0.000000]      soft-irqs-on + irq-safe-A/21:  ok  |  ok  |  ok  |
[    0.000000]        sirq-safe-A => hirqs-on/12:  ok  |  ok  |  ok  |
[    0.000000]        sirq-safe-A => hirqs-on/21:  ok  |  ok  |  ok  |
[    0.000000]          hard-safe-A + irqs-on/12:  ok  |  ok  |  ok  |
[    0.000000]          soft-safe-A + irqs-on/12:  ok  |  ok  |  ok  |
[    0.000000]          hard-safe-A + irqs-on/21:  ok  |  ok  |  ok  |
[    0.000000]          soft-safe-A + irqs-on/21:  ok  |  ok  |  ok  |
[    0.000000]     hard-safe-A + unsafe-B #1/123:  ok  |  ok  |  ok  |
[    0.000000]     soft-safe-A + unsafe-B #1/123:  ok  |  ok  |  ok  |
[    0.000000]     hard-safe-A + unsafe-B #1/132:  ok  |  ok  |  ok  |
[    0.000000]     soft-safe-A + unsafe-B #1/132:  ok  |  ok  |  ok  |
[    0.000000]     hard-safe-A + unsafe-B #1/213:  ok  |  ok  |  ok  |
[    0.000000]     soft-safe-A + unsafe-B #1/213:  ok  |  ok  |  ok  |
[    0.000000]     hard-safe-A + unsafe-B #1/231:  ok  |  ok  |  ok  |
[    0.000000]     soft-safe-A + unsafe-B #1/231:  ok  |  ok  |  ok  |
[    0.000000]     hard-safe-A + unsafe-B #1/312:  ok  |  ok  |  ok  |
[    0.000000]     soft-safe-A + unsafe-B #1/312:  ok  |  ok  |  ok  |
[    0.000000]     hard-safe-A + unsafe-B #1/321:  ok  |  ok  |  ok  |
[    0.000000]     soft-safe-A + unsafe-B #1/321:  ok  |  ok  |  ok  |
[    0.000000]     hard-safe-A + unsafe-B #2/123:  ok  |  ok  |  ok  |
[    0.000000]     soft-safe-A + unsafe-B #2/123:  ok  |  ok  |  ok  |
[    0.000000]     hard-safe-A + unsafe-B #2/132:  ok  |  ok  |  ok  |
[    0.000000]     soft-safe-A + unsafe-B #2/132:  ok  |  ok  |  ok  |
[    0.000000]     hard-safe-A + unsafe-B #2/213:  ok  |  ok  |  ok  |
[    0.000000]     soft-safe-A + unsafe-B #2/213:  ok  |  ok  |  ok  |
[    0.000000]     hard-safe-A + unsafe-B #2/231:  ok  |  ok  |  ok  |
[    0.000000]     soft-safe-A + unsafe-B #2/231:  ok  |  ok  |  ok  |
[    0.000000]     hard-safe-A + unsafe-B #2/312:  ok  |  ok  |  ok  |
[    0.000000]     soft-safe-A + unsafe-B #2/312:  ok  |  ok  |  ok  |
[    0.000000]     hard-safe-A + unsafe-B #2/321:  ok  |  ok  |  ok  |
[    0.000000]     soft-safe-A + unsafe-B #2/321:  ok  |  ok  |  ok  |
[    0.000000]       hard-irq lock-inversion/123:  ok  |  ok  |  ok  |
[    0.000000]       soft-irq lock-inversion/123:  ok  |  ok  |  ok  |
[    0.000000]       hard-irq lock-inversion/132:  ok  |  ok  |  ok  |
[    0.000000]       soft-irq lock-inversion/132:  ok  |  ok  |  ok  |
[    0.000000]       hard-irq lock-inversion/213:  ok  |  ok  |  ok  |
[    0.000000]       soft-irq lock-inversion/213:  ok  |  ok  |  ok  |
[    0.000000]       hard-irq lock-inversion/231:  ok  |  ok  |  ok  |
[    0.000000]       soft-irq lock-inversion/231:  ok  |  ok  |  ok  |
[    0.000000]       hard-irq lock-inversion/312:  ok  |  ok  |  ok  |
[    0.000000]       soft-irq lock-inversion/312:  ok  |  ok  |  ok  |
[    0.000000]       hard-irq lock-inversion/321:  ok  |  ok  |  ok  |
[    0.000000]       soft-irq lock-inversion/321:  ok  |  ok  |  ok  |
[    0.000000]       hard-irq read-recursion/123:  ok  |
[    0.000000]       soft-irq read-recursion/123:  ok  |
[    0.000000]       hard-irq read-recursion/132:  ok  |
[    0.000000]       soft-irq read-recursion/132:  ok  |
[    0.000000]       hard-irq read-recursion/213:  ok  |
[    0.000000]       soft-irq read-recursion/213:  ok  |
[    0.000000]       hard-irq read-recursion/231:  ok  |
[    0.000000]       soft-irq read-recursion/231:  ok  |
[    0.000000]       hard-irq read-recursion/312:  ok  |
[    0.000000]       soft-irq read-recursion/312:  ok  |
[    0.000000]       hard-irq read-recursion/321:  ok  |
[    0.000000]       soft-irq read-recursion/321:  ok  |
[    0.000000] -------------------------------------------------------
[    0.000000] Good, all 218 testcases passed! |
[    0.000000] ---------------------------------
[    0.000000] ODEBUG: 0 of 0 active objects replaced
[    0.000000] hpet clockevent registered
[    0.000000] tsc: Fast TSC calibration failed
[    0.000000] tsc: Unable to calibrate against PIT
[    0.000000] tsc: using HPET reference calibration
[    0.000000] tsc: Detected 2693.428 MHz processor
[    0.008009] Calibrating delay loop (skipped), value calculated using timer frequency.. 5386.85 BogoMIPS (lpj=2693428)
[    0.011028] pid_max: default: 32768 minimum: 301
[    0.013427] Dentry cache hash table entries: 65536 (order: 7, 524288 bytes)
[    0.016053] Inode-cache hash table entries: 32768 (order: 6, 262144 bytes)
[    0.018623] Mount-cache hash table entries: 256
[    0.024024] Initializing cgroup subsys debug
[    0.025033] Initializing cgroup subsys devices
[    0.027051] Initializing cgroup subsys freezer
[    0.028043] Initializing cgroup subsys blkio
[    0.030285] mce: CPU supports 10 MCE banks
[    0.031099] numa_add_cpu cpu 0 node 0: mask now 0
[    0.032022] Last level iTLB entries: 4KB 0, 2MB 0, 4MB 0
[    0.032022] Last level dTLB entries: 4KB 0, 2MB 0, 4MB 0
[    0.032022] tlb_flushall_shift: 6
[    0.033312] Freeing SMP alternatives: 40k freed
[    0.034043] ACPI: Core revision 20130328
[    0.105412] ACPI: All ACPI Tables successfully acquired
[    0.108083] ftrace: allocating 43235 entries in 169 pages
[    0.123307] Getting VERSION: 50014
[    0.124029] Getting VERSION: 50014
[    0.125022] Getting ID: 0
[    0.126000] Getting ID: ff000000
[    0.126027] Getting LVT0: 8700
[    0.127025] Getting LVT1: 8400
[    0.128120] enabled ExtINT on CPU#0
[    0.131000] ENABLING IO-APIC IRQs
[    0.131025] init IO_APIC IRQs
[    0.132013]  apic 2 pin 0 not connected
[    0.134079] IOAPIC[0]: Set routing entry (2-1 -> 0x31 -> IRQ 1 Mode:0 Active:0 Dest:1)
[    0.135068] IOAPIC[0]: Set routing entry (2-2 -> 0x30 -> IRQ 0 Mode:0 Active:0 Dest:1)
[    0.136060] IOAPIC[0]: Set routing entry (2-3 -> 0x33 -> IRQ 3 Mode:0 Active:0 Dest:1)
[    0.137054] IOAPIC[0]: Set routing entry (2-4 -> 0x34 -> IRQ 4 Mode:0 Active:0 Dest:1)
[    0.138064] IOAPIC[0]: Set routing entry (2-5 -> 0x35 -> IRQ 5 Mode:1 Active:0 Dest:1)
[    0.139117] IOAPIC[0]: Set routing entry (2-6 -> 0x36 -> IRQ 6 Mode:0 Active:0 Dest:1)
[    0.140136] IOAPIC[0]: Set routing entry (2-7 -> 0x37 -> IRQ 7 Mode:0 Active:0 Dest:1)
[    0.141055] IOAPIC[0]: Set routing entry (2-8 -> 0x38 -> IRQ 8 Mode:0 Active:0 Dest:1)
[    0.142054] IOAPIC[0]: Set routing entry (2-9 -> 0x39 -> IRQ 9 Mode:1 Active:0 Dest:1)
[    0.144046] IOAPIC[0]: Set routing entry (2-10 -> 0x3a -> IRQ 10 Mode:1 Active:0 Dest:1)
[    0.145050] IOAPIC[0]: Set routing entry (2-11 -> 0x3b -> IRQ 11 Mode:1 Active:0 Dest:1)
[    0.146088] IOAPIC[0]: Set routing entry (2-12 -> 0x3c -> IRQ 12 Mode:0 Active:0 Dest:1)
[    0.147059] IOAPIC[0]: Set routing entry (2-13 -> 0x3d -> IRQ 13 Mode:0 Active:0 Dest:1)
[    0.149075] IOAPIC[0]: Set routing entry (2-14 -> 0x3e -> IRQ 14 Mode:0 Active:0 Dest:1)
[    0.150060] IOAPIC[0]: Set routing entry (2-15 -> 0x3f -> IRQ 15 Mode:0 Active:0 Dest:1)
[    0.151046]  apic 2 pin 16 not connected
[    0.152007]  apic 2 pin 17 not connected
[    0.154010]  apic 2 pin 18 not connected
[    0.155008]  apic 2 pin 19 not connected
[    0.156009]  apic 2 pin 20 not connected
[    0.157012]  apic 2 pin 21 not connected
[    0.158008]  apic 2 pin 22 not connected
[    0.159007]  apic 2 pin 23 not connected
[    0.160000] ..TIMER: vector=0x30 apic1=0 pin1=2 apic2=-1 pin2=-1
[    0.170589] smpboot: CPU0: Intel Common KVM processor (fam: 0f, model: 06, stepping: 01)
[    0.174008] Using local APIC timer interrupts.
[    0.174008] calibrating APIC timer ...
[    0.176000] ... lapic delta = 11062477
[    0.176000] ... PM-Timer delta = 633584
[    0.176000] APIC calibration not consistent with PM-Timer: 177ms instead of 100ms
[    0.176000] APIC delta adjusted to PM-Timer: 6249933 (11062477)
[    0.176000] TSC delta adjusted to PM-Timer: 269352046 (476757201)
[    0.176000] ..... delta 6249933
[    0.176000] ..... mult: 268432578
[    0.176000] ..... calibration result: 999989
[    0.176000] ..... CPU clock speed is 2693.0520 MHz.
[    0.176000] ..... host bus clock speed is 999.0989 MHz.
[    0.176126] Performance Events: unsupported Netburst CPU model 6 no PMU driver, software events only.
[    0.185579] SMP alternatives: lockdep: fixing up alternatives
[    0.187047] smpboot: Booting Node   0, Processors  #1 OK
[    0.009000] masked ExtINT on CPU#1
[    0.009000] numa_add_cpu cpu 1 node 0: mask now 0-1
[    0.009000] calibrate_delay_direct() dropping min bogoMips estimate 2 = 3505713
[    0.009000] calibrate_delay_direct() dropping max bogoMips estimate 0 = 6463809
[    0.009000] calibrate_delay_direct() dropping max bogoMips estimate 1 = 6333829
[    0.270212] Brought up 2 CPUs
[    0.272016] ----------------
[    0.274008] | NMI testsuite:
[    0.276004] --------------------
[    0.278007]   remote IPI:  ok  |
[    0.283005]    local IPI:  ok  |
[    0.292014] --------------------
[    0.294006] Good, all   2 testcases passed! |
[    0.296005] ---------------------------------
[    0.298008] smpboot: Total of 2 processors activated (15622.11 BogoMIPS)
[    0.303513] CPU0 attaching sched-domain:
[    0.305025]  domain 0: span 0-1 level CPU
[    0.308007]   groups: 0 1
[    0.311258] CPU1 attaching sched-domain:
[    0.313008]  domain 0: span 0-1 level CPU
[    0.316007]   groups: 1 0
[    0.324018] devtmpfs: initialized
[    0.335403] kworker/u4:0 (17) used greatest stack depth: 5344 bytes left
[    0.351666] xor: measuring software checksum speed
[    0.363028]    prefetch64-sse:   168.000 MB/sec
[    0.375019]    generic_sse:   172.000 MB/sec
[    0.377006] xor: using function: generic_sse (172.000 MB/sec)
[    0.379017] atomic64 test passed for x86-64 platform with CX8 and with SSE
[    0.382264] RTC time: 13:55:12, date: 06/14/13
[    0.385405] NET: Registered protocol family 16
[    0.390358] kworker/u4:0 (22) used greatest stack depth: 4960 bytes left
[    0.399522] ACPI: bus type PCI registered
[    0.403271] dca service started, version 1.12.1
[    0.407231] PCI: Using configuration type 1 for base access
[    0.757398] bio: create slab <bio-0> at 0
[    0.777025] raid6: sse2x1    3843 MB/s
[    0.796015] raid6: sse2x2    3992 MB/s
[    0.815019] raid6: sse2x4    5843 MB/s
[    0.817006] raid6: using algorithm sse2x4 (5843 MB/s)
[    0.819006] raid6: using intx1 recovery algorithm
[    0.822266] ACPI: Added _OSI(Module Device)
[    0.824133] ACPI: Added _OSI(Processor Device)
[    0.826039] ACPI: Added _OSI(3.0 _SCP Extensions)
[    0.829019] ACPI: Added _OSI(Processor Aggregator Device)
[    0.839454] ACPI: EC: Look up EC in DSDT
[    0.998228] ACPI: Interpreter enabled
[    1.000036] ACPI Exception: AE_NOT_FOUND, While evaluating Sleep State [\_S1_] (20130328/hwxface-568)
[    1.006053] ACPI Exception: AE_NOT_FOUND, While evaluating Sleep State [\_S2_] (20130328/hwxface-568)
[    1.013367] ACPI: (supports S0 S3 S4 S5)
[    1.016030] ACPI: Using IOAPIC for interrupt routing
[    1.018482] PCI: Ignoring host bridge windows from ACPI; if necessary, use "pci=use_crs" and report a bug
[    1.308029] ACPI: PCI Root Bridge [PCI0] (domain 0000 [bus 00-ff])
[    1.310536] acpi PNP0A03:00: host bridge window [io  0x0000-0x0cf7] (ignored)
[    1.312015] acpi PNP0A03:00: host bridge window [io  0x0d00-0xffff] (ignored)
[    1.314008] acpi PNP0A03:00: host bridge window [mem 0x000a0000-0x000bffff] (ignored)
[    1.316011] acpi PNP0A03:00: host bridge window [mem 0xe0000000-0xfebfffff] (ignored)
[    1.318056] PCI: root bus 00: using default resources
[    1.320080] acpi PNP0A03:00: fail to add MMCONFIG information, can't access extended PCI configuration space under this bridge.
[    1.337008] PCI host bridge to bus 0000:00
[    1.339038] pci_bus 0000:00: root bus resource [bus 00-ff]
[    1.341054] pci_bus 0000:00: root bus resource [io  0x0000-0xffff]
[    1.343022] pci_bus 0000:00: root bus resource [mem 0x00000000-0xffffffffff]
[    1.345191] pci 0000:00:00.0: [8086:1237] type 00 class 0x060000
[    1.355114] pci 0000:00:01.0: [8086:7000] type 00 class 0x060100
[    1.360173] pci 0000:00:01.1: [8086:7010] type 00 class 0x010180
[    1.365342] pci 0000:00:01.1: reg 20: [io  0xc1e0-0xc1ef]
[    1.375232] pci 0000:00:01.3: [8086:7113] type 00 class 0x068000
[    1.378394] pci 0000:00:01.3: quirk: [io  0xb000-0xb03f] claimed by PIIX4 ACPI
[    1.380037] pci 0000:00:01.3: quirk: [io  0xb100-0xb10f] claimed by PIIX4 SMB
[    1.385120] pci 0000:00:02.0: [1013:00b8] type 00 class 0x030000
[    1.389731] pci 0000:00:02.0: reg 10: [mem 0xfc000000-0xfdffffff pref]
[    1.393674] pci 0000:00:02.0: reg 14: [mem 0xfebe0000-0xfebe0fff]
[    1.404086] pci 0000:00:02.0: reg 30: [mem 0xfebc0000-0xfebcffff pref]
[    1.410331] pci 0000:00:03.0: [1af4:1000] type 00 class 0x020000
[    1.413535] pci 0000:00:03.0: reg 10: [io  0xc1c0-0xc1df]
[    1.417010] pci 0000:00:03.0: reg 14: [mem 0xfebe1000-0xfebe1fff]
[    1.425518] pci 0000:00:03.0: reg 30: [mem 0xfebd0000-0xfebdffff pref]
[    1.430235] pci 0000:00:04.0: [8086:100e] type 00 class 0x020000
[    1.433009] pci 0000:00:04.0: reg 10: [mem 0xfeb80000-0xfeb9ffff]
[    1.436014] pci 0000:00:04.0: reg 14: [io  0xc000-0xc03f]
[    1.443010] pci 0000:00:04.0: reg 30: [mem 0xfeba0000-0xfebbffff pref]
[    1.448301] pci 0000:00:05.0: [1af4:1001] type 00 class 0x010000
[    1.451551] pci 0000:00:05.0: reg 10: [io  0xc040-0xc07f]
[    1.454014] pci 0000:00:05.0: reg 14: [mem 0xfebe2000-0xfebe2fff]
[    1.466309] pci 0000:00:06.0: [1af4:1001] type 00 class 0x010000
[    1.469566] pci 0000:00:06.0: reg 10: [io  0xc080-0xc0bf]
[    1.472009] pci 0000:00:06.0: reg 14: [mem 0xfebe3000-0xfebe3fff]
[    1.485288] pci 0000:00:07.0: [1af4:1001] type 00 class 0x010000
[    1.488563] pci 0000:00:07.0: reg 10: [io  0xc0c0-0xc0ff]
[    1.491009] pci 0000:00:07.0: reg 14: [mem 0xfebe4000-0xfebe4fff]
[    1.504294] pci 0000:00:08.0: [1af4:1001] type 00 class 0x010000
[    1.507561] pci 0000:00:08.0: reg 10: [io  0xc100-0xc13f]
[    1.510010] pci 0000:00:08.0: reg 14: [mem 0xfebe5000-0xfebe5fff]
[    1.523340] pci 0000:00:09.0: [1af4:1001] type 00 class 0x010000
[    1.527015] pci 0000:00:09.0: reg 10: [io  0xc140-0xc17f]
[    1.530559] pci 0000:00:09.0: reg 14: [mem 0xfebe6000-0xfebe6fff]
[    1.544283] pci 0000:00:0a.0: [1af4:1001] type 00 class 0x010000
[    1.547010] pci 0000:00:0a.0: reg 10: [io  0xc180-0xc1bf]
[    1.550622] pci 0000:00:0a.0: reg 14: [mem 0xfebe7000-0xfebe7fff]
[    1.562219] pci 0000:00:0b.0: [8086:25ab] type 00 class 0x088000
[    1.565009] pci 0000:00:0b.0: reg 10: [mem 0xfebe8000-0xfebe800f]
[    1.576240] acpi PNP0A03:00: ACPI _OSC support notification failed, disabling PCIe ASPM
[    1.578009] acpi PNP0A03:00: Unable to request _OSC control (_OSC support mask: 0x08)
[    1.594262] ACPI: PCI Interrupt Link [LNKA] (IRQs 5 *10 11)
[    1.603533] ACPI: PCI Interrupt Link [LNKB] (IRQs 5 *10 11)
[    1.612608] ACPI: PCI Interrupt Link [LNKC] (IRQs 5 10 *11)
[    1.622102] ACPI: PCI Interrupt Link [LNKD] (IRQs 5 10 *11)
[    1.631850] ACPI: PCI Interrupt Link [LNKS] (IRQs 9) *0
[    1.641899] ACPI: Enabled 16 GPEs in block 00 to 0F
[    1.643064] acpi root: \_SB_.PCI0 notify handler is installed
[    1.646043] Found 1 acpi root devices
[    1.674514] ACPI: No dock devices found.
[    1.679301] vgaarb: device added: PCI:0000:00:02.0,decodes=io+mem,owns=io+mem,locks=none
[    1.684033] vgaarb: loaded
[    1.686006] vgaarb: bridge control possible 0000:00:02.0
[    1.705468] SCSI subsystem initialized
[    1.707052] ACPI: bus type ATA registered
[    1.711370] libata version 3.00 loaded.
[    1.715418] ACPI: bus type USB registered
[    1.723370] usbcore: registered new interface driver usbfs
[    1.725355] usbcore: registered new interface driver hub
[    1.728468] usbcore: registered new device driver usb
[    1.732348] pps_core: LinuxPPS API ver. 1 registered
[    1.735174] pps_core: Software ver. 5.3.6 - Copyright 2005-2007 Rodolfo Giometti <giometti@linux.it>
[    1.738231] PTP clock support registered
[    1.744637] wmi: Mapper loaded
[    1.749271] Advanced Linux Sound Architecture Driver Initialized.
[    1.753014] PCI: Using ACPI for IRQ routing
[    1.755019] PCI: pci_cache_line_size set to 64 bytes
[    1.760566] e820: reserve RAM buffer [mem 0x00093c00-0x0009ffff]
[    1.768055] e820: reserve RAM buffer [mem 0x1fffe000-0x1fffffff]
[    1.790761] HPET: 3 timers in total, 0 timers will be used for per-cpu timer
[    1.795075] hpet0: at MMIO 0xfed00000, IRQs 2, 8, 0
[    1.804008] hpet0: 3 comparators, 64-bit 100.000000 MHz counter
[    1.823397] Switching to clocksource hpet
[    2.345154] pnp: PnP ACPI init
[    2.348386] ACPI: bus type PNP registered
[    2.408362] IOAPIC[0]: Set routing entry (2-8 -> 0x38 -> IRQ 8 Mode:0 Active:0 Dest:3)
[    2.431930] pnp 00:00: Plug and Play ACPI device, IDs PNP0b00 (active)
[    2.437703] IOAPIC[0]: Set routing entry (2-1 -> 0x31 -> IRQ 1 Mode:0 Active:0 Dest:3)
[    2.468171] pnp 00:01: Plug and Play ACPI device, IDs PNP0303 (active)
[    2.473256] IOAPIC[0]: Set routing entry (2-12 -> 0x3c -> IRQ 12 Mode:0 Active:0 Dest:3)
[    2.489864] pnp 00:02: Plug and Play ACPI device, IDs PNP0f13 (active)
[    2.495742] IOAPIC[0]: Set routing entry (2-6 -> 0x36 -> IRQ 6 Mode:0 Active:0 Dest:3)
[    2.502440] pnp 00:03: [dma 2]
[    2.529195] pnp 00:03: Plug and Play ACPI device, IDs PNP0700 (active)
[    2.556745] IOAPIC[0]: Set routing entry (2-7 -> 0x37 -> IRQ 7 Mode:0 Active:0 Dest:3)
[    2.583719] pnp 00:04: Plug and Play ACPI device, IDs PNP0400 (active)
[    2.593740] IOAPIC[0]: Set routing entry (2-4 -> 0x34 -> IRQ 4 Mode:0 Active:0 Dest:3)
[    2.618550] pnp 00:05: Plug and Play ACPI device, IDs PNP0501 (active)
[    2.644303] pnp 00:06: Plug and Play ACPI device, IDs PNP0103 (active)
[    2.682126] pnp: PnP ACPI: found 7 devices
[    2.685801] ACPI: bus type PNP unregistered
[    3.003973] pci_bus 0000:00: resource 4 [io  0x0000-0xffff]
[    3.013677] pci_bus 0000:00: resource 5 [mem 0x00000000-0xffffffffff]
[    3.024245] NET: Registered protocol family 2
[    3.031623] TCP established hash table entries: 4096 (order: 4, 65536 bytes)
[    3.044416] TCP bind hash table entries: 4096 (order: 6, 327680 bytes)
[    3.057205] TCP: Hash tables configured (established 4096 bind 4096)
[    3.065517] TCP: reno registered
[    3.074341] UDP hash table entries: 256 (order: 3, 49152 bytes)
[    3.080679] UDP-Lite hash table entries: 256 (order: 3, 49152 bytes)
[    3.092434] NET: Registered protocol family 1
[    3.103814] RPC: Registered named UNIX socket transport module.
[    3.114703] RPC: Registered udp transport module.
[    3.120227] RPC: Registered tcp transport module.
[    3.127577] RPC: Registered tcp NFSv4.1 backchannel transport module.
[    3.136840] pci 0000:00:00.0: Limiting direct PCI/PCI transfers
[    3.147540] pci 0000:00:01.0: PIIX3: Enabling Passive Release
[    3.154663] pci 0000:00:01.0: Activating ISA DMA hang workarounds
[    3.164522] pci 0000:00:02.0: Boot video device
[    3.170319] PCI: CLS 0 bytes, default 64
[    4.124523] DMA-API: preallocated 65536 debug entries
[    4.142176] DMA-API: debugging enabled by kernel config
[    4.159969] kvm: no hardware support
[    4.171256] Machine check injector initialized
[    4.201015] microcode: CPU0 sig=0xf61, pf=0x1, revision=0x1
[    4.209212] microcode: CPU1 sig=0xf61, pf=0x1, revision=0x1
[    4.218988] microcode: Microcode Update Driver: v2.00 <tigran@aivazian.fsnet.co.uk>, Peter Oruba
[    4.230514] Scanning for low memory corruption every 60 seconds
[    4.266567] Initializing RT-Tester: OK
[    4.269251] audit: initializing netlink socket (disabled)
[    4.281180] type=2000 audit(1371218112.281:1): initialized
[    4.449858] Kprobe smoke test started
[    4.664249] Kprobe smoke test passed successfully
[    4.673561] rcu-torture:--- Start of test: nreaders=4 nfakewriters=4 stat_interval=60 verbose=0 test_no_idle_hz=1 shuffle_interval=3 stutter=5 irqreader=1 fqs_duration=0 fqs_holdoff=0 fqs_stutter=3 test_boost=1/0 test_boost_interval=7 test_boost_duration=4 shutdown_secs=0 stall_cpu=0 stall_cpu_holdoff=10 n_barrier_cbs=0 onoff_interval=0 onoff_holdoff=0
[    4.742324] bounce pool size: 64 pages
[    4.745808] HugeTLB registered 2 MB page size, pre-allocated 0 pages
[    5.174689] tsc: Refined TSC clocksource calibration: 2693.509 MHz
[    5.199424] Switching to clocksource tsc
[    5.439640] NFS: Registering the id_resolver key type
[    5.448778] Key type id_resolver registered
[    5.456156] Key type id_legacy registered
[    5.460462] Installing knfsd (copyright (C) 1996 okir@monad.swb.de).
[    5.515051] fuse init (API version 7.22)
[    5.542705] JFS: nTxBlock = 3675, nTxLock = 29401
[    5.568750] SGI XFS with ACLs, security attributes, large block/inode numbers, no debug enabled
[    5.628564] 9p: Installing v9fs 9p2000 file system support
[    5.648056] NILFS version 2 loaded
[    5.711127] Btrfs loaded
[    5.717520] msgmni has been set to 918
[    5.745920] async_tx: api initialized (async)
[    5.753850] Block layer SCSI generic (bsg) driver version 0.4 loaded (major 250)
[    5.764396] io scheduler noop registered
[    5.770195] io scheduler deadline registered
[    5.800325] io scheduler cfq registered (default)
[    5.804796] list_sort_test: start testing list_sort()
[    5.851551] pci_hotplug: PCI Hot Plug PCI Core version: 0.5
[    5.860686] input: Power Button as /devices/LNXSYSTM:00/LNXPWRBN:00/input/input0
[    5.872836] ACPI: Power Button [PWRF]
[    6.120001] ioatdma: Intel(R) QuickData Technology Driver 4.00
[    6.180833] ACPI: PCI Interrupt Link [LNKC] enabled at IRQ 11
[    6.184046] IOAPIC[0]: Set routing entry (2-11 -> 0x3b -> IRQ 11 Mode:1 Active:0 Dest:3)
[    6.245386] virtio-pci 0000:00:03.0: setting latency timer to 64
[    6.298267] ACPI: PCI Interrupt Link [LNKA] enabled at IRQ 10
[    6.307467] IOAPIC[0]: Set routing entry (2-10 -> 0x3a -> IRQ 10 Mode:1 Active:0 Dest:3)
[    6.322147] virtio-pci 0000:00:05.0: setting latency timer to 64
[    6.382927] ACPI: PCI Interrupt Link [LNKB] enabled at IRQ 10
[    6.386357] virtio-pci 0000:00:06.0: setting latency timer to 64
[    6.434122] virtio-pci 0000:00:07.0: setting latency timer to 64
[    6.513213] ACPI: PCI Interrupt Link [LNKD] enabled at IRQ 11
[    6.517273] virtio-pci 0000:00:08.0: setting latency timer to 64
[    6.567783] virtio-pci 0000:00:09.0: setting latency timer to 64
[    6.601483] virtio-pci 0000:00:0a.0: setting latency timer to 64
[    7.385198] Serial: 8250/16550 driver, 4 ports, IRQ sharing enabled
[    7.443849] 00:05: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
[    7.468547] Initializing Nozomi driver 2.1d
[    7.482685] Non-volatile memory driver v1.3
[    7.486170] Linux agpgart interface v0.103
[    7.540145] Hangcheck: starting hangcheck timer 0.9.1 (tick is 180 seconds, margin is 60 seconds).
[    7.567958] Hangcheck: Using getrawmonotonic().
[    7.588143] [drm] Initialized drm 1.1.0 20060810
[    7.609480] Floppy drive(s): fd0 is 1.44M
[    7.629968] FDC 0 is a S82078B
[    7.677531] brd: module loaded
[    7.731933] loop: module loaded
[    7.750063] virtio-pci 0000:00:05.0: irq 40 for MSI/MSI-X
[    7.753161] virtio-pci 0000:00:05.0: irq 41 for MSI/MSI-X
[    7.805912]  vda: unknown partition table
[    7.815448] virtio-pci 0000:00:06.0: irq 42 for MSI/MSI-X
[    7.818539] virtio-pci 0000:00:06.0: irq 43 for MSI/MSI-X
[    7.866162]  vdb: unknown partition table
[    7.877657] virtio-pci 0000:00:07.0: irq 44 for MSI/MSI-X
[    7.881080] virtio-pci 0000:00:07.0: irq 45 for MSI/MSI-X
[    7.932315]  vdc: unknown partition table
[    7.937641] virtio-pci 0000:00:08.0: irq 46 for MSI/MSI-X
[    7.941362] virtio-pci 0000:00:08.0: irq 47 for MSI/MSI-X
[    7.997711]  vdd: unknown partition table
[    8.015222] virtio-pci 0000:00:09.0: irq 48 for MSI/MSI-X
[    8.018559] virtio-pci 0000:00:09.0: irq 49 for MSI/MSI-X
[    8.068420]  vde: unknown partition table
[    8.079362] virtio-pci 0000:00:0a.0: irq 50 for MSI/MSI-X
[    8.083257] virtio-pci 0000:00:0a.0: irq 51 for MSI/MSI-X
[    8.138530]  vdf: unknown partition table
[    8.148138] lkdtm: No crash points registered, enable through debugfs
[    8.159083] Uniform Multi-Platform E-IDE driver
[    8.171213] piix 0000:00:01.1: IDE controller (0x8086:0x7010 rev 0x00)
[    8.175638] piix 0000:00:01.1: not 100% native mode: will probe irqs later
[    8.202748] pci 0000:00:01.1: setting latency timer to 64
[    8.205974]     ide0: BM-DMA at 0xc1e0-0xc1e7
[    8.232289]     ide1: BM-DMA at 0xc1e8-0xc1ef
[    8.234897] Probing IDE interface ide0...
[    8.828102] Probing IDE interface ide1...
[    9.538225] hdc: QEMU DVD-ROM, ATAPI CD/DVD-ROM drive
[   10.157663] hdc: host max PIO4 wanted PIO255(auto-tune) selected PIO0
[   10.161582] hdc: MWDMA2 mode selected
[   10.164845] ide0 at 0x1f0-0x1f7,0x3f6 on irq 14
[   10.168770] ide1 at 0x170-0x177,0x376 on irq 15
[   10.194699] ide_generic: please use "probe_mask=0x3f" module parameter for probing all legacy ISA IDE ports
[   10.209642] ide-gd driver 1.18
[   10.222271] Loading iSCSI transport class v2.0-870.
[   10.247346] Loading Adaptec I2O RAID: Version 2.4 Build 5go
[   10.258952] Detecting Adaptec I2O RAID controllers...
[   10.264065] Adaptec aacraid driver 1.2-0[30200]-ms
[   10.268625] aic94xx: Adaptec aic94xx SAS/SATA driver version 1.0.3 loaded
[   10.290472] isci: Intel(R) C600 SAS Controller Driver - version 1.1.0
[   10.297167] qla2xxx [0000:00:00.0]-0005: : QLogic Fibre Channel HBA Driver: 8.05.00.03-k.
[   10.339326] iscsi: registered transport (qla4xxx)
[   10.343405] QLogic iSCSI HBA Driver
[   10.367236] megaraid cmm: 2.20.2.7 (Release Date: Sun Jul 16 00:01:03 EST 2006)
[   10.374821] megaraid: 2.20.5.1 (Release Date: Thu Nov 16 15:32:35 EST 2006)
[   10.406910] megasas: 06.506.00.00-rc1 Sat. Feb. 9 17:00:00 PDT 2013
[   10.448380] mpt2sas version 14.100.00.00 loaded
[   10.477301] GDT-HA: Storage RAID Controller Driver. Version: 3.05
[   10.651827] tun: Universal TUN/TAP device driver, 1.6
[   10.655190] tun: (C) 1999-2004 Max Krasnyansky <maxk@qualcomm.com>
[   10.680072] netif_napi_add() called with weight 128 on device eth%d
[   10.700200] virtio-pci 0000:00:03.0: irq 52 for MSI/MSI-X
[   10.703713] virtio-pci 0000:00:03.0: irq 53 for MSI/MSI-X
[   10.707290] virtio-pci 0000:00:03.0: irq 54 for MSI/MSI-X
[   10.793538] Atheros(R) L2 Ethernet Driver - version 2.2.3
[   10.797185] Copyright (c) 2007 Atheros Corporation.
[   10.814074] cnic: Broadcom NetXtreme II CNIC Driver cnic v2.5.16 (Dec 05, 2012)
[   10.837849] e100: Intel(R) PRO/100 Network Driver, 3.5.24-k2-NAPI
[   10.841907] e100: Copyright(c) 1999-2006 Intel Corporation
[   10.855671] e1000: Intel(R) PRO/1000 Network Driver - version 7.3.21-k8-NAPI
[   10.889141] e1000: Copyright (c) 1999-2006 Intel Corporation.
[   10.906146] e1000 0000:00:04.0: setting latency timer to 64
[   11.651444] e1000 0000:00:04.0 eth1: (PCI:33MHz:32-bit) 52:54:00:12:34:57
[   11.654861] e1000 0000:00:04.0 eth1: Intel(R) PRO/1000 Network Connection
[   11.669711] e1000e: Intel(R) PRO/1000 Network Driver - 2.3.2-k
[   11.672838] e1000e: Copyright(c) 1999 - 2013 Intel Corporation.
[   11.676944] igb: Intel(R) Gigabit Ethernet Network Driver - version 5.0.3-k
[   11.689135] igb: Copyright (c) 2007-2013 Intel Corporation.
[   11.705131] igbvf: Intel(R) Gigabit Virtual Function Network Driver - version 2.0.2-k
[   11.709870] igbvf: Copyright (c) 2009 - 2012 Intel Corporation.
[   11.714679] ixgbe: Intel(R) 10 Gigabit PCI Express Network Driver - version 3.13.10-k
[   11.719517] ixgbe: Copyright (c) 1999-2013 Intel Corporation.
[   11.728998] ixgb: Intel(R) PRO/10GbE Network Driver - version 1.0.135-k2-NAPI
[   11.732540] ixgb: Copyright (c) 1999-2008 Intel Corporation.
[   11.741091] jme: JMicron JMC2XX ethernet driver version 1.0.8
[   11.760053] sky2: driver version 1.30
[   11.769224] pch_gbe: EG20T PCH Gigabit Ethernet Driver - version 1.01
[   11.781105] usbcore: registered new interface driver catc
[   11.789049] usbcore: registered new interface driver kaweth
[   11.792315] pegasus: v0.9.3 (2013/04/25), Pegasus/Pegasus II USB Ethernet driver
[   11.809165] usbcore: registered new interface driver pegasus
[   11.813631] usbcore: registered new interface driver rtl8150
[   11.819157] usbcore: registered new interface driver asix
[   11.822714] usbcore: registered new interface driver ax88179_178a
[   11.826404] usbcore: registered new interface driver cdc_ether
[   11.831316] usbcore: registered new interface driver cdc_eem
[   11.839097] usbcore: registered new interface driver dm9601
[   11.849011] usbcore: registered new interface driver smsc75xx
[   11.859140] usbcore: registered new interface driver smsc95xx
[   11.869079] usbcore: registered new interface driver gl620a
[   11.872689] usbcore: registered new interface driver net1080
[   11.878322] usbcore: registered new interface driver plusb
[   11.889090] usbcore: registered new interface driver rndis_host
[   11.899128] usbcore: registered new interface driver cdc_subset
[   11.902883] usbcore: registered new interface driver zaurus
[   11.909065] usbcore: registered new interface driver MOSCHIP usb-ethernet driver
[   11.919004] usbcore: registered new interface driver int51x1
[   11.929085] usbcore: registered new interface driver cdc_ncm
[   11.932490] Fusion MPT base driver 3.04.20
[   11.935165] Copyright (c) 1999-2008 LSI Corporation
[   11.938351] Fusion MPT SPI Host driver 3.04.20
[   11.956444] Fusion MPT FC Host driver 3.04.20
[   11.961040] Fusion MPT SAS Host driver 3.04.20
[   11.968980] Fusion MPT misc device (ioctl) driver 3.04.20
[   11.982071] mptctl: Registered with Fusion MPT base driver
[   11.985218] mptctl: /dev/mptctl @ (major,minor=10,220)
[   11.998582] ehci_hcd: USB 2.0 'Enhanced' Host Controller (EHCI) Driver
[   12.002726] ehci-pci: EHCI PCI platform driver
[   12.006778] uhci_hcd: USB Universal Host Controller Interface driver
[   12.026790] usbcore: registered new interface driver usb-storage
[   12.039050] usbcore: registered new interface driver ums-alauda
[   12.049135] usbcore: registered new interface driver ums-cypress
[   12.065058] usbcore: registered new interface driver ums-datafab
[   12.088101] usbcore: registered new interface driver ums-freecom
[   12.119238] usbcore: registered new interface driver ums-isd200
[   12.123472] usbcore: registered new interface driver ums-jumpshot
[   12.149366] usbcore: registered new interface driver ums-karma
[   12.153821] usbcore: registered new interface driver ums-onetouch
[   12.158344] usbcore: registered new interface driver ums-sddr09
[   12.189449] usbcore: registered new interface driver ums-sddr55
[   12.193716] usbcore: registered new interface driver ums-usbat
[   12.219435] usbcore: registered new interface driver usbserial
[   12.229089] usbcore: registered new interface driver usbserial_generic
[   12.235125] usbserial: USB Serial support registered for generic
[   12.269364] usbcore: registered new interface driver belkin_sa
[   12.273665] usbserial: USB Serial support registered for Belkin / Peracom / GoHubs USB Serial Adapter
[   12.299422] usbcore: registered new interface driver mct_u232
[   12.303585] usbserial: USB Serial support registered for MCT U232
[   12.308231] usbcore: registered new interface driver usbtest
[   12.378133] i8042: PNP: PS/2 Controller [PNP0303:KBD,PNP0f13:MOU] at 0x60,0x64 irq 1,12
[   12.409949] serio: i8042 KBD port at 0x60,0x64 irq 1
[   12.413333] serio: i8042 AUX port at 0x60,0x64 irq 12
[   12.442236] mousedev: PS/2 mouse device common for all mice
[   12.471136] input: AT Translated Set 2 keyboard as /devices/platform/i8042/serio0/input/input1
[   12.505947] rtc_cmos 00:00: RTC can wake from S4
[   12.528699] rtc_cmos 00:00: rtc core: registered rtc_cmos as rtc0
[   12.542236] rtc_cmos 00:00: alarms up to one day, 114 bytes nvram, hpet irqs
[   12.570972] rtc-test rtc-test.0: rtc core: registered test as rtc1
[   12.598504] rtc-test rtc-test.1: rtc core: registered test as rtc2
[   12.603071] i6300esb: Intel 6300ESB WatchDog Timer Driver v0.05
[   12.618414] i6300esb: initialized (0xffffc90000484000). heartbeat=30 sec (nowayout=0)
[   12.648560] iTCO_wdt: Intel TCO WatchDog Timer Driver v1.10
[   12.661723] iTCO_vendor_support: vendor-support=0
[   12.665230] watchdog: Software Watchdog: cannot register miscdev on minor=130 (err=-16).
[   12.679161] watchdog: Software Watchdog: a legacy watchdog module is probably present.
[   12.737364] softdog: Software Watchdog Timer: 0.08 initialized. soft_noboot=0 soft_margin=60 sec soft_panic=0 (nowayout=0)
[   12.745863] md: linear personality registered for level -1
[   12.753670] md: raid0 personality registered for level 0
[   12.761448] md: raid1 personality registered for level 1
[   12.770198] md: raid10 personality registered for level 10
[   12.776801] md: raid6 personality registered for level 6
[   12.784397] md: raid5 personality registered for level 5
[   12.792133] md: raid4 personality registered for level 4
[   12.798755] md: multipath personality registered for level -4
[   12.805518] md: faulty personality registered for level -5
[   12.840702] device-mapper: uevent: version 1.0.3
[   12.879650] device-mapper: ioctl: 4.24.0-ioctl (2013-01-15) initialised: dm-devel@redhat.com
[   12.920411] device-mapper: multipath: version 1.5.1 loaded
[   12.924088] device-mapper: multipath round-robin: version 1.0.0 loaded
[   12.935235] device-mapper: multipath queue-length: version 0.1.0 loaded
[   12.942739] device-mapper: multipath service-time: version 0.2.0 loaded
[   12.981540] device-mapper: dm-log-userspace: version 1.1.0 loaded
[   12.985540] cpuidle: using governor ladder
[   12.988577] cpuidle: using governor menu
[   13.029753] usbcore: registered new interface driver usbhid
[   13.036782] usbhid: USB HID core driver
[   13.072270] dell_wmi: No known WMI GUID found
[   13.075327] acer_wmi: Acer Laptop ACPI-WMI Extras
[   13.078499] acer_wmi: No or unsupported WMI interface, unable to load
[   13.110503] oprofile: using NMI interrupt.
[   13.114986] netem: version 1.3
[   13.118001] Netfilter messages via NETLINK v0.30.
[   13.148321] nf_conntrack version 0.5.0 (3675 buckets, 14700 max)
[   13.179550] input: ImExPS/2 Generic Explorer Mouse as /devices/platform/i8042/serio1/input/input2
[   13.187949] ctnetlink v0.93: registering with nfnetlink.
[   13.209209] NF_TPROXY: Transparent proxy support initialized, version 4.1.0
[   13.213323] NF_TPROXY: Copyright (c) 2006-2007 BalaBit IT Ltd.
[   13.241205] xt_time: kernel timezone is -0000
[   13.245144] ip_tables: (C) 2000-2006 Netfilter Core Team
[   13.259428] ipt_CLUSTERIP: ClusterIP Version 0.8 loaded successfully
[   13.267822] arp_tables: (C) 2002 David S. Miller
[   13.275658] TCP: bic registered
[   13.282412] TCP: cubic registered
[   13.288450] TCP: westwood registered
[   13.294596] TCP: highspeed registered
[   13.300868] TCP: hybla registered
[   13.306786] TCP: htcp registered
[   13.312724] TCP: vegas registered
[   13.318706] TCP: veno registered
[   13.324692] TCP: scalable registered
[   13.330889] TCP: lp registered
[   13.336756] TCP: yeah registered
[   13.342728] TCP: illinois registered
[   13.348839] Initializing XFRM netlink socket
[   13.409705] NET: Registered protocol family 10
[   13.429152] sit: IPv6 over IPv4 tunneling driver
[   13.454964] NET: Registered protocol family 17
[   13.460903] NET: Registered protocol family 15
[   13.480563] Bridge firewalling registered
[   13.484175] Ebtables v2.0 registered
[   13.492534] 9pnet: Installing 9P2000 support
[   13.509744] Key type dns_resolver registered
[   13.543862] 
[   13.543862] printing PIC contents
[   13.548747] ... PIC  IMR: ffff
[   13.549690] ... PIC  IRR: 1153
[   13.556221] ... PIC  ISR: 0000
[   13.580072] ... PIC ELCR: 0c00
[   13.582863] printing local APIC contents on CPU#0/0:
[   13.583843] ... APIC ID:      00000000 (0)
[   13.583843] ... APIC VERSION: 00050014
[   13.583843] ... APIC TASKPRI: 00000000 (00)
[   13.583843] ... APIC PROCPRI: 00000000
[   13.583843] ... APIC LDR: 01000000
[   13.583843] ... APIC DFR: ffffffff
[   13.583843] ... APIC SPIV: 000001ff
[   13.583843] ... APIC ISR field:
[   13.583843] 0000000000000000000000000000000000000000000000000000000000000000
[   13.583843] ... APIC TMR field:
[   13.583843] 0000000000000000000000000000000000000000000000000000000000000000
[   13.583843] ... APIC IRR field:
[   13.583843] 0000000000000000000000000000000000000000000000000000000000008000
[   13.583843] ... APIC ESR: 00000000
[   13.583843] ... APIC ICR: 000008fd
[   13.583843] ... APIC ICR2: 02000000
[   13.583843] ... APIC LVTT: 000000ef
[   13.583843] ... APIC LVTPC: 00010000
[   13.583843] ... APIC LVT0: 00010700
[   13.583843] ... APIC LVT1: 00000400
[   13.583843] ... APIC LVTERR: 000000fe
[   13.583843] ... APIC TMICT: 0000ec58
[   13.583843] ... APIC TMCCT: 00000000
[   13.583843] ... APIC TDCR: 00000003
[   13.583843] 
[   13.922457] number of MP IRQ sources: 15.
[   13.925433] number of IO-APIC #2 registers: 24.
[   13.928615] testing the IO APIC.......................
[   13.933244] IO APIC #2......
[   13.935813] .... register #00: 00000000
[   13.938797] .......    : physical APIC id: 00
[   13.952040] .......    : Delivery Type: 0
[   13.955053] .......    : LTS          : 0
[   13.958204] .... register #01: 00170011
[   13.971298] .......     : max redirection entries: 17
[   13.974858] .......     : PRQ implemented: 0
[   13.977981] .......     : IO APIC version: 11
[   13.991163] .... register #02: 00000000
[   13.994186] .......     : arbitration: 00
[   13.997143] .... IRQ redirection table:
[   14.010168] 1    0    0   0   0    0    0    00
[   14.013381] 0    0    0   0   0    1    1    31
[   14.016596] 0    0    0   0   0    1    1    30
[   14.029925] 0    0    0   0   0    1    1    33
[   14.033122] 1    0    0   0   0    1    1    34
[   14.036299] 1    1    0   0   0    1    1    35
[   14.049539] 0    0    0   0   0    1    1    36
[   14.052720] 0    0    0   0   0    1    1    37
[   14.055881] 0    0    0   0   0    1    1    38
[   14.069187] 0    1    0   0   0    1    1    39
[   14.072515] 1    1    0   0   0    1    1    3A
[   14.075701] 1    1    0   0   0    1    1    3B
[   14.089130] 0    0    0   0   0    1    1    3C
[   14.092488] 0    0    0   0   0    1    1    3D
[   14.095731] 0    0    0   0   0    1    1    3E
[   14.109080] 0    0    0   0   0    1    1    3F
[   14.112345] 1    0    0   0   0    0    0    00
[   14.115577] 1    0    0   0   0    0    0    00
[   14.118827] 1    0    0   0   0    0    0    00
[   14.132160] 1    0    0   0   0    0    0    00
[   14.135416] 1    0    0   0   0    0    0    00
[   14.138666] 1    0    0   0   0    0    0    00
[   14.151894] 1    0    0   0   0    0    0    00
[   14.155147] 1    0    0   0   0    0    0    00
[   14.158385] IRQ to pin mappings:
[   14.171194] IRQ0 -> 0:2
[   14.174136] IRQ1 -> 0:1
[   14.177072] IRQ3 -> 0:3
[   14.190084] IRQ4 -> 0:4
[   14.193002] IRQ5 -> 0:5
[   14.195975] IRQ6 -> 0:6
[   14.211714] IRQ7 -> 0:7
[   14.216753] IRQ8 -> 0:8
[   14.221862] IRQ9 -> 0:9
[   14.225030] IRQ10 -> 0:10
[   14.228019] IRQ11 -> 0:11
[   14.231286] IRQ12 -> 0:12
[   14.234489] IRQ13 -> 0:13
[   14.238752] IRQ14 -> 0:14
[   14.241993] IRQ15 -> 0:15
[   14.246262] .................................... done.
[   14.288469] PM: Hibernation image not present or could not be loaded.
[   14.292674] registered taskstats version 1
[   14.345197]   Magic number: 1:321:938
[   14.349527] console [netcon0] enabled
[   14.352667] netconsole: network logging started
[   14.430744] IPv6: ADDRCONF(NETDEV_UP): eth1: link is not ready
[   14.445090] Sending DHCP requests ., OK
[   14.458962] IP-Config: Got DHCP answer from 10.0.2.2, my address is 10.0.2.15
[   14.581169] IP-Config: Complete:
[   14.591346]      device=eth0, hwaddr=52:54:00:12:34:56, ipaddr=10.0.2.15, mask=255.255.255.0, gw=10.0.2.2
[   14.618741]      host=kvm, domain=, nis-domain=(none)
[   14.622722]      bootserver=10.0.2.2, rootserver=192.168.1.1, rootpath=
[   14.625913]      nameserver0=10.0.2.3
[   14.654404] ALSA device list:
[   14.657470]   No soundcards found.
[   14.682971] md: Waiting for all devices to be available before autodetect
[   14.733368] md: If you don't use raid, use raid=noautodetect
[   14.757116] md: Autodetecting RAID arrays.
[   14.764564] md: Scanned 0 and added 0 devices.
[   14.771139] md: autorun ...
[   14.773805] md: ... autorun DONE.
[   14.916128] VFS: Mounted root (nfs filesystem) on device 0:14.
[   14.928277] devtmpfs: mounted
[   14.935681] Freeing unused kernel memory: 3208k freed
[   17.443148] modprobe (1963) used greatest stack depth: 3240 bytes left
[   19.377956] S02mountkernfs. (1984) used greatest stack depth: 3072 bytes left
[   20.022697] udevd[2047]: starting version 175
[   22.693676] udisks-part-id (2145) used greatest stack depth: 2800 bytes left
[   60.553643] NFSD: Using /var/lib/nfs/v4recovery as the NFSv4 state recovery directory
[   60.562561] NFSD: starting 90-second grace period (net ffffffff82103840)
[   60.582450] rpc.nfsd (2912) used greatest stack depth: 2640 bytes left
Kernel tests: Boot OK!
[   63.076085] CPU0 attaching NULL sched-domain.
[   63.079836] CPU1 attaching NULL sched-domain.
[   63.080090] CPU0 attaching NULL sched-domain.
[   63.095840] numa_remove_cpu cpu 1 node 0: mask now 0
[   63.348052] smpboot: CPU 1 is now offline
[   63.661174] SMP alternatives: lockdep: fixing up alternatives
[   63.675633] smpboot: Booting Node 0 Processor 1 APIC 0x1
[   63.096720] masked ExtINT on CPU#1
[   63.096720] numa_add_cpu cpu 1 node 0: mask now 0-1
[   63.728711] CPU0 attaching NULL sched-domain.
[   63.734132] CPU0 attaching sched-domain:
[   63.737447]  domain 0: span 0-1 level CPU
[   63.741093]   groups: 0 (cpu_power = 1023) 1
[   63.745637] CPU1 attaching sched-domain:
[   63.748964]  domain 0: span 0-1 level CPU
[   63.752606]   groups: 1 0 (cpu_power = 1023)
[   64.733281] rcu-torture: rtc: ffffffff82da41a0 ver: 1 tfle: 0 rta: 1 rtaf: 0 rtf: 0 rtmbe: 0 rtbke: 0 rtbre: 0 rtbf: 0 rtb: 0 nt: 4 onoff: 0/0:0/0 -1,0:-1,0 0:0 (HZ=1000) barrier: 0/0:0
[   64.733281] rcu-torture: Reader Pipe:  8 0 0 0 0 0 0 0 0 0 0
[   64.733281] rcu-torture: Reader Batch:  8 0 0 0 0 0 0 0 0 0 0
[   64.733281] rcu-torture: Free-Block Circulation:  0 0 0 0 0 0 0 0 0 0 0
[   64.795262] CPU0 attaching NULL sched-domain.
[   64.798240] CPU1 attaching NULL sched-domain.
[   64.801483] CPU0 attaching NULL sched-domain.
[   64.805574] numa_remove_cpu cpu 1 node 0: mask now 0
[   64.812342] smpboot: CPU 1 is now offline
[   74.570969] XFS (vdb): bad magic number
[   74.573837] ffff8800170ed000: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
[   74.579266] ffff8800170ed010: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
[   74.584581] ffff8800170ed020: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
[   74.590036] ffff8800170ed030: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
[   74.595386] XFS (vdb): Internal error xfs_sb_read_verify at line 730 of file /c/kernel-tests/src/stable/fs/xfs/xfs_mount.c.  Caller 0xffffffff81309514
[   74.595386] 
[   74.603826] CPU: 0 PID: 2137 Comm: kworker/0:1H Not tainted 3.10.0-rc1-00031-gade1335 #1508
[   74.609255] Hardware name: Bochs Bochs, BIOS Bochs 01/01/2007
[   74.612498] Workqueue: xfslogd xfs_buf_iodone_work
[   74.615690]  0000000000000001 ffff880016815c68 ffffffff81aa456f ffff880016815c88
[   74.621548]  ffffffff8130b179 ffffffff81309514 0000000000000001 ffff880016815cc8
[   74.627417]  ffffffff8130b1d0 0000000000000000 00000000000002da 0000000000000016
[   74.633321] Call Trace:
[   74.635427]  [<ffffffff81aa456f>] dump_stack+0x19/0x1b
[   74.638412]  [<ffffffff8130b179>] xfs_error_report+0x3d/0x3f
[   74.641627]  [<ffffffff81309514>] ? xfs_buf_iodone_work+0x4a/0x83
[   74.644970]  [<ffffffff8130b1d0>] xfs_corruption_error+0x55/0x71
[   74.648217]  [<ffffffff81352ce1>] xfs_sb_read_verify+0xee/0x105
[   74.651478]  [<ffffffff81309514>] ? xfs_buf_iodone_work+0x4a/0x83
[   74.654820]  [<ffffffff8108045d>] ? ftrace_raw_event_workqueue_execute_start+0x92/0xa1
[   74.659821]  [<ffffffff81309514>] xfs_buf_iodone_work+0x4a/0x83
[   74.663042]  [<ffffffff81082561>] process_one_work+0x26c/0x470
[   74.666296]  [<ffffffff810824bf>] ? process_one_work+0x1ca/0x470
[   74.669647]  [<ffffffff81082ee6>] worker_thread+0x1d0/0x2cb
[   74.672770]  [<ffffffff81082d16>] ? manage_workers.isra.19+0x1c3/0x1c3
[   74.676201]  [<ffffffff8108a590>] kthread+0xd5/0xdd
[   74.679151]  [<ffffffff810bd47c>] ? trace_hardirqs_on+0xd/0xf
[   74.682411]  [<ffffffff8108a4bb>] ? __init_kthread_worker+0x5a/0x5a
[   74.685776]  [<ffffffff81ab74dc>] ret_from_fork+0x7c/0xb0
[   74.688798]  [<ffffffff8108a4bb>] ? __init_kthread_worker+0x5a/0x5a
[   74.692206] XFS (vdb): Corruption detected. Unmount and run xfs_repair
[   74.696000] XFS (vdb): SB validate failed with error 22.
common.rc: retrying test device mount with external set
[   74.782247] XFS (vdb): bad magic number
[   74.784895] ffff8800170e7000: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
[   74.790201] ffff8800170e7010: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
[   74.795466] ffff8800170e7020: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
[   74.800759] ffff8800170e7030: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
[   74.806031] XFS (vdb): Internal error xfs_sb_read_verify at line 730 of file /c/kernel-tests/src/stable/fs/xfs/xfs_mount.c.  Caller 0xffffffff81309514
[   74.806031] 
[   74.814456] CPU: 0 PID: 2137 Comm: kworker/0:1H Not tainted 3.10.0-rc1-00031-gade1335 #1508
[   74.841351] Hardware name: Bochs Bochs, BIOS Bochs 01/01/2007
[   74.844614] Workqueue: xfslogd xfs_buf_iodone_work
[   74.847730]  0000000000000001 ffff880016815c68 ffffffff81aa456f ffff880016815c88
[   74.853619]  ffffffff8130b179 ffffffff81309514 0000000000000001 ffff880016815cc8
[   74.859519]  ffffffff8130b1d0 0000000000000000 00000000000002da 0000000000000016
[   74.868341] Call Trace:
[   74.872414]  [<ffffffff81aa456f>] dump_stack+0x19/0x1b
[   74.877040]  [<ffffffff8130b179>] xfs_error_report+0x3d/0x3f
[   74.881460]  [<ffffffff81309514>] ? xfs_buf_iodone_work+0x4a/0x83
[   74.886649]  [<ffffffff8130b1d0>] xfs_corruption_error+0x55/0x71
[   74.890851]  [<ffffffff81352ce1>] xfs_sb_read_verify+0xee/0x105
[   74.895473]  [<ffffffff81309514>] ? xfs_buf_iodone_work+0x4a/0x83
[   74.900719]  [<ffffffff8108045d>] ? ftrace_raw_event_workqueue_execute_start+0x92/0xa1
[   74.906554]  [<ffffffff81309514>] xfs_buf_iodone_work+0x4a/0x83
[   74.910862]  [<ffffffff81082561>] process_one_work+0x26c/0x470
[   74.914750]  [<ffffffff810824bf>] ? process_one_work+0x1ca/0x470
[   74.918694]  [<ffffffff81082ee6>] worker_thread+0x1d0/0x2cb
[   74.922414]  [<ffffffff81082d16>] ? manage_workers.isra.19+0x1c3/0x1c3
[   74.926989]  [<ffffffff8108a590>] kthread+0xd5/0xdd
[   74.930564]  [<ffffffff810bd47c>] ? trace_hardirqs_on+0xd/0xf
[   74.934319]  [<ffffffff8108a4bb>] ? __init_kthread_worker+0x5a/0x5a
[   74.938625]  [<ffffffff81ab74dc>] ret_from_fork+0x7c/0xb0
[   74.942272]  [<ffffffff8108a4bb>] ? __init_kthread_worker+0x5a/0x5a
[   74.946203] XFS (vdb): Corruption detected. Unmount and run xfs_repair
[   74.953983] XFS (vdb): SB validate failed with error 22.
[   74.973442] SMP alternatives: lockdep: fixing up alternatives
[   74.973449] smpboot: Booting Node 0 Processor 1 APIC 0x1
[   64.806031] masked ExtINT on CPU#1
[   64.806031] numa_add_cpu cpu 1 node 0: mask now 0-1
common.rc: could not mount /dev/vdb on /fs/vdb
[   75.042339] CPU0 attaching NULL sched-domain.
[   75.045891] CPU0 attaching sched-domain:
[   75.048254]  domain 0: span 0-1 level CPU
[   75.051236]   groups: 0 (cpu_power = 877) 1
[   75.054564] CPU1 attaching sched-domain:
[   75.057050]  domain 0: span 0-1 level CPU
[   75.059475]   groups: 1 0 (cpu_power = 877)
[  124.760153] rcu-torture: rtc: ffffffff82da41a0 ver: 1 tfle: 0 rta: 1 rtaf: 0 rtf: 0 rtmbe: 0 rtbke: 0 rtbre: 0 rtbf: 0 rtb: 0 nt: 4 onoff: 0/0:0/0 -1,0:-1,0 0:0 (HZ=1000) barrier: 0/0:0
[  124.760153] rcu-torture: Reader Pipe:  8 0 0 0 0 0 0 0 0 0 0
[  124.760153] rcu-torture: Reader Batch:  8 0 0 0 0 0 0 0 0 0 0
[  124.760153] rcu-torture: Free-Block Circulation:  0 0 0 0 0 0 0 0 0 0 0
[  175.111487] CPU0 attaching NULL sched-domain.
[  175.114843] CPU1 attaching NULL sched-domain.
[  175.118270] CPU0 attaching NULL sched-domain.
[  175.122313] numa_remove_cpu cpu 1 node 0: mask now 0
[  175.128259] smpboot: CPU 1 is now offline
[  175.169925] SMP alternatives: lockdep: fixing up alternatives
[  175.175080] smpboot: Booting Node 0 Processor 1 APIC 0x1
[  175.123028] masked ExtINT on CPU#1
[  175.123028] numa_add_cpu cpu 1 node 0: mask now 0-1
[  175.219651] CPU0 attaching NULL sched-domain.
[  175.223437] CPU0 attaching sched-domain:
[  175.226704]  domain 0: span 0-1 level CPU
[  175.230184]   groups: 0 (cpu_power = 1023) 1
[  175.233732] CPU1 attaching sched-domain:
[  175.236475]  domain 0: span 0-1 level CPU
[  175.239954]   groups: 1 0 (cpu_power = 1023)
[  175.363835] CPU0 attaching NULL sched-domain.
[  175.366639] CPU1 attaching NULL sched-domain.
[  175.369376] CPU0 attaching NULL sched-domain.
[  175.372905] numa_remove_cpu cpu 1 node 0: mask now 0
[  175.378313] smpboot: CPU 1 is now offline
[  175.387913] 99-trinity[3224]: segfault at 8 ip 00000000004434f0 sp 00007fffdc4b3c68 error 4 in bash[400000+e4000]
[  175.408843] rc.local[3029]: segfault at 8 ip 00000000004434f0 sp 00007fff87126678 error 4 in bash[400000+e4000]
[  176.469468] SMP alternatives: lockdep: fixing up alternatives
[  176.473369] smpboot: Booting Node 0 Processor 1 APIC 0x1
[  175.373796] masked ExtINT on CPU#1
[  175.373796] numa_add_cpu cpu 1 node 0: mask now 0-1
[  176.532093] CPU0 attaching NULL sched-domain.
[  176.535831] CPU0 attaching sched-domain:
[  176.539236]  domain 0: span 0-1 level CPU
[  176.542978]   groups: 0 (cpu_power = 1023) 1
[  176.555532] CPU1 attaching sched-domain:
[  176.558623]  domain 0: span 0-1 level CPU
[  176.562047]   groups: 1 0 (cpu_power = 1023)
[  184.785233] rcu-torture: rtc: ffffffff82da41a0 ver: 1 tfle: 0 rta: 1 rtaf: 0 rtf: 0 rtmbe: 0 rtbke: 0 rtbre: 0 rtbf: 0 rtb: 0 nt: 4 onoff: 0/0:0/0 -1,0:-1,0 0:0 (HZ=1000) barrier: 0/0:0
[  184.785233] rcu-torture: Reader Pipe:  8 0 0 0 0 0 0 0 0 0 0
[  184.785233] rcu-torture: Reader Batch:  8 0 0 0 0 0 0 0 0 0 0
[  184.785233] rcu-torture: Free-Block Circulation:  0 0 0 0 0 0 0 0 0 0 0
[  186.589557] CPU0 attaching NULL sched-domain.
[  186.591712] CPU1 attaching NULL sched-domain.
[  186.593948] CPU0 attaching NULL sched-domain.
[  186.599182] numa_remove_cpu cpu 1 node 0: mask now 0
[  186.604160] smpboot: CPU 1 is now offline
[  244.800266] rcu-torture: rtc: ffffffff82da41a0 ver: 1 tfle: 0 rta: 1 rtaf: 0 rtf: 0 rtmbe: 0 rtbke: 0 rtbre: 0 rtbf: 0 rtb: 0 nt: 4 onoff: 0/0:0/0 -1,0:-1,0 0:0 (HZ=1000) barrier: 0/0:0
[  244.800266] rcu-torture: Reader Pipe:  8 0 0 0 0 0 0 0 0 0 0
[  244.800266] rcu-torture: Reader Batch:  8 0 0 0 0 0 0 0 0 0 0
[  244.800266] rcu-torture: Free-Block Circulation:  0 0 0 0 0 0 0 0 0 0 0
[  286.674613] SMP alternatives: lockdep: fixing up alternatives
[  286.676971] smpboot: Booting Node 0 Processor 1 APIC 0x1
[  186.600039] masked ExtINT on CPU#1
[  186.600039] numa_add_cpu cpu 1 node 0: mask now 0-1
[  286.715825] CPU0 attaching NULL sched-domain.
[  286.717726] CPU0 attaching sched-domain:
[  286.718802]  domain 0: span 0-1 level CPU
[  286.720134]   groups: 0 (cpu_power = 1023) 1
[  286.722562] CPU1 attaching sched-domain:
[  286.724240]  domain 0: span 0-1 level CPU
[  286.726050]   groups: 1 0 (cpu_power = 1023)
[  286.744203] CPU0 attaching NULL sched-domain.
[  286.746101] CPU1 attaching NULL sched-domain.
[  286.748043] CPU0 attaching NULL sched-domain.
[  286.751261] numa_remove_cpu cpu 1 node 0: mask now 0
[  286.756671] smpboot: CPU 1 is now offline
[  286.884201] SMP alternatives: lockdep: fixing up alternatives
[  286.886414] smpboot: Booting Node 0 Processor 1 APIC 0x1
[  286.752171] masked ExtINT on CPU#1
[  286.752171] numa_add_cpu cpu 1 node 0: mask now 0-1
[  286.925238] CPU0 attaching NULL sched-domain.
[  286.927337] CPU0 attaching sched-domain:
[  286.929293]  domain 0: span 0-1 level CPU
[  286.931381]   groups: 0 (cpu_power = 1023) 1
[  286.933918] CPU1 attaching sched-domain:
[  286.935608]  domain 0: span 0-1 level CPU
[  286.937545]   groups: 1 0 (cpu_power = 1023)
[  287.955947] CPU0 attaching NULL sched-domain.
[  287.957775] CPU1 attaching NULL sched-domain.
[  287.959708] CPU0 attaching NULL sched-domain.
[  287.961702] numa_remove_cpu cpu 1 node 0: mask now 0
[  287.965900] smpboot: CPU 1 is now offline
[  297.997382] SMP alternatives: lockdep: fixing up alternatives
[  297.999628] smpboot: Booting Node 0 Processor 1 APIC 0x1
[  287.962358] masked ExtINT on CPU#1
[  287.962358] numa_add_cpu cpu 1 node 0: mask now 0-1
[  298.036960] CPU0 attaching NULL sched-domain.
[  298.039096] CPU0 attaching sched-domain:
[  298.040852]  domain 0: span 0-1 level CPU
[  298.042713]   groups: 0 (cpu_power = 1023) 1
[  298.045089] CPU1 attaching sched-domain:
[  298.046787]  domain 0: span 0-1 level CPU
[  298.048630]   groups: 1 0 (cpu_power = 1023)
[  304.812177] rcu-torture: rtc: ffffffff82da41a0 ver: 1 tfle: 0 rta: 1 rtaf: 0 rtf: 0 rtmbe: 0 rtbke: 0 rtbre: 0 rtbf: 0 rtb: 0 nt: 4 onoff: 0/0:0/0 -1,0:-1,0 0:0 (HZ=1000) barrier: 0/0:0
[  304.812177] rcu-torture: Reader Pipe:  8 0 0 0 0 0 0 0 0 0 0
[  304.812177] rcu-torture: Reader Batch:  8 0 0 0 0 0 0 0 0 0 0
[  304.812177] rcu-torture: Free-Block Circulation:  0 0 0 0 0 0 0 0 0 0 0
[  364.831227] rcu-torture: rtc: ffffffff82da41a0 ver: 1 tfle: 0 rta: 1 rtaf: 0 rtf: 0 rtmbe: 0 rtbke: 0 rtbre: 0 rtbf: 0 rtb: 0 nt: 4 onoff: 0/0:0/0 -1,0:-1,0 0:0 (HZ=1000) barrier: 0/0:0
[  364.831227] rcu-torture: Reader Pipe:  8 0 0 0 0 0 0 0 0 0 0
[  364.831227] rcu-torture: Reader Batch:  8 0 0 0 0 0 0 0 0 0 0
[  364.831227] rcu-torture: Free-Block Circulation:  0 0 0 0 0 0 0 0 0 0 0
[  398.071798] CPU0 attaching NULL sched-domain.
[  398.075062] CPU1 attaching NULL sched-domain.
[  398.078497] CPU0 attaching NULL sched-domain.
[  398.082517] numa_remove_cpu cpu 1 node 0: mask now 0
[  398.087813] smpboot: CPU 1 is now offline
[  398.136621] SMP alternatives: lockdep: fixing up alternatives
[  398.142073] smpboot: Booting Node 0 Processor 1 APIC 0x1
[  398.083029] masked ExtINT on CPU#1
[  398.083029] numa_add_cpu cpu 1 node 0: mask now 0-1
[  398.190651] CPU0 attaching NULL sched-domain.
[  398.194434] CPU0 attaching sched-domain:
[  398.197694]  domain 0: span 0-1 level CPU
[  398.201148]   groups: 0 (cpu_power = 1022) 1
[  398.204858] CPU1 attaching sched-domain:
[  398.207856]  domain 0: span 0-1 level CPU
[  398.210736]   groups: 1 0 (cpu_power = 1022)
[  398.335514] CPU0 attaching NULL sched-domain.
[  398.339502] CPU1 attaching NULL sched-domain.
[  398.343698] CPU0 attaching NULL sched-domain.
[  398.348353] numa_remove_cpu cpu 1 node 0: mask now 0
[  398.354737] smpboot: CPU 1 is now offline
[  399.391548] SMP alternatives: lockdep: fixing up alternatives
[  399.397399] smpboot: Booting Node 0 Processor 1 APIC 0x1
[  398.349248] masked ExtINT on CPU#1
[  398.349248] numa_add_cpu cpu 1 node 0: mask now 0-1
[  399.440313] CPU0 attaching NULL sched-domain.
[  399.444781] CPU0 attaching sched-domain:
[  399.448517]  domain 0: span 0-1 level CPU
[  399.452266]   groups: 0 (cpu_power = 1023) 1
[  399.456858] CPU1 attaching sched-domain:
[  399.460071]  domain 0: span 0-1 level CPU
[  399.463846]   groups: 1 0 (cpu_power = 1023)
[  409.491242] CPU0 attaching NULL sched-domain.
[  409.494611] CPU1 attaching NULL sched-domain.
[  409.496988] CPU0 attaching NULL sched-domain.
[  409.499818] numa_remove_cpu cpu 1 node 0: mask now 0
[  409.505583] smpboot: CPU 1 is now offline
[  424.850283] rcu-torture: rtc: ffffffff82da41a0 ver: 1 tfle: 0 rta: 1 rtaf: 0 rtf: 0 rtmbe: 0 rtbke: 0 rtbre: 0 rtbf: 0 rtb: 0 nt: 4 onoff: 0/0:0/0 -1,0:-1,0 0:0 (HZ=1000) barrier: 0/0:0
[  424.850283] rcu-torture: Reader Pipe:  8 0 0 0 0 0 0 0 0 0 0
[  424.850283] rcu-torture: Reader Batch:  8 0 0 0 0 0 0 0 0 0 0
[  424.850283] rcu-torture: Free-Block Circulation:  0 0 0 0 0 0 0 0 0 0 0
[  484.870189] rcu-torture: rtc: ffffffff82da41a0 ver: 1 tfle: 0 rta: 1 rtaf: 0 rtf: 0 rtmbe: 0 rtbke: 0 rtbre: 0 rtbf: 0 rtb: 0 nt: 4 onoff: 0/0:0/0 -1,0:-1,0 0:0 (HZ=1000) barrier: 0/0:0
[  484.870189] rcu-torture: Reader Pipe:  8 0 0 0 0 0 0 0 0 0 0
[  484.870189] rcu-torture: Reader Batch:  8 0 0 0 0 0 0 0 0 0 0
[  484.870189] rcu-torture: Free-Block Circulation:  0 0 0 0 0 0 0 0 0 0 0
[  509.549736] SMP alternatives: lockdep: fixing up alternatives
[  509.576134] smpboot: Booting Node 0 Processor 1 APIC 0x1
[  409.500726] masked ExtINT on CPU#1
[  409.500726] numa_add_cpu cpu 1 node 0: mask now 0-1
[  509.624234] CPU0 attaching NULL sched-domain.
[  509.627390] CPU0 attaching sched-domain:
[  509.629843]  domain 0: span 0-1 level CPU
[  509.632695]   groups: 0 (cpu_power = 1023) 1
[  509.644493] CPU1 attaching sched-domain:
[  509.647464]  domain 0: span 0-1 level CPU
[  509.650655]   groups: 1 0 (cpu_power = 1023)
[  509.679241] CPU0 attaching NULL sched-domain.
[  509.682375] CPU1 attaching NULL sched-domain.
[  509.685652] CPU0 attaching NULL sched-domain.
[  509.692802] numa_remove_cpu cpu 1 node 0: mask now 0
[  509.712914] smpboot: CPU 1 is now offline
[  509.858560] SMP alternatives: lockdep: fixing up alternatives
[  509.864082] smpboot: Booting Node 0 Processor 1 APIC 0x1
[  509.693020] masked ExtINT on CPU#1
[  509.693020] numa_add_cpu cpu 1 node 0: mask now 0-1
[  509.908960] CPU0 attaching NULL sched-domain.
[  509.912209] CPU0 attaching sched-domain:
[  509.914994]  domain 0: span 0-1 level CPU
[  509.920580]   groups: 0 (cpu_power = 1023) 1
[  509.925229] CPU1 attaching sched-domain:
[  509.927608]  domain 0: span 0-1 level CPU
[  509.933225]   groups: 1 0 (cpu_power = 1023)
[  510.959521] CPU0 attaching NULL sched-domain.
[  510.964484] CPU1 attaching NULL sched-domain.
[  510.969799] CPU0 attaching NULL sched-domain.
[  510.974718] numa_remove_cpu cpu 1 node 0: mask now 0
[  510.980671] smpboot: CPU 1 is now offline
[  521.032772] SMP alternatives: lockdep: fixing up alternatives
[  521.043126] smpboot: Booting Node 0 Processor 1 APIC 0x1
[  510.975586] masked ExtINT on CPU#1
[  510.975586] numa_add_cpu cpu 1 node 0: mask now 0-1
[  521.085969] CPU0 attaching NULL sched-domain.
[  521.090233] CPU0 attaching sched-domain:
[  521.093830]  domain 0: span 0-1 level CPU
[  521.097811]   groups: 0 (cpu_power = 1023) 1
[  521.102112] CPU1 attaching sched-domain:
[  521.105216]  domain 0: span 0-1 level CPU
[  521.108570]   groups: 1 0 (cpu_power = 1023)
[  544.894211] rcu-torture: rtc: ffffffff82da41a0 ver: 1 tfle: 0 rta: 1 rtaf: 0 rtf: 0 rtmbe: 0 rtbke: 0 rtbre: 0 rtbf: 0 rtb: 0 nt: 4 onoff: 0/0:0/0 -1,0:-1,0 0:0 (HZ=1000) barrier: 0/0:0
[  544.894211] rcu-torture: Reader Pipe:  8 0 0 0 0 0 0 0 0 0 0
[  544.894211] rcu-torture: Reader Batch:  8 0 0 0 0 0 0 0 0 0 0
[  544.894211] rcu-torture: Free-Block Circulation:  0 0 0 0 0 0 0 0 0 0 0
[  604.957402] rcu-torture: rtc: ffffffff82da41a0 ver: 1 tfle: 0 rta: 1 rtaf: 0 rtf: 0 rtmbe: 0 rtbke: 0 rtbre: 0 rtbf: 0 rtb: 0 nt: 4 onoff: 0/0:0/0 -1,0:-1,0 0:0 (HZ=1000) barrier: 0/0:0
[  604.957402] rcu-torture: Reader Pipe:  8 0 0 0 0 0 0 0 0 0 0
[  604.957402] rcu-torture: Reader Batch:  8 0 0 0 0 0 0 0 0 0 0
[  604.957402] rcu-torture: Free-Block Circulation:  0 0 0 0 0 0 0 0 0 0 0
[  621.168450] CPU0 attaching NULL sched-domain.
[  621.171715] CPU1 attaching NULL sched-domain.
[  621.175415] CPU0 attaching NULL sched-domain.
[  621.223979] numa_remove_cpu cpu 1 node 0: mask now 0
[  621.296578] smpboot: CPU 1 is now offline
[  623.003320] SMP alternatives: lockdep: fixing up alternatives
[  623.199824] smpboot: Booting Node 0 Processor 1 APIC 0x1
[  621.224312] masked ExtINT on CPU#1
[  621.224312] numa_add_cpu cpu 1 node 0: mask now 0-1
[  623.589935] CPU0 attaching NULL sched-domain.
[  623.795355] CPU0 attaching sched-domain:
[  623.854837]  domain 0: span 0-1 level CPU
[  623.858346]   groups: 0 (cpu_power = 1022) 1
[  623.993124] CPU1 attaching sched-domain:
[  624.117939]  domain 0: span 0-1 level CPU
[  624.623521]   groups: 1 0 (cpu_power = 1022)
[  624.949548] CPU0 attaching NULL sched-domain.
[  624.952047] CPU1 attaching NULL sched-domain.
[  625.015481] CPU0 attaching NULL sched-domain.
[  625.054301] numa_remove_cpu cpu 1 node 0: mask now 0
[  625.118258] smpboot: CPU 1 is now offline
[  626.988687] SMP alternatives: lockdep: fixing up alternatives
[  627.021839] smpboot: Booting Node 0 Processor 1 APIC 0x1
[  625.055222] masked ExtINT on CPU#1
[  625.055222] numa_add_cpu cpu 1 node 0: mask now 0-1
[  627.608578] CPU0 attaching NULL sched-domain.
[  627.612266] CPU0 attaching sched-domain:
[  627.666147]  domain 0: span 0-1 level CPU
[  627.748549]   groups: 0 (cpu_power = 980) 1
[  627.923982] CPU1 attaching sched-domain:
[  627.927057]  domain 0: span 0-1 level CPU
[  628.008300]   groups: 1 0 (cpu_power = 988)
[  638.330315] CPU0 attaching NULL sched-domain.
[  638.333726] CPU1 attaching NULL sched-domain.
[  638.363694] CPU0 attaching NULL sched-domain.
[  638.459338] numa_remove_cpu cpu 1 node 0: mask now 0
[  638.521192] smpboot: CPU 1 is now offline
[  665.384202] rcu-torture: rtc: ffffffff82da41a0 ver: 1 tfle: 0 rta: 1 rtaf: 0 rtf: 0 rtmbe: 0 rtbke: 0 rtbre: 0 rtbf: 0 rtb: 0 nt: 4 onoff: 0/0:0/0 -1,0:-1,0 0:0 (HZ=1000) barrier: 0/0:0
[  665.384202] rcu-torture: Reader Pipe:  8 0 0 0 0 0 0 0 0 0 0
[  665.384202] rcu-torture: Reader Batch:  8 0 0 0 0 0 0 0 0 0 0
[  665.384202] rcu-torture: Free-Block Circulation:  0 0 0 0 0 0 0 0 0 0 0
[  725.583767] rcu-torture: rtc: ffffffff82da41a0 ver: 1 tfle: 0 rta: 1 rtaf: 0 rtf: 0 rtmbe: 0 rtbke: 0 rtbre: 0 rtbf: 0 rtb: 0 nt: 4 onoff: 0/0:0/0 -1,0:-1,0 0:0 (HZ=1000) barrier: 0/0:0
[  725.583767] rcu-torture: Reader Pipe:  8 0 0 0 0 0 0 0 0 0 0
[  725.583767] rcu-torture: Reader Batch:  8 0 0 0 0 0 0 0 0 0 0
[  725.583767] rcu-torture: Free-Block Circulation:  0 0 0 0 0 0 0 0 0 0 0
[  739.083494] SMP alternatives: lockdep: fixing up alternatives
[  739.087302] smpboot: Booting Node 0 Processor 1 APIC 0x1
[  638.460201] masked ExtINT on CPU#1
[  638.460201] numa_add_cpu cpu 1 node 0: mask now 0-1
[  739.469982] CPU0 attaching NULL sched-domain.
[  739.474273] CPU0 attaching sched-domain:
[  739.571818]  domain 0: span 0-1 level CPU
[  739.601364]   groups: 0 (cpu_power = 1023) 1
[  739.705488] CPU1 attaching sched-domain:
[  739.734186]  domain 0: span 0-1 level CPU
[  739.761817]   groups: 1 0 (cpu_power = 1023)
[  740.139760] CPU0 attaching NULL sched-domain.
[  740.142535] CPU1 attaching NULL sched-domain.
[  740.146841] CPU0 attaching NULL sched-domain.
[  740.180477] numa_remove_cpu cpu 1 node 0: mask now 0
[  740.227156] smpboot: CPU 1 is now offline
[  741.134381] SMP alternatives: lockdep: fixing up alternatives
[  741.264552] smpboot: Booting Node 0 Processor 1 APIC 0x1
[  740.181034] masked ExtINT on CPU#1
[  740.181034] numa_add_cpu cpu 1 node 0: mask now 0-1
[  741.638494] CPU0 attaching NULL sched-domain.
[  741.746999] CPU0 attaching sched-domain:
[  741.795225]  domain 0: span 0-1 level CPU
[  741.817924]   groups: 0 (cpu_power = 990) 1
[  741.846289] CPU1 attaching sched-domain:
[  741.909602]  domain 0: span 0-1 level CPU
[  741.926040]   groups: 1 0 (cpu_power = 992)
[  743.182568] CPU0 attaching NULL sched-domain.
[  743.185596] CPU1 attaching NULL sched-domain.
[  743.192171] CPU0 attaching NULL sched-domain.
[  743.237623] numa_remove_cpu cpu 1 node 0: mask now 0
[  743.249657] smpboot: CPU 1 is now offline
[  753.570388] SMP alternatives: lockdep: fixing up alternatives
[  753.584015] smpboot: Booting Node 0 Processor 1 APIC 0x1
[  743.238442] masked ExtINT on CPU#1
[  743.238442] numa_add_cpu cpu 1 node 0: mask now 0-1
[  753.706607] CPU0 attaching NULL sched-domain.
[  753.722746] CPU0 attaching sched-domain:
[  753.725765]  domain 0: span 0-1 level CPU
[  753.728581]   groups: 0 (cpu_power = 1022) 1
[  753.741979] CPU1 attaching sched-domain:
[  753.760246]  domain 0: span 0-1 level CPU
[  753.764262]   groups: 1 0 (cpu_power = 1022)
[  785.688202] rcu-torture: rtc: ffffffff82da41a0 ver: 1 tfle: 0 rta: 1 rtaf: 0 rtf: 0 rtmbe: 0 rtbke: 0 rtbre: 0 rtbf: 0 rtb: 0 nt: 4 onoff: 0/0:0/0 -1,0:-1,0 0:0 (HZ=1000) barrier: 0/0:0
[  785.688202] rcu-torture: Reader Pipe:  8 0 0 0 0 0 0 0 0 0 0
[  785.688202] rcu-torture: Reader Batch:  8 0 0 0 0 0 0 0 0 0 0
[  785.688202] rcu-torture: Free-Block Circulation:  0 0 0 0 0 0 0 0 0 0 0
[  845.809157] rcu-torture: rtc: ffffffff82da41a0 ver: 1 tfle: 0 rta: 1 rtaf: 0 rtf: 0 rtmbe: 0 rtbke: 0 rtbre: 0 rtbf: 0 rtb: 0 nt: 4 onoff: 0/0:0/0 -1,0:-1,0 0:0 (HZ=1000) barrier: 0/0:0
[  845.809157] rcu-torture: Reader Pipe:  8 0 0 0 0 0 0 0 0 0 0
[  845.809157] rcu-torture: Reader Batch:  8 0 0 0 0 0 0 0 0 0 0
[  845.809157] rcu-torture: Free-Block Circulation:  0 0 0 0 0 0 0 0 0 0 0
[  853.847459] CPU0 attaching NULL sched-domain.
[  853.871287] CPU1 attaching NULL sched-domain.
[  853.906275] CPU0 attaching NULL sched-domain.
[  854.019249] numa_remove_cpu cpu 1 node 0: mask now 0
[  854.076495] smpboot: CPU 1 is now offline
[  854.454556] SMP alternatives: lockdep: fixing up alternatives
[  854.595479] smpboot: Booting Node 0 Processor 1 APIC 0x1
[  854.020015] masked ExtINT on CPU#1
[  854.020015] numa_add_cpu cpu 1 node 0: mask now 0-1
[  854.901584] CPU0 attaching NULL sched-domain.
[  854.946550] CPU0 attaching sched-domain:
[  854.964850]  domain 0: span 0-1 level CPU
[  854.984817]   groups: 0 (cpu_power = 1023) 1
[  855.020302] CPU1 attaching sched-domain:
[  855.054144]  domain 0: span 0-1 level CPU
[  855.070148]   groups: 1 0 (cpu_power = 1023)
[  855.466463] CPU0 attaching NULL sched-domain.
[  855.493965] CPU1 attaching NULL sched-domain.
[  855.516445] CPU0 attaching NULL sched-domain.
[  855.541658] numa_remove_cpu cpu 1 node 0: mask now 0
[  855.594351] smpboot: CPU 1 is now offline
[  856.944623] SMP alternatives: lockdep: fixing up alternatives
[  857.097776] smpboot: Booting Node 0 Processor 1 APIC 0x1
[  855.542023] masked ExtINT on CPU#1
[  855.542023] numa_add_cpu cpu 1 node 0: mask now 0-1
[  857.270313] CPU0 attaching NULL sched-domain.
[  857.326806] CPU0 attaching sched-domain:
[  857.362809]  domain 0: span 0-1 level CPU
[  857.400286]   groups: 0 (cpu_power = 1023) 1
[  857.427389] CPU1 attaching sched-domain:
[  857.462993]  domain 0: span 0-1 level CPU
[  857.487218]   groups: 1 0 (cpu_power = 1023)
[  867.800169] CPU0 attaching NULL sched-domain.
[  867.803529] CPU1 attaching NULL sched-domain.
[  867.806762] CPU0 attaching NULL sched-domain.
[  867.827285] numa_remove_cpu cpu 1 node 0: mask now 0
[  867.848558] smpboot: CPU 1 is now offline
[  905.986186] rcu-torture: rtc: ffffffff82da41a0 ver: 1 tfle: 0 rta: 1 rtaf: 0 rtf: 0 rtmbe: 0 rtbke: 0 rtbre: 0 rtbf: 0 rtb: 0 nt: 4 onoff: 0/0:0/0 -1,0:-1,0 0:0 (HZ=1000) barrier: 0/0:0
[  905.986186] rcu-torture: Reader Pipe:  8 0 0 0 0 0 0 0 0 0 0
[  905.986186] rcu-torture: Reader Batch:  8 0 0 0 0 0 0 0 0 0 0
[  905.986186] rcu-torture: Free-Block Circulation:  0 0 0 0 0 0 0 0 0 0 0
[  966.038325] rcu-torture: rtc: ffffffff82da41a0 ver: 1 tfle: 0 rta: 1 rtaf: 0 rtf: 0 rtmbe: 0 rtbke: 0 rtbre: 0 rtbf: 0 rtb: 0 nt: 4 onoff: 0/0:0/0 -1,0:-1,0 0:0 (HZ=1000) barrier: 0/0:0
[  966.038325] rcu-torture: Reader Pipe:  8 0 0 0 0 0 0 0 0 0 0
[  966.038325] rcu-torture: Reader Batch:  8 0 0 0 0 0 0 0 0 0 0
[  966.038325] rcu-torture: Free-Block Circulation:  0 0 0 0 0 0 0 0 0 0 0
[  968.333105] SMP alternatives: lockdep: fixing up alternatives
[  968.339127] smpboot: Booting Node 0 Processor 1 APIC 0x1
[  867.828008] masked ExtINT on CPU#1
[  867.828008] numa_add_cpu cpu 1 node 0: mask now 0-1
[  968.378868] CPU0 attaching NULL sched-domain.
[  968.382526] CPU0 attaching sched-domain:
[  968.385284]  domain 0: span 0-1 level CPU
[  968.388246]   groups: 0 (cpu_power = 1022) 1
[  968.391910] CPU1 attaching sched-domain:
[  968.394725]  domain 0: span 0-1 level CPU
[  968.397805]   groups: 1 0 (cpu_power = 1022)
[  968.423803] CPU0 attaching NULL sched-domain.
[  968.426889] CPU1 attaching NULL sched-domain.
[  968.429940] CPU0 attaching NULL sched-domain.
[  968.433512] numa_remove_cpu cpu 1 node 0: mask now 0
[  968.438705] smpboot: CPU 1 is now offline
[  968.590111] SMP alternatives: lockdep: fixing up alternatives
[  968.598826] smpboot: Booting Node 0 Processor 1 APIC 0x1
[  968.434020] masked ExtINT on CPU#1
[  968.434020] numa_add_cpu cpu 1 node 0: mask now 0-1
[  968.636795] CPU0 attaching NULL sched-domain.
[  968.640470] CPU0 attaching sched-domain:
[  968.643297]  domain 0: span 0-1 level CPU
[  968.646210]   groups: 0 (cpu_power = 1023) 1
[  968.650141] CPU1 attaching sched-domain:
[  968.652858]  domain 0: span 0-1 level CPU
[  968.655783]   groups: 1 0 (cpu_power = 1023)
[  969.687175] CPU0 attaching NULL sched-domain.
[  969.690212] CPU1 attaching NULL sched-domain.
[  969.693250] CPU0 attaching NULL sched-domain.
[  969.698933] numa_remove_cpu cpu 1 node 0: mask now 0
[  969.706391] smpboot: CPU 1 is now offline
[  979.766527] SMP alternatives: lockdep: fixing up alternatives
[  979.779132] smpboot: Booting Node 0 Processor 1 APIC 0x1
[  969.699826] masked ExtINT on CPU#1
[  969.699826] numa_add_cpu cpu 1 node 0: mask now 0-1
[  979.816844] CPU0 attaching NULL sched-domain.
[  979.820333] CPU0 attaching sched-domain:
[  979.823072]  domain 0: span 0-1 level CPU
[  979.826033]   groups: 0 (cpu_power = 1022) 1
[  979.830087] CPU1 attaching sched-domain:
[  979.832746]  domain 0: span 0-1 level CPU
[  979.835707]   groups: 1 0 (cpu_power = 1022)
[ 1026.062311] rcu-torture: rtc: ffffffff82da41a0 ver: 1 tfle: 0 rta: 1 rtaf: 0 rtf: 0 rtmbe: 0 rtbke: 0 rtbre: 0 rtbf: 0 rtb: 0 nt: 4 onoff: 0/0:0/0 -1,0:-1,0 0:0 (HZ=1000) barrier: 0/0:0
[ 1026.062311] rcu-torture: Reader Pipe:  8 0 0 0 0 0 0 0 0 0 0
[ 1026.062311] rcu-torture: Reader Batch:  8 0 0 0 0 0 0 0 0 0 0
[ 1026.062311] rcu-torture: Free-Block Circulation:  0 0 0 0 0 0 0 0 0 0 0
[ 1079.863341] CPU0 attaching NULL sched-domain.
[ 1079.866180] CPU1 attaching NULL sched-domain.
[ 1079.871324] CPU0 attaching NULL sched-domain.
[ 1079.874764] numa_remove_cpu cpu 1 node 0: mask now 0
[ 1079.880139] smpboot: CPU 1 is now offline
[ 1079.951622] SMP alternatives: lockdep: fixing up alternatives
[ 1079.959194] smpboot: Booting Node 0 Processor 1 APIC 0x1
[ 1079.875084] masked ExtINT on CPU#1
[ 1079.875084] numa_add_cpu cpu 1 node 0: mask now 0-1
[ 1080.024622] CPU0 attaching NULL sched-domain.
[ 1080.030475] CPU0 attaching sched-domain:
[ 1080.033412]  domain 0: span 0-1 level CPU
[ 1080.036375]   groups: 0 (cpu_power = 1022) 1
[ 1080.040205] CPU1 attaching sched-domain:
[ 1080.042845]  domain 0: span 0-1 level CPU
[ 1080.045822]   groups: 1 0 (cpu_power = 1022)
[ 1080.179277] CPU0 attaching NULL sched-domain.
[ 1080.182553] CPU1 attaching NULL sched-domain.
[ 1080.185288] CPU0 attaching NULL sched-domain.
[ 1080.190616] numa_remove_cpu cpu 1 node 0: mask now 0
[ 1080.195851] smpboot: CPU 1 is now offline
[ 1081.246770] SMP alternatives: lockdep: fixing up alternatives
[ 1081.253143] smpboot: Booting Node 0 Processor 1 APIC 0x1
[ 1080.191025] masked ExtINT on CPU#1
[ 1080.191025] numa_add_cpu cpu 1 node 0: mask now 0-1
[ 1081.293725] CPU0 attaching NULL sched-domain.
[ 1081.318493] CPU0 attaching sched-domain:
[ 1081.321335]  domain 0: span 0-1 level CPU
[ 1081.324374]   groups: 0 (cpu_power = 1023) 1
[ 1081.328196] CPU1 attaching sched-domain:
[ 1081.331045]  domain 0: span 0-1 level CPU
[ 1081.334081]   groups: 1 0 (cpu_power = 1023)
[ 1086.081278] rcu-torture: rtc: ffffffff82da41a0 ver: 1 tfle: 0 rta: 1 rtaf: 0 rtf: 0 rtmbe: 0 rtbke: 0 rtbre: 0 rtbf: 0 rtb: 0 nt: 4 onoff: 0/0:0/0 -1,0:-1,0 0:0 (HZ=1000) barrier: 0/0:0
[ 1086.081278] rcu-torture: Reader Pipe:  8 0 0 0 0 0 0 0 0 0 0
[ 1086.081278] rcu-torture: Reader Batch:  8 0 0 0 0 0 0 0 0 0 0
[ 1086.081278] rcu-torture: Free-Block Circulation:  0 0 0 0 0 0 0 0 0 0 0
[ 1091.367199] CPU0 attaching NULL sched-domain.
[ 1091.369949] CPU1 attaching NULL sched-domain.
[ 1091.373238] CPU0 attaching NULL sched-domain.
[ 1091.379298] numa_remove_cpu cpu 1 node 0: mask now 0
[ 1091.384148] smpboot: CPU 1 is now offline
[ 1146.099217] rcu-torture: rtc: ffffffff82da41a0 ver: 1 tfle: 0 rta: 1 rtaf: 0 rtf: 0 rtmbe: 0 rtbke: 0 rtbre: 0 rtbf: 0 rtb: 0 nt: 4 onoff: 0/0:0/0 -1,0:-1,0 0:0 (HZ=1000) barrier: 0/0:0
[ 1146.099217] rcu-torture: Reader Pipe:  8 0 0 0 0 0 0 0 0 0 0
[ 1146.099217] rcu-torture: Reader Batch:  8 0 0 0 0 0 0 0 0 0 0
[ 1146.099217] rcu-torture: Free-Block Circulation:  0 0 0 0 0 0 0 0 0 0 0
[ 1191.442084] SMP alternatives: lockdep: fixing up alternatives
[ 1191.451135] smpboot: Booting Node 0 Processor 1 APIC 0x1
[ 1091.380176] masked ExtINT on CPU#1
[ 1091.380176] numa_add_cpu cpu 1 node 0: mask now 0-1
[ 1191.489333] CPU0 attaching NULL sched-domain.
[ 1191.493189] CPU0 attaching sched-domain:
[ 1191.496208]  domain 0: span 0-1 level CPU
[ 1191.499478]   groups: 0 (cpu_power = 1023) 1
[ 1191.503727] CPU1 attaching sched-domain:
[ 1191.506904]  domain 0: span 0-1 level CPU
[ 1191.510177]   groups: 1 0 (cpu_power = 1023)
[ 1191.542184] CPU0 attaching NULL sched-domain.
[ 1191.544480] CPU1 attaching NULL sched-domain.
[ 1191.546902] CPU0 attaching NULL sched-domain.
[ 1191.549723] numa_remove_cpu cpu 1 node 0: mask now 0
[ 1191.554682] smpboot: CPU 1 is now offline
[ 1191.707213] SMP alternatives: lockdep: fixing up alternatives
[ 1191.718119] smpboot: Booting Node 0 Processor 1 APIC 0x1
[ 1191.550121] masked ExtINT on CPU#1
[ 1191.550121] numa_add_cpu cpu 1 node 0: mask now 0-1
[ 1191.758342] CPU0 attaching NULL sched-domain.
[ 1191.762297] CPU0 attaching sched-domain:
[ 1191.765370]  domain 0: span 0-1 level CPU
[ 1191.768829]   groups: 0 (cpu_power = 1022) 1
[ 1191.773160] CPU1 attaching sched-domain:
[ 1191.776341]  domain 0: span 0-1 level CPU
[ 1191.779737]   groups: 1 0 (cpu_power = 1022)
[ 1192.811003] CPU0 attaching NULL sched-domain.
[ 1192.814372] CPU1 attaching NULL sched-domain.
[ 1192.817754] CPU0 attaching NULL sched-domain.
[ 1192.829154] numa_remove_cpu cpu 1 node 0: mask now 0
[ 1192.834603] smpboot: CPU 1 is now offline
[ 1202.889207] SMP alternatives: lockdep: fixing up alternatives
[ 1202.895132] smpboot: Booting Node 0 Processor 1 APIC 0x1
[ 1192.830026] masked ExtINT on CPU#1
[ 1192.830026] numa_add_cpu cpu 1 node 0: mask now 0-1
[ 1202.941275] CPU0 attaching NULL sched-domain.
[ 1202.945312] CPU0 attaching sched-domain:
[ 1202.948323]  domain 0: span 0-1 level CPU
[ 1202.951747]   groups: 0 (cpu_power = 1023) 1
[ 1202.955860] CPU1 attaching sched-domain:
[ 1202.958833]  domain 0: span 0-1 level CPU
[ 1202.962279]   groups: 1 0 (cpu_power = 1023)
[ 1206.128221] rcu-torture: rtc: ffffffff82da41a0 ver: 1 tfle: 0 rta: 1 rtaf: 0 rtf: 0 rtmbe: 0 rtbke: 0 rtbre: 0 rtbf: 0 rtb: 0 nt: 4 onoff: 0/0:0/0 -1,0:-1,0 0:0 (HZ=1000) barrier: 0/0:0
[ 1206.128221] rcu-torture: Reader Pipe:  8 0 0 0 0 0 0 0 0 0 0
[ 1206.128221] rcu-torture: Reader Batch:  8 0 0 0 0 0 0 0 0 0 0
[ 1206.128221] rcu-torture: Free-Block Circulation:  0 0 0 0 0 0 0 0 0 0 0
[ 1266.151281] rcu-torture: rtc: ffffffff82da41a0 ver: 1 tfle: 0 rta: 1 rtaf: 0 rtf: 0 rtmbe: 0 rtbke: 0 rtbre: 0 rtbf: 0 rtb: 0 nt: 4 onoff: 0/0:0/0 -1,0:-1,0 0:0 (HZ=1000) barrier: 0/0:0
[ 1266.151281] rcu-torture: Reader Pipe:  8 0 0 0 0 0 0 0 0 0 0
[ 1266.151281] rcu-torture: Reader Batch:  8 0 0 0 0 0 0 0 0 0 0
[ 1266.151281] rcu-torture: Free-Block Circulation:  0 0 0 0 0 0 0 0 0 0 0
[ 1302.995187] CPU0 attaching NULL sched-domain.
[ 1302.999950] CPU1 attaching NULL sched-domain.
[ 1303.002756] CPU0 attaching NULL sched-domain.
[ 1303.005846] numa_remove_cpu cpu 1 node 0: mask now 0
[ 1303.010851] smpboot: CPU 1 is now offline
[ 1303.084170] SMP alternatives: lockdep: fixing up alternatives
[ 1303.092394] smpboot: Booting Node 0 Processor 1 APIC 0x1
[ 1303.006304] masked ExtINT on CPU#1
[ 1303.006304] numa_add_cpu cpu 1 node 0: mask now 0-1
[ 1303.141346] CPU0 attaching NULL sched-domain.
[ 1303.148946] CPU0 attaching sched-domain:
[ 1303.152191]  domain 0: span 0-1 level CPU
[ 1303.158635]   groups: 0 (cpu_power = 1023) 1
[ 1303.163180] CPU1 attaching sched-domain:
[ 1303.166254]  domain 0: span 0-1 level CPU
[ 1303.169608]   groups: 1 0 (cpu_power = 1023)
[ 1303.301434] CPU0 attaching NULL sched-domain.
[ 1303.304824] CPU1 attaching NULL sched-domain.
[ 1303.308342] CPU0 attaching NULL sched-domain.
[ 1303.314545] numa_remove_cpu cpu 1 node 0: mask now 0
[ 1303.320468] smpboot: CPU 1 is now offline
[ 1304.386703] SMP alternatives: lockdep: fixing up alternatives
[ 1304.401956] smpboot: Booting Node 0 Processor 1 APIC 0x1
[ 1303.315420] masked ExtINT on CPU#1
[ 1303.315420] numa_add_cpu cpu 1 node 0: mask now 0-1
[ 1304.442804] CPU0 attaching NULL sched-domain.
[ 1304.445709] CPU0 attaching sched-domain:
[ 1304.448155]  domain 0: span 0-1 level CPU
[ 1304.450620]   groups: 0 (cpu_power = 1023) 1
[ 1304.453668] CPU1 attaching sched-domain:
[ 1304.455830]  domain 0: span 0-1 level CPU
[ 1304.458228]   groups: 1 0 (cpu_power = 1023)
[ 1314.491258] CPU0 attaching NULL sched-domain.
[ 1314.494159] CPU1 attaching NULL sched-domain.
[ 1314.497288] CPU0 attaching NULL sched-domain.
[ 1314.502838] numa_remove_cpu cpu 1 node 0: mask now 0
[ 1314.508267] smpboot: CPU 1 is now offline
[ 1326.169243] rcu-torture: rtc: ffffffff82da41a0 ver: 1 tfle: 0 rta: 1 rtaf: 0 rtf: 0 rtmbe: 0 rtbke: 0 rtbre: 0 rtbf: 0 rtb: 0 nt: 4 onoff: 0/0:0/0 -1,0:-1,0 0:0 (HZ=1000) barrier: 0/0:0
[ 1326.169243] rcu-torture: Reader Pipe:  8 0 0 0 0 0 0 0 0 0 0
[ 1326.169243] rcu-torture: Reader Batch:  8 0 0 0 0 0 0 0 0 0 0
[ 1326.169243] rcu-torture: Free-Block Circulation:  0 0 0 0 0 0 0 0 0 0 0
[ 1386.188275] rcu-torture: rtc: ffffffff82da41a0 ver: 1 tfle: 0 rta: 1 rtaf: 0 rtf: 0 rtmbe: 0 rtbke: 0 rtbre: 0 rtbf: 0 rtb: 0 nt: 4 onoff: 0/0:0/0 -1,0:-1,0 0:0 (HZ=1000) barrier: 0/0:0
[ 1386.188275] rcu-torture: Reader Pipe:  8 0 0 0 0 0 0 0 0 0 0
[ 1386.188275] rcu-torture: Reader Batch:  8 0 0 0 0 0 0 0 0 0 0
[ 1386.188275] rcu-torture: Free-Block Circulation:  0 0 0 0 0 0 0 0 0 0 0
[ 1414.559584] SMP alternatives: lockdep: fixing up alternatives
[ 1414.569148] smpboot: Booting Node 0 Processor 1 APIC 0x1
[ 1314.503138] masked ExtINT on CPU#1
[ 1314.503138] numa_add_cpu cpu 1 node 0: mask now 0-1
[ 1414.612640] CPU0 attaching NULL sched-domain.
[ 1414.616592] CPU0 attaching sched-domain:
[ 1414.619767]  domain 0: span 0-1 level CPU
[ 1414.623082]   groups: 0 (cpu_power = 1023) 1
[ 1414.627513] CPU1 attaching sched-domain:
[ 1414.630614]  domain 0: span 0-1 level CPU
[ 1414.633984]   groups: 1 0 (cpu_power = 1023)
[ 1414.667800] CPU0 attaching NULL sched-domain.
[ 1414.670774] CPU1 attaching NULL sched-domain.
[ 1414.673751] CPU0 attaching NULL sched-domain.
[ 1414.677466] numa_remove_cpu cpu 1 node 0: mask now 0
[ 1414.682862] smpboot: CPU 1 is now offline
[ 1414.829715] SMP alternatives: lockdep: fixing up alternatives
[ 1414.839127] smpboot: Booting Node 0 Processor 1 APIC 0x1
[ 1414.678032] masked ExtINT on CPU#1
[ 1414.678032] numa_add_cpu cpu 1 node 0: mask now 0-1
[ 1414.880414] CPU0 attaching NULL sched-domain.
[ 1414.884236] CPU0 attaching sched-domain:
[ 1414.887112]  domain 0: span 0-1 level CPU
[ 1414.890543]   groups: 0 (cpu_power = 1009) 1
[ 1414.894859] CPU1 attaching sched-domain:
[ 1414.897743]  domain 0: span 0-1 level CPU
[ 1414.901174]   groups: 1 0 (cpu_power = 1009)
[ 1415.930695] CPU0 attaching NULL sched-domain.
[ 1415.933982] CPU1 attaching NULL sched-domain.
[ 1415.937441] CPU0 attaching NULL sched-domain.
[ 1415.942174] numa_remove_cpu cpu 1 node 0: mask now 0
[ 1415.947703] smpboot: CPU 1 is now offline
[ 1426.000108] SMP alternatives: lockdep: fixing up alternatives
[ 1426.010109] smpboot: Booting Node 0 Processor 1 APIC 0x1
[ 1415.943029] masked ExtINT on CPU#1
[ 1415.943029] numa_add_cpu cpu 1 node 0: mask now 0-1
[ 1426.049315] CPU0 attaching NULL sched-domain.
[ 1426.053398] CPU0 attaching sched-domain:
[ 1426.056301]  domain 0: span 0-1 level CPU
[ 1426.059608]   groups: 0 (cpu_power = 1023) 1
[ 1426.064051] CPU1 attaching sched-domain:
[ 1426.067031]  domain 0: span 0-1 level CPU
[ 1426.070273]   groups: 1 0 (cpu_power = 1023)
[ 1446.206316] rcu-torture: rtc: ffffffff82da41a0 ver: 1 tfle: 0 rta: 1 rtaf: 0 rtf: 0 rtmbe: 0 rtbke: 0 rtbre: 0 rtbf: 0 rtb: 0 nt: 4 onoff: 0/0:0/0 -1,0:-1,0 0:0 (HZ=1000) barrier: 0/0:0
[ 1446.206316] rcu-torture: Reader Pipe:  8 0 0 0 0 0 0 0 0 0 0
[ 1446.206316] rcu-torture: Reader Batch:  8 0 0 0 0 0 0 0 0 0 0
[ 1446.206316] rcu-torture: Free-Block Circulation:  0 0 0 0 0 0 0 0 0 0 0
[ 1506.220283] rcu-torture: rtc: ffffffff82da41a0 ver: 1 tfle: 0 rta: 1 rtaf: 0 rtf: 0 rtmbe: 0 rtbke: 0 rtbre: 0 rtbf: 0 rtb: 0 nt: 4 onoff: 0/0:0/0 -1,0:-1,0 0:0 (HZ=1000) barrier: 0/0:0
[ 1506.220283] rcu-torture: Reader Pipe:  8 0 0 0 0 0 0 0 0 0 0
[ 1506.220283] rcu-torture: Reader Batch:  8 0 0 0 0 0 0 0 0 0 0
[ 1506.220283] rcu-torture: Free-Block Circulation:  0 0 0 0 0 0 0 0 0 0 0
[ 1526.099129] CPU0 attaching NULL sched-domain.
[ 1526.102165] CPU1 attaching NULL sched-domain.
[ 1526.105283] CPU0 attaching NULL sched-domain.
[ 1526.112294] numa_remove_cpu cpu 1 node 0: mask now 0
[ 1526.117194] smpboot: CPU 1 is now offline
[ 1526.191847] SMP alternatives: lockdep: fixing up alternatives
[ 1526.208130] smpboot: Booting Node 0 Processor 1 APIC 0x1
[ 1526.113190] masked ExtINT on CPU#1
[ 1526.113190] numa_add_cpu cpu 1 node 0: mask now 0-1
[ 1526.256681] CPU0 attaching NULL sched-domain.
[ 1526.263562] CPU0 attaching sched-domain:
[ 1526.266329]  domain 0: span 0-1 level CPU
[ 1526.269408]   groups: 0 (cpu_power = 1022) 1
[ 1526.273131] CPU1 attaching sched-domain:
[ 1526.275886]  domain 0: span 0-1 level CPU
[ 1526.278865]   groups: 1 0 (cpu_power = 1022)
[ 1526.407247] CPU0 attaching NULL sched-domain.
[ 1526.410202] CPU1 attaching NULL sched-domain.
[ 1526.413322] CPU0 attaching NULL sched-domain.
[ 1526.417023] numa_remove_cpu cpu 1 node 0: mask now 0
[ 1526.422084] smpboot: CPU 1 is now offline
[ 1527.467961] SMP alternatives: lockdep: fixing up alternatives
[ 1527.477187] smpboot: Booting Node 0 Processor 1 APIC 0x1
[ 1526.417904] masked ExtINT on CPU#1
[ 1526.417904] numa_add_cpu cpu 1 node 0: mask now 0-1
[ 1527.516798] CPU0 attaching NULL sched-domain.
[ 1527.520702] CPU0 attaching sched-domain:
[ 1527.523555]  domain 0: span 0-1 level CPU
[ 1527.549082]   groups: 0 (cpu_power = 1023) 1
[ 1527.553054] CPU1 attaching sched-domain:
[ 1527.555820]  domain 0: span 0-1 level CPU
[ 1527.558965]   groups: 1 0 (cpu_power = 1023)
[ 1537.605931] CPU0 attaching NULL sched-domain.
[ 1537.608286] CPU1 attaching NULL sched-domain.
[ 1537.610784] CPU0 attaching NULL sched-domain.
[ 1537.613531] numa_remove_cpu cpu 1 node 0: mask now 0
[ 1537.618449] smpboot: CPU 1 is now offline
[ 1566.238200] rcu-torture: rtc: ffffffff82da41a0 ver: 1 tfle: 0 rta: 1 rtaf: 0 rtf: 0 rtmbe: 0 rtbke: 0 rtbre: 0 rtbf: 0 rtb: 0 nt: 4 onoff: 0/0:0/0 -1,0:-1,0 0:0 (HZ=1000) barrier: 0/0:0
[ 1566.238200] rcu-torture: Reader Pipe:  8 0 0 0 0 0 0 0 0 0 0
[ 1566.238200] rcu-torture: Reader Batch:  8 0 0 0 0 0 0 0 0 0 0
[ 1566.238200] rcu-torture: Free-Block Circulation:  0 0 0 0 0 0 0 0 0 0 0
[ 1626.258200] rcu-torture: rtc: ffffffff82da41a0 ver: 1 tfle: 0 rta: 1 rtaf: 0 rtf: 0 rtmbe: 0 rtbke: 0 rtbre: 0 rtbf: 0 rtb: 0 nt: 4 onoff: 0/0:0/0 -1,0:-1,0 0:0 (HZ=1000) barrier: 0/0:0
[ 1626.258200] rcu-torture: Reader Pipe:  8 0 0 0 0 0 0 0 0 0 0
[ 1626.258200] rcu-torture: Reader Batch:  8 0 0 0 0 0 0 0 0 0 0
[ 1626.258200] rcu-torture: Free-Block Circulation:  0 0 0 0 0 0 0 0 0 0 0
[ 1637.752869] SMP alternatives: lockdep: fixing up alternatives
[ 1637.760231] smpboot: Booting Node 0 Processor 1 APIC 0x1
[ 1537.614014] masked ExtINT on CPU#1
[ 1537.614014] numa_add_cpu cpu 1 node 0: mask now 0-1
[ 1637.798325] CPU0 attaching NULL sched-domain.
[ 1637.802415] CPU0 attaching sched-domain:
[ 1637.805777]  domain 0: span 0-1 level CPU
[ 1637.808170]   groups: 0 (cpu_power = 1023) 1
[ 1637.812192] CPU1 attaching sched-domain:
[ 1637.814756]  domain 0: span 0-1 level CPU
[ 1637.816897]   groups: 1 0 (cpu_power = 1023)
[ 1637.849221] CPU0 attaching NULL sched-domain.
[ 1637.852456] CPU1 attaching NULL sched-domain.
[ 1637.856884] CPU0 attaching NULL sched-domain.
[ 1637.862456] numa_remove_cpu cpu 1 node 0: mask now 0
[ 1637.867364] smpboot: CPU 1 is now offline
[ 1638.009416] SMP alternatives: lockdep: fixing up alternatives
[ 1638.015066] smpboot: Booting Node 0 Processor 1 APIC 0x1
[ 1637.863387] masked ExtINT on CPU#1
[ 1637.863387] numa_add_cpu cpu 1 node 0: mask now 0-1
[ 1638.051354] CPU0 attaching NULL sched-domain.
[ 1638.054459] CPU0 attaching sched-domain:
[ 1638.056517]  domain 0: span 0-1 level CPU
[ 1638.058654]   groups: 0 (cpu_power = 1023) 1
[ 1638.062424] CPU1 attaching sched-domain:
[ 1638.064931]  domain 0: span 0-1 level CPU
[ 1638.067044]   groups: 1 0 (cpu_power = 1023)
[ 1639.089190] CPU0 attaching NULL sched-domain.
[ 1639.092280] CPU1 attaching NULL sched-domain.
[ 1639.095600] CPU0 attaching NULL sched-domain.
[ 1639.099123] numa_remove_cpu cpu 1 node 0: mask now 0
[ 1639.103213] smpboot: CPU 1 is now offline
[ 1649.149121] SMP alternatives: lockdep: fixing up alternatives
[ 1649.157629] smpboot: Booting Node 0 Processor 1 APIC 0x1
[ 1639.100041] masked ExtINT on CPU#1
[ 1639.100041] numa_add_cpu cpu 1 node 0: mask now 0-1
[ 1649.195239] CPU0 attaching NULL sched-domain.
[ 1649.198559] CPU0 attaching sched-domain:
[ 1649.201317]  domain 0: span 0-1 level CPU
[ 1649.204490]   groups: 0 (cpu_power = 1022) 1
[ 1649.208473] CPU1 attaching sched-domain:
[ 1649.211278]  domain 0: span 0-1 level CPU
[ 1649.214385]   groups: 1 0 (cpu_power = 1022)
[ 1686.279223] rcu-torture: rtc: ffffffff82da41a0 ver: 1 tfle: 0 rta: 1 rtaf: 0 rtf: 0 rtmbe: 0 rtbke: 0 rtbre: 0 rtbf: 0 rtb: 0 nt: 4 onoff: 0/0:0/0 -1,0:-1,0 0:0 (HZ=1000) barrier: 0/0:0
[ 1686.279223] rcu-torture: Reader Pipe:  8 0 0 0 0 0 0 0 0 0 0
[ 1686.279223] rcu-torture: Reader Batch:  8 0 0 0 0 0 0 0 0 0 0
[ 1686.279223] rcu-torture: Free-Block Circulation:  0 0 0 0 0 0 0 0 0 0 0
[ 1746.296154] rcu-torture: rtc: ffffffff82da41a0 ver: 1 tfle: 0 rta: 1 rtaf: 0 rtf: 0 rtmbe: 0 rtbke: 0 rtbre: 0 rtbf: 0 rtb: 0 nt: 4 onoff: 0/0:0/0 -1,0:-1,0 0:0 (HZ=1000) barrier: 0/0:0
[ 1746.296154] rcu-torture: Reader Pipe:  8 0 0 0 0 0 0 0 0 0 0
[ 1746.296154] rcu-torture: Reader Batch:  8 0 0 0 0 0 0 0 0 0 0
[ 1746.296154] rcu-torture: Free-Block Circulation:  0 0 0 0 0 0 0 0 0 0 0
[ 1749.236259] CPU0 attaching NULL sched-domain.
[ 1749.238042] CPU1 attaching NULL sched-domain.
[ 1749.239964] CPU0 attaching NULL sched-domain.
[ 1749.242081] numa_remove_cpu cpu 1 node 0: mask now 0
[ 1749.246045] smpboot: CPU 1 is now offline
[ 1749.273746] SMP alternatives: lockdep: fixing up alternatives
[ 1749.275833] smpboot: Booting Node 0 Processor 1 APIC 0x1
[ 1749.243016] masked ExtINT on CPU#1
[ 1749.243016] numa_add_cpu cpu 1 node 0: mask now 0-1
[ 1749.318385] CPU0 attaching NULL sched-domain.
[ 1749.320360] CPU0 attaching sched-domain:
[ 1749.322399]  domain 0: span 0-1 level CPU
[ 1749.324178]   groups: 0 (cpu_power = 1023) 1
[ 1749.326429] CPU1 attaching sched-domain:
[ 1749.328031]  domain 0: span 0-1 level CPU
[ 1749.329779]   groups: 1 0 (cpu_power = 1023)
[ 1749.447799] CPU0 attaching NULL sched-domain.
[ 1749.449514] CPU1 attaching NULL sched-domain.
[ 1749.451257] CPU0 attaching NULL sched-domain.
[ 1749.453248] numa_remove_cpu cpu 1 node 0: mask now 0
[ 1749.457149] smpboot: CPU 1 is now offline
[ 1750.481996] SMP alternatives: lockdep: fixing up alternatives
[ 1750.487074] smpboot: Booting Node 0 Processor 1 APIC 0x1
[ 1749.454010] masked ExtINT on CPU#1
[ 1749.454010] numa_add_cpu cpu 1 node 0: mask now 0-1
[ 1750.523552] CPU0 attaching NULL sched-domain.
[ 1750.525650] CPU0 attaching sched-domain:
[ 1750.527284]  domain 0: span 0-1 level CPU
[ 1750.529177]   groups: 0 (cpu_power = 1023) 1
[ 1750.531471] CPU1 attaching sched-domain:
[ 1750.533088]  domain 0: span 0-1 level CPU
[ 1750.534847]   groups: 1 0 (cpu_power = 1023)
[ 1760.556566] CPU0 attaching NULL sched-domain.
[ 1760.559324] CPU1 attaching NULL sched-domain.
[ 1760.561763] CPU0 attaching NULL sched-domain.
[ 1760.563731] numa_remove_cpu cpu 1 node 0: mask now 0
[ 1760.567670] smpboot: CPU 1 is now offline
[ 1806.309461] rcu-torture: rtc: ffffffff82da41a0 ver: 1 tfle: 0 rta: 1 rtaf: 0 rtf: 0 rtmbe: 0 rtbke: 0 rtbre: 0 rtbf: 0 rtb: 0 nt: 4 onoff: 0/0:0/0 -1,0:-1,0 0:0 (HZ=1000) barrier: 0/0:0
[ 1806.309461] rcu-torture: Reader Pipe:  8 0 0 0 0 0 0 0 0 0 0
[ 1806.309461] rcu-torture: Reader Batch:  8 0 0 0 0 0 0 0 0 0 0
[ 1806.309461] rcu-torture: Free-Block Circulation:  0 0 0 0 0 0 0 0 0 0 0
[ 1860.660186] SMP alternatives: lockdep: fixing up alternatives
[ 1860.698422] smpboot: Booting Node 0 Processor 1 APIC 0x1
[ 1760.564390] masked ExtINT on CPU#1
[ 1760.564390] numa_add_cpu cpu 1 node 0: mask now 0-1
[ 1860.891619] CPU0 attaching NULL sched-domain.
[ 1860.911153] CPU0 attaching sched-domain:
[ 1860.930062]  domain 0: span 0-1 level CPU
[ 1860.933001]   groups: 0 (cpu_power = 1023) 1
[ 1860.986054] CPU1 attaching sched-domain:
[ 1861.006472]  domain 0: span 0-1 level CPU
[ 1861.020562]   groups: 1 0 (cpu_power = 1023)
[ 1861.181193] CPU0 attaching NULL sched-domain.
[ 1861.184581] CPU1 attaching NULL sched-domain.
[ 1861.189657] CPU0 attaching NULL sched-domain.
[ 1861.193571] numa_remove_cpu cpu 1 node 0: mask now 0
[ 1861.224316] smpboot: CPU 1 is now offline
[ 1861.459288] SMP alternatives: lockdep: fixing up alternatives
[ 1861.472088] smpboot: Booting Node 0 Processor 1 APIC 0x1
[ 1861.194028] masked ExtINT on CPU#1
[ 1861.194028] numa_add_cpu cpu 1 node 0: mask now 0-1
[ 1861.526811] CPU0 attaching NULL sched-domain.
[ 1861.530374] CPU0 attaching sched-domain:
[ 1861.533087]  domain 0: span 0-1 level CPU
[ 1861.537992]   groups: 0 (cpu_power = 977) 1
[ 1861.543761] CPU1 attaching sched-domain:
[ 1861.547678]  domain 0: span 0-1 level CPU
[ 1861.555583]   groups: 1 0 (cpu_power = 977)
[ 1862.621272] CPU0 attaching NULL sched-domain.
[ 1862.624721] CPU1 attaching NULL sched-domain.
[ 1862.628370] CPU0 attaching NULL sched-domain.
[ 1862.638430] numa_remove_cpu cpu 1 node 0: mask now 0
[ 1862.644158] smpboot: CPU 1 is now offline
[ 1866.350198] rcu-torture: rtc: ffffffff82da41a0 ver: 1 tfle: 0 rta: 1 rtaf: 0 rtf: 0 rtmbe: 0 rtbke: 0 rtbre: 0 rtbf: 0 rtb: 0 nt: 4 onoff: 0/0:0/0 -1,0:-1,0 0:0 (HZ=1000) barrier: 0/0:0
[ 1866.350198] rcu-torture: Reader Pipe:  8 0 0 0 0 0 0 0 0 0 0
[ 1866.350198] rcu-torture: Reader Batch:  8 0 0 0 0 0 0 0 0 0 0
[ 1866.350198] rcu-torture: Free-Block Circulation:  0 0 0 0 0 0 0 0 0 0 0
[ 1872.733680] SMP alternatives: lockdep: fixing up alternatives
[ 1872.789227] smpboot: Booting Node 0 Processor 1 APIC 0x1
[ 1862.639329] masked ExtINT on CPU#1
[ 1862.639329] numa_add_cpu cpu 1 node 0: mask now 0-1
[ 1872.948514] CPU0 attaching NULL sched-domain.
[ 1872.952554] CPU0 attaching sched-domain:
[ 1872.956310]  domain 0: span 0-1 level CPU
[ 1872.971564]   groups: 0 (cpu_power = 1023) 1
[ 1872.998576] CPU1 attaching sched-domain:
[ 1873.026519]  domain 0: span 0-1 level CPU
[ 1873.047479]   groups: 1 0 (cpu_power = 1023)
[ 1926.435208] rcu-torture: rtc: ffffffff82da41a0 ver: 1 tfle: 0 rta: 1 rtaf: 0 rtf: 0 rtmbe: 0 rtbke: 0 rtbre: 0 rtbf: 0 rtb: 0 nt: 4 onoff: 0/0:0/0 -1,0:-1,0 0:0 (HZ=1000) barrier: 0/0:0
[ 1926.435208] rcu-torture: Reader Pipe:  8 0 0 0 0 0 0 0 0 0 0
[ 1926.435208] rcu-torture: Reader Batch:  8 0 0 0 0 0 0 0 0 0 0
[ 1926.435208] rcu-torture: Free-Block Circulation:  0 0 0 0 0 0 0 0 0 0 0
[ 1973.249388] CPU0 attaching NULL sched-domain.
[ 1973.252781] CPU1 attaching NULL sched-domain.
[ 1973.258801] CPU0 attaching NULL sched-domain.
[ 1973.279698] numa_remove_cpu cpu 1 node 0: mask now 0
[ 1973.285287] smpboot: CPU 1 is now offline
[ 1973.359764] SMP alternatives: lockdep: fixing up alternatives
[ 1973.366124] smpboot: Booting Node 0 Processor 1 APIC 0x1
[ 1973.280554] masked ExtINT on CPU#1
[ 1973.280554] numa_add_cpu cpu 1 node 0: mask now 0-1
[ 1973.421392] CPU0 attaching NULL sched-domain.
[ 1973.427459] CPU0 attaching sched-domain:
[ 1973.430998]  domain 0: span 0-1 level CPU
[ 1973.434514]   groups: 0 (cpu_power = 1022) 1
[ 1973.439001] CPU1 attaching sched-domain:
[ 1973.442079]  domain 0: span 0-1 level CPU
[ 1973.445511]   groups: 1 0 (cpu_power = 1022)
[ 1973.571918] CPU0 attaching NULL sched-domain.
[ 1973.576364] CPU1 attaching NULL sched-domain.
[ 1973.579204] CPU0 attaching NULL sched-domain.
[ 1973.581986] numa_remove_cpu cpu 1 node 0: mask now 0
[ 1973.586749] smpboot: CPU 1 is now offline
[ 1974.640189] SMP alternatives: lockdep: fixing up alternatives
[ 1974.650126] smpboot: Booting Node 0 Processor 1 APIC 0x1
[ 1973.582438] masked ExtINT on CPU#1
[ 1973.582438] numa_add_cpu cpu 1 node 0: mask now 0-1
[ 1974.705557] CPU0 attaching NULL sched-domain.
[ 1974.709728] CPU0 attaching sched-domain:
[ 1974.713176]  domain 0: span 0-1 level CPU
[ 1974.716576]   groups: 0 (cpu_power = 1023) 1
[ 1974.720893] CPU1 attaching sched-domain:
[ 1974.723972]  domain 0: span 0-1 level CPU
[ 1974.727402]   groups: 1 0 (cpu_power = 1023)
[ 1984.755842] CPU0 attaching NULL sched-domain.
[ 1984.760002] CPU1 attaching NULL sched-domain.
[ 1984.763720] CPU0 attaching NULL sched-domain.
[ 1984.769748] numa_remove_cpu cpu 1 node 0: mask now 0
[ 1984.776509] smpboot: CPU 1 is now offline
[ 1986.460195] rcu-torture: rtc: ffffffff82da41a0 ver: 1 tfle: 0 rta: 1 rtaf: 0 rtf: 0 rtmbe: 0 rtbke: 0 rtbre: 0 rtbf: 0 rtb: 0 nt: 4 onoff: 0/0:0/0 -1,0:-1,0 0:0 (HZ=1000) barrier: 0/0:0
[ 1986.460195] rcu-torture: Reader Pipe:  8 0 0 0 0 0 0 0 0 0 0
[ 1986.460195] rcu-torture: Reader Batch:  8 0 0 0 0 0 0 0 0 0 0
[ 1986.460195] rcu-torture: Free-Block Circulation:  0 0 0 0 0 0 0 0 0 0 0
[ 2046.484213] rcu-torture: rtc: ffffffff82da41a0 ver: 1 tfle: 0 rta: 1 rtaf: 0 rtf: 0 rtmbe: 0 rtbke: 0 rtbre: 0 rtbf: 0 rtb: 0 nt: 4 onoff: 0/0:0/0 -1,0:-1,0 0:0 (HZ=1000) barrier: 0/0:0
[ 2046.484213] rcu-torture: Reader Pipe:  8 0 0 0 0 0 0 0 0 0 0
[ 2046.484213] rcu-torture: Reader Batch:  8 0 0 0 0 0 0 0 0 0 0
[ 2046.484213] rcu-torture: Free-Block Circulation:  0 0 0 0 0 0 0 0 0 0 0
[ 2084.854368] SMP alternatives: lockdep: fixing up alternatives
[ 2084.864150] smpboot: Booting Node 0 Processor 1 APIC 0x1
[ 1984.770632] masked ExtINT on CPU#1
[ 1984.770632] numa_add_cpu cpu 1 node 0: mask now 0-1
[ 2084.907453] CPU0 attaching NULL sched-domain.
[ 2084.911225] CPU0 attaching sched-domain:
[ 2084.914064]  domain 0: span 0-1 level CPU
[ 2084.916983]   groups: 0 (cpu_power = 1023) 1
[ 2084.920364] CPU1 attaching sched-domain:
[ 2084.922814]  domain 0: span 0-1 level CPU
[ 2084.925722]   groups: 1 0 (cpu_power = 1023)
[ 2084.967615] CPU0 attaching NULL sched-domain.
[ 2084.970544] CPU1 attaching NULL sched-domain.
[ 2084.973155] CPU0 attaching NULL sched-domain.
[ 2084.976047] numa_remove_cpu cpu 1 node 0: mask now 0
[ 2084.982236] smpboot: CPU 1 is now offline
[ 2085.132144] SMP alternatives: lockdep: fixing up alternatives
[ 2085.138158] smpboot: Booting Node 0 Processor 1 APIC 0x1
[ 2084.976947] masked ExtINT on CPU#1
[ 2084.976947] numa_add_cpu cpu 1 node 0: mask now 0-1
[ 2085.177728] CPU0 attaching NULL sched-domain.
[ 2085.181347] CPU0 attaching sched-domain:
[ 2085.184060]  domain 0: span 0-1 level CPU
[ 2085.186983]   groups: 0 (cpu_power = 1011) 1
[ 2085.190690] CPU1 attaching sched-domain:
[ 2085.193328]  domain 0: span 0-1 level CPU
[ 2085.196182]   groups: 1 0 (cpu_power = 1011)
[ 2086.222237] CPU0 attaching NULL sched-domain.
[ 2086.225366] CPU1 attaching NULL sched-domain.
[ 2086.228627] CPU0 attaching NULL sched-domain.
[ 2086.233329] numa_remove_cpu cpu 1 node 0: mask now 0
[ 2086.239801] smpboot: CPU 1 is now offline
[ 2096.291444] SMP alternatives: lockdep: fixing up alternatives
[ 2096.301111] smpboot: Booting Node 0 Processor 1 APIC 0x1
[ 2086.234208] masked ExtINT on CPU#1
[ 2086.234208] numa_add_cpu cpu 1 node 0: mask now 0-1
[ 2096.340258] CPU0 attaching NULL sched-domain.
[ 2096.344821] CPU0 attaching sched-domain:
[ 2096.347660]  domain 0: span 0-1 level CPU
[ 2096.351620]   groups: 0 (cpu_power = 1023) 1
[ 2096.355394] CPU1 attaching sched-domain:
[ 2096.358165]  domain 0: span 0-1 level CPU
[ 2096.361069]   groups: 1 0 (cpu_power = 1023)
[ 2106.512330] rcu-torture: rtc: ffffffff82da41a0 ver: 1 tfle: 0 rta: 1 rtaf: 0 rtf: 0 rtmbe: 0 rtbke: 0 rtbre: 0 rtbf: 0 rtb: 0 nt: 4 onoff: 0/0:0/0 -1,0:-1,0 0:0 (HZ=1000) barrier: 0/0:0
[ 2106.512330] rcu-torture: Reader Pipe:  8 0 0 0 0 0 0 0 0 0 0
[ 2106.512330] rcu-torture: Reader Batch:  8 0 0 0 0 0 0 0 0 0 0
[ 2106.512330] rcu-torture: Free-Block Circulation:  0 0 0 0 0 0 0 0 0 0 0
[ 2166.530295] rcu-torture: rtc: ffffffff82da41a0 ver: 1 tfle: 0 rta: 1 rtaf: 0 rtf: 0 rtmbe: 0 rtbke: 0 rtbre: 0 rtbf: 0 rtb: 0 nt: 4 onoff: 0/0:0/0 -1,0:-1,0 0:0 (HZ=1000) barrier: 0/0:0
[ 2166.530295] rcu-torture: Reader Pipe:  8 0 0 0 0 0 0 0 0 0 0
[ 2166.530295] rcu-torture: Reader Batch:  8 0 0 0 0 0 0 0 0 0 0
[ 2166.530295] rcu-torture: Free-Block Circulation:  0 0 0 0 0 0 0 0 0 0 0
[ 2196.389815] CPU0 attaching NULL sched-domain.
[ 2196.392789] CPU1 attaching NULL sched-domain.
[ 2196.395697] CPU0 attaching NULL sched-domain.
[ 2196.400436] numa_remove_cpu cpu 1 node 0: mask now 0
[ 2196.405909] smpboot: CPU 1 is now offline
[ 2196.459687] SMP alternatives: lockdep: fixing up alternatives
[ 2196.466115] smpboot: Booting Node 0 Processor 1 APIC 0x1
[ 2196.401335] masked ExtINT on CPU#1
[ 2196.401335] numa_add_cpu cpu 1 node 0: mask now 0-1
[ 2196.519931] CPU0 attaching NULL sched-domain.
[ 2196.523404] CPU0 attaching sched-domain:
[ 2196.526073]  domain 0: span 0-1 level CPU
[ 2196.529054]   groups: 0 (cpu_power = 1022) 1
[ 2196.532729] CPU1 attaching sched-domain:
[ 2196.535421]  domain 0: span 0-1 level CPU
[ 2196.538464]   groups: 1 0 (cpu_power = 1022)
[ 2196.664561] CPU0 attaching NULL sched-domain.
[ 2196.667543] CPU1 attaching NULL sched-domain.
[ 2196.670789] CPU0 attaching NULL sched-domain.
[ 2196.674671] numa_remove_cpu cpu 1 node 0: mask now 0
[ 2196.679991] smpboot: CPU 1 is now offline
[ 2197.724643] SMP alternatives: lockdep: fixing up alternatives
[ 2197.734139] smpboot: Booting Node 0 Processor 1 APIC 0x1
[ 2196.675573] masked ExtINT on CPU#1
[ 2196.675573] numa_add_cpu cpu 1 node 0: mask now 0-1
[ 2197.774337] CPU0 attaching NULL sched-domain.
[ 2197.777572] CPU0 attaching sched-domain:
[ 2197.780396]  domain 0: span 0-1 level CPU
[ 2197.783521]   groups: 0 (cpu_power = 1022) 1
[ 2197.787536] CPU1 attaching sched-domain:
[ 2197.790311]  domain 0: span 0-1 level CPU
[ 2197.793303]   groups: 1 0 (cpu_power = 1022)
[ 2207.820675] CPU0 attaching NULL sched-domain.
[ 2207.823540] CPU1 attaching NULL sched-domain.
[ 2207.826571] CPU0 attaching NULL sched-domain.
[ 2207.831150] numa_remove_cpu cpu 1 node 0: mask now 0
[ 2207.836737] smpboot: CPU 1 is now offline
[ 2226.557228] rcu-torture: rtc: ffffffff82da41a0 ver: 1 tfle: 0 rta: 1 rtaf: 0 rtf: 0 rtmbe: 0 rtbke: 0 rtbre: 0 rtbf: 0 rtb: 0 nt: 4 onoff: 0/0:0/0 -1,0:-1,0 0:0 (HZ=1000) barrier: 0/0:0
[ 2226.557228] rcu-torture: Reader Pipe:  8 0 0 0 0 0 0 0 0 0 0
[ 2226.557228] rcu-torture: Reader Batch:  8 0 0 0 0 0 0 0 0 0 0
[ 2226.557228] rcu-torture: Free-Block Circulation:  0 0 0 0 0 0 0 0 0 0 0
[ 2286.575223] rcu-torture: rtc: ffffffff82da41a0 ver: 1 tfle: 0 rta: 1 rtaf: 0 rtf: 0 rtmbe: 0 rtbke: 0 rtbre: 0 rtbf: 0 rtb: 0 nt: 4 onoff: 0/0:0/0 -1,0:-1,0 0:0 (HZ=1000) barrier: 0/0:0
[ 2286.575223] rcu-torture: Reader Pipe:  8 0 0 0 0 0 0 0 0 0 0
[ 2286.575223] rcu-torture: Reader Batch:  8 0 0 0 0 0 0 0 0 0 0
[ 2286.575223] rcu-torture: Free-Block Circulation:  0 0 0 0 0 0 0 0 0 0 0
[ 2307.887133] SMP alternatives: lockdep: fixing up alternatives
[ 2307.896142] smpboot: Booting Node 0 Processor 1 APIC 0x1
[ 2207.832029] masked ExtINT on CPU#1
[ 2207.832029] numa_add_cpu cpu 1 node 0: mask now 0-1
[ 2307.934306] CPU0 attaching NULL sched-domain.
[ 2307.938627] CPU0 attaching sched-domain:
[ 2307.941328]  domain 0: span 0-1 level CPU
[ 2307.944411]   groups: 0 (cpu_power = 1022) 1
[ 2307.948290] CPU1 attaching sched-domain:
[ 2307.950952]  domain 0: span 0-1 level CPU
[ 2307.953924]   groups: 1 0 (cpu_power = 1022)
[ 2307.984959] CPU0 attaching NULL sched-domain.
[ 2307.988510] CPU1 attaching NULL sched-domain.
[ 2307.991978] CPU0 attaching NULL sched-domain.
[ 2307.996020] numa_remove_cpu cpu 1 node 0: mask now 0
[ 2308.007130] smpboot: CPU 1 is now offline
[ 2308.146685] SMP alternatives: lockdep: fixing up alternatives
[ 2308.156141] smpboot: Booting Node 0 Processor 1 APIC 0x1
[ 2307.996020] masked ExtINT on CPU#1
[ 2307.996020] numa_add_cpu cpu 1 node 0: mask now 0-1
[ 2308.195749] CPU0 attaching NULL sched-domain.
[ 2308.199458] CPU0 attaching sched-domain:
[ 2308.202298]  domain 0: span 0-1 level CPU
[ 2308.205195]   groups: 0 (cpu_power = 1023) 1
[ 2308.209050] CPU1 attaching sched-domain:
[ 2308.211700]  domain 0: span 0-1 level CPU
[ 2308.214657]   groups: 1 0 (cpu_power = 1023)
[ 2309.240195] CPU0 attaching NULL sched-domain.
[ 2309.243481] CPU1 attaching NULL sched-domain.
[ 2309.246661] CPU0 attaching NULL sched-domain.
[ 2309.251455] numa_remove_cpu cpu 1 node 0: mask now 0
[ 2309.256862] smpboot: CPU 1 is now offline
[ 2319.304157] SMP alternatives: lockdep: fixing up alternatives
[ 2319.313133] smpboot: Booting Node 0 Processor 1 APIC 0x1
[ 2309.252358] masked ExtINT on CPU#1
[ 2309.252358] numa_add_cpu cpu 1 node 0: mask now 0-1
[ 2319.351527] CPU0 attaching NULL sched-domain.
[ 2319.354945] CPU0 attaching sched-domain:
[ 2319.357823]  domain 0: span 0-1 level CPU
[ 2319.360885]   groups: 0 (cpu_power = 1022) 1
[ 2319.364708] CPU1 attaching sched-domain:
[ 2319.367462]  domain 0: span 0-1 level CPU
[ 2319.370494]   groups: 1 0 (cpu_power = 1022)
[ 2346.595299] rcu-torture: rtc: ffffffff82da41a0 ver: 1 tfle: 0 rta: 1 rtaf: 0 rtf: 0 rtmbe: 0 rtbke: 0 rtbre: 0 rtbf: 0 rtb: 0 nt: 4 onoff: 0/0:0/0 -1,0:-1,0 0:0 (HZ=1000) barrier: 0/0:0
[ 2346.595299] rcu-torture: Reader Pipe:  8 0 0 0 0 0 0 0 0 0 0
[ 2346.595299] rcu-torture: Reader Batch:  8 0 0 0 0 0 0 0 0 0 0
[ 2346.595299] rcu-torture: Free-Block Circulation:  0 0 0 0 0 0 0 0 0 0 0
[ 2406.614328] rcu-torture: rtc: ffffffff82da41a0 ver: 1 tfle: 0 rta: 1 rtaf: 0 rtf: 0 rtmbe: 0 rtbke: 0 rtbre: 0 rtbf: 0 rtb: 0 nt: 4 onoff: 0/0:0/0 -1,0:-1,0 0:0 (HZ=1000) barrier: 0/0:0
[ 2406.614328] rcu-torture: Reader Pipe:  8 0 0 0 0 0 0 0 0 0 0
[ 2406.614328] rcu-torture: Reader Batch:  8 0 0 0 0 0 0 0 0 0 0
[ 2406.614328] rcu-torture: Free-Block Circulation:  0 0 0 0 0 0 0 0 0 0 0
[ 2419.394671] CPU0 attaching NULL sched-domain.
[ 2419.396725] CPU1 attaching NULL sched-domain.
[ 2419.398814] CPU0 attaching NULL sched-domain.
[ 2419.401277] numa_remove_cpu cpu 1 node 0: mask now 0
[ 2419.405506] smpboot: CPU 1 is now offline
[ 2419.438339] SMP alternatives: lockdep: fixing up alternatives
[ 2419.440680] smpboot: Booting Node 0 Processor 1 APIC 0x1
[ 2419.402210] masked ExtINT on CPU#1
[ 2419.402210] numa_add_cpu cpu 1 node 0: mask now 0-1
[ 2419.480157] CPU0 attaching NULL sched-domain.
[ 2419.482351] CPU0 attaching sched-domain:
[ 2419.484573]  domain 0: span 0-1 level CPU
[ 2419.486621]   groups: 0 (cpu_power = 1023) 1
[ 2419.489238] CPU1 attaching sched-domain:
[ 2419.491060]  domain 0: span 0-1 level CPU
[ 2419.493072]   groups: 1 0 (cpu_power = 1023)
[ 2419.611952] CPU0 attaching NULL sched-domain.
[ 2419.613867] CPU1 attaching NULL sched-domain.
[ 2419.615852] CPU0 attaching NULL sched-domain.
[ 2419.618118] numa_remove_cpu cpu 1 node 0: mask now 0
[ 2419.622263] smpboot: CPU 1 is now offline
[ 2420.649838] SMP alternatives: lockdep: fixing up alternatives
[ 2420.655086] smpboot: Booting Node 0 Processor 1 APIC 0x1
[ 2419.619014] masked ExtINT on CPU#1
[ 2419.619014] numa_add_cpu cpu 1 node 0: mask now 0-1
[ 2420.692595] CPU0 attaching NULL sched-domain.
[ 2420.694926] CPU0 attaching sched-domain:
[ 2420.696758]  domain 0: span 0-1 level CPU
[ 2420.698799]   groups: 0 (cpu_power = 1023) 1
[ 2420.701472] CPU1 attaching sched-domain:
[ 2420.703326]  domain 0: span 0-1 level CPU
[ 2420.705419]   groups: 1 0 (cpu_power = 1023)
[ 2430.725993] CPU0 attaching NULL sched-domain.
[ 2430.727956] CPU1 attaching NULL sched-domain.
[ 2430.730089] CPU0 attaching NULL sched-domain.
[ 2430.732327] numa_remove_cpu cpu 1 node 0: mask now 0
[ 2430.736506] smpboot: CPU 1 is now offline
[ 2466.639221] rcu-torture: rtc: ffffffff82da41a0 ver: 1 tfle: 0 rta: 1 rtaf: 0 rtf: 0 rtmbe: 0 rtbke: 0 rtbre: 0 rtbf: 0 rtb: 0 nt: 4 onoff: 0/0:0/0 -1,0:-1,0 0:0 (HZ=1000) barrier: 0/0:0
[ 2466.639221] rcu-torture: Reader Pipe:  8 0 0 0 0 0 0 0 0 0 0
[ 2466.639221] rcu-torture: Reader Batch:  8 0 0 0 0 0 0 0 0 0 0
[ 2466.639221] rcu-torture: Free-Block Circulation:  0 0 0 0 0 0 0 0 0 0 0
[ 2526.685094] rcu-torture: rtc: ffffffff82da41a0 ver: 1 tfle: 0 rta: 1 rtaf: 0 rtf: 0 rtmbe: 0 rtbke: 0 rtbre: 0 rtbf: 0 rtb: 0 nt: 4 onoff: 0/0:0/0 -1,0:-1,0 0:0 (HZ=1000) barrier: 0/0:0
[ 2526.685094] rcu-torture: Reader Pipe:  8 0 0 0 0 0 0 0 0 0 0
[ 2526.685094] rcu-torture: Reader Batch:  8 0 0 0 0 0 0 0 0 0 0
[ 2526.685094] rcu-torture: Free-Block Circulation:  0 0 0 0 0 0 0 0 0 0 0
[ 2530.767851] SMP alternatives: lockdep: fixing up alternatives
[ 2530.773587] smpboot: Booting Node 0 Processor 1 APIC 0x1
[ 2430.733017] masked ExtINT on CPU#1
[ 2430.733017] numa_add_cpu cpu 1 node 0: mask now 0-1
[ 2530.809571] CPU0 attaching NULL sched-domain.
[ 2530.811916] CPU0 attaching sched-domain:
[ 2530.813761]  domain 0: span 0-1 level CPU
[ 2530.815823]   groups: 0 (cpu_power = 1023) 1
[ 2530.818451] CPU1 attaching sched-domain:
[ 2530.820317]  domain 0: span 0-1 level CPU
[ 2530.822366]   groups: 1 0 (cpu_power = 1023)
[ 2530.842604] CPU0 attaching NULL sched-domain.
[ 2530.844752] CPU1 attaching NULL sched-domain.
[ 2530.846860] CPU0 attaching NULL sched-domain.
[ 2530.849338] numa_remove_cpu cpu 1 node 0: mask now 0
[ 2530.853543] smpboot: CPU 1 is now offline
[ 2530.978556] SMP alternatives: lockdep: fixing up alternatives
[ 2530.980928] smpboot: Booting Node 0 Processor 1 APIC 0x1
[ 2530.850272] masked ExtINT on CPU#1
[ 2530.850272] numa_add_cpu cpu 1 node 0: mask now 0-1
[ 2531.020501] CPU0 attaching NULL sched-domain.
[ 2531.022747] CPU0 attaching sched-domain:
[ 2531.024607]  domain 0: span 0-1 level CPU
[ 2531.026668]   groups: 0 (cpu_power = 1023) 1
[ 2531.029325] CPU1 attaching sched-domain:
[ 2531.031167]  domain 0: span 0-1 level CPU
[ 2531.033181]   groups: 1 0 (cpu_power = 1023)
[ 2532.051410] CPU0 attaching NULL sched-domain.
[ 2532.053393] CPU1 attaching NULL sched-domain.
[ 2532.055421] CPU0 attaching NULL sched-domain.
[ 2532.057682] numa_remove_cpu cpu 1 node 0: mask now 0
[ 2532.061970] smpboot: CPU 1 is now offline
[ 2542.092589] SMP alternatives: lockdep: fixing up alternatives
[ 2542.094965] smpboot: Booting Node 0 Processor 1 APIC 0x1
[ 2532.058293] masked ExtINT on CPU#1
[ 2532.058293] numa_add_cpu cpu 1 node 0: mask now 0-1
[ 2542.132476] CPU0 attaching NULL sched-domain.
[ 2542.134801] CPU0 attaching sched-domain:
[ 2542.136656]  domain 0: span 0-1 level CPU
[ 2542.138697]   groups: 0 (cpu_power = 1023) 1
[ 2542.141358] CPU1 attaching sched-domain:
[ 2542.143209]  domain 0: span 0-1 level CPU
[ 2542.145309]   groups: 1 0 (cpu_power = 1023)
[ 2586.697219] rcu-torture: rtc: ffffffff82da41a0 ver: 1 tfle: 0 rta: 1 rtaf: 0 rtf: 0 rtmbe: 0 rtbke: 0 rtbre: 0 rtbf: 0 rtb: 0 nt: 4 onoff: 0/0:0/0 -1,0:-1,0 0:0 (HZ=1000) barrier: 0/0:0
[ 2586.697219] rcu-torture: Reader Pipe:  8 0 0 0 0 0 0 0 0 0 0
[ 2586.697219] rcu-torture: Reader Batch:  8 0 0 0 0 0 0 0 0 0 0
[ 2586.697219] rcu-torture: Free-Block Circulation:  0 0 0 0 0 0 0 0 0 0 0
[ 2642.168762] CPU0 attaching NULL sched-domain.
[ 2642.171864] CPU1 attaching NULL sched-domain.
[ 2642.176503] CPU0 attaching NULL sched-domain.
[ 2642.193289] numa_remove_cpu cpu 1 node 0: mask now 0
[ 2642.198656] smpboot: CPU 1 is now offline
[ 2642.354627] SMP alternatives: lockdep: fixing up alternatives
[ 2642.374002] smpboot: Booting Node 0 Processor 1 APIC 0x1
[ 2642.194164] masked ExtINT on CPU#1
[ 2642.194164] numa_add_cpu cpu 1 node 0: mask now 0-1
[ 2642.523227] CPU0 attaching NULL sched-domain.
[ 2642.526399] CPU0 attaching sched-domain:
[ 2642.537456]  domain 0: span 0-1 level CPU
[ 2642.560908]   groups: 0 (cpu_power = 1022) 1
[ 2642.564085] CPU1 attaching sched-domain:
[ 2642.579635]  domain 0: span 0-1 level CPU
[ 2642.582377]   groups: 1 0 (cpu_power = 1022)
[ 2642.910655] CPU0 attaching NULL sched-domain.
[ 2642.917283] CPU1 attaching NULL sched-domain.
[ 2642.925289] CPU0 attaching NULL sched-domain.
[ 2642.953418] numa_remove_cpu cpu 1 node 0: mask now 0
[ 2642.958500] smpboot: CPU 1 is now offline
[ 2644.079965] SMP alternatives: lockdep: fixing up alternatives
[ 2644.087572] smpboot: Booting Node 0 Processor 1 APIC 0x1
[ 2642.954306] masked ExtINT on CPU#1
[ 2642.954306] numa_add_cpu cpu 1 node 0: mask now 0-1
[ 2644.217218] CPU0 attaching NULL sched-domain.
[ 2644.224390] CPU0 attaching sched-domain:
[ 2644.237384]  domain 0: span 0-1 level CPU
[ 2644.239892]   groups: 0 (cpu_power = 1022) 1
[ 2644.253131] CPU1 attaching sched-domain:
[ 2644.263052]  domain 0: span 0-1 level CPU
[ 2644.265798]   groups: 1 0 (cpu_power = 1022)
[ 2646.723991] rcu-torture: rtc: ffffffff82da41a0 ver: 1 tfle: 0 rta: 1 rtaf: 0 rtf: 0 rtmbe: 0 rtbke: 0 rtbre: 0 rtbf: 0 rtb: 0 nt: 4 onoff: 0/0:0/0 -1,0:-1,0 0:0 (HZ=1000) barrier: 0/0:0
[ 2646.723991] rcu-torture: Reader Pipe:  8 0 0 0 0 0 0 0 0 0 0
[ 2646.723991] rcu-torture: Reader Batch:  8 0 0 0 0 0 0 0 0 0 0
[ 2646.723991] rcu-torture: Free-Block Circulation:  0 0 0 0 0 0 0 0 0 0 0
[ 2654.391178] CPU0 attaching NULL sched-domain.
[ 2654.394128] CPU1 attaching NULL sched-domain.
[ 2654.396649] CPU0 attaching NULL sched-domain.
[ 2654.423605] numa_remove_cpu cpu 1 node 0: mask now 0
[ 2654.439200] smpboot: CPU 1 is now offline
[ 2706.758243] rcu-torture: rtc: ffffffff82da41a0 ver: 1 tfle: 0 rta: 1 rtaf: 0 rtf: 0 rtmbe: 0 rtbke: 0 rtbre: 0 rtbf: 0 rtb: 0 nt: 4 onoff: 0/0:0/0 -1,0:-1,0 0:0 (HZ=1000) barrier: 0/0:0
[ 2706.758243] rcu-torture: Reader Pipe:  8 0 0 0 0 0 0 0 0 0 0
[ 2706.758243] rcu-torture: Reader Batch:  8 0 0 0 0 0 0 0 0 0 0
[ 2706.758243] rcu-torture: Free-Block Circulation:  0 0 0 0 0 0 0 0 0 0 0
[ 2754.588192] SMP alternatives: lockdep: fixing up alternatives
[ 2754.608128] smpboot: Booting Node 0 Processor 1 APIC 0x1
[ 2654.424508] masked ExtINT on CPU#1
[ 2654.424508] numa_add_cpu cpu 1 node 0: mask now 0-1
[ 2754.740751] CPU0 attaching NULL sched-domain.
[ 2754.759998] CPU0 attaching sched-domain:
[ 2754.775668]  domain 0: span 0-1 level CPU
[ 2754.786363]   groups: 0 (cpu_power = 1022) 1
[ 2754.798057] CPU1 attaching sched-domain:
[ 2754.813051]  domain 0: span 0-1 level CPU
[ 2754.829053]   groups: 1 0 (cpu_power = 1022)
[ 2754.927947] CPU0 attaching NULL sched-domain.
[ 2754.932005] CPU1 attaching NULL sched-domain.
[ 2754.935986] CPU0 attaching NULL sched-domain.
[ 2754.967437] numa_remove_cpu cpu 1 node 0: mask now 0
[ 2754.981968] smpboot: CPU 1 is now offline
[ 2755.268317] SMP alternatives: lockdep: fixing up alternatives
[ 2755.289226] smpboot: Booting Node 0 Processor 1 APIC 0x1
[ 2754.968321] masked ExtINT on CPU#1
[ 2754.968321] numa_add_cpu cpu 1 node 0: mask now 0-1
[ 2755.423560] CPU0 attaching NULL sched-domain.
[ 2755.439794] CPU0 attaching sched-domain:
[ 2755.443231]  domain 0: span 0-1 level CPU
[ 2755.459153]   groups: 0 (cpu_power = 1023) 1
[ 2755.463560] CPU1 attaching sched-domain:
[ 2755.467835]  domain 0: span 0-1 level CPU
[ 2755.482512]   groups: 1 0 (cpu_power = 1023)
[ 2756.557126] CPU0 attaching NULL sched-domain.
[ 2756.567427] CPU1 attaching NULL sched-domain.
[ 2756.579706] CPU0 attaching NULL sched-domain.
[ 2756.606301] numa_remove_cpu cpu 1 node 0: mask now 0
[ 2756.617764] smpboot: CPU 1 is now offline
[ 2766.687164] SMP alternatives: lockdep: fixing up alternatives
[ 2766.726170] smpboot: Booting Node 0 Processor 1 APIC 0x1
[ 2756.607160] masked ExtINT on CPU#1
[ 2756.607160] numa_add_cpu cpu 1 node 0: mask now 0-1
[ 2766.861263] rcu-torture: rtc: ffffffff82da41a0 ver: 1 tfle: 0 rta: 1 rtaf: 0 rtf: 0 rtmbe: 0 rtbke: 0 rtbre: 0 rtbf: 0 rtb: 0 nt: 4 onoff: 0/0:0/0 -1,0:-1,0 0:0 (HZ=1000) barrier: 0/0:0
[ 2766.861263] rcu-torture: Reader Pipe:  8 0 0 0 0 0 0 0 0 0 0
[ 2766.861263] rcu-torture: Reader Batch:  8 0 0 0 0 0 0 0 0 0 0
[ 2766.861263] rcu-torture: Free-Block Circulation:  0 0 0 0 0 0 0 0 0 0 0
[ 2766.965281] CPU0 attaching NULL sched-domain.
[ 2766.986813] CPU0 attaching sched-domain:
[ 2767.006273]  domain 0: span 0-1 level CPU
[ 2767.034254]   groups: 0 (cpu_power = 1022) 1
[ 2767.069281] CPU1 attaching sched-domain:
[ 2767.082073]  domain 0: span 0-1 level CPU
[ 2767.085733]   groups: 1 0 (cpu_power = 1022)
[ 2826.967153] rcu-torture: rtc: ffffffff82da41a0 ver: 1 tfle: 0 rta: 1 rtaf: 0 rtf: 0 rtmbe: 0 rtbke: 0 rtbre: 0 rtbf: 0 rtb: 0 nt: 4 onoff: 0/0:0/0 -1,0:-1,0 0:0 (HZ=1000) barrier: 0/0:0
[ 2826.967153] rcu-torture: Reader Pipe:  8 0 0 0 0 0 0 0 0 0 0
[ 2826.967153] rcu-torture: Reader Batch:  8 0 0 0 0 0 0 0 0 0 0
[ 2826.967153] rcu-torture: Free-Block Circulation:  0 0 0 0 0 0 0 0 0 0 0
[ 2867.227189] CPU0 attaching NULL sched-domain.
[ 2867.230288] CPU1 attaching NULL sched-domain.
[ 2867.233402] CPU0 attaching NULL sched-domain.
[ 2867.239202] numa_remove_cpu cpu 1 node 0: mask now 0
[ 2867.243969] smpboot: CPU 1 is now offline
[ 2867.297089] SMP alternatives: lockdep: fixing up alternatives
[ 2867.303090] smpboot: Booting Node 0 Processor 1 APIC 0x1
[ 2867.240119] masked ExtINT on CPU#1
[ 2867.240119] numa_add_cpu cpu 1 node 0: mask now 0-1
[ 2867.356554] CPU0 attaching NULL sched-domain.
[ 2867.359647] CPU0 attaching sched-domain:
[ 2867.362516]  domain 0: span 0-1 level CPU
[ 2867.365421]   groups: 0 (cpu_power = 1022) 1
[ 2867.369056] CPU1 attaching sched-domain:
[ 2867.371753]  domain 0: span 0-1 level CPU
[ 2867.374773]   groups: 1 0 (cpu_power = 1022)
[ 2867.504183] CPU0 attaching NULL sched-domain.
[ 2867.507345] CPU1 attaching NULL sched-domain.
[ 2867.512410] CPU0 attaching NULL sched-domain.
[ 2867.518198] numa_remove_cpu cpu 1 node 0: mask now 0
[ 2867.523979] smpboot: CPU 1 is now offline
[ 2868.570615] SMP alternatives: lockdep: fixing up alternatives
[ 2868.580187] smpboot: Booting Node 0 Processor 1 APIC 0x1
[ 2867.519039] masked ExtINT on CPU#1
[ 2867.519039] numa_add_cpu cpu 1 node 0: mask now 0-1
[ 2868.622279] CPU0 attaching NULL sched-domain.
[ 2868.625731] CPU0 attaching sched-domain:
[ 2868.628713]  domain 0: span 0-1 level CPU
[ 2868.632056]   groups: 0 (cpu_power = 1022) 1
[ 2868.635931] CPU1 attaching sched-domain:
[ 2868.638627]  domain 0: span 0-1 level CPU
[ 2868.641703]   groups: 1 0 (cpu_power = 1022)
[ 2878.675283] CPU0 attaching NULL sched-domain.
[ 2878.678203] CPU1 attaching NULL sched-domain.
[ 2878.681239] CPU0 attaching NULL sched-domain.
[ 2878.690289] numa_remove_cpu cpu 1 node 0: mask now 0
[ 2878.695634] smpboot: CPU 1 is now offline
[ 2887.035236] rcu-torture: rtc: ffffffff82da41a0 ver: 1 tfle: 0 rta: 1 rtaf: 0 rtf: 0 rtmbe: 0 rtbke: 0 rtbre: 0 rtbf: 0 rtb: 0 nt: 4 onoff: 0/0:0/0 -1,0:-1,0 0:0 (HZ=1000) barrier: 0/0:0
[ 2887.035236] rcu-torture: Reader Pipe:  8 0 0 0 0 0 0 0 0 0 0
[ 2887.035236] rcu-torture: Reader Batch:  8 0 0 0 0 0 0 0 0 0 0
[ 2887.035236] rcu-torture: Free-Block Circulation:  0 0 0 0 0 0 0 0 0 0 0
[ 2947.061119] rcu-torture: rtc: ffffffff82da41a0 ver: 1 tfle: 0 rta: 1 rtaf: 0 rtf: 0 rtmbe: 0 rtbke: 0 rtbre: 0 rtbf: 0 rtb: 0 nt: 4 onoff: 0/0:0/0 -1,0:-1,0 0:0 (HZ=1000) barrier: 0/0:0
[ 2947.061119] rcu-torture: Reader Pipe:  8 0 0 0 0 0 0 0 0 0 0
[ 2947.061119] rcu-torture: Reader Batch:  8 0 0 0 0 0 0 0 0 0 0
[ 2947.061119] rcu-torture: Free-Block Circulation:  0 0 0 0 0 0 0 0 0 0 0
[ 2978.765280] SMP alternatives: lockdep: fixing up alternatives
[ 2978.775111] smpboot: Booting Node 0 Processor 1 APIC 0x1
[ 2878.691176] masked ExtINT on CPU#1
[ 2878.691176] numa_add_cpu cpu 1 node 0: mask now 0-1
[ 2978.813323] CPU0 attaching NULL sched-domain.
[ 2978.817444] CPU0 attaching sched-domain:
[ 2978.820793]  domain 0: span 0-1 level CPU
[ 2978.824372]   groups: 0 (cpu_power = 1022) 1
[ 2978.828623] CPU1 attaching sched-domain:
[ 2978.831942]  domain 0: span 0-1 level CPU
[ 2978.835336]   groups: 1 0 (cpu_power = 1022)
[ 2978.882246] CPU0 attaching NULL sched-domain.
[ 2978.885801] CPU1 attaching NULL sched-domain.
[ 2978.896318] CPU0 attaching NULL sched-domain.
[ 2978.903408] numa_remove_cpu cpu 1 node 0: mask now 0
[ 2978.908432] smpboot: CPU 1 is now offline
[ 2979.057403] SMP alternatives: lockdep: fixing up alternatives
[ 2979.066925] smpboot: Booting Node 0 Processor 1 APIC 0x1
[ 2978.904272] masked ExtINT on CPU#1
[ 2978.904272] numa_add_cpu cpu 1 node 0: mask now 0-1
[ 2979.105268] CPU0 attaching NULL sched-domain.
[ 2979.109586] CPU0 attaching sched-domain:
[ 2979.112983]  domain 0: span 0-1 level CPU
[ 2979.116655]   groups: 0 (cpu_power = 1023) 1
[ 2979.120931] CPU1 attaching sched-domain:
[ 2979.124067]  domain 0: span 0-1 level CPU
[ 2979.127470]   groups: 1 0 (cpu_power = 1023)
[ 2980.161286] CPU0 attaching NULL sched-domain.
[ 2980.164684] CPU1 attaching NULL sched-domain.
[ 2980.168394] CPU0 attaching NULL sched-domain.
[ 2980.175252] numa_remove_cpu cpu 1 node 0: mask now 0
[ 2980.180256] smpboot: CPU 1 is now offline
[ 2990.233936] SMP alternatives: lockdep: fixing up alternatives
[ 2990.240125] smpboot: Booting Node 0 Processor 1 APIC 0x1
[ 2980.176147] masked ExtINT on CPU#1
[ 2980.176147] numa_add_cpu cpu 1 node 0: mask now 0-1
[ 2990.278805] CPU0 attaching NULL sched-domain.
[ 2990.282814] CPU0 attaching sched-domain:
[ 2990.286178]  domain 0: span 0-1 level CPU
[ 2990.289462]   groups: 0 (cpu_power = 1023) 1
[ 2990.293923] CPU1 attaching sched-domain:
[ 2990.296765]  domain 0: span 0-1 level CPU
[ 2990.300037]   groups: 1 0 (cpu_power = 1023)
[ 3007.110310] rcu-torture: rtc: ffffffff82da41a0 ver: 1 tfle: 0 rta: 1 rtaf: 0 rtf: 0 rtmbe: 0 rtbke: 0 rtbre: 0 rtbf: 0 rtb: 0 nt: 4 onoff: 0/0:0/0 -1,0:-1,0 0:0 (HZ=1000) barrier: 0/0:0
[ 3007.110310] rcu-torture: Reader Pipe:  8 0 0 0 0 0 0 0 0 0 0
[ 3007.110310] rcu-torture: Reader Batch:  8 0 0 0 0 0 0 0 0 0 0
[ 3007.110310] rcu-torture: Free-Block Circulation:  0 0 0 0 0 0 0 0 0 0 0
[ 3067.132318] rcu-torture: rtc: ffffffff82da41a0 ver: 1 tfle: 0 rta: 1 rtaf: 0 rtf: 0 rtmbe: 0 rtbke: 0 rtbre: 0 rtbf: 0 rtb: 0 nt: 4 onoff: 0/0:0/0 -1,0:-1,0 0:0 (HZ=1000) barrier: 0/0:0
[ 3067.132318] rcu-torture: Reader Pipe:  8 0 0 0 0 0 0 0 0 0 0
[ 3067.132318] rcu-torture: Reader Batch:  8 0 0 0 0 0 0 0 0 0 0
[ 3067.132318] rcu-torture: Free-Block Circulation:  0 0 0 0 0 0 0 0 0 0 0
[ 3090.357483] CPU0 attaching NULL sched-domain.
[ 3090.363540] CPU1 attaching NULL sched-domain.
[ 3090.366524] CPU0 attaching NULL sched-domain.
[ 3090.373169] numa_remove_cpu cpu 1 node 0: mask now 0
[ 3090.378714] smpboot: CPU 1 is now offline
[ 3090.493837] SMP alternatives: lockdep: fixing up alternatives
[ 3090.508148] smpboot: Booting Node 0 Processor 1 APIC 0x1
[ 3090.374020] masked ExtINT on CPU#1
[ 3090.374020] numa_add_cpu cpu 1 node 0: mask now 0-1
[ 3090.551694] CPU0 attaching NULL sched-domain.
[ 3090.555488] CPU0 attaching sched-domain:
[ 3090.558552]  domain 0: span 0-1 level CPU
[ 3090.562067]   groups: 0 (cpu_power = 1023) 1
[ 3090.566315] CPU1 attaching sched-domain:
[ 3090.569471]  domain 0: span 0-1 level CPU
[ 3090.572967]   groups: 1 0 (cpu_power = 1023)
[ 3090.702302] CPU0 attaching NULL sched-domain.
[ 3090.705702] CPU1 attaching NULL sched-domain.
[ 3090.710953] CPU0 attaching NULL sched-domain.
[ 3090.714556] numa_remove_cpu cpu 1 node 0: mask now 0
[ 3090.719736] smpboot: CPU 1 is now offline
[ 3091.767084] SMP alternatives: lockdep: fixing up alternatives
[ 3091.781475] smpboot: Booting Node 0 Processor 1 APIC 0x1
[ 3090.715448] masked ExtINT on CPU#1
[ 3090.715448] numa_add_cpu cpu 1 node 0: mask now 0-1
[ 3091.819636] CPU0 attaching NULL sched-domain.
[ 3091.822947] CPU0 attaching sched-domain:
[ 3091.825696]  domain 0: span 0-1 level CPU
[ 3091.828660]   groups: 0 (cpu_power = 1023) 1
[ 3091.832441] CPU1 attaching sched-domain:
[ 3091.835066]  domain 0: span 0-1 level CPU
[ 3091.837988]   groups: 1 0 (cpu_power = 1023)
[ 3101.912932] CPU0 attaching NULL sched-domain.
[ 3101.915691] CPU1 attaching NULL sched-domain.
[ 3101.918794] CPU0 attaching NULL sched-domain.
[ 3101.922306] numa_remove_cpu cpu 1 node 0: mask now 0
[ 3101.927587] smpboot: CPU 1 is now offline
[ 3127.160248] rcu-torture: rtc: ffffffff82da41a0 ver: 1 tfle: 0 rta: 1 rtaf: 0 rtf: 0 rtmbe: 0 rtbke: 0 rtbre: 0 rtbf: 0 rtb: 0 nt: 4 onoff: 0/0:0/0 -1,0:-1,0 0:0 (HZ=1000) barrier: 0/0:0
[ 3127.160248] rcu-torture: Reader Pipe:  8 0 0 0 0 0 0 0 0 0 0
[ 3127.160248] rcu-torture: Reader Batch:  8 0 0 0 0 0 0 0 0 0 0
[ 3127.160248] rcu-torture: Free-Block Circulation:  0 0 0 0 0 0 0 0 0 0 0
[ 3187.181219] rcu-torture: rtc: ffffffff82da41a0 ver: 1 tfle: 0 rta: 1 rtaf: 0 rtf: 0 rtmbe: 0 rtbke: 0 rtbre: 0 rtbf: 0 rtb: 0 nt: 4 onoff: 0/0:0/0 -1,0:-1,0 0:0 (HZ=1000) barrier: 0/0:0
[ 3187.181219] rcu-torture: Reader Pipe:  8 0 0 0 0 0 0 0 0 0 0
[ 3187.181219] rcu-torture: Reader Batch:  8 0 0 0 0 0 0 0 0 0 0
[ 3187.181219] rcu-torture: Free-Block Circulation:  0 0 0 0 0 0 0 0 0 0 0
[ 3202.002947] SMP alternatives: lockdep: fixing up alternatives
[ 3202.013133] smpboot: Booting Node 0 Processor 1 APIC 0x1
[ 3101.923016] masked ExtINT on CPU#1
[ 3101.923016] numa_add_cpu cpu 1 node 0: mask now 0-1
[ 3202.052676] CPU0 attaching NULL sched-domain.
[ 3202.056920] CPU0 attaching sched-domain:
[ 3202.060184]  domain 0: span 0-1 level CPU
[ 3202.063551]   groups: 0 (cpu_power = 1022) 1
[ 3202.067894] CPU1 attaching sched-domain:
[ 3202.071077]  domain 0: span 0-1 level CPU
[ 3202.074572]   groups: 1 0 (cpu_power = 1022)
[ 3202.109355] CPU0 attaching NULL sched-domain.
[ 3202.112812] CPU1 attaching NULL sched-domain.
[ 3202.116253] CPU0 attaching NULL sched-domain.
[ 3202.120366] numa_remove_cpu cpu 1 node 0: mask now 0
[ 3202.125640] smpboot: CPU 1 is now offline
[ 3202.271708] SMP alternatives: lockdep: fixing up alternatives
[ 3202.281141] smpboot: Booting Node 0 Processor 1 APIC 0x1
[ 3202.121229] masked ExtINT on CPU#1
[ 3202.121229] numa_add_cpu cpu 1 node 0: mask now 0-1
[ 3202.321675] CPU0 attaching NULL sched-domain.
[ 3202.325469] CPU0 attaching sched-domain:
[ 3202.328669]  domain 0: span 0-1 level CPU
[ 3202.332176]   groups: 0 (cpu_power = 1022) 1
[ 3202.336490] CPU1 attaching sched-domain:
[ 3202.339568]  domain 0: span 0-1 level CPU
[ 3202.343090]   groups: 1 0 (cpu_power = 1022)
[ 3203.379891] CPU0 attaching NULL sched-domain.
[ 3203.383372] CPU1 attaching NULL sched-domain.
[ 3203.386903] CPU0 attaching NULL sched-domain.
[ 3203.419193] numa_remove_cpu cpu 1 node 0: mask now 0
[ 3203.424379] smpboot: CPU 1 is now offline
[ 3213.478162] SMP alternatives: lockdep: fixing up alternatives
[ 3213.489371] smpboot: Booting Node 0 Processor 1 APIC 0x1
[ 3203.420025] masked ExtINT on CPU#1
[ 3203.420025] numa_add_cpu cpu 1 node 0: mask now 0-1
[ 3213.530733] CPU0 attaching NULL sched-domain.
[ 3213.533828] CPU0 attaching sched-domain:
[ 3213.536475]  domain 0: span 0-1 level CPU
[ 3213.540412]   groups: 0 (cpu_power = 1023) 1
[ 3213.544600] CPU1 attaching sched-domain:
[ 3213.552761]  domain 0: span 0-1 level CPU
[ 3213.555827]   groups: 1 0 (cpu_power = 1023)
[ 3247.211147] rcu-torture: rtc: ffffffff82da41a0 ver: 1 tfle: 0 rta: 1 rtaf: 0 rtf: 0 rtmbe: 0 rtbke: 0 rtbre: 0 rtbf: 0 rtb: 0 nt: 4 onoff: 0/0:0/0 -1,0:-1,0 0:0 (HZ=1000) barrier: 0/0:0
[ 3247.211147] rcu-torture: Reader Pipe:  8 0 0 0 0 0 0 0 0 0 0
[ 3247.211147] rcu-torture: Reader Batch:  8 0 0 0 0 0 0 0 0 0 0
[ 3247.211147] rcu-torture: Free-Block Circulation:  0 0 0 0 0 0 0 0 0 0 0
[ 3307.225272] rcu-torture: rtc: ffffffff82da41a0 ver: 1 tfle: 0 rta: 1 rtaf: 0 rtf: 0 rtmbe: 0 rtbke: 0 rtbre: 0 rtbf: 0 rtb: 0 nt: 4 onoff: 0/0:0/0 -1,0:-1,0 0:0 (HZ=1000) barrier: 0/0:0
[ 3307.225272] rcu-torture: Reader Pipe:  8 0 0 0 0 0 0 0 0 0 0
[ 3307.225272] rcu-torture: Reader Batch:  8 0 0 0 0 0 0 0 0 0 0
[ 3307.225272] rcu-torture: Free-Block Circulation:  0 0 0 0 0 0 0 0 0 0 0
[ 3313.591298] CPU0 attaching NULL sched-domain.
[ 3313.594320] CPU1 attaching NULL sched-domain.
[ 3313.597399] CPU0 attaching NULL sched-domain.
[ 3313.606243] numa_remove_cpu cpu 1 node 0: mask now 0
[ 3313.611743] smpboot: CPU 1 is now offline
[ 3313.704548] SMP alternatives: lockdep: fixing up alternatives
[ 3313.711165] smpboot: Booting Node 0 Processor 1 APIC 0x1
[ 3313.607099] masked ExtINT on CPU#1
[ 3313.607099] numa_add_cpu cpu 1 node 0: mask now 0-1
[ 3313.764941] CPU0 attaching NULL sched-domain.
[ 3313.771778] CPU0 attaching sched-domain:
[ 3313.774506]  domain 0: span 0-1 level CPU
[ 3313.777695]   groups: 0 (cpu_power = 1004) 1
[ 3313.781527] CPU1 attaching sched-domain:
[ 3313.784247]  domain 0: span 0-1 level CPU
[ 3313.787284]   groups: 1 0 (cpu_power = 1004)
[ 3313.925167] CPU0 attaching NULL sched-domain.
[ 3313.928231] CPU1 attaching NULL sched-domain.
[ 3313.931327] CPU0 attaching NULL sched-domain.
[ 3313.937182] numa_remove_cpu cpu 1 node 0: mask now 0
[ 3313.942714] smpboot: CPU 1 is now offline
[ 3314.990710] SMP alternatives: lockdep: fixing up alternatives
[ 3315.000140] smpboot: Booting Node 0 Processor 1 APIC 0x1
[ 3313.938035] masked ExtINT on CPU#1
[ 3313.938035] numa_add_cpu cpu 1 node 0: mask now 0-1
[ 3315.040381] CPU0 attaching NULL sched-domain.
[ 3315.044120] CPU0 attaching sched-domain:
[ 3315.046777]  domain 0: span 0-1 level CPU
[ 3315.049860]   groups: 0 (cpu_power = 1019) 1
[ 3315.053661] CPU1 attaching sched-domain:
[ 3315.056492]  domain 0: span 0-1 level CPU
[ 3315.059490]   groups: 1 0 (cpu_power = 1019)
[ 3325.098219] CPU0 attaching NULL sched-domain.
[ 3325.101550] CPU1 attaching NULL sched-domain.
[ 3325.104821] CPU0 attaching NULL sched-domain.
[ 3325.109161] numa_remove_cpu cpu 1 node 0: mask now 0
[ 3325.114143] smpboot: CPU 1 is now offline
[ 3367.245177] rcu-torture: rtc: ffffffff82da41a0 ver: 1 tfle: 0 rta: 1 rtaf: 0 rtf: 0 rtmbe: 0 rtbke: 0 rtbre: 0 rtbf: 0 rtb: 0 nt: 4 onoff: 0/0:0/0 -1,0:-1,0 0:0 (HZ=1000) barrier: 0/0:0
[ 3367.245177] rcu-torture: Reader Pipe:  8 0 0 0 0 0 0 0 0 0 0
[ 3367.245177] rcu-torture: Reader Batch:  8 0 0 0 0 0 0 0 0 0 0
[ 3367.245177] rcu-torture: Free-Block Circulation:  0 0 0 0 0 0 0 0 0 0 0
[ 3425.172736] SMP alternatives: lockdep: fixing up alternatives
[ 3425.182130] smpboot: Booting Node 0 Processor 1 APIC 0x1
[ 3325.110020] masked ExtINT on CPU#1
[ 3325.110020] numa_add_cpu cpu 1 node 0: mask now 0-1
[ 3425.222340] CPU0 attaching NULL sched-domain.
[ 3425.225997] CPU0 attaching sched-domain:
[ 3425.228951]  domain 0: span 0-1 level CPU
[ 3425.232077]   groups: 0 (cpu_power = 1023) 1
[ 3425.258353] CPU1 attaching sched-domain:
[ 3425.261229]  domain 0: span 0-1 level CPU
[ 3425.264368]   groups: 1 0 (cpu_power = 1023)
[ 3425.330501] CPU0 attaching NULL sched-domain.
[ 3425.333721] CPU1 attaching NULL sched-domain.
[ 3425.337044] CPU0 attaching NULL sched-domain.
[ 3425.342030] numa_remove_cpu cpu 1 node 0: mask now 0
[ 3425.348188] smpboot: CPU 1 is now offline
[ 3425.493697] SMP alternatives: lockdep: fixing up alternatives
[ 3425.503168] smpboot: Booting Node 0 Processor 1 APIC 0x1
[ 3425.342868] masked ExtINT on CPU#1
[ 3425.342868] numa_add_cpu cpu 1 node 0: mask now 0-1
[ 3425.543513] CPU0 attaching NULL sched-domain.
[ 3425.547314] CPU0 attaching sched-domain:
[ 3425.550208]  domain 0: span 0-1 level CPU
[ 3425.553290]   groups: 0 (cpu_power = 1023) 1
[ 3425.557208] CPU1 attaching sched-domain:
[ 3425.560047]  domain 0: span 0-1 level CPU
[ 3425.563113]   groups: 1 0 (cpu_power = 1023)
[ 3426.589523] CPU0 attaching NULL sched-domain.
[ 3426.591595] CPU1 attaching NULL sched-domain.
[ 3426.593718] CPU0 attaching NULL sched-domain.
[ 3426.596174] numa_remove_cpu cpu 1 node 0: mask now 0
[ 3426.600494] smpboot: CPU 1 is now offline
[ 3427.270196] rcu-torture: rtc: ffffffff82da41a0 ver: 1 tfle: 0 rta: 1 rtaf: 0 rtf: 0 rtmbe: 0 rtbke: 0 rtbre: 0 rtbf: 0 rtb: 0 nt: 4 onoff: 0/0:0/0 -1,0:-1,0 0:0 (HZ=1000) barrier: 0/0:0
[ 3427.270196] rcu-torture: Reader Pipe:  8 0 0 0 0 0 0 0 0 0 0
[ 3427.270196] rcu-torture: Reader Batch:  8 0 0 0 0 0 0 0 0 0 0
[ 3427.270196] rcu-torture: Free-Block Circulation:  0 0 0 0 0 0 0 0 0 0 0
[ 3436.630312] SMP alternatives: lockdep: fixing up alternatives
[ 3436.636142] smpboot: Booting Node 0 Processor 1 APIC 0x1
[ 3426.597072] masked ExtINT on CPU#1
[ 3426.597072] numa_add_cpu cpu 1 node 0: mask now 0-1
[ 3436.673205] CPU0 attaching NULL sched-domain.
[ 3436.675397] CPU0 attaching sched-domain:
[ 3436.677247]  domain 0: span 0-1 level CPU
[ 3436.679265]   groups: 0 (cpu_power = 1023) 1
[ 3436.681837] CPU1 attaching sched-domain:
[ 3436.683671]  domain 0: span 0-1 level CPU
[ 3436.685704]   groups: 1 0 (cpu_power = 1023)
[ 3487.285098] rcu-torture: rtc: ffffffff82da41a0 ver: 1 tfle: 0 rta: 1 rtaf: 0 rtf: 0 rtmbe: 0 rtbke: 0 rtbre: 0 rtbf: 0 rtb: 0 nt: 4 onoff: 0/0:0/0 -1,0:-1,0 0:0 (HZ=1000) barrier: 0/0:0
[ 3487.285098] rcu-torture: Reader Pipe:  8 0 0 0 0 0 0 0 0 0 0
[ 3487.285098] rcu-torture: Reader Batch:  8 0 0 0 0 0 0 0 0 0 0
[ 3487.285098] rcu-torture: Free-Block Circulation:  0 0 0 0 0 0 0 0 0 0 0
[ 3536.707535] CPU0 attaching NULL sched-domain.
[ 3536.711831] CPU1 attaching NULL sched-domain.
[ 3536.715200] CPU0 attaching NULL sched-domain.
[ 3536.719319] numa_remove_cpu cpu 1 node 0: mask now 0
[ 3536.724805] smpboot: CPU 1 is now offline
[ 3536.781820] SMP alternatives: lockdep: fixing up alternatives
[ 3536.791137] smpboot: Booting Node 0 Processor 1 APIC 0x1
[ 3536.720028] masked ExtINT on CPU#1
[ 3536.720028] numa_add_cpu cpu 1 node 0: mask now 0-1
[ 3536.841843] CPU0 attaching NULL sched-domain.
[ 3536.845709] CPU0 attaching sched-domain:
[ 3536.849132]  domain 0: span 0-1 level CPU
[ 3536.852477]   groups: 0 (cpu_power = 1022) 1
[ 3536.856696] CPU1 attaching sched-domain:
[ 3536.859994]  domain 0: span 0-1 level CPU
[ 3536.863346]   groups: 1 0 (cpu_power = 1022)
[ 3536.993145] CPU0 attaching NULL sched-domain.
[ 3536.996442] CPU1 attaching NULL sched-domain.
[ 3537.000146] CPU0 attaching NULL sched-domain.
[ 3537.004160] numa_remove_cpu cpu 1 node 0: mask now 0
[ 3537.009787] smpboot: CPU 1 is now offline
[ 3538.057755] SMP alternatives: lockdep: fixing up alternatives
[ 3538.067144] smpboot: Booting Node 0 Processor 1 APIC 0x1
[ 3537.005008] masked ExtINT on CPU#1
[ 3537.005008] numa_add_cpu cpu 1 node 0: mask now 0-1
[ 3538.108518] CPU0 attaching NULL sched-domain.
[ 3538.111578] CPU0 attaching sched-domain:
[ 3538.113602]  domain 0: span 0-1 level CPU
[ 3538.115760]   groups: 0 (cpu_power = 1003) 1
[ 3538.119669] CPU1 attaching sched-domain:
[ 3538.122755]  domain 0: span 0-1 level CPU
[ 3538.126376]   groups: 1 0 (cpu_power = 1003)
[ 3547.302309] rcu-torture: rtc: ffffffff82da41a0 ver: 1 tfle: 0 rta: 1 rtaf: 0 rtf: 0 rtmbe: 0 rtbke: 0 rtbre: 0 rtbf: 0 rtb: 0 nt: 4 onoff: 0/0:0/0 -1,0:-1,0 0:0 (HZ=1000) barrier: 0/0:0
[ 3547.302309] rcu-torture: Reader Pipe:  8 0 0 0 0 0 0 0 0 0 0
[ 3547.302309] rcu-torture: Reader Batch:  8 0 0 0 0 0 0 0 0 0 0
[ 3547.302309] rcu-torture: Free-Block Circulation:  0 0 0 0 0 0 0 0 0 0 0
[ 3548.153805] CPU0 attaching NULL sched-domain.
[ 3548.156721] CPU1 attaching NULL sched-domain.
[ 3548.161116] CPU0 attaching NULL sched-domain.
[ 3548.164729] numa_remove_cpu cpu 1 node 0: mask now 0
[ 3548.170245] smpboot: CPU 1 is now offline
[ 3607.320247] rcu-torture: rtc: ffffffff82da41a0 ver: 1 tfle: 0 rta: 1 rtaf: 0 rtf: 0 rtmbe: 0 rtbke: 0 rtbre: 0 rtbf: 0 rtb: 0 nt: 4 onoff: 0/0:0/0 -1,0:-1,0 0:0 (HZ=1000) barrier: 0/0:0
[ 3607.320247] rcu-torture: Reader Pipe:  8 0 0 0 0 0 0 0 0 0 0
[ 3607.320247] rcu-torture: Reader Batch:  8 0 0 0 0 0 0 0 0 0 0
[ 3607.320247] rcu-torture: Free-Block Circulation:  0 0 0 0 0 0 0 0 0 0 0
[ 3648.222104] SMP alternatives: lockdep: fixing up alternatives
[ 3648.232150] smpboot: Booting Node 0 Processor 1 APIC 0x1
[ 3548.165638] masked ExtINT on CPU#1
[ 3548.165638] numa_add_cpu cpu 1 node 0: mask now 0-1
[ 3648.271756] CPU0 attaching NULL sched-domain.
[ 3648.275738] CPU0 attaching sched-domain:
[ 3648.278947]  domain 0: span 0-1 level CPU
[ 3648.282428]   groups: 0 (cpu_power = 1022) 1
[ 3648.286820] CPU1 attaching sched-domain:
[ 3648.289996]  domain 0: span 0-1 level CPU
[ 3648.293477]   groups: 1 0 (cpu_power = 1022)
[ 3648.321297] CPU0 attaching NULL sched-domain.
[ 3648.324565] CPU1 attaching NULL sched-domain.
[ 3648.328404] CPU0 attaching NULL sched-domain.
[ 3648.332523] numa_remove_cpu cpu 1 node 0: mask now 0
[ 3648.338347] smpboot: CPU 1 is now offline
[ 3648.490830] SMP alternatives: lockdep: fixing up alternatives
[ 3648.500116] smpboot: Booting Node 0 Processor 1 APIC 0x1
[ 3648.333020] masked ExtINT on CPU#1
[ 3648.333020] numa_add_cpu cpu 1 node 0: mask now 0-1
[ 3648.540401] CPU0 attaching NULL sched-domain.
[ 3648.544440] CPU0 attaching sched-domain:
[ 3648.547914]  domain 0: span 0-1 level CPU
[ 3648.551384]   groups: 0 (cpu_power = 1023) 1
[ 3648.555837] CPU1 attaching sched-domain:
[ 3648.559087]  domain 0: span 0-1 level CPU
[ 3648.562582]   groups: 1 0 (cpu_power = 1023)
[ 3649.617709] CPU0 attaching NULL sched-domain.
[ 3649.622103] CPU1 attaching NULL sched-domain.
[ 3649.625692] CPU0 attaching NULL sched-domain.
[ 3649.644414] numa_remove_cpu cpu 1 node 0: mask now 0
[ 3649.650766] smpboot: CPU 1 is now offline
[ 3659.697094] SMP alternatives: lockdep: fixing up alternatives
[ 3659.706291] smpboot: Booting Node 0 Processor 1 APIC 0x1
[ 3649.645285] masked ExtINT on CPU#1
[ 3649.645285] numa_add_cpu cpu 1 node 0: mask now 0-1
[ 3659.749643] CPU0 attaching NULL sched-domain.
[ 3659.753799] CPU0 attaching sched-domain:
[ 3659.757061]  domain 0: span 0-1 level CPU
[ 3659.760721]   groups: 0 (cpu_power = 1022) 1
[ 3659.765104] CPU1 attaching sched-domain:
[ 3659.768141]  domain 0: span 0-1 level CPU
[ 3659.771707]   groups: 1 0 (cpu_power = 1022)
[ 3667.339185] rcu-torture: rtc: ffffffff82da41a0 ver: 1 tfle: 0 rta: 1 rtaf: 0 rtf: 0 rtmbe: 0 rtbke: 0 rtbre: 0 rtbf: 0 rtb: 0 nt: 4 onoff: 0/0:0/0 -1,0:-1,0 0:0 (HZ=1000) barrier: 0/0:0
[ 3667.339185] rcu-torture: Reader Pipe:  8 0 0 0 0 0 0 0 0 0 0
[ 3667.339185] rcu-torture: Reader Batch:  8 0 0 0 0 0 0 0 0 0 0
[ 3667.339185] rcu-torture: Free-Block Circulation:  0 0 0 0 0 0 0 0 0 0 0
[ 3727.360265] rcu-torture: rtc: ffffffff82da41a0 ver: 1 tfle: 0 rta: 1 rtaf: 0 rtf: 0 rtmbe: 0 rtbke: 0 rtbre: 0 rtbf: 0 rtb: 0 nt: 4 onoff: 0/0:0/0 -1,0:-1,0 0:0 (HZ=1000) barrier: 0/0:0
[ 3727.360265] rcu-torture: Reader Pipe:  8 0 0 0 0 0 0 0 0 0 0
[ 3727.360265] rcu-torture: Reader Batch:  8 0 0 0 0 0 0 0 0 0 0
[ 3727.360265] rcu-torture: Free-Block Circulation:  0 0 0 0 0 0 0 0 0 0 0
[ 3759.805218] CPU0 attaching NULL sched-domain.
[ 3759.808683] CPU1 attaching NULL sched-domain.
[ 3759.812440] CPU0 attaching NULL sched-domain.
[ 3759.816565] numa_remove_cpu cpu 1 node 0: mask now 0
[ 3759.822186] smpboot: CPU 1 is now offline
[ 3759.881538] SMP alternatives: lockdep: fixing up alternatives
[ 3759.891119] smpboot: Booting Node 0 Processor 1 APIC 0x1
[ 3759.817443] masked ExtINT on CPU#1
[ 3759.817443] numa_add_cpu cpu 1 node 0: mask now 0-1
[ 3759.934665] CPU0 attaching NULL sched-domain.
[ 3759.940208] CPU0 attaching sched-domain:
[ 3759.943398]  domain 0: span 0-1 level CPU
[ 3759.946901]   groups: 0 (cpu_power = 1023) 1
[ 3759.951318] CPU1 attaching sched-domain:
[ 3759.954465]  domain 0: span 0-1 level CPU
[ 3759.957914]   groups: 1 0 (cpu_power = 1023)
[ 3760.088234] CPU0 attaching NULL sched-domain.
[ 3760.091406] CPU1 attaching NULL sched-domain.
[ 3760.094829] CPU0 attaching NULL sched-domain.
[ 3760.098803] numa_remove_cpu cpu 1 node 0: mask now 0
[ 3760.107582] smpboot: CPU 1 is now offline
[ 3761.166852] SMP alternatives: lockdep: fixing up alternatives
[ 3761.172383] smpboot: Booting Node 0 Processor 1 APIC 0x1
[ 3760.099686] masked ExtINT on CPU#1
[ 3760.099686] numa_add_cpu cpu 1 node 0: mask now 0-1
[ 3761.215273] CPU0 attaching NULL sched-domain.
[ 3761.218853] CPU0 attaching sched-domain:
[ 3761.222066]  domain 0: span 0-1 level CPU
[ 3761.225539]   groups: 0 (cpu_power = 1023) 1
[ 3761.229924] CPU1 attaching sched-domain:
[ 3761.233073]  domain 0: span 0-1 level CPU
[ 3761.236360]   groups: 1 0 (cpu_power = 1023)
[ 3771.267242] CPU0 attaching NULL sched-domain.
[ 3771.270460] CPU1 attaching NULL sched-domain.
[ 3771.273856] CPU0 attaching NULL sched-domain.
[ 3771.279254] numa_remove_cpu cpu 1 node 0: mask now 0
[ 3771.285146] smpboot: CPU 1 is now offline
[ 3787.383117] rcu-torture: rtc: ffffffff82da41a0 ver: 1 tfle: 0 rta: 1 rtaf: 0 rtf: 0 rtmbe: 0 rtbke: 0 rtbre: 0 rtbf: 0 rtb: 0 nt: 4 onoff: 0/0:0/0 -1,0:-1,0 0:0 (HZ=1000) barrier: 0/0:0
[ 3787.383117] rcu-torture: Reader Pipe:  8 0 0 0 0 0 0 0 0 0 0
[ 3787.383117] rcu-torture: Reader Batch:  8 0 0 0 0 0 0 0 0 0 0
[ 3787.383117] rcu-torture: Free-Block Circulation:  0 0 0 0 0 0 0 0 0 0 0
[ 3847.404234] rcu-torture: rtc: ffffffff82da41a0 ver: 1 tfle: 0 rta: 1 rtaf: 0 rtf: 0 rtmbe: 0 rtbke: 0 rtbre: 0 rtbf: 0 rtb: 0 nt: 4 onoff: 0/0:0/0 -1,0:-1,0 0:0 (HZ=1000) barrier: 0/0:0
[ 3847.404234] rcu-torture: Reader Pipe:  8 0 0 0 0 0 0 0 0 0 0
[ 3847.404234] rcu-torture: Reader Batch:  8 0 0 0 0 0 0 0 0 0 0
[ 3847.404234] rcu-torture: Free-Block Circulation:  0 0 0 0 0 0 0 0 0 0 0
[ 3871.346553] SMP alternatives: lockdep: fixing up alternatives
[ 3871.358730] smpboot: Booting Node 0 Processor 1 APIC 0x1
[ 3771.280051] masked ExtINT on CPU#1
[ 3771.280051] numa_add_cpu cpu 1 node 0: mask now 0-1
[ 3871.397997] CPU0 attaching NULL sched-domain.
[ 3871.401952] CPU0 attaching sched-domain:
[ 3871.404939]  domain 0: span 0-1 level CPU
[ 3871.408299]   groups: 0 (cpu_power = 1022) 1
[ 3871.412509] CPU1 attaching sched-domain:
[ 3871.415431]  domain 0: span 0-1 level CPU
[ 3871.442403]   groups: 1 0 (cpu_power = 1022)
[ 3871.551864] CPU0 attaching NULL sched-domain.
[ 3871.553954] CPU1 attaching NULL sched-domain.
[ 3871.556067] CPU0 attaching NULL sched-domain.
[ 3871.558432] numa_remove_cpu cpu 1 node 0: mask now 0
[ 3871.563141] smpboot: CPU 1 is now offline
[ 3871.686795] SMP alternatives: lockdep: fixing up alternatives
[ 3871.692089] smpboot: Booting Node 0 Processor 1 APIC 0x1
[ 3871.559015] masked ExtINT on CPU#1
[ 3871.559015] numa_add_cpu cpu 1 node 0: mask now 0-1
[ 3871.731407] CPU0 attaching NULL sched-domain.
[ 3871.733517] CPU0 attaching sched-domain:
[ 3871.735167]  domain 0: span 0-1 level CPU
[ 3871.736964]   groups: 0 (cpu_power = 1022) 1
[ 3871.739334] CPU1 attaching sched-domain:
[ 3871.740962]  domain 0: span 0-1 level CPU
[ 3871.742775]   groups: 1 0 (cpu_power = 1022)
[ 3872.767884] CPU0 attaching NULL sched-domain.
[ 3872.769970] CPU1 attaching NULL sched-domain.
[ 3872.772052] CPU0 attaching NULL sched-domain.
[ 3872.774360] numa_remove_cpu cpu 1 node 0: mask now 0
[ 3872.778845] smpboot: CPU 1 is now offline
[ 3882.814235] SMP alternatives: lockdep: fixing up alternatives
[ 3882.816708] smpboot: Booting Node 0 Processor 1 APIC 0x1
[ 3872.775014] masked ExtINT on CPU#1
[ 3872.775014] numa_add_cpu cpu 1 node 0: mask now 0-1
[ 3882.854294] CPU0 attaching NULL sched-domain.
[ 3882.856531] CPU0 attaching sched-domain:
[ 3882.858440]  domain 0: span 0-1 level CPU
[ 3882.860555]   groups: 0 (cpu_power = 1022) 1
[ 3882.863241] CPU1 attaching sched-domain:
[ 3882.865132]  domain 0: span 0-1 level CPU
[ 3882.867239]   groups: 1 0 (cpu_power = 1022)
[ 3907.426217] rcu-torture: rtc: ffffffff82da41a0 ver: 1 tfle: 0 rta: 1 rtaf: 0 rtf: 0 rtmbe: 0 rtbke: 0 rtbre: 0 rtbf: 0 rtb: 0 nt: 4 onoff: 0/0:0/0 -1,0:-1,0 0:0 (HZ=1000) barrier: 0/0:0
[ 3907.426217] rcu-torture: Reader Pipe:  8 0 0 0 0 0 0 0 0 0 0
[ 3907.426217] rcu-torture: Reader Batch:  8 0 0 0 0 0 0 0 0 0 0
[ 3907.426217] rcu-torture: Free-Block Circulation:  0 0 0 0 0 0 0 0 0 0 0
[ 3967.447257] rcu-torture: rtc: ffffffff82da41a0 ver: 1 tfle: 0 rta: 1 rtaf: 0 rtf: 0 rtmbe: 0 rtbke: 0 rtbre: 0 rtbf: 0 rtb: 0 nt: 4 onoff: 0/0:0/0 -1,0:-1,0 0:0 (HZ=1000) barrier: 0/0:0
[ 3967.447257] rcu-torture: Reader Pipe:  8 0 0 0 0 0 0 0 0 0 0
[ 3967.447257] rcu-torture: Reader Batch:  8 0 0 0 0 0 0 0 0 0 0
[ 3967.447257] rcu-torture: Free-Block Circulation:  0 0 0 0 0 0 0 0 0 0 0
[ 3982.890095] CPU0 attaching NULL sched-domain.
[ 3982.892444] CPU1 attaching NULL sched-domain.
[ 3982.894890] CPU0 attaching NULL sched-domain.
[ 3982.897593] numa_remove_cpu cpu 1 node 0: mask now 0
[ 3982.902309] smpboot: CPU 1 is now offline
[ 3982.938347] SMP alternatives: lockdep: fixing up alternatives
[ 3982.940395] smpboot: Booting Node 0 Processor 1 APIC 0x1
[ 3982.898132] masked ExtINT on CPU#1
[ 3982.898132] numa_add_cpu cpu 1 node 0: mask now 0-1
[ 3982.981692] CPU0 attaching NULL sched-domain.
[ 3982.984199] CPU0 attaching sched-domain:
[ 3982.986109]  domain 0: span 0-1 level CPU
[ 3982.987950]   groups: 0 (cpu_power = 1023) 1
[ 3982.990274] CPU1 attaching sched-domain:
[ 3982.991912]  domain 0: span 0-1 level CPU
[ 3982.993705]   groups: 1 0 (cpu_power = 1023)
[ 3983.107536] CPU0 attaching NULL sched-domain.
[ 3983.109248] CPU1 attaching NULL sched-domain.
[ 3983.111039] CPU0 attaching NULL sched-domain.
[ 3983.113017] numa_remove_cpu cpu 1 node 0: mask now 0
[ 3983.116940] smpboot: CPU 1 is now offline
[ 3984.133906] SMP alternatives: lockdep: fixing up alternatives
[ 3984.135991] smpboot: Booting Node 0 Processor 1 APIC 0x1
[ 3983.113658] masked ExtINT on CPU#1
[ 3983.113658] numa_add_cpu cpu 1 node 0: mask now 0-1
[ 3984.176360] CPU0 attaching NULL sched-domain.
[ 3984.178445] CPU0 attaching sched-domain:
[ 3984.180092]  domain 0: span 0-1 level CPU
[ 3984.181859]   groups: 0 (cpu_power = 1023) 1
[ 3984.184193] CPU1 attaching sched-domain:
[ 3984.185818]  domain 0: span 0-1 level CPU
[ 3984.187647]   groups: 1 0 (cpu_power = 1023)
[ 3994.209299] CPU0 attaching NULL sched-domain.
[ 3994.211567] CPU1 attaching NULL sched-domain.
[ 3994.213393] CPU0 attaching NULL sched-domain.
[ 3994.215385] numa_remove_cpu cpu 1 node 0: mask now 0
[ 3994.219345] smpboot: CPU 1 is now offline
[ 4027.462172] rcu-torture: rtc: ffffffff82da41a0 ver: 1 tfle: 0 rta: 1 rtaf: 0 rtf: 0 rtmbe: 0 rtbke: 0 rtbre: 0 rtbf: 0 rtb: 0 nt: 4 onoff: 0/0:0/0 -1,0:-1,0 0:0 (HZ=1000) barrier: 0/0:0
[ 4027.462172] rcu-torture: Reader Pipe:  8 0 0 0 0 0 0 0 0 0 0
[ 4027.462172] rcu-torture: Reader Batch:  8 0 0 0 0 0 0 0 0 0 0
[ 4027.462172] rcu-torture: Free-Block Circulation:  0 0 0 0 0 0 0 0 0 0 0
[ 4087.473407] rcu-torture: rtc: ffffffff82da41a0 ver: 1 tfle: 0 rta: 1 rtaf: 0 rtf: 0 rtmbe: 0 rtbke: 0 rtbre: 0 rtbf: 0 rtb: 0 nt: 4 onoff: 0/0:0/0 -1,0:-1,0 0:0 (HZ=1000) barrier: 0/0:0
[ 4087.473407] rcu-torture: Reader Pipe:  8 0 0 0 0 0 0 0 0 0 0
[ 4087.473407] rcu-torture: Reader Batch:  8 0 0 0 0 0 0 0 0 0 0
[ 4087.473407] rcu-torture: Free-Block Circulation:  0 0 0 0 0 0 0 0 0 0 0
[ 4094.259184] SMP alternatives: lockdep: fixing up alternatives
[ 4094.270193] smpboot: Booting Node 0 Processor 1 APIC 0x1
[ 3994.216033] masked ExtINT on CPU#1
[ 3994.216033] numa_add_cpu cpu 1 node 0: mask now 0-1
[ 4094.313949] CPU0 attaching NULL sched-domain.
[ 4094.317612] CPU0 attaching sched-domain:
[ 4094.320933]  domain 0: span 0-1 level CPU
[ 4094.324324]   groups: 0 (cpu_power = 1022) 1
[ 4094.327580] CPU1 attaching sched-domain:
[ 4094.330378]  domain 0: span 0-1 level CPU
[ 4094.333347]   groups: 1 0 (cpu_power = 1022)
[ 4094.381183] CPU0 attaching NULL sched-domain.
[ 4094.383962] CPU1 attaching NULL sched-domain.
[ 4094.386852] CPU0 attaching NULL sched-domain.
[ 4094.390453] numa_remove_cpu cpu 1 node 0: mask now 0
[ 4094.395912] smpboot: CPU 1 is now offline
[ 4094.547745] SMP alternatives: lockdep: fixing up alternatives
[ 4094.557170] smpboot: Booting Node 0 Processor 1 APIC 0x1
[ 4094.391033] masked ExtINT on CPU#1
[ 4094.391033] numa_add_cpu cpu 1 node 0: mask now 0-1
[ 4094.600203] CPU0 attaching NULL sched-domain.
[ 4094.604067] CPU0 attaching sched-domain:
[ 4094.607349]  domain 0: span 0-1 level CPU
[ 4094.610861]   groups: 0 (cpu_power = 1023) 1
[ 4094.615287] CPU1 attaching sched-domain:
[ 4094.618460]  domain 0: span 0-1 level CPU
[ 4094.622036]   groups: 1 0 (cpu_power = 1023)
[ 4095.646711] CPU0 attaching NULL sched-domain.
[ 4095.649768] CPU1 attaching NULL sched-domain.
[ 4095.652809] CPU0 attaching NULL sched-domain.
[ 4095.669248] numa_remove_cpu cpu 1 node 0: mask now 0
[ 4095.674079] smpboot: CPU 1 is now offline
[ 4105.723932] SMP alternatives: lockdep: fixing up alternatives
[ 4105.732904] smpboot: Booting Node 0 Processor 1 APIC 0x1
[ 4095.670136] masked ExtINT on CPU#1
[ 4095.670136] numa_add_cpu cpu 1 node 0: mask now 0-1
[ 4105.799267] CPU0 attaching NULL sched-domain.
[ 4105.823191] CPU0 attaching sched-domain:
[ 4105.825850]  domain 0: span 0-1 level CPU
[ 4105.832908]   groups: 0 (cpu_power = 977) 1
[ 4105.851111] CPU1 attaching sched-domain:
[ 4105.861597]  domain 0: span 0-1 level CPU
[ 4105.864717]   groups: 1 0 (cpu_power = 977)
[ 4147.503295] rcu-torture: rtc: ffffffff82da41a0 ver: 1 tfle: 0 rta: 1 rtaf: 0 rtf: 0 rtmbe: 0 rtbke: 0 rtbre: 0 rtbf: 0 rtb: 0 nt: 4 onoff: 0/0:0/0 -1,0:-1,0 0:0 (HZ=1000) barrier: 0/0:0
[ 4147.503295] rcu-torture: Reader Pipe:  8 0 0 0 0 0 0 0 0 0 0
[ 4147.503295] rcu-torture: Reader Batch:  8 0 0 0 0 0 0 0 0 0 0
[ 4147.503295] rcu-torture: Free-Block Circulation:  0 0 0 0 0 0 0 0 0 0 0
[ 4205.940387] CPU0 attaching NULL sched-domain.
[ 4205.943293] CPU1 attaching NULL sched-domain.
[ 4205.945797] CPU0 attaching NULL sched-domain.
[ 4205.953380] numa_remove_cpu cpu 1 node 0: mask now 0
[ 4205.959514] smpboot: CPU 1 is now offline
[ 4206.009574] SMP alternatives: lockdep: fixing up alternatives
[ 4206.015085] smpboot: Booting Node 0 Processor 1 APIC 0x1
[ 4205.954023] masked ExtINT on CPU#1
[ 4205.954023] numa_add_cpu cpu 1 node 0: mask now 0-1
[ 4206.103656] CPU0 attaching NULL sched-domain.
[ 4206.106465] CPU0 attaching sched-domain:
[ 4206.108820]  domain 0: span 0-1 level CPU
[ 4206.117907]   groups: 0 (cpu_power = 1022) 1
[ 4206.129656] CPU1 attaching sched-domain:
[ 4206.131901]  domain 0: span 0-1 level CPU
[ 4206.134409]   groups: 1 0 (cpu_power = 1022)
[ 4206.288221] CPU0 attaching NULL sched-domain.
[ 4206.290669] CPU1 attaching NULL sched-domain.
[ 4206.293237] CPU0 attaching NULL sched-domain.
[ 4206.296588] numa_remove_cpu cpu 1 node 0: mask now 0
[ 4206.301527] smpboot: CPU 1 is now offline
[ 4207.353659] SMP alternatives: lockdep: fixing up alternatives
[ 4207.386390] smpboot: Booting Node 0 Processor 1 APIC 0x1
[ 4206.297508] masked ExtINT on CPU#1
[ 4206.297508] numa_add_cpu cpu 1 node 0: mask now 0-1
[ 4207.479500] CPU0 attaching NULL sched-domain.
[ 4207.482887] CPU0 attaching sched-domain:
[ 4207.490732]  domain 0: span 0-1 level CPU
[ 4207.493637]   groups: 0 (cpu_power = 1023) 1
[ 4207.513984] CPU1 attaching sched-domain:
[ 4207.516829]  domain 0: span 0-1 level CPU
[ 4207.579063]   groups: 1 0 (cpu_power = 1023)
[ 4207.587312] rcu-torture: rtc: ffffffff82da41a0 ver: 1 tfle: 0 rta: 1 rtaf: 0 rtf: 0 rtmbe: 0 rtbke: 0 rtbre: 0 rtbf: 0 rtb: 0 nt: 4 onoff: 0/0:0/0 -1,0:-1,0 0:0 (HZ=1000) barrier: 0/0:0
[ 4207.587312] rcu-torture: Reader Pipe:  8 0 0 0 0 0 0 0 0 0 0
[ 4207.587312] rcu-torture: Reader Batch:  8 0 0 0 0 0 0 0 0 0 0
[ 4207.587312] rcu-torture: Free-Block Circulation:  0 0 0 0 0 0 0 0 0 0 0
[ 4217.678305] CPU0 attaching NULL sched-domain.
[ 4217.681055] CPU1 attaching NULL sched-domain.
[ 4217.683824] CPU0 attaching NULL sched-domain.
[ 4217.691015] numa_remove_cpu cpu 1 node 0: mask now 0
[ 4217.696095] smpboot: CPU 1 is now offline
[ 4267.635117] rcu-torture: rtc: ffffffff82da41a0 ver: 1 tfle: 0 rta: 1 rtaf: 0 rtf: 0 rtmbe: 0 rtbke: 0 rtbre: 0 rtbf: 0 rtb: 0 nt: 4 onoff: 0/0:0/0 -1,0:-1,0 0:0 (HZ=1000) barrier: 0/0:0
[ 4267.635117] rcu-torture: Reader Pipe:  8 0 0 0 0 0 0 0 0 0 0
[ 4267.635117] rcu-torture: Reader Batch:  8 0 0 0 0 0 0 0 0 0 0
[ 4267.635117] rcu-torture: Free-Block Circulation:  0 0 0 0 0 0 0 0 0 0 0
[ 4317.811260] SMP alternatives: lockdep: fixing up alternatives
[ 4317.818788] smpboot: Booting Node 0 Processor 1 APIC 0x1
[ 4217.691369] masked ExtINT on CPU#1
[ 4217.691369] numa_add_cpu cpu 1 node 0: mask now 0-1
[ 4317.855917] CPU0 attaching NULL sched-domain.
[ 4317.858800] CPU0 attaching sched-domain:
[ 4317.861055]  domain 0: span 0-1 level CPU
[ 4317.863449]   groups: 0 (cpu_power = 1023) 1
[ 4317.866489] CPU1 attaching sched-domain:
[ 4317.868668]  domain 0: span 0-1 level CPU
[ 4317.871119]   groups: 1 0 (cpu_power = 1023)
[ 4317.902444] CPU0 attaching NULL sched-domain.
[ 4317.905356] CPU1 attaching NULL sched-domain.
[ 4317.908259] CPU0 attaching NULL sched-domain.
[ 4317.911600] numa_remove_cpu cpu 1 node 0: mask now 0
[ 4317.916867] smpboot: CPU 1 is now offline
[ 4318.056540] SMP alternatives: lockdep: fixing up alternatives
[ 4318.065097] smpboot: Booting Node 0 Processor 1 APIC 0x1
[ 4317.912006] masked ExtINT on CPU#1
[ 4317.912006] numa_add_cpu cpu 1 node 0: mask now 0-1
[ 4318.104417] CPU0 attaching NULL sched-domain.
[ 4318.124296] CPU0 attaching sched-domain:
[ 4318.126466]  domain 0: span 0-1 level CPU
[ 4318.128908]   groups: 0 (cpu_power = 1012) 1
[ 4318.131959] CPU1 attaching sched-domain:
[ 4318.134096]  domain 0: span 0-1 level CPU
[ 4318.136427]   groups: 1 0 (cpu_power = 1012)
[ 4319.163237] CPU0 attaching NULL sched-domain.
[ 4319.166382] CPU1 attaching NULL sched-domain.
[ 4319.169661] CPU0 attaching NULL sched-domain.
[ 4319.174261] numa_remove_cpu cpu 1 node 0: mask now 0
[ 4319.180066] smpboot: CPU 1 is now offline
[ 4327.686215] rcu-torture: rtc: ffffffff82da41a0 ver: 1 tfle: 0 rta: 1 rtaf: 0 rtf: 0 rtmbe: 0 rtbke: 0 rtbre: 0 rtbf: 0 rtb: 0 nt: 4 onoff: 0/0:0/0 -1,0:-1,0 0:0 (HZ=1000) barrier: 0/0:0
[ 4327.686215] rcu-torture: Reader Pipe:  8 0 0 0 0 0 0 0 0 0 0
[ 4327.686215] rcu-torture: Reader Batch:  8 0 0 0 0 0 0 0 0 0 0
[ 4327.686215] rcu-torture: Free-Block Circulation:  0 0 0 0 0 0 0 0 0 0 0
[ 4329.228290] SMP alternatives: lockdep: fixing up alternatives
[ 4329.238107] smpboot: Booting Node 0 Processor 1 APIC 0x1
[ 4319.175110] masked ExtINT on CPU#1
[ 4319.175110] numa_add_cpu cpu 1 node 0: mask now 0-1
[ 4329.276927] CPU0 attaching NULL sched-domain.
[ 4329.280775] CPU0 attaching sched-domain:
[ 4329.283894]  domain 0: span 0-1 level CPU
[ 4329.287230]   groups: 0 (cpu_power = 1023) 1
[ 4329.291709] CPU1 attaching sched-domain:
[ 4329.294796]  domain 0: span 0-1 level CPU
[ 4329.298302]   groups: 1 0 (cpu_power = 1023)
[ 4387.705229] rcu-torture: rtc: ffffffff82da41a0 ver: 1 tfle: 0 rta: 1 rtaf: 0 rtf: 0 rtmbe: 0 rtbke: 0 rtbre: 0 rtbf: 0 rtb: 0 nt: 4 onoff: 0/0:0/0 -1,0:-1,0 0:0 (HZ=1000) barrier: 0/0:0
[ 4387.705229] rcu-torture: Reader Pipe:  8 0 0 0 0 0 0 0 0 0 0
[ 4387.705229] rcu-torture: Reader Batch:  8 0 0 0 0 0 0 0 0 0 0
[ 4387.705229] rcu-torture: Free-Block Circulation:  0 0 0 0 0 0 0 0 0 0 0
[ 4429.321653] CPU0 attaching NULL sched-domain.
[ 4429.324565] CPU1 attaching NULL sched-domain.
[ 4429.327511] CPU0 attaching NULL sched-domain.
[ 4429.332261] numa_remove_cpu cpu 1 node 0: mask now 0
[ 4429.338306] smpboot: CPU 1 is now offline
[ 4429.393300] SMP alternatives: lockdep: fixing up alternatives
[ 4429.399113] smpboot: Booting Node 0 Processor 1 APIC 0x1
[ 4429.333030] masked ExtINT on CPU#1
[ 4429.333030] numa_add_cpu cpu 1 node 0: mask now 0-1
[ 4429.455069] CPU0 attaching NULL sched-domain.
[ 4429.458454] CPU0 attaching sched-domain:
[ 4429.461273]  domain 0: span 0-1 level CPU
[ 4429.464075]   groups: 0 (cpu_power = 1023) 1
[ 4429.467756] CPU1 attaching sched-domain:
[ 4429.470602]  domain 0: span 0-1 level CPU
[ 4429.473603]   groups: 1 0 (cpu_power = 1023)
[ 4429.601112] CPU0 attaching NULL sched-domain.
[ 4429.604124] CPU1 attaching NULL sched-domain.
[ 4429.607546] CPU0 attaching NULL sched-domain.
[ 4429.612390] numa_remove_cpu cpu 1 node 0: mask now 0
[ 4429.618185] smpboot: CPU 1 is now offline
[ 4430.668753] SMP alternatives: lockdep: fixing up alternatives
[ 4430.677156] smpboot: Booting Node 0 Processor 1 APIC 0x1
[ 4429.613035] masked ExtINT on CPU#1
[ 4429.613035] numa_add_cpu cpu 1 node 0: mask now 0-1
[ 4430.718459] CPU0 attaching NULL sched-domain.
[ 4430.721866] CPU0 attaching sched-domain:
[ 4430.724862]  domain 0: span 0-1 level CPU
[ 4430.728029]   groups: 0 (cpu_power = 1022) 1
[ 4430.731971] CPU1 attaching sched-domain:
[ 4430.734809]  domain 0: span 0-1 level CPU
[ 4430.737837]   groups: 1 0 (cpu_power = 1022)
[ 4440.764333] CPU0 attaching NULL sched-domain.
[ 4440.767698] CPU1 attaching NULL sched-domain.
[ 4440.770471] CPU0 attaching NULL sched-domain.
[ 4440.773406] numa_remove_cpu cpu 1 node 0: mask now 0
[ 4440.778605] smpboot: CPU 1 is now offline
[ 4447.725262] rcu-torture: rtc: ffffffff82da41a0 ver: 1 tfle: 0 rta: 1 rtaf: 0 rtf: 0 rtmbe: 0 rtbke: 0 rtbre: 0 rtbf: 0 rtb: 0 nt: 4 onoff: 0/0:0/0 -1,0:-1,0 0:0 (HZ=1000) barrier: 0/0:0
[ 4447.725262] rcu-torture: Reader Pipe:  8 0 0 0 0 0 0 0 0 0 0
[ 4447.725262] rcu-torture: Reader Batch:  8 0 0 0 0 0 0 0 0 0 0
[ 4447.725262] rcu-torture: Free-Block Circulation:  0 0 0 0 0 0 0 0 0 0 0
[ 4507.740228] rcu-torture: rtc: ffffffff82da41a0 ver: 1 tfle: 0 rta: 1 rtaf: 0 rtf: 0 rtmbe: 0 rtbke: 0 rtbre: 0 rtbf: 0 rtb: 0 nt: 4 onoff: 0/0:0/0 -1,0:-1,0 0:0 (HZ=1000) barrier: 0/0:0
[ 4507.740228] rcu-torture: Reader Pipe:  8 0 0 0 0 0 0 0 0 0 0
[ 4507.740228] rcu-torture: Reader Batch:  8 0 0 0 0 0 0 0 0 0 0
[ 4507.740228] rcu-torture: Free-Block Circulation:  0 0 0 0 0 0 0 0 0 0 0
[ 4540.827003] SMP alternatives: lockdep: fixing up alternatives
[ 4540.836146] smpboot: Booting Node 0 Processor 1 APIC 0x1
[ 4440.774318] masked ExtINT on CPU#1
[ 4440.774318] numa_add_cpu cpu 1 node 0: mask now 0-1
[ 4540.874939] CPU0 attaching NULL sched-domain.
[ 4540.878856] CPU0 attaching sched-domain:
[ 4540.882205]  domain 0: span 0-1 level CPU
[ 4540.885601]   groups: 0 (cpu_power = 1022) 1
[ 4540.890061] CPU1 attaching sched-domain:
[ 4540.893227]  domain 0: span 0-1 level CPU
[ 4540.896821]   groups: 1 0 (cpu_power = 1022)
[ 4540.932091] CPU0 attaching NULL sched-domain.
[ 4540.935059] CPU1 attaching NULL sched-domain.
[ 4540.938215] CPU0 attaching NULL sched-domain.
[ 4540.942797] numa_remove_cpu cpu 1 node 0: mask now 0
[ 4540.948852] smpboot: CPU 1 is now offline
[ 4541.098730] SMP alternatives: lockdep: fixing up alternatives
[ 4541.108134] smpboot: Booting Node 0 Processor 1 APIC 0x1
[ 4540.943058] masked ExtINT on CPU#1
[ 4540.943058] numa_add_cpu cpu 1 node 0: mask now 0-1
[ 4541.149241] CPU0 attaching NULL sched-domain.
[ 4541.153474] CPU0 attaching sched-domain:
[ 4541.156838]  domain 0: span 0-1 level CPU
[ 4541.160414]   groups: 0 (cpu_power = 1022) 1
[ 4541.164858] CPU1 attaching sched-domain:
[ 4541.168134]  domain 0: span 0-1 level CPU
[ 4541.171464]   groups: 1 0 (cpu_power = 1022)
[ 4542.201693] CPU0 attaching NULL sched-domain.
[ 4542.205544] CPU1 attaching NULL sched-domain.
[ 4542.209068] CPU0 attaching NULL sched-domain.
[ 4542.214174] numa_remove_cpu cpu 1 node 0: mask now 0
[ 4542.219926] smpboot: CPU 1 is now offline
[ 4552.274749] SMP alternatives: lockdep: fixing up alternatives
[ 4552.282730] smpboot: Booting Node 0 Processor 1 APIC 0x1
[ 4542.215031] masked ExtINT on CPU#1
[ 4542.215031] numa_add_cpu cpu 1 node 0: mask now 0-1
[ 4552.320306] CPU0 attaching NULL sched-domain.
[ 4552.323063] CPU0 attaching sched-domain:
[ 4552.325208]  domain 0: span 0-1 level CPU
[ 4552.327797]   groups: 0 (cpu_power = 1022) 1
[ 4552.330909] CPU1 attaching sched-domain:
[ 4552.333053]  domain 0: span 0-1 level CPU
[ 4552.335360]   groups: 1 0 (cpu_power = 1022)
[ 4567.759291] rcu-torture: rtc: ffffffff82da41a0 ver: 1 tfle: 0 rta: 1 rtaf: 0 rtf: 0 rtmbe: 0 rtbke: 0 rtbre: 0 rtbf: 0 rtb: 0 nt: 4 onoff: 0/0:0/0 -1,0:-1,0 0:0 (HZ=1000) barrier: 0/0:0
[ 4567.759291] rcu-torture: Reader Pipe:  8 0 0 0 0 0 0 0 0 0 0
[ 4567.759291] rcu-torture: Reader Batch:  8 0 0 0 0 0 0 0 0 0 0
[ 4567.759291] rcu-torture: Free-Block Circulation:  0 0 0 0 0 0 0 0 0 0 0
[ 4627.778246] rcu-torture: rtc: ffffffff82da41a0 ver: 1 tfle: 0 rta: 1 rtaf: 0 rtf: 0 rtmbe: 0 rtbke: 0 rtbre: 0 rtbf: 0 rtb: 0 nt: 4 onoff: 0/0:0/0 -1,0:-1,0 0:0 (HZ=1000) barrier: 0/0:0
[ 4627.778246] rcu-torture: Reader Pipe:  8 0 0 0 0 0 0 0 0 0 0
[ 4627.778246] rcu-torture: Reader Batch:  8 0 0 0 0 0 0 0 0 0 0
[ 4627.778246] rcu-torture: Free-Block Circulation:  0 0 0 0 0 0 0 0 0 0 0
[ 4652.361743] CPU0 attaching NULL sched-domain.
[ 4652.364804] CPU1 attaching NULL sched-domain.
[ 4652.367893] CPU0 attaching NULL sched-domain.
[ 4652.374300] numa_remove_cpu cpu 1 node 0: mask now 0
[ 4652.379583] smpboot: CPU 1 is now offline
[ 4652.447676] SMP alternatives: lockdep: fixing up alternatives
[ 4652.457125] smpboot: Booting Node 0 Processor 1 APIC 0x1
[ 4652.375200] masked ExtINT on CPU#1
[ 4652.375200] numa_add_cpu cpu 1 node 0: mask now 0-1
[ 4652.510852] CPU0 attaching NULL sched-domain.
[ 4652.517827] CPU0 attaching sched-domain:
[ 4652.521701]  domain 0: span 0-1 level CPU
[ 4652.525110]   groups: 0 (cpu_power = 1022) 1
[ 4652.531131] CPU1 attaching sched-domain:
[ 4652.533963]  domain 0: span 0-1 level CPU
[ 4652.536894]   groups: 1 0 (cpu_power = 1022)
[ 4652.667183] CPU0 attaching NULL sched-domain.
[ 4652.673052] CPU1 attaching NULL sched-domain.
[ 4652.676105] CPU0 attaching NULL sched-domain.
[ 4652.679372] numa_remove_cpu cpu 1 node 0: mask now 0
[ 4652.684708] smpboot: CPU 1 is now offline
[ 4653.733834] SMP alternatives: lockdep: fixing up alternatives
[ 4653.740110] smpboot: Booting Node 0 Processor 1 APIC 0x1
[ 4652.680024] masked ExtINT on CPU#1
[ 4652.680024] numa_add_cpu cpu 1 node 0: mask now 0-1
[ 4653.785086] CPU0 attaching NULL sched-domain.
[ 4653.788790] CPU0 attaching sched-domain:
[ 4653.791897]  domain 0: span 0-1 level CPU
[ 4653.795124]   groups: 0 (cpu_power = 1022) 1
[ 4653.798993] CPU1 attaching sched-domain:
[ 4653.801816]  domain 0: span 0-1 level CPU
[ 4653.804926]   groups: 1 0 (cpu_power = 1022)
[ 4663.832081] CPU0 attaching NULL sched-domain.
[ 4663.835213] CPU1 attaching NULL sched-domain.
[ 4663.838443] CPU0 attaching NULL sched-domain.
[ 4663.843204] numa_remove_cpu cpu 1 node 0: mask now 0
[ 4663.848552] smpboot: CPU 1 is now offline
[ 4687.797421] rcu-torture: rtc: ffffffff82da41a0 ver: 1 tfle: 0 rta: 1 rtaf: 0 rtf: 0 rtmbe: 0 rtbke: 0 rtbre: 0 rtbf: 0 rtb: 0 nt: 4 onoff: 0/0:0/0 -1,0:-1,0 0:0 (HZ=1000) barrier: 0/0:0
[ 4687.797421] rcu-torture: Reader Pipe:  8 0 0 0 0 0 0 0 0 0 0
[ 4687.797421] rcu-torture: Reader Batch:  8 0 0 0 0 0 0 0 0 0 0
[ 4687.797421] rcu-torture: Free-Block Circulation:  0 0 0 0 0 0 0 0 0 0 0
[ 4747.817274] rcu-torture: rtc: ffffffff82da41a0 ver: 1 tfle: 0 rta: 1 rtaf: 0 rtf: 0 rtmbe: 0 rtbke: 0 rtbre: 0 rtbf: 0 rtb: 0 nt: 4 onoff: 0/0:0/0 -1,0:-1,0 0:0 (HZ=1000) barrier: 0/0:0
[ 4747.817274] rcu-torture: Reader Pipe:  8 0 0 0 0 0 0 0 0 0 0
[ 4747.817274] rcu-torture: Reader Batch:  8 0 0 0 0 0 0 0 0 0 0
[ 4747.817274] rcu-torture: Free-Block Circulation:  0 0 0 0 0 0 0 0 0 0 0
[ 4763.902783] SMP alternatives: lockdep: fixing up alternatives
[ 4763.911141] smpboot: Booting Node 0 Processor 1 APIC 0x1
[ 4663.844116] masked ExtINT on CPU#1
[ 4663.844116] numa_add_cpu cpu 1 node 0: mask now 0-1
[ 4763.948931] CPU0 attaching NULL sched-domain.
[ 4763.951573] CPU0 attaching sched-domain:
[ 4763.953718]  domain 0: span 0-1 level CPU
[ 4763.956084]   groups: 0 (cpu_power = 1023) 1
[ 4763.959096] CPU1 attaching sched-domain:
[ 4763.961210]  domain 0: span 0-1 level CPU
[ 4763.963504]   groups: 1 0 (cpu_power = 1023)
[ 4763.999267] CPU0 attaching NULL sched-domain.
[ 4764.002289] CPU1 attaching NULL sched-domain.
[ 4764.004965] CPU0 attaching NULL sched-domain.
[ 4764.012321] numa_remove_cpu cpu 1 node 0: mask now 0
[ 4764.017415] smpboot: CPU 1 is now offline
[ 4764.162749] SMP alternatives: lockdep: fixing up alternatives
[ 4764.168113] smpboot: Booting Node 0 Processor 1 APIC 0x1
[ 4764.013021] masked ExtINT on CPU#1
[ 4764.013021] numa_add_cpu cpu 1 node 0: mask now 0-1
[ 4764.207791] CPU0 attaching NULL sched-domain.
[ 4764.210567] CPU0 attaching sched-domain:
[ 4764.212913]  domain 0: span 0-1 level CPU
[ 4764.232008]   groups: 0 (cpu_power = 1023) 1
[ 4764.235033] CPU1 attaching sched-domain:
[ 4764.237124]  domain 0: span 0-1 level CPU
[ 4764.239459]   groups: 1 0 (cpu_power = 1023)
[ 4765.266196] CPU0 attaching NULL sched-domain.
[ 4765.268533] CPU1 attaching NULL sched-domain.
[ 4765.271060] CPU0 attaching NULL sched-domain.
[ 4765.274018] numa_remove_cpu cpu 1 node 0: mask now 0
[ 4765.282247] smpboot: CPU 1 is now offline
[ 4775.328823] SMP alternatives: lockdep: fixing up alternatives
[ 4775.340756] smpboot: Booting Node 0 Processor 1 APIC 0x1
[ 4765.274886] masked ExtINT on CPU#1
[ 4765.274886] numa_add_cpu cpu 1 node 0: mask now 0-1
[ 4775.394609] CPU0 attaching NULL sched-domain.
[ 4775.397869] CPU0 attaching sched-domain:
[ 4775.400656]  domain 0: span 0-1 level CPU
[ 4775.403670]   groups: 0 (cpu_power = 1023) 1
[ 4775.407407] CPU1 attaching sched-domain:
[ 4775.410035]  domain 0: span 0-1 level CPU
[ 4775.412960]   groups: 1 0 (cpu_power = 1023)
[ 4807.834300] rcu-torture: rtc: ffffffff82da41a0 ver: 1 tfle: 0 rta: 1 rtaf: 0 rtf: 0 rtmbe: 0 rtbke: 0 rtbre: 0 rtbf: 0 rtb: 0 nt: 4 onoff: 0/0:0/0 -1,0:-1,0 0:0 (HZ=1000) barrier: 0/0:0
[ 4807.834300] rcu-torture: Reader Pipe:  8 0 0 0 0 0 0 0 0 0 0
[ 4807.834300] rcu-torture: Reader Batch:  8 0 0 0 0 0 0 0 0 0 0
[ 4807.834300] rcu-torture: Free-Block Circulation:  0 0 0 0 0 0 0 0 0 0 0
[ 4867.851153] rcu-torture: rtc: ffffffff82da41a0 ver: 1 tfle: 0 rta: 1 rtaf: 0 rtf: 0 rtmbe: 0 rtbke: 0 rtbre: 0 rtbf: 0 rtb: 0 nt: 4 onoff: 0/0:0/0 -1,0:-1,0 0:0 (HZ=1000) barrier: 0/0:0
[ 4867.851153] rcu-torture: Reader Pipe:  8 0 0 0 0 0 0 0 0 0 0
[ 4867.851153] rcu-torture: Reader Batch:  8 0 0 0 0 0 0 0 0 0 0
[ 4867.851153] rcu-torture: Free-Block Circulation:  0 0 0 0 0 0 0 0 0 0 0
[ 4875.442390] CPU0 attaching NULL sched-domain.
[ 4875.444899] CPU1 attaching NULL sched-domain.
[ 4875.447582] CPU0 attaching NULL sched-domain.
[ 4875.450714] numa_remove_cpu cpu 1 node 0: mask now 0
[ 4875.455551] smpboot: CPU 1 is now offline
[ 4875.502546] SMP alternatives: lockdep: fixing up alternatives
[ 4875.508122] smpboot: Booting Node 0 Processor 1 APIC 0x1
[ 4875.451024] masked ExtINT on CPU#1
[ 4875.451024] numa_add_cpu cpu 1 node 0: mask now 0-1
[ 4875.549484] CPU0 attaching NULL sched-domain.
[ 4875.551534] CPU0 attaching sched-domain:
[ 4875.553255]  domain 0: span 0-1 level CPU
[ 4875.555137]   groups: 0 (cpu_power = 1023) 1
[ 4875.557636] CPU1 attaching sched-domain:
[ 4875.559415]  domain 0: span 0-1 level CPU
[ 4875.561861]   groups: 1 0 (cpu_power = 1023)
[ 4875.679091] CPU0 attaching NULL sched-domain.
[ 4875.681853] CPU1 attaching NULL sched-domain.
[ 4875.683953] CPU0 attaching NULL sched-domain.
[ 4875.686432] numa_remove_cpu cpu 1 node 0: mask now 0
[ 4875.691339] smpboot: CPU 1 is now offline
[ 4876.716584] SMP alternatives: lockdep: fixing up alternatives
[ 4876.718769] smpboot: Booting Node 0 Processor 1 APIC 0x1
[ 4875.687356] masked ExtINT on CPU#1
[ 4875.687356] numa_add_cpu cpu 1 node 0: mask now 0-1
[ 4876.758231] CPU0 attaching NULL sched-domain.
[ 4876.760292] CPU0 attaching sched-domain:
[ 4876.761997]  domain 0: span 0-1 level CPU
[ 4876.763890]   groups: 0 (cpu_power = 1023) 1
[ 4876.766248] CPU1 attaching sched-domain:
[ 4876.767865]  domain 0: span 0-1 level CPU
[ 4876.769684]   groups: 1 0 (cpu_power = 1023)
[ 4886.788961] CPU0 attaching NULL sched-domain.
[ 4886.790772] CPU1 attaching NULL sched-domain.
[ 4886.792712] CPU0 attaching NULL sched-domain.
[ 4886.794880] numa_remove_cpu cpu 1 node 0: mask now 0
[ 4886.798991] smpboot: CPU 1 is now offline
[ 4927.862199] rcu-torture: rtc: ffffffff82da41a0 ver: 1 tfle: 0 rta: 1 rtaf: 0 rtf: 0 rtmbe: 0 rtbke: 0 rtbre: 0 rtbf: 0 rtb: 0 nt: 4 onoff: 0/0:0/0 -1,0:-1,0 0:0 (HZ=1000) barrier: 0/0:0
[ 4927.862199] rcu-torture: Reader Pipe:  8 0 0 0 0 0 0 0 0 0 0
[ 4927.862199] rcu-torture: Reader Batch:  8 0 0 0 0 0 0 0 0 0 0
[ 4927.862199] rcu-torture: Free-Block Circulation:  0 0 0 0 0 0 0 0 0 0 0
[ 4986.837766] SMP alternatives: lockdep: fixing up alternatives
[ 4986.852643] smpboot: Booting Node 0 Processor 1 APIC 0x1
[ 4886.795518] masked ExtINT on CPU#1
[ 4886.795518] numa_add_cpu cpu 1 node 0: mask now 0-1
[ 4987.011225] CPU0 attaching NULL sched-domain.
[ 4987.014684] CPU0 attaching sched-domain:
[ 4987.017493]  domain 0: span 0-1 level CPU
[ 4987.030626]   groups: 0 (cpu_power = 1023) 1
[ 4987.034806] CPU1 attaching sched-domain:
[ 4987.057065]  domain 0: span 0-1 level CPU
[ 4987.060658]   groups: 1 0 (cpu_power = 1023)
[ 4987.203726] CPU0 attaching NULL sched-domain.
[ 4987.207235] CPU1 attaching NULL sched-domain.
[ 4987.220609] CPU0 attaching NULL sched-domain.
[ 4987.238262] numa_remove_cpu cpu 1 node 0: mask now 0
[ 4987.257322] smpboot: CPU 1 is now offline
[ 4987.476727] SMP alternatives: lockdep: fixing up alternatives
[ 4987.515201] smpboot: Booting Node 0 Processor 1 APIC 0x1
[ 4987.239142] masked ExtINT on CPU#1
[ 4987.239142] numa_add_cpu cpu 1 node 0: mask now 0-1
[ 4987.614332] CPU0 attaching NULL sched-domain.
[ 4987.617210] CPU0 attaching sched-domain:
[ 4987.619753]  domain 0: span 0-1 level CPU
[ 4987.622512]   groups: 0 (cpu_power = 1019) 1
[ 4987.626318] CPU1 attaching sched-domain:
[ 4987.629269]  domain 0: span 0-1 level CPU
[ 4987.632290]   groups: 1 0 (cpu_power = 1019)
[ 4987.880235] rcu-torture: rtc: ffffffff82da41a0 ver: 1 tfle: 0 rta: 1 rtaf: 0 rtf: 0 rtmbe: 0 rtbke: 0 rtbre: 0 rtbf: 0 rtb: 0 nt: 4 onoff: 0/0:0/0 -1,0:-1,0 0:0 (HZ=1000) barrier: 0/0:0
[ 4987.880235] rcu-torture: Reader Pipe:  8 0 0 0 0 0 0 0 0 0 0
[ 4987.880235] rcu-torture: Reader Batch:  8 0 0 0 0 0 0 0 0 0 0
[ 4987.880235] rcu-torture: Free-Block Circulation:  0 0 0 0 0 0 0 0 0 0 0
[ 4988.689243] CPU0 attaching NULL sched-domain.
[ 4988.692125] CPU1 attaching NULL sched-domain.
[ 4988.694805] CPU0 attaching NULL sched-domain.
[ 4988.713904] numa_remove_cpu cpu 1 node 0: mask now 0
[ 4988.718736] smpboot: CPU 1 is now offline
[ 4998.879506] SMP alternatives: lockdep: fixing up alternatives
[ 4998.885131] smpboot: Booting Node 0 Processor 1 APIC 0x1
[ 4988.714804] masked ExtINT on CPU#1
[ 4988.714804] numa_add_cpu cpu 1 node 0: mask now 0-1
[ 4998.979359] CPU0 attaching NULL sched-domain.
[ 4998.982663] CPU0 attaching sched-domain:
[ 4998.985593]  domain 0: span 0-1 level CPU
[ 4998.988670]   groups: 0 (cpu_power = 1023) 1
[ 4999.002755] CPU1 attaching sched-domain:
[ 4999.005462]  domain 0: span 0-1 level CPU
[ 4999.008502]   groups: 1 0 (cpu_power = 1023)
[ 5047.911248] rcu-torture: rtc: ffffffff82da41a0 ver: 1 tfle: 0 rta: 1 rtaf: 0 rtf: 0 rtmbe: 0 rtbke: 0 rtbre: 0 rtbf: 0 rtb: 0 nt: 4 onoff: 0/0:0/0 -1,0:-1,0 0:0 (HZ=1000) barrier: 0/0:0
[ 5047.911248] rcu-torture: Reader Pipe:  8 0 0 0 0 0 0 0 0 0 0
[ 5047.911248] rcu-torture: Reader Batch:  8 0 0 0 0 0 0 0 0 0 0
[ 5047.911248] rcu-torture: Free-Block Circulation:  0 0 0 0 0 0 0 0 0 0 0
[ 5099.047336] CPU0 attaching NULL sched-domain.
[ 5099.050127] CPU1 attaching NULL sched-domain.
[ 5099.053049] CPU0 attaching NULL sched-domain.
[ 5099.056219] numa_remove_cpu cpu 1 node 0: mask now 0
[ 5099.061269] smpboot: CPU 1 is now offline
[ 5099.096491] SMP alternatives: lockdep: fixing up alternatives
[ 5099.102082] smpboot: Booting Node 0 Processor 1 APIC 0x1
[ 5099.057026] masked ExtINT on CPU#1
[ 5099.057026] numa_add_cpu cpu 1 node 0: mask now 0-1
[ 5099.138845] CPU0 attaching NULL sched-domain.
[ 5099.141616] CPU0 attaching sched-domain:
[ 5099.143623]  domain 0: span 0-1 level CPU
[ 5099.145825]   groups: 0 (cpu_power = 1023) 1
[ 5099.148643] CPU1 attaching sched-domain:
[ 5099.150652]  domain 0: span 0-1 level CPU
[ 5099.152848]   groups: 1 0 (cpu_power = 1023)
[ 5099.275666] CPU0 attaching NULL sched-domain.
[ 5099.278365] CPU1 attaching NULL sched-domain.
[ 5099.281259] CPU0 attaching NULL sched-domain.
[ 5099.284397] numa_remove_cpu cpu 1 node 0: mask now 0
[ 5099.288857] smpboot: CPU 1 is now offline
[ 5100.322445] SMP alternatives: lockdep: fixing up alternatives
[ 5100.324848] smpboot: Booting Node 0 Processor 1 APIC 0x1
[ 5099.285021] masked ExtINT on CPU#1
[ 5099.285021] numa_add_cpu cpu 1 node 0: mask now 0-1
[ 5100.364162] CPU0 attaching NULL sched-domain.
[ 5100.366541] CPU0 attaching sched-domain:
[ 5100.368466]  domain 0: span 0-1 level CPU
[ 5100.370690]   groups: 0 (cpu_power = 1023) 1
[ 5100.373424] CPU1 attaching sched-domain:
[ 5100.375343]  domain 0: span 0-1 level CPU
[ 5100.377476]   groups: 1 0 (cpu_power = 1023)
[ 5107.925192] rcu-torture: rtc: ffffffff82da41a0 ver: 1 tfle: 0 rta: 1 rtaf: 0 rtf: 0 rtmbe: 0 rtbke: 0 rtbre: 0 rtbf: 0 rtb: 0 nt: 4 onoff: 0/0:0/0 -1,0:-1,0 0:0 (HZ=1000) barrier: 0/0:0
[ 5107.925192] rcu-torture: Reader Pipe:  8 0 0 0 0 0 0 0 0 0 0
[ 5107.925192] rcu-torture: Reader Batch:  8 0 0 0 0 0 0 0 0 0 0
[ 5107.925192] rcu-torture: Free-Block Circulation:  0 0 0 0 0 0 0 0 0 0 0
[ 5110.397391] CPU0 attaching NULL sched-domain.
[ 5110.401189] CPU1 attaching NULL sched-domain.
[ 5110.405336] CPU0 attaching NULL sched-domain.
[ 5110.409979] numa_remove_cpu cpu 1 node 0: mask now 0
[ 5110.415911] smpboot: CPU 1 is now offline
[ 5167.939434] rcu-torture: rtc: ffffffff82da41a0 ver: 1 tfle: 0 rta: 1 rtaf: 0 rtf: 0 rtmbe: 0 rtbke: 0 rtbre: 0 rtbf: 0 rtb: 0 nt: 4 onoff: 0/0:0/0 -1,0:-1,0 0:0 (HZ=1000) barrier: 0/0:0
[ 5167.939434] rcu-torture: Reader Pipe:  8 0 0 0 0 0 0 0 0 0 0
[ 5167.939434] rcu-torture: Reader Batch:  8 0 0 0 0 0 0 0 0 0 0
[ 5167.939434] rcu-torture: Free-Block Circulation:  0 0 0 0 0 0 0 0 0 0 0
[ 5210.464618] SMP alternatives: lockdep: fixing up alternatives
[ 5210.467339] smpboot: Booting Node 0 Processor 1 APIC 0x1
[ 5110.410844] masked ExtINT on CPU#1
[ 5110.410844] numa_add_cpu cpu 1 node 0: mask now 0-1
[ 5210.505672] CPU0 attaching NULL sched-domain.
[ 5210.508244] CPU0 attaching sched-domain:
[ 5210.510173]  domain 0: span 0-1 level CPU
[ 5210.512477]   groups: 0 (cpu_power = 1023) 1
[ 5210.515043] CPU1 attaching sched-domain:
[ 5210.516807]  domain 0: span 0-1 level CPU
[ 5210.518789]   groups: 1 0 (cpu_power = 1023)
[ 5210.671111] CPU0 attaching NULL sched-domain.
[ 5210.674473] CPU1 attaching NULL sched-domain.
[ 5210.677963] CPU0 attaching NULL sched-domain.
[ 5210.682060] numa_remove_cpu cpu 1 node 0: mask now 0
[ 5210.687836] smpboot: CPU 1 is now offline
[ 5210.861418] SMP alternatives: lockdep: fixing up alternatives
[ 5210.867067] smpboot: Booting Node 0 Processor 1 APIC 0x1
[ 5210.682417] masked ExtINT on CPU#1
[ 5210.682417] numa_add_cpu cpu 1 node 0: mask now 0-1
[ 5210.904815] CPU0 attaching NULL sched-domain.
[ 5210.907476] CPU0 attaching sched-domain:
[ 5210.909513]  domain 0: span 0-1 level CPU
[ 5210.911785]   groups: 0 (cpu_power = 1023) 1
[ 5210.914749] CPU1 attaching sched-domain:
[ 5210.916753]  domain 0: span 0-1 level CPU
[ 5210.919002]   groups: 1 0 (cpu_power = 1023)
[ 5211.937369] CPU0 attaching NULL sched-domain.
[ 5211.939640] CPU1 attaching NULL sched-domain.
[ 5211.942440] CPU0 attaching NULL sched-domain.
[ 5211.945630] numa_remove_cpu cpu 1 node 0: mask now 0
[ 5211.950330] smpboot: CPU 1 is now offline
[ 5222.018307] SMP alternatives: lockdep: fixing up alternatives
[ 5222.040135] smpboot: Booting Node 0 Processor 1 APIC 0x1
[ 5211.946562] masked ExtINT on CPU#1
[ 5211.946562] numa_add_cpu cpu 1 node 0: mask now 0-1
[ 5222.149986] CPU0 attaching NULL sched-domain.
[ 5222.170434] CPU0 attaching sched-domain:
[ 5222.178055]  domain 0: span 0-1 level CPU
[ 5222.184809]   groups: 0 (cpu_power = 1023) 1
[ 5222.200077] CPU1 attaching sched-domain:
[ 5222.206041]  domain 0: span 0-1 level CPU
[ 5222.209030]   groups: 1 0 (cpu_power = 1023)
[ 5227.978283] rcu-torture: rtc: ffffffff82da41a0 ver: 1 tfle: 0 rta: 1 rtaf: 0 rtf: 0 rtmbe: 0 rtbke: 0 rtbre: 0 rtbf: 0 rtb: 0 nt: 4 onoff: 0/0:0/0 -1,0:-1,0 0:0 (HZ=1000) barrier: 0/0:0
[ 5227.978283] rcu-torture: Reader Pipe:  8 0 0 0 0 0 0 0 0 0 0
[ 5227.978283] rcu-torture: Reader Batch:  8 0 0 0 0 0 0 0 0 0 0
[ 5227.978283] rcu-torture: Free-Block Circulation:  0 0 0 0 0 0 0 0 0 0 0
[ 5288.049327] rcu-torture: rtc: ffffffff82da41a0 ver: 1 tfle: 0 rta: 1 rtaf: 0 rtf: 0 rtmbe: 0 rtbke: 0 rtbre: 0 rtbf: 0 rtb: 0 nt: 4 onoff: 0/0:0/0 -1,0:-1,0 0:0 (HZ=1000) barrier: 0/0:0
[ 5288.049327] rcu-torture: Reader Pipe:  8 0 0 0 0 0 0 0 0 0 0
[ 5288.049327] rcu-torture: Reader Batch:  8 0 0 0 0 0 0 0 0 0 0
[ 5288.049327] rcu-torture: Free-Block Circulation:  0 0 0 0 0 0 0 0 0 0 0
[ 5322.391769] CPU0 attaching NULL sched-domain.
[ 5322.393819] CPU1 attaching NULL sched-domain.
[ 5322.395963] CPU0 attaching NULL sched-domain.
[ 5322.398338] numa_remove_cpu cpu 1 node 0: mask now 0
[ 5322.402595] smpboot: CPU 1 is now offline
[ 5322.756199] SMP alternatives: lockdep: fixing up alternatives
[ 5322.762383] smpboot: Booting Node 0 Processor 1 APIC 0x1
[ 5322.399014] masked ExtINT on CPU#1
[ 5322.399014] numa_add_cpu cpu 1 node 0: mask now 0-1
[ 5322.799286] CPU0 attaching NULL sched-domain.
[ 5322.802480] CPU0 attaching sched-domain:
[ 5322.804638]  domain 0: span 0-1 level CPU
[ 5322.806882]   groups: 0 (cpu_power = 1023) 1
[ 5322.809887] CPU1 attaching sched-domain:
[ 5322.811854]  domain 0: span 0-1 level CPU
[ 5322.814020]   groups: 1 0 (cpu_power = 1023)
[ 5322.928823] CPU0 attaching NULL sched-domain.
[ 5322.930994] CPU1 attaching NULL sched-domain.
[ 5322.933223] CPU0 attaching NULL sched-domain.
[ 5322.935729] numa_remove_cpu cpu 1 node 0: mask now 0
[ 5322.940161] smpboot: CPU 1 is now offline
[ 5323.962235] SMP alternatives: lockdep: fixing up alternatives
[ 5323.967082] smpboot: Booting Node 0 Processor 1 APIC 0x1
[ 5322.936660] masked ExtINT on CPU#1
[ 5322.936660] numa_add_cpu cpu 1 node 0: mask now 0-1
[ 5324.005308] CPU0 attaching NULL sched-domain.
[ 5324.007726] CPU0 attaching sched-domain:
[ 5324.009706]  domain 0: span 0-1 level CPU
[ 5324.011852]   groups: 0 (cpu_power = 1023) 1
[ 5324.014616] CPU1 attaching sched-domain:
[ 5324.016561]  domain 0: span 0-1 level CPU
[ 5324.018683]   groups: 1 0 (cpu_power = 1023)
[ 5334.037721] CPU0 attaching NULL sched-domain.
[ 5334.039856] CPU1 attaching NULL sched-domain.
[ 5334.042172] CPU0 attaching NULL sched-domain.
[ 5334.044621] numa_remove_cpu cpu 1 node 0: mask now 0
[ 5334.049202] smpboot: CPU 1 is now offline
[ 5348.078166] rcu-torture: rtc: ffffffff82da41a0 ver: 1 tfle: 0 rta: 1 rtaf: 0 rtf: 0 rtmbe: 0 rtbke: 0 rtbre: 0 rtbf: 0 rtb: 0 nt: 4 onoff: 0/0:0/0 -1,0:-1,0 0:0 (HZ=1000) barrier: 0/0:0
[ 5348.078166] rcu-torture: Reader Pipe:  8 0 0 0 0 0 0 0 0 0 0
[ 5348.078166] rcu-torture: Reader Batch:  8 0 0 0 0 0 0 0 0 0 0
[ 5348.078166] rcu-torture: Free-Block Circulation:  0 0 0 0 0 0 0 0 0 0 0
[ 5408.097164] rcu-torture: rtc: ffffffff82da41a0 ver: 1 tfle: 0 rta: 1 rtaf: 0 rtf: 0 rtmbe: 0 rtbke: 0 rtbre: 0 rtbf: 0 rtb: 0 nt: 4 onoff: 0/0:0/0 -1,0:-1,0 0:0 (HZ=1000) barrier: 0/0:0
[ 5408.097164] rcu-torture: Reader Pipe:  8 0 0 0 0 0 0 0 0 0 0
[ 5408.097164] rcu-torture: Reader Batch:  8 0 0 0 0 0 0 0 0 0 0
[ 5408.097164] rcu-torture: Free-Block Circulation:  0 0 0 0 0 0 0 0 0 0 0
[ 5434.263412] SMP alternatives: lockdep: fixing up alternatives
[ 5434.266069] smpboot: Booting Node 0 Processor 1 APIC 0x1
[ 5334.045216] masked ExtINT on CPU#1
[ 5334.045216] numa_add_cpu cpu 1 node 0: mask now 0-1
[ 5434.302304] CPU0 attaching NULL sched-domain.
[ 5434.304579] CPU0 attaching sched-domain:
[ 5434.306522]  domain 0: span 0-1 level CPU
[ 5434.308767]   groups: 0 (cpu_power = 1023) 1
[ 5434.311676] CPU1 attaching sched-domain:
[ 5434.313610]  domain 0: span 0-1 level CPU
[ 5434.315722]   groups: 1 0 (cpu_power = 1023)
[ 5434.339462] CPU0 attaching NULL sched-domain.
[ 5434.341458] CPU1 attaching NULL sched-domain.
[ 5434.343530] CPU0 attaching NULL sched-domain.
[ 5434.345811] numa_remove_cpu cpu 1 node 0: mask now 0
[ 5434.350046] smpboot: CPU 1 is now offline
[ 5434.471628] SMP alternatives: lockdep: fixing up alternatives
[ 5434.477081] smpboot: Booting Node 0 Processor 1 APIC 0x1
[ 5434.346436] masked ExtINT on CPU#1
[ 5434.346436] numa_add_cpu cpu 1 node 0: mask now 0-1
[ 5434.514615] CPU0 attaching NULL sched-domain.
[ 5434.517183] CPU0 attaching sched-domain:
[ 5434.519336]  domain 0: span 0-1 level CPU
[ 5434.521605]   groups: 0 (cpu_power = 1023) 1
[ 5434.524447] CPU1 attaching sched-domain:
[ 5434.526387]  domain 0: span 0-1 level CPU
[ 5434.528665]   groups: 1 0 (cpu_power = 1023)
[ 5435.547960] CPU0 attaching NULL sched-domain.
[ 5435.550074] CPU1 attaching NULL sched-domain.
[ 5435.552306] CPU0 attaching NULL sched-domain.
[ 5435.554783] numa_remove_cpu cpu 1 node 0: mask now 0
[ 5435.559117] smpboot: CPU 1 is now offline
[ 5445.596947] SMP alternatives: lockdep: fixing up alternatives
[ 5445.610335] smpboot: Booting Node 0 Processor 1 APIC 0x1
[ 5435.555387] masked ExtINT on CPU#1
[ 5435.555387] numa_add_cpu cpu 1 node 0: mask now 0-1
[ 5445.671418] CPU0 attaching NULL sched-domain.
[ 5445.676823] CPU0 attaching sched-domain:
[ 5445.684382]  domain 0: span 0-1 level CPU
[ 5445.689135]   groups: 0 (cpu_power = 1022) 1
[ 5445.696087] CPU1 attaching sched-domain:
[ 5445.705347]  domain 0: span 0-1 level CPU
[ 5445.709300]   groups: 1 0 (cpu_power = 1022)
[ 5468.111324] rcu-torture: rtc: ffffffff82da41a0 ver: 1 tfle: 0 rta: 1 rtaf: 0 rtf: 0 rtmbe: 0 rtbke: 0 rtbre: 0 rtbf: 0 rtb: 0 nt: 4 onoff: 0/0:0/0 -1,0:-1,0 0:0 (HZ=1000) barrier: 0/0:0
[ 5468.111324] rcu-torture: Reader Pipe:  8 0 0 0 0 0 0 0 0 0 0
[ 5468.111324] rcu-torture: Reader Batch:  8 0 0 0 0 0 0 0 0 0 0
[ 5468.111324] rcu-torture: Free-Block Circulation:  0 0 0 0 0 0 0 0 0 0 0
[ 5528.131221] rcu-torture: rtc: ffffffff82da41a0 ver: 1 tfle: 0 rta: 1 rtaf: 0 rtf: 0 rtmbe: 0 rtbke: 0 rtbre: 0 rtbf: 0 rtb: 0 nt: 4 onoff: 0/0:0/0 -1,0:-1,0 0:0 (HZ=1000) barrier: 0/0:0
[ 5528.131221] rcu-torture: Reader Pipe:  8 0 0 0 0 0 0 0 0 0 0
[ 5528.131221] rcu-torture: Reader Batch:  8 0 0 0 0 0 0 0 0 0 0
[ 5528.131221] rcu-torture: Free-Block Circulation:  0 0 0 0 0 0 0 0 0 0 0
[ 5545.764521] CPU0 attaching NULL sched-domain.
[ 5545.767416] CPU1 attaching NULL sched-domain.
[ 5545.770819] CPU0 attaching NULL sched-domain.
[ 5545.774774] numa_remove_cpu cpu 1 node 0: mask now 0
[ 5545.780659] smpboot: CPU 1 is now offline
[ 5545.822180] SMP alternatives: lockdep: fixing up alternatives
[ 5545.825759] smpboot: Booting Node 0 Processor 1 APIC 0x1
[ 5545.775661] masked ExtINT on CPU#1
[ 5545.775661] numa_add_cpu cpu 1 node 0: mask now 0-1
[ 5545.869714] CPU0 attaching NULL sched-domain.
[ 5545.872411] CPU0 attaching sched-domain:
[ 5545.874916]  domain 0: span 0-1 level CPU
[ 5545.877298]   groups: 0 (cpu_power = 1019) 1
[ 5545.880321] CPU1 attaching sched-domain:
[ 5545.882504]  domain 0: span 0-1 level CPU
[ 5545.884922]   groups: 1 0 (cpu_power = 1019)
[ 5546.005140] CPU0 attaching NULL sched-domain.
[ 5546.008667] CPU1 attaching NULL sched-domain.
[ 5546.013257] CPU0 attaching NULL sched-domain.
[ 5546.016398] numa_remove_cpu cpu 1 node 0: mask now 0
[ 5546.021472] smpboot: CPU 1 is now offline
[ 5547.057609] SMP alternatives: lockdep: fixing up alternatives
[ 5547.063120] smpboot: Booting Node 0 Processor 1 APIC 0x1
[ 5546.017316] masked ExtINT on CPU#1
[ 5546.017316] numa_add_cpu cpu 1 node 0: mask now 0-1
[ 5547.103245] CPU0 attaching NULL sched-domain.
[ 5547.106526] CPU0 attaching sched-domain:
[ 5547.109241]  domain 0: span 0-1 level CPU
[ 5547.111960]   groups: 0 (cpu_power = 1022) 1
[ 5547.116355] CPU1 attaching sched-domain:
[ 5547.119093]  domain 0: span 0-1 level CPU
[ 5547.122559]   groups: 1 0 (cpu_power = 1022)
[ 5557.169966] CPU0 attaching NULL sched-domain.
[ 5557.174780] CPU1 attaching NULL sched-domain.
[ 5557.184150] CPU0 attaching NULL sched-domain.
[ 5557.189370] numa_remove_cpu cpu 1 node 0: mask now 0
[ 5557.201684] smpboot: CPU 1 is now offline
[ 5588.154239] rcu-torture: rtc: ffffffff82da41a0 ver: 1 tfle: 0 rta: 1 rtaf: 0 rtf: 0 rtmbe: 0 rtbke: 0 rtbre: 0 rtbf: 0 rtb: 0 nt: 4 onoff: 0/0:0/0 -1,0:-1,0 0:0 (HZ=1000) barrier: 0/0:0
[ 5588.154239] rcu-torture: Reader Pipe:  8 0 0 0 0 0 0 0 0 0 0
[ 5588.154239] rcu-torture: Reader Batch:  8 0 0 0 0 0 0 0 0 0 0
[ 5588.154239] rcu-torture: Free-Block Circulation:  0 0 0 0 0 0 0 0 0 0 0
[ 5648.214188] rcu-torture: rtc: ffffffff82da41a0 ver: 1 tfle: 0 rta: 1 rtaf: 0 rtf: 0 rtmbe: 0 rtbke: 0 rtbre: 0 rtbf: 0 rtb: 0 nt: 4 onoff: 0/0:0/0 -1,0:-1,0 0:0 (HZ=1000) barrier: 0/0:0
[ 5648.214188] rcu-torture: Reader Pipe:  8 0 0 0 0 0 0 0 0 0 0
[ 5648.214188] rcu-torture: Reader Batch:  8 0 0 0 0 0 0 0 0 0 0
[ 5648.214188] rcu-torture: Free-Block Circulation:  0 0 0 0 0 0 0 0 0 0 0
[ 5657.274111] SMP alternatives: lockdep: fixing up alternatives
[ 5657.279746] smpboot: Booting Node 0 Processor 1 APIC 0x1
[ 5557.190250] masked ExtINT on CPU#1
[ 5557.190250] numa_add_cpu cpu 1 node 0: mask now 0-1
[ 5657.317263] CPU0 attaching NULL sched-domain.
[ 5657.319635] CPU0 attaching sched-domain:
[ 5657.321495]  domain 0: span 0-1 level CPU
[ 5657.323513]   groups: 0 (cpu_power = 1023) 1
[ 5657.326196] CPU1 attaching sched-domain:
[ 5657.327963]  domain 0: span 0-1 level CPU
[ 5657.329895]   groups: 1 0 (cpu_power = 1023)
[ 5657.354849] CPU0 attaching NULL sched-domain.
[ 5657.356893] CPU1 attaching NULL sched-domain.
[ 5657.359774] CPU0 attaching NULL sched-domain.
[ 5657.362909] numa_remove_cpu cpu 1 node 0: mask now 0
[ 5657.368284] smpboot: CPU 1 is now offline
[ 5657.496165] SMP alternatives: lockdep: fixing up alternatives
[ 5657.503489] smpboot: Booting Node 0 Processor 1 APIC 0x1
[ 5657.363780] masked ExtINT on CPU#1
[ 5657.363780] numa_add_cpu cpu 1 node 0: mask now 0-1
[ 5657.540245] CPU0 attaching NULL sched-domain.
[ 5657.542426] CPU0 attaching sched-domain:
[ 5657.544400]  domain 0: span 0-1 level CPU
[ 5657.546289]   groups: 0 (cpu_power = 1023) 1
[ 5657.548710] CPU1 attaching sched-domain:
[ 5657.550481]  domain 0: span 0-1 level CPU
[ 5657.552414]   groups: 1 0 (cpu_power = 1023)
[ 5658.576585] CPU0 attaching NULL sched-domain.
[ 5658.579848] CPU1 attaching NULL sched-domain.
[ 5658.583290] CPU0 attaching NULL sched-domain.
[ 5658.587413] numa_remove_cpu cpu 1 node 0: mask now 0
[ 5658.593400] smpboot: CPU 1 is now offline
[ 5668.629610] SMP alternatives: lockdep: fixing up alternatives
[ 5668.637075] smpboot: Booting Node 0 Processor 1 APIC 0x1
[ 5658.588019] masked ExtINT on CPU#1
[ 5658.588019] numa_add_cpu cpu 1 node 0: mask now 0-1
[ 5668.693237] CPU0 attaching NULL sched-domain.
[ 5668.696321] CPU0 attaching sched-domain:
[ 5668.698647]  domain 0: span 0-1 level CPU
[ 5668.701271]   groups: 0 (cpu_power = 1023) 1
[ 5668.704592] CPU1 attaching sched-domain:
[ 5668.706902]  domain 0: span 0-1 level CPU
[ 5668.709627]   groups: 1 0 (cpu_power = 1023)
[ 5708.236187] rcu-torture: rtc: ffffffff82da41a0 ver: 1 tfle: 0 rta: 1 rtaf: 0 rtf: 0 rtmbe: 0 rtbke: 0 rtbre: 0 rtbf: 0 rtb: 0 nt: 4 onoff: 0/0:0/0 -1,0:-1,0 0:0 (HZ=1000) barrier: 0/0:0
[ 5708.236187] rcu-torture: Reader Pipe:  8 0 0 0 0 0 0 0 0 0 0
[ 5708.236187] rcu-torture: Reader Batch:  8 0 0 0 0 0 0 0 0 0 0
[ 5708.236187] rcu-torture: Free-Block Circulation:  0 0 0 0 0 0 0 0 0 0 0
[ 5768.258324] rcu-torture: rtc: ffffffff82da41a0 ver: 1 tfle: 0 rta: 1 rtaf: 0 rtf: 0 rtmbe: 0 rtbke: 0 rtbre: 0 rtbf: 0 rtb: 0 nt: 4 onoff: 0/0:0/0 -1,0:-1,0 0:0 (HZ=1000) barrier: 0/0:0
[ 5768.258324] rcu-torture: Reader Pipe:  8 0 0 0 0 0 0 0 0 0 0
[ 5768.258324] rcu-torture: Reader Batch:  8 0 0 0 0 0 0 0 0 0 0
[ 5768.258324] rcu-torture: Free-Block Circulation:  0 0 0 0 0 0 0 0 0 0 0
[ 5768.734083] CPU0 attaching NULL sched-domain.
[ 5768.736461] CPU1 attaching NULL sched-domain.
[ 5768.739252] CPU0 attaching NULL sched-domain.
[ 5768.764204] numa_remove_cpu cpu 1 node 0: mask now 0
[ 5768.769740] smpboot: CPU 1 is now offline
[ 5768.812398] SMP alternatives: lockdep: fixing up alternatives
[ 5768.818091] smpboot: Booting Node 0 Processor 1 APIC 0x1
[ 5768.765023] masked ExtINT on CPU#1
[ 5768.765023] numa_add_cpu cpu 1 node 0: mask now 0-1
[ 5768.883437] CPU0 attaching NULL sched-domain.
[ 5768.887423] CPU0 attaching sched-domain:
[ 5768.890355]  domain 0: span 0-1 level CPU
[ 5768.893402]   groups: 0 (cpu_power = 1022) 1
[ 5768.897786] CPU1 attaching sched-domain:
[ 5768.969215]  domain 0: span 0-1 level CPU
[ 5768.972391]   groups: 1 0 (cpu_power = 1022)
[ 5769.170174] CPU0 attaching NULL sched-domain.
[ 5769.173598] CPU1 attaching NULL sched-domain.
[ 5769.180337] CPU0 attaching NULL sched-domain.
[ 5769.201727] numa_remove_cpu cpu 1 node 0: mask now 0
[ 5769.209263] smpboot: CPU 1 is now offline
[ 5770.298471] SMP alternatives: lockdep: fixing up alternatives
[ 5770.320109] smpboot: Booting Node 0 Processor 1 APIC 0x1
[ 5769.202609] masked ExtINT on CPU#1
[ 5769.202609] numa_add_cpu cpu 1 node 0: mask now 0-1
[ 5770.378621] CPU0 attaching NULL sched-domain.
[ 5770.383494] CPU0 attaching sched-domain:
[ 5770.391214]  domain 0: span 0-1 level CPU
[ 5770.403494]   groups: 0 (cpu_power = 1022) 1
[ 5770.410180] CPU1 attaching sched-domain:
[ 5770.418174]  domain 0: span 0-1 level CPU
[ 5770.443144]   groups: 1 0 (cpu_power = 1022)
[ 5780.485707] CPU0 attaching NULL sched-domain.
[ 5780.489209] CPU1 attaching NULL sched-domain.
[ 5780.492728] CPU0 attaching NULL sched-domain.
[ 5780.496675] numa_remove_cpu cpu 1 node 0: mask now 0
[ 5780.501652] smpboot: CPU 1 is now offline
[ 5828.301184] rcu-torture: rtc: ffffffff82da41a0 ver: 1 tfle: 0 rta: 1 rtaf: 0 rtf: 0 rtmbe: 0 rtbke: 0 rtbre: 0 rtbf: 0 rtb: 0 nt: 4 onoff: 0/0:0/0 -1,0:-1,0 0:0 (HZ=1000) barrier: 0/0:0
[ 5828.301184] rcu-torture: Reader Pipe:  8 0 0 0 0 0 0 0 0 0 0
[ 5828.301184] rcu-torture: Reader Batch:  8 0 0 0 0 0 0 0 0 0 0
[ 5828.301184] rcu-torture: Free-Block Circulation:  0 0 0 0 0 0 0 0 0 0 0
[ 5880.546793] SMP alternatives: lockdep: fixing up alternatives
[ 5880.549287] smpboot: Booting Node 0 Processor 1 APIC 0x1
[ 5780.497598] masked ExtINT on CPU#1
[ 5780.497598] numa_add_cpu cpu 1 node 0: mask now 0-1
[ 5880.585128] CPU0 attaching NULL sched-domain.
[ 5880.587377] CPU0 attaching sched-domain:
[ 5880.589310]  domain 0: span 0-1 level CPU
[ 5880.591413]   groups: 0 (cpu_power = 1023) 1
[ 5880.594108] CPU1 attaching sched-domain:
[ 5880.596021]  domain 0: span 0-1 level CPU
[ 5880.598091]   groups: 1 0 (cpu_power = 1023)
[ 5880.618711] CPU0 attaching NULL sched-domain.
[ 5880.621111] CPU1 attaching NULL sched-domain.
[ 5880.623276] CPU0 attaching NULL sched-domain.
[ 5880.625700] numa_remove_cpu cpu 1 node 0: mask now 0
[ 5880.629958] smpboot: CPU 1 is now offline
[ 5880.756241] SMP alternatives: lockdep: fixing up alternatives
[ 5880.758718] smpboot: Booting Node 0 Processor 1 APIC 0x1
[ 5880.626639] masked ExtINT on CPU#1
[ 5880.626639] numa_add_cpu cpu 1 node 0: mask now 0-1
[ 5880.798496] CPU0 attaching NULL sched-domain.
[ 5880.800741] CPU0 attaching sched-domain:
[ 5880.802648]  domain 0: span 0-1 level CPU
[ 5880.804756]   groups: 0 (cpu_power = 1023) 1
[ 5880.807466] CPU1 attaching sched-domain:
[ 5880.809376]  domain 0: span 0-1 level CPU
[ 5880.811491]   groups: 1 0 (cpu_power = 1023)
[ 5881.826802] CPU0 attaching NULL sched-domain.
[ 5881.828560] CPU1 attaching NULL sched-domain.
[ 5881.830404] CPU0 attaching NULL sched-domain.
[ 5881.832517] numa_remove_cpu cpu 1 node 0: mask now 0
[ 5881.836733] smpboot: CPU 1 is now offline
[ 5888.312095] rcu-torture: rtc: ffffffff82da41a0 ver: 1 tfle: 0 rta: 1 rtaf: 0 rtf: 0 rtmbe: 0 rtbke: 0 rtbre: 0 rtbf: 0 rtb: 0 nt: 4 onoff: 0/0:0/0 -1,0:-1,0 0:0 (HZ=1000) barrier: 0/0:0
[ 5888.312095] rcu-torture: Reader Pipe:  8 0 0 0 0 0 0 0 0 0 0
[ 5888.312095] rcu-torture: Reader Batch:  8 0 0 0 0 0 0 0 0 0 0
[ 5888.312095] rcu-torture: Free-Block Circulation:  0 0 0 0 0 0 0 0 0 0 0
[ 5891.867300] SMP alternatives: lockdep: fixing up alternatives
[ 5891.873220] smpboot: Booting Node 0 Processor 1 APIC 0x1
[ 5881.833042] masked ExtINT on CPU#1
[ 5881.833042] numa_add_cpu cpu 1 node 0: mask now 0-1
[ 5891.908983] CPU0 attaching NULL sched-domain.
[ 5891.911378] CPU0 attaching sched-domain:
[ 5891.913238]  domain 0: span 0-1 level CPU
[ 5891.915277]   groups: 0 (cpu_power = 1023) 1
[ 5891.917889] CPU1 attaching sched-domain:
[ 5891.919758]  domain 0: span 0-1 level CPU
[ 5891.921830]   groups: 1 0 (cpu_power = 1023)
[ 5948.326112] rcu-torture: rtc: ffffffff82da41a0 ver: 1 tfle: 0 rta: 1 rtaf: 0 rtf: 0 rtmbe: 0 rtbke: 0 rtbre: 0 rtbf: 0 rtb: 0 nt: 4 onoff: 0/0:0/0 -1,0:-1,0 0:0 (HZ=1000) barrier: 0/0:0
[ 5948.326112] rcu-torture: Reader Pipe:  8 0 0 0 0 0 0 0 0 0 0
[ 5948.326112] rcu-torture: Reader Batch:  8 0 0 0 0 0 0 0 0 0 0
[ 5948.326112] rcu-torture: Free-Block Circulation:  0 0 0 0 0 0 0 0 0 0 0
[ 5991.941299] CPU0 attaching NULL sched-domain.
[ 5991.943284] CPU1 attaching NULL sched-domain.
[ 5991.945314] CPU0 attaching NULL sched-domain.
[ 5991.947548] numa_remove_cpu cpu 1 node 0: mask now 0
[ 5991.952105] smpboot: CPU 1 is now offline
[ 5991.986333] SMP alternatives: lockdep: fixing up alternatives
[ 5991.988275] smpboot: Booting Node 0 Processor 1 APIC 0x1
[ 5991.948182] masked ExtINT on CPU#1
[ 5991.948182] numa_add_cpu cpu 1 node 0: mask now 0-1
[ 5992.024917] CPU0 attaching NULL sched-domain.
[ 5992.027402] CPU0 attaching sched-domain:
[ 5992.029232]  domain 0: span 0-1 level CPU
[ 5992.030916]   groups: 0 (cpu_power = 1023) 1
[ 5992.033090] CPU1 attaching sched-domain:
[ 5992.034578]  domain 0: span 0-1 level CPU
[ 5992.036269]   groups: 1 0 (cpu_power = 1023)
[ 5992.148167] CPU0 attaching NULL sched-domain.
[ 5992.150110] CPU1 attaching NULL sched-domain.
[ 5992.152158] CPU0 attaching NULL sched-domain.
[ 5992.154451] numa_remove_cpu cpu 1 node 0: mask now 0
[ 5992.158924] smpboot: CPU 1 is now offline
[ 5993.176370] SMP alternatives: lockdep: fixing up alternatives
[ 5993.178441] smpboot: Booting Node 0 Processor 1 APIC 0x1
[ 5992.155014] masked ExtINT on CPU#1
[ 5992.155014] numa_add_cpu cpu 1 node 0: mask now 0-1
[ 5993.217385] CPU0 attaching NULL sched-domain.
[ 5993.219273] CPU0 attaching sched-domain:
[ 5993.220840]  domain 0: span 0-1 level CPU
[ 5993.222577]   groups: 0 (cpu_power = 1023) 1
[ 5993.224780] CPU1 attaching sched-domain:
[ 5993.226347]  domain 0: span 0-1 level CPU
[ 5993.228055]   groups: 1 0 (cpu_power = 1023)
[ 6003.246428] CPU0 attaching NULL sched-domain.
[ 6003.248423] CPU1 attaching NULL sched-domain.
[ 6003.250516] CPU0 attaching NULL sched-domain.
[ 6003.252846] numa_remove_cpu cpu 1 node 0: mask now 0
[ 6003.257338] smpboot: CPU 1 is now offline
[ 6008.339174] rcu-torture: rtc: ffffffff82da41a0 ver: 1 tfle: 0 rta: 1 rtaf: 0 rtf: 0 rtmbe: 0 rtbke: 0 rtbre: 0 rtbf: 0 rtb: 0 nt: 4 onoff: 0/0:0/0 -1,0:-1,0 0:0 (HZ=1000) barrier: 0/0:0
[ 6008.339174] rcu-torture: Reader Pipe:  8 0 0 0 0 0 0 0 0 0 0
[ 6008.339174] rcu-torture: Reader Batch:  8 0 0 0 0 0 0 0 0 0 0
[ 6008.339174] rcu-torture: Free-Block Circulation:  0 0 0 0 0 0 0 0 0 0 0
[ 6068.380102] rcu-torture: rtc: ffffffff82da41a0 ver: 1 tfle: 0 rta: 1 rtaf: 0 rtf: 0 rtmbe: 0 rtbke: 0 rtbre: 0 rtbf: 0 rtb: 0 nt: 4 onoff: 0/0:0/0 -1,0:-1,0 0:0 (HZ=1000) barrier: 0/0:0
[ 6068.380102] rcu-torture: Reader Pipe:  8 0 0 0 0 0 0 0 0 0 0
[ 6068.380102] rcu-torture: Reader Batch:  8 0 0 0 0 0 0 0 0 0 0
[ 6068.380102] rcu-torture: Free-Block Circulation:  0 0 0 0 0 0 0 0 0 0 0
[ 6103.286332] SMP alternatives: lockdep: fixing up alternatives
[ 6103.292243] smpboot: Booting Node 0 Processor 1 APIC 0x1
[ 6003.253442] masked ExtINT on CPU#1
[ 6003.253442] numa_add_cpu cpu 1 node 0: mask now 0-1
[ 6103.329245] CPU0 attaching NULL sched-domain.
[ 6103.331377] CPU0 attaching sched-domain:
[ 6103.333221]  domain 0: span 0-1 level CPU
[ 6103.335203]   groups: 0 (cpu_power = 1009) 1
[ 6103.337763] CPU1 attaching sched-domain:
[ 6103.339592]  domain 0: span 0-1 level CPU
[ 6103.341596]   groups: 1 0 (cpu_power = 1009)
[ 6103.367510] CPU0 attaching NULL sched-domain.
[ 6103.370519] CPU1 attaching NULL sched-domain.
[ 6103.373723] CPU0 attaching NULL sched-domain.
[ 6103.377322] numa_remove_cpu cpu 1 node 0: mask now 0
[ 6103.382312] smpboot: CPU 1 is now offline
[ 6103.507134] SMP alternatives: lockdep: fixing up alternatives
[ 6103.509455] smpboot: Booting Node 0 Processor 1 APIC 0x1
[ 6103.378023] masked ExtINT on CPU#1
[ 6103.378023] numa_add_cpu cpu 1 node 0: mask now 0-1
[ 6103.546567] CPU0 attaching NULL sched-domain.
[ 6103.548848] CPU0 attaching sched-domain:
[ 6103.550719]  domain 0: span 0-1 level CPU
[ 6103.552795]   groups: 0 (cpu_power = 1013) 1
[ 6103.555409] CPU1 attaching sched-domain:
[ 6103.557245]  domain 0: span 0-1 level CPU
[ 6103.559272]   groups: 1 0 (cpu_power = 1013)
[ 6104.578112] CPU0 attaching NULL sched-domain.
[ 6104.580088] CPU1 attaching NULL sched-domain.
[ 6104.582125] CPU0 attaching NULL sched-domain.
[ 6104.584390] numa_remove_cpu cpu 1 node 0: mask now 0
[ 6104.588611] smpboot: CPU 1 is now offline
[ 6114.616697] SMP alternatives: lockdep: fixing up alternatives
[ 6114.622089] smpboot: Booting Node 0 Processor 1 APIC 0x1
[ 6104.585016] masked ExtINT on CPU#1
[ 6104.585016] numa_add_cpu cpu 1 node 0: mask now 0-1
[ 6114.659760] CPU0 attaching NULL sched-domain.
[ 6114.662186] CPU0 attaching sched-domain:
[ 6114.664211]  domain 0: span 0-1 level CPU
[ 6114.666249]   groups: 0 (cpu_power = 1023) 1
[ 6114.668848] CPU1 attaching sched-domain:
[ 6114.670736]  domain 0: span 0-1 level CPU
[ 6114.672792]   groups: 1 0 (cpu_power = 1023)
[ 6128.392100] rcu-torture: rtc: ffffffff82da41a0 ver: 1 tfle: 0 rta: 1 rtaf: 0 rtf: 0 rtmbe: 0 rtbke: 0 rtbre: 0 rtbf: 0 rtb: 0 nt: 4 onoff: 0/0:0/0 -1,0:-1,0 0:0 (HZ=1000) barrier: 0/0:0
[ 6128.392100] rcu-torture: Reader Pipe:  8 0 0 0 0 0 0 0 0 0 0
[ 6128.392100] rcu-torture: Reader Batch:  8 0 0 0 0 0 0 0 0 0 0
[ 6128.392100] rcu-torture: Free-Block Circulation:  0 0 0 0 0 0 0 0 0 0 0
[ 6188.418089] rcu-torture: rtc: ffffffff82da41a0 ver: 1 tfle: 0 rta: 1 rtaf: 0 rtf: 0 rtmbe: 0 rtbke: 0 rtbre: 0 rtbf: 0 rtb: 0 nt: 4 onoff: 0/0:0/0 -1,0:-1,0 0:0 (HZ=1000) barrier: 0/0:0
[ 6188.418089] rcu-torture: Reader Pipe:  8 0 0 0 0 0 0 0 0 0 0
[ 6188.418089] rcu-torture: Reader Batch:  8 0 0 0 0 0 0 0 0 0 0
[ 6188.418089] rcu-torture: Free-Block Circulation:  0 0 0 0 0 0 0 0 0 0 0
[ 6214.692064] CPU0 attaching NULL sched-domain.
[ 6214.693970] CPU1 attaching NULL sched-domain.
[ 6214.695964] CPU0 attaching NULL sched-domain.
[ 6214.698173] numa_remove_cpu cpu 1 node 0: mask now 0
[ 6214.702420] smpboot: CPU 1 is now offline
[ 6214.734352] SMP alternatives: lockdep: fixing up alternatives
[ 6214.736664] smpboot: Booting Node 0 Processor 1 APIC 0x1
[ 6214.699015] masked ExtINT on CPU#1
[ 6214.699015] numa_add_cpu cpu 1 node 0: mask now 0-1
[ 6214.776147] CPU0 attaching NULL sched-domain.
[ 6214.778307] CPU0 attaching sched-domain:
[ 6214.780229]  domain 0: span 0-1 level CPU
[ 6214.782250]   groups: 0 (cpu_power = 1023) 1
[ 6214.784848] CPU1 attaching sched-domain:
[ 6214.786701]  domain 0: span 0-1 level CPU
[ 6214.788735]   groups: 1 0 (cpu_power = 1023)
[ 6214.907392] CPU0 attaching NULL sched-domain.
[ 6214.909318] CPU1 attaching NULL sched-domain.
[ 6214.911334] CPU0 attaching NULL sched-domain.
[ 6214.913556] numa_remove_cpu cpu 1 node 0: mask now 0
[ 6214.917717] smpboot: CPU 1 is now offline
[ 6215.944143] SMP alternatives: lockdep: fixing up alternatives
[ 6215.949076] smpboot: Booting Node 0 Processor 1 APIC 0x1
[ 6214.914186] masked ExtINT on CPU#1
[ 6214.914186] numa_add_cpu cpu 1 node 0: mask now 0-1
[ 6215.986304] CPU0 attaching NULL sched-domain.
[ 6215.988607] CPU0 attaching sched-domain:
[ 6215.990495]  domain 0: span 0-1 level CPU
[ 6215.992529]   groups: 0 (cpu_power = 1023) 1
[ 6215.995164] CPU1 attaching sched-domain:
[ 6215.997024]  domain 0: span 0-1 level CPU
[ 6215.999034]   groups: 1 0 (cpu_power = 1023)
[ 6226.019107] CPU0 attaching NULL sched-domain.
[ 6226.021074] CPU1 attaching NULL sched-domain.
[ 6226.023107] CPU0 attaching NULL sched-domain.
[ 6226.025364] numa_remove_cpu cpu 1 node 0: mask now 0
[ 6226.029564] smpboot: CPU 1 is now offline
[ 6248.430143] rcu-torture: rtc: ffffffff82da41a0 ver: 1 tfle: 0 rta: 1 rtaf: 0 rtf: 0 rtmbe: 0 rtbke: 0 rtbre: 0 rtbf: 0 rtb: 0 nt: 4 onoff: 0/0:0/0 -1,0:-1,0 0:0 (HZ=1000) barrier: 0/0:0
[ 6248.430143] rcu-torture: Reader Pipe:  8 0 0 0 0 0 0 0 0 0 0
[ 6248.430143] rcu-torture: Reader Batch:  8 0 0 0 0 0 0 0 0 0 0
[ 6248.430143] rcu-torture: Free-Block Circulation:  0 0 0 0 0 0 0 0 0 0 0
[ 6308.448092] rcu-torture: rtc: ffffffff82da41a0 ver: 1 tfle: 0 rta: 1 rtaf: 0 rtf: 0 rtmbe: 0 rtbke: 0 rtbre: 0 rtbf: 0 rtb: 0 nt: 4 onoff: 0/0:0/0 -1,0:-1,0 0:0 (HZ=1000) barrier: 0/0:0
[ 6308.448092] rcu-torture: Reader Pipe:  8 0 0 0 0 0 0 0 0 0 0
[ 6308.448092] rcu-torture: Reader Batch:  8 0 0 0 0 0 0 0 0 0 0
[ 6308.448092] rcu-torture: Free-Block Circulation:  0 0 0 0 0 0 0 0 0 0 0
[ 6326.060701] SMP alternatives: lockdep: fixing up alternatives
[ 6326.066286] smpboot: Booting Node 0 Processor 1 APIC 0x1
[ 6226.026016] masked ExtINT on CPU#1
[ 6226.026016] numa_add_cpu cpu 1 node 0: mask now 0-1
[ 6326.102112] CPU0 attaching NULL sched-domain.
[ 6326.104266] CPU0 attaching sched-domain:
[ 6326.106109]  domain 0: span 0-1 level CPU
[ 6326.108157]   groups: 0 (cpu_power = 1023) 1
[ 6326.110753] CPU1 attaching sched-domain:
[ 6326.112609]  domain 0: span 0-1 level CPU
[ 6326.114645]   groups: 1 0 (cpu_power = 1023)
[ 6326.133300] CPU0 attaching NULL sched-domain.
[ 6326.135380] CPU1 attaching NULL sched-domain.
[ 6326.137757] CPU0 attaching NULL sched-domain.
[ 6326.140240] numa_remove_cpu cpu 1 node 0: mask now 0
[ 6326.144428] smpboot: CPU 1 is now offline
[ 6326.270123] SMP alternatives: lockdep: fixing up alternatives
[ 6326.272518] smpboot: Booting Node 0 Processor 1 APIC 0x1
[ 6326.141175] masked ExtINT on CPU#1
[ 6326.141175] numa_add_cpu cpu 1 node 0: mask now 0-1
[ 6326.312197] CPU0 attaching NULL sched-domain.
[ 6326.314369] CPU0 attaching sched-domain:
[ 6326.316231]  domain 0: span 0-1 level CPU
[ 6326.318278]   groups: 0 (cpu_power = 1023) 1
[ 6326.320889] CPU1 attaching sched-domain:
[ 6326.322717]  domain 0: span 0-1 level CPU
[ 6326.324767]   groups: 1 0 (cpu_power = 1023)
[ 6327.342922] CPU0 attaching NULL sched-domain.
[ 6327.344862] CPU1 attaching NULL sched-domain.
[ 6327.346904] CPU0 attaching NULL sched-domain.
[ 6327.349219] numa_remove_cpu cpu 1 node 0: mask now 0
[ 6327.353417] smpboot: CPU 1 is now offline
[ 6337.380300] SMP alternatives: lockdep: fixing up alternatives
[ 6337.385113] smpboot: Booting Node 0 Processor 1 APIC 0x1
[ 6327.350021] masked ExtINT on CPU#1
[ 6327.350021] numa_add_cpu cpu 1 node 0: mask now 0-1
[ 6337.423187] CPU0 attaching NULL sched-domain.
[ 6337.425397] CPU0 attaching sched-domain:
[ 6337.427480]  domain 0: span 0-1 level CPU
[ 6337.429584]   groups: 0 (cpu_power = 1023) 1
[ 6337.432231] CPU1 attaching sched-domain:
[ 6337.434087]  domain 0: span 0-1 level CPU
[ 6337.436099]   groups: 1 0 (cpu_power = 1023)
[ 6368.460183] rcu-torture: rtc: ffffffff82da41a0 ver: 1 tfle: 0 rta: 1 rtaf: 0 rtf: 0 rtmbe: 0 rtbke: 0 rtbre: 0 rtbf: 0 rtb: 0 nt: 4 onoff: 0/0:0/0 -1,0:-1,0 0:0 (HZ=1000) barrier: 0/0:0
[ 6368.460183] rcu-torture: Reader Pipe:  8 0 0 0 0 0 0 0 0 0 0
[ 6368.460183] rcu-torture: Reader Batch:  8 0 0 0 0 0 0 0 0 0 0
[ 6368.460183] rcu-torture: Free-Block Circulation:  0 0 0 0 0 0 0 0 0 0 0
[ 6428.472151] rcu-torture: rtc: ffffffff82da41a0 ver: 1 tfle: 0 rta: 1 rtaf: 0 rtf: 0 rtmbe: 0 rtbke: 0 rtbre: 0 rtbf: 0 rtb: 0 nt: 4 onoff: 0/0:0/0 -1,0:-1,0 0:0 (HZ=1000) barrier: 0/0:0
[ 6428.472151] rcu-torture: Reader Pipe:  8 0 0 0 0 0 0 0 0 0 0
[ 6428.472151] rcu-torture: Reader Batch:  8 0 0 0 0 0 0 0 0 0 0
[ 6428.472151] rcu-torture: Free-Block Circulation:  0 0 0 0 0 0 0 0 0 0 0
[ 6437.455815] CPU0 attaching NULL sched-domain.
[ 6437.457751] CPU1 attaching NULL sched-domain.
[ 6437.459787] CPU0 attaching NULL sched-domain.
[ 6437.462038] numa_remove_cpu cpu 1 node 0: mask now 0
[ 6437.466191] smpboot: CPU 1 is now offline
[ 6437.498398] SMP alternatives: lockdep: fixing up alternatives
[ 6437.500701] smpboot: Booting Node 0 Processor 1 APIC 0x1
[ 6437.462624] masked ExtINT on CPU#1
[ 6437.462624] numa_add_cpu cpu 1 node 0: mask now 0-1
[ 6437.542515] CPU0 attaching NULL sched-domain.
[ 6437.544687] CPU0 attaching sched-domain:
[ 6437.546889]  domain 0: span 0-1 level CPU
[ 6437.548976]   groups: 0 (cpu_power = 1023) 1
[ 6437.551569] CPU1 attaching sched-domain:
[ 6437.553390]  domain 0: span 0-1 level CPU
[ 6437.555413]   groups: 1 0 (cpu_power = 1023)
[ 6437.673500] CPU0 attaching NULL sched-domain.
[ 6437.675412] CPU1 attaching NULL sched-domain.
[ 6437.677405] CPU0 attaching NULL sched-domain.
[ 6437.679642] numa_remove_cpu cpu 1 node 0: mask now 0
[ 6437.683775] smpboot: CPU 1 is now offline
[ 6438.710891] SMP alternatives: lockdep: fixing up alternatives
[ 6438.716092] smpboot: Booting Node 0 Processor 1 APIC 0x1
[ 6437.680273] masked ExtINT on CPU#1
[ 6437.680273] numa_add_cpu cpu 1 node 0: mask now 0-1
[ 6438.752865] CPU0 attaching NULL sched-domain.
[ 6438.755241] CPU0 attaching sched-domain:
[ 6438.757206]  domain 0: span 0-1 level CPU
[ 6438.759233]   groups: 0 (cpu_power = 1023) 1
[ 6438.761789] CPU1 attaching sched-domain:
[ 6438.763612]  domain 0: span 0-1 level CPU
[ 6438.765640]   groups: 1 0 (cpu_power = 1023)
[ 6448.783330] CPU0 attaching NULL sched-domain.
[ 6448.785238] CPU1 attaching NULL sched-domain.
[ 6448.787207] CPU0 attaching NULL sched-domain.
[ 6448.789430] numa_remove_cpu cpu 1 node 0: mask now 0
[ 6448.793605] smpboot: CPU 1 is now offline
[ 6488.484150] rcu-torture: rtc: ffffffff82da41a0 ver: 1 tfle: 0 rta: 1 rtaf: 0 rtf: 0 rtmbe: 0 rtbke: 0 rtbre: 0 rtbf: 0 rtb: 0 nt: 4 onoff: 0/0:0/0 -1,0:-1,0 0:0 (HZ=1000) barrier: 0/0:0
[ 6488.484150] rcu-torture: Reader Pipe:  8 0 0 0 0 0 0 0 0 0 0
[ 6488.484150] rcu-torture: Reader Batch:  8 0 0 0 0 0 0 0 0 0 0
[ 6488.484150] rcu-torture: Free-Block Circulation:  0 0 0 0 0 0 0 0 0 0 0
[ 6548.497089] rcu-torture: rtc: ffffffff82da41a0 ver: 1 tfle: 0 rta: 1 rtaf: 0 rtf: 0 rtmbe: 0 rtbke: 0 rtbre: 0 rtbf: 0 rtb: 0 nt: 4 onoff: 0/0:0/0 -1,0:-1,0 0:0 (HZ=1000) barrier: 0/0:0
[ 6548.497089] rcu-torture: Reader Pipe:  8 0 0 0 0 0 0 0 0 0 0
[ 6548.497089] rcu-torture: Reader Batch:  8 0 0 0 0 0 0 0 0 0 0
[ 6548.497089] rcu-torture: Free-Block Circulation:  0 0 0 0 0 0 0 0 0 0 0
[ 6548.824270] SMP alternatives: lockdep: fixing up alternatives
[ 6548.830143] smpboot: Booting Node 0 Processor 1 APIC 0x1
[ 6448.790044] masked ExtINT on CPU#1
[ 6448.790044] numa_add_cpu cpu 1 node 0: mask now 0-1
[ 6548.865894] CPU0 attaching NULL sched-domain.
[ 6548.868326] CPU0 attaching sched-domain:
[ 6548.870211]  domain 0: span 0-1 level CPU
[ 6548.872273]   groups: 0 (cpu_power = 1023) 1
[ 6548.874868] CPU1 attaching sched-domain:
[ 6548.876747]  domain 0: span 0-1 level CPU
[ 6548.878797]   groups: 1 0 (cpu_power = 1023)
[ 6548.897479] CPU0 attaching NULL sched-domain.
[ 6548.899576] CPU1 attaching NULL sched-domain.
[ 6548.901724] CPU0 attaching NULL sched-domain.
[ 6548.904563] numa_remove_cpu cpu 1 node 0: mask now 0
[ 6548.908764] smpboot: CPU 1 is now offline
[ 6549.033867] SMP alternatives: lockdep: fixing up alternatives
[ 6549.039073] smpboot: Booting Node 0 Processor 1 APIC 0x1
[ 6548.905490] masked ExtINT on CPU#1
[ 6548.905490] numa_add_cpu cpu 1 node 0: mask now 0-1
[ 6549.076366] CPU0 attaching NULL sched-domain.
[ 6549.078560] CPU0 attaching sched-domain:
[ 6549.080534]  domain 0: span 0-1 level CPU
[ 6549.082619]   groups: 0 (cpu_power = 1004) 1
[ 6549.085207] CPU1 attaching sched-domain:
[ 6549.087021]  domain 0: span 0-1 level CPU
[ 6549.089019]   groups: 1 0 (cpu_power = 1004)
[ 6550.106480] CPU0 attaching NULL sched-domain.
[ 6550.108341] CPU1 attaching NULL sched-domain.
[ 6550.110341] CPU0 attaching NULL sched-domain.
[ 6550.112545] numa_remove_cpu cpu 1 node 0: mask now 0
[ 6550.116676] smpboot: CPU 1 is now offline
[ 6560.142467] SMP alternatives: lockdep: fixing up alternatives
[ 6560.144801] smpboot: Booting Node 0 Processor 1 APIC 0x1
[ 6550.113175] masked ExtINT on CPU#1
[ 6550.113175] numa_add_cpu cpu 1 node 0: mask now 0-1
[ 6560.184404] CPU0 attaching NULL sched-domain.
[ 6560.186581] CPU0 attaching sched-domain:
[ 6560.188416]  domain 0: span 0-1 level CPU
[ 6560.190459]   groups: 0 (cpu_power = 1023) 1
[ 6560.193095] CPU1 attaching sched-domain:
[ 6560.194920]  domain 0: span 0-1 level CPU
[ 6560.196950]   groups: 1 0 (cpu_power = 1023)
[ 6608.509195] rcu-torture: rtc: ffffffff82da41a0 ver: 1 tfle: 0 rta: 1 rtaf: 0 rtf: 0 rtmbe: 0 rtbke: 0 rtbre: 0 rtbf: 0 rtb: 0 nt: 4 onoff: 0/0:0/0 -1,0:-1,0 0:0 (HZ=1000) barrier: 0/0:0
[ 6608.509195] rcu-torture: Reader Pipe:  8 0 0 0 0 0 0 0 0 0 0
[ 6608.509195] rcu-torture: Reader Batch:  8 0 0 0 0 0 0 0 0 0 0
[ 6608.509195] rcu-torture: Free-Block Circulation:  0 0 0 0 0 0 0 0 0 0 0
[ 6660.215497] CPU0 attaching NULL sched-domain.
[ 6660.217567] CPU1 attaching NULL sched-domain.
[ 6660.219723] CPU0 attaching NULL sched-domain.
[ 6660.222153] numa_remove_cpu cpu 1 node 0: mask now 0
[ 6660.226488] smpboot: CPU 1 is now offline
[ 6660.265394] SMP alternatives: lockdep: fixing up alternatives
[ 6660.267709] smpboot: Booting Node 0 Processor 1 APIC 0x1
[ 6660.223068] masked ExtINT on CPU#1
[ 6660.223068] numa_add_cpu cpu 1 node 0: mask now 0-1
[ 6660.310676] CPU0 attaching NULL sched-domain.
[ 6660.314114] CPU0 attaching sched-domain:
[ 6660.316049]  domain 0: span 0-1 level CPU
[ 6660.318153]   groups: 0 (cpu_power = 1023) 1
[ 6660.320786] CPU1 attaching sched-domain:
[ 6660.322658]  domain 0: span 0-1 level CPU
[ 6660.324714]   groups: 1 0 (cpu_power = 1023)
[ 6660.443514] CPU0 attaching NULL sched-domain.
[ 6660.445430] CPU1 attaching NULL sched-domain.
[ 6660.447445] CPU0 attaching NULL sched-domain.
[ 6660.449703] numa_remove_cpu cpu 1 node 0: mask now 0
[ 6660.453905] smpboot: CPU 1 is now offline
[ 6661.480359] SMP alternatives: lockdep: fixing up alternatives
[ 6661.482866] smpboot: Booting Node 0 Processor 1 APIC 0x1
[ 6660.450318] masked ExtINT on CPU#1
[ 6660.450318] numa_add_cpu cpu 1 node 0: mask now 0-1
[ 6661.523068] CPU0 attaching NULL sched-domain.
[ 6661.525342] CPU0 attaching sched-domain:
[ 6661.527565]  domain 0: span 0-1 level CPU
[ 6661.529785]   groups: 0 (cpu_power = 1023) 1
[ 6661.532496] CPU1 attaching sched-domain:
[ 6661.534407]  domain 0: span 0-1 level CPU
[ 6661.536513]   groups: 1 0 (cpu_power = 1023)
[ 6668.538148] rcu-torture: rtc: ffffffff82da41a0 ver: 1 tfle: 0 rta: 1 rtaf: 0 rtf: 0 rtmbe: 0 rtbke: 0 rtbre: 0 rtbf: 0 rtb: 0 nt: 4 onoff: 0/0:0/0 -1,0:-1,0 0:0 (HZ=1000) barrier: 0/0:0
[ 6668.538148] rcu-torture: Reader Pipe:  8 0 0 0 0 0 0 0 0 0 0
[ 6668.538148] rcu-torture: Reader Batch:  8 0 0 0 0 0 0 0 0 0 0
[ 6668.538148] rcu-torture: Free-Block Circulation:  0 0 0 0 0 0 0 0 0 0 0
[ 6671.556122] CPU0 attaching NULL sched-domain.
[ 6671.558053] CPU1 attaching NULL sched-domain.
[ 6671.560121] CPU0 attaching NULL sched-domain.
[ 6671.562396] numa_remove_cpu cpu 1 node 0: mask now 0
[ 6671.566603] smpboot: CPU 1 is now offline
[ 6728.550099] rcu-torture: rtc: ffffffff82da41a0 ver: 1 tfle: 0 rta: 1 rtaf: 0 rtf: 0 rtmbe: 0 rtbke: 0 rtbre: 0 rtbf: 0 rtb: 0 nt: 4 onoff: 0/0:0/0 -1,0:-1,0 0:0 (HZ=1000) barrier: 0/0:0
[ 6728.550099] rcu-torture: Reader Pipe:  8 0 0 0 0 0 0 0 0 0 0
[ 6728.550099] rcu-torture: Reader Batch:  8 0 0 0 0 0 0 0 0 0 0
[ 6728.550099] rcu-torture: Free-Block Circulation:  0 0 0 0 0 0 0 0 0 0 0
[ 6771.598693] SMP alternatives: lockdep: fixing up alternatives
[ 6771.604394] smpboot: Booting Node 0 Processor 1 APIC 0x1
[ 6671.563014] masked ExtINT on CPU#1
[ 6671.563014] numa_add_cpu cpu 1 node 0: mask now 0-1
[ 6771.640196] CPU0 attaching NULL sched-domain.
[ 6771.642332] CPU0 attaching sched-domain:
[ 6771.644156]  domain 0: span 0-1 level CPU
[ 6771.646148]   groups: 0 (cpu_power = 1023) 1
[ 6771.648715] CPU1 attaching sched-domain:
[ 6771.650565]  domain 0: span 0-1 level CPU
[ 6771.652573]   groups: 1 0 (cpu_power = 1023)
[ 6771.673300] CPU0 attaching NULL sched-domain.
[ 6771.675434] CPU1 attaching NULL sched-domain.
[ 6771.677412] CPU0 attaching NULL sched-domain.
[ 6771.679613] numa_remove_cpu cpu 1 node 0: mask now 0
[ 6771.683786] smpboot: CPU 1 is now offline
[ 6771.814113] SMP alternatives: lockdep: fixing up alternatives
[ 6771.816376] smpboot: Booting Node 0 Processor 1 APIC 0x1
[ 6771.680243] masked ExtINT on CPU#1
[ 6771.680243] numa_add_cpu cpu 1 node 0: mask now 0-1
[ 6771.853517] CPU0 attaching NULL sched-domain.
[ 6771.855789] CPU0 attaching sched-domain:
[ 6771.857635]  domain 0: span 0-1 level CPU
[ 6771.859679]   groups: 0 (cpu_power = 1023) 1
[ 6771.862289] CPU1 attaching sched-domain:
[ 6771.864090]  domain 0: span 0-1 level CPU
[ 6771.866073]   groups: 1 0 (cpu_power = 1023)
[ 6772.885435] CPU0 attaching NULL sched-domain.
[ 6772.887317] CPU1 attaching NULL sched-domain.
[ 6772.889301] CPU0 attaching NULL sched-domain.
[ 6772.891486] numa_remove_cpu cpu 1 node 0: mask now 0
[ 6772.895626] smpboot: CPU 1 is now offline
[ 6782.921403] SMP alternatives: lockdep: fixing up alternatives
[ 6782.927079] smpboot: Booting Node 0 Processor 1 APIC 0x1
[ 6772.892126] masked ExtINT on CPU#1
[ 6772.892126] numa_add_cpu cpu 1 node 0: mask now 0-1
[ 6782.963908] CPU0 attaching NULL sched-domain.
[ 6782.966272] CPU0 attaching sched-domain:
[ 6782.968251]  domain 0: span 0-1 level CPU
[ 6782.970270]   groups: 0 (cpu_power = 1023) 1
[ 6782.972831] CPU1 attaching sched-domain:
[ 6782.974654]  domain 0: span 0-1 level CPU
[ 6782.976677]   groups: 1 0 (cpu_power = 1023)
[ 6788.562155] rcu-torture: rtc: ffffffff82da41a0 ver: 1 tfle: 0 rta: 1 rtaf: 0 rtf: 0 rtmbe: 0 rtbke: 0 rtbre: 0 rtbf: 0 rtb: 0 nt: 4 onoff: 0/0:0/0 -1,0:-1,0 0:0 (HZ=1000) barrier: 0/0:0
[ 6788.562155] rcu-torture: Reader Pipe:  8 0 0 0 0 0 0 0 0 0 0
[ 6788.562155] rcu-torture: Reader Batch:  8 0 0 0 0 0 0 0 0 0 0
[ 6788.562155] rcu-torture: Free-Block Circulation:  0 0 0 0 0 0 0 0 0 0 0
[ 6848.574158] rcu-torture: rtc: ffffffff82da41a0 ver: 1 tfle: 0 rta: 1 rtaf: 0 rtf: 0 rtmbe: 0 rtbke: 0 rtbre: 0 rtbf: 0 rtb: 0 nt: 4 onoff: 0/0:0/0 -1,0:-1,0 0:0 (HZ=1000) barrier: 0/0:0
[ 6848.574158] rcu-torture: Reader Pipe:  8 0 0 0 0 0 0 0 0 0 0
[ 6848.574158] rcu-torture: Reader Batch:  8 0 0 0 0 0 0 0 0 0 0
[ 6848.574158] rcu-torture: Free-Block Circulation:  0 0 0 0 0 0 0 0 0 0 0
[ 6882.994854] CPU0 attaching NULL sched-domain.
[ 6882.996781] CPU1 attaching NULL sched-domain.
[ 6882.998786] CPU0 attaching NULL sched-domain.
[ 6883.001084] numa_remove_cpu cpu 1 node 0: mask now 0
[ 6883.005268] smpboot: CPU 1 is now offline
[ 6883.035373] SMP alternatives: lockdep: fixing up alternatives
[ 6883.037733] smpboot: Booting Node 0 Processor 1 APIC 0x1
[ 6883.002012] masked ExtINT on CPU#1
[ 6883.002012] numa_add_cpu cpu 1 node 0: mask now 0-1
[ 6883.081448] CPU0 attaching NULL sched-domain.
[ 6883.083647] CPU0 attaching sched-domain:
[ 6883.085637]  domain 0: span 0-1 level CPU
[ 6883.087704]   groups: 0 (cpu_power = 1023) 1
[ 6883.090340] CPU1 attaching sched-domain:
[ 6883.092186]  domain 0: span 0-1 level CPU
[ 6883.094205]   groups: 1 0 (cpu_power = 1023)
[ 6883.212552] CPU0 attaching NULL sched-domain.
[ 6883.214458] CPU1 attaching NULL sched-domain.
[ 6883.216452] CPU0 attaching NULL sched-domain.
[ 6883.218680] numa_remove_cpu cpu 1 node 0: mask now 0
[ 6883.222852] smpboot: CPU 1 is now offline
[ 6884.248710] SMP alternatives: lockdep: fixing up alternatives
[ 6884.254072] smpboot: Booting Node 0 Processor 1 APIC 0x1
[ 6883.219313] masked ExtINT on CPU#1
[ 6883.219313] numa_add_cpu cpu 1 node 0: mask now 0-1
[ 6884.290952] CPU0 attaching NULL sched-domain.
[ 6884.293306] CPU0 attaching sched-domain:
[ 6884.295283]  domain 0: span 0-1 level CPU
[ 6884.297281]   groups: 0 (cpu_power = 1023) 1
[ 6884.299886] CPU1 attaching sched-domain:
[ 6884.301701]  domain 0: span 0-1 level CPU
[ 6884.303724]   groups: 1 0 (cpu_power = 1023)
[ 6894.322461] CPU0 attaching NULL sched-domain.
[ 6894.324351] CPU1 attaching NULL sched-domain.
[ 6894.326341] CPU0 attaching NULL sched-domain.
[ 6894.328528] numa_remove_cpu cpu 1 node 0: mask now 0
[ 6894.332692] smpboot: CPU 1 is now offline
[ 6908.587094] rcu-torture: rtc: ffffffff82da41a0 ver: 1 tfle: 0 rta: 1 rtaf: 0 rtf: 0 rtmbe: 0 rtbke: 0 rtbre: 0 rtbf: 0 rtb: 0 nt: 4 onoff: 0/0:0/0 -1,0:-1,0 0:0 (HZ=1000) barrier: 0/0:0
[ 6908.587094] rcu-torture: Reader Pipe:  8 0 0 0 0 0 0 0 0 0 0
[ 6908.587094] rcu-torture: Reader Batch:  8 0 0 0 0 0 0 0 0 0 0
[ 6908.587094] rcu-torture: Free-Block Circulation:  0 0 0 0 0 0 0 0 0 0 0
[ 6968.599097] rcu-torture: rtc: ffffffff82da41a0 ver: 1 tfle: 0 rta: 1 rtaf: 0 rtf: 0 rtmbe: 0 rtbke: 0 rtbre: 0 rtbf: 0 rtb: 0 nt: 4 onoff: 0/0:0/0 -1,0:-1,0 0:0 (HZ=1000) barrier: 0/0:0
[ 6968.599097] rcu-torture: Reader Pipe:  8 0 0 0 0 0 0 0 0 0 0
[ 6968.599097] rcu-torture: Reader Batch:  8 0 0 0 0 0 0 0 0 0 0
[ 6968.599097] rcu-torture: Free-Block Circulation:  0 0 0 0 0 0 0 0 0 0 0
[ 6994.362644] SMP alternatives: lockdep: fixing up alternatives
[ 6994.368486] smpboot: Booting Node 0 Processor 1 APIC 0x1
[ 6894.329162] masked ExtINT on CPU#1
[ 6894.329162] numa_add_cpu cpu 1 node 0: mask now 0-1
[ 6994.404201] CPU0 attaching NULL sched-domain.
[ 6994.406553] CPU0 attaching sched-domain:
[ 6994.408408]  domain 0: span 0-1 level CPU
[ 6994.410477]   groups: 0 (cpu_power = 1023) 1
[ 6994.413112] CPU1 attaching sched-domain:
[ 6994.414979]  domain 0: span 0-1 level CPU
[ 6994.417021]   groups: 1 0 (cpu_power = 1023)
[ 6994.434723] CPU0 attaching NULL sched-domain.
[ 6994.436809] CPU1 attaching NULL sched-domain.
[ 6994.439780] CPU0 attaching NULL sched-domain.
[ 6994.442263] numa_remove_cpu cpu 1 node 0: mask now 0
[ 6994.446481] smpboot: CPU 1 is now offline
[ 6994.572847] SMP alternatives: lockdep: fixing up alternatives
[ 6994.578073] smpboot: Booting Node 0 Processor 1 APIC 0x1
[ 6994.443198] masked ExtINT on CPU#1
[ 6994.443198] numa_add_cpu cpu 1 node 0: mask now 0-1
[ 6994.615128] CPU0 attaching NULL sched-domain.
[ 6994.617443] CPU0 attaching sched-domain:
[ 6994.619332]  domain 0: span 0-1 level CPU
[ 6994.621416]   groups: 0 (cpu_power = 1023) 1
[ 6994.624093] CPU1 attaching sched-domain:
[ 6994.625946]  domain 0: span 0-1 level CPU
[ 6994.627994]   groups: 1 0 (cpu_power = 1023)
[ 6995.645596] CPU0 attaching NULL sched-domain.
[ 6995.647517] CPU1 attaching NULL sched-domain.
[ 6995.649549] CPU0 attaching NULL sched-domain.
[ 6995.651785] numa_remove_cpu cpu 1 node 0: mask now 0
[ 6995.655985] smpboot: CPU 1 is now offline
[ 7005.681361] SMP alternatives: lockdep: fixing up alternatives
[ 7005.683770] smpboot: Booting Node 0 Processor 1 APIC 0x1
[ 6995.652419] masked ExtINT on CPU#1
[ 6995.652419] numa_add_cpu cpu 1 node 0: mask now 0-1
[ 7005.723767] CPU0 attaching NULL sched-domain.
[ 7005.725961] CPU0 attaching sched-domain:
[ 7005.727830]  domain 0: span 0-1 level CPU
[ 7005.729903]   groups: 0 (cpu_power = 1023) 1
[ 7005.732527] CPU1 attaching sched-domain:
[ 7005.734396]  domain 0: span 0-1 level CPU
[ 7005.736458]   groups: 1 0 (cpu_power = 1023)
[ 7028.611157] rcu-torture: rtc: ffffffff82da41a0 ver: 1 tfle: 0 rta: 1 rtaf: 0 rtf: 0 rtmbe: 0 rtbke: 0 rtbre: 0 rtbf: 0 rtb: 0 nt: 4 onoff: 0/0:0/0 -1,0:-1,0 0:0 (HZ=1000) barrier: 0/0:0
[ 7028.611157] rcu-torture: Reader Pipe:  8 0 0 0 0 0 0 0 0 0 0
[ 7028.611157] rcu-torture: Reader Batch:  8 0 0 0 0 0 0 0 0 0 0
[ 7028.611157] rcu-torture: Free-Block Circulation:  0 0 0 0 0 0 0 0 0 0 0
[ 7088.623185] rcu-torture: rtc: ffffffff82da41a0 ver: 1 tfle: 0 rta: 1 rtaf: 0 rtf: 0 rtmbe: 0 rtbke: 0 rtbre: 0 rtbf: 0 rtb: 0 nt: 4 onoff: 0/0:0/0 -1,0:-1,0 0:0 (HZ=1000) barrier: 0/0:0
[ 7088.623185] rcu-torture: Reader Pipe:  8 0 0 0 0 0 0 0 0 0 0
[ 7088.623185] rcu-torture: Reader Batch:  8 0 0 0 0 0 0 0 0 0 0
[ 7088.623185] rcu-torture: Free-Block Circulation:  0 0 0 0 0 0 0 0 0 0 0
[ 7105.755844] CPU0 attaching NULL sched-domain.
[ 7105.758222] CPU1 attaching NULL sched-domain.
[ 7105.760305] CPU0 attaching NULL sched-domain.
[ 7105.762592] numa_remove_cpu cpu 1 node 0: mask now 0
[ 7105.766798] smpboot: CPU 1 is now offline
[ 7105.796521] SMP alternatives: lockdep: fixing up alternatives
[ 7105.798952] smpboot: Booting Node 0 Processor 1 APIC 0x1
[ 7105.763202] masked ExtINT on CPU#1
[ 7105.763202] numa_add_cpu cpu 1 node 0: mask now 0-1
[ 7105.842924] CPU0 attaching NULL sched-domain.
[ 7105.845351] CPU0 attaching sched-domain:
[ 7105.847272]  domain 0: span 0-1 level CPU
[ 7105.849401]   groups: 0 (cpu_power = 1023) 1
[ 7105.852122] CPU1 attaching sched-domain:
[ 7105.854032]  domain 0: span 0-1 level CPU
[ 7105.856095]   groups: 1 0 (cpu_power = 1023)
[ 7105.977677] CPU0 attaching NULL sched-domain.
[ 7105.979734] CPU1 attaching NULL sched-domain.
[ 7105.981882] CPU0 attaching NULL sched-domain.
[ 7105.984376] numa_remove_cpu cpu 1 node 0: mask now 0
[ 7105.988582] smpboot: CPU 1 is now offline
[ 7107.013273] SMP alternatives: lockdep: fixing up alternatives
[ 7107.015651] smpboot: Booting Node 0 Processor 1 APIC 0x1
[ 7105.985309] masked ExtINT on CPU#1
[ 7105.985309] numa_add_cpu cpu 1 node 0: mask now 0-1
[ 7107.055246] CPU0 attaching NULL sched-domain.
[ 7107.057437] CPU0 attaching sched-domain:
[ 7107.059320]  domain 0: span 0-1 level CPU
[ 7107.061364]   groups: 0 (cpu_power = 1023) 1
[ 7107.063985] CPU1 attaching sched-domain:
[ 7107.065852]  domain 0: span 0-1 level CPU
[ 7107.067903]   groups: 1 0 (cpu_power = 1023)
[ 7117.085893] CPU0 attaching NULL sched-domain.
[ 7117.087824] CPU1 attaching NULL sched-domain.
[ 7117.089881] CPU0 attaching NULL sched-domain.
[ 7117.092121] numa_remove_cpu cpu 1 node 0: mask now 0
[ 7117.096316] smpboot: CPU 1 is now offline
[ 7148.651128] rcu-torture: rtc: ffffffff82da41a0 ver: 1 tfle: 0 rta: 1 rtaf: 0 rtf: 0 rtmbe: 0 rtbke: 0 rtbre: 0 rtbf: 0 rtb: 0 nt: 4 onoff: 0/0:0/0 -1,0:-1,0 0:0 (HZ=1000) barrier: 0/0:0
[ 7148.651128] rcu-torture: Reader Pipe:  8 0 0 0 0 0 0 0 0 0 0
[ 7148.651128] rcu-torture: Reader Batch:  8 0 0 0 0 0 0 0 0 0 0
[ 7148.651128] rcu-torture: Free-Block Circulation:  0 0 0 0 0 0 0 0 0 0 0
[ 7208.664145] rcu-torture: rtc: ffffffff82da41a0 ver: 1 tfle: 0 rta: 1 rtaf: 0 rtf: 0 rtmbe: 0 rtbke: 0 rtbre: 0 rtbf: 0 rtb: 0 nt: 4 onoff: 0/0:0/0 -1,0:-1,0 0:0 (HZ=1000) barrier: 0/0:0
[ 7208.664145] rcu-torture: Reader Pipe:  8 0 0 0 0 0 0 0 0 0 0
[ 7208.664145] rcu-torture: Reader Batch:  8 0 0 0 0 0 0 0 0 0 0
[ 7208.664145] rcu-torture: Free-Block Circulation:  0 0 0 0 0 0 0 0 0 0 0
[ 7217.126219] SMP alternatives: lockdep: fixing up alternatives
[ 7217.132088] smpboot: Booting Node 0 Processor 1 APIC 0x1
[ 7117.093015] masked ExtINT on CPU#1
[ 7117.093015] numa_add_cpu cpu 1 node 0: mask now 0-1
[ 7217.167842] CPU0 attaching NULL sched-domain.
[ 7217.170267] CPU0 attaching sched-domain:
[ 7217.172127]  domain 0: span 0-1 level CPU
[ 7217.174146]   groups: 0 (cpu_power = 1023) 1
[ 7217.176741] CPU1 attaching sched-domain:
[ 7217.178595]  domain 0: span 0-1 level CPU
[ 7217.180660]   groups: 1 0 (cpu_power = 1023)
[ 7217.199116] CPU0 attaching NULL sched-domain.
[ 7217.201190] CPU1 attaching NULL sched-domain.
[ 7217.203330] CPU0 attaching NULL sched-domain.
[ 7217.205803] numa_remove_cpu cpu 1 node 0: mask now 0
[ 7217.210082] smpboot: CPU 1 is now offline
[ 7217.336743] SMP alternatives: lockdep: fixing up alternatives
[ 7217.342075] smpboot: Booting Node 0 Processor 1 APIC 0x1
[ 7217.206735] masked ExtINT on CPU#1
[ 7217.206735] numa_add_cpu cpu 1 node 0: mask now 0-1
[ 7217.379514] CPU0 attaching NULL sched-domain.
[ 7217.381845] CPU0 attaching sched-domain:
[ 7217.383691]  domain 0: span 0-1 level CPU
[ 7217.385716]   groups: 0 (cpu_power = 1023) 1
[ 7217.388310] CPU1 attaching sched-domain:
[ 7217.390138]  domain 0: span 0-1 level CPU
[ 7217.392124]   groups: 1 0 (cpu_power = 1023)
[ 7218.411585] CPU0 attaching NULL sched-domain.
[ 7218.413609] CPU1 attaching NULL sched-domain.
[ 7218.415672] CPU0 attaching NULL sched-domain.
[ 7218.417968] numa_remove_cpu cpu 1 node 0: mask now 0
[ 7218.422405] smpboot: CPU 1 is now offline
[ 7228.449129] SMP alternatives: lockdep: fixing up alternatives
[ 7228.454076] smpboot: Booting Node 0 Processor 1 APIC 0x1
[ 7218.418574] masked ExtINT on CPU#1
[ 7218.418574] numa_add_cpu cpu 1 node 0: mask now 0-1
[ 7228.491778] CPU0 attaching NULL sched-domain.
[ 7228.494142] CPU0 attaching sched-domain:
[ 7228.496158]  domain 0: span 0-1 level CPU
[ 7228.498164]   groups: 0 (cpu_power = 1023) 1
[ 7228.500761] CPU1 attaching sched-domain:
[ 7228.502591]  domain 0: span 0-1 level CPU
[ 7228.504611]   groups: 1 0 (cpu_power = 1023)
[ 7268.677144] rcu-torture: rtc: ffffffff82da41a0 ver: 1 tfle: 0 rta: 1 rtaf: 0 rtf: 0 rtmbe: 0 rtbke: 0 rtbre: 0 rtbf: 0 rtb: 0 nt: 4 onoff: 0/0:0/0 -1,0:-1,0 0:0 (HZ=1000) barrier: 0/0:0
[ 7268.677144] rcu-torture: Reader Pipe:  8 0 0 0 0 0 0 0 0 0 0
[ 7268.677144] rcu-torture: Reader Batch:  8 0 0 0 0 0 0 0 0 0 0
[ 7268.677144] rcu-torture: Free-Block Circulation:  0 0 0 0 0 0 0 0 0 0 0
[ 7328.523805] CPU0 attaching NULL sched-domain.
[ 7328.525741] CPU1 attaching NULL sched-domain.
[ 7328.527749] CPU0 attaching NULL sched-domain.
[ 7328.530107] numa_remove_cpu cpu 1 node 0: mask now 0
[ 7328.534275] smpboot: CPU 1 is now offline
[ 7328.578395] SMP alternatives: lockdep: fixing up alternatives
[ 7328.580717] smpboot: Booting Node 0 Processor 1 APIC 0x1
[ 7328.531012] masked ExtINT on CPU#1
[ 7328.531012] numa_add_cpu cpu 1 node 0: mask now 0-1
[ 7328.623774] CPU0 attaching NULL sched-domain.
[ 7328.627147] CPU0 attaching sched-domain:
[ 7328.629079]  domain 0: span 0-1 level CPU
[ 7328.631170]   groups: 0 (cpu_power = 1023) 1
[ 7328.633758] CPU1 attaching sched-domain:
[ 7328.635610]  domain 0: span 0-1 level CPU
[ 7328.637663]   groups: 1 0 (cpu_power = 1023)
[ 7328.690137] rcu-torture: rtc: ffffffff82da41a0 ver: 1 tfle: 0 rta: 1 rtaf: 0 rtf: 0 rtmbe: 0 rtbke: 0 rtbre: 0 rtbf: 0 rtb: 0 nt: 4 onoff: 0/0:0/0 -1,0:-1,0 0:0 (HZ=1000) barrier: 0/0:0
[ 7328.690137] rcu-torture: Reader Pipe:  8 0 0 0 0 0 0 0 0 0 0
[ 7328.690137] rcu-torture: Reader Batch:  8 0 0 0 0 0 0 0 0 0 0
[ 7328.690137] rcu-torture: Free-Block Circulation:  0 0 0 0 0 0 0 0 0 0 0
[ 7328.757327] CPU0 attaching NULL sched-domain.
[ 7328.759332] CPU1 attaching NULL sched-domain.
[ 7328.761416] CPU0 attaching NULL sched-domain.
[ 7328.763852] numa_remove_cpu cpu 1 node 0: mask now 0
[ 7328.768056] smpboot: CPU 1 is now offline
[ 7329.792838] SMP alternatives: lockdep: fixing up alternatives
[ 7329.798089] smpboot: Booting Node 0 Processor 1 APIC 0x1
[ 7328.764788] masked ExtINT on CPU#1
[ 7328.764788] numa_add_cpu cpu 1 node 0: mask now 0-1
[ 7329.835220] CPU0 attaching NULL sched-domain.
[ 7329.837426] CPU0 attaching sched-domain:
[ 7329.839441]  domain 0: span 0-1 level CPU
[ 7329.841519]   groups: 0 (cpu_power = 1023) 1
[ 7329.844148] CPU1 attaching sched-domain:
[ 7329.846021]  domain 0: span 0-1 level CPU
[ 7329.848025]   groups: 1 0 (cpu_power = 1023)
[ 7339.866619] CPU0 attaching NULL sched-domain.
[ 7339.868536] CPU1 attaching NULL sched-domain.
[ 7339.870565] CPU0 attaching NULL sched-domain.
[ 7339.872783] numa_remove_cpu cpu 1 node 0: mask now 0
[ 7339.876979] smpboot: CPU 1 is now offline
[ 7388.702104] rcu-torture: rtc: ffffffff82da41a0 ver: 1 tfle: 0 rta: 1 rtaf: 0 rtf: 0 rtmbe: 0 rtbke: 0 rtbre: 0 rtbf: 0 rtb: 0 nt: 4 onoff: 0/0:0/0 -1,0:-1,0 0:0 (HZ=1000) barrier: 0/0:0
[ 7388.702104] rcu-torture: Reader Pipe:  8 0 0 0 0 0 0 0 0 0 0
[ 7388.702104] rcu-torture: Reader Batch:  8 0 0 0 0 0 0 0 0 0 0
[ 7388.702104] rcu-torture: Free-Block Circulation:  0 0 0 0 0 0 0 0 0 0 0
[ 7439.912854] SMP alternatives: lockdep: fixing up alternatives
[ 7439.915245] smpboot: Booting Node 0 Processor 1 APIC 0x1
[ 7339.873399] masked ExtINT on CPU#1
[ 7339.873399] numa_add_cpu cpu 1 node 0: mask now 0-1
[ 7439.951137] CPU0 attaching NULL sched-domain.
[ 7439.953332] CPU0 attaching sched-domain:
[ 7439.955190]  domain 0: span 0-1 level CPU
[ 7439.957208]   groups: 0 (cpu_power = 1023) 1
[ 7439.959817] CPU1 attaching sched-domain:
[ 7439.961669]  domain 0: span 0-1 level CPU
[ 7439.963707]   groups: 1 0 (cpu_power = 1023)
[ 7439.983563] CPU0 attaching NULL sched-domain.
[ 7439.985478] CPU1 attaching NULL sched-domain.
[ 7439.987633] CPU0 attaching NULL sched-domain.
[ 7439.989859] numa_remove_cpu cpu 1 node 0: mask now 0
[ 7439.994051] smpboot: CPU 1 is now offline
[ 7440.125393] SMP alternatives: lockdep: fixing up alternatives
[ 7440.127712] smpboot: Booting Node 0 Processor 1 APIC 0x1
[ 7439.990489] masked ExtINT on CPU#1
[ 7439.990489] numa_add_cpu cpu 1 node 0: mask now 0-1
[ 7440.164736] CPU0 attaching NULL sched-domain.
[ 7440.167123] CPU0 attaching sched-domain:
[ 7440.169193]  domain 0: span 0-1 level CPU
[ 7440.171217]   groups: 0 (cpu_power = 1023) 1
[ 7440.173794] CPU1 attaching sched-domain:
[ 7440.175624]  domain 0: span 0-1 level CPU
[ 7440.177676]   groups: 1 0 (cpu_power = 1023)
[ 7441.196970] CPU0 attaching NULL sched-domain.
[ 7441.198934] CPU1 attaching NULL sched-domain.
[ 7441.200954] CPU0 attaching NULL sched-domain.
[ 7441.203229] numa_remove_cpu cpu 1 node 0: mask now 0
[ 7441.207417] smpboot: CPU 1 is now offline
[ 7448.715098] rcu-torture: rtc: ffffffff82da41a0 ver: 1 tfle: 0 rta: 1 rtaf: 0 rtf: 0 rtmbe: 0 rtbke: 0 rtbre: 0 rtbf: 0 rtb: 0 nt: 4 onoff: 0/0:0/0 -1,0:-1,0 0:0 (HZ=1000) barrier: 0/0:0
[ 7448.715098] rcu-torture: Reader Pipe:  8 0 0 0 0 0 0 0 0 0 0
[ 7448.715098] rcu-torture: Reader Batch:  8 0 0 0 0 0 0 0 0 0 0
[ 7448.715098] rcu-torture: Free-Block Circulation:  0 0 0 0 0 0 0 0 0 0 0
[ 7451.237447] SMP alternatives: lockdep: fixing up alternatives
[ 7451.243364] smpboot: Booting Node 0 Processor 1 APIC 0x1
[ 7441.204017] masked ExtINT on CPU#1
[ 7441.204017] numa_add_cpu cpu 1 node 0: mask now 0-1
[ 7451.279252] CPU0 attaching NULL sched-domain.
[ 7451.281466] CPU0 attaching sched-domain:
[ 7451.283317]  domain 0: span 0-1 level CPU
[ 7451.285375]   groups: 0 (cpu_power = 1023) 1
[ 7451.287987] CPU1 attaching sched-domain:
[ 7451.289847]  domain 0: span 0-1 level CPU
[ 7451.291901]   groups: 1 0 (cpu_power = 1023)
[ 7508.727103] rcu-torture: rtc: ffffffff82da41a0 ver: 1 tfle: 0 rta: 1 rtaf: 0 rtf: 0 rtmbe: 0 rtbke: 0 rtbre: 0 rtbf: 0 rtb: 0 nt: 4 onoff: 0/0:0/0 -1,0:-1,0 0:0 (HZ=1000) barrier: 0/0:0
[ 7508.727103] rcu-torture: Reader Pipe:  8 0 0 0 0 0 0 0 0 0 0
[ 7508.727103] rcu-torture: Reader Batch:  8 0 0 0 0 0 0 0 0 0 0
[ 7508.727103] rcu-torture: Free-Block Circulation:  0 0 0 0 0 0 0 0 0 0 0
[ 7551.310762] CPU0 attaching NULL sched-domain.
[ 7551.312673] CPU1 attaching NULL sched-domain.
[ 7551.314677] CPU0 attaching NULL sched-domain.
[ 7551.316913] numa_remove_cpu cpu 1 node 0: mask now 0
[ 7551.321140] smpboot: CPU 1 is now offline
[ 7551.352405] SMP alternatives: lockdep: fixing up alternatives
[ 7551.354710] smpboot: Booting Node 0 Processor 1 APIC 0x1
[ 7551.317522] masked ExtINT on CPU#1
[ 7551.317522] numa_add_cpu cpu 1 node 0: mask now 0-1
[ 7551.396686] CPU0 attaching NULL sched-domain.
[ 7551.413158] CPU0 attaching sched-domain:
[ 7551.414999]  domain 0: span 0-1 level CPU
[ 7551.417072]   groups: 0 (cpu_power = 1023) 1
[ 7551.419677] CPU1 attaching sched-domain:
[ 7551.421524]  domain 0: span 0-1 level CPU
[ 7551.423591]   groups: 1 0 (cpu_power = 1023)
[ 7551.538078] CPU0 attaching NULL sched-domain.
[ 7551.540085] CPU1 attaching NULL sched-domain.
[ 7551.542159] CPU0 attaching NULL sched-domain.
[ 7551.544588] numa_remove_cpu cpu 1 node 0: mask now 0
[ 7551.548786] smpboot: CPU 1 is now offline
[ 7552.574721] SMP alternatives: lockdep: fixing up alternatives
[ 7552.580083] smpboot: Booting Node 0 Processor 1 APIC 0x1
[ 7551.545524] masked ExtINT on CPU#1
[ 7551.545524] numa_add_cpu cpu 1 node 0: mask now 0-1
[ 7552.616905] CPU0 attaching NULL sched-domain.
[ 7552.619288] CPU0 attaching sched-domain:
[ 7552.621262]  domain 0: span 0-1 level CPU
[ 7552.623275]   groups: 0 (cpu_power = 1023) 1
[ 7552.625870] CPU1 attaching sched-domain:
[ 7552.627709]  domain 0: span 0-1 level CPU
[ 7552.629750]   groups: 1 0 (cpu_power = 1023)
[ 7562.648539] CPU0 attaching NULL sched-domain.
[ 7562.650444] CPU1 attaching NULL sched-domain.
[ 7562.652408] CPU0 attaching NULL sched-domain.
[ 7562.654600] numa_remove_cpu cpu 1 node 0: mask now 0
[ 7562.658734] smpboot: CPU 1 is now offline
[ 7568.739091] rcu-torture: rtc: ffffffff82da41a0 ver: 1 tfle: 0 rta: 1 rtaf: 0 rtf: 0 rtmbe: 0 rtbke: 0 rtbre: 0 rtbf: 0 rtb: 0 nt: 4 onoff: 0/0:0/0 -1,0:-1,0 0:0 (HZ=1000) barrier: 0/0:0
[ 7568.739091] rcu-torture: Reader Pipe:  8 0 0 0 0 0 0 0 0 0 0
[ 7568.739091] rcu-torture: Reader Batch:  8 0 0 0 0 0 0 0 0 0 0
[ 7568.739091] rcu-torture: Free-Block Circulation:  0 0 0 0 0 0 0 0 0 0 0
[ 7628.751096] rcu-torture: rtc: ffffffff82da41a0 ver: 1 tfle: 0 rta: 1 rtaf: 0 rtf: 0 rtmbe: 0 rtbke: 0 rtbre: 0 rtbf: 0 rtb: 0 nt: 4 onoff: 0/0:0/0 -1,0:-1,0 0:0 (HZ=1000) barrier: 0/0:0
[ 7628.751096] rcu-torture: Reader Pipe:  8 0 0 0 0 0 0 0 0 0 0
[ 7628.751096] rcu-torture: Reader Batch:  8 0 0 0 0 0 0 0 0 0 0
[ 7628.751096] rcu-torture: Free-Block Circulation:  0 0 0 0 0 0 0 0 0 0 0
[ 7662.688583] SMP alternatives: lockdep: fixing up alternatives
[ 7662.694359] smpboot: Booting Node 0 Processor 1 APIC 0x1
[ 7562.655234] masked ExtINT on CPU#1
[ 7562.655234] numa_add_cpu cpu 1 node 0: mask now 0-1
[ 7662.730277] CPU0 attaching NULL sched-domain.
[ 7662.732468] CPU0 attaching sched-domain:
[ 7662.734328]  domain 0: span 0-1 level CPU
[ 7662.736385]   groups: 0 (cpu_power = 1007) 1
[ 7662.738988] CPU1 attaching sched-domain:
[ 7662.740837]  domain 0: span 0-1 level CPU
[ 7662.742904]   groups: 1 0 (cpu_power = 1007)
[ 7662.760565] CPU0 attaching NULL sched-domain.
[ 7662.762767] CPU1 attaching NULL sched-domain.
[ 7662.764868] CPU0 attaching NULL sched-domain.
[ 7662.767284] numa_remove_cpu cpu 1 node 0: mask now 0
[ 7662.771485] smpboot: CPU 1 is now offline
[ 7662.896853] SMP alternatives: lockdep: fixing up alternatives
[ 7662.902090] smpboot: Booting Node 0 Processor 1 APIC 0x1
[ 7662.768220] masked ExtINT on CPU#1
[ 7662.768220] numa_add_cpu cpu 1 node 0: mask now 0-1
[ 7662.939218] CPU0 attaching NULL sched-domain.
[ 7662.941545] CPU0 attaching sched-domain:
[ 7662.943408]  domain 0: span 0-1 level CPU
[ 7662.945472]   groups: 0 (cpu_power = 1011) 1
[ 7662.948104] CPU1 attaching sched-domain:
[ 7662.949975]  domain 0: span 0-1 level CPU
[ 7662.952041]   groups: 1 0 (cpu_power = 1011)
[ 7663.969693] CPU0 attaching NULL sched-domain.
[ 7663.971672] CPU1 attaching NULL sched-domain.
[ 7663.973740] CPU0 attaching NULL sched-domain.
[ 7663.976030] numa_remove_cpu cpu 1 node 0: mask now 0
[ 7663.980230] smpboot: CPU 1 is now offline
[ 7674.006502] SMP alternatives: lockdep: fixing up alternatives
[ 7674.008957] smpboot: Booting Node 0 Processor 1 APIC 0x1
[ 7663.976643] masked ExtINT on CPU#1
[ 7663.976643] numa_add_cpu cpu 1 node 0: mask now 0-1
[ 7674.048731] CPU0 attaching NULL sched-domain.
[ 7674.050935] CPU0 attaching sched-domain:
[ 7674.052786]  domain 0: span 0-1 level CPU
[ 7674.054839]   groups: 0 (cpu_power = 1023) 1
[ 7674.057463] CPU1 attaching sched-domain:
[ 7674.059326]  domain 0: span 0-1 level CPU
[ 7674.061365]   groups: 1 0 (cpu_power = 1023)
[ 7688.764136] rcu-torture: rtc: ffffffff82da41a0 ver: 1 tfle: 0 rta: 1 rtaf: 0 rtf: 0 rtmbe: 0 rtbke: 0 rtbre: 0 rtbf: 0 rtb: 0 nt: 4 onoff: 0/0:0/0 -1,0:-1,0 0:0 (HZ=1000) barrier: 0/0:0
[ 7688.764136] rcu-torture: Reader Pipe:  8 0 0 0 0 0 0 0 0 0 0
[ 7688.764136] rcu-torture: Reader Batch:  8 0 0 0 0 0 0 0 0 0 0
[ 7688.764136] rcu-torture: Free-Block Circulation:  0 0 0 0 0 0 0 0 0 0 0
[ 7748.779160] rcu-torture: rtc: ffffffff82da41a0 ver: 1 tfle: 0 rta: 1 rtaf: 0 rtf: 0 rtmbe: 0 rtbke: 0 rtbre: 0 rtbf: 0 rtb: 0 nt: 4 onoff: 0/0:0/0 -1,0:-1,0 0:0 (HZ=1000) barrier: 0/0:0
[ 7748.779160] rcu-torture: Reader Pipe:  8 0 0 0 0 0 0 0 0 0 0
[ 7748.779160] rcu-torture: Reader Batch:  8 0 0 0 0 0 0 0 0 0 0
[ 7748.779160] rcu-torture: Free-Block Circulation:  0 0 0 0 0 0 0 0 0 0 0
[ 7774.080842] CPU0 attaching NULL sched-domain.
[ 7774.082834] CPU1 attaching NULL sched-domain.
[ 7774.085038] CPU0 attaching NULL sched-domain.
[ 7774.087381] numa_remove_cpu cpu 1 node 0: mask now 0
[ 7774.091625] smpboot: CPU 1 is now offline
[ 7774.124376] SMP alternatives: lockdep: fixing up alternatives
[ 7774.126770] smpboot: Booting Node 0 Processor 1 APIC 0x1
[ 7774.088017] masked ExtINT on CPU#1
[ 7774.088017] numa_add_cpu cpu 1 node 0: mask now 0-1
[ 7774.166126] CPU0 attaching NULL sched-domain.
[ 7774.168356] CPU0 attaching sched-domain:
[ 7774.170296]  domain 0: span 0-1 level CPU
[ 7774.172421]   groups: 0 (cpu_power = 1023) 1
[ 7774.175143] CPU1 attaching sched-domain:
[ 7774.177074]  domain 0: span 0-1 level CPU
[ 7774.179172]   groups: 1 0 (cpu_power = 1023)
[ 7774.295823] CPU0 attaching NULL sched-domain.
[ 7774.297891] CPU1 attaching NULL sched-domain.
[ 7774.300083] CPU0 attaching NULL sched-domain.
[ 7774.302575] numa_remove_cpu cpu 1 node 0: mask now 0
[ 7774.306935] smpboot: CPU 1 is now offline
[ 7775.332199] SMP alternatives: lockdep: fixing up alternatives
[ 7775.337093] smpboot: Booting Node 0 Processor 1 APIC 0x1
[ 7774.303510] masked ExtINT on CPU#1
[ 7774.303510] numa_add_cpu cpu 1 node 0: mask now 0-1
[ 7775.374959] CPU0 attaching NULL sched-domain.
[ 7775.377382] CPU0 attaching sched-domain:
[ 7775.379503]  domain 0: span 0-1 level CPU
[ 7775.381711]   groups: 0 (cpu_power = 1023) 1
[ 7775.384400] CPU1 attaching sched-domain:
[ 7775.386321]  domain 0: span 0-1 level CPU
[ 7775.388419]   groups: 1 0 (cpu_power = 1023)
[ 7785.410294] CPU0 attaching NULL sched-domain.
[ 7785.413292] CPU1 attaching NULL sched-domain.
[ 7785.416467] CPU0 attaching NULL sched-domain.
[ 7785.420209] numa_remove_cpu cpu 1 node 0: mask now 0
[ 7785.425604] smpboot: CPU 1 is now offline
[ 7808.792248] rcu-torture: rtc: ffffffff82da41a0 ver: 1 tfle: 0 rta: 1 rtaf: 0 rtf: 0 rtmbe: 0 rtbke: 0 rtbre: 0 rtbf: 0 rtb: 0 nt: 4 onoff: 0/0:0/0 -1,0:-1,0 0:0 (HZ=1000) barrier: 0/0:0
[ 7808.792248] rcu-torture: Reader Pipe:  8 0 0 0 0 0 0 0 0 0 0
[ 7808.792248] rcu-torture: Reader Batch:  8 0 0 0 0 0 0 0 0 0 0
[ 7808.792248] rcu-torture: Free-Block Circulation:  0 0 0 0 0 0 0 0 0 0 0
[ 7868.818243] rcu-torture: rtc: ffffffff82da41a0 ver: 1 tfle: 0 rta: 1 rtaf: 0 rtf: 0 rtmbe: 0 rtbke: 0 rtbre: 0 rtbf: 0 rtb: 0 nt: 4 onoff: 0/0:0/0 -1,0:-1,0 0:0 (HZ=1000) barrier: 0/0:0
[ 7868.818243] rcu-torture: Reader Pipe:  8 0 0 0 0 0 0 0 0 0 0
[ 7868.818243] rcu-torture: Reader Batch:  8 0 0 0 0 0 0 0 0 0 0
[ 7868.818243] rcu-torture: Free-Block Circulation:  0 0 0 0 0 0 0 0 0 0 0
[ 7885.472884] SMP alternatives: lockdep: fixing up alternatives
[ 7885.480561] smpboot: Booting Node 0 Processor 1 APIC 0x1
[ 7785.421024] masked ExtINT on CPU#1
[ 7785.421024] numa_add_cpu cpu 1 node 0: mask now 0-1
[ 7885.518697] CPU0 attaching NULL sched-domain.
[ 7885.521944] CPU0 attaching sched-domain:
[ 7885.524429]  domain 0: span 0-1 level CPU
[ 7885.527161]   groups: 0 (cpu_power = 1023) 1
[ 7885.530721] CPU1 attaching sched-domain:
[ 7885.533223]  domain 0: span 0-1 level CPU
[ 7885.535970]   groups: 1 0 (cpu_power = 1023)
[ 7885.556986] CPU0 attaching NULL sched-domain.
[ 7885.559702] CPU1 attaching NULL sched-domain.
[ 7885.562528] CPU0 attaching NULL sched-domain.
[ 7885.565637] numa_remove_cpu cpu 1 node 0: mask now 0
[ 7885.570760] smpboot: CPU 1 is now offline
[ 7885.708566] SMP alternatives: lockdep: fixing up alternatives
[ 7885.715118] smpboot: Booting Node 0 Processor 1 APIC 0x1
[ 7885.566107] masked ExtINT on CPU#1
[ 7885.566107] numa_add_cpu cpu 1 node 0: mask now 0-1
[ 7885.757413] CPU0 attaching NULL sched-domain.
[ 7885.760574] CPU0 attaching sched-domain:
[ 7885.763383]  domain 0: span 0-1 level CPU
[ 7885.766190]   groups: 0 (cpu_power = 1023) 1
[ 7885.769559] CPU1 attaching sched-domain:
[ 7885.771938]  domain 0: span 0-1 level CPU
[ 7885.774553]   groups: 1 0 (cpu_power = 1023)
[ 7886.795756] CPU0 attaching NULL sched-domain.
[ 7886.798523] CPU1 attaching NULL sched-domain.
[ 7886.801414] CPU0 attaching NULL sched-domain.
[ 7886.804683] numa_remove_cpu cpu 1 node 0: mask now 0
[ 7886.809681] smpboot: CPU 1 is now offline
[ 7896.853088] SMP alternatives: lockdep: fixing up alternatives
[ 7896.863123] smpboot: Booting Node 0 Processor 1 APIC 0x1
[ 7886.805604] masked ExtINT on CPU#1
[ 7886.805604] numa_add_cpu cpu 1 node 0: mask now 0-1
[ 7896.901974] CPU0 attaching NULL sched-domain.
[ 7896.905699] CPU0 attaching sched-domain:
[ 7896.909079]  domain 0: span 0-1 level CPU
[ 7896.912495]   groups: 0 (cpu_power = 1023) 1
[ 7896.916847] CPU1 attaching sched-domain:
[ 7896.919957]  domain 0: span 0-1 level CPU
[ 7896.923420]   groups: 1 0 (cpu_power = 1023)
[ 7928.834227] rcu-torture: rtc: ffffffff82da41a0 ver: 1 tfle: 0 rta: 1 rtaf: 0 rtf: 0 rtmbe: 0 rtbke: 0 rtbre: 0 rtbf: 0 rtb: 0 nt: 4 onoff: 0/0:0/0 -1,0:-1,0 0:0 (HZ=1000) barrier: 0/0:0
[ 7928.834227] rcu-torture: Reader Pipe:  8 0 0 0 0 0 0 0 0 0 0
[ 7928.834227] rcu-torture: Reader Batch:  8 0 0 0 0 0 0 0 0 0 0
[ 7928.834227] rcu-torture: Free-Block Circulation:  0 0 0 0 0 0 0 0 0 0 0
[ 7988.851261] rcu-torture: rtc: ffffffff82da41a0 ver: 1 tfle: 0 rta: 1 rtaf: 0 rtf: 0 rtmbe: 0 rtbke: 0 rtbre: 0 rtbf: 0 rtb: 0 nt: 4 onoff: 0/0:0/0 -1,0:-1,0 0:0 (HZ=1000) barrier: 0/0:0
[ 7988.851261] rcu-torture: Reader Pipe:  8 0 0 0 0 0 0 0 0 0 0
[ 7988.851261] rcu-torture: Reader Batch:  8 0 0 0 0 0 0 0 0 0 0
[ 7988.851261] rcu-torture: Free-Block Circulation:  0 0 0 0 0 0 0 0 0 0 0
[ 7996.954795] CPU0 attaching NULL sched-domain.
[ 7996.957796] CPU1 attaching NULL sched-domain.
[ 7996.960847] CPU0 attaching NULL sched-domain.
[ 7996.969165] numa_remove_cpu cpu 1 node 0: mask now 0
[ 7996.974648] smpboot: CPU 1 is now offline
[ 7997.117558] SMP alternatives: lockdep: fixing up alternatives
[ 7997.128122] smpboot: Booting Node 0 Processor 1 APIC 0x1
[ 7996.970032] masked ExtINT on CPU#1
[ 7996.970032] numa_add_cpu cpu 1 node 0: mask now 0-1
[ 7997.179278] CPU0 attaching NULL sched-domain.
[ 7997.183672] CPU0 attaching sched-domain:
[ 7997.186495]  domain 0: span 0-1 level CPU
[ 7997.260608]   groups: 0 (cpu_power = 1022) 1
[ 7997.264231] CPU1 attaching sched-domain:
[ 7997.266824]  domain 0: span 0-1 level CPU
[ 7997.279776]   groups: 1 0 (cpu_power = 1022)
[ 7997.430757] CPU0 attaching NULL sched-domain.
[ 7997.433620] CPU1 attaching NULL sched-domain.
[ 7997.436567] CPU0 attaching NULL sched-domain.
[ 7997.462528] numa_remove_cpu cpu 1 node 0: mask now 0
[ 7997.470909] smpboot: CPU 1 is now offline
[ 7998.535145] SMP alternatives: lockdep: fixing up alternatives
[ 7998.554272] smpboot: Booting Node 0 Processor 1 APIC 0x1
[ 7997.463414] masked ExtINT on CPU#1
[ 7997.463414] numa_add_cpu cpu 1 node 0: mask now 0-1
[ 7998.630062] CPU0 attaching NULL sched-domain.
[ 7998.633377] CPU0 attaching sched-domain:
[ 7998.636216]  domain 0: span 0-1 level CPU
[ 7998.643208]   groups: 0 (cpu_power = 1022) 1
[ 7998.650973] CPU1 attaching sched-domain:
[ 7998.658178]  domain 0: span 0-1 level CPU
[ 7998.661131]   groups: 1 0 (cpu_power = 1022)
[ 8008.711494] CPU0 attaching NULL sched-domain.
[ 8008.714032] CPU1 attaching NULL sched-domain.
[ 8008.716626] CPU0 attaching NULL sched-domain.
[ 8008.719610] numa_remove_cpu cpu 1 node 0: mask now 0
[ 8008.724892] smpboot: CPU 1 is now offline
[ 8048.870198] rcu-torture: rtc: ffffffff82da41a0 ver: 1 tfle: 0 rta: 1 rtaf: 0 rtf: 0 rtmbe: 0 rtbke: 0 rtbre: 0 rtbf: 0 rtb: 0 nt: 4 onoff: 0/0:0/0 -1,0:-1,0 0:0 (HZ=1000) barrier: 0/0:0
[ 8048.870198] rcu-torture: Reader Pipe:  8 0 0 0 0 0 0 0 0 0 0
[ 8048.870198] rcu-torture: Reader Batch:  8 0 0 0 0 0 0 0 0 0 0
[ 8048.870198] rcu-torture: Free-Block Circulation:  0 0 0 0 0 0 0 0 0 0 0
[ 8108.768473] SMP alternatives: lockdep: fixing up alternatives
[ 8108.774502] smpboot: Booting Node 0 Processor 1 APIC 0x1
[ 8008.720521] masked ExtINT on CPU#1
[ 8008.720521] numa_add_cpu cpu 1 node 0: mask now 0-1
[ 8108.811356] CPU0 attaching NULL sched-domain.
[ 8108.813611] CPU0 attaching sched-domain:
[ 8108.815538]  domain 0: span 0-1 level CPU
[ 8108.817669]   groups: 0 (cpu_power = 1023) 1
[ 8108.820410] CPU1 attaching sched-domain:
[ 8108.822341]  domain 0: span 0-1 level CPU
[ 8108.824468]   groups: 1 0 (cpu_power = 1023)
[ 8108.844390] CPU0 attaching NULL sched-domain.
[ 8108.846478] CPU1 attaching NULL sched-domain.
[ 8108.848743] CPU0 attaching NULL sched-domain.
[ 8108.851448] numa_remove_cpu cpu 1 node 0: mask now 0
[ 8108.856535] smpboot: CPU 1 is now offline
[ 8108.906121] rcu-torture: rtc: ffffffff82da41a0 ver: 1 tfle: 0 rta: 1 rtaf: 0 rtf: 0 rtmbe: 0 rtbke: 0 rtbre: 0 rtbf: 0 rtb: 0 nt: 4 onoff: 0/0:0/0 -1,0:-1,0 0:0 (HZ=1000) barrier: 0/0:0
[ 8108.906121] rcu-torture: Reader Pipe:  8 0 0 0 0 0 0 0 0 0 0
[ 8108.906121] rcu-torture: Reader Batch:  8 0 0 0 0 0 0 0 0 0 0
[ 8108.906121] rcu-torture: Free-Block Circulation:  0 0 0 0 0 0 0 0 0 0 0
[ 8108.985482] SMP alternatives: lockdep: fixing up alternatives
[ 8108.991515] smpboot: Booting Node 0 Processor 1 APIC 0x1
[ 8108.852327] masked ExtINT on CPU#1
[ 8108.852327] numa_add_cpu cpu 1 node 0: mask now 0-1
[ 8109.028203] CPU0 attaching NULL sched-domain.
[ 8109.030829] CPU0 attaching sched-domain:
[ 8109.032820]  domain 0: span 0-1 level CPU
[ 8109.035020]   groups: 0 (cpu_power = 1023) 1
[ 8109.037748] CPU1 attaching sched-domain:
[ 8109.039757]  domain 0: span 0-1 level CPU
[ 8109.041953]   groups: 1 0 (cpu_power = 1023)
[ 8110.063569] CPU0 attaching NULL sched-domain.
[ 8110.066968] CPU1 attaching NULL sched-domain.
[ 8110.070524] CPU0 attaching NULL sched-domain.
[ 8110.074395] numa_remove_cpu cpu 1 node 0: mask now 0
[ 8110.080130] smpboot: CPU 1 is now offline
[ 8120.111885] SMP alternatives: lockdep: fixing up alternatives
[ 8120.117959] smpboot: Booting Node 0 Processor 1 APIC 0x1
[ 8110.075023] masked ExtINT on CPU#1
[ 8110.075023] numa_add_cpu cpu 1 node 0: mask now 0-1
[ 8120.155690] CPU0 attaching NULL sched-domain.
[ 8120.158455] CPU0 attaching sched-domain:
[ 8120.160635]  domain 0: span 0-1 level CPU
[ 8120.163027]   groups: 0 (cpu_power = 1023) 1
[ 8120.166028] CPU1 attaching sched-domain:
[ 8120.168161]  domain 0: span 0-1 level CPU
[ 8120.170552]   groups: 1 0 (cpu_power = 1023)
[ 8168.919197] rcu-torture: rtc: ffffffff82da41a0 ver: 1 tfle: 0 rta: 1 rtaf: 0 rtf: 0 rtmbe: 0 rtbke: 0 rtbre: 0 rtbf: 0 rtb: 0 nt: 4 onoff: 0/0:0/0 -1,0:-1,0 0:0 (HZ=1000) barrier: 0/0:0
[ 8168.919197] rcu-torture: Reader Pipe:  8 0 0 0 0 0 0 0 0 0 0
[ 8168.919197] rcu-torture: Reader Batch:  8 0 0 0 0 0 0 0 0 0 0
[ 8168.919197] rcu-torture: Free-Block Circulation:  0 0 0 0 0 0 0 0 0 0 0
[ 8220.191360] CPU0 attaching NULL sched-domain.
[ 8220.195105] CPU1 attaching NULL sched-domain.
[ 8220.198579] CPU0 attaching NULL sched-domain.
[ 8220.202805] numa_remove_cpu cpu 1 node 0: mask now 0
[ 8220.207748] smpboot: CPU 1 is now offline
[ 8220.260662] SMP alternatives: lockdep: fixing up alternatives
[ 8220.269992] smpboot: Booting Node 0 Processor 1 APIC 0x1
[ 8220.203722] masked ExtINT on CPU#1
[ 8220.203722] numa_add_cpu cpu 1 node 0: mask now 0-1
[ 8220.319391] CPU0 attaching NULL sched-domain.
[ 8220.322947] CPU0 attaching sched-domain:
[ 8220.325896]  domain 0: span 0-1 level CPU
[ 8220.331087]   groups: 0 (cpu_power = 1023) 1
[ 8220.335159] CPU1 attaching sched-domain:
[ 8220.338033]  domain 0: span 0-1 level CPU
[ 8220.341206]   groups: 1 0 (cpu_power = 1023)
[ 8220.464897] CPU0 attaching NULL sched-domain.
[ 8220.468107] CPU1 attaching NULL sched-domain.
[ 8220.471548] CPU0 attaching NULL sched-domain.
[ 8220.479270] numa_remove_cpu cpu 1 node 0: mask now 0
[ 8220.484297] smpboot: CPU 1 is now offline
[ 8221.538669] SMP alternatives: lockdep: fixing up alternatives
[ 8221.548150] smpboot: Booting Node 0 Processor 1 APIC 0x1
[ 8220.480183] masked ExtINT on CPU#1
[ 8220.480183] numa_add_cpu cpu 1 node 0: mask now 0-1
[ 8221.605668] CPU0 attaching NULL sched-domain.
[ 8221.619697] CPU0 attaching sched-domain:
[ 8221.622551]  domain 0: span 0-1 level CPU
[ 8221.625763]   groups: 0 (cpu_power = 1023) 1
[ 8221.639916] CPU1 attaching sched-domain:
[ 8221.642822]  domain 0: span 0-1 level CPU
[ 8221.646057]   groups: 1 0 (cpu_power = 1023)
[ 8228.951194] rcu-torture: rtc: ffffffff82da41a0 ver: 1 tfle: 0 rta: 1 rtaf: 0 rtf: 0 rtmbe: 0 rtbke: 0 rtbre: 0 rtbf: 0 rtb: 0 nt: 4 onoff: 0/0:0/0 -1,0:-1,0 0:0 (HZ=1000) barrier: 0/0:0
[ 8228.951194] rcu-torture: Reader Pipe:  8 0 0 0 0 0 0 0 0 0 0
[ 8228.951194] rcu-torture: Reader Batch:  8 0 0 0 0 0 0 0 0 0 0
[ 8228.951194] rcu-torture: Free-Block Circulation:  0 0 0 0 0 0 0 0 0 0 0
[ 8231.692667] CPU0 attaching NULL sched-domain.
[ 8232.164328] CPU1 attaching NULL sched-domain.
[ 8232.167945] CPU0 attaching NULL sched-domain.
[ 8232.179439] numa_remove_cpu cpu 1 node 0: mask now 0
[ 8232.184727] smpboot: CPU 1 is now offline
[ 8288.990200] rcu-torture: rtc: ffffffff82da41a0 ver: 1 tfle: 0 rta: 1 rtaf: 0 rtf: 0 rtmbe: 0 rtbke: 0 rtbre: 0 rtbf: 0 rtb: 0 nt: 4 onoff: 0/0:0/0 -1,0:-1,0 0:0 (HZ=1000) barrier: 0/0:0
[ 8288.990200] rcu-torture: Reader Pipe:  8 0 0 0 0 0 0 0 0 0 0
[ 8288.990200] rcu-torture: Reader Batch:  8 0 0 0 0 0 0 0 0 0 0
[ 8288.990200] rcu-torture: Free-Block Circulation:  0 0 0 0 0 0 0 0 0 0 0
[ 8332.230688] SMP alternatives: lockdep: fixing up alternatives
[ 8332.246694] smpboot: Booting Node 0 Processor 1 APIC 0x1
[ 8232.180335] masked ExtINT on CPU#1
[ 8232.180335] numa_add_cpu cpu 1 node 0: mask now 0-1
[ 8332.304851] CPU0 attaching NULL sched-domain.
[ 8332.310894] CPU0 attaching sched-domain:
[ 8332.314132]  domain 0: span 0-1 level CPU
[ 8332.327858]   groups: 0 (cpu_power = 1017) 1
[ 8332.331360] CPU1 attaching sched-domain:
[ 8332.333543]  domain 0: span 0-1 level CPU
[ 8332.341926]   groups: 1 0 (cpu_power = 1017)
[ 8332.375442] CPU0 attaching NULL sched-domain.
[ 8332.378501] CPU1 attaching NULL sched-domain.
[ 8332.400735] CPU0 attaching NULL sched-domain.
[ 8332.418782] numa_remove_cpu cpu 1 node 0: mask now 0
[ 8332.424999] smpboot: CPU 1 is now offline
[ 8332.571610] SMP alternatives: lockdep: fixing up alternatives
[ 8332.589152] smpboot: Booting Node 0 Processor 1 APIC 0x1
[ 8332.419018] masked ExtINT on CPU#1
[ 8332.419018] numa_add_cpu cpu 1 node 0: mask now 0-1
[ 8332.644752] CPU0 attaching NULL sched-domain.
[ 8332.648504] CPU0 attaching sched-domain:
[ 8332.662284]  domain 0: span 0-1 level CPU
[ 8332.666368]   groups: 0 (cpu_power = 1020) 1
[ 8332.681487] CPU1 attaching sched-domain:
[ 8332.689723]  domain 0: span 0-1 level CPU
[ 8332.693699]   groups: 1 0 (cpu_power = 1020)
[ 8333.743400] CPU0 attaching NULL sched-domain.
[ 8333.746547] CPU1 attaching NULL sched-domain.
[ 8333.749947] CPU0 attaching NULL sched-domain.
[ 8333.753518] numa_remove_cpu cpu 1 node 0: mask now 0
[ 8333.769058] smpboot: CPU 1 is now offline
[ 8343.813487] SMP alternatives: lockdep: fixing up alternatives
[ 8343.824123] smpboot: Booting Node 0 Processor 1 APIC 0x1
[ 8333.754021] masked ExtINT on CPU#1
[ 8333.754021] numa_add_cpu cpu 1 node 0: mask now 0-1
[ 8343.862839] CPU0 attaching NULL sched-domain.
[ 8343.867809] CPU0 attaching sched-domain:
[ 8343.871511]  domain 0: span 0-1 level CPU
[ 8343.875540]   groups: 0 (cpu_power = 1023) 1
[ 8343.880624] CPU1 attaching sched-domain:
[ 8343.884315]  domain 0: span 0-1 level CPU
[ 8343.888313]   groups: 1 0 (cpu_power = 1023)
[ 8349.038215] rcu-torture: rtc: ffffffff82da41a0 ver: 1 tfle: 0 rta: 1 rtaf: 0 rtf: 0 rtmbe: 0 rtbke: 0 rtbre: 0 rtbf: 0 rtb: 0 nt: 4 onoff: 0/0:0/0 -1,0:-1,0 0:0 (HZ=1000) barrier: 0/0:0
[ 8349.038215] rcu-torture: Reader Pipe:  8 0 0 0 0 0 0 0 0 0 0
[ 8349.038215] rcu-torture: Reader Batch:  8 0 0 0 0 0 0 0 0 0 0
[ 8349.038215] rcu-torture: Free-Block Circulation:  0 0 0 0 0 0 0 0 0 0 0
[ 8409.053154] rcu-torture: rtc: ffffffff82da41a0 ver: 1 tfle: 0 rta: 1 rtaf: 0 rtf: 0 rtmbe: 0 rtbke: 0 rtbre: 0 rtbf: 0 rtb: 0 nt: 4 onoff: 0/0:0/0 -1,0:-1,0 0:0 (HZ=1000) barrier: 0/0:0
[ 8409.053154] rcu-torture: Reader Pipe:  8 0 0 0 0 0 0 0 0 0 0
[ 8409.053154] rcu-torture: Reader Batch:  8 0 0 0 0 0 0 0 0 0 0
[ 8409.053154] rcu-torture: Free-Block Circulation:  0 0 0 0 0 0 0 0 0 0 0
[ 8443.912306] CPU0 attaching NULL sched-domain.
[ 8443.914210] CPU1 attaching NULL sched-domain.
[ 8443.916261] CPU0 attaching NULL sched-domain.
[ 8443.918520] numa_remove_cpu cpu 1 node 0: mask now 0
[ 8443.923354] smpboot: CPU 1 is now offline
[ 8443.953897] SMP alternatives: lockdep: fixing up alternatives
[ 8443.956041] smpboot: Booting Node 0 Processor 1 APIC 0x1
[ 8443.919441] masked ExtINT on CPU#1
[ 8443.919441] numa_add_cpu cpu 1 node 0: mask now 0-1
[ 8443.996176] CPU0 attaching NULL sched-domain.
[ 8443.998227] CPU0 attaching sched-domain:
[ 8444.000157]  domain 0: span 0-1 level CPU
[ 8444.002002]   groups: 0 (cpu_power = 1023) 1
[ 8444.004358] CPU1 attaching sched-domain:
[ 8444.006031]  domain 0: span 0-1 level CPU
[ 8444.007836]   groups: 1 0 (cpu_power = 1023)
[ 8444.129440] CPU0 attaching NULL sched-domain.
[ 8444.131358] CPU1 attaching NULL sched-domain.
[ 8444.133401] CPU0 attaching NULL sched-domain.
[ 8444.135784] numa_remove_cpu cpu 1 node 0: mask now 0
[ 8444.140601] smpboot: CPU 1 is now offline
[ 8445.188543] SMP alternatives: lockdep: fixing up alternatives
[ 8445.194083] smpboot: Booting Node 0 Processor 1 APIC 0x1
[ 8444.136380] masked ExtINT on CPU#1
[ 8444.136380] numa_add_cpu cpu 1 node 0: mask now 0-1
[ 8445.233567] CPU0 attaching NULL sched-domain.
[ 8445.236868] CPU0 attaching sched-domain:
[ 8445.239351]  domain 0: span 0-1 level CPU
[ 8445.242062]   groups: 0 (cpu_power = 1023) 1
[ 8445.245471] CPU1 attaching sched-domain:
[ 8445.247923]  domain 0: span 0-1 level CPU
[ 8445.250641]   groups: 1 0 (cpu_power = 1023)
[ 8455.271940] CPU0 attaching NULL sched-domain.
[ 8455.274706] CPU1 attaching NULL sched-domain.
[ 8455.277447] CPU0 attaching NULL sched-domain.
[ 8455.280498] numa_remove_cpu cpu 1 node 0: mask now 0
[ 8455.285133] smpboot: CPU 1 is now offline
[ 8469.063225] rcu-torture: rtc: ffffffff82da41a0 ver: 1 tfle: 0 rta: 1 rtaf: 0 rtf: 0 rtmbe: 0 rtbke: 0 rtbre: 0 rtbf: 0 rtb: 0 nt: 4 onoff: 0/0:0/0 -1,0:-1,0 0:0 (HZ=1000) barrier: 0/0:0
[ 8469.063225] rcu-torture: Reader Pipe:  8 0 0 0 0 0 0 0 0 0 0
[ 8469.063225] rcu-torture: Reader Batch:  8 0 0 0 0 0 0 0 0 0 0
[ 8469.063225] rcu-torture: Free-Block Circulation:  0 0 0 0 0 0 0 0 0 0 0
[ 8529.092217] rcu-torture: rtc: ffffffff82da41a0 ver: 1 tfle: 0 rta: 1 rtaf: 0 rtf: 0 rtmbe: 0 rtbke: 0 rtbre: 0 rtbf: 0 rtb: 0 nt: 4 onoff: 0/0:0/0 -1,0:-1,0 0:0 (HZ=1000) barrier: 0/0:0
[ 8529.092217] rcu-torture: Reader Pipe:  8 0 0 0 0 0 0 0 0 0 0
[ 8529.092217] rcu-torture: Reader Batch:  8 0 0 0 0 0 0 0 0 0 0
[ 8529.092217] rcu-torture: Free-Block Circulation:  0 0 0 0 0 0 0 0 0 0 0
[ 8555.327639] SMP alternatives: lockdep: fixing up alternatives
[ 8555.354817] smpboot: Booting Node 0 Processor 1 APIC 0x1
[ 8455.281426] masked ExtINT on CPU#1
[ 8455.281426] numa_add_cpu cpu 1 node 0: mask now 0-1
[ 8555.417242] CPU0 attaching NULL sched-domain.
[ 8555.430507] CPU0 attaching sched-domain:
[ 8555.433695]  domain 0: span 0-1 level CPU
[ 8555.436330]   groups: 0 (cpu_power = 1023) 1
[ 8555.460078] CPU1 attaching sched-domain:
[ 8555.462921]  domain 0: span 0-1 level CPU
[ 8555.465427]   groups: 1 0 (cpu_power = 1023)
[ 8555.505657] CPU0 attaching NULL sched-domain.
[ 8555.508086] CPU1 attaching NULL sched-domain.
[ 8555.529881] CPU0 attaching NULL sched-domain.
[ 8555.545244] numa_remove_cpu cpu 1 node 0: mask now 0
[ 8555.568069] smpboot: CPU 1 is now offline
[ 8555.838868] SMP alternatives: lockdep: fixing up alternatives
[ 8555.854737] smpboot: Booting Node 0 Processor 1 APIC 0x1
[ 8555.546017] masked ExtINT on CPU#1
[ 8555.546017] numa_add_cpu cpu 1 node 0: mask now 0-1
[ 8555.909561] CPU0 attaching NULL sched-domain.
[ 8555.913470] CPU0 attaching sched-domain:
[ 8555.916521]  domain 0: span 0-1 level CPU
[ 8555.919392]   groups: 0 (cpu_power = 1001) 1
[ 8555.923403] CPU1 attaching sched-domain:
[ 8555.926216]  domain 0: span 0-1 level CPU
[ 8555.929519]   groups: 1 0 (cpu_power = 1001)
[ 8557.023141] CPU0 attaching NULL sched-domain.
[ 8557.026667] CPU1 attaching NULL sched-domain.
[ 8557.030188] CPU0 attaching NULL sched-domain.
[ 8557.049449] numa_remove_cpu cpu 1 node 0: mask now 0
[ 8557.054247] smpboot: CPU 1 is now offline
[ 8567.212757] SMP alternatives: lockdep: fixing up alternatives
[ 8567.232153] smpboot: Booting Node 0 Processor 1 APIC 0x1
[ 8557.050357] masked ExtINT on CPU#1
[ 8557.050357] numa_add_cpu cpu 1 node 0: mask now 0-1
[ 8567.289605] CPU0 attaching NULL sched-domain.
[ 8567.293769] CPU0 attaching sched-domain:
[ 8567.296837]  domain 0: span 0-1 level CPU
[ 8567.324576]   groups: 0 (cpu_power = 1022) 1
[ 8567.334254] CPU1 attaching sched-domain:
[ 8567.337478]  domain 0: span 0-1 level CPU
[ 8567.344099]   groups: 1 0 (cpu_power = 1022)
[ 8589.126165] rcu-torture: rtc: ffffffff82da41a0 ver: 1 tfle: 0 rta: 1 rtaf: 0 rtf: 0 rtmbe: 0 rtbke: 0 rtbre: 0 rtbf: 0 rtb: 0 nt: 4 onoff: 0/0:0/0 -1,0:-1,0 0:0 (HZ=1000) barrier: 0/0:0
[ 8589.126165] rcu-torture: Reader Pipe:  8 0 0 0 0 0 0 0 0 0 0
[ 8589.126165] rcu-torture: Reader Batch:  8 0 0 0 0 0 0 0 0 0 0
[ 8589.126165] rcu-torture: Free-Block Circulation:  0 0 0 0 0 0 0 0 0 0 0
[ 8649.141136] rcu-torture: rtc: ffffffff82da41a0 ver: 1 tfle: 0 rta: 1 rtaf: 0 rtf: 0 rtmbe: 0 rtbke: 0 rtbre: 0 rtbf: 0 rtb: 0 nt: 4 onoff: 0/0:0/0 -1,0:-1,0 0:0 (HZ=1000) barrier: 0/0:0
[ 8649.141136] rcu-torture: Reader Pipe:  8 0 0 0 0 0 0 0 0 0 0
[ 8649.141136] rcu-torture: Reader Batch:  8 0 0 0 0 0 0 0 0 0 0
[ 8649.141136] rcu-torture: Free-Block Circulation:  0 0 0 0 0 0 0 0 0 0 0
[ 8667.428945] CPU0 attaching NULL sched-domain.
[ 8667.432440] CPU1 attaching NULL sched-domain.
[ 8667.435969] CPU0 attaching NULL sched-domain.
[ 8667.449786] numa_remove_cpu cpu 1 node 0: mask now 0
[ 8667.455279] smpboot: CPU 1 is now offline
[ 8667.649695] SMP alternatives: lockdep: fixing up alternatives
[ 8667.659207] smpboot: Booting Node 0 Processor 1 APIC 0x1
[ 8667.450131] masked ExtINT on CPU#1
[ 8667.450131] numa_add_cpu cpu 1 node 0: mask now 0-1
[ 8667.716499] CPU0 attaching NULL sched-domain.
[ 8667.721791] CPU0 attaching sched-domain:
[ 8667.724641]  domain 0: span 0-1 level CPU
[ 8667.727747]   groups: 0 (cpu_power = 1022) 1
[ 8667.731776] CPU1 attaching sched-domain:
[ 8667.734634]  domain 0: span 0-1 level CPU
[ 8667.737687]   groups: 1 0 (cpu_power = 1022)
[ 8667.884959] CPU0 attaching NULL sched-domain.
[ 8667.895458] CPU1 attaching NULL sched-domain.
[ 8667.898579] CPU0 attaching NULL sched-domain.
[ 8667.902191] numa_remove_cpu cpu 1 node 0: mask now 0
[ 8667.908963] smpboot: CPU 1 is now offline
[ 8668.956669] SMP alternatives: lockdep: fixing up alternatives
[ 8668.989191] smpboot: Booting Node 0 Processor 1 APIC 0x1
[ 8667.903038] masked ExtINT on CPU#1
[ 8667.903038] numa_add_cpu cpu 1 node 0: mask now 0-1
[ 8669.050236] CPU0 attaching NULL sched-domain.
[ 8669.053617] CPU0 attaching sched-domain:
[ 8669.056453]  domain 0: span 0-1 level CPU
[ 8669.069487]   groups: 0 (cpu_power = 1023) 1
[ 8669.073369] CPU1 attaching sched-domain:
[ 8669.076126]  domain 0: span 0-1 level CPU
[ 8669.089288]   groups: 1 0 (cpu_power = 1023)
[ 8679.124559] CPU0 attaching NULL sched-domain.
[ 8679.127613] CPU1 attaching NULL sched-domain.
[ 8679.131567] CPU0 attaching NULL sched-domain.
[ 8679.146671] numa_remove_cpu cpu 1 node 0: mask now 0
[ 8679.151622] smpboot: CPU 1 is now offline
[ 8709.156243] rcu-torture: rtc: ffffffff82da41a0 ver: 1 tfle: 0 rta: 1 rtaf: 0 rtf: 0 rtmbe: 0 rtbke: 0 rtbre: 0 rtbf: 0 rtb: 0 nt: 4 onoff: 0/0:0/0 -1,0:-1,0 0:0 (HZ=1000) barrier: 0/0:0
[ 8709.156243] rcu-torture: Reader Pipe:  8 0 0 0 0 0 0 0 0 0 0
[ 8709.156243] rcu-torture: Reader Batch:  8 0 0 0 0 0 0 0 0 0 0
[ 8709.156243] rcu-torture: Free-Block Circulation:  0 0 0 0 0 0 0 0 0 0 0
[ 8769.181098] rcu-torture: rtc: ffffffff82da41a0 ver: 1 tfle: 0 rta: 1 rtaf: 0 rtf: 0 rtmbe: 0 rtbke: 0 rtbre: 0 rtbf: 0 rtb: 0 nt: 4 onoff: 0/0:0/0 -1,0:-1,0 0:0 (HZ=1000) barrier: 0/0:0
[ 8769.181098] rcu-torture: Reader Pipe:  8 0 0 0 0 0 0 0 0 0 0
[ 8769.181098] rcu-torture: Reader Batch:  8 0 0 0 0 0 0 0 0 0 0
[ 8769.181098] rcu-torture: Free-Block Circulation:  0 0 0 0 0 0 0 0 0 0 0
[ 8779.286656] SMP alternatives: lockdep: fixing up alternatives
[ 8779.291789] smpboot: Booting Node 0 Processor 1 APIC 0x1
[ 8679.147578] masked ExtINT on CPU#1
[ 8679.147578] numa_add_cpu cpu 1 node 0: mask now 0-1
[ 8779.327440] CPU0 attaching NULL sched-domain.
[ 8779.329619] CPU0 attaching sched-domain:
[ 8779.331333]  domain 0: span 0-1 level CPU
[ 8779.333201]   groups: 0 (cpu_power = 1023) 1
[ 8779.335606] CPU1 attaching sched-domain:
[ 8779.337316]  domain 0: span 0-1 level CPU
[ 8779.339198]   groups: 1 0 (cpu_power = 1023)
[ 8779.361449] CPU0 attaching NULL sched-domain.
[ 8779.363209] CPU1 attaching NULL sched-domain.
[ 8779.365132] CPU0 attaching NULL sched-domain.
[ 8779.367323] numa_remove_cpu cpu 1 node 0: mask now 0
[ 8779.371257] smpboot: CPU 1 is now offline
[ 8779.500232] SMP alternatives: lockdep: fixing up alternatives
[ 8779.502312] smpboot: Booting Node 0 Processor 1 APIC 0x1
[ 8779.368251] masked ExtINT on CPU#1
[ 8779.368251] numa_add_cpu cpu 1 node 0: mask now 0-1
[ 8779.539475] CPU0 attaching NULL sched-domain.
[ 8779.541564] CPU0 attaching sched-domain:
[ 8779.543234]  domain 0: span 0-1 level CPU
[ 8779.545021]   groups: 0 (cpu_power = 1023) 1
[ 8779.547323] CPU1 attaching sched-domain:
[ 8779.548956]  domain 0: span 0-1 level CPU
[ 8779.550752]   groups: 1 0 (cpu_power = 1023)
[ 8780.569749] CPU0 attaching NULL sched-domain.
[ 8780.571727] CPU1 attaching NULL sched-domain.
[ 8780.574245] CPU0 attaching NULL sched-domain.
[ 8780.576722] numa_remove_cpu cpu 1 node 0: mask now 0
[ 8780.580922] smpboot: CPU 1 is now offline
[ 8790.613857] SMP alternatives: lockdep: fixing up alternatives
[ 8790.619089] smpboot: Booting Node 0 Processor 1 APIC 0x1
[ 8780.577351] masked ExtINT on CPU#1
[ 8780.577351] numa_add_cpu cpu 1 node 0: mask now 0-1
[ 8790.656331] CPU0 attaching NULL sched-domain.
[ 8790.659282] CPU0 attaching sched-domain:
[ 8790.661698]  domain 0: span 0-1 level CPU
[ 8790.664258]   groups: 0 (cpu_power = 1023) 1
[ 8790.667446] CPU1 attaching sched-domain:
[ 8790.669757]  domain 0: span 0-1 level CPU
[ 8790.672282]   groups: 1 0 (cpu_power = 1023)
[ 8829.192242] rcu-torture: rtc: ffffffff82da41a0 ver: 1 tfle: 0 rta: 1 rtaf: 0 rtf: 0 rtmbe: 0 rtbke: 0 rtbre: 0 rtbf: 0 rtb: 0 nt: 4 onoff: 0/0:0/0 -1,0:-1,0 0:0 (HZ=1000) barrier: 0/0:0
[ 8829.192242] rcu-torture: Reader Pipe:  8 0 0 0 0 0 0 0 0 0 0
[ 8829.192242] rcu-torture: Reader Batch:  8 0 0 0 0 0 0 0 0 0 0
[ 8829.192242] rcu-torture: Free-Block Circulation:  0 0 0 0 0 0 0 0 0 0 0
[ 8889.241327] rcu-torture: rtc: ffffffff82da41a0 ver: 1 tfle: 0 rta: 1 rtaf: 0 rtf: 0 rtmbe: 0 rtbke: 0 rtbre: 0 rtbf: 0 rtb: 0 nt: 4 onoff: 0/0:0/0 -1,0:-1,0 0:0 (HZ=1000) barrier: 0/0:0
[ 8889.241327] rcu-torture: Reader Pipe:  8 0 0 0 0 0 0 0 0 0 0
[ 8889.241327] rcu-torture: Reader Batch:  8 0 0 0 0 0 0 0 0 0 0
[ 8889.241327] rcu-torture: Free-Block Circulation:  0 0 0 0 0 0 0 0 0 0 0
[ 8890.694732] CPU0 attaching NULL sched-domain.
[ 8890.698345] CPU1 attaching NULL sched-domain.
[ 8890.702196] CPU0 attaching NULL sched-domain.
[ 8890.710230] numa_remove_cpu cpu 1 node 0: mask now 0
[ 8890.715516] smpboot: CPU 1 is now offline
[ 8890.794643] SMP alternatives: lockdep: fixing up alternatives
[ 8890.809104] smpboot: Booting Node 0 Processor 1 APIC 0x1
[ 8890.711024] masked ExtINT on CPU#1
[ 8890.711024] numa_add_cpu cpu 1 node 0: mask now 0-1
[ 8890.900746] CPU0 attaching NULL sched-domain.
[ 8890.904933] CPU0 attaching sched-domain:
[ 8890.908151]  domain 0: span 0-1 level CPU
[ 8890.911624]   groups: 0 (cpu_power = 1022) 1
[ 8890.915960] CPU1 attaching sched-domain:
[ 8890.919123]  domain 0: span 0-1 level CPU
[ 8890.922511]   groups: 1 0 (cpu_power = 1022)
[ 8891.116483] CPU0 attaching NULL sched-domain.
[ 8891.120056] CPU1 attaching NULL sched-domain.
[ 8891.123801] CPU0 attaching NULL sched-domain.
[ 8891.159769] numa_remove_cpu cpu 1 node 0: mask now 0
[ 8891.168384] smpboot: CPU 1 is now offline
[ 8892.225634] SMP alternatives: lockdep: fixing up alternatives
[ 8892.253081] smpboot: Booting Node 0 Processor 1 APIC 0x1
[ 8891.160556] masked ExtINT on CPU#1
[ 8891.160556] numa_add_cpu cpu 1 node 0: mask now 0-1
[ 8892.414373] CPU0 attaching NULL sched-domain.
[ 8892.418310] CPU0 attaching sched-domain:
[ 8892.431549]  domain 0: span 0-1 level CPU
[ 8892.435033]   groups: 0 (cpu_power = 1022) 1
[ 8892.449436] CPU1 attaching sched-domain:
[ 8892.452549]  domain 0: span 0-1 level CPU
[ 8892.455957]   groups: 1 0 (cpu_power = 1022)
[ 8902.510138] CPU0 attaching NULL sched-domain.
[ 8902.511857] CPU1 attaching NULL sched-domain.
[ 8902.513672] CPU0 attaching NULL sched-domain.
[ 8902.515765] numa_remove_cpu cpu 1 node 0: mask now 0
[ 8902.519675] smpboot: CPU 1 is now offline
[ 8949.295089] rcu-torture: rtc: ffffffff82da41a0 ver: 1 tfle: 0 rta: 1 rtaf: 0 rtf: 0 rtmbe: 0 rtbke: 0 rtbre: 0 rtbf: 0 rtb: 0 nt: 4 onoff: 0/0:0/0 -1,0:-1,0 0:0 (HZ=1000) barrier: 0/0:0
[ 8949.295089] rcu-torture: Reader Pipe:  8 0 0 0 0 0 0 0 0 0 0
[ 8949.295089] rcu-torture: Reader Batch:  8 0 0 0 0 0 0 0 0 0 0
[ 8949.295089] rcu-torture: Free-Block Circulation:  0 0 0 0 0 0 0 0 0 0 0
[ 9002.559849] SMP alternatives: lockdep: fixing up alternatives
[ 9002.579128] smpboot: Booting Node 0 Processor 1 APIC 0x1
[ 8902.516708] masked ExtINT on CPU#1
[ 8902.516708] numa_add_cpu cpu 1 node 0: mask now 0-1
[ 9002.639680] CPU0 attaching NULL sched-domain.
[ 9002.643387] CPU0 attaching sched-domain:
[ 9002.650821]  domain 0: span 0-1 level CPU
[ 9002.671300]   groups: 0 (cpu_power = 1022) 1
[ 9002.681408] CPU1 attaching sched-domain:
[ 9002.684557]  domain 0: span 0-1 level CPU
[ 9002.703186]   groups: 1 0 (cpu_power = 1022)
[ 9002.784892] CPU0 attaching NULL sched-domain.
[ 9002.796340] CPU1 attaching NULL sched-domain.
[ 9002.811357] CPU0 attaching NULL sched-domain.
[ 9002.826720] numa_remove_cpu cpu 1 node 0: mask now 0
[ 9002.843671] smpboot: CPU 1 is now offline
[ 9003.013650] SMP alternatives: lockdep: fixing up alternatives
[ 9003.029088] smpboot: Booting Node 0 Processor 1 APIC 0x1
[ 9002.827617] masked ExtINT on CPU#1
[ 9002.827617] numa_add_cpu cpu 1 node 0: mask now 0-1
[ 9003.092429] CPU0 attaching NULL sched-domain.
[ 9003.096618] CPU0 attaching sched-domain:
[ 9003.110647]  domain 0: span 0-1 level CPU
[ 9003.114431]   groups: 0 (cpu_power = 1022) 1
[ 9003.129249] CPU1 attaching sched-domain:
[ 9003.132557]  domain 0: span 0-1 level CPU
[ 9003.146398]   groups: 1 0 (cpu_power = 1022)
[ 9004.212598] CPU0 attaching NULL sched-domain.
[ 9004.216608] CPU1 attaching NULL sched-domain.
[ 9004.222408] CPU0 attaching NULL sched-domain.
[ 9004.248435] numa_remove_cpu cpu 1 node 0: mask now 0
[ 9004.260496] smpboot: CPU 1 is now offline
[ 9009.305218] rcu-torture: rtc: ffffffff82da41a0 ver: 1 tfle: 0 rta: 1 rtaf: 0 rtf: 0 rtmbe: 0 rtbke: 0 rtbre: 0 rtbf: 0 rtb: 0 nt: 4 onoff: 0/0:0/0 -1,0:-1,0 0:0 (HZ=1000) barrier: 0/0:0
[ 9009.305218] rcu-torture: Reader Pipe:  8 0 0 0 0 0 0 0 0 0 0
[ 9009.305218] rcu-torture: Reader Batch:  8 0 0 0 0 0 0 0 0 0 0
[ 9009.305218] rcu-torture: Free-Block Circulation:  0 0 0 0 0 0 0 0 0 0 0
[ 9014.344304] SMP alternatives: lockdep: fixing up alternatives
[ 9014.378370] smpboot: Booting Node 0 Processor 1 APIC 0x1
[ 9004.249274] masked ExtINT on CPU#1
[ 9004.249274] numa_add_cpu cpu 1 node 0: mask now 0-1
[ 9014.485237] CPU0 attaching NULL sched-domain.
[ 9014.489610] CPU0 attaching sched-domain:
[ 9014.493322]  domain 0: span 0-1 level CPU
[ 9014.497263]   groups: 0 (cpu_power = 1023) 1
[ 9014.512522] CPU1 attaching sched-domain:
[ 9014.518985]  domain 0: span 0-1 level CPU
[ 9014.522791]   groups: 1 0 (cpu_power = 1023)
[ 9069.338237] rcu-torture: rtc: ffffffff82da41a0 ver: 1 tfle: 0 rta: 1 rtaf: 0 rtf: 0 rtmbe: 0 rtbke: 0 rtbre: 0 rtbf: 0 rtb: 0 nt: 4 onoff: 0/0:0/0 -1,0:-1,0 0:0 (HZ=1000) barrier: 0/0:0
[ 9069.338237] rcu-torture: Reader Pipe:  8 0 0 0 0 0 0 0 0 0 0
[ 9069.338237] rcu-torture: Reader Batch:  8 0 0 0 0 0 0 0 0 0 0
[ 9069.338237] rcu-torture: Free-Block Circulation:  0 0 0 0 0 0 0 0 0 0 0
[ 9114.589911] CPU0 attaching NULL sched-domain.
[ 9114.592902] CPU1 attaching NULL sched-domain.
[ 9114.595925] CPU0 attaching NULL sched-domain.
[ 9114.618314] numa_remove_cpu cpu 1 node 0: mask now 0
[ 9114.624293] smpboot: CPU 1 is now offline
[ 9114.712001] SMP alternatives: lockdep: fixing up alternatives
[ 9114.715944] smpboot: Booting Node 0 Processor 1 APIC 0x1
[ 9114.619222] masked ExtINT on CPU#1
[ 9114.619222] numa_add_cpu cpu 1 node 0: mask now 0-1
[ 9114.812866] CPU0 attaching NULL sched-domain.
[ 9114.825899] CPU0 attaching sched-domain:
[ 9114.839309]  domain 0: span 0-1 level CPU
[ 9114.842726]   groups: 0 (cpu_power = 1023) 1
[ 9114.847185] CPU1 attaching sched-domain:
[ 9114.860682]  domain 0: span 0-1 level CPU
[ 9114.864029]   groups: 1 0 (cpu_power = 1023)
[ 9115.004186] CPU0 attaching NULL sched-domain.
[ 9115.007532] CPU1 attaching NULL sched-domain.
[ 9115.010968] CPU0 attaching NULL sched-domain.
[ 9115.019331] numa_remove_cpu cpu 1 node 0: mask now 0
[ 9115.040221] smpboot: CPU 1 is now offline
[ 9116.083596] SMP alternatives: lockdep: fixing up alternatives
[ 9116.096118] smpboot: Booting Node 0 Processor 1 APIC 0x1
[ 9115.020236] masked ExtINT on CPU#1
[ 9115.020236] numa_add_cpu cpu 1 node 0: mask now 0-1
[ 9116.155239] CPU0 attaching NULL sched-domain.
[ 9116.158617] CPU0 attaching sched-domain:
[ 9116.161109]  domain 0: span 0-1 level CPU
[ 9116.163729]   groups: 0 (cpu_power = 1022) 1
[ 9116.167104] CPU1 attaching sched-domain:
[ 9116.169604]  domain 0: span 0-1 level CPU
[ 9116.172984]   groups: 1 0 (cpu_power = 1022)
[ 9126.200644] CPU0 attaching NULL sched-domain.
[ 9126.204320] CPU1 attaching NULL sched-domain.
[ 9126.208357] CPU0 attaching NULL sched-domain.
[ 9126.249054] numa_remove_cpu cpu 1 node 0: mask now 0
[ 9126.254445] smpboot: CPU 1 is now offline
[ 9129.366146] rcu-torture: rtc: ffffffff82da41a0 ver: 1 tfle: 0 rta: 1 rtaf: 0 rtf: 0 rtmbe: 0 rtbke: 0 rtbre: 0 rtbf: 0 rtb: 0 nt: 4 onoff: 0/0:0/0 -1,0:-1,0 0:0 (HZ=1000) barrier: 0/0:0
[ 9129.366146] rcu-torture: Reader Pipe:  8 0 0 0 0 0 0 0 0 0 0
[ 9129.366146] rcu-torture: Reader Batch:  8 0 0 0 0 0 0 0 0 0 0
[ 9129.366146] rcu-torture: Free-Block Circulation:  0 0 0 0 0 0 0 0 0 0 0
[ 9189.409166] rcu-torture: rtc: ffffffff82da41a0 ver: 1 tfle: 0 rta: 1 rtaf: 0 rtf: 0 rtmbe: 0 rtbke: 0 rtbre: 0 rtbf: 0 rtb: 0 nt: 4 onoff: 0/0:0/0 -1,0:-1,0 0:0 (HZ=1000) barrier: 0/0:0
[ 9189.409166] rcu-torture: Reader Pipe:  8 0 0 0 0 0 0 0 0 0 0
[ 9189.409166] rcu-torture: Reader Batch:  8 0 0 0 0 0 0 0 0 0 0
[ 9189.409166] rcu-torture: Free-Block Circulation:  0 0 0 0 0 0 0 0 0 0 0
[ 9226.322619] SMP alternatives: lockdep: fixing up alternatives
[ 9226.339108] smpboot: Booting Node 0 Processor 1 APIC 0x1
[ 9126.249947] masked ExtINT on CPU#1
[ 9126.249947] numa_add_cpu cpu 1 node 0: mask now 0-1
[ 9226.396459] CPU0 attaching NULL sched-domain.
[ 9226.410708] CPU0 attaching sched-domain:
[ 9226.414056]  domain 0: span 0-1 level CPU
[ 9226.417700]   groups: 0 (cpu_power = 1023) 1
[ 9226.432518] CPU1 attaching sched-domain:
[ 9226.436046]  domain 0: span 0-1 level CPU
[ 9226.439824]   groups: 1 0 (cpu_power = 1023)
[ 9226.489363] CPU0 attaching NULL sched-domain.
[ 9226.493442] CPU1 attaching NULL sched-domain.
[ 9226.497157] CPU0 attaching NULL sched-domain.
[ 9226.509156] numa_remove_cpu cpu 1 node 0: mask now 0
[ 9226.514646] smpboot: CPU 1 is now offline
[ 9226.668680] SMP alternatives: lockdep: fixing up alternatives
[ 9226.689099] smpboot: Booting Node 0 Processor 1 APIC 0x1
[ 9226.510048] masked ExtINT on CPU#1
[ 9226.510048] numa_add_cpu cpu 1 node 0: mask now 0-1
[ 9226.755243] CPU0 attaching NULL sched-domain.
[ 9226.769770] CPU0 attaching sched-domain:
[ 9226.772973]  domain 0: span 0-1 level CPU
[ 9226.776549]   groups: 0 (cpu_power = 1022) 1
[ 9226.791195] CPU1 attaching sched-domain:
[ 9226.794445]  domain 0: span 0-1 level CPU
[ 9226.797943]   groups: 1 0 (cpu_power = 1022)
[ 9227.853368] CPU0 attaching NULL sched-domain.
[ 9227.856847] CPU1 attaching NULL sched-domain.
[ 9227.860815] CPU0 attaching NULL sched-domain.
[ 9227.869365] numa_remove_cpu cpu 1 node 0: mask now 0
[ 9227.874726] smpboot: CPU 1 is now offline
[ 9237.961252] SMP alternatives: lockdep: fixing up alternatives
[ 9237.979311] smpboot: Booting Node 0 Processor 1 APIC 0x1
[ 9227.870267] masked ExtINT on CPU#1
[ 9227.870267] numa_add_cpu cpu 1 node 0: mask now 0-1
[ 9238.035951] CPU0 attaching NULL sched-domain.
[ 9238.050256] CPU0 attaching sched-domain:
[ 9238.053583]  domain 0: span 0-1 level CPU
[ 9238.057433]   groups: 0 (cpu_power = 1023) 1
[ 9238.072270] CPU1 attaching sched-domain:
[ 9238.075499]  domain 0: span 0-1 level CPU
[ 9238.089130]   groups: 1 0 (cpu_power = 1023)
[ 9249.432215] rcu-torture: rtc: ffffffff82da41a0 ver: 1 tfle: 0 rta: 1 rtaf: 0 rtf: 0 rtmbe: 0 rtbke: 0 rtbre: 0 rtbf: 0 rtb: 0 nt: 4 onoff: 0/0:0/0 -1,0:-1,0 0:0 (HZ=1000) barrier: 0/0:0
[ 9249.432215] rcu-torture: Reader Pipe:  8 0 0 0 0 0 0 0 0 0 0
[ 9249.432215] rcu-torture: Reader Batch:  8 0 0 0 0 0 0 0 0 0 0
[ 9249.432215] rcu-torture: Free-Block Circulation:  0 0 0 0 0 0 0 0 0 0 0
[ 9309.464296] rcu-torture: rtc: ffffffff82da41a0 ver: 1 tfle: 0 rta: 1 rtaf: 0 rtf: 0 rtmbe: 0 rtbke: 0 rtbre: 0 rtbf: 0 rtb: 0 nt: 4 onoff: 0/0:0/0 -1,0:-1,0 0:0 (HZ=1000) barrier: 0/0:0
[ 9309.464296] rcu-torture: Reader Pipe:  8 0 0 0 0 0 0 0 0 0 0
[ 9309.464296] rcu-torture: Reader Batch:  8 0 0 0 0 0 0 0 0 0 0
[ 9309.464296] rcu-torture: Free-Block Circulation:  0 0 0 0 0 0 0 0 0 0 0
[ 9338.138089] CPU0 attaching NULL sched-domain.
[ 9338.139755] CPU1 attaching NULL sched-domain.
[ 9338.141460] CPU0 attaching NULL sched-domain.
[ 9338.143383] numa_remove_cpu cpu 1 node 0: mask now 0
[ 9338.147251] smpboot: CPU 1 is now offline
[ 9338.181340] SMP alternatives: lockdep: fixing up alternatives
[ 9338.183273] smpboot: Booting Node 0 Processor 1 APIC 0x1
[ 9338.144024] masked ExtINT on CPU#1
[ 9338.144024] numa_add_cpu cpu 1 node 0: mask now 0-1
[ 9338.223809] CPU0 attaching NULL sched-domain.
[ 9338.226669] CPU0 attaching sched-domain:
[ 9338.228453]  domain 0: span 0-1 level CPU
[ 9338.230242]   groups: 0 (cpu_power = 1023) 1
[ 9338.232432] CPU1 attaching sched-domain:
[ 9338.233989]  domain 0: span 0-1 level CPU
[ 9338.235706]   groups: 1 0 (cpu_power = 1023)
[ 9338.346999] CPU0 attaching NULL sched-domain.
[ 9338.348627] CPU1 attaching NULL sched-domain.
[ 9338.350353] CPU0 attaching NULL sched-domain.
[ 9338.352260] numa_remove_cpu cpu 1 node 0: mask now 0
[ 9338.356126] smpboot: CPU 1 is now offline
[ 9339.373774] SMP alternatives: lockdep: fixing up alternatives
[ 9339.375899] smpboot: Booting Node 0 Processor 1 APIC 0x1
[ 9338.353009] masked ExtINT on CPU#1
[ 9338.353009] numa_add_cpu cpu 1 node 0: mask now 0-1
[ 9339.415128] CPU0 attaching NULL sched-domain.
[ 9339.416969] CPU0 attaching sched-domain:
[ 9339.418526]  domain 0: span 0-1 level CPU
[ 9339.420274]   groups: 0 (cpu_power = 1023) 1
[ 9339.422464] CPU1 attaching sched-domain:
[ 9339.424030]  domain 0: span 0-1 level CPU
[ 9339.425724]   groups: 1 0 (cpu_power = 1023)
[ 9349.443295] CPU0 attaching NULL sched-domain.
[ 9349.456142] CPU1 attaching NULL sched-domain.
[ 9349.457805] CPU0 attaching NULL sched-domain.
[ 9349.459758] numa_remove_cpu cpu 1 node 0: mask now 0
[ 9349.463644] smpboot: CPU 1 is now offline
[ 9369.492154] rcu-torture: rtc: ffffffff82da41a0 ver: 1 tfle: 0 rta: 1 rtaf: 0 rtf: 0 rtmbe: 0 rtbke: 0 rtbre: 0 rtbf: 0 rtb: 0 nt: 4 onoff: 0/0:0/0 -1,0:-1,0 0:0 (HZ=1000) barrier: 0/0:0
[ 9369.492154] rcu-torture: Reader Pipe:  8 0 0 0 0 0 0 0 0 0 0
[ 9369.492154] rcu-torture: Reader Batch:  8 0 0 0 0 0 0 0 0 0 0
[ 9369.492154] rcu-torture: Free-Block Circulation:  0 0 0 0 0 0 0 0 0 0 0
[ 9429.504123] rcu-torture: rtc: ffffffff82da41a0 ver: 1 tfle: 0 rta: 1 rtaf: 0 rtf: 0 rtmbe: 0 rtbke: 0 rtbre: 0 rtbf: 0 rtb: 0 nt: 4 onoff: 0/0:0/0 -1,0:-1,0 0:0 (HZ=1000) barrier: 0/0:0
[ 9429.504123] rcu-torture: Reader Pipe:  8 0 0 0 0 0 0 0 0 0 0
[ 9429.504123] rcu-torture: Reader Batch:  8 0 0 0 0 0 0 0 0 0 0
[ 9429.504123] rcu-torture: Free-Block Circulation:  0 0 0 0 0 0 0 0 0 0 0
[ 9449.498690] SMP alternatives: lockdep: fixing up alternatives
[ 9449.518812] smpboot: Booting Node 0 Processor 1 APIC 0x1
[ 9349.460404] masked ExtINT on CPU#1
[ 9349.460404] numa_add_cpu cpu 1 node 0: mask now 0-1
[ 9449.572916] CPU0 attaching NULL sched-domain.
[ 9449.576843] CPU0 attaching sched-domain:
[ 9449.600136]  domain 0: span 0-1 level CPU
[ 9449.603533]   groups: 0 (cpu_power = 989) 1
[ 9449.607966] CPU1 attaching sched-domain:
[ 9449.616343]  domain 0: span 0-1 level CPU
[ 9449.620032]   groups: 1 0 (cpu_power = 989)
[ 9449.648810] CPU0 attaching NULL sched-domain.
[ 9449.652338] CPU1 attaching NULL sched-domain.
[ 9449.659289] CPU0 attaching NULL sched-domain.
[ 9449.666500] numa_remove_cpu cpu 1 node 0: mask now 0
[ 9449.684071] smpboot: CPU 1 is now offline
[ 9449.844645] SMP alternatives: lockdep: fixing up alternatives
[ 9449.854123] smpboot: Booting Node 0 Processor 1 APIC 0x1
[ 9449.667022] masked ExtINT on CPU#1
[ 9449.667022] numa_add_cpu cpu 1 node 0: mask now 0-1
[ 9449.906961] CPU0 attaching NULL sched-domain.
[ 9449.910506] CPU0 attaching sched-domain:
[ 9449.913369]  domain 0: span 0-1 level CPU
[ 9449.916462]   groups: 0 (cpu_power = 1002) 1
[ 9449.920541] CPU1 attaching sched-domain:
[ 9449.923377]  domain 0: span 0-1 level CPU
[ 9449.926477]   groups: 1 0 (cpu_power = 1002)
[ 9451.008150] CPU0 attaching NULL sched-domain.
[ 9451.011064] CPU1 attaching NULL sched-domain.
[ 9451.014055] CPU0 attaching NULL sched-domain.
[ 9451.051634] numa_remove_cpu cpu 1 node 0: mask now 0
[ 9451.069469] smpboot: CPU 1 is now offline
[ 9461.130081] SMP alternatives: lockdep: fixing up alternatives
[ 9461.134438] smpboot: Booting Node 0 Processor 1 APIC 0x1
[ 9451.052017] masked ExtINT on CPU#1
[ 9451.052017] numa_add_cpu cpu 1 node 0: mask now 0-1
[ 9461.188611] CPU0 attaching NULL sched-domain.
[ 9461.192758] CPU0 attaching sched-domain:
[ 9461.196207]  domain 0: span 0-1 level CPU
[ 9461.200150]   groups: 0 (cpu_power = 1022) 1
[ 9461.204627] CPU1 attaching sched-domain:
[ 9461.207999]  domain 0: span 0-1 level CPU
[ 9461.212038]   groups: 1 0 (cpu_power = 1022)
[ 9489.549576] rcu-torture: rtc: ffffffff82da41a0 ver: 1 tfle: 0 rta: 1 rtaf: 0 rtf: 0 rtmbe: 0 rtbke: 0 rtbre: 0 rtbf: 0 rtb: 0 nt: 4 onoff: 0/0:0/0 -1,0:-1,0 0:0 (HZ=1000) barrier: 0/0:0
[ 9489.549576] rcu-torture: Reader Pipe:  8 0 0 0 0 0 0 0 0 0 0
[ 9489.549576] rcu-torture: Reader Batch:  8 0 0 0 0 0 0 0 0 0 0
[ 9489.549576] rcu-torture: Free-Block Circulation:  0 0 0 0 0 0 0 0 0 0 0
[ 9549.583253] rcu-torture: rtc: ffffffff82da41a0 ver: 1 tfle: 0 rta: 1 rtaf: 0 rtf: 0 rtmbe: 0 rtbke: 0 rtbre: 0 rtbf: 0 rtb: 0 nt: 4 onoff: 0/0:0/0 -1,0:-1,0 0:0 (HZ=1000) barrier: 0/0:0
[ 9549.583253] rcu-torture: Reader Pipe:  8 0 0 0 0 0 0 0 0 0 0
[ 9549.583253] rcu-torture: Reader Batch:  8 0 0 0 0 0 0 0 0 0 0
[ 9549.583253] rcu-torture: Free-Block Circulation:  0 0 0 0 0 0 0 0 0 0 0
[ 9561.276456] CPU0 attaching NULL sched-domain.
[ 9561.279655] CPU1 attaching NULL sched-domain.
[ 9561.282962] CPU0 attaching NULL sched-domain.
[ 9561.286703] numa_remove_cpu cpu 1 node 0: mask now 0
[ 9561.292482] smpboot: CPU 1 is now offline
[ 9561.344386] SMP alternatives: lockdep: fixing up alternatives
[ 9561.354173] smpboot: Booting Node 0 Processor 1 APIC 0x1
[ 9561.287172] masked ExtINT on CPU#1
[ 9561.287172] numa_add_cpu cpu 1 node 0: mask now 0-1
[ 9561.402500] CPU0 attaching NULL sched-domain.
[ 9561.406643] CPU0 attaching sched-domain:
[ 9561.410343]  domain 0: span 0-1 level CPU
[ 9561.414413]   groups: 0 (cpu_power = 1023) 1
[ 9561.419274] CPU1 attaching sched-domain:
[ 9561.422765]  domain 0: span 0-1 level CPU
[ 9561.426784]   groups: 1 0 (cpu_power = 1023)
[ 9561.551318] CPU0 attaching NULL sched-domain.
[ 9561.554997] CPU1 attaching NULL sched-domain.
[ 9561.558751] CPU0 attaching NULL sched-domain.
[ 9561.562984] numa_remove_cpu cpu 1 node 0: mask now 0
[ 9561.568607] smpboot: CPU 1 is now offline
[ 9562.612699] SMP alternatives: lockdep: fixing up alternatives
[ 9562.623111] smpboot: Booting Node 0 Processor 1 APIC 0x1
[ 9561.563886] masked ExtINT on CPU#1
[ 9561.563886] numa_add_cpu cpu 1 node 0: mask now 0-1
[ 9562.662291] CPU0 attaching NULL sched-domain.
[ 9562.666582] CPU0 attaching sched-domain:
[ 9562.670323]  domain 0: span 0-1 level CPU
[ 9562.674044]   groups: 0 (cpu_power = 1023) 1
[ 9562.678593] CPU1 attaching sched-domain:
[ 9562.682063]  domain 0: span 0-1 level CPU
[ 9562.685648]   groups: 1 0 (cpu_power = 1023)
[ 9572.712990] CPU0 attaching NULL sched-domain.
[ 9572.715917] CPU1 attaching NULL sched-domain.
[ 9572.718925] CPU0 attaching NULL sched-domain.
[ 9572.723791] numa_remove_cpu cpu 1 node 0: mask now 0
[ 9572.729185] smpboot: CPU 1 is now offline
[ 9609.603232] rcu-torture: rtc: ffffffff82da41a0 ver: 1 tfle: 0 rta: 1 rtaf: 0 rtf: 0 rtmbe: 0 rtbke: 0 rtbre: 0 rtbf: 0 rtb: 0 nt: 4 onoff: 0/0:0/0 -1,0:-1,0 0:0 (HZ=1000) barrier: 0/0:0
[ 9609.603232] rcu-torture: Reader Pipe:  8 0 0 0 0 0 0 0 0 0 0
[ 9609.603232] rcu-torture: Reader Batch:  8 0 0 0 0 0 0 0 0 0 0
[ 9609.603232] rcu-torture: Free-Block Circulation:  0 0 0 0 0 0 0 0 0 0 0
[ 9669.625187] rcu-torture: rtc: ffffffff82da41a0 ver: 1 tfle: 0 rta: 1 rtaf: 0 rtf: 0 rtmbe: 0 rtbke: 0 rtbre: 0 rtbf: 0 rtb: 0 nt: 4 onoff: 0/0:0/0 -1,0:-1,0 0:0 (HZ=1000) barrier: 0/0:0
[ 9669.625187] rcu-torture: Reader Pipe:  8 0 0 0 0 0 0 0 0 0 0
[ 9669.625187] rcu-torture: Reader Batch:  8 0 0 0 0 0 0 0 0 0 0
[ 9669.625187] rcu-torture: Free-Block Circulation:  0 0 0 0 0 0 0 0 0 0 0
[ 9672.779582] SMP alternatives: lockdep: fixing up alternatives
[ 9672.789792] smpboot: Booting Node 0 Processor 1 APIC 0x1
[ 9572.724202] masked ExtINT on CPU#1
[ 9572.724202] numa_add_cpu cpu 1 node 0: mask now 0-1
[ 9672.828957] CPU0 attaching NULL sched-domain.
[ 9672.834203] CPU0 attaching sched-domain:
[ 9672.837591]  domain 0: span 0-1 level CPU
[ 9672.841644]   groups: 0 (cpu_power = 1023) 1
[ 9672.846427] CPU1 attaching sched-domain:
[ 9672.850225]  domain 0: span 0-1 level CPU
[ 9672.854706]   groups: 1 0 (cpu_power = 1023)
[ 9672.881087] CPU0 attaching NULL sched-domain.
[ 9672.883955] CPU1 attaching NULL sched-domain.
[ 9672.887001] CPU0 attaching NULL sched-domain.
[ 9672.891008] numa_remove_cpu cpu 1 node 0: mask now 0
[ 9672.896788] smpboot: CPU 1 is now offline
[ 9673.043894] SMP alternatives: lockdep: fixing up alternatives
[ 9673.053109] smpboot: Booting Node 0 Processor 1 APIC 0x1
[ 9672.891491] masked ExtINT on CPU#1
[ 9672.891491] numa_add_cpu cpu 1 node 0: mask now 0-1
[ 9673.091966] CPU0 attaching NULL sched-domain.
[ 9673.096155] CPU0 attaching sched-domain:
[ 9673.099288]  domain 0: span 0-1 level CPU
[ 9673.102900]   groups: 0 (cpu_power = 1023) 1
[ 9673.107504] CPU1 attaching sched-domain:
[ 9673.110798]  domain 0: span 0-1 level CPU
[ 9673.114304]   groups: 1 0 (cpu_power = 1023)
[ 9674.139268] CPU0 attaching NULL sched-domain.
[ 9674.142526] CPU1 attaching NULL sched-domain.
[ 9674.145848] CPU0 attaching NULL sched-domain.
[ 9674.149920] numa_remove_cpu cpu 1 node 0: mask now 0
[ 9674.155588] smpboot: CPU 1 is now offline
[ 9684.201221] SMP alternatives: lockdep: fixing up alternatives
[ 9684.211101] smpboot: Booting Node 0 Processor 1 APIC 0x1
[ 9674.150776] masked ExtINT on CPU#1
[ 9674.150776] numa_add_cpu cpu 1 node 0: mask now 0-1
[ 9684.249661] CPU0 attaching NULL sched-domain.
[ 9684.253577] CPU0 attaching sched-domain:
[ 9684.256710]  domain 0: span 0-1 level CPU
[ 9684.260161]   groups: 0 (cpu_power = 1023) 1
[ 9684.264401] CPU1 attaching sched-domain:
[ 9684.267476]  domain 0: span 0-1 level CPU
[ 9684.270883]   groups: 1 0 (cpu_power = 1023)
[ 9729.652204] rcu-torture: rtc: ffffffff82da41a0 ver: 1 tfle: 0 rta: 1 rtaf: 0 rtf: 0 rtmbe: 0 rtbke: 0 rtbre: 0 rtbf: 0 rtb: 0 nt: 4 onoff: 0/0:0/0 -1,0:-1,0 0:0 (HZ=1000) barrier: 0/0:0
[ 9729.652204] rcu-torture: Reader Pipe:  8 0 0 0 0 0 0 0 0 0 0
[ 9729.652204] rcu-torture: Reader Batch:  8 0 0 0 0 0 0 0 0 0 0
[ 9729.652204] rcu-torture: Free-Block Circulation:  0 0 0 0 0 0 0 0 0 0 0
[ 9784.294310] CPU0 attaching NULL sched-domain.
[ 9784.297559] CPU1 attaching NULL sched-domain.
[ 9784.300927] CPU0 attaching NULL sched-domain.
[ 9784.304785] numa_remove_cpu cpu 1 node 0: mask now 0
[ 9784.310765] smpboot: CPU 1 is now offline
[ 9784.358635] SMP alternatives: lockdep: fixing up alternatives
[ 9784.368110] smpboot: Booting Node 0 Processor 1 APIC 0x1
[ 9784.305687] masked ExtINT on CPU#1
[ 9784.305687] numa_add_cpu cpu 1 node 0: mask now 0-1
[ 9784.415654] CPU0 attaching NULL sched-domain.
[ 9784.419770] CPU0 attaching sched-domain:
[ 9784.422824]  domain 0: span 0-1 level CPU
[ 9784.426157]   groups: 0 (cpu_power = 1023) 1
[ 9784.430272] CPU1 attaching sched-domain:
[ 9784.433497]  domain 0: span 0-1 level CPU
[ 9784.436962]   groups: 1 0 (cpu_power = 1023)
[ 9784.564093] CPU0 attaching NULL sched-domain.
[ 9784.567675] CPU1 attaching NULL sched-domain.
[ 9784.571189] CPU0 attaching NULL sched-domain.
[ 9784.575084] numa_remove_cpu cpu 1 node 0: mask now 0
[ 9784.681254] smpboot: CPU 1 is now offline
[ 9785.726595] SMP alternatives: lockdep: fixing up alternatives
[ 9785.733100] smpboot: Booting Node 0 Processor 1 APIC 0x1
[ 9784.581810] masked ExtINT on CPU#1
[ 9784.581810] numa_add_cpu cpu 1 node 0: mask now 0-1
[ 9785.774450] CPU0 attaching NULL sched-domain.
[ 9785.776694] CPU0 attaching sched-domain:
[ 9785.778536]  domain 0: span 0-1 level CPU
[ 9785.780609]   groups: 0 (cpu_power = 1023) 1
[ 9785.783348] CPU1 attaching sched-domain:
[ 9785.785128]  domain 0: span 0-1 level CPU
[ 9785.787090]   groups: 1 0 (cpu_power = 1023)
[ 9789.687241] rcu-torture: rtc: ffffffff82da41a0 ver: 1 tfle: 0 rta: 1 rtaf: 0 rtf: 0 rtmbe: 0 rtbke: 0 rtbre: 0 rtbf: 0 rtb: 0 nt: 4 onoff: 0/0:0/0 -1,0:-1,0 0:0 (HZ=1000) barrier: 0/0:0
[ 9789.687241] rcu-torture: Reader Pipe:  8 0 0 0 0 0 0 0 0 0 0
[ 9789.687241] rcu-torture: Reader Batch:  8 0 0 0 0 0 0 0 0 0 0
[ 9789.687241] rcu-torture: Free-Block Circulation:  0 0 0 0 0 0 0 0 0 0 0
[ 9795.811516] CPU0 attaching NULL sched-domain.
[ 9795.815100] CPU1 attaching NULL sched-domain.
[ 9795.818765] CPU0 attaching NULL sched-domain.
[ 9795.849676] numa_remove_cpu cpu 1 node 0: mask now 0
[ 9795.855644] smpboot: CPU 1 is now offline
[ 9849.708120] rcu-torture: rtc: ffffffff82da41a0 ver: 1 tfle: 0 rta: 1 rtaf: 0 rtf: 0 rtmbe: 0 rtbke: 0 rtbre: 0 rtbf: 0 rtb: 0 nt: 4 onoff: 0/0:0/0 -1,0:-1,0 0:0 (HZ=1000) barrier: 0/0:0
[ 9849.708120] rcu-torture: Reader Pipe:  8 0 0 0 0 0 0 0 0 0 0
[ 9849.708120] rcu-torture: Reader Batch:  8 0 0 0 0 0 0 0 0 0 0
[ 9849.708120] rcu-torture: Free-Block Circulation:  0 0 0 0 0 0 0 0 0 0 0
[ 9895.903838] SMP alternatives: lockdep: fixing up alternatives
[ 9895.929408] smpboot: Booting Node 0 Processor 1 APIC 0x1
[ 9795.850050] masked ExtINT on CPU#1
[ 9795.850050] numa_add_cpu cpu 1 node 0: mask now 0-1
[ 9895.990378] CPU0 attaching NULL sched-domain.
[ 9895.994576] CPU0 attaching sched-domain:
[ 9895.998062]  domain 0: span 0-1 level CPU
[ 9896.004598]   groups: 0 (cpu_power = 1022) 1
[ 9896.008846] CPU1 attaching sched-domain:
[ 9896.012041]  domain 0: span 0-1 level CPU
[ 9896.015458]   groups: 1 0 (cpu_power = 1022)
[ 9896.070784] CPU0 attaching NULL sched-domain.
[ 9896.074181] CPU1 attaching NULL sched-domain.
[ 9896.077899] CPU0 attaching NULL sched-domain.
[ 9896.094057] numa_remove_cpu cpu 1 node 0: mask now 0
[ 9896.100104] smpboot: CPU 1 is now offline
[ 9896.246695] SMP alternatives: lockdep: fixing up alternatives
[ 9896.288520] smpboot: Booting Node 0 Processor 1 APIC 0x1
[ 9896.094945] masked ExtINT on CPU#1
[ 9896.094945] numa_add_cpu cpu 1 node 0: mask now 0-1
[ 9896.341719] CPU0 attaching NULL sched-domain.
[ 9896.346227] CPU0 attaching sched-domain:
[ 9896.349671]  domain 0: span 0-1 level CPU
[ 9896.353365]   groups: 0 (cpu_power = 1022) 1
[ 9896.358003] CPU1 attaching sched-domain:
[ 9896.361447]  domain 0: span 0-1 level CPU
[ 9896.365202]   groups: 1 0 (cpu_power = 1022)
[ 9897.391141] CPU0 attaching NULL sched-domain.
[ 9897.394937] CPU1 attaching NULL sched-domain.
[ 9897.398842] CPU0 attaching NULL sched-domain.
[ 9897.409399] numa_remove_cpu cpu 1 node 0: mask now 0
[ 9897.415150] smpboot: CPU 1 is now offline
[ 9907.469634] SMP alternatives: lockdep: fixing up alternatives
[ 9907.479132] smpboot: Booting Node 0 Processor 1 APIC 0x1
[ 9897.410281] masked ExtINT on CPU#1
[ 9897.410281] numa_add_cpu cpu 1 node 0: mask now 0-1
[ 9907.517953] CPU0 attaching NULL sched-domain.
[ 9907.521810] CPU0 attaching sched-domain:
[ 9907.524670]  domain 0: span 0-1 level CPU
[ 9907.527859]   groups: 0 (cpu_power = 1023) 1
[ 9907.532356] CPU1 attaching sched-domain:
[ 9907.535377]  domain 0: span 0-1 level CPU
[ 9907.538694]   groups: 1 0 (cpu_power = 1023)
[ 9909.740158] rcu-torture: rtc: ffffffff82da41a0 ver: 1 tfle: 0 rta: 1 rtaf: 0 rtf: 0 rtmbe: 0 rtbke: 0 rtbre: 0 rtbf: 0 rtb: 0 nt: 4 onoff: 0/0:0/0 -1,0:-1,0 0:0 (HZ=1000) barrier: 0/0:0
[ 9909.740158] rcu-torture: Reader Pipe:  8 0 0 0 0 0 0 0 0 0 0
[ 9909.740158] rcu-torture: Reader Batch:  8 0 0 0 0 0 0 0 0 0 0
[ 9909.740158] rcu-torture: Free-Block Circulation:  0 0 0 0 0 0 0 0 0 0 0
[ 9969.765287] rcu-torture: rtc: ffffffff82da41a0 ver: 1 tfle: 0 rta: 1 rtaf: 0 rtf: 0 rtmbe: 0 rtbke: 0 rtbre: 0 rtbf: 0 rtb: 0 nt: 4 onoff: 0/0:0/0 -1,0:-1,0 0:0 (HZ=1000) barrier: 0/0:0
[ 9969.765287] rcu-torture: Reader Pipe:  8 0 0 0 0 0 0 0 0 0 0
[ 9969.765287] rcu-torture: Reader Batch:  8 0 0 0 0 0 0 0 0 0 0
[ 9969.765287] rcu-torture: Free-Block Circulation:  0 0 0 0 0 0 0 0 0 0 0
[10007.757292] CPU0 attaching NULL sched-domain.
[10007.760486] CPU1 attaching NULL sched-domain.
[10007.763732] CPU0 attaching NULL sched-domain.
[10007.767502] numa_remove_cpu cpu 1 node 0: mask now 0
[10007.773261] smpboot: CPU 1 is now offline
[10007.840244] SMP alternatives: lockdep: fixing up alternatives
[10007.847114] smpboot: Booting Node 0 Processor 1 APIC 0x1
[10007.768028] masked ExtINT on CPU#1
[10007.768028] numa_add_cpu cpu 1 node 0: mask now 0-1
[10007.901882] CPU0 attaching NULL sched-domain.
[10007.906804] CPU0 attaching sched-domain:
[10007.909995]  domain 0: span 0-1 level CPU
[10007.913276]   groups: 0 (cpu_power = 1023) 1
[10007.917346] CPU1 attaching sched-domain:
[10007.920442]  domain 0: span 0-1 level CPU
[10007.923765]   groups: 1 0 (cpu_power = 1023)
[10008.101967] CPU0 attaching NULL sched-domain.
[10008.104700] CPU1 attaching NULL sched-domain.
[10008.107613] CPU0 attaching NULL sched-domain.
[10008.121269] numa_remove_cpu cpu 1 node 0: mask now 0
[10008.128821] smpboot: CPU 1 is now offline
[10009.172594] SMP alternatives: lockdep: fixing up alternatives
[10009.189219] smpboot: Booting Node 0 Processor 1 APIC 0x1
[10008.122027] masked ExtINT on CPU#1
[10008.122027] numa_add_cpu cpu 1 node 0: mask now 0-1
[10009.239590] CPU0 attaching NULL sched-domain.
[10009.243151] CPU0 attaching sched-domain:
[10009.246231]  domain 0: span 0-1 level CPU
[10009.258842]   groups: 0 (cpu_power = 995) 1
[10009.271553] CPU1 attaching sched-domain:
[10009.277384]  domain 0: span 0-1 level CPU
[10009.285157]   groups: 1 0 (cpu_power = 995)
[10019.340957] CPU0 attaching NULL sched-domain.
[10019.344196] CPU1 attaching NULL sched-domain.
[10019.348301] CPU0 attaching NULL sched-domain.
[10019.369278] numa_remove_cpu cpu 1 node 0: mask now 0
[10019.374578] smpboot: CPU 1 is now offline
[10029.794223] rcu-torture: rtc: ffffffff82da41a0 ver: 1 tfle: 0 rta: 1 rtaf: 0 rtf: 0 rtmbe: 0 rtbke: 0 rtbre: 0 rtbf: 0 rtb: 0 nt: 4 onoff: 0/0:0/0 -1,0:-1,0 0:0 (HZ=1000) barrier: 0/0:0
[10029.794223] rcu-torture: Reader Pipe:  8 0 0 0 0 0 0 0 0 0 0
[10029.794223] rcu-torture: Reader Batch:  8 0 0 0 0 0 0 0 0 0 0
[10029.794223] rcu-torture: Free-Block Circulation:  0 0 0 0 0 0 0 0 0 0 0
[10089.825233] rcu-torture: rtc: ffffffff82da41a0 ver: 1 tfle: 0 rta: 1 rtaf: 0 rtf: 0 rtmbe: 0 rtbke: 0 rtbre: 0 rtbf: 0 rtb: 0 nt: 4 onoff: 0/0:0/0 -1,0:-1,0 0:0 (HZ=1000) barrier: 0/0:0
[10089.825233] rcu-torture: Reader Pipe:  8 0 0 0 0 0 0 0 0 0 0
[10089.825233] rcu-torture: Reader Batch:  8 0 0 0 0 0 0 0 0 0 0
[10089.825233] rcu-torture: Free-Block Circulation:  0 0 0 0 0 0 0 0 0 0 0
[10119.428781] SMP alternatives: lockdep: fixing up alternatives
[10119.432678] smpboot: Booting Node 0 Processor 1 APIC 0x1
[10019.370148] masked ExtINT on CPU#1
[10019.370148] numa_add_cpu cpu 1 node 0: mask now 0-1
[10119.491227] CPU0 attaching NULL sched-domain.
[10119.494856] CPU0 attaching sched-domain:
[10119.498219]  domain 0: span 0-1 level CPU
[10119.511790]   groups: 0 (cpu_power = 1023) 1
[10119.516058] CPU1 attaching sched-domain:
[10119.528045]  domain 0: span 0-1 level CPU
[10119.531616]   groups: 1 0 (cpu_power = 1023)
[10119.570515] CPU0 attaching NULL sched-domain.
[10119.573483] CPU1 attaching NULL sched-domain.
[10119.576458] CPU0 attaching NULL sched-domain.
[10119.579848] numa_remove_cpu cpu 1 node 0: mask now 0
[10119.584905] smpboot: CPU 1 is now offline
[10119.752654] SMP alternatives: lockdep: fixing up alternatives
[10119.761078] smpboot: Booting Node 0 Processor 1 APIC 0x1
[10119.580267] masked ExtINT on CPU#1
[10119.580267] numa_add_cpu cpu 1 node 0: mask now 0-1
[10119.828698] CPU0 attaching NULL sched-domain.
[10119.832903] CPU0 attaching sched-domain:
[10119.836292]  domain 0: span 0-1 level CPU
[10119.842071]   groups: 0 (cpu_power = 1023) 1
[10119.846814] CPU1 attaching sched-domain:
[10119.860275]  domain 0: span 0-1 level CPU
[10119.864038]   groups: 1 0 (cpu_power = 1023)
[10120.943046] CPU0 attaching NULL sched-domain.
[10120.946147] CPU1 attaching NULL sched-domain.
[10120.949504] CPU0 attaching NULL sched-domain.
[10120.961329] numa_remove_cpu cpu 1 node 0: mask now 0
[10120.975164] smpboot: CPU 1 is now offline
[10131.078841] SMP alternatives: lockdep: fixing up alternatives
[10131.085080] smpboot: Booting Node 0 Processor 1 APIC 0x1
[10120.962193] masked ExtINT on CPU#1
[10120.962193] numa_add_cpu cpu 1 node 0: mask now 0-1
[10131.180725] CPU0 attaching NULL sched-domain.
[10131.185257] CPU0 attaching sched-domain:
[10131.188109]  domain 0: span 0-1 level CPU
[10131.191348]   groups: 0 (cpu_power = 1023) 1
[10131.195214] CPU1 attaching sched-domain:
[10131.198075]  domain 0: span 0-1 level CPU
[10131.215698]   groups: 1 0 (cpu_power = 1023)
[10149.841240] rcu-torture: rtc: ffffffff82da41a0 ver: 1 tfle: 0 rta: 1 rtaf: 0 rtf: 0 rtmbe: 0 rtbke: 0 rtbre: 0 rtbf: 0 rtb: 0 nt: 4 onoff: 0/0:0/0 -1,0:-1,0 0:0 (HZ=1000) barrier: 0/0:0
[10149.841240] rcu-torture: Reader Pipe:  8 0 0 0 0 0 0 0 0 0 0
[10149.841240] rcu-torture: Reader Batch:  8 0 0 0 0 0 0 0 0 0 0
[10149.841240] rcu-torture: Free-Block Circulation:  0 0 0 0 0 0 0 0 0 0 0
[10209.866204] rcu-torture: rtc: ffffffff82da41a0 ver: 1 tfle: 0 rta: 1 rtaf: 0 rtf: 0 rtmbe: 0 rtbke: 0 rtbre: 0 rtbf: 0 rtb: 0 nt: 4 onoff: 0/0:0/0 -1,0:-1,0 0:0 (HZ=1000) barrier: 0/0:0
[10209.866204] rcu-torture: Reader Pipe:  8 0 0 0 0 0 0 0 0 0 0
[10209.866204] rcu-torture: Reader Batch:  8 0 0 0 0 0 0 0 0 0 0
[10209.866204] rcu-torture: Free-Block Circulation:  0 0 0 0 0 0 0 0 0 0 0
[10231.262688] CPU0 attaching NULL sched-domain.
[10231.264897] CPU1 attaching NULL sched-domain.
[10231.267410] CPU0 attaching NULL sched-domain.
[10231.270047] numa_remove_cpu cpu 1 node 0: mask now 0
[10231.274361] smpboot: CPU 1 is now offline
[10231.307396] SMP alternatives: lockdep: fixing up alternatives
[10231.309889] smpboot: Booting Node 0 Processor 1 APIC 0x1
[10231.270979] masked ExtINT on CPU#1
[10231.270979] numa_add_cpu cpu 1 node 0: mask now 0-1
[10231.351206] CPU0 attaching NULL sched-domain.
[10231.353630] CPU0 attaching sched-domain:
[10231.355577]  domain 0: span 0-1 level CPU
[10231.357751]   groups: 0 (cpu_power = 1023) 1
[10231.360552] CPU1 attaching sched-domain:
[10231.362506]  domain 0: span 0-1 level CPU
[10231.364678]   groups: 1 0 (cpu_power = 1023)
[10231.480827] CPU0 attaching NULL sched-domain.
[10231.482930] CPU1 attaching NULL sched-domain.
[10231.485149] CPU0 attaching NULL sched-domain.
[10231.487724] numa_remove_cpu cpu 1 node 0: mask now 0
[10231.492058] smpboot: CPU 1 is now offline
[10232.517982] SMP alternatives: lockdep: fixing up alternatives
[10232.523099] smpboot: Booting Node 0 Processor 1 APIC 0x1
[10231.488655] masked ExtINT on CPU#1
[10231.488655] numa_add_cpu cpu 1 node 0: mask now 0-1
[10232.560975] CPU0 attaching NULL sched-domain.
[10232.563551] CPU0 attaching sched-domain:
[10232.565524]  domain 0: span 0-1 level CPU
[10232.568202]   groups: 0 (cpu_power = 1023) 1
[10232.571050] CPU1 attaching sched-domain:
[10232.573033]  domain 0: span 0-1 level CPU
[10232.575159]   groups: 1 0 (cpu_power = 1023)
[10242.593962] CPU0 attaching NULL sched-domain.
[10242.597236] CPU1 attaching NULL sched-domain.
[10242.600785] CPU0 attaching NULL sched-domain.
[10242.604793] numa_remove_cpu cpu 1 node 0: mask now 0
[10242.609926] smpboot: CPU 1 is now offline
[10269.899615] rcu-torture: rtc: ffffffff82da41a0 ver: 1 tfle: 0 rta: 1 rtaf: 0 rtf: 0 rtmbe: 0 rtbke: 0 rtbre: 0 rtbf: 0 rtb: 0 nt: 4 onoff: 0/0:0/0 -1,0:-1,0 0:0 (HZ=1000) barrier: 0/0:0
[10269.899615] rcu-torture: Reader Pipe:  8 0 0 0 0 0 0 0 0 0 0
[10269.899615] rcu-torture: Reader Batch:  8 0 0 0 0 0 0 0 0 0 0
[10269.899615] rcu-torture: Free-Block Circulation:  0 0 0 0 0 0 0 0 0 0 0
[10329.959594] rcu-torture: rtc: ffffffff82da41a0 ver: 1 tfle: 0 rta: 1 rtaf: 0 rtf: 0 rtmbe: 0 rtbke: 0 rtbre: 0 rtbf: 0 rtb: 0 nt: 4 onoff: 0/0:0/0 -1,0:-1,0 0:0 (HZ=1000) barrier: 0/0:0
[10329.959594] rcu-torture: Reader Pipe:  8 0 0 0 0 0 0 0 0 0 0
[10329.959594] rcu-torture: Reader Batch:  8 0 0 0 0 0 0 0 0 0 0
[10329.959594] rcu-torture: Free-Block Circulation:  0 0 0 0 0 0 0 0 0 0 0
[10342.657792] SMP alternatives: lockdep: fixing up alternatives
[10342.675722] smpboot: Booting Node 0 Processor 1 APIC 0x1
[10242.605715] masked ExtINT on CPU#1
[10242.605715] numa_add_cpu cpu 1 node 0: mask now 0-1
[10342.723429] CPU0 attaching NULL sched-domain.
[10342.726518] CPU0 attaching sched-domain:
[10342.728939]  domain 0: span 0-1 level CPU
[10342.731686]   groups: 0 (cpu_power = 1022) 1
[10342.735211] CPU1 attaching sched-domain:
[10342.737687]  domain 0: span 0-1 level CPU
[10342.750498]   groups: 1 0 (cpu_power = 1022)
[10342.774141] CPU0 attaching NULL sched-domain.
[10342.777452] CPU1 attaching NULL sched-domain.
[10342.780859] CPU0 attaching NULL sched-domain.
[10342.784648] numa_remove_cpu cpu 1 node 0: mask now 0
[10342.790573] smpboot: CPU 1 is now offline
[10342.933834] SMP alternatives: lockdep: fixing up alternatives
[10342.949100] smpboot: Booting Node 0 Processor 1 APIC 0x1
[10342.785009] masked ExtINT on CPU#1
[10342.785009] numa_add_cpu cpu 1 node 0: mask now 0-1
[10342.994603] CPU0 attaching NULL sched-domain.
[10342.997566] CPU0 attaching sched-domain:
[10343.000216]  domain 0: span 0-1 level CPU
[10343.002925]   groups: 0 (cpu_power = 1023) 1
[10343.006294] CPU1 attaching sched-domain:
[10343.008679]  domain 0: span 0-1 level CPU
[10343.011419]   groups: 1 0 (cpu_power = 1023)
[10344.056571] CPU0 attaching NULL sched-domain.
[10344.059127] CPU1 attaching NULL sched-domain.
[10344.061800] CPU0 attaching NULL sched-domain.
[10344.064816] numa_remove_cpu cpu 1 node 0: mask now 0
[10344.070003] smpboot: CPU 1 is now offline
[10354.118206] SMP alternatives: lockdep: fixing up alternatives
[10354.128862] smpboot: Booting Node 0 Processor 1 APIC 0x1
[10344.065326] masked ExtINT on CPU#1
[10344.065326] numa_add_cpu cpu 1 node 0: mask now 0-1
[10354.168594] CPU0 attaching NULL sched-domain.
[10354.173374] CPU0 attaching sched-domain:
[10354.177226]  domain 0: span 0-1 level CPU
[10354.181471]   groups: 0 (cpu_power = 1005) 1
[10354.186769] CPU1 attaching sched-domain:
[10354.190596]  domain 0: span 0-1 level CPU
[10354.194708]   groups: 1 0 (cpu_power = 1005)
[10390.064344] rcu-torture: rtc: ffffffff82da41a0 ver: 1 tfle: 0 rta: 1 rtaf: 0 rtf: 0 rtmbe: 0 rtbke: 0 rtbre: 0 rtbf: 0 rtb: 0 nt: 4 onoff: 0/0:0/0 -1,0:-1,0 0:0 (HZ=1000) barrier: 0/0:0
[10390.064344] rcu-torture: Reader Pipe:  8 0 0 0 0 0 0 0 0 0 0
[10390.064344] rcu-torture: Reader Batch:  8 0 0 0 0 0 0 0 0 0 0
[10390.064344] rcu-torture: Free-Block Circulation:  0 0 0 0 0 0 0 0 0 0 0
[10450.088321] rcu-torture: rtc: ffffffff82da41a0 ver: 1 tfle: 0 rta: 1 rtaf: 0 rtf: 0 rtmbe: 0 rtbke: 0 rtbre: 0 rtbf: 0 rtb: 0 nt: 4 onoff: 0/0:0/0 -1,0:-1,0 0:0 (HZ=1000) barrier: 0/0:0
[10450.088321] rcu-torture: Reader Pipe:  8 0 0 0 0 0 0 0 0 0 0
[10450.088321] rcu-torture: Reader Batch:  8 0 0 0 0 0 0 0 0 0 0
[10450.088321] rcu-torture: Free-Block Circulation:  0 0 0 0 0 0 0 0 0 0 0
[10454.218866] CPU0 attaching NULL sched-domain.
[10454.223073] CPU1 attaching NULL sched-domain.
[10454.227931] CPU0 attaching NULL sched-domain.
[10454.242785] numa_remove_cpu cpu 1 node 0: mask now 0
[10454.248429] smpboot: CPU 1 is now offline
[10454.369605] SMP alternatives: lockdep: fixing up alternatives
[10454.373974] smpboot: Booting Node 0 Processor 1 APIC 0x1
[10454.243689] masked ExtINT on CPU#1
[10454.243689] numa_add_cpu cpu 1 node 0: mask now 0-1
[10454.445265] CPU0 attaching NULL sched-domain.
[10454.453486] CPU0 attaching sched-domain:
[10454.456856]  domain 0: span 0-1 level CPU
[10454.460585]   groups: 0 (cpu_power = 1022) 1
[10454.465229] CPU1 attaching sched-domain:
[10454.468930]  domain 0: span 0-1 level CPU
[10454.472819]   groups: 1 0 (cpu_power = 1022)
[10454.603087] CPU0 attaching NULL sched-domain.
[10454.606647] CPU1 attaching NULL sched-domain.
[10454.610495] CPU0 attaching NULL sched-domain.
[10454.619298] numa_remove_cpu cpu 1 node 0: mask now 0
[10454.624888] smpboot: CPU 1 is now offline
[10455.710719] SMP alternatives: lockdep: fixing up alternatives
[10455.729156] smpboot: Booting Node 0 Processor 1 APIC 0x1
[10454.620184] masked ExtINT on CPU#1
[10454.620184] numa_add_cpu cpu 1 node 0: mask now 0-1
[10455.775336] CPU0 attaching NULL sched-domain.
[10455.779381] CPU0 attaching sched-domain:
[10455.783072]  domain 0: span 0-1 level CPU
[10455.787199]   groups: 0 (cpu_power = 1022) 1
[10455.792101] CPU1 attaching sched-domain:
[10455.795508]  domain 0: span 0-1 level CPU
[10455.799502]   groups: 1 0 (cpu_power = 1022)
[10465.825888] CPU0 attaching NULL sched-domain.
[10465.828707] CPU1 attaching NULL sched-domain.
[10465.832439] CPU0 attaching NULL sched-domain.
[10465.839229] numa_remove_cpu cpu 1 node 0: mask now 0
[10465.845228] smpboot: CPU 1 is now offline
[10510.129171] rcu-torture: rtc: ffffffff82da41a0 ver: 1 tfle: 0 rta: 1 rtaf: 0 rtf: 0 rtmbe: 0 rtbke: 0 rtbre: 0 rtbf: 0 rtb: 0 nt: 4 onoff: 0/0:0/0 -1,0:-1,0 0:0 (HZ=1000) barrier: 0/0:0
[10510.129171] rcu-torture: Reader Pipe:  8 0 0 0 0 0 0 0 0 0 0
[10510.129171] rcu-torture: Reader Batch:  8 0 0 0 0 0 0 0 0 0 0
[10510.129171] rcu-torture: Free-Block Circulation:  0 0 0 0 0 0 0 0 0 0 0
[10565.899685] SMP alternatives: lockdep: fixing up alternatives
[10565.908467] smpboot: Booting Node 0 Processor 1 APIC 0x1
[10465.840126] masked ExtINT on CPU#1
[10465.840126] numa_add_cpu cpu 1 node 0: mask now 0-1
[10565.947180] CPU0 attaching NULL sched-domain.
[10565.950824] CPU0 attaching sched-domain:
[10565.954217]  domain 0: span 0-1 level CPU
[10565.958338]   groups: 0 (cpu_power = 1023) 1
[10565.962311] CPU1 attaching sched-domain:
[10565.965141]  domain 0: span 0-1 level CPU
[10565.968312]   groups: 1 0 (cpu_power = 1023)
[10565.994077] CPU0 attaching NULL sched-domain.
[10565.997351] CPU1 attaching NULL sched-domain.
[10566.000781] CPU0 attaching NULL sched-domain.
[10566.005588] numa_remove_cpu cpu 1 node 0: mask now 0
[10566.011466] smpboot: CPU 1 is now offline
[10566.146609] SMP alternatives: lockdep: fixing up alternatives
[10566.153101] smpboot: Booting Node 0 Processor 1 APIC 0x1
[10566.006025] masked ExtINT on CPU#1
[10566.006025] numa_add_cpu cpu 1 node 0: mask now 0-1
[10566.194669] CPU0 attaching NULL sched-domain.
[10566.198373] CPU0 attaching sched-domain:
[10566.201244]  domain 0: span 0-1 level CPU
[10566.204495]   groups: 0 (cpu_power = 1023) 1
[10566.208606] CPU1 attaching sched-domain:
[10566.211439]  domain 0: span 0-1 level CPU
[10566.214467]   groups: 1 0 (cpu_power = 1023)
[10567.243581] CPU0 attaching NULL sched-domain.
[10567.247423] CPU1 attaching NULL sched-domain.
[10567.251548] CPU0 attaching NULL sched-domain.
[10567.255714] numa_remove_cpu cpu 1 node 0: mask now 0
[10567.261385] smpboot: CPU 1 is now offline
[10570.153189] rcu-torture: rtc: ffffffff82da41a0 ver: 1 tfle: 0 rta: 1 rtaf: 0 rtf: 0 rtmbe: 0 rtbke: 0 rtbre: 0 rtbf: 0 rtb: 0 nt: 4 onoff: 0/0:0/0 -1,0:-1,0 0:0 (HZ=1000) barrier: 0/0:0
[10570.153189] rcu-torture: Reader Pipe:  8 0 0 0 0 0 0 0 0 0 0
[10570.153189] rcu-torture: Reader Batch:  8 0 0 0 0 0 0 0 0 0 0
[10570.153189] rcu-torture: Free-Block Circulation:  0 0 0 0 0 0 0 0 0 0 0
[10577.307451] SMP alternatives: lockdep: fixing up alternatives
[10577.334809] smpboot: Booting Node 0 Processor 1 APIC 0x1
[10567.256599] masked ExtINT on CPU#1
[10567.256599] numa_add_cpu cpu 1 node 0: mask now 0-1
[10577.374258] CPU0 attaching NULL sched-domain.
[10577.378240] CPU0 attaching sched-domain:
[10577.381762]  domain 0: span 0-1 level CPU
[10577.385525]   groups: 0 (cpu_power = 1023) 1
[10577.390375] CPU1 attaching sched-domain:
[10577.393730]  domain 0: span 0-1 level CPU
[10577.397528]   groups: 1 0 (cpu_power = 1023)
[10630.178249] rcu-torture: rtc: ffffffff82da41a0 ver: 1 tfle: 0 rta: 1 rtaf: 0 rtf: 0 rtmbe: 0 rtbke: 0 rtbre: 0 rtbf: 0 rtb: 0 nt: 4 onoff: 0/0:0/0 -1,0:-1,0 0:0 (HZ=1000) barrier: 0/0:0
[10630.178249] rcu-torture: Reader Pipe:  8 0 0 0 0 0 0 0 0 0 0
[10630.178249] rcu-torture: Reader Batch:  8 0 0 0 0 0 0 0 0 0 0
[10630.178249] rcu-torture: Free-Block Circulation:  0 0 0 0 0 0 0 0 0 0 0
[10677.436636] CPU0 attaching NULL sched-domain.
[10677.439751] CPU1 attaching NULL sched-domain.
[10677.443071] CPU0 attaching NULL sched-domain.
[10677.447889] numa_remove_cpu cpu 1 node 0: mask now 0
[10677.453422] smpboot: CPU 1 is now offline
[10677.522394] SMP alternatives: lockdep: fixing up alternatives
[10677.529288] smpboot: Booting Node 0 Processor 1 APIC 0x1
[10677.448304] masked ExtINT on CPU#1
[10677.448304] numa_add_cpu cpu 1 node 0: mask now 0-1
[10677.580513] CPU0 attaching NULL sched-domain.
[10677.585672] CPU0 attaching sched-domain:
[10677.589566]  domain 0: span 0-1 level CPU
[10677.593304]   groups: 0 (cpu_power = 1022) 1
[10677.597232] CPU1 attaching sched-domain:
[10677.600061]  domain 0: span 0-1 level CPU
[10677.603102]   groups: 1 0 (cpu_power = 1022)
[10677.732247] CPU0 attaching NULL sched-domain.
[10677.735196] CPU1 attaching NULL sched-domain.
[10677.738290] CPU0 attaching NULL sched-domain.
[10677.741823] numa_remove_cpu cpu 1 node 0: mask now 0
[10677.747153] smpboot: CPU 1 is now offline
[10678.789681] SMP alternatives: lockdep: fixing up alternatives
[10678.798693] smpboot: Booting Node 0 Processor 1 APIC 0x1
[10677.742739] masked ExtINT on CPU#1
[10677.742739] numa_add_cpu cpu 1 node 0: mask now 0-1
[10678.836961] CPU0 attaching NULL sched-domain.
[10678.840741] CPU0 attaching sched-domain:
[10678.843597]  domain 0: span 0-1 level CPU
[10678.846727]   groups: 0 (cpu_power = 1022) 1
[10678.850707] CPU1 attaching sched-domain:
[10678.854356]  domain 0: span 0-1 level CPU
[10678.857511]   groups: 1 0 (cpu_power = 1022)
[10688.882607] CPU0 attaching NULL sched-domain.
[10688.885904] CPU1 attaching NULL sched-domain.
[10688.889464] CPU0 attaching NULL sched-domain.
[10688.893384] numa_remove_cpu cpu 1 node 0: mask now 0
[10688.899135] smpboot: CPU 1 is now offline
[10690.210156] rcu-torture: rtc: ffffffff82da41a0 ver: 1 tfle: 0 rta: 1 rtaf: 0 rtf: 0 rtmbe: 0 rtbke: 0 rtbre: 0 rtbf: 0 rtb: 0 nt: 4 onoff: 0/0:0/0 -1,0:-1,0 0:0 (HZ=1000) barrier: 0/0:0
[10690.210156] rcu-torture: Reader Pipe:  8 0 0 0 0 0 0 0 0 0 0
[10690.210156] rcu-torture: Reader Batch:  8 0 0 0 0 0 0 0 0 0 0
[10690.210156] rcu-torture: Free-Block Circulation:  0 0 0 0 0 0 0 0 0 0 0
[10750.229271] rcu-torture: rtc: ffffffff82da41a0 ver: 1 tfle: 0 rta: 1 rtaf: 0 rtf: 0 rtmbe: 0 rtbke: 0 rtbre: 0 rtbf: 0 rtb: 0 nt: 4 onoff: 0/0:0/0 -1,0:-1,0 0:0 (HZ=1000) barrier: 0/0:0
[10750.229271] rcu-torture: Reader Pipe:  8 0 0 0 0 0 0 0 0 0 0
[10750.229271] rcu-torture: Reader Batch:  8 0 0 0 0 0 0 0 0 0 0
[10750.229271] rcu-torture: Free-Block Circulation:  0 0 0 0 0 0 0 0 0 0 0
[10788.952435] SMP alternatives: lockdep: fixing up alternatives
[10788.968188] smpboot: Booting Node 0 Processor 1 APIC 0x1
[10688.894287] masked ExtINT on CPU#1
[10688.894287] numa_add_cpu cpu 1 node 0: mask now 0-1
[10789.030830] CPU0 attaching NULL sched-domain.
[10789.094135] CPU0 attaching sched-domain:
[10789.100255]  domain 0: span 0-1 level CPU
[10789.109846]   groups: 0 (cpu_power = 1023) 1
[10789.117994] CPU1 attaching sched-domain:
[10789.127121]  domain 0: span 0-1 level CPU
[10789.133766]   groups: 1 0 (cpu_power = 1023)
[10789.212986] CPU0 attaching NULL sched-domain.
[10789.215835] CPU1 attaching NULL sched-domain.
[10789.218701] CPU0 attaching NULL sched-domain.
[10789.222620] numa_remove_cpu cpu 1 node 0: mask now 0
[10789.227953] smpboot: CPU 1 is now offline
[10789.372608] SMP alternatives: lockdep: fixing up alternatives
[10789.380594] smpboot: Booting Node 0 Processor 1 APIC 0x1
[10789.223027] masked ExtINT on CPU#1
[10789.223027] numa_add_cpu cpu 1 node 0: mask now 0-1
[10789.469594] CPU0 attaching NULL sched-domain.
[10789.473168] CPU0 attaching sched-domain:
[10789.475804]  domain 0: span 0-1 level CPU
[10789.478742]   groups: 0 (cpu_power = 976) 1
[10789.483305] CPU1 attaching sched-domain:
[10789.485933]  domain 0: span 0-1 level CPU
[10789.488947]   groups: 1 0 (cpu_power = 976)
[10790.528661] CPU0 attaching NULL sched-domain.
[10790.531738] CPU1 attaching NULL sched-domain.
[10790.534925] CPU0 attaching NULL sched-domain.
[10790.539229] numa_remove_cpu cpu 1 node 0: mask now 0
[10790.544243] smpboot: CPU 1 is now offline
[10800.602570] SMP alternatives: lockdep: fixing up alternatives
[10800.608509] smpboot: Booting Node 0 Processor 1 APIC 0x1
[10790.539999] masked ExtINT on CPU#1
[10790.539999] numa_add_cpu cpu 1 node 0: mask now 0-1
[10800.644947] CPU0 attaching NULL sched-domain.
[10800.647174] CPU0 attaching sched-domain:
[10800.649191]  domain 0: span 0-1 level CPU
[10800.651164]   groups: 0 (cpu_power = 1023) 1
[10800.653665] CPU1 attaching sched-domain:
[10800.655473]  domain 0: span 0-1 level CPU
[10800.657574]   groups: 1 0 (cpu_power = 1023)
[10810.249249] rcu-torture: rtc: ffffffff82da41a0 ver: 1 tfle: 0 rta: 1 rtaf: 0 rtf: 0 rtmbe: 0 rtbke: 0 rtbre: 0 rtbf: 0 rtb: 0 nt: 4 onoff: 0/0:0/0 -1,0:-1,0 0:0 (HZ=1000) barrier: 0/0:0
[10810.249249] rcu-torture: Reader Pipe:  8 0 0 0 0 0 0 0 0 0 0
[10810.249249] rcu-torture: Reader Batch:  8 0 0 0 0 0 0 0 0 0 0
[10810.249249] rcu-torture: Free-Block Circulation:  0 0 0 0 0 0 0 0 0 0 0
[10870.261177] rcu-torture: rtc: ffffffff82da41a0 ver: 1 tfle: 0 rta: 1 rtaf: 0 rtf: 0 rtmbe: 0 rtbke: 0 rtbre: 0 rtbf: 0 rtb: 0 nt: 4 onoff: 0/0:0/0 -1,0:-1,0 0:0 (HZ=1000) barrier: 0/0:0
[10870.261177] rcu-torture: Reader Pipe:  8 0 0 0 0 0 0 0 0 0 0
[10870.261177] rcu-torture: Reader Batch:  8 0 0 0 0 0 0 0 0 0 0
[10870.261177] rcu-torture: Free-Block Circulation:  0 0 0 0 0 0 0 0 0 0 0

BUG: kernel test hang
Elapsed time: 10805

--fUYQa+Pmc3FrFX/N
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="bisect-ade1335afef556df6538eb02e8c0dc91fbd9cc37-x86_64-nfsroot-xfs_sb_read_verify-25543.log"

git checkout f722406faae2d073cc1d01063d1123c35425939e
Previous HEAD position was ade1335... xfs: ensure btree root split sets blkno correctly
HEAD is now at f722406... Linux 3.10-rc1
ls -a /kernel-tests/run-queue/kvm/x86_64-nfsroot/xfs:for-next:f722406faae2d073cc1d01063d1123c35425939e:bisect-mm

2013-06-15-06:07:10 f722406faae2d073cc1d01063d1123c35425939e reuse /kernel/x86_64-nfsroot/f722406faae2d073cc1d01063d1123c35425939e/vmlinuz-3.10.0-rc1

2013-06-15-06:07:10 detecting boot state .	6	29	43	76	87	92.	98	100 SUCCESS

bisect: good commit f722406faae2d073cc1d01063d1123c35425939e
git bisect start ade1335afef556df6538eb02e8c0dc91fbd9cc37 f722406faae2d073cc1d01063d1123c35425939e --
Previous HEAD position was f722406... Linux 3.10-rc1
HEAD is now at c1be5a5... Linux 3.9
Bisecting: 15 revisions left to test after this (roughly 4 steps)
[d4c712bcf26a25c2b67c90e44e0b74c7993b5334] xfs: fully initialise temp leaf in xfs_attr3_leaf_compact
git bisect run /c/kernel-tests/bisect-test-boot-failure.sh /home/wfg/usb/obj-bisect
running /c/kernel-tests/bisect-test-boot-failure.sh /home/wfg/usb/obj-bisect
ls -a /kernel-tests/run-queue/kvm/x86_64-nfsroot/xfs:for-next:d4c712bcf26a25c2b67c90e44e0b74c7993b5334:bisect-mm

2013-06-15-06:12:23 d4c712bcf26a25c2b67c90e44e0b74c7993b5334 compiling
306 real  1460 user  117 sys  514.12% cpu 	x86_64-nfsroot

2013-06-15-06:18:08 detecting boot state 3.10.0-rc1-00015-gd4c712b....... TEST FAILURE
dmesg-kvm-stoakley-4592-20130615062107-3.10.0-rc1-00015-gd4c712b-18
dmesg-kvm-stoakley-5117-20130615062103-3.10.0-rc1-00015-gd4c712b-18
dmesg-kvm-stoakley-3678-20130615062113-3.10.0-rc1-00015-gd4c712b-18
dmesg-kvm-vp-15260-20130615062320-3.10.0-rc1-00015-gd4c712b-18
dmesg-kvm-vp-40909-20130615062324-3.10.0-rc1-00015-gd4c712b-18
dmesg-kvm-bens-7956-20130615062039-3.10.0-rc1-00015-gd4c712b-18
dmesg-kvm-stoakley-4282-20130615062122-3.10.0-rc1-00015-gd4c712b-18
dmesg-kvm-stoakley-4481-20130615062121-3.10.0-rc1-00015-gd4c712b-18
dmesg-kvm-vp-14836-20130615062330-3.10.0-rc1-00015-gd4c712b-18
dmesg-kvm-vp-15869-20130615062330-3.10.0-rc1-00015-gd4c712b-18
dmesg-kvm-vp-29296-20130615062332-3.10.0-rc1-00015-gd4c712b-18
dmesg-kvm-vp-32856-20130615062332-3.10.0-rc1-00015-gd4c712b-18
dmesg-kvm-vp-36600-20130615062331-3.10.0-rc1-00015-gd4c712b-18

Bisecting: 7 revisions left to test after this (roughly 3 steps)
[b38958d715316031fe9ea0cc6c22043072a55f49] xfs: xfs_attr_shortform_allfit() does not handle attr3 format.
running /c/kernel-tests/bisect-test-boot-failure.sh /home/wfg/usb/obj-bisect
ls -a /kernel-tests/run-queue/kvm/x86_64-nfsroot/xfs:for-next:b38958d715316031fe9ea0cc6c22043072a55f49:bisect-mm

2013-06-15-06:21:39 b38958d715316031fe9ea0cc6c22043072a55f49 compiling
153 real  1461 user  121 sys  1031.10% cpu 	x86_64-nfsroot

2013-06-15-06:24:25 detecting boot state 3.10.0-rc1-00007-gb38958d....... TEST FAILURE
dmesg-kvm-vp-13915-20130615062935-3.10.0-rc1-00007-gb38958d-19
dmesg-kvm-vp-20632-20130615062942-3.10.0-rc1-00007-gb38958d-19
dmesg-kvm-vp-30221-20130615062951-3.10.0-rc1-00007-gb38958d-19
dmesg-kvm-vp-31620-20130615062947-3.10.0-rc1-00007-gb38958d-19
dmesg-kvm-vp-28937-20130615062951-3.10.0-rc1-00007-gb38958d-19

Bisecting: 3 revisions left to test after this (roughly 2 steps)
[28ca489c63e9aceed8801d2f82d731b3c9aa50f5] xfs: fix rounding in xfs_free_file_space
running /c/kernel-tests/bisect-test-boot-failure.sh /home/wfg/usb/obj-bisect
ls -a /kernel-tests/run-queue/kvm/x86_64-nfsroot/xfs:for-next:28ca489c63e9aceed8801d2f82d731b3c9aa50f5:bisect-mm

2013-06-15-06:27:57 28ca489c63e9aceed8801d2f82d731b3c9aa50f5 compiling
175 real  1469 user  124 sys  906.68% cpu 	x86_64-nfsroot

2013-06-15-06:31:08 detecting boot state 3.10.0-rc1-00003-g28ca489.......	1 TEST FAILURE
dmesg-kvm-vp-12443-20130615063635-3.10.0-rc1-00003-g28ca489-20
dmesg-kvm-vp-13138-20130615063641-3.10.0-rc1-00003-g28ca489-20
dmesg-kvm-vp-20632-20130615063639-3.10.0-rc1-00003-g28ca489-20
dmesg-kvm-vp-20928-20130615063640-3.10.0-rc1-00003-g28ca489-20
dmesg-kvm-vp-22127-20130615063641-3.10.0-rc1-00003-g28ca489-20
dmesg-kvm-vp-22338-20130615063639-3.10.0-rc1-00003-g28ca489-20
dmesg-kvm-vp-29296-20130615063641-3.10.0-rc1-00003-g28ca489-20
dmesg-kvm-vp-41632-20130615063639-3.10.0-rc1-00003-g28ca489-20
dmesg-kvm-vp-19031-20130615063643-3.10.0-rc1-00003-g28ca489-20

Bisecting: 0 revisions left to test after this (roughly 1 step)
[49b137cbbcc836ef231866c137d24f42c42bb483] xfs: fix sub-page blocksize data integrity writes
running /c/kernel-tests/bisect-test-boot-failure.sh /home/wfg/usb/obj-bisect
ls -a /kernel-tests/run-queue/kvm/x86_64-nfsroot/xfs:for-next:49b137cbbcc836ef231866c137d24f42c42bb483:bisect-mm

2013-06-15-06:35:10 49b137cbbcc836ef231866c137d24f42c42bb483 compiling
139 real  1460 user  122 sys  1131.60% cpu 	x86_64-nfsroot

2013-06-15-06:37:41 detecting boot state 3.10.0-rc1-00002-g49b137c....... TEST FAILURE
dmesg-kvm-vp-13255-20130615064304-3.10.0-rc1-00002-g49b137c-21

Bisecting: 0 revisions left to test after this (roughly 0 steps)
[211d022c43cac3aecbe967fcaf9b10156bfa63ad] xfs: Avoid pathological backwards allocation
running /c/kernel-tests/bisect-test-boot-failure.sh /home/wfg/usb/obj-bisect
ls -a /kernel-tests/run-queue/kvm/x86_64-nfsroot/xfs:for-next:211d022c43cac3aecbe967fcaf9b10156bfa63ad:bisect-mm

2013-06-15-06:41:12 211d022c43cac3aecbe967fcaf9b10156bfa63ad compiling
143 real  1482 user  132 sys  1128.17% cpu 	x86_64-nfsroot

2013-06-15-06:43:46 detecting boot state 3.10.0-rc1-00001-g211d022....... TEST FAILURE
dmesg-kvm-stoakley-4481-20130615064637-3.10.0-rc1-00001-g211d022-22
dmesg-kvm-stoakley-4683-20130615064639-3.10.0-rc1-00001-g211d022-22
dmesg-kvm-stoakley-3678-20130615064644-3.10.0-rc1-00001-g211d022-22

211d022c43cac3aecbe967fcaf9b10156bfa63ad is the first bad commit
commit 211d022c43cac3aecbe967fcaf9b10156bfa63ad
Author: Jan Kara <jack@suse.cz>
Date:   Thu Apr 11 22:09:56 2013 +0200

    xfs: Avoid pathological backwards allocation
    
    Writing a large file using direct IO in 16 MB chunks sometimes results
    in a pathological allocation pattern where 16 MB chunks of large free
    extent are allocated to a file in a reversed order. So extents of a file
    look for example as:
    
     ext logical physical expected length flags
       0        0        13          4550656
       1  4550656 188136807   4550668 12562432
       2 17113088 200699240 200699238 622592
       3 17735680 182046055 201321831   4096
       4 17739776 182041959 182050150   4096
       5 17743872 182037863 182046054   4096
       6 17747968 182033767 182041958   4096
       7 17752064 182029671 182037862   4096
    ...
    6757 45400064 154381644 154389835   4096
    6758 45404160 154377548 154385739   4096
    6759 45408256 252951571 154381643  73728 eof
    
    This happens because XFS_ALLOCTYPE_THIS_BNO allocation fails (the last
    extent in the file cannot be further extended) so we fall back to
    XFS_ALLOCTYPE_NEAR_BNO allocation which picks end of a large free
    extent as the best place to continue the file. Since the chunk at the
    end of the free extent again cannot be further extended, this behavior
    repeats until the whole free extent is consumed in a reversed order.
    
    For data allocations this backward allocation isn't beneficial so make
    xfs_alloc_compute_diff() pick start of a free extent instead of its end
    for them. That avoids the backward allocation pattern.
    
    See thread at http://oss.sgi.com/archives/xfs/2013-03/msg00144.html for
    more details about the reproduction case and why this solution was
    chosen.
    
    Based on idea by Dave Chinner <dchinner@redhat.com>.
    
    CC: Dave Chinner <dchinner@redhat.com>
    Signed-off-by: Jan Kara <jack@suse.cz>
    Reviewed-by: Dave Chinner <dchinner@redhat.com>
    Reviewed-by: Mark Tinguely <tinguely@sgi.com>
    Signed-off-by: Ben Myers <bpm@sgi.com>

:040000 040000 e985da5ddb4802b70b70f5729bf8f2955dc75a1f 9adc5822188e0e0042dffaffc52196dd22440325 M	fs
bisect run success
ls -a /kernel-tests/run-queue/kvm/x86_64-nfsroot/xfs:for-next:f722406faae2d073cc1d01063d1123c35425939e:bisect-mm

2013-06-15-06:47:19 f722406faae2d073cc1d01063d1123c35425939e reuse /kernel/x86_64-nfsroot/f722406faae2d073cc1d01063d1123c35425939e/vmlinuz-3.10.0-rc1

2013-06-15-06:47:19 detecting boot state ..	6	21	25	37	40	51	60	61	63	73	86.	87	89	103	107..	116	123	129.	132	136	140	142..	145	153.	155	172	182	184	185	188	192	194.	195.	202.	206	207	214	215	217.	230	231.	235	239	241..	249	254	256	257	261	272	282	287.	294	298..	299.......................................................................................................................................................................................................................................................................................................	300 SUCCESS

ls -a /kernel-tests/run-queue/kvm/x86_64-nfsroot/xfs:for-next:ade1335afef556df6538eb02e8c0dc91fbd9cc37:bisect-mm
 TEST FAILURE
/kernel/x86_64-nfsroot/ade1335afef556df6538eb02e8c0dc91fbd9cc37/dmesg-kvm-kbuild-31646-20130615005640-3.10.0-rc1-00031-gade1335-1508
/kernel/x86_64-nfsroot/ade1335afef556df6538eb02e8c0dc91fbd9cc37/dmesg-kvm-stoakley-4353-20130615063155-3.10.0-rc1-00031-gade1335-1508
/kernel/x86_64-nfsroot/ade1335afef556df6538eb02e8c0dc91fbd9cc37/dmesg-kvm-vp-14105-20130615090604-3.10.0-rc1-00031-gade1335-1508
/kernel/x86_64-nfsroot/ade1335afef556df6538eb02e8c0dc91fbd9cc37/dmesg-kvm-xgwo-25228-20130615090438-3.10.0-rc1-00031-gade1335-1508

[detached HEAD 7872bbb] Revert "xfs: Avoid pathological backwards allocation"
 1 file changed, 6 insertions(+), 18 deletions(-)
ls -a /kernel-tests/run-queue/kvm/x86_64-nfsroot/xfs:for-next:7872bbb055d8070cdd8e7691d7a4181fbfa43caa:bisect-mm

2013-06-15-09:52:35 7872bbb055d8070cdd8e7691d7a4181fbfa43caa compiling

2013-06-15-09:55:30 detecting boot state 3.10.0-rc1-00032-g7872bbb......	2 TEST FAILURE
dmesg-kvm-vp-15998-20130615100040-3.10.0-rc1-00032-g7872bbb-23
dmesg-kvm-vp-13785-20130615100046-3.10.0-rc1-00032-g7872bbb-23
dmesg-kvm-vp-37754-20130615100046-3.10.0-rc1-00032-g7872bbb-23
dmesg-kvm-vp-28199-20130615100047-3.10.0-rc1-00032-g7872bbb-23


========= upstream =========
Fetching linus
ls -a /kernel-tests/run-queue/kvm/x86_64-nfsroot/xfs:for-next:a2648ebb7ed69ef209d9c8a76fadeb3252d9a023:bisect-mm

2013-06-15-09:59:03 a2648ebb7ed69ef209d9c8a76fadeb3252d9a023 reuse /kernel/x86_64-nfsroot/a2648ebb7ed69ef209d9c8a76fadeb3252d9a023/vmlinuz-3.10.0-rc5-00204-ga2648eb

2013-06-15-09:59:03 detecting boot state ........ TEST FAILURE
dmesg-kvm-stoakley-4683-20130615100228-3.10.0-rc5-00204-ga2648eb-1496
dmesg-kvm-stoakley-3899-20130615100255-3.10.0-rc5-00204-ga2648eb-1496
dmesg-kvm-stoakley-4592-20130615100255-3.10.0-rc5-00204-ga2648eb-1496


========= linux-next =========
Fetching next
ls -a /kernel-tests/run-queue/kvm/x86_64-nfsroot/xfs:for-next:c04efed734409f5a44715b54a6ca1b54b0ccf215:bisect-mm

2013-06-15-10:03:07 c04efed734409f5a44715b54a6ca1b54b0ccf215 reuse /kernel/x86_64-nfsroot/c04efed734409f5a44715b54a6ca1b54b0ccf215/vmlinuz-3.10.0-rc4-next-20130607

2013-06-15-10:03:07 detecting boot state ...... TEST FAILURE
dmesg-kvm-stoakley-3811-20130615100534-3.10.0-rc4-next-20130607-1297


--fUYQa+Pmc3FrFX/N
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename=".config-bisect"

#
# Automatically generated file; DO NOT EDIT.
# Linux/x86_64 3.10.0-rc1 Kernel Configuration
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
CONFIG_LOCALVERSION=""
CONFIG_LOCALVERSION_AUTO=y
CONFIG_HAVE_KERNEL_GZIP=y
CONFIG_HAVE_KERNEL_BZIP2=y
CONFIG_HAVE_KERNEL_LZMA=y
CONFIG_HAVE_KERNEL_XZ=y
CONFIG_HAVE_KERNEL_LZO=y
CONFIG_KERNEL_GZIP=y
# CONFIG_KERNEL_BZIP2 is not set
# CONFIG_KERNEL_LZMA is not set
# CONFIG_KERNEL_XZ is not set
# CONFIG_KERNEL_LZO is not set
CONFIG_DEFAULT_HOSTNAME="(none)"
CONFIG_SWAP=y
CONFIG_SYSVIPC=y
CONFIG_SYSVIPC_SYSCTL=y
CONFIG_POSIX_MQUEUE=y
CONFIG_POSIX_MQUEUE_SYSCTL=y
# CONFIG_FHANDLE is not set
CONFIG_AUDIT=y
CONFIG_AUDITSYSCALL=y
CONFIG_AUDIT_WATCH=y
CONFIG_AUDIT_TREE=y
# CONFIG_AUDIT_LOGINUID_IMMUTABLE is not set
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
CONFIG_NO_HZ_COMMON=y
# CONFIG_HZ_PERIODIC is not set
CONFIG_NO_HZ_IDLE=y
# CONFIG_NO_HZ_FULL is not set
CONFIG_NO_HZ=y
CONFIG_HIGH_RES_TIMERS=y

#
# CPU/Task time and stats accounting
#
CONFIG_TICK_CPU_ACCOUNTING=y
# CONFIG_VIRT_CPU_ACCOUNTING_GEN is not set
# CONFIG_IRQ_TIME_ACCOUNTING is not set
CONFIG_BSD_PROCESS_ACCT=y
CONFIG_BSD_PROCESS_ACCT_V3=y
CONFIG_TASKSTATS=y
CONFIG_TASK_DELAY_ACCT=y
CONFIG_TASK_XACCT=y
CONFIG_TASK_IO_ACCOUNTING=y

#
# RCU Subsystem
#
CONFIG_TREE_RCU=y
# CONFIG_PREEMPT_RCU is not set
CONFIG_RCU_STALL_COMMON=y
# CONFIG_RCU_USER_QS is not set
CONFIG_RCU_FANOUT=64
CONFIG_RCU_FANOUT_LEAF=16
# CONFIG_RCU_FANOUT_EXACT is not set
# CONFIG_RCU_FAST_NO_HZ is not set
CONFIG_TREE_RCU_TRACE=y
# CONFIG_RCU_NOCB_CPU is not set
CONFIG_IKCONFIG=y
CONFIG_IKCONFIG_PROC=y
CONFIG_LOG_BUF_SHIFT=18
CONFIG_HAVE_UNSTABLE_SCHED_CLOCK=y
CONFIG_ARCH_SUPPORTS_NUMA_BALANCING=y
CONFIG_ARCH_WANTS_PROT_NUMA_PROT_NONE=y
# CONFIG_NUMA_BALANCING is not set
CONFIG_CGROUPS=y
CONFIG_CGROUP_DEBUG=y
CONFIG_CGROUP_FREEZER=y
CONFIG_CGROUP_DEVICE=y
CONFIG_CPUSETS=y
CONFIG_PROC_PID_CPUSET=y
# CONFIG_CGROUP_CPUACCT is not set
CONFIG_RESOURCE_COUNTERS=y
# CONFIG_MEMCG is not set
# CONFIG_CGROUP_HUGETLB is not set
# CONFIG_CGROUP_PERF is not set
CONFIG_CGROUP_SCHED=y
CONFIG_FAIR_GROUP_SCHED=y
# CONFIG_CFS_BANDWIDTH is not set
# CONFIG_RT_GROUP_SCHED is not set
CONFIG_BLK_CGROUP=y
CONFIG_DEBUG_BLK_CGROUP=y
# CONFIG_CHECKPOINT_RESTORE is not set
# CONFIG_NAMESPACES is not set
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
CONFIG_CC_OPTIMIZE_FOR_SIZE=y
CONFIG_SYSCTL=y
CONFIG_ANON_INODES=y
CONFIG_HAVE_UID16=y
CONFIG_SYSCTL_EXCEPTION_TRACE=y
CONFIG_HOTPLUG=y
CONFIG_HAVE_PCSPKR_PLATFORM=y
CONFIG_EXPERT=y
CONFIG_UID16=y
CONFIG_SYSCTL_SYSCALL=y
CONFIG_KALLSYMS=y
CONFIG_KALLSYMS_ALL=y
CONFIG_PRINTK=y
CONFIG_BUG=y
CONFIG_ELF_CORE=y
CONFIG_PCSPKR_PLATFORM=y
CONFIG_BASE_FULL=y
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
CONFIG_SLUB_DEBUG=y
CONFIG_COMPAT_BRK=y
# CONFIG_SLAB is not set
CONFIG_SLUB=y
# CONFIG_SLOB is not set
CONFIG_PROFILING=y
CONFIG_TRACEPOINTS=y
CONFIG_OPROFILE=y
# CONFIG_OPROFILE_EVENT_MULTIPLEX is not set
CONFIG_HAVE_OPROFILE=y
CONFIG_OPROFILE_NMI_TIMER=y
CONFIG_KPROBES=y
# CONFIG_JUMP_LABEL is not set
CONFIG_OPTPROBES=y
CONFIG_KPROBES_ON_FTRACE=y
# CONFIG_HAVE_64BIT_ALIGNED_ACCESS is not set
CONFIG_HAVE_EFFICIENT_UNALIGNED_ACCESS=y
CONFIG_ARCH_USE_BUILTIN_BSWAP=y
CONFIG_KRETPROBES=y
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
# CONFIG_GCOV_KERNEL is not set
# CONFIG_HAVE_GENERIC_DMA_COHERENT is not set
CONFIG_SLABINFO=y
CONFIG_RT_MUTEXES=y
CONFIG_BASE_SMALL=0
CONFIG_MODULES=y
# CONFIG_MODULE_FORCE_LOAD is not set
CONFIG_MODULE_UNLOAD=y
CONFIG_MODULE_FORCE_UNLOAD=y
# CONFIG_MODVERSIONS is not set
# CONFIG_MODULE_SRCVERSION_ALL is not set
# CONFIG_MODULE_SIG is not set
CONFIG_STOP_MACHINE=y
CONFIG_BLOCK=y
CONFIG_BLK_DEV_BSG=y
CONFIG_BLK_DEV_BSGLIB=y
CONFIG_BLK_DEV_INTEGRITY=y
CONFIG_BLK_DEV_THROTTLING=y

#
# Partition Types
#
# CONFIG_PARTITION_ADVANCED is not set
CONFIG_MSDOS_PARTITION=y
CONFIG_EFI_PARTITION=y
CONFIG_BLOCK_COMPAT=y

#
# IO Schedulers
#
CONFIG_IOSCHED_NOOP=y
CONFIG_IOSCHED_DEADLINE=y
CONFIG_IOSCHED_CFQ=y
CONFIG_CFQ_GROUP_IOSCHED=y
# CONFIG_DEFAULT_DEADLINE is not set
CONFIG_DEFAULT_CFQ=y
# CONFIG_DEFAULT_NOOP is not set
CONFIG_DEFAULT_IOSCHED="cfq"
CONFIG_PREEMPT_NOTIFIERS=y
CONFIG_UNINLINE_SPIN_UNLOCK=y
CONFIG_FREEZER=y

#
# Processor type and features
#
CONFIG_ZONE_DMA=y
CONFIG_SMP=y
CONFIG_X86_MPPARSE=y
CONFIG_X86_EXTENDED_PLATFORM=y
# CONFIG_X86_VSMP is not set
# CONFIG_X86_INTEL_LPSS is not set
CONFIG_X86_SUPPORTS_MEMORY_FAILURE=y
# CONFIG_SCHED_OMIT_FRAME_POINTER is not set
# CONFIG_HYPERVISOR_GUEST is not set
CONFIG_NO_BOOTMEM=y
CONFIG_MEMTEST=y
# CONFIG_MK8 is not set
# CONFIG_MPSC is not set
CONFIG_MCORE2=y
# CONFIG_MATOM is not set
# CONFIG_GENERIC_CPU is not set
CONFIG_X86_INTERNODE_CACHE_SHIFT=6
CONFIG_X86_L1_CACHE_SHIFT=6
CONFIG_X86_INTEL_USERCOPY=y
CONFIG_X86_USE_PPRO_CHECKSUM=y
CONFIG_X86_P6_NOP=y
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
CONFIG_HPET_EMULATE_RTC=y
CONFIG_DMI=y
# CONFIG_CALGARY_IOMMU is not set
CONFIG_SWIOTLB=y
CONFIG_IOMMU_HELPER=y
# CONFIG_MAXSMP is not set
CONFIG_NR_CPUS=64
CONFIG_SCHED_SMT=y
CONFIG_SCHED_MC=y
# CONFIG_PREEMPT_NONE is not set
CONFIG_PREEMPT_VOLUNTARY=y
# CONFIG_PREEMPT is not set
CONFIG_PREEMPT_COUNT=y
CONFIG_X86_LOCAL_APIC=y
CONFIG_X86_IO_APIC=y
# CONFIG_X86_REROUTE_FOR_BROKEN_BOOT_IRQS is not set
CONFIG_X86_MCE=y
CONFIG_X86_MCE_INTEL=y
# CONFIG_X86_MCE_AMD is not set
CONFIG_X86_MCE_THRESHOLD=y
CONFIG_X86_MCE_INJECT=y
CONFIG_X86_THERMAL_VECTOR=y
# CONFIG_I8K is not set
CONFIG_MICROCODE=y
CONFIG_MICROCODE_INTEL=y
# CONFIG_MICROCODE_AMD is not set
CONFIG_MICROCODE_OLD_INTERFACE=y
CONFIG_MICROCODE_INTEL_LIB=y
CONFIG_MICROCODE_INTEL_EARLY=y
CONFIG_MICROCODE_EARLY=y
CONFIG_X86_MSR=y
CONFIG_X86_CPUID=y
CONFIG_ARCH_PHYS_ADDR_T_64BIT=y
CONFIG_ARCH_DMA_ADDR_T_64BIT=y
CONFIG_DIRECT_GBPAGES=y
CONFIG_NUMA=y
CONFIG_AMD_NUMA=y
CONFIG_X86_64_ACPI_NUMA=y
CONFIG_NODES_SPAN_OTHER_NODES=y
CONFIG_NUMA_EMU=y
CONFIG_NODES_SHIFT=6
CONFIG_ARCH_SPARSEMEM_ENABLE=y
CONFIG_ARCH_SPARSEMEM_DEFAULT=y
CONFIG_ARCH_SELECT_MEMORY_MODEL=y
CONFIG_ARCH_MEMORY_PROBE=y
CONFIG_ARCH_PROC_KCORE_TEXT=y
CONFIG_ILLEGAL_POINTER_VALUE=0xdead000000000000
CONFIG_SELECT_MEMORY_MODEL=y
CONFIG_SPARSEMEM_MANUAL=y
CONFIG_SPARSEMEM=y
CONFIG_NEED_MULTIPLE_NODES=y
CONFIG_HAVE_MEMORY_PRESENT=y
CONFIG_SPARSEMEM_EXTREME=y
CONFIG_SPARSEMEM_VMEMMAP_ENABLE=y
CONFIG_SPARSEMEM_ALLOC_MEM_MAP_TOGETHER=y
CONFIG_SPARSEMEM_VMEMMAP=y
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
CONFIG_BOUNCE=y
CONFIG_NEED_BOUNCE_POOL=y
CONFIG_VIRT_TO_BUS=y
CONFIG_MMU_NOTIFIER=y
CONFIG_KSM=y
CONFIG_DEFAULT_MMAP_MIN_ADDR=4096
CONFIG_ARCH_SUPPORTS_MEMORY_FAILURE=y
CONFIG_MEMORY_FAILURE=y
CONFIG_HWPOISON_INJECT=y
# CONFIG_TRANSPARENT_HUGEPAGE is not set
CONFIG_CROSS_MEMORY_ATTACH=y
# CONFIG_CLEANCACHE is not set
# CONFIG_FRONTSWAP is not set
CONFIG_X86_CHECK_BIOS_CORRUPTION=y
CONFIG_X86_BOOTPARAM_MEMORY_CORRUPTION_CHECK=y
CONFIG_X86_RESERVE_LOW=64
CONFIG_MTRR=y
# CONFIG_MTRR_SANITIZER is not set
CONFIG_X86_PAT=y
CONFIG_ARCH_USES_PG_UNCACHED=y
CONFIG_ARCH_RANDOM=y
CONFIG_X86_SMAP=y
CONFIG_EFI=y
# CONFIG_EFI_STUB is not set
CONFIG_SECCOMP=y
# CONFIG_CC_STACKPROTECTOR is not set
# CONFIG_HZ_100 is not set
# CONFIG_HZ_250 is not set
# CONFIG_HZ_300 is not set
CONFIG_HZ_1000=y
CONFIG_HZ=1000
CONFIG_SCHED_HRTICK=y
CONFIG_KEXEC=y
CONFIG_CRASH_DUMP=y
# CONFIG_KEXEC_JUMP is not set
CONFIG_PHYSICAL_START=0x1000000
CONFIG_RELOCATABLE=y
CONFIG_PHYSICAL_ALIGN=0x1000000
CONFIG_HOTPLUG_CPU=y
# CONFIG_BOOTPARAM_HOTPLUG_CPU0 is not set
# CONFIG_DEBUG_HOTPLUG_CPU0 is not set
CONFIG_COMPAT_VDSO=y
# CONFIG_CMDLINE_BOOL is not set
CONFIG_ARCH_ENABLE_MEMORY_HOTPLUG=y
CONFIG_ARCH_ENABLE_MEMORY_HOTREMOVE=y
CONFIG_USE_PERCPU_NUMA_NODE_ID=y

#
# Power management and ACPI options
#
CONFIG_ARCH_HIBERNATION_HEADER=y
CONFIG_SUSPEND=y
CONFIG_SUSPEND_FREEZER=y
CONFIG_HIBERNATE_CALLBACKS=y
CONFIG_HIBERNATION=y
CONFIG_PM_STD_PARTITION=""
CONFIG_PM_SLEEP=y
CONFIG_PM_SLEEP_SMP=y
# CONFIG_PM_AUTOSLEEP is not set
# CONFIG_PM_WAKELOCKS is not set
CONFIG_PM_RUNTIME=y
CONFIG_PM=y
CONFIG_PM_DEBUG=y
CONFIG_PM_ADVANCED_DEBUG=y
CONFIG_PM_TEST_SUSPEND=y
CONFIG_PM_SLEEP_DEBUG=y
CONFIG_PM_TRACE=y
CONFIG_PM_TRACE_RTC=y
CONFIG_ACPI=y
CONFIG_ACPI_SLEEP=y
CONFIG_ACPI_PROCFS=y
CONFIG_ACPI_PROCFS_POWER=y
CONFIG_ACPI_EC_DEBUGFS=y
CONFIG_ACPI_PROC_EVENT=y
CONFIG_ACPI_AC=y
CONFIG_ACPI_BATTERY=y
CONFIG_ACPI_BUTTON=y
CONFIG_ACPI_VIDEO=y
CONFIG_ACPI_FAN=y
CONFIG_ACPI_DOCK=y
CONFIG_ACPI_I2C=y
CONFIG_ACPI_PROCESSOR=y
CONFIG_ACPI_HOTPLUG_CPU=y
# CONFIG_ACPI_PROCESSOR_AGGREGATOR is not set
CONFIG_ACPI_THERMAL=y
CONFIG_ACPI_NUMA=y
CONFIG_ACPI_CUSTOM_DSDT_FILE=""
# CONFIG_ACPI_CUSTOM_DSDT is not set
# CONFIG_ACPI_INITRD_TABLE_OVERRIDE is not set
CONFIG_ACPI_BLACKLIST_YEAR=0
CONFIG_ACPI_DEBUG=y
CONFIG_ACPI_PCI_SLOT=y
CONFIG_X86_PM_TIMER=y
CONFIG_ACPI_CONTAINER=y
# CONFIG_ACPI_HOTPLUG_MEMORY is not set
CONFIG_ACPI_SBS=y
# CONFIG_ACPI_HED is not set
# CONFIG_ACPI_CUSTOM_METHOD is not set
# CONFIG_ACPI_BGRT is not set
# CONFIG_ACPI_APEI is not set
# CONFIG_SFI is not set

#
# CPU Frequency scaling
#
CONFIG_CPU_FREQ=y
CONFIG_CPU_FREQ_TABLE=y
CONFIG_CPU_FREQ_GOV_COMMON=y
CONFIG_CPU_FREQ_STAT=y
CONFIG_CPU_FREQ_STAT_DETAILS=y
# CONFIG_CPU_FREQ_DEFAULT_GOV_PERFORMANCE is not set
# CONFIG_CPU_FREQ_DEFAULT_GOV_POWERSAVE is not set
# CONFIG_CPU_FREQ_DEFAULT_GOV_USERSPACE is not set
CONFIG_CPU_FREQ_DEFAULT_GOV_ONDEMAND=y
# CONFIG_CPU_FREQ_DEFAULT_GOV_CONSERVATIVE is not set
CONFIG_CPU_FREQ_GOV_PERFORMANCE=y
CONFIG_CPU_FREQ_GOV_POWERSAVE=y
CONFIG_CPU_FREQ_GOV_USERSPACE=y
CONFIG_CPU_FREQ_GOV_ONDEMAND=y
CONFIG_CPU_FREQ_GOV_CONSERVATIVE=y

#
# x86 CPU frequency scaling drivers
#
# CONFIG_X86_INTEL_PSTATE is not set
# CONFIG_X86_PCC_CPUFREQ is not set
CONFIG_X86_ACPI_CPUFREQ=y
# CONFIG_X86_POWERNOW_K8 is not set
CONFIG_X86_SPEEDSTEP_CENTRINO=y
# CONFIG_X86_P4_CLOCKMOD is not set

#
# shared options
#
# CONFIG_X86_SPEEDSTEP_LIB is not set
CONFIG_CPU_IDLE=y
# CONFIG_CPU_IDLE_MULTIPLE_DRIVERS is not set
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
CONFIG_PCI_MMCONFIG=y
CONFIG_PCI_DOMAINS=y
# CONFIG_PCI_CNB20LE_QUIRK is not set
CONFIG_PCIEPORTBUS=y
# CONFIG_HOTPLUG_PCI_PCIE is not set
CONFIG_PCIEAER=y
# CONFIG_PCIE_ECRC is not set
# CONFIG_PCIEAER_INJECT is not set
# CONFIG_PCIEASPM is not set
CONFIG_PCIE_PME=y
CONFIG_ARCH_SUPPORTS_MSI=y
CONFIG_PCI_MSI=y
# CONFIG_PCI_DEBUG is not set
# CONFIG_PCI_REALLOC_ENABLE_AUTO is not set
# CONFIG_PCI_STUB is not set
CONFIG_HT_IRQ=y
# CONFIG_PCI_IOV is not set
# CONFIG_PCI_PRI is not set
# CONFIG_PCI_PASID is not set
CONFIG_PCI_IOAPIC=y
CONFIG_PCI_LABEL=y
CONFIG_ISA_DMA_API=y
# CONFIG_PCCARD is not set
CONFIG_HOTPLUG_PCI=y
# CONFIG_HOTPLUG_PCI_ACPI is not set
# CONFIG_HOTPLUG_PCI_CPCI is not set
# CONFIG_HOTPLUG_PCI_SHPC is not set
# CONFIG_RAPIDIO is not set

#
# Executable file formats / Emulations
#
CONFIG_BINFMT_ELF=y
CONFIG_COMPAT_BINFMT_ELF=y
CONFIG_ARCH_BINFMT_ELF_RANDOMIZE_PIE=y
# CONFIG_CORE_DUMP_DEFAULT_ELF_HEADERS is not set
CONFIG_BINFMT_SCRIPT=y
# CONFIG_HAVE_AOUT is not set
# CONFIG_BINFMT_MISC is not set
CONFIG_COREDUMP=y
CONFIG_IA32_EMULATION=y
# CONFIG_IA32_AOUT is not set
# CONFIG_X86_X32 is not set
CONFIG_COMPAT=y
CONFIG_COMPAT_FOR_U64_ALIGNMENT=y
CONFIG_SYSVIPC_COMPAT=y
CONFIG_KEYS_COMPAT=y
CONFIG_HAVE_TEXT_POKE_SMP=y
CONFIG_X86_DEV_DMA_OPS=y
CONFIG_NET=y

#
# Networking options
#
CONFIG_PACKET=y
# CONFIG_PACKET_DIAG is not set
CONFIG_UNIX=y
# CONFIG_UNIX_DIAG is not set
CONFIG_XFRM=y
CONFIG_XFRM_ALGO=y
CONFIG_XFRM_USER=y
# CONFIG_XFRM_SUB_POLICY is not set
# CONFIG_XFRM_MIGRATE is not set
# CONFIG_XFRM_STATISTICS is not set
CONFIG_XFRM_IPCOMP=y
CONFIG_NET_KEY=y
# CONFIG_NET_KEY_MIGRATE is not set
CONFIG_INET=y
# CONFIG_IP_MULTICAST is not set
# CONFIG_IP_ADVANCED_ROUTER is not set
CONFIG_IP_ROUTE_CLASSID=y
CONFIG_IP_PNP=y
CONFIG_IP_PNP_DHCP=y
# CONFIG_IP_PNP_BOOTP is not set
# CONFIG_IP_PNP_RARP is not set
# CONFIG_NET_IPIP is not set
# CONFIG_NET_IPGRE_DEMUX is not set
CONFIG_NET_IP_TUNNEL=y
# CONFIG_ARPD is not set
# CONFIG_SYN_COOKIES is not set
CONFIG_INET_AH=y
CONFIG_INET_ESP=y
CONFIG_INET_IPCOMP=y
CONFIG_INET_XFRM_TUNNEL=y
CONFIG_INET_TUNNEL=y
# CONFIG_INET_XFRM_MODE_TRANSPORT is not set
# CONFIG_INET_XFRM_MODE_TUNNEL is not set
# CONFIG_INET_XFRM_MODE_BEET is not set
CONFIG_INET_LRO=y
CONFIG_INET_DIAG=y
CONFIG_INET_TCP_DIAG=y
# CONFIG_INET_UDP_DIAG is not set
CONFIG_TCP_CONG_ADVANCED=y
CONFIG_TCP_CONG_BIC=y
CONFIG_TCP_CONG_CUBIC=y
CONFIG_TCP_CONG_WESTWOOD=y
CONFIG_TCP_CONG_HTCP=y
CONFIG_TCP_CONG_HSTCP=y
CONFIG_TCP_CONG_HYBLA=y
CONFIG_TCP_CONG_VEGAS=y
CONFIG_TCP_CONG_SCALABLE=y
CONFIG_TCP_CONG_LP=y
CONFIG_TCP_CONG_VENO=y
CONFIG_TCP_CONG_YEAH=y
CONFIG_TCP_CONG_ILLINOIS=y
# CONFIG_DEFAULT_BIC is not set
CONFIG_DEFAULT_CUBIC=y
# CONFIG_DEFAULT_HTCP is not set
# CONFIG_DEFAULT_HYBLA is not set
# CONFIG_DEFAULT_VEGAS is not set
# CONFIG_DEFAULT_VENO is not set
# CONFIG_DEFAULT_WESTWOOD is not set
# CONFIG_DEFAULT_RENO is not set
CONFIG_DEFAULT_TCP_CONG="cubic"
# CONFIG_TCP_MD5SIG is not set
CONFIG_IPV6=y
# CONFIG_IPV6_PRIVACY is not set
# CONFIG_IPV6_ROUTER_PREF is not set
# CONFIG_IPV6_OPTIMISTIC_DAD is not set
# CONFIG_INET6_AH is not set
# CONFIG_INET6_ESP is not set
# CONFIG_INET6_IPCOMP is not set
# CONFIG_IPV6_MIP6 is not set
# CONFIG_INET6_XFRM_TUNNEL is not set
# CONFIG_INET6_TUNNEL is not set
CONFIG_INET6_XFRM_MODE_TRANSPORT=y
CONFIG_INET6_XFRM_MODE_TUNNEL=y
CONFIG_INET6_XFRM_MODE_BEET=y
# CONFIG_INET6_XFRM_MODE_ROUTEOPTIMIZATION is not set
CONFIG_IPV6_SIT=y
# CONFIG_IPV6_SIT_6RD is not set
CONFIG_IPV6_NDISC_NODETYPE=y
# CONFIG_IPV6_TUNNEL is not set
# CONFIG_IPV6_GRE is not set
# CONFIG_IPV6_MULTIPLE_TABLES is not set
# CONFIG_IPV6_MROUTE is not set
# CONFIG_NETWORK_SECMARK is not set
# CONFIG_NETWORK_PHY_TIMESTAMPING is not set
CONFIG_NETFILTER=y
# CONFIG_NETFILTER_DEBUG is not set
CONFIG_NETFILTER_ADVANCED=y
CONFIG_BRIDGE_NETFILTER=y

#
# Core Netfilter Configuration
#
CONFIG_NETFILTER_NETLINK=y
# CONFIG_NETFILTER_NETLINK_ACCT is not set
CONFIG_NETFILTER_NETLINK_QUEUE=y
CONFIG_NETFILTER_NETLINK_LOG=y
CONFIG_NF_CONNTRACK=y
CONFIG_NF_CONNTRACK_MARK=y
CONFIG_NF_CONNTRACK_ZONES=y
CONFIG_NF_CONNTRACK_PROCFS=y
CONFIG_NF_CONNTRACK_EVENTS=y
# CONFIG_NF_CONNTRACK_TIMEOUT is not set
# CONFIG_NF_CONNTRACK_TIMESTAMP is not set
CONFIG_NF_CT_PROTO_DCCP=y
CONFIG_NF_CT_PROTO_GRE=y
CONFIG_NF_CT_PROTO_SCTP=y
CONFIG_NF_CT_PROTO_UDPLITE=y
CONFIG_NF_CONNTRACK_AMANDA=y
CONFIG_NF_CONNTRACK_FTP=y
CONFIG_NF_CONNTRACK_H323=y
CONFIG_NF_CONNTRACK_IRC=y
CONFIG_NF_CONNTRACK_BROADCAST=y
CONFIG_NF_CONNTRACK_NETBIOS_NS=y
# CONFIG_NF_CONNTRACK_SNMP is not set
CONFIG_NF_CONNTRACK_PPTP=y
CONFIG_NF_CONNTRACK_SANE=y
CONFIG_NF_CONNTRACK_SIP=y
CONFIG_NF_CONNTRACK_TFTP=y
CONFIG_NF_CT_NETLINK=y
# CONFIG_NF_CT_NETLINK_TIMEOUT is not set
# CONFIG_NETFILTER_NETLINK_QUEUE_CT is not set
CONFIG_NETFILTER_TPROXY=y
CONFIG_NETFILTER_XTABLES=y

#
# Xtables combined modules
#
CONFIG_NETFILTER_XT_MARK=y
CONFIG_NETFILTER_XT_CONNMARK=y

#
# Xtables targets
#
# CONFIG_NETFILTER_XT_TARGET_AUDIT is not set
CONFIG_NETFILTER_XT_TARGET_CHECKSUM=y
CONFIG_NETFILTER_XT_TARGET_CLASSIFY=y
CONFIG_NETFILTER_XT_TARGET_CONNMARK=y
CONFIG_NETFILTER_XT_TARGET_CT=y
CONFIG_NETFILTER_XT_TARGET_DSCP=y
CONFIG_NETFILTER_XT_TARGET_HL=y
# CONFIG_NETFILTER_XT_TARGET_HMARK is not set
CONFIG_NETFILTER_XT_TARGET_IDLETIMER=y
CONFIG_NETFILTER_XT_TARGET_LED=y
# CONFIG_NETFILTER_XT_TARGET_LOG is not set
CONFIG_NETFILTER_XT_TARGET_MARK=y
CONFIG_NETFILTER_XT_TARGET_NFLOG=y
CONFIG_NETFILTER_XT_TARGET_NFQUEUE=y
CONFIG_NETFILTER_XT_TARGET_NOTRACK=y
CONFIG_NETFILTER_XT_TARGET_RATEEST=y
CONFIG_NETFILTER_XT_TARGET_TEE=y
CONFIG_NETFILTER_XT_TARGET_TPROXY=y
CONFIG_NETFILTER_XT_TARGET_TRACE=y
CONFIG_NETFILTER_XT_TARGET_TCPMSS=y
CONFIG_NETFILTER_XT_TARGET_TCPOPTSTRIP=y

#
# Xtables matches
#
# CONFIG_NETFILTER_XT_MATCH_ADDRTYPE is not set
# CONFIG_NETFILTER_XT_MATCH_BPF is not set
CONFIG_NETFILTER_XT_MATCH_CLUSTER=y
CONFIG_NETFILTER_XT_MATCH_COMMENT=y
CONFIG_NETFILTER_XT_MATCH_CONNBYTES=y
# CONFIG_NETFILTER_XT_MATCH_CONNLABEL is not set
CONFIG_NETFILTER_XT_MATCH_CONNLIMIT=y
CONFIG_NETFILTER_XT_MATCH_CONNMARK=y
CONFIG_NETFILTER_XT_MATCH_CONNTRACK=y
CONFIG_NETFILTER_XT_MATCH_CPU=y
CONFIG_NETFILTER_XT_MATCH_DCCP=y
# CONFIG_NETFILTER_XT_MATCH_DEVGROUP is not set
CONFIG_NETFILTER_XT_MATCH_DSCP=y
CONFIG_NETFILTER_XT_MATCH_ECN=y
CONFIG_NETFILTER_XT_MATCH_ESP=y
CONFIG_NETFILTER_XT_MATCH_HASHLIMIT=y
CONFIG_NETFILTER_XT_MATCH_HELPER=y
CONFIG_NETFILTER_XT_MATCH_HL=y
CONFIG_NETFILTER_XT_MATCH_IPRANGE=y
CONFIG_NETFILTER_XT_MATCH_LENGTH=y
CONFIG_NETFILTER_XT_MATCH_LIMIT=y
CONFIG_NETFILTER_XT_MATCH_MAC=y
CONFIG_NETFILTER_XT_MATCH_MARK=y
CONFIG_NETFILTER_XT_MATCH_MULTIPORT=y
# CONFIG_NETFILTER_XT_MATCH_NFACCT is not set
CONFIG_NETFILTER_XT_MATCH_OSF=y
CONFIG_NETFILTER_XT_MATCH_OWNER=y
CONFIG_NETFILTER_XT_MATCH_POLICY=y
CONFIG_NETFILTER_XT_MATCH_PHYSDEV=y
CONFIG_NETFILTER_XT_MATCH_PKTTYPE=y
CONFIG_NETFILTER_XT_MATCH_QUOTA=y
CONFIG_NETFILTER_XT_MATCH_RATEEST=y
CONFIG_NETFILTER_XT_MATCH_REALM=y
CONFIG_NETFILTER_XT_MATCH_RECENT=y
CONFIG_NETFILTER_XT_MATCH_SCTP=y
CONFIG_NETFILTER_XT_MATCH_SOCKET=y
CONFIG_NETFILTER_XT_MATCH_STATE=y
CONFIG_NETFILTER_XT_MATCH_STATISTIC=y
CONFIG_NETFILTER_XT_MATCH_STRING=y
CONFIG_NETFILTER_XT_MATCH_TCPMSS=y
CONFIG_NETFILTER_XT_MATCH_TIME=y
CONFIG_NETFILTER_XT_MATCH_U32=y
# CONFIG_IP_SET is not set
# CONFIG_IP_VS is not set

#
# IP: Netfilter Configuration
#
CONFIG_NF_DEFRAG_IPV4=y
CONFIG_NF_CONNTRACK_IPV4=y
CONFIG_NF_CONNTRACK_PROC_COMPAT=y
CONFIG_IP_NF_IPTABLES=y
CONFIG_IP_NF_MATCH_AH=y
CONFIG_IP_NF_MATCH_ECN=y
# CONFIG_IP_NF_MATCH_RPFILTER is not set
CONFIG_IP_NF_MATCH_TTL=y
CONFIG_IP_NF_FILTER=y
CONFIG_IP_NF_TARGET_REJECT=y
CONFIG_IP_NF_TARGET_ULOG=y
# CONFIG_NF_NAT_IPV4 is not set
CONFIG_IP_NF_MANGLE=y
CONFIG_IP_NF_TARGET_CLUSTERIP=y
CONFIG_IP_NF_TARGET_ECN=y
CONFIG_IP_NF_TARGET_TTL=y
CONFIG_IP_NF_RAW=y
CONFIG_IP_NF_ARPTABLES=y
CONFIG_IP_NF_ARPFILTER=y
CONFIG_IP_NF_ARP_MANGLE=y

#
# IPv6: Netfilter Configuration
#
# CONFIG_NF_DEFRAG_IPV6 is not set
# CONFIG_NF_CONNTRACK_IPV6 is not set
# CONFIG_IP6_NF_IPTABLES is not set
CONFIG_BRIDGE_NF_EBTABLES=y
CONFIG_BRIDGE_EBT_BROUTE=y
CONFIG_BRIDGE_EBT_T_FILTER=y
CONFIG_BRIDGE_EBT_T_NAT=y
CONFIG_BRIDGE_EBT_802_3=y
CONFIG_BRIDGE_EBT_AMONG=y
CONFIG_BRIDGE_EBT_ARP=y
CONFIG_BRIDGE_EBT_IP=y
# CONFIG_BRIDGE_EBT_IP6 is not set
CONFIG_BRIDGE_EBT_LIMIT=y
CONFIG_BRIDGE_EBT_MARK=y
CONFIG_BRIDGE_EBT_PKTTYPE=y
CONFIG_BRIDGE_EBT_STP=y
CONFIG_BRIDGE_EBT_VLAN=y
CONFIG_BRIDGE_EBT_ARPREPLY=y
CONFIG_BRIDGE_EBT_DNAT=y
CONFIG_BRIDGE_EBT_MARK_T=y
CONFIG_BRIDGE_EBT_REDIRECT=y
CONFIG_BRIDGE_EBT_SNAT=y
CONFIG_BRIDGE_EBT_LOG=y
CONFIG_BRIDGE_EBT_ULOG=y
CONFIG_BRIDGE_EBT_NFLOG=y
# CONFIG_IP_DCCP is not set
# CONFIG_IP_SCTP is not set
# CONFIG_RDS is not set
# CONFIG_TIPC is not set
# CONFIG_ATM is not set
# CONFIG_L2TP is not set
CONFIG_STP=y
CONFIG_BRIDGE=y
CONFIG_BRIDGE_IGMP_SNOOPING=y
CONFIG_HAVE_NET_DSA=y
# CONFIG_VLAN_8021Q is not set
# CONFIG_DECNET is not set
CONFIG_LLC=y
# CONFIG_LLC2 is not set
# CONFIG_IPX is not set
# CONFIG_ATALK is not set
# CONFIG_X25 is not set
# CONFIG_LAPB is not set
# CONFIG_PHONET is not set
# CONFIG_IEEE802154 is not set
CONFIG_NET_SCHED=y

#
# Queueing/Scheduling
#
# CONFIG_NET_SCH_CBQ is not set
# CONFIG_NET_SCH_HTB is not set
# CONFIG_NET_SCH_HFSC is not set
# CONFIG_NET_SCH_PRIO is not set
# CONFIG_NET_SCH_MULTIQ is not set
# CONFIG_NET_SCH_RED is not set
# CONFIG_NET_SCH_SFB is not set
# CONFIG_NET_SCH_SFQ is not set
# CONFIG_NET_SCH_TEQL is not set
# CONFIG_NET_SCH_TBF is not set
# CONFIG_NET_SCH_GRED is not set
# CONFIG_NET_SCH_DSMARK is not set
CONFIG_NET_SCH_NETEM=y
# CONFIG_NET_SCH_DRR is not set
# CONFIG_NET_SCH_MQPRIO is not set
# CONFIG_NET_SCH_CHOKE is not set
# CONFIG_NET_SCH_QFQ is not set
# CONFIG_NET_SCH_CODEL is not set
# CONFIG_NET_SCH_FQ_CODEL is not set
# CONFIG_NET_SCH_PLUG is not set

#
# Classification
#
# CONFIG_NET_CLS_BASIC is not set
# CONFIG_NET_CLS_TCINDEX is not set
# CONFIG_NET_CLS_ROUTE4 is not set
# CONFIG_NET_CLS_FW is not set
# CONFIG_NET_CLS_U32 is not set
# CONFIG_NET_CLS_RSVP is not set
# CONFIG_NET_CLS_RSVP6 is not set
# CONFIG_NET_CLS_FLOW is not set
# CONFIG_NET_CLS_CGROUP is not set
# CONFIG_NET_EMATCH is not set
# CONFIG_NET_CLS_ACT is not set
CONFIG_NET_SCH_FIFO=y
# CONFIG_DCB is not set
CONFIG_DNS_RESOLVER=y
# CONFIG_BATMAN_ADV is not set
# CONFIG_OPENVSWITCH is not set
# CONFIG_VSOCKETS is not set
# CONFIG_NETLINK_MMAP is not set
# CONFIG_NETLINK_DIAG is not set
CONFIG_RPS=y
CONFIG_RFS_ACCEL=y
CONFIG_XPS=y
# CONFIG_NETPRIO_CGROUP is not set
CONFIG_BQL=y
# CONFIG_BPF_JIT is not set

#
# Network testing
#
# CONFIG_NET_PKTGEN is not set
# CONFIG_NET_TCPPROBE is not set
# CONFIG_NET_DROP_MONITOR is not set
# CONFIG_HAMRADIO is not set
# CONFIG_CAN is not set
# CONFIG_IRDA is not set
# CONFIG_BT is not set
# CONFIG_AF_RXRPC is not set
# CONFIG_WIRELESS is not set
# CONFIG_WIMAX is not set
# CONFIG_RFKILL is not set
CONFIG_NET_9P=y
CONFIG_NET_9P_VIRTIO=y
# CONFIG_NET_9P_DEBUG is not set
# CONFIG_CAIF is not set
# CONFIG_CEPH_LIB is not set
# CONFIG_NFC is not set
CONFIG_HAVE_BPF_JIT=y

#
# Device Drivers
#

#
# Generic Driver Options
#
CONFIG_UEVENT_HELPER_PATH="/sbin/hotplug"
CONFIG_DEVTMPFS=y
CONFIG_DEVTMPFS_MOUNT=y
# CONFIG_STANDALONE is not set
# CONFIG_PREVENT_FIRMWARE_BUILD is not set
CONFIG_FW_LOADER=y
CONFIG_FIRMWARE_IN_KERNEL=y
CONFIG_EXTRA_FIRMWARE=""
CONFIG_FW_LOADER_USER_HELPER=y
# CONFIG_DEBUG_DRIVER is not set
# CONFIG_DEBUG_DEVRES is not set
# CONFIG_SYS_HYPERVISOR is not set
# CONFIG_GENERIC_CPU_DEVICES is not set
CONFIG_DMA_SHARED_BUFFER=y

#
# Bus devices
#
CONFIG_CONNECTOR=y
CONFIG_PROC_EVENTS=y
# CONFIG_MTD is not set
# CONFIG_PARPORT is not set
CONFIG_PNP=y
CONFIG_PNP_DEBUG_MESSAGES=y

#
# Protocols
#
CONFIG_PNPACPI=y
CONFIG_BLK_DEV=y
CONFIG_BLK_DEV_FD=y
# CONFIG_BLK_DEV_PCIESSD_MTIP32XX is not set
# CONFIG_BLK_CPQ_DA is not set
# CONFIG_BLK_CPQ_CISS_DA is not set
# CONFIG_BLK_DEV_DAC960 is not set
# CONFIG_BLK_DEV_UMEM is not set
# CONFIG_BLK_DEV_COW_COMMON is not set
CONFIG_BLK_DEV_LOOP=y
CONFIG_BLK_DEV_LOOP_MIN_COUNT=8
CONFIG_BLK_DEV_CRYPTOLOOP=y
# CONFIG_BLK_DEV_DRBD is not set
# CONFIG_BLK_DEV_NBD is not set
# CONFIG_BLK_DEV_NVME is not set
# CONFIG_BLK_DEV_SX8 is not set
CONFIG_BLK_DEV_RAM=y
CONFIG_BLK_DEV_RAM_COUNT=16
CONFIG_BLK_DEV_RAM_SIZE=65536
# CONFIG_BLK_DEV_XIP is not set
CONFIG_CDROM_PKTCDVD=y
CONFIG_CDROM_PKTCDVD_BUFFERS=128
# CONFIG_CDROM_PKTCDVD_WCACHE is not set
# CONFIG_ATA_OVER_ETH is not set
CONFIG_VIRTIO_BLK=y
# CONFIG_BLK_DEV_HD is not set
# CONFIG_BLK_DEV_RBD is not set
# CONFIG_BLK_DEV_RSXX is not set

#
# Misc devices
#
# CONFIG_SENSORS_LIS3LV02D is not set
# CONFIG_AD525X_DPOT is not set
# CONFIG_DUMMY_IRQ is not set
# CONFIG_IBM_ASM is not set
# CONFIG_PHANTOM is not set
# CONFIG_INTEL_MID_PTI is not set
# CONFIG_SGI_IOC4 is not set
# CONFIG_TIFM_CORE is not set
# CONFIG_ICS932S401 is not set
# CONFIG_ATMEL_SSC is not set
# CONFIG_ENCLOSURE_SERVICES is not set
# CONFIG_HP_ILO is not set
# CONFIG_APDS9802ALS is not set
# CONFIG_ISL29003 is not set
# CONFIG_ISL29020 is not set
# CONFIG_SENSORS_TSL2550 is not set
# CONFIG_SENSORS_BH1780 is not set
# CONFIG_SENSORS_BH1770 is not set
# CONFIG_SENSORS_APDS990X is not set
# CONFIG_HMC6352 is not set
# CONFIG_DS1682 is not set
# CONFIG_BMP085_I2C is not set
# CONFIG_PCH_PHUB is not set
# CONFIG_USB_SWITCH_FSA9480 is not set
# CONFIG_SRAM is not set
# CONFIG_C2PORT is not set

#
# EEPROM support
#
# CONFIG_EEPROM_AT24 is not set
# CONFIG_EEPROM_LEGACY is not set
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
# CONFIG_ALTERA_STAPL is not set
# CONFIG_INTEL_MEI is not set
# CONFIG_INTEL_MEI_ME is not set
# CONFIG_VMWARE_VMCI is not set
CONFIG_HAVE_IDE=y
CONFIG_IDE=y

#
# Please see Documentation/ide/ide.txt for help/info on IDE drives
#
CONFIG_IDE_XFER_MODE=y
# CONFIG_BLK_DEV_IDE_SATA is not set
CONFIG_IDE_GD=y
CONFIG_IDE_GD_ATA=y
# CONFIG_IDE_GD_ATAPI is not set
# CONFIG_BLK_DEV_IDECD is not set
# CONFIG_BLK_DEV_IDETAPE is not set
# CONFIG_BLK_DEV_IDEACPI is not set
# CONFIG_IDE_TASK_IOCTL is not set
CONFIG_IDE_PROC_FS=y

#
# IDE chipset support/bugfixes
#
CONFIG_IDE_GENERIC=y
# CONFIG_BLK_DEV_PLATFORM is not set
# CONFIG_BLK_DEV_CMD640 is not set
# CONFIG_BLK_DEV_IDEPNP is not set
CONFIG_BLK_DEV_IDEDMA_SFF=y

#
# PCI IDE chipsets support
#
CONFIG_BLK_DEV_IDEPCI=y
CONFIG_IDEPCI_PCIBUS_ORDER=y
# CONFIG_BLK_DEV_GENERIC is not set
# CONFIG_BLK_DEV_OPTI621 is not set
# CONFIG_BLK_DEV_RZ1000 is not set
CONFIG_BLK_DEV_IDEDMA_PCI=y
# CONFIG_BLK_DEV_AEC62XX is not set
# CONFIG_BLK_DEV_ALI15X3 is not set
# CONFIG_BLK_DEV_AMD74XX is not set
# CONFIG_BLK_DEV_ATIIXP is not set
# CONFIG_BLK_DEV_CMD64X is not set
# CONFIG_BLK_DEV_TRIFLEX is not set
# CONFIG_BLK_DEV_CS5520 is not set
# CONFIG_BLK_DEV_CS5530 is not set
# CONFIG_BLK_DEV_HPT366 is not set
# CONFIG_BLK_DEV_JMICRON is not set
# CONFIG_BLK_DEV_SC1200 is not set
CONFIG_BLK_DEV_PIIX=y
# CONFIG_BLK_DEV_IT8172 is not set
# CONFIG_BLK_DEV_IT8213 is not set
# CONFIG_BLK_DEV_IT821X is not set
# CONFIG_BLK_DEV_NS87415 is not set
# CONFIG_BLK_DEV_PDC202XX_OLD is not set
# CONFIG_BLK_DEV_PDC202XX_NEW is not set
# CONFIG_BLK_DEV_SVWKS is not set
# CONFIG_BLK_DEV_SIIMAGE is not set
# CONFIG_BLK_DEV_SIS5513 is not set
# CONFIG_BLK_DEV_SLC90E66 is not set
# CONFIG_BLK_DEV_TRM290 is not set
# CONFIG_BLK_DEV_VIA82CXXX is not set
# CONFIG_BLK_DEV_TC86C001 is not set
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
CONFIG_SCSI_PROC_FS=y

#
# SCSI support type (disk, tape, CD-ROM)
#
CONFIG_BLK_DEV_SD=y
# CONFIG_CHR_DEV_ST is not set
# CONFIG_CHR_DEV_OSST is not set
# CONFIG_BLK_DEV_SR is not set
# CONFIG_CHR_DEV_SG is not set
# CONFIG_CHR_DEV_SCH is not set
# CONFIG_SCSI_MULTI_LUN is not set
CONFIG_SCSI_CONSTANTS=y
# CONFIG_SCSI_LOGGING is not set
CONFIG_SCSI_SCAN_ASYNC=y

#
# SCSI Transports
#
CONFIG_SCSI_SPI_ATTRS=y
CONFIG_SCSI_FC_ATTRS=y
CONFIG_SCSI_ISCSI_ATTRS=y
CONFIG_SCSI_SAS_ATTRS=y
CONFIG_SCSI_SAS_LIBSAS=y
CONFIG_SCSI_SAS_ATA=y
CONFIG_SCSI_SAS_HOST_SMP=y
# CONFIG_SCSI_SRP_ATTRS is not set
CONFIG_SCSI_LOWLEVEL=y
# CONFIG_ISCSI_TCP is not set
CONFIG_ISCSI_BOOT_SYSFS=y
# CONFIG_SCSI_CXGB3_ISCSI is not set
# CONFIG_SCSI_CXGB4_ISCSI is not set
# CONFIG_SCSI_BNX2_ISCSI is not set
# CONFIG_SCSI_BNX2X_FCOE is not set
# CONFIG_BE2ISCSI is not set
# CONFIG_BLK_DEV_3W_XXXX_RAID is not set
# CONFIG_SCSI_HPSA is not set
# CONFIG_SCSI_3W_9XXX is not set
# CONFIG_SCSI_3W_SAS is not set
# CONFIG_SCSI_ACARD is not set
CONFIG_SCSI_AACRAID=y
CONFIG_SCSI_AIC7XXX=y
CONFIG_AIC7XXX_CMDS_PER_DEVICE=32
CONFIG_AIC7XXX_RESET_DELAY_MS=5000
# CONFIG_AIC7XXX_BUILD_FIRMWARE is not set
CONFIG_AIC7XXX_DEBUG_ENABLE=y
CONFIG_AIC7XXX_DEBUG_MASK=0
CONFIG_AIC7XXX_REG_PRETTY_PRINT=y
CONFIG_SCSI_AIC7XXX_OLD=y
CONFIG_SCSI_AIC79XX=y
CONFIG_AIC79XX_CMDS_PER_DEVICE=32
CONFIG_AIC79XX_RESET_DELAY_MS=5000
# CONFIG_AIC79XX_BUILD_FIRMWARE is not set
CONFIG_AIC79XX_DEBUG_ENABLE=y
CONFIG_AIC79XX_DEBUG_MASK=0
CONFIG_AIC79XX_REG_PRETTY_PRINT=y
CONFIG_SCSI_AIC94XX=y
CONFIG_AIC94XX_DEBUG=y
CONFIG_SCSI_MVSAS=y
CONFIG_SCSI_MVSAS_DEBUG=y
# CONFIG_SCSI_MVSAS_TASKLET is not set
# CONFIG_SCSI_MVUMI is not set
CONFIG_SCSI_DPT_I2O=y
CONFIG_SCSI_ADVANSYS=y
# CONFIG_SCSI_ARCMSR is not set
CONFIG_MEGARAID_NEWGEN=y
CONFIG_MEGARAID_MM=y
CONFIG_MEGARAID_MAILBOX=y
CONFIG_MEGARAID_LEGACY=y
CONFIG_MEGARAID_SAS=y
CONFIG_SCSI_MPT2SAS=y
CONFIG_SCSI_MPT2SAS_MAX_SGE=128
# CONFIG_SCSI_MPT2SAS_LOGGING is not set
# CONFIG_SCSI_MPT3SAS is not set
# CONFIG_SCSI_UFSHCD is not set
# CONFIG_SCSI_HPTIOP is not set
# CONFIG_SCSI_BUSLOGIC is not set
# CONFIG_VMWARE_PVSCSI is not set
# CONFIG_LIBFC is not set
# CONFIG_LIBFCOE is not set
# CONFIG_FCOE is not set
# CONFIG_FCOE_FNIC is not set
# CONFIG_SCSI_DMX3191D is not set
# CONFIG_SCSI_EATA is not set
# CONFIG_SCSI_FUTURE_DOMAIN is not set
CONFIG_SCSI_GDTH=y
CONFIG_SCSI_ISCI=y
# CONFIG_SCSI_IPS is not set
# CONFIG_SCSI_INITIO is not set
# CONFIG_SCSI_INIA100 is not set
# CONFIG_SCSI_STEX is not set
# CONFIG_SCSI_SYM53C8XX_2 is not set
# CONFIG_SCSI_IPR is not set
CONFIG_SCSI_QLOGIC_1280=y
CONFIG_SCSI_QLA_FC=y
CONFIG_SCSI_QLA_ISCSI=y
# CONFIG_SCSI_LPFC is not set
# CONFIG_SCSI_DC395x is not set
# CONFIG_SCSI_DC390T is not set
# CONFIG_SCSI_DEBUG is not set
# CONFIG_SCSI_PMCRAID is not set
# CONFIG_SCSI_PM8001 is not set
# CONFIG_SCSI_SRP is not set
# CONFIG_SCSI_BFA_FC is not set
CONFIG_SCSI_VIRTIO=y
# CONFIG_SCSI_CHELSIO_FCOE is not set
# CONFIG_SCSI_DH is not set
# CONFIG_SCSI_OSD_INITIATOR is not set
CONFIG_ATA=y
# CONFIG_ATA_NONSTANDARD is not set
CONFIG_ATA_VERBOSE_ERROR=y
CONFIG_ATA_ACPI=y
# CONFIG_SATA_ZPODD is not set
CONFIG_SATA_PMP=y

#
# Controllers with non-SFF native interface
#
CONFIG_SATA_AHCI=y
# CONFIG_SATA_AHCI_PLATFORM is not set
# CONFIG_SATA_INIC162X is not set
# CONFIG_SATA_ACARD_AHCI is not set
# CONFIG_SATA_SIL24 is not set
# CONFIG_ATA_SFF is not set

#
# SFF controllers with custom DMA interface
#
# CONFIG_PDC_ADMA is not set
# CONFIG_SATA_QSTOR is not set
# CONFIG_SATA_SX4 is not set
CONFIG_ATA_BMDMA=y

#
# SATA SFF controllers with BMDMA
#
CONFIG_ATA_PIIX=y
# CONFIG_SATA_HIGHBANK is not set
# CONFIG_SATA_MV is not set
# CONFIG_SATA_NV is not set
# CONFIG_SATA_PROMISE is not set
# CONFIG_SATA_SIL is not set
# CONFIG_SATA_SIS is not set
# CONFIG_SATA_SVW is not set
# CONFIG_SATA_ULI is not set
# CONFIG_SATA_VIA is not set
# CONFIG_SATA_VITESSE is not set

#
# PATA SFF controllers with BMDMA
#
# CONFIG_PATA_ALI is not set
# CONFIG_PATA_AMD is not set
# CONFIG_PATA_ARASAN_CF is not set
# CONFIG_PATA_ARTOP is not set
# CONFIG_PATA_ATIIXP is not set
# CONFIG_PATA_ATP867X is not set
# CONFIG_PATA_CMD64X is not set
# CONFIG_PATA_CS5520 is not set
# CONFIG_PATA_CS5530 is not set
# CONFIG_PATA_CS5536 is not set
# CONFIG_PATA_CYPRESS is not set
# CONFIG_PATA_EFAR is not set
# CONFIG_PATA_HPT366 is not set
# CONFIG_PATA_HPT37X is not set
# CONFIG_PATA_HPT3X2N is not set
# CONFIG_PATA_HPT3X3 is not set
# CONFIG_PATA_IT8213 is not set
# CONFIG_PATA_IT821X is not set
# CONFIG_PATA_JMICRON is not set
# CONFIG_PATA_MARVELL is not set
# CONFIG_PATA_NETCELL is not set
# CONFIG_PATA_NINJA32 is not set
# CONFIG_PATA_NS87415 is not set
# CONFIG_PATA_OLDPIIX is not set
# CONFIG_PATA_OPTIDMA is not set
# CONFIG_PATA_PDC2027X is not set
# CONFIG_PATA_PDC_OLD is not set
# CONFIG_PATA_RADISYS is not set
# CONFIG_PATA_RDC is not set
# CONFIG_PATA_SC1200 is not set
# CONFIG_PATA_SCH is not set
# CONFIG_PATA_SERVERWORKS is not set
# CONFIG_PATA_SIL680 is not set
# CONFIG_PATA_SIS is not set
# CONFIG_PATA_TOSHIBA is not set
# CONFIG_PATA_TRIFLEX is not set
# CONFIG_PATA_VIA is not set
# CONFIG_PATA_WINBOND is not set

#
# PIO-only SFF controllers
#
# CONFIG_PATA_CMD640_PCI is not set
# CONFIG_PATA_MPIIX is not set
# CONFIG_PATA_NS87410 is not set
# CONFIG_PATA_OPTI is not set
CONFIG_PATA_PLATFORM=y
# CONFIG_PATA_RZ1000 is not set

#
# Generic fallback / legacy drivers
#
# CONFIG_PATA_ACPI is not set
CONFIG_ATA_GENERIC=y
# CONFIG_PATA_LEGACY is not set
CONFIG_MD=y
CONFIG_BLK_DEV_MD=y
CONFIG_MD_AUTODETECT=y
CONFIG_MD_LINEAR=y
CONFIG_MD_RAID0=y
CONFIG_MD_RAID1=y
CONFIG_MD_RAID10=y
CONFIG_MD_RAID456=y
CONFIG_MD_MULTIPATH=y
CONFIG_MD_FAULTY=y
# CONFIG_BCACHE is not set
CONFIG_BLK_DEV_DM=y
CONFIG_DM_DEBUG=y
CONFIG_DM_CRYPT=y
CONFIG_DM_SNAPSHOT=y
# CONFIG_DM_THIN_PROVISIONING is not set
# CONFIG_DM_CACHE is not set
CONFIG_DM_MIRROR=y
# CONFIG_DM_RAID is not set
CONFIG_DM_LOG_USERSPACE=y
CONFIG_DM_ZERO=y
CONFIG_DM_MULTIPATH=y
CONFIG_DM_MULTIPATH_QL=y
CONFIG_DM_MULTIPATH_ST=y
CONFIG_DM_DELAY=y
CONFIG_DM_UEVENT=y
# CONFIG_DM_FLAKEY is not set
# CONFIG_DM_VERITY is not set
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
# CONFIG_FIREWIRE_NOSY is not set
# CONFIG_I2O is not set
# CONFIG_MACINTOSH_DRIVERS is not set
CONFIG_NETDEVICES=y
CONFIG_NET_CORE=y
# CONFIG_BONDING is not set
CONFIG_DUMMY=y
# CONFIG_EQUALIZER is not set
# CONFIG_NET_FC is not set
CONFIG_MII=y
# CONFIG_NET_TEAM is not set
# CONFIG_MACVLAN is not set
# CONFIG_VXLAN is not set
CONFIG_NETCONSOLE=y
CONFIG_NETCONSOLE_DYNAMIC=y
CONFIG_NETPOLL=y
# CONFIG_NETPOLL_TRAP is not set
CONFIG_NET_POLL_CONTROLLER=y
CONFIG_TUN=y
# CONFIG_VETH is not set
CONFIG_VIRTIO_NET=y
# CONFIG_ARCNET is not set

#
# CAIF transport drivers
#
CONFIG_VHOST_NET=y
CONFIG_VHOST_RING=y

#
# Distributed Switch Architecture drivers
#
# CONFIG_NET_DSA_MV88E6XXX is not set
# CONFIG_NET_DSA_MV88E6060 is not set
# CONFIG_NET_DSA_MV88E6XXX_NEED_PPU is not set
# CONFIG_NET_DSA_MV88E6131 is not set
# CONFIG_NET_DSA_MV88E6123_61_65 is not set
CONFIG_ETHERNET=y
CONFIG_MDIO=y
# CONFIG_NET_VENDOR_3COM is not set
CONFIG_NET_VENDOR_ADAPTEC=y
# CONFIG_ADAPTEC_STARFIRE is not set
CONFIG_NET_VENDOR_ALTEON=y
# CONFIG_ACENIC is not set
CONFIG_NET_VENDOR_AMD=y
# CONFIG_AMD8111_ETH is not set
# CONFIG_PCNET32 is not set
CONFIG_NET_VENDOR_ATHEROS=y
CONFIG_ATL2=y
CONFIG_ATL1=y
CONFIG_ATL1E=y
CONFIG_ATL1C=y
CONFIG_NET_CADENCE=y
# CONFIG_ARM_AT91_ETHER is not set
# CONFIG_MACB is not set
CONFIG_NET_VENDOR_BROADCOM=y
# CONFIG_B44 is not set
CONFIG_BNX2=y
CONFIG_CNIC=y
CONFIG_TIGON3=y
# CONFIG_BNX2X is not set
CONFIG_NET_VENDOR_BROCADE=y
# CONFIG_BNA is not set
# CONFIG_NET_CALXEDA_XGMAC is not set
CONFIG_NET_VENDOR_CHELSIO=y
# CONFIG_CHELSIO_T1 is not set
# CONFIG_CHELSIO_T3 is not set
# CONFIG_CHELSIO_T4 is not set
# CONFIG_CHELSIO_T4VF is not set
CONFIG_NET_VENDOR_CISCO=y
# CONFIG_ENIC is not set
# CONFIG_DNET is not set
CONFIG_NET_VENDOR_DEC=y
CONFIG_NET_TULIP=y
# CONFIG_DE2104X is not set
# CONFIG_TULIP is not set
# CONFIG_DE4X5 is not set
# CONFIG_WINBOND_840 is not set
# CONFIG_DM9102 is not set
# CONFIG_ULI526X is not set
CONFIG_NET_VENDOR_DLINK=y
# CONFIG_DL2K is not set
# CONFIG_SUNDANCE is not set
CONFIG_NET_VENDOR_EMULEX=y
# CONFIG_BE2NET is not set
CONFIG_NET_VENDOR_EXAR=y
# CONFIG_S2IO is not set
# CONFIG_VXGE is not set
CONFIG_NET_VENDOR_HP=y
# CONFIG_HP100 is not set
CONFIG_NET_VENDOR_INTEL=y
CONFIG_E100=y
CONFIG_E1000=y
CONFIG_E1000E=y
CONFIG_IGB=y
CONFIG_IGB_HWMON=y
CONFIG_IGB_DCA=y
CONFIG_IGBVF=y
CONFIG_IXGB=y
CONFIG_IXGBE=y
CONFIG_IXGBE_HWMON=y
CONFIG_IXGBE_DCA=y
# CONFIG_IXGBEVF is not set
CONFIG_NET_VENDOR_I825XX=y
CONFIG_IP1000=y
CONFIG_JME=y
CONFIG_NET_VENDOR_MARVELL=y
# CONFIG_MVMDIO is not set
CONFIG_SKGE=y
# CONFIG_SKGE_DEBUG is not set
# CONFIG_SKGE_GENESIS is not set
CONFIG_SKY2=y
# CONFIG_SKY2_DEBUG is not set
CONFIG_NET_VENDOR_MELLANOX=y
# CONFIG_MLX4_EN is not set
# CONFIG_MLX4_CORE is not set
CONFIG_NET_VENDOR_MICREL=y
# CONFIG_KS8842 is not set
# CONFIG_KS8851_MLL is not set
# CONFIG_KSZ884X_PCI is not set
CONFIG_NET_VENDOR_MYRI=y
# CONFIG_MYRI10GE is not set
# CONFIG_FEALNX is not set
CONFIG_NET_VENDOR_NATSEMI=y
# CONFIG_NATSEMI is not set
# CONFIG_NS83820 is not set
CONFIG_NET_VENDOR_8390=y
# CONFIG_NE2K_PCI is not set
CONFIG_NET_VENDOR_NVIDIA=y
# CONFIG_FORCEDETH is not set
CONFIG_NET_VENDOR_OKI=y
CONFIG_PCH_GBE=y
# CONFIG_ETHOC is not set
# CONFIG_NET_PACKET_ENGINE is not set
CONFIG_NET_VENDOR_QLOGIC=y
# CONFIG_QLA3XXX is not set
# CONFIG_QLCNIC is not set
# CONFIG_QLGE is not set
# CONFIG_NETXEN_NIC is not set
CONFIG_NET_VENDOR_REALTEK=y
# CONFIG_8139CP is not set
# CONFIG_8139TOO is not set
CONFIG_R8169=y
CONFIG_NET_VENDOR_RDC=y
# CONFIG_R6040 is not set
CONFIG_NET_VENDOR_SEEQ=y
CONFIG_NET_VENDOR_SILAN=y
# CONFIG_SC92031 is not set
CONFIG_NET_VENDOR_SIS=y
# CONFIG_SIS900 is not set
CONFIG_SIS190=y
# CONFIG_SFC is not set
CONFIG_NET_VENDOR_SMSC=y
# CONFIG_EPIC100 is not set
# CONFIG_SMSC9420 is not set
CONFIG_NET_VENDOR_STMICRO=y
# CONFIG_STMMAC_ETH is not set
CONFIG_NET_VENDOR_SUN=y
# CONFIG_HAPPYMEAL is not set
# CONFIG_SUNGEM is not set
# CONFIG_CASSINI is not set
# CONFIG_NIU is not set
CONFIG_NET_VENDOR_TEHUTI=y
# CONFIG_TEHUTI is not set
CONFIG_NET_VENDOR_TI=y
# CONFIG_TLAN is not set
CONFIG_NET_VENDOR_VIA=y
# CONFIG_VIA_RHINE is not set
CONFIG_VIA_VELOCITY=y
CONFIG_NET_VENDOR_WIZNET=y
# CONFIG_WIZNET_W5100 is not set
# CONFIG_WIZNET_W5300 is not set
# CONFIG_FDDI is not set
# CONFIG_HIPPI is not set
# CONFIG_NET_SB1000 is not set
CONFIG_PHYLIB=y

#
# MII PHY device drivers
#
# CONFIG_AT803X_PHY is not set
# CONFIG_AMD_PHY is not set
CONFIG_MARVELL_PHY=y
CONFIG_DAVICOM_PHY=y
CONFIG_QSEMI_PHY=y
CONFIG_LXT_PHY=y
CONFIG_CICADA_PHY=y
CONFIG_VITESSE_PHY=y
CONFIG_SMSC_PHY=y
CONFIG_BROADCOM_PHY=y
# CONFIG_BCM87XX_PHY is not set
CONFIG_ICPLUS_PHY=y
# CONFIG_REALTEK_PHY is not set
# CONFIG_NATIONAL_PHY is not set
# CONFIG_STE10XP is not set
# CONFIG_LSI_ET1011C_PHY is not set
# CONFIG_MICREL_PHY is not set
# CONFIG_FIXED_PHY is not set
# CONFIG_MDIO_BITBANG is not set
# CONFIG_PPP is not set
# CONFIG_SLIP is not set

#
# USB Network Adapters
#
CONFIG_USB_CATC=y
CONFIG_USB_KAWETH=y
CONFIG_USB_PEGASUS=y
CONFIG_USB_RTL8150=y
# CONFIG_USB_RTL8152 is not set
CONFIG_USB_USBNET=y
CONFIG_USB_NET_AX8817X=y
CONFIG_USB_NET_AX88179_178A=y
CONFIG_USB_NET_CDCETHER=y
CONFIG_USB_NET_CDC_EEM=y
CONFIG_USB_NET_CDC_NCM=y
# CONFIG_USB_NET_CDC_MBIM is not set
CONFIG_USB_NET_DM9601=y
CONFIG_USB_NET_SMSC75XX=y
CONFIG_USB_NET_SMSC95XX=y
CONFIG_USB_NET_GL620A=y
CONFIG_USB_NET_NET1080=y
CONFIG_USB_NET_PLUSB=y
CONFIG_USB_NET_MCS7830=y
CONFIG_USB_NET_RNDIS_HOST=y
CONFIG_USB_NET_CDC_SUBSET=y
CONFIG_USB_ALI_M5632=y
CONFIG_USB_AN2720=y
CONFIG_USB_BELKIN=y
CONFIG_USB_ARMLINUX=y
CONFIG_USB_EPSON2888=y
CONFIG_USB_KC2190=y
CONFIG_USB_NET_ZAURUS=y
# CONFIG_USB_NET_CX82310_ETH is not set
# CONFIG_USB_NET_KALMIA is not set
# CONFIG_USB_NET_QMI_WWAN is not set
CONFIG_USB_NET_INT51X1=y
# CONFIG_USB_IPHETH is not set
# CONFIG_USB_SIERRA_NET is not set
# CONFIG_USB_VL600 is not set
# CONFIG_WLAN is not set

#
# Enable WiMAX (Networking options) to see the WiMAX drivers
#
# CONFIG_WAN is not set
# CONFIG_VMXNET3 is not set
# CONFIG_ISDN is not set

#
# Input device support
#
CONFIG_INPUT=y
# CONFIG_INPUT_FF_MEMLESS is not set
CONFIG_INPUT_POLLDEV=y
CONFIG_INPUT_SPARSEKMAP=y
# CONFIG_INPUT_MATRIXKMAP is not set

#
# Userland interfaces
#
CONFIG_INPUT_MOUSEDEV=y
CONFIG_INPUT_MOUSEDEV_PSAUX=y
CONFIG_INPUT_MOUSEDEV_SCREEN_X=1024
CONFIG_INPUT_MOUSEDEV_SCREEN_Y=768
# CONFIG_INPUT_JOYDEV is not set
CONFIG_INPUT_EVDEV=y
# CONFIG_INPUT_EVBUG is not set

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
CONFIG_KEYBOARD_NEWTON=y
# CONFIG_KEYBOARD_OPENCORES is not set
# CONFIG_KEYBOARD_STOWAWAY is not set
# CONFIG_KEYBOARD_SUNKBD is not set
CONFIG_KEYBOARD_XTKBD=y
CONFIG_INPUT_MOUSE=y
CONFIG_MOUSE_PS2=y
CONFIG_MOUSE_PS2_ALPS=y
CONFIG_MOUSE_PS2_LOGIPS2PP=y
CONFIG_MOUSE_PS2_SYNAPTICS=y
CONFIG_MOUSE_PS2_CYPRESS=y
CONFIG_MOUSE_PS2_LIFEBOOK=y
CONFIG_MOUSE_PS2_TRACKPOINT=y
# CONFIG_MOUSE_PS2_ELANTECH is not set
# CONFIG_MOUSE_PS2_SENTELIC is not set
# CONFIG_MOUSE_PS2_TOUCHKIT is not set
# CONFIG_MOUSE_SERIAL is not set
# CONFIG_MOUSE_APPLETOUCH is not set
# CONFIG_MOUSE_BCM5974 is not set
# CONFIG_MOUSE_CYAPA is not set
# CONFIG_MOUSE_VSXXXAA is not set
# CONFIG_MOUSE_SYNAPTICS_I2C is not set
# CONFIG_MOUSE_SYNAPTICS_USB is not set
# CONFIG_INPUT_JOYSTICK is not set
# CONFIG_INPUT_TABLET is not set
# CONFIG_INPUT_TOUCHSCREEN is not set
CONFIG_INPUT_MISC=y
# CONFIG_INPUT_AD714X is not set
# CONFIG_INPUT_BMA150 is not set
# CONFIG_INPUT_PCSPKR is not set
# CONFIG_INPUT_MMA8450 is not set
# CONFIG_INPUT_MPU3050 is not set
# CONFIG_INPUT_APANEL is not set
# CONFIG_INPUT_ATLAS_BTNS is not set
# CONFIG_INPUT_ATI_REMOTE2 is not set
# CONFIG_INPUT_KEYSPAN_REMOTE is not set
# CONFIG_INPUT_KXTJ9 is not set
# CONFIG_INPUT_POWERMATE is not set
# CONFIG_INPUT_YEALINK is not set
# CONFIG_INPUT_CM109 is not set
CONFIG_INPUT_UINPUT=y
# CONFIG_INPUT_PCF8574 is not set
# CONFIG_INPUT_ADXL34X is not set
# CONFIG_INPUT_IMS_PCU is not set
# CONFIG_INPUT_CMA3000 is not set

#
# Hardware I/O ports
#
CONFIG_SERIO=y
CONFIG_SERIO_I8042=y
# CONFIG_SERIO_SERPORT is not set
# CONFIG_SERIO_CT82C710 is not set
# CONFIG_SERIO_PCIPS2 is not set
CONFIG_SERIO_LIBPS2=y
# CONFIG_SERIO_RAW is not set
# CONFIG_SERIO_ALTERA_PS2 is not set
# CONFIG_SERIO_PS2MULT is not set
# CONFIG_SERIO_ARC_PS2 is not set
# CONFIG_GAMEPORT is not set

#
# Character devices
#
CONFIG_TTY=y
CONFIG_VT=y
CONFIG_CONSOLE_TRANSLATIONS=y
CONFIG_VT_CONSOLE=y
CONFIG_VT_CONSOLE_SLEEP=y
CONFIG_HW_CONSOLE=y
CONFIG_VT_HW_CONSOLE_BINDING=y
CONFIG_UNIX98_PTYS=y
# CONFIG_DEVPTS_MULTIPLE_INSTANCES is not set
CONFIG_LEGACY_PTYS=y
CONFIG_LEGACY_PTY_COUNT=256
# CONFIG_SERIAL_NONSTANDARD is not set
CONFIG_NOZOMI=y
# CONFIG_N_GSM is not set
# CONFIG_TRACE_SINK is not set
CONFIG_DEVKMEM=y

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
CONFIG_SERIAL_8250_NR_UARTS=16
CONFIG_SERIAL_8250_RUNTIME_UARTS=4
CONFIG_SERIAL_8250_EXTENDED=y
CONFIG_SERIAL_8250_MANY_PORTS=y
CONFIG_SERIAL_8250_SHARE_IRQ=y
# CONFIG_SERIAL_8250_DETECT_IRQ is not set
CONFIG_SERIAL_8250_RSA=y
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
# CONFIG_TTY_PRINTK is not set
CONFIG_HVC_DRIVER=y
CONFIG_VIRTIO_CONSOLE=y
# CONFIG_IPMI_HANDLER is not set
CONFIG_HW_RANDOM=y
# CONFIG_HW_RANDOM_TIMERIOMEM is not set
CONFIG_HW_RANDOM_INTEL=y
# CONFIG_HW_RANDOM_AMD is not set
CONFIG_HW_RANDOM_VIA=y
CONFIG_HW_RANDOM_VIRTIO=y
CONFIG_NVRAM=y
# CONFIG_R3964 is not set
# CONFIG_APPLICOM is not set
# CONFIG_MWAVE is not set
# CONFIG_RAW_DRIVER is not set
CONFIG_HPET=y
CONFIG_HPET_MMAP=y
CONFIG_HANGCHECK_TIMER=y
# CONFIG_TCG_TPM is not set
# CONFIG_TELCLOCK is not set
CONFIG_DEVPORT=y
CONFIG_I2C=y
CONFIG_I2C_BOARDINFO=y
CONFIG_I2C_COMPAT=y
# CONFIG_I2C_CHARDEV is not set
# CONFIG_I2C_MUX is not set
CONFIG_I2C_HELPER_AUTO=y
CONFIG_I2C_ALGOBIT=y

#
# I2C Hardware Bus support
#

#
# PC SMBus host controller drivers
#
# CONFIG_I2C_ALI1535 is not set
# CONFIG_I2C_ALI1563 is not set
# CONFIG_I2C_ALI15X3 is not set
# CONFIG_I2C_AMD756 is not set
# CONFIG_I2C_AMD8111 is not set
# CONFIG_I2C_I801 is not set
# CONFIG_I2C_ISCH is not set
# CONFIG_I2C_ISMT is not set
# CONFIG_I2C_PIIX4 is not set
# CONFIG_I2C_NFORCE2 is not set
# CONFIG_I2C_SIS5595 is not set
# CONFIG_I2C_SIS630 is not set
# CONFIG_I2C_SIS96X is not set
# CONFIG_I2C_VIA is not set
# CONFIG_I2C_VIAPRO is not set

#
# ACPI drivers
#
# CONFIG_I2C_SCMI is not set

#
# I2C system bus drivers (mostly embedded / system-on-chip)
#
# CONFIG_I2C_DESIGNWARE_PCI is not set
# CONFIG_I2C_EG20T is not set
# CONFIG_I2C_INTEL_MID is not set
# CONFIG_I2C_OCORES is not set
# CONFIG_I2C_PCA_PLATFORM is not set
# CONFIG_I2C_PXA_PCI is not set
# CONFIG_I2C_SIMTEC is not set
# CONFIG_I2C_XILINX is not set

#
# External I2C/SMBus adapter drivers
#
# CONFIG_I2C_DIOLAN_U2C is not set
# CONFIG_I2C_PARPORT_LIGHT is not set
# CONFIG_I2C_TAOS_EVM is not set
# CONFIG_I2C_TINY_USB is not set

#
# Other I2C/SMBus bus drivers
#
# CONFIG_I2C_STUB is not set
# CONFIG_I2C_DEBUG_CORE is not set
# CONFIG_I2C_DEBUG_ALGO is not set
# CONFIG_I2C_DEBUG_BUS is not set
# CONFIG_SPI is not set

#
# Qualcomm MSM SSBI bus support
#
# CONFIG_SSBI is not set
# CONFIG_HSI is not set

#
# PPS support
#
CONFIG_PPS=y
# CONFIG_PPS_DEBUG is not set

#
# PPS clients support
#
# CONFIG_PPS_CLIENT_KTIMER is not set
# CONFIG_PPS_CLIENT_LDISC is not set
# CONFIG_PPS_CLIENT_GPIO is not set

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
CONFIG_GPIO_DEVRES=y
# CONFIG_GPIOLIB is not set
# CONFIG_W1 is not set
CONFIG_POWER_SUPPLY=y
# CONFIG_POWER_SUPPLY_DEBUG is not set
# CONFIG_PDA_POWER is not set
# CONFIG_TEST_POWER is not set
# CONFIG_BATTERY_DS2780 is not set
# CONFIG_BATTERY_DS2781 is not set
# CONFIG_BATTERY_DS2782 is not set
# CONFIG_BATTERY_SBS is not set
# CONFIG_BATTERY_BQ27x00 is not set
# CONFIG_BATTERY_MAX17040 is not set
# CONFIG_BATTERY_MAX17042 is not set
# CONFIG_CHARGER_MAX8903 is not set
# CONFIG_CHARGER_LP8727 is not set
# CONFIG_CHARGER_BQ2415X is not set
# CONFIG_CHARGER_SMB347 is not set
# CONFIG_BATTERY_GOLDFISH is not set
# CONFIG_POWER_RESET is not set
# CONFIG_POWER_AVS is not set
CONFIG_HWMON=y
# CONFIG_HWMON_VID is not set
# CONFIG_HWMON_DEBUG_CHIP is not set

#
# Native drivers
#
# CONFIG_SENSORS_ABITUGURU is not set
# CONFIG_SENSORS_ABITUGURU3 is not set
# CONFIG_SENSORS_AD7414 is not set
# CONFIG_SENSORS_AD7418 is not set
# CONFIG_SENSORS_ADM1021 is not set
# CONFIG_SENSORS_ADM1025 is not set
# CONFIG_SENSORS_ADM1026 is not set
# CONFIG_SENSORS_ADM1029 is not set
# CONFIG_SENSORS_ADM1031 is not set
# CONFIG_SENSORS_ADM9240 is not set
# CONFIG_SENSORS_ADT7410 is not set
# CONFIG_SENSORS_ADT7411 is not set
# CONFIG_SENSORS_ADT7462 is not set
# CONFIG_SENSORS_ADT7470 is not set
# CONFIG_SENSORS_ADT7475 is not set
# CONFIG_SENSORS_ASC7621 is not set
# CONFIG_SENSORS_K8TEMP is not set
# CONFIG_SENSORS_K10TEMP is not set
# CONFIG_SENSORS_FAM15H_POWER is not set
# CONFIG_SENSORS_ASB100 is not set
# CONFIG_SENSORS_ATXP1 is not set
# CONFIG_SENSORS_DS620 is not set
# CONFIG_SENSORS_DS1621 is not set
# CONFIG_SENSORS_I5K_AMB is not set
# CONFIG_SENSORS_F71805F is not set
# CONFIG_SENSORS_F71882FG is not set
# CONFIG_SENSORS_F75375S is not set
# CONFIG_SENSORS_FSCHMD is not set
# CONFIG_SENSORS_G760A is not set
# CONFIG_SENSORS_GL518SM is not set
# CONFIG_SENSORS_GL520SM is not set
# CONFIG_SENSORS_HIH6130 is not set
# CONFIG_SENSORS_CORETEMP is not set
# CONFIG_SENSORS_IT87 is not set
# CONFIG_SENSORS_JC42 is not set
# CONFIG_SENSORS_LINEAGE is not set
# CONFIG_SENSORS_LM63 is not set
# CONFIG_SENSORS_LM73 is not set
# CONFIG_SENSORS_LM75 is not set
# CONFIG_SENSORS_LM77 is not set
# CONFIG_SENSORS_LM78 is not set
# CONFIG_SENSORS_LM80 is not set
# CONFIG_SENSORS_LM83 is not set
# CONFIG_SENSORS_LM85 is not set
# CONFIG_SENSORS_LM87 is not set
# CONFIG_SENSORS_LM90 is not set
# CONFIG_SENSORS_LM92 is not set
# CONFIG_SENSORS_LM93 is not set
# CONFIG_SENSORS_LTC4151 is not set
# CONFIG_SENSORS_LTC4215 is not set
# CONFIG_SENSORS_LTC4245 is not set
# CONFIG_SENSORS_LTC4261 is not set
# CONFIG_SENSORS_LM95234 is not set
# CONFIG_SENSORS_LM95241 is not set
# CONFIG_SENSORS_LM95245 is not set
# CONFIG_SENSORS_MAX16065 is not set
# CONFIG_SENSORS_MAX1619 is not set
# CONFIG_SENSORS_MAX1668 is not set
# CONFIG_SENSORS_MAX197 is not set
# CONFIG_SENSORS_MAX6639 is not set
# CONFIG_SENSORS_MAX6642 is not set
# CONFIG_SENSORS_MAX6650 is not set
# CONFIG_SENSORS_MAX6697 is not set
# CONFIG_SENSORS_MCP3021 is not set
# CONFIG_SENSORS_NCT6775 is not set
# CONFIG_SENSORS_NTC_THERMISTOR is not set
# CONFIG_SENSORS_PC87360 is not set
# CONFIG_SENSORS_PC87427 is not set
# CONFIG_SENSORS_PCF8591 is not set
# CONFIG_PMBUS is not set
# CONFIG_SENSORS_SHT21 is not set
# CONFIG_SENSORS_SIS5595 is not set
# CONFIG_SENSORS_SMM665 is not set
# CONFIG_SENSORS_DME1737 is not set
# CONFIG_SENSORS_EMC1403 is not set
# CONFIG_SENSORS_EMC2103 is not set
# CONFIG_SENSORS_EMC6W201 is not set
# CONFIG_SENSORS_SMSC47M1 is not set
# CONFIG_SENSORS_SMSC47M192 is not set
# CONFIG_SENSORS_SMSC47B397 is not set
# CONFIG_SENSORS_SCH56XX_COMMON is not set
# CONFIG_SENSORS_SCH5627 is not set
# CONFIG_SENSORS_SCH5636 is not set
# CONFIG_SENSORS_ADS1015 is not set
# CONFIG_SENSORS_ADS7828 is not set
# CONFIG_SENSORS_AMC6821 is not set
# CONFIG_SENSORS_INA209 is not set
# CONFIG_SENSORS_INA2XX is not set
# CONFIG_SENSORS_THMC50 is not set
# CONFIG_SENSORS_TMP102 is not set
# CONFIG_SENSORS_TMP401 is not set
# CONFIG_SENSORS_TMP421 is not set
# CONFIG_SENSORS_VIA_CPUTEMP is not set
# CONFIG_SENSORS_VIA686A is not set
# CONFIG_SENSORS_VT1211 is not set
# CONFIG_SENSORS_VT8231 is not set
# CONFIG_SENSORS_W83781D is not set
# CONFIG_SENSORS_W83791D is not set
# CONFIG_SENSORS_W83792D is not set
# CONFIG_SENSORS_W83793 is not set
# CONFIG_SENSORS_W83795 is not set
# CONFIG_SENSORS_W83L785TS is not set
# CONFIG_SENSORS_W83L786NG is not set
# CONFIG_SENSORS_W83627HF is not set
# CONFIG_SENSORS_W83627EHF is not set
# CONFIG_SENSORS_APPLESMC is not set

#
# ACPI drivers
#
# CONFIG_SENSORS_ACPI_POWER is not set
# CONFIG_SENSORS_ATK0110 is not set
CONFIG_THERMAL=y
CONFIG_THERMAL_HWMON=y
CONFIG_THERMAL_DEFAULT_GOV_STEP_WISE=y
# CONFIG_THERMAL_DEFAULT_GOV_FAIR_SHARE is not set
# CONFIG_THERMAL_DEFAULT_GOV_USER_SPACE is not set
# CONFIG_THERMAL_GOV_FAIR_SHARE is not set
CONFIG_THERMAL_GOV_STEP_WISE=y
# CONFIG_THERMAL_GOV_USER_SPACE is not set
# CONFIG_CPU_THERMAL is not set
# CONFIG_THERMAL_EMULATION is not set
# CONFIG_INTEL_POWERCLAMP is not set
CONFIG_WATCHDOG=y
CONFIG_WATCHDOG_CORE=y
# CONFIG_WATCHDOG_NOWAYOUT is not set

#
# Watchdog Device Drivers
#
CONFIG_SOFT_WATCHDOG=y
# CONFIG_ACQUIRE_WDT is not set
# CONFIG_ADVANTECH_WDT is not set
# CONFIG_ALIM1535_WDT is not set
# CONFIG_ALIM7101_WDT is not set
# CONFIG_F71808E_WDT is not set
# CONFIG_SP5100_TCO is not set
# CONFIG_SC520_WDT is not set
# CONFIG_SBC_FITPC2_WATCHDOG is not set
# CONFIG_EUROTECH_WDT is not set
# CONFIG_IB700_WDT is not set
# CONFIG_IBMASR is not set
# CONFIG_WAFER_WDT is not set
CONFIG_I6300ESB_WDT=y
# CONFIG_IE6XX_WDT is not set
CONFIG_ITCO_WDT=y
CONFIG_ITCO_VENDOR_SUPPORT=y
# CONFIG_IT8712F_WDT is not set
# CONFIG_IT87_WDT is not set
# CONFIG_HP_WATCHDOG is not set
# CONFIG_SC1200_WDT is not set
# CONFIG_PC87413_WDT is not set
# CONFIG_NV_TCO is not set
# CONFIG_60XX_WDT is not set
# CONFIG_SBC8360_WDT is not set
# CONFIG_CPU5_WDT is not set
# CONFIG_SMSC_SCH311X_WDT is not set
# CONFIG_SMSC37B787_WDT is not set
# CONFIG_VIA_WDT is not set
# CONFIG_W83627HF_WDT is not set
# CONFIG_W83697HF_WDT is not set
# CONFIG_W83697UG_WDT is not set
# CONFIG_W83877F_WDT is not set
# CONFIG_W83977F_WDT is not set
# CONFIG_MACHZ_WDT is not set
# CONFIG_SBC_EPX_C3_WATCHDOG is not set

#
# PCI-based Watchdog Cards
#
# CONFIG_PCIPCWATCHDOG is not set
# CONFIG_WDTPCI is not set

#
# USB-based Watchdog Cards
#
# CONFIG_USBPCWATCHDOG is not set
CONFIG_SSB_POSSIBLE=y

#
# Sonics Silicon Backplane
#
CONFIG_SSB=y
CONFIG_SSB_SPROM=y
CONFIG_SSB_PCIHOST_POSSIBLE=y
CONFIG_SSB_PCIHOST=y
# CONFIG_SSB_B43_PCI_BRIDGE is not set
# CONFIG_SSB_SILENT is not set
# CONFIG_SSB_DEBUG is not set
CONFIG_SSB_DRIVER_PCICORE_POSSIBLE=y
CONFIG_SSB_DRIVER_PCICORE=y
CONFIG_BCMA_POSSIBLE=y

#
# Broadcom specific AMBA
#
# CONFIG_BCMA is not set

#
# Multifunction device drivers
#
CONFIG_MFD_CORE=y
# CONFIG_MFD_CS5535 is not set
# CONFIG_MFD_AS3711 is not set
# CONFIG_PMIC_ADP5520 is not set
# CONFIG_MFD_CROS_EC is not set
# CONFIG_PMIC_DA903X is not set
# CONFIG_MFD_DA9052_I2C is not set
# CONFIG_MFD_DA9055 is not set
# CONFIG_MFD_MC13XXX_I2C is not set
# CONFIG_HTC_PASIC3 is not set
CONFIG_LPC_ICH=y
# CONFIG_LPC_SCH is not set
# CONFIG_MFD_JANZ_CMODIO is not set
# CONFIG_MFD_88PM800 is not set
# CONFIG_MFD_88PM805 is not set
# CONFIG_MFD_88PM860X is not set
# CONFIG_MFD_MAX77686 is not set
# CONFIG_MFD_MAX77693 is not set
# CONFIG_MFD_MAX8907 is not set
# CONFIG_MFD_MAX8925 is not set
# CONFIG_MFD_MAX8997 is not set
# CONFIG_MFD_MAX8998 is not set
# CONFIG_MFD_VIPERBOARD is not set
# CONFIG_MFD_RETU is not set
# CONFIG_MFD_PCF50633 is not set
# CONFIG_MFD_RDC321X is not set
# CONFIG_MFD_RTSX_PCI is not set
# CONFIG_MFD_RC5T583 is not set
# CONFIG_MFD_SEC_CORE is not set
# CONFIG_MFD_SI476X_CORE is not set
# CONFIG_MFD_SM501 is not set
# CONFIG_MFD_SMSC is not set
# CONFIG_ABX500_CORE is not set
# CONFIG_MFD_STMPE is not set
# CONFIG_MFD_SYSCON is not set
# CONFIG_MFD_TI_AM335X_TSCADC is not set
# CONFIG_MFD_LP8788 is not set
# CONFIG_MFD_PALMAS is not set
# CONFIG_TPS6105X is not set
# CONFIG_TPS6507X is not set
# CONFIG_MFD_TPS65090 is not set
# CONFIG_MFD_TPS65217 is not set
# CONFIG_MFD_TPS6586X is not set
# CONFIG_MFD_TPS80031 is not set
# CONFIG_TWL4030_CORE is not set
# CONFIG_TWL6040_CORE is not set
# CONFIG_MFD_WL1273_CORE is not set
# CONFIG_MFD_LM3533 is not set
# CONFIG_MFD_TC3589X is not set
# CONFIG_MFD_TMIO is not set
# CONFIG_MFD_VX855 is not set
# CONFIG_MFD_ARIZONA_I2C is not set
# CONFIG_MFD_WM8400 is not set
# CONFIG_MFD_WM831X_I2C is not set
# CONFIG_MFD_WM8350_I2C is not set
# CONFIG_MFD_WM8994 is not set
# CONFIG_REGULATOR is not set
# CONFIG_MEDIA_SUPPORT is not set

#
# Graphics support
#
CONFIG_AGP=y
CONFIG_AGP_INTEL=y
# CONFIG_AGP_SIS is not set
# CONFIG_AGP_VIA is not set
CONFIG_VGA_ARB=y
CONFIG_VGA_ARB_MAX_GPUS=16
# CONFIG_VGA_SWITCHEROO is not set
CONFIG_DRM=y
CONFIG_DRM_KMS_HELPER=y
# CONFIG_DRM_LOAD_EDID_FIRMWARE is not set

#
# I2C encoder or helper chips
#
# CONFIG_DRM_I2C_CH7006 is not set
# CONFIG_DRM_I2C_SIL164 is not set
# CONFIG_DRM_I2C_NXP_TDA998X is not set
# CONFIG_DRM_TDFX is not set
# CONFIG_DRM_R128 is not set
# CONFIG_DRM_RADEON is not set
# CONFIG_DRM_NOUVEAU is not set
# CONFIG_DRM_I810 is not set
CONFIG_DRM_I915=y
CONFIG_DRM_I915_KMS=y
# CONFIG_DRM_MGA is not set
# CONFIG_DRM_SIS is not set
# CONFIG_DRM_VIA is not set
# CONFIG_DRM_SAVAGE is not set
# CONFIG_DRM_VMWGFX is not set
# CONFIG_DRM_GMA500 is not set
# CONFIG_DRM_UDL is not set
# CONFIG_DRM_AST is not set
# CONFIG_DRM_MGAG200 is not set
# CONFIG_DRM_CIRRUS_QEMU is not set
# CONFIG_DRM_QXL is not set
# CONFIG_VGASTATE is not set
CONFIG_VIDEO_OUTPUT_CONTROL=y
CONFIG_HDMI=y
CONFIG_FB=y
# CONFIG_FIRMWARE_EDID is not set
# CONFIG_FB_DDC is not set
# CONFIG_FB_BOOT_VESA_SUPPORT is not set
CONFIG_FB_CFB_FILLRECT=y
CONFIG_FB_CFB_COPYAREA=y
CONFIG_FB_CFB_IMAGEBLIT=y
# CONFIG_FB_CFB_REV_PIXELS_IN_BYTE is not set
# CONFIG_FB_SYS_FILLRECT is not set
# CONFIG_FB_SYS_COPYAREA is not set
# CONFIG_FB_SYS_IMAGEBLIT is not set
# CONFIG_FB_FOREIGN_ENDIAN is not set
# CONFIG_FB_SYS_FOPS is not set
# CONFIG_FB_SVGALIB is not set
# CONFIG_FB_MACMODES is not set
# CONFIG_FB_BACKLIGHT is not set
CONFIG_FB_MODE_HELPERS=y
# CONFIG_FB_TILEBLITTING is not set

#
# Frame buffer hardware drivers
#
# CONFIG_FB_CIRRUS is not set
# CONFIG_FB_PM2 is not set
# CONFIG_FB_CYBER2000 is not set
# CONFIG_FB_ARC is not set
# CONFIG_FB_ASILIANT is not set
# CONFIG_FB_IMSTT is not set
# CONFIG_FB_VGA16 is not set
# CONFIG_FB_UVESA is not set
# CONFIG_FB_VESA is not set
# CONFIG_FB_EFI is not set
# CONFIG_FB_N411 is not set
# CONFIG_FB_HGA is not set
# CONFIG_FB_S1D13XXX is not set
# CONFIG_FB_NVIDIA is not set
# CONFIG_FB_RIVA is not set
# CONFIG_FB_I740 is not set
# CONFIG_FB_LE80578 is not set
# CONFIG_FB_MATROX is not set
# CONFIG_FB_RADEON is not set
# CONFIG_FB_ATY128 is not set
# CONFIG_FB_ATY is not set
# CONFIG_FB_S3 is not set
# CONFIG_FB_SAVAGE is not set
# CONFIG_FB_SIS is not set
# CONFIG_FB_VIA is not set
# CONFIG_FB_NEOMAGIC is not set
# CONFIG_FB_KYRO is not set
# CONFIG_FB_3DFX is not set
# CONFIG_FB_VOODOO1 is not set
# CONFIG_FB_VT8623 is not set
# CONFIG_FB_TRIDENT is not set
# CONFIG_FB_ARK is not set
# CONFIG_FB_PM3 is not set
# CONFIG_FB_CARMINE is not set
# CONFIG_FB_GEODE is not set
# CONFIG_FB_TMIO is not set
# CONFIG_FB_SMSCUFX is not set
# CONFIG_FB_UDL is not set
# CONFIG_FB_GOLDFISH is not set
# CONFIG_FB_VIRTUAL is not set
# CONFIG_FB_METRONOME is not set
# CONFIG_FB_MB862XX is not set
# CONFIG_FB_BROADSHEET is not set
# CONFIG_FB_AUO_K190X is not set
# CONFIG_EXYNOS_VIDEO is not set
CONFIG_BACKLIGHT_LCD_SUPPORT=y
CONFIG_LCD_CLASS_DEVICE=y
# CONFIG_LCD_PLATFORM is not set
CONFIG_BACKLIGHT_CLASS_DEVICE=y
CONFIG_BACKLIGHT_GENERIC=y
# CONFIG_BACKLIGHT_APPLE is not set
# CONFIG_BACKLIGHT_SAHARA is not set
# CONFIG_BACKLIGHT_ADP8860 is not set
# CONFIG_BACKLIGHT_ADP8870 is not set
# CONFIG_BACKLIGHT_LM3630 is not set
# CONFIG_BACKLIGHT_LM3639 is not set
# CONFIG_BACKLIGHT_LP855X is not set

#
# Console display driver support
#
CONFIG_VGA_CONSOLE=y
CONFIG_VGACON_SOFT_SCROLLBACK=y
CONFIG_VGACON_SOFT_SCROLLBACK_SIZE=1024
CONFIG_DUMMY_CONSOLE=y
CONFIG_FRAMEBUFFER_CONSOLE=y
CONFIG_FRAMEBUFFER_CONSOLE_DETECT_PRIMARY=y
# CONFIG_FRAMEBUFFER_CONSOLE_ROTATION is not set
# CONFIG_FONTS is not set
CONFIG_FONT_8x8=y
CONFIG_FONT_8x16=y
# CONFIG_LOGO is not set
CONFIG_SOUND=y
# CONFIG_SOUND_OSS_CORE is not set
CONFIG_SND=y
CONFIG_SND_TIMER=y
CONFIG_SND_PCM=y
CONFIG_SND_HWDEP=y
CONFIG_SND_JACK=y
CONFIG_SND_SEQUENCER=y
CONFIG_SND_SEQ_DUMMY=y
# CONFIG_SND_MIXER_OSS is not set
# CONFIG_SND_PCM_OSS is not set
# CONFIG_SND_SEQUENCER_OSS is not set
CONFIG_SND_HRTIMER=y
CONFIG_SND_SEQ_HRTIMER_DEFAULT=y
CONFIG_SND_DYNAMIC_MINORS=y
# CONFIG_SND_SUPPORT_OLD_API is not set
CONFIG_SND_VERBOSE_PROCFS=y
CONFIG_SND_VERBOSE_PRINTK=y
CONFIG_SND_DEBUG=y
CONFIG_SND_DEBUG_VERBOSE=y
CONFIG_SND_PCM_XRUN_DEBUG=y
CONFIG_SND_VMASTER=y
CONFIG_SND_KCTL_JACK=y
CONFIG_SND_DMA_SGBUF=y
# CONFIG_SND_RAWMIDI_SEQ is not set
# CONFIG_SND_OPL3_LIB_SEQ is not set
# CONFIG_SND_OPL4_LIB_SEQ is not set
# CONFIG_SND_SBAWE_SEQ is not set
# CONFIG_SND_EMU10K1_SEQ is not set
CONFIG_SND_DRIVERS=y
CONFIG_SND_PCSP=m
# CONFIG_SND_DUMMY is not set
# CONFIG_SND_ALOOP is not set
# CONFIG_SND_VIRMIDI is not set
# CONFIG_SND_MTPAV is not set
# CONFIG_SND_SERIAL_U16550 is not set
# CONFIG_SND_MPU401 is not set
CONFIG_SND_PCI=y
# CONFIG_SND_AD1889 is not set
# CONFIG_SND_ALS300 is not set
# CONFIG_SND_ALS4000 is not set
# CONFIG_SND_ALI5451 is not set
# CONFIG_SND_ASIHPI is not set
# CONFIG_SND_ATIIXP is not set
# CONFIG_SND_ATIIXP_MODEM is not set
# CONFIG_SND_AU8810 is not set
# CONFIG_SND_AU8820 is not set
# CONFIG_SND_AU8830 is not set
# CONFIG_SND_AW2 is not set
# CONFIG_SND_AZT3328 is not set
# CONFIG_SND_BT87X is not set
# CONFIG_SND_CA0106 is not set
# CONFIG_SND_CMIPCI is not set
# CONFIG_SND_OXYGEN is not set
# CONFIG_SND_CS4281 is not set
# CONFIG_SND_CS46XX is not set
# CONFIG_SND_CS5530 is not set
# CONFIG_SND_CS5535AUDIO is not set
# CONFIG_SND_CTXFI is not set
# CONFIG_SND_DARLA20 is not set
# CONFIG_SND_GINA20 is not set
# CONFIG_SND_LAYLA20 is not set
# CONFIG_SND_DARLA24 is not set
# CONFIG_SND_GINA24 is not set
# CONFIG_SND_LAYLA24 is not set
# CONFIG_SND_MONA is not set
# CONFIG_SND_MIA is not set
# CONFIG_SND_ECHO3G is not set
# CONFIG_SND_INDIGO is not set
# CONFIG_SND_INDIGOIO is not set
# CONFIG_SND_INDIGODJ is not set
# CONFIG_SND_INDIGOIOX is not set
# CONFIG_SND_INDIGODJX is not set
# CONFIG_SND_EMU10K1 is not set
# CONFIG_SND_EMU10K1X is not set
# CONFIG_SND_ENS1370 is not set
# CONFIG_SND_ENS1371 is not set
# CONFIG_SND_ES1938 is not set
# CONFIG_SND_ES1968 is not set
# CONFIG_SND_FM801 is not set
CONFIG_SND_HDA_INTEL=y
CONFIG_SND_HDA_PREALLOC_SIZE=64
CONFIG_SND_HDA_HWDEP=y
CONFIG_SND_HDA_RECONFIG=y
CONFIG_SND_HDA_INPUT_BEEP=y
CONFIG_SND_HDA_INPUT_BEEP_MODE=1
CONFIG_SND_HDA_INPUT_JACK=y
CONFIG_SND_HDA_PATCH_LOADER=y
CONFIG_SND_HDA_CODEC_REALTEK=y
CONFIG_SND_HDA_CODEC_ANALOG=y
CONFIG_SND_HDA_CODEC_SIGMATEL=y
CONFIG_SND_HDA_CODEC_VIA=y
CONFIG_SND_HDA_CODEC_HDMI=y
CONFIG_SND_HDA_CODEC_CIRRUS=y
CONFIG_SND_HDA_CODEC_CONEXANT=y
CONFIG_SND_HDA_CODEC_CA0110=y
CONFIG_SND_HDA_CODEC_CA0132=y
# CONFIG_SND_HDA_CODEC_CA0132_DSP is not set
CONFIG_SND_HDA_CODEC_CMEDIA=y
CONFIG_SND_HDA_CODEC_SI3054=y
CONFIG_SND_HDA_GENERIC=y
CONFIG_SND_HDA_POWER_SAVE_DEFAULT=0
# CONFIG_SND_HDSP is not set
# CONFIG_SND_HDSPM is not set
# CONFIG_SND_ICE1712 is not set
# CONFIG_SND_ICE1724 is not set
# CONFIG_SND_INTEL8X0 is not set
# CONFIG_SND_INTEL8X0M is not set
# CONFIG_SND_KORG1212 is not set
# CONFIG_SND_LOLA is not set
# CONFIG_SND_LX6464ES is not set
# CONFIG_SND_MAESTRO3 is not set
# CONFIG_SND_MIXART is not set
# CONFIG_SND_NM256 is not set
# CONFIG_SND_PCXHR is not set
# CONFIG_SND_RIPTIDE is not set
# CONFIG_SND_RME32 is not set
# CONFIG_SND_RME96 is not set
# CONFIG_SND_RME9652 is not set
# CONFIG_SND_SONICVIBES is not set
# CONFIG_SND_TRIDENT is not set
# CONFIG_SND_VIA82XX is not set
# CONFIG_SND_VIA82XX_MODEM is not set
# CONFIG_SND_VIRTUOSO is not set
# CONFIG_SND_VX222 is not set
# CONFIG_SND_YMFPCI is not set
# CONFIG_SND_USB is not set
# CONFIG_SND_SOC is not set
# CONFIG_SOUND_PRIME is not set

#
# HID support
#
CONFIG_HID=y
CONFIG_HID_BATTERY_STRENGTH=y
# CONFIG_HIDRAW is not set
# CONFIG_UHID is not set
CONFIG_HID_GENERIC=y

#
# Special HID drivers
#
# CONFIG_HID_A4TECH is not set
# CONFIG_HID_ACRUX is not set
# CONFIG_HID_APPLE is not set
# CONFIG_HID_APPLEIR is not set
# CONFIG_HID_AUREAL is not set
# CONFIG_HID_BELKIN is not set
# CONFIG_HID_CHERRY is not set
# CONFIG_HID_CHICONY is not set
# CONFIG_HID_PRODIKEYS is not set
# CONFIG_HID_CYPRESS is not set
# CONFIG_HID_DRAGONRISE is not set
# CONFIG_HID_EMS_FF is not set
# CONFIG_HID_ELECOM is not set
# CONFIG_HID_EZKEY is not set
# CONFIG_HID_HOLTEK is not set
# CONFIG_HID_KEYTOUCH is not set
# CONFIG_HID_KYE is not set
# CONFIG_HID_UCLOGIC is not set
# CONFIG_HID_WALTOP is not set
# CONFIG_HID_GYRATION is not set
# CONFIG_HID_ICADE is not set
# CONFIG_HID_TWINHAN is not set
# CONFIG_HID_KENSINGTON is not set
# CONFIG_HID_LCPOWER is not set
# CONFIG_HID_LENOVO_TPKBD is not set
# CONFIG_HID_LOGITECH is not set
# CONFIG_HID_MAGICMOUSE is not set
# CONFIG_HID_MICROSOFT is not set
# CONFIG_HID_MONTEREY is not set
# CONFIG_HID_MULTITOUCH is not set
# CONFIG_HID_NTRIG is not set
# CONFIG_HID_ORTEK is not set
# CONFIG_HID_PANTHERLORD is not set
# CONFIG_HID_PETALYNX is not set
# CONFIG_HID_PICOLCD is not set
# CONFIG_HID_PRIMAX is not set
# CONFIG_HID_PS3REMOTE is not set
# CONFIG_HID_ROCCAT is not set
# CONFIG_HID_SAITEK is not set
# CONFIG_HID_SAMSUNG is not set
# CONFIG_HID_SONY is not set
# CONFIG_HID_SPEEDLINK is not set
# CONFIG_HID_STEELSERIES is not set
# CONFIG_HID_SUNPLUS is not set
# CONFIG_HID_GREENASIA is not set
# CONFIG_HID_SMARTJOYPLUS is not set
# CONFIG_HID_TIVO is not set
# CONFIG_HID_TOPSEED is not set
# CONFIG_HID_THINGM is not set
# CONFIG_HID_THRUSTMASTER is not set
# CONFIG_HID_WACOM is not set
# CONFIG_HID_WIIMOTE is not set
# CONFIG_HID_ZEROPLUS is not set
# CONFIG_HID_ZYDACRON is not set
# CONFIG_HID_SENSOR_HUB is not set

#
# USB HID support
#
CONFIG_USB_HID=y
# CONFIG_HID_PID is not set
CONFIG_USB_HIDDEV=y

#
# I2C HID support
#
# CONFIG_I2C_HID is not set
CONFIG_USB_ARCH_HAS_OHCI=y
CONFIG_USB_ARCH_HAS_EHCI=y
CONFIG_USB_ARCH_HAS_XHCI=y
CONFIG_USB_SUPPORT=y
CONFIG_USB_COMMON=y
CONFIG_USB_ARCH_HAS_HCD=y
CONFIG_USB=y
# CONFIG_USB_DEBUG is not set
CONFIG_USB_ANNOUNCE_NEW_DEVICES=y

#
# Miscellaneous USB options
#
CONFIG_USB_DEFAULT_PERSIST=y
CONFIG_USB_DYNAMIC_MINORS=y
# CONFIG_USB_OTG_WHITELIST is not set
# CONFIG_USB_OTG_BLACKLIST_HUB is not set
# CONFIG_USB_MON is not set
# CONFIG_USB_WUSB_CBAF is not set

#
# USB Host Controller Drivers
#
# CONFIG_USB_C67X00_HCD is not set
# CONFIG_USB_XHCI_HCD is not set
CONFIG_USB_EHCI_HCD=y
CONFIG_USB_EHCI_ROOT_HUB_TT=y
# CONFIG_USB_EHCI_TT_NEWSCHED is not set
CONFIG_USB_EHCI_PCI=y
# CONFIG_USB_EHCI_HCD_PLATFORM is not set
# CONFIG_USB_OXU210HP_HCD is not set
# CONFIG_USB_ISP116X_HCD is not set
# CONFIG_USB_ISP1760_HCD is not set
# CONFIG_USB_ISP1362_HCD is not set
# CONFIG_USB_OHCI_HCD is not set
CONFIG_USB_UHCI_HCD=y
# CONFIG_USB_SL811_HCD is not set
# CONFIG_USB_R8A66597_HCD is not set
# CONFIG_USB_HCD_SSB is not set

#
# USB Device Class drivers
#
# CONFIG_USB_ACM is not set
# CONFIG_USB_PRINTER is not set
# CONFIG_USB_WDM is not set
# CONFIG_USB_TMC is not set

#
# NOTE: USB_STORAGE depends on SCSI but BLK_DEV_SD may
#

#
# also be needed; see USB_STORAGE Help for more info
#
CONFIG_USB_STORAGE=y
# CONFIG_USB_STORAGE_DEBUG is not set
# CONFIG_USB_STORAGE_REALTEK is not set
CONFIG_USB_STORAGE_DATAFAB=y
CONFIG_USB_STORAGE_FREECOM=y
CONFIG_USB_STORAGE_ISD200=y
CONFIG_USB_STORAGE_USBAT=y
CONFIG_USB_STORAGE_SDDR09=y
CONFIG_USB_STORAGE_SDDR55=y
CONFIG_USB_STORAGE_JUMPSHOT=y
CONFIG_USB_STORAGE_ALAUDA=y
CONFIG_USB_STORAGE_ONETOUCH=y
CONFIG_USB_STORAGE_KARMA=y
CONFIG_USB_STORAGE_CYPRESS_ATACB=y
# CONFIG_USB_STORAGE_ENE_UB6250 is not set

#
# USB Imaging devices
#
# CONFIG_USB_MDC800 is not set
# CONFIG_USB_MICROTEK is not set
# CONFIG_USB_DWC3 is not set
# CONFIG_USB_CHIPIDEA is not set

#
# USB port drivers
#
CONFIG_USB_SERIAL=y
CONFIG_USB_SERIAL_CONSOLE=y
CONFIG_USB_SERIAL_GENERIC=y
# CONFIG_USB_SERIAL_AIRCABLE is not set
# CONFIG_USB_SERIAL_ARK3116 is not set
CONFIG_USB_SERIAL_BELKIN=y
# CONFIG_USB_SERIAL_CH341 is not set
# CONFIG_USB_SERIAL_WHITEHEAT is not set
# CONFIG_USB_SERIAL_DIGI_ACCELEPORT is not set
# CONFIG_USB_SERIAL_CP210X is not set
# CONFIG_USB_SERIAL_CYPRESS_M8 is not set
# CONFIG_USB_SERIAL_EMPEG is not set
# CONFIG_USB_SERIAL_FTDI_SIO is not set
# CONFIG_USB_SERIAL_FUNSOFT is not set
# CONFIG_USB_SERIAL_VISOR is not set
# CONFIG_USB_SERIAL_IPAQ is not set
# CONFIG_USB_SERIAL_IR is not set
# CONFIG_USB_SERIAL_EDGEPORT is not set
# CONFIG_USB_SERIAL_EDGEPORT_TI is not set
# CONFIG_USB_SERIAL_F81232 is not set
# CONFIG_USB_SERIAL_GARMIN is not set
# CONFIG_USB_SERIAL_IPW is not set
# CONFIG_USB_SERIAL_IUU is not set
# CONFIG_USB_SERIAL_KEYSPAN_PDA is not set
# CONFIG_USB_SERIAL_KEYSPAN is not set
# CONFIG_USB_SERIAL_KLSI is not set
# CONFIG_USB_SERIAL_KOBIL_SCT is not set
CONFIG_USB_SERIAL_MCT_U232=y
# CONFIG_USB_SERIAL_METRO is not set
# CONFIG_USB_SERIAL_MOS7720 is not set
# CONFIG_USB_SERIAL_MOS7840 is not set
# CONFIG_USB_SERIAL_MOTOROLA is not set
# CONFIG_USB_SERIAL_NAVMAN is not set
# CONFIG_USB_SERIAL_PL2303 is not set
# CONFIG_USB_SERIAL_OTI6858 is not set
# CONFIG_USB_SERIAL_QCAUX is not set
# CONFIG_USB_SERIAL_QUALCOMM is not set
# CONFIG_USB_SERIAL_SPCP8X5 is not set
# CONFIG_USB_SERIAL_HP4X is not set
# CONFIG_USB_SERIAL_SAFE is not set
# CONFIG_USB_SERIAL_SIEMENS_MPI is not set
# CONFIG_USB_SERIAL_SIERRAWIRELESS is not set
# CONFIG_USB_SERIAL_SYMBOL is not set
# CONFIG_USB_SERIAL_TI is not set
# CONFIG_USB_SERIAL_CYBERJACK is not set
# CONFIG_USB_SERIAL_XIRCOM is not set
# CONFIG_USB_SERIAL_OPTION is not set
# CONFIG_USB_SERIAL_OMNINET is not set
# CONFIG_USB_SERIAL_OPTICON is not set
# CONFIG_USB_SERIAL_VIVOPAY_SERIAL is not set
# CONFIG_USB_SERIAL_XSENS_MT is not set
# CONFIG_USB_SERIAL_ZIO is not set
# CONFIG_USB_SERIAL_WISHBONE is not set
# CONFIG_USB_SERIAL_ZTE is not set
# CONFIG_USB_SERIAL_SSU100 is not set
# CONFIG_USB_SERIAL_QT2 is not set
# CONFIG_USB_SERIAL_DEBUG is not set

#
# USB Miscellaneous drivers
#
# CONFIG_USB_EMI62 is not set
# CONFIG_USB_EMI26 is not set
# CONFIG_USB_ADUTUX is not set
# CONFIG_USB_SEVSEG is not set
# CONFIG_USB_RIO500 is not set
# CONFIG_USB_LEGOTOWER is not set
# CONFIG_USB_LCD is not set
# CONFIG_USB_LED is not set
# CONFIG_USB_CYPRESS_CY7C63 is not set
# CONFIG_USB_CYTHERM is not set
# CONFIG_USB_IDMOUSE is not set
# CONFIG_USB_FTDI_ELAN is not set
# CONFIG_USB_APPLEDISPLAY is not set
# CONFIG_USB_SISUSBVGA is not set
# CONFIG_USB_LD is not set
# CONFIG_USB_TRANCEVIBRATOR is not set
# CONFIG_USB_IOWARRIOR is not set
CONFIG_USB_TEST=y
# CONFIG_USB_ISIGHTFW is not set
# CONFIG_USB_YUREX is not set
# CONFIG_USB_EZUSB_FX2 is not set
# CONFIG_USB_HSIC_USB3503 is not set
# CONFIG_USB_PHY is not set
# CONFIG_USB_GADGET is not set
# CONFIG_UWB is not set
# CONFIG_MMC is not set
# CONFIG_MEMSTICK is not set
CONFIG_NEW_LEDS=y
CONFIG_LEDS_CLASS=y

#
# LED drivers
#
# CONFIG_LEDS_LM3530 is not set
# CONFIG_LEDS_LM3642 is not set
# CONFIG_LEDS_PCA9532 is not set
# CONFIG_LEDS_LP3944 is not set
# CONFIG_LEDS_LP5521 is not set
# CONFIG_LEDS_LP5523 is not set
# CONFIG_LEDS_LP5562 is not set
# CONFIG_LEDS_CLEVO_MAIL is not set
# CONFIG_LEDS_PCA955X is not set
# CONFIG_LEDS_PCA9633 is not set
# CONFIG_LEDS_BD2802 is not set
# CONFIG_LEDS_INTEL_SS4200 is not set
# CONFIG_LEDS_DELL_NETBOOKS is not set
# CONFIG_LEDS_TCA6507 is not set
# CONFIG_LEDS_LM355x is not set
# CONFIG_LEDS_OT200 is not set
# CONFIG_LEDS_BLINKM is not set

#
# LED Triggers
#
CONFIG_LEDS_TRIGGERS=y
# CONFIG_LEDS_TRIGGER_TIMER is not set
# CONFIG_LEDS_TRIGGER_ONESHOT is not set
# CONFIG_LEDS_TRIGGER_IDE_DISK is not set
# CONFIG_LEDS_TRIGGER_HEARTBEAT is not set
# CONFIG_LEDS_TRIGGER_BACKLIGHT is not set
# CONFIG_LEDS_TRIGGER_CPU is not set
# CONFIG_LEDS_TRIGGER_DEFAULT_ON is not set

#
# iptables trigger is under Netfilter config (LED target)
#
# CONFIG_LEDS_TRIGGER_TRANSIENT is not set
# CONFIG_LEDS_TRIGGER_CAMERA is not set
# CONFIG_ACCESSIBILITY is not set
# CONFIG_INFINIBAND is not set
# CONFIG_EDAC is not set
CONFIG_RTC_LIB=y
CONFIG_RTC_CLASS=y
# CONFIG_RTC_DEBUG is not set

#
# RTC interfaces
#
CONFIG_RTC_INTF_SYSFS=y
CONFIG_RTC_INTF_PROC=y
CONFIG_RTC_INTF_DEV=y
# CONFIG_RTC_INTF_DEV_UIE_EMUL is not set
CONFIG_RTC_DRV_TEST=y

#
# I2C RTC drivers
#
# CONFIG_RTC_DRV_DS1307 is not set
# CONFIG_RTC_DRV_DS1374 is not set
# CONFIG_RTC_DRV_DS1672 is not set
# CONFIG_RTC_DRV_DS3232 is not set
# CONFIG_RTC_DRV_MAX6900 is not set
# CONFIG_RTC_DRV_RS5C372 is not set
# CONFIG_RTC_DRV_ISL1208 is not set
# CONFIG_RTC_DRV_ISL12022 is not set
# CONFIG_RTC_DRV_X1205 is not set
# CONFIG_RTC_DRV_PCF8523 is not set
# CONFIG_RTC_DRV_PCF8563 is not set
# CONFIG_RTC_DRV_PCF8583 is not set
# CONFIG_RTC_DRV_M41T80 is not set
# CONFIG_RTC_DRV_BQ32K is not set
# CONFIG_RTC_DRV_S35390A is not set
# CONFIG_RTC_DRV_FM3130 is not set
# CONFIG_RTC_DRV_RX8581 is not set
# CONFIG_RTC_DRV_RX8025 is not set
# CONFIG_RTC_DRV_EM3027 is not set
# CONFIG_RTC_DRV_RV3029C2 is not set

#
# SPI RTC drivers
#

#
# Platform RTC drivers
#
CONFIG_RTC_DRV_CMOS=y
# CONFIG_RTC_DRV_DS1286 is not set
# CONFIG_RTC_DRV_DS1511 is not set
# CONFIG_RTC_DRV_DS1553 is not set
# CONFIG_RTC_DRV_DS1742 is not set
# CONFIG_RTC_DRV_STK17TA8 is not set
# CONFIG_RTC_DRV_M48T86 is not set
# CONFIG_RTC_DRV_M48T35 is not set
# CONFIG_RTC_DRV_M48T59 is not set
# CONFIG_RTC_DRV_MSM6242 is not set
# CONFIG_RTC_DRV_BQ4802 is not set
# CONFIG_RTC_DRV_RP5C01 is not set
# CONFIG_RTC_DRV_V3020 is not set
# CONFIG_RTC_DRV_DS2404 is not set

#
# on-CPU RTC drivers
#

#
# HID Sensor RTC drivers
#
# CONFIG_RTC_DRV_HID_SENSOR_TIME is not set
CONFIG_DMADEVICES=y
# CONFIG_DMADEVICES_DEBUG is not set

#
# DMA Devices
#
# CONFIG_INTEL_MID_DMAC is not set
CONFIG_INTEL_IOATDMA=y
# CONFIG_DW_DMAC is not set
# CONFIG_TIMB_DMA is not set
# CONFIG_PCH_DMA is not set
CONFIG_DMA_ENGINE=y
CONFIG_DMA_ACPI=y

#
# DMA Clients
#
# CONFIG_NET_DMA is not set
# CONFIG_ASYNC_TX_DMA is not set
# CONFIG_DMATEST is not set
CONFIG_DCA=y
# CONFIG_AUXDISPLAY is not set
CONFIG_UIO=y
# CONFIG_UIO_CIF is not set
# CONFIG_UIO_PDRV is not set
# CONFIG_UIO_PDRV_GENIRQ is not set
# CONFIG_UIO_DMEM_GENIRQ is not set
# CONFIG_UIO_AEC is not set
# CONFIG_UIO_SERCOS3 is not set
# CONFIG_UIO_PCI_GENERIC is not set
# CONFIG_UIO_NETX is not set
# CONFIG_VIRT_DRIVERS is not set
CONFIG_VIRTIO=y

#
# Virtio drivers
#
CONFIG_VIRTIO_PCI=y
CONFIG_VIRTIO_BALLOON=y
CONFIG_VIRTIO_MMIO=y
# CONFIG_VIRTIO_MMIO_CMDLINE_DEVICES is not set

#
# Microsoft Hyper-V guest support
#
# CONFIG_STAGING is not set
CONFIG_X86_PLATFORM_DEVICES=y
CONFIG_ACER_WMI=y
# CONFIG_ACERHDF is not set
# CONFIG_ASUS_LAPTOP is not set
# CONFIG_CHROMEOS_LAPTOP is not set
CONFIG_DELL_WMI=y
# CONFIG_DELL_WMI_AIO is not set
# CONFIG_FUJITSU_LAPTOP is not set
# CONFIG_FUJITSU_TABLET is not set
# CONFIG_HP_ACCEL is not set
CONFIG_HP_WMI=y
# CONFIG_PANASONIC_LAPTOP is not set
CONFIG_THINKPAD_ACPI=y
CONFIG_THINKPAD_ACPI_ALSA_SUPPORT=y
# CONFIG_THINKPAD_ACPI_DEBUGFACILITIES is not set
# CONFIG_THINKPAD_ACPI_DEBUG is not set
# CONFIG_THINKPAD_ACPI_UNSAFE_LEDS is not set
CONFIG_THINKPAD_ACPI_VIDEO=y
CONFIG_THINKPAD_ACPI_HOTKEY_POLL=y
# CONFIG_SENSORS_HDAPS is not set
# CONFIG_INTEL_MENLOW is not set
CONFIG_EEEPC_LAPTOP=y
# CONFIG_ASUS_WMI is not set
CONFIG_ACPI_WMI=y
# CONFIG_MSI_WMI is not set
# CONFIG_TOPSTAR_LAPTOP is not set
# CONFIG_ACPI_TOSHIBA is not set
# CONFIG_TOSHIBA_BT_RFKILL is not set
# CONFIG_ACPI_CMPC is not set
# CONFIG_INTEL_IPS is not set
# CONFIG_IBM_RTL is not set
# CONFIG_XO15_EBOOK is not set
# CONFIG_SAMSUNG_LAPTOP is not set
# CONFIG_MXM_WMI is not set
# CONFIG_SAMSUNG_Q10 is not set
# CONFIG_APPLE_GMUX is not set
# CONFIG_PVPANIC is not set

#
# Hardware Spinlock drivers
#
CONFIG_CLKEVT_I8253=y
CONFIG_I8253_LOCK=y
CONFIG_CLKBLD_I8253=y
# CONFIG_MAILBOX is not set
CONFIG_IOMMU_SUPPORT=y
# CONFIG_AMD_IOMMU is not set
# CONFIG_INTEL_IOMMU is not set
# CONFIG_IRQ_REMAP is not set

#
# Remoteproc drivers
#
# CONFIG_STE_MODEM_RPROC is not set

#
# Rpmsg drivers
#
# CONFIG_PM_DEVFREQ is not set
# CONFIG_EXTCON is not set
# CONFIG_MEMORY is not set
# CONFIG_IIO is not set
# CONFIG_NTB is not set
# CONFIG_VME_BUS is not set
# CONFIG_PWM is not set
# CONFIG_IPACK_BUS is not set
# CONFIG_RESET_CONTROLLER is not set

#
# Firmware Drivers
#
# CONFIG_EDD is not set
CONFIG_FIRMWARE_MEMMAP=y
# CONFIG_DELL_RBU is not set
# CONFIG_DCDBAS is not set
CONFIG_DMIID=y
# CONFIG_DMI_SYSFS is not set
# CONFIG_ISCSI_IBFT_FIND is not set
# CONFIG_GOOGLE_FIRMWARE is not set

#
# EFI (Extensible Firmware Interface) Support
#
# CONFIG_EFI_VARS is not set

#
# File systems
#
CONFIG_DCACHE_WORD_ACCESS=y
# CONFIG_EXT2_FS is not set
CONFIG_EXT3_FS=y
# CONFIG_EXT3_DEFAULTS_TO_ORDERED is not set
CONFIG_EXT3_FS_XATTR=y
CONFIG_EXT3_FS_POSIX_ACL=y
CONFIG_EXT3_FS_SECURITY=y
CONFIG_EXT4_FS=y
CONFIG_EXT4_USE_FOR_EXT23=y
# CONFIG_EXT4_FS_POSIX_ACL is not set
# CONFIG_EXT4_FS_SECURITY is not set
# CONFIG_EXT4_DEBUG is not set
CONFIG_JBD=y
# CONFIG_JBD_DEBUG is not set
CONFIG_JBD2=y
# CONFIG_JBD2_DEBUG is not set
CONFIG_FS_MBCACHE=y
CONFIG_REISERFS_FS=y
# CONFIG_REISERFS_CHECK is not set
CONFIG_REISERFS_PROC_INFO=y
# CONFIG_REISERFS_FS_XATTR is not set
CONFIG_JFS_FS=y
# CONFIG_JFS_POSIX_ACL is not set
# CONFIG_JFS_SECURITY is not set
# CONFIG_JFS_DEBUG is not set
# CONFIG_JFS_STATISTICS is not set
CONFIG_XFS_FS=y
# CONFIG_XFS_QUOTA is not set
CONFIG_XFS_POSIX_ACL=y
# CONFIG_XFS_RT is not set
# CONFIG_XFS_WARN is not set
# CONFIG_XFS_DEBUG is not set
# CONFIG_GFS2_FS is not set
# CONFIG_OCFS2_FS is not set
CONFIG_BTRFS_FS=y
# CONFIG_BTRFS_FS_POSIX_ACL is not set
# CONFIG_BTRFS_FS_CHECK_INTEGRITY is not set
# CONFIG_BTRFS_FS_RUN_SANITY_TESTS is not set
# CONFIG_BTRFS_DEBUG is not set
CONFIG_NILFS2_FS=y
CONFIG_FS_POSIX_ACL=y
CONFIG_EXPORTFS=y
CONFIG_FILE_LOCKING=y
CONFIG_FSNOTIFY=y
CONFIG_DNOTIFY=y
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
# CD-ROM/DVD Filesystems
#
CONFIG_ISO9660_FS=y
# CONFIG_JOLIET is not set
# CONFIG_ZISOFS is not set
# CONFIG_UDF_FS is not set

#
# DOS/FAT/NT Filesystems
#
CONFIG_FAT_FS=y
# CONFIG_MSDOS_FS is not set
CONFIG_VFAT_FS=y
CONFIG_FAT_DEFAULT_CODEPAGE=437
CONFIG_FAT_DEFAULT_IOCHARSET="iso8859-1"
# CONFIG_NTFS_FS is not set

#
# Pseudo filesystems
#
CONFIG_PROC_FS=y
CONFIG_PROC_KCORE=y
CONFIG_PROC_VMCORE=y
CONFIG_PROC_SYSCTL=y
CONFIG_PROC_PAGE_MONITOR=y
CONFIG_SYSFS=y
CONFIG_TMPFS=y
# CONFIG_TMPFS_POSIX_ACL is not set
# CONFIG_TMPFS_XATTR is not set
CONFIG_HUGETLBFS=y
CONFIG_HUGETLB_PAGE=y
CONFIG_CONFIGFS_FS=y
CONFIG_MISC_FILESYSTEMS=y
# CONFIG_ADFS_FS is not set
# CONFIG_AFFS_FS is not set
# CONFIG_ECRYPT_FS is not set
# CONFIG_HFS_FS is not set
# CONFIG_HFSPLUS_FS is not set
# CONFIG_BEFS_FS is not set
# CONFIG_BFS_FS is not set
# CONFIG_EFS_FS is not set
# CONFIG_LOGFS is not set
CONFIG_CRAMFS=y
# CONFIG_SQUASHFS is not set
# CONFIG_VXFS_FS is not set
# CONFIG_MINIX_FS is not set
# CONFIG_OMFS_FS is not set
# CONFIG_HPFS_FS is not set
# CONFIG_QNX4FS_FS is not set
# CONFIG_QNX6FS_FS is not set
# CONFIG_ROMFS_FS is not set
# CONFIG_PSTORE is not set
# CONFIG_SYSV_FS is not set
# CONFIG_UFS_FS is not set
# CONFIG_F2FS_FS is not set
# CONFIG_EFIVAR_FS is not set
CONFIG_NETWORK_FILESYSTEMS=y
CONFIG_NFS_FS=y
CONFIG_NFS_V2=y
CONFIG_NFS_V3=y
CONFIG_NFS_V3_ACL=y
CONFIG_NFS_V4=y
# CONFIG_NFS_SWAP is not set
# CONFIG_NFS_V4_1 is not set
CONFIG_ROOT_NFS=y
# CONFIG_NFS_USE_LEGACY_DNS is not set
CONFIG_NFS_USE_KERNEL_DNS=y
CONFIG_NFSD=y
CONFIG_NFSD_V3=y
# CONFIG_NFSD_V3_ACL is not set
CONFIG_NFSD_V4=y
# CONFIG_NFSD_FAULT_INJECTION is not set
CONFIG_LOCKD=y
CONFIG_LOCKD_V4=y
CONFIG_NFS_ACL_SUPPORT=y
CONFIG_NFS_COMMON=y
CONFIG_SUNRPC=y
CONFIG_SUNRPC_GSS=y
# CONFIG_SUNRPC_DEBUG is not set
# CONFIG_CEPH_FS is not set
CONFIG_CIFS=y
CONFIG_CIFS_STATS=y
CONFIG_CIFS_STATS2=y
# CONFIG_CIFS_WEAK_PW_HASH is not set
# CONFIG_CIFS_UPCALL is not set
CONFIG_CIFS_XATTR=y
CONFIG_CIFS_POSIX=y
# CONFIG_CIFS_ACL is not set
CONFIG_CIFS_DEBUG=y
CONFIG_CIFS_DEBUG2=y
# CONFIG_CIFS_DFS_UPCALL is not set
# CONFIG_CIFS_SMB2 is not set
# CONFIG_NCP_FS is not set
# CONFIG_CODA_FS is not set
# CONFIG_AFS_FS is not set
CONFIG_9P_FS=y
CONFIG_9P_FS_POSIX_ACL=y
CONFIG_NLS=y
CONFIG_NLS_DEFAULT="iso8859-1"
CONFIG_NLS_CODEPAGE_437=y
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
CONFIG_NLS_CODEPAGE_936=y
# CONFIG_NLS_CODEPAGE_950 is not set
# CONFIG_NLS_CODEPAGE_932 is not set
# CONFIG_NLS_CODEPAGE_949 is not set
# CONFIG_NLS_CODEPAGE_874 is not set
# CONFIG_NLS_ISO8859_8 is not set
# CONFIG_NLS_CODEPAGE_1250 is not set
# CONFIG_NLS_CODEPAGE_1251 is not set
# CONFIG_NLS_ASCII is not set
CONFIG_NLS_ISO8859_1=y
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
CONFIG_NLS_UTF8=y
# CONFIG_DLM is not set

#
# Kernel hacking
#
CONFIG_TRACE_IRQFLAGS_SUPPORT=y
CONFIG_PRINTK_TIME=y
CONFIG_DEFAULT_MESSAGE_LOGLEVEL=4
CONFIG_ENABLE_WARN_DEPRECATED=y
CONFIG_ENABLE_MUST_CHECK=y
CONFIG_FRAME_WARN=2048
CONFIG_MAGIC_SYSRQ=y
# CONFIG_STRIP_ASM_SYMS is not set
# CONFIG_READABLE_ASM is not set
# CONFIG_UNUSED_SYMBOLS is not set
CONFIG_DEBUG_FS=y
# CONFIG_HEADERS_CHECK is not set
CONFIG_DEBUG_SECTION_MISMATCH=y
CONFIG_DEBUG_KERNEL=y
CONFIG_DEBUG_SHIRQ=y
# CONFIG_LOCKUP_DETECTOR is not set
# CONFIG_PANIC_ON_OOPS is not set
CONFIG_PANIC_ON_OOPS_VALUE=0
CONFIG_DETECT_HUNG_TASK=y
CONFIG_DEFAULT_HUNG_TASK_TIMEOUT=120
CONFIG_BOOTPARAM_HUNG_TASK_PANIC=y
CONFIG_BOOTPARAM_HUNG_TASK_PANIC_VALUE=1
CONFIG_SCHED_DEBUG=y
CONFIG_SCHEDSTATS=y
CONFIG_TIMER_STATS=y
CONFIG_DEBUG_OBJECTS=y
# CONFIG_DEBUG_OBJECTS_SELFTEST is not set
# CONFIG_DEBUG_OBJECTS_FREE is not set
# CONFIG_DEBUG_OBJECTS_TIMERS is not set
# CONFIG_DEBUG_OBJECTS_WORK is not set
# CONFIG_DEBUG_OBJECTS_RCU_HEAD is not set
# CONFIG_DEBUG_OBJECTS_PERCPU_COUNTER is not set
CONFIG_DEBUG_OBJECTS_ENABLE_DEFAULT=1
CONFIG_SLUB_DEBUG_ON=y
CONFIG_SLUB_STATS=y
CONFIG_HAVE_DEBUG_KMEMLEAK=y
# CONFIG_DEBUG_KMEMLEAK is not set
CONFIG_DEBUG_RT_MUTEXES=y
CONFIG_DEBUG_PI_LIST=y
CONFIG_RT_MUTEX_TESTER=y
CONFIG_DEBUG_SPINLOCK=y
CONFIG_DEBUG_MUTEXES=y
CONFIG_DEBUG_LOCK_ALLOC=y
CONFIG_PROVE_LOCKING=y
CONFIG_LOCKDEP=y
CONFIG_LOCK_STAT=y
# CONFIG_DEBUG_LOCKDEP is not set
CONFIG_TRACE_IRQFLAGS=y
CONFIG_DEBUG_ATOMIC_SLEEP=y
CONFIG_DEBUG_LOCKING_API_SELFTESTS=y
CONFIG_STACKTRACE=y
CONFIG_DEBUG_STACK_USAGE=y
# CONFIG_DEBUG_KOBJECT is not set
CONFIG_DEBUG_BUGVERBOSE=y
CONFIG_DEBUG_INFO=y
CONFIG_DEBUG_VM=y
# CONFIG_DEBUG_VM_RB is not set
CONFIG_DEBUG_VIRTUAL=y
CONFIG_DEBUG_WRITECOUNT=y
CONFIG_DEBUG_MEMORY_INIT=y
CONFIG_DEBUG_LIST=y
CONFIG_TEST_LIST_SORT=y
CONFIG_DEBUG_SG=y
CONFIG_DEBUG_NOTIFIERS=y
CONFIG_DEBUG_CREDENTIALS=y
CONFIG_ARCH_WANT_FRAME_POINTERS=y
CONFIG_FRAME_POINTER=y
CONFIG_BOOT_PRINTK_DELAY=y

#
# RCU Debugging
#
# CONFIG_PROVE_RCU is not set
CONFIG_SPARSE_RCU_POINTER=y
# CONFIG_RCU_TORTURE_TEST is not set
# CONFIG_RCU_TORTURE_TEST_RUNNABLE is not set
CONFIG_RCU_CPU_STALL_TIMEOUT=60
CONFIG_RCU_CPU_STALL_INFO=y
CONFIG_RCU_TRACE=y
CONFIG_KPROBES_SANITY_TEST=y
# CONFIG_BACKTRACE_SELF_TEST is not set
# CONFIG_DEBUG_BLOCK_EXT_DEVT is not set
CONFIG_DEBUG_FORCE_WEAK_PER_CPU=y
CONFIG_DEBUG_PER_CPU_MAPS=y
CONFIG_LKDTM=y
# CONFIG_NOTIFIER_ERROR_INJECTION is not set
CONFIG_FAULT_INJECTION=y
# CONFIG_FAILSLAB is not set
CONFIG_FAIL_PAGE_ALLOC=y
CONFIG_FAIL_MAKE_REQUEST=y
# CONFIG_FAIL_IO_TIMEOUT is not set
CONFIG_FAULT_INJECTION_DEBUG_FS=y
CONFIG_LATENCYTOP=y
CONFIG_ARCH_HAS_DEBUG_STRICT_USER_COPY_CHECKS=y
# CONFIG_DEBUG_STRICT_USER_COPY_CHECKS is not set
# CONFIG_DEBUG_PAGEALLOC is not set
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
CONFIG_FUNCTION_GRAPH_TRACER=y
CONFIG_IRQSOFF_TRACER=y
CONFIG_SCHED_TRACER=y
CONFIG_FTRACE_SYSCALLS=y
CONFIG_TRACER_SNAPSHOT=y
CONFIG_TRACER_SNAPSHOT_PER_CPU_SWAP=y
CONFIG_BRANCH_PROFILE_NONE=y
# CONFIG_PROFILE_ANNOTATED_BRANCHES is not set
# CONFIG_PROFILE_ALL_BRANCHES is not set
# CONFIG_STACK_TRACER is not set
CONFIG_BLK_DEV_IO_TRACE=y
CONFIG_KPROBE_EVENT=y
# CONFIG_UPROBE_EVENT is not set
CONFIG_PROBE_EVENTS=y
CONFIG_DYNAMIC_FTRACE=y
CONFIG_DYNAMIC_FTRACE_WITH_REGS=y
CONFIG_FUNCTION_PROFILER=y
CONFIG_FTRACE_MCOUNT_RECORD=y
# CONFIG_FTRACE_STARTUP_TEST is not set
CONFIG_MMIOTRACE=y
CONFIG_MMIOTRACE_TEST=m
# CONFIG_RING_BUFFER_BENCHMARK is not set
# CONFIG_RING_BUFFER_STARTUP_TEST is not set
# CONFIG_RBTREE_TEST is not set
# CONFIG_INTERVAL_TREE_TEST is not set
# CONFIG_PROVIDE_OHCI1394_DMA_INIT is not set
# CONFIG_DYNAMIC_DEBUG is not set
CONFIG_DMA_API_DEBUG=y
CONFIG_ATOMIC64_SELFTEST=y
# CONFIG_ASYNC_RAID6_TEST is not set
# CONFIG_SAMPLES is not set
CONFIG_HAVE_ARCH_KGDB=y
# CONFIG_KGDB is not set
CONFIG_HAVE_ARCH_KMEMCHECK=y
# CONFIG_TEST_STRING_HELPERS is not set
# CONFIG_TEST_KSTRTOX is not set
# CONFIG_STRICT_DEVMEM is not set
CONFIG_X86_VERBOSE_BOOTUP=y
CONFIG_EARLY_PRINTK=y
# CONFIG_EARLY_PRINTK_DBGP is not set
CONFIG_DEBUG_STACKOVERFLOW=y
CONFIG_X86_PTDUMP=y
# CONFIG_DEBUG_RODATA is not set
# CONFIG_DEBUG_SET_MODULE_RONX is not set
CONFIG_DEBUG_NX_TEST=m
# CONFIG_DEBUG_TLBFLUSH is not set
# CONFIG_IOMMU_STRESS is not set
CONFIG_HAVE_MMIOTRACE_SUPPORT=y
# CONFIG_X86_DECODER_SELFTEST is not set
CONFIG_IO_DELAY_TYPE_0X80=0
CONFIG_IO_DELAY_TYPE_0XED=1
CONFIG_IO_DELAY_TYPE_UDELAY=2
CONFIG_IO_DELAY_TYPE_NONE=3
CONFIG_IO_DELAY_0X80=y
# CONFIG_IO_DELAY_0XED is not set
# CONFIG_IO_DELAY_UDELAY is not set
# CONFIG_IO_DELAY_NONE is not set
CONFIG_DEFAULT_IO_DELAY_TYPE=0
# CONFIG_DEBUG_BOOT_PARAMS is not set
# CONFIG_CPA_DEBUG is not set
# CONFIG_OPTIMIZE_INLINING is not set
CONFIG_DEBUG_NMI_SELFTEST=y

#
# Security options
#
CONFIG_KEYS=y
# CONFIG_ENCRYPTED_KEYS is not set
# CONFIG_KEYS_DEBUG_PROC_KEYS is not set
# CONFIG_SECURITY_DMESG_RESTRICT is not set
# CONFIG_SECURITY is not set
# CONFIG_SECURITYFS is not set
CONFIG_DEFAULT_SECURITY_DAC=y
CONFIG_DEFAULT_SECURITY=""
CONFIG_XOR_BLOCKS=y
CONFIG_ASYNC_CORE=y
CONFIG_ASYNC_MEMCPY=y
CONFIG_ASYNC_XOR=y
CONFIG_ASYNC_PQ=y
CONFIG_ASYNC_RAID6_RECOV=y
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
CONFIG_CRYPTO_RNG2=y
CONFIG_CRYPTO_PCOMP2=y
CONFIG_CRYPTO_MANAGER=y
CONFIG_CRYPTO_MANAGER2=y
# CONFIG_CRYPTO_USER is not set
CONFIG_CRYPTO_MANAGER_DISABLE_TESTS=y
CONFIG_CRYPTO_GF128MUL=y
CONFIG_CRYPTO_NULL=y
# CONFIG_CRYPTO_PCRYPT is not set
CONFIG_CRYPTO_WORKQUEUE=y
# CONFIG_CRYPTO_CRYPTD is not set
CONFIG_CRYPTO_AUTHENC=y
# CONFIG_CRYPTO_TEST is not set

#
# Authenticated Encryption with Associated Data
#
# CONFIG_CRYPTO_CCM is not set
# CONFIG_CRYPTO_GCM is not set
# CONFIG_CRYPTO_SEQIV is not set

#
# Block modes
#
CONFIG_CRYPTO_CBC=y
# CONFIG_CRYPTO_CTR is not set
# CONFIG_CRYPTO_CTS is not set
CONFIG_CRYPTO_ECB=y
# CONFIG_CRYPTO_LRW is not set
# CONFIG_CRYPTO_PCBC is not set
CONFIG_CRYPTO_XTS=y

#
# Hash modes
#
# CONFIG_CRYPTO_CMAC is not set
CONFIG_CRYPTO_HMAC=y
# CONFIG_CRYPTO_XCBC is not set
# CONFIG_CRYPTO_VMAC is not set

#
# Digest
#
CONFIG_CRYPTO_CRC32C=y
# CONFIG_CRYPTO_CRC32C_INTEL is not set
# CONFIG_CRYPTO_CRC32 is not set
# CONFIG_CRYPTO_CRC32_PCLMUL is not set
# CONFIG_CRYPTO_GHASH is not set
CONFIG_CRYPTO_MD4=y
CONFIG_CRYPTO_MD5=y
# CONFIG_CRYPTO_MICHAEL_MIC is not set
# CONFIG_CRYPTO_RMD128 is not set
# CONFIG_CRYPTO_RMD160 is not set
# CONFIG_CRYPTO_RMD256 is not set
# CONFIG_CRYPTO_RMD320 is not set
CONFIG_CRYPTO_SHA1=y
# CONFIG_CRYPTO_SHA1_SSSE3 is not set
# CONFIG_CRYPTO_SHA256_SSSE3 is not set
# CONFIG_CRYPTO_SHA512_SSSE3 is not set
CONFIG_CRYPTO_SHA256=y
CONFIG_CRYPTO_SHA512=y
# CONFIG_CRYPTO_TGR192 is not set
# CONFIG_CRYPTO_WP512 is not set
# CONFIG_CRYPTO_GHASH_CLMUL_NI_INTEL is not set

#
# Ciphers
#
CONFIG_CRYPTO_AES=y
# CONFIG_CRYPTO_AES_X86_64 is not set
# CONFIG_CRYPTO_AES_NI_INTEL is not set
# CONFIG_CRYPTO_ANUBIS is not set
CONFIG_CRYPTO_ARC4=y
# CONFIG_CRYPTO_BLOWFISH is not set
# CONFIG_CRYPTO_BLOWFISH_X86_64 is not set
# CONFIG_CRYPTO_BLOWFISH_AVX2_X86_64 is not set
# CONFIG_CRYPTO_CAMELLIA is not set
# CONFIG_CRYPTO_CAMELLIA_X86_64 is not set
# CONFIG_CRYPTO_CAMELLIA_AESNI_AVX_X86_64 is not set
# CONFIG_CRYPTO_CAMELLIA_AESNI_AVX2_X86_64 is not set
# CONFIG_CRYPTO_CAST5 is not set
# CONFIG_CRYPTO_CAST5_AVX_X86_64 is not set
# CONFIG_CRYPTO_CAST6 is not set
# CONFIG_CRYPTO_CAST6_AVX_X86_64 is not set
CONFIG_CRYPTO_DES=y
# CONFIG_CRYPTO_FCRYPT is not set
# CONFIG_CRYPTO_KHAZAD is not set
# CONFIG_CRYPTO_SALSA20 is not set
# CONFIG_CRYPTO_SALSA20_X86_64 is not set
# CONFIG_CRYPTO_SEED is not set
# CONFIG_CRYPTO_SERPENT is not set
# CONFIG_CRYPTO_SERPENT_SSE2_X86_64 is not set
# CONFIG_CRYPTO_SERPENT_AVX_X86_64 is not set
# CONFIG_CRYPTO_SERPENT_AVX2_X86_64 is not set
# CONFIG_CRYPTO_TEA is not set
# CONFIG_CRYPTO_TWOFISH is not set
# CONFIG_CRYPTO_TWOFISH_X86_64 is not set
# CONFIG_CRYPTO_TWOFISH_X86_64_3WAY is not set
# CONFIG_CRYPTO_TWOFISH_AVX_X86_64 is not set
# CONFIG_CRYPTO_TWOFISH_AVX2_X86_64 is not set

#
# Compression
#
CONFIG_CRYPTO_DEFLATE=y
# CONFIG_CRYPTO_ZLIB is not set
# CONFIG_CRYPTO_LZO is not set

#
# Random Number Generation
#
# CONFIG_CRYPTO_ANSI_CPRNG is not set
# CONFIG_CRYPTO_USER_API_HASH is not set
# CONFIG_CRYPTO_USER_API_SKCIPHER is not set
CONFIG_CRYPTO_HW=y
# CONFIG_CRYPTO_DEV_PADLOCK is not set
# CONFIG_ASYMMETRIC_KEY_TYPE is not set
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
# CONFIG_KVM_AMD is not set
# CONFIG_KVM_MMU_AUDIT is not set
CONFIG_BINARY_PRINTF=y

#
# Library routines
#
CONFIG_RAID6_PQ=y
CONFIG_BITREVERSE=y
CONFIG_GENERIC_STRNCPY_FROM_USER=y
CONFIG_GENERIC_STRNLEN_USER=y
CONFIG_GENERIC_FIND_FIRST_BIT=y
CONFIG_GENERIC_PCI_IOMAP=y
CONFIG_GENERIC_IOMAP=y
CONFIG_GENERIC_IO=y
CONFIG_CRC_CCITT=y
CONFIG_CRC16=y
CONFIG_CRC_T10DIF=y
# CONFIG_CRC_ITU_T is not set
CONFIG_CRC32=y
# CONFIG_CRC32_SELFTEST is not set
CONFIG_CRC32_SLICEBY8=y
# CONFIG_CRC32_SLICEBY4 is not set
# CONFIG_CRC32_SARWATE is not set
# CONFIG_CRC32_BIT is not set
# CONFIG_CRC7 is not set
CONFIG_LIBCRC32C=y
# CONFIG_CRC8 is not set
CONFIG_ZLIB_INFLATE=y
CONFIG_ZLIB_DEFLATE=y
CONFIG_LZO_COMPRESS=y
CONFIG_LZO_DECOMPRESS=y
# CONFIG_XZ_DEC is not set
# CONFIG_XZ_DEC_BCJ is not set
CONFIG_DECOMPRESS_GZIP=y
CONFIG_TEXTSEARCH=y
CONFIG_TEXTSEARCH_KMP=y
CONFIG_TEXTSEARCH_BM=y
CONFIG_TEXTSEARCH_FSM=y
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
# CONFIG_DDR is not set
CONFIG_OID_REGISTRY=y
CONFIG_UCS2_STRING=y
# CONFIG_IIO_SIMPLE_DUMMY is not set
# CONFIG_DRM_TTM is not set
# CONFIG_ISDN_DRV_LOOP is not set
# CONFIG_PCI_ATS is not set

--fUYQa+Pmc3FrFX/N
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="dmesg-kvm-xian-2307-20130615060932-3.10.0-rc1-587"

[    0.000000] Initializing cgroup subsys cpuset
[    0.000000] Initializing cgroup subsys cpu
[    0.000000] Linux version 3.10.0-rc1 (kbuild@inn) (gcc version 4.7.1 (Debian 4.7.1-6) ) #587 SMP Thu May 16 14:41:50 CST 2013
[    0.000000] Command line: hung_task_panic=1 rcutree.rcu_cpu_stall_timeout=100 log_buf_len=8M ignore_loglevel debug sched_debug apic=debug dynamic_printk sysrq_always_enabled panic=10 load_ramdisk=2 prompt_ramdisk=0 console=ttyS0,115200 console=tty0 vga=normal ip=::::kvm::dhcp nfsroot=192.168.1.1:/nfsroot/wfg,tcp,v3,nocto,actimeo=600,nolock,rsize=524288,wsize=524288 rw link=/kernel-tests/run-queue/kvm/x86_64-nfsroot/xfs:for-next:f722406faae2d073cc1d01063d1123c35425939e:bisect-mm/.vmlinuz-f722406faae2d073cc1d01063d1123c35425939e-20130615060710-33-xian branch=xfs/for-next  BOOT_IMAGE=/kernel/x86_64-nfsroot/f722406faae2d073cc1d01063d1123c35425939e/vmlinuz-3.10.0-rc1
[    0.000000] KERNEL supported cpus:
[    0.000000]   Intel GenuineIntel
[    0.000000]   Centaur CentaurHauls
[    0.000000] e820: BIOS-provided physical RAM map:
[    0.000000] BIOS-e820: [mem 0x0000000000000000-0x0000000000093bff] usable
[    0.000000] BIOS-e820: [mem 0x0000000000093c00-0x000000000009ffff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000000f0000-0x00000000000fffff] reserved
[    0.000000] BIOS-e820: [mem 0x0000000000100000-0x000000001fffdfff] usable
[    0.000000] BIOS-e820: [mem 0x000000001fffe000-0x000000001fffffff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000feffc000-0x00000000feffffff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000fffc0000-0x00000000ffffffff] reserved
[    0.000000] debug: ignoring loglevel setting.
[    0.000000] NX (Execute Disable) protection: active
[    0.000000] SMBIOS 2.4 present.
[    0.000000] DMI: Bochs Bochs, BIOS Bochs 01/01/2007
[    0.000000] e820: update [mem 0x00000000-0x00000fff] usable ==> reserved
[    0.000000] e820: remove [mem 0x000a0000-0x000fffff] usable
[    0.000000] e820: last_pfn = 0x1fffe max_arch_pfn = 0x400000000
[    0.000000] MTRR default type: write-back
[    0.000000] MTRR fixed ranges enabled:
[    0.000000]   00000-9FFFF write-back
[    0.000000]   A0000-BFFFF uncachable
[    0.000000]   C0000-FFFFF write-protect
[    0.000000] MTRR variable ranges enabled:
[    0.000000]   0 base 00E0000000 mask FFE0000000 uncachable
[    0.000000]   1 disabled
[    0.000000]   2 disabled
[    0.000000]   3 disabled
[    0.000000]   4 disabled
[    0.000000]   5 disabled
[    0.000000]   6 disabled
[    0.000000]   7 disabled
[    0.000000] x86 PAT enabled: cpu 0, old 0x70406, new 0x7010600070106
[    0.000000] Scan for SMP in [mem 0x00000000-0x000003ff]
[    0.000000] Scan for SMP in [mem 0x0009fc00-0x0009ffff]
[    0.000000] Scan for SMP in [mem 0x000f0000-0x000fffff]
[    0.000000] found SMP MP-table at [mem 0x000fdab0-0x000fdabf] mapped at [ffff8800000fdab0]
[    0.000000]   mpc: fdac0-fdbe4
[    0.000000] Scanning 1 areas for low memory corruption
[    0.000000] Base memory trampoline at [ffff88000008d000] 8d000 size 24576
[    0.000000] init_memory_mapping: [mem 0x00000000-0x000fffff]
[    0.000000]  [mem 0x00000000-0x000fffff] page 4k
[    0.000000] BRK [0x02fa9000, 0x02fa9fff] PGTABLE
[    0.000000] BRK [0x02faa000, 0x02faafff] PGTABLE
[    0.000000] BRK [0x02fab000, 0x02fabfff] PGTABLE
[    0.000000] init_memory_mapping: [mem 0x1fc00000-0x1fdfffff]
[    0.000000]  [mem 0x1fc00000-0x1fdfffff] page 4k
[    0.000000] BRK [0x02fac000, 0x02facfff] PGTABLE
[    0.000000] init_memory_mapping: [mem 0x1c000000-0x1fbfffff]
[    0.000000]  [mem 0x1c000000-0x1fbfffff] page 4k
[    0.000000] BRK [0x02fad000, 0x02fadfff] PGTABLE
[    0.000000] init_memory_mapping: [mem 0x00100000-0x1bffffff]
[    0.000000]  [mem 0x00100000-0x1bffffff] page 4k
[    0.000000] init_memory_mapping: [mem 0x1fe00000-0x1fffdfff]
[    0.000000]  [mem 0x1fe00000-0x1fffdfff] page 4k
[    0.000000] log_buf_len: 8388608
[    0.000000] early log buf free: 258208(98%)
[    0.000000] ACPI: RSDP 00000000000fd920 00014 (v00 BOCHS )
[    0.000000] ACPI: RSDT 000000001fffe550 00038 (v01 BOCHS  BXPCRSDT 00000001 BXPC 00000001)
[    0.000000] ACPI: FACP 000000001fffff80 00074 (v01 BOCHS  BXPCFACP 00000001 BXPC 00000001)
[    0.000000] ACPI: DSDT 000000001fffe590 01121 (v01   BXPC   BXDSDT 00000001 INTL 20100528)
[    0.000000] ACPI: FACS 000000001fffff40 00040
[    0.000000] ACPI: SSDT 000000001ffffe40 000FF (v01 BOCHS  BXPCSSDT 00000001 BXPC 00000001)
[    0.000000] ACPI: APIC 000000001ffffd50 00080 (v01 BOCHS  BXPCAPIC 00000001 BXPC 00000001)
[    0.000000] ACPI: HPET 000000001ffffd10 00038 (v01 BOCHS  BXPCHPET 00000001 BXPC 00000001)
[    0.000000] ACPI: SSDT 000000001ffff6c0 00644 (v01   BXPC BXSSDTPC 00000001 INTL 20100528)
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] mapped APIC to ffffffffff5fb000 (        fee00000)
[    0.000000] No NUMA configuration found
[    0.000000] Faking a node at [mem 0x0000000000000000-0x000000001fffdfff]
[    0.000000] Initmem setup node 0 [mem 0x00000000-0x1fffdfff]
[    0.000000]   NODE_DATA [mem 0x1fff9000-0x1fffdfff]
[    0.000000]  [ffffea0000000000-ffffea00007fffff] PMD -> [ffff88001e400000-ffff88001ebfffff] on node 0
[    0.000000] Zone ranges:
[    0.000000]   DMA      [mem 0x00001000-0x00ffffff]
[    0.000000]   DMA32    [mem 0x01000000-0xffffffff]
[    0.000000]   Normal   empty
[    0.000000] Movable zone start for each node
[    0.000000] Early memory node ranges
[    0.000000]   node   0: [mem 0x00001000-0x00092fff]
[    0.000000]   node   0: [mem 0x00100000-0x1fffdfff]
[    0.000000] On node 0 totalpages: 130960
[    0.000000]   DMA zone: 64 pages used for memmap
[    0.000000]   DMA zone: 21 pages reserved
[    0.000000]   DMA zone: 3986 pages, LIFO batch:0
[    0.000000]   DMA32 zone: 1984 pages used for memmap
[    0.000000]   DMA32 zone: 126974 pages, LIFO batch:31
[    0.000000] ACPI: PM-Timer IO Port: 0xb008
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] mapped APIC to ffffffffff5fb000 (        fee00000)
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
[    0.000000] mapped IOAPIC to ffffffffff5fa000 (fec00000)
[    0.000000] nr_irqs_gsi: 40
[    0.000000] PM: Registered nosave memory: 0000000000093000 - 0000000000094000
[    0.000000] PM: Registered nosave memory: 0000000000094000 - 00000000000a0000
[    0.000000] PM: Registered nosave memory: 00000000000a0000 - 00000000000f0000
[    0.000000] PM: Registered nosave memory: 00000000000f0000 - 0000000000100000
[    0.000000] e820: [mem 0x20000000-0xfeffbfff] available for PCI devices
[    0.000000] setup_percpu: NR_CPUS:64 nr_cpumask_bits:64 nr_cpu_ids:2 nr_node_ids:1
[    0.000000] PERCPU: Embedded 476 pages/cpu @ffff88001f000000 s1920384 r8192 d21120 u2097152
[    0.000000] pcpu-alloc: s1920384 r8192 d21120 u2097152 alloc=1*2097152
[    0.000000] pcpu-alloc: [0] 0 [0] 1 
[    0.000000] Built 1 zonelists in Node order, mobility grouping on.  Total pages: 128891
[    0.000000] Policy zone: DMA32
[    0.000000] Kernel command line: hung_task_panic=1 rcutree.rcu_cpu_stall_timeout=100 log_buf_len=8M ignore_loglevel debug sched_debug apic=debug dynamic_printk sysrq_always_enabled panic=10 load_ramdisk=2 prompt_ramdisk=0 console=ttyS0,115200 console=tty0 vga=normal ip=::::kvm::dhcp nfsroot=192.168.1.1:/nfsroot/wfg,tcp,v3,nocto,actimeo=600,nolock,rsize=524288,wsize=524288 rw link=/kernel-tests/run-queue/kvm/x86_64-nfsroot/xfs:for-next:f722406faae2d073cc1d01063d1123c35425939e:bisect-mm/.vmlinuz-f722406faae2d073cc1d01063d1123c35425939e-20130615060710-33-xian branch=xfs/for-next  BOOT_IMAGE=/kernel/x86_64-nfsroot/f722406faae2d073cc1d01063d1123c35425939e/vmlinuz-3.10.0-rc1
[    0.000000] sysrq: sysrq always enabled.
[    0.000000] PID hash table entries: 2048 (order: 2, 16384 bytes)
[    0.000000] Memory: 469352k/524280k available (11015k kernel code, 440k absent, 54488k reserved, 6683k data, 3208k init)
[    0.000000] SLUB: HWalign=64, Order=0-3, MinObjects=0, CPUs=2, Nodes=1
[    0.000000] Hierarchical RCU implementation.
[    0.000000] 
[    0.000000] 
[    0.000000] 
[    0.000000] NR_IRQS:4352 nr_irqs:512 16
[    0.000000] Console: colour VGA+ 80x25
[    0.000000] console [tty0] enabled
[    0.000000] console [ttyS0] enabled
[    0.000000] Lock dependency validator: Copyright (c) 2006 Red Hat, Inc., Ingo Molnar
[    0.000000] ... MAX_LOCKDEP_SUBCLASSES:  8
[    0.000000] ... MAX_LOCK_DEPTH:          48
[    0.000000] ... MAX_LOCKDEP_KEYS:        8191
[    0.000000] ... CLASSHASH_SIZE:          4096
[    0.000000] ... MAX_LOCKDEP_ENTRIES:     16384
[    0.000000] ... MAX_LOCKDEP_CHAINS:      32768
[    0.000000] ... CHAINHASH_SIZE:          16384
[    0.000000]  memory used by lock dependency info: 6367 kB
[    0.000000]  per task-struct memory footprint: 2688 bytes
[    0.000000] ------------------------
[    0.000000] | Locking API testsuite:
[    0.000000] ----------------------------------------------------------------------------
[    0.000000]                                  | spin |wlock |rlock |mutex | wsem | rsem |
[    0.000000]   --------------------------------------------------------------------------
[    0.000000]                      A-A deadlock:  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |
[    0.000000]                  A-B-B-A deadlock:  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |
[    0.000000]              A-B-B-C-C-A deadlock:  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |
[    0.000000]              A-B-C-A-B-C deadlock:  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |
[    0.000000]          A-B-B-C-C-D-D-A deadlock:  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |
[    0.000000]          A-B-C-D-B-D-D-A deadlock:  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |
[    0.000000]          A-B-C-D-B-C-D-A deadlock:  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |
[    0.000000]                     double unlock:  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |
[    0.000000]                   initialize held:  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |
[    0.000000]                  bad unlock order:  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |
[    0.000000]   --------------------------------------------------------------------------
[    0.000000]               recursive read-lock:             |  ok  |             |  ok  |
[    0.000000]            recursive read-lock #2:             |  ok  |             |  ok  |
[    0.000000]             mixed read-write-lock:             |  ok  |             |  ok  |
[    0.000000]             mixed write-read-lock:             |  ok  |             |  ok  |
[    0.000000]   --------------------------------------------------------------------------
[    0.000000]      hard-irqs-on + irq-safe-A/12:  ok  |  ok  |  ok  |
[    0.000000]      soft-irqs-on + irq-safe-A/12:  ok  |  ok  |  ok  |
[    0.000000]      hard-irqs-on + irq-safe-A/21:  ok  |  ok  |  ok  |
[    0.000000]      soft-irqs-on + irq-safe-A/21:  ok  |  ok  |  ok  |
[    0.000000]        sirq-safe-A => hirqs-on/12:  ok  |  ok  |  ok  |
[    0.000000]        sirq-safe-A => hirqs-on/21:  ok  |  ok  |  ok  |
[    0.000000]          hard-safe-A + irqs-on/12:  ok  |  ok  |  ok  |
[    0.000000]          soft-safe-A + irqs-on/12:  ok  |  ok  |  ok  |
[    0.000000]          hard-safe-A + irqs-on/21:  ok  |  ok  |  ok  |
[    0.000000]          soft-safe-A + irqs-on/21:  ok  |  ok  |  ok  |
[    0.000000]     hard-safe-A + unsafe-B #1/123:  ok  |  ok  |  ok  |
[    0.000000]     soft-safe-A + unsafe-B #1/123:  ok  |  ok  |  ok  |
[    0.000000]     hard-safe-A + unsafe-B #1/132:  ok  |  ok  |  ok  |
[    0.000000]     soft-safe-A + unsafe-B #1/132:  ok  |  ok  |  ok  |
[    0.000000]     hard-safe-A + unsafe-B #1/213:  ok  |  ok  |  ok  |
[    0.000000]     soft-safe-A + unsafe-B #1/213:  ok  |  ok  |  ok  |
[    0.000000]     hard-safe-A + unsafe-B #1/231:  ok  |  ok  |  ok  |
[    0.000000]     soft-safe-A + unsafe-B #1/231:  ok  |  ok  |  ok  |
[    0.000000]     hard-safe-A + unsafe-B #1/312:  ok  |  ok  |  ok  |
[    0.000000]     soft-safe-A + unsafe-B #1/312:  ok  |  ok  |  ok  |
[    0.000000]     hard-safe-A + unsafe-B #1/321:  ok  |  ok  |  ok  |
[    0.000000]     soft-safe-A + unsafe-B #1/321:  ok  |  ok  |  ok  |
[    0.000000]     hard-safe-A + unsafe-B #2/123:  ok  |  ok  |  ok  |
[    0.000000]     soft-safe-A + unsafe-B #2/123:  ok  |  ok  |  ok  |
[    0.000000]     hard-safe-A + unsafe-B #2/132:  ok  |  ok  |  ok  |
[    0.000000]     soft-safe-A + unsafe-B #2/132:  ok  |  ok  |  ok  |
[    0.000000]     hard-safe-A + unsafe-B #2/213:  ok  |  ok  |  ok  |
[    0.000000]     soft-safe-A + unsafe-B #2/213:  ok  |  ok  |  ok  |
[    0.000000]     hard-safe-A + unsafe-B #2/231:  ok  |  ok  |  ok  |
[    0.000000]     soft-safe-A + unsafe-B #2/231:  ok  |  ok  |  ok  |
[    0.000000]     hard-safe-A + unsafe-B #2/312:  ok  |  ok  |  ok  |
[    0.000000]     soft-safe-A + unsafe-B #2/312:  ok  |  ok  |  ok  |
[    0.000000]     hard-safe-A + unsafe-B #2/321:  ok  |  ok  |  ok  |
[    0.000000]     soft-safe-A + unsafe-B #2/321:  ok  |  ok  |  ok  |
[    0.000000]       hard-irq lock-inversion/123:  ok  |  ok  |  ok  |
[    0.000000]       soft-irq lock-inversion/123:  ok  |  ok  |  ok  |
[    0.000000]       hard-irq lock-inversion/132:  ok  |  ok  |  ok  |
[    0.000000]       soft-irq lock-inversion/132:  ok  |  ok  |  ok  |
[    0.000000]       hard-irq lock-inversion/213:  ok  |  ok  |  ok  |
[    0.000000]       soft-irq lock-inversion/213:  ok  |  ok  |  ok  |
[    0.000000]       hard-irq lock-inversion/231:  ok  |  ok  |  ok  |
[    0.000000]       soft-irq lock-inversion/231:  ok  |  ok  |  ok  |
[    0.000000]       hard-irq lock-inversion/312:  ok  |  ok  |  ok  |
[    0.000000]       soft-irq lock-inversion/312:  ok  |  ok  |  ok  |
[    0.000000]       hard-irq lock-inversion/321:  ok  |  ok  |  ok  |
[    0.000000]       soft-irq lock-inversion/321:  ok  |  ok  |  ok  |
[    0.000000]       hard-irq read-recursion/123:  ok  |
[    0.000000]       soft-irq read-recursion/123:  ok  |
[    0.000000]       hard-irq read-recursion/132:  ok  |
[    0.000000]       soft-irq read-recursion/132:  ok  |
[    0.000000]       hard-irq read-recursion/213:  ok  |
[    0.000000]       soft-irq read-recursion/213:  ok  |
[    0.000000]       hard-irq read-recursion/231:  ok  |
[    0.000000]       soft-irq read-recursion/231:  ok  |
[    0.000000]       hard-irq read-recursion/312:  ok  |
[    0.000000]       soft-irq read-recursion/312:  ok  |
[    0.000000]       hard-irq read-recursion/321:  ok  |
[    0.000000]       soft-irq read-recursion/321:  ok  |
[    0.000000] -------------------------------------------------------
[    0.000000] Good, all 218 testcases passed! |
[    0.000000] ---------------------------------
[    0.000000] ODEBUG: 0 of 0 active objects replaced
[    0.000000] hpet clockevent registered
[    0.000000] tsc: Fast TSC calibration using PIT
[    0.000000] tsc: Detected 2892.891 MHz processor
[    0.003004] Calibrating delay loop (skipped), value calculated using timer frequency.. 5785.78 BogoMIPS (lpj=2892891)
[    0.005009] pid_max: default: 32768 minimum: 301
[    0.007650] Dentry cache hash table entries: 65536 (order: 7, 524288 bytes)
[    0.009470] Inode-cache hash table entries: 32768 (order: 6, 262144 bytes)
[    0.010204] Mount-cache hash table entries: 256
[    0.013685] Initializing cgroup subsys debug
[    0.014023] Initializing cgroup subsys devices
[    0.015032] Initializing cgroup subsys freezer
[    0.016030] Initializing cgroup subsys blkio
[    0.018072] mce: CPU supports 10 MCE banks
[    0.019067] numa_add_cpu cpu 0 node 0: mask now 0
[    0.020013] Last level iTLB entries: 4KB 0, 2MB 0, 4MB 0
[    0.020013] Last level dTLB entries: 4KB 0, 2MB 0, 4MB 0
[    0.020013] tlb_flushall_shift: 6
[    0.021060] debug: unmapping init [mem 0xffffffff8246c000-0xffffffff82475fff]
[    0.022064] ACPI: Core revision 20130328
[    0.059386] ACPI: All ACPI Tables successfully acquired
[    0.062050] ftrace: allocating 43255 entries in 169 pages
[    0.073559] Getting VERSION: 50014
[    0.074015] Getting VERSION: 50014
[    0.075014] Getting ID: 0
[    0.076018] Getting ID: ff000000
[    0.077017] Getting LVT0: 8700
[    0.078012] Getting LVT1: 8400
[    0.079073] enabled ExtINT on CPU#0
[    0.081647] ENABLING IO-APIC IRQs
[    0.082012] init IO_APIC IRQs
[    0.083009]  apic 2 pin 0 not connected
[    0.084039] IOAPIC[0]: Set routing entry (2-1 -> 0x31 -> IRQ 1 Mode:0 Active:0 Dest:1)
[    0.085039] IOAPIC[0]: Set routing entry (2-2 -> 0x30 -> IRQ 0 Mode:0 Active:0 Dest:1)
[    0.086038] IOAPIC[0]: Set routing entry (2-3 -> 0x33 -> IRQ 3 Mode:0 Active:0 Dest:1)
[    0.087035] IOAPIC[0]: Set routing entry (2-4 -> 0x34 -> IRQ 4 Mode:0 Active:0 Dest:1)
[    0.088034] IOAPIC[0]: Set routing entry (2-5 -> 0x35 -> IRQ 5 Mode:1 Active:0 Dest:1)
[    0.089034] IOAPIC[0]: Set routing entry (2-6 -> 0x36 -> IRQ 6 Mode:0 Active:0 Dest:1)
[    0.090043] IOAPIC[0]: Set routing entry (2-7 -> 0x37 -> IRQ 7 Mode:0 Active:0 Dest:1)
[    0.091033] IOAPIC[0]: Set routing entry (2-8 -> 0x38 -> IRQ 8 Mode:0 Active:0 Dest:1)
[    0.092034] IOAPIC[0]: Set routing entry (2-9 -> 0x39 -> IRQ 9 Mode:1 Active:0 Dest:1)
[    0.093033] IOAPIC[0]: Set routing entry (2-10 -> 0x3a -> IRQ 10 Mode:1 Active:0 Dest:1)
[    0.094033] IOAPIC[0]: Set routing entry (2-11 -> 0x3b -> IRQ 11 Mode:1 Active:0 Dest:1)
[    0.095038] IOAPIC[0]: Set routing entry (2-12 -> 0x3c -> IRQ 12 Mode:0 Active:0 Dest:1)
[    0.096033] IOAPIC[0]: Set routing entry (2-13 -> 0x3d -> IRQ 13 Mode:0 Active:0 Dest:1)
[    0.097049] IOAPIC[0]: Set routing entry (2-14 -> 0x3e -> IRQ 14 Mode:0 Active:0 Dest:1)
[    0.098034] IOAPIC[0]: Set routing entry (2-15 -> 0x3f -> IRQ 15 Mode:0 Active:0 Dest:1)
[    0.100004]  apic 2 pin 16 not connected
[    0.101005]  apic 2 pin 17 not connected
[    0.102005]  apic 2 pin 18 not connected
[    0.103005]  apic 2 pin 19 not connected
[    0.104006]  apic 2 pin 20 not connected
[    0.105005]  apic 2 pin 21 not connected
[    0.106005]  apic 2 pin 22 not connected
[    0.107005]  apic 2 pin 23 not connected
[    0.108205] ..TIMER: vector=0x30 apic1=0 pin1=2 apic2=-1 pin2=-1
[    0.117543] smpboot: CPU0: Intel Common KVM processor (fam: 0f, model: 06, stepping: 01)
[    0.120011] Using local APIC timer interrupts.
[    0.120011] calibrating APIC timer ...
[    0.122000] ... lapic delta = 7187358
[    0.122000] ... PM-Timer delta = 411622
[    0.122000] APIC calibration not consistent with PM-Timer: 114ms instead of 100ms
[    0.122000] APIC delta adjusted to PM-Timer: 6250257 (7187358)
[    0.122000] TSC delta adjusted to PM-Timer: 289287465 (332660300)
[    0.122000] ..... delta 6250257
[    0.122000] ..... mult: 268446494
[    0.122000] ..... calibration result: 1000041
[    0.122000] ..... CPU clock speed is 2892.0874 MHz.
[    0.122000] ..... host bus clock speed is 1000.0041 MHz.
[    0.122110] Performance Events: unsupported Netburst CPU model 6 no PMU driver, software events only.
[    0.128792] SMP alternatives: lockdep: fixing up alternatives
[    0.130044] smpboot: Booting Node   0, Processors  #1 OK
[    0.004000] masked ExtINT on CPU#1
[    0.004000] numa_add_cpu cpu 1 node 0: mask now 0-1
[    0.210231] Brought up 2 CPUs
[    0.212011] ----------------
[    0.214005] | NMI testsuite:
[    0.216003] --------------------
[    0.218005]   remote IPI:  ok  |
[    0.226006]    local IPI:  ok  |
[    0.235022] --------------------
[    0.237006] Good, all   2 testcases passed! |
[    0.239005] ---------------------------------
[    0.241008] smpboot: Total of 2 processors activated (11572.07 BogoMIPS)
[    0.244496] CPU0 attaching sched-domain:
[    0.246020]  domain 0: span 0-1 level CPU
[    0.250009]   groups: 0 1
[    0.254027] CPU1 attaching sched-domain:
[    0.256010]  domain 0: span 0-1 level CPU
[    0.259008]   groups: 1 0
[    0.265478] devtmpfs: initialized
[    0.275384] kworker/u4:0 (17) used greatest stack depth: 5328 bytes left
[    0.291214] xor: measuring software checksum speed
[    0.303035]    prefetch64-sse:   156.000 MB/sec
[    0.315015]    generic_sse:   156.000 MB/sec
[    0.317006] xor: using function: generic_sse (156.000 MB/sec)
[    0.319025] atomic64 test passed for x86-64 platform with CX8 and with SSE
[    0.322333] RTC time: 22:08:53, date: 06/14/13
[    0.325613] NET: Registered protocol family 16
[    0.332193] kworker/u4:0 (23) used greatest stack depth: 4944 bytes left
[    0.345892] ACPI: bus type PCI registered
[    0.353100] dca service started, version 1.12.1
[    0.358237] PCI: Using configuration type 1 for base access
[    0.655248] bio: create slab <bio-0> at 0
[    0.676014] raid6: sse2x1    5175 MB/s
[    0.695015] raid6: sse2x2    6378 MB/s
[    0.714012] raid6: sse2x4    6800 MB/s
[    0.716007] raid6: using algorithm sse2x4 (6800 MB/s)
[    0.719011] raid6: using intx1 recovery algorithm
[    0.722281] ACPI: Added _OSI(Module Device)
[    0.724025] ACPI: Added _OSI(Processor Device)
[    0.726039] ACPI: Added _OSI(3.0 _SCP Extensions)
[    0.728025] ACPI: Added _OSI(Processor Aggregator Device)
[    0.734250] ACPI: EC: Look up EC in DSDT
[    0.814942] ACPI: Interpreter enabled
[    0.816040] ACPI Exception: AE_NOT_FOUND, While evaluating Sleep State [\_S1_] (20130328/hwxface-568)
[    0.823028] ACPI Exception: AE_NOT_FOUND, While evaluating Sleep State [\_S2_] (20130328/hwxface-568)
[    0.828245] ACPI: (supports S0 S3 S4 S5)
[    0.830006] ACPI: Using IOAPIC for interrupt routing
[    0.833361] PCI: Ignoring host bridge windows from ACPI; if necessary, use "pci=use_crs" and report a bug
[    1.022039] ACPI: PCI Root Bridge [PCI0] (domain 0000 [bus 00-ff])
[    1.024381] acpi PNP0A03:00: host bridge window [io  0x0000-0x0cf7] (ignored)
[    1.026008] acpi PNP0A03:00: host bridge window [io  0x0d00-0xffff] (ignored)
[    1.028009] acpi PNP0A03:00: host bridge window [mem 0x000a0000-0x000bffff] (ignored)
[    1.030012] acpi PNP0A03:00: host bridge window [mem 0xe0000000-0xfebfffff] (ignored)
[    1.032054] PCI: root bus 00: using default resources
[    1.034054] acpi PNP0A03:00: fail to add MMCONFIG information, can't access extended PCI configuration space under this bridge.
[    1.048875] PCI host bridge to bus 0000:00
[    1.050035] pci_bus 0000:00: root bus resource [bus 00-ff]
[    1.052022] pci_bus 0000:00: root bus resource [io  0x0000-0xffff]
[    1.054022] pci_bus 0000:00: root bus resource [mem 0x00000000-0xffffffffff]
[    1.056201] pci 0000:00:00.0: [8086:1237] type 00 class 0x060000
[    1.063469] pci 0000:00:01.0: [8086:7000] type 00 class 0x060100
[    1.069231] pci 0000:00:01.1: [8086:7010] type 00 class 0x010180
[    1.074620] pci 0000:00:01.1: reg 20: [io  0xc1e0-0xc1ef]
[    1.082187] pci 0000:00:01.3: [8086:7113] type 00 class 0x068000
[    1.085209] pci 0000:00:01.3: quirk: [io  0xb000-0xb03f] claimed by PIIX4 ACPI
[    1.088013] pci 0000:00:01.3: quirk: [io  0xb100-0xb10f] claimed by PIIX4 SMB
[    1.092388] pci 0000:00:02.0: [1013:00b8] type 00 class 0x030000
[    1.096103] pci 0000:00:02.0: reg 10: [mem 0xfc000000-0xfdffffff pref]
[    1.100100] pci 0000:00:02.0: reg 14: [mem 0xfebe0000-0xfebe0fff]
[    1.109074] pci 0000:00:02.0: reg 30: [mem 0xfebc0000-0xfebcffff pref]
[    1.114058] pci 0000:00:03.0: [1af4:1000] type 00 class 0x020000
[    1.117391] pci 0000:00:03.0: reg 10: [io  0xc1c0-0xc1df]
[    1.120548] pci 0000:00:03.0: reg 14: [mem 0xfebe1000-0xfebe1fff]
[    1.126545] pci 0000:00:03.0: reg 30: [mem 0xfebd0000-0xfebdffff pref]
[    1.130275] pci 0000:00:04.0: [8086:100e] type 00 class 0x020000
[    1.133530] pci 0000:00:04.0: reg 10: [mem 0xfeb80000-0xfeb9ffff]
[    1.136551] pci 0000:00:04.0: reg 14: [io  0xc000-0xc03f]
[    1.142396] pci 0000:00:04.0: reg 30: [mem 0xfeba0000-0xfebbffff pref]
[    1.147255] pci 0000:00:05.0: [1af4:1001] type 00 class 0x010000
[    1.150008] pci 0000:00:05.0: reg 10: [io  0xc040-0xc07f]
[    1.153531] pci 0000:00:05.0: reg 14: [mem 0xfebe2000-0xfebe2fff]
[    1.162213] pci 0000:00:06.0: [1af4:1001] type 00 class 0x010000
[    1.165422] pci 0000:00:06.0: reg 10: [io  0xc080-0xc0bf]
[    1.168502] pci 0000:00:06.0: reg 14: [mem 0xfebe3000-0xfebe3fff]
[    1.178190] pci 0000:00:07.0: [1af4:1001] type 00 class 0x010000
[    1.181007] pci 0000:00:07.0: reg 10: [io  0xc0c0-0xc0ff]
[    1.184438] pci 0000:00:07.0: reg 14: [mem 0xfebe4000-0xfebe4fff]
[    1.193441] pci 0000:00:08.0: [1af4:1001] type 00 class 0x010000
[    1.196011] pci 0000:00:08.0: reg 10: [io  0xc100-0xc13f]
[    1.199008] pci 0000:00:08.0: reg 14: [mem 0xfebe5000-0xfebe5fff]
[    1.208322] pci 0000:00:09.0: [1af4:1001] type 00 class 0x010000
[    1.211008] pci 0000:00:09.0: reg 10: [io  0xc140-0xc17f]
[    1.214424] pci 0000:00:09.0: reg 14: [mem 0xfebe6000-0xfebe6fff]
[    1.224089] pci 0000:00:0a.0: [1af4:1001] type 00 class 0x010000
[    1.226895] pci 0000:00:0a.0: reg 10: [io  0xc180-0xc1bf]
[    1.229415] pci 0000:00:0a.0: reg 14: [mem 0xfebe7000-0xfebe7fff]
[    1.239240] pci 0000:00:0b.0: [8086:25ab] type 00 class 0x088000
[    1.242307] pci 0000:00:0b.0: reg 10: [mem 0xfebe8000-0xfebe800f]
[    1.252030] acpi PNP0A03:00: ACPI _OSC support notification failed, disabling PCIe ASPM
[    1.254008] acpi PNP0A03:00: Unable to request _OSC control (_OSC support mask: 0x08)
[    1.266730] ACPI: PCI Interrupt Link [LNKA] (IRQs 5 *10 11)
[    1.275554] ACPI: PCI Interrupt Link [LNKB] (IRQs 5 *10 11)
[    1.284224] ACPI: PCI Interrupt Link [LNKC] (IRQs 5 10 *11)
[    1.294078] ACPI: PCI Interrupt Link [LNKD] (IRQs 5 10 *11)
[    1.301327] ACPI: PCI Interrupt Link [LNKS] (IRQs 9) *0
[    1.310779] ACPI: Enabled 16 GPEs in block 00 to 0F
[    1.312037] acpi root: \_SB_.PCI0 notify handler is installed
[    1.314223] Found 1 acpi root devices
[    1.333077] ACPI: No dock devices found.
[    1.340174] vgaarb: device added: PCI:0000:00:02.0,decodes=io+mem,owns=io+mem,locks=none
[    1.342018] vgaarb: loaded
[    1.344006] vgaarb: bridge control possible 0000:00:02.0
[    1.353156] SCSI subsystem initialized
[    1.356018] ACPI: bus type ATA registered
[    1.361322] libata version 3.00 loaded.
[    1.368138] ACPI: bus type USB registered
[    1.375476] usbcore: registered new interface driver usbfs
[    1.378068] usbcore: registered new interface driver hub
[    1.381334] usbcore: registered new device driver usb
[    1.386370] pps_core: LinuxPPS API ver. 1 registered
[    1.388033] pps_core: Software ver. 5.3.6 - Copyright 2005-2007 Rodolfo Giometti <giometti@linux.it>
[    1.390434] PTP clock support registered
[    1.397288] wmi: Mapper loaded
[    1.401019] Advanced Linux Sound Architecture Driver Initialized.
[    1.403016] PCI: Using ACPI for IRQ routing
[    1.405017] PCI: pci_cache_line_size set to 64 bytes
[    1.408135] e820: reserve RAM buffer [mem 0x00093c00-0x0009ffff]
[    1.410052] e820: reserve RAM buffer [mem 0x1fffe000-0x1fffffff]
[    1.417371] HPET: 3 timers in total, 0 timers will be used for per-cpu timer
[    1.419067] hpet0: at MMIO 0xfed00000, IRQs 2, 8, 0
[    1.424008] hpet0: 3 comparators, 64-bit 100.000000 MHz counter
[    1.431053] Switching to clocksource hpet
[    1.660134] pnp: PnP ACPI init
[    1.664093] ACPI: bus type PNP registered
[    1.668611] IOAPIC[0]: Set routing entry (2-8 -> 0x38 -> IRQ 8 Mode:0 Active:0 Dest:3)
[    1.709313] pnp 00:00: Plug and Play ACPI device, IDs PNP0b00 (active)
[    1.715409] IOAPIC[0]: Set routing entry (2-1 -> 0x31 -> IRQ 1 Mode:0 Active:0 Dest:3)
[    1.727961] pnp 00:01: Plug and Play ACPI device, IDs PNP0303 (active)
[    1.732912] IOAPIC[0]: Set routing entry (2-12 -> 0x3c -> IRQ 12 Mode:0 Active:0 Dest:3)
[    1.740711] pnp 00:02: Plug and Play ACPI device, IDs PNP0f13 (active)
[    1.746399] IOAPIC[0]: Set routing entry (2-6 -> 0x36 -> IRQ 6 Mode:0 Active:0 Dest:3)
[    1.752811] pnp 00:03: [dma 2]
[    1.756451] pnp 00:03: Plug and Play ACPI device, IDs PNP0700 (active)
[    1.762328] IOAPIC[0]: Set routing entry (2-7 -> 0x37 -> IRQ 7 Mode:0 Active:0 Dest:3)
[    1.770166] pnp 00:04: Plug and Play ACPI device, IDs PNP0400 (active)
[    1.776962] IOAPIC[0]: Set routing entry (2-4 -> 0x34 -> IRQ 4 Mode:0 Active:0 Dest:3)
[    1.784799] pnp 00:05: Plug and Play ACPI device, IDs PNP0501 (active)
[    1.796450] pnp 00:06: Plug and Play ACPI device, IDs PNP0103 (active)
[    1.804390] pnp: PnP ACPI: found 7 devices
[    1.806822] ACPI: bus type PNP unregistered
[    1.941724] pci_bus 0000:00: resource 4 [io  0x0000-0xffff]
[    1.946449] pci_bus 0000:00: resource 5 [mem 0x00000000-0xffffffffff]
[    1.951653] NET: Registered protocol family 2
[    1.956264] TCP established hash table entries: 4096 (order: 4, 65536 bytes)
[    1.959962] TCP bind hash table entries: 4096 (order: 6, 327680 bytes)
[    1.964181] TCP: Hash tables configured (established 4096 bind 4096)
[    1.967166] TCP: reno registered
[    1.969092] UDP hash table entries: 256 (order: 3, 49152 bytes)
[    1.973204] UDP-Lite hash table entries: 256 (order: 3, 49152 bytes)
[    1.978591] NET: Registered protocol family 1
[    1.982811] RPC: Registered named UNIX socket transport module.
[    1.985767] RPC: Registered udp transport module.
[    1.989706] RPC: Registered tcp transport module.
[    1.994096] RPC: Registered tcp NFSv4.1 backchannel transport module.
[    1.999107] pci 0000:00:00.0: Limiting direct PCI/PCI transfers
[    2.003956] pci 0000:00:01.0: PIIX3: Enabling Passive Release
[    2.008414] pci 0000:00:01.0: Activating ISA DMA hang workarounds
[    2.011508] pci 0000:00:02.0: Boot video device
[    2.014102] PCI: CLS 0 bytes, default 64
[    2.499210] DMA-API: preallocated 65536 debug entries
[    2.503962] DMA-API: debugging enabled by kernel config
[    2.509740] kvm: no hardware support
[    2.515171] Machine check injector initialized
[    2.532684] microcode: CPU0 sig=0xf61, pf=0x1, revision=0x1
[    2.539774] microcode: CPU1 sig=0xf61, pf=0x1, revision=0x1
[    2.546617] microcode: Microcode Update Driver: v2.00 <tigran@aivazian.fsnet.co.uk>, Peter Oruba
[    2.552235] Scanning for low memory corruption every 60 seconds
[    2.576392] Initializing RT-Tester: OK
[    2.579829] audit: initializing netlink socket (disabled)
[    2.583765] type=2000 audit(1371247734.583:1): initialized
[    2.648684] Kprobe smoke test started
[    2.755280] Kprobe smoke test passed successfully
[    2.758592] rcu-torture:--- Start of test: nreaders=4 nfakewriters=4 stat_interval=60 verbose=0 test_no_idle_hz=1 shuffle_interval=3 stutter=5 irqreader=1 fqs_duration=0 fqs_holdoff=0 fqs_stutter=3 test_boost=1/0 test_boost_interval=7 test_boost_duration=4 shutdown_secs=0 stall_cpu=0 stall_cpu_holdoff=10 n_barrier_cbs=0 onoff_interval=0 onoff_holdoff=0
[    2.784692] bounce pool size: 64 pages
[    2.787352] HugeTLB registered 2 MB page size, pre-allocated 0 pages
[    3.033970] NFS: Registering the id_resolver key type
[    3.037874] Key type id_resolver registered
[    3.040659] Key type id_legacy registered
[    3.044332] Installing knfsd (copyright (C) 1996 okir@monad.swb.de).
[    3.066255] fuse init (API version 7.22)
[    3.077711] JFS: nTxBlock = 3666, nTxLock = 29334
[    3.094631] SGI XFS with ACLs, security attributes, large block/inode numbers, no debug enabled
[    3.146820] 9p: Installing v9fs 9p2000 file system support
[    3.159486] NILFS version 2 loaded
[    3.188637] Btrfs loaded
[    3.191550] msgmni has been set to 916
[    3.208532] async_tx: api initialized (async)
[    3.213096] Block layer SCSI generic (bsg) driver version 0.4 loaded (major 250)
[    3.218393] io scheduler noop registered
[    3.221122] io scheduler deadline registered
[    3.225554] io scheduler cfq registered (default)
[    3.229887] list_sort_test: start testing list_sort()
[    3.248113] pci_hotplug: PCI Hot Plug PCI Core version: 0.5
[    3.258173] input: Power Button as /devices/LNXSYSTM:00/LNXPWRBN:00/input/input0
[    3.266182] ACPI: Power Button [PWRF]
[    3.337660] ioatdma: Intel(R) QuickData Technology Driver 4.00
[    3.364899] ACPI: PCI Interrupt Link [LNKC] enabled at IRQ 11
[    3.370269] IOAPIC[0]: Set routing entry (2-11 -> 0x3b -> IRQ 11 Mode:1 Active:0 Dest:3)
[    3.378600] virtio-pci 0000:00:03.0: setting latency timer to 64
[    3.404414] ACPI: PCI Interrupt Link [LNKA] enabled at IRQ 10
[    3.409403] IOAPIC[0]: Set routing entry (2-10 -> 0x3a -> IRQ 10 Mode:1 Active:0 Dest:3)
[    3.417588] virtio-pci 0000:00:05.0: setting latency timer to 64
[    3.442656] ACPI: PCI Interrupt Link [LNKB] enabled at IRQ 10
[    3.447908] virtio-pci 0000:00:06.0: setting latency timer to 64
[    3.468667] virtio-pci 0000:00:07.0: setting latency timer to 64
[    3.493637] ACPI: PCI Interrupt Link [LNKD] enabled at IRQ 11
[    3.498713] virtio-pci 0000:00:08.0: setting latency timer to 64
[    3.516339] tsc: Refined TSC clocksource calibration: 2893.028 MHz
[    3.521818] Switching to clocksource tsc
[    3.525615] virtio-pci 0000:00:09.0: setting latency timer to 64
[    3.539098] virtio-pci 0000:00:0a.0: setting latency timer to 64
[    3.957400] Serial: 8250/16550 driver, 4 ports, IRQ sharing enabled
[    3.989070] 00:05: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
[    4.002153] Initializing Nozomi driver 2.1d
[    4.015142] Non-volatile memory driver v1.3
[    4.019183] Linux agpgart interface v0.103
[    4.022403] Hangcheck: starting hangcheck timer 0.9.1 (tick is 180 seconds, margin is 60 seconds).
[    4.029832] Hangcheck: Using getrawmonotonic().
[    4.033620] [drm] Initialized drm 1.1.0 20060810
[    4.040703] Floppy drive(s): fd0 is 1.44M
[    4.057806] FDC 0 is a S82078B
[    4.087758] brd: module loaded
[    4.109638] loop: module loaded
[    4.114812] virtio-pci 0000:00:05.0: irq 40 for MSI/MSI-X
[    4.117896] virtio-pci 0000:00:05.0: irq 41 for MSI/MSI-X
[    4.170530]  vda: unknown partition table
[    4.174618] virtio-pci 0000:00:06.0: irq 42 for MSI/MSI-X
[    4.177348] virtio-pci 0000:00:06.0: irq 43 for MSI/MSI-X
[    4.229243]  vdb: unknown partition table
[    4.234581] virtio-pci 0000:00:07.0: irq 44 for MSI/MSI-X
[    4.238140] virtio-pci 0000:00:07.0: irq 45 for MSI/MSI-X
[    4.284571]  vdc: unknown partition table
[    4.290847] virtio-pci 0000:00:08.0: irq 46 for MSI/MSI-X
[    4.295448] virtio-pci 0000:00:08.0: irq 47 for MSI/MSI-X
[    4.348440]  vdd: unknown partition table
[    4.354543] virtio-pci 0000:00:09.0: irq 48 for MSI/MSI-X
[    4.358283] virtio-pci 0000:00:09.0: irq 49 for MSI/MSI-X
[    4.423388]  vde: unknown partition table
[    4.428166] virtio-pci 0000:00:0a.0: irq 50 for MSI/MSI-X
[    4.431932] virtio-pci 0000:00:0a.0: irq 51 for MSI/MSI-X
[    4.476320]  vdf: unknown partition table
[    4.480737] lkdtm: No crash points registered, enable through debugfs
[    4.485910] Uniform Multi-Platform E-IDE driver
[    4.490330] piix 0000:00:01.1: IDE controller (0x8086:0x7010 rev 0x00)
[    4.494566] piix 0000:00:01.1: not 100% native mode: will probe irqs later
[    4.499275] pci 0000:00:01.1: setting latency timer to 64
[    4.502625]     ide0: BM-DMA at 0xc1e0-0xc1e7
[    4.505113]     ide1: BM-DMA at 0xc1e8-0xc1ef
[    4.507579] Probing IDE interface ide0...
[    5.032569] Probing IDE interface ide1...
[    5.727160] hdc: QEMU DVD-ROM, ATAPI CD/DVD-ROM drive
[    6.352246] hdc: host max PIO4 wanted PIO255(auto-tune) selected PIO0
[    6.356572] hdc: MWDMA2 mode selected
[    6.359951] ide0 at 0x1f0-0x1f7,0x3f6 on irq 14
[    6.363947] ide1 at 0x170-0x177,0x376 on irq 15
[    6.383054] ide_generic: please use "probe_mask=0x3f" module parameter for probing all legacy ISA IDE ports
[    6.394092] ide-gd driver 1.18
[    6.436978] Loading iSCSI transport class v2.0-870.
[    6.516960] Loading Adaptec I2O RAID: Version 2.4 Build 5go
[    6.520711] Detecting Adaptec I2O RAID controllers...
[    6.532996] Adaptec aacraid driver 1.2-0[30200]-ms
[    6.542359] aic94xx: Adaptec aic94xx SAS/SATA driver version 1.0.3 loaded
[    6.567047] isci: Intel(R) C600 SAS Controller Driver - version 1.1.0
[    6.588121] qla2xxx [0000:00:00.0]-0005: : QLogic Fibre Channel HBA Driver: 8.05.00.03-k.
[    6.608102] iscsi: registered transport (qla4xxx)
[    6.617960] QLogic iSCSI HBA Driver
[    6.627079] megaraid cmm: 2.20.2.7 (Release Date: Sun Jul 16 00:01:03 EST 2006)
[    6.637983] megaraid: 2.20.5.1 (Release Date: Thu Nov 16 15:32:35 EST 2006)
[    6.649968] megasas: 06.506.00.00-rc1 Sat. Feb. 9 17:00:00 PDT 2013
[    6.658048] mpt2sas version 14.100.00.00 loaded
[    6.671963] GDT-HA: Storage RAID Controller Driver. Version: 3.05
[    6.793266] tun: Universal TUN/TAP device driver, 1.6
[    6.796791] tun: (C) 1999-2004 Max Krasnyansky <maxk@qualcomm.com>
[    6.803121] netif_napi_add() called with weight 128 on device eth%d
[    6.808480] virtio-pci 0000:00:03.0: irq 52 for MSI/MSI-X
[    6.812604] virtio-pci 0000:00:03.0: irq 53 for MSI/MSI-X
[    6.816802] virtio-pci 0000:00:03.0: irq 54 for MSI/MSI-X
[    6.891957] Atheros(R) L2 Ethernet Driver - version 2.2.3
[    6.895636] Copyright (c) 2007 Atheros Corporation.
[    6.910966] cnic: Broadcom NetXtreme II CNIC Driver cnic v2.5.16 (Dec 05, 2012)
[    6.922979] e100: Intel(R) PRO/100 Network Driver, 3.5.24-k2-NAPI
[    6.926934] e100: Copyright(c) 1999-2006 Intel Corporation
[    6.939007] e1000: Intel(R) PRO/1000 Network Driver - version 7.3.21-k8-NAPI
[    6.945553] e1000: Copyright (c) 1999-2006 Intel Corporation.
[    6.988933] e1000 0000:00:04.0: setting latency timer to 64
[    7.444578] e1000 0000:00:04.0 eth1: (PCI:33MHz:32-bit) 52:54:00:12:34:57
[    7.450316] e1000 0000:00:04.0 eth1: Intel(R) PRO/1000 Network Connection
[    7.458574] e1000e: Intel(R) PRO/1000 Network Driver - 2.3.2-k
[    7.462956] e1000e: Copyright(c) 1999 - 2013 Intel Corporation.
[    7.468282] igb: Intel(R) Gigabit Ethernet Network Driver - version 5.0.3-k
[    7.472961] igb: Copyright (c) 2007-2013 Intel Corporation.
[    7.479047] igbvf: Intel(R) Gigabit Virtual Function Network Driver - version 2.0.2-k
[    7.489586] igbvf: Copyright (c) 2009 - 2012 Intel Corporation.
[    7.497068] ixgbe: Intel(R) 10 Gigabit PCI Express Network Driver - version 3.13.10-k
[    7.509886] ixgbe: Copyright (c) 1999-2013 Intel Corporation.
[    7.542492] ixgb: Intel(R) PRO/10GbE Network Driver - version 1.0.135-k2-NAPI
[    7.547099] ixgb: Copyright (c) 1999-2008 Intel Corporation.
[    7.564480] jme: JMicron JMC2XX ethernet driver version 1.0.8
[    7.580979] sky2: driver version 1.30
[    7.589969] pch_gbe: EG20T PCH Gigabit Ethernet Driver - version 1.01
[    7.621988] usbcore: registered new interface driver catc
[    7.630000] usbcore: registered new interface driver kaweth
[    7.633917] pegasus: v0.9.3 (2013/04/25), Pegasus/Pegasus II USB Ethernet driver
[    7.647982] usbcore: registered new interface driver pegasus
[    7.660000] usbcore: registered new interface driver rtl8150
[    7.667351] usbcore: registered new interface driver asix
[    7.673255] usbcore: registered new interface driver ax88179_178a
[    7.681371] usbcore: registered new interface driver cdc_ether
[    7.693080] usbcore: registered new interface driver cdc_eem
[    7.707316] usbcore: registered new interface driver dm9601
[    7.713194] usbcore: registered new interface driver smsc75xx
[    7.719268] usbcore: registered new interface driver smsc95xx
[    7.727353] usbcore: registered new interface driver gl620a
[    7.736146] usbcore: registered new interface driver net1080
[    7.743060] usbcore: registered new interface driver plusb
[    7.751988] usbcore: registered new interface driver rndis_host
[    7.759997] usbcore: registered new interface driver cdc_subset
[    7.767984] usbcore: registered new interface driver zaurus
[    7.781207] usbcore: registered new interface driver MOSCHIP usb-ethernet driver
[    7.793081] usbcore: registered new interface driver int51x1
[    7.807469] usbcore: registered new interface driver cdc_ncm
[    7.811379] Fusion MPT base driver 3.04.20
[    7.815279] Copyright (c) 1999-2008 LSI Corporation
[    7.819171] Fusion MPT SPI Host driver 3.04.20
[    7.837072] Fusion MPT FC Host driver 3.04.20
[    7.847015] Fusion MPT SAS Host driver 3.04.20
[    7.853049] Fusion MPT misc device (ioctl) driver 3.04.20
[    7.863065] mptctl: Registered with Fusion MPT base driver
[    7.866735] mptctl: /dev/mptctl @ (major,minor=10,220)
[    7.877947] ehci_hcd: USB 2.0 'Enhanced' Host Controller (EHCI) Driver
[    7.882188] ehci_hcd: block sizes: qh 112 qtd 96 itd 192 sitd 96
[    7.885466] ehci-pci: EHCI PCI platform driver
[    7.913424] uhci_hcd: USB Universal Host Controller Interface driver
[    7.941412] usbcore: registered new interface driver usb-storage
[    7.946792] usbcore: registered new interface driver ums-alauda
[    7.953012] usbcore: registered new interface driver ums-cypress
[    7.959734] usbcore: registered new interface driver ums-datafab
[    7.969985] usbcore: registered new interface driver ums-freecom
[    7.975535] usbcore: registered new interface driver ums-isd200
[    7.988339] usbcore: registered new interface driver ums-jumpshot
[    7.997072] usbcore: registered new interface driver ums-karma
[    8.003356] usbcore: registered new interface driver ums-onetouch
[    8.011449] usbcore: registered new interface driver ums-sddr09
[    8.021237] usbcore: registered new interface driver ums-sddr55
[    8.028243] usbcore: registered new interface driver ums-usbat
[    8.042997] usbcore: registered new interface driver usbserial
[    8.056375] usbcore: registered new interface driver usbserial_generic
[    8.061983] usbserial: USB Serial support registered for generic
[    8.089165] usbcore: registered new interface driver belkin_sa
[    8.097445] usbserial: USB Serial support registered for Belkin / Peracom / GoHubs USB Serial Adapter
[    8.123219] usbcore: registered new interface driver mct_u232
[    8.130418] usbserial: USB Serial support registered for MCT U232
[    8.143714] usbcore: registered new interface driver usbtest
[    8.149854] i8042: PNP: PS/2 Controller [PNP0303:KBD,PNP0f13:MOU] at 0x60,0x64 irq 1,12
[    8.175337] serio: i8042 KBD port at 0x60,0x64 irq 1
[    8.180740] serio: i8042 AUX port at 0x60,0x64 irq 12
[    8.208340] mousedev: PS/2 mouse device common for all mice
[    8.237182] input: AT Translated Set 2 keyboard as /devices/platform/i8042/serio0/input/input1
[    8.248143] rtc_cmos 00:00: RTC can wake from S4
[    8.254344] rtc_cmos 00:00: rtc core: registered rtc_cmos as rtc0
[    8.260573] rtc_cmos 00:00: alarms up to one day, 114 bytes nvram, hpet irqs
[    8.269128] rtc-test rtc-test.0: rtc core: registered test as rtc1
[    8.275662] rtc-test rtc-test.1: rtc core: registered test as rtc2
[    8.280728] i6300esb: Intel 6300ESB WatchDog Timer Driver v0.05
[    8.286568] i6300esb: initialized (0xffffc90000482000). heartbeat=30 sec (nowayout=0)
[    8.293607] iTCO_wdt: Intel TCO WatchDog Timer Driver v1.10
[    8.297852] iTCO_vendor_support: vendor-support=0
[    8.301469] watchdog: Software Watchdog: cannot register miscdev on minor=130 (err=-16).
[    8.307519] watchdog: Software Watchdog: a legacy watchdog module is probably present.
[    8.314529] softdog: Software Watchdog Timer: 0.08 initialized. soft_noboot=0 soft_margin=60 sec soft_panic=0 (nowayout=0)
[    8.321857] md: linear personality registered for level -1
[    8.325652] md: raid0 personality registered for level 0
[    8.329327] md: raid1 personality registered for level 1
[    8.332972] md: raid10 personality registered for level 10
[    8.336706] md: raid6 personality registered for level 6
[    8.340396] md: raid5 personality registered for level 5
[    8.344150] md: raid4 personality registered for level 4
[    8.347743] md: multipath personality registered for level -4
[    8.351614] md: faulty personality registered for level -5
[    8.363908] device-mapper: uevent: version 1.0.3
[    8.370635] device-mapper: ioctl: 4.24.0-ioctl (2013-01-15) initialised: dm-devel@redhat.com
[    8.387992] device-mapper: multipath: version 1.5.1 loaded
[    8.390978] device-mapper: multipath round-robin: version 1.0.0 loaded
[    8.394961] device-mapper: multipath queue-length: version 0.1.0 loaded
[    8.398348] device-mapper: multipath service-time: version 0.2.0 loaded
[    8.403375] device-mapper: dm-log-userspace: version 1.1.0 loaded
[    8.406084] cpuidle: using governor ladder
[    8.408435] cpuidle: using governor menu
[    8.412583] usbcore: registered new interface driver usbhid
[    8.415792] usbhid: USB HID core driver
[    8.424120] dell_wmi: No known WMI GUID found
[    8.426795] acer_wmi: Acer Laptop ACPI-WMI Extras
[    8.429426] acer_wmi: No or unsupported WMI interface, unable to load
[    8.437176] oprofile: using NMI interrupt.
[    8.441718] netem: version 1.3
[    8.444765] Netfilter messages via NETLINK v0.30.
[    8.449245] nf_conntrack version 0.5.0 (3666 buckets, 14664 max)
[    8.456901] ctnetlink v0.93: registering with nfnetlink.
[    8.460942] NF_TPROXY: Transparent proxy support initialized, version 4.1.0
[    8.465578] NF_TPROXY: Copyright (c) 2006-2007 BalaBit IT Ltd.
[    8.471945] xt_time: kernel timezone is -0000
[    8.475248] ip_tables: (C) 2000-2006 Netfilter Core Team
[    8.478530] ipt_CLUSTERIP: ClusterIP Version 0.8 loaded successfully
[    8.482652] arp_tables: (C) 2002 David S. Miller
[    8.485284] TCP: bic registered
[    8.487393] TCP: cubic registered
[    8.490044] TCP: westwood registered
[    8.493369] TCP: highspeed registered
[    8.496172] TCP: hybla registered
[    8.498774] TCP: htcp registered
[    8.501431] TCP: vegas registered
[    8.504250] TCP: veno registered
[    8.507492] TCP: scalable registered
[    8.510008] TCP: lp registered
[    8.512222] TCP: yeah registered
[    8.514501] TCP: illinois registered
[    8.517448] Initializing XFRM netlink socket
[    8.527834] NET: Registered protocol family 10
[    8.557892] sit: IPv6 over IPv4 tunneling driver
[    8.564224] NET: Registered protocol family 17
[    8.567598] NET: Registered protocol family 15
[    8.571777] Bridge firewalling registered
[    8.575212] Ebtables v2.0 registered
[    8.585498] 9pnet: Installing 9P2000 support
[    8.590538] Key type dns_resolver registered
[    8.600811] 
[    8.600811] printing PIC contents
[    8.607528] ... PIC  IMR: ffff
[    8.608476] ... PIC  IRR: 1153
[    8.613775] ... PIC  ISR: 0000
[    8.617319] ... PIC ELCR: 0c00
[    8.620099] printing local APIC contents on CPU#0/0:
[    8.621080] ... APIC ID:      00000000 (0)
[    8.621080] ... APIC VERSION: 00050014
[    8.621080] ... APIC TASKPRI: 00000000 (00)
[    8.621080] ... APIC PROCPRI: 00000000
[    8.621080] ... APIC LDR: 01000000
[    8.621080] ... APIC DFR: ffffffff
[    8.621080] ... APIC SPIV: 000001ff
[    8.621080] ... APIC ISR field:
[    8.621080] 0000000000000000000000000000000000000000000000000000000000000000
[    8.621080] ... APIC TMR field:
[    8.621080] 0000000000000000000000000000000000000000000000000000000000000000
[    8.621080] ... APIC IRR field:
[    8.621080] 0000000000000000000000000000000000000000000000000000000020008000
[    8.621080] ... APIC ESR: 00000000
[    8.621080] ... APIC ICR: 000008fd
[    8.621080] ... APIC ICR2: 02000000
[    8.621080] ... APIC LVTT: 000000ef
[    8.621080] ... APIC LVTPC: 00010000
[    8.621080] ... APIC LVT0: 00010700
[    8.621080] ... APIC LVT1: 00000400
[    8.621080] ... APIC LVTERR: 000000fe
[    8.621080] ... APIC TMICT: 0002c453
[    8.621080] ... APIC TMCCT: 00000000
[    8.621080] ... APIC TDCR: 00000003
[    8.621080] 
[    8.767487] number of MP IRQ sources: 15.
[    8.770909] number of IO-APIC #2 registers: 24.
[    8.774225] testing the IO APIC.......................
[    8.776545] IO APIC #2......
[    8.778282] .... register #00: 00000000
[    8.780253] .......    : physical APIC id: 00
[    8.782356] .......    : Delivery Type: 0
[    8.784498] .......    : LTS          : 0
[    8.786495] .... register #01: 00170011
[    8.788444] .......     : max redirection entries: 17
[    8.790700] .......     : PRQ implemented: 0
[    8.792745] .......     : IO APIC version: 11
[    8.795153] .... register #02: 00000000
[    8.797108] .......     : arbitration: 00
[    8.799095] .... IRQ redirection table:
[    8.801063] 1    0    0   0   0    0    0    00
[    8.803485] 0    0    0   0   0    1    1    31
[    8.807690] 0    0    0   0   0    1    1    30
[    8.811462] 0    0    0   0   0    1    1    33
[    8.815224] 1    0    0   0   0    1    1    34
[    8.819829] 1    1    0   0   0    1    1    35
[    8.823667] 0    0    0   0   0    1    1    36
[    8.828323] 0    0    0   0   0    1    1    37
[    8.832136] 0    0    0   0   0    1    1    38
[    8.835801] 0    1    0   0   0    1    1    39
[    8.839345] 1    1    0   0   0    1    1    3A
[    8.842842] 1    1    0   0   0    1    1    3B
[    8.846438] 0    0    0   0   0    1    1    3C
[    8.849724] 0    0    0   0   0    1    1    3D
[    8.852842] 0    0    0   0   0    1    1    3E
[    8.856219] 0    0    0   0   0    1    1    3F
[    8.860240] 1    0    0   0   0    0    0    00
[    8.863611] 1    0    0   0   0    0    0    00
[    8.866963] 1    0    0   0   0    0    0    00
[    8.870317] 1    0    0   0   0    0    0    00
[    8.873731] 1    0    0   0   0    0    0    00
[    8.877125] 1    0    0   0   0    0    0    00
[    8.879954] 1    0    0   0   0    0    0    00
[    8.882277] 1    0    0   0   0    0    0    00
[    8.884445] IRQ to pin mappings:
[    8.886228] IRQ0 -> 0:2
[    8.888152] IRQ1 -> 0:1
[    8.890157] IRQ3 -> 0:3
[    8.892803] IRQ4 -> 0:4
[    8.895052] IRQ5 -> 0:5
[    8.898205] IRQ6 -> 0:6
[    8.901538] IRQ7 -> 0:7
[    8.905085] IRQ8 -> 0:8
[    8.907247] IRQ9 -> 0:9
[    8.909827] IRQ10 -> 0:10
[    8.912145] IRQ11 -> 0:11
[    8.914717] IRQ12 -> 0:12
[    8.917816] IRQ13 -> 0:13
[    8.920803] IRQ14 -> 0:14
[    8.924379] IRQ15 -> 0:15
[    8.927838] .................................... done.
[    8.946417] PM: Hibernation image not present or could not be loaded.
[    8.950315] registered taskstats version 1
[    8.957318]   Magic number: 1:451:148
[    8.960621] bdi 1:0: hash matches
[    8.963922] tty ttyp2: hash matches
[    8.967346] acpi device:19: hash matches
[    8.971778] console [netcon0] enabled
[    8.975236] netconsole: network logging started
[    8.999756] IPv6: ADDRCONF(NETDEV_UP): eth1: link is not ready
[    9.015278] Sending DHCP requests ., OK
[    9.025406] IP-Config: Got DHCP answer from 10.0.2.2, my address is 10.0.2.15
[    9.086065] IP-Config: Complete:
[    9.090070]      device=eth0, hwaddr=52:54:00:12:34:56, ipaddr=10.0.2.15, mask=255.255.255.0, gw=10.0.2.2
[    9.096027]      host=kvm, domain=, nis-domain=(none)
[    9.099557]      bootserver=10.0.2.2, rootserver=192.168.1.1, rootpath=
[    9.102405]      nameserver0=10.0.2.3
[    9.107299] ALSA device list:
[    9.110045]   No soundcards found.
[    9.150427] input: ImExPS/2 Generic Explorer Mouse as /devices/platform/i8042/serio1/input/input2
[    9.160238] md: Waiting for all devices to be available before autodetect
[    9.164685] md: If you don't use raid, use raid=noautodetect
[    9.175793] md: Autodetecting RAID arrays.
[    9.179481] md: Scanned 0 and added 0 devices.
[    9.182807] md: autorun ...
[    9.185644] md: ... autorun DONE.
[    9.210845] VFS: Mounted root (nfs filesystem) on device 0:14.
[    9.215969] devtmpfs: mounted
[    9.218881] debug: unmapping init [mem 0xffffffff8214a000-0xffffffff8246bfff]
[    9.600264] modprobe (1964) used greatest stack depth: 3208 bytes left
[   10.669372] S02mountkernfs. (1985) used greatest stack depth: 3072 bytes left
[   10.949448] udevd[2048]: starting version 175
[   12.063485] hwclock (2150) used greatest stack depth: 2800 bytes left
[   29.688387] S20ipmidetectd (2857) used greatest stack depth: 2592 bytes left
[   30.851378] NFSD: Using /var/lib/nfs/v4recovery as the NFSv4 state recovery directory
[   30.865268] NFSD: starting 90-second grace period (net ffffffff8210b7c0)
Kernel tests: Boot OK!
[   34.207167] CPU0 attaching NULL sched-domain.
[   34.207346] CPU1 attaching NULL sched-domain.
[   34.207561] CPU0 attaching NULL sched-domain.
[   34.230337] numa_remove_cpu cpu 1 node 0: mask now 0
[   34.514446] smpboot: CPU 1 is now offline
[   34.758519] SMP alternatives: lockdep: fixing up alternatives
[   34.773185] smpboot: Booting Node 0 Processor 1 APIC 0x1

BUG: kernel test crashed
Elapsed time: 40

--fUYQa+Pmc3FrFX/N--
