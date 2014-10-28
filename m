Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754013AbaJ1O1c (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Oct 2014 10:27:32 -0400
Received: from mga14.intel.com ([192.55.52.115]:20030 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753939AbaJ1O12 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Oct 2014 10:27:28 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.04,802,1406617200"; 
   d="scan'208";a="612788315"
Date: Tue, 28 Oct 2014 22:27:15 +0800
From: Fengguang Wu <fengguang.wu@intel.com>
To: Kirill Tkhai <ktkhai@parallels.com>
Cc: Peter Zijlstra <peterz@infradead.org>, LKP <lkp@01.org>,
        linux-kernel@vger.kernel.org
Subject: [sched] [ INFO: suspicious RCU usage. ]
Message-ID: <20141028142715.GB19097@wfg-t540p.sh.intel.com>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="Pd0ReVV5GZGQvF3a"
Content-Disposition: inline
User-Agent: Heirloom mailx 12.5 6/20/10
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--Pd0ReVV5GZGQvF3a
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Greetings,

0day kernel testing robot got the below dmesg and the first bad commit is

git://git.kernel.org/pub/scm/linux/kernel/git/peterz/queue.git sched/urgent
commit f6a2b544517d33f6a1e428567bda96fd859ce1c9
Author:     Kirill Tkhai <ktkhai@parallels.com>
AuthorDate: Mon Oct 27 14:18:25 2014 +0400
Commit:     Peter Zijlstra <peterz@infradead.org>
CommitDate: Mon Oct 27 13:23:31 2014 +0100

    sched: Fix race between task_group and sched_task_group
    
    The race may happen when somebody is changing task_group of a forking task.
    Child's cgroup is the same as parent's after dup_task_struct() (there just
    memory copying). Also, cfs_rq and rt_rq are the same as parent's.
    
    But if parent changes its task_group before it's called cgroup_post_fork(),
    we do not reflect this situation on child. Child's cfs_rq and rt_rq remain
    the same, while child's task_group changes in cgroup_post_fork().
    
    To fix this we introduce fork() method, which calls sched_move_task() directly.
    This function changes sched_task_group on appropriate (also its logic has
    no problem with freshly created tasks, so we shouldn't introduce something
    special; we are able just to use it).
    
    Possibly, this decides the Burke Libbey's problem: https://lkml.org/lkml/2014/10/24/456
    
    Signed-off-by: Kirill Tkhai <ktkhai@parallels.com>
    Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
    Link: http://lkml.kernel.org/r/1414405105.19914.169.camel@tkhai

+---------------------------+-----------+------------+------------+
|                           | v3.18-rc2 | f6a2b54451 | 8e5859c73b |
+---------------------------+-----------+------------+------------+
| boot_successes            | 200       | 0          | 0          |
| boot_failures             | 1         | 20         | 11         |
| BUG:kernel_boot_hang      | 1         |            |            |
| INFO:suspicious_RCU_usage | 0         | 20         | 11         |
| backtrace:do_fork         | 0         | 20         | 11         |
+---------------------------+-----------+------------+------------+

[    0.060187] 
[    0.060500] ===============================
[    0.060500] ===============================
[    0.061307] [ INFO: suspicious RCU usage. ]
[    0.061307] [ INFO: suspicious RCU usage. ]
[    0.062109] 3.18.0-rc2-gf6a2b54 #404 Not tainted
[    0.062109] 3.18.0-rc2-gf6a2b54 #404 Not tainted
[    0.063049] -------------------------------

git bisect start 8e5859c73b9f45602222441a23eba899bb24c82e 522e980064c24d3dd9859e9375e17417496567cf --
git bisect  bad 259820751fd17a4b49098429c68c2c0adfd1c9ed  # 21:11      0-      2  Merge branch 'sched/core'
git bisect  bad 8c64bf8de891aa51e916b51a3f7992321ec19b63  # 21:15      0-      1  Merge branch 'sched/urgent'
git bisect  bad fd457f2bafdc4e367d1814ac395035a35980783f  # 21:27      0-      7  sched/fair: Care divide error in update_task_scan_period()
git bisect  bad fb5b330f079e243dcc831e9a3d65b9b9fbbed7f8  # 21:36      0-      1  sched/deadline: don't replenish from a !SCHED_DEADLINE entity
git bisect  bad f6a2b544517d33f6a1e428567bda96fd859ce1c9  # 21:41      0-      2  sched: Fix race between task_group and sched_task_group
# first bad commit: [f6a2b544517d33f6a1e428567bda96fd859ce1c9] sched: Fix race between task_group and sched_task_group
git bisect good cac7f2429872d3733dc3f9915857b1691da2eb2f  # 21:58     60+      1  Linux 3.18-rc2
git bisect  bad 8e5859c73b9f45602222441a23eba899bb24c82e  # 22:00      0-     11  Merge branch 'sched/wait'
git bisect good cac7f2429872d3733dc3f9915857b1691da2eb2f  # 22:05     60+      1  Linux 3.18-rc2
git bisect good 7a891e6323e963f3301e44bdeee734028e34d390  # 22:14     60+      0  Add linux-next specific files for 20141027


This script may reproduce the error.

----------------------------------------------------------------------------
#!/bin/bash

kernel=$1
initrd=quantal-core-x86_64.cgz

wget --no-clobber https://github.com/fengguang/reproduce-kernel-bug/raw/master/initrd/$initrd

kvm=(
	qemu-system-x86_64
	-cpu kvm64
	-enable-kvm
	-kernel $kernel
	-initrd $initrd
	-m 320
	-smp 2
	-net nic,vlan=1,model=e1000
	-net user,vlan=1
	-boot order=nc
	-no-reboot
	-watchdog i6300esb
	-rtc base=localtime
	-serial stdio
	-display none
	-monitor null 
)

append=(
	hung_task_panic=1
	earlyprintk=ttyS0,115200
	debug
	apic=debug
	sysrq_always_enabled
	rcupdate.rcu_cpu_stall_timeout=100
	panic=-1
	softlockup_panic=1
	nmi_watchdog=panic
	oops=panic
	load_ramdisk=2
	prompt_ramdisk=0
	console=ttyS0,115200
	console=tty0
	vga=normal
	root=/dev/ram0
	rw
	drbd.minor_count=8
)

"${kvm[@]}" --append "${append[*]}"
----------------------------------------------------------------------------

Thanks,
Fengguang

--Pd0ReVV5GZGQvF3a
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="dmesg-quantal-vp-29:20141027214255:x86_64-randconfig-c0-1027:3.18.0-rc2-gf6a2b54:404"
Content-Transfer-Encoding: quoted-printable

early console in setup code
early console in decompress_kernel

Decompressing Linux... Parsing ELF... done.
Booting the kernel.
[    0.000000] Initializing cgroup subsys cpu
[    0.000000] Linux version 3.18.0-rc2-gf6a2b54 (kbuild@cairo) (gcc versio=
n 4.9.1 (Debian 4.9.1-11) ) #404 Mon Oct 27 21:39:28 CST 2014
[    0.000000] Command line: hung_task_panic=3D1 earlyprintk=3DttyS0,115200=
 debug apic=3Ddebug sysrq_always_enabled rcupdate.rcu_cpu_stall_timeout=3D1=
00 panic=3D-1 softlockup_panic=3D1 nmi_watchdog=3Dpanic oops=3Dpanic load_r=
amdisk=3D2 prompt_ramdisk=3D0 console=3DttyS0,115200 console=3Dtty0 vga=3Dn=
ormal  root=3D/dev/ram0 rw link=3D/kbuild-tests/run-queue/kvm/x86_64-randco=
nfig-c0-1027/peterz-queue:master:f6a2b544517d33f6a1e428567bda96fd859ce1c9:b=
isect-linux-2/.vmlinuz-f6a2b544517d33f6a1e428567bda96fd859ce1c9-20141027213=
935-19-vp branch=3Dpeterz-queue/master BOOT_IMAGE=3D/kernel/x86_64-randconf=
ig-c0-1027/f6a2b544517d33f6a1e428567bda96fd859ce1c9/vmlinuz-3.18.0-rc2-gf6a=
2b54 drbd.minor_count=3D8
[    0.000000] KERNEL supported cpus:
[    0.000000]   Intel GenuineIntel
[    0.000000]   AMD AuthenticAMD
[    0.000000] e820: BIOS-provided physical RAM map:
[    0.000000] BIOS-e820: [mem 0x0000000000000000-0x000000000009fbff] usable
[    0.000000] BIOS-e820: [mem 0x000000000009fc00-0x000000000009ffff] reser=
ved
[    0.000000] BIOS-e820: [mem 0x00000000000f0000-0x00000000000fffff] reser=
ved
[    0.000000] BIOS-e820: [mem 0x0000000000100000-0x0000000013ffdfff] usable
[    0.000000] BIOS-e820: [mem 0x0000000013ffe000-0x0000000013ffffff] reser=
ved
[    0.000000] BIOS-e820: [mem 0x00000000feffc000-0x00000000feffffff] reser=
ved
[    0.000000] BIOS-e820: [mem 0x00000000fffc0000-0x00000000ffffffff] reser=
ved
[    0.000000] bootconsole [earlyser0] enabled
[    0.000000] NX (Execute Disable) protection: active
[    0.000000] Hypervisor detected: KVM
[    0.000000] e820: update [mem 0x00000000-0x00000fff] usable =3D=3D> rese=
rved
[    0.000000] e820: remove [mem 0x000a0000-0x000fffff] usable
[    0.000000] e820: last_pfn =3D 0x13ffe max_arch_pfn =3D 0x400000000
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
[    0.000000] Base memory trampoline at [ffff880000099000] 99000 size 24576
[    0.000000] init_memory_mapping: [mem 0x00000000-0x000fffff]
[    0.000000]  [mem 0x00000000-0x000fffff] page 4k
[    0.000000] BRK [0x03187000, 0x03187fff] PGTABLE
[    0.000000] BRK [0x03188000, 0x03188fff] PGTABLE
[    0.000000] BRK [0x03189000, 0x03189fff] PGTABLE
[    0.000000] init_memory_mapping: [mem 0x12600000-0x127fffff]
[    0.000000]  [mem 0x12600000-0x127fffff] page 2M
[    0.000000] init_memory_mapping: [mem 0x10000000-0x125fffff]
[    0.000000]  [mem 0x10000000-0x125fffff] page 2M
[    0.000000] init_memory_mapping: [mem 0x00100000-0x0fffffff]
[    0.000000]  [mem 0x00100000-0x001fffff] page 4k
[    0.000000]  [mem 0x00200000-0x0fffffff] page 2M
[    0.000000] init_memory_mapping: [mem 0x12800000-0x13ffdfff]
[    0.000000]  [mem 0x12800000-0x13dfffff] page 2M
[    0.000000]  [mem 0x13e00000-0x13ffdfff] page 4k
[    0.000000] BRK [0x0318a000, 0x0318afff] PGTABLE
[    0.000000] RAMDISK: [mem 0x1293d000-0x13feffff]
[    0.000000] ACPI: Early table checksum verification disabled
[    0.000000] ACPI: RSDP 0x00000000000FD930 000014 (v00 BOCHS )
[    0.000000] ACPI: RSDT 0x0000000013FFE450 000034 (v01 BOCHS  BXPCRSDT 00=
000001 BXPC 00000001)
[    0.000000] ACPI: FACP 0x0000000013FFFF80 000074 (v01 BOCHS  BXPCFACP 00=
000001 BXPC 00000001)
[    0.000000] ACPI: DSDT 0x0000000013FFE490 0011A9 (v01 BXPC   BXDSDT   00=
000001 INTL 20100528)
[    0.000000] ACPI: FACS 0x0000000013FFFF40 000040
[    0.000000] ACPI: SSDT 0x0000000013FFF7A0 000796 (v01 BOCHS  BXPCSSDT 00=
000001 BXPC 00000001)
[    0.000000] ACPI: APIC 0x0000000013FFF680 000080 (v01 BOCHS  BXPCAPIC 00=
000001 BXPC 00000001)
[    0.000000] ACPI: HPET 0x0000000013FFF640 000038 (v01 BOCHS  BXPCHPET 00=
000001 BXPC 00000001)
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] mapped APIC to ffffffffff5fc000 (        fee00000)
[    0.000000] kvm-clock: Using msrs 4b564d01 and 4b564d00
[    0.000000] kvm-clock: cpu 0, msr 0:13ffd001, primary cpu clock
[    0.000000] Zone ranges:
[    0.000000]   DMA      [mem 0x00001000-0x00ffffff]
[    0.000000]   DMA32    [mem 0x01000000-0xffffffff]
[    0.000000]   Normal   empty
[    0.000000] Movable zone start for each node
[    0.000000] Early memory node ranges
[    0.000000]   node   0: [mem 0x00001000-0x0009efff]
[    0.000000]   node   0: [mem 0x00100000-0x13ffdfff]
[    0.000000] Initmem setup node 0 [mem 0x00001000-0x13ffdfff]
[    0.000000] On node 0 totalpages: 81820
[    0.000000]   DMA zone: 56 pages used for memmap
[    0.000000]   DMA zone: 21 pages reserved
[    0.000000]   DMA zone: 3998 pages, LIFO batch:0
[    0.000000]   DMA32 zone: 1064 pages used for memmap
[    0.000000]   DMA32 zone: 77822 pages, LIFO batch:15
[    0.000000] ACPI: PM-Timer IO Port: 0xb008
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] mapped APIC to ffffffffff5fc000 (        fee00000)
[    0.000000] ACPI: LAPIC (acpi_id[0x00] lapic_id[0x00] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x01] lapic_id[0x01] enabled)
[    0.000000] ACPI: NR_CPUS/possible_cpus limit of 1 reached.  Processor 1=
/0x1 ignored.
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
[    0.000000] mapped IOAPIC to ffffffffff5fb000 (fec00000)
[    0.000000] KVM setup async PF for cpu 0
[    0.000000] kvm-stealtime: cpu 0, msr 2031c80
[    0.000000] PM: Registered nosave memory: [mem 0x00000000-0x00000fff]
[    0.000000] PM: Registered nosave memory: [mem 0x0009f000-0x0009ffff]
[    0.000000] PM: Registered nosave memory: [mem 0x000a0000-0x000effff]
[    0.000000] PM: Registered nosave memory: [mem 0x000f0000-0x000fffff]
[    0.000000] e820: [mem 0x14000000-0xfeffbfff] available for PCI devices
[    0.000000] Booting paravirtualized kernel on KVM
[    0.000000] pcpu-alloc: s0 r0 d32768 u32768 alloc=3D1*32768
[    0.000000] pcpu-alloc: [0] 0=20
[    0.000000] Built 1 zonelists in Zone order, mobility grouping on.  Tota=
l pages: 80679
[    0.000000] Kernel command line: hung_task_panic=3D1 earlyprintk=3DttyS0=
,115200 debug apic=3Ddebug sysrq_always_enabled rcupdate.rcu_cpu_stall_time=
out=3D100 panic=3D-1 softlockup_panic=3D1 nmi_watchdog=3Dpanic oops=3Dpanic=
 load_ramdisk=3D2 prompt_ramdisk=3D0 console=3DttyS0,115200 console=3Dtty0 =
vga=3Dnormal  root=3D/dev/ram0 rw link=3D/kbuild-tests/run-queue/kvm/x86_64=
-randconfig-c0-1027/peterz-queue:master:f6a2b544517d33f6a1e428567bda96fd859=
ce1c9:bisect-linux-2/.vmlinuz-f6a2b544517d33f6a1e428567bda96fd859ce1c9-2014=
1027213935-19-vp branch=3Dpeterz-queue/master BOOT_IMAGE=3D/kernel/x86_64-r=
andconfig-c0-1027/f6a2b544517d33f6a1e428567bda96fd859ce1c9/vmlinuz-3.18.0-r=
c2-gf6a2b54 drbd.minor_count=3D8
[    0.000000] PID hash table entries: 2048 (order: 2, 16384 bytes)
[    0.000000] Dentry cache hash table entries: 65536 (order: 7, 524288 byt=
es)
[    0.000000] Inode-cache hash table entries: 32768 (order: 6, 262144 byte=
s)
[    0.000000] Memory: 263344K/327280K available (9374K kernel code, 2080K =
rwdata, 5096K rodata, 1196K init, 14660K bss, 63936K reserved)
[    0.000000] NR_IRQS:4352 nr_irqs:256 0
[    0.000000] Initializing cgroup subsys cpu
[    0.000000] Linux version 3.18.0-rc2-gf6a2b54 (kbuild@cairo) (gcc versio=
n 4.9.1 (Debian 4.9.1-11) ) #404 Mon Oct 27 21:39:28 CST 2014
[    0.000000] Command line: hung_task_panic=3D1 earlyprintk=3DttyS0,115200=
 debug apic=3Ddebug sysrq_always_enabled rcupdate.rcu_cpu_stall_timeout=3D1=
