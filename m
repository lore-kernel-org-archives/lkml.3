Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752947AbaCGCM3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Mar 2014 21:12:29 -0500
Received: from mga01.intel.com ([192.55.52.88]:22543 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751457AbaCGCKJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Mar 2014 21:10:09 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,605,1389772800"; 
   d="log'?scan'208";a="487633396"
Date: Fri, 7 Mar 2014 09:58:33 +0800
From: Fengguang Wu <fengguang.wu@intel.com>
To: Andreas Herrmann <andreas.herrmann3@amd.com>
Cc: "H. Peter Anvin" <hpa@linux.intel.com>, Ingo Molnar <mingo@elte.hu>,
        Borislav Petkov <borislav.petkov@amd.com>,
        Yinghai Lu <yhlu.kernel@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>
Subject: [qemu64,+smep,+smap] WARNING: CPU: 1 PID: 0 at
 arch/x86/kernel/cpu/amd.c:220 init_amd()
Message-ID: <20140307015833.GA10048@localhost>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="ikeVEW9yuYc//A+q"
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--ikeVEW9yuYc//A+q
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi all,

I find the below WARNING shows up only in

        qemu-system-x86_64 -cpu qemu64,+smep,+smap

[    0.018000] Initializing CPU#1
[    0.018000] masked ExtINT on CPU#1
[    0.018000] ------------[ cut here ]------------
[    0.018000] WARNING: CPU: 1 PID: 0 at arch/x86/kernel/cpu/amd.c:220 init_amd+0x752/0x780()
[    0.018000] WARNING: This combination of AMD processors is not suitable for SMP.          
[    0.018000] CPU: 1 PID: 0 Comm: swapper/1 Not tainted 3.14.0-rc3-next-20140221-04488-gfaa2e6f #1
[    0.018000]  00000000 00000000 80047ec0 8a1c529a 80047f00 80047ef0 89c44b6f 8a38b9f4            
[    0.018000]  80047f1c 00000000 8a38ba3c 000000dc 89c124a2 89c124a2 9396cfc0 9396d010
[    0.018000]  9396d03c 80047f08 89c44bee 00000009 80047f00 8a38b9f4 80047f1c 80047f44
[    0.018000] Call Trace:
[    0.018000]  [<8a1c529a>] dump_stack+0x48/0x60
[    0.018000]  [<89c44b6f>] warn_slowpath_common+0x6f/0x90
[    0.018000]  [<89c124a2>] ? init_amd+0x752/0x780
[    0.018000]  [<89c124a2>] ? init_amd+0x752/0x780
[    0.018000]  [<89c44bee>] warn_slowpath_fmt+0x2e/0x30
[    0.018000]  [<89c124a2>] init_amd+0x752/0x780
[    0.018000]  [<89c104a7>] identify_cpu+0x117/0x4d0
[    0.018000]  [<89c1086f>] identify_secondary_cpu+0xf/0x20
[    0.018000]  [<89c289ed>] smp_store_cpu_info+0x2d/0x40   
[    0.018000]  [<89c290ac>] start_secondary+0xec/0x270
[    0.018000] ---[ end trace 129d9276306a64a7 ]---

Bisect shows that it predates Linux 3.0:

git bisect good faa2e6fb0a98c9caa8995acf3222db9f7f029395  # 05:42     10+     17  Add linux-next specific files for 20140221
git bisect  bad faa2e6fb0a98c9caa8995acf3222db9f7f029395  # 05:45      8-     20  Add linux-next specific files for 20140221
git bisect  bad 5047a5b231a24b15d06958cefb54858d77debd22  # 05:46      0-     10  Merge remote-tracking branch 'llvmlinux/for-next'
git bisect  bad d8ec26d7f8287f5788a494f56e8814210f0e64be  # 05:46      0-      7  Linux 3.13
git bisect  bad 5e01dc7b26d9f24f39abace5da98ccbd6a5ceb52  # 05:46      0-     16  Linux 3.12
git bisect  bad 6e4664525b1db28f8c4e1130957f70a94c19213e  # 05:46      0-     74  Linux 3.11
git bisect  bad 8bb495e3f02401ee6f76d1b1d77f3ac9f079e376  # 05:46      0-     77  Linux 3.10
git bisect  bad c1be5a5b1b355d40e6cf79cc979eb66dafa24ad1  # 05:53     42-      2  Linux 3.9
git bisect  bad 19f949f52599ba7c3f67a5897ac6be14bfcb1200  # 05:57      2-      3  Linux 3.8
git bisect  bad 29594404d7fe73cd80eaa4ee8c43dcc53970c60e  # 06:18    125-     64  Linux 3.7
git bisect  bad a0d271cbfed1dd50278c6b06bead3d00ba0a88f9  # 06:26     35-     20  Linux 3.6
git bisect  bad 28a33cbc24e4256c143dce96c7d93bf423229f92  # 06:30      6-      5  Linux 3.5
git bisect  bad 76e10d158efb6d4516018846f60c2ab5501900bc  # 06:36     62-     39  Linux 3.4
git bisect  bad c16fa4f2ad19908a47c63d8fa436a1178438c7e7  # 06:46     87-     33  Linux 3.3
git bisect  bad 805a6af8dba5dfdd35ec35dc52ec0122400b2610  # 06:52     23-     10  Linux 3.2
git bisect  bad c3b92c8787367a8bb53d57d9789b558f1295cc96  # 07:14    525-    201  Linux 3.1
git bisect  bad 02f8c6aee8df3cdc935e9bdd4f2d020306035dbe  # 07:29    248-    105  Linux 3.0

Thanks,
Fengguang

--ikeVEW9yuYc//A+q
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="dmesg-yocto-roam-17:20140222002312:i386-randconfig-x4-02212316:3.14.0-rc3-next-20140221-04488-gfaa2e6f:1"
Content-Transfer-Encoding: quoted-printable

early console in setup code
Probing EDD (edd=3Doff to disable)... ok
[    0.000000] Initializing cgroup subsys cpuset
[    0.000000] Initializing cgroup subsys cpu
[    0.000000] Linux version 3.14.0-rc3-next-20140221-04488-gfaa2e6f (kbuil=
d@xian) (gcc version 4.8.1 (Debian 4.8.1-8) ) #1 SMP Sat Feb 22 00:12:46 CS=
T 2014
[    0.000000] e820: BIOS-provided physical RAM map:
[    0.000000] BIOS-e820: [mem 0x0000000000000000-0x000000000009fbff] usable
[    0.000000] BIOS-e820: [mem 0x000000000009fc00-0x000000000009ffff] reser=
ved
[    0.000000] BIOS-e820: [mem 0x00000000000f0000-0x00000000000fffff] reser=
ved
[    0.000000] BIOS-e820: [mem 0x0000000000100000-0x0000000013ffdfff] usable
[    0.000000] BIOS-e820: [mem 0x0000000013ffe000-0x0000000013ffffff] reser=
ved
[    0.000000] BIOS-e820: [mem 0x00000000fffc0000-0x00000000ffffffff] reser=
ved
[    0.000000] Notice: NX (Execute Disable) protection cannot be enabled: n=
on-PAE kernel!
[    0.000000] e820: update [mem 0x00000000-0x00000fff] usable =3D=3D> rese=
rved
[    0.000000] e820: remove [mem 0x000a0000-0x000fffff] usable
[    0.000000] e820: last_pfn =3D 0x13ffe max_arch_pfn =3D 0x100000
[    0.000000] initial memory mapped: [mem 0x00000000-0x0affffff]
[    0.000000] Base memory trampoline at [8009b000] 9b000 size 16384
[    0.000000] init_memory_mapping: [mem 0x00000000-0x000fffff]
[    0.000000]  [mem 0x00000000-0x000fffff] page 4k
[    0.000000] init_memory_mapping: [mem 0x13800000-0x13bfffff]
[    0.000000]  [mem 0x13800000-0x13bfffff] page 4k
[    0.000000] BRK [0x0ab21000, 0x0ab21fff] PGTABLE
[    0.000000] init_memory_mapping: [mem 0x10000000-0x137fffff]
[    0.000000]  [mem 0x10000000-0x137fffff] page 4k
[    0.000000] BRK [0x0ab22000, 0x0ab22fff] PGTABLE
[    0.000000] BRK [0x0ab23000, 0x0ab23fff] PGTABLE
[    0.000000] BRK [0x0ab24000, 0x0ab24fff] PGTABLE
[    0.000000] BRK [0x0ab25000, 0x0ab25fff] PGTABLE
[    0.000000] BRK [0x0ab26000, 0x0ab26fff] PGTABLE
[    0.000000] init_memory_mapping: [mem 0x00100000-0x0fffffff]
[    0.000000]  [mem 0x00100000-0x0fffffff] page 4k
[    0.000000] init_memory_mapping: [mem 0x13c00000-0x13ffdfff]
[    0.000000]  [mem 0x13c00000-0x13ffdfff] page 4k
[    0.000000] RAMDISK: [mem 0x13cbd000-0x13feffff]
[    0.000000] ACPI: RSDP 0x000FD930 000014 (v00 BOCHS )
[    0.000000] ACPI: RSDT 0x13FFE450 000034 (v01 BOCHS  BXPCRSDT 00000001 B=
XPC 00000001)
[    0.000000] ACPI: FACP 0x13FFFF80 000074 (v01 BOCHS  BXPCFACP 00000001 B=
XPC 00000001)
[    0.000000] ACPI: DSDT 0x13FFE490 0011A9 (v01 BXPC   BXDSDT   00000001 I=
NTL 20100528)
[    0.000000] ACPI: FACS 0x13FFFF40 000040
[    0.000000] ACPI: SSDT 0x13FFF7A0 000796 (v01 BOCHS  BXPCSSDT 00000001 B=
XPC 00000001)
[    0.000000] ACPI: APIC 0x13FFF680 000080 (v01 BOCHS  BXPCAPIC 00000001 B=
XPC 00000001)
[    0.000000] ACPI: HPET 0x13FFF640 000038 (v01 BOCHS  BXPCHPET 00000001 B=
XPC 00000001)
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] mapped APIC to         ffffb000 (        fee00000)
[    0.000000] 0MB HIGHMEM available.
[    0.000000] 319MB LOWMEM available.
[    0.000000]   mapped low ram: 0 - 13ffe000
[    0.000000]   low ram: 0 - 13ffe000
[    0.000000] Zone ranges:
[    0.000000]   Normal   [mem 0x00001000-0x13ffdfff]
[    0.000000]   HighMem  empty
[    0.000000] Movable zone start for each node
[    0.000000] Early memory node ranges
[    0.000000]   node   0: [mem 0x00001000-0x0009efff]
[    0.000000]   node   0: [mem 0x00100000-0x13ffdfff]
[    0.000000] On node 0 totalpages: 81820
[    0.000000]   Normal zone: 720 pages used for memmap
[    0.000000]   Normal zone: 0 pages reserved
[    0.000000]   Normal zone: 81820 pages, LIFO batch:15
[    0.000000] Using APIC driver default
[    0.000000] ACPI: PM-Timer IO Port: 0xb008
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] mapped APIC to         ffffb000 (        fee00000)
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
[    0.000000] mapped IOAPIC to ffffa000 (fec00000)
[    0.000000] nr_irqs_gsi: 40
[    0.000000] e820: [mem 0x14000000-0xfffbffff] available for PCI devices
[    0.000000] Booting paravirtualized kernel on bare hardware
[    0.000000] setup_percpu: NR_CPUS:32 nr_cpumask_bits:2 nr_cpu_ids:2 nr_n=
ode_ids:1
[    0.000000] PERCPU: Embedded 331 pages/cpu @936dc000 s1339400 r0 d16376 =
u1355776
[    0.000000] pcpu-alloc: s1339400 r0 d16376 u1355776 alloc=3D331*4096
[    0.000000] pcpu-alloc: [0] 0 [0] 1=20
[    0.000000] Built 1 zonelists in Zone order, mobility grouping on.  Tota=
l pages: 81100
[    0.000000] Kernel command line: hung_task_panic=3D1 earlyprintk=3DttyS0=
,115200 debug apic=3Ddebug sysrq_always_enabled panic=3D10 softlockup_panic=
=3D1 nmi_watchdog=3Dpanic  prompt_ramdisk=3D0 console=3DttyS0,115200 consol=
e=3Dtty0 vga=3Dnormal  root=3D/dev/ram0 rw link=3D/kernel-tests/run-queue/k=
vm/i386-randconfig-x4-02212316/next:master/.vmlinuz-faa2e6fb0a98c9caa8995ac=
f3222db9f7f029395-20140222001515-4-roam branch=3Dnext/master BOOT_IMAGE=3D/=
kernel/i386-randconfig-x4-02212316/faa2e6fb0a98c9caa8995acf3222db9f7f029395=
/vmlinuz-3.14.0-rc3-next-20140221-04488-gfaa2e6f
[    0.000000] PID hash table entries: 2048 (order: 1, 8192 bytes)
[    0.000000] Dentry cache hash table entries: 65536 (order: 6, 262144 byt=
es)
[    0.000000] Inode-cache hash table entries: 32768 (order: 5, 131072 byte=
s)
[    0.000000] Initializing CPU#0
[    0.000000] Initializing HighMem for node 0 (00000000:00000000)
[    0.000000] Memory: 302168K/327280K available (5944K kernel code, 555K r=
wdata, 2340K rodata, 1740K init, 4704K bss, 25112K reserved, 0K highmem)
[    0.000000] virtual kernel memory layout:
[    0.000000]     fixmap  : 0xffd35000 - 0xfffff000   (2856 kB)
[    0.000000]     pkmap   : 0xff800000 - 0xffc00000   (4096 kB)
[    0.000000]     vmalloc : 0x947fe000 - 0xff7fe000   (1712 MB)
[    0.000000]     lowmem  : 0x80000000 - 0x93ffe000   ( 319 MB)
[    0.000000]       .init : 0x8a4a4000 - 0x8a657000   (1740 kB)
[    0.000000]       .data : 0x8a1ce579 - 0x8a4a3e40   (2902 kB)
[    0.000000]       .text : 0x89c00000 - 0x8a1ce579   (5945 kB)
[    0.000000] Checking if this processor honours the WP bit even in superv=
isor mode...Ok.
[    0.000000] Hierarchical RCU implementation.
[    0.000000]=20
[    0.000000]=20
[    0.000000]=20
[    0.000000]=20
[    0.000000] RCU: Adjusting geometry for rcu_fanout_leaf=3D16, nr_cpu_ids=
=3D2
[    0.000000] NR_IRQS:2304 nr_irqs:512 16
[    0.000000] CPU 0 irqstacks, hard=3D80090000 soft=3D80092000
[    0.000000] ACPI: Core revision 20140114
[    0.000000] ACPI: All ACPI Tables successfully acquired
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
[    0.000000]  memory used by lock dependency info: 3807 kB
[    0.000000]  per task-struct memory footprint: 1920 bytes
[    0.000000] hpet clockevent registered
[    0.000000] tsc: Fast TSC calibration failed
[    0.000000] tsc: Unable to calibrate against PIT
[    0.000000] tsc: using HPET reference calibration
[    0.000000] tsc: Detected 2892.909 MHz processor
[    0.000000] tsc: Marking TSC unstable due to TSCs unsynchronized
[    0.018000] Calibrating delay loop (skipped), value calculated using tim=
er frequency.. 5785.81 BogoMIPS (lpj=3D2892909)
[    0.020283] pid_max: default: 32768 minimum: 301
[    0.025233] Mount-cache hash table entries: 512
[    0.047707] Initializing cgroup subsys debug
[    0.048567] Initializing cgroup subsys devices
[    0.049360] Initializing cgroup subsys perf_event
[    0.061000] mce: CPU supports 10 MCE banks
[    0.071932] Last level iTLB entries: 4KB 0, 2MB 0, 4MB 0
[    0.071932] Last level dTLB entries: 4KB 0, 2MB 0, 4MB 0, 1GB 0
[    0.071932] tlb_flushall_shift: -1
[    0.076482] debug: unmapping init [mem 0x8a657000-0x8a65cfff]
[    0.123306] Getting VERSION: 50011
[    0.123680] Getting VERSION: 50011
[    0.124218] Getting ID: 0
[    0.124383] Getting ID: f000000
[    0.124565] Getting LVT0: 8700
[    0.124722] Getting LVT1: 8400
[    0.125268] Enabling APIC mode:  Flat.  Using 1 I/O APICs
[    0.127137] enabled ExtINT on CPU#0
[    0.131724] ENABLING IO-APIC IRQs
[    0.132377] init IO_APIC IRQs
[    0.133237]  apic 0 pin 0 not connected
[    0.136265] IOAPIC[0]: Set routing entry (0-1 -> 0x31 -> IRQ 1 Mode:0 Ac=
tive:0 Dest:1)
[    0.139130] IOAPIC[0]: Set routing entry (0-2 -> 0x30 -> IRQ 0 Mode:0 Ac=
tive:0 Dest:1)
[    0.139662] IOAPIC[0]: Set routing entry (0-3 -> 0x33 -> IRQ 3 Mode:0 Ac=
tive:0 Dest:1)
[    0.140319] IOAPIC[0]: Set routing entry (0-4 -> 0x34 -> IRQ 4 Mode:0 Ac=
tive:0 Dest:1)
[    0.141000] IOAPIC[0]: Set routing entry (0-5 -> 0x35 -> IRQ 5 Mode:1 Ac=
tive:0 Dest:1)
[    0.141000] IOAPIC[0]: Set routing entry (0-6 -> 0x36 -> IRQ 6 Mode:0 Ac=
tive:0 Dest:1)
[    0.141000] IOAPIC[0]: Set routing entry (0-7 -> 0x37 -> IRQ 7 Mode:0 Ac=
tive:0 Dest:1)
[    0.141000] IOAPIC[0]: Set routing entry (0-8 -> 0x38 -> IRQ 8 Mode:0 Ac=
tive:0 Dest:1)
[    0.141000] IOAPIC[0]: Set routing entry (0-9 -> 0x39 -> IRQ 9 Mode:1 Ac=
tive:0 Dest:1)
[    0.141000] IOAPIC[0]: Set routing entry (0-10 -> 0x3a -> IRQ 10 Mode:1 =
Active:0 Dest:1)
[    0.141000] IOAPIC[0]: Set routing entry (0-11 -> 0x3b -> IRQ 11 Mode:1 =
Active:0 Dest:1)
[    0.141000] IOAPIC[0]: Set routing entry (0-12 -> 0x3c -> IRQ 12 Mode:0 =
Active:0 Dest:1)
[    0.141000] IOAPIC[0]: Set routing entry (0-13 -> 0x3d -> IRQ 13 Mode:0 =
Active:0 Dest:1)
[    0.141000] IOAPIC[0]: Set routing entry (0-14 -> 0x3e -> IRQ 14 Mode:0 =
Active:0 Dest:1)
[    0.141183] IOAPIC[0]: Set routing entry (0-15 -> 0x3f -> IRQ 15 Mode:0 =
Active:0 Dest:1)
[    0.141560]  apic 0 pin 16 not connected
[    0.141708]  apic 0 pin 17 not connected
[    0.141858]  apic 0 pin 18 not connected
[    0.142000]  apic 0 pin 19 not connected
[    0.142000]  apic 0 pin 20 not connected
[    0.142000]  apic 0 pin 21 not connected
[    0.142000]  apic 0 pin 22 not connected
[    0.142000]  apic 0 pin 23 not connected
[    0.142000] ..TIMER: vector=3D0x30 apic1=3D0 pin1=3D2 apic2=3D-1 pin2=3D=
-1
[    0.152749] smpboot: CPU0: AMD QEMU Virtual CPU version 1.6.0 (fam: 06, =
model: 02, stepping: 03)
[    0.155199] Using local APIC timer interrupts.
[    0.155199] calibrating APIC timer ...
[    0.157000] ... lapic delta =3D 8396380
[    0.157000] ... PM-Timer delta =3D 480883
[    0.157000] APIC calibration not consistent with PM-Timer: 134ms instead=
 of 100ms
[    0.157000] APIC delta adjusted to PM-Timer: 6249998 (8396380)
[    0.157000] TSC delta adjusted to PM-Timer: 289295649 (388645915)
[    0.157000] ..... delta 6249998
[    0.157000] ..... mult: 268435370
[    0.157000] ..... calibration result: 999999
[    0.157000] ..... CPU clock speed is 2892.0956 MHz.
[    0.157000] ..... host bus clock speed is 999.0999 MHz.
[    0.159344] Performance Events: Broken PMU hardware detected, using soft=
ware events only.
[    0.160763] Failed to access perfctr msr (MSR c0010004 is 0)
[    0.231401] CPU 1 irqstacks, hard=3D80062000 soft=3D80064000
[    0.231736] x86: Booting SMP configuration:
[    0.232214] .... node  #0, CPUs:      #1
[    0.018000] Initializing CPU#1
[    0.018000] masked ExtINT on CPU#1
[    0.018000] ------------[ cut here ]------------
[    0.018000] WARNING: CPU: 1 PID: 0 at arch/x86/kernel/cpu/amd.c:220 init=
_amd+0x752/0x780()
[    0.018000] WARNING: This combination of AMD processors is not suitable =
for SMP.
[    0.018000] CPU: 1 PID: 0 Comm: swapper/1 Not tainted 3.14.0-rc3-next-20=
140221-04488-gfaa2e6f #1
[    0.018000]  00000000 00000000 80047ec0 8a1c529a 80047f00 80047ef0 89c44=
b6f 8a38b9f4
[    0.018000]  80047f1c 00000000 8a38ba3c 000000dc 89c124a2 89c124a2 9396c=
fc0 9396d010
[    0.018000]  9396d03c 80047f08 89c44bee 00000009 80047f00 8a38b9f4 80047=
f1c 80047f44
[    0.018000] Call Trace:
[    0.018000]  [<8a1c529a>] dump_stack+0x48/0x60
[    0.018000]  [<89c44b6f>] warn_slowpath_common+0x6f/0x90
[    0.018000]  [<89c124a2>] ? init_amd+0x752/0x780
[    0.018000]  [<89c124a2>] ? init_amd+0x752/0x780
[    0.018000]  [<89c44bee>] warn_slowpath_fmt+0x2e/0x30
[    0.018000]  [<89c124a2>] init_amd+0x752/0x780
[    0.018000]  [<89c104a7>] identify_cpu+0x117/0x4d0
[    0.018000]  [<89c1086f>] identify_secondary_cpu+0xf/0x20
[    0.018000]  [<89c289ed>] smp_store_cpu_info+0x2d/0x40
[    0.018000]  [<89c290ac>] start_secondary+0xec/0x270
[    0.018000] ---[ end trace 129d9276306a64a7 ]---
[    0.018000] Disabling lock debugging due to kernel taint
[    0.018000] calibrate_delay_direct() dropping max bogoMips estimate 3 =
=3D 10501652
[    0.338445] x86: Booted up 1 node, 2 CPUs
[    0.338730] ----------------
[    0.339058] | NMI testsuite:
[    0.339188] --------------------
[    0.339438]   remote IPI:  ok  |
[    0.349143]    local IPI:  ok  |
[    0.353753] --------------------
[    0.353913] Good, all   2 testcases passed! |
[    0.354058] ---------------------------------
[    0.354467] smpboot: Total of 2 processors activated (22886.04 BogoMIPS)
[    0.434640] regulator-dummy: no parameters
[    0.441180] NET: Registered protocol family 16
[    0.465460] EISA bus registered
[    0.465950] cpuidle: using governor ladder
[    0.472080] ACPI: bus type PCI registered
[    0.477661] PCI: PCI BIOS revision 2.10 entry at 0xfc6d5, last bus=3D0
[    0.478128] PCI: Using configuration type 1 for base access
[    0.805894] gpio-f7188x: Not a Fintek device at 0x0000002e
[    0.806503] gpio-f7188x: Not a Fintek device at 0x0000004e
[    0.816192] ACPI: Added _OSI(Module Device)
[    0.816423] ACPI: Added _OSI(Processor Device)
[    0.818051] ACPI: Added _OSI(3.0 _SCP Extensions)
[    0.818241] ACPI: Added _OSI(Processor Aggregator Device)
[    1.077062] ACPI: Interpreter enabled
[    1.078315] ACPI: (supports S0 S5)
[    1.078668] ACPI: Using IOAPIC for interrupt routing
[    1.080816] PCI: Using host bridge windows from ACPI; if necessary, use =
"pci=3Dnocrs" and report a bug
[    1.394000] ACPI: PCI Root Bridge [PCI0] (domain 0000 [bus 00-ff])
[    1.396207] acpi PNP0A03:00: _OSC: OS supports [Segments]
[    1.397224] acpi PNP0A03:00: _OSC failed (AE_NOT_FOUND); disabling ASPM
[    1.414075] acpi PNP0A03:00: fail to add MMCONFIG information, can't acc=
ess extended PCI configuration space under this bridge.
[    1.417123] PCI host bridge to bus 0000:00
[    1.417718] pci_bus 0000:00: root bus resource [bus 00-ff]
[    1.418150] pci_bus 0000:00: root bus resource [io  0x0000-0x0cf7]
[    1.418492] pci_bus 0000:00: root bus resource [io  0x0d00-0xffff]
[    1.418720] pci_bus 0000:00: root bus resource [mem 0x000a0000-0x000bfff=
f]
[    1.419068] pci_bus 0000:00: root bus resource [mem 0x80000000-0xfebffff=
f]
[    1.420894] pci 0000:00:00.0: [8086:1237] type 00 class 0x060000
[    1.432085] pci 0000:00:01.0: [8086:7000] type 00 class 0x060100
[    1.441546] pci 0000:00:01.1: [8086:7010] type 00 class 0x010180
[    1.448641] pci 0000:00:01.1: reg 0x20: [io  0xc1c0-0xc1cf]
[    1.458472] pci 0000:00:01.3: [8086:7113] type 00 class 0x068000
[    1.459877] pci 0000:00:01.3: quirk: [io  0xb000-0xb03f] claimed by PIIX=
4 ACPI
[    1.460116] pci 0000:00:01.3: quirk: [io  0xb100-0xb10f] claimed by PIIX=
4 SMB
[    1.468841] pci 0000:00:02.0: [1013:00b8] type 00 class 0x030000
[    1.471101] pci 0000:00:02.0: reg 0x10: [mem 0xfc000000-0xfdffffff pref]
[    1.474056] pci 0000:00:02.0: reg 0x14: [mem 0xfebf0000-0xfebf0fff]
[    1.484085] pci 0000:00:02.0: reg 0x30: [mem 0xfebe0000-0xfebeffff pref]
[    1.491571] pci 0000:00:03.0: [8086:100e] type 00 class 0x020000
[    1.495000] pci 0000:00:03.0: reg 0x10: [mem 0xfeba0000-0xfebbffff]
[    1.497075] pci 0000:00:03.0: reg 0x14: [io  0xc000-0xc03f]
[    1.506221] pci 0000:00:03.0: reg 0x30: [mem 0xfebc0000-0xfebdffff pref]
[    1.514174] pci 0000:00:04.0: [1af4:1001] type 00 class 0x010000
[    1.516202] pci 0000:00:04.0: reg 0x10: [io  0xc040-0xc07f]
[    1.518067] pci 0000:00:04.0: reg 0x14: [mem 0xfebf1000-0xfebf1fff]
[    1.535572] pci 0000:00:05.0: [1af4:1001] type 00 class 0x010000
[    1.537070] pci 0000:00:05.0: reg 0x10: [io  0xc080-0xc0bf]
[    1.539076] pci 0000:00:05.0: reg 0x14: [mem 0xfebf2000-0xfebf2fff]
[    1.556564] pci 0000:00:06.0: [1af4:1001] type 00 class 0x010000
[    1.558073] pci 0000:00:06.0: reg 0x10: [io  0xc0c0-0xc0ff]
[    1.560070] pci 0000:00:06.0: reg 0x14: [mem 0xfebf3000-0xfebf3fff]
[    1.578249] pci 0000:00:07.0: [1af4:1001] type 00 class 0x010000
[    1.580073] pci 0000:00:07.0: reg 0x10: [io  0xc100-0xc13f]
[    1.583080] pci 0000:00:07.0: reg 0x14: [mem 0xfebf4000-0xfebf4fff]
[    1.601486] pci 0000:00:08.0: [1af4:1001] type 00 class 0x010000
[    1.603075] pci 0000:00:08.0: reg 0x10: [io  0xc140-0xc17f]
[    1.605072] pci 0000:00:08.0: reg 0x14: [mem 0xfebf5000-0xfebf5fff]
[    1.622148] pci 0000:00:09.0: [1af4:1001] type 00 class 0x010000
[    1.624203] pci 0000:00:09.0: reg 0x10: [io  0xc180-0xc1bf]
[    1.626070] pci 0000:00:09.0: reg 0x14: [mem 0xfebf6000-0xfebf6fff]
[    1.644262] pci 0000:00:0a.0: [8086:25ab] type 00 class 0x088000
[    1.645639] pci 0000:00:0a.0: reg 0x10: [mem 0xfebf7000-0xfebf700f]
[    1.660810] pci_bus 0000:00: on NUMA node 0
[    1.685845] ACPI: PCI Interrupt Link [LNKA] (IRQs 5 *10 11)
[    1.695459] ACPI: PCI Interrupt Link [LNKB] (IRQs 5 *10 11)
[    1.703861] ACPI: PCI Interrupt Link [LNKC] (IRQs 5 10 *11)
[    1.712598] ACPI: PCI Interrupt Link [LNKD] (IRQs 5 10 *11)
[    1.715786] ACPI: PCI Interrupt Link [LNKS] (IRQs *9)
[    1.739000] ACPI: Enabled 16 GPEs in block 00 to 0F
[    1.769000] vgaarb: device added: PCI:0000:00:02.0,decodes=3Dio+mem,owns=
=3Dio+mem,locks=3Dnone
[    1.769182] vgaarb: loaded
[    1.769334] vgaarb: bridge control possible 0000:00:02.0
[    1.805436] pps_core: LinuxPPS API ver. 1 registered
[    1.806057] pps_core: Software ver. 5.3.6 - Copyright 2005-2007 Rodolfo =
Giometti <giometti@linux.it>
[    1.807239] PTP clock support registered
[    1.815053] PCI: Using ACPI for IRQ routing
[    1.815538] PCI: pci_cache_line_size set to 64 bytes
[    1.817052] e820: reserve RAM buffer [mem 0x0009fc00-0x0009ffff]
[    1.817539] e820: reserve RAM buffer [mem 0x13ffe000-0x13ffffff]
[    1.836243] irda_init()
[    1.840559] NET: Registered protocol family 23
[    1.842732] NET: Registered protocol family 8
[    1.843089] NET: Registered protocol family 20
[    1.846138] nfc: nfc_init: NFC Core ver 0.1
[    1.848761] NET: Registered protocol family 39
[    1.856702] Switched to clocksource hpet
[    1.860499] pnp: PnP ACPI init
[    1.861633] ACPI: bus type PNP registered
[    1.866344] IOAPIC[0]: Set routing entry (0-8 -> 0x38 -> IRQ 8 Mode:0 Ac=
tive:0 Dest:3)
[    1.869159] pnp 00:00: Plug and Play ACPI device, IDs PNP0b00 (active)
[    1.870508] IOAPIC[0]: Set routing entry (0-1 -> 0x31 -> IRQ 1 Mode:0 Ac=
tive:0 Dest:3)
[    1.871931] pnp 00:01: Plug and Play ACPI device, IDs PNP0303 (active)
[    1.874367] IOAPIC[0]: Set routing entry (0-12 -> 0x3c -> IRQ 12 Mode:0 =
Active:0 Dest:3)
[    1.875899] pnp 00:02: Plug and Play ACPI device, IDs PNP0f13 (active)
[    1.878973] IOAPIC[0]: Set routing entry (0-6 -> 0x36 -> IRQ 6 Mode:0 Ac=
tive:0 Dest:3)
[    1.879640] pnp 00:03: [dma 2]
[    1.881520] pnp 00:03: Plug and Play ACPI device, IDs PNP0700 (active)
[    1.896050] IOAPIC[0]: Set routing entry (0-7 -> 0x37 -> IRQ 7 Mode:0 Ac=
tive:0 Dest:3)
[    1.897562] pnp 00:04: Plug and Play ACPI device, IDs PNP0400 (active)
[    1.899466] IOAPIC[0]: Set routing entry (0-4 -> 0x34 -> IRQ 4 Mode:0 Ac=
tive:0 Dest:3)
[    1.900854] pnp 00:05: Plug and Play ACPI device, IDs PNP0501 (active)
[    1.915030] pnp 00:06: Plug and Play ACPI device, IDs PNP0103 (active)
[    1.920780] pnp: PnP ACPI: found 7 devices
[    1.921029] ACPI: bus type PNP unregistered
[    1.985435] pci_bus 0000:00: resource 4 [io  0x0000-0x0cf7]
[    1.985711] pci_bus 0000:00: resource 5 [io  0x0d00-0xffff]
[    1.985964] pci_bus 0000:00: resource 6 [mem 0x000a0000-0x000bffff]
[    1.986164] pci_bus 0000:00: resource 7 [mem 0x80000000-0xfebfffff]
[    1.987459] NET: Registered protocol family 2
[    2.008626] TCP established hash table entries: 4096 (order: 2, 16384 by=
tes)
[    2.010532] TCP bind hash table entries: 4096 (order: 5, 180224 bytes)
[    2.014214] TCP: Hash tables configured (established 4096 bind 4096)
[    2.015706] TCP: reno registered
[    2.016218] UDP hash table entries: 256 (order: 2, 24576 bytes)
[    2.017198] UDP-Lite hash table entries: 256 (order: 2, 24576 bytes)
[    2.021829] NET: Registered protocol family 1
[    2.035955] RPC: Registered named UNIX socket transport module.
[    2.036226] RPC: Registered udp transport module.
[    2.036524] RPC: Registered tcp transport module.
[    2.036807] RPC: Registered tcp NFSv4.1 backchannel transport module.
[    2.037150] pci 0000:00:00.0: Limiting direct PCI/PCI transfers
[    2.037560] pci 0000:00:01.0: PIIX3: Enabling Passive Release
[    2.038164] pci 0000:00:01.0: Activating ISA DMA hang workarounds
[    2.038871] pci 0000:00:02.0: Boot video device
[    2.039467] PCI: CLS 0 bytes, default 64
[    2.063151] Unpacking initramfs...
[    4.906171] debug: unmapping init [mem 0x93cbd000-0x93feffff]
[   21.185976] DMA-API: preallocated 65536 debug entries
[   21.186219] DMA-API: debugging enabled by kernel config
[   21.280370] Machine check injector initialized
[   21.998552] The force parameter has not been set to 1. The Iris poweroff=
 handler will not be installed.
[   22.000060] NatSemi SCx200 Driver
[   22.005141] spin_lock-torture:--- Start of test: nwriters_stress=3D4 sta=
t_interval=3D60 verbose=3D1 shuffle_interval=3D3 stutter=3D5 shutdown_secs=
=3D0 onoff_interval=3D0 onoff_holdoff=3D0
[   22.007213] spin_lock-torture: Creating torture_shuffle task
[   22.014054] spin_lock-torture: torture_shuffle task started
[   22.015096] spin_lock-torture: Creating torture_stutter task
[   22.030138] spin_lock-torture: Creating lock_torture_writer task
[   22.031083] spin_lock-torture: torture_stutter task started
[   22.053128] spin_lock-torture: Creating lock_torture_writer task
[   22.053978] spin_lock-torture: lock_torture_writer task started
[   22.063181] spin_lock-torture: Creating lock_torture_writer task
[   22.063368] spin_lock-torture: lock_torture_writer task started
[   22.081202] spin_lock-torture: Creating lock_torture_writer task
[   22.082898] spin_lock-torture: lock_torture_writer task started
[   22.089413] spin_lock-torture: lock_torture_writer task started
[   22.090180] spin_lock-torture: Creating lock_torture_stats task
[   22.126163] spin_lock-torture: lock_torture_stats task started
[   22.229920] futex hash table entries: 512 (order: 3, 32768 bytes)
[   22.285469] NFS: Registering the id_resolver key type
[   22.288182] Key type id_resolver registered
[   22.288585] Key type id_legacy registered
[   22.289041] nfs4filelayout_init: NFSv4 File Layout Driver Registering...
[   22.289606] Installing knfsd (copyright (C) 1996 okir@monad.swb.de).
[   22.301213] Key type cifs.idmap registered
[   22.328482] fuse init (API version 7.22)
[   22.333558] 9p: Installing v9fs 9p2000 file system support
[   22.334453] msgmni has been set to 590
[   23.353572] alg: No test for crc32 (crc32-table)
[   23.387552] alg: No test for lz4 (lz4-generic)
[   23.401393] alg: No test for stdrng (krng)
[   23.671095] alg: No test for fips(ansi_cprng) (fips_ansi_cprng)
[   23.695917] NET: Registered protocol family 38
[   23.696847] Key type asymmetric registered
[   23.697082] Asymmetric key parser 'x509' registered
[   23.697806] test_string_helpers: Running tests...
[   23.766287] no IO addresses supplied
[   23.786802] hgafb: HGA card not detected.
[   23.787559] hgafb: probe of hgafb.0 failed with error -22
[   24.120000] uvesafb: VGABIOS Cirrus extension, VGABIOS Cirrus extension,=
 1.0, OEM: VGABIOS Cirrus extension, VBE v2.0
[   24.250402] uvesafb: no monitor limits have been set, default refresh ra=
te will be used
[   24.254864] uvesafb: VBE state buffer size cannot be determined (eax=3D0=
x14f, err=3D0)
[   24.258097] uvesafb: scrolling: redraw
[   24.309467] uvesafb: framebuffer at 0xfc000000, mapped to 0x94900000, us=
ing 4096k, total 4096k
[   24.309874] fb0: VESA VGA frame buffer device
[   24.325838] ipmi message handler version 39.2
[   24.326203] ipmi device interface
[   24.335549] IPMI System Interface driver.
[   24.338031] ipmi_si: Adding default-specified kcs state machine
[   24.338578] ipmi_si: Trying default-specified kcs state machine at i/o a=
ddress 0xca2, slave address 0x0, irq 0
[   24.340208] ipmi_si: Interface detection failed
[   24.356310] ipmi_si: Adding default-specified smic state machine
[   24.356310] ipmi_si: Trying default-specified smic state machine at i/o =
address 0xca9, slave address 0x0, irq 0
[   24.356310] ipmi_si: Interface detection failed
[   24.359711] ipmi_si: Adding default-specified bt state machine
[   24.359968] ipmi_si: Trying default-specified bt state machine at i/o ad=
dress 0xe4, slave address 0x0, irq 0
[   24.360301] ipmi_si: Interface detection failed
[   24.366143] ipmi_si: Unable to find any System Interface(s)
[   24.366599] Copyright (C) 2004 MontaVista Software - IPMI Powerdown via =
sys_reboot.
[   24.418821] input: Power Button as /devices/LNXSYSTM:00/LNXPWRBN:00/inpu=
t/input0
[   24.419400] ACPI: Power Button [PWRF]
[   27.452883] Serial: 8250/16550 driver, 4 ports, IRQ sharing disabled
[   27.529203] 00:05: ttyS0 at I/O 0x3f8 (irq =3D 4, base_baud =3D 115200) =
is a 16550A
[   27.643938] DoubleTalk PC - not found
[   27.664226] ppdev: user-space parallel port driver
[   27.668400] scx200_gpio: no SCx200 gpio present
[   27.670227] platform pc8736x_gpio.0: NatSemi pc8736x GPIO Driver Initial=
izing
[   27.670925] platform pc8736x_gpio.0: no device found
[   27.682061] nsc_gpio initializing
[   27.682580] telclk_interrupt =3D 0xf non-mcpbl0010 hw.
[   27.719003] [drm] Initialized drm 1.1.0 20060810
[   27.728999] parport_pc 00:04: reported by Plug and Play ACPI
[   27.734024] parport0: PC-style at 0x378, irq 7 [PCSPP(,...)]
[   27.924136] dummy-irq: no IRQ given.  Use irq=3DN
[   27.970107] Silicon Labs C2 port support v. 0.51.0 - (C) 2007 Rodolfo Gi=
ometti
[   28.049511] LocalTalk card not found; 220 =3D ff, 240 =3D ff.
[   28.052416] AX.25: Z8530 SCC driver version 3.0.dl1bke
[   28.093063] YAM driver version 0.8 by F1OAT/F6FBB
[   28.231226] AX.25: bpqether driver version 004
[   28.232039] baycom_ser_fdx: (C) 1996-2000 Thomas Sailer, HB9JNX/AE4WA
[   28.232039] baycom_ser_fdx: version 0.10
[   28.486193] hdlcdrv: (C) 1996-2000 Thomas Sailer HB9JNX/AE4WA
[   28.488979] hdlcdrv: version 0.8
[   28.489152] baycom_ser_hdx: (C) 1996-2000 Thomas Sailer, HB9JNX/AE4WA
[   28.489152] baycom_ser_hdx: version 0.10
[   28.707954] baycom_par: (C) 1996-2000 Thomas Sailer, HB9JNX/AE4WA
[   28.707954] baycom_par: version 0.9
[   28.901223] w83977af_init()
[   28.902471] w83977af_open()
[   28.903154] w83977af_probe()
[   28.903571] w83977af_probe(), Wrong chip version
[   28.904042] w83977af_probe()
[   28.904172] w83977af_probe(), Wrong chip version
[   28.960113] fb1: cfag12864b frame buffer device
[   28.985104] i8042: PNP: PS/2 Controller [PNP0303:KBD,PNP0f13:MOU] at 0x6=
0,0x64 irq 1,12
[   28.999213] serio: i8042 KBD port at 0x60,0x64 irq 1
[   29.000524] serio: i8042 AUX port at 0x60,0x64 irq 12
[   29.022636] mousedev: PS/2 mouse device common for all mice
[   29.073969] input: AT Translated Set 2 keyboard as /devices/platform/i80=
42/serio0/input/input1
[   29.141142] i2c-parport-light: adapter type unspecified
[   29.149132] isa i2c-pca-isa.0: Please specify I/O base
[   29.156157] scx200_i2c: no SCx200 gpio pins available
[   29.157182] pps_parport: parallel port PPS client
[   29.159136] parport0: no more devices allowed
[   29.160158] pps_parport: couldn't register with parport0
[   29.167187] Driver for 1-wire Dallas network protocol.
[   29.208159] DS1WM w1 busmaster driver - (c) 2004 Szabolcs Gyurko
[   29.217970] 1-Wire driver for the DS2760 battery monitor  chip  - (c) 20=
04-2005, Szabolcs Gyurko
[   29.226171] w83781d: Detection failed at step 2
[   29.438146] pc87360: PC8736x not detected, module not inserted
[   29.439142] sch56xx_common: Unsupported device id: 0xff
[   29.439572] sch56xx_common: Unsupported device id: 0xff
[   29.461215] mixcomwd: No card detected, or port not available
[   29.463039] acquirewdt: WDT driver for Acquire single board computer ini=
tialising
[   29.467084] acquirewdt: I/O address 0x0043 already in use
[   29.468502] acquirewdt: probe of acquirewdt failed with error -5
[   29.469130] advantechwdt: WDT driver for Advantech single board computer=
 initialising
[   29.487061] advantechwdt: initialized. timeout=3D60 sec (nowayout=3D1)
[   29.488570] sc520_wdt: cannot register miscdev on minor=3D130 (err=3D-16)
[   29.492894] ib700wdt: WDT driver for IB700 single board computer initial=
ising
[   29.497282] ib700wdt: START method I/O 443 is not available
[   29.498057] ib700wdt: probe of ib700wdt failed with error -5
[   29.499158] pc87413_wdt: Version 1.1 at io 0x2E
[   29.499599] pc87413_wdt: cannot register miscdev on minor=3D130 (err=3D-=
16)
[   29.501028] sbc60xxwdt: I/O address 0x0443 already in use
[   29.501563] sbc8360: failed to register misc device
[   29.502074] sbc7240_wdt: I/O address 0x0443 already in use
[   29.502570] w83697hf_wdt: WDT driver for W83697HF/HG initializing
[   29.503125] w83697hf_wdt: watchdog not found at address 0x2e
[   29.503557] w83697hf_wdt: No W83697HF/HG could be found
[   29.504010] w83697ug_wdt: WDT driver for the Winbond(TM) W83697UG/UF Sup=
er I/O chip initialising
[   29.504576] w83697ug_wdt: No W83697UG/UF could be found
[   29.506041] w83877f_wdt: I/O address 0x0443 already in use
[   29.506275] machzwd: MachZ ZF-Logic Watchdog driver initializing
[   29.506637] machzwd: no ZF-Logic found
[   29.507114] sbc_epx_c3: cannot register miscdev on minor=3D130 (err=3D-1=
6)
[   29.523188] watchdog: Software Watchdog: cannot register miscdev on mino=
r=3D130 (err=3D-16).
[   29.524515] watchdog: Software Watchdog: a legacy watchdog module is pro=
bably present.
[   29.529145] softdog: Software Watchdog Timer: 0.08 initialized. soft_nob=
oot=3D0 soft_margin=3D60 sec soft_panic=3D0 (nowayout=3D1)
[   29.532281] platform eisa.0: Probing EISA bus 0
[   29.533082] platform eisa.0: EISA: Cannot allocate resource for mainboard
[   29.537132] cpufreq-nforce2: No nForce2 chipset.
[   29.581210] parport0: no more devices allowed
[   29.582184] panel: panel_attach: port->number=3D0 parport=3D0, parport_r=
egister_device() failed
[   29.583225] panel: driver version 0.9.5 not yet registered
[   29.685187] FPGA DOWNLOAD --->
[   29.686122] built at Sat Feb 22 00:06:27 2014 UTC
[   29.687033] FPGA image file name: xlinx_fpga_firmware.bit
[   29.723179] GPIO INIT FAIL!!
[   29.758167] goldfish_pdev_bus goldfish_pdev_bus: unable to reserve Goldf=
ish MMIO.
[   29.760135] goldfish_pdev_bus: probe of goldfish_pdev_bus failed with er=
ror -16
[   30.040217] GACT probability NOT on
[   30.042137] Mirror/redirect action on
[   30.043165] Simple TC action Loaded
[   30.117002] netem: version 1.3
[   30.119141] u32 classifier
[   30.120076]     Performance counters on
[   30.120194]     input device check on
[   30.121120]     Actions configured
[   30.123073] gre: GRE over IPv4 demultiplexor driver
[   30.125056] ip_gre: GRE over IPv4 tunneling driver
[   30.272190] input: ImExPS/2 Generic Explorer Mouse as /devices/platform/=
i8042/serio1/input/input4
[   30.312209] IPv4 over IPSec tunneling driver
[   30.336194] TCP: bic registered
[   30.336576] TCP: highspeed registered
[   30.336931] TCP: htcp registered
[   30.337058] TCP: vegas registered
[   30.337177] TCP: veno registered
[   30.337927] TCP: scalable registered
[   30.338086] TCP: lp registered
[   30.338223] TCP: yeah registered
[   30.338960] Initializing XFRM netlink socket
[   30.340630] NET: Registered protocol family 10
[   30.384454] mip6: Mobile IPv6
[   30.384960] sit: IPv6 over IPv4 tunneling driver
[   30.446036] NET: Registered protocol family 17
[   30.457096] NET: Registered protocol family 15
[   30.461066] NET: Registered protocol family 4
[   30.464086] NET: Registered protocol family 5
[   30.987562] NET: Registered protocol family 11
[   30.989054] NET: Registered protocol family 3
[   31.040621] NET: Registered protocol family 33
[   31.042191] Key type rxrpc registered
[   31.043228] Key type rxrpc_s registered
[   31.067979] RxRPC: Registered security type 2 'rxkad'
[   31.069697] lec:lane_module_init: lec.c: initialized
[   31.070203] mpoa:atm_mpoa_init: mpc.c: initialized
[   31.071932] NET4: DECnet for Linux: V.2.5.68s (C) 1995-2003 Linux DECnet=
 Project Team
[   31.076574] DECnet: Routing cache hash table of 256 buckets, 11Kbytes
[   31.078004] NET: Registered protocol family 12
[   31.095975] rds_page_remainder_cpu_notify(): cpu 0 action 0x7
[   31.096684] rds_page_remainder_cpu_notify(): cpu 1 action 0x7
[   31.097083] tipc: Activated (version 2.0.0)
[   31.110076] NET: Registered protocol family 30
[   31.136188] tipc: Started in single node mode
[   31.142128] 9pnet: Installing 9P2000 support
[   31.144890] Key type dns_resolver registered
[   31.145548] Key type ceph registered
[   31.147203] libceph: loaded (mon/osd proto 15/24)
[   31.190543] batman_adv: B.A.T.M.A.N. advanced 2014.1.0 (compatibility ve=
rsion 15) loaded
[   31.191217] openvswitch: Open vSwitch switching datapath
[   31.200033] mpls_gso: MPLS GSO support
[   31.248045]=20
[   31.248045] printing PIC contents
[   31.248514] ... PIC  IMR: ffff
[   31.248639] ... PIC  IRR: 1013
[   31.249515] ... PIC  ISR: 0000
[   31.249653] ... PIC ELCR: 0c00
[   31.250139] printing local APIC contents on CPU#0/0:
[   31.250465] ... APIC ID:      00000000 (0)
[   31.250465] ... APIC VERSION: 00050011
[   31.250465] ... APIC TASKPRI: 00000000 (00)
[   31.250465] ... APIC ARBPRI: 00000000 (00)
[   31.250465] ... APIC PROCPRI: 00000000
[   31.250465] ... APIC LDR: 01000000
[   31.250465] ... APIC DFR: f0000000
[   31.250465] ... APIC SPIV: 000001ff
[   31.250465] ... APIC ISR field:
[   31.250465] 000000000000000000000000000000000000000000000000000000000000=
0000
[   31.250465] ... APIC TMR field:
[   31.250465] 000000000000000000000000000000000000000000000000000000000000=
0000
[   31.250465] ... APIC IRR field:
[   31.250465] 000000000000000000000000000000000000000000000000000000000000=
8000
[   31.250465] ... APIC ESR: 00000000
[   31.250465] ... APIC ICR: 000008fd
[   31.250465] ... APIC ICR2: 02000000
[   31.250465] ... APIC LVTT: 000200ef
[   31.250465] ... APIC LVTPC: 00010000
[   31.250465] ... APIC LVT0: 00010700
[   31.250465] ... APIC LVT1: 00000400
[   31.250465] ... APIC LVTERR: 000000fe
[   31.250465] ... APIC TMICT: 0000f423
[   31.250465] ... APIC TMCCT: 000009c5
[   31.250465] ... APIC TDCR: 00000003
[   31.250465]=20
[   31.259215] number of MP IRQ sources: 15.
[   31.260482] number of IO-APIC #0 registers: 24.
[   31.260619] testing the IO APIC.......................
[   31.264628] IO APIC #0......
[   31.265048] .... register #00: 00000000
[   31.265170] .......    : physical APIC id: 00
[   31.265556] .......    : Delivery Type: 0
[   31.266542] .......    : LTS          : 0
[   31.267037] .... register #01: 00170011
[   31.267162] .......     : max redirection entries: 17
[   31.267523] .......     : PRQ implemented: 0
[   31.267986] .......     : IO APIC version: 11
[   31.268173] .... register #02: 00000000
[   31.268520] .......     : arbitration: 00
[   31.269440] .... IRQ redirection table:
[   31.269639] 1    0    0   0   0    0    0    00
[   31.270110] 0    0    0   0   0    1    1    31
[   31.270282] 0    0    0   0   0    1    1    30
[   31.270588] 0    0    0   0   0    1    1    33
[   31.271048] 1    0    0   0   0    1    1    34
[   31.271177] 1    1    0   0   0    1    1    35
[   31.272310] 0    0    0   0   0    1    1    36
[   31.272667] 0    0    0   0   0    1    1    37
[   31.273552] 0    0    0   0   0    1    1    38
[   31.274509] 0    1    0   0   0    1    1    39
[   31.275177] 1    1    0   0   0    1    1    3A
[   31.275536] 1    1    0   0   0    1    1    3B
[   31.276530] 0    0    0   0   0    1    1    3C
[   31.277127] 0    0    0   0   0    1    1    3D
[   31.277468] 0    0    0   0   0    1    1    3E
[   31.277612] 0    0    0   0   0    1    1    3F
[   31.278072] 1    0    0   0   0    0    0    00
[   31.278228] 1    0    0   0   0    0    0    00
[   31.278672] 1    0    0   0   0    0    0    00
[   31.279567] 1    0    0   0   0    0    0    00
[   31.280508] 1    0    0   0   0    0    0    00
[   31.280894] 1    0    0   0   0    0    0    00
[   31.281045] 1    0    0   0   0    0    0    00
[   31.281171] 1    0    0   0   0    0    0    00
[   31.281593] IRQ to pin mappings:
[   31.282049] IRQ0 -> 0:2
[   31.282274] IRQ1 -> 0:1
[   31.282562] IRQ3 -> 0:3
[   31.283466] IRQ4 -> 0:4
[   31.283575] IRQ5 -> 0:5
[   31.283956] IRQ6 -> 0:6
[   31.284071] IRQ7 -> 0:7
[   31.284172] IRQ8 -> 0:8
[   31.284504] IRQ9 -> 0:9
[   31.284635] IRQ10 -> 0:10
[   31.284998] IRQ11 -> 0:11
[   31.285115] IRQ12 -> 0:12
[   31.285219] IRQ13 -> 0:13
[   31.285552] IRQ14 -> 0:14
[   31.286191] IRQ15 -> 0:15
[   31.286527] .................................... done.
[   31.287284] Using IPI No-Shortcut mode
[   31.296902] registered taskstats version 1
[   31.297093] kAFS: Red Hat AFS client v0.1 registering.
[   31.307126] kAFS: failed to register: -12
[   31.442710] Key type trusted registered
[   31.549391] BIOS EDD facility v0.16 2004-Jun-25, 6 devices found
[   31.713400] debug: unmapping init [mem 0x8a4a4000-0x8a656fff]
[   31.732690] Write protecting the kernel text: 5948k
[   31.738630] Write protecting the kernel read-only data: 2344k

mount: mounting proc on /proc failed: No such device
/etc/rcS.d/S00fbsetup: line 3: /sbin/modprobe: No such file or directory

Please wait: booting...
mount: mounting proc on /proc failed: No such device
grep: /proc/filesystems: No such file or directory
Starting Bootlog daemon: bootlogd: cannot allocate pseudo tty: No such file=
 or directory
bootlogd.
mount: can't read '/proc/mounts': No such file or directory
/etc/rcS.d/S37populate-volatile.sh: line 172: /proc/cmdline: No such file o=
r directory
grep: /proc/filesystems: No such file or directory
Configuring network interfaces... ifup: can't open '/var/run/ifstate': No s=
uch file or directory
done.
hwclock: can't open '/dev/misc/rtc': No such file or directory
Running postinst /etc/rpm-postinsts/100...

mount: no /proc/mounts
wfg: skip syslogd
Kernel tests: Boot OK!
Kernel tests: Boot OK!
mount: mounting proc on /proc failed: No such device
/etc/rc5.d/S99-rc.local: line 19: /proc/189/oom_score_adj: No such file or =
directory
sed: /lib/modules/3.14.0-rc3-next-20140221-04488-gfaa2e6f/modules.dep: No s=
uch file or directory
xargs: modprobe: No such file or directory
run-parts: /etc/kernel-tests/01-modprobe exited with code 127
grep: /proc/cmdline: No such file or directory
grep: /proc/cmdline: No such file or directory
Trinity v1.4pre  Dave Jones <davej@redhat.com>
Trinity v1.4pre  Dave Jones <davej@redhat.com>
Trinity v1.4pre  Dave Jones <davej@redhat.com>
[   55.109084] random: trinity urandom read with 17 bits of entropy availab=
le
Done parsing arguments.
## couldn't open logfile trinity.log
Done parsing arguments.
[init] Marking syscall get_robust_list (312) as to be disabled.
Done parsing arguments.
Marking all syscalls as enabled.
[init] Enabled 351 syscalls. Disabled 0 syscalls.
Marking all syscalls as enabled.
[init] Disabling syscalls marked as disabled by command line options
[init] Marked syscall get_robust_list (312) as deactivated.
[init] Enabled 350 syscalls. Disabled 1 syscalls.
DANGER: RUNNING AS ROOT.
Unless you are running in a virtual machine, this could cause serious probl=
ems such as overwriting CMOS
or similar which could potentially make this machine unbootable without a f=
irmware reset.

ctrl-c now unless you really know what you are doing.
Continuing in 10 seconds.
Unless you are running in a virtual machine, this could cause serious probl=
ems such as overwriting CMOS
or similar which could potentially make this machine unbootable without a f=
irmware reset.

ctrl-c now unless you really know what you are doing.
Continuing in 10 seconds.
[init] Marking syscall get_robust_list (312) as to be disabled.
Done parsing arguments.
## couldn't open logfile trinity.log
Continuing in 9 seconds.
Couldn't read pid_max from proc
[init] Using pid_max =3D 32768
[init] Kernel was tainted on startup. Will ignore flags that are already se=
t.
[init] Started watchdog process, PID is 207
[main] Main thread is alive.
[main] Couldn't find socket cachefile. Regenerating.
[main] Setsockopt(1 12 80d1000 4) on fd 7 [2:3:38]
[main] Setsockopt(1 20 80d1000 4) on fd 8 [3:2:0]
[main] Setsockopt(100 1 80d1000 4) on fd 9 [4:2:82]
[main] Setsockopt(1 23 80d1000 4) on fd 12 [10:3:46]
[main] Setsockopt(105 b 80d1000 4) on fd 13 [12:5:2]
[main] Setsockopt(10e 4 80d1000 bb) on fd 14 [16:3:0]
fopen: No such file or directory
Couldn't read pid_max from proc
[init] Using pid_max =3D 32768
[main] Setsockopt(1 2 80d1000 4) on fd 16 [20:10:69]
[main] Setsockopt(10a 4 80d1000 ec) on fd 17 [23:1:173]
[   66.773867] irttp_open_tsap(), invalid tsap!
[   66.774135] irda_open_tsap(), Unable to allocate TSAP!
[   66.775065] irias_delete_object(), object already removed!
[init] Kernel was tainted on startup. Will ignore flags that are already se=
t.
[main] Setsockopt(1 2d 80d1000 4) on fd 20 [1:5:1]
[main] Setsockopt(88 1 80d1000 4) on fd 21 [2:2:17]
[main] Setsockopt(1 b 80d1000 8b) on fd 22 [3:5:202]
[init] Started watchdog process, PID is 209
[main] Setsockopt(1 2f 80d1000 4) on fd 23 [4:2:186]
[main] Setsockopt(1 12 80d1000 4) on fd 25 [8:5:62]
[main] Setsockopt(11 1 80d1000 4) on fd 26 [10:2:0]
[main] Setsockopt(1 29 80d1000 d6) on fd 27 [12:1:177]
[main] Main thread is alive.
[main] Setsockopt(1 1d 80d1000 47) on fd 28 [17:2:768]
[main] Setsockopt(1 20 80d1000 c8) on fd 29 [23:1:125]
[main] Setsockopt(1 f 80d1000 4) on fd 31 [39:5:0]
[main] Setsockopt(6 3 80d1000 4) on fd 33 [2:1:6]
[main] Setsockopt(1 23 80d1000 4) on fd 34 [3:2:0]
[main] Setsockopt(1 1d 80d1000 18) on fd 36 [5:3:165]
[main] Setsockopt(1 1d 80d1000 23) on fd 37 [10:1:0]
[main] Setsockopt(10d b 80d1000 4) on fd 38 [12:1:2]
[main] Setsockopt(1 2e 80d1000 4) on fd 39 [16:3:10]
[   67.339702] sock: process `trinity-main' is using obsolete setsockopt SO=
_BSDCOMPAT
[main] Setsockopt(1 e 80d1000 4) on fd 41 [20:2:173]
[main] Setsockopt(1 2 80d1000 d6) on fd 42 [23:1:173]
[main] Setsockopt(6 e 0 cc) on fd 43 [30:1:0]
[main] Setsockopt(1 28 80d1000 69) on fd 46 [2:3:51]
[main] Setsockopt(1 2 80d1000 98) on fd 47 [3:2:0]
[main] Setsockopt(1 8 80d1000 88) on fd 48 [4:2:228]
[main] Setsockopt(1 2e 80d1000 4) on fd 49 [5:2:0]
[main] Setsockopt(1 e 80d1000 ab) on fd 50 [8:2:132]
[main] Setsockopt(1 2f 80d1000 4) on fd 51 [10:1:0]
[main] Setsockopt(1 a 80d1000 c0) on fd 53 [16:2:2]
[main] Setsockopt(1 2f 80d1000 4) on fd 55 [20:10:11]
[main] Setsockopt(1 b 80d1000 29) on fd 56 [23:5:17]
[main] Setsockopt(1 2f 80d1000 4) on fd 57 [30:2:0]
[main] Setsockopt(0 20 80cab80 c) on fd 60 [2:3:248]
[main] Setsockopt(101 c 80d1000 19) on fd 61 [3:2:0]
[main] Setsockopt(1 28 80d1000 4) on fd 63 [5:3:138]
[main] Setsockopt(29 18 0 9b) on fd 65 [10:3:65]
[main] Setsockopt(109 c 80d1000 4) on fd 66 [12:1:251]
[main] Setsockopt(1 2b 80d1000 4) on fd 67 [16:2:10]
[main] Setsockopt(1 1 80d1000 f1) on fd 69 [20:4:175]
[main] Setsockopt(1 22 80d1000 bc) on fd 72 [1:2:1]
[main] Setsockopt(1 d 80d1000 8) on fd 74 [3:3:156]
[main] Setsockopt(1 2d 80d1000 4) on fd 75 [4:2:137]
[main] Setsockopt(1 b 80d1000 4) on fd 76 [5:3:216]
[main] Setsockopt(1 2d 80d1000 4) on fd 77 [8:3:180]
[main] Setsockopt(1 a 80d1000 4) on fd 78 [10:1:0]
[main] Setsockopt(1 2b 80d1000 4) on fd 80 [17:2:768]
[main] Setsockopt(1 12 80d1000 4) on fd 81 [20:5:49]
[main] Setsockopt(1 2e 80d1000 65) on fd 82 [23:1:148]
[main] Setsockopt(1 2e 80d1000 4) on fd 84 [39:2:1]
[main] Setsockopt(1 22 80d1000 4) on fd 85 [1:1:1]
[main] Setsockopt(11 1 80d1000 c1) on fd 86 [2:2:17]
[main] Setsockopt(1 1d 80d1000 4) on fd 89 [5:2:0]
[main] Setsockopt(1 28 80d1000 8c) on fd 90 [8:4:21]
[main] Setsockopt(0 1 80d1000 1) on fd 91 [10:2:0]
[main] Setsockopt(1 2b 80d1000 9e) on fd 93 [17:10:768]
[main] Setsockopt(1 2b 80d1000 c3) on fd 95 [23:1:148]
[main] Setsockopt(1 2f 80d1000 9b) on fd 97 [39:2:1]
[main] Setsockopt(1 2 80d1000 5e) on fd 98 [1:2:1]
[main] Setsockopt(1 28 80d1000 1a) on fd 99 [2:3:95]
[main] Setsockopt(101 8 80d1000 7e) on fd 100 [3:3:95]
[main] Setsockopt(100 1 80d1000 4) on fd 101 [4:2:237]
[main] Setsockopt(1 2b 80d1000 ee) on fd 104 [12:1:54]
[main] Setsockopt(107 7 80d1000 4) on fd 106 [17:3:768]
[main] Setsockopt(1 10 80d1000 4) on fd 110 [1:5:1]
[main] Setsockopt(1 2e 80d1000 4) on fd 111 [2:1:6]
[main] Setsockopt(1 2b 80d1000 4) on fd 112 [3:3:6]
[main] Setsockopt(100 1 80d1000 4) on fd 113 [4:2:215]
[main] Setsockopt(1 5 80d1000 4) on fd 114 [5:3:110]
[main] Setsockopt(29 b 80d1000 4) on fd 116 [10:2:0]
[main] Setsockopt(1 2d 80d1000 4) on fd 117 [12:1:14]
[main] Setsockopt(1 d 80d1000 8) on fd 118 [17:10:768]
[main] Setsockopt(1 29 80d1000 4) on fd 119 [20:2:45]
[main] Setsockopt(1 21 80d1000 4) on fd 122 [39:5:0]
[main] Setsockopt(1 8 80d1000 4) on fd 125 [3:5:206]
[main] Setsockopt(1 f 80d1000 4) on fd 126 [4:2:7]
[main] Setsockopt(1 1 80d1000 86) on fd 128 [10:3:15]
[main] Setsockopt(1 2d 80d1000 4) on fd 130 [16:3:2]
[main] Setsockopt(1 24 80d1000 4) on fd 131 [17:2:768]
[main] Setsockopt(1 a 80d1000 4) on fd 132 [20:4:73]
[   68.440572] irttp_open_tsap(), invalid tsap!
[   68.442397] irda_open_tsap(), Unable to allocate TSAP!
[   68.442589] irias_delete_object(), object already removed!
[main] Setsockopt(6 f 80d1000 d1) on fd 134 [30:1:0]
[main] Setsockopt(1 d 80d1000 8) on fd 136 [1:1:1]
[main] Setsockopt(0 7 80d1000 1) on fd 137 [2:1:0]
[main] Setsockopt(1 b 80d1000 69) on fd 139 [4:2:7]
[main] Setsockopt(1 2b 80d1000 53) on fd 140 [5:2:0]
[main] Setsockopt(108 42000004 80d1000 4) on fd 141 [8:5:128]
[main] Setsockopt(11 1 80d1000 9) on fd 142 [10:2:0]
[main] Setsockopt(1 8 80d1000 a2) on fd 143 [12:1:77]
[main] Setsockopt(1 22 80d1000 4) on fd 144 [17:3:768]
[main] Setsockopt(1 c 80d1000 e7) on fd 145 [20:4:199]
[main] Setsockopt(10a a 80d1000 5d) on fd 146 [23:1:59]
[main] Setsockopt(6 1 0 4) on fd 147 [30:1:0]
[main] Setsockopt(1 21 80d1000 19) on fd 149 [1:2:1]
[main] Setsockopt(1 a 80d1000 4) on fd 150 [2:3:252]
[main] Setsockopt(100 1 80d1000 4) on fd 152 [4:2:153]
[main] Setsockopt(1 f 80d1000 4) on fd 153 [5:3:122]
[main] Setsockopt(108 42000004 80d1000 4) on fd 154 [8:10:216]
[main] Setsockopt(29 18 0 e5) on fd 155 [10:2:17]
[main] Setsockopt(105 d 80d1000 4) on fd 156 [12:1:162]
[main] Setsockopt(10e 5 80d1000 5f) on fd 157 [16:2:2]
[main] Setsockopt(1 8 80d1000 4) on fd 158 [17:2:768]
[main] Setsockopt(1 d 80d1000 8) on fd 160 [23:5:123]
[main] Setsockopt(6 14 0 73) on fd 161 [30:1:0]
[main] Setsockopt(1 22 80d1000 4) on fd 162 [39:2:1]
[main] Setsockopt(1 2f 80d1000 5d) on fd 163 [1:1:1]
[main] Setsockopt(1 20 80d1000 4) on fd 164 [2:3:119]
[main] Setsockopt(101 7 80d1000 4) on fd 165 [3:2:0]
[main] Setsockopt(1 9 80d1000 4) on fd 166 [4:2:81]
[main] Setsockopt(1 24 80d1000 4) on fd 168 [8:4:221]
[main] Setsockopt(1 12 80d1000 62) on fd 169 [10:3:122]
[main] Setsockopt(88 b 80d1000 4) on fd 170 [12:1:177]
[main] Setsockopt(1 9 80d1000 4) on fd 173 [23:5:36]
[main] Setsockopt(6 14 0 4) on fd 174 [30:1:0]
[main] Setsockopt(1 8 80d1000 48) on fd 175 [39:1:1]
[main] Setsockopt(1 2 80d1000 4) on fd 176 [1:1:1]
[main] Setsockopt(1 b 80d1000 3a) on fd 177 [2:1:6]
[main] Setsockopt(1 20 80d1000 72) on fd 179 [4:2:242]
[main] Setsockopt(29 13 0 57) on fd 182 [10:3:230]
[main] Setsockopt(1 d 80d1000 8) on fd 183 [12:5:2]
[main] Setsockopt(1 2 80d1000 4) on fd 184 [16:2:6]
[main] Setsockopt(1 24 80d1000 6a) on fd 185 [17:2:768]
[main] Setsockopt(108 42000004 80d1000 4) on fd 186 [20:10:188]
[main] Setsockopt(1 22 80d1000 4) on fd 187 [23:2:0]
[main] Setsockopt(6 1 80d1000 4) on fd 188 [30:1:0]
[main] Setsockopt(1 1 80d1000 d) on fd 189 [39:5:0]
[main] Setsockopt(6 8 80d1000 4) on fd 191 [2:1:6]
[main] Setsockopt(1 e 80d1000 29) on fd 192 [3:3:6]
[main] Setsockopt(1 1 80d1000 4) on fd 193 [4:2:87]
[main] Setsockopt(29 8 0 4) on fd 196 [10:2:0]
[main] Setsockopt(109 b 80d1000 4) on fd 197 [12:5:2]
[main] Setsockopt(10a a 80d1000 4) on fd 200 [23:5:72]
[main] Setsockopt(1 21 80d1000 a1) on fd 201 [30:5:0]
[main] Setsockopt(0 1 80d1000 4) on fd 204 [2:1:0]
[main] Setsockopt(101 c 80d1000 7) on fd 205 [3:2:0]
[main] Setsockopt(100 1 80d1000 4) on fd 206 [4:2:205]
[main] Setsockopt(1 d 80d1000 8) on fd 207 [5:2:0]
[main] Setsockopt(1 22 80d1000 8) on fd 208 [8:5:31]
[main] Setsockopt(1 2e 80d1000 4) on fd 209 [10:1:0]
[main] Setsockopt(6 c 80d1000 4) on fd 210 [12:5:2]
[main] Setsockopt(1 a 80d1000 dd) on fd 211 [17:2:768]
[main] Setsockopt(1 a 80d1000 4) on fd 213 [23:5:203]
[main] Setsockopt(1 2f 80d1000 4) on fd 214 [30:5:0]
[main] Setsockopt(1 2e 80d1000 d3) on fd 215 [39:5:0]
[main] Setsockopt(0 3 80d1000 4) on fd 217 [2:3:160]
[main] Setsockopt(1 7 80d1000 4) on fd 218 [3:3:160]
[main] Setsockopt(1 f 80d1000 4) on fd 221 [8:2:229]
[main] Setsockopt(29 17 0 61) on fd 222 [10:1:0]
[main] Setsockopt(1 9 80d1000 f7) on fd 223 [12:1:178]
[main] Setsockopt(107 9 80d1000 c9) on fd 225 [17:2:768]
[main] Setsockopt(108 42000004 80d1000 4) on fd 226 [20:5:38]
[main] Setsockopt(10a 7 80d1000 4) on fd 227 [23:1:177]
[   69.369817] irttp_open_tsap(), invalid tsap!
[   69.370023] irda_open_tsap(), Unable to allocate TSAP!
[   69.370206] irias_delete_object(), object already removed!
[main] Setsockopt(1 e 80d1000 33) on fd 228 [30:1:0]
[main] Setsockopt(1 2f 80d1000 1f) on fd 229 [39:5:0]
[main] Setsockopt(1 2f 80d1000 4) on fd 230 [1:1:1]
[main] Setsockopt(11 1 80d1000 19) on fd 231 [2:2:0]
[main] Setsockopt(1 6 80d1000 8d) on fd 234 [5:2:0]
[main] Setsockopt(11 1 80d1000 b4) on fd 236 [10:2:0]
[main] Setsockopt(107 b 80d1000 4) on fd 237 [12:5:2]
[main] Setsockopt(1 a 80d1000 dc) on fd 238 [17:2:768]
[main] Setsockopt(1 12 80d1000 4) on fd 240 [23:5:39]
[   69.520550] irttp_open_tsap(), invalid tsap!
[   69.520953] irda_open_tsap(), Unable to allocate TSAP!
[   69.521148] irias_delete_object(), object already removed!
[main] Setsockopt(1 b 80d1000 4) on fd 242 [39:1:1]
[main] Setsockopt(1 2b 80d1000 4) on fd 243 [1:5:1]
[main] Setsockopt(1 f 80d1000 5d) on fd 246 [4:2:207]
[main] Setsockopt(1 2b 80d1000 4) on fd 247 [5:3:12]
[main] Setsockopt(108 42000004 80d1000 4) on fd 248 [8:5:183]
[main] Setsockopt(29 b 80d1000 4) on fd 249 [10:2:17]
[main] Setsockopt(105 b 80d1000 4) on fd 250 [12:1:194]
[main] Setsockopt(107 8 80d1000 4) on fd 251 [17:2:768]
[main] Setsockopt(10a 7 80d1000 35) on fd 252 [23:2:0]
[main] Setsockopt(1 d 80d1000 8) on fd 253 [30:2:0]
[main] Setsockopt(1 f 80d1000 4) on fd 254 [39:1:1]
[main] Setsockopt(1 2e 80d1000 af) on fd 255 [1:5:1]
[main] Setsockopt(1 9 80d1000 58) on fd 257 [3:3:60]
[main] Setsockopt(1 1 80d1000 fb) on fd 258 [4:2:175]
[main] Setsockopt(1 2e 80d1000 12) on fd 259 [5:2:0]
[main] Setsockopt(1 24 80d1000 1c) on fd 260 [8:2:199]
[main] Setsockopt(0 22 80d1000 4) on fd 261 [10:2:17]
[main] Setsockopt(1 2f 80d1000 7b) on fd 262 [12:5:2]
[main] Setsockopt(1 d 80d1000 8) on fd 263 [16:3:0]
[main] Setsockopt(107 11 80d1000 4) on fd 264 [17:3:768]
[main] Setsockopt(1 6 80d1000 4) on fd 265 [23:1:140]
[main] Setsockopt(6 b 0 4) on fd 266 [30:1:0]
[main] Setsockopt(1 a 80d1000 17) on fd 268 [1:2:1]
[main] Setsockopt(1 c 80d1000 4) on fd 269 [2:3:196]
[main] Setsockopt(1 9 80d1000 4) on fd 270 [3:3:196]
[main] Setsockopt(100 1 80d1000 4) on fd 271 [4:2:184]
[main] Setsockopt(1 20 80d1000 4) on fd 273 [8:3:147]
[main] Setsockopt(10a b 80d1000 4) on fd 275 [12:1:224]
[main] Setsockopt(1 b 80d1000 4) on fd 277 [20:5:84]
[main] Setsockopt(1 a 80d1000 55) on fd 278 [23:1:42]
[main] Setsockopt(1 20 80d1000 e2) on fd 280 [39:5:0]
[main] Setsockopt(1 d 80d1000 8) on fd 281 [1:2:1]
[main] Setsockopt(6 8 80d1000 83) on fd 282 [2:1:6]
[main] Setsockopt(1 21 80d1000 91) on fd 283 [3:3:6]
[main] Setsockopt(1 b 80d1000 57) on fd 284 [4:2:35]
[main] Setsockopt(1 1d 80d1000 4) on fd 285 [5:2:0]
[main] Setsockopt(11 1 80d1000 4) on fd 287 [10:2:17]
[main] Setsockopt(84 b 80d1000 4) on fd 288 [12:1:85]
[main] Setsockopt(1 28 80d1000 f1) on fd 290 [20:10:107]
[main] Setsockopt(6 101 0 2d) on fd 292 [30:1:0]
[main] Setsockopt(1 6 80d1000 4) on fd 293 [39:5:0]
[main] Setsockopt(1 2d 80d1000 23) on fd 294 [1:5:1]
[main] Setsockopt(88 1 80d1000 4) on fd 295 [2:2:17]
[main] Setsockopt(1 b 80d1000 4) on fd 297 [4:2:87]
[main] Setsockopt(1 8 80d1000 8f) on fd 298 [5:3:190]
[main] Setsockopt(1 22 80d1000 4) on fd 299 [8:2:67]
[main] Setsockopt(0 13 80d1000 4) on fd 300 [10:1:0]
[main] Setsockopt(10d d 80d1000 4) on fd 301 [12:1:218]
[main] Setsockopt(1 c 80d1000 67) on fd 302 [17:10:768]
[main] Setsockopt(1 1 80d1000 4) on fd 303 [20:5:23]
[main] Setsockopt(1 2f 80d1000 4) on fd 304 [23:5:118]
[main] Setsockopt(6 f 0 4) on fd 305 [30:1:0]
[main] Setsockopt(1 f 80d1000 1a) on fd 306 [39:1:1]
[main] Setsockopt(6 a 80d1000 4) on fd 308 [2:1:6]
[main] Setsockopt(1 2f 80d1000 92) on fd 309 [3:5:206]
[main] Setsockopt(1 2d 80d1000 9) on fd 311 [5:2:0]
[main] Setsockopt(1 21 80d1000 4) on fd 312 [8:4:111]
[main] Setsockopt(11 1 80d1000 4) on fd 313 [10:2:17]
[main] Setsockopt(105 c 80d1000 4) on fd 314 [12:1:19]
[main] Setsockopt(1 5 80d1000 2d) on fd 317 [30:2:0]
[main] Setsockopt(1 1 80d1000 4) on fd 319 [1:1:1]
[main] Setsockopt(1 2e 80d1000 4) on fd 320 [2:1:6]
[main] Setsockopt(101 8 80d1000 4) on fd 321 [3:3:6]
[main] Setsockopt(1 1 80d1000 ac) on fd 322 [4:2:13]
[main] Setsockopt(1 2 80d1000 4) on fd 323 [5:3:196]
[main] Setsockopt(29 18 80d1000 d5) on fd 325 [10:3:118]
[main] Setsockopt(1 23 80d1000 55) on fd 326 [12:5:2]
[main] Setsockopt(1 d 80d1000 8) on fd 327 [17:3:768]
[main] Setsockopt(1 a 80d1000 83) on fd 328 [20:3:51]
[main] Setsockopt(1 f 80d1000 b2) on fd 329 [23:2:0]
[main] Setsockopt(1 d 80d1000 8) on fd 331 [39:5:0]
[main] Setsockopt(1 d 80d1000 8) on fd 332 [1:2:1]
[main] Setsockopt(1 7 80d1000 4) on fd 333 [2:1:0]
[main] Setsockopt(101 8 80d1000 1c) on fd 334 [3:5:195]
[main] Setsockopt(1 1 80d1000 4) on fd 335 [4:2:175]
[main] Setsockopt(1 2e 80d1000 b3) on fd 337 [8:3:146]
[main] Setsockopt(1 b 80d1000 dd) on fd 338 [10:3:247]
[main] Setsockopt(1 2d 80d1000 4) on fd 340 [16:3:0]
[main] Setsockopt(1 7 80d1000 32) on fd 342 [20:5:65]
[main] Setsockopt(6 10 0 4) on fd 343 [30:1:0]
[main] Setsockopt(0 13 80d1000 4) on fd 346 [2:1:0]
[main] Setsockopt(100 1 80d1000 4) on fd 348 [4:2:95]
[main] Setsockopt(1 22 80d1000 6c) on fd 349 [5:3:7]
[main] Setsockopt(1 2e 80d1000 be) on fd 351 [12:5:2]
[main] Setsockopt(108 42000004 80d1000 4) on fd 353 [20:10:192]
[main] Setsockopt(1 2e 80d1000 e) on fd 354 [23:5:70]
[   70.833924] irttp_open_tsap(), invalid tsap!
[   70.834120] irda_open_tsap(), Unable to allocate TSAP!
[   70.836077] irias_delete_object(), object already removed!
[main] Setsockopt(6 7 80d1000 4e) on fd 355 [30:1:0]
[main] Setsockopt(1 d 80d1000 8) on fd 356 [39:2:1]
[main] Setsockopt(1 5 80d1000 4) on fd 357 [1:5:1]
[main] Setsockopt(88 1 80d1000 4d) on fd 358 [2:2:0]
[main] Setsockopt(101 7 80d1000 f3) on fd 359 [3:2:0]
[main] Setsockopt(100 1 80d1000 4) on fd 360 [4:2:244]
[main] Setsockopt(1 23 80d1000 7) on fd 361 [5:3:61]
[main] Setsockopt(29 3 80d1000 f3) on fd 363 [10:2:0]
[main] Setsockopt(1 2 80d1000 4) on fd 365 [17:3:768]
[main] Setsockopt(1 1d 80d1000 4) on fd 366 [23:5:136]
[main] Setsockopt(0 14 80d1000 4) on fd 370 [2:3:243]
[main] Setsockopt(100 1 80d1000 4) on fd 372 [4:2:126]
[main] Setsockopt(1 2f 80d1000 4) on fd 373 [5:3:186]
[main] Setsockopt(1 c 80d1000 4) on fd 374 [10:3:159]
[main] Setsockopt(10e 4 80d1000 4) on fd 376 [16:3:4]
[main] Setsockopt(1 7 80d1000 f8) on fd 378 [23:5:206]
[main] Setsockopt(1 b 80d1000 4) on fd 379 [30:2:0]
[main] created 375 sockets
[main] Setsockopt(1 2e 80d1000 4) on fd 7 [2:3:38]
[main] Setsockopt(101 a 80d1000 c6) on fd 8 [3:2:0]
[main] Setsockopt(100 1 80d1000 4) on fd 9 [4:2:82]
[main] Setsockopt(1 5 80d1000 4) on fd 10 [5:2:0]
[main] Setsockopt(29 4 80d1000 4) on fd 12 [10:3:46]
[main] Setsockopt(1 6 80d1000 8d) on fd 13 [12:5:2]
[main] Setsockopt(1 28 80d1000 4) on fd 14 [16:3:0]
[main] Setsockopt(1 6 80d1000 2e) on fd 18 [30:5:0]
[main] Setsockopt(1 1d 80d1000 28) on fd 19 [39:5:0]
[main] Setsockopt(11 1 80d1000 4) on fd 21 [2:2:17]
[main] Setsockopt(101 c 80d1000 46) on fd 22 [3:5:202]
[main] Setsockopt(1 29 80d1000 4) on fd 23 [4:2:186]
[main] Setsockopt(88 1 80d1000 4) on fd 26 [10:2:0]
[main] Setsockopt(0 c 80d1000 4) on fd 27 [12:1:177]
[main] Setsockopt(1 b 80d1000 4) on fd 28 [17:2:768]
[main] Setsockopt(1 b 80d1000 42) on fd 29 [23:1:125]
[main] Setsockopt(1 23 80d1000 4) on fd 30 [30:2:0]
[main] Setsockopt(1 23 80d1000 f5) on fd 31 [39:5:0]
[main] Setsockopt(1 8 80d1000 4) on fd 32 [1:2:1]
[main] Setsockopt(1 24 80d1000 8d) on fd 33 [2:1:6]
[main] Setsockopt(100 1 80d1000 4) on fd 35 [4:2:48]
[main] Setsockopt(6 3 80d1000 4c) on fd 37 [10:1:0]
[main] Setsockopt(1 2 80d1000 69) on fd 38 [12:1:2]
[main] Setsockopt(10e 3 80d1000 37) on fd 39 [16:3:10]
[main] Setsockopt(1 e 80d1000 4) on fd 42 [23:1:173]
[   71.732163] irttp_open_tsap(), invalid tsap!
[   71.732933] irda_open_tsap(), Unable to allocate TSAP!
[   71.733125] irias_delete_object(), object already removed!
[main] Setsockopt(6 1 0 4) on fd 43 [30:1:0]
[main] Setsockopt(1 2e 80d1000 d) on fd 44 [39:2:1]
[main] Setsockopt(1 10 80d1000 4) on fd 45 [1:5:1]
[main] Setsockopt(0 3 80d1000 bf) on fd 46 [2:3:51]
[main] Setsockopt(101 a 80d1000 4) on fd 47 [3:2:0]
[main] Setsockopt(1 1 80d1000 78) on fd 48 [4:2:228]
[main] Setsockopt(1 28 80d1000 4) on fd 49 [5:2:0]
[main] Setsockopt(1 10 80d1000 4) on fd 50 [8:2:132]
[main] Setsockopt(1 6 80d1000 4) on fd 51 [10:1:0]
[main] Setsockopt(641fa9bb d 80d1000 4) on fd 52 [12:5:2]
[main] Setsockopt(10e 4 80d1000 28) on fd 53 [16:2:2]
[main] Setsockopt(1 1 80d1000 80) on fd 54 [17:10:32821]
[main] Setsockopt(1 a 80d1000 4) on fd 55 [20:10:11]
[main] Setsockopt(10a 4 80d1000 3c) on fd 56 [23:5:17]
[main] Setsockopt(1 12 80d1000 f5) on fd 57 [30:2:0]
[main] Setsockopt(1 2a 80d1000 30) on fd 59 [1:5:1]
[main] Setsockopt(1 1 80d1000 a9) on fd 60 [2:3:248]
[main] Setsockopt(1 2b 80d1000 cd) on fd 61 [3:2:0]
[main] Setsockopt(1 c 80d1000 67) on fd 62 [4:2:124]
[main] Setsockopt(1 8 80d1000 4) on fd 65 [10:3:65]
[main] Setsockopt(1 9 80d1000 75) on fd 66 [12:1:251]
[main] Setsockopt(1 28 80d1000 4) on fd 67 [16:2:10]
[main] Setsockopt(1 2d 80d1000 bd) on fd 68 [17:3:768]
[main] Setsockopt(1 7 80d1000 52) on fd 69 [20:4:175]
[main] Setsockopt(1 8 80d1000 69) on fd 70 [30:2:0]
[main] Setsockopt(1 10 80d1000 d8) on fd 71 [39:2:1]
[main] Setsockopt(1 8 80d1000 b8) on fd 72 [1:2:1]
[main] Setsockopt(1 b 80d1000 86) on fd 73 [2:3:156]
[main] Setsockopt(1 e 80d1000 88) on fd 74 [3:3:156]
[main] Setsockopt(1 b 80d1000 4) on fd 75 [4:2:137]
[main] Setsockopt(1 29 80d1000 4) on fd 76 [5:3:216]
[main] Setsockopt(1 5 80d1000 4) on fd 77 [8:3:180]
[main] Setsockopt(29 4 80d1000 48) on fd 78 [10:1:0]
[main] Setsockopt(1 2c 80d1000 cc) on fd 79 [12:1:247]
[main] Setsockopt(1 5 80d1000 f5) on fd 81 [20:5:49]
[main] Setsockopt(1 c 80d1000 4) on fd 82 [23:1:148]
[main] Setsockopt(1 a 80d1000 b2) on fd 85 [1:1:1]
[main] Setsockopt(1 b 80d1000 4) on fd 87 [3:3:17]
[main] Setsockopt(1 29 80d1000 44) on fd 90 [8:4:21]
[main] Setsockopt(0 f 80d1000 1) on fd 91 [10:2:0]
[main] Setsockopt(101 c 80d1000 4) on fd 92 [12:5:2]
[main] Setsockopt(1 d 80d1000 8) on fd 95 [23:1:148]
[main] Setsockopt(1 21 80d1000 41) on fd 97 [39:2:1]
[main] Setsockopt(1 23 80d1000 a5) on fd 98 [1:2:1]
[main] Setsockopt(1 29 80d1000 a5) on fd 100 [3:3:95]
[main] Setsockopt(1 2b 80d1000 45) on fd 102 [5:2:0]
[main] Setsockopt(6 1 80d1000 35) on fd 103 [10:1:0]
[main] Setsockopt(0 d 80d1000 4) on fd 104 [12:1:54]
[main] Setsockopt(10e 3 80d1000 1f) on fd 105 [16:3:4]
[main] Setsockopt(107 f 80d1000 37) on fd 106 [17:3:768]
[main] Setsockopt(1 7 80d1000 26) on fd 112 [3:3:6]
[main] Setsockopt(1 2 80d1000 4) on fd 115 [8:3:222]
[main] Setsockopt(29 b 0 aa) on fd 116 [10:2:0]
[main] Setsockopt(107 c 80d1000 4) on fd 117 [12:1:14]
[main] Setsockopt(1 1 80d1000 4) on fd 120 [23:2:0]
[   73.153228] irttp_open_tsap(), invalid tsap!
[   73.155186] irda_open_tsap(), Unable to allocate TSAP!
[   73.157039] irias_delete_object(), object already removed!
[main] Setsockopt(1 8 80d1000 4) on fd 121 [30:2:0]
[main] Setsockopt(11 1 80d1000 56) on fd 124 [2:2:0]
[main] Setsockopt(101 9 80d1000 4b) on fd 125 [3:5:206]
[main] Setsockopt(1 c 80d1000 4) on fd 126 [4:2:7]
[main] Setsockopt(1 29 80d1000 ab) on fd 128 [10:3:15]
[main] Setsockopt(1 21 80d1000 4) on fd 129 [12:5:2]
[main] Setsockopt(1 2c 80d1000 d2) on fd 130 [16:3:2]
[main] Setsockopt(1 2f 80d1000 29) on fd 131 [17:2:768]
[main] Setsockopt(1 23 80d1000 4) on fd 133 [23:1:220]
[main] Setsockopt(6 e 0 4) on fd 134 [30:1:0]
[main] Setsockopt(1 8 80d1000 4) on fd 141 [8:5:128]
[main] Setsockopt(1 2f 80d1000 4) on fd 142 [10:2:0]
[main] Setsockopt(1 e 80d1000 67) on fd 143 [12:1:77]
[main] Setsockopt(1 f 80d1000 4) on fd 146 [23:1:59]
[main] Setsockopt(6 7 80d1000 0) on fd 147 [30:1:0]
[main] Setsockopt(0 7 80d1000 4) on fd 150 [2:3:252]
[main] Setsockopt(1 2b 80d1000 4) on fd 152 [4:2:153]
[main] Setsockopt(1 d 80d1000 8) on fd 154 [8:10:216]
[main] Setsockopt(11 1 80d1000 4) on fd 155 [10:2:17]
[main] Setsockopt(1 10 80d1000 39) on fd 156 [12:1:162]
[main] Setsockopt(1 c 80d1000 4) on fd 157 [16:2:2]
[main] Setsockopt(1 2c 80d1000 7e) on fd 158 [17:2:768]
[main] Setsockopt(1 1d 80d1000 4) on fd 159 [20:2:247]
[   74.133191] irda_setsockopt: not allowed to set MAXSDUSIZE for this sock=
et type!
[main] Setsockopt(10a a 80d1000 4) on fd 160 [23:5:123]
[main] Setsockopt(1 10 80d1000 a4) on fd 161 [30:1:0]
[main] Setsockopt(1 8 80d1000 4) on fd 164 [2:3:119]
[main] Setsockopt(1 12 80d1000 c0) on fd 166 [4:2:81]
[main] Setsockopt(1 d 80d1000 8) on fd 167 [5:2:0]
[main] Setsockopt(108 42000004 80d1000 4) on fd 168 [8:4:221]
[main] Setsockopt(1 2b 80d1000 a0) on fd 169 [10:3:122]
[main] Setsockopt(1 d 80d1000 8) on fd 172 [20:4:181]
[main] Setsockopt(6 1 0 4) on fd 174 [30:1:0]
[main] Setsockopt(1 2 80d1000 4) on fd 175 [39:1:1]
[main] Setsockopt(1 9 80d1000 b8) on fd 176 [1:1:1]
[main] Setsockopt(6 a 80d1000 4) on fd 177 [2:1:6]
[main] Setsockopt(101 5 80d1000 4) on fd 178 [3:3:6]
[main] Generating file descriptors
[main] Setsockopt(100 1 80d1000 4) on fd 179 [4:2:242]
[main] Setsockopt(1 9 80d1000 4) on fd 181 [8:2:60]
[main] Setsockopt(1 20 80d1000 4) on fd 182 [10:3:230]
[main] Setsockopt(1 2 80d1000 4) on fd 183 [12:5:2]
[main] Setsockopt(1 1 80d1000 4) on fd 184 [16:2:6]
[main] Setsockopt(1 24 80d1000 2e) on fd 185 [17:2:768]
[main] Added 50 filenames from /dev
[main] Added 1 filenames from /proc
[main] Added 1 filenames from /sys
[main] Setsockopt(1 22 80d1000 4) on fd 186 [20:10:188]
[main] Setsockopt(1 d 80d1000 8) on fd 187 [23:2:0]
[   74.589962] irttp_open_tsap(), invalid tsap!
[   74.590880] irda_open_tsap(), Unable to allocate TSAP!
[   74.591172] irias_delete_object(), object already removed!
[main] Setsockopt(6 13 80d1000 d) on fd 188 [30:1:0]
[main] Setsockopt(1 1 80d1000 4) on fd 189 [39:5:0]
[main] Setsockopt(1 c 80d1000 be) on fd 190 [1:2:1]
[main] Setsockopt(1 e 80d1000 4) on fd 191 [2:1:6]
[main] Setsockopt(101 8 80d1000 4) on fd 192 [3:3:6]
[main] Setsockopt(1 c 80d1000 ac) on fd 193 [4:2:87]
[main] Setsockopt(1 2b 80d1000 4) on fd 194 [5:2:0]
[main] Setsockopt(1 28 80d1000 ac) on fd 195 [8:2:216]
[main] Setsockopt(1 1 80d1000 4) on fd 196 [10:2:0]
[main] Setsockopt(88 b 80d1000 4) on fd 197 [12:5:2]
[main] Setsockopt(1 6 80d1000 4) on fd 198 [17:10:24582]
[main] Setsockopt(1 2e 80d1000 4) on fd 199 [20:10:242]
[main] Setsockopt(1 a 80d1000 4) on fd 200 [23:5:72]
[   74.775868] irttp_open_tsap(), invalid tsap!
[   74.776184] irda_open_tsap(), Unable to allocate TSAP!
[   74.778914] irias_delete_object(), object already removed!
[main] Setsockopt(1 1 80d1000 84) on fd 201 [30:5:0]
[main] Setsockopt(1 21 80d1000 4) on fd 202 [39:5:0]
[main] Setsockopt(1 8 80d1000 34) on fd 203 [1:2:1]
[main] Setsockopt(1 2b 80d1000 db) on fd 204 [2:1:0]
[main] Setsockopt(1 5 80d1000 9e) on fd 205 [3:2:0]
[main] Setsockopt(1 5 80d1000 4) on fd 208 [8:5:31]
[main] Setsockopt(1 28 80d1000 b) on fd 209 [10:1:0]
[main] Setsockopt(105 d 80d1000 4) on fd 210 [12:5:2]
[main] Setsockopt(1 10 80d1000 4) on fd 211 [17:2:768]
[main] Setsockopt(108 42000004 80d1000 4) on fd 212 [20:4:116]
[main] Setsockopt(1 5 80d1000 4) on fd 213 [23:5:203]
[main] Setsockopt(1 21 80d1000 15) on fd 214 [30:5:0]
[main] Setsockopt(1 2b 80d1000 4) on fd 215 [39:5:0]
[main] Setsockopt(1 28 80d1000 99) on fd 216 [1:1:1]
[main] Setsockopt(1 2 80d1000 4) on fd 217 [2:3:160]
[main] Setsockopt(1 23 80d1000 4) on fd 218 [3:3:160]
[   75.182026] VFS: Warning: trinity-c0 using old stat() call. Recompile yo=
ur binary.
[main] Setsockopt(100 1 80d1000 4) on fd 219 [4:2:141]
[main] Setsockopt(1 a 80d1000 77) on fd 220 [5:3:168]
[main] Setsockopt(1 f 80d1000 8) on fd 222 [10:1:0]
[main] Setsockopt(1 b 80d1000 3e) on fd 223 [12:1:178]
[main] Setsockopt(10e 3 80d1000 4) on fd 224 [16:3:10]
[main] Setsockopt(107 7 80d1000 4) on fd 225 [17:2:768]
[main] Setsockopt(1 8 80d1000 bf) on fd 226 [20:5:38]
[main] Setsockopt(6 16 0 4) on fd 228 [30:1:0]
[main] Setsockopt(1 9 80d1000 c4) on fd 229 [39:5:0]
[main] Setsockopt(11 1 80d1000 13) on fd 231 [2:2:0]
[child0:211] signalfd (321) returned ENOSYS, marking as inactive.
[main] Setsockopt(1 6 80d1000 30) on fd 232 [3:2:0]
[main] Setsockopt(100 1 80d1000 4) on fd 233 [4:2:16]
[child0:211] delete_module (129) returned ENOSYS, marking as inactive.
[watchdog] Watchdog is alive. (pid:207)
[main] Setsockopt(88 1 80d1000 4) on fd 236 [10:2:0]
[main] Setsockopt(10d d 80d1000 4) on fd 237 [12:5:2]
[child0:211] timerfd_settime (325) returned ENOSYS, marking as inactive.
[main] Setsockopt(107 9 80d1000 4) on fd 238 [17:2:768]
[main] Setsockopt(1 b 80d1000 c) on fd 239 [20:2:94]
[child0:211] bdflush (134) returned ENOSYS, marking as inactive.
[   75.582218] irda_setsockopt: not allowed to set MAXSDUSIZE for this sock=
et type!
[   75.589182] irttp_open_tsap: unable to allocate LSAP!!
[   75.591628] irda_open_tsap(), Unable to allocate TSAP!
[   75.595702] irias_delete_object(), object already removed!
[main] Setsockopt(1 2f 80d1000 70) on fd 241 [30:5:0]
[main] Setsockopt(1 f 80d1000 86) on fd 242 [39:1:1]
[main] Setsockopt(1 2d 80d1000 4) on fd 244 [2:2:17]
[main] Setsockopt(101 4 80d1000 dc) on fd 245 [3:5:206]
[main] Setsockopt(1 28 80d1000 4b) on fd 246 [4:2:207]
[child0:211] finit_module (350) returned ENOSYS, marking as inactive.
[main] Setsockopt(1 8 80d1000 36) on fd 247 [5:3:12]
[main] Setsockopt(1 6 80d1000 4) on fd 248 [8:5:183]
[main] Setsockopt(11 1 80d1000 4) on fd 249 [10:2:17]
[main] Setsockopt(1 d 80d1000 8) on fd 250 [12:1:194]
[main] Setsockopt(107 9 80d1000 49) on fd 251 [17:2:768]
[   75.744042] irttp_open_tsap(), invalid tsap!
[   75.744388] irda_open_tsap(), Unable to allocate TSAP!
[   75.744571] irias_delete_object(), object already removed!
[main] Setsockopt(1 a 80d1000 6b) on fd 254 [39:1:1]
[main] Setsockopt(1 28 80d1000 22) on fd 255 [1:5:1]
[main] Setsockopt(0 1 80d1000 57) on fd 256 [2:3:60]
[main] Setsockopt(1 21 80d1000 51) on fd 257 [3:3:60]
[main] Setsockopt(100 1 80d1000 4) on fd 258 [4:2:175]
[main] Setsockopt(108 42000004 80d1000 4) on fd 260 [8:2:199]
[main] Setsockopt(1 29 80d1000 4) on fd 261 [10:2:17]
[main] Setsockopt(10d d 80d1000 4) on fd 262 [12:5:2]
[main] Setsockopt(1 c 80d1000 4) on fd 263 [16:3:0]
[main] Setsockopt(1 6 80d1000 2e) on fd 264 [17:3:768]
[main] Setsockopt(6 f 0 4) on fd 266 [30:1:0]
[main] Setsockopt(1 2 80d1000 4) on fd 269 [2:3:196]
[main] Setsockopt(1 5 80d1000 aa) on fd 270 [3:3:196]
[main] Setsockopt(100 1 80d1000 4) on fd 271 [4:2:184]
[main] Setsockopt(1 21 80d1000 4) on fd 272 [5:2:0]
[main] Setsockopt(88 b 80d1000 4) on fd 275 [12:1:224]
[main] Setsockopt(1 8 80d1000 4) on fd 278 [23:1:42]
[main] Setsockopt(1 2f 80d1000 4) on fd 279 [30:2:0]
[main] Setsockopt(1 29 80d1000 4) on fd 281 [1:2:1]
[main] Setsockopt(6 5 80d1000 58) on fd 282 [2:1:6]
[main] Setsockopt(1 21 80d1000 1c) on fd 283 [3:3:6]
[main] Setsockopt(1 2d 80d1000 4) on fd 285 [5:2:0]
[main] Setsockopt(29 4 80d1000 4) on fd 287 [10:2:17]
[main] Setsockopt(1 d 80d1000 8) on fd 288 [12:1:85]
[main] Setsockopt(10a a 80d1000 16) on fd 291 [23:1:84]
[   76.089190] irttp_open_tsap(), invalid tsap!
[   76.089938] irda_open_tsap(), Unable to allocate TSAP!
[   76.090133] irias_delete_object(), object already removed!
[main] Setsockopt(6 b 0 32) on fd 292 [30:1:0]
[main] Setsockopt(1 12 80d1000 7c) on fd 294 [1:5:1]
[main] Setsockopt(1 2f 80d1000 4) on fd 295 [2:2:17]
[main] Setsockopt(101 7 80d1000 4) on fd 296 [3:5:240]
[main] Setsockopt(1 10 80d1000 f9) on fd 297 [4:2:87]
[main] Setsockopt(1 6 80d1000 4) on fd 299 [8:2:67]
[main] Setsockopt(1 2f 80d1000 d3) on fd 300 [10:1:0]
[main] Setsockopt(1 a 80d1000 4) on fd 301 [12:1:218]
[main] Setsockopt(1 1 80d1000 4) on fd 304 [23:5:118]
[main] Setsockopt(1 1d 80d1000 ec) on fd 305 [30:1:0]
[main] Setsockopt(6 1 80d1000 75) on fd 308 [2:1:6]
[main] Setsockopt(101 5 80d1000 4) on fd 309 [3:5:206]
[main] Setsockopt(100 1 80d1000 4) on fd 310 [4:2:53]
[main] Setsockopt(1 24 80d1000 41) on fd 312 [8:4:111]
[main] Setsockopt(0 12 80d1000 4) on fd 313 [10:2:17]
[main] Setsockopt(1 2d 80d1000 1b) on fd 314 [12:1:19]
[main] Setsockopt(1 29 80d1000 42) on fd 315 [17:2:768]
[main] Setsockopt(1 b 80d1000 3d) on fd 316 [23:5:74]
[   76.321851] irttp_open_tsap(), invalid tsap!
[   76.322042] irda_open_tsap(), Unable to allocate TSAP!
[   76.322221] irias_delete_object(), object already removed!
[main] Setsockopt(1 29 80d1000 4) on fd 318 [39:5:0]
[main] Setsockopt(1 a 80d1000 6b) on fd 320 [2:1:6]
[main] Setsockopt(101 5 80d1000 26) on fd 321 [3:3:6]
[main] Setsockopt(1 8 80d1000 c2) on fd 323 [5:3:196]
[main] Setsockopt(1 1d 80d1000 a4) on fd 324 [8:3:130]
[main] Setsockopt(1 23 80d1000 e) on fd 325 [10:3:118]
[main] Setsockopt(88 b 80d1000 4) on fd 326 [12:5:2]
[main] Setsockopt(1 f 80d1000 b) on fd 327 [17:3:768]
[main] Setsockopt(1 20 80d1000 d7) on fd 328 [20:3:51]
[   76.472914] irttp_open_tsap(), invalid tsap!
[   76.473138] irda_open_tsap(), Unable to allocate TSAP!
[   76.473459] irias_delete_object(), object already removed!
[main] Setsockopt(1 22 80d1000 38) on fd 332 [1:2:1]
[main] Setsockopt(1 e 80d1000 65) on fd 333 [2:1:0]
[main] Setsockopt(100 1 80d1000 4) on fd 335 [4:2:175]
[main] Setsockopt(1 6 80d1000 4) on fd 336 [5:3:250]
[main] Setsockopt(1 8 80d1000 4) on fd 338 [10:3:247]
[main] Setsockopt(1 10 80d1000 c6) on fd 339 [12:1:184]
[main] Setsockopt(1 5 80d1000 63) on fd 340 [16:3:0]
[main] Setsockopt(1 2 80d1000 e4) on fd 342 [20:5:65]
[main] Setsockopt(1 2 80d1000 4) on fd 343 [30:1:0]
[main] Setsockopt(1 29 80d1000 28) on fd 344 [39:5:0]
[main] Setsockopt(1 1d 80d1000 bd) on fd 345 [1:5:1]
[main] Setsockopt(6 1 80d1000 4) on fd 346 [2:1:0]
[main] Setsockopt(1 e 80d1000 4) on fd 347 [3:3:0]
[main] Setsockopt(1 a 80d1000 4) on fd 348 [4:2:95]
[main] Setsockopt(1 2c 80d1000 4) on fd 350 [10:1:0]
[main] Setsockopt(1 10 80d1000 4) on fd 352 [17:2:768]
[main] Setsockopt(1 d 80d1000 8) on fd 353 [20:10:192]
[child0:211] set_mempolicy (276) returned ENOSYS, marking as inactive.
[main] Setsockopt(6 5 0 70) on fd 355 [30:1:0]
[main] Setsockopt(1 6 80d1000 4) on fd 357 [1:5:1]
[main] Setsockopt(11 1 80d1000 ac) on fd 358 [2:2:0]
[main] Setsockopt(1 24 80d1000 4) on fd 359 [3:2:0]
[main] Setsockopt(100 1 80d1000 4) on fd 360 [4:2:244]
[main] Setsockopt(1 23 80d1000 d5) on fd 361 [5:3:61]
[child0:211] mq_notify (281) returned ENOSYS, marking as inactive.
[main] Setsockopt(1 7 80d1000 99) on fd 362 [8:3:240]
[main] Setsockopt(88 1 80d1000 38) on fd 363 [10:2:0]
[main] Setsockopt(113 b 80d1000 4) on fd 364 [12:5:2]
[main] Setsockopt(1 10 80d1000 4) on fd 365 [17:3:768]
[   76.858995] irttp_open_tsap(), invalid tsap!
[   76.859169] irda_open_tsap(), Unable to allocate TSAP!
[   76.861491] irias_delete_object(), object already removed!
[main] Setsockopt(1 2f 80d1000 98) on fd 366 [23:5:136]
[main] Setsockopt(1 22 80d1000 4) on fd 369 [1:1:1]
[main] Setsockopt(1 22 80d1000 4e) on fd 370 [2:3:243]
[main] Setsockopt(1 28 80d1000 4) on fd 371 [3:2:0]
[main] Setsockopt(100 1 80d1000 4) on fd 372 [4:2:126]
[main] Setsockopt(29 17 0 52) on fd 374 [10:3:159]
[main] Setsockopt(105 b 80d1000 4) on fd 375 [12:5:2]
[main] Setsockopt(10e 3 80d1000 4) on fd 376 [16:3:4]
[main] Setsockopt(1 c 80d1000 4) on fd 377 [17:3:768]
[   76.943120] irttp_open_tsap(), invalid tsap!
[main] Setsockopt(1 2b 80d1000 4) on fd 378 [23:5:206]
[   76.948606] irda_open_tsap(), Unable to allocate TSAP!
[   76.949573] irias_delete_object(), object already removed!
[main] Setsockopt(1 6 80d1000 2a) on fd 379 [30:2:0]
[main] 375 sockets created based on info from socket cachefile.
[child0:211] process_vm_writev (348) returned ENOSYS, marking as inactive.
[child0:211] io_getevents (247) returned ENOSYS, marking as inactive.
[child0:211] lookup_dcookie (253) returned ENOSYS, marking as inactive.
[child0:211] process_vm_readv (347) returned ENOSYS, marking as inactive.
[child0:211] move_pages (317) returned ENOSYS, marking as inactive.
*** glibc detected *** /trinity: free(): invalid pointer: 0x08666000 ***
[main] Random reseed: 891785912
[child0:212] uid changed! Was: 0, now 6051057
Bailing main loop. Exit reason: UID changed.
[main] Generating file descriptors
[main] Added 47 filenames from /dev
[main] Added 1 filenames from /proc
[main] Added 1 filenames from /sys
[child0:213] kexec_load (283) returned ENOSYS, marking as inactive.
[child0:213] timerfd_gettime (326) returned ENOSYS, marking as inactive.
[child0:213] mq_open (277) returned ENOSYS, marking as inactive.
[child0:213] uid changed! Was: 0, now 229
Bailing main loop. Exit reason: UID changed.
[watchdog] [209] Watchdog exiting
[init]=20
Ran 16 syscalls. Successes: 4  Failures: 12
[watchdog] [207] Watchdog exiting
[init]=20
Ran 100 syscalls. Successes: 31  Failures: 68
[  100.781324] spin_lock-torture: Writes:  Total: 4  Max/Min: 0/0   Fail: 0=
=20
lsmod: can't open '/proc/modules': No such file or directory
BusyBox v1.19.4 (2012-04-22 09:22:10 PDT) multi-call binary.

Usage: rmmod [-wfa] [MODULE]...

lsmod: can't open '/proc/modules': No such file or directory
BusyBox v1.19.4 (2012-04-22 09:22:10 PDT) multi-call binary.

Usage: rmmod [-wfa] [MODULE]...

lsmod: can't open '/proc/modules': No such file or directory
BusyBox v1.19.4 (2012-04-22 09:22:10 PDT) multi-call binary.

Usage: rmmod [-wfa] [MODULE]...

run-parts: /etc/kernel-tests/99-rmmod exited with code 123
shutdown: warning: cannot open /var/run/shutdown.pid


mount: no /proc/mounts
wfg: skip syslogd
sed: /proc/mounts: No such file or directory
sed: /proc/mounts: No such file or directory
sed: /proc/mounts: No such file or directory
Deconfiguring network interfaces... ifdown: interface lo not configured
done.
Sending all processes the TERM signal...
mount: mounting proc on /proc failed: No such device
killall5[245]: mount returned non-zero exit status
killall5[245]: /proc not mounted, failed to mount.
Sending all processes the KILL signal...
mount: mounting proc on /proc failed: No such device
killall5[248]: mount returned non-zero exit status
killall5[248]: /proc not mounted, failed to mount.
Unmounting remote filesystems...
Deactivating swap...
Unmounting local filesystems...
grep: /proc/mounts: No such file or directory
mount: can't read '/proc/mounts': No such file or directory
Rebooting...=20
[  130.836575] spin_lock-torture: Unscheduled system shutdown detected
[  130.841573] torture thread torture_shuffle parking due to system shutdown
[  130.863209] reboot: Restarting system
[  130.864054] reboot: machine restart
Elapsed time: 140
qemu-system-x86_64 -cpu qemu64,+smep,+smap -kernel /kernel/i386-randconfig-=
x4-02212316/faa2e6fb0a98c9caa8995acf3222db9f7f029395/vmlinuz-3.14.0-rc3-nex=
t-20140221-04488-gfaa2e6f -append 'hung_task_panic=3D1 earlyprintk=3DttyS0,=
115200 debug apic=3Ddebug sysrq_always_enabled panic=3D10 softlockup_panic=
=3D1 nmi_watchdog=3Dpanic  prompt_ramdisk=3D0 console=3DttyS0,115200 consol=
e=3Dtty0 vga=3Dnormal  root=3D/dev/ram0 rw link=3D/kernel-tests/run-queue/k=
vm/i386-randconfig-x4-02212316/next:master/.vmlinuz-faa2e6fb0a98c9caa8995ac=
f3222db9f7f029395-20140222001515-4-roam branch=3Dnext/master BOOT_IMAGE=3D/=
kernel/i386-randconfig-x4-02212316/faa2e6fb0a98c9caa8995acf3222db9f7f029395=
/vmlinuz-3.14.0-rc3-next-20140221-04488-gfaa2e6f'  -initrd /kernel-tests/in=
itrd/yocto-minimal-i386.cgz -m 320 -smp 2 -net nic,vlan=3D1,model=3De1000 -=
net user,vlan=3D1,hostfwd=3Dtcp::36096-:22 -boot order=3Dnc -no-reboot -wat=
chdog i6300esb -rtc base=3Dlocaltime -drive file=3D/fs/LABEL=3DKVM/disk0-yo=
cto-roam-17,media=3Ddisk,if=3Dvirtio -drive file=3D/fs/LABEL=3DKVM/disk1-yo=
cto-roam-17,media=3Ddisk,if=3Dvirtio -drive file=3D/fs/LABEL=3DKVM/disk2-yo=
cto-roam-17,media=3Ddisk,if=3Dvirtio -drive file=3D/fs/LABEL=3DKVM/disk3-yo=
cto-roam-17,media=3Ddisk,if=3Dvirtio -drive file=3D/fs/LABEL=3DKVM/disk4-yo=
cto-roam-17,media=3Ddisk,if=3Dvirtio -drive file=3D/fs/LABEL=3DKVM/disk5-yo=
cto-roam-17,media=3Ddisk,if=3Dvirtio -pidfile /dev/shm/kboot/pid-yocto-roam=
-17 -serial file:/dev/shm/kboot/serial-yocto-roam-17 -daemonize -display no=
ne -monitor null=20

--ikeVEW9yuYc//A+q
Content-Type: application/octet-stream
Content-Disposition: attachment; filename="i386-randconfig-x4-02212316-faa2e6fb0a98c9caa8995acf3222db9f7f029395-WARNING:---at----init_amd+-x-79798.log"
Content-Transfer-Encoding: base64

Z2l0IGNoZWNrb3V0IDUwNDdhNWIyMzFhMjRiMTVkMDY5NThjZWZiNTQ4NThkNzdkZWJkMjIK
bHMgLWEgL2tlcm5lbC10ZXN0cy9ydW4tcXVldWUva3ZtL2kzODYtcmFuZGNvbmZpZy14NC0w
MjIxMjMxNi9uZXh0Om1hc3Rlcjo1MDQ3YTViMjMxYTI0YjE1ZDA2OTU4Y2VmYjU0ODU4ZDc3
ZGViZDIyOmJpc2VjdC1uZXQKIFRFU1QgRkFJTFVSRQpbICAgIDAuMDA4MDAwXSBJbml0aWFs
aXppbmcgQ1BVIzEKWyAgICAwLjAwODAwMF0gbWFza2VkIEV4dElOVCBvbiBDUFUjMQpbICAg
IDAuMDA4MDAwXSAtLS0tLS0tLS0tLS1bIGN1dCBoZXJlIF0tLS0tLS0tLS0tLS0KWyAgICAw
LjAwODAwMF0gV0FSTklORzogQ1BVOiAxIFBJRDogMCBhdCAva2VybmVsLXRlc3RzL2xpbnV4
Mi9hcmNoL3g4Ni9rZXJuZWwvY3B1L2FtZC5jOjIyMCBpbml0X2FtZCsweDc2Mi8weDc5MCgp
Ci9rZXJuZWwvaTM4Ni1yYW5kY29uZmlnLXg0LTAyMjEyMzE2LzUwNDdhNWIyMzFhMjRiMTVk
MDY5NThjZWZiNTQ4NThkNzdkZWJkMjIvZG1lc2cteW9jdG8tcm9hbS0zMjoyMDE0MDIyMjE0
MDM1NzppMzg2LXJhbmRjb25maWcteDQtMDIyMTIzMTY6My4xNC4wLXJjMy0wNDIyMy1nNTA0
N2E1YjoxNjgKL2tlcm5lbC9pMzg2LXJhbmRjb25maWcteDQtMDIyMTIzMTYvNTA0N2E1YjIz
MWEyNGIxNWQwNjk1OGNlZmI1NDg1OGQ3N2RlYmQyMi9kbWVzZy1xdWFudGFsLXJvYW0tMzk6
MjAxNDAyMjIxNDAwNDA6aTM4Ni1yYW5kY29uZmlnLXg0LTAyMjEyMzE2OjMuMTQuMC1yYzMt
MDQyMjMtZzUwNDdhNWI6MTY4Ci9rZXJuZWwvaTM4Ni1yYW5kY29uZmlnLXg0LTAyMjEyMzE2
LzUwNDdhNWIyMzFhMjRiMTVkMDY5NThjZWZiNTQ4NThkNzdkZWJkMjIvZG1lc2cteW9jdG8t
cm9hbS01MjoyMDE0MDIyMjE0MDUxMzppMzg2LXJhbmRjb25maWcteDQtMDIyMTIzMTY6My4x
NC4wLXJjMy0wNDIyMy1nNTA0N2E1YjoxNjgKL2tlcm5lbC9pMzg2LXJhbmRjb25maWcteDQt
MDIyMTIzMTYvNTA0N2E1YjIzMWEyNGIxNWQwNjk1OGNlZmI1NDg1OGQ3N2RlYmQyMi9kbWVz
Zy15b2N0by1yb2FtLTU5OjIwMTQwMjIyMTQwMTM5OmkzODYtcmFuZGNvbmZpZy14NC0wMjIx
MjMxNjozLjE0LjAtcmMzLTA0MjIzLWc1MDQ3YTViOjE2OAova2VybmVsL2kzODYtcmFuZGNv
bmZpZy14NC0wMjIxMjMxNi81MDQ3YTViMjMxYTI0YjE1ZDA2OTU4Y2VmYjU0ODU4ZDc3ZGVi
ZDIyL2RtZXNnLXlvY3RvLXJvYW0tNTk6MjAxNDAyMjIxNDEyMjc6aTM4Ni1yYW5kY29uZmln
LXg0LTAyMjEyMzE2OjMuMTQuMC1yYzMtMDQyMjMtZzUwNDdhNWI6MTY4Ci9rZXJuZWwvaTM4
Ni1yYW5kY29uZmlnLXg0LTAyMjEyMzE2LzUwNDdhNWIyMzFhMjRiMTVkMDY5NThjZWZiNTQ4
NThkNzdkZWJkMjIvZG1lc2cteW9jdG8tcm9hbS0yMDoyMDE0MDIyMjE0MDAzNTppMzg2LXJh
bmRjb25maWcteDQtMDIyMTIzMTY6My4xNC4wLXJjMy0wNDIyMy1nNTA0N2E1YjoxNjgKL2tl
cm5lbC9pMzg2LXJhbmRjb25maWcteDQtMDIyMTIzMTYvNTA0N2E1YjIzMWEyNGIxNWQwNjk1
OGNlZmI1NDg1OGQ3N2RlYmQyMi9kbWVzZy15b2N0by1yb2FtLTQ3OjIwMTQwMjIyMTQwMTM5
OmkzODYtcmFuZGNvbmZpZy14NC0wMjIxMjMxNjozLjE0LjAtcmMzLTA0MjIzLWc1MDQ3YTVi
OjE2OAova2VybmVsL2kzODYtcmFuZGNvbmZpZy14NC0wMjIxMjMxNi81MDQ3YTViMjMxYTI0
YjE1ZDA2OTU4Y2VmYjU0ODU4ZDc3ZGViZDIyL2RtZXNnLXlvY3RvLXdhaW1lYS02OjIwMTQw
MjIyMTM1MzIyOmkzODYtcmFuZGNvbmZpZy14NC0wMjIxMjMxNjozLjE0LjAtcmMzLTA0MjIz
LWc1MDQ3YTViOjE2OAoxMzo4OjEwIGFsbF9nb29kOmJhZDphbGxfYmFkIGJvb3RzChtbMTsz
NW0yMDE0LTAzLTAxIDA1OjQ2OjEwIFJFUEVBVCBDT1VOVDogMzggICMgL2NjL3dmZy9uZXQt
YmlzZWN0Ly5yZXBlYXQbWzBtCgpiaXNlY3Q6IGJhZCBjb21taXQgNTA0N2E1YjIzMWEyNGIx
NWQwNjk1OGNlZmI1NDg1OGQ3N2RlYmQyMgpnaXQgY2hlY2tvdXQgdjMuMTMKbHMgLWEgL2tl
cm5lbC10ZXN0cy9ydW4tcXVldWUva3ZtL2kzODYtcmFuZGNvbmZpZy14NC0wMjIxMjMxNi9u
ZXh0Om1hc3RlcjpkOGVjMjZkN2Y4Mjg3ZjU3ODhhNDk0ZjU2ZTg4MTQyMTBmMGU2NGJlOmJp
c2VjdC1uZXQKIFRFU1QgRkFJTFVSRQpbICAgIDAuMDE0MDAwXSBJbml0aWFsaXppbmcgQ1BV
IzEKWyAgICAwLjAxNDAwMF0gbWFza2VkIEV4dElOVCBvbiBDUFUjMQpbICAgIDAuMDE0MDAw
XSAtLS0tLS0tLS0tLS1bIGN1dCBoZXJlIF0tLS0tLS0tLS0tLS0KWyAgICAwLjAxNDAwMF0g
V0FSTklORzogQ1BVOiAxIFBJRDogMCBhdCAva2VybmVsLXRlc3RzL2xpbnV4Mi9hcmNoL3g4
Ni9rZXJuZWwvY3B1L2FtZC5jOjIyMSBpbml0X2FtZCsweDc2Mi8weDc5MCgpCi9rZXJuZWwv
aTM4Ni1yYW5kY29uZmlnLXg0LTAyMjEyMzE2L2Q4ZWMyNmQ3ZjgyODdmNTc4OGE0OTRmNTZl
ODgxNDIxMGYwZTY0YmUvZG1lc2cteW9jdG8tcm9hbS0yNToyMDE0MDIyMjE0MDQyMjppMzg2
LXJhbmRjb25maWcteDQtMDIyMTIzMTY6My4xMy4wOjE2OQova2VybmVsL2kzODYtcmFuZGNv
bmZpZy14NC0wMjIxMjMxNi9kOGVjMjZkN2Y4Mjg3ZjU3ODhhNDk0ZjU2ZTg4MTQyMTBmMGU2
NGJlL2RtZXNnLXF1YW50YWwtcm9hbS0zNToyMDE0MDIyMjE0MDUzMDppMzg2LXJhbmRjb25m
aWcteDQtMDIyMTIzMTY6My4xMy4wOjE2OQova2VybmVsL2kzODYtcmFuZGNvbmZpZy14NC0w
MjIxMjMxNi9kOGVjMjZkN2Y4Mjg3ZjU3ODhhNDk0ZjU2ZTg4MTQyMTBmMGU2NGJlL2RtZXNn
LXlvY3RvLXJvYW0tNjM6MjAxNDAyMjIxNDA0Mjc6aTM4Ni1yYW5kY29uZmlnLXg0LTAyMjEy
MzE2OjMuMTMuMDoxNjkKL2tlcm5lbC9pMzg2LXJhbmRjb25maWcteDQtMDIyMTIzMTYvZDhl
YzI2ZDdmODI4N2Y1Nzg4YTQ5NGY1NmU4ODE0MjEwZjBlNjRiZS9kbWVzZy15b2N0by1yb2Ft
LTY6MjAxNDAyMjIxNDA0MjI6aTM4Ni1yYW5kY29uZmlnLXg0LTAyMjEyMzE2OjMuMTMuMDox
NjkKL2tlcm5lbC9pMzg2LXJhbmRjb25maWcteDQtMDIyMTIzMTYvZDhlYzI2ZDdmODI4N2Y1
Nzg4YTQ5NGY1NmU4ODE0MjEwZjBlNjRiZS9kbWVzZy1xdWFudGFsLXJvYW0tODoyMDE0MDIy
MjE0MDUwMzppMzg2LXJhbmRjb25maWcteDQtMDIyMTIzMTY6My4xMy4wOjE2OQova2VybmVs
L2kzODYtcmFuZGNvbmZpZy14NC0wMjIxMjMxNi9kOGVjMjZkN2Y4Mjg3ZjU3ODhhNDk0ZjU2
ZTg4MTQyMTBmMGU2NGJlL2RtZXNnLXF1YW50YWwtcm9hbS01MjoyMDE0MDIyMjE0MDUzMDpp
Mzg2LXJhbmRjb25maWcteDQtMDIyMTIzMTY6My4xMy4wOjE2OQova2VybmVsL2kzODYtcmFu
ZGNvbmZpZy14NC0wMjIxMjMxNi9kOGVjMjZkN2Y4Mjg3ZjU3ODhhNDk0ZjU2ZTg4MTQyMTBm
MGU2NGJlL2RtZXNnLXF1YW50YWwtcm9hbS05OjIwMTQwMjIyMTQwMTUxOmkzODYtcmFuZGNv
bmZpZy14NC0wMjIxMjMxNjozLjEzLjA6MTY5CjE2Ojc6NyBhbGxfZ29vZDpiYWQ6YWxsX2Jh
ZCBib290cwobWzE7MzVtMjAxNC0wMy0wMSAwNTo0NjoxNiBSRVBFQVQgQ09VTlQ6IDQyICAj
IC9jYy93ZmcvbmV0LWJpc2VjdC8ucmVwZWF0G1swbQoKYmlzZWN0OiBiYWQgY29tbWl0IHYz
LjEzCmdpdCBjaGVja291dCB2My4xMgpscyAtYSAva2VybmVsLXRlc3RzL3J1bi1xdWV1ZS9r
dm0vaTM4Ni1yYW5kY29uZmlnLXg0LTAyMjEyMzE2L25leHQ6bWFzdGVyOjVlMDFkYzdiMjZk
OWYyNGYzOWFiYWNlNWRhOThjY2JkNmE1Y2ViNTI6YmlzZWN0LW5ldAogVEVTVCBGQUlMVVJF
ClsgICAgMC4wMDYwMDBdIEluaXRpYWxpemluZyBDUFUjMQpbICAgIDAuMDA2MDAwXSBtYXNr
ZWQgRXh0SU5UIG9uIENQVSMxClsgICAgMC4wMDYwMDBdIC0tLS0tLS0tLS0tLVsgY3V0IGhl
cmUgXS0tLS0tLS0tLS0tLQpbICAgIDAuMDA2MDAwXSBXQVJOSU5HOiBDUFU6IDEgUElEOiAw
IGF0IC9rZXJuZWwtdGVzdHMvbGludXgyL2FyY2gveDg2L2tlcm5lbC9jcHUvYW1kLmM6MjIx
IGluaXRfYW1kKzB4NzYyLzB4NzkwKCkKL2tlcm5lbC9pMzg2LXJhbmRjb25maWcteDQtMDIy
MTIzMTYvNWUwMWRjN2IyNmQ5ZjI0ZjM5YWJhY2U1ZGE5OGNjYmQ2YTVjZWI1Mi9kbWVzZy15
b2N0by1yb2FtLTk6MjAxNDAyMjIxNDE3NDM6aTM4Ni1yYW5kY29uZmlnLXg0LTAyMjEyMzE2
OjMuMTIuMDoxNzAKL2tlcm5lbC9pMzg2LXJhbmRjb25maWcteDQtMDIyMTIzMTYvNWUwMWRj
N2IyNmQ5ZjI0ZjM5YWJhY2U1ZGE5OGNjYmQ2YTVjZWI1Mi9kbWVzZy15b2N0by13YWltZWEt
NjoyMDE0MDIyMjE0MTYwNjppMzg2LXJhbmRjb25maWcteDQtMDIyMTIzMTY6My4xMi4wOjE3
MAova2VybmVsL2kzODYtcmFuZGNvbmZpZy14NC0wMjIxMjMxNi81ZTAxZGM3YjI2ZDlmMjRm
MzlhYmFjZTVkYTk4Y2NiZDZhNWNlYjUyL2RtZXNnLXlvY3RvLXJvYW0tNTQ6MjAxNDAyMjIx
NDE3NDk6aTM4Ni1yYW5kY29uZmlnLXg0LTAyMjEyMzE2OjMuMTIuMDoxNzAKL2tlcm5lbC9p
Mzg2LXJhbmRjb25maWcteDQtMDIyMTIzMTYvNWUwMWRjN2IyNmQ5ZjI0ZjM5YWJhY2U1ZGE5
OGNjYmQ2YTVjZWI1Mi9kbWVzZy1xdWFudGFsLXJvYW0tNjA6MjAxNDAyMjIxNDI4NDU6aTM4
Ni1yYW5kY29uZmlnLXg0LTAyMjEyMzE2OjMuMTIuMDoxNzAKL2tlcm5lbC9pMzg2LXJhbmRj
b25maWcteDQtMDIyMTIzMTYvNWUwMWRjN2IyNmQ5ZjI0ZjM5YWJhY2U1ZGE5OGNjYmQ2YTVj
ZWI1Mi9kbWVzZy1xdWFudGFsLXJvYW0tMjQ6MjAxNDAyMjMwMTE3MTM6aTM4Ni1yYW5kY29u
ZmlnLXg0LTAyMjEyMzE2OjMuMTIuMDoxNzAKL2tlcm5lbC9pMzg2LXJhbmRjb25maWcteDQt
MDIyMTIzMTYvNWUwMWRjN2IyNmQ5ZjI0ZjM5YWJhY2U1ZGE5OGNjYmQ2YTVjZWI1Mi9kbWVz
Zy1xdWFudGFsLXJvYW0tMjI6MjAxNDAyMjIxNDE1NDM6aTM4Ni1yYW5kY29uZmlnLXg0LTAy
MjEyMzE2OjMuMTIuMDoxNzAKL2tlcm5lbC9pMzg2LXJhbmRjb25maWcteDQtMDIyMTIzMTYv
NWUwMWRjN2IyNmQ5ZjI0ZjM5YWJhY2U1ZGE5OGNjYmQ2YTVjZWI1Mi9kbWVzZy1xdWFudGFs
LXdhaW1lYS0xMDoyMDE0MDIyMjE0MTcxMzppMzg2LXJhbmRjb25maWcteDQtMDIyMTIzMTY6
My4xMi4wOjE3MAova2VybmVsL2kzODYtcmFuZGNvbmZpZy14NC0wMjIxMjMxNi81ZTAxZGM3
YjI2ZDlmMjRmMzlhYmFjZTVkYTk4Y2NiZDZhNWNlYjUyL2RtZXNnLXlvY3RvLXJvYW0tMjg6
MjAxNDAyMjIxNDI1Mjc6aTM4Ni1yYW5kY29uZmlnLXg0LTAyMjEyMzE2OjMuMTIuMDoxNzAK
L2tlcm5lbC9pMzg2LXJhbmRjb25maWcteDQtMDIyMTIzMTYvNWUwMWRjN2IyNmQ5ZjI0ZjM5
YWJhY2U1ZGE5OGNjYmQ2YTVjZWI1Mi9kbWVzZy1xdWFudGFsLXJvYW0tNTg6MjAxNDAyMjIx
NDE3NDM6aTM4Ni1yYW5kY29uZmlnLXg0LTAyMjEyMzE2OjMuMTIuMDoxNzAKL2tlcm5lbC9p
Mzg2LXJhbmRjb25maWcteDQtMDIyMTIzMTYvNWUwMWRjN2IyNmQ5ZjI0ZjM5YWJhY2U1ZGE5
OGNjYmQ2YTVjZWI1Mi9kbWVzZy15b2N0by13YWltZWEtNDoyMDE0MDIyMjE0MTU1MDppMzg2
LXJhbmRjb25maWcteDQtMDIyMTIzMTY6My4xMi4wOjE3MAova2VybmVsL2kzODYtcmFuZGNv
bmZpZy14NC0wMjIxMjMxNi81ZTAxZGM3YjI2ZDlmMjRmMzlhYmFjZTVkYTk4Y2NiZDZhNWNl
YjUyL2RtZXNnLXlvY3RvLXJvYW0tMjg6MjAxNDAyMjIxNDM2MzQ6aTM4Ni1yYW5kY29uZmln
LXg0LTAyMjEyMzE2OjMuMTIuMDoxNzAKL2tlcm5lbC9pMzg2LXJhbmRjb25maWcteDQtMDIy
MTIzMTYvNWUwMWRjN2IyNmQ5ZjI0ZjM5YWJhY2U1ZGE5OGNjYmQ2YTVjZWI1Mi9kbWVzZy15
b2N0by1yb2FtLTU3OjIwMTQwMjIyMTQzNjMzOmkzODYtcmFuZGNvbmZpZy14NC0wMjIxMjMx
NjozLjEyLjA6MTcwCi9rZXJuZWwvaTM4Ni1yYW5kY29uZmlnLXg0LTAyMjEyMzE2LzVlMDFk
YzdiMjZkOWYyNGYzOWFiYWNlNWRhOThjY2JkNmE1Y2ViNTIvZG1lc2cteW9jdG8tcm9hbS0x
MjoyMDE0MDIyMjE0MzAwOTppMzg2LXJhbmRjb25maWcteDQtMDIyMTIzMTY6My4xMi4wOjE3
MAova2VybmVsL2kzODYtcmFuZGNvbmZpZy14NC0wMjIxMjMxNi81ZTAxZGM3YjI2ZDlmMjRm
MzlhYmFjZTVkYTk4Y2NiZDZhNWNlYjUyL2RtZXNnLXlvY3RvLXJvYW0tMTM6MjAxNDAyMjIx
NDE3NDM6aTM4Ni1yYW5kY29uZmlnLXg0LTAyMjEyMzE2OjMuMTIuMDoxNzAKL2tlcm5lbC9p
Mzg2LXJhbmRjb25maWcteDQtMDIyMTIzMTYvNWUwMWRjN2IyNmQ5ZjI0ZjM5YWJhY2U1ZGE5
OGNjYmQ2YTVjZWI1Mi9kbWVzZy1xdWFudGFsLXJvYW0tMTc6MjAxNDAyMjIxNDI4MTU6aTM4
Ni1yYW5kY29uZmlnLXg0LTAyMjEyMzE2OjMuMTIuMDoxNzAKNTY6MTU6MTYgYWxsX2dvb2Q6
YmFkOmFsbF9iYWQgYm9vdHMKG1sxOzM1bTIwMTQtMDMtMDEgMDU6NDY6MjggUkVQRUFUIENP
VU5UOiA1OCAgIyAvY2Mvd2ZnL25ldC1iaXNlY3QvLnJlcGVhdBtbMG0KCmJpc2VjdDogYmFk
IGNvbW1pdCB2My4xMgpnaXQgY2hlY2tvdXQgdjMuMTEKbHMgLWEgL2tlcm5lbC10ZXN0cy9y
dW4tcXVldWUva3ZtL2kzODYtcmFuZGNvbmZpZy14NC0wMjIxMjMxNi9uZXh0Om1hc3Rlcjo2
ZTQ2NjQ1MjViMWRiMjhmOGM0ZTExMzA5NTdmNzBhOTRjMTkyMTNlOmJpc2VjdC1uZXQKIFRF
U1QgRkFJTFVSRQpbICAgIDAuMDI1MDAwXSBJbml0aWFsaXppbmcgQ1BVIzEKWyAgICAwLjAy
NTAwMF0gbWFza2VkIEV4dElOVCBvbiBDUFUjMQpbICAgIDAuMDI1MDAwXSAtLS0tLS0tLS0t
LS1bIGN1dCBoZXJlIF0tLS0tLS0tLS0tLS0KWyAgICAwLjAyNTAwMF0gV0FSTklORzogQ1BV
OiAxIFBJRDogMCBhdCAva2VybmVsLXRlc3RzL2xpbnV4Mi9hcmNoL3g4Ni9rZXJuZWwvY3B1
L2FtZC5jOjIyMSBpbml0X2FtZCsweDc2Mi8weDc5MCgpCi9rZXJuZWwvaTM4Ni1yYW5kY29u
ZmlnLXg0LTAyMjEyMzE2LzZlNDY2NDUyNWIxZGIyOGY4YzRlMTEzMDk1N2Y3MGE5NGMxOTIx
M2UvZG1lc2cteW9jdG8tcm9hbS01NzoyMDE0MDIyMjE2MTY1NjppMzg2LXJhbmRjb25maWct
eDQtMDIyMTIzMTY6My4xMS4wOjE3MQova2VybmVsL2kzODYtcmFuZGNvbmZpZy14NC0wMjIx
MjMxNi82ZTQ2NjQ1MjViMWRiMjhmOGM0ZTExMzA5NTdmNzBhOTRjMTkyMTNlL2RtZXNnLXlv
Y3RvLXJvYW0tNTU6MjAxNDAyMjIxNTExNTA6aTM4Ni1yYW5kY29uZmlnLXg0LTAyMjEyMzE2
OjMuMTEuMDoxNzEKL2tlcm5lbC9pMzg2LXJhbmRjb25maWcteDQtMDIyMTIzMTYvNmU0NjY0
NTI1YjFkYjI4ZjhjNGUxMTMwOTU3ZjcwYTk0YzE5MjEzZS9kbWVzZy15b2N0by1yb2FtLTMz
OjIwMTQwMjIyMTU1NTMxOmkzODYtcmFuZGNvbmZpZy14NC0wMjIxMjMxNjozLjExLjA6MTcx
Ci9rZXJuZWwvaTM4Ni1yYW5kY29uZmlnLXg0LTAyMjEyMzE2LzZlNDY2NDUyNWIxZGIyOGY4
YzRlMTEzMDk1N2Y3MGE5NGMxOTIxM2UvZG1lc2cteW9jdG8tcm9hbS0zNjoyMDE0MDIyMjE5
MjQxMzppMzg2LXJhbmRjb25maWcteDQtMDIyMTIzMTY6My4xMS4wOjE3MQova2VybmVsL2kz
ODYtcmFuZGNvbmZpZy14NC0wMjIxMjMxNi82ZTQ2NjQ1MjViMWRiMjhmOGM0ZTExMzA5NTdm
NzBhOTRjMTkyMTNlL2RtZXNnLXF1YW50YWwtcm9hbS02MzoyMDE0MDIyMjE4MzUzMTppMzg2
LXJhbmRjb25maWcteDQtMDIyMTIzMTY6My4xMS4wOjE3MQova2VybmVsL2kzODYtcmFuZGNv
bmZpZy14NC0wMjIxMjMxNi82ZTQ2NjQ1MjViMWRiMjhmOGM0ZTExMzA5NTdmNzBhOTRjMTky
MTNlL2RtZXNnLXlvY3RvLXJvYW0tMTE6MjAxNDAyMjMwMDA2NTI6aTM4Ni1yYW5kY29uZmln
LXg0LTAyMjEyMzE2OjMuMTEuMDoxNzEKL2tlcm5lbC9pMzg2LXJhbmRjb25maWcteDQtMDIy
MTIzMTYvNmU0NjY0NTI1YjFkYjI4ZjhjNGUxMTMwOTU3ZjcwYTk0YzE5MjEzZS9kbWVzZy1x
dWFudGFsLXJvYW0tNDE6MjAxNDAyMjIyMDQxNDY6aTM4Ni1yYW5kY29uZmlnLXg0LTAyMjEy
MzE2OjMuMTEuMDoxNzEKL2tlcm5lbC9pMzg2LXJhbmRjb25maWcteDQtMDIyMTIzMTYvNmU0
NjY0NTI1YjFkYjI4ZjhjNGUxMTMwOTU3ZjcwYTk0YzE5MjEzZS9kbWVzZy15b2N0by1yb2Ft
LTE4OjIwMTQwMjIyMjEwODMxOmkzODYtcmFuZGNvbmZpZy14NC0wMjIxMjMxNjozLjExLjA6
MTcxCi9rZXJuZWwvaTM4Ni1yYW5kY29uZmlnLXg0LTAyMjEyMzE2LzZlNDY2NDUyNWIxZGIy
OGY4YzRlMTEzMDk1N2Y3MGE5NGMxOTIxM2UvZG1lc2cteW9jdG8tcm9hbS01MToyMDE0MDIy
MjE1MjEyMjppMzg2LXJhbmRjb25maWcteDQtMDIyMTIzMTY6My4xMS4wOjE3MQova2VybmVs
L2kzODYtcmFuZGNvbmZpZy14NC0wMjIxMjMxNi82ZTQ2NjQ1MjViMWRiMjhmOGM0ZTExMzA5
NTdmNzBhOTRjMTkyMTNlL2RtZXNnLXlvY3RvLXJvYW0tMjM6MjAxNDAyMjIyMTEyMzI6aTM4
Ni1yYW5kY29uZmlnLXg0LTAyMjEyMzE2OjMuMTEuMDoxNzEKL2tlcm5lbC9pMzg2LXJhbmRj
b25maWcteDQtMDIyMTIzMTYvNmU0NjY0NTI1YjFkYjI4ZjhjNGUxMTMwOTU3ZjcwYTk0YzE5
MjEzZS9kbWVzZy15b2N0by1yb2FtLTE1OjIwMTQwMjIyMjEzMTQxOmkzODYtcmFuZGNvbmZp
Zy14NC0wMjIxMjMxNjozLjExLjA6MTcxCi9rZXJuZWwvaTM4Ni1yYW5kY29uZmlnLXg0LTAy
MjEyMzE2LzZlNDY2NDUyNWIxZGIyOGY4YzRlMTEzMDk1N2Y3MGE5NGMxOTIxM2UvZG1lc2ct
cXVhbnRhbC1yb2FtLTQxOjIwMTQwMjIyMjA1OTQ3OmkzODYtcmFuZGNvbmZpZy14NC0wMjIx
MjMxNjozLjExLjA6MTcxCi9rZXJuZWwvaTM4Ni1yYW5kY29uZmlnLXg0LTAyMjEyMzE2LzZl
NDY2NDUyNWIxZGIyOGY4YzRlMTEzMDk1N2Y3MGE5NGMxOTIxM2UvZG1lc2ctcXVhbnRhbC1y
b2FtLTE2OjIwMTQwMjIyMTkzODE0OmkzODYtcmFuZGNvbmZpZy14NC0wMjIxMjMxNjozLjEx
LjA6MTcxCi9rZXJuZWwvaTM4Ni1yYW5kY29uZmlnLXg0LTAyMjEyMzE2LzZlNDY2NDUyNWIx
ZGIyOGY4YzRlMTEzMDk1N2Y3MGE5NGMxOTIxM2UvZG1lc2ctcXVhbnRhbC1yb2FtLTM3OjIw
MTQwMjIyMTYyMTA5OmkzODYtcmFuZGNvbmZpZy14NC0wMjIxMjMxNjozLjExLjA6MTcxCi9r
ZXJuZWwvaTM4Ni1yYW5kY29uZmlnLXg0LTAyMjEyMzE2LzZlNDY2NDUyNWIxZGIyOGY4YzRl
MTEzMDk1N2Y3MGE5NGMxOTIxM2UvZG1lc2cteW9jdG8tcm9hbS0yMDoyMDE0MDIyMjE1MDIy
MjppMzg2LXJhbmRjb25maWcteDQtMDIyMTIzMTY6My4xMS4wOjE3MQova2VybmVsL2kzODYt
cmFuZGNvbmZpZy14NC0wMjIxMjMxNi82ZTQ2NjQ1MjViMWRiMjhmOGM0ZTExMzA5NTdmNzBh
OTRjMTkyMTNlL2RtZXNnLXF1YW50YWwtcm9hbS00NDoyMDE0MDIyMjE2MDcxMDppMzg2LXJh
bmRjb25maWcteDQtMDIyMTIzMTY6My4xMS4wOjE3MQova2VybmVsL2kzODYtcmFuZGNvbmZp
Zy14NC0wMjIxMjMxNi82ZTQ2NjQ1MjViMWRiMjhmOGM0ZTExMzA5NTdmNzBhOTRjMTkyMTNl
L2RtZXNnLXlvY3RvLXJvYW0tMToyMDE0MDIyMjIwMTQyNzppMzg2LXJhbmRjb25maWcteDQt
MDIyMTIzMTY6My4xMS4wOjE3MQova2VybmVsL2kzODYtcmFuZGNvbmZpZy14NC0wMjIxMjMx
Ni82ZTQ2NjQ1MjViMWRiMjhmOGM0ZTExMzA5NTdmNzBhOTRjMTkyMTNlL2RtZXNnLXlvY3Rv
LXJvYW0tNDc6MjAxNDAyMjIxNTA3NTI6aTM4Ni1yYW5kY29uZmlnLXg0LTAyMjEyMzE2OjMu
MTEuMDoxNzEKL2tlcm5lbC9pMzg2LXJhbmRjb25maWcteDQtMDIyMTIzMTYvNmU0NjY0NTI1
YjFkYjI4ZjhjNGUxMTMwOTU3ZjcwYTk0YzE5MjEzZS9kbWVzZy1xdWFudGFsLXJvYW0tMTc6
MjAxNDAyMjIyMTE4Mjc6aTM4Ni1yYW5kY29uZmlnLXg0LTAyMjEyMzE2OjMuMTEuMDoxNzEK
L2tlcm5lbC9pMzg2LXJhbmRjb25maWcteDQtMDIyMTIzMTYvNmU0NjY0NTI1YjFkYjI4Zjhj
NGUxMTMwOTU3ZjcwYTk0YzE5MjEzZS9kbWVzZy15b2N0by1yb2FtLTU6MjAxNDAyMjMwMDU0
MjQ6aTM4Ni1yYW5kY29uZmlnLXg0LTAyMjEyMzE2OjMuMTEuMDoxNzEKL2tlcm5lbC9pMzg2
LXJhbmRjb25maWcteDQtMDIyMTIzMTYvNmU0NjY0NTI1YjFkYjI4ZjhjNGUxMTMwOTU3Zjcw
YTk0YzE5MjEzZS9kbWVzZy15b2N0by1yb2FtLTE1OjIwMTQwMjIyMjEyNzM1OmkzODYtcmFu
ZGNvbmZpZy14NC0wMjIxMjMxNjozLjExLjA6MTcxCi9rZXJuZWwvaTM4Ni1yYW5kY29uZmln
LXg0LTAyMjEyMzE2LzZlNDY2NDUyNWIxZGIyOGY4YzRlMTEzMDk1N2Y3MGE5NGMxOTIxM2Uv
ZG1lc2ctcXVhbnRhbC13YWltZWEtMTE6MjAxNDAyMjIxNDMyMzE6aTM4Ni1yYW5kY29uZmln
LXg0LTAyMjEyMzE2OjMuMTEuMDoxNzEKL2tlcm5lbC9pMzg2LXJhbmRjb25maWcteDQtMDIy
MTIzMTYvNmU0NjY0NTI1YjFkYjI4ZjhjNGUxMTMwOTU3ZjcwYTk0YzE5MjEzZS9kbWVzZy1x
dWFudGFsLXJvYW0tNTM6MjAxNDAyMjMwMDA2MDc6aTM4Ni1yYW5kY29uZmlnLXg0LTAyMjEy
MzE2OjMuMTEuMDoxNzEKL2tlcm5lbC9pMzg2LXJhbmRjb25maWcteDQtMDIyMTIzMTYvNmU0
NjY0NTI1YjFkYjI4ZjhjNGUxMTMwOTU3ZjcwYTk0YzE5MjEzZS9kbWVzZy15b2N0by1yb2Ft
LTYwOjIwMTQwMjIyMTkzMDE1OmkzODYtcmFuZGNvbmZpZy14NC0wMjIxMjMxNjozLjExLjA6
MTcxCi9rZXJuZWwvaTM4Ni1yYW5kY29uZmlnLXg0LTAyMjEyMzE2LzZlNDY2NDUyNWIxZGIy
OGY4YzRlMTEzMDk1N2Y3MGE5NGMxOTIxM2UvZG1lc2ctcXVhbnRhbC1yb2FtLTU0OjIwMTQw
MjIyMjA0NDAyOmkzODYtcmFuZGNvbmZpZy14NC0wMjIxMjMxNjozLjExLjA6MTcxCi9rZXJu
ZWwvaTM4Ni1yYW5kY29uZmlnLXg0LTAyMjEyMzE2LzZlNDY2NDUyNWIxZGIyOGY4YzRlMTEz
MDk1N2Y3MGE5NGMxOTIxM2UvZG1lc2cteW9jdG8tcm9hbS00NDoyMDE0MDIyMjE1MTE1MDpp
Mzg2LXJhbmRjb25maWcteDQtMDIyMTIzMTY6My4xMS4wOjE3MQova2VybmVsL2kzODYtcmFu
ZGNvbmZpZy14NC0wMjIxMjMxNi82ZTQ2NjQ1MjViMWRiMjhmOGM0ZTExMzA5NTdmNzBhOTRj
MTkyMTNlL2RtZXNnLXlvY3RvLXJvYW0tMTY6MjAxNDAyMjIxNDM1MTE6aTM4Ni1yYW5kY29u
ZmlnLXg0LTAyMjEyMzE2OjMuMTEuMDoxNzEKL2tlcm5lbC9pMzg2LXJhbmRjb25maWcteDQt
MDIyMTIzMTYvNmU0NjY0NTI1YjFkYjI4ZjhjNGUxMTMwOTU3ZjcwYTk0YzE5MjEzZS9kbWVz
Zy15b2N0by1yb2FtLTUzOjIwMTQwMjIyMTkyMTA4OmkzODYtcmFuZGNvbmZpZy14NC0wMjIx
MjMxNjozLjExLjA6MTcxCi9rZXJuZWwvaTM4Ni1yYW5kY29uZmlnLXg0LTAyMjEyMzE2LzZl
NDY2NDUyNWIxZGIyOGY4YzRlMTEzMDk1N2Y3MGE5NGMxOTIxM2UvZG1lc2ctcXVhbnRhbC1y
b2FtLTQxOjIwMTQwMjIyMjEyNjI3OmkzODYtcmFuZGNvbmZpZy14NC0wMjIxMjMxNjozLjEx
LjA6MTcxCi9rZXJuZWwvaTM4Ni1yYW5kY29uZmlnLXg0LTAyMjEyMzE2LzZlNDY2NDUyNWIx
ZGIyOGY4YzRlMTEzMDk1N2Y3MGE5NGMxOTIxM2UvZG1lc2ctcXVhbnRhbC1yb2FtLTU4OjIw
MTQwMjIyMjA1OTQ3OmkzODYtcmFuZGNvbmZpZy14NC0wMjIxMjMxNjozLjExLjA6MTcxCi9r
ZXJuZWwvaTM4Ni1yYW5kY29uZmlnLXg0LTAyMjEyMzE2LzZlNDY2NDUyNWIxZGIyOGY4YzRl
MTEzMDk1N2Y3MGE5NGMxOTIxM2UvZG1lc2ctcXVhbnRhbC1yb2FtLTE4OjIwMTQwMjIyMTUz
MzMyOmkzODYtcmFuZGNvbmZpZy14NC0wMjIxMjMxNjozLjExLjA6MTcxCi9rZXJuZWwvaTM4
Ni1yYW5kY29uZmlnLXg0LTAyMjEyMzE2LzZlNDY2NDUyNWIxZGIyOGY4YzRlMTEzMDk1N2Y3
MGE5NGMxOTIxM2UvZG1lc2ctcXVhbnRhbC1yb2FtLTM0OjIwMTQwMjIyMjAwNjMwOmkzODYt
cmFuZGNvbmZpZy14NC0wMjIxMjMxNjozLjExLjA6MTcxCi9rZXJuZWwvaTM4Ni1yYW5kY29u
ZmlnLXg0LTAyMjEyMzE2LzZlNDY2NDUyNWIxZGIyOGY4YzRlMTEzMDk1N2Y3MGE5NGMxOTIx
M2UvZG1lc2ctcXVhbnRhbC1yb2FtLTU1OjIwMTQwMjIyMjA1OTQ3OmkzODYtcmFuZGNvbmZp
Zy14NC0wMjIxMjMxNjozLjExLjA6MTcxCi9rZXJuZWwvaTM4Ni1yYW5kY29uZmlnLXg0LTAy
MjEyMzE2LzZlNDY2NDUyNWIxZGIyOGY4YzRlMTEzMDk1N2Y3MGE5NGMxOTIxM2UvZG1lc2ct
cXVhbnRhbC1yb2FtLTE1OjIwMTQwMjIyMTU1NDM1OmkzODYtcmFuZGNvbmZpZy14NC0wMjIx
MjMxNjozLjExLjA6MTcxCi9rZXJuZWwvaTM4Ni1yYW5kY29uZmlnLXg0LTAyMjEyMzE2LzZl
NDY2NDUyNWIxZGIyOGY4YzRlMTEzMDk1N2Y3MGE5NGMxOTIxM2UvZG1lc2cteW9jdG8tcm9h
bS0xMDoyMDE0MDIyMjE0MjExMDppMzg2LXJhbmRjb25maWcteDQtMDIyMTIzMTY6My4xMS4w
OjE3MQova2VybmVsL2kzODYtcmFuZGNvbmZpZy14NC0wMjIxMjMxNi82ZTQ2NjQ1MjViMWRi
MjhmOGM0ZTExMzA5NTdmNzBhOTRjMTkyMTNlL2RtZXNnLXlvY3RvLXJvYW0tNTI6MjAxNDAy
MjMwMDA3MzU6aTM4Ni1yYW5kY29uZmlnLXg0LTAyMjEyMzE2OjMuMTEuMDoxNzEKL2tlcm5l
bC9pMzg2LXJhbmRjb25maWcteDQtMDIyMTIzMTYvNmU0NjY0NTI1YjFkYjI4ZjhjNGUxMTMw
OTU3ZjcwYTk0YzE5MjEzZS9kbWVzZy15b2N0by1yb2FtLTQ1OjIwMTQwMjIyMTkzMDE2Omkz
ODYtcmFuZGNvbmZpZy14NC0wMjIxMjMxNjozLjExLjA6MTcxCi9rZXJuZWwvaTM4Ni1yYW5k
Y29uZmlnLXg0LTAyMjEyMzE2LzZlNDY2NDUyNWIxZGIyOGY4YzRlMTEzMDk1N2Y3MGE5NGMx
OTIxM2UvZG1lc2ctcXVhbnRhbC1yb2FtLTQ4OjIwMTQwMjIyMTYwNDQ0OmkzODYtcmFuZGNv
bmZpZy14NC0wMjIxMjMxNjozLjExLjA6MTcxCi9rZXJuZWwvaTM4Ni1yYW5kY29uZmlnLXg0
LTAyMjEyMzE2LzZlNDY2NDUyNWIxZGIyOGY4YzRlMTEzMDk1N2Y3MGE5NGMxOTIxM2UvZG1l
c2ctcXVhbnRhbC1yb2FtLTQ2OjIwMTQwMjIyMTUxMzIwOmkzODYtcmFuZGNvbmZpZy14NC0w
MjIxMjMxNjozLjExLjA6MTcxCi9rZXJuZWwvaTM4Ni1yYW5kY29uZmlnLXg0LTAyMjEyMzE2
LzZlNDY2NDUyNWIxZGIyOGY4YzRlMTEzMDk1N2Y3MGE5NGMxOTIxM2UvZG1lc2ctcXVhbnRh
bC1yb2FtLTIxOjIwMTQwMjIyMTQ0NzEzOmkzODYtcmFuZGNvbmZpZy14NC0wMjIxMjMxNjoz
LjExLjA6MTcxCi9rZXJuZWwvaTM4Ni1yYW5kY29uZmlnLXg0LTAyMjEyMzE2LzZlNDY2NDUy
NWIxZGIyOGY4YzRlMTEzMDk1N2Y3MGE5NGMxOTIxM2UvZG1lc2ctcXVhbnRhbC13YWltZWEt
OToyMDE0MDIyMjE1MTk1NzppMzg2LXJhbmRjb25maWcteDQtMDIyMTIzMTY6My4xMS4wOjE3
MQova2VybmVsL2kzODYtcmFuZGNvbmZpZy14NC0wMjIxMjMxNi82ZTQ2NjQ1MjViMWRiMjhm
OGM0ZTExMzA5NTdmNzBhOTRjMTkyMTNlL2RtZXNnLXF1YW50YWwtd2FpbWVhLTEzOjIwMTQw
MjIyMTkxNDQzOmkzODYtcmFuZGNvbmZpZy14NC0wMjIxMjMxNjozLjExLjA6MTcxCi9rZXJu
ZWwvaTM4Ni1yYW5kY29uZmlnLXg0LTAyMjEyMzE2LzZlNDY2NDUyNWIxZGIyOGY4YzRlMTEz
MDk1N2Y3MGE5NGMxOTIxM2UvZG1lc2cteW9jdG8tcm9hbS02MToyMDE0MDIyMzAwMDg0Nzpp
Mzg2LXJhbmRjb25maWcteDQtMDIyMTIzMTY6My4xMS4wOjE3MQova2VybmVsL2kzODYtcmFu
ZGNvbmZpZy14NC0wMjIxMjMxNi82ZTQ2NjQ1MjViMWRiMjhmOGM0ZTExMzA5NTdmNzBhOTRj
MTkyMTNlL2RtZXNnLXF1YW50YWwtcm9hbS0yNzoyMDE0MDIyMzAyMDg0NzppMzg2LXJhbmRj
b25maWcteDQtMDIyMTIzMTY6My4xMS4wOjE3MQova2VybmVsL2kzODYtcmFuZGNvbmZpZy14
NC0wMjIxMjMxNi82ZTQ2NjQ1MjViMWRiMjhmOGM0ZTExMzA5NTdmNzBhOTRjMTkyMTNlL2Rt
ZXNnLXlvY3RvLXJvYW0tMjA6MjAxNDAyMjIxNTE5MjY6aTM4Ni1yYW5kY29uZmlnLXg0LTAy
MjEyMzE2OjMuMTEuMDoxNzEKL2tlcm5lbC9pMzg2LXJhbmRjb25maWcteDQtMDIyMTIzMTYv
NmU0NjY0NTI1YjFkYjI4ZjhjNGUxMTMwOTU3ZjcwYTk0YzE5MjEzZS9kbWVzZy15b2N0by1y
b2FtLTM5OjIwMTQwMjIyMTYxOTAzOmkzODYtcmFuZGNvbmZpZy14NC0wMjIxMjMxNjozLjEx
LjA6MTcxCi9rZXJuZWwvaTM4Ni1yYW5kY29uZmlnLXg0LTAyMjEyMzE2LzZlNDY2NDUyNWIx
ZGIyOGY4YzRlMTEzMDk1N2Y3MGE5NGMxOTIxM2UvZG1lc2ctcXVhbnRhbC1yb2FtLTQxOjIw
MTQwMjIyMTUyNzM5OmkzODYtcmFuZGNvbmZpZy14NC0wMjIxMjMxNjozLjExLjA6MTcxCi9r
ZXJuZWwvaTM4Ni1yYW5kY29uZmlnLXg0LTAyMjEyMzE2LzZlNDY2NDUyNWIxZGIyOGY4YzRl
MTEzMDk1N2Y3MGE5NGMxOTIxM2UvZG1lc2cteW9jdG8tcm9hbS0yODoyMDE0MDIyMjE1MTE1
MDppMzg2LXJhbmRjb25maWcteDQtMDIyMTIzMTY6My4xMS4wOjE3MQova2VybmVsL2kzODYt
cmFuZGNvbmZpZy14NC0wMjIxMjMxNi82ZTQ2NjQ1MjViMWRiMjhmOGM0ZTExMzA5NTdmNzBh
OTRjMTkyMTNlL2RtZXNnLXF1YW50YWwtcm9hbS0zNDoyMDE0MDIyMjE1MDU0NDppMzg2LXJh
bmRjb25maWcteDQtMDIyMTIzMTY6My4xMS4wOjE3MQova2VybmVsL2kzODYtcmFuZGNvbmZp
Zy14NC0wMjIxMjMxNi82ZTQ2NjQ1MjViMWRiMjhmOGM0ZTExMzA5NTdmNzBhOTRjMTkyMTNl
L2RtZXNnLXF1YW50YWwtcm9hbS00OToyMDE0MDIyMjE4MjYxOTppMzg2LXJhbmRjb25maWct
eDQtMDIyMTIzMTY6My4xMS4wOjE3MQova2VybmVsL2kzODYtcmFuZGNvbmZpZy14NC0wMjIx
MjMxNi82ZTQ2NjQ1MjViMWRiMjhmOGM0ZTExMzA5NTdmNzBhOTRjMTkyMTNlL2RtZXNnLXF1
YW50YWwtcm9hbS0zNjoyMDE0MDIyMjE1MTUzMDppMzg2LXJhbmRjb25maWcteDQtMDIyMTIz
MTY6My4xMS4wOjE3MQova2VybmVsL2kzODYtcmFuZGNvbmZpZy14NC0wMjIxMjMxNi82ZTQ2
NjQ1MjViMWRiMjhmOGM0ZTExMzA5NTdmNzBhOTRjMTkyMTNlL2RtZXNnLXlvY3RvLXdhaW1l
YS0xOjIwMTQwMjIyMTU1NzM4OmkzODYtcmFuZGNvbmZpZy14NC0wMjIxMjMxNjozLjExLjA6
MTcxCi9rZXJuZWwvaTM4Ni1yYW5kY29uZmlnLXg0LTAyMjEyMzE2LzZlNDY2NDUyNWIxZGIy
OGY4YzRlMTEzMDk1N2Y3MGE5NGMxOTIxM2UvZG1lc2ctcXVhbnRhbC1yb2FtLTMxOjIwMTQw
MjIzMDAxMDU5OmkzODYtcmFuZGNvbmZpZy14NC0wMjIxMjMxNjozLjExLjA6MTcxCi9rZXJu
ZWwvaTM4Ni1yYW5kY29uZmlnLXg0LTAyMjEyMzE2LzZlNDY2NDUyNWIxZGIyOGY4YzRlMTEz
MDk1N2Y3MGE5NGMxOTIxM2UvZG1lc2cteW9jdG8tcm9hbS0zOToyMDE0MDIyMjIxMTgwMjpp
Mzg2LXJhbmRjb25maWcteDQtMDIyMTIzMTY6My4xMS4wOjE3MQova2VybmVsL2kzODYtcmFu
ZGNvbmZpZy14NC0wMjIxMjMxNi82ZTQ2NjQ1MjViMWRiMjhmOGM0ZTExMzA5NTdmNzBhOTRj
MTkyMTNlL2RtZXNnLXlvY3RvLXJvYW0tNjI6MjAxNDAyMjIxNTU4NTc6aTM4Ni1yYW5kY29u
ZmlnLXg0LTAyMjEyMzE2OjMuMTEuMDoxNzEKL2tlcm5lbC9pMzg2LXJhbmRjb25maWcteDQt
MDIyMTIzMTYvNmU0NjY0NTI1YjFkYjI4ZjhjNGUxMTMwOTU3ZjcwYTk0YzE5MjEzZS9kbWVz
Zy15b2N0by1yb2FtLTM3OjIwMTQwMjIyMjEyMzEwOmkzODYtcmFuZGNvbmZpZy14NC0wMjIx
MjMxNjozLjExLjA6MTcxCi9rZXJuZWwvaTM4Ni1yYW5kY29uZmlnLXg0LTAyMjEyMzE2LzZl
NDY2NDUyNWIxZGIyOGY4YzRlMTEzMDk1N2Y3MGE5NGMxOTIxM2UvZG1lc2cteW9jdG8tcm9h
bS00MzoyMDE0MDIyMjE5MDAxNDppMzg2LXJhbmRjb25maWcteDQtMDIyMTIzMTY6My4xMS4w
OjE3MQova2VybmVsL2kzODYtcmFuZGNvbmZpZy14NC0wMjIxMjMxNi82ZTQ2NjQ1MjViMWRi
MjhmOGM0ZTExMzA5NTdmNzBhOTRjMTkyMTNlL2RtZXNnLXlvY3RvLXJvYW0tMTA6MjAxNDAy
MjIxNTIzMjc6aTM4Ni1yYW5kY29uZmlnLXg0LTAyMjEyMzE2OjMuMTEuMDoxNzEKL2tlcm5l
bC9pMzg2LXJhbmRjb25maWcteDQtMDIyMTIzMTYvNmU0NjY0NTI1YjFkYjI4ZjhjNGUxMTMw
OTU3ZjcwYTk0YzE5MjEzZS9kbWVzZy1xdWFudGFsLXJvYW0tNDg6MjAxNDAyMjIxOTE4Mzk6
aTM4Ni1yYW5kY29uZmlnLXg0LTAyMjEyMzE2OjMuMTEuMDoxNzEKL2tlcm5lbC9pMzg2LXJh
bmRjb25maWcteDQtMDIyMTIzMTYvNmU0NjY0NTI1YjFkYjI4ZjhjNGUxMTMwOTU3ZjcwYTk0
YzE5MjEzZS9kbWVzZy1xdWFudGFsLXJvYW0tMTc6MjAxNDAyMjIxOTA4Mzc6aTM4Ni1yYW5k
Y29uZmlnLXg0LTAyMjEyMzE2OjMuMTEuMDoxNzEKL2tlcm5lbC9pMzg2LXJhbmRjb25maWct
eDQtMDIyMTIzMTYvNmU0NjY0NTI1YjFkYjI4ZjhjNGUxMTMwOTU3ZjcwYTk0YzE5MjEzZS9k
bWVzZy15b2N0by1yb2FtLTExOjIwMTQwMjIyMTc1ODU4OmkzODYtcmFuZGNvbmZpZy14NC0w
MjIxMjMxNjozLjExLjA6MTcxCi9rZXJuZWwvaTM4Ni1yYW5kY29uZmlnLXg0LTAyMjEyMzE2
LzZlNDY2NDUyNWIxZGIyOGY4YzRlMTEzMDk1N2Y3MGE5NGMxOTIxM2UvZG1lc2ctcXVhbnRh
bC1yb2FtLTIxOjIwMTQwMjIyMTkwMDE0OmkzODYtcmFuZGNvbmZpZy14NC0wMjIxMjMxNjoz
LjExLjA6MTcxCi9rZXJuZWwvaTM4Ni1yYW5kY29uZmlnLXg0LTAyMjEyMzE2LzZlNDY2NDUy
NWIxZGIyOGY4YzRlMTEzMDk1N2Y3MGE5NGMxOTIxM2UvZG1lc2ctcXVhbnRhbC1yb2FtLTY6
MjAxNDAyMjIxNjA0NDQ6aTM4Ni1yYW5kY29uZmlnLXg0LTAyMjEyMzE2OjMuMTEuMDoxNzEK
L2tlcm5lbC9pMzg2LXJhbmRjb25maWcteDQtMDIyMTIzMTYvNmU0NjY0NTI1YjFkYjI4Zjhj
NGUxMTMwOTU3ZjcwYTk0YzE5MjEzZS9kbWVzZy1xdWFudGFsLXJvYW0tMjM6MjAxNDAyMjIy
MTEyMzc6aTM4Ni1yYW5kY29uZmlnLXg0LTAyMjEyMzE2OjMuMTEuMDoxNzEKL2tlcm5lbC9p
Mzg2LXJhbmRjb25maWcteDQtMDIyMTIzMTYvNmU0NjY0NTI1YjFkYjI4ZjhjNGUxMTMwOTU3
ZjcwYTk0YzE5MjEzZS9kbWVzZy1xdWFudGFsLXJvYW0tNDc6MjAxNDAyMjIyMTMxMzY6aTM4
Ni1yYW5kY29uZmlnLXg0LTAyMjEyMzE2OjMuMTEuMDoxNzEKL2tlcm5lbC9pMzg2LXJhbmRj
b25maWcteDQtMDIyMTIzMTYvNmU0NjY0NTI1YjFkYjI4ZjhjNGUxMTMwOTU3ZjcwYTk0YzE5
MjEzZS9kbWVzZy15b2N0by1yb2FtLTU3OjIwMTQwMjIyMTkwMDE0OmkzODYtcmFuZGNvbmZp
Zy14NC0wMjIxMjMxNjozLjExLjA6MTcxCi9rZXJuZWwvaTM4Ni1yYW5kY29uZmlnLXg0LTAy
MjEyMzE2LzZlNDY2NDUyNWIxZGIyOGY4YzRlMTEzMDk1N2Y3MGE5NGMxOTIxM2UvZG1lc2ct
cXVhbnRhbC1yb2FtLTI6MjAxNDAyMjIxNjA2MDk6aTM4Ni1yYW5kY29uZmlnLXg0LTAyMjEy
MzE2OjMuMTEuMDoxNzEKL2tlcm5lbC9pMzg2LXJhbmRjb25maWcteDQtMDIyMTIzMTYvNmU0
NjY0NTI1YjFkYjI4ZjhjNGUxMTMwOTU3ZjcwYTk0YzE5MjEzZS9kbWVzZy15b2N0by1yb2Ft
LTE0OjIwMTQwMjIyMTQzNDQzOmkzODYtcmFuZGNvbmZpZy14NC0wMjIxMjMxNjozLjExLjA6
MTcxCi9rZXJuZWwvaTM4Ni1yYW5kY29uZmlnLXg0LTAyMjEyMzE2LzZlNDY2NDUyNWIxZGIy
OGY4YzRlMTEzMDk1N2Y3MGE5NGMxOTIxM2UvZG1lc2cteW9jdG8tcm9hbS0zNjoyMDE0MDIy
MjIwMzczNDppMzg2LXJhbmRjb25maWcteDQtMDIyMTIzMTY6My4xMS4wOjE3MQova2VybmVs
L2kzODYtcmFuZGNvbmZpZy14NC0wMjIxMjMxNi82ZTQ2NjQ1MjViMWRiMjhmOGM0ZTExMzA5
NTdmNzBhOTRjMTkyMTNlL2RtZXNnLXF1YW50YWwtcm9hbS0yMzoyMDE0MDIyMjE5NDcwNDpp
Mzg2LXJhbmRjb25maWcteDQtMDIyMTIzMTY6My4xMS4wOjE3MQova2VybmVsL2kzODYtcmFu
ZGNvbmZpZy14NC0wMjIxMjMxNi82ZTQ2NjQ1MjViMWRiMjhmOGM0ZTExMzA5NTdmNzBhOTRj
MTkyMTNlL2RtZXNnLXF1YW50YWwtcm9hbS02MjoyMDE0MDIyMjE0MjgxMDppMzg2LXJhbmRj
b25maWcteDQtMDIyMTIzMTY6My4xMS4wOjE3MQova2VybmVsL2kzODYtcmFuZGNvbmZpZy14
NC0wMjIxMjMxNi82ZTQ2NjQ1MjViMWRiMjhmOGM0ZTExMzA5NTdmNzBhOTRjMTkyMTNlL2Rt
ZXNnLXlvY3RvLXJvYW0tNDoyMDE0MDIyMjE1MjIwNDppMzg2LXJhbmRjb25maWcteDQtMDIy
MTIzMTY6My4xMS4wOjE3MQova2VybmVsL2kzODYtcmFuZGNvbmZpZy14NC0wMjIxMjMxNi82
ZTQ2NjQ1MjViMWRiMjhmOGM0ZTExMzA5NTdmNzBhOTRjMTkyMTNlL2RtZXNnLXF1YW50YWwt
d2FpbWVhLTE0OjIwMTQwMjIyMTQzNjMzOmkzODYtcmFuZGNvbmZpZy14NC0wMjIxMjMxNjoz
LjExLjA6MTcxCjI0Njo3Mzo3NCBhbGxfZ29vZDpiYWQ6YWxsX2JhZCBib290cwoKYmlzZWN0
OiBiYWQgY29tbWl0IHYzLjExCmdpdCBjaGVja291dCB2My4xMApscyAtYSAva2VybmVsLXRl
c3RzL3J1bi1xdWV1ZS9rdm0vaTM4Ni1yYW5kY29uZmlnLXg0LTAyMjEyMzE2L25leHQ6bWFz
dGVyOjhiYjQ5NWUzZjAyNDAxZWU2Zjc2ZDFiMWQ3N2YzYWM5ZjA3OWUzNzY6YmlzZWN0LW5l
dAogVEVTVCBGQUlMVVJFClsgICAgMC4wMTMwMDBdIEluaXRpYWxpemluZyBDUFUjMQpbICAg
IDAuMDEzMDAwXSBtYXNrZWQgRXh0SU5UIG9uIENQVSMxClsgICAgMC4wMTMwMDBdIC0tLS0t
LS0tLS0tLVsgY3V0IGhlcmUgXS0tLS0tLS0tLS0tLQpbICAgIDAuMDEzMDAwXSBXQVJOSU5H
OiBhdCAva2VybmVsLXRlc3RzL2xpbnV4Mi9hcmNoL3g4Ni9rZXJuZWwvY3B1L2FtZC5jOjIy
MSBpbml0X2FtZCsweDMxYS8weDYxOSgpCi9rZXJuZWwvaTM4Ni1yYW5kY29uZmlnLXg0LTAy
MjEyMzE2LzhiYjQ5NWUzZjAyNDAxZWU2Zjc2ZDFiMWQ3N2YzYWM5ZjA3OWUzNzYvZG1lc2ct
eW9jdG8tcm9hbS0yMToyMDE0MDIyMzAwMzUyNzppMzg2LXJhbmRjb25maWcteDQtMDIyMTIz
MTY6My4xMC4wOjE3Mgova2VybmVsL2kzODYtcmFuZGNvbmZpZy14NC0wMjIxMjMxNi84YmI0
OTVlM2YwMjQwMWVlNmY3NmQxYjFkNzdmM2FjOWYwNzllMzc2L2RtZXNnLXF1YW50YWwtcm9h
bS0zOToyMDE0MDIyMzAxMzUxMzppMzg2LXJhbmRjb25maWcteDQtMDIyMTIzMTY6My4xMC4w
OjE3Mgova2VybmVsL2kzODYtcmFuZGNvbmZpZy14NC0wMjIxMjMxNi84YmI0OTVlM2YwMjQw
MWVlNmY3NmQxYjFkNzdmM2FjOWYwNzllMzc2L2RtZXNnLXlvY3RvLXJvYW0tMzI6MjAxNDAy
MjIyMDE0MzI6aTM4Ni1yYW5kY29uZmlnLXg0LTAyMjEyMzE2OjMuMTAuMDoxNzIKL2tlcm5l
bC9pMzg2LXJhbmRjb25maWcteDQtMDIyMTIzMTYvOGJiNDk1ZTNmMDI0MDFlZTZmNzZkMWIx
ZDc3ZjNhYzlmMDc5ZTM3Ni9kbWVzZy1xdWFudGFsLXJvYW0tMTM6MjAxNDAyMjIyMTEyMzI6
aTM4Ni1yYW5kY29uZmlnLXg0LTAyMjEyMzE2OjMuMTAuMDoxNzIKL2tlcm5lbC9pMzg2LXJh
bmRjb25maWcteDQtMDIyMTIzMTYvOGJiNDk1ZTNmMDI0MDFlZTZmNzZkMWIxZDc3ZjNhYzlm
MDc5ZTM3Ni9kbWVzZy15b2N0by1yb2FtLTI1OjIwMTQwMjIyMTkxMDI0OmkzODYtcmFuZGNv
bmZpZy14NC0wMjIxMjMxNjozLjEwLjA6MTcyCi9rZXJuZWwvaTM4Ni1yYW5kY29uZmlnLXg0
LTAyMjEyMzE2LzhiYjQ5NWUzZjAyNDAxZWU2Zjc2ZDFiMWQ3N2YzYWM5ZjA3OWUzNzYvZG1l
c2ctcXVhbnRhbC1yb2FtLTMxOjIwMTQwMjIzMDEzOTA1OmkzODYtcmFuZGNvbmZpZy14NC0w
MjIxMjMxNjozLjEwLjA6MTcyCi9rZXJuZWwvaTM4Ni1yYW5kY29uZmlnLXg0LTAyMjEyMzE2
LzhiYjQ5NWUzZjAyNDAxZWU2Zjc2ZDFiMWQ3N2YzYWM5ZjA3OWUzNzYvZG1lc2ctcXVhbnRh
bC13YWltZWEtMToyMDE0MDIyMzAxNDgxMzppMzg2LXJhbmRjb25maWcteDQtMDIyMTIzMTY6
My4xMC4wOjE3Mgova2VybmVsL2kzODYtcmFuZGNvbmZpZy14NC0wMjIxMjMxNi84YmI0OTVl
M2YwMjQwMWVlNmY3NmQxYjFkNzdmM2FjOWYwNzllMzc2L2RtZXNnLXF1YW50YWwtcm9hbS01
OjIwMTQwMjIyMjEzMjMzOmkzODYtcmFuZGNvbmZpZy14NC0wMjIxMjMxNjozLjEwLjA6MTcy
Ci9rZXJuZWwvaTM4Ni1yYW5kY29uZmlnLXg0LTAyMjEyMzE2LzhiYjQ5NWUzZjAyNDAxZWU2
Zjc2ZDFiMWQ3N2YzYWM5ZjA3OWUzNzYvZG1lc2ctcXVhbnRhbC1yb2FtLTYwOjIwMTQwMjIy
MjAyOTA1OmkzODYtcmFuZGNvbmZpZy14NC0wMjIxMjMxNjozLjEwLjA6MTcyCi9rZXJuZWwv
aTM4Ni1yYW5kY29uZmlnLXg0LTAyMjEyMzE2LzhiYjQ5NWUzZjAyNDAxZWU2Zjc2ZDFiMWQ3
N2YzYWM5ZjA3OWUzNzYvZG1lc2ctcXVhbnRhbC1yb2FtLTU2OjIwMTQwMjIyMTUyNzU2Omkz
ODYtcmFuZGNvbmZpZy14NC0wMjIxMjMxNjozLjEwLjA6MTcyCi9rZXJuZWwvaTM4Ni1yYW5k
Y29uZmlnLXg0LTAyMjEyMzE2LzhiYjQ5NWUzZjAyNDAxZWU2Zjc2ZDFiMWQ3N2YzYWM5ZjA3
OWUzNzYvZG1lc2cteW9jdG8td2FpbWVhLTQ6MjAxNDAyMjIyMDI5MzI6aTM4Ni1yYW5kY29u
ZmlnLXg0LTAyMjEyMzE2OjMuMTAuMDoxNzIKL2tlcm5lbC9pMzg2LXJhbmRjb25maWcteDQt
MDIyMTIzMTYvOGJiNDk1ZTNmMDI0MDFlZTZmNzZkMWIxZDc3ZjNhYzlmMDc5ZTM3Ni9kbWVz
Zy15b2N0by1yb2FtLTU6MjAxNDAyMjMwMTAwNDg6aTM4Ni1yYW5kY29uZmlnLXg0LTAyMjEy
MzE2OjMuMTAuMDoxNzIKL2tlcm5lbC9pMzg2LXJhbmRjb25maWcteDQtMDIyMTIzMTYvOGJi
NDk1ZTNmMDI0MDFlZTZmNzZkMWIxZDc3ZjNhYzlmMDc5ZTM3Ni9kbWVzZy15b2N0by1yb2Ft
LTE0OjIwMTQwMjIyMTUwNTQ0OmkzODYtcmFuZGNvbmZpZy14NC0wMjIxMjMxNjozLjEwLjA6
MTcyCi9rZXJuZWwvaTM4Ni1yYW5kY29uZmlnLXg0LTAyMjEyMzE2LzhiYjQ5NWUzZjAyNDAx
ZWU2Zjc2ZDFiMWQ3N2YzYWM5ZjA3OWUzNzYvZG1lc2cteW9jdG8tcm9hbS01OjIwMTQwMjIy
MjAyNjUyOmkzODYtcmFuZGNvbmZpZy14NC0wMjIxMjMxNjozLjEwLjA6MTcyCi9rZXJuZWwv
aTM4Ni1yYW5kY29uZmlnLXg0LTAyMjEyMzE2LzhiYjQ5NWUzZjAyNDAxZWU2Zjc2ZDFiMWQ3
N2YzYWM5ZjA3OWUzNzYvZG1lc2ctcXVhbnRhbC1yb2FtLTU6MjAxNDAyMjMwMTQ2Mjg6aTM4
Ni1yYW5kY29uZmlnLXg0LTAyMjEyMzE2OjMuMTAuMDoxNzIKL2tlcm5lbC9pMzg2LXJhbmRj
b25maWcteDQtMDIyMTIzMTYvOGJiNDk1ZTNmMDI0MDFlZTZmNzZkMWIxZDc3ZjNhYzlmMDc5
ZTM3Ni9kbWVzZy15b2N0by1yb2FtLTQyOjIwMTQwMjIyMTQzNDU0OmkzODYtcmFuZGNvbmZp
Zy14NC0wMjIxMjMxNjozLjEwLjA6MTcyCi9rZXJuZWwvaTM4Ni1yYW5kY29uZmlnLXg0LTAy
MjEyMzE2LzhiYjQ5NWUzZjAyNDAxZWU2Zjc2ZDFiMWQ3N2YzYWM5ZjA3OWUzNzYvZG1lc2ct
cXVhbnRhbC1yb2FtLTQ3OjIwMTQwMjIyMTYxMjM0OmkzODYtcmFuZGNvbmZpZy14NC0wMjIx
MjMxNjozLjEwLjA6MTcyCi9rZXJuZWwvaTM4Ni1yYW5kY29uZmlnLXg0LTAyMjEyMzE2Lzhi
YjQ5NWUzZjAyNDAxZWU2Zjc2ZDFiMWQ3N2YzYWM5ZjA3OWUzNzYvZG1lc2ctcXVhbnRhbC1y
b2FtLTE4OjIwMTQwMjIyMjEzMjMzOmkzODYtcmFuZGNvbmZpZy14NC0wMjIxMjMxNjozLjEw
LjA6MTcyCi9rZXJuZWwvaTM4Ni1yYW5kY29uZmlnLXg0LTAyMjEyMzE2LzhiYjQ5NWUzZjAy
NDAxZWU2Zjc2ZDFiMWQ3N2YzYWM5ZjA3OWUzNzYvZG1lc2cteW9jdG8tcm9hbS00MToyMDE0
MDIyMjIxMzIxNjppMzg2LXJhbmRjb25maWcteDQtMDIyMTIzMTY6My4xMC4wOjE3Mgova2Vy
bmVsL2kzODYtcmFuZGNvbmZpZy14NC0wMjIxMjMxNi84YmI0OTVlM2YwMjQwMWVlNmY3NmQx
YjFkNzdmM2FjOWYwNzllMzc2L2RtZXNnLXF1YW50YWwtcm9hbS00ODoyMDE0MDIyMjIxMjcw
MjppMzg2LXJhbmRjb25maWcteDQtMDIyMTIzMTY6My4xMC4wOjE3Mgova2VybmVsL2kzODYt
cmFuZGNvbmZpZy14NC0wMjIxMjMxNi84YmI0OTVlM2YwMjQwMWVlNmY3NmQxYjFkNzdmM2Fj
OWYwNzllMzc2L2RtZXNnLXlvY3RvLXJvYW0tNTA6MjAxNDAyMjIxODQwMDc6aTM4Ni1yYW5k
Y29uZmlnLXg0LTAyMjEyMzE2OjMuMTAuMDoxNzIKL2tlcm5lbC9pMzg2LXJhbmRjb25maWct
eDQtMDIyMTIzMTYvOGJiNDk1ZTNmMDI0MDFlZTZmNzZkMWIxZDc3ZjNhYzlmMDc5ZTM3Ni9k
bWVzZy15b2N0by13YWltZWEtNjoyMDE0MDIyMjE1MzI1MTppMzg2LXJhbmRjb25maWcteDQt
MDIyMTIzMTY6My4xMC4wOjE3Mgova2VybmVsL2kzODYtcmFuZGNvbmZpZy14NC0wMjIxMjMx
Ni84YmI0OTVlM2YwMjQwMWVlNmY3NmQxYjFkNzdmM2FjOWYwNzllMzc2L2RtZXNnLXlvY3Rv
LXJvYW0tMzk6MjAxNDAyMjIxNDQ3MTM6aTM4Ni1yYW5kY29uZmlnLXg0LTAyMjEyMzE2OjMu
MTAuMDoxNzIKL2tlcm5lbC9pMzg2LXJhbmRjb25maWcteDQtMDIyMTIzMTYvOGJiNDk1ZTNm
MDI0MDFlZTZmNzZkMWIxZDc3ZjNhYzlmMDc5ZTM3Ni9kbWVzZy1xdWFudGFsLXdhaW1lYS0x
OjIwMTQwMjIzMDE1MDUxOmkzODYtcmFuZGNvbmZpZy14NC0wMjIxMjMxNjozLjEwLjA6MTcy
Ci9rZXJuZWwvaTM4Ni1yYW5kY29uZmlnLXg0LTAyMjEyMzE2LzhiYjQ5NWUzZjAyNDAxZWU2
Zjc2ZDFiMWQ3N2YzYWM5ZjA3OWUzNzYvZG1lc2cteW9jdG8td2FpbWVhLTQ6MjAxNDAyMjIx
NjE4NDY6aTM4Ni1yYW5kY29uZmlnLXg0LTAyMjEyMzE2OjMuMTAuMDoxNzIKL2tlcm5lbC9p
Mzg2LXJhbmRjb25maWcteDQtMDIyMTIzMTYvOGJiNDk1ZTNmMDI0MDFlZTZmNzZkMWIxZDc3
ZjNhYzlmMDc5ZTM3Ni9kbWVzZy15b2N0by1yb2FtLTIyOjIwMTQwMjIyMjEyMzM2OmkzODYt
cmFuZGNvbmZpZy14NC0wMjIxMjMxNjozLjEwLjA6MTcyCi9rZXJuZWwvaTM4Ni1yYW5kY29u
ZmlnLXg0LTAyMjEyMzE2LzhiYjQ5NWUzZjAyNDAxZWU2Zjc2ZDFiMWQ3N2YzYWM5ZjA3OWUz
NzYvZG1lc2cteW9jdG8tcm9hbS0zNzoyMDE0MDIyMzAxMzUwOTppMzg2LXJhbmRjb25maWct
eDQtMDIyMTIzMTY6My4xMC4wOjE3Mgova2VybmVsL2kzODYtcmFuZGNvbmZpZy14NC0wMjIx
MjMxNi84YmI0OTVlM2YwMjQwMWVlNmY3NmQxYjFkNzdmM2FjOWYwNzllMzc2L2RtZXNnLXlv
Y3RvLXJvYW0tMzE6MjAxNDAyMjIxOTE4NDI6aTM4Ni1yYW5kY29uZmlnLXg0LTAyMjEyMzE2
OjMuMTAuMDoxNzIKL2tlcm5lbC9pMzg2LXJhbmRjb25maWcteDQtMDIyMTIzMTYvOGJiNDk1
ZTNmMDI0MDFlZTZmNzZkMWIxZDc3ZjNhYzlmMDc5ZTM3Ni9kbWVzZy1xdWFudGFsLXJvYW0t
Mzg6MjAxNDAyMjIxNTEzMjA6aTM4Ni1yYW5kY29uZmlnLXg0LTAyMjEyMzE2OjMuMTAuMDox
NzIKL2tlcm5lbC9pMzg2LXJhbmRjb25maWcteDQtMDIyMTIzMTYvOGJiNDk1ZTNmMDI0MDFl
ZTZmNzZkMWIxZDc3ZjNhYzlmMDc5ZTM3Ni9kbWVzZy15b2N0by1yb2FtLTU5OjIwMTQwMjIy
MTYxNzUwOmkzODYtcmFuZGNvbmZpZy14NC0wMjIxMjMxNjozLjEwLjA6MTcyCi9rZXJuZWwv
aTM4Ni1yYW5kY29uZmlnLXg0LTAyMjEyMzE2LzhiYjQ5NWUzZjAyNDAxZWU2Zjc2ZDFiMWQ3
N2YzYWM5ZjA3OWUzNzYvZG1lc2ctcXVhbnRhbC1yb2FtLTk6MjAxNDAyMjMwMTAxMDA6aTM4
Ni1yYW5kY29uZmlnLXg0LTAyMjEyMzE2OjMuMTAuMDoxNzIKL2tlcm5lbC9pMzg2LXJhbmRj
b25maWcteDQtMDIyMTIzMTYvOGJiNDk1ZTNmMDI0MDFlZTZmNzZkMWIxZDc3ZjNhYzlmMDc5
ZTM3Ni9kbWVzZy1xdWFudGFsLXJvYW0tMTE6MjAxNDAyMjIxNTEzMjY6aTM4Ni1yYW5kY29u
ZmlnLXg0LTAyMjEyMzE2OjMuMTAuMDoxNzIKL2tlcm5lbC9pMzg2LXJhbmRjb25maWcteDQt
MDIyMTIzMTYvOGJiNDk1ZTNmMDI0MDFlZTZmNzZkMWIxZDc3ZjNhYzlmMDc5ZTM3Ni9kbWVz
Zy1xdWFudGFsLXJvYW0tMzE6MjAxNDAyMjIxNTM1MDA6aTM4Ni1yYW5kY29uZmlnLXg0LTAy
MjEyMzE2OjMuMTAuMDoxNzIKL2tlcm5lbC9pMzg2LXJhbmRjb25maWcteDQtMDIyMTIzMTYv
OGJiNDk1ZTNmMDI0MDFlZTZmNzZkMWIxZDc3ZjNhYzlmMDc5ZTM3Ni9kbWVzZy15b2N0by1y
b2FtLTQ1OjIwMTQwMjIyMTQzNjMzOmkzODYtcmFuZGNvbmZpZy14NC0wMjIxMjMxNjozLjEw
LjA6MTcyCi9rZXJuZWwvaTM4Ni1yYW5kY29uZmlnLXg0LTAyMjEyMzE2LzhiYjQ5NWUzZjAy
NDAxZWU2Zjc2ZDFiMWQ3N2YzYWM5ZjA3OWUzNzYvZG1lc2cteW9jdG8tcm9hbS0yNzoyMDE0
MDIyMzEyNDMzNTppMzg2LXJhbmRjb25maWcteDQtMDIyMTIzMTY6My4xMC4wOjE3Mgova2Vy
bmVsL2kzODYtcmFuZGNvbmZpZy14NC0wMjIxMjMxNi84YmI0OTVlM2YwMjQwMWVlNmY3NmQx
YjFkNzdmM2FjOWYwNzllMzc2L2RtZXNnLXlvY3RvLXJvYW0tMjE6MjAxNDAyMjIyMTMwNTA6
aTM4Ni1yYW5kY29uZmlnLXg0LTAyMjEyMzE2OjMuMTAuMDoxNzIKL2tlcm5lbC9pMzg2LXJh
bmRjb25maWcteDQtMDIyMTIzMTYvOGJiNDk1ZTNmMDI0MDFlZTZmNzZkMWIxZDc3ZjNhYzlm
MDc5ZTM3Ni9kbWVzZy15b2N0by1yb2FtLTQ5OjIwMTQwMjIzMDIyMjQ4OmkzODYtcmFuZGNv
bmZpZy14NC0wMjIxMjMxNjozLjEwLjA6MTcyCi9rZXJuZWwvaTM4Ni1yYW5kY29uZmlnLXg0
LTAyMjEyMzE2LzhiYjQ5NWUzZjAyNDAxZWU2Zjc2ZDFiMWQ3N2YzYWM5ZjA3OWUzNzYvZG1l
c2cteW9jdG8tcm9hbS01MzoyMDE0MDIyMjE5MzAxNjppMzg2LXJhbmRjb25maWcteDQtMDIy
MTIzMTY6My4xMC4wOjE3Mgova2VybmVsL2kzODYtcmFuZGNvbmZpZy14NC0wMjIxMjMxNi84
YmI0OTVlM2YwMjQwMWVlNmY3NmQxYjFkNzdmM2FjOWYwNzllMzc2L2RtZXNnLXlvY3RvLXJv
YW0tNjE6MjAxNDAyMjIxNjEyMzQ6aTM4Ni1yYW5kY29uZmlnLXg0LTAyMjEyMzE2OjMuMTAu
MDoxNzIKL2tlcm5lbC9pMzg2LXJhbmRjb25maWcteDQtMDIyMTIzMTYvOGJiNDk1ZTNmMDI0
MDFlZTZmNzZkMWIxZDc3ZjNhYzlmMDc5ZTM3Ni9kbWVzZy15b2N0by1yb2FtLTI6MjAxNDAy
MjIyMTMwNTc6aTM4Ni1yYW5kY29uZmlnLXg0LTAyMjEyMzE2OjMuMTAuMDoxNzIKL2tlcm5l
bC9pMzg2LXJhbmRjb25maWcteDQtMDIyMTIzMTYvOGJiNDk1ZTNmMDI0MDFlZTZmNzZkMWIx
ZDc3ZjNhYzlmMDc5ZTM3Ni9kbWVzZy15b2N0by13YWltZWEtNDoyMDE0MDIyMzAyMDEyNjpp
Mzg2LXJhbmRjb25maWcteDQtMDIyMTIzMTY6My4xMC4wOjE3Mgova2VybmVsL2kzODYtcmFu
ZGNvbmZpZy14NC0wMjIxMjMxNi84YmI0OTVlM2YwMjQwMWVlNmY3NmQxYjFkNzdmM2FjOWYw
NzllMzc2L2RtZXNnLXlvY3RvLXJvYW0tNTg6MjAxNDAyMjMwMjM2Mzc6aTM4Ni1yYW5kY29u
ZmlnLXg0LTAyMjEyMzE2OjMuMTAuMDoxNzIKL2tlcm5lbC9pMzg2LXJhbmRjb25maWcteDQt
MDIyMTIzMTYvOGJiNDk1ZTNmMDI0MDFlZTZmNzZkMWIxZDc3ZjNhYzlmMDc5ZTM3Ni9kbWVz
Zy1xdWFudGFsLXJvYW0tMTk6MjAxNDAyMjIxNjEyMzY6aTM4Ni1yYW5kY29uZmlnLXg0LTAy
MjEyMzE2OjMuMTAuMDoxNzIKL2tlcm5lbC9pMzg2LXJhbmRjb25maWcteDQtMDIyMTIzMTYv
OGJiNDk1ZTNmMDI0MDFlZTZmNzZkMWIxZDc3ZjNhYzlmMDc5ZTM3Ni9kbWVzZy15b2N0by1y
b2FtLTE3OjIwMTQwMjIyMTkwMDE0OmkzODYtcmFuZGNvbmZpZy14NC0wMjIxMjMxNjozLjEw
LjA6MTcyCi9rZXJuZWwvaTM4Ni1yYW5kY29uZmlnLXg0LTAyMjEyMzE2LzhiYjQ5NWUzZjAy
NDAxZWU2Zjc2ZDFiMWQ3N2YzYWM5ZjA3OWUzNzYvZG1lc2cteW9jdG8tcm9hbS02MjoyMDE0
MDIyMjIxMTgzMjppMzg2LXJhbmRjb25maWcteDQtMDIyMTIzMTY6My4xMC4wOjE3Mgova2Vy
bmVsL2kzODYtcmFuZGNvbmZpZy14NC0wMjIxMjMxNi84YmI0OTVlM2YwMjQwMWVlNmY3NmQx
YjFkNzdmM2FjOWYwNzllMzc2L2RtZXNnLXF1YW50YWwtcm9hbS05OjIwMTQwMjIyMTQzNzMz
OmkzODYtcmFuZGNvbmZpZy14NC0wMjIxMjMxNjozLjEwLjA6MTcyCi9rZXJuZWwvaTM4Ni1y
YW5kY29uZmlnLXg0LTAyMjEyMzE2LzhiYjQ5NWUzZjAyNDAxZWU2Zjc2ZDFiMWQ3N2YzYWM5
ZjA3OWUzNzYvZG1lc2ctcXVhbnRhbC1yb2FtLTQ6MjAxNDAyMjMwMTQ2Mjk6aTM4Ni1yYW5k
Y29uZmlnLXg0LTAyMjEyMzE2OjMuMTAuMDoxNzIKL2tlcm5lbC9pMzg2LXJhbmRjb25maWct
eDQtMDIyMTIzMTYvOGJiNDk1ZTNmMDI0MDFlZTZmNzZkMWIxZDc3ZjNhYzlmMDc5ZTM3Ni9k
bWVzZy15b2N0by1yb2FtLTY0OjIwMTQwMjIyMTk0NTM1OmkzODYtcmFuZGNvbmZpZy14NC0w
MjIxMjMxNjozLjEwLjA6MTcyCi9rZXJuZWwvaTM4Ni1yYW5kY29uZmlnLXg0LTAyMjEyMzE2
LzhiYjQ5NWUzZjAyNDAxZWU2Zjc2ZDFiMWQ3N2YzYWM5ZjA3OWUzNzYvZG1lc2ctcXVhbnRh
bC1yb2FtLTM0OjIwMTQwMjIzMDIzNjM3OmkzODYtcmFuZGNvbmZpZy14NC0wMjIxMjMxNjoz
LjEwLjA6MTcyCi9rZXJuZWwvaTM4Ni1yYW5kY29uZmlnLXg0LTAyMjEyMzE2LzhiYjQ5NWUz
ZjAyNDAxZWU2Zjc2ZDFiMWQ3N2YzYWM5ZjA3OWUzNzYvZG1lc2cteW9jdG8tcm9hbS00Njoy
MDE0MDIyMjE4MzkzMDppMzg2LXJhbmRjb25maWcteDQtMDIyMTIzMTY6My4xMC4wOjE3Mgov
a2VybmVsL2kzODYtcmFuZGNvbmZpZy14NC0wMjIxMjMxNi84YmI0OTVlM2YwMjQwMWVlNmY3
NmQxYjFkNzdmM2FjOWYwNzllMzc2L2RtZXNnLXlvY3RvLXJvYW0tNDQ6MjAxNDAyMjIxNjEy
MzU6aTM4Ni1yYW5kY29uZmlnLXg0LTAyMjEyMzE2OjMuMTAuMDoxNzIKL2tlcm5lbC9pMzg2
LXJhbmRjb25maWcteDQtMDIyMTIzMTYvOGJiNDk1ZTNmMDI0MDFlZTZmNzZkMWIxZDc3ZjNh
YzlmMDc5ZTM3Ni9kbWVzZy15b2N0by1yb2FtLTUwOjIwMTQwMjIyMTk0OTA3OmkzODYtcmFu
ZGNvbmZpZy14NC0wMjIxMjMxNjozLjEwLjA6MTcyCi9rZXJuZWwvaTM4Ni1yYW5kY29uZmln
LXg0LTAyMjEyMzE2LzhiYjQ5NWUzZjAyNDAxZWU2Zjc2ZDFiMWQ3N2YzYWM5ZjA3OWUzNzYv
ZG1lc2cteW9jdG8tcm9hbS0zOToyMDE0MDIyMjIwMzEzNTppMzg2LXJhbmRjb25maWcteDQt
MDIyMTIzMTY6My4xMC4wOjE3Mgova2VybmVsL2kzODYtcmFuZGNvbmZpZy14NC0wMjIxMjMx
Ni84YmI0OTVlM2YwMjQwMWVlNmY3NmQxYjFkNzdmM2FjOWYwNzllMzc2L2RtZXNnLXlvY3Rv
LXJvYW0tNTM6MjAxNDAyMjIyMDM0NTE6aTM4Ni1yYW5kY29uZmlnLXg0LTAyMjEyMzE2OjMu
MTAuMDoxNzIKL2tlcm5lbC9pMzg2LXJhbmRjb25maWcteDQtMDIyMTIzMTYvOGJiNDk1ZTNm
MDI0MDFlZTZmNzZkMWIxZDc3ZjNhYzlmMDc5ZTM3Ni9kbWVzZy15b2N0by1yb2FtLTQ3OjIw
MTQwMjIyMTUwMTMxOmkzODYtcmFuZGNvbmZpZy14NC0wMjIxMjMxNjozLjEwLjA6MTcyCi9r
ZXJuZWwvaTM4Ni1yYW5kY29uZmlnLXg0LTAyMjEyMzE2LzhiYjQ5NWUzZjAyNDAxZWU2Zjc2
ZDFiMWQ3N2YzYWM5ZjA3OWUzNzYvZG1lc2ctcXVhbnRhbC1yb2FtLTM6MjAxNDAyMjIxOTM4
MTQ6aTM4Ni1yYW5kY29uZmlnLXg0LTAyMjEyMzE2OjMuMTAuMDoxNzIKL2tlcm5lbC9pMzg2
LXJhbmRjb25maWcteDQtMDIyMTIzMTYvOGJiNDk1ZTNmMDI0MDFlZTZmNzZkMWIxZDc3ZjNh
YzlmMDc5ZTM3Ni9kbWVzZy15b2N0by1yb2FtLTQ5OjIwMTQwMjIzMDE0NjI5OmkzODYtcmFu
ZGNvbmZpZy14NC0wMjIxMjMxNjozLjEwLjA6MTcyCi9rZXJuZWwvaTM4Ni1yYW5kY29uZmln
LXg0LTAyMjEyMzE2LzhiYjQ5NWUzZjAyNDAxZWU2Zjc2ZDFiMWQ3N2YzYWM5ZjA3OWUzNzYv
ZG1lc2ctcXVhbnRhbC1yb2FtLTM0OjIwMTQwMjIyMTkxODM5OmkzODYtcmFuZGNvbmZpZy14
NC0wMjIxMjMxNjozLjEwLjA6MTcyCi9rZXJuZWwvaTM4Ni1yYW5kY29uZmlnLXg0LTAyMjEy
MzE2LzhiYjQ5NWUzZjAyNDAxZWU2Zjc2ZDFiMWQ3N2YzYWM5ZjA3OWUzNzYvZG1lc2cteW9j
dG8tcm9hbS0zOjIwMTQwMjIzMDIwODQ3OmkzODYtcmFuZGNvbmZpZy14NC0wMjIxMjMxNjoz
LjEwLjA6MTcyCi9rZXJuZWwvaTM4Ni1yYW5kY29uZmlnLXg0LTAyMjEyMzE2LzhiYjQ5NWUz
ZjAyNDAxZWU2Zjc2ZDFiMWQ3N2YzYWM5ZjA3OWUzNzYvZG1lc2cteW9jdG8tcm9hbS01Mzoy
MDE0MDIyMzAxMTUwNDppMzg2LXJhbmRjb25maWcteDQtMDIyMTIzMTY6My4xMC4wOjE3Mgov
a2VybmVsL2kzODYtcmFuZGNvbmZpZy14NC0wMjIxMjMxNi84YmI0OTVlM2YwMjQwMWVlNmY3
NmQxYjFkNzdmM2FjOWYwNzllMzc2L2RtZXNnLXlvY3RvLXJvYW0tMjg6MjAxNDAyMjIxODI3
MjY6aTM4Ni1yYW5kY29uZmlnLXg0LTAyMjEyMzE2OjMuMTAuMDoxNzIKL2tlcm5lbC9pMzg2
LXJhbmRjb25maWcteDQtMDIyMTIzMTYvOGJiNDk1ZTNmMDI0MDFlZTZmNzZkMWIxZDc3ZjNh
YzlmMDc5ZTM3Ni9kbWVzZy15b2N0by13YWltZWEtNjoyMDE0MDIyMjE5MDUxNjppMzg2LXJh
bmRjb25maWcteDQtMDIyMTIzMTY6My4xMC4wOjE3Mgova2VybmVsL2kzODYtcmFuZGNvbmZp
Zy14NC0wMjIxMjMxNi84YmI0OTVlM2YwMjQwMWVlNmY3NmQxYjFkNzdmM2FjOWYwNzllMzc2
L2RtZXNnLXlvY3RvLXdhaW1lYS0xMzoyMDE0MDIyMjIxMjc1MTppMzg2LXJhbmRjb25maWct
eDQtMDIyMTIzMTY6My4xMC4wOjE3Mgova2VybmVsL2kzODYtcmFuZGNvbmZpZy14NC0wMjIx
MjMxNi84YmI0OTVlM2YwMjQwMWVlNmY3NmQxYjFkNzdmM2FjOWYwNzllMzc2L2RtZXNnLXF1
YW50YWwtcm9hbS01MToyMDE0MDIyMjE0MzgxNDppMzg2LXJhbmRjb25maWcteDQtMDIyMTIz
MTY6My4xMC4wOjE3Mgova2VybmVsL2kzODYtcmFuZGNvbmZpZy14NC0wMjIxMjMxNi84YmI0
OTVlM2YwMjQwMWVlNmY3NmQxYjFkNzdmM2FjOWYwNzllMzc2L2RtZXNnLXlvY3RvLXdhaW1l
YS0zOjIwMTQwMjIzMDE1NTQxOmkzODYtcmFuZGNvbmZpZy14NC0wMjIxMjMxNjozLjEwLjA6
MTcyCi9rZXJuZWwvaTM4Ni1yYW5kY29uZmlnLXg0LTAyMjEyMzE2LzhiYjQ5NWUzZjAyNDAx
ZWU2Zjc2ZDFiMWQ3N2YzYWM5ZjA3OWUzNzYvZG1lc2cteW9jdG8tcm9hbS0xOToyMDE0MDIy
MjE5NTAzNzppMzg2LXJhbmRjb25maWcteDQtMDIyMTIzMTY6My4xMC4wOjE3Mgova2VybmVs
L2kzODYtcmFuZGNvbmZpZy14NC0wMjIxMjMxNi84YmI0OTVlM2YwMjQwMWVlNmY3NmQxYjFk
NzdmM2FjOWYwNzllMzc2L2RtZXNnLXlvY3RvLXJvYW0tNTA6MjAxNDAyMjIxOTA3NDg6aTM4
Ni1yYW5kY29uZmlnLXg0LTAyMjEyMzE2OjMuMTAuMDoxNzIKL2tlcm5lbC9pMzg2LXJhbmRj
b25maWcteDQtMDIyMTIzMTYvOGJiNDk1ZTNmMDI0MDFlZTZmNzZkMWIxZDc3ZjNhYzlmMDc5
ZTM3Ni9kbWVzZy1xdWFudGFsLXdhaW1lYS02OjIwMTQwMjIyMTUwODAxOmkzODYtcmFuZGNv
bmZpZy14NC0wMjIxMjMxNjozLjEwLjA6MTcyCi9rZXJuZWwvaTM4Ni1yYW5kY29uZmlnLXg0
LTAyMjEyMzE2LzhiYjQ5NWUzZjAyNDAxZWU2Zjc2ZDFiMWQ3N2YzYWM5ZjA3OWUzNzYvZG1l
c2cteW9jdG8tcm9hbS0zNjoyMDE0MDIyMzAxMTUwNDppMzg2LXJhbmRjb25maWcteDQtMDIy
MTIzMTY6My4xMC4wOjE3Mgova2VybmVsL2kzODYtcmFuZGNvbmZpZy14NC0wMjIxMjMxNi84
YmI0OTVlM2YwMjQwMWVlNmY3NmQxYjFkNzdmM2FjOWYwNzllMzc2L2RtZXNnLXF1YW50YWwt
cm9hbS0xMToyMDE0MDIyMjE5MzcxNDppMzg2LXJhbmRjb25maWcteDQtMDIyMTIzMTY6My4x
MC4wOjE3Mgova2VybmVsL2kzODYtcmFuZGNvbmZpZy14NC0wMjIxMjMxNi84YmI0OTVlM2Yw
MjQwMWVlNmY3NmQxYjFkNzdmM2FjOWYwNzllMzc2L2RtZXNnLXF1YW50YWwtcm9hbS0zNzoy
MDE0MDIyMjE5MjU0NDppMzg2LXJhbmRjb25maWcteDQtMDIyMTIzMTY6My4xMC4wOjE3Mgov
a2VybmVsL2kzODYtcmFuZGNvbmZpZy14NC0wMjIxMjMxNi84YmI0OTVlM2YwMjQwMWVlNmY3
NmQxYjFkNzdmM2FjOWYwNzllMzc2L2RtZXNnLXlvY3RvLXdhaW1lYS01OjIwMTQwMjIyMTgw
MzI4OmkzODYtcmFuZGNvbmZpZy14NC0wMjIxMjMxNjozLjEwLjA6MTcyCi9rZXJuZWwvaTM4
Ni1yYW5kY29uZmlnLXg0LTAyMjEyMzE2LzhiYjQ5NWUzZjAyNDAxZWU2Zjc2ZDFiMWQ3N2Yz
YWM5ZjA3OWUzNzYvZG1lc2cteW9jdG8td2FpbWVhLTEyOjIwMTQwMjIyMTkzOTA1OmkzODYt
cmFuZGNvbmZpZy14NC0wMjIxMjMxNjozLjEwLjA6MTcyCjI4NTo3Mzo3NyBhbGxfZ29vZDpi
YWQ6YWxsX2JhZCBib290cwobWzE7MzVtMjAxNC0wMy0wMSAwNTo0NjozOSBSRVBFQVQgQ09V
TlQ6IDU5ICAjIC9jYy93ZmcvbmV0LWJpc2VjdC8ucmVwZWF0G1swbQoKYmlzZWN0OiBiYWQg
Y29tbWl0IHYzLjEwCmdpdCBjaGVja291dCB2My45CmxzIC1hIC9rZXJuZWwtdGVzdHMvcnVu
LXF1ZXVlL2t2bS9pMzg2LXJhbmRjb25maWcteDQtMDIyMTIzMTYvbmV4dDptYXN0ZXI6YzFi
ZTVhNWIxYjM1NWQ0MGU2Y2Y3OWNjOTc5ZWI2NmRhZmEyNGFkMTpiaXNlY3QtbmV0CgoyMDE0
LTAzLTAxLTA1OjQ2OjQ5IGMxYmU1YTViMWIzNTVkNDBlNmNmNzljYzk3OWViNjZkYWZhMjRh
ZDEgY29tcGlsaW5nCjc2IHJlYWwgIDk2NSB1c2VyICA5MCBzeXMgIDEzODguNzIlIGNwdSAJ
aTM4Ni1yYW5kY29uZmlnLXg0LTAyMjEyMzE2CgoyMDE0LTAzLTAxLTA1OjQ4OjI3IGRldGVj
dGluZyBib290IHN0YXRlIDMuOS4wLi4uCTQJMTAJMTMJMTYJMjMJNDIuLiBURVNUIEZBSUxV
UkUKWyAgICAwLjAxMDAwMF0gSW5pdGlhbGl6aW5nIENQVSMxClsgICAgMC4wMTAwMDBdIG1h
c2tlZCBFeHRJTlQgb24gQ1BVIzEKWyAgICAwLjAxMDAwMF0gLS0tLS0tLS0tLS0tWyBjdXQg
aGVyZSBdLS0tLS0tLS0tLS0tClsgICAgMC4wMTAwMDBdIFdBUk5JTkc6IGF0IGFyY2gveDg2
L2tlcm5lbC9jcHUvYW1kLmM6MjIxIGluaXRfYW1kKzB4MzFhLzB4NWYzKCkKL2tlcm5lbC9p
Mzg2LXJhbmRjb25maWcteDQtMDIyMTIzMTYvYzFiZTVhNWIxYjM1NWQ0MGU2Y2Y3OWNjOTc5
ZWI2NmRhZmEyNGFkMS9kbWVzZy1xdWFudGFsLXdhaW1lYS0xNToyMDE0MDMwMTA1NTMyMzpp
Mzg2LXJhbmRjb25maWcteDQtMDIyMTIzMTY6My45LjA6Mgova2VybmVsL2kzODYtcmFuZGNv
bmZpZy14NC0wMjIxMjMxNi9jMWJlNWE1YjFiMzU1ZDQwZTZjZjc5Y2M5NzllYjY2ZGFmYTI0
YWQxL2RtZXNnLXF1YW50YWwtd2FpbWVhLTg6MjAxNDAzMDEwNTUzMjM6aTM4Ni1yYW5kY29u
ZmlnLXg0LTAyMjEyMzE2OjMuOS4wOjIKNDI6MjoyIGFsbF9nb29kOmJhZDphbGxfYmFkIGJv
b3RzChtbMTszNW0yMDE0LTAzLTAxIDA1OjUzOjU4IFJFUEVBVCBDT1VOVDogMjMwICAjIC9j
Yy93ZmcvbmV0LWJpc2VjdC8ucmVwZWF0G1swbQoKYmlzZWN0OiBiYWQgY29tbWl0IHYzLjkK
Z2l0IGNoZWNrb3V0IHYzLjgKbHMgLWEgL2tlcm5lbC10ZXN0cy9ydW4tcXVldWUva3ZtL2kz
ODYtcmFuZGNvbmZpZy14NC0wMjIxMjMxNi9uZXh0Om1hc3RlcjoxOWY5NDlmNTI1OTliYTdj
M2Y2N2E1ODk3YWM2YmUxNGJmY2IxMjAwOmJpc2VjdC1uZXQKCjIwMTQtMDMtMDEtMDU6NTQ6
MDEgMTlmOTQ5ZjUyNTk5YmE3YzNmNjdhNTg5N2FjNmJlMTRiZmNiMTIwMCBjb21waWxpbmcK
NTYgcmVhbCAgODYzIHVzZXIgIDc3IHN5cyAgMTY1OS4yNiUgY3B1IAlpMzg2LXJhbmRjb25m
aWcteDQtMDIyMTIzMTYKCjIwMTQtMDMtMDEtMDU6NTU6MTUgZGV0ZWN0aW5nIGJvb3Qgc3Rh
dGUgMy44LjAuLi4JMi4gVEVTVCBGQUlMVVJFClsgICAxMi42Nzc0OTJdIGlydHRwX29wZW5f
dHNhcCgpLCBpbnZhbGlkIHRzYXAhClsgICAxMi42NzgwMjNdIGlyZGFfb3Blbl90c2FwKCks
IFVuYWJsZSB0byBhbGxvY2F0ZSBUU0FQIQpbICAgMTIuNjc4NjM2XSBpcmlhc19kZWxldGVf
b2JqZWN0KCksIG9iamVjdCBhbHJlYWR5IHJlbW92ZWQhClsgICAxMi43MjY3ODddIEJVRzog
dW5hYmxlIHRvIGhhbmRsZSBrZXJuZWwgcGFnaW5nIHJlcXVlc3QgYXQgYmUxYWU5MjgKWyAg
IDEyLjcyNzIzNF0gSVA6IFs8YzAyOTdmMDQ+XSBzdGF0aWNfa2V5X3Nsb3dfaW5jKzB4NC8w
eDgwClsgICAxMi43MjcyMzRdICpwZGUgPSAwMDAwMDAwMCAKWyAgIDEyLjcyNzIzNF0gT29w
czogMDAwMCBbIzFdIFNNUCBERUJVR19QQUdFQUxMT0MKWyAgIDEyLjcyNzIzNF0gUGlkOiAx
MTksIGNvbW06IHRyaW5pdHktbWFpbiBOb3QgdGFpbnRlZCAzLjguMCAjMyAgClsgICAxMi43
MjcyMzRdIEVJUDogMDA2MDpbPGMwMjk3ZjA0Pl0gRUZMQUdTOiAwMDAxMDI0NiBDUFU6IDAK
WyAgIDEyLjcyNzIzNF0gRUlQIGlzIGF0IHN0YXRpY19rZXlfc2xvd19pbmMrMHg0LzB4ODAK
WyAgIDEyLjcyNzIzNF0gRUFYOiBiZTFhZTkyOCBFQlg6IGM4NzExOGQ4IEVDWDogMDAwMDAw
MDAgRURYOiAwMDAwMDAwMQpbICAgMTIuNzI3MjM0XSBFU0k6IGZmYTRjNTMxIEVESTogMDAw
MDAwMDIgRUJQOiBjODVjYmU5MCBFU1A6IGM4NWNiZThjClsgICAxMi43MjcyMzRdICBEUzog
MDA3YiBFUzogMDA3YiBGUzogMDBkOCBHUzogMDAzMyBTUzogMDA2OApbICAgMTIuNzI3MjM0
XSBDUjA6IDgwMDUwMDNiIENSMjogYmUxYWU5MjggQ1IzOiAwODYzMTAwMCBDUjQ6IDAwMDAw
NmQwClsgICAxMi43MjcyMzRdIERSMDogMDAwMDAwMDAgRFIxOiAwMDAwMDAwMCBEUjI6IDAw
MDAwMDAwIERSMzogMDAwMDAwMDAKWyAgIDEyLjcyNzIzNF0gRFI2OiBmZmZmMGZmMCBEUjc6
IDAwMDEwNjAyClsgICAxMi43MjcyMzRdIFByb2Nlc3MgdHJpbml0eS1tYWluIChwaWQ6IDEx
OSwgdGk9Yzg1Y2EwMDAgdGFzaz1jODYzMjAwMCB0YXNrLnRpPWM4NWNhMDAwKQpbICAgMTIu
NzI3MjM0XSBTdGFjazoKWyAgIDEyLjcyNzIzNF0gIGM4NzExOGQ4IGM4NWNiZWE4IGMwMjhm
ZDgwIDAwMDAwMDAwIGMwOGU4YmMwIGM4NzExOGQ4IDAwMDAwMDAwIGM4NWNiZWQwClsgICAx
Mi43MjcyMzRdICBjMDI5NTAwOCAwMDAwMDAwMiAwMDAwMDAwMSAwMDAwMDAwMCBjMDI5NGVm
MCBjMDhlOGJjMCAwMDAwMDAwMCBjODcxMWEyMApbICAgMTIuNzI3MjM0XSAgYzg3MTE4ZDgg
Yzg1Y2JlZmMgYzAyOTUyYTAgYzg1Y2JlZGQgMDAwMDAyNDYgMDAwMDAwMDAgYzg2MzIwMDAg
Yzg1Y2JmNDAKWyAgIDEyLjcyNzIzNF0gQ2FsbCBUcmFjZToKWyAgIDEyLjcyNzIzNF0gIFs8
YzAyOGZkODA+XSBwZXJmX3N3ZXZlbnRfaW5pdCsweDcwLzB4MTUwClsgICAxMi43MjcyMzRd
ICBbPGMwMjk1MDA4Pl0gcGVyZl9pbml0X2V2ZW50KzB4MTE4LzB4MTMwClsgICAxMi43Mjcy
MzRdICBbPGMwMjk0ZWYwPl0gPyBwZXJmX3BtdV91bnJlZ2lzdGVyKzB4MTMwLzB4MTMwClsg
ICAxMi43MjcyMzRdICBbPGMwMjk1MmEwPl0gcGVyZl9ldmVudF9hbGxvYysweDI4MC8weDNj
MApbICAgMTIuNzI3MjM0XSAgWzxjMDI5NWJmOT5dIHN5c19wZXJmX2V2ZW50X29wZW4rMHg1
OTkvMHhhNjAKWyAgIDEyLjcyNzIzNF0gIFs8YzAyMjcwNWI+XSA/IF9fZG9fcGFnZV9mYXVs
dCsweDFjYi8weDQ1MApbICAgMTIuNzI3MjM0XSAgWzxjMDZkYThjYT5dIHN5c2VudGVyX2Rv
X2NhbGwrMHgxMi8weDM3ClsgICAxMi43MjcyMzRdIENvZGU6IGMwIGU4IDMxIGVlIDQzIDAw
IDVkIGMzIGViIDBkIDkwIDkwIDkwIDkwIDkwIDkwIDkwIDkwIDkwIDkwIDkwIDkwIDkwIDU1
IGI4IGMwIDhkIDhlIGMwIDg5IGU1IGU4IDczIGZiIDQzIDAwIDVkIGMzIDkwIDU1IDg5IGU1
IDUzIDw4Yj4gMTAgODkgYzMgODUgZDIgNzQgMTIgOGQgNGEgMDEgODkgZDAgZjAgMGYgYjEg
MGIgMzkgYzIgODkgYzEKWyAgIDEyLjcyNzIzNF0gRUlQOiBbPGMwMjk3ZjA0Pl0gc3RhdGlj
X2tleV9zbG93X2luYysweDQvMHg4MCBTUzpFU1AgMDA2ODpjODVjYmU4YwpbICAgMTIuNzI3
MjM0XSBDUjI6IDAwMDAwMDAwYmUxYWU5MjgKWyAgIDEyLjc1MTA0Ml0gLS0tWyBlbmQgdHJh
Y2UgNjk1OTEyNDA4ZTZiZWUxOSBdLS0tCgova2VybmVsL2kzODYtcmFuZGNvbmZpZy14NC0w
MjIxMjMxNi8xOWY5NDlmNTI1OTliYTdjM2Y2N2E1ODk3YWM2YmUxNGJmY2IxMjAwL2RtZXNn
LXF1YW50YWwtd2FpbWVhLTk6MjAxNDAzMDEwNTU3MzU6aTM4Ni1yYW5kY29uZmlnLXg0LTAy
MjEyMzE2OjMuOC4wOjMKMDoxOjMgYWxsX2dvb2Q6YmFkOmFsbF9iYWQgYm9vdHMKCmJpc2Vj
dDogYmFkIGNvbW1pdCB2My44CmdpdCBjaGVja291dCB2My43CmxzIC1hIC9rZXJuZWwtdGVz
dHMvcnVuLXF1ZXVlL2t2bS9pMzg2LXJhbmRjb25maWcteDQtMDIyMTIzMTYvbmV4dDptYXN0
ZXI6Mjk1OTQ0MDRkN2ZlNzNjZDgwZWFhNGVlOGM0M2RjYzUzOTcwYzYwZTpiaXNlY3QtbmV0
CgoyMDE0LTAzLTAxLTA1OjU3OjUxIDI5NTk0NDA0ZDdmZTczY2Q4MGVhYTRlZThjNDNkY2M1
Mzk3MGM2MGUgY29tcGlsaW5nCjYxIHJlYWwgIDg0NCB1c2VyICA3NyBzeXMgIDE1MDIuMTEl
IGNwdSAJaTM4Ni1yYW5kY29uZmlnLXg0LTAyMjEyMzE2CgoyMDE0LTAzLTAxLTA1OjU5OjAy
IGRldGVjdGluZyBib290IHN0YXRlIDMuNy4wLi4JMQkzCTUJOAk5CTE1CTE4CTIwCTI0CTI4
CTI5CTMwCTM0CTM3CTQyCTQ4CTUwCTUxCTUzCTU1CTU2CTU3CTYxCTY1CTczCTc0Lgk3OAk4
Mgk4NAk4Ngk5OAkxMDYJMTA5CTExMQkxMTQJMTI1IFRFU1QgRkFJTFVSRQpbICAgMTMuNTYz
ODU3XSBpcnR0cF9vcGVuX3RzYXAoKSwgaW52YWxpZCB0c2FwIQpbICAgMTMuNTY0NjE3XSBp
cmRhX29wZW5fdHNhcCgpLCBVbmFibGUgdG8gYWxsb2NhdGUgVFNBUCEKWyAgIDEzLjU2NTQz
MF0gaXJpYXNfZGVsZXRlX29iamVjdCgpLCBvYmplY3QgYWxyZWFkeSByZW1vdmVkIQpbICAg
MTMuNTkzMzEzXSBCVUc6IHVuYWJsZSB0byBoYW5kbGUga2VybmVsIHBhZ2luZyByZXF1ZXN0
IGF0IGU4ZjI4ZWUwClsgICAxMy41OTM5MzBdIElQOiBbPGMwMjkzYzA0Pl0gc3RhdGljX2tl
eV9zbG93X2luYysweDQvMHg4MApbICAgMTMuNTkzOTMwXSAqcGRlID0gMDAwMDAwMDAgClsg
ICAxMy41OTM5MzBdIE9vcHM6IDAwMDAgWyMxXSBTTVAgREVCVUdfUEFHRUFMTE9DClsgICAx
My41OTM5MzBdIFBpZDogMTE5LCBjb21tOiB0cmluaXR5LW1haW4gTm90IHRhaW50ZWQgMy43
LjAgIzQgIApbICAgMTMuNTkzOTMwXSBFSVA6IDAwNjA6WzxjMDI5M2MwND5dIEVGTEFHUzog
MDAwMTAyNDYgQ1BVOiAxClsgICAxMy41OTM5MzBdIEVJUCBpcyBhdCBzdGF0aWNfa2V5X3Ns
b3dfaW5jKzB4NC8weDgwClsgICAxMy41OTM5MzBdIEVBWDogZThmMjhlZTAgRUJYOiBjODI0
NTdhOCBFQ1g6IDAwMDAwMDAwIEVEWDogMDAwMDAwMDEKWyAgIDEzLjU5MzkzMF0gRVNJOiA4
NTAwMDAwMCBFREk6IDAwMDAwMDAyIEVCUDogYzgwYTllYTQgRVNQOiBjODBhOWVhMApbICAg
MTMuNTkzOTMwXSAgRFM6IDAwN2IgRVM6IDAwN2IgRlM6IDAwZDggR1M6IDAwMzMgU1M6IDAw
NjgKWyAgIDEzLjU5MzkzMF0gQ1IwOiA4MDA1MDAzYiBDUjI6IGU4ZjI4ZWUwIENSMzogMDgx
MzUwMDAgQ1I0OiAwMDAwMDZkMApbICAgMTMuNTkzOTMwXSBEUjA6IDAwMDAwMDAwIERSMTog
MDAwMDAwMDAgRFIyOiAwMDAwMDAwMCBEUjM6IDAwMDAwMDAwClsgICAxMy41OTM5MzBdIERS
NjogZmZmZjBmZjAgRFI3OiAwMDAwMDQwMApbICAgMTMuNTkzOTMwXSBQcm9jZXNzIHRyaW5p
dHktbWFpbiAocGlkOiAxMTksIHRpPWM4MGE4MDAwIHRhc2s9YzgxMzQwMDAgdGFzay50aT1j
ODBhODAwMCkKWyAgIDEzLjU5MzkzMF0gU3RhY2s6ClsgICAxMy41OTM5MzBdICBjODI0NTdh
OCBjODBhOWViYyBjMDI4YmFhMCAwMDAwMDAwMCBjMDhjYTg0MCBjODI0NTdhOCAwMDAwMDAw
MCBjODBhOWVlNApbICAgMTMuNTkzOTMwXSAgYzAyOTBkMjggMDAwMDAwMDIgMDAwMDAwMDEg
MDAwMDAwMDAgYzAyOTBjMTAgYzA4Y2E4NDAgZmJkZmZkZmIgYzgyNDU4ZjAKWyAgIDEzLjU5
MzkzMF0gIGM4MjQ1N2E4IGM4MGE5ZjAwIGMwMjkwZmM4IGM4MGE5ZjQwIGM4MjQ1N2E4IDAw
MDAwMDc3IGM4MTM0MDAwIGM4MGE5ZmEwClsgICAxMy41OTM5MzBdIENhbGwgVHJhY2U6Clsg
ICAxMy41OTM5MzBdICBbPGMwMjhiYWEwPl0gcGVyZl9zd2V2ZW50X2luaXQrMHg3MC8weDE1
MApbICAgMTMuNTkzOTMwXSAgWzxjMDI5MGQyOD5dIHBlcmZfaW5pdF9ldmVudCsweDExOC8w
eDEzMApbICAgMTMuNTkzOTMwXSAgWzxjMDI5MGMxMD5dID8gcGVyZl9wbXVfdW5yZWdpc3Rl
cisweDEzMC8weDEzMApbICAgMTMuNTkzOTMwXSAgWzxjMDI5MGZjOD5dIHBlcmZfZXZlbnRf
YWxsb2MrMHgyODgvMHgzZDAKWyAgIDEzLjU5MzkzMF0gIFs8YzAyOTE5Mzk+XSBzeXNfcGVy
Zl9ldmVudF9vcGVuKzB4NWE5LzB4YTMwClsgICAxMy41OTM5MzBdICBbPGMwMjI2YmViPl0g
PyBfX2RvX3BhZ2VfZmF1bHQrMHgxY2IvMHg0NTAKWyAgIDEzLjU5MzkzMF0gIFs8YzA2YzI5
MGE+XSBzeXNlbnRlcl9kb19jYWxsKzB4MTIvMHgzNwpbICAgMTMuNTkzOTMwXSBDb2RlOiBj
MCBlOCA4MSBiMSA0MiAwMCA1ZCBjMyBlYiAwZCA5MCA5MCA5MCA5MCA5MCA5MCA5MCA5MCA5
MCA5MCA5MCA5MCA5MCA1NSBiOCA0MCBhYSA4YyBjMCA4OSBlNSBlOCBjMyBiZSA0MiAwMCA1
ZCBjMyA5MCA1NSA4OSBlNSA1MyA8OGI+IDEwIDg5IGMzIDg1IGQyIDc0IDEyIDhkIDRhIDAx
IDg5IGQwIGYwIDBmIGIxIDBiIDM5IGMyIDg5IGMxClsgICAxMy41OTM5MzBdIEVJUDogWzxj
MDI5M2MwND5dIHN0YXRpY19rZXlfc2xvd19pbmMrMHg0LzB4ODAgU1M6RVNQIDAwNjg6Yzgw
YTllYTAKWyAgIDEzLjU5MzkzMF0gQ1IyOiAwMDAwMDAwMGU4ZjI4ZWUwClsgICAxMy41OTM5
MzBdIC0tLVsgZW5kIHRyYWNlIDI4MDdiYTRhZTU4ZTlhN2MgXS0tLQpbICAgMTMuNTkzOTMw
XSBCVUc6IHNsZWVwaW5nIGZ1bmN0aW9uIGNhbGxlZCBmcm9tIGludmFsaWQgY29udGV4dCBh
dCBrZXJuZWwvcndzZW0uYzoyMAova2VybmVsL2kzODYtcmFuZGNvbmZpZy14NC0wMjIxMjMx
Ni8yOTU5NDQwNGQ3ZmU3M2NkODBlYWE0ZWU4YzQzZGNjNTM5NzBjNjBlL2RtZXNnLXF1YW50
YWwtd2FpbWVhLTEwOjIwMTQwMzAxMDYxODIwOmkzODYtcmFuZGNvbmZpZy14NC0wMjIxMjMx
NjozLjcuMDo0CjYyOjE6NjQgYWxsX2dvb2Q6YmFkOmFsbF9iYWQgYm9vdHMKG1sxOzM1bTIw
MTQtMDMtMDEgMDY6MTg6MzQgUkVQRUFUIENPVU5UOiAxMDAwICAjIC9jYy93ZmcvbmV0LWJp
c2VjdC8ucmVwZWF0G1swbQoKYmlzZWN0OiBiYWQgY29tbWl0IHYzLjcKZ2l0IGNoZWNrb3V0
IHYzLjYKbHMgLWEgL2tlcm5lbC10ZXN0cy9ydW4tcXVldWUva3ZtL2kzODYtcmFuZGNvbmZp
Zy14NC0wMjIxMjMxNi9uZXh0Om1hc3RlcjphMGQyNzFjYmZlZDFkZDUwMjc4YzZiMDZiZWFk
M2QwMGJhMGE4OGY5OmJpc2VjdC1uZXQKCjIwMTQtMDMtMDEtMDY6MTg6NDEgYTBkMjcxY2Jm
ZWQxZGQ1MDI3OGM2YjA2YmVhZDNkMDBiYTBhODhmOSBjb21waWxpbmcKNjAgcmVhbCAgNzg3
IHVzZXIgIDczIHN5cyAgMTQxMy4zOCUgY3B1IAlpMzg2LXJhbmRjb25maWcteDQtMDIyMTIz
MTYKCjIwMTQtMDMtMDEtMDY6MTk6NTYgZGV0ZWN0aW5nIGJvb3Qgc3RhdGUgMy42LjAuCTQJ
NQk3CTEzLgkxNwkxOQkyMAkyNAkyNwkzMwkzNSBURVNUIEZBSUxVUkUKWyAgIDEyLjQ5NzYx
OV0gaXJ0dHBfb3Blbl90c2FwKCksIGludmFsaWQgdHNhcCEKWyAgIDEyLjQ5ODA4Nl0gaXJk
YV9vcGVuX3RzYXAoKSwgVW5hYmxlIHRvIGFsbG9jYXRlIFRTQVAhClsgICAxMi40OTg2NjNd
IGlyaWFzX2RlbGV0ZV9vYmplY3QoKSwgb2JqZWN0IGFscmVhZHkgcmVtb3ZlZCEKWyAgIDEy
LjU0MTE5OV0gQlVHOiB1bmFibGUgdG8gaGFuZGxlIGtlcm5lbCBwYWdpbmcgcmVxdWVzdCBh
dCBlNGQ3OGE5OApbICAgMTIuNTQxNTExXSBJUDogWzxjMDI5MTU4ND5dIHN0YXRpY19rZXlf
c2xvd19pbmMrMHg0LzB4ODAKWyAgIDEyLjU0MTUxMV0gKnBkZSA9IDAwMDAwMDAwIApbICAg
MTIuNTQxNTExXSBPb3BzOiAwMDAwIFsjMV0gU01QIERFQlVHX1BBR0VBTExPQwpbICAgMTIu
NTQxNTExXSBQaWQ6IDExNywgY29tbTogdHJpbml0eS1tYWluIE5vdCB0YWludGVkIDMuNi4w
ICM1ICAKWyAgIDEyLjU0MTUxMV0gRUlQOiAwMDYwOls8YzAyOTE1ODQ+XSBFRkxBR1M6IDAw
MDEwMjQ2IENQVTogMApbICAgMTIuNTQxNTExXSBFSVAgaXMgYXQgc3RhdGljX2tleV9zbG93
X2luYysweDQvMHg4MApbICAgMTIuNTQxNTExXSBFQVg6IGU0ZDc4YTk4IEVCWDogYzgwY2Iw
MDggRUNYOiAwMDAwMDAwMCBFRFg6IDAwMDAwMDAxClsgICAxMi41NDE1MTFdIEVTSTogYTQ3
ZDQ1NzMgRURJOiAwMDAwMDAwMiBFQlA6IGM4N2VkZWIwIEVTUDogYzg3ZWRlYWMKWyAgIDEy
LjU0MTUxMV0gIERTOiAwMDdiIEVTOiAwMDdiIEZTOiAwMGQ4IEdTOiAwMDMzIFNTOiAwMDY4
ClsgICAxMi41NDE1MTFdIENSMDogODAwNTAwM2IgQ1IyOiBlNGQ3OGE5OCBDUjM6IDA4N2U3
MDAwIENSNDogMDAwMDA2ZDAKWyAgIDEyLjU0MTUxMV0gRFIwOiAwMDAwMDAwMCBEUjE6IDAw
MDAwMDAwIERSMjogMDAwMDAwMDAgRFIzOiAwMDAwMDAwMApbICAgMTIuNTQxNTExXSBEUjY6
IGZmZmYwZmYwIERSNzogMDAwMDA0MDAKWyAgIDEyLjU0MTUxMV0gUHJvY2VzcyB0cmluaXR5
LW1haW4gKHBpZDogMTE3LCB0aT1jODdlYzAwMCB0YXNrPWM4N2U2MDAwIHRhc2sudGk9Yzg3
ZWMwMDApClsgICAxMi41NDE1MTFdIFN0YWNrOgpbICAgMTIuNTQxNTExXSAgYzgwY2IwMDgg
Yzg3ZWRlYzggYzAyODk5ZTAgMDAwMDAwMDAgYzA4ODE4YzAgYzgwY2IwMDggMDAwMDAwMDAg
Yzg3ZWRlZjAKWyAgIDEyLjU0MTUxMV0gIGMwMjhlODU4IDAwMDAwMDAyIDAwMDAwMDAxIDAw
MDAwMDAwIGMwMjhlNzQwIGMwODgxOGMwIDAwMDAwMDAwIGM4MGNiMTQwClsgICAxMi41NDE1
MTFdICBjODBjYjAwOCBjODdlZGYwYyBjMDI4ZWFmOCBjODdlZGY1MCBjODBjYjAwOCAwMDAw
MDAwMCBjODdlNjAwMCAwMDAwMDAwMApbICAgMTIuNTQxNTExXSBDYWxsIFRyYWNlOgpbICAg
MTIuNTQxNTExXSAgWzxjMDI4OTllMD5dIHBlcmZfc3dldmVudF9pbml0KzB4NzAvMHgxNTAK
WyAgIDEyLjU0MTUxMV0gIFs8YzAyOGU4NTg+XSBwZXJmX2luaXRfZXZlbnQrMHgxMTgvMHgx
MzAKWyAgIDEyLjU0MTUxMV0gIFs8YzAyOGU3NDA+XSA/IHBlcmZfcG11X3VucmVnaXN0ZXIr
MHgxMzAvMHgxMzAKWyAgIDEyLjU0MTUxMV0gIFs8YzAyOGVhZjg+XSBwZXJmX2V2ZW50X2Fs
bG9jKzB4Mjg4LzB4M2QwClsgICAxMi41NDE1MTFdICBbPGMwMjhmNDJlPl0gc3lzX3BlcmZf
ZXZlbnRfb3BlbisweDU2ZS8weDk4MApbICAgMTIuNTQxNTExXSAgWzxjMDY4ZGYxYz5dIHN5
c2VudGVyX2RvX2NhbGwrMHgxMi8weDM3ClsgICAxMi41NDE1MTFdIENvZGU6IGMwIGU4IDYx
IDhmIDNmIDAwIDVkIGMzIGViIDBkIDkwIDkwIDkwIDkwIDkwIDkwIDkwIDkwIDkwIDkwIDkw
IDkwIDkwIDU1IGI4IGMwIDFhIDg4IGMwIDg5IGU1IGU4IGEzIDljIDNmIDAwIDVkIGMzIDkw
IDU1IDg5IGU1IDUzIDw4Yj4gMTAgODkgYzMgODUgZDIgNzQgMTIgOGQgNGEgMDEgODkgZDAg
ZjAgMGYgYjEgMGIgMzkgYzIgODkgYzEKWyAgIDEyLjU0MTUxMV0gRUlQOiBbPGMwMjkxNTg0
Pl0gc3RhdGljX2tleV9zbG93X2luYysweDQvMHg4MCBTUzpFU1AgMDA2ODpjODdlZGVhYwpb
ICAgMTIuNTQxNTExXSBDUjI6IDAwMDAwMDAwZTRkNzhhOTgKWyAgIDEyLjU0MTUxMV0gLS0t
WyBlbmQgdHJhY2UgZGVkODgyNDA5MWM4NWIwYiBdLS0tClsgICAxMi41NDE1MTFdIEJVRzog
c2xlZXBpbmcgZnVuY3Rpb24gY2FsbGVkIGZyb20gaW52YWxpZCBjb250ZXh0IGF0IGtlcm5l
bC9yd3NlbS5jOjIwCi9rZXJuZWwvaTM4Ni1yYW5kY29uZmlnLXg0LTAyMjEyMzE2L2EwZDI3
MWNiZmVkMWRkNTAyNzhjNmIwNmJlYWQzZDAwYmEwYTg4ZjkvZG1lc2cteW9jdG8td2FpbWVh
LTEyOjIwMTQwMzAxMDYyNjAzOmkzODYtcmFuZGNvbmZpZy14NC0wMjIxMjMxNjozLjYuMDo1
CjE2OjE6MjAgYWxsX2dvb2Q6YmFkOmFsbF9iYWQgYm9vdHMKCmJpc2VjdDogYmFkIGNvbW1p
dCB2My42CmdpdCBjaGVja291dCB2My41CmxzIC1hIC9rZXJuZWwtdGVzdHMvcnVuLXF1ZXVl
L2t2bS9pMzg2LXJhbmRjb25maWcteDQtMDIyMTIzMTYvbmV4dDptYXN0ZXI6MjhhMzNjYmMy
NGU0MjU2YzE0M2RjZTk2YzdkOTNiZjQyMzIyOWY5MjpiaXNlY3QtbmV0CgoyMDE0LTAzLTAx
LTA2OjI2OjMzIDI4YTMzY2JjMjRlNDI1NmMxNDNkY2U5NmM3ZDkzYmY0MjMyMjlmOTIgY29t
cGlsaW5nCjU4IHJlYWwgIDc3MyB1c2VyICA3MCBzeXMgIDE0MzguNzYlIGNwdSAJaTM4Ni1y
YW5kY29uZmlnLXg0LTAyMjEyMzE2CgoyMDE0LTAzLTAxLTA2OjI3OjQ1IGRldGVjdGluZyBi
b290IHN0YXRlIDMuNS4wLi4JMQk0CTYgVEVTVCBGQUlMVVJFClsgICAxMi4wMjEzMjRdIGly
dHRwX29wZW5fdHNhcCgpLCBpbnZhbGlkIHRzYXAhClsgICAxMi4wMjE5NzldIGlyZGFfb3Bl
bl90c2FwKCksIFVuYWJsZSB0byBhbGxvY2F0ZSBUU0FQIQpbICAgMTIuMDIyNzMxXSBpcmlh
c19kZWxldGVfb2JqZWN0KCksIG9iamVjdCBhbHJlYWR5IHJlbW92ZWQhClsgICAxMi4zOTAz
MDVdIEJVRzogdW5hYmxlIHRvIGhhbmRsZSBrZXJuZWwgcGFnaW5nIHJlcXVlc3QgYXQgYWVi
YzY4MDgKWyAgIDEyLjM5MDk2MF0gSVA6IFs8YzAyOGNiNjQ+XSBzdGF0aWNfa2V5X3Nsb3df
aW5jKzB4NC8weDgwClsgICAxMi4zOTA5NjBdICpwZGUgPSAwMDAwMDAwMCAKWyAgIDEyLjM5
MDk2MF0gT29wczogMDAwMCBbIzFdIFNNUCBERUJVR19QQUdFQUxMT0MKWyAgIDEyLjM5MDk2
MF0gClsgICAxMi4zOTA5NjBdIFBpZDogMTE0LCBjb21tOiB0cmluaXR5LW1haW4gTm90IHRh
aW50ZWQgMy41LjAgIzYgIApbICAgMTIuMzkwOTYwXSBFSVA6IDAwNjA6WzxjMDI4Y2I2ND5d
IEVGTEFHUzogMDAwMTAyNDYgQ1BVOiAwClsgICAxMi4zOTA5NjBdIEVJUCBpcyBhdCBzdGF0
aWNfa2V5X3Nsb3dfaW5jKzB4NC8weDgwClsgICAxMi4zOTA5NjBdIEVBWDogYWViYzY4MDgg
RUJYOiBjODZhODZjOCBFQ1g6IDAwMDAwMDAwIEVEWDogMDAwMDAwMDEKWyAgIDEyLjM5MDk2
MF0gRVNJOiBmZGJhMzAzNSBFREk6IDAwMDAwMDAyIEVCUDogYzg1NzNlYjAgRVNQOiBjODU3
M2VhYwpbICAgMTIuMzkwOTYwXSAgRFM6IDAwN2IgRVM6IDAwN2IgRlM6IDAwZDggR1M6IDAw
MzMgU1M6IDAwNjgKWyAgIDEyLjM5MDk2MF0gQ1IwOiA4MDA1MDAzYiBDUjI6IGFlYmM2ODA4
IENSMzogMDg1Y2YwMDAgQ1I0OiAwMDAwMDZkMApbICAgMTIuMzkwOTYwXSBEUjA6IDA4MGQz
MDAwIERSMTogMDAwMDAwMDAgRFIyOiAwMDAwMDAwMCBEUjM6IDAwMDAwMDAwClsgICAxMi4z
OTA5NjBdIERSNjogZmZmZjBmZjAgRFI3OiAwMDA3MDYwMgpbICAgMTIuMzkwOTYwXSBQcm9j
ZXNzIHRyaW5pdHktbWFpbiAocGlkOiAxMTQsIHRpPWM4NTcyMDAwIHRhc2s9Yzg1NTEwMDAg
dGFzay50aT1jODU3MjAwMCkKWyAgIDEyLjM5MDk2MF0gU3RhY2s6ClsgICAxMi4zOTA5NjBd
ICBjODZhODZjOCBjODU3M2VjOCBjMDI4NTJlMCAwMDAwMDAwMCBjMDg1ZDFhMCBjODZhODZj
OCAwMDAwMDAwMCBjODU3M2VmMApbICAgMTIuMzkwOTYwXSAgYzAyOGEwNjggMDAwMDAwMDIg
MDAwMDAwMDEgMDAwMDAwMDAgYzAyODlmNTAgYzA4NWQxYTAgMDAwMDAwMDAgYzg2YTg4MDAK
WyAgIDEyLjM5MDk2MF0gIGM4NmE4NmM4IGM4NTczZjBjIGMwMjhhMzAwIGM4NTczZjUwIGM4
NmE4NmM4IDAwMDAwMDAwIGM4NTUxMDAwIDAwMDAwMDAwClsgICAxMi4zOTA5NjBdIENhbGwg
VHJhY2U6ClsgICAxMi4zOTA5NjBdICBbPGMwMjg1MmUwPl0gcGVyZl9zd2V2ZW50X2luaXQr
MHg3MC8weDE1MApbICAgMTIuMzkwOTYwXSAgWzxjMDI4YTA2OD5dIHBlcmZfaW5pdF9ldmVu
dCsweDExOC8weDEzMApbICAgMTIuMzkwOTYwXSAgWzxjMDI4OWY1MD5dID8gcGVyZl9wbXVf
dW5yZWdpc3RlcisweDEzMC8weDEzMApbICAgMTIuMzkwOTYwXSAgWzxjMDI4YTMwMD5dIHBl
cmZfZXZlbnRfYWxsb2MrMHgyODAvMHgzYzAKWyAgIDEyLjM5MDk2MF0gIFs8YzAyOGFiYjk+
XSBzeXNfcGVyZl9ldmVudF9vcGVuKzB4NTQ5LzB4OTQwClsgICAxMi4zOTA5NjBdICBbPGMw
NjdiMjFjPl0gc3lzZW50ZXJfZG9fY2FsbCsweDEyLzB4MzcKWyAgIDEyLjM5MDk2MF0gQ29k
ZTogYzAgZTggYTEgYTYgM2UgMDAgNWQgYzMgZWIgMGQgOTAgOTAgOTAgOTAgOTAgOTAgOTAg
OTAgOTAgOTAgOTAgOTAgOTAgNTUgYjggYTAgZDMgODUgYzAgODkgZTUgZTggZTMgYjMgM2Ug
MDAgNWQgYzMgOTAgNTUgODkgZTUgNTMgPDhiPiAxMCA4OSBjMyA4NSBkMiA3NCAxMiA4ZCA0
YSAwMSA4OSBkMCBmMCAwZiBiMSAwYiAzOSBjMiA4OSBjMSAKWyAgIDEyLjM5MDk2MF0gRUlQ
OiBbPGMwMjhjYjY0Pl0gc3RhdGljX2tleV9zbG93X2luYysweDQvMHg4MCBTUzpFU1AgMDA2
ODpjODU3M2VhYwpbICAgMTIuMzkwOTYwXSBDUjI6IDAwMDAwMDAwYWViYzY4MDgKWyAgIDEy
LjQxOTE2Ml0gLS0tWyBlbmQgdHJhY2UgNmZhN2EwZWM0OTQwM2YxMyBdLS0tCgova2VybmVs
L2kzODYtcmFuZGNvbmZpZy14NC0wMjIxMjMxNi8yOGEzM2NiYzI0ZTQyNTZjMTQzZGNlOTZj
N2Q5M2JmNDIzMjI5ZjkyL2RtZXNnLXF1YW50YWwtd2FpbWVhLTEyOjIwMTQwMzAxMDYzMDAx
OmkzODYtcmFuZGNvbmZpZy14NC0wMjIxMjMxNjozLjUuMDo2CjI6MTo1IGFsbF9nb29kOmJh
ZDphbGxfYmFkIGJvb3RzCgpiaXNlY3Q6IGJhZCBjb21taXQgdjMuNQpnaXQgY2hlY2tvdXQg
djMuNApscyAtYSAva2VybmVsLXRlc3RzL3J1bi1xdWV1ZS9rdm0vaTM4Ni1yYW5kY29uZmln
LXg0LTAyMjEyMzE2L25leHQ6bWFzdGVyOjc2ZTEwZDE1OGVmYjZkNDUxNjAxODg0NmY2MGMy
YWI1NTAxOTAwYmM6YmlzZWN0LW5ldAoKMjAxNC0wMy0wMS0wNjozMDoyMCA3NmUxMGQxNThl
ZmI2ZDQ1MTYwMTg4NDZmNjBjMmFiNTUwMTkwMGJjIGNvbXBpbGluZwo1NiByZWFsICA3NDIg
dXNlciAgNjYgc3lzICAxNDI0LjkwJSBjcHUgCWkzODYtcmFuZGNvbmZpZy14NC0wMjIxMjMx
NgoKMjAxNC0wMy0wMS0wNjozMToyNyBkZXRlY3RpbmcgYm9vdCBzdGF0ZSAzLjQuMAk1Lgkx
MwkxNgkyNwkyOQkzNgk0OAk1OAk2MiBURVNUIEZBSUxVUkUKWyAgIDEyLjg2MzY4NV0gaXJ0
dHBfb3Blbl90c2FwKCksIGludmFsaWQgdHNhcCEKWyAgIDEyLjg2NDQzM10gaXJkYV9vcGVu
X3RzYXAoKSwgVW5hYmxlIHRvIGFsbG9jYXRlIFRTQVAhClsgICAxMi44NjU0NTBdIGlyaWFz
X2RlbGV0ZV9vYmplY3QoKSwgb2JqZWN0IGFscmVhZHkgcmVtb3ZlZCEKWyAgIDEyLjkzMzY5
OV0gQlVHOiB1bmFibGUgdG8gaGFuZGxlIGtlcm5lbCBwYWdpbmcgcmVxdWVzdCBhdCA0MGYw
OWI5OApbICAgMTIuOTM0NTA3XSBJUDogWzxjMDI4ODAwND5dIHN0YXRpY19rZXlfc2xvd19p
bmMrMHg0LzB4ODAKWyAgIDEyLjkzNDUwN10gKnBkZSA9IDAwMDAwMDAwIApbICAgMTIuOTM0
NTA3XSBPb3BzOiAwMDAwIFsjMV0gU01QIERFQlVHX1BBR0VBTExPQwpbICAgMTIuOTM0NTA3
XSAKWyAgIDEyLjkzNDUwN10gUGlkOiAxMTQsIGNvbW06IHRyaW5pdHktbWFpbiBOb3QgdGFp
bnRlZCAzLjQuMCAjNyAgClsgICAxMi45MzQ1MDddIEVJUDogMDA2MDpbPGMwMjg4MDA0Pl0g
RUZMQUdTOiAwMDAxMDI0NiBDUFU6IDAKWyAgIDEyLjkzNDUwN10gRUlQIGlzIGF0IHN0YXRp
Y19rZXlfc2xvd19pbmMrMHg0LzB4ODAKWyAgIDEyLjkzNDUwN10gRUFYOiA0MGYwOWI5OCBF
Qlg6IGM4NmJiOWE4IEVDWDogMDAwMDAwMDAgRURYOiAwMDAwMDAwMQpbICAgMTIuOTM0NTA3
XSBFU0k6IGQwMDBmZmZmIEVESTogMDAwMDAwMDIgRUJQOiBjODVmM2ViNCBFU1A6IGM4NWYz
ZWIwClsgICAxMi45MzQ1MDddICBEUzogMDA3YiBFUzogMDA3YiBGUzogMDBkOCBHUzogMDAz
MyBTUzogMDA2OApbICAgMTIuOTM0NTA3XSBDUjA6IDgwMDUwMDNiIENSMjogNDBmMDliOTgg
Q1IzOiAwODVlOTAwMCBDUjQ6IDAwMDAwNmQwClsgICAxMi45MzQ1MDddIERSMDogMDAwMDAw
MDAgRFIxOiAwMDAwMDAwMCBEUjI6IDAwMDAwMDAwIERSMzogMDAwMDAwMDAKWyAgIDEyLjkz
NDUwN10gRFI2OiBmZmZmMGZmMCBEUjc6IDAwMDAwNDAwClsgICAxMi45MzQ1MDddIFByb2Nl
c3MgdHJpbml0eS1tYWluIChwaWQ6IDExNCwgdGk9Yzg1ZjIwMDAgdGFzaz1jODVlODAwMCB0
YXNrLnRpPWM4NWYyMDAwKQpbICAgMTIuOTM0NTA3XSBTdGFjazoKWyAgIDEyLjkzNDUwN10g
IGM4NmJiOWE4IGM4NWYzZWNjIGMwMjgwN2MwIDAwMDAwMDAwIGMwODNlZWMwIGM4NmJiOWE4
IDAwMDAwMDAwIGM4NWYzZWY0ClsgICAxMi45MzQ1MDddICBjMDI4NTU0OCAwMDAwMDAwMiAw
MDAwMDAwMSAwMDAwMDAwMCBjMDI4NTQzMCBjMDgzZWVjMCAwMDAwMDAwMCBjODZiYmFlMApb
ICAgMTIuOTM0NTA3XSAgYzg2YmI5YTggYzg1ZjNmMTAgYzAyODU3ZTAgYzg1ZjNmNTAgYzg2
YmI5YTggMDAwMDAwMDAgYzg1ZTgwMDAgMDAwMDAwMDAKWyAgIDEyLjkzNDUwN10gQ2FsbCBU
cmFjZToKWyAgIDEyLjkzNDUwN10gIFs8YzAyODA3YzA+XSBwZXJmX3N3ZXZlbnRfaW5pdCsw
eDcwLzB4MTUwClsgICAxMi45MzQ1MDddICBbPGMwMjg1NTQ4Pl0gcGVyZl9pbml0X2V2ZW50
KzB4MTE4LzB4MTMwClsgICAxMi45MzQ1MDddICBbPGMwMjg1NDMwPl0gPyBwZXJmX3BtdV91
bnJlZ2lzdGVyKzB4MTMwLzB4MTMwClsgICAxMi45MzQ1MDddICBbPGMwMjg1N2UwPl0gcGVy
Zl9ldmVudF9hbGxvYysweDI4MC8weDNjMApbICAgMTIuOTM0NTA3XSAgWzxjMDI4NjBjMT5d
IHN5c19wZXJmX2V2ZW50X29wZW4rMHg1NzEvMHg5MDAKWyAgIDEyLjkzNDUwN10gIFs8YzA2
NmFlNWM+XSBzeXNlbnRlcl9kb19jYWxsKzB4MTIvMHgzNwpbICAgMTIuOTM0NTA3XSBDb2Rl
OiBjMCBlOCA2MSBlZSAzZCAwMCA1ZCBjMyBlYiAwZCA5MCA5MCA5MCA5MCA5MCA5MCA5MCA5
MCA5MCA5MCA5MCA5MCA5MCA1NSBiOCBjMCBmMCA4MyBjMCA4OSBlNSBlOCBhMyBmYiAzZCAw
MCA1ZCBjMyA5MCA1NSA4OSBlNSA1MyA8OGI+IDEwIDg5IGMzIDg1IGQyIDc0IDEyIDhkIDRh
IDAxIDg5IGQwIGYwIDBmIGIxIDBiIDM5IGMyIDg5IGMxIApbICAgMTIuOTM0NTA3XSBFSVA6
IFs8YzAyODgwMDQ+XSBzdGF0aWNfa2V5X3Nsb3dfaW5jKzB4NC8weDgwIFNTOkVTUCAwMDY4
OmM4NWYzZWIwClsgICAxMi45MzQ1MDddIENSMjogMDAwMDAwMDA0MGYwOWI5OApbICAgMTIu
OTYzNzY0XSAtLS1bIGVuZCB0cmFjZSBkYTMyZTU1MmQyY2I0YjU1IF0tLS0KCi9rZXJuZWwv
aTM4Ni1yYW5kY29uZmlnLXg0LTAyMjEyMzE2Lzc2ZTEwZDE1OGVmYjZkNDUxNjAxODg0NmY2
MGMyYWI1NTAxOTAwYmMvZG1lc2cteW9jdG8td2FpbWVhLTExOjIwMTQwMzAxMDYzNjEwOmkz
ODYtcmFuZGNvbmZpZy14NC0wMjIxMjMxNjozLjQuMDo3CjI1OjE6MzkgYWxsX2dvb2Q6YmFk
OmFsbF9iYWQgYm9vdHMKCmJpc2VjdDogYmFkIGNvbW1pdCB2My40CmdpdCBjaGVja291dCB2
My4zCmxzIC1hIC9rZXJuZWwtdGVzdHMvcnVuLXF1ZXVlL2t2bS9pMzg2LXJhbmRjb25maWct
eDQtMDIyMTIzMTYvbmV4dDptYXN0ZXI6YzE2ZmE0ZjJhZDE5OTA4YTQ3YzYzZDhmYTQzNmEx
MTc4NDM4YzdlNzpiaXNlY3QtbmV0CgoyMDE0LTAzLTAxLTA2OjM2OjM0IGMxNmZhNGYyYWQx
OTkwOGE0N2M2M2Q4ZmE0MzZhMTE3ODQzOGM3ZTcgY29tcGlsaW5nCjk1IHJlYWwgIDc2NyB1
c2VyICA3NSBzeXMgIDg3OS43NyUgY3B1IAlpMzg2LXJhbmRjb25maWcteDQtMDIyMTIzMTYK
CjIwMTQtMDMtMDEtMDY6Mzg6MjYgZGV0ZWN0aW5nIGJvb3Qgc3RhdGUgMy4zLjAJMQk1CTEw
CTE1LgkyMQkyMwkzNQk1Mwk2MQk3MQk3Mgk4MAk4NC4JODcgVEVTVCBGQUlMVVJFClsgICAx
Mi43MzY1MTNdIGlydHRwX29wZW5fdHNhcCgpLCBpbnZhbGlkIHRzYXAhClsgICAxMi43Mzcx
ODNdIGlyZGFfb3Blbl90c2FwKCksIFVuYWJsZSB0byBhbGxvY2F0ZSBUU0FQIQpbICAgMTIu
NzM4MjY2XSBpcmlhc19kZWxldGVfb2JqZWN0KCksIG9iamVjdCBhbHJlYWR5IHJlbW92ZWQh
ClsgICAxMi43Njg5MDhdIEJVRzogdW5hYmxlIHRvIGhhbmRsZSBrZXJuZWwgcGFnaW5nIHJl
cXVlc3QgYXQgNGYzN2Q1ZTAKWyAgIDEyLjc2OTEyMl0gSVA6IFs8YzAyODc3ZTQ+XSBqdW1w
X2xhYmVsX2luYysweDQvMHg3MApbICAgMTIuNzY5MTIyXSAqcGRlID0gMDAwMDAwMDAgClsg
ICAxMi43NjkxMjJdIE9vcHM6IDAwMDAgWyMxXSBTTVAgREVCVUdfUEFHRUFMTE9DClsgICAx
Mi43NjkxMjJdIApbICAgMTIuNzY5MTIyXSBQaWQ6IDExMCwgY29tbTogdHJpbml0eS1tYWlu
IE5vdCB0YWludGVkIDMuMy4wICM4ICAKWyAgIDEyLjc2OTEyMl0gRUlQOiAwMDYwOls8YzAy
ODc3ZTQ+XSBFRkxBR1M6IDAwMDEwMjQ2IENQVTogMQpbICAgMTIuNzY5MTIyXSBFSVAgaXMg
YXQganVtcF9sYWJlbF9pbmMrMHg0LzB4NzAKWyAgIDEyLjc2OTEyMl0gRUFYOiA0ZjM3ZDVl
MCBFQlg6IGM4NmM2NTg4IEVDWDogMDAwMDAwMDAgRURYOiAwMDAwMDAwMQpbICAgMTIuNzY5
MTIyXSBFU0k6IGQxY2EyNTQ4IEVESTogMDAwMDAwMDIgRUJQOiBjODVkN2ViYyBFU1A6IGM4
NWQ3ZWI4ClsgICAxMi43NjkxMjJdICBEUzogMDA3YiBFUzogMDA3YiBGUzogMDBkOCBHUzog
MDAzMyBTUzogMDA2OApbICAgMTIuNzY5MTIyXSBQcm9jZXNzIHRyaW5pdHktbWFpbiAocGlk
OiAxMTAsIHRpPWM4NWQ2MDAwIHRhc2s9Yzg1ZTMwMDAgdGFzay50aT1jODVkNjAwMCkKWyAg
IDEyLjc2OTEyMl0gU3RhY2s6ClsgICAxMi43NjkxMjJdICBjODZjNjU4OCBjODVkN2VkNCBj
MDI4MDYxOCAwMDAwMDAwMCBjMDgyMzYwMCBjODZjNjU4OCAwMDAwMDAwMCBjODVkN2VmYwpb
ICAgMTIuNzY5MTIyXSAgYzAyODRlNzggMDAwMDAwMDIgMDAwMDAwMDEgMDAwMDAwMDAgYzAy
ODRkNjAgYzA4MjM2MDAgMDAwMDAwMDAgYzg2YzY2YTAKWyAgIDEyLjc2OTEyMl0gIDAwMDAw
MDAwIGM4NWQ3ZjE4IGMwMjg1MTEwIGM4NWQ3ZjU4IGM4NmM2NTg4IDAwMDAwMDAwIGM4NWUz
MDAwIDAwMDAwMDAwClsgICAxMi43NjkxMjJdIENhbGwgVHJhY2U6ClsgICAxMi43NjkxMjJd
ICBbPGMwMjgwNjE4Pl0gcGVyZl9zd2V2ZW50X2luaXQrMHg2OC8weDEzMApbICAgMTIuNzY5
MTIyXSAgWzxjMDI4NGU3OD5dIHBlcmZfaW5pdF9ldmVudCsweDExOC8weDEzMApbICAgMTIu
NzY5MTIyXSAgWzxjMDI4NGQ2MD5dID8gcGVyZl9wbXVfdW5yZWdpc3RlcisweDEzMC8weDEz
MApbICAgMTIuNzY5MTIyXSAgWzxjMDI4NTExMD5dIHBlcmZfZXZlbnRfYWxsb2MrMHgyODAv
MHgzNzAKWyAgIDEyLjc2OTEyMl0gIFs8YzAyODU5NDE+XSBzeXNfcGVyZl9ldmVudF9vcGVu
KzB4NTExLzB4ODgwClsgICAxMi43NjkxMjJdICBbPGMwMjYzMjA0Pl0gPyBsb2NrX3JlbGVh
c2VfaG9sZHRpbWUucGFydC4yMisweGI0LzB4ZTAKWyAgIDEyLjc2OTEyMl0gIFs8YzA2NTlh
ZGM+XSBzeXNlbnRlcl9kb19jYWxsKzB4MTIvMHgzNwpbICAgMTIuNzY5MTIyXSBDb2RlOiA5
MCA5MCA5MCA5MCA5MCA5MCA5MCA1NSBiOCBlMCAzNyA4MiBjMCA4OSBlNSBlOCA4MyBmMCAz
YyAwMCA1ZCBjMyA5MCA1NSA4YiAwMCA4OSBlNSA1ZCA4NSBjMCAwZiA5NSBjMCBjMyA4ZCA3
NCAyNiAwMCA1NSA4OSBlNSA1MyA8OGI+IDEwIDg5IGMzIDg1IGQyIDc0IDEyIDhkIDRhIDAx
IDg5IGQwIGYwIDBmIGIxIDBiIDM5IGMyIDg5IGMxIApbICAgMTIuNzY5MTIyXSBFSVA6IFs8
YzAyODc3ZTQ+XSBqdW1wX2xhYmVsX2luYysweDQvMHg3MCBTUzpFU1AgMDA2ODpjODVkN2Vi
OApbICAgMTIuNzY5MTIyXSBDUjI6IDAwMDAwMDAwNGYzN2Q1ZTAKWyAgIDEyLjc5NTkxOF0g
LS0tWyBlbmQgdHJhY2UgMWI3YTI5Yjk3ZTM0NzZmMSBdLS0tCgova2VybmVsL2kzODYtcmFu
ZGNvbmZpZy14NC0wMjIxMjMxNi9jMTZmYTRmMmFkMTk5MDhhNDdjNjNkOGZhNDM2YTExNzg0
MzhjN2U3L2RtZXNnLXF1YW50YWwtd2FpbWVhLTY6MjAxNDAzMDEwNjQ2MDE6aTM4Ni1yYW5k
Y29uZmlnLXg0LTAyMjEyMzE2OjMuMy4wOjgKNTU6MTozMyBhbGxfZ29vZDpiYWQ6YWxsX2Jh
ZCBib290cwoKYmlzZWN0OiBiYWQgY29tbWl0IHYzLjMKZ2l0IGNoZWNrb3V0IHYzLjIKbHMg
LWEgL2tlcm5lbC10ZXN0cy9ydW4tcXVldWUva3ZtL2kzODYtcmFuZGNvbmZpZy14NC0wMjIx
MjMxNi9uZXh0Om1hc3Rlcjo4MDVhNmFmOGRiYTVkZmRkMzVlYzM1ZGM1MmVjMDEyMjQwMGIy
NjEwOmJpc2VjdC1uZXQKCjIwMTQtMDMtMDEtMDY6NDY6MzUgODA1YTZhZjhkYmE1ZGZkZDM1
ZWMzNWRjNTJlYzAxMjI0MDBiMjYxMCBjb21waWxpbmcKNTUgcmVhbCAgNzI2IHVzZXIgIDY2
IHN5cyAgMTQzNS42OCUgY3B1IAlpMzg2LXJhbmRjb25maWcteDQtMDIyMTIzMTYKCjIwMTQt
MDMtMDEtMDY6NDc6NDIgZGV0ZWN0aW5nIGJvb3Qgc3RhdGUgMy4yLjAJMQk2CTEzCTIwCTIx
Li4JMjIJMjMgVEVTVCBGQUlMVVJFClsgICAxMi45MjMzMDBdIGlyZGFfb3Blbl90c2FwKCks
IFVuYWJsZSB0byBhbGxvY2F0ZSBUU0FQIQpbICAgMTIuOTI0MTIzXSBpcmlhc19kZWxldGVf
b2JqZWN0KCksIG9iamVjdCBhbHJlYWR5IHJlbW92ZWQhClsgICAxMi45NDEyMTldIGlyZGFf
c2V0c29ja29wdDogbm90IGFsbG93ZWQgdG8gc2V0IE1BWFNEVVNJWkUgZm9yIHRoaXMgc29j
a2V0IHR5cGUhClsgICAxMy4xMjg5MzFdIEJVRzogdW5hYmxlIHRvIGhhbmRsZSBrZXJuZWwg
cGFnaW5nIHJlcXVlc3QgYXQgNmMyYjE0MDAKWyAgIDEzLjEyOTEyNl0gSVA6IFs8YzAyN2Yy
OTQ+XSBqdW1wX2xhYmVsX2luYysweDQvMHg3MApbICAgMTMuMTI5MTI2XSAqcGRlID0gMDAw
MDAwMDAgClsgICAxMy4xMjkxMjZdIE9vcHM6IDAwMDAgWyMxXSBTTVAgREVCVUdfUEFHRUFM
TE9DClsgICAxMy4xMjkxMjZdIApbICAgMTMuMTI5MTI2XSBQaWQ6IDk4LCBjb21tOiB0cmlu
aXR5LW1haW4gTm90IHRhaW50ZWQgMy4yLjAgIzkgIApbICAgMTMuMTI5MTI2XSBFSVA6IDAw
NjA6WzxjMDI3ZjI5ND5dIEVGTEFHUzogMDAwMTAyNDYgQ1BVOiAxClsgICAxMy4xMjkxMjZd
IEVJUCBpcyBhdCBqdW1wX2xhYmVsX2luYysweDQvMHg3MApbICAgMTMuMTI5MTI2XSBFQVg6
IDZjMmIxNDAwIEVCWDogYzg2ZDc1NzggRUNYOiAwMDAwMDAwMCBFRFg6IDAwMDAwMDAxClsg
ICAxMy4xMjkxMjZdIEVTSTogYjU2OGY3MjggRURJOiAwMDAwMDAwMiBFQlA6IGM4NjA5ZWJj
IEVTUDogYzg2MDllYjgKWyAgIDEzLjEyOTEyNl0gIERTOiAwMDdiIEVTOiAwMDdiIEZTOiAw
MGQ4IEdTOiAwMDMzIFNTOiAwMDY4ClsgICAxMy4xMjkxMjZdIFByb2Nlc3MgdHJpbml0eS1t
YWluIChwaWQ6IDk4LCB0aT1jODYwODAwMCB0YXNrPWM4NWY5MDAwIHRhc2sudGk9Yzg2MDgw
MDApClsgICAxMy4xMjkxMjZdIFN0YWNrOgpbICAgMTMuMTI5MTI2XSAgYzg2ZDc1NzggYzg2
MDllZDQgYzAyNzg2ODggMDAwMDAwMDAgYzA3ZjI5MjAgYzg2ZDc1NzggMDAwMDAwMDAgYzg2
MDllZmMKWyAgIDEzLjEyOTEyNl0gIGMwMjdjYzM4IDAwMDAwMDAyIDAwMDAwMDAxIDAwMDAw
MDAwIGMwMjdjYjIwIGMwN2YyOTIwIDAwMDAwMDAwIGM4NmQ3NjkwClsgICAxMy4xMjkxMjZd
ICBjODZkNzU3OCBjODYwOWYxOCBjMDI3Y2VjOCBjODYwOWY1OCBjODZkNzU3OCAwMDAwMDAw
MCBjODVmOTAwMCAwMDAwMDAwMApbICAgMTMuMTI5MTI2XSBDYWxsIFRyYWNlOgpbICAgMTMu
MTI5MTI2XSAgWzxjMDI3ODY4OD5dIHBlcmZfc3dldmVudF9pbml0KzB4NjgvMHgxMzAKWyAg
IDEzLjEyOTEyNl0gIFs8YzAyN2NjMzg+XSBwZXJmX2luaXRfZXZlbnQrMHgxMTgvMHgxMzAK
WyAgIDEzLjEyOTEyNl0gIFs8YzAyN2NiMjA+XSA/IHBlcmZfcG11X3VucmVnaXN0ZXIrMHgx
MzAvMHgxMzAKWyAgIDEzLjEyOTEyNl0gIFs8YzAyN2NlYzg+XSBwZXJmX2V2ZW50X2FsbG9j
KzB4Mjc4LzB4NGQwClsgICAxMy4xMjkxMjZdICBbPGMwMjdkODYxPl0gc3lzX3BlcmZfZXZl
bnRfb3BlbisweDUxMS8weDg4MApbICAgMTMuMTI5MTI2XSAgWzxjMDYzODUxYz5dIHN5c2Vu
dGVyX2RvX2NhbGwrMHgxMi8weDM3ClsgICAxMy4xMjkxMjZdIENvZGU6IDkwIDkwIDkwIDkw
IDkwIDkwIDkwIDU1IGI4IDAwIDJiIDdmIGMwIDg5IGU1IGU4IDIzIDZkIDNiIDAwIDVkIGMz
IDkwIDU1IDhiIDAwIDg5IGU1IDVkIDg1IGMwIDBmIDk1IGMwIGMzIDhkIDc0IDI2IDAwIDU1
IDg5IGU1IDUzIDw4Yj4gMTAgODkgYzMgODUgZDIgNzQgMTIgOGQgNGEgMDEgODkgZDAgZjAg
MGYgYjEgMGIgMzkgYzIgODkgYzEgClsgICAxMy4xMjkxMjZdIEVJUDogWzxjMDI3ZjI5ND5d
IGp1bXBfbGFiZWxfaW5jKzB4NC8weDcwIFNTOkVTUCAwMDY4OmM4NjA5ZWI4ClsgICAxMy4x
MjkxMjZdIENSMjogMDAwMDAwMDA2YzJiMTQwMApbICAgMTMuMTUzNzYzXSAtLS1bIGVuZCB0
cmFjZSBhMWNjMjFkOTg4Y2M0MzE5IF0tLS0KCi9rZXJuZWwvaTM4Ni1yYW5kY29uZmlnLXg0
LTAyMjEyMzE2LzgwNWE2YWY4ZGJhNWRmZGQzNWVjMzVkYzUyZWMwMTIyNDAwYjI2MTAvZG1l
c2cteW9jdG8td2FpbWVhLTE1OjIwMTQwMzAxMDY1MTQ2OmkzODYtcmFuZGNvbmZpZy14NC0w
MjIxMjMxNjozLjIuMDo5Ci9rZXJuZWwvaTM4Ni1yYW5kY29uZmlnLXg0LTAyMjEyMzE2Lzgw
NWE2YWY4ZGJhNWRmZGQzNWVjMzVkYzUyZWMwMTIyNDAwYjI2MTAvZG1lc2cteW9jdG8td2Fp
bWVhLTc6MjAxNDAzMDEwNjUyMDM6aTM4Ni1yYW5kY29uZmlnLXg0LTAyMjEyMzE2OjMuMi4w
OjkKMTU6MjoxMCBhbGxfZ29vZDpiYWQ6YWxsX2JhZCBib290cwoKYmlzZWN0OiBiYWQgY29t
bWl0IHYzLjIKZ2l0IGNoZWNrb3V0IHYzLjEKbHMgLWEgL2tlcm5lbC10ZXN0cy9ydW4tcXVl
dWUva3ZtL2kzODYtcmFuZGNvbmZpZy14NC0wMjIxMjMxNi9uZXh0Om1hc3RlcjpjM2I5MmM4
Nzg3MzY3YThiYjUzZDU3ZDk3ODliNTU4ZjEyOTVjYzk2OmJpc2VjdC1uZXQKCjIwMTQtMDMt
MDEtMDY6NTI6MjEgYzNiOTJjODc4NzM2N2E4YmI1M2Q1N2Q5Nzg5YjU1OGYxMjk1Y2M5NiBj
b21waWxpbmcKNTMgcmVhbCAgNjg1IHVzZXIgIDYzIHN5cyAgMTM5Ny4yMCUgY3B1IAlpMzg2
LXJhbmRjb25maWcteDQtMDIyMTIzMTYKCjIwMTQtMDMtMDEtMDY6NTM6MjkgZGV0ZWN0aW5n
IGJvb3Qgc3RhdGUgMy4xLjAuCTMJNgkxNQkyOQkzNwk0Mwk1NQk1OQk4NQk5NwkxMTEJMTMx
CTE0MQkxNTQJMTY3CTE4OQkxOTkJMjA5CTIzMQkyNDIJMjY0CTI4MwkyOTIJMzA2CTMxOAkz
MzIJMzQyCTM1NQkzNjIJMzY5CTM4NQk0MDAJNDE4CTQzNwk0NDMJNDYxCTQ3NAk0ODIJNDkx
CTUwMQk1MDgJNTI1IFRFU1QgRkFJTFVSRQpbICAgMTMuNzM0ODIzXSBpcnR0cF9vcGVuX3Rz
YXAoKSwgaW52YWxpZCB0c2FwIQpbICAgMTMuNzM1NjMyXSBpcmRhX29wZW5fdHNhcCgpLCBV
bmFibGUgdG8gYWxsb2NhdGUgVFNBUCEKWyAgIDEzLjczNjI0M10gaXJpYXNfZGVsZXRlX29i
amVjdCgpLCBvYmplY3QgYWxyZWFkeSByZW1vdmVkIQpbICAgMTUuMDU4OTM3XSBCVUc6IHVu
YWJsZSB0byBoYW5kbGUga2VybmVsIHBhZ2luZyByZXF1ZXN0IGF0IDAwZTI3YjQwClsgICAx
NS4wNTkzNTldIElQOiBbPGMwMjdkZGY0Pl0ganVtcF9sYWJlbF9pbmMrMHg0LzB4NzAKWyAg
IDE1LjA1OTM1OV0gKnBkZSA9IDAwMDAwMDAwIApbICAgMTUuMDU5MzU5XSBPb3BzOiAwMDAw
IFsjMV0gU01QIERFQlVHX1BBR0VBTExPQwpbICAgMTUuMDU5MzU5XSAKWyAgIDE1LjA1OTM1
OV0gUGlkOiA5NywgY29tbTogdHJpbml0eS1tYWluIE5vdCB0YWludGVkIDMuMS4wICMxMCAg
ClsgICAxNS4wNTkzNTldIEVJUDogMDA2MDpbPGMwMjdkZGY0Pl0gRUZMQUdTOiAwMDAxMDI0
NiBDUFU6IDEKWyAgIDE1LjA1OTM1OV0gRUlQIGlzIGF0IGp1bXBfbGFiZWxfaW5jKzB4NC8w
eDcwClsgICAxNS4wNTkzNTldIEVBWDogMDBlMjdiNDAgRUJYOiBjODZhNDJiOCBFQ1g6IDAw
MDAwMDAwIEVEWDogMDAwMDAwMDEKWyAgIDE1LjA1OTM1OV0gRVNJOiA4ODAwMDAwMCBFREk6
IDAwMDAwMDAyIEVCUDogYzg1YzdlYmMgRVNQOiBjODVjN2ViOApbICAgMTUuMDU5MzU5XSAg
RFM6IDAwN2IgRVM6IDAwN2IgRlM6IDAwZDggR1M6IDAwMzMgU1M6IDAwNjgKWyAgIDE1LjA1
OTM1OV0gUHJvY2VzcyB0cmluaXR5LW1haW4gKHBpZDogOTcsIHRpPWM4NWM2MDAwIHRhc2s9
Yzg1YmMwMDAgdGFzay50aT1jODVjNjAwMCkKWyAgIDE1LjA1OTM1OV0gU3RhY2s6ClsgICAx
NS4wNTkzNTldICBjODZhNDJiOCBjODVjN2VkNCBjMDI3NzMyOCAwMDAwMDAwMCBjMDdlNDcy
MCBjODZhNDJiOCAwMDAwMDAwMCBjODVjN2VmYwpbICAgMTUuMDU5MzU5XSAgYzAyN2I3YzUg
MDAwMDAwMDIgMDAwMDAwMDEgMDAwMDAwMDAgYzAyN2I2YjAgYzA3ZTQ3MjAgMDAwMDAwMDAg
Yzg2YTQzZDAKWyAgIDE1LjA1OTM1OV0gIGM4NmE0MmI4IGM4NWM3ZjE4IGMwMjdiYTQwIGM4
NWM3ZjU4IGM4NmE0MmI4IDAwMDAwMDAwIGM4NWJjMDAwIDAwMDAwMDAwClsgICAxNS4wNTkz
NTldIENhbGwgVHJhY2U6ClsgICAxNS4wNTkzNTldICBbPGMwMjc3MzI4Pl0gcGVyZl9zd2V2
ZW50X2luaXQrMHg2OC8weDEzMApbICAgMTUuMDU5MzU5XSAgWzxjMDI3YjdjNT5dIHBlcmZf
aW5pdF9ldmVudCsweDExNS8weDEzMApbICAgMTUuMDU5MzU5XSAgWzxjMDI3YjZiMD5dID8g
cGVyZl9wbXVfdW5yZWdpc3RlcisweDEzMC8weDEzMApbICAgMTUuMDU5MzU5XSAgWzxjMDI3
YmE0MD5dIHBlcmZfZXZlbnRfYWxsb2MrMHgyNjAvMHg0YzAKWyAgIDE1LjA1OTM1OV0gIFs8
YzAyN2MzZTE+XSBzeXNfcGVyZl9ldmVudF9vcGVuKzB4NTExLzB4ODgwClsgICAxNS4wNTkz
NTldICBbPGMwNjJjYzFjPl0gc3lzZW50ZXJfZG9fY2FsbCsweDEyLzB4MzcKWyAgIDE1LjA1
OTM1OV0gQ29kZTogOTAgOTAgOTAgOTAgOTAgOTAgOTAgNTUgYjggMDAgNDkgN2UgYzAgODkg
ZTUgZTggYzMgYzggM2EgMDAgNWQgYzMgOTAgNTUgOGIgMDAgODkgZTUgNWQgODUgYzAgMGYg
OTUgYzAgYzMgOGQgNzQgMjYgMDAgNTUgODkgZTUgNTMgPDhiPiAxMCA4OSBjMyA4NSBkMiA3
NCAxMiA4ZCA0YSAwMSA4OSBkMCBmMCAwZiBiMSAwYiAzOSBjMiA4OSBjMSAKWyAgIDE1LjA1
OTM1OV0gRUlQOiBbPGMwMjdkZGY0Pl0ganVtcF9sYWJlbF9pbmMrMHg0LzB4NzAgU1M6RVNQ
IDAwNjg6Yzg1YzdlYjgKWyAgIDE1LjA1OTM1OV0gQ1IyOiAwMDAwMDAwMDAwZTI3YjQwClsg
ICAxNS4wOTEyNzVdIC0tLVsgZW5kIHRyYWNlIDRhNTc0ZDY2NDdkMTdjYzUgXS0tLQoKL2tl
cm5lbC9pMzg2LXJhbmRjb25maWcteDQtMDIyMTIzMTYvYzNiOTJjODc4NzM2N2E4YmI1M2Q1
N2Q5Nzg5YjU1OGYxMjk1Y2M5Ni9kbWVzZy15b2N0by13YWltZWEtMTE6MjAxNDAzMDEwNzE0
MjA6aTM4Ni1yYW5kY29uZmlnLXg0LTAyMjEyMzE2OjMuMS4wOjEwCjMyNToxOjIwMSBhbGxf
Z29vZDpiYWQ6YWxsX2JhZCBib290cwobWzE7MzVtMjAxNC0wMy0wMSAwNzoxNTowMSBSRVBF
QVQgQ09VTlQ6IDEwMDAgICMgL2NjL3dmZy9uZXQtYmlzZWN0Ly5yZXBlYXQbWzBtCgpiaXNl
Y3Q6IGJhZCBjb21taXQgdjMuMQpnaXQgY2hlY2tvdXQgdjMuMApscyAtYSAva2VybmVsLXRl
c3RzL3J1bi1xdWV1ZS9rdm0vaTM4Ni1yYW5kY29uZmlnLXg0LTAyMjEyMzE2L25leHQ6bWFz
dGVyOjAyZjhjNmFlZThkZjNjZGM5MzVlOWJkZDRmMmQwMjAzMDYwMzVkYmU6YmlzZWN0LW5l
dAoKMjAxNC0wMy0wMS0wNzoxNTowNCAwMmY4YzZhZWU4ZGYzY2RjOTM1ZTliZGQ0ZjJkMDIw
MzA2MDM1ZGJlIGNvbXBpbGluZwo1NiByZWFsICA2NzcgdXNlciAgNjUgc3lzICAxMzE3LjQw
JSBjcHUgCWkzODYtcmFuZGNvbmZpZy14NC0wMjIxMjMxNgoKMjAxNC0wMy0wMS0wNzoxNjox
NSBkZXRlY3RpbmcgYm9vdCBzdGF0ZSAzLjAuMC4JMgkxMQkxOQkzMAk0MQk0Nwk2Mgk3NAk4
Mgk4OQkxMDMJMTA5CTExOQkxMzEJMTM1CTE1MAkxNTkJMTcxCTE3NgkxODgJMTk3CTIxMQky
MjcJMjM4CTI0OCBURVNUIEZBSUxVUkUKWyAgIDEyLjY1MTUwNV0gaXJ0dHBfb3Blbl90c2Fw
KCksIGludmFsaWQgdHNhcCEKWyAgIDEyLjY1MjQwOF0gaXJkYV9vcGVuX3RzYXAoKSwgVW5h
YmxlIHRvIGFsbG9jYXRlIFRTQVAhClsgICAxMi42NTMzNjVdIGlyaWFzX2RlbGV0ZV9vYmpl
Y3QoKSwgb2JqZWN0IGFscmVhZHkgcmVtb3ZlZCEKWyAgIDEyLjgxNzA3NV0gQlVHOiB1bmFi
bGUgdG8gaGFuZGxlIGtlcm5lbCBwYWdpbmcgcmVxdWVzdCBhdCBlMGUxNjJmOApbICAgMTIu
ODE3NjcyXSBJUDogWzxjMDI1Mjc4ND5dIGp1bXBfbGFiZWxfaW5jKzB4NC8weDcwClsgICAx
Mi44MTc2NzJdICpwZGUgPSAwMDAwMDAwMCAKWyAgIDEyLjgxNzY3Ml0gT29wczogMDAwMCBb
IzFdIFNNUCBERUJVR19QQUdFQUxMT0MKWyAgIDEyLjgxNzY3Ml0gClsgICAxMi44MTc2NzJd
IFBpZDogOTcsIGNvbW06IHRyaW5pdHktbWFpbiBOb3QgdGFpbnRlZCAzLjAuMCAjMTEgIApb
ICAgMTIuODE3NjcyXSBFSVA6IDAwNjA6WzxjMDI1Mjc4ND5dIEVGTEFHUzogMDAwMTAyNDYg
Q1BVOiAxClsgICAxMi44MTc2NzJdIEVJUCBpcyBhdCBqdW1wX2xhYmVsX2luYysweDQvMHg3
MApbICAgMTIuODE3NjcyXSBFQVg6IGUwZTE2MmY4IEVCWDogYzg2OWE3ZjAgRUNYOiAwMDAw
MDAwMCBFRFg6IDAwMDAwMDAxClsgICAxMi44MTc2NzJdIEVTSTogYTQwMDAwZmYgRURJOiAw
MDAwMDAwMiBFQlA6IGM4NTM5ZWJjIEVTUDogYzg1MzllYjgKWyAgIDEyLjgxNzY3Ml0gIERT
OiAwMDdiIEVTOiAwMDdiIEZTOiAwMGQ4IEdTOiAwMDMzIFNTOiAwMDY4ClsgICAxMi44MTc2
NzJdIFByb2Nlc3MgdHJpbml0eS1tYWluIChwaWQ6IDk3LCB0aT1jODUzODAwMCB0YXNrPWM4
NTVmMDAwIHRhc2sudGk9Yzg1MzgwMDApClsgICAxMi44MTc2NzJdIFN0YWNrOgpbICAgMTIu
ODE3NjcyXSAgYzg2OWE3ZjAgYzg1MzllZDQgYzAyNzVjZjggMDAwMDAwMDAgYzA3ZDQ4MjAg
Yzg2OWE3ZjAgMDAwMDAwMDAgYzg1MzllZmMKWyAgIDEyLjgxNzY3Ml0gIGMwMjdhY2NkIDAw
MDAwMDAyIDAwMDAwMDAxIDAwMDAwMDAwIGMwMjdhYmQwIGMwN2Q0ODIwIDAwMDAwMDAwIGM4
NjlhOTA4ClsgICAxMi44MTc2NzJdICBjODY5YTdmMCBjODUzOWYxOCBjMDI3YWYzOCBjODUz
OWY1OCBjODY5YTdmMCAwMDAwMDAwMCBjODU1ZjAwMCAwMDAwMDAwMApbICAgMTIuODE3Njcy
XSBDYWxsIFRyYWNlOgpbICAgMTIuODE3NjcyXSAgWzxjMDI3NWNmOD5dIHBlcmZfc3dldmVu
dF9pbml0KzB4NjgvMHgxMzAKWyAgIDEyLjgxNzY3Ml0gIFs8YzAyN2FjY2Q+XSBwZXJmX2lu
aXRfZXZlbnQrMHhmZC8weDEyMApbICAgMTIuODE3NjcyXSAgWzxjMDI3YWJkMD5dID8gcGVy
Zl9wbXVfdW5yZWdpc3RlcisweDEzMC8weDEzMApbICAgMTIuODE3NjcyXSAgWzxjMDI3YWYz
OD5dIHBlcmZfZXZlbnRfYWxsb2MrMHgyNDgvMHg0YTAKWyAgIDEyLjgxNzY3Ml0gIFs8YzAy
N2I4OGY+XSBzeXNfcGVyZl9ldmVudF9vcGVuKzB4NGVmLzB4ODcwClsgICAxMi44MTc2NzJd
ICBbPGMwMjdiN2YwPl0gPyBzeXNfcGVyZl9ldmVudF9vcGVuKzB4NDUwLzB4ODcwClsgICAx
Mi44MTc2NzJdICBbPGMwNjFmNzFjPl0gc3lzZW50ZXJfZG9fY2FsbCsweDEyLzB4MzcKWyAg
IDEyLjgxNzY3Ml0gQ29kZTogOTAgOTAgOTAgOTAgOTAgOTAgOTAgNTUgYjggMjAgMjAgN2Qg
YzAgODkgZTUgZTggOTMgYWIgM2MgMDAgNWQgYzMgOTAgNTUgOGIgMDAgODkgZTUgNWQgODUg
YzAgMGYgOTUgYzAgYzMgOGQgNzQgMjYgMDAgNTUgODkgZTUgNTMgPDhiPiAxMCA4OSBjMyA4
NSBkMiA3NCAxMiA4ZCA0YSAwMSA4OSBkMCBmMCAwZiBiMSAwYiAzOSBjMiA4OSBjMSAKWyAg
IDEyLjgxNzY3Ml0gRUlQOiBbPGMwMjUyNzg0Pl0ganVtcF9sYWJlbF9pbmMrMHg0LzB4NzAg
U1M6RVNQIDAwNjg6Yzg1MzllYjgKWyAgIDEyLjgxNzY3Ml0gQ1IyOiAwMDAwMDAwMGUwZTE2
MmY4ClsgICAxMi44MTc2NzJdIC0tLVsgZW5kIHRyYWNlIDE3ODU4M2ZhMDRhNzBjZDkgXS0t
LQpbICAgMTIuODE3NjcyXSBCVUc6IHNsZWVwaW5nIGZ1bmN0aW9uIGNhbGxlZCBmcm9tIGlu
dmFsaWQgY29udGV4dCBhdCBrZXJuZWwvcndzZW0uYzoyMQova2VybmVsL2kzODYtcmFuZGNv
bmZpZy14NC0wMjIxMjMxNi8wMmY4YzZhZWU4ZGYzY2RjOTM1ZTliZGQ0ZjJkMDIwMzA2MDM1
ZGJlL2RtZXNnLXF1YW50YWwtd2FpbWVhLTQ6MjAxNDAzMDEwNzI4NTY6aTM4Ni1yYW5kY29u
ZmlnLXg0LTAyMjEyMzE2OjMuMC4wOjExCjE0NDoxOjEwNSBhbGxfZ29vZDpiYWQ6YWxsX2Jh
ZCBib290cwobWzE7MzVtMjAxNC0wMy0wMSAwNzoyOToxNiBSRVBFQVQgQ09VTlQ6IDEwMDAg
ICMgL2NjL3dmZy9uZXQtYmlzZWN0Ly5yZXBlYXQbWzBtCgpiaXNlY3Q6IGJhZCBjb21taXQg
djMuMApnaXQgY2hlY2tvdXQgdjIuNi4zOQpscyAtYSAva2VybmVsLXRlc3RzL3J1bi1xdWV1
ZS9rdm0vaTM4Ni1yYW5kY29uZmlnLXg0LTAyMjEyMzE2L25leHQ6bWFzdGVyOjYxYzRmMmM4
MWM2MWY3MzU0OTkyOGRmZDlmM2U4ZjI2YWEzNmE4Y2Y6YmlzZWN0LW5ldAoKMjAxNC0wMy0w
MS0wNzoyOToyMyA2MWM0ZjJjODFjNjFmNzM1NDk5MjhkZmQ5ZjNlOGYyNmFhMzZhOGNmIGNv
bXBpbGluZwo2NSByZWFsICA2MzUgdXNlciAgNTQgc3lzICAxMDU4LjQ4JSBjcHUgCWkzODYt
cmFuZGNvbmZpZy14NC0wMjIxMjMxNgoyMDE0LTAzLTAxLTA3OjMwOjM5IDYxYzRmMmM4MWM2
MWY3MzU0OTkyOGRmZDlmM2U4ZjI2YWEzNmE4Y2YgU0tJUCBCUk9LRU4gQlVJTEQKQ2hlY2sg
ZXJyb3MgaW4gL2NjL3dmZy9uZXQtYmlzZWN0IGFuZCAvdG1wL2tlcm5lbC9pMzg2LXJhbmRj
b25maWcteDQtMDIyMTIzMTYvNjFjNGYyYzgxYzYxZjczNTQ5OTI4ZGZkOWYzZThmMjZhYTM2
YThjZgpiaXNlY3Q6IHNraXAgYnJva2VuIGJ1aWxkIGZvciB2Mi42LjM5CmdpdCBjaGVja291
dCB2Mi42LjM4CmxzIC1hIC9rZXJuZWwtdGVzdHMvcnVuLXF1ZXVlL2t2bS9pMzg2LXJhbmRj
b25maWcteDQtMDIyMTIzMTYvbmV4dDptYXN0ZXI6NTIxY2I0MGIwYzQ0NDE4YTRmZDM2ZGM2
MzNmNTc1ODEzZDU5YTQzZDpiaXNlY3QtbmV0CgoyMDE0LTAzLTAxLTA3OjMwOjQ2IDUyMWNi
NDBiMGM0NDQxOGE0ZmQzNmRjNjMzZjU3NTgxM2Q1OWE0M2QgY29tcGlsaW5nCjQyIHJlYWwg
IDU3MSB1c2VyICA0OCBzeXMgIDE0NTQuNDUlIGNwdSAJaTM4Ni1yYW5kY29uZmlnLXg0LTAy
MjEyMzE2CjIwMTQtMDMtMDEtMDc6MzE6MzcgNTIxY2I0MGIwYzQ0NDE4YTRmZDM2ZGM2MzNm
NTc1ODEzZDU5YTQzZCBTS0lQIEJST0tFTiBCVUlMRApDaGVjayBlcnJvcyBpbiAvY2Mvd2Zn
L25ldC1iaXNlY3QgYW5kIC90bXAva2VybmVsL2kzODYtcmFuZGNvbmZpZy14NC0wMjIxMjMx
Ni81MjFjYjQwYjBjNDQ0MThhNGZkMzZkYzYzM2Y1NzU4MTNkNTlhNDNkCmJpc2VjdDogc2tp
cCBicm9rZW4gYnVpbGQgZm9yIHYyLjYuMzgKZ2l0IGNoZWNrb3V0IHYyLjYuMzcKbHMgLWEg
L2tlcm5lbC10ZXN0cy9ydW4tcXVldWUva3ZtL2kzODYtcmFuZGNvbmZpZy14NC0wMjIxMjMx
Ni9uZXh0Om1hc3RlcjozYzBlZWUzZmU2YTNhMWM3NDUzNzk1NDdjN2U3YzkwNGFhNjRmNmQ1
OmJpc2VjdC1uZXQKCjIwMTQtMDMtMDEtMDc6MzE6NDEgM2MwZWVlM2ZlNmEzYTFjNzQ1Mzc5
NTQ3YzdlN2M5MDRhYTY0ZjZkNSBjb21waWxpbmcKNDUgcmVhbCAgNTUxIHVzZXIgIDQ2IHN5
cyAgMTMwMS40MiUgY3B1IAlpMzg2LXJhbmRjb25maWcteDQtMDIyMTIzMTYKMjAxNC0wMy0w
MS0wNzozMjo0MCAzYzBlZWUzZmU2YTNhMWM3NDUzNzk1NDdjN2U3YzkwNGFhNjRmNmQ1IFNL
SVAgQlJPS0VOIEJVSUxECkNoZWNrIGVycm9zIGluIC9jYy93ZmcvbmV0LWJpc2VjdCBhbmQg
L3RtcC9rZXJuZWwvaTM4Ni1yYW5kY29uZmlnLXg0LTAyMjEyMzE2LzNjMGVlZTNmZTZhM2Ex
Yzc0NTM3OTU0N2M3ZTdjOTA0YWE2NGY2ZDUKYmlzZWN0OiBza2lwIGJyb2tlbiBidWlsZCBm
b3IgdjIuNi4zNwpnaXQgY2hlY2tvdXQgdjIuNi4zNgpscyAtYSAva2VybmVsLXRlc3RzL3J1
bi1xdWV1ZS9rdm0vaTM4Ni1yYW5kY29uZmlnLXg0LTAyMjEyMzE2L25leHQ6bWFzdGVyOmY2
Zjk0ZTJhYjFiMzNmMDA4MmFjMjJkNzFmNjYzODVhNjBkODE1N2Y6YmlzZWN0LW5ldAoKMjAx
NC0wMy0wMS0wNzozMjo0NSBmNmY5NGUyYWIxYjMzZjAwODJhYzIyZDcxZjY2Mzg1YTYwZDgx
NTdmIGNvbXBpbGluZwo0MCByZWFsICA1MzggdXNlciAgNDcgc3lzICAxNDUzLjg5JSBjcHUg
CWkzODYtcmFuZGNvbmZpZy14NC0wMjIxMjMxNgoyMDE0LTAzLTAxLTA3OjMzOjM3IGY2Zjk0
ZTJhYjFiMzNmMDA4MmFjMjJkNzFmNjYzODVhNjBkODE1N2YgU0tJUCBCUk9LRU4gQlVJTEQK
Q2hlY2sgZXJyb3MgaW4gL2NjL3dmZy9uZXQtYmlzZWN0IGFuZCAvdG1wL2tlcm5lbC9pMzg2
LXJhbmRjb25maWcteDQtMDIyMTIzMTYvZjZmOTRlMmFiMWIzM2YwMDgyYWMyMmQ3MWY2NjM4
NWE2MGQ4MTU3ZgpiaXNlY3Q6IHNraXAgYnJva2VuIGJ1aWxkIGZvciB2Mi42LjM2CmdpdCBj
aGVja291dCB2Mi42LjM1CmxzIC1hIC9rZXJuZWwtdGVzdHMvcnVuLXF1ZXVlL2t2bS9pMzg2
LXJhbmRjb25maWcteDQtMDIyMTIzMTYvbmV4dDptYXN0ZXI6OWZlNjIwNmY0MDA2NDZhMjMy
MjA5NmI1NmM1OTg5MWQ1MzBlOGQ1MTpiaXNlY3QtbmV0CgoyMDE0LTAzLTAxLTA3OjMzOjQz
IDlmZTYyMDZmNDAwNjQ2YTIzMjIwOTZiNTZjNTk4OTFkNTMwZThkNTEgY29tcGlsaW5nChtb
MTszNW0yMDE0LTAzLTAxIDA3OjMzOjQ3IGkzODYtcmFuZGNvbmZpZy14NC0wMjIxMjMxNjog
bWFrZSBvbGRub2NvbmZpZyBmYWlsZWQbWzBtChtbMTszNW0yMDE0LTAzLTAxIDA3OjMzOjUx
IGkzODYtcmFuZGNvbmZpZy14NC0wMjIxMjMxNjogbWFrZSBvbGRjb25maWcgc3VjY2VlZGVk
G1swbQozOCByZWFsICA1MTEgdXNlciAgNDUgc3lzICAxNDQxLjQ5JSBjcHUgCWkzODYtcmFu
ZGNvbmZpZy14NC0wMjIxMjMxNgoyMDE0LTAzLTAxLTA3OjM0OjM1IDlmZTYyMDZmNDAwNjQ2
YTIzMjIwOTZiNTZjNTk4OTFkNTMwZThkNTEgU0tJUCBCUk9LRU4gQlVJTEQKQ2hlY2sgZXJy
b3MgaW4gL2NjL3dmZy9uZXQtYmlzZWN0IGFuZCAvdG1wL2tlcm5lbC9pMzg2LXJhbmRjb25m
aWcteDQtMDIyMTIzMTYvOWZlNjIwNmY0MDA2NDZhMjMyMjA5NmI1NmM1OTg5MWQ1MzBlOGQ1
MQpiaXNlY3Q6IHNraXAgYnJva2VuIGJ1aWxkIGZvciB2Mi42LjM1CmdpdCBjaGVja291dCB2
Mi42LjM0CmxzIC1hIC9rZXJuZWwtdGVzdHMvcnVuLXF1ZXVlL2t2bS9pMzg2LXJhbmRjb25m
aWcteDQtMDIyMTIzMTYvbmV4dDptYXN0ZXI6ZTQwMTUyZWUxZTFjN2E2M2Y0Nzc3NzkxODYz
MjE1ZTNmYWEzN2E4NjpiaXNlY3QtbmV0CgoyMDE0LTAzLTAxLTA3OjM0OjQxIGU0MDE1MmVl
MWUxYzdhNjNmNDc3Nzc5MTg2MzIxNWUzZmFhMzdhODYgY29tcGlsaW5nChtbMTszNW0yMDE0
LTAzLTAxIDA3OjM0OjQzIGkzODYtcmFuZGNvbmZpZy14NC0wMjIxMjMxNjogbWFrZSBvbGRu
b2NvbmZpZyBmYWlsZWQbWzBtChtbMTszNW0yMDE0LTAzLTAxIDA3OjM0OjQ3IGkzODYtcmFu
ZGNvbmZpZy14NC0wMjIxMjMxNjogbWFrZSBvbGRjb25maWcgc3VjY2VlZGVkG1swbQozOCBy
ZWFsICA0OTkgdXNlciAgNDIgc3lzICAxNDA4LjUzJSBjcHUgCWkzODYtcmFuZGNvbmZpZy14
NC0wMjIxMjMxNgoyMDE0LTAzLTAxLTA3OjM1OjM2IGU0MDE1MmVlMWUxYzdhNjNmNDc3Nzc5
MTg2MzIxNWUzZmFhMzdhODYgU0tJUCBCUk9LRU4gQlVJTEQKQ2hlY2sgZXJyb3MgaW4gL2Nj
L3dmZy9uZXQtYmlzZWN0IGFuZCAvdG1wL2tlcm5lbC9pMzg2LXJhbmRjb25maWcteDQtMDIy
MTIzMTYvZTQwMTUyZWUxZTFjN2E2M2Y0Nzc3NzkxODYzMjE1ZTNmYWEzN2E4NgpiaXNlY3Q6
IHNraXAgYnJva2VuIGJ1aWxkIGZvciB2Mi42LjM0CmdpdCBjaGVja291dCB2Mi42LjMzCmxz
IC1hIC9rZXJuZWwtdGVzdHMvcnVuLXF1ZXVlL2t2bS9pMzg2LXJhbmRjb25maWcteDQtMDIy
MTIzMTYvbmV4dDptYXN0ZXI6NjBiMzQxYjc3OGNjMjkyOWRmMTZjMGE1MDRjOTE2MjFiM2M2
YTRhZDpiaXNlY3QtbmV0CgoyMDE0LTAzLTAxLTA3OjM1OjQyIDYwYjM0MWI3NzhjYzI5Mjlk
ZjE2YzBhNTA0YzkxNjIxYjNjNmE0YWQgY29tcGlsaW5nChtbMTszNW0yMDE0LTAzLTAxIDA3
OjM1OjQ0IGkzODYtcmFuZGNvbmZpZy14NC0wMjIxMjMxNjogbWFrZSBvbGRub2NvbmZpZyBm
YWlsZWQbWzBtChtbMTszNW0yMDE0LTAzLTAxIDA3OjM1OjQ0IGkzODYtcmFuZGNvbmZpZy14
NC0wMjIxMjMxNjogbWFrZSBvbGRjb25maWcgc3VjY2VlZGVkG1swbQozMiByZWFsICA0OTgg
dXNlciAgNDUgc3lzICAxNjg2LjMwJSBjcHUgCWkzODYtcmFuZGNvbmZpZy14NC0wMjIxMjMx
NgoyMDE0LTAzLTAxLTA3OjM2OjI0IDYwYjM0MWI3NzhjYzI5MjlkZjE2YzBhNTA0YzkxNjIx
YjNjNmE0YWQgU0tJUCBCUk9LRU4gQlVJTEQKQ2hlY2sgZXJyb3MgaW4gL2NjL3dmZy9uZXQt
YmlzZWN0IGFuZCAvdG1wL2tlcm5lbC9pMzg2LXJhbmRjb25maWcteDQtMDIyMTIzMTYvNjBi
MzQxYjc3OGNjMjkyOWRmMTZjMGE1MDRjOTE2MjFiM2M2YTRhZApiaXNlY3Q6IHNraXAgYnJv
a2VuIGJ1aWxkIGZvciB2Mi42LjMzCmdpdCBjaGVja291dCB2Mi42LjMyCmxzIC1hIC9rZXJu
ZWwtdGVzdHMvcnVuLXF1ZXVlL2t2bS9pMzg2LXJhbmRjb25maWcteDQtMDIyMTIzMTYvbmV4
dDptYXN0ZXI6MjI3NjNjNWNmMzY5MGE2ODE1NTExNjJjMTVkMzRkOTM1MzA4YzhkNzpiaXNl
Y3QtbmV0CgoyMDE0LTAzLTAxLTA3OjM2OjI5IDIyNzYzYzVjZjM2OTBhNjgxNTUxMTYyYzE1
ZDM0ZDkzNTMwOGM4ZDcgY29tcGlsaW5nChtbMTszNW0yMDE0LTAzLTAxIDA3OjM2OjMxIGkz
ODYtcmFuZGNvbmZpZy14NC0wMjIxMjMxNjogbWFrZSBvbGRub2NvbmZpZyBmYWlsZWQbWzBt
ChtbMTszNW0yMDE0LTAzLTAxIDA3OjM2OjM1IGkzODYtcmFuZGNvbmZpZy14NC0wMjIxMjMx
NjogbWFrZSBvbGRjb25maWcgc3VjY2VlZGVkG1swbQozNCByZWFsICA1MDEgdXNlciAgNDUg
c3lzICAxNjA0LjE5JSBjcHUgCWkzODYtcmFuZGNvbmZpZy14NC0wMjIxMjMxNgoyMDE0LTAz
LTAxLTA3OjM3OjE2IDIyNzYzYzVjZjM2OTBhNjgxNTUxMTYyYzE1ZDM0ZDkzNTMwOGM4ZDcg
U0tJUCBCUk9LRU4gQlVJTEQKQ2hlY2sgZXJyb3MgaW4gL2NjL3dmZy9uZXQtYmlzZWN0IGFu
ZCAvdG1wL2tlcm5lbC9pMzg2LXJhbmRjb25maWcteDQtMDIyMTIzMTYvMjI3NjNjNWNmMzY5
MGE2ODE1NTExNjJjMTVkMzRkOTM1MzA4YzhkNwpiaXNlY3Q6IHNraXAgYnJva2VuIGJ1aWxk
IGZvciB2Mi42LjMyCmdpdCBjaGVja291dCB2Mi42LjMxCmxzIC1hIC9rZXJuZWwtdGVzdHMv
cnVuLXF1ZXVlL2t2bS9pMzg2LXJhbmRjb25maWcteDQtMDIyMTIzMTYvbmV4dDptYXN0ZXI6
NzRmY2E2YTQyODYzZmZhY2FmN2JhNmYxOTM2YTlmMjI4OTUwZjY1NzpiaXNlY3QtbmV0Cgoy
MDE0LTAzLTAxLTA3OjM3OjE5IDc0ZmNhNmE0Mjg2M2ZmYWNhZjdiYTZmMTkzNmE5ZjIyODk1
MGY2NTcgY29tcGlsaW5nChtbMTszNW0yMDE0LTAzLTAxIDA3OjM3OjIzIGkzODYtcmFuZGNv
bmZpZy14NC0wMjIxMjMxNjogbWFrZSBvbGRub2NvbmZpZyBmYWlsZWQbWzBtChtbMTszNW0y
MDE0LTAzLTAxIDA3OjM3OjI2IGkzODYtcmFuZGNvbmZpZy14NC0wMjIxMjMxNjogbWFrZSBv
bGRjb25maWcgc3VjY2VlZGVkG1swbQo0MSByZWFsICA0NjEgdXNlciAgNDEgc3lzICAxMjA5
Ljg1JSBjcHUgCWkzODYtcmFuZGNvbmZpZy14NC0wMjIxMjMxNgoyMDE0LTAzLTAxLTA3OjM4
OjE4IDc0ZmNhNmE0Mjg2M2ZmYWNhZjdiYTZmMTkzNmE5ZjIyODk1MGY2NTcgU0tJUCBCUk9L
RU4gQlVJTEQKQ2hlY2sgZXJyb3MgaW4gL2NjL3dmZy9uZXQtYmlzZWN0IGFuZCAvdG1wL2tl
cm5lbC9pMzg2LXJhbmRjb25maWcteDQtMDIyMTIzMTYvNzRmY2E2YTQyODYzZmZhY2FmN2Jh
NmYxOTM2YTlmMjI4OTUwZjY1NwpiaXNlY3Q6IHNraXAgYnJva2VuIGJ1aWxkIGZvciB2Mi42
LjMxCmdpdCBjaGVja291dCB2Mi42LjMwCmxzIC1hIC9rZXJuZWwtdGVzdHMvcnVuLXF1ZXVl
L2t2bS9pMzg2LXJhbmRjb25maWcteDQtMDIyMTIzMTYvbmV4dDptYXN0ZXI6MDdhMjAzOWI4
ZWIwYWY0ZmY0NjRlZmQzZGZkOTVkZTVjMDI2NDhjNjpiaXNlY3QtbmV0CgoyMDE0LTAzLTAx
LTA3OjM4OjIyIDA3YTIwMzliOGViMGFmNGZmNDY0ZWZkM2RmZDk1ZGU1YzAyNjQ4YzYgY29t
cGlsaW5nChtbMTszNW0yMDE0LTAzLTAxIDA3OjM4OjI2IGkzODYtcmFuZGNvbmZpZy14NC0w
MjIxMjMxNjogbWFrZSBvbGRub2NvbmZpZyBmYWlsZWQbWzBtChtbMTszNW0yMDE0LTAzLTAx
IDA3OjM4OjI5IGkzODYtcmFuZGNvbmZpZy14NC0wMjIxMjMxNjogbWFrZSBvbGRjb25maWcg
c3VjY2VlZGVkG1swbQozNCByZWFsICA0MTggdXNlciAgMzcgc3lzICAxMzExLjM4JSBjcHUg
CWkzODYtcmFuZGNvbmZpZy14NC0wMjIxMjMxNgoyMDE0LTAzLTAxLTA3OjM5OjE1IDA3YTIw
MzliOGViMGFmNGZmNDY0ZWZkM2RmZDk1ZGU1YzAyNjQ4YzYgU0tJUCBCUk9LRU4gQlVJTEQK
Q2hlY2sgZXJyb3MgaW4gL2NjL3dmZy9uZXQtYmlzZWN0IGFuZCAvdG1wL2tlcm5lbC9pMzg2
LXJhbmRjb25maWcteDQtMDIyMTIzMTYvMDdhMjAzOWI4ZWIwYWY0ZmY0NjRlZmQzZGZkOTVk
ZTVjMDI2NDhjNgpiaXNlY3Q6IHNraXAgYnJva2VuIGJ1aWxkIGZvciB2Mi42LjMwCmdpdCBj
aGVja291dCB2Mi42LjI5CmxzIC1hIC9rZXJuZWwtdGVzdHMvcnVuLXF1ZXVlL2t2bS9pMzg2
LXJhbmRjb25maWcteDQtMDIyMTIzMTYvbmV4dDptYXN0ZXI6OGUwZWU0M2JjMmMzZTE5ZGI1
NmE0YWRhYTlhOWIwNGNlODg1Y2Q4NDpiaXNlY3QtbmV0CgoyMDE0LTAzLTAxLTA3OjM5OjE5
IDhlMGVlNDNiYzJjM2UxOWRiNTZhNGFkYWE5YTliMDRjZTg4NWNkODQgY29tcGlsaW5nChtb
MTszNW0yMDE0LTAzLTAxIDA3OjM5OjIyIGkzODYtcmFuZGNvbmZpZy14NC0wMjIxMjMxNjog
bWFrZSBvbGRub2NvbmZpZyBmYWlsZWQbWzBtChtbMTszNW0yMDE0LTAzLTAxIDA3OjM5OjIz
IGkzODYtcmFuZGNvbmZpZy14NC0wMjIxMjMxNjogbWFrZSBvbGRjb25maWcgc3VjY2VlZGVk
G1swbQo0MiByZWFsICA0MTEgdXNlciAgMzggc3lzICAxMDU2LjgyJSBjcHUgCWkzODYtcmFu
ZGNvbmZpZy14NC0wMjIxMjMxNgoyMDE0LTAzLTAxLTA3OjQwOjM4IDhlMGVlNDNiYzJjM2Ux
OWRiNTZhNGFkYWE5YTliMDRjZTg4NWNkODQgU0tJUCBCUk9LRU4gQlVJTEQKQ2hlY2sgZXJy
b3MgaW4gL2NjL3dmZy9uZXQtYmlzZWN0IGFuZCAvdG1wL2tlcm5lbC9pMzg2LXJhbmRjb25m
aWcteDQtMDIyMTIzMTYvOGUwZWU0M2JjMmMzZTE5ZGI1NmE0YWRhYTlhOWIwNGNlODg1Y2Q4
NApiaXNlY3Q6IHNraXAgYnJva2VuIGJ1aWxkIGZvciB2Mi42LjI5CmdpdCBjaGVja291dCB2
Mi42LjI4CmxzIC1hIC9rZXJuZWwtdGVzdHMvcnVuLXF1ZXVlL2t2bS9pMzg2LXJhbmRjb25m
aWcteDQtMDIyMTIzMTYvbmV4dDptYXN0ZXI6NGE2OTA4YTNhMDUwYWFjYzljM2EyZjM2YjI3
NmI0NmMwNjI5YWQ5MTpiaXNlY3QtbmV0CgoyMDE0LTAzLTAxLTA3OjQwOjQyIDRhNjkwOGEz
YTA1MGFhY2M5YzNhMmYzNmIyNzZiNDZjMDYyOWFkOTEgY29tcGlsaW5nChtbMTszNW0yMDE0
LTAzLTAxIDA3OjQwOjQ0IGkzODYtcmFuZGNvbmZpZy14NC0wMjIxMjMxNjogbWFrZSBvbGRu
b2NvbmZpZyBmYWlsZWQbWzBtChtbMTszNW0yMDE0LTAzLTAxIDA3OjQwOjQ4IGkzODYtcmFu
ZGNvbmZpZy14NC0wMjIxMjMxNjogbWFrZSBvbGRjb25maWcgc3VjY2VlZGVkG1swbQo0MiBy
ZWFsICA0MjggdXNlciAgNDIgc3lzICAxMTA2LjUxJSBjcHUgCWkzODYtcmFuZGNvbmZpZy14
NC0wMjIxMjMxNgoyMDE0LTAzLTAxLTA3OjQxOjUzIDRhNjkwOGEzYTA1MGFhY2M5YzNhMmYz
NmIyNzZiNDZjMDYyOWFkOTEgU0tJUCBCUk9LRU4gQlVJTEQKQ2hlY2sgZXJyb3MgaW4gL2Nj
L3dmZy9uZXQtYmlzZWN0IGFuZCAvdG1wL2tlcm5lbC9pMzg2LXJhbmRjb25maWcteDQtMDIy
MTIzMTYvNGE2OTA4YTNhMDUwYWFjYzljM2EyZjM2YjI3NmI0NmMwNjI5YWQ5MQpiaXNlY3Q6
IHNraXAgYnJva2VuIGJ1aWxkIGZvciB2Mi42LjI4CmdpdCBjaGVja291dCB2Mi42LjI3Cmxz
IC1hIC9rZXJuZWwtdGVzdHMvcnVuLXF1ZXVlL2t2bS9pMzg2LXJhbmRjb25maWcteDQtMDIy
MTIzMTYvbmV4dDptYXN0ZXI6M2ZhODc0OWU1ODRiNTVmMTE4MDQxMWFiMWI1MTExNzE5MGJh
YzFlNTpiaXNlY3QtbmV0CgoyMDE0LTAzLTAxLTA3OjQxOjU3IDNmYTg3NDllNTg0YjU1ZjEx
ODA0MTFhYjFiNTExMTcxOTBiYWMxZTUgY29tcGlsaW5nCjIwMTQtMDMtMDEgMDc6NDE6NTg6
IGNtZF9mYWlsOiAnL2Jpbi9ncmVwJyAnLXMnICctcScgJy1GJyAnJGFyY2ggZXEgImkzODYi
JyAnL2hvbWUvd2ZnL25ldC9zY3JpcHRzL3JlY29yZG1jb3VudC5wbCcgLCByZXQ9MiwgcmVm
OiAva2VybmVsLXRlc3RzL2ZhaWxlZC1jbWQvYmVlLWdyZXAtd2ZnLmxvZwobWzE7MzVtMjAx
NC0wMy0wMSAwNzo0MjowMCBpMzg2LXJhbmRjb25maWcteDQtMDIyMTIzMTY6IG1ha2Ugb2xk
bm9jb25maWcgZmFpbGVkG1swbQobWzE7MzVtMjAxNC0wMy0wMSAwNzo0MjowMyBpMzg2LXJh
bmRjb25maWcteDQtMDIyMTIzMTY6IG1ha2Ugb2xkY29uZmlnIHN1Y2NlZWRlZBtbMG0KMjkg
cmVhbCAgNDEyIHVzZXIgIDM2IHN5cyAgMTUzNS41OCUgY3B1IAlpMzg2LXJhbmRjb25maWct
eDQtMDIyMTIzMTYKMjAxNC0wMy0wMS0wNzo0Mjo0NiAzZmE4NzQ5ZTU4NGI1NWYxMTgwNDEx
YWIxYjUxMTE3MTkwYmFjMWU1IFNLSVAgQlJPS0VOIEJVSUxECkNoZWNrIGVycm9zIGluIC9j
Yy93ZmcvbmV0LWJpc2VjdCBhbmQgL3RtcC9rZXJuZWwvaTM4Ni1yYW5kY29uZmlnLXg0LTAy
MjEyMzE2LzNmYTg3NDllNTg0YjU1ZjExODA0MTFhYjFiNTExMTcxOTBiYWMxZTUKYmlzZWN0
OiBza2lwIGJyb2tlbiBidWlsZCBmb3IgdjIuNi4yNwpnaXQgY2hlY2tvdXQgdjIuNi4yNgps
cyAtYSAva2VybmVsLXRlc3RzL3J1bi1xdWV1ZS9rdm0vaTM4Ni1yYW5kY29uZmlnLXg0LTAy
MjEyMzE2L25leHQ6bWFzdGVyOmJjZTdmNzkzZGFlYzNlNjVlYzVjNTcwNWQyNDU3YjgxZmU3
YjU3MjU6YmlzZWN0LW5ldAoKMjAxNC0wMy0wMS0wNzo0Mjo1MCBiY2U3Zjc5M2RhZWMzZTY1
ZWM1YzU3MDVkMjQ1N2I4MWZlN2I1NzI1IGNvbXBpbGluZwoyMDE0LTAzLTAxIDA3OjQyOjUx
OiBjbWRfZmFpbDogJy9iaW4vZ3JlcCcgJy1zJyAnLXEnICctRicgJyRhcmNoIGVxICJpMzg2
IicgJy9ob21lL3dmZy9uZXQvc2NyaXB0cy9yZWNvcmRtY291bnQucGwnICwgcmV0PTIsIHJl
ZjogL2tlcm5lbC10ZXN0cy9mYWlsZWQtY21kL2JlZS1ncmVwLXdmZy5sb2cKG1sxOzM1bTIw
MTQtMDMtMDEgMDc6NDI6NTQgaTM4Ni1yYW5kY29uZmlnLXg0LTAyMjEyMzE2OiBtYWtlIG9s
ZG5vY29uZmlnIGZhaWxlZBtbMG0KG1sxOzM1bTIwMTQtMDMtMDEgMDc6NDI6NTcgaTM4Ni1y
YW5kY29uZmlnLXg0LTAyMjEyMzE2OiBtYWtlIG9sZGNvbmZpZyBzdWNjZWVkZWQbWzBtCjMx
IHJlYWwgIDM5NSB1c2VyICAzMiBzeXMgIDEzNTEuODklIGNwdSAJaTM4Ni1yYW5kY29uZmln
LXg0LTAyMjEyMzE2CjIwMTQtMDMtMDEtMDc6NDM6NDIgYmNlN2Y3OTNkYWVjM2U2NWVjNWM1
NzA1ZDI0NTdiODFmZTdiNTcyNSBTS0lQIEJST0tFTiBCVUlMRApDaGVjayBlcnJvcyBpbiAv
Y2Mvd2ZnL25ldC1iaXNlY3QgYW5kIC90bXAva2VybmVsL2kzODYtcmFuZGNvbmZpZy14NC0w
MjIxMjMxNi9iY2U3Zjc5M2RhZWMzZTY1ZWM1YzU3MDVkMjQ1N2I4MWZlN2I1NzI1CmJpc2Vj
dDogc2tpcCBicm9rZW4gYnVpbGQgZm9yIHYyLjYuMjYKZ2l0IGNoZWNrb3V0IHYyLjYuMjUK
bHMgLWEgL2tlcm5lbC10ZXN0cy9ydW4tcXVldWUva3ZtL2kzODYtcmFuZGNvbmZpZy14NC0w
MjIxMjMxNi9uZXh0Om1hc3Rlcjo0YjExOWUyMWQwYzY2YzIyZThjYTAzZGYwNWQ5ZGU2MjNk
MGViNTBmOmJpc2VjdC1uZXQKCjIwMTQtMDMtMDEtMDc6NDM6NDQgNGIxMTllMjFkMGM2NmMy
MmU4Y2EwM2RmMDVkOWRlNjIzZDBlYjUwZiBjb21waWxpbmcKMjAxNC0wMy0wMSAwNzo0Mzo0
NTogY21kX2ZhaWw6ICcvYmluL2dyZXAnICctcycgJy1xJyAnLUYnICckYXJjaCBlcSAiaTM4
NiInICcvaG9tZS93ZmcvbmV0L3NjcmlwdHMvcmVjb3JkbWNvdW50LnBsJyAsIHJldD0yLCBy
ZWY6IC9rZXJuZWwtdGVzdHMvZmFpbGVkLWNtZC9iZWUtZ3JlcC13ZmcubG9nChtbMTszNW0y
MDE0LTAzLTAxIDA3OjQzOjQ2IGkzODYtcmFuZGNvbmZpZy14NC0wMjIxMjMxNjogbWFrZSBv
bGRub2NvbmZpZyBmYWlsZWQbWzBtChtbMTszNW0yMDE0LTAzLTAxIDA3OjQzOjQ5IGkzODYt
cmFuZGNvbmZpZy14NC0wMjIxMjMxNjogbWFrZSBvbGRjb25maWcgc3VjY2VlZGVkG1swbQoy
MiByZWFsICAzNzggdXNlciAgMzIgc3lzICAxODM5LjE4JSBjcHUgCWkzODYtcmFuZGNvbmZp
Zy14NC0wMjIxMjMxNgoyMDE0LTAzLTAxLTA3OjQ0OjI1IDRiMTE5ZTIxZDBjNjZjMjJlOGNh
MDNkZjA1ZDlkZTYyM2QwZWI1MGYgU0tJUCBCUk9LRU4gQlVJTEQKQ2hlY2sgZXJyb3MgaW4g
L2NjL3dmZy9uZXQtYmlzZWN0IGFuZCAvdG1wL2tlcm5lbC9pMzg2LXJhbmRjb25maWcteDQt
MDIyMTIzMTYvNGIxMTllMjFkMGM2NmMyMmU4Y2EwM2RmMDVkOWRlNjIzZDBlYjUwZgpiaXNl
Y3Q6IHNraXAgYnJva2VuIGJ1aWxkIGZvciB2Mi42LjI1CmdpdCBjaGVja291dCB2Mi42LjI0
CmxzIC1hIC9rZXJuZWwtdGVzdHMvcnVuLXF1ZXVlL2t2bS9pMzg2LXJhbmRjb25maWcteDQt
MDIyMTIzMTYvbmV4dDptYXN0ZXI6NDk5MTQwODRlNzk3NTMwZDliYWFmNTFkZjllZGE3N2Jh
YmM5OGZhODpiaXNlY3QtbmV0CgoyMDE0LTAzLTAxLTA3OjQ0OjI4IDQ5OTE0MDg0ZTc5NzUz
MGQ5YmFhZjUxZGY5ZWRhNzdiYWJjOThmYTggY29tcGlsaW5nCjIwMTQtMDMtMDEgMDc6NDQ6
Mjk6IGNtZF9mYWlsOiAnL2Jpbi9ncmVwJyAnLXMnICctcScgJy1GJyAnJGFyY2ggZXEgImkz
ODYiJyAnL2hvbWUvd2ZnL25ldC9zY3JpcHRzL3JlY29yZG1jb3VudC5wbCcgLCByZXQ9Miwg
cmVmOiAva2VybmVsLXRlc3RzL2ZhaWxlZC1jbWQvYmVlLWdyZXAtd2ZnLmxvZwobWzE7MzVt
MjAxNC0wMy0wMSAwNzo0NDozMyBpMzg2LXJhbmRjb25maWcteDQtMDIyMTIzMTY6IG1ha2Ug
b2xkbm9jb25maWcgZmFpbGVkG1swbQobWzE7MzVtMjAxNC0wMy0wMSAwNzo0NDozNyBpMzg2
LXJhbmRjb25maWcteDQtMDIyMTIzMTY6IG1ha2Ugb2xkY29uZmlnIHN1Y2NlZWRlZBtbMG0K
MjYgcmVhbCAgMzQ4IHVzZXIgIDMwIHN5cyAgMTQwNC43NiUgY3B1IAlpMzg2LXJhbmRjb25m
aWcteDQtMDIyMTIzMTYKMjAxNC0wMy0wMS0wNzo0NToxNiA0OTkxNDA4NGU3OTc1MzBkOWJh
YWY1MWRmOWVkYTc3YmFiYzk4ZmE4IFNLSVAgQlJPS0VOIEJVSUxECkNoZWNrIGVycm9zIGlu
IC9jYy93ZmcvbmV0LWJpc2VjdCBhbmQgL3RtcC9rZXJuZWwvaTM4Ni1yYW5kY29uZmlnLXg0
LTAyMjEyMzE2LzQ5OTE0MDg0ZTc5NzUzMGQ5YmFhZjUxZGY5ZWRhNzdiYWJjOThmYTgKYmlz
ZWN0OiBza2lwIGJyb2tlbiBidWlsZCBmb3IgdjIuNi4yNApnaXQgY2hlY2tvdXQgdjIuNi4y
MwpscyAtYSAva2VybmVsLXRlc3RzL3J1bi1xdWV1ZS9rdm0vaTM4Ni1yYW5kY29uZmlnLXg0
LTAyMjEyMzE2L25leHQ6bWFzdGVyOmJiZjI1MDEwZjFhNmI3NjE5MTQ0MzBmNWZjYTA4MWVj
OGM3YWNjZDE6YmlzZWN0LW5ldAoKMjAxNC0wMy0wMS0wNzo0NToxOSBiYmYyNTAxMGYxYTZi
NzYxOTE0NDMwZjVmY2EwODFlYzhjN2FjY2QxIGNvbXBpbGluZwoyMDE0LTAzLTAxIDA3OjQ1
OjIwOiBjbWRfZmFpbDogJy9iaW4vZ3JlcCcgJy1zJyAnLXEnICctRicgJyRhcmNoIGVxICJp
Mzg2IicgJy9ob21lL3dmZy9uZXQvc2NyaXB0cy9yZWNvcmRtY291bnQucGwnICwgcmV0PTIs
IHJlZjogL2tlcm5lbC10ZXN0cy9mYWlsZWQtY21kL2JlZS1ncmVwLXdmZy5sb2cKG1sxOzM1
bTIwMTQtMDMtMDEgMDc6NDU6MjQgaTM4Ni1yYW5kY29uZmlnLXg0LTAyMjEyMzE2OiBtYWtl
IG9sZG5vY29uZmlnIGZhaWxlZBtbMG0KG1sxOzM1bTIwMTQtMDMtMDEgMDc6NDU6MjYgaTM4
Ni1yYW5kY29uZmlnLXg0LTAyMjEyMzE2OiBtYWtlIG9sZGNvbmZpZyBzdWNjZWVkZWQbWzBt
CjIzIHJlYWwgIDMxOCB1c2VyICAyNiBzeXMgIDE0NzIuMTMlIGNwdSAJaTM4Ni1yYW5kY29u
ZmlnLXg0LTAyMjEyMzE2CjIwMTQtMDMtMDEtMDc6NDY6MDMgYmJmMjUwMTBmMWE2Yjc2MTkx
NDQzMGY1ZmNhMDgxZWM4YzdhY2NkMSBTS0lQIEJST0tFTiBCVUlMRApDaGVjayBlcnJvcyBp
biAvY2Mvd2ZnL25ldC1iaXNlY3QgYW5kIC90bXAva2VybmVsL2kzODYtcmFuZGNvbmZpZy14
NC0wMjIxMjMxNi9iYmYyNTAxMGYxYTZiNzYxOTE0NDMwZjVmY2EwODFlYzhjN2FjY2QxCmJp
c2VjdDogc2tpcCBicm9rZW4gYnVpbGQgZm9yIHYyLjYuMjMKZ2l0IGNoZWNrb3V0IHYyLjYu
MjIKbHMgLWEgL2tlcm5lbC10ZXN0cy9ydW4tcXVldWUva3ZtL2kzODYtcmFuZGNvbmZpZy14
NC0wMjIxMjMxNi9uZXh0Om1hc3Rlcjo3ZGNjYTMwYTMyYWFkYjA1MjA0MTc1MjFiMGM0NGY0
MmQwOWZlMDVjOmJpc2VjdC1uZXQKCjIwMTQtMDMtMDEtMDc6NDY6MDYgN2RjY2EzMGEzMmFh
ZGIwNTIwNDE3NTIxYjBjNDRmNDJkMDlmZTA1YyBjb21waWxpbmcKMjAxNC0wMy0wMSAwNzo0
NjowNzogY21kX2ZhaWw6ICcvYmluL2dyZXAnICctcycgJy1xJyAnLUYnICckYXJjaCBlcSAi
aTM4NiInICcvaG9tZS93ZmcvbmV0L3NjcmlwdHMvcmVjb3JkbWNvdW50LnBsJyAsIHJldD0y
LCByZWY6IC9rZXJuZWwtdGVzdHMvZmFpbGVkLWNtZC9iZWUtZ3JlcC13ZmcubG9nChtbMTsz
NW0yMDE0LTAzLTAxIDA3OjQ2OjA4IGkzODYtcmFuZGNvbmZpZy14NC0wMjIxMjMxNjogbWFr
ZSBvbGRub2NvbmZpZyBmYWlsZWQbWzBtChtbMTszNW0yMDE0LTAzLTAxIDA3OjQ2OjEwIGkz
ODYtcmFuZGNvbmZpZy14NC0wMjIxMjMxNjogbWFrZSBvbGRjb25maWcgc3VjY2VlZGVkG1sw
bQoyNyByZWFsICAzMTAgdXNlciAgMjUgc3lzICAxMjA3LjkwJSBjcHUgCWkzODYtcmFuZGNv
bmZpZy14NC0wMjIxMjMxNgoyMDE0LTAzLTAxLTA3OjQ2OjU0IDdkY2NhMzBhMzJhYWRiMDUy
MDQxNzUyMWIwYzQ0ZjQyZDA5ZmUwNWMgU0tJUCBCUk9LRU4gQlVJTEQKQ2hlY2sgZXJyb3Mg
aW4gL2NjL3dmZy9uZXQtYmlzZWN0IGFuZCAvdG1wL2tlcm5lbC9pMzg2LXJhbmRjb25maWct
eDQtMDIyMTIzMTYvN2RjY2EzMGEzMmFhZGIwNTIwNDE3NTIxYjBjNDRmNDJkMDlmZTA1Ywpi
aXNlY3Q6IHNraXAgYnJva2VuIGJ1aWxkIGZvciB2Mi42LjIyCmdpdCBjaGVja291dCB2Mi42
LjIxCmxzIC1hIC9rZXJuZWwtdGVzdHMvcnVuLXF1ZXVlL2t2bS9pMzg2LXJhbmRjb25maWct
eDQtMDIyMTIzMTYvbmV4dDptYXN0ZXI6ZGU0NmMzMzc0NWY1ZTJhZDU5NGM3MmYyY2Y1ZjQ5
MDg2MWIxNmNlMTpiaXNlY3QtbmV0CgoyMDE0LTAzLTAxLTA3OjQ2OjU4IGRlNDZjMzM3NDVm
NWUyYWQ1OTRjNzJmMmNmNWY0OTA4NjFiMTZjZTEgY29tcGlsaW5nCjIwMTQtMDMtMDEgMDc6
NDY6NTg6IGNtZF9mYWlsOiAnL2Jpbi9ncmVwJyAnLXMnICctcScgJy1GJyAnJGFyY2ggZXEg
ImkzODYiJyAnL2hvbWUvd2ZnL25ldC9zY3JpcHRzL3JlY29yZG1jb3VudC5wbCcgLCByZXQ9
MiwgcmVmOiAva2VybmVsLXRlc3RzL2ZhaWxlZC1jbWQvYmVlLWdyZXAtd2ZnLmxvZwobWzE7
MzVtMjAxNC0wMy0wMSAwNzo0NzowMyBpMzg2LXJhbmRjb25maWcteDQtMDIyMTIzMTY6IG1h
a2Ugb2xkbm9jb25maWcgZmFpbGVkG1swbQobWzE7MzVtMjAxNC0wMy0wMSAwNzo0NzowNSBp
Mzg2LXJhbmRjb25maWcteDQtMDIyMTIzMTY6IG1ha2Ugb2xkY29uZmlnIHN1Y2NlZWRlZBtb
MG0KMTAgcmVhbCAgOSB1c2VyICAwIHN5cyAgOTkuNzMlIGNwdSAJaTM4Ni1yYW5kY29uZmln
LXg0LTAyMjEyMzE2CjIwMTQtMDMtMDEtMDc6NDc6MjYgZGU0NmMzMzc0NWY1ZTJhZDU5NGM3
MmYyY2Y1ZjQ5MDg2MWIxNmNlMSBTS0lQIEJST0tFTiBCVUlMRApDaGVjayBlcnJvcyBpbiAv
Y2Mvd2ZnL25ldC1iaXNlY3QgYW5kIC90bXAva2VybmVsL2kzODYtcmFuZGNvbmZpZy14NC0w
MjIxMjMxNi9kZTQ2YzMzNzQ1ZjVlMmFkNTk0YzcyZjJjZjVmNDkwODYxYjE2Y2UxCmJpc2Vj
dDogc2tpcCBicm9rZW4gYnVpbGQgZm9yIHYyLjYuMjEKZ2l0IGNoZWNrb3V0IHYyLjYuMjAK
bHMgLWEgL2tlcm5lbC10ZXN0cy9ydW4tcXVldWUva3ZtL2kzODYtcmFuZGNvbmZpZy14NC0w
MjIxMjMxNi9uZXh0Om1hc3Rlcjo2MmQwY2ZjYjI3Y2Y3NTVjZWJkYzkzY2E5NWRhYmM4MzYw
ODAwN2NkOmJpc2VjdC1uZXQKCjIwMTQtMDMtMDEtMDc6NDc6MjkgNjJkMGNmY2IyN2NmNzU1
Y2ViZGM5M2NhOTVkYWJjODM2MDgwMDdjZCBjb21waWxpbmcKMjAxNC0wMy0wMSAwNzo0Nzoy
OTogY21kX2ZhaWw6ICcvYmluL2dyZXAnICctcycgJy1xJyAnLUYnICckYXJjaCBlcSAiaTM4
NiInICcvaG9tZS93ZmcvbmV0L3NjcmlwdHMvcmVjb3JkbWNvdW50LnBsJyAsIHJldD0yLCBy
ZWY6IC9rZXJuZWwtdGVzdHMvZmFpbGVkLWNtZC9iZWUtZ3JlcC13ZmcubG9nChtbMTszNW0y
MDE0LTAzLTAxIDA3OjQ3OjMyIGkzODYtcmFuZGNvbmZpZy14NC0wMjIxMjMxNjogbWFrZSBv
bGRub2NvbmZpZyBmYWlsZWQbWzBtChtbMTszNW0yMDE0LTAzLTAxIDA3OjQ3OjMzIGkzODYt
cmFuZGNvbmZpZy14NC0wMjIxMjMxNjogbWFrZSBvbGRjb25maWcgc3VjY2VlZGVkG1swbQox
MCByZWFsICA5IHVzZXIgIDAgc3lzICA5OC42OSUgY3B1IAlpMzg2LXJhbmRjb25maWcteDQt
MDIyMTIzMTYKMjAxNC0wMy0wMS0wNzo0Nzo1NCA2MmQwY2ZjYjI3Y2Y3NTVjZWJkYzkzY2E5
NWRhYmM4MzYwODAwN2NkIFNLSVAgQlJPS0VOIEJVSUxECkNoZWNrIGVycm9zIGluIC9jYy93
ZmcvbmV0LWJpc2VjdCBhbmQgL3RtcC9rZXJuZWwvaTM4Ni1yYW5kY29uZmlnLXg0LTAyMjEy
MzE2LzYyZDBjZmNiMjdjZjc1NWNlYmRjOTNjYTk1ZGFiYzgzNjA4MDA3Y2QKYmlzZWN0OiBz
a2lwIGJyb2tlbiBidWlsZCBmb3IgdjIuNi4yMApnaXQgY2hlY2tvdXQgdjIuNi4xOQpscyAt
YSAva2VybmVsLXRlc3RzL3J1bi1xdWV1ZS9rdm0vaTM4Ni1yYW5kY29uZmlnLXg0LTAyMjEy
MzE2L25leHQ6bWFzdGVyOjAyMTVmZmIwOGNlOTllMmJiNTllY2ExMTRhOTk0OTlhNGQwNmU3
MDQ6YmlzZWN0LW5ldAoKMjAxNC0wMy0wMS0wNzo0Nzo1NyAwMjE1ZmZiMDhjZTk5ZTJiYjU5
ZWNhMTE0YTk5NDk5YTRkMDZlNzA0IGNvbXBpbGluZwoyMDE0LTAzLTAxIDA3OjQ3OjU3OiBj
bWRfZmFpbDogJy9iaW4vZ3JlcCcgJy1zJyAnLXEnICctRicgJyRhcmNoIGVxICJpMzg2Iicg
Jy9ob21lL3dmZy9uZXQvc2NyaXB0cy9yZWNvcmRtY291bnQucGwnICwgcmV0PTIsIHJlZjog
L2tlcm5lbC10ZXN0cy9mYWlsZWQtY21kL2JlZS1ncmVwLXdmZy5sb2cKG1sxOzM1bTIwMTQt
MDMtMDEgMDc6NDg6MDAgaTM4Ni1yYW5kY29uZmlnLXg0LTAyMjEyMzE2OiBtYWtlIG9sZG5v
Y29uZmlnIGZhaWxlZBtbMG0KG1sxOzM1bTIwMTQtMDMtMDEgMDc6NDg6MDMgaTM4Ni1yYW5k
Y29uZmlnLXg0LTAyMjEyMzE2OiBtYWtlIG9sZGNvbmZpZyBzdWNjZWVkZWQbWzBtCjEwIHJl
YWwgIDEwIHVzZXIgIDAgc3lzICAxMDMuMTElIGNwdSAJaTM4Ni1yYW5kY29uZmlnLXg0LTAy
MjEyMzE2CjIwMTQtMDMtMDEtMDc6NDg6MjQgMDIxNWZmYjA4Y2U5OWUyYmI1OWVjYTExNGE5
OTQ5OWE0ZDA2ZTcwNCBTS0lQIEJST0tFTiBCVUlMRApDaGVjayBlcnJvcyBpbiAvY2Mvd2Zn
L25ldC1iaXNlY3QgYW5kIC90bXAva2VybmVsL2kzODYtcmFuZGNvbmZpZy14NC0wMjIxMjMx
Ni8wMjE1ZmZiMDhjZTk5ZTJiYjU5ZWNhMTE0YTk5NDk5YTRkMDZlNzA0CmJpc2VjdDogc2tp
cCBicm9rZW4gYnVpbGQgZm9yIHYyLjYuMTkKG1sxOzM1bTIwMTQtMDMtMDEgMDc6NDg6MjUg
Q2Fubm90IGZpbmQgdGhlIGZpcnN0IGdvb2QgY29tbWl0LhtbMG0KG1sxOzM1bTIwMTQtMDMt
MDEgMDc6NDg6MjUgYmlzZWN0IGZhaWxlZBtbMG0K

--ikeVEW9yuYc//A+q
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="config-3.14.0-rc3-next-20140221-04488-gfaa2e6f"

#
# Automatically generated file; DO NOT EDIT.
# Linux/i386 3.14.0-rc3 Kernel Configuration
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
CONFIG_X86_32_LAZY_GS=y
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
# CONFIG_COMPILE_TEST is not set
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
CONFIG_SYSVIPC=y
# CONFIG_POSIX_MQUEUE is not set
# CONFIG_FHANDLE is not set
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
CONFIG_KTIME_SCALAR=y
CONFIG_GENERIC_CLOCKEVENTS=y
CONFIG_GENERIC_CLOCKEVENTS_BUILD=y
CONFIG_GENERIC_CLOCKEVENTS_BROADCAST=y
CONFIG_GENERIC_CLOCKEVENTS_MIN_ADJUST=y
CONFIG_GENERIC_CMOS_UPDATE=y

#
# Timers subsystem
#
CONFIG_HZ_PERIODIC=y
# CONFIG_NO_HZ_IDLE is not set
# CONFIG_NO_HZ is not set
# CONFIG_HIGH_RES_TIMERS is not set

#
# CPU/Task time and stats accounting
#
# CONFIG_TICK_CPU_ACCOUNTING is not set
CONFIG_IRQ_TIME_ACCOUNTING=y
CONFIG_BSD_PROCESS_ACCT=y
CONFIG_BSD_PROCESS_ACCT_V3=y
CONFIG_TASKSTATS=y
CONFIG_TASK_DELAY_ACCT=y
CONFIG_TASK_XACCT=y
# CONFIG_TASK_IO_ACCOUNTING is not set

#
# RCU Subsystem
#
CONFIG_TREE_RCU=y
# CONFIG_PREEMPT_RCU is not set
CONFIG_RCU_STALL_COMMON=y
CONFIG_RCU_FANOUT=32
CONFIG_RCU_FANOUT_LEAF=16
# CONFIG_RCU_FANOUT_EXACT is not set
CONFIG_TREE_RCU_TRACE=y
CONFIG_RCU_NOCB_CPU=y
# CONFIG_RCU_NOCB_CPU_NONE is not set
CONFIG_RCU_NOCB_CPU_ZERO=y
# CONFIG_RCU_NOCB_CPU_ALL is not set
CONFIG_IKCONFIG=y
CONFIG_LOG_BUF_SHIFT=17
CONFIG_HAVE_UNSTABLE_SCHED_CLOCK=y
CONFIG_ARCH_SUPPORTS_NUMA_BALANCING=y
CONFIG_ARCH_WANTS_PROT_NUMA_PROT_NONE=y
CONFIG_CGROUPS=y
CONFIG_CGROUP_DEBUG=y
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
# CONFIG_RD_LZ4 is not set
# CONFIG_CC_OPTIMIZE_FOR_SIZE is not set
CONFIG_ANON_INODES=y
CONFIG_HAVE_UID16=y
CONFIG_SYSCTL_EXCEPTION_TRACE=y
CONFIG_HAVE_PCSPKR_PLATFORM=y
CONFIG_EXPERT=y
CONFIG_UID16=y
CONFIG_SYSFS_SYSCALL=y
CONFIG_KALLSYMS=y
CONFIG_KALLSYMS_ALL=y
CONFIG_PRINTK=y
CONFIG_BUG=y
CONFIG_ELF_CORE=y
# CONFIG_PCSPKR_PLATFORM is not set
CONFIG_BASE_FULL=y
CONFIG_FUTEX=y
CONFIG_EPOLL=y
# CONFIG_SIGNALFD is not set
# CONFIG_TIMERFD is not set
# CONFIG_EVENTFD is not set
# CONFIG_SHMEM is not set
# CONFIG_AIO is not set
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
CONFIG_HAVE_CC_STACKPROTECTOR=y
# CONFIG_CC_STACKPROTECTOR is not set
CONFIG_CC_STACKPROTECTOR_NONE=y
# CONFIG_CC_STACKPROTECTOR_REGULAR is not set
# CONFIG_CC_STACKPROTECTOR_STRONG is not set
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
CONFIG_BASE_SMALL=0
# CONFIG_SYSTEM_TRUSTED_KEYRING is not set
# CONFIG_MODULES is not set
CONFIG_STOP_MACHINE=y
# CONFIG_BLOCK is not set
CONFIG_PADATA=y
CONFIG_ASN1=y
CONFIG_UNINLINE_SPIN_UNLOCK=y
# CONFIG_FREEZER is not set

#
# Processor type and features
#
# CONFIG_ZONE_DMA is not set
CONFIG_SMP=y
# CONFIG_X86_MPPARSE is not set
CONFIG_X86_BIGSMP=y
CONFIG_GOLDFISH=y
CONFIG_X86_EXTENDED_PLATFORM=y
CONFIG_X86_GOLDFISH=y
# CONFIG_X86_INTEL_LPSS is not set
CONFIG_X86_RDC321X=y
# CONFIG_X86_32_NON_STANDARD is not set
CONFIG_X86_32_IRIS=y
# CONFIG_SCHED_OMIT_FRAME_POINTER is not set
CONFIG_HYPERVISOR_GUEST=y
CONFIG_PARAVIRT=y
# CONFIG_PARAVIRT_DEBUG is not set
# CONFIG_PARAVIRT_SPINLOCKS is not set
# CONFIG_XEN_PRIVILEGED_GUEST is not set
CONFIG_KVM_GUEST=y
# CONFIG_KVM_DEBUG_FS is not set
# CONFIG_LGUEST_GUEST is not set
# CONFIG_PARAVIRT_TIME_ACCOUNTING is not set
CONFIG_PARAVIRT_CLOCK=y
CONFIG_NO_BOOTMEM=y
CONFIG_MEMTEST=y
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
CONFIG_SCHED_MC=y
CONFIG_PREEMPT_NONE=y
# CONFIG_PREEMPT_VOLUNTARY is not set
# CONFIG_PREEMPT is not set
CONFIG_PREEMPT_COUNT=y
CONFIG_X86_LOCAL_APIC=y
CONFIG_X86_IO_APIC=y
CONFIG_X86_REROUTE_FOR_BROKEN_BOOT_IRQS=y
CONFIG_X86_MCE=y
CONFIG_X86_MCE_INTEL=y
CONFIG_X86_MCE_AMD=y
CONFIG_X86_ANCIENT_MCE=y
CONFIG_X86_MCE_THRESHOLD=y
CONFIG_X86_MCE_INJECT=y
CONFIG_X86_THERMAL_VECTOR=y
CONFIG_VM86=y
# CONFIG_TOSHIBA is not set
CONFIG_I8K=y
CONFIG_X86_REBOOTFIXUPS=y
CONFIG_MICROCODE=y
# CONFIG_MICROCODE_INTEL is not set
# CONFIG_MICROCODE_AMD is not set
CONFIG_MICROCODE_OLD_INTERFACE=y
# CONFIG_MICROCODE_INTEL_EARLY is not set
# CONFIG_MICROCODE_AMD_EARLY is not set
CONFIG_MICROCODE_EARLY=y
# CONFIG_X86_MSR is not set
CONFIG_X86_CPUID=y
# CONFIG_NOHIGHMEM is not set
CONFIG_HIGHMEM4G=y
# CONFIG_HIGHMEM64G is not set
# CONFIG_VMSPLIT_3G is not set
# CONFIG_VMSPLIT_3G_OPT is not set
CONFIG_VMSPLIT_2G=y
# CONFIG_VMSPLIT_2G_OPT is not set
# CONFIG_VMSPLIT_1G is not set
CONFIG_PAGE_OFFSET=0x80000000
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
# CONFIG_MEMORY_HOTREMOVE is not set
CONFIG_SPLIT_PTLOCK_CPUS=4
# CONFIG_COMPACTION is not set
CONFIG_MIGRATION=y
# CONFIG_PHYS_ADDR_T_64BIT is not set
CONFIG_ZONE_DMA_FLAG=0
CONFIG_VIRT_TO_BUS=y
# CONFIG_KSM is not set
CONFIG_DEFAULT_MMAP_MIN_ADDR=4096
# CONFIG_TRANSPARENT_HUGEPAGE is not set
# CONFIG_CROSS_MEMORY_ATTACH is not set
CONFIG_CLEANCACHE=y
# CONFIG_CMA is not set
# CONFIG_ZBUD is not set
CONFIG_ZSMALLOC=y
# CONFIG_PGTABLE_MAPPING is not set
# CONFIG_HIGHPTE is not set
CONFIG_X86_CHECK_BIOS_CORRUPTION=y
# CONFIG_X86_BOOTPARAM_MEMORY_CORRUPTION_CHECK is not set
CONFIG_X86_RESERVE_LOW=64
# CONFIG_MATH_EMULATION is not set
# CONFIG_MTRR is not set
# CONFIG_ARCH_RANDOM is not set
CONFIG_X86_SMAP=y
# CONFIG_EFI is not set
# CONFIG_SECCOMP is not set
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
CONFIG_RANDOMIZE_BASE=y
CONFIG_RANDOMIZE_BASE_MAX_OFFSET=0x20000000
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
# CONFIG_SUSPEND is not set
# CONFIG_PM_RUNTIME is not set
CONFIG_ACPI=y
# CONFIG_ACPI_EC_DEBUGFS is not set
CONFIG_ACPI_AC=y
CONFIG_ACPI_BATTERY=y
CONFIG_ACPI_BUTTON=y
# CONFIG_ACPI_VIDEO is not set
CONFIG_ACPI_FAN=y
# CONFIG_ACPI_DOCK is not set
CONFIG_ACPI_PROCESSOR=y
CONFIG_ACPI_IPMI=y
CONFIG_ACPI_HOTPLUG_CPU=y
# CONFIG_ACPI_PROCESSOR_AGGREGATOR is not set
CONFIG_ACPI_THERMAL=y
# CONFIG_ACPI_CUSTOM_DSDT is not set
# CONFIG_ACPI_INITRD_TABLE_OVERRIDE is not set
# CONFIG_ACPI_DEBUG is not set
# CONFIG_ACPI_PCI_SLOT is not set
CONFIG_X86_PM_TIMER=y
CONFIG_ACPI_CONTAINER=y
# CONFIG_ACPI_HOTPLUG_MEMORY is not set
# CONFIG_ACPI_SBS is not set
# CONFIG_ACPI_HED is not set
# CONFIG_ACPI_CUSTOM_METHOD is not set
# CONFIG_ACPI_REDUCED_HARDWARE_ONLY is not set
# CONFIG_ACPI_APEI is not set
# CONFIG_ACPI_EXTLOG is not set
CONFIG_SFI=y

#
# CPU Frequency scaling
#
CONFIG_CPU_FREQ=y
CONFIG_CPU_FREQ_STAT=y
# CONFIG_CPU_FREQ_STAT_DETAILS is not set
# CONFIG_CPU_FREQ_DEFAULT_GOV_PERFORMANCE is not set
CONFIG_CPU_FREQ_DEFAULT_GOV_POWERSAVE=y
# CONFIG_CPU_FREQ_DEFAULT_GOV_USERSPACE is not set
# CONFIG_CPU_FREQ_DEFAULT_GOV_ONDEMAND is not set
# CONFIG_CPU_FREQ_DEFAULT_GOV_CONSERVATIVE is not set
CONFIG_CPU_FREQ_GOV_PERFORMANCE=y
CONFIG_CPU_FREQ_GOV_POWERSAVE=y
CONFIG_CPU_FREQ_GOV_USERSPACE=y
# CONFIG_CPU_FREQ_GOV_ONDEMAND is not set
# CONFIG_CPU_FREQ_GOV_CONSERVATIVE is not set

#
# x86 CPU frequency scaling drivers
#
CONFIG_X86_INTEL_PSTATE=y
# CONFIG_X86_PCC_CPUFREQ is not set
# CONFIG_X86_ACPI_CPUFREQ is not set
# CONFIG_X86_POWERNOW_K6 is not set
CONFIG_X86_POWERNOW_K7=y
CONFIG_X86_POWERNOW_K7_ACPI=y
# CONFIG_X86_GX_SUSPMOD is not set
# CONFIG_X86_SPEEDSTEP_CENTRINO is not set
CONFIG_X86_SPEEDSTEP_ICH=y
CONFIG_X86_SPEEDSTEP_SMI=y
# CONFIG_X86_P4_CLOCKMOD is not set
CONFIG_X86_CPUFREQ_NFORCE2=y
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
# CONFIG_CPU_IDLE_MULTIPLE_DRIVERS is not set
CONFIG_CPU_IDLE_GOV_LADDER=y
# CONFIG_CPU_IDLE_GOV_MENU is not set
# CONFIG_ARCH_NEEDS_CPU_IDLE_COUPLED is not set
# CONFIG_INTEL_IDLE is not set

#
# Bus options (PCI etc.)
#
CONFIG_PCI=y
# CONFIG_PCI_GOBIOS is not set
# CONFIG_PCI_GOMMCONFIG is not set
# CONFIG_PCI_GODIRECT is not set
CONFIG_PCI_GOANY=y
CONFIG_PCI_BIOS=y
CONFIG_PCI_DIRECT=y
CONFIG_PCI_MMCONFIG=y
CONFIG_PCI_DOMAINS=y
# CONFIG_PCI_CNB20LE_QUIRK is not set
# CONFIG_PCIEPORTBUS is not set
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

#
# PCI host controller drivers
#
CONFIG_ISA_DMA_API=y
CONFIG_ISA=y
CONFIG_EISA=y
# CONFIG_EISA_VLB_PRIMING is not set
CONFIG_EISA_PCI_EISA=y
CONFIG_EISA_VIRTUAL_ROOT=y
CONFIG_EISA_NAMES=y
CONFIG_SCx200=y
CONFIG_SCx200HR_TIMER=y
# CONFIG_OLPC is not set
CONFIG_ALIX=y
# CONFIG_NET5501 is not set
CONFIG_AMD_NB=y
# CONFIG_PCCARD is not set
# CONFIG_HOTPLUG_PCI is not set
# CONFIG_RAPIDIO is not set
CONFIG_X86_SYSFB=y

#
# Executable file formats / Emulations
#
CONFIG_BINFMT_ELF=y
CONFIG_ARCH_BINFMT_ELF_RANDOMIZE_PIE=y
CONFIG_CORE_DUMP_DEFAULT_ELF_HEADERS=y
CONFIG_BINFMT_SCRIPT=y
CONFIG_HAVE_AOUT=y
CONFIG_BINFMT_AOUT=y
# CONFIG_BINFMT_MISC is not set
CONFIG_COREDUMP=y
CONFIG_HAVE_ATOMIC_IOMAP=y
CONFIG_NET=y

#
# Networking options
#
CONFIG_PACKET=y
CONFIG_PACKET_DIAG=y
CONFIG_UNIX=y
CONFIG_UNIX_DIAG=y
CONFIG_XFRM=y
CONFIG_XFRM_ALGO=y
CONFIG_XFRM_USER=y
# CONFIG_XFRM_SUB_POLICY is not set
CONFIG_XFRM_MIGRATE=y
CONFIG_XFRM_IPCOMP=y
CONFIG_NET_KEY=y
# CONFIG_NET_KEY_MIGRATE is not set
CONFIG_INET=y
CONFIG_IP_MULTICAST=y
# CONFIG_IP_ADVANCED_ROUTER is not set
CONFIG_IP_PNP=y
CONFIG_IP_PNP_DHCP=y
CONFIG_IP_PNP_BOOTP=y
CONFIG_IP_PNP_RARP=y
# CONFIG_NET_IPIP is not set
CONFIG_NET_IPGRE_DEMUX=y
CONFIG_NET_IP_TUNNEL=y
CONFIG_NET_IPGRE=y
CONFIG_NET_IPGRE_BROADCAST=y
# CONFIG_IP_MROUTE is not set
CONFIG_SYN_COOKIES=y
CONFIG_NET_IPVTI=y
CONFIG_INET_AH=y
CONFIG_INET_ESP=y
CONFIG_INET_IPCOMP=y
CONFIG_INET_XFRM_TUNNEL=y
CONFIG_INET_TUNNEL=y
CONFIG_INET_XFRM_MODE_TRANSPORT=y
CONFIG_INET_XFRM_MODE_TUNNEL=y
CONFIG_INET_XFRM_MODE_BEET=y
# CONFIG_INET_LRO is not set
CONFIG_INET_DIAG=y
CONFIG_INET_TCP_DIAG=y
CONFIG_INET_UDP_DIAG=y
CONFIG_TCP_CONG_ADVANCED=y
CONFIG_TCP_CONG_BIC=y
# CONFIG_TCP_CONG_CUBIC is not set
# CONFIG_TCP_CONG_WESTWOOD is not set
CONFIG_TCP_CONG_HTCP=y
CONFIG_TCP_CONG_HSTCP=y
# CONFIG_TCP_CONG_HYBLA is not set
CONFIG_TCP_CONG_VEGAS=y
CONFIG_TCP_CONG_SCALABLE=y
CONFIG_TCP_CONG_LP=y
CONFIG_TCP_CONG_VENO=y
CONFIG_TCP_CONG_YEAH=y
# CONFIG_TCP_CONG_ILLINOIS is not set
CONFIG_DEFAULT_BIC=y
# CONFIG_DEFAULT_HTCP is not set
# CONFIG_DEFAULT_VEGAS is not set
# CONFIG_DEFAULT_VENO is not set
# CONFIG_DEFAULT_RENO is not set
CONFIG_DEFAULT_TCP_CONG="bic"
CONFIG_TCP_MD5SIG=y
CONFIG_IPV6=y
# CONFIG_IPV6_ROUTER_PREF is not set
CONFIG_IPV6_OPTIMISTIC_DAD=y
CONFIG_INET6_AH=y
CONFIG_INET6_ESP=y
CONFIG_INET6_IPCOMP=y
CONFIG_IPV6_MIP6=y
CONFIG_INET6_XFRM_TUNNEL=y
CONFIG_INET6_TUNNEL=y
CONFIG_INET6_XFRM_MODE_TRANSPORT=y
CONFIG_INET6_XFRM_MODE_TUNNEL=y
# CONFIG_INET6_XFRM_MODE_BEET is not set
CONFIG_INET6_XFRM_MODE_ROUTEOPTIMIZATION=y
# CONFIG_IPV6_VTI is not set
CONFIG_IPV6_SIT=y
CONFIG_IPV6_SIT_6RD=y
CONFIG_IPV6_NDISC_NODETYPE=y
CONFIG_IPV6_TUNNEL=y
# CONFIG_IPV6_GRE is not set
CONFIG_IPV6_MULTIPLE_TABLES=y
# CONFIG_IPV6_SUBTREES is not set
CONFIG_IPV6_MROUTE=y
CONFIG_IPV6_MROUTE_MULTIPLE_TABLES=y
# CONFIG_IPV6_PIMSM_V2 is not set
# CONFIG_NETWORK_SECMARK is not set
CONFIG_NETWORK_PHY_TIMESTAMPING=y
# CONFIG_NETFILTER is not set
# CONFIG_IP_DCCP is not set
# CONFIG_IP_SCTP is not set
CONFIG_RDS=y
# CONFIG_RDS_TCP is not set
CONFIG_RDS_DEBUG=y
CONFIG_TIPC=y
CONFIG_TIPC_PORTS=8191
CONFIG_ATM=y
CONFIG_ATM_CLIP=y
CONFIG_ATM_CLIP_NO_ICMP=y
CONFIG_ATM_LANE=y
CONFIG_ATM_MPOA=y
# CONFIG_ATM_BR2684 is not set
# CONFIG_L2TP is not set
CONFIG_STP=y
CONFIG_BRIDGE=y
# CONFIG_BRIDGE_IGMP_SNOOPING is not set
# CONFIG_VLAN_8021Q is not set
CONFIG_DECNET=y
CONFIG_DECNET_ROUTER=y
CONFIG_LLC=y
# CONFIG_LLC2 is not set
CONFIG_IPX=y
CONFIG_IPX_INTERN=y
CONFIG_ATALK=y
CONFIG_DEV_APPLETALK=y
CONFIG_LTPC=y
# CONFIG_COPS is not set
# CONFIG_IPDDP is not set
# CONFIG_X25 is not set
CONFIG_LAPB=y
# CONFIG_PHONET is not set
# CONFIG_IEEE802154 is not set
CONFIG_NET_SCHED=y

#
# Queueing/Scheduling
#
# CONFIG_NET_SCH_CBQ is not set
# CONFIG_NET_SCH_HTB is not set
CONFIG_NET_SCH_HFSC=y
CONFIG_NET_SCH_ATM=y
CONFIG_NET_SCH_PRIO=y
CONFIG_NET_SCH_MULTIQ=y
# CONFIG_NET_SCH_RED is not set
CONFIG_NET_SCH_SFB=y
CONFIG_NET_SCH_SFQ=y
CONFIG_NET_SCH_TEQL=y
CONFIG_NET_SCH_TBF=y
CONFIG_NET_SCH_GRED=y
CONFIG_NET_SCH_DSMARK=y
CONFIG_NET_SCH_NETEM=y
CONFIG_NET_SCH_DRR=y
CONFIG_NET_SCH_MQPRIO=y
# CONFIG_NET_SCH_CHOKE is not set
# CONFIG_NET_SCH_QFQ is not set
CONFIG_NET_SCH_CODEL=y
CONFIG_NET_SCH_FQ_CODEL=y
CONFIG_NET_SCH_FQ=y
CONFIG_NET_SCH_HHF=y
CONFIG_NET_SCH_PIE=y
CONFIG_NET_SCH_INGRESS=y
CONFIG_NET_SCH_PLUG=y

#
# Classification
#
CONFIG_NET_CLS=y
CONFIG_NET_CLS_BASIC=y
# CONFIG_NET_CLS_TCINDEX is not set
# CONFIG_NET_CLS_ROUTE4 is not set
CONFIG_NET_CLS_FW=y
CONFIG_NET_CLS_U32=y
CONFIG_CLS_U32_PERF=y
CONFIG_CLS_U32_MARK=y
# CONFIG_NET_CLS_RSVP is not set
CONFIG_NET_CLS_RSVP6=y
CONFIG_NET_CLS_FLOW=y
# CONFIG_NET_CLS_CGROUP is not set
CONFIG_NET_CLS_BPF=y
# CONFIG_NET_EMATCH is not set
CONFIG_NET_CLS_ACT=y
CONFIG_NET_ACT_POLICE=y
CONFIG_NET_ACT_GACT=y
# CONFIG_GACT_PROB is not set
CONFIG_NET_ACT_MIRRED=y
CONFIG_NET_ACT_NAT=y
# CONFIG_NET_ACT_PEDIT is not set
CONFIG_NET_ACT_SIMP=y
CONFIG_NET_ACT_SKBEDIT=y
# CONFIG_NET_ACT_CSUM is not set
CONFIG_NET_CLS_IND=y
CONFIG_NET_SCH_FIFO=y
CONFIG_DCB=y
CONFIG_DNS_RESOLVER=y
CONFIG_BATMAN_ADV=y
CONFIG_BATMAN_ADV_BLA=y
# CONFIG_BATMAN_ADV_DAT is not set
CONFIG_BATMAN_ADV_NC=y
CONFIG_BATMAN_ADV_DEBUG=y
CONFIG_OPENVSWITCH=y
CONFIG_OPENVSWITCH_GRE=y
# CONFIG_VSOCKETS is not set
CONFIG_NETLINK_MMAP=y
# CONFIG_NETLINK_DIAG is not set
CONFIG_NET_MPLS_GSO=y
# CONFIG_HSR is not set
CONFIG_RPS=y
CONFIG_RFS_ACCEL=y
CONFIG_XPS=y
# CONFIG_CGROUP_NET_PRIO is not set
# CONFIG_CGROUP_NET_CLASSID is not set
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
CONFIG_AX25=y
# CONFIG_AX25_DAMA_SLAVE is not set
# CONFIG_NETROM is not set
CONFIG_ROSE=y

#
# AX.25 network device drivers
#
# CONFIG_MKISS is not set
# CONFIG_6PACK is not set
CONFIG_BPQETHER=y
CONFIG_SCC=y
CONFIG_SCC_DELAY=y
# CONFIG_SCC_TRXECHO is not set
CONFIG_BAYCOM_SER_FDX=y
CONFIG_BAYCOM_SER_HDX=y
CONFIG_BAYCOM_PAR=y
# CONFIG_BAYCOM_EPP is not set
CONFIG_YAM=y
# CONFIG_CAN is not set
CONFIG_IRDA=y

#
# IrDA protocols
#
CONFIG_IRLAN=y
# CONFIG_IRCOMM is not set
# CONFIG_IRDA_ULTRA is not set

#
# IrDA options
#
CONFIG_IRDA_CACHE_LAST_LSAP=y
# CONFIG_IRDA_FAST_RR is not set
CONFIG_IRDA_DEBUG=y

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

#
# FIR device drivers
#
CONFIG_NSC_FIR=y
CONFIG_WINBOND_FIR=y
# CONFIG_TOSHIBA_FIR is not set
# CONFIG_SMC_IRCC_FIR is not set
# CONFIG_ALI_FIR is not set
# CONFIG_VLSI_FIR is not set
CONFIG_VIA_FIR=y
# CONFIG_BT is not set
CONFIG_AF_RXRPC=y
CONFIG_AF_RXRPC_DEBUG=y
CONFIG_RXKAD=y
CONFIG_FIB_RULES=y
# CONFIG_WIRELESS is not set
# CONFIG_WIMAX is not set
CONFIG_RFKILL=y
# CONFIG_RFKILL_INPUT is not set
CONFIG_RFKILL_REGULATOR=y
CONFIG_RFKILL_GPIO=y
CONFIG_NET_9P=y
CONFIG_NET_9P_VIRTIO=y
CONFIG_NET_9P_DEBUG=y
# CONFIG_CAIF is not set
CONFIG_CEPH_LIB=y
CONFIG_CEPH_LIB_PRETTYDEBUG=y
# CONFIG_CEPH_LIB_USE_DNS_RESOLVER is not set
CONFIG_NFC=y
# CONFIG_NFC_DIGITAL is not set
CONFIG_NFC_NCI=y
CONFIG_NFC_HCI=y
CONFIG_NFC_SHDLC=y

#
# Near Field Communication (NFC) devices
#
CONFIG_NFC_SIM=y
# CONFIG_NFC_PN544 is not set
# CONFIG_NFC_MICROREAD is not set
# CONFIG_NFC_MRVL is not set

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
CONFIG_GENERIC_CPU_AUTOPROBE=y
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
CONFIG_ARCH_MIGHT_HAVE_PC_PARPORT=y
CONFIG_PARPORT_PC=y
# CONFIG_PARPORT_SERIAL is not set
# CONFIG_PARPORT_PC_FIFO is not set
# CONFIG_PARPORT_PC_SUPERIO is not set
# CONFIG_PARPORT_GSC is not set
CONFIG_PARPORT_AX88796=y
# CONFIG_PARPORT_1284 is not set
CONFIG_PARPORT_NOT_PC=y
CONFIG_PNP=y
CONFIG_PNP_DEBUG_MESSAGES=y

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
CONFIG_AD525X_DPOT=y
CONFIG_AD525X_DPOT_I2C=y
CONFIG_DUMMY_IRQ=y
# CONFIG_IBM_ASM is not set
# CONFIG_PHANTOM is not set
# CONFIG_SGI_IOC4 is not set
# CONFIG_TIFM_CORE is not set
CONFIG_ICS932S401=y
# CONFIG_ATMEL_SSC is not set
CONFIG_ENCLOSURE_SERVICES=y
# CONFIG_HP_ILO is not set
CONFIG_APDS9802ALS=y
CONFIG_ISL29003=y
# CONFIG_ISL29020 is not set
# CONFIG_SENSORS_TSL2550 is not set
# CONFIG_SENSORS_BH1780 is not set
# CONFIG_SENSORS_BH1770 is not set
CONFIG_SENSORS_APDS990X=y
CONFIG_HMC6352=y
CONFIG_DS1682=y
# CONFIG_VMWARE_BALLOON is not set
CONFIG_BMP085=y
CONFIG_BMP085_I2C=y
# CONFIG_PCH_PHUB is not set
CONFIG_USB_SWITCH_FSA9480=y
CONFIG_SRAM=y
CONFIG_C2PORT=y
# CONFIG_C2PORT_DURAMAR_2150 is not set

#
# EEPROM support
#
CONFIG_EEPROM_AT24=y
# CONFIG_EEPROM_LEGACY is not set
CONFIG_EEPROM_MAX6875=y
CONFIG_EEPROM_93CX6=y
# CONFIG_CB710_CORE is not set

#
# Texas Instruments shared transport line discipline
#
# CONFIG_TI_ST is not set
# CONFIG_SENSORS_LIS3_I2C is not set

#
# Altera FPGA firmware download module
#
# CONFIG_ALTERA_STAPL is not set
# CONFIG_INTEL_MEI is not set
# CONFIG_INTEL_MEI_ME is not set
# CONFIG_INTEL_MEI_TXE is not set
# CONFIG_VMWARE_VMCI is not set

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
# CONFIG_FUSION is not set

#
# IEEE 1394 (FireWire) support
#
# CONFIG_FIREWIRE is not set
# CONFIG_FIREWIRE_NOSY is not set
# CONFIG_I2O is not set
# CONFIG_MACINTOSH_DRIVERS is not set
# CONFIG_NETDEVICES is not set

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
# CONFIG_KEYBOARD_LM8333 is not set
# CONFIG_KEYBOARD_MAX7359 is not set
# CONFIG_KEYBOARD_MCS is not set
# CONFIG_KEYBOARD_MPR121 is not set
# CONFIG_KEYBOARD_NEWTON is not set
# CONFIG_KEYBOARD_OPENCORES is not set
# CONFIG_KEYBOARD_GOLDFISH_EVENTS is not set
# CONFIG_KEYBOARD_STOWAWAY is not set
# CONFIG_KEYBOARD_SUNKBD is not set
# CONFIG_KEYBOARD_STMPE is not set
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
CONFIG_ARCH_MIGHT_HAVE_PC_SERIO=y
CONFIG_SERIO_I8042=y
CONFIG_SERIO_SERPORT=y
# CONFIG_SERIO_CT82C710 is not set
# CONFIG_SERIO_PARKBD is not set
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
# CONFIG_VT is not set
CONFIG_UNIX98_PTYS=y
# CONFIG_DEVPTS_MULTIPLE_INSTANCES is not set
CONFIG_LEGACY_PTYS=y
CONFIG_LEGACY_PTY_COUNT=256
# CONFIG_SERIAL_NONSTANDARD is not set
# CONFIG_NOZOMI is not set
# CONFIG_N_GSM is not set
# CONFIG_TRACE_SINK is not set
# CONFIG_GOLDFISH_TTY is not set
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
# CONFIG_TTY_PRINTK is not set
# CONFIG_PRINTER is not set
CONFIG_PPDEV=y
# CONFIG_VIRTIO_CONSOLE is not set
CONFIG_IPMI_HANDLER=y
CONFIG_IPMI_PANIC_EVENT=y
# CONFIG_IPMI_PANIC_STRING is not set
CONFIG_IPMI_DEVICE_INTERFACE=y
CONFIG_IPMI_SI=y
# CONFIG_IPMI_WATCHDOG is not set
CONFIG_IPMI_POWEROFF=y
CONFIG_HW_RANDOM=y
CONFIG_HW_RANDOM_TIMERIOMEM=y
CONFIG_HW_RANDOM_INTEL=y
CONFIG_HW_RANDOM_AMD=y
CONFIG_HW_RANDOM_GEODE=y
# CONFIG_HW_RANDOM_VIA is not set
# CONFIG_HW_RANDOM_VIRTIO is not set
CONFIG_HW_RANDOM_TPM=y
# CONFIG_NVRAM is not set
CONFIG_DTLK=y
# CONFIG_R3964 is not set
# CONFIG_APPLICOM is not set
# CONFIG_SONYPI is not set
# CONFIG_MWAVE is not set
CONFIG_SCx200_GPIO=y
CONFIG_PC8736x_GPIO=y
CONFIG_NSC_GPIO=y
# CONFIG_HPET is not set
# CONFIG_HANGCHECK_TIMER is not set
CONFIG_TCG_TPM=y
CONFIG_TCG_TIS=y
# CONFIG_TCG_TIS_I2C_ATMEL is not set
# CONFIG_TCG_TIS_I2C_INFINEON is not set
CONFIG_TCG_TIS_I2C_NUVOTON=y
# CONFIG_TCG_NSC is not set
# CONFIG_TCG_ATMEL is not set
# CONFIG_TCG_INFINEON is not set
CONFIG_TCG_ST33_I2C=y
CONFIG_TELCLOCK=y
CONFIG_DEVPORT=y
CONFIG_I2C=y
CONFIG_I2C_BOARDINFO=y
CONFIG_I2C_COMPAT=y
# CONFIG_I2C_CHARDEV is not set
# CONFIG_I2C_MUX is not set
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
CONFIG_I2C_CBUS_GPIO=y
CONFIG_I2C_DESIGNWARE_CORE=y
CONFIG_I2C_DESIGNWARE_PLATFORM=y
# CONFIG_I2C_DESIGNWARE_PCI is not set
# CONFIG_I2C_EG20T is not set
CONFIG_I2C_GPIO=y
CONFIG_I2C_KEMPLD=y
# CONFIG_I2C_OCORES is not set
CONFIG_I2C_PCA_PLATFORM=y
# CONFIG_I2C_PXA_PCI is not set
CONFIG_I2C_SIMTEC=y
CONFIG_I2C_XILINX=y

#
# External I2C/SMBus adapter drivers
#
# CONFIG_I2C_PARPORT is not set
CONFIG_I2C_PARPORT_LIGHT=y
# CONFIG_I2C_TAOS_EVM is not set

#
# Other I2C/SMBus bus drivers
#
CONFIG_I2C_PCA_ISA=y
CONFIG_SCx200_I2C=y
CONFIG_SCx200_I2C_SCL=12
CONFIG_SCx200_I2C_SDA=13
# CONFIG_SCx200_ACB is not set
# CONFIG_I2C_DEBUG_CORE is not set
# CONFIG_I2C_DEBUG_ALGO is not set
# CONFIG_I2C_DEBUG_BUS is not set
# CONFIG_SPI is not set
CONFIG_SPMI=y
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
CONFIG_GPIOLIB=y
CONFIG_GPIO_DEVRES=y
CONFIG_GPIO_ACPI=y
CONFIG_DEBUG_GPIO=y
CONFIG_GPIO_SYSFS=y
CONFIG_GPIO_GENERIC=y
CONFIG_GPIO_DA9052=y

#
# Memory mapped GPIO drivers:
#
CONFIG_GPIO_GENERIC_PLATFORM=y
CONFIG_GPIO_IT8761E=y
CONFIG_GPIO_F7188X=y
# CONFIG_GPIO_SCH311X is not set
# CONFIG_GPIO_TS5500 is not set
# CONFIG_GPIO_SCH is not set
# CONFIG_GPIO_ICH is not set
# CONFIG_GPIO_VX855 is not set
# CONFIG_GPIO_LYNXPOINT is not set

#
# I2C GPIO expanders:
#
CONFIG_GPIO_ARIZONA=y
# CONFIG_GPIO_LP3943 is not set
# CONFIG_GPIO_MAX7300 is not set
# CONFIG_GPIO_MAX732X is not set
CONFIG_GPIO_PCA953X=y
# CONFIG_GPIO_PCA953X_IRQ is not set
CONFIG_GPIO_PCF857X=y
# CONFIG_GPIO_RC5T583 is not set
CONFIG_GPIO_SX150X=y
# CONFIG_GPIO_STMPE is not set
CONFIG_GPIO_TWL6040=y
# CONFIG_GPIO_WM831X is not set
CONFIG_GPIO_WM8994=y
CONFIG_GPIO_ADP5520=y
# CONFIG_GPIO_ADP5588 is not set

#
# PCI GPIO expanders:
#
# CONFIG_GPIO_BT8XX is not set
# CONFIG_GPIO_AMD8111 is not set
# CONFIG_GPIO_INTEL_MID is not set
# CONFIG_GPIO_PCH is not set
# CONFIG_GPIO_ML_IOH is not set
# CONFIG_GPIO_RDC321X is not set

#
# SPI GPIO expanders:
#

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
CONFIG_GPIO_TPS6586X=y

#
# USB GPIO expanders:
#
CONFIG_W1=y
CONFIG_W1_CON=y

#
# 1-wire Bus Masters
#
# CONFIG_W1_MASTER_MATROX is not set
CONFIG_W1_MASTER_DS2482=y
CONFIG_W1_MASTER_DS1WM=y
CONFIG_W1_MASTER_GPIO=y

#
# 1-wire Slaves
#
CONFIG_W1_SLAVE_THERM=y
CONFIG_W1_SLAVE_SMEM=y
# CONFIG_W1_SLAVE_DS2408 is not set
# CONFIG_W1_SLAVE_DS2413 is not set
CONFIG_W1_SLAVE_DS2423=y
CONFIG_W1_SLAVE_DS2431=y
CONFIG_W1_SLAVE_DS2433=y
# CONFIG_W1_SLAVE_DS2433_CRC is not set
CONFIG_W1_SLAVE_DS2760=y
CONFIG_W1_SLAVE_DS2780=y
# CONFIG_W1_SLAVE_DS2781 is not set
CONFIG_W1_SLAVE_DS28E04=y
CONFIG_W1_SLAVE_BQ27000=y
CONFIG_POWER_SUPPLY=y
# CONFIG_POWER_SUPPLY_DEBUG is not set
# CONFIG_PDA_POWER is not set
# CONFIG_GENERIC_ADC_BATTERY is not set
# CONFIG_MAX8925_POWER is not set
# CONFIG_WM831X_BACKUP is not set
# CONFIG_WM831X_POWER is not set
# CONFIG_TEST_POWER is not set
# CONFIG_BATTERY_DS2760 is not set
# CONFIG_BATTERY_DS2780 is not set
# CONFIG_BATTERY_DS2781 is not set
# CONFIG_BATTERY_DS2782 is not set
# CONFIG_BATTERY_SBS is not set
# CONFIG_BATTERY_BQ27x00 is not set
# CONFIG_BATTERY_DA9030 is not set
# CONFIG_BATTERY_DA9052 is not set
# CONFIG_BATTERY_MAX17040 is not set
# CONFIG_BATTERY_MAX17042 is not set
# CONFIG_CHARGER_PCF50633 is not set
# CONFIG_CHARGER_MAX8903 is not set
# CONFIG_CHARGER_LP8727 is not set
# CONFIG_CHARGER_GPIO is not set
# CONFIG_CHARGER_MAX14577 is not set
# CONFIG_CHARGER_MAX8997 is not set
# CONFIG_CHARGER_BQ2415X is not set
# CONFIG_CHARGER_BQ24190 is not set
# CONFIG_CHARGER_BQ24735 is not set
# CONFIG_CHARGER_SMB347 is not set
# CONFIG_CHARGER_TPS65090 is not set
# CONFIG_BATTERY_GOLDFISH is not set
# CONFIG_POWER_RESET is not set
CONFIG_POWER_AVS=y
CONFIG_HWMON=y
CONFIG_HWMON_VID=y
CONFIG_HWMON_DEBUG_CHIP=y

#
# Native drivers
#
CONFIG_SENSORS_AD7414=y
CONFIG_SENSORS_AD7418=y
# CONFIG_SENSORS_ADM1021 is not set
CONFIG_SENSORS_ADM1025=y
CONFIG_SENSORS_ADM1026=y
CONFIG_SENSORS_ADM1029=y
CONFIG_SENSORS_ADM1031=y
CONFIG_SENSORS_ADM9240=y
CONFIG_SENSORS_ADT7X10=y
CONFIG_SENSORS_ADT7410=y
CONFIG_SENSORS_ADT7411=y
CONFIG_SENSORS_ADT7462=y
# CONFIG_SENSORS_ADT7470 is not set
CONFIG_SENSORS_ADT7475=y
# CONFIG_SENSORS_ASC7621 is not set
# CONFIG_SENSORS_K8TEMP is not set
# CONFIG_SENSORS_K10TEMP is not set
# CONFIG_SENSORS_FAM15H_POWER is not set
# CONFIG_SENSORS_APPLESMC is not set
CONFIG_SENSORS_ASB100=y
CONFIG_SENSORS_ATXP1=y
CONFIG_SENSORS_DS620=y
CONFIG_SENSORS_DS1621=y
CONFIG_SENSORS_DA9052_ADC=y
# CONFIG_SENSORS_I5K_AMB is not set
# CONFIG_SENSORS_F71805F is not set
# CONFIG_SENSORS_F71882FG is not set
CONFIG_SENSORS_F75375S=y
# CONFIG_SENSORS_FSCHMD is not set
# CONFIG_SENSORS_GL518SM is not set
CONFIG_SENSORS_GL520SM=y
CONFIG_SENSORS_G760A=y
# CONFIG_SENSORS_G762 is not set
CONFIG_SENSORS_GPIO_FAN=y
CONFIG_SENSORS_HIH6130=y
CONFIG_SENSORS_IBMAEM=y
CONFIG_SENSORS_IBMPEX=y
CONFIG_SENSORS_IIO_HWMON=y
# CONFIG_SENSORS_CORETEMP is not set
CONFIG_SENSORS_IT87=y
CONFIG_SENSORS_JC42=y
# CONFIG_SENSORS_LINEAGE is not set
CONFIG_SENSORS_LTC2945=y
# CONFIG_SENSORS_LTC4151 is not set
CONFIG_SENSORS_LTC4215=y
# CONFIG_SENSORS_LTC4222 is not set
# CONFIG_SENSORS_LTC4245 is not set
CONFIG_SENSORS_LTC4260=y
# CONFIG_SENSORS_LTC4261 is not set
CONFIG_SENSORS_MAX16065=y
# CONFIG_SENSORS_MAX1619 is not set
CONFIG_SENSORS_MAX1668=y
CONFIG_SENSORS_MAX197=y
CONFIG_SENSORS_MAX6639=y
CONFIG_SENSORS_MAX6642=y
CONFIG_SENSORS_MAX6650=y
CONFIG_SENSORS_MAX6697=y
CONFIG_SENSORS_HTU21=y
CONFIG_SENSORS_MCP3021=y
CONFIG_SENSORS_LM63=y
# CONFIG_SENSORS_LM73 is not set
# CONFIG_SENSORS_LM75 is not set
# CONFIG_SENSORS_LM77 is not set
# CONFIG_SENSORS_LM78 is not set
# CONFIG_SENSORS_LM80 is not set
# CONFIG_SENSORS_LM83 is not set
# CONFIG_SENSORS_LM85 is not set
# CONFIG_SENSORS_LM87 is not set
CONFIG_SENSORS_LM90=y
CONFIG_SENSORS_LM92=y
CONFIG_SENSORS_LM93=y
CONFIG_SENSORS_LM95234=y
# CONFIG_SENSORS_LM95241 is not set
CONFIG_SENSORS_LM95245=y
CONFIG_SENSORS_PC87360=y
CONFIG_SENSORS_PC87427=y
# CONFIG_SENSORS_NCT6775 is not set
# CONFIG_SENSORS_PCF8591 is not set
# CONFIG_PMBUS is not set
# CONFIG_SENSORS_SHT15 is not set
CONFIG_SENSORS_SHT21=y
# CONFIG_SENSORS_SIS5595 is not set
CONFIG_SENSORS_DME1737=y
# CONFIG_SENSORS_EMC1403 is not set
# CONFIG_SENSORS_EMC2103 is not set
# CONFIG_SENSORS_EMC6W201 is not set
# CONFIG_SENSORS_SMSC47M1 is not set
CONFIG_SENSORS_SMSC47M192=y
# CONFIG_SENSORS_SMSC47B397 is not set
CONFIG_SENSORS_SCH56XX_COMMON=y
CONFIG_SENSORS_SCH5627=y
CONFIG_SENSORS_SCH5636=y
CONFIG_SENSORS_SMM665=y
CONFIG_SENSORS_ADC128D818=y
# CONFIG_SENSORS_ADS1015 is not set
CONFIG_SENSORS_ADS7828=y
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
# CONFIG_SENSORS_VT8231 is not set
CONFIG_SENSORS_W83781D=y
CONFIG_SENSORS_W83791D=y
# CONFIG_SENSORS_W83792D is not set
CONFIG_SENSORS_W83793=y
# CONFIG_SENSORS_W83795 is not set
# CONFIG_SENSORS_W83L785TS is not set
CONFIG_SENSORS_W83L786NG=y
CONFIG_SENSORS_W83627HF=y
# CONFIG_SENSORS_W83627EHF is not set
# CONFIG_SENSORS_WM831X is not set

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
CONFIG_THERMAL_GOV_USER_SPACE=y
# CONFIG_THERMAL_EMULATION is not set
# CONFIG_INTEL_POWERCLAMP is not set
CONFIG_X86_PKG_TEMP_THERMAL=y
# CONFIG_ACPI_INT3403_THERMAL is not set

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
CONFIG_DA9052_WATCHDOG=y
CONFIG_WM831X_WATCHDOG=y
CONFIG_DW_WATCHDOG=y
CONFIG_ACQUIRE_WDT=y
CONFIG_ADVANTECH_WDT=y
# CONFIG_ALIM1535_WDT is not set
# CONFIG_ALIM7101_WDT is not set
CONFIG_F71808E_WDT=y
# CONFIG_SP5100_TCO is not set
CONFIG_SC520_WDT=y
CONFIG_SBC_FITPC2_WATCHDOG=y
# CONFIG_EUROTECH_WDT is not set
CONFIG_IB700_WDT=y
# CONFIG_IBMASR is not set
# CONFIG_WAFER_WDT is not set
# CONFIG_I6300ESB_WDT is not set
# CONFIG_IE6XX_WDT is not set
# CONFIG_ITCO_WDT is not set
# CONFIG_IT8712F_WDT is not set
# CONFIG_IT87_WDT is not set
# CONFIG_HP_WATCHDOG is not set
CONFIG_KEMPLD_WDT=y
# CONFIG_SC1200_WDT is not set
# CONFIG_SCx200_WDT is not set
CONFIG_PC87413_WDT=y
# CONFIG_NV_TCO is not set
CONFIG_RDC321X_WDT=y
CONFIG_60XX_WDT=y
CONFIG_SBC8360_WDT=y
CONFIG_SBC7240_WDT=y
# CONFIG_CPU5_WDT is not set
CONFIG_SMSC_SCH311X_WDT=y
# CONFIG_SMSC37B787_WDT is not set
# CONFIG_VIA_WDT is not set
# CONFIG_W83627HF_WDT is not set
CONFIG_W83697HF_WDT=y
CONFIG_W83697UG_WDT=y
CONFIG_W83877F_WDT=y
# CONFIG_W83977F_WDT is not set
CONFIG_MACHZ_WDT=y
CONFIG_SBC_EPX_C3_WATCHDOG=y
CONFIG_MEN_A21_WDT=y

#
# ISA-based Watchdog Cards
#
# CONFIG_PCWATCHDOG is not set
CONFIG_MIXCOMWD=y
# CONFIG_WDT is not set

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
# CONFIG_SSB_B43_PCI_BRIDGE is not set
# CONFIG_SSB_SILENT is not set
# CONFIG_SSB_DEBUG is not set
CONFIG_SSB_DRIVER_PCICORE_POSSIBLE=y
# CONFIG_SSB_DRIVER_PCICORE is not set
CONFIG_SSB_DRIVER_GPIO=y
CONFIG_BCMA_POSSIBLE=y

#
# Broadcom specific AMBA
#
CONFIG_BCMA=y
CONFIG_BCMA_HOST_PCI_POSSIBLE=y
CONFIG_BCMA_HOST_PCI=y
# CONFIG_BCMA_HOST_SOC is not set
CONFIG_BCMA_DRIVER_GMAC_CMN=y
CONFIG_BCMA_DRIVER_GPIO=y
CONFIG_BCMA_DEBUG=y

#
# Multifunction device drivers
#
CONFIG_MFD_CORE=y
# CONFIG_MFD_CS5535 is not set
CONFIG_MFD_AS3711=y
CONFIG_PMIC_ADP5520=y
CONFIG_MFD_AAT2870_CORE=y
# CONFIG_MFD_CROS_EC is not set
CONFIG_PMIC_DA903X=y
CONFIG_PMIC_DA9052=y
CONFIG_MFD_DA9052_I2C=y
# CONFIG_MFD_DA9055 is not set
CONFIG_MFD_DA9063=y
# CONFIG_MFD_MC13XXX_I2C is not set
CONFIG_HTC_PASIC3=y
# CONFIG_HTC_I2CPLD is not set
# CONFIG_LPC_ICH is not set
# CONFIG_LPC_SCH is not set
# CONFIG_MFD_JANZ_CMODIO is not set
CONFIG_MFD_KEMPLD=y
CONFIG_MFD_88PM800=y
CONFIG_MFD_88PM805=y
# CONFIG_MFD_88PM860X is not set
CONFIG_MFD_MAX14577=y
# CONFIG_MFD_MAX77686 is not set
# CONFIG_MFD_MAX77693 is not set
CONFIG_MFD_MAX8907=y
CONFIG_MFD_MAX8925=y
CONFIG_MFD_MAX8997=y
# CONFIG_MFD_MAX8998 is not set
# CONFIG_MFD_RETU is not set
CONFIG_MFD_PCF50633=y
# CONFIG_PCF50633_ADC is not set
# CONFIG_PCF50633_GPIO is not set
# CONFIG_MFD_RDC321X is not set
# CONFIG_MFD_RTSX_PCI is not set
CONFIG_MFD_RC5T583=y
# CONFIG_MFD_SEC_CORE is not set
# CONFIG_MFD_SI476X_CORE is not set
CONFIG_MFD_SM501=y
# CONFIG_MFD_SM501_GPIO is not set
CONFIG_MFD_SMSC=y
# CONFIG_ABX500_CORE is not set
CONFIG_MFD_STMPE=y

#
# STMicroelectronics STMPE Interface Drivers
#
CONFIG_STMPE_I2C=y
# CONFIG_MFD_SYSCON is not set
CONFIG_MFD_TI_AM335X_TSCADC=y
CONFIG_MFD_LP3943=y
# CONFIG_MFD_LP8788 is not set
# CONFIG_MFD_PALMAS is not set
CONFIG_TPS6105X=y
# CONFIG_TPS65010 is not set
CONFIG_TPS6507X=y
CONFIG_MFD_TPS65090=y
CONFIG_MFD_TPS65217=y
CONFIG_MFD_TPS6586X=y
# CONFIG_MFD_TPS65910 is not set
# CONFIG_MFD_TPS65912 is not set
# CONFIG_MFD_TPS65912_I2C is not set
# CONFIG_MFD_TPS80031 is not set
# CONFIG_TWL4030_CORE is not set
CONFIG_TWL6040_CORE=y
CONFIG_MFD_WL1273_CORE=y
# CONFIG_MFD_LM3533 is not set
# CONFIG_MFD_TIMBERDALE is not set
# CONFIG_MFD_TC3589X is not set
# CONFIG_MFD_TMIO is not set
# CONFIG_MFD_VX855 is not set
CONFIG_MFD_ARIZONA=y
CONFIG_MFD_ARIZONA_I2C=y
CONFIG_MFD_WM5102=y
# CONFIG_MFD_WM5110 is not set
# CONFIG_MFD_WM8997 is not set
# CONFIG_MFD_WM8400 is not set
CONFIG_MFD_WM831X=y
CONFIG_MFD_WM831X_I2C=y
# CONFIG_MFD_WM8350_I2C is not set
CONFIG_MFD_WM8994=y
CONFIG_REGULATOR=y
# CONFIG_REGULATOR_DEBUG is not set
CONFIG_REGULATOR_FIXED_VOLTAGE=y
CONFIG_REGULATOR_VIRTUAL_CONSUMER=y
CONFIG_REGULATOR_USERSPACE_CONSUMER=y
CONFIG_REGULATOR_88PM800=y
CONFIG_REGULATOR_ACT8865=y
CONFIG_REGULATOR_AD5398=y
CONFIG_REGULATOR_AAT2870=y
CONFIG_REGULATOR_AS3711=y
# CONFIG_REGULATOR_DA903X is not set
# CONFIG_REGULATOR_DA9052 is not set
CONFIG_REGULATOR_DA9063=y
CONFIG_REGULATOR_DA9210=y
# CONFIG_REGULATOR_FAN53555 is not set
# CONFIG_REGULATOR_GPIO is not set
# CONFIG_REGULATOR_ISL6271A is not set
CONFIG_REGULATOR_LP3971=y
CONFIG_REGULATOR_LP3972=y
CONFIG_REGULATOR_LP872X=y
CONFIG_REGULATOR_LP8755=y
# CONFIG_REGULATOR_MAX14577 is not set
CONFIG_REGULATOR_MAX1586=y
# CONFIG_REGULATOR_MAX8649 is not set
# CONFIG_REGULATOR_MAX8660 is not set
CONFIG_REGULATOR_MAX8907=y
CONFIG_REGULATOR_MAX8925=y
# CONFIG_REGULATOR_MAX8952 is not set
CONFIG_REGULATOR_MAX8973=y
CONFIG_REGULATOR_MAX8997=y
CONFIG_REGULATOR_PCF50633=y
CONFIG_REGULATOR_PFUZE100=y
CONFIG_REGULATOR_RC5T583=y
CONFIG_REGULATOR_TPS51632=y
# CONFIG_REGULATOR_TPS6105X is not set
CONFIG_REGULATOR_TPS62360=y
CONFIG_REGULATOR_TPS65023=y
CONFIG_REGULATOR_TPS6507X=y
CONFIG_REGULATOR_TPS65090=y
# CONFIG_REGULATOR_TPS65217 is not set
# CONFIG_REGULATOR_TPS6586X is not set
CONFIG_REGULATOR_WM831X=y
CONFIG_REGULATOR_WM8994=y
# CONFIG_MEDIA_SUPPORT is not set

#
# Graphics support
#
# CONFIG_AGP is not set
CONFIG_VGA_ARB=y
CONFIG_VGA_ARB_MAX_GPUS=16
# CONFIG_VGA_SWITCHEROO is not set
CONFIG_DRM=y
# CONFIG_DRM_TDFX is not set
# CONFIG_DRM_R128 is not set
# CONFIG_DRM_RADEON is not set
# CONFIG_DRM_NOUVEAU is not set
# CONFIG_DRM_I915 is not set
# CONFIG_DRM_MGA is not set
# CONFIG_DRM_VIA is not set
# CONFIG_DRM_SAVAGE is not set
# CONFIG_DRM_VMWGFX is not set
# CONFIG_DRM_GMA500 is not set
# CONFIG_DRM_UDL is not set
# CONFIG_DRM_AST is not set
# CONFIG_DRM_MGAG200 is not set
# CONFIG_DRM_CIRRUS_QEMU is not set
# CONFIG_DRM_QXL is not set
# CONFIG_DRM_BOCHS is not set
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
CONFIG_FB_SYS_FILLRECT=y
CONFIG_FB_SYS_COPYAREA=y
CONFIG_FB_SYS_IMAGEBLIT=y
# CONFIG_FB_FOREIGN_ENDIAN is not set
CONFIG_FB_SYS_FOPS=y
CONFIG_FB_DEFERRED_IO=y
CONFIG_FB_HECUBA=y
# CONFIG_FB_SVGALIB is not set
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
# CONFIG_FB_IMSTT is not set
# CONFIG_FB_VGA16 is not set
CONFIG_FB_UVESA=y
# CONFIG_FB_VESA is not set
CONFIG_FB_N411=y
CONFIG_FB_HGA=y
# CONFIG_FB_OPENCORES is not set
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
CONFIG_FB_TMIO=y
CONFIG_FB_TMIO_ACCELL=y
# CONFIG_FB_SM501 is not set
CONFIG_FB_GOLDFISH=y
CONFIG_FB_VIRTUAL=y
CONFIG_FB_METRONOME=y
# CONFIG_FB_MB862XX is not set
CONFIG_FB_BROADSHEET=y
CONFIG_FB_AUO_K190X=y
CONFIG_FB_AUO_K1900=y
CONFIG_FB_AUO_K1901=y
CONFIG_FB_SIMPLE=y
# CONFIG_EXYNOS_VIDEO is not set
CONFIG_BACKLIGHT_LCD_SUPPORT=y
CONFIG_LCD_CLASS_DEVICE=y
# CONFIG_LCD_PLATFORM is not set
CONFIG_BACKLIGHT_CLASS_DEVICE=y
# CONFIG_BACKLIGHT_GENERIC is not set
CONFIG_BACKLIGHT_PWM=y
# CONFIG_BACKLIGHT_DA903X is not set
# CONFIG_BACKLIGHT_DA9052 is not set
# CONFIG_BACKLIGHT_MAX8925 is not set
# CONFIG_BACKLIGHT_APPLE is not set
CONFIG_BACKLIGHT_SAHARA=y
CONFIG_BACKLIGHT_WM831X=y
CONFIG_BACKLIGHT_ADP5520=y
# CONFIG_BACKLIGHT_ADP8860 is not set
# CONFIG_BACKLIGHT_ADP8870 is not set
# CONFIG_BACKLIGHT_PCF50633 is not set
# CONFIG_BACKLIGHT_AAT2870 is not set
# CONFIG_BACKLIGHT_LM3630A is not set
# CONFIG_BACKLIGHT_LM3639 is not set
# CONFIG_BACKLIGHT_LP855X is not set
# CONFIG_BACKLIGHT_TPS65217 is not set
CONFIG_BACKLIGHT_AS3711=y
CONFIG_BACKLIGHT_GPIO=y
CONFIG_BACKLIGHT_LV5207LP=y
# CONFIG_BACKLIGHT_BD6107 is not set
CONFIG_LOGO=y
# CONFIG_LOGO_LINUX_MONO is not set
# CONFIG_LOGO_LINUX_VGA16 is not set
# CONFIG_LOGO_LINUX_CLUT224 is not set
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
# CONFIG_HID_AUREAL is not set
# CONFIG_HID_BELKIN is not set
# CONFIG_HID_CHERRY is not set
# CONFIG_HID_CHICONY is not set
# CONFIG_HID_CYPRESS is not set
# CONFIG_HID_DRAGONRISE is not set
# CONFIG_HID_EMS_FF is not set
# CONFIG_HID_ELECOM is not set
# CONFIG_HID_EZKEY is not set
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
# CONFIG_HID_ORTEK is not set
# CONFIG_HID_PANTHERLORD is not set
# CONFIG_HID_PETALYNX is not set
# CONFIG_HID_PICOLCD is not set
# CONFIG_HID_PRIMAX is not set
# CONFIG_HID_SAITEK is not set
# CONFIG_HID_SAMSUNG is not set
# CONFIG_HID_SPEEDLINK is not set
# CONFIG_HID_STEELSERIES is not set
# CONFIG_HID_SUNPLUS is not set
# CONFIG_HID_GREENASIA is not set
# CONFIG_HID_SMARTJOYPLUS is not set
# CONFIG_HID_TIVO is not set
# CONFIG_HID_TOPSEED is not set
# CONFIG_HID_THRUSTMASTER is not set
# CONFIG_HID_XINMO is not set
# CONFIG_HID_ZEROPLUS is not set
# CONFIG_HID_ZYDACRON is not set
# CONFIG_HID_SENSOR_HUB is not set

#
# I2C HID support
#
# CONFIG_I2C_HID is not set
CONFIG_USB_OHCI_LITTLE_ENDIAN=y
CONFIG_USB_SUPPORT=y
CONFIG_USB_ARCH_HAS_HCD=y
# CONFIG_USB is not set

#
# USB port drivers
#

#
# USB Physical Layer drivers
#
# CONFIG_USB_PHY is not set
# CONFIG_NOP_USB_XCEIV is not set
# CONFIG_SAMSUNG_USB2PHY is not set
# CONFIG_SAMSUNG_USB3PHY is not set
# CONFIG_USB_GPIO_VBUS is not set
# CONFIG_USB_GADGET is not set
# CONFIG_UWB is not set
# CONFIG_MMC is not set
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
# CONFIG_MEMSTICK_JMICRON_38X is not set
# CONFIG_MEMSTICK_R592 is not set
# CONFIG_NEW_LEDS is not set
# CONFIG_ACCESSIBILITY is not set
# CONFIG_INFINIBAND is not set
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
# CONFIG_INTEL_IOATDMA is not set
CONFIG_DW_DMAC_CORE=y
CONFIG_DW_DMAC=y
# CONFIG_DW_DMAC_PCI is not set
# CONFIG_TIMB_DMA is not set
# CONFIG_PCH_DMA is not set
CONFIG_DMA_ENGINE=y
CONFIG_DMA_ACPI=y

#
# DMA Clients
#
CONFIG_ASYNC_TX_DMA=y
CONFIG_DMATEST=y
CONFIG_AUXDISPLAY=y
CONFIG_KS0108=y
CONFIG_KS0108_PORT=0x378
CONFIG_KS0108_DELAY=2
CONFIG_CFAG12864B=y
CONFIG_CFAG12864B_RATE=20
CONFIG_UIO=y
# CONFIG_UIO_CIF is not set
CONFIG_UIO_PDRV_GENIRQ=y
CONFIG_UIO_DMEM_GENIRQ=y
# CONFIG_UIO_AEC is not set
# CONFIG_UIO_SERCOS3 is not set
# CONFIG_UIO_PCI_GENERIC is not set
# CONFIG_UIO_NETX is not set
# CONFIG_UIO_MF624 is not set
CONFIG_VIRT_DRIVERS=y
CONFIG_VIRTIO=y

#
# Virtio drivers
#
# CONFIG_VIRTIO_PCI is not set
# CONFIG_VIRTIO_BALLOON is not set
CONFIG_VIRTIO_MMIO=y
# CONFIG_VIRTIO_MMIO_CMDLINE_DEVICES is not set

#
# Microsoft Hyper-V guest support
#
# CONFIG_HYPERV is not set
CONFIG_STAGING=y
# CONFIG_SLICOSS is not set
# CONFIG_ECHO is not set
CONFIG_PANEL=y
CONFIG_PANEL_PARPORT=0
CONFIG_PANEL_PROFILE=5
# CONFIG_PANEL_CHANGE_MESSAGE is not set
# CONFIG_DX_SEP is not set

#
# IIO staging drivers
#

#
# Accelerometers
#

#
# Analog to digital converters
#
CONFIG_AD7291=y
CONFIG_AD7606=y
CONFIG_AD7606_IFACE_PARALLEL=y
CONFIG_AD799X=y
CONFIG_AD799X_RING_BUFFER=y

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

#
# Digital gyroscope sensors
#

#
# Network Analyzer, Impedance Converters
#
CONFIG_AD5933=y

#
# Light sensors
#
CONFIG_SENSORS_ISL29018=y
CONFIG_SENSORS_ISL29028=y
CONFIG_TSL2583=y
CONFIG_TSL2x7x=y

#
# Magnetometer sensors
#
# CONFIG_SENSORS_HMC5843 is not set

#
# Active energy metering IC
#
CONFIG_ADE7854=y
CONFIG_ADE7854_I2C=y

#
# Resolver to digital converters
#

#
# Triggers - standalone
#
CONFIG_IIO_SIMPLE_DUMMY=y
# CONFIG_IIO_SIMPLE_DUMMY_EVENTS is not set
# CONFIG_IIO_SIMPLE_DUMMY_BUFFER is not set
# CONFIG_FB_SM7XX is not set
# CONFIG_CRYSTALHD is not set
# CONFIG_FB_XGI is not set
# CONFIG_ACPI_QUICKSTART is not set
CONFIG_FT1000=y

#
# Speakup console speech
#
# CONFIG_TOUCHSCREEN_CLEARPAD_TM1217 is not set
# CONFIG_TOUCHSCREEN_SYNAPTICS_I2C_RMI4 is not set
# CONFIG_STAGING_MEDIA is not set

#
# Android
#
# CONFIG_ANDROID is not set
# CONFIG_DGRP is not set
CONFIG_GOLDFISH_AUDIO=y
# CONFIG_XILLYBUS is not set
# CONFIG_DGNC is not set
# CONFIG_DGAP is not set
CONFIG_GS_FPGABOOT=y
# CONFIG_X86_PLATFORM_DEVICES is not set
# CONFIG_GOLDFISH_PIPE is not set
# CONFIG_CHROME_PLATFORMS is not set

#
# Hardware Spinlock drivers
#
CONFIG_CLKSRC_I8253=y
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
CONFIG_PM_DEVFREQ=y

#
# DEVFREQ Governors
#
CONFIG_DEVFREQ_GOV_SIMPLE_ONDEMAND=y
CONFIG_DEVFREQ_GOV_PERFORMANCE=y
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
CONFIG_EXTCON_MAX14577=y
CONFIG_EXTCON_MAX8997=y
CONFIG_MEMORY=y
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

#
# Amplifiers
#

#
# Hid Sensor IIO Common
#
CONFIG_IIO_ST_SENSORS_I2C=y
CONFIG_IIO_ST_SENSORS_CORE=y

#
# Digital to analog converters
#
CONFIG_AD5064=y
CONFIG_AD5380=y
# CONFIG_AD5446 is not set
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
# CONFIG_IIO_ST_GYRO_3AXIS is not set
CONFIG_ITG3200=y

#
# Humidity sensors
#
# CONFIG_DHT11 is not set
CONFIG_SI7005=y

#
# Inertial measurement units
#
# CONFIG_INV_MPU6050_IIO is not set

#
# Light sensors
#
CONFIG_ADJD_S311=y
# CONFIG_APDS9300 is not set
# CONFIG_CM32181 is not set
CONFIG_CM36651=y
CONFIG_GP2AP020A00F=y
# CONFIG_LTR501 is not set
# CONFIG_TCS3472 is not set
CONFIG_SENSORS_TSL2563=y
# CONFIG_TSL4531 is not set
CONFIG_VCNL4000=y

#
# Magnetometer sensors
#
# CONFIG_AK8975 is not set
CONFIG_MAG3110=y
CONFIG_IIO_ST_MAGN_3AXIS=y
CONFIG_IIO_ST_MAGN_I2C_3AXIS=y

#
# Inclinometer sensors
#

#
# Triggers - standalone
#
CONFIG_IIO_INTERRUPT_TRIGGER=y
CONFIG_IIO_SYSFS_TRIGGER=y

#
# Pressure sensors
#
CONFIG_MPL3115=y
CONFIG_IIO_ST_PRESS=y
CONFIG_IIO_ST_PRESS_I2C=y

#
# Temperature sensors
#
CONFIG_TMP006=y
# CONFIG_NTB is not set
# CONFIG_VME_BUS is not set
CONFIG_PWM=y
CONFIG_PWM_SYSFS=y
# CONFIG_PWM_LP3943 is not set
CONFIG_IPACK_BUS=y
# CONFIG_BOARD_TPCI200 is not set
# CONFIG_SERIAL_IPOCTAL is not set
# CONFIG_RESET_CONTROLLER is not set
# CONFIG_FMC is not set

#
# PHY Subsystem
#
# CONFIG_GENERIC_PHY is not set
CONFIG_PHY_EXYNOS_MIPI_VIDEO=y
CONFIG_POWERCAP=y
# CONFIG_INTEL_RAPL is not set

#
# Firmware Drivers
#
CONFIG_EDD=y
# CONFIG_EDD_OFF is not set
# CONFIG_FIRMWARE_MEMMAP is not set
CONFIG_DELL_RBU=y
# CONFIG_DCDBAS is not set
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
CONFIG_FSNOTIFY=y
CONFIG_DNOTIFY=y
CONFIG_INOTIFY_USER=y
CONFIG_FANOTIFY=y
# CONFIG_QUOTA is not set
# CONFIG_QUOTACTL is not set
CONFIG_AUTOFS4_FS=y
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
CONFIG_KERNFS=y
CONFIG_SYSFS=y
# CONFIG_HUGETLBFS is not set
# CONFIG_HUGETLB_PAGE is not set
CONFIG_CONFIGFS_FS=y
CONFIG_MISC_FILESYSTEMS=y
# CONFIG_ECRYPT_FS is not set
# CONFIG_PSTORE is not set
CONFIG_NETWORK_FILESYSTEMS=y
CONFIG_NFS_FS=y
# CONFIG_NFS_V2 is not set
# CONFIG_NFS_V3 is not set
CONFIG_NFS_V4=y
CONFIG_NFS_SWAP=y
CONFIG_NFS_V4_1=y
CONFIG_NFS_V4_2=y
CONFIG_PNFS_FILE_LAYOUT=y
CONFIG_NFS_V4_1_IMPLEMENTATION_ID_DOMAIN="kernel.org"
# CONFIG_NFS_V4_1_MIGRATION is not set
# CONFIG_ROOT_NFS is not set
# CONFIG_NFS_USE_LEGACY_DNS is not set
CONFIG_NFS_USE_KERNEL_DNS=y
CONFIG_NFSD=y
# CONFIG_NFSD_V3 is not set
CONFIG_LOCKD=y
CONFIG_NFS_COMMON=y
CONFIG_SUNRPC=y
CONFIG_SUNRPC_GSS=y
CONFIG_SUNRPC_BACKCHANNEL=y
CONFIG_SUNRPC_SWAP=y
CONFIG_RPCSEC_GSS_KRB5=y
# CONFIG_CEPH_FS is not set
CONFIG_CIFS=y
CONFIG_CIFS_STATS=y
CONFIG_CIFS_STATS2=y
# CONFIG_CIFS_WEAK_PW_HASH is not set
# CONFIG_CIFS_UPCALL is not set
CONFIG_CIFS_XATTR=y
# CONFIG_CIFS_POSIX is not set
CONFIG_CIFS_ACL=y
# CONFIG_CIFS_DEBUG is not set
# CONFIG_CIFS_DFS_UPCALL is not set
# CONFIG_CIFS_SMB2 is not set
CONFIG_NCP_FS=y
# CONFIG_NCPFS_PACKET_SIGNING is not set
# CONFIG_NCPFS_IOCTL_LOCKING is not set
CONFIG_NCPFS_STRONG=y
CONFIG_NCPFS_NFS_NS=y
CONFIG_NCPFS_OS2_NS=y
# CONFIG_NCPFS_SMALLDOS is not set
# CONFIG_NCPFS_NLS is not set
# CONFIG_NCPFS_EXTRAS is not set
# CONFIG_CODA_FS is not set
CONFIG_AFS_FS=y
# CONFIG_AFS_DEBUG is not set
CONFIG_9P_FS=y
# CONFIG_9P_FS_POSIX_ACL is not set
# CONFIG_9P_FS_SECURITY is not set
CONFIG_NLS=y
CONFIG_NLS_DEFAULT="iso8859-1"
CONFIG_NLS_CODEPAGE_437=y
CONFIG_NLS_CODEPAGE_737=y
# CONFIG_NLS_CODEPAGE_775 is not set
CONFIG_NLS_CODEPAGE_850=y
CONFIG_NLS_CODEPAGE_852=y
# CONFIG_NLS_CODEPAGE_855 is not set
CONFIG_NLS_CODEPAGE_857=y
CONFIG_NLS_CODEPAGE_860=y
# CONFIG_NLS_CODEPAGE_861 is not set
CONFIG_NLS_CODEPAGE_862=y
CONFIG_NLS_CODEPAGE_863=y
CONFIG_NLS_CODEPAGE_864=y
# CONFIG_NLS_CODEPAGE_865 is not set
# CONFIG_NLS_CODEPAGE_866 is not set
CONFIG_NLS_CODEPAGE_869=y
# CONFIG_NLS_CODEPAGE_936 is not set
CONFIG_NLS_CODEPAGE_950=y
CONFIG_NLS_CODEPAGE_932=y
CONFIG_NLS_CODEPAGE_949=y
CONFIG_NLS_CODEPAGE_874=y
CONFIG_NLS_ISO8859_8=y
# CONFIG_NLS_CODEPAGE_1250 is not set
CONFIG_NLS_CODEPAGE_1251=y
CONFIG_NLS_ASCII=y
# CONFIG_NLS_ISO8859_1 is not set
# CONFIG_NLS_ISO8859_2 is not set
# CONFIG_NLS_ISO8859_3 is not set
CONFIG_NLS_ISO8859_4=y
# CONFIG_NLS_ISO8859_5 is not set
# CONFIG_NLS_ISO8859_6 is not set
CONFIG_NLS_ISO8859_7=y
CONFIG_NLS_ISO8859_9=y
CONFIG_NLS_ISO8859_13=y
CONFIG_NLS_ISO8859_14=y
CONFIG_NLS_ISO8859_15=y
CONFIG_NLS_KOI8_R=y
# CONFIG_NLS_KOI8_U is not set
# CONFIG_NLS_MAC_ROMAN is not set
# CONFIG_NLS_MAC_CELTIC is not set
CONFIG_NLS_MAC_CENTEURO=y
CONFIG_NLS_MAC_CROATIAN=y
CONFIG_NLS_MAC_CYRILLIC=y
# CONFIG_NLS_MAC_GAELIC is not set
CONFIG_NLS_MAC_GREEK=y
CONFIG_NLS_MAC_ICELAND=y
CONFIG_NLS_MAC_INUIT=y
CONFIG_NLS_MAC_ROMANIAN=y
# CONFIG_NLS_MAC_TURKISH is not set
# CONFIG_NLS_UTF8 is not set
# CONFIG_DLM is not set

#
# Kernel hacking
#
CONFIG_TRACE_IRQFLAGS_SUPPORT=y

#
# printk and dmesg options
#
CONFIG_PRINTK_TIME=y
CONFIG_DEFAULT_MESSAGE_LOGLEVEL=4
CONFIG_BOOT_PRINTK_DELAY=y
# CONFIG_DYNAMIC_DEBUG is not set

#
# Compile-time checks and compiler options
#
# CONFIG_DEBUG_INFO is not set
CONFIG_ENABLE_WARN_DEPRECATED=y
CONFIG_ENABLE_MUST_CHECK=y
CONFIG_FRAME_WARN=1024
# CONFIG_STRIP_ASM_SYMS is not set
# CONFIG_READABLE_ASM is not set
# CONFIG_UNUSED_SYMBOLS is not set
CONFIG_DEBUG_FS=y
# CONFIG_HEADERS_CHECK is not set
# CONFIG_DEBUG_SECTION_MISMATCH is not set
CONFIG_ARCH_WANT_FRAME_POINTERS=y
CONFIG_FRAME_POINTER=y
# CONFIG_DEBUG_FORCE_WEAK_PER_CPU is not set
# CONFIG_MAGIC_SYSRQ is not set
CONFIG_DEBUG_KERNEL=y

#
# Memory Debugging
#
CONFIG_DEBUG_PAGEALLOC=y
CONFIG_WANT_PAGE_DEBUG_FLAGS=y
CONFIG_PAGE_GUARD=y
# CONFIG_DEBUG_OBJECTS is not set
CONFIG_HAVE_DEBUG_KMEMLEAK=y
# CONFIG_DEBUG_KMEMLEAK is not set
# CONFIG_DEBUG_STACK_USAGE is not set
# CONFIG_DEBUG_VM is not set
CONFIG_DEBUG_VIRTUAL=y
CONFIG_DEBUG_MEMORY_INIT=y
CONFIG_MEMORY_NOTIFIER_ERROR_INJECT=y
CONFIG_DEBUG_PER_CPU_MAPS=y
# CONFIG_DEBUG_HIGHMEM is not set
CONFIG_HAVE_DEBUG_STACKOVERFLOW=y
CONFIG_DEBUG_STACKOVERFLOW=y
CONFIG_HAVE_ARCH_KMEMCHECK=y
CONFIG_DEBUG_SHIRQ=y

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
CONFIG_PANIC_TIMEOUT=0

#
# Lock Debugging (spinlocks, mutexes, etc...)
#
# CONFIG_DEBUG_RT_MUTEXES is not set
# CONFIG_RT_MUTEX_TESTER is not set
CONFIG_DEBUG_SPINLOCK=y
CONFIG_DEBUG_MUTEXES=y
CONFIG_DEBUG_WW_MUTEX_SLOWPATH=y
CONFIG_DEBUG_LOCK_ALLOC=y
# CONFIG_PROVE_LOCKING is not set
CONFIG_LOCKDEP=y
CONFIG_LOCK_STAT=y
CONFIG_DEBUG_LOCKDEP=y
CONFIG_DEBUG_ATOMIC_SLEEP=y
# CONFIG_DEBUG_LOCKING_API_SELFTESTS is not set
CONFIG_LOCK_TORTURE_TEST=y
CONFIG_STACKTRACE=y
# CONFIG_DEBUG_KOBJECT is not set
CONFIG_DEBUG_BUGVERBOSE=y
# CONFIG_DEBUG_WRITECOUNT is not set
# CONFIG_DEBUG_LIST is not set
CONFIG_DEBUG_SG=y
CONFIG_DEBUG_NOTIFIERS=y
CONFIG_DEBUG_CREDENTIALS=y

#
# RCU Debugging
#
CONFIG_SPARSE_RCU_POINTER=y
CONFIG_TORTURE_TEST=y
# CONFIG_RCU_TORTURE_TEST is not set
CONFIG_RCU_CPU_STALL_TIMEOUT=21
# CONFIG_RCU_CPU_STALL_INFO is not set
CONFIG_RCU_TRACE=y
CONFIG_NOTIFIER_ERROR_INJECTION=y
# CONFIG_CPU_NOTIFIER_ERROR_INJECT is not set
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
CONFIG_TRACE_CLOCK=y
CONFIG_TRACING_SUPPORT=y
# CONFIG_FTRACE is not set

#
# Runtime Testing
#
# CONFIG_TEST_LIST_SORT is not set
# CONFIG_BACKTRACE_SELF_TEST is not set
# CONFIG_RBTREE_TEST is not set
# CONFIG_ATOMIC64_SELFTEST is not set
CONFIG_TEST_STRING_HELPERS=y
CONFIG_TEST_KSTRTOX=y
# CONFIG_PROVIDE_OHCI1394_DMA_INIT is not set
CONFIG_DMA_API_DEBUG=y
# CONFIG_SAMPLES is not set
CONFIG_HAVE_ARCH_KGDB=y
# CONFIG_KGDB is not set
# CONFIG_STRICT_DEVMEM is not set
CONFIG_X86_VERBOSE_BOOTUP=y
# CONFIG_EARLY_PRINTK is not set
CONFIG_X86_PTDUMP=y
CONFIG_DEBUG_RODATA=y
CONFIG_DEBUG_RODATA_TEST=y
# CONFIG_DOUBLEFAULT is not set
CONFIG_DEBUG_TLBFLUSH=y
# CONFIG_IOMMU_STRESS is not set
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
# CONFIG_DEBUG_BOOT_PARAMS is not set
# CONFIG_CPA_DEBUG is not set
CONFIG_OPTIMIZE_INLINING=y
CONFIG_DEBUG_NMI_SELFTEST=y
# CONFIG_X86_DEBUG_STATIC_CPU_HAS is not set

#
# Security options
#
CONFIG_KEYS=y
# CONFIG_PERSISTENT_KEYRINGS is not set
CONFIG_TRUSTED_KEYS=y
# CONFIG_ENCRYPTED_KEYS is not set
CONFIG_KEYS_DEBUG_PROC_KEYS=y
CONFIG_SECURITY_DMESG_RESTRICT=y
# CONFIG_SECURITY is not set
CONFIG_SECURITYFS=y
CONFIG_DEFAULT_SECURITY_DAC=y
CONFIG_DEFAULT_SECURITY=""
CONFIG_CRYPTO=y

#
# Crypto core or helper
#
CONFIG_CRYPTO_FIPS=y
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
CONFIG_CRYPTO_AUTHENC=y
CONFIG_CRYPTO_ABLK_HELPER=y
CONFIG_CRYPTO_GLUE_HELPER_X86=y

#
# Authenticated Encryption with Associated Data
#
CONFIG_CRYPTO_CCM=y
# CONFIG_CRYPTO_GCM is not set
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
# CONFIG_CRYPTO_CRCT10DIF is not set
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
CONFIG_CRYPTO_AES_586=y
CONFIG_CRYPTO_AES_NI_INTEL=y
CONFIG_CRYPTO_ANUBIS=y
CONFIG_CRYPTO_ARC4=y
CONFIG_CRYPTO_BLOWFISH=y
CONFIG_CRYPTO_BLOWFISH_COMMON=y
CONFIG_CRYPTO_CAMELLIA=y
CONFIG_CRYPTO_CAST_COMMON=y
CONFIG_CRYPTO_CAST5=y
CONFIG_CRYPTO_CAST6=y
CONFIG_CRYPTO_DES=y
CONFIG_CRYPTO_FCRYPT=y
CONFIG_CRYPTO_KHAZAD=y
CONFIG_CRYPTO_SALSA20=y
CONFIG_CRYPTO_SALSA20_586=y
# CONFIG_CRYPTO_SEED is not set
CONFIG_CRYPTO_SERPENT=y
CONFIG_CRYPTO_SERPENT_SSE2_586=y
CONFIG_CRYPTO_TEA=y
CONFIG_CRYPTO_TWOFISH=y
CONFIG_CRYPTO_TWOFISH_COMMON=y
CONFIG_CRYPTO_TWOFISH_586=y

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
# CONFIG_CRYPTO_USER_API_SKCIPHER is not set
CONFIG_CRYPTO_HASH_INFO=y
# CONFIG_CRYPTO_HW is not set
CONFIG_ASYMMETRIC_KEY_TYPE=y
CONFIG_ASYMMETRIC_PUBLIC_KEY_SUBTYPE=y
CONFIG_PUBLIC_KEY_ALGO_RSA=y
CONFIG_X509_CERTIFICATE_PARSER=y
CONFIG_HAVE_KVM=y
CONFIG_VIRTUALIZATION=y
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
CONFIG_CRC32_SLICEBY4=y
# CONFIG_CRC32_SARWATE is not set
# CONFIG_CRC32_BIT is not set
CONFIG_CRC7=y
CONFIG_LIBCRC32C=y
CONFIG_CRC8=y
CONFIG_CRC64_ECMA=y
# CONFIG_RANDOM32_SELFTEST is not set
CONFIG_ZLIB_INFLATE=y
CONFIG_ZLIB_DEFLATE=y
CONFIG_LZO_COMPRESS=y
CONFIG_LZO_DECOMPRESS=y
CONFIG_LZ4_COMPRESS=y
CONFIG_LZ4_DECOMPRESS=y
# CONFIG_XZ_DEC is not set
# CONFIG_XZ_DEC_BCJ is not set
CONFIG_DECOMPRESS_GZIP=y
CONFIG_GENERIC_ALLOCATOR=y
CONFIG_ASSOCIATIVE_ARRAY=y
CONFIG_HAS_IOMEM=y
CONFIG_HAS_IOPORT=y
CONFIG_HAS_DMA=y
CONFIG_CPUMASK_OFFSTACK=y
CONFIG_CPU_RMAP=y
CONFIG_DQL=y
CONFIG_NLATTR=y
CONFIG_ARCH_HAS_ATOMIC64_DEC_IF_POSITIVE=y
CONFIG_AVERAGE=y
CONFIG_CLZ_TAB=y
# CONFIG_CORDIC is not set
# CONFIG_DDR is not set
CONFIG_MPILIB=y
CONFIG_OID_REGISTRY=y

--ikeVEW9yuYc//A+q
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

_______________________________________________
LKP mailing list
LKP@linux.intel.com

--ikeVEW9yuYc//A+q--
