Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752154Ab3JFIZJ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Oct 2013 04:25:09 -0400
Received: from mga01.intel.com ([192.55.52.88]:20282 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751467Ab3JFIYW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Oct 2013 04:24:22 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.90,1043,1371106800"; 
   d="log'?scan'208";a="406038430"
Date: Sun, 6 Oct 2013 15:58:11 +0800
From: Fengguang Wu <fengguang.wu@intel.com>
To: Russell King <rmk+kernel@arm.linux.org.uk>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Subject: BUG: sleeping function called from invalid context at mm/slab.c:3060
Message-ID: <20131006075811.GA22562@localhost>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="SLDf9lqlvOQaIe6s"
Content-Disposition: inline
User-Agent: Heirloom mailx 12.5 6/20/10
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--SLDf9lqlvOQaIe6s
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

mount: mounting proc on /proc failed: No such device
grep: /proc/filesystems: No such file or directory
[    4.188118] BUG: sleeping function called from invalid context at mm/slab.c:3060
[    4.190236] in_atomic(): 1, irqs_disabled(): 0, pid: 0, name: swapper/0
[    4.191696] 1 lock held by swapper/0/0:
Starting Bootlog daemon: 
[    4.192991]  #0:  (H

git bisect start 45c4ea0c4c1b8abffb575b865243fd1c69bbecd9 v3.11 --
git bisect  bad 39eda2aba6be642b71f2e0ad623dcb09fd9d79cf  # 03:04      0-  Merge branch 'next' of git://git.kernel.org/pub/scm/linux/kernel/git/benh/powerpc
git bisect  bad aa7054f5a5a9ff728ce291cb103afa19f4f849eb  # 03:16    160-  Merge tag 'pinctrl-v3.12-1' of git://git.kernel.org/pub/scm/linux/kernel/git/linusw/linux-pinctrl
git bisect  bad 751144271f4b63d5de9005ea4e5e6e5c7c6fd629  # 03:40    110-  Merge tag 'staging-3.12-rc1' of git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/staging
git bisect good c211148fb6355f347ec819a05c3034acd56e75c1  # 09:25   2140+  staging: dgnc: adds TODO
git bisect good b9a1048137f4ae43ee90f61a3f34f0efe863cfeb  # 14:30   2140+  usbcore: fix incorrect type in assignment in descriptors_changed()
git bisect good ec1882a9391c55332ebf3d1654f40b76e4a6c010  # 21:05   2140+  Merge tag 'regulator-v3.12' of git://git.kernel.org/pub/scm/linux/kernel/git/broonie/regulator
git bisect good 1d1fdd95df681f0c065d90ffaafa215a0e8825e2  # 03:49   2140+  Merge tag 'char-misc-3.12-rc1' of git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/char-misc
git bisect  bad f9ae443b5a1aa3d34d57df966a220a51a854d4c8  # 03:59     37-  sysfs: group.c: add kerneldoc for sysfs_remove_group
git bisect  bad 910f5c7cdb1d4541997f01c17b731bdfe2e92eda  # 04:23    190-  Correct unfaithful translation on HOWTO in ko_KR
git bisect  bad 86df268705696ce2286410f1493e294e889bdce6  # 04:35     83-  drivers:base:core: Moved sym export macros to respective functions
git bisect good 7c42721fe0c58a848849b43ff558cf2fb86aa35a  # 13:41   2140+  char: tile-srom: fix build error
git bisect  bad 92a3e661bf55457091817c5c346c4313be2508af  # 13:49    310-  SCSI: OSD: convert class code to use dev_groups
git bisect  bad 58b267d3e3f3ce87c3e559e4c330c8c03e905f5e  # 13:53    249-  dma: convert dma_devclass to use dev_groups
git bisect  bad c817a67ecba7c3c2aaa104796d78f160af60920d  # 14:00    445-  kobject: delayed kobject release: help find buggy drivers
git bisect good 7c42721fe0c58a848849b43ff558cf2fb86aa35a  # 21:46  10000+  char: tile-srom: fix build error
git bisect  bad a0cf1abc25ac197dd97b857c0f6341066a8cb1cf  # 21:47     55-  Add linux-next specific files for 20130927
git bisect good 918cf69e1b11370ca6da77c96ff3383b06a72bf3  # 02:15  10000+  Revert "kobject: delayed kobject release: help find buggy drivers"
git bisect  bad 7dee8dff47734ee52da2cd8b8ea9736e42c5062f  # 02:20     25-  Merge tag 'pm+acpi-3.12-rc4' of git://git.kernel.org/pub/scm/linux/kernel/git/rafael/linux-pm
git bisect  bad a0cf1abc25ac197dd97b857c0f6341066a8cb1cf  # 02:20      0-  Add linux-next specific files for 20130927

Thanks,
Fengguang

--SLDf9lqlvOQaIe6s
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="dmesg-yocto-lkp-tt02-10:20130928023627:3.12.0-rc2-02842-g45c4ea0:25"
Content-Transfer-Encoding: quoted-printable

[    0.000000] Initializing cgroup subsys cpuset
[    0.000000] Initializing cgroup subsys cpu
[    0.000000] Linux version 3.12.0-rc2-02842-g45c4ea0 (kbuild@xian) (gcc v=
ersion 4.8.1 (Debian 4.8.1-8) ) #25 SMP PREEMPT Sat Sep 28 11:59:48 CST 2013
[    0.000000] Command line: hung_task_panic=3D1 rcutree.rcu_cpu_stall_time=
out=3D100 log_buf_len=3D8M ignore_loglevel debug sched_debug apic=3Ddebug d=
ynamic_printk sysrq_always_enabled panic=3D10  prompt_ramdisk=3D0 console=
=3DttyS0,115200 console=3Dtty0 vga=3Dnormal  root=3D/dev/ram0 rw link=3D/ke=
rnel-tests/run-queue/kvm/x86_64-randconfig-x1-0928/next:master/.vmlinuz-45c=
4ea0c4c1b8abffb575b865243fd1c69bbecd9-20130928121103-8-lkp-tt02 branch=3Dne=
xt/master BOOT_IMAGE=3D/kernel/x86_64-randconfig-x1-0928/45c4ea0c4c1b8abffb=
575b865243fd1c69bbecd9/vmlinuz-3.12.0-rc2-02842-g45c4ea0
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
[    0.000000] e820: last_pfn =3D 0xfffe max_arch_pfn =3D 0x400000000
[    0.000000] Scan for SMP in [mem 0x00000000-0x000003ff]
[    0.000000] Scan for SMP in [mem 0x0009fc00-0x0009ffff]
[    0.000000] Scan for SMP in [mem 0x000f0000-0x000fffff]
[    0.000000] found SMP MP-table at [mem 0x000fdae0-0x000fdaef] mapped at =
[ffff8800000fdae0]
[    0.000000]   mpc: fdaf0-fdbec
[    0.000000] Base memory trampoline at [ffff880000099000] 99000 size 24576
[    0.000000] init_memory_mapping: [mem 0x00000000-0x000fffff]
[    0.000000]  [mem 0x00000000-0x000fffff] page 4k
[    0.000000] BRK [0x028c8000, 0x028c8fff] PGTABLE
[    0.000000] BRK [0x028c9000, 0x028c9fff] PGTABLE
[    0.000000] BRK [0x028ca000, 0x028cafff] PGTABLE
[    0.000000] init_memory_mapping: [mem 0x0fa00000-0x0fbfffff]
[    0.000000]  [mem 0x0fa00000-0x0fbfffff] page 4k
[    0.000000] BRK [0x028cb000, 0x028cbfff] PGTABLE
[    0.000000] init_memory_mapping: [mem 0x0c000000-0x0f9fffff]
[    0.000000]  [mem 0x0c000000-0x0f9fffff] page 4k
[    0.000000] BRK [0x028cc000, 0x028ccfff] PGTABLE
[    0.000000] BRK [0x028cd000, 0x028cdfff] PGTABLE
[    0.000000] init_memory_mapping: [mem 0x00100000-0x0bffffff]
[    0.000000]  [mem 0x00100000-0x0bffffff] page 4k
[    0.000000] init_memory_mapping: [mem 0x0fc00000-0x0fffdfff]
[    0.000000]  [mem 0x0fc00000-0x0fffdfff] page 4k
[    0.000000] log_buf_len: 8388608
[    0.000000] early log buf free: 128008(97%)
[    0.000000] RAMDISK: [mem 0x0fd03000-0x0ffeffff]
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
[    0.000000] mapped APIC to ffffffffff5bb000 (        fee00000)
[    0.000000] kvm-clock: Using msrs 4b564d01 and 4b564d00
[    0.000000] kvm-clock: cpu 0, msr 0:fcc3001, boot clock
[    0.000000] Zone ranges:
[    0.000000]   DMA32    [mem 0x00001000-0xffffffff]
[    0.000000]   Normal   empty
[    0.000000] Movable zone start for each node
[    0.000000] Early memory node ranges
[    0.000000]   node   0: [mem 0x00001000-0x0009efff]
[    0.000000]   node   0: [mem 0x00100000-0x0fffdfff]
[    0.000000] On node 0 totalpages: 65436
[    0.000000]   DMA32 zone: 1024 pages used for memmap
[    0.000000]   DMA32 zone: 21 pages reserved
[    0.000000]   DMA32 zone: 65436 pages, LIFO batch:15
[    0.000000] ACPI: PM-Timer IO Port: 0xb008
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] mapped APIC to ffffffffff5bb000 (        fee00000)
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
[    0.000000] mapped IOAPIC to ffffffffff5ba000 (fec00000)
[    0.000000] nr_irqs_gsi: 40
[    0.000000] e820: [mem 0x10000000-0xfeffbfff] available for PCI devices
[    0.000000] Booting paravirtualized kernel on KVM
[    0.000000] setup_percpu: NR_CPUS:4096 nr_cpumask_bits:2 nr_cpu_ids:2 nr=
_node_ids:1
[    0.000000] PERCPU: Embedded 24 pages/cpu @ffff88000f000000 s77520 r0 d2=
0784 u1048576
[    0.000000] pcpu-alloc: s77520 r0 d20784 u1048576 alloc=3D1*2097152
[    0.000000] pcpu-alloc: [0] 0 1=20
[    0.000000] kvm-clock: cpu 0, msr 0:fcc3001, primary cpu clock
[    0.000000] KVM setup async PF for cpu 0
[    0.000000] kvm-stealtime: cpu 0, msr f00ccc0
[    0.000000] Built 1 zonelists in Zone order, mobility grouping on.  Tota=
l pages: 64391
[    0.000000] Kernel command line: hung_task_panic=3D1 rcutree.rcu_cpu_sta=
ll_timeout=3D100 log_buf_len=3D8M ignore_loglevel debug sched_debug apic=3D=
debug dynamic_printk sysrq_always_enabled panic=3D10  prompt_ramdisk=3D0 co=
nsole=3DttyS0,115200 console=3Dtty0 vga=3Dnormal  root=3D/dev/ram0 rw link=
=3D/kernel-tests/run-queue/kvm/x86_64-randconfig-x1-0928/next:master/.vmlin=
uz-45c4ea0c4c1b8abffb575b865243fd1c69bbecd9-20130928121103-8-lkp-tt02 branc=
h=3Dnext/master BOOT_IMAGE=3D/kernel/x86_64-randconfig-x1-0928/45c4ea0c4c1b=
8abffb575b865243fd1c69bbecd9/vmlinuz-3.12.0-rc2-02842-g45c4ea0
[    0.000000] PID hash table entries: 1024 (order: 1, 8192 bytes)
[    0.000000] Dentry cache hash table entries: 32768 (order: 6, 262144 byt=
es)
[    0.000000] Inode-cache hash table entries: 16384 (order: 5, 131072 byte=
s)
[    0.000000] Calgary: detecting Calgary via BIOS EBDA area
[    0.000000] Calgary: Unable to locate Rio Grande table in EBDA - bailing!
[    0.000000] Memory: 219600K/261744K available (8589K kernel code, 1778K =
rwdata, 4068K rodata, 844K init, 10068K bss, 42144K reserved)
[    0.000000] Preemptible hierarchical RCU implementation.
[    0.000000]=20
[    0.000000]=20
[    0.000000]=20
[    0.000000]=20
[    0.000000] NR_IRQS:262400 nr_irqs:512 16
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
[    0.000000] ODEBUG: 3 of 3 active objects replaced
[    0.000000] hpet clockevent registered
[    0.000000] tsc: Detected 2393.914 MHz processor
[    0.008000] Calibrating delay loop (skipped) preset value.. 4787.82 Bogo=
MIPS (lpj=3D9575656)
[    0.008000] pid_max: default: 32768 minimum: 301
[    0.008840] Mount-cache hash table entries: 256
[    0.010902] Initializing cgroup subsys devices
[    0.012027] Initializing cgroup subsys perf_event
[    0.013063] Initializing cgroup subsys net_prio
[    0.014346] Last level iTLB entries: 4KB 0, 2MB 0, 4MB 0
[    0.014346] Last level dTLB entries: 4KB 0, 2MB 0, 4MB 0
[    0.014346] tlb_flushall_shift: 6
[    0.016046] debug: unmapping init [mem 0xffffffff81eef000-0xffffffff81ef=
2fff]
[    0.021821] ACPI: Core revision 20130823
[    0.025849] ACPI: All ACPI Tables successfully acquired
[    0.027626] Getting VERSION: 50014
[    0.028017] Getting VERSION: 50014
[    0.028799] Getting ID: 0
[    0.029408] Getting ID: ff000000
[    0.030123] Getting LVT0: 8700
[    0.030829] Getting LVT1: 8400
[    0.032086] enabled ExtINT on CPU#0
[    0.034329] ENABLING IO-APIC IRQs
[    0.035082] init IO_APIC IRQs
[    0.035746]  apic 0 pin 0 not connected
[    0.036024] IOAPIC[0]: Set routing entry (0-1 -> 0x31 -> IRQ 1 Mode:0 Ac=
tive:0 Dest:1)
[    0.037815] IOAPIC[0]: Set routing entry (0-2 -> 0x30 -> IRQ 0 Mode:0 Ac=
tive:0 Dest:1)
[    0.040038] IOAPIC[0]: Set routing entry (0-3 -> 0x33 -> IRQ 3 Mode:0 Ac=
tive:0 Dest:1)
[    0.041814] IOAPIC[0]: Set routing entry (0-4 -> 0x34 -> IRQ 4 Mode:0 Ac=
tive:0 Dest:1)
[    0.043552] IOAPIC[0]: Set routing entry (0-5 -> 0x35 -> IRQ 5 Mode:1 Ac=
tive:0 Dest:1)
[    0.044035] IOAPIC[0]: Set routing entry (0-6 -> 0x36 -> IRQ 6 Mode:0 Ac=
tive:0 Dest:1)
[    0.045774] IOAPIC[0]: Set routing entry (0-7 -> 0x37 -> IRQ 7 Mode:0 Ac=
tive:0 Dest:1)
[    0.048030] IOAPIC[0]: Set routing entry (0-8 -> 0x38 -> IRQ 8 Mode:0 Ac=
tive:0 Dest:1)
[    0.049778] IOAPIC[0]: Set routing entry (0-9 -> 0x39 -> IRQ 9 Mode:1 Ac=
tive:0 Dest:1)
[    0.052030] IOAPIC[0]: Set routing entry (0-10 -> 0x3a -> IRQ 10 Mode:1 =
Active:0 Dest:1)
[    0.053783] IOAPIC[0]: Set routing entry (0-11 -> 0x3b -> IRQ 11 Mode:1 =
Active:0 Dest:1)
[    0.056030] IOAPIC[0]: Set routing entry (0-12 -> 0x3c -> IRQ 12 Mode:0 =
Active:0 Dest:1)
[    0.057825] IOAPIC[0]: Set routing entry (0-13 -> 0x3d -> IRQ 13 Mode:0 =
Active:0 Dest:1)
[    0.060029] IOAPIC[0]: Set routing entry (0-14 -> 0x3e -> IRQ 14 Mode:0 =
Active:0 Dest:1)
[    0.061824] IOAPIC[0]: Set routing entry (0-15 -> 0x3f -> IRQ 15 Mode:0 =
Active:0 Dest:1)
[    0.063560]  apic 0 pin 16 not connected
[    0.064004]  apic 0 pin 17 not connected
[    0.064883]  apic 0 pin 18 not connected
[    0.065770]  apic 0 pin 19 not connected
[    0.066632]  apic 0 pin 20 not connected
[    0.068004]  apic 0 pin 21 not connected
[    0.068869]  apic 0 pin 22 not connected
[    0.069733]  apic 0 pin 23 not connected
[    0.070734] ..TIMER: vector=3D0x30 apic1=3D0 pin1=3D2 apic2=3D-1 pin2=3D=
-1
[    0.072004] smpboot: CPU0: Intel Common KVM processor (fam: 0f, model: 0=
6, stepping: 01)
[    0.074145] Using local APIC timer interrupts.
[    0.074145] calibrating APIC timer ...
[    0.080000] ... lapic delta =3D 6250130
[    0.080000] ... PM-Timer delta =3D 357958
[    0.080000] ... PM-Timer result ok
[    0.080000] ..... delta 6250130
[    0.080000] ..... mult: 268441039
[    0.080000] ..... calibration result: 4000083
[    0.080000] ..... CPU clock speed is 2393.3836 MHz.
[    0.080000] ..... host bus clock speed is 1000.0083 MHz.
[    0.080162] Performance Events: unsupported Netburst CPU model 6 no PMU =
driver, software events only.
[    0.105732] SMP alternatives: lockdep: fixing up alternatives
[    0.107172] smpboot: Booting Node   0, Processors  #   1 OK
[    0.008000] kvm-clock: cpu 1, msr 0:fcc3041, secondary cpu clock
[    0.008000] masked ExtINT on CPU#1
[    0.124000] TSC synchronization [CPU#0 -> CPU#1]:
[    0.124000] Measured 8267 cycles TSC warp between CPUs, turning off TSC =
clock.
[    0.124000] tsc: Marking TSC unstable due to check_tsc_sync_source failed
[    0.128162] Brought up 2 CPUs
[    0.128098] KVM setup async PF for cpu 1
[    0.128098] kvm-stealtime: cpu 1, msr f10ccc0
[    0.130652] smpboot: Total of 2 processors activated (9575.65 BogoMIPS)
[    0.136075] devtmpfs: initialized
[    0.138737] atomic64 test passed for x86-64 platform with CX8 and with S=
SE
[    0.140959] regulator-dummy: no parameters
[    0.142515] NET: Registered protocol family 16
[    0.145528] cpuidle: using governor ladder
[    0.146430] cpuidle: using governor menu
[    0.148443] ACPI: bus type PCI registered
[    0.149439] PCI: Using configuration type 1 for base access
[    0.162589] ACPI: Added _OSI(Module Device)
[    0.164005] ACPI: Added _OSI(Processor Device)
[    0.164944] ACPI: Added _OSI(3.0 _SCP Extensions)
[    0.165955] ACPI: Added _OSI(Processor Aggregator Device)
[    0.176269] ACPI: Interpreter enabled
[    0.177105] ACPI: (supports S0 S5)
[    0.177874] ACPI: Using IOAPIC for interrupt routing
[    0.178963] PCI: Using host bridge windows from ACPI; if necessary, use =
"pci=3Dnocrs" and report a bug
[    0.194630] ACPI: PCI Root Bridge [PCI0] (domain 0000 [bus 00-ff])
[    0.195957] acpi PNP0A03:00: _OSC: OS supports [ASPM ClockPM Segments MS=
I]
[    0.196045] acpi PNP0A03:00: _OSC failed (AE_NOT_FOUND); disabling ASPM
[    0.198135] PCI host bridge to bus 0000:00
[    0.200007] pci_bus 0000:00: root bus resource [bus 00-ff]
[    0.201218] pci_bus 0000:00: root bus resource [io  0x0000-0x0cf7]
[    0.202535] pci_bus 0000:00: root bus resource [io  0x0d00-0xffff]
[    0.204005] pci_bus 0000:00: root bus resource [mem 0x000a0000-0x000bfff=
f]
[    0.205488] pci_bus 0000:00: root bus resource [mem 0x80000000-0xfebffff=
f]
[    0.207031] pci 0000:00:00.0: [8086:1237] type 00 class 0x060000
[    0.209031] pci 0000:00:01.0: [8086:7000] type 00 class 0x060100
[    0.212295] pci 0000:00:01.1: [8086:7010] type 00 class 0x010180
[    0.216599] pci 0000:00:01.1: reg 0x20: [io  0xc060-0xc06f]
[    0.219494] pci 0000:00:01.3: [8086:7113] type 00 class 0x068000
[    0.220794] pci 0000:00:01.3: quirk: [io  0xb000-0xb03f] claimed by PIIX=
4 ACPI
[    0.222324] pci 0000:00:01.3: quirk: [io  0xb100-0xb10f] claimed by PIIX=
4 SMB
[    0.224698] pci 0000:00:02.0: [1013:00b8] type 00 class 0x030000
[    0.228761] pci 0000:00:02.0: reg 0x10: [mem 0xfc000000-0xfdffffff pref]
[    0.231666] pci 0000:00:02.0: reg 0x14: [mem 0xfebe0000-0xfebe0fff]
[    0.240068] pci 0000:00:02.0: reg 0x30: [mem 0xfebc0000-0xfebcffff pref]
[    0.242426] pci 0000:00:03.0: [1af4:1000] type 00 class 0x020000
[    0.245132] pci 0000:00:03.0: reg 0x10: [io  0xc040-0xc05f]
[    0.247333] pci 0000:00:03.0: reg 0x14: [mem 0xfebe1000-0xfebe1fff]
[    0.253571] pci 0000:00:03.0: reg 0x30: [mem 0xfebd0000-0xfebdffff pref]
[    0.256141] pci 0000:00:04.0: [8086:100e] type 00 class 0x020000
[    0.258503] pci 0000:00:04.0: reg 0x10: [mem 0xfeb80000-0xfeb9ffff]
[    0.260562] pci 0000:00:04.0: reg 0x14: [io  0xc000-0xc03f]
[    0.267109] pci 0000:00:04.0: reg 0x30: [mem 0xfeba0000-0xfebbffff pref]
[    0.268565] pci 0000:00:05.0: [8086:25ab] type 00 class 0x088000
[    0.270445] pci 0000:00:05.0: reg 0x10: [mem 0xfebe2000-0xfebe200f]
[    0.276853] pci_bus 0000:00: on NUMA node 0
[    0.279047] ACPI: PCI Interrupt Link [LNKA] (IRQs 5 *10 11)
[    0.280659] ACPI: PCI Interrupt Link [LNKB] (IRQs 5 *10 11)
[    0.282243] ACPI: PCI Interrupt Link [LNKC] (IRQs 5 10 *11)
[    0.283861] ACPI: PCI Interrupt Link [LNKD] (IRQs 5 10 *11)
[    0.284508] ACPI: PCI Interrupt Link [LNKS] (IRQs *9)
[    0.286827] ACPI: Enabled 16 GPEs in block 00 to 0F
[    0.288014] ACPI: \_SB_.PCI0: notify handler is installed
[    0.289272] Found 1 acpi root devices
[    0.292088] vgaarb: device added: PCI:0000:00:02.0,decodes=3Dio+mem,owns=
=3Dio+mem,locks=3Dnone
[    0.293834] vgaarb: loaded
[    0.294428] vgaarb: bridge control possible 0000:00:02.0
[    0.296849] ACPI: bus type USB registered
[    0.297815] usbcore: registered new interface driver usbfs
[    0.299040] usbcore: registered new interface driver hub
[    0.300165] usbcore: registered new device driver usb
[    0.301428] pps_core: LinuxPPS API ver. 1 registered
[    0.302500] pps_core: Software ver. 5.3.6 - Copyright 2005-2007 Rodolfo =
Giometti <giometti@linux.it>
[    0.304090] PTP clock support registered
[    0.305326] wmi: Mapper loaded
[    0.306148] PCI: Using ACPI for IRQ routing
[    0.308006] PCI: pci_cache_line_size set to 64 bytes
[    0.309357] e820: reserve RAM buffer [mem 0x0009fc00-0x0009ffff]
[    0.310676] e820: reserve RAM buffer [mem 0x0fffe000-0x0fffffff]
[    0.312792] NET: Registered protocol family 23
[    0.314589] cfg80211: Calling CRDA to update world regulatory domain
[    0.316112] nfc: nfc_init: NFC Core ver 0.1
[    0.317066] NET: Registered protocol family 39
[    0.318720] HPET: 3 timers in total, 0 timers will be used for per-cpu t=
imer
[    0.320200] Switched to clocksource kvm-clock
[    0.321618] pnp: PnP ACPI init
[    0.322363] ACPI: bus type PNP registered
[    0.323359] IOAPIC[0]: Set routing entry (0-8 -> 0x38 -> IRQ 8 Mode:0 Ac=
tive:0 Dest:3)
[    0.325168] pnp 00:00: Plug and Play ACPI device, IDs PNP0b00 (active)
[    0.326801] IOAPIC[0]: Set routing entry (0-1 -> 0x31 -> IRQ 1 Mode:0 Ac=
tive:0 Dest:3)
[    0.328590] pnp 00:01: Plug and Play ACPI device, IDs PNP0303 (active)
[    0.329997] IOAPIC[0]: Set routing entry (0-12 -> 0x3c -> IRQ 12 Mode:0 =
Active:0 Dest:3)
[    0.331810] pnp 00:02: Plug and Play ACPI device, IDs PNP0f13 (active)
[    0.333309] IOAPIC[0]: Set routing entry (0-6 -> 0x36 -> IRQ 6 Mode:0 Ac=
tive:0 Dest:3)
[    0.334994] pnp 00:03: [dma 2]
[    0.335711] pnp 00:03: Plug and Play ACPI device, IDs PNP0700 (active)
[    0.337187] IOAPIC[0]: Set routing entry (0-7 -> 0x37 -> IRQ 7 Mode:0 Ac=
tive:0 Dest:3)
[    0.338966] pnp 00:04: Plug and Play ACPI device, IDs PNP0400 (active)
[    0.340464] IOAPIC[0]: Set routing entry (0-4 -> 0x34 -> IRQ 4 Mode:0 Ac=
tive:0 Dest:3)
[    0.342194] pnp 00:05: Plug and Play ACPI device, IDs PNP0501 (active)
[    0.344044] pnp 00:06: Plug and Play ACPI device, IDs PNP0103 (active)
[    0.345684] pnp: PnP ACPI: found 7 devices
[    0.346575] ACPI: bus type PNP unregistered
[    0.353710] pci_bus 0000:00: resource 4 [io  0x0000-0x0cf7]
[    0.354891] pci_bus 0000:00: resource 5 [io  0x0d00-0xffff]
[    0.356074] pci_bus 0000:00: resource 6 [mem 0x000a0000-0x000bffff]
[    0.357384] pci_bus 0000:00: resource 7 [mem 0x80000000-0xfebfffff]
[    0.359254] NET: Registered protocol family 2
[    0.361562] TCP established hash table entries: 2048 (order: 3, 32768 by=
tes)
[    0.363170] TCP bind hash table entries: 2048 (order: 5, 131072 bytes)
[    0.364782] TCP: Hash tables configured (established 2048 bind 2048)
[    0.366266] TCP: reno registered
[    0.367260] UDP hash table entries: 256 (order: 3, 40960 bytes)
[    0.368892] UDP-Lite hash table entries: 256 (order: 3, 40960 bytes)
[    0.370624] NET: Registered protocol family 1
[    0.372839] RPC: Registered named UNIX socket transport module.
[    0.374090] RPC: Registered udp transport module.
[    0.375087] RPC: Registered tcp transport module.
[    0.376146] RPC: Registered tcp NFSv4.1 backchannel transport module.
[    0.377509] pci 0000:00:00.0: Limiting direct PCI/PCI transfers
[    0.378788] pci 0000:00:01.0: PIIX3: Enabling Passive Release
[    0.380054] pci 0000:00:01.0: Activating ISA DMA hang workarounds
[    0.381391] pci 0000:00:02.0: Boot video device
[    0.382409] PCI: CLS 0 bytes, default 64
[    0.383635] Unpacking initramfs...
[    0.673773] debug: unmapping init [mem 0xffff88000fd03000-0xffff88000ffe=
ffff]
[    0.676403] has_svm: not amd
[    0.677041] kvm: no hardware support
[    0.678496] camellia-x86_64: performance on this CPU would be suboptimal=
: disabling camellia-x86_64.
[    0.680443] blowfish-x86_64: performance on this CPU would be suboptimal=
: disabling blowfish-x86_64.
[    0.684450] twofish-x86_64-3way: performance on this CPU would be subopt=
imal: disabling twofish-x86_64-3way.
[    0.686511] sha1_ssse3: Neither AVX nor SSSE3 is available/usable.
[    0.687831] sha256_ssse3: Neither AVX nor SSSE3 is available/usable.
[    0.689203] sha512_ssse3: Neither AVX nor SSSE3 is available/usable.
[    0.689247] cryptomgr_test (24) used greatest stack depth: 6504 bytes le=
ft
[    0.691977] AVX or AES-NI instructions are not detected.
[    0.693139] AVX instructions are not detected.
[    0.694080] AVX instructions are not detected.
[    0.695022] AVX instructions are not detected.
[    0.695962] AVX2 instructions are not detected.
[    0.700921] Initializing RT-Tester: OK
[    0.701741] audit: initializing netlink socket (disabled)
[    0.702978] type=3D2000 audit(1380306978.571:1): initialized
[    0.709665] DLM installed
[    0.712878] NFS: Registering the id_resolver key type
[    0.714110] Key type id_resolver registered
[    0.715015] Key type id_legacy registered
[    0.715876] Installing knfsd (copyright (C) 1996 okir@monad.swb.de).
[    0.718561] ROMFS MTD (C) 2007 Red Hat, Inc.
[    0.719496] fuse init (API version 7.22)
[    0.721227] ceph: loaded (mds proto 32)
[    0.725068] cryptomgr_test (43) used greatest stack depth: 5648 bytes le=
ft
[    0.771292] cryptomgr_test (72) used greatest stack depth: 5496 bytes le=
ft
[    0.784625] alg: No test for crc32 (crc32-table)
[    0.787711] alg: No test for lz4hc (lz4hc-generic)
[    0.788956] alg: No test for stdrng (krng)
[    0.791809] NET: Registered protocol family 38
[    0.792967] Key type asymmetric registered
[    0.793858] Asymmetric key parser 'x509' registered
[    0.794896] test_string_helpers: Running tests...
[    0.796571] crc32: CRC_LE_BITS =3D 32, CRC_BE BITS =3D 32
[    0.797640] crc32: self tests passed, processed 225944 bytes in 261634 n=
sec
[    0.799343] crc32c: CRC_LE_BITS =3D 32
[    0.800390] crc32c: self tests passed, processed 225944 bytes in 126257 =
nsec
[    0.801885] rbtree testing -> 18881 cycles
[    1.640682] augmented rbtree testing -> 29972 cycles
[    2.967555] cr_bllcd: INTEL CARILLO RANCH LPC not found.
[    2.968768] cr_bllcd: Carillo Ranch Backlight Driver Initialized.
[    2.970574] VIA Graphics Integration Chipset framebuffer 2.4 initializing
[    2.972262] vmlfb: initializing
[    2.972968] Could not find Carillo Ranch MCH device.
[    2.974124] no IO addresses supplied
[    2.975032] hgafb: HGA card not detected.
[    2.975898] hgafb: probe of hgafb.0 failed with error -22
[    2.977186] usbcore: registered new interface driver udlfb
[    2.978354] usbcore: registered new interface driver smscufx
[    2.987293] uvesafb: VGABIOS Cirrus extension, VGABIOS Cirrus extension,=
 1.0, OEM: VGABIOS Cirrus extension, VBE v2.0
[    2.992148] uvesafb: no monitor limits have been set, default refresh ra=
te will be used
[    2.993969] uvesafb: VBE state buffer size cannot be determined (eax=3D0=
x14f, err=3D0)
[    2.995631] uvesafb: scrolling: redraw
[    2.997317] uvesafb: framebuffer at 0xfc000000, mapped to 0xffffc9000008=
0000, using 4096k, total 4096k
[    2.999263] fb0: VESA VGA frame buffer device
[    3.000331] ipmi message handler version 39.2
[    3.001258] ipmi device interface
[    3.002082] IPMI System Interface driver.
[    3.003000] ipmi_si: Adding default-specified kcs state machine
[    3.004390] ipmi_si: Trying default-specified kcs state machine at i/o a=
ddress 0xca2, slave address 0x0, irq 0
[    3.006495] ipmi_si: Interface detection failed
[    3.016137] ipmi_si: Adding default-specified smic state machine
[    3.017446] ipmi_si: Trying default-specified smic state machine at i/o =
address 0xca9, slave address 0x0, irq 0
[    3.019570] ipmi_si: Interface detection failed
[    3.032089] ipmi_si: Adding default-specified bt state machine
[    3.033384] ipmi_si: Trying default-specified bt state machine at i/o ad=
dress 0xe4, slave address 0x0, irq 0
[    3.035465] ipmi_si: Interface detection failed
[    3.048207] ipmi_si: Unable to find any System Interface(s)
[    3.049383] IPMI Watchdog: driver initialized
[    3.050309] Copyright (C) 2004 MontaVista Software - IPMI Powerdown via =
sys_reboot.
[    3.052267] input: Power Button as /devices/LNXSYSTM:00/LNXPWRBN:00/inpu=
t/input0
[    3.053836] ACPI: Power Button [PWRF]
[    3.145210] Serial: 8250/16550 driver, 4 ports, IRQ sharing disabled
[    3.171151] 00:05: ttyS0 at I/O 0x3f8 (irq =3D 4, base_baud =3D 115200) =
is a 16550A
[    3.174687] Applicom driver: $Id: ac.c,v 1.30 2000/03/22 16:03:57 dwmw2 =
Exp $
[    3.176250] ac.o: No PCI boards found.
[    3.177081] ac.o: For an ISA board you must supply memory and irq parame=
ters.
[    3.178802] Non-volatile memory driver v1.3
[    3.179717] Linux agpgart interface v0.103
[    3.181282] [drm] Initialized drm 1.1.0 20060810
[    3.182415] [drm] radeon kernel modesetting enabled.
[    3.185401] [drm:cirrus_vram_init] *ERROR* can't reserve VRAM
[    3.186689] cirrus 0000:00:02.0: Fatal error during GPU init: -6
[    3.187995] Trying to free nonexistent resource <00000000febe0000-000000=
00febe0fff>
[    3.190777] usbcore: registered new interface driver udl
[    3.193542] parport_pc 00:04: reported by Plug and Play ACPI
[    3.194867] parport0: PC-style at 0x378, irq 7 [PCSPP(,...)]
[    3.197188] ibmasm: IBM ASM Service Processor Driver version 1.0 loaded
[    3.198701] dummy-irq: no IRQ given.  Use irq=3DN
[    3.199842] Phantom Linux Driver, version n0.9.8, init OK
[    3.201407] Silicon Labs C2 port support v. 0.51.0 - (C) 2007 Rodolfo Gi=
ometti
[    3.203238] c2port c2port0: C2 port uc added
[    3.204225] c2port c2port0: uc flash has 30 blocks x 512 bytes (15360 by=
tes total)
[    3.206151] Guest personality initialized and is inactive
[    3.207627] VMCI host device registered (name=3Dvmci, major=3D10, minor=
=3D57)
[    3.209058] Initialized host personality
[    3.210445] usbcore: registered new interface driver viperboard
[    3.211849] usbcore: registered new interface driver pn533
[    3.213475] mtdoops: mtd device (mtddev=3Dname/number) must be supplied
[    3.214889] device id =3D 2440
[    3.215544] device id =3D 2480
[    3.216181] device id =3D 24c0
[    3.216832] device id =3D 24d0
[    3.217442] device id =3D 25a1
[    3.218081] device id =3D 2670
[    3.218746] platform physmap-flash.0: failed to claim resource 0
[    3.220057] SBC-GXx flash: IO:0x258-0x259 MEM:0xdc000-0xdffff
[    3.221432] Could not find PAR responsible for SC520CDP Flash Bank #0
[    3.222821] Trying default address 0x8400000
[    3.223741] Could not find PAR responsible for SC520CDP Flash Bank #1
[    3.225139] Trying default address 0x8c00000
[    3.226055] Could not find PAR responsible for SC520CDP DIL Flash
[    3.227349] Trying default address 0x9400000
[    3.228378] SC520 CDP flash device: 0x800000 at 0x8400000
[    3.229548] Failed to ioremap_nocache
[    3.230316] Failed to ioremap_nocache
[    3.231141] Generic platform RAM MTD, (c) 2004 Simtec Electronics
[    3.232714] slram: not enough parameters.
[    3.240155] No valid DiskOnChip devices found
[    3.241125] [nandsim] warning: read_byte: unexpected data output cycle, =
state is STATE_READY return 0x0
[    3.243119] [nandsim] warning: read_byte: unexpected data output cycle, =
state is STATE_READY return 0x0
[    3.245137] [nandsim] warning: read_byte: unexpected data output cycle, =
state is STATE_READY return 0x0
[    3.247122] [nandsim] warning: read_byte: unexpected data output cycle, =
state is STATE_READY return 0x0
[    3.249153] [nandsim] warning: read_byte: unexpected data output cycle, =
state is STATE_READY return 0x0
[    3.251141] [nandsim] warning: read_byte: unexpected data output cycle, =
state is STATE_READY return 0x0
[    3.253176] NAND device: Manufacturer ID: 0x98, Chip ID: 0x39 (Toshiba N=
AND 128MiB 1,8V 8-bit), 128MiB, page size: 512, OOB size: 16
[    3.255850] flash size: 128 MiB
[    3.256576] page size: 512 bytes
[    3.257258] OOB area size: 16 bytes
[    3.258014] sector size: 16 KiB
[    3.258705] pages number: 262144
[    3.259381] pages per sector: 32
[    3.260121] bus width: 8
[    3.260689] bits in sector size: 14
[    3.261430] bits in page size: 9
[    3.262137] bits in OOB size: 4
[    3.262838] flash size with OOB: 135168 KiB
[    3.263739] page address bytes: 4
[    3.264467] sector address bytes: 3
[    3.265229] options: 0x42
[    3.275324] Scanning device for bad blocks
[    3.317743] Creating 1 MTD partitions on "NAND 128MiB 1,8V 8-bit":
[    3.319092] 0x000000000000-0x000008000000 : "NAND simulator partition 0"
[    3.321574] parport0: powerup/reset Butterfly
[    3.436239] parport_pc 00:04: registered master spi42
[    3.437675] spi spi42.1: spi_bitbang_setup, 66 nsec/bit
[    3.438814] spi spi42.1: setup mode 0, 8 bits/w, 15000000 Hz max --> 0
[    3.440317] parport_pc 00:04: registered child spi42.1
[    3.441413] parport0: dataflash at spi42.1
[    3.442293] parport0: AVR Butterfly
[    3.443183] parport0: cannot grant exclusive access for device spi-lm70l=
lp
[    3.444698] spi-lm70llp: spi_lm70llp probe fail, status -12
[    3.446209] usbcore: registered new interface driver irda-usb
[    3.447458] usbcore: registered new interface driver stir4200
[    3.448821] usbcore: registered new interface driver mcs7780
[    3.450040] usbcore: registered new interface driver kingsun-sir
[    3.451344] usbcore: registered new interface driver ksdazzle-sir
[    3.452815] usbcore: registered new interface driver ks959-sir
[    3.454407] usbcore: registered new interface driver hwa-rc
[    3.455715] ohci_hcd: USB 1.1 'Open' Host Controller (OHCI) Driver
[    3.457049] ohci-pci: OHCI PCI platform driver
[    3.458031] ohci-platform: OHCI generic platform driver
[    3.459181] uhci_hcd: USB Universal Host Controller Interface driver
[    3.460856] driver u132_hcd
[    3.462015] usbcore: registered new interface driver hwa-hc
[    3.463278] fusbh200_hcd: FUSBH200 Host Controller (EHCI) Driver
[    3.464617] Warning! fusbh200_hcd should always be loaded before uhci_hc=
d and ohci_hcd, not after
[    3.466735] usbcore: registered new interface driver cdc_wdm
[    3.467979] usbcore: registered new interface driver usbtmc
[    3.469424] usbcore: registered new interface driver appledisplay
[    3.470786] usbcore: registered new interface driver emi26 - firmware lo=
ader
[    3.472324] usbcore: registered new interface driver emi62 - firmware lo=
ader
[    3.473845] driver ftdi-elan
[    3.475036] usbcore: registered new interface driver ftdi-elan
[    3.476329] usbcore: registered new interface driver idmouse
[    3.477610] usbcore: registered new interface driver usblcd
[    3.478806] usbcore: registered new interface driver ldusb
[    3.479991] usbcore: registered new interface driver usbled
[    3.481221] usbcore: registered new interface driver legousbtower
[    3.482590] usbcore: registered new interface driver rio500
[    3.483827] usbcore: registered new interface driver usbtest
[    3.485080] usbcore: registered new interface driver usb_ehset_test
[    3.486421] usbcore: registered new interface driver trancevibrator
[    3.487829] usbcore: registered new interface driver uss720
[    3.489038] uss720: v0.6:USB Parport Cable driver for Cables using the L=
ucent Technologies USS720 Chip
[    3.490998] uss720: NOTE: this is a special purpose driver to allow nons=
tandard
[    3.492595] uss720: protocols (eg. bitbang) over USS720 usb to parallel =
cables
[    3.494110] uss720: If you just want to connect to a printer, use usblp =
instead
[    3.495722] usbcore: registered new interface driver yurex
[    3.497134] i8042: PNP: PS/2 Controller [PNP0303:KBD,PNP0f13:MOU] at 0x6=
0,0x64 irq 1,12
[    3.500264] serio: i8042 KBD port at 0x60,0x64 irq 1
[    3.501674] serio: i8042 AUX port at 0x60,0x64 irq 12
[    3.502824] parport0: cannot grant exclusive access for device parkbd
[    3.617846] input: AT Translated Set 2 keyboard as /devices/platform/i80=
42/serio0/input/input1
[    3.620163] usbcore: registered new interface driver bcm5974
[    3.621695] usbcore: registered new interface driver synaptics_usb
[    3.623158] usbcore: registered new interface driver iforce
[    3.626341] parport0: cannot grant exclusive access for device walkera07=
01
[    3.628309] walkera0701: failed to register parport device
[    3.630972] usbcore: registered new interface driver usbtouchscreen
[    3.632603] apanel: Fujitsu BIOS signature 'FJKEYINF' not found...
[    3.633911] usbcore: registered new interface driver ati_remote2
[    3.635186] cm109: Keymap for Komunikate KIP1000 phone loaded
[    3.636449] usbcore: registered new interface driver cm109
[    3.637620] cm109: CM109 phone driver: 20080805 (C) Alfred E. Heggestad
[    3.639044] usbcore: registered new interface driver keyspan_remote
[    3.640778] usbcore: registered new interface driver yealink
[    3.641968] I2O subsystem v1.325
[    3.642669] i2o: max drivers =3D 8
[    3.643648] I2O Configuration OSM v1.323
[    3.644576] I2O ProcFS OSM v1.316
[    3.646682] rtc rtc0: test: dev (254:0)
[    3.647493] rtc-test rtc-test.0: rtc core: registered test as rtc0
[    3.649108] rtc rtc1: test: dev (254:1)
[    3.649933] rtc-test rtc-test.1: rtc core: registered test as rtc1
[    3.651344] i2c /dev entries driver
[    3.652619] usbcore: registered new interface driver i2c-diolan-u2c
[    3.653933] i2c-parport: adapter type unspecified
[    3.654923] i2c-parport-light: adapter type unspecified
[    3.656269] pps pps0: new PPS source ktimer
[    3.657176] pps pps0: ktimer PPS source registered
[    3.658182] pps_parport: parallel port PPS client
[    3.659179] parport0: cannot grant exclusive access for device pps_parpo=
rt
[    3.660648] pps_parport: couldn't register with parport0
[    3.661835] Driver for 1-wire Dallas network protocol.
[    3.663028] usbcore: registered new interface driver DS9490R
[    3.664251] DS1WM w1 busmaster driver - (c) 2004 Szabolcs Gyurko
[    3.665755] power_supply test_ac: uevent
[    3.666602] power_supply test_ac: POWER_SUPPLY_NAME=3Dtest_ac
[    3.667794] power_supply test_ac: prop ONLINE=3D1
[    3.668825] power_supply test_ac: power_supply_changed
[    3.669968] power_supply test_ac: power_supply_changed_work
[    3.671142] power_supply test_ac: power_supply_update_gen_leds 1
[    3.672443] power_supply test_ac: uevent
[    3.672575] power_supply test_battery: uevent
[    3.672578] power_supply test_battery: POWER_SUPPLY_NAME=3Dtest_battery
[    3.672614] power_supply test_battery: prop STATUS=3DDischarging
[    3.672617] power_supply test_battery: prop CHARGE_TYPE=3DFast
[    3.672620] power_supply test_battery: prop HEALTH=3DGood
[    3.672623] power_supply test_battery: prop PRESENT=3D1
[    3.672626] power_supply test_battery: prop TECHNOLOGY=3DLi-ion
[    3.672628] power_supply test_battery: prop CHARGE_FULL_DESIGN=3D100
[    3.672631] power_supply test_battery: prop CHARGE_FULL=3D100
[    3.672634] power_supply test_battery: prop CHARGE_NOW=3D50
[    3.672636] power_supply test_battery: prop CAPACITY=3D50
[    3.672639] power_supply test_battery: prop CAPACITY_LEVEL=3DNormal
[    3.672642] power_supply test_battery: prop TIME_TO_EMPTY_AVG=3D3600
[    3.672645] power_supply test_battery: prop TIME_TO_FULL_NOW=3D3600
[    3.672648] power_supply test_battery: prop MODEL_NAME=3DTest battery
[    3.672684] power_supply test_battery: prop MANUFACTURER=3DLinux
[    3.672688] power_supply test_battery: prop SERIAL_NUMBER=3D3.12.0-rc2-0=
2842-g45c4ea0
[    3.672690] power_supply test_battery: prop TEMP=3D26
[    3.672693] power_supply test_battery: prop VOLTAGE_NOW=3D3300
[    3.672998] power_supply test_battery: power_supply_changed
[    3.673010] power_supply test_battery: power_supply_changed_work
[    3.673014] power_supply test_battery: power_supply_update_bat_leds 2
[    3.673019] power_supply test_battery: uevent
[    3.673021] power_supply test_battery: POWER_SUPPLY_NAME=3Dtest_battery
[    3.673053] power_supply test_battery: prop STATUS=3DDischarging
[    3.673056] power_supply test_battery: prop CHARGE_TYPE=3DFast
[    3.673059] power_supply test_battery: prop HEALTH=3DGood
[    3.673062] power_supply test_battery: prop PRESENT=3D1
[    3.673065] power_supply test_battery: prop TECHNOLOGY=3DLi-ion
[    3.673068] power_supply test_battery: prop CHARGE_FULL_DESIGN=3D100
[    3.673071] power_supply test_battery: prop CHARGE_FULL=3D100
[    3.673073] power_supply test_battery: prop CHARGE_NOW=3D50
[    3.673076] power_supply test_battery: prop CAPACITY=3D50
[    3.673079] power_supply test_battery: prop CAPACITY_LEVEL=3DNormal
[    3.673082] power_supply test_battery: prop TIME_TO_EMPTY_AVG=3D3600
[    3.673085] power_supply test_battery: prop TIME_TO_FULL_NOW=3D3600
[    3.673088] power_supply test_battery: prop MODEL_NAME=3DTest battery
[    3.673091] power_supply test_battery: prop MANUFACTURER=3DLinux
[    3.673094] power_supply test_battery: prop SERIAL_NUMBER=3D3.12.0-rc2-0=
2842-g45c4ea0
[    3.673096] power_supply test_battery: prop TEMP=3D26
[    3.673099] power_supply test_battery: prop VOLTAGE_NOW=3D3300
[    3.673201] power_supply test_usb: uevent
[    3.673203] power_supply test_usb: POWER_SUPPLY_NAME=3Dtest_usb
[    3.673234] power_supply test_usb: prop ONLINE=3D1
[    3.673265] power_supply test_usb: power_supply_changed
[    3.673284] power_supply test_usb: power_supply_changed_work
[    3.673288] power_supply test_usb: power_supply_update_gen_leds 1
[    3.673293] power_supply test_usb: uevent
[    3.673294] power_supply test_usb: POWER_SUPPLY_NAME=3Dtest_usb
[    3.673326] power_supply test_usb: prop ONLINE=3D1
[    3.674193] applesmc: supported laptop not found!
[    3.674194] applesmc: driver init failed (ret=3D-19)!
[    3.674615] f71882fg: Not a Fintek device
[    3.674674] f71882fg: Not a Fintek device
[    3.675932] pc87360: PC8736x not detected, module not inserted
[    3.676868] sdhci: Secure Digital Host Controller Interface driver
[    3.676869] sdhci: Copyright(c) Pierre Ossman
[    3.677390] VUB300 Driver rom wait states =3D 1C irqpoll timeout =3D 0400
[    3.677391] usbcore: registered new interface driver vub300
[    3.677437] usbcore: registered new interface driver ushc
[    3.677438] sdhci-pltfm: SDHCI platform and OF driver helper
[    3.678234] ledtrig-cpu: registered to indicate activity on CPUs
[    3.678604] dcdbas dcdbas: Dell Systems Management Base Driver (version =
5.6.0-3.2)
[    3.680383] usbcore: registered new interface driver usbhid
[    3.680384] usbhid: USB HID core driver
[    3.680417] usbip_core: usbip_core_init:805: USB/IP Core v1.0.0
[    3.680596] vhci_hcd: vhci_hcd_probe:1000: name vhci_hcd id -1
[    3.680653] vhci_hcd vhci_hcd: USB/IP Virtual Host Controller
[    3.680701] vhci_hcd vhci_hcd: new USB bus registered, assigned bus numb=
er 1
[    3.680709] vhci_hcd: vhci_start:884: enter vhci_start
[    3.682030] usb usb1: New USB device found, idVendor=3D1d6b, idProduct=
=3D0002
[    3.682033] usb usb1: New USB device strings: Mfr=3D3, Product=3D2, Seri=
alNumber=3D1
[    3.682035] usb usb1: Product: USB/IP Virtual Host Controller
[    3.682037] usb usb1: Manufacturer: Linux 3.12.0-rc2-02842-g45c4ea0 vhci=
_hcd
[    3.682039] usb usb1: SerialNumber: vhci_hcd
[    3.763282] power_supply test_ac: POWER_SUPPLY_NAME=3Dtest_ac
[    3.763872] hub 1-0:1.0: USB hub found
[    3.763940] vhci_hcd: vhci_hub_control:247: typeReq a006 wValue 2900 wIn=
dex 0
[    3.763974] vhci_hcd: vhci_hub_control:305:  GetHubDescriptor
[    3.763976] vhci_hcd: vhci_hub_control:398: port -1
[    3.763977] vhci_hcd: vhci_hub_control:405:  bye
[    3.764041] hub 1-0:1.0: 8 ports detected
[    3.764113] vhci_hcd: vhci_hub_control:247: typeReq a000 wValue 0 wIndex=
 0
[    3.764122] vhci_hcd: vhci_hub_control:309:  GetHubStatus
[    3.764123] vhci_hcd: vhci_hub_control:398: port -1
[    3.764124] vhci_hcd: vhci_hub_control:405:  bye
[    3.764863] vhci_hcd: vhci_hub_control:247: typeReq 2303 wValue 8 wIndex=
 1
[    3.764865] vhci_hcd: vhci_hub_control:384:  SetPortFeature: default 8
[    3.764866] vhci_hcd: vhci_hub_control:398: port 0
[    3.764868] vhci_hcd: dump_port_status_diff:101: status prev -> new: 000=
00000 -> 00000100
[    3.764869] vhci_hcd: dump_port_status_diff:115:  +POWER
[    3.764870] vhci_hcd: dump_port_status_diff:119:=20
[    3.764871] vhci_hcd: vhci_hub_control:405:  bye
[    3.764888] vhci_hcd: vhci_hub_control:247: typeReq 2303 wValue 8 wIndex=
 2
[    3.764890] vhci_hcd: vhci_hub_control:384:  SetPortFeature: default 8
[    3.764891] vhci_hcd: vhci_hub_control:398: port 1
[    3.764892] vhci_hcd: dump_port_status_diff:101: status prev -> new: 000=
00000 -> 00000100
[    3.764893] vhci_hcd: dump_port_status_diff:115:  +POWER
[    3.764894] vhci_hcd: dump_port_status_diff:119:=20
[    3.764895] vhci_hcd: vhci_hub_control:405:  bye
[    3.764918] vhci_hcd: vhci_hub_control:247: typeReq 2303 wValue 8 wIndex=
 3
[    3.764920] vhci_hcd: vhci_hub_control:384:  SetPortFeature: default 8
[    3.764921] vhci_hcd: vhci_hub_control:398: port 2
[    3.764922] vhci_hcd: dump_port_status_diff:101: status prev -> new: 000=
00000 -> 00000100
[    3.764924] vhci_hcd: dump_port_status_diff:115:  +POWER
[    3.764925] vhci_hcd: dump_port_status_diff:119:=20
[    3.764926] vhci_hcd: vhci_hub_control:405:  bye
[    3.764940] vhci_hcd: vhci_hub_control:247: typeReq 2303 wValue 8 wIndex=
 4
[    3.764942] vhci_hcd: vhci_hub_control:384:  SetPortFeature: default 8
[    3.764943] vhci_hcd: vhci_hub_control:398: port 3
[    3.764945] vhci_hcd: dump_port_status_diff:101: status prev -> new: 000=
00000 -> 00000100
[    3.764946] vhci_hcd: dump_port_status_diff:115:  +POWER
[    3.764947] vhci_hcd: dump_port_status_diff:119:=20
[    3.764948] vhci_hcd: vhci_hub_control:405:  bye
[    3.764961] vhci_hcd: vhci_hub_control:247: typeReq 2303 wValue 8 wIndex=
 5
[    3.764963] vhci_hcd: vhci_hub_control:384:  SetPortFeature: default 8
[    3.764964] vhci_hcd: vhci_hub_control:398: port 4
[    3.764965] vhci_hcd: dump_port_status_diff:101: status prev -> new: 000=
00000 -> 00000100
[    3.764967] vhci_hcd: dump_port_status_diff:115:  +POWER
[    3.764968] vhci_hcd: dump_port_status_diff:119:=20
[    3.764969] vhci_hcd: vhci_hub_control:405:  bye
[    3.764982] vhci_hcd: vhci_hub_control:247: typeReq 2303 wValue 8 wIndex=
 6
[    3.764984] vhci_hcd: vhci_hub_control:384:  SetPortFeature: default 8
[    3.764985] vhci_hcd: vhci_hub_control:398: port 5
[    3.764986] vhci_hcd: dump_port_status_diff:101: status prev -> new: 000=
00000 -> 00000100
[    3.764987] vhci_hcd: dump_port_status_diff:115:  +POWER
[    3.764989] vhci_hcd: dump_port_status_diff:119:=20
[    3.764990] vhci_hcd: vhci_hub_control:405:  bye
[    3.765003] vhci_hcd: vhci_hub_control:247: typeReq 2303 wValue 8 wIndex=
 7
[    3.765005] vhci_hcd: vhci_hub_control:384:  SetPortFeature: default 8
[    3.765006] vhci_hcd: vhci_hub_control:398: port 6
[    3.765007] vhci_hcd: dump_port_status_diff:101: status prev -> new: 000=
00000 -> 00000100
[    3.765009] vhci_hcd: dump_port_status_diff:115:  +POWER
[    3.765010] vhci_hcd: dump_port_status_diff:119:=20
[    3.765011] vhci_hcd: vhci_hub_control:405:  bye
[    3.765024] vhci_hcd: vhci_hub_control:247: typeReq 2303 wValue 8 wIndex=
 8
[    3.765026] vhci_hcd: vhci_hub_control:384:  SetPortFeature: default 8
[    3.765027] vhci_hcd: vhci_hub_control:398: port 7
[    3.765028] vhci_hcd: dump_port_status_diff:101: status prev -> new: 000=
00000 -> 00000100
[    3.765029] vhci_hcd: dump_port_status_diff:115:  +POWER
[    3.765030] vhci_hcd: dump_port_status_diff:119:=20
[    3.765031] vhci_hcd: vhci_hub_control:405:  bye
[    3.765321] vhci_hcd: vhci_hcd_probe:1028: bye
[    3.765327] vhci_hcd: vhci_hcd_init:1150: USB/IP 'Virtual' Host Controll=
er (VHCI) Driver v1.0.0
[    3.847964] usbcore: registered new interface driver usbip-host
[    3.848228] power_supply test_ac: prop ONLINE=3D1
[    3.850387] usbip_host: usbip_host_init:270: USB/IP Host Driver v1.0.0
[    3.851965] usbcore: registered new interface driver tranzport
[    3.853346] usbcore: registered new interface driver alphatrack
[    3.854839] vme_user: VME User Space Access Driver
[    3.855989] vme_user: No cards, skipping registration
[    3.858882] Loading crystalhd 0.9.27
[    3.859831] usbcore: registered new interface driver ft1000usb
[    3.861187] vhci_hcd: vhci_hub_control:247: typeReq a300 wValue 0 wIndex=
 1
[    3.862668] vhci_hcd: vhci_hub_control:313:  GetPortStatus port 1
[    3.863961] vhci_hcd: vhci_hub_control:355:  GetPortStatus bye 100 0
[    3.865352] vhci_hcd: vhci_hub_control:398: port 0
[    3.865559] usbcore: registered new interface driver gdm_wimax
[    3.865575] usbcore: registered new interface driver cedusb
[    3.868915] vhci_hcd: dump_port_status_diff:101: status prev -> new: 000=
00100 -> 00000100
[    3.869065] ipip: IPv4 over IPv4 tunneling driver
[    3.869552] gre: GRE over IPv4 demultiplexor driver
[    3.869553] IPv4 over IPSec tunneling driver
[    3.870135] TCP: cubic registered
[    3.870139] NET: Registered protocol family 17
[    3.875335] vhci_hcd: dump_port_status_diff:115:   POWER
[    3.875343] NET: Registered protocol family 9
[    3.875346] X.25 for Linux Version 0.2
[    3.878271] vhci_hcd: dump_port_status_diff:119:=20
[    3.879294] vhci_hcd: vhci_hub_control:405:  bye
[    3.879295] NET: Registered protocol family 33
[    3.879299] Key type rxrpc registered
[    3.879301] Key type rxrpc_s registered
[    3.883161] vhci_hcd: vhci_hub_control:247: typeReq a300 wValue 0 wIndex=
 2
[    3.884878] vhci_hcd: vhci_hub_control:313:  GetPortStatus port 2
[    3.884993] RxRPC: Registered security type 2 'rxkad'
[    3.885027] l2tp_core: L2TP core driver, V2.0
[    3.885029] NET4: DECnet for Linux: V.2.5.68s (C) 1995-2003 Linux DECnet=
 Project Team
[    3.889952] vhci_hcd: vhci_hub_control:355:  GetPortStatus bye 100 0
[    3.891308] vhci_hcd: vhci_hub_control:398: port 1
[    3.891395] DECnet: Routing cache hash table of 256 buckets, 16Kbytes
[    3.893782] vhci_hcd: dump_port_status_diff:101: status prev -> new: 000=
00100 -> 00000100
[    3.893854] NET: Registered protocol family 12
[    3.896490] vhci_hcd: dump_port_status_diff:115:   POWER
[    3.897649] vhci_hcd: dump_port_status_diff:119:=20
[    3.898650] vhci_hcd: vhci_hub_control:405:  bye
[    3.899660] vhci_hcd: vhci_hub_control:247: typeReq a300 wValue 0 wIndex=
 3
[    3.901155] vhci_hcd: vhci_hub_control:313:  GetPortStatus port 3
[    3.902449] vhci_hcd: vhci_hub_control:355:  GetPortStatus bye 100 0
[    3.903823] vhci_hcd: vhci_hub_control:398: port 2
[    3.904884] vhci_hcd: dump_port_status_diff:101: status prev -> new: 000=
00100 -> 00000100
[    3.906640] vhci_hcd: dump_port_status_diff:115:   POWER
[    3.907805] vhci_hcd: dump_port_status_diff:119:=20
[    3.908865] vhci_hcd: vhci_hub_control:405:  bye
[    3.909864] vhci_hcd: vhci_hub_control:247: typeReq a300 wValue 0 wIndex=
 4
[    3.911316] vhci_hcd: vhci_hub_control:313:  GetPortStatus port 4
[    3.912681] vhci_hcd: vhci_hub_control:355:  GetPortStatus bye 100 0
[    3.912700] 8021q: 802.1Q VLAN Support v1.8
[    3.914982] vhci_hcd: vhci_hub_control:398: port 3
[    3.916074] vhci_hcd: dump_port_status_diff:101: status prev -> new: 000=
00100 -> 00000100
[    3.916459] sctp: Hash tables configured (established 1024 bind 1024)
[    3.919203] vhci_hcd: dump_port_status_diff:115:   POWER
[    3.920377] vhci_hcd: dump_port_status_diff:119:=20
[    3.921406] vhci_hcd: vhci_hub_control:405:  bye
[    3.922575] vhci_hcd: vhci_hub_control:247: typeReq a300 wValue 0 wIndex=
 5
[    3.924073] rds_page_remainder_cpu_notify(): cpu 0 action 0x7
[    3.924089] vhci_hcd: vhci_hub_control:313:  GetPortStatus port 5
[    3.924091] vhci_hcd: vhci_hub_control:355:  GetPortStatus bye 100 0
[    3.924092] vhci_hcd: vhci_hub_control:398: port 4
[    3.924093] vhci_hcd: dump_port_status_diff:101: status prev -> new: 000=
00100 -> 00000100
[    3.924095] vhci_hcd: dump_port_status_diff:115:   POWER
[    3.924096] vhci_hcd: dump_port_status_diff:119:=20
[    3.924097] vhci_hcd: vhci_hub_control:405:  bye
[    3.924119] vhci_hcd: vhci_hub_control:247: typeReq a300 wValue 0 wIndex=
 6
[    3.924121] vhci_hcd: vhci_hub_control:313:  GetPortStatus port 6
[    3.924122] vhci_hcd: vhci_hub_control:355:  GetPortStatus bye 100 0
[    3.924123] vhci_hcd: vhci_hub_control:398: port 5
[    3.924125] vhci_hcd: dump_port_status_diff:101: status prev -> new: 000=
00100 -> 00000100
[    3.924126] vhci_hcd: dump_port_status_diff:115:   POWER
[    3.924127] vhci_hcd: dump_port_status_diff:119:=20
[    3.924128] vhci_hcd: vhci_hub_control:405:  bye
[    3.924140] vhci_hcd: vhci_hub_control:247: typeReq a300 wValue 0 wIndex=
 7
[    3.924141] vhci_hcd: vhci_hub_control:313:  GetPortStatus port 7
[    3.924143] vhci_hcd: vhci_hub_control:355:  GetPortStatus bye 100 0
[    3.924144] vhci_hcd: vhci_hub_control:398: port 6
[    3.924146] vhci_hcd: dump_port_status_diff:101: status prev -> new: 000=
00100 -> 00000100
[    3.924147] vhci_hcd: dump_port_status_diff:115:   POWER
[    3.924148] vhci_hcd: dump_port_status_diff:119:=20
[    3.924149] vhci_hcd: vhci_hub_control:405:  bye
[    3.924161] vhci_hcd: vhci_hub_control:247: typeReq a300 wValue 0 wIndex=
 8
[    3.924163] vhci_hcd: vhci_hub_control:313:  GetPortStatus port 8
[    3.924164] vhci_hcd: vhci_hub_control:355:  GetPortStatus bye 100 0
[    3.924165] vhci_hcd: vhci_hub_control:398: port 7
[    3.924167] vhci_hcd: dump_port_status_diff:101: status prev -> new: 000=
00100 -> 00000100
[    3.924168] vhci_hcd: dump_port_status_diff:115:   POWER
[    3.924169] vhci_hcd: dump_port_status_diff:119:=20
[    3.924170] vhci_hcd: vhci_hub_control:405:  bye
[    3.924385] usb usb1: vhci_bus_suspend
[    3.924395] vhci_hcd: vhci_hub_status:208: changed 0
[    3.965612] rds_page_remainder_cpu_notify(): cpu 1 action 0x7
[    3.966962] NET: Registered protocol family 37
[    3.968056] NET: Registered protocol family 36
[    3.969093] Key type dns_resolver registered
[    3.970025] Key type ceph registered
[    3.971173] libceph: loaded (mon/osd proto 15/24)
[    3.972209] mpls_gso: MPLS GSO support
[    3.973661]=20
[    3.973661] printing PIC contents
[    3.974693] ... PIC  IMR: ffff
[    3.975343] ... PIC  IRR: 1013
[    3.976058] ... PIC  ISR: 0000
[    3.976738] ... PIC ELCR: 0c00
[    3.977423] printing local APIC contents on CPU#0/0:
[    3.978508] ... APIC ID:      00000000 (0)
[    3.979395] ... APIC VERSION: 00050014
[    3.980242] ... APIC TASKPRI: 00000000 (00)
[    3.981166] ... APIC PROCPRI: 00000000
[    3.981415] ... APIC LDR: 01000000
[    3.981415] ... APIC DFR: ffffffff
[    3.981415] ... APIC SPIV: 000001ff
[    3.981415] ... APIC ISR field:
[    3.981415] 000000000000000000000000000000000000000000000000000000000000=
0000
[    3.981415] ... APIC TMR field:
[    3.981415] 000000000200000000000000000000000000000000000000000000000000=
0000
[    3.981415] ... APIC IRR field:
[    3.981415] 000000000000000000000000000000000000000000000000000000000000=
8000
[    3.981415] ... APIC ESR: 00000000
[    3.981415] ... APIC ICR: 000008fd
[    3.981415] ... APIC ICR2: 02000000
[    3.981415] ... APIC LVTT: 000000ef
[    3.981415] ... APIC LVTPC: 00010000
[    3.981415] ... APIC LVT0: 00010700
[    3.981415] ... APIC LVT1: 00000400
[    3.981415] ... APIC LVTERR: 000000fe
[    3.981415] ... APIC TMICT: 0003c7d3
[    3.981415] ... APIC TMCCT: 00000000
[    3.981415] ... APIC TDCR: 00000003
[    3.981415]=20
[    4.001016] number of MP IRQ sources: 15.
[    4.001891] number of IO-APIC #0 registers: 24.
[    4.002870] testing the IO APIC.......................
[    4.003984] IO APIC #0......
[    4.004668] .... register #00: 00000000
[    4.005473] .......    : physical APIC id: 00
[    4.006416] .......    : Delivery Type: 0
[    4.007277] .......    : LTS          : 0
[    4.008175] .... register #01: 00170011
[    4.009006] .......     : max redirection entries: 17
[    4.010067] .......     : PRQ implemented: 0
[    4.010988] .......     : IO APIC version: 11
[    4.011922] .... register #02: 00000000
[    4.012766] .......     : arbitration: 00
[    4.013622] .... IRQ redirection table:
[    4.014443] 1    0    0   0   0    0    0    00
[    4.015421] 0    0    0   0   0    1    1    31
[    4.016445] 0    0    0   0   0    1    1    30
[    4.017418] 0    0    0   0   0    1    1    33
[    4.018396] 1    0    0   0   0    1    1    34
[    4.019371] 1    1    0   0   0    1    1    35
[    4.020366] 0    0    0   0   0    1    1    36
[    4.021347] 0    0    0   0   0    1    1    37
[    4.022312] 0    0    0   0   0    1    1    38
[    4.023277] 0    1    0   0   0    1    1    39
[    4.024271] 1    1    0   0   0    1    1    3A
[    4.025250] 1    1    0   0   0    1    1    3B
[    4.026225] 0    0    0   0   0    1    1    3C
[    4.027203] 0    0    0   0   0    1    1    3D
[    4.028196] 0    0    0   0   0    1    1    3E
[    4.029164] 0    0    0   0   0    1    1    3F
[    4.030135] 1    0    0   0   0    0    0    00
[    4.031111] 1    0    0   0   0    0    0    00
[    4.032101] 1    0    0   0   0    0    0    00
[    4.033071] 1    0    0   0   0    0    0    00
[    4.034045] 1    0    0   0   0    0    0    00
[    4.035022] 1    0    0   0   0    0    0    00
[    4.035995] 1    0    0   0   0    0    0    00
[    4.036990] 1    0    0   0   0    0    0    00
[    4.037944] IRQ to pin mappings:
[    4.038633] IRQ0 -> 0:2
[    4.039212] IRQ1 -> 0:1
[    4.039812] IRQ3 -> 0:3
[    4.040413] IRQ4 -> 0:4
[    4.041023] IRQ5 -> 0:5
[    4.041619] IRQ6 -> 0:6
[    4.042200] IRQ7 -> 0:7
[    4.042796] IRQ8 -> 0:8
[    4.043375] IRQ9 -> 0:9
[    4.043974] IRQ10 -> 0:10
[    4.044642] IRQ11 -> 0:11
[    4.045257] IRQ12 -> 0:12
[    4.045891] IRQ13 -> 0:13
[    4.046528] IRQ14 -> 0:14
[    4.047145] IRQ15 -> 0:15
[    4.047778] .................................... done.
[    4.049551] registered taskstats version 1
[    4.051205] rtc-test rtc-test.0: setting system clock to 2013-09-27 18:3=
6:21 UTC (1380306981)
[    4.054577] debug: unmapping init [mem 0xffffffff81e1c000-0xffffffff81ee=
efff]

mount: mounting proc on /proc failed: No such device
/etc/rcS.d/S00fbsetup: line 3: /sbin/modprobe: not found

Please wait: booting...
mount: mounting proc on /proc failed: No such device
grep: /proc/filesystems: No such file or directory
[    4.188118] BUG: sleeping function called from invalid context at mm/sla=
b.c:3060
[    4.190236] in_atomic(): 1, irqs_disabled(): 0, pid: 0, name: swapper/0
[    4.191696] 1 lock held by swapper/0/0:
Starting Bootlog daemon:=20
[    4.192991]  #0:  (H
[    4.195103] CPU: 0 PID: 0 Comm: swapper/0 Not tainted 3.12.0-rc2-02842-g=
45c4ea0 #25
[    4.196824]  ffffffff810c393f ffff88000f003d50 ffffffff81856222 ffffffff=
81c6c480
[    4.198578]  ffff88000f003d70 ffffffff810b9f17 00000000000000d0 ffffffff=
81c6cad8
[    4.200320]  ffff88000f003da0 ffffffff811214ed ffffffff81c6c480 ffffffff=
81c6cad8
[    4.202058] Call Trace:
[    4.202610]  <IRQ>  [<ffffffff810c393f>] ? console_unlock+0x312/0x35b
[    4.204128]  [<ffffffff81856222>] dump_stack+0x4e/0x7a
[    4.205295]  [<ffffffff810b9f17>] __might_sleep+0x10a/0x10f
[    4.206550]  [<ffffffff811214ed>] kmem_cache_alloc+0x35/0x9d
bootlogd: cannot
[    4.207845]  [<ffffffff81031dd8>] init_fpu+0x51/0x91
 allocate pseudo
[    4.209105]  [<ffffffff8102b066>] math_state_restore+0x26/0x127
 tty: No such fi
[    4.210497]  [<ffffffff8102b174>] do_device_not_available+0xd/0xf
le or directory
[    4.212059]  [<ffffffff81862bde>] device_not_available+0x1e/0x30
[    4.213624]  [<ffffffff8109e8d2>] ? call_timer_fn+0x67/0xd4

[    4.214864]  [<ffffffff8109e86b>] ? process_timeout+0xb/0xb
[    4.216153]  [<ffffffff8109eff1>] run_timer_softirq+0x18d/0x1b8
[    4.217451]  [<ffffffff8109b40a>] __do_softirq+0xc6/0x196
bootlogd.
[    4.218708]  [<ffffffff8109b5e3>] irq_exit+0x50/0x86
[    4.219901]  [<ffffffff8104585c>] smp_apic_timer_interrupt+0x30/0x3c

[    4.221385]  [<ffffffff818626f2>] apic_timer_interrupt+0x72/0x80
[    4.222755]  <EOI>  [<ffffffff810bf879>] ? idle_balance+0x13f/0x17a
[    4.224215]  [<ffffffff810b278d>] ? notifier_call_chain+0x59/0x59
[    4.225591]  [<ffffffff810b278d>] ? notifier_call_chain+0x59/0x59
[    4.226916]  [<ffffffff8104abba>] ? native_safe_halt+0x6/0x8
[    4.228168]  [<ffffffff810d3708>] ? trace_hardirqs_on+0xd/0xf
[    4.229425]  [<ffffffff810311d1>] default_idle+0x13/0x1c
[    4.230609]  [<ffffffff810318bc>] arch_cpu_idle+0x13/0x21
[    4.231797]  [<ffffffff810c5202>] cpu_startup_entry+0x118/0x19c
[    4.233091]  [<ffffffff81850105>] rest_init+0xb9/0xbd
[    4.234170]  [<ffffffff8185004c>] ? csum_partial_copy_generic+0x16c/0x16c
[    4.235659]  [<ffffffff81e2fd3a>] start_kernel+0x416/0x422
[    4.236891]  [<ffffffff81e2f732>] ? repair_env_string+0x58/0x58
[    4.238191]  [<ffffffff81e2f120>] ? early_idt_handlers+0x120/0x120
[    4.239571]  [<ffffffff81e2f44c>] x86_64_start_reservations+0x2a/0x2c
[    4.240990]  [<ffffffff81e2f52a>] x86_64_start_kernel+0xdc/0xe9
[    4.242287] invalid opcode: 0000 [#1] PREEMPT SMP DEBUG_PAGEALLOC
[    4.243776] CPU: 0 PID: 0 Comm: swapper/0 Not tainted 3.12.0-rc2-02842-g=
45c4ea0 #25
[    4.244977] task: ffffffff81c6c480 ti: ffffffff81c5e000 task.ti: fffffff=
f81c5e000
[    4.244977] RIP: 0010:[<ffffffff81f3dd21>]  [<ffffffff81f3dd21>] boot_tv=
ec_bases+0x2a1/0x2080
[    4.244977] RSP: 0018:ffff88000f003ea0  EFLAGS: 00010a12
[    4.244977] RAX: 0000000000000001 RBX: 0000000000000101 RCX: 00000000000=
0ff00
[    4.244977] RDX: 0000000000000f2e RSI: ffffffff81f80848 RDI: ffffffff81f=
3dd18
[    4.244977] RBP: ffff88000f003ee8 R08: 0000000000000000 R09: 00000000000=
00000
mo[un t:  c an 't4 r.ea244977] R10: 0000000000000001 R11: ffff88000f00a000 =
R12: ffffffff81f3dd18
[    4.256416] R13: ffffffff81f3dd18 R14: ffffffff81f3dd18 R15: ffffffff81f=
3dd18
[    4.256823] FS:  0000000000000000(0000) GS:ffff88000f000000(0000) knlGS:=
0000000000000000
[    4.256823] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[    4.256823] CR2: 000000000068d8d8 CR3: 0000000001c67000 CR4: 00000000000=
006b0
[    4.256823] Stack:
d ['/p roc/ mo un ts4'.256823]  ffffffff8109e8d2 ffffffff8109e86b ffffffff8=
1f3dd28 ffffffff8234ef20
[    4.256823]  0000000000000000:  Nof sfucfh ffiflef off81f3dd48 ffffffff8=
1f3da80 ffffffff81f3dcf8
[    4.256823]  ffff88000f003ef8 ffff88000f003f30 ffffffff8109eff1 ffff8800=
0cd658a0
[    4.256823] Call Trace:
[    4.256823]  <IRQ>=20
r [direc to ry
  4.256823]  [<ffffffff8109e8d2>] ? call_timer_fn+0x67/0xd4
[    4.256823]  [<ffffffff8109e86b>] ? process_timeout+0xb/0xb
[    4.256823]  [<ffffffff8109eff1>] run_timer_softirq+0x18d/0x1b8
[    4.273849]  [<ffffffff8109b40a>] __do_softirq+0xc6/0x196
[    4.273849]  [<ffffffff8109b5e3>] irq_exit+0x50/0x86
[    4.273849]  [<ffffffff8104585c>] smp_apic_timer_interrupt+0x30/0x3c
[    4.273849]  [<ffffffff818626f2>] apic_timer_interrupt+0x72/0x80
[    4.273849]  <EOI>=20
[    4.273849]  [<ffffffff810bf879>] ? idle_balance+0x13f/0x17a
[    4.273849]  [<ffffffff810b278d>] ? notifier_call_chain+0x59/0x59
[    4.273849]  [<ffffffff810b278d>] ? notifier_call_chain+0x59/0x59
[    4.273849]  [<ffffffff8104abba>] ? native_safe_halt+0x6/0x8
[    4.273849]  [<ffffffff810d3708>] ? trace_hardirqs_on+0xd/0xf
[    4.273849]  [<ffffffff810311d1>] default_idle+0x13/0x1c
[    4.273849]  [<ffffffff810318bc>] arch_cpu_idle+0x13/0x21
[    4.273849]  [<ffffffff810c5202>] cpu_startup_entry+0x118/0x19c
[    4.273849]  [<ffffffff81850105>] rest_init+0xb9/0xbd
[    4.273849]  [<ffffffff8185004c>] ? csum_partial_copy_generic+0x16c/0x16c
[    4.273849]  [<ffffffff81e2fd3a>] start_kernel+0x416/0x422
[    4.273849]  [<ffffffff81e2f732>] ? repair_env_string+0x58/0x58
[    4.273849]  [<ffffffff81e2f120>] ? early_idt_handlers+0x120/0x120
[    4.273849]  [<ffffffff81e2f44c>] x86_64_start_reservations+0x2a/0x2c
[    4.273849]  [<ffffffff81e2f52a>] x86_64_start_kernel+0xdc/0xe9
[    4.273849] Code: ff ff 00 00 00 00 00 00 00 00 00 02 20 00 00 00 ad de =
08 dd f3 81 ff ff ff ff 08 dd f3 81 ff ff ff ff 18 dd f3 81 ff ff ff ff 18 =
<dd> f3 81 ff ff ff ff 28 dd f3 81 ff ff ff ff 28 dd f3 81 ff ff=20
[    4.273849] RIP  [<ffffffff81f3dd21>] boot_tvec_bases+0x2a1/0x2080
[    4.273849]  RSP <ffff88000f003ea0>
[    4.307230] ---[ end trace 32f1882d260e7c4e ]---
[    4.308371] Kernel panic - not syncing: Fatal exception in interrupt
[    4.309894] Rebooting in 10 seconds..
BUG: kernel test oops
Elapsed time: 10
qemu-system-x86_64 -cpu kvm64 -enable-kvm -kernel /kernel/x86_64-randconfig=
-x1-0928/45c4ea0c4c1b8abffb575b865243fd1c69bbecd9/vmlinuz-3.12.0-rc2-02842-=
g45c4ea0 -append 'hung_task_panic=3D1 rcutree.rcu_cpu_stall_timeout=3D100 l=
og_buf_len=3D8M ignore_loglevel debug sched_debug apic=3Ddebug dynamic_prin=
tk sysrq_always_enabled panic=3D10  prompt_ramdisk=3D0 console=3DttyS0,1152=
00 console=3Dtty0 vga=3Dnormal  root=3D/dev/ram0 rw link=3D/kernel-tests/ru=
n-queue/kvm/x86_64-randconfig-x1-0928/next:master/.vmlinuz-45c4ea0c4c1b8abf=
fb575b865243fd1c69bbecd9-20130928121103-8-lkp-tt02 branch=3Dnext/master BOO=
T_IMAGE=3D/kernel/x86_64-randconfig-x1-0928/45c4ea0c4c1b8abffb575b865243fd1=
c69bbecd9/vmlinuz-3.12.0-rc2-02842-g45c4ea0'  -initrd /kernel-tests/initrd/=
yocto-minimal-x86_64.cgz -m 256M -smp 2 -net nic,vlan=3D0,macaddr=3D00:00:0=
0:00:00:00,model=3Dvirtio -net user,vlan=3D0,hostfwd=3Dtcp::13136-:22 -net =
nic,vlan=3D1,model=3De1000 -net user,vlan=3D1 -boot order=3Dnc -no-reboot -=
watchdog i6300esb -pidfile /dev/shm/kboot/pid-lkp-tt02-lkp-9040 -serial fil=
e:/dev/shm/kboot/serial-lkp-tt02-lkp-9040 -daemonize -display none -monitor=
 null=20

--SLDf9lqlvOQaIe6s
Content-Type: application/octet-stream
Content-Disposition: attachment; filename="bisect-45c4ea0c4c1b8abffb575b865243fd1c69bbecd9-x86_64-randconfig-x1-0928-BUG:-sleeping-function-called-from-invalid-context-at-105490.log"
Content-Transfer-Encoding: base64

Z2l0IGNoZWNrb3V0IDQ1YzRlYTBjNGMxYjhhYmZmYjU3NWI4NjUyNDNmZDFjNjliYmVjZDkK
SEVBRCBpcyBub3cgYXQgNDVjNGVhMC4uLiBNZXJnZSByZW1vdGUtdHJhY2tpbmcgYnJhbmNo
ICdsem8tdXBkYXRlL2x6by11cGRhdGUnCmxzIC1hIC9rZXJuZWwtdGVzdHMvcnVuLXF1ZXVl
L2t2bS94ODZfNjQtcmFuZGNvbmZpZy14MS0wOTI4L25leHQ6bWFzdGVyOjQ1YzRlYTBjNGMx
YjhhYmZmYjU3NWI4NjUyNDNmZDFjNjliYmVjZDk6YmlzZWN0LW1tCiBURVNUIEZBSUxVUkUK
WyAgIDMzLjcyOTk0MF0gU2Nhbm5pbmcgZGV2aWNlIGZvciBiYWQgYmxvY2tzClsgICAzNC41
NzY0NjRdIC0tLS0tLS0tLS0tLVsgY3V0IGhlcmUgXS0tLS0tLS0tLS0tLQpbICAgMzQuNTc3
OTEzXSBXQVJOSU5HOiBDUFU6IDAgUElEOiAxIGF0IGtlcm5lbC93b3JrcXVldWUuYzo2MDMg
c2V0X3dvcmtfZGF0YSsweDMzLzB4NTAoKQpbICAgMzQuNTc5MTkzXSBDUFU6IDAgUElEOiAx
IENvbW06IHN3YXBwZXIvMCBOb3QgdGFpbnRlZCAzLjEyLjAtcmMyLTAyODQyLWc0NWM0ZWEw
ICMyNQpbICAgMzQuNTgwMjI2XSAgZmZmZmZmZmY4MTBjMzkzZiBmZmZmODgwMDBmMDAzZDkw
IGZmZmZmZmZmODE4NTYyMjIgMDAwMDAwMDAwMDAwMDAwMApbICAgMzQuNTgwMjI2XSAgZmZm
Zjg4MDAwZjAwM2RjOCBmZmZmZmZmZjgxMDk3ZGZkIGZmZmZmZmZmODEwYTY3MDMgZmZmZjg4
MDAwY2M3Zjg2MApbICAgMzQuNTgwMjI2XSAgZmZmZjg4MDAwZjAxMzQwMCAwMDAwMDAwMDAw
MDAwMDA1IGZmZmY4ODAwMGYwMTE2NDAgZmZmZjg4MDAwZjAwM2RkOApbICAgMzQuNTgwMjI2
XSBDYWxsIFRyYWNlOgpbICAgMzQuNTgwMjI2XSAgPElSUT4gIFs8ZmZmZmZmZmY4MTBjMzkz
Zj5dID8gY29uc29sZV91bmxvY2srMHgzMTIvMHgzNWIKWyAgIDM0LjU4MDIyNl0gIFs8ZmZm
ZmZmZmY4MTg1NjIyMj5dIGR1bXBfc3RhY2srMHg0ZS8weDdhClsgICAzNC41ODAyMjZdICBb
PGZmZmZmZmZmODEwOTdkZmQ+XSB3YXJuX3Nsb3dwYXRoX2NvbW1vbisweDcwLzB4ODkKWyAg
IDM0LjU4MDIyNl0gIFs8ZmZmZmZmZmY4MTBhNjcwMz5dID8gc2V0X3dvcmtfZGF0YSsweDMz
LzB4NTAKWyAgIDM0LjU4MDIyNl0gIFs8ZmZmZmZmZmY4MTA5N2VkOD5dIHdhcm5fc2xvd3Bh
dGhfbnVsbCsweDE1LzB4MTcKWyAgIDM0LjU4MDIyNl0gIFs8ZmZmZmZmZmY4MTBhNjcwMz5d
IHNldF93b3JrX2RhdGErMHgzMy8weDUwClsgICAzNC41ODAyMjZdICBbPGZmZmZmZmZmODEw
YTc0MTU+XSBpbnNlcnRfd29yaysweDI3LzB4NjUKWyAgIDM0LjU4MDIyNl0gIFs8ZmZmZmZm
ZmY4MTBhNzYyMj5dIF9fcXVldWVfd29yaysweDFjZi8weDFlZQpbICAgMzQuNTgwMjI2XSAg
WzxmZmZmZmZmZjgxMGE3NjQxPl0gPyBfX3F1ZXVlX3dvcmsrMHgxZWUvMHgxZWUKWyAgIDM0
LjU4MDIyNl0gIFs8ZmZmZmZmZmY4MTBhNzY0MT5dID8gX19xdWV1ZV93b3JrKzB4MWVlLzB4
MWVlClsgICAzNC41ODAyMjZdICBbPGZmZmZmZmZmODEwYTc2NWE+XSBkZWxheWVkX3dvcmtf
dGltZXJfZm4rMHgxOS8weDFiClsgICAzNC41ODAyMjZdICBbPGZmZmZmZmZmODEwOWU4ZDI+
XSBjYWxsX3RpbWVyX2ZuKzB4NjcvMHhkNApbICAgMzQuNTgwMjI2XSAgWzxmZmZmZmZmZjgx
MDllODZiPl0gPyBwcm9jZXNzX3RpbWVvdXQrMHhiLzB4YgpbICAgMzQuNTgwMjI2XSAgWzxm
ZmZmZmZmZjgxMDllZmQ0Pl0gcnVuX3RpbWVyX3NvZnRpcnErMHgxNzAvMHgxYjgKWyAgIDM0
LjU4MDIyNl0gIFs8ZmZmZmZmZmY4MTA5YjQwYT5dIF9fZG9fc29mdGlycSsweGM2LzB4MTk2
ClsgICAzNC41ODAyMjZdICBbPGZmZmZmZmZmODEwOWI1ZTM+XSBpcnFfZXhpdCsweDUwLzB4
ODYKWyAgIDM0LjU4MDIyNl0gIFs8ZmZmZmZmZmY4MTAyYjdhYT5dIGRvX0lSUSsweDg4LzB4
OWYKWyAgIDM0LjU4MDIyNl0gIFs8ZmZmZmZmZmY4MTg2MTFiMj5dIGNvbW1vbl9pbnRlcnJ1
cHQrMHg3Mi8weDcyClsgICAzNC41ODAyMjZdICA8RU9JPiAgWzxmZmZmZmZmZjgxNjY0NjQ5
Pl0gPyBsZWRfdHJpZ2dlcl9ldmVudCsweDI2LzB4NTQKWyAgIDM0LjU4MDIyNl0gIFs8ZmZm
ZmZmZmY4MTBkMWNlZD5dID8gYXJjaF9sb2NhbF9pcnFfcmVzdG9yZSsweDYvMHhkClsgICAz
NC41ODAyMjZdICBbPGZmZmZmZmZmODEwZDUzN2Q+XSBsb2NrX2FjcXVpcmUrMHg5NC8weDlk
ClsgICAzNC41ODAyMjZdICBbPGZmZmZmZmZmODE2NjQ2NDk+XSA/IGxlZF90cmlnZ2VyX2V2
ZW50KzB4MjYvMHg1NApbICAgMzQuNTgwMjI2XSAgWzxmZmZmZmZmZjgxODYwODhlPl0gX3Jh
d19yZWFkX2xvY2srMHgzNi8weDQyClsgICAzNC41ODAyMjZdICBbPGZmZmZmZmZmODE2NjQ2
NDk+XSA/IGxlZF90cmlnZ2VyX2V2ZW50KzB4MjYvMHg1NApbICAgMzQuNTgwMjI2XSAgWzxm
ZmZmZmZmZjgxNjY0NjQ5Pl0gbGVkX3RyaWdnZXJfZXZlbnQrMHgyNi8weDU0ClsgICAzNC41
ODAyMjZdICBbPGZmZmZmZmZmODE0ZTVlNTE+XSBuYW5kX3dhaXRfcmVhZHkrMHg3Yi8weGFj
ClsgICAzNC41ODAyMjZdICBbPGZmZmZmZmZmODE0ZTY2ZDc+XSBuYW5kX3JlYWRfb29iKzB4
MWE4LzB4MjcwClsgICAzNC41ODAyMjZdICBbPGZmZmZmZmZmODE0Y2Y1ZWQ+XSBtdGRfcmVh
ZF9vb2IrMHgyNi8weDRjClsgICAzNC41ODAyMjZdICBbPGZmZmZmZmZmODE0ZTkxZTM+XSBj
cmVhdGVfYmJ0KzB4MjBmLzB4MjlhClsgICAzNC41ODAyMjZdICBbPGZmZmZmZmZmODE0ZTky
ZWQ+XSBuYW5kX3NjYW5fYmJ0KzB4N2YvMHg0ZGQKWyAgIDM0LjU4MDIyNl0gIFs8ZmZmZmZm
ZmY4MTEyMWJkND5dID8gX19rbWFsbG9jKzB4OTAvMHhiYgpbICAgMzQuNTgwMjI2XSAgWzxm
ZmZmZmZmZjgxNGU5ODJhPl0gbmFuZF9kZWZhdWx0X2JidCsweGRmLzB4ZTQKWyAgIDM0LjU4
MDIyNl0gIFs8ZmZmZmZmZmY4MWU1OTgwND5dIG5zX2luaXRfbW9kdWxlKzB4NTZjLzB4ZDI4
ClsgICAzNC41ODAyMjZdICBbPGZmZmZmZmZmODEyMmVlYjM+XSA/IGZyZWVfcnMrMHg3NS8w
eDc4ClsgICAzNC41ODAyMjZdICBbPGZmZmZmZmZmODFlNTkyOTg+XSA/IG5mdGxfc2Nhbl9i
YnQrMHgzMTIvMHgzMTIKWyAgIDM0LjU4MDIyNl0gIFs8ZmZmZmZmZmY4MWUyZmRkND5dIGRv
X29uZV9pbml0Y2FsbCsweDhlLzB4MTM0ClsgICAzNC41ODAyMjZdICBbPGZmZmZmZmZmODEw
YWNhMDA+XSA/IHBhcmFtZXFuKzB4MzYvMHgzNgpbICAgMzQuNTgwMjI2XSAgWzxmZmZmZmZm
ZjgxMGFjYmEzPl0gPyBwYXJzZV9hcmdzKzB4MTg0LzB4MjQyClsgICAzNC41ODAyMjZdICBb
PGZmZmZmZmZmODFlMmZmY2U+XSBrZXJuZWxfaW5pdF9mcmVlYWJsZSsweDE1NC8weDFkNQpb
ICAgMzQuNTgwMjI2XSAgWzxmZmZmZmZmZjgxZTJmNmRhPl0gPyBkb19lYXJseV9wYXJhbSsw
eDg4LzB4ODgKWyAgIDM0LjU4MDIyNl0gIFs8ZmZmZmZmZmY4MTg1MDEwOT5dID8gcmVzdF9p
bml0KzB4YmQvMHhiZApbICAgMzQuNTgwMjI2XSAgWzxmZmZmZmZmZjgxODUwMTEyPl0ga2Vy
bmVsX2luaXQrMHg5LzB4Y2MKWyAgIDM0LjU4MDIyNl0gIFs8ZmZmZmZmZmY4MTg2MTljYz5d
IHJldF9mcm9tX2ZvcmsrMHg3Yy8weGIwClsgICAzNC41ODAyMjZdICBbPGZmZmZmZmZmODE4
NTAxMDk+XSA/IHJlc3RfaW5pdCsweGJkLzB4YmQKWyAgIDM0LjU4MDIyNl0gLS0tWyBlbmQg
dHJhY2UgM2MxMjkwNjZmMTZkNjJiNSBdLS0tCi9rZXJuZWwveDg2XzY0LXJhbmRjb25maWct
eDEtMDkyOC80NWM0ZWEwYzRjMWI4YWJmZmI1NzViODY1MjQzZmQxYzY5YmJlY2Q5L2RtZXNn
LXlvY3RvLWxrcC10dDAyLTEwOjIwMTMwOTI4MDIzNjI3OjMuMTIuMC1yYzItMDI4NDItZzQ1
YzRlYTA6MjUKL2tlcm5lbC94ODZfNjQtcmFuZGNvbmZpZy14MS0wOTI4LzQ1YzRlYTBjNGMx
YjhhYmZmYjU3NWI4NjUyNDNmZDFjNjliYmVjZDkvZG1lc2cteW9jdG8tbGtwLXR0MDItMTA6
MjAxMzA5MjgwMjM2NDQ6My4xMi4wLXJjMi0wMjg0Mi1nNDVjNGVhMDoyNQova2VybmVsL3g4
Nl82NC1yYW5kY29uZmlnLXgxLTA5MjgvNDVjNGVhMGM0YzFiOGFiZmZiNTc1Yjg2NTI0M2Zk
MWM2OWJiZWNkOS9kbWVzZy15b2N0by1sa3AtdHQwMi0xNToyMDEzMTAwMjEyNTUzOTozLjEy
LjAtcmMyLTAyODQyLWc0NWM0ZWEwOjI1Ci9rZXJuZWwveDg2XzY0LXJhbmRjb25maWcteDEt
MDkyOC80NWM0ZWEwYzRjMWI4YWJmZmI1NzViODY1MjQzZmQxYzY5YmJlY2Q5L2RtZXNnLXlv
Y3RvLXhpYW4tMzE6MjAxMzA5MjgxMjIzNTE6My4xMi4wLXJjMi0wMjg0Mi1nNDVjNGVhMDoy
NQoKYmlzZWN0OiBiYWQgY29tbWl0IDQ1YzRlYTBjNGMxYjhhYmZmYjU3NWI4NjUyNDNmZDFj
NjliYmVjZDkKZ2l0IGNoZWNrb3V0IHYzLjExClByZXZpb3VzIEhFQUQgcG9zaXRpb24gd2Fz
IDQ1YzRlYTAuLi4gTWVyZ2UgcmVtb3RlLXRyYWNraW5nIGJyYW5jaCAnbHpvLXVwZGF0ZS9s
em8tdXBkYXRlJwpIRUFEIGlzIG5vdyBhdCA2ZTQ2NjQ1Li4uIExpbnV4IDMuMTEKbHMgLWEg
L2tlcm5lbC10ZXN0cy9ydW4tcXVldWUva3ZtL3g4Nl82NC1yYW5kY29uZmlnLXgxLTA5Mjgv
bmV4dDptYXN0ZXI6NmU0NjY0NTI1YjFkYjI4ZjhjNGUxMTMwOTU3ZjcwYTk0YzE5MjEzZTpi
aXNlY3QtbW0KCjIwMTMtMTAtMDItMjI6Mjk6NTUgNmU0NjY0NTI1YjFkYjI4ZjhjNGUxMTMw
OTU3ZjcwYTk0YzE5MjEzZSBjb21waWxpbmcKNTcxIHJlYWwgIDE0MzkgdXNlciAgMTQxIHN5
cyAgMjc2Ljg2JSBjcHUgCXg4Nl82NC1yYW5kY29uZmlnLXgxLTA5MjgKCjIwMTMtMTAtMDIt
MjI6NDA6MzAgZGV0ZWN0aW5nIGJvb3Qgc3RhdGUgMy4xMS4wLi4JMwkxMgkyNAkzMwk0MAk1
MQk2Mwk3MQk3Ngk4Mwk4OQk5NS4JOTcJOTguLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4u
Li4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4u
Li4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4u
Li4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4u
Li4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4u
Li4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4u
Li4uG1sxOzM1bWFkZF90b19ydW5fcXVldWUgMhtbMG0KLi4JOTkJMTAwIFNVQ0NFU1MKCmJp
c2VjdDogZ29vZCBjb21taXQgdjMuMTEKZ2l0IGJpc2VjdCBzdGFydCA0NWM0ZWEwYzRjMWI4
YWJmZmI1NzViODY1MjQzZmQxYzY5YmJlY2Q5IHYzLjExIC0tClByZXZpb3VzIEhFQUQgcG9z
aXRpb24gd2FzIDZlNDY2NDUuLi4gTGludXggMy4xMQpIRUFEIGlzIG5vdyBhdCAzYzBlZWUz
Li4uIExpbnV4IDIuNi4zNwpCaXNlY3Rpbmc6IDY2NDggcmV2aXNpb25zIGxlZnQgdG8gdGVz
dCBhZnRlciB0aGlzIChyb3VnaGx5IDEzIHN0ZXBzKQpbMzllZGEyYWJhNmJlNjQyYjcxZjJl
MGFkNjIzZGNiMDlmZDlkNzljZl0gTWVyZ2UgYnJhbmNoICduZXh0JyBvZiBnaXQ6Ly9naXQu
a2VybmVsLm9yZy9wdWIvc2NtL2xpbnV4L2tlcm5lbC9naXQvYmVuaC9wb3dlcnBjCmdpdCBi
aXNlY3QgcnVuIC9jL2tlcm5lbC10ZXN0cy9iaXNlY3QtdGVzdC1ib290LWZhaWx1cmUuc2gg
L2hvbWUvd2ZnL21tL29iai1iaXNlY3QKcnVubmluZyAvYy9rZXJuZWwtdGVzdHMvYmlzZWN0
LXRlc3QtYm9vdC1mYWlsdXJlLnNoIC9ob21lL3dmZy9tbS9vYmotYmlzZWN0CmxzIC1hIC9r
ZXJuZWwtdGVzdHMvcnVuLXF1ZXVlL2t2bS94ODZfNjQtcmFuZGNvbmZpZy14MS0wOTI4L25l
eHQ6bWFzdGVyOjM5ZWRhMmFiYTZiZTY0MmI3MWYyZTBhZDYyM2RjYjA5ZmQ5ZDc5Y2Y6Ymlz
ZWN0LW1tCgoyMDEzLTEwLTAzLTAxOjIyOjE2IDM5ZWRhMmFiYTZiZTY0MmI3MWYyZTBhZDYy
M2RjYjA5ZmQ5ZDc5Y2YgY29tcGlsaW5nCjI1MCByZWFsICAxNTExIHVzZXIgIDE0NyBzeXMg
IDY2Mi41MCUgY3B1IAl4ODZfNjQtcmFuZGNvbmZpZy14MS0wOTI4CgoyMDEzLTEwLTAzLTAx
OjI4OjE4IGRldGVjdGluZyBib290IHN0YXRlIDMuMTEuMC0wNjM3NS1nMzllZGEyYS4uIFRF
U1QgRkFJTFVSRQovZXRjL2tlcm5lbC10ZXN0cy85OS10cmluaXR5OiBsaW5lIDE1OiAvdHJp
bml0eTogbm90IGZvdW5kClsgICAgMS43ODIzODldIGlucHV0OiBJbUV4UFMvMiBHZW5lcmlj
IEV4cGxvcmVyIE1vdXNlIGFzIC9kZXZpY2VzL3BsYXRmb3JtL2k4MDQyL3NlcmlvMS9pbnB1
dC9pbnB1dDIKWyAgICAxLjgyODEzM10gQlVHOiBzbGVlcGluZyBmdW5jdGlvbiBjYWxsZWQg
ZnJvbSBpbnZhbGlkIGNvbnRleHQgYXQgL2Mvd2ZnL21tL21tL3NsYWIuYzozMDYwClsgICAg
MS44Mjk0MjZdIGluX2F0b21pYygpOiAxLCBpcnFzX2Rpc2FibGVkKCk6IDAsIHBpZDogMCwg
bmFtZTogc3dhcHBlci8wClsgICAgMS44MzA0MjJdIDEgbG9jayBoZWxkIGJ5IHN3YXBwZXIv
MC8wOgpbICAgIDEuODMwOTgyXSAgIzA6ICAoClsgICAgMS44MzI0NzNdIENQVTogMCBQSUQ6
IDAgQ29tbTogc3dhcHBlci8wIE5vdCB0YWludGVkIDMuMTEuMC0wNjM3NS1nMzllZGEyYSAj
Mzg0Ci9rZXJuZWwveDg2XzY0LXJhbmRjb25maWcteDEtMDkyOC8zOWVkYTJhYmE2YmU2NDJi
NzFmMmUwYWQ2MjNkY2IwOWZkOWQ3OWNmL2RtZXNnLXlvY3RvLXdhaW1lYS01OjIwMTMxMDAz
MDkyNTA1OjMuMTEuMC0wNjM3NS1nMzllZGEyYTozODQKCkJpc2VjdGluZzogMzQ5MCByZXZp
c2lvbnMgbGVmdCB0byB0ZXN0IGFmdGVyIHRoaXMgKHJvdWdobHkgMTIgc3RlcHMpClthYTcw
NTRmNWE1YTlmZjcyOGNlMjkxY2IxMDNhZmExOWY0Zjg0OWViXSBNZXJnZSB0YWcgJ3BpbmN0
cmwtdjMuMTItMScgb2YgZ2l0Oi8vZ2l0Lmtlcm5lbC5vcmcvcHViL3NjbS9saW51eC9rZXJu
ZWwvZ2l0L2xpbnVzdy9saW51eC1waW5jdHJsCnJ1bm5pbmcgL2Mva2VybmVsLXRlc3RzL2Jp
c2VjdC10ZXN0LWJvb3QtZmFpbHVyZS5zaCAvaG9tZS93ZmcvbW0vb2JqLWJpc2VjdApscyAt
YSAva2VybmVsLXRlc3RzL3J1bi1xdWV1ZS9rdm0veDg2XzY0LXJhbmRjb25maWcteDEtMDky
OC9uZXh0Om1hc3RlcjphYTcwNTRmNWE1YTlmZjcyOGNlMjkxY2IxMDNhZmExOWY0Zjg0OWVi
OmJpc2VjdC1tbQoKMjAxMy0xMC0wMy0wMToyOToyMSBhYTcwNTRmNWE1YTlmZjcyOGNlMjkx
Y2IxMDNhZmExOWY0Zjg0OWViIGNvbXBpbGluZwo0NzQgcmVhbCAgMTQ3MiB1c2VyICAxNDAg
c3lzICAzMzkuNzIlIGNwdSAJeDg2XzY0LXJhbmRjb25maWcteDEtMDkyOAoKMjAxMy0xMC0w
My0wMTozNzo1OSBkZXRlY3RpbmcgYm9vdCBzdGF0ZSAzLjExLjAtMDMyNDgtZ2FhNzA1NGYJ
MS4uCTMuCTYJOC4JMTAuLgkxMQkxMy4JMTQJMTYJMTcJMTgJMjAuLgkzMAkzNAkzNgkzOAk0
Nwk1Mwk1NQk2Mwk2OAk3MAk3Mwk3OQk4Mwk5MQk5Mgk5My4uLi4uLi4uLi4uLi4uLi4uLi4u
Li4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4u
Li4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4u
Li4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4u
Li4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4u
Li4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4u
Li4uLi4uLi4uLi4bWzE7MzVtYWRkX3RvX3J1bl9xdWV1ZSA3G1swbQoJOTcJOTkJMTAwIFNV
Q0NFU1MKCkJpc2VjdGluZzogMTY4NSByZXZpc2lvbnMgbGVmdCB0byB0ZXN0IGFmdGVyIHRo
aXMgKHJvdWdobHkgMTEgc3RlcHMpClsyN2MwNTNhYThkMThkMWZhN2I4MzA0MWUzNmJhZDIw
YmNkZjU1NTE0XSBNZXJnZSBicmFuY2ggJ3Y0bF9mb3JfbGludXMnIG9mIGdpdDovL2dpdC5r
ZXJuZWwub3JnL3B1Yi9zY20vbGludXgva2VybmVsL2dpdC9tY2hlaGFiL2xpbnV4LW1lZGlh
CnJ1bm5pbmcgL2Mva2VybmVsLXRlc3RzL2Jpc2VjdC10ZXN0LWJvb3QtZmFpbHVyZS5zaCAv
aG9tZS93ZmcvbW0vb2JqLWJpc2VjdApscyAtYSAva2VybmVsLXRlc3RzL3J1bi1xdWV1ZS9r
dm0veDg2XzY0LXJhbmRjb25maWcteDEtMDkyOC9uZXh0Om1hc3RlcjoyN2MwNTNhYThkMThk
MWZhN2I4MzA0MWUzNmJhZDIwYmNkZjU1NTE0OmJpc2VjdC1tbQoKMjAxMy0xMC0wMy0wNDoy
ODo0MCAyN2MwNTNhYThkMThkMWZhN2I4MzA0MWUzNmJhZDIwYmNkZjU1NTE0IGNvbXBpbGlu
ZwoyNDkgcmVhbCAgMTUxNyB1c2VyICAxNDEgc3lzICA2NjQuODIlIGNwdSAJeDg2XzY0LXJh
bmRjb25maWcteDEtMDkyOAoKMjAxMy0xMC0wMy0wNDozMjo1OCBkZXRlY3RpbmcgYm9vdCBz
dGF0ZSAzLjExLjAtMDQ2ODktZzI3YzA1M2EJNCBURVNUIEZBSUxVUkUKL2V0Yy9rZXJuZWwt
dGVzdHMvOTktdHJpbml0eTogbGluZSAxNjogL3RyaW5pdHk6IG5vdCBmb3VuZAovZXRjL2tl
cm5lbC10ZXN0cy85OS10cmluaXR5OiBsaW5lIDE1OiAvdHJpbml0eTogbm90IGZvdW5kClsg
ICAgMS44MjgxODldIEJVRzogc2xlZXBpbmcgZnVuY3Rpb24gY2FsbGVkIGZyb20gaW52YWxp
ZCBjb250ZXh0IGF0IC9jL3dmZy9tbS9tbS9zbGFiLmM6MzA2MApbICAgIDEuODI5NzI2XSBp
bl9hdG9taWMoKTogMSwgaXJxc19kaXNhYmxlZCgpOiAwLCBwaWQ6IDAsIG5hbWU6IHN3YXBw
ZXIvMApbICAgIDEuODMwOTM5XSAxIGxvY2sgaGVsZCBieSBzd2FwcGVyLzAvMDoKWyAgICAx
LjgzMTYzOV0gICMwOiAgKApbICAgIDEuODMzMjM5XSBDUFU6IDAgUElEOiAwIENvbW06IHN3
YXBwZXIvMCBOb3QgdGFpbnRlZCAzLjExLjAtMDQ2ODktZzI3YzA1M2EgIzM4Ngova2VybmVs
L3g4Nl82NC1yYW5kY29uZmlnLXgxLTA5MjgvMjdjMDUzYWE4ZDE4ZDFmYTdiODMwNDFlMzZi
YWQyMGJjZGY1NTUxNC9kbWVzZy15b2N0by1jYWlyby03OjIwMTMxMDAzMDQzMzExOjMuMTEu
MC0wNDY4OS1nMjdjMDUzYTozODYKCkJpc2VjdGluZzogOTQxIHJldmlzaW9ucyBsZWZ0IHRv
IHRlc3QgYWZ0ZXIgdGhpcyAocm91Z2hseSAxMCBzdGVwcykKWzlhYjA3M2JjNDViOGI1MjNj
YzM5NjU4OTI1YmI0NGJlZjM1Y2E2NTddIE1lcmdlIHRhZyAnZmJkZXYtMy4xMicgb2YgZ2l0
Oi8vZ2l0Lmtlcm5lbC5vcmcvcHViL3NjbS9saW51eC9rZXJuZWwvZ2l0L3RvbWJhL2xpbnV4
CnJ1bm5pbmcgL2Mva2VybmVsLXRlc3RzL2Jpc2VjdC10ZXN0LWJvb3QtZmFpbHVyZS5zaCAv
aG9tZS93ZmcvbW0vb2JqLWJpc2VjdApscyAtYSAva2VybmVsLXRlc3RzL3J1bi1xdWV1ZS9r
dm0veDg2XzY0LXJhbmRjb25maWcteDEtMDkyOC9uZXh0Om1hc3Rlcjo5YWIwNzNiYzQ1Yjhi
NTIzY2MzOTY1ODkyNWJiNDRiZWYzNWNhNjU3OmJpc2VjdC1tbQoKMjAxMy0xMC0wMy0wNDoz
MzozMSA5YWIwNzNiYzQ1YjhiNTIzY2MzOTY1ODkyNWJiNDRiZWYzNWNhNjU3IGNvbXBpbGlu
Zwo0OSByZWFsICAyODkgdXNlciAgMzAgc3lzICA2NDUuMDElIGNwdSAJeDg2XzY0LXJhbmRj
b25maWcteDEtMDkyOAoKMjAxMy0xMC0wMy0wNDozNDozMCBkZXRlY3RpbmcgYm9vdCBzdGF0
ZSAzLjExLjAtMDM3NDctZzlhYjA3M2IJMTUJNTgJODAJODcuCTkwCTkyCTk2CTEwMCBTVUND
RVNTCgpCaXNlY3Rpbmc6IDQ3OCByZXZpc2lvbnMgbGVmdCB0byB0ZXN0IGFmdGVyIHRoaXMg
KHJvdWdobHkgOSBzdGVwcykKWzYyZjIxMDRmM2ZjMTFjNGNmZDEzMDc0MjljYjk1NWJmYTQ4
ZGNiMzddIGRybTogQWR2ZXJ0aXNlIGFzeW5jIHBhZ2UgZmxpcCBhYmlsaXR5IHRocm91Z2gg
R0VUQ0FQIGlvY3RsCnJ1bm5pbmcgL2Mva2VybmVsLXRlc3RzL2Jpc2VjdC10ZXN0LWJvb3Qt
ZmFpbHVyZS5zaCAvaG9tZS93ZmcvbW0vb2JqLWJpc2VjdApscyAtYSAva2VybmVsLXRlc3Rz
L3J1bi1xdWV1ZS9rdm0veDg2XzY0LXJhbmRjb25maWcteDEtMDkyOC9uZXh0Om1hc3Rlcjo2
MmYyMTA0ZjNmYzExYzRjZmQxMzA3NDI5Y2I5NTViZmE0OGRjYjM3OmJpc2VjdC1tbQoKMjAx
My0xMC0wMy0wNDozOTowMyA2MmYyMTA0ZjNmYzExYzRjZmQxMzA3NDI5Y2I5NTViZmE0OGRj
YjM3IGNvbXBpbGluZwoyMTEgcmVhbCAgMTQ3NCB1c2VyICAxMzkgc3lzICA3NjQuMDQlIGNw
dSAJeDg2XzY0LXJhbmRjb25maWcteDEtMDkyOAoKMjAxMy0xMC0wMy0wNDo0Mjo0NiBkZXRl
Y3RpbmcgYm9vdCBzdGF0ZSAzLjExLjAtcmMzLTAwNDYzLWc2MmYyMTA0Li4uLi4uLi4uLi4u
Li4uCTEuLi4JMi4uLi4uLgkzLi4JNC4uLi4uLi4uLi4uLi4JNgk3CTEwLi4JMTEuCTEyCTEz
LgkxNAkxNS4JMTYJMTkJMjIJMjYJMzcJNDEJNTgJNjUJNzQuLgk5Nwk5OC4uLi4uLi4uLi4u
Li4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4u
Li4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4u
Li4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4u
Li4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4u
Li4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4u
Li4uLi4uLi4uLi4uLi4uLi4uLi4bWzE7MzVtYWRkX3RvX3J1bl9xdWV1ZSAyG1swbQouLi4J
OTkuLi4uLgkxMDAgU1VDQ0VTUwoKQmlzZWN0aW5nOiAyMzkgcmV2aXNpb25zIGxlZnQgdG8g
dGVzdCBhZnRlciB0aGlzIChyb3VnaGx5IDggc3RlcHMpClszMmJmN2M2Y2RmNjNhNjcwNDgy
MmM4MWI3MTM5YzU0YWMxY2JkNmExXSBbbWVkaWFdIGVtMjh4eDogZml4IGFzc2lnbm1lbnQg
b2YgdGhlIGVlcHJvbSBkYXRhCnJ1bm5pbmcgL2Mva2VybmVsLXRlc3RzL2Jpc2VjdC10ZXN0
LWJvb3QtZmFpbHVyZS5zaCAvaG9tZS93ZmcvbW0vb2JqLWJpc2VjdApscyAtYSAva2VybmVs
LXRlc3RzL3J1bi1xdWV1ZS9rdm0veDg2XzY0LXJhbmRjb25maWcteDEtMDkyOC9uZXh0Om1h
c3RlcjozMmJmN2M2Y2RmNjNhNjcwNDgyMmM4MWI3MTM5YzU0YWMxY2JkNmExOmJpc2VjdC1t
bQoKMjAxMy0xMC0wMy0wNzo1Mjo1NSAzMmJmN2M2Y2RmNjNhNjcwNDgyMmM4MWI3MTM5YzU0
YWMxY2JkNmExIGNvbXBpbGluZwozMzggcmVhbCAgNzk5IHVzZXIgIDc1IHN5cyAgMjU4LjYw
JSBjcHUgCXg4Nl82NC1yYW5kY29uZmlnLXgxLTA5MjgKCjIwMTMtMTAtMDMtMDg6MDE6MDYg
ZGV0ZWN0aW5nIGJvb3Qgc3RhdGUgMy4xMS4wLXJjMi0wMDIzOS1nMzJiZjdjNi4uLgkzCTcJ
MTgJMjMJMzUJMzcuCTQ0CTUyCTU3CTYwCTczCTc5CTg5Lgk5NC4uCTk1CTk2Li4uLi4uLi4u
Li4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4u
Li4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4u
Li4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4u
Li4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4u
Li4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4u
Li4uLi4uLi4uLi4uLi4uLi4uLi4uLhtbMTszNW1hZGRfdG9fcnVuX3F1ZXVlIDQbWzBtCi4u
Li4JOTgJMTAwIFNVQ0NFU1MKCkJpc2VjdGluZzogMTI1IHJldmlzaW9ucyBsZWZ0IHRvIHRl
c3QgYWZ0ZXIgdGhpcyAocm91Z2hseSA3IHN0ZXBzKQpbNjc5ZmU4MGZiZTk2NGVhN2Y5Zjcx
NzgxYzJjYTY1YjYzMDk0OWRhM10gZHJtL3JhZGVvbi9kcG06IG1ha2Ugc3VyZSBkYyBwZXJm
b3JtYW5jZSBsZXZlbCBsaW1pdHMgYXJlIHZhbGlkIChDSSkKcnVubmluZyAvYy9rZXJuZWwt
dGVzdHMvYmlzZWN0LXRlc3QtYm9vdC1mYWlsdXJlLnNoIC9ob21lL3dmZy9tbS9vYmotYmlz
ZWN0CmxzIC1hIC9rZXJuZWwtdGVzdHMvcnVuLXF1ZXVlL2t2bS94ODZfNjQtcmFuZGNvbmZp
Zy14MS0wOTI4L25leHQ6bWFzdGVyOjY3OWZlODBmYmU5NjRlYTdmOWY3MTc4MWMyY2E2NWI2
MzA5NDlkYTM6YmlzZWN0LW1tCgoyMDEzLTEwLTAzLTEwOjQ2OjEzIDY3OWZlODBmYmU5NjRl
YTdmOWY3MTc4MWMyY2E2NWI2MzA5NDlkYTMgY29tcGlsaW5nCjIxOSByZWFsICAxNDk4IHVz
ZXIgIDE0MSBzeXMgIDc0Ni4yNCUgY3B1IAl4ODZfNjQtcmFuZGNvbmZpZy14MS0wOTI4Cgoy
MDEzLTEwLTAzLTEwOjUwOjA0IGRldGVjdGluZyBib290IHN0YXRlIDMuMTEuMC1yYzctMDAx
MTctZzY3OWZlODAuLi4JMgk0CTExCTIwCTI2CTI5CTM5CTQ1CTU5CTYxCTY3CTc3CTg4CTk2
CTk3CTEwMCBTVUNDRVNTCgpCaXNlY3Rpbmc6IDYyIHJldmlzaW9ucyBsZWZ0IHRvIHRlc3Qg
YWZ0ZXIgdGhpcyAocm91Z2hseSA2IHN0ZXBzKQpbZWZhMjdmOWNlYzA5NTE4YzliNTc0ZTNh
YjRhMGE0MTcxNzIzNzQyOV0gTWVyZ2UgdGFnICdkcm0taW50ZWwtbmV4dC0yMDEzLTA4LTIz
JyBvZiBnaXQ6Ly9wZW9wbGUuZnJlZWRlc2t0b3Aub3JnL35kYW52ZXQvZHJtLWludGVsIGlu
dG8gZHJtLW5leHQKcnVubmluZyAvYy9rZXJuZWwtdGVzdHMvYmlzZWN0LXRlc3QtYm9vdC1m
YWlsdXJlLnNoIC9ob21lL3dmZy9tbS9vYmotYmlzZWN0CmxzIC1hIC9rZXJuZWwtdGVzdHMv
cnVuLXF1ZXVlL2t2bS94ODZfNjQtcmFuZGNvbmZpZy14MS0wOTI4L25leHQ6bWFzdGVyOmVm
YTI3ZjljZWMwOTUxOGM5YjU3NGUzYWI0YTBhNDE3MTcyMzc0Mjk6YmlzZWN0LW1tCgoyMDEz
LTEwLTAzLTEwOjU5OjM2IGVmYTI3ZjljZWMwOTUxOGM5YjU3NGUzYWI0YTBhNDE3MTcyMzc0
MjkgY29tcGlsaW5nCjIxMCByZWFsICAxNTAzIHVzZXIgIDE0NSBzeXMgIDc4MS45OCUgY3B1
IAl4ODZfNjQtcmFuZGNvbmZpZy14MS0wOTI4CgoyMDEzLTEwLTAzLTExOjAzOjE4IGRldGVj
dGluZyBib290IHN0YXRlIDMuMTEuMC1yYzMtMDA1MjYtZ2VmYTI3ZjkuLi4JOQkxNgkxOQkz
MQk0NAk1Mwk2MAk3MAk4Mgk5Mgk5OQkxMDAgU1VDQ0VTUwoKQmlzZWN0aW5nOiAzMSByZXZp
c2lvbnMgbGVmdCB0byB0ZXN0IGFmdGVyIHRoaXMgKHJvdWdobHkgNSBzdGVwcykKW2MwNzI0
NzBmNGU5YWJkZGU3Y2RmMWM4NTBiODgyNmYzMmY5ZTc5ZTNdIGRybS9ub3V2ZWF1L2Jpb3Mv
dGhlcm06IGhhbmRsZSB2Ymlvc2VzIHdpdGggZHVwbGljYXRlIGVudHJpZXMgKG1vc3RseSBu
dmE1KQpydW5uaW5nIC9jL2tlcm5lbC10ZXN0cy9iaXNlY3QtdGVzdC1ib290LWZhaWx1cmUu
c2ggL2hvbWUvd2ZnL21tL29iai1iaXNlY3QKbHMgLWEgL2tlcm5lbC10ZXN0cy9ydW4tcXVl
dWUva3ZtL3g4Nl82NC1yYW5kY29uZmlnLXgxLTA5MjgvbmV4dDptYXN0ZXI6YzA3MjQ3MGY0
ZTlhYmRkZTdjZGYxYzg1MGI4ODI2ZjMyZjllNzllMzpiaXNlY3QtbW0KCjIwMTMtMTAtMDMt
MTE6MTA6NDkgYzA3MjQ3MGY0ZTlhYmRkZTdjZGYxYzg1MGI4ODI2ZjMyZjllNzllMyBjb21w
aWxpbmcKMjEzIHJlYWwgIDE0OTYgdXNlciAgMTQyIHN5cyAgNzY3LjIwJSBjcHUgCXg4Nl82
NC1yYW5kY29uZmlnLXgxLTA5MjgKCjIwMTMtMTAtMDMtMTE6MTQ6MzUgZGV0ZWN0aW5nIGJv
b3Qgc3RhdGUgMy4xMS4wLXJjNy0wMDY3NC1nYzA3MjQ3MC4uLgkxLi4JMi4uLi4uCTMuLi4J
NC4JNS4uCTYuLi4uLi4uLi4uLi4uLi4uCTcuLi4JOC4uLi4uLi4uLi4uLgkxMQkxMgkxMy4J
MTQJMTkuCTIxCTIyCTMwCTM2CTQ2CTQ5CTU0CTYyCTczCTg3CTk0Lgk5NS4uLi4uLi4uLi4u
Li4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4u
Li4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4u
Li4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4u
Li4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4u
Li4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4u
Li4uLi4uLi4uLi4uLi4uLi4uLi4bWzE7MzVtYWRkX3RvX3J1bl9xdWV1ZSA1G1swbQouLi4u
Li4JOTYuCTk3Lgk5OAkxMDAgU1VDQ0VTUwoKQmlzZWN0aW5nOiAxNSByZXZpc2lvbnMgbGVm
dCB0byB0ZXN0IGFmdGVyIHRoaXMgKHJvdWdobHkgNCBzdGVwcykKW2IwNjNmNGFmODQ5ZTVm
M2E4YTQyMmRjMTAxMzg4MTRmNThjNzM2NDFdIGRybS9leHlub3M6IGZpbWQ6IGdldCBzaWdu
YWwgcG9sYXJpdGllcyBmcm9tIGRldmljZSB0cmVlCnJ1bm5pbmcgL2Mva2VybmVsLXRlc3Rz
L2Jpc2VjdC10ZXN0LWJvb3QtZmFpbHVyZS5zaCAvaG9tZS93ZmcvbW0vb2JqLWJpc2VjdAps
cyAtYSAva2VybmVsLXRlc3RzL3J1bi1xdWV1ZS9rdm0veDg2XzY0LXJhbmRjb25maWcteDEt
MDkyOC9uZXh0Om1hc3RlcjpiMDYzZjRhZjg0OWU1ZjNhOGE0MjJkYzEwMTM4ODE0ZjU4Yzcz
NjQxOmJpc2VjdC1tbQoKMjAxMy0xMC0wMy0xNDoyODozOSBiMDYzZjRhZjg0OWU1ZjNhOGE0
MjJkYzEwMTM4ODE0ZjU4YzczNjQxIGNvbXBpbGluZwo0OSByZWFsICAzNCB1c2VyICA3IHN5
cyAgODUuODclIGNwdSAJeDg2XzY0LXJhbmRjb25maWcteDEtMDkyOAoKMjAxMy0xMC0wMy0x
NDoyOTozOCBkZXRlY3RpbmcgYm9vdCBzdGF0ZSAzLjExLjAtcmM3LTAwNjkwLWdiMDYzZjRh
Li4uLgkxCTIJNAk1CTYuCTcJOAk5CTExCTEzLi4JMTQuLgkxNS4JMTcJMTkuLgkyMQkyNAky
NwkzMQkzNAkzNi4JMzcJMzgJMzkuLi4JNDAuLi4uLi4uLi4JNDEuLgk0Mgk0My4uCTQ0Li4u
Li4uCTQ1CTQ3Li4JNDkJNTEJNTIJNTMJNTUJNTcJNjUJNjkuCTc4CTg0CTkwCTk2CTk5CTEw
MCBTVUNDRVNTCgpCaXNlY3Rpbmc6IDcgcmV2aXNpb25zIGxlZnQgdG8gdGVzdCBhZnRlciB0
aGlzIChyb3VnaGx5IDMgc3RlcHMpClsyZDNmMTczY2Y3YzJlMDMyMDA0Zjk1MDcxODMxNmU2
NGZiMTg2NmViXSBkcm0vZXh5bm9zOiBSZW1vdmUgbm9uLURUIHN1cHBvcnQgaW4gZXh5bm9z
X2RybV9maW1kCnJ1bm5pbmcgL2Mva2VybmVsLXRlc3RzL2Jpc2VjdC10ZXN0LWJvb3QtZmFp
bHVyZS5zaCAvaG9tZS93ZmcvbW0vb2JqLWJpc2VjdApscyAtYSAva2VybmVsLXRlc3RzL3J1
bi1xdWV1ZS9rdm0veDg2XzY0LXJhbmRjb25maWcteDEtMDkyOC9uZXh0Om1hc3RlcjoyZDNm
MTczY2Y3YzJlMDMyMDA0Zjk1MDcxODMxNmU2NGZiMTg2NmViOmJpc2VjdC1tbQoKMjAxMy0x
MC0wMy0xNToxMDo0MCAyZDNmMTczY2Y3YzJlMDMyMDA0Zjk1MDcxODMxNmU2NGZiMTg2NmVi
IGNvbXBpbGluZwoyMiByZWFsICAzNSB1c2VyICA3IHN5cyAgMTg3LjM5JSBjcHUgCXg4Nl82
NC1yYW5kY29uZmlnLXgxLTA5MjgKCjIwMTMtMTAtMDMtMTU6MTE6MTIgZGV0ZWN0aW5nIGJv
b3Qgc3RhdGUgMy4xMS4wLXJjNy0wMDY5OC1nMmQzZjE3My4uLgkzCTExCTE2CTIxCTI4CTMw
CTMyCTM0CTQzCTQ1CTQ5CTYxCTY0CTY4CTcwCTc0CTc1CTc4CTgwLi4JODIJODUuCTg2CTg3
CTg4CTkwLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4u
Li4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4u
Li4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4u
Li4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4u
Li4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4u
Li4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLhtbMTszNW1hZGRfdG9fcnVu
X3F1ZXVlIDEwG1swbQouLi4JOTEJOTQJOTguCTEwMCBTVUNDRVNTCgpCaXNlY3Rpbmc6IDMg
cmV2aXNpb25zIGxlZnQgdG8gdGVzdCBhZnRlciB0aGlzIChyb3VnaGx5IDIgc3RlcHMpCltm
NjZiMmExYzdmMmFlM2ZiMGQ1YjY3ZDA3YWI0ZjUwNTVmZDNjZjE2XSBbbWVkaWFdIGN4ODg6
IEZpeCByZWdyZXNzaW9uOiBDWDg4X0FVRElPX1dNODc3NSBjYW4ndCBiZSAwCnJ1bm5pbmcg
L2Mva2VybmVsLXRlc3RzL2Jpc2VjdC10ZXN0LWJvb3QtZmFpbHVyZS5zaCAvaG9tZS93Zmcv
bW0vb2JqLWJpc2VjdApscyAtYSAva2VybmVsLXRlc3RzL3J1bi1xdWV1ZS9rdm0veDg2XzY0
LXJhbmRjb25maWcteDEtMDkyOC9uZXh0Om1hc3RlcjpmNjZiMmExYzdmMmFlM2ZiMGQ1YjY3
ZDA3YWI0ZjUwNTVmZDNjZjE2OmJpc2VjdC1tbQoKMjAxMy0xMC0wMy0xODowMTo1NiBmNjZi
MmExYzdmMmFlM2ZiMGQ1YjY3ZDA3YWI0ZjUwNTVmZDNjZjE2IGNvbXBpbGluZwozNTcgcmVh
bCAgMTUwNyB1c2VyICAxNDAgc3lzICA0NjAuNDklIGNwdSAJeDg2XzY0LXJhbmRjb25maWct
eDEtMDkyOAoKMjAxMy0xMC0wMy0xODowODoyMCBkZXRlY3RpbmcgYm9vdCBzdGF0ZSAzLjEx
LjAtcmMyLTAwMjQzLWdmNjZiMmExLi4JMS4JNQk3CTgJMTMJMTQJMTUJMjIJMjUJMjcJMzQJ
MzUJMzgJNDMJNDYJNDkJNTIJNTQJNTkJNjgJNzIJNzUJODMJODYJODgJOTIJOTQuCTk3CTk4
Lgk5OS4JMTAwIFNVQ0NFU1MKCkJpc2VjdGluZzogMSByZXZpc2lvbiBsZWZ0IHRvIHRlc3Qg
YWZ0ZXIgdGhpcyAocm91Z2hseSAxIHN0ZXApCls4NmE3ZTEyMjRhNjg1MTFkM2ExYWUwYjdl
MTE1ODFiOWQzNzcyM2FlXSBNZXJnZSBicmFuY2ggJ2V4eW5vcy1kcm0tbmV4dCcgb2YgZ2l0
Oi8vZ2l0Lmtlcm5lbC5vcmcvcHViL3NjbS9saW51eC9rZXJuZWwvZ2l0L2RhZWlua2kvZHJt
LWV4eW5vcyBpbnRvIGRybS1uZXh0CnJ1bm5pbmcgL2Mva2VybmVsLXRlc3RzL2Jpc2VjdC10
ZXN0LWJvb3QtZmFpbHVyZS5zaCAvaG9tZS93ZmcvbW0vb2JqLWJpc2VjdApscyAtYSAva2Vy
bmVsLXRlc3RzL3J1bi1xdWV1ZS9rdm0veDg2XzY0LXJhbmRjb25maWcteDEtMDkyOC9uZXh0
Om1hc3Rlcjo4NmE3ZTEyMjRhNjg1MTFkM2ExYWUwYjdlMTE1ODFiOWQzNzcyM2FlOmJpc2Vj
dC1tbQoKMjAxMy0xMC0wMy0xODoyNjo1OSA4NmE3ZTEyMjRhNjg1MTFkM2ExYWUwYjdlMTE1
ODFiOWQzNzcyM2FlIGNvbXBpbGluZwozMTUgcmVhbCAgMTQ5MyB1c2VyICAxMzUgc3lzICA1
MTYuNDYlIGNwdSAJeDg2XzY0LXJhbmRjb25maWcteDEtMDkyOAoKMjAxMy0xMC0wMy0xODoz
MzozMyBkZXRlY3RpbmcgYm9vdCBzdGF0ZSAzLjExLjAtcmM3LTAwNzAwLWc4NmE3ZTEyLi4u
CTEwCTE1CTE4CTIzCTMwCTMzCTM1CTQ4CTU1CTU2CTU4CTYyCTY0CTY1CTY3CTY5CTcyCTc1
CTc2CTg3CTkwLgk5Mwk5Nwk5OAkxMDAgU1VDQ0VTUwoKQmlzZWN0aW5nOiAwIHJldmlzaW9u
cyBsZWZ0IHRvIHRlc3QgYWZ0ZXIgdGhpcyAocm91Z2hseSAwIHN0ZXBzKQpbYTA5ZTlhN2E0
YjkwN2YyZGZhOWJkYjJiOThhMTgyOGFiNGIzNDBiMl0gTWVyZ2UgYnJhbmNoICdkcm0tbmV4
dCcgb2YgZ2l0Oi8vcGVvcGxlLmZyZWVkZXNrdG9wLm9yZy9+YWlybGllZC9saW51eApydW5u
aW5nIC9jL2tlcm5lbC10ZXN0cy9iaXNlY3QtdGVzdC1ib290LWZhaWx1cmUuc2ggL2hvbWUv
d2ZnL21tL29iai1iaXNlY3QKbHMgLWEgL2tlcm5lbC10ZXN0cy9ydW4tcXVldWUva3ZtL3g4
Nl82NC1yYW5kY29uZmlnLXgxLTA5MjgvbmV4dDptYXN0ZXI6YTA5ZTlhN2E0YjkwN2YyZGZh
OWJkYjJiOThhMTgyOGFiNGIzNDBiMjpiaXNlY3QtbW0KCjIwMTMtMTAtMDMtMTg6NDg6MzEg
YTA5ZTlhN2E0YjkwN2YyZGZhOWJkYjJiOThhMTgyOGFiNGIzNDBiMiBjb21waWxpbmcKMzY1
IHJlYWwgIDE1NDAgdXNlciAgMTM5IHN5cyAgNDYwLjE3JSBjcHUgCXg4Nl82NC1yYW5kY29u
ZmlnLXgxLTA5MjgKCjIwMTMtMTAtMDMtMTg6NTY6MTUgZGV0ZWN0aW5nIGJvb3Qgc3RhdGUg
My4xMS4wLTA0NDQ1LWdhMDllOWE3LgkxCTUJNwkxMwkxOAkyMwkyNgkyOAkzNAkzNwk0MiBU
RVNUIEZBSUxVUkUKG1sxOzM1bUluY3JlYXNpbmcgcmVwZWF0IGNvdW50IGZyb20gMTAwIHRv
IDMwNRtbMG0KZ3JlcDogL3Byb2MvZmlsZXN5c3RlbXM6IE5vIHN1Y2ggZmlsZSBvciBkaXJl
Y3RvcnkKWyAgICAxLjk2MzIzOV0gaW5wdXQ6IEltRXhQUy8yIEdlbmVyaWMgRXhwbG9yZXIg
TW91c2UgYXMgL2RldmljZXMvcGxhdGZvcm0vaTgwNDIvc2VyaW8xL2lucHV0L2lucHV0Mgpb
ICAgIDEuOTcyMDczXSBJTkZPOiB0cnlpbmcgdG8gcmVnaXN0ZXIgbm9uLXN0YXRpYyBrZXku
ClsgICAgMS45NzI5NTldIHRoZSBjb2RlIGlzIGZpbmUgYnV0IG5lZWRzIGxvY2tkZXAgYW5u
b3RhdGlvbi4KWyAgICAxLjk3MzkxMl0gdHVybmluZyBvZmYgdGhlIGxvY2tpbmcgY29ycmVj
dG5lc3MgdmFsaWRhdG9yLgova2VybmVsL3g4Nl82NC1yYW5kY29uZmlnLXgxLTA5MjgvYTA5
ZTlhN2E0YjkwN2YyZGZhOWJkYjJiOThhMTgyOGFiNGIzNDBiMi9kbWVzZy15b2N0by1sa3At
dHQwMi00OjIwMTMxMDAzMDkzMDA3OjMuMTEuMC0wNDQ0NS1nYTA5ZTlhNzozOTcKCmEwOWU5
YTdhNGI5MDdmMmRmYTliZGIyYjk4YTE4MjhhYjRiMzQwYjIgaXMgdGhlIGZpcnN0IGJhZCBj
b21taXQKYmlzZWN0IHJ1biBzdWNjZXNzCmxzIC1hIC9rZXJuZWwtdGVzdHMvcnVuLXF1ZXVl
L2t2bS94ODZfNjQtcmFuZGNvbmZpZy14MS0wOTI4L25leHQ6bWFzdGVyOjlhYjA3M2JjNDVi
OGI1MjNjYzM5NjU4OTI1YmI0NGJlZjM1Y2E2NTc6YmlzZWN0LW1tCgoyMDEzLTEwLTAzLTE5
OjAyOjIxIDlhYjA3M2JjNDViOGI1MjNjYzM5NjU4OTI1YmI0NGJlZjM1Y2E2NTcgcmV1c2Ug
L2tlcm5lbC94ODZfNjQtcmFuZGNvbmZpZy14MS0wOTI4LzlhYjA3M2JjNDViOGI1MjNjYzM5
NjU4OTI1YmI0NGJlZjM1Y2E2NTcvdm1saW51ei0zLjExLjAtMDM3NDctZzlhYjA3M2IKCjIw
MTMtMTAtMDMtMTk6MDI6MjMgZGV0ZWN0aW5nIGJvb3Qgc3RhdGUgCTIJNgk3CTExIFRFU1Qg
RkFJTFVSRQpbICAgNjQuMjU0MTI5XSBTY2FubmluZyBkZXZpY2UgZm9yIGJhZCBibG9ja3MK
WyAgIDY1LjAzNjY0M10gLS0tLS0tLS0tLS0tWyBjdXQgaGVyZSBdLS0tLS0tLS0tLS0tClsg
ICA2NS4wMzg0NjBdIFdBUk5JTkc6IENQVTogMCBQSUQ6IDEgYXQgL2Mvd2ZnL21tL2tlcm5l
bC93b3JrcXVldWUuYzo1OTEgc2V0X3dvcmtfZGF0YSsweDMzLzB4NTAoKQpbICAgNjUuMDM5
NjUyXSBDUFU6IDAgUElEOiAxIENvbW06IHN3YXBwZXIvMCBOb3QgdGFpbnRlZCAzLjExLjAt
MDM3NDctZzlhYjA3M2IgIzM4NwpbICAgNjUuMDQwMzE4XSAgMDAwMDAwMDAwMDAwMDAwMCBm
ZmZmODgwMDBkYzAzZDgwIGZmZmZmZmZmODE4Mzg5ZTMgMDAwMDAwMDAwMDAwMDAwMApbICAg
NjUuMDQwMzE4XSAgZmZmZjg4MDAwZGMwM2RiOCBmZmZmZmZmZjgxMDhmYTUzIGZmZmZmZmZm
ODEwOWUzNzkgZmZmZjg4MDAwNmNjMzA2MApbICAgNjUuMDQwMzE4XSAgZmZmZjg4MDAwZGMx
MzQwMCAwMDAwMDAwMDAwMDAwMDA1IGZmZmY4ODAwMGRjMTE2MDAgZmZmZjg4MDAwZGMwM2Rj
OApbICAgNjUuMDQwMzE4XSBDYWxsIFRyYWNlOgpbICAgNjUuMDQwMzE4XSAgPElSUT4gIFs8
ZmZmZmZmZmY4MTgzODllMz5dIGR1bXBfc3RhY2srMHg0ZS8weDgyClsgICA2NS4wNDAzMThd
ICBbPGZmZmZmZmZmODEwOGZhNTM+XSB3YXJuX3Nsb3dwYXRoX2NvbW1vbisweDcwLzB4ODkK
WyAgIDY1LjA0MDMxOF0gIFs8ZmZmZmZmZmY4MTA5ZTM3OT5dID8gc2V0X3dvcmtfZGF0YSsw
eDMzLzB4NTAKWyAgIDY1LjA0MDMxOF0gIFs8ZmZmZmZmZmY4MTA4ZmIyZT5dIHdhcm5fc2xv
d3BhdGhfbnVsbCsweDE1LzB4MTcKWyAgIDY1LjA0MDMxOF0gIFs8ZmZmZmZmZmY4MTA5ZTM3
OT5dIHNldF93b3JrX2RhdGErMHgzMy8weDUwClsgICA2NS4wNDAzMThdICBbPGZmZmZmZmZm
ODEwOWYwOGY+XSBpbnNlcnRfd29yaysweDI3LzB4NjUKWyAgIDY1LjA0MDMxOF0gIFs8ZmZm
ZmZmZmY4MTA5ZjI5Yz5dIF9fcXVldWVfd29yaysweDFjZi8weDFlZQpbICAgNjUuMDQwMzE4
XSAgWzxmZmZmZmZmZjgxMDlmMmJiPl0gPyBfX3F1ZXVlX3dvcmsrMHgxZWUvMHgxZWUKWyAg
IDY1LjA0MDMxOF0gIFs8ZmZmZmZmZmY4MTA5ZjJkND5dIGRlbGF5ZWRfd29ya190aW1lcl9m
bisweDE5LzB4MWIKWyAgIDY1LjA0MDMxOF0gIFs8ZmZmZmZmZmY4MTA5NjU5Mz5dIGNhbGxf
dGltZXJfZm4rMHg2Yy8weGRmClsgICA2NS4wNDAzMThdICBbPGZmZmZmZmZmODEwOTY1Mjc+
XSA/IHByb2Nlc3NfdGltZW91dCsweGIvMHhiClsgICA2NS4wNDAzMThdICBbPGZmZmZmZmZm
ODEwOWYyYmI+XSA/IF9fcXVldWVfd29yaysweDFlZS8weDFlZQpbICAgNjUuMDQwMzE4XSAg
WzxmZmZmZmZmZjgxMDk2Y2EyPl0gcnVuX3RpbWVyX3NvZnRpcnErMHgxNzAvMHgxYjgKWyAg
IDY1LjA0MDMxOF0gIFs8ZmZmZmZmZmY4MTA5MzBhYT5dIF9fZG9fc29mdGlycSsweGM4LzB4
MThkClsgICA2NS4wNDAzMThdICBbPGZmZmZmZmZmODEwOTMyODQ+XSBpcnFfZXhpdCsweDU2
LzB4OTcKWyAgIDY1LjA0MDMxOF0gIFs8ZmZmZmZmZmY4MTAyYjdlYz5dIGRvX0lSUSsweDg4
LzB4OWYKWyAgIDY1LjA0MDMxOF0gIFs8ZmZmZmZmZmY4MTg0MmFmMj5dIGNvbW1vbl9pbnRl
cnJ1cHQrMHg3Mi8weDcyClsgICA2NS4wNDAzMThdICA8RU9JPiAgWzxmZmZmZmZmZjgxMGFm
MjQ0Pl0gPyBfX3dha2VfdXArMHgxZC8weDQ2ClsgICA2NS4wNDAzMThdICBbPGZmZmZmZmZm
ODEwY2NkNmI+XSA/IGFyY2hfbG9jYWxfaXJxX3Jlc3RvcmUrMHg2LzB4ZApbICAgNjUuMDQw
MzE4XSAgWzxmZmZmZmZmZjgxODQxZmYwPl0gX3Jhd19zcGluX3VubG9ja19pcnFyZXN0b3Jl
KzB4NDgvMHg3NQpbICAgNjUuMDQwMzE4XSAgWzxmZmZmZmZmZjgxMGFmMjY2Pl0gX193YWtl
X3VwKzB4M2YvMHg0NgpbICAgNjUuMDQwMzE4XSAgWzxmZmZmZmZmZjgxNGNjNDMwPl0gbmFu
ZF9yZWxlYXNlX2RldmljZS5pc3JhLjEzKzB4NDkvMHg1OApbICAgNjUuMDQwMzE4XSAgWzxm
ZmZmZmZmZjgxNGNkMTY5Pl0gbmFuZF9yZWFkX29vYisweDI1Ny8weDI3MApbICAgNjUuMDQw
MzE4XSAgWzxmZmZmZmZmZjgxNGI2MTFjPl0gbXRkX3JlYWRfb29iKzB4MjYvMHg0YwpbICAg
NjUuMDQwMzE4XSAgWzxmZmZmZmZmZjgxNGNmNmY2Pl0gY3JlYXRlX2JidCsweDIyNS8weDJk
NApbICAgNjUuMDQwMzE4XSAgWzxmZmZmZmZmZjgxNGNmY2IwPl0gbmFuZF9zY2FuX2JidCsw
eDg1LzB4NGUzClsgICA2NS4wNDAzMThdICBbPGZmZmZmZmZmODExMTk0Yjc+XSA/IF9fa21h
bGxvYysweDkwLzB4YmIKWyAgIDY1LjA0MDMxOF0gIFs8ZmZmZmZmZmY4MTRkMDFlZD5dIG5h
bmRfZGVmYXVsdF9iYnQrMHhkZi8weGU0ClsgICA2NS4wNDAzMThdICBbPGZmZmZmZmZmODFl
Mjc0MTU+XSBuc19pbml0X21vZHVsZSsweDU3Ni8weGQ2MQpbICAgNjUuMDQwMzE4XSAgWzxm
ZmZmZmZmZjgxODQwM2YxPl0gPyBtdXRleF91bmxvY2srMHg5LzB4YgpbICAgNjUuMDQwMzE4
XSAgWzxmZmZmZmZmZjgxZTI2ZTlmPl0gPyBpbml0X25hbmRkb2MrMHhjOC8weGM4ClsgICA2
NS4wNDAzMThdICBbPGZmZmZmZmZmODFkZmRkZDQ+XSBkb19vbmVfaW5pdGNhbGwrMHg4ZS8w
eDEzMgpbICAgNjUuMDQwMzE4XSAgWzxmZmZmZmZmZjgxMGE0NjAwPl0gPyBwYXJhbWVxbisw
eDFhLzB4MzYKWyAgIDY1LjA0MDMxOF0gIFs8ZmZmZmZmZmY4MTBhNDdiZj5dID8gcGFyc2Vf
YXJncysweDE4NC8weDI0MgpbICAgNjUuMDQwMzE4XSAgWzxmZmZmZmZmZjgxZGZkZmNjPl0g
a2VybmVsX2luaXRfZnJlZWFibGUrMHgxNTQvMHgxZDAKWyAgIDY1LjA0MDMxOF0gIFs8ZmZm
ZmZmZmY4MWRmZDZkYT5dID8gZG9fZWFybHlfcGFyYW0rMHg4OC8weDg4ClsgICA2NS4wNDAz
MThdICBbPGZmZmZmZmZmODE4MzI3NTk+XSA/IHJlc3RfaW5pdCsweGJkLzB4YmQKWyAgIDY1
LjA0MDMxOF0gIFs8ZmZmZmZmZmY4MTgzMjc2Mj5dIGtlcm5lbF9pbml0KzB4OS8weGNjClsg
ICA2NS4wNDAzMThdICBbPGZmZmZmZmZmODE4NDMzN2M+XSByZXRfZnJvbV9mb3JrKzB4N2Mv
MHhiMApbICAgNjUuMDQwMzE4XSAgWzxmZmZmZmZmZjgxODMyNzU5Pl0gPyByZXN0X2luaXQr
MHhiZC8weGJkClsgICA2NS4wNDAzMThdIC0tLVsgZW5kIHRyYWNlIDdmNjE0NjdmMjlhMWMw
MWMgXS0tLQova2VybmVsL3g4Nl82NC1yYW5kY29uZmlnLXgxLTA5MjgvOWFiMDczYmM0NWI4
YjUyM2NjMzk2NTg5MjViYjQ0YmVmMzVjYTY1Ny9kbWVzZy1xdWFudGFsLWxrcC10dDAyLTIz
OjIwMTMxMDAzMDkzMTU0OjMuMTEuMC0wMzc0Ny1nOWFiMDczYjozODcKL2tlcm5lbC94ODZf
NjQtcmFuZGNvbmZpZy14MS0wOTI4LzlhYjA3M2JjNDViOGI1MjNjYzM5NjU4OTI1YmI0NGJl
ZjM1Y2E2NTcvZG1lc2ctcXVhbnRhbC14cHMtNToyMDEzMTAwNDAzMDM0MjozLjExLjAtMDM3
NDctZzlhYjA3M2I6Mzg3CgobWzE7MzVtYmFkIGJpc2VjdCwgcmV0cnkgd2l0aCBpbmNyZWFz
ZWQgcmVwZWF0IGNvdW50IDkxNRtbMG0KZ2l0IGNoZWNrb3V0IDQ1YzRlYTBjNGMxYjhhYmZm
YjU3NWI4NjUyNDNmZDFjNjliYmVjZDkKSEVBRCBpcyBub3cgYXQgNDVjNGVhMC4uLiBNZXJn
ZSByZW1vdGUtdHJhY2tpbmcgYnJhbmNoICdsem8tdXBkYXRlL2x6by11cGRhdGUnCmxzIC1h
IC9rZXJuZWwtdGVzdHMvcnVuLXF1ZXVlL2t2bS94ODZfNjQtcmFuZGNvbmZpZy14MS0wOTI4
L25leHQ6bWFzdGVyOjQ1YzRlYTBjNGMxYjhhYmZmYjU3NWI4NjUyNDNmZDFjNjliYmVjZDk6
YmlzZWN0LW1tCiBURVNUIEZBSUxVUkUKWyAgIDMzLjcyOTk0MF0gU2Nhbm5pbmcgZGV2aWNl
IGZvciBiYWQgYmxvY2tzClsgICAzNC41NzY0NjRdIC0tLS0tLS0tLS0tLVsgY3V0IGhlcmUg
XS0tLS0tLS0tLS0tLQpbICAgMzQuNTc3OTEzXSBXQVJOSU5HOiBDUFU6IDAgUElEOiAxIGF0
IGtlcm5lbC93b3JrcXVldWUuYzo2MDMgc2V0X3dvcmtfZGF0YSsweDMzLzB4NTAoKQpbICAg
MzQuNTc5MTkzXSBDUFU6IDAgUElEOiAxIENvbW06IHN3YXBwZXIvMCBOb3QgdGFpbnRlZCAz
LjEyLjAtcmMyLTAyODQyLWc0NWM0ZWEwICMyNQpbICAgMzQuNTgwMjI2XSAgZmZmZmZmZmY4
MTBjMzkzZiBmZmZmODgwMDBmMDAzZDkwIGZmZmZmZmZmODE4NTYyMjIgMDAwMDAwMDAwMDAw
MDAwMApbICAgMzQuNTgwMjI2XSAgZmZmZjg4MDAwZjAwM2RjOCBmZmZmZmZmZjgxMDk3ZGZk
IGZmZmZmZmZmODEwYTY3MDMgZmZmZjg4MDAwY2M3Zjg2MApbICAgMzQuNTgwMjI2XSAgZmZm
Zjg4MDAwZjAxMzQwMCAwMDAwMDAwMDAwMDAwMDA1IGZmZmY4ODAwMGYwMTE2NDAgZmZmZjg4
MDAwZjAwM2RkOApbICAgMzQuNTgwMjI2XSBDYWxsIFRyYWNlOgpbICAgMzQuNTgwMjI2XSAg
PElSUT4gIFs8ZmZmZmZmZmY4MTBjMzkzZj5dID8gY29uc29sZV91bmxvY2srMHgzMTIvMHgz
NWIKWyAgIDM0LjU4MDIyNl0gIFs8ZmZmZmZmZmY4MTg1NjIyMj5dIGR1bXBfc3RhY2srMHg0
ZS8weDdhClsgICAzNC41ODAyMjZdICBbPGZmZmZmZmZmODEwOTdkZmQ+XSB3YXJuX3Nsb3dw
YXRoX2NvbW1vbisweDcwLzB4ODkKWyAgIDM0LjU4MDIyNl0gIFs8ZmZmZmZmZmY4MTBhNjcw
Mz5dID8gc2V0X3dvcmtfZGF0YSsweDMzLzB4NTAKWyAgIDM0LjU4MDIyNl0gIFs8ZmZmZmZm
ZmY4MTA5N2VkOD5dIHdhcm5fc2xvd3BhdGhfbnVsbCsweDE1LzB4MTcKWyAgIDM0LjU4MDIy
Nl0gIFs8ZmZmZmZmZmY4MTBhNjcwMz5dIHNldF93b3JrX2RhdGErMHgzMy8weDUwClsgICAz
NC41ODAyMjZdICBbPGZmZmZmZmZmODEwYTc0MTU+XSBpbnNlcnRfd29yaysweDI3LzB4NjUK
WyAgIDM0LjU4MDIyNl0gIFs8ZmZmZmZmZmY4MTBhNzYyMj5dIF9fcXVldWVfd29yaysweDFj
Zi8weDFlZQpbICAgMzQuNTgwMjI2XSAgWzxmZmZmZmZmZjgxMGE3NjQxPl0gPyBfX3F1ZXVl
X3dvcmsrMHgxZWUvMHgxZWUKWyAgIDM0LjU4MDIyNl0gIFs8ZmZmZmZmZmY4MTBhNzY0MT5d
ID8gX19xdWV1ZV93b3JrKzB4MWVlLzB4MWVlClsgICAzNC41ODAyMjZdICBbPGZmZmZmZmZm
ODEwYTc2NWE+XSBkZWxheWVkX3dvcmtfdGltZXJfZm4rMHgxOS8weDFiClsgICAzNC41ODAy
MjZdICBbPGZmZmZmZmZmODEwOWU4ZDI+XSBjYWxsX3RpbWVyX2ZuKzB4NjcvMHhkNApbICAg
MzQuNTgwMjI2XSAgWzxmZmZmZmZmZjgxMDllODZiPl0gPyBwcm9jZXNzX3RpbWVvdXQrMHhi
LzB4YgpbICAgMzQuNTgwMjI2XSAgWzxmZmZmZmZmZjgxMDllZmQ0Pl0gcnVuX3RpbWVyX3Nv
ZnRpcnErMHgxNzAvMHgxYjgKWyAgIDM0LjU4MDIyNl0gIFs8ZmZmZmZmZmY4MTA5YjQwYT5d
IF9fZG9fc29mdGlycSsweGM2LzB4MTk2ClsgICAzNC41ODAyMjZdICBbPGZmZmZmZmZmODEw
OWI1ZTM+XSBpcnFfZXhpdCsweDUwLzB4ODYKWyAgIDM0LjU4MDIyNl0gIFs8ZmZmZmZmZmY4
MTAyYjdhYT5dIGRvX0lSUSsweDg4LzB4OWYKWyAgIDM0LjU4MDIyNl0gIFs8ZmZmZmZmZmY4
MTg2MTFiMj5dIGNvbW1vbl9pbnRlcnJ1cHQrMHg3Mi8weDcyClsgICAzNC41ODAyMjZdICA8
RU9JPiAgWzxmZmZmZmZmZjgxNjY0NjQ5Pl0gPyBsZWRfdHJpZ2dlcl9ldmVudCsweDI2LzB4
NTQKWyAgIDM0LjU4MDIyNl0gIFs8ZmZmZmZmZmY4MTBkMWNlZD5dID8gYXJjaF9sb2NhbF9p
cnFfcmVzdG9yZSsweDYvMHhkClsgICAzNC41ODAyMjZdICBbPGZmZmZmZmZmODEwZDUzN2Q+
XSBsb2NrX2FjcXVpcmUrMHg5NC8weDlkClsgICAzNC41ODAyMjZdICBbPGZmZmZmZmZmODE2
NjQ2NDk+XSA/IGxlZF90cmlnZ2VyX2V2ZW50KzB4MjYvMHg1NApbICAgMzQuNTgwMjI2XSAg
WzxmZmZmZmZmZjgxODYwODhlPl0gX3Jhd19yZWFkX2xvY2srMHgzNi8weDQyClsgICAzNC41
ODAyMjZdICBbPGZmZmZmZmZmODE2NjQ2NDk+XSA/IGxlZF90cmlnZ2VyX2V2ZW50KzB4MjYv
MHg1NApbICAgMzQuNTgwMjI2XSAgWzxmZmZmZmZmZjgxNjY0NjQ5Pl0gbGVkX3RyaWdnZXJf
ZXZlbnQrMHgyNi8weDU0ClsgICAzNC41ODAyMjZdICBbPGZmZmZmZmZmODE0ZTVlNTE+XSBu
YW5kX3dhaXRfcmVhZHkrMHg3Yi8weGFjClsgICAzNC41ODAyMjZdICBbPGZmZmZmZmZmODE0
ZTY2ZDc+XSBuYW5kX3JlYWRfb29iKzB4MWE4LzB4MjcwClsgICAzNC41ODAyMjZdICBbPGZm
ZmZmZmZmODE0Y2Y1ZWQ+XSBtdGRfcmVhZF9vb2IrMHgyNi8weDRjClsgICAzNC41ODAyMjZd
ICBbPGZmZmZmZmZmODE0ZTkxZTM+XSBjcmVhdGVfYmJ0KzB4MjBmLzB4MjlhClsgICAzNC41
ODAyMjZdICBbPGZmZmZmZmZmODE0ZTkyZWQ+XSBuYW5kX3NjYW5fYmJ0KzB4N2YvMHg0ZGQK
WyAgIDM0LjU4MDIyNl0gIFs8ZmZmZmZmZmY4MTEyMWJkND5dID8gX19rbWFsbG9jKzB4OTAv
MHhiYgpbICAgMzQuNTgwMjI2XSAgWzxmZmZmZmZmZjgxNGU5ODJhPl0gbmFuZF9kZWZhdWx0
X2JidCsweGRmLzB4ZTQKWyAgIDM0LjU4MDIyNl0gIFs8ZmZmZmZmZmY4MWU1OTgwND5dIG5z
X2luaXRfbW9kdWxlKzB4NTZjLzB4ZDI4ClsgICAzNC41ODAyMjZdICBbPGZmZmZmZmZmODEy
MmVlYjM+XSA/IGZyZWVfcnMrMHg3NS8weDc4ClsgICAzNC41ODAyMjZdICBbPGZmZmZmZmZm
ODFlNTkyOTg+XSA/IG5mdGxfc2Nhbl9iYnQrMHgzMTIvMHgzMTIKWyAgIDM0LjU4MDIyNl0g
IFs8ZmZmZmZmZmY4MWUyZmRkND5dIGRvX29uZV9pbml0Y2FsbCsweDhlLzB4MTM0ClsgICAz
NC41ODAyMjZdICBbPGZmZmZmZmZmODEwYWNhMDA+XSA/IHBhcmFtZXFuKzB4MzYvMHgzNgpb
ICAgMzQuNTgwMjI2XSAgWzxmZmZmZmZmZjgxMGFjYmEzPl0gPyBwYXJzZV9hcmdzKzB4MTg0
LzB4MjQyClsgICAzNC41ODAyMjZdICBbPGZmZmZmZmZmODFlMmZmY2U+XSBrZXJuZWxfaW5p
dF9mcmVlYWJsZSsweDE1NC8weDFkNQpbICAgMzQuNTgwMjI2XSAgWzxmZmZmZmZmZjgxZTJm
NmRhPl0gPyBkb19lYXJseV9wYXJhbSsweDg4LzB4ODgKWyAgIDM0LjU4MDIyNl0gIFs8ZmZm
ZmZmZmY4MTg1MDEwOT5dID8gcmVzdF9pbml0KzB4YmQvMHhiZApbICAgMzQuNTgwMjI2XSAg
WzxmZmZmZmZmZjgxODUwMTEyPl0ga2VybmVsX2luaXQrMHg5LzB4Y2MKWyAgIDM0LjU4MDIy
Nl0gIFs8ZmZmZmZmZmY4MTg2MTljYz5dIHJldF9mcm9tX2ZvcmsrMHg3Yy8weGIwClsgICAz
NC41ODAyMjZdICBbPGZmZmZmZmZmODE4NTAxMDk+XSA/IHJlc3RfaW5pdCsweGJkLzB4YmQK
WyAgIDM0LjU4MDIyNl0gLS0tWyBlbmQgdHJhY2UgM2MxMjkwNjZmMTZkNjJiNSBdLS0tCi9r
ZXJuZWwveDg2XzY0LXJhbmRjb25maWcteDEtMDkyOC80NWM0ZWEwYzRjMWI4YWJmZmI1NzVi
ODY1MjQzZmQxYzY5YmJlY2Q5L2RtZXNnLXlvY3RvLWxrcC10dDAyLTEwOjIwMTMwOTI4MDIz
NjI3OjMuMTIuMC1yYzItMDI4NDItZzQ1YzRlYTA6MjUKL2tlcm5lbC94ODZfNjQtcmFuZGNv
bmZpZy14MS0wOTI4LzQ1YzRlYTBjNGMxYjhhYmZmYjU3NWI4NjUyNDNmZDFjNjliYmVjZDkv
ZG1lc2cteW9jdG8tbGtwLXR0MDItMTA6MjAxMzA5MjgwMjM2NDQ6My4xMi4wLXJjMi0wMjg0
Mi1nNDVjNGVhMDoyNQova2VybmVsL3g4Nl82NC1yYW5kY29uZmlnLXgxLTA5MjgvNDVjNGVh
MGM0YzFiOGFiZmZiNTc1Yjg2NTI0M2ZkMWM2OWJiZWNkOS9kbWVzZy15b2N0by1sa3AtdHQw
Mi0xNToyMDEzMTAwMjEyNTUzOTozLjEyLjAtcmMyLTAyODQyLWc0NWM0ZWEwOjI1Ci9rZXJu
ZWwveDg2XzY0LXJhbmRjb25maWcteDEtMDkyOC80NWM0ZWEwYzRjMWI4YWJmZmI1NzViODY1
MjQzZmQxYzY5YmJlY2Q5L2RtZXNnLXlvY3RvLXhpYW4tMzE6MjAxMzA5MjgxMjIzNTE6My4x
Mi4wLXJjMi0wMjg0Mi1nNDVjNGVhMDoyNQoKYmlzZWN0OiBiYWQgY29tbWl0IDQ1YzRlYTBj
NGMxYjhhYmZmYjU3NWI4NjUyNDNmZDFjNjliYmVjZDkKZ2l0IGNoZWNrb3V0IHYzLjExClBy
ZXZpb3VzIEhFQUQgcG9zaXRpb24gd2FzIDQ1YzRlYTAuLi4gTWVyZ2UgcmVtb3RlLXRyYWNr
aW5nIGJyYW5jaCAnbHpvLXVwZGF0ZS9sem8tdXBkYXRlJwpIRUFEIGlzIG5vdyBhdCA2ZTQ2
NjQ1Li4uIExpbnV4IDMuMTEKbHMgLWEgL2tlcm5lbC10ZXN0cy9ydW4tcXVldWUva3ZtL3g4
Nl82NC1yYW5kY29uZmlnLXgxLTA5MjgvbmV4dDptYXN0ZXI6NmU0NjY0NTI1YjFkYjI4Zjhj
NGUxMTMwOTU3ZjcwYTk0YzE5MjEzZTpiaXNlY3QtbW0KCjIwMTMtMTAtMDMtMTk6MDQ6NDIg
NmU0NjY0NTI1YjFkYjI4ZjhjNGUxMTMwOTU3ZjcwYTk0YzE5MjEzZSByZXVzZSAva2VybmVs
L3g4Nl82NC1yYW5kY29uZmlnLXgxLTA5MjgvNmU0NjY0NTI1YjFkYjI4ZjhjNGUxMTMwOTU3
ZjcwYTk0YzE5MjEzZS92bWxpbnV6LTMuMTEuMAoKMjAxMy0xMC0wMy0xOTowNDo0MyBkZXRl
Y3RpbmcgYm9vdCBzdGF0ZSAuLi4JMQk0CTUJNwk5CTE1CTE2CTE4CTIwCTI2CTM0CTM4CTQz
CTQ1CTQ4CTQ5CTUxCTUyCTU0CTU5CTYwCTY4CTY5CTcxCTc1CTc3CTc4CTc5Lgk4Mgk4NAk4
NS4JODcuLgk4OC4uLi4uCTg5CTkwCTkzLgk5NS4uLi4JOTYuCTk3Lgk5OQkxMDEuLgkxMDMJ
MTA0CTEwNS4uCTEwNi4uLi4JMTA3Li4uCTEwOC4uCTEwOQkxMTAuCTExMQkxMTIuLi4JMTEz
LgkxMTUJMTE2Li4JMTE3Li4uCTExOAkxMjEJMTIyLgkxMjMuLgkxMjQuLi4uLi4uCTEyNwkx
MzAJMTMxCTEzMgkxMzMJMTM1CTEzNi4JMTQyCTE0MwkxNDQJMTQ3LgkxNDkJMTUzCTE1NC4J
MTU3CTE2MQkxNjMJMTcwCTE3NAkxNzcJMTgwCTE4NAkxODgJMTkyCTE5NQkxOTguCTE5OQky
MDEJMjAzCTIwNwkyMDgJMjExLgkyMTcJMjIyCTIyNAkyMjYJMjI4CTIzNAkyMzYJMjQxCTI0
NAkyNDUJMjQ2LgkyNDgJMjU2CTI1NwkyNjcJMjcwCTI3MQkyNzMJMjgxCTI4NgkyOTIJMjk0
CTI5OQkzMDYJMzA4CTMxMAkzMTUJMzE5CTMyMgkzMjgJMzI5CTMzNQkzNDQJMzQ3CTM0OAkz
NTMJMzU2CTM1NwkzNTkJMzYxLgkzNjMJMzY1CTM2NgkzNjcJMzY4Li4uCTM2OQkzNzAJMzc0
CTM3NQkzNzcJMzc4CTM4MQkzODIJMzgzLgkzODQJMzg4CTM4OQkzOTEJMzk2CTM5Ny4JNDAx
CTQwNC4JNDA1CTQwOQk0MTMuCTQxNAk0MTcJNDE5CTQyMS4JNDMwCTQzMQk0MzUJNDQyLi4u
CTQ0Mwk0NDQJNDQ3CTQ0OAk0NDkJNDUwCTQ1MS4uCTQ1Mi4uCTQ1My4JNDU2Lgk0NTcJNDU5
CTQ2NAk0NjUJNDcwCTQ3Ny4JNDg4CTQ5Mgk0OTQJNDk4CTUwNAk1MDUJNTEyCTUyMwk1MjcJ
NTM2CTU0Nwk1NTUJNTYzCTU2OQk1NzUJNTg4CTU5Mgk2MDAJNjEyCTYxNwk2MjMJNjM1CTYz
OQk2NDUJNjU1CTY2Mgk2NjQJNjY5CTY4MAk2ODEJNjg5CTcwMwk3MTAJNzE3CTcyMAk3MjIJ
NzI3CTczNAk3MzkJNzQyLgk3NDkJNzUyCTc1NAk3NjMJNzcwCTc3NAk3NzkuCTc4MAk3ODUJ
NzkxCTc5Mwk3OTQJNzk2CTgwMQk4MDUJODEwLgk4MTEJODE2CTgyMgk4MzAJODMzCTg0MAk4
NDgJODUwCTg1Ngk4NjQJODcwCTg3Ngk4NzkJODgxCTg4Mwk4ODYuCTg5NQk4OTcuLi4uLi4u
Li4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4u
Li4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4u
Li4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4u
Li4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4u
Li4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4u
Li4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uG1sxOzM1bWFkZF90b19ydW5fcXVldWUgMTgbWzBt
Ci4uCTg5OAk5MDEJOTA0CTkwNgk5MDgJOTA5CTkxMAk5MTEuLi4uLi4uLi4uLi4uLi4uLi4u
Li4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4u
Li4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4u
Li4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4u
Li4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4u
Li4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4u
Li4uLi4uLi4uLi4uG1sxOzM1bWFkZF90b19ydW5fcXVldWUgNBtbMG0KLi4uCTkxMi4JOTE1
IFNVQ0NFU1MKCmJpc2VjdDogZ29vZCBjb21taXQgdjMuMTEKZ2l0IGJpc2VjdCBzdGFydCA0
NWM0ZWEwYzRjMWI4YWJmZmI1NzViODY1MjQzZmQxYzY5YmJlY2Q5IHYzLjExIC0tClByZXZp
b3VzIEhFQUQgcG9zaXRpb24gd2FzIDZlNDY2NDUuLi4gTGludXggMy4xMQpIRUFEIGlzIG5v
dyBhdCAzYzBlZWUzLi4uIExpbnV4IDIuNi4zNwpCaXNlY3Rpbmc6IDY2NDggcmV2aXNpb25z
IGxlZnQgdG8gdGVzdCBhZnRlciB0aGlzIChyb3VnaGx5IDEzIHN0ZXBzKQpbMzllZGEyYWJh
NmJlNjQyYjcxZjJlMGFkNjIzZGNiMDlmZDlkNzljZl0gTWVyZ2UgYnJhbmNoICduZXh0JyBv
ZiBnaXQ6Ly9naXQua2VybmVsLm9yZy9wdWIvc2NtL2xpbnV4L2tlcm5lbC9naXQvYmVuaC9w
b3dlcnBjCmdpdCBiaXNlY3QgcnVuIC9jL2tlcm5lbC10ZXN0cy9iaXNlY3QtdGVzdC1ib290
LWZhaWx1cmUuc2ggL2hvbWUvd2ZnL21tL29iai1iaXNlY3QKcnVubmluZyAvYy9rZXJuZWwt
dGVzdHMvYmlzZWN0LXRlc3QtYm9vdC1mYWlsdXJlLnNoIC9ob21lL3dmZy9tbS9vYmotYmlz
ZWN0CmxzIC1hIC9rZXJuZWwtdGVzdHMvcnVuLXF1ZXVlL2t2bS94ODZfNjQtcmFuZGNvbmZp
Zy14MS0wOTI4L25leHQ6bWFzdGVyOjM5ZWRhMmFiYTZiZTY0MmI3MWYyZTBhZDYyM2RjYjA5
ZmQ5ZDc5Y2Y6YmlzZWN0LW1tCiBURVNUIEZBSUxVUkUKWyAgIDE3LjM5Nzc4Ml0gU2Nhbm5p
bmcgZGV2aWNlIGZvciBiYWQgYmxvY2tzClsgICAxNy42ODUxMzddIC0tLS0tLS0tLS0tLVsg
Y3V0IGhlcmUgXS0tLS0tLS0tLS0tLQpbICAgMTcuNjg3Mzk1XSBXQVJOSU5HOiBDUFU6IDAg
UElEOiAxIGF0IC9jL3dmZy9tbS9rZXJuZWwvd29ya3F1ZXVlLmM6NTkzIHNldF93b3JrX2Rh
dGErMHgzMy8weDUwKCkKWyAgIDE3LjY4ODYzNF0gQ1BVOiAwIFBJRDogMSBDb21tOiBzd2Fw
cGVyLzAgTm90IHRhaW50ZWQgMy4xMS4wLTA2Mzc1LWczOWVkYTJhICMzODQKWyAgIDE3LjY4
ODYzNF0gIDAwMDAwMDAwMDAwMDAwMDAgZmZmZjg4MDAwZjAwM2Q4MCBmZmZmZmZmZjgxODQ2
MjQzIDAwMDAwMDAwMDAwMDAwMDAKWyAgIDE3LjY4ODYzNF0gIGZmZmY4ODAwMGYwMDNkYjgg
ZmZmZmZmZmY4MTA4ZmE1MyBmZmZmZmZmZjgxMDllMzc5IGZmZmY4ODAwMGNjOWU4NjAKWyAg
IDE3LjY4ODYzNF0gIGZmZmY4ODAwMGYwMTM0MDAgMDAwMDAwMDAwMDAwMDAwNSBmZmZmODgw
MDBmMDExNjAwIGZmZmY4ODAwMGYwMDNkYzgKWyAgIDE3LjY4ODYzNF0gQ2FsbCBUcmFjZToK
WyAgIDE3LjY4ODYzNF0gIDxJUlE+ICBbPGZmZmZmZmZmODE4NDYyNDM+XSBkdW1wX3N0YWNr
KzB4NGUvMHg4MgpbICAgMTcuNjg4NjM0XSAgWzxmZmZmZmZmZjgxMDhmYTUzPl0gd2Fybl9z
bG93cGF0aF9jb21tb24rMHg3MC8weDg5ClsgICAxNy42ODg2MzRdICBbPGZmZmZmZmZmODEw
OWUzNzk+XSA/IHNldF93b3JrX2RhdGErMHgzMy8weDUwClsgICAxNy42ODg2MzRdICBbPGZm
ZmZmZmZmODEwOGZiMmU+XSB3YXJuX3Nsb3dwYXRoX251bGwrMHgxNS8weDE3ClsgICAxNy42
ODg2MzRdICBbPGZmZmZmZmZmODEwOWUzNzk+XSBzZXRfd29ya19kYXRhKzB4MzMvMHg1MApb
ICAgMTcuNjg4NjM0XSAgWzxmZmZmZmZmZjgxMDlmMDhmPl0gaW5zZXJ0X3dvcmsrMHgyNy8w
eDY1ClsgICAxNy42ODg2MzRdICBbPGZmZmZmZmZmODEwOWYyOWM+XSBfX3F1ZXVlX3dvcmsr
MHgxY2YvMHgxZWUKWyAgIDE3LjY4ODYzNF0gIFs8ZmZmZmZmZmY4MTA5ZjJiYj5dID8gX19x
dWV1ZV93b3JrKzB4MWVlLzB4MWVlClsgICAxNy42ODg2MzRdICBbPGZmZmZmZmZmODEwOWYy
ZDQ+XSBkZWxheWVkX3dvcmtfdGltZXJfZm4rMHgxOS8weDFiClsgICAxNy42ODg2MzRdICBb
PGZmZmZmZmZmODEwOTY1OTM+XSBjYWxsX3RpbWVyX2ZuKzB4NmMvMHhkZgpbICAgMTcuNjg4
NjM0XSAgWzxmZmZmZmZmZjgxMDk2NTI3Pl0gPyBwcm9jZXNzX3RpbWVvdXQrMHhiLzB4Ygpb
ICAgMTcuNjg4NjM0XSAgWzxmZmZmZmZmZjgxMDlmMmJiPl0gPyBfX3F1ZXVlX3dvcmsrMHgx
ZWUvMHgxZWUKWyAgIDE3LjY4ODYzNF0gIFs8ZmZmZmZmZmY4MTA5NmNhMj5dIHJ1bl90aW1l
cl9zb2Z0aXJxKzB4MTcwLzB4MWI4ClsgICAxNy42ODg2MzRdICBbPGZmZmZmZmZmODEwOTMw
YWE+XSBfX2RvX3NvZnRpcnErMHhjOC8weDE4ZApbICAgMTcuNjg4NjM0XSAgWzxmZmZmZmZm
ZjgxMDkzMjg0Pl0gaXJxX2V4aXQrMHg1Ni8weDk3ClsgICAxNy42ODg2MzRdICBbPGZmZmZm
ZmZmODEwMmI3ZWM+XSBkb19JUlErMHg4OC8weDlmClsgICAxNy42ODg2MzRdICBbPGZmZmZm
ZmZmODE4NTEwYjI+XSBjb21tb25faW50ZXJydXB0KzB4NzIvMHg3MgpbICAgMTcuNjg4NjM0
XSAgPEVPST4gIFs8ZmZmZmZmZmY4MTY1NWRkZD5dID8gbGVkX3RyaWdnZXJfZXZlbnQrMHgy
Ni8weDU0ClsgICAxNy42ODg2MzRdICBbPGZmZmZmZmZmODEyMWM2OTk+XSA/IGRvX3Jhd19z
cGluX3VubG9jaysweDg4LzB4ODgKWyAgIDE3LjY4ODYzNF0gIFs8ZmZmZmZmZmY4MTg1MDcy
ZT5dID8gX3Jhd19yZWFkX2xvY2srMHgzZS8weDQyClsgICAxNy42ODg2MzRdICBbPGZmZmZm
ZmZmODE2NTVkZGQ+XSA/IGxlZF90cmlnZ2VyX2V2ZW50KzB4MjYvMHg1NApbICAgMTcuNjg4
NjM0XSAgWzxmZmZmZmZmZjgxNjU1ZGRkPl0gbGVkX3RyaWdnZXJfZXZlbnQrMHgyNi8weDU0
ClsgICAxNy42ODg2MzRdICBbPGZmZmZmZmZmODE0ZDgxNTg+XSBuYW5kX3dhaXRfcmVhZHkr
MHg4MS8weGIyClsgICAxNy42ODg2MzRdICBbPGZmZmZmZmZmODE0ZDgzMGM+XSBuYW5kX2Nv
bW1hbmQrMHgxODMvMHgxOGUKWyAgIDE3LjY4ODYzNF0gIFs8ZmZmZmZmZmY4MTRkNjkyNT5d
IG5hbmRfcmVhZF9vb2Jfc3RkKzB4MTkvMHgzMgpbICAgMTcuNjg4NjM0XSAgWzxmZmZmZmZm
ZjgxNGQ4OThjPl0gbmFuZF9yZWFkX29vYisweDE1Ni8weDI3MApbICAgMTcuNjg4NjM0XSAg
WzxmZmZmZmZmZjgxNGMxYTQwPl0gbXRkX3JlYWRfb29iKzB4MjYvMHg0YwpbICAgMTcuNjg4
NjM0XSAgWzxmZmZmZmZmZjgxNGRiMDFhPl0gY3JlYXRlX2JidCsweDIyNS8weDJkNApbICAg
MTcuNjg4NjM0XSAgWzxmZmZmZmZmZjgxNGRiNWQ0Pl0gbmFuZF9zY2FuX2JidCsweDg1LzB4
NGUzClsgICAxNy42ODg2MzRdICBbPGZmZmZmZmZmODExMTk0YzI+XSA/IF9fa21hbGxvYysw
eDkwLzB4YmIKWyAgIDE3LjY4ODYzNF0gIFs8ZmZmZmZmZmY4MTRkYmIxMT5dIG5hbmRfZGVm
YXVsdF9iYnQrMHhkZi8weGU0ClsgICAxNy42ODg2MzRdICBbPGZmZmZmZmZmODFlM2E0NGM+
XSBuc19pbml0X21vZHVsZSsweDU3Ni8weGQ2MQpbICAgMTcuNjg4NjM0XSAgWzxmZmZmZmZm
ZjgxODRlOWI5Pl0gPyBtdXRleF91bmxvY2srMHg5LzB4YgpbICAgMTcuNjg4NjM0XSAgWzxm
ZmZmZmZmZjgxZTM5ZWQ2Pl0gPyBpbml0X25hbmRkb2MrMHhjOC8weGM4ClsgICAxNy42ODg2
MzRdICBbPGZmZmZmZmZmODFlMTBkZDQ+XSBkb19vbmVfaW5pdGNhbGwrMHg4ZS8weDEzMgpb
ICAgMTcuNjg4NjM0XSAgWzxmZmZmZmZmZjgxZTEwZmNjPl0ga2VybmVsX2luaXRfZnJlZWFi
bGUrMHgxNTQvMHgxZDAKWyAgIDE3LjY4ODYzNF0gIFs8ZmZmZmZmZmY4MWUxMDZkYT5dID8g
ZG9fZWFybHlfcGFyYW0rMHg4OC8weDg4ClsgICAxNy42ODg2MzRdICBbPGZmZmZmZmZmODE4
NDAwMTk+XSA/IHJlc3RfaW5pdCsweGJkLzB4YmQKWyAgIDE3LjY4ODYzNF0gIFs8ZmZmZmZm
ZmY4MTg0MDAyMj5dIGtlcm5lbF9pbml0KzB4OS8weGNjClsgICAxNy42ODg2MzRdICBbPGZm
ZmZmZmZmODE4NTE5M2M+XSByZXRfZnJvbV9mb3JrKzB4N2MvMHhiMApbICAgMTcuNjg4NjM0
XSAgWzxmZmZmZmZmZjgxODQwMDE5Pl0gPyByZXN0X2luaXQrMHhiZC8weGJkClsgICAxNy42
ODg2MzRdIC0tLVsgZW5kIHRyYWNlIDUwODAzYjI3YWY0YzA2NzkgXS0tLQova2VybmVsL3g4
Nl82NC1yYW5kY29uZmlnLXgxLTA5MjgvMzllZGEyYWJhNmJlNjQyYjcxZjJlMGFkNjIzZGNi
MDlmZDlkNzljZi9kbWVzZy15b2N0by1sa3Atc3QwMS0xMToyMDEzMTAwMzAxMjkzODozLjEx
LjAtMDYzNzUtZzM5ZWRhMmE6Mzg0Ci9rZXJuZWwveDg2XzY0LXJhbmRjb25maWcteDEtMDky
OC8zOWVkYTJhYmE2YmU2NDJiNzFmMmUwYWQ2MjNkY2IwOWZkOWQ3OWNmL2RtZXNnLXlvY3Rv
LXN0b2FrbGV5LTc6MjAxMzEwMDMwMTM0MjU6My4xMS4wLTA2Mzc1LWczOWVkYTJhOjM4NAov
a2VybmVsL3g4Nl82NC1yYW5kY29uZmlnLXgxLTA5MjgvMzllZGEyYWJhNmJlNjQyYjcxZjJl
MGFkNjIzZGNiMDlmZDlkNzljZi9kbWVzZy15b2N0by13YWltZWEtNToyMDEzMTAwMzA5MjUw
NTozLjExLjAtMDYzNzUtZzM5ZWRhMmE6Mzg0CgpCaXNlY3Rpbmc6IDM0OTAgcmV2aXNpb25z
IGxlZnQgdG8gdGVzdCBhZnRlciB0aGlzIChyb3VnaGx5IDEyIHN0ZXBzKQpbYWE3MDU0ZjVh
NWE5ZmY3MjhjZTI5MWNiMTAzYWZhMTlmNGY4NDllYl0gTWVyZ2UgdGFnICdwaW5jdHJsLXYz
LjEyLTEnIG9mIGdpdDovL2dpdC5rZXJuZWwub3JnL3B1Yi9zY20vbGludXgva2VybmVsL2dp
dC9saW51c3cvbGludXgtcGluY3RybApydW5uaW5nIC9jL2tlcm5lbC10ZXN0cy9iaXNlY3Qt
dGVzdC1ib290LWZhaWx1cmUuc2ggL2hvbWUvd2ZnL21tL29iai1iaXNlY3QKbHMgLWEgL2tl
cm5lbC10ZXN0cy9ydW4tcXVldWUva3ZtL3g4Nl82NC1yYW5kY29uZmlnLXgxLTA5MjgvbmV4
dDptYXN0ZXI6YWE3MDU0ZjVhNWE5ZmY3MjhjZTI5MWNiMTAzYWZhMTlmNGY4NDllYjpiaXNl
Y3QtbW0KCjIwMTMtMTAtMDQtMDM6MDQ6NDMgYWE3MDU0ZjVhNWE5ZmY3MjhjZTI5MWNiMTAz
YWZhMTlmNGY4NDllYiByZXVzZSAva2VybmVsL3g4Nl82NC1yYW5kY29uZmlnLXgxLTA5Mjgv
YWE3MDU0ZjVhNWE5ZmY3MjhjZTI5MWNiMTAzYWZhMTlmNGY4NDllYi92bWxpbnV6LTMuMTEu
MC0wMzI0OC1nYWE3MDU0ZgoKMjAxMy0xMC0wNC0wMzowNTowNyBkZXRlY3RpbmcgYm9vdCBz
dGF0ZSAuCTMJMTIJMTcJMzIuCTM2Lgk0MAk0Mgk0Mwk0NAk1MAk2NQk2OAk2OQkxMDcJMTE2
CTEzMQkxMzYJMTQxCTE2MCBURVNUIEZBSUxVUkUKG1sxOzM1bUluY3JlYXNpbmcgcmVwZWF0
IGNvdW50IGZyb20gOTE1IHRvIDIxNDAbWzBtClsgICA2NS4xNDU2NjFdIFNjYW5uaW5nIGRl
dmljZSBmb3IgYmFkIGJsb2NrcwpbICAgNjUuODAxMTMyXSAtLS0tLS0tLS0tLS1bIGN1dCBo
ZXJlIF0tLS0tLS0tLS0tLS0KWyAgIDY1LjgwMzY1Ml0gV0FSTklORzogQ1BVOiAwIFBJRDog
MSBhdCAvYy93ZmcvbW0va2VybmVsL3dvcmtxdWV1ZS5jOjU5MSBzZXRfd29ya19kYXRhKzB4
MzMvMHg1MCgpClsgICA2NS44MDQ1MDVdIENQVTogMCBQSUQ6IDEgQ29tbTogc3dhcHBlci8w
IE5vdCB0YWludGVkIDMuMTEuMC0wMzI0OC1nYWE3MDU0ZiAjMzg1ClsgICA2NS44MDQ1MDVd
ICAwMDAwMDAwMDAwMDAwMDAwIGZmZmY4ODAwMGRjMDNkODAgZmZmZmZmZmY4MTgzNzBmMyAw
MDAwMDAwMDAwMDAwMDAwClsgICA2NS44MDQ1MDVdICBmZmZmODgwMDBkYzAzZGI4IGZmZmZm
ZmZmODEwOGU2MTMgZmZmZmZmZmY4MTA5Y2YzOSBmZmZmODgwMDA2Y2MwMDYwClsgICA2NS44
MDQ1MDVdICBmZmZmODgwMDBkYzEzNDAwIDAwMDAwMDAwMDAwMDAwMDUgZmZmZjg4MDAwZGMx
MTYwMCBmZmZmODgwMDBkYzAzZGM4ClsgICA2NS44MDQ1MDVdIENhbGwgVHJhY2U6ClsgICA2
NS44MDQ1MDVdICA8SVJRPiAgWzxmZmZmZmZmZjgxODM3MGYzPl0gZHVtcF9zdGFjaysweDRl
LzB4ODIKWyAgIDY1LjgwNDUwNV0gIFs8ZmZmZmZmZmY4MTA4ZTYxMz5dIHdhcm5fc2xvd3Bh
dGhfY29tbW9uKzB4NzAvMHg4OQpbICAgNjUuODA0NTA1XSAgWzxmZmZmZmZmZjgxMDljZjM5
Pl0gPyBzZXRfd29ya19kYXRhKzB4MzMvMHg1MApbICAgNjUuODA0NTA1XSAgWzxmZmZmZmZm
ZjgxMDhlNmVlPl0gd2Fybl9zbG93cGF0aF9udWxsKzB4MTUvMHgxNwpbICAgNjUuODA0NTA1
XSAgWzxmZmZmZmZmZjgxMDljZjM5Pl0gc2V0X3dvcmtfZGF0YSsweDMzLzB4NTAKWyAgIDY1
LjgwNDUwNV0gIFs8ZmZmZmZmZmY4MTA5ZGM0Zj5dIGluc2VydF93b3JrKzB4MjcvMHg2NQpb
ICAgNjUuODA0NTA1XSAgWzxmZmZmZmZmZjgxMDlkZTVjPl0gX19xdWV1ZV93b3JrKzB4MWNm
LzB4MWVlClsgICA2NS44MDQ1MDVdICBbPGZmZmZmZmZmODEwOWRlN2I+XSA/IF9fcXVldWVf
d29yaysweDFlZS8weDFlZQpbICAgNjUuODA0NTA1XSAgWzxmZmZmZmZmZjgxMDlkZTk0Pl0g
ZGVsYXllZF93b3JrX3RpbWVyX2ZuKzB4MTkvMHgxYgpbICAgNjUuODA0NTA1XSAgWzxmZmZm
ZmZmZjgxMDk1MTUzPl0gY2FsbF90aW1lcl9mbisweDZjLzB4ZGYKWyAgIDY1LjgwNDUwNV0g
IFs8ZmZmZmZmZmY4MTA5NTBlNz5dID8gcHJvY2Vzc190aW1lb3V0KzB4Yi8weGIKWyAgIDY1
LjgwNDUwNV0gIFs8ZmZmZmZmZmY4MTA5ZGU3Yj5dID8gX19xdWV1ZV93b3JrKzB4MWVlLzB4
MWVlClsgICA2NS44MDQ1MDVdICBbPGZmZmZmZmZmODEwOTU4NjI+XSBydW5fdGltZXJfc29m
dGlycSsweDE3MC8weDFiOApbICAgNjUuODA0NTA1XSAgWzxmZmZmZmZmZjgxMDkxYzZhPl0g
X19kb19zb2Z0aXJxKzB4YzgvMHgxOGQKWyAgIDY1LjgwNDUwNV0gIFs8ZmZmZmZmZmY4MTA5
MWU0ND5dIGlycV9leGl0KzB4NTYvMHg5NwpbICAgNjUuODA0NTA1XSAgWzxmZmZmZmZmZjgx
MDJhMzcwPl0gZG9fSVJRKzB4ODgvMHg5ZgpbICAgNjUuODA0NTA1XSAgWzxmZmZmZmZmZjgx
ODQxMWYyPl0gY29tbW9uX2ludGVycnVwdCsweDcyLzB4NzIKWyAgIDY1LjgwNDUwNV0gIDxF
T0k+ICBbPGZmZmZmZmZmODEwYWRlMGM+XSA/IF9fd2FrZV91cCsweDFkLzB4NDYKWyAgIDY1
LjgwNDUwNV0gIFs8ZmZmZmZmZmY4MTBjYjkzMz5dID8gYXJjaF9sb2NhbF9pcnFfcmVzdG9y
ZSsweDYvMHhkClsgICA2NS44MDQ1MDVdICBbPGZmZmZmZmZmODE4NDA3MDA+XSBfcmF3X3Nw
aW5fdW5sb2NrX2lycXJlc3RvcmUrMHg0OC8weDc1ClsgICA2NS44MDQ1MDVdICBbPGZmZmZm
ZmZmODEwYWRlMmU+XSBfX3dha2VfdXArMHgzZi8weDQ2ClsgICA2NS44MDQ1MDVdICBbPGZm
ZmZmZmZmODE0Y2FiYWU+XSBuYW5kX3JlbGVhc2VfZGV2aWNlLmlzcmEuMTMrMHg0OS8weDU4
ClsgICA2NS44MDQ1MDVdICBbPGZmZmZmZmZmODE0Y2I4ZTc+XSBuYW5kX3JlYWRfb29iKzB4
MjU3LzB4MjcwClsgICA2NS44MDQ1MDVdICBbPGZmZmZmZmZmODE0YjQ4OWE+XSBtdGRfcmVh
ZF9vb2IrMHgyNi8weDRjClsgICA2NS44MDQ1MDVdICBbPGZmZmZmZmZmODE0Y2RlNzQ+XSBj
cmVhdGVfYmJ0KzB4MjI1LzB4MmQ0ClsgICA2NS44MDQ1MDVdICBbPGZmZmZmZmZmODE0Y2U0
MmU+XSBuYW5kX3NjYW5fYmJ0KzB4ODUvMHg0ZTMKWyAgIDY1LjgwNDUwNV0gIFs8ZmZmZmZm
ZmY4MTExODA5OD5dID8gX19rbWFsbG9jKzB4OTAvMHhiYgpbICAgNjUuODA0NTA1XSAgWzxm
ZmZmZmZmZjgxNGNlOTZiPl0gbmFuZF9kZWZhdWx0X2JidCsweGRmLzB4ZTQKWyAgIDY1Ljgw
NDUwNV0gIFs8ZmZmZmZmZmY4MWUyNzQzND5dIG5zX2luaXRfbW9kdWxlKzB4NTc2LzB4ZDYx
ClsgICA2NS44MDQ1MDVdICBbPGZmZmZmZmZmODE4M2ViMDE+XSA/IG11dGV4X3VubG9jaysw
eDkvMHhiClsgICA2NS44MDQ1MDVdICBbPGZmZmZmZmZmODFlMjZlYmU+XSA/IGluaXRfbmFu
ZGRvYysweGM4LzB4YzgKWyAgIDY1LjgwNDUwNV0gIFs8ZmZmZmZmZmY4MWRmZGRkND5dIGRv
X29uZV9pbml0Y2FsbCsweDhlLzB4MTMyClsgICA2NS44MDQ1MDVdICBbPGZmZmZmZmZmODEw
YTMxYmM+XSA/IHBhcmFtZXErMHgxZC8weDFmClsgICA2NS44MDQ1MDVdICBbPGZmZmZmZmZm
ODEwYTMzNGY+XSA/IHBhcnNlX2FyZ3MrMHgxOTEvMHgyNDcKWyAgIDY1LjgwNDUwNV0gIFs8
ZmZmZmZmZmY4MWRmZGZjYz5dIGtlcm5lbF9pbml0X2ZyZWVhYmxlKzB4MTU0LzB4MWQwClsg
ICA2NS44MDQ1MDVdICBbPGZmZmZmZmZmODFkZmQ2ZGE+XSA/IGRvX2Vhcmx5X3BhcmFtKzB4
ODgvMHg4OApbICAgNjUuODA0NTA1XSAgWzxmZmZmZmZmZjgxODMwZWE5Pl0gPyByZXN0X2lu
aXQrMHhiZC8weGJkClsgICA2NS44MDQ1MDVdICBbPGZmZmZmZmZmODE4MzBlYjI+XSBrZXJu
ZWxfaW5pdCsweDkvMHhjYwpbICAgNjUuODA0NTA1XSAgWzxmZmZmZmZmZjgxODQxYTdjPl0g
cmV0X2Zyb21fZm9yaysweDdjLzB4YjAKWyAgIDY1LjgwNDUwNV0gIFs8ZmZmZmZmZmY4MTgz
MGVhOT5dID8gcmVzdF9pbml0KzB4YmQvMHhiZApbICAgNjUuODA0NTA1XSAtLS1bIGVuZCB0
cmFjZSBmNTcxMTQ3MjM0NjEwYTc4IF0tLS0KL2tlcm5lbC94ODZfNjQtcmFuZGNvbmZpZy14
MS0wOTI4L2FhNzA1NGY1YTVhOWZmNzI4Y2UyOTFjYjEwM2FmYTE5ZjRmODQ5ZWIvZG1lc2ct
cXVhbnRhbC1sa3AtdHQwMi01OjIwMTMxMDAzMTc0MzE3OjMuMTEuMC0wMzI0OC1nYWE3MDU0
ZjozODUKCkJpc2VjdGluZzogMTM5NiByZXZpc2lvbnMgbGVmdCB0byB0ZXN0IGFmdGVyIHRo
aXMgKHJvdWdobHkgMTEgc3RlcHMpCls3NTExNDQyNzFmNGI2M2Q1ZGU5MDA1ZWE0ZTVlNmU1
YzdjNmZkNjI5XSBNZXJnZSB0YWcgJ3N0YWdpbmctMy4xMi1yYzEnIG9mIGdpdDovL2dpdC5r
ZXJuZWwub3JnL3B1Yi9zY20vbGludXgva2VybmVsL2dpdC9ncmVna2gvc3RhZ2luZwpydW5u
aW5nIC9jL2tlcm5lbC10ZXN0cy9iaXNlY3QtdGVzdC1ib290LWZhaWx1cmUuc2ggL2hvbWUv
d2ZnL21tL29iai1iaXNlY3QKbHMgLWEgL2tlcm5lbC10ZXN0cy9ydW4tcXVldWUva3ZtL3g4
Nl82NC1yYW5kY29uZmlnLXgxLTA5MjgvbmV4dDptYXN0ZXI6NzUxMTQ0MjcxZjRiNjNkNWRl
OTAwNWVhNGU1ZTZlNWM3YzZmZDYyOTpiaXNlY3QtbW0KCjIwMTMtMTAtMDQtMDM6MTY6MTMg
NzUxMTQ0MjcxZjRiNjNkNWRlOTAwNWVhNGU1ZTZlNWM3YzZmZDYyOSBjb21waWxpbmcKMzM2
IHJlYWwgIDE0ODUgdXNlciAgMTQ0IHN5cyAgNDg0LjgyJSBjcHUgCXg4Nl82NC1yYW5kY29u
ZmlnLXgxLTA5MjgKCjIwMTMtMTAtMDQtMDM6MjI6MjQgZGV0ZWN0aW5nIGJvb3Qgc3RhdGUg
My4xMS4wLTAxODUxLWc3NTExNDQyLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4u
Li4JMTEwIFRFU1QgRkFJTFVSRQpbICAgODguNjE1MTE1XSBTY2FubmluZyBkZXZpY2UgZm9y
IGJhZCBibG9ja3MKWyAgIDg5LjMwMDg1N10gLS0tLS0tLS0tLS0tWyBjdXQgaGVyZSBdLS0t
LS0tLS0tLS0tClsgICA4OS4zMDMxMzRdIFdBUk5JTkc6IENQVTogMCBQSUQ6IDEgYXQgL2Mv
d2ZnL21tL2tlcm5lbC93b3JrcXVldWUuYzo1OTAgc2V0X3dvcmtfZGF0YSsweDMzLzB4NTAo
KQpbICAgODkuMzA0MzcxXSBDUFU6IDAgUElEOiAxIENvbW06IHN3YXBwZXIvMCBOb3QgdGFp
bnRlZCAzLjExLjAtMDE4NTEtZzc1MTE0NDIgIzM5OApbICAgODkuMzA0MzcxXSAgMDAwMDAw
MDAwMDAwMDAwMCBmZmZmODgwMDBkYzAzZDgwIGZmZmZmZmZmODE4MzU3MGYgMDAwMDAwMDAw
MDAwMDAwMApbICAgODkuMzA0MzcxXSAgZmZmZjg4MDAwZGMwM2RiOCBmZmZmZmZmZjgxMDhk
ZjJhIGZmZmZmZmZmODEwOWM4MDkgZmZmZjg4MDAwNmNkMDg2MApbICAgODkuMzA0MzcxXSAg
ZmZmZjg4MDAwZGMxMzQwMCAwMDAwMDAwMDAwMDAwMDA1IGZmZmY4ODAwMGRjMTE3ODAgZmZm
Zjg4MDAwZGMwM2RjOApbICAgODkuMzA0MzcxXSBDYWxsIFRyYWNlOgpbICAgODkuMzA0Mzcx
XSAgPElSUT4gIFs8ZmZmZmZmZmY4MTgzNTcwZj5dIGR1bXBfc3RhY2srMHg0ZS8weDgyClsg
ICA4OS4zMDQzNzFdICBbPGZmZmZmZmZmODEwOGRmMmE+XSB3YXJuX3Nsb3dwYXRoX2NvbW1v
bisweDcwLzB4ODkKWyAgIDg5LjMwNDM3MV0gIFs8ZmZmZmZmZmY4MTA5YzgwOT5dID8gc2V0
X3dvcmtfZGF0YSsweDMzLzB4NTAKWyAgIDg5LjMwNDM3MV0gIFs8ZmZmZmZmZmY4MTA4ZTAw
NT5dIHdhcm5fc2xvd3BhdGhfbnVsbCsweDE1LzB4MTcKWyAgIDg5LjMwNDM3MV0gIFs8ZmZm
ZmZmZmY4MTA5YzgwOT5dIHNldF93b3JrX2RhdGErMHgzMy8weDUwClsgICA4OS4zMDQzNzFd
ICBbPGZmZmZmZmZmODEwOWQ1MWY+XSBpbnNlcnRfd29yaysweDI3LzB4NjUKWyAgIDg5LjMw
NDM3MV0gIFs8ZmZmZmZmZmY4MTA5ZDcyYz5dIF9fcXVldWVfd29yaysweDFjZi8weDFlZQpb
ICAgODkuMzA0MzcxXSAgWzxmZmZmZmZmZjgxMDlkNzRiPl0gPyBfX3F1ZXVlX3dvcmsrMHgx
ZWUvMHgxZWUKWyAgIDg5LjMwNDM3MV0gIFs8ZmZmZmZmZmY4MTA5ZDc2ND5dIGRlbGF5ZWRf
d29ya190aW1lcl9mbisweDE5LzB4MWIKWyAgIDg5LjMwNDM3MV0gIFs8ZmZmZmZmZmY4MTA5
NGEyOT5dIGNhbGxfdGltZXJfZm4rMHg2Yy8weGRmClsgICA4OS4zMDQzNzFdICBbPGZmZmZm
ZmZmODEwOTQ5YmQ+XSA/IHByb2Nlc3NfdGltZW91dCsweGIvMHhiClsgICA4OS4zMDQzNzFd
ICBbPGZmZmZmZmZmODEwOWQ3NGI+XSA/IF9fcXVldWVfd29yaysweDFlZS8weDFlZQpbICAg
ODkuMzA0MzcxXSAgWzxmZmZmZmZmZjgxMDk1MTM1Pl0gcnVuX3RpbWVyX3NvZnRpcnErMHgx
NzAvMHgxYjgKWyAgIDg5LjMwNDM3MV0gIFs8ZmZmZmZmZmY4MTA5MTU2OT5dIF9fZG9fc29m
dGlycSsweGM4LzB4MThkClsgICA4OS4zMDQzNzFdICBbPGZmZmZmZmZmODEwOTE3NDM+XSBp
cnFfZXhpdCsweDU2LzB4OTcKWyAgIDg5LjMwNDM3MV0gIFs8ZmZmZmZmZmY4MTAyYTJiYj5d
IGRvX0lSUSsweDg4LzB4OWYKWyAgIDg5LjMwNDM3MV0gIFs8ZmZmZmZmZmY4MTgzZjVmMj5d
IGNvbW1vbl9pbnRlcnJ1cHQrMHg3Mi8weDcyClsgICA4OS4zMDQzNzFdICA8RU9JPiAgWzxm
ZmZmZmZmZjgxNGM5OWJkPl0gPyBuYW5kX2NvbW1hbmQrMHhiZC8weDE4ZQpbICAgODkuMzA0
MzcxXSAgWzxmZmZmZmZmZjgxNGM4MDljPl0gbmFuZF9yZWFkX29vYl9zdGQrMHgxOS8weDMy
ClsgICA4OS4zMDQzNzFdICBbPGZmZmZmZmZmODE0Y2ExMDM+XSBuYW5kX3JlYWRfb29iKzB4
MTU2LzB4MjcwClsgICA4OS4zMDQzNzFdICBbPGZmZmZmZmZmODE0YjMxZDQ+XSBtdGRfcmVh
ZF9vb2IrMHgyNi8weDRjClsgICA4OS4zMDQzNzFdICBbPGZmZmZmZmZmODE0Y2M3OTE+XSBj
cmVhdGVfYmJ0KzB4MjI1LzB4MmQ0ClsgICA4OS4zMDQzNzFdICBbPGZmZmZmZmZmODE0Y2Nk
NGI+XSBuYW5kX3NjYW5fYmJ0KzB4ODUvMHg0ZTMKWyAgIDg5LjMwNDM3MV0gIFs8ZmZmZmZm
ZmY4MTExNzQyYz5dID8gX19rbWFsbG9jKzB4OTAvMHhiYgpbICAgODkuMzA0MzcxXSAgWzxm
ZmZmZmZmZjgxNGNkMjg4Pl0gbmFuZF9kZWZhdWx0X2JidCsweGRmLzB4ZTQKWyAgIDg5LjMw
NDM3MV0gIFs8ZmZmZmZmZmY4MWUyMzM5Mj5dIG5zX2luaXRfbW9kdWxlKzB4NTc2LzB4ZDYx
ClsgICA4OS4zMDQzNzFdICBbPGZmZmZmZmZmODE4M2NmZmM+XSA/IG11dGV4X3VubG9jaysw
eDkvMHhiClsgICA4OS4zMDQzNzFdICBbPGZmZmZmZmZmODFlMjJlMWM+XSA/IGluaXRfbmFu
ZGRvYysweGM4LzB4YzgKWyAgIDg5LjMwNDM3MV0gIFs8ZmZmZmZmZmY4MWRmOWRkND5dIGRv
X29uZV9pbml0Y2FsbCsweDhlLzB4MTMyClsgICA4OS4zMDQzNzFdICBbPGZmZmZmZmZmODEw
YTJjMTA+XSA/IHBhcmFtZXErMHgxZC8weDFmClsgICA4OS4zMDQzNzFdICBbPGZmZmZmZmZm
ODEwYTJkYTM+XSA/IHBhcnNlX2FyZ3MrMHgxOTEvMHgyNDcKWyAgIDg5LjMwNDM3MV0gIFs8
ZmZmZmZmZmY4MWRmOWZjYz5dIGtlcm5lbF9pbml0X2ZyZWVhYmxlKzB4MTU0LzB4MWQwClsg
ICA4OS4zMDQzNzFdICBbPGZmZmZmZmZmODFkZjk2ZGE+XSA/IGRvX2Vhcmx5X3BhcmFtKzB4
ODgvMHg4OApbICAgODkuMzA0MzcxXSAgWzxmZmZmZmZmZjgxODJmNGQ5Pl0gPyByZXN0X2lu
aXQrMHhiZC8weGJkClsgICA4OS4zMDQzNzFdICBbPGZmZmZmZmZmODE4MmY0ZTI+XSBrZXJu
ZWxfaW5pdCsweDkvMHhjYwpbICAgODkuMzA0MzcxXSAgWzxmZmZmZmZmZjgxODNmZTdjPl0g
cmV0X2Zyb21fZm9yaysweDdjLzB4YjAKWyAgIDg5LjMwNDM3MV0gIFs8ZmZmZmZmZmY4MTgy
ZjRkOT5dID8gcmVzdF9pbml0KzB4YmQvMHhiZApbICAgODkuMzA0MzcxXSAtLS1bIGVuZCB0
cmFjZSA1YTNjYTgyZmZiZGJiNmMxIF0tLS0KL2tlcm5lbC94ODZfNjQtcmFuZGNvbmZpZy14
MS0wOTI4Lzc1MTE0NDI3MWY0YjYzZDVkZTkwMDVlYTRlNWU2ZTVjN2M2ZmQ2MjkvZG1lc2ct
cXVhbnRhbC1zdG9ha2xleS00OjIwMTMxMDA0MDMzMjA3OjMuMTEuMC0wMTg1MS1nNzUxMTQ0
MjozOTgKCkJpc2VjdGluZzogOTI1IHJldmlzaW9ucyBsZWZ0IHRvIHRlc3QgYWZ0ZXIgdGhp
cyAocm91Z2hseSAxMCBzdGVwcykKW2MyMTExNDhmYjYzNTVmMzQ3ZWM4MTlhMDVjMzAzNGFj
ZDU2ZTc1YzFdIHN0YWdpbmc6IGRnbmM6IGFkZHMgVE9ETwpydW5uaW5nIC9jL2tlcm5lbC10
ZXN0cy9iaXNlY3QtdGVzdC1ib290LWZhaWx1cmUuc2ggL2hvbWUvd2ZnL21tL29iai1iaXNl
Y3QKbHMgLWEgL2tlcm5lbC10ZXN0cy9ydW4tcXVldWUva3ZtL3g4Nl82NC1yYW5kY29uZmln
LXgxLTA5MjgvbmV4dDptYXN0ZXI6YzIxMTE0OGZiNjM1NWYzNDdlYzgxOWEwNWMzMDM0YWNk
NTZlNzVjMTpiaXNlY3QtbW0KCjIwMTMtMTAtMDQtMDM6NDA6MzggYzIxMTE0OGZiNjM1NWYz
NDdlYzgxOWEwNWMzMDM0YWNkNTZlNzVjMSBjb21waWxpbmcKMzIzIHJlYWwgIDE0NzQgdXNl
ciAgMTM0IHN5cyAgNDk3LjE1JSBjcHUgCXg4Nl82NC1yYW5kY29uZmlnLXgxLTA5MjgKCjIw
MTMtMTAtMDQtMDM6NDc6MjkgZGV0ZWN0aW5nIGJvb3Qgc3RhdGUgMy4xMS4wLXJjNS0wMDky
NS1nYzIxMTE0OC4JMgkxNwkyOAk1OQk3OQk4OAkxMDYJMTMzCTE0OAkxNjkuLi4JMTg2CTE5
My4JMjA3CTIyMQkyMjYJMjQ1CTI1NgkyNjMJMjY3CTI3OQkyOTUuLgkyOTgJMjk5CTMwMgkz
MDUuCTMwNi4JMzEyCTMzMAkzMzMuCTMzNwkzNDkJMzUxCTM1NAkzNjEJMzYyCTM3MgkzODMJ
MzkwCTM5Nwk0MDEJNDA1CTQxOQk0MzAJNDM2CTQ0OQk0NjEJNDcwCTQ3Ngk0ODAJNDk0CTUw
Mgk1MDgJNTI3CTUzOAk1NDMJNTQ4CTU1OAk1NzYJNTg2CTU4Nwk1OTcJNjA1CTYxNAk2MjgJ
NjMyCTYzNgk2NDUJNjcxCTY3Ngk2ODYJNjk1CTcwMS4JNzA2CTcxNAk3MTcJNzE5CTcyMi4u
Lgk3MjQJNzI1CTcyOAk3MzMJNzM3CTc0Nwk3NTEJNzUyCTc1NQk3NTgJNzY0CTc2OAk3NzMJ
Nzc3CTc4My4JNzg2CTc4OQk4MDEJODA1CTg0MAk4NDYJODU0CTg1OQk4NjQJODcwCTg3Mwk4
ODEJODg1CTg5NAk5MDIJOTA1CTkwNwk5MTIJOTI2CTkzNAk5MzcJOTM5CTk0Mgk5NDcJOTUw
CTk1OAk5NzMJOTgyCTk4Mwk5OTgJMTAwNgkxMDE3CTEwMTkuCTEwMzAJMTAzOAkxMDQ5CTEw
NTYJMTA2Mi4JMTA2OQkxMDc4CTEwODMJMTA4OAkxMTAwCTExMDQJMTEwNwkxMTE3CTExMjMJ
MTEzMAkxMTMzCTExMzgJMTE0MQkxMTUxCTExNTcJMTE1OC4uCTExNzguCTExODkJMTIwMAkx
MjAxCTEyMDQJMTIwNwkxMjA5CTEyMTAJMTIxMgkxMjE2LgkxMjE4CTEyMjQJMTIzMQkxMjM4
CTEyNDQJMTI0OAkxMjU5CTEyNjMJMTI2OAkxMjc2CTEyODEJMTI4OAkxMjg5CTEyOTgJMTMw
NAkxMzA4CTEzMTAJMTMxNwkxMzI0CTEzMjgJMTMzMgkxMzM3CTEzNDIJMTM0OQkxMzU2CTEz
NTkJMTM2NwkxMzgyCTEzOTIJMTM5OQkxNDA3CTE0MTIJMTQyMwkxNDI3CTE0MzMuCTE0MzcJ
MTQ0NAkxNDUxCTE0NTgJMTQ2MwkxNDcwCTE0NzQJMTQ3NwkxNDc4CTE0ODEJMTQ4NAkxNDg5
CTE0OTEuCTE0OTQJMTUwMAkxNTAxCTE1MDIJMTUwMwkxNTA1CTE1MDcJMTUwOC4JMTUwOQkx
NTE5CTE1MjMJMTUyOAkxNTM2CTE1NDUJMTU1MAkxNTU3CTE1NjAJMTU2NQkxNTcyCTE1NzcJ
MTU4NQkxNTg4CTE2MDIJMTYxMwkxNjIxCTE2MzYJMTY0NwkxNjUxCTE2NTMJMTY2NQkxNjcy
CTE2NzYJMTY4NgkxNjkyCTE2OTUJMTcwMQkxNzEzCTE3MTUJMTcxNgkxNzIzLi4JMTcyNgkx
NzI3LgkxNzM3CTE3NDgJMTc1NQkxNzY2CTE3NzMJMTc3NAkxNzgyLgkxNzg5CTE3OTYJMTc5
NwkxODA0CTE4MDkJMTgxMAkxODE5CTE4MjUJMTgzMi4JMTgzMwkxODM0CTE4MzgJMTg0OQkx
ODUxCTE4NTIJMTg1NAkxODYxCTE4NjQJMTg3MAkxODcxCTE4NzkJMTg4MwkxODg0CTE4ODgJ
MTg5MwkxOTAwCTE5MDEJMTkxMgkxOTE1CTE5MTgJMTkyMgkxOTM0CTE5MzkJMTk0NgkxOTU2
CTE5NTcJMTk2MQkxOTYyCTE5NjkJMTk3Mi4JMTk3MwkxOTc2CTE5NzkJMTk4NAkxOTg4CTE5
ODkJMTk5MgkxOTk5CTIwMDEJMjAwMwkyMDA4CTIwMDkJMjAxMgkyMDE1CTIwMTkJMjAyNQky
MDMwCTIwMzUJMjA0MAkyMDQxCTIwNDMJMjA0NS4JMjA0NgkyMDQ4CTIwNTAJMjA1MQkyMDUy
LgkyMDU2CTIwNTguCTIwNjYJMjA2OQkyMDcwCTIwNzgJMjA4NgkyMDk3CTIxMDQJMjExMgky
MTE1CTIxMTYuLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4u
Li4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4u
Li4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4u
Li4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4u
Li4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4u
Li4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uG1sxOzM1bWFkZF90b19y
dW5fcXVldWUgMjQbWzBtCi4uLgkyMTE4CTIxMjgJMjEzMwkyMTM5CTIxNDAgU1VDQ0VTUwoK
QmlzZWN0aW5nOiA1NjEgcmV2aXNpb25zIGxlZnQgdG8gdGVzdCBhZnRlciB0aGlzIChyb3Vn
aGx5IDkgc3RlcHMpCltiOWExMDQ4MTM3ZjRhZTQzZWU5MGY2MWEzZjM0ZjBlZmU4NjNjZmVi
XSB1c2Jjb3JlOiBmaXggaW5jb3JyZWN0IHR5cGUgaW4gYXNzaWdubWVudCBpbiBkZXNjcmlw
dG9yc19jaGFuZ2VkKCkKcnVubmluZyAvYy9rZXJuZWwtdGVzdHMvYmlzZWN0LXRlc3QtYm9v
dC1mYWlsdXJlLnNoIC9ob21lL3dmZy9tbS9vYmotYmlzZWN0CmxzIC1hIC9rZXJuZWwtdGVz
dHMvcnVuLXF1ZXVlL2t2bS94ODZfNjQtcmFuZGNvbmZpZy14MS0wOTI4L25leHQ6bWFzdGVy
OmI5YTEwNDgxMzdmNGFlNDNlZTkwZjYxYTNmMzRmMGVmZTg2M2NmZWI6YmlzZWN0LW1tCgoy
MDEzLTEwLTA0LTA5OjI1OjA3IGI5YTEwNDgxMzdmNGFlNDNlZTkwZjYxYTNmMzRmMGVmZTg2
M2NmZWIgY29tcGlsaW5nCjMxMSByZWFsICAxMzc4IHVzZXIgIDE0MCBzeXMgIDQ4Ni45OCUg
Y3B1IAl4ODZfNjQtcmFuZGNvbmZpZy14MS0wOTI4CgoyMDEzLTEwLTA0LTA5OjMxOjIwIGRl
dGVjdGluZyBib290IHN0YXRlIDMuMTEuMC1yYzYuLi4JMwk2CTEwCTExCTE2CTE4CTIwCTI0
CTMwLgkzNgk0MAk0OQk1MQk1Mwk1NAk1Ngk1OAk2NAk2OAk3NQk4MAk4OAk5Mgk5Ngk5OAkx
MDIJMTA4CTExNAkxMTgJMTIyCTEyNS4JMTM1CTE0NQkxNTEJMTYyCTE2NAkxNjYJMTY4CTE3
NwkxODEJMTg0CTE4OQkxOTIJMTk1CTE5NgkyMDAJMjAzCTIwNQkyMTAJMjE1CTIyMQkyMjkJ
MjMzCTIzNgkyNDEJMjQyCTI0NQkyNDkJMjUyCTI1MwkyNTcJMjU4CTI1OQkyNjAuCTI2NAky
NjgJMjY5CTI3MQkyNzMJMjc0CTI3OAkyNzkJMjgxLgkyODIJMjgzCTI4OAkyOTEJMjkzCTI5
NQkyOTYJMjk3CTMwMAkzMDMJMzA2CTMxMAkzMTQJMzIxCTMyMgkzMjQJMzI4LgkzMzIJMzM2
LgkzMzgJMzQzCTM0NQkzNDkJMzUzCTM1NwkzNjAJMzc1CTM4MgkzODkJMzk1CTQwMwk0MTQJ
NDI2CTQzNQk0NDMJNDQ5CTQ1OQk0NjkJNDc1CTQ3OQk0ODkJNDkyCTUxMAk1MTUJNTIyCTUz
Mwk1MzYJNTUxCTU2MQk1NjMJNTc1CTU4Mgk1ODgJNjAyCTYwMwk2MDkJNjIzCTYyNwk2MzkJ
NjQ3CTY1Ngk2NTgJNjY0CTY3MQk2NzQJNjc3CTY5Mgk3MDQJNzE1CTcxOAk3MjgJNzMyCTcz
NQk3NDMJNzUwCTc1OQk3NzMJNzc2CTc4NAk3OTQJODAxCTgwOAk4MjQJODM3CTg0NQk4NTMJ
ODY0CTg2OQk4NzUJODgzCTg5Mwk5MDQJOTA5CTkxNwk5MjIJOTM2CTk0NC4JOTU1CTk1Ni4J
OTcyCTk5MQkxMDA0CTEwMjUJMTA0NAkxMDYwCTEwODEJMTA5MQkxMTM4CTExNTIJMTE2Mwkx
MTc4CTExOTYJMTIxMwkxMjI4CTEyNDEJMTI3MAkxMjc4CTEyOTQJMTMxMgkxMzMxCTEzNDcJ
MTM2NAkxMzc3CTEzOTYJMTQxMwkxNDIzCTE0NDAJMTQ1NQkxNDcwCTE0NzUJMTQ5MgkxNTAz
CTE1MTgJMTUzNQkxNTUyCTE1NTkJMTU3NgkxNjA2CTE2MTIJMTYzNAkxNjQ2CTE2NTMJMTY3
NAkxNjg3CTE3MDQJMTcyMwkxNzI2CTE3MzUJMTc1MwkxNzY1CTE3ODMJMTc4NwkxODAzCTE4
MjcJMTg1MAkxODY1CTE5MTIJMTkxOQkxOTI0CTE5NDQJMTk3NQkxOTk3CTIwMDYJMjA0Mgky
MDU2CTIwNjIuCTIwNjMuCTIwNjUJMjA2OC4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4u
Li4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4u
Li4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4u
Li4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4u
Li4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4u
Li4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4u
Li4bWzE7MzVtYWRkX3RvX3J1bl9xdWV1ZSA3MhtbMG0KLi4uCTIwNzAJMjA3NQkyMDc4CTIw
ODEJMjA4MwkyMDg0CTIwODUJMjA4OC4JMjA4OS4uCTIwOTAuCTIwOTIJMjA5MwkyMDk1CTIw
OTcJMjA5OQkyMTA0CTIxMDgJMjExMgkyMTE0CTIxMTUJMjExNgkyMTE5CTIxMjMJMjEyNAky
MTI2CTIxMjkJMjEzMQkyMTM3CTIxMzguLgkyMTM5Li4JMjE0MCBTVUNDRVNTCgpCaXNlY3Rp
bmc6IDI2NSByZXZpc2lvbnMgbGVmdCB0byB0ZXN0IGFmdGVyIHRoaXMgKHJvdWdobHkgOCBz
dGVwcykKW2VjMTg4MmE5MzkxYzU1MzMyZWJmM2QxNjU0ZjQwYjc2ZTRhNmMwMTBdIE1lcmdl
IHRhZyAncmVndWxhdG9yLXYzLjEyJyBvZiBnaXQ6Ly9naXQua2VybmVsLm9yZy9wdWIvc2Nt
L2xpbnV4L2tlcm5lbC9naXQvYnJvb25pZS9yZWd1bGF0b3IKcnVubmluZyAvYy9rZXJuZWwt
dGVzdHMvYmlzZWN0LXRlc3QtYm9vdC1mYWlsdXJlLnNoIC9ob21lL3dmZy9tbS9vYmotYmlz
ZWN0CmxzIC1hIC9rZXJuZWwtdGVzdHMvcnVuLXF1ZXVlL2t2bS94ODZfNjQtcmFuZGNvbmZp
Zy14MS0wOTI4L25leHQ6bWFzdGVyOmVjMTg4MmE5MzkxYzU1MzMyZWJmM2QxNjU0ZjQwYjc2
ZTRhNmMwMTA6YmlzZWN0LW1tCgoyMDEzLTEwLTA0LTE0OjMwOjQxIGVjMTg4MmE5MzkxYzU1
MzMyZWJmM2QxNjU0ZjQwYjc2ZTRhNmMwMTAgY29tcGlsaW5nCjQyNSByZWFsICAxNDA4IHVz
ZXIgIDE0MCBzeXMgIDM2NC4zMSUgY3B1IAl4ODZfNjQtcmFuZGNvbmZpZy14MS0wOTI4Cgoy
MDEzLTEwLTA0LTE0OjM4OjUyIGRldGVjdGluZyBib290IHN0YXRlIDMuMTEuMC0wMDI5Ni1n
ZWMxODgyYS4uLgk1CTEwCTEyCTE0CTE5CTIxCTIyCTI0CTMwCTMyCTMzCTM3CTQ1CTU0CTYw
CTY3CTcyCTc2CTg5CTk1CTk4CTEwMgkxMTYJMTIzCTEyNwkxMzcJMTQzCTE1NQkxNjAJMTY2
CTE3NgkxOTEJMTk1CTIwNAkyMTIJMjI2CTIzOAkyNDMJMjQ5CTI1NwkyNjMJMjc1CTI3Nwky
ODYJMjkzCTMwMAkzMTQJMzIzCTMzMAkzMzYJMzM3CTM1MgkzNjQJMzcxCTM3NQkzODAJMzk3
CTQwNgk0MTMJNDI0CTQyOQk0MzMJNDQwCTQ0NQk0NTQJNDU5CTQ2Ngk0NzAJNDc0CTQ3Nwk0
ODIJNDg1CTQ5MAk0OTYJNTAzCTUwOAk1MTAJNTE3CTUxOAk1MjMJNTMxCTUzMgk1MzgJNTQ0
CTU0NQk1NDcuLgk1NTEJNTU3CTU1OQk1NjEJNTY5Lgk1NzgJNTc5Lgk1ODEJNTg0CTU4Ngk1
ODgJNTkwCTU5Mwk1OTQJNTk1CTU5Nwk1OTgJNjAwCTYwMgk2MDQJNjA5CTYxNwk2MjIJNjI4
CTYzNAk2NDUJNjQ2CTY1MAk2NTUJNjYzCTY3MAk2NzQJNjg3CTY5MAk2OTYJNzAwCTcwNwk3
MTQJNzE2CTcyNAk3MzAJNzM3CTc0NAk3NTAJNzU0CTc1OQk3NjMJNzcyCTc3Ngk3ODAJNzg3
CTc4OQk3OTUJODAwCTgwNAk4MTMJODIxCTgyNAk4MjcJODMyCTgzNAk4MzcJODQ1CTg0Nwk4
NTEJODU3CTg2MAk4NjUJODY5CTg3NQk4NzYJODg1CTg5MQk4OTMJODk5CTkwNAk5MTAJOTIy
CTkyMwk5MjcJOTMxCTkzNAk5NDMJOTQ5CTk1NQk5NjAJOTY0CTk2Nwk5NzIJOTgzCTk4Ngk5
OTAJOTkzCTk5NQkxMDAwCTEwMDQJMTAwNgkxMDA4CTEwMTEJMTAxMgkxMDE0CTEwMTgJMTAy
MAkxMDI0CTEwMzMJMTAzOQkxMDQ1CTEwNDgJMTA1NwkxMDYzCTEwNjkJMTA3MwkxMDc4CTEw
ODEJMTA4NAkxMDg4CTEwODkJMTA5NgkxMDk4CTExMDAJMTEwNwkxMTA4CTExMTIuCTExMTgJ
MTEyNgkxMTI4CTExMjkJMTEzMAkxMTMxCTExMzIJMTEzMwkxMTQxLgkxMTQ1CTExNDkJMTE1
MwkxMTU4CTExNjAJMTE2OQkxMTc3CTExODIJMTE4OAkxMTkxCTExOTYJMTIwNAkxMjA3CTEy
MTMJMTIxOAkxMjIwLgkxMjMxCTEyMzcJMTIzOQkxMjQxCTEyNDcJMTI1Ni4JMTI2NAkxMjY3
CTEyNzEJMTI3NQkxMjc2CTEyNzgJMTI4MgkxMjg3CTEyOTAJMTI5NwkxMjk5CTEzMDEJMTMw
NwkxMzEwCTEzMTMJMTMxNAkxMzE2CTEzMTcuLi4JMTMxOQkxMzIwCTEzMjEJMTMyMwkxMzI1
Li4JMTMyNgkxMzI4CTEzMzEJMTMzMgkxMzMzCTEzMzgJMTM0MC4JMTM0MQkxMzQ2CTEzNTAu
Li4JMTM1MgkxMzU4CTEzNjAJMTM2MgkxMzcwCTEzODUJMTM5MgkxMzk5CTE0MDUJMTQwOAkx
NDEwCTE0MTEJMTQxMgkxNDE0LgkxNDE1CTE0MTgJMTQyMgkxNDIzCTE0MjQJMTQyNS4uCTE0
MjYJMTQyNwkxNDI4CTE0MjkJMTQzMQkxNDM1CTE0MzgJMTQ0NQkxNDQ3CTE0NDgJMTQ0OQkx
NDUxLgkxNDUzCTE0NTQJMTQ1NQkxNDU3CTE0NTkuCTE0NjYJMTQ3MwkxNDc2CTE0OTAJMTQ5
MgkxNTAxCTE1MTUJMTUyMQkxNTMxCTE1NDAJMTU0OAkxNTUxCTE1NTcJMTU2NQkxNTc2CTE1
ODEJMTU5MgkxNjAwCTE2MDcJMTYyMAkxNjI2CTE2MjgJMTYzMAkxNjM4CTE2NDQJMTY0Nwkx
NjU0CTE2NTYJMTY2NAkxNjcyCTE2NzQJMTY4MQkxNjg4CTE2OTEJMTY5OQkxNzAzCTE3MDgJ
MTcxNQkxNzE3CTE3MjcJMTczMgkxNzM2CTE3NDMJMTc0OQkxNzU2CTE3NTkJMTc2NwkxNzY5
LgkxNzc0CTE3NzgJMTc4NAkxNzkwCTE3OTQJMTc5NwkxODAxCTE4MDUJMTgxMgkxODE3CTE4
MjEJMTgyNwkxODMwCTE4MzYJMTgzNwkxODM4CTE4NDcJMTg1NAkxODU4CTE4NjMJMTg3NQkx
ODc2CTE4NzcJMTg4MgkxODg4CTE4OTUJMTkwMC4JMTkwMgkxOTExCTE5MTcJMTkyNgkxOTI5
CTE5MzEJMTkzOAkxOTQzCTE5NDkJMTk1MgkxOTU2CTE5NTkJMTk3MAkxOTczCTE5NzUJMTk3
OAkxOTc5CTE5ODMJMTk4NwkxOTk4CTIwMDEJMjAwOAkyMDE3CTIwMjYJMjAyOAkyMDM1CTIw
NDAJMjA0NAkyMDQ3CTIwNTIJMjA1NwkyMDYyCTIwNjMJMjA2OC4JMjA3MAkyMDc1CTIwNzcu
LgkyMDc4CTIwODIuCTIwODMuLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4u
Li4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4u
Li4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4u
Li4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4u
Li4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4u
Li4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uG1sxOzM1
bWFkZF90b19ydW5fcXVldWUgNTcbWzBtCi4uLgkyMDg3CTIwOTAJMjA5MgkyMTAxCTIxMDQJ
MjEwOQkyMTIxLgkyMTI2CTIxMzQJMjEzNwkyMTQwIFNVQ0NFU1MKCkJpc2VjdGluZzogMTQz
IHJldmlzaW9ucyBsZWZ0IHRvIHRlc3QgYWZ0ZXIgdGhpcyAocm91Z2hseSA3IHN0ZXBzKQpb
MWQxZmRkOTVkZjY4MWYwYzA2NWQ5MGZmYWFmYTIxNWEwZTg4MjVlMl0gTWVyZ2UgdGFnICdj
aGFyLW1pc2MtMy4xMi1yYzEnIG9mIGdpdDovL2dpdC5rZXJuZWwub3JnL3B1Yi9zY20vbGlu
dXgva2VybmVsL2dpdC9ncmVna2gvY2hhci1taXNjCnJ1bm5pbmcgL2Mva2VybmVsLXRlc3Rz
L2Jpc2VjdC10ZXN0LWJvb3QtZmFpbHVyZS5zaCAvaG9tZS93ZmcvbW0vb2JqLWJpc2VjdAps
cyAtYSAva2VybmVsLXRlc3RzL3J1bi1xdWV1ZS9rdm0veDg2XzY0LXJhbmRjb25maWcteDEt
MDkyOC9uZXh0Om1hc3RlcjoxZDFmZGQ5NWRmNjgxZjBjMDY1ZDkwZmZhYWZhMjE1YTBlODgy
NWUyOmJpc2VjdC1tbQoKMjAxMy0xMC0wNC0yMTowNTowNCAxZDFmZGQ5NWRmNjgxZjBjMDY1
ZDkwZmZhYWZhMjE1YTBlODgyNWUyIGNvbXBpbGluZwoyNzEgcmVhbCAgMTI1OSB1c2VyICAx
MjYgc3lzICA1MTAuMTklIGNwdSAJeDg2XzY0LXJhbmRjb25maWcteDEtMDkyOAoKMjAxMy0x
MC0wNC0yMTowOTo1MiBkZXRlY3RpbmcgYm9vdCBzdGF0ZSAzLjExLjAtMDA3ODItZzFkMWZk
ZDkuLgkxCTUJMTMJMjAJMjEJMjIJMzEJMzkJNTIJNjAJNjkJNzcJODIJOTEJOTcJMTAxCTEw
NwkxMTAJMTE1CTEyNgkxMzcJMTQ5CTE1MgkxNTQJMTU5CTE2MQkxNjIJMTY1CTE2NwkxNzIJ
MTczCTE3OAkxNzkuCTE4MC4uCTE4MS4uLi4uLgkxODQuCTE4NQkxODcJMTkxCTE5NAkxOTkJ
MjA2CTIxMAkyMTYuCTIyMQkyMzAJMjM2CTI0MQkyNTAJMjYzCTI3MAkyNzMJMjg0CTI5MAkz
MDQJMzA2CTMwOAkzMTEuLgkzMTQJMzE1LgkzMTcJMzIwLi4JMzIxCTMyMgkzMjQJMzI1CTMy
NwkzMjgJMzI5LgkzMzMuCTMzNQkzMzguLgkzNDQJMzQ5CTM1NQkzNjcJMzcxCTM3NQkzNzcJ
Mzg0CTM5MAkzOTcJNDAzCTQwNwk0MTAuLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4u
Li4uLi4uLi4uLi4uLi4JNDEzCTYzMwk2NTIJNjYxCTY3MQk2NzkJNjg0CTY4Nwk2OTAJNjk2
Lgk2OTkJNzA1CTcxMS4JNzE5CTcyOQk3MzQJNzM5CTc0Mwk3NDkJNzU1CTc1Nwk3NjMJNzY5
CTc3NAk3NzcJNzc5Lgk3ODEJNzg0CTc4Nwk3OTIuLi4uLi4uLi4uLi4uLi4uLi4uCTg3Mi4u
CTg5Mwk5MDEJOTA1Lgk5MjAuLi4uLi4uLi4JOTc2CTk4Ny4uCTEwMTIJMTAxOQkxMDI1Lgkx
MDI5CTEwMzcJMTAzOQkxMDQwCTEwNDMJMTA0OQkxMDUzCTEwNTgJMTA2MgkxMDY3CTEwNzIJ
MTA3NgkxMDg3CTEwODkJMTA5MgkxMDk5CTExMDYJMTEwNwkxMTEyCTExMTUJMTExOQkxMTIx
CTExMjYJMTEzMgkxMTM5CTExNDIJMTE0OAkxMTUzCTExNTcuCTExNTkJMTE2Ni4JMTE2OAkx
MTczCTExNzUJMTE3OAkxMTgyCTExODcJMTE5NAkxMTk5CTEyMDYJMTIxNAkxMjE4CTEyMjAJ
MTIyNQkxMjI5CTEyMzIJMTIzMwkxMjQzCTEyNDcJMTI1MAkxMjU2CTEyNjEJMTI2NwkxMjcw
CTEyNzgJMTI4NAkxMjg3CTEyOTAJMTI5MgkxMjk5CTEzMDQJMTMwNgkxMzEyCTEzMTUJMTMx
OQkxMzIxCTEzMjQJMTMyOQkxMzM0CTEzNDEJMTM0OAkxMzQ5CTEzNTgJMTM2MQkxMzY0CTEz
NjYJMTM2OAkxMzc0CTEzNzUJMTM3OAkxMzg2CTEzOTAJMTM5NgkxMzk4CTE0MDEJMTQwOAkx
NDA5CTE0MTMJMTQxNgkxNDIwCTE0MjIJMTQyNQkxNDI5CTE0MzIJMTQzNQkxNDQ0CTE0NTIJ
MTQ1NgkxNDY0CTE0NjcJMTQ3NQkxNDgwCTE0ODMJMTQ4NAkxNDg4CTE0OTkJMTUwNgkxNTE0
CTE1MTgJMTUxOQkxNTI2CTE1MjkJMTUzMgkxNTM4CTE1NDYJMTU1NQkxNTYxCTE1NzQJMTU4
MQkxNTg2CTE1OTMJMTU5NwkxNjAwCTE2MDQJMTYxMQkxNjE3CTE2MjcJMTYzMgkxNjQwCTE2
NDQJMTY1NAkxNjYxCTE2NjUJMTY2OAkxNjc3CTE2ODQJMTY4NwkxNjkwCTE3MDEJMTcxMAkx
NzEzCTE3MTUJMTcxOQkxNzI4CTE3MzAJMTczNQkxNzQ1CTE3NDYJMTc1MAkxNzU3CTE3NjQJ
MTc3NQkxNzgwCTE3ODIJMTc4NAkxNzg4CTE3OTEJMTc5NQkxNzk2CTE3OTkJMTgwMgkxODA4
CTE4MTEJMTgxMgkxODE0CTE4MTkJMTgyMQkxODI3CTE4MzUJMTgzNgkxODM5CTE4NDMJMTg0
OQkxODUxCTE4NTMJMTg1OAkxODU5CTE4NjEJMTg2NgkxODY3CTE4NjkJMTg3MQkxODc2CTE4
NzkJMTg4NAkxODg1CTE4ODkJMTg5MC4JMTg5MwkxODk3CTE4OTgJMTkwMAkxOTAyCTE5MDYJ
MTkxMgkxOTE0CTE5MTYJMTkyMAkxOTI0CTE5MjkJMTkzNQkxOTQwLgkxOTQ3CTE5NTcJMTk2
MgkxOTY3CTE5NzYJMTk4MwkxOTg2CTE5ODgJMTk5MQkxOTkzCTE5OTcuCTIwMDIJMjAwNwky
MDEyCTIwMTMJMjAxNgkyMDE5CTIwMjAuCTIwMjYJMjAyNwkyMDI5CTIwMzQJMjAzNgkyMDM5
Li4uLi4uLi4JMjA1NwkyMDY3CTIwNjkJMjA3MAkyMDcyCTIwNzcJMjA4MAkyMDgxCTIwODIJ
MjA4NAkyMDg2CTIwODcJMjA5OAkyMTA1CTIxMTEJMjExMwkyMTE0Li4uLi4uLi4uLi4uLi4u
Li4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4u
Li4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4u
Li4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4u
Li4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4u
Li4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4u
Li4uLi4uLi4uLi4uLi4uLhtbMTszNW1hZGRfdG9fcnVuX3F1ZXVlIDI2G1swbQouLi4JMjEx
NgkyMTE3CTIxMTgJMjExOQkyMTIwCTIxMjMJMjEzMQkyMTMzCTIxMzYJMjE0MCBTVUNDRVNT
CgpCaXNlY3Rpbmc6IDcxIHJldmlzaW9ucyBsZWZ0IHRvIHRlc3QgYWZ0ZXIgdGhpcyAocm91
Z2hseSA2IHN0ZXBzKQpbZjlhZTQ0M2I1YTFhYTNkMzRkNTdkZjk2NmEyMjBhNTFhODU0ZDRj
OF0gc3lzZnM6IGdyb3VwLmM6IGFkZCBrZXJuZWxkb2MgZm9yIHN5c2ZzX3JlbW92ZV9ncm91
cApydW5uaW5nIC9jL2tlcm5lbC10ZXN0cy9iaXNlY3QtdGVzdC1ib290LWZhaWx1cmUuc2gg
L2hvbWUvd2ZnL21tL29iai1iaXNlY3QKbHMgLWEgL2tlcm5lbC10ZXN0cy9ydW4tcXVldWUv
a3ZtL3g4Nl82NC1yYW5kY29uZmlnLXgxLTA5MjgvbmV4dDptYXN0ZXI6ZjlhZTQ0M2I1YTFh
YTNkMzRkNTdkZjk2NmEyMjBhNTFhODU0ZDRjODpiaXNlY3QtbW0KCjIwMTMtMTAtMDUtMDM6
NTA6MDMgZjlhZTQ0M2I1YTFhYTNkMzRkNTdkZjk2NmEyMjBhNTFhODU0ZDRjOCBjb21waWxp
bmcKMzAyIHJlYWwgIDEzODQgdXNlciAgMTM2IHN5cyAgNTAxLjkzJSBjcHUgCXg4Nl82NC1y
YW5kY29uZmlnLXgxLTA5MjgKCjIwMTMtMTAtMDUtMDM6NTU6MjUgZGV0ZWN0aW5nIGJvb3Qg
c3RhdGUgMy4xMS4wLXJjMy0wMDA3Mi1nZjlhZTQ0MwkxCTQJMTEJMTUJMTYJMjYuCTMxCTM3
IFRFU1QgRkFJTFVSRQpbICAgIDMuNzI4NjM1XSAuLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4u
Li4uLi4uLi4uLi4gZG9uZS4KWyAgICAzLjcyOTI0NF0gcmVnaXN0ZXJlZCB0YXNrc3RhdHMg
dmVyc2lvbiAxClsgICAgMy44MDQ2MzJdIEJVRzogdW5hYmxlIHRvIGhhbmRsZSBrZXJuZWwg
ClsgICAgMy44MDQ5NDRdIHJ0Yy10ZXN0IHJ0Yy10ZXN0LjA6IHNldHRpbmcgc3lzdGVtIGNs
b2NrIHRvIDIwMTMtMTAtMDQgMTk6NTg6MDQgVVRDICgxMzgwOTE2Njg0KQpOVUxMIHBvaW50
ZXIgZGVyZWZlcmVuY2UgYXQgMDAwMDAwMDAwMDAwMDAwOAoKL2tlcm5lbC94ODZfNjQtcmFu
ZGNvbmZpZy14MS0wOTI4L2Y5YWU0NDNiNWExYWEzZDM0ZDU3ZGY5NjZhMjIwYTUxYTg1NGQ0
YzgvZG1lc2ctcXVhbnRhbC13YWltZWEtMTQ6MjAxMzEwMDUxMTU4MjE6eDg2XzY0LXJhbmRj
b25maWcteDEtMDkyODozLjExLjAtcmMzLTAwMDcyLWdmOWFlNDQzOjQwMwoKQmlzZWN0aW5n
OiAzNSByZXZpc2lvbnMgbGVmdCB0byB0ZXN0IGFmdGVyIHRoaXMgKHJvdWdobHkgNSBzdGVw
cykKWzkxMGY1YzdjZGIxZDQ1NDE5OTdmMDFjMTdiNzMxYmRmZTJlOTJlZGFdIENvcnJlY3Qg
dW5mYWl0aGZ1bCB0cmFuc2xhdGlvbiBvbiBIT1dUTyBpbiBrb19LUgpydW5uaW5nIC9jL2tl
cm5lbC10ZXN0cy9iaXNlY3QtdGVzdC1ib290LWZhaWx1cmUuc2ggL2hvbWUvd2ZnL21tL29i
ai1iaXNlY3QKbHMgLWEgL2tlcm5lbC10ZXN0cy9ydW4tcXVldWUva3ZtL3g4Nl82NC1yYW5k
Y29uZmlnLXgxLTA5MjgvbmV4dDptYXN0ZXI6OTEwZjVjN2NkYjFkNDU0MTk5N2YwMWMxN2I3
MzFiZGZlMmU5MmVkYTpiaXNlY3QtbW0KCjIwMTMtMTAtMDUtMDM6NTk6NTggOTEwZjVjN2Nk
YjFkNDU0MTk5N2YwMWMxN2I3MzFiZGZlMmU5MmVkYSBjb21waWxpbmcKMTk5IHJlYWwgIDEz
NzIgdXNlciAgMTI4IHN5cyAgNzUyLjM0JSBjcHUgCXg4Nl82NC1yYW5kY29uZmlnLXgxLTA5
MjgKCjIwMTMtMTAtMDUtMDQ6MDM6MzEgZGV0ZWN0aW5nIGJvb3Qgc3RhdGUgMy4xMS4wLXJj
My0wMDAzNi1nOTEwZjVjNy4uLi4JMTYuCTI0Li4JMzUuCTQ1CTUyCTU2CTY0CTY4CTczCTc3
CTgzCTg3CTg4CTk4CTEwMAkxMjIuLgkxMjkJMTM4CTE0Ni4JMTQ3CTE1NC4JMTU2CTE2Ngkx
NzMJMTc4CTE4MwkxODcJMTkwIFRFU1QgRkFJTFVSRQpbICAxMjQuNTMzNDQzXSBTY2Fubmlu
ZyBkZXZpY2UgZm9yIGJhZCBibG9ja3MKWyAgMTI1LjAzNjM5Nl0gLS0tLS0tLS0tLS0tWyBj
dXQgaGVyZSBdLS0tLS0tLS0tLS0tClsgIDEyNS4wMzYzOTZdIFdBUk5JTkc6IENQVTogMCBQ
SUQ6IDEgYXQgL2Mvd2ZnL21tL2tlcm5lbC93b3JrcXVldWUuYzo1OTAgc2V0X3dvcmtfZGF0
YSsweDMzLzB4NTAoKQpbICAxMjUuMDM2Mzk2XSBDUFU6IDAgUElEOiAxIENvbW06IHN3YXBw
ZXIvMCBOb3QgdGFpbnRlZCAzLjExLjAtcmMzLTAwMDM2LWc5MTBmNWM3ICM0MDQKWyAgMTI1
LjAzNjM5Nl0gIDAwMDAwMDAwMDAwMDAwMDAgZmZmZjg4MDAwZGMwM2Q4MCBmZmZmZmZmZjgx
ODJhMTZmIDAwMDAwMDAwMDAwMDAwMDAKWyAgMTI1LjAzNjM5Nl0gIGZmZmY4ODAwMGRjMDNk
YjggZmZmZmZmZmY4MTA4ZGY2YSBmZmZmZmZmZjgxMDlmMjQwIGZmZmY4ODAwMDZjYjQ4NjAK
WyAgMTI1LjAzNjM5Nl0gIGZmZmY4ODAwMGRjMTM0MDAgMDAwMDAwMDAwMDAwMDAwNSBmZmZm
ODgwMDBkYzExN2MwIGZmZmY4ODAwMGRjMDNkYzgKWyAgMTI1LjAzNjM5Nl0gQ2FsbCBUcmFj
ZToKWyAgMTI1LjAzNjM5Nl0gIDxJUlE+ICBbPGZmZmZmZmZmODE4MmExNmY+XSBkdW1wX3N0
YWNrKzB4NGUvMHg4MgpbICAxMjUuMDM2Mzk2XSAgWzxmZmZmZmZmZjgxMDhkZjZhPl0gd2Fy
bl9zbG93cGF0aF9jb21tb24rMHg3MC8weDg5ClsgIDEyNS4wMzYzOTZdICBbPGZmZmZmZmZm
ODEwOWYyNDA+XSA/IHNldF93b3JrX2RhdGErMHgzMy8weDUwClsgIDEyNS4wMzYzOTZdICBb
PGZmZmZmZmZmODEwOGUwNDU+XSB3YXJuX3Nsb3dwYXRoX251bGwrMHgxNS8weDE3ClsgIDEy
NS4wMzYzOTZdICBbPGZmZmZmZmZmODEwOWYyNDA+XSBzZXRfd29ya19kYXRhKzB4MzMvMHg1
MApbICAxMjUuMDM2Mzk2XSAgWzxmZmZmZmZmZjgxMDlmZjU2Pl0gaW5zZXJ0X3dvcmsrMHgy
Ny8weDY1ClsgIDEyNS4wMzYzOTZdICBbPGZmZmZmZmZmODEwYTAxNjM+XSBfX3F1ZXVlX3dv
cmsrMHgxY2YvMHgxZWUKWyAgMTI1LjAzNjM5Nl0gIFs8ZmZmZmZmZmY4MTBhMDE4Mj5dID8g
X19xdWV1ZV93b3JrKzB4MWVlLzB4MWVlClsgIDEyNS4wMzYzOTZdICBbPGZmZmZmZmZmODEw
YTAxOWI+XSBkZWxheWVkX3dvcmtfdGltZXJfZm4rMHgxOS8weDFiClsgIDEyNS4wMzYzOTZd
ICBbPGZmZmZmZmZmODEwOTc0NjA+XSBjYWxsX3RpbWVyX2ZuKzB4NmMvMHhkZgpbICAxMjUu
MDM2Mzk2XSAgWzxmZmZmZmZmZjgxMDk3M2Y0Pl0gPyBwcm9jZXNzX3RpbWVvdXQrMHhiLzB4
YgpbICAxMjUuMDM2Mzk2XSAgWzxmZmZmZmZmZjgxMGEwMTgyPl0gPyBfX3F1ZXVlX3dvcmsr
MHgxZWUvMHgxZWUKWyAgMTI1LjAzNjM5Nl0gIFs8ZmZmZmZmZmY4MTA5N2I2Yz5dIHJ1bl90
aW1lcl9zb2Z0aXJxKzB4MTcwLzB4MWI4ClsgIDEyNS4wMzYzOTZdICBbPGZmZmZmZmZmODEw
OTNmOTg+XSBfX2RvX3NvZnRpcnErMHhjOC8weDE4ZApbICAxMjUuMDM2Mzk2XSAgWzxmZmZm
ZmZmZjgxMDk0MTcyPl0gaXJxX2V4aXQrMHg1Ni8weDk3ClsgIDEyNS4wMzYzOTZdICBbPGZm
ZmZmZmZmODEwMmEyYmI+XSBkb19JUlErMHg4OC8weDlmClsgIDEyNS4wMzYzOTZdICBbPGZm
ZmZmZmZmODE2M2Q5OTU+XSA/IGxlZF90cmlnZ2VyX2V2ZW50KzB4NGIvMHg1NApbICAxMjUu
MDM2Mzk2XSAgWzxmZmZmZmZmZjgxODM0MGYyPl0gY29tbW9uX2ludGVycnVwdCsweDcyLzB4
NzIKWyAgMTI1LjAzNjM5Nl0gIDxFT0k+ICBbPGZmZmZmZmZmODE2M2Q5NzA+XSA/IGxlZF90
cmlnZ2VyX2V2ZW50KzB4MjYvMHg1NApbICAxMjUuMDM2Mzk2XSAgWzxmZmZmZmZmZjgxMGMz
MGNlPl0gPyBhcmNoX2xvY2FsX2lycV9yZXN0b3JlKzB4Ni8weGQKWyAgMTI1LjAzNjM5Nl0g
IFs8ZmZmZmZmZmY4MTBjNmFkNT5dIGxvY2tfcmVsZWFzZSsweDE1MC8weDE2YQpbICAxMjUu
MDM2Mzk2XSAgWzxmZmZmZmZmZjgxODMzOTc5Pl0gX3Jhd19yZWFkX3VubG9jaysweDFhLzB4
NGQKWyAgMTI1LjAzNjM5Nl0gIFs8ZmZmZmZmZmY4MTYzZDk5NT5dIGxlZF90cmlnZ2VyX2V2
ZW50KzB4NGIvMHg1NApbICAxMjUuMDM2Mzk2XSAgWzxmZmZmZmZmZjgxNGM4Y2QzPl0gbmFu
ZF93YWl0X3JlYWR5KzB4ODQvMHhiMgpbICAxMjUuMDM2Mzk2XSAgWzxmZmZmZmZmZjgxNGM4
ZTg0Pl0gbmFuZF9jb21tYW5kKzB4MTgzLzB4MThlClsgIDEyNS4wMzYzOTZdICBbPGZmZmZm
ZmZmODE0Yzc0OWQ+XSBuYW5kX3JlYWRfb29iX3N0ZCsweDE5LzB4MzIKWyAgMTI1LjAzNjM5
Nl0gIFs8ZmZmZmZmZmY4MTRjOTUwND5dIG5hbmRfcmVhZF9vb2IrMHgxNTYvMHgyNzAKWyAg
MTI1LjAzNjM5Nl0gIFs8ZmZmZmZmZmY4MTRiMjVjYT5dIG10ZF9yZWFkX29vYisweDI2LzB4
NGMKWyAgMTI1LjAzNjM5Nl0gIFs8ZmZmZmZmZmY4MTRjYmI5Mj5dIGNyZWF0ZV9iYnQrMHgy
MjUvMHgyZDQKWyAgMTI1LjAzNjM5Nl0gIFs8ZmZmZmZmZmY4MTRjYzE0Yz5dIG5hbmRfc2Nh
bl9iYnQrMHg4NS8weDRlMwpbICAxMjUuMDM2Mzk2XSAgWzxmZmZmZmZmZjgxMTE3M2E0Pl0g
PyBfX2ttYWxsb2MrMHg5MC8weGJiClsgIDEyNS4wMzYzOTZdICBbPGZmZmZmZmZmODE0Y2M2
ODk+XSBuYW5kX2RlZmF1bHRfYmJ0KzB4ZGYvMHhlNApbICAxMjUuMDM2Mzk2XSAgWzxmZmZm
ZmZmZjgxZTEzMzM4Pl0gbnNfaW5pdF9tb2R1bGUrMHg1NzYvMHhkNjEKWyAgMTI1LjAzNjM5
Nl0gIFs8ZmZmZmZmZmY4MTgzMWIyMz5dID8gbXV0ZXhfdW5sb2NrKzB4OS8weGIKWyAgMTI1
LjAzNjM5Nl0gIFs8ZmZmZmZmZmY4MWUxMmRjMj5dID8gaW5pdF9uYW5kZG9jKzB4YzgvMHhj
OApbICAxMjUuMDM2Mzk2XSAgWzxmZmZmZmZmZjgxZGU5ZGQ0Pl0gZG9fb25lX2luaXRjYWxs
KzB4OGUvMHgxMzIKWyAgMTI1LjAzNjM5Nl0gIFs8ZmZmZmZmZmY4MTBhNTVmNj5dID8gcGFy
YW1lcSsweDFkLzB4MWYKWyAgMTI1LjAzNjM5Nl0gIFs8ZmZmZmZmZmY4MTBhNTc4OT5dID8g
cGFyc2VfYXJncysweDE5MS8weDI0NwpbICAxMjUuMDM2Mzk2XSAgWzxmZmZmZmZmZjgxZGU5
ZmNjPl0ga2VybmVsX2luaXRfZnJlZWFibGUrMHgxNTQvMHgxZDAKWyAgMTI1LjAzNjM5Nl0g
IFs8ZmZmZmZmZmY4MWRlOTZkYT5dID8gZG9fZWFybHlfcGFyYW0rMHg4OC8weDg4ClsgIDEy
NS4wMzYzOTZdICBbPGZmZmZmZmZmODE4MjNmMzk+XSA/IHJlc3RfaW5pdCsweGJkLzB4YmQK
WyAgMTI1LjAzNjM5Nl0gIFs8ZmZmZmZmZmY4MTgyM2Y0Mj5dIGtlcm5lbF9pbml0KzB4OS8w
eGNjClsgIDEyNS4wMzYzOTZdICBbPGZmZmZmZmZmODE4MzQ5N2M+XSByZXRfZnJvbV9mb3Jr
KzB4N2MvMHhiMApbICAxMjUuMDM2Mzk2XSAgWzxmZmZmZmZmZjgxODIzZjM5Pl0gPyByZXN0
X2luaXQrMHhiZC8weGJkClsgIDEyNS4wMzYzOTZdIC0tLVsgZW5kIHRyYWNlIDZiMTYyYzBm
NDYyNjIzOGUgXS0tLQova2VybmVsL3g4Nl82NC1yYW5kY29uZmlnLXgxLTA5MjgvOTEwZjVj
N2NkYjFkNDU0MTk5N2YwMWMxN2I3MzFiZGZlMmU5MmVkYS9kbWVzZy1xdWFudGFsLWxrcC10
dDAyLTg6MjAxMzEwMDQxODUxNTA6eDg2XzY0LXJhbmRjb25maWcteDEtMDkyODozLjExLjAt
cmMzLTAwMDM2LWc5MTBmNWM3OjQwNAoKQmlzZWN0aW5nOiAxNyByZXZpc2lvbnMgbGVmdCB0
byB0ZXN0IGFmdGVyIHRoaXMgKHJvdWdobHkgNCBzdGVwcykKWzg2ZGYyNjg3MDU2OTZjZTIy
ODY0MTBmMTQ5M2UyOTRlODg5YmRjZTZdIGRyaXZlcnM6YmFzZTpjb3JlOiBNb3ZlZCBzeW0g
ZXhwb3J0IG1hY3JvcyB0byByZXNwZWN0aXZlIGZ1bmN0aW9ucwpydW5uaW5nIC9jL2tlcm5l
bC10ZXN0cy9iaXNlY3QtdGVzdC1ib290LWZhaWx1cmUuc2ggL2hvbWUvd2ZnL21tL29iai1i
aXNlY3QKbHMgLWEgL2tlcm5lbC10ZXN0cy9ydW4tcXVldWUva3ZtL3g4Nl82NC1yYW5kY29u
ZmlnLXgxLTA5MjgvbmV4dDptYXN0ZXI6ODZkZjI2ODcwNTY5NmNlMjI4NjQxMGYxNDkzZTI5
NGU4ODliZGNlNjpiaXNlY3QtbW0KCjIwMTMtMTAtMDUtMDQ6MjM6MzQgODZkZjI2ODcwNTY5
NmNlMjI4NjQxMGYxNDkzZTI5NGU4ODliZGNlNiBjb21waWxpbmcKMjA0IHJlYWwgIDE0Nzcg
dXNlciAgMTQ0IHN5cyAgNzk0LjUyJSBjcHUgCXg4Nl82NC1yYW5kY29uZmlnLXgxLTA5MjgK
CjIwMTMtMTAtMDUtMDQ6Mjc6MDkgZGV0ZWN0aW5nIGJvb3Qgc3RhdGUgMy4xMS4wLXJjMi0w
MDAxOC1nODZkZjI2OAkzCTgJMTYJMjEJMjYJMzEJMzUJMzkJNDIJNDcJNTAJNTUJNjAJNjMJ
NzAJNzYJODMgVEVTVCBGQUlMVVJFCi9iaW4vc2g6IC9wcm9jL3NlbGYvZmQvOTogTm8gc3Vj
aCBmaWxlIG9yIGRpcmVjdG9yeQovYmluL3NoOiAvcHJvYy9zZWxmL2ZkLzk6IE5vIHN1Y2gg
ZmlsZSBvciBkaXJlY3RvcnkKWyAgICAzLjAyODA1M10gQlVHOiB1bmFibGUgdG8gaGFuZGxl
IGtlcm5lbCBOVUxMIHBvaW50ZXIgZGVyZWZlcmVuY2UgYXQgMDAwMDAwMDAwMDAwMDAwOApb
ICAgIDMuMDI5MjM0XSBJUDogWzxmZmZmZmZmZjgxMDk3YjI4Pl0gcnVuX3RpbWVyX3NvZnRp
cnErMHgxMmMvMHgxYjgKWyAgICAzLjAzMDE0MV0gUEdEIDZhNTAwNjcgUFVEIDZhNGYwNjcg
UE1EIDAgClsgICAgMy4wMzA3OThdIE9vcHM6IDAwMDIgWyMxXSBQUkVFTVBUIFNNUCBERUJV
R19QQUdFQUxMT0MKWyAgICAzLjAzMTYzMl0gQ1BVOiAxIFBJRDogMCBDb21tOiBzd2FwcGVy
LzEgTm90IHRhaW50ZWQgMy4xMS4wLXJjMi0wMDAxOC1nODZkZjI2OCAjNDA1ClsgICAgMy4w
MzIwMzRdIHRhc2s6IGZmZmY4ODAwMDAxNDIyYzAgdGk6IGZmZmY4ODAwMDAxNDQwMDAgdGFz
ay50aTogZmZmZjg4MDAwMDE0NDAwMApbICAgIDMuMDMyMDM0XSBSSVA6IDAwMTA6WzxmZmZm
ZmZmZjgxMDk3YjI4Pl0gIFs8ZmZmZmZmZmY4MTA5N2IyOD5dIHJ1bl90aW1lcl9zb2Z0aXJx
KzB4MTJjLzB4MWI4ClsgICAgMy4wMzIwMzRdIFJTUDogMDAxODpmZmZmODgwMDBkZDAzZWYw
ICBFRkxBR1M6IDAwMDEwMDAyClsgICAgMy4wMzIwMzRdIFJBWDogZmZmZjg4MDAwZGQwM2Vm
MCBSQlg6IGZmZmY4ODAwMDAxNWMwMDAgUkNYOiAwMDAwMDAwMDAwMDAwMDAyClsgICAgMy4w
MzIwMzRdIFJEWDogMDAwMDAwMDAwMDAwMDAwMCBSU0k6IDAwMDAwMDAwMDAwMDAwMDAgUkRJ
OiBmZmZmODgwMDAwMTVjMDAwClsgICAgMy4wMzIwMzRdIFJCUDogZmZmZjg4MDAwZGQwM2Yy
OCBSMDg6IDAwMDAwMDAwMDAwMDAwMDIgUjA5OiAwMDAwMDAwMDAwMDAwMDAxClsgICAgMy4w
MzIwMzRdIFIxMDogZmZmZmZmZmY4MTA5N2I3NCBSMTE6IDAwMDAwMDAwMDAwMGI4NGEgUjEy
OiBmZmZmODgwMDA2ZGM5OGEwClsgICAgMy4wMzIwMzRdIFIxMzogZmZmZjg4MDAwZGQwM2Vm
MCBSMTQ6IGZmZmZmZmZmODEwYTAxODIgUjE1OiBmZmZmODgwMDA2ZGM5ODYwClsgICAgMy4w
MzIwMzRdIEZTOiAgMDAwMDAwMDAwMDAwMDAwMCgwMDAwKSBHUzpmZmZmODgwMDBkZDAwMDAw
KDAwMDApIGtubEdTOjAwMDAwMDAwMDAwMDAwMDAKWyAgICAzLjAzMjAzNF0gQ1M6ICAwMDEw
IERTOiAwMDAwIEVTOiAwMDAwIENSMDogMDAwMDAwMDA4MDA1MDAzYgpbICAgIDMuMDMyMDM0
XSBDUjI6IDAwMDAwMDAwMDAwMDAwMDggQ1IzOiAwMDAwMDAwMDA2YTRkMDAwIENSNDogMDAw
MDAwMDAwMDAwMDZhMApbICAgIDMuMDMyMDM0XSBTdGFjazoKWyAgICAzLjAzMjAzNF0gIGZm
ZmY4ODAwMDZkYzk4YTAgZmZmZjg4MDAwNmRkMDhhMCAwMDAwMDAwMDAwMDAwMTQxIGZmZmZm
ZmZmODFjMWIwODgKWyAgICAzLjAzMjAzNF0gIGZmZmY4ODAwMDAxNDVmZDggMDAwMDAwMDAw
MDAwMDAwYSAwMDAwMDAwMDAwMDAwMTAxIGZmZmY4ODAwMGRkMDNmODAKWyAgICAzLjAzMjAz
NF0gIGZmZmZmZmZmODEwOTNmOTggMDAwMDAwMDAwMDAwMDAwMSAwMDAwMDAwMDAwMDAwMDAx
IDAwMjAwMDQwMDAwMDAwMDEKWyAgICAzLjAzMjAzNF0gQ2FsbCBUcmFjZToKWyAgICAzLjAz
MjAzNF0gIDxJUlE+IApbICAgIDMuMDMyMDM0XSAgWzxmZmZmZmZmZjgxMDkzZjk4Pl0gX19k
b19zb2Z0aXJxKzB4YzgvMHgxOGQKWyAgICAzLjAzMjAzNF0gIFs8ZmZmZmZmZmY4MTA5NDE3
Mj5dIGlycV9leGl0KzB4NTYvMHg5NwpbICAgIDMuMDMyMDM0XSAgWzxmZmZmZmZmZjgxMDQz
ZjExPl0gc21wX2FwaWNfdGltZXJfaW50ZXJydXB0KzB4MzAvMHgzYwpbICAgIDMuMDMyMDM0
XSAgWzxmZmZmZmZmZjgxODM1MGYyPl0gYXBpY190aW1lcl9pbnRlcnJ1cHQrMHg3Mi8weDgw
ClsgICAgMy4wMzIwMzRdICA8RU9JPiAKWyAgICAzLjAzMjAzNF0gIFs8ZmZmZmZmZmY4MTBh
YjM5ZT5dID8gbm90aWZpZXJfY2FsbF9jaGFpbisweDU5LzB4NTkKWyAgICAzLjAzMjAzNF0g
IFs8ZmZmZmZmZmY4MTBhYjM5ZT5dID8gbm90aWZpZXJfY2FsbF9jaGFpbisweDU5LzB4NTkK
WyAgICAzLjAzMjAzNF0gIFs8ZmZmZmZmZmY4MTA0OTFhZD5dID8gbmF0aXZlX3NhZmVfaGFs
dCsweDYvMHg4ClsgICAgMy4wMzIwMzRdICBbPGZmZmZmZmZmODEwMmZjY2M+XSBkZWZhdWx0
X2lkbGUrMHgxMy8weDFjClsgICAgMy4wMzIwMzRdICBbPGZmZmZmZmZmODEwMzAzY2Q+XSBh
cmNoX2NwdV9pZGxlKzB4MTMvMHgyMQpbICAgIDMuMDMyMDM0XSAgWzxmZmZmZmZmZjgxMGJi
Mzc4Pl0gY3B1X3N0YXJ0dXBfZW50cnkrMHgxMDEvMHgxNjEKWyAgICAzLjAzMjAzNF0gIFs8
ZmZmZmZmZmY4MTA0MjgyZD5dIHN0YXJ0X3NlY29uZGFyeSsweDFlZC8weDFmMQpbICAgIDMu
MDMyMDM0XSBDb2RlOiA4YiA2NSBjOCA0ZCAzOSBlYyAwZiA4NCAyZiBmZiBmZiBmZiA0MSA4
YiA0YyAyNCAxOCA0ZCA4YiA3NCAyNCAyMCA0ZCA4YiA3YyAyNCAyOCA0YyA4OSA2MyAzOCA0
OSA4YiA0NCAyNCAwOCA0OSA4YiAxNCAyNCA4MyBlMSAwMiA8NDg+IDg5IDQyIDA4IDQ4IDg5
IDEwIDQ4IGI4IDAwIDAyIDIwIDAwIDAwIDAwIGFkIGRlIDQxIGY2IDQ0IDI0IApbICAgIDMu
MDMyMDM0XSBSSVAgIFs8ZmZmZmZmZmY4MTA5N2IyOD5dIHJ1bl90aW1lcl9zb2Z0aXJxKzB4
MTJjLzB4MWI4ClsgICAgMy4wMzIwMzRdICBSU1AgPGZmZmY4ODAwMGRkMDNlZjA+ClsgICAg
My4wMzIwMzRdIENSMjogMDAwMDAwMDAwMDAwMDAwOApbICAgIDMuMDMyMDM0XSAtLS1bIGVu
ZCB0cmFjZSAyNzAyNjRjMmM5YWE0Nzc5IF0tLS0KL2tlcm5lbC94ODZfNjQtcmFuZGNvbmZp
Zy14MS0wOTI4Lzg2ZGYyNjg3MDU2OTZjZTIyODY0MTBmMTQ5M2UyOTRlODg5YmRjZTYvZG1l
c2cteW9jdG8teHBzLTE6MjAxMzEwMDUxMjMzNTk6eDg2XzY0LXJhbmRjb25maWcteDEtMDky
ODozLjExLjAtcmMyLTAwMDE4LWc4NmRmMjY4OjQwNQoKQmlzZWN0aW5nOiA4IHJldmlzaW9u
cyBsZWZ0IHRvIHRlc3QgYWZ0ZXIgdGhpcyAocm91Z2hseSAzIHN0ZXBzKQpbN2M0MjcyMWZl
MGM1OGE4NDg4NDliNDNmZjU1OGNmMmZiODZhYTM1YV0gY2hhcjogdGlsZS1zcm9tOiBmaXgg
YnVpbGQgZXJyb3IKcnVubmluZyAvYy9rZXJuZWwtdGVzdHMvYmlzZWN0LXRlc3QtYm9vdC1m
YWlsdXJlLnNoIC9ob21lL3dmZy9tbS9vYmotYmlzZWN0CmxzIC1hIC9rZXJuZWwtdGVzdHMv
cnVuLXF1ZXVlL2t2bS94ODZfNjQtcmFuZGNvbmZpZy14MS0wOTI4L25leHQ6bWFzdGVyOjdj
NDI3MjFmZTBjNThhODQ4ODQ5YjQzZmY1NThjZjJmYjg2YWEzNWE6YmlzZWN0LW1tCgoyMDEz
LTEwLTA1LTA0OjM1OjQyIDdjNDI3MjFmZTBjNThhODQ4ODQ5YjQzZmY1NThjZjJmYjg2YWEz
NWEgY29tcGlsaW5nCjE5MCByZWFsICAxMzgwIHVzZXIgIDEzMSBzeXMgIDc5NS44MiUgY3B1
IAl4ODZfNjQtcmFuZGNvbmZpZy14MS0wOTI4CgoyMDEzLTEwLTA1LTA0OjM5OjA2IGRldGVj
dGluZyBib290IHN0YXRlIDMuMTEuMC1yYzItMDAwMDktZzdjNDI3MjEuLgkxCTQJOAkxNAkx
Ni4JMjMJMjUJMjkJMzEJMzQJMzgJNDMJNTAJNTUJNjEJNzAJNzEJNzYJODEJODYJOTAJOTcJ
OTkJMTA1CTEwNwkxMDgJMTE2CTEyMwkxMjQJMTI1CTEzMQkxMzcJMTQxCTE0NS4JMTU0CTE2
MAkxNjgJMTcxCTE3My4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4u
Li4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLgkzNDcJNDEzLi4uLi4uLgk0NzYuCTQ5MAk0OTgJ
NTA3CTUxNwk1MjIJNTI1CTUzMAk1MzQJNTM1CTU0MQk1NDQJNTUyCTU1Mwk1NTcJNTU5CTU2
NS4JNTY4CTU3Mwk1NzcJNTg1CTU5Mgk1OTYJNjAyCTYwNgk2MTEJNjE3CTYyMgk2MjgJNjMz
CTYzOAk2NDUJNjQ4CTY1Mwk2NTgJNjY0CTY3MAk2NzUJNjgxCTY4Mwk2ODkJNjkyCTY5Mwk3
MDUuCTcxNQk3MTkJNzI0CTczMgk3MzgJNzQ1CTc0OQk3NTMJNzU3CTc2MQk3NjUJNzY2CTc3
Mgk3NzQJNzc5CTc4MQk3ODYJNzg4CTc5Mwk3OTgJODAzCTgwNwk4MTAJODE1CTgxOQk4MjYJ
ODI5CTgzNAk4MzcJODM4CTg0MAk4NDIJODQ3CTg1Mgk4NTMJODU5CTg2MQk4NjUJODcwCTg3
OAk4ODAJODg2CTg5NAk4OTkuCTkwNQk5MDgJOTEyCTkxMy4JOTE1CTkxNwk5MjAuCTkyMgk5
MjUJOTI4CTkzOQk5NDQJOTUyCTk1Ngk5NjEuCTk2Mwk5NjYJOTcxCTk3Mwk5NzcJOTg4CTk5
NQk5OTYJMTAwMwkxMDA3LgkxMDEwCTEwMTMJMTAxNwkxMDE5CTEwMjYJMTAzMgkxMDM1CTEw
NTEJMTA1OQkxMDYzCTEwNjcJMTA3MAkxMDcyCTEwNzgJMTA4NAkxMDg3CTEwOTUJMTEwMAkx
MTA3CTExMTEuCTExMTIJMTEyNgkxMTMyCTExMzcJMTE0MAkxMTQ4CTExNTIJMTE1NAkxMTYz
CTExNjgJMTE3MwkxMTc5CTExODcJMTE5NAkxMjAwCTEyMDQJMTIwNQkxMjA3CTEyMTEJMTIx
MwkxMjE2CTEyMjcJMTIzMS4JMTI0NC4JMTI0OAkxMjUxLgkxMjU2CTEyNTkJMTI2MAkxMjYy
LgkxMjY3CTEyNzAJMTI4MAkxMjg5CTEyOTIJMTI5NgkxMzAxLgkxMzA2LgkxMzE0CTEzMTgJ
MTMyOQkxMzM0CTEzNDEJMTM0NQkxMzQ3CTEzNDgJMTM1MgkxMzU2CTEzNjMJMTM2OAkxMzcx
CTEzODUJMTM4OQkxMzk0CTE0MDAJMTQwNQkxNDA5CTE0MTkJMTQyMwkxNDI5CTE0MzUuCTE0
MzYJMTQzOQkxNDQwCTE0NDUJMTQ1MQkxNDU0CTE0NTcJMTQ2MAkxNDYzCTE0NzQJMTQ4Mwkx
NDkxCTE1MDAJMTUwMgkxNTA3CTE1MTUJMTUxOQkxNTIzLgkxNTMxCTE1MzQJMTU0MwkxNTU1
CTE1NjAJMTU2NQkxNTcxCTE1NzcJMTU4MAkxNTg2CTE1OTQJMTYwMAkxNjA2CTE2MDcJMTYx
NQkxNjIxCTE2MjQJMTYzMAkxNjM5CTE2NDMJMTY1MAkxNjU1CTE2NjQJMTY3NQkxNjgwCTE2
ODUJMTY5MAkxNjk3CTE3MDkJMTcxNwkxNzIyCTE3MjgJMTczMQkxNzQyLgkxNzUzCTE3NTkJ
MTc2MQkxNzY0CTE3NjkJMTc3MwkxNzgwCTE3ODQJMTc4NgkxNzkwCTE3OTYuCTE4MDMJMTgw
NgkxODA5CTE4MTMJMTgxOAkxODIyCTE4MjQuCTE4MjYJMTgzMQkxODM5CTE4NDQJMTg0Nwkx
ODQ5CTE4NTUJMTg2MgkxODY4CTE4NzAJMTg3MwkxODgxCTE4ODYJMTg5MgkxODk1CTE4OTkJ
MTkwMgkxOTA1CTE5MDYJMTkxMC4JMTkxMQkxOTE0CTE5MTkJMTkyMgkxOTI5CTE5MzMJMTkz
NgkxOTQzCTE5NDUJMTk0OAkxOTUwCTE5NTIJMTk1NwkxOTYwCTE5NjUuCTE5NzEJMTk3NAkx
OTc4CTE5ODIJMTk5MAkxOTkyCTE5OTMJMTk5OAkyMDAxCTIwMDQJMjAwNgkyMDEyCTIwMTUJ
MjAxOQkyMDI0CTIwMzIJMjAzNgkyMDQyCTIwNDUJMjA1MAkyMDU2CTIwNTkJMjA2MQkyMDY4
CTIwNzQJMjA4MC4JMjA5MAkyMDk3CTIxMDEJMjEwNwkyMTA5Li4uLi4uLi4uLi4uLi4uLi4u
Li4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4u
Li4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4u
Li4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4u
Li4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4u
Li4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4u
Li4uLi4uLi4uLi4uLhtbMTszNW1hZGRfdG9fcnVuX3F1ZXVlIDMxG1swbQouLgkyMTE1CTIx
MjEJMjEyMwkyMTM3CTIxMzkuLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4u
Li4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4u
Li4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4u
Li4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4u
Li4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4u
Li4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uG1sxOzM1
bWFkZF90b19ydW5fcXVldWUgMRtbMG0KLi4uCTIxNDAgU1VDQ0VTUwoKQmlzZWN0aW5nOiA0
IHJldmlzaW9ucyBsZWZ0IHRvIHRlc3QgYWZ0ZXIgdGhpcyAocm91Z2hseSAyIHN0ZXBzKQpb
OTJhM2U2NjFiZjU1NDU3MDkxODE3YzVjMzQ2YzQzMTNiZTI1MDhhZl0gU0NTSTogT1NEOiBj
b252ZXJ0IGNsYXNzIGNvZGUgdG8gdXNlIGRldl9ncm91cHMKcnVubmluZyAvYy9rZXJuZWwt
dGVzdHMvYmlzZWN0LXRlc3QtYm9vdC1mYWlsdXJlLnNoIC9ob21lL3dmZy9tbS9vYmotYmlz
ZWN0CmxzIC1hIC9rZXJuZWwtdGVzdHMvcnVuLXF1ZXVlL2t2bS94ODZfNjQtcmFuZGNvbmZp
Zy14MS0wOTI4L25leHQ6bWFzdGVyOjkyYTNlNjYxYmY1NTQ1NzA5MTgxN2M1YzM0NmM0MzEz
YmUyNTA4YWY6YmlzZWN0LW1tCgoyMDEzLTEwLTA1LTEzOjQxOjE5IDkyYTNlNjYxYmY1NTQ1
NzA5MTgxN2M1YzM0NmM0MzEzYmUyNTA4YWYgY29tcGlsaW5nCjI4NSByZWFsICAxMzUzIHVz
ZXIgIDEzNiBzeXMgIDUyMi41MSUgY3B1IAl4ODZfNjQtcmFuZGNvbmZpZy14MS0wOTI4Cgoy
MDEzLTEwLTA1LTEzOjQ2OjIwIGRldGVjdGluZyBib290IHN0YXRlIDMuMTEuMC1yYzItMDAw
MTMtZzkyYTNlNjYJMjYJNTkJMTEyCTE4OAkyNTUJMzEwIFRFU1QgRkFJTFVSRQpbICAgNjAu
NjM1NDc2XSBTY2FubmluZyBkZXZpY2UgZm9yIGJhZCBibG9ja3MKWyAgIDYxLjAzNjg4NV0g
LS0tLS0tLS0tLS0tWyBjdXQgaGVyZSBdLS0tLS0tLS0tLS0tClsgICA2MS4wMzkzMDddIFdB
Uk5JTkc6IENQVTogMCBQSUQ6IDEgYXQgL2Mvd2ZnL21tL2tlcm5lbC93b3JrcXVldWUuYzo1
OTAgc2V0X3dvcmtfZGF0YSsweDMzLzB4NTAoKQpbICAgNjEuMDQwMzk2XSBDUFU6IDAgUElE
OiAxIENvbW06IHN3YXBwZXIvMCBOb3QgdGFpbnRlZCAzLjExLjAtcmMyLTAwMDEzLWc5MmEz
ZTY2ICM0MDcKWyAgIDYxLjA0MDM5Nl0gIDAwMDAwMDAwMDAwMDAwMDAgZmZmZjg4MDAwZGMw
M2Q4MCBmZmZmZmZmZjgxODI5YmNmIDAwMDAwMDAwMDAwMDAwMDAKWyAgIDYxLjA0MDM5Nl0g
IGZmZmY4ODAwMGRjMDNkYjggZmZmZmZmZmY4MTA4ZGY2YSBmZmZmZmZmZjgxMDlmMjQwIGZm
ZmY4ODAwMDZjZDA4NjAKWyAgIDYxLjA0MDM5Nl0gIGZmZmY4ODAwMGRjMTM0MDAgMDAwMDAw
MDAwMDAwMDAwNSBmZmZmODgwMDBkYzExN2MwIGZmZmY4ODAwMGRjMDNkYzgKWyAgIDYxLjA0
MDM5Nl0gQ2FsbCBUcmFjZToKWyAgIDYxLjA0MDM5Nl0gIDxJUlE+ICBbPGZmZmZmZmZmODE4
MjliY2Y+XSBkdW1wX3N0YWNrKzB4NGUvMHg4MgpbICAgNjEuMDQwMzk2XSAgWzxmZmZmZmZm
ZjgxMDhkZjZhPl0gd2Fybl9zbG93cGF0aF9jb21tb24rMHg3MC8weDg5ClsgICA2MS4wNDAz
OTZdICBbPGZmZmZmZmZmODEwOWYyNDA+XSA/IHNldF93b3JrX2RhdGErMHgzMy8weDUwClsg
ICA2MS4wNDAzOTZdICBbPGZmZmZmZmZmODEwOGUwNDU+XSB3YXJuX3Nsb3dwYXRoX251bGwr
MHgxNS8weDE3ClsgICA2MS4wNDAzOTZdICBbPGZmZmZmZmZmODEwOWYyNDA+XSBzZXRfd29y
a19kYXRhKzB4MzMvMHg1MApbICAgNjEuMDQwMzk2XSAgWzxmZmZmZmZmZjgxMDlmZjU2Pl0g
aW5zZXJ0X3dvcmsrMHgyNy8weDY1ClsgICA2MS4wNDAzOTZdICBbPGZmZmZmZmZmODEwYTAx
NjM+XSBfX3F1ZXVlX3dvcmsrMHgxY2YvMHgxZWUKWyAgIDYxLjA0MDM5Nl0gIFs8ZmZmZmZm
ZmY4MTBhMDE4Mj5dID8gX19xdWV1ZV93b3JrKzB4MWVlLzB4MWVlClsgICA2MS4wNDAzOTZd
ICBbPGZmZmZmZmZmODEwYTAxOWI+XSBkZWxheWVkX3dvcmtfdGltZXJfZm4rMHgxOS8weDFi
ClsgICA2MS4wNDAzOTZdICBbPGZmZmZmZmZmODEwOTc0NjA+XSBjYWxsX3RpbWVyX2ZuKzB4
NmMvMHhkZgpbICAgNjEuMDQwMzk2XSAgWzxmZmZmZmZmZjgxMDk3M2Y0Pl0gPyBwcm9jZXNz
X3RpbWVvdXQrMHhiLzB4YgpbICAgNjEuMDQwMzk2XSAgWzxmZmZmZmZmZjgxMGEwMTgyPl0g
PyBfX3F1ZXVlX3dvcmsrMHgxZWUvMHgxZWUKWyAgIDYxLjA0MDM5Nl0gIFs8ZmZmZmZmZmY4
MTA5N2I2Yz5dIHJ1bl90aW1lcl9zb2Z0aXJxKzB4MTcwLzB4MWI4ClsgICA2MS4wNDAzOTZd
ICBbPGZmZmZmZmZmODEwOTNmOTg+XSBfX2RvX3NvZnRpcnErMHhjOC8weDE4ZApbICAgNjEu
MDQwMzk2XSAgWzxmZmZmZmZmZjgxMDk0MTcyPl0gaXJxX2V4aXQrMHg1Ni8weDk3ClsgICA2
MS4wNDAzOTZdICBbPGZmZmZmZmZmODEwMmEyYmI+XSBkb19JUlErMHg4OC8weDlmClsgICA2
MS4wNDAzOTZdICBbPGZmZmZmZmZmODE4MzNiMzI+XSBjb21tb25faW50ZXJydXB0KzB4NzIv
MHg3MgpbICAgNjEuMDQwMzk2XSAgPEVPST4gIFs8ZmZmZmZmZmY4MTBiMDFkND5dID8gX193
YWtlX3VwKzB4MWQvMHg0OApbICAgNjEuMDQwMzk2XSAgWzxmZmZmZmZmZjgxMGNiMjNiPl0g
PyBhcmNoX2xvY2FsX2lycV9yZXN0b3JlKzB4Ni8weGQKWyAgIDYxLjA0MDM5Nl0gIFs8ZmZm
ZmZmZmY4MTgzMzE1MD5dIF9yYXdfc3Bpbl91bmxvY2tfaXJxcmVzdG9yZSsweDQ4LzB4NzUK
WyAgIDYxLjA0MDM5Nl0gIFs8ZmZmZmZmZmY4MTBiMDFmNj5dIF9fd2FrZV91cCsweDNmLzB4
NDgKWyAgIDYxLjA0MDM5Nl0gIFs8ZmZmZmZmZmY4MTRjODQyMz5dIG5hbmRfcmVsZWFzZV9k
ZXZpY2UuaXNyYS4xMysweDQ5LzB4NTgKWyAgIDYxLjA0MDM5Nl0gIFs8ZmZmZmZmZmY4MTRj
OTE1Yz5dIG5hbmRfcmVhZF9vb2IrMHgyNTcvMHgyNzAKWyAgIDYxLjA0MDM5Nl0gIFs8ZmZm
ZmZmZmY4MTRiMjEyMT5dIG10ZF9yZWFkX29vYisweDI2LzB4NGMKWyAgIDYxLjA0MDM5Nl0g
IFs8ZmZmZmZmZmY4MTRjYjZlOT5dIGNyZWF0ZV9iYnQrMHgyMjUvMHgyZDQKWyAgIDYxLjA0
MDM5Nl0gIFs8ZmZmZmZmZmY4MTRjYmNhMz5dIG5hbmRfc2Nhbl9iYnQrMHg4NS8weDRlMwpb
ICAgNjEuMDQwMzk2XSAgWzxmZmZmZmZmZjgxMTE3Mzk3Pl0gPyBfX2ttYWxsb2MrMHg5MC8w
eGJiClsgICA2MS4wNDAzOTZdICBbPGZmZmZmZmZmODE0Y2MxZTA+XSBuYW5kX2RlZmF1bHRf
YmJ0KzB4ZGYvMHhlNApbICAgNjEuMDQwMzk2XSAgWzxmZmZmZmZmZjgxZTEzMzcwPl0gbnNf
aW5pdF9tb2R1bGUrMHg1NzYvMHhkNjEKWyAgIDYxLjA0MDM5Nl0gIFs8ZmZmZmZmZmY4MTgz
MTU3Zj5dID8gbXV0ZXhfdW5sb2NrKzB4OS8weGIKWyAgIDYxLjA0MDM5Nl0gIFs8ZmZmZmZm
ZmY4MWUxMmRmYT5dID8gaW5pdF9uYW5kZG9jKzB4YzgvMHhjOApbICAgNjEuMDQwMzk2XSAg
WzxmZmZmZmZmZjgxZGU5ZGQ0Pl0gZG9fb25lX2luaXRjYWxsKzB4OGUvMHgxMzIKWyAgIDYx
LjA0MDM5Nl0gIFs8ZmZmZmZmZmY4MTBhNTVmNj5dID8gcGFyYW1lcSsweDFkLzB4MWYKWyAg
IDYxLjA0MDM5Nl0gIFs8ZmZmZmZmZmY4MTBhNTc4OT5dID8gcGFyc2VfYXJncysweDE5MS8w
eDI0NwpbICAgNjEuMDQwMzk2XSAgWzxmZmZmZmZmZjgxZGU5ZmNjPl0ga2VybmVsX2luaXRf
ZnJlZWFibGUrMHgxNTQvMHgxZDAKWyAgIDYxLjA0MDM5Nl0gIFs8ZmZmZmZmZmY4MWRlOTZk
YT5dID8gZG9fZWFybHlfcGFyYW0rMHg4OC8weDg4ClsgICA2MS4wNDAzOTZdICBbPGZmZmZm
ZmZmODE4MjM5OTk+XSA/IHJlc3RfaW5pdCsweGJkLzB4YmQKWyAgIDYxLjA0MDM5Nl0gIFs8
ZmZmZmZmZmY4MTgyMzlhMj5dIGtlcm5lbF9pbml0KzB4OS8weGNjClsgICA2MS4wNDAzOTZd
ICBbPGZmZmZmZmZmODE4MzQzYmM+XSByZXRfZnJvbV9mb3JrKzB4N2MvMHhiMApbICAgNjEu
MDQwMzk2XSAgWzxmZmZmZmZmZjgxODIzOTk5Pl0gPyByZXN0X2luaXQrMHhiZC8weGJkClsg
ICA2MS4wNDAzOTZdIC0tLVsgZW5kIHRyYWNlIDQwNDVjMDgyNmJhNDQxZDQgXS0tLQova2Vy
bmVsL3g4Nl82NC1yYW5kY29uZmlnLXgxLTA5MjgvOTJhM2U2NjFiZjU1NDU3MDkxODE3YzVj
MzQ2YzQzMTNiZTI1MDhhZi9kbWVzZy15b2N0by13YWltZWEtMTE6MjAxMzEwMDUyMTQ4MDE6
eDg2XzY0LXJhbmRjb25maWcteDEtMDkyODozLjExLjAtcmMyLTAwMDEzLWc5MmEzZTY2OjQw
Nwova2VybmVsL3g4Nl82NC1yYW5kY29uZmlnLXgxLTA5MjgvOTJhM2U2NjFiZjU1NDU3MDkx
ODE3YzVjMzQ2YzQzMTNiZTI1MDhhZi9kbWVzZy15b2N0by1sa3AtdHQwMi02OjIwMTMxMDA1
MDQxODE2Ong4Nl82NC1yYW5kY29uZmlnLXgxLTA5Mjg6My4xMS4wLXJjMi0wMDAxMy1nOTJh
M2U2Njo0MDcKCkJpc2VjdGluZzogMSByZXZpc2lvbiBsZWZ0IHRvIHRlc3QgYWZ0ZXIgdGhp
cyAocm91Z2hseSAxIHN0ZXApCls1OGIyNjdkM2UzZjNjZTg3YzNlNTU5ZTRjMzMwYzhjMDNl
OTA1ZjVlXSBkbWE6IGNvbnZlcnQgZG1hX2RldmNsYXNzIHRvIHVzZSBkZXZfZ3JvdXBzCnJ1
bm5pbmcgL2Mva2VybmVsLXRlc3RzL2Jpc2VjdC10ZXN0LWJvb3QtZmFpbHVyZS5zaCAvaG9t
ZS93ZmcvbW0vb2JqLWJpc2VjdApscyAtYSAva2VybmVsLXRlc3RzL3J1bi1xdWV1ZS9rdm0v
eDg2XzY0LXJhbmRjb25maWcteDEtMDkyOC9uZXh0Om1hc3Rlcjo1OGIyNjdkM2UzZjNjZTg3
YzNlNTU5ZTRjMzMwYzhjMDNlOTA1ZjVlOmJpc2VjdC1tbQoKMjAxMy0xMC0wNS0xMzo0OToy
MiA1OGIyNjdkM2UzZjNjZTg3YzNlNTU5ZTRjMzMwYzhjMDNlOTA1ZjVlIGNvbXBpbGluZwoy
MSByZWFsICAzNSB1c2VyICA3IHN5cyAgMTk1LjE0JSBjcHUgCXg4Nl82NC1yYW5kY29uZmln
LXgxLTA5MjgKCjIwMTMtMTAtMDUtMTM6NDk6NTUgZGV0ZWN0aW5nIGJvb3Qgc3RhdGUgMy4x
MS4wLXJjMi0wMDAxMS1nNThiMjY3ZAk5CTMzCTg3CTExOAkxNDEJMjA3CTI0OSBURVNUIEZB
SUxVUkUKL2Jpbi9zaDogL3Byb2Mvc2VsZi9mZC85OiBObyBzdWNoIGZpbGUgb3IgZGlyZWN0
b3J5ClsgICAgNC44ODYyMzBdIGlucHV0OiBJbUV4UFMvMiBHZW5lcmljIEV4cGxvcmVyIE1v
dXNlIGFzIC9kZXZpY2VzL3BsYXRmb3JtL2k4MDQyL3NlcmlvMS9pbnB1dC9pbnB1dDIKWyAg
ICA0Ljg4ODA0MV0gQlVHOiB1bmFibGUgdG8gaGFuZGxlIGtlcm5lbCBOVUxMIHBvaW50ZXIg
ZGVyZWZlcmVuY2UgYXQgMDAwMDAwMDAwMDAwMDAwOApbICAgIDQuODg5MjA3XSBJUDogWzxm
ZmZmZmZmZjgxMDk3YjI4Pl0gcnVuX3RpbWVyX3NvZnRpcnErMHgxMmMvMHgxYjgKWyAgICA0
Ljg5MDEyMF0gUEdEIDZhNjAwNjcgUFVEIDZhNWYwNjcgUE1EIDAgClsgICAgNC44OTA3ODNd
IE9vcHM6IDAwMDIgWyMxXSBQUkVFTVBUIFNNUCBERUJVR19QQUdFQUxMT0MKWyAgICA0Ljg5
MTYyNF0gQ1BVOiAwIFBJRDogMCBDb21tOiBzd2FwcGVyLzAgTm90IHRhaW50ZWQgMy4xMS4w
LXJjMi0wMDAxMS1nNThiMjY3ZCAjNDA4ClsgICAgNC44OTIwMjRdIHRhc2s6IGZmZmZmZmZm
ODFjMjQ0MDAgdGk6IGZmZmZmZmZmODFjMTYwMDAgdGFzay50aTogZmZmZmZmZmY4MWMxNjAw
MApbICAgIDQuODkyMDI0XSBSSVA6IDAwMTA6WzxmZmZmZmZmZjgxMDk3YjI4Pl0gIFs8ZmZm
ZmZmZmY4MTA5N2IyOD5dIHJ1bl90aW1lcl9zb2Z0aXJxKzB4MTJjLzB4MWI4ClsgICAgNC44
OTIwMjRdIFJTUDogMDAxODpmZmZmODgwMDBkYzAzZWYwICBFRkxBR1M6IDAwMDEwMDAyClsg
ICAgNC44OTIwMjRdIFJBWDogZmZmZjg4MDAwZGMwM2VmMCBSQlg6IGZmZmZmZmZmODFmMTY3
YzAgUkNYOiAwMDAwMDAwMDAwMDAwMDAyClsgICAgNC44OTIwMjRdIFJEWDogMDAwMDAwMDAw
MDAwMDAwMCBSU0k6IDAwMDAwMDAwMDAwMDAwMDAgUkRJOiBmZmZmZmZmZjgxZjE2N2MwClsg
ICAgNC44OTIwMjRdIFJCUDogZmZmZjg4MDAwZGMwM2YyOCBSMDg6IDAwMDAwMDAwMDAwMDAw
MDIgUjA5OiAwMDAwMDAwMDAwMDAwMDAxClsgICAgNC44OTIwMjRdIFIxMDogZmZmZmZmZmY4
MTA5N2I3NCBSMTE6IDAwMDAwMDAwMDAwMGI3ZjAgUjEyOiBmZmZmODgwMDA2ZGM3OGEwClsg
ICAgNC44OTIwMjRdIFIxMzogZmZmZjg4MDAwZGMwM2VmMCBSMTQ6IGZmZmZmZmZmODEwYTAx
ODIgUjE1OiBmZmZmODgwMDA2ZGM3ODYwClsgICAgNC44OTIwMjRdIEZTOiAgMDAwMDAwMDAw
MDAwMDAwMCgwMDAwKSBHUzpmZmZmODgwMDBkYzAwMDAwKDAwMDApIGtubEdTOjAwMDAwMDAw
MDAwMDAwMDAKWyAgICA0Ljg5MjAyNF0gQ1M6ICAwMDEwIERTOiAwMDAwIEVTOiAwMDAwIENS
MDogMDAwMDAwMDA4MDA1MDAzYgpbICAgIDQuODkyMDI0XSBDUjI6IDAwMDAwMDAwMDAwMDAw
MDggQ1IzOiAwMDAwMDAwMDA2OWY4MDAwIENSNDogMDAwMDAwMDAwMDAwMDZiMApbICAgIDQu
ODkyMDI0XSBTdGFjazoKWyAgICA0Ljg5MjAyNF0gIGZmZmY4ODAwMDZkYzc4YTAgZmZmZjg4
MDAwNmRjZDhhMCAwMDAwMDAwMDAwMDAwMDQxIGZmZmZmZmZmODFjMWIwODgKWyAgICA0Ljg5
MjAyNF0gIGZmZmZmZmZmODFjMTdmZDggMDAwMDAwMDAwMDAwMDAwYSAwMDAwMDAwMDAwMDAw
MTAxIGZmZmY4ODAwMGRjMDNmODAKWyAgICA0Ljg5MjAyNF0gIGZmZmZmZmZmODEwOTNmOTgg
MDAwMDAwMDAwMDAwMDAwMSAwMDAwMDAwMDAwMDAwMDAxIDAwMjAwMDAwMDAwMDAwMDAKWyAg
ICA0Ljg5MjAyNF0gQ2FsbCBUcmFjZToKWyAgICA0Ljg5MjAyNF0gIDxJUlE+IApbICAgIDQu
ODkyMDI0XSAgWzxmZmZmZmZmZjgxMDkzZjk4Pl0gX19kb19zb2Z0aXJxKzB4YzgvMHgxOGQK
WyAgICA0Ljg5MjAyNF0gIFs8ZmZmZmZmZmY4MTA5NDE3Mj5dIGlycV9leGl0KzB4NTYvMHg5
NwpbICAgIDQuODkyMDI0XSAgWzxmZmZmZmZmZjgxMDQzZjExPl0gc21wX2FwaWNfdGltZXJf
aW50ZXJydXB0KzB4MzAvMHgzYwpbICAgIDQuODkyMDI0XSAgWzxmZmZmZmZmZjgxODM1MGYy
Pl0gYXBpY190aW1lcl9pbnRlcnJ1cHQrMHg3Mi8weDgwClsgICAgNC44OTIwMjRdICA8RU9J
PiAKWyAgICA0Ljg5MjAyNF0gIFs8ZmZmZmZmZmY4MTBhYjM5ZT5dID8gbm90aWZpZXJfY2Fs
bF9jaGFpbisweDU5LzB4NTkKWyAgICA0Ljg5MjAyNF0gIFs8ZmZmZmZmZmY4MTBhYjM5ZT5d
ID8gbm90aWZpZXJfY2FsbF9jaGFpbisweDU5LzB4NTkKWyAgICA0Ljg5MjAyNF0gIFs8ZmZm
ZmZmZmY4MTA0OTFhZD5dID8gbmF0aXZlX3NhZmVfaGFsdCsweDYvMHg4ClsgICAgNC44OTIw
MjRdICBbPGZmZmZmZmZmODEwYzRhZWQ+XSA/IHRyYWNlX2hhcmRpcnFzX29uKzB4ZC8weGYK
WyAgICA0Ljg5MjAyNF0gIFs8ZmZmZmZmZmY4MTAyZmNjYz5dIGRlZmF1bHRfaWRsZSsweDEz
LzB4MWMKWyAgICA0Ljg5MjAyNF0gIFs8ZmZmZmZmZmY4MTAzMDNjZD5dIGFyY2hfY3B1X2lk
bGUrMHgxMy8weDIxClsgICAgNC44OTIwMjRdICBbPGZmZmZmZmZmODEwYmIzNzg+XSBjcHVf
c3RhcnR1cF9lbnRyeSsweDEwMS8weDE2MQpbICAgIDQuODkyMDI0XSAgWzxmZmZmZmZmZjgx
ODIzOTk1Pl0gcmVzdF9pbml0KzB4YjkvMHhiZApbICAgIDQuODkyMDI0XSAgWzxmZmZmZmZm
ZjgxODIzOGRjPl0gPyBjc3VtX3BhcnRpYWxfY29weV9nZW5lcmljKzB4MTZjLzB4MTZjClsg
ICAgNC44OTIwMjRdICBbPGZmZmZmZmZmODFkZTlkM2E+XSBzdGFydF9rZXJuZWwrMHg0MTYv
MHg0MjIKWyAgICA0Ljg5MjAyNF0gIFs8ZmZmZmZmZmY4MWRlOTczMj5dID8gcmVwYWlyX2Vu
dl9zdHJpbmcrMHg1OC8weDU4ClsgICAgNC44OTIwMjRdICBbPGZmZmZmZmZmODFkZTkxMjA+
XSA/IGVhcmx5X2lkdF9oYW5kbGVycysweDEyMC8weDEyMApbICAgIDQuODkyMDI0XSAgWzxm
ZmZmZmZmZjgxZGU5NDRjPl0geDg2XzY0X3N0YXJ0X3Jlc2VydmF0aW9ucysweDJhLzB4MmMK
WyAgICA0Ljg5MjAyNF0gIFs8ZmZmZmZmZmY4MWRlOTUyYT5dIHg4Nl82NF9zdGFydF9rZXJu
ZWwrMHhkYy8weGU5ClsgICAgNC44OTIwMjRdIENvZGU6IDhiIDY1IGM4IDRkIDM5IGVjIDBm
IDg0IDJmIGZmIGZmIGZmIDQxIDhiIDRjIDI0IDE4IDRkIDhiIDc0IDI0IDIwIDRkIDhiIDdj
IDI0IDI4IDRjIDg5IDYzIDM4IDQ5IDhiIDQ0IDI0IDA4IDQ5IDhiIDE0IDI0IDgzIGUxIDAy
IDw0OD4gODkgNDIgMDggNDggODkgMTAgNDggYjggMDAgMDIgMjAgMDAgMDAgMDAgYWQgZGUg
NDEgZjYgNDQgMjQgClsgICAgNC44OTIwMjRdIFJJUCAgWzxmZmZmZmZmZjgxMDk3YjI4Pl0g
cnVuX3RpbWVyX3NvZnRpcnErMHgxMmMvMHgxYjgKWyAgICA0Ljg5MjAyNF0gIFJTUCA8ZmZm
Zjg4MDAwZGMwM2VmMD4KWyAgICA0Ljg5MjAyNF0gQ1IyOiAwMDAwMDAwMDAwMDAwMDA4Clsg
ICAgNC44OTIwMjRdIC0tLVsgZW5kIHRyYWNlIDk4YzhiZmJmMDE3OGZmODggXS0tLQova2Vy
bmVsL3g4Nl82NC1yYW5kY29uZmlnLXgxLTA5MjgvNThiMjY3ZDNlM2YzY2U4N2MzZTU1OWU0
YzMzMGM4YzAzZTkwNWY1ZS9kbWVzZy15b2N0by1sa3Atc3QwMS0xMDoyMDEzMTAwNTEzNTI1
MTp4ODZfNjQtcmFuZGNvbmZpZy14MS0wOTI4OjMuMTEuMC1yYzItMDAwMTEtZzU4YjI2N2Q6
NDA4Ci9rZXJuZWwveDg2XzY0LXJhbmRjb25maWcteDEtMDkyOC81OGIyNjdkM2UzZjNjZTg3
YzNlNTU5ZTRjMzMwYzhjMDNlOTA1ZjVlL2RtZXNnLXlvY3RvLWlubi0zNDoyMDEzMTAwNTEz
NTMwNzp4ODZfNjQtcmFuZGNvbmZpZy14MS0wOTI4OjMuMTEuMC1yYzItMDAwMTEtZzU4YjI2
N2Q6NDA4CgpCaXNlY3Rpbmc6IDAgcmV2aXNpb25zIGxlZnQgdG8gdGVzdCBhZnRlciB0aGlz
IChyb3VnaGx5IDAgc3RlcHMpCltjODE3YTY3ZWNiYTdjM2MyYWFhMTA0Nzk2ZDc4ZjE2MGFm
NjA5MjBkXSBrb2JqZWN0OiBkZWxheWVkIGtvYmplY3QgcmVsZWFzZTogaGVscCBmaW5kIGJ1
Z2d5IGRyaXZlcnMKcnVubmluZyAvYy9rZXJuZWwtdGVzdHMvYmlzZWN0LXRlc3QtYm9vdC1m
YWlsdXJlLnNoIC9ob21lL3dmZy9tbS9vYmotYmlzZWN0CmxzIC1hIC9rZXJuZWwtdGVzdHMv
cnVuLXF1ZXVlL2t2bS94ODZfNjQtcmFuZGNvbmZpZy14MS0wOTI4L25leHQ6bWFzdGVyOmM4
MTdhNjdlY2JhN2MzYzJhYWExMDQ3OTZkNzhmMTYwYWY2MDkyMGQ6YmlzZWN0LW1tCgoyMDEz
LTEwLTA1LTEzOjUzOjI4IGM4MTdhNjdlY2JhN2MzYzJhYWExMDQ3OTZkNzhmMTYwYWY2MDky
MGQgY29tcGlsaW5nCjIyIHJlYWwgIDM3IHVzZXIgIDcgc3lzICAxOTkuMTIlIGNwdSAJeDg2
XzY0LXJhbmRjb25maWcteDEtMDkyOAoKMjAxMy0xMC0wNS0xMzo1NDowMiBkZXRlY3Rpbmcg
Ym9vdCBzdGF0ZSAzLjExLjAtcmMyLTAwMDEwLWdjODE3YTY3CTI4CTcwCTk1CTEzNwkxODkJ
MjAwCTIzOQkzMDYJMzEyCTM2MQkzOTgJNDQ1IFRFU1QgRkFJTFVSRQobWzE7MzVtSW5jcmVh
c2luZyByZXBlYXQgY291bnQgZnJvbSAyMTQwIHRvIDQzODUbWzBtClsgICA4MS43NzE3NzRd
IFNjYW5uaW5nIGRldmljZSBmb3IgYmFkIGJsb2NrcwpbICAgODIuNDQ4OTk3XSAtLS0tLS0t
LS0tLS1bIGN1dCBoZXJlIF0tLS0tLS0tLS0tLS0KWyAgIDgyLjQ1MDc4NV0gV0FSTklORzog
Q1BVOiAwIFBJRDogMSBhdCAvYy93ZmcvbW0va2VybmVsL3dvcmtxdWV1ZS5jOjU5MCBzZXRf
d29ya19kYXRhKzB4MzMvMHg1MCgpClsgICA4Mi40NTI0MjFdIENQVTogMCBQSUQ6IDEgQ29t
bTogc3dhcHBlci8wIE5vdCB0YWludGVkIDMuMTEuMC1yYzItMDAwMTAtZ2M4MTdhNjcgIzQw
OQpbICAgODIuNDUyNDIxXSAgMDAwMDAwMDAwMDAwMDAwMCBmZmZmODgwMDBkYzAzZDgwIGZm
ZmZmZmZmODE4MjliY2YgMDAwMDAwMDAwMDAwMDAwMApbICAgODIuNDUyNDIxXSAgZmZmZjg4
MDAwZGMwM2RiOCBmZmZmZmZmZjgxMDhkZjZhIGZmZmZmZmZmODEwOWYyNDAgZmZmZjg4MDAw
NmNkMDg2MApbICAgODIuNDUyNDIxXSAgZmZmZjg4MDAwZGMxMzQwMCAwMDAwMDAwMDAwMDAw
MDA1IGZmZmY4ODAwMGRjMTE3YzAgZmZmZjg4MDAwZGMwM2RjOApbICAgODIuNDUyNDIxXSBD
YWxsIFRyYWNlOgpbICAgODIuNDUyNDIxXSAgPElSUT4gIFs8ZmZmZmZmZmY4MTgyOWJjZj5d
IGR1bXBfc3RhY2srMHg0ZS8weDgyClsgICA4Mi40NTI0MjFdICBbPGZmZmZmZmZmODEwOGRm
NmE+XSB3YXJuX3Nsb3dwYXRoX2NvbW1vbisweDcwLzB4ODkKWyAgIDgyLjQ1MjQyMV0gIFs8
ZmZmZmZmZmY4MTA5ZjI0MD5dID8gc2V0X3dvcmtfZGF0YSsweDMzLzB4NTAKWyAgIDgyLjQ1
MjQyMV0gIFs8ZmZmZmZmZmY4MTA4ZTA0NT5dIHdhcm5fc2xvd3BhdGhfbnVsbCsweDE1LzB4
MTcKWyAgIDgyLjQ1MjQyMV0gIFs8ZmZmZmZmZmY4MTA5ZjI0MD5dIHNldF93b3JrX2RhdGEr
MHgzMy8weDUwClsgICA4Mi40NTI0MjFdICBbPGZmZmZmZmZmODEwOWZmNTY+XSBpbnNlcnRf
d29yaysweDI3LzB4NjUKWyAgIDgyLjQ1MjQyMV0gIFs8ZmZmZmZmZmY4MTBhMDE2Mz5dIF9f
cXVldWVfd29yaysweDFjZi8weDFlZQpbICAgODIuNDUyNDIxXSAgWzxmZmZmZmZmZjgxMGEw
MTgyPl0gPyBfX3F1ZXVlX3dvcmsrMHgxZWUvMHgxZWUKWyAgIDgyLjQ1MjQyMV0gIFs8ZmZm
ZmZmZmY4MTBhMDE5Yj5dIGRlbGF5ZWRfd29ya190aW1lcl9mbisweDE5LzB4MWIKWyAgIDgy
LjQ1MjQyMV0gIFs8ZmZmZmZmZmY4MTA5NzQ2MD5dIGNhbGxfdGltZXJfZm4rMHg2Yy8weGRm
ClsgICA4Mi40NTI0MjFdICBbPGZmZmZmZmZmODEwOTczZjQ+XSA/IHByb2Nlc3NfdGltZW91
dCsweGIvMHhiClsgICA4Mi40NTI0MjFdICBbPGZmZmZmZmZmODEwYTAxODI+XSA/IF9fcXVl
dWVfd29yaysweDFlZS8weDFlZQpbICAgODIuNDUyNDIxXSAgWzxmZmZmZmZmZjgxMDk3YjZj
Pl0gcnVuX3RpbWVyX3NvZnRpcnErMHgxNzAvMHgxYjgKWyAgIDgyLjQ1MjQyMV0gIFs8ZmZm
ZmZmZmY4MTA5M2Y5OD5dIF9fZG9fc29mdGlycSsweGM4LzB4MThkClsgICA4Mi40NTI0MjFd
ICBbPGZmZmZmZmZmODEwOTQxNzI+XSBpcnFfZXhpdCsweDU2LzB4OTcKWyAgIDgyLjQ1MjQy
MV0gIFs8ZmZmZmZmZmY4MTAyYTJiYj5dIGRvX0lSUSsweDg4LzB4OWYKWyAgIDgyLjQ1MjQy
MV0gIFs8ZmZmZmZmZmY4MTgzM2IzMj5dIGNvbW1vbl9pbnRlcnJ1cHQrMHg3Mi8weDcyClsg
ICA4Mi40NTI0MjFdICA8RU9JPiAgWzxmZmZmZmZmZjgxNjNkM2NkPl0gPyBsZWRfdHJpZ2dl
cl9ldmVudCsweDI2LzB4NTQKWyAgIDgyLjQ1MjQyMV0gIFs8ZmZmZmZmZmY4MTBjMzBjZT5d
ID8gYXJjaF9sb2NhbF9pcnFfcmVzdG9yZSsweDYvMHhkClsgICA4Mi40NTI0MjFdICBbPGZm
ZmZmZmZmODEwYzY3NjM+XSBsb2NrX2FjcXVpcmUrMHg5NC8weDlkClsgICA4Mi40NTI0MjFd
ICBbPGZmZmZmZmZmODE2M2QzY2Q+XSA/IGxlZF90cmlnZ2VyX2V2ZW50KzB4MjYvMHg1NApb
ICAgODIuNDUyNDIxXSAgWzxmZmZmZmZmZjgxODMzMmJlPl0gX3Jhd19yZWFkX2xvY2srMHgz
Ni8weDQyClsgICA4Mi40NTI0MjFdICBbPGZmZmZmZmZmODE2M2QzY2Q+XSA/IGxlZF90cmln
Z2VyX2V2ZW50KzB4MjYvMHg1NApbICAgODIuNDUyNDIxXSAgWzxmZmZmZmZmZjgxNjNkM2Nk
Pl0gbGVkX3RyaWdnZXJfZXZlbnQrMHgyNi8weDU0ClsgICA4Mi40NTI0MjFdICBbPGZmZmZm
ZmZmODE0Yzg4NGY+XSBuYW5kX3dhaXRfcmVhZHkrMHhhOS8weGIyClsgICA4Mi40NTI0MjFd
ICBbPGZmZmZmZmZmODE0Yzg5ZGI+XSBuYW5kX2NvbW1hbmQrMHgxODMvMHgxOGUKWyAgIDgy
LjQ1MjQyMV0gIFs8ZmZmZmZmZmY4MTRjNmZmND5dIG5hbmRfcmVhZF9vb2Jfc3RkKzB4MTkv
MHgzMgpbICAgODIuNDUyNDIxXSAgWzxmZmZmZmZmZjgxNGM5MDViPl0gbmFuZF9yZWFkX29v
YisweDE1Ni8weDI3MApbICAgODIuNDUyNDIxXSAgWzxmZmZmZmZmZjgxNGIyMTIxPl0gbXRk
X3JlYWRfb29iKzB4MjYvMHg0YwpbICAgODIuNDUyNDIxXSAgWzxmZmZmZmZmZjgxNGNiNmU5
Pl0gY3JlYXRlX2JidCsweDIyNS8weDJkNApbICAgODIuNDUyNDIxXSAgWzxmZmZmZmZmZjgx
NGNiY2EzPl0gbmFuZF9zY2FuX2JidCsweDg1LzB4NGUzClsgICA4Mi40NTI0MjFdICBbPGZm
ZmZmZmZmODExMTczOTc+XSA/IF9fa21hbGxvYysweDkwLzB4YmIKWyAgIDgyLjQ1MjQyMV0g
IFs8ZmZmZmZmZmY4MTRjYzFlMD5dIG5hbmRfZGVmYXVsdF9iYnQrMHhkZi8weGU0ClsgICA4
Mi40NTI0MjFdICBbPGZmZmZmZmZmODFlMTMzNzA+XSBuc19pbml0X21vZHVsZSsweDU3Ni8w
eGQ2MQpbICAgODIuNDUyNDIxXSAgWzxmZmZmZmZmZjgxODMxNTdmPl0gPyBtdXRleF91bmxv
Y2srMHg5LzB4YgpbICAgODIuNDUyNDIxXSAgWzxmZmZmZmZmZjgxZTEyZGZhPl0gPyBpbml0
X25hbmRkb2MrMHhjOC8weGM4ClsgICA4Mi40NTI0MjFdICBbPGZmZmZmZmZmODFkZTlkZDQ+
XSBkb19vbmVfaW5pdGNhbGwrMHg4ZS8weDEzMgpbICAgODIuNDUyNDIxXSAgWzxmZmZmZmZm
ZjgxMGIwMjAwPl0gPyBfX3dha2VfdXBfbG9ja2VkKzB4MS8weDEwClsgICA4Mi40NTI0MjFd
ICBbPGZmZmZmZmZmODEwYjAyZTI+XSA/IGNvbXBsZXRlX2FsbCsweDE4LzB4NDkKWyAgIDgy
LjQ1MjQyMV0gIFs8ZmZmZmZmZmY4MWRmOTQ1OT5dID8gaW5pdCsweDYwLzB4NjAKWyAgIDgy
LjQ1MjQyMV0gIFs8ZmZmZmZmZmY4MWRlOWZjYz5dIGtlcm5lbF9pbml0X2ZyZWVhYmxlKzB4
MTU0LzB4MWQwClsgICA4Mi40NTI0MjFdICBbPGZmZmZmZmZmODFkZTk2ZGE+XSA/IGRvX2Vh
cmx5X3BhcmFtKzB4ODgvMHg4OApbICAgODIuNDUyNDIxXSAgWzxmZmZmZmZmZjgxODIzOTk5
Pl0gPyByZXN0X2luaXQrMHhiZC8weGJkClsgICA4Mi40NTI0MjFdICBbPGZmZmZmZmZmODE4
MjM5YTI+XSBrZXJuZWxfaW5pdCsweDkvMHhjYwpbICAgODIuNDUyNDIxXSAgWzxmZmZmZmZm
ZjgxODM0M2JjPl0gcmV0X2Zyb21fZm9yaysweDdjLzB4YjAKWyAgIDgyLjQ1MjQyMV0gIFs8
ZmZmZmZmZmY4MTgyMzk5OT5dID8gcmVzdF9pbml0KzB4YmQvMHhiZApbICAgODIuNDUyNDIx
XSAtLS1bIGVuZCB0cmFjZSA2MjJjZGQzODRjNmRmNmU2IF0tLS0KL2tlcm5lbC94ODZfNjQt
cmFuZGNvbmZpZy14MS0wOTI4L2M4MTdhNjdlY2JhN2MzYzJhYWExMDQ3OTZkNzhmMTYwYWY2
MDkyMGQvZG1lc2ctcXVhbnRhbC13YWltZWEtMTA6MjAxMzEwMDUyMTU4NDI6eDg2XzY0LXJh
bmRjb25maWcteDEtMDkyODozLjExLjAtcmMyLTAwMDEwLWdjODE3YTY3OjQwOQoKYzgxN2E2
N2VjYmE3YzNjMmFhYTEwNDc5NmQ3OGYxNjBhZjYwOTIwZCBpcyB0aGUgZmlyc3QgYmFkIGNv
bW1pdApjb21taXQgYzgxN2E2N2VjYmE3YzNjMmFhYTEwNDc5NmQ3OGYxNjBhZjYwOTIwZApB
dXRob3I6IFJ1c3NlbGwgS2luZyA8cm1rK2tlcm5lbEBhcm0ubGludXgub3JnLnVrPgpEYXRl
OiAgIFRodSBKdW4gMjcgMTU6MDY6MTQgMjAxMyArMDEwMAoKICAgIGtvYmplY3Q6IGRlbGF5
ZWQga29iamVjdCByZWxlYXNlOiBoZWxwIGZpbmQgYnVnZ3kgZHJpdmVycwogICAgCiAgICBJ
bXBsZW1lbnQgZGVidWdnaW5nIGZvciBrb2JqZWN0IHJlbGVhc2UgZnVuY3Rpb25zLiAga29i
amVjdHMgYXJlCiAgICByZWZlcmVuY2UgY291bnRlZCwgc28gdGhlIGRyb3Agb2YgdGhlIGxh
c3QgcmVmZXJlbmNlIHRvIHRoZW0gaXMgbm90CiAgICBwcmVkaWN0YWJsZS4gSG93ZXZlciwg
dGhlIGNvbW1vbiBjYXNlIGlzIGZvciB0aGUgbGFzdCByZWZlcmVuY2UgdG8gYmUKICAgIHRo
ZSBrb2JqZWN0J3MgcmVtb3ZhbCBmcm9tIGEgc3Vic3lzdGVtLCB3aGljaCByZXN1bHRzIGlu
IHRoZSByZWxlYXNlCiAgICBmdW5jdGlvbiBiZWluZyBpbW1lZGlhdGVseSBjYWxsZWQuCiAg
ICAKICAgIFRoaXMgY2FuIGhpZGUgc3VidGxlIGJ1Z3MsIHdoaWNoIGNhbiBvY2N1ciB3aGVu
IGFub3RoZXIgdGhyZWFkIGhvbGRzIGEKICAgIHJlZmVyZW5jZSB0byB0aGUga29iamVjdCBh
dCB0aGUgc2FtZSB0aW1lIHRoYXQgYSBrb2JqZWN0IGlzIHJlbW92ZWQuCiAgICBUaGlzIHJl
c3VsdHMgaW4gdGhlIHJlbGVhc2UgbWV0aG9kIGJlaW5nIGRlbGF5ZWQuCiAgICAKICAgIElu
IG9yZGVyIHRvIG1ha2UgdGhlc2Uga2luZHMgb2YgcHJvYmxlbXMgbW9yZSB2aXNpYmxlLCB0
aGUgZm9sbG93aW5nCiAgICBwYXRjaCBpbXBsZW1lbnRzIGEgZGVsYXllZCByZWxlYXNlOyB0
aGlzIGhhcyB0aGUgZWZmZWN0IHRoYXQgdGhlCiAgICByZWxlYXNlIGZ1bmN0aW9uIHdpbGwg
YmUgb3V0IG9mIG9yZGVyIHdpdGggcmVzcGVjdCB0byB0aGUgcmVtb3ZhbCBvZgogICAgdGhl
IGtvYmplY3QgaW4gdGhlIHNhbWUgbWFubmVyIHRoYXQgaXQgd291bGQgYmUgaWYgYSByZWZl
cmVuY2Ugd2FzCiAgICBiZWluZyBoZWxkLgogICAgCiAgICBUaGlzIHByb3ZpZGVzIHVzIHdp
dGggYW4gZWFzeSB3YXkgdG8gYWxsb3cgZHJpdmVyIHdyaXRlcnMgdG8gZGVidWcKICAgIHRo
ZWlyIGRyaXZlcnMgYW5kIGZpeCBvdGhlcndpc2UgaGlkZGVuIHByb2JsZW1zLgogICAgCiAg
ICBTaWduZWQtb2ZmLWJ5OiBSdXNzZWxsIEtpbmcgPHJtaytrZXJuZWxAYXJtLmxpbnV4Lm9y
Zy51az4KICAgIFNpZ25lZC1vZmYtYnk6IEdyZWcgS3JvYWgtSGFydG1hbiA8Z3JlZ2toQGxp
bnV4Zm91bmRhdGlvbi5vcmc+Cgo6MDQwMDAwIDA0MDAwMCBmNmMyM2VmYTEwMmZjMmMyZWFk
NWM4NmJkYjY1YWE3MDcxOWIxYWI5IDA0OTg1OWZhN2EzYTk1Mzg5MjEyNzQ2N2JhYmJmMDJm
NjZhNjliNzYgTQlpbmNsdWRlCjowNDAwMDAgMDQwMDAwIGE0MWQyMDY2OWYwZjYyNGQyY2U5
Y2E3ZTZhNWY5NmU0ZjkxNDMyZTAgYmYyMTY4MTk0ZjgyOTExY2YyZTE4OTJkODJmMGMxM2Qw
MGM3NzJhZSBNCWxpYgpiaXNlY3QgcnVuIHN1Y2Nlc3MKbHMgLWEgL2tlcm5lbC10ZXN0cy9y
dW4tcXVldWUva3ZtL3g4Nl82NC1yYW5kY29uZmlnLXgxLTA5MjgvbmV4dDptYXN0ZXI6N2M0
MjcyMWZlMGM1OGE4NDg4NDliNDNmZjU1OGNmMmZiODZhYTM1YTpiaXNlY3QtbW0KCjIwMTMt
MTAtMDUtMTQ6MDA6MDYgN2M0MjcyMWZlMGM1OGE4NDg4NDliNDNmZjU1OGNmMmZiODZhYTM1
YSByZXVzZSAva2VybmVsL3g4Nl82NC1yYW5kY29uZmlnLXgxLTA5MjgvN2M0MjcyMWZlMGM1
OGE4NDg4NDliNDNmZjU1OGNmMmZiODZhYTM1YS92bWxpbnV6LTMuMTEuMC1yYzItMDAwMDkt
ZzdjNDI3MjEKG1sxOzM1bWFkZF90b19ydW5fcXVldWU6IHJlcXVlc3RlZCA3ODYwLCBsaW1p
dCB0byA1MDAwG1swbQoKMjAxMy0xMC0wNS0xNDowMDoxMiBkZXRlY3RpbmcgYm9vdCBzdGF0
ZSAuLgkyMTQzLi4uLi4uLi4uLi4uLi4uCTIyMzQJMjM2OC4uLi4uCTIzODEJMjY0MwkyNzM5
Li4uLi4uLi4uLgkyOTQ0CTMwOTYuLi4uLi4JMzEwNAkzMzQwLi4uLgkzNTU0CTM1NTguLi4J
MzU2MAkzODM0CTQwMzEuCTQxNzIJNDM3MQk0NDAzCTQ0MjcJNDQzNAk0NTI2CTQ1OTMJNDY0
MQk0Njg5CTQ3MzQJNDc2NAk0ODEzCTQ4NjMJNDkwNAk0OTY0CTQ5OTQJNTA1OQk1MTAwCTUx
MzUJNTE3Nwk1MjI3CTUyNzUJNTMxNgk1Mzc5CTU0NTIJNTUwMQk1NTcxCTU2NTMJNTcwMgk1
NzU3CTU4MDkJNTg2Nwk1OTA1CTU5NDAJNTk4Nwk2MDMyCTYwNzEJNjEwNwk2MTU2CTYxODQJ
NjI0Ngk2MjY2CTYyOTAJNjM0Ngk2MzgwCTY0MTkJNjQ2NQk2NTA2CTY1NDAJNjU4Ngk2NjMy
CTY2NjkJNjcxNwk2NzUwCTY3OTMJNjg0Mwk2OTEwCTY5NjUJNzAwMQk3MDQ3Li4uLi4uLi4u
Li4uLi4JNzEyMAk3MTQwLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4u
Li4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4u
Li4uLi4uLi4uLi4uLi4uLi4uLgk3MTQyLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4u
Li4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4u
Li4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4JNzE1My4uLi4JNzE1NC4uLi4uLi4uLi4u
Li4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4u
Li4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4u
Li4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uCTcxNTYJNzE2Mi4u
Li4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4u
Li4uLi4JNzE3MC4uLgk3MTcxLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4u
Li4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4u
Li4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4u
Li4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4u
Li4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4u
Li4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLhtbMTsz
NW1hZGRfdG9fcnVuX3F1ZXVlIDI4MjkbWzBtCi4uLi4uCTczNjcJNzQ3MS4JNzcwNgk3ODYz
CTc4ODkJODE2My4JODQxMQk4NDEyCTg2MTgJODc2NAk4NzkxCTg5NDUJOTEwMwk5MjEyLgk5
Mzk3Lgk5NDg3CTk1ODIJOTYyNS4JOTcxNwk5ODEyCTk5MTUJMTAwMDAgU1VDQ0VTUwoKbHMg
LWEgL2tlcm5lbC10ZXN0cy9ydW4tcXVldWUva3ZtL3g4Nl82NC1yYW5kY29uZmlnLXgxLTA5
MjgvbmV4dDptYXN0ZXI6YTBjZjFhYmMyNWFjMTk3ZGQ5N2I4NTdjMGY2MzQxMDY2YThjYjFj
ZjpiaXNlY3QtbW0KCjIwMTMtMTAtMDUtMjE6NDY6MzMgYTBjZjFhYmMyNWFjMTk3ZGQ5N2I4
NTdjMGY2MzQxMDY2YThjYjFjZiByZXVzZSAva2VybmVsL3g4Nl82NC1yYW5kY29uZmlnLXgx
LTA5MjgvYTBjZjFhYmMyNWFjMTk3ZGQ5N2I4NTdjMGY2MzQxMDY2YThjYjFjZi92bWxpbnV6
LTMuMTIuMC1yYzItbmV4dC0yMDEzMDkyNy0wMzEwMC1nYTBjZjFhYgobWzE7MzVtYWRkX3Rv
X3J1bl9xdWV1ZTogcmVxdWVzdGVkIDEwMDAwLCBsaW1pdCB0byA1MDAwG1swbQoKMjAxMy0x
MC0wNS0yMTo0NjozOCBkZXRlY3RpbmcgYm9vdCBzdGF0ZSAuCTU1IFRFU1QgRkFJTFVSRQpb
ICAgMzIuOTUyNTkwXSBTY2FubmluZyBkZXZpY2UgZm9yIGJhZCBibG9ja3MKWyAgIDMzLjc5
NjQ0MF0gLS0tLS0tLS0tLS0tWyBjdXQgaGVyZSBdLS0tLS0tLS0tLS0tClsgICAzMy43OTc5
MzFdIFdBUk5JTkc6IENQVTogMCBQSUQ6IDEgYXQga2VybmVsL3dvcmtxdWV1ZS5jOjYwMyBz
ZXRfd29ya19kYXRhKzB4MzMvMHg1MCgpClsgICAzMy43OTkxNzhdIENQVTogMCBQSUQ6IDEg
Q29tbTogc3dhcHBlci8wIE5vdCB0YWludGVkIDMuMTIuMC1yYzItbmV4dC0yMDEzMDkyNy0w
MzEwMC1nYTBjZjFhYiAjMjQKWyAgIDMzLjgwMDE4NF0gIGZmZmZmZmZmODEwYzNhNzkgZmZm
Zjg4MDAwZjAwM2Q5MCBmZmZmZmZmZjgxODU1NjA2IDAwMDAwMDAwMDAwMDAwMDAKWyAgIDMz
LjgwMDE4NF0gIGZmZmY4ODAwMGYwMDNkYzggZmZmZmZmZmY4MTA5N2RmZCBmZmZmZmZmZjgx
MGE2NzRlIGZmZmY4ODAwMGNjN2Y4NjAKWyAgIDMzLjgwMDE4NF0gIGZmZmY4ODAwMGYwMTM0
MDAgMDAwMDAwMDAwMDAwMDAwNSBmZmZmODgwMDBmMDExNjQwIGZmZmY4ODAwMGYwMDNkZDgK
WyAgIDMzLjgwMDE4NF0gQ2FsbCBUcmFjZToKWyAgIDMzLjgwMDE4NF0gIDxJUlE+ICBbPGZm
ZmZmZmZmODEwYzNhNzk+XSA/IGNvbnNvbGVfdW5sb2NrKzB4MzEyLzB4MzViClsgICAzMy44
MDAxODRdICBbPGZmZmZmZmZmODE4NTU2MDY+XSBkdW1wX3N0YWNrKzB4NGUvMHg3YQpbICAg
MzMuODAwMTg0XSAgWzxmZmZmZmZmZjgxMDk3ZGZkPl0gd2Fybl9zbG93cGF0aF9jb21tb24r
MHg3MC8weDg5ClsgICAzMy44MDAxODRdICBbPGZmZmZmZmZmODEwYTY3NGU+XSA/IHNldF93
b3JrX2RhdGErMHgzMy8weDUwClsgICAzMy44MDAxODRdICBbPGZmZmZmZmZmODEwOTdlZDg+
XSB3YXJuX3Nsb3dwYXRoX251bGwrMHgxNS8weDE3ClsgICAzMy44MDAxODRdICBbPGZmZmZm
ZmZmODEwYTY3NGU+XSBzZXRfd29ya19kYXRhKzB4MzMvMHg1MApbICAgMzMuODAwMTg0XSAg
WzxmZmZmZmZmZjgxMGE3NDYwPl0gaW5zZXJ0X3dvcmsrMHgyNy8weDY1ClsgICAzMy44MDAx
ODRdICBbPGZmZmZmZmZmODEwYTc2NmQ+XSBfX3F1ZXVlX3dvcmsrMHgxY2YvMHgxZWUKWyAg
IDMzLjgwMDE4NF0gIFs8ZmZmZmZmZmY4MTBhNzY4Yz5dID8gX19xdWV1ZV93b3JrKzB4MWVl
LzB4MWVlClsgICAzMy44MDAxODRdICBbPGZmZmZmZmZmODEwYTc2OGM+XSA/IF9fcXVldWVf
d29yaysweDFlZS8weDFlZQpbICAgMzMuODAwMTg0XSAgWzxmZmZmZmZmZjgxMGE3NmE1Pl0g
ZGVsYXllZF93b3JrX3RpbWVyX2ZuKzB4MTkvMHgxYgpbICAgMzMuODAwMTg0XSAgWzxmZmZm
ZmZmZjgxMDllOGRkPl0gY2FsbF90aW1lcl9mbisweDY3LzB4ZDQKWyAgIDMzLjgwMDE4NF0g
IFs8ZmZmZmZmZmY4MTA5ZTg3Nj5dID8gcHJvY2Vzc190aW1lb3V0KzB4Yi8weGIKWyAgIDMz
LjgwMDE4NF0gIFs8ZmZmZmZmZmY4MTA5ZWZkYz5dIHJ1bl90aW1lcl9zb2Z0aXJxKzB4MTcw
LzB4MWI4ClsgICAzMy44MDAxODRdICBbPGZmZmZmZmZmODEwOWI0MTU+XSBfX2RvX3NvZnRp
cnErMHhjNi8weDE5NgpbICAgMzMuODAwMTg0XSAgWzxmZmZmZmZmZjgxMDliNWVlPl0gaXJx
X2V4aXQrMHg1MC8weDg2ClsgICAzMy44MDAxODRdICBbPGZmZmZmZmZmODEwMmI3YWE+XSBk
b19JUlErMHg4OC8weDlmClsgICAzMy44MDAxODRdICBbPGZmZmZmZmZmODE4NjA1YjI+XSBj
b21tb25faW50ZXJydXB0KzB4NzIvMHg3MgpbICAgMzMuODAwMTg0XSAgPEVPST4gIFs8ZmZm
ZmZmZmY4MTRlNGNlMT5dID8gbmFuZF9nZXRfZGV2aWNlLmlzcmEuMTUrMHg0ZC8weGY1Clsg
ICAzMy44MDAxODRdICBbPGZmZmZmZmZmODE0ZTRjZTE+XSA/IG5hbmRfZ2V0X2RldmljZS5p
c3JhLjE1KzB4NGQvMHhmNQpbICAgMzMuODAwMTg0XSAgWzxmZmZmZmZmZjgxMGI3MzM5Pl0g
PyBwcmVlbXB0X2NvdW50X2FkZCsweDU2LzB4NTYKWyAgIDMzLjgwMDE4NF0gIFs8ZmZmZmZm
ZmY4MTg1ZmFjYj5dID8gX3Jhd19zcGluX3VubG9jaysweDJjLzB4NDAKWyAgIDMzLjgwMDE4
NF0gIFs8ZmZmZmZmZmY4MTRlNGQzNj5dIG5hbmRfZ2V0X2RldmljZS5pc3JhLjE1KzB4YTIv
MHhmNQpbICAgMzMuODAwMTg0XSAgWzxmZmZmZmZmZjgxMGI4YWUyPl0gPyB3YWtlX3VwX3N0
YXRlKzB4ZC8weGQKWyAgIDMzLjgwMDE4NF0gIFs8ZmZmZmZmZmY4MTRlNTk1Mj5dIG5hbmRf
cmVhZF9vb2IrMHg1NS8weDI3MApbICAgMzMuODAwMTg0XSAgWzxmZmZmZmZmZjgxODYwNjc3
Pl0gPyByZXRpbnRfcmVzdG9yZV9hcmdzKzB4MTMvMHgxMwpbICAgMzMuODAwMTg0XSAgWzxm
ZmZmZmZmZjgxNGNlOWJiPl0gbXRkX3JlYWRfb29iKzB4MjYvMHg0YwpbICAgMzMuODAwMTg0
XSAgWzxmZmZmZmZmZjgxNGU4NWIxPl0gY3JlYXRlX2JidCsweDIwZi8weDI5YQpbICAgMzMu
ODAwMTg0XSAgWzxmZmZmZmZmZjgxNGU4NmJiPl0gbmFuZF9zY2FuX2JidCsweDdmLzB4NGRk
ClsgICAzMy44MDAxODRdICBbPGZmZmZmZmZmODEwOTgwMDk+XSA/IHB1dF9vbmxpbmVfY3B1
cysweDI0LzB4NmIKWyAgIDMzLjgwMDE4NF0gIFs8ZmZmZmZmZmY4MTRlOGJmOD5dIG5hbmRf
ZGVmYXVsdF9iYnQrMHhkZi8weGU0ClsgICAzMy44MDAxODRdICBbPGZmZmZmZmZmODFlNTc3
Njk+XSBuc19pbml0X21vZHVsZSsweDU2Yy8weGQyOApbICAgMzMuODAwMTg0XSAgWzxmZmZm
ZmZmZjgxMjJmMWJkPl0gPyBmcmVlX3JzKzB4NzUvMHg3OApbICAgMzMuODAwMTg0XSAgWzxm
ZmZmZmZmZjgxZTU3MWZkPl0gPyBuZnRsX3NjYW5fYmJ0KzB4MzEyLzB4MzEyClsgICAzMy44
MDAxODRdICBbPGZmZmZmZmZmODFlMmRkZDQ+XSBkb19vbmVfaW5pdGNhbGwrMHg4ZS8weDEz
NApbICAgMzMuODAwMTg0XSAgWzxmZmZmZmZmZjgxMGFjYTAwPl0gPyBwYXJhbV9zZXRfY2hh
cnArMHg4YS8weGRhClsgICAzMy44MDAxODRdICBbPGZmZmZmZmZmODEwYWNjMjk+XSA/IHBh
cnNlX2FyZ3MrMHgxODQvMHgyNDIKWyAgIDMzLjgwMDE4NF0gIFs8ZmZmZmZmZmY4MWUyZGZj
ZT5dIGtlcm5lbF9pbml0X2ZyZWVhYmxlKzB4MTU0LzB4MWQ1ClsgICAzMy44MDAxODRdICBb
PGZmZmZmZmZmODFlMmQ2ZGE+XSA/IGRvX2Vhcmx5X3BhcmFtKzB4ODgvMHg4OApbICAgMzMu
ODAwMTg0XSAgWzxmZmZmZmZmZjgxODRmNTA5Pl0gPyByZXN0X2luaXQrMHhiZC8weGJkClsg
ICAzMy44MDAxODRdICBbPGZmZmZmZmZmODE4NGY1MTI+XSBrZXJuZWxfaW5pdCsweDkvMHhj
YwpbICAgMzMuODAwMTg0XSAgWzxmZmZmZmZmZjgxODYwZGNjPl0gcmV0X2Zyb21fZm9yaysw
eDdjLzB4YjAKWyAgIDMzLjgwMDE4NF0gIFs8ZmZmZmZmZmY4MTg0ZjUwOT5dID8gcmVzdF9p
bml0KzB4YmQvMHhiZApbICAgMzMuODAwMTg0XSAtLS1bIGVuZCB0cmFjZSA2M2E3NTI3Zjgz
NTQ3ODliIF0tLS0KL2tlcm5lbC94ODZfNjQtcmFuZGNvbmZpZy14MS0wOTI4L2EwY2YxYWJj
MjVhYzE5N2RkOTdiODU3YzBmNjM0MTA2NmE4Y2IxY2YvZG1lc2cteW9jdG8tbGtwLXR0MDIt
MTg6MjAxMzEwMDUxMjE2Mjc6eDg2XzY0LXJhbmRjb25maWcteDEtMDkyODozLjEyLjAtcmMy
LW5leHQtMjAxMzA5MjctMDMxMDAtZ2EwY2YxYWI6MTUyCgpbZGV0YWNoZWQgSEVBRCA5MThj
ZjY5XSBSZXZlcnQgImtvYmplY3Q6IGRlbGF5ZWQga29iamVjdCByZWxlYXNlOiBoZWxwIGZp
bmQgYnVnZ3kgZHJpdmVycyIKIDMgZmlsZXMgY2hhbmdlZCwgMyBpbnNlcnRpb25zKCspLCA0
MiBkZWxldGlvbnMoLSkKbHMgLWEgL2tlcm5lbC10ZXN0cy9ydW4tcXVldWUva3ZtL3g4Nl82
NC1yYW5kY29uZmlnLXgxLTA5MjgvbmV4dDptYXN0ZXI6OTE4Y2Y2OWUxYjExMzcwY2E2ZGE3
N2M5NmZmMzM4M2IwNmE3MmJmMzpiaXNlY3QtbW0KCjIwMTMtMTAtMDUtMjE6NDc6NDMgOTE4
Y2Y2OWUxYjExMzcwY2E2ZGE3N2M5NmZmMzM4M2IwNmE3MmJmMyBjb21waWxpbmcKG1sxOzM1
bWFkZF90b19ydW5fcXVldWU6IHJlcXVlc3RlZCAxMDAwMCwgbGltaXQgdG8gNTAwMBtbMG0K
CjIwMTMtMTAtMDUtMjE6NTQ6MDggZGV0ZWN0aW5nIGJvb3Qgc3RhdGUgMy4xMi4wLXJjMi1u
ZXh0LTIwMTMwOTI3LTAwMDAxLWc5MThjZjY5Li4uCTEzOQkyMjEuLi4uLi4uLi4uCTM0Nwk0
OTcJNTYzCTYyMgk2ODkJNzYxCTg3MAkxMDI1CTExNzIJMTMyNQkxNTExCTE2NjEuLi4uLi4u
Li4uLi4uLi4uLi4uLi4JMTcxMwkxODQwCTE5MzgJMjA0NwkyMTQ1CTIyNTUJMjM3OQkyNTAx
CTI2MDcJMjcwMAkyNzkxCTI4OTUJMzAxNQkzMTI1CTMyNDcJMzM2MwkzNDc2CTM1OTMJMzY4
NwkzNzg1CTM4OTkJNDAxNQk0MTI4CTQyNDEJNDMzOQk0NDUwCTQ1NjAJNDY3Mgk0Nzk1CTQ4
OTgJNTAwMC4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4u
Li4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4u
Li4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4u
Li4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4u
Li4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4u
Li4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4bWzE7MzVtYWRkX3RvX3J1
bl9xdWV1ZSA1MDAwG1swbQouLgk1MDA4CTUwMTUJNTAyMgk1MDI5CTUwMzUJNTAzOQk1MDQ1
CTUwNDgJNTA1NC4JNTA1OAk1MDY1CTUwNjkJNTA3Mgk1MDczCTUwNzUJNTA4Mgk1MDg2CTUw
OTQuCTUwOTkJNTEwMgk1MTA1CTUxMTMJNTExNwk1MTI3CTUxNDEJNTE1NQk1MTcwCTUxOTcJ
NTIxNQk1MjMxCTUyNDIJNTI2Ngk1Mjc0CTUyODkJNTMwNAk1MzMxCTUzNTUJNTM4Mwk1NDAy
CTU0NDMJNTQ2OAk1NDk1CTU1MjcJNTU1NAk1NTc0CTU1OTMJNTYxNQk1NjMyCTU2NTQJNTY3
OAk1NzAwCTU3MjgJNTc1NQk1NzkxCTU4MjQJNTg2Mgk1OTA2CTU5NDEJNTk2OQk2MDA5CTYw
NDMJNjA3Mgk2MTE2CTYxNDUJNjE3OQk2MjE5CTYyNTEJNjI3Nwk2MzEzCTYzNDUJNjM2OQk2
Mzk5CTY0MjgJNjQ1NQk2NTA2CTY1NDAJNjU1NAk2NjAyCTY2NDkJNjY5MAk2NzIwCTY3NjgJ
NjgwNwk2ODQ2CTY4ODYJNjkyNwk2OTczCTY5OTUJNzA0NQk3MDg5CTcxMTcJNzE0NQk3MTkw
CTcyMzMJNzI2Ngk3MzI3CTczNjUJNzQwNgk3NDU2CTc0ODUJNzUxNAk3NTcwCTc2MDYJNzY0
Mi4JNzY4MAk3NzQ0Li4JNzg1Ngk3OTM3Lgk3OTY2CTgxMzkuCTgyNjgJODMzNwk4NDU2CTg1
NzIJODY1OAk4NzI0CTg4MDIJODg5OQk4OTgxCTkwNzYJOTE5Mwk5Mjk4CTk0MTEJOTUyOQk5
NjAyCTk3MDgJOTc5OAk5ODk2CTk5OTYJOTk5OAk5OTk5CTEwMDAwIFNVQ0NFU1MKCgo9PT09
PT09PT0gdXBzdHJlYW0gPT09PT09PT09CkZldGNoaW5nIGxpbnVzCmxzIC1hIC9rZXJuZWwt
dGVzdHMvcnVuLXF1ZXVlL2t2bS94ODZfNjQtcmFuZGNvbmZpZy14MS0wOTI4L25leHQ6bWFz
dGVyOjdkZWU4ZGZmNDc3MzRlZTUyZGEyY2Q4YjhlYTk3MzZlNDJjNTA2MmY6YmlzZWN0LW1t
CgoyMDEzLTEwLTA2LTAyOjE1OjEyIDdkZWU4ZGZmNDc3MzRlZTUyZGEyY2Q4YjhlYTk3MzZl
NDJjNTA2MmYgY29tcGlsaW5nChtbMTszNW1hZGRfdG9fcnVuX3F1ZXVlOiByZXF1ZXN0ZWQg
MTAwMDAsIGxpbWl0IHRvIDUwMDAbWzBtCgoyMDEzLTEwLTA2LTAyOjE5OjQ4IGRldGVjdGlu
ZyBib290IHN0YXRlIDMuMTIuMC1yYzMtMDAzMTMtZzdkZWU4ZGYJNgkyNSBURVNUIEZBSUxV
UkUKWyAgICAzLjY1ODUzNV0gREVDbmV0OiBSb3V0aW5nIGNhY2hlIGhhc2ggdGFibGUgb2Yg
MjU2IGJ1Y2tldHMsIDE2S2J5dGVzClsgICAgMy42NTk3NjZdIE5FVDogUmVnaXN0ZXJlZCBw
cm90b2NvbCBmYW1pbHkgMTIKWyAgICAzLjY2ODA2MV0gQlVHOiB1bmFibGUgdG8gaGFuZGxl
IGtlcm5lbCBwYWdpbmcgcmVxdWVzdCBhdCBmZmZmZmZmZmZmZmZmZjhjClsgICAgMy42Njky
NDJdIElQOiBbPGZmZmZmZmZmODE3NGU3ZTE+XSB0Y3BtX2NoZWNrX3N0YW1wKzB4OC8weDI5
ClsgICAgMy42NzAxOTddIFBHRCAxYzVhMDY3IFBVRCAxYzVjMDY3IFBNRCAwIApbICAgIDMu
NjcwOTQ2XSBPb3BzOiAwMDAyIFsjMV0gUFJFRU1QVCBTTVAgREVCVUdfUEFHRUFMTE9DClsg
ICAgMy42NzE4MzNdIENQVTogMCBQSUQ6IDAgQ29tbTogc3dhcHBlci8wIE5vdCB0YWludGVk
IDMuMTIuMC1yYzMtMDAzMTMtZzdkZWU4ZGYgIzQxMQpbICAgIDMuNjcyMDE0XSB0YXNrOiBm
ZmZmZmZmZjgxYzVlNDgwIHRpOiBmZmZmZmZmZjgxYzUwMDAwIHRhc2sudGk6IGZmZmZmZmZm
ODFjNTAwMDAKWyAgICAzLjY3MjAxNF0gUklQOiAwMDEwOls8ZmZmZmZmZmY4MTc0ZTdlMT5d
ICBbPGZmZmZmZmZmODE3NGU3ZTE+XSB0Y3BtX2NoZWNrX3N0YW1wKzB4OC8weDI5ClsgICAg
My42NzIwMTRdIFJTUDogMDAxODpmZmZmODgwMDBmMDAzZTU4ICBFRkxBR1M6IDAwMDEwMjg2
ClsgICAgMy42NzIwMTRdIFJBWDogMDAwMDAwMDAwMDAwMDAwMSBSQlg6IDAwMDAwMDAwMDAw
MDAxMDEgUkNYOiAwMDAwMDAwMDAwMDAwMDAwClsgICAgMy42NzIwMTRdIFJEWDogMDAwMDAw
MDAwMDAwMGRmYiBSU0k6IGZmZmZmZmZmODFmNzA0YTggUkRJOiBmZmZmZmZmZjgxZjJmNGU4
ClsgICAgMy42NzIwMTRdIFJCUDogZmZmZjg4MDAwZjAwM2ViMCBSMDg6IDAwMDAwMDAwMDAw
MDAwMDAgUjA5OiAwMDAwMDAwMDAwMDAwMDAwClsgICAgMy42NzIwMTRdIFIxMDogMDAwMDAw
MDAwMDAwMDAwMSBSMTE6IGZmZmY4ODAwMGYwMGEwMDAgUjEyOiBmZmZmZmZmZjgxYzUxZmQ4
ClsgICAgMy42NzIwMTRdIFIxMzogZmZmZmZmZmY4MWYyZjRlOCBSMTQ6IGZmZmZmZmZmODFm
MmY0ZTggUjE1OiBmZmZmZmZmZjgxZjJmNGU4ClsgICAgMy42NzIwMTRdIEZTOiAgMDAwMDAw
MDAwMDAwMDAwMCgwMDAwKSBHUzpmZmZmODgwMDBmMDAwMDAwKDAwMDApIGtubEdTOjAwMDAw
MDAwMDAwMDAwMDAKWyAgICAzLjY3MjAxNF0gQ1M6ICAwMDEwIERTOiAwMDAwIEVTOiAwMDAw
IENSMDogMDAwMDAwMDA4MDA1MDAzYgpbICAgIDMuNjcyMDE0XSBDUjI6IGZmZmZmZmZmZmZm
ZmZmOGMgQ1IzOiAwMDAwMDAwMDAxYzU5MDAwIENSNDogMDAwMDAwMDAwMDAwMDZiMApbICAg
IDMuNjcyMDE0XSBTdGFjazoKWyAgICAzLjY3MjAxNF0gIGZmZmZmZmZmODFmMmY0ZWQgZmZm
ZmZmZmY4MTA5NjZiOCBmZmZmZmZmZjgxMDk2NjRjIGZmZmZmZmZmODFmMmY0ZjgKWyAgICAz
LjY3MjAxNF0gIGZmZmZmZmZmODIzM2I5ZjAgMDAwMDAwMDAwMDAwMDAwMCBmZmZmZmZmZjgx
ZjJmNTE4IGZmZmZmZmZmODFmMmVhODAKWyAgICAzLjY3MjAxNF0gIGZmZmZmZmZmODFmMmY0
YzggZmZmZjg4MDAwZjAwM2VjMCBmZmZmZmZmZjgxZjJmNGU4IGZmZmY4ODAwMGYwMDNlZjgK
WyAgICAzLjY3MjAxNF0gQ2FsbCBUcmFjZToKWyAgICAzLjY3MjAxNF0gIDxJUlE+IApbICAg
IDMuNjcyMDE0XSAgWzxmZmZmZmZmZjgxMDk2NmI4Pl0gPyBjYWxsX3RpbWVyX2ZuKzB4NmMv
MHhkZgpbICAgIDMuNjcyMDE0XSAgWzxmZmZmZmZmZjgxMDk2NjRjPl0gPyBwcm9jZXNzX3Rp
bWVvdXQrMHhiLzB4YgpbICAgIDMuNjcyMDE0XSAgWzxmZmZmZmZmZjgxMDk2ZGU0Pl0gcnVu
X3RpbWVyX3NvZnRpcnErMHgxOGQvMHgxYjgKWyAgICAzLjY3MjAxNF0gIFs8ZmZmZmZmZmY4
MTA5MzFjYT5dIF9fZG9fc29mdGlycSsweGM4LzB4MThkClsgICAgMy42NzIwMTRdICBbPGZm
ZmZmZmZmODE4NWMzM2M+XSBjYWxsX3NvZnRpcnErMHgxYy8weDI2ClsgICAgMy42NzIwMTRd
ICBbPGZmZmZmZmZmODEwMmJjNWM+XSBkb19zb2Z0aXJxKzB4NDUvMHg5ZgpbICAgIDMuNjcy
MDE0XSAgWzxmZmZmZmZmZjgxMDkzM2E0Pl0gaXJxX2V4aXQrMHg1Ni8weDk3ClsgICAgMy42
NzIwMTRdICBbPGZmZmZmZmZmODEwNDVhNWU+XSBzbXBfYXBpY190aW1lcl9pbnRlcnJ1cHQr
MHgzMC8weDNjClsgICAgMy42NzIwMTRdICBbPGZmZmZmZmZmODE4NWJjNzI+XSBhcGljX3Rp
bWVyX2ludGVycnVwdCsweDcyLzB4ODAKWyAgICAzLjY3MjAxNF0gIDxFT0k+IApbICAgIDMu
NjcyMDE0XSAgWzxmZmZmZmZmZjgxMGFhNWM0Pl0gPyBub3RpZmllcl9jYWxsX2NoYWluKzB4
NTkvMHg1OQpbICAgIDMuNjcyMDE0XSAgWzxmZmZmZmZmZjgxMGFhNWM0Pl0gPyBub3RpZmll
cl9jYWxsX2NoYWluKzB4NTkvMHg1OQpbICAgIDMuNjcyMDE0XSAgWzxmZmZmZmZmZjgxMDRh
ZGUzPl0gPyBuYXRpdmVfc2FmZV9oYWx0KzB4Ni8weDgKWyAgICAzLjY3MjAxNF0gIFs8ZmZm
ZmZmZmY4MTBjYjU1MT5dID8gdHJhY2VfaGFyZGlycXNfb24rMHhkLzB4ZgpbICAgIDMuNjcy
MDE0XSAgWzxmZmZmZmZmZjgxMDMxMzE3Pl0gZGVmYXVsdF9pZGxlKzB4MTMvMHgxYwpbICAg
IDMuNjcyMDE0XSAgWzxmZmZmZmZmZjgxMDMxYTJhPl0gYXJjaF9jcHVfaWRsZSsweDEzLzB4
MjEKWyAgICAzLjY3MjAxNF0gIFs8ZmZmZmZmZmY4MTBiZDA1MT5dIGNwdV9zdGFydHVwX2Vu
dHJ5KzB4MTA0LzB4MTY0ClsgICAgMy42NzIwMTRdICBbPGZmZmZmZmZmODE4NDkwNjU+XSBy
ZXN0X2luaXQrMHhiOS8weGJkClsgICAgMy42NzIwMTRdICBbPGZmZmZmZmZmODE4NDhmYWM+
XSA/IGNzdW1fcGFydGlhbF9jb3B5X2dlbmVyaWMrMHgxNmMvMHgxNmMKWyAgICAzLjY3MjAx
NF0gIFs8ZmZmZmZmZmY4MWUyMGQzYT5dIHN0YXJ0X2tlcm5lbCsweDQxNi8weDQyMgpbICAg
IDMuNjcyMDE0XSAgWzxmZmZmZmZmZjgxZTIwNzMyPl0gPyByZXBhaXJfZW52X3N0cmluZysw
eDU4LzB4NTgKWyAgICAzLjY3MjAxNF0gIFs8ZmZmZmZmZmY4MWUyMDEyMD5dID8gZWFybHlf
aWR0X2hhbmRsZXJzKzB4MTIwLzB4MTIwClsgICAgMy42NzIwMTRdICBbPGZmZmZmZmZmODFl
MjA0NGM+XSB4ODZfNjRfc3RhcnRfcmVzZXJ2YXRpb25zKzB4MmEvMHgyYwpbICAgIDMuNjcy
MDE0XSAgWzxmZmZmZmZmZjgxZTIwNTJhPl0geDg2XzY0X3N0YXJ0X2tlcm5lbCsweGRjLzB4
ZTkKWyAgICAzLjY3MjAxNF0gQ29kZTogMmMgMDAgMDAgMDAgMDAgODkgNDMgNDQgNzQgMTAg
NjYgODEgNjMgNGEgMDAgZmMgNjYgYzcgNDMgNDggMDAgMDAgYzYgNDMgNTggMDAgNWIgNDEg
NWMgNDEgNWQgNDEgNWUgNWQgYzMgNDggODUgZmYgNzQgMjMgNDggOGIgNGYgPDIwPiA0OCA4
YiAwNSAxNyBkOCA2YiAwMCA0OCA4ZCA5MSBhMCBiYiAwZCAwMCA0OCAzOSBjMiA3OSAwYyA1
NSAKWyAgICAzLjY3MjAxNF0gUklQICBbPGZmZmZmZmZmODE3NGU3ZTE+XSB0Y3BtX2NoZWNr
X3N0YW1wKzB4OC8weDI5ClsgICAgMy42NzIwMTRdICBSU1AgPGZmZmY4ODAwMGYwMDNlNTg+
ClsgICAgMy42NzIwMTRdIENSMjogZmZmZmZmZmZmZmZmZmY4YwpbICAgIDMuNjcyMDE0XSAt
LS1bIGVuZCB0cmFjZSA3MDY0ODY1YjRlN2FhNTlmIF0tLS0KL2tlcm5lbC94ODZfNjQtcmFu
ZGNvbmZpZy14MS0wOTI4LzdkZWU4ZGZmNDc3MzRlZTUyZGEyY2Q4YjhlYTk3MzZlNDJjNTA2
MmYvZG1lc2cteW9jdG8tc3RvYWtsZXktNDoyMDEzMTAwNjAyMjAzMTp4ODZfNjQtcmFuZGNv
bmZpZy14MS0wOTI4OjMuMTIuMC1yYzMtMDAzMTMtZzdkZWU4ZGY6NDExCgoKPT09PT09PT09
IGxpbnV4LW5leHQgPT09PT09PT09CkZldGNoaW5nIG5leHQKbHMgLWEgL2tlcm5lbC10ZXN0
cy9ydW4tcXVldWUva3ZtL3g4Nl82NC1yYW5kY29uZmlnLXgxLTA5MjgvbmV4dDptYXN0ZXI6
YTBjZjFhYmMyNWFjMTk3ZGQ5N2I4NTdjMGY2MzQxMDY2YThjYjFjZjpiaXNlY3QtbW0KIFRF
U1QgRkFJTFVSRQpbICAgMzMuNTEyMTQ1XSBvcHRpb25zOiAweDQyClsgICAzMy41NTQ2MDNd
IFNjYW5uaW5nIGRldmljZSBmb3IgYmFkIGJsb2NrcwpbICAgMzQuNDAxMjg2XSBCVUc6IHVu
YWJsZSB0byBoYW5kbGUga2VybmVsIE5VTEwgcG9pbnRlciBkZXJlZmVyZW5jZSBhdCAwMDAw
MDAwMDAwMDAwMDA4ClsgICAzNC40MDIxMDddIElQOiBbPGZmZmZmZmZmODEwOWVmOTg+XSBy
dW5fdGltZXJfc29mdGlycSsweDEyYy8weDFiOApbICAgMzQuNDAzODA4XSBQR0QgMCAKWyAg
IDM0LjQwNDI3Nl0gT29wczogMDAwMiBbIzFdIFBSRUVNUFQgU01QIERFQlVHX1BBR0VBTExP
QwpbICAgMzQuNDA0Mjc2XSBDUFU6IDAgUElEOiAxIENvbW06IHN3YXBwZXIvMCBOb3QgdGFp
bnRlZCAzLjEyLjAtcmMyLW5leHQtMjAxMzA5MjctMDMxMDAtZ2EwY2YxYWIgIzE1MgpbICAg
MzQuNDA0Mjc2XSB0YXNrOiBmZmZmODgwMDAwMDdjMDQwIHRpOiBmZmZmODgwMDAwMDdlMDAw
IHRhc2sudGk6IGZmZmY4ODAwMDAwN2UwMDAKWyAgIDM0LjQwNDI3Nl0gUklQOiAwMDEwOls8
ZmZmZmZmZmY4MTA5ZWY5OD5dICBbPGZmZmZmZmZmODEwOWVmOTg+XSBydW5fdGltZXJfc29m
dGlycSsweDEyYy8weDFiOApbICAgMzQuNDA0Mjc2XSBSU1A6IDAwMTg6ZmZmZjg4MDAwZjAw
M2VlMCAgRUZMQUdTOiAwMDAwMDAwMgpbICAgMzQuNDA0Mjc2XSBSQVg6IGZmZmY4ODAwMGYw
MDNlZTAgUkJYOiBmZmZmZmZmZjgxZjNiYTgwIFJDWDogMDAwMDAwMDAwMDAwMDAwMgpbICAg
MzQuNDA0Mjc2XSBSRFg6IDAwMDAwMDAwMDAwMDAwMDAgUlNJOiAwMDAwMDAwMDAwMDAwMDI4
IFJESTogZmZmZmZmZmY4MTA5ZWVhOApbICAgMzQuNDA0Mjc2XSBSQlA6IGZmZmY4ODAwMGYw
MDNmMTggUjA4OiAwMDAwMDAwMDAwMDAwMDAyIFIwOTogMDAwMDAwMDAwMDAwMDAwMQpbICAg
MzQuNDA0Mjc2XSBSMTA6IGZmZmZmZmZmODEwOWVlYTggUjExOiBmZmZmZmZmZjgxMGM1Yzc2
IFIxMjogZmZmZjg4MDAwY2M3ZThhMApbICAgMzQuNDA0Mjc2XSBSMTM6IGZmZmY4ODAwMGYw
MDNlZTAgUjE0OiBmZmZmZmZmZjgxMGE3NjhjIFIxNTogZmZmZjg4MDAwY2M3ZTg2MApbICAg
MzQuNDA0Mjc2XSBGUzogIDAwMDAwMDAwMDAwMDAwMDAoMDAwMCkgR1M6ZmZmZjg4MDAwZjAw
MDAwMCgwMDAwKSBrbmxHUzowMDAwMDAwMDAwMDAwMDAwClsgICAzNC40MDQyNzZdIENTOiAg
MDAxMCBEUzogMDAwMCBFUzogMDAwMCBDUjA6IDAwMDAwMDAwODAwNTAwM2IKWyAgIDM0LjQw
NDI3Nl0gQ1IyOiAwMDAwMDAwMDAwMDAwMDA4IENSMzogMDAwMDAwMDAwMWM2NTAwMCBDUjQ6
IDAwMDAwMDAwMDAwMDA2YjAKWyAgIDM0LjQwNDI3Nl0gRFIwOiAwMDAwMDAwMDAwMDAwMDAw
IERSMTogMDAwMDAwMDAwMDAwMDAwMCBEUjI6IDAwMDAwMDAwMDAwMDAwMDAKWyAgIDM0LjQw
NDI3Nl0gRFIzOiAwMDAwMDAwMDAwMDAwMDAwIERSNjogMDAwMDAwMDAwMDAwMDAwMCBEUjc6
IDAwMDAwMDAwMDAwMDAwMDAKWyAgIDM0LjQwNDI3Nl0gU3RhY2s6ClsgICAzNC40MDQyNzZd
ICBmZmZmODgwMDBjYzdlOGEwIGZmZmY4ODAwMGNjN2UwYTAgMDAwMDAwMDAwMDAwMDAwMSBm
ZmZmZmZmZjgxYzYxMDg4ClsgICAzNC40MDQyNzZdICAwMDAwMDAwMDAwMDAwMDBhIDAwMDAw
MDAwMDAwMDAxMDEgMDAwMDAwMDAwMDAwMDAwMSBmZmZmODgwMDBmMDAzZjY4ClsgICAzNC40
MDQyNzZdICBmZmZmZmZmZjgxMDliNDE1IDAwMDAwMDAwMDAwMDAwMDEgMDAyMDQxNDAwMDAw
MDAwMCAwMDAwMDAwMGZmZmVmY2ExClsgICAzNC40MDQyNzZdIENhbGwgVHJhY2U6ClsgICAz
NC40MDQyNzZdICA8SVJRPiAKWyAgIDM0LjQwNDI3Nl0gIFs8ZmZmZmZmZmY4MTA5YjQxNT5d
IF9fZG9fc29mdGlycSsweGM2LzB4MTk2ClsgICAzNC40MDQyNzZdICBbPGZmZmZmZmZmODEw
OWI1ZWU+XSBpcnFfZXhpdCsweDUwLzB4ODYKWyAgIDM0LjQwNDI3Nl0gIFs8ZmZmZmZmZmY4
MTAyYjdhYT5dIGRvX0lSUSsweDg4LzB4OWYKWyAgIDM0LjQwNDI3Nl0gIFs8ZmZmZmZmZmY4
MTg2MDViMj5dIGNvbW1vbl9pbnRlcnJ1cHQrMHg3Mi8weDcyClsgICAzNC40MDQyNzZdICA8
RU9JPiAKWyAgIDM0LjQwNDI3Nl0gIFs8ZmZmZmZmZmY4MTRlNGNlMT5dID8gbmFuZF9nZXRf
ZGV2aWNlLmlzcmEuMTUrMHg0ZC8weGY1ClsgICAzNC40MDQyNzZdICBbPGZmZmZmZmZmODE0
ZTRjZTE+XSA/IG5hbmRfZ2V0X2RldmljZS5pc3JhLjE1KzB4NGQvMHhmNQpbICAgMzQuNDA0
Mjc2XSAgWzxmZmZmZmZmZjgxNGU0ZDM2Pl0gPyBuYW5kX2dldF9kZXZpY2UuaXNyYS4xNSsw
eGEyLzB4ZjUKWyAgIDM0LjQwNDI3Nl0gIFs8ZmZmZmZmZmY4MTBkNTZlZj5dID8gbG9ja19y
ZWxlYXNlX25vbl9uZXN0ZWQrMHgyMWQvMHgyMWQKWyAgIDM0LjQwNDI3Nl0gIFs8ZmZmZmZm
ZmY4MTg1ZjliNj5dID8gX3Jhd19zcGluX2xvY2srMHgzYy8weDQxClsgICAzNC40MDQyNzZd
ICBbPGZmZmZmZmZmODE4NWZhYjk+XSA/IF9yYXdfc3Bpbl91bmxvY2srMHgxYS8weDQwClsg
ICAzNC40MDQyNzZdICBbPGZmZmZmZmZmODE0ZTRkMzY+XSBuYW5kX2dldF9kZXZpY2UuaXNy
YS4xNSsweGEyLzB4ZjUKWyAgIDM0LjQwNDI3Nl0gIFs8ZmZmZmZmZmY4MTBiOGFlMj5dID8g
d2FrZV91cF9zdGF0ZSsweGQvMHhkClsgICAzNC40MDQyNzZdICBbPGZmZmZmZmZmODE0ZTU5
NTI+XSBuYW5kX3JlYWRfb29iKzB4NTUvMHgyNzAKWyAgIDM0LjQwNDI3Nl0gIFs8ZmZmZmZm
ZmY4MTRjZTliYj5dIG10ZF9yZWFkX29vYisweDI2LzB4NGMKWyAgIDM0LjQwNDI3Nl0gIFs8
ZmZmZmZmZmY4MTRlODViMT5dIGNyZWF0ZV9iYnQrMHgyMGYvMHgyOWEKWyAgIDM0LjQwNDI3
Nl0gIFs8ZmZmZmZmZmY4MTRlODZiYj5dIG5hbmRfc2Nhbl9iYnQrMHg3Zi8weDRkZApbICAg
MzQuNDA0Mjc2XSAgWzxmZmZmZmZmZjgxMTIxZDg3Pl0gPyBfX2ttYWxsb2MrMHg5MC8weGJi
ClsgICAzNC40MDQyNzZdICBbPGZmZmZmZmZmODE0ZThiZjg+XSBuYW5kX2RlZmF1bHRfYmJ0
KzB4ZGYvMHhlNApbICAgMzQuNDA0Mjc2XSAgWzxmZmZmZmZmZjgxZTU3NzY5Pl0gbnNfaW5p
dF9tb2R1bGUrMHg1NmMvMHhkMjgKWyAgIDM0LjQwNDI3Nl0gIFs8ZmZmZmZmZmY4MTIyZjFi
ZD5dID8gZnJlZV9ycysweDc1LzB4NzgKWyAgIDM0LjQwNDI3Nl0gIFs8ZmZmZmZmZmY4MWU1
NzFmZD5dID8gbmZ0bF9zY2FuX2JidCsweDMxMi8weDMxMgpbICAgMzQuNDA0Mjc2XSAgWzxm
ZmZmZmZmZjgxZTJkZGQ0Pl0gZG9fb25lX2luaXRjYWxsKzB4OGUvMHgxMzQKWyAgIDM0LjQw
NDI3Nl0gIFs8ZmZmZmZmZmY4MTBhY2EwMD5dID8gcGFyYW1fc2V0X2NoYXJwKzB4OGEvMHhk
YQpbICAgMzQuNDA0Mjc2XSAgWzxmZmZmZmZmZjgxMGFjYzI5Pl0gPyBwYXJzZV9hcmdzKzB4
MTg0LzB4MjQyClsgICAzNC40MDQyNzZdICBbPGZmZmZmZmZmODFlMmRmY2U+XSBrZXJuZWxf
aW5pdF9mcmVlYWJsZSsweDE1NC8weDFkNQpbICAgMzQuNDA0Mjc2XSAgWzxmZmZmZmZmZjgx
ZTJkNmRhPl0gPyBkb19lYXJseV9wYXJhbSsweDg4LzB4ODgKWyAgIDM0LjQwNDI3Nl0gIFs8
ZmZmZmZmZmY4MTg0ZjUwOT5dID8gcmVzdF9pbml0KzB4YmQvMHhiZApbICAgMzQuNDA0Mjc2
XSAgWzxmZmZmZmZmZjgxODRmNTEyPl0ga2VybmVsX2luaXQrMHg5LzB4Y2MKWyAgIDM0LjQw
NDI3Nl0gIFs8ZmZmZmZmZmY4MTg2MGRjYz5dIHJldF9mcm9tX2ZvcmsrMHg3Yy8weGIwClsg
ICAzNC40MDQyNzZdICBbPGZmZmZmZmZmODE4NGY1MDk+XSA/IHJlc3RfaW5pdCsweGJkLzB4
YmQKWyAgIDM0LjQwNDI3Nl0gQ29kZTogOGIgNjUgYzggNGQgMzkgZWMgMGYgODQgMmYgZmYg
ZmYgZmYgNDEgOGIgNGMgMjQgMTggNGQgOGIgNzQgMjQgMjAgNGQgOGIgN2MgMjQgMjggNGMg
ODkgNjMgMzggNDkgOGIgNDQgMjQgMDggNDkgOGIgMTQgMjQgODMgZTEgMDIgPDQ4PiA4OSA0
MiAwOCA0OCA4OSAxMCA0OCBiOCAwMCAwMiAyMCAwMCAwMCAwMCBhZCBkZSA0MSBmNiA0NCAy
NCAKWyAgIDM0LjQwNDI3Nl0gUklQICBbPGZmZmZmZmZmODEwOWVmOTg+XSBydW5fdGltZXJf
c29mdGlycSsweDEyYy8weDFiOApbICAgMzQuNDA0Mjc2XSAgUlNQIDxmZmZmODgwMDBmMDAz
ZWUwPgpbICAgMzQuNDA0Mjc2XSBDUjI6IDAwMDAwMDAwMDAwMDAwMDgKWyAgIDM0LjQwNDI3
Nl0gLS0tWyBlbmQgdHJhY2UgZTUzOGUwOThlMGYyYjE1NSBdLS0tCi9rZXJuZWwveDg2XzY0
LXJhbmRjb25maWcteDEtMDkyOC9hMGNmMWFiYzI1YWMxOTdkZDk3Yjg1N2MwZjYzNDEwNjZh
OGNiMWNmL2RtZXNnLXlvY3RvLWF0aGVucy0xMToyMDEzMTAwNTIxNTgyMDp4ODZfNjQtcmFu
ZGNvbmZpZy14MS0wOTI4OjMuMTIuMC1yYzItbmV4dC0yMDEzMDkyNy0wMzEwMC1nYTBjZjFh
YjoxNTIKL2tlcm5lbC94ODZfNjQtcmFuZGNvbmZpZy14MS0wOTI4L2EwY2YxYWJjMjVhYzE5
N2RkOTdiODU3YzBmNjM0MTA2NmE4Y2IxY2YvZG1lc2cteW9jdG8tYXRoZW5zLTU6MjAxMzEw
MDUyMjAxNTY6eDg2XzY0LXJhbmRjb25maWcteDEtMDkyODozLjEyLjAtcmMyLW5leHQtMjAx
MzA5MjctMDMxMDAtZ2EwY2YxYWI6MTUyCi9rZXJuZWwveDg2XzY0LXJhbmRjb25maWcteDEt
MDkyOC9hMGNmMWFiYzI1YWMxOTdkZDk3Yjg1N2MwZjYzNDEwNjZhOGNiMWNmL2RtZXNnLXlv
Y3RvLWNhaXJvLTEwOjIwMTMxMDA1MjE1NDExOng4Nl82NC1yYW5kY29uZmlnLXgxLTA5Mjg6
My4xMi4wLXJjMi1uZXh0LTIwMTMwOTI3LTAzMTAwLWdhMGNmMWFiOjE1Mgova2VybmVsL3g4
Nl82NC1yYW5kY29uZmlnLXgxLTA5MjgvYTBjZjFhYmMyNWFjMTk3ZGQ5N2I4NTdjMGY2MzQx
MDY2YThjYjFjZi9kbWVzZy15b2N0by1jYWlyby0yMjoyMDEzMTAwNTIxNTAzMjp4ODZfNjQt
cmFuZGNvbmZpZy14MS0wOTI4OjMuMTIuMC1yYzItbmV4dC0yMDEzMDkyNy0wMzEwMC1nYTBj
ZjFhYjoxNTIKL2tlcm5lbC94ODZfNjQtcmFuZGNvbmZpZy14MS0wOTI4L2EwY2YxYWJjMjVh
YzE5N2RkOTdiODU3YzBmNjM0MTA2NmE4Y2IxY2YvZG1lc2cteW9jdG8tY2Fpcm8tMjc6MjAx
MzEwMDUyMTUyMDA6eDg2XzY0LXJhbmRjb25maWcteDEtMDkyODozLjEyLjAtcmMyLW5leHQt
MjAxMzA5MjctMDMxMDAtZ2EwY2YxYWI6MTUyCi9rZXJuZWwveDg2XzY0LXJhbmRjb25maWct
eDEtMDkyOC9hMGNmMWFiYzI1YWMxOTdkZDk3Yjg1N2MwZjYzNDEwNjZhOGNiMWNmL2RtZXNn
LXlvY3RvLWNhaXJvLTMzOjIwMTMxMDA1MjE0OTIxOng4Nl82NC1yYW5kY29uZmlnLXgxLTA5
Mjg6My4xMi4wLXJjMi1uZXh0LTIwMTMwOTI3LTAzMTAwLWdhMGNmMWFiOjE1Mgova2VybmVs
L3g4Nl82NC1yYW5kY29uZmlnLXgxLTA5MjgvYTBjZjFhYmMyNWFjMTk3ZGQ5N2I4NTdjMGY2
MzQxMDY2YThjYjFjZi9kbWVzZy15b2N0by1jYWlyby0zOToyMDEzMTAwNTIyMDAzMzp4ODZf
NjQtcmFuZGNvbmZpZy14MS0wOTI4OjMuMTIuMC1yYzItbmV4dC0yMDEzMDkyNy0wMzEwMC1n
YTBjZjFhYjoxNTIKL2tlcm5lbC94ODZfNjQtcmFuZGNvbmZpZy14MS0wOTI4L2EwY2YxYWJj
MjVhYzE5N2RkOTdiODU3YzBmNjM0MTA2NmE4Y2IxY2YvZG1lc2cteW9jdG8taW5uLTQwOjIw
MTMxMDA1MjIwMDE0Ong4Nl82NC1yYW5kY29uZmlnLXgxLTA5Mjg6My4xMi4wLXJjMi1uZXh0
LTIwMTMwOTI3LTAzMTAwLWdhMGNmMWFiOjE1Mgova2VybmVsL3g4Nl82NC1yYW5kY29uZmln
LXgxLTA5MjgvYTBjZjFhYmMyNWFjMTk3ZGQ5N2I4NTdjMGY2MzQxMDY2YThjYjFjZi9kbWVz
Zy15b2N0by1pbm4tNDU6MjAxMzEwMDUyMTQ5MDI6eDg2XzY0LXJhbmRjb25maWcteDEtMDky
ODozLjEyLjAtcmMyLW5leHQtMjAxMzA5MjctMDMxMDAtZ2EwY2YxYWI6MTUyCi9rZXJuZWwv
eDg2XzY0LXJhbmRjb25maWcteDEtMDkyOC9hMGNmMWFiYzI1YWMxOTdkZDk3Yjg1N2MwZjYz
NDEwNjZhOGNiMWNmL2RtZXNnLXlvY3RvLWxrcC1zdDAxLTE6MjAxMzEwMDUyMTU2MTA6eDg2
XzY0LXJhbmRjb25maWcteDEtMDkyODozLjEyLjAtcmMyLW5leHQtMjAxMzA5MjctMDMxMDAt
Z2EwY2YxYWI6MTUyCi9rZXJuZWwveDg2XzY0LXJhbmRjb25maWcteDEtMDkyOC9hMGNmMWFi
YzI1YWMxOTdkZDk3Yjg1N2MwZjYzNDEwNjZhOGNiMWNmL2RtZXNnLXlvY3RvLWxrcC1zdDAx
LTI6MjAxMzEwMDUyMTU4MzQ6eDg2XzY0LXJhbmRjb25maWcteDEtMDkyODozLjEyLjAtcmMy
LW5leHQtMjAxMzA5MjctMDMxMDAtZ2EwY2YxYWI6MTUyCi9rZXJuZWwveDg2XzY0LXJhbmRj
b25maWcteDEtMDkyOC9hMGNmMWFiYzI1YWMxOTdkZDk3Yjg1N2MwZjYzNDEwNjZhOGNiMWNm
L2RtZXNnLXlvY3RvLWxrcC1zdDAxLTY6MjAxMzEwMDUyMTU3NTQ6eDg2XzY0LXJhbmRjb25m
aWcteDEtMDkyODozLjEyLjAtcmMyLW5leHQtMjAxMzA5MjctMDMxMDAtZ2EwY2YxYWI6MTUy
Ci9rZXJuZWwveDg2XzY0LXJhbmRjb25maWcteDEtMDkyOC9hMGNmMWFiYzI1YWMxOTdkZDk3
Yjg1N2MwZjYzNDEwNjZhOGNiMWNmL2RtZXNnLXlvY3RvLWxrcC1zdDAxLTY6MjAxMzEwMDUy
MjA1NTI6eDg2XzY0LXJhbmRjb25maWcteDEtMDkyODozLjEyLjAtcmMyLW5leHQtMjAxMzA5
MjctMDMxMDAtZ2EwY2YxYWI6MTUyCi9rZXJuZWwveDg2XzY0LXJhbmRjb25maWcteDEtMDky
OC9hMGNmMWFiYzI1YWMxOTdkZDk3Yjg1N2MwZjYzNDEwNjZhOGNiMWNmL2RtZXNnLXlvY3Rv
LWxrcC1zdDAxLTk6MjAxMzEwMDUyMjAzMzc6eDg2XzY0LXJhbmRjb25maWcteDEtMDkyODoz
LjEyLjAtcmMyLW5leHQtMjAxMzA5MjctMDMxMDAtZ2EwY2YxYWI6MTUyCi9rZXJuZWwveDg2
XzY0LXJhbmRjb25maWcteDEtMDkyOC9hMGNmMWFiYzI1YWMxOTdkZDk3Yjg1N2MwZjYzNDEw
NjZhOGNiMWNmL2RtZXNnLXlvY3RvLWxrcC10dDAyLTE4OjIwMTMxMDA1MTIxNjI3Ong4Nl82
NC1yYW5kY29uZmlnLXgxLTA5Mjg6My4xMi4wLXJjMi1uZXh0LTIwMTMwOTI3LTAzMTAwLWdh
MGNmMWFiOjE1Mgova2VybmVsL3g4Nl82NC1yYW5kY29uZmlnLXgxLTA5MjgvYTBjZjFhYmMy
NWFjMTk3ZGQ5N2I4NTdjMGY2MzQxMDY2YThjYjFjZi9kbWVzZy15b2N0by1sa3AtdHQwMi02
OjIwMTMxMDA1MTIyMjIyOng4Nl82NC1yYW5kY29uZmlnLXgxLTA5Mjg6My4xMi4wLXJjMi1u
ZXh0LTIwMTMwOTI3LTAzMTAwLWdhMGNmMWFiOjE1Mgova2VybmVsL3g4Nl82NC1yYW5kY29u
ZmlnLXgxLTA5MjgvYTBjZjFhYmMyNWFjMTk3ZGQ5N2I4NTdjMGY2MzQxMDY2YThjYjFjZi9k
bWVzZy15b2N0by1uaG00LTM6MjAxMzEwMDUxNDA4MDU6eDg2XzY0LXJhbmRjb25maWcteDEt
MDkyODozLjEyLjAtcmMyLW5leHQtMjAxMzA5MjctMDMxMDAtZ2EwY2YxYWI6MTUyCi9rZXJu
ZWwveDg2XzY0LXJhbmRjb25maWcteDEtMDkyOC9hMGNmMWFiYzI1YWMxOTdkZDk3Yjg1N2Mw
ZjYzNDEwNjZhOGNiMWNmL2RtZXNnLXlvY3RvLXJvYW0tMjg6MjAxMzEwMDUyMTU0MjY6eDg2
XzY0LXJhbmRjb25maWcteDEtMDkyODozLjEyLjAtcmMyLW5leHQtMjAxMzA5MjctMDMxMDAt
Z2EwY2YxYWI6MTUyCi9rZXJuZWwveDg2XzY0LXJhbmRjb25maWcteDEtMDkyOC9hMGNmMWFi
YzI1YWMxOTdkZDk3Yjg1N2MwZjYzNDEwNjZhOGNiMWNmL2RtZXNnLXlvY3RvLXNuYi0xMjoy
MDEzMTAwNTIxNDg1NTp4ODZfNjQtcmFuZGNvbmZpZy14MS0wOTI4OjMuMTIuMC1yYzItbmV4
dC0yMDEzMDkyNy0wMzEwMC1nYTBjZjFhYjoxNTIKL2tlcm5lbC94ODZfNjQtcmFuZGNvbmZp
Zy14MS0wOTI4L2EwY2YxYWJjMjVhYzE5N2RkOTdiODU3YzBmNjM0MTA2NmE4Y2IxY2YvZG1l
c2cteW9jdG8tc25iLTE0OjIwMTMxMDA1MjE0NzMxOng4Nl82NC1yYW5kY29uZmlnLXgxLTA5
Mjg6My4xMi4wLXJjMi1uZXh0LTIwMTMwOTI3LTAzMTAwLWdhMGNmMWFiOjE1Mgova2VybmVs
L3g4Nl82NC1yYW5kY29uZmlnLXgxLTA5MjgvYTBjZjFhYmMyNWFjMTk3ZGQ5N2I4NTdjMGY2
MzQxMDY2YThjYjFjZi9kbWVzZy15b2N0by1zbmItMTY6MjAxMzEwMDUyMTUyMDE6eDg2XzY0
LXJhbmRjb25maWcteDEtMDkyODozLjEyLjAtcmMyLW5leHQtMjAxMzA5MjctMDMxMDAtZ2Ew
Y2YxYWI6MTUyCi9rZXJuZWwveDg2XzY0LXJhbmRjb25maWcteDEtMDkyOC9hMGNmMWFiYzI1
YWMxOTdkZDk3Yjg1N2MwZjYzNDEwNjZhOGNiMWNmL2RtZXNnLXlvY3RvLXNuYi0xNzoyMDEz
MTAwNTIxNTgyOTp4ODZfNjQtcmFuZGNvbmZpZy14MS0wOTI4OjMuMTIuMC1yYzItbmV4dC0y
MDEzMDkyNy0wMzEwMC1nYTBjZjFhYjoxNTIKL2tlcm5lbC94ODZfNjQtcmFuZGNvbmZpZy14
MS0wOTI4L2EwY2YxYWJjMjVhYzE5N2RkOTdiODU3YzBmNjM0MTA2NmE4Y2IxY2YvZG1lc2ct
eW9jdG8tc25iLTIwOjIwMTMxMDA1MjIwNjM1Ong4Nl82NC1yYW5kY29uZmlnLXgxLTA5Mjg6
My4xMi4wLXJjMi1uZXh0LTIwMTMwOTI3LTAzMTAwLWdhMGNmMWFiOjE1Mgova2VybmVsL3g4
Nl82NC1yYW5kY29uZmlnLXgxLTA5MjgvYTBjZjFhYmMyNWFjMTk3ZGQ5N2I4NTdjMGY2MzQx
MDY2YThjYjFjZi9kbWVzZy15b2N0by1zbmItMjI6MjAxMzEwMDUyMjAwNTk6eDg2XzY0LXJh
bmRjb25maWcteDEtMDkyODozLjEyLjAtcmMyLW5leHQtMjAxMzA5MjctMDMxMDAtZ2EwY2Yx
YWI6MTUyCi9rZXJuZWwveDg2XzY0LXJhbmRjb25maWcteDEtMDkyOC9hMGNmMWFiYzI1YWMx
OTdkZDk3Yjg1N2MwZjYzNDEwNjZhOGNiMWNmL2RtZXNnLXlvY3RvLXNuYi0yNjoyMDEzMTAw
NTIxNTgwMzp4ODZfNjQtcmFuZGNvbmZpZy14MS0wOTI4OjMuMTIuMC1yYzItbmV4dC0yMDEz
MDkyNy0wMzEwMC1nYTBjZjFhYjoxNTIKL2tlcm5lbC94ODZfNjQtcmFuZGNvbmZpZy14MS0w
OTI4L2EwY2YxYWJjMjVhYzE5N2RkOTdiODU3YzBmNjM0MTA2NmE4Y2IxY2YvZG1lc2cteW9j
dG8tc25iLTI4OjIwMTMxMDA1MjIwNjAyOng4Nl82NC1yYW5kY29uZmlnLXgxLTA5Mjg6My4x
Mi4wLXJjMi1uZXh0LTIwMTMwOTI3LTAzMTAwLWdhMGNmMWFiOjE1Mgova2VybmVsL3g4Nl82
NC1yYW5kY29uZmlnLXgxLTA5MjgvYTBjZjFhYmMyNWFjMTk3ZGQ5N2I4NTdjMGY2MzQxMDY2
YThjYjFjZi9kbWVzZy15b2N0by1zbmItMzg6MjAxMzEwMDUyMTU0MTE6eDg2XzY0LXJhbmRj
b25maWcteDEtMDkyODozLjEyLjAtcmMyLW5leHQtMjAxMzA5MjctMDMxMDAtZ2EwY2YxYWI6
MTUyCi9rZXJuZWwveDg2XzY0LXJhbmRjb25maWcteDEtMDkyOC9hMGNmMWFiYzI1YWMxOTdk
ZDk3Yjg1N2MwZjYzNDEwNjZhOGNiMWNmL2RtZXNnLXlvY3RvLXNuYi00MzoyMDEzMTAwNTIx
NTIwNTp4ODZfNjQtcmFuZGNvbmZpZy14MS0wOTI4OjMuMTIuMC1yYzItbmV4dC0yMDEzMDky
Ny0wMzEwMC1nYTBjZjFhYjoxNTIKL2tlcm5lbC94ODZfNjQtcmFuZGNvbmZpZy14MS0wOTI4
L2EwY2YxYWJjMjVhYzE5N2RkOTdiODU3YzBmNjM0MTA2NmE4Y2IxY2YvZG1lc2cteW9jdG8t
c25iLTQ2OjIwMTMxMDA1MjE1ODMzOng4Nl82NC1yYW5kY29uZmlnLXgxLTA5Mjg6My4xMi4w
LXJjMi1uZXh0LTIwMTMwOTI3LTAzMTAwLWdhMGNmMWFiOjE1Mgova2VybmVsL3g4Nl82NC1y
YW5kY29uZmlnLXgxLTA5MjgvYTBjZjFhYmMyNWFjMTk3ZGQ5N2I4NTdjMGY2MzQxMDY2YThj
YjFjZi9kbWVzZy15b2N0by1zdG9ha2xleS02OjIwMTMxMDA1MjE1NDIyOng4Nl82NC1yYW5k
Y29uZmlnLXgxLTA5Mjg6My4xMi4wLXJjMi1uZXh0LTIwMTMwOTI3LTAzMTAwLWdhMGNmMWFi
OjE1Mgova2VybmVsL3g4Nl82NC1yYW5kY29uZmlnLXgxLTA5MjgvYTBjZjFhYmMyNWFjMTk3
ZGQ5N2I4NTdjMGY2MzQxMDY2YThjYjFjZi9kbWVzZy15b2N0by14aWFuLTExOjIwMTMxMDA1
MjIwNDUyOng4Nl82NC1yYW5kY29uZmlnLXgxLTA5Mjg6My4xMi4wLXJjMi1uZXh0LTIwMTMw
OTI3LTAzMTAwLWdhMGNmMWFiOjE1Mgova2VybmVsL3g4Nl82NC1yYW5kY29uZmlnLXgxLTA5
MjgvYTBjZjFhYmMyNWFjMTk3ZGQ5N2I4NTdjMGY2MzQxMDY2YThjYjFjZi9kbWVzZy15b2N0
by14aWFuLTIyOjIwMTMxMDA1MjE1MjAxOng4Nl82NC1yYW5kY29uZmlnLXgxLTA5Mjg6My4x
Mi4wLXJjMi1uZXh0LTIwMTMwOTI3LTAzMTAwLWdhMGNmMWFiOjE1Mgova2VybmVsL3g4Nl82
NC1yYW5kY29uZmlnLXgxLTA5MjgvYTBjZjFhYmMyNWFjMTk3ZGQ5N2I4NTdjMGY2MzQxMDY2
YThjYjFjZi9kbWVzZy15b2N0by14cHMtMToyMDEzMTAwNjA1NTY0Nzp4ODZfNjQtcmFuZGNv
bmZpZy14MS0wOTI4OjMuMTIuMC1yYzItbmV4dC0yMDEzMDkyNy0wMzEwMC1nYTBjZjFhYjox
NTIKL2tlcm5lbC94ODZfNjQtcmFuZGNvbmZpZy14MS0wOTI4L2EwY2YxYWJjMjVhYzE5N2Rk
OTdiODU3YzBmNjM0MTA2NmE4Y2IxY2YvZG1lc2cteW9jdG8teHBzLTU6MjAxMzEwMDYwNTU4
NDA6eDg2XzY0LXJhbmRjb25maWcteDEtMDkyODozLjEyLjAtcmMyLW5leHQtMjAxMzA5Mjct
MDMxMDAtZ2EwY2YxYWI6MTUyCi9rZXJuZWwveDg2XzY0LXJhbmRjb25maWcteDEtMDkyOC9h
MGNmMWFiYzI1YWMxOTdkZDk3Yjg1N2MwZjYzNDEwNjZhOGNiMWNmL2RtZXNnLXlvY3RvLXhw
cy02OjIwMTMxMDA2MDYwMjI2Ong4Nl82NC1yYW5kY29uZmlnLXgxLTA5Mjg6My4xMi4wLXJj
Mi1uZXh0LTIwMTMwOTI3LTAzMTAwLWdhMGNmMWFiOjE1MgoK

--SLDf9lqlvOQaIe6s
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="config-3.12.0-rc2-02842-g45c4ea0"

#
# Automatically generated file; DO NOT EDIT.
# Linux/x86_64 3.12.0-rc2 Kernel Configuration
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
CONFIG_KERNEL_GZIP=y
# CONFIG_KERNEL_BZIP2 is not set
# CONFIG_KERNEL_LZMA is not set
# CONFIG_KERNEL_XZ is not set
# CONFIG_KERNEL_LZO is not set
# CONFIG_KERNEL_LZ4 is not set
CONFIG_DEFAULT_HOSTNAME="(none)"
# CONFIG_SYSVIPC is not set
CONFIG_POSIX_MQUEUE=y
# CONFIG_FHANDLE is not set
CONFIG_AUDIT=y
CONFIG_AUDITSYSCALL=y
CONFIG_AUDIT_WATCH=y
CONFIG_AUDIT_TREE=y
# CONFIG_AUDIT_LOGINUID_IMMUTABLE is not set

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
CONFIG_TREE_PREEMPT_RCU=y
CONFIG_PREEMPT_RCU=y
CONFIG_RCU_STALL_COMMON=y
# CONFIG_RCU_USER_QS is not set
CONFIG_RCU_FANOUT=64
CONFIG_RCU_FANOUT_LEAF=16
# CONFIG_RCU_FANOUT_EXACT is not set
# CONFIG_RCU_FAST_NO_HZ is not set
CONFIG_TREE_RCU_TRACE=y
# CONFIG_RCU_BOOST is not set
CONFIG_RCU_NOCB_CPU=y
CONFIG_RCU_NOCB_CPU_NONE=y
# CONFIG_RCU_NOCB_CPU_ZERO is not set
# CONFIG_RCU_NOCB_CPU_ALL is not set
CONFIG_IKCONFIG=y
CONFIG_LOG_BUF_SHIFT=17
CONFIG_HAVE_UNSTABLE_SCHED_CLOCK=y
CONFIG_ARCH_SUPPORTS_NUMA_BALANCING=y
CONFIG_ARCH_WANTS_PROT_NUMA_PROT_NONE=y
CONFIG_CGROUPS=y
# CONFIG_CGROUP_DEBUG is not set
# CONFIG_CGROUP_FREEZER is not set
CONFIG_CGROUP_DEVICE=y
CONFIG_CPUSETS=y
# CONFIG_PROC_PID_CPUSET is not set
# CONFIG_CGROUP_CPUACCT is not set
# CONFIG_RESOURCE_COUNTERS is not set
CONFIG_CGROUP_PERF=y
CONFIG_CGROUP_SCHED=y
CONFIG_FAIR_GROUP_SCHED=y
CONFIG_CFS_BANDWIDTH=y
# CONFIG_RT_GROUP_SCHED is not set
CONFIG_CHECKPOINT_RESTORE=y
# CONFIG_NAMESPACES is not set
# CONFIG_UIDGID_STRICT_TYPE_CHECKS is not set
CONFIG_SCHED_AUTOGROUP=y
# CONFIG_SYSFS_DEPRECATED is not set
# CONFIG_RELAY is not set
CONFIG_BLK_DEV_INITRD=y
CONFIG_INITRAMFS_SOURCE=""
CONFIG_RD_GZIP=y
# CONFIG_RD_BZIP2 is not set
# CONFIG_RD_LZMA is not set
# CONFIG_RD_XZ is not set
# CONFIG_RD_LZO is not set
# CONFIG_RD_LZ4 is not set
CONFIG_CC_OPTIMIZE_FOR_SIZE=y
CONFIG_ANON_INODES=y
CONFIG_SYSCTL_EXCEPTION_TRACE=y
CONFIG_HAVE_PCSPKR_PLATFORM=y
CONFIG_EXPERT=y
CONFIG_KALLSYMS=y
CONFIG_KALLSYMS_ALL=y
CONFIG_PRINTK=y
CONFIG_BUG=y
# CONFIG_PCSPKR_PLATFORM is not set
CONFIG_BASE_FULL=y
CONFIG_FUTEX=y
# CONFIG_EPOLL is not set
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
# CONFIG_VM_EVENT_COUNTERS is not set
CONFIG_COMPAT_BRK=y
CONFIG_SLAB=y
# CONFIG_SLUB is not set
# CONFIG_SLOB is not set
# CONFIG_PROFILING is not set
CONFIG_HAVE_OPROFILE=y
CONFIG_OPROFILE_NMI_TIMER=y
# CONFIG_JUMP_LABEL is not set
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
CONFIG_HAVE_IRQ_TIME_ACCOUNTING=y
CONFIG_HAVE_ARCH_TRANSPARENT_HUGEPAGE=y
CONFIG_HAVE_ARCH_SOFT_DIRTY=y
CONFIG_MODULES_USE_ELF_RELA=y

#
# GCOV-based kernel profiling
#
# CONFIG_GCOV_KERNEL is not set
# CONFIG_HAVE_GENERIC_DMA_COHERENT is not set
CONFIG_RT_MUTEXES=y
CONFIG_BASE_SMALL=0
# CONFIG_MODULES is not set
CONFIG_STOP_MACHINE=y
# CONFIG_BLOCK is not set
CONFIG_PREEMPT_NOTIFIERS=y
CONFIG_PADATA=y
CONFIG_ASN1=y
CONFIG_UNINLINE_SPIN_UNLOCK=y
# CONFIG_FREEZER is not set

#
# Processor type and features
#
# CONFIG_ZONE_DMA is not set
CONFIG_SMP=y
CONFIG_X86_MPPARSE=y
# CONFIG_X86_EXTENDED_PLATFORM is not set
# CONFIG_X86_INTEL_LPSS is not set
# CONFIG_SCHED_OMIT_FRAME_POINTER is not set
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
# CONFIG_PROCESSOR_SELECT is not set
CONFIG_CPU_SUP_INTEL=y
CONFIG_CPU_SUP_AMD=y
CONFIG_CPU_SUP_CENTAUR=y
CONFIG_HPET_TIMER=y
# CONFIG_DMI is not set
# CONFIG_GART_IOMMU is not set
CONFIG_CALGARY_IOMMU=y
CONFIG_CALGARY_IOMMU_ENABLED_BY_DEFAULT=y
CONFIG_SWIOTLB=y
CONFIG_IOMMU_HELPER=y
CONFIG_MAXSMP=y
CONFIG_NR_CPUS=4096
# CONFIG_SCHED_SMT is not set
CONFIG_SCHED_MC=y
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
# CONFIG_MICROCODE_INTEL is not set
# CONFIG_MICROCODE_AMD is not set
CONFIG_MICROCODE_OLD_INTERFACE=y
# CONFIG_MICROCODE_INTEL_EARLY is not set
# CONFIG_MICROCODE_AMD_EARLY is not set
CONFIG_MICROCODE_EARLY=y
# CONFIG_X86_MSR is not set
# CONFIG_X86_CPUID is not set
CONFIG_ARCH_PHYS_ADDR_T_64BIT=y
CONFIG_ARCH_DMA_ADDR_T_64BIT=y
CONFIG_DIRECT_GBPAGES=y
# CONFIG_NUMA is not set
CONFIG_ARCH_SPARSEMEM_ENABLE=y
CONFIG_ARCH_SPARSEMEM_DEFAULT=y
CONFIG_ARCH_SELECT_MEMORY_MODEL=y
CONFIG_ILLEGAL_POINTER_VALUE=0xdead000000000000
CONFIG_SELECT_MEMORY_MODEL=y
CONFIG_SPARSEMEM_MANUAL=y
CONFIG_SPARSEMEM=y
CONFIG_HAVE_MEMORY_PRESENT=y
CONFIG_SPARSEMEM_EXTREME=y
CONFIG_SPARSEMEM_VMEMMAP_ENABLE=y
CONFIG_SPARSEMEM_ALLOC_MEM_MAP_TOGETHER=y
# CONFIG_SPARSEMEM_VMEMMAP is not set
CONFIG_HAVE_MEMBLOCK=y
CONFIG_HAVE_MEMBLOCK_NODE_MAP=y
CONFIG_ARCH_DISCARD_MEMBLOCK=y
# CONFIG_HAVE_BOOTMEM_INFO_NODE is not set
# CONFIG_MEMORY_HOTPLUG is not set
CONFIG_PAGEFLAGS_EXTENDED=y
CONFIG_SPLIT_PTLOCK_CPUS=999999
# CONFIG_COMPACTION is not set
CONFIG_PHYS_ADDR_T_64BIT=y
CONFIG_ZONE_DMA_FLAG=0
CONFIG_VIRT_TO_BUS=y
CONFIG_MMU_NOTIFIER=y
CONFIG_KSM=y
CONFIG_DEFAULT_MMAP_MIN_ADDR=4096
# CONFIG_TRANSPARENT_HUGEPAGE is not set
CONFIG_CROSS_MEMORY_ATTACH=y
# CONFIG_CLEANCACHE is not set
# CONFIG_CMA is not set
# CONFIG_ZBUD is not set
CONFIG_MEM_SOFT_DIRTY=y
# CONFIG_X86_CHECK_BIOS_CORRUPTION is not set
CONFIG_X86_RESERVE_LOW=64
# CONFIG_MTRR is not set
# CONFIG_ARCH_RANDOM is not set
CONFIG_X86_SMAP=y
# CONFIG_EFI is not set
# CONFIG_SECCOMP is not set
CONFIG_CC_STACKPROTECTOR=y
# CONFIG_HZ_100 is not set
CONFIG_HZ_250=y
# CONFIG_HZ_300 is not set
# CONFIG_HZ_1000 is not set
CONFIG_HZ=250
CONFIG_SCHED_HRTICK=y
# CONFIG_KEXEC is not set
CONFIG_CRASH_DUMP=y
CONFIG_PHYSICAL_START=0x1000000
# CONFIG_RELOCATABLE is not set
CONFIG_PHYSICAL_ALIGN=0x1000000
CONFIG_HOTPLUG_CPU=y
CONFIG_BOOTPARAM_HOTPLUG_CPU0=y
# CONFIG_DEBUG_HOTPLUG_CPU0 is not set
# CONFIG_CMDLINE_BOOL is not set
CONFIG_ARCH_ENABLE_MEMORY_HOTPLUG=y

#
# Power management and ACPI options
#
# CONFIG_SUSPEND is not set
CONFIG_PM_RUNTIME=y
CONFIG_PM=y
CONFIG_PM_DEBUG=y
# CONFIG_PM_ADVANCED_DEBUG is not set
# CONFIG_WQ_POWER_EFFICIENT_DEFAULT is not set
CONFIG_ACPI=y
# CONFIG_ACPI_EC_DEBUGFS is not set
CONFIG_ACPI_AC=y
CONFIG_ACPI_BATTERY=y
CONFIG_ACPI_BUTTON=y
CONFIG_ACPI_VIDEO=y
CONFIG_ACPI_FAN=y
# CONFIG_ACPI_DOCK is not set
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
# CONFIG_ACPI_SBS is not set
# CONFIG_ACPI_HED is not set
# CONFIG_ACPI_CUSTOM_METHOD is not set
# CONFIG_ACPI_APEI is not set
# CONFIG_SFI is not set

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
# CONFIG_CPU_FREQ_DEFAULT_GOV_USERSPACE is not set
CONFIG_CPU_FREQ_DEFAULT_GOV_ONDEMAND=y
# CONFIG_CPU_FREQ_DEFAULT_GOV_CONSERVATIVE is not set
CONFIG_CPU_FREQ_GOV_PERFORMANCE=y
CONFIG_CPU_FREQ_GOV_POWERSAVE=y
# CONFIG_CPU_FREQ_GOV_USERSPACE is not set
CONFIG_CPU_FREQ_GOV_ONDEMAND=y
CONFIG_CPU_FREQ_GOV_CONSERVATIVE=y

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
CONFIG_PCIEPORTBUS=y
CONFIG_PCIEAER=y
# CONFIG_PCIE_ECRC is not set
CONFIG_PCIEAER_INJECT=y
CONFIG_PCIEASPM=y
CONFIG_PCIEASPM_DEBUG=y
# CONFIG_PCIEASPM_DEFAULT is not set
CONFIG_PCIEASPM_POWERSAVE=y
# CONFIG_PCIEASPM_PERFORMANCE is not set
CONFIG_PCIE_PME=y
CONFIG_PCI_MSI=y
# CONFIG_PCI_DEBUG is not set
CONFIG_PCI_REALLOC_ENABLE_AUTO=y
# CONFIG_PCI_STUB is not set
CONFIG_HT_IRQ=y
# CONFIG_PCI_IOV is not set
# CONFIG_PCI_PRI is not set
# CONFIG_PCI_PASID is not set
# CONFIG_PCI_IOAPIC is not set
CONFIG_PCI_LABEL=y

#
# PCI host controller drivers
#
# CONFIG_ISA_DMA_API is not set
CONFIG_AMD_NB=y
CONFIG_PCCARD=y
CONFIG_PCMCIA=y
CONFIG_PCMCIA_LOAD_CIS=y
CONFIG_CARDBUS=y

#
# PC-card bridges
#
# CONFIG_YENTA is not set
CONFIG_PD6729=y
# CONFIG_I82092 is not set
CONFIG_PCCARD_NONSTATIC=y
# CONFIG_HOTPLUG_PCI is not set
# CONFIG_RAPIDIO is not set
CONFIG_X86_SYSFB=y

#
# Executable file formats / Emulations
#
CONFIG_BINFMT_ELF=y
CONFIG_ARCH_BINFMT_ELF_RANDOMIZE_PIE=y
CONFIG_BINFMT_SCRIPT=y
# CONFIG_HAVE_AOUT is not set
# CONFIG_BINFMT_MISC is not set
# CONFIG_COREDUMP is not set
# CONFIG_IA32_EMULATION is not set
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
# CONFIG_XFRM_USER is not set
CONFIG_XFRM_SUB_POLICY=y
CONFIG_XFRM_MIGRATE=y
# CONFIG_NET_KEY is not set
CONFIG_INET=y
CONFIG_IP_MULTICAST=y
CONFIG_IP_ADVANCED_ROUTER=y
# CONFIG_IP_FIB_TRIE_STATS is not set
# CONFIG_IP_MULTIPLE_TABLES is not set
# CONFIG_IP_ROUTE_MULTIPATH is not set
# CONFIG_IP_ROUTE_VERBOSE is not set
CONFIG_IP_PNP=y
CONFIG_IP_PNP_DHCP=y
CONFIG_IP_PNP_BOOTP=y
# CONFIG_IP_PNP_RARP is not set
CONFIG_NET_IPIP=y
CONFIG_NET_IPGRE_DEMUX=y
CONFIG_NET_IP_TUNNEL=y
# CONFIG_NET_IPGRE is not set
# CONFIG_IP_MROUTE is not set
CONFIG_SYN_COOKIES=y
CONFIG_NET_IPVTI=y
CONFIG_INET_AH=y
CONFIG_INET_ESP=y
# CONFIG_INET_IPCOMP is not set
# CONFIG_INET_XFRM_TUNNEL is not set
CONFIG_INET_TUNNEL=y
CONFIG_INET_XFRM_MODE_TRANSPORT=y
CONFIG_INET_XFRM_MODE_TUNNEL=y
CONFIG_INET_XFRM_MODE_BEET=y
CONFIG_INET_LRO=y
CONFIG_INET_DIAG=y
CONFIG_INET_TCP_DIAG=y
CONFIG_INET_UDP_DIAG=y
# CONFIG_TCP_CONG_ADVANCED is not set
CONFIG_TCP_CONG_CUBIC=y
CONFIG_DEFAULT_TCP_CONG="cubic"
# CONFIG_TCP_MD5SIG is not set
# CONFIG_IPV6 is not set
CONFIG_NETWORK_SECMARK=y
# CONFIG_NETWORK_PHY_TIMESTAMPING is not set
# CONFIG_NETFILTER is not set
# CONFIG_IP_DCCP is not set
CONFIG_IP_SCTP=y
# CONFIG_SCTP_DEFAULT_COOKIE_HMAC_MD5 is not set
CONFIG_SCTP_DEFAULT_COOKIE_HMAC_SHA1=y
# CONFIG_SCTP_DEFAULT_COOKIE_HMAC_NONE is not set
CONFIG_SCTP_COOKIE_HMAC_MD5=y
CONFIG_SCTP_COOKIE_HMAC_SHA1=y
CONFIG_RDS=y
# CONFIG_RDS_TCP is not set
CONFIG_RDS_DEBUG=y
# CONFIG_TIPC is not set
# CONFIG_ATM is not set
CONFIG_L2TP=y
# CONFIG_L2TP_DEBUGFS is not set
# CONFIG_L2TP_V3 is not set
CONFIG_STP=y
CONFIG_GARP=y
CONFIG_BRIDGE=y
# CONFIG_BRIDGE_IGMP_SNOOPING is not set
# CONFIG_BRIDGE_VLAN_FILTERING is not set
CONFIG_VLAN_8021Q=y
CONFIG_VLAN_8021Q_GVRP=y
# CONFIG_VLAN_8021Q_MVRP is not set
CONFIG_DECNET=y
CONFIG_DECNET_ROUTER=y
CONFIG_LLC=y
# CONFIG_LLC2 is not set
# CONFIG_IPX is not set
# CONFIG_ATALK is not set
CONFIG_X25=y
CONFIG_LAPB=y
CONFIG_PHONET=y
CONFIG_IEEE802154=y
# CONFIG_MAC802154 is not set
# CONFIG_NET_SCHED is not set
CONFIG_DCB=y
CONFIG_DNS_RESOLVER=y
# CONFIG_BATMAN_ADV is not set
# CONFIG_OPENVSWITCH is not set
# CONFIG_VSOCKETS is not set
CONFIG_NETLINK_MMAP=y
# CONFIG_NETLINK_DIAG is not set
CONFIG_NET_MPLS_GSO=y
CONFIG_RPS=y
CONFIG_RFS_ACCEL=y
CONFIG_XPS=y
CONFIG_NETPRIO_CGROUP=y
CONFIG_NET_RX_BUSY_POLL=y
CONFIG_BQL=y
CONFIG_NET_FLOW_LIMIT=y

#
# Network testing
#
CONFIG_HAMRADIO=y

#
# Packet Radio protocols
#
# CONFIG_AX25 is not set
# CONFIG_CAN is not set
CONFIG_IRDA=y

#
# IrDA protocols
#
CONFIG_IRLAN=y
# CONFIG_IRCOMM is not set
CONFIG_IRDA_ULTRA=y

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
# CONFIG_IRTTY_SIR is not set

#
# Dongle support
#
CONFIG_KINGSUN_DONGLE=y
CONFIG_KSDAZZLE_DONGLE=y
CONFIG_KS959_DONGLE=y

#
# FIR device drivers
#
CONFIG_USB_IRDA=y
CONFIG_SIGMATEL_FIR=y
CONFIG_VLSI_FIR=y
CONFIG_MCS_FIR=y
# CONFIG_BT is not set
CONFIG_AF_RXRPC=y
CONFIG_AF_RXRPC_DEBUG=y
CONFIG_RXKAD=y
CONFIG_FIB_RULES=y
CONFIG_WIRELESS=y
CONFIG_CFG80211=y
CONFIG_NL80211_TESTMODE=y
# CONFIG_CFG80211_DEVELOPER_WARNINGS is not set
# CONFIG_CFG80211_REG_DEBUG is not set
CONFIG_CFG80211_CERTIFICATION_ONUS=y
# CONFIG_CFG80211_DEFAULT_PS is not set
CONFIG_CFG80211_DEBUGFS=y
# CONFIG_CFG80211_INTERNAL_REGDB is not set
# CONFIG_CFG80211_WEXT is not set
# CONFIG_LIB80211 is not set
# CONFIG_MAC80211 is not set
CONFIG_WIMAX=y
CONFIG_WIMAX_DEBUG_LEVEL=8
CONFIG_RFKILL=y
CONFIG_RFKILL_LEDS=y
# CONFIG_RFKILL_INPUT is not set
# CONFIG_RFKILL_REGULATOR is not set
# CONFIG_NET_9P is not set
CONFIG_CAIF=y
CONFIG_CAIF_DEBUG=y
CONFIG_CAIF_NETDEV=y
CONFIG_CAIF_USB=y
CONFIG_CEPH_LIB=y
# CONFIG_CEPH_LIB_PRETTYDEBUG is not set
# CONFIG_CEPH_LIB_USE_DNS_RESOLVER is not set
CONFIG_NFC=y
CONFIG_NFC_NCI=y
CONFIG_NFC_NCI_SPI=y
CONFIG_NFC_HCI=y
CONFIG_NFC_SHDLC=y

#
# Near Field Communication (NFC) devices
#
CONFIG_NFC_PN533=y
# CONFIG_NFC_SIM is not set
CONFIG_NFC_PN544=y
CONFIG_NFC_PN544_I2C=y
CONFIG_NFC_MICROREAD=y
# CONFIG_NFC_MICROREAD_I2C is not set
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
# CONFIG_STANDALONE is not set
CONFIG_PREVENT_FIRMWARE_BUILD=y
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
CONFIG_REGMAP_SPI=y
CONFIG_REGMAP_MMIO=y
CONFIG_REGMAP_IRQ=y
CONFIG_DMA_SHARED_BUFFER=y

#
# Bus devices
#
CONFIG_CONNECTOR=y
# CONFIG_PROC_EVENTS is not set
CONFIG_MTD=y
CONFIG_MTD_REDBOOT_PARTS=y
CONFIG_MTD_REDBOOT_DIRECTORY_BLOCK=-1
CONFIG_MTD_REDBOOT_PARTS_UNALLOCATED=y
CONFIG_MTD_REDBOOT_PARTS_READONLY=y
CONFIG_MTD_CMDLINE_PARTS=y
CONFIG_MTD_AR7_PARTS=y

#
# User Modules And Translation Layers
#
CONFIG_MTD_OOPS=y

#
# RAM/ROM/Flash chip drivers
#
CONFIG_MTD_CFI=y
CONFIG_MTD_JEDECPROBE=y
CONFIG_MTD_GEN_PROBE=y
# CONFIG_MTD_CFI_ADV_OPTIONS is not set
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
CONFIG_MTD_CFI_INTELEXT=y
CONFIG_MTD_CFI_AMDSTD=y
CONFIG_MTD_CFI_STAA=y
CONFIG_MTD_CFI_UTIL=y
CONFIG_MTD_RAM=y
CONFIG_MTD_ROM=y
CONFIG_MTD_ABSENT=y

#
# Mapping drivers for chip access
#
CONFIG_MTD_COMPLEX_MAPPINGS=y
CONFIG_MTD_PHYSMAP=y
CONFIG_MTD_PHYSMAP_COMPAT=y
CONFIG_MTD_PHYSMAP_START=0x8000000
CONFIG_MTD_PHYSMAP_LEN=0
CONFIG_MTD_PHYSMAP_BANKWIDTH=2
CONFIG_MTD_SC520CDP=y
# CONFIG_MTD_NETSC520 is not set
CONFIG_MTD_TS5500=y
CONFIG_MTD_SBC_GXX=y
CONFIG_MTD_AMD76XROM=y
# CONFIG_MTD_ICHXROM is not set
CONFIG_MTD_ESB2ROM=y
# CONFIG_MTD_CK804XROM is not set
CONFIG_MTD_SCB2_FLASH=y
# CONFIG_MTD_NETtel is not set
# CONFIG_MTD_L440GX is not set
# CONFIG_MTD_PCI is not set
# CONFIG_MTD_PCMCIA is not set
CONFIG_MTD_GPIO_ADDR=y
CONFIG_MTD_INTEL_VR_NOR=y
CONFIG_MTD_PLATRAM=y
CONFIG_MTD_LATCH_ADDR=y

#
# Self-contained MTD device drivers
#
# CONFIG_MTD_PMC551 is not set
# CONFIG_MTD_DATAFLASH is not set
CONFIG_MTD_M25P80=y
# CONFIG_M25PXX_USE_FAST_READ is not set
CONFIG_MTD_SST25L=y
CONFIG_MTD_SLRAM=y
CONFIG_MTD_PHRAM=y
# CONFIG_MTD_MTDRAM is not set

#
# Disk-On-Chip Device Drivers
#
CONFIG_MTD_DOCG3=y
CONFIG_BCH_CONST_M=14
CONFIG_BCH_CONST_T=4
CONFIG_MTD_NAND_ECC=y
# CONFIG_MTD_NAND_ECC_SMC is not set
CONFIG_MTD_NAND=y
# CONFIG_MTD_NAND_ECC_BCH is not set
# CONFIG_MTD_SM_COMMON is not set
CONFIG_MTD_NAND_DENALI=y
# CONFIG_MTD_NAND_DENALI_PCI is not set
CONFIG_MTD_NAND_GPIO=y
CONFIG_MTD_NAND_IDS=y
# CONFIG_MTD_NAND_RICOH is not set
CONFIG_MTD_NAND_DISKONCHIP=y
CONFIG_MTD_NAND_DISKONCHIP_PROBE_ADVANCED=y
CONFIG_MTD_NAND_DISKONCHIP_PROBE_ADDRESS=0
CONFIG_MTD_NAND_DISKONCHIP_PROBE_HIGH=y
CONFIG_MTD_NAND_DISKONCHIP_BBTWRITE=y
# CONFIG_MTD_NAND_DOCG4 is not set
CONFIG_MTD_NAND_CAFE=y
CONFIG_MTD_NAND_NANDSIM=y
# CONFIG_MTD_NAND_PLATFORM is not set
CONFIG_MTD_ONENAND=y
# CONFIG_MTD_ONENAND_VERIFY_WRITE is not set
# CONFIG_MTD_ONENAND_GENERIC is not set
# CONFIG_MTD_ONENAND_OTP is not set
CONFIG_MTD_ONENAND_2X_PROGRAM=y

#
# LPDDR flash memory drivers
#
# CONFIG_MTD_LPDDR is not set
# CONFIG_MTD_UBI is not set
CONFIG_PARPORT=y
CONFIG_PARPORT_PC=y
# CONFIG_PARPORT_SERIAL is not set
# CONFIG_PARPORT_PC_FIFO is not set
CONFIG_PARPORT_PC_SUPERIO=y
# CONFIG_PARPORT_PC_PCMCIA is not set
# CONFIG_PARPORT_GSC is not set
CONFIG_PARPORT_AX88796=y
# CONFIG_PARPORT_1284 is not set
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
# CONFIG_AD525X_DPOT is not set
CONFIG_DUMMY_IRQ=y
CONFIG_IBM_ASM=y
CONFIG_PHANTOM=y
# CONFIG_INTEL_MID_PTI is not set
# CONFIG_SGI_IOC4 is not set
CONFIG_TIFM_CORE=y
CONFIG_TIFM_7XX1=y
CONFIG_ICS932S401=y
CONFIG_ATMEL_SSC=y
CONFIG_ENCLOSURE_SERVICES=y
CONFIG_CS5535_MFGPT=y
CONFIG_CS5535_MFGPT_DEFAULT_IRQ=7
# CONFIG_CS5535_CLOCK_EVENT_SRC is not set
CONFIG_HP_ILO=y
CONFIG_APDS9802ALS=y
CONFIG_ISL29003=y
CONFIG_ISL29020=y
CONFIG_SENSORS_TSL2550=y
CONFIG_SENSORS_BH1780=y
CONFIG_SENSORS_BH1770=y
# CONFIG_SENSORS_APDS990X is not set
CONFIG_HMC6352=y
# CONFIG_DS1682 is not set
CONFIG_TI_DAC7512=y
CONFIG_VMWARE_BALLOON=y
# CONFIG_BMP085_I2C is not set
# CONFIG_BMP085_SPI is not set
CONFIG_PCH_PHUB=y
CONFIG_USB_SWITCH_FSA9480=y
CONFIG_LATTICE_ECP3_CONFIG=y
# CONFIG_SRAM is not set
CONFIG_C2PORT=y
CONFIG_C2PORT_DURAMAR_2150=y

#
# EEPROM support
#
CONFIG_EEPROM_AT24=y
CONFIG_EEPROM_AT25=y
CONFIG_EEPROM_LEGACY=y
# CONFIG_EEPROM_MAX6875 is not set
CONFIG_EEPROM_93CX6=y
CONFIG_EEPROM_93XX46=y
CONFIG_CB710_CORE=y
# CONFIG_CB710_DEBUG is not set
CONFIG_CB710_DEBUG_ASSUMPTIONS=y

#
# Texas Instruments shared transport line discipline
#
# CONFIG_TI_ST is not set
CONFIG_SENSORS_LIS3_I2C=y

#
# Altera FPGA firmware download module
#
CONFIG_ALTERA_STAPL=y
CONFIG_VMWARE_VMCI=y

#
# Intel MIC Host Driver
#
# CONFIG_INTEL_MIC_HOST is not set

#
# Intel MIC Card Driver
#
# CONFIG_INTEL_MIC_CARD is not set
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
CONFIG_I2O_LCT_NOTIFY_ON_CHANGES=y
CONFIG_I2O_EXT_ADAPTEC=y
CONFIG_I2O_EXT_ADAPTEC_DMA64=y
CONFIG_I2O_CONFIG=y
# CONFIG_I2O_CONFIG_OLD_IOCTL is not set
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
# CONFIG_INPUT_MATRIXKMAP is not set

#
# Userland interfaces
#
# CONFIG_INPUT_MOUSEDEV is not set
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
# CONFIG_KEYBOARD_STMPE is not set
# CONFIG_KEYBOARD_TC3589X is not set
# CONFIG_KEYBOARD_XTKBD is not set
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
CONFIG_MOUSE_BCM5974=y
CONFIG_MOUSE_CYAPA=y
CONFIG_MOUSE_VSXXXAA=y
# CONFIG_MOUSE_GPIO is not set
CONFIG_MOUSE_SYNAPTICS_I2C=y
CONFIG_MOUSE_SYNAPTICS_USB=y
CONFIG_INPUT_JOYSTICK=y
CONFIG_JOYSTICK_ANALOG=y
# CONFIG_JOYSTICK_A3D is not set
CONFIG_JOYSTICK_ADI=y
# CONFIG_JOYSTICK_COBRA is not set
CONFIG_JOYSTICK_GF2K=y
# CONFIG_JOYSTICK_GRIP is not set
CONFIG_JOYSTICK_GRIP_MP=y
# CONFIG_JOYSTICK_GUILLEMOT is not set
CONFIG_JOYSTICK_INTERACT=y
CONFIG_JOYSTICK_SIDEWINDER=y
# CONFIG_JOYSTICK_TMDC is not set
CONFIG_JOYSTICK_IFORCE=y
CONFIG_JOYSTICK_IFORCE_USB=y
# CONFIG_JOYSTICK_IFORCE_232 is not set
# CONFIG_JOYSTICK_WARRIOR is not set
CONFIG_JOYSTICK_MAGELLAN=y
CONFIG_JOYSTICK_SPACEORB=y
CONFIG_JOYSTICK_SPACEBALL=y
CONFIG_JOYSTICK_STINGER=y
CONFIG_JOYSTICK_TWIDJOY=y
CONFIG_JOYSTICK_ZHENHUA=y
# CONFIG_JOYSTICK_DB9 is not set
# CONFIG_JOYSTICK_GAMECON is not set
CONFIG_JOYSTICK_TURBOGRAFX=y
CONFIG_JOYSTICK_AS5011=y
CONFIG_JOYSTICK_JOYDUMP=y
# CONFIG_JOYSTICK_XPAD is not set
CONFIG_JOYSTICK_WALKERA0701=y
# CONFIG_INPUT_TABLET is not set
CONFIG_INPUT_TOUCHSCREEN=y
CONFIG_TOUCHSCREEN_ADS7846=y
CONFIG_TOUCHSCREEN_AD7877=y
# CONFIG_TOUCHSCREEN_AD7879 is not set
CONFIG_TOUCHSCREEN_ATMEL_MXT=y
CONFIG_TOUCHSCREEN_AUO_PIXCIR=y
CONFIG_TOUCHSCREEN_BU21013=y
# CONFIG_TOUCHSCREEN_CY8CTMG110 is not set
CONFIG_TOUCHSCREEN_CYTTSP_CORE=y
# CONFIG_TOUCHSCREEN_CYTTSP_I2C is not set
# CONFIG_TOUCHSCREEN_CYTTSP_SPI is not set
# CONFIG_TOUCHSCREEN_CYTTSP4_CORE is not set
CONFIG_TOUCHSCREEN_DA9052=y
CONFIG_TOUCHSCREEN_DYNAPRO=y
CONFIG_TOUCHSCREEN_HAMPSHIRE=y
CONFIG_TOUCHSCREEN_EETI=y
# CONFIG_TOUCHSCREEN_FUJITSU is not set
CONFIG_TOUCHSCREEN_ILI210X=y
# CONFIG_TOUCHSCREEN_GUNZE is not set
CONFIG_TOUCHSCREEN_ELO=y
# CONFIG_TOUCHSCREEN_WACOM_W8001 is not set
CONFIG_TOUCHSCREEN_WACOM_I2C=y
CONFIG_TOUCHSCREEN_MAX11801=y
CONFIG_TOUCHSCREEN_MCS5000=y
# CONFIG_TOUCHSCREEN_MMS114 is not set
CONFIG_TOUCHSCREEN_MTOUCH=y
CONFIG_TOUCHSCREEN_INEXIO=y
# CONFIG_TOUCHSCREEN_MK712 is not set
CONFIG_TOUCHSCREEN_PENMOUNT=y
CONFIG_TOUCHSCREEN_EDT_FT5X06=y
# CONFIG_TOUCHSCREEN_TOUCHRIGHT is not set
CONFIG_TOUCHSCREEN_TOUCHWIN=y
# CONFIG_TOUCHSCREEN_PIXCIR is not set
# CONFIG_TOUCHSCREEN_WM831X is not set
CONFIG_TOUCHSCREEN_USB_COMPOSITE=y
# CONFIG_TOUCHSCREEN_MC13783 is not set
# CONFIG_TOUCHSCREEN_USB_EGALAX is not set
# CONFIG_TOUCHSCREEN_USB_PANJIT is not set
# CONFIG_TOUCHSCREEN_USB_3M is not set
CONFIG_TOUCHSCREEN_USB_ITM=y
# CONFIG_TOUCHSCREEN_USB_ETURBO is not set
CONFIG_TOUCHSCREEN_USB_GUNZE=y
CONFIG_TOUCHSCREEN_USB_DMC_TSC10=y
# CONFIG_TOUCHSCREEN_USB_IRTOUCH is not set
CONFIG_TOUCHSCREEN_USB_IDEALTEK=y
# CONFIG_TOUCHSCREEN_USB_GENERAL_TOUCH is not set
# CONFIG_TOUCHSCREEN_USB_GOTOP is not set
CONFIG_TOUCHSCREEN_USB_JASTEC=y
# CONFIG_TOUCHSCREEN_USB_ELO is not set
CONFIG_TOUCHSCREEN_USB_E2I=y
# CONFIG_TOUCHSCREEN_USB_ZYTRONIC is not set
# CONFIG_TOUCHSCREEN_USB_ETT_TC45USB is not set
# CONFIG_TOUCHSCREEN_USB_NEXIO is not set
CONFIG_TOUCHSCREEN_USB_EASYTOUCH=y
# CONFIG_TOUCHSCREEN_TOUCHIT213 is not set
# CONFIG_TOUCHSCREEN_TSC_SERIO is not set
CONFIG_TOUCHSCREEN_TSC2005=y
CONFIG_TOUCHSCREEN_TSC2007=y
CONFIG_TOUCHSCREEN_PCAP=y
# CONFIG_TOUCHSCREEN_ST1232 is not set
# CONFIG_TOUCHSCREEN_STMPE is not set
CONFIG_TOUCHSCREEN_TPS6507X=y
CONFIG_INPUT_MISC=y
CONFIG_INPUT_AD714X=y
CONFIG_INPUT_AD714X_I2C=y
# CONFIG_INPUT_AD714X_SPI is not set
CONFIG_INPUT_BMA150=y
CONFIG_INPUT_MC13783_PWRBUTTON=y
# CONFIG_INPUT_MMA8450 is not set
CONFIG_INPUT_MPU3050=y
CONFIG_INPUT_APANEL=y
CONFIG_INPUT_GP2A=y
# CONFIG_INPUT_GPIO_TILT_POLLED is not set
# CONFIG_INPUT_ATLAS_BTNS is not set
CONFIG_INPUT_ATI_REMOTE2=y
CONFIG_INPUT_KEYSPAN_REMOTE=y
CONFIG_INPUT_KXTJ9=y
CONFIG_INPUT_KXTJ9_POLLED_MODE=y
# CONFIG_INPUT_POWERMATE is not set
CONFIG_INPUT_YEALINK=y
CONFIG_INPUT_CM109=y
CONFIG_INPUT_RETU_PWRBUTTON=y
CONFIG_INPUT_TWL6040_VIBRA=y
CONFIG_INPUT_UINPUT=y
# CONFIG_INPUT_PCF50633_PMU is not set
# CONFIG_INPUT_PCF8574 is not set
CONFIG_INPUT_PWM_BEEPER=y
CONFIG_INPUT_GPIO_ROTARY_ENCODER=y
# CONFIG_INPUT_DA9052_ONKEY is not set
CONFIG_INPUT_WM831X_ON=y
CONFIG_INPUT_PCAP=y
CONFIG_INPUT_ADXL34X=y
CONFIG_INPUT_ADXL34X_I2C=y
# CONFIG_INPUT_ADXL34X_SPI is not set
# CONFIG_INPUT_IMS_PCU is not set
CONFIG_INPUT_CMA3000=y
# CONFIG_INPUT_CMA3000_I2C is not set
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
CONFIG_SERIO_ALTERA_PS2=y
CONFIG_SERIO_PS2MULT=y
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
CONFIG_SERIAL_8250_PCI=y
# CONFIG_SERIAL_8250_CS is not set
CONFIG_SERIAL_8250_NR_UARTS=4
CONFIG_SERIAL_8250_RUNTIME_UARTS=4
# CONFIG_SERIAL_8250_EXTENDED is not set
# CONFIG_SERIAL_8250_DW is not set

#
# Non-8250 serial port support
#
# CONFIG_SERIAL_MAX3100 is not set
# CONFIG_SERIAL_MAX310X is not set
# CONFIG_SERIAL_MRST_MAX3110 is not set
# CONFIG_SERIAL_MFD_HSU is not set
# CONFIG_SERIAL_UARTLITE is not set
CONFIG_SERIAL_CORE=y
CONFIG_SERIAL_CORE_CONSOLE=y
# CONFIG_SERIAL_JSM is not set
# CONFIG_SERIAL_SCCNXP is not set
# CONFIG_SERIAL_TIMBERDALE is not set
# CONFIG_SERIAL_ALTERA_JTAGUART is not set
# CONFIG_SERIAL_ALTERA_UART is not set
# CONFIG_SERIAL_IFX6X60 is not set
# CONFIG_SERIAL_PCH_UART is not set
# CONFIG_SERIAL_ARC is not set
# CONFIG_SERIAL_RP2 is not set
# CONFIG_SERIAL_FSL_LPUART is not set
# CONFIG_SERIAL_ST_ASC is not set
# CONFIG_TTY_PRINTK is not set
# CONFIG_PRINTER is not set
# CONFIG_PPDEV is not set
# CONFIG_VIRTIO_CONSOLE is not set
CONFIG_IPMI_HANDLER=y
# CONFIG_IPMI_PANIC_EVENT is not set
CONFIG_IPMI_DEVICE_INTERFACE=y
CONFIG_IPMI_SI=y
CONFIG_IPMI_WATCHDOG=y
CONFIG_IPMI_POWEROFF=y
# CONFIG_HW_RANDOM is not set
CONFIG_NVRAM=y
# CONFIG_R3964 is not set
CONFIG_APPLICOM=y

#
# PCMCIA character devices
#
# CONFIG_SYNCLINK_CS is not set
CONFIG_CARDMAN_4000=y
# CONFIG_CARDMAN_4040 is not set
# CONFIG_MWAVE is not set
# CONFIG_HPET is not set
# CONFIG_HANGCHECK_TIMER is not set
CONFIG_TCG_TPM=y
# CONFIG_TCG_TIS is not set
CONFIG_TCG_TIS_I2C_INFINEON=y
CONFIG_TCG_NSC=y
# CONFIG_TCG_ATMEL is not set
# CONFIG_TCG_INFINEON is not set
# CONFIG_TCG_ST33_I2C is not set
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
CONFIG_I2C_MUX_GPIO=y
# CONFIG_I2C_MUX_PCA9541 is not set
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
# CONFIG_I2C_ALI1535 is not set
CONFIG_I2C_ALI1563=y
CONFIG_I2C_ALI15X3=y
# CONFIG_I2C_AMD756 is not set
CONFIG_I2C_AMD8111=y
CONFIG_I2C_I801=y
# CONFIG_I2C_ISCH is not set
CONFIG_I2C_ISMT=y
# CONFIG_I2C_PIIX4 is not set
# CONFIG_I2C_NFORCE2 is not set
CONFIG_I2C_SIS5595=y
CONFIG_I2C_SIS630=y
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
CONFIG_I2C_CBUS_GPIO=y
# CONFIG_I2C_DESIGNWARE_PCI is not set
CONFIG_I2C_EG20T=y
# CONFIG_I2C_GPIO is not set
CONFIG_I2C_KEMPLD=y
CONFIG_I2C_OCORES=y
CONFIG_I2C_PCA_PLATFORM=y
# CONFIG_I2C_PXA_PCI is not set
CONFIG_I2C_SIMTEC=y
CONFIG_I2C_XILINX=y

#
# External I2C/SMBus adapter drivers
#
CONFIG_I2C_DIOLAN_U2C=y
CONFIG_I2C_PARPORT=y
CONFIG_I2C_PARPORT_LIGHT=y
# CONFIG_I2C_TAOS_EVM is not set
# CONFIG_I2C_TINY_USB is not set
# CONFIG_I2C_VIPERBOARD is not set

#
# Other I2C/SMBus bus drivers
#
# CONFIG_I2C_DEBUG_CORE is not set
# CONFIG_I2C_DEBUG_ALGO is not set
# CONFIG_I2C_DEBUG_BUS is not set
CONFIG_SPI=y
CONFIG_SPI_DEBUG=y
CONFIG_SPI_MASTER=y

#
# SPI Master Controller Drivers
#
CONFIG_SPI_ALTERA=y
CONFIG_SPI_ATMEL=y
CONFIG_SPI_BCM2835=y
CONFIG_SPI_BITBANG=y
CONFIG_SPI_BUTTERFLY=y
CONFIG_SPI_EP93XX=y
# CONFIG_SPI_GPIO is not set
CONFIG_SPI_IMX=y
CONFIG_SPI_LM70_LLP=y
CONFIG_SPI_FSL_DSPI=y
CONFIG_SPI_OC_TINY=y
CONFIG_SPI_OMAP24XX=y
# CONFIG_SPI_TI_QSPI is not set
# CONFIG_SPI_OMAP_100K is not set
# CONFIG_SPI_ORION is not set
CONFIG_SPI_PXA2XX_DMA=y
CONFIG_SPI_PXA2XX=y
CONFIG_SPI_PXA2XX_PCI=y
CONFIG_SPI_SC18IS602=y
# CONFIG_SPI_SH is not set
# CONFIG_SPI_SH_HSPI is not set
CONFIG_SPI_TEGRA114=y
CONFIG_SPI_TEGRA20_SFLASH=y
# CONFIG_SPI_TEGRA20_SLINK is not set
CONFIG_SPI_TOPCLIFF_PCH=y
CONFIG_SPI_TXX9=y
CONFIG_SPI_XCOMM=y
CONFIG_SPI_XILINX=y
CONFIG_SPI_DESIGNWARE=y
CONFIG_SPI_DW_PCI=y

#
# SPI Protocol Masters
#
CONFIG_SPI_SPIDEV=y
CONFIG_SPI_TLE62X0=y
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
CONFIG_ARCH_WANT_OPTIONAL_GPIOLIB=y
CONFIG_GPIO_DEVRES=y
CONFIG_GPIOLIB=y
CONFIG_GPIO_ACPI=y
# CONFIG_DEBUG_GPIO is not set
# CONFIG_GPIO_SYSFS is not set
CONFIG_GPIO_GENERIC=y
# CONFIG_GPIO_DA9052 is not set
CONFIG_GPIO_MAX730X=y

#
# Memory mapped GPIO drivers:
#
CONFIG_GPIO_GENERIC_PLATFORM=y
# CONFIG_GPIO_IT8761E is not set
# CONFIG_GPIO_F7188X is not set
CONFIG_GPIO_TS5500=y
CONFIG_GPIO_SCH=y
CONFIG_GPIO_ICH=y
CONFIG_GPIO_VX855=y
# CONFIG_GPIO_LYNXPOINT is not set

#
# I2C GPIO expanders:
#
CONFIG_GPIO_ARIZONA=y
# CONFIG_GPIO_MAX7300 is not set
CONFIG_GPIO_MAX732X=y
# CONFIG_GPIO_MAX732X_IRQ is not set
CONFIG_GPIO_PCA953X=y
CONFIG_GPIO_PCA953X_IRQ=y
CONFIG_GPIO_PCF857X=y
CONFIG_GPIO_RC5T583=y
# CONFIG_GPIO_SX150X is not set
CONFIG_GPIO_STMPE=y
CONFIG_GPIO_TC3589X=y
CONFIG_GPIO_TPS65912=y
CONFIG_GPIO_TWL6040=y
CONFIG_GPIO_WM831X=y
CONFIG_GPIO_WM8350=y
CONFIG_GPIO_WM8994=y
CONFIG_GPIO_ADP5520=y
# CONFIG_GPIO_ADP5588 is not set

#
# PCI GPIO expanders:
#
CONFIG_GPIO_CS5535=y
CONFIG_GPIO_BT8XX=y
CONFIG_GPIO_AMD8111=y
CONFIG_GPIO_LANGWELL=y
# CONFIG_GPIO_PCH is not set
CONFIG_GPIO_ML_IOH=y
CONFIG_GPIO_TIMBERDALE=y
CONFIG_GPIO_RDC321X=y

#
# SPI GPIO expanders:
#
CONFIG_GPIO_MAX7301=y
CONFIG_GPIO_MCP23S08=y
CONFIG_GPIO_MC33880=y
# CONFIG_GPIO_74X164 is not set

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
# CONFIG_GPIO_TPS6586X is not set
CONFIG_GPIO_TPS65910=y

#
# USB GPIO expanders:
#
CONFIG_GPIO_VIPERBOARD=y
CONFIG_W1=y
# CONFIG_W1_CON is not set

#
# 1-wire Bus Masters
#
# CONFIG_W1_MASTER_MATROX is not set
CONFIG_W1_MASTER_DS2490=y
CONFIG_W1_MASTER_DS2482=y
CONFIG_W1_MASTER_DS1WM=y
CONFIG_W1_MASTER_GPIO=y

#
# 1-wire Slaves
#
# CONFIG_W1_SLAVE_THERM is not set
CONFIG_W1_SLAVE_SMEM=y
# CONFIG_W1_SLAVE_DS2408 is not set
CONFIG_W1_SLAVE_DS2413=y
CONFIG_W1_SLAVE_DS2423=y
CONFIG_W1_SLAVE_DS2431=y
CONFIG_W1_SLAVE_DS2433=y
# CONFIG_W1_SLAVE_DS2433_CRC is not set
# CONFIG_W1_SLAVE_DS2760 is not set
CONFIG_W1_SLAVE_DS2780=y
CONFIG_W1_SLAVE_DS2781=y
CONFIG_W1_SLAVE_DS28E04=y
CONFIG_W1_SLAVE_BQ27000=y
CONFIG_POWER_SUPPLY=y
CONFIG_POWER_SUPPLY_DEBUG=y
# CONFIG_PDA_POWER is not set
CONFIG_GENERIC_ADC_BATTERY=y
CONFIG_WM831X_BACKUP=y
CONFIG_WM831X_POWER=y
CONFIG_WM8350_POWER=y
CONFIG_TEST_POWER=y
CONFIG_BATTERY_DS2780=y
CONFIG_BATTERY_DS2781=y
CONFIG_BATTERY_DS2782=y
CONFIG_BATTERY_SBS=y
# CONFIG_BATTERY_BQ27x00 is not set
# CONFIG_BATTERY_DA9052 is not set
# CONFIG_BATTERY_MAX17040 is not set
CONFIG_BATTERY_MAX17042=y
CONFIG_CHARGER_PCF50633=y
# CONFIG_CHARGER_ISP1704 is not set
CONFIG_CHARGER_MAX8903=y
# CONFIG_CHARGER_LP8727 is not set
CONFIG_CHARGER_GPIO=y
# CONFIG_CHARGER_MANAGER is not set
CONFIG_CHARGER_MAX8997=y
CONFIG_CHARGER_MAX8998=y
CONFIG_CHARGER_BQ2415X=y
CONFIG_CHARGER_BQ24190=y
CONFIG_CHARGER_SMB347=y
CONFIG_BATTERY_GOLDFISH=y
# CONFIG_POWER_RESET is not set
# CONFIG_POWER_AVS is not set
CONFIG_HWMON=y
CONFIG_HWMON_VID=y
CONFIG_HWMON_DEBUG_CHIP=y

#
# Native drivers
#
CONFIG_SENSORS_AD7314=y
CONFIG_SENSORS_AD7414=y
# CONFIG_SENSORS_AD7418 is not set
CONFIG_SENSORS_ADCXX=y
# CONFIG_SENSORS_ADM1021 is not set
# CONFIG_SENSORS_ADM1025 is not set
CONFIG_SENSORS_ADM1026=y
CONFIG_SENSORS_ADM1029=y
# CONFIG_SENSORS_ADM1031 is not set
# CONFIG_SENSORS_ADM9240 is not set
CONFIG_SENSORS_ADT7X10=y
CONFIG_SENSORS_ADT7310=y
# CONFIG_SENSORS_ADT7410 is not set
CONFIG_SENSORS_ADT7411=y
CONFIG_SENSORS_ADT7462=y
CONFIG_SENSORS_ADT7470=y
# CONFIG_SENSORS_ADT7475 is not set
CONFIG_SENSORS_ASC7621=y
# CONFIG_SENSORS_K8TEMP is not set
# CONFIG_SENSORS_K10TEMP is not set
CONFIG_SENSORS_FAM15H_POWER=y
CONFIG_SENSORS_ASB100=y
CONFIG_SENSORS_ATXP1=y
CONFIG_SENSORS_DS620=y
CONFIG_SENSORS_DS1621=y
CONFIG_SENSORS_DA9052_ADC=y
# CONFIG_SENSORS_I5K_AMB is not set
CONFIG_SENSORS_F71805F=y
CONFIG_SENSORS_F71882FG=y
# CONFIG_SENSORS_F75375S is not set
CONFIG_SENSORS_FSCHMD=y
CONFIG_SENSORS_G760A=y
# CONFIG_SENSORS_G762 is not set
# CONFIG_SENSORS_GL518SM is not set
CONFIG_SENSORS_GL520SM=y
CONFIG_SENSORS_GPIO_FAN=y
CONFIG_SENSORS_HIH6130=y
# CONFIG_SENSORS_HTU21 is not set
# CONFIG_SENSORS_CORETEMP is not set
CONFIG_SENSORS_IBMAEM=y
# CONFIG_SENSORS_IBMPEX is not set
# CONFIG_SENSORS_IIO_HWMON is not set
CONFIG_SENSORS_IT87=y
CONFIG_SENSORS_JC42=y
CONFIG_SENSORS_LINEAGE=y
CONFIG_SENSORS_LM63=y
# CONFIG_SENSORS_LM70 is not set
CONFIG_SENSORS_LM73=y
# CONFIG_SENSORS_LM75 is not set
CONFIG_SENSORS_LM77=y
# CONFIG_SENSORS_LM78 is not set
CONFIG_SENSORS_LM80=y
CONFIG_SENSORS_LM83=y
# CONFIG_SENSORS_LM85 is not set
CONFIG_SENSORS_LM87=y
# CONFIG_SENSORS_LM90 is not set
# CONFIG_SENSORS_LM92 is not set
CONFIG_SENSORS_LM93=y
CONFIG_SENSORS_LTC4151=y
CONFIG_SENSORS_LTC4215=y
CONFIG_SENSORS_LTC4245=y
CONFIG_SENSORS_LTC4261=y
CONFIG_SENSORS_LM95234=y
CONFIG_SENSORS_LM95241=y
# CONFIG_SENSORS_LM95245 is not set
CONFIG_SENSORS_MAX1111=y
CONFIG_SENSORS_MAX16065=y
CONFIG_SENSORS_MAX1619=y
CONFIG_SENSORS_MAX1668=y
CONFIG_SENSORS_MAX197=y
# CONFIG_SENSORS_MAX6639 is not set
CONFIG_SENSORS_MAX6642=y
# CONFIG_SENSORS_MAX6650 is not set
# CONFIG_SENSORS_MAX6697 is not set
CONFIG_SENSORS_MCP3021=y
CONFIG_SENSORS_NCT6775=y
CONFIG_SENSORS_PC87360=y
CONFIG_SENSORS_PC87427=y
# CONFIG_SENSORS_PCF8591 is not set
CONFIG_PMBUS=y
# CONFIG_SENSORS_PMBUS is not set
CONFIG_SENSORS_ADM1275=y
# CONFIG_SENSORS_LM25066 is not set
CONFIG_SENSORS_LTC2978=y
CONFIG_SENSORS_MAX16064=y
# CONFIG_SENSORS_MAX34440 is not set
# CONFIG_SENSORS_MAX8688 is not set
CONFIG_SENSORS_UCD9000=y
CONFIG_SENSORS_UCD9200=y
CONFIG_SENSORS_ZL6100=y
CONFIG_SENSORS_SHT15=y
CONFIG_SENSORS_SHT21=y
CONFIG_SENSORS_SIS5595=y
# CONFIG_SENSORS_SMM665 is not set
# CONFIG_SENSORS_DME1737 is not set
CONFIG_SENSORS_EMC1403=y
CONFIG_SENSORS_EMC2103=y
CONFIG_SENSORS_EMC6W201=y
CONFIG_SENSORS_SMSC47M1=y
# CONFIG_SENSORS_SMSC47M192 is not set
CONFIG_SENSORS_SMSC47B397=y
# CONFIG_SENSORS_SCH56XX_COMMON is not set
CONFIG_SENSORS_ADS1015=y
# CONFIG_SENSORS_ADS7828 is not set
# CONFIG_SENSORS_ADS7871 is not set
CONFIG_SENSORS_AMC6821=y
CONFIG_SENSORS_INA209=y
# CONFIG_SENSORS_INA2XX is not set
CONFIG_SENSORS_THMC50=y
# CONFIG_SENSORS_TMP102 is not set
# CONFIG_SENSORS_TMP401 is not set
# CONFIG_SENSORS_TMP421 is not set
CONFIG_SENSORS_VIA_CPUTEMP=y
# CONFIG_SENSORS_VIA686A is not set
CONFIG_SENSORS_VT1211=y
CONFIG_SENSORS_VT8231=y
CONFIG_SENSORS_W83781D=y
CONFIG_SENSORS_W83791D=y
# CONFIG_SENSORS_W83792D is not set
CONFIG_SENSORS_W83793=y
CONFIG_SENSORS_W83795=y
# CONFIG_SENSORS_W83795_FANCTRL is not set
# CONFIG_SENSORS_W83L785TS is not set
CONFIG_SENSORS_W83L786NG=y
CONFIG_SENSORS_W83627HF=y
CONFIG_SENSORS_W83627EHF=y
CONFIG_SENSORS_WM831X=y
CONFIG_SENSORS_WM8350=y
CONFIG_SENSORS_APPLESMC=y
CONFIG_SENSORS_MC13783_ADC=y

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

#
# Texas Instruments thermal drivers
#
# CONFIG_WATCHDOG is not set
CONFIG_SSB_POSSIBLE=y

#
# Sonics Silicon Backplane
#
CONFIG_SSB=y
CONFIG_SSB_SPROM=y
CONFIG_SSB_PCIHOST_POSSIBLE=y
CONFIG_SSB_PCIHOST=y
# CONFIG_SSB_B43_PCI_BRIDGE is not set
CONFIG_SSB_PCMCIAHOST_POSSIBLE=y
# CONFIG_SSB_PCMCIAHOST is not set
CONFIG_SSB_SDIOHOST_POSSIBLE=y
CONFIG_SSB_SDIOHOST=y
CONFIG_SSB_SILENT=y
CONFIG_SSB_DRIVER_PCICORE_POSSIBLE=y
CONFIG_SSB_DRIVER_PCICORE=y
CONFIG_SSB_DRIVER_GPIO=y
CONFIG_BCMA_POSSIBLE=y

#
# Broadcom specific AMBA
#
CONFIG_BCMA=y
CONFIG_BCMA_HOST_PCI_POSSIBLE=y
# CONFIG_BCMA_HOST_PCI is not set
# CONFIG_BCMA_HOST_SOC is not set
CONFIG_BCMA_DRIVER_GMAC_CMN=y
# CONFIG_BCMA_DRIVER_GPIO is not set
# CONFIG_BCMA_DEBUG is not set

#
# Multifunction device drivers
#
CONFIG_MFD_CORE=y
CONFIG_MFD_CS5535=y
# CONFIG_MFD_AS3711 is not set
CONFIG_PMIC_ADP5520=y
CONFIG_MFD_AAT2870_CORE=y
# CONFIG_MFD_CROS_EC is not set
# CONFIG_PMIC_DA903X is not set
CONFIG_PMIC_DA9052=y
# CONFIG_MFD_DA9052_SPI is not set
CONFIG_MFD_DA9052_I2C=y
# CONFIG_MFD_DA9055 is not set
CONFIG_MFD_DA9063=y
CONFIG_MFD_MC13783=y
CONFIG_MFD_MC13XXX=y
CONFIG_MFD_MC13XXX_SPI=y
CONFIG_MFD_MC13XXX_I2C=y
# CONFIG_HTC_PASIC3 is not set
# CONFIG_HTC_I2CPLD is not set
CONFIG_LPC_ICH=y
CONFIG_LPC_SCH=y
CONFIG_MFD_JANZ_CMODIO=y
CONFIG_MFD_KEMPLD=y
# CONFIG_MFD_88PM800 is not set
CONFIG_MFD_88PM805=y
# CONFIG_MFD_88PM860X is not set
# CONFIG_MFD_MAX77686 is not set
# CONFIG_MFD_MAX77693 is not set
# CONFIG_MFD_MAX8907 is not set
# CONFIG_MFD_MAX8925 is not set
CONFIG_MFD_MAX8997=y
CONFIG_MFD_MAX8998=y
CONFIG_EZX_PCAP=y
CONFIG_MFD_VIPERBOARD=y
CONFIG_MFD_RETU=y
CONFIG_MFD_PCF50633=y
CONFIG_PCF50633_ADC=y
CONFIG_PCF50633_GPIO=y
CONFIG_MFD_RDC321X=y
# CONFIG_MFD_RTSX_PCI is not set
CONFIG_MFD_RC5T583=y
CONFIG_MFD_SEC_CORE=y
# CONFIG_MFD_SI476X_CORE is not set
# CONFIG_MFD_SM501 is not set
CONFIG_MFD_SMSC=y
# CONFIG_ABX500_CORE is not set
CONFIG_MFD_STMPE=y

#
# STMicroelectronics STMPE Interface Drivers
#
# CONFIG_STMPE_I2C is not set
# CONFIG_STMPE_SPI is not set
CONFIG_MFD_SYSCON=y
# CONFIG_MFD_TI_AM335X_TSCADC is not set
CONFIG_MFD_LP8788=y
# CONFIG_MFD_PALMAS is not set
# CONFIG_TPS6105X is not set
# CONFIG_TPS65010 is not set
CONFIG_TPS6507X=y
# CONFIG_MFD_TPS65090 is not set
# CONFIG_MFD_TPS65217 is not set
CONFIG_MFD_TPS6586X=y
CONFIG_MFD_TPS65910=y
CONFIG_MFD_TPS65912=y
CONFIG_MFD_TPS65912_I2C=y
# CONFIG_MFD_TPS65912_SPI is not set
# CONFIG_MFD_TPS80031 is not set
# CONFIG_TWL4030_CORE is not set
CONFIG_TWL6040_CORE=y
CONFIG_MFD_WL1273_CORE=y
CONFIG_MFD_LM3533=y
CONFIG_MFD_TIMBERDALE=y
CONFIG_MFD_TC3589X=y
# CONFIG_MFD_TMIO is not set
CONFIG_MFD_VX855=y
CONFIG_MFD_ARIZONA=y
# CONFIG_MFD_ARIZONA_I2C is not set
CONFIG_MFD_ARIZONA_SPI=y
CONFIG_MFD_WM5102=y
CONFIG_MFD_WM5110=y
# CONFIG_MFD_WM8997 is not set
# CONFIG_MFD_WM8400 is not set
CONFIG_MFD_WM831X=y
CONFIG_MFD_WM831X_I2C=y
CONFIG_MFD_WM831X_SPI=y
CONFIG_MFD_WM8350=y
CONFIG_MFD_WM8350_I2C=y
CONFIG_MFD_WM8994=y
CONFIG_REGULATOR=y
CONFIG_REGULATOR_DEBUG=y
CONFIG_REGULATOR_FIXED_VOLTAGE=y
CONFIG_REGULATOR_VIRTUAL_CONSUMER=y
# CONFIG_REGULATOR_USERSPACE_CONSUMER is not set
# CONFIG_REGULATOR_AD5398 is not set
# CONFIG_REGULATOR_ANATOP is not set
# CONFIG_REGULATOR_AAT2870 is not set
CONFIG_REGULATOR_DA9052=y
CONFIG_REGULATOR_DA9063=y
# CONFIG_REGULATOR_DA9210 is not set
# CONFIG_REGULATOR_FAN53555 is not set
CONFIG_REGULATOR_GPIO=y
CONFIG_REGULATOR_ISL6271A=y
CONFIG_REGULATOR_LP3971=y
# CONFIG_REGULATOR_LP3972 is not set
CONFIG_REGULATOR_LP872X=y
CONFIG_REGULATOR_LP8755=y
CONFIG_REGULATOR_LP8788=y
# CONFIG_REGULATOR_MAX1586 is not set
CONFIG_REGULATOR_MAX8649=y
CONFIG_REGULATOR_MAX8660=y
# CONFIG_REGULATOR_MAX8952 is not set
# CONFIG_REGULATOR_MAX8973 is not set
CONFIG_REGULATOR_MAX8997=y
CONFIG_REGULATOR_MAX8998=y
CONFIG_REGULATOR_MC13XXX_CORE=y
# CONFIG_REGULATOR_MC13783 is not set
CONFIG_REGULATOR_MC13892=y
CONFIG_REGULATOR_PCAP=y
CONFIG_REGULATOR_PCF50633=y
CONFIG_REGULATOR_PFUZE100=y
# CONFIG_REGULATOR_RC5T583 is not set
# CONFIG_REGULATOR_S2MPS11 is not set
CONFIG_REGULATOR_S5M8767=y
CONFIG_REGULATOR_TPS51632=y
CONFIG_REGULATOR_TPS62360=y
CONFIG_REGULATOR_TPS65023=y
CONFIG_REGULATOR_TPS6507X=y
CONFIG_REGULATOR_TPS6524X=y
CONFIG_REGULATOR_TPS6586X=y
CONFIG_REGULATOR_TPS65910=y
CONFIG_REGULATOR_TPS65912=y
# CONFIG_REGULATOR_WM831X is not set
CONFIG_REGULATOR_WM8350=y
CONFIG_REGULATOR_WM8994=y
# CONFIG_MEDIA_SUPPORT is not set

#
# Graphics support
#
CONFIG_AGP=y
# CONFIG_AGP_AMD64 is not set
CONFIG_AGP_INTEL=y
CONFIG_AGP_SIS=y
CONFIG_AGP_VIA=y
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
CONFIG_DRM_TDFX=y
# CONFIG_DRM_R128 is not set
CONFIG_DRM_RADEON=y
# CONFIG_DRM_RADEON_UMS is not set
CONFIG_DRM_NOUVEAU=y
CONFIG_NOUVEAU_DEBUG=5
CONFIG_NOUVEAU_DEBUG_DEFAULT=3
# CONFIG_DRM_NOUVEAU_BACKLIGHT is not set
# CONFIG_DRM_I915 is not set
CONFIG_DRM_MGA=y
# CONFIG_DRM_SIS is not set
CONFIG_DRM_VIA=y
CONFIG_DRM_SAVAGE=y
CONFIG_DRM_VMWGFX=y
# CONFIG_DRM_VMWGFX_FBCON is not set
# CONFIG_DRM_GMA500 is not set
CONFIG_DRM_UDL=y
CONFIG_DRM_AST=y
CONFIG_DRM_MGAG200=y
CONFIG_DRM_CIRRUS_QEMU=y
CONFIG_DRM_QXL=y
CONFIG_VGASTATE=y
CONFIG_VIDEO_OUTPUT_CONTROL=y
CONFIG_HDMI=y
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
CONFIG_FB_FOREIGN_ENDIAN=y
CONFIG_FB_BOTH_ENDIAN=y
# CONFIG_FB_BIG_ENDIAN is not set
# CONFIG_FB_LITTLE_ENDIAN is not set
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
# CONFIG_FB_CIRRUS is not set
CONFIG_FB_PM2=y
# CONFIG_FB_PM2_FIFO_DISCONNECT is not set
CONFIG_FB_CYBER2000=y
# CONFIG_FB_CYBER2000_DDC is not set
# CONFIG_FB_ARC is not set
# CONFIG_FB_ASILIANT is not set
# CONFIG_FB_IMSTT is not set
# CONFIG_FB_VGA16 is not set
CONFIG_FB_UVESA=y
# CONFIG_FB_VESA is not set
CONFIG_FB_N411=y
CONFIG_FB_HGA=y
CONFIG_FB_S1D13XXX=y
# CONFIG_FB_NVIDIA is not set
# CONFIG_FB_RIVA is not set
CONFIG_FB_I740=y
CONFIG_FB_LE80578=y
CONFIG_FB_CARILLO_RANCH=y
# CONFIG_FB_INTEL is not set
# CONFIG_FB_MATROX is not set
CONFIG_FB_RADEON=y
CONFIG_FB_RADEON_I2C=y
# CONFIG_FB_RADEON_BACKLIGHT is not set
# CONFIG_FB_RADEON_DEBUG is not set
CONFIG_FB_ATY128=y
CONFIG_FB_ATY128_BACKLIGHT=y
CONFIG_FB_ATY=y
CONFIG_FB_ATY_CT=y
# CONFIG_FB_ATY_GENERIC_LCD is not set
CONFIG_FB_ATY_GX=y
CONFIG_FB_ATY_BACKLIGHT=y
CONFIG_FB_S3=y
# CONFIG_FB_S3_DDC is not set
# CONFIG_FB_SAVAGE is not set
CONFIG_FB_SIS=y
# CONFIG_FB_SIS_300 is not set
# CONFIG_FB_SIS_315 is not set
CONFIG_FB_VIA=y
CONFIG_FB_VIA_DIRECT_PROCFS=y
# CONFIG_FB_VIA_X_COMPATIBILITY is not set
CONFIG_FB_NEOMAGIC=y
CONFIG_FB_KYRO=y
# CONFIG_FB_3DFX is not set
# CONFIG_FB_VOODOO1 is not set
CONFIG_FB_VT8623=y
CONFIG_FB_TRIDENT=y
# CONFIG_FB_ARK is not set
CONFIG_FB_PM3=y
CONFIG_FB_CARMINE=y
CONFIG_FB_CARMINE_DRAM_EVAL=y
# CONFIG_CARMINE_DRAM_CUSTOM is not set
# CONFIG_FB_GEODE is not set
CONFIG_FB_TMIO=y
# CONFIG_FB_TMIO_ACCELL is not set
CONFIG_FB_SMSCUFX=y
CONFIG_FB_UDL=y
CONFIG_FB_GOLDFISH=y
# CONFIG_FB_VIRTUAL is not set
CONFIG_FB_METRONOME=y
CONFIG_FB_MB862XX=y
CONFIG_FB_MB862XX_PCI_GDC=y
# CONFIG_FB_MB862XX_I2C is not set
# CONFIG_FB_BROADSHEET is not set
# CONFIG_FB_AUO_K190X is not set
# CONFIG_FB_SIMPLE is not set
# CONFIG_EXYNOS_VIDEO is not set
CONFIG_BACKLIGHT_LCD_SUPPORT=y
CONFIG_LCD_CLASS_DEVICE=y
# CONFIG_LCD_L4F00242T03 is not set
CONFIG_LCD_LMS283GF05=y
CONFIG_LCD_LTV350QV=y
# CONFIG_LCD_ILI922X is not set
# CONFIG_LCD_ILI9320 is not set
CONFIG_LCD_TDO24M=y
# CONFIG_LCD_VGG2432A4 is not set
CONFIG_LCD_PLATFORM=y
# CONFIG_LCD_S6E63M0 is not set
CONFIG_LCD_LD9040=y
# CONFIG_LCD_AMS369FG06 is not set
CONFIG_LCD_LMS501KF03=y
CONFIG_LCD_HX8357=y
CONFIG_BACKLIGHT_CLASS_DEVICE=y
CONFIG_BACKLIGHT_GENERIC=y
# CONFIG_BACKLIGHT_LM3533 is not set
CONFIG_BACKLIGHT_CARILLO_RANCH=y
CONFIG_BACKLIGHT_PWM=y
# CONFIG_BACKLIGHT_DA9052 is not set
# CONFIG_BACKLIGHT_APPLE is not set
CONFIG_BACKLIGHT_SAHARA=y
CONFIG_BACKLIGHT_WM831X=y
CONFIG_BACKLIGHT_ADP5520=y
# CONFIG_BACKLIGHT_ADP8860 is not set
# CONFIG_BACKLIGHT_ADP8870 is not set
CONFIG_BACKLIGHT_PCF50633=y
CONFIG_BACKLIGHT_AAT2870=y
CONFIG_BACKLIGHT_LM3630=y
CONFIG_BACKLIGHT_LM3639=y
CONFIG_BACKLIGHT_LP855X=y
# CONFIG_BACKLIGHT_LP8788 is not set
# CONFIG_BACKLIGHT_OT200 is not set
CONFIG_BACKLIGHT_GPIO=y
CONFIG_BACKLIGHT_LV5207LP=y
# CONFIG_BACKLIGHT_BD6107 is not set
# CONFIG_LOGO is not set
# CONFIG_SOUND is not set

#
# HID support
#
CONFIG_HID=y
CONFIG_HID_BATTERY_STRENGTH=y
# CONFIG_HIDRAW is not set
# CONFIG_UHID is not set
# CONFIG_HID_GENERIC is not set

#
# Special HID drivers
#
CONFIG_HID_A4TECH=y
CONFIG_HID_ACRUX=y
# CONFIG_HID_ACRUX_FF is not set
# CONFIG_HID_APPLE is not set
CONFIG_HID_APPLEIR=y
# CONFIG_HID_AUREAL is not set
CONFIG_HID_BELKIN=y
# CONFIG_HID_CHERRY is not set
CONFIG_HID_CHICONY=y
CONFIG_HID_CYPRESS=y
# CONFIG_HID_DRAGONRISE is not set
CONFIG_HID_EMS_FF=y
# CONFIG_HID_ELECOM is not set
CONFIG_HID_ELO=y
CONFIG_HID_EZKEY=y
# CONFIG_HID_HOLTEK is not set
CONFIG_HID_HUION=y
# CONFIG_HID_KEYTOUCH is not set
CONFIG_HID_KYE=y
# CONFIG_HID_UCLOGIC is not set
CONFIG_HID_WALTOP=y
# CONFIG_HID_GYRATION is not set
CONFIG_HID_ICADE=y
# CONFIG_HID_TWINHAN is not set
CONFIG_HID_KENSINGTON=y
CONFIG_HID_LCPOWER=y
CONFIG_HID_LENOVO_TPKBD=y
CONFIG_HID_LOGITECH=y
CONFIG_HID_LOGITECH_DJ=y
CONFIG_LOGITECH_FF=y
# CONFIG_LOGIRUMBLEPAD2_FF is not set
CONFIG_LOGIG940_FF=y
CONFIG_LOGIWHEELS_FF=y
CONFIG_HID_MAGICMOUSE=y
# CONFIG_HID_MICROSOFT is not set
# CONFIG_HID_MONTEREY is not set
CONFIG_HID_MULTITOUCH=y
CONFIG_HID_NTRIG=y
CONFIG_HID_ORTEK=y
CONFIG_HID_PANTHERLORD=y
# CONFIG_PANTHERLORD_FF is not set
# CONFIG_HID_PETALYNX is not set
CONFIG_HID_PICOLCD=y
# CONFIG_HID_PICOLCD_FB is not set
# CONFIG_HID_PICOLCD_BACKLIGHT is not set
# CONFIG_HID_PICOLCD_LCD is not set
# CONFIG_HID_PICOLCD_LEDS is not set
# CONFIG_HID_PRIMAX is not set
CONFIG_HID_ROCCAT=y
CONFIG_HID_SAITEK=y
CONFIG_HID_SAMSUNG=y
CONFIG_HID_SONY=y
CONFIG_HID_SPEEDLINK=y
CONFIG_HID_STEELSERIES=y
CONFIG_HID_SUNPLUS=y
CONFIG_HID_GREENASIA=y
CONFIG_GREENASIA_FF=y
# CONFIG_HID_SMARTJOYPLUS is not set
# CONFIG_HID_TIVO is not set
# CONFIG_HID_TOPSEED is not set
CONFIG_HID_THINGM=y
# CONFIG_HID_THRUSTMASTER is not set
# CONFIG_HID_WACOM is not set
CONFIG_HID_WIIMOTE=y
CONFIG_HID_XINMO=y
CONFIG_HID_ZEROPLUS=y
# CONFIG_ZEROPLUS_FF is not set
CONFIG_HID_ZYDACRON=y
CONFIG_HID_SENSOR_HUB=y

#
# USB HID support
#
CONFIG_USB_HID=y
CONFIG_HID_PID=y
CONFIG_USB_HIDDEV=y

#
# I2C HID support
#
# CONFIG_I2C_HID is not set
CONFIG_USB_OHCI_LITTLE_ENDIAN=y
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
# CONFIG_USB_DYNAMIC_MINORS is not set
# CONFIG_USB_OTG is not set
# CONFIG_USB_OTG_WHITELIST is not set
CONFIG_USB_OTG_BLACKLIST_HUB=y
# CONFIG_USB_MON is not set
CONFIG_USB_WUSB=y
# CONFIG_USB_WUSB_CBAF is not set

#
# USB Host Controller Drivers
#
# CONFIG_USB_C67X00_HCD is not set
CONFIG_USB_XHCI_HCD=y
CONFIG_USB_XHCI_PLATFORM=y
# CONFIG_USB_EHCI_HCD is not set
CONFIG_USB_OXU210HP_HCD=y
CONFIG_USB_ISP116X_HCD=y
CONFIG_USB_ISP1760_HCD=y
# CONFIG_USB_ISP1362_HCD is not set
CONFIG_USB_FUSBH200_HCD=y
# CONFIG_USB_FOTG210_HCD is not set
CONFIG_USB_OHCI_HCD=y
CONFIG_USB_OHCI_HCD_PCI=y
# CONFIG_USB_OHCI_HCD_SSB is not set
CONFIG_USB_OHCI_HCD_PLATFORM=y
CONFIG_USB_UHCI_HCD=y
CONFIG_USB_U132_HCD=y
CONFIG_USB_SL811_HCD=y
# CONFIG_USB_SL811_HCD_ISO is not set
CONFIG_USB_SL811_CS=y
# CONFIG_USB_R8A66597_HCD is not set
CONFIG_USB_WHCI_HCD=y
CONFIG_USB_HWA_HCD=y
CONFIG_USB_HCD_BCMA=y
CONFIG_USB_HCD_SSB=y
CONFIG_USB_HCD_TEST_MODE=y

#
# USB Device Class drivers
#
# CONFIG_USB_ACM is not set
# CONFIG_USB_PRINTER is not set
CONFIG_USB_WDM=y
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
# CONFIG_USB_MDC800 is not set
CONFIG_USB_DWC3=y
CONFIG_USB_DWC3_HOST=y

#
# Platform Glue Driver Support
#
# CONFIG_USB_DWC3_OMAP is not set
# CONFIG_USB_DWC3_EXYNOS is not set
# CONFIG_USB_DWC3_PCI is not set

#
# Debugging features
#
CONFIG_USB_DWC3_DEBUG=y
CONFIG_USB_DWC3_VERBOSE=y

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
CONFIG_USB_LEGOTOWER=y
CONFIG_USB_LCD=y
CONFIG_USB_LED=y
# CONFIG_USB_CYPRESS_CY7C63 is not set
# CONFIG_USB_CYTHERM is not set
CONFIG_USB_IDMOUSE=y
CONFIG_USB_FTDI_ELAN=y
CONFIG_USB_APPLEDISPLAY=y
CONFIG_USB_LD=y
CONFIG_USB_TRANCEVIBRATOR=y
# CONFIG_USB_IOWARRIOR is not set
CONFIG_USB_TEST=y
CONFIG_USB_EHSET_TEST_FIXTURE=y
# CONFIG_USB_ISIGHTFW is not set
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
# CONFIG_AM335X_PHY_USB is not set
CONFIG_SAMSUNG_USBPHY=y
# CONFIG_SAMSUNG_USB2PHY is not set
CONFIG_SAMSUNG_USB3PHY=y
CONFIG_USB_GPIO_VBUS=y
# CONFIG_USB_ISP1301 is not set
CONFIG_USB_RCAR_PHY=y
# CONFIG_USB_GADGET is not set
CONFIG_UWB=y
CONFIG_UWB_HWA=y
CONFIG_UWB_WHCI=y
# CONFIG_UWB_I1480U is not set
CONFIG_MMC=y
# CONFIG_MMC_DEBUG is not set
# CONFIG_MMC_UNSAFE_RESUME is not set
CONFIG_MMC_CLKGATE=y

#
# MMC/SD/SDIO Card Drivers
#
# CONFIG_SDIO_UART is not set
CONFIG_MMC_TEST=y

#
# MMC/SD/SDIO Host Controller Drivers
#
CONFIG_MMC_SDHCI=y
CONFIG_MMC_SDHCI_PCI=y
CONFIG_MMC_RICOH_MMC=y
# CONFIG_MMC_SDHCI_ACPI is not set
CONFIG_MMC_SDHCI_PLTFM=y
# CONFIG_MMC_OMAP_HS is not set
CONFIG_MMC_TIFM_SD=y
CONFIG_MMC_SPI=y
CONFIG_MMC_SDRICOH_CS=y
CONFIG_MMC_CB710=y
# CONFIG_MMC_VIA_SDMMC is not set
CONFIG_MMC_VUB300=y
CONFIG_MMC_USHC=y
CONFIG_MEMSTICK=y
CONFIG_MEMSTICK_DEBUG=y

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
CONFIG_NEW_LEDS=y
CONFIG_LEDS_CLASS=y

#
# LED drivers
#
CONFIG_LEDS_LM3530=y
CONFIG_LEDS_LM3533=y
# CONFIG_LEDS_LM3642 is not set
CONFIG_LEDS_PCA9532=y
# CONFIG_LEDS_PCA9532_GPIO is not set
# CONFIG_LEDS_GPIO is not set
CONFIG_LEDS_LP3944=y
CONFIG_LEDS_LP55XX_COMMON=y
CONFIG_LEDS_LP5521=y
CONFIG_LEDS_LP5523=y
CONFIG_LEDS_LP5562=y
# CONFIG_LEDS_LP8501 is not set
CONFIG_LEDS_LP8788=y
CONFIG_LEDS_PCA955X=y
# CONFIG_LEDS_PCA963X is not set
# CONFIG_LEDS_WM831X_STATUS is not set
CONFIG_LEDS_WM8350=y
CONFIG_LEDS_DA9052=y
# CONFIG_LEDS_DAC124S085 is not set
CONFIG_LEDS_PWM=y
# CONFIG_LEDS_REGULATOR is not set
CONFIG_LEDS_BD2802=y
CONFIG_LEDS_LT3593=y
CONFIG_LEDS_ADP5520=y
# CONFIG_LEDS_DELL_NETBOOKS is not set
# CONFIG_LEDS_MC13783 is not set
# CONFIG_LEDS_TCA6507 is not set
CONFIG_LEDS_MAX8997=y
# CONFIG_LEDS_LM355x is not set
CONFIG_LEDS_OT200=y
CONFIG_LEDS_BLINKM=y

#
# LED Triggers
#
CONFIG_LEDS_TRIGGERS=y
# CONFIG_LEDS_TRIGGER_TIMER is not set
# CONFIG_LEDS_TRIGGER_ONESHOT is not set
# CONFIG_LEDS_TRIGGER_HEARTBEAT is not set
# CONFIG_LEDS_TRIGGER_BACKLIGHT is not set
CONFIG_LEDS_TRIGGER_CPU=y
CONFIG_LEDS_TRIGGER_GPIO=y
CONFIG_LEDS_TRIGGER_DEFAULT_ON=y

#
# iptables trigger is under Netfilter config (LED target)
#
CONFIG_LEDS_TRIGGER_TRANSIENT=y
# CONFIG_LEDS_TRIGGER_CAMERA is not set
CONFIG_ACCESSIBILITY=y
# CONFIG_INFINIBAND is not set
CONFIG_EDAC=y
# CONFIG_EDAC_LEGACY_SYSFS is not set
CONFIG_EDAC_DEBUG=y
# CONFIG_EDAC_MM_EDAC is not set
CONFIG_RTC_LIB=y
CONFIG_RTC_CLASS=y
CONFIG_RTC_HCTOSYS=y
# CONFIG_RTC_SYSTOHC is not set
CONFIG_RTC_HCTOSYS_DEVICE="rtc0"
CONFIG_RTC_DEBUG=y

#
# RTC interfaces
#
# CONFIG_RTC_INTF_SYSFS is not set
CONFIG_RTC_INTF_DEV=y
CONFIG_RTC_INTF_DEV_UIE_EMUL=y
CONFIG_RTC_DRV_TEST=y

#
# I2C RTC drivers
#
CONFIG_RTC_DRV_DS1307=y
# CONFIG_RTC_DRV_DS1374 is not set
# CONFIG_RTC_DRV_DS1672 is not set
CONFIG_RTC_DRV_DS3232=y
# CONFIG_RTC_DRV_LP8788 is not set
CONFIG_RTC_DRV_MAX6900=y
CONFIG_RTC_DRV_MAX8998=y
CONFIG_RTC_DRV_MAX8997=y
# CONFIG_RTC_DRV_RS5C372 is not set
CONFIG_RTC_DRV_ISL1208=y
CONFIG_RTC_DRV_ISL12022=y
CONFIG_RTC_DRV_X1205=y
CONFIG_RTC_DRV_PCF2127=y
CONFIG_RTC_DRV_PCF8523=y
# CONFIG_RTC_DRV_PCF8563 is not set
CONFIG_RTC_DRV_PCF8583=y
CONFIG_RTC_DRV_M41T80=y
CONFIG_RTC_DRV_M41T80_WDT=y
# CONFIG_RTC_DRV_BQ32K is not set
CONFIG_RTC_DRV_TPS6586X=y
CONFIG_RTC_DRV_TPS65910=y
CONFIG_RTC_DRV_RC5T583=y
CONFIG_RTC_DRV_S35390A=y
CONFIG_RTC_DRV_FM3130=y
CONFIG_RTC_DRV_RX8581=y
# CONFIG_RTC_DRV_RX8025 is not set
# CONFIG_RTC_DRV_EM3027 is not set
CONFIG_RTC_DRV_RV3029C2=y

#
# SPI RTC drivers
#
CONFIG_RTC_DRV_M41T93=y
CONFIG_RTC_DRV_M41T94=y
CONFIG_RTC_DRV_DS1305=y
CONFIG_RTC_DRV_DS1390=y
CONFIG_RTC_DRV_MAX6902=y
CONFIG_RTC_DRV_R9701=y
CONFIG_RTC_DRV_RS5C348=y
CONFIG_RTC_DRV_DS3234=y
CONFIG_RTC_DRV_PCF2123=y
CONFIG_RTC_DRV_RX4581=y

#
# Platform RTC drivers
#
# CONFIG_RTC_DRV_CMOS is not set
CONFIG_RTC_DRV_DS1286=y
CONFIG_RTC_DRV_DS1511=y
# CONFIG_RTC_DRV_DS1553 is not set
CONFIG_RTC_DRV_DS1742=y
# CONFIG_RTC_DRV_DA9052 is not set
# CONFIG_RTC_DRV_STK17TA8 is not set
CONFIG_RTC_DRV_M48T86=y
CONFIG_RTC_DRV_M48T35=y
CONFIG_RTC_DRV_M48T59=y
CONFIG_RTC_DRV_MSM6242=y
CONFIG_RTC_DRV_BQ4802=y
CONFIG_RTC_DRV_RP5C01=y
# CONFIG_RTC_DRV_V3020 is not set
# CONFIG_RTC_DRV_DS2404 is not set
# CONFIG_RTC_DRV_WM831X is not set
CONFIG_RTC_DRV_WM8350=y
CONFIG_RTC_DRV_PCF50633=y

#
# on-CPU RTC drivers
#
CONFIG_RTC_DRV_PCAP=y
CONFIG_RTC_DRV_MC13XXX=y
# CONFIG_RTC_DRV_MOXART is not set

#
# HID Sensor RTC drivers
#
CONFIG_RTC_DRV_HID_SENSOR_TIME=y
# CONFIG_DMADEVICES is not set
# CONFIG_AUXDISPLAY is not set
CONFIG_UIO=y
CONFIG_UIO_CIF=y
# CONFIG_UIO_PDRV_GENIRQ is not set
CONFIG_UIO_DMEM_GENIRQ=y
# CONFIG_UIO_AEC is not set
CONFIG_UIO_SERCOS3=y
CONFIG_UIO_PCI_GENERIC=y
CONFIG_UIO_NETX=y
# CONFIG_UIO_MF624 is not set
# CONFIG_VIRT_DRIVERS is not set
CONFIG_VIRTIO=y

#
# Virtio drivers
#
# CONFIG_VIRTIO_PCI is not set
CONFIG_VIRTIO_BALLOON=y
CONFIG_VIRTIO_MMIO=y
CONFIG_VIRTIO_MMIO_CMDLINE_DEVICES=y

#
# Microsoft Hyper-V guest support
#
# CONFIG_HYPERV is not set
CONFIG_STAGING=y
CONFIG_SLICOSS=y
CONFIG_USBIP_CORE=y
CONFIG_USBIP_VHCI_HCD=y
CONFIG_USBIP_HOST=y
CONFIG_USBIP_DEBUG=y
CONFIG_ECHO=y
# CONFIG_PANEL is not set
CONFIG_TRANZPORT=y
# CONFIG_DX_SEP is not set

#
# IIO staging drivers
#

#
# Accelerometers
#
# CONFIG_ADIS16201 is not set
# CONFIG_ADIS16203 is not set
CONFIG_ADIS16204=y
CONFIG_ADIS16209=y
# CONFIG_ADIS16220 is not set
CONFIG_ADIS16240=y
CONFIG_LIS3L02DQ=y
CONFIG_SCA3000=y

#
# Analog to digital converters
#
CONFIG_AD7291=y
CONFIG_AD7606=y
# CONFIG_AD7606_IFACE_PARALLEL is not set
# CONFIG_AD7606_IFACE_SPI is not set
CONFIG_AD799X=y
CONFIG_AD799X_RING_BUFFER=y
# CONFIG_AD7780 is not set
# CONFIG_AD7816 is not set
# CONFIG_AD7192 is not set
CONFIG_AD7280=y

#
# Analog digital bi-direction converters
#
# CONFIG_ADT7316 is not set

#
# Capacitance to digital converters
#
# CONFIG_AD7150 is not set
CONFIG_AD7152=y
# CONFIG_AD7746 is not set

#
# Direct Digital Synthesis
#
CONFIG_AD5930=y
CONFIG_AD9832=y
CONFIG_AD9834=y
# CONFIG_AD9850 is not set
CONFIG_AD9852=y
CONFIG_AD9910=y
# CONFIG_AD9951 is not set

#
# Digital gyroscope sensors
#
CONFIG_ADIS16060=y

#
# Network Analyzer, Impedance Converters
#
CONFIG_AD5933=y

#
# Light sensors
#
CONFIG_SENSORS_ISL29018=y
CONFIG_SENSORS_ISL29028=y
# CONFIG_TSL2583 is not set
# CONFIG_TSL2x7x is not set

#
# Magnetometer sensors
#
# CONFIG_SENSORS_HMC5843 is not set

#
# Active energy metering IC
#
# CONFIG_ADE7753 is not set
CONFIG_ADE7754=y
# CONFIG_ADE7758 is not set
CONFIG_ADE7759=y
CONFIG_ADE7854=y
CONFIG_ADE7854_I2C=y
CONFIG_ADE7854_SPI=y

#
# Resolver to digital converters
#
CONFIG_AD2S90=y
CONFIG_AD2S1200=y
CONFIG_AD2S1210=y

#
# Triggers - standalone
#
CONFIG_IIO_PERIODIC_RTC_TRIGGER=y
CONFIG_IIO_SIMPLE_DUMMY=y
# CONFIG_IIO_SIMPLE_DUMMY_EVENTS is not set
CONFIG_IIO_SIMPLE_DUMMY_BUFFER=y
CONFIG_ZSMALLOC=y
CONFIG_FB_SM7XX=y
CONFIG_CRYSTALHD=y
CONFIG_FB_XGI=y
# CONFIG_ACPI_QUICKSTART is not set
# CONFIG_BCM_WIMAX is not set
CONFIG_FT1000=y
CONFIG_FT1000_USB=y
CONFIG_FT1000_PCMCIA=y

#
# Speakup console speech
#
CONFIG_TOUCHSCREEN_CLEARPAD_TM1217=y
CONFIG_TOUCHSCREEN_SYNAPTICS_I2C_RMI4=y
# CONFIG_STAGING_MEDIA is not set

#
# Android
#
# CONFIG_ANDROID is not set
# CONFIG_USB_WPAN_HCD is not set
CONFIG_WIMAX_GDM72XX=y
# CONFIG_WIMAX_GDM72XX_QOS is not set
# CONFIG_WIMAX_GDM72XX_K_MODE is not set
# CONFIG_WIMAX_GDM72XX_WIMAX2 is not set
CONFIG_WIMAX_GDM72XX_USB=y
# CONFIG_WIMAX_GDM72XX_SDIO is not set
CONFIG_WIMAX_GDM72XX_USB_PM=y
CONFIG_CED1401=y
# CONFIG_DGRP is not set
CONFIG_USB_DWC2=y
# CONFIG_USB_DWC2_DEBUG is not set
# CONFIG_USB_DWC2_TRACK_MISSED_SOFS is not set
# CONFIG_XILLYBUS is not set
# CONFIG_DGNC is not set
# CONFIG_DGAP is not set
CONFIG_X86_PLATFORM_DEVICES=y
# CONFIG_ACER_WMI is not set
# CONFIG_ACERHDF is not set
# CONFIG_ASUS_LAPTOP is not set
# CONFIG_DELL_LAPTOP is not set
# CONFIG_DELL_WMI is not set
# CONFIG_DELL_WMI_AIO is not set
# CONFIG_FUJITSU_LAPTOP is not set
# CONFIG_FUJITSU_TABLET is not set
# CONFIG_AMILO_RFKILL is not set
# CONFIG_HP_ACCEL is not set
# CONFIG_HP_WMI is not set
# CONFIG_MSI_LAPTOP is not set
# CONFIG_PANASONIC_LAPTOP is not set
# CONFIG_COMPAL_LAPTOP is not set
# CONFIG_SONY_LAPTOP is not set
# CONFIG_IDEAPAD_LAPTOP is not set
# CONFIG_THINKPAD_ACPI is not set
# CONFIG_SENSORS_HDAPS is not set
# CONFIG_INTEL_MENLOW is not set
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
CONFIG_MXM_WMI=y
# CONFIG_INTEL_OAKTRAIL is not set
# CONFIG_SAMSUNG_Q10 is not set
# CONFIG_APPLE_GMUX is not set
# CONFIG_INTEL_RST is not set
# CONFIG_INTEL_SMARTCONNECT is not set
# CONFIG_PVPANIC is not set

#
# Hardware Spinlock drivers
#
CONFIG_CLKEVT_I8253=y
CONFIG_CLKBLD_I8253=y
CONFIG_MAILBOX=y
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
CONFIG_EXTCON=y

#
# Extcon Device Drivers
#
# CONFIG_EXTCON_GPIO is not set
CONFIG_EXTCON_ADC_JACK=y
# CONFIG_EXTCON_MAX8997 is not set
# CONFIG_MEMORY is not set
CONFIG_IIO=y
CONFIG_IIO_BUFFER=y
# CONFIG_IIO_BUFFER_CB is not set
CONFIG_IIO_KFIFO_BUF=y
CONFIG_IIO_TRIGGERED_BUFFER=y
CONFIG_IIO_TRIGGER=y
CONFIG_IIO_CONSUMERS_PER_TRIGGER=2

#
# Accelerometers
#
CONFIG_BMA180=y
CONFIG_HID_SENSOR_ACCEL_3D=y
# CONFIG_IIO_ST_ACCEL_3AXIS is not set
CONFIG_KXSD9=y

#
# Analog to digital converters
#
CONFIG_AD_SIGMA_DELTA=y
# CONFIG_AD7266 is not set
# CONFIG_AD7298 is not set
# CONFIG_AD7476 is not set
CONFIG_AD7791=y
# CONFIG_AD7793 is not set
# CONFIG_AD7887 is not set
CONFIG_AD7923=y
# CONFIG_LP8788_ADC is not set
CONFIG_MAX1363=y
CONFIG_MCP320X=y
# CONFIG_MCP3422 is not set
CONFIG_NAU7802=y
CONFIG_TI_ADC081C=y
CONFIG_VIPERBOARD_ADC=y

#
# Amplifiers
#
# CONFIG_AD8366 is not set

#
# Hid Sensor IIO Common
#
CONFIG_HID_SENSOR_IIO_COMMON=y
CONFIG_HID_SENSOR_IIO_TRIGGER=y
# CONFIG_HID_SENSOR_ENUM_BASE_QUIRKS is not set
CONFIG_IIO_ST_SENSORS_I2C=y
CONFIG_IIO_ST_SENSORS_SPI=y
CONFIG_IIO_ST_SENSORS_CORE=y

#
# Digital to analog converters
#
# CONFIG_AD5064 is not set
CONFIG_AD5360=y
CONFIG_AD5380=y
CONFIG_AD5421=y
CONFIG_AD5446=y
CONFIG_AD5449=y
# CONFIG_AD5504 is not set
# CONFIG_AD5624R_SPI is not set
# CONFIG_AD5686 is not set
CONFIG_AD5755=y
# CONFIG_AD5764 is not set
# CONFIG_AD5791 is not set
CONFIG_AD7303=y
CONFIG_MAX517=y
# CONFIG_MCP4725 is not set

#
# Frequency Synthesizers DDS/PLL
#

#
# Clock Generator/Distribution
#
# CONFIG_AD9523 is not set

#
# Phase-Locked Loop (PLL) frequency synthesizers
#
CONFIG_ADF4350=y

#
# Digital gyroscope sensors
#
CONFIG_ADIS16080=y
CONFIG_ADIS16130=y
CONFIG_ADIS16136=y
CONFIG_ADIS16260=y
CONFIG_ADXRS450=y
CONFIG_HID_SENSOR_GYRO_3D=y
CONFIG_IIO_ST_GYRO_3AXIS=y
CONFIG_IIO_ST_GYRO_I2C_3AXIS=y
CONFIG_IIO_ST_GYRO_SPI_3AXIS=y
# CONFIG_ITG3200 is not set

#
# Inertial measurement units
#
CONFIG_ADIS16400=y
CONFIG_ADIS16480=y
CONFIG_IIO_ADIS_LIB=y
CONFIG_IIO_ADIS_LIB_BUFFER=y
CONFIG_INV_MPU6050_IIO=y

#
# Light sensors
#
CONFIG_ADJD_S311=y
CONFIG_APDS9300=y
# CONFIG_GP2AP020A00F is not set
CONFIG_HID_SENSOR_ALS=y
CONFIG_SENSORS_LM3533=y
# CONFIG_TCS3472 is not set
CONFIG_SENSORS_TSL2563=y
# CONFIG_TSL4531 is not set
CONFIG_VCNL4000=y

#
# Magnetometer sensors
#
CONFIG_AK8975=y
CONFIG_HID_SENSOR_MAGNETOMETER_3D=y
# CONFIG_IIO_ST_MAGN_3AXIS is not set

#
# Triggers - standalone
#
CONFIG_IIO_INTERRUPT_TRIGGER=y
CONFIG_IIO_SYSFS_TRIGGER=y

#
# Pressure sensors
#
CONFIG_IIO_ST_PRESS=y
CONFIG_IIO_ST_PRESS_I2C=y
CONFIG_IIO_ST_PRESS_SPI=y

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
CONFIG_VME_USER=y
# CONFIG_VME_PIO2 is not set
CONFIG_PWM=y
CONFIG_PWM_SYSFS=y
CONFIG_IPACK_BUS=y
# CONFIG_BOARD_TPCI200 is not set
# CONFIG_SERIAL_IPOCTAL is not set
# CONFIG_RESET_CONTROLLER is not set
CONFIG_FMC=y
# CONFIG_FMC_FAKEDEV is not set
CONFIG_FMC_TRIVIAL=y
# CONFIG_FMC_WRITE_EEPROM is not set
# CONFIG_FMC_CHARDEV is not set

#
# Firmware Drivers
#
# CONFIG_EDD is not set
CONFIG_FIRMWARE_MEMMAP=y
CONFIG_DELL_RBU=y
CONFIG_DCDBAS=y
# CONFIG_ISCSI_IBFT_FIND is not set
# CONFIG_GOOGLE_FIRMWARE is not set

#
# File systems
#
CONFIG_DCACHE_WORD_ACCESS=y
# CONFIG_FS_POSIX_ACL is not set
CONFIG_EXPORTFS=y
CONFIG_FILE_LOCKING=y
CONFIG_FSNOTIFY=y
CONFIG_DNOTIFY=y
CONFIG_INOTIFY_USER=y
CONFIG_FANOTIFY=y
# CONFIG_QUOTA is not set
# CONFIG_QUOTACTL is not set
# CONFIG_AUTOFS4_FS is not set
CONFIG_FUSE_FS=y
CONFIG_CUSE=y

#
# Caches
#
# CONFIG_FSCACHE is not set

#
# Pseudo filesystems
#
# CONFIG_PROC_FS is not set
CONFIG_PROC_PAGE_MONITOR=y
CONFIG_SYSFS=y
# CONFIG_TMPFS is not set
# CONFIG_HUGETLBFS is not set
# CONFIG_HUGETLB_PAGE is not set
CONFIG_CONFIGFS_FS=y
CONFIG_MISC_FILESYSTEMS=y
# CONFIG_ECRYPT_FS is not set
# CONFIG_JFFS2_FS is not set
CONFIG_LOGFS=y
CONFIG_ROMFS_FS=y
CONFIG_ROMFS_BACKED_BY_MTD=y
CONFIG_ROMFS_ON_MTD=y
CONFIG_PSTORE=y
CONFIG_PSTORE_CONSOLE=y
# CONFIG_PSTORE_RAM is not set
CONFIG_NETWORK_FILESYSTEMS=y
CONFIG_NFS_FS=y
# CONFIG_NFS_V2 is not set
CONFIG_NFS_V3=y
# CONFIG_NFS_V3_ACL is not set
CONFIG_NFS_V4=y
# CONFIG_NFS_SWAP is not set
# CONFIG_NFS_V4_1 is not set
# CONFIG_ROOT_NFS is not set
# CONFIG_NFS_USE_LEGACY_DNS is not set
CONFIG_NFS_USE_KERNEL_DNS=y
CONFIG_NFSD=y
# CONFIG_NFSD_V3 is not set
CONFIG_LOCKD=y
CONFIG_LOCKD_V4=y
CONFIG_NFS_COMMON=y
CONFIG_SUNRPC=y
CONFIG_SUNRPC_GSS=y
# CONFIG_RPCSEC_GSS_KRB5 is not set
CONFIG_CEPH_FS=y
# CONFIG_CIFS is not set
CONFIG_NCP_FS=y
# CONFIG_NCPFS_PACKET_SIGNING is not set
CONFIG_NCPFS_IOCTL_LOCKING=y
CONFIG_NCPFS_STRONG=y
# CONFIG_NCPFS_NFS_NS is not set
# CONFIG_NCPFS_OS2_NS is not set
CONFIG_NCPFS_SMALLDOS=y
CONFIG_NCPFS_NLS=y
# CONFIG_NCPFS_EXTRAS is not set
CONFIG_CODA_FS=y
# CONFIG_AFS_FS is not set
CONFIG_NLS=y
CONFIG_NLS_DEFAULT="iso8859-1"
CONFIG_NLS_CODEPAGE_437=y
CONFIG_NLS_CODEPAGE_737=y
CONFIG_NLS_CODEPAGE_775=y
CONFIG_NLS_CODEPAGE_850=y
# CONFIG_NLS_CODEPAGE_852 is not set
# CONFIG_NLS_CODEPAGE_855 is not set
CONFIG_NLS_CODEPAGE_857=y
# CONFIG_NLS_CODEPAGE_860 is not set
# CONFIG_NLS_CODEPAGE_861 is not set
# CONFIG_NLS_CODEPAGE_862 is not set
CONFIG_NLS_CODEPAGE_863=y
CONFIG_NLS_CODEPAGE_864=y
# CONFIG_NLS_CODEPAGE_865 is not set
# CONFIG_NLS_CODEPAGE_866 is not set
# CONFIG_NLS_CODEPAGE_869 is not set
# CONFIG_NLS_CODEPAGE_936 is not set
CONFIG_NLS_CODEPAGE_950=y
CONFIG_NLS_CODEPAGE_932=y
CONFIG_NLS_CODEPAGE_949=y
CONFIG_NLS_CODEPAGE_874=y
CONFIG_NLS_ISO8859_8=y
CONFIG_NLS_CODEPAGE_1250=y
# CONFIG_NLS_CODEPAGE_1251 is not set
CONFIG_NLS_ASCII=y
CONFIG_NLS_ISO8859_1=y
CONFIG_NLS_ISO8859_2=y
CONFIG_NLS_ISO8859_3=y
# CONFIG_NLS_ISO8859_4 is not set
CONFIG_NLS_ISO8859_5=y
CONFIG_NLS_ISO8859_6=y
CONFIG_NLS_ISO8859_7=y
CONFIG_NLS_ISO8859_9=y
CONFIG_NLS_ISO8859_13=y
# CONFIG_NLS_ISO8859_14 is not set
CONFIG_NLS_ISO8859_15=y
# CONFIG_NLS_KOI8_R is not set
# CONFIG_NLS_KOI8_U is not set
CONFIG_NLS_MAC_ROMAN=y
# CONFIG_NLS_MAC_CELTIC is not set
# CONFIG_NLS_MAC_CENTEURO is not set
CONFIG_NLS_MAC_CROATIAN=y
# CONFIG_NLS_MAC_CYRILLIC is not set
# CONFIG_NLS_MAC_GAELIC is not set
# CONFIG_NLS_MAC_GREEK is not set
# CONFIG_NLS_MAC_ICELAND is not set
# CONFIG_NLS_MAC_INUIT is not set
# CONFIG_NLS_MAC_ROMANIAN is not set
# CONFIG_NLS_MAC_TURKISH is not set
CONFIG_NLS_UTF8=y
CONFIG_DLM=y
CONFIG_DLM_DEBUG=y

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
CONFIG_FRAME_WARN=2048
# CONFIG_STRIP_ASM_SYMS is not set
# CONFIG_READABLE_ASM is not set
CONFIG_UNUSED_SYMBOLS=y
CONFIG_DEBUG_FS=y
CONFIG_HEADERS_CHECK=y
# CONFIG_DEBUG_SECTION_MISMATCH is not set
CONFIG_ARCH_WANT_FRAME_POINTERS=y
CONFIG_FRAME_POINTER=y
CONFIG_DEBUG_FORCE_WEAK_PER_CPU=y
# CONFIG_MAGIC_SYSRQ is not set
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
# CONFIG_DEBUG_OBJECTS_TIMERS is not set
CONFIG_DEBUG_OBJECTS_WORK=y
CONFIG_DEBUG_OBJECTS_RCU_HEAD=y
# CONFIG_DEBUG_OBJECTS_PERCPU_COUNTER is not set
CONFIG_DEBUG_OBJECTS_ENABLE_DEFAULT=1
# CONFIG_DEBUG_SLAB is not set
CONFIG_HAVE_DEBUG_KMEMLEAK=y
# CONFIG_DEBUG_KMEMLEAK is not set
CONFIG_DEBUG_STACK_USAGE=y
CONFIG_DEBUG_VM=y
# CONFIG_DEBUG_VM_RB is not set
# CONFIG_DEBUG_VIRTUAL is not set
# CONFIG_DEBUG_MEMORY_INIT is not set
# CONFIG_DEBUG_PER_CPU_MAPS is not set
CONFIG_HAVE_DEBUG_STACKOVERFLOW=y
# CONFIG_DEBUG_STACKOVERFLOW is not set
CONFIG_HAVE_ARCH_KMEMCHECK=y
# CONFIG_DEBUG_SHIRQ is not set

#
# Debug Lockups and Hangs
#
# CONFIG_LOCKUP_DETECTOR is not set
CONFIG_DETECT_HUNG_TASK=y
CONFIG_DEFAULT_HUNG_TASK_TIMEOUT=120
# CONFIG_BOOTPARAM_HUNG_TASK_PANIC is not set
CONFIG_BOOTPARAM_HUNG_TASK_PANIC_VALUE=0
# CONFIG_PANIC_ON_OOPS is not set
CONFIG_PANIC_ON_OOPS_VALUE=0
CONFIG_DEBUG_PREEMPT=y

#
# Lock Debugging (spinlocks, mutexes, etc...)
#
# CONFIG_DEBUG_RT_MUTEXES is not set
CONFIG_RT_MUTEX_TESTER=y
CONFIG_DEBUG_SPINLOCK=y
CONFIG_DEBUG_MUTEXES=y
# CONFIG_DEBUG_WW_MUTEX_SLOWPATH is not set
CONFIG_DEBUG_LOCK_ALLOC=y
CONFIG_PROVE_LOCKING=y
CONFIG_LOCKDEP=y
# CONFIG_LOCK_STAT is not set
# CONFIG_DEBUG_LOCKDEP is not set
CONFIG_DEBUG_ATOMIC_SLEEP=y
# CONFIG_DEBUG_LOCKING_API_SELFTESTS is not set
CONFIG_TRACE_IRQFLAGS=y
CONFIG_STACKTRACE=y
# CONFIG_DEBUG_KOBJECT is not set
CONFIG_DEBUG_KOBJECT_RELEASE=y
CONFIG_DEBUG_BUGVERBOSE=y
CONFIG_DEBUG_WRITECOUNT=y
# CONFIG_DEBUG_LIST is not set
CONFIG_DEBUG_SG=y
# CONFIG_DEBUG_NOTIFIERS is not set
CONFIG_DEBUG_CREDENTIALS=y

#
# RCU Debugging
#
# CONFIG_PROVE_RCU is not set
# CONFIG_PROVE_RCU_DELAY is not set
CONFIG_SPARSE_RCU_POINTER=y
# CONFIG_RCU_TORTURE_TEST is not set
CONFIG_RCU_CPU_STALL_TIMEOUT=21
# CONFIG_RCU_CPU_STALL_VERBOSE is not set
CONFIG_RCU_CPU_STALL_INFO=y
CONFIG_RCU_TRACE=y
# CONFIG_NOTIFIER_ERROR_INJECTION is not set
CONFIG_FAULT_INJECTION=y
# CONFIG_FAILSLAB is not set
# CONFIG_FAIL_PAGE_ALLOC is not set
CONFIG_FAIL_MMC_REQUEST=y
# CONFIG_FAULT_INJECTION_DEBUG_FS is not set
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
CONFIG_HAVE_FENTRY=y
CONFIG_HAVE_C_RECORDMCOUNT=y
CONFIG_TRACE_CLOCK=y
CONFIG_TRACING_SUPPORT=y
# CONFIG_FTRACE is not set

#
# Runtime Testing
#
# CONFIG_TEST_LIST_SORT is not set
# CONFIG_BACKTRACE_SELF_TEST is not set
CONFIG_RBTREE_TEST=y
CONFIG_ATOMIC64_SELFTEST=y
CONFIG_TEST_STRING_HELPERS=y
CONFIG_TEST_KSTRTOX=y
# CONFIG_PROVIDE_OHCI1394_DMA_INIT is not set
CONFIG_BUILD_DOCSRC=y
# CONFIG_DMA_API_DEBUG is not set
# CONFIG_SAMPLES is not set
CONFIG_HAVE_ARCH_KGDB=y
# CONFIG_KGDB is not set
# CONFIG_STRICT_DEVMEM is not set
# CONFIG_X86_VERBOSE_BOOTUP is not set
# CONFIG_EARLY_PRINTK is not set
# CONFIG_X86_PTDUMP is not set
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
CONFIG_IO_DELAY_0XED=y
# CONFIG_IO_DELAY_UDELAY is not set
# CONFIG_IO_DELAY_NONE is not set
CONFIG_DEFAULT_IO_DELAY_TYPE=1
CONFIG_DEBUG_BOOT_PARAMS=y
# CONFIG_CPA_DEBUG is not set
CONFIG_OPTIMIZE_INLINING=y
# CONFIG_DEBUG_NMI_SELFTEST is not set
# CONFIG_X86_DEBUG_STATIC_CPU_HAS is not set

#
# Security options
#
CONFIG_KEYS=y
# CONFIG_TRUSTED_KEYS is not set
# CONFIG_ENCRYPTED_KEYS is not set
# CONFIG_KEYS_DEBUG_PROC_KEYS is not set
CONFIG_SECURITY_DMESG_RESTRICT=y
# CONFIG_SECURITY is not set
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
CONFIG_CRYPTO_PCOMP2=y
CONFIG_CRYPTO_MANAGER=y
CONFIG_CRYPTO_MANAGER2=y
CONFIG_CRYPTO_USER=y
# CONFIG_CRYPTO_MANAGER_DISABLE_TESTS is not set
CONFIG_CRYPTO_GF128MUL=y
CONFIG_CRYPTO_NULL=y
CONFIG_CRYPTO_PCRYPT=y
CONFIG_CRYPTO_WORKQUEUE=y
CONFIG_CRYPTO_CRYPTD=y
CONFIG_CRYPTO_AUTHENC=y
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
CONFIG_CRYPTO_XCBC=y
CONFIG_CRYPTO_VMAC=y

#
# Digest
#
CONFIG_CRYPTO_CRC32C=y
# CONFIG_CRYPTO_CRC32C_INTEL is not set
CONFIG_CRYPTO_CRC32=y
# CONFIG_CRYPTO_CRC32_PCLMUL is not set
CONFIG_CRYPTO_CRCT10DIF=y
# CONFIG_CRYPTO_CRCT10DIF_PCLMUL is not set
CONFIG_CRYPTO_GHASH=y
CONFIG_CRYPTO_MD4=y
CONFIG_CRYPTO_MD5=y
CONFIG_CRYPTO_MICHAEL_MIC=y
# CONFIG_CRYPTO_RMD128 is not set
CONFIG_CRYPTO_RMD160=y
CONFIG_CRYPTO_RMD256=y
CONFIG_CRYPTO_RMD320=y
CONFIG_CRYPTO_SHA1=y
CONFIG_CRYPTO_SHA1_SSSE3=y
CONFIG_CRYPTO_SHA256_SSSE3=y
CONFIG_CRYPTO_SHA512_SSSE3=y
CONFIG_CRYPTO_SHA256=y
CONFIG_CRYPTO_SHA512=y
CONFIG_CRYPTO_TGR192=y
CONFIG_CRYPTO_WP512=y
CONFIG_CRYPTO_GHASH_CLMUL_NI_INTEL=y

#
# Ciphers
#
CONFIG_CRYPTO_AES=y
# CONFIG_CRYPTO_AES_X86_64 is not set
# CONFIG_CRYPTO_AES_NI_INTEL is not set
CONFIG_CRYPTO_ANUBIS=y
CONFIG_CRYPTO_ARC4=y
CONFIG_CRYPTO_BLOWFISH=y
CONFIG_CRYPTO_BLOWFISH_COMMON=y
CONFIG_CRYPTO_BLOWFISH_X86_64=y
# CONFIG_CRYPTO_CAMELLIA is not set
CONFIG_CRYPTO_CAMELLIA_X86_64=y
CONFIG_CRYPTO_CAMELLIA_AESNI_AVX_X86_64=y
# CONFIG_CRYPTO_CAMELLIA_AESNI_AVX2_X86_64 is not set
CONFIG_CRYPTO_CAST_COMMON=y
CONFIG_CRYPTO_CAST5=y
# CONFIG_CRYPTO_CAST5_AVX_X86_64 is not set
CONFIG_CRYPTO_CAST6=y
CONFIG_CRYPTO_CAST6_AVX_X86_64=y
CONFIG_CRYPTO_DES=y
CONFIG_CRYPTO_FCRYPT=y
# CONFIG_CRYPTO_KHAZAD is not set
CONFIG_CRYPTO_SALSA20=y
# CONFIG_CRYPTO_SALSA20_X86_64 is not set
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
# CONFIG_CRYPTO_ZLIB is not set
# CONFIG_CRYPTO_LZO is not set
# CONFIG_CRYPTO_LZ4 is not set
CONFIG_CRYPTO_LZ4HC=y

#
# Random Number Generation
#
# CONFIG_CRYPTO_ANSI_CPRNG is not set
CONFIG_CRYPTO_USER_API=y
CONFIG_CRYPTO_USER_API_HASH=y
# CONFIG_CRYPTO_USER_API_SKCIPHER is not set
# CONFIG_CRYPTO_HW is not set
CONFIG_ASYMMETRIC_KEY_TYPE=y
CONFIG_ASYMMETRIC_PUBLIC_KEY_SUBTYPE=y
CONFIG_PUBLIC_KEY_ALGO_RSA=y
CONFIG_X509_CERTIFICATE_PARSER=y
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
# CONFIG_KVM_INTEL is not set
CONFIG_KVM_AMD=y
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
CONFIG_ARCH_USE_CMPXCHG_LOCKREF=y
CONFIG_CRC_CCITT=y
CONFIG_CRC16=y
CONFIG_CRC_T10DIF=y
CONFIG_CRC_ITU_T=y
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
CONFIG_LZ4HC_COMPRESS=y
CONFIG_LZ4_DECOMPRESS=y
CONFIG_XZ_DEC=y
# CONFIG_XZ_DEC_X86 is not set
# CONFIG_XZ_DEC_POWERPC is not set
CONFIG_XZ_DEC_IA64=y
# CONFIG_XZ_DEC_ARM is not set
# CONFIG_XZ_DEC_ARMTHUMB is not set
CONFIG_XZ_DEC_SPARC=y
CONFIG_XZ_DEC_BCJ=y
# CONFIG_XZ_DEC_TEST is not set
CONFIG_DECOMPRESS_GZIP=y
CONFIG_REED_SOLOMON=y
CONFIG_REED_SOLOMON_DEC16=y
CONFIG_BCH=y
CONFIG_BCH_CONST_PARAMS=y
CONFIG_BTREE=y
CONFIG_HAS_IOMEM=y
CONFIG_HAS_IOPORT=y
CONFIG_HAS_DMA=y
CONFIG_CHECK_SIGNATURE=y
CONFIG_CPUMASK_OFFSTACK=y
CONFIG_CPU_RMAP=y
CONFIG_DQL=y
CONFIG_NLATTR=y
CONFIG_ARCH_HAS_ATOMIC64_DEC_IF_POSITIVE=y
# CONFIG_AVERAGE is not set
CONFIG_CLZ_TAB=y
CONFIG_CORDIC=y
CONFIG_DDR=y
CONFIG_MPILIB=y
CONFIG_OID_REGISTRY=y

--SLDf9lqlvOQaIe6s--