00 panic=3D-1 softlockup_panic=3D1 nmi_watchdog=3Dpanic oops=3Dpanic load_r=
amdisk=3D2 prompt_ramdisk=3D0 console=3DttyS0,115200 console=3Dtty0 vga=3Dn=
ormal  root=3D/dev/ram0 rw link=3D/kbuild-tests/run-queue/kvm/x86_64-randco=
nfig-c0-1027/peterz-queue:master:f6a2b544517d33f6a1e428567bda96fd859ce1c9:b=
isect-linux-2/.vmlinuz-f6a2b544517d33f6a1e428567bda96fd859ce1c9-20141027213=
935-19-vp branch=3Dpeterz-queue/master BOOT_IMAGE=3D/kernel/x86_64-randconf=
ig-c0-1027/f6a2b544517d33f6a1e428567bda96fd859ce1c9/vmlinuz-3.18.0-rc2-gf6a=
2b54 drbd.minor_count=3D8
[    0.000000] KERNEL supported cpus:
[    0.000000]   Intel GenuineIntel
[    0.000000]   AMD AuthenticAMD
[    0.000000] e820: BIOS-provided physical RAM map:
[    0.000000] BIOS-e820: [mem 0x0000000000000000-0x000000000009fbff] usable
[    0.000000] BIOS-e820: [mem 0x000000000009fc00-0x000000000009ffff] reser=
ved
[    0.000000] BIOS-e820: [mem 0x00000000000f0000-0x00000000000fffff] reser=
ved
[    0.000000] BIOS-e820: [mem 0x0000000000100000-0x0000000013ffdfff] usable
[    0.000000] BIOS-e820: [mem 0x0000000013ffe000-0x0000000013ffffff] reser=
ved
[    0.000000] BIOS-e820: [mem 0x00000000feffc000-0x00000000feffffff] reser=
ved
[    0.000000] BIOS-e820: [mem 0x00000000fffc0000-0x00000000ffffffff] reser=
ved
[    0.000000] bootconsole [earlyser0] enabled
[    0.000000] NX (Execute Disable) protection: active
[    0.000000] Hypervisor detected: KVM
[    0.000000] e820: update [mem 0x00000000-0x00000fff] usable =3D=3D> rese=
rved
[    0.000000] e820: remove [mem 0x000a0000-0x000fffff] usable
[    0.000000] e820: last_pfn =3D 0x13ffe max_arch_pfn =3D 0x400000000
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
[    0.000000] Base memory trampoline at [ffff880000099000] 99000 size 24576
[    0.000000] init_memory_mapping: [mem 0x00000000-0x000fffff]
[    0.000000]  [mem 0x00000000-0x000fffff] page 4k
[    0.000000] BRK [0x03187000, 0x03187fff] PGTABLE
[    0.000000] BRK [0x03188000, 0x03188fff] PGTABLE
[    0.000000] BRK [0x03189000, 0x03189fff] PGTABLE
[    0.000000] init_memory_mapping: [mem 0x12600000-0x127fffff]
[    0.000000]  [mem 0x12600000-0x127fffff] page 2M
[    0.000000] init_memory_mapping: [mem 0x10000000-0x125fffff]
[    0.000000]  [mem 0x10000000-0x125fffff] page 2M
[    0.000000] init_memory_mapping: [mem 0x00100000-0x0fffffff]
[    0.000000]  [mem 0x00100000-0x001fffff] page 4k
[    0.000000]  [mem 0x00200000-0x0fffffff] page 2M
[    0.000000] init_memory_mapping: [mem 0x12800000-0x13ffdfff]
[    0.000000]  [mem 0x12800000-0x13dfffff] page 2M
[    0.000000]  [mem 0x13e00000-0x13ffdfff] page 4k
[    0.000000] BRK [0x0318a000, 0x0318afff] PGTABLE
[    0.000000] RAMDISK: [mem 0x1293d000-0x13feffff]
[    0.000000] ACPI: Early table checksum verification disabled
[    0.000000] ACPI: RSDP 0x00000000000FD930 000014 (v00 BOCHS )
[    0.000000] ACPI: RSDT 0x0000000013FFE450 000034 (v01 BOCHS  BXPCRSDT 00=
000001 BXPC 00000001)
[    0.000000] ACPI: FACP 0x0000000013FFFF80 000074 (v01 BOCHS  BXPCFACP 00=
000001 BXPC 00000001)
[    0.000000] ACPI: DSDT 0x0000000013FFE490 0011A9 (v01 BXPC   BXDSDT   00=
000001 INTL 20100528)
[    0.000000] ACPI: FACS 0x0000000013FFFF40 000040
[    0.000000] ACPI: SSDT 0x0000000013FFF7A0 000796 (v01 BOCHS  BXPCSSDT 00=
000001 BXPC 00000001)
[    0.000000] ACPI: APIC 0x0000000013FFF680 000080 (v01 BOCHS  BXPCAPIC 00=
000001 BXPC 00000001)
[    0.000000] ACPI: HPET 0x0000000013FFF640 000038 (v01 BOCHS  BXPCHPET 00=
000001 BXPC 00000001)
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] mapped APIC to ffffffffff5fc000 (        fee00000)
[    0.000000] kvm-clock: Using msrs 4b564d01 and 4b564d00
[    0.000000] kvm-clock: cpu 0, msr 0:13ffd001, primary cpu clock
[    0.000000] Zone ranges:
[    0.000000]   DMA      [mem 0x00001000-0x00ffffff]
[    0.000000]   DMA32    [mem 0x01000000-0xffffffff]
[    0.000000]   Normal   empty
[    0.000000] Movable zone start for each node
[    0.000000] Early memory node ranges
[    0.000000]   node   0: [mem 0x00001000-0x0009efff]
[    0.000000]   node   0: [mem 0x00100000-0x13ffdfff]
[    0.000000] Initmem setup node 0 [mem 0x00001000-0x13ffdfff]
[    0.000000] On node 0 totalpages: 81820
[    0.000000]   DMA zone: 56 pages used for memmap
[    0.000000]   DMA zone: 21 pages reserved
[    0.000000]   DMA zone: 3998 pages, LIFO batch:0
[    0.000000]   DMA32 zone: 1064 pages used for memmap
[    0.000000]   DMA32 zone: 77822 pages, LIFO batch:15
[    0.000000] ACPI: PM-Timer IO Port: 0xb008
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] mapped APIC to ffffffffff5fc000 (        fee00000)
[    0.000000] ACPI: LAPIC (acpi_id[0x00] lapic_id[0x00] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x01] lapic_id[0x01] enabled)
[    0.000000] ACPI: NR_CPUS/possible_cpus limit of 1 reached.  Processor 1=
/0x1 ignored.
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
[    0.000000] mapped IOAPIC to ffffffffff5fb000 (fec00000)
[    0.000000] KVM setup async PF for cpu 0
[    0.000000] kvm-stealtime: cpu 0, msr 2031c80
[    0.000000] PM: Registered nosave memory: [mem 0x00000000-0x00000fff]
[    0.000000] PM: Registered nosave memory: [mem 0x0009f000-0x0009ffff]
[    0.000000] PM: Registered nosave memory: [mem 0x000a0000-0x000effff]
[    0.000000] PM: Registered nosave memory: [mem 0x000f0000-0x000fffff]
[    0.000000] e820: [mem 0x14000000-0xfeffbfff] available for PCI devices
[    0.000000] Booting paravirtualized kernel on KVM
[    0.000000] pcpu-alloc: s0 r0 d32768 u32768 alloc=3D1*32768
[    0.000000] pcpu-alloc: [0] 0=20
[    0.000000] Built 1 zonelists in Zone order, mobility grouping on.  Tota=
l pages: 80679
[    0.000000] Kernel command line: hung_task_panic=3D1 earlyprintk=3DttyS0=
,115200 debug apic=3Ddebug sysrq_always_enabled rcupdate.rcu_cpu_stall_time=
out=3D100 panic=3D-1 softlockup_panic=3D1 nmi_watchdog=3Dpanic oops=3Dpanic=
 load_ramdisk=3D2 prompt_ramdisk=3D0 console=3DttyS0,115200 console=3Dtty0 =
vga=3Dnormal  root=3D/dev/ram0 rw link=3D/kbuild-tests/run-queue/kvm/x86_64=
-randconfig-c0-1027/peterz-queue:master:f6a2b544517d33f6a1e428567bda96fd859=
ce1c9:bisect-linux-2/.vmlinuz-f6a2b544517d33f6a1e428567bda96fd859ce1c9-2014=
1027213935-19-vp branch=3Dpeterz-queue/master BOOT_IMAGE=3D/kernel/x86_64-r=
andconfig-c0-1027/f6a2b544517d33f6a1e428567bda96fd859ce1c9/vmlinuz-3.18.0-r=
c2-gf6a2b54 drbd.minor_count=3D8
[    0.000000] PID hash table entries: 2048 (order: 2, 16384 bytes)
[    0.000000] Dentry cache hash table entries: 65536 (order: 7, 524288 byt=
es)
[    0.000000] Inode-cache hash table entries: 32768 (order: 6, 262144 byte=
s)
[    0.000000] Memory: 263344K/327280K available (9374K kernel code, 2080K =
rwdata, 5096K rodata, 1196K init, 14660K bss, 63936K reserved)
[    0.000000] NR_IRQS:4352 nr_irqs:256 0
[    0.000000] console [ttyS0] enabled
[    0.000000] console [ttyS0] enabled
[    0.000000] Lock dependency validator: Copyright (c) 2006 Red Hat, Inc.,=
 Ingo Molnar
[    0.000000] Lock dependency validator: Copyright (c) 2006 Red Hat, Inc.,=
 Ingo Molnar
[    0.000000] ... MAX_LOCKDEP_SUBCLASSES:  8
[    0.000000] ... MAX_LOCKDEP_SUBCLASSES:  8
[    0.000000] ... MAX_LOCK_DEPTH:          48
[    0.000000] ... MAX_LOCK_DEPTH:          48
[    0.000000] ... MAX_LOCKDEP_KEYS:        8191
[    0.000000] ... MAX_LOCKDEP_KEYS:        8191
[    0.000000] ... CLASSHASH_SIZE:          4096
[    0.000000] ... CLASSHASH_SIZE:          4096
[    0.000000] ... MAX_LOCKDEP_ENTRIES:     32768
[    0.000000] ... MAX_LOCKDEP_ENTRIES:     32768
[    0.000000] ... MAX_LOCKDEP_CHAINS:      65536
[    0.000000] ... MAX_LOCKDEP_CHAINS:      65536
[    0.000000] ... CHAINHASH_SIZE:          32768
[    0.000000] ... CHAINHASH_SIZE:          32768
[    0.000000]  memory used by lock dependency info: 8159 kB
[    0.000000]  memory used by lock dependency info: 8159 kB
[    0.000000]  per task-struct memory footprint: 1920 bytes
[    0.000000]  per task-struct memory footprint: 1920 bytes
[    0.000000] ------------------------
[    0.000000] ------------------------
[    0.000000] | Locking API testsuite:
[    0.000000] | Locking API testsuite:
[    0.000000] ------------------------------------------------------------=
----------------
[    0.000000] ------------------------------------------------------------=
----------------
[    0.000000]                                  | spin |wlock |rlock |mutex=
 | wsem | rsem |
[    0.000000]                                  | spin |wlock |rlock |mutex=
 | wsem | rsem |
[    0.000000]   ----------------------------------------------------------=
----------------
[    0.000000]   ----------------------------------------------------------=
----------------
[    0.000000]                      A-A deadlock:
[    0.000000]                      A-A deadlock:  ok  |  ok  |  ok  |  ok =
 |  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |

[    0.000000]                  A-B-B-A deadlock:
[    0.000000]                  A-B-B-A deadlock:  ok  |  ok  |  ok  |  ok =
 |  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |

[    0.000000]              A-B-B-C-C-A deadlock:
[    0.000000]              A-B-B-C-C-A deadlock:  ok  |  ok  |  ok  |  ok =
 |  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |

[    0.000000]              A-B-C-A-B-C deadlock:
[    0.000000]              A-B-C-A-B-C deadlock:  ok  |  ok  |  ok  |  ok =
 |  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |

[    0.000000]          A-B-B-C-C-D-D-A deadlock:
[    0.000000]          A-B-B-C-C-D-D-A deadlock:  ok  |  ok  |  ok  |  ok =
 |  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |

[    0.000000]          A-B-C-D-B-D-D-A deadlock:
[    0.000000]          A-B-C-D-B-D-D-A deadlock:  ok  |  ok  |  ok  |  ok =
 |  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |

[    0.000000]          A-B-C-D-B-C-D-A deadlock:
[    0.000000]          A-B-C-D-B-C-D-A deadlock:  ok  |  ok  |  ok  |  ok =
 |  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |

[    0.000000]                     double unlock:
[    0.000000]                     double unlock:  ok  |  ok  |  ok  |  ok =
 |  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |

[    0.000000]                   initialize held:
[    0.000000]                   initialize held:  ok  |  ok  |  ok  |  ok =
 |  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |

[    0.000000]                  bad unlock order:
[    0.000000]                  bad unlock order:  ok  |  ok  |  ok  |  ok =
 |  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |

[    0.000000]   ----------------------------------------------------------=
----------------
[    0.000000]   ----------------------------------------------------------=
----------------
[    0.000000]               recursive read-lock:
[    0.000000]               recursive read-lock:             |            =
 |  ok  |  ok  |             |             |  ok  |  ok  |

[    0.000000]            recursive read-lock #2:
[    0.000000]            recursive read-lock #2:             |            =
 |  ok  |  ok  |             |             |  ok  |  ok  |

[    0.000000]             mixed read-write-lock:
[    0.000000]             mixed read-write-lock:             |            =
 |  ok  |  ok  |             |             |  ok  |  ok  |

[    0.000000]             mixed write-read-lock:
[    0.000000]             mixed write-read-lock:             |            =
 |  ok  |  ok  |             |             |  ok  |  ok  |

[    0.000000]   ----------------------------------------------------------=
----------------
[    0.000000]   ----------------------------------------------------------=
----------------
[    0.000000]      hard-irqs-on + irq-safe-A/12:
[    0.000000]      hard-irqs-on + irq-safe-A/12:  ok  |  ok  |  ok  |  ok =
 |  ok  |  ok  |

[    0.000000]      soft-irqs-on + irq-safe-A/12:
[    0.000000]      soft-irqs-on + irq-safe-A/12:  ok  |  ok  |  ok  |  ok =
 |  ok  |  ok  |

[    0.000000]      hard-irqs-on + irq-safe-A/21:
[    0.000000]      hard-irqs-on + irq-safe-A/21:  ok  |  ok  |  ok  |  ok =
 |  ok  |  ok  |

[    0.000000]      soft-irqs-on + irq-safe-A/21:
[    0.000000]      soft-irqs-on + irq-safe-A/21:  ok  |  ok  |  ok  |  ok =
 |  ok  |  ok  |

[    0.000000]        sirq-safe-A =3D> hirqs-on/12:
[    0.000000]        sirq-safe-A =3D> hirqs-on/12:  ok  |  ok  |  ok  |  o=
k  |  ok  |  ok  |

[    0.000000]        sirq-safe-A =3D> hirqs-on/21:
[    0.000000]        sirq-safe-A =3D> hirqs-on/21:  ok  |  ok  |  ok  |  o=
k  |  ok  |  ok  |

[    0.000000]          hard-safe-A + irqs-on/12:
[    0.000000]          hard-safe-A + irqs-on/12:  ok  |  ok  |  ok  |  ok =
 |  ok  |  ok  |

[    0.000000]          soft-safe-A + irqs-on/12:
[    0.000000]          soft-safe-A + irqs-on/12:  ok  |  ok  |  ok  |  ok =
 |  ok  |  ok  |

[    0.000000]          hard-safe-A + irqs-on/21:
[    0.000000]          hard-safe-A + irqs-on/21:  ok  |  ok  |  ok  |  ok =
 |  ok  |  ok  |

[    0.000000]          soft-safe-A + irqs-on/21:
[    0.000000]          soft-safe-A + irqs-on/21:  ok  |  ok  |  ok  |  ok =
 |  ok  |  ok  |

[    0.000000]     hard-safe-A + unsafe-B #1/123:
[    0.000000]     hard-safe-A + unsafe-B #1/123:  ok  |  ok  |  ok  |  ok =
 |  ok  |  ok  |

[    0.000000]     soft-safe-A + unsafe-B #1/123:
[    0.000000]     soft-safe-A + unsafe-B #1/123:  ok  |  ok  |  ok  |  ok =
 |  ok  |  ok  |

[    0.000000]     hard-safe-A + unsafe-B #1/132:
[    0.000000]     hard-safe-A + unsafe-B #1/132:  ok  |  ok  |  ok  |  ok =
 |  ok  |  ok  |

[    0.000000]     soft-safe-A + unsafe-B #1/132:
[    0.000000]     soft-safe-A + unsafe-B #1/132:  ok  |  ok  |  ok  |  ok =
 |  ok  |  ok  |

[    0.000000]     hard-safe-A + unsafe-B #1/213:
[    0.000000]     hard-safe-A + unsafe-B #1/213:  ok  |  ok  |  ok  |  ok =
 |  ok  |  ok  |

[    0.000000]     soft-safe-A + unsafe-B #1/213:
[    0.000000]     soft-safe-A + unsafe-B #1/213:  ok  |  ok  |  ok  |  ok =
 |  ok  |  ok  |

[    0.000000]     hard-safe-A + unsafe-B #1/231:
[    0.000000]     hard-safe-A + unsafe-B #1/231:  ok  |  ok  |  ok  |  ok =
 |  ok  |  ok  |

[    0.000000]     soft-safe-A + unsafe-B #1/231:
[    0.000000]     soft-safe-A + unsafe-B #1/231:  ok  |  ok  |  ok  |  ok =
 |  ok  |  ok  |

[    0.000000]     hard-safe-A + unsafe-B #1/312:
[    0.000000]     hard-safe-A + unsafe-B #1/312:  ok  |  ok  |  ok  |  ok =
 |  ok  |  ok  |

[    0.000000]     soft-safe-A + unsafe-B #1/312:
[    0.000000]     soft-safe-A + unsafe-B #1/312:  ok  |  ok  |  ok  |  ok =
 |  ok  |  ok  |

[    0.000000]     hard-safe-A + unsafe-B #1/321:
[    0.000000]     hard-safe-A + unsafe-B #1/321:  ok  |  ok  |  ok  |  ok =
 |  ok  |  ok  |

[    0.000000]     soft-safe-A + unsafe-B #1/321:
[    0.000000]     soft-safe-A + unsafe-B #1/321:  ok  |  ok  |  ok  |  ok =
 |  ok  |  ok  |

[    0.000000]     hard-safe-A + unsafe-B #2/123:
[    0.000000]     hard-safe-A + unsafe-B #2/123:  ok  |  ok  |  ok  |  ok =
 |  ok  |  ok  |

[    0.000000]     soft-safe-A + unsafe-B #2/123:
[    0.000000]     soft-safe-A + unsafe-B #2/123:  ok  |  ok  |  ok  |  ok =
 |  ok  |  ok  |

[    0.000000]     hard-safe-A + unsafe-B #2/132:
[    0.000000]     hard-safe-A + unsafe-B #2/132:  ok  |  ok  |  ok  |  ok =
 |  ok  |  ok  |

