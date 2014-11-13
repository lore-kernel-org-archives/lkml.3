Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932917AbaKMMlL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Nov 2014 07:41:11 -0500
Received: from mga02.intel.com ([134.134.136.20]:5885 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932562AbaKMMlG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Nov 2014 07:41:06 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.07,376,1413270000"; 
   d="scan'208";a="636343692"
Date: Thu, 13 Nov 2014 20:39:58 +0800
From: Fengguang Wu <fengguang.wu@intel.com>
To: Jiang Liu <jiang.liu@linux.intel.com>
Cc: LKP <lkp@01.org>, linux-kernel@vger.kernel.org,
        Yuanhan Liu <yuanhan.liu@intel.com>
Subject: [x86, irq] INFO: task swapper/0:1 blocked for more than 120 seconds.
Message-ID: <20141113123958.GA15348@wfg-t540p.sh.intel.com>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="UlVJffcvxoiEqYs2"
Content-Disposition: inline
User-Agent: Heirloom mailx 12.5 6/20/10
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--UlVJffcvxoiEqYs2
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi Jiang,

0day kernel testing robot got the below dmesg and the first bad commit is

https://github.com/jiangliu/linux.git irqdomain/p4v2

commit b8c2d075135a41f69254a75c4f26162559503ab4
Author:     Jiang Liu <jiang.liu@linux.intel.com>
AuthorDate: Sun Nov 2 22:16:02 2014 +0800
Commit:     Jiang Liu <jiang.liu@linux.intel.com>
CommitDate: Tue Nov 11 21:10:49 2014 +0800

    x86, irq: Use cached IOAPIC entry instead of reading from hardware
    
    Use cahced IOAPIC entry instead of reading data from IOAPIC hardware
    registers to improve performance.
    
    Signed-off-by: Jiang Liu <jiang.liu@linux.intel.com>

+--------------------------------------------------+------------+------------+------------+
|                                                  | 384c30d19a | b8c2d07513 | 349d0daa5e |
+--------------------------------------------------+------------+------------+------------+
| boot_successes                                   | 1000       | 34         | 10         |
| boot_failures                                    | 0          | 31         | 15         |
| BUG:kernel_test_hang                             | 0          | 5          |            |
| INFO:task_blocked_for_more_than#seconds          | 0          | 26         | 15         |
| RIP:native_apic_mem_write                        | 0          | 26         | 15         |
| RIP:native_safe_halt                             | 0          | 6          | 5          |
| Kernel_panic-not_syncing:hung_task:blocked_tasks | 0          | 26         | 15         |
| backtrace:init                                   | 0          | 26         | 15         |
| backtrace:kernel_init_freeable                   | 0          | 26         | 15         |
| backtrace:watchdog                               | 0          | 26         | 15         |
| backtrace:cpu_startup_entry                      | 0          | 6          | 5          |
+--------------------------------------------------+------------+------------+------------+

[  120.948052] Writes:  Total: 2  Max/Min: 0/0   Fail: 0 
[  180.948037] Writes:  Total: 2  Max/Min: 0/0   Fail: 0 
[  180.948037] Writes:  Total: 2  Max/Min: 0/0   Fail: 0 
[  240.224080] INFO: task swapper/0:1 blocked for more than 120 seconds.
[  240.224080] INFO: task swapper/0:1 blocked for more than 120 seconds.
[  240.225192]       Not tainted 3.18.0-rc3-gb8c2d07 #8
[  240.225192]       Not tainted 3.18.0-rc3-gb8c2d07 #8
[  240.226050] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.

git bisect start 349d0daa5e14b9b402a2dea3e602ef1cb109173b 0df1f2487d2f0d04703f142813d53615d62a1da4 --
git bisect good 71d00938cba8f46d6cd7af0577a19ee256989c80  # 14:42    390+      0  x86, PCI, MSI: Use hierarchy irqdomain to manage MSI interrupts
git bisect good 08076214697dcf740059247de8e40a76404c98ce  # 15:27    390+      0  x86: irq_remapping: Clean up unused interfaces
git bisect  bad 62995ecf6bad313d8925906aad7202c586d6abf8  # 15:27      0-     11  ACPI, irq, x86: Kill private function mp_register_gsi()/ mp_unregister_gsi()
git bisect good 384c30d19a855f8c2df40e4627baece3f815792c  # 15:27    780+      0  x86, irq: Clean up io_apic.h
git bisect  bad 73b43c2b87de413c0297c029cc193f2919f75e29  # 15:27      0-     14  x86, irq: Kill function apic_set_affinity()
git bisect  bad c07b9f681c75ae000e986b38ddb59cfc867e181c  # 15:27      0-     28  x86, irq: Kill unused alloc_irq_and_cfg_at()
git bisect  bad b8c2d075135a41f69254a75c4f26162559503ab4  # 15:27      0-     31  x86, irq: Use cached IOAPIC entry instead of reading from hardware
# first bad commit: [b8c2d075135a41f69254a75c4f26162559503ab4] x86, irq: Use cached IOAPIC entry instead of reading from hardware
git bisect good 384c30d19a855f8c2df40e4627baece3f815792c  # 16:23   1000+      0  x86, irq: Clean up io_apic.h
git bisect  bad ed233b3515062f426278aa6c87594e7f0c38e39f  # 16:23      0-     31  0day head guard for 'devel-lkp-ib04-smoke-201411130604'
git bisect good 04689e749b7ec156291446028a0ce2e685bf3855  # 17:34   1000+      0  Merge tag 'for-linus' of git://git.kernel.org/pub/scm/virt/kvm/kvm
git bisect good bbdef57970d5e1887de755474ff1562baa17ef11  # 18:03   1000+      0  Add linux-next specific files for 20141113


This script may reproduce the error.

----------------------------------------------------------------------------
#!/bin/bash

kernel=$1
initrd=yocto-minimal-x86_64.cgz

wget --no-clobber https://github.com/fengguang/reproduce-kernel-bug/raw/master/initrd/$initrd

kvm=(
	qemu-system-x86_64
	-cpu kvm64
	-enable-kvm
	-kernel $kernel
	-initrd $initrd
	-m 320
	-smp 1
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

--UlVJffcvxoiEqYs2
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="dmesg-yocto-vp-55:20141113050059:x86_64-randconfig-ib0-11122254:3.18.0-rc3-gb8c2d07:8"
Content-Transfer-Encoding: quoted-printable

early console in setup code
early console in decompress_kernel

Decompressing Linux... Parsing ELF... done.
Booting the kernel.
[    0.000000] Linux version 3.18.0-rc3-gb8c2d07 (kbuild@lkp-ib04) (gcc ver=
sion 4.9.1 (Debian 4.9.1-19) ) #8 SMP Thu Nov 13 04:49:51 CST 2014
[    0.000000] Command line: hung_task_panic=3D1 earlyprintk=3DttyS0,115200=
 debug apic=3Ddebug sysrq_always_enabled rcupdate.rcu_cpu_stall_timeout=3D1=
00 panic=3D-1 softlockup_panic=3D1 nmi_watchdog=3Dpanic oops=3Dpanic load_r=
amdisk=3D2 prompt_ramdisk=3D0 console=3DttyS0,115200 console=3Dtty0 vga=3Dn=
ormal  root=3D/dev/ram0 rw link=3D/kbuild-tests/run-queue/kvm/x86_64-randco=
nfig-ib0-11122254/arm-platforms:irq:stacked-its-v2:b8c2d075135a41f69254a75c=
4f26162559503ab4:bisect-linux-7/.vmlinuz-b8c2d075135a41f69254a75c4f26162559=
503ab4-20141113045005-43-vp branch=3Darm-platforms/irq/stacked-its-v2 BOOT_=
IMAGE=3D/kernel/x86_64-randconfig-ib0-11122254/b8c2d075135a41f69254a75c4f26=
162559503ab4/vmlinuz-3.18.0-rc3-gb8c2d07 drbd.minor_count=3D8
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
[    0.000000] Base memory trampoline at [ffff880000099000] 99000 size 24576
[    0.000000] init_memory_mapping: [mem 0x00000000-0x000fffff]
[    0.000000]  [mem 0x00000000-0x000fffff] page 4k
[    0.000000] BRK [0x024e2000, 0x024e2fff] PGTABLE
[    0.000000] BRK [0x024e3000, 0x024e3fff] PGTABLE
[    0.000000] BRK [0x024e4000, 0x024e4fff] PGTABLE
[    0.000000] init_memory_mapping: [mem 0x13a00000-0x13bfffff]
[    0.000000]  [mem 0x13a00000-0x13bfffff] page 4k
[    0.000000] BRK [0x024e5000, 0x024e5fff] PGTABLE
[    0.000000] init_memory_mapping: [mem 0x10000000-0x139fffff]
[    0.000000]  [mem 0x10000000-0x139fffff] page 4k
[    0.000000] BRK [0x024e6000, 0x024e6fff] PGTABLE
[    0.000000] BRK [0x024e7000, 0x024e7fff] PGTABLE
[    0.000000] init_memory_mapping: [mem 0x00100000-0x0fffffff]
[    0.000000]  [mem 0x00100000-0x0fffffff] page 4k
[    0.000000] init_memory_mapping: [mem 0x13c00000-0x13ffdfff]
[    0.000000]  [mem 0x13c00000-0x13ffdfff] page 4k
[    0.000000] RAMDISK: [mem 0x13ce6000-0x13feffff]
[    0.000000] ACPI: Early table checksum verification disabled
[    0.000000] ACPI: RSDP 0x00000000000FD970 000014 (v00 BOCHS )
[    0.000000] ACPI: RSDT 0x0000000013FFE4B0 000034 (v01 BOCHS  BXPCRSDT 00=
000001 BXPC 00000001)
[    0.000000] ACPI: FACP 0x0000000013FFFF80 000074 (v01 BOCHS  BXPCFACP 00=
000001 BXPC 00000001)
[    0.000000] ACPI: DSDT 0x0000000013FFE4F0 0011A9 (v01 BXPC   BXDSDT   00=
000001 INTL 20100528)
[    0.000000] ACPI: FACS 0x0000000013FFFF40 000040
[    0.000000] ACPI: SSDT 0x0000000013FFF800 000735 (v01 BOCHS  BXPCSSDT 00=
000001 BXPC 00000001)
[    0.000000] ACPI: APIC 0x0000000013FFF6E0 000078 (v01 BOCHS  BXPCAPIC 00=
000001 BXPC 00000001)
[    0.000000] ACPI: HPET 0x0000000013FFF6A0 000038 (v01 BOCHS  BXPCHPET 00=
000001 BXPC 00000001)
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] mapped APIC to ffffffffff5fc000 (        fee00000)
[    0.000000] No NUMA configuration found
[    0.000000] Faking a node at [mem 0x0000000000000000-0x0000000013ffdfff]
[    0.000000] NODE_DATA(0) allocated [mem 0x13ff0000-0x13ffdfff]
[    0.000000] kvm-clock: Using msrs 4b564d01 and 4b564d00
[    0.000000] kvm-clock: cpu 0, msr 0:13ce5001, primary cpu clock
[    0.000000]  [ffffea0000000000-ffffea00005fffff] PMD -> [ffff880012c0000=
0-ffff8800131fffff] on node 0
[    0.000000] Zone ranges:
[    0.000000]   DMA32    [mem 0x00001000-0xffffffff]
[    0.000000]   Normal   empty
[    0.000000] Movable zone start for each node
[    0.000000] Early memory node ranges
[    0.000000]   node   0: [mem 0x00001000-0x0009efff]
[    0.000000]   node   0: [mem 0x00100000-0x13ffdfff]
[    0.000000] Initmem setup node 0 [mem 0x00001000-0x13ffdfff]
[    0.000000] On node 0 totalpages: 81820
[    0.000000]   DMA32 zone: 1280 pages used for memmap
[    0.000000]   DMA32 zone: 21 pages reserved
[    0.000000]   DMA32 zone: 81820 pages, LIFO batch:15
[    0.000000] ACPI: PM-Timer IO Port: 0xb008
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] mapped APIC to ffffffffff5fc000 (        fee00000)
[    0.000000] ACPI: LAPIC (acpi_id[0x00] lapic_id[0x00] enabled)
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
[    0.000000] smpboot: Allowing 1 CPUs, 0 hotplug CPUs
[    0.000000] mapped IOAPIC to ffffffffff5fb000 (fec00000)
[    0.000000] PM: Registered nosave memory: [mem 0x00000000-0x00000fff]
[    0.000000] PM: Registered nosave memory: [mem 0x0009f000-0x0009ffff]
[    0.000000] PM: Registered nosave memory: [mem 0x000a0000-0x000effff]
[    0.000000] PM: Registered nosave memory: [mem 0x000f0000-0x000fffff]
[    0.000000] e820: [mem 0x14000000-0xfeffbfff] available for PCI devices
[    0.000000] Booting paravirtualized kernel on KVM
[    0.000000] setup_percpu: NR_CPUS:8 nr_cpumask_bits:8 nr_cpu_ids:1 nr_no=
de_ids:1
[    0.000000] PERCPU: Embedded 29 pages/cpu @ffff880013800000 s79424 r8192=
 d31168 u2097152
