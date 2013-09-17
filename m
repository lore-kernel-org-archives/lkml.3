Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753023Ab3IQNxo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Sep 2013 09:53:44 -0400
Received: from mga01.intel.com ([192.55.52.88]:26720 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752759Ab3IQNxm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Sep 2013 09:53:42 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.90,923,1371106800"; 
   d="log'?scan'208";a="396991805"
Date: Tue, 17 Sep 2013 21:52:58 +0800
From: Fengguang Wu <fengguang.wu@intel.com>
To: fengguang.wu@intel.com, Russell King <rmk+kernel@arm.linux.org.uk>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Lai Jiangshan <laijs@cn.fujitsu.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        "Paul E. McKenney" <paul.mckenney@linaro.org>,
        linux-kernel@vger.kernel.org
Subject: [rcu_gp_kthread] WARNING: CPU: 1 PID: 9 at lib/list_debug.c:33
 __list_add()
Message-ID: <20130917135258.GB17015@localhost>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="gj572EiMnwbLXET9"
Content-Disposition: inline
User-Agent: Heirloom mailx 12.5 6/20/10
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--gj572EiMnwbLXET9
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Greetings,

I got the below dmesg and the first bad commit is

commit c817a67ecba7c3c2aaa104796d78f160af60920d
Author: Russell King <rmk+kernel@arm.linux.org.uk>
Date:   Thu Jun 27 15:06:14 2013 +0100

    kobject: delayed kobject release: help find buggy drivers
    
    Implement debugging for kobject release functions.  kobjects are
    reference counted, so the drop of the last reference to them is not
    predictable. However, the common case is for the last reference to be
    the kobject's removal from a subsystem, which results in the release
    function being immediately called.
    
    This can hide subtle bugs, which can occur when another thread holds a
    reference to the kobject at the same time that a kobject is removed.
    This results in the release method being delayed.
    
    In order to make these kinds of problems more visible, the following
    patch implements a delayed release; this has the effect that the
    release function will be out of order with respect to the removal of
    the kobject in the same manner that it would be if a reference was
    being held.
    
    This provides us with an easy way to allow driver writers to debug
    their drivers and fix otherwise hidden problems.
    
    Signed-off-by: Russell King <rmk+kernel@arm.linux.org.uk>
    Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

[    4.230561] init: Temporary process spawn error: No space left on device
[    4.260052] ------------[ cut here ]------------
[    4.260720] WARNING: CPU: 1 PID: 9 at lib/list_debug.c:33 __list_add+0x6c/0xae()
[    4.261993] list_add corruption. prev->next should be next (78100408), but was 716c92f0. (prev=781ac170).
[    4.263266] Modules linked in:
[    4.263712] CPU: 1 PID: 9 Comm: rcu_sched Not tainted 3.11.0-02563-gf74a274 #188
[    4.264702]  00000000 00000000 78067df4 7920b4c3 78067e34 78067e24 79030823 792f0a64
[    4.265894]  78067e50 00000009 792f0a3a 00000021 79105213 79105213 781ac170 78100408
[    4.267087]  78067ea0 78067e3c 79030868 00000009 78067e34 792f0a64 78067e50 78067e68
[    4.268281] Call Trace:
[    4.268633]  [<7920b4c3>] dump_stack+0x4b/0x66
[    4.269237]  [<79030823>] warn_slowpath_common+0x74/0x8b
[    4.269956]  [<79105213>] ? __list_add+0x6c/0xae
[    4.270014]  [<79105213>] ? __list_add+0x6c/0xae
[    4.270014]  [<79030868>] warn_slowpath_fmt+0x2e/0x30
[    4.270014]  [<79105213>] __list_add+0x6c/0xae
[    4.270014]  [<79036b0e>] __internal_add_timer+0x8a/0x8e
[    4.270014]  [<79036b20>] internal_add_timer+0xe/0x26
[    4.270014]  [<7920bcce>] schedule_timeout+0x126/0x16e
[    4.270014]  [<79036bda>] ? cascade+0x5a/0x5a
[    4.270014]  [<7907b60a>] rcu_gp_kthread+0x299/0x467
[    4.270014]  [<79045a1c>] ? abort_exclusive_wait+0x63/0x63
[    4.270014]  [<7907b371>] ? rcu_gp_fqs+0x53/0x53
[    4.270014]  [<79045276>] kthread+0x95/0x9a
[    4.270014]  [<79040000>] ? __flush_work+0x101/0x1e2
[    4.270014]  [<7921093b>] ret_from_kernel_thread+0x1b/0x30
[    4.270014]  [<790451e1>] ? kthread_stop+0x4e/0x4e
[    4.270014] ---[ end trace 4267c218318dfa80 ]---

git bisect start f74a274c8b0b0a3837d5706d1b7bd1d120a226bb v3.11 --
git bisect good 91121c103ae93ef117e58712786864270d7f488e  # 22:37    420+  staging: dwc2: make dwc2_core_params documentation more complete
git bisect good 1d1fdd95df681f0c065d90ffaafa215a0e8825e2  # 04:27    420+  Merge tag 'char-misc-3.12-rc1' of git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/char-misc
git bisect  bad f66c83d059d1ed90968caa81d401f160912b063a  # 04:33      3-  Merge tag 'scsi-misc' of git://git.kernel.org/pub/scm/linux/kernel/git/jejb/scsi
git bisect good 2d1d3f3ae985ec5676fb56ff2c7acad2e1c4e6eb  # 04:46    420+  hvc_xen: Remove unnecessary __GFP_ZERO from kzalloc
git bisect  bad 542a086ac72fb193cbc1b996963a572269e57743  # 04:52     12-  Merge tag 'driver-core-3.12-rc1' of git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/driver-core
git bisect  bad 879f1bec8e136c7bc71e38715e62a73b75f91d78  # 04:57     13-  drivers: base: remove unneeded variable
git bisect  bad e70b0915124942204dec8064bb25756e8723b81a  # 05:03      7-  tile / cpu topology: remove stale Macro arch_provides_topology_pointers
git bisect  bad d79fd03fd651bd91a081fc97f5f0d221557f8cbb  # 05:09      1-  video: backlight: lcd: convert class code to use dev_groups
git bisect good e56341ad380114454119ac043e6d710ddbbb7710  # 05:29    420+  staging: comedi: convert class code to use dev_groups
git bisect  bad 58b267d3e3f3ce87c3e559e4c330c8c03e905f5e  # 05:35      4-  dma: convert dma_devclass to use dev_groups
git bisect good 7c42721fe0c58a848849b43ff558cf2fb86aa35a  # 05:59    420+  char: tile-srom: fix build error
git bisect  bad c817a67ecba7c3c2aaa104796d78f160af60920d  # 06:10      0-  kobject: delayed kobject release: help find buggy drivers
git bisect good 7c42721fe0c58a848849b43ff558cf2fb86aa35a  # 15:07   1260+  char: tile-srom: fix build error
git bisect good 7c42721fe0c58a848849b43ff558cf2fb86aa35a  # 15:07   1260+  char: tile-srom: fix build error
git bisect  bad 272b98c6455f00884f0350f775c5342358ebb73f  # 15:14      0-  Linux 3.12-rc1

Thanks,
Fengguang

--gj572EiMnwbLXET9
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="dmesg-quantal-bay-1:20130915142709:3.11.0-02563-gf74a274:188"
Content-Transfer-Encoding: quoted-printable

[    0.000000] Linux version 3.11.0-02563-gf74a274 (kbuild@inn) (gcc versio=
n 4.8.1 (Debian 4.8.1-8) ) #188 SMP Fri Sep 13 16:35:53 CST 2013
[    0.000000] KERNEL supported cpus:
[    0.000000]   Intel GenuineIntel
[    0.000000]   AMD AuthenticAMD
[    0.000000]   NSC Geode by NSC
[    0.000000]   Cyrix CyrixInstead
[    0.000000]   UMC UMC UMC UMC
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
[    0.000000] Notice: NX (Execute Disable) protection cannot be enabled: n=
on-PAE kernel!
[    0.000000] Hypervisor detected: KVM
[    0.000000] e820: update [mem 0x00000000-0x00000fff] usable =3D=3D> rese=
rved
[    0.000000] e820: remove [mem 0x000a0000-0x000fffff] usable
[    0.000000] e820: last_pfn =3D 0xfffe max_arch_pfn =3D 0x100000
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
[    0.000000] Scanning 1 areas for low memory corruption
[    0.000000] initial memory mapped: [mem 0x00000000-0x01ffffff]
[    0.000000] Base memory trampoline at [7809b000] 9b000 size 16384
[    0.000000] init_memory_mapping: [mem 0x00000000-0x000fffff]
[    0.000000]  [mem 0x00000000-0x000fffff] page 4k
[    0.000000] init_memory_mapping: [mem 0x0e000000-0x0e3fffff]
[    0.000000]  [mem 0x0e000000-0x0e3fffff] page 4k
[    0.000000] BRK [0x01979000, 0x01979fff] PGTABLE
[    0.000000] init_memory_mapping: [mem 0x08000000-0x0dffffff]
[    0.000000]  [mem 0x08000000-0x0dffffff] page 4k
[    0.000000] BRK [0x0197a000, 0x0197afff] PGTABLE
[    0.000000] BRK [0x0197b000, 0x0197bfff] PGTABLE
[    0.000000] BRK [0x0197c000, 0x0197cfff] PGTABLE
[    0.000000] BRK [0x0197d000, 0x0197dfff] PGTABLE
[    0.000000] BRK [0x0197e000, 0x0197efff] PGTABLE
[    0.000000] init_memory_mapping: [mem 0x00100000-0x07ffffff]
[    0.000000]  [mem 0x00100000-0x07ffffff] page 4k
[    0.000000] init_memory_mapping: [mem 0x0e400000-0x0fffdfff]
[    0.000000]  [mem 0x0e400000-0x0fffdfff] page 4k
[    0.000000] log_buf_len: 8388608
[    0.000000] early log buf free: 128092(97%)
[    0.000000] RAMDISK: [mem 0x0e73f000-0x0ffeffff]
[    0.000000] ACPI: RSDP 000fd920 00014 (v00 BOCHS )
[    0.000000] ACPI: RSDT 0fffe450 00034 (v01 BOCHS  BXPCRSDT 00000001 BXPC=
 00000001)
[    0.000000] ACPI: FACP 0fffff80 00074 (v01 BOCHS  BXPCFACP 00000001 BXPC=
 00000001)
[    0.000000] ACPI: DSDT 0fffe490 011A9 (v01   BXPC   BXDSDT 00000001 INTL=
 20100528)
[    0.000000] ACPI: FACS 0fffff40 00040
[    0.000000] ACPI: SSDT 0ffff7a0 00796 (v01 BOCHS  BXPCSSDT 00000001 BXPC=
 00000001)
[    0.000000] ACPI: APIC 0ffff680 00080 (v01 BOCHS  BXPCAPIC 00000001 BXPC=
 00000001)
[    0.000000] ACPI: HPET 0ffff640 00038 (v01 BOCHS  BXPCHPET 00000001 BXPC=
 00000001)
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] mapped APIC to         ffffa000 (        fee00000)
[    0.000000] 0MB HIGHMEM available.
[    0.000000] 255MB LOWMEM available.
[    0.000000]   mapped low ram: 0 - 0fffe000
[    0.000000]   low ram: 0 - 0fffe000
[    0.000000] kvm-clock: Using msrs 4b564d01 and 4b564d00
[    0.000000] kvm-clock: cpu 0, msr 0:fffd001, boot clock
[    0.000000] Zone ranges:
[    0.000000]   Normal   [mem 0x00001000-0x0fffdfff]
[    0.000000]   HighMem  empty
[    0.000000] Movable zone start for each node
[    0.000000] Early memory node ranges
[    0.000000]   node   0: [mem 0x00001000-0x0009efff]
[    0.000000]   node   0: [mem 0x00100000-0x0fffdfff]
[    0.000000] On node 0 totalpages: 65436
[    0.000000]   Normal zone: 640 pages used for memmap
[    0.000000]   Normal zone: 0 pages reserved
[    0.000000]   Normal zone: 65436 pages, LIFO batch:15
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
[    0.000000] setup_percpu: NR_CPUS:8 nr_cpumask_bits:8 nr_cpu_ids:2 nr_no=
de_ids:1
[    0.000000] PERCPU: Embedded 12 pages/cpu @8647f000 s27136 r0 d22016 u49=
152
[    0.000000] pcpu-alloc: s27136 r0 d22016 u49152 alloc=3D12*4096
[    0.000000] pcpu-alloc: [0] 0 [0] 1=20
[    0.000000] kvm-clock: cpu 0, msr 0:fffd001, primary cpu clock
[    0.000000] KVM setup async PF for cpu 0
[    0.000000] kvm-stealtime: cpu 0, msr e481640
[    0.000000] Built 1 zonelists in Zone order, mobility grouping on.  Tota=
l pages: 64796
[    0.000000] Kernel command line: hung_task_panic=3D1 rcutree.rcu_cpu_sta=
ll_timeout=3D100 log_buf_len=3D8M ignore_loglevel debug sched_debug apic=3D=
debug dynamic_printk sysrq_always_enabled panic=3D10  prompt_ramdisk=3D0 co=
nsole=3DttyS0,115200 console=3Dtty0 vga=3Dnormal  root=3D/dev/ram0 rw link=
=3D/kernel-tests/run-queue/kvm/i386-randconfig-i002-0912/vireshk:for-v3.13/=
=2Evmlinuz-f74a274c8b0b0a3837d5706d1b7bd1d120a226bb-20130914204917-3-bay br=
anch=3Dvireshk/for-v3.13  BOOT_IMAGE=3D/kernel/i386-randconfig-i002-0912/f7=
4a274c8b0b0a3837d5706d1b7bd1d120a226bb/vmlinuz-3.11.0-02563-gf74a274
[    0.000000] sysrq: sysrq always enabled.
[    0.000000] PID hash table entries: 1024 (order: 0, 4096 bytes)
[    0.000000] Dentry cache hash table entries: 32768 (order: 5, 131072 byt=
es)
[    0.000000] Inode-cache hash table entries: 16384 (order: 4, 65536 bytes)
[    0.000000] Initializing CPU#0
[    0.000000] Initializing HighMem for node 0 (00000000:00000000)
[    0.000000] Memory: 215240K/261744K available (2117K kernel code, 193K r=
wdata, 1180K rodata, 300K init, 5856K bss, 46504K reserved, 0K highmem)
[    0.000000] virtual kernel memory layout:
[    0.000000]     fixmap  : 0xffe6d000 - 0xfffff000   (1608 kB)
[    0.000000]     pkmap   : 0xff800000 - 0xffc00000   (4096 kB)
[    0.000000]     vmalloc : 0x887fe000 - 0xff7fe000   (1904 MB)
[    0.000000]     lowmem  : 0x78000000 - 0x87ffe000   ( 255 MB)
[    0.000000]       .init : 0x7936b000 - 0x793b6000   ( 300 kB)
[    0.000000]       .data : 0x7921180e - 0x7936a580   (1379 kB)
[    0.000000]       .text : 0x79000000 - 0x7921180e   (2118 kB)
[    0.000000] Checking if this processor honours the WP bit even in superv=
isor mode...Ok.
[    0.000000] SLUB: HWalign=3D128, Order=3D0-3, MinObjects=3D0, CPUs=3D2, =
Nodes=3D1
[    0.000000] Hierarchical RCU implementation.
[    0.000000]=20
[    0.000000] NR_IRQS:2304 nr_irqs:56 16
[    0.000000] CPU 0 irqstacks, hard=3D78096000 soft=3D78080000
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
[    0.000000] ODEBUG: 11 of 11 active objects replaced
[    0.000000] hpet clockevent registered
[    0.000000] tsc: Detected 2992.486 MHz processor
[    0.020000] Calibrating delay loop (skipped) preset value.. 5984.97 Bogo=
MIPS (lpj=3D29924860)
[    0.020000] pid_max: default: 32768 minimum: 301
[    0.020000] Security Framework initialized
[    0.020000] Yama: becoming mindful.
[    0.020000] Mount-cache hash table entries: 512
[    0.020000] Last level iTLB entries: 4KB 0, 2MB 0, 4MB 0
[    0.020000] Last level dTLB entries: 4KB 0, 2MB 0, 4MB 0
[    0.020000] tlb_flushall_shift: 6
[    0.020467] debug: unmapping init [mem 0x793b6000-0x793b8fff]
[    0.025023] ACPI: Core revision 20130725
[    0.027378] ACPI: All ACPI Tables successfully acquired
[    0.028687] Getting VERSION: 50014
[    0.030016] Getting VERSION: 50014
[    0.030527] Getting ID: 0
[    0.030941] Getting ID: f000000
[    0.031418] Getting LVT0: 8700
[    0.031877] Getting LVT1: 8400
[    0.032340] Enabling APIC mode:  Flat.  Using 1 I/O APICs
[    0.033234] enabled ExtINT on CPU#0
[    0.035151] ENABLING IO-APIC IRQs
[    0.035644] init IO_APIC IRQs
[    0.036097]  apic 0 pin 0 not connected
[    0.036671] IOAPIC[0]: Set routing entry (0-1 -> 0x31 -> IRQ 1 Mode:0 Ac=
tive:0 Dest:1)
[    0.037826] IOAPIC[0]: Set routing entry (0-2 -> 0x30 -> IRQ 0 Mode:0 Ac=
tive:0 Dest:1)
[    0.038985] IOAPIC[0]: Set routing entry (0-3 -> 0x33 -> IRQ 3 Mode:0 Ac=
tive:0 Dest:1)
[    0.040027] IOAPIC[0]: Set routing entry (0-4 -> 0x34 -> IRQ 4 Mode:0 Ac=
tive:0 Dest:1)
[    0.041170] IOAPIC[0]: Set routing entry (0-5 -> 0x35 -> IRQ 5 Mode:1 Ac=
tive:0 Dest:1)
[    0.042355] IOAPIC[0]: Set routing entry (0-6 -> 0x36 -> IRQ 6 Mode:0 Ac=
tive:0 Dest:1)
[    0.043508] IOAPIC[0]: Set routing entry (0-7 -> 0x37 -> IRQ 7 Mode:0 Ac=
tive:0 Dest:1)
[    0.044650] IOAPIC[0]: Set routing entry (0-8 -> 0x38 -> IRQ 8 Mode:0 Ac=
tive:0 Dest:1)
[    0.045796] IOAPIC[0]: Set routing entry (0-9 -> 0x39 -> IRQ 9 Mode:1 Ac=
tive:0 Dest:1)
[    0.046959] IOAPIC[0]: Set routing entry (0-10 -> 0x3a -> IRQ 10 Mode:1 =
Active:0 Dest:1)
[    0.048117] IOAPIC[0]: Set routing entry (0-11 -> 0x3b -> IRQ 11 Mode:1 =
Active:0 Dest:1)
[    0.049285] IOAPIC[0]: Set routing entry (0-12 -> 0x3c -> IRQ 12 Mode:0 =
Active:0 Dest:1)
[    0.050028] IOAPIC[0]: Set routing entry (0-13 -> 0x3d -> IRQ 13 Mode:0 =
Active:0 Dest:1)
[    0.051206] IOAPIC[0]: Set routing entry (0-14 -> 0x3e -> IRQ 14 Mode:0 =
Active:0 Dest:1)
[    0.052412] IOAPIC[0]: Set routing entry (0-15 -> 0x3f -> IRQ 15 Mode:0 =
Active:0 Dest:1)
[    0.053575]  apic 0 pin 16 not connected
[    0.054144]  apic 0 pin 17 not connected
[    0.054711]  apic 0 pin 18 not connected
[    0.055309]  apic 0 pin 19 not connected
[    0.055869]  apic 0 pin 20 not connected
[    0.056437]  apic 0 pin 21 not connected
[    0.056998]  apic 0 pin 22 not connected
[    0.057565]  apic 0 pin 23 not connected
[    0.058280] ..TIMER: vector=3D0x30 apic1=3D0 pin1=3D2 apic2=3D-1 pin2=3D=
-1
[    0.060005] smpboot: CPU0: Intel Common KVM processor (fam: 0f, model: 0=
6, stepping: 01)
[    0.061739] Using local APIC timer interrupts.
[    0.061739] calibrating APIC timer ...
[    0.070000] ... lapic delta =3D 6251177
[    0.070000] ... PM-Timer delta =3D 358016
[    0.070000] ... PM-Timer result ok
[    0.070000] ..... delta 6251177
[    0.070000] ..... mult: 268486007
[    0.070000] ..... calibration result: 10001883
[    0.070000] ..... CPU clock speed is 2992.9644 MHz.
[    0.070000] ..... host bus clock speed is 1000.1883 MHz.
[    0.070000] Performance Events: unsupported Netburst CPU model 6 no PMU =
driver, software events only.
[    0.070000] NMI watchdog: disabled (cpu0): hardware events not enabled
[    0.070000] SMP alternatives: lockdep: fixing up alternatives
[    0.070000] CPU 1 irqstacks, hard=3D78108000 soft=3D7810a000
[    0.070000] smpboot: Booting Node   0, Processors  #1 OK
[    0.010000] Initializing CPU#1
[    0.020000] kvm-clock: cpu 1, msr 0:fffd041, secondary cpu clock
[    0.020000] masked ExtINT on CPU#1
[    0.110127] Brought up 2 CPUs
[    0.110092] KVM setup async PF for cpu 1
[    0.110092] kvm-stealtime: cpu 1, msr e48d640
[    0.111965] smpboot: Total of 2 processors activated (11969.94 BogoMIPS)
[    0.124409] devtmpfs: initialized
[    0.130374] regulator-dummy: no parameters
[    0.131202] NET: Registered protocol family 16
[    0.132405] cpuidle: using governor menu
[    0.142816] ACPI: bus type PCI registered
[    0.143486] PCI: PCI BIOS revision 2.10 entry at 0xfc6d5, last bus=3D0
[    0.150181] ACPI: Added _OSI(Module Device)
[    0.150851] ACPI: Added _OSI(Processor Device)
[    0.151471] ACPI: Added _OSI(3.0 _SCP Extensions)
[    0.152130] ACPI: Added _OSI(Processor Aggregator Device)
[    0.154634] ACPI: EC: Look up EC in DSDT
[    0.159806] ACPI: Interpreter enabled
[    0.160015] ACPI: (supports S0 S5)
[    0.160508] ACPI: Using IOAPIC for interrupt routing
[    0.161227] PCI: Using host bridge windows from ACPI; if necessary, use =
"pci=3Dnocrs" and report a bug
[    0.172276] ACPI: PCI Root Bridge [PCI0] (domain 0000 [bus 00-ff])
[    0.173113] acpi PNP0A03:00: Unable to request _OSC control (_OSC suppor=
t mask: 0x08)
[    0.175106] PCI host bridge to bus 0000:00
[    0.175758] pci_bus 0000:00: root bus resource [bus 00-ff]
[    0.176509] pci_bus 0000:00: root bus resource [io  0x0000-0x0cf7]
[    0.177388] pci_bus 0000:00: root bus resource [io  0x0d00-0xffff]
[    0.178263] pci_bus 0000:00: root bus resource [mem 0x000a0000-0x000bfff=
f]
[    0.179243] pci_bus 0000:00: root bus resource [mem 0x80000000-0xfebffff=
f]
[    0.180091] pci 0000:00:00.0: [8086:1237] type 00 class 0x060000
[    0.181630] pci 0000:00:01.0: [8086:7000] type 00 class 0x060100
[    0.183340] pci 0000:00:01.1: [8086:7010] type 00 class 0x010180
[    0.187301] pci 0000:00:01.1: reg 0x20: [io  0xc1e0-0xc1ef]
[    0.189629] pci 0000:00:01.3: [8086:7113] type 00 class 0x068000
[    0.190519] pci 0000:00:01.3: quirk: [io  0xb000-0xb03f] claimed by PIIX=
4 ACPI
[    0.191528] pci 0000:00:01.3: quirk: [io  0xb100-0xb10f] claimed by PIIX=
4 SMB
[    0.193060] pci 0000:00:02.0: [1013:00b8] type 00 class 0x030000
[    0.196178] pci 0000:00:02.0: reg 0x10: [mem 0xfc000000-0xfdffffff pref]
[    0.198511] pci 0000:00:02.0: reg 0x14: [mem 0xfebe4000-0xfebe4fff]
[    0.207415] pci 0000:00:02.0: reg 0x30: [mem 0xfebc0000-0xfebcffff pref]
[    0.209157] pci 0000:00:03.0: [1af4:1000] type 00 class 0x020000
[    0.211244] pci 0000:00:03.0: reg 0x10: [io  0xc1c0-0xc1df]
[    0.213108] pci 0000:00:03.0: reg 0x14: [mem 0xfebe5000-0xfebe5fff]
[    0.219418] pci 0000:00:03.0: reg 0x30: [mem 0xfebd0000-0xfebdffff pref]
[    0.220517] pci 0000:00:04.0: [8086:100e] type 00 class 0x020000
[    0.222487] pci 0000:00:04.0: reg 0x10: [mem 0xfeb80000-0xfeb9ffff]
[    0.224521] pci 0000:00:04.0: reg 0x14: [io  0xc000-0xc03f]
[    0.230519] pci 0000:00:04.0: reg 0x30: [mem 0xfeba0000-0xfebbffff pref]
[    0.232154] pci 0000:00:05.0: [8086:2668] type 00 class 0x040300
[    0.233703] pci 0000:00:05.0: reg 0x10: [mem 0xfebe0000-0xfebe3fff]
[    0.241723] pci 0000:00:06.0: [1af4:1001] type 00 class 0x010000
[    0.243727] pci 0000:00:06.0: reg 0x10: [io  0xc040-0xc07f]
[    0.245611] pci 0000:00:06.0: reg 0x14: [mem 0xfebe6000-0xfebe6fff]
[    0.252135] pci 0000:00:07.0: [1af4:1001] type 00 class 0x010000
[    0.254110] pci 0000:00:07.0: reg 0x10: [io  0xc080-0xc0bf]
[    0.255995] pci 0000:00:07.0: reg 0x14: [mem 0xfebe7000-0xfebe7fff]
[    0.263223] pci 0000:00:08.0: [1af4:1001] type 00 class 0x010000
[    0.265197] pci 0000:00:08.0: reg 0x10: [io  0xc0c0-0xc0ff]
[    0.267073] pci 0000:00:08.0: reg 0x14: [mem 0xfebe8000-0xfebe8fff]
[    0.272955] pci 0000:00:09.0: [1af4:1001] type 00 class 0x010000
[    0.275185] pci 0000:00:09.0: reg 0x10: [io  0xc100-0xc13f]
[    0.277042] pci 0000:00:09.0: reg 0x14: [mem 0xfebe9000-0xfebe9fff]
[    0.283599] pci 0000:00:0a.0: [1af4:1001] type 00 class 0x010000
[    0.285560] pci 0000:00:0a.0: reg 0x10: [io  0xc140-0xc17f]
[    0.287399] pci 0000:00:0a.0: reg 0x14: [mem 0xfebea000-0xfebeafff]
[    0.294205] pci 0000:00:0b.0: [1af4:1001] type 00 class 0x010000
[    0.296199] pci 0000:00:0b.0: reg 0x10: [io  0xc180-0xc1bf]
[    0.298041] pci 0000:00:0b.0: reg 0x14: [mem 0xfebeb000-0xfebebfff]
[    0.304691] pci 0000:00:0c.0: [8086:25ab] type 00 class 0x088000
[    0.306156] pci 0000:00:0c.0: reg 0x10: [mem 0xfebec000-0xfebec00f]
[    0.311061] pci_bus 0000:00: on NUMA node 0
[    0.312663] ACPI: PCI Interrupt Link [LNKA] (IRQs 5 *10 11)
[    0.313720] ACPI: PCI Interrupt Link [LNKB] (IRQs 5 *10 11)
[    0.314769] ACPI: PCI Interrupt Link [LNKC] (IRQs 5 10 *11)
[    0.315849] ACPI: PCI Interrupt Link [LNKD] (IRQs 5 10 *11)
[    0.316826] ACPI: PCI Interrupt Link [LNKS] (IRQs *9)
[    0.318415] ACPI: Enabled 16 GPEs in block 00 to 0F
[    0.319134] ACPI: \_SB_.PCI0: notify handler is installed
[    0.320095] Found 1 acpi root devices
[    0.320940] pps_core: LinuxPPS API ver. 1 registered
[    0.321652] pps_core: Software ver. 5.3.6 - Copyright 2005-2007 Rodolfo =
Giometti <giometti@linux.it>
[    0.322917] PCI: Using ACPI for IRQ routing
[    0.323526] PCI: pci_cache_line_size set to 64 bytes
[    0.324549] e820: reserve RAM buffer [mem 0x0009fc00-0x0009ffff]
[    0.325369] e820: reserve RAM buffer [mem 0x0fffe000-0x0fffffff]
[    0.331516] Switched to clocksource kvm-clock
[    0.332492] pnp: PnP ACPI init
[    0.332943] ACPI: bus type PNP registered
[    0.333535] IOAPIC[0]: Set routing entry (0-8 -> 0x38 -> IRQ 8 Mode:0 Ac=
tive:0 Dest:3)
[    0.333830] pnp 00:00: Plug and Play ACPI device, IDs PNP0b00 (active)
[    0.334775] IOAPIC[0]: Set routing entry (0-1 -> 0x31 -> IRQ 1 Mode:0 Ac=
tive:0 Dest:3)
[    0.336005] pnp 00:01: Plug and Play ACPI device, IDs PNP0303 (active)
[    0.336916] IOAPIC[0]: Set routing entry (0-12 -> 0x3c -> IRQ 12 Mode:0 =
Active:0 Dest:3)
[    0.338173] pnp 00:02: Plug and Play ACPI device, IDs PNP0f13 (active)
[    0.339122] IOAPIC[0]: Set routing entry (0-6 -> 0x36 -> IRQ 6 Mode:0 Ac=
tive:0 Dest:3)
[    0.340246] pnp 00:03: [dma 2]
[    0.340737] pnp 00:03: Plug and Play ACPI device, IDs PNP0700 (active)
[    0.341697] IOAPIC[0]: Set routing entry (0-7 -> 0x37 -> IRQ 7 Mode:0 Ac=
tive:0 Dest:3)
[    0.342896] pnp 00:04: Plug and Play ACPI device, IDs PNP0400 (active)
[    0.343860] IOAPIC[0]: Set routing entry (0-4 -> 0x34 -> IRQ 4 Mode:0 Ac=
tive:0 Dest:3)
[    0.345036] pnp 00:05: Plug and Play ACPI device, IDs PNP0501 (active)
[    0.346223] pnp 00:06: Plug and Play ACPI device, IDs PNP0103 (active)
[    0.347362] pnp: PnP ACPI: found 7 devices
[    0.347966] ACPI: bus type PNP unregistered
[    0.384707] pci_bus 0000:00: resource 4 [io  0x0000-0x0cf7]
[    0.385496] pci_bus 0000:00: resource 5 [io  0x0d00-0xffff]
[    0.386275] pci_bus 0000:00: resource 6 [mem 0x000a0000-0x000bffff]
[    0.387124] pci_bus 0000:00: resource 7 [mem 0x80000000-0xfebfffff]
[    0.388009] NET: Registered protocol family 1
[    0.388623] pci 0000:00:00.0: Limiting direct PCI/PCI transfers
[    0.389469] pci 0000:00:01.0: PIIX3: Enabling Passive Release
[    0.390327] pci 0000:00:01.0: Activating ISA DMA hang workarounds
[    0.391196] pci 0000:00:02.0: Boot video device
[    0.391969] PCI: CLS 0 bytes, default 64
[    0.392806] Unpacking initramfs...
[    3.074179] debug: unmapping init [mem 0x8673f000-0x87feffff]
[    3.076733] microcode: CPU0 sig=3D0xf61, pf=3D0x1, revision=3D0x1
[    3.077506] microcode: CPU1 sig=3D0xf61, pf=3D0x1, revision=3D0x1
[    3.078611] microcode: Microcode Update Driver: v2.00 <tigran@aivazian.f=
snet.co.uk>, Peter Oruba
[    3.079808] Scanning for low memory corruption every 60 seconds
[    3.081216] NatSemi SCx200 Driver
[    3.084510] Initializing RT-Tester: OK
[    3.117821] crc32: CRC_LE_BITS =3D 32, CRC_BE BITS =3D 32
[    3.118557] crc32: self tests passed, processed 225944 bytes in 209785 n=
sec
[    3.119768] crc32c: CRC_LE_BITS =3D 32
[    3.120350] crc32c: self tests passed, processed 225944 bytes in 101750 =
nsec
[    3.121630] pci_hotplug: PCI Hot Plug PCI Core version: 0.5
[    3.122446] cpcihp_generic: Generic port I/O CompactPCI Hot Plug Driver =
version: 0.1
[    3.123544] cpcihp_generic: not configured, disabling.
[    3.124324] shpchp: Standard Hot Plug PCI Controller Driver version: 0.4
[    3.125306] ipmi message handler version 39.2
[    3.125936] ipmi device interface
[    3.126471] IPMI Watchdog: driver initialized
[    3.127389] input: Power Button as /devices/LNXSYSTM:00/LNXPWRBN:00/inpu=
t/input0
[    3.128475] ACPI: Power Button [PWRF]
[    3.166307] Serial: 8250/16550 driver, 4 ports, IRQ sharing disabled
[    3.189457] 00:05: ttyS0 at I/O 0x3f8 (irq =3D 4, base_baud =3D 115200) =
is a 16550A
[    3.191652] Non-volatile memory driver v1.3
[    3.192214] toshiba: not a supported Toshiba laptop
[    3.192869] nsc_gpio initializing
[    3.193554] dummy-irq: no IRQ given.  Use irq=3DN
[    3.194204] Phantom Linux Driver, version n0.9.8, init OK
[    3.195277] i8042: PNP: PS/2 Controller [PNP0303:KBD,PNP0f13:MOU] at 0x6=
0,0x64 irq 1,12
[    3.197380] serio: i8042 KBD port at 0x60,0x64 irq 1
[    3.198099] serio: i8042 AUX port at 0x60,0x64 irq 12
[    3.199234] mousedev: PS/2 mouse device common for all mice
[    3.200766] input: AT Translated Set 2 keyboard as /devices/platform/i80=
42/serio0/input/input1
[    3.202361] rtc_cmos 00:00: RTC can wake from S4
[    3.203247] rtc (null): alarm rollover: day
[    3.204292] rtc rtc0: rtc_cmos: dev (254:0)
[    3.204865] rtc_cmos 00:00: rtc core: registered rtc_cmos as rtc0
[    3.205823] rtc_cmos 00:00: alarms up to one day, 114 bytes nvram, hpet =
irqs
[    3.206819] Driver for 1-wire Dallas network protocol.
[    3.207761] intel_powerclamp: Intel powerclamp does not run on family 15=
 model 6