[    0.000000]     soft-safe-A + unsafe-B #2/132:
[    0.000000]     soft-safe-A + unsafe-B #2/132:  ok  |  ok  |  ok  |  ok =
 |  ok  |  ok  |

[    0.000000]     hard-safe-A + unsafe-B #2/213:
[    0.000000]     hard-safe-A + unsafe-B #2/213:  ok  |  ok  |  ok  |  ok =
 |  ok  |  ok  |

[    0.000000]     soft-safe-A + unsafe-B #2/213:
[    0.000000]     soft-safe-A + unsafe-B #2/213:  ok  |  ok  |  ok  |  ok =
 |  ok  |  ok  |

[    0.000000]     hard-safe-A + unsafe-B #2/231:
[    0.000000]     hard-safe-A + unsafe-B #2/231:  ok  |  ok  |  ok  |  ok =
 |  ok  |  ok  |

[    0.000000]     soft-safe-A + unsafe-B #2/231:
[    0.000000]     soft-safe-A + unsafe-B #2/231:  ok  |  ok  |  ok  |  ok =
 |  ok  |  ok  |

[    0.000000]     hard-safe-A + unsafe-B #2/312:
[    0.000000]     hard-safe-A + unsafe-B #2/312:  ok  |  ok  |  ok  |  ok =
 |  ok  |  ok  |

[    0.000000]     soft-safe-A + unsafe-B #2/312:
[    0.000000]     soft-safe-A + unsafe-B #2/312:  ok  |  ok  |  ok  |  ok =
 |  ok  |  ok  |

[    0.000000]     hard-safe-A + unsafe-B #2/321:
[    0.000000]     hard-safe-A + unsafe-B #2/321:  ok  |  ok  |  ok  |  ok =
 |  ok  |  ok  |

[    0.000000]     soft-safe-A + unsafe-B #2/321:
[    0.000000]     soft-safe-A + unsafe-B #2/321:  ok  |  ok  |  ok  |  ok =
 |  ok  |  ok  |

[    0.000000]       hard-irq lock-inversion/123:
[    0.000000]       hard-irq lock-inversion/123:  ok  |  ok  |  ok  |  ok =
 |  ok  |  ok  |

[    0.000000]       soft-irq lock-inversion/123:
[    0.000000]       soft-irq lock-inversion/123:  ok  |  ok  |  ok  |  ok =
 |  ok  |  ok  |

[    0.000000]       hard-irq lock-inversion/132:
[    0.000000]       hard-irq lock-inversion/132:  ok  |  ok  |  ok  |  ok =
 |  ok  |  ok  |

[    0.000000]       soft-irq lock-inversion/132:
[    0.000000]       soft-irq lock-inversion/132:  ok  |  ok  |  ok  |  ok =
 |  ok  |  ok  |

[    0.000000]       hard-irq lock-inversion/213:
[    0.000000]       hard-irq lock-inversion/213:  ok  |  ok  |  ok  |  ok =
 |  ok  |  ok  |

[    0.000000]       soft-irq lock-inversion/213:
[    0.000000]       soft-irq lock-inversion/213:  ok  |  ok  |  ok  |  ok =
 |  ok  |  ok  |

[    0.000000]       hard-irq lock-inversion/231:
[    0.000000]       hard-irq lock-inversion/231:  ok  |  ok  |  ok  |  ok =
 |  ok  |  ok  |

[    0.000000]       soft-irq lock-inversion/231:
[    0.000000]       soft-irq lock-inversion/231:  ok  |  ok  |  ok  |  ok =
 |  ok  |  ok  |

[    0.000000]       hard-irq lock-inversion/312:
[    0.000000]       hard-irq lock-inversion/312:  ok  |  ok  |  ok  |  ok =
 |  ok  |  ok  |

[    0.000000]       soft-irq lock-inversion/312:
[    0.000000]       soft-irq lock-inversion/312:  ok  |  ok  |  ok  |  ok =
 |  ok  |  ok  |

[    0.000000]       hard-irq lock-inversion/321:
[    0.000000]       hard-irq lock-inversion/321:  ok  |  ok  |  ok  |  ok =
 |  ok  |  ok  |

[    0.000000]       soft-irq lock-inversion/321:
[    0.000000]       soft-irq lock-inversion/321:  ok  |  ok  |  ok  |  ok =
 |  ok  |  ok  |

[    0.000000]       hard-irq read-recursion/123:
[    0.000000]       hard-irq read-recursion/123:  ok  |  ok  |

[    0.000000]       soft-irq read-recursion/123:
[    0.000000]       soft-irq read-recursion/123:  ok  |  ok  |

[    0.000000]       hard-irq read-recursion/132:
[    0.000000]       hard-irq read-recursion/132:  ok  |  ok  |

[    0.000000]       soft-irq read-recursion/132:
[    0.000000]       soft-irq read-recursion/132:  ok  |  ok  |

[    0.000000]       hard-irq read-recursion/213:
[    0.000000]       hard-irq read-recursion/213:  ok  |  ok  |

[    0.000000]       soft-irq read-recursion/213:
[    0.000000]       soft-irq read-recursion/213:  ok  |  ok  |

[    0.000000]       hard-irq read-recursion/231:
[    0.000000]       hard-irq read-recursion/231:  ok  |  ok  |

[    0.000000]       soft-irq read-recursion/231:
[    0.000000]       soft-irq read-recursion/231:  ok  |  ok  |

[    0.000000]       hard-irq read-recursion/312:
[    0.000000]       hard-irq read-recursion/312:  ok  |  ok  |

[    0.000000]       soft-irq read-recursion/312:
[    0.000000]       soft-irq read-recursion/312:  ok  |  ok  |

[    0.000000]       hard-irq read-recursion/321:
[    0.000000]       hard-irq read-recursion/321:  ok  |  ok  |

[    0.000000]       soft-irq read-recursion/321:
[    0.000000]       soft-irq read-recursion/321:  ok  |  ok  |

[    0.000000]   ----------------------------------------------------------=
----------------
[    0.000000]   ----------------------------------------------------------=
----------------
[    0.000000]   | Wound/wait tests |
[    0.000000]   | Wound/wait tests |
[    0.000000]   ---------------------
[    0.000000]   ---------------------
[    0.000000]                   ww api failures:
[    0.000000]                   ww api failures:  ok  |  ok  |  ok  |  ok =
 |  ok  |  ok  |

[    0.000000]                ww contexts mixing:
[    0.000000]                ww contexts mixing:  ok  |  ok  |  ok  |  ok =
 |

[    0.000000]              finishing ww context:
[    0.000000]              finishing ww context:  ok  |  ok  |  ok  |  ok =
 |  ok  |  ok  |  ok  |  ok  |

[    0.000000]                locking mismatches:
[    0.000000]                locking mismatches:  ok  |  ok  |  ok  |  ok =
 |  ok  |  ok  |

[    0.000000]                  EDEADLK handling:
[    0.000000]                  EDEADLK handling:  ok  |  ok  |  ok  |  ok =
 |  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |  o=
k  |  ok  |  ok  |  ok  |  ok  |  ok  |

[    0.000000]            spinlock nest unlocked:
[    0.000000]            spinlock nest unlocked:  ok  |  ok  |

[    0.000000]   -----------------------------------------------------
[    0.000000]   -----------------------------------------------------
[    0.000000]                                  |block | try  |context|
[    0.000000]                                  |block | try  |context|
[    0.000000]   -----------------------------------------------------
[    0.000000]   -----------------------------------------------------
[    0.000000]                           context:
[    0.000000]                           context:  ok  |  ok  |  ok  |  ok =
 |  ok  |  ok  |

[    0.000000]                               try:
[    0.000000]                               try:  ok  |  ok  |  ok  |  ok =
 |  ok  |  ok  |

[    0.000000]                             block:
[    0.000000]                             block:  ok  |  ok  |  ok  |  ok =
 |  ok  |  ok  |

[    0.000000]                          spinlock:
[    0.000000]                          spinlock:  ok  |  ok  |  ok  |  ok =
 |  ok  |  ok  |

[    0.000000] -------------------------------------------------------
[    0.000000] -------------------------------------------------------
[    0.000000] Good, all 253 testcases passed! |
[    0.000000] Good, all 253 testcases passed! |
[    0.000000] ---------------------------------
[    0.000000] ---------------------------------
[    0.000000] allocated 1572864 bytes of page_cgroup
[    0.000000] allocated 1572864 bytes of page_cgroup
[    0.000000] please try 'cgroup_disable=3Dmemory' option if you don't wan=
t memory cgroups
[    0.000000] please try 'cgroup_disable=3Dmemory' option if you don't wan=
t memory cgroups
[    0.000000] ODEBUG: selftest passed
[    0.000000] ODEBUG: selftest passed
[    0.000000] hpet clockevent registered
[    0.000000] hpet clockevent registered
[    0.000000] tsc: Detected 2693.530 MHz processor
[    0.000000] tsc: Detected 2693.530 MHz processor
[    0.020000] Calibrating delay loop (skipped) preset value..=20
[    0.020000] Calibrating delay loop (skipped) preset value.. 5387.06 Bogo=
MIPS (lpj=3D26935300)
5387.06 BogoMIPS (lpj=3D26935300)
[    0.020000] pid_max: default: 32768 minimum: 301
[    0.020000] pid_max: default: 32768 minimum: 301
[    0.020000] ACPI: Core revision 20140926
[    0.020000] ACPI: Core revision 20140926
[    0.020673] ACPI:=20
[    0.020673] ACPI: All ACPI Tables successfully acquiredAll ACPI Tables s=
uccessfully acquired

[    0.022481] Mount-cache hash table entries: 1024 (order: 1, 8192 bytes)
[    0.022481] Mount-cache hash table entries: 1024 (order: 1, 8192 bytes)
[    0.024560] Mountpoint-cache hash table entries: 1024 (order: 1, 8192 by=
tes)
[    0.024560] Mountpoint-cache hash table entries: 1024 (order: 1, 8192 by=
tes)
[    0.027680] Initializing cgroup subsys memory
[    0.027680] Initializing cgroup subsys memory
[    0.029126] Initializing cgroup subsys blkio
[    0.029126] Initializing cgroup subsys blkio
[    0.030022] Initializing cgroup subsys perf_event
[    0.030022] Initializing cgroup subsys perf_event
[    0.031503] Initializing cgroup subsys debug
[    0.031503] Initializing cgroup subsys debug
[    0.032952] Last level iTLB entries: 4KB 0, 2MB 0, 4MB 0
[    0.032952] Last level dTLB entries: 4KB 0, 2MB 0, 4MB 0, 1GB 0
[    0.032952] Last level iTLB entries: 4KB 0, 2MB 0, 4MB 0
[    0.032952] Last level dTLB entries: 4KB 0, 2MB 0, 4MB 0, 1GB 0
[    0.036445] CPU:=20
[    0.036445] CPU: Intel Intel Common KVM processorCommon KVM processor (f=
am: 0f, model: 06 (fam: 0f, model: 06, stepping: 01)
, stepping: 01)
[    0.047620] ftrace: allocating 35123 entries in 138 pages
[    0.047620] ftrace: allocating 35123 entries in 138 pages
[    0.060187]=20
[    0.060187]=20
[    0.060500] =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
[    0.060500] =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
[    0.061307] [ INFO: suspicious RCU usage. ]
[    0.061307] [ INFO: suspicious RCU usage. ]
[    0.062109] 3.18.0-rc2-gf6a2b54 #404 Not tainted
[    0.062109] 3.18.0-rc2-gf6a2b54 #404 Not tainted
[    0.063049] -------------------------------
[    0.063049] -------------------------------
[    0.063807] kernel/sched/core.c:7408 suspicious rcu_dereference_check() =
usage!
[    0.063807] kernel/sched/core.c:7408 suspicious rcu_dereference_check() =
usage!
[    0.065419]=20
[    0.065419] other info that might help us debug this:
[    0.065419]=20
[    0.065419]=20
[    0.065419] other info that might help us debug this:
[    0.065419]=20
[    0.066875]=20
[    0.066875] rcu_scheduler_active =3D 1, debug_locks =3D 0
[    0.066875]=20
[    0.066875] rcu_scheduler_active =3D 1, debug_locks =3D 0
[    0.068070] 2 locks held by swapper/0:
[    0.068070] 2 locks held by swapper/0:
[    0.068752]  #0:=20
[    0.068752]  #0:  ( (&p->pi_lock&p->pi_lock){......}){......}, at: , at:=
 [<ffffffff810d0b05>] task_rq_lock+0x25/0xa2
[<ffffffff810d0b05>] task_rq_lock+0x25/0xa2
[    0.070000]  #1:=20
[    0.070000]  #1:  ( (&rq->lock&rq->lock){-.....}){-.....}, at: , at: [<f=
fffffff810d0b15>] task_rq_lock+0x35/0xa2
[<ffffffff810d0b15>] task_rq_lock+0x35/0xa2
[    0.070000]=20
[    0.070000] stack backtrace:
[    0.070000]=20
[    0.070000] stack backtrace:
[    0.070000] CPU: 0 PID: 0 Comm: swapper Not tainted 3.18.0-rc2-gf6a2b54 =
#404
[    0.070000] CPU: 0 PID: 0 Comm: swapper Not tainted 3.18.0-rc2-gf6a2b54 =
#404
[    0.070000]  0000000000000001
[    0.070000]  0000000000000001 ffffffff82003ca8 ffffffff82003ca8 ffffffff=
8191a91a ffffffff8191a91a ffffffff82003cd8 ffffffff82003cd8

[    0.070000]  ffffffff810e5c40
[    0.070000]  ffffffff810e5c40 ffff880012470000 ffff880012470000 ffffffff=
82040580 ffffffff82040580 0000000000000000 0000000000000000

[    0.070000]  0000000000000000
[    0.070000]  0000000000000000 ffffffff82003d38 ffffffff82003d38 ffffffff=
810d4eaa ffffffff810d4eaa 0000000000000000 0000000000000000