[    0.000000] pcpu-alloc: s79424 r8192 d31168 u2097152 alloc=3D1*2097152
[    0.000000] pcpu-alloc: [0] 0=20
[    0.000000] KVM setup async PF for cpu 0
[    0.000000] kvm-stealtime: cpu 0, msr 1380de00
[    0.000000] Built 1 zonelists in Node order, mobility grouping on.  Tota=
l pages: 80519
[    0.000000] Policy zone: DMA32
[    0.000000] Kernel command line: hung_task_panic=3D1 earlyprintk=3DttyS0=
,115200 debug apic=3Ddebug sysrq_always_enabled rcupdate.rcu_cpu_stall_time=
out=3D100 panic=3D-1 softlockup_panic=3D1 nmi_watchdog=3Dpanic oops=3Dpanic=
 load_ramdisk=3D2 prompt_ramdisk=3D0 console=3DttyS0,115200 console=3Dtty0 =
vga=3Dnormal  root=3D/dev/ram0 rw link=3D/kbuild-tests/run-queue/kvm/x86_64=
-randconfig-ib0-11122254/arm-platforms:irq:stacked-its-v2:b8c2d075135a41f69=
254a75c4f26162559503ab4:bisect-linux-7/.vmlinuz-b8c2d075135a41f69254a75c4f2=
6162559503ab4-20141113045005-43-vp branch=3Darm-platforms/irq/stacked-its-v=
2 BOOT_IMAGE=3D/kernel/x86_64-randconfig-ib0-11122254/b8c2d075135a41f69254a=
75c4f26162559503ab4/vmlinuz-3.18.0-rc3-gb8c2d07 drbd.minor_count=3D8
[    0.000000] sysrq: sysrq always enabled.
[    0.000000] PID hash table entries: 2048 (order: 2, 16384 bytes)
[    0.000000] Memory: 295404K/327280K available (5458K kernel code, 996K r=
wdata, 3396K rodata, 732K init, 10776K bss, 31876K reserved)
[    0.000000] SLUB: HWalign=3D64, Order=3D0-3, MinObjects=3D0, CPUs=3D1, N=
odes=3D1
[    0.000000] Hierarchical RCU implementation.
[    0.000000] RCU: Adjusting geometry for rcu_fanout_leaf=3D16, nr_cpu_ids=
=3D1
[    0.000000] NR_IRQS:4352 nr_irqs:256 16
[    0.000000] Linux version 3.18.0-rc3-gb8c2d07 (kbuild@lkp-ib04) (gcc ver=
sion 4.9.1 (Debian 4.9.1-19) ) #8 SMP Thu Nov 13 04:49:51 CST 2014
[    0.000000] Command line: hung_task_panic=3D1 earlyprintk=3DttyS0,115200=
 debug apic=3Ddebug sysrq_always_enabled rcupdate.rcu_cpu_stall_timeout=3D1=
00 panic=3D-1 softlockup_panic=3D1 nmi_watchdog=3Dpanic oops=3Dpanic load_r=
amdisk=3D2 prompt_ramdisk=3D0 console=3DttyS0,115200 console=3Dtty0 vga=3Dn=
ormal  root=3D/dev/ram0 rw link=3D/kbuild-tests/run-queue/kvm/x86_64-randco=
nfig-ib0-11122254/arm-platforms:irq:stacked-its-v2:b8c2d075135a41f69254a75c=
4f26162559503ab4:bisect-linux-7/.vmlinuz-b8c2d075135a41f69254a75c4f26162559=
503ab4-20141113045005-43-vp branch=3Darm-platforms/irq/stacked-its-v2 BOOT_=
IMAGE=3D/kernel/x86_64-randconfig-ib0-11122254/b8c2d075135a41f69254a75c4f26=
162559503ab4/vmlinuz-3.18.0-rc3-gb8c2d07 drbd.minor_count=3D8
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
[    0.000000] Base memory trampoline at [ffff880000099000] 99000 size 24576
[    0.000000] init_memory_mapping: [mem 0x00000000-0x000fffff]
[    0.000000]  [mem 0x00000000-0x000fffff] page 4k
[    0.000000] BRK [0x024e2000, 0x024e2fff] PGTABLE
[    0.000000] BRK [0x024e3000, 0x024e3fff] PGTABLE
[    0.000000] BRK [0x024e4000, 0x024e4fff] PGTABLE
[    0.000000] init_memory_mapping: [mem 0x13a00000-0x13bfffff]
[    0.000000]  [mem 0x13a00000-0x13bfffff] page 4k
[    0.000000] BRK [0x024e5000, 0x024e5fff] PGTABLE
[    0.000000] init_memory_mapping: [mem 0x10000000-0x139fffff]
[    0.000000]  [mem 0x10000000-0x139fffff] page 4k
[    0.000000] BRK [0x024e6000, 0x024e6fff] PGTABLE
[    0.000000] BRK [0x024e7000, 0x024e7fff] PGTABLE
[    0.000000] init_memory_mapping: [mem 0x00100000-0x0fffffff]
[    0.000000]  [mem 0x00100000-0x0fffffff] page 4k
[    0.000000] init_memory_mapping: [mem 0x13c00000-0x13ffdfff]
[    0.000000]  [mem 0x13c00000-0x13ffdfff] page 4k
[    0.000000] RAMDISK: [mem 0x13ce6000-0x13feffff]
[    0.000000] ACPI: Early table checksum verification disabled
[    0.000000] ACPI: RSDP 0x00000000000FD970 000014 (v00 BOCHS )
[    0.000000] ACPI: RSDT 0x0000000013FFE4B0 000034 (v01 BOCHS  BXPCRSDT 00=
000001 BXPC 00000001)
[    0.000000] ACPI: FACP 0x0000000013FFFF80 000074 (v01 BOCHS  BXPCFACP 00=
000001 BXPC 00000001)
[    0.000000] ACPI: DSDT 0x0000000013FFE4F0 0011A9 (v01 BXPC   BXDSDT   00=
000001 INTL 20100528)
[    0.000000] ACPI: FACS 0x0000000013FFFF40 000040
[    0.000000] ACPI: SSDT 0x0000000013FFF800 000735 (v01 BOCHS  BXPCSSDT 00=
000001 BXPC 00000001)
[    0.000000] ACPI: APIC 0x0000000013FFF6E0 000078 (v01 BOCHS  BXPCAPIC 00=
000001 BXPC 00000001)
[    0.000000] ACPI: HPET 0x0000000013FFF6A0 000038 (v01 BOCHS  BXPCHPET 00=
000001 BXPC 00000001)
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] mapped APIC to ffffffffff5fc000 (        fee00000)
[    0.000000] No NUMA configuration found
[    0.000000] Faking a node at [mem 0x0000000000000000-0x0000000013ffdfff]
[    0.000000] NODE_DATA(0) allocated [mem 0x13ff0000-0x13ffdfff]
[    0.000000] kvm-clock: Using msrs 4b564d01 and 4b564d00
[    0.000000] kvm-clock: cpu 0, msr 0:13ce5001, primary cpu clock
[    0.000000]  [ffffea0000000000-ffffea00005fffff] PMD -> [ffff880012c0000=
0-ffff8800131fffff] on node 0
[    0.000000] Zone ranges:
[    0.000000]   DMA32    [mem 0x00001000-0xffffffff]
[    0.000000]   Normal   empty
[    0.000000] Movable zone start for each node
[    0.000000] Early memory node ranges
[    0.000000]   node   0: [mem 0x00001000-0x0009efff]
[    0.000000]   node   0: [mem 0x00100000-0x13ffdfff]
[    0.000000] Initmem setup node 0 [mem 0x00001000-0x13ffdfff]
[    0.000000] On node 0 totalpages: 81820
[    0.000000]   DMA32 zone: 1280 pages used for memmap
[    0.000000]   DMA32 zone: 21 pages reserved
[    0.000000]   DMA32 zone: 81820 pages, LIFO batch:15
[    0.000000] ACPI: PM-Timer IO Port: 0xb008
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] mapped APIC to ffffffffff5fc000 (        fee00000)
[    0.000000] ACPI: LAPIC (acpi_id[0x00] lapic_id[0x00] enabled)
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
[    0.000000] smpboot: Allowing 1 CPUs, 0 hotplug CPUs
[    0.000000] mapped IOAPIC to ffffffffff5fb000 (fec00000)
[    0.000000] PM: Registered nosave memory: [mem 0x00000000-0x00000fff]
[    0.000000] PM: Registered nosave memory: [mem 0x0009f000-0x0009ffff]
[    0.000000] PM: Registered nosave memory: [mem 0x000a0000-0x000effff]
[    0.000000] PM: Registered nosave memory: [mem 0x000f0000-0x000fffff]
[    0.000000] e820: [mem 0x14000000-0xfeffbfff] available for PCI devices
[    0.000000] Booting paravirtualized kernel on KVM
[    0.000000] setup_percpu: NR_CPUS:8 nr_cpumask_bits:8 nr_cpu_ids:1 nr_no=
de_ids:1
[    0.000000] PERCPU: Embedded 29 pages/cpu @ffff880013800000 s79424 r8192=
 d31168 u2097152