[    3.209189] advantechwdt: WDT driver for Advantech single board computer=
 initialising
[    3.210577] advantechwdt: initialized. timeout=3D60 sec (nowayout=3D1)
[    3.211429] i6300esb: Intel 6300ESB WatchDog Timer Driver v0.05
[    3.212398] i6300esb: cannot register miscdev on minor=3D130 (err=3D-16)
[    3.213309] i6300ESB timer: probe of 0000:00:0c.0 failed with error -16
[    3.214208] pc87413_wdt: Version 1.1 at io 0x2E
[    3.214826] pc87413_wdt: cannot register miscdev on minor=3D130 (err=3D-=
16)
[    3.215728] sbc7240_wdt: I/O address 0x0443 already in use
[    3.216493] watchdog: Software Watchdog: cannot register miscdev on mino=
r=3D130 (err=3D-16).
[    3.217570] watchdog: Software Watchdog: a legacy watchdog module is pro=
bably present.
[    3.218793] softdog: Software Watchdog Timer: 0.08 initialized. soft_nob=
oot=3D0 soft_margin=3D60 sec soft_panic=3D0 (nowayout=3D1)
[    3.220577]=20
[    3.220577] printing PIC contents
[    3.221229] ... PIC  IMR: ffff
[    3.221680] ... PIC  IRR: 1113
[    3.222147] ... PIC  ISR: 0000
[    3.222570] ... PIC ELCR: 0c00
[    3.223015] printing local APIC contents on CPU#0/0:
[    3.223690] ... APIC ID:      00000000 (0)
[    3.224234] ... APIC VERSION: 00050014
[    3.224741] ... APIC TASKPRI: 00000000 (00)
[    3.225297] ... APIC PROCPRI: 00000000
[    3.225803] ... APIC LDR: 01000000
[    3.226260] ... APIC DFR: ffffffff
[    3.226723] ... APIC SPIV: 000001ff
[    3.227186] ... APIC ISR field:
[    3.227707] 000000000000000000000000000000000000000000000000000000000000=
0000
[    3.228817] ... APIC TMR field:
[    3.229244] 000000000200000000000000000000000000000000000000000000000000=
0000
[    3.230492] ... APIC IRR field:
[    3.230929] 000000000000000000000000000000000000000000000000000000002000=
8000
[    3.232061] ... APIC ESR: 00000000
[    3.232528] ... APIC ICR: 000008fd
[    3.232994] ... APIC ICR2: 02000000
[    3.233005] ... APIC LVTT: 000000ef
[    3.233005] ... APIC LVTPC: 00010000
[    3.233005] ... APIC LVT0: 00010700
[    3.233005] ... APIC LVT1: 00000400
[    3.233005] ... APIC LVTERR: 000000fe
[    3.233005] ... APIC TMICT: 0009860d
[    3.233005] ... APIC TMCCT: 00000000
[    3.233005] ... APIC TDCR: 00000003
[    3.233005]=20
[    3.237575] number of MP IRQ sources: 15.
[    3.238129] number of IO-APIC #0 registers: 24.
[    3.238736] testing the IO APIC.......................
[    3.239441] IO APIC #0......
[    3.239837] .... register #00: 00000000
[    3.240384] .......    : physical APIC id: 00
[    3.240971] .......    : Delivery Type: 0
[    3.241508] .......    : LTS          : 0
[    3.242048] .... register #01: 00170011
[    3.242561] .......     : max redirection entries: 17
[    3.243232] .......     : PRQ implemented: 0
[    3.243805] .......     : IO APIC version: 11
[    3.244386] .... register #02: 00000000
[    3.244903] .......     : arbitration: 00
[    3.245438] .... IRQ redirection table:
[    3.245972] 1    0    0   0   0    0    0    00
[    3.246589] 0    0    0   0   0    1    1    31
[    3.247211] 0    0    0   0   0    1    1    30
[    3.247839] 0    0    0   0   0    1    1    33
[    3.248457] 1    0    0   0   0    1    1    34
[    3.249082] 1    1    0   0   0    1    1    35
[    3.249706] 0    0    0   0   0    1    1    36
[    3.250354] 0    0    0   0   0    1    1    37
[    3.250978] 0    0    0   0   0    1    1    38
[    3.251594] 0    1    0   0   0    1    1    39
[    3.252216] 1    1    0   0   0    1    1    3A
[    3.252836] 1    1    0   0   0    1    1    3B
[    3.253451] 0    0    0   0   0    1    1    3C
[    3.254070] 0    0    0   0   0    1    1    3D
[    3.254691] 0    0    0   0   0    1    1    3E
[    3.255308] 0    0    0   0   0    1    1    3F
[    3.255927] 1    0    0   0   0    0    0    00
[    3.256540] 1    0    0   0   0    0    0    00
[    3.257160] 1    0    0   0   0    0    0    00
[    3.257780] 1    0    0   0   0    0    0    00
[    3.258394] 1    0    0   0   0    0    0    00
[    3.259016] 1    0    0   0   0    0    0    00
[    3.259640] 1    0    0   0   0    0    0    00
[    3.260286] 1    0    0   0   0    0    0    00
[    3.260896] IRQ to pin mappings:
[    3.261332] IRQ0 -> 0:2
[    3.261712] IRQ1 -> 0:1
[    3.262086] IRQ3 -> 0:3
[    3.262460] IRQ4 -> 0:4
[    3.262839] IRQ5 -> 0:5
[    3.263213] IRQ6 -> 0:6
[    3.263587] IRQ7 -> 0:7
[    3.263966] IRQ8 -> 0:8
[    3.264340] IRQ9 -> 0:9
[    3.264719] IRQ10 -> 0:10
[    3.265116] IRQ11 -> 0:11
[    3.265512] IRQ12 -> 0:12
[    3.265913] IRQ13 -> 0:13
[    3.266308] IRQ14 -> 0:14
[    3.266708] IRQ15 -> 0:15
[    3.267104] .................................... done.
[    3.267789] Using IPI No-Shortcut mode
[    3.268770] IMA: No TPM chip found, activating TPM-bypass!
[    3.270901] rtc_cmos 00:00: setting system clock to 2013-09-15 06:26:54 =
UTC (1379226414)
[    3.272248] Unregister pv shared memory for cpu 0
[    3.277829] CPU 0 is now offline
[    3.279580] debug: unmapping init [mem 0x7936b000-0x793b5fff]
[    3.280673] Write protecting the kernel text: 2120k
[    3.281445] Write protecting the kernel read-only data: 1184k
modprobe: FATAL: Could not load /lib/modules/3.11.0-02563-gf74a274/modules.=
dep: No such file or directory

modprobe: FATAL: Could not load /lib/modules/3.11.0-02563-gf74a274/modules.=
dep: No such file or directory

mountall: Event failed
 * Asking all remaining processes to terminate...      =20
[    3.773991] init: Failed to create pty - disabling logging for job
[    3.774988] init: Temporary process spawn error: No space left on device

mountall: Filesystem could not be mounted: /dev/pts
mountall: Skipping mounting /dev/pts since Plymouth is not available
[    3.846653] init: Failed to create pty - disabling logging for job
[    3.847652] init: Temporary process spawn error: No space left on device
[    3.871687] input: ImExPS/2 Generic Explorer Mouse as /devices/platform/=
i8042/serio1/input/input2