[    0.070000] Call Trace:
[    0.070000] Call Trace:
[    0.070000]  [<ffffffff8191a91a>] dump_stack+0x19/0x1b
[    0.070000]  [<ffffffff8191a91a>] dump_stack+0x19/0x1b
[    0.070000]  [<ffffffff810e5c40>] lockdep_rcu_suspicious+0xf6/0xff
[    0.070000]  [<ffffffff810e5c40>] lockdep_rcu_suspicious+0xf6/0xff
[    0.070000]  [<ffffffff810d4eaa>] sched_move_task+0xec/0x1b9
[    0.070000]  [<ffffffff810d4eaa>] sched_move_task+0xec/0x1b9
[    0.070000]  [<ffffffff810d4f9e>] cpu_cgroup_fork+0xe/0x10
[    0.070000]  [<ffffffff810d4f9e>] cpu_cgroup_fork+0xe/0x10
[    0.070000]  [<ffffffff8112180c>] cgroup_post_fork+0xf3/0x105
[    0.070000]  [<ffffffff8112180c>] cgroup_post_fork+0xf3/0x105
[    0.070000]  [<ffffffff810add12>] copy_process+0x18c6/0x1aa8
[    0.070000]  [<ffffffff810add12>] copy_process+0x18c6/0x1aa8
[    0.070000]  [<ffffffff819122b4>] ? rest_init+0x138/0x138
[    0.070000]  [<ffffffff819122b4>] ? rest_init+0x138/0x138
[    0.070000]  [<ffffffff81926da7>] ? smp_apic_timer_interrupt+0x4f/0x4f
[    0.070000]  [<ffffffff81926da7>] ? smp_apic_timer_interrupt+0x4f/0x4f
[    0.070000]  [<ffffffff810e1d5d>] ? mark_held_locks+0x5d/0x74
[    0.070000]  [<ffffffff810e1d5d>] ? mark_held_locks+0x5d/0x74
[    0.070000]  [<ffffffff810ae0ed>] do_fork+0x103/0x793
[    0.070000]  [<ffffffff810ae0ed>] do_fork+0x103/0x793
[    0.070000]  [<ffffffff819122b4>] ? rest_init+0x138/0x138
[    0.070000]  [<ffffffff819122b4>] ? rest_init+0x138/0x138
[    0.070000]  [<ffffffff810e2108>] ? trace_hardirqs_on+0xd/0xf
[    0.070000]  [<ffffffff810e2108>] ? trace_hardirqs_on+0xd/0xf
[    0.070000]  [<ffffffff810ae7a3>] kernel_thread+0x26/0x28
[    0.070000]  [<ffffffff810ae7a3>] kernel_thread+0x26/0x28
[    0.070000]  [<ffffffff8191219f>] rest_init+0x23/0x138
[    0.070000]  [<ffffffff8191219f>] rest_init+0x23/0x138
[    0.070000]  [<ffffffff8220b01f>] start_kernel+0x56f/0x57c
[    0.070000]  [<ffffffff8220b01f>] start_kernel+0x56f/0x57c
[    0.070000]  [<ffffffff8220a120>] ? early_idt_handlers+0x120/0x120
[    0.070000]  [<ffffffff8220a120>] ? early_idt_handlers+0x120/0x120
[    0.070000]  [<ffffffff8220a473>] x86_64_start_reservations+0x2a/0x2c
[    0.070000]  [<ffffffff8220a473>] x86_64_start_reservations+0x2a/0x2c
[    0.070000]  [<ffffffff8220a5b5>] x86_64_start_kernel+0x140/0x14f
[    0.070000]  [<ffffffff8220a5b5>] x86_64_start_kernel+0x140/0x14f
[    0.070177] Performance Events:=20
[    0.070177] Performance Events: unsupported Netburst CPU model 6 unsuppo=
rted Netburst CPU model 6 no PMU driver, software events only.
no PMU driver, software events only.
[    0.073520]=20
[    0.073520] **********************************************************
[    0.073520]=20
[    0.073520] **********************************************************
[    0.080007] **   NOTICE NOTICE NOTICE NOTICE NOTICE NOTICE NOTICE   **
[    0.080007] **   NOTICE NOTICE NOTICE NOTICE NOTICE NOTICE NOTICE   **
[    0.082237] **                                                      **
[    0.082237] **                                                      **
[    0.084355] ** trace_printk() being used. Allocating extra memory.  **
[    0.084355] ** trace_printk() being used. Allocating extra memory.  **
[    0.086427] **                                                      **
[    0.086427] **                                                      **
[    0.088301] ** This means that this is a DEBUG kernel and it is     **
[    0.088301] ** This means that this is a DEBUG kernel and it is     **
[    0.090009] ** unsafe for produciton use.                           **
[    0.090009] ** unsafe for produciton use.                           **
[    0.091804] **                                                      **
[    0.091804] **                                                      **
[    0.093679] ** If you see this message and you are not debugging    **
[    0.093679] ** If you see this message and you are not debugging    **
[    0.095542] ** the kernel, report this immediately to your vendor!  **
[    0.095542] ** the kernel, report this immediately to your vendor!  **
[    0.097609] **                                                      **
[    0.097609] **                                                      **
[    0.100008] **   NOTICE NOTICE NOTICE NOTICE NOTICE NOTICE NOTICE   **
[    0.100008] **   NOTICE NOTICE NOTICE NOTICE NOTICE NOTICE NOTICE   **
[    0.102019] **********************************************************
[    0.102019] **********************************************************
[    0.104772] Getting VERSION: 50014
[    0.104772] Getting VERSION: 50014
[    0.105701] Getting VERSION: 50014
[    0.105701] Getting VERSION: 50014
[    0.106615] Getting ID: 0
[    0.106615] Getting ID: 0
[    0.107343] Getting ID: ff000000
[    0.107343] Getting ID: ff000000
[    0.108216] Getting LVT0: 8700
[    0.108216] Getting LVT0: 8700
[    0.110011] Getting LVT1: 8400
[    0.110011] Getting LVT1: 8400
[    0.110905] enabled ExtINT on CPU#0
[    0.110905] enabled ExtINT on CPU#0
[    0.112932] ENABLING IO-APIC IRQs
[    0.112932] ENABLING IO-APIC IRQs
[    0.113831] init IO_APIC IRQs
[    0.113831] init IO_APIC IRQs
[    0.114637]  apic 0 pin 0 not connected
[    0.114637]  apic 0 pin 0 not connected
[    0.115664] IOAPIC[0]: Set routing entry (0-1 -> 0x31 -> IRQ 1 Mode:0 Ac=
tive:0 Dest:1)
[    0.115664] IOAPIC[0]: Set routing entry (0-1 -> 0x31 -> IRQ 1 Mode:0 Ac=
tive:0 Dest:1)
[    0.117776] IOAPIC[0]: Set routing entry (0-2 -> 0x30 -> IRQ 0 Mode:0 Ac=
tive:0 Dest:1)
[    0.117776] IOAPIC[0]: Set routing entry (0-2 -> 0x30 -> IRQ 0 Mode:0 Ac=
tive:0 Dest:1)
[    0.120028] IOAPIC[0]: Set routing entry (0-2 -> 0x30 -> IRQ 0 Mode:0 Ac=
tive:0 Dest:1)
[    0.120028] IOAPIC[0]: Set routing entry (0-2 -> 0x30 -> IRQ 0 Mode:0 Ac=
tive:0 Dest:1)
[    0.122158] IOAPIC[0]: Set routing entry (0-3 -> 0x33 -> IRQ 3 Mode:0 Ac=
tive:0 Dest:1)
[    0.122158] IOAPIC[0]: Set routing entry (0-3 -> 0x33 -> IRQ 3 Mode:0 Ac=
tive:0 Dest:1)
[    0.124268] IOAPIC[0]: Set routing entry (0-4 -> 0x34 -> IRQ 4 Mode:0 Ac=
tive:0 Dest:1)
[    0.124268] IOAPIC[0]: Set routing entry (0-4 -> 0x34 -> IRQ 4 Mode:0 Ac=
tive:0 Dest:1)
[    0.126383] IOAPIC[0]: Set routing entry (0-5 -> 0x35 -> IRQ 5 Mode:1 Ac=
tive:0 Dest:1)
[    0.126383] IOAPIC[0]: Set routing entry (0-5 -> 0x35 -> IRQ 5 Mode:1 Ac=
tive:0 Dest:1)
[    0.128489] IOAPIC[0]: Set routing entry (0-6 -> 0x36 -> IRQ 6 Mode:0 Ac=
tive:0 Dest:1)
[    0.128489] IOAPIC[0]: Set routing entry (0-6 -> 0x36 -> IRQ 6 Mode:0 Ac=
tive:0 Dest:1)
[    0.130026] IOAPIC[0]: Set routing entry (0-7 -> 0x37 -> IRQ 7 Mode:0 Ac=
tive:0 Dest:1)
[    0.130026] IOAPIC[0]: Set routing entry (0-7 -> 0x37 -> IRQ 7 Mode:0 Ac=
tive:0 Dest:1)
[    0.132108] IOAPIC[0]: Set routing entry (0-8 -> 0x38 -> IRQ 8 Mode:0 Ac=
tive:0 Dest:1)
[    0.132108] IOAPIC[0]: Set routing entry (0-8 -> 0x38 -> IRQ 8 Mode:0 Ac=
tive:0 Dest:1)
[    0.134183] IOAPIC[0]: Set routing entry (0-9 -> 0x39 -> IRQ 9 Mode:1 Ac=
tive:0 Dest:1)
[    0.134183] IOAPIC[0]: Set routing entry (0-9 -> 0x39 -> IRQ 9 Mode:1 Ac=
tive:0 Dest:1)
[    0.136252] IOAPIC[0]: Set routing entry (0-10 -> 0x3a -> IRQ 10 Mode:1 =
Active:0 Dest:1)
[    0.136252] IOAPIC[0]: Set routing entry (0-10 -> 0x3a -> IRQ 10 Mode:1 =
Active:0 Dest:1)
[    0.138374] IOAPIC[0]: Set routing entry (0-11 -> 0x3b -> IRQ 11 Mode:1 =
Active:0 Dest:1)
[    0.138374] IOAPIC[0]: Set routing entry (0-11 -> 0x3b -> IRQ 11 Mode:1 =
Active:0 Dest:1)
[    0.140026] IOAPIC[0]: Set routing entry (0-12 -> 0x3c -> IRQ 12 Mode:0 =
Active:0 Dest:1)
[    0.140026] IOAPIC[0]: Set routing entry (0-12 -> 0x3c -> IRQ 12 Mode:0 =
Active:0 Dest:1)
[    0.142154] IOAPIC[0]: Set routing entry (0-13 -> 0x3d -> IRQ 13 Mode:0 =
Active:0 Dest:1)
[    0.142154] IOAPIC[0]: Set routing entry (0-13 -> 0x3d -> IRQ 13 Mode:0 =
Active:0 Dest:1)
[    0.144280] IOAPIC[0]: Set routing entry (0-14 -> 0x3e -> IRQ 14 Mode:0 =
Active:0 Dest:1)
[    0.144280] IOAPIC[0]: Set routing entry (0-14 -> 0x3e -> IRQ 14 Mode:0 =
Active:0 Dest:1)
[    0.146401] IOAPIC[0]: Set routing entry (0-15 -> 0x3f -> IRQ 15 Mode:0 =
Active:0 Dest:1)
[    0.146401] IOAPIC[0]: Set routing entry (0-15 -> 0x3f -> IRQ 15 Mode:0 =
Active:0 Dest:1)
[    0.148522]  apic 0 pin 16 not connected
[    0.148522]  apic 0 pin 16 not connected
[    0.150005]  apic 0 pin 17 not connected
[    0.150005]  apic 0 pin 17 not connected
[    0.151041]  apic 0 pin 18 not connected
[    0.151041]  apic 0 pin 18 not connected
[    0.152063]  apic 0 pin 19 not connected
[    0.152063]  apic 0 pin 19 not connected
[    0.153213]  apic 0 pin 20 not connected
[    0.153213]  apic 0 pin 20 not connected
[    0.154212]  apic 0 pin 21 not connected
[    0.154212]  apic 0 pin 21 not connected
[    0.155284]  apic 0 pin 22 not connected
[    0.155284]  apic 0 pin 22 not connected
[    0.156284]  apic 0 pin 23 not connected
[    0.156284]  apic 0 pin 23 not connected
[    0.157555] ..TIMER: vector=3D0x30 apic1=3D0 pin1=3D2 apic2=3D-1 pin2=3D=
-1
[    0.157555] ..TIMER: vector=3D0x30 apic1=3D0 pin1=3D2 apic2=3D-1 pin2=3D=
-1
[    0.160005] Using local APIC timer interrupts.
[    0.160005] calibrating APIC timer ...
[    0.160005] Using local APIC timer interrupts.
[    0.160005] calibrating APIC timer ...
[    0.170000] ... lapic delta =3D 6249566
[    0.170000] ... lapic delta =3D 6249566
[    0.170000] ... PM-Timer delta =3D 357892
[    0.170000] ... PM-Timer delta =3D 357892
[    0.170000] ... PM-Timer result ok
[    0.170000] ... PM-Timer result ok
[    0.170000] ..... delta 6249566
[    0.170000] ..... delta 6249566
[    0.170000] ..... mult: 268416815
[    0.170000] ..... mult: 268416815
[    0.170000] ..... calibration result: 9999305
[    0.170000] ..... calibration result: 9999305
[    0.170000] ..... CPU clock speed is 2692.9513 MHz.
[    0.170000] ..... CPU clock speed is 2692.9513 MHz.
[    0.170000] ..... host bus clock speed is 999.9305 MHz.
[    0.170000] ..... host bus clock speed is 999.9305 MHz.
[    0.170000] NMI watchdog: disabled (cpu0): hardware events not enabled
[    0.170000] NMI watchdog: disabled (cpu0): hardware events not enabled
[    0.170000] xor: measuring software checksum speed
[    0.170000] xor: measuring software checksum speed
[    0.260028]    prefetch64-sse:   113.600 MB/sec
[    0.260028]    prefetch64-sse:   113.600 MB/sec
[    0.360010]    generic_sse:   112.800 MB/sec
[    0.360010]    generic_sse:   112.800 MB/sec
[    0.361416] xor: using function: prefetch64-sse (113.600 MB/sec)
[    0.361416] xor: using function: prefetch64-sse (113.600 MB/sec)
[    0.363389] prandom: seed boundary self test passed
[    0.363389] prandom: seed boundary self test passed
[    0.365689] prandom: 100 self tests passed
[    0.365689] prandom: 100 self tests passed
[    0.367274] NET: Registered protocol family 16
[    0.367274] NET: Registered protocol family 16
[    0.369819] cpuidle: using governor ladder
[    0.369819] cpuidle: using governor ladder
[    0.370575] ACPI: bus type PCI registered
[    0.370575] ACPI: bus type PCI registered
[    0.371969] PCI: Using configuration type 1 for base access
[    0.371969] PCI: Using configuration type 1 for base access
[    0.394613] Running resizable hashtable tests...
[    0.394613] Running resizable hashtable tests...
[    0.396171]   Adding 2048 keys
[    0.396171]   Adding 2048 keys
[    0.398908]   Traversal complete: counted=3D2048, nelems=3D2048, entries=
=3D2048
[    0.398908]   Traversal complete: counted=3D2048, nelems=3D2048, entries=
=3D2048
[    0.400210]   Table expansion iteration 0...
[    0.400210]   Table expansion iteration 0...
[    0.402195]   Verifying lookups...
[    0.402195]   Verifying lookups...
[    0.403553]   Table expansion iteration 1...
[    0.403553]   Table expansion iteration 1...
[    0.405763]   Verifying lookups...
[    0.405763]   Verifying lookups...
[    0.407059]   Table expansion iteration 2...
[    0.407059]   Table expansion iteration 2...
[    0.410844]   Verifying lookups...
[    0.410844]   Verifying lookups...
[    0.412085]   Table expansion iteration 3...
[    0.412085]   Table expansion iteration 3...
[    0.415762]   Verifying lookups...
[    0.415762]   Verifying lookups...
[    0.417067]   Table shrinkage iteration 0...
[    0.417067]   Table shrinkage iteration 0...
[    0.418983]   Verifying lookups...
[    0.418983]   Verifying lookups...
[    0.420202]   Table shrinkage iteration 1...
[    0.420202]   Table shrinkage iteration 1...
[    0.421786]   Verifying lookups...
[    0.421786]   Verifying lookups...
[    0.423038]   Table shrinkage iteration 2...
[    0.423038]   Table shrinkage iteration 2...
[    0.424495]   Verifying lookups...
[    0.424495]   Verifying lookups...
[    0.425738]   Table shrinkage iteration 3...
[    0.425738]   Table shrinkage iteration 3...
[    0.427217]   Verifying lookups...
[    0.427217]   Verifying lookups...
[    0.428554]   Deleting 2048 keys
[    0.428554]   Deleting 2048 keys
[    0.600015] raid6: sse2x1    4545 MB/s
[    0.600015] raid6: sse2x1    4545 MB/s
[    0.770014] raid6: sse2x2    6460 MB/s
[    0.770014] raid6: sse2x2    6460 MB/s
[    0.940008] raid6: sse2x4    7613 MB/s
[    0.940008] raid6: sse2x4    7613 MB/s
[    0.941162] raid6: using algorithm sse2x4 (7613 MB/s)
[    0.941162] raid6: using algorithm sse2x4 (7613 MB/s)
[    0.942676] raid6: using intx1 recovery algorithm
[    0.942676] raid6: using intx1 recovery algorithm
[    0.944552] ACPI: Added _OSI(Module Device)
[    0.944552] ACPI: Added _OSI(Module Device)
[    0.945836] ACPI: Added _OSI(Processor Device)
[    0.945836] ACPI: Added _OSI(Processor Device)
[    0.947166] ACPI: Added _OSI(3.0 _SCP Extensions)
[    0.947166] ACPI: Added _OSI(3.0 _SCP Extensions)
[    0.948580] ACPI: Added _OSI(Processor Aggregator Device)
[    0.948580] ACPI: Added _OSI(Processor Aggregator Device)
[    0.951400] IOAPIC[0]: Set routing entry (0-9 -> 0x39 -> IRQ 9 Mode:1 Ac=
tive:0 Dest:1)
[    0.951400] IOAPIC[0]: Set routing entry (0-9 -> 0x39 -> IRQ 9 Mode:1 Ac=
tive:0 Dest:1)
[    0.960017] ACPI: Interpreter enabled
[    0.960017] ACPI: Interpreter enabled
[    0.961120] ACPI Exception: AE_NOT_FOUND,=20
[    0.961120] ACPI Exception: AE_NOT_FOUND, While evaluating Sleep State [=
\_S1_]While evaluating Sleep State [\_S1_] (20140926/hwxface-580)
 (20140926/hwxface-580)
[    0.963744] ACPI Exception: AE_NOT_FOUND,=20
[    0.963744] ACPI Exception: AE_NOT_FOUND, While evaluating Sleep State [=
\_S2_]While evaluating Sleep State [\_S2_] (20140926/hwxface-580)
 (20140926/hwxface-580)