[    0.000000] pcpu-alloc: s79424 r8192 d31168 u2097152 alloc=3D1*2097152
[    0.000000] pcpu-alloc: [0] 0=20
[    0.000000] KVM setup async PF for cpu 0
[    0.000000] kvm-stealtime: cpu 0, msr 1380de00
[    0.000000] Built 1 zonelists in Node order, mobility grouping on.  Tota=
l pages: 80519
[    0.000000] Policy zone: DMA32
[    0.000000] Kernel command line: hung_task_panic=3D1 earlyprintk=3DttyS0=
,115200 debug apic=3Ddebug sysrq_always_enabled rcupdate.rcu_cpu_stall_time=
out=3D100 panic=3D-1 softlockup_panic=3D1 nmi_watchdog=3Dpanic oops=3Dpanic=
 load_ramdisk=3D2 prompt_ramdisk=3D0 console=3DttyS0,115200 console=3Dtty0 =
vga=3Dnormal  root=3D/dev/ram0 rw link=3D/kbuild-tests/run-queue/kvm/x86_64=
-randconfig-ib0-11122254/arm-platforms:irq:stacked-its-v2:b8c2d075135a41f69=
254a75c4f26162559503ab4:bisect-linux-7/.vmlinuz-b8c2d075135a41f69254a75c4f2=
6162559503ab4-20141113045005-43-vp branch=3Darm-platforms/irq/stacked-its-v=
2 BOOT_IMAGE=3D/kernel/x86_64-randconfig-ib0-11122254/b8c2d075135a41f69254a=
75c4f26162559503ab4/vmlinuz-3.18.0-rc3-gb8c2d07 drbd.minor_count=3D8
[    0.000000] sysrq: sysrq always enabled.
[    0.000000] PID hash table entries: 2048 (order: 2, 16384 bytes)
[    0.000000] Memory: 295404K/327280K available (5458K kernel code, 996K r=
wdata, 3396K rodata, 732K init, 10776K bss, 31876K reserved)
[    0.000000] SLUB: HWalign=3D64, Order=3D0-3, MinObjects=3D0, CPUs=3D1, N=
odes=3D1
[    0.000000] Hierarchical RCU implementation.
[    0.000000] RCU: Adjusting geometry for rcu_fanout_leaf=3D16, nr_cpu_ids=
=3D1
[    0.000000] NR_IRQS:4352 nr_irqs:256 16
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
[    0.000000]  memory used by lock dependency info: 8127 kB
[    0.000000]  memory used by lock dependency info: 8127 kB
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
[    0.000000]                      A-A deadlock:failed|failed|failed|faile=
d|  ok  |  ok  |failed|failed|failed|failed|failed|failed|

[    0.000000]                  A-B-B-A deadlock:
[    0.000000]                  A-B-B-A deadlock:failed|failed|failed|faile=
d|  ok  |  ok  |failed|failed|failed|failed|failed|failed|

[    0.000000]              A-B-B-C-C-A deadlock:
[    0.000000]              A-B-B-C-C-A deadlock:failed|failed|failed|faile=
d|  ok  |  ok  |failed|failed|failed|failed|failed|failed|

[    0.000000]              A-B-C-A-B-C deadlock:
[    0.000000]              A-B-C-A-B-C deadlock:failed|failed|failed|faile=
d|  ok  |  ok  |failed|failed|failed|failed|failed|failed|

[    0.000000]          A-B-B-C-C-D-D-A deadlock:
[    0.000000]          A-B-B-C-C-D-D-A deadlock:failed|failed|failed|faile=
d|  ok  |  ok  |failed|failed|failed|failed|failed|failed|

[    0.000000]          A-B-C-D-B-D-D-A deadlock:
[    0.000000]          A-B-C-D-B-D-D-A deadlock:failed|failed|failed|faile=
d|  ok  |  ok  |failed|failed|failed|failed|failed|failed|

[    0.000000]          A-B-C-D-B-C-D-A deadlock:
[    0.000000]          A-B-C-D-B-C-D-A deadlock:failed|failed|failed|faile=
d|  ok  |  ok  |failed|failed|failed|failed|failed|failed|

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
 |  ok  |  ok  |             |             |failed|failed|

[    0.000000]            recursive read-lock #2:
[    0.000000]            recursive read-lock #2:             |            =
 |  ok  |  ok  |             |             |failed|failed|

[    0.000000]             mixed read-write-lock:
[    0.000000]             mixed read-write-lock:             |            =
 |failed|failed|             |             |failed|failed|

[    0.000000]             mixed write-read-lock:
[    0.000000]             mixed write-read-lock:             |            =
 |failed|failed|             |             |failed|failed|

[    0.000000]   ----------------------------------------------------------=
----------------
[    0.000000]   ----------------------------------------------------------=
----------------
[    0.000000]      hard-irqs-on + irq-safe-A/12:
[    0.000000]      hard-irqs-on + irq-safe-A/12:failed|failed|failed|faile=
d|  ok  |  ok  |

[    0.000000]      soft-irqs-on + irq-safe-A/12:
[    0.000000]      soft-irqs-on + irq-safe-A/12:failed|failed|failed|faile=
d|  ok  |  ok  |

[    0.000000]      hard-irqs-on + irq-safe-A/21:
[    0.000000]      hard-irqs-on + irq-safe-A/21:failed|failed|failed|faile=
d|  ok  |  ok  |

[    0.000000]      soft-irqs-on + irq-safe-A/21:
[    0.000000]      soft-irqs-on + irq-safe-A/21:failed|failed|failed|faile=
d|  ok  |  ok  |

[    0.000000]        sirq-safe-A =3D> hirqs-on/12:
[    0.000000]        sirq-safe-A =3D> hirqs-on/12:failed|failed|failed|fai=
led|  ok  |  ok  |

[    0.000000]        sirq-safe-A =3D> hirqs-on/21:
[    0.000000]        sirq-safe-A =3D> hirqs-on/21:failed|failed|failed|fai=
led|  ok  |  ok  |

[    0.000000]          hard-safe-A + irqs-on/12:
[    0.000000]          hard-safe-A + irqs-on/12:failed|failed|failed|faile=
d|  ok  |  ok  |

[    0.000000]          soft-safe-A + irqs-on/12:
[    0.000000]          soft-safe-A + irqs-on/12:failed|failed|failed|faile=
d|  ok  |  ok  |

[    0.000000]          hard-safe-A + irqs-on/21:
[    0.000000]          hard-safe-A + irqs-on/21:failed|failed|failed|faile=
d|  ok  |  ok  |

[    0.000000]          soft-safe-A + irqs-on/21:
[    0.000000]          soft-safe-A + irqs-on/21:failed|failed|failed|faile=
d|  ok  |  ok  |

[    0.000000]     hard-safe-A + unsafe-B #1/123:
[    0.000000]     hard-safe-A + unsafe-B #1/123:failed|failed|failed|faile=
d|  ok  |  ok  |

[    0.000000]     soft-safe-A + unsafe-B #1/123:
[    0.000000]     soft-safe-A + unsafe-B #1/123:failed|failed|failed|faile=
d|  ok  |  ok  |

[    0.000000]     hard-safe-A + unsafe-B #1/132:
[    0.000000]     hard-safe-A + unsafe-B #1/132:failed|failed|failed|faile=
d|  ok  |  ok  |

[    0.000000]     soft-safe-A + unsafe-B #1/132:
[    0.000000]     soft-safe-A + unsafe-B #1/132:failed|failed|failed|faile=
d|  ok  |  ok  |

[    0.000000]     hard-safe-A + unsafe-B #1/213:
[    0.000000]     hard-safe-A + unsafe-B #1/213:failed|failed|failed|faile=
d|  ok  |  ok  |

[    0.000000]     soft-safe-A + unsafe-B #1/213:
[    0.000000]     soft-safe-A + unsafe-B #1/213:failed|failed|failed|faile=
d|  ok  |  ok  |

[    0.000000]     hard-safe-A + unsafe-B #1/231:
[    0.000000]     hard-safe-A + unsafe-B #1/231:failed|failed|failed|faile=
d|  ok  |  ok  |

[    0.000000]     soft-safe-A + unsafe-B #1/231:
[    0.000000]     soft-safe-A + unsafe-B #1/231:failed|failed|failed|faile=
d|  ok  |  ok  |

