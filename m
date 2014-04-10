Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965021AbaDJGyT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Apr 2014 02:54:19 -0400
Received: from mga09.intel.com ([134.134.136.24]:39953 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933461AbaDJGyH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Apr 2014 02:54:07 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,832,1389772800"; 
   d="log'?scan'208";a="518289586"
Date: Thu, 10 Apr 2014 14:53:30 +0800
From: Fengguang Wu <fengguang.wu@intel.com>
To: Boaz Harrosh <bharrosh@panasas.com>
Cc: linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        Jet Chen <jet.chen@intel.com>
Subject: [uml/do_xor_speed] WARNING: CPU: 0 PID: 1 at init/main.c:708
 do_one_initcall()
Message-ID: <20140410065330.GB2132@localhost>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="a8Wt8u1KmwUX3Y2C"
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--a8Wt8u1KmwUX3Y2C
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi Boaz,

I catch the below warning again in

git://git.open-osd.org/linux-open-osd.git raid6

commit 60e833d86a01ad9d8204a04b8db324106ab50395
Author:     Boaz Harrosh <bharrosh@panasas.com>
AuthorDate: Thu Jul 19 15:22:37 2012 +0300
Commit:     Boaz Harrosh <bharrosh@panasas.com>
CommitDate: Tue Apr 8 08:42:14 2014 +0300

    RFC: do_xor_speed Broken on UML do to jiffies
    
    Remember that hang I reported a while back on UML. Well
    I'm at it again, and it still hangs and I found why.
    
    I have dprinted jiffies and it never advances during the
    loop at do_xor_speed. There for it is stuck in an endless
    loop. I have also dprinted current_kernel_time() and it
    returns the same constant value as well.
    
    Note that it does usually work on UML, only during
    the modprobe of xor.ko while that test is running. It looks
    like some lucking is preventing the clock from ticking.
    
    However ktime_get_ts does work for me so I changed the code
    as below, so I can work. See how I put several safety
    guards, to never get hangs again.
    And I think my time based approach is more accurate then
    previous system.
    
    UML guys please investigate the jiffies issue? what is
    xor.ko not doing right?
    
    Signed-off-by: Boaz Harrosh <bharrosh@panasas.com>

+------------------------------------------------------------------+------------+------------+
|                                                                  | 60e833d86a | 158b685625 |
+------------------------------------------------------------------+------------+------------+
| boot_successes                                                   | 0          | 0          |
| boot_failures                                                    | 22         | 13         |
| WARNING:CPU:PID:at_init/main.c:do_one_initcall()                 | 22         | 12         |
| initcall_calibrate_xor_blocks_returned_with_preemption_imbalance | 22         | 12         |
| backtrace:warn_slowpath_fmt                                      | 22         | 12         |
| backtrace:kernel_init_freeable                                   | 22         | 12         |
| INFO:possible_irq_lock_inversion_dependency_detected             | 0          | 12         |
| backtrace:page_writeback_init                                    | 0          | 12         |
| backtrace:smp_init                                               | 0          | 12         |
| backtrace:kvm_guest_init                                         | 0          | 12         |
| backtrace:kvmclock_init                                          | 0          | 12         |
| BUG:kernel_early_hang_without_any_printk_output                  | 0          | 1          |
+------------------------------------------------------------------+------------+------------+

[    0.381056] xor: using function: pIII_sse (0.192 MB/sec)
[    0.382268] ------------[ cut here ]------------
[    0.382268] ------------[ cut here ]------------
[    0.383315] WARNING: CPU: 0 PID: 1 at init/main.c:708 do_one_initcall+0x11d/0x136()

git bisect start 158b6856256ef0171c2c7db83832b249861e9d3b 455c6fdbd219161bd09b1165f11699d6d73de11c --
git bisect good 646a0bcc54fefa29c32fc03bebde6ff613a3047b  # 00:26     22+      0  Merge 'drm-exynos/exynos-drm-next-todo' into devel-f4-i386-201404081359
git bisect good 65c4c808e7aa0d49fac20baeebbb1869ee5dfe14  # 00:34     22+     22  Merge 'vireshk/isolate-cpusets' into devel-f4-i386-201404081359
git bisect  bad 78fb990bc3dd5c7a71b01c87e9e94d218720bfac  # 00:59      0-      8  Merge 'open-osd/raid6' into devel-f4-i386-201404081359
git bisect good 523fd2062839e80b615d5382bc9c44736cc24c8c  # 01:20     22+      0  ore: (trivial) reformat some code
git bisect good a7b6083b7dfa79c3109e200317fe190d7b61d1eb  # 01:30     22+      0  ore: Support for raid 6
git bisect  bad edffc9c132ffb305179d016fc68d8e947bad83f4  # 01:41      0-     20  SQUASHME: ore: 2 raid6 bugs
git bisect  bad 60e833d86a01ad9d8204a04b8db324106ab50395  # 01:49      0-     20  RFC: do_xor_speed Broken on UML do to jiffies
# first bad commit: [60e833d86a01ad9d8204a04b8db324106ab50395] RFC: do_xor_speed Broken on UML do to jiffies
git bisect good a7b6083b7dfa79c3109e200317fe190d7b61d1eb  # 01:54     66+      0  ore: Support for raid 6
git bisect  bad 158b6856256ef0171c2c7db83832b249861e9d3b  # 01:54      0-     13  0day head guard for 'devel-f4-i386-201404081359'
git bisect good 39de65aa2c3eee901db020a4f1396998e09602a3  # 01:59     66+      0  Merge branch 'i2c/for-next' of git://git.kernel.org/pub/scm/linux/kernel/git/wsa/linux
git bisect good 35e2933ca69ef1b8061e5aee090535410336e063  # 02:05     66+      0  Add linux-next specific files for 20140409


This script may reproduce the error.

-----------------------------------------------------------------------------
#!/bin/bash

kernel=$1
initrd=quantal-core-i386.cgz

wget --no-clobber https://github.com/fengguang/reproduce-kernel-bug/blob/master/initrd/$initrd

kvm=(
	qemu-system-x86_64 -cpu kvm64 -enable-kvm 
	-kernel $kernel
	-initrd $initrd
	-smp 2
	-m 256M
	-net nic,vlan=0,macaddr=00:00:00:00:00:00,model=virtio
	-net user,vlan=0
	-net nic,vlan=1,model=e1000
	-net user,vlan=1
	-boot order=nc
	-no-reboot
	-watchdog i6300esb
	-serial stdio
	-display none
	-monitor null
)

append=(
	debug
	sched_debug
	apic=debug
	ignore_loglevel
	sysrq_always_enabled
	panic=10
	prompt_ramdisk=0
	earlyprintk=ttyS0,115200
	console=ttyS0,115200
	console=tty0
	vga=normal
	root=/dev/ram0
	rw
)

"${kvm[@]}" --append "${append[*]}"
-----------------------------------------------------------------------------

Thanks,
Fengguang

--a8Wt8u1KmwUX3Y2C
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="dmesg-quantal-lkp-ib03-65:20140410014919:i386-randconfig-fd1-0408:3.14.0-rc8-00007-g60e833d:2"
Content-Transfer-Encoding: quoted-printable

early console in setup code
early console in decompress_kernel

Decompressing Linux... Parsing ELF... No relocation needed... done.
Booting the kernel.
[    0.000000] Initializing cgroup subsys cpuset
[    0.000000] Initializing cgroup subsys cpu
[    0.000000] Linux version 3.14.0-rc8-00007-g60e833d (kbuild@inn) (gcc ve=
rsion 4.8.2 (Debian 4.8.2-18) ) #2 SMP PREEMPT Thu Apr 10 01:46:54 CST 2014
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
[    0.000000] Notice: NX (Execute Disable) protection cannot be enabled: n=
on-PAE kernel!
[    0.000000] Hypervisor detected: KVM
[    0.000000] e820: update [mem 0x00000000-0x00000fff] usable =3D=3D> rese=
rved
[    0.000000] e820: remove [mem 0x000a0000-0x000fffff] usable
[    0.000000] e820: last_pfn =3D 0x13ffe max_arch_pfn =3D 0x100000
[    0.000000] Scanning 1 areas for low memory corruption
[    0.000000] initial memory mapped: [mem 0x00000000-0x02ffffff]
[    0.000000] Base memory trampoline at [8009b000] 9b000 size 16384
[    0.000000] init_memory_mapping: [mem 0x00000000-0x000fffff]
[    0.000000]  [mem 0x00000000-0x000fffff] page 4k
[    0.000000] init_memory_mapping: [mem 0x12000000-0x123fffff]
[    0.000000]  [mem 0x12000000-0x123fffff] page 2M
[    0.000000] init_memory_mapping: [mem 0x10000000-0x11ffffff]
[    0.000000]  [mem 0x10000000-0x11ffffff] page 2M
[    0.000000] init_memory_mapping: [mem 0x00100000-0x0fffffff]
[    0.000000]  [mem 0x00100000-0x003fffff] page 4k
[    0.000000]  [mem 0x00400000-0x0fffffff] page 2M
[    0.000000] init_memory_mapping: [mem 0x12400000-0x13ffdfff]
[    0.000000]  [mem 0x12400000-0x13bfffff] page 2M
[    0.000000]  [mem 0x13c00000-0x13ffdfff] page 4k
[    0.000000] BRK [0x02881000, 0x02881fff] PGTABLE
[    0.000000] cma: CMA: reserved 16 MiB at 11400000
[    0.000000] RAMDISK: [mem 0x127ab000-0x13feffff]
[    0.000000] ACPI: RSDP 000fd950 000014 (v00 BOCHS )
[    0.000000] ACPI: RSDT 13ffe450 000034 (v01 BOCHS  BXPCRSDT 00000001 BXP=
C 00000001)
[    0.000000] ACPI: FACP 13ffff80 000074 (v01 BOCHS  BXPCFACP 00000001 BXP=
C 00000001)
[    0.000000] ACPI: DSDT 13ffe490 0011A9 (v01   BXPC   BXDSDT 00000001 INT=
L 20100528)
[    0.000000] ACPI: FACS 13ffff40 000040
[    0.000000] ACPI: SSDT 13fff7a0 000796 (v01 BOCHS  BXPCSSDT 00000001 BXP=
C 00000001)
[    0.000000] ACPI: APIC 13fff680 000080 (v01 BOCHS  BXPCAPIC 00000001 BXP=
C 00000001)
[    0.000000] ACPI: HPET 13fff640 000038 (v01 BOCHS  BXPCHPET 00000001 BXP=
C 00000001)
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] mapped APIC to         ffffa000 (        fee00000)
[    0.000000] 0MB HIGHMEM available.
[    0.000000] 319MB LOWMEM available.
[    0.000000]   mapped low ram: 0 - 13ffe000
[    0.000000]   low ram: 0 - 13ffe000
[    0.000000] kvm-clock: Using msrs 4b564d01 and 4b564d00
[    0.000000] kvm-clock: cpu 0, msr 0:13ffd001, boot clock
[    0.000000] BRK [0x02882000, 0x02882fff] PGTABLE
[    0.000000] Zone ranges:
[    0.000000]   DMA      [mem 0x00001000-0x00ffffff]
[    0.000000]   Normal   [mem 0x01000000-0x13ffdfff]
[    0.000000]   HighMem  empty
[    0.000000] Movable zone start for each node
[    0.000000] Early memory node ranges
[    0.000000]   node   0: [mem 0x00001000-0x0009efff]
[    0.000000]   node   0: [mem 0x00100000-0x13ffdfff]
[    0.000000] On node 0 totalpages: 81820
[    0.000000] free_area_init_node: node 0, pgdat 821ee8d0, node_mem_map 92=
52b020
[    0.000000]   DMA zone: 32 pages used for memmap
[    0.000000]   DMA zone: 0 pages reserved
[    0.000000]   DMA zone: 3998 pages, LIFO batch:0
[    0.000000]   Normal zone: 608 pages used for memmap
[    0.000000]   Normal zone: 77822 pages, LIFO batch:15
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
[    0.000000] e820: [mem 0x14000000-0xfeffbfff] available for PCI devices
[    0.000000] Booting paravirtualized kernel on KVM
[    0.000000] setup_percpu: NR_CPUS:8 nr_cpumask_bits:8 nr_cpu_ids:2 nr_no=
de_ids:1
[    0.000000] PERCPU: Embedded 11 pages/cpu @92515000 s31856 r0 d13200 u45=
056
[    0.000000] pcpu-alloc: s31856 r0 d13200 u45056 alloc=3D11*4096
[    0.000000] pcpu-alloc: [0] 0 [0] 1=20
[    0.000000] kvm-clock: cpu 0, msr 0:13ffd001, primary cpu clock
[    0.000000] KVM setup async PF for cpu 0
[    0.000000] kvm-stealtime: cpu 0, msr 12517700
[    0.000000] Built 1 zonelists in Zone order, mobility grouping on.  Tota=
l pages: 81180
[    0.000000] Kernel command line: hung_task_panic=3D1 earlyprintk=3DttyS0=
,115200 debug apic=3Ddebug sysrq_always_enabled rcupdate.rcu_cpu_stall_time=
out=3D100 panic=3D10 softlockup_panic=3D1 nmi_watchdog=3Dpanic  prompt_ramd=
isk=3D0 console=3DttyS0,115200 console=3Dtty0 vga=3Dnormal  root=3D/dev/ram=
0 rw link=3D/kernel-tests/run-queue/kvm/i386-randconfig-fd1-0408/linux-deve=
l:devel-f4-i386-201404081359:60e833d86a01ad9d8204a04b8db324106ab50395:bisec=
t-linux5/.vmlinuz-60e833d86a01ad9d8204a04b8db324106ab50395-20140410014725-4=
-lkp-ib03 branch=3Dlinux-devel/devel-f4-i386-201404081359 BOOT_IMAGE=3D/ker=
nel/i386-randconfig-fd1-0408/60e833d86a01ad9d8204a04b8db324106ab50395/vmlin=
uz-3.14.0-rc8-00007-g60e833d drbd.minor_count=3D8
[    0.000000] PID hash table entries: 2048 (order: 1, 8192 bytes)
[    0.000000] Dentry cache hash table entries: 65536 (order: 6, 262144 byt=
es)
[    0.000000] Inode-cache hash table entries: 32768 (order: 5, 131072 byte=
s)
[    0.000000] Initializing CPU#0
[    0.000000] Initializing HighMem for node 0 (00000000:00000000)
[    0.000000] Memory: 257784K/327280K available (11265K kernel code, 1591K=
 rwdata, 5888K rodata, 572K init, 5700K bss, 69496K reserved, 0K highmem)
[    0.000000] virtual kernel memory layout:
[    0.000000]     fixmap  : 0xfff15000 - 0xfffff000   ( 936 kB)
[    0.000000]     pkmap   : 0xff800000 - 0xffc00000   (4096 kB)
[    0.000000]     vmalloc : 0x947fe000 - 0xff7fe000   (1712 MB)
[    0.000000]     lowmem  : 0x80000000 - 0x93ffe000   ( 319 MB)
[    0.000000]       .init : 0x82250000 - 0x822df000   ( 572 kB)
[    0.000000]       .data : 0x81b00984 - 0x8224fc30   (7484 kB)
[    0.000000]       .text : 0x81000000 - 0x81b00984   (11266 kB)
[    0.000000] Checking if this processor honours the WP bit even in superv=
isor mode...Ok.
[    0.000000] SLUB: HWalign=3D128, Order=3D0-3, MinObjects=3D0, CPUs=3D2, =
Nodes=3D1
[    0.000000] Preemptible hierarchical RCU implementation.
[    0.000000] RCU: Adjusting geometry for rcu_fanout_leaf=3D16, nr_cpu_ids=
=3D2
[    0.000000] NR_IRQS:2304 nr_irqs:512 16
[    0.000000] CPU 0 irqstacks, hard=3D91010000 soft=3D91012000
[    0.000000] Initializing cgroup subsys cpuset
[    0.000000] Initializing cgroup subsys cpu
[    0.000000] Linux version 3.14.0-rc8-00007-g60e833d (kbuild@inn) (gcc ve=
rsion 4.8.2 (Debian 4.8.2-18) ) #2 SMP PREEMPT Thu Apr 10 01:46:54 CST 2014
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
[    0.000000] Notice: NX (Execute Disable) protection cannot be enabled: n=
on-PAE kernel!
[    0.000000] Hypervisor detected: KVM
[    0.000000] e820: update [mem 0x00000000-0x00000fff] usable =3D=3D> rese=
rved
[    0.000000] e820: remove [mem 0x000a0000-0x000fffff] usable
[    0.000000] e820: last_pfn =3D 0x13ffe max_arch_pfn =3D 0x100000
[    0.000000] Scanning 1 areas for low memory corruption
[    0.000000] initial memory mapped: [mem 0x00000000-0x02ffffff]
[    0.000000] Base memory trampoline at [8009b000] 9b000 size 16384
[    0.000000] init_memory_mapping: [mem 0x00000000-0x000fffff]
[    0.000000]  [mem 0x00000000-0x000fffff] page 4k
[    0.000000] init_memory_mapping: [mem 0x12000000-0x123fffff]
[    0.000000]  [mem 0x12000000-0x123fffff] page 2M
[    0.000000] init_memory_mapping: [mem 0x10000000-0x11ffffff]
[    0.000000]  [mem 0x10000000-0x11ffffff] page 2M
[    0.000000] init_memory_mapping: [mem 0x00100000-0x0fffffff]
[    0.000000]  [mem 0x00100000-0x003fffff] page 4k
[    0.000000]  [mem 0x00400000-0x0fffffff] page 2M
[    0.000000] init_memory_mapping: [mem 0x12400000-0x13ffdfff]
[    0.000000]  [mem 0x12400000-0x13bfffff] page 2M
[    0.000000]  [mem 0x13c00000-0x13ffdfff] page 4k
[    0.000000] BRK [0x02881000, 0x02881fff] PGTABLE
[    0.000000] cma: CMA: reserved 16 MiB at 11400000
[    0.000000] RAMDISK: [mem 0x127ab000-0x13feffff]
[    0.000000] ACPI: RSDP 000fd950 000014 (v00 BOCHS )
[    0.000000] ACPI: RSDT 13ffe450 000034 (v01 BOCHS  BXPCRSDT 00000001 BXP=
C 00000001)
[    0.000000] ACPI: FACP 13ffff80 000074 (v01 BOCHS  BXPCFACP 00000001 BXP=
C 00000001)
[    0.000000] ACPI: DSDT 13ffe490 0011A9 (v01   BXPC   BXDSDT 00000001 INT=
L 20100528)
[    0.000000] ACPI: FACS 13ffff40 000040
[    0.000000] ACPI: SSDT 13fff7a0 000796 (v01 BOCHS  BXPCSSDT 00000001 BXP=
C 00000001)
[    0.000000] ACPI: APIC 13fff680 000080 (v01 BOCHS  BXPCAPIC 00000001 BXP=
C 00000001)
[    0.000000] ACPI: HPET 13fff640 000038 (v01 BOCHS  BXPCHPET 00000001 BXP=
C 00000001)
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] mapped APIC to         ffffa000 (        fee00000)
[    0.000000] 0MB HIGHMEM available.
[    0.000000] 319MB LOWMEM available.
[    0.000000]   mapped low ram: 0 - 13ffe000
[    0.000000]   low ram: 0 - 13ffe000
[    0.000000] kvm-clock: Using msrs 4b564d01 and 4b564d00
[    0.000000] kvm-clock: cpu 0, msr 0:13ffd001, boot clock
[    0.000000] BRK [0x02882000, 0x02882fff] PGTABLE
[    0.000000] Zone ranges:
[    0.000000]   DMA      [mem 0x00001000-0x00ffffff]
[    0.000000]   Normal   [mem 0x01000000-0x13ffdfff]
[    0.000000]   HighMem  empty
[    0.000000] Movable zone start for each node
[    0.000000] Early memory node ranges
[    0.000000]   node   0: [mem 0x00001000-0x0009efff]
[    0.000000]   node   0: [mem 0x00100000-0x13ffdfff]
[    0.000000] On node 0 totalpages: 81820
[    0.000000] free_area_init_node: node 0, pgdat 821ee8d0, node_mem_map 92=
52b020
[    0.000000]   DMA zone: 32 pages used for memmap
[    0.000000]   DMA zone: 0 pages reserved
[    0.000000]   DMA zone: 3998 pages, LIFO batch:0
[    0.000000]   Normal zone: 608 pages used for memmap
[    0.000000]   Normal zone: 77822 pages, LIFO batch:15
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
[    0.000000] e820: [mem 0x14000000-0xfeffbfff] available for PCI devices
[    0.000000] Booting paravirtualized kernel on KVM
[    0.000000] setup_percpu: NR_CPUS:8 nr_cpumask_bits:8 nr_cpu_ids:2 nr_no=
de_ids:1
[    0.000000] PERCPU: Embedded 11 pages/cpu @92515000 s31856 r0 d13200 u45=
056
[    0.000000] pcpu-alloc: s31856 r0 d13200 u45056 alloc=3D11*4096
[    0.000000] pcpu-alloc: [0] 0 [0] 1=20
[    0.000000] kvm-clock: cpu 0, msr 0:13ffd001, primary cpu clock
[    0.000000] KVM setup async PF for cpu 0
[    0.000000] kvm-stealtime: cpu 0, msr 12517700
[    0.000000] Built 1 zonelists in Zone order, mobility grouping on.  Tota=
l pages: 81180
[    0.000000] Kernel command line: hung_task_panic=3D1 earlyprintk=3DttyS0=
,115200 debug apic=3Ddebug sysrq_always_enabled rcupdate.rcu_cpu_stall_time=
out=3D100 panic=3D10 softlockup_panic=3D1 nmi_watchdog=3Dpanic  prompt_ramd=
isk=3D0 console=3DttyS0,115200 console=3Dtty0 vga=3Dnormal  root=3D/dev/ram=
0 rw link=3D/kernel-tests/run-queue/kvm/i386-randconfig-fd1-0408/linux-deve=
l:devel-f4-i386-201404081359:60e833d86a01ad9d8204a04b8db324106ab50395:bisec=
t-linux5/.vmlinuz-60e833d86a01ad9d8204a04b8db324106ab50395-20140410014725-4=
-lkp-ib03 branch=3Dlinux-devel/devel-f4-i386-201404081359 BOOT_IMAGE=3D/ker=
nel/i386-randconfig-fd1-0408/60e833d86a01ad9d8204a04b8db324106ab50395/vmlin=
uz-3.14.0-rc8-00007-g60e833d drbd.minor_count=3D8
[    0.000000] PID hash table entries: 2048 (order: 1, 8192 bytes)
[    0.000000] Dentry cache hash table entries: 65536 (order: 6, 262144 byt=
es)
[    0.000000] Inode-cache hash table entries: 32768 (order: 5, 131072 byte=
s)
[    0.000000] Initializing CPU#0
[    0.000000] Initializing HighMem for node 0 (00000000:00000000)
[    0.000000] Memory: 257784K/327280K available (11265K kernel code, 1591K=
 rwdata, 5888K rodata, 572K init, 5700K bss, 69496K reserved, 0K highmem)
[    0.000000] virtual kernel memory layout:
[    0.000000]     fixmap  : 0xfff15000 - 0xfffff000   ( 936 kB)
[    0.000000]     pkmap   : 0xff800000 - 0xffc00000   (4096 kB)
[    0.000000]     vmalloc : 0x947fe000 - 0xff7fe000   (1712 MB)
[    0.000000]     lowmem  : 0x80000000 - 0x93ffe000   ( 319 MB)
[    0.000000]       .init : 0x82250000 - 0x822df000   ( 572 kB)
[    0.000000]       .data : 0x81b00984 - 0x8224fc30   (7484 kB)
[    0.000000]       .text : 0x81000000 - 0x81b00984   (11266 kB)
[    0.000000] Checking if this processor honours the WP bit even in superv=
isor mode...Ok.
[    0.000000] SLUB: HWalign=3D128, Order=3D0-3, MinObjects=3D0, CPUs=3D2, =
Nodes=3D1
[    0.000000] Preemptible hierarchical RCU implementation.
[    0.000000] RCU: Adjusting geometry for rcu_fanout_leaf=3D16, nr_cpu_ids=
=3D2
[    0.000000] NR_IRQS:2304 nr_irqs:512 16
[    0.000000] CPU 0 irqstacks, hard=3D91010000 soft=3D91012000
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
[    0.000000] ... MAX_LOCKDEP_ENTRIES:     16384
[    0.000000] ... MAX_LOCKDEP_ENTRIES:     16384
[    0.000000] ... MAX_LOCKDEP_CHAINS:      32768
[    0.000000] ... MAX_LOCKDEP_CHAINS:      32768
[    0.000000] ... CHAINHASH_SIZE:          16384
[    0.000000] ... CHAINHASH_SIZE:          16384
[    0.000000]  memory used by lock dependency info: 3567 kB
[    0.000000]  memory used by lock dependency info: 3567 kB
[    0.000000]  per task-struct memory footprint: 1152 bytes
[    0.000000]  per task-struct memory footprint: 1152 bytes
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
[    0.000000] hpet clockevent registered
[    0.000000] hpet clockevent registered
[    0.000000] tsc: Detected 2693.672 MHz processor
[    0.000000] tsc: Detected 2693.672 MHz processor
[    0.020000] Calibrating delay loop (skipped) preset value..=20
[    0.020000] Calibrating delay loop (skipped) preset value.. 5387.34 Bogo=
MIPS (lpj=3D26936720)
5387.34 BogoMIPS (lpj=3D26936720)
[    0.020000] pid_max: default: 32768 minimum: 301
[    0.020000] pid_max: default: 32768 minimum: 301
[    0.020000] ACPI: Core revision 20131218
[    0.020000] ACPI: Core revision 20131218
[    0.042928] ACPI:=20
[    0.042928] ACPI: All ACPI Tables successfully acquiredAll ACPI Tables s=
uccessfully acquired

[    0.044511] Mount-cache hash table entries: 512
[    0.044511] Mount-cache hash table entries: 512
[    0.046401] Initializing cgroup subsys devices
[    0.046401] Initializing cgroup subsys devices
[    0.047506] Initializing cgroup subsys blkio
[    0.047506] Initializing cgroup subsys blkio
[    0.048510] Initializing cgroup subsys net_prio
[    0.048510] Initializing cgroup subsys net_prio
[    0.049778] mce: CPU supports 10 MCE banks
[    0.049778] mce: CPU supports 10 MCE banks
[    0.050123] Last level iTLB entries: 4KB 0, 2MB 0, 4MB 0
[    0.050123] Last level dTLB entries: 4KB 0, 2MB 0, 4MB 0, 1GB 0
[    0.050123] tlb_flushall_shift: 6
[    0.050123] Last level iTLB entries: 4KB 0, 2MB 0, 4MB 0
[    0.050123] Last level dTLB entries: 4KB 0, 2MB 0, 4MB 0, 1GB 0
[    0.050123] tlb_flushall_shift: 6
[    0.054428] Freeing SMP alternatives memory: 20K (822df000 - 822e4000)
[    0.054428] Freeing SMP alternatives memory: 20K (822df000 - 822e4000)
[    0.057910] Getting VERSION: 50014
[    0.057910] Getting VERSION: 50014
[    0.058760] Getting VERSION: 50014
[    0.058760] Getting VERSION: 50014
[    0.060009] Getting ID: 0
[    0.060009] Getting ID: 0
[    0.060646] Getting ID: f000000
[    0.060646] Getting ID: f000000
[    0.061406] Getting LVT0: 8700
[    0.061406] Getting LVT0: 8700
[    0.062137] Getting LVT1: 8400
[    0.062137] Getting LVT1: 8400
[    0.062892] Enabling APIC mode:  Flat.  Using 1 I/O APICs
[    0.062892] Enabling APIC mode:  Flat.  Using 1 I/O APICs
[    0.064176] enabled ExtINT on CPU#0
[    0.064176] enabled ExtINT on CPU#0
[    0.066166] ENABLING IO-APIC IRQs
[    0.066166] ENABLING IO-APIC IRQs
[    0.066982] init IO_APIC IRQs
[    0.066982] init IO_APIC IRQs
[    0.067689]  apic 0 pin 0 not connected
[    0.067689]  apic 0 pin 0 not connected
[    0.068617] IOAPIC[0]: Set routing entry (0-1 -> 0x31 -> IRQ 1 Mode:0 Ac=
tive:0 Dest:1)
[    0.068617] IOAPIC[0]: Set routing entry (0-1 -> 0x31 -> IRQ 1 Mode:0 Ac=
tive:0 Dest:1)
[    0.070040] IOAPIC[0]: Set routing entry (0-2 -> 0x30 -> IRQ 0 Mode:0 Ac=
tive:0 Dest:1)
[    0.070040] IOAPIC[0]: Set routing entry (0-2 -> 0x30 -> IRQ 0 Mode:0 Ac=
tive:0 Dest:1)
[    0.071914] IOAPIC[0]: Set routing entry (0-3 -> 0x33 -> IRQ 3 Mode:0 Ac=
tive:0 Dest:1)
[    0.071914] IOAPIC[0]: Set routing entry (0-3 -> 0x33 -> IRQ 3 Mode:0 Ac=
tive:0 Dest:1)
[    0.073812] IOAPIC[0]: Set routing entry (0-4 -> 0x34 -> IRQ 4 Mode:0 Ac=
tive:0 Dest:1)
[    0.073812] IOAPIC[0]: Set routing entry (0-4 -> 0x34 -> IRQ 4 Mode:0 Ac=
tive:0 Dest:1)
[    0.075713] IOAPIC[0]: Set routing entry (0-5 -> 0x35 -> IRQ 5 Mode:1 Ac=
tive:0 Dest:1)
[    0.075713] IOAPIC[0]: Set routing entry (0-5 -> 0x35 -> IRQ 5 Mode:1 Ac=
tive:0 Dest:1)
[    0.077593] IOAPIC[0]: Set routing entry (0-6 -> 0x36 -> IRQ 6 Mode:0 Ac=
tive:0 Dest:1)
[    0.077593] IOAPIC[0]: Set routing entry (0-6 -> 0x36 -> IRQ 6 Mode:0 Ac=
tive:0 Dest:1)
[    0.080036] IOAPIC[0]: Set routing entry (0-7 -> 0x37 -> IRQ 7 Mode:0 Ac=
tive:0 Dest:1)
[    0.080036] IOAPIC[0]: Set routing entry (0-7 -> 0x37 -> IRQ 7 Mode:0 Ac=
tive:0 Dest:1)
[    0.081932] IOAPIC[0]: Set routing entry (0-8 -> 0x38 -> IRQ 8 Mode:0 Ac=
tive:0 Dest:1)
[    0.081932] IOAPIC[0]: Set routing entry (0-8 -> 0x38 -> IRQ 8 Mode:0 Ac=
tive:0 Dest:1)
[    0.083838] IOAPIC[0]: Set routing entry (0-9 -> 0x39 -> IRQ 9 Mode:1 Ac=
tive:0 Dest:1)
[    0.083838] IOAPIC[0]: Set routing entry (0-9 -> 0x39 -> IRQ 9 Mode:1 Ac=
tive:0 Dest:1)
[    0.085719] IOAPIC[0]: Set routing entry (0-10 -> 0x3a -> IRQ 10 Mode:1 =
Active:0 Dest:1)
[    0.085719] IOAPIC[0]: Set routing entry (0-10 -> 0x3a -> IRQ 10 Mode:1 =
Active:0 Dest:1)
[    0.087683] IOAPIC[0]: Set routing entry (0-11 -> 0x3b -> IRQ 11 Mode:1 =
Active:0 Dest:1)
[    0.087683] IOAPIC[0]: Set routing entry (0-11 -> 0x3b -> IRQ 11 Mode:1 =
Active:0 Dest:1)
[    0.090039] IOAPIC[0]: Set routing entry (0-12 -> 0x3c -> IRQ 12 Mode:0 =
Active:0 Dest:1)
[    0.090039] IOAPIC[0]: Set routing entry (0-12 -> 0x3c -> IRQ 12 Mode:0 =
Active:0 Dest:1)
[    0.091999] IOAPIC[0]: Set routing entry (0-13 -> 0x3d -> IRQ 13 Mode:0 =
Active:0 Dest:1)
[    0.091999] IOAPIC[0]: Set routing entry (0-13 -> 0x3d -> IRQ 13 Mode:0 =
Active:0 Dest:1)
[    0.094021] IOAPIC[0]: Set routing entry (0-14 -> 0x3e -> IRQ 14 Mode:0 =
Active:0 Dest:1)
[    0.094021] IOAPIC[0]: Set routing entry (0-14 -> 0x3e -> IRQ 14 Mode:0 =
Active:0 Dest:1)
[    0.095973] IOAPIC[0]: Set routing entry (0-15 -> 0x3f -> IRQ 15 Mode:0 =
Active:0 Dest:1)
[    0.095973] IOAPIC[0]: Set routing entry (0-15 -> 0x3f -> IRQ 15 Mode:0 =
Active:0 Dest:1)
[    0.097887]  apic 0 pin 16 not connected
[    0.097887]  apic 0 pin 16 not connected
[    0.098850]  apic 0 pin 17 not connected
[    0.098850]  apic 0 pin 17 not connected
[    0.099777]  apic 0 pin 18 not connected
[    0.099777]  apic 0 pin 18 not connected
[    0.100007]  apic 0 pin 19 not connected
[    0.100007]  apic 0 pin 19 not connected
[    0.100935]  apic 0 pin 20 not connected
[    0.100935]  apic 0 pin 20 not connected
[    0.101865]  apic 0 pin 21 not connected
[    0.101865]  apic 0 pin 21 not connected
[    0.102808]  apic 0 pin 22 not connected
[    0.102808]  apic 0 pin 22 not connected
[    0.103727]  apic 0 pin 23 not connected
[    0.103727]  apic 0 pin 23 not connected
[    0.104802] ..TIMER: vector=3D0x30 apic1=3D0 pin1=3D2 apic2=3D-1 pin2=3D=
-1
[    0.104802] ..TIMER: vector=3D0x30 apic1=3D0 pin1=3D2 apic2=3D-1 pin2=3D=
-1
[    0.106595] smpboot: CPU0:=20
[    0.106595] smpboot: CPU0: Intel Intel Common KVM processorCommon KVM pr=
ocessor (fam: 0f, model: 06 (fam: 0f, model: 06, stepping: 01)
, stepping: 01)
[    0.109047] Using local APIC timer interrupts.
[    0.109047] calibrating APIC timer ...
[    0.109047] Using local APIC timer interrupts.
[    0.109047] calibrating APIC timer ...
[    0.120000] ... lapic delta =3D 6250492
[    0.120000] ... lapic delta =3D 6250492
[    0.120000] ... PM-Timer delta =3D 357986
[    0.120000] ... PM-Timer delta =3D 357986
[    0.120000] ... PM-Timer result ok
[    0.120000] ... PM-Timer result ok
[    0.120000] ..... delta 6250492
[    0.120000] ..... delta 6250492
[    0.120000] ..... mult: 268456587
[    0.120000] ..... mult: 268456587
[    0.120000] ..... calibration result: 10000787
[    0.120000] ..... calibration result: 10000787
[    0.120000] ..... CPU clock speed is 2693.7788 MHz.
[    0.120000] ..... CPU clock speed is 2693.7788 MHz.
[    0.120000] ..... host bus clock speed is 1000.0787 MHz.
[    0.120000] ..... host bus clock speed is 1000.0787 MHz.
[    0.120072] Performance Events:=20
[    0.120072] Performance Events: unsupported Netburst CPU model 6 unsuppo=
rted Netburst CPU model 6 no PMU driver, software events only.
no PMU driver, software events only.
[    0.160166] ftrace: Allocated trace_printk buffers
[    0.160166] ftrace: Allocated trace_printk buffers
[    0.180240] NMI watchdog: disabled (cpu0): hardware events not enabled
[    0.180240] NMI watchdog: disabled (cpu0): hardware events not enabled
[    0.200462] CPU 1 irqstacks, hard=3D913c2000 soft=3D913c4000
[    0.200462] CPU 1 irqstacks, hard=3D913c2000 soft=3D913c4000
[    0.201726] x86: Booting SMP configuration:
[    0.201726] x86: Booting SMP configuration:
[    0.202702] .... node  #0, CPUs: =20
[    0.202702] .... node  #0, CPUs:         #1 #1
[    0.010000] Initializing CPU#1
[    0.020000] kvm-clock: cpu 1, msr 0:13ffd021, secondary cpu clock
[    0.020000] masked ExtINT on CPU#1
[    0.222430] x86: Booted up 1 node, 2 CPUs
[    0.222430] x86: Booted up 1 node, 2 CPUs
[    0.222353] KVM setup async PF for cpu 1
[    0.222353] KVM setup async PF for cpu 1
[    0.222353] kvm-stealtime: cpu 1, msr 12522700
[    0.222353] kvm-stealtime: cpu 1, msr 12522700
[    0.230016] ----------------
[    0.230016] ----------------
[    0.233665] | NMI testsuite:
[    0.233665] | NMI testsuite:
[    0.234383] --------------------
[    0.234383] --------------------
[    0.240006]   remote IPI:
[    0.240006]   remote IPI:  ok  |  ok  |

[    0.270319]    local IPI:
[    0.270319]    local IPI:  ok  |  ok  |

[    0.330031] --------------------
[    0.330031] --------------------
[    0.330800] Good, all   2 testcases passed! |
[    0.330800] Good, all   2 testcases passed! |
[    0.331800] ---------------------------------
[    0.331800] ---------------------------------
[    0.332824] smpboot: Total of 2 processors activated (10774.68 BogoMIPS)
[    0.332824] smpboot: Total of 2 processors activated (10774.68 BogoMIPS)
[    0.335016] devtmpfs: initialized
[    0.335016] devtmpfs: initialized
[    0.344257] xor: measuring software checksum speed
[    0.344257] xor: measuring software checksum speed
[    0.360010]    pIII_sse  :     0.192 MB/sec
[    0.360010]    pIII_sse  :     0.192 MB/sec
[    0.380008]    prefetch64-sse:     0.178 MB/sec
[    0.380008]    prefetch64-sse:     0.178 MB/sec
[    0.381056] xor: using function: pIII_sse (0.192 MB/sec)
[    0.381056] xor: using function: pIII_sse (0.192 MB/sec)
[    0.382268] ------------[ cut here ]------------
[    0.382268] ------------[ cut here ]------------
[    0.383315] WARNING: CPU: 0 PID: 1 at init/main.c:708 do_one_initcall+0x=
11d/0x136()
[    0.383315] WARNING: CPU: 0 PID: 1 at init/main.c:708 do_one_initcall+0x=
11d/0x136()
[    0.386506] initcall calibrate_xor_blocks+0x0/0x17f returned with preemp=
tion imbalance=20
[    0.386506] initcall calibrate_xor_blocks+0x0/0x17f returned with preemp=
tion imbalance=20
[    0.388417] CPU: 0 PID: 1 Comm: swapper/0 Not tainted 3.14.0-rc8-00007-g=
60e833d #2
[    0.388417] CPU: 0 PID: 1 Comm: swapper/0 Not tainted 3.14.0-rc8-00007-g=
60e833d #2
[    0.390007]  00000000
[    0.390007]  00000000 00000000 00000000 9106febc 9106febc 81aeaf7d 81aea=
f7d 9106fefc 9106fefc 9106feec 9106feec 81039a96 81039a96 81f5758f 81f5758f

[    0.394731]  9106ff18
[    0.394731]  9106ff18 00000001 00000001 81f57320 81f57320 000002c4 00000=
2c4 82250b54 82250b54 82250b54 82250b54 00000001 00000001 8227e0b8 8227e0b8

[    0.398813]  00000000
[    0.398813]  00000000 9106ff04 9106ff04 81039af4 81039af4 00000009 00000=
009 9106fefc 9106fefc 81f5758f 81f5758f 9106ff18 9106ff18 9106ff74 9106ff74

[    0.401267] Call Trace:
[    0.401267] Call Trace:
[    0.401846]  [<81aeaf7d>] dump_stack+0x4b/0x98
[    0.401846]  [<81aeaf7d>] dump_stack+0x4b/0x98
[    0.403658]  [<81039a96>] warn_slowpath_common+0x74/0x8b
[    0.403658]  [<81039a96>] warn_slowpath_common+0x74/0x8b
[    0.404920]  [<82250b54>] ? do_one_initcall+0x11d/0x136
[    0.404920]  [<82250b54>] ? do_one_initcall+0x11d/0x136
[    0.406157]  [<82250b54>] ? do_one_initcall+0x11d/0x136
[    0.406157]  [<82250b54>] ? do_one_initcall+0x11d/0x136
[    0.410013]  [<8227e0b8>] ? do_xor_speed+0x112/0x112
[    0.410013]  [<8227e0b8>] ? do_xor_speed+0x112/0x112
[    0.413253]  [<81039af4>] warn_slowpath_fmt+0x2e/0x30
[    0.413253]  [<81039af4>] warn_slowpath_fmt+0x2e/0x30
[    0.414399]  [<82250b54>] do_one_initcall+0x11d/0x136
[    0.414399]  [<82250b54>] do_one_initcall+0x11d/0x136
[    0.420011]  [<8227e0b8>] ? do_xor_speed+0x112/0x112
[    0.420011]  [<8227e0b8>] ? do_xor_speed+0x112/0x112
[    0.421141]  [<82250d01>] kernel_init_freeable+0x194/0x23b
[    0.421141]  [<82250d01>] kernel_init_freeable+0x194/0x23b
[    0.423149]  [<8225042b>] ? do_early_param+0x7a/0x7a
[    0.423149]  [<8225042b>] ? do_early_param+0x7a/0x7a
[    0.424283]  [<81adcda8>] kernel_init+0xb/0xcb
[    0.424283]  [<81adcda8>] kernel_init+0xb/0xcb
[    0.425290]  [<8105dcd2>] ? schedule_tail+0x21/0x4f
[    0.425290]  [<8105dcd2>] ? schedule_tail+0x21/0x4f
[    0.426493]  [<81affc7b>] ret_from_kernel_thread+0x1b/0x30
[    0.426493]  [<81affc7b>] ret_from_kernel_thread+0x1b/0x30
[    0.427726]  [<81adcd9d>] ? rest_init+0x122/0x122
[    0.427726]  [<81adcd9d>] ? rest_init+0x122/0x122
[    0.430030] ---[ end trace 55007558fd7bf832 ]---
[    0.430030] ---[ end trace 55007558fd7bf832 ]---
[    0.431083] atomic64 test passed for i386+ platform with CX8 and with SSE
[    0.431083] atomic64 test passed for i386+ platform with CX8 and with SSE
[    0.440932] regulator-dummy: no parameters
[    0.440932] regulator-dummy: no parameters
[    0.442935] NET: Registered protocol family 16
[    0.442935] NET: Registered protocol family 16
[    0.446716] cpuidle: using governor ladder
[    0.446716] cpuidle: using governor ladder
[    0.447733] cpuidle: using governor menu
[    0.447733] cpuidle: using governor menu
[    0.449872] ACPI: bus type PCI registered
[    0.449872] ACPI: bus type PCI registered
[    0.450483] PCI: PCI BIOS revision 2.10 entry at 0xfc6d5, last bus=3D0
[    0.450483] PCI: PCI BIOS revision 2.10 entry at 0xfc6d5, last bus=3D0
[    0.572449] bio: create slab <bio-0> at 0
[    0.572449] bio: create slab <bio-0> at 0
[    0.600013] raid6: mmxx1      519=20
[    0.600013] raid6: mmxx1      519=20
[    0.620019] raid6: mmxx2      489=20
[    0.620019] raid6: mmxx2      489=20
[    0.640012] raid6: sse1x1     322=20
[    0.640012] raid6: sse1x1     322=20
[    0.660015] raid6: sse1x2     533=20
[    0.660015] raid6: sse1x2     533=20
[    0.680014] raid6: sse2x1     585=20
[    0.680014] raid6: sse2x1     585=20
[    0.700008] raid6: sse2x2    1052=20
[    0.700008] raid6: sse2x2    1052=20
[    0.705070] raid6: using algorithm sse2x2 (1052)
[    0.705070] raid6: using algorithm sse2x2 (1052)
[    0.706308] raid6: using intx1 recovery algorithm
[    0.706308] raid6: using intx1 recovery algorithm
[    0.710255] ACPI: Added _OSI(Module Device)
[    0.710255] ACPI: Added _OSI(Module Device)
[    0.711472] ACPI: Added _OSI(Processor Device)
[    0.711472] ACPI: Added _OSI(Processor Device)
[    0.712555] ACPI: Added _OSI(3.0 _SCP Extensions)
[    0.712555] ACPI: Added _OSI(3.0 _SCP Extensions)
[    0.713799] ACPI: Added _OSI(Processor Aggregator Device)
[    0.713799] ACPI: Added _OSI(Processor Aggregator Device)
[    0.812281] ACPI: Interpreter enabled
[    0.812281] ACPI: Interpreter enabled
[    0.818424] ACPI: (supports S0 S5)
[    0.818424] ACPI: (supports S0 S5)
[    0.819155] ACPI: Using IOAPIC for interrupt routing
[    0.819155] ACPI: Using IOAPIC for interrupt routing
[    0.820226] PCI: Using host bridge windows from ACPI; if necessary, use =
"pci=3Dnocrs" and report a bug
[    0.820226] PCI: Using host bridge windows from ACPI; if necessary, use =
"pci=3Dnocrs" and report a bug
[    0.918508] ACPI: PCI Root Bridge [PCI0] (domain 0000 [bus 00-ff])
[    0.918508] ACPI: PCI Root Bridge [PCI0] (domain 0000 [bus 00-ff])
[    0.919968] acpi PNP0A03:00: _OSC: OS supports [Segments MSI]
[    0.919968] acpi PNP0A03:00: _OSC: OS supports [Segments MSI]
[    0.920148] acpi PNP0A03:00: _OSC failed (AE_NOT_FOUND); disabling ASPM
[    0.920148] acpi PNP0A03:00: _OSC failed (AE_NOT_FOUND); disabling ASPM
[    0.926542] PCI host bridge to bus 0000:00
[    0.926542] PCI host bridge to bus 0000:00
[    0.927438] pci_bus 0000:00: root bus resource [bus 00-ff]
[    0.927438] pci_bus 0000:00: root bus resource [bus 00-ff]
[    0.928614] pci_bus 0000:00: root bus resource [io  0x0000-0x0cf7]
[    0.928614] pci_bus 0000:00: root bus resource [io  0x0000-0x0cf7]
[    0.930013] pci_bus 0000:00: root bus resource [io  0x0d00-0xffff]
[    0.930013] pci_bus 0000:00: root bus resource [io  0x0d00-0xffff]
[    0.931315] pci_bus 0000:00: root bus resource [mem 0x000a0000-0x000bfff=
f]
[    0.931315] pci_bus 0000:00: root bus resource [mem 0x000a0000-0x000bfff=
f]
[    0.932778] pci_bus 0000:00: root bus resource [mem 0x80000000-0xfebffff=
f]
[    0.932778] pci_bus 0000:00: root bus resource [mem 0x80000000-0xfebffff=
f]
[    0.934315] pci 0000:00:00.0: [8086:1237] type 00 class 0x060000
[    0.934315] pci 0000:00:00.0: [8086:1237] type 00 class 0x060000
[    0.937854] pci 0000:00:01.0: [8086:7000] type 00 class 0x060100
[    0.937854] pci 0000:00:01.0: [8086:7000] type 00 class 0x060100
[    0.942504] pci 0000:00:01.1: [8086:7010] type 00 class 0x010180
[    0.942504] pci 0000:00:01.1: [8086:7010] type 00 class 0x010180
[    0.946491] pci 0000:00:01.1: reg 0x20: [io  0xc040-0xc04f]
[    0.946491] pci 0000:00:01.1: reg 0x20: [io  0xc040-0xc04f]
[    0.951023] pci 0000:00:01.3: [8086:7113] type 00 class 0x068000
[    0.951023] pci 0000:00:01.3: [8086:7113] type 00 class 0x068000
[    0.952697] pci 0000:00:01.3: quirk: [io  0xb000-0xb03f] claimed by PIIX=
4 ACPI
[    0.952697] pci 0000:00:01.3: quirk: [io  0xb000-0xb03f] claimed by PIIX=
4 ACPI
[    0.954234] pci 0000:00:01.3: quirk: [io  0xb100-0xb10f] claimed by PIIX=
4 SMB
[    0.954234] pci 0000:00:01.3: quirk: [io  0xb100-0xb10f] claimed by PIIX=
4 SMB
[    0.957853] pci 0000:00:02.0: [1013:00b8] type 00 class 0x030000
[    0.957853] pci 0000:00:02.0: [1013:00b8] type 00 class 0x030000
[    0.960013] pci 0000:00:02.0: reg 0x10: [mem 0xfc000000-0xfdffffff pref]
[    0.960013] pci 0000:00:02.0: reg 0x10: [mem 0xfc000000-0xfdffffff pref]
[    0.962722] pci 0000:00:02.0: reg 0x14: [mem 0xfebf0000-0xfebf0fff]
[    0.962722] pci 0000:00:02.0: reg 0x14: [mem 0xfebf0000-0xfebf0fff]
[    0.970609] pci 0000:00:02.0: reg 0x30: [mem 0xfebe0000-0xfebeffff pref]
[    0.970609] pci 0000:00:02.0: reg 0x30: [mem 0xfebe0000-0xfebeffff pref]
[    0.974171] pci 0000:00:03.0: [8086:100e] type 00 class 0x020000
[    0.974171] pci 0000:00:03.0: [8086:100e] type 00 class 0x020000
[    0.976470] pci 0000:00:03.0: reg 0x10: [mem 0xfeba0000-0xfebbffff]
[    0.976470] pci 0000:00:03.0: reg 0x10: [mem 0xfeba0000-0xfebbffff]
[    0.978811] pci 0000:00:03.0: reg 0x14: [io  0xc000-0xc03f]
[    0.978811] pci 0000:00:03.0: reg 0x14: [io  0xc000-0xc03f]
[    0.985006] pci 0000:00:03.0: reg 0x30: [mem 0xfebc0000-0xfebdffff pref]
[    0.985006] pci 0000:00:03.0: reg 0x30: [mem 0xfebc0000-0xfebdffff pref]
[    0.988472] pci 0000:00:04.0: [8086:25ab] type 00 class 0x088000
[    0.988472] pci 0000:00:04.0: [8086:25ab] type 00 class 0x088000
[    0.990287] pci 0000:00:04.0: reg 0x10: [mem 0xfebf1000-0xfebf100f]
[    0.990287] pci 0000:00:04.0: reg 0x10: [mem 0xfebf1000-0xfebf100f]
[    0.996955] pci_bus 0000:00: on NUMA node 0
[    0.996955] pci_bus 0000:00: on NUMA node 0
[    1.003363] ACPI: PCI Interrupt Link [LNKA] (IRQs
[    1.003363] ACPI: PCI Interrupt Link [LNKA] (IRQs 5 5 *10 *10 11 11))

[    1.006272] ACPI: PCI Interrupt Link [LNKB] (IRQs
[    1.006272] ACPI: PCI Interrupt Link [LNKB] (IRQs 5 5 *10 *10 11 11))

[    1.009167] ACPI: PCI Interrupt Link [LNKC] (IRQs
[    1.009167] ACPI: PCI Interrupt Link [LNKC] (IRQs 5 5 10 10 *11 *11))

[    1.011924] ACPI: PCI Interrupt Link [LNKD] (IRQs
[    1.011924] ACPI: PCI Interrupt Link [LNKD] (IRQs 5 5 10 10 *11 *11))

[    1.013830] ACPI: PCI Interrupt Link [LNKS] (IRQs
[    1.013830] ACPI: PCI Interrupt Link [LNKS] (IRQs *9 *9))

[    1.019821] ACPI:=20
[    1.019821] ACPI: Enabled 16 GPEs in block 00 to 0FEnabled 16 GPEs in bl=
ock 00 to 0F

[    1.023474] ACPI: bus type USB registered
[    1.023474] ACPI: bus type USB registered
[    1.023897] usbcore: registered new interface driver usbfs
[    1.023897] usbcore: registered new interface driver usbfs
[    1.025204] usbcore: registered new interface driver hub
[    1.025204] usbcore: registered new interface driver hub
[    1.030135] usbcore: registered new device driver usb
[    1.030135] usbcore: registered new device driver usb
[    1.032344] Linux video capture interface: v2.00
[    1.032344] Linux video capture interface: v2.00
[    1.034699] wmi: Mapper loaded
[    1.034699] wmi: Mapper loaded
[    1.035366] PCI: Using ACPI for IRQ routing
[    1.035366] PCI: Using ACPI for IRQ routing
[    1.036260] PCI: pci_cache_line_size set to 64 bytes
[    1.036260] PCI: pci_cache_line_size set to 64 bytes
[    1.037442] e820: reserve RAM buffer [mem 0x0009fc00-0x0009ffff]
[    1.037442] e820: reserve RAM buffer [mem 0x0009fc00-0x0009ffff]
[    1.038722] e820: reserve RAM buffer [mem 0x13ffe000-0x13ffffff]
[    1.038722] e820: reserve RAM buffer [mem 0x13ffe000-0x13ffffff]
[    1.041985] nfc: nfc_init: NFC Core ver 0.1
[    1.041985] nfc: nfc_init: NFC Core ver 0.1
[    1.041985] NET: Registered protocol family 39
[    1.041985] NET: Registered protocol family 39
[    1.043817] HPET: 3 timers in total, 0 timers will be used for per-cpu t=
imer
[    1.043817] HPET: 3 timers in total, 0 timers will be used for per-cpu t=
imer
[    1.050164] Switched to clocksource kvm-clock
[    1.050164] Switched to clocksource kvm-clock
[    1.052267] Warning: could not register annotated branches stats
[    1.052267] Warning: could not register annotated branches stats
[    1.160264] pnp: PnP ACPI init
[    1.160264] pnp: PnP ACPI init
[    1.161199] ACPI: bus type PNP registered
[    1.161199] ACPI: bus type PNP registered
[    1.162441] IOAPIC[0]: Set routing entry (0-8 -> 0x38 -> IRQ 8 Mode:0 Ac=
tive:0 Dest:3)
[    1.162441] IOAPIC[0]: Set routing entry (0-8 -> 0x38 -> IRQ 8 Mode:0 Ac=
tive:0 Dest:3)
[    1.164796] pnp 00:00: Plug and Play ACPI device, IDs PNP0b00 (active)
[    1.164796] pnp 00:00: Plug and Play ACPI device, IDs PNP0b00 (active)
[    1.166616] IOAPIC[0]: Set routing entry (0-1 -> 0x31 -> IRQ 1 Mode:0 Ac=
tive:0 Dest:3)
[    1.166616] IOAPIC[0]: Set routing entry (0-1 -> 0x31 -> IRQ 1 Mode:0 Ac=
tive:0 Dest:3)
[    1.168921] pnp 00:01: Plug and Play ACPI device, IDs PNP0303 (active)
[    1.168921] pnp 00:01: Plug and Play ACPI device, IDs PNP0303 (active)
[    1.170749] IOAPIC[0]: Set routing entry (0-12 -> 0x3c -> IRQ 12 Mode:0 =
Active:0 Dest:3)
[    1.170749] IOAPIC[0]: Set routing entry (0-12 -> 0x3c -> IRQ 12 Mode:0 =
Active:0 Dest:3)
[    1.173500] pnp 00:02: Plug and Play ACPI device, IDs PNP0f13 (active)
[    1.173500] pnp 00:02: Plug and Play ACPI device, IDs PNP0f13 (active)
[    1.175638] IOAPIC[0]: Set routing entry (0-6 -> 0x36 -> IRQ 6 Mode:0 Ac=
tive:0 Dest:3)
[    1.175638] IOAPIC[0]: Set routing entry (0-6 -> 0x36 -> IRQ 6 Mode:0 Ac=
tive:0 Dest:3)
[    1.177549] pnp 00:03: [dma 2]
[    1.177549] pnp 00:03: [dma 2]
[    1.178706] pnp 00:03: Plug and Play ACPI device, IDs PNP0700 (active)
[    1.178706] pnp 00:03: Plug and Play ACPI device, IDs PNP0700 (active)
[    1.180861] IOAPIC[0]: Set routing entry (0-7 -> 0x37 -> IRQ 7 Mode:0 Ac=
tive:0 Dest:3)
[    1.180861] IOAPIC[0]: Set routing entry (0-7 -> 0x37 -> IRQ 7 Mode:0 Ac=
tive:0 Dest:3)
[    1.183186] pnp 00:04: Plug and Play ACPI device, IDs PNP0400 (active)
[    1.183186] pnp 00:04: Plug and Play ACPI device, IDs PNP0400 (active)
[    1.185307] IOAPIC[0]: Set routing entry (0-4 -> 0x34 -> IRQ 4 Mode:0 Ac=
tive:0 Dest:3)
[    1.185307] IOAPIC[0]: Set routing entry (0-4 -> 0x34 -> IRQ 4 Mode:0 Ac=
tive:0 Dest:3)
[    1.187569] pnp 00:05: Plug and Play ACPI device, IDs PNP0501 (active)
[    1.187569] pnp 00:05: Plug and Play ACPI device, IDs PNP0501 (active)
[    1.190090] IOAPIC[0]: Set routing entry (0-3 -> 0x33 -> IRQ 3 Mode:0 Ac=
tive:0 Dest:3)
[    1.190090] IOAPIC[0]: Set routing entry (0-3 -> 0x33 -> IRQ 3 Mode:0 Ac=
tive:0 Dest:3)
[    1.192332] pnp 00:06: Plug and Play ACPI device, IDs PNP0501 (active)
[    1.192332] pnp 00:06: Plug and Play ACPI device, IDs PNP0501 (active)
[    1.196600] pnp 00:07: Plug and Play ACPI device, IDs PNP0103 (active)
[    1.196600] pnp 00:07: Plug and Play ACPI device, IDs PNP0103 (active)
[    1.200339] pnp: PnP ACPI: found 8 devices
[    1.200339] pnp: PnP ACPI: found 8 devices
[    1.201289] ACPI: bus type PNP unregistered
[    1.201289] ACPI: bus type PNP unregistered
[    1.241343] pci_bus 0000:00: resource 4 [io  0x0000-0x0cf7]
[    1.241343] pci_bus 0000:00: resource 4 [io  0x0000-0x0cf7]
[    1.242637] pci_bus 0000:00: resource 5 [io  0x0d00-0xffff]
[    1.242637] pci_bus 0000:00: resource 5 [io  0x0d00-0xffff]
[    1.243893] pci_bus 0000:00: resource 6 [mem 0x000a0000-0x000bffff]
[    1.243893] pci_bus 0000:00: resource 6 [mem 0x000a0000-0x000bffff]
[    1.245297] pci_bus 0000:00: resource 7 [mem 0x80000000-0xfebfffff]
[    1.245297] pci_bus 0000:00: resource 7 [mem 0x80000000-0xfebfffff]
[    1.246876] NET: Registered protocol family 2
[    1.246876] NET: Registered protocol family 2
[    1.248461] TCP established hash table entries: 4096 (order: 2, 16384 by=
tes)
[    1.248461] TCP established hash table entries: 4096 (order: 2, 16384 by=
tes)
[    1.250154] TCP bind hash table entries: 4096 (order: 5, 147456 bytes)
[    1.250154] TCP bind hash table entries: 4096 (order: 5, 147456 bytes)
[    1.252010] TCP: Hash tables configured (established 4096 bind 4096)
[    1.252010] TCP: Hash tables configured (established 4096 bind 4096)
[    1.253555] TCP: reno registered
[    1.253555] TCP: reno registered
[    1.254300] UDP hash table entries: 256 (order: 2, 20480 bytes)
[    1.254300] UDP hash table entries: 256 (order: 2, 20480 bytes)
[    1.255699] UDP-Lite hash table entries: 256 (order: 2, 20480 bytes)
[    1.255699] UDP-Lite hash table entries: 256 (order: 2, 20480 bytes)
[    1.257479] NET: Registered protocol family 1
[    1.257479] NET: Registered protocol family 1
[    1.258493] pci 0000:00:00.0: Limiting direct PCI/PCI transfers
[    1.258493] pci 0000:00:00.0: Limiting direct PCI/PCI transfers
[    1.259981] pci 0000:00:01.0: PIIX3: Enabling Passive Release
[    1.259981] pci 0000:00:01.0: PIIX3: Enabling Passive Release
[    1.261319] pci 0000:00:01.0: Activating ISA DMA hang workarounds
[    1.261319] pci 0000:00:01.0: Activating ISA DMA hang workarounds
[    1.263125] pci 0000:00:02.0: Boot video device
[    1.263125] pci 0000:00:02.0: Boot video device
[    1.264350] PCI: CLS 0 bytes, default 64
[    1.264350] PCI: CLS 0 bytes, default 64
[    1.265896] Unpacking initramfs...
[    1.265896] Unpacking initramfs...
[    2.764249] Freeing initrd memory: 24852K (927ab000 - 93ff0000)
[    2.764249] Freeing initrd memory: 24852K (927ab000 - 93ff0000)
[    2.768699] Scanning for low memory corruption every 60 seconds
[    2.768699] Scanning for low memory corruption every 60 seconds
[    2.770614] cryptomgr_test (28) used greatest stack depth: 7284 bytes le=
ft
[    2.770614] cryptomgr_test (28) used greatest stack depth: 7284 bytes le=
ft
[    2.770725] PCLMULQDQ-NI instructions are not detected.
[    2.770725] PCLMULQDQ-NI instructions are not detected.
[    2.770727] The force parameter has not been set to 1. The Iris poweroff=
 handler will not be installed.
[    2.770727] The force parameter has not been set to 1. The Iris poweroff=
 handler will not be installed.
[    2.776078] cryptomgr_test (29) used greatest stack depth: 7216 bytes le=
ft
[    2.776078] cryptomgr_test (29) used greatest stack depth: 7216 bytes le=
ft
[    2.780250] Initializing RT-Tester: OK
[    2.780250] Initializing RT-Tester: OK
[    2.783071] futex hash table entries: 512 (order: 2, 24576 bytes)
[    2.783071] futex hash table entries: 512 (order: 2, 24576 bytes)
[    2.784470] audit: initializing netlink subsys (disabled)
[    2.784470] audit: initializing netlink subsys (disabled)
[    2.785754] audit: type=3D2000 audit(1397065666.840:1): initialized
[    2.785754] audit: type=3D2000 audit(1397065666.840:1): initialized
[    2.917931] DLM installed
[    2.917931] DLM installed
[    2.958687] NTFS driver 2.1.30 [Flags: R/W DEBUG].
[    2.958687] NTFS driver 2.1.30 [Flags: R/W DEBUG].
[    2.966174] fuse init (API version 7.22)
[    2.966174] fuse init (API version 7.22)
[    3.010256] GFS2 installed
[    3.010256] GFS2 installed
[    3.010912] msgmni has been set to 584
[    3.010912] msgmni has been set to 584
[    3.460097] NET: Registered protocol family 38
[    3.460097] NET: Registered protocol family 38
[    3.475770] Block layer SCSI generic (bsg) driver version 0.4 loaded (ma=
jor 253)
[    3.475770] Block layer SCSI generic (bsg) driver version 0.4 loaded (ma=
jor 253)
[    3.478019] io scheduler noop registered (default)
[    3.478019] io scheduler noop registered (default)
[    3.479307] io scheduler deadline registered
[    3.479307] io scheduler deadline registered
[    3.518147] pci_hotplug: PCI Hot Plug PCI Core version: 0.5
[    3.518147] pci_hotplug: PCI Hot Plug PCI Core version: 0.5
[    3.519511] cpcihp_zt5550: ZT5550 CompactPCI Hot Plug Driver version: 0.2
[    3.519511] cpcihp_zt5550: ZT5550 CompactPCI Hot Plug Driver version: 0.2
[    3.525035] cpcihp_generic: Generic port I/O CompactPCI Hot Plug Driver =
version: 0.1
[    3.525035] cpcihp_generic: Generic port I/O CompactPCI Hot Plug Driver =
version: 0.1
[    3.526833] cpcihp_generic: not configured, disabling.
[    3.526833] cpcihp_generic: not configured, disabling.
[    3.531598] shpchp: Standard Hot Plug PCI Controller Driver version: 0.4
[    3.531598] shpchp: Standard Hot Plug PCI Controller Driver version: 0.4
[    3.542183] VIA Graphics Integration Chipset framebuffer 2.4 initializing
[    3.542183] VIA Graphics Integration Chipset framebuffer 2.4 initializing
[    3.548790] vmlfb: initializing
[    3.548790] vmlfb: initializing
[    3.549729] Could not find Carillo Ranch MCH device.
[    3.549729] Could not find Carillo Ranch MCH device.
[    3.558935] cirrusfb 0000:00:02.0: Cirrus Logic chipset on PCI bus, RAM =
(4096 kB) at 0xfc000000
[    3.558935] cirrusfb 0000:00:02.0: Cirrus Logic chipset on PCI bus, RAM =
(4096 kB) at 0xfc000000
[    3.562956] usbcore: registered new interface driver udlfb
[    3.562956] usbcore: registered new interface driver udlfb
[    3.585636] kworker/u4:0 (90) used greatest stack depth: 7020 bytes left
[    3.585636] kworker/u4:0 (90) used greatest stack depth: 7020 bytes left
[    3.587334] uvesafb: failed to execute /sbin/v86d
[    3.587334] uvesafb: failed to execute /sbin/v86d
[    3.588536] uvesafb: make sure that the v86d helper is installed and exe=
cutable
[    3.588536] uvesafb: make sure that the v86d helper is installed and exe=
cutable
[    3.590292] uvesafb: Getting VBE info block failed (eax=3D0x4f00, err=3D=
-2)
[    3.590292] uvesafb: Getting VBE info block failed (eax=3D0x4f00, err=3D=
-2)
[    3.596104] uvesafb: vbe_init() failed with -22
[    3.596104] uvesafb: vbe_init() failed with -22
[    3.597199] uvesafb: probe of uvesafb.0 failed with error -22
[    3.597199] uvesafb: probe of uvesafb.0 failed with error -22
[    3.598788] ipmi message handler version 39.2
[    3.598788] ipmi message handler version 39.2
[    3.599924] IPMI System Interface driver.
[    3.599924] IPMI System Interface driver.
[    3.601226] ipmi_si: Adding default-specified kcs state machine
[    3.601226] ipmi_si: Adding default-specified kcs state machine

[    3.602620] ipmi_si: Trying default-specified kcs state machine at i/o a=
ddress 0xca2, slave address 0x0, irq 0
[    3.602620] ipmi_si: Trying default-specified kcs state machine at i/o a=
ddress 0xca2, slave address 0x0, irq 0
[    3.604917] ipmi_si: Interface detection failed
[    3.604917] ipmi_si: Interface detection failed
[    3.622240] ipmi_si: Adding default-specified smic state machine
[    3.622240] ipmi_si: Adding default-specified smic state machine

[    3.623663] ipmi_si: Trying default-specified smic state machine at i/o =
address 0xca9, slave address 0x0, irq 0
[    3.623663] ipmi_si: Trying default-specified smic state machine at i/o =
address 0xca9, slave address 0x0, irq 0
[    3.625957] ipmi_si: Interface detection failed
[    3.625957] ipmi_si: Interface detection failed
[    3.652090] ipmi_si: Adding default-specified bt state machine
[    3.652090] ipmi_si: Adding default-specified bt state machine

[    3.653534] ipmi_si: Trying default-specified bt state machine at i/o ad=
dress 0xe4, slave address 0x0, irq 0
[    3.653534] ipmi_si: Trying default-specified bt state machine at i/o ad=
dress 0xe4, slave address 0x0, irq 0
[    3.655785] ipmi_si: Interface detection failed
[    3.655785] ipmi_si: Interface detection failed
[    3.690415] ipmi_si: Unable to find any System Interface(s)
[    3.690415] ipmi_si: Unable to find any System Interface(s)
[    3.691839] IPMI Watchdog: driver initialized
[    3.691839] IPMI Watchdog: driver initialized
[    3.693052] Copyright (C) 2004 MontaVista Software - IPMI Powerdown via =
sys_reboot.
[    3.693052] Copyright (C) 2004 MontaVista Software - IPMI Powerdown via =
sys_reboot.
[    3.695965] input: Power Button as /devices/LNXSYSTM:00/LNXPWRBN:00/inpu=
t/input0
[    3.695965] input: Power Button as /devices/LNXSYSTM:00/LNXPWRBN:00/inpu=
t/input0
[    3.697667] ACPI: Power Button [PWRF]
[    3.697667] ACPI: Power Button [PWRF]
[    3.760123] tsc: Refined TSC clocksource calibration: 2693.498 MHz
[    3.760123] tsc: Refined TSC clocksource calibration: 2693.498 MHz
[    3.974584] HDLC line discipline maxframe=3D4096
[    3.974584] HDLC line discipline maxframe=3D4096
[    3.975698] N_HDLC line discipline registered.
[    3.975698] N_HDLC line discipline registered.
[    3.976721] r3964: Philips r3964 Driver $Revision: 1.10 $
[    3.976721] r3964: Philips r3964 Driver $Revision: 1.10 $
[    3.978392] Serial: 8250/16550 driver, 4 ports, IRQ sharing disabled
[    3.978392] Serial: 8250/16550 driver, 4 ports, IRQ sharing disabled
[    4.027726] 00:05: ttyS0 at I/O 0x3f8 (irq =3D 4, base_baud =3D 115200) =
is a 16550A
[    4.027726] 00:05: ttyS0 at I/O 0x3f8 (irq =3D 4, base_baud =3D 115200) =
is a 16550A
[    4.034817] STMicroelectronics ASC driver initialized
[    4.034817] STMicroelectronics ASC driver initialized
[    4.037629] serial: Freescale lpuart driver
[    4.037629] serial: Freescale lpuart driver
[    4.038801] Cyclades driver 2.6
[    4.038801] Cyclades driver 2.6
[    4.044184] MOXA Smartio/Industio family driver version 2.0.5
[    4.044184] MOXA Smartio/Industio family driver version 2.0.5
[    4.045711] Initializing Nozomi driver 2.1d
[    4.045711] Initializing Nozomi driver 2.1d
[    4.046883] RocketPort device driver module, version 2.09, 12-June-2003
[    4.046883] RocketPort device driver module, version 2.09, 12-June-2003
[    4.048460] No rocketport ports found; unloading driver
[    4.048460] No rocketport ports found; unloading driver
[    4.049750] SyncLink GT
[    4.049750] SyncLink GT
[    4.050428] SyncLink GT, tty major#245
[    4.050428] SyncLink GT, tty major#245
[    4.051500] SyncLink GT no devices found
[    4.051500] SyncLink GT no devices found
[    4.052576] SyncLink serial driver $Revision: 4.38 $
[    4.052576] SyncLink serial driver $Revision: 4.38 $
[    4.101777] SyncLink serial driver $Revision: 4.38 $, tty major#244
[    4.101777] SyncLink serial driver $Revision: 4.38 $, tty major#244
[    4.104061] lp: driver loaded but no devices found
[    4.104061] lp: driver loaded but no devices found
[    4.105178] sonypi: Sony Programmable I/O Controller Driver v1.26.
[    4.105178] sonypi: Sony Programmable I/O Controller Driver v1.26.
[    4.106650] toshiba: not a supported Toshiba laptop
[    4.106650] toshiba: not a supported Toshiba laptop
[    4.108751] ppdev: user-space parallel port driver
[    4.108751] ppdev: user-space parallel port driver
[    4.110297] platform pc8736x_gpio.0: NatSemi pc8736x GPIO Driver Initial=
izing
[    4.110297] platform pc8736x_gpio.0: NatSemi pc8736x GPIO Driver Initial=
izing
[    4.112240] platform pc8736x_gpio.0: no device found
[    4.112240] platform pc8736x_gpio.0: no device found
[    4.113674] nsc_gpio initializing
[    4.113674] nsc_gpio initializing
[    4.114511] telclk_interrupt =3D 0xf non-mcpbl0010 hw.
[    4.114511] telclk_interrupt =3D 0xf non-mcpbl0010 hw.
[    4.115794] smapi::smapi_init, ERROR invalid usSmapiID
[    4.115794] smapi::smapi_init, ERROR invalid usSmapiID
[    4.116998] mwave: tp3780i::tp3780I_InitializeBoardData: Error: SMAPI is=
 not available on this machine
[    4.116998] mwave: tp3780i::tp3780I_InitializeBoardData: Error: SMAPI is=
 not available on this machine
[    4.119178] mwave: mwavedd::mwave_init: Error: Failed to initialize boar=
d data
[    4.119178] mwave: mwavedd::mwave_init: Error: Failed to initialize boar=
d data
[    4.122325] mwave: mwavedd::mwave_init: Error: Failed to initialize
[    4.122325] mwave: mwavedd::mwave_init: Error: Failed to initialize
[    4.123841] Linux agpgart interface v0.103
[    4.123841] Linux agpgart interface v0.103
[    4.127170] [drm] Initialized drm 1.1.0 20060810
[    4.127170] [drm] Initialized drm 1.1.0 20060810
[    4.128734] [drm] radeon kernel modesetting enabled.
[    4.128734] [drm] radeon kernel modesetting enabled.
[    4.130483] usbcore: registered new interface driver udl
[    4.130483] usbcore: registered new interface driver udl
[    4.132754] parport_pc 00:04: reported by Plug and Play ACPI
[    4.132754] parport_pc 00:04: reported by Plug and Play ACPI
[    4.134220] parport0: PC-style at 0x378
[    4.134220] parport0: PC-style at 0x378, irq 7, irq 7 [ [PCSPPPCSPP,TRIS=
TATE,TRISTATE]
]
[    4.214199] lp0: using parport0 (interrupt-driven).
[    4.214199] lp0: using parport0 (interrupt-driven).
[    4.215552] lp0: console ready
[    4.215552] lp0: console ready
[    4.220964] HP CISS Driver (v 3.6.26)
[    4.220964] HP CISS Driver (v 3.6.26)
[    4.231346] MM: desc_per_page =3D 128
[    4.231346] MM: desc_per_page =3D 128
[    4.232525] mtip32xx Version 1.3.0
[    4.232525] mtip32xx Version 1.3.0
[    4.237484] blk-mq: CPU -> queue map
[    4.237484] blk-mq: CPU -> queue map
[    4.238354]   CPU 0 -> Queue 0
[    4.238354]   CPU 0 -> Queue 0
[    4.239068]   CPU 1 -> Queue 0
[    4.239068]   CPU 1 -> Queue 0
[    4.241471]  nullb0: unknown partition table
[    4.241471]  nullb0: unknown partition table
[    4.243640] blk-mq: CPU -> queue map
[    4.243640] blk-mq: CPU -> queue map
[    4.244502]   CPU 0 -> Queue 0
[    4.244502]   CPU 0 -> Queue 0
[    4.245268]   CPU 1 -> Queue 0
[    4.245268]   CPU 1 -> Queue 0
[    4.247688]  nullb1: unknown partition table
[    4.247688]  nullb1: unknown partition table
[    4.250065] null: module loaded
[    4.250065] null: module loaded
[    4.251005] ibmasm: IBM ASM Service Processor Driver version 1.0 loaded
[    4.251005] ibmasm: IBM ASM Service Processor Driver version 1.0 loaded
[    4.252865] dummy-irq: no IRQ given.  Use irq=3DN
[    4.252865] dummy-irq: no IRQ given.  Use irq=3DN
[    4.255064] Silicon Labs C2 port support v. 0.51.0 - (C) 2007 Rodolfo Gi=
ometti
[    4.255064] Silicon Labs C2 port support v. 0.51.0 - (C) 2007 Rodolfo Gi=
ometti
[    4.257463] c2port c2port0: C2 port uc added
[    4.257463] c2port c2port0: C2 port uc added
[    4.258483] c2port c2port0: uc flash has 30 blocks x 512 bytes (15360 by=
tes total)
[    4.258483] c2port c2port0: uc flash has 30 blocks x 512 bytes (15360 by=
tes total)
[    4.261341] Guest personality initialized and is inactive
[    4.261341] Guest personality initialized and is inactive
[    4.263054] VMCI host device registered (name=3Dvmci, major=3D10, minor=
=3D58)
[    4.263054] VMCI host device registered (name=3Dvmci, major=3D10, minor=
=3D58)
[    4.264614] Initialized host personality
[    4.264614] Initialized host personality
[    4.267779] usbcore: registered new interface driver viperboard
[    4.267779] usbcore: registered new interface driver viperboard
[    4.269553] usbcore: registered new interface driver pn533
[    4.269553] usbcore: registered new interface driver pn533
[    4.270875] Uniform Multi-Platform E-IDE driver
[    4.270875] Uniform Multi-Platform E-IDE driver
[    4.274129] piix 0000:00:01.1: IDE controller (0x8086:0x7010 rev 0x00)
[    4.274129] piix 0000:00:01.1: IDE controller (0x8086:0x7010 rev 0x00)
[    4.275873] piix 0000:00:01.1: not 100% native mode: will probe irqs lat=
er
[    4.275873] piix 0000:00:01.1: not 100% native mode: will probe irqs lat=
er
[    4.278133]     ide0: BM-DMA at 0xc040-0xc047
[    4.278133]     ide0: BM-DMA at 0xc040-0xc047
[    4.279189]     ide1: BM-DMA at 0xc048-0xc04f
[    4.279189]     ide1: BM-DMA at 0xc048-0xc04f
[    4.280260] Probing IDE interface ide0...
[    4.280260] Probing IDE interface ide0...
[    4.890779] Probing IDE interface ide1...
[    4.890779] Probing IDE interface ide1...
[    5.690116] hdc: QEMU DVD-ROM, ATAPI=20
[    5.690116] hdc: QEMU DVD-ROM, ATAPI CD/DVD-ROMCD/DVD-ROM drive
 drive
[    6.440916] hdc: host max PIO4 wanted PIO255(auto-tune) selected PIO0
[    6.440916] hdc: host max PIO4 wanted PIO255(auto-tune) selected PIO0
[    6.442555] hdc: MWDMA2 mode selected
[    6.442555] hdc: MWDMA2 mode selected
[    6.443650] ide0 at 0x1f0-0x1f7,0x3f6 on irq 14
[    6.443650] ide0 at 0x1f0-0x1f7,0x3f6 on irq 14

[    6.444884] ide1 at 0x170-0x177,0x376 on irq 15
[    6.444884] ide1 at 0x170-0x177,0x376 on irq 15

[    6.448842] ide_generic: please use "probe_mask=3D0x3f" module parameter=
 for probing all legacy ISA IDE ports
[    6.448842] ide_generic: please use "probe_mask=3D0x3f" module parameter=
 for probing all legacy ISA IDE ports
[    6.451131] ide-cd driver 5.00
[    6.451131] ide-cd driver 5.00
[    6.452661] ide-cd: hdc: ATAPI
[    6.452661] ide-cd: hdc: ATAPI 4X 4X DVD-ROM DVD-ROM drive drive, 512kB =
Cache
, 512kB Cache
[    6.454187] cdrom: Uniform CD-ROM driver Revision: 3.20
[    6.454187] cdrom: Uniform CD-ROM driver Revision: 3.20
[    6.464065] SSFDC read-only Flash Translation layer
[    6.464065] SSFDC read-only Flash Translation layer
[    6.465293] L440GX flash mapping: failed to find PIIX4 ISA bridge, canno=
t continue
[    6.465293] L440GX flash mapping: failed to find PIIX4 ISA bridge, canno=
t continue
[    6.467267] platform physmap-flash.0: failed to claim resource 0
[    6.467267] platform physmap-flash.0: failed to claim resource 0
[    6.468708] SBC-GXx flash: IO:0x258-0x259 MEM:0xdc000-0xdffff
[    6.468708] SBC-GXx flash: IO:0x258-0x259 MEM:0xdc000-0xdffff
[    6.471025] Ramix PMC551 PCI Mezzanine Ram Driver. (C) 1999,2000 Nortel =
Networks.
[    6.471025] Ramix PMC551 PCI Mezzanine Ram Driver. (C) 1999,2000 Nortel =
Networks.
[    6.476171] pmc551: not detected
[    6.476171] pmc551: not detected
[    6.479223] ftl_cs: FTL header not found.
[    6.479223] ftl_cs: FTL header not found.
[    6.483494] HSI/SSI char device loaded
[    6.483494] HSI/SSI char device loaded
[    6.484372] slcan: serial line CAN interface driver
[    6.484372] slcan: serial line CAN interface driver
[    6.485475] slcan: 10 dynamic interface channels.
[    6.485475] slcan: 10 dynamic interface channels.
[    6.486558] CAN device driver interface
[    6.486558] CAN device driver interface
[    6.487631] usbcore: registered new interface driver esd_usb2
[    6.487631] usbcore: registered new interface driver esd_usb2
[    6.489137] usbcore: registered new interface driver kvaser_usb
[    6.489137] usbcore: registered new interface driver kvaser_usb
[    6.490709] usbcore: registered new interface driver peak_usb
[    6.490709] usbcore: registered new interface driver peak_usb
[    6.492221] usbcore: registered new interface driver usb_8dev
[    6.492221] usbcore: registered new interface driver usb_8dev
[    6.493707] sja1000 CAN netdevice driver
[    6.493707] sja1000 CAN netdevice driver
[    6.494634] sja1000_isa: insufficient parameters supplied
[    6.494634] sja1000_isa: insufficient parameters supplied
[    6.496834] cc770: CAN netdevice driver
[    6.496834] cc770: CAN netdevice driver
[    6.497750] cc770_isa: insufficient parameters supplied
[    6.497750] cc770_isa: insufficient parameters supplied
[    6.499149] mkiss: AX.25 Multikiss, Hans Albas PE1AYX
[    6.499149] mkiss: AX.25 Multikiss, Hans Albas PE1AYX
[    6.500369] YAM driver version 0.8 by F1OAT/F6FBB
[    6.500369] YAM driver version 0.8 by F1OAT/F6FBB
[    6.508230] AX.25: bpqether driver version 004
[    6.508230] AX.25: bpqether driver version 004
[    6.509305] baycom_ser_fdx: (C) 1996-2000 Thomas Sailer, HB9JNX/AE4WA
[    6.509305] baycom_ser_fdx: version 0.10
[    6.509305] baycom_ser_fdx: (C) 1996-2000 Thomas Sailer, HB9JNX/AE4WA
[    6.509305] baycom_ser_fdx: version 0.10
[    6.518480] hdlcdrv: (C) 1996-2000 Thomas Sailer HB9JNX/AE4WA
[    6.518480] hdlcdrv: (C) 1996-2000 Thomas Sailer HB9JNX/AE4WA
[    6.519801] hdlcdrv: version 0.8
[    6.519801] hdlcdrv: version 0.8
[    6.520567] baycom_ser_hdx: (C) 1996-2000 Thomas Sailer, HB9JNX/AE4WA
[    6.520567] baycom_ser_hdx: version 0.10
[    6.520567] baycom_ser_hdx: (C) 1996-2000 Thomas Sailer, HB9JNX/AE4WA
[    6.520567] baycom_ser_hdx: version 0.10
[    6.529414] baycom_par: (C) 1996-2000 Thomas Sailer, HB9JNX/AE4WA
[    6.529414] baycom_par: version 0.9
[    6.529414] baycom_par: (C) 1996-2000 Thomas Sailer, HB9JNX/AE4WA
[    6.529414] baycom_par: version 0.9
[    6.538226] I2O subsystem v1.325
[    6.538226] I2O subsystem v1.325
[    6.538982] i2o: max drivers =3D 8
[    6.538982] i2o: max drivers =3D 8
[    6.540421] I2O Configuration OSM v1.323
[    6.540421] I2O Configuration OSM v1.323
[    6.541861] I2O Bus Adapter OSM v1.317
[    6.541861] I2O Bus Adapter OSM v1.317
[    6.542892] I2O ProcFS OSM v1.316
[    6.542892] I2O ProcFS OSM v1.316
[    6.544729] usbcore: registered new interface driver hwa-rc
[    6.544729] usbcore: registered new interface driver hwa-rc
[    6.546731] ehci_hcd: USB 2.0 'Enhanced' Host Controller (EHCI) Driver
[    6.546731] ehci_hcd: USB 2.0 'Enhanced' Host Controller (EHCI) Driver
[    6.548279] ehci-pci: EHCI PCI platform driver
[    6.548279] ehci-pci: EHCI PCI platform driver
[    6.549725] ohci_hcd: USB 1.1 'Open' Host Controller (OHCI) Driver
[    6.549725] ohci_hcd: USB 1.1 'Open' Host Controller (OHCI) Driver
[    6.551950] ohci-pci: OHCI PCI platform driver
[    6.551950] ohci-pci: OHCI PCI platform driver
[    6.553217] ohci-platform: OHCI generic platform driver
[    6.553217] ohci-platform: OHCI generic platform driver
[    6.554569] uhci_hcd: USB Universal Host Controller Interface driver
[    6.554569] uhci_hcd: USB Universal Host Controller Interface driver
[    6.557610] driver u132_hcd
[    6.557610] driver u132_hcd
[    6.558722] usbcore: registered new interface driver hwa-hc
[    6.558722] usbcore: registered new interface driver hwa-hc
[    6.560072] fotg210_hcd: FOTG210 Host Controller (EHCI) Driver
[    6.560072] fotg210_hcd: FOTG210 Host Controller (EHCI) Driver
[    6.564083] usbcore: registered new interface driver wusb-cbaf
[    6.564083] usbcore: registered new interface driver wusb-cbaf
[    6.565617] usbcore: registered new interface driver cdc_wdm
[    6.565617] usbcore: registered new interface driver cdc_wdm
[    6.567072] usbcore: registered new interface driver usbtmc
[    6.567072] usbcore: registered new interface driver usbtmc
[    6.568671] usbcore: registered new interface driver usbserial
[    6.568671] usbcore: registered new interface driver usbserial
[    6.570154] usbcore: registered new interface driver usbserial_generic
[    6.570154] usbcore: registered new interface driver usbserial_generic
[    6.571841] usbserial: USB Serial support registered for generic
[    6.571841] usbserial: USB Serial support registered for generic
[    6.573346] usbcore: registered new interface driver ch341
[    6.573346] usbcore: registered new interface driver ch341
[    6.574730] usbserial: USB Serial support registered for ch341-uart
[    6.574730] usbserial: USB Serial support registered for ch341-uart
[    6.576287] usbcore: registered new interface driver cp210x
[    6.576287] usbcore: registered new interface driver cp210x
[    6.577704] usbserial: USB Serial support registered for cp210x
[    6.577704] usbserial: USB Serial support registered for cp210x
[    6.579180] usbcore: registered new interface driver cyberjack
[    6.579180] usbcore: registered new interface driver cyberjack
[    6.580659] usbserial: USB Serial support registered for Reiner SCT Cybe=
rjack USB card reader
[    6.580659] usbserial: USB Serial support registered for Reiner SCT Cybe=
rjack USB card reader
[    6.582704] usbcore: registered new interface driver digi_acceleport
[    6.582704] usbcore: registered new interface driver digi_acceleport
[    6.584282] usbserial: USB Serial support registered for Digi 2 port USB=
 adapter
[    6.584282] usbserial: USB Serial support registered for Digi 2 port USB=
 adapter
[    6.586073] usbserial: USB Serial support registered for Digi 4 port USB=
 adapter
[    6.586073] usbserial: USB Serial support registered for Digi 4 port USB=
 adapter
[    6.587873] usbcore: registered new interface driver empeg
[    6.587873] usbcore: registered new interface driver empeg
[    6.589254] usbserial: USB Serial support registered for empeg
[    6.589254] usbserial: USB Serial support registered for empeg
[    6.590718] usbcore: registered new interface driver ftdi_sio
[    6.590718] usbcore: registered new interface driver ftdi_sio
[    6.592164] usbserial: USB Serial support registered for FTDI USB Serial=
 Device
[    6.592164] usbserial: USB Serial support registered for FTDI USB Serial=
 Device
[    6.593954] usbcore: registered new interface driver garmin_gps
[    6.593954] usbcore: registered new interface driver garmin_gps
[    6.595476] usbserial: USB Serial support registered for Garmin GPS usb/=
tty
[    6.595476] usbserial: USB Serial support registered for Garmin GPS usb/=
tty
[    6.597237] usbcore: registered new interface driver ipaq
[    6.597237] usbcore: registered new interface driver ipaq
[    6.598651] usbserial: USB Serial support registered for PocketPC PDA
[    6.598651] usbserial: USB Serial support registered for PocketPC PDA
[    6.600311] usbcore: registered new interface driver ipw
[    6.600311] usbcore: registered new interface driver ipw
[    6.601714] usbserial: USB Serial support registered for IPWireless conv=
erter
[    6.601714] usbserial: USB Serial support registered for IPWireless conv=
erter
[    6.603533] usbcore: registered new interface driver ir_usb
[    6.603533] usbcore: registered new interface driver ir_usb
[    6.604985] usbserial: USB Serial support registered for IR Dongle
[    6.604985] usbserial: USB Serial support registered for IR Dongle
[    6.606566] usbcore: registered new interface driver iuu_phoenix
[    6.606566] usbcore: registered new interface driver iuu_phoenix
[    6.608123] usbserial: USB Serial support registered for iuu_phoenix
[    6.608123] usbserial: USB Serial support registered for iuu_phoenix
[    6.609742] usbcore: registered new interface driver keyspan_pda
[    6.609742] usbcore: registered new interface driver keyspan_pda
[    6.611304] usbserial: USB Serial support registered for Keyspan PDA
[    6.611304] usbserial: USB Serial support registered for Keyspan PDA
[    6.612941] usbserial: USB Serial support registered for Keyspan PDA - (=
prerenumeration)
[    6.612941] usbserial: USB Serial support registered for Keyspan PDA - (=
prerenumeration)
[    6.614976] usbserial: USB Serial support registered for Xircom / Entreg=
ra PGS - (prerenumeration)
[    6.614976] usbserial: USB Serial support registered for Xircom / Entreg=
ra PGS - (prerenumeration)
[    6.630279] usbcore: registered new interface driver mct_u232
[    6.630279] usbcore: registered new interface driver mct_u232
[    6.631719] usbserial: USB Serial support registered for MCT U232
[    6.631719] usbserial: USB Serial support registered for MCT U232
[    6.633232] usbcore: registered new interface driver mos7720
[    6.633232] usbcore: registered new interface driver mos7720
[    6.634655] usbserial: USB Serial support registered for Moschip 2 port =
adapter
[    6.634655] usbserial: USB Serial support registered for Moschip 2 port =
adapter
[    6.636657] usbcore: registered new interface driver mos7840
[    6.636657] usbcore: registered new interface driver mos7840
[    6.638281] usbserial: USB Serial support registered for Moschip 7840/78=
20 USB Serial Driver
[    6.638281] usbserial: USB Serial support registered for Moschip 7840/78=
20 USB Serial Driver
[    6.640852] usbcore: registered new interface driver mxuport
[    6.640852] usbcore: registered new interface driver mxuport
[    6.642383] usbserial: USB Serial support registered for MOXA UPort
[    6.642383] usbserial: USB Serial support registered for MOXA UPort
[    6.644017] usbcore: registered new interface driver omninet
[    6.644017] usbcore: registered new interface driver omninet
[    6.645551] usbserial: USB Serial support registered for ZyXEL - omni.ne=
t lcd plus usb
[    6.645551] usbserial: USB Serial support registered for ZyXEL - omni.ne=
t lcd plus usb
[    6.647665] usbcore: registered new interface driver option
[    6.647665] usbcore: registered new interface driver option
[    6.649146] usbserial: USB Serial support registered for GSM modem (1-po=
rt)
[    6.649146] usbserial: USB Serial support registered for GSM modem (1-po=
rt)
[    6.650927] usbcore: registered new interface driver oti6858
[    6.650927] usbcore: registered new interface driver oti6858
[    6.652396] usbserial: USB Serial support registered for oti6858
[    6.652396] usbserial: USB Serial support registered for oti6858
[    6.653931] usbcore: registered new interface driver pl2303
[    6.653931] usbcore: registered new interface driver pl2303
[    6.655388] usbserial: USB Serial support registered for pl2303
[    6.655388] usbserial: USB Serial support registered for pl2303
[    6.656890] usbcore: registered new interface driver qcaux
[    6.656890] usbcore: registered new interface driver qcaux
[    6.658318] usbserial: USB Serial support registered for qcaux
[    6.658318] usbserial: USB Serial support registered for qcaux
[    6.659817] usbcore: registered new interface driver qcserial
[    6.659817] usbcore: registered new interface driver qcserial
[    6.661338] usbserial: USB Serial support registered for Qualcomm USB mo=
dem
[    6.661338] usbserial: USB Serial support registered for Qualcomm USB mo=
dem
[    6.663310] usbcore: registered new interface driver quatech2
[    6.663310] usbcore: registered new interface driver quatech2
[    6.664970] usbserial: USB Serial support registered for Quatech 2nd gen=
 USB to Serial Driver
[    6.664970] usbserial: USB Serial support registered for Quatech 2nd gen=
 USB to Serial Driver
[    6.667424] usbcore: registered new interface driver sierra
[    6.667424] usbcore: registered new interface driver sierra
[    6.669049] usbserial: USB Serial support registered for Sierra USB modem
[    6.669049] usbserial: USB Serial support registered for Sierra USB modem
[    6.670989] usbcore: registered new interface driver spcp8x5
[    6.670989] usbcore: registered new interface driver spcp8x5
[    6.672736] usbserial: USB Serial support registered for SPCP8x5
[    6.672736] usbserial: USB Serial support registered for SPCP8x5
[    6.674483] usbcore: registered new interface driver ssu100
[    6.674483] usbcore: registered new interface driver ssu100
[    6.675928] usbserial: USB Serial support registered for Quatech SSU-100=
 USB to Serial Driver
[    6.675928] usbserial: USB Serial support registered for Quatech SSU-100=
 USB to Serial Driver
[    6.678077] usbcore: registered new interface driver ti_usb_3410_5052
[    6.678077] usbcore: registered new interface driver ti_usb_3410_5052
[    6.679721] usbserial: USB Serial support registered for TI USB 3410 1 p=
ort adapter
[    6.679721] usbserial: USB Serial support registered for TI USB 3410 1 p=
ort adapter
[    6.681675] usbserial: USB Serial support registered for TI USB 5052 2 p=
ort adapter
[    6.681675] usbserial: USB Serial support registered for TI USB 5052 2 p=
ort adapter
[    6.683599] usbcore: registered new interface driver whiteheat
[    6.683599] usbcore: registered new interface driver whiteheat
[    6.685108] usbserial: USB Serial support registered for Connect Tech - =
WhiteHEAT - (prerenumeration)
[    6.685108] usbserial: USB Serial support registered for Connect Tech - =
WhiteHEAT - (prerenumeration)
[    6.687396] usbserial: USB Serial support registered for Connect Tech - =
WhiteHEAT
[    6.687396] usbserial: USB Serial support registered for Connect Tech - =
WhiteHEAT
[    6.689437] usbcore: registered new interface driver xsens_mt
[    6.689437] usbcore: registered new interface driver xsens_mt
[    6.691056] usbserial: USB Serial support registered for xsens_mt
[    6.691056] usbserial: USB Serial support registered for xsens_mt
[    6.692735] usbcore: registered new interface driver zte_ev
[    6.692735] usbcore: registered new interface driver zte_ev
[    6.694569] usbserial: USB Serial support registered for zte_ev
[    6.694569] usbserial: USB Serial support registered for zte_ev
[    6.696244] usbcore: registered new interface driver adutux
[    6.696244] usbcore: registered new interface driver adutux
[    6.698003] usbcore: registered new interface driver appledisplay
[    6.698003] usbcore: registered new interface driver appledisplay
[    6.699739] usbcore: registered new interface driver cypress_cy7c63
[    6.699739] usbcore: registered new interface driver cypress_cy7c63
[    6.701584] usbcore: registered new interface driver cytherm
[    6.701584] usbcore: registered new interface driver cytherm
[    6.703266] usbcore: registered new interface driver emi26 - firmware lo=
ader
[    6.703266] usbcore: registered new interface driver emi26 - firmware lo=
ader
[    6.705262] usbcore: registered new interface driver emi62 - firmware lo=
ader
[    6.705262] usbcore: registered new interface driver emi62 - firmware lo=
ader
[    6.707077] driver ftdi-elan
[    6.707077] driver ftdi-elan
[    6.708367] usbcore: registered new interface driver ftdi-elan
[    6.708367] usbcore: registered new interface driver ftdi-elan
[    6.710312] usbcore: registered new interface driver isight_firmware
[    6.710312] usbcore: registered new interface driver isight_firmware
[    6.712157] usbcore: registered new interface driver usblcd
[    6.712157] usbcore: registered new interface driver usblcd
[    6.713648] usbcore: registered new interface driver ldusb
[    6.713648] usbcore: registered new interface driver ldusb
[    6.715471] usbcore: registered new interface driver usbled
[    6.715471] usbcore: registered new interface driver usbled
[    6.716957] usbcore: registered new interface driver legousbtower
[    6.716957] usbcore: registered new interface driver legousbtower
[    6.718584] usbcore: registered new interface driver rio500
[    6.718584] usbcore: registered new interface driver rio500
[    6.720134] usbcore: registered new interface driver usbtest
[    6.720134] usbcore: registered new interface driver usbtest
[    6.721648] usbcore: registered new interface driver usb_ehset_test
[    6.721648] usbcore: registered new interface driver usb_ehset_test
[    6.723446] usbcore: registered new interface driver usbsevseg
[    6.723446] usbcore: registered new interface driver usbsevseg
[    6.725076] usbcore: registered new interface driver yurex
[    6.725076] usbcore: registered new interface driver yurex
[    6.727160] usbcore: registered new interface driver sisusb
[    6.727160] usbcore: registered new interface driver sisusb
[    6.730505] dummy_hcd dummy_hcd.0: USB Host+Gadget Emulator, driver 02 M=
ay 2005
[    6.730505] dummy_hcd dummy_hcd.0: USB Host+Gadget Emulator, driver 02 M=
ay 2005
[    6.732409] dummy_hcd dummy_hcd.0: Dummy host controller
[    6.732409] dummy_hcd dummy_hcd.0: Dummy host controller
[    6.734584] dummy_hcd dummy_hcd.0: new USB bus registered, assigned bus =
number 1
[    6.734584] dummy_hcd dummy_hcd.0: new USB bus registered, assigned bus =
number 1
[    6.739002] hub 1-0:1.0: USB hub found
[    6.739002] hub 1-0:1.0: USB hub found
[    6.740140] hub 1-0:1.0: 1 port detected
[    6.740140] hub 1-0:1.0: 1 port detected
[    6.745190] userial_init: registered 4 ttyGS* devices
[    6.745190] userial_init: registered 4 ttyGS* devices
[    6.746725] udc dummy_udc.0: registering UDC driver [g_nokia]
[    6.746725] udc dummy_udc.0: registering UDC driver [g_nokia]
[    6.749827] using random self ethernet address
[    6.749827] using random self ethernet address
[    6.750956] using random host ethernet address
[    6.750956] using random host ethernet address
[    6.752032] g_nokia gadget: adding config #1 'Bus Powered'/8216292c
[    6.752032] g_nokia gadget: adding config #1 'Bus Powered'/8216292c
[    6.753672] g_nokia gadget: adding 'phonet'/932c5290 to config 'Bus Powe=
red'/8216292c
[    6.753672] g_nokia gadget: adding 'phonet'/932c5290 to config 'Bus Powe=
red'/8216292c
[    6.757724] g_nokia gadget: USB CDC Phonet function
[    6.757724] g_nokia gadget: USB CDC Phonet function
[    6.758983] g_nokia gadget: using dummy_udc, OUT ep2out-bulk, IN ep1in-b=
ulk
[    6.758983] g_nokia gadget: using dummy_udc, OUT ep2out-bulk, IN ep1in-b=
ulk
[    6.760789] g_nokia gadget: adding 'obex'/9332e5f0 to config 'Bus Powere=
d'/8216292c
[    6.760789] g_nokia gadget: adding 'obex'/9332e5f0 to config 'Bus Powere=
d'/8216292c
[    6.762788] g_nokia gadget: obex ttyGS0: dual speed IN/ep6in-bulk OUT/ep=
7out-bulk
[    6.762788] g_nokia gadget: obex ttyGS0: dual speed IN/ep6in-bulk OUT/ep=
7out-bulk
[    6.764744] g_nokia gadget: adding 'obex'/93337000 to config 'Bus Powere=
d'/8216292c
[    6.764744] g_nokia gadget: adding 'obex'/93337000 to config 'Bus Powere=
d'/8216292c
[    6.766769] g_nokia gadget: obex ttyGS1: dual speed IN/ep11in-bulk OUT/e=
p12out-bulk
[    6.766769] g_nokia gadget: obex ttyGS1: dual speed IN/ep11in-bulk OUT/e=
p12out-bulk
[    6.768784] g_nokia gadget: adding 'acm'/93300a10 to config 'Bus Powered=
'/8216292c
[    6.768784] g_nokia gadget: adding 'acm'/93300a10 to config 'Bus Powered=
'/8216292c
[    6.770708] g_nokia gadget: acm ttyGS2: super speed IN/ep2in-bulk OUT/ep=
1out-bulk NOTIFY/ep5in-int
[    6.770708] g_nokia gadget: acm ttyGS2: super speed IN/ep2in-bulk OUT/ep=
1out-bulk NOTIFY/ep5in-int
[    6.773081] g_nokia gadget: adding 'cdc_ethernet'/93301420 to config 'Bu=
s Powered'/8216292c
[    6.773081] g_nokia gadget: adding 'cdc_ethernet'/93301420 to config 'Bu=
s Powered'/8216292c
[    6.776847] usb0: HOST MAC 9a:dd:76:35:45:5e
[    6.776847] usb0: HOST MAC 9a:dd:76:35:45:5e
[    6.778079] usb0: MAC 6e:48:38:3b:ed:b5
[    6.778079] usb0: MAC 6e:48:38:3b:ed:b5
[    6.779046] g_nokia gadget: CDC Ethernet: super speed IN/ep4in OUT/ep3ou=
t NOTIFY/ep10in-int
[    6.779046] g_nokia gadget: CDC Ethernet: super speed IN/ep4in OUT/ep3ou=
t NOTIFY/ep10in-int
[    6.781282] g_nokia gadget: cfg 1/8216292c speeds: super high full
[    6.781282] g_nokia gadget: cfg 1/8216292c speeds: super high full
[    6.782988] g_nokia gadget:   interface 0 =3D phonet/932c5290
[    6.782988] g_nokia gadget:   interface 0 =3D phonet/932c5290
[    6.784501] g_nokia gadget:   interface 1 =3D phonet/932c5290
[    6.784501] g_nokia gadget:   interface 1 =3D phonet/932c5290
[    6.786037] g_nokia gadget:   interface 2 =3D obex/9332e5f0
[    6.786037] g_nokia gadget:   interface 2 =3D obex/9332e5f0
[    6.787427] g_nokia gadget:   interface 3 =3D obex/9332e5f0
[    6.787427] g_nokia gadget:   interface 3 =3D obex/9332e5f0
[    6.788738] g_nokia gadget:   interface 4 =3D obex/93337000
[    6.788738] g_nokia gadget:   interface 4 =3D obex/93337000
[    6.790071] g_nokia gadget:   interface 5 =3D obex/93337000
[    6.790071] g_nokia gadget:   interface 5 =3D obex/93337000
[    6.791407] g_nokia gadget:   interface 6 =3D acm/93300a10
[    6.791407] g_nokia gadget:   interface 6 =3D acm/93300a10
[    6.792762] g_nokia gadget:   interface 7 =3D acm/93300a10
[    6.792762] g_nokia gadget:   interface 7 =3D acm/93300a10
[    6.794062] g_nokia gadget:   interface 8 =3D cdc_ethernet/93301420
[    6.794062] g_nokia gadget:   interface 8 =3D cdc_ethernet/93301420
[    6.795610] g_nokia gadget:   interface 9 =3D cdc_ethernet/93301420
[    6.795610] g_nokia gadget:   interface 9 =3D cdc_ethernet/93301420
[    6.797135] g_nokia gadget: adding config #2 'Self Powered'/821628b8
[    6.797135] g_nokia gadget: adding config #2 'Self Powered'/821628b8
[    6.799072] g_nokia gadget: adding 'phonet'/932c5440 to config 'Self Pow=
ered'/821628b8
[    6.799072] g_nokia gadget: adding 'phonet'/932c5440 to config 'Self Pow=
ered'/821628b8
[    6.801245] g_nokia gadget: USB CDC Phonet function
[    6.801245] g_nokia gadget: USB CDC Phonet function
[    6.802473] g_nokia gadget: using dummy_udc, OUT ep2out-bulk, IN ep1in-b=
ulk
[    6.802473] g_nokia gadget: using dummy_udc, OUT ep2out-bulk, IN ep1in-b=
ulk
[    6.804239] g_nokia gadget: adding 'obex'/93337ab0 to config 'Self Power=
ed'/821628b8
[    6.804239] g_nokia gadget: adding 'obex'/93337ab0 to config 'Self Power=
ed'/821628b8
[    6.806304] g_nokia gadget: obex ttyGS0: dual speed IN/ep6in-bulk OUT/ep=
7out-bulk
[    6.806304] g_nokia gadget: obex ttyGS0: dual speed IN/ep6in-bulk OUT/ep=
7out-bulk
[    6.808249] g_nokia gadget: adding 'obex'/933374c0 to config 'Self Power=
ed'/821628b8
[    6.808249] g_nokia gadget: adding 'obex'/933374c0 to config 'Self Power=
ed'/821628b8
[    6.810339] g_nokia gadget: obex ttyGS1: dual speed IN/ep11in-bulk OUT/e=
p12out-bulk
[    6.810339] g_nokia gadget: obex ttyGS1: dual speed IN/ep11in-bulk OUT/e=
p12out-bulk
[    6.812301] g_nokia gadget: adding 'acm'/93300cf0 to config 'Self Powere=
d'/821628b8
[    6.812301] g_nokia gadget: adding 'acm'/93300cf0 to config 'Self Powere=
d'/821628b8
[    6.814406] g_nokia gadget: acm ttyGS2: super speed IN/ep2in-bulk OUT/ep=
1out-bulk NOTIFY/ep5in-int
[    6.814406] g_nokia gadget: acm ttyGS2: super speed IN/ep2in-bulk OUT/ep=
1out-bulk NOTIFY/ep5in-int
[    6.816788] g_nokia gadget: adding 'cdc_ethernet'/93301140 to config 'Se=
lf Powered'/821628b8
[    6.816788] g_nokia gadget: adding 'cdc_ethernet'/93301140 to config 'Se=
lf Powered'/821628b8
[    6.818918] g_nokia gadget: CDC Ethernet: super speed IN/ep4in OUT/ep3ou=
t NOTIFY/ep10in-int
[    6.818918] g_nokia gadget: CDC Ethernet: super speed IN/ep4in OUT/ep3ou=
t NOTIFY/ep10in-int
[    6.821028] g_nokia gadget: cfg 2/821628b8 speeds: super high full
[    6.821028] g_nokia gadget: cfg 2/821628b8 speeds: super high full
[    6.822884] g_nokia gadget:   interface 0 =3D phonet/932c5440
[    6.822884] g_nokia gadget:   interface 0 =3D phonet/932c5440
[    6.824282] g_nokia gadget:   interface 1 =3D phonet/932c5440
[    6.824282] g_nokia gadget:   interface 1 =3D phonet/932c5440
[    6.838725] g_nokia gadget:   interface 2 =3D obex/93337ab0
[    6.838725] g_nokia gadget:   interface 2 =3D obex/93337ab0
[    6.840730] usb usb1: dummy_bus_suspend
[    6.840730] usb usb1: dummy_bus_suspend
[    6.841784] g_nokia gadget:   interface 3 =3D obex/93337ab0
[    6.841784] g_nokia gadget:   interface 3 =3D obex/93337ab0
[    6.843123] g_nokia gadget:   interface 4 =3D obex/933374c0
[    6.843123] g_nokia gadget:   interface 4 =3D obex/933374c0
[    6.844506] g_nokia gadget:   interface 5 =3D obex/933374c0
[    6.844506] g_nokia gadget:   interface 5 =3D obex/933374c0
[    6.845823] g_nokia gadget:   interface 6 =3D acm/93300cf0
[    6.845823] g_nokia gadget:   interface 6 =3D acm/93300cf0
[    6.847116] g_nokia gadget:   interface 7 =3D acm/93300cf0
[    6.847116] g_nokia gadget:   interface 7 =3D acm/93300cf0
[    6.848451] g_nokia gadget:   interface 8 =3D cdc_ethernet/93301140
[    6.848451] g_nokia gadget:   interface 8 =3D cdc_ethernet/93301140
[    6.849959] g_nokia gadget:   interface 9 =3D cdc_ethernet/93301140
[    6.849959] g_nokia gadget:   interface 9 =3D cdc_ethernet/93301140
[    6.864625] g_nokia gadget: N900 (PC-Suite Mode)
[    6.864625] g_nokia gadget: N900 (PC-Suite Mode)
[    6.866016] g_nokia gadget: g_nokia ready
[    6.866016] g_nokia gadget: g_nokia ready
[    6.867053] dummy_udc dummy_udc.0: binding gadget driver 'g_nokia'
[    6.867053] dummy_udc dummy_udc.0: binding gadget driver 'g_nokia'
[    6.868655] dummy_hcd dummy_hcd.0: port status 0x00010101 has changes
[    6.868655] dummy_hcd dummy_hcd.0: port status 0x00010101 has changes
[    6.870449] usb usb1: dummy_bus_resume
[    6.870449] usb usb1: dummy_bus_resume
[    6.871520] dummy_hcd dummy_hcd.0: port status 0x00010101 has changes
[    6.871520] dummy_hcd dummy_hcd.0: port status 0x00010101 has changes
[    6.874024] i8042: PNP: PS/2 Controller [PNP0303:KBD,PNP0f13:MOU] at 0x6=
0,0x64 irq 1,12
[    6.874024] i8042: PNP: PS/2 Controller [PNP0303:KBD,PNP0f13:MOU] at 0x6=
0,0x64 irq 1,12
[    6.890311] serio: i8042 KBD port at 0x60,0x64 irq 1
[    6.890311] serio: i8042 KBD port at 0x60,0x64 irq 1
[    6.891973] serio: i8042 AUX port at 0x60,0x64 irq 12
[    6.891973] serio: i8042 AUX port at 0x60,0x64 irq 12
[    6.894301] parport0: cannot grant exclusive access for device parkbd
[    6.894301] parport0: cannot grant exclusive access for device parkbd
[    6.977042] evbug: Connected device: input0 (Power Button at LNXPWRBN/bu=
tton/input0)
[    6.977042] evbug: Connected device: input0 (Power Button at LNXPWRBN/bu=
tton/input0)
[    6.981730] input: AT Translated Set 2 keyboard as /devices/platform/i80=
42/serio0/input/input1
[    6.981730] input: AT Translated Set 2 keyboard as /devices/platform/i80=
42/serio0/input/input1
[    6.984827] evbug: Connected device: input1 (AT Translated Set 2 keyboar=
d at isa0060/serio0/input0)
[    6.984827] evbug: Connected device: input1 (AT Translated Set 2 keyboar=
d at isa0060/serio0/input0)
[    6.988586] usbcore: registered new interface driver appletouch
[    6.988586] usbcore: registered new interface driver appletouch
[    6.990231] usbcore: registered new interface driver bcm5974
[    6.990231] usbcore: registered new interface driver bcm5974
[    6.994726] usbcore: registered new interface driver iforce
[    6.994726] usbcore: registered new interface driver iforce
[    6.997342] usbcore: registered new interface driver xpad
[    6.997342] usbcore: registered new interface driver xpad
[    6.998782] parport0: cannot grant exclusive access for device walkera07=
01
[    6.998782] parport0: cannot grant exclusive access for device walkera07=
01
[    7.000604] walkera0701: failed to register parport device
[    7.000604] walkera0701: failed to register parport device
[    7.004116] mk712: device not present
[    7.004116] mk712: device not present
[    7.005469] usbcore: registered new interface driver sur40
[    7.005469] usbcore: registered new interface driver sur40
[    7.007601] apanel: Fujitsu BIOS signature 'FJKEYINF' not found...
[    7.007601] apanel: Fujitsu BIOS signature 'FJKEYINF' not found...
[    7.009314] cm109: Keymap for Komunikate KIP1000 phone loaded
[    7.009314] cm109: Keymap for Komunikate KIP1000 phone loaded
[    7.011008] usbcore: registered new interface driver cm109
[    7.011008] usbcore: registered new interface driver cm109
[    7.012364] cm109: CM109 phone driver: 20080805 (C) Alfred E. Heggestad
[    7.012364] cm109: CM109 phone driver: 20080805 (C) Alfred E. Heggestad
[    7.014766] usbcore: registered new interface driver keyspan_remote
[    7.014766] usbcore: registered new interface driver keyspan_remote
[    7.017293] input: PC Speaker as /devices/platform/pcspkr/input/input4
[    7.017293] input: PC Speaker as /devices/platform/pcspkr/input/input4
[    7.019335] evbug: Connected device: input4 (PC Speaker at isa0061/input=
0)
[    7.019335] evbug: Connected device: input4 (PC Speaker at isa0061/input=
0)
[    7.021266] wistron_btns: System unknown
[    7.021266] wistron_btns: System unknown
[    7.022324] usbcore: registered new interface driver yealink
[    7.022324] usbcore: registered new interface driver yealink
[    7.023604] ideapad_slidebar: DMI does not match
[    7.023604] ideapad_slidebar: DMI does not match
[    7.028166] i2c /dev entries driver
[    7.028166] i2c /dev entries driver
[    7.030192] piix4_smbus 0000:00:01.3: SMBus Host Controller at 0xb100, r=
evision 0
[    7.030192] piix4_smbus 0000:00:01.3: SMBus Host Controller at 0xb100, r=
evision 0
[    7.034655] i2c-parport-light: adapter type unspecified
[    7.034655] i2c-parport-light: adapter type unspecified
[    7.040083] g_nokia gadget: resume
[    7.040083] g_nokia gadget: resume
[    7.040911] dummy_hcd dummy_hcd.0: port status 0x00100503 has changes
[    7.040911] dummy_hcd dummy_hcd.0: port status 0x00100503 has changes
[    7.042879] b2c2-flexcop: B2C2 FlexcopII/II(b)/III digital TV receiver c=
hip loaded successfully
[    7.042879] b2c2-flexcop: B2C2 FlexcopII/II(b)/III digital TV receiver c=
hip loaded successfully
[    7.045110] usbcore: registered new interface driver ttusb-dec
[    7.045110] usbcore: registered new interface driver ttusb-dec
[    7.046726] usbcore: registered new interface driver ttusb
[    7.046726] usbcore: registered new interface driver ttusb
[    7.048185] usbcore: registered new interface driver dvb_usb_vp7045
[    7.048185] usbcore: registered new interface driver dvb_usb_vp7045
[    7.049810] usbcore: registered new interface driver dvb_usb_gp8psk
[    7.049810] usbcore: registered new interface driver dvb_usb_gp8psk
[    7.051454] usbcore: registered new interface driver dvb_usb_a800
[    7.051454] usbcore: registered new interface driver dvb_usb_a800
[    7.053019] usbcore: registered new interface driver dvb_usb_dibusb_mb
[    7.053019] usbcore: registered new interface driver dvb_usb_dibusb_mb
[    7.054700] usbcore: registered new interface driver dvb_usb_dibusb_mc
[    7.054700] usbcore: registered new interface driver dvb_usb_dibusb_mc
[    7.056374] usbcore: registered new interface driver dvb_usb_umt_010
[    7.056374] usbcore: registered new interface driver dvb_usb_umt_010
[    7.058005] usbcore: registered new interface driver dvb_usb_m920x
[    7.058005] usbcore: registered new interface driver dvb_usb_m920x
[    7.059604] usbcore: registered new interface driver dvb_usb_digitv
[    7.059604] usbcore: registered new interface driver dvb_usb_digitv
[    7.061258] usbcore: registered new interface driver dvb_usb_cxusb
[    7.061258] usbcore: registered new interface driver dvb_usb_cxusb
[    7.062871] usbcore: registered new interface driver dvb_usb_ttusb2
[    7.062871] usbcore: registered new interface driver dvb_usb_ttusb2
[    7.064483] usbcore: registered new interface driver opera1
[    7.064483] usbcore: registered new interface driver opera1
[    7.065909] usbcore: registered new interface driver dvb_usb_af9005
[    7.065909] usbcore: registered new interface driver dvb_usb_af9005
[    7.067491] usbcore: registered new interface driver pctv452e
[    7.067491] usbcore: registered new interface driver pctv452e
[    7.068949] usbcore: registered new interface driver dw2102
[    7.068949] usbcore: registered new interface driver dw2102
[    7.070386] usbcore: registered new interface driver dvb_usb_dtv5100
[    7.070386] usbcore: registered new interface driver dvb_usb_dtv5100
[    7.071985] usbcore: registered new interface driver cinergyT2
[    7.071985] usbcore: registered new interface driver cinergyT2
[    7.073493] usbcore: registered new interface driver dvb_usb_friio
[    7.073493] usbcore: registered new interface driver dvb_usb_friio
[    7.075780] usbcore: registered new interface driver dvb_usb_technisat_u=
sb2
[    7.075780] usbcore: registered new interface driver dvb_usb_technisat_u=
sb2
[    7.077531] usbcore: registered new interface driver dvb_usb_anysee
[    7.077531] usbcore: registered new interface driver dvb_usb_anysee
[    7.079115] usbcore: registered new interface driver dvb_usb_au6610
[    7.079115] usbcore: registered new interface driver dvb_usb_au6610
[    7.080741] usbcore: registered new interface driver dvb_usb_az6007
[    7.080741] usbcore: registered new interface driver dvb_usb_az6007
[    7.082343] usbcore: registered new interface driver dvb_usb_ec168
[    7.082343] usbcore: registered new interface driver dvb_usb_ec168
[    7.083919] usbcore: registered new interface driver dvb_usb_gl861
[    7.083919] usbcore: registered new interface driver dvb_usb_gl861
[    7.085500] usbcore: registered new interface driver dvb_usb_mxl111sf
[    7.085500] usbcore: registered new interface driver dvb_usb_mxl111sf
[    7.087134] usbcore: registered new interface driver dvb_usb_rtl28xxu
[    7.087134] usbcore: registered new interface driver dvb_usb_rtl28xxu
[    7.088809] usbcore: registered new interface driver smsusb
[    7.088809] usbcore: registered new interface driver smsusb
[    7.090285] usbcore: registered new interface driver b2c2_flexcop_usb
[    7.090285] usbcore: registered new interface driver b2c2_flexcop_usb
[    7.092240] au0828 driver loaded
[    7.092240] au0828 driver loaded
[    7.093161] usbcore: registered new interface driver au0828
[    7.093161] usbcore: registered new interface driver au0828
[    7.094610] usbcore: registered new interface driver hdpvr
[    7.094610] usbcore: registered new interface driver hdpvr
[    7.100113] usb 1-1: new high-speed USB device number 2 using dummy_hcd
[    7.100113] usb 1-1: new high-speed USB device number 2 using dummy_hcd
[    7.101860] usbcore: registered new interface driver pvrusb2
[    7.101860] usbcore: registered new interface driver pvrusb2
[    7.103156] pvrusb2: V4L in-tree version:Hauppauge WinTV-PVR-USB2 MPEG2 =
Encoder/Tuner
[    7.103156] pvrusb2: V4L in-tree version:Hauppauge WinTV-PVR-USB2 MPEG2 =
Encoder/Tuner
[    7.104921] pvrusb2: Debug mask is 31 (0x1f)
[    7.104921] pvrusb2: Debug mask is 31 (0x1f)
[    7.106042] usbcore: registered new interface driver usbvision
[    7.106042] usbcore: registered new interface driver usbvision
[    7.107371] USBVision USB Video Device Driver for Linux : 0.9.11
[    7.107371] USBVision USB Video Device Driver for Linux : 0.9.11
[    7.108877] usbcore: registered new interface driver stk1160
[    7.108877] usbcore: registered new interface driver stk1160
[    7.110523] usbcore: registered new interface driver cx231xx
[    7.110523] usbcore: registered new interface driver cx231xx
[    7.111837] cx231xx: Cx231xx dvb Extension initialized
[    7.111837] cx231xx: Cx231xx dvb Extension initialized
[    7.113002] smssdio: Siano SMS1xxx SDIO driver
[    7.113002] smssdio: Siano SMS1xxx SDIO driver
[    7.114008] smssdio: Copyright Pierre Ossman
[    7.114008] smssdio: Copyright Pierre Ossman
[    7.115241] usbcore: registered new interface driver dsbr100
[    7.115241] usbcore: registered new interface driver dsbr100
[    7.116912] usbcore: registered new interface driver radio-ma901
[    7.116912] usbcore: registered new interface driver radio-ma901
[    7.119116] Driver for 1-wire Dallas network protocol.
[    7.119116] Driver for 1-wire Dallas network protocol.
[    7.121002] usbcore: registered new interface driver DS9490R
[    7.121002] usbcore: registered new interface driver DS9490R
[    7.122465] DS1WM w1 busmaster driver - (c) 2004 Szabolcs Gyurko
[    7.122465] DS1WM w1 busmaster driver - (c) 2004 Szabolcs Gyurko
[    7.124136] 1-Wire driver for the DS2760 battery monitor  chip  - (c) 20=
04-2005, Szabolcs Gyurko
[    7.124136] 1-Wire driver for the DS2760 battery monitor  chip  - (c) 20=
04-2005, Szabolcs Gyurko
[    7.126712] power_supply test_ac: uevent
[    7.126712] power_supply test_ac: uevent
[    7.127647] power_supply test_ac: POWER_SUPPLY_NAME=3Dtest_ac
[    7.127647] power_supply test_ac: POWER_SUPPLY_NAME=3Dtest_ac
[    7.128958] power_supply test_ac: prop ONLINE=3D1
[    7.128958] power_supply test_ac: prop ONLINE=3D1
[    7.130098] power_supply test_ac: power_supply_changed
[    7.130098] power_supply test_ac: power_supply_changed
[    7.131365] power_supply test_ac: power_supply_changed_work
[    7.131365] power_supply test_ac: power_supply_changed_work
[    7.132691] power_supply test_ac: power_supply_update_gen_leds 1
[    7.132691] power_supply test_ac: power_supply_update_gen_leds 1
[    7.134148] power_supply test_ac: uevent
[    7.134148] power_supply test_ac: uevent
[    7.135069] power_supply test_ac: POWER_SUPPLY_NAME=3Dtest_ac
[    7.135069] power_supply test_ac: POWER_SUPPLY_NAME=3Dtest_ac
[    7.136378] power_supply test_ac: prop ONLINE=3D1
[    7.136378] power_supply test_ac: prop ONLINE=3D1
[    7.138014] power_supply test_battery: uevent
[    7.138014] power_supply test_battery: uevent
[    7.139044] power_supply test_battery: POWER_SUPPLY_NAME=3Dtest_battery
[    7.139044] power_supply test_battery: POWER_SUPPLY_NAME=3Dtest_battery
[    7.140582] power_supply test_battery: prop STATUS=3DDischarging
[    7.140582] power_supply test_battery: prop STATUS=3DDischarging
[    7.141959] power_supply test_battery: prop CHARGE_TYPE=3DFast
[    7.141959] power_supply test_battery: prop CHARGE_TYPE=3DFast
[    7.143422] power_supply test_battery: prop HEALTH=3DGood
[    7.143422] power_supply test_battery: prop HEALTH=3DGood
[    7.144658] power_supply test_battery: prop PRESENT=3D1
[    7.144658] power_supply test_battery: prop PRESENT=3D1
[    7.145847] power_supply test_battery: prop TECHNOLOGY=3DLi-ion
[    7.145847] power_supply test_battery: prop TECHNOLOGY=3DLi-ion
[    7.147189] power_supply test_battery: prop CHARGE_FULL_DESIGN=3D100
[    7.147189] power_supply test_battery: prop CHARGE_FULL_DESIGN=3D100
[    7.148593] power_supply test_battery: prop CHARGE_FULL=3D100
[    7.148593] power_supply test_battery: prop CHARGE_FULL=3D100
[    7.149857] power_supply test_battery: prop CHARGE_NOW=3D50
[    7.149857] power_supply test_battery: prop CHARGE_NOW=3D50
[    7.151109] power_supply test_battery: prop CAPACITY=3D50
[    7.151109] power_supply test_battery: prop CAPACITY=3D50
[    7.152314] power_supply test_battery: prop CAPACITY_LEVEL=3DNormal
[    7.152314] power_supply test_battery: prop CAPACITY_LEVEL=3DNormal
[    7.153696] power_supply test_battery: prop TIME_TO_EMPTY_AVG=3D3600
[    7.153696] power_supply test_battery: prop TIME_TO_EMPTY_AVG=3D3600
[    7.155098] power_supply test_battery: prop TIME_TO_FULL_NOW=3D3600
[    7.155098] power_supply test_battery: prop TIME_TO_FULL_NOW=3D3600
[    7.157861] power_supply test_battery: prop MODEL_NAME=3DTest battery
[    7.157861] power_supply test_battery: prop MODEL_NAME=3DTest battery
[    7.159301] power_supply test_battery: prop MANUFACTURER=3DLinux
[    7.159301] power_supply test_battery: prop MANUFACTURER=3DLinux
[    7.160655] power_supply test_battery: prop SERIAL_NUMBER=3D3.14.0-rc8-0=
0007-g60e833d
[    7.160655] power_supply test_battery: prop SERIAL_NUMBER=3D3.14.0-rc8-0=
0007-g60e833d
[    7.162438] power_supply test_battery: prop TEMP=3D26
[    7.162438] power_supply test_battery: prop TEMP=3D26
[    7.163558] power_supply test_battery: prop VOLTAGE_NOW=3D3300
[    7.163558] power_supply test_battery: prop VOLTAGE_NOW=3D3300
[    7.165784] power_supply test_battery: power_supply_changed
[    7.165784] power_supply test_battery: power_supply_changed
[    7.167082] power_supply test_battery: power_supply_changed_work
[    7.167082] power_supply test_battery: power_supply_changed_work
[    7.168468] power_supply test_battery: power_supply_update_bat_leds 2
[    7.168468] power_supply test_battery: power_supply_update_bat_leds 2
[    7.169936] power_supply test_battery: uevent
[    7.169936] power_supply test_battery: uevent
[    7.171000] g_nokia gadget: resume
[    7.171000] g_nokia gadget: resume
[    7.171813] dummy_hcd dummy_hcd.0: port status 0x00100503 has changes
[    7.171813] dummy_hcd dummy_hcd.0: port status 0x00100503 has changes
[    7.173824] power_supply test_battery: POWER_SUPPLY_NAME=3Dtest_battery
[    7.173824] power_supply test_battery: POWER_SUPPLY_NAME=3Dtest_battery
[    7.175356] power_supply test_battery: prop STATUS=3DDischarging
[    7.175356] power_supply test_battery: prop STATUS=3DDischarging
[    7.176736] power_supply test_battery: prop CHARGE_TYPE=3DFast
[    7.176736] power_supply test_battery: prop CHARGE_TYPE=3DFast
[    7.178080] power_supply test_battery: prop HEALTH=3DGood
[    7.178080] power_supply test_battery: prop HEALTH=3DGood
[    7.179328] power_supply test_battery: prop PRESENT=3D1
[    7.179328] power_supply test_battery: prop PRESENT=3D1
[    7.180822] power_supply test_usb: uevent
[    7.180822] power_supply test_usb: uevent
[    7.181779] power_supply test_usb: POWER_SUPPLY_NAME=3Dtest_usb
[    7.181779] power_supply test_usb: POWER_SUPPLY_NAME=3Dtest_usb
[    7.183122] power_supply test_usb: prop ONLINE=3D1
[    7.183122] power_supply test_usb: prop ONLINE=3D1
[    7.184247] power_supply test_usb: power_supply_changed
[    7.184247] power_supply test_usb: power_supply_changed
[    7.188048] power_supply test_battery: prop TECHNOLOGY=3DLi-ion
[    7.188048] power_supply test_battery: prop TECHNOLOGY=3DLi-ion
[    7.189423] power_supply test_battery: prop CHARGE_FULL_DESIGN=3D100
[    7.189423] power_supply test_battery: prop CHARGE_FULL_DESIGN=3D100
[    7.190898] power_supply test_battery: prop CHARGE_FULL=3D100
[    7.190898] power_supply test_battery: prop CHARGE_FULL=3D100
[    7.192225] power_supply test_battery: prop CHARGE_NOW=3D50
[    7.192225] power_supply test_battery: prop CHARGE_NOW=3D50
[    7.193500] power_supply test_battery: prop CAPACITY=3D50
[    7.193500] power_supply test_battery: prop CAPACITY=3D50
[    7.194737] power_supply test_battery: prop CAPACITY_LEVEL=3DNormal
[    7.194737] power_supply test_battery: prop CAPACITY_LEVEL=3DNormal
[    7.196170] power_supply test_battery: prop TIME_TO_EMPTY_AVG=3D3600
[    7.196170] power_supply test_battery: prop TIME_TO_EMPTY_AVG=3D3600
[    7.197601] power_supply test_battery: prop TIME_TO_FULL_NOW=3D3600
[    7.197601] power_supply test_battery: prop TIME_TO_FULL_NOW=3D3600
[    7.198995] power_supply test_battery: prop MODEL_NAME=3DTest battery
[    7.198995] power_supply test_battery: prop MODEL_NAME=3DTest battery
[    7.200727] power_supply test_battery: prop MANUFACTURER=3DLinux
[    7.200727] power_supply test_battery: prop MANUFACTURER=3DLinux
[    7.202308] power_supply test_battery: prop SERIAL_NUMBER=3D3.14.0-rc8-0=
0007-g60e833d
[    7.202308] power_supply test_battery: prop SERIAL_NUMBER=3D3.14.0-rc8-0=
0007-g60e833d
[    7.204116] power_supply test_battery: prop TEMP=3D26
[    7.204116] power_supply test_battery: prop TEMP=3D26
[    7.205328] power_supply test_battery: prop VOLTAGE_NOW=3D3300
[    7.205328] power_supply test_battery: prop VOLTAGE_NOW=3D3300
[    7.206893] power_supply test_usb: power_supply_changed_work
[    7.206893] power_supply test_usb: power_supply_changed_work
[    7.208575] power_supply test_usb: power_supply_update_gen_leds 1
[    7.208575] power_supply test_usb: power_supply_update_gen_leds 1
[    7.209968] power_supply test_usb: uevent
[    7.209968] power_supply test_usb: uevent
[    7.210905] power_supply test_usb: POWER_SUPPLY_NAME=3Dtest_usb
[    7.210905] power_supply test_usb: POWER_SUPPLY_NAME=3Dtest_usb
[    7.212231] power_supply test_usb: prop ONLINE=3D1
[    7.212231] power_supply test_usb: prop ONLINE=3D1
[    7.240031] dummy_udc dummy_udc.0: set_address =3D 2
[    7.240031] dummy_udc dummy_udc.0: set_address =3D 2
[    7.360077] usb 1-1: device v0421 p01c8 is not supported
[    7.360077] usb 1-1: device v0421 p01c8 is not supported
[    7.361349] g_nokia gadget: suspend
[    7.361349] g_nokia gadget: suspend
[    7.362437] hub 1-0:1.0: unable to enumerate USB device on port 1
[    7.362437] hub 1-0:1.0: unable to enumerate USB device on port 1
[    7.363988] usb usb1: dummy_bus_suspend
[    7.363988] usb usb1: dummy_bus_suspend
[    7.400452] psmouse serio1: hgpk: ID: 10 00 64
[    7.400452] psmouse serio1: hgpk: ID: 10 00 64
[    7.410071] w83793: Detection failed at check vendor id
[    7.410071] w83793: Detection failed at check vendor id
[    7.470068] w83793: Detection failed at check vendor id
[    7.470068] w83793: Detection failed at check vendor id
[    7.550070] w83793: Detection failed at check vendor id
[    7.550070] w83793: Detection failed at check vendor id
[    7.620074] w83793: Detection failed at check vendor id
[    7.620074] w83793: Detection failed at check vendor id
[    7.670082] i2c i2c-0: Detection of w83781d chip failed at step 3
[    7.670082] i2c i2c-0: Detection of w83781d chip failed at step 3
[    7.714195] i2c i2c-0: Detection of w83781d chip failed at step 3
[    7.714195] i2c i2c-0: Detection of w83781d chip failed at step 3
[    7.750077] i2c i2c-0: Detection of w83781d chip failed at step 3
[    7.750077] i2c i2c-0: Detection of w83781d chip failed at step 3
[    7.790078] i2c i2c-0: Detection of w83781d chip failed at step 3
[    7.790078] i2c i2c-0: Detection of w83781d chip failed at step 3
[    7.860116] input: ImExPS/2 Generic Explorer Mouse as /devices/platform/=
i8042/serio1/input/input3
[    7.860116] input: ImExPS/2 Generic Explorer Mouse as /devices/platform/=
i8042/serio1/input/input3
[    7.862754] evbug: Connected device: input3 (ImExPS/2 Generic Explorer M=
ouse at isa0060/serio1/input0)
[    7.862754] evbug: Connected device: input3 (ImExPS/2 Generic Explorer M=
ouse at isa0060/serio1/input0)
[    7.877933] i2c i2c-0: Detection of w83781d chip failed at step 3
[    7.877933] i2c i2c-0: Detection of w83781d chip failed at step 3
[    7.920074] i2c i2c-0: Detection of w83781d chip failed at step 3
[    7.920074] i2c i2c-0: Detection of w83781d chip failed at step 3
[    7.960076] i2c i2c-0: Detection of w83781d chip failed at step 3
[    7.960076] i2c i2c-0: Detection of w83781d chip failed at step 3
[    8.017192] i2c i2c-0: Detection of w83781d chip failed at step 3
[    8.017192] i2c i2c-0: Detection of w83781d chip failed at step 3
[    8.149150] detect failed, chip not detected!
[    8.149150] detect failed, chip not detected!
[    8.240072] detect failed, chip not detected!
[    8.240072] detect failed, chip not detected!
[    8.350080] detect failed, chip not detected!
[    8.350080] detect failed, chip not detected!
[    8.442142] detect failed, chip not detected!
[    8.442142] detect failed, chip not detected!
[    8.543130] detect failed, chip not detected!
[    8.543130] detect failed, chip not detected!
[    8.636175] detect failed, chip not detected!
[    8.636175] detect failed, chip not detected!
[    8.723108] detect failed, chip not detected!
[    8.723108] detect failed, chip not detected!
[    8.824114] detect failed, chip not detected!
[    8.824114] detect failed, chip not detected!
[    8.928095] detect failed, chip not detected!
[    8.928095] detect failed, chip not detected!
[    8.980078] i2c i2c-0: Detecting device at 0,0x2c with COMPANY: 0xff and=
 VERSTEP: 0xff
[    8.980078] i2c i2c-0: Detecting device at 0,0x2c with COMPANY: 0xff and=
 VERSTEP: 0xff
[    8.981892] i2c i2c-0: Autodetecting device at 0,0x2c...
[    8.981892] i2c i2c-0: Autodetecting device at 0,0x2c...
[    8.983137] i2c i2c-0: Autodetection failed
[    8.983137] i2c i2c-0: Autodetection failed
[    9.050075] i2c i2c-0: Detecting device at 0,0x2d with COMPANY: 0xff and=
 VERSTEP: 0xff
[    9.050075] i2c i2c-0: Detecting device at 0,0x2d with COMPANY: 0xff and=
 VERSTEP: 0xff
[    9.051885] i2c i2c-0: Autodetecting device at 0,0x2d...
[    9.051885] i2c i2c-0: Autodetecting device at 0,0x2d...
[    9.053098] i2c i2c-0: Autodetection failed
[    9.053098] i2c i2c-0: Autodetection failed
[    9.120075] i2c i2c-0: Detecting device at 0,0x2e with COMPANY: 0xff and=
 VERSTEP: 0xff
[    9.120075] i2c i2c-0: Detecting device at 0,0x2e with COMPANY: 0xff and=
 VERSTEP: 0xff
[    9.121874] i2c i2c-0: Autodetecting device at 0,0x2e...
[    9.121874] i2c i2c-0: Autodetecting device at 0,0x2e...
[    9.123082] i2c i2c-0: Autodetection failed
[    9.123082] i2c i2c-0: Autodetection failed
[   10.050079] i2c i2c-0: detect fail: address match, 0x2c
[   10.050079] i2c i2c-0: detect fail: address match, 0x2c
[   10.104034] i2c i2c-0: detect fail: address match, 0x2d
[   10.104034] i2c i2c-0: detect fail: address match, 0x2d
[   10.156030] i2c i2c-0: detect fail: address match, 0x2e
[   10.156030] i2c i2c-0: detect fail: address match, 0x2e
[   10.208028] i2c i2c-0: detect fail: address match, 0x2f
[   10.208028] i2c i2c-0: detect fail: address match, 0x2f
[   10.240073]  (null): Wrong manufacturer ID. Got 255, expected 65
[   10.240073]  (null): Wrong manufacturer ID. Got 255, expected 65
[   10.280070]  (null): Wrong manufacturer ID. Got 255, expected 65
[   10.280070]  (null): Wrong manufacturer ID. Got 255, expected 65
[   10.322019]  (null): Wrong manufacturer ID. Got 255, expected 65
[   10.322019]  (null): Wrong manufacturer ID. Got 255, expected 65
[   11.940067]  (null): Unknown chip type, skipping
[   11.940067]  (null): Unknown chip type, skipping
[   11.980065]  (null): Unknown chip type, skipping
[   11.980065]  (null): Unknown chip type, skipping
[   12.920075] i2c i2c-0: Unsupported chip (man_id=3D0xFF, chip_id=3D0xFF)
[   12.920075] i2c i2c-0: Unsupported chip (man_id=3D0xFF, chip_id=3D0xFF)
[   13.060076] i2c i2c-0: Unsupported chip (man_id=3D0xFF, chip_id=3D0xFF)
[   13.060076] i2c i2c-0: Unsupported chip (man_id=3D0xFF, chip_id=3D0xFF)
[   13.200074] i2c i2c-0: Unsupported chip (man_id=3D0xFF, chip_id=3D0xFF)
[   13.200074] i2c i2c-0: Unsupported chip (man_id=3D0xFF, chip_id=3D0xFF)
[   13.820074] i2c i2c-0: Detecting device at 0x2c with COMPANY: 0xff and V=
ERSTEP: 0xff
[   13.820074] i2c i2c-0: Detecting device at 0x2c with COMPANY: 0xff and V=
ERSTEP: 0xff
[   13.821710] i2c i2c-0: Autodetection failed: unsupported version
[   13.821710] i2c i2c-0: Autodetection failed: unsupported version
[   13.880076] i2c i2c-0: Detecting device at 0x2d with COMPANY: 0xff and V=
ERSTEP: 0xff
[   13.880076] i2c i2c-0: Detecting device at 0x2d with COMPANY: 0xff and V=
ERSTEP: 0xff
[   13.881726] i2c i2c-0: Autodetection failed: unsupported version
[   13.881726] i2c i2c-0: Autodetection failed: unsupported version
[   13.940080] i2c i2c-0: Detecting device at 0x2e with COMPANY: 0xff and V=
ERSTEP: 0xff
[   13.940080] i2c i2c-0: Detecting device at 0x2e with COMPANY: 0xff and V=
ERSTEP: 0xff
[   13.941730] i2c i2c-0: Autodetection failed: unsupported version
[   13.941730] i2c i2c-0: Autodetection failed: unsupported version
[   14.160079] i2c i2c-0: Unsupported chip at 0x18 (man_id=3D0xFF, chip_id=
=3D0xFF)
[   14.160079] i2c i2c-0: Unsupported chip at 0x18 (man_id=3D0xFF, chip_id=
=3D0xFF)
[   14.260080] i2c i2c-0: Unsupported chip at 0x19 (man_id=3D0xFF, chip_id=
=3D0xFF)
[   14.260080] i2c i2c-0: Unsupported chip at 0x19 (man_id=3D0xFF, chip_id=
=3D0xFF)
[   14.360075] i2c i2c-0: Unsupported chip at 0x1a (man_id=3D0xFF, chip_id=
=3D0xFF)
[   14.360075] i2c i2c-0: Unsupported chip at 0x1a (man_id=3D0xFF, chip_id=
=3D0xFF)
[   14.460091] i2c i2c-0: Unsupported chip at 0x29 (man_id=3D0xFF, chip_id=
=3D0xFF)
[   14.460091] i2c i2c-0: Unsupported chip at 0x29 (man_id=3D0xFF, chip_id=
=3D0xFF)
[   14.560086] i2c i2c-0: Unsupported chip at 0x2a (man_id=3D0xFF, chip_id=
=3D0xFF)
[   14.560086] i2c i2c-0: Unsupported chip at 0x2a (man_id=3D0xFF, chip_id=
=3D0xFF)
[   14.660083] i2c i2c-0: Unsupported chip at 0x2b (man_id=3D0xFF, chip_id=
=3D0xFF)
[   14.660083] i2c i2c-0: Unsupported chip at 0x2b (man_id=3D0xFF, chip_id=
=3D0xFF)
[   14.760097] i2c i2c-0: Unsupported chip at 0x48 (man_id=3D0xFF, chip_id=
=3D0xFF)
[   14.760097] i2c i2c-0: Unsupported chip at 0x48 (man_id=3D0xFF, chip_id=
=3D0xFF)
[   14.860083] i2c i2c-0: Unsupported chip at 0x49 (man_id=3D0xFF, chip_id=
=3D0xFF)
[   14.860083] i2c i2c-0: Unsupported chip at 0x49 (man_id=3D0xFF, chip_id=
=3D0xFF)
[   14.960114] i2c i2c-0: Unsupported chip at 0x4a (man_id=3D0xFF, chip_id=
=3D0xFF)
[   14.960114] i2c i2c-0: Unsupported chip at 0x4a (man_id=3D0xFF, chip_id=
=3D0xFF)
[   15.060098] i2c i2c-0: Unsupported chip at 0x4b (man_id=3D0xFF, chip_id=
=3D0xFF)
[   15.060098] i2c i2c-0: Unsupported chip at 0x4b (man_id=3D0xFF, chip_id=
=3D0xFF)
[   15.160089] i2c i2c-0: Unsupported chip at 0x4c (man_id=3D0xFF, chip_id=
=3D0xFF)
[   15.160089] i2c i2c-0: Unsupported chip at 0x4c (man_id=3D0xFF, chip_id=
=3D0xFF)
[   15.260098] i2c i2c-0: Unsupported chip at 0x4d (man_id=3D0xFF, chip_id=
=3D0xFF)
[   15.260098] i2c i2c-0: Unsupported chip at 0x4d (man_id=3D0xFF, chip_id=
=3D0xFF)
[   15.360083] i2c i2c-0: Unsupported chip at 0x4e (man_id=3D0xFF, chip_id=
=3D0xFF)
[   15.360083] i2c i2c-0: Unsupported chip at 0x4e (man_id=3D0xFF, chip_id=
=3D0xFF)
[   15.460086] i2c i2c-0: Unsupported chip at 0x4f (man_id=3D0xFF, chip_id=
=3D0xFF)
[   15.460086] i2c i2c-0: Unsupported chip at 0x4f (man_id=3D0xFF, chip_id=
=3D0xFF)
[   16.060088] i2c i2c-0: detect failed, bad manufacturer id 0xff!
[   16.060088] i2c i2c-0: detect failed, bad manufacturer id 0xff!
[   16.100084] i2c i2c-0: detect failed, bad manufacturer id 0xff!
[   16.100084] i2c i2c-0: detect failed, bad manufacturer id 0xff!
[   16.140092] i2c i2c-0: detect failed, bad manufacturer id 0xff!
[   16.140092] i2c i2c-0: detect failed, bad manufacturer id 0xff!
[   16.540094] i2c i2c-0: MAX1619 detection failed at 0x18
[   16.540094] i2c i2c-0: MAX1619 detection failed at 0x18
[   16.620086] i2c i2c-0: MAX1619 detection failed at 0x19
[   16.620086] i2c i2c-0: MAX1619 detection failed at 0x19
[   16.700079] i2c i2c-0: MAX1619 detection failed at 0x1a
[   16.700079] i2c i2c-0: MAX1619 detection failed at 0x1a
[   16.780088] i2c i2c-0: MAX1619 detection failed at 0x29
[   16.780088] i2c i2c-0: MAX1619 detection failed at 0x29
[   16.860103] i2c i2c-0: MAX1619 detection failed at 0x2a
[   16.860103] i2c i2c-0: MAX1619 detection failed at 0x2a
[   16.940086] i2c i2c-0: MAX1619 detection failed at 0x2b
[   16.940086] i2c i2c-0: MAX1619 detection failed at 0x2b
[   17.020077] i2c i2c-0: MAX1619 detection failed at 0x4c
[   17.020077] i2c i2c-0: MAX1619 detection failed at 0x4c
[   17.100077] i2c i2c-0: MAX1619 detection failed at 0x4d
[   17.100077] i2c i2c-0: MAX1619 detection failed at 0x4d
[   17.180096] i2c i2c-0: MAX1619 detection failed at 0x4e
[   17.180096] i2c i2c-0: MAX1619 detection failed at 0x4e
[   18.060097] i2c i2c-0: amc6821_detect called.
[   18.060097] i2c i2c-0: amc6821_detect called.
[   18.100092] i2c i2c-0: amc6821: detection failed at 0x18.
[   18.100092] i2c i2c-0: amc6821: detection failed at 0x18.
[   18.120082] i2c i2c-0: amc6821_detect called.
[   18.120082] i2c i2c-0: amc6821_detect called.
[   18.160075] i2c i2c-0: amc6821: detection failed at 0x19.
[   18.160075] i2c i2c-0: amc6821: detection failed at 0x19.
[   18.180176] i2c i2c-0: amc6821_detect called.
[   18.180176] i2c i2c-0: amc6821_detect called.
[   18.220090] i2c i2c-0: amc6821: detection failed at 0x1a.
[   18.220090] i2c i2c-0: amc6821: detection failed at 0x1a.
[   18.240091] i2c i2c-0: amc6821_detect called.
[   18.240091] i2c i2c-0: amc6821_detect called.
[   18.280090] i2c i2c-0: amc6821: detection failed at 0x2c.
[   18.280090] i2c i2c-0: amc6821: detection failed at 0x2c.
[   18.300091] i2c i2c-0: amc6821_detect called.
[   18.300091] i2c i2c-0: amc6821_detect called.
[   18.340085] i2c i2c-0: amc6821: detection failed at 0x2d.
[   18.340085] i2c i2c-0: amc6821: detection failed at 0x2d.
[   18.360080] i2c i2c-0: amc6821_detect called.
[   18.360080] i2c i2c-0: amc6821_detect called.
[   18.400214] i2c i2c-0: amc6821: detection failed at 0x2e.
[   18.400214] i2c i2c-0: amc6821: detection failed at 0x2e.
[   18.420079] i2c i2c-0: amc6821_detect called.
[   18.420079] i2c i2c-0: amc6821_detect called.
[   18.460090] i2c i2c-0: amc6821: detection failed at 0x4c.
[   18.460090] i2c i2c-0: amc6821: detection failed at 0x4c.
[   18.480083] i2c i2c-0: amc6821_detect called.
[   18.480083] i2c i2c-0: amc6821_detect called.
[   18.520094] i2c i2c-0: amc6821: detection failed at 0x4d.
[   18.520094] i2c i2c-0: amc6821: detection failed at 0x4d.
[   18.540073] i2c i2c-0: amc6821_detect called.
[   18.540073] i2c i2c-0: amc6821_detect called.
[   18.580082] i2c i2c-0: amc6821: detection failed at 0x4e.
[   18.580082] i2c i2c-0: amc6821: detection failed at 0x4e.
[   18.940095] i2c i2c-0: W83L786NG detection failed at 0x2e
[   18.940095] i2c i2c-0: W83L786NG detection failed at 0x2e
[   18.980098] i2c i2c-0: W83L786NG detection failed at 0x2f
[   18.980098] i2c i2c-0: W83L786NG detection failed at 0x2f
[   18.985463] sdhci: Secure Digital Host Controller Interface driver
[   18.985463] sdhci: Secure Digital Host Controller Interface driver
[   18.987361] sdhci: Copyright(c) Pierre Ossman
[   18.987361] sdhci: Copyright(c) Pierre Ossman
[   18.989537] usbcore: registered new interface driver ushc
[   18.989537] usbcore: registered new interface driver ushc
[   25.078104]  (null): enodev DEV ADDR =3D 0xFF
[   25.078104]  (null): enodev DEV ADDR =3D 0xFF
[   25.079378] ledtrig-cpu: registered to indicate activity on CPUs
[   25.079378] ledtrig-cpu: registered to indicate activity on CPUs
[   25.104152] dcdbas dcdbas: Dell Systems Management Base Driver (version =
5.6.0-3.2)
[   25.104152] dcdbas dcdbas: Dell Systems Management Base Driver (version =
5.6.0-3.2)
[   25.106513] Driver for HIFN 795x crypto accelerator chip has been succes=
sfully registered.
[   25.106513] Driver for HIFN 795x crypto accelerator chip has been succes=
sfully registered.
[   25.125978] usbcore: registered new interface driver usbhid
[   25.125978] usbcore: registered new interface driver usbhid
[   25.140390] usbhid: USB HID core driver
[   25.140390] usbhid: USB HID core driver
[   25.141475] hdaps: supported laptop not found!
[   25.141475] hdaps: supported laptop not found!
[   25.142557] hdaps: driver init failed (ret=3D-19)!
[   25.142557] hdaps: driver init failed (ret=3D-19)!
[   25.144393]  fake-fmc-carrier: mezzanine 0
[   25.144393]  fake-fmc-carrier: mezzanine 0
[   25.145497]       Manufacturer: fake-vendor
[   25.145497]       Manufacturer: fake-vendor
[   25.146524]       Product name: fake-design-for-testing
[   25.146524]       Product name: fake-design-for-testing
[   25.148134] fmc fake-design-for-testing-f001: Driver has no ID: matches =
all
[   25.148134] fmc fake-design-for-testing-f001: Driver has no ID: matches =
all
[   25.149971] fmc_trivial: probe of fake-design-for-testing-f001 failed wi=
th error -95
[   25.149971] fmc_trivial: probe of fake-design-for-testing-f001 failed wi=
th error -95
[   25.165079] fmc fake-design-for-testing-f001: Driver has no ID: matches =
all
[   25.165079] fmc fake-design-for-testing-f001: Driver has no ID: matches =
all
[   25.167165] fmc_write_eeprom fake-design-for-testing-f001: fmc_write_eep=
rom: no busid passed, refusing all cards
[   25.167165] fmc_write_eeprom fake-design-for-testing-f001: fmc_write_eep=
rom: no busid passed, refusing all cards
[   25.172003] drop_monitor: Initializing network drop monitor service
[   25.172003] drop_monitor: Initializing network drop monitor service
[   25.174114] NET: Registered protocol family 26
[   25.174114] NET: Registered protocol family 26
[   25.175439] ipip: IPv4 over IPv4 tunneling driver
[   25.175439] ipip: IPv4 over IPv4 tunneling driver
[   25.191735] gre: GRE over IPv4 demultiplexor driver
[   25.191735] gre: GRE over IPv4 demultiplexor driver
[   25.193174] ip_gre: GRE over IPv4 tunneling driver
[   25.193174] ip_gre: GRE over IPv4 tunneling driver
[   25.198194] IPv4 over IPSec tunneling driver
[   25.198194] IPv4 over IPSec tunneling driver
[   25.201367] TCP: cubic registered
[   25.201367] TCP: cubic registered
[   25.202372] NET: Registered protocol family 17
[   25.202372] NET: Registered protocol family 17
[   25.219200] NET: Registered protocol family 4
[   25.219200] NET: Registered protocol family 4
[   25.246969] NET: Registered protocol family 11
[   25.246969] NET: Registered protocol family 11
[   25.248043] NET: Registered protocol family 3
[   25.248043] NET: Registered protocol family 3
[   25.249026] can: controller area network core (rev 20120528 abi 9)
[   25.249026] can: controller area network core (rev 20120528 abi 9)
[   25.251389] can: failed to create /proc/net/can . CONFIG_PROC_FS missing?
[   25.251389] can: failed to create /proc/net/can . CONFIG_PROC_FS missing?
[   25.252922] NET: Registered protocol family 29
[   25.252922] NET: Registered protocol family 29
[   25.253910] can: broadcast manager protocol (rev 20120528 t)
[   25.253910] can: broadcast manager protocol (rev 20120528 t)
[   25.268233] can: netlink gateway (rev 20130117) max_hops=3D1
[   25.268233] can: netlink gateway (rev 20130117) max_hops=3D1
[   25.270547] l2tp_core: L2TP core driver, V2.0
[   25.270547] l2tp_core: L2TP core driver, V2.0
[   25.271540] l2tp_ip: L2TP IP encapsulation support (L2TPv3)
[   25.271540] l2tp_ip: L2TP IP encapsulation support (L2TPv3)
[   25.273766] l2tp_netlink: L2TP netlink interface
[   25.273766] l2tp_netlink: L2TP netlink interface
[   25.274867] l2tp_eth: L2TP ethernet pseudowire support (L2TPv3)
[   25.274867] l2tp_eth: L2TP ethernet pseudowire support (L2TPv3)
[   25.277213] 8021q: 802.1Q VLAN Support v1.8
[   25.277213] 8021q: 802.1Q VLAN Support v1.8
[   25.280739] sctp: Hash tables configured (established 3276 bind 3640)
[   25.280739] sctp: Hash tables configured (established 3276 bind 3640)
[   25.296362] tipc: Activated (version 2.0.0)
[   25.296362] tipc: Activated (version 2.0.0)
[   25.299428] NET: Registered protocol family 30
[   25.299428] NET: Registered protocol family 30
[   25.302872] tipc: Started in single node mode
[   25.302872] tipc: Started in single node mode
[   25.304115] 9pnet: Installing 9P2000 support
[   25.304115] 9pnet: Installing 9P2000 support
[   25.305276] NET: Registered protocol family 37
[   25.305276] NET: Registered protocol family 37
[   25.321260] NET: Registered protocol family 36
[   25.321260] NET: Registered protocol family 36
[   25.322366] openvswitch: Open vSwitch switching datapath
[   25.322366] openvswitch: Open vSwitch switching datapath
[   25.324905] mpls_gso: MPLS GSO support
[   25.324905] mpls_gso: MPLS GSO support
[   25.328515]=20
[   25.328515] printing PIC contents
[   25.328515]=20
[   25.328515] printing PIC contents
[   25.329661] ... PIC  IMR: ffff
[   25.329661] ... PIC  IMR: ffff
[   25.330011] ... PIC  IRR: 9013
[   25.330011] ... PIC  IRR: 9013
[   25.331319] ... PIC  ISR: 0000
[   25.331319] ... PIC  ISR: 0000
[   25.332046] ... PIC ELCR: 0c00
[   25.332046] ... PIC ELCR: 0c00
[   25.320008] printing local APIC contents on CPU#0/0:
[   25.320008] printing local APIC contents on CPU#0/0:
[   25.320008] ... APIC ID:      00000000 (0)
[   25.320008] ... APIC ID:      00000000 (0)
[   25.320008] ... APIC VERSION: 00050014
[   25.320008] ... APIC VERSION: 00050014
[   25.320008] ... APIC TASKPRI: 00000000 (00)
[   25.320008] ... APIC TASKPRI: 00000000 (00)
[   25.320008] ... APIC PROCPRI: 00000000
[   25.320008] ... APIC PROCPRI: 00000000
[   25.320008] ... APIC LDR: 01000000
[   25.320008] ... APIC LDR: 01000000
[   25.320008] ... APIC DFR: ffffffff
[   25.320008] ... APIC DFR: ffffffff
[   25.320008] ... APIC SPIV: 000001ff
[   25.320008] ... APIC SPIV: 000001ff
[   25.320008] ... APIC ISR field:
[   25.320008] ... APIC ISR field:
[   25.320008] 00000000
[   25.320008] 000000000000000000000000000000000000000000000000000000000000=
000000000000000000000000000000000000000000000000000000000000

[   25.320008] ... APIC TMR field:
[   25.320008] ... APIC TMR field:
[   25.320008] 00000000
[   25.320008] 000000000200000002000000000000000000000000000000000000000000=
000000000000000000000000000000000000000000000000000000000000

[   25.320008] ... APIC IRR field:
[   25.320008] ... APIC IRR field:
[   25.320008] 00000000
[   25.320008] 000000000000000000000000000000000000000000000000000000000000=
000000000000000000000000000000000000000000000000800000008000

[   25.320008] ... APIC ESR: 00000000
[   25.320008] ... APIC ESR: 00000000
[   25.320008] ... APIC ICR: 000408f6
[   25.320008] ... APIC ICR: 000408f6
[   25.320008] ... APIC ICR2: 02000000
[   25.320008] ... APIC ICR2: 02000000
[   25.320008] ... APIC LVTT: 000000ef
[   25.320008] ... APIC LVTT: 000000ef
[   25.320008] ... APIC LVTPC: 00010000
[   25.320008] ... APIC LVTPC: 00010000
[   25.320008] ... APIC LVT0: 00010700
[   25.320008] ... APIC LVT0: 00010700
[   25.320008] ... APIC LVT1: 00000400
[   25.320008] ... APIC LVT1: 00000400
[   25.320008] ... APIC LVTERR: 000000fe
[   25.320008] ... APIC LVTERR: 000000fe
[   25.320008] ... APIC TMICT: 0009866e
[   25.320008] ... APIC TMICT: 0009866e
[   25.320008] ... APIC TMCCT: 00000000
[   25.320008] ... APIC TMCCT: 00000000
[   25.320008] ... APIC TDCR: 00000003
[   25.320008] ... APIC TDCR: 00000003
[   25.320008]=20
[   25.320008]=20
[   25.375786] number of MP IRQ sources: 15.
[   25.375786] number of MP IRQ sources: 15.
[   25.376975] number of IO-APIC #0 registers: 24.
[   25.376975] number of IO-APIC #0 registers: 24.
[   25.378153] testing the IO APIC.......................
[   25.378153] testing the IO APIC.......................
[   25.379509] IO APIC #0......
[   25.379509] IO APIC #0......
[   25.380308] .... register #00: 00000000
[   25.380308] .... register #00: 00000000
[   25.381322] .......    : physical APIC id: 00
[   25.381322] .......    : physical APIC id: 00
[   25.382398] .......    : Delivery Type: 0
[   25.382398] .......    : Delivery Type: 0
[   25.383390] .......    : LTS          : 0
[   25.383390] .......    : LTS          : 0
[   25.384502] .... register #01: 00170011
[   25.384502] .... register #01: 00170011
[   25.385698] .......     : max redirection entries: 17
[   25.385698] .......     : max redirection entries: 17
[   25.386972] .......     : PRQ implemented: 0
[   25.386972] .......     : PRQ implemented: 0
[   25.388180] .......     : IO APIC version: 11
[   25.388180] .......     : IO APIC version: 11
[   25.389454] .... register #02: 00000000
[   25.389454] .... register #02: 00000000
[   25.390439] .......     : arbitration: 00
[   25.390439] .......     : arbitration: 00
[   25.391427] .... IRQ redirection table:
[   25.391427] .... IRQ redirection table:
[   25.392632] 1    0    0   0   0    0    0    00
[   25.392632] 1    0    0   0   0    0    0    00
[   25.394052] 0    0    0   0   0    1    1    31
[   25.394052] 0    0    0   0   0    1    1    31
[   25.395151] 0    0    0   0   0    1    1    30
[   25.395151] 0    0    0   0   0    1    1    30
[   25.396550] 0    0    0   0   0    1    1    33
[   25.396550] 0    0    0   0   0    1    1    33
[   25.397790] 1    0    0   0   0    1    1    34
[   25.397790] 1    0    0   0   0    1    1    34
[   25.398962] 1    1    0   0   0    1    1    35
[   25.398962] 1    1    0   0   0    1    1    35
[   25.400316] 0    0    0   0   0    1    1    36
[   25.400316] 0    0    0   0   0    1    1    36
[   25.401724] 0    0    0   0   0    1    1    37
[   25.401724] 0    0    0   0   0    1    1    37
[   25.403004] 0    0    0   0   0    1    1    38
[   25.403004] 0    0    0   0   0    1    1    38
[   25.404410] 0    1    0   0   0    1    1    39
[   25.404410] 0    1    0   0   0    1    1    39
[   25.405514] 1    1    0   0   0    1    1    3A
[   25.405514] 1    1    0   0   0    1    1    3A
[   25.406623] 1    1    0   0   0    1    1    3B
[   25.406623] 1    1    0   0   0    1    1    3B
[   25.407789] 0    0    0   0   0    1    1    3C
[   25.407789] 0    0    0   0   0    1    1    3C
[   25.409139] 0    0    0   0   0    1    1    3D
[   25.409139] 0    0    0   0   0    1    1    3D
[   25.410539] 0    0    0   0   0    1    1    3E
[   25.410539] 0    0    0   0   0    1    1    3E
[   25.411863] 0    0    0   0   0    1    1    3F
[   25.411863] 0    0    0   0   0    1    1    3F
[   25.413228] 1    0    0   0   0    0    0    00
[   25.413228] 1    0    0   0   0    0    0    00
[   25.414310] 1    0    0   0   0    0    0    00
[   25.414310] 1    0    0   0   0    0    0    00
[   25.415413] 1    0    0   0   0    0    0    00
[   25.415413] 1    0    0   0   0    0    0    00
[   25.416564] 1    0    0   0   0    0    0    00
[   25.416564] 1    0    0   0   0    0    0    00
[   25.417666] 1    0    0   0   0    0    0    00
[   25.417666] 1    0    0   0   0    0    0    00
[   25.418859] 1    0    0   0   0    0    0    00
[   25.418859] 1    0    0   0   0    0    0    00
[   25.420057] 1    0    0   0   0    0    0    00
[   25.420057] 1    0    0   0   0    0    0    00
[   25.421207] 1    0    0   0   0    0    0    00
[   25.421207] 1    0    0   0   0    0    0    00
[   25.422354] IRQ to pin mappings:
[   25.422354] IRQ to pin mappings:
[   25.423141] IRQ0=20
[   25.423141] IRQ0 -> 0:2-> 0:2

[   25.423878] IRQ1=20
[   25.423878] IRQ1 -> 0:1-> 0:1

[   25.424677] IRQ3=20
[   25.424677] IRQ3 -> 0:3-> 0:3

[   25.425467] IRQ4=20
[   25.425467] IRQ4 -> 0:4-> 0:4

[   25.426114] IRQ5=20
[   25.426114] IRQ5 -> 0:5-> 0:5

[   25.426778] IRQ6=20
[   25.426778] IRQ6 -> 0:6-> 0:6

[   25.427422] IRQ7=20
[   25.427422] IRQ7 -> 0:7-> 0:7

[   25.428067] IRQ8=20
[   25.428067] IRQ8 -> 0:8-> 0:8

[   25.428725] IRQ9=20
[   25.428725] IRQ9 -> 0:9-> 0:9

[   25.429402] IRQ10=20
[   25.429402] IRQ10 -> 0:10-> 0:10

[   25.430135] IRQ11=20
[   25.430135] IRQ11 -> 0:11-> 0:11

[   25.430829] IRQ12=20
[   25.430829] IRQ12 -> 0:12-> 0:12

[   25.431550] IRQ13=20
[   25.431550] IRQ13 -> 0:13-> 0:13

[   25.432418] IRQ14=20
[   25.432418] IRQ14 -> 0:14-> 0:14

[   25.433285] IRQ15=20
[   25.433285] IRQ15 -> 0:15-> 0:15

[   25.434143] .................................... done.
[   25.434143] .................................... done.
[   25.435389] Using IPI Shortcut mode
[   25.435389] Using IPI Shortcut mode
[   25.437540] bootconsole [earlyser0] disabled
[   25.437540] bootconsole [earlyser0] disabled
[   25.438853] registered taskstats version 1
[   25.450194] bio: create slab <bio-1> at 1
[   25.460457] Btrfs loaded, debug=3Don, assert=3Don
[   25.462220] RIO: rio_register_scan for mport_id=3D-1
[   25.462865] regulator-dummy: disabling
[   25.473214] register_blkdev: cannot get major 3 for hd
[   25.476040] drivers/rtc/hctosys.c: unable to open rtc device (rtc0)
[   25.505314] Freeing unused kernel memory: 572K (82250000 - 822df000)
[   25.506701] Write protecting the kernel text: 11268k
[   25.507690] Write protecting the kernel read-only data: 5892k
[   25.532710] random: init urandom read with 12 bits of entropy available
[   25.560155] hostname (118) used greatest stack depth: 6740 bytes left
[   25.580788] sh (121) used greatest stack depth: 6472 bytes left
/bin/sh: /proc/self/fd/9: No such file or directory
/bin/sh: /proc/self/fd/9: No such file or directory
/bin/sh: /proc/self/fd/9: No such file or directory
[   85.727803] shutdown (139) used greatest stack depth: 6448 bytes left
[   85.870762] initctl (148) used greatest stack depth: 6244 bytes left
mount: proc has wrong device number or fs type proc not supported
[   87.205808] initctl (171) used greatest stack depth: 6156 bytes left
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
mount: / is busy
 * Will now restart
[   92.893660] Unregister pv shared memory for cpu 1
[   92.894489] Unregister pv shared memory for cpu 0
[   92.898753] reboot: Restarting system
[   92.899197] reboot: machine restart
Elapsed time: 100
qemu-system-x86_64 -cpu kvm64 -enable-kvm -kernel /kernel/i386-randconfig-f=
d1-0408/60e833d86a01ad9d8204a04b8db324106ab50395/vmlinuz-3.14.0-rc8-00007-g=
60e833d -append 'hung_task_panic=3D1 earlyprintk=3DttyS0,115200 debug apic=
=3Ddebug sysrq_always_enabled rcupdate.rcu_cpu_stall_timeout=3D100 panic=3D=
10 softlockup_panic=3D1 nmi_watchdog=3Dpanic  prompt_ramdisk=3D0 console=3D=
ttyS0,115200 console=3Dtty0 vga=3Dnormal  root=3D/dev/ram0 rw link=3D/kerne=
l-tests/run-queue/kvm/i386-randconfig-fd1-0408/linux-devel:devel-f4-i386-20=
1404081359:60e833d86a01ad9d8204a04b8db324106ab50395:bisect-linux5/.vmlinuz-=
60e833d86a01ad9d8204a04b8db324106ab50395-20140410014725-4-lkp-ib03 branch=
=3Dlinux-devel/devel-f4-i386-201404081359 BOOT_IMAGE=3D/kernel/i386-randcon=
fig-fd1-0408/60e833d86a01ad9d8204a04b8db324106ab50395/vmlinuz-3.14.0-rc8-00=
007-g60e833d drbd.minor_count=3D8'  -initrd /kernel-tests/initrd/quantal-co=
re-i386.cgz -m 320 -smp 2 -net nic,vlan=3D1,model=3De1000 -net user,vlan=3D=
1,hostfwd=3Dtcp::6099-:22 -boot order=3Dnc -no-reboot -watchdog i6300esb -r=
tc base=3Dlocaltime -pidfile /dev/shm/kboot/pid-quantal-lkp-ib03-65 -serial=
 file:/dev/shm/kboot/serial-quantal-lkp-ib03-65 -daemonize -display none -m=
onitor null=20

--a8Wt8u1KmwUX3Y2C
Content-Type: application/octet-stream
Content-Disposition: attachment; filename="i386-randconfig-fd1-0408-158b6856256ef0171c2c7db83832b249861e9d3b-WARNING:---at----do_one_initcall+-x-86190.log"
Content-Transfer-Encoding: base64

SEVBRCBpcyBub3cgYXQgMTU4YjY4NS4uLiAwZGF5IGhlYWQgZ3VhcmQgZm9yICdkZXZlbC1m
NC1pMzg2LTIwMTQwNDA4MTM1OScKZ2l0IGNoZWNrb3V0IDQ1NWM2ZmRiZDIxOTE2MWJkMDli
MTE2NWYxMTY5OWQ2ZDczZGUxMWMKbHMgLWEgL2tlcm5lbC10ZXN0cy9ydW4tcXVldWUva3Zt
L2kzODYtcmFuZGNvbmZpZy1mZDEtMDQwOC9saW51eC1kZXZlbDpkZXZlbC1mNC1pMzg2LTIw
MTQwNDA4MTM1OTo0NTVjNmZkYmQyMTkxNjFiZDA5YjExNjVmMTE2OTlkNmQ3M2RlMTFjOmJp
c2VjdC1saW51eDUKCjIwMTQtMDQtMDktMjM6NDA6MjMgNDU1YzZmZGJkMjE5MTYxYmQwOWIx
MTY1ZjExNjk5ZDZkNzNkZTExYyBjb21waWxpbmcKUXVldWVkIGJ1aWxkIHRhc2sgdG8gL2tl
cm5lbC10ZXN0cy9idWlsZC1xdWV1ZS9pMzg2LXJhbmRjb25maWctZmQxLTA0MDgtNDU1YzZm
ZGJkMjE5MTYxYmQwOWIxMTY1ZjExNjk5ZDZkNzNkZTExYwpDaGVjayBmb3Iga2VybmVsIGlu
IC9rZXJuZWwvaTM4Ni1yYW5kY29uZmlnLWZkMS0wNDA4LzQ1NWM2ZmRiZDIxOTE2MWJkMDli
MTE2NWYxMTY5OWQ2ZDczZGUxMWMKd2FpdGluZyBmb3IgY29tcGxldGlvbiBvZiAva2VybmVs
LXRlc3RzL2J1aWxkLXF1ZXVlL2kzODYtcmFuZGNvbmZpZy1mZDEtMDQwOC00NTVjNmZkYmQy
MTkxNjFiZDA5YjExNjVmMTE2OTlkNmQ3M2RlMTFjCndhaXRpbmcgZm9yIGNvbXBsZXRpb24g
b2YgL2tlcm5lbC10ZXN0cy9idWlsZC1xdWV1ZS8uaTM4Ni1yYW5kY29uZmlnLWZkMS0wNDA4
LTQ1NWM2ZmRiZDIxOTE2MWJkMDliMTE2NWYxMTY5OWQ2ZDczZGUxMWMKa2VybmVsOiAva2Vy
bmVsL2kzODYtcmFuZGNvbmZpZy1mZDEtMDQwOC80NTVjNmZkYmQyMTkxNjFiZDA5YjExNjVm
MTE2OTlkNmQ3M2RlMTFjL3ZtbGludXotMy4xNC4wCgoyMDE0LTA0LTEwLTAwOjAzOjIzIGRl
dGVjdGluZyBib290IHN0YXRlIC4uLgkyMQkyMiBTVUNDRVNTCgpiaXNlY3Q6IGdvb2QgY29t
bWl0IDQ1NWM2ZmRiZDIxOTE2MWJkMDliMTE2NWYxMTY5OWQ2ZDczZGUxMWMKZ2l0IGJpc2Vj
dCBzdGFydCAxNThiNjg1NjI1NmVmMDE3MWMyYzdkYjgzODMyYjI0OTg2MWU5ZDNiIDQ1NWM2
ZmRiZDIxOTE2MWJkMDliMTE2NWYxMTY5OWQ2ZDczZGUxMWMgLS0KL2Mva2VybmVsLXRlc3Rz
L2xpbmVhci1iaXNlY3Q6IFsiLWIiLCAiMTU4YjY4NTYyNTZlZjAxNzFjMmM3ZGI4MzgzMmIy
NDk4NjFlOWQzYiIsICItZyIsICI0NTVjNmZkYmQyMTkxNjFiZDA5YjExNjVmMTE2OTlkNmQ3
M2RlMTFjIiwgIi9jL2tlcm5lbC10ZXN0cy9iaXNlY3QtdGVzdC1ib290LWZhaWx1cmUuc2gi
LCAiL2tlcm5lbC10ZXN0cy9saW51eDUvb2JqLWJpc2VjdCJdCkJpc2VjdGluZzogOTk2IHJl
dmlzaW9ucyBsZWZ0IHRvIHRlc3QgYWZ0ZXIgdGhpcyAocm91Z2hseSAxMCBzdGVwcykKWzY0
NmEwYmNjNTRmZWZhMjljMzJmYzAzYmViZGU2ZmY2MTNhMzA0N2JdIE1lcmdlICdkcm0tZXh5
bm9zL2V4eW5vcy1kcm0tbmV4dC10b2RvJyBpbnRvIGRldmVsLWY0LWkzODYtMjAxNDA0MDgx
MzU5CnJ1bm5pbmcgL2Mva2VybmVsLXRlc3RzL2Jpc2VjdC10ZXN0LWJvb3QtZmFpbHVyZS5z
aCAva2VybmVsLXRlc3RzL2xpbnV4NS9vYmotYmlzZWN0CmxzIC1hIC9rZXJuZWwtdGVzdHMv
cnVuLXF1ZXVlL2t2bS9pMzg2LXJhbmRjb25maWctZmQxLTA0MDgvbGludXgtZGV2ZWw6ZGV2
ZWwtZjQtaTM4Ni0yMDE0MDQwODEzNTk6NjQ2YTBiY2M1NGZlZmEyOWMzMmZjMDNiZWJkZTZm
ZjYxM2EzMDQ3YjpiaXNlY3QtbGludXg1CgoyMDE0LTA0LTEwLTAwOjA1OjU1IDY0NmEwYmNj
NTRmZWZhMjljMzJmYzAzYmViZGU2ZmY2MTNhMzA0N2IgY29tcGlsaW5nClF1ZXVlZCBidWls
ZCB0YXNrIHRvIC9rZXJuZWwtdGVzdHMvYnVpbGQtcXVldWUvaTM4Ni1yYW5kY29uZmlnLWZk
MS0wNDA4LTY0NmEwYmNjNTRmZWZhMjljMzJmYzAzYmViZGU2ZmY2MTNhMzA0N2IKQ2hlY2sg
Zm9yIGtlcm5lbCBpbiAva2VybmVsL2kzODYtcmFuZGNvbmZpZy1mZDEtMDQwOC82NDZhMGJj
YzU0ZmVmYTI5YzMyZmMwM2JlYmRlNmZmNjEzYTMwNDdiCndhaXRpbmcgZm9yIGNvbXBsZXRp
b24gb2YgL2tlcm5lbC10ZXN0cy9idWlsZC1xdWV1ZS9pMzg2LXJhbmRjb25maWctZmQxLTA0
MDgtNjQ2YTBiY2M1NGZlZmEyOWMzMmZjMDNiZWJkZTZmZjYxM2EzMDQ3Ygp3YWl0aW5nIGZv
ciBjb21wbGV0aW9uIG9mIC9rZXJuZWwtdGVzdHMvYnVpbGQtcXVldWUvLmkzODYtcmFuZGNv
bmZpZy1mZDEtMDQwOC02NDZhMGJjYzU0ZmVmYTI5YzMyZmMwM2JlYmRlNmZmNjEzYTMwNDdi
Cmtlcm5lbDogL2tlcm5lbC9pMzg2LXJhbmRjb25maWctZmQxLTA0MDgvNjQ2YTBiY2M1NGZl
ZmEyOWMzMmZjMDNiZWJkZTZmZjYxM2EzMDQ3Yi92bWxpbnV6LTMuMTQuMC0wMDUzNC1nNjQ2
YTBiYwoKMjAxNC0wNC0xMC0wMDoyNDo1NSBkZXRlY3RpbmcgYm9vdCBzdGF0ZSAuLgkyMAky
MiBTVUNDRVNTCgpCaXNlY3Rpbmc6IDEwMiByZXZpc2lvbnMgbGVmdCB0byB0ZXN0IGFmdGVy
IHRoaXMgKHJvdWdobHkgNyBzdGVwcykKWzY1YzRjODA4ZTdhYTBkNDlmYWMyMGJhZWViYmIx
ODY5ZWU1ZGZlMTRdIE1lcmdlICd2aXJlc2hrL2lzb2xhdGUtY3B1c2V0cycgaW50byBkZXZl
bC1mNC1pMzg2LTIwMTQwNDA4MTM1OQpydW5uaW5nIC9jL2tlcm5lbC10ZXN0cy9iaXNlY3Qt
dGVzdC1ib290LWZhaWx1cmUuc2ggL2tlcm5lbC10ZXN0cy9saW51eDUvb2JqLWJpc2VjdAps
cyAtYSAva2VybmVsLXRlc3RzL3J1bi1xdWV1ZS9rdm0vaTM4Ni1yYW5kY29uZmlnLWZkMS0w
NDA4L2xpbnV4LWRldmVsOmRldmVsLWY0LWkzODYtMjAxNDA0MDgxMzU5OjY1YzRjODA4ZTdh
YTBkNDlmYWMyMGJhZWViYmIxODY5ZWU1ZGZlMTQ6YmlzZWN0LWxpbnV4NQoKMjAxNC0wNC0x
MC0wMDoyNjo1NiA2NWM0YzgwOGU3YWEwZDQ5ZmFjMjBiYWVlYmJiMTg2OWVlNWRmZTE0IGNv
bXBpbGluZwpRdWV1ZWQgYnVpbGQgdGFzayB0byAva2VybmVsLXRlc3RzL2J1aWxkLXF1ZXVl
L2kzODYtcmFuZGNvbmZpZy1mZDEtMDQwOC02NWM0YzgwOGU3YWEwZDQ5ZmFjMjBiYWVlYmJi
MTg2OWVlNWRmZTE0CkNoZWNrIGZvciBrZXJuZWwgaW4gL2tlcm5lbC9pMzg2LXJhbmRjb25m
aWctZmQxLTA0MDgvNjVjNGM4MDhlN2FhMGQ0OWZhYzIwYmFlZWJiYjE4NjllZTVkZmUxNAp3
YWl0aW5nIGZvciBjb21wbGV0aW9uIG9mIC9rZXJuZWwtdGVzdHMvYnVpbGQtcXVldWUvaTM4
Ni1yYW5kY29uZmlnLWZkMS0wNDA4LTY1YzRjODA4ZTdhYTBkNDlmYWMyMGJhZWViYmIxODY5
ZWU1ZGZlMTQKd2FpdGluZyBmb3IgY29tcGxldGlvbiBvZiAva2VybmVsLXRlc3RzL2J1aWxk
LXF1ZXVlLy5pMzg2LXJhbmRjb25maWctZmQxLTA0MDgtNjVjNGM4MDhlN2FhMGQ0OWZhYzIw
YmFlZWJiYjE4NjllZTVkZmUxNAprZXJuZWw6IC9rZXJuZWwvaTM4Ni1yYW5kY29uZmlnLWZk
MS0wNDA4LzY1YzRjODA4ZTdhYTBkNDlmYWMyMGJhZWViYmIxODY5ZWU1ZGZlMTQvdm1saW51
ei0zLjE0LjAtMDA2MjYtZzY1YzRjODAKCjIwMTQtMDQtMTAtMDA6MzI6NTcgZGV0ZWN0aW5n
IGJvb3Qgc3RhdGUgLi4JMTEJMjIgU1VDQ0VTUwoKQmlzZWN0aW5nOiAxMCByZXZpc2lvbnMg
bGVmdCB0byB0ZXN0IGFmdGVyIHRoaXMgKHJvdWdobHkgNCBzdGVwcykKWzc4ZmI5OTBiYzNk
ZDVjN2E3MWIwMWM4N2U5ZTk0ZDIxODcyMGJmYWNdIE1lcmdlICdvcGVuLW9zZC9yYWlkNicg
aW50byBkZXZlbC1mNC1pMzg2LTIwMTQwNDA4MTM1OQpydW5uaW5nIC9jL2tlcm5lbC10ZXN0
cy9iaXNlY3QtdGVzdC1ib290LWZhaWx1cmUuc2ggL2tlcm5lbC10ZXN0cy9saW51eDUvb2Jq
LWJpc2VjdApscyAtYSAva2VybmVsLXRlc3RzL3J1bi1xdWV1ZS9rdm0vaTM4Ni1yYW5kY29u
ZmlnLWZkMS0wNDA4L2xpbnV4LWRldmVsOmRldmVsLWY0LWkzODYtMjAxNDA0MDgxMzU5Ojc4
ZmI5OTBiYzNkZDVjN2E3MWIwMWM4N2U5ZTk0ZDIxODcyMGJmYWM6YmlzZWN0LWxpbnV4NQoK
MjAxNC0wNC0xMC0wMDozNDo1NyA3OGZiOTkwYmMzZGQ1YzdhNzFiMDFjODdlOWU5NGQyMTg3
MjBiZmFjIGNvbXBpbGluZwpRdWV1ZWQgYnVpbGQgdGFzayB0byAva2VybmVsLXRlc3RzL2J1
aWxkLXF1ZXVlL2kzODYtcmFuZGNvbmZpZy1mZDEtMDQwOC03OGZiOTkwYmMzZGQ1YzdhNzFi
MDFjODdlOWU5NGQyMTg3MjBiZmFjCkNoZWNrIGZvciBrZXJuZWwgaW4gL2tlcm5lbC9pMzg2
LXJhbmRjb25maWctZmQxLTA0MDgvNzhmYjk5MGJjM2RkNWM3YTcxYjAxYzg3ZTllOTRkMjE4
NzIwYmZhYwp3YWl0aW5nIGZvciBjb21wbGV0aW9uIG9mIC9rZXJuZWwtdGVzdHMvYnVpbGQt
cXVldWUvaTM4Ni1yYW5kY29uZmlnLWZkMS0wNDA4LTc4ZmI5OTBiYzNkZDVjN2E3MWIwMWM4
N2U5ZTk0ZDIxODcyMGJmYWMKd2FpdGluZyBmb3IgY29tcGxldGlvbiBvZiAva2VybmVsLXRl
c3RzL2J1aWxkLXF1ZXVlLy5pMzg2LXJhbmRjb25maWctZmQxLTA0MDgtNzhmYjk5MGJjM2Rk
NWM3YTcxYjAxYzg3ZTllOTRkMjE4NzIwYmZhYwprZXJuZWw6IC9rZXJuZWwvaTM4Ni1yYW5k
Y29uZmlnLWZkMS0wNDA4Lzc4ZmI5OTBiYzNkZDVjN2E3MWIwMWM4N2U5ZTk0ZDIxODcyMGJm
YWMvdm1saW51ei0zLjE0LjAtMDA5OTUtZzc4ZmI5OTAKCjIwMTQtMDQtMTAtMDA6NTc6NTcg
ZGV0ZWN0aW5nIGJvb3Qgc3RhdGUgLi4uLiBURVNUIEZBSUxVUkUKWyAgICAwLjMxMDc0OF0g
eG9yOiB1c2luZyBmdW5jdGlvbjogcElJSV9zc2UgKDAuMDQ4IE1CL3NlYykKWyAgICAwLjMx
MTY0OF0gLS0tLS0tLS0tLS0tWyBjdXQgaGVyZSBdLS0tLS0tLS0tLS0tClsgICAgMC4zMTE2
NDhdIC0tLS0tLS0tLS0tLVsgY3V0IGhlcmUgXS0tLS0tLS0tLS0tLQpbICAgIDAuMzEyMzc2
XSBXQVJOSU5HOiBDUFU6IDAgUElEOiAxIGF0IGluaXQvbWFpbi5jOjcwOCBkb19vbmVfaW5p
dGNhbGwrMHgxMWQvMHgxMzYoKQova2VybmVsL2kzODYtcmFuZGNvbmZpZy1mZDEtMDQwOC83
OGZiOTkwYmMzZGQ1YzdhNzFiMDFjODdlOWU5NGQyMTg3MjBiZmFjL2RtZXNnLXF1YW50YWwt
ZjMtMTI0OjIwMTQwNDEwMDA1OTMyOmkzODYtcmFuZGNvbmZpZy1mZDEtMDQwODozLjE0LjAt
MDA5OTUtZzc4ZmI5OTA6MQova2VybmVsL2kzODYtcmFuZGNvbmZpZy1mZDEtMDQwOC83OGZi
OTkwYmMzZGQ1YzdhNzFiMDFjODdlOWU5NGQyMTg3MjBiZmFjL2RtZXNnLXF1YW50YWwtbGtw
LWliMDMtOTQ6MjAxNDA0MTAwMDU5MzQ6aTM4Ni1yYW5kY29uZmlnLWZkMS0wNDA4OjMuMTQu
MC0wMDk5NS1nNzhmYjk5MDoxCi9rZXJuZWwvaTM4Ni1yYW5kY29uZmlnLWZkMS0wNDA4Lzc4
ZmI5OTBiYzNkZDVjN2E3MWIwMWM4N2U5ZTk0ZDIxODcyMGJmYWMvZG1lc2ctcXVhbnRhbC1m
My04MjoyMDE0MDQxMDAwNTkzNzppMzg2LXJhbmRjb25maWctZmQxLTA0MDg6My4xNC4wLTAw
OTk1LWc3OGZiOTkwOjEKL2tlcm5lbC9pMzg2LXJhbmRjb25maWctZmQxLTA0MDgvNzhmYjk5
MGJjM2RkNWM3YTcxYjAxYzg3ZTllOTRkMjE4NzIwYmZhYy9kbWVzZy1xdWFudGFsLWxrcC1p
YjAzLTEwODoyMDE0MDQxMDAwNTk0MTppMzg2LXJhbmRjb25maWctZmQxLTA0MDg6My4xNC4w
LTAwOTk1LWc3OGZiOTkwOjEKL2tlcm5lbC9pMzg2LXJhbmRjb25maWctZmQxLTA0MDgvNzhm
Yjk5MGJjM2RkNWM3YTcxYjAxYzg3ZTllOTRkMjE4NzIwYmZhYy9kbWVzZy15b2N0by1sa3At
aWIwMy0xMTA6MjAxNDA0MTAwMDU5Mzg6aTM4Ni1yYW5kY29uZmlnLWZkMS0wNDA4OjMuMTQu
MC0wMDk5NS1nNzhmYjk5MDoxCi9rZXJuZWwvaTM4Ni1yYW5kY29uZmlnLWZkMS0wNDA4Lzc4
ZmI5OTBiYzNkZDVjN2E3MWIwMWM4N2U5ZTk0ZDIxODcyMGJmYWMvZG1lc2cteW9jdG8tbGtw
LWliMDQtNjI6MjAxNDA0MTAwMDU5Mzc6aTM4Ni1yYW5kY29uZmlnLWZkMS0wNDA4OjMuMTQu
MC0wMDk5NS1nNzhmYjk5MDoxCi9rZXJuZWwvaTM4Ni1yYW5kY29uZmlnLWZkMS0wNDA4Lzc4
ZmI5OTBiYzNkZDVjN2E3MWIwMWM4N2U5ZTk0ZDIxODcyMGJmYWMvZG1lc2cteW9jdG8tZjIt
NDg6MjAxNDA0MTAwMDU5NDc6aTM4Ni1yYW5kY29uZmlnLWZkMS0wNDA4OjMuMTQuMC0wMDk5
NS1nNzhmYjk5MDoxCi9rZXJuZWwvaTM4Ni1yYW5kY29uZmlnLWZkMS0wNDA4Lzc4ZmI5OTBi
YzNkZDVjN2E3MWIwMWM4N2U5ZTk0ZDIxODcyMGJmYWMvZG1lc2cteW9jdG8tZjItODU6MjAx
NDA0MTAwMDU5NTM6aTM4Ni1yYW5kY29uZmlnLWZkMS0wNDA4OjMuMTQuMC0wMDk5NS1nNzhm
Yjk5MDoxCjA6ODo4IGFsbF9nb29kOmJhZDphbGxfYmFkIGJvb3RzCgpsaW5lYXItYmlzZWN0
OiBiYWQgYnJhbmNoIG1heSBiZSBvcGVuLW9zZC9yYWlkNgpsaW5lYXItYmlzZWN0OiBoYW5k
bGUgb3ZlciB0byBnaXQgYmlzZWN0CmxpbmVhci1iaXNlY3Q6IGdpdCBiaXNlY3Qgc3RhcnQg
NzhmYjk5MGJjM2RkNWM3YTcxYjAxYzg3ZTllOTRkMjE4NzIwYmZhYyA2NWM0YzgwOGU3YWEw
ZDQ5ZmFjMjBiYWVlYmJiMTg2OWVlNWRmZTE0IC0tClByZXZpb3VzIEhFQUQgcG9zaXRpb24g
d2FzIDc4ZmI5OTAuLi4gTWVyZ2UgJ29wZW4tb3NkL3JhaWQ2JyBpbnRvIGRldmVsLWY0LWkz
ODYtMjAxNDA0MDgxMzU5CkhFQUQgaXMgbm93IGF0IDlkYzBiNjMuLi4gTWVyZ2UgJ3ZpcmVz
aGsvdGltZXItY2xlYW51cC1mb3ItdGdseCcgaW50byBkZXZlbC1yb2FtLWkzODYtMjAxNDA0
MDIxNzAzCkJpc2VjdGluZzogNCByZXZpc2lvbnMgbGVmdCB0byB0ZXN0IGFmdGVyIHRoaXMg
KHJvdWdobHkgMiBzdGVwcykKWzUyM2ZkMjA2MjgzOWU4MGI2MTVkNTM4MmJjOWM0NDczNmNj
MjRjOGNdIG9yZTogKHRyaXZpYWwpIHJlZm9ybWF0IHNvbWUgY29kZQpsaW5lYXItYmlzZWN0
OiBnaXQgYmlzZWN0IHJ1biAvYy9rZXJuZWwtdGVzdHMvYmlzZWN0LXRlc3QtYm9vdC1mYWls
dXJlLnNoIC9rZXJuZWwtdGVzdHMvbGludXg1L29iai1iaXNlY3QKcnVubmluZyAvYy9rZXJu
ZWwtdGVzdHMvYmlzZWN0LXRlc3QtYm9vdC1mYWlsdXJlLnNoIC9rZXJuZWwtdGVzdHMvbGlu
dXg1L29iai1iaXNlY3QKbHMgLWEgL2tlcm5lbC10ZXN0cy9ydW4tcXVldWUva3ZtL2kzODYt
cmFuZGNvbmZpZy1mZDEtMDQwOC9saW51eC1kZXZlbDpkZXZlbC1mNC1pMzg2LTIwMTQwNDA4
MTM1OTo1MjNmZDIwNjI4MzllODBiNjE1ZDUzODJiYzljNDQ3MzZjYzI0YzhjOmJpc2VjdC1s
aW51eDUKCjIwMTQtMDQtMTAtMDE6MDA6MDMgNTIzZmQyMDYyODM5ZTgwYjYxNWQ1MzgyYmM5
YzQ0NzM2Y2MyNGM4YyBjb21waWxpbmcKUXVldWVkIGJ1aWxkIHRhc2sgdG8gL2tlcm5lbC10
ZXN0cy9idWlsZC1xdWV1ZS9pMzg2LXJhbmRjb25maWctZmQxLTA0MDgtNTIzZmQyMDYyODM5
ZTgwYjYxNWQ1MzgyYmM5YzQ0NzM2Y2MyNGM4YwpDaGVjayBmb3Iga2VybmVsIGluIC9rZXJu
ZWwvaTM4Ni1yYW5kY29uZmlnLWZkMS0wNDA4LzUyM2ZkMjA2MjgzOWU4MGI2MTVkNTM4MmJj
OWM0NDczNmNjMjRjOGMKd2FpdGluZyBmb3IgY29tcGxldGlvbiBvZiAva2VybmVsLXRlc3Rz
L2J1aWxkLXF1ZXVlL2kzODYtcmFuZGNvbmZpZy1mZDEtMDQwOC01MjNmZDIwNjI4MzllODBi
NjE1ZDUzODJiYzljNDQ3MzZjYzI0YzhjCndhaXRpbmcgZm9yIGNvbXBsZXRpb24gb2YgL2tl
cm5lbC10ZXN0cy9idWlsZC1xdWV1ZS8uaTM4Ni1yYW5kY29uZmlnLWZkMS0wNDA4LTUyM2Zk
MjA2MjgzOWU4MGI2MTVkNTM4MmJjOWM0NDczNmNjMjRjOGMKa2VybmVsOiAva2VybmVsL2kz
ODYtcmFuZGNvbmZpZy1mZDEtMDQwOC81MjNmZDIwNjI4MzllODBiNjE1ZDUzODJiYzljNDQ3
MzZjYzI0YzhjL3ZtbGludXotMy4xNC4wLXJjOC0wMDAwNC1nNTIzZmQyMAoKMjAxNC0wNC0x
MC0wMToxODowMyBkZXRlY3RpbmcgYm9vdCBzdGF0ZSAuLgkxCTE5CTIyIFNVQ0NFU1MKCkJp
c2VjdGluZzogMiByZXZpc2lvbnMgbGVmdCB0byB0ZXN0IGFmdGVyIHRoaXMgKHJvdWdobHkg
MSBzdGVwKQpbYTdiNjA4M2I3ZGZhNzljMzEwOWUyMDAzMTdmZTE5MGQ3YjYxZDFlYl0gb3Jl
OiBTdXBwb3J0IGZvciByYWlkIDYKcnVubmluZyAvYy9rZXJuZWwtdGVzdHMvYmlzZWN0LXRl
c3QtYm9vdC1mYWlsdXJlLnNoIC9rZXJuZWwtdGVzdHMvbGludXg1L29iai1iaXNlY3QKbHMg
LWEgL2tlcm5lbC10ZXN0cy9ydW4tcXVldWUva3ZtL2kzODYtcmFuZGNvbmZpZy1mZDEtMDQw
OC9saW51eC1kZXZlbDpkZXZlbC1mNC1pMzg2LTIwMTQwNDA4MTM1OTphN2I2MDgzYjdkZmE3
OWMzMTA5ZTIwMDMxN2ZlMTkwZDdiNjFkMWViOmJpc2VjdC1saW51eDUKCjIwMTQtMDQtMTAt
MDE6MjA6MzQgYTdiNjA4M2I3ZGZhNzljMzEwOWUyMDAzMTdmZTE5MGQ3YjYxZDFlYiBjb21w
aWxpbmcKUXVldWVkIGJ1aWxkIHRhc2sgdG8gL2tlcm5lbC10ZXN0cy9idWlsZC1xdWV1ZS9p
Mzg2LXJhbmRjb25maWctZmQxLTA0MDgtYTdiNjA4M2I3ZGZhNzljMzEwOWUyMDAzMTdmZTE5
MGQ3YjYxZDFlYgpDaGVjayBmb3Iga2VybmVsIGluIC9rZXJuZWwvaTM4Ni1yYW5kY29uZmln
LWZkMS0wNDA4L2E3YjYwODNiN2RmYTc5YzMxMDllMjAwMzE3ZmUxOTBkN2I2MWQxZWIKd2Fp
dGluZyBmb3IgY29tcGxldGlvbiBvZiAva2VybmVsLXRlc3RzL2J1aWxkLXF1ZXVlL2kzODYt
cmFuZGNvbmZpZy1mZDEtMDQwOC1hN2I2MDgzYjdkZmE3OWMzMTA5ZTIwMDMxN2ZlMTkwZDdi
NjFkMWViCndhaXRpbmcgZm9yIGNvbXBsZXRpb24gb2YgL2tlcm5lbC10ZXN0cy9idWlsZC1x
dWV1ZS8uaTM4Ni1yYW5kY29uZmlnLWZkMS0wNDA4LWE3YjYwODNiN2RmYTc5YzMxMDllMjAw
MzE3ZmUxOTBkN2I2MWQxZWIKa2VybmVsOiAva2VybmVsL2kzODYtcmFuZGNvbmZpZy1mZDEt
MDQwOC9hN2I2MDgzYjdkZmE3OWMzMTA5ZTIwMDMxN2ZlMTkwZDdiNjFkMWViL3ZtbGludXot
My4xNC4wLXJjOC0wMDAwNi1nYTdiNjA4MwoKMjAxNC0wNC0xMC0wMToyODozNCBkZXRlY3Rp
bmcgYm9vdCBzdGF0ZSAuLi4JMjIgU1VDQ0VTUwoKQmlzZWN0aW5nOiAwIHJldmlzaW9ucyBs
ZWZ0IHRvIHRlc3QgYWZ0ZXIgdGhpcyAocm91Z2hseSAxIHN0ZXApCltlZGZmYzljMTMyZmZi
MzA1MTc5ZDAxNmZjNjhkOGU5NDdiYWQ4M2Y0XSBTUVVBU0hNRTogb3JlOiAyIHJhaWQ2IGJ1
Z3MKcnVubmluZyAvYy9rZXJuZWwtdGVzdHMvYmlzZWN0LXRlc3QtYm9vdC1mYWlsdXJlLnNo
IC9rZXJuZWwtdGVzdHMvbGludXg1L29iai1iaXNlY3QKbHMgLWEgL2tlcm5lbC10ZXN0cy9y
dW4tcXVldWUva3ZtL2kzODYtcmFuZGNvbmZpZy1mZDEtMDQwOC9saW51eC1kZXZlbDpkZXZl
bC1mNC1pMzg2LTIwMTQwNDA4MTM1OTplZGZmYzljMTMyZmZiMzA1MTc5ZDAxNmZjNjhkOGU5
NDdiYWQ4M2Y0OmJpc2VjdC1saW51eDUKCjIwMTQtMDQtMTAtMDE6MzA6MzUgZWRmZmM5YzEz
MmZmYjMwNTE3OWQwMTZmYzY4ZDhlOTQ3YmFkODNmNCBjb21waWxpbmcKUXVldWVkIGJ1aWxk
IHRhc2sgdG8gL2tlcm5lbC10ZXN0cy9idWlsZC1xdWV1ZS9pMzg2LXJhbmRjb25maWctZmQx
LTA0MDgtZWRmZmM5YzEzMmZmYjMwNTE3OWQwMTZmYzY4ZDhlOTQ3YmFkODNmNApDaGVjayBm
b3Iga2VybmVsIGluIC9rZXJuZWwvaTM4Ni1yYW5kY29uZmlnLWZkMS0wNDA4L2VkZmZjOWMx
MzJmZmIzMDUxNzlkMDE2ZmM2OGQ4ZTk0N2JhZDgzZjQKd2FpdGluZyBmb3IgY29tcGxldGlv
biBvZiAva2VybmVsLXRlc3RzL2J1aWxkLXF1ZXVlL2kzODYtcmFuZGNvbmZpZy1mZDEtMDQw
OC1lZGZmYzljMTMyZmZiMzA1MTc5ZDAxNmZjNjhkOGU5NDdiYWQ4M2Y0CndhaXRpbmcgZm9y
IGNvbXBsZXRpb24gb2YgL2tlcm5lbC10ZXN0cy9idWlsZC1xdWV1ZS8uaTM4Ni1yYW5kY29u
ZmlnLWZkMS0wNDA4LWVkZmZjOWMxMzJmZmIzMDUxNzlkMDE2ZmM2OGQ4ZTk0N2JhZDgzZjQK
a2VybmVsOiAva2VybmVsL2kzODYtcmFuZGNvbmZpZy1mZDEtMDQwOC9lZGZmYzljMTMyZmZi
MzA1MTc5ZDAxNmZjNjhkOGU5NDdiYWQ4M2Y0L3ZtbGludXotMy4xNC4wLXJjOC0wMDAwOC1n
ZWRmZmM5YwoKMjAxNC0wNC0xMC0wMTozOTozNSBkZXRlY3RpbmcgYm9vdCBzdGF0ZSAuLi4u
IFRFU1QgRkFJTFVSRQpbICAgIDAuMzEwNzM3XSB4b3I6IHVzaW5nIGZ1bmN0aW9uOiBwcmVm
ZXRjaDY0LXNzZSAoMC4xMDggTUIvc2VjKQpbICAgIDAuMzExNjI1XSAtLS0tLS0tLS0tLS1b
IGN1dCBoZXJlIF0tLS0tLS0tLS0tLS0KWyAgICAwLjMxMTYyNV0gLS0tLS0tLS0tLS0tWyBj
dXQgaGVyZSBdLS0tLS0tLS0tLS0tClsgICAgMC4zMTIzMzVdIFdBUk5JTkc6IENQVTogMCBQ
SUQ6IDEgYXQgaW5pdC9tYWluLmM6NzA4IGRvX29uZV9pbml0Y2FsbCsweDExZC8weDEzNigp
Ci9rZXJuZWwvaTM4Ni1yYW5kY29uZmlnLWZkMS0wNDA4L2VkZmZjOWMxMzJmZmIzMDUxNzlk
MDE2ZmM2OGQ4ZTk0N2JhZDgzZjQvZG1lc2ctcXVhbnRhbC1mMy0xMTg6MjAxNDA0MTAwMTQw
NTc6aTM4Ni1yYW5kY29uZmlnLWZkMS0wNDA4OjMuMTQuMC1yYzgtMDAwMDgtZ2VkZmZjOWM6
MTQKL2tlcm5lbC9pMzg2LXJhbmRjb25maWctZmQxLTA0MDgvZWRmZmM5YzEzMmZmYjMwNTE3
OWQwMTZmYzY4ZDhlOTQ3YmFkODNmNC9kbWVzZy1xdWFudGFsLWYzLTY3OjIwMTQwNDEwMDE0
MTAxOmkzODYtcmFuZGNvbmZpZy1mZDEtMDQwODozLjE0LjAtcmM4LTAwMDA4LWdlZGZmYzlj
OjE0Ci9rZXJuZWwvaTM4Ni1yYW5kY29uZmlnLWZkMS0wNDA4L2VkZmZjOWMxMzJmZmIzMDUx
NzlkMDE2ZmM2OGQ4ZTk0N2JhZDgzZjQvZG1lc2cteW9jdG8tbGtwLWliMDQtNzY6MjAxNDA0
MTAwMTQxMDE6aTM4Ni1yYW5kY29uZmlnLWZkMS0wNDA4OjMuMTQuMC1yYzgtMDAwMDgtZ2Vk
ZmZjOWM6MTQKL2tlcm5lbC9pMzg2LXJhbmRjb25maWctZmQxLTA0MDgvZWRmZmM5YzEzMmZm
YjMwNTE3OWQwMTZmYzY4ZDhlOTQ3YmFkODNmNC9kbWVzZy1xdWFudGFsLWYzLTEwNToyMDE0
MDQxMDAxNDEwMzppMzg2LXJhbmRjb25maWctZmQxLTA0MDg6My4xNC4wLXJjOC0wMDAwOC1n
ZWRmZmM5YzoxNAova2VybmVsL2kzODYtcmFuZGNvbmZpZy1mZDEtMDQwOC9lZGZmYzljMTMy
ZmZiMzA1MTc5ZDAxNmZjNjhkOGU5NDdiYWQ4M2Y0L2RtZXNnLXF1YW50YWwtZjItODg6MjAx
NDA0MTAwMTQxMDc6aTM4Ni1yYW5kY29uZmlnLWZkMS0wNDA4OjMuMTQuMC1yYzgtMDAwMDgt
Z2VkZmZjOWM6MTQKL2tlcm5lbC9pMzg2LXJhbmRjb25maWctZmQxLTA0MDgvZWRmZmM5YzEz
MmZmYjMwNTE3OWQwMTZmYzY4ZDhlOTQ3YmFkODNmNC9kbWVzZy1xdWFudGFsLWY0LTExMzoy
MDE0MDQxMDAxNDEwODppMzg2LXJhbmRjb25maWctZmQxLTA0MDg6My4xNC4wLXJjOC0wMDAw
OC1nZWRmZmM5YzoxNAova2VybmVsL2kzODYtcmFuZGNvbmZpZy1mZDEtMDQwOC9lZGZmYzlj
MTMyZmZiMzA1MTc5ZDAxNmZjNjhkOGU5NDdiYWQ4M2Y0L2RtZXNnLXF1YW50YWwtZjQtMTQ6
MjAxNDA0MTAwMTQxMTU6aTM4Ni1yYW5kY29uZmlnLWZkMS0wNDA4OjMuMTQuMC1yYzgtMDAw
MDgtZ2VkZmZjOWM6MTQKL2tlcm5lbC9pMzg2LXJhbmRjb25maWctZmQxLTA0MDgvZWRmZmM5
YzEzMmZmYjMwNTE3OWQwMTZmYzY4ZDhlOTQ3YmFkODNmNC9kbWVzZy1xdWFudGFsLWY0LTU5
OjIwMTQwNDEwMDE0MTEzOmkzODYtcmFuZGNvbmZpZy1mZDEtMDQwODozLjE0LjAtcmM4LTAw
MDA4LWdlZGZmYzljOjE0Ci9rZXJuZWwvaTM4Ni1yYW5kY29uZmlnLWZkMS0wNDA4L2VkZmZj
OWMxMzJmZmIzMDUxNzlkMDE2ZmM2OGQ4ZTk0N2JhZDgzZjQvZG1lc2cteW9jdG8tZjItODU6
MjAxNDA0MTAwMTQxMTM6aTM4Ni1yYW5kY29uZmlnLWZkMS0wNDA4OjMuMTQuMC1yYzgtMDAw
MDgtZ2VkZmZjOWM6MTQKL2tlcm5lbC9pMzg2LXJhbmRjb25maWctZmQxLTA0MDgvZWRmZmM5
YzEzMmZmYjMwNTE3OWQwMTZmYzY4ZDhlOTQ3YmFkODNmNC9kbWVzZy15b2N0by1mNC0xNDoy
MDE0MDQxMDAxNDExMDppMzg2LXJhbmRjb25maWctZmQxLTA0MDg6My4xNC4wLXJjOC0wMDAw
OC1nZWRmZmM5YzoxNAova2VybmVsL2kzODYtcmFuZGNvbmZpZy1mZDEtMDQwOC9lZGZmYzlj
MTMyZmZiMzA1MTc5ZDAxNmZjNjhkOGU5NDdiYWQ4M2Y0L2RtZXNnLXlvY3RvLWY0LTQ6MjAx
NDA0MTAwMTQxMTU6aTM4Ni1yYW5kY29uZmlnLWZkMS0wNDA4OjMuMTQuMC1yYzgtMDAwMDgt
Z2VkZmZjOWM6MTQKL2tlcm5lbC9pMzg2LXJhbmRjb25maWctZmQxLTA0MDgvZWRmZmM5YzEz
MmZmYjMwNTE3OWQwMTZmYzY4ZDhlOTQ3YmFkODNmNC9kbWVzZy15b2N0by1mNC01NToyMDE0
MDQxMDAxNDExMDppMzg2LXJhbmRjb25maWctZmQxLTA0MDg6My4xNC4wLXJjOC0wMDAwOC1n
ZWRmZmM5YzoxNAova2VybmVsL2kzODYtcmFuZGNvbmZpZy1mZDEtMDQwOC9lZGZmYzljMTMy
ZmZiMzA1MTc5ZDAxNmZjNjhkOGU5NDdiYWQ4M2Y0L2RtZXNnLXlvY3RvLWxrcC1pYjAzLTQy
OjIwMTQwNDEwMDE0MTA3OmkzODYtcmFuZGNvbmZpZy1mZDEtMDQwODozLjE0LjAtcmM4LTAw
MDA4LWdlZGZmYzljOjE0Ci9rZXJuZWwvaTM4Ni1yYW5kY29uZmlnLWZkMS0wNDA4L2VkZmZj
OWMxMzJmZmIzMDUxNzlkMDE2ZmM2OGQ4ZTk0N2JhZDgzZjQvZG1lc2cteW9jdG8tbGtwLWli
MDQtNDc6MjAxNDA0MTAwMTQxMTM6aTM4Ni1yYW5kY29uZmlnLWZkMS0wNDA4OjMuMTQuMC1y
YzgtMDAwMDgtZ2VkZmZjOWM6MTQKL2tlcm5lbC9pMzg2LXJhbmRjb25maWctZmQxLTA0MDgv
ZWRmZmM5YzEzMmZmYjMwNTE3OWQwMTZmYzY4ZDhlOTQ3YmFkODNmNC9kbWVzZy1xdWFudGFs
LWYzLTcxOjIwMTQwNDEwMDE0MTE3OmkzODYtcmFuZGNvbmZpZy1mZDEtMDQwODozLjE0LjAt
cmM4LTAwMDA4LWdlZGZmYzljOjE0Ci9rZXJuZWwvaTM4Ni1yYW5kY29uZmlnLWZkMS0wNDA4
L2VkZmZjOWMxMzJmZmIzMDUxNzlkMDE2ZmM2OGQ4ZTk0N2JhZDgzZjQvZG1lc2ctcXVhbnRh
bC1sa3AtaWIwNC01NToyMDE0MDQxMDAxNDExODppMzg2LXJhbmRjb25maWctZmQxLTA0MDg6
My4xNC4wLXJjOC0wMDAwOC1nZWRmZmM5YzoxNAova2VybmVsL2kzODYtcmFuZGNvbmZpZy1m
ZDEtMDQwOC9lZGZmYzljMTMyZmZiMzA1MTc5ZDAxNmZjNjhkOGU5NDdiYWQ4M2Y0L2RtZXNn
LXlvY3RvLWYzLTQ3OjIwMTQwNDEwMDE0MTI0OmkzODYtcmFuZGNvbmZpZy1mZDEtMDQwODoz
LjE0LjAtcmM4LTAwMDA4LWdlZGZmYzljOjE0Ci9rZXJuZWwvaTM4Ni1yYW5kY29uZmlnLWZk
MS0wNDA4L2VkZmZjOWMxMzJmZmIzMDUxNzlkMDE2ZmM2OGQ4ZTk0N2JhZDgzZjQvZG1lc2ct
eW9jdG8tZjMtNjk6MjAxNDA0MTAwMTQxMTg6aTM4Ni1yYW5kY29uZmlnLWZkMS0wNDA4OjMu
MTQuMC1yYzgtMDAwMDgtZ2VkZmZjOWM6MTQKL2tlcm5lbC9pMzg2LXJhbmRjb25maWctZmQx
LTA0MDgvZWRmZmM5YzEzMmZmYjMwNTE3OWQwMTZmYzY4ZDhlOTQ3YmFkODNmNC9kbWVzZy15
b2N0by1mNC0xMjA6MjAxNDA0MTAwMTQxMTc6aTM4Ni1yYW5kY29uZmlnLWZkMS0wNDA4OjMu
MTQuMC1yYzgtMDAwMDgtZ2VkZmZjOWM6MTQKL2tlcm5lbC9pMzg2LXJhbmRjb25maWctZmQx
LTA0MDgvZWRmZmM5YzEzMmZmYjMwNTE3OWQwMTZmYzY4ZDhlOTQ3YmFkODNmNC9kbWVzZy15
b2N0by1mNC0yNjoyMDE0MDQxMDAxNDEyNjppMzg2LXJhbmRjb25maWctZmQxLTA0MDg6My4x
NC4wLXJjOC0wMDAwOC1nZWRmZmM5YzoxNAowOjIwOjIwIGFsbF9nb29kOmJhZDphbGxfYmFk
IGJvb3RzCgpCaXNlY3Rpbmc6IDAgcmV2aXNpb25zIGxlZnQgdG8gdGVzdCBhZnRlciB0aGlz
IChyb3VnaGx5IDAgc3RlcHMpCls2MGU4MzNkODZhMDFhZDlkODIwNGEwNGI4ZGIzMjQxMDZh
YjUwMzk1XSBSRkM6IGRvX3hvcl9zcGVlZCBCcm9rZW4gb24gVU1MIGRvIHRvIGppZmZpZXMK
cnVubmluZyAvYy9rZXJuZWwtdGVzdHMvYmlzZWN0LXRlc3QtYm9vdC1mYWlsdXJlLnNoIC9r
ZXJuZWwtdGVzdHMvbGludXg1L29iai1iaXNlY3QKbHMgLWEgL2tlcm5lbC10ZXN0cy9ydW4t
cXVldWUva3ZtL2kzODYtcmFuZGNvbmZpZy1mZDEtMDQwOC9saW51eC1kZXZlbDpkZXZlbC1m
NC1pMzg2LTIwMTQwNDA4MTM1OTo2MGU4MzNkODZhMDFhZDlkODIwNGEwNGI4ZGIzMjQxMDZh
YjUwMzk1OmJpc2VjdC1saW51eDUKCjIwMTQtMDQtMTAtMDE6NDE6MzggNjBlODMzZDg2YTAx
YWQ5ZDgyMDRhMDRiOGRiMzI0MTA2YWI1MDM5NSBjb21waWxpbmcKUXVldWVkIGJ1aWxkIHRh
c2sgdG8gL2tlcm5lbC10ZXN0cy9idWlsZC1xdWV1ZS9pMzg2LXJhbmRjb25maWctZmQxLTA0
MDgtNjBlODMzZDg2YTAxYWQ5ZDgyMDRhMDRiOGRiMzI0MTA2YWI1MDM5NQpDaGVjayBmb3Ig
a2VybmVsIGluIC9rZXJuZWwvaTM4Ni1yYW5kY29uZmlnLWZkMS0wNDA4LzYwZTgzM2Q4NmEw
MWFkOWQ4MjA0YTA0YjhkYjMyNDEwNmFiNTAzOTUKd2FpdGluZyBmb3IgY29tcGxldGlvbiBv
ZiAva2VybmVsLXRlc3RzL2J1aWxkLXF1ZXVlL2kzODYtcmFuZGNvbmZpZy1mZDEtMDQwOC02
MGU4MzNkODZhMDFhZDlkODIwNGEwNGI4ZGIzMjQxMDZhYjUwMzk1CndhaXRpbmcgZm9yIGNv
bXBsZXRpb24gb2YgL2tlcm5lbC10ZXN0cy9idWlsZC1xdWV1ZS8uaTM4Ni1yYW5kY29uZmln
LWZkMS0wNDA4LTYwZTgzM2Q4NmEwMWFkOWQ4MjA0YTA0YjhkYjMyNDEwNmFiNTAzOTUKa2Vy
bmVsOiAva2VybmVsL2kzODYtcmFuZGNvbmZpZy1mZDEtMDQwOC82MGU4MzNkODZhMDFhZDlk
ODIwNGEwNGI4ZGIzMjQxMDZhYjUwMzk1L3ZtbGludXotMy4xNC4wLXJjOC0wMDAwNy1nNjBl
ODMzZAoKMjAxNC0wNC0xMC0wMTo0NzozOCBkZXRlY3RpbmcgYm9vdCBzdGF0ZSAuLi4uIFRF
U1QgRkFJTFVSRQpbICAgIDAuMzkxMDkwXSB4b3I6IHVzaW5nIGZ1bmN0aW9uOiBwcmVmZXRj
aDY0LXNzZSAoMC4xMzggTUIvc2VjKQpbICAgIDAuMzkyNDExXSAtLS0tLS0tLS0tLS1bIGN1
dCBoZXJlIF0tLS0tLS0tLS0tLS0KWyAgICAwLjM5MjQxMV0gLS0tLS0tLS0tLS0tWyBjdXQg
aGVyZSBdLS0tLS0tLS0tLS0tClsgICAgMC4zOTM1MTRdIFdBUk5JTkc6IENQVTogMCBQSUQ6
IDEgYXQgaW5pdC9tYWluLmM6NzA4IGRvX29uZV9pbml0Y2FsbCsweDExZC8weDEzNigpCi9r
ZXJuZWwvaTM4Ni1yYW5kY29uZmlnLWZkMS0wNDA4LzYwZTgzM2Q4NmEwMWFkOWQ4MjA0YTA0
YjhkYjMyNDEwNmFiNTAzOTUvZG1lc2cteW9jdG8tbGtwLWliMDMtMTIwOjIwMTQwNDEwMDE0
OTEwOmkzODYtcmFuZGNvbmZpZy1mZDEtMDQwODozLjE0LjAtcmM4LTAwMDA3LWc2MGU4MzNk
OjIKL2tlcm5lbC9pMzg2LXJhbmRjb25maWctZmQxLTA0MDgvNjBlODMzZDg2YTAxYWQ5ZDgy
MDRhMDRiOGRiMzI0MTA2YWI1MDM5NS9kbWVzZy1xdWFudGFsLWYzLTc0OjIwMTQwNDEwMDE0
OTIwOmkzODYtcmFuZGNvbmZpZy1mZDEtMDQwODozLjE0LjAtcmM4LTAwMDA3LWc2MGU4MzNk
OjIKL2tlcm5lbC9pMzg2LXJhbmRjb25maWctZmQxLTA0MDgvNjBlODMzZDg2YTAxYWQ5ZDgy
MDRhMDRiOGRiMzI0MTA2YWI1MDM5NS9kbWVzZy1xdWFudGFsLWxrcC1pYjAzLTEwNToyMDE0
MDQxMDAxNDkxNjppMzg2LXJhbmRjb25maWctZmQxLTA0MDg6My4xNC4wLXJjOC0wMDAwNy1n
NjBlODMzZDoyCi9rZXJuZWwvaTM4Ni1yYW5kY29uZmlnLWZkMS0wNDA4LzYwZTgzM2Q4NmEw
MWFkOWQ4MjA0YTA0YjhkYjMyNDEwNmFiNTAzOTUvZG1lc2ctcXVhbnRhbC1sa3AtaWIwMy0y
MDoyMDE0MDQxMDAxNDkxMjppMzg2LXJhbmRjb25maWctZmQxLTA0MDg6My4xNC4wLXJjOC0w
MDAwNy1nNjBlODMzZDoyCi9rZXJuZWwvaTM4Ni1yYW5kY29uZmlnLWZkMS0wNDA4LzYwZTgz
M2Q4NmEwMWFkOWQ4MjA0YTA0YjhkYjMyNDEwNmFiNTAzOTUvZG1lc2ctcXVhbnRhbC1sa3At
aWIwMy0zNDoyMDE0MDQxMDAxNDkxNzppMzg2LXJhbmRjb25maWctZmQxLTA0MDg6My4xNC4w
LXJjOC0wMDAwNy1nNjBlODMzZDoyCi9rZXJuZWwvaTM4Ni1yYW5kY29uZmlnLWZkMS0wNDA4
LzYwZTgzM2Q4NmEwMWFkOWQ4MjA0YTA0YjhkYjMyNDEwNmFiNTAzOTUvZG1lc2ctcXVhbnRh
bC1sa3AtaWIwNC0xMToyMDE0MDQxMDAxNDkxMjppMzg2LXJhbmRjb25maWctZmQxLTA0MDg6
My4xNC4wLXJjOC0wMDAwNy1nNjBlODMzZDoyCi9rZXJuZWwvaTM4Ni1yYW5kY29uZmlnLWZk
MS0wNDA4LzYwZTgzM2Q4NmEwMWFkOWQ4MjA0YTA0YjhkYjMyNDEwNmFiNTAzOTUvZG1lc2ct
cXVhbnRhbC1sa3AtaWIwNC0zMzoyMDE0MDQxMDAxNDkxNDppMzg2LXJhbmRjb25maWctZmQx
LTA0MDg6My4xNC4wLXJjOC0wMDAwNy1nNjBlODMzZDoyCi9rZXJuZWwvaTM4Ni1yYW5kY29u
ZmlnLWZkMS0wNDA4LzYwZTgzM2Q4NmEwMWFkOWQ4MjA0YTA0YjhkYjMyNDEwNmFiNTAzOTUv
ZG1lc2ctcXVhbnRhbC1sa3AtaWIwNC04NjoyMDE0MDQxMDAxNDkyMDppMzg2LXJhbmRjb25m
aWctZmQxLTA0MDg6My4xNC4wLXJjOC0wMDAwNy1nNjBlODMzZDoyCi9rZXJuZWwvaTM4Ni1y
YW5kY29uZmlnLWZkMS0wNDA4LzYwZTgzM2Q4NmEwMWFkOWQ4MjA0YTA0YjhkYjMyNDEwNmFi
NTAzOTUvZG1lc2cteW9jdG8tZjMtMTg6MjAxNDA0MTAwMTQ5MTE6aTM4Ni1yYW5kY29uZmln
LWZkMS0wNDA4OjMuMTQuMC1yYzgtMDAwMDctZzYwZTgzM2Q6Mgova2VybmVsL2kzODYtcmFu
ZGNvbmZpZy1mZDEtMDQwOC82MGU4MzNkODZhMDFhZDlkODIwNGEwNGI4ZGIzMjQxMDZhYjUw
Mzk1L2RtZXNnLXlvY3RvLWYzLTY0OjIwMTQwNDEwMDE0OTIwOmkzODYtcmFuZGNvbmZpZy1m
ZDEtMDQwODozLjE0LjAtcmM4LTAwMDA3LWc2MGU4MzNkOjIKL2tlcm5lbC9pMzg2LXJhbmRj
b25maWctZmQxLTA0MDgvNjBlODMzZDg2YTAxYWQ5ZDgyMDRhMDRiOGRiMzI0MTA2YWI1MDM5
NS9kbWVzZy15b2N0by1sa3AtaWIwMy0yMjoyMDE0MDQxMDAxNDkxMzppMzg2LXJhbmRjb25m
aWctZmQxLTA0MDg6My4xNC4wLXJjOC0wMDAwNy1nNjBlODMzZDoyCi9rZXJuZWwvaTM4Ni1y
YW5kY29uZmlnLWZkMS0wNDA4LzYwZTgzM2Q4NmEwMWFkOWQ4MjA0YTA0YjhkYjMyNDEwNmFi
NTAzOTUvZG1lc2cteW9jdG8tbGtwLWliMDQtMjk6MjAxNDA0MTAwMTQ5MTk6aTM4Ni1yYW5k
Y29uZmlnLWZkMS0wNDA4OjMuMTQuMC1yYzgtMDAwMDctZzYwZTgzM2Q6Mgova2VybmVsL2kz
ODYtcmFuZGNvbmZpZy1mZDEtMDQwOC82MGU4MzNkODZhMDFhZDlkODIwNGEwNGI4ZGIzMjQx
MDZhYjUwMzk1L2RtZXNnLXlvY3RvLWxrcC1pYjA0LTY1OjIwMTQwNDEwMDE0OTE3OmkzODYt
cmFuZGNvbmZpZy1mZDEtMDQwODozLjE0LjAtcmM4LTAwMDA3LWc2MGU4MzNkOjIKL2tlcm5l
bC9pMzg2LXJhbmRjb25maWctZmQxLTA0MDgvNjBlODMzZDg2YTAxYWQ5ZDgyMDRhMDRiOGRi
MzI0MTA2YWI1MDM5NS9kbWVzZy1xdWFudGFsLWxrcC1pYjAzLTMxOjIwMTQwNDEwMDE0OTIw
OmkzODYtcmFuZGNvbmZpZy1mZDEtMDQwODozLjE0LjAtcmM4LTAwMDA3LWc2MGU4MzNkOjIK
L2tlcm5lbC9pMzg2LXJhbmRjb25maWctZmQxLTA0MDgvNjBlODMzZDg2YTAxYWQ5ZDgyMDRh
MDRiOGRiMzI0MTA2YWI1MDM5NS9kbWVzZy1xdWFudGFsLWxrcC1pYjAzLTY1OjIwMTQwNDEw
MDE0OTE5OmkzODYtcmFuZGNvbmZpZy1mZDEtMDQwODozLjE0LjAtcmM4LTAwMDA3LWc2MGU4
MzNkOjIKL2tlcm5lbC9pMzg2LXJhbmRjb25maWctZmQxLTA0MDgvNjBlODMzZDg2YTAxYWQ5
ZDgyMDRhMDRiOGRiMzI0MTA2YWI1MDM5NS9kbWVzZy15b2N0by1sa3AtaWIwNC00NToyMDE0
MDQxMDAxNDkyMDppMzg2LXJhbmRjb25maWctZmQxLTA0MDg6My4xNC4wLXJjOC0wMDAwNy1n
NjBlODMzZDoyCi9rZXJuZWwvaTM4Ni1yYW5kY29uZmlnLWZkMS0wNDA4LzYwZTgzM2Q4NmEw
MWFkOWQ4MjA0YTA0YjhkYjMyNDEwNmFiNTAzOTUvZG1lc2ctcXVhbnRhbC1sa3AtaWIwMy03
ODoyMDE0MDQxMDAxNDkyMTppMzg2LXJhbmRjb25maWctZmQxLTA0MDg6My4xNC4wLXJjOC0w
MDAwNy1nNjBlODMzZDoyCi9rZXJuZWwvaTM4Ni1yYW5kY29uZmlnLWZkMS0wNDA4LzYwZTgz
M2Q4NmEwMWFkOWQ4MjA0YTA0YjhkYjMyNDEwNmFiNTAzOTUvZG1lc2ctcXVhbnRhbC1mMy0y
MToyMDE0MDQxMDAxNDkyMzppMzg2LXJhbmRjb25maWctZmQxLTA0MDg6My4xNC4wLXJjOC0w
MDAwNy1nNjBlODMzZDoyCi9rZXJuZWwvaTM4Ni1yYW5kY29uZmlnLWZkMS0wNDA4LzYwZTgz
M2Q4NmEwMWFkOWQ4MjA0YTA0YjhkYjMyNDEwNmFiNTAzOTUvZG1lc2ctcXVhbnRhbC1mMy05
OToyMDE0MDQxMDAxNDkyNDppMzg2LXJhbmRjb25maWctZmQxLTA0MDg6My4xNC4wLXJjOC0w
MDAwNy1nNjBlODMzZDoyCi9rZXJuZWwvaTM4Ni1yYW5kY29uZmlnLWZkMS0wNDA4LzYwZTgz
M2Q4NmEwMWFkOWQ4MjA0YTA0YjhkYjMyNDEwNmFiNTAzOTUvZG1lc2cteW9jdG8tbGtwLWli
MDQtMTA6MjAxNDA0MTAwMTQ5MjI6aTM4Ni1yYW5kY29uZmlnLWZkMS0wNDA4OjMuMTQuMC1y
YzgtMDAwMDctZzYwZTgzM2Q6MgowOjIwOjIwIGFsbF9nb29kOmJhZDphbGxfYmFkIGJvb3Rz
Cgo2MGU4MzNkODZhMDFhZDlkODIwNGEwNGI4ZGIzMjQxMDZhYjUwMzk1IGlzIHRoZSBmaXJz
dCBiYWQgY29tbWl0CmNvbW1pdCA2MGU4MzNkODZhMDFhZDlkODIwNGEwNGI4ZGIzMjQxMDZh
YjUwMzk1CkF1dGhvcjogQm9heiBIYXJyb3NoIDxiaGFycm9zaEBwYW5hc2FzLmNvbT4KRGF0
ZTogICBUaHUgSnVsIDE5IDE1OjIyOjM3IDIwMTIgKzAzMDAKCiAgICBSRkM6IGRvX3hvcl9z
cGVlZCBCcm9rZW4gb24gVU1MIGRvIHRvIGppZmZpZXMKICAgIAogICAgUmVtZW1iZXIgdGhh
dCBoYW5nIEkgcmVwb3J0ZWQgYSB3aGlsZSBiYWNrIG9uIFVNTC4gV2VsbAogICAgSSdtIGF0
IGl0IGFnYWluLCBhbmQgaXQgc3RpbGwgaGFuZ3MgYW5kIEkgZm91bmQgd2h5LgogICAgCiAg
ICBJIGhhdmUgZHByaW50ZWQgamlmZmllcyBhbmQgaXQgbmV2ZXIgYWR2YW5jZXMgZHVyaW5n
IHRoZQogICAgbG9vcCBhdCBkb194b3Jfc3BlZWQuIFRoZXJlIGZvciBpdCBpcyBzdHVjayBp
biBhbiBlbmRsZXNzCiAgICBsb29wLiBJIGhhdmUgYWxzbyBkcHJpbnRlZCBjdXJyZW50X2tl
cm5lbF90aW1lKCkgYW5kIGl0CiAgICByZXR1cm5zIHRoZSBzYW1lIGNvbnN0YW50IHZhbHVl
IGFzIHdlbGwuCiAgICAKICAgIE5vdGUgdGhhdCBpdCBkb2VzIHVzdWFsbHkgd29yayBvbiBV
TUwsIG9ubHkgZHVyaW5nCiAgICB0aGUgbW9kcHJvYmUgb2YgeG9yLmtvIHdoaWxlIHRoYXQg
dGVzdCBpcyBydW5uaW5nLiBJdCBsb29rcwogICAgbGlrZSBzb21lIGx1Y2tpbmcgaXMgcHJl
dmVudGluZyB0aGUgY2xvY2sgZnJvbSB0aWNraW5nLgogICAgCiAgICBIb3dldmVyIGt0aW1l
X2dldF90cyBkb2VzIHdvcmsgZm9yIG1lIHNvIEkgY2hhbmdlZCB0aGUgY29kZQogICAgYXMg
YmVsb3csIHNvIEkgY2FuIHdvcmsuIFNlZSBob3cgSSBwdXQgc2V2ZXJhbCBzYWZldHkKICAg
IGd1YXJkcywgdG8gbmV2ZXIgZ2V0IGhhbmdzIGFnYWluLgogICAgQW5kIEkgdGhpbmsgbXkg
dGltZSBiYXNlZCBhcHByb2FjaCBpcyBtb3JlIGFjY3VyYXRlIHRoZW4KICAgIHByZXZpb3Vz
IHN5c3RlbS4KICAgIAogICAgVU1MIGd1eXMgcGxlYXNlIGludmVzdGlnYXRlIHRoZSBqaWZm
aWVzIGlzc3VlPyB3aGF0IGlzCiAgICB4b3Iua28gbm90IGRvaW5nIHJpZ2h0PwogICAgCiAg
ICBTaWduZWQtb2ZmLWJ5OiBCb2F6IEhhcnJvc2ggPGJoYXJyb3NoQHBhbmFzYXMuY29tPgoK
OjA0MDAwMCAwNDAwMDAgMzEyYzNlZDFkNGUzZjcxZTIyOGI0YTM2NjYzYzAxYzk0ZDFlMzYy
MSA0M2JiY2Q3YmJlYmU5OTA2Zjk3NTEzNmNiOWZiNWE0NjNlYmY1N2ViIE0JY3J5cHRvCjow
NDAwMDAgMDQwMDAwIDNkNDhjYzEzOTJmMTJlMTYzMDE5OTNlZTNlNzBlYWQ1NDAwZjlhYjkg
ZjYyYmFhOWI2MjI0ZWYzOWMzMjNjMGE1ZGRhMTU0YjAwODNkYmYxNiBNCWxpYgpiaXNlY3Qg
cnVuIHN1Y2Nlc3MKUHJldmlvdXMgSEVBRCBwb3NpdGlvbiB3YXMgNjBlODMzZC4uLiBSRkM6
IGRvX3hvcl9zcGVlZCBCcm9rZW4gb24gVU1MIGRvIHRvIGppZmZpZXMKSEVBRCBpcyBub3cg
YXQgYTdiNjA4My4uLiBvcmU6IFN1cHBvcnQgZm9yIHJhaWQgNgpscyAtYSAva2VybmVsLXRl
c3RzL3J1bi1xdWV1ZS9rdm0vaTM4Ni1yYW5kY29uZmlnLWZkMS0wNDA4L2xpbnV4LWRldmVs
OmRldmVsLWY0LWkzODYtMjAxNDA0MDgxMzU5OmE3YjYwODNiN2RmYTc5YzMxMDllMjAwMzE3
ZmUxOTBkN2I2MWQxZWI6YmlzZWN0LWxpbnV4NQoKMjAxNC0wNC0xMC0wMTo0OTo0MSBhN2I2
MDgzYjdkZmE3OWMzMTA5ZTIwMDMxN2ZlMTkwZDdiNjFkMWViIHJldXNlIC9rZXJuZWwvaTM4
Ni1yYW5kY29uZmlnLWZkMS0wNDA4L2E3YjYwODNiN2RmYTc5YzMxMDllMjAwMzE3ZmUxOTBk
N2I2MWQxZWIvdm1saW51ei0zLjE0LjAtcmM4LTAwMDA2LWdhN2I2MDgzCgoyMDE0LTA0LTEw
LTAxOjQ5OjQyIGRldGVjdGluZyBib290IHN0YXRlIC4uLgkyMwk2NC4uCTY1CTY2IFNVQ0NF
U1MKClByZXZpb3VzIEhFQUQgcG9zaXRpb24gd2FzIGE3YjYwODMuLi4gb3JlOiBTdXBwb3J0
IGZvciByYWlkIDYKSEVBRCBpcyBub3cgYXQgMTU4YjY4NS4uLiAwZGF5IGhlYWQgZ3VhcmQg
Zm9yICdkZXZlbC1mNC1pMzg2LTIwMTQwNDA4MTM1OScKbHMgLWEgL2tlcm5lbC10ZXN0cy9y
dW4tcXVldWUva3ZtL2kzODYtcmFuZGNvbmZpZy1mZDEtMDQwOC9saW51eC1kZXZlbDpkZXZl
bC1mNC1pMzg2LTIwMTQwNDA4MTM1OToxNThiNjg1NjI1NmVmMDE3MWMyYzdkYjgzODMyYjI0
OTg2MWU5ZDNiOmJpc2VjdC1saW51eDUKIFRFU1QgRkFJTFVSRQpbICAgIDAuMzEwNjkzXSB4
b3I6IHVzaW5nIGZ1bmN0aW9uOiBwSUlJX3NzZSAoMC4wOTEgTUIvc2VjKQpbICAgIDAuMzEx
NDIyXSAtLS0tLS0tLS0tLS1bIGN1dCBoZXJlIF0tLS0tLS0tLS0tLS0KWyAgICAwLjMxMTQy
Ml0gLS0tLS0tLS0tLS0tWyBjdXQgaGVyZSBdLS0tLS0tLS0tLS0tClsgICAgMC4zMTIwNzNd
IFdBUk5JTkc6IENQVTogMCBQSUQ6IDEgYXQgaW5pdC9tYWluLmM6NzA4IGRvX29uZV9pbml0
Y2FsbCsweDExZC8weDEzNigpCi9rZXJuZWwvaTM4Ni1yYW5kY29uZmlnLWZkMS0wNDA4LzE1
OGI2ODU2MjU2ZWYwMTcxYzJjN2RiODM4MzJiMjQ5ODYxZTlkM2IvZG1lc2cteW9jdG8tamFr
ZXRvd24tMzI6MjAxNDA0MDkyMzQwNDY6aTM4Ni1yYW5kY29uZmlnLWZkMS0wNDA4OjoKL2tl
cm5lbC9pMzg2LXJhbmRjb25maWctZmQxLTA0MDgvMTU4YjY4NTYyNTZlZjAxNzFjMmM3ZGI4
MzgzMmIyNDk4NjFlOWQzYi9kbWVzZy1xdWFudGFsLWxrcC1pYjA0LTQ4OjIwMTQwNDA5MjM0
MDEwOmkzODYtcmFuZGNvbmZpZy1mZDEtMDQwODozLjE0LjAtMDA0OTItZzE1OGI2ODU6MjEw
Ci9rZXJuZWwvaTM4Ni1yYW5kY29uZmlnLWZkMS0wNDA4LzE1OGI2ODU2MjU2ZWYwMTcxYzJj
N2RiODM4MzJiMjQ5ODYxZTlkM2IvZG1lc2ctcXVhbnRhbC1sa3AtaWIwNC01MToyMDE0MDQw
OTIzNDAzMDppMzg2LXJhbmRjb25maWctZmQxLTA0MDg6My4xNC4wLTAwNDkyLWcxNThiNjg1
OjIxMAova2VybmVsL2kzODYtcmFuZGNvbmZpZy1mZDEtMDQwOC8xNThiNjg1NjI1NmVmMDE3
MWMyYzdkYjgzODMyYjI0OTg2MWU5ZDNiL2RtZXNnLXF1YW50YWwtZjMtODA6MjAxNDA0MDky
MzQwMjU6aTM4Ni1yYW5kY29uZmlnLWZkMS0wNDA4OjMuMTQuMC0wMDQ5Mi1nMTU4YjY4NToy
MTAKL2tlcm5lbC9pMzg2LXJhbmRjb25maWctZmQxLTA0MDgvMTU4YjY4NTYyNTZlZjAxNzFj
MmM3ZGI4MzgzMmIyNDk4NjFlOWQzYi9kbWVzZy15b2N0by1sa3AtaWIwMy03OjIwMTQwNDA5
MjM0MDMxOmkzODYtcmFuZGNvbmZpZy1mZDEtMDQwODozLjE0LjAtMDA0OTItZzE1OGI2ODU6
MjEwCi9rZXJuZWwvaTM4Ni1yYW5kY29uZmlnLWZkMS0wNDA4LzE1OGI2ODU2MjU2ZWYwMTcx
YzJjN2RiODM4MzJiMjQ5ODYxZTlkM2IvZG1lc2ctcXVhbnRhbC1sa3AtaWIwMy03OjIwMTQw
NDA5MjM0MDA2OmkzODYtcmFuZGNvbmZpZy1mZDEtMDQwODozLjE0LjAtMDA0OTItZzE1OGI2
ODU6MjEwCi9rZXJuZWwvaTM4Ni1yYW5kY29uZmlnLWZkMS0wNDA4LzE1OGI2ODU2MjU2ZWYw
MTcxYzJjN2RiODM4MzJiMjQ5ODYxZTlkM2IvZG1lc2ctcXVhbnRhbC1sa3AtaWIwMy00Mzoy
MDE0MDQwOTIzNDAyMjppMzg2LXJhbmRjb25maWctZmQxLTA0MDg6My4xNC4wLTAwNDkyLWcx
NThiNjg1OjIxMAova2VybmVsL2kzODYtcmFuZGNvbmZpZy1mZDEtMDQwOC8xNThiNjg1NjI1
NmVmMDE3MWMyYzdkYjgzODMyYjI0OTg2MWU5ZDNiL2RtZXNnLXlvY3RvLWxrcC1pYjA0LTM1
OjIwMTQwNDA4MTU0OTA1OmkzODYtcmFuZGNvbmZpZy1mZDEtMDQwODozLjE0LjAtMDA0OTIt
ZzE1OGI2ODU6MjEwCi9rZXJuZWwvaTM4Ni1yYW5kY29uZmlnLWZkMS0wNDA4LzE1OGI2ODU2
MjU2ZWYwMTcxYzJjN2RiODM4MzJiMjQ5ODYxZTlkM2IvZG1lc2cteW9jdG8tbGtwLWliMDQt
NjA6MjAxNDA0MDgxNTUwMzI6aTM4Ni1yYW5kY29uZmlnLWZkMS0wNDA4OjMuMTQuMC0wMDQ5
Mi1nMTU4YjY4NToyMTAKL2tlcm5lbC9pMzg2LXJhbmRjb25maWctZmQxLTA0MDgvMTU4YjY4
NTYyNTZlZjAxNzFjMmM3ZGI4MzgzMmIyNDk4NjFlOWQzYi9kbWVzZy1xdWFudGFsLWxrcC1p
YjAzLTExMjoyMDE0MDQwOTIzNDAwNjppMzg2LXJhbmRjb25maWctZmQxLTA0MDg6My4xNC4w
LTAwNDkyLWcxNThiNjg1OjIxMAova2VybmVsL2kzODYtcmFuZGNvbmZpZy1mZDEtMDQwOC8x
NThiNjg1NjI1NmVmMDE3MWMyYzdkYjgzODMyYjI0OTg2MWU5ZDNiL2RtZXNnLXlvY3RvLWxr
cC1pYjAzLTI3OjIwMTQwNDA5MjM0MDMyOmkzODYtcmFuZGNvbmZpZy1mZDEtMDQwODozLjE0
LjAtMDA0OTItZzE1OGI2ODU6MjEwCi9rZXJuZWwvaTM4Ni1yYW5kY29uZmlnLWZkMS0wNDA4
LzE1OGI2ODU2MjU2ZWYwMTcxYzJjN2RiODM4MzJiMjQ5ODYxZTlkM2IvZG1lc2ctcXVhbnRh
bC1sa3AtaWIwMy01MzoyMDE0MDQwOTIzNDAxNzppMzg2LXJhbmRjb25maWctZmQxLTA0MDg6
My4xNC4wLTAwNDkyLWcxNThiNjg1OjIxMAowOjEyOjEzIGFsbF9nb29kOmJhZDphbGxfYmFk
IGJvb3RzCgpbZGV0YWNoZWQgSEVBRCBmY2U0MTAwXSBSZXZlcnQgIlJGQzogZG9feG9yX3Nw
ZWVkIEJyb2tlbiBvbiBVTUwgZG8gdG8gamlmZmllcyIKIDIgZmlsZXMgY2hhbmdlZCwgMzMg
aW5zZXJ0aW9ucygrKSwgNDYgZGVsZXRpb25zKC0pCmxzIC1hIC9rZXJuZWwtdGVzdHMvcnVu
LXF1ZXVlL2t2bS9pMzg2LXJhbmRjb25maWctZmQxLTA0MDgvbGludXgtZGV2ZWw6ZGV2ZWwt
ZjQtaTM4Ni0yMDE0MDQwODEzNTk6ZmNlNDEwMDIzZDM0ZDg4OTQ4YzMxNWNlYTk1ZmQ3YzFl
YTg3NDIzMDpiaXNlY3QtbGludXg1CgoyMDE0LTA0LTEwLTAxOjU0OjE3IGZjZTQxMDAyM2Qz
NGQ4ODk0OGMzMTVjZWE5NWZkN2MxZWE4NzQyMzAgY29tcGlsaW5nClF1ZXVlZCBidWlsZCB0
YXNrIHRvIC9rZXJuZWwtdGVzdHMvYnVpbGQtcXVldWUvaTM4Ni1yYW5kY29uZmlnLWZkMS0w
NDA4LWZjZTQxMDAyM2QzNGQ4ODk0OGMzMTVjZWE5NWZkN2MxZWE4NzQyMzAKQ2hlY2sgZm9y
IGtlcm5lbCBpbiAva2VybmVsL2kzODYtcmFuZGNvbmZpZy1mZDEtMDQwOC9mY2U0MTAwMjNk
MzRkODg5NDhjMzE1Y2VhOTVmZDdjMWVhODc0MjMwCndhaXRpbmcgZm9yIGNvbXBsZXRpb24g
b2YgL2tlcm5lbC10ZXN0cy9idWlsZC1xdWV1ZS9pMzg2LXJhbmRjb25maWctZmQxLTA0MDgt
ZmNlNDEwMDIzZDM0ZDg4OTQ4YzMxNWNlYTk1ZmQ3YzFlYTg3NDIzMAobWzE7MzVtMjAxNC0w
NC0xMCAwMTo1NToxNyBLZXJuZWwgYnVpbGQgZmFpbCBvciB0aW1lb3V0G1swbQoyMDE0LTA0
LTEwLTAxOjU1OjE3IGZjZTQxMDAyM2QzNGQ4ODk0OGMzMTVjZWE5NWZkN2MxZWE4NzQyMzAg
U0tJUCBCUk9LRU4gQlVJTEQKQ2hlY2sgL2tlcm5lbC10ZXN0cy9idWlsZC1zZXJ2ZWQvaTM4
Ni1yYW5kY29uZmlnLWZkMS0wNDA4LWZjZTQxMDAyM2QzNGQ4ODk0OGMzMTVjZWE5NWZkN2Mx
ZWE4NzQyMzAKCj09PT09PT09PSB1cHN0cmVhbSA9PT09PT09PT0KRnJvbSBnaXQ6Ly9naXRt
aXJyb3IvbGludXMKICAgNjljZDllYi4uMzlkZTY1YSAgbWFzdGVyICAgICAtPiBsaW51cy9t
YXN0ZXIKV2FybmluZzogeW91IGFyZSBsZWF2aW5nIDEgY29tbWl0IGJlaGluZCwgbm90IGNv
bm5lY3RlZCB0bwphbnkgb2YgeW91ciBicmFuY2hlczoKCiAgZmNlNDEwMCBSZXZlcnQgIlJG
QzogZG9feG9yX3NwZWVkIEJyb2tlbiBvbiBVTUwgZG8gdG8gamlmZmllcyIKCklmIHlvdSB3
YW50IHRvIGtlZXAgdGhlbSBieSBjcmVhdGluZyBhIG5ldyBicmFuY2gsIHRoaXMgbWF5IGJl
IGEgZ29vZCB0aW1lCnRvIGRvIHNvIHdpdGg6CgogZ2l0IGJyYW5jaCBuZXdfYnJhbmNoX25h
bWUgZmNlNDEwMAoKSEVBRCBpcyBub3cgYXQgMzlkZTY1YS4uLiBNZXJnZSBicmFuY2ggJ2ky
Yy9mb3ItbmV4dCcgb2YgZ2l0Oi8vZ2l0Lmtlcm5lbC5vcmcvcHViL3NjbS9saW51eC9rZXJu
ZWwvZ2l0L3dzYS9saW51eApscyAtYSAva2VybmVsLXRlc3RzL3J1bi1xdWV1ZS9rdm0vaTM4
Ni1yYW5kY29uZmlnLWZkMS0wNDA4L2xpbnVzOm1hc3RlcjozOWRlNjVhYTJjM2VlZTkwMWRi
MDIwYTRmMTM5Njk5OGUwOTYwMmEzOmJpc2VjdC1saW51eDUKCjIwMTQtMDQtMTAtMDE6NTU6
MjYgMzlkZTY1YWEyYzNlZWU5MDFkYjAyMGE0ZjEzOTY5OThlMDk2MDJhMyByZXVzZSAva2Vy
bmVsL2kzODYtcmFuZGNvbmZpZy1mZDEtMDQwOC8zOWRlNjVhYTJjM2VlZTkwMWRiMDIwYTRm
MTM5Njk5OGUwOTYwMmEzL3ZtbGludXotMy4xNC4wLTEyMjM2LWczOWRlNjVhCgoyMDE0LTA0
LTEwLTAxOjU1OjI2IGRldGVjdGluZyBib290IHN0YXRlIC4uLgkyMgk1Nwk2NAk2NQk2NiBT
VUNDRVNTCgoKPT09PT09PT09IGxpbnV4LW5leHQgPT09PT09PT09ClByZXZpb3VzIEhFQUQg
cG9zaXRpb24gd2FzIDM5ZGU2NWEuLi4gTWVyZ2UgYnJhbmNoICdpMmMvZm9yLW5leHQnIG9m
IGdpdDovL2dpdC5rZXJuZWwub3JnL3B1Yi9zY20vbGludXgva2VybmVsL2dpdC93c2EvbGlu
dXgKSEVBRCBpcyBub3cgYXQgMzVlMjkzMy4uLiBBZGQgbGludXgtbmV4dCBzcGVjaWZpYyBm
aWxlcyBmb3IgMjAxNDA0MDkKbHMgLWEgL2tlcm5lbC10ZXN0cy9ydW4tcXVldWUva3ZtL2kz
ODYtcmFuZGNvbmZpZy1mZDEtMDQwOC9uZXh0Om1hc3RlcjozNWUyOTMzY2E2OWVmMWI4MDYx
ZTVhZWUwOTA1MzU0MTAzMzZlMDYzOmJpc2VjdC1saW51eDUKCjIwMTQtMDQtMTAtMDE6NTk6
MjcgMzVlMjkzM2NhNjllZjFiODA2MWU1YWVlMDkwNTM1NDEwMzM2ZTA2MyBjb21waWxpbmcK
UXVldWVkIGJ1aWxkIHRhc2sgdG8gL2tlcm5lbC10ZXN0cy9idWlsZC1xdWV1ZS9pMzg2LXJh
bmRjb25maWctZmQxLTA0MDgtMzVlMjkzM2NhNjllZjFiODA2MWU1YWVlMDkwNTM1NDEwMzM2
ZTA2MwpDaGVjayBmb3Iga2VybmVsIGluIC9rZXJuZWwvaTM4Ni1yYW5kY29uZmlnLWZkMS0w
NDA4LzM1ZTI5MzNjYTY5ZWYxYjgwNjFlNWFlZTA5MDUzNTQxMDMzNmUwNjMKd2FpdGluZyBm
b3IgY29tcGxldGlvbiBvZiAva2VybmVsLXRlc3RzL2J1aWxkLXF1ZXVlL2kzODYtcmFuZGNv
bmZpZy1mZDEtMDQwOC0zNWUyOTMzY2E2OWVmMWI4MDYxZTVhZWUwOTA1MzU0MTAzMzZlMDYz
CndhaXRpbmcgZm9yIGNvbXBsZXRpb24gb2YgL2tlcm5lbC10ZXN0cy9idWlsZC1xdWV1ZS8u
aTM4Ni1yYW5kY29uZmlnLWZkMS0wNDA4LTM1ZTI5MzNjYTY5ZWYxYjgwNjFlNWFlZTA5MDUz
NTQxMDMzNmUwNjMKa2VybmVsOiAva2VybmVsL2kzODYtcmFuZGNvbmZpZy1mZDEtMDQwOC8z
NWUyOTMzY2E2OWVmMWI4MDYxZTVhZWUwOTA1MzU0MTAzMzZlMDYzL3ZtbGludXotMy4xNC4w
LW5leHQtMjAxNDA0MDkKCjIwMTQtMDQtMTAtMDI6MDM6MjcgZGV0ZWN0aW5nIGJvb3Qgc3Rh
dGUgLgk2MQk2NQk2NiBTVUNDRVNTCgo=

--a8Wt8u1KmwUX3Y2C
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="config-3.14.0-rc8-00007-g60e833d"

#
# Automatically generated file; DO NOT EDIT.
# Linux/i386 3.14.0-rc8 Kernel Configuration
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
# CONFIG_KERNEL_BZIP2 is not set
CONFIG_KERNEL_LZMA=y
# CONFIG_KERNEL_XZ is not set
# CONFIG_KERNEL_LZO is not set
# CONFIG_KERNEL_LZ4 is not set
CONFIG_DEFAULT_HOSTNAME="(none)"
# CONFIG_SWAP is not set
CONFIG_SYSVIPC=y
# CONFIG_POSIX_MQUEUE is not set
CONFIG_FHANDLE=y
CONFIG_AUDIT=y
# CONFIG_AUDITSYSCALL is not set

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
CONFIG_NO_HZ=y
CONFIG_HIGH_RES_TIMERS=y

#
# CPU/Task time and stats accounting
#
CONFIG_TICK_CPU_ACCOUNTING=y
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
CONFIG_RCU_FANOUT=32
CONFIG_RCU_FANOUT_LEAF=16
CONFIG_RCU_FANOUT_EXACT=y
CONFIG_RCU_FAST_NO_HZ=y
# CONFIG_TREE_RCU_TRACE is not set
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
# CONFIG_CGROUP_PERF is not set
CONFIG_CGROUP_SCHED=y
CONFIG_FAIR_GROUP_SCHED=y
# CONFIG_CFS_BANDWIDTH is not set
# CONFIG_RT_GROUP_SCHED is not set
CONFIG_BLK_CGROUP=y
CONFIG_DEBUG_BLK_CGROUP=y
# CONFIG_CHECKPOINT_RESTORE is not set
CONFIG_NAMESPACES=y
CONFIG_UTS_NS=y
CONFIG_IPC_NS=y
CONFIG_USER_NS=y
# CONFIG_PID_NS is not set
# CONFIG_NET_NS is not set
CONFIG_SCHED_AUTOGROUP=y
# CONFIG_SYSFS_DEPRECATED is not set
CONFIG_RELAY=y
CONFIG_BLK_DEV_INITRD=y
CONFIG_INITRAMFS_SOURCE=""
CONFIG_RD_GZIP=y
CONFIG_RD_BZIP2=y
# CONFIG_RD_LZMA is not set
# CONFIG_RD_XZ is not set
CONFIG_RD_LZO=y
# CONFIG_RD_LZ4 is not set
CONFIG_CC_OPTIMIZE_FOR_SIZE=y
CONFIG_ANON_INODES=y
CONFIG_HAVE_UID16=y
CONFIG_SYSCTL_EXCEPTION_TRACE=y
CONFIG_HAVE_PCSPKR_PLATFORM=y
CONFIG_EXPERT=y
CONFIG_UID16=y
CONFIG_KALLSYMS=y
CONFIG_KALLSYMS_ALL=y
CONFIG_PRINTK=y
CONFIG_BUG=y
# CONFIG_ELF_CORE is not set
CONFIG_PCSPKR_PLATFORM=y
CONFIG_BASE_FULL=y
CONFIG_FUTEX=y
CONFIG_EPOLL=y
# CONFIG_SIGNALFD is not set
CONFIG_TIMERFD=y
# CONFIG_EVENTFD is not set
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
CONFIG_SLUB_DEBUG=y
# CONFIG_COMPAT_BRK is not set
# CONFIG_SLAB is not set
CONFIG_SLUB=y
# CONFIG_SLOB is not set
# CONFIG_SLUB_CPU_PARTIAL is not set
# CONFIG_PROFILING is not set
CONFIG_TRACEPOINTS=y
CONFIG_HAVE_OPROFILE=y
CONFIG_OPROFILE_NMI_TIMER=y
CONFIG_JUMP_LABEL=y
CONFIG_UPROBES=y
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
CONFIG_HAVE_ALIGNED_STRUCT_PAGE=y
CONFIG_HAVE_CMPXCHG_LOCAL=y
CONFIG_HAVE_CMPXCHG_DOUBLE=y
CONFIG_ARCH_WANT_IPC_PARSE_VERSION=y
CONFIG_HAVE_ARCH_SECCOMP_FILTER=y
CONFIG_SECCOMP_FILTER=y
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
# CONFIG_MODULES is not set
CONFIG_BLOCK=y
CONFIG_LBDAF=y
CONFIG_BLK_DEV_BSG=y
CONFIG_BLK_DEV_BSGLIB=y
CONFIG_BLK_DEV_INTEGRITY=y
# CONFIG_BLK_DEV_THROTTLING is not set
# CONFIG_BLK_CMDLINE_PARSER is not set

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
# CONFIG_DEFAULT_DEADLINE is not set
CONFIG_DEFAULT_NOOP=y
CONFIG_DEFAULT_IOSCHED="noop"
CONFIG_PADATA=y
CONFIG_UNINLINE_SPIN_UNLOCK=y
# CONFIG_FREEZER is not set

#
# Processor type and features
#
CONFIG_ZONE_DMA=y
CONFIG_SMP=y
# CONFIG_X86_MPPARSE is not set
# CONFIG_X86_BIGSMP is not set
# CONFIG_X86_EXTENDED_PLATFORM is not set
# CONFIG_X86_INTEL_LPSS is not set
CONFIG_X86_SUPPORTS_MEMORY_FAILURE=y
CONFIG_X86_32_IRIS=y
# CONFIG_SCHED_OMIT_FRAME_POINTER is not set
CONFIG_HYPERVISOR_GUEST=y
CONFIG_PARAVIRT=y
# CONFIG_PARAVIRT_DEBUG is not set
CONFIG_PARAVIRT_SPINLOCKS=y
# CONFIG_XEN_PRIVILEGED_GUEST is not set
CONFIG_KVM_GUEST=y
# CONFIG_KVM_DEBUG_FS is not set
# CONFIG_LGUEST_GUEST is not set
CONFIG_PARAVIRT_TIME_ACCOUNTING=y
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
# CONFIG_X86_GENERIC is not set
CONFIG_X86_INTERNODE_CACHE_SHIFT=4
CONFIG_X86_L1_CACHE_SHIFT=4
# CONFIG_X86_PPRO_FENCE is not set
CONFIG_X86_F00F_BUG=y
CONFIG_X86_INVD_BUG=y
CONFIG_X86_ALIGNMENT_16=y
CONFIG_X86_MINIMUM_CPU_FAMILY=4
# CONFIG_PROCESSOR_SELECT is not set
CONFIG_CPU_SUP_INTEL=y
CONFIG_CPU_SUP_CYRIX_32=y
CONFIG_CPU_SUP_AMD=y
CONFIG_CPU_SUP_CENTAUR=y
CONFIG_CPU_SUP_TRANSMETA_32=y
CONFIG_CPU_SUP_UMC_32=y
CONFIG_HPET_TIMER=y
# CONFIG_DMI is not set
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
CONFIG_X86_MCE=y
# CONFIG_X86_MCE_INTEL is not set
CONFIG_X86_MCE_AMD=y
# CONFIG_X86_ANCIENT_MCE is not set
CONFIG_X86_MCE_THRESHOLD=y
# CONFIG_X86_MCE_INJECT is not set
CONFIG_VM86=y
CONFIG_TOSHIBA=y
# CONFIG_I8K is not set
CONFIG_X86_REBOOTFIXUPS=y
CONFIG_MICROCODE=y
# CONFIG_MICROCODE_INTEL is not set
# CONFIG_MICROCODE_AMD is not set
CONFIG_MICROCODE_OLD_INTERFACE=y
# CONFIG_MICROCODE_INTEL_EARLY is not set
# CONFIG_MICROCODE_AMD_EARLY is not set
# CONFIG_MICROCODE_EARLY is not set
CONFIG_X86_MSR=y
# CONFIG_X86_CPUID is not set
# CONFIG_NOHIGHMEM is not set
CONFIG_HIGHMEM4G=y
# CONFIG_VMSPLIT_3G is not set
# CONFIG_VMSPLIT_3G_OPT is not set
CONFIG_VMSPLIT_2G=y
# CONFIG_VMSPLIT_2G_OPT is not set
# CONFIG_VMSPLIT_1G is not set
CONFIG_PAGE_OFFSET=0x80000000
CONFIG_HIGHMEM=y
CONFIG_ARCH_FLATMEM_ENABLE=y
CONFIG_ARCH_SPARSEMEM_ENABLE=y
CONFIG_ARCH_SELECT_MEMORY_MODEL=y
CONFIG_ILLEGAL_POINTER_VALUE=0
CONFIG_SELECT_MEMORY_MODEL=y
CONFIG_FLATMEM_MANUAL=y
# CONFIG_SPARSEMEM_MANUAL is not set
CONFIG_FLATMEM=y
CONFIG_FLAT_NODE_MEM_MAP=y
CONFIG_SPARSEMEM_STATIC=y
CONFIG_HAVE_MEMBLOCK=y
CONFIG_HAVE_MEMBLOCK_NODE_MAP=y
CONFIG_ARCH_DISCARD_MEMBLOCK=y
CONFIG_MEMORY_ISOLATION=y
# CONFIG_HAVE_BOOTMEM_INFO_NODE is not set
CONFIG_PAGEFLAGS_EXTENDED=y
CONFIG_SPLIT_PTLOCK_CPUS=4
CONFIG_BALLOON_COMPACTION=y
CONFIG_COMPACTION=y
CONFIG_MIGRATION=y
# CONFIG_PHYS_ADDR_T_64BIT is not set
CONFIG_ZONE_DMA_FLAG=1
CONFIG_BOUNCE=y
CONFIG_NEED_BOUNCE_POOL=y
CONFIG_VIRT_TO_BUS=y
CONFIG_KSM=y
CONFIG_DEFAULT_MMAP_MIN_ADDR=4096
CONFIG_ARCH_SUPPORTS_MEMORY_FAILURE=y
# CONFIG_MEMORY_FAILURE is not set
CONFIG_TRANSPARENT_HUGEPAGE=y
CONFIG_TRANSPARENT_HUGEPAGE_ALWAYS=y
# CONFIG_TRANSPARENT_HUGEPAGE_MADVISE is not set
# CONFIG_CROSS_MEMORY_ATTACH is not set
# CONFIG_CLEANCACHE is not set
CONFIG_CMA=y
# CONFIG_CMA_DEBUG is not set
# CONFIG_ZBUD is not set
CONFIG_ZSMALLOC=y
# CONFIG_PGTABLE_MAPPING is not set
# CONFIG_HIGHPTE is not set
CONFIG_X86_CHECK_BIOS_CORRUPTION=y
CONFIG_X86_BOOTPARAM_MEMORY_CORRUPTION_CHECK=y
CONFIG_X86_RESERVE_LOW=64
# CONFIG_MATH_EMULATION is not set
# CONFIG_MTRR is not set
CONFIG_ARCH_RANDOM=y
CONFIG_X86_SMAP=y
# CONFIG_EFI is not set
CONFIG_SECCOMP=y
CONFIG_HZ_100=y
# CONFIG_HZ_250 is not set
# CONFIG_HZ_300 is not set
# CONFIG_HZ_1000 is not set
CONFIG_HZ=100
CONFIG_SCHED_HRTICK=y
CONFIG_KEXEC=y
CONFIG_CRASH_DUMP=y
CONFIG_PHYSICAL_START=0x1000000
CONFIG_RELOCATABLE=y
# CONFIG_RANDOMIZE_BASE is not set
CONFIG_X86_NEED_RELOCS=y
CONFIG_PHYSICAL_ALIGN=0x200000
# CONFIG_HOTPLUG_CPU is not set
CONFIG_COMPAT_VDSO=y
# CONFIG_CMDLINE_BOOL is not set
CONFIG_ARCH_ENABLE_MEMORY_HOTPLUG=y

#
# Power management and ACPI options
#
# CONFIG_SUSPEND is not set
CONFIG_PM_RUNTIME=y
CONFIG_PM=y
# CONFIG_PM_DEBUG is not set
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
# CONFIG_ACPI_PROCESSOR_AGGREGATOR is not set
CONFIG_ACPI_THERMAL=y
# CONFIG_ACPI_CUSTOM_DSDT is not set
# CONFIG_ACPI_INITRD_TABLE_OVERRIDE is not set
# CONFIG_ACPI_DEBUG is not set
# CONFIG_ACPI_PCI_SLOT is not set
CONFIG_X86_PM_TIMER=y
# CONFIG_ACPI_CONTAINER is not set
# CONFIG_ACPI_SBS is not set
# CONFIG_ACPI_HED is not set
# CONFIG_ACPI_CUSTOM_METHOD is not set
# CONFIG_ACPI_APEI is not set
# CONFIG_ACPI_EXTLOG is not set
CONFIG_SFI=y

#
# CPU Frequency scaling
#
CONFIG_CPU_FREQ=y
CONFIG_CPU_FREQ_GOV_COMMON=y
CONFIG_CPU_FREQ_STAT=y
CONFIG_CPU_FREQ_STAT_DETAILS=y
CONFIG_CPU_FREQ_DEFAULT_GOV_PERFORMANCE=y
# CONFIG_CPU_FREQ_DEFAULT_GOV_POWERSAVE is not set
# CONFIG_CPU_FREQ_DEFAULT_GOV_USERSPACE is not set
# CONFIG_CPU_FREQ_DEFAULT_GOV_ONDEMAND is not set
# CONFIG_CPU_FREQ_DEFAULT_GOV_CONSERVATIVE is not set
CONFIG_CPU_FREQ_GOV_PERFORMANCE=y
# CONFIG_CPU_FREQ_GOV_POWERSAVE is not set
CONFIG_CPU_FREQ_GOV_USERSPACE=y
CONFIG_CPU_FREQ_GOV_ONDEMAND=y
# CONFIG_CPU_FREQ_GOV_CONSERVATIVE is not set

#
# x86 CPU frequency scaling drivers
#
# CONFIG_X86_INTEL_PSTATE is not set
# CONFIG_X86_PCC_CPUFREQ is not set
# CONFIG_X86_ACPI_CPUFREQ is not set
# CONFIG_X86_POWERNOW_K6 is not set
CONFIG_X86_POWERNOW_K7=y
CONFIG_X86_POWERNOW_K7_ACPI=y
CONFIG_X86_GX_SUSPMOD=y
CONFIG_X86_SPEEDSTEP_CENTRINO=y
CONFIG_X86_SPEEDSTEP_CENTRINO_TABLE=y
CONFIG_X86_SPEEDSTEP_ICH=y
# CONFIG_X86_SPEEDSTEP_SMI is not set
# CONFIG_X86_P4_CLOCKMOD is not set
# CONFIG_X86_CPUFREQ_NFORCE2 is not set
# CONFIG_X86_LONGRUN is not set
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
# CONFIG_PCI_GOOLPC is not set
# CONFIG_PCI_GOANY is not set
CONFIG_PCI_BIOS=y
CONFIG_PCI_DOMAINS=y
# CONFIG_PCI_CNB20LE_QUIRK is not set
CONFIG_PCIEPORTBUS=y
# CONFIG_HOTPLUG_PCI_PCIE is not set
CONFIG_PCIEAER=y
# CONFIG_PCIE_ECRC is not set
# CONFIG_PCIEAER_INJECT is not set
# CONFIG_PCIEASPM is not set
CONFIG_PCIE_PME=y
CONFIG_PCI_MSI=y
# CONFIG_PCI_DEBUG is not set
# CONFIG_PCI_REALLOC_ENABLE_AUTO is not set
# CONFIG_PCI_STUB is not set
# CONFIG_HT_IRQ is not set
CONFIG_PCI_ATS=y
# CONFIG_PCI_IOV is not set
CONFIG_PCI_PRI=y
CONFIG_PCI_PASID=y
# CONFIG_PCI_IOAPIC is not set
CONFIG_PCI_LABEL=y

#
# PCI host controller drivers
#
CONFIG_ISA_DMA_API=y
# CONFIG_ISA is not set
# CONFIG_SCx200 is not set
CONFIG_OLPC=y
# CONFIG_OLPC_XO15_SCI is not set
# CONFIG_ALIX is not set
# CONFIG_NET5501 is not set
CONFIG_AMD_NB=y
CONFIG_PCCARD=y
# CONFIG_PCMCIA is not set
# CONFIG_CARDBUS is not set

#
# PC-card bridges
#
# CONFIG_YENTA is not set
CONFIG_HOTPLUG_PCI=y
# CONFIG_HOTPLUG_PCI_COMPAQ is not set
# CONFIG_HOTPLUG_PCI_IBM is not set
# CONFIG_HOTPLUG_PCI_ACPI is not set
CONFIG_HOTPLUG_PCI_CPCI=y
CONFIG_HOTPLUG_PCI_CPCI_ZT5550=y
CONFIG_HOTPLUG_PCI_CPCI_GENERIC=y
CONFIG_HOTPLUG_PCI_SHPC=y
CONFIG_RAPIDIO=y
CONFIG_RAPIDIO_TSI721=y
CONFIG_RAPIDIO_DISC_TIMEOUT=30
# CONFIG_RAPIDIO_ENABLE_RX_TX_PORTS is not set
# CONFIG_RAPIDIO_DMA_ENGINE is not set
CONFIG_RAPIDIO_DEBUG=y
CONFIG_RAPIDIO_ENUM_BASIC=y

#
# RapidIO Switch drivers
#
CONFIG_RAPIDIO_TSI57X=y
# CONFIG_RAPIDIO_CPS_XX is not set
# CONFIG_RAPIDIO_TSI568 is not set
# CONFIG_RAPIDIO_CPS_GEN2 is not set
# CONFIG_X86_SYSFB is not set

#
# Executable file formats / Emulations
#
CONFIG_BINFMT_ELF=y
CONFIG_ARCH_BINFMT_ELF_RANDOMIZE_PIE=y
CONFIG_BINFMT_SCRIPT=y
CONFIG_HAVE_AOUT=y
CONFIG_BINFMT_AOUT=y
CONFIG_BINFMT_MISC=y
CONFIG_COREDUMP=y
CONFIG_HAVE_ATOMIC_IOMAP=y
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
# CONFIG_XFRM_USER is not set
CONFIG_XFRM_SUB_POLICY=y
# CONFIG_XFRM_MIGRATE is not set
CONFIG_XFRM_IPCOMP=y
# CONFIG_NET_KEY is not set
CONFIG_INET=y
# CONFIG_IP_MULTICAST is not set
# CONFIG_IP_ADVANCED_ROUTER is not set
# CONFIG_IP_PNP is not set
CONFIG_NET_IPIP=y
CONFIG_NET_IPGRE_DEMUX=y
CONFIG_NET_IP_TUNNEL=y
CONFIG_NET_IPGRE=y
# CONFIG_SYN_COOKIES is not set
CONFIG_NET_IPVTI=y
# CONFIG_INET_AH is not set
# CONFIG_INET_ESP is not set
CONFIG_INET_IPCOMP=y
CONFIG_INET_XFRM_TUNNEL=y
CONFIG_INET_TUNNEL=y
CONFIG_INET_XFRM_MODE_TRANSPORT=y
CONFIG_INET_XFRM_MODE_TUNNEL=y
# CONFIG_INET_XFRM_MODE_BEET is not set
CONFIG_INET_LRO=y
CONFIG_INET_DIAG=y
CONFIG_INET_TCP_DIAG=y
# CONFIG_INET_UDP_DIAG is not set
# CONFIG_TCP_CONG_ADVANCED is not set
CONFIG_TCP_CONG_CUBIC=y
CONFIG_DEFAULT_TCP_CONG="cubic"
CONFIG_TCP_MD5SIG=y
# CONFIG_IPV6 is not set
CONFIG_NETWORK_SECMARK=y
# CONFIG_NETWORK_PHY_TIMESTAMPING is not set
# CONFIG_NETFILTER is not set
# CONFIG_IP_DCCP is not set
CONFIG_IP_SCTP=y
# CONFIG_SCTP_DEFAULT_COOKIE_HMAC_MD5 is not set
# CONFIG_SCTP_DEFAULT_COOKIE_HMAC_SHA1 is not set
CONFIG_SCTP_DEFAULT_COOKIE_HMAC_NONE=y
CONFIG_SCTP_COOKIE_HMAC_MD5=y
# CONFIG_SCTP_COOKIE_HMAC_SHA1 is not set
# CONFIG_RDS is not set
CONFIG_TIPC=y
CONFIG_TIPC_PORTS=8191
# CONFIG_ATM is not set
CONFIG_L2TP=y
# CONFIG_L2TP_DEBUGFS is not set
CONFIG_L2TP_V3=y
CONFIG_L2TP_IP=y
CONFIG_L2TP_ETH=y
CONFIG_STP=y
CONFIG_GARP=y
CONFIG_MRP=y
CONFIG_BRIDGE=y
CONFIG_BRIDGE_IGMP_SNOOPING=y
# CONFIG_BRIDGE_VLAN_FILTERING is not set
CONFIG_VLAN_8021Q=y
CONFIG_VLAN_8021Q_GVRP=y
CONFIG_VLAN_8021Q_MVRP=y
# CONFIG_DECNET is not set
CONFIG_LLC=y
CONFIG_LLC2=y
CONFIG_IPX=y
CONFIG_IPX_INTERN=y
# CONFIG_ATALK is not set
# CONFIG_X25 is not set
CONFIG_LAPB=y
CONFIG_PHONET=y
CONFIG_IEEE802154=y
CONFIG_MAC802154=y
# CONFIG_NET_SCHED is not set
CONFIG_DCB=y
# CONFIG_BATMAN_ADV is not set
CONFIG_OPENVSWITCH=y
CONFIG_OPENVSWITCH_GRE=y
CONFIG_VSOCKETS=y
# CONFIG_VMWARE_VMCI_VSOCKETS is not set
CONFIG_NETLINK_MMAP=y
# CONFIG_NETLINK_DIAG is not set
CONFIG_NET_MPLS_GSO=y
CONFIG_HSR=y
CONFIG_RPS=y
CONFIG_RFS_ACCEL=y
CONFIG_XPS=y
CONFIG_CGROUP_NET_PRIO=y
# CONFIG_CGROUP_NET_CLASSID is not set
CONFIG_NET_RX_BUSY_POLL=y
CONFIG_BQL=y
CONFIG_NET_FLOW_LIMIT=y

#
# Network testing
#
CONFIG_NET_DROP_MONITOR=y
CONFIG_HAMRADIO=y

#
# Packet Radio protocols
#
CONFIG_AX25=y
CONFIG_AX25_DAMA_SLAVE=y
# CONFIG_NETROM is not set
CONFIG_ROSE=y

#
# AX.25 network device drivers
#
CONFIG_MKISS=y
# CONFIG_6PACK is not set
CONFIG_BPQETHER=y
CONFIG_BAYCOM_SER_FDX=y
CONFIG_BAYCOM_SER_HDX=y
CONFIG_BAYCOM_PAR=y
# CONFIG_BAYCOM_EPP is not set
CONFIG_YAM=y
CONFIG_CAN=y
# CONFIG_CAN_RAW is not set
CONFIG_CAN_BCM=y
CONFIG_CAN_GW=y

#
# CAN Device Drivers
#
# CONFIG_CAN_VCAN is not set
CONFIG_CAN_SLCAN=y
CONFIG_CAN_DEV=y
# CONFIG_CAN_CALC_BITTIMING is not set
CONFIG_CAN_LEDS=y
CONFIG_PCH_CAN=y
# CONFIG_CAN_GRCAN is not set
CONFIG_CAN_SJA1000=y
CONFIG_CAN_SJA1000_ISA=y
CONFIG_CAN_SJA1000_PLATFORM=y
# CONFIG_CAN_SJA1000_OF_PLATFORM is not set
CONFIG_CAN_EMS_PCI=y
CONFIG_CAN_PEAK_PCI=y
# CONFIG_CAN_PEAK_PCIEC is not set
# CONFIG_CAN_KVASER_PCI is not set
CONFIG_CAN_PLX_PCI=y
CONFIG_CAN_C_CAN=y
CONFIG_CAN_C_CAN_PLATFORM=y
CONFIG_CAN_C_CAN_PCI=y
CONFIG_CAN_CC770=y
CONFIG_CAN_CC770_ISA=y
# CONFIG_CAN_CC770_PLATFORM is not set

#
# CAN USB interfaces
#
# CONFIG_CAN_EMS_USB is not set
CONFIG_CAN_ESD_USB2=y
CONFIG_CAN_KVASER_USB=y
CONFIG_CAN_PEAK_USB=y
CONFIG_CAN_8DEV_USB=y
CONFIG_CAN_SOFTING=y
# CONFIG_CAN_DEBUG_DEVICES is not set
# CONFIG_IRDA is not set
# CONFIG_BT is not set
# CONFIG_AF_RXRPC is not set
# CONFIG_WIRELESS is not set
CONFIG_WIMAX=y
CONFIG_WIMAX_DEBUG_LEVEL=8
CONFIG_RFKILL=y
CONFIG_RFKILL_LEDS=y
CONFIG_RFKILL_INPUT=y
CONFIG_RFKILL_REGULATOR=y
CONFIG_RFKILL_GPIO=y
CONFIG_NET_9P=y
CONFIG_NET_9P_VIRTIO=y
CONFIG_NET_9P_RDMA=y
# CONFIG_NET_9P_DEBUG is not set
CONFIG_CAIF=y
# CONFIG_CAIF_DEBUG is not set
# CONFIG_CAIF_NETDEV is not set
CONFIG_CAIF_USB=y
# CONFIG_CEPH_LIB is not set
CONFIG_NFC=y
# CONFIG_NFC_DIGITAL is not set
# CONFIG_NFC_NCI is not set
CONFIG_NFC_HCI=y
CONFIG_NFC_SHDLC=y

#
# Near Field Communication (NFC) devices
#
CONFIG_NFC_PN533=y
# CONFIG_NFC_SIM is not set
# CONFIG_NFC_PN544 is not set
# CONFIG_NFC_MICROREAD is not set

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
CONFIG_PREVENT_FIRMWARE_BUILD=y
CONFIG_FW_LOADER=y
CONFIG_FIRMWARE_IN_KERNEL=y
CONFIG_EXTRA_FIRMWARE=""
CONFIG_FW_LOADER_USER_HELPER=y
# CONFIG_DEBUG_DRIVER is not set
# CONFIG_DEBUG_DEVRES is not set
# CONFIG_SYS_HYPERVISOR is not set
# CONFIG_GENERIC_CPU_DEVICES is not set
CONFIG_REGMAP=y
CONFIG_REGMAP_I2C=y
CONFIG_REGMAP_MMIO=y
CONFIG_REGMAP_IRQ=y
CONFIG_DMA_SHARED_BUFFER=y
CONFIG_DMA_CMA=y

#
# Default contiguous memory area size:
#
CONFIG_CMA_SIZE_MBYTES=16
CONFIG_CMA_SIZE_SEL_MBYTES=y
# CONFIG_CMA_SIZE_SEL_PERCENTAGE is not set
# CONFIG_CMA_SIZE_SEL_MIN is not set
# CONFIG_CMA_SIZE_SEL_MAX is not set
CONFIG_CMA_ALIGNMENT=8
CONFIG_CMA_AREAS=7

#
# Bus devices
#
CONFIG_CONNECTOR=y
CONFIG_PROC_EVENTS=y
CONFIG_MTD=y
# CONFIG_MTD_REDBOOT_PARTS is not set
# CONFIG_MTD_CMDLINE_PARTS is not set
CONFIG_MTD_OF_PARTS=y
CONFIG_MTD_AR7_PARTS=y

#
# User Modules And Translation Layers
#
CONFIG_MTD_BLKDEVS=y
CONFIG_MTD_BLOCK=y
CONFIG_FTL=y
CONFIG_NFTL=y
# CONFIG_NFTL_RW is not set
CONFIG_INFTL=y
CONFIG_RFD_FTL=y
CONFIG_SSFDC=y
# CONFIG_SM_FTL is not set
# CONFIG_MTD_OOPS is not set

#
# RAM/ROM/Flash chip drivers
#
CONFIG_MTD_CFI=y
CONFIG_MTD_JEDECPROBE=y
CONFIG_MTD_GEN_PROBE=y
CONFIG_MTD_CFI_ADV_OPTIONS=y
# CONFIG_MTD_CFI_NOSWAP is not set
CONFIG_MTD_CFI_BE_BYTE_SWAP=y
# CONFIG_MTD_CFI_LE_BYTE_SWAP is not set
CONFIG_MTD_CFI_GEOMETRY=y
# CONFIG_MTD_MAP_BANK_WIDTH_1 is not set
CONFIG_MTD_MAP_BANK_WIDTH_2=y
CONFIG_MTD_MAP_BANK_WIDTH_4=y
CONFIG_MTD_MAP_BANK_WIDTH_8=y
CONFIG_MTD_MAP_BANK_WIDTH_16=y
# CONFIG_MTD_MAP_BANK_WIDTH_32 is not set
CONFIG_MTD_CFI_I1=y
# CONFIG_MTD_CFI_I2 is not set
# CONFIG_MTD_CFI_I4 is not set
# CONFIG_MTD_CFI_I8 is not set
# CONFIG_MTD_OTP is not set
CONFIG_MTD_CFI_INTELEXT=y
CONFIG_MTD_CFI_AMDSTD=y
# CONFIG_MTD_CFI_STAA is not set
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
# CONFIG_MTD_PHYSMAP_OF is not set
# CONFIG_MTD_SC520CDP is not set
# CONFIG_MTD_NETSC520 is not set
# CONFIG_MTD_TS5500 is not set
CONFIG_MTD_SBC_GXX=y
CONFIG_MTD_AMD76XROM=y
CONFIG_MTD_ICHXROM=y
# CONFIG_MTD_ESB2ROM is not set
CONFIG_MTD_CK804XROM=y
CONFIG_MTD_SCB2_FLASH=y
# CONFIG_MTD_NETtel is not set
CONFIG_MTD_L440GX=y
CONFIG_MTD_PCI=y
# CONFIG_MTD_GPIO_ADDR is not set
CONFIG_MTD_INTEL_VR_NOR=y
CONFIG_MTD_PLATRAM=y
CONFIG_MTD_LATCH_ADDR=y

#
# Self-contained MTD device drivers
#
CONFIG_MTD_PMC551=y
CONFIG_MTD_PMC551_BUGFIX=y
CONFIG_MTD_PMC551_DEBUG=y
# CONFIG_MTD_SLRAM is not set
CONFIG_MTD_PHRAM=y
CONFIG_MTD_MTDRAM=y
CONFIG_MTDRAM_TOTAL_SIZE=4096
CONFIG_MTDRAM_ERASE_SIZE=128
CONFIG_MTDRAM_ABS_POS=0
CONFIG_MTD_BLOCK2MTD=y

#
# Disk-On-Chip Device Drivers
#
# CONFIG_MTD_DOCG3 is not set
# CONFIG_MTD_NAND is not set
CONFIG_MTD_ONENAND=y
CONFIG_MTD_ONENAND_VERIFY_WRITE=y
CONFIG_MTD_ONENAND_GENERIC=y
# CONFIG_MTD_ONENAND_OTP is not set
CONFIG_MTD_ONENAND_2X_PROGRAM=y

#
# LPDDR flash memory drivers
#
# CONFIG_MTD_LPDDR is not set
CONFIG_MTD_UBI=y
CONFIG_MTD_UBI_WL_THRESHOLD=4096
CONFIG_MTD_UBI_BEB_LIMIT=20
CONFIG_MTD_UBI_FASTMAP=y
# CONFIG_MTD_UBI_GLUEBI is not set
CONFIG_OF=y

#
# Device Tree and Open Firmware support
#
# CONFIG_OF_SELFTEST is not set
CONFIG_OF_PROMTREE=y
CONFIG_OF_ADDRESS=y
CONFIG_OF_IRQ=y
CONFIG_OF_PCI=y
CONFIG_OF_PCI_IRQ=y
CONFIG_OF_MTD=y
CONFIG_PARPORT=y
CONFIG_ARCH_MIGHT_HAVE_PC_PARPORT=y
CONFIG_PARPORT_PC=y
CONFIG_PARPORT_SERIAL=y
# CONFIG_PARPORT_PC_FIFO is not set
# CONFIG_PARPORT_PC_SUPERIO is not set
# CONFIG_PARPORT_GSC is not set
CONFIG_PARPORT_AX88796=y
CONFIG_PARPORT_1284=y
CONFIG_PARPORT_NOT_PC=y
CONFIG_PNP=y
CONFIG_PNP_DEBUG_MESSAGES=y

#
# Protocols
#
CONFIG_PNPACPI=y
CONFIG_BLK_DEV=y
CONFIG_BLK_DEV_NULL_BLK=y
# CONFIG_BLK_DEV_FD is not set
# CONFIG_PARIDE is not set
CONFIG_BLK_DEV_PCIESSD_MTIP32XX=y
# CONFIG_ZRAM is not set
CONFIG_BLK_CPQ_CISS_DA=y
# CONFIG_BLK_DEV_DAC960 is not set
CONFIG_BLK_DEV_UMEM=y
# CONFIG_BLK_DEV_COW_COMMON is not set
# CONFIG_BLK_DEV_LOOP is not set

#
# DRBD disabled because PROC_FS or INET not selected
#
# CONFIG_BLK_DEV_NBD is not set
# CONFIG_BLK_DEV_NVME is not set
CONFIG_BLK_DEV_SX8=y
# CONFIG_BLK_DEV_RAM is not set
CONFIG_CDROM_PKTCDVD=y
CONFIG_CDROM_PKTCDVD_BUFFERS=8
CONFIG_CDROM_PKTCDVD_WCACHE=y
# CONFIG_ATA_OVER_ETH is not set
CONFIG_VIRTIO_BLK=y
CONFIG_BLK_DEV_HD=y
# CONFIG_BLK_DEV_RBD is not set
CONFIG_BLK_DEV_RSXX=y

#
# Misc devices
#
CONFIG_SENSORS_LIS3LV02D=y
CONFIG_AD525X_DPOT=y
CONFIG_AD525X_DPOT_I2C=y
CONFIG_DUMMY_IRQ=y
CONFIG_IBM_ASM=y
# CONFIG_PHANTOM is not set
# CONFIG_INTEL_MID_PTI is not set
CONFIG_SGI_IOC4=y
CONFIG_TIFM_CORE=y
CONFIG_TIFM_7XX1=y
# CONFIG_ICS932S401 is not set
# CONFIG_ATMEL_SSC is not set
# CONFIG_ENCLOSURE_SERVICES is not set
# CONFIG_CS5535_MFGPT is not set
CONFIG_HP_ILO=y
# CONFIG_APDS9802ALS is not set
CONFIG_ISL29003=y
CONFIG_ISL29020=y
CONFIG_SENSORS_TSL2550=y
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
CONFIG_C2PORT_DURAMAR_2150=y

#
# EEPROM support
#
CONFIG_EEPROM_AT24=y
# CONFIG_EEPROM_LEGACY is not set
CONFIG_EEPROM_MAX6875=y
# CONFIG_EEPROM_93CX6 is not set
CONFIG_CB710_CORE=y
CONFIG_CB710_DEBUG=y
CONFIG_CB710_DEBUG_ASSUMPTIONS=y

#
# Texas Instruments shared transport line discipline
#
CONFIG_TI_ST=y
CONFIG_SENSORS_LIS3_I2C=y

#
# Altera FPGA firmware download module
#
CONFIG_ALTERA_STAPL=y
CONFIG_VMWARE_VMCI=y

#
# Intel MIC Host Driver
#

#
# Intel MIC Card Driver
#
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
CONFIG_IDE_TASK_IOCTL=y

#
# IDE chipset support/bugfixes
#
CONFIG_IDE_GENERIC=y
# CONFIG_BLK_DEV_PLATFORM is not set
CONFIG_BLK_DEV_CMD640=y
CONFIG_BLK_DEV_CMD640_ENHANCED=y
# CONFIG_BLK_DEV_IDEPNP is not set
CONFIG_BLK_DEV_IDEDMA_SFF=y

#
# PCI IDE chipsets support
#
CONFIG_BLK_DEV_IDEPCI=y
# CONFIG_IDEPCI_PCIBUS_ORDER is not set
CONFIG_BLK_DEV_OFFBOARD=y
CONFIG_BLK_DEV_GENERIC=y
CONFIG_BLK_DEV_OPTI621=y
# CONFIG_BLK_DEV_RZ1000 is not set
CONFIG_BLK_DEV_IDEDMA_PCI=y
# CONFIG_BLK_DEV_AEC62XX is not set
CONFIG_BLK_DEV_ALI15X3=y
CONFIG_BLK_DEV_AMD74XX=y
CONFIG_BLK_DEV_ATIIXP=y
# CONFIG_BLK_DEV_CMD64X is not set
CONFIG_BLK_DEV_TRIFLEX=y
# CONFIG_BLK_DEV_CS5520 is not set
CONFIG_BLK_DEV_CS5530=y
# CONFIG_BLK_DEV_CS5535 is not set
# CONFIG_BLK_DEV_CS5536 is not set
CONFIG_BLK_DEV_HPT366=y
# CONFIG_BLK_DEV_JMICRON is not set
CONFIG_BLK_DEV_SC1200=y
CONFIG_BLK_DEV_PIIX=y
CONFIG_BLK_DEV_IT8172=y
# CONFIG_BLK_DEV_IT8213 is not set
# CONFIG_BLK_DEV_IT821X is not set
CONFIG_BLK_DEV_NS87415=y
CONFIG_BLK_DEV_PDC202XX_OLD=y
CONFIG_BLK_DEV_PDC202XX_NEW=y
CONFIG_BLK_DEV_SVWKS=y
CONFIG_BLK_DEV_SIIMAGE=y
# CONFIG_BLK_DEV_SIS5513 is not set
CONFIG_BLK_DEV_SLC90E66=y
CONFIG_BLK_DEV_TRM290=y
CONFIG_BLK_DEV_VIA82CXXX=y
# CONFIG_BLK_DEV_TC86C001 is not set
CONFIG_BLK_DEV_IDEDMA=y

#
# SCSI device support
#
CONFIG_SCSI_MOD=y
CONFIG_RAID_ATTRS=y
# CONFIG_SCSI is not set
# CONFIG_SCSI_DMA is not set
# CONFIG_SCSI_NETLINK is not set
# CONFIG_ATA is not set
CONFIG_MD=y
# CONFIG_BLK_DEV_MD is not set
CONFIG_BCACHE=y
# CONFIG_BCACHE_DEBUG is not set
# CONFIG_BCACHE_CLOSURES_DEBUG is not set
# CONFIG_BLK_DEV_DM is not set
CONFIG_FUSION=y
CONFIG_FUSION_MAX_SGE=128
CONFIG_FUSION_LOGGING=y

#
# IEEE 1394 (FireWire) support
#
# CONFIG_FIREWIRE is not set
CONFIG_FIREWIRE_NOSY=y
CONFIG_I2O=y
# CONFIG_I2O_LCT_NOTIFY_ON_CHANGES is not set
# CONFIG_I2O_EXT_ADAPTEC is not set
CONFIG_I2O_CONFIG=y
CONFIG_I2O_CONFIG_OLD_IOCTL=y
CONFIG_I2O_BUS=y
# CONFIG_I2O_BLOCK is not set
CONFIG_I2O_PROC=y
CONFIG_MACINTOSH_DRIVERS=y
# CONFIG_NETDEVICES is not set

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
# CONFIG_INPUT_MOUSEDEV is not set
# CONFIG_INPUT_JOYDEV is not set
CONFIG_INPUT_EVDEV=y
CONFIG_INPUT_EVBUG=y

#
# Input Device Drivers
#
CONFIG_INPUT_KEYBOARD=y
CONFIG_KEYBOARD_ADP5588=y
CONFIG_KEYBOARD_ADP5589=y
CONFIG_KEYBOARD_ATKBD=y
CONFIG_KEYBOARD_QT1070=y
# CONFIG_KEYBOARD_QT2160 is not set
CONFIG_KEYBOARD_LKKBD=y
CONFIG_KEYBOARD_GPIO=y
CONFIG_KEYBOARD_GPIO_POLLED=y
CONFIG_KEYBOARD_TCA6416=y
CONFIG_KEYBOARD_TCA8418=y
# CONFIG_KEYBOARD_MATRIX is not set
# CONFIG_KEYBOARD_LM8323 is not set
# CONFIG_KEYBOARD_LM8333 is not set
CONFIG_KEYBOARD_MAX7359=y
CONFIG_KEYBOARD_MCS=y
# CONFIG_KEYBOARD_MPR121 is not set
# CONFIG_KEYBOARD_NEWTON is not set
# CONFIG_KEYBOARD_OPENCORES is not set
CONFIG_KEYBOARD_STOWAWAY=y
# CONFIG_KEYBOARD_SUNKBD is not set
CONFIG_KEYBOARD_SH_KEYSC=y
CONFIG_KEYBOARD_STMPE=y
CONFIG_KEYBOARD_TC3589X=y
# CONFIG_KEYBOARD_TWL4030 is not set
# CONFIG_KEYBOARD_XTKBD is not set
CONFIG_INPUT_MOUSE=y
CONFIG_MOUSE_PS2=y
CONFIG_MOUSE_PS2_ALPS=y
CONFIG_MOUSE_PS2_LOGIPS2PP=y
# CONFIG_MOUSE_PS2_SYNAPTICS is not set
CONFIG_MOUSE_PS2_CYPRESS=y
CONFIG_MOUSE_PS2_TRACKPOINT=y
# CONFIG_MOUSE_PS2_ELANTECH is not set
# CONFIG_MOUSE_PS2_SENTELIC is not set
CONFIG_MOUSE_PS2_TOUCHKIT=y
CONFIG_MOUSE_PS2_OLPC=y
CONFIG_MOUSE_SERIAL=y
CONFIG_MOUSE_APPLETOUCH=y
CONFIG_MOUSE_BCM5974=y
# CONFIG_MOUSE_CYAPA is not set
# CONFIG_MOUSE_VSXXXAA is not set
CONFIG_MOUSE_GPIO=y
# CONFIG_MOUSE_SYNAPTICS_I2C is not set
# CONFIG_MOUSE_SYNAPTICS_USB is not set
CONFIG_INPUT_JOYSTICK=y
# CONFIG_JOYSTICK_ANALOG is not set
CONFIG_JOYSTICK_A3D=y
CONFIG_JOYSTICK_ADI=y
# CONFIG_JOYSTICK_COBRA is not set
# CONFIG_JOYSTICK_GF2K is not set
CONFIG_JOYSTICK_GRIP=y
# CONFIG_JOYSTICK_GRIP_MP is not set
# CONFIG_JOYSTICK_GUILLEMOT is not set
# CONFIG_JOYSTICK_INTERACT is not set
# CONFIG_JOYSTICK_SIDEWINDER is not set
CONFIG_JOYSTICK_TMDC=y
CONFIG_JOYSTICK_IFORCE=y
CONFIG_JOYSTICK_IFORCE_USB=y
CONFIG_JOYSTICK_IFORCE_232=y
CONFIG_JOYSTICK_WARRIOR=y
CONFIG_JOYSTICK_MAGELLAN=y
CONFIG_JOYSTICK_SPACEORB=y
CONFIG_JOYSTICK_SPACEBALL=y
# CONFIG_JOYSTICK_STINGER is not set
CONFIG_JOYSTICK_TWIDJOY=y
CONFIG_JOYSTICK_ZHENHUA=y
CONFIG_JOYSTICK_DB9=y
CONFIG_JOYSTICK_GAMECON=y
# CONFIG_JOYSTICK_TURBOGRAFX is not set
CONFIG_JOYSTICK_AS5011=y
CONFIG_JOYSTICK_JOYDUMP=y
CONFIG_JOYSTICK_XPAD=y
# CONFIG_JOYSTICK_XPAD_FF is not set
# CONFIG_JOYSTICK_XPAD_LEDS is not set
CONFIG_JOYSTICK_WALKERA0701=y
# CONFIG_INPUT_TABLET is not set
CONFIG_INPUT_TOUCHSCREEN=y
CONFIG_TOUCHSCREEN_88PM860X=y
CONFIG_TOUCHSCREEN_AD7879=y
CONFIG_TOUCHSCREEN_AD7879_I2C=y
CONFIG_TOUCHSCREEN_ATMEL_MXT=y
CONFIG_TOUCHSCREEN_AUO_PIXCIR=y
CONFIG_TOUCHSCREEN_BU21013=y
# CONFIG_TOUCHSCREEN_CY8CTMG110 is not set
CONFIG_TOUCHSCREEN_CYTTSP_CORE=y
# CONFIG_TOUCHSCREEN_CYTTSP_I2C is not set
CONFIG_TOUCHSCREEN_CYTTSP4_CORE=y
CONFIG_TOUCHSCREEN_CYTTSP4_I2C=y
CONFIG_TOUCHSCREEN_DA9034=y
# CONFIG_TOUCHSCREEN_DA9052 is not set
CONFIG_TOUCHSCREEN_DYNAPRO=y
# CONFIG_TOUCHSCREEN_HAMPSHIRE is not set
# CONFIG_TOUCHSCREEN_EETI is not set
# CONFIG_TOUCHSCREEN_EGALAX is not set
CONFIG_TOUCHSCREEN_FUJITSU=y
# CONFIG_TOUCHSCREEN_ILI210X is not set
CONFIG_TOUCHSCREEN_GUNZE=y
# CONFIG_TOUCHSCREEN_ELO is not set
CONFIG_TOUCHSCREEN_WACOM_W8001=y
# CONFIG_TOUCHSCREEN_WACOM_I2C is not set
CONFIG_TOUCHSCREEN_MAX11801=y
# CONFIG_TOUCHSCREEN_MCS5000 is not set
CONFIG_TOUCHSCREEN_MMS114=y
CONFIG_TOUCHSCREEN_MTOUCH=y
CONFIG_TOUCHSCREEN_INEXIO=y
CONFIG_TOUCHSCREEN_MK712=y
CONFIG_TOUCHSCREEN_PENMOUNT=y
CONFIG_TOUCHSCREEN_EDT_FT5X06=y
CONFIG_TOUCHSCREEN_TOUCHRIGHT=y
# CONFIG_TOUCHSCREEN_TOUCHWIN is not set
# CONFIG_TOUCHSCREEN_PIXCIR is not set
# CONFIG_TOUCHSCREEN_WM831X is not set
# CONFIG_TOUCHSCREEN_USB_COMPOSITE is not set
CONFIG_TOUCHSCREEN_MC13783=y
CONFIG_TOUCHSCREEN_TOUCHIT213=y
# CONFIG_TOUCHSCREEN_TSC_SERIO is not set
# CONFIG_TOUCHSCREEN_TSC2007 is not set
# CONFIG_TOUCHSCREEN_ST1232 is not set
CONFIG_TOUCHSCREEN_STMPE=y
CONFIG_TOUCHSCREEN_SUR40=y
CONFIG_TOUCHSCREEN_TPS6507X=y
# CONFIG_TOUCHSCREEN_ZFORCE is not set
CONFIG_INPUT_MISC=y
CONFIG_INPUT_88PM860X_ONKEY=y
CONFIG_INPUT_AD714X=y
# CONFIG_INPUT_AD714X_I2C is not set
# CONFIG_INPUT_BMA150 is not set
CONFIG_INPUT_PCSPKR=y
CONFIG_INPUT_MC13783_PWRBUTTON=y
# CONFIG_INPUT_MMA8450 is not set
# CONFIG_INPUT_MPU3050 is not set
CONFIG_INPUT_APANEL=y
CONFIG_INPUT_GP2A=y
CONFIG_INPUT_GPIO_BEEPER=y
# CONFIG_INPUT_GPIO_TILT_POLLED is not set
CONFIG_INPUT_WISTRON_BTNS=y
# CONFIG_INPUT_ATLAS_BTNS is not set
# CONFIG_INPUT_ATI_REMOTE2 is not set
CONFIG_INPUT_KEYSPAN_REMOTE=y
CONFIG_INPUT_KXTJ9=y
CONFIG_INPUT_KXTJ9_POLLED_MODE=y
# CONFIG_INPUT_POWERMATE is not set
CONFIG_INPUT_YEALINK=y
CONFIG_INPUT_CM109=y
CONFIG_INPUT_TWL4030_PWRBUTTON=y
# CONFIG_INPUT_TWL4030_VIBRA is not set
# CONFIG_INPUT_UINPUT is not set
# CONFIG_INPUT_PCF50633_PMU is not set
# CONFIG_INPUT_PCF8574 is not set
CONFIG_INPUT_GPIO_ROTARY_ENCODER=y
CONFIG_INPUT_DA9052_ONKEY=y
CONFIG_INPUT_DA9055_ONKEY=y
# CONFIG_INPUT_WM831X_ON is not set
# CONFIG_INPUT_ADXL34X is not set
# CONFIG_INPUT_IMS_PCU is not set
CONFIG_INPUT_CMA3000=y
CONFIG_INPUT_CMA3000_I2C=y
CONFIG_INPUT_IDEAPAD_SLIDEBAR=y

#
# Hardware I/O ports
#
CONFIG_SERIO=y
CONFIG_ARCH_MIGHT_HAVE_PC_SERIO=y
CONFIG_SERIO_I8042=y
CONFIG_SERIO_SERPORT=y
CONFIG_SERIO_CT82C710=y
CONFIG_SERIO_PARKBD=y
CONFIG_SERIO_PCIPS2=y
CONFIG_SERIO_LIBPS2=y
# CONFIG_SERIO_RAW is not set
CONFIG_SERIO_ALTERA_PS2=y
# CONFIG_SERIO_PS2MULT is not set
CONFIG_SERIO_ARC_PS2=y
CONFIG_SERIO_APBPS2=y
CONFIG_SERIO_OLPC_APSP=y
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
CONFIG_SERIAL_NONSTANDARD=y
CONFIG_ROCKETPORT=y
CONFIG_CYCLADES=y
CONFIG_CYZ_INTR=y
# CONFIG_MOXA_INTELLIO is not set
CONFIG_MOXA_SMARTIO=y
CONFIG_SYNCLINK=y
# CONFIG_SYNCLINKMP is not set
CONFIG_SYNCLINK_GT=y
CONFIG_NOZOMI=y
CONFIG_ISI=y
CONFIG_N_HDLC=y
# CONFIG_N_GSM is not set
CONFIG_TRACE_ROUTER=y
CONFIG_TRACE_SINK=y
CONFIG_DEVKMEM=y

#
# Serial drivers
#
CONFIG_SERIAL_8250=y
CONFIG_SERIAL_8250_DEPRECATED_OPTIONS=y
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
# CONFIG_SERIAL_CLPS711X is not set
CONFIG_SERIAL_MFD_HSU=y
# CONFIG_SERIAL_MFD_HSU_CONSOLE is not set
CONFIG_SERIAL_CORE=y
CONFIG_SERIAL_CORE_CONSOLE=y
# CONFIG_SERIAL_JSM is not set
CONFIG_SERIAL_OF_PLATFORM=y
CONFIG_SERIAL_SCCNXP=y
CONFIG_SERIAL_SCCNXP_CONSOLE=y
CONFIG_SERIAL_TIMBERDALE=y
# CONFIG_SERIAL_ALTERA_JTAGUART is not set
CONFIG_SERIAL_ALTERA_UART=y
CONFIG_SERIAL_ALTERA_UART_MAXPORTS=4
CONFIG_SERIAL_ALTERA_UART_BAUDRATE=115200
# CONFIG_SERIAL_ALTERA_UART_CONSOLE is not set
CONFIG_SERIAL_PCH_UART=y
CONFIG_SERIAL_PCH_UART_CONSOLE=y
CONFIG_SERIAL_XILINX_PS_UART=y
# CONFIG_SERIAL_XILINX_PS_UART_CONSOLE is not set
CONFIG_SERIAL_ARC=y
CONFIG_SERIAL_ARC_CONSOLE=y
CONFIG_SERIAL_ARC_NR_PORTS=1
CONFIG_SERIAL_RP2=y
CONFIG_SERIAL_RP2_NR_UARTS=32
CONFIG_SERIAL_FSL_LPUART=y
CONFIG_SERIAL_FSL_LPUART_CONSOLE=y
CONFIG_SERIAL_ST_ASC=y
CONFIG_SERIAL_ST_ASC_CONSOLE=y
# CONFIG_TTY_PRINTK is not set
CONFIG_PRINTER=y
CONFIG_LP_CONSOLE=y
CONFIG_PPDEV=y
# CONFIG_VIRTIO_CONSOLE is not set
CONFIG_IPMI_HANDLER=y
CONFIG_IPMI_PANIC_EVENT=y
# CONFIG_IPMI_PANIC_STRING is not set
# CONFIG_IPMI_DEVICE_INTERFACE is not set
CONFIG_IPMI_SI=y
CONFIG_IPMI_WATCHDOG=y
CONFIG_IPMI_POWEROFF=y
CONFIG_HW_RANDOM=y
# CONFIG_HW_RANDOM_TIMERIOMEM is not set
CONFIG_HW_RANDOM_INTEL=y
# CONFIG_HW_RANDOM_AMD is not set
CONFIG_HW_RANDOM_GEODE=y
# CONFIG_HW_RANDOM_VIA is not set
CONFIG_HW_RANDOM_VIRTIO=y
CONFIG_HW_RANDOM_TPM=y
# CONFIG_NVRAM is not set
CONFIG_R3964=y
# CONFIG_APPLICOM is not set
CONFIG_SONYPI=y
CONFIG_MWAVE=y
CONFIG_PC8736x_GPIO=y
CONFIG_NSC_GPIO=y
CONFIG_RAW_DRIVER=y
CONFIG_MAX_RAW_DEVS=256
# CONFIG_HPET is not set
# CONFIG_HANGCHECK_TIMER is not set
CONFIG_TCG_TPM=y
CONFIG_TCG_TIS=y
CONFIG_TCG_TIS_I2C_ATMEL=y
# CONFIG_TCG_TIS_I2C_INFINEON is not set
CONFIG_TCG_TIS_I2C_NUVOTON=y
CONFIG_TCG_NSC=y
CONFIG_TCG_ATMEL=y
# CONFIG_TCG_INFINEON is not set
# CONFIG_TCG_ST33_I2C is not set
CONFIG_TELCLOCK=y
CONFIG_DEVPORT=y
CONFIG_I2C=y
CONFIG_I2C_BOARDINFO=y
# CONFIG_I2C_COMPAT is not set
CONFIG_I2C_CHARDEV=y
CONFIG_I2C_MUX=y

#
# Multiplexer I2C Chip support
#
CONFIG_I2C_ARB_GPIO_CHALLENGE=y
# CONFIG_I2C_MUX_GPIO is not set
# CONFIG_I2C_MUX_PCA9541 is not set
CONFIG_I2C_MUX_PCA954x=y
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
CONFIG_I2C_ALI15X3=y
CONFIG_I2C_AMD756=y
CONFIG_I2C_AMD756_S4882=y
CONFIG_I2C_AMD8111=y
# CONFIG_I2C_I801 is not set
CONFIG_I2C_ISCH=y
# CONFIG_I2C_ISMT is not set
CONFIG_I2C_PIIX4=y
CONFIG_I2C_NFORCE2=y
CONFIG_I2C_NFORCE2_S4985=y
CONFIG_I2C_SIS5595=y
CONFIG_I2C_SIS630=y
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
# CONFIG_I2C_CBUS_GPIO is not set
CONFIG_I2C_DESIGNWARE_CORE=y
CONFIG_I2C_DESIGNWARE_PLATFORM=y
CONFIG_I2C_DESIGNWARE_PCI=y
CONFIG_I2C_EG20T=y
CONFIG_I2C_GPIO=y
CONFIG_I2C_OCORES=y
CONFIG_I2C_PCA_PLATFORM=y
# CONFIG_I2C_PXA is not set
# CONFIG_I2C_PXA_PCI is not set
CONFIG_I2C_RIIC=y
CONFIG_I2C_SH_MOBILE=y
CONFIG_I2C_SIMTEC=y
CONFIG_I2C_XILINX=y
CONFIG_I2C_RCAR=y

#
# External I2C/SMBus adapter drivers
#
# CONFIG_I2C_DIOLAN_U2C is not set
# CONFIG_I2C_PARPORT is not set
CONFIG_I2C_PARPORT_LIGHT=y
# CONFIG_I2C_ROBOTFUZZ_OSIF is not set
CONFIG_I2C_TAOS_EVM=y
# CONFIG_I2C_TINY_USB is not set
CONFIG_I2C_VIPERBOARD=y

#
# Other I2C/SMBus bus drivers
#
CONFIG_SCx200_ACB=y
# CONFIG_I2C_DEBUG_CORE is not set
# CONFIG_I2C_DEBUG_ALGO is not set
# CONFIG_I2C_DEBUG_BUS is not set
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
# CONFIG_PPS is not set

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
CONFIG_GPIOLIB=y
CONFIG_GPIO_DEVRES=y
CONFIG_OF_GPIO=y
CONFIG_GPIO_ACPI=y
CONFIG_DEBUG_GPIO=y
# CONFIG_GPIO_SYSFS is not set
CONFIG_GPIO_GENERIC=y
# CONFIG_GPIO_DA9052 is not set
CONFIG_GPIO_DA9055=y
CONFIG_GPIO_MAX730X=y

#
# Memory mapped GPIO drivers:
#
CONFIG_GPIO_CLPS711X=y
CONFIG_GPIO_GENERIC_PLATFORM=y
CONFIG_GPIO_IT8761E=y
# CONFIG_GPIO_F7188X is not set
# CONFIG_GPIO_SCH311X is not set
# CONFIG_GPIO_TS5500 is not set
CONFIG_GPIO_SCH=y
CONFIG_GPIO_ICH=y
CONFIG_GPIO_VX855=y
# CONFIG_GPIO_LYNXPOINT is not set
# CONFIG_GPIO_GRGPIO is not set

#
# I2C GPIO expanders:
#
# CONFIG_GPIO_LP3943 is not set
CONFIG_GPIO_MAX7300=y
CONFIG_GPIO_MAX732X=y
# CONFIG_GPIO_MAX732X_IRQ is not set
CONFIG_GPIO_PCA953X=y
CONFIG_GPIO_PCA953X_IRQ=y
CONFIG_GPIO_PCF857X=y
CONFIG_GPIO_RC5T583=y
# CONFIG_GPIO_SX150X is not set
CONFIG_GPIO_STMPE=y
# CONFIG_GPIO_TC3589X is not set
# CONFIG_GPIO_TWL4030 is not set
# CONFIG_GPIO_WM831X is not set
CONFIG_GPIO_WM8350=y
CONFIG_GPIO_WM8994=y
CONFIG_GPIO_ADP5588=y
CONFIG_GPIO_ADP5588_IRQ=y
CONFIG_GPIO_ADNP=y

#
# PCI GPIO expanders:
#
# CONFIG_GPIO_CS5535 is not set
CONFIG_GPIO_BT8XX=y
CONFIG_GPIO_AMD8111=y
# CONFIG_GPIO_INTEL_MID is not set
CONFIG_GPIO_PCH=y
# CONFIG_GPIO_ML_IOH is not set
# CONFIG_GPIO_SODAVILLE is not set
CONFIG_GPIO_RDC321X=y

#
# SPI GPIO expanders:
#
# CONFIG_GPIO_MCP23S08 is not set

#
# AC97 GPIO expanders:
#

#
# LPC GPIO expanders:
#

#
# MODULbus GPIO expanders:
#
# CONFIG_GPIO_PALMAS is not set
CONFIG_GPIO_TPS65910=y
CONFIG_GPIO_BCM_KONA=y

#
# USB GPIO expanders:
#
CONFIG_GPIO_VIPERBOARD=y
CONFIG_W1=y
CONFIG_W1_CON=y

#
# 1-wire Bus Masters
#
CONFIG_W1_MASTER_MATROX=y
CONFIG_W1_MASTER_DS2490=y
CONFIG_W1_MASTER_DS2482=y
CONFIG_W1_MASTER_DS1WM=y
CONFIG_W1_MASTER_GPIO=y

#
# 1-wire Slaves
#
CONFIG_W1_SLAVE_THERM=y
# CONFIG_W1_SLAVE_SMEM is not set
# CONFIG_W1_SLAVE_DS2408 is not set
CONFIG_W1_SLAVE_DS2413=y
# CONFIG_W1_SLAVE_DS2423 is not set
# CONFIG_W1_SLAVE_DS2431 is not set
CONFIG_W1_SLAVE_DS2433=y
# CONFIG_W1_SLAVE_DS2433_CRC is not set
CONFIG_W1_SLAVE_DS2760=y
CONFIG_W1_SLAVE_DS2780=y
CONFIG_W1_SLAVE_DS2781=y
CONFIG_W1_SLAVE_DS28E04=y
CONFIG_W1_SLAVE_BQ27000=y
CONFIG_POWER_SUPPLY=y
CONFIG_POWER_SUPPLY_DEBUG=y
# CONFIG_PDA_POWER is not set
CONFIG_WM831X_BACKUP=y
CONFIG_WM831X_POWER=y
# CONFIG_WM8350_POWER is not set
CONFIG_TEST_POWER=y
CONFIG_BATTERY_88PM860X=y
CONFIG_BATTERY_DS2760=y
# CONFIG_BATTERY_DS2780 is not set
CONFIG_BATTERY_DS2781=y
# CONFIG_BATTERY_DS2782 is not set
# CONFIG_BATTERY_OLPC is not set
CONFIG_BATTERY_SBS=y
CONFIG_BATTERY_BQ27x00=y
CONFIG_BATTERY_BQ27X00_I2C=y
CONFIG_BATTERY_BQ27X00_PLATFORM=y
CONFIG_BATTERY_DA9030=y
CONFIG_BATTERY_DA9052=y
# CONFIG_BATTERY_MAX17040 is not set
CONFIG_BATTERY_MAX17042=y
CONFIG_BATTERY_TWL4030_MADC=y
# CONFIG_CHARGER_88PM860X is not set
CONFIG_CHARGER_PCF50633=y
# CONFIG_BATTERY_RX51 is not set
CONFIG_CHARGER_ISP1704=y
# CONFIG_CHARGER_MAX8903 is not set
CONFIG_CHARGER_TWL4030=y
# CONFIG_CHARGER_LP8727 is not set
CONFIG_CHARGER_GPIO=y
# CONFIG_CHARGER_MANAGER is not set
# CONFIG_CHARGER_MAX14577 is not set
# CONFIG_CHARGER_MAX8997 is not set
CONFIG_CHARGER_BQ2415X=y
# CONFIG_CHARGER_BQ24190 is not set
CONFIG_CHARGER_BQ24735=y
CONFIG_CHARGER_SMB347=y
CONFIG_CHARGER_TPS65090=y
CONFIG_BATTERY_GOLDFISH=y
CONFIG_POWER_RESET=y
CONFIG_POWER_RESET_GPIO=y
CONFIG_POWER_AVS=y
CONFIG_HWMON=y
CONFIG_HWMON_VID=y
CONFIG_HWMON_DEBUG_CHIP=y

#
# Native drivers
#
CONFIG_SENSORS_AD7414=y
# CONFIG_SENSORS_AD7418 is not set
CONFIG_SENSORS_ADM1021=y
# CONFIG_SENSORS_ADM1025 is not set
CONFIG_SENSORS_ADM1026=y
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
# CONFIG_SENSORS_K10TEMP is not set
CONFIG_SENSORS_FAM15H_POWER=y
# CONFIG_SENSORS_ASB100 is not set
CONFIG_SENSORS_ATXP1=y
CONFIG_SENSORS_DS620=y
CONFIG_SENSORS_DS1621=y
CONFIG_SENSORS_DA9052_ADC=y
CONFIG_SENSORS_DA9055=y
CONFIG_SENSORS_I5K_AMB=y
# CONFIG_SENSORS_F71805F is not set
# CONFIG_SENSORS_F71882FG is not set
CONFIG_SENSORS_F75375S=y
# CONFIG_SENSORS_FSCHMD is not set
CONFIG_SENSORS_G760A=y
# CONFIG_SENSORS_G762 is not set
CONFIG_SENSORS_GL518SM=y
CONFIG_SENSORS_GL520SM=y
# CONFIG_SENSORS_GPIO_FAN is not set
CONFIG_SENSORS_HIH6130=y
CONFIG_SENSORS_HTU21=y
# CONFIG_SENSORS_CORETEMP is not set
CONFIG_SENSORS_IBMAEM=y
CONFIG_SENSORS_IBMPEX=y
CONFIG_SENSORS_IT87=y
CONFIG_SENSORS_JC42=y
CONFIG_SENSORS_LINEAGE=y
CONFIG_SENSORS_LM63=y
CONFIG_SENSORS_LM73=y
# CONFIG_SENSORS_LM75 is not set
# CONFIG_SENSORS_LM77 is not set
CONFIG_SENSORS_LM78=y
# CONFIG_SENSORS_LM80 is not set
# CONFIG_SENSORS_LM83 is not set
CONFIG_SENSORS_LM85=y
CONFIG_SENSORS_LM87=y
CONFIG_SENSORS_LM90=y
CONFIG_SENSORS_LM92=y
CONFIG_SENSORS_LM93=y
# CONFIG_SENSORS_LTC4151 is not set
CONFIG_SENSORS_LTC4215=y
# CONFIG_SENSORS_LTC4245 is not set
# CONFIG_SENSORS_LTC4261 is not set
CONFIG_SENSORS_LM95234=y
# CONFIG_SENSORS_LM95241 is not set
CONFIG_SENSORS_LM95245=y
CONFIG_SENSORS_MAX16065=y
CONFIG_SENSORS_MAX1619=y
CONFIG_SENSORS_MAX1668=y
CONFIG_SENSORS_MAX197=y
CONFIG_SENSORS_MAX6639=y
CONFIG_SENSORS_MAX6642=y
CONFIG_SENSORS_MAX6650=y
CONFIG_SENSORS_MAX6697=y
# CONFIG_SENSORS_MCP3021 is not set
CONFIG_SENSORS_NCT6775=y
# CONFIG_SENSORS_PC87360 is not set
# CONFIG_SENSORS_PC87427 is not set
CONFIG_SENSORS_PCF8591=y
CONFIG_PMBUS=y
CONFIG_SENSORS_PMBUS=y
CONFIG_SENSORS_ADM1275=y
CONFIG_SENSORS_LM25066=y
CONFIG_SENSORS_LTC2978=y
CONFIG_SENSORS_MAX16064=y
CONFIG_SENSORS_MAX34440=y
CONFIG_SENSORS_MAX8688=y
CONFIG_SENSORS_UCD9000=y
CONFIG_SENSORS_UCD9200=y
CONFIG_SENSORS_ZL6100=y
# CONFIG_SENSORS_SHT15 is not set
# CONFIG_SENSORS_SHT21 is not set
# CONFIG_SENSORS_SIS5595 is not set
# CONFIG_SENSORS_SMM665 is not set
CONFIG_SENSORS_DME1737=y
CONFIG_SENSORS_EMC1403=y
# CONFIG_SENSORS_EMC2103 is not set
CONFIG_SENSORS_EMC6W201=y
CONFIG_SENSORS_SMSC47M1=y
# CONFIG_SENSORS_SMSC47M192 is not set
CONFIG_SENSORS_SMSC47B397=y
# CONFIG_SENSORS_SCH56XX_COMMON is not set
CONFIG_SENSORS_ADS1015=y
CONFIG_SENSORS_ADS7828=y
CONFIG_SENSORS_AMC6821=y
CONFIG_SENSORS_INA209=y
# CONFIG_SENSORS_INA2XX is not set
# CONFIG_SENSORS_THMC50 is not set
# CONFIG_SENSORS_TMP102 is not set
CONFIG_SENSORS_TMP401=y
CONFIG_SENSORS_TMP421=y
CONFIG_SENSORS_TWL4030_MADC=y
CONFIG_SENSORS_VIA_CPUTEMP=y
CONFIG_SENSORS_VIA686A=y
CONFIG_SENSORS_VT1211=y
CONFIG_SENSORS_VT8231=y
CONFIG_SENSORS_W83781D=y
# CONFIG_SENSORS_W83791D is not set
CONFIG_SENSORS_W83792D=y
CONFIG_SENSORS_W83793=y
# CONFIG_SENSORS_W83795 is not set
# CONFIG_SENSORS_W83L785TS is not set
CONFIG_SENSORS_W83L786NG=y
CONFIG_SENSORS_W83627HF=y
CONFIG_SENSORS_W83627EHF=y
# CONFIG_SENSORS_WM831X is not set
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
CONFIG_THERMAL_OF=y
# CONFIG_THERMAL_DEFAULT_GOV_STEP_WISE is not set
CONFIG_THERMAL_DEFAULT_GOV_FAIR_SHARE=y
# CONFIG_THERMAL_DEFAULT_GOV_USER_SPACE is not set
CONFIG_THERMAL_GOV_FAIR_SHARE=y
# CONFIG_THERMAL_GOV_STEP_WISE is not set
CONFIG_THERMAL_GOV_USER_SPACE=y
CONFIG_CPU_THERMAL=y
# CONFIG_THERMAL_EMULATION is not set
CONFIG_IMX_THERMAL=y
# CONFIG_RCAR_THERMAL is not set
# CONFIG_INTEL_POWERCLAMP is not set
# CONFIG_ACPI_INT3403_THERMAL is not set

#
# Texas Instruments thermal drivers
#
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
CONFIG_BCMA=y
CONFIG_BCMA_HOST_PCI_POSSIBLE=y
CONFIG_BCMA_HOST_PCI=y
CONFIG_BCMA_HOST_SOC=y
# CONFIG_BCMA_DRIVER_GMAC_CMN is not set
CONFIG_BCMA_DRIVER_GPIO=y
CONFIG_BCMA_DEBUG=y

#
# Multifunction device drivers
#
CONFIG_MFD_CORE=y
CONFIG_MFD_CS5535=y
CONFIG_MFD_AS3711=y
# CONFIG_MFD_AS3722 is not set
# CONFIG_PMIC_ADP5520 is not set
# CONFIG_MFD_AAT2870_CORE is not set
# CONFIG_MFD_CROS_EC is not set
CONFIG_PMIC_DA903X=y
CONFIG_PMIC_DA9052=y
CONFIG_MFD_DA9052_I2C=y
CONFIG_MFD_DA9055=y
# CONFIG_MFD_DA9063 is not set
CONFIG_MFD_MC13XXX=y
CONFIG_MFD_MC13XXX_I2C=y
CONFIG_HTC_PASIC3=y
# CONFIG_HTC_I2CPLD is not set
CONFIG_LPC_ICH=y
CONFIG_LPC_SCH=y
# CONFIG_MFD_JANZ_CMODIO is not set
# CONFIG_MFD_KEMPLD is not set
# CONFIG_MFD_88PM800 is not set
# CONFIG_MFD_88PM805 is not set
CONFIG_MFD_88PM860X=y
CONFIG_MFD_MAX14577=y
CONFIG_MFD_MAX77686=y
CONFIG_MFD_MAX77693=y
CONFIG_MFD_MAX8907=y
# CONFIG_MFD_MAX8925 is not set
CONFIG_MFD_MAX8997=y
# CONFIG_MFD_MAX8998 is not set
CONFIG_MFD_VIPERBOARD=y
# CONFIG_MFD_RETU is not set
CONFIG_MFD_PCF50633=y
CONFIG_PCF50633_ADC=y
CONFIG_PCF50633_GPIO=y
CONFIG_MFD_RDC321X=y
CONFIG_MFD_RTSX_PCI=y
CONFIG_MFD_RC5T583=y
# CONFIG_MFD_SEC_CORE is not set
CONFIG_MFD_SI476X_CORE=y
# CONFIG_MFD_SM501 is not set
CONFIG_MFD_SMSC=y
# CONFIG_ABX500_CORE is not set
CONFIG_MFD_STMPE=y

#
# STMicroelectronics STMPE Interface Drivers
#
CONFIG_STMPE_I2C=y
CONFIG_MFD_SYSCON=y
# CONFIG_MFD_TI_AM335X_TSCADC is not set
CONFIG_MFD_LP3943=y
CONFIG_MFD_LP8788=y
CONFIG_MFD_PALMAS=y
# CONFIG_TPS6105X is not set
# CONFIG_TPS65010 is not set
CONFIG_TPS6507X=y
CONFIG_MFD_TPS65090=y
CONFIG_MFD_TPS65217=y
# CONFIG_MFD_TPS6586X is not set
CONFIG_MFD_TPS65910=y
# CONFIG_MFD_TPS65912 is not set
# CONFIG_MFD_TPS65912_I2C is not set
# CONFIG_MFD_TPS80031 is not set
CONFIG_TWL4030_CORE=y
CONFIG_TWL4030_MADC=y
CONFIG_MFD_TWL4030_AUDIO=y
# CONFIG_TWL6040_CORE is not set
CONFIG_MFD_WL1273_CORE=y
CONFIG_MFD_LM3533=y
# CONFIG_MFD_TIMBERDALE is not set
CONFIG_MFD_TC3589X=y
# CONFIG_MFD_TMIO is not set
CONFIG_MFD_VX855=y
# CONFIG_MFD_ARIZONA_I2C is not set
CONFIG_MFD_WM8400=y
CONFIG_MFD_WM831X=y
CONFIG_MFD_WM831X_I2C=y
CONFIG_MFD_WM8350=y
CONFIG_MFD_WM8350_I2C=y
CONFIG_MFD_WM8994=y
CONFIG_REGULATOR=y
# CONFIG_REGULATOR_DEBUG is not set
CONFIG_REGULATOR_FIXED_VOLTAGE=y
CONFIG_REGULATOR_VIRTUAL_CONSUMER=y
# CONFIG_REGULATOR_USERSPACE_CONSUMER is not set
# CONFIG_REGULATOR_88PM8607 is not set
CONFIG_REGULATOR_ACT8865=y
CONFIG_REGULATOR_AD5398=y
# CONFIG_REGULATOR_ANATOP is not set
# CONFIG_REGULATOR_AS3711 is not set
CONFIG_REGULATOR_DA903X=y
CONFIG_REGULATOR_DA9052=y
CONFIG_REGULATOR_DA9055=y
CONFIG_REGULATOR_DA9210=y
# CONFIG_REGULATOR_FAN53555 is not set
CONFIG_REGULATOR_GPIO=y
# CONFIG_REGULATOR_ISL6271A is not set
CONFIG_REGULATOR_LP3971=y
CONFIG_REGULATOR_LP3972=y
CONFIG_REGULATOR_LP872X=y
CONFIG_REGULATOR_LP8755=y
CONFIG_REGULATOR_LP8788=y
CONFIG_REGULATOR_MAX14577=y
CONFIG_REGULATOR_MAX1586=y
CONFIG_REGULATOR_MAX8649=y
CONFIG_REGULATOR_MAX8660=y
# CONFIG_REGULATOR_MAX8907 is not set
CONFIG_REGULATOR_MAX8952=y
# CONFIG_REGULATOR_MAX8973 is not set
CONFIG_REGULATOR_MAX8997=y
# CONFIG_REGULATOR_MAX77686 is not set
CONFIG_REGULATOR_MAX77693=y
CONFIG_REGULATOR_MC13XXX_CORE=y
CONFIG_REGULATOR_MC13783=y
# CONFIG_REGULATOR_MC13892 is not set
CONFIG_REGULATOR_PALMAS=y
CONFIG_REGULATOR_PCF50633=y
# CONFIG_REGULATOR_PFUZE100 is not set
CONFIG_REGULATOR_RC5T583=y
CONFIG_REGULATOR_TPS51632=y
CONFIG_REGULATOR_TPS62360=y
CONFIG_REGULATOR_TPS65023=y
CONFIG_REGULATOR_TPS6507X=y
# CONFIG_REGULATOR_TPS65090 is not set
CONFIG_REGULATOR_TPS65217=y
CONFIG_REGULATOR_TPS65910=y
CONFIG_REGULATOR_TWL4030=y
# CONFIG_REGULATOR_WM831X is not set
CONFIG_REGULATOR_WM8350=y
CONFIG_REGULATOR_WM8400=y
# CONFIG_REGULATOR_WM8994 is not set
CONFIG_MEDIA_SUPPORT=y

#
# Multimedia core support
#
# CONFIG_MEDIA_CAMERA_SUPPORT is not set
CONFIG_MEDIA_ANALOG_TV_SUPPORT=y
CONFIG_MEDIA_DIGITAL_TV_SUPPORT=y
CONFIG_MEDIA_RADIO_SUPPORT=y
CONFIG_MEDIA_RC_SUPPORT=y
CONFIG_VIDEO_DEV=y
CONFIG_VIDEO_V4L2=y
CONFIG_VIDEO_ADV_DEBUG=y
CONFIG_VIDEO_FIXED_MINOR_RANGES=y
CONFIG_VIDEO_TUNER=y
CONFIG_VIDEOBUF_GEN=y
CONFIG_VIDEOBUF_VMALLOC=y
CONFIG_VIDEOBUF_DVB=y
CONFIG_VIDEOBUF2_CORE=y
CONFIG_VIDEOBUF2_MEMOPS=y
CONFIG_VIDEOBUF2_VMALLOC=y
CONFIG_DVB_CORE=y
CONFIG_DVB_NET=y
CONFIG_TTPCI_EEPROM=y
CONFIG_DVB_MAX_ADAPTERS=8
CONFIG_DVB_DYNAMIC_MINORS=y

#
# Media drivers
#
CONFIG_RC_CORE=y
CONFIG_RC_MAP=y
# CONFIG_RC_DECODERS is not set
# CONFIG_RC_DEVICES is not set
CONFIG_MEDIA_USB_SUPPORT=y

#
# Analog TV USB devices
#
CONFIG_VIDEO_PVRUSB2=y
# CONFIG_VIDEO_PVRUSB2_SYSFS is not set
# CONFIG_VIDEO_PVRUSB2_DVB is not set
CONFIG_VIDEO_HDPVR=y
CONFIG_VIDEO_USBVISION=y
CONFIG_VIDEO_STK1160_COMMON=y
CONFIG_VIDEO_STK1160=y

#
# Analog/digital TV USB devices
#
CONFIG_VIDEO_AU0828=y
CONFIG_VIDEO_AU0828_V4L2=y
CONFIG_VIDEO_CX231XX=y
# CONFIG_VIDEO_CX231XX_RC is not set
CONFIG_VIDEO_CX231XX_DVB=y
# CONFIG_VIDEO_TM6000 is not set

#
# Digital TV USB devices
#
CONFIG_DVB_USB=y
# CONFIG_DVB_USB_DEBUG is not set
CONFIG_DVB_USB_A800=y
CONFIG_DVB_USB_DIBUSB_MB=y
CONFIG_DVB_USB_DIBUSB_MB_FAULTY=y
CONFIG_DVB_USB_DIBUSB_MC=y
# CONFIG_DVB_USB_DIB0700 is not set
CONFIG_DVB_USB_UMT_010=y
CONFIG_DVB_USB_CXUSB=y
CONFIG_DVB_USB_M920X=y
CONFIG_DVB_USB_DIGITV=y
CONFIG_DVB_USB_VP7045=y
# CONFIG_DVB_USB_VP702X is not set
CONFIG_DVB_USB_GP8PSK=y
# CONFIG_DVB_USB_NOVA_T_USB2 is not set
CONFIG_DVB_USB_TTUSB2=y
# CONFIG_DVB_USB_DTT200U is not set
CONFIG_DVB_USB_OPERA1=y
CONFIG_DVB_USB_AF9005=y
CONFIG_DVB_USB_AF9005_REMOTE=y
CONFIG_DVB_USB_PCTV452E=y
CONFIG_DVB_USB_DW2102=y
CONFIG_DVB_USB_CINERGY_T2=y
CONFIG_DVB_USB_DTV5100=y
CONFIG_DVB_USB_FRIIO=y
# CONFIG_DVB_USB_AZ6027 is not set
CONFIG_DVB_USB_TECHNISAT_USB2=y
CONFIG_DVB_USB_V2=y
# CONFIG_DVB_USB_AF9015 is not set
# CONFIG_DVB_USB_AF9035 is not set
CONFIG_DVB_USB_ANYSEE=y
CONFIG_DVB_USB_AU6610=y
CONFIG_DVB_USB_AZ6007=y
# CONFIG_DVB_USB_CE6230 is not set
CONFIG_DVB_USB_EC168=y
CONFIG_DVB_USB_GL861=y
# CONFIG_DVB_USB_IT913X is not set
# CONFIG_DVB_USB_LME2510 is not set
CONFIG_DVB_USB_MXL111SF=y
CONFIG_DVB_USB_RTL28XXU=y
CONFIG_DVB_TTUSB_BUDGET=y
CONFIG_DVB_TTUSB_DEC=y
CONFIG_SMS_USB_DRV=y
CONFIG_DVB_B2C2_FLEXCOP_USB=y
# CONFIG_DVB_B2C2_FLEXCOP_USB_DEBUG is not set

#
# Webcam, TV (analog/digital) USB devices
#
# CONFIG_VIDEO_EM28XX is not set
# CONFIG_MEDIA_PCI_SUPPORT is not set

#
# Supported MMC/SDIO adapters
#
CONFIG_SMS_SDIO_DRV=y
CONFIG_RADIO_ADAPTERS=y
# CONFIG_RADIO_SI470X is not set
CONFIG_RADIO_SI4713=y
# CONFIG_USB_SI4713 is not set
CONFIG_PLATFORM_SI4713=y
CONFIG_I2C_SI4713=y
# CONFIG_USB_MR800 is not set
CONFIG_USB_DSBR=y
# CONFIG_RADIO_MAXIRADIO is not set
# CONFIG_RADIO_SHARK is not set
# CONFIG_RADIO_SHARK2 is not set
# CONFIG_USB_KEENE is not set
# CONFIG_USB_RAREMONO is not set
CONFIG_USB_MA901=y
CONFIG_RADIO_TEA5764=y
# CONFIG_RADIO_TEA5764_XTAL is not set
# CONFIG_RADIO_SAA7706H is not set
# CONFIG_RADIO_TEF6862 is not set
CONFIG_RADIO_WL1273=y

#
# Texas Instruments WL128x FM driver (ST based)
#
CONFIG_RADIO_WL128X=y
CONFIG_MEDIA_COMMON_OPTIONS=y

#
# common driver options
#
CONFIG_VIDEO_CX2341X=y
CONFIG_VIDEO_TVEEPROM=y
CONFIG_CYPRESS_FIRMWARE=y
CONFIG_DVB_B2C2_FLEXCOP=y
CONFIG_SMS_SIANO_MDTV=y
CONFIG_SMS_SIANO_RC=y

#
# Media ancillary drivers (tuners, sensors, i2c, frontends)
#
# CONFIG_MEDIA_SUBDRV_AUTOSELECT is not set
CONFIG_VIDEO_IR_I2C=y

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
# CONFIG_VIDEO_TEA6420 is not set
CONFIG_VIDEO_MSP3400=y
# CONFIG_VIDEO_CS5345 is not set
CONFIG_VIDEO_CS53L32A=y
CONFIG_VIDEO_TLV320AIC23B=y
CONFIG_VIDEO_UDA1342=y
CONFIG_VIDEO_WM8775=y
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
CONFIG_VIDEO_ADV7180=y
# CONFIG_VIDEO_ADV7183 is not set
CONFIG_VIDEO_BT819=y
# CONFIG_VIDEO_BT856 is not set
CONFIG_VIDEO_BT866=y
CONFIG_VIDEO_KS0127=y
# CONFIG_VIDEO_ML86V7667 is not set
CONFIG_VIDEO_SAA7110=y
CONFIG_VIDEO_SAA711X=y
# CONFIG_VIDEO_SAA7191 is not set
CONFIG_VIDEO_TVP514X=y
# CONFIG_VIDEO_TVP5150 is not set
CONFIG_VIDEO_TVP7002=y
# CONFIG_VIDEO_TW2804 is not set
CONFIG_VIDEO_TW9903=y
CONFIG_VIDEO_TW9906=y
CONFIG_VIDEO_VPX3220=y

#
# Video and audio decoders
#
CONFIG_VIDEO_SAA717X=y
CONFIG_VIDEO_CX25840=y

#
# Video encoders
#
# CONFIG_VIDEO_SAA7127 is not set
# CONFIG_VIDEO_SAA7185 is not set
CONFIG_VIDEO_ADV7170=y
CONFIG_VIDEO_ADV7175=y
# CONFIG_VIDEO_ADV7343 is not set
CONFIG_VIDEO_ADV7393=y
CONFIG_VIDEO_AK881X=y
CONFIG_VIDEO_THS8200=y

#
# Camera sensor devices
#

#
# Flash devices
#

#
# Video improvement chips
#
CONFIG_VIDEO_UPD64031A=y
CONFIG_VIDEO_UPD64083=y

#
# Audio/Video compression chips
#
CONFIG_VIDEO_SAA6752HS=y

#
# Miscellaneous helper chips
#
# CONFIG_VIDEO_THS7303 is not set
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
# CONFIG_MEDIA_TUNER_TEA5761 is not set
CONFIG_MEDIA_TUNER_TEA5767=y
CONFIG_MEDIA_TUNER_MT20XX=y
# CONFIG_MEDIA_TUNER_MT2060 is not set
CONFIG_MEDIA_TUNER_MT2063=y
CONFIG_MEDIA_TUNER_MT2266=y
# CONFIG_MEDIA_TUNER_MT2131 is not set
# CONFIG_MEDIA_TUNER_QT1010 is not set
CONFIG_MEDIA_TUNER_XC2028=y
# CONFIG_MEDIA_TUNER_XC5000 is not set
# CONFIG_MEDIA_TUNER_XC4000 is not set
CONFIG_MEDIA_TUNER_MXL5005S=y
CONFIG_MEDIA_TUNER_MXL5007T=y
# CONFIG_MEDIA_TUNER_MC44S803 is not set
CONFIG_MEDIA_TUNER_MAX2165=y
# CONFIG_MEDIA_TUNER_TDA18218 is not set
CONFIG_MEDIA_TUNER_FC0011=y
CONFIG_MEDIA_TUNER_FC0012=y
CONFIG_MEDIA_TUNER_FC0013=y
CONFIG_MEDIA_TUNER_TDA18212=y
# CONFIG_MEDIA_TUNER_E4000 is not set
CONFIG_MEDIA_TUNER_FC2580=y
CONFIG_MEDIA_TUNER_M88TS2022=y
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
CONFIG_DVB_M88DS3103=y

#
# Multistandard (cable + terrestrial) frontends
#
# CONFIG_DVB_DRXK is not set
# CONFIG_DVB_TDA18271C2DD is not set

#
# DVB-S (satellite) frontends
#
CONFIG_DVB_CX24110=y
CONFIG_DVB_CX24123=y
CONFIG_DVB_MT312=y
CONFIG_DVB_ZL10036=y
CONFIG_DVB_ZL10039=y
CONFIG_DVB_S5H1420=y
# CONFIG_DVB_STV0288 is not set
# CONFIG_DVB_STB6000 is not set
# CONFIG_DVB_STV0299 is not set
CONFIG_DVB_STV6110=y
CONFIG_DVB_STV0900=y
# CONFIG_DVB_TDA8083 is not set
CONFIG_DVB_TDA10086=y
CONFIG_DVB_TDA8261=y
CONFIG_DVB_VES1X93=y
CONFIG_DVB_TUNER_ITD1000=y
CONFIG_DVB_TUNER_CX24113=y
# CONFIG_DVB_TDA826X is not set
CONFIG_DVB_TUA6100=y
# CONFIG_DVB_CX24116 is not set
# CONFIG_DVB_CX24117 is not set
CONFIG_DVB_SI21XX=y
CONFIG_DVB_TS2020=y
CONFIG_DVB_DS3000=y
# CONFIG_DVB_MB86A16 is not set
CONFIG_DVB_TDA10071=y

#
# DVB-T (terrestrial) frontends
#
CONFIG_DVB_SP8870=y
CONFIG_DVB_SP887X=y
CONFIG_DVB_CX22700=y
# CONFIG_DVB_CX22702 is not set
# CONFIG_DVB_S5H1432 is not set
CONFIG_DVB_DRXD=y
# CONFIG_DVB_L64781 is not set
# CONFIG_DVB_TDA1004X is not set
CONFIG_DVB_NXT6000=y
# CONFIG_DVB_MT352 is not set
CONFIG_DVB_ZL10353=y
CONFIG_DVB_DIB3000MB=y
CONFIG_DVB_DIB3000MC=y
CONFIG_DVB_DIB7000M=y
# CONFIG_DVB_DIB7000P is not set
CONFIG_DVB_DIB9000=y
# CONFIG_DVB_TDA10048 is not set
CONFIG_DVB_AF9013=y
CONFIG_DVB_EC100=y
CONFIG_DVB_HD29L2=y
# CONFIG_DVB_STV0367 is not set
CONFIG_DVB_CXD2820R=y
CONFIG_DVB_RTL2830=y
CONFIG_DVB_RTL2832=y

#
# DVB-C (cable) frontends
#
# CONFIG_DVB_VES1820 is not set
# CONFIG_DVB_TDA10021 is not set
CONFIG_DVB_TDA10023=y
CONFIG_DVB_STV0297=y

#
# ATSC (North American/Korean Terrestrial/Cable DTV) frontends
#
# CONFIG_DVB_NXT200X is not set
# CONFIG_DVB_OR51211 is not set
CONFIG_DVB_OR51132=y
CONFIG_DVB_BCM3510=y
# CONFIG_DVB_LGDT330X is not set
CONFIG_DVB_LGDT3305=y
CONFIG_DVB_LG2160=y
CONFIG_DVB_S5H1409=y
CONFIG_DVB_AU8522=y
CONFIG_DVB_AU8522_DTV=y
# CONFIG_DVB_AU8522_V4L is not set
# CONFIG_DVB_S5H1411 is not set

#
# ISDB-T (terrestrial) frontends
#
# CONFIG_DVB_S921 is not set
CONFIG_DVB_DIB8000=y
CONFIG_DVB_MB86A20S=y

#
# Digital terrestrial only tuners/PLL
#
CONFIG_DVB_PLL=y
# CONFIG_DVB_TUNER_DIB0070 is not set
CONFIG_DVB_TUNER_DIB0090=y

#
# SEC control devices for DVB-S
#
CONFIG_DVB_LNBP21=y
CONFIG_DVB_LNBP22=y
CONFIG_DVB_ISL6405=y
CONFIG_DVB_ISL6421=y
CONFIG_DVB_ISL6423=y
CONFIG_DVB_A8293=y
# CONFIG_DVB_LGS8GL5 is not set
CONFIG_DVB_LGS8GXX=y
CONFIG_DVB_ATBM8830=y
# CONFIG_DVB_TDA665x is not set
CONFIG_DVB_IX2505V=y
CONFIG_DVB_IT913X_FE=y
# CONFIG_DVB_M88RS2000 is not set
# CONFIG_DVB_AF9033 is not set

#
# Tools to develop new frontends
#
CONFIG_DVB_DUMMY_FE=y

#
# Graphics support
#
CONFIG_AGP=y
CONFIG_AGP_ALI=y
CONFIG_AGP_ATI=y
CONFIG_AGP_AMD=y
CONFIG_AGP_AMD64=y
CONFIG_AGP_INTEL=y
# CONFIG_AGP_NVIDIA is not set
CONFIG_AGP_SIS=y
CONFIG_AGP_SWORKS=y
# CONFIG_AGP_VIA is not set
# CONFIG_AGP_EFFICEON is not set
CONFIG_INTEL_GTT=y
# CONFIG_VGA_ARB is not set
# CONFIG_VGA_SWITCHEROO is not set
CONFIG_DRM=y
CONFIG_DRM_USB=y
CONFIG_DRM_KMS_HELPER=y
CONFIG_DRM_KMS_FB_HELPER=y
# CONFIG_DRM_LOAD_EDID_FIRMWARE is not set
CONFIG_DRM_TTM=y

#
# I2C encoder or helper chips
#
CONFIG_DRM_I2C_CH7006=y
CONFIG_DRM_I2C_SIL164=y
# CONFIG_DRM_I2C_NXP_TDA998X is not set
CONFIG_DRM_TDFX=y
CONFIG_DRM_R128=y
CONFIG_DRM_RADEON=y
CONFIG_DRM_RADEON_UMS=y
CONFIG_DRM_NOUVEAU=y
CONFIG_NOUVEAU_DEBUG=5
CONFIG_NOUVEAU_DEBUG_DEFAULT=3
CONFIG_DRM_NOUVEAU_BACKLIGHT=y
CONFIG_DRM_I915=y
# CONFIG_DRM_I915_KMS is not set
CONFIG_DRM_I915_FBDEV=y
# CONFIG_DRM_I915_PRELIMINARY_HW_SUPPORT is not set
# CONFIG_DRM_I915_UMS is not set
CONFIG_DRM_MGA=y
CONFIG_DRM_SIS=y
# CONFIG_DRM_VIA is not set
# CONFIG_DRM_SAVAGE is not set
# CONFIG_DRM_VMWGFX is not set
# CONFIG_DRM_GMA500 is not set
CONFIG_DRM_UDL=y
CONFIG_DRM_AST=y
# CONFIG_DRM_MGAG200 is not set
# CONFIG_DRM_CIRRUS_QEMU is not set
# CONFIG_DRM_QXL is not set
CONFIG_DRM_BOCHS=y
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
# CONFIG_FB_BOTH_ENDIAN is not set
# CONFIG_FB_BIG_ENDIAN is not set
CONFIG_FB_LITTLE_ENDIAN=y
CONFIG_FB_SYS_FOPS=y
CONFIG_FB_DEFERRED_IO=y
CONFIG_FB_SVGALIB=y
# CONFIG_FB_MACMODES is not set
CONFIG_FB_BACKLIGHT=y
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
# CONFIG_FB_ARC is not set
# CONFIG_FB_ASILIANT is not set
CONFIG_FB_IMSTT=y
# CONFIG_FB_VGA16 is not set
CONFIG_FB_UVESA=y
# CONFIG_FB_VESA is not set
# CONFIG_FB_N411 is not set
# CONFIG_FB_HGA is not set
CONFIG_FB_OPENCORES=y
CONFIG_FB_S1D13XXX=y
# CONFIG_FB_NVIDIA is not set
# CONFIG_FB_RIVA is not set
CONFIG_FB_I740=y
CONFIG_FB_I810=y
# CONFIG_FB_I810_GTF is not set
CONFIG_FB_LE80578=y
CONFIG_FB_CARILLO_RANCH=y
CONFIG_FB_MATROX=y
CONFIG_FB_MATROX_MILLENIUM=y
CONFIG_FB_MATROX_MYSTIQUE=y
# CONFIG_FB_MATROX_G is not set
CONFIG_FB_MATROX_I2C=y
CONFIG_FB_RADEON=y
CONFIG_FB_RADEON_I2C=y
# CONFIG_FB_RADEON_BACKLIGHT is not set
# CONFIG_FB_RADEON_DEBUG is not set
# CONFIG_FB_ATY128 is not set
CONFIG_FB_ATY=y
CONFIG_FB_ATY_CT=y
CONFIG_FB_ATY_GENERIC_LCD=y
# CONFIG_FB_ATY_GX is not set
CONFIG_FB_ATY_BACKLIGHT=y
# CONFIG_FB_S3 is not set
# CONFIG_FB_SAVAGE is not set
CONFIG_FB_SIS=y
CONFIG_FB_SIS_300=y
# CONFIG_FB_SIS_315 is not set
CONFIG_FB_VIA=y
CONFIG_FB_VIA_DIRECT_PROCFS=y
CONFIG_FB_VIA_X_COMPATIBILITY=y
CONFIG_FB_NEOMAGIC=y
CONFIG_FB_KYRO=y
CONFIG_FB_3DFX=y
# CONFIG_FB_3DFX_ACCEL is not set
# CONFIG_FB_3DFX_I2C is not set
CONFIG_FB_VOODOO1=y
# CONFIG_FB_VT8623 is not set
CONFIG_FB_TRIDENT=y
CONFIG_FB_ARK=y
# CONFIG_FB_PM3 is not set
# CONFIG_FB_CARMINE is not set
CONFIG_FB_GEODE=y
# CONFIG_FB_GEODE_LX is not set
CONFIG_FB_GEODE_GX=y
# CONFIG_FB_GEODE_GX1 is not set
CONFIG_FB_TMIO=y
# CONFIG_FB_TMIO_ACCELL is not set
# CONFIG_FB_SMSCUFX is not set
CONFIG_FB_UDL=y
# CONFIG_FB_GOLDFISH is not set
CONFIG_FB_VIRTUAL=y
CONFIG_FB_METRONOME=y
CONFIG_FB_MB862XX=y
CONFIG_FB_MB862XX_PCI_GDC=y
CONFIG_FB_MB862XX_I2C=y
# CONFIG_FB_BROADSHEET is not set
CONFIG_FB_AUO_K190X=y
CONFIG_FB_AUO_K1900=y
CONFIG_FB_AUO_K1901=y
# CONFIG_FB_SIMPLE is not set
# CONFIG_EXYNOS_VIDEO is not set
CONFIG_BACKLIGHT_LCD_SUPPORT=y
# CONFIG_LCD_CLASS_DEVICE is not set
CONFIG_BACKLIGHT_CLASS_DEVICE=y
CONFIG_BACKLIGHT_GENERIC=y
CONFIG_BACKLIGHT_LM3533=y
CONFIG_BACKLIGHT_PWM=y
CONFIG_BACKLIGHT_DA903X=y
CONFIG_BACKLIGHT_DA9052=y
# CONFIG_BACKLIGHT_APPLE is not set
# CONFIG_BACKLIGHT_SAHARA is not set
CONFIG_BACKLIGHT_WM831X=y
CONFIG_BACKLIGHT_ADP8860=y
CONFIG_BACKLIGHT_ADP8870=y
CONFIG_BACKLIGHT_88PM860X=y
# CONFIG_BACKLIGHT_PCF50633 is not set
# CONFIG_BACKLIGHT_LM3630A is not set
CONFIG_BACKLIGHT_LM3639=y
# CONFIG_BACKLIGHT_LP855X is not set
CONFIG_BACKLIGHT_LP8788=y
CONFIG_BACKLIGHT_PANDORA=y
# CONFIG_BACKLIGHT_TPS65217 is not set
CONFIG_BACKLIGHT_AS3711=y
# CONFIG_BACKLIGHT_GPIO is not set
CONFIG_BACKLIGHT_LV5207LP=y
CONFIG_BACKLIGHT_BD6107=y
CONFIG_LOGO=y
# CONFIG_LOGO_LINUX_MONO is not set
# CONFIG_LOGO_LINUX_VGA16 is not set
CONFIG_LOGO_LINUX_CLUT224=y
CONFIG_FB_SSD1307=y
# CONFIG_SOUND is not set

#
# HID support
#
CONFIG_HID=y
CONFIG_HID_BATTERY_STRENGTH=y
# CONFIG_HIDRAW is not set
CONFIG_UHID=y
# CONFIG_HID_GENERIC is not set

#
# Special HID drivers
#
CONFIG_HID_A4TECH=y
# CONFIG_HID_ACRUX is not set
CONFIG_HID_APPLE=y
# CONFIG_HID_APPLEIR is not set
CONFIG_HID_AUREAL=y
# CONFIG_HID_BELKIN is not set
CONFIG_HID_CHERRY=y
CONFIG_HID_CHICONY=y
# CONFIG_HID_CYPRESS is not set
# CONFIG_HID_DRAGONRISE is not set
CONFIG_HID_EMS_FF=y
CONFIG_HID_ELECOM=y
CONFIG_HID_ELO=y
CONFIG_HID_EZKEY=y
CONFIG_HID_HOLTEK=y
CONFIG_HOLTEK_FF=y
# CONFIG_HID_HUION is not set
CONFIG_HID_KEYTOUCH=y
CONFIG_HID_KYE=y
CONFIG_HID_UCLOGIC=y
# CONFIG_HID_WALTOP is not set
CONFIG_HID_GYRATION=y
CONFIG_HID_ICADE=y
CONFIG_HID_TWINHAN=y
CONFIG_HID_KENSINGTON=y
CONFIG_HID_LCPOWER=y
CONFIG_HID_LENOVO_TPKBD=y
CONFIG_HID_LOGITECH=y
# CONFIG_LOGITECH_FF is not set
# CONFIG_LOGIRUMBLEPAD2_FF is not set
CONFIG_LOGIG940_FF=y
CONFIG_LOGIWHEELS_FF=y
# CONFIG_HID_MAGICMOUSE is not set
CONFIG_HID_MICROSOFT=y
CONFIG_HID_MONTEREY=y
CONFIG_HID_MULTITOUCH=y
CONFIG_HID_NTRIG=y
CONFIG_HID_ORTEK=y
CONFIG_HID_PANTHERLORD=y
# CONFIG_PANTHERLORD_FF is not set
CONFIG_HID_PETALYNX=y
# CONFIG_HID_PICOLCD is not set
CONFIG_HID_PRIMAX=y
CONFIG_HID_ROCCAT=y
# CONFIG_HID_SAITEK is not set
CONFIG_HID_SAMSUNG=y
CONFIG_HID_SONY=y
CONFIG_SONY_FF=y
CONFIG_HID_SPEEDLINK=y
# CONFIG_HID_STEELSERIES is not set
# CONFIG_HID_SUNPLUS is not set
CONFIG_HID_GREENASIA=y
CONFIG_GREENASIA_FF=y
# CONFIG_HID_SMARTJOYPLUS is not set
# CONFIG_HID_TIVO is not set
CONFIG_HID_TOPSEED=y
# CONFIG_HID_THINGM is not set
CONFIG_HID_THRUSTMASTER=y
CONFIG_THRUSTMASTER_FF=y
CONFIG_HID_WACOM=y
# CONFIG_HID_WIIMOTE is not set
CONFIG_HID_XINMO=y
CONFIG_HID_ZEROPLUS=y
# CONFIG_ZEROPLUS_FF is not set
# CONFIG_HID_ZYDACRON is not set
# CONFIG_HID_SENSOR_HUB is not set

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
# CONFIG_USB_DEFAULT_PERSIST is not set
# CONFIG_USB_DYNAMIC_MINORS is not set
CONFIG_USB_OTG=y
CONFIG_USB_OTG_WHITELIST=y
CONFIG_USB_OTG_BLACKLIST_HUB=y
CONFIG_USB_MON=y
CONFIG_USB_WUSB=y
CONFIG_USB_WUSB_CBAF=y
# CONFIG_USB_WUSB_CBAF_DEBUG is not set

#
# USB Host Controller Drivers
#
CONFIG_USB_C67X00_HCD=y
# CONFIG_USB_XHCI_HCD is not set
CONFIG_USB_EHCI_HCD=y
# CONFIG_USB_EHCI_ROOT_HUB_TT is not set
CONFIG_USB_EHCI_TT_NEWSCHED=y
CONFIG_USB_EHCI_PCI=y
# CONFIG_USB_EHCI_HCD_PLATFORM is not set
CONFIG_USB_OXU210HP_HCD=y
# CONFIG_USB_ISP116X_HCD is not set
# CONFIG_USB_ISP1760_HCD is not set
CONFIG_USB_ISP1362_HCD=y
# CONFIG_USB_FUSBH200_HCD is not set
CONFIG_USB_FOTG210_HCD=y
CONFIG_USB_OHCI_HCD=y
CONFIG_USB_OHCI_HCD_PCI=y
CONFIG_USB_OHCI_HCD_PLATFORM=y
CONFIG_USB_UHCI_HCD=y
CONFIG_USB_U132_HCD=y
CONFIG_USB_SL811_HCD=y
# CONFIG_USB_SL811_HCD_ISO is not set
# CONFIG_USB_R8A66597_HCD is not set
# CONFIG_USB_RENESAS_USBHS_HCD is not set
CONFIG_USB_WHCI_HCD=y
CONFIG_USB_HWA_HCD=y
# CONFIG_USB_HCD_BCMA is not set
CONFIG_USB_HCD_TEST_MODE=y
CONFIG_USB_RENESAS_USBHS=y

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
# CONFIG_USB_MUSB_HDRC is not set
# CONFIG_USB_DWC3 is not set
# CONFIG_USB_DWC2 is not set
# CONFIG_USB_CHIPIDEA is not set

#
# USB port drivers
#
# CONFIG_USB_USS720 is not set
CONFIG_USB_SERIAL=y
CONFIG_USB_SERIAL_CONSOLE=y
CONFIG_USB_SERIAL_GENERIC=y
# CONFIG_USB_SERIAL_SIMPLE is not set
# CONFIG_USB_SERIAL_AIRCABLE is not set
# CONFIG_USB_SERIAL_ARK3116 is not set
# CONFIG_USB_SERIAL_BELKIN is not set
CONFIG_USB_SERIAL_CH341=y
CONFIG_USB_SERIAL_WHITEHEAT=y
CONFIG_USB_SERIAL_DIGI_ACCELEPORT=y
CONFIG_USB_SERIAL_CP210X=y
# CONFIG_USB_SERIAL_CYPRESS_M8 is not set
CONFIG_USB_SERIAL_EMPEG=y
CONFIG_USB_SERIAL_FTDI_SIO=y
# CONFIG_USB_SERIAL_VISOR is not set
CONFIG_USB_SERIAL_IPAQ=y
CONFIG_USB_SERIAL_IR=y
# CONFIG_USB_SERIAL_EDGEPORT is not set
# CONFIG_USB_SERIAL_EDGEPORT_TI is not set
# CONFIG_USB_SERIAL_F81232 is not set
CONFIG_USB_SERIAL_GARMIN=y
CONFIG_USB_SERIAL_IPW=y
CONFIG_USB_SERIAL_IUU=y
CONFIG_USB_SERIAL_KEYSPAN_PDA=y
# CONFIG_USB_SERIAL_KEYSPAN is not set
# CONFIG_USB_SERIAL_KLSI is not set
# CONFIG_USB_SERIAL_KOBIL_SCT is not set
CONFIG_USB_SERIAL_MCT_U232=y
# CONFIG_USB_SERIAL_METRO is not set
CONFIG_USB_SERIAL_MOS7720=y
# CONFIG_USB_SERIAL_MOS7715_PARPORT is not set
CONFIG_USB_SERIAL_MOS7840=y
CONFIG_USB_SERIAL_MXUPORT=y
# CONFIG_USB_SERIAL_NAVMAN is not set
CONFIG_USB_SERIAL_PL2303=y
CONFIG_USB_SERIAL_OTI6858=y
CONFIG_USB_SERIAL_QCAUX=y
CONFIG_USB_SERIAL_QUALCOMM=y
CONFIG_USB_SERIAL_SPCP8X5=y
# CONFIG_USB_SERIAL_SAFE is not set
CONFIG_USB_SERIAL_SIERRAWIRELESS=y
# CONFIG_USB_SERIAL_SYMBOL is not set
CONFIG_USB_SERIAL_TI=y
CONFIG_USB_SERIAL_CYBERJACK=y
CONFIG_USB_SERIAL_XIRCOM=y
CONFIG_USB_SERIAL_WWAN=y
CONFIG_USB_SERIAL_OPTION=y
CONFIG_USB_SERIAL_OMNINET=y
# CONFIG_USB_SERIAL_OPTICON is not set
CONFIG_USB_SERIAL_XSENS_MT=y
# CONFIG_USB_SERIAL_WISHBONE is not set
CONFIG_USB_SERIAL_ZTE=y
CONFIG_USB_SERIAL_SSU100=y
CONFIG_USB_SERIAL_QT2=y
# CONFIG_USB_SERIAL_DEBUG is not set

#
# USB Miscellaneous drivers
#
CONFIG_USB_EMI62=y
CONFIG_USB_EMI26=y
CONFIG_USB_ADUTUX=y
CONFIG_USB_SEVSEG=y
CONFIG_USB_RIO500=y
CONFIG_USB_LEGOTOWER=y
CONFIG_USB_LCD=y
CONFIG_USB_LED=y
CONFIG_USB_CYPRESS_CY7C63=y
CONFIG_USB_CYTHERM=y
# CONFIG_USB_IDMOUSE is not set
CONFIG_USB_FTDI_ELAN=y
CONFIG_USB_APPLEDISPLAY=y
CONFIG_USB_SISUSBVGA=y
CONFIG_USB_LD=y
# CONFIG_USB_TRANCEVIBRATOR is not set
# CONFIG_USB_IOWARRIOR is not set
CONFIG_USB_TEST=y
CONFIG_USB_EHSET_TEST_FIXTURE=y
CONFIG_USB_ISIGHTFW=y
CONFIG_USB_YUREX=y
CONFIG_USB_EZUSB_FX2=y
CONFIG_USB_HSIC_USB3503=y

#
# USB Physical Layer drivers
#
CONFIG_USB_PHY=y
# CONFIG_USB_OTG_FSM is not set
CONFIG_KEYSTONE_USB_PHY=y
CONFIG_NOP_USB_XCEIV=y
# CONFIG_OMAP_CONTROL_USB is not set
# CONFIG_OMAP_USB3 is not set
CONFIG_AM335X_CONTROL_USB=y
CONFIG_AM335X_PHY_USB=y
CONFIG_SAMSUNG_USBPHY=y
CONFIG_SAMSUNG_USB2PHY=y
CONFIG_SAMSUNG_USB3PHY=y
CONFIG_USB_GPIO_VBUS=y
CONFIG_USB_ISP1301=y
CONFIG_USB_RCAR_PHY=y
CONFIG_USB_RCAR_GEN2_PHY=y
CONFIG_USB_GADGET=y
CONFIG_USB_GADGET_DEBUG=y
CONFIG_USB_GADGET_VERBOSE=y
CONFIG_USB_GADGET_DEBUG_FS=y
CONFIG_USB_GADGET_VBUS_DRAW=2
CONFIG_USB_GADGET_STORAGE_NUM_BUFFERS=2

#
# USB Peripheral Controller
#
CONFIG_USB_FUSB300=y
# CONFIG_USB_FOTG210_UDC is not set
# CONFIG_USB_GR_UDC is not set
CONFIG_USB_R8A66597=y
# CONFIG_USB_RENESAS_USBHS_UDC is not set
# CONFIG_USB_PXA27X is not set
CONFIG_USB_MV_UDC=y
CONFIG_USB_MV_U3D=y
# CONFIG_USB_M66592 is not set
CONFIG_USB_AMD5536UDC=y
CONFIG_USB_NET2272=y
# CONFIG_USB_NET2272_DMA is not set
# CONFIG_USB_NET2280 is not set
# CONFIG_USB_GOKU is not set
# CONFIG_USB_EG20T is not set
CONFIG_USB_DUMMY_HCD=y
CONFIG_USB_LIBCOMPOSITE=y
CONFIG_USB_F_ACM=y
CONFIG_USB_U_SERIAL=y
CONFIG_USB_U_ETHER=y
CONFIG_USB_F_OBEX=y
CONFIG_USB_F_ECM=y
CONFIG_USB_F_PHONET=y
# CONFIG_USB_CONFIGFS is not set
# CONFIG_USB_ZERO is not set
# CONFIG_USB_ETH is not set
# CONFIG_USB_G_NCM is not set
# CONFIG_USB_GADGETFS is not set
# CONFIG_USB_FUNCTIONFS is not set
# CONFIG_USB_MASS_STORAGE is not set
# CONFIG_USB_G_SERIAL is not set
# CONFIG_USB_G_PRINTER is not set
# CONFIG_USB_CDC_COMPOSITE is not set
CONFIG_USB_G_NOKIA=y
# CONFIG_USB_G_ACM_MS is not set
# CONFIG_USB_G_MULTI is not set
# CONFIG_USB_G_HID is not set
# CONFIG_USB_G_DBGP is not set
# CONFIG_USB_G_WEBCAM is not set
CONFIG_UWB=y
CONFIG_UWB_HWA=y
CONFIG_UWB_WHCI=y
# CONFIG_UWB_I1480U is not set
CONFIG_MMC=y
CONFIG_MMC_DEBUG=y
CONFIG_MMC_UNSAFE_RESUME=y
CONFIG_MMC_CLKGATE=y

#
# MMC/SD/SDIO Card Drivers
#
CONFIG_MMC_BLOCK=y
CONFIG_MMC_BLOCK_MINORS=8
CONFIG_MMC_BLOCK_BOUNCE=y
CONFIG_SDIO_UART=y
CONFIG_MMC_TEST=y

#
# MMC/SD/SDIO Host Controller Drivers
#
CONFIG_MMC_SDHCI=y
CONFIG_MMC_SDHCI_PCI=y
CONFIG_MMC_RICOH_MMC=y
# CONFIG_MMC_SDHCI_ACPI is not set
# CONFIG_MMC_SDHCI_PLTFM is not set
# CONFIG_MMC_OMAP_HS is not set
# CONFIG_MMC_WBSD is not set
CONFIG_MMC_TIFM_SD=y
CONFIG_MMC_CB710=y
CONFIG_MMC_VIA_SDMMC=y
CONFIG_MMC_SH_MMCIF=y
# CONFIG_MMC_VUB300 is not set
CONFIG_MMC_USHC=y
CONFIG_MMC_REALTEK_PCI=y
CONFIG_MEMSTICK=y
# CONFIG_MEMSTICK_DEBUG is not set

#
# MemoryStick drivers
#
# CONFIG_MEMSTICK_UNSAFE_RESUME is not set
CONFIG_MSPRO_BLOCK=y
# CONFIG_MS_BLOCK is not set

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
CONFIG_LEDS_88PM860X=y
CONFIG_LEDS_LM3530=y
# CONFIG_LEDS_LM3533 is not set
# CONFIG_LEDS_LM3642 is not set
CONFIG_LEDS_PCA9532=y
# CONFIG_LEDS_PCA9532_GPIO is not set
CONFIG_LEDS_GPIO=y
CONFIG_LEDS_LP3944=y
CONFIG_LEDS_LP55XX_COMMON=y
# CONFIG_LEDS_LP5521 is not set
CONFIG_LEDS_LP5523=y
CONFIG_LEDS_LP5562=y
# CONFIG_LEDS_LP8501 is not set
CONFIG_LEDS_LP8788=y
CONFIG_LEDS_PCA955X=y
# CONFIG_LEDS_PCA963X is not set
# CONFIG_LEDS_PCA9685 is not set
CONFIG_LEDS_WM831X_STATUS=y
CONFIG_LEDS_WM8350=y
CONFIG_LEDS_DA903X=y
CONFIG_LEDS_DA9052=y
CONFIG_LEDS_PWM=y
# CONFIG_LEDS_REGULATOR is not set
# CONFIG_LEDS_BD2802 is not set
# CONFIG_LEDS_LT3593 is not set
# CONFIG_LEDS_DELL_NETBOOKS is not set
CONFIG_LEDS_MC13783=y
CONFIG_LEDS_TCA6507=y
# CONFIG_LEDS_MAX8997 is not set
# CONFIG_LEDS_LM355x is not set
# CONFIG_LEDS_OT200 is not set
CONFIG_LEDS_BLINKM=y

#
# LED Triggers
#
CONFIG_LEDS_TRIGGERS=y
CONFIG_LEDS_TRIGGER_TIMER=y
CONFIG_LEDS_TRIGGER_ONESHOT=y
CONFIG_LEDS_TRIGGER_HEARTBEAT=y
CONFIG_LEDS_TRIGGER_BACKLIGHT=y
CONFIG_LEDS_TRIGGER_CPU=y
# CONFIG_LEDS_TRIGGER_GPIO is not set
# CONFIG_LEDS_TRIGGER_DEFAULT_ON is not set

#
# iptables trigger is under Netfilter config (LED target)
#
CONFIG_LEDS_TRIGGER_TRANSIENT=y
CONFIG_LEDS_TRIGGER_CAMERA=y
CONFIG_ACCESSIBILITY=y
CONFIG_INFINIBAND=y
# CONFIG_INFINIBAND_USER_MAD is not set
# CONFIG_INFINIBAND_USER_ACCESS is not set
CONFIG_INFINIBAND_ADDR_TRANS=y
# CONFIG_INFINIBAND_MTHCA is not set
CONFIG_INFINIBAND_AMSO1100=y
# CONFIG_INFINIBAND_AMSO1100_DEBUG is not set
CONFIG_INFINIBAND_NES=y
CONFIG_INFINIBAND_NES_DEBUG=y
# CONFIG_EDAC is not set
CONFIG_RTC_LIB=y
CONFIG_RTC_CLASS=y
CONFIG_RTC_HCTOSYS=y
CONFIG_RTC_SYSTOHC=y
CONFIG_RTC_HCTOSYS_DEVICE="rtc0"
# CONFIG_RTC_DEBUG is not set

#
# RTC interfaces
#
# CONFIG_RTC_INTF_SYSFS is not set
CONFIG_RTC_INTF_DEV=y
CONFIG_RTC_INTF_DEV_UIE_EMUL=y
# CONFIG_RTC_DRV_TEST is not set

#
# I2C RTC drivers
#
# CONFIG_RTC_DRV_88PM860X is not set
# CONFIG_RTC_DRV_DS1307 is not set
CONFIG_RTC_DRV_DS1374=y
# CONFIG_RTC_DRV_DS1672 is not set
# CONFIG_RTC_DRV_DS3232 is not set
CONFIG_RTC_DRV_HYM8563=y
CONFIG_RTC_DRV_LP8788=y
# CONFIG_RTC_DRV_MAX6900 is not set
# CONFIG_RTC_DRV_MAX8907 is not set
# CONFIG_RTC_DRV_MAX8997 is not set
# CONFIG_RTC_DRV_MAX77686 is not set
# CONFIG_RTC_DRV_RS5C372 is not set
CONFIG_RTC_DRV_ISL1208=y
CONFIG_RTC_DRV_ISL12022=y
CONFIG_RTC_DRV_ISL12057=y
# CONFIG_RTC_DRV_X1205 is not set
# CONFIG_RTC_DRV_PALMAS is not set
# CONFIG_RTC_DRV_PCF2127 is not set
# CONFIG_RTC_DRV_PCF8523 is not set
# CONFIG_RTC_DRV_PCF8563 is not set
# CONFIG_RTC_DRV_PCF8583 is not set
CONFIG_RTC_DRV_M41T80=y
# CONFIG_RTC_DRV_M41T80_WDT is not set
CONFIG_RTC_DRV_BQ32K=y
CONFIG_RTC_DRV_TWL4030=y
# CONFIG_RTC_DRV_TPS65910 is not set
# CONFIG_RTC_DRV_RC5T583 is not set
# CONFIG_RTC_DRV_S35390A is not set
CONFIG_RTC_DRV_FM3130=y
CONFIG_RTC_DRV_RX8581=y
# CONFIG_RTC_DRV_RX8025 is not set
CONFIG_RTC_DRV_EM3027=y
CONFIG_RTC_DRV_RV3029C2=y

#
# SPI RTC drivers
#

#
# Platform RTC drivers
#
# CONFIG_RTC_DRV_CMOS is not set
CONFIG_RTC_DRV_DS1286=y
# CONFIG_RTC_DRV_DS1511 is not set
CONFIG_RTC_DRV_DS1553=y
# CONFIG_RTC_DRV_DS1742 is not set
# CONFIG_RTC_DRV_DA9052 is not set
CONFIG_RTC_DRV_DA9055=y
# CONFIG_RTC_DRV_STK17TA8 is not set
CONFIG_RTC_DRV_M48T86=y
CONFIG_RTC_DRV_M48T35=y
CONFIG_RTC_DRV_M48T59=y
CONFIG_RTC_DRV_MSM6242=y
# CONFIG_RTC_DRV_BQ4802 is not set
CONFIG_RTC_DRV_RP5C01=y
CONFIG_RTC_DRV_V3020=y
CONFIG_RTC_DRV_DS2404=y
CONFIG_RTC_DRV_WM831X=y
CONFIG_RTC_DRV_WM8350=y
# CONFIG_RTC_DRV_PCF50633 is not set

#
# on-CPU RTC drivers
#
CONFIG_RTC_DRV_MC13XXX=y
CONFIG_RTC_DRV_SNVS=y
CONFIG_RTC_DRV_MOXART=y

#
# HID Sensor RTC drivers
#
# CONFIG_RTC_DRV_HID_SENSOR_TIME is not set
# CONFIG_DMADEVICES is not set
CONFIG_AUXDISPLAY=y
# CONFIG_KS0108 is not set
# CONFIG_UIO is not set
# CONFIG_VIRT_DRIVERS is not set
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
CONFIG_X86_PLATFORM_DEVICES=y
# CONFIG_ACER_WMI is not set
# CONFIG_ACERHDF is not set
# CONFIG_ASUS_LAPTOP is not set
# CONFIG_DELL_LAPTOP is not set
# CONFIG_DELL_WMI is not set
# CONFIG_DELL_WMI_AIO is not set
# CONFIG_FUJITSU_LAPTOP is not set
# CONFIG_FUJITSU_TABLET is not set
CONFIG_AMILO_RFKILL=y
# CONFIG_TC1100_WMI is not set
# CONFIG_HP_ACCEL is not set
# CONFIG_HP_WIRELESS is not set
# CONFIG_HP_WMI is not set
# CONFIG_MSI_LAPTOP is not set
# CONFIG_PANASONIC_LAPTOP is not set
# CONFIG_COMPAL_LAPTOP is not set
# CONFIG_SONY_LAPTOP is not set
# CONFIG_IDEAPAD_LAPTOP is not set
# CONFIG_THINKPAD_ACPI is not set
CONFIG_SENSORS_HDAPS=y
# CONFIG_INTEL_MENLOW is not set
# CONFIG_EEEPC_LAPTOP is not set
# CONFIG_ASUS_WMI is not set
CONFIG_ACPI_WMI=y
# CONFIG_MSI_WMI is not set
# CONFIG_TOPSTAR_LAPTOP is not set
# CONFIG_ACPI_TOSHIBA is not set
# CONFIG_TOSHIBA_BT_RFKILL is not set
# CONFIG_ACPI_CMPC is not set
# CONFIG_INTEL_IPS is not set
# CONFIG_IBM_RTL is not set
CONFIG_XO1_RFKILL=y
# CONFIG_XO15_EBOOK is not set
CONFIG_SAMSUNG_LAPTOP=y
CONFIG_MXM_WMI=y
# CONFIG_INTEL_OAKTRAIL is not set
# CONFIG_SAMSUNG_Q10 is not set
# CONFIG_APPLE_GMUX is not set
# CONFIG_INTEL_RST is not set
# CONFIG_INTEL_SMARTCONNECT is not set
# CONFIG_PVPANIC is not set
# CONFIG_CHROME_PLATFORMS is not set

#
# Hardware Spinlock drivers
#
CONFIG_CLKSRC_I8253=y
CONFIG_CLKEVT_I8253=y
CONFIG_I8253_LOCK=y
CONFIG_CLKBLD_I8253=y
CONFIG_MAILBOX=y
CONFIG_IOMMU_SUPPORT=y
CONFIG_OF_IOMMU=y
# CONFIG_INTEL_IOMMU is not set

#
# Remoteproc drivers
#
CONFIG_REMOTEPROC=y
CONFIG_STE_MODEM_RPROC=y

#
# Rpmsg drivers
#
# CONFIG_PM_DEVFREQ is not set
# CONFIG_EXTCON is not set
CONFIG_MEMORY=y
# CONFIG_IIO is not set
# CONFIG_NTB is not set
# CONFIG_VME_BUS is not set
CONFIG_PWM=y
CONFIG_PWM_SYSFS=y
CONFIG_PWM_LP3943=y
CONFIG_PWM_PCA9685=y
CONFIG_PWM_RENESAS_TPU=y
# CONFIG_PWM_TWL is not set
# CONFIG_PWM_TWL_LED is not set
CONFIG_IRQCHIP=y
# CONFIG_IPACK_BUS is not set
CONFIG_RESET_CONTROLLER=y
CONFIG_FMC=y
CONFIG_FMC_FAKEDEV=y
CONFIG_FMC_TRIVIAL=y
CONFIG_FMC_WRITE_EEPROM=y
# CONFIG_FMC_CHARDEV is not set

#
# PHY Subsystem
#
CONFIG_GENERIC_PHY=y
CONFIG_PHY_EXYNOS_MIPI_VIDEO=y
# CONFIG_PHY_EXYNOS_DP_VIDEO is not set
# CONFIG_BCM_KONA_USB2_PHY is not set
CONFIG_POWERCAP=y
# CONFIG_INTEL_RAPL is not set

#
# Firmware Drivers
#
# CONFIG_EDD is not set
CONFIG_FIRMWARE_MEMMAP=y
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
CONFIG_EXT2_FS=y
CONFIG_EXT2_FS_XATTR=y
CONFIG_EXT2_FS_POSIX_ACL=y
# CONFIG_EXT2_FS_SECURITY is not set
# CONFIG_EXT2_FS_XIP is not set
CONFIG_EXT3_FS=y
# CONFIG_EXT3_DEFAULTS_TO_ORDERED is not set
# CONFIG_EXT3_FS_XATTR is not set
CONFIG_EXT4_FS=y
# CONFIG_EXT4_FS_POSIX_ACL is not set
CONFIG_EXT4_FS_SECURITY=y
# CONFIG_EXT4_DEBUG is not set
CONFIG_JBD=y
# CONFIG_JBD_DEBUG is not set
CONFIG_JBD2=y
# CONFIG_JBD2_DEBUG is not set
CONFIG_FS_MBCACHE=y
# CONFIG_REISERFS_FS is not set
# CONFIG_JFS_FS is not set
# CONFIG_XFS_FS is not set
CONFIG_GFS2_FS=y
CONFIG_GFS2_FS_LOCKING_DLM=y
# CONFIG_OCFS2_FS is not set
CONFIG_BTRFS_FS=y
CONFIG_BTRFS_FS_POSIX_ACL=y
# CONFIG_BTRFS_FS_CHECK_INTEGRITY is not set
# CONFIG_BTRFS_FS_RUN_SANITY_TESTS is not set
CONFIG_BTRFS_DEBUG=y
CONFIG_BTRFS_ASSERT=y
# CONFIG_NILFS2_FS is not set
CONFIG_FS_POSIX_ACL=y
CONFIG_EXPORTFS=y
# CONFIG_FILE_LOCKING is not set
CONFIG_FSNOTIFY=y
# CONFIG_DNOTIFY is not set
# CONFIG_INOTIFY_USER is not set
CONFIG_FANOTIFY=y
# CONFIG_QUOTA is not set
# CONFIG_QUOTA_NETLINK_INTERFACE is not set
CONFIG_QUOTACTL=y
CONFIG_AUTOFS4_FS=y
CONFIG_FUSE_FS=y
# CONFIG_CUSE is not set

#
# Caches
#
# CONFIG_FSCACHE is not set

#
# CD-ROM/DVD Filesystems
#
# CONFIG_ISO9660_FS is not set
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
CONFIG_NTFS_DEBUG=y
CONFIG_NTFS_RW=y

#
# Pseudo filesystems
#
# CONFIG_PROC_FS is not set
CONFIG_SYSFS=y
CONFIG_TMPFS=y
# CONFIG_TMPFS_POSIX_ACL is not set
# CONFIG_TMPFS_XATTR is not set
# CONFIG_HUGETLBFS is not set
# CONFIG_HUGETLB_PAGE is not set
CONFIG_CONFIGFS_FS=y
# CONFIG_MISC_FILESYSTEMS is not set
# CONFIG_NETWORK_FILESYSTEMS is not set
CONFIG_NLS=y
CONFIG_NLS_DEFAULT="iso8859-1"
CONFIG_NLS_CODEPAGE_437=y
CONFIG_NLS_CODEPAGE_737=y
CONFIG_NLS_CODEPAGE_775=y
CONFIG_NLS_CODEPAGE_850=y
CONFIG_NLS_CODEPAGE_852=y
CONFIG_NLS_CODEPAGE_855=y
CONFIG_NLS_CODEPAGE_857=y
CONFIG_NLS_CODEPAGE_860=y
# CONFIG_NLS_CODEPAGE_861 is not set
CONFIG_NLS_CODEPAGE_862=y
CONFIG_NLS_CODEPAGE_863=y
CONFIG_NLS_CODEPAGE_864=y
CONFIG_NLS_CODEPAGE_865=y
CONFIG_NLS_CODEPAGE_866=y
CONFIG_NLS_CODEPAGE_869=y
# CONFIG_NLS_CODEPAGE_936 is not set
# CONFIG_NLS_CODEPAGE_950 is not set
CONFIG_NLS_CODEPAGE_932=y
CONFIG_NLS_CODEPAGE_949=y
CONFIG_NLS_CODEPAGE_874=y
CONFIG_NLS_ISO8859_8=y
# CONFIG_NLS_CODEPAGE_1250 is not set
CONFIG_NLS_CODEPAGE_1251=y
CONFIG_NLS_ASCII=y
CONFIG_NLS_ISO8859_1=y
# CONFIG_NLS_ISO8859_2 is not set
CONFIG_NLS_ISO8859_3=y
# CONFIG_NLS_ISO8859_4 is not set
# CONFIG_NLS_ISO8859_5 is not set
# CONFIG_NLS_ISO8859_6 is not set
CONFIG_NLS_ISO8859_7=y
CONFIG_NLS_ISO8859_9=y
CONFIG_NLS_ISO8859_13=y
# CONFIG_NLS_ISO8859_14 is not set
# CONFIG_NLS_ISO8859_15 is not set
CONFIG_NLS_KOI8_R=y
CONFIG_NLS_KOI8_U=y
CONFIG_NLS_MAC_ROMAN=y
# CONFIG_NLS_MAC_CELTIC is not set
CONFIG_NLS_MAC_CENTEURO=y
CONFIG_NLS_MAC_CROATIAN=y
# CONFIG_NLS_MAC_CYRILLIC is not set
# CONFIG_NLS_MAC_GAELIC is not set
# CONFIG_NLS_MAC_GREEK is not set
CONFIG_NLS_MAC_ICELAND=y
CONFIG_NLS_MAC_INUIT=y
CONFIG_NLS_MAC_ROMANIAN=y
CONFIG_NLS_MAC_TURKISH=y
# CONFIG_NLS_UTF8 is not set
CONFIG_DLM=y
# CONFIG_DLM_DEBUG is not set

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
CONFIG_ENABLE_WARN_DEPRECATED=y
CONFIG_ENABLE_MUST_CHECK=y
CONFIG_FRAME_WARN=1024
# CONFIG_STRIP_ASM_SYMS is not set
CONFIG_READABLE_ASM=y
CONFIG_UNUSED_SYMBOLS=y
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
# CONFIG_DEBUG_PAGEALLOC is not set
# CONFIG_DEBUG_OBJECTS is not set
CONFIG_SLUB_DEBUG_ON=y
CONFIG_SLUB_STATS=y
CONFIG_HAVE_DEBUG_KMEMLEAK=y
# CONFIG_DEBUG_KMEMLEAK is not set
CONFIG_DEBUG_STACK_USAGE=y
# CONFIG_DEBUG_VM is not set
# CONFIG_DEBUG_VIRTUAL is not set
# CONFIG_DEBUG_MEMORY_INIT is not set
# CONFIG_DEBUG_PER_CPU_MAPS is not set
# CONFIG_DEBUG_HIGHMEM is not set
CONFIG_HAVE_DEBUG_STACKOVERFLOW=y
# CONFIG_DEBUG_STACKOVERFLOW is not set
CONFIG_HAVE_ARCH_KMEMCHECK=y
CONFIG_DEBUG_SHIRQ=y

#
# Debug Lockups and Hangs
#
CONFIG_LOCKUP_DETECTOR=y
CONFIG_HARDLOCKUP_DETECTOR=y
CONFIG_BOOTPARAM_HARDLOCKUP_PANIC=y
CONFIG_BOOTPARAM_HARDLOCKUP_PANIC_VALUE=1
CONFIG_BOOTPARAM_SOFTLOCKUP_PANIC=y
CONFIG_BOOTPARAM_SOFTLOCKUP_PANIC_VALUE=1
# CONFIG_DETECT_HUNG_TASK is not set
# CONFIG_PANIC_ON_OOPS is not set
CONFIG_PANIC_ON_OOPS_VALUE=0
CONFIG_PANIC_TIMEOUT=0
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
# CONFIG_DEBUG_LOCKDEP is not set
CONFIG_DEBUG_ATOMIC_SLEEP=y
CONFIG_DEBUG_LOCKING_API_SELFTESTS=y
CONFIG_TRACE_IRQFLAGS=y
CONFIG_STACKTRACE=y
# CONFIG_DEBUG_KOBJECT is not set
CONFIG_DEBUG_BUGVERBOSE=y
# CONFIG_DEBUG_WRITECOUNT is not set
# CONFIG_DEBUG_LIST is not set
# CONFIG_DEBUG_SG is not set
CONFIG_DEBUG_NOTIFIERS=y
# CONFIG_DEBUG_CREDENTIALS is not set

#
# RCU Debugging
#
CONFIG_PROVE_RCU=y
CONFIG_PROVE_RCU_REPEATEDLY=y
# CONFIG_PROVE_RCU_DELAY is not set
CONFIG_SPARSE_RCU_POINTER=y
# CONFIG_RCU_TORTURE_TEST is not set
CONFIG_RCU_CPU_STALL_TIMEOUT=21
# CONFIG_RCU_CPU_STALL_VERBOSE is not set
# CONFIG_RCU_CPU_STALL_INFO is not set
# CONFIG_RCU_TRACE is not set
# CONFIG_DEBUG_BLOCK_EXT_DEVT is not set
CONFIG_NOTIFIER_ERROR_INJECTION=y
CONFIG_PM_NOTIFIER_ERROR_INJECT=y
CONFIG_FAULT_INJECTION=y
CONFIG_FAILSLAB=y
CONFIG_FAIL_PAGE_ALLOC=y
# CONFIG_FAIL_MAKE_REQUEST is not set
CONFIG_FAIL_IO_TIMEOUT=y
CONFIG_FAIL_MMC_REQUEST=y
CONFIG_FAULT_INJECTION_DEBUG_FS=y
CONFIG_FAULT_INJECTION_STACKTRACE_FILTER=y
CONFIG_ARCH_HAS_DEBUG_STRICT_USER_COPY_CHECKS=y
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
# CONFIG_SCHED_TRACER is not set
# CONFIG_FTRACE_SYSCALLS is not set
CONFIG_TRACER_SNAPSHOT=y
CONFIG_TRACER_SNAPSHOT_PER_CPU_SWAP=y
CONFIG_TRACE_BRANCH_PROFILING=y
# CONFIG_BRANCH_PROFILE_NONE is not set
CONFIG_PROFILE_ANNOTATED_BRANCHES=y
# CONFIG_PROFILE_ALL_BRANCHES is not set
CONFIG_TRACING_BRANCHES=y
CONFIG_BRANCH_TRACER=y
# CONFIG_STACK_TRACER is not set
CONFIG_BLK_DEV_IO_TRACE=y
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
# CONFIG_TEST_LIST_SORT is not set
# CONFIG_BACKTRACE_SELF_TEST is not set
# CONFIG_RBTREE_TEST is not set
CONFIG_ATOMIC64_SELFTEST=y
# CONFIG_TEST_STRING_HELPERS is not set
CONFIG_TEST_KSTRTOX=y
CONFIG_PROVIDE_OHCI1394_DMA_INIT=y
# CONFIG_DMA_API_DEBUG is not set
# CONFIG_SAMPLES is not set
CONFIG_HAVE_ARCH_KGDB=y
# CONFIG_KGDB is not set
CONFIG_STRICT_DEVMEM=y
CONFIG_X86_VERBOSE_BOOTUP=y
CONFIG_EARLY_PRINTK=y
CONFIG_EARLY_PRINTK_DBGP=y
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
CONFIG_DEBUG_BOOT_PARAMS=y
# CONFIG_CPA_DEBUG is not set
CONFIG_OPTIMIZE_INLINING=y
CONFIG_DEBUG_NMI_SELFTEST=y
# CONFIG_X86_DEBUG_STATIC_CPU_HAS is not set

#
# Security options
#
# CONFIG_KEYS is not set
CONFIG_SECURITY_DMESG_RESTRICT=y
# CONFIG_SECURITY is not set
CONFIG_SECURITYFS=y
CONFIG_DEFAULT_SECURITY_DAC=y
CONFIG_DEFAULT_SECURITY=""
CONFIG_XOR_BLOCKS=y
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
CONFIG_CRYPTO_MANAGER_DISABLE_TESTS=y
CONFIG_CRYPTO_GF128MUL=y
CONFIG_CRYPTO_NULL=y
CONFIG_CRYPTO_PCRYPT=y
CONFIG_CRYPTO_WORKQUEUE=y
CONFIG_CRYPTO_CRYPTD=y
CONFIG_CRYPTO_AUTHENC=y
CONFIG_CRYPTO_ABLK_HELPER=y

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
# CONFIG_CRYPTO_PCBC is not set
CONFIG_CRYPTO_XTS=y

#
# Hash modes
#
# CONFIG_CRYPTO_CMAC is not set
CONFIG_CRYPTO_HMAC=y
CONFIG_CRYPTO_XCBC=y
# CONFIG_CRYPTO_VMAC is not set

#
# Digest
#
CONFIG_CRYPTO_CRC32C=y
# CONFIG_CRYPTO_CRC32C_INTEL is not set
# CONFIG_CRYPTO_CRC32 is not set
CONFIG_CRYPTO_CRC32_PCLMUL=y
CONFIG_CRYPTO_CRCT10DIF=y
CONFIG_CRYPTO_GHASH=y
CONFIG_CRYPTO_MD4=y
CONFIG_CRYPTO_MD5=y
# CONFIG_CRYPTO_MICHAEL_MIC is not set
CONFIG_CRYPTO_RMD128=y
# CONFIG_CRYPTO_RMD160 is not set
CONFIG_CRYPTO_RMD256=y
CONFIG_CRYPTO_RMD320=y
CONFIG_CRYPTO_SHA1=y
CONFIG_CRYPTO_SHA256=y
CONFIG_CRYPTO_SHA512=y
CONFIG_CRYPTO_TGR192=y
CONFIG_CRYPTO_WP512=y

#
# Ciphers
#
CONFIG_CRYPTO_AES=y
CONFIG_CRYPTO_AES_586=y
CONFIG_CRYPTO_AES_NI_INTEL=y
CONFIG_CRYPTO_ANUBIS=y
# CONFIG_CRYPTO_ARC4 is not set
CONFIG_CRYPTO_BLOWFISH=y
CONFIG_CRYPTO_BLOWFISH_COMMON=y
CONFIG_CRYPTO_CAMELLIA=y
# CONFIG_CRYPTO_CAST5 is not set
# CONFIG_CRYPTO_CAST6 is not set
CONFIG_CRYPTO_DES=y
# CONFIG_CRYPTO_FCRYPT is not set
CONFIG_CRYPTO_KHAZAD=y
CONFIG_CRYPTO_SALSA20=y
# CONFIG_CRYPTO_SALSA20_586 is not set
CONFIG_CRYPTO_SEED=y
# CONFIG_CRYPTO_SERPENT is not set
# CONFIG_CRYPTO_SERPENT_SSE2_586 is not set
CONFIG_CRYPTO_TEA=y
CONFIG_CRYPTO_TWOFISH=y
CONFIG_CRYPTO_TWOFISH_COMMON=y
CONFIG_CRYPTO_TWOFISH_586=y

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
CONFIG_CRYPTO_ANSI_CPRNG=y
CONFIG_CRYPTO_USER_API=y
CONFIG_CRYPTO_USER_API_HASH=y
CONFIG_CRYPTO_USER_API_SKCIPHER=y
CONFIG_CRYPTO_HW=y
CONFIG_CRYPTO_DEV_PADLOCK=y
CONFIG_CRYPTO_DEV_PADLOCK_AES=y
# CONFIG_CRYPTO_DEV_PADLOCK_SHA is not set
# CONFIG_CRYPTO_DEV_GEODE is not set
CONFIG_CRYPTO_DEV_HIFN_795X=y
# CONFIG_CRYPTO_DEV_HIFN_795X_RNG is not set
# CONFIG_CRYPTO_DEV_CCP is not set
CONFIG_HAVE_KVM=y
CONFIG_VIRTUALIZATION=y
# CONFIG_KVM is not set
CONFIG_BINARY_PRINTF=y

#
# Library routines
#
CONFIG_RAID6_PQ=y
CONFIG_BITREVERSE=y
CONFIG_GENERIC_STRNCPY_FROM_USER=y
CONFIG_GENERIC_STRNLEN_USER=y
CONFIG_GENERIC_NET_UTILS=y
CONFIG_GENERIC_FIND_FIRST_BIT=y
CONFIG_GENERIC_PCI_IOMAP=y
CONFIG_GENERIC_IOMAP=y
CONFIG_GENERIC_IO=y
CONFIG_PERCPU_RWSEM=y
CONFIG_CRC_CCITT=y
CONFIG_CRC16=y
CONFIG_CRC_T10DIF=y
CONFIG_CRC_ITU_T=y
CONFIG_CRC32=y
# CONFIG_CRC32_SELFTEST is not set
CONFIG_CRC32_SLICEBY8=y
# CONFIG_CRC32_SLICEBY4 is not set
# CONFIG_CRC32_SARWATE is not set
# CONFIG_CRC32_BIT is not set
CONFIG_CRC7=y
CONFIG_LIBCRC32C=y
# CONFIG_CRC8 is not set
CONFIG_AUDIT_GENERIC=y
# CONFIG_RANDOM32_SELFTEST is not set
CONFIG_ZLIB_INFLATE=y
CONFIG_ZLIB_DEFLATE=y
CONFIG_LZO_COMPRESS=y
CONFIG_LZO_DECOMPRESS=y
CONFIG_LZ4HC_COMPRESS=y
CONFIG_LZ4_DECOMPRESS=y
# CONFIG_XZ_DEC is not set
# CONFIG_XZ_DEC_BCJ is not set
CONFIG_DECOMPRESS_GZIP=y
CONFIG_DECOMPRESS_BZIP2=y
CONFIG_DECOMPRESS_LZO=y
CONFIG_GENERIC_ALLOCATOR=y
CONFIG_HAS_IOMEM=y
CONFIG_HAS_IOPORT=y
CONFIG_HAS_DMA=y
CONFIG_CHECK_SIGNATURE=y
CONFIG_CPU_RMAP=y
CONFIG_DQL=y
CONFIG_NLATTR=y
CONFIG_ARCH_HAS_ATOMIC64_DEC_IF_POSITIVE=y
CONFIG_AVERAGE=y
# CONFIG_CORDIC is not set
# CONFIG_DDR is not set

--a8Wt8u1KmwUX3Y2C--