[    0.966431] ACPI: (supports S0 S3 S4 S5)
[    0.966431] ACPI: (supports S0 S3 S4 S5)
[    0.967662] ACPI: Using IOAPIC for interrupt routing
[    0.967662] ACPI: Using IOAPIC for interrupt routing
[    0.969538] PCI: Using host bridge windows from ACPI; if necessary, use =
"pci=3Dnocrs" and report a bug
[    0.969538] PCI: Using host bridge windows from ACPI; if necessary, use =
"pci=3Dnocrs" and report a bug
[    0.985823] ACPI: PCI Root Bridge [PCI0] (domain 0000 [bus 00-ff])
[    0.985823] ACPI: PCI Root Bridge [PCI0] (domain 0000 [bus 00-ff])
[    0.987570] acpi PNP0A03:00: _OSC: OS supports [Segments]
[    0.987570] acpi PNP0A03:00: _OSC: OS supports [Segments]
[    0.989106] acpi PNP0A03:00: _OSC failed (AE_NOT_FOUND); disabling ASPM
[    0.989106] acpi PNP0A03:00: _OSC failed (AE_NOT_FOUND); disabling ASPM
[    0.990636] PCI host bridge to bus 0000:00
[    0.990636] PCI host bridge to bus 0000:00
[    0.991879] pci_bus 0000:00: root bus resource [bus 00-ff]
[    0.991879] pci_bus 0000:00: root bus resource [bus 00-ff]
[    0.993459] pci_bus 0000:00: root bus resource [io  0x0000-0x0cf7]
[    0.993459] pci_bus 0000:00: root bus resource [io  0x0000-0x0cf7]
[    0.995259] pci_bus 0000:00: root bus resource [io  0x0d00-0xffff]
[    0.995259] pci_bus 0000:00: root bus resource [io  0x0d00-0xffff]
[    0.997022] pci_bus 0000:00: root bus resource [mem 0x000a0000-0x000bfff=
f]
[    0.997022] pci_bus 0000:00: root bus resource [mem 0x000a0000-0x000bfff=
f]
[    1.000007] pci_bus 0000:00: root bus resource [mem 0x80000000-0xfebffff=
f]
[    1.000007] pci_bus 0000:00: root bus resource [mem 0x80000000-0xfebffff=
f]
[    1.002100] pci 0000:00:00.0: [8086:1237] type 00 class 0x060000
[    1.002100] pci 0000:00:00.0: [8086:1237] type 00 class 0x060000
[    1.004504] pci 0000:00:01.0: [8086:7000] type 00 class 0x060100
[    1.004504] pci 0000:00:01.0: [8086:7000] type 00 class 0x060100
[    1.007098] pci 0000:00:01.1: [8086:7010] type 00 class 0x010180
[    1.007098] pci 0000:00:01.1: [8086:7010] type 00 class 0x010180
[    1.011921] pci 0000:00:01.1: reg 0x20: [io  0xc1c0-0xc1cf]
[    1.011921] pci 0000:00:01.1: reg 0x20: [io  0xc1c0-0xc1cf]
[    1.014816] pci 0000:00:01.1: legacy IDE quirk: reg 0x10: [io  0x01f0-0x=
01f7]
[    1.014816] pci 0000:00:01.1: legacy IDE quirk: reg 0x10: [io  0x01f0-0x=
01f7]
[    1.016896] pci 0000:00:01.1: legacy IDE quirk: reg 0x14: [io  0x03f6]
[    1.016896] pci 0000:00:01.1: legacy IDE quirk: reg 0x14: [io  0x03f6]
[    1.018817] pci 0000:00:01.1: legacy IDE quirk: reg 0x18: [io  0x0170-0x=
0177]
[    1.018817] pci 0000:00:01.1: legacy IDE quirk: reg 0x18: [io  0x0170-0x=
0177]
[    1.020006] pci 0000:00:01.1: legacy IDE quirk: reg 0x1c: [io  0x0376]
[    1.020006] pci 0000:00:01.1: legacy IDE quirk: reg 0x1c: [io  0x0376]
[    1.022111] pci 0000:00:01.3: [8086:7113] type 00 class 0x068000
[    1.022111] pci 0000:00:01.3: [8086:7113] type 00 class 0x068000
[    1.023704] pci 0000:00:01.3: quirk: [io  0xb000-0xb03f] claimed by PIIX=
4 ACPI
[    1.023704] pci 0000:00:01.3: quirk: [io  0xb000-0xb03f] claimed by PIIX=
4 ACPI
[    1.025323] pci 0000:00:01.3: quirk: [io  0xb100-0xb10f] claimed by PIIX=
4 SMB
[    1.025323] pci 0000:00:01.3: quirk: [io  0xb100-0xb10f] claimed by PIIX=
4 SMB
[    1.027251] pci 0000:00:02.0: [1013:00b8] type 00 class 0x030000
[    1.027251] pci 0000:00:02.0: [1013:00b8] type 00 class 0x030000
[    1.033537] pci 0000:00:02.0: reg 0x10: [mem 0xfc000000-0xfdffffff pref]
[    1.033537] pci 0000:00:02.0: reg 0x10: [mem 0xfc000000-0xfdffffff pref]
[    1.037213] pci 0000:00:02.0: reg 0x14: [mem 0xfebf0000-0xfebf0fff]
[    1.037213] pci 0000:00:02.0: reg 0x14: [mem 0xfebf0000-0xfebf0fff]
[    1.046794] pci 0000:00:02.0: reg 0x30: [mem 0xfebe0000-0xfebeffff pref]
[    1.046794] pci 0000:00:02.0: reg 0x30: [mem 0xfebe0000-0xfebeffff pref]
[    1.049716] pci 0000:00:03.0: [8086:100e] type 00 class 0x020000
[    1.049716] pci 0000:00:03.0: [8086:100e] type 00 class 0x020000
[    1.051034] pci 0000:00:03.0: reg 0x10: [mem 0xfeba0000-0xfebbffff]
[    1.051034] pci 0000:00:03.0: reg 0x10: [mem 0xfeba0000-0xfebbffff]
[    1.053370] pci 0000:00:03.0: reg 0x14: [io  0xc000-0xc03f]
[    1.053370] pci 0000:00:03.0: reg 0x14: [io  0xc000-0xc03f]
[    1.061062] pci 0000:00:03.0: reg 0x30: [mem 0xfebc0000-0xfebdffff pref]
[    1.061062] pci 0000:00:03.0: reg 0x30: [mem 0xfebc0000-0xfebdffff pref]
[    1.062953] pci 0000:00:04.0: [1af4:1001] type 00 class 0x010000
[    1.062953] pci 0000:00:04.0: [1af4:1001] type 00 class 0x010000
[    1.065511] pci 0000:00:04.0: reg 0x10: [io  0xc040-0xc07f]
[    1.065511] pci 0000:00:04.0: reg 0x10: [io  0xc040-0xc07f]
[    1.067675] pci 0000:00:04.0: reg 0x14: [mem 0xfebf1000-0xfebf1fff]
[    1.067675] pci 0000:00:04.0: reg 0x14: [mem 0xfebf1000-0xfebf1fff]
[    1.075300] pci 0000:00:05.0: [1af4:1001] type 00 class 0x010000
[    1.075300] pci 0000:00:05.0: [1af4:1001] type 00 class 0x010000
[    1.077822] pci 0000:00:05.0: reg 0x10: [io  0xc080-0xc0bf]
[    1.077822] pci 0000:00:05.0: reg 0x10: [io  0xc080-0xc0bf]
[    1.080005] pci 0000:00:05.0: reg 0x14: [mem 0xfebf2000-0xfebf2fff]
[    1.080005] pci 0000:00:05.0: reg 0x14: [mem 0xfebf2000-0xfebf2fff]
[    1.086689] pci 0000:00:06.0: [1af4:1001] type 00 class 0x010000
[    1.086689] pci 0000:00:06.0: [1af4:1001] type 00 class 0x010000
[    1.088975] pci 0000:00:06.0: reg 0x10: [io  0xc0c0-0xc0ff]
[    1.088975] pci 0000:00:06.0: reg 0x10: [io  0xc0c0-0xc0ff]
[    1.090984] pci 0000:00:06.0: reg 0x14: [mem 0xfebf3000-0xfebf3fff]
[    1.090984] pci 0000:00:06.0: reg 0x14: [mem 0xfebf3000-0xfebf3fff]
[    1.097586] pci 0000:00:07.0: [1af4:1001] type 00 class 0x010000
[    1.097586] pci 0000:00:07.0: [1af4:1001] type 00 class 0x010000
[    1.100006] pci 0000:00:07.0: reg 0x10: [io  0xc100-0xc13f]
[    1.100006] pci 0000:00:07.0: reg 0x10: [io  0xc100-0xc13f]
[    1.102306] pci 0000:00:07.0: reg 0x14: [mem 0xfebf4000-0xfebf4fff]
[    1.102306] pci 0000:00:07.0: reg 0x14: [mem 0xfebf4000-0xfebf4fff]
[    1.109569] pci 0000:00:08.0: [1af4:1001] type 00 class 0x010000
[    1.109569] pci 0000:00:08.0: [1af4:1001] type 00 class 0x010000
[    1.111450] pci 0000:00:08.0: reg 0x10: [io  0xc140-0xc17f]
[    1.111450] pci 0000:00:08.0: reg 0x10: [io  0xc140-0xc17f]
[    1.114748] pci 0000:00:08.0: reg 0x14: [mem 0xfebf5000-0xfebf5fff]
[    1.114748] pci 0000:00:08.0: reg 0x14: [mem 0xfebf5000-0xfebf5fff]
[    1.124980] pci 0000:00:09.0: [1af4:1001] type 00 class 0x010000
[    1.124980] pci 0000:00:09.0: [1af4:1001] type 00 class 0x010000
[    1.129023] pci 0000:00:09.0: reg 0x10: [io  0xc180-0xc1bf]
[    1.129023] pci 0000:00:09.0: reg 0x10: [io  0xc180-0xc1bf]
[    1.131393] pci 0000:00:09.0: reg 0x14: [mem 0xfebf6000-0xfebf6fff]
[    1.131393] pci 0000:00:09.0: reg 0x14: [mem 0xfebf6000-0xfebf6fff]
[    1.142268] pci 0000:00:0a.0: [8086:25ab] type 00 class 0x088000
[    1.142268] pci 0000:00:0a.0: [8086:25ab] type 00 class 0x088000
[    1.145122] pci 0000:00:0a.0: reg 0x10: [mem 0xfebf7000-0xfebf700f]
[    1.145122] pci 0000:00:0a.0: reg 0x10: [mem 0xfebf7000-0xfebf700f]
[    1.151993] pci_bus 0000:00: on NUMA node 0
[    1.151993] pci_bus 0000:00: on NUMA node 0
[    1.154522] ACPI: PCI Interrupt Link [LNKA] (IRQs
[    1.154522] ACPI: PCI Interrupt Link [LNKA] (IRQs 5 5 *10 *10 11 11))

[    1.156749] ACPI: PCI Interrupt Link [LNKB] (IRQs
[    1.156749] ACPI: PCI Interrupt Link [LNKB] (IRQs 5 5 *10 *10 11 11))

[    1.158967] ACPI: PCI Interrupt Link [LNKC] (IRQs
[    1.158967] ACPI: PCI Interrupt Link [LNKC] (IRQs 5 5 10 10 *11 *11))

[    1.160701] ACPI: PCI Interrupt Link [LNKD] (IRQs
[    1.160701] ACPI: PCI Interrupt Link [LNKD] (IRQs 5 5 10 10 *11 *11))

[    1.162795] ACPI: PCI Interrupt Link [LNKS] (IRQs
[    1.162795] ACPI: PCI Interrupt Link [LNKS] (IRQs *9 *9))

[    1.165660] ACPI:=20
[    1.165660] ACPI: Enabled 16 GPEs in block 00 to 0FEnabled 16 GPEs in bl=
ock 00 to 0F

[    1.167802] vgaarb: setting as boot device: PCI:0000:00:02.0
[    1.167802] vgaarb: setting as boot device: PCI:0000:00:02.0
[    1.169659] vgaarb: device added: PCI:0000:00:02.0,decodes=3Dio+mem,owns=
=3Dio+mem,locks=3Dnone
[    1.169659] vgaarb: device added: PCI:0000:00:02.0,decodes=3Dio+mem,owns=
=3Dio+mem,locks=3Dnone
[    1.170007] vgaarb: loaded
[    1.170007] vgaarb: loaded
[    1.170582] vgaarb: bridge control possible 0000:00:02.0
[    1.170582] vgaarb: bridge control possible 0000:00:02.0
[    1.172413] SCSI subsystem initialized
[    1.172413] SCSI subsystem initialized
[    1.173680] libata version 3.00 loaded.
[    1.173680] libata version 3.00 loaded.
[    1.174665] ACPI: bus type USB registered
[    1.174665] ACPI: bus type USB registered
[    1.175600] usbcore: registered new interface driver usbfs
[    1.175600] usbcore: registered new interface driver usbfs
[    1.176803] usbcore: registered new interface driver hub
[    1.176803] usbcore: registered new interface driver hub
[    1.180038] usbcore: registered new device driver usb
[    1.180038] usbcore: registered new device driver usb
[    1.181332] Linux video capture interface: v2.00
[    1.181332] Linux video capture interface: v2.00
[    1.182490] pps_core: LinuxPPS API ver. 1 registered
[    1.182490] pps_core: LinuxPPS API ver. 1 registered
[    1.183980] pps_core: Software ver. 5.3.6 - Copyright 2005-2007 Rodolfo =
Giometti <giometti@linux.it>
[    1.183980] pps_core: Software ver. 5.3.6 - Copyright 2005-2007 Rodolfo =
Giometti <giometti@linux.it>
[    1.186523] Advanced Linux Sound Architecture Driver Initialized.
[    1.186523] Advanced Linux Sound Architecture Driver Initialized.
[    1.187872] PCI: Using ACPI for IRQ routing
[    1.187872] PCI: Using ACPI for IRQ routing
[    1.189189] PCI: pci_cache_line_size set to 64 bytes
[    1.189189] PCI: pci_cache_line_size set to 64 bytes
[    1.190192] e820: reserve RAM buffer [mem 0x0009fc00-0x0009ffff]
[    1.190192] e820: reserve RAM buffer [mem 0x0009fc00-0x0009ffff]
[    1.191455] e820: reserve RAM buffer [mem 0x13ffe000-0x13ffffff]
[    1.191455] e820: reserve RAM buffer [mem 0x13ffe000-0x13ffffff]
[    1.194279] Switched to clocksource kvm-clock
[    1.194279] Switched to clocksource kvm-clock
[    1.196313] Warning: could not register annotated branches stats
[    1.196313] Warning: could not register annotated branches stats
[    1.226357] FS-Cache: Loaded
[    1.226357] FS-Cache: Loaded
[    1.227448] CacheFiles: Loaded
[    1.227448] CacheFiles: Loaded
[    1.228499] pnp: PnP ACPI init
[    1.228499] pnp: PnP ACPI init
[    1.229636] IOAPIC[0]: Set routing entry (0-8 -> 0x38 -> IRQ 8 Mode:0 Ac=
tive:0 Dest:1)
[    1.229636] IOAPIC[0]: Set routing entry (0-8 -> 0x38 -> IRQ 8 Mode:0 Ac=
tive:0 Dest:1)
[    1.232307] pnp 00:00: Plug and Play ACPI device, IDs PNP0b00 (active)
[    1.232307] pnp 00:00: Plug and Play ACPI device, IDs PNP0b00 (active)
[    1.234429] IOAPIC[0]: Set routing entry (0-1 -> 0x31 -> IRQ 1 Mode:0 Ac=
tive:0 Dest:1)
[    1.234429] IOAPIC[0]: Set routing entry (0-1 -> 0x31 -> IRQ 1 Mode:0 Ac=
tive:0 Dest:1)
[    1.237001] pnp 00:01: Plug and Play ACPI device, IDs PNP0303 (active)
[    1.237001] pnp 00:01: Plug and Play ACPI device, IDs PNP0303 (active)
[    1.239148] IOAPIC[0]: Set routing entry (0-12 -> 0x3c -> IRQ 12 Mode:0 =
Active:0 Dest:1)
[    1.239148] IOAPIC[0]: Set routing entry (0-12 -> 0x3c -> IRQ 12 Mode:0 =
Active:0 Dest:1)
[    1.241919] pnp 00:02: Plug and Play ACPI device, IDs PNP0f13 (active)
[    1.241919] pnp 00:02: Plug and Play ACPI device, IDs PNP0f13 (active)
[    1.244694] IOAPIC[0]: Set routing entry (0-6 -> 0x36 -> IRQ 6 Mode:0 Ac=
tive:0 Dest:1)
[    1.244694] IOAPIC[0]: Set routing entry (0-6 -> 0x36 -> IRQ 6 Mode:0 Ac=
tive:0 Dest:1)
[    1.247880] pnp 00:03: [dma 2]
[    1.247880] pnp 00:03: [dma 2]
[    1.249494] pnp 00:03: Plug and Play ACPI device, IDs PNP0700 (active)
[    1.249494] pnp 00:03: Plug and Play ACPI device, IDs PNP0700 (active)
[    1.252306] IOAPIC[0]: Set routing entry (0-7 -> 0x37 -> IRQ 7 Mode:0 Ac=
tive:0 Dest:1)
[    1.252306] IOAPIC[0]: Set routing entry (0-7 -> 0x37 -> IRQ 7 Mode:0 Ac=
tive:0 Dest:1)
[    1.255366] pnp 00:04: Plug and Play ACPI device, IDs PNP0400 (active)
[    1.255366] pnp 00:04: Plug and Play ACPI device, IDs PNP0400 (active)
[    1.257952] IOAPIC[0]: Set routing entry (0-4 -> 0x34 -> IRQ 4 Mode:0 Ac=
tive:0 Dest:1)
[    1.257952] IOAPIC[0]: Set routing entry (0-4 -> 0x34 -> IRQ 4 Mode:0 Ac=
tive:0 Dest:1)
[    1.260945] pnp 00:05: Plug and Play ACPI device, IDs PNP0501 (active)
[    1.260945] pnp 00:05: Plug and Play ACPI device, IDs PNP0501 (active)
[    1.263784] IOAPIC[0]: Set routing entry (0-3 -> 0x33 -> IRQ 3 Mode:0 Ac=
tive:0 Dest:1)
[    1.263784] IOAPIC[0]: Set routing entry (0-3 -> 0x33 -> IRQ 3 Mode:0 Ac=
tive:0 Dest:1)
[    1.267047] pnp 00:06: Plug and Play ACPI device, IDs PNP0501 (active)
[    1.267047] pnp 00:06: Plug and Play ACPI device, IDs PNP0501 (active)
[    1.270373] pnp: PnP ACPI: found 7 devices
[    1.270373] pnp: PnP ACPI: found 7 devices
[    1.278385] pci_bus 0000:00: resource 4 [io  0x0000-0x0cf7]
[    1.278385] pci_bus 0000:00: resource 4 [io  0x0000-0x0cf7]
[    1.280262] pci_bus 0000:00: resource 5 [io  0x0d00-0xffff]
[    1.280262] pci_bus 0000:00: resource 5 [io  0x0d00-0xffff]
[    1.282013] pci_bus 0000:00: resource 6 [mem 0x000a0000-0x000bffff]
[    1.282013] pci_bus 0000:00: resource 6 [mem 0x000a0000-0x000bffff]
[    1.283937] pci_bus 0000:00: resource 7 [mem 0x80000000-0xfebfffff]
[    1.283937] pci_bus 0000:00: resource 7 [mem 0x80000000-0xfebfffff]
[    1.285904] NET: Registered protocol family 1
[    1.285904] NET: Registered protocol family 1
[    1.287229] pci 0000:00:00.0: Limiting direct PCI/PCI transfers
[    1.287229] pci 0000:00:00.0: Limiting direct PCI/PCI transfers
[    1.289476] pci 0000:00:01.0: PIIX3: Enabling Passive Release
[    1.289476] pci 0000:00:01.0: PIIX3: Enabling Passive Release
[    1.291814] pci 0000:00:01.0: Activating ISA DMA hang workarounds
[    1.291814] pci 0000:00:01.0: Activating ISA DMA hang workarounds
[    1.294104] pci 0000:00:02.0: Video device with shadowed ROM
[    1.294104] pci 0000:00:02.0: Video device with shadowed ROM
[    1.295959] PCI: CLS 0 bytes, default 64
[    1.295959] PCI: CLS 0 bytes, default 64
[    1.297481] Unpacking initramfs...
[    1.297481] Unpacking initramfs...
[    2.276078] Freeing initrd memory: 23244K (ffff88001293d000 - ffff880013=
ff0000)
[    2.276078] Freeing initrd memory: 23244K (ffff88001293d000 - ffff880013=
ff0000)
[    2.278381] microcode: CPU0 sig=3D0xf61, pf=3D0x1, revision=3D0x1
[    2.278381] microcode: CPU0 sig=3D0xf61, pf=3D0x1, revision=3D0x1
[    2.279731] microcode: Microcode Update Driver: v2.00 <tigran@aivazian.f=
snet.co.uk>, Peter Oruba
[    2.279731] microcode: Microcode Update Driver: v2.00 <tigran@aivazian.f=
snet.co.uk>, Peter Oruba
[    2.282716] cryptomgr_test (20) used greatest stack depth: 14512 bytes l=
eft
[    2.282716] cryptomgr_test (20) used greatest stack depth: 14512 bytes l=
eft
[    2.285210] des3_ede-x86_64: performance on this CPU would be suboptimal=
: disabling des3_ede-x86_64.
[    2.285210] des3_ede-x86_64: performance on this CPU would be suboptimal=
: disabling des3_ede-x86_64.
[    2.289022] camellia-x86_64: performance on this CPU would be suboptimal=
: disabling camellia-x86_64.
[    2.289022] camellia-x86_64: performance on this CPU would be suboptimal=
: disabling camellia-x86_64.
[    2.291014] blowfish-x86_64: performance on this CPU would be suboptimal=
: disabling blowfish-x86_64.
[    2.291014] blowfish-x86_64: performance on this CPU would be suboptimal=
: disabling blowfish-x86_64.
[    2.293417] twofish-x86_64-3way: performance on this CPU would be subopt=
imal: disabling twofish-x86_64-3way.
[    2.293417] twofish-x86_64-3way: performance on this CPU would be subopt=
imal: disabling twofish-x86_64-3way.
[    2.296714] sha1_ssse3: Neither AVX nor AVX2 nor SSSE3 is available/usab=
le.
[    2.296714] sha1_ssse3: Neither AVX nor AVX2 nor SSSE3 is available/usab=
le.
[    2.298279] sha512_ssse3: Neither AVX nor SSSE3 is available/usable.
[    2.298279] sha512_ssse3: Neither AVX nor SSSE3 is available/usable.
[    2.299707] AVX or AES-NI instructions are not detected.
[    2.299707] AVX or AES-NI instructions are not detected.
[    2.300920] AVX instructions are not detected.
[    2.300920] AVX instructions are not detected.
[    2.302445] AVX instructions are not detected.
[    2.302445] AVX instructions are not detected.
[    2.304128] AVX instructions are not detected.
[    2.304128] AVX instructions are not detected.
[    2.305850] AVX2 or AES-NI instructions are not detected.
[    2.305850] AVX2 or AES-NI instructions are not detected.
[    2.307916] AVX2 instructions are not detected.
[    2.307916] AVX2 instructions are not detected.
[    2.309918] rcu-torture:--- Start of test: nreaders=3D1 nfakewriters=3D4=
 stat_interval=3D60 verbose=3D1 test_no_idle_hz=3D1 shuffle_interval=3D3 st=