[    0.000000]     hard-safe-A + unsafe-B #1/312:
[    0.000000]     hard-safe-A + unsafe-B #1/312:failed|failed|failed|faile=
d|  ok  |  ok  |

[    0.000000]     soft-safe-A + unsafe-B #1/312:
[    0.000000]     soft-safe-A + unsafe-B #1/312:failed|failed|failed|faile=
d|  ok  |  ok  |

[    0.000000]     hard-safe-A + unsafe-B #1/321:
[    0.000000]     hard-safe-A + unsafe-B #1/321:failed|failed|failed|faile=
d|  ok  |  ok  |

[    0.000000]     soft-safe-A + unsafe-B #1/321:
[    0.000000]     soft-safe-A + unsafe-B #1/321:failed|failed|failed|faile=
d|  ok  |  ok  |

[    0.000000]     hard-safe-A + unsafe-B #2/123:
[    0.000000]     hard-safe-A + unsafe-B #2/123:failed|failed|failed|faile=
d|  ok  |  ok  |

[    0.000000]     soft-safe-A + unsafe-B #2/123:
[    0.000000]     soft-safe-A + unsafe-B #2/123:failed|failed|failed|faile=
d|  ok  |  ok  |

[    0.000000]     hard-safe-A + unsafe-B #2/132:
[    0.000000]     hard-safe-A + unsafe-B #2/132:failed|failed|failed|faile=
d|  ok  |  ok  |

[    0.000000]     soft-safe-A + unsafe-B #2/132:
[    0.000000]     soft-safe-A + unsafe-B #2/132:failed|failed|failed|faile=
d|  ok  |  ok  |

[    0.000000]     hard-safe-A + unsafe-B #2/213:
[    0.000000]     hard-safe-A + unsafe-B #2/213:failed|failed|failed|faile=
d|  ok  |  ok  |

[    0.000000]     soft-safe-A + unsafe-B #2/213:
[    0.000000]     soft-safe-A + unsafe-B #2/213:failed|failed|failed|faile=
d|  ok  |  ok  |

[    0.000000]     hard-safe-A + unsafe-B #2/231:
[    0.000000]     hard-safe-A + unsafe-B #2/231:failed|failed|failed|faile=
d|  ok  |  ok  |

[    0.000000]     soft-safe-A + unsafe-B #2/231:
[    0.000000]     soft-safe-A + unsafe-B #2/231:failed|failed|failed|faile=
d|  ok  |  ok  |

[    0.000000]     hard-safe-A + unsafe-B #2/312:
[    0.000000]     hard-safe-A + unsafe-B #2/312:failed|failed|failed|faile=
d|  ok  |  ok  |

[    0.000000]     soft-safe-A + unsafe-B #2/312:
[    0.000000]     soft-safe-A + unsafe-B #2/312:failed|failed|failed|faile=
d|  ok  |  ok  |

[    0.000000]     hard-safe-A + unsafe-B #2/321:
[    0.000000]     hard-safe-A + unsafe-B #2/321:failed|failed|failed|faile=
d|  ok  |  ok  |

[    0.000000]     soft-safe-A + unsafe-B #2/321:
[    0.000000]     soft-safe-A + unsafe-B #2/321:failed|failed|failed|faile=
d|  ok  |  ok  |

[    0.000000]       hard-irq lock-inversion/123:
[    0.000000]       hard-irq lock-inversion/123:failed|failed|failed|faile=
d|  ok  |  ok  |

[    0.000000]       soft-irq lock-inversion/123:
[    0.000000]       soft-irq lock-inversion/123:failed|failed|failed|faile=
d|  ok  |  ok  |

[    0.000000]       hard-irq lock-inversion/132:
[    0.000000]       hard-irq lock-inversion/132:failed|failed|failed|faile=
d|  ok  |  ok  |

[    0.000000]       soft-irq lock-inversion/132:
[    0.000000]       soft-irq lock-inversion/132:failed|failed|failed|faile=
d|  ok  |  ok  |

[    0.000000]       hard-irq lock-inversion/213:
[    0.000000]       hard-irq lock-inversion/213:failed|failed|failed|faile=
d|  ok  |  ok  |

[    0.000000]       soft-irq lock-inversion/213:
[    0.000000]       soft-irq lock-inversion/213:failed|failed|failed|faile=
d|  ok  |  ok  |

[    0.000000]       hard-irq lock-inversion/231:
[    0.000000]       hard-irq lock-inversion/231:failed|failed|failed|faile=
d|  ok  |  ok  |

[    0.000000]       soft-irq lock-inversion/231:
[    0.000000]       soft-irq lock-inversion/231:failed|failed|failed|faile=
d|  ok  |  ok  |

[    0.000000]       hard-irq lock-inversion/312:
[    0.000000]       hard-irq lock-inversion/312:failed|failed|failed|faile=
d|  ok  |  ok  |

[    0.000000]       soft-irq lock-inversion/312:
[    0.000000]       soft-irq lock-inversion/312:failed|failed|failed|faile=
d|  ok  |  ok  |

[    0.000000]       hard-irq lock-inversion/321:
[    0.000000]       hard-irq lock-inversion/321:failed|failed|failed|faile=
d|  ok  |  ok  |

[    0.000000]       soft-irq lock-inversion/321:
[    0.000000]       soft-irq lock-inversion/321:failed|failed|failed|faile=
d|  ok  |  ok  |

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
[    0.000000]                ww contexts mixing:failed|failed|  ok  |  ok =
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
[    0.000000]                           context:failed|failed|  ok  |  ok =
 |  ok  |  ok  |

[    0.000000]                               try:
[    0.000000]                               try:failed|failed|  ok  |  ok =
 |failed|failed|

[    0.000000]                             block:
[    0.000000]                             block:failed|failed|  ok  |  ok =
 |failed|failed|

[    0.000000]                          spinlock:
[    0.000000]                          spinlock:failed|failed|  ok  |  ok =
 |failed|failed|

[    0.000000] --------------------------------------------------------
[    0.000000] --------------------------------------------------------
[    0.000000] 141 out of 253 testcases failed, as expected. |
[    0.000000] 141 out of 253 testcases failed, as expected. |
[    0.000000] ----------------------------------------------------
[    0.000000] ----------------------------------------------------
[    0.000000] hpet clockevent registered
[    0.000000] hpet clockevent registered
[    0.000000] tsc: Detected 2693.562 MHz processor
[    0.000000] tsc: Detected 2693.562 MHz processor
[    0.008000] Calibrating delay loop (skipped) preset value..=20
[    0.008000] Calibrating delay loop (skipped) preset value.. 5387.12 Bogo=
MIPS (lpj=3D10774248)
5387.12 BogoMIPS (lpj=3D10774248)
[    0.008000] pid_max: default: 4096 minimum: 301
[    0.008000] pid_max: default: 4096 minimum: 301
[    0.008047] ACPI: Core revision 20140926
[    0.008047] ACPI: Core revision 20140926
[    0.039761] ACPI:=20
[    0.039761] ACPI: All ACPI Tables successfully acquiredAll ACPI Tables s=
uccessfully acquired