[    4.007849] init: Failed to create pty - disabling logging for job
[    4.008967] init: Temporary process spawn error: No space left on device
[    4.016227] init: Failed to create pty - disabling logging for job
[    4.017231] init: Temporary process spawn error: No space left on device
[    4.074530] tsc: Refined TSC clocksource calibration: 2992.479 MHz
[    4.197694] init: Failed to create pty - disabling logging for job
[    4.198713] init: Temporary process spawn error: No space left on device
[    4.203758] init: Failed to create pty - disabling logging for job
[    4.204757] init: Temporary process spawn error: No space left on device
[    4.213454] init: Failed to create pty - disabling logging for job
[    4.214462] init: Temporary process spawn error: No space left on device
[    4.229426] init: Failed to create pty - disabling logging for job
[    4.230561] init: Temporary process spawn error: No space left on device
[    4.260052] ------------[ cut here ]------------
[    4.260720] WARNING: CPU: 1 PID: 9 at lib/list_debug.c:33 __list_add+0x6=
c/0xae()
[    4.261993] list_add corruption. prev->next should be next (78100408), b=
ut was 716c92f0. (prev=3D781ac170).
[    4.263266] Modules linked in:
[    4.263712] CPU: 1 PID: 9 Comm: rcu_sched Not tainted 3.11.0-02563-gf74a=
274 #188
[    4.264702]  00000000 00000000 78067df4 7920b4c3 78067e34 78067e24 79030=
823 792f0a64
[    4.265894]  78067e50 00000009 792f0a3a 00000021 79105213 79105213 781ac=
170 78100408
[    4.267087]  78067ea0 78067e3c 79030868 00000009 78067e34 792f0a64 78067=
e50 78067e68
[    4.268281] Call Trace:
[    4.268633]  [<7920b4c3>] dump_stack+0x4b/0x66
[    4.269237]  [<79030823>] warn_slowpath_common+0x74/0x8b
[    4.269956]  [<79105213>] ? __list_add+0x6c/0xae
[    4.270014]  [<79105213>] ? __list_add+0x6c/0xae
[    4.270014]  [<79030868>] warn_slowpath_fmt+0x2e/0x30
[    4.270014]  [<79105213>] __list_add+0x6c/0xae
[    4.270014]  [<79036b0e>] __internal_add_timer+0x8a/0x8e
[    4.270014]  [<79036b20>] internal_add_timer+0xe/0x26
[    4.270014]  [<7920bcce>] schedule_timeout+0x126/0x16e
[    4.270014]  [<79036bda>] ? cascade+0x5a/0x5a
[    4.270014]  [<7907b60a>] rcu_gp_kthread+0x299/0x467
[    4.270014]  [<79045a1c>] ? abort_exclusive_wait+0x63/0x63
[    4.270014]  [<7907b371>] ? rcu_gp_fqs+0x53/0x53
[    4.270014]  [<79045276>] kthread+0x95/0x9a
[    4.270014]  [<79040000>] ? __flush_work+0x101/0x1e2
[    4.270014]  [<7921093b>] ret_from_kernel_thread+0x1b/0x30
[    4.270014]  [<790451e1>] ? kthread_stop+0x4e/0x4e
[    4.270014] ---[ end trace 4267c218318dfa80 ]---
[    4.280597] BUG: unable to handle kernel NULL pointer dereference at 000=
00004
[    4.281592] IP: [<79036dcc>] run_timer_softirq+0x115/0x19c
[    4.282355] *pde =3D 00000000=20
[    4.282773] Oops: 0002 [#1] SMP DEBUG_PAGEALLOC
[    4.283438] Modules linked in:
[    4.283881] CPU: 1 PID: 9 Comm: rcu_sched Tainted: G        W    3.11.0-=
02563-gf74a274 #188
[    4.284988] task: 7804cd00 ti: 78066000 task.ti: 78066000
[    4.285712] EIP: 0060:[<79036dcc>] EFLAGS: 00010002 CPU: 1
[    4.286441] EIP is at run_timer_softirq+0x115/0x19c
[    4.287097] EAX: 78067dcc EBX: 78100000 ECX: 7804cd00 EDX: 00000000
[    4.287934] ESI: 781ac040 EDI: 00000000 EBP: 78067de0 ESP: 78067dac
[    4.288768]  DS: 007b ES: 007b FS: 00d8 GS: 00e0 SS: 0068
[    4.289487] CR0: 8005003b CR2: 00000004 CR3: 07661000 CR4: 00000690
[    4.290338] Stack:
[    4.290582]  7804cd00 79033c6e ffff8c7b 78100a30 78100830 78067dcc 00000=
000 00000000
[    4.290582]  781ac040 78067ea0 00000101 78066000 7933c084 78067e24 79033=
c9e 78067e14
[    4.290582]  7904fe9e 00000000 00000046 78067e1c 79062186 00000001 00000=
001 0000000a
[    4.290582] Call Trace:
[    4.290582]  [<79033c6e>] ? __do_softirq+0x7b/0x165
[    4.290582]  [<79033c9e>] __do_softirq+0xab/0x165
[    4.290582]  [<7904fe9e>] ? sched_clock_cpu+0x109/0x121
[    4.290582]  [<79062186>] ? tick_nohz_handler+0xcd/0xd9
[    4.290582]  [<79033e6d>] irq_exit+0x56/0x91
[    4.290582]  [<7901e5f0>] smp_apic_timer_interrupt+0x33/0x3d
[    4.290582]  [<792104c9>] apic_timer_interrupt+0x39/0x40
[    4.290582]  [<7920f8fa>] ? _raw_spin_unlock_irqrestore+0x3d/0x4f
[    4.290582]  [<7920bcda>] schedule_timeout+0x132/0x16e
[    4.290582]  [<79036bda>] ? cascade+0x5a/0x5a
[    4.290582]  [<7907b60a>] rcu_gp_kthread+0x299/0x467
[    4.290582]  [<79045a1c>] ? abort_exclusive_wait+0x63/0x63
[    4.290582]  [<7907b371>] ? rcu_gp_fqs+0x53/0x53
[    4.290582]  [<79045276>] kthread+0x95/0x9a
[    4.290582]  [<79040000>] ? __flush_work+0x101/0x1e2
[    4.290582]  [<7921093b>] ret_from_kernel_thread+0x1b/0x30
[    4.290582]  [<790451e1>] ? kthread_stop+0x4e/0x4e
[    4.290582] Code: e0 01 89 44 24 08 8d 46 24 89 44 24 04 89 f0 89 3c 24 =
e8 ca be 02 00 ba 38 96 34 79 89 f0 89 73 20 e8 6a ec 0c 00 8b 16 8b 46 04 =
<89> 42 04 89 10 f6 46 0c 01 c7 06 00 00 00 00 c7 46 04 00 02 20
[    4.290582] EIP: [<79036dcc>] run_timer_softirq+0x115/0x19c SS:ESP 0068:=
78067dac
[    4.290582] CR2: 0000000000000004
[    4.290582] ---[ end trace 4267c218318dfa81 ]---
[    4.290582] Kernel panic - not syncing: Fatal exception in interrupt
[    4.290582] Rebooting in 10 seconds..
BUG: kernel test crashed
Elapsed time: 25
qemu-system-x86_64 -cpu kvm64 -enable-kvm -kernel /tmp//kernel/i386-randcon=
fig-i002-0912/f74a274c8b0b0a3837d5706d1b7bd1d120a226bb/vmlinuz-3.11.0-02563=
-gf74a274-3621 -append 'hung_task_panic=3D1 rcutree.rcu_cpu_stall_timeout=
=3D100 log_buf_len=3D8M ignore_loglevel debug sched_debug apic=3Ddebug dyna=
mic_printk sysrq_always_enabled panic=3D10  prompt_ramdisk=3D0 console=3Dtt=
yS0,115200 console=3Dtty0 vga=3Dnormal  root=3D/dev/ram0 rw link=3D/kernel-=
tests/run-queue/kvm/i386-randconfig-i002-0912/vireshk:for-v3.13/.vmlinuz-f7=
4a274c8b0b0a3837d5706d1b7bd1d120a226bb-20130914204917-3-bay branch=3Dviresh=
k/for-v3.13  BOOT_IMAGE=3D/kernel/i386-randconfig-i002-0912/f74a274c8b0b0a3=
837d5706d1b7bd1d120a226bb/vmlinuz-3.11.0-02563-gf74a274'  -initrd /kernel-t=
ests/initrd/quantal-core-i386.cgz -m 256M -smp 2 -net nic,vlan=3D0,macaddr=
=3D00:00:00:00:00:00,model=3Dvirtio -net user,vlan=3D0,hostfwd=3Dtcp::7717-=
:22 -net nic,vlan=3D1,model=3De1000 -net user,vlan=3D1 -boot order=3Dnc -no=
-reboot -watchdog i6300esb -soundhw hda -drive file=3D/fs/sda3/disk0-bay-36=
21,media=3Ddisk,if=3Dvirtio -drive file=3D/fs/sda3/disk1-bay-3621,media=3Dd=
isk,if=3Dvirtio -drive file=3D/fs/sda3/disk2-bay-3621,media=3Ddisk,if=3Dvir=
tio -drive file=3D/fs/sda3/disk3-bay-3621,media=3Ddisk,if=3Dvirtio -drive f=
ile=3D/fs/sda3/disk4-bay-3621,media=3Ddisk,if=3Dvirtio -drive file=3D/fs/sd=
a3/disk5-bay-3621,media=3Ddisk,if=3Dvirtio -pidfile /dev/shm/kboot/pid-bay-=
lkp-3621 -serial file:/dev/shm/kboot/serial-bay-lkp-3621 -daemonize -displa=
y none -monitor null=20

--gj572EiMnwbLXET9
Content-Type: application/octet-stream
Content-Disposition: attachment; filename="bisect-f74a274c8b0b0a3837d5706d1b7bd1d120a226bb-i386-randconfig-i002-0912-WARNING:-CPU:-58265.log"
Content-Transfer-Encoding: base64

Z2l0IGNoZWNrb3V0IGY3NGEyNzRjOGIwYjBhMzgzN2Q1NzA2ZDFiN2JkMWQxMjBhMjI2YmIK
SEVBRCBpcyBub3cgYXQgZjc0YTI3NC4uLiBNZXJnZSBicmFuY2ggJ3BtLWNwdWZyZXEtbmV4
dCcgaW50byBsaW51eC1uZXh0CmxzIC1hIC9rZXJuZWwtdGVzdHMvcnVuLXF1ZXVlL2t2bS9p
Mzg2LXJhbmRjb25maWctaTAwMi0wOTEyL3ZpcmVzaGs6Zm9yLXYzLjEzOmY3NGEyNzRjOGIw
YjBhMzgzN2Q1NzA2ZDFiN2JkMWQxMjBhMjI2YmI6YmlzZWN0LWRybQogVEVTVCBGQUlMVVJF
ClsgICAgNC4yMzA1NjFdIGluaXQ6IFRlbXBvcmFyeSBwcm9jZXNzIHNwYXduIGVycm9yOiBO
byBzcGFjZSBsZWZ0IG9uIGRldmljZQpbICAgIDQuMjYwMDUyXSAtLS0tLS0tLS0tLS1bIGN1
dCBoZXJlIF0tLS0tLS0tLS0tLS0KWyAgICA0LjI2MDcyMF0gV0FSTklORzogQ1BVOiAxIFBJ
RDogOSBhdCBsaWIvbGlzdF9kZWJ1Zy5jOjMzIF9fbGlzdF9hZGQrMHg2Yy8weGFlKCkKWyAg
ICA0LjI2MTk5M10gbGlzdF9hZGQgY29ycnVwdGlvbi4gcHJldi0+bmV4dCBzaG91bGQgYmUg
bmV4dCAoNzgxMDA0MDgpLCBidXQgd2FzIDcxNmM5MmYwLiAocHJldj03ODFhYzE3MCkuClsg
ICAgNC4yNjMyNjZdIE1vZHVsZXMgbGlua2VkIGluOgpbICAgIDQuMjYzNzEyXSBDUFU6IDEg
UElEOiA5IENvbW06IHJjdV9zY2hlZCBOb3QgdGFpbnRlZCAzLjExLjAtMDI1NjMtZ2Y3NGEy
NzQgIzE4OApbICAgIDQuMjY0NzAyXSAgMDAwMDAwMDAgMDAwMDAwMDAgNzgwNjdkZjQgNzky
MGI0YzMgNzgwNjdlMzQgNzgwNjdlMjQgNzkwMzA4MjMgNzkyZjBhNjQKWyAgICA0LjI2NTg5
NF0gIDc4MDY3ZTUwIDAwMDAwMDA5IDc5MmYwYTNhIDAwMDAwMDIxIDc5MTA1MjEzIDc5MTA1
MjEzIDc4MWFjMTcwIDc4MTAwNDA4ClsgICAgNC4yNjcwODddICA3ODA2N2VhMCA3ODA2N2Uz
YyA3OTAzMDg2OCAwMDAwMDAwOSA3ODA2N2UzNCA3OTJmMGE2NCA3ODA2N2U1MCA3ODA2N2U2
OApbICAgIDQuMjY4MjgxXSBDYWxsIFRyYWNlOgpbICAgIDQuMjY4NjMzXSAgWzw3OTIwYjRj
Mz5dIGR1bXBfc3RhY2srMHg0Yi8weDY2ClsgICAgNC4yNjkyMzddICBbPDc5MDMwODIzPl0g
d2Fybl9zbG93cGF0aF9jb21tb24rMHg3NC8weDhiClsgICAgNC4yNjk5NTZdICBbPDc5MTA1
MjEzPl0gPyBfX2xpc3RfYWRkKzB4NmMvMHhhZQpbICAgIDQuMjcwMDE0XSAgWzw3OTEwNTIx
Mz5dID8gX19saXN0X2FkZCsweDZjLzB4YWUKWyAgICA0LjI3MDAxNF0gIFs8NzkwMzA4Njg+
XSB3YXJuX3Nsb3dwYXRoX2ZtdCsweDJlLzB4MzAKWyAgICA0LjI3MDAxNF0gIFs8NzkxMDUy
MTM+XSBfX2xpc3RfYWRkKzB4NmMvMHhhZQpbICAgIDQuMjcwMDE0XSAgWzw3OTAzNmIwZT5d
IF9faW50ZXJuYWxfYWRkX3RpbWVyKzB4OGEvMHg4ZQpbICAgIDQuMjcwMDE0XSAgWzw3OTAz
NmIyMD5dIGludGVybmFsX2FkZF90aW1lcisweGUvMHgyNgpbICAgIDQuMjcwMDE0XSAgWzw3
OTIwYmNjZT5dIHNjaGVkdWxlX3RpbWVvdXQrMHgxMjYvMHgxNmUKWyAgICA0LjI3MDAxNF0g
IFs8NzkwMzZiZGE+XSA/IGNhc2NhZGUrMHg1YS8weDVhClsgICAgNC4yNzAwMTRdICBbPDc5
MDdiNjBhPl0gcmN1X2dwX2t0aHJlYWQrMHgyOTkvMHg0NjcKWyAgICA0LjI3MDAxNF0gIFs8
NzkwNDVhMWM+XSA/IGFib3J0X2V4Y2x1c2l2ZV93YWl0KzB4NjMvMHg2MwpbICAgIDQuMjcw
MDE0XSAgWzw3OTA3YjM3MT5dID8gcmN1X2dwX2ZxcysweDUzLzB4NTMKWyAgICA0LjI3MDAx
NF0gIFs8NzkwNDUyNzY+XSBrdGhyZWFkKzB4OTUvMHg5YQpbICAgIDQuMjcwMDE0XSAgWzw3
OTA0MDAwMD5dID8gX19mbHVzaF93b3JrKzB4MTAxLzB4MWUyClsgICAgNC4yNzAwMTRdICBb
PDc5MjEwOTNiPl0gcmV0X2Zyb21fa2VybmVsX3RocmVhZCsweDFiLzB4MzAKWyAgICA0LjI3
MDAxNF0gIFs8NzkwNDUxZTE+XSA/IGt0aHJlYWRfc3RvcCsweDRlLzB4NGUKWyAgICA0LjI3
MDAxNF0gLS0tWyBlbmQgdHJhY2UgNDI2N2MyMTgzMThkZmE4MCBdLS0tCi9rZXJuZWwvaTM4
Ni1yYW5kY29uZmlnLWkwMDItMDkxMi9mNzRhMjc0YzhiMGIwYTM4MzdkNTcwNmQxYjdiZDFk
MTIwYTIyNmJiL2RtZXNnLXF1YW50YWwtYmF5LTE6MjAxMzA5MTUxNDI3MDk6My4xMS4wLTAy
NTYzLWdmNzRhMjc0OjE4OAova2VybmVsL2kzODYtcmFuZGNvbmZpZy1pMDAyLTA5MTIvZjc0
YTI3NGM4YjBiMGEzODM3ZDU3MDZkMWI3YmQxZDEyMGEyMjZiYi9kbWVzZy1xdWFudGFsLWJh
eS0xOjIwMTMwOTE2MTcwNDE3OjMuMTEuMC0wMjU2My1nZjc0YTI3NDoxODgKL2tlcm5lbC9p
Mzg2LXJhbmRjb25maWctaTAwMi0wOTEyL2Y3NGEyNzRjOGIwYjBhMzgzN2Q1NzA2ZDFiN2Jk
MWQxMjBhMjI2YmIvZG1lc2ctcXVhbnRhbC1iYXktNDoyMDEzMDkxNjE3MDQxMzozLjExLjAt
bmV4dC0yMDEzMDkxNi0xMTI5NS1nNjc0NmY3NzoxMTUKL2tlcm5lbC9pMzg2LXJhbmRjb25m
aWctaTAwMi0wOTEyL2Y3NGEyNzRjOGIwYjBhMzgzN2Q1NzA2ZDFiN2JkMWQxMjBhMjI2YmIv
ZG1lc2ctcXVhbnRhbC1iZW5zLTE6MjAxMzA5MTUxMjU2MzY6My4xMS4wLTAyNTYzLWdmNzRh
Mjc0OjE4OAova2VybmVsL2kzODYtcmFuZGNvbmZpZy1pMDAyLTA5MTIvZjc0YTI3NGM4YjBi
MGEzODM3ZDU3MDZkMWI3YmQxZDEyMGEyMjZiYi9kbWVzZy1xdWFudGFsLWJlbnMtMToyMDEz
MDkxNjE3MDQ1NTozLjExLjAtMTAxMzAtZ2Q4ZWZkODI6NjgKL2tlcm5lbC9pMzg2LXJhbmRj
b25maWctaTAwMi0wOTEyL2Y3NGEyNzRjOGIwYjBhMzgzN2Q1NzA2ZDFiN2JkMWQxMjBhMjI2
YmIvZG1lc2ctcXVhbnRhbC1iZW5zLTM6MjAxMzA5MTUxMjQ2MTg6My4xMS4wLTAyNTYzLWdm
NzRhMjc0OjE4OAova2VybmVsL2kzODYtcmFuZGNvbmZpZy1pMDAyLTA5MTIvZjc0YTI3NGM4
YjBiMGEzODM3ZDU3MDZkMWI3YmQxZDEyMGEyMjZiYi9kbWVzZy1xdWFudGFsLWJlbnMtMzoy
MDEzMDkxNjE3MTIzNjozLjExLjAtMDI1NjMtZ2Y3NGEyNzQ6MTg4Ci9rZXJuZWwvaTM4Ni1y
YW5kY29uZmlnLWkwMDItMDkxMi9mNzRhMjc0YzhiMGIwYTM4MzdkNTcwNmQxYjdiZDFkMTIw
YTIyNmJiL2RtZXNnLXF1YW50YWwtbGtwLXN0MDEtNToyMDEzMDkxNDE0MDc0MDozLjExLjAt
MDI1NjMtZ2Y3NGEyNzQ6MTg4Ci9rZXJuZWwvaTM4Ni1yYW5kY29uZmlnLWkwMDItMDkxMi9m
NzRhMjc0YzhiMGIwYTM4MzdkNTcwNmQxYjdiZDFkMTIwYTIyNmJiL2RtZXNnLXF1YW50YWwt
bGtwLXN0MDEtNToyMDEzMDkxNTEwNDQ0MjozLjExLjAtMDI1NjMtZ2Y3NGEyNzQ6MTg4Ci9r
ZXJuZWwvaTM4Ni1yYW5kY29uZmlnLWkwMDItMDkxMi9mNzRhMjc0YzhiMGIwYTM4MzdkNTcw
NmQxYjdiZDFkMTIwYTIyNmJiL2RtZXNnLXF1YW50YWwtbGtwLXN0MDEtNToyMDEzMDkxNjE3
MTE1ODozLjExLjAtMDI1NjMtZ2Y3NGEyNzQ6MTg4Ci9rZXJuZWwvaTM4Ni1yYW5kY29uZmln
LWkwMDItMDkxMi9mNzRhMjc0YzhiMGIwYTM4MzdkNTcwNmQxYjdiZDFkMTIwYTIyNmJiL2Rt
ZXNnLXF1YW50YWwtbGtwLXN0MDEtNjoyMDEzMDkxNjE3MDQ0MDozLjExLjAtMDI1NjMtZ2Y3
NGEyNzQ6MTg4Ci9rZXJuZWwvaTM4Ni1yYW5kY29uZmlnLWkwMDItMDkxMi9mNzRhMjc0Yzhi
MGIwYTM4MzdkNTcwNmQxYjdiZDFkMTIwYTIyNmJiL2RtZXNnLXF1YW50YWwtbGtwLXN0MDEt
NzoyMDEzMDkxNTExNTIyNzozLjExLjAtMDI1NjMtZ2Y3NGEyNzQ6MTg4Ci9rZXJuZWwvaTM4
Ni1yYW5kY29uZmlnLWkwMDItMDkxMi9mNzRhMjc0YzhiMGIwYTM4MzdkNTcwNmQxYjdiZDFk
MTIwYTIyNmJiL2RtZXNnLXF1YW50YWwtbGtwLXR0MDItMTQ6MjAxMzA5MTYwNzIzMDU6My4x
MS4wLTA5OTkyLWc1YTdkOGEyOjgKL2tlcm5lbC9pMzg2LXJhbmRjb25maWctaTAwMi0wOTEy
L2Y3NGEyNzRjOGIwYjBhMzgzN2Q1NzA2ZDFiN2JkMWQxMjBhMjI2YmIvZG1lc2ctcXVhbnRh
bC1sa3AtdHQwMi0xNjoyMDEzMDkxNjA3MjMzNzozLjExLjAtbmV4dC0yMDEzMDkxNi0xMTI5
NS1nNjc0NmY3NzoxMTUKL2tlcm5lbC9pMzg2LXJhbmRjb25maWctaTAwMi0wOTEyL2Y3NGEy
NzRjOGIwYjBhMzgzN2Q1NzA2ZDFiN2JkMWQxMjBhMjI2YmIvZG1lc2ctcXVhbnRhbC1sa3At
dHQwMi0xOjIwMTMwOTE2MDcyMzM1OjMuMTEuMDoxMDYKL2tlcm5lbC9pMzg2LXJhbmRjb25m
aWctaTAwMi0wOTEyL2Y3NGEyNzRjOGIwYjBhMzgzN2Q1NzA2ZDFiN2JkMWQxMjBhMjI2YmIv
ZG1lc2ctcXVhbnRhbC1sa3AtdHQwMi0zOjIwMTMwOTE2MDcyMzE5OjMuMTEuMC1uZXh0LTIw
MTMwOTE2LTExMjg3LWdiZWYzYzI2OjExMQova2VybmVsL2kzODYtcmFuZGNvbmZpZy1pMDAy
LTA5MTIvZjc0YTI3NGM4YjBiMGEzODM3ZDU3MDZkMWI3YmQxZDEyMGEyMjZiYi9kbWVzZy1x
dWFudGFsLWxrcC10dDAyLTQ6MjAxMzA5MTYwNzIzNDM6My4xMS4wLW5leHQtMjAxMzA5MTYt
MTEyODctZ2QxMjM2ODg6MTUyCi9rZXJuZWwvaTM4Ni1yYW5kY29uZmlnLWkwMDItMDkxMi9m
NzRhMjc0YzhiMGIwYTM4MzdkNTcwNmQxYjdiZDFkMTIwYTIyNmJiL2RtZXNnLXF1YW50YWwt
bGtwLXR0MDItNDoyMDEzMDkxNjA3MzE1MzozLjExLjAtMDI1NjMtZ2Y3NGEyNzQ6MTg4Ci9r
ZXJuZWwvaTM4Ni1yYW5kY29uZmlnLWkwMDItMDkxMi9mNzRhMjc0YzhiMGIwYTM4MzdkNTcw
NmQxYjdiZDFkMTIwYTIyNmJiL2RtZXNnLXF1YW50YWwtbGtwLXR0MDItNToyMDEzMDkxNjA3
MjI1NzozLjExLjAtMDI1NjMtZ2Y3NGEyNzQ6MTg4Ci9rZXJuZWwvaTM4Ni1yYW5kY29uZmln
LWkwMDItMDkxMi9mNzRhMjc0YzhiMGIwYTM4MzdkNTcwNmQxYjdiZDFkMTIwYTIyNmJiL2Rt
ZXNnLXF1YW50YWwtbGtwLXR0MDItODoyMDEzMDkxNjA3MjM0NjozLjExLjAtbmV4dC0yMDEz
MDkxNi0xMTMwOC1nMDE3MzZmYTo1NAova2VybmVsL2kzODYtcmFuZGNvbmZpZy1pMDAyLTA5
MTIvZjc0YTI3NGM4YjBiMGEzODM3ZDU3MDZkMWI3YmQxZDEyMGEyMjZiYi9kbWVzZy1xdWFu
dGFsLXJvYW0tMjY6MjAxMzA5MTUxNDI1NDA6My4xMS4wLTAyNTYzLWdmNzRhMjc0OjE4OAov
a2VybmVsL2kzODYtcmFuZGNvbmZpZy1pMDAyLTA5MTIvZjc0YTI3NGM4YjBiMGEzODM3ZDU3
MDZkMWI3YmQxZDEyMGEyMjZiYi9kbWVzZy1xdWFudGFsLXN0b2FrbGV5LTM6MjAxMzA5MTUx
NDI0Mzg6My4xMS4wLTAyNTYzLWdmNzRhMjc0OjE4OAova2VybmVsL2kzODYtcmFuZGNvbmZp
Zy1pMDAyLTA5MTIvZjc0YTI3NGM4YjBiMGEzODM3ZDU3MDZkMWI3YmQxZDEyMGEyMjZiYi9k
bWVzZy1xdWFudGFsLXN0b2FrbGV5LTg6MjAxMzA5MTUwOTMwNDE6My4xMS4wLTAyNTYzLWdm
NzRhMjc0OjE4OAova2VybmVsL2kzODYtcmFuZGNvbmZpZy1pMDAyLTA5MTIvZjc0YTI3NGM4
YjBiMGEzODM3ZDU3MDZkMWI3YmQxZDEyMGEyMjZiYi9kbWVzZy1xdWFudGFsLXhpYW4tMTE6
MjAxMzA5MTUxNDI1Mjg6My4xMS4wLTAyNTYzLWdmNzRhMjc0OjE4OAova2VybmVsL2kzODYt
cmFuZGNvbmZpZy1pMDAyLTA5MTIvZjc0YTI3NGM4YjBiMGEzODM3ZDU3MDZkMWI3YmQxZDEy
MGEyMjZiYi9kbWVzZy1xdWFudGFsLXhpYW4tMTY6MjAxMzA5MTYxNzA0MTg6My4xMS4wLTAy
NjA3LWdkZWQ1MzczOjExOQova2VybmVsL2kzODYtcmFuZGNvbmZpZy1pMDAyLTA5MTIvZjc0
YTI3NGM4YjBiMGEzODM3ZDU3MDZkMWI3YmQxZDEyMGEyMjZiYi9kbWVzZy1xdWFudGFsLXhp
YW4tMjU6MjAxMzA5MTYxNzA1MDY6My4xMS4wLTAyNTkwLWdjN2MyMjc2OjEwNQova2VybmVs
L2kzODYtcmFuZGNvbmZpZy1pMDAyLTA5MTIvZjc0YTI3NGM4YjBiMGEzODM3ZDU3MDZkMWI3
YmQxZDEyMGEyMjZiYi9kbWVzZy1xdWFudGFsLXhpYW4tMjoyMDEzMDkxNjE3MDQyMDozLjEx
LjAtMDI3MTUtZzBkOGVmMDg6NjgKL2tlcm5lbC9pMzg2LXJhbmRjb25maWctaTAwMi0wOTEy
L2Y3NGEyNzRjOGIwYjBhMzgzN2Q1NzA2ZDFiN2JkMWQxMjBhMjI2YmIvZG1lc2cteW9jdG8t
YmVucy0zOjIwMTMwOTE2MTcwNDMyOjMuMTEuMC0wMjU2My1nZjc0YTI3NDoxODgKL2tlcm5l
bC9pMzg2LXJhbmRjb25maWctaTAwMi0wOTEyL2Y3NGEyNzRjOGIwYjBhMzgzN2Q1NzA2ZDFi
N2JkMWQxMjBhMjI2YmIvZG1lc2cteW9jdG8tYmVucy00OjIwMTMwOTE1MDg1MjU5OjMuMTEu
MC0wMjU2My1nZjc0YTI3NDoxODgKL2tlcm5lbC9pMzg2LXJhbmRjb25maWctaTAwMi0wOTEy
L2Y3NGEyNzRjOGIwYjBhMzgzN2Q1NzA2ZDFiN2JkMWQxMjBhMjI2YmIvZG1lc2cteW9jdG8t
bGtwLXN0MDEtODoyMDEzMDkxNTA4MzgyMjozLjExLjAtMDI1NjMtZ2Y3NGEyNzQ6MTg4Ci9r
ZXJuZWwvaTM4Ni1yYW5kY29uZmlnLWkwMDItMDkxMi9mNzRhMjc0YzhiMGIwYTM4MzdkNTcw
NmQxYjdiZDFkMTIwYTIyNmJiL2RtZXNnLXlvY3RvLXJvYW0tMTA6MjAxMzA5MTUxNDIwNTM6
My4xMS4wLTAyNTYzLWdmNzRhMjc0OjE4OAova2VybmVsL2kzODYtcmFuZGNvbmZpZy1pMDAy
LTA5MTIvZjc0YTI3NGM4YjBiMGEzODM3ZDU3MDZkMWI3YmQxZDEyMGEyMjZiYi9kbWVzZy15
b2N0by1yb2FtLTMyOjIwMTMwOTE1MDkwNTE5OjMuMTEuMC0wMjU2My1nZjc0YTI3NDoxODgK
L2tlcm5lbC9pMzg2LXJhbmRjb25maWctaTAwMi0wOTEyL2Y3NGEyNzRjOGIwYjBhMzgzN2Q1
NzA2ZDFiN2JkMWQxMjBhMjI2YmIvZG1lc2cteW9jdG8tc3RvYWtsZXktNzoyMDEzMDkxNjE3
MDQ0NjozLjExLjAtMDI1NjMtZ2Y3NGEyNzQ6MTg4Ci9rZXJuZWwvaTM4Ni1yYW5kY29uZmln
LWkwMDItMDkxMi9mNzRhMjc0YzhiMGIwYTM4MzdkNTcwNmQxYjdiZDFkMTIwYTIyNmJiL2Rt
ZXNnLXlvY3RvLXhpYW4tMjc6MjAxMzA5MTYxNzEzMTE6My4xMS4wLTAyNTk5LWc0ZDlhODdj
OjExMgoKYmlzZWN0OiBiYWQgY29tbWl0IGY3NGEyNzRjOGIwYjBhMzgzN2Q1NzA2ZDFiN2Jk
MWQxMjBhMjI2YmIKZ2l0IGNoZWNrb3V0IHYzLjExClByZXZpb3VzIEhFQUQgcG9zaXRpb24g
d2FzIGY3NGEyNzQuLi4gTWVyZ2UgYnJhbmNoICdwbS1jcHVmcmVxLW5leHQnIGludG8gbGlu
dXgtbmV4dApIRUFEIGlzIG5vdyBhdCA2ZTQ2NjQ1Li4uIExpbnV4IDMuMTEKbHMgLWEgL2tl
cm5lbC10ZXN0cy9ydW4tcXVldWUva3ZtL2kzODYtcmFuZGNvbmZpZy1pMDAyLTA5MTIvdmly
ZXNoazpmb3ItdjMuMTM6NmU0NjY0NTI1YjFkYjI4ZjhjNGUxMTMwOTU3ZjcwYTk0YzE5MjEz
ZTpiaXNlY3QtZHJtCiBTVUNDRVNTCgpiaXNlY3Q6IGdvb2QgY29tbWl0IHYzLjExCmdpdCBi
aXNlY3Qgc3RhcnQgZjc0YTI3NGM4YjBiMGEzODM3ZDU3MDZkMWI3YmQxZDEyMGEyMjZiYiB2
My4xMSAtLQpQcmV2aW91cyBIRUFEIHBvc2l0aW9uIHdhcyA2ZTQ2NjQ1Li4uIExpbnV4IDMu
MTEKSEVBRCBpcyBub3cgYXQgYzFiZTVhNS4uLiBMaW51eCAzLjkKQmlzZWN0aW5nOiAxNjE1
IHJldmlzaW9ucyBsZWZ0IHRvIHRlc3QgYWZ0ZXIgdGhpcyAocm91Z2hseSAxMCBzdGVwcykK
WzkxMTIxYzEwM2FlOTNlZjExN2U1ODcxMjc4Njg2NDI3MGQ3ZjQ4OGVdIHN0YWdpbmc6IGR3
YzI6IG1ha2UgZHdjMl9jb3JlX3BhcmFtcyBkb2N1bWVudGF0aW9uIG1vcmUgY29tcGxldGUK
Z2l0IGJpc2VjdCBydW4gL2Mva2VybmVsLXRlc3RzL2Jpc2VjdC10ZXN0LWJvb3QtZmFpbHVy
ZS5zaCAvaG9tZS93ZmcvZHJtL29iai1iaXNlY3QKcnVubmluZyAvYy9rZXJuZWwtdGVzdHMv
YmlzZWN0LXRlc3QtYm9vdC1mYWlsdXJlLnNoIC9ob21lL3dmZy9kcm0vb2JqLWJpc2VjdAps
cyAtYSAva2VybmVsLXRlc3RzL3J1bi1xdWV1ZS9rdm0vaTM4Ni1yYW5kY29uZmlnLWkwMDIt
MDkxMi92aXJlc2hrOmZvci12My4xMzo5MTEyMWMxMDNhZTkzZWYxMTdlNTg3MTI3ODY4NjQy
NzBkN2Y0ODhlOmJpc2VjdC1kcm0KCjIwMTMtMDktMTYtMTc6MTQ6MjggOTExMjFjMTAzYWU5
M2VmMTE3ZTU4NzEyNzg2ODY0MjcwZDdmNDg4ZSBjb21waWxpbmcKMjk4NSByZWFsICAxNjE3
IHVzZXIgIDMyMiBzeXMgIDY0Ljk3JSBjcHUgCWkzODYtcmFuZGNvbmZpZy1pMDAyLTA5MTIK
CjIwMTMtMDktMTYtMTg6MTg6MTIgZGV0ZWN0aW5nIGJvb3Qgc3RhdGUgMy4xMS4wLXJjNS0w
MDk0Ny1nOTExMjFjMQkxLi4JMwk2LgkxMAkxNAkxNwkxOAkyNwkzMS4JMzgJNDMJNDYJNDgJ
NTIJNTcJNTkuCTYyCTY2CTcyCTc3CTc4CTc5CTgxCTg1Lgk4Nwk4OAk5MwkxMDAJMTAyCTEw
NQkxMDgJMTEwLgkxMTQJMTE1CTExNwkxMTkJMTIwCTEyNAkxMjUJMTI4CTEzMAkxMzIuCTEz
NQkxMzcuCTEzOAkxMzkJMTQwCTE0MQkxNDMJMTQ0LgkxNDcuCTE1MC4JMTUzLi4uCTE1NC4u
CTE1NQkxNTYJMTU5LgkxNjIuLi4JMTYzLi4uLgkxNjQuLi4JMTY2Li4JMTY3Li4JMTY4Li4u
CTE3MC4uLi4uLgkxNzEuCTE3MgkxNzMJMTc1Li4uLgkxNzYuLi4uLi4JMTc3CTE3OC4JMTc5
Li4uLi4JMTgyCTE4NQkxODYuCTE4NwkxODgJMTkwCTE5MS4JMTk1CTE5Ni4JMTk5CTIwMAky
MDEuCTIwMwkyMDQuLgkyMDUuLi4uCTIwNi4uCTIwNwkyMDgJMjA5LgkyMTAJMjExLi4uLgky
MTIuLi4uLgkyMTQJMjE1Li4JMjE2CTIxOC4uCTIyMAkyMjQuCTIyNS4uCTIyOC4uCTIyOS4J
MjMwCTIzMS4uLgkyMzIJMjMzLi4JMjM1CTIzNwkyMzguLgkyMzkJMjQwCTI0MQkyNDIJMjQ0
CTI0NS4uCTI0Ny4JMjQ4CTI0OS4JMjUxLi4uCTI1MgkyNTMJMjU0LgkyNTUuLi4uLi4uCTI1
Ni4uCTI1NwkyNTguCTI1OS4JMjYxLgkyNjIuCTI2MwkyNjQJMjY2Li4uCTI2OC4uCTI3MC4u
Li4uLi4uCTI3MS4JMjcyCTI3My4uLi4uLgkyNzQJMjc1LgkyNzYuLi4uCTI3Ny4JMjc4CTI4
MAkyODEJMjgyLgkyODMuLi4JMjg1LgkyODYuLi4uCTI4NwkyODguLi4JMjg5LgkyOTEuCTI5
Mi4uCTI5My4uCTI5NC4JMjk1Li4uLi4uCTI5Ni4uLgkyOTcuLi4uLi4uLgkyOTkuLi4uCTMw
MC4uLi4JMzAyLgkzMDMuLgkzMDQuLgkzMDUuLi4JMzA3CTMwOC4JMzExLgkzMTIuLi4JMzEz
LgkzMTQJMzE1CTMxNi4uCTMxOC4JMzE5CTMyMAkzMjMuLi4uCTMyNC4uLi4uLi4uCTMyNS4J
MzI2CTMyNwkzMjkuCTMzMC4JMzMxCTMzMgkzMzMuCTMzNC4uLi4uLgkzMzYJMzM3CTMzOAkz
MzkuLgkzNDQJMzQ2CTM0OAkzNDkJMzUwLgkzNTMJMzU0CTM1NQkzNTcuLgkzNTkJMzYyLgkz
NjQuLgkzNjUJMzY3Li4uCTM2OC4JMzY5CTM3MAkzNzIJMzc0CTM3NS4uLi4uCTM3NgkzNzcJ
MzgwCTM4Mi4JMzgzLi4JMzg0CTM4NwkzODguLgkzODkJMzkwCTM5MgkzOTMJMzk1Li4uCTM5
NgkzOTcJMzk5Li4JNDAwLgk0MDEuLi4JNDAyLgk0MDMJNDA1CTQwNy4uCTQwOC4uLi4JNDA5
CTQxMC4JNDExLi4JNDEzLgk0MTQJNDE1Lgk0MTYuCTQxNy4uCTQxOS4JNDIwIFNVQ0NFU1MK
CkJpc2VjdGluZzogODMzIHJldmlzaW9ucyBsZWZ0IHRvIHRlc3QgYWZ0ZXIgdGhpcyAocm91
Z2hseSAxMCBzdGVwcykKWzFkMWZkZDk1ZGY2ODFmMGMwNjVkOTBmZmFhZmEyMTVhMGU4ODI1
ZTJdIE1lcmdlIHRhZyAnY2hhci1taXNjLTMuMTItcmMxJyBvZiBnaXQ6Ly9naXQua2VybmVs
Lm9yZy9wdWIvc2NtL2xpbnV4L2tlcm5lbC9naXQvZ3JlZ2toL2NoYXItbWlzYwpydW5uaW5n
IC9jL2tlcm5lbC10ZXN0cy9iaXNlY3QtdGVzdC1ib290LWZhaWx1cmUuc2ggL2hvbWUvd2Zn
L2RybS9vYmotYmlzZWN0CmxzIC1hIC9rZXJuZWwtdGVzdHMvcnVuLXF1ZXVlL2t2bS9pMzg2
LXJhbmRjb25maWctaTAwMi0wOTEyL3ZpcmVzaGs6Zm9yLXYzLjEzOjFkMWZkZDk1ZGY2ODFm
MGMwNjVkOTBmZmFhZmEyMTVhMGU4ODI1ZTI6YmlzZWN0LWRybQoKMjAxMy0wOS0xNi0yMjoz
ODowMSAxZDFmZGQ5NWRmNjgxZjBjMDY1ZDkwZmZhYWZhMjE1YTBlODgyNWUyIGNvbXBpbGlu
Zwo1NDUgcmVhbCAgMTY4MiB1c2VyICAzNjQgc3lzICAzNzUuMzAlIGNwdSAJaTM4Ni1yYW5k
Y29uZmlnLWkwMDItMDkxMgoKMjAxMy0wOS0xNi0yMjo0ODowNiBkZXRlY3RpbmcgYm9vdCBz
dGF0ZSAzLjExLjAtMDA3ODItZzFkMWZkZDkuLi4uCTEuLgkyCTMuCTQJNi4JNy4uLgk4CTku
CTEwLi4JMTEuLgkxMwkxNC4uLgkxNS4uLgkxNy4uLi4uLi4uLi4uLi4uLgkxOS4uLi4uLi4u
CTIwLi4uLi4uLi4JMjEJMjIuLi4uLgkyMy4JMjUuLi4uLgkyNi4uLi4JMjcJMjguLi4JMzAJ
MzEuCTMyLi4JMzMuCTM0Li4uLi4JMzUuLi4uLi4JMzgJMzkuCTQyCTQ3Li4JNTIJNTMJNTQJ
NTUJNTYJNTkuCTYyCTY0Lgk2Nwk2OS4JNzUuCTc2CTc3CTc4CTgxCTgyCTg0CTg2Li4uLi4u
Li4uLgk5MAkxMDIJMTAzLgkxMDQuLgkxMDUuCTEwNgkxMDguCTExMC4uCTExMgkxMTYJMTE3
CTExOQkxMjAJMTIyCTEyMwkxMjQJMTI1Li4JMTI2LgkxMjguCTEyOS4JMTMxCTEzMi4uCTEz
MwkxMzQuCTEzNgkxMzcJMTM4Li4uCTE0MAkxNDIJMTQzLgkxNDUJMTQ4Li4JMTQ5CTE1MC4J
MTUyCTE1NQkxNTYJMTU4CTE1OS4JMTYyCTE2MwkxNjUJMTY2LgkxNjcuLi4uCTE2OC4JMTcw
CTE3MgkxNzQJMTc1CTE3NgkxNzkJMTg0LgkxODUJMTg2CTE4OC4uCTE4OQkxOTEJMTkyCTE5
NAkxOTgJMTk5CTIwMQkyMDQJMjA4CTIxMAkyMTIJMjE0CTIxOQkyMjEJMjI2CTIyNwkyMjkJ
MjMxCTIzMi4JMjM3CTIzOQkyNDAJMjQyCTI0NQkyNTAJMjUxCTI1MgkyNTMJMjU3CTI1OC4J
MjYzCTI2NwkyNjkJMjcwCTI3MgkyNzUJMjc3CTI4MQkyODQJMjg2CTI4OAkyODkJMjkwCTI5
MQkyOTQuCTI5NgkyOTcJMjk4CTMwMQkzMDIJMzAzCTMwNQkzMDYJMzA3LgkzMDgJMzA5Li4J
MzEwCTMxMQkzMTIuLi4uLgkzMTMuLi4JMzE0CTMxNS4uCTMxNy4JMzE4LgkzMTkuLgkzMjIu
CTMyNC4JMzI3LgkzMjgJMzMyCTMzNgkzMzgJMzM5CTM0MC4JMzQyCTM0NAkzNDcJMzUxCTM1
MwkzNTQJMzU3LgkzNTgJMzU5CTM2NAkzNzAJMzcyCTM3MwkzNzUJMzc5CTM4MS4JMzgyCTM4
OAkzOTMJMzk1CTM5NwkzOTgJNDAyCTQwMwk0MDQJNDA3CTQwOQk0MTEJNDEyCTQxMy4JNDE1
CTQxOAk0MTkuLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4u
Li4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4u
Li4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4u
Li4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4u
Li4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4u
Li4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uG1sxOzM1bWFkZF90b19y
dW5fcXVldWUgMRtbMG0KLgk0MjAgU1VDQ0VTUwoKQmlzZWN0aW5nOiAzNjIgcmV2aXNpb25z
IGxlZnQgdG8gdGVzdCBhZnRlciB0aGlzIChyb3VnaGx5IDkgc3RlcHMpCltmNjZjODNkMDU5
ZDFlZDkwOTY4Y2FhODFkNDAxZjE2MDkxMmIwNjNhXSBNZXJnZSB0YWcgJ3Njc2ktbWlzYycg
b2YgZ2l0Oi8vZ2l0Lmtlcm5lbC5vcmcvcHViL3NjbS9saW51eC9rZXJuZWwvZ2l0L2plamIv
c2NzaQpydW5uaW5nIC9jL2tlcm5lbC10ZXN0cy9iaXNlY3QtdGVzdC1ib290LWZhaWx1cmUu
c2ggL2hvbWUvd2ZnL2RybS9vYmotYmlzZWN0CmxzIC1hIC9rZXJuZWwtdGVzdHMvcnVuLXF1
ZXVlL2t2bS9pMzg2LXJhbmRjb25maWctaTAwMi0wOTEyL3ZpcmVzaGs6Zm9yLXYzLjEzOmY2
NmM4M2QwNTlkMWVkOTA5NjhjYWE4MWQ0MDFmMTYwOTEyYjA2M2E6YmlzZWN0LWRybQoKMjAx
My0wOS0xNy0wNDoyNzoyNCBmNjZjODNkMDU5ZDFlZDkwOTY4Y2FhODFkNDAxZjE2MDkxMmIw
NjNhIGNvbXBpbGluZwoyNTcgcmVhbCAgMTU1MSB1c2VyICAzMDYgc3lzICA3MjIuMTglIGNw
dSAJaTM4Ni1yYW5kY29uZmlnLWkwMDItMDkxMgoKMjAxMy0wOS0xNy0wNDozMjozMSBkZXRl
Y3RpbmcgYm9vdCBzdGF0ZSAzLjExLjAtMDIyMDAtZ2Y2NmM4M2QJMQkzIFRFU1QgRkFJTFVS
RQptb3VudGFsbDogRXZlbnQgZmFpbGVkClsgICAgNS44NDAxMThdIC0tLS0tLS0tLS0tLVsg
Y3V0IGhlcmUgXS0tLS0tLS0tLS0tLQpbICAgIDUuODQxMjYxXSBXQVJOSU5HOiBDUFU6IDEg
UElEOiA5IGF0IC9jL3dmZy9saW51eC1kcm0vbGliL2xpc3RfZGVidWcuYzozMyBfX2xpc3Rf
YWRkKzB4NmMvMHhhZSgpClsgICAgNS44NDMwNjhdIGxpc3RfYWRkIGNvcnJ1cHRpb24uIHBy
ZXYtPm5leHQgc2hvdWxkIGJlIG5leHQgKDc4MTAwMTAwKSwgYnV0IHdhcyAgIChudWxsKS4g
KHByZXY9NzgwOTE1NzApLgpbICAgIDUuODQ0OTUzXSBNb2R1bGVzIGxpbmtlZCBpbjoKWyAg
ICA1Ljg0NTU4Nl0gQ1BVOiAxIFBJRDogOSBDb21tOiByY3Vfc2NoZWQgTm90IHRhaW50ZWQg
My4xMS4wLTAyMjAwLWdmNjZjODNkICMxMjIKWyAgICA1Ljg0NzI0Nl0gIDAwMDAwMDAwIDAw
MDAwMDAwIDc4MDY3ZGY0IDc5MjA5YmYwIDc4MDY3ZTM0IDc4MDY3ZTI0IDc5MDMwODgzIDc5
MmVkOWM4ClsgICAgNS44NDkwMjJdICA3ODA2N2U1MCAwMDAwMDAwOSA3OTJlZDlhNiAwMDAw
MDAyMSA3OTEwNTM2NSA3OTEwNTM2NSA3ODA5MTU3MCA3ODEwMDEwMApbICAgIDUuODUwMDU3
XSAgNzgwNjdlYTAgNzgwNjdlM2MgNzkwMzA4YzggMDAwMDAwMDkgNzgwNjdlMzQgNzkyZWQ5
YzggNzgwNjdlNTAgNzgwNjdlNjgKWyAgICA1Ljg1MDA1N10gQ2FsbCBUcmFjZToKWyAgICA1
Ljg1MDA1N10gIFs8NzkyMDliZjA+XSBkdW1wX3N0YWNrKzB4NGIvMHg2NgpbICAgIDUuODUw
MDU3XSAgWzw3OTAzMDg4Mz5dIHdhcm5fc2xvd3BhdGhfY29tbW9uKzB4NzQvMHg4YgpbICAg
IDUuODUwMDU3XSAgWzw3OTEwNTM2NT5dID8gX19saXN0X2FkZCsweDZjLzB4YWUKWyAgICA1
Ljg1MDA1N10gIFs8NzkxMDUzNjU+XSA/IF9fbGlzdF9hZGQrMHg2Yy8weGFlClsgICAgNS44
NTAwNTddICBbPDc5MDMwOGM4Pl0gd2Fybl9zbG93cGF0aF9mbXQrMHgyZS8weDMwClsgICAg
NS44NTAwNTddICBbPDc5MTA1MzY1Pl0gX19saXN0X2FkZCsweDZjLzB4YWUKWyAgICA1Ljg1
MDA1N10gIFs8NzkwMzZiNjQ+XSBfX2ludGVybmFsX2FkZF90aW1lcisweDhhLzB4OGUKWyAg
ICA1Ljg1MDA1N10gIFs8NzkwMzZiNzY+XSBpbnRlcm5hbF9hZGRfdGltZXIrMHhlLzB4MjYK
WyAgICA1Ljg1MDA1N10gIFs8NzkyMGEzZjY+XSBzY2hlZHVsZV90aW1lb3V0KzB4MTI2LzB4
MTZlClsgICAgNS44NTAwNTddICBbPDc5MDM2YzMwPl0gPyBjYXNjYWRlKzB4NWEvMHg1YQpb
ICAgIDUuODUwMDU3XSAgWzw3OTA3YjY5Nz5dIHJjdV9ncF9rdGhyZWFkKzB4Mjk5LzB4NDY3
ClsgICAgNS44NTAwNTddICBbPDc5MDQ1YTcyPl0gPyBhYm9ydF9leGNsdXNpdmVfd2FpdCsw
eDYzLzB4NjMKWyAgICA1Ljg1MDA1N10gIFs8NzkwN2IzZmU+XSA/IHJjdV9ncF9mcXMrMHg1
My8weDUzClsgICAgNS44NTAwNTddICBbPDc5MDQ1MmNjPl0ga3RocmVhZCsweDk1LzB4OWEK
WyAgICA1Ljg1MDA1N10gIFs8NzkwNDAwMDA+XSA/IF9fZmx1c2hfd29yaysweGFiLzB4MWUy
ClsgICAgNS44NTAwNTddICBbPDc5MjBmMDdiPl0gcmV0X2Zyb21fa2VybmVsX3RocmVhZCsw
eDFiLzB4MzAKWyAgICA1Ljg1MDA1N10gIFs8NzkwNDUyMzc+XSA/IGt0aHJlYWRfc3RvcCsw
eDRlLzB4NGUKWyAgICA1Ljg1MDA1N10gLS0tWyBlbmQgdHJhY2UgMTQ2NWIxOGVmZDlmMzcw
NiBdLS0tCi9rZXJuZWwvaTM4Ni1yYW5kY29uZmlnLWkwMDItMDkxMi9mNjZjODNkMDU5ZDFl
ZDkwOTY4Y2FhODFkNDAxZjE2MDkxMmIwNjNhL2RtZXNnLXF1YW50YWwtbGtwLXR0MDItMjoy
MDEzMDkxNjE4NTIyMjozLjExLjAtMDIyMDAtZ2Y2NmM4M2Q6MTIyCgpCaXNlY3Rpbmc6IDI0
MiByZXZpc2lvbnMgbGVmdCB0byB0ZXN0IGFmdGVyIHRoaXMgKHJvdWdobHkgOCBzdGVwcykK
WzJkMWQzZjNhZTk4NWVjNTY3NmZiNTZmZjJjN2FjYWQyZTFjNGU2ZWJdIGh2Y194ZW46IFJl
bW92ZSB1bm5lY2Vzc2FyeSBfX0dGUF9aRVJPIGZyb20ga3phbGxvYwpydW5uaW5nIC9jL2tl
cm5lbC10ZXN0cy9iaXNlY3QtdGVzdC1ib290LWZhaWx1cmUuc2ggL2hvbWUvd2ZnL2RybS9v
YmotYmlzZWN0CmxzIC1hIC9rZXJuZWwtdGVzdHMvcnVuLXF1ZXVlL2t2bS9pMzg2LXJhbmRj
b25maWctaTAwMi0wOTEyL3ZpcmVzaGs6Zm9yLXYzLjEzOjJkMWQzZjNhZTk4NWVjNTY3NmZi
NTZmZjJjN2FjYWQyZTFjNGU2ZWI6YmlzZWN0LWRybQoKMjAxMy0wOS0xNy0wNDozMzozNSAy
ZDFkM2YzYWU5ODVlYzU2NzZmYjU2ZmYyYzdhY2FkMmUxYzRlNmViIGNvbXBpbGluZwoyNjQg
cmVhbCAgMTU1MyB1c2VyICAyOTMgc3lzICA2OTkuNTMlIGNwdSAJaTM4Ni1yYW5kY29uZmln
LWkwMDItMDkxMgoKMjAxMy0wOS0xNy0wNDozODo0NyBkZXRlY3RpbmcgYm9vdCBzdGF0ZSAz
LjExLjAtcmM0LTAwMjI4LWcyZDFkM2YzCTQJMTMJMzQJNzIJMTE3CTE4MAkyMjUJMjUyCTI4
OQkzNzMJNDEwCTQxNgk0MTkuCTQyMCBTVUNDRVNTCgpCaXNlY3Rpbmc6IDEyMSByZXZpc2lv
bnMgbGVmdCB0byB0ZXN0IGFmdGVyIHRoaXMgKHJvdWdobHkgNyBzdGVwcykKWzU0MmEwODZh
YzcyZmIxOTNjYmMxYjk5Njk2M2E1NzIyNjllNTc3NDNdIE1lcmdlIHRhZyAnZHJpdmVyLWNv
cmUtMy4xMi1yYzEnIG9mIGdpdDovL2dpdC5rZXJuZWwub3JnL3B1Yi9zY20vbGludXgva2Vy
bmVsL2dpdC9ncmVna2gvZHJpdmVyLWNvcmUKcnVubmluZyAvYy9rZXJuZWwtdGVzdHMvYmlz
ZWN0LXRlc3QtYm9vdC1mYWlsdXJlLnNoIC9ob21lL3dmZy9kcm0vb2JqLWJpc2VjdApscyAt
YSAva2VybmVsLXRlc3RzL3J1bi1xdWV1ZS9rdm0vaTM4Ni1yYW5kY29uZmlnLWkwMDItMDkx
Mi92aXJlc2hrOmZvci12My4xMzo1NDJhMDg2YWM3MmZiMTkzY2JjMWI5OTY5NjNhNTcyMjY5
ZTU3NzQzOmJpc2VjdC1kcm0KCjIwMTMtMDktMTctMDQ6NDY6MTkgNTQyYTA4NmFjNzJmYjE5
M2NiYzFiOTk2OTYzYTU3MjI2OWU1Nzc0MyBjb21waWxpbmcKMjI0IHJlYWwgIDE1NTUgdXNl
ciAgMzAyIHN5cyAgODI2Ljk0JSBjcHUgCWkzODYtcmFuZGNvbmZpZy1pMDAyLTA5MTIKCjIw
MTMtMDktMTctMDQ6NTA6NDggZGV0ZWN0aW5nIGJvb3Qgc3RhdGUgMy4xMS4wLTAwOTAzLWc1
NDJhMDg2CTEJNgkxMiBURVNUIEZBSUxVUkUKWyAgICAzLjk1MDE3MV0gdHNjOiBSZWZpbmVk
IFRTQyBjbG9ja3NvdXJjZSBjYWxpYnJhdGlvbjogMjY2Ni42MDEgTUh6ClsgICAgNC4xNTAw
NDldIC0tLS0tLS0tLS0tLVsgY3V0IGhlcmUgXS0tLS0tLS0tLS0tLQpbICAgIDQuMTUwODcw
XSBXQVJOSU5HOiBDUFU6IDEgUElEOiA5IGF0IC9jL3dmZy9saW51eC1kcm0vbGliL2xpc3Rf
ZGVidWcuYzozMyBfX2xpc3RfYWRkKzB4NmMvMHhhZSgpClsgICAgNC4xNTIyNjJdIGxpc3Rf
YWRkIGNvcnJ1cHRpb24uIHByZXYtPm5leHQgc2hvdWxkIGJlIG5leHQgKDc4MTAwM2IwKSwg
YnV0IHdhcyAwMGFiY2RlZi4gKHByZXY9NzgxOGUxNzApLgpbICAgIDQuMTUzNzY1XSBNb2R1
bGVzIGxpbmtlZCBpbjoKWyAgICA0LjE1NDI4Ml0gQ1BVOiAxIFBJRDogOSBDb21tOiByY3Vf
c2NoZWQgTm90IHRhaW50ZWQgMy4xMS4wLTAwOTAzLWc1NDJhMDg2ICMxMjQKWyAgICA0LjE1
NTQ0Nl0gIDAwMDAwMDAwIDAwMDAwMDAwIDc4MDY3ZGY0IDc5MjA5ZTAwIDc4MDY3ZTM0IDc4
MDY3ZTI0IDc5MDMwODgzIDc5MmVkOGM1ClsgICAgNC4xNTY4NDldICA3ODA2N2U1MCAwMDAw
MDAwOSA3OTJlZDhhMyAwMDAwMDAyMSA3OTEwNTMyNSA3OTEwNTMyNSA3ODE4ZTE3MCA3ODEw
MDNiMApbICAgIDQuMTU4MjQ2XSAgNzgwNjdlYTAgNzgwNjdlM2MgNzkwMzA4YzggMDAwMDAw
MDkgNzgwNjdlMzQgNzkyZWQ4YzUgNzgwNjdlNTAgNzgwNjdlNjgKWyAgICA0LjE1OTY1MF0g
Q2FsbCBUcmFjZToKWyAgICA0LjE2MDAxOF0gIFs8NzkyMDllMDA+XSBkdW1wX3N0YWNrKzB4
NGIvMHg2NgpbICAgIDQuMTYwMDE4XSAgWzw3OTAzMDg4Mz5dIHdhcm5fc2xvd3BhdGhfY29t
bW9uKzB4NzQvMHg4YgpbICAgIDQuMTYwMDE4XSAgWzw3OTEwNTMyNT5dID8gX19saXN0X2Fk
ZCsweDZjLzB4YWUKWyAgICA0LjE2MDAxOF0gIFs8NzkxMDUzMjU+XSA/IF9fbGlzdF9hZGQr
MHg2Yy8weGFlClsgICAgNC4xNjAwMThdICBbPDc5MDMwOGM4Pl0gd2Fybl9zbG93cGF0aF9m
bXQrMHgyZS8weDMwClsgICAgNC4xNjAwMThdICBbPDc5MTA1MzI1Pl0gX19saXN0X2FkZCsw
eDZjLzB4YWUKWyAgICA0LjE2MDAxOF0gIFs8NzkwMzZiNjQ+XSBfX2ludGVybmFsX2FkZF90
aW1lcisweDhhLzB4OGUKWyAgICA0LjE2MDAxOF0gIFs8NzkwMzZiNzY+XSBpbnRlcm5hbF9h
ZGRfdGltZXIrMHhlLzB4MjYKWyAgICA0LjE2MDAxOF0gIFs8NzkyMGE2MDY+XSBzY2hlZHVs
ZV90aW1lb3V0KzB4MTI2LzB4MTZlClsgICAgNC4xNjAwMThdICBbPDc5MDM2YzMwPl0gPyBj
YXNjYWRlKzB4NWEvMHg1YQpbICAgIDQuMTYwMDE4XSAgWzw3OTA3YjY1MD5dIHJjdV9ncF9r
dGhyZWFkKzB4Mjk5LzB4NDY3ClsgICAgNC4xNjAwMThdICBbPDc5MDQ1YTcyPl0gPyBhYm9y
dF9leGNsdXNpdmVfd2FpdCsweDYzLzB4NjMKWyAgICA0LjE2MDAxOF0gIFs8NzkwN2IzYjc+
XSA/IHJjdV9ncF9mcXMrMHg1My8weDUzClsgICAgNC4xNjAwMThdICBbPDc5MDQ1MmNjPl0g
a3RocmVhZCsweDk1LzB4OWEKWyAgICA0LjE2MDAxOF0gIFs8NzkwNDAwMDA+XSA/IF9fZmx1
c2hfd29yaysweGFiLzB4MWUyClsgICAgNC4xNjAwMThdICBbPDc5MjBmMTdiPl0gcmV0X2Zy
b21fa2VybmVsX3RocmVhZCsweDFiLzB4MzAKWyAgICA0LjE2MDAxOF0gIFs8NzkwNDUyMzc+
XSA/IGt0aHJlYWRfc3RvcCsweDRlLzB4NGUKWyAgICA0LjE2MDAxOF0gLS0tWyBlbmQgdHJh
Y2UgOGIxODY4YjM1ZDdkODc5ZCBdLS0tCi9rZXJuZWwvaTM4Ni1yYW5kY29uZmlnLWkwMDIt
MDkxMi81NDJhMDg2YWM3MmZiMTkzY2JjMWI5OTY5NjNhNTcyMjY5ZTU3NzQzL2RtZXNnLXF1
YW50YWwtYmVucy0yOjIwMTMwOTE3MDQ1MjA4OjMuMTEuMC0wMDkwMy1nNTQyYTA4NjoxMjQK
CkJpc2VjdGluZzogNjAgcmV2aXNpb25zIGxlZnQgdG8gdGVzdCBhZnRlciB0aGlzIChyb3Vn
aGx5IDYgc3RlcHMpCls4NzlmMWJlYzhlMTM2YzdiYzcxZTM4NzE1ZTYyYTczYjc1ZjkxZDc4
XSBkcml2ZXJzOiBiYXNlOiByZW1vdmUgdW5uZWVkZWQgdmFyaWFibGUKcnVubmluZyAvYy9r
ZXJuZWwtdGVzdHMvYmlzZWN0LXRlc3QtYm9vdC1mYWlsdXJlLnNoIC9ob21lL3dmZy9kcm0v
b2JqLWJpc2VjdApscyAtYSAva2VybmVsLXRlc3RzL3J1bi1xdWV1ZS9rdm0vaTM4Ni1yYW5k
Y29uZmlnLWkwMDItMDkxMi92aXJlc2hrOmZvci12My4xMzo4NzlmMWJlYzhlMTM2YzdiYzcx
ZTM4NzE1ZTYyYTczYjc1ZjkxZDc4OmJpc2VjdC1kcm0KCjIwMTMtMDktMTctMDQ6NTI6MjEg
ODc5ZjFiZWM4ZTEzNmM3YmM3MWUzODcxNWU2MmE3M2I3NWY5MWQ3OCBjb21waWxpbmcKMjMw
IHJlYWwgIDE1NDkgdXNlciAgMjk5IHN5cyAgODAxLjgyJSBjcHUgCWkzODYtcmFuZGNvbmZp
Zy1pMDAyLTA5MTIKCjIwMTMtMDktMTctMDQ6NTY6NTkgZGV0ZWN0aW5nIGJvb3Qgc3RhdGUg
My4xMS4wLXJjMy0wMDA2MC1nODc5ZjFiZQk0CTEzIFRFU1QgRkFJTFVSRQoKWyAgICA0LjQ2
MDA3Ml0gLS0tLS0tLS0tLS0tWyBjdXQgaGVyZSBdLS0tLS0tLS0tLS0tClsgICAgNC40NjEx
NzFdIFdBUk5JTkc6IENQVTogMSBQSUQ6IDkgYXQgL2Mvd2ZnL2xpbnV4LWRybS9saWIvbGlz
dF9kZWJ1Zy5jOjMzIF9fbGlzdF9hZGQrMHg2Yy8weGFlKCkKWyAgICA0LjQ2MjkwN10gbGlz
dF9hZGQgY29ycnVwdGlvbi4gcHJldi0+bmV4dCBzaG91bGQgYmUgbmV4dCAoNzgxMDA0YTgp
LCBidXQgd2FzIDc3ZmEwMzE4LiAocHJldj03ODA5MTU3MCkuClsgICAgNC40NjQ3NzJdIE1v
ZHVsZXMgbGlua2VkIGluOgpbICAgIDQuNDY1NDEwXSBDUFU6IDEgUElEOiA5IENvbW06IHJj
dV9zY2hlZCBOb3QgdGFpbnRlZCAzLjExLjAtcmMzLTAwMDYwLWc4NzlmMWJlICMxMjUKWyAg
ICA0LjQ2NjkzMl0gIDAwMDAwMDAwIDAwMDAwMDAwIDc4MDY3ZGY0IDc5MjA5ZDdiIDc4MDY3
ZTM0IDc4MDY3ZTI0IDc5MDMwODgzIDc5MmVkNDFmClsgICAgNC40Njg2NjZdICA3ODA2N2U1
MCAwMDAwMDAwOSA3OTJlZDNmZCAwMDAwMDAyMSA3OTEwNTMzZCA3OTEwNTMzZCA3ODA5MTU3
MCA3ODEwMDRhOApbICAgIDQuNDcwMDIxXSAgNzgwNjdlYTAgNzgwNjdlM2MgNzkwMzA4Yzgg
MDAwMDAwMDkgNzgwNjdlMzQgNzkyZWQ0MWYgNzgwNjdlNTAgNzgwNjdlNjgKWyAgICA0LjQ3
MDAyMV0gQ2FsbCBUcmFjZToKWyAgICA0LjQ3MDAyMV0gIFs8NzkyMDlkN2I+XSBkdW1wX3N0
YWNrKzB4NGIvMHg2NgpbICAgIDQuNDcwMDIxXSAgWzw3OTAzMDg4Mz5dIHdhcm5fc2xvd3Bh
dGhfY29tbW9uKzB4NzQvMHg4YgpbICAgIDQuNDcwMDIxXSAgWzw3OTEwNTMzZD5dID8gX19s
aXN0X2FkZCsweDZjLzB4YWUKWyAgICA0LjQ3MDAyMV0gIFs8NzkxMDUzM2Q+XSA/IF9fbGlz
dF9hZGQrMHg2Yy8weGFlClsgICAgNC40NzAwMjFdICBbPDc5MDMwOGM4Pl0gd2Fybl9zbG93
cGF0aF9mbXQrMHgyZS8weDMwClsgICAgNC40NzAwMjFdICBbPDc5MTA1MzNkPl0gX19saXN0
X2FkZCsweDZjLzB4YWUKWyAgICA0LjQ3MDAyMV0gIFs8NzkwMzk1N2M+XSBfX2ludGVybmFs
X2FkZF90aW1lcisweDhhLzB4OGUKWyAgICA0LjQ3MDAyMV0gIFs8NzkwMzk1OGU+XSBpbnRl
cm5hbF9hZGRfdGltZXIrMHhlLzB4MjYKWyAgICA0LjQ3MDAyMV0gIFs8NzkyMGE1YWE+XSBz
Y2hlZHVsZV90aW1lb3V0KzB4MTI2LzB4MTZlClsgICAgNC40NzAwMjFdICBbPDc5MDM5NjQ4
Pl0gPyBjYXNjYWRlKzB4NWEvMHg1YQpbICAgIDQuNDcwMDIxXSAgWzw3OTA3YjVmNz5dIHJj
dV9ncF9rdGhyZWFkKzB4Mjk5LzB4NDY3ClsgICAgNC40NzAwMjFdICBbPDc5MDQ4NDM0Pl0g
PyBhYm9ydF9leGNsdXNpdmVfd2FpdCsweDYzLzB4NjMKWyAgICA0LjQ3MDAyMV0gIFs8Nzkw
N2IzNWU+XSA/IHJjdV9ncF9mcXMrMHg1My8weDUzClsgICAgNC40NzAwMjFdICBbPDc5MDQ3
YzhlPl0ga3RocmVhZCsweDk1LzB4OWEKWyAgICA0LjQ3MDAyMV0gIFs8NzkwNDAwMDA+XSA/
IGdldHJ1c2FnZSsweDE5Mi8weDIyMApbICAgIDQuNDcwMDIxXSAgWzw3OTIwZjBmYj5dIHJl
dF9mcm9tX2tlcm5lbF90aHJlYWQrMHgxYi8weDMwClsgICAgNC40NzAwMjFdICBbPDc5MDQ3
YmY5Pl0gPyBrdGhyZWFkX3N0b3ArMHg0ZS8weDRlClsgICAgNC40NzAwMjFdIC0tLVsgZW5k
IHRyYWNlIDcyNDA5ZWY5NWUyMTI1MzEgXS0tLQova2VybmVsL2kzODYtcmFuZGNvbmZpZy1p
MDAyLTA5MTIvODc5ZjFiZWM4ZTEzNmM3YmM3MWUzODcxNWU2MmE3M2I3NWY5MWQ3OC9kbWVz
Zy1xdWFudGFsLWxrcC10dDAyLTM6MjAxMzA5MTYxOTE2MzM6My4xMS4wLXJjMy0wMDA2MC1n
ODc5ZjFiZToxMjUKL2tlcm5lbC9pMzg2LXJhbmRjb25maWctaTAwMi0wOTEyLzg3OWYxYmVj
OGUxMzZjN2JjNzFlMzg3MTVlNjJhNzNiNzVmOTFkNzgvZG1lc2ctcXVhbnRhbC1sa3AtdHQw
Mi04OjIwMTMwOTE2MTkxNjQzOjMuMTAuMC1yYzEtMDAwOTYtZzQzODQ5MmE6MjAKCkJpc2Vj
dGluZzogMjkgcmV2aXNpb25zIGxlZnQgdG8gdGVzdCBhZnRlciB0aGlzIChyb3VnaGx5IDUg
c3RlcHMpCltlNzBiMDkxNTEyNDk0MjIwNGRlYzgwNjRiYjI1NzU2ZTg3MjNiODFhXSB0aWxl
IC8gY3B1IHRvcG9sb2d5OiByZW1vdmUgc3RhbGUgTWFjcm8gYXJjaF9wcm92aWRlc190b3Bv
bG9neV9wb2ludGVycwpydW5uaW5nIC9jL2tlcm5lbC10ZXN0cy9iaXNlY3QtdGVzdC1ib290
LWZhaWx1cmUuc2ggL2hvbWUvd2ZnL2RybS9vYmotYmlzZWN0CmxzIC1hIC9rZXJuZWwtdGVz
dHMvcnVuLXF1ZXVlL2t2bS9pMzg2LXJhbmRjb25maWctaTAwMi0wOTEyL3ZpcmVzaGs6Zm9y
LXYzLjEzOmU3MGIwOTE1MTI0OTQyMjA0ZGVjODA2NGJiMjU3NTZlODcyM2I4MWE6YmlzZWN0
LWRybQoKMjAxMy0wOS0xNy0wNDo1ODowMSBlNzBiMDkxNTEyNDk0MjIwNGRlYzgwNjRiYjI1
NzU2ZTg3MjNiODFhIGNvbXBpbGluZwoyMjggcmVhbCAgMTQ5OSB1c2VyICAyOTEgc3lzICA3
ODMuMDclIGNwdSAJaTM4Ni1yYW5kY29uZmlnLWkwMDItMDkxMgoKMjAxMy0wOS0xNy0wNTow
MjozNCBkZXRlY3RpbmcgYm9vdCBzdGF0ZSAzLjExLjAtcmMzLTAwMDMwLWdlNzBiMDkxCTEJ
NyBURVNUIEZBSUxVUkUKWyAgICAzLjk1MDI2MF0gdHNjOiBSZWZpbmVkIFRTQyBjbG9ja3Nv
dXJjZSBjYWxpYnJhdGlvbjogMjY2Ni42MDQgTUh6ClsgICAgNC4xNDAyMjVdIC0tLS0tLS0t
LS0tLVsgY3V0IGhlcmUgXS0tLS0tLS0tLS0tLQpbICAgIDQuMTQxMDM2XSBXQVJOSU5HOiBD
UFU6IDEgUElEOiA5IGF0IC9jL3dmZy9saW51eC1kcm0vbGliL2xpc3RfZGVidWcuYzozMyBf
X2xpc3RfYWRkKzB4NmMvMHhhZSgpClsgICAgNC4xNDI0MjBdIGxpc3RfYWRkIGNvcnJ1cHRp
b24uIHByZXYtPm5leHQgc2hvdWxkIGJlIG5leHQgKDc4MTAwM2E4KSwgYnV0IHdhcyA3OTJk
ZmVmNS4gKHByZXY9NzgwOTBiNzApLgpbICAgIDQuMTQzODk5XSBNb2R1bGVzIGxpbmtlZCBp
bjoKWyAgICA0LjE0NDQxNl0gQ1BVOiAxIFBJRDogOSBDb21tOiByY3Vfc2NoZWQgTm90IHRh
aW50ZWQgMy4xMS4wLXJjMy0wMDAzMC1nZTcwYjA5MSAjMTI2ClsgICAgNC4xNDU2MjBdICAw
MDAwMDAwMCAwMDAwMDAwMCA3ODA2N2RmNCA3OTIwOWM1YiA3ODA2N2UzNCA3ODA2N2UyNCA3
OTAzMDg4MyA3OTJlZDMwZgpbICAgIDQuMTQ3MDA5XSAgNzgwNjdlNTAgMDAwMDAwMDkgNzky
ZWQyZWQgMDAwMDAwMjEgNzkxMDUzM2QgNzkxMDUzM2QgNzgwOTBiNzAgNzgxMDAzYTgKWyAg
ICA0LjE0ODQwNV0gIDc4MDY3ZWEwIDc4MDY3ZTNjIDc5MDMwOGM4IDAwMDAwMDA5IDc4MDY3
ZTM0IDc5MmVkMzBmIDc4MDY3ZTUwIDc4MDY3ZTY4ClsgICAgNC4xNDk3OTFdIENhbGwgVHJh
Y2U6ClsgICAgNC4xNTAwMjBdICBbPDc5MjA5YzViPl0gZHVtcF9zdGFjaysweDRiLzB4NjYK
WyAgICA0LjE1MDAyMF0gIFs8NzkwMzA4ODM+XSB3YXJuX3Nsb3dwYXRoX2NvbW1vbisweDc0
LzB4OGIKWyAgICA0LjE1MDAyMF0gIFs8NzkxMDUzM2Q+XSA/IF9fbGlzdF9hZGQrMHg2Yy8w
eGFlClsgICAgNC4xNTAwMjBdICBbPDc5MTA1MzNkPl0gPyBfX2xpc3RfYWRkKzB4NmMvMHhh
ZQpbICAgIDQuMTUwMDIwXSAgWzw3OTAzMDhjOD5dIHdhcm5fc2xvd3BhdGhfZm10KzB4MmUv
MHgzMApbICAgIDQuMTUwMDIwXSAgWzw3OTEwNTMzZD5dIF9fbGlzdF9hZGQrMHg2Yy8weGFl
ClsgICAgNC4xNTAwMjBdICBbPDc5MDM5NTdjPl0gX19pbnRlcm5hbF9hZGRfdGltZXIrMHg4
YS8weDhlClsgICAgNC4xNTAwMjBdICBbPDc5MDM5NThlPl0gaW50ZXJuYWxfYWRkX3RpbWVy
KzB4ZS8weDI2ClsgICAgNC4xNTAwMjBdICBbPDc5MjBhNDhhPl0gc2NoZWR1bGVfdGltZW91
dCsweDEyNi8weDE2ZQpbICAgIDQuMTUwMDIwXSAgWzw3OTAzOTY0OD5dID8gY2FzY2FkZSsw
eDVhLzB4NWEKWyAgICA0LjE1MDAyMF0gIFs8NzkwN2I1Zjc+XSByY3VfZ3Bfa3RocmVhZCsw
eDI5OS8weDQ2NwpbICAgIDQuMTUwMDIwXSAgWzw3OTA0ODQzND5dID8gYWJvcnRfZXhjbHVz
aXZlX3dhaXQrMHg2My8weDYzClsgICAgNC4xNTAwMjBdICBbPDc5MDdiMzVlPl0gPyByY3Vf
Z3BfZnFzKzB4NTMvMHg1MwpbICAgIDQuMTUwMDIwXSAgWzw3OTA0N2M4ZT5dIGt0aHJlYWQr
MHg5NS8weDlhClsgICAgNC4xNTAwMjBdICBbPDc5MDQwMDAwPl0gPyBnZXRydXNhZ2UrMHgx
OTIvMHgyMjAKWyAgICA0LjE1MDAyMF0gIFs8NzkyMGVmZmI+XSByZXRfZnJvbV9rZXJuZWxf
dGhyZWFkKzB4MWIvMHgzMApbICAgIDQuMTUwMDIwXSAgWzw3OTA0N2JmOT5dID8ga3RocmVh
ZF9zdG9wKzB4NGUvMHg0ZQpbICAgIDQuMTUwMDIwXSAtLS1bIGVuZCB0cmFjZSBmZTUyYjFh
YzYzM2UxMzUyIF0tLS0KL2tlcm5lbC9pMzg2LXJhbmRjb25maWctaTAwMi0wOTEyL2U3MGIw
OTE1MTI0OTQyMjA0ZGVjODA2NGJiMjU3NTZlODcyM2I4MWEvZG1lc2ctcXVhbnRhbC1iZW5z
LTI6MjAxMzA5MTcwNTAzMTk6My4xMS4wLXJjMy0wMDAzMC1nZTcwYjA5MToxMjYKCkJpc2Vj
dGluZzogMTQgcmV2aXNpb25zIGxlZnQgdG8gdGVzdCBhZnRlciB0aGlzIChyb3VnaGx5IDQg
c3RlcHMpCltkNzlmZDAzZmQ2NTFiZDkxYTA4MWZjOTdmNWYwZDIyMTU1N2Y4Y2JiXSB2aWRl
bzogYmFja2xpZ2h0OiBsY2Q6IGNvbnZlcnQgY2xhc3MgY29kZSB0byB1c2UgZGV2X2dyb3Vw
cwpydW5uaW5nIC9jL2tlcm5lbC10ZXN0cy9iaXNlY3QtdGVzdC1ib290LWZhaWx1cmUuc2gg
L2hvbWUvd2ZnL2RybS9vYmotYmlzZWN0CmxzIC1hIC9rZXJuZWwtdGVzdHMvcnVuLXF1ZXVl
L2t2bS9pMzg2LXJhbmRjb25maWctaTAwMi0wOTEyL3ZpcmVzaGs6Zm9yLXYzLjEzOmQ3OWZk
MDNmZDY1MWJkOTFhMDgxZmM5N2Y1ZjBkMjIxNTU3ZjhjYmI6YmlzZWN0LWRybQoKMjAxMy0w
OS0xNy0wNTowMzozNyBkNzlmZDAzZmQ2NTFiZDkxYTA4MWZjOTdmNWYwZDIyMTU1N2Y4Y2Ji
IGNvbXBpbGluZwoyMjcgcmVhbCAgMTUzNyB1c2VyICAyOTYgc3lzICA4MDYuNTElIGNwdSAJ
aTM4Ni1yYW5kY29uZmlnLWkwMDItMDkxMgoKMjAxMy0wOS0xNy0wNTowODowNyBkZXRlY3Rp
bmcgYm9vdCBzdGF0ZSAzLjExLjAtcmMyLTAwMDE1LWdkNzlmZDAzCTEuIFRFU1QgRkFJTFVS
RQoKWyAgICA0LjE5MDA5MF0gLS0tLS0tLS0tLS0tWyBjdXQgaGVyZSBdLS0tLS0tLS0tLS0t
ClsgICAgNC4xOTA5MDZdIFdBUk5JTkc6IENQVTogMSBQSUQ6IDkgYXQgL2Mvd2ZnL2xpbnV4
LWRybS9saWIvbGlzdF9kZWJ1Zy5jOjMzIF9fbGlzdF9hZGQrMHg2Yy8weGFlKCkKWyAgICA0
LjE5MjI5MF0gbGlzdF9hZGQgY29ycnVwdGlvbi4gcHJldi0+bmV4dCBzaG91bGQgYmUgbmV4
dCAoNzgxMDAzZDApLCBidXQgd2FzIDc5MmUwMDY1LiAocHJldj03ODA5MTU3MCkuClsgICAg
NC4xOTM3ODBdIE1vZHVsZXMgbGlua2VkIGluOgpbICAgIDQuMTk0MjkzXSBDUFU6IDEgUElE
OiA5IENvbW06IHJjdV9zY2hlZCBOb3QgdGFpbnRlZCAzLjExLjAtcmMyLTAwMDE1LWdkNzlm
ZDAzICMxMjcKWyAgICA0LjE5NTUwNV0gIDAwMDAwMDAwIDAwMDAwMDAwIDc4MDY3ZGY0IDc5
MjA5Y2ZiIDc4MDY3ZTM0IDc4MDY3ZTI0IDc5MDMwODgzIDc5MmVkNDdmClsgICAgNC4xOTY5
MDZdICA3ODA2N2U1MCAwMDAwMDAwOSA3OTJlZDQ1ZCAwMDAwMDAyMSA3OTEwNTNjZCA3OTEw
NTNjZCA3ODA5MTU3MCA3ODEwMDNkMApbICAgIDQuMTk4MzAzXSAgNzgwNjdlYTAgNzgwNjdl
M2MgNzkwMzA4YzggMDAwMDAwMDkgNzgwNjdlMzQgNzkyZWQ0N2YgNzgwNjdlNTAgNzgwNjdl
NjgKWyAgICA0LjE5OTcwNV0gQ2FsbCBUcmFjZToKWyAgICA0LjIwMDAzMF0gIFs8NzkyMDlj
ZmI+XSBkdW1wX3N0YWNrKzB4NGIvMHg2NgpbICAgIDQuMjAwMDMwXSAgWzw3OTAzMDg4Mz5d
IHdhcm5fc2xvd3BhdGhfY29tbW9uKzB4NzQvMHg4YgpbICAgIDQuMjAwMDMwXSAgWzw3OTEw
NTNjZD5dID8gX19saXN0X2FkZCsweDZjLzB4YWUKWyAgICA0LjIwMDAzMF0gIFs8NzkxMDUz
Y2Q+XSA/IF9fbGlzdF9hZGQrMHg2Yy8weGFlClsgICAgNC4yMDAwMzBdICBbPDc5MDMwOGM4
Pl0gd2Fybl9zbG93cGF0aF9mbXQrMHgyZS8weDMwClsgICAgNC4yMDAwMzBdICBbPDc5MTA1
M2NkPl0gX19saXN0X2FkZCsweDZjLzB4YWUKWyAgICA0LjIwMDAzMF0gIFs8NzkwMzk1N2M+
XSBfX2ludGVybmFsX2FkZF90aW1lcisweDhhLzB4OGUKWyAgICA0LjIwMDAzMF0gIFs8Nzkw
Mzk1OGU+XSBpbnRlcm5hbF9hZGRfdGltZXIrMHhlLzB4MjYKWyAgICA0LjIwMDAzMF0gIFs8
NzkyMGE1MmE+XSBzY2hlZHVsZV90aW1lb3V0KzB4MTI2LzB4MTZlClsgICAgNC4yMDAwMzBd
ICBbPDc5MDM5NjQ4Pl0gPyBjYXNjYWRlKzB4NWEvMHg1YQpbICAgIDQuMjAwMDMwXSAgWzw3
OTA3YjVmNz5dIHJjdV9ncF9rdGhyZWFkKzB4Mjk5LzB4NDY3ClsgICAgNC4yMDAwMzBdICBb
PDc5MDQ4NDM0Pl0gPyBhYm9ydF9leGNsdXNpdmVfd2FpdCsweDYzLzB4NjMKWyAgICA0LjIw
MDAzMF0gIFs8NzkwN2IzNWU+XSA/IHJjdV9ncF9mcXMrMHg1My8weDUzClsgICAgNC4yMDAw
MzBdICBbPDc5MDQ3YzhlPl0ga3RocmVhZCsweDk1LzB4OWEKWyAgICA0LjIwMDAzMF0gIFs8
NzkwNDAwMDA+XSA/IGdldHJ1c2FnZSsweDE5Mi8weDIyMApbICAgIDQuMjAwMDMwXSAgWzw3
OTIwZjA3Yj5dIHJldF9mcm9tX2tlcm5lbF90aHJlYWQrMHgxYi8weDMwClsgICAgNC4yMDAw
MzBdICBbPDc5MDQ3YmY5Pl0gPyBrdGhyZWFkX3N0b3ArMHg0ZS8weDRlClsgICAgNC4yMDAw
MzBdIC0tLVsgZW5kIHRyYWNlIDZmMTA1OTdjMTQyMDAyOTEgXS0tLQova2VybmVsL2kzODYt
cmFuZGNvbmZpZy1pMDAyLTA5MTIvZDc5ZmQwM2ZkNjUxYmQ5MWEwODFmYzk3ZjVmMGQyMjE1
NTdmOGNiYi9kbWVzZy1xdWFudGFsLWJlbnMtMjoyMDEzMDkxNzA1MDg1MDozLjExLjAtcmMy
LTAwMDE1LWdkNzlmZDAzOjEyNwoKQmlzZWN0aW5nOiA3IHJldmlzaW9ucyBsZWZ0IHRvIHRl
c3QgYWZ0ZXIgdGhpcyAocm91Z2hseSAzIHN0ZXBzKQpbZTU2MzQxYWQzODAxMTQ0NTQxMTlh
YzA0M2U2ZDcxMGRkYmJiNzcxMF0gc3RhZ2luZzogY29tZWRpOiBjb252ZXJ0IGNsYXNzIGNv
ZGUgdG8gdXNlIGRldl9ncm91cHMKcnVubmluZyAvYy9rZXJuZWwtdGVzdHMvYmlzZWN0LXRl
c3QtYm9vdC1mYWlsdXJlLnNoIC9ob21lL3dmZy9kcm0vb2JqLWJpc2VjdApscyAtYSAva2Vy
bmVsLXRlc3RzL3J1bi1xdWV1ZS9rdm0vaTM4Ni1yYW5kY29uZmlnLWkwMDItMDkxMi92aXJl
c2hrOmZvci12My4xMzplNTYzNDFhZDM4MDExNDQ1NDExOWFjMDQzZTZkNzEwZGRiYmI3NzEw
OmJpc2VjdC1kcm0KCjIwMTMtMDktMTctMDU6MDk6MDkgZTU2MzQxYWQzODAxMTQ0NTQxMTlh
YzA0M2U2ZDcxMGRkYmJiNzcxMCBjb21waWxpbmcKMjE3IHJlYWwgIDE1MzYgdXNlciAgMzA2
IHN5cyAgODQ5LjM2JSBjcHUgCWkzODYtcmFuZGNvbmZpZy1pMDAyLTA5MTIKCjIwMTMtMDkt
MTctMDU6MTM6MzAgZGV0ZWN0aW5nIGJvb3Qgc3RhdGUgMy4xMS4wLXJjMi0wMDAwNy1nZTU2
MzQxYQkyCTcJMjAJMzMJNTIJNjYJODIJOTIJMTAwCTEyMgkxNDEJMTYwCTE3MgkxOTEJMjAy
CTIyOAkyNDcJMjY4CTI4OAkzMDgJMzI3CTM0OQkzNjUJMzg3CTM5OQk0MDUJNDEyCTQxNQk0
MTgJNDE5Lgk0MjAgU1VDQ0VTUwoKQmlzZWN0aW5nOiAzIHJldmlzaW9ucyBsZWZ0IHRvIHRl
c3QgYWZ0ZXIgdGhpcyAocm91Z2hseSAyIHN0ZXBzKQpbNThiMjY3ZDNlM2YzY2U4N2MzZTU1
OWU0YzMzMGM4YzAzZTkwNWY1ZV0gZG1hOiBjb252ZXJ0IGRtYV9kZXZjbGFzcyB0byB1c2Ug
ZGV2X2dyb3VwcwpydW5uaW5nIC9jL2tlcm5lbC10ZXN0cy9iaXNlY3QtdGVzdC1ib290LWZh
aWx1cmUuc2ggL2hvbWUvd2ZnL2RybS9vYmotYmlzZWN0CmxzIC1hIC9rZXJuZWwtdGVzdHMv
cnVuLXF1ZXVlL2t2bS9pMzg2LXJhbmRjb25maWctaTAwMi0wOTEyL3ZpcmVzaGs6Zm9yLXYz
LjEzOjU4YjI2N2QzZTNmM2NlODdjM2U1NTllNGMzMzBjOGMwM2U5MDVmNWU6YmlzZWN0LWRy
bQoKMjAxMy0wOS0xNy0wNToyOTozMiA1OGIyNjdkM2UzZjNjZTg3YzNlNTU5ZTRjMzMwYzhj
MDNlOTA1ZjVlIGNvbXBpbGluZwoxOTQgcmVhbCAgMTU1MSB1c2VyICAzMTUgc3lzICA5NTgu
NjMlIGNwdSAJaTM4Ni1yYW5kY29uZmlnLWkwMDItMDkxMgoKMjAxMy0wOS0xNy0wNTozMzoy
OSBkZXRlY3RpbmcgYm9vdCBzdGF0ZSAzLjExLjAtcmMyLTAwMDExLWc1OGIyNjdkLi4JMQky
CTQgVEVTVCBGQUlMVVJFCgpbICAgIDQuNDUwOTgyXSAtLS0tLS0tLS0tLS1bIGN1dCBoZXJl
IF0tLS0tLS0tLS0tLS0KWyAgICA0LjQ1MTk4Ml0gV0FSTklORzogQ1BVOiAxIFBJRDogOSBh
dCAvYy93ZmcvbGludXgtZHJtL2xpYi9saXN0X2RlYnVnLmM6MzMgX19saXN0X2FkZCsweDZj
LzB4YWUoKQpbICAgIDQuNDUzNzA1XSBsaXN0X2FkZCBjb3JydXB0aW9uLiBwcmV2LT5uZXh0
IHNob3VsZCBiZSBuZXh0ICg3ODEwMDRhOCksIGJ1dCB3YXMgICAobnVsbCkuIChwcmV2PTc4
MTQwZDcwKS4KWyAgICA0LjQ1NTU3Nl0gTW9kdWxlcyBsaW5rZWQgaW46ClsgICAgNC40NTYy
MjhdIENQVTogMSBQSUQ6IDkgQ29tbTogcmN1X3NjaGVkIE5vdCB0YWludGVkIDMuMTEuMC1y
YzItMDAwMTEtZzU4YjI2N2QgIzEyOQpbICAgIDQuNDU3NzMxXSAgMDAwMDAwMDAgMDAwMDAw
MDAgNzgwNjdkZjQgNzkyMDljZmIgNzgwNjdlMzQgNzgwNjdlMjQgNzkwMzA4ODMgNzkyZWQ0
N2YKWyAgICA0LjQ1OTU1NV0gIDc4MDY3ZTUwIDAwMDAwMDA5IDc5MmVkNDVkIDAwMDAwMDIx
IDc5MTA1M2NkIDc5MTA1M2NkIDc4MTQwZDcwIDc4MTAwNGE4ClsgICAgNC40NjAwMjFdICA3
ODA2N2VhMCA3ODA2N2UzYyA3OTAzMDhjOCAwMDAwMDAwOSA3ODA2N2UzNCA3OTJlZDQ3ZiA3
ODA2N2U1MCA3ODA2N2U2OApbICAgIDQuNDYwMDIxXSBDYWxsIFRyYWNlOgpbICAgIDQuNDYw
MDIxXSAgWzw3OTIwOWNmYj5dIGR1bXBfc3RhY2srMHg0Yi8weDY2ClsgICAgNC40NjAwMjFd
ICBbPDc5MDMwODgzPl0gd2Fybl9zbG93cGF0aF9jb21tb24rMHg3NC8weDhiClsgICAgNC40
NjAwMjFdICBbPDc5MTA1M2NkPl0gPyBfX2xpc3RfYWRkKzB4NmMvMHhhZQpbICAgIDQuNDYw
MDIxXSAgWzw3OTEwNTNjZD5dID8gX19saXN0X2FkZCsweDZjLzB4YWUKWyAgICA0LjQ2MDAy
MV0gIFs8NzkwMzA4Yzg+XSB3YXJuX3Nsb3dwYXRoX2ZtdCsweDJlLzB4MzAKWyAgICA0LjQ2
MDAyMV0gIFs8NzkxMDUzY2Q+XSBfX2xpc3RfYWRkKzB4NmMvMHhhZQpbICAgIDQuNDYwMDIx
XSAgWzw3OTAzOTU3Yz5dIF9faW50ZXJuYWxfYWRkX3RpbWVyKzB4OGEvMHg4ZQpbICAgIDQu
NDYwMDIxXSAgWzw3OTAzOTU4ZT5dIGludGVybmFsX2FkZF90aW1lcisweGUvMHgyNgpbICAg
IDQuNDYwMDIxXSAgWzw3OTIwYTUyYT5dIHNjaGVkdWxlX3RpbWVvdXQrMHgxMjYvMHgxNmUK
WyAgICA0LjQ2MDAyMV0gIFs8NzkwMzk2NDg+XSA/IGNhc2NhZGUrMHg1YS8weDVhClsgICAg
NC40NjAwMjFdICBbPDc5MDdiNWY3Pl0gcmN1X2dwX2t0aHJlYWQrMHgyOTkvMHg0NjcKWyAg
ICA0LjQ2MDAyMV0gIFs8NzkwNDg0MzQ+XSA/IGFib3J0X2V4Y2x1c2l2ZV93YWl0KzB4NjMv
MHg2MwpbICAgIDQuNDYwMDIxXSAgWzw3OTA3YjM1ZT5dID8gcmN1X2dwX2ZxcysweDUzLzB4
NTMKWyAgICA0LjQ2MDAyMV0gIFs8NzkwNDdjOGU+XSBrdGhyZWFkKzB4OTUvMHg5YQpbICAg
IDQuNDYwMDIxXSAgWzw3OTA0MDAwMD5dID8gZ2V0cnVzYWdlKzB4MTkyLzB4MjIwClsgICAg
NC40NjAwMjFdICBbPDc5MjBmMDdiPl0gcmV0X2Zyb21fa2VybmVsX3RocmVhZCsweDFiLzB4
MzAKWyAgICA0LjQ2MDAyMV0gIFs8NzkwNDdiZjk+XSA/IGt0aHJlYWRfc3RvcCsweDRlLzB4
NGUKWyAgICA0LjQ2MDAyMV0gLS0tWyBlbmQgdHJhY2UgNzc1YzhhNzFmNTgxYmFhNCBdLS0t
Ci9rZXJuZWwvaTM4Ni1yYW5kY29uZmlnLWkwMDItMDkxMi81OGIyNjdkM2UzZjNjZTg3YzNl
NTU5ZTRjMzMwYzhjMDNlOTA1ZjVlL2RtZXNnLXF1YW50YWwtbGtwLXR0MDItMTU6MjAxMzA5
MTYxOTU0NTg6My4xMS4wLXJjMi0wMDAxMS1nNThiMjY3ZDoxMjkKCkJpc2VjdGluZzogMSBy
ZXZpc2lvbiBsZWZ0IHRvIHRlc3QgYWZ0ZXIgdGhpcyAocm91Z2hseSAxIHN0ZXApCls3YzQy
NzIxZmUwYzU4YTg0ODg0OWI0M2ZmNTU4Y2YyZmI4NmFhMzVhXSBjaGFyOiB0aWxlLXNyb206
IGZpeCBidWlsZCBlcnJvcgpydW5uaW5nIC9jL2tlcm5lbC10ZXN0cy9iaXNlY3QtdGVzdC1i
b290LWZhaWx1cmUuc2ggL2hvbWUvd2ZnL2RybS9vYmotYmlzZWN0CmxzIC1hIC9rZXJuZWwt
dGVzdHMvcnVuLXF1ZXVlL2t2bS9pMzg2LXJhbmRjb25maWctaTAwMi0wOTEyL3ZpcmVzaGs6
Zm9yLXYzLjEzOjdjNDI3MjFmZTBjNThhODQ4ODQ5YjQzZmY1NThjZjJmYjg2YWEzNWE6Ymlz
ZWN0LWRybQoKMjAxMy0wOS0xNy0wNTozNjowMSA3YzQyNzIxZmUwYzU4YTg0ODg0OWI0M2Zm
NTU4Y2YyZmI4NmFhMzVhIGNvbXBpbGluZwoxOTggcmVhbCAgMTU3NiB1c2VyICAzNDIgc3lz
ICA5NjguMDMlIGNwdSAJaTM4Ni1yYW5kY29uZmlnLWkwMDItMDkxMgoKMjAxMy0wOS0xNy0w
NTo0MDowMyBkZXRlY3RpbmcgYm9vdCBzdGF0ZSAzLjExLjAtcmMyLTAwMDA5LWc3YzQyNzIx
CTEwCTIxCTMzCTUxCTc1CTkxCTEwNgkxMjIJMTQ5CTE2MwkxODkJMjExCTIyNwkyMzQJMjQ0
CTI1NgkyNjgJMjc4CTI5MQkyOTgJMzA1CTMwOQkzMjEJMzMwCTMzNwkzNTQJMzc2CTM3OQkz
ODMJMzkyCTM5NgkzOTcJNDA2CTQxMQk0MTYJNDE3CTQxOAk0MjAgU1VDQ0VTUwoKQmlzZWN0
aW5nOiAwIHJldmlzaW9ucyBsZWZ0IHRvIHRlc3QgYWZ0ZXIgdGhpcyAocm91Z2hseSAwIHN0
ZXBzKQpbYzgxN2E2N2VjYmE3YzNjMmFhYTEwNDc5NmQ3OGYxNjBhZjYwOTIwZF0ga29iamVj
dDogZGVsYXllZCBrb2JqZWN0IHJlbGVhc2U6IGhlbHAgZmluZCBidWdneSBkcml2ZXJzCnJ1
bm5pbmcgL2Mva2VybmVsLXRlc3RzL2Jpc2VjdC10ZXN0LWJvb3QtZmFpbHVyZS5zaCAvaG9t
ZS93ZmcvZHJtL29iai1iaXNlY3QKbHMgLWEgL2tlcm5lbC10ZXN0cy9ydW4tcXVldWUva3Zt
L2kzODYtcmFuZGNvbmZpZy1pMDAyLTA5MTIvdmlyZXNoazpmb3ItdjMuMTM6YzgxN2E2N2Vj
YmE3YzNjMmFhYTEwNDc5NmQ3OGYxNjBhZjYwOTIwZDpiaXNlY3QtZHJtCgoyMDEzLTA5LTE3
LTA1OjU5OjEyIGM4MTdhNjdlY2JhN2MzYzJhYWExMDQ3OTZkNzhmMTYwYWY2MDkyMGQgY29t
cGlsaW5nCjM0MCByZWFsICAxNTg0IHVzZXIgIDM0NSBzeXMgIDU2Ni4yNyUgY3B1IAlpMzg2
LXJhbmRjb25maWctaTAwMi0wOTEyCgoyMDEzLTA5LTE3LTA2OjA5OjA0IGRldGVjdGluZyBi
b290IHN0YXRlIDMuMTEuMC1yYzItMDAwMTAtZ2M4MTdhNjcuLiBURVNUIEZBSUxVUkUKWyAg
ICA2LjU0MDQ5OF0gaW5wdXQ6IEltRXhQUy8yIEdlbmVyaWMgRXhwbG9yZXIgTW91c2UgYXMg
L2RldmljZXMvcGxhdGZvcm0vaTgwNDIvc2VyaW8xL2lucHV0L2lucHV0MgpbICAgIDYuOTUx
MzYwXSAtLS0tLS0tLS0tLS1bIGN1dCBoZXJlIF0tLS0tLS0tLS0tLS0KWyAgICA2Ljk1MjM4
M10gV0FSTklORzogQ1BVOiAxIFBJRDogOSBhdCAvYy93ZmcvbGludXgtZHJtL2xpYi9saXN0
X2RlYnVnLmM6MzMgX19saXN0X2FkZCsweDZjLzB4YWUoKQpbICAgIDYuOTU0MTExXSBsaXN0
X2FkZCBjb3JydXB0aW9uLiBwcmV2LT5uZXh0IHNob3VsZCBiZSBuZXh0ICg3ODEwMDQ3OCks
IGJ1dCB3YXMgICAobnVsbCkuIChwcmV2PTc4MThlMTcwKS4KWyAgICA2Ljk1NjAwNF0gTW9k
dWxlcyBsaW5rZWQgaW46ClsgICAgNi45NTY2NzFdIENQVTogMSBQSUQ6IDkgQ29tbTogcmN1
X3NjaGVkIE5vdCB0YWludGVkIDMuMTEuMC1yYzItMDAwMTAtZ2M4MTdhNjcgIzEzMQpbICAg
IDYuOTU4MTk0XSAgMDAwMDAwMDAgMDAwMDAwMDAgNzgwNjdkZjQgNzkyMDljZmIgNzgwNjdl
MzQgNzgwNjdlMjQgNzkwMzA4ODMgNzkyZWQ0MzMKWyAgICA2Ljk1OTk4N10gIDc4MDY3ZTUw
IDAwMDAwMDA5IDc5MmVkNDExIDAwMDAwMDIxIDc5MTA1M2NkIDc5MTA1M2NkIDc4MThlMTcw
IDc4MTAwNDc4ClsgICAgNi45NjEzMDVdICA3ODA2N2VhMCA3ODA2N2UzYyA3OTAzMDhjOCAw
MDAwMDAwOSA3ODA2N2UzNCA3OTJlZDQzMyA3ODA2N2U1MCA3ODA2N2U2OApbICAgIDYuOTYx
MzA1XSBDYWxsIFRyYWNlOgpbICAgIDYuOTYxMzA1XSAgWzw3OTIwOWNmYj5dIGR1bXBfc3Rh
Y2srMHg0Yi8weDY2ClsgICAgNi45NjEzMDVdICBbPDc5MDMwODgzPl0gd2Fybl9zbG93cGF0
aF9jb21tb24rMHg3NC8weDhiClsgICAgNi45NjEzMDVdICBbPDc5MTA1M2NkPl0gPyBfX2xp
c3RfYWRkKzB4NmMvMHhhZQpbICAgIDYuOTYxMzA1XSAgWzw3OTEwNTNjZD5dID8gX19saXN0
X2FkZCsweDZjLzB4YWUKWyAgICA2Ljk2MTMwNV0gIFs8NzkwMzA4Yzg+XSB3YXJuX3Nsb3dw
YXRoX2ZtdCsweDJlLzB4MzAKWyAgICA2Ljk2MTMwNV0gIFs8NzkxMDUzY2Q+XSBfX2xpc3Rf
YWRkKzB4NmMvMHhhZQpbICAgIDYuOTYxMzA1XSAgWzw3OTAzOTU3Yz5dIF9faW50ZXJuYWxf
YWRkX3RpbWVyKzB4OGEvMHg4ZQpbICAgIDYuOTYxMzA1XSAgWzw3OTAzOTU4ZT5dIGludGVy
bmFsX2FkZF90aW1lcisweGUvMHgyNgpbICAgIDYuOTYxMzA1XSAgWzw3OTIwYTUyYT5dIHNj
aGVkdWxlX3RpbWVvdXQrMHgxMjYvMHgxNmUKWyAgICA2Ljk2MTMwNV0gIFs8NzkwMzk2NDg+
XSA/IGNhc2NhZGUrMHg1YS8weDVhClsgICAgNi45NjEzMDVdICBbPDc5MDdiNWY3Pl0gcmN1
X2dwX2t0aHJlYWQrMHgyOTkvMHg0NjcKWyAgICA2Ljk2MTMwNV0gIFs8NzkwNDg0MzQ+XSA/
IGFib3J0X2V4Y2x1c2l2ZV93YWl0KzB4NjMvMHg2MwpbICAgIDYuOTYxMzA1XSAgWzw3OTA3
YjM1ZT5dID8gcmN1X2dwX2ZxcysweDUzLzB4NTMKWyAgICA2Ljk2MTMwNV0gIFs8NzkwNDdj
OGU+XSBrdGhyZWFkKzB4OTUvMHg5YQpbICAgIDYuOTYxMzA1XSAgWzw3OTA0MDAwMD5dID8g
Z2V0cnVzYWdlKzB4MTkyLzB4MjIwClsgICAgNi45NjEzMDVdICBbPDc5MjBmMDdiPl0gcmV0
X2Zyb21fa2VybmVsX3RocmVhZCsweDFiLzB4MzAKWyAgICA2Ljk2MTMwNV0gIFs8NzkwNDdi
Zjk+XSA/IGt0aHJlYWRfc3RvcCsweDRlLzB4NGUKWyAgICA2Ljk2MTMwNV0gLS0tWyBlbmQg
dHJhY2UgZDMzMTYyM2FlMzE2NzM2OCBdLS0tCi9rZXJuZWwvaTM4Ni1yYW5kY29uZmlnLWkw
MDItMDkxMi9jODE3YTY3ZWNiYTdjM2MyYWFhMTA0Nzk2ZDc4ZjE2MGFmNjA5MjBkL2RtZXNn
LXF1YW50YWwtbGtwLXR0MDItMjoyMDEzMDkxNjIwMjkwMjozLjExLjAtcmMyLTAwMDEwLWdj
ODE3YTY3OjEzMQoKYzgxN2E2N2VjYmE3YzNjMmFhYTEwNDc5NmQ3OGYxNjBhZjYwOTIwZCBp
cyB0aGUgZmlyc3QgYmFkIGNvbW1pdApjb21taXQgYzgxN2E2N2VjYmE3YzNjMmFhYTEwNDc5
NmQ3OGYxNjBhZjYwOTIwZApBdXRob3I6IFJ1c3NlbGwgS2luZyA8cm1rK2tlcm5lbEBhcm0u
bGludXgub3JnLnVrPgpEYXRlOiAgIFRodSBKdW4gMjcgMTU6MDY6MTQgMjAxMyArMDEwMAoK
ICAgIGtvYmplY3Q6IGRlbGF5ZWQga29iamVjdCByZWxlYXNlOiBoZWxwIGZpbmQgYnVnZ3kg
ZHJpdmVycwogICAgCiAgICBJbXBsZW1lbnQgZGVidWdnaW5nIGZvciBrb2JqZWN0IHJlbGVh
c2UgZnVuY3Rpb25zLiAga29iamVjdHMgYXJlCiAgICByZWZlcmVuY2UgY291bnRlZCwgc28g
dGhlIGRyb3Agb2YgdGhlIGxhc3QgcmVmZXJlbmNlIHRvIHRoZW0gaXMgbm90CiAgICBwcmVk
aWN0YWJsZS4gSG93ZXZlciwgdGhlIGNvbW1vbiBjYXNlIGlzIGZvciB0aGUgbGFzdCByZWZl
cmVuY2UgdG8gYmUKICAgIHRoZSBrb2JqZWN0J3MgcmVtb3ZhbCBmcm9tIGEgc3Vic3lzdGVt
LCB3aGljaCByZXN1bHRzIGluIHRoZSByZWxlYXNlCiAgICBmdW5jdGlvbiBiZWluZyBpbW1l
ZGlhdGVseSBjYWxsZWQuCiAgICAKICAgIFRoaXMgY2FuIGhpZGUgc3VidGxlIGJ1Z3MsIHdo
aWNoIGNhbiBvY2N1ciB3aGVuIGFub3RoZXIgdGhyZWFkIGhvbGRzIGEKICAgIHJlZmVyZW5j
ZSB0byB0aGUga29iamVjdCBhdCB0aGUgc2FtZSB0aW1lIHRoYXQgYSBrb2JqZWN0IGlzIHJl
bW92ZWQuCiAgICBUaGlzIHJlc3VsdHMgaW4gdGhlIHJlbGVhc2UgbWV0aG9kIGJlaW5nIGRl
bGF5ZWQuCiAgICAKICAgIEluIG9yZGVyIHRvIG1ha2UgdGhlc2Uga2luZHMgb2YgcHJvYmxl
bXMgbW9yZSB2aXNpYmxlLCB0aGUgZm9sbG93aW5nCiAgICBwYXRjaCBpbXBsZW1lbnRzIGEg
ZGVsYXllZCByZWxlYXNlOyB0aGlzIGhhcyB0aGUgZWZmZWN0IHRoYXQgdGhlCiAgICByZWxl
YXNlIGZ1bmN0aW9uIHdpbGwgYmUgb3V0IG9mIG9yZGVyIHdpdGggcmVzcGVjdCB0byB0aGUg
cmVtb3ZhbCBvZgogICAgdGhlIGtvYmplY3QgaW4gdGhlIHNhbWUgbWFubmVyIHRoYXQgaXQg
d291bGQgYmUgaWYgYSByZWZlcmVuY2Ugd2FzCiAgICBiZWluZyBoZWxkLgogICAgCiAgICBU
aGlzIHByb3ZpZGVzIHVzIHdpdGggYW4gZWFzeSB3YXkgdG8gYWxsb3cgZHJpdmVyIHdyaXRl
cnMgdG8gZGVidWcKICAgIHRoZWlyIGRyaXZlcnMgYW5kIGZpeCBvdGhlcndpc2UgaGlkZGVu
IHByb2JsZW1zLgogICAgCiAgICBTaWduZWQtb2ZmLWJ5OiBSdXNzZWxsIEtpbmcgPHJtaytr
ZXJuZWxAYXJtLmxpbnV4Lm9yZy51az4KICAgIFNpZ25lZC1vZmYtYnk6IEdyZWcgS3JvYWgt
SGFydG1hbiA8Z3JlZ2toQGxpbnV4Zm91bmRhdGlvbi5vcmc+Cgo6MDQwMDAwIDA0MDAwMCBm
NmMyM2VmYTEwMmZjMmMyZWFkNWM4NmJkYjY1YWE3MDcxOWIxYWI5IDA0OTg1OWZhN2EzYTk1
Mzg5MjEyNzQ2N2JhYmJmMDJmNjZhNjliNzYgTQlpbmNsdWRlCjowNDAwMDAgMDQwMDAwIGE0
MWQyMDY2OWYwZjYyNGQyY2U5Y2E3ZTZhNWY5NmU0ZjkxNDMyZTAgYmYyMTY4MTk0ZjgyOTEx
Y2YyZTE4OTJkODJmMGMxM2QwMGM3NzJhZSBNCWxpYgpiaXNlY3QgcnVuIHN1Y2Nlc3MKbHMg
LWEgL2tlcm5lbC10ZXN0cy9ydW4tcXVldWUva3ZtL2kzODYtcmFuZGNvbmZpZy1pMDAyLTA5
MTIvdmlyZXNoazpmb3ItdjMuMTM6N2M0MjcyMWZlMGM1OGE4NDg4NDliNDNmZjU1OGNmMmZi
ODZhYTM1YTpiaXNlY3QtZHJtCgoyMDEzLTA5LTE3LTA2OjEwOjEwIDdjNDI3MjFmZTBjNThh
ODQ4ODQ5YjQzZmY1NThjZjJmYjg2YWEzNWEgcmV1c2UgL2tlcm5lbC9pMzg2LXJhbmRjb25m
aWctaTAwMi0wOTEyLzdjNDI3MjFmZTBjNThhODQ4ODQ5YjQzZmY1NThjZjJmYjg2YWEzNWEv
dm1saW51ei0zLjExLjAtcmMyLTAwMDA5LWc3YzQyNzIxCgoyMDEzLTA5LTE3LTA2OjEwOjEx
IGRldGVjdGluZyBib290IHN0YXRlIC4JNDIxLgk0MjIuLgk0MjMuCTQyNC4uLi4JNDI1Li4u
Li4uLi4JNDI4Li4JNDI5Li4uCTQzMAk0MzEJNDMyCTQzMy4uLgk0MzQuLi4uLi4uLi4uLi4J
NDM1CTQzNi4uLgk0MzcuLi4JNDM4Li4uCTQzOS4uCTQ0MAk0NDEJNDQyCTQ0Mwk0NDQuCTQ0
NS4uLi4JNDQ2CTQ0Nwk0NDguLi4JNDUwLi4uLi4uLgk0NTEJNDU0CTQ1OC4JNDYyCTQ2My4J
NDY1Lgk0NjYJNDcxCTQ3Mwk0NzguCTQ4MQk0ODIJNDgzCTQ4Ni4JNDg3Lgk0OTIJNDk0CTQ5
NQk0OTYuCTQ5Nwk1MDAJNTA1CTUwNwk1MDkJNTExLgk1MTYJNTE3CTUxOQk1MjMJNTI0Lgk1
MzAJNTMxCTUzMgk1MzUuCTU0MAk1NDIJNTQ1Lgk1NDcJNTQ4CTU0OS4JNTUwLgk1NTIuCTU1
Mwk1NTUJNTU4CTU1OQk1NjAJNTY0CTU2NQk1NjkJNTcxCTU3Mi4JNTczCTU3NQk1NzkJNTgw
CTU4MQk1ODMJNTg0CTU4Ngk1ODkJNTkyLgk1OTQJNTk3CTYwMAk2MDEJNjAzCTYwNQk2MDYJ
NjA3CTYxMC4JNjEyLgk2MTMJNjE0CTYxNQk2MTgJNjE5CTYyMAk2MjEuCTYyMi4uLgk2MjMu
Li4uLi4JNjI0Li4uCTYyNQk2MjYuLgk2MjguCTYzMS4JNjMyCTYzNAk2MzUJNjM2Lgk2Mzcu
CTYzOAk2NDEJNjQyCTY0Mwk2NDUuLgk2NDYuCTY0OAk2NDkJNjUwCTY1Mgk2NTMJNjU0CTY1
NQk2NTYuLi4JNjU3Li4JNjYwLgk2NjMJNjY0Li4JNjY1CTY2Nwk2NjgJNjY5CTY3MC4JNjcx
CTY3Mi4JNjc0CTY3NS4uCTY3Ni4JNjc3Li4JNjc4Li4JNjgwCTY4MQk2ODIJNjg0Lgk2ODUJ
Njg2CTY4OC4JNjg5Lgk2OTEJNjkzCTY5NAk2OTcJNzAxCTcwMwk3MDQJNzA1Lgk3MDYJNzA3
CTcwOQk3MTIJNzEzLgk3MTUJNzE2Li4JNzE3Li4JNzE4Li4JNzE5Li4JNzIwCTcyMQk3MjIu
CTcyNC4uLi4JNzI2Li4uLi4uLi4uLi4uCTcyNwk3MjgJNzI5CTczMQk3MzIuLgk3MzMuCTcz
NQk3MzguLgk3MzkJNzQwLgk3NDEuCTc0Mwk3NDUJNzQ2Lgk3NDcJNzQ4Li4uLi4JNzQ5CTc1
MC4uLgk3NTIuCTc1Mwk3NTUJNzU2CTc1Ny4JNzU4Li4JNzU5CTc2MC4uLgk3NjEuLgk3NjMu
CTc2NAk3NjUJNzY2CTc2Nwk3NzAuCTc3MQk3NzMJNzc0Lgk3NzcJNzc4CTc3OQk3ODAJNzg0
CTc4OQk3OTEJNzkzLi4uLgk3OTcuCTc5OS4JODAwCTgwMgk4MDQJODA1Lgk4MDYJODA4CTgw
OQk4MTEJODEyLgk4MTMJODE0Li4uLi4uLi4JODE1CTgxNi4uLi4JODE3Li4JODE5CTgyMC4u
Lgk4MjEuLi4uLi4uLi4JODIyCTgyMy4uLi4JODI0Li4uLi4uLi4uLi4uCTgyNS4JODI3Li4u
CTgyOC4uLi4uLi4JODI5Lgk4MzAuCTgzMS4uCTgzMi4uLi4uLgk4MzMuCTgzNQk4MzgJODQw
CTg0NQk4NTAJODUzCTg1Ngk4NjAJODY2Lgk4NjkJODczCTg3Nwk4ODIJODg3CTg4OQk4OTEJ
ODkyCTg5NAk4OTYJODk3CTg5OQk5MDAJOTAzCTkwNC4JOTA2CTkxMgk5MTMJOTE1CTkxNwk5
MTkJOTI0CTkyOQk5MzIJOTM4Lgk5NDQJOTQ2Lgk5NDkJOTUyCTk1Mwk5NTQuLgk5NTUJOTU4
CTk1OQk5NjEJOTYzCTk2NQk5NjguLi4uLi4JOTY5Lgk5NzIJOTc2CTk3Ny4uCTk3OC4uLi4J
OTgxCTk4Mi4JOTgzLi4JOTg0CTk4NS4uLi4JOTg3CTk4OC4uCTk4OQk5OTEJOTkyLgk5OTMJ
OTk0Li4JOTk1Li4uCTk5OC4JMTAwMC4uLgkxMDAyCTEwMDUuCTEwMDcJMTAwOC4JMTAwOQkx
MDEwCTEwMTEuCTEwMTMJMTAxNC4JMTAxNS4JMTAxNy4JMTAxOQkxMDI0CTEwMjYJMTAyNwkx
MDMxCTEwMzUJMTAzOAkxMDQyCTEwNDUJMTA0NwkxMDUwCTEwNTEJMTA1MgkxMDU0CTEwNTkJ
MTA2My4JMTA2NgkxMDcxCTEwNzQJMTA3NQkxMDc3CTEwNzgJMTA3OQkxMDgwCTEwODEJMTA4
MgkxMDg0CTEwODUJMTA4NgkxMDg3LgkxMDg4CTEwODkJMTA5MC4JMTA5MQkxMDkzCTEwOTUJ
MTA5NgkxMDk4CTEwOTkJMTEwMAkxMTAyLgkxMTA1CTExMDYJMTEwOC4JMTExMAkxMTEyCTEx
MTUJMTExNgkxMTE4Li4uCTExMjEJMTEyMgkxMTI0CTExMjcJMTEyOAkxMTI5CTExMzAJMTEz
MQkxMTM2CTExMzcJMTE0MwkxMTQ2CTExNDcJMTE0OAkxMTUxCTExNTQuCTExNTkJMTE2MQkx
MTY1CTExNzEJMTE3MgkxMTc2Li4JMTE3NwkxMTgwCTExODMJMTE4NAkxMTkzCTExOTUJMTE5
Ny4JMTIwMC4JMTIwMQkxMjAyLi4JMTIwNC4uCTEyMDYJMTIwNy4JMTIwOC4uCTEyMDkJMTIx
MC4uCTEyMTEuCTEyMTIJMTIxMwkxMjE0CTEyMTUJMTIxNgkxMjE3LgkxMjE4Li4JMTIxOS4J
MTIyMAkxMjIxLgkxMjIyLgkxMjI1CTEyMjkJMTIzMC4JMTIzMQkxMjM3CTEyMzgJMTI0Mgkx
MjQ0CTEyNDkuCTEyNTcuLgkxMjU4Li4uLgkxMjU5Li4uLi4uLi4uLi4uLi4uLi4uLi4uLi4u
Li4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4u
Li4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4u
Li4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4u
Li4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4u
Li4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4u
Li4uLi4uLhtbMTszNW1hZGRfdG9fcnVuX3F1ZXVlIDEbWzBtCgkxMjYwIFNVQ0NFU1MKCmxz
IC1hIC9rZXJuZWwtdGVzdHMvcnVuLXF1ZXVlL2t2bS9pMzg2LXJhbmRjb25maWctaTAwMi0w
OTEyL3ZpcmVzaGs6Zm9yLXYzLjEzOjdjNDI3MjFmZTBjNThhODQ4ODQ5YjQzZmY1NThjZjJm
Yjg2YWEzNWE6YmlzZWN0LWRybQogU1VDQ0VTUwoKIyBIRUFEIGRldGFjaGVkIGF0IDdjNDI3
MjEKIyBZb3UgYXJlIGN1cnJlbnRseSBiaXNlY3RpbmcsIHN0YXJ0ZWQgZnJvbSBicmFuY2gg
J2MxYmU1YTUnLgojICAgKHVzZSAiZ2l0IGJpc2VjdCByZXNldCIgdG8gZ2V0IGJhY2sgdG8g
dGhlIG9yaWdpbmFsIGJyYW5jaCkKIwojIFVudHJhY2tlZCBmaWxlczoKIyAgICh1c2UgImdp
dCBhZGQgPGZpbGU+Li4uIiB0byBpbmNsdWRlIGluIHdoYXQgd2lsbCBiZSBjb21taXR0ZWQp
CiMKIwlpbmNsdWRlL2FzbQojCW9iai1iaXNlY3QKIwlvYmoteDg2XzY0Cm5vdGhpbmcgYWRk
ZWQgdG8gY29tbWl0IGJ1dCB1bnRyYWNrZWQgZmlsZXMgcHJlc2VudCAodXNlICJnaXQgYWRk
IiB0byB0cmFjaykKCj09PT09PT09PSB1cHN0cmVhbSA9PT09PT09PT0KRmV0Y2hpbmcgbGlu
dXMKbHMgLWEgL2tlcm5lbC10ZXN0cy9ydW4tcXVldWUva3ZtL2kzODYtcmFuZGNvbmZpZy1p
MDAyLTA5MTIvdmlyZXNoazpmb3ItdjMuMTM6MjcyYjk4YzY0NTVmMDA4ODRmMDM1MGY3NzVj
NTM0MjM1OGViYjczZjpiaXNlY3QtZHJtCgoyMDEzLTA5LTE3LTE1OjA4OjE4IDI3MmI5OGM2
NDU1ZjAwODg0ZjAzNTBmNzc1YzUzNDIzNThlYmI3M2YgY29tcGlsaW5nCgoyMDEzLTA5LTE3
LTE1OjEzOjExIGRldGVjdGluZyBib290IHN0YXRlIDMuMTIuMC1yYzEuLiBURVNUIEZBSUxV
UkUKWyAgICAzLjYyMDg3OF0gdHNjOiBSZWZpbmVkIFRTQyBjbG9ja3NvdXJjZSBjYWxpYnJh
dGlvbjogMjgzMy4yNzUgTUh6ClsgICAgMy43ODAyMTZdIC0tLS0tLS0tLS0tLVsgY3V0IGhl
cmUgXS0tLS0tLS0tLS0tLQpbICAgIDMuNzgwODkxXSBXQVJOSU5HOiBDUFU6IDEgUElEOiA5
IGF0IC9jL3dmZy9saW51eC1kcm0vbGliL2xpc3RfZGVidWcuYzozMyBfX2xpc3RfYWRkKzB4
NmMvMHhhZSgpClsgICAgMy43ODIwNTldIGxpc3RfYWRkIGNvcnJ1cHRpb24uIHByZXYtPm5l
eHQgc2hvdWxkIGJlIG5leHQgKDc4MTAwMjkwKSwgYnV0IHdhcyA3N2EwNDkwOC4gKHByZXY9
NzgxOGUxNzApLgpbICAgIDMuNzgzMzEzXSBNb2R1bGVzIGxpbmtlZCBpbjoKWyAgICAzLjc4
Mzc0NV0gQ1BVOiAxIFBJRDogOSBDb21tOiByY3Vfc2NoZWQgTm90IHRhaW50ZWQgMy4xMi4w
LXJjMSAjMTMyClsgICAgMy43ODQ2MDNdICAwMDAwMDAwMCAwMDAwMDAwMCA3ODA2N2RmNCA3
OTIwZTdmZiA3ODA2N2UzNCA3ODA2N2UyNCA3OTAzMGVmMiA3OTJmNGRlOApbICAgIDMuNzg1
Nzc5XSAgNzgwNjdlNTAgMDAwMDAwMDkgNzkyZjRkYzYgMDAwMDAwMjEgNzkxMDgwNTAgNzkx
MDgwNTAgNzgxOGUxNzAgNzgxMDAyOTAKWyAgICAzLjc4Njk2Nl0gIDc4MDY3ZWEwIDc4MDY3
ZTNjIDc5MDMwZjM3IDAwMDAwMDA5IDc4MDY3ZTM0IDc5MmY0ZGU4IDc4MDY3ZTUwIDc4MDY3
ZTY4ClsgICAgMy43ODgxNDFdIENhbGwgVHJhY2U6ClsgICAgMy43ODg0ODVdICBbPDc5MjBl
N2ZmPl0gZHVtcF9zdGFjaysweDRiLzB4NjYKWyAgICAzLjc4OTA4OV0gIFs8NzkwMzBlZjI+
XSB3YXJuX3Nsb3dwYXRoX2NvbW1vbisweDc0LzB4OGIKWyAgICAzLjc4OTc5Nl0gIFs8Nzkx
MDgwNTA+XSA/IF9fbGlzdF9hZGQrMHg2Yy8weGFlClsgICAgMy43OTAwNDBdICBbPDc5MTA4
MDUwPl0gPyBfX2xpc3RfYWRkKzB4NmMvMHhhZQpbICAgIDMuNzkwMDQwXSAgWzw3OTAzMGYz
Nz5dIHdhcm5fc2xvd3BhdGhfZm10KzB4MmUvMHgzMApbICAgIDMuNzkwMDQwXSAgWzw3OTEw
ODA1MD5dIF9fbGlzdF9hZGQrMHg2Yy8weGFlClsgICAgMy43OTAwNDBdICBbPDc5MDM3MWQx
Pl0gX19pbnRlcm5hbF9hZGRfdGltZXIrMHg4YS8weDhlClsgICAgMy43OTAwNDBdICBbPDc5
MDM3MWUzPl0gaW50ZXJuYWxfYWRkX3RpbWVyKzB4ZS8weDI2ClsgICAgMy43OTAwNDBdICBb
PDc5MjBmMDA2Pl0gc2NoZWR1bGVfdGltZW91dCsweDEyNi8weDE2ZQpbICAgIDMuNzkwMDQw
XSAgWzw3OTAzNzI5ZD5dID8gY2FzY2FkZSsweDVhLzB4NWEKWyAgICAzLjc5MDA0MF0gIFs8
NzkwN2JmMzM+XSByY3VfZ3Bfa3RocmVhZCsweDI5OS8weDQ2NwpbICAgIDMuNzkwMDQwXSAg
Wzw3OTA0NjE0Yj5dID8gYWJvcnRfZXhjbHVzaXZlX3dhaXQrMHg2My8weDYzClsgICAgMy43
OTAwNDBdICBbPDc5MDdiYzlhPl0gPyByY3VfZ3BfZnFzKzB4NmEvMHg2YQpbICAgIDMuNzkw
MDQwXSAgWzw3OTA0NTlhNT5dIGt0aHJlYWQrMHg5NS8weDlhClsgICAgMy43OTAwNDBdICBb
PDc5MDQwMDAwPl0gPyBkZXN0cm95X3dvcmtxdWV1ZSsweDJmLzB4MTc5ClsgICAgMy43OTAw
NDBdICBbPDc5MjEzY2ZiPl0gcmV0X2Zyb21fa2VybmVsX3RocmVhZCsweDFiLzB4MzAKWyAg
ICAzLjc5MDA0MF0gIFs8NzkwNDU5MTA+XSA/IGt0aHJlYWRfc3RvcCsweDRlLzB4NGUKWyAg
ICAzLjc5MDA0MF0gLS0tWyBlbmQgdHJhY2UgYmFhZGYxMmNlNTQyZmFjMSBdLS0tCi9rZXJu
ZWwvaTM4Ni1yYW5kY29uZmlnLWkwMDItMDkxMi8yNzJiOThjNjQ1NWYwMDg4NGYwMzUwZjc3
NWM1MzQyMzU4ZWJiNzNmL2RtZXNnLXF1YW50YWwtc3RvYWtsZXktMzoyMDEzMDkxNzE1MTQw
NDozLjEyLjAtcmMxOjEzMgoKCj09PT09PT09PSBsaW51eC1uZXh0ID09PT09PT09PQpGZXRj
aGluZyBuZXh0CmxzIC1hIC9rZXJuZWwtdGVzdHMvcnVuLXF1ZXVlL2t2bS9pMzg2LXJhbmRj
b25maWctaTAwMi0wOTEyL3ZpcmVzaGs6Zm9yLXYzLjEzOjJhNjVlZjVlNWU1ODYzYWY3ODQ4
NjgwOTA5NDc4ZmRjNzllNzI2ZDc6YmlzZWN0LWRybQoKMjAxMy0wOS0xNy0xNToxNDoyNSAy
YTY1ZWY1ZTVlNTg2M2FmNzg0ODY4MDkwOTQ3OGZkYzc5ZTcyNmQ3IGNvbXBpbGluZwoyMDEz
LTA5LTE3LTE1OjIxOjA0IDJhNjVlZjVlNWU1ODYzYWY3ODQ4NjgwOTA5NDc4ZmRjNzllNzI2
ZDcgU0tJUCBCUk9LRU4gQlVJTEQKQ2hlY2sgZXJyb3MgaW4gL2NjL3dmZy9saW51eC1kcm0g
YW5kIC90bXAva2VybmVsL2kzODYtcmFuZGNvbmZpZy1pMDAyLTA5MTIvMmE2NWVmNWU1ZTU4
NjNhZjc4NDg2ODA5MDk0NzhmZGM3OWU3MjZkNwo=

--gj572EiMnwbLXET9
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="config-3.11.0-02563-gf74a274"

#
# Automatically generated file; DO NOT EDIT.
# Linux/i386 3.11.0 Kernel Configuration
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
CONFIG_ARCH_CPU_PROBE_RELEASE=y
CONFIG_ARCH_SUPPORTS_UPROBES=y
CONFIG_DEFCONFIG_LIST="/lib/modules/$UNAME_RELEASE/.config"
CONFIG_CONSTRUCTORS=y
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
# CONFIG_SYSVIPC is not set
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
CONFIG_NO_HZ=y
# CONFIG_HIGH_RES_TIMERS is not set

#
# CPU/Task time and stats accounting
#
# CONFIG_TICK_CPU_ACCOUNTING is not set
CONFIG_IRQ_TIME_ACCOUNTING=y
# CONFIG_BSD_PROCESS_ACCT is not set
# CONFIG_TASKSTATS is not set

#
# RCU Subsystem
#
CONFIG_TREE_RCU=y
# CONFIG_PREEMPT_RCU is not set
CONFIG_RCU_STALL_COMMON=y
CONFIG_RCU_FANOUT=32
CONFIG_RCU_FANOUT_LEAF=16
# CONFIG_RCU_FANOUT_EXACT is not set
# CONFIG_RCU_FAST_NO_HZ is not set
# CONFIG_TREE_RCU_TRACE is not set
# CONFIG_RCU_NOCB_CPU is not set
CONFIG_IKCONFIG=y
# CONFIG_IKCONFIG_PROC is not set
CONFIG_LOG_BUF_SHIFT=17
CONFIG_HAVE_UNSTABLE_SCHED_CLOCK=y
CONFIG_ARCH_SUPPORTS_NUMA_BALANCING=y
CONFIG_ARCH_WANTS_PROT_NUMA_PROT_NONE=y
# CONFIG_CGROUPS is not set
# CONFIG_CHECKPOINT_RESTORE is not set
# CONFIG_NAMESPACES is not set
CONFIG_UIDGID_CONVERTED=y
# CONFIG_UIDGID_STRICT_TYPE_CHECKS is not set
# CONFIG_SCHED_AUTOGROUP is not set
# CONFIG_SYSFS_DEPRECATED is not set
CONFIG_RELAY=y
CONFIG_BLK_DEV_INITRD=y
CONFIG_INITRAMFS_SOURCE=""
CONFIG_RD_GZIP=y
# CONFIG_RD_BZIP2 is not set
CONFIG_RD_LZMA=y
# CONFIG_RD_XZ is not set
# CONFIG_RD_LZO is not set
CONFIG_RD_LZ4=y
CONFIG_CC_OPTIMIZE_FOR_SIZE=y
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
# CONFIG_ELF_CORE is not set
CONFIG_PCSPKR_PLATFORM=y
CONFIG_BASE_FULL=y
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

#
# Kernel Performance Events And Counters
#
CONFIG_PERF_EVENTS=y
# CONFIG_DEBUG_PERF_USE_VMALLOC is not set
CONFIG_VM_EVENT_COUNTERS=y
# CONFIG_SLUB_DEBUG is not set
# CONFIG_COMPAT_BRK is not set
# CONFIG_SLAB is not set
CONFIG_SLUB=y
# CONFIG_SLOB is not set
CONFIG_SLUB_CPU_PARTIAL=y
# CONFIG_PROFILING is not set
CONFIG_HAVE_OPROFILE=y
CONFIG_OPROFILE_NMI_TIMER=y
# CONFIG_KPROBES is not set
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
CONFIG_GCOV_KERNEL=y
# CONFIG_GCOV_PROFILE_ALL is not set
CONFIG_HAVE_GENERIC_DMA_COHERENT=y
CONFIG_RT_MUTEXES=y
CONFIG_BASE_SMALL=0
CONFIG_MODULES=y
CONFIG_MODULE_FORCE_LOAD=y
CONFIG_MODULE_UNLOAD=y
CONFIG_MODULE_FORCE_UNLOAD=y
CONFIG_MODVERSIONS=y
# CONFIG_MODULE_SRCVERSION_ALL is not set
# CONFIG_MODULE_SIG is not set
CONFIG_STOP_MACHINE=y
# CONFIG_BLOCK is not set
CONFIG_PADATA=y
CONFIG_UNINLINE_SPIN_UNLOCK=y
# CONFIG_FREEZER is not set

#
# Processor type and features
#
# CONFIG_ZONE_DMA is not set
CONFIG_SMP=y
# CONFIG_X86_MPPARSE is not set
# CONFIG_X86_BIGSMP is not set
# CONFIG_X86_EXTENDED_PLATFORM is not set
# CONFIG_X86_INTEL_LPSS is not set
# CONFIG_X86_32_IRIS is not set
# CONFIG_SCHED_OMIT_FRAME_POINTER is not set
CONFIG_HYPERVISOR_GUEST=y
CONFIG_PARAVIRT=y
# CONFIG_PARAVIRT_DEBUG is not set
# CONFIG_PARAVIRT_SPINLOCKS is not set
# CONFIG_XEN_PRIVILEGED_GUEST is not set
CONFIG_KVM_GUEST=y
# CONFIG_LGUEST_GUEST is not set
# CONFIG_PARAVIRT_TIME_ACCOUNTING is not set
CONFIG_PARAVIRT_CLOCK=y
CONFIG_NO_BOOTMEM=y
CONFIG_MEMTEST=y
CONFIG_M486=y
# CONFIG_M586 is not set
# CONFIG_M586TSC is not set
# CONFIG_M586MMX is not set
# CONFIG_M686 is not set
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
CONFIG_X86_F00F_BUG=y
CONFIG_X86_INVD_BUG=y
CONFIG_X86_ALIGNMENT_16=y
CONFIG_X86_INTEL_USERCOPY=y
CONFIG_X86_MINIMUM_CPU_FAMILY=4
CONFIG_PROCESSOR_SELECT=y
CONFIG_CPU_SUP_INTEL=y
CONFIG_CPU_SUP_CYRIX_32=y
CONFIG_CPU_SUP_AMD=y
# CONFIG_CPU_SUP_CENTAUR is not set
# CONFIG_CPU_SUP_TRANSMETA_32 is not set
CONFIG_CPU_SUP_UMC_32=y
CONFIG_HPET_TIMER=y
CONFIG_HPET_EMULATE_RTC=y
# CONFIG_DMI is not set
CONFIG_NR_CPUS=8
CONFIG_SCHED_SMT=y
CONFIG_SCHED_MC=y
CONFIG_PREEMPT_NONE=y
# CONFIG_PREEMPT_VOLUNTARY is not set
# CONFIG_PREEMPT is not set
CONFIG_PREEMPT_COUNT=y
CONFIG_X86_LOCAL_APIC=y
CONFIG_X86_IO_APIC=y
# CONFIG_X86_REROUTE_FOR_BROKEN_BOOT_IRQS is not set
# CONFIG_X86_MCE is not set
# CONFIG_VM86 is not set
CONFIG_TOSHIBA=y
CONFIG_I8K=m
# CONFIG_X86_REBOOTFIXUPS is not set
CONFIG_MICROCODE=y
CONFIG_MICROCODE_INTEL=y
CONFIG_MICROCODE_AMD=y
CONFIG_MICROCODE_OLD_INTERFACE=y
CONFIG_MICROCODE_INTEL_LIB=y
CONFIG_MICROCODE_INTEL_EARLY=y
CONFIG_MICROCODE_AMD_EARLY=y
CONFIG_MICROCODE_EARLY=y
# CONFIG_X86_MSR is not set
# CONFIG_X86_CPUID is not set
# CONFIG_NOHIGHMEM is not set
CONFIG_HIGHMEM4G=y
# CONFIG_VMSPLIT_3G is not set
# CONFIG_VMSPLIT_3G_OPT is not set
# CONFIG_VMSPLIT_2G is not set
CONFIG_VMSPLIT_2G_OPT=y
# CONFIG_VMSPLIT_1G is not set
CONFIG_PAGE_OFFSET=0x78000000
CONFIG_HIGHMEM=y
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
CONFIG_SPLIT_PTLOCK_CPUS=999999
# CONFIG_COMPACTION is not set
# CONFIG_MIGRATION is not set
# CONFIG_PHYS_ADDR_T_64BIT is not set
CONFIG_ZONE_DMA_FLAG=0
CONFIG_VIRT_TO_BUS=y
CONFIG_KSM=y
CONFIG_DEFAULT_MMAP_MIN_ADDR=4096
# CONFIG_TRANSPARENT_HUGEPAGE is not set
CONFIG_CROSS_MEMORY_ATTACH=y
CONFIG_CLEANCACHE=y
# CONFIG_ZBUD is not set
CONFIG_HIGHPTE=y
CONFIG_X86_CHECK_BIOS_CORRUPTION=y
CONFIG_X86_BOOTPARAM_MEMORY_CORRUPTION_CHECK=y
CONFIG_X86_RESERVE_LOW=64
CONFIG_MATH_EMULATION=y
CONFIG_MTRR=y
CONFIG_MTRR_SANITIZER=y
CONFIG_MTRR_SANITIZER_ENABLE_DEFAULT=0
CONFIG_MTRR_SANITIZER_SPARE_REG_NR_DEFAULT=1
# CONFIG_X86_PAT is not set
# CONFIG_ARCH_RANDOM is not set
CONFIG_X86_SMAP=y
# CONFIG_EFI is not set
CONFIG_SECCOMP=y
CONFIG_CC_STACKPROTECTOR=y
CONFIG_HZ_100=y
# CONFIG_HZ_250 is not set
# CONFIG_HZ_300 is not set
# CONFIG_HZ_1000 is not set
CONFIG_HZ=100
# CONFIG_SCHED_HRTICK is not set
CONFIG_KEXEC=y
# CONFIG_CRASH_DUMP is not set
CONFIG_PHYSICAL_START=0x1000000
CONFIG_RELOCATABLE=y
CONFIG_X86_NEED_RELOCS=y
CONFIG_PHYSICAL_ALIGN=0x1000000
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
# CONFIG_SUSPEND is not set
CONFIG_PM_RUNTIME=y
CONFIG_PM=y
CONFIG_PM_DEBUG=y
CONFIG_PM_ADVANCED_DEBUG=y
# CONFIG_WQ_POWER_EFFICIENT_DEFAULT is not set
CONFIG_ACPI=y
# CONFIG_ACPI_PROCFS is not set
# CONFIG_ACPI_PROCFS_POWER is not set
# CONFIG_ACPI_EC_DEBUGFS is not set
CONFIG_ACPI_AC=y
CONFIG_ACPI_BATTERY=y
CONFIG_ACPI_BUTTON=y
CONFIG_ACPI_VIDEO=m
CONFIG_ACPI_FAN=y
# CONFIG_ACPI_DOCK is not set
CONFIG_ACPI_I2C=m
CONFIG_ACPI_PROCESSOR=y
# CONFIG_ACPI_IPMI is not set
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
CONFIG_SFI=y

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
CONFIG_CPU_FREQ_GOV_POWERSAVE=m
# CONFIG_CPU_FREQ_GOV_USERSPACE is not set
CONFIG_CPU_FREQ_GOV_ONDEMAND=y
CONFIG_CPU_FREQ_GOV_CONSERVATIVE=y

#
# x86 CPU frequency scaling drivers
#
CONFIG_X86_INTEL_PSTATE=y
# CONFIG_X86_PCC_CPUFREQ is not set
# CONFIG_X86_ACPI_CPUFREQ is not set
CONFIG_X86_POWERNOW_K6=m
CONFIG_X86_POWERNOW_K7=y
CONFIG_X86_POWERNOW_K7_ACPI=y
# CONFIG_X86_GX_SUSPMOD is not set
CONFIG_X86_SPEEDSTEP_CENTRINO=m
CONFIG_X86_SPEEDSTEP_CENTRINO_TABLE=y
CONFIG_X86_SPEEDSTEP_ICH=y
# CONFIG_X86_SPEEDSTEP_SMI is not set
CONFIG_X86_P4_CLOCKMOD=y
CONFIG_X86_CPUFREQ_NFORCE2=m
CONFIG_X86_LONGRUN=y
# CONFIG_X86_LONGHAUL is not set
# CONFIG_X86_E_POWERSAVER is not set

#
# shared options
#
CONFIG_X86_SPEEDSTEP_LIB=y
CONFIG_X86_SPEEDSTEP_RELAXED_CAP_CHECK=y

#
# CPU Idle
#
CONFIG_CPU_IDLE=y
CONFIG_CPU_IDLE_MULTIPLE_DRIVERS=y
# CONFIG_CPU_IDLE_GOV_LADDER is not set
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
# CONFIG_PCIEPORTBUS is not set
CONFIG_ARCH_SUPPORTS_MSI=y
# CONFIG_PCI_MSI is not set
# CONFIG_PCI_DEBUG is not set
# CONFIG_PCI_REALLOC_ENABLE_AUTO is not set
# CONFIG_PCI_STUB is not set
# CONFIG_HT_IRQ is not set
CONFIG_PCI_ATS=y
CONFIG_PCI_IOV=y
CONFIG_PCI_PRI=y
# CONFIG_PCI_PASID is not set
# CONFIG_PCI_IOAPIC is not set
CONFIG_PCI_LABEL=y

#
# PCI host controller drivers
#
CONFIG_ISA_DMA_API=y
CONFIG_ISA=y
# CONFIG_EISA is not set
CONFIG_SCx200=y
# CONFIG_SCx200HR_TIMER is not set
# CONFIG_OLPC is not set
CONFIG_ALIX=y
CONFIG_NET5501=y
CONFIG_AMD_NB=y
CONFIG_PCCARD=m
CONFIG_PCMCIA=m
CONFIG_PCMCIA_LOAD_CIS=y
# CONFIG_CARDBUS is not set

#
# PC-card bridges
#
CONFIG_YENTA=m
CONFIG_YENTA_O2=y
# CONFIG_YENTA_RICOH is not set
# CONFIG_YENTA_TI is not set
CONFIG_YENTA_TOSHIBA=y
CONFIG_PD6729=m
# CONFIG_I82092 is not set
CONFIG_I82365=m
CONFIG_TCIC=m
CONFIG_PCMCIA_PROBE=y
CONFIG_PCCARD_NONSTATIC=y
CONFIG_HOTPLUG_PCI=y
CONFIG_HOTPLUG_PCI_COMPAQ=m
# CONFIG_HOTPLUG_PCI_COMPAQ_NVRAM is not set
# CONFIG_HOTPLUG_PCI_IBM is not set
# CONFIG_HOTPLUG_PCI_ACPI is not set
CONFIG_HOTPLUG_PCI_CPCI=y
# CONFIG_HOTPLUG_PCI_CPCI_ZT5550 is not set
CONFIG_HOTPLUG_PCI_CPCI_GENERIC=y
CONFIG_HOTPLUG_PCI_SHPC=y
CONFIG_RAPIDIO=y
CONFIG_RAPIDIO_DISC_TIMEOUT=30
# CONFIG_RAPIDIO_ENABLE_RX_TX_PORTS is not set
CONFIG_RAPIDIO_DMA_ENGINE=y
CONFIG_RAPIDIO_DEBUG=y
# CONFIG_RAPIDIO_ENUM_BASIC is not set

#
# RapidIO Switch drivers
#
CONFIG_RAPIDIO_TSI57X=m
CONFIG_RAPIDIO_CPS_XX=y
CONFIG_RAPIDIO_TSI568=m
# CONFIG_RAPIDIO_CPS_GEN2 is not set

#
# Executable file formats / Emulations
#
CONFIG_BINFMT_ELF=y
CONFIG_ARCH_BINFMT_ELF_RANDOMIZE_PIE=y
CONFIG_BINFMT_SCRIPT=m
CONFIG_HAVE_AOUT=y
# CONFIG_BINFMT_AOUT is not set
CONFIG_BINFMT_MISC=m
CONFIG_COREDUMP=y
CONFIG_HAVE_ATOMIC_IOMAP=y
CONFIG_HAVE_TEXT_POKE_SMP=y
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
# CONFIG_BATMAN_ADV is not set
# CONFIG_OPENVSWITCH is not set
# CONFIG_VSOCKETS is not set
# CONFIG_NETLINK_MMAP is not set
# CONFIG_NETLINK_DIAG is not set
# CONFIG_NET_MPLS_GSO is not set
CONFIG_RPS=y
CONFIG_RFS_ACCEL=y
CONFIG_XPS=y
CONFIG_NET_RX_BUSY_POLL=y
CONFIG_BQL=y
CONFIG_NET_FLOW_LIMIT=y

#
# Network testing
#
# CONFIG_NET_PKTGEN is not set
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

#
# Device Drivers
#

#
# Generic Driver Options
#
CONFIG_UEVENT_HELPER_PATH=""
CONFIG_DEVTMPFS=y
# CONFIG_DEVTMPFS_MOUNT is not set
# CONFIG_STANDALONE is not set
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
CONFIG_REGMAP_I2C=m
CONFIG_REGMAP_MMIO=m
CONFIG_REGMAP_IRQ=y
CONFIG_DMA_SHARED_BUFFER=y
# CONFIG_CMA is not set

#
# Bus devices
#
# CONFIG_CONNECTOR is not set
CONFIG_MTD=m
CONFIG_MTD_TESTS=m
# CONFIG_MTD_REDBOOT_PARTS is not set
CONFIG_MTD_CMDLINE_PARTS=m
CONFIG_MTD_AR7_PARTS=m

#
# User Modules And Translation Layers
#
CONFIG_MTD_OOPS=m

#
# RAM/ROM/Flash chip drivers
#
CONFIG_MTD_CFI=m
CONFIG_MTD_JEDECPROBE=m
CONFIG_MTD_GEN_PROBE=m
CONFIG_MTD_CFI_ADV_OPTIONS=y
CONFIG_MTD_CFI_NOSWAP=y
# CONFIG_MTD_CFI_BE_BYTE_SWAP is not set
# CONFIG_MTD_CFI_LE_BYTE_SWAP is not set
# CONFIG_MTD_CFI_GEOMETRY is not set
CONFIG_MTD_MAP_BANK_WIDTH_1=y
CONFIG_MTD_MAP_BANK_WIDTH_2=y
CONFIG_MTD_MAP_BANK_WIDTH_4=y
# CONFIG_MTD_MAP_BANK_WIDTH_8 is not set
# CONFIG_MTD_MAP_BANK_WIDTH_16 is not set
# CONFIG_MTD_MAP_BANK_WIDTH_32 is not set
CONFIG_MTD_CFI_I1=y
CONFIG_MTD_CFI_I2=y
# CONFIG_MTD_CFI_I4 is not set
# CONFIG_MTD_CFI_I8 is not set
# CONFIG_MTD_OTP is not set
# CONFIG_MTD_CFI_INTELEXT is not set
# CONFIG_MTD_CFI_AMDSTD is not set
CONFIG_MTD_CFI_STAA=m
CONFIG_MTD_CFI_UTIL=m
CONFIG_MTD_RAM=m
# CONFIG_MTD_ROM is not set
CONFIG_MTD_ABSENT=m

#
# Mapping drivers for chip access
#
# CONFIG_MTD_COMPLEX_MAPPINGS is not set
CONFIG_MTD_PHYSMAP=m
CONFIG_MTD_PHYSMAP_COMPAT=y
CONFIG_MTD_PHYSMAP_START=0x8000000
CONFIG_MTD_PHYSMAP_LEN=0
CONFIG_MTD_PHYSMAP_BANKWIDTH=2
CONFIG_MTD_SC520CDP=m
# CONFIG_MTD_NETSC520 is not set
# CONFIG_MTD_TS5500 is not set
# CONFIG_MTD_SCx200_DOCFLASH is not set
CONFIG_MTD_AMD76XROM=m
# CONFIG_MTD_ICHXROM is not set
# CONFIG_MTD_ESB2ROM is not set
CONFIG_MTD_CK804XROM=m
CONFIG_MTD_SCB2_FLASH=m
# CONFIG_MTD_NETtel is not set
# CONFIG_MTD_L440GX is not set
CONFIG_MTD_INTEL_VR_NOR=m
CONFIG_MTD_PLATRAM=m

#
# Self-contained MTD device drivers
#
CONFIG_MTD_PMC551=m
# CONFIG_MTD_PMC551_BUGFIX is not set
# CONFIG_MTD_PMC551_DEBUG is not set
CONFIG_MTD_SLRAM=m
# CONFIG_MTD_PHRAM is not set
CONFIG_MTD_MTDRAM=m
CONFIG_MTDRAM_TOTAL_SIZE=4096
CONFIG_MTDRAM_ERASE_SIZE=128

#
# Disk-On-Chip Device Drivers
#
# CONFIG_MTD_DOCG3 is not set
CONFIG_MTD_NAND_ECC=m
# CONFIG_MTD_NAND_ECC_SMC is not set
CONFIG_MTD_NAND=m
# CONFIG_MTD_NAND_ECC_BCH is not set
# CONFIG_MTD_SM_COMMON is not set
# CONFIG_MTD_NAND_DENALI is not set
CONFIG_MTD_NAND_IDS=m
# CONFIG_MTD_NAND_RICOH is not set
CONFIG_MTD_NAND_DISKONCHIP=m
# CONFIG_MTD_NAND_DISKONCHIP_PROBE_ADVANCED is not set
CONFIG_MTD_NAND_DISKONCHIP_PROBE_ADDRESS=0
CONFIG_MTD_NAND_DISKONCHIP_BBTWRITE=y
# CONFIG_MTD_NAND_DOCG4 is not set
CONFIG_MTD_NAND_CAFE=m
CONFIG_MTD_NAND_CS553X=m
CONFIG_MTD_NAND_NANDSIM=m
# CONFIG_MTD_NAND_PLATFORM is not set
# CONFIG_MTD_ALAUDA is not set
CONFIG_MTD_ONENAND=m
CONFIG_MTD_ONENAND_VERIFY_WRITE=y
# CONFIG_MTD_ONENAND_GENERIC is not set
# CONFIG_MTD_ONENAND_OTP is not set
CONFIG_MTD_ONENAND_2X_PROGRAM=y

#
# LPDDR flash memory drivers
#
CONFIG_MTD_LPDDR=m
CONFIG_MTD_QINFO_PROBE=m
CONFIG_MTD_UBI=m
CONFIG_MTD_UBI_WL_THRESHOLD=4096
CONFIG_MTD_UBI_BEB_LIMIT=20
# CONFIG_MTD_UBI_FASTMAP is not set
CONFIG_MTD_UBI_GLUEBI=m
# CONFIG_PARPORT is not set
CONFIG_PNP=y
# CONFIG_PNP_DEBUG_MESSAGES is not set

#
# Protocols
#
# CONFIG_ISAPNP is not set
# CONFIG_PNPBIOS is not set
CONFIG_PNPACPI=y

#
# Misc devices
#
# CONFIG_SENSORS_LIS3LV02D is not set
CONFIG_AD525X_DPOT=m
CONFIG_AD525X_DPOT_I2C=m
CONFIG_DUMMY_IRQ=y
# CONFIG_IBM_ASM is not set
CONFIG_PHANTOM=y
# CONFIG_INTEL_MID_PTI is not set
CONFIG_SGI_IOC4=y
# CONFIG_TIFM_CORE is not set
CONFIG_ICS932S401=m
# CONFIG_ATMEL_SSC is not set
CONFIG_ENCLOSURE_SERVICES=m
# CONFIG_CS5535_MFGPT is not set
# CONFIG_HP_ILO is not set
CONFIG_APDS9802ALS=m
# CONFIG_ISL29003 is not set
CONFIG_ISL29020=m
CONFIG_SENSORS_TSL2550=m
CONFIG_SENSORS_BH1780=m
CONFIG_SENSORS_BH1770=m
# CONFIG_SENSORS_APDS990X is not set
CONFIG_HMC6352=m
CONFIG_DS1682=m
CONFIG_VMWARE_BALLOON=y
# CONFIG_BMP085_I2C is not set
# CONFIG_PCH_PHUB is not set
CONFIG_USB_SWITCH_FSA9480=m
CONFIG_SRAM=y
# CONFIG_C2PORT is not set

#
# EEPROM support
#
CONFIG_EEPROM_AT24=m
# CONFIG_EEPROM_LEGACY is not set
CONFIG_EEPROM_MAX6875=m
CONFIG_EEPROM_93CX6=m
CONFIG_CB710_CORE=y
# CONFIG_CB710_DEBUG is not set
CONFIG_CB710_DEBUG_ASSUMPTIONS=y

#
# Texas Instruments shared transport line discipline
#
# CONFIG_TI_ST is not set
# CONFIG_SENSORS_LIS3_I2C is not set

#
# Altera FPGA firmware download module
#
CONFIG_ALTERA_STAPL=m
CONFIG_INTEL_MEI=y
CONFIG_INTEL_MEI_ME=y
# CONFIG_VMWARE_VMCI is not set
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
CONFIG_FIREWIRE=m
CONFIG_FIREWIRE_OHCI=m
# CONFIG_FIREWIRE_NOSY is not set
# CONFIG_I2O is not set
# CONFIG_MACINTOSH_DRIVERS is not set
# CONFIG_NETDEVICES is not set
# CONFIG_VHOST_NET is not set

#
# Input device support
#
CONFIG_INPUT=y
# CONFIG_INPUT_FF_MEMLESS is not set
# CONFIG_INPUT_POLLDEV is not set
# CONFIG_INPUT_SPARSEKMAP is not set
# CONFIG_INPUT_MATRIXKMAP is not set

#
# Userland interfaces
#
CONFIG_INPUT_MOUSEDEV=y
CONFIG_INPUT_MOUSEDEV_PSAUX=y
CONFIG_INPUT_MOUSEDEV_SCREEN_X=1024
CONFIG_INPUT_MOUSEDEV_SCREEN_Y=768
# CONFIG_INPUT_JOYDEV is not set
# CONFIG_INPUT_EVDEV is not set
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
# CONFIG_KEYBOARD_GPIO is not set
# CONFIG_KEYBOARD_GPIO_POLLED is not set
# CONFIG_KEYBOARD_TCA6416 is not set
# CONFIG_KEYBOARD_TCA8418 is not set
# CONFIG_KEYBOARD_MATRIX is not set
# CONFIG_KEYBOARD_LM8323 is not set
# CONFIG_KEYBOARD_LM8333 is not set
# CONFIG_KEYBOARD_MAX7359 is not set
# CONFIG_KEYBOARD_MCS is not set
# CONFIG_KEYBOARD_MPR121 is not set
# CONFIG_KEYBOARD_NEWTON is not set
# CONFIG_KEYBOARD_OPENCORES is not set
# CONFIG_KEYBOARD_STOWAWAY is not set
# CONFIG_KEYBOARD_SUNKBD is not set
# CONFIG_KEYBOARD_XTKBD is not set
# CONFIG_KEYBOARD_CROS_EC is not set
CONFIG_INPUT_MOUSE=y
CONFIG_MOUSE_PS2=y
CONFIG_MOUSE_PS2_ALPS=y
CONFIG_MOUSE_PS2_LOGIPS2PP=y
CONFIG_MOUSE_PS2_SYNAPTICS=y
CONFIG_MOUSE_PS2_CYPRESS=y
CONFIG_MOUSE_PS2_TRACKPOINT=y
# CONFIG_MOUSE_PS2_ELANTECH is not set
# CONFIG_MOUSE_PS2_SENTELIC is not set
# CONFIG_MOUSE_PS2_TOUCHKIT is not set
# CONFIG_MOUSE_SERIAL is not set
# CONFIG_MOUSE_APPLETOUCH is not set
# CONFIG_MOUSE_BCM5974 is not set
# CONFIG_MOUSE_CYAPA is not set
# CONFIG_MOUSE_INPORT is not set
# CONFIG_MOUSE_LOGIBM is not set
# CONFIG_MOUSE_PC110PAD is not set
# CONFIG_MOUSE_VSXXXAA is not set
# CONFIG_MOUSE_GPIO is not set
# CONFIG_MOUSE_SYNAPTICS_I2C is not set
# CONFIG_MOUSE_SYNAPTICS_USB is not set
# CONFIG_INPUT_JOYSTICK is not set
# CONFIG_INPUT_TABLET is not set
# CONFIG_INPUT_TOUCHSCREEN is not set
# CONFIG_INPUT_MISC is not set

#
# Hardware I/O ports
#
CONFIG_SERIO=y
CONFIG_SERIO_I8042=y
CONFIG_SERIO_SERPORT=y
CONFIG_SERIO_CT82C710=m
CONFIG_SERIO_PCIPS2=m
CONFIG_SERIO_LIBPS2=y
CONFIG_SERIO_RAW=m
CONFIG_SERIO_ALTERA_PS2=m
# CONFIG_SERIO_PS2MULT is not set
CONFIG_SERIO_ARC_PS2=m
CONFIG_GAMEPORT=y
CONFIG_GAMEPORT_NS558=m
CONFIG_GAMEPORT_L4=y
# CONFIG_GAMEPORT_EMU10K1 is not set
CONFIG_GAMEPORT_FM801=m

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
# CONFIG_SERIAL_8250_CS is not set
CONFIG_SERIAL_8250_NR_UARTS=4
CONFIG_SERIAL_8250_RUNTIME_UARTS=4
# CONFIG_SERIAL_8250_EXTENDED is not set
# CONFIG_SERIAL_8250_DW is not set

#
# Non-8250 serial port support
#
# CONFIG_SERIAL_MFD_HSU is not set
# CONFIG_SERIAL_UARTLITE is not set
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
# CONFIG_VIRTIO_CONSOLE is not set
CONFIG_IPMI_HANDLER=y
CONFIG_IPMI_PANIC_EVENT=y
CONFIG_IPMI_PANIC_STRING=y
CONFIG_IPMI_DEVICE_INTERFACE=y
CONFIG_IPMI_SI=m
CONFIG_IPMI_WATCHDOG=y
# CONFIG_IPMI_POWEROFF is not set
# CONFIG_HW_RANDOM is not set
CONFIG_NVRAM=y
# CONFIG_DTLK is not set
# CONFIG_R3964 is not set
# CONFIG_APPLICOM is not set
# CONFIG_SONYPI is not set

#
# PCMCIA character devices
#
# CONFIG_SYNCLINK_CS is not set
CONFIG_CARDMAN_4000=m
CONFIG_CARDMAN_4040=m
# CONFIG_MWAVE is not set
CONFIG_SCx200_GPIO=m
CONFIG_PC8736x_GPIO=m
CONFIG_NSC_GPIO=y
# CONFIG_HPET is not set
CONFIG_HANGCHECK_TIMER=m
CONFIG_TCG_TPM=y
CONFIG_TCG_TIS=y
CONFIG_TCG_TIS_I2C_INFINEON=m
# CONFIG_TCG_NSC is not set
CONFIG_TCG_ATMEL=y
# CONFIG_TCG_INFINEON is not set
CONFIG_TCG_ST33_I2C=m
# CONFIG_TELCLOCK is not set
CONFIG_DEVPORT=y
CONFIG_I2C=m
CONFIG_I2C_BOARDINFO=y
# CONFIG_I2C_COMPAT is not set
CONFIG_I2C_CHARDEV=m
CONFIG_I2C_MUX=m

#
# Multiplexer I2C Chip support
#
CONFIG_I2C_MUX_GPIO=m
CONFIG_I2C_MUX_PCA9541=m
# CONFIG_I2C_MUX_PCA954x is not set
# CONFIG_I2C_HELPER_AUTO is not set
CONFIG_I2C_SMBUS=m

#
# I2C Algorithms
#
CONFIG_I2C_ALGOBIT=m
CONFIG_I2C_ALGOPCF=m
CONFIG_I2C_ALGOPCA=m

#
# I2C Hardware Bus support
#

#
# PC SMBus host controller drivers
#
# CONFIG_I2C_ALI1535 is not set
CONFIG_I2C_ALI1563=m
# CONFIG_I2C_ALI15X3 is not set
CONFIG_I2C_AMD756=m
# CONFIG_I2C_AMD756_S4882 is not set
CONFIG_I2C_AMD8111=m
# CONFIG_I2C_I801 is not set
CONFIG_I2C_ISCH=m
CONFIG_I2C_ISMT=m
CONFIG_I2C_PIIX4=m
CONFIG_I2C_NFORCE2=m
# CONFIG_I2C_NFORCE2_S4985 is not set
CONFIG_I2C_SIS5595=m
# CONFIG_I2C_SIS630 is not set
CONFIG_I2C_SIS96X=m
CONFIG_I2C_VIA=m
CONFIG_I2C_VIAPRO=m

#
# ACPI drivers
#
# CONFIG_I2C_SCMI is not set

#
# I2C system bus drivers (mostly embedded / system-on-chip)
#
# CONFIG_I2C_CBUS_GPIO is not set
# CONFIG_I2C_DESIGNWARE_PCI is not set
# CONFIG_I2C_EG20T is not set
CONFIG_I2C_GPIO=m
# CONFIG_I2C_KEMPLD is not set
# CONFIG_I2C_OCORES is not set
CONFIG_I2C_PCA_PLATFORM=m
# CONFIG_I2C_PXA_PCI is not set
CONFIG_I2C_SIMTEC=m
CONFIG_I2C_XILINX=m

#
# External I2C/SMBus adapter drivers
#
# CONFIG_I2C_DIOLAN_U2C is not set
CONFIG_I2C_PARPORT_LIGHT=m
# CONFIG_I2C_TAOS_EVM is not set
# CONFIG_I2C_TINY_USB is not set
CONFIG_I2C_VIPERBOARD=m

#
# Other I2C/SMBus bus drivers
#
# CONFIG_I2C_PCA_ISA is not set
# CONFIG_SCx200_I2C is not set
CONFIG_SCx200_ACB=m
CONFIG_I2C_STUB=m
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

#
# PPS clients support
#
CONFIG_PPS_CLIENT_KTIMER=m
# CONFIG_PPS_CLIENT_LDISC is not set
# CONFIG_PPS_CLIENT_GPIO is not set

#
# PPS generators support
#

#
# PTP clock support
#
# CONFIG_PTP_1588_CLOCK is not set

#
# Enable PHYLIB and NETWORK_PHY_TIMESTAMPING to see the additional clocks.
#
# CONFIG_PTP_1588_CLOCK_PCH is not set
CONFIG_ARCH_WANT_OPTIONAL_GPIOLIB=y
CONFIG_GPIO_DEVRES=y
CONFIG_GPIOLIB=y
CONFIG_GPIO_ACPI=y
CONFIG_DEBUG_GPIO=y
# CONFIG_GPIO_SYSFS is not set
CONFIG_GPIO_GENERIC=y
CONFIG_GPIO_MAX730X=m

#
# Memory mapped GPIO drivers:
#
CONFIG_GPIO_GENERIC_PLATFORM=y
# CONFIG_GPIO_IT8761E is not set
CONFIG_GPIO_TS5500=m
CONFIG_GPIO_SCH=y
CONFIG_GPIO_ICH=y
# CONFIG_GPIO_VX855 is not set
# CONFIG_GPIO_LYNXPOINT is not set

#
# I2C GPIO expanders:
#
CONFIG_GPIO_MAX7300=m
# CONFIG_GPIO_MAX732X is not set
CONFIG_GPIO_PCA953X=m
# CONFIG_GPIO_PCF857X is not set
# CONFIG_GPIO_ADP5588 is not set

#
# PCI GPIO expanders:
#
CONFIG_GPIO_CS5535=m
CONFIG_GPIO_BT8XX=m
# CONFIG_GPIO_AMD8111 is not set
CONFIG_GPIO_LANGWELL=y
CONFIG_GPIO_PCH=m
CONFIG_GPIO_ML_IOH=m
# CONFIG_GPIO_TIMBERDALE is not set
CONFIG_GPIO_RDC321X=y

#
# SPI GPIO expanders:
#
CONFIG_GPIO_MCP23S08=m

#
# AC97 GPIO expanders:
#

#
# MODULbus GPIO expanders:
#

#
# USB GPIO expanders:
#
# CONFIG_GPIO_VIPERBOARD is not set
CONFIG_W1=y

#
# 1-wire Bus Masters
#
CONFIG_W1_MASTER_MATROX=y
CONFIG_W1_MASTER_DS2490=m
CONFIG_W1_MASTER_DS2482=m
# CONFIG_W1_MASTER_DS1WM is not set
CONFIG_W1_MASTER_GPIO=y

#
# 1-wire Slaves
#
CONFIG_W1_SLAVE_THERM=m
# CONFIG_W1_SLAVE_SMEM is not set
# CONFIG_W1_SLAVE_DS2408 is not set
# CONFIG_W1_SLAVE_DS2413 is not set
CONFIG_W1_SLAVE_DS2423=y
CONFIG_W1_SLAVE_DS2431=m
CONFIG_W1_SLAVE_DS2433=m
CONFIG_W1_SLAVE_DS2433_CRC=y
CONFIG_W1_SLAVE_DS2760=m
CONFIG_W1_SLAVE_DS2780=y
CONFIG_W1_SLAVE_DS2781=y
# CONFIG_W1_SLAVE_DS28E04 is not set
CONFIG_W1_SLAVE_BQ27000=m
CONFIG_POWER_SUPPLY=y
# CONFIG_POWER_SUPPLY_DEBUG is not set
CONFIG_PDA_POWER=m
# CONFIG_GENERIC_ADC_BATTERY is not set
CONFIG_TEST_POWER=m
CONFIG_BATTERY_DS2760=m
CONFIG_BATTERY_DS2780=y
# CONFIG_BATTERY_DS2781 is not set
CONFIG_BATTERY_DS2782=m
# CONFIG_BATTERY_SBS is not set
CONFIG_BATTERY_BQ27x00=m
CONFIG_BATTERY_BQ27X00_I2C=y
CONFIG_BATTERY_BQ27X00_PLATFORM=y
CONFIG_BATTERY_MAX17040=m
CONFIG_BATTERY_MAX17042=m
CONFIG_CHARGER_PCF50633=m
CONFIG_CHARGER_ISP1704=m
CONFIG_CHARGER_MAX8903=m
CONFIG_CHARGER_LP8727=m
# CONFIG_CHARGER_GPIO is not set
# CONFIG_CHARGER_MANAGER is not set
# CONFIG_CHARGER_BQ2415X is not set
CONFIG_CHARGER_SMB347=m
CONFIG_BATTERY_GOLDFISH=y
CONFIG_POWER_RESET=y
CONFIG_POWER_AVS=y
CONFIG_HWMON=m
CONFIG_HWMON_VID=m
CONFIG_HWMON_DEBUG_CHIP=y

#
# Native drivers
#
CONFIG_SENSORS_AD7414=m
# CONFIG_SENSORS_AD7418 is not set
# CONFIG_SENSORS_ADM1021 is not set
# CONFIG_SENSORS_ADM1025 is not set
CONFIG_SENSORS_ADM1026=m
# CONFIG_SENSORS_ADM1029 is not set
CONFIG_SENSORS_ADM1031=m
# CONFIG_SENSORS_ADM9240 is not set
CONFIG_SENSORS_ADT7X10=m
CONFIG_SENSORS_ADT7410=m
CONFIG_SENSORS_ADT7411=m
CONFIG_SENSORS_ADT7462=m
# CONFIG_SENSORS_ADT7470 is not set
CONFIG_SENSORS_ADT7475=m
CONFIG_SENSORS_ASC7621=m
# CONFIG_SENSORS_K8TEMP is not set
CONFIG_SENSORS_K10TEMP=m
CONFIG_SENSORS_FAM15H_POWER=m
CONFIG_SENSORS_ASB100=m
CONFIG_SENSORS_ATXP1=m
# CONFIG_SENSORS_DS620 is not set
# CONFIG_SENSORS_DS1621 is not set
# CONFIG_SENSORS_I5K_AMB is not set
CONFIG_SENSORS_F71805F=m
# CONFIG_SENSORS_F71882FG is not set
CONFIG_SENSORS_F75375S=m
CONFIG_SENSORS_FSCHMD=m
CONFIG_SENSORS_G760A=m
# CONFIG_SENSORS_G762 is not set
CONFIG_SENSORS_GL518SM=m
# CONFIG_SENSORS_GL520SM is not set
CONFIG_SENSORS_GPIO_FAN=m
# CONFIG_SENSORS_HIH6130 is not set
CONFIG_SENSORS_HTU21=m
CONFIG_SENSORS_CORETEMP=m
CONFIG_SENSORS_IBMAEM=m
CONFIG_SENSORS_IBMPEX=m
# CONFIG_SENSORS_IIO_HWMON is not set
CONFIG_SENSORS_IT87=m
CONFIG_SENSORS_JC42=m
CONFIG_SENSORS_LINEAGE=m
# CONFIG_SENSORS_LM63 is not set
CONFIG_SENSORS_LM73=m
CONFIG_SENSORS_LM75=m
CONFIG_SENSORS_LM77=m
CONFIG_SENSORS_LM78=m
# CONFIG_SENSORS_LM80 is not set
CONFIG_SENSORS_LM83=m
CONFIG_SENSORS_LM85=m
CONFIG_SENSORS_LM87=m
CONFIG_SENSORS_LM90=m
CONFIG_SENSORS_LM92=m
CONFIG_SENSORS_LM93=m
CONFIG_SENSORS_LTC4151=m
# CONFIG_SENSORS_LTC4215 is not set
CONFIG_SENSORS_LTC4245=m
CONFIG_SENSORS_LTC4261=m
CONFIG_SENSORS_LM95234=m
CONFIG_SENSORS_LM95241=m
CONFIG_SENSORS_LM95245=m
CONFIG_SENSORS_MAX16065=m
CONFIG_SENSORS_MAX1619=m
CONFIG_SENSORS_MAX1668=m
CONFIG_SENSORS_MAX197=m
CONFIG_SENSORS_MAX6639=m
# CONFIG_SENSORS_MAX6642 is not set
# CONFIG_SENSORS_MAX6650 is not set
# CONFIG_SENSORS_MAX6697 is not set
CONFIG_SENSORS_MCP3021=m
CONFIG_SENSORS_NCT6775=m
CONFIG_SENSORS_NTC_THERMISTOR=m
CONFIG_SENSORS_PC87360=m
CONFIG_SENSORS_PC87427=m
CONFIG_SENSORS_PCF8591=m
# CONFIG_PMBUS is not set
# CONFIG_SENSORS_SHT15 is not set
# CONFIG_SENSORS_SHT21 is not set
CONFIG_SENSORS_SIS5595=m
# CONFIG_SENSORS_SMM665 is not set
# CONFIG_SENSORS_DME1737 is not set
CONFIG_SENSORS_EMC1403=m
# CONFIG_SENSORS_EMC2103 is not set
CONFIG_SENSORS_EMC6W201=m
# CONFIG_SENSORS_SMSC47M1 is not set
# CONFIG_SENSORS_SMSC47M192 is not set
# CONFIG_SENSORS_SMSC47B397 is not set
CONFIG_SENSORS_SCH56XX_COMMON=m
CONFIG_SENSORS_SCH5627=m
CONFIG_SENSORS_SCH5636=m
CONFIG_SENSORS_ADS1015=m
# CONFIG_SENSORS_ADS7828 is not set
# CONFIG_SENSORS_AMC6821 is not set
CONFIG_SENSORS_INA209=m
# CONFIG_SENSORS_INA2XX is not set
CONFIG_SENSORS_THMC50=m
CONFIG_SENSORS_TMP102=m
CONFIG_SENSORS_TMP401=m
CONFIG_SENSORS_TMP421=m
CONFIG_SENSORS_VIA_CPUTEMP=m
# CONFIG_SENSORS_VIA686A is not set
CONFIG_SENSORS_VT1211=m
CONFIG_SENSORS_VT8231=m
CONFIG_SENSORS_W83781D=m
CONFIG_SENSORS_W83791D=m
CONFIG_SENSORS_W83792D=m
CONFIG_SENSORS_W83793=m
CONFIG_SENSORS_W83795=m
CONFIG_SENSORS_W83795_FANCTRL=y
CONFIG_SENSORS_W83L785TS=m
CONFIG_SENSORS_W83L786NG=m
CONFIG_SENSORS_W83627HF=m
# CONFIG_SENSORS_W83627EHF is not set
# CONFIG_SENSORS_APPLESMC is not set
CONFIG_SENSORS_MC13783_ADC=m

#
# ACPI drivers
#
# CONFIG_SENSORS_ACPI_POWER is not set
# CONFIG_SENSORS_ATK0110 is not set
CONFIG_THERMAL=y
CONFIG_THERMAL_DEFAULT_GOV_STEP_WISE=y
# CONFIG_THERMAL_DEFAULT_GOV_FAIR_SHARE is not set
# CONFIG_THERMAL_DEFAULT_GOV_USER_SPACE is not set
# CONFIG_THERMAL_GOV_FAIR_SHARE is not set
CONFIG_THERMAL_GOV_STEP_WISE=y
# CONFIG_THERMAL_GOV_USER_SPACE is not set
# CONFIG_CPU_THERMAL is not set
# CONFIG_THERMAL_EMULATION is not set
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
CONFIG_SOFT_WATCHDOG=y
CONFIG_RETU_WATCHDOG=m
# CONFIG_ACQUIRE_WDT is not set
CONFIG_ADVANTECH_WDT=y
CONFIG_ALIM1535_WDT=m
CONFIG_ALIM7101_WDT=m
# CONFIG_F71808E_WDT is not set
CONFIG_SP5100_TCO=m
CONFIG_SC520_WDT=m
CONFIG_SBC_FITPC2_WATCHDOG=m
# CONFIG_EUROTECH_WDT is not set
# CONFIG_IB700_WDT is not set
CONFIG_IBMASR=y
# CONFIG_WAFER_WDT is not set
CONFIG_I6300ESB_WDT=y
# CONFIG_IE6XX_WDT is not set
# CONFIG_ITCO_WDT is not set
# CONFIG_IT8712F_WDT is not set
CONFIG_IT87_WDT=m
# CONFIG_HP_WATCHDOG is not set
CONFIG_KEMPLD_WDT=m
# CONFIG_SC1200_WDT is not set
# CONFIG_SCx200_WDT is not set
CONFIG_PC87413_WDT=y
CONFIG_NV_TCO=m
# CONFIG_60XX_WDT is not set
# CONFIG_SBC8360_WDT is not set
CONFIG_SBC7240_WDT=y
# CONFIG_CPU5_WDT is not set
CONFIG_SMSC_SCH311X_WDT=m
CONFIG_SMSC37B787_WDT=m
CONFIG_VIA_WDT=m
CONFIG_W83627HF_WDT=m
CONFIG_W83697HF_WDT=m
CONFIG_W83697UG_WDT=m
# CONFIG_W83877F_WDT is not set
CONFIG_W83977F_WDT=m
# CONFIG_MACHZ_WDT is not set
CONFIG_SBC_EPX_C3_WATCHDOG=m
CONFIG_MEN_A21_WDT=y

#
# ISA-based Watchdog Cards
#
CONFIG_PCWATCHDOG=y
# CONFIG_MIXCOMWD is not set
# CONFIG_WDT is not set

#
# PCI-based Watchdog Cards
#
CONFIG_PCIPCWATCHDOG=y
# CONFIG_WDTPCI is not set

#
# USB-based Watchdog Cards
#
CONFIG_USBPCWATCHDOG=m
CONFIG_SSB_POSSIBLE=y

#
# Sonics Silicon Backplane
#
CONFIG_SSB=y
CONFIG_SSB_PCIHOST_POSSIBLE=y
# CONFIG_SSB_PCIHOST is not set
CONFIG_SSB_SILENT=y
# CONFIG_SSB_DRIVER_GPIO is not set
CONFIG_BCMA_POSSIBLE=y

#
# Broadcom specific AMBA
#
CONFIG_BCMA=m
CONFIG_BCMA_HOST_PCI_POSSIBLE=y
CONFIG_BCMA_HOST_PCI=y
# CONFIG_BCMA_DRIVER_GMAC_CMN is not set
# CONFIG_BCMA_DRIVER_GPIO is not set
# CONFIG_BCMA_DEBUG is not set

#
# Multifunction device drivers
#
CONFIG_MFD_CORE=y
CONFIG_MFD_CS5535=y
CONFIG_MFD_CROS_EC=m
CONFIG_MFD_CROS_EC_I2C=m
CONFIG_MFD_MC13783=m
CONFIG_MFD_MC13XXX=m
CONFIG_MFD_MC13XXX_I2C=m
CONFIG_HTC_PASIC3=m
CONFIG_LPC_ICH=y
CONFIG_LPC_SCH=y
# CONFIG_MFD_JANZ_CMODIO is not set
CONFIG_MFD_KEMPLD=m
CONFIG_MFD_VIPERBOARD=m
CONFIG_MFD_RETU=m
CONFIG_MFD_PCF50633=m
CONFIG_PCF50633_ADC=m
# CONFIG_PCF50633_GPIO is not set
CONFIG_MFD_RDC321X=y
CONFIG_MFD_RTSX_PCI=y
# CONFIG_MFD_SI476X_CORE is not set
# CONFIG_MFD_SM501 is not set
# CONFIG_ABX500_CORE is not set
# CONFIG_MFD_SYSCON is not set
CONFIG_MFD_TI_AM335X_TSCADC=m
CONFIG_TPS6105X=m
# CONFIG_TPS65010 is not set
CONFIG_TPS6507X=m
CONFIG_MFD_TPS65217=m
# CONFIG_MFD_TPS65912 is not set
CONFIG_MFD_WL1273_CORE=m
# CONFIG_MFD_LM3533 is not set
CONFIG_MFD_TIMBERDALE=m
# CONFIG_MFD_TMIO is not set
CONFIG_MFD_VX855=m
# CONFIG_MFD_ARIZONA_I2C is not set
CONFIG_REGULATOR=y
CONFIG_REGULATOR_DEBUG=y
# CONFIG_REGULATOR_DUMMY is not set
CONFIG_REGULATOR_FIXED_VOLTAGE=m
CONFIG_REGULATOR_VIRTUAL_CONSUMER=m
CONFIG_REGULATOR_USERSPACE_CONSUMER=m
CONFIG_REGULATOR_AD5398=m
CONFIG_REGULATOR_DA9210=m
CONFIG_REGULATOR_FAN53555=m
CONFIG_REGULATOR_GPIO=m
CONFIG_REGULATOR_ISL6271A=m
CONFIG_REGULATOR_LP3971=m
CONFIG_REGULATOR_LP3972=m
CONFIG_REGULATOR_LP872X=m
# CONFIG_REGULATOR_LP8755 is not set
CONFIG_REGULATOR_MAX1586=m
# CONFIG_REGULATOR_MAX8649 is not set
CONFIG_REGULATOR_MAX8660=m
CONFIG_REGULATOR_MAX8952=m
# CONFIG_REGULATOR_MAX8973 is not set
CONFIG_REGULATOR_MC13XXX_CORE=m
# CONFIG_REGULATOR_MC13783 is not set
CONFIG_REGULATOR_MC13892=m
CONFIG_REGULATOR_PCF50633=m
# CONFIG_REGULATOR_PFUZE100 is not set
CONFIG_REGULATOR_TPS51632=m
CONFIG_REGULATOR_TPS6105X=m
# CONFIG_REGULATOR_TPS62360 is not set
CONFIG_REGULATOR_TPS65023=m
CONFIG_REGULATOR_TPS6507X=m
CONFIG_REGULATOR_TPS65217=m
CONFIG_MEDIA_SUPPORT=y

#
# Multimedia core support
#
# CONFIG_MEDIA_CAMERA_SUPPORT is not set
CONFIG_MEDIA_ANALOG_TV_SUPPORT=y
# CONFIG_MEDIA_DIGITAL_TV_SUPPORT is not set
CONFIG_MEDIA_RADIO_SUPPORT=y
# CONFIG_MEDIA_RC_SUPPORT is not set
CONFIG_VIDEO_DEV=y
CONFIG_VIDEO_V4L2=m
CONFIG_VIDEO_ADV_DEBUG=y
CONFIG_VIDEO_FIXED_MINOR_RANGES=y
CONFIG_VIDEO_TUNER=m
CONFIG_VIDEOBUF_GEN=m
CONFIG_VIDEOBUF_DMA_SG=m
CONFIG_VIDEOBUF2_CORE=m
CONFIG_VIDEOBUF2_MEMOPS=m
CONFIG_VIDEOBUF2_VMALLOC=m
CONFIG_VIDEO_V4L2_INT_DEVICE=m
# CONFIG_TTPCI_EEPROM is not set

#
# Media drivers
#
CONFIG_MEDIA_USB_SUPPORT=y

#
# Analog TV USB devices
#
# CONFIG_VIDEO_PVRUSB2 is not set
# CONFIG_VIDEO_HDPVR is not set
# CONFIG_VIDEO_USBVISION is not set
CONFIG_VIDEO_STK1160=m

#
# Analog/digital TV USB devices
#

#
# Webcam, TV (analog/digital) USB devices
#
CONFIG_VIDEO_EM28XX=m
CONFIG_MEDIA_PCI_SUPPORT=y

#
# Media capture/analog TV support
#
CONFIG_VIDEO_ZORAN=m
CONFIG_VIDEO_ZORAN_DC30=m
# CONFIG_VIDEO_ZORAN_ZR36060 is not set
# CONFIG_VIDEO_HEXIUM_GEMINI is not set
CONFIG_VIDEO_HEXIUM_ORION=m
CONFIG_VIDEO_MXB=m

#
# Media capture/analog/hybrid TV support
#
# CONFIG_VIDEO_CX25821 is not set
CONFIG_VIDEO_SAA7134=m

#
# Supported MMC/SDIO adapters
#
CONFIG_RADIO_ADAPTERS=y
# CONFIG_RADIO_SI470X is not set
CONFIG_USB_MR800=m
CONFIG_USB_DSBR=m
CONFIG_RADIO_SHARK2=m
CONFIG_I2C_SI4713=m
# CONFIG_RADIO_SI4713 is not set
CONFIG_USB_KEENE=m
# CONFIG_USB_MA901 is not set
CONFIG_RADIO_TEA5764=m
CONFIG_RADIO_SAA7706H=m
CONFIG_RADIO_TEF6862=m
CONFIG_RADIO_TIMBERDALE=m
CONFIG_RADIO_WL1273=m

#
# Texas Instruments WL128x FM driver (ST based)
#
# CONFIG_V4L_RADIO_ISA_DRIVERS is not set
CONFIG_VIDEO_TVEEPROM=m
CONFIG_CYPRESS_FIRMWARE=m
CONFIG_VIDEO_SAA7146=m
CONFIG_VIDEO_SAA7146_VV=m

#
# Media ancillary drivers (tuners, sensors, i2c, frontends)
#
CONFIG_MEDIA_SUBDRV_AUTOSELECT=y
CONFIG_MEDIA_ATTACH=y

#
# Audio decoders, processors and mixers
#
CONFIG_VIDEO_TDA9840=m
CONFIG_VIDEO_TEA6415C=m
CONFIG_VIDEO_TEA6420=m
CONFIG_VIDEO_MSP3400=m

#
# RDS decoders
#
CONFIG_VIDEO_SAA6588=m

#
# Video decoders
#
CONFIG_VIDEO_SAA711X=m
CONFIG_VIDEO_TVP5150=m
CONFIG_VIDEO_VPX3220=m

#
# Video and audio decoders
#

#
# Video encoders
#
CONFIG_VIDEO_ADV7175=m

#
# Camera sensor devices
#
CONFIG_VIDEO_MT9V011=m

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
CONFIG_MEDIA_TUNER=m
CONFIG_MEDIA_TUNER_SIMPLE=m
CONFIG_MEDIA_TUNER_TDA8290=m
CONFIG_MEDIA_TUNER_TDA827X=m
CONFIG_MEDIA_TUNER_TDA18271=m
CONFIG_MEDIA_TUNER_TDA9887=m
CONFIG_MEDIA_TUNER_TEA5761=m
CONFIG_MEDIA_TUNER_TEA5767=m
CONFIG_MEDIA_TUNER_MT20XX=m
CONFIG_MEDIA_TUNER_XC2028=m
CONFIG_MEDIA_TUNER_XC5000=m
CONFIG_MEDIA_TUNER_XC4000=m
CONFIG_MEDIA_TUNER_MC44S803=m

#
# Tools to develop new frontends
#
# CONFIG_DVB_DUMMY_FE is not set

#
# Graphics support
#
CONFIG_AGP=m
# CONFIG_AGP_ALI is not set
# CONFIG_AGP_ATI is not set
# CONFIG_AGP_AMD is not set
CONFIG_AGP_AMD64=m
CONFIG_AGP_INTEL=m
CONFIG_AGP_NVIDIA=m
# CONFIG_AGP_SIS is not set
CONFIG_AGP_SWORKS=m
CONFIG_AGP_VIA=m
CONFIG_AGP_EFFICEON=m
# CONFIG_VGA_ARB is not set
# CONFIG_VGA_SWITCHEROO is not set
CONFIG_DRM=m
CONFIG_DRM_USB=m
CONFIG_DRM_KMS_HELPER=m
CONFIG_DRM_LOAD_EDID_FIRMWARE=y
CONFIG_DRM_TTM=m

#
# I2C encoder or helper chips
#
# CONFIG_DRM_I2C_CH7006 is not set
CONFIG_DRM_I2C_SIL164=m
CONFIG_DRM_I2C_NXP_TDA998X=m
# CONFIG_DRM_TDFX is not set
CONFIG_DRM_R128=m
# CONFIG_DRM_RADEON is not set
CONFIG_DRM_NOUVEAU=m
CONFIG_NOUVEAU_DEBUG=5
CONFIG_NOUVEAU_DEBUG_DEFAULT=3
CONFIG_DRM_NOUVEAU_BACKLIGHT=y
# CONFIG_DRM_I810 is not set
# CONFIG_DRM_I915 is not set
CONFIG_DRM_MGA=m
CONFIG_DRM_SIS=m
CONFIG_DRM_VIA=m
# CONFIG_DRM_SAVAGE is not set
CONFIG_DRM_VMWGFX=m
# CONFIG_DRM_VMWGFX_FBCON is not set
# CONFIG_DRM_GMA500 is not set
CONFIG_DRM_UDL=m
CONFIG_DRM_AST=m
CONFIG_DRM_MGAG200=m
CONFIG_DRM_CIRRUS_QEMU=m
# CONFIG_DRM_QXL is not set
CONFIG_VGASTATE=m
CONFIG_VIDEO_OUTPUT_CONTROL=m
CONFIG_HDMI=y
CONFIG_FB=m
CONFIG_FIRMWARE_EDID=y
CONFIG_FB_DDC=m
# CONFIG_FB_BOOT_VESA_SUPPORT is not set
CONFIG_FB_CFB_FILLRECT=m
CONFIG_FB_CFB_COPYAREA=m
CONFIG_FB_CFB_IMAGEBLIT=m
# CONFIG_FB_CFB_REV_PIXELS_IN_BYTE is not set
CONFIG_FB_SYS_FILLRECT=m
CONFIG_FB_SYS_COPYAREA=m
CONFIG_FB_SYS_IMAGEBLIT=m
CONFIG_FB_FOREIGN_ENDIAN=y
CONFIG_FB_BOTH_ENDIAN=y
# CONFIG_FB_BIG_ENDIAN is not set
# CONFIG_FB_LITTLE_ENDIAN is not set
CONFIG_FB_SYS_FOPS=m
CONFIG_FB_DEFERRED_IO=y
CONFIG_FB_HECUBA=m
CONFIG_FB_SVGALIB=m
# CONFIG_FB_MACMODES is not set
CONFIG_FB_BACKLIGHT=y
CONFIG_FB_MODE_HELPERS=y
CONFIG_FB_TILEBLITTING=y

#
# Frame buffer hardware drivers
#
CONFIG_FB_CIRRUS=m
CONFIG_FB_PM2=m
# CONFIG_FB_PM2_FIFO_DISCONNECT is not set
CONFIG_FB_CYBER2000=m
# CONFIG_FB_CYBER2000_DDC is not set
# CONFIG_FB_ARC is not set
# CONFIG_FB_VGA16 is not set
CONFIG_FB_N411=m
CONFIG_FB_HGA=m
CONFIG_FB_S1D13XXX=m
CONFIG_FB_NVIDIA=m
CONFIG_FB_NVIDIA_I2C=y
CONFIG_FB_NVIDIA_DEBUG=y
CONFIG_FB_NVIDIA_BACKLIGHT=y
CONFIG_FB_RIVA=m
# CONFIG_FB_RIVA_I2C is not set
# CONFIG_FB_RIVA_DEBUG is not set
# CONFIG_FB_RIVA_BACKLIGHT is not set
CONFIG_FB_I740=m
CONFIG_FB_I810=m
CONFIG_FB_I810_GTF=y
# CONFIG_FB_I810_I2C is not set
# CONFIG_FB_LE80578 is not set
CONFIG_FB_INTEL=m
# CONFIG_FB_INTEL_DEBUG is not set
CONFIG_FB_INTEL_I2C=y
CONFIG_FB_MATROX=m
# CONFIG_FB_MATROX_MILLENIUM is not set
CONFIG_FB_MATROX_MYSTIQUE=y
CONFIG_FB_MATROX_G=y
CONFIG_FB_MATROX_I2C=m
# CONFIG_FB_MATROX_MAVEN is not set
CONFIG_FB_RADEON=m
CONFIG_FB_RADEON_I2C=y
# CONFIG_FB_RADEON_BACKLIGHT is not set
# CONFIG_FB_RADEON_DEBUG is not set
CONFIG_FB_ATY128=m
CONFIG_FB_ATY128_BACKLIGHT=y
CONFIG_FB_ATY=m
CONFIG_FB_ATY_CT=y
# CONFIG_FB_ATY_GENERIC_LCD is not set
# CONFIG_FB_ATY_GX is not set
# CONFIG_FB_ATY_BACKLIGHT is not set
CONFIG_FB_S3=m
CONFIG_FB_S3_DDC=y
# CONFIG_FB_SAVAGE is not set
CONFIG_FB_SIS=m
# CONFIG_FB_SIS_300 is not set
CONFIG_FB_SIS_315=y
# CONFIG_FB_VIA is not set
CONFIG_FB_NEOMAGIC=m
CONFIG_FB_KYRO=m
CONFIG_FB_3DFX=m
CONFIG_FB_3DFX_ACCEL=y
CONFIG_FB_3DFX_I2C=y
CONFIG_FB_VOODOO1=m
CONFIG_FB_VT8623=m
CONFIG_FB_TRIDENT=m
CONFIG_FB_ARK=m
CONFIG_FB_PM3=m
CONFIG_FB_CARMINE=m
# CONFIG_FB_CARMINE_DRAM_EVAL is not set
CONFIG_CARMINE_DRAM_CUSTOM=y
CONFIG_FB_GEODE=y
CONFIG_FB_GEODE_LX=m
CONFIG_FB_GEODE_GX=m
CONFIG_FB_GEODE_GX1=m
CONFIG_FB_TMIO=m
# CONFIG_FB_TMIO_ACCELL is not set
# CONFIG_FB_SMSCUFX is not set
CONFIG_FB_UDL=m
CONFIG_FB_GOLDFISH=m
CONFIG_FB_VIRTUAL=m
CONFIG_FB_METRONOME=m
CONFIG_FB_MB862XX=m
CONFIG_FB_MB862XX_PCI_GDC=y
# CONFIG_FB_MB862XX_I2C is not set
# CONFIG_FB_BROADSHEET is not set
CONFIG_FB_AUO_K190X=m
CONFIG_FB_AUO_K1900=m
CONFIG_FB_AUO_K1901=m
CONFIG_EXYNOS_VIDEO=y
CONFIG_BACKLIGHT_LCD_SUPPORT=y
CONFIG_LCD_CLASS_DEVICE=m
CONFIG_LCD_PLATFORM=m
CONFIG_BACKLIGHT_CLASS_DEVICE=m
# CONFIG_BACKLIGHT_GENERIC is not set
# CONFIG_BACKLIGHT_APPLE is not set
# CONFIG_BACKLIGHT_SAHARA is not set
CONFIG_BACKLIGHT_ADP8860=m
CONFIG_BACKLIGHT_ADP8870=m
# CONFIG_BACKLIGHT_PCF50633 is not set
# CONFIG_BACKLIGHT_LM3630 is not set
CONFIG_BACKLIGHT_LM3639=m
CONFIG_BACKLIGHT_LP855X=m
# CONFIG_BACKLIGHT_TPS65217 is not set
# CONFIG_LOGO is not set
# CONFIG_SOUND is not set

#
# HID support
#
CONFIG_HID=y
# CONFIG_HID_BATTERY_STRENGTH is not set
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
# CONFIG_HID_CYPRESS is not set
# CONFIG_HID_DRAGONRISE is not set
# CONFIG_HID_EMS_FF is not set
# CONFIG_HID_ELECOM is not set
# CONFIG_HID_ELO is not set
# CONFIG_HID_EZKEY is not set
# CONFIG_HID_HOLTEK is not set
# CONFIG_HID_HUION is not set
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
CONFIG_USB_HID=m
# CONFIG_HID_PID is not set
# CONFIG_USB_HIDDEV is not set

#
# USB HID Boot Protocol drivers
#
# CONFIG_USB_KBD is not set
# CONFIG_USB_MOUSE is not set

#
# I2C HID support
#
# CONFIG_I2C_HID is not set
CONFIG_USB_OHCI_LITTLE_ENDIAN=y
CONFIG_USB_SUPPORT=y
CONFIG_USB_COMMON=m
CONFIG_USB_ARCH_HAS_HCD=y
CONFIG_USB=m
# CONFIG_USB_DEBUG is not set
CONFIG_USB_ANNOUNCE_NEW_DEVICES=y

#
# Miscellaneous USB options
#
CONFIG_USB_DEFAULT_PERSIST=y
# CONFIG_USB_DYNAMIC_MINORS is not set
CONFIG_USB_OTG=y
# CONFIG_USB_OTG_WHITELIST is not set
CONFIG_USB_OTG_BLACKLIST_HUB=y
CONFIG_USB_MON=m
CONFIG_USB_WUSB=m
# CONFIG_USB_WUSB_CBAF is not set

#
# USB Host Controller Drivers
#
CONFIG_USB_C67X00_HCD=m
CONFIG_USB_XHCI_HCD=m
# CONFIG_USB_EHCI_HCD is not set
# CONFIG_USB_OXU210HP_HCD is not set
CONFIG_USB_ISP116X_HCD=m
CONFIG_USB_ISP1760_HCD=m
CONFIG_USB_ISP1362_HCD=m
CONFIG_USB_FUSBH200_HCD=m
CONFIG_USB_FOTG210_HCD=m
CONFIG_USB_OHCI_HCD=m
# CONFIG_USB_OHCI_HCD_PCI is not set
CONFIG_USB_OHCI_HCD_SSB=y
CONFIG_USB_OHCI_HCD_PLATFORM=m
# CONFIG_USB_UHCI_HCD is not set
CONFIG_USB_SL811_HCD=m
# CONFIG_USB_SL811_HCD_ISO is not set
# CONFIG_USB_SL811_CS is not set
CONFIG_USB_R8A66597_HCD=m
# CONFIG_USB_RENESAS_USBHS_HCD is not set
CONFIG_USB_WHCI_HCD=m
CONFIG_USB_HWA_HCD=m
CONFIG_USB_HCD_BCMA=m
CONFIG_USB_HCD_SSB=m
CONFIG_USB_HCD_TEST_MODE=y
# CONFIG_USB_MUSB_HDRC is not set
CONFIG_USB_RENESAS_USBHS=m

#
# USB Device Class drivers
#
# CONFIG_USB_ACM is not set
CONFIG_USB_PRINTER=m
# CONFIG_USB_WDM is not set
CONFIG_USB_TMC=m

#
# NOTE: USB_STORAGE depends on SCSI but BLK_DEV_SD may
#

#
# also be needed; see USB_STORAGE Help for more info
#

#
# USB Imaging devices
#
CONFIG_USB_MDC800=m
CONFIG_USB_CHIPIDEA=m
CONFIG_USB_CHIPIDEA_UDC=y
# CONFIG_USB_CHIPIDEA_DEBUG is not set

#
# USB port drivers
#
# CONFIG_USB_SERIAL is not set

#
# USB Miscellaneous drivers
#
# CONFIG_USB_EMI62 is not set
CONFIG_USB_EMI26=m
CONFIG_USB_ADUTUX=m
CONFIG_USB_SEVSEG=m
CONFIG_USB_RIO500=m
# CONFIG_USB_LEGOTOWER is not set
CONFIG_USB_LCD=m
CONFIG_USB_LED=m
CONFIG_USB_CYPRESS_CY7C63=m
CONFIG_USB_CYTHERM=m
CONFIG_USB_IDMOUSE=m
# CONFIG_USB_FTDI_ELAN is not set
CONFIG_USB_APPLEDISPLAY=m
# CONFIG_USB_LD is not set
# CONFIG_USB_TRANCEVIBRATOR is not set
CONFIG_USB_IOWARRIOR=m
CONFIG_USB_TEST=m
# CONFIG_USB_EHSET_TEST_FIXTURE is not set
# CONFIG_USB_ISIGHTFW is not set
# CONFIG_USB_YUREX is not set
# CONFIG_USB_EZUSB_FX2 is not set
CONFIG_USB_HSIC_USB3503=m

#
# USB Physical Layer drivers
#
CONFIG_USB_PHY=y
CONFIG_NOP_USB_XCEIV=m
CONFIG_OMAP_CONTROL_USB=m
CONFIG_OMAP_USB3=m
CONFIG_AM335X_CONTROL_USB=m
CONFIG_AM335X_PHY_USB=m
CONFIG_SAMSUNG_USBPHY=m
CONFIG_SAMSUNG_USB2PHY=m
# CONFIG_SAMSUNG_USB3PHY is not set
# CONFIG_USB_GPIO_VBUS is not set
CONFIG_USB_ISP1301=m
CONFIG_USB_RCAR_PHY=m
CONFIG_USB_GADGET=m
# CONFIG_USB_GADGET_DEBUG is not set
# CONFIG_USB_GADGET_DEBUG_FILES is not set
# CONFIG_USB_GADGET_DEBUG_FS is not set
CONFIG_USB_GADGET_VBUS_DRAW=2
CONFIG_USB_GADGET_STORAGE_NUM_BUFFERS=2

#
# USB Peripheral Controller
#
CONFIG_USB_FUSB300=m
CONFIG_USB_FOTG210_UDC=m
# CONFIG_USB_R8A66597 is not set
# CONFIG_USB_RENESAS_USBHS_UDC is not set
CONFIG_USB_PXA27X=m
# CONFIG_USB_MV_UDC is not set
CONFIG_USB_MV_U3D=m
CONFIG_USB_M66592=m
CONFIG_USB_AMD5536UDC=m
# CONFIG_USB_NET2272 is not set
CONFIG_USB_NET2280=m
CONFIG_USB_GOKU=m
# CONFIG_USB_EG20T is not set
CONFIG_USB_DUMMY_HCD=m
CONFIG_USB_LIBCOMPOSITE=m
CONFIG_USB_F_SS_LB=m
CONFIG_USB_CONFIGFS=m
# CONFIG_USB_CONFIGFS_SERIAL is not set
# CONFIG_USB_CONFIGFS_ACM is not set
# CONFIG_USB_CONFIGFS_OBEX is not set
# CONFIG_USB_CONFIGFS_NCM is not set
# CONFIG_USB_CONFIGFS_ECM is not set
# CONFIG_USB_CONFIGFS_ECM_SUBSET is not set
# CONFIG_USB_CONFIGFS_RNDIS is not set
# CONFIG_USB_CONFIGFS_EEM is not set
CONFIG_USB_ZERO=m
# CONFIG_USB_ZERO_HNPTEST is not set
# CONFIG_USB_ETH is not set
# CONFIG_USB_G_NCM is not set
# CONFIG_USB_GADGETFS is not set
CONFIG_USB_FUNCTIONFS=m
# CONFIG_USB_FUNCTIONFS_ETH is not set
# CONFIG_USB_FUNCTIONFS_RNDIS is not set
CONFIG_USB_FUNCTIONFS_GENERIC=y
# CONFIG_USB_G_SERIAL is not set
# CONFIG_USB_G_PRINTER is not set
# CONFIG_USB_CDC_COMPOSITE is not set
# CONFIG_USB_G_HID is not set
# CONFIG_USB_G_DBGP is not set
CONFIG_USB_G_WEBCAM=m
CONFIG_UWB=m
CONFIG_UWB_HWA=m
CONFIG_UWB_WHCI=m
CONFIG_UWB_I1480U=m
# CONFIG_MMC is not set
# CONFIG_MEMSTICK is not set
CONFIG_NEW_LEDS=y
CONFIG_LEDS_CLASS=y

#
# LED drivers
#
CONFIG_LEDS_LM3530=m
CONFIG_LEDS_LM3642=m
CONFIG_LEDS_NET48XX=m
CONFIG_LEDS_WRAP=m
# CONFIG_LEDS_PCA9532 is not set
CONFIG_LEDS_GPIO=m
CONFIG_LEDS_LP3944=m
CONFIG_LEDS_LP55XX_COMMON=m
# CONFIG_LEDS_LP5521 is not set
CONFIG_LEDS_LP5523=m
# CONFIG_LEDS_LP5562 is not set
# CONFIG_LEDS_PCA955X is not set
# CONFIG_LEDS_PCA9633 is not set
CONFIG_LEDS_REGULATOR=m
CONFIG_LEDS_BD2802=m
CONFIG_LEDS_LT3593=y
# CONFIG_LEDS_DELL_NETBOOKS is not set
CONFIG_LEDS_MC13783=m
# CONFIG_LEDS_TCA6507 is not set
CONFIG_LEDS_LM355x=m
# CONFIG_LEDS_OT200 is not set
# CONFIG_LEDS_BLINKM is not set

#
# LED Triggers
#
# CONFIG_LEDS_TRIGGERS is not set
CONFIG_ACCESSIBILITY=y
# CONFIG_INFINIBAND is not set
# CONFIG_EDAC is not set
CONFIG_RTC_LIB=y
CONFIG_RTC_CLASS=y
CONFIG_RTC_HCTOSYS=y
# CONFIG_RTC_SYSTOHC is not set
CONFIG_RTC_HCTOSYS_DEVICE="rtc0"
CONFIG_RTC_DEBUG=y

#
# RTC interfaces
#
CONFIG_RTC_INTF_SYSFS=y
CONFIG_RTC_INTF_PROC=y
CONFIG_RTC_INTF_DEV=y
# CONFIG_RTC_INTF_DEV_UIE_EMUL is not set
CONFIG_RTC_DRV_TEST=m

#
# I2C RTC drivers
#
# CONFIG_RTC_DRV_DS1307 is not set
CONFIG_RTC_DRV_DS1374=m
CONFIG_RTC_DRV_DS1672=m
CONFIG_RTC_DRV_DS3232=m
# CONFIG_RTC_DRV_MAX6900 is not set
# CONFIG_RTC_DRV_RS5C372 is not set
CONFIG_RTC_DRV_ISL1208=m
CONFIG_RTC_DRV_ISL12022=m
# CONFIG_RTC_DRV_X1205 is not set
# CONFIG_RTC_DRV_PCF2127 is not set
CONFIG_RTC_DRV_PCF8523=m
# CONFIG_RTC_DRV_PCF8563 is not set
# CONFIG_RTC_DRV_PCF8583 is not set
CONFIG_RTC_DRV_M41T80=m
# CONFIG_RTC_DRV_M41T80_WDT is not set
CONFIG_RTC_DRV_BQ32K=m
CONFIG_RTC_DRV_S35390A=m
# CONFIG_RTC_DRV_FM3130 is not set
CONFIG_RTC_DRV_RX8581=m
# CONFIG_RTC_DRV_RX8025 is not set
CONFIG_RTC_DRV_EM3027=m
CONFIG_RTC_DRV_RV3029C2=m

#
# SPI RTC drivers
#

#
# Platform RTC drivers
#
CONFIG_RTC_DRV_CMOS=y
# CONFIG_RTC_DRV_DS1286 is not set
# CONFIG_RTC_DRV_DS1511 is not set
CONFIG_RTC_DRV_DS1553=m
# CONFIG_RTC_DRV_DS1742 is not set
CONFIG_RTC_DRV_STK17TA8=y
CONFIG_RTC_DRV_M48T86=m
# CONFIG_RTC_DRV_M48T35 is not set
CONFIG_RTC_DRV_M48T59=y
CONFIG_RTC_DRV_MSM6242=m
CONFIG_RTC_DRV_BQ4802=y
CONFIG_RTC_DRV_RP5C01=m
# CONFIG_RTC_DRV_V3020 is not set
CONFIG_RTC_DRV_DS2404=m
CONFIG_RTC_DRV_PCF50633=m

#
# on-CPU RTC drivers
#
CONFIG_RTC_DRV_MC13XXX=m

#
# HID Sensor RTC drivers
#
# CONFIG_RTC_DRV_HID_SENSOR_TIME is not set
CONFIG_DMADEVICES=y
CONFIG_DMADEVICES_DEBUG=y
CONFIG_DMADEVICES_VDEBUG=y

#
# DMA Devices
#
CONFIG_INTEL_MID_DMAC=m
CONFIG_INTEL_IOATDMA=m
CONFIG_DW_DMAC_CORE=y
CONFIG_DW_DMAC=y
CONFIG_DW_DMAC_PCI=m
CONFIG_TIMB_DMA=m
CONFIG_PCH_DMA=m
CONFIG_DMA_ENGINE=y
CONFIG_DMA_ACPI=y

#
# DMA Clients
#
CONFIG_NET_DMA=y
CONFIG_ASYNC_TX_DMA=y
CONFIG_DMATEST=m
CONFIG_DCA=m
CONFIG_AUXDISPLAY=y
CONFIG_UIO=m
# CONFIG_UIO_CIF is not set
# CONFIG_UIO_PDRV_GENIRQ is not set
CONFIG_UIO_DMEM_GENIRQ=m
CONFIG_UIO_AEC=m
CONFIG_UIO_SERCOS3=m
CONFIG_UIO_PCI_GENERIC=m
CONFIG_UIO_NETX=m
CONFIG_UIO_MF624=m
CONFIG_VIRT_DRIVERS=y
CONFIG_VIRTIO=m

#
# Virtio drivers
#
CONFIG_VIRTIO_PCI=m
CONFIG_VIRTIO_BALLOON=m
# CONFIG_VIRTIO_MMIO is not set

#
# Microsoft Hyper-V guest support
#
# CONFIG_HYPERV is not set
# CONFIG_STAGING is not set
CONFIG_X86_PLATFORM_DEVICES=y
# CONFIG_ACER_WMI is not set
# CONFIG_ACERHDF is not set
# CONFIG_ASUS_LAPTOP is not set
# CONFIG_DELL_LAPTOP is not set
# CONFIG_DELL_WMI is not set
# CONFIG_DELL_WMI_AIO is not set
# CONFIG_FUJITSU_LAPTOP is not set
# CONFIG_FUJITSU_TABLET is not set
# CONFIG_TC1100_WMI is not set
# CONFIG_HP_ACCEL is not set
# CONFIG_HP_WMI is not set
# CONFIG_PANASONIC_LAPTOP is not set
# CONFIG_THINKPAD_ACPI is not set
# CONFIG_SENSORS_HDAPS is not set
# CONFIG_INTEL_MENLOW is not set
# CONFIG_EEEPC_LAPTOP is not set
# CONFIG_ASUS_WMI is not set
CONFIG_ACPI_WMI=m
# CONFIG_MSI_WMI is not set
# CONFIG_TOPSTAR_LAPTOP is not set
# CONFIG_ACPI_TOSHIBA is not set
# CONFIG_TOSHIBA_BT_RFKILL is not set
# CONFIG_ACPI_CMPC is not set
# CONFIG_INTEL_IPS is not set
CONFIG_IBM_RTL=m
# CONFIG_XO15_EBOOK is not set
CONFIG_SAMSUNG_LAPTOP=m
CONFIG_MXM_WMI=m
CONFIG_SAMSUNG_Q10=m
# CONFIG_APPLE_GMUX is not set
# CONFIG_INTEL_RST is not set
# CONFIG_INTEL_SMARTCONNECT is not set
# CONFIG_PVPANIC is not set

#
# Hardware Spinlock drivers
#
CONFIG_CLKSRC_I8253=y
CONFIG_CLKEVT_I8253=y
CONFIG_I8253_LOCK=y
CONFIG_CLKBLD_I8253=y
CONFIG_MAILBOX=y
CONFIG_IOMMU_SUPPORT=y

#
# Remoteproc drivers
#
CONFIG_REMOTEPROC=m
CONFIG_STE_MODEM_RPROC=m

#
# Rpmsg drivers
#
# CONFIG_PM_DEVFREQ is not set
# CONFIG_EXTCON is not set
# CONFIG_MEMORY is not set
CONFIG_IIO=m
CONFIG_IIO_BUFFER=y
CONFIG_IIO_BUFFER_CB=y
CONFIG_IIO_KFIFO_BUF=m
CONFIG_IIO_TRIGGERED_BUFFER=m
CONFIG_IIO_TRIGGER=y
CONFIG_IIO_CONSUMERS_PER_TRIGGER=2

#
# Accelerometers
#
# CONFIG_BMA180 is not set
CONFIG_IIO_ST_ACCEL_3AXIS=m
CONFIG_IIO_ST_ACCEL_I2C_3AXIS=m

#
# Analog to digital converters
#
CONFIG_MAX1363=m
CONFIG_NAU7802=m
CONFIG_TI_ADC081C=m
# CONFIG_TI_AM335X_ADC is not set
CONFIG_VIPERBOARD_ADC=m

#
# Amplifiers
#

#
# Hid Sensor IIO Common
#
CONFIG_IIO_ST_SENSORS_I2C=m
CONFIG_IIO_ST_SENSORS_CORE=m

#
# Digital to analog converters
#
CONFIG_AD5064=m
CONFIG_AD5380=m
# CONFIG_AD5446 is not set
CONFIG_MAX517=m
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
CONFIG_IIO_ST_GYRO_3AXIS=m
CONFIG_IIO_ST_GYRO_I2C_3AXIS=m
CONFIG_ITG3200=m

#
# Inertial measurement units
#
CONFIG_INV_MPU6050_IIO=m

#
# Light sensors
#
CONFIG_ADJD_S311=m
# CONFIG_APDS9300 is not set
CONFIG_SENSORS_TSL2563=m
CONFIG_VCNL4000=m

#
# Magnetometer sensors
#
CONFIG_AK8975=m
# CONFIG_IIO_ST_MAGN_3AXIS is not set

#
# Triggers - standalone
#
CONFIG_IIO_INTERRUPT_TRIGGER=m
CONFIG_IIO_SYSFS_TRIGGER=m

#
# Pressure sensors
#
CONFIG_IIO_ST_PRESS=m
CONFIG_IIO_ST_PRESS_I2C=m

#
# Temperature sensors
#
# CONFIG_TMP006 is not set
# CONFIG_VME_BUS is not set
# CONFIG_PWM is not set
CONFIG_IPACK_BUS=m
# CONFIG_BOARD_TPCI200 is not set
# CONFIG_SERIAL_IPOCTAL is not set
CONFIG_RESET_CONTROLLER=y
# CONFIG_FMC is not set

#
# Firmware Drivers
#
CONFIG_EDD=m
# CONFIG_EDD_OFF is not set
CONFIG_FIRMWARE_MEMMAP=y
CONFIG_DELL_RBU=m
CONFIG_DCDBAS=m
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
CONFIG_EXPORTFS=y
CONFIG_FILE_LOCKING=y
# CONFIG_FSNOTIFY is not set
# CONFIG_DNOTIFY is not set
# CONFIG_INOTIFY_USER is not set
# CONFIG_FANOTIFY is not set
# CONFIG_QUOTA is not set
# CONFIG_QUOTACTL is not set
# CONFIG_AUTOFS4_FS is not set
CONFIG_FUSE_FS=m
CONFIG_CUSE=m

#
# Caches
#
# CONFIG_FSCACHE is not set

#
# Pseudo filesystems
#
CONFIG_PROC_FS=y
# CONFIG_PROC_KCORE is not set
# CONFIG_PROC_SYSCTL is not set
CONFIG_PROC_PAGE_MONITOR=y
CONFIG_SYSFS=y
# CONFIG_HUGETLBFS is not set
# CONFIG_HUGETLB_PAGE is not set
CONFIG_CONFIGFS_FS=m
# CONFIG_MISC_FILESYSTEMS is not set
CONFIG_NETWORK_FILESYSTEMS=y
CONFIG_NLS=y
CONFIG_NLS_DEFAULT="iso8859-1"
CONFIG_NLS_CODEPAGE_437=m
CONFIG_NLS_CODEPAGE_737=m
# CONFIG_NLS_CODEPAGE_775 is not set
# CONFIG_NLS_CODEPAGE_850 is not set
# CONFIG_NLS_CODEPAGE_852 is not set
CONFIG_NLS_CODEPAGE_855=m
CONFIG_NLS_CODEPAGE_857=m
CONFIG_NLS_CODEPAGE_860=m
# CONFIG_NLS_CODEPAGE_861 is not set
CONFIG_NLS_CODEPAGE_862=m
# CONFIG_NLS_CODEPAGE_863 is not set
# CONFIG_NLS_CODEPAGE_864 is not set
CONFIG_NLS_CODEPAGE_865=m
CONFIG_NLS_CODEPAGE_866=m
CONFIG_NLS_CODEPAGE_869=m
CONFIG_NLS_CODEPAGE_936=m
CONFIG_NLS_CODEPAGE_950=m
CONFIG_NLS_CODEPAGE_932=m
# CONFIG_NLS_CODEPAGE_949 is not set
CONFIG_NLS_CODEPAGE_874=m
CONFIG_NLS_ISO8859_8=m
CONFIG_NLS_CODEPAGE_1250=m
CONFIG_NLS_CODEPAGE_1251=m
# CONFIG_NLS_ASCII is not set
# CONFIG_NLS_ISO8859_1 is not set
# CONFIG_NLS_ISO8859_2 is not set
CONFIG_NLS_ISO8859_3=m
# CONFIG_NLS_ISO8859_4 is not set
CONFIG_NLS_ISO8859_5=m
# CONFIG_NLS_ISO8859_6 is not set
CONFIG_NLS_ISO8859_7=m
CONFIG_NLS_ISO8859_9=m
CONFIG_NLS_ISO8859_13=m
CONFIG_NLS_ISO8859_14=m
CONFIG_NLS_ISO8859_15=m
# CONFIG_NLS_KOI8_R is not set
CONFIG_NLS_KOI8_U=m
CONFIG_NLS_MAC_ROMAN=m
# CONFIG_NLS_MAC_CELTIC is not set
CONFIG_NLS_MAC_CENTEURO=m
CONFIG_NLS_MAC_CROATIAN=m
CONFIG_NLS_MAC_CYRILLIC=m
CONFIG_NLS_MAC_GAELIC=m
# CONFIG_NLS_MAC_GREEK is not set
CONFIG_NLS_MAC_ICELAND=m
# CONFIG_NLS_MAC_INUIT is not set
# CONFIG_NLS_MAC_ROMANIAN is not set
# CONFIG_NLS_MAC_TURKISH is not set
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
CONFIG_ENABLE_WARN_DEPRECATED=y
CONFIG_ENABLE_MUST_CHECK=y
CONFIG_FRAME_WARN=1024
CONFIG_STRIP_ASM_SYMS=y
CONFIG_READABLE_ASM=y
# CONFIG_UNUSED_SYMBOLS is not set
CONFIG_DEBUG_FS=y
# CONFIG_HEADERS_CHECK is not set
# CONFIG_DEBUG_SECTION_MISMATCH is not set
CONFIG_ARCH_WANT_FRAME_POINTERS=y
CONFIG_FRAME_POINTER=y
# CONFIG_DEBUG_FORCE_WEAK_PER_CPU is not set
CONFIG_MAGIC_SYSRQ=y
CONFIG_DEBUG_KERNEL=y

#
# Memory Debugging
#
CONFIG_DEBUG_PAGEALLOC=y
CONFIG_WANT_PAGE_DEBUG_FLAGS=y
CONFIG_PAGE_GUARD=y
CONFIG_DEBUG_OBJECTS=y
# CONFIG_DEBUG_OBJECTS_SELFTEST is not set
# CONFIG_DEBUG_OBJECTS_FREE is not set
CONFIG_DEBUG_OBJECTS_TIMERS=y
CONFIG_DEBUG_OBJECTS_WORK=y
# CONFIG_DEBUG_OBJECTS_RCU_HEAD is not set
CONFIG_DEBUG_OBJECTS_PERCPU_COUNTER=y
CONFIG_DEBUG_OBJECTS_ENABLE_DEFAULT=1
# CONFIG_SLUB_STATS is not set
CONFIG_HAVE_DEBUG_KMEMLEAK=y
# CONFIG_DEBUG_KMEMLEAK is not set
# CONFIG_DEBUG_STACK_USAGE is not set
# CONFIG_DEBUG_VM is not set
# CONFIG_DEBUG_VIRTUAL is not set
CONFIG_DEBUG_MEMORY_INIT=y
CONFIG_MEMORY_NOTIFIER_ERROR_INJECT=m
# CONFIG_DEBUG_PER_CPU_MAPS is not set
CONFIG_DEBUG_HIGHMEM=y
CONFIG_HAVE_DEBUG_STACKOVERFLOW=y
CONFIG_DEBUG_STACKOVERFLOW=y
CONFIG_HAVE_ARCH_KMEMCHECK=y
# CONFIG_DEBUG_SHIRQ is not set

#
# Debug Lockups and Hangs
#
CONFIG_LOCKUP_DETECTOR=y
CONFIG_HARDLOCKUP_DETECTOR=y
# CONFIG_BOOTPARAM_HARDLOCKUP_PANIC is not set
CONFIG_BOOTPARAM_HARDLOCKUP_PANIC_VALUE=0
# CONFIG_BOOTPARAM_SOFTLOCKUP_PANIC is not set
CONFIG_BOOTPARAM_SOFTLOCKUP_PANIC_VALUE=0
CONFIG_DETECT_HUNG_TASK=y
CONFIG_DEFAULT_HUNG_TASK_TIMEOUT=120
CONFIG_BOOTPARAM_HUNG_TASK_PANIC=y
CONFIG_BOOTPARAM_HUNG_TASK_PANIC_VALUE=1
# CONFIG_PANIC_ON_OOPS is not set
CONFIG_PANIC_ON_OOPS_VALUE=0
# CONFIG_SCHED_DEBUG is not set
CONFIG_SCHEDSTATS=y
CONFIG_TIMER_STATS=y

#
# Lock Debugging (spinlocks, mutexes, etc...)
#
CONFIG_DEBUG_RT_MUTEXES=y
CONFIG_DEBUG_PI_LIST=y
CONFIG_RT_MUTEX_TESTER=y
CONFIG_DEBUG_SPINLOCK=y
CONFIG_DEBUG_MUTEXES=y
CONFIG_DEBUG_WW_MUTEX_SLOWPATH=y
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
CONFIG_DEBUG_KOBJECT_RELEASE=y
CONFIG_DEBUG_BUGVERBOSE=y
# CONFIG_DEBUG_WRITECOUNT is not set
CONFIG_DEBUG_LIST=y
# CONFIG_DEBUG_SG is not set
# CONFIG_DEBUG_NOTIFIERS is not set
# CONFIG_DEBUG_CREDENTIALS is not set

#
# RCU Debugging
#
# CONFIG_PROVE_RCU is not set
# CONFIG_SPARSE_RCU_POINTER is not set
# CONFIG_RCU_TORTURE_TEST is not set
CONFIG_RCU_CPU_STALL_TIMEOUT=21
# CONFIG_RCU_CPU_STALL_INFO is not set
# CONFIG_RCU_TRACE is not set
CONFIG_NOTIFIER_ERROR_INJECTION=y
# CONFIG_CPU_NOTIFIER_ERROR_INJECT is not set
CONFIG_PM_NOTIFIER_ERROR_INJECT=y
# CONFIG_FAULT_INJECTION is not set
# CONFIG_LATENCYTOP is not set
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
CONFIG_RBTREE_TEST=m
CONFIG_INTERVAL_TREE_TEST=m
# CONFIG_ATOMIC64_SELFTEST is not set
CONFIG_TEST_STRING_HELPERS=m
CONFIG_TEST_KSTRTOX=m
CONFIG_PROVIDE_OHCI1394_DMA_INIT=y
CONFIG_FIREWIRE_OHCI_REMOTE_DMA=y
# CONFIG_DMA_API_DEBUG is not set
# CONFIG_SAMPLES is not set
CONFIG_HAVE_ARCH_KGDB=y
# CONFIG_KGDB is not set
# CONFIG_STRICT_DEVMEM is not set
# CONFIG_X86_VERBOSE_BOOTUP is not set
# CONFIG_EARLY_PRINTK is not set
CONFIG_X86_PTDUMP=y
CONFIG_DEBUG_RODATA=y
# CONFIG_DEBUG_RODATA_TEST is not set
# CONFIG_DEBUG_SET_MODULE_RONX is not set
CONFIG_DEBUG_NX_TEST=m
# CONFIG_DOUBLEFAULT is not set
CONFIG_DEBUG_TLBFLUSH=y
# CONFIG_IOMMU_STRESS is not set
CONFIG_HAVE_MMIOTRACE_SUPPORT=y
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
# CONFIG_DEBUG_NMI_SELFTEST is not set
# CONFIG_X86_DEBUG_STATIC_CPU_HAS is not set

#
# Security options
#
# CONFIG_KEYS is not set
CONFIG_SECURITY_DMESG_RESTRICT=y
CONFIG_SECURITY=y
CONFIG_SECURITYFS=y
CONFIG_SECURITY_NETWORK=y
CONFIG_SECURITY_PATH=y
# CONFIG_SECURITY_TOMOYO is not set
# CONFIG_SECURITY_APPARMOR is not set
CONFIG_SECURITY_YAMA=y
CONFIG_SECURITY_YAMA_STACKED=y
CONFIG_INTEGRITY=y
CONFIG_IMA=y
CONFIG_IMA_MEASURE_PCR_IDX=10
CONFIG_IMA_APPRAISE=y
CONFIG_DEFAULT_SECURITY_YAMA=y
# CONFIG_DEFAULT_SECURITY_DAC is not set
CONFIG_DEFAULT_SECURITY="yama"
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
CONFIG_CRYPTO_MANAGER_DISABLE_TESTS=y
CONFIG_CRYPTO_GF128MUL=y
# CONFIG_CRYPTO_NULL is not set
CONFIG_CRYPTO_PCRYPT=m
CONFIG_CRYPTO_WORKQUEUE=y
CONFIG_CRYPTO_CRYPTD=y
CONFIG_CRYPTO_AUTHENC=m
# CONFIG_CRYPTO_TEST is not set
CONFIG_CRYPTO_ABLK_HELPER_X86=y
CONFIG_CRYPTO_GLUE_HELPER_X86=m

#
# Authenticated Encryption with Associated Data
#
CONFIG_CRYPTO_CCM=y
# CONFIG_CRYPTO_GCM is not set
CONFIG_CRYPTO_SEQIV=y

#
# Block modes
#
CONFIG_CRYPTO_CBC=m
CONFIG_CRYPTO_CTR=y
CONFIG_CRYPTO_CTS=y
# CONFIG_CRYPTO_ECB is not set
CONFIG_CRYPTO_LRW=y
CONFIG_CRYPTO_PCBC=m
CONFIG_CRYPTO_XTS=y

#
# Hash modes
#
CONFIG_CRYPTO_CMAC=m
CONFIG_CRYPTO_HMAC=y
# CONFIG_CRYPTO_XCBC is not set
# CONFIG_CRYPTO_VMAC is not set

#
# Digest
#
CONFIG_CRYPTO_CRC32C=y
CONFIG_CRYPTO_CRC32C_INTEL=m
CONFIG_CRYPTO_CRC32=y
# CONFIG_CRYPTO_CRC32_PCLMUL is not set
# CONFIG_CRYPTO_GHASH is not set
CONFIG_CRYPTO_MD4=m
CONFIG_CRYPTO_MD5=y
# CONFIG_CRYPTO_MICHAEL_MIC is not set
# CONFIG_CRYPTO_RMD128 is not set
# CONFIG_CRYPTO_RMD160 is not set
CONFIG_CRYPTO_RMD256=m
# CONFIG_CRYPTO_RMD320 is not set
CONFIG_CRYPTO_SHA1=y
# CONFIG_CRYPTO_SHA256 is not set
CONFIG_CRYPTO_SHA512=y
CONFIG_CRYPTO_TGR192=y
# CONFIG_CRYPTO_WP512 is not set

#
# Ciphers
#
CONFIG_CRYPTO_AES=y
CONFIG_CRYPTO_AES_586=y
CONFIG_CRYPTO_AES_NI_INTEL=y
CONFIG_CRYPTO_ANUBIS=m
CONFIG_CRYPTO_ARC4=y
CONFIG_CRYPTO_BLOWFISH=m
CONFIG_CRYPTO_BLOWFISH_COMMON=m
CONFIG_CRYPTO_CAMELLIA=m
CONFIG_CRYPTO_CAST_COMMON=y
CONFIG_CRYPTO_CAST5=y
CONFIG_CRYPTO_CAST6=m
# CONFIG_CRYPTO_DES is not set
CONFIG_CRYPTO_FCRYPT=m
CONFIG_CRYPTO_KHAZAD=m
CONFIG_CRYPTO_SALSA20=m
CONFIG_CRYPTO_SALSA20_586=y
CONFIG_CRYPTO_SEED=y
CONFIG_CRYPTO_SERPENT=m
CONFIG_CRYPTO_SERPENT_SSE2_586=m
CONFIG_CRYPTO_TEA=m
CONFIG_CRYPTO_TWOFISH=m
CONFIG_CRYPTO_TWOFISH_COMMON=y
CONFIG_CRYPTO_TWOFISH_586=y

#
# Compression
#
CONFIG_CRYPTO_DEFLATE=y
CONFIG_CRYPTO_ZLIB=y
CONFIG_CRYPTO_LZO=y
CONFIG_CRYPTO_LZ4=y
CONFIG_CRYPTO_LZ4HC=y

#
# Random Number Generation
#
# CONFIG_CRYPTO_ANSI_CPRNG is not set
# CONFIG_CRYPTO_USER_API_HASH is not set
# CONFIG_CRYPTO_USER_API_SKCIPHER is not set
# CONFIG_CRYPTO_HW is not set
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
# CONFIG_CRC_CCITT is not set
CONFIG_CRC16=y
# CONFIG_CRC_T10DIF is not set
CONFIG_CRC_ITU_T=m
CONFIG_CRC32=y
CONFIG_CRC32_SELFTEST=y
# CONFIG_CRC32_SLICEBY8 is not set
CONFIG_CRC32_SLICEBY4=y
# CONFIG_CRC32_SARWATE is not set
# CONFIG_CRC32_BIT is not set
CONFIG_CRC7=y
CONFIG_LIBCRC32C=y
# CONFIG_CRC8 is not set
CONFIG_ZLIB_INFLATE=y
CONFIG_ZLIB_DEFLATE=y
CONFIG_LZO_COMPRESS=y
CONFIG_LZO_DECOMPRESS=y
CONFIG_LZ4_COMPRESS=y
CONFIG_LZ4HC_COMPRESS=y
CONFIG_LZ4_DECOMPRESS=y
CONFIG_XZ_DEC=m
CONFIG_XZ_DEC_X86=y
CONFIG_XZ_DEC_POWERPC=y
# CONFIG_XZ_DEC_IA64 is not set
# CONFIG_XZ_DEC_ARM is not set
CONFIG_XZ_DEC_ARMTHUMB=y
CONFIG_XZ_DEC_SPARC=y
CONFIG_XZ_DEC_BCJ=y
CONFIG_XZ_DEC_TEST=m
CONFIG_DECOMPRESS_GZIP=y
CONFIG_DECOMPRESS_LZMA=y
CONFIG_DECOMPRESS_LZ4=y
CONFIG_GENERIC_ALLOCATOR=y
CONFIG_REED_SOLOMON=m
CONFIG_REED_SOLOMON_DEC16=y
CONFIG_HAS_IOMEM=y
CONFIG_HAS_IOPORT=y
CONFIG_HAS_DMA=y
CONFIG_CPU_RMAP=y
CONFIG_DQL=y
CONFIG_NLATTR=y
CONFIG_ARCH_HAS_ATOMIC64_DEC_IF_POSITIVE=y
CONFIG_AVERAGE=y
CONFIG_CORDIC=y
# CONFIG_DDR is not set

--gj572EiMnwbLXET9--