utter=3D5 irqreader=3D1 fqs_duration=3D0 fqs_holdoff=3D0 fqs_stutter=3D3 te=
st_boost=3D1/0 test_boost_interval=3D7 test_boost_duration=3D4 shutdown_sec=
s=3D0 stall_cpu=3D0 stall_cpu_holdoff=3D10 n_barrier_cbs=3D0 onoff_interval=
=3D0 onoff_holdoff=3D0
[    2.309918] rcu-torture:--- Start of test: nreaders=3D1 nfakewriters=3D4=
 stat_interval=3D60 verbose=3D1 test_no_idle_hz=3D1 shuffle_interval=3D3 st=
utter=3D5 irqreader=3D1 fqs_duration=3D0 fqs_holdoff=3D0 fqs_stutter=3D3 te=
st_boost=3D1/0 test_boost_interval=3D7 test_boost_duration=3D4 shutdown_sec=
s=3D0 stall_cpu=3D0 stall_cpu_holdoff=3D10 n_barrier_cbs=3D0 onoff_interval=
=3D0 onoff_holdoff=3D0
[    2.321926] rcu-torture: Creating rcu_torture_writer task
[    2.321926] rcu-torture: Creating rcu_torture_writer task
[    2.324074] rcu-torture: Creating rcu_torture_fakewriter task
[    2.324074] rcu-torture: Creating rcu_torture_fakewriter task
[    2.326328] rcu-torture: rcu_torture_writer task started
[    2.326328] rcu-torture: rcu_torture_writer task started
[    2.328248] rcu-torture: Creating rcu_torture_fakewriter task
[    2.328248] rcu-torture: Creating rcu_torture_fakewriter task
[    2.331147] rcu-torture: rcu_torture_fakewriter task started
[    2.331147] rcu-torture: rcu_torture_fakewriter task started
[    2.333137] rcu-torture: Creating rcu_torture_fakewriter task
[    2.333137] rcu-torture: Creating rcu_torture_fakewriter task
[    2.335386] rcu-torture: rcu_torture_fakewriter task started
[    2.335386] rcu-torture: rcu_torture_fakewriter task started
[    2.337560] rcu-torture: Creating rcu_torture_fakewriter task
[    2.337560] rcu-torture: Creating rcu_torture_fakewriter task
[    2.339826] rcu-torture: rcu_torture_fakewriter task started
[    2.339826] rcu-torture: rcu_torture_fakewriter task started
[    2.342029] rcu-torture: Creating rcu_torture_reader task
[    2.342029] rcu-torture: Creating rcu_torture_reader task
[    2.344211] rcu-torture: rcu_torture_fakewriter task started
[    2.344211] rcu-torture: rcu_torture_fakewriter task started
[    2.346380] rcu-torture: Creating rcu_torture_stats task
[    2.346380] rcu-torture: Creating rcu_torture_stats task
[    2.348533] rcu-torture: rcu_torture_reader task started
[    2.348533] rcu-torture: rcu_torture_reader task started
[    2.350654] rcu-torture: Creating torture_shuffle task
[    2.350654] rcu-torture: Creating torture_shuffle task
[    2.352681] rcu-torture: rcu_torture_stats task started
[    2.352681] rcu-torture: rcu_torture_stats task started
[    2.354749] rcu-torture: Creating torture_stutter task
[    2.354749] rcu-torture: Creating torture_stutter task
[    2.356739] rcu-torture: torture_shuffle task started
[    2.356739] rcu-torture: torture_shuffle task started
[    2.358697] rcu-torture: Creating rcu_torture_cbflood task
[    2.358697] rcu-torture: Creating rcu_torture_cbflood task
[    2.360883] rcu-torture: torture_stutter task started
[    2.360883] rcu-torture: torture_stutter task started
[    2.364337] futex hash table entries: 256 (order: 2, 20480 bytes)
[    2.364337] futex hash table entries: 256 (order: 2, 20480 bytes)
[    2.368754] rcu-torture: rcu_torture_cbflood task started
[    2.368754] rcu-torture: rcu_torture_cbflood task started
[    2.398126] HugeTLB registered 2 MB page size, pre-allocated 0 pages
[    2.398126] HugeTLB registered 2 MB page size, pre-allocated 0 pages
[    2.401046] zpool: loaded
[    2.401046] zpool: loaded
[    2.402081] zbud: loaded
[    2.402081] zbud: loaded
[    2.403821] ntfs: driver 2.1.31 [Flags: R/O].
[    2.403821] ntfs: driver 2.1.31 [Flags: R/O].
[    2.405673] fuse init (API version 7.23)
[    2.405673] fuse init (API version 7.23)
[    2.407466] JFS: nTxBlock =3D 2238, nTxLock =3D 17911
[    2.407466] JFS: nTxBlock =3D 2238, nTxLock =3D 17911
[    2.411475] SGI XFS with ACLs, security attributes, no debug enabled
[    2.411475] SGI XFS with ACLs, security attributes, no debug enabled
[    2.419797] Block layer SCSI generic (bsg) driver version 0.4 loaded (ma=
jor 250)
[    2.419797] Block layer SCSI generic (bsg) driver version 0.4 loaded (ma=
jor 250)
[    2.422972] io scheduler noop registered (default)
[    2.422972] io scheduler noop registered (default)
[    2.424815] io scheduler cfq registered
[    2.424815] io scheduler cfq registered
[    2.426307] start plist test
[    2.426307] start plist test
[    2.436336] end plist test
[    2.436336] end plist test
[    2.438212] test_string_helpers: Running tests...
[    2.438212] test_string_helpers: Running tests...
[    2.444944] crc32: CRC_LE_BITS =3D 1, CRC_BE BITS =3D 1
[    2.444944] crc32: CRC_LE_BITS =3D 1, CRC_BE BITS =3D 1
[    2.446042] crc32: self tests passed, processed 225944 bytes in 2328929 =
nsec
[    2.446042] crc32: self tests passed, processed 225944 bytes in 2328929 =
nsec
[    2.450805] crc32c: CRC_LE_BITS =3D 1
[    2.450805] crc32c: CRC_LE_BITS =3D 1
[    2.452364] crc32c: self tests passed, processed 225944 bytes in 1444986=
 nsec
[    2.452364] crc32c: self tests passed, processed 225944 bytes in 1444986=
 nsec