[    0.041075] Dentry cache hash table entries: 65536 (order: 7, 524288 byt=
es)
[    0.041075] Dentry cache hash table entries: 65536 (order: 7, 524288 byt=
es)
[    0.042586] Inode-cache hash table entries: 32768 (order: 6, 262144 byte=
s)
[    0.042586] Inode-cache hash table entries: 32768 (order: 6, 262144 byte=
s)
[    0.044083] Mount-cache hash table entries: 1024 (order: 1, 8192 bytes)
[    0.044083] Mount-cache hash table entries: 1024 (order: 1, 8192 bytes)
[    0.045353] Mountpoint-cache hash table entries: 1024 (order: 1, 8192 by=
tes)
[    0.045353] Mountpoint-cache hash table entries: 1024 (order: 1, 8192 by=
tes)
[    0.047565] Last level iTLB entries: 4KB 0, 2MB 0, 4MB 0
[    0.047565] Last level dTLB entries: 4KB 0, 2MB 0, 4MB 0, 1GB 0
[    0.047565] Last level iTLB entries: 4KB 0, 2MB 0, 4MB 0
[    0.047565] Last level dTLB entries: 4KB 0, 2MB 0, 4MB 0, 1GB 0
[    0.055448] debug: unmapping init [mem 0xffffffff81a58000-0xffffffff81a5=
afff]
[    0.055448] debug: unmapping init [mem 0xffffffff81a58000-0xffffffff81a5=
afff]
[    0.057166] Getting VERSION: 50014
[    0.057166] Getting VERSION: 50014
[    0.057827] Getting VERSION: 50014
[    0.057827] Getting VERSION: 50014
[    0.058471] Getting ID: 0
[    0.058471] Getting ID: 0
[    0.058981] Getting ID: ff000000
[    0.058981] Getting ID: ff000000
[    0.060011] Getting LVT0: 8700
[    0.060011] Getting LVT0: 8700
[    0.060601] Getting LVT1: 8400
[    0.060601] Getting LVT1: 8400
[    0.061237] enabled ExtINT on CPU#0
[    0.061237] enabled ExtINT on CPU#0
[    0.062629] ENABLING IO-APIC IRQs
[    0.062629] ENABLING IO-APIC IRQs
[    0.063275] init IO_APIC IRQs
[    0.063275] init IO_APIC IRQs
[    0.064005]  apic 0 pin 0 not connected
[    0.064005]  apic 0 pin 0 not connected
[    0.064762] IOAPIC[0]: Set routing entry (0-1 -> 0x31 -> IRQ 1 Mode:0 Ac=
tive:0 Dest:1)
[    0.064762] IOAPIC[0]: Set routing entry (0-1 -> 0x31 -> IRQ 1 Mode:0 Ac=
tive:0 Dest:1)
[    0.066284] IOAPIC[0]: Set routing entry (0-2 -> 0x30 -> IRQ 0 Mode:0 Ac=
tive:0 Dest:1)
[    0.066284] IOAPIC[0]: Set routing entry (0-2 -> 0x30 -> IRQ 0 Mode:0 Ac=
tive:0 Dest:1)
[    0.067832] IOAPIC[0]: Set routing entry (0-3 -> 0x33 -> IRQ 3 Mode:0 Ac=
tive:0 Dest:1)
[    0.067832] IOAPIC[0]: Set routing entry (0-3 -> 0x33 -> IRQ 3 Mode:0 Ac=
tive:0 Dest:1)
[    0.068000] IOAPIC[0]: Set routing entry (0-4 -> 0x34 -> IRQ 4 Mode:0 Ac=
tive:0 Dest:1)
[    0.068000] IOAPIC[0]: Set routing entry (0-4 -> 0x34 -> IRQ 4 Mode:0 Ac=
tive:0 Dest:1)
[    0.068000] IOAPIC[0]: Set routing entry (0-5 -> 0x35 -> IRQ 5 Mode:1 Ac=
tive:0 Dest:1)
[    0.068000] IOAPIC[0]: Set routing entry (0-5 -> 0x35 -> IRQ 5 Mode:1 Ac=
tive:0 Dest:1)
[    0.068000] IOAPIC[0]: Set routing entry (0-6 -> 0x36 -> IRQ 6 Mode:0 Ac=
tive:0 Dest:1)
[    0.068000] IOAPIC[0]: Set routing entry (0-6 -> 0x36 -> IRQ 6 Mode:0 Ac=
tive:0 Dest:1)
[    0.068000] IOAPIC[0]: Set routing entry (0-7 -> 0x37 -> IRQ 7 Mode:0 Ac=
tive:0 Dest:1)
[    0.068000] IOAPIC[0]: Set routing entry (0-7 -> 0x37 -> IRQ 7 Mode:0 Ac=
tive:0 Dest:1)
[    0.068000] IOAPIC[0]: Set routing entry (0-8 -> 0x38 -> IRQ 8 Mode:0 Ac=
tive:0 Dest:1)
[    0.068000] IOAPIC[0]: Set routing entry (0-8 -> 0x38 -> IRQ 8 Mode:0 Ac=
tive:0 Dest:1)
[    0.068000] IOAPIC[0]: Set routing entry (0-9 -> 0x39 -> IRQ 9 Mode:1 Ac=
tive:0 Dest:1)
[    0.068000] IOAPIC[0]: Set routing entry (0-9 -> 0x39 -> IRQ 9 Mode:1 Ac=
tive:0 Dest:1)
[    0.068000] IOAPIC[0]: Set routing entry (0-10 -> 0x3a -> IRQ 10 Mode:1 =
Active:0 Dest:1)
[    0.068000] IOAPIC[0]: Set routing entry (0-10 -> 0x3a -> IRQ 10 Mode:1 =
Active:0 Dest:1)
[    0.068000] IOAPIC[0]: Set routing entry (0-11 -> 0x3b -> IRQ 11 Mode:1 =
Active:0 Dest:1)
[    0.068000] IOAPIC[0]: Set routing entry (0-11 -> 0x3b -> IRQ 11 Mode:1 =
Active:0 Dest:1)
[    0.068000] IOAPIC[0]: Set routing entry (0-12 -> 0x3c -> IRQ 12 Mode:0 =
Active:0 Dest:1)
[    0.068000] IOAPIC[0]: Set routing entry (0-12 -> 0x3c -> IRQ 12 Mode:0 =
Active:0 Dest:1)
[    0.068000] IOAPIC[0]: Set routing entry (0-13 -> 0x3d -> IRQ 13 Mode:0 =
Active:0 Dest:1)
[    0.068000] IOAPIC[0]: Set routing entry (0-13 -> 0x3d -> IRQ 13 Mode:0 =
Active:0 Dest:1)
[    0.068000] IOAPIC[0]: Set routing entry (0-14 -> 0x3e -> IRQ 14 Mode:0 =
Active:0 Dest:1)
[    0.068000] IOAPIC[0]: Set routing entry (0-14 -> 0x3e -> IRQ 14 Mode:0 =
Active:0 Dest:1)
[    0.068000] IOAPIC[0]: Set routing entry (0-15 -> 0x3f -> IRQ 15 Mode:0 =
Active:0 Dest:1)
[    0.068000] IOAPIC[0]: Set routing entry (0-15 -> 0x3f -> IRQ 15 Mode:0 =
Active:0 Dest:1)
[    0.068000]  apic 0 pin 16 not connected
[    0.068000]  apic 0 pin 16 not connected
[    0.068000]  apic 0 pin 17 not connected
[    0.068000]  apic 0 pin 17 not connected
[    0.068000]  apic 0 pin 18 not connected
[    0.068000]  apic 0 pin 18 not connected
[    0.068000]  apic 0 pin 19 not connected
[    0.068000]  apic 0 pin 19 not connected
[    0.068000]  apic 0 pin 20 not connected
[    0.068000]  apic 0 pin 20 not connected
[    0.068000]  apic 0 pin 21 not connected
[    0.068000]  apic 0 pin 21 not connected
[    0.068000]  apic 0 pin 22 not connected
[    0.068000]  apic 0 pin 22 not connected
[    0.068000]  apic 0 pin 23 not connected
[    0.068000]  apic 0 pin 23 not connected
[    0.068000] ..TIMER: vector=3D0x30 apic1=3D0 pin1=3D2 apic2=3D-1 pin2=3D=
-1
[    0.068000] ..TIMER: vector=3D0x30 apic1=3D0 pin1=3D2 apic2=3D-1 pin2=3D=
-1
[    0.068000] smpboot: CPU0:=20
[    0.068000] smpboot: CPU0: Intel Intel Common KVM processorCommon KVM pr=
ocessor (fam: 0f, model: 06 (fam: 0f, model: 06, stepping: 01)
, stepping: 01)
[    0.068625] Using local APIC timer interrupts.
[    0.068625] calibrating APIC timer ...
[    0.068625] Using local APIC timer interrupts.
[    0.068625] calibrating APIC timer ...
[    0.072000] ... lapic delta =3D 6250028
[    0.072000] ... lapic delta =3D 6250028
[    0.072000] ... PM-Timer delta =3D 357918
[    0.072000] ... PM-Timer delta =3D 357918
[    0.072000] ... PM-Timer result ok
[    0.072000] ... PM-Timer result ok
[    0.072000] ..... delta 6250028
[    0.072000] ..... delta 6250028
[    0.072000] ..... mult: 268436658
[    0.072000] ..... mult: 268436658
[    0.072000] ..... calibration result: 4000017
[    0.072000] ..... calibration result: 4000017
[    0.072000] ..... CPU clock speed is 2693.0879 MHz.
[    0.072000] ..... CPU clock speed is 2693.0879 MHz.
[    0.072000] ..... host bus clock speed is 1000.0017 MHz.
[    0.072000] ..... host bus clock speed is 1000.0017 MHz.
[    0.072088] Performance Events:=20
[    0.072088] Performance Events: unsupported Netburst CPU model 6 unsuppo=
rted Netburst CPU model 6 no PMU driver, software events only.
no PMU driver, software events only.
[    0.076381] x86: Booted up 1 node, 1 CPUs
[    0.076381] x86: Booted up 1 node, 1 CPUs
[    0.077131] smpboot: Total of 1 processors activated (5387.12 BogoMIPS)
[    0.077131] smpboot: Total of 1 processors activated (5387.12 BogoMIPS)
[    0.078496] NMI watchdog: disabled (cpu0): hardware events not enabled
[    0.078496] NMI watchdog: disabled (cpu0): hardware events not enabled
[    0.087711] xor: measuring software checksum speed
[    0.087711] xor: measuring software checksum speed
[    0.128006]    prefetch64-sse: 11750.000 MB/sec
[    0.128006]    prefetch64-sse: 11750.000 MB/sec
[    0.168002]    generic_sse:  9797.000 MB/sec
[    0.168002]    generic_sse:  9797.000 MB/sec
[    0.168794] xor: using function: prefetch64-sse (11750.000 MB/sec)
[    0.168794] xor: using function: prefetch64-sse (11750.000 MB/sec)
[    0.169968] prandom: seed boundary self test passed
[    0.169968] prandom: seed boundary self test passed
[    0.171298] prandom: 100 self tests passed
[    0.171298] prandom: 100 self tests passed
[    0.172031] atomic64_test: passed for x86-64 platform with CX8 and with =
SSE
[    0.172031] atomic64_test: passed for x86-64 platform with CX8 and with =
SSE
[    0.173317] pinctrl core: initialized pinctrl subsystem
[    0.173317] pinctrl core: initialized pinctrl subsystem
[    0.175346] regulator-dummy: no parameters
[    0.175346] regulator-dummy: no parameters
[    0.176258] RTC time:  4:56:51, date: 11/13/14
[    0.176258] RTC time:  4:56:51, date: 11/13/14
[    0.177597] NET: Registered protocol family 16
[    0.177597] NET: Registered protocol family 16
[    0.180373] cpuidle: using governor menu
[    0.180373] cpuidle: using governor menu
[    0.181453] ACPI: bus type PCI registered
[    0.181453] ACPI: bus type PCI registered
[    0.182287] PCI: Using configuration type 1 for base access
[    0.182287] PCI: Using configuration type 1 for base access
[    0.227697] Running resizable hashtable tests...
[    0.227697] Running resizable hashtable tests...
[    0.228010]   Adding 2048 keys
[    0.228010]   Adding 2048 keys
[    0.236607]   Traversal complete: counted=3D2048, nelems=3D2048, entries=
=3D2048
[    0.236607]   Traversal complete: counted=3D2048, nelems=3D2048, entries=
=3D2048
[    0.237973]   Table expansion iteration 0...
[    0.237973]   Table expansion iteration 0...
[    0.239100]   Verifying lookups...
[    0.239100]   Verifying lookups...
[    0.239847]   Table expansion iteration 1...
[    0.239847]   Table expansion iteration 1...
[    0.240459]   Verifying lookups...
[    0.240459]   Verifying lookups...
[    0.241196]   Table expansion iteration 2...
[    0.241196]   Table expansion iteration 2...
[    0.242689]   Verifying lookups...
[    0.242689]   Verifying lookups...
[    0.244092]   Table expansion iteration 3...
[    0.244092]   Table expansion iteration 3...
[    0.246095]   Verifying lookups...
[    0.246095]   Verifying lookups...
[    0.246839]   Table shrinkage iteration 0...
[    0.246839]   Table shrinkage iteration 0...
[    0.247817]   Verifying lookups...
[    0.247817]   Verifying lookups...
[    0.248104]   Table shrinkage iteration 1...
[    0.248104]   Table shrinkage iteration 1...
[    0.248967]   Verifying lookups...
[    0.248967]   Verifying lookups...
[    0.249704]   Table shrinkage iteration 2...
[    0.249704]   Table shrinkage iteration 2...
[    0.250528]   Verifying lookups...
[    0.250528]   Verifying lookups...
[    0.251265]   Table shrinkage iteration 3...
[    0.251265]   Table shrinkage iteration 3...
[    0.252033]   Verifying lookups...
[    0.252033]   Verifying lookups...
[    0.252778]   Deleting 2048 keys
[    0.252778]   Deleting 2048 keys
[    0.328012] raid6: sse2x1    7893 MB/s
[    0.328012] raid6: sse2x1    7893 MB/s
[    0.396003] raid6: sse2x2    9951 MB/s
[    0.396003] raid6: sse2x2    9951 MB/s
[    0.464004] raid6: sse2x4   11565 MB/s
[    0.464004] raid6: sse2x4   11565 MB/s
[    0.464709] raid6: using algorithm sse2x4 (11565 MB/s)
[    0.464709] raid6: using algorithm sse2x4 (11565 MB/s)
[    0.465657] raid6: using intx1 recovery algorithm
[    0.465657] raid6: using intx1 recovery algorithm
[    0.467333] ACPI: Added _OSI(Module Device)
[    0.467333] ACPI: Added _OSI(Module Device)
[    0.468003] ACPI: Added _OSI(Processor Device)
[    0.468003] ACPI: Added _OSI(Processor Device)
[    0.468825] ACPI: Added _OSI(3.0 _SCP Extensions)
[    0.468825] ACPI: Added _OSI(3.0 _SCP Extensions)
[    0.469690] ACPI: Added _OSI(Processor Aggregator Device)
[    0.469690] ACPI: Added _OSI(Processor Aggregator Device)
[    0.508228] ACPI: Interpreter enabled
[    0.508228] ACPI: Interpreter enabled
[    0.508971] ACPI: (supports S0 S4 S5)
[    0.508971] ACPI: (supports S0 S4 S5)
[    0.509651] ACPI: Using IOAPIC for interrupt routing
[    0.509651] ACPI: Using IOAPIC for interrupt routing
[    0.510747] PCI: Using host bridge windows from ACPI; if necessary, use =
"pci=3Dnocrs" and report a bug
[    0.510747] PCI: Using host bridge windows from ACPI; if necessary, use =
"pci=3Dnocrs" and report a bug
[    0.571301] ACPI: PCI Root Bridge [PCI0] (domain 0000 [bus 00-ff])
[    0.571301] ACPI: PCI Root Bridge [PCI0] (domain 0000 [bus 00-ff])
[    0.572026] acpi PNP0A03:00: _OSC: OS supports [ASPM ClockPM Segments]
[    0.572026] acpi PNP0A03:00: _OSC: OS supports [ASPM ClockPM Segments]
[    0.573322] acpi PNP0A03:00: _OSC failed (AE_NOT_FOUND); disabling ASPM
[    0.573322] acpi PNP0A03:00: _OSC failed (AE_NOT_FOUND); disabling ASPM
[    0.578548] acpi PNP0A03:00: fail to add MMCONFIG information, can't acc=
ess extended PCI configuration space under this bridge.
[    0.578548] acpi PNP0A03:00: fail to add MMCONFIG information, can't acc=
ess extended PCI configuration space under this bridge.
[    0.587724] PCI host bridge to bus 0000:00
[    0.587724] PCI host bridge to bus 0000:00
[    0.588010] pci_bus 0000:00: root bus resource [bus 00-ff]
[    0.588010] pci_bus 0000:00: root bus resource [bus 00-ff]
[    0.589025] pci_bus 0000:00: root bus resource [io  0x0000-0x0cf7]
[    0.589025] pci_bus 0000:00: root bus resource [io  0x0000-0x0cf7]
[    0.590161] pci_bus 0000:00: root bus resource [io  0x0d00-0xffff]
[    0.590161] pci_bus 0000:00: root bus resource [io  0x0d00-0xffff]
[    0.591292] pci_bus 0000:00: root bus resource [mem 0x000a0000-0x000bfff=
f]
[    0.591292] pci_bus 0000:00: root bus resource [mem 0x000a0000-0x000bfff=
f]
[    0.592009] pci_bus 0000:00: root bus resource [mem 0x80000000-0xfebffff=
f]
[    0.592009] pci_bus 0000:00: root bus resource [mem 0x80000000-0xfebffff=
f]
[    0.593310] pci 0000:00:00.0: [8086:1237] type 00 class 0x060000
[    0.593310] pci 0000:00:00.0: [8086:1237] type 00 class 0x060000
[    0.597536] pci 0000:00:01.0: [8086:7000] type 00 class 0x060100
[    0.597536] pci 0000:00:01.0: [8086:7000] type 00 class 0x060100
[    0.600950] pci 0000:00:01.1: [8086:7010] type 00 class 0x010180
[    0.600950] pci 0000:00:01.1: [8086:7010] type 00 class 0x010180
[    0.604511] pci 0000:00:01.1: reg 0x20: [io  0xc1c0-0xc1cf]
[    0.604511] pci 0000:00:01.1: reg 0x20: [io  0xc1c0-0xc1cf]
[    0.606573] pci 0000:00:01.1: legacy IDE quirk: reg 0x10: [io  0x01f0-0x=
01f7]
[    0.606573] pci 0000:00:01.1: legacy IDE quirk: reg 0x10: [io  0x01f0-0x=
01f7]
[    0.608003] pci 0000:00:01.1: legacy IDE quirk: reg 0x14: [io  0x03f6]
[    0.608003] pci 0000:00:01.1: legacy IDE quirk: reg 0x14: [io  0x03f6]
[    0.609197] pci 0000:00:01.1: legacy IDE quirk: reg 0x18: [io  0x0170-0x=
0177]
[    0.609197] pci 0000:00:01.1: legacy IDE quirk: reg 0x18: [io  0x0170-0x=
0177]
[    0.610497] pci 0000:00:01.1: legacy IDE quirk: reg 0x1c: [io  0x0376]
[    0.610497] pci 0000:00:01.1: legacy IDE quirk: reg 0x1c: [io  0x0376]
[    0.613630] pci 0000:00:01.3: [8086:7113] type 00 class 0x068000
[    0.613630] pci 0000:00:01.3: [8086:7113] type 00 class 0x068000
[    0.615120] pci 0000:00:01.3: quirk: [io  0xb000-0xb03f] claimed by PIIX=
4 ACPI
[    0.615120] pci 0000:00:01.3: quirk: [io  0xb000-0xb03f] claimed by PIIX=
4 ACPI
[    0.616013] pci 0000:00:01.3: quirk: [io  0xb100-0xb10f] claimed by PIIX=
4 SMB
[    0.616013] pci 0000:00:01.3: quirk: [io  0xb100-0xb10f] claimed by PIIX=
4 SMB
[    0.619262] pci 0000:00:02.0: [1013:00b8] type 00 class 0x030000
[    0.619262] pci 0000:00:02.0: [1013:00b8] type 00 class 0x030000
[    0.622281] pci 0000:00:02.0: reg 0x10: [mem 0xfc000000-0xfdffffff pref]
[    0.622281] pci 0000:00:02.0: reg 0x10: [mem 0xfc000000-0xfdffffff pref]
[    0.625285] pci 0000:00:02.0: reg 0x14: [mem 0xfebf0000-0xfebf0fff]
[    0.625285] pci 0000:00:02.0: reg 0x14: [mem 0xfebf0000-0xfebf0fff]
[    0.632621] pci 0000:00:02.0: reg 0x30: [mem 0xfebe0000-0xfebeffff pref]
[    0.632621] pci 0000:00:02.0: reg 0x30: [mem 0xfebe0000-0xfebeffff pref]
[    0.636671] pci 0000:00:03.0: [8086:100e] type 00 class 0x020000
[    0.636671] pci 0000:00:03.0: [8086:100e] type 00 class 0x020000
[    0.638752] pci 0000:00:03.0: reg 0x10: [mem 0xfeba0000-0xfebbffff]
[    0.638752] pci 0000:00:03.0: reg 0x10: [mem 0xfeba0000-0xfebbffff]
[    0.640493] pci 0000:00:03.0: reg 0x14: [io  0xc000-0xc03f]
[    0.640493] pci 0000:00:03.0: reg 0x14: [io  0xc000-0xc03f]
[    0.646377] pci 0000:00:03.0: reg 0x30: [mem 0xfebc0000-0xfebdffff pref]
[    0.646377] pci 0000:00:03.0: reg 0x30: [mem 0xfebc0000-0xfebdffff pref]
[    0.649861] pci 0000:00:04.0: [1af4:1001] type 00 class 0x010000
[    0.649861] pci 0000:00:04.0: [1af4:1001] type 00 class 0x010000
[    0.651967] pci 0000:00:04.0: reg 0x10: [io  0xc040-0xc07f]
[    0.651967] pci 0000:00:04.0: reg 0x10: [io  0xc040-0xc07f]
[    0.652974] pci 0000:00:04.0: reg 0x14: [mem 0xfebf1000-0xfebf1fff]
[    0.652974] pci 0000:00:04.0: reg 0x14: [mem 0xfebf1000-0xfebf1fff]
[    0.662064] pci 0000:00:05.0: [1af4:1001] type 00 class 0x010000
[    0.662064] pci 0000:00:05.0: [1af4:1001] type 00 class 0x010000
[    0.664004] pci 0000:00:05.0: reg 0x10: [io  0xc080-0xc0bf]
[    0.664004] pci 0000:00:05.0: reg 0x10: [io  0xc080-0xc0bf]
[    0.665999] pci 0000:00:05.0: reg 0x14: [mem 0xfebf2000-0xfebf2fff]
[    0.665999] pci 0000:00:05.0: reg 0x14: [mem 0xfebf2000-0xfebf2fff]
[    0.674101] pci 0000:00:06.0: [1af4:1001] type 00 class 0x010000
[    0.674101] pci 0000:00:06.0: [1af4:1001] type 00 class 0x010000
[    0.676004] pci 0000:00:06.0: reg 0x10: [io  0xc0c0-0xc0ff]
[    0.676004] pci 0000:00:06.0: reg 0x10: [io  0xc0c0-0xc0ff]
[    0.678001] pci 0000:00:06.0: reg 0x14: [mem 0xfebf3000-0xfebf3fff]
[    0.678001] pci 0000:00:06.0: reg 0x14: [mem 0xfebf3000-0xfebf3fff]
[    0.686085] pci 0000:00:07.0: [1af4:1001] type 00 class 0x010000
[    0.686085] pci 0000:00:07.0: [1af4:1001] type 00 class 0x010000
[    0.688505] pci 0000:00:07.0: reg 0x10: [io  0xc100-0xc13f]
[    0.688505] pci 0000:00:07.0: reg 0x10: [io  0xc100-0xc13f]
[    0.690494] pci 0000:00:07.0: reg 0x14: [mem 0xfebf4000-0xfebf4fff]
[    0.690494] pci 0000:00:07.0: reg 0x14: [mem 0xfebf4000-0xfebf4fff]
[    0.698565] pci 0000:00:08.0: [1af4:1001] type 00 class 0x010000
[    0.698565] pci 0000:00:08.0: [1af4:1001] type 00 class 0x010000
[    0.700505] pci 0000:00:08.0: reg 0x10: [io  0xc140-0xc17f]
[    0.700505] pci 0000:00:08.0: reg 0x10: [io  0xc140-0xc17f]
[    0.702502] pci 0000:00:08.0: reg 0x14: [mem 0xfebf5000-0xfebf5fff]
[    0.702502] pci 0000:00:08.0: reg 0x14: [mem 0xfebf5000-0xfebf5fff]
[    0.710558] pci 0000:00:09.0: [1af4:1001] type 00 class 0x010000
[    0.710558] pci 0000:00:09.0: [1af4:1001] type 00 class 0x010000
[    0.713000] pci 0000:00:09.0: reg 0x10: [io  0xc180-0xc1bf]
[    0.713000] pci 0000:00:09.0: reg 0x10: [io  0xc180-0xc1bf]
[    0.714993] pci 0000:00:09.0: reg 0x14: [mem 0xfebf6000-0xfebf6fff]
[    0.714993] pci 0000:00:09.0: reg 0x14: [mem 0xfebf6000-0xfebf6fff]
[    0.723015] pci 0000:00:0a.0: [8086:25ab] type 00 class 0x088000
[    0.723015] pci 0000:00:0a.0: [8086:25ab] type 00 class 0x088000
[    0.724531] pci 0000:00:0a.0: reg 0x10: [mem 0xfebf7000-0xfebf700f]
[    0.724531] pci 0000:00:0a.0: reg 0x10: [mem 0xfebf7000-0xfebf700f]
[    0.730835] pci_bus 0000:00: on NUMA node 0
[    0.730835] pci_bus 0000:00: on NUMA node 0
[    0.737328] ACPI: PCI Interrupt Link [LNKA] (IRQs
[    0.737328] ACPI: PCI Interrupt Link [LNKA] (IRQs 5 5 *10 *10 11 11))