[    2.585887] crc32_combine: 8373 self tests passed
[    2.585887] crc32_combine: 8373 self tests passed
[    2.720412] crc32c_combine: 8373 self tests passed
[    2.720412] crc32c_combine: 8373 self tests passed
[    2.722783] glob: 64 self-tests passed, 0 failed
[    2.722783] glob: 64 self-tests passed, 0 failed
[    2.725273] no IO addresses supplied
[    2.725273] no IO addresses supplied
[    2.726827] hgafb: HGA card not detected.
[    2.726827] hgafb: HGA card not detected.
[    2.728090] hgafb: probe of hgafb.0 failed with error -22
[    2.728090] hgafb: probe of hgafb.0 failed with error -22
[    2.730785] usbcore: registered new interface driver udlfb
[    2.730785] usbcore: registered new interface driver udlfb
[    2.733377] usbcore: registered new interface driver smscufx
[    2.733377] usbcore: registered new interface driver smscufx
[    2.735349] ipmi message handler version 39.2
[    2.735349] ipmi message handler version 39.2
[    2.736789] ipmi device interface
[    2.736789] ipmi device interface
[    2.738506] IPMI System Interface driver.
[    2.738506] IPMI System Interface driver.
[    2.740055] ipmi_si: Unable to find any System Interface(s)
[    2.740055] ipmi_si: Unable to find any System Interface(s)
[    2.742319] Copyright (C) 2004 MontaVista Software - IPMI Powerdown via =
sys_reboot.
[    2.742319] Copyright (C) 2004 MontaVista Software - IPMI Powerdown via =
sys_reboot.
[    2.745683] IPMI poweroff: Unable to register powercycle sysctl
[    2.745683] IPMI poweroff: Unable to register powercycle sysctl
[    2.748340] input: Power Button as /devices/LNXSYSTM:00/LNXPWRBN:00/inpu=
t/input0
[    2.748340] input: Power Button as /devices/LNXSYSTM:00/LNXPWRBN:00/inpu=
t/input0
[    2.749904] ACPI: Power Button [PWRF]
[    2.749904] ACPI: Power Button [PWRF]
[    2.795676] Serial: 8250/16550 driver, 4 ports, IRQ sharing disabled
[    2.795676] Serial: 8250/16550 driver, 4 ports, IRQ sharing disabled
[    2.822756] serial 00:05: ttyS0 at I/O 0x3f8 (irq =3D 4, base_baud =3D 1=
15200) is a 16550A
[    2.822756] serial 00:05: ttyS0 at I/O 0x3f8 (irq =3D 4, base_baud =3D 1=
15200) is a 16550A
[    2.827887] lp: driver loaded but no devices found
[    2.827887] lp: driver loaded but no devices found
[    2.829125] Non-volatile memory driver v1.3
[    2.829125] Non-volatile memory driver v1.3
[    2.830465] telclk_interrupt =3D 0xf non-mcpbl0010 hw.
[    2.830465] telclk_interrupt =3D 0xf non-mcpbl0010 hw.
[    2.833020] Hangcheck: starting hangcheck timer 0.9.1 (tick is 180 secon=
ds, margin is 60 seconds).
[    2.833020] Hangcheck: starting hangcheck timer 0.9.1 (tick is 180 secon=
ds, margin is 60 seconds).
[    2.835890] [drm] Initialized drm 1.1.0 20060810
[    2.835890] [drm] Initialized drm 1.1.0 20060810
[    2.837022] usbcore: registered new interface driver udl
[    2.837022] usbcore: registered new interface driver udl
[    2.838807] parport_pc 00:04: reported by Plug and Play ACPI
[    2.838807] parport_pc 00:04: reported by Plug and Play ACPI
[    2.840778] parport0: PC-style at 0x378
[    2.840778] parport0: PC-style at 0x378, irq 7, irq 7 [ [PCSPPPCSPP,TRIS=
TATE,TRISTATE]
]
[    2.920234] lp0: using parport0 (interrupt-driven).
[    2.920234] lp0: using parport0 (interrupt-driven).
[    2.922273] dummy-irq: no IRQ given.  Use irq=3DN
[    2.922273] dummy-irq: no IRQ given.  Use irq=3DN
[    2.923605] Silicon Labs C2 port support v. 0.51.0 - (C) 2007 Rodolfo Gi=
ometti
[    2.923605] Silicon Labs C2 port support v. 0.51.0 - (C) 2007 Rodolfo Gi=
ometti
[    2.925706] c2port c2port0: C2 port uc added
[    2.925706] c2port c2port0: C2 port uc added
[    2.926697] c2port c2port0: uc flash has 30 blocks x 512 bytes (15360 by=
tes total)
[    2.926697] c2port c2port0: uc flash has 30 blocks x 512 bytes (15360 by=
tes total)
[    2.928618] usbcore: registered new interface driver rtsx_usb
[    2.928618] usbcore: registered new interface driver rtsx_usb
[    2.930283] usbcore: registered new interface driver viperboard
[    2.930283] usbcore: registered new interface driver viperboard
[    2.931611] Uniform Multi-Platform E-IDE driver
[    2.931611] Uniform Multi-Platform E-IDE driver
[    2.933733] ppa: Version 2.07 (for Linux 2.4.x)
[    2.933733] ppa: Version 2.07 (for Linux 2.4.x)
[    2.936994] imm: Version 2.05 (for Linux 2.4.0)
[    2.936994] imm: Version 2.05 (for Linux 2.4.0)
[    2.938629] st: Version 20101219, fixed bufsize 32768, s/g segs 256
[    2.938629] st: Version 20101219, fixed bufsize 32768, s/g segs 256
[    2.940073] osst :I: Tape driver with OnStream support version 0.99.4
[    2.940073] osst :I: $Id: osst.c,v 1.73 2005/01/01 21:13:34 wriede Exp $
[    2.940073] osst :I: Tape driver with OnStream support version 0.99.4
[    2.940073] osst :I: $Id: osst.c,v 1.73 2005/01/01 21:13:34 wriede Exp $
[    2.943346] osd: LOADED open-osd 0.2.1
[    2.943346] osd: LOADED open-osd 0.2.1
[    2.959112] scsi_debug: host protection
[    2.959112] scsi_debug: host protection
[    2.960628] scsi host0: scsi_debug, version 1.84 [20140706], dev_size_mb=
=3D8, opts=3D0x0
[    2.960628] scsi host0: scsi_debug, version 1.84 [20140706], dev_size_mb=
=3D8, opts=3D0x0
[    2.964704] scsi 0:0:0:0: Direct-Access     Linux    scsi_debug       01=
84 PQ: 0 ANSI: 6
[    2.964704] scsi 0:0:0:0: Direct-Access     Linux    scsi_debug       01=
84 PQ: 0 ANSI: 6
[    2.969731] Error: Driver 'pata_platform' is already registered, abortin=
g...
[    2.969731] Error: Driver 'pata_platform' is already registered, abortin=
g...
[    2.973757] Rounding down aligned max_sectors from 4294967295 to 4294967=
288
[    2.973757] Rounding down aligned max_sectors from 4294967295 to 4294967=
288
[    2.977567] parport0: cannot grant exclusive access for device spi-lm70l=
lp
[    2.977567] parport0: cannot grant exclusive access for device spi-lm70l=
lp
[    2.980509] spi-lm70llp: spi_lm70llp probe fail, status -12
[    2.980509] spi-lm70llp: spi_lm70llp probe fail, status -12
[    2.983107] HSI/SSI char device loaded
[    2.983107] HSI/SSI char device loaded
[    2.984617] parport0: cannot grant exclusive access for device ks0108
[    2.984617] parport0: cannot grant exclusive access for device ks0108
[    2.987253] ks0108: ERROR: parport didn't register new device
[    2.987253] ks0108: ERROR: parport didn't register new device
[    2.989651] cfag12864b: ERROR: ks0108 is not initialized
[    2.989651] cfag12864b: ERROR: ks0108 is not initialized
[    2.991918] cfag12864bfb: ERROR: cfag12864b is not initialized
[    2.991918] cfag12864bfb: ERROR: cfag12864b is not initialized
[    2.995671] usbcore: registered new interface driver cdc_acm
[    2.995671] usbcore: registered new interface driver cdc_acm
[    2.998061] cdc_acm: USB Abstract Control Model driver for USB modems an=
d ISDN adapters
[    2.998061] cdc_acm: USB Abstract Control Model driver for USB modems an=
d ISDN adapters
[    3.001521] usbcore: registered new interface driver usblp
[    3.001521] usbcore: registered new interface driver usblp
[    3.003775] usbcore: registered new interface driver uas
[    3.003775] usbcore: registered new interface driver uas
[    3.005871] usbcore: registered new interface driver usb-storage
[    3.005871] usbcore: registered new interface driver usb-storage
[    3.008460] usbcore: registered new interface driver ums-alauda
[    3.008460] usbcore: registered new interface driver ums-alauda
[    3.011038] usbcore: registered new interface driver ums-cypress
[    3.011038] usbcore: registered new interface driver ums-cypress
[    3.013573] usbcore: registered new interface driver ums-datafab
[    3.013573] usbcore: registered new interface driver ums-datafab
[    3.016031] usbcore: registered new interface driver ums_eneub6250
[    3.016031] usbcore: registered new interface driver ums_eneub6250
[    3.018622] usbcore: registered new interface driver ums-freecom
[    3.018622] usbcore: registered new interface driver ums-freecom
[    3.021178] usbcore: registered new interface driver ums-jumpshot
[    3.021178] usbcore: registered new interface driver ums-jumpshot
[    3.023665] usbcore: registered new interface driver ums-karma
[    3.023665] usbcore: registered new interface driver ums-karma
[    3.025964] usbcore: registered new interface driver ums-realtek
[    3.025964] usbcore: registered new interface driver ums-realtek
[    3.028526] usbcore: registered new interface driver ums-sddr55
[    3.028526] usbcore: registered new interface driver ums-sddr55
[    3.031067] usbcore: registered new interface driver mdc800
[    3.031067] usbcore: registered new interface driver mdc800
[    3.033296] mdc800: v0.7.5 (30/10/2000):USB Driver for Mustek MDC800 Dig=
ital Camera
[    3.033296] mdc800: v0.7.5 (30/10/2000):USB Driver for Mustek MDC800 Dig=
ital Camera
[    3.035930] usbcore: registered new interface driver adutux
[    3.035930] usbcore: registered new interface driver adutux
[    3.038428] usbcore: registered new interface driver appledisplay
[    3.038428] usbcore: registered new interface driver appledisplay
[    3.041016] usbcore: registered new interface driver cypress_cy7c63
[    3.041016] usbcore: registered new interface driver cypress_cy7c63
[    3.043587] usbcore: registered new interface driver cytherm
[    3.043587] usbcore: registered new interface driver cytherm
[    3.045859] usbcore: registered new interface driver emi26 - firmware lo=
ader
[    3.045859] usbcore: registered new interface driver emi26 - firmware lo=
ader
[    3.048762] ftdi_elan: driver ftdi-elan
[    3.048762] ftdi_elan: driver ftdi-elan
[    3.050388] sd 0:0:0:0: [sda] 16384 512-byte logical blocks: (8.38 MB/8.=
00 MiB)
[    3.050388] sd 0:0:0:0: [sda] 16384 512-byte logical blocks: (8.38 MB/8.=
00 MiB)
[    3.053525] usbcore: registered new interface driver ftdi-elan
[    3.053525] usbcore: registered new interface driver ftdi-elan
[    3.055808] usbcore: registered new interface driver idmouse
[    3.055808] usbcore: registered new interface driver idmouse
[    3.058207] usbcore: registered new interface driver usblcd
[    3.058207] usbcore: registered new interface driver usblcd
[    3.060608] usbcore: registered new interface driver ldusb
[    3.060608] usbcore: registered new interface driver ldusb
[    3.062921] usbcore: registered new interface driver usbled
[    3.062921] usbcore: registered new interface driver usbled
[    3.065039] usbcore: registered new interface driver legousbtower
[    3.065039] usbcore: registered new interface driver legousbtower
[    3.067619] usbcore: registered new interface driver usbtest
[    3.067619] usbcore: registered new interface driver usbtest
[    3.070052] usbcore: registered new interface driver trancevibrator
[    3.070052] usbcore: registered new interface driver trancevibrator
[    3.072311] usbcore: registered new interface driver usbsevseg
[    3.072311] usbcore: registered new interface driver usbsevseg
[    3.074390] usbcore: registered new interface driver sisusb
[    3.074390] usbcore: registered new interface driver sisusb
[    3.076192] usbcore: registered new interface driver lvs
[    3.076192] usbcore: registered new interface driver lvs
[    3.079706] dummy_hcd dummy_hcd.0: USB Host+Gadget Emulator, driver 02 M=
ay 2005
[    3.079706] dummy_hcd dummy_hcd.0: USB Host+Gadget Emulator, driver 02 M=
ay 2005
[    3.082257] dummy_hcd dummy_hcd.0: Dummy host controller
[    3.082257] dummy_hcd dummy_hcd.0: Dummy host controller
[    3.084563] dummy_hcd dummy_hcd.0: new USB bus registered, assigned bus =
number 1
[    3.084563] dummy_hcd dummy_hcd.0: new USB bus registered, assigned bus =
number 1
[    3.087254] usb usb1: New USB device found, idVendor=3D1d6b, idProduct=
=3D0002
[    3.087254] usb usb1: New USB device found, idVendor=3D1d6b, idProduct=
=3D0002
[    3.089526] usb usb1: New USB device strings: Mfr=3D3, Product=3D2, Seri=
alNumber=3D1
[    3.089526] usb usb1: New USB device strings: Mfr=3D3, Product=3D2, Seri=
alNumber=3D1
[    3.092019] usb usb1: Product: Dummy host controller
[    3.092019] usb usb1: Product: Dummy host controller
[    3.093197] usb usb1: Manufacturer: Linux 3.18.0-rc2-gf6a2b54 dummy_hcd
[    3.093197] usb usb1: Manufacturer: Linux 3.18.0-rc2-gf6a2b54 dummy_hcd
[    3.094824] usb usb1: SerialNumber: dummy_hcd.0
[    3.094824] usb usb1: SerialNumber: dummy_hcd.0
[    3.096281] sd 0:0:0:0: [sda] Write Protect is off
[    3.096281] sd 0:0:0:0: [sda] Write Protect is off
[    3.097331] sd 0:0:0:0: [sda] Mode Sense: 73 00 10 08
[    3.097331] sd 0:0:0:0: [sda] Mode Sense: 73 00 10 08
[    3.098612] hub 1-0:1.0: USB hub found
[    3.098612] hub 1-0:1.0: USB hub found
[    3.099418] hub 1-0:1.0: 1 port detected
[    3.099418] hub 1-0:1.0: 1 port detected
[    3.101535] udc dummy_udc.0: registering UDC driver [g_mass_storage]
[    3.101535] udc dummy_udc.0: registering UDC driver [g_mass_storage]
[    3.103248] Number of LUNs=3D8
[    3.103248] Number of LUNs=3D8
[    3.103913] Mass Storage Function, version: 2009/09/11
[    3.103913] Mass Storage Function, version: 2009/09/11
[    3.105007] LUN: removable file: (no medium)
[    3.105007] LUN: removable file: (no medium)
[    3.106304] Number of LUNs=3D1
[    3.106304] Number of LUNs=3D1
[    3.107199] no file given for LUN0
[    3.107199] no file given for LUN0
[    3.108735] g_mass_storage dummy_udc.0: failed to start g_mass_storage: =
-22
[    3.108735] g_mass_storage dummy_udc.0: failed to start g_mass_storage: =
-22
[    3.111299] i8042: PNP: PS/2 Controller [PNP0303:KBD,PNP0f13:MOU] at 0x6=
0,0x64 irq 1,12
[    3.111299] i8042: PNP: PS/2 Controller [PNP0303:KBD,PNP0f13:MOU] at 0x6=
0,0x64 irq 1,12
[    3.115111] serio: i8042 KBD port at 0x60,0x64 irq 1
[    3.115111] serio: i8042 KBD port at 0x60,0x64 irq 1
[    3.117320] serio: i8042 AUX port at 0x60,0x64 irq 12
[    3.117320] serio: i8042 AUX port at 0x60,0x64 irq 12
[    3.119160] parport0: cannot grant exclusive access for device parkbd
[    3.119160] parport0: cannot grant exclusive access for device parkbd
[    3.122296] mousedev: PS/2 mouse device common for all mice
[    3.122296] mousedev: PS/2 mouse device common for all mice
[    3.124333] evbug: Connected device: input0 (Power Button at LNXPWRBN/bu=
tton/input0)
[    3.124333] evbug: Connected device: input0 (Power Button at LNXPWRBN/bu=
tton/input0)
[    3.127054] usbcore: registered new interface driver appletouch
[    3.127054] usbcore: registered new interface driver appletouch
[    3.129292] usbcore: registered new interface driver usb_acecad
[    3.129292] usbcore: registered new interface driver usb_acecad
[    3.131346] usbcore: registered new interface driver aiptek
[    3.131346] usbcore: registered new interface driver aiptek
[    3.133249] usbcore: registered new interface driver gtco
[    3.133249] usbcore: registered new interface driver gtco
[    3.135135] usbcore: registered new interface driver hanwang
[    3.135135] usbcore: registered new interface driver hanwang
[    3.137100] usbcore: registered new interface driver kbtab
[    3.137100] usbcore: registered new interface driver kbtab
[    3.139667] mk712: device not present
[    3.139667] mk712: device not present
[    3.141034] usbcore: registered new interface driver usbtouchscreen
[    3.141034] usbcore: registered new interface driver usbtouchscreen
[    3.143817] rtc_cmos 00:00: RTC can wake from S4
[    3.143817] rtc_cmos 00:00: RTC can wake from S4
[    3.145622] rtc (null): alarm rollover: day
[    3.145622] rtc (null): alarm rollover: day
[    3.147245] rtc rtc0: rtc_cmos: dev (254:0)
[    3.147245] rtc rtc0: rtc_cmos: dev (254:0)
[    3.148664] rtc_cmos 00:00: rtc core: registered rtc_cmos as rtc0
[    3.148664] rtc_cmos 00:00: rtc core: registered rtc_cmos as rtc0
[    3.150597] rtc_cmos 00:00: alarms up to one day, 114 bytes nvram, hpet =
irqs
[    3.150597] rtc_cmos 00:00: alarms up to one day, 114 bytes nvram, hpet =
irqs
[    3.153822] i2c /dev entries driver
[    3.153822] i2c /dev entries driver
[    3.155294] i2c-parport-light: adapter type unspecified
[    3.155294] i2c-parport-light: adapter type unspecified
[    3.157254] lirc_dev: IR Remote Control driver registered, major 242=20
[    3.157254] lirc_dev: IR Remote Control driver registered, major 242=20
[    3.158902] IR NEC protocol handler initialized
[    3.158902] IR NEC protocol handler initialized
[    3.159904] IR RC5(x/sz) protocol handler initialized
[    3.159904] IR RC5(x/sz) protocol handler initialized
[    3.161246] IR Sony protocol handler initialized
[    3.161246] IR Sony protocol handler initialized
[    3.162351] IR SANYO protocol handler initialized
[    3.162351] IR SANYO protocol handler initialized
[    3.163407] IR Sharp protocol handler initialized
[    3.163407] IR Sharp protocol handler initialized
[    3.164495] IR MCE Keyboard/mouse protocol handler initialized
[    3.164495] IR MCE Keyboard/mouse protocol handler initialized
[    3.165775] IR LIRC bridge handler initialized
[    3.165775] IR LIRC bridge handler initialized
[    3.166921] IR XMP protocol handler initialized
[    3.166921] IR XMP protocol handler initialized
[    3.168097] usbcore: registered new interface driver airspy
[    3.168097] usbcore: registered new interface driver airspy
[    3.169314] usbcore: registered new interface driver hackrf
[    3.169314] usbcore: registered new interface driver hackrf
[    3.170676] usbcore: registered new interface driver msi2500
[    3.170676] usbcore: registered new interface driver msi2500
[    3.172230] pps pps0: new PPS source ktimer
[    3.172230] pps pps0: new PPS source ktimer
[    3.173164] pps pps0: ktimer PPS source registered
[    3.173164] pps pps0: ktimer PPS source registered
[    3.174264] pps_ldisc: PPS line discipline registered
[    3.174264] pps_ldisc: PPS line discipline registered
[    3.175614] pps_parport: parallel port PPS client
[    3.175614] pps_parport: parallel port PPS client
[    3.176702] parport0: cannot grant exclusive access for device pps_parpo=
rt
[    3.176702] parport0: cannot grant exclusive access for device pps_parpo=
rt
[    3.179100] pps_parport: couldn't register with parport0
[    3.179100] pps_parport: couldn't register with parport0
[    3.180943] Driver for 1-wire Dallas network protocol.
[    3.180943] Driver for 1-wire Dallas network protocol.
[    3.183185] usbcore: registered new interface driver DS9490R
[    3.183185] usbcore: registered new interface driver DS9490R
[    3.185348] DS1WM w1 busmaster driver - (c) 2004 Szabolcs Gyurko
[    3.185348] DS1WM w1 busmaster driver - (c) 2004 Szabolcs Gyurko
[    3.188115] power_supply test_ac: uevent
[    3.188115] power_supply test_ac: uevent
[    3.189474] power_supply test_ac: POWER_SUPPLY_NAME=3Dtest_ac
[    3.189474] power_supply test_ac: POWER_SUPPLY_NAME=3Dtest_ac
[    3.191465] power_supply test_ac: prop ONLINE=3D1
[    3.191465] power_supply test_ac: prop ONLINE=3D1
[    3.193372] power_supply test_ac: power_supply_changed
[    3.193372] power_supply test_ac: power_supply_changed
[    3.195713] power_supply test_battery: uevent
[    3.195713] power_supply test_battery: uevent
[    3.197307] power_supply test_battery: POWER_SUPPLY_NAME=3Dtest_battery
[    3.197307] power_supply test_battery: POWER_SUPPLY_NAME=3Dtest_battery
[    3.199707] power_supply test_battery: prop STATUS=3DDischarging
[    3.199707] power_supply test_battery: prop STATUS=3DDischarging
[    3.201918] power_supply test_battery: prop CHARGE_TYPE=3DFast
[    3.201918] power_supply test_battery: prop CHARGE_TYPE=3DFast
[    3.204043] power_supply test_battery: prop HEALTH=3DGood
[    3.204043] power_supply test_battery: prop HEALTH=3DGood
[    3.205956] power_supply test_battery: prop PRESENT=3D1
[    3.205956] power_supply test_battery: prop PRESENT=3D1
[    3.207904] power_supply test_battery: prop TECHNOLOGY=3DLi-ion
[    3.207904] power_supply test_battery: prop TECHNOLOGY=3DLi-ion
[    3.209911] power_supply test_battery: prop CHARGE_FULL_DESIGN=3D100
[    3.209911] power_supply test_battery: prop CHARGE_FULL_DESIGN=3D100
[    3.212222] power_supply test_battery: prop CHARGE_FULL=3D100
[    3.212222] power_supply test_battery: prop CHARGE_FULL=3D100
[    3.214219] power_supply test_battery: prop CHARGE_NOW=3D50
[    3.214219] power_supply test_battery: prop CHARGE_NOW=3D50
[    3.216242] power_supply test_battery: prop CAPACITY=3D50
[    3.216242] power_supply test_battery: prop CAPACITY=3D50
[    3.218235] power_supply test_battery: prop CAPACITY_LEVEL=3DNormal
[    3.218235] power_supply test_battery: prop CAPACITY_LEVEL=3DNormal
[    3.220654] power_supply test_battery: prop TIME_TO_EMPTY_AVG=3D3600
[    3.220654] power_supply test_battery: prop TIME_TO_EMPTY_AVG=3D3600
[    3.223061] power_supply test_battery: prop TIME_TO_FULL_NOW=3D3600
[    3.223061] power_supply test_battery: prop TIME_TO_FULL_NOW=3D3600
[    3.225325] power_supply test_battery: prop MODEL_NAME=3DTest battery
[    3.225325] power_supply test_battery: prop MODEL_NAME=3DTest battery
[    3.228114] power_supply test_battery: prop MANUFACTURER=3DLinux
[    3.228114] power_supply test_battery: prop MANUFACTURER=3DLinux
[    3.230397] power_supply test_battery: prop SERIAL_NUMBER=3D3.18.0-rc2-g=
f6a2b54
[    3.230397] power_supply test_battery: prop SERIAL_NUMBER=3D3.18.0-rc2-g=
f6a2b54
[    3.233092] power_supply test_battery: prop TEMP=3D26
[    3.233092] power_supply test_battery: prop TEMP=3D26
[    3.235007] power_supply test_battery: prop VOLTAGE_NOW=3D3300
[    3.235007] power_supply test_battery: prop VOLTAGE_NOW=3D3300
[    3.236965] power_supply test_battery: power_supply_changed
[    3.236965] power_supply test_battery: power_supply_changed
[    3.238370] power_supply test_usb: uevent
[    3.238370] power_supply test_usb: uevent
[    3.239591] power_supply test_usb: POWER_SUPPLY_NAME=3Dtest_usb
[    3.239591] power_supply test_usb: POWER_SUPPLY_NAME=3Dtest_usb
[    3.240817] power_supply test_usb: prop ONLINE=3D1
[    3.240817] power_supply test_usb: prop ONLINE=3D1
[    3.241847] power_supply test_usb: power_supply_changed
[    3.241847] power_supply test_usb: power_supply_changed
[    3.244392] applesmc: supported laptop not found!
[    3.244392] applesmc: supported laptop not found!
[    3.245735] applesmc: driver init failed (ret=3D-19)!
[    3.245735] applesmc: driver init failed (ret=3D-19)!
[    3.248571] pc87360: PC8736x not detected, module not inserted
[    3.248571] pc87360: PC8736x not detected, module not inserted
[    3.250214] usbcore: registered new interface driver pcwd_usb
[    3.250214] usbcore: registered new interface driver pcwd_usb
[    3.251584] acquirewdt: WDT driver for Acquire single board computer ini=
tialising
[    3.251584] acquirewdt: WDT driver for Acquire single board computer ini=
tialising
[    3.253517] acquirewdt: I/O address 0x0043 already in use
[    3.253517] acquirewdt: I/O address 0x0043 already in use
[    3.254723] acquirewdt: probe of acquirewdt failed with error -5
[    3.254723] acquirewdt: probe of acquirewdt failed with error -5
[    3.256053] wafer5823wdt: WDT driver for Wafer 5823 single board compute=
r initialising
[    3.256053] wafer5823wdt: WDT driver for Wafer 5823 single board compute=
r initialising
[    3.258022] wafer5823wdt: initialized. timeout=3D60 sec (nowayout=3D0)
[    3.258022] wafer5823wdt: initialized. timeout=3D60 sec (nowayout=3D0)
[    3.259412] it87_wdt: no device
[    3.259412] it87_wdt: no device
[    3.260268] sc1200wdt: build 20020303
[    3.260268] sc1200wdt: build 20020303
[    3.261029] sc1200wdt: io parameter must be specified
[    3.261029] sc1200wdt: io parameter must be specified
[    3.262719] cpu5wdt: misc_register failed
[    3.262719] cpu5wdt: misc_register failed
[    3.264347] smsc37b787_wdt: SMsC 37B787 watchdog component driver 1.1 in=
itialising...
[    3.264347] smsc37b787_wdt: SMsC 37B787 watchdog component driver 1.1 in=
itialising...
[    3.268406] smsc37b787_wdt: Unable to register miscdev on minor 130
[    3.268406] smsc37b787_wdt: Unable to register miscdev on minor 130
[    3.270704] w83877f_wdt: I/O address 0x0443 already in use
[    3.270704] w83877f_wdt: I/O address 0x0443 already in use
[    3.272902] machzwd: MachZ ZF-Logic Watchdog driver initializing
[    3.272902] machzwd: MachZ ZF-Logic Watchdog driver initializing
[    3.275172] machzwd: no ZF-Logic found
[    3.275172] machzwd: no ZF-Logic found
[    3.276600] sbc_epx_c3: cannot register miscdev on minor=3D130 (err=3D-1=
6)
[    3.276600] sbc_epx_c3: cannot register miscdev on minor=3D130 (err=3D-1=
6)
[    3.279210] watchdog: Software Watchdog: cannot register miscdev on mino=
r=3D130 (err=3D-16).
[    3.279210] watchdog: Software Watchdog: cannot register miscdev on mino=
r=3D130 (err=3D-16).
[    3.282319] watchdog: Software Watchdog: a legacy watchdog module is pro=
bably present.
[    3.282319] watchdog: Software Watchdog: a legacy watchdog module is pro=
bably present.
[    3.285352] softdog: Software Watchdog Timer: 0.08 initialized. soft_nob=
oot=3D0 soft_margin=3D60 sec soft_panic=3D0 (nowayout=3D0)
[    3.285352] softdog: Software Watchdog Timer: 0.08 initialized. soft_nob=
oot=3D0 soft_margin=3D60 sec soft_panic=3D0 (nowayout=3D0)
[    3.290549] input: AT Translated Set 2 keyboard as /devices/platform/i80=
42/serio0/input/input1
[    3.290549] input: AT Translated Set 2 keyboard as /devices/platform/i80=
42/serio0/input/input1
[    3.293971] evbug: Connected device: input1 (AT Translated Set 2 keyboar=
d at isa0060/serio0/input0)
[    3.293971] evbug: Connected device: input1 (AT Translated Set 2 keyboar=
d at isa0060/serio0/input0)
[    3.298024] sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled,=
 supports DPO and FUA