[    0.739779] ACPI: PCI Interrupt Link [LNKB] (IRQs
[    0.739779] ACPI: PCI Interrupt Link [LNKB] (IRQs 5 5 *10 *10 11 11))

[    0.741609] ACPI: PCI Interrupt Link [LNKC] (IRQs
[    0.741609] ACPI: PCI Interrupt Link [LNKC] (IRQs 5 5 10 10 *11 *11))

[    0.744682] ACPI: PCI Interrupt Link [LNKD] (IRQs
[    0.744682] ACPI: PCI Interrupt Link [LNKD] (IRQs 5 5 10 10 *11 *11))

[    0.746290] ACPI: PCI Interrupt Link [LNKS] (IRQs
[    0.746290] ACPI: PCI Interrupt Link [LNKS] (IRQs *9 *9))

[    0.749860] ACPI:=20
[    0.749860] ACPI: Enabled 16 GPEs in block 00 to 0FEnabled 16 GPEs in bl=
ock 00 to 0F

[    0.752728] vgaarb: setting as boot device: PCI:0000:00:02.0
[    0.752728] vgaarb: setting as boot device: PCI:0000:00:02.0
[    0.753767] vgaarb: device added: PCI:0000:00:02.0,decodes=3Dio+mem,owns=
=3Dio+mem,locks=3Dnone
[    0.753767] vgaarb: device added: PCI:0000:00:02.0,decodes=3Dio+mem,owns=
=3Dio+mem,locks=3Dnone
[    0.755241] vgaarb: loaded
[    0.755241] vgaarb: loaded
[    0.755744] vgaarb: bridge control possible 0000:00:02.0
[    0.755744] vgaarb: bridge control possible 0000:00:02.0
[    0.758668] SCSI subsystem initialized
[    0.758668] SCSI subsystem initialized
[    0.761155] Advanced Linux Sound Architecture Driver Initialized.
[    0.761155] Advanced Linux Sound Architecture Driver Initialized.
[    0.762291] PCI: Using ACPI for IRQ routing
[    0.762291] PCI: Using ACPI for IRQ routing
[    0.763063] PCI: pci_cache_line_size set to 64 bytes
[    0.763063] PCI: pci_cache_line_size set to 64 bytes
[    0.764195] e820: reserve RAM buffer [mem 0x0009fc00-0x0009ffff]
[    0.764195] e820: reserve RAM buffer [mem 0x0009fc00-0x0009ffff]
[    0.765312] e820: reserve RAM buffer [mem 0x13ffe000-0x13ffffff]
[    0.765312] e820: reserve RAM buffer [mem 0x13ffe000-0x13ffffff]
[    0.768567] hpet0: at MMIO 0xfed00000, IRQs
[    0.768567] hpet0: at MMIO 0xfed00000, IRQs 2 2, 8, 8, 0, 0

[    0.769529] hpet0: 3 comparators, 64-bit 100.000000 MHz counter
[    0.769529] hpet0: 3 comparators, 64-bit 100.000000 MHz counter
[    0.773121] Switched to clocksource kvm-clock
[    0.773121] Switched to clocksource kvm-clock
[    0.774651] FS-Cache: Loaded
[    0.774651] FS-Cache: Loaded
[    0.774651] pnp: PnP ACPI init
[    0.774651] pnp: PnP ACPI init
[    0.775567] pnp 00:00: Plug and Play ACPI device, IDs PNP0b00 (active)
[    0.775567] pnp 00:00: Plug and Play ACPI device, IDs PNP0b00 (active)
[    0.777322] pnp 00:01: Plug and Play ACPI device, IDs PNP0303 (active)
[    0.777322] pnp 00:01: Plug and Play ACPI device, IDs PNP0303 (active)
[    0.779040] pnp 00:02: Plug and Play ACPI device, IDs PNP0f13 (active)
[    0.779040] pnp 00:02: Plug and Play ACPI device, IDs PNP0f13 (active)
[    0.780715] pnp 00:03: [dma 2]
[    0.780715] pnp 00:03: [dma 2]
[    0.781577] pnp 00:03: Plug and Play ACPI device, IDs PNP0700 (active)
[    0.781577] pnp 00:03: Plug and Play ACPI device, IDs PNP0700 (active)
[    0.783529] pnp 00:04: Plug and Play ACPI device, IDs PNP0400 (active)
[    0.783529] pnp 00:04: Plug and Play ACPI device, IDs PNP0400 (active)
[    0.785495] pnp 00:05: Plug and Play ACPI device, IDs PNP0501 (active)
[    0.785495] pnp 00:05: Plug and Play ACPI device, IDs PNP0501 (active)
[    0.787446] pnp 00:06: Plug and Play ACPI device, IDs PNP0501 (active)
[    0.787446] pnp 00:06: Plug and Play ACPI device, IDs PNP0501 (active)
[    0.791647] pnp: PnP ACPI: found 7 devices
[    0.791647] pnp: PnP ACPI: found 7 devices
[    0.800281] pci_bus 0000:00: resource 4 [io  0x0000-0x0cf7]
[    0.800281] pci_bus 0000:00: resource 4 [io  0x0000-0x0cf7]
[    0.801307] pci_bus 0000:00: resource 5 [io  0x0d00-0xffff]
[    0.801307] pci_bus 0000:00: resource 5 [io  0x0d00-0xffff]
[    0.802325] pci_bus 0000:00: resource 6 [mem 0x000a0000-0x000bffff]
[    0.802325] pci_bus 0000:00: resource 6 [mem 0x000a0000-0x000bffff]
[    0.803472] pci_bus 0000:00: resource 7 [mem 0x80000000-0xfebfffff]
[    0.803472] pci_bus 0000:00: resource 7 [mem 0x80000000-0xfebfffff]
[    0.804703] NET: Registered protocol family 1
[    0.804703] NET: Registered protocol family 1
[    0.805560] pci 0000:00:00.0: Limiting direct PCI/PCI transfers
[    0.805560] pci 0000:00:00.0: Limiting direct PCI/PCI transfers
[    0.806663] pci 0000:00:01.0: PIIX3: Enabling Passive Release
[    0.806663] pci 0000:00:01.0: PIIX3: Enabling Passive Release
[    0.807736] pci 0000:00:01.0: Activating ISA DMA hang workarounds
[    0.807736] pci 0000:00:01.0: Activating ISA DMA hang workarounds
[    0.808893] pci 0000:00:02.0: Video device with shadowed ROM
[    0.808893] pci 0000:00:02.0: Video device with shadowed ROM
[    0.809989] PCI: CLS 0 bytes, default 64
[    0.809989] PCI: CLS 0 bytes, default 64
[    0.811128] Unpacking initramfs...
[    0.811128] Unpacking initramfs...
[    0.919054] debug: unmapping init [mem 0xffff880013ce6000-0xffff880013fe=
ffff]
[    0.919054] debug: unmapping init [mem 0xffff880013ce6000-0xffff880013fe=
ffff]
[    0.921653] microcode: CPU0 sig=3D0xf61, pf=3D0x1, revision=3D0x1
[    0.921653] microcode: CPU0 sig=3D0xf61, pf=3D0x1, revision=3D0x1
[    0.922977] microcode: Microcode Update Driver: v2.00 <tigran@aivazian.f=
snet.co.uk>, Peter Oruba
[    0.922977] microcode: Microcode Update Driver: v2.00 <tigran@aivazian.f=
snet.co.uk>, Peter Oruba
[    0.925187] cryptomgr_test (20) used greatest stack depth: 14768 bytes l=
eft
[    0.925187] cryptomgr_test (20) used greatest stack depth: 14768 bytes l=
eft
[    0.927312] sha256_ssse3: Neither AVX nor SSSE3 is available/usable.
[    0.927312] sha256_ssse3: Neither AVX nor SSSE3 is available/usable.
[    0.928628] spin_lock-torture:--- Start of test [debug]: nwriters_stress=
=3D2 nreaders_stress=3D0 stat_interval=3D60 verbose=3D1 shuffle_interval=3D=
3 stutter=3D5 shutdown_secs=3D0 onoff_interval=3D0 onoff_holdoff=3D0
[    0.928628] spin_lock-torture:--- Start of test [debug]: nwriters_stress=
=3D2 nreaders_stress=3D0 stat_interval=3D60 verbose=3D1 shuffle_interval=3D=
3 stutter=3D5 shutdown_secs=3D0 onoff_interval=3D0 onoff_holdoff=3D0
[    0.931795] spin_lock-torture: Creating torture_shuffle task
[    0.931795] spin_lock-torture: Creating torture_shuffle task
[    0.932949] spin_lock-torture: Creating torture_stutter task
[    0.932949] spin_lock-torture: Creating torture_stutter task
[    0.934045] spin_lock-torture: torture_shuffle task started
[    0.934045] spin_lock-torture: torture_shuffle task started
[    0.935086] spin_lock-torture: Creating lock_torture_writer task
[    0.935086] spin_lock-torture: Creating lock_torture_writer task
[    0.936396] spin_lock-torture: torture_stutter task started
[    0.936396] spin_lock-torture: torture_stutter task started
[    0.937435] spin_lock-torture: Creating lock_torture_writer task
[    0.937435] spin_lock-torture: Creating lock_torture_writer task
[    0.938573] spin_lock-torture: lock_torture_writer task started
[    0.938573] spin_lock-torture: lock_torture_writer task started
[    0.939673] spin_lock-torture: Creating lock_torture_stats task
[    0.939673] spin_lock-torture: Creating lock_torture_stats task
[    0.940816] spin_lock-torture: lock_torture_writer task started
[    0.940816] spin_lock-torture: lock_torture_writer task started
[    0.942209] torture_init_begin: refusing rcu init: spin_lock running
[    0.942209] torture_init_begin: refusing rcu init: spin_lock running