[    3.298024] sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled,=
 supports DPO and FUA
[    3.301324] power_supply test_ac: power_supply_changed_work
[    3.301324] power_supply test_ac: power_supply_changed_work
[    3.303217] power_supply test_ac: uevent
[    3.303217] power_supply test_ac: uevent
[    3.304655] power_supply test_ac: POWER_SUPPLY_NAME=3Dtest_ac
[    3.304655] power_supply test_ac: POWER_SUPPLY_NAME=3Dtest_ac
[    3.306811] power_supply test_ac: prop ONLINE=3D1
[    3.306811] power_supply test_ac: prop ONLINE=3D1
[    3.308439] power_supply test_battery: power_supply_changed_work
[    3.308439] power_supply test_battery: power_supply_changed_work
[    3.310928] power_supply test_battery: uevent
[    3.310928] power_supply test_battery: uevent
[    3.312717] power_supply test_battery: POWER_SUPPLY_NAME=3Dtest_battery
[    3.312717] power_supply test_battery: POWER_SUPPLY_NAME=3Dtest_battery
[    3.315285] power_supply test_battery: prop STATUS=3DDischarging
[    3.315285] power_supply test_battery: prop STATUS=3DDischarging
[    3.317490] power_supply test_battery: prop CHARGE_TYPE=3DFast
[    3.317490] power_supply test_battery: prop CHARGE_TYPE=3DFast
[    3.319620] power_supply test_battery: prop HEALTH=3DGood
[    3.319620] power_supply test_battery: prop HEALTH=3DGood
[    3.321801] power_supply test_battery: prop PRESENT=3D1
[    3.321801] power_supply test_battery: prop PRESENT=3D1
[    3.323518] power_supply test_battery: prop TECHNOLOGY=3DLi-ion
[    3.323518] power_supply test_battery: prop TECHNOLOGY=3DLi-ion
[    3.325788] power_supply test_battery: prop CHARGE_FULL_DESIGN=3D100
[    3.325788] power_supply test_battery: prop CHARGE_FULL_DESIGN=3D100
[    3.328136] power_supply test_battery: prop CHARGE_FULL=3D100
[    3.328136] power_supply test_battery: prop CHARGE_FULL=3D100
[    3.330136] power_supply test_battery: prop CHARGE_NOW=3D50
[    3.330136] power_supply test_battery: prop CHARGE_NOW=3D50
[    3.332341] power_supply test_battery: prop CAPACITY=3D50
[    3.332341] power_supply test_battery: prop CAPACITY=3D50
[    3.334173] power_supply test_battery: prop CAPACITY_LEVEL=3DNormal
[    3.334173] power_supply test_battery: prop CAPACITY_LEVEL=3DNormal
[    3.336662] power_supply test_battery: prop TIME_TO_EMPTY_AVG=3D3600
[    3.336662] power_supply test_battery: prop TIME_TO_EMPTY_AVG=3D3600
[    3.338879] power_supply test_battery: prop TIME_TO_FULL_NOW=3D3600
[    3.338879] power_supply test_battery: prop TIME_TO_FULL_NOW=3D3600
[    3.341138] power_supply test_battery: prop MODEL_NAME=3DTest battery
[    3.341138] power_supply test_battery: prop MODEL_NAME=3DTest battery
[    3.343540] power_supply test_battery: prop MANUFACTURER=3DLinux
[    3.343540] power_supply test_battery: prop MANUFACTURER=3DLinux
[    3.345818] power_supply test_battery: prop SERIAL_NUMBER=3D3.18.0-rc2-g=
f6a2b54
[    3.345818] power_supply test_battery: prop SERIAL_NUMBER=3D3.18.0-rc2-g=
f6a2b54
[    3.348478] power_supply test_battery: prop TEMP=3D26
[    3.348478] power_supply test_battery: prop TEMP=3D26
[    3.350238] power_supply test_battery: prop VOLTAGE_NOW=3D3300
[    3.350238] power_supply test_battery: prop VOLTAGE_NOW=3D3300
[    3.352647] power_supply test_usb: power_supply_changed_work
[    3.352647] power_supply test_usb: power_supply_changed_work
[    3.354820] power_supply test_usb: uevent
[    3.354820] power_supply test_usb: uevent
[    3.356327] power_supply test_usb: POWER_SUPPLY_NAME=3Dtest_usb
[    3.356327] power_supply test_usb: POWER_SUPPLY_NAME=3Dtest_usb
[    3.358467] power_supply test_usb: prop ONLINE=3D1
[    3.358467] power_supply test_usb: prop ONLINE=3D1
[    3.360449] tsc: Refined TSC clocksource calibration: 2693.408 MHz
[    3.360449] tsc: Refined TSC clocksource calibration: 2693.408 MHz
[    3.364053] usb usb1: dummy_bus_suspend
[    3.364053] usb usb1: dummy_bus_suspend
[    3.367543] dcdbas dcdbas: Dell Systems Management Base Driver (version =
5.6.0-3.2)
[    3.367543] dcdbas dcdbas: Dell Systems Management Base Driver (version =
5.6.0-3.2)
[    3.370432] hidraw: raw HID events driver (C) Jiri Kosina
[    3.370432] hidraw: raw HID events driver (C) Jiri Kosina
[    3.459936] usbcore: registered new interface driver usbhid
[    3.459936] usbcore: registered new interface driver usbhid
[    3.462205] usbhid: USB HID core driver
[    3.462205] usbhid: USB HID core driver
[    3.463885] usbcore: registered new interface driver line6usb
[    3.463885] usbcore: registered new interface driver line6usb
[    3.529082] logger: created 256K log 'log_main'
[    3.529082] logger: created 256K log 'log_main'
[    3.604314] logger: created 256K log 'log_events'
[    3.604314] logger: created 256K log 'log_events'
[    3.605984] logger: created 256K log 'log_radio'
[    3.605984] logger: created 256K log 'log_radio'
[    3.607608] logger: created 256K log 'log_system'
[    3.607608] logger: created 256K log 'log_system'
[    3.629455] intel_rapl: driver does not support CPU family 15 model 6
[    3.629455] intel_rapl: driver does not support CPU family 15 model 6
[    3.634570]=20
[    3.634570] printing PIC contents
[    3.634570]=20
[    3.634570] printing PIC contents
[    3.635668] ... PIC  IMR: ffff
[    3.635668] ... PIC  IMR: ffff
[    3.636535] ... PIC  IRR: 1113
[    3.636535] ... PIC  IRR: 1113
[    3.637509] ... PIC  ISR: 0000
[    3.637509] ... PIC  ISR: 0000
[    3.638425] ... PIC ELCR: 0c00
[    3.638425] ... PIC ELCR: 0c00
[    3.639078] printing local APIC contents on CPU#0/0:
[    3.639078] printing local APIC contents on CPU#0/0:
[    3.640159] ... APIC ID:      00000000 (0)
[    3.640159] ... APIC ID:      00000000 (0)
[    3.641106] ... APIC VERSION: 00050014
[    3.641106] ... APIC VERSION: 00050014
[    3.641106] ... APIC TASKPRI: 00000000 (00)
[    3.641106] ... APIC TASKPRI: 00000000 (00)
[    3.641106] ... APIC PROCPRI: 00000000
[    3.641106] ... APIC PROCPRI: 00000000
[    3.641106] ... APIC LDR: 01000000
[    3.641106] ... APIC LDR: 01000000
[    3.641106] ... APIC DFR: ffffffff
[    3.641106] ... APIC DFR: ffffffff
[    3.641106] ... APIC SPIV: 000001ff
[    3.641106] ... APIC SPIV: 000001ff
[    3.641106] ... APIC ISR field:
[    3.641106] ... APIC ISR field:
[    3.641106] 00000000
[    3.641106] 000000000000000000000000000000000000000000000000000000000000=
000000000000000000000000000000000000000000000000000000000000

[    3.641106] ... APIC TMR field:
[    3.641106] ... APIC TMR field:
[    3.641106] 00000000
[    3.641106] 000000000200000002000000000000000000000000000000000000000000=
000000000000000000000000000000000000000000000000000000000000

[    3.641106] ... APIC IRR field:
[    3.641106] ... APIC IRR field:
[    3.641106] 00000000
[    3.641106] 000000000000000000000000000000000000000000000000000000000000=
000000000000000000000000000000000000000000000000800000008000

[    3.641106] ... APIC ESR: 00000000
[    3.641106] ... APIC ESR: 00000000
[    3.641106] ... APIC ICR: 00000831
[    3.641106] ... APIC ICR: 00000831
[    3.641106] ... APIC ICR2: 01000000
[    3.641106] ... APIC ICR2: 01000000
[    3.641106] ... APIC LVTT: 000000ef
[    3.641106] ... APIC LVTT: 000000ef
[    3.641106] ... APIC LVTPC: 00010000
[    3.641106] ... APIC LVTPC: 00010000
[    3.641106] ... APIC LVT0: 00010700
[    3.641106] ... APIC LVT0: 00010700
[    3.641106] ... APIC LVT1: 00000400
[    3.641106] ... APIC LVT1: 00000400
[    3.641106] ... APIC LVTERR: 000000fe
[    3.641106] ... APIC LVTERR: 000000fe
[    3.641106] ... APIC TMICT: 00087a94
[    3.641106] ... APIC TMICT: 00087a94
[    3.641106] ... APIC TMCCT: 00000000
[    3.641106] ... APIC TMCCT: 00000000
[    3.641106] ... APIC TDCR: 00000003
[    3.641106] ... APIC TDCR: 00000003
[    3.641106]=20
[    3.641106]=20
[    3.665006] number of MP IRQ sources: 15.
[    3.665006] number of MP IRQ sources: 15.
[    3.665858] number of IO-APIC #0 registers: 24.
[    3.665858] number of IO-APIC #0 registers: 24.
[    3.666842] testing the IO APIC.......................
[    3.666842] testing the IO APIC.......................
[    3.667937] IO APIC #0......
[    3.667937] IO APIC #0......
[    3.668557] .... register #00: 00000000
[    3.668557] .... register #00: 00000000
[    3.669374] .......    : physical APIC id: 00
[    3.669374] .......    : physical APIC id: 00
[    3.670306] .......    : Delivery Type: 0
[    3.670306] .......    : Delivery Type: 0
[    3.671156] .......    : LTS          : 0
[    3.671156] .......    : LTS          : 0
[    3.671988] .... register #01: 00170011
[    3.671988] .... register #01: 00170011
[    3.672798] .......     : max redirection entries: 17
[    3.672798] .......     : max redirection entries: 17
[    3.673898] .......     : PRQ implemented: 0
[    3.673898] .......     : PRQ implemented: 0
[    3.674797] .......     : IO APIC version: 11
[    3.674797] .......     : IO APIC version: 11
[    3.675710] .... register #02: 00000000
[    3.675710] .... register #02: 00000000
[    3.676541] .......     : arbitration: 00
[    3.676541] .......     : arbitration: 00
[    3.677390] .... IRQ redirection table:
[    3.677390] .... IRQ redirection table:
[    3.678226] 1    0    0   0   0    0    0    00
[    3.678226] 1    0    0   0   0    0    0    00
[    3.679199] 0    0    0   0   0    1    1    31
[    3.679199] 0    0    0   0   0    1    1    31
[    3.680184] 0    0    0   0   0    1    1    30
[    3.680184] 0    0    0   0   0    1    1    30
[    3.681196] 0    0    0   0   0    1    1    33
[    3.681196] 0    0    0   0   0    1    1    33
[    3.682667] 1    0    0   0   0    1    1    34
[    3.682667] 1    0    0   0   0    1    1    34
[    3.684230] 1    1    0   0   0    1    1    35
[    3.684230] 1    1    0   0   0    1    1    35
[    3.685734] 0    0    0   0   0    1    1    36
[    3.685734] 0    0    0   0   0    1    1    36
[    3.687204] 0    0    0   0   0    1    1    37
[    3.687204] 0    0    0   0   0    1    1    37
[    3.688745] 0    0    0   0   0    1    1    38
[    3.688745] 0    0    0   0   0    1    1    38
[    3.690281] 0    1    0   0   0    1    1    39
[    3.690281] 0    1    0   0   0    1    1    39
[    3.691785] 1    1    0   0   0    1    1    3A
[    3.691785] 1    1    0   0   0    1    1    3A
[    3.693293] 1    1    0   0   0    1    1    3B
[    3.693293] 1    1    0   0   0    1    1    3B
[    3.694810] 0    0    0   0   0    1    1    3C
[    3.694810] 0    0    0   0   0    1    1    3C
[    3.696362] 0    0    0   0   0    1    1    3D
[    3.696362] 0    0    0   0   0    1    1    3D
[    3.697803] 0    0    0   0   0    1    1    3E
[    3.697803] 0    0    0   0   0    1    1    3E
[    3.699411] 0    0    0   0   0    1    1    3F
[    3.699411] 0    0    0   0   0    1    1    3F
[    3.700957] 1    0    0   0   0    0    0    00
[    3.700957] 1    0    0   0   0    0    0    00
[    3.702406] 1    0    0   0   0    0    0    00
[    3.702406] 1    0    0   0   0    0    0    00
[    3.703917] 1    0    0   0   0    0    0    00
[    3.703917] 1    0    0   0   0    0    0    00
[    3.705478] 1    0    0   0   0    0    0    00
[    3.705478] 1    0    0   0   0    0    0    00
[    3.706943] 1    0    0   0   0    0    0    00
[    3.706943] 1    0    0   0   0    0    0    00
[    3.708468] 1    0    0   0   0    0    0    00
[    3.708468] 1    0    0   0   0    0    0    00
[    3.710027] 1    0    0   0   0    0    0    00
[    3.710027] 1    0    0   0   0    0    0    00
[    3.711581] 1    0    0   0   0    0    0    00
[    3.711581] 1    0    0   0   0    0    0    00
[    3.713091] IRQ to pin mappings:
[    3.713091] IRQ to pin mappings:
[    3.714228] IRQ0=20
[    3.714228] IRQ0 -> 0:2-> 0:2

[    3.715064] IRQ1=20
[    3.715064] IRQ1 -> 0:1-> 0:1

[    3.715930] IRQ3=20
[    3.715930] IRQ3 -> 0:3-> 0:3

[    3.716824] IRQ4=20
[    3.716824] IRQ4 -> 0:4-> 0:4

[    3.717654] IRQ5=20
[    3.717654] IRQ5 -> 0:5-> 0:5

[    3.718592] IRQ6=20
[    3.718592] IRQ6 -> 0:6-> 0:6

[    3.719424] IRQ7=20
[    3.719424] IRQ7 -> 0:7-> 0:7

[    3.720335] IRQ8=20
[    3.720335] IRQ8 -> 0:8-> 0:8

[    3.721189] IRQ9=20
[    3.721189] IRQ9 -> 0:9-> 0:9

[    3.722015] IRQ10=20
[    3.722015] IRQ10 -> 0:10-> 0:10

[    3.723008] IRQ11=20
[    3.723008] IRQ11 -> 0:11-> 0:11

[    3.723898] IRQ12=20
[    3.723898] IRQ12 -> 0:12-> 0:12

[    3.724861] IRQ13=20
[    3.724861] IRQ13 -> 0:13-> 0:13

[    3.725758] IRQ14=20
[    3.725758] IRQ14 -> 0:14-> 0:14

[    3.726713] IRQ15=20
[    3.726713] IRQ15 -> 0:15-> 0:15

[    3.727645] .................................... done.
[    3.727645] .................................... done.
[    3.730503] bootconsole [earlyser0] disabled
[    3.730503] bootconsole [earlyser0] disabled
[    3.733164] Btrfs loaded, debug=3Don
[    3.735607] rtc_cmos 00:00: setting system clock to 2014-10-27 21:41:52 =
UTC (1414446112)
[    3.736950] PM: Hibernation image not present or could not be loaded
--Pd0ReVV5GZGQvF3a
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

_______________________________________________
LKP mailing list
LKP@linux.intel.com

--Pd0ReVV5GZGQvF3a--