[    0.945297] futex hash table entries: 16 (order: -1, 2048 bytes)
[    0.945297] futex hash table entries: 16 (order: -1, 2048 bytes)
[    0.946472] Initialise system trusted keyring
[    0.946472] Initialise system trusted keyring
[    0.947619] Kprobe smoke test: started
[    0.947619] Kprobe smoke test: started
[    0.948955] spin_lock-torture: lock_torture_stats task started
[    0.948955] spin_lock-torture: lock_torture_stats task started
[    0.956559] Kprobe smoke test: passed successfully
[    0.956559] Kprobe smoke test: passed successfully
[    0.991780] zpool: loaded
[    0.991780] zpool: loaded
[    1.004182] efs: 1.0a - http://aeschi.ch.eu.org/efs/
[    1.004182] efs: 1.0a - http://aeschi.ch.eu.org/efs/
[    1.005631] befs: version: 0.9.3
[    1.005631] befs: version: 0.9.3
[    1.006819] msgmni has been set to 576
[    1.006819] msgmni has been set to 576
[    1.011118] Key type asymmetric registered
[    1.011118] Key type asymmetric registered
[    1.011902] Asymmetric key parser 'x509' registered
[    1.011902] Asymmetric key parser 'x509' registered
[    1.013432] Block layer SCSI generic (bsg) driver version 0.4 loaded (ma=
jor 252)
[    1.013432] Block layer SCSI generic (bsg) driver version 0.4 loaded (ma=
jor 252)
[    1.014797] io scheduler noop registered (default)
[    1.014797] io scheduler noop registered (default)
[    1.019794] test_firmware: interface ready
[    1.019794] test_firmware: interface ready
[    1.021317] crc32: CRC_LE_BITS =3D 64, CRC_BE BITS =3D 64
[    1.021317] crc32: CRC_LE_BITS =3D 64, CRC_BE BITS =3D 64
[    1.022254] crc32: self tests passed, processed 225944 bytes in 144523 n=
sec
[    1.022254] crc32: self tests passed, processed 225944 bytes in 144523 n=
sec
[    1.023672] crc32c: CRC_LE_BITS =3D 64
[    1.023672] crc32c: CRC_LE_BITS =3D 64
[    1.024348] crc32c: self tests passed, processed 225944 bytes in 72175 n=
sec
[    1.024348] crc32c: self tests passed, processed 225944 bytes in 72175 n=
sec
[    1.037070] crc32_combine: 8373 self tests passed
[    1.037070] crc32_combine: 8373 self tests passed
[    1.049217] crc32c_combine: 8373 self tests passed
[    1.049217] crc32c_combine: 8373 self tests passed
[    1.050216] rbtree testing
[    1.050216] rbtree testing -> 9037 cycles
 -> 9037 cycles
[    1.417046] augmented rbtree testing
[    1.417046] augmented rbtree testing -> 12816 cycles
 -> 12816 cycles
[    1.934826] tsc: Refined TSC clocksource calibration: 2693.410 MHz
[    1.934826] tsc: Refined TSC clocksource calibration: 2693.410 MHz
[    1.938229] VIA Graphics Integration Chipset framebuffer 2.4 initializing
[    1.938229] VIA Graphics Integration Chipset framebuffer 2.4 initializing
[    1.940871] cirrusfb 0000:00:02.0: Cirrus Logic chipset on PCI bus, RAM =
(4096 kB) at 0xfc000000
[    1.940871] cirrusfb 0000:00:02.0: Cirrus Logic chipset on PCI bus, RAM =
(4096 kB) at 0xfc000000
[    1.942440] CL Picasso4: enable CONFIG_FB_LITTLE_ENDIAN to support this =
framebuffer
[    1.942440] CL Picasso4: enable CONFIG_FB_LITTLE_ENDIAN to support this =
framebuffer
[    1.943838] cirrusfb 0000:00:02.0: could not register fb device; err =3D=
 -38!
[    1.943838] cirrusfb 0000:00:02.0: could not register fb device; err =3D=
 -38!
[    1.945198] cirrusfb: probe of 0000:00:02.0 failed with error -38
[    1.945198] cirrusfb: probe of 0000:00:02.0 failed with error -38
[    1.947052] ipmi message handler version 39.2
[    1.947052] ipmi message handler version 39.2
[    1.956438] ACPI: PCI Interrupt Link [LNKD] enabled at IRQ 11
[    1.956438] ACPI: PCI Interrupt Link [LNKD] enabled at IRQ 11
[    1.965820] ACPI: PCI Interrupt Link [LNKA] enabled at IRQ 10
[    1.965820] ACPI: PCI Interrupt Link [LNKA] enabled at IRQ 10
[    1.975405] ACPI: PCI Interrupt Link [LNKB] enabled at IRQ 10
[    1.975405] ACPI: PCI Interrupt Link [LNKB] enabled at IRQ 10
[    1.985410] ACPI: PCI Interrupt Link [LNKC] enabled at IRQ 11
[    1.985410] ACPI: PCI Interrupt Link [LNKC] enabled at IRQ 11
[    2.129095] Serial: 8250/16550 driver, 4 ports, IRQ sharing disabled
[    2.129095] Serial: 8250/16550 driver, 4 ports, IRQ sharing disabled
[    2.155666] serial 00:05: ttyS0 at I/O 0x3f8 (irq =3D 4, base_baud =3D 1=
15200) is a 16550A
[    2.155666] serial 00:05: ttyS0 at I/O 0x3f8 (irq =3D 4, base_baud =3D 1=
15200) is a 16550A
[    2.161536] Applicom driver: $Id: ac.c,v 1.30 2000/03/22 16:03:57 dwmw2 =
Exp $
[    2.161536] Applicom driver: $Id: ac.c,v 1.30 2000/03/22 16:03:57 dwmw2 =
Exp $
[    2.162843] ac.o: No PCI boards found.
[    2.162843] ac.o: No PCI boards found.
[    2.163525] ac.o: For an ISA board you must supply memory and irq parame=
ters.
[    2.163525] ac.o: For an ISA board you must supply memory and irq parame=
ters.
[    2.165377] Linux agpgart interface v0.103
[    2.165377] Linux agpgart interface v0.103
[    2.167520] parport_pc 00:04: reported by Plug and Play ACPI
[    2.167520] parport_pc 00:04: reported by Plug and Play ACPI
[    2.168716] parport0: PC-style at 0x378
[    2.168716] parport0: PC-style at 0x378, irq 7, irq 7 [ [PCSPPPCSPP,TRIS=
TATE,TRISTATE]
]
[    2.266153] HP CISS Driver (v 3.6.26)
[    2.266153] HP CISS Driver (v 3.6.26)
[   60.948050] Writes:  Total: 2  Max/Min: 0/0   Fail: 0=20
[   60.948050] Writes:  Total: 2  Max/Min: 0/0   Fail: 0=20
[  120.948052] Writes:  Total: 2  Max/Min: 0/0   Fail: 0=20
[  120.948052] Writes:  Total: 2  Max/Min: 0/0   Fail: 0=20
[  180.948037] Writes:  Total: 2  Max/Min: 0/0   Fail: 0=20
[  180.948037] Writes:  Total: 2  Max/Min: 0/0   Fail: 0=20
[  240.224080] INFO: task swapper/0:1 blocked for more than 120 seconds
--UlVJffcvxoiEqYs2
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

_______________________________________________
LKP mailing list
LKP@linux.intel.com

--UlVJffcvxoiEqYs2--
