Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752078AbaG3EMv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jul 2014 00:12:51 -0400
Received: from mga14.intel.com ([192.55.52.115]:65278 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751169AbaG3EMr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jul 2014 00:12:47 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.01,762,1400050800"; 
   d="log'?scan'208";a="569240352"
Date: Wed, 30 Jul 2014 12:12:35 +0800
From: Fengguang Wu <fengguang.wu@intel.com>
To: David Herrmann <dh.herrmann@gmail.com>
Cc: Jet Chen <jet.chen@intel.com>, Su Tao <tao.su@intel.com>,
        Yuanhan Liu <yuanhan.liu@intel.com>, LKP <lkp@01.org>,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [fs] BUG: unable to handle kernel NULL pointer dereference at
 00000104
Message-ID: <20140730041235.GJ16537@localhost>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="Ah40dssYA/cDqAW1"
Content-Disposition: inline
User-Agent: Heirloom mailx 12.5 6/20/10
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--Ah40dssYA/cDqAW1
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Greetings,

0day kernel testing robot got the below dmesg and the first bad commit is

git://people.freedesktop.org/~dvdhrm/linux fops
commit bc2d5105254034778034487d8f3aec42db2a5285
Author:     David Herrmann <dh.herrmann@gmail.com>
AuthorDate: Tue Jun 17 22:10:12 2014 +0200
Commit:     David Herrmann <dh.herrmann@gmail.com>
CommitDate: Tue Jul 22 14:54:07 2014 +0200

    fs: add active reference counter to "struct file"
    
    This adds an kactive reference counter to "struct file". This allows to
    acquire active references on any file that enabled it. Furthermore, all
    file->f_op->xy() callbacks are modified to acquire an active reference
    before entering and dropping it afterwards.
    
    Drivers have to opt-in to enable this feature. By using fops_file_attach()
    in the ->open() callback, they can enable the active-counter on the file.
    From now on they can use fops_file_disable() and fops_file_drain() to
    prevent any new active-references from being acquired and waiting for all
    those to be released.
    
    All those protected files have to be linked to a parent device (called
    "struct fops_device"). A driver has to allocate and manage those. The
    parent device can be used to atomically disable and drain all linked
    files.
    
    Signed-off-by: David Herrmann <dh.herrmann@gmail.com>

===================================================
PARENT COMMIT NOT CLEAN. LOOK OUT FOR WRONG BISECT!
===================================================
Attached dmesg for the parent commit, too, to help confirm whether it is a noise error.

+------------------------------------------------------+------------+------------+
|                                                      | 47702c7c4c | bc2d510525 |
+------------------------------------------------------+------------+------------+
| boot_successes                                       | 61         | 0          |
| boot_failures                                        | 2          | 21         |
| BUG:kernel_boot_crashed                              | 2          |            |
| BUG:unable_to_handle_kernel_NULL_pointer_dereference | 0          | 21         |
| Oops                                                 | 0          | 21         |
| EIP_is_at_get_unmapped_area                          | 0          | 21         |
| Kernel_panic-not_syncing:Fatal_exception             | 0          | 21         |
| backtrace:do_execve                                  | 0          | 21         |
| backtrace:run_init_process                           | 0          | 21         |
+------------------------------------------------------+------------+------------+

[    2.054083] debug: unmapping init [mem 0xb48be000-0xb490ffff]
[    2.054646] Write protecting the kernel text: 6640k
[    2.055106] Write protecting the kernel read-only data: 4012k
[    2.056047] BUG: unable to handle kernel NULL pointer dereference at 00000104
[    2.056648] IP: [<b3c81d3e>] get_unmapped_area+0x40/0xef
[    2.056905] *pde = 00000000 
[    2.056905] Oops: 0000 [#1] DEBUG_PAGEALLOC
[    2.056905] CPU: 0 PID: 1 Comm: init Not tainted 3.16.0-rc5-00231-gbc2d510 #2
[    2.056905] task: b0030010 ti: b0032000 task.ti: b0032000
[    2.056905] EIP: 0060:[<b3c81d3e>] EFLAGS: 00010246 CPU: 0
[    2.056905] EIP is at get_unmapped_area+0x40/0xef
[    2.056905] EAX: c290ddc0 EBX: 00000000 ECX: 00003000 EDX: 00000000
[    2.056905] ESI: b427f198 EDI: b3c81ed4 EBP: b0033eac ESP: b0033e98
[    2.056905]  DS: 007b ES: 007b FS: 0000 GS: 0000 SS: 0068
[    2.056905] CR0: 8005003b CR2: 00000104 CR3: 12916000 CR4: 00000690
[    2.056905] Stack:
[    2.056905]  00000000 00003000 47e77cc0 b427f198 b0030010 b0033ed0 b3c1bff5 00000000
[    2.056905]  00000000 c290de1c c290ddc0 47e77cc0 47e767c8 c2901800 b0033f50 b3cb5d6c
[    2.056905]  b0032000 00002000 00000006 0001d000 00000000 00000001 47e77cc0 0804fad4
[    2.056905] Call Trace:
[    2.056905]  [<b3c1bff5>] arch_setup_additional_pages+0x4e/0x188
[    2.056905]  [<b3cb5d6c>] load_elf_binary+0x9c5/0xff7
[    2.056905]  [<b3c95585>] search_binary_handler+0x41/0x95
[    2.056905]  [<b3c95955>] do_execve+0x37c/0x48a
[    2.056905]  [<b3c0035c>] run_init_process+0x1c/0x1e
[    2.056905]  [<b426a586>] kernel_init+0x34/0xb8
[    2.056905]  [<b427a7c0>] ret_from_kernel_thread+0x20/0x30
[    2.056905]  [<b426a552>] ? rest_init+0x10e/0x10e
[    2.056905] Code: 76 0a be f4 ff ff ff e9 c4 00 00 00 89 c3 a1 20 a9 67 b4 8b 80 10 02 00 00 85 db 8b 78 0c 74 0b 8b 43 14 8b 40 58 85 c0 0f 45 f8 <8b> b3 04 01 00 00 85 f6 74 54 83 c6 14 31 c9 8d 41 01 89 c2 89
[    2.056905] EIP: [<b3c81d3e>] get_unmapped_area+0x40/0xef SS:ESP 0068:b0033e98
[    2.056905] CR2: 0000000000000104
[    2.070596] ---[ end trace 10ed763858844c61 ]---
[    2.070973] Kernel panic - not syncing: Fatal exception

git bisect start 988a7cce9cf281d8954af4f421419713e2d6499a 9a3c4145af32125c5ee39c0272662b47307a8323 --
git bisect good 0b6fe2b988caee808f3ccb616fa22f2a56a042e8  # 21:58     20+      1  Merge 'wsa/i2c/for-next' into devel-roam-i386-201407222107
git bisect good d127240d43380e9e1463fd8cde0134f85b66c261  # 22:00     20+      0  Merge 'linux-sti/sti-dt-for-v3.17-1' into devel-roam-i386-201407222107
git bisect  bad 1713b12636b3daab7ea2625efa376119c7b490de  # 22:04      1-     10  Merge 'dvdhrm/fops' into devel-roam-i386-201407222107
git bisect good 47702c7c4c9c1e8514ca52e367cf0b71e50177f8  # 22:10     21+      0  kactive: make kernfs "active-ref" generic
git bisect  bad 34e6b7dea8bb2c359c29d4b0021967c6de0f1b7a  # 22:17      0-     21  fs: track fops-depth in task_struct
git bisect  bad bc2d5105254034778034487d8f3aec42db2a5285  # 22:23      0-     21  fs: add active reference counter to "struct file"
# first bad commit: [bc2d5105254034778034487d8f3aec42db2a5285] fs: add active reference counter to "struct file"
git bisect good 47702c7c4c9c1e8514ca52e367cf0b71e50177f8  # 22:26     63+      2  kactive: make kernfs "active-ref" generic
git bisect  bad 988a7cce9cf281d8954af4f421419713e2d6499a  # 22:26      0-     11  0day head guard for 'devel-roam-i386-201407222107'
git bisect good 15ba2236f3556fc01b9ca91394465152b5ea74b6  # 22:36     63+      1  Merge git://git.kernel.org/pub/scm/linux/kernel/git/davem/net


This script may reproduce the error.

----------------------------------------------------------------------------
#!/bin/bash

kernel=$1
initrd=yocto-minimal-i386.cgz

wget --no-clobber https://github.com/fengguang/reproduce-kernel-bug/blob/master/initrd/$initrd

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
	panic=10
	softlockup_panic=1
	nmi_watchdog=panic
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

--Ah40dssYA/cDqAW1
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="dmesg-yocto-vp-8:20140722222318:i386-randconfig-r2-0722:3.16.0-rc5-00231-gbc2d510:2"
Content-Transfer-Encoding: quoted-printable

early console in setup code
early console in decompress_kernel
KASLR using RDTSC...

Decompressing Linux... Parsing ELF... Performing relocations... done.
Booting the kernel.
[    0.000000] Initializing cgroup subsys cpu
[    0.000000] Linux version 3.16.0-rc5-00231-gbc2d510 (kbuild@jaketown) (g=
cc version 4.8.2 (Debian 4.8.2-18) ) #2 Tue Jul 22 22:22:25 CST 2014
[    0.000000] KERNEL supported cpus:
[    0.000000]   NSC Geode by NSC
[    0.000000]   Cyrix CyrixInstead
[    0.000000]   Centaur CentaurHauls
[    0.000000] CPU: vendor_id 'GenuineIntel' unknown, using generic init.
[    0.000000] CPU: Your system may be unstable.
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
[    0.000000] Scan for SMP in [mem 0x00000000-0x000003ff]
[    0.000000] Scan for SMP in [mem 0x0009fc00-0x0009ffff]
[    0.000000] Scan for SMP in [mem 0x000f0000-0x000fffff]
[    0.000000] found SMP MP-table at [mem 0x000fdad0-0x000fdadf] mapped at =
[b00fdad0]
[    0.000000]   mpc: fdae0-fdbe8
[    0.000000] Scanning 1 areas for low memory corruption
[    0.000000] initial memory mapped: [mem 0x00000000-0x053fffff]
[    0.000000] Base memory trampoline at [b009b000] 9b000 size 16384
[    0.000000] init_memory_mapping: [mem 0x00000000-0x000fffff]
[    0.000000]  [mem 0x00000000-0x000fffff] page 4k
[    0.000000] init_memory_mapping: [mem 0x13800000-0x13bfffff]
[    0.000000]  [mem 0x13800000-0x13bfffff] page 4k
[    0.000000] BRK [0x05124000, 0x05124fff] PGTABLE
[    0.000000] init_memory_mapping: [mem 0x10000000-0x137fffff]
[    0.000000]  [mem 0x10000000-0x137fffff] page 4k
[    0.000000] BRK [0x05125000, 0x05125fff] PGTABLE
[    0.000000] BRK [0x05126000, 0x05126fff] PGTABLE
[    0.000000] BRK [0x05127000, 0x05127fff] PGTABLE
[    0.000000] BRK [0x05128000, 0x05128fff] PGTABLE
[    0.000000] BRK [0x05129000, 0x05129fff] PGTABLE
[    0.000000] init_memory_mapping: [mem 0x00100000-0x0fffffff]
[    0.000000]  [mem 0x00100000-0x0fffffff] page 4k
[    0.000000] init_memory_mapping: [mem 0x13c00000-0x13ffdfff]
[    0.000000]  [mem 0x13c00000-0x13ffdfff] page 4k
[    0.000000] RAMDISK: [mem 0x13cbd000-0x13feffff]
[    0.000000] ACPI: Early table checksum verification disabled
[    0.000000] ACPI: RSDP 0x000FD970 000014 (v00 BOCHS )
[    0.000000] ACPI: RSDT 0x13FFE4B0 000034 (v01 BOCHS  BXPCRSDT 00000001 B=
XPC 00000001)
[    0.000000] ACPI: FACP 0x13FFFF80 000074 (v01 BOCHS  BXPCFACP 00000001 B=
XPC 00000001)
[    0.000000] ACPI: DSDT 0x13FFE4F0 0011A9 (v01 BXPC   BXDSDT   00000001 I=
NTL 20100528)
[    0.000000] ACPI: FACS 0x13FFFF40 000040
[    0.000000] ACPI: SSDT 0x13FFF800 000735 (v01 BOCHS  BXPCSSDT 00000001 B=
XPC 00000001)
[    0.000000] ACPI: APIC 0x13FFF6E0 000078 (v01 BOCHS  BXPCAPIC 00000001 B=
XPC 00000001)
[    0.000000] ACPI: HPET 0x13FFF6A0 000038 (v01 BOCHS  BXPCHPET 00000001 B=
XPC 00000001)
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] mapped APIC to         ffffc000 (        fee00000)
[    0.000000] 319MB LOWMEM available.
[    0.000000]   mapped low ram: 0 - 13ffe000
[    0.000000]   low ram: 0 - 13ffe000
[    0.000000] kvm-clock: Using msrs 4b564d01 and 4b564d00
[    0.000000] kvm-clock: cpu 0, msr 0:13ffd001, primary cpu clock
[    0.000000] Zone ranges:
[    0.000000]   Normal   [mem 0x00001000-0x13ffdfff]
[    0.000000] Movable zone start for each node
[    0.000000] Early memory node ranges
[    0.000000]   node   0: [mem 0x00001000-0x0009efff]
[    0.000000]   node   0: [mem 0x00100000-0x13ffdfff]
[    0.000000] On node 0 totalpages: 81820
[    0.000000] free_area_init_node: node 0, pgdat b48a2884, node_mem_map c3=
8fb024
[    0.000000]   Normal zone: 720 pages used for memmap
[    0.000000]   Normal zone: 0 pages reserved
[    0.000000]   Normal zone: 81820 pages, LIFO batch:15
[    0.000000] Using APIC driver default
[    0.000000] ACPI: PM-Timer IO Port: 0xb008
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] mapped APIC to         ffffc000 (        fee00000)
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
[    0.000000] mapped IOAPIC to ffffb000 (fec00000)
[    0.000000] nr_irqs_gsi: 40
[    0.000000] KVM setup async PF for cpu 0
[    0.000000] kvm-stealtime: cpu 0, msr 467c280
[    0.000000] e820: [mem 0x14000000-0xfeffbfff] available for PCI devices
[    0.000000] Booting paravirtualized kernel on KVM
[    0.000000] pcpu-alloc: s0 r0 d32768 u32768 alloc=3D1*32768
[    0.000000] pcpu-alloc: [0] 0=20
[    0.000000] Built 1 zonelists in Zone order, mobility grouping on.  Tota=
l pages: 81100
[    0.000000] Kernel command line: hung_task_panic=3D1 earlyprintk=3DttyS0=
,115200 debug apic=3Ddebug sysrq_always_enabled rcupdate.rcu_cpu_stall_time=
out=3D100 panic=3D10 softlockup_panic=3D1 nmi_watchdog=3Dpanic  prompt_ramd=
isk=3D0 console=3DttyS0,115200 console=3Dtty0 vga=3Dnormal  root=3D/dev/ram=
0 rw link=3D/kbuild-tests/run-queue/kvm/i386-randconfig-r2-0722/linux-devel=
:devel-roam-i386-201407222107:bc2d5105254034778034487d8f3aec42db2a5285:bise=
ct-linux-8/.vmlinuz-bc2d5105254034778034487d8f3aec42db2a5285-20140722222240=
-21-vp branch=3Dlinux-devel/devel-roam-i386-201407222107 BOOT_IMAGE=3D/kern=
el/i386-randconfig-r2-0722/bc2d5105254034778034487d8f3aec42db2a5285/vmlinuz=
-3.16.0-rc5-00231-gbc2d510 drbd.minor_count=3D8
[    0.000000] sysrq: sysrq always enabled.
[    0.000000] PID hash table entries: 2048 (order: 1, 8192 bytes)
[    0.000000] Dentry cache hash table entries: 65536 (order: 6, 262144 byt=
es)
[    0.000000] Inode-cache hash table entries: 32768 (order: 5, 131072 byte=
s)
[    0.000000] Initializing CPU#0
[    0.000000] Memory: 298704K/327280K available (6637K kernel code, 2388K =
rwdata, 4008K rodata, 328K init, 8188K bss, 28576K reserved)
[    0.000000] virtual kernel memory layout:
[    0.000000]     fixmap  : 0xfffa3000 - 0xfffff000   ( 368 kB)
[    0.000000]     vmalloc : 0xc47fe000 - 0xfffa1000   ( 951 MB)
[    0.000000]     lowmem  : 0xb0000000 - 0xc3ffe000   ( 319 MB)
[    0.000000]       .init : 0xb48be000 - 0xb4910000   ( 328 kB)
[    0.000000]       .data : 0xb427ba4c - 0xb48bc000   (6401 kB)
[    0.000000]       .text : 0xb3c00000 - 0xb427ba4c   (6638 kB)
[    0.000000] Checking if this processor honours the WP bit even in superv=
isor mode...Ok.
[    0.000000] NR_IRQS:2304 nr_irqs:256 16
[    0.000000] CPU 0 irqstacks, hard=3Db0094000 soft=3Db0096000
[    0.000000] Initializing cgroup subsys cpu
[    0.000000] Linux version 3.16.0-rc5-00231-gbc2d510 (kbuild@jaketown) (g=
cc version 4.8.2 (Debian 4.8.2-18) ) #2 Tue Jul 22 22:22:25 CST 2014
[    0.000000] KERNEL supported cpus:
[    0.000000]   NSC Geode by NSC
[    0.000000]   Cyrix CyrixInstead
[    0.000000]   Centaur CentaurHauls
[    0.000000] CPU: vendor_id 'GenuineIntel' unknown, using generic init.
[    0.000000] CPU: Your system may be unstable.
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
[    0.000000] Scan for SMP in [mem 0x00000000-0x000003ff]
[    0.000000] Scan for SMP in [mem 0x0009fc00-0x0009ffff]
[    0.000000] Scan for SMP in [mem 0x000f0000-0x000fffff]
[    0.000000] found SMP MP-table at [mem 0x000fdad0-0x000fdadf] mapped at =
[b00fdad0]
[    0.000000]   mpc: fdae0-fdbe8
[    0.000000] Scanning 1 areas for low memory corruption
[    0.000000] initial memory mapped: [mem 0x00000000-0x053fffff]
[    0.000000] Base memory trampoline at [b009b000] 9b000 size 16384
[    0.000000] init_memory_mapping: [mem 0x00000000-0x000fffff]
[    0.000000]  [mem 0x00000000-0x000fffff] page 4k
[    0.000000] init_memory_mapping: [mem 0x13800000-0x13bfffff]
[    0.000000]  [mem 0x13800000-0x13bfffff] page 4k
[    0.000000] BRK [0x05124000, 0x05124fff] PGTABLE
[    0.000000] init_memory_mapping: [mem 0x10000000-0x137fffff]
[    0.000000]  [mem 0x10000000-0x137fffff] page 4k
[    0.000000] BRK [0x05125000, 0x05125fff] PGTABLE
[    0.000000] BRK [0x05126000, 0x05126fff] PGTABLE
[    0.000000] BRK [0x05127000, 0x05127fff] PGTABLE
[    0.000000] BRK [0x05128000, 0x05128fff] PGTABLE
[    0.000000] BRK [0x05129000, 0x05129fff] PGTABLE
[    0.000000] init_memory_mapping: [mem 0x00100000-0x0fffffff]
[    0.000000]  [mem 0x00100000-0x0fffffff] page 4k
[    0.000000] init_memory_mapping: [mem 0x13c00000-0x13ffdfff]
[    0.000000]  [mem 0x13c00000-0x13ffdfff] page 4k
[    0.000000] RAMDISK: [mem 0x13cbd000-0x13feffff]
[    0.000000] ACPI: Early table checksum verification disabled
[    0.000000] ACPI: RSDP 0x000FD970 000014 (v00 BOCHS )
[    0.000000] ACPI: RSDT 0x13FFE4B0 000034 (v01 BOCHS  BXPCRSDT 00000001 B=
XPC 00000001)
[    0.000000] ACPI: FACP 0x13FFFF80 000074 (v01 BOCHS  BXPCFACP 00000001 B=
XPC 00000001)
[    0.000000] ACPI: DSDT 0x13FFE4F0 0011A9 (v01 BXPC   BXDSDT   00000001 I=
NTL 20100528)
[    0.000000] ACPI: FACS 0x13FFFF40 000040
[    0.000000] ACPI: SSDT 0x13FFF800 000735 (v01 BOCHS  BXPCSSDT 00000001 B=
XPC 00000001)
[    0.000000] ACPI: APIC 0x13FFF6E0 000078 (v01 BOCHS  BXPCAPIC 00000001 B=
XPC 00000001)
[    0.000000] ACPI: HPET 0x13FFF6A0 000038 (v01 BOCHS  BXPCHPET 00000001 B=
XPC 00000001)
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] mapped APIC to         ffffc000 (        fee00000)
[    0.000000] 319MB LOWMEM available.
[    0.000000]   mapped low ram: 0 - 13ffe000
[    0.000000]   low ram: 0 - 13ffe000
[    0.000000] kvm-clock: Using msrs 4b564d01 and 4b564d00
[    0.000000] kvm-clock: cpu 0, msr 0:13ffd001, primary cpu clock
[    0.000000] Zone ranges:
[    0.000000]   Normal   [mem 0x00001000-0x13ffdfff]
[    0.000000] Movable zone start for each node
[    0.000000] Early memory node ranges
[    0.000000]   node   0: [mem 0x00001000-0x0009efff]
[    0.000000]   node   0: [mem 0x00100000-0x13ffdfff]
[    0.000000] On node 0 totalpages: 81820
[    0.000000] free_area_init_node: node 0, pgdat b48a2884, node_mem_map c3=
8fb024
[    0.000000]   Normal zone: 720 pages used for memmap
[    0.000000]   Normal zone: 0 pages reserved
[    0.000000]   Normal zone: 81820 pages, LIFO batch:15
[    0.000000] Using APIC driver default
[    0.000000] ACPI: PM-Timer IO Port: 0xb008
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] mapped APIC to         ffffc000 (        fee00000)
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
[    0.000000] mapped IOAPIC to ffffb000 (fec00000)
[    0.000000] nr_irqs_gsi: 40
[    0.000000] KVM setup async PF for cpu 0
[    0.000000] kvm-stealtime: cpu 0, msr 467c280
[    0.000000] e820: [mem 0x14000000-0xfeffbfff] available for PCI devices
[    0.000000] Booting paravirtualized kernel on KVM
[    0.000000] pcpu-alloc: s0 r0 d32768 u32768 alloc=3D1*32768
[    0.000000] pcpu-alloc: [0] 0=20
[    0.000000] Built 1 zonelists in Zone order, mobility grouping on.  Tota=
l pages: 81100
[    0.000000] Kernel command line: hung_task_panic=3D1 earlyprintk=3DttyS0=
,115200 debug apic=3Ddebug sysrq_always_enabled rcupdate.rcu_cpu_stall_time=
out=3D100 panic=3D10 softlockup_panic=3D1 nmi_watchdog=3Dpanic  prompt_ramd=
isk=3D0 console=3DttyS0,115200 console=3Dtty0 vga=3Dnormal  root=3D/dev/ram=
0 rw link=3D/kbuild-tests/run-queue/kvm/i386-randconfig-r2-0722/linux-devel=
:devel-roam-i386-201407222107:bc2d5105254034778034487d8f3aec42db2a5285:bise=
ct-linux-8/.vmlinuz-bc2d5105254034778034487d8f3aec42db2a5285-20140722222240=
-21-vp branch=3Dlinux-devel/devel-roam-i386-201407222107 BOOT_IMAGE=3D/kern=
el/i386-randconfig-r2-0722/bc2d5105254034778034487d8f3aec42db2a5285/vmlinuz=
-3.16.0-rc5-00231-gbc2d510 drbd.minor_count=3D8
[    0.000000] sysrq: sysrq always enabled.
[    0.000000] PID hash table entries: 2048 (order: 1, 8192 bytes)
[    0.000000] Dentry cache hash table entries: 65536 (order: 6, 262144 byt=
es)
[    0.000000] Inode-cache hash table entries: 32768 (order: 5, 131072 byte=
s)
[    0.000000] Initializing CPU#0
[    0.000000] Memory: 298704K/327280K available (6637K kernel code, 2388K =
rwdata, 4008K rodata, 328K init, 8188K bss, 28576K reserved)
[    0.000000] virtual kernel memory layout:
[    0.000000]     fixmap  : 0xfffa3000 - 0xfffff000   ( 368 kB)
[    0.000000]     vmalloc : 0xc47fe000 - 0xfffa1000   ( 951 MB)
[    0.000000]     lowmem  : 0xb0000000 - 0xc3ffe000   ( 319 MB)
[    0.000000]       .init : 0xb48be000 - 0xb4910000   ( 328 kB)
[    0.000000]       .data : 0xb427ba4c - 0xb48bc000   (6401 kB)
[    0.000000]       .text : 0xb3c00000 - 0xb427ba4c   (6638 kB)
[    0.000000] Checking if this processor honours the WP bit even in superv=
isor mode...Ok.
[    0.000000] NR_IRQS:2304 nr_irqs:256 16
[    0.000000] CPU 0 irqstacks, hard=3Db0094000 soft=3Db0096000
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
[    0.000000]  memory used by lock dependency info: 5167 kB
[    0.000000]  memory used by lock dependency info: 5167 kB
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
[    0.000000] hpet clockevent registered
[    0.000000] hpet clockevent registered
[    0.000000] tsc: Detected 2693.486 MHz processor
[    0.000000] tsc: Detected 2693.486 MHz processor
[    0.003000] Calibrating delay loop (skipped) preset value..=20
[    0.003000] Calibrating delay loop (skipped) preset value.. 5386.97 Bogo=
MIPS (lpj=3D2693486)
5386.97 BogoMIPS (lpj=3D2693486)
[    0.003466] pid_max: default: 32768 minimum: 301
[    0.003466] pid_max: default: 32768 minimum: 301
[    0.004029] ACPI: Core revision 20140424
[    0.004029] ACPI: Core revision 20140424
[    0.007793] ACPI:=20
[    0.007793] ACPI: All ACPI Tables successfully acquiredAll ACPI Tables s=
uccessfully acquired

[    0.008646] Security Framework initialized
[    0.008646] Security Framework initialized
[    0.009010] Yama: becoming mindful.
[    0.009010] Yama: becoming mindful.
[    0.010034] Mount-cache hash table entries: 1024 (order: 0, 4096 bytes)
[    0.010034] Mount-cache hash table entries: 1024 (order: 0, 4096 bytes)
[    0.011008] Mountpoint-cache hash table entries: 1024 (order: 0, 4096 by=
tes)
[    0.011008] Mountpoint-cache hash table entries: 1024 (order: 0, 4096 by=
tes)
[    0.013087] Initializing cgroup subsys devices
[    0.013087] Initializing cgroup subsys devices
[    0.013863] Initializing cgroup subsys freezer
[    0.013863] Initializing cgroup subsys freezer
[    0.014017] Initializing cgroup subsys perf_event
[    0.014017] Initializing cgroup subsys perf_event
[    0.015052] Last level iTLB entries: 4KB 0, 2MB 0, 4MB 0
[    0.015052] Last level dTLB entries: 4KB 0, 2MB 0, 4MB 0, 1GB 0
[    0.015052] tlb_flushall_shift: -1
[    0.015052] Last level iTLB entries: 4KB 0, 2MB 0, 4MB 0
[    0.015052] Last level dTLB entries: 4KB 0, 2MB 0, 4MB 0, 1GB 0
[    0.015052] tlb_flushall_shift: -1
[    0.016005] CPU:=20
[    0.016005] CPU: GenuineIntel GenuineIntel Common KVM processorCommon KV=
M processor (fam: 0f, model: 06 (fam: 0f, model: 06, stepping: 01)
, stepping: 01)
[    0.019529] Performance Events:=20
[    0.019529] Performance Events: no PMU driver, software events only.
no PMU driver, software events only.
[    0.022617] Enabling APIC mode:  Flat.  Using 1 I/O APICs
[    0.022617] Enabling APIC mode:  Flat.  Using 1 I/O APICs
[    0.023015] Getting VERSION: 50014
[    0.023015] Getting VERSION: 50014
[    0.024010] Getting VERSION: 50014
[    0.024010] Getting VERSION: 50014
[    0.024689] Getting ID: 0
[    0.024689] Getting ID: 0
[    0.025013] Getting ID: f000000
[    0.025013] Getting ID: f000000
[    0.026018] Getting LVT0: 8700
[    0.026018] Getting LVT0: 8700
[    0.026615] Getting LVT1: 8400
[    0.026615] Getting LVT1: 8400
[    0.027067] enabled ExtINT on CPU#0
[    0.027067] enabled ExtINT on CPU#0
[    0.028778] ENABLING IO-APIC IRQs
[    0.028778] ENABLING IO-APIC IRQs
[    0.029009] init IO_APIC IRQs
[    0.029009] init IO_APIC IRQs
[    0.029503]  apic 0 pin 0 not connected
[    0.029503]  apic 0 pin 0 not connected
[    0.030019] NMI watchdog: disabled (cpu0): hardware events not enabled
[    0.030019] NMI watchdog: disabled (cpu0): hardware events not enabled
[    0.031045] IOAPIC[0]: Set routing entry (0-1 -> 0x31 -> IRQ 1 Mode:0 Ac=
tive:0 Dest:1)
[    0.031045] IOAPIC[0]: Set routing entry (0-1 -> 0x31 -> IRQ 1 Mode:0 Ac=
tive:0 Dest:1)
[    0.032022] IOAPIC[0]: Set routing entry (0-2 -> 0x30 -> IRQ 0 Mode:0 Ac=
tive:0 Dest:1)
[    0.032022] IOAPIC[0]: Set routing entry (0-2 -> 0x30 -> IRQ 0 Mode:0 Ac=
tive:0 Dest:1)
[    0.033021] IOAPIC[0]: Set routing entry (0-3 -> 0x33 -> IRQ 3 Mode:0 Ac=
tive:0 Dest:1)
[    0.033021] IOAPIC[0]: Set routing entry (0-3 -> 0x33 -> IRQ 3 Mode:0 Ac=
tive:0 Dest:1)
[    0.034019] IOAPIC[0]: Set routing entry (0-4 -> 0x34 -> IRQ 4 Mode:0 Ac=
tive:0 Dest:1)
[    0.034019] IOAPIC[0]: Set routing entry (0-4 -> 0x34 -> IRQ 4 Mode:0 Ac=
tive:0 Dest:1)
[    0.035019] IOAPIC[0]: Set routing entry (0-5 -> 0x35 -> IRQ 5 Mode:1 Ac=
tive:0 Dest:1)
[    0.035019] IOAPIC[0]: Set routing entry (0-5 -> 0x35 -> IRQ 5 Mode:1 Ac=
tive:0 Dest:1)
[    0.036020] IOAPIC[0]: Set routing entry (0-6 -> 0x36 -> IRQ 6 Mode:0 Ac=
tive:0 Dest:1)
[    0.036020] IOAPIC[0]: Set routing entry (0-6 -> 0x36 -> IRQ 6 Mode:0 Ac=
tive:0 Dest:1)
[    0.037019] IOAPIC[0]: Set routing entry (0-7 -> 0x37 -> IRQ 7 Mode:0 Ac=
tive:0 Dest:1)
[    0.037019] IOAPIC[0]: Set routing entry (0-7 -> 0x37 -> IRQ 7 Mode:0 Ac=
tive:0 Dest:1)
[    0.038019] IOAPIC[0]: Set routing entry (0-8 -> 0x38 -> IRQ 8 Mode:0 Ac=
tive:0 Dest:1)
[    0.038019] IOAPIC[0]: Set routing entry (0-8 -> 0x38 -> IRQ 8 Mode:0 Ac=
tive:0 Dest:1)
[    0.039020] IOAPIC[0]: Set routing entry (0-9 -> 0x39 -> IRQ 9 Mode:1 Ac=
tive:0 Dest:1)
[    0.039020] IOAPIC[0]: Set routing entry (0-9 -> 0x39 -> IRQ 9 Mode:1 Ac=
tive:0 Dest:1)
[    0.040027] IOAPIC[0]: Set routing entry (0-10 -> 0x3a -> IRQ 10 Mode:1 =
Active:0 Dest:1)
[    0.040027] IOAPIC[0]: Set routing entry (0-10 -> 0x3a -> IRQ 10 Mode:1 =
Active:0 Dest:1)
[    0.041019] IOAPIC[0]: Set routing entry (0-11 -> 0x3b -> IRQ 11 Mode:1 =
Active:0 Dest:1)
[    0.041019] IOAPIC[0]: Set routing entry (0-11 -> 0x3b -> IRQ 11 Mode:1 =
Active:0 Dest:1)
[    0.042020] IOAPIC[0]: Set routing entry (0-12 -> 0x3c -> IRQ 12 Mode:0 =
Active:0 Dest:1)
[    0.042020] IOAPIC[0]: Set routing entry (0-12 -> 0x3c -> IRQ 12 Mode:0 =
Active:0 Dest:1)
[    0.043019] IOAPIC[0]: Set routing entry (0-13 -> 0x3d -> IRQ 13 Mode:0 =
Active:0 Dest:1)
[    0.043019] IOAPIC[0]: Set routing entry (0-13 -> 0x3d -> IRQ 13 Mode:0 =
Active:0 Dest:1)
[    0.044019] IOAPIC[0]: Set routing entry (0-14 -> 0x3e -> IRQ 14 Mode:0 =
Active:0 Dest:1)
[    0.044019] IOAPIC[0]: Set routing entry (0-14 -> 0x3e -> IRQ 14 Mode:0 =
Active:0 Dest:1)
[    0.045020] IOAPIC[0]: Set routing entry (0-15 -> 0x3f -> IRQ 15 Mode:0 =
Active:0 Dest:1)
[    0.045020] IOAPIC[0]: Set routing entry (0-15 -> 0x3f -> IRQ 15 Mode:0 =
Active:0 Dest:1)
[    0.046016]  apic 0 pin 16 not connected
[    0.046016]  apic 0 pin 16 not connected
[    0.047006]  apic 0 pin 17 not connected
[    0.047006]  apic 0 pin 17 not connected
[    0.048004]  apic 0 pin 18 not connected
[    0.048004]  apic 0 pin 18 not connected
[    0.049003]  apic 0 pin 19 not connected
[    0.049003]  apic 0 pin 19 not connected
[    0.049640]  apic 0 pin 20 not connected
[    0.049640]  apic 0 pin 20 not connected
[    0.050003]  apic 0 pin 21 not connected
[    0.050003]  apic 0 pin 21 not connected
[    0.051003]  apic 0 pin 22 not connected
[    0.051003]  apic 0 pin 22 not connected
[    0.051652]  apic 0 pin 23 not connected
[    0.051652]  apic 0 pin 23 not connected
[    0.052145] ..TIMER: vector=3D0x30 apic1=3D0 pin1=3D2 apic2=3D-1 pin2=3D=
-1
[    0.052145] ..TIMER: vector=3D0x30 apic1=3D0 pin1=3D2 apic2=3D-1 pin2=3D=
-1
[    0.053003] Using local APIC timer interrupts.
[    0.053003] calibrating APIC timer ...
[    0.053003] Using local APIC timer interrupts.
[    0.053003] calibrating APIC timer ...
[    0.055000] ... lapic delta =3D 6249636
[    0.055000] ... lapic delta =3D 6249636
[    0.055000] ... PM-Timer delta =3D 357965
[    0.055000] ... PM-Timer delta =3D 357965
[    0.055000] ... PM-Timer result ok
[    0.055000] ... PM-Timer result ok
[    0.055000] ..... delta 6249636
[    0.055000] ..... delta 6249636
[    0.055000] ..... mult: 268419822
[    0.055000] ..... mult: 268419822
[    0.055000] ..... calibration result: 999941
[    0.055000] ..... calibration result: 999941
[    0.055000] ..... CPU clock speed is 2693.0304 MHz.
[    0.055000] ..... CPU clock speed is 2693.0304 MHz.
[    0.055000] ..... host bus clock speed is 999.0941 MHz.
[    0.055000] ..... host bus clock speed is 999.0941 MHz.
[    0.055439] devtmpfs: initialized
[    0.055439] devtmpfs: initialized
[    0.056734] evm: security.ima
[    0.056734] evm: security.ima
[    0.057004] evm: security.capability
[    0.057004] evm: security.capability
[    0.058645] atomic64_test: passed for i586+ platform with CX8 and with S=
SE
[    0.058645] atomic64_test: passed for i586+ platform with CX8 and with S=
SE
[    0.059097] RTC time: 22:23:10, date: 07/22/14
[    0.059097] RTC time: 22:23:10, date: 07/22/14
[    0.060140] NET: Registered protocol family 16
[    0.060140] NET: Registered protocol family 16
[    0.062421] EISA bus registered
[    0.062421] EISA bus registered
[    0.062947] cpuidle: using governor ladder
[    0.062947] cpuidle: using governor ladder
[    0.063007] cpuidle: using governor menu
[    0.063007] cpuidle: using governor menu
[    0.064601] ACPI: bus type PCI registered
[    0.064601] ACPI: bus type PCI registered
[    0.065038] PCI: PCI BIOS revision 2.10 entry at 0xfc6d5, last bus=3D0
[    0.065038] PCI: PCI BIOS revision 2.10 entry at 0xfc6d5, last bus=3D0
[    0.079746] ACPI: Added _OSI(Module Device)
[    0.079746] ACPI: Added _OSI(Module Device)
[    0.080004] ACPI: Added _OSI(Processor Device)
[    0.080004] ACPI: Added _OSI(Processor Device)
[    0.081003] ACPI: Added _OSI(3.0 _SCP Extensions)
[    0.081003] ACPI: Added _OSI(3.0 _SCP Extensions)
[    0.081846] ACPI: Added _OSI(Processor Aggregator Device)
[    0.081846] ACPI: Added _OSI(Processor Aggregator Device)
[    0.089636] ACPI: Interpreter enabled
[    0.089636] ACPI: Interpreter enabled
[    0.090005] ACPI Exception: AE_NOT_FOUND,=20
[    0.090005] ACPI Exception: AE_NOT_FOUND, While evaluating Sleep State [=
\_S1_]While evaluating Sleep State [\_S1_] (20140424/hwxface-580)
 (20140424/hwxface-580)
[    0.091357] ACPI Exception: AE_NOT_FOUND,=20
[    0.091357] ACPI Exception: AE_NOT_FOUND, While evaluating Sleep State [=
\_S2_]While evaluating Sleep State [\_S2_] (20140424/hwxface-580)
 (20140424/hwxface-580)
[    0.093029] ACPI: (supports S0 S3 S5)
[    0.093029] ACPI: (supports S0 S3 S5)
[    0.093664] ACPI: Using IOAPIC for interrupt routing
[    0.093664] ACPI: Using IOAPIC for interrupt routing
[    0.094046] PCI: Using host bridge windows from ACPI; if necessary, use =
"pci=3Dnocrs" and report a bug
[    0.094046] PCI: Using host bridge windows from ACPI; if necessary, use =
"pci=3Dnocrs" and report a bug
[    0.103768] ACPI: PCI Root Bridge [PCI0] (domain 0000 [bus 00-ff])
[    0.103768] ACPI: PCI Root Bridge [PCI0] (domain 0000 [bus 00-ff])
[    0.104009] acpi PNP0A03:00: _OSC: OS supports [ASPM ClockPM Segments MS=
I]
[    0.104009] acpi PNP0A03:00: _OSC: OS supports [ASPM ClockPM Segments MS=
I]
[    0.105032] acpi PNP0A03:00: _OSC failed (AE_NOT_FOUND); disabling ASPM
[    0.105032] acpi PNP0A03:00: _OSC failed (AE_NOT_FOUND); disabling ASPM
[    0.106461] PCI host bridge to bus 0000:00
[    0.106461] PCI host bridge to bus 0000:00
[    0.107005] pci_bus 0000:00: root bus resource [bus 00-ff]
[    0.107005] pci_bus 0000:00: root bus resource [bus 00-ff]
[    0.108005] pci_bus 0000:00: root bus resource [io  0x0000-0x0cf7]
[    0.108005] pci_bus 0000:00: root bus resource [io  0x0000-0x0cf7]
[    0.109003] pci_bus 0000:00: root bus resource [io  0x0d00-0xffff]
[    0.109003] pci_bus 0000:00: root bus resource [io  0x0d00-0xffff]
[    0.109952] pci_bus 0000:00: root bus resource [mem 0x000a0000-0x000bfff=
f]
[    0.109952] pci_bus 0000:00: root bus resource [mem 0x000a0000-0x000bfff=
f]
[    0.110003] pci_bus 0000:00: root bus resource [mem 0x80000000-0xfebffff=
f]
[    0.110003] pci_bus 0000:00: root bus resource [mem 0x80000000-0xfebffff=
f]
[    0.111057] pci 0000:00:00.0: [8086:1237] type 00 class 0x060000
[    0.111057] pci 0000:00:00.0: [8086:1237] type 00 class 0x060000
[    0.112541] pci 0000:00:01.0: [8086:7000] type 00 class 0x060100
[    0.112541] pci 0000:00:01.0: [8086:7000] type 00 class 0x060100
[    0.114372] pci 0000:00:01.1: [8086:7010] type 00 class 0x010180
[    0.114372] pci 0000:00:01.1: [8086:7010] type 00 class 0x010180
[    0.118005] pci 0000:00:01.1: reg 0x20: [io  0xc1c0-0xc1cf]
[    0.118005] pci 0000:00:01.1: reg 0x20: [io  0xc1c0-0xc1cf]
[    0.120027] pci 0000:00:01.1: legacy IDE quirk: reg 0x10: [io  0x01f0-0x=
01f7]
[    0.120027] pci 0000:00:01.1: legacy IDE quirk: reg 0x10: [io  0x01f0-0x=
01f7]
[    0.121003] pci 0000:00:01.1: legacy IDE quirk: reg 0x14: [io  0x03f6]
[    0.121003] pci 0000:00:01.1: legacy IDE quirk: reg 0x14: [io  0x03f6]
[    0.122003] pci 0000:00:01.1: legacy IDE quirk: reg 0x18: [io  0x0170-0x=
0177]
[    0.122003] pci 0000:00:01.1: legacy IDE quirk: reg 0x18: [io  0x0170-0x=
0177]
[    0.123004] pci 0000:00:01.1: legacy IDE quirk: reg 0x1c: [io  0x0376]
[    0.123004] pci 0000:00:01.1: legacy IDE quirk: reg 0x1c: [io  0x0376]
[    0.124341] pci 0000:00:01.3: [8086:7113] type 00 class 0x068000
[    0.124341] pci 0000:00:01.3: [8086:7113] type 00 class 0x068000
[    0.126033] pci 0000:00:01.3: quirk: [io  0xb000-0xb03f] claimed by PIIX=
4 ACPI
[    0.126033] pci 0000:00:01.3: quirk: [io  0xb000-0xb03f] claimed by PIIX=
4 ACPI
[    0.127013] pci 0000:00:01.3: quirk: [io  0xb100-0xb10f] claimed by PIIX=
4 SMB
[    0.127013] pci 0000:00:01.3: quirk: [io  0xb100-0xb10f] claimed by PIIX=
4 SMB
[    0.128391] pci 0000:00:02.0: [1013:00b8] type 00 class 0x030000
[    0.128391] pci 0000:00:02.0: [1013:00b8] type 00 class 0x030000
[    0.131029] pci 0000:00:02.0: reg 0x10: [mem 0xfc000000-0xfdffffff pref]
[    0.131029] pci 0000:00:02.0: reg 0x10: [mem 0xfc000000-0xfdffffff pref]
[    0.133652] pci 0000:00:02.0: reg 0x14: [mem 0xfebf0000-0xfebf0fff]
[    0.133652] pci 0000:00:02.0: reg 0x14: [mem 0xfebf0000-0xfebf0fff]
[    0.141655] pci 0000:00:02.0: reg 0x30: [mem 0xfebe0000-0xfebeffff pref]
[    0.141655] pci 0000:00:02.0: reg 0x30: [mem 0xfebe0000-0xfebeffff pref]
[    0.143412] pci 0000:00:03.0: [8086:100e] type 00 class 0x020000
[    0.143412] pci 0000:00:03.0: [8086:100e] type 00 class 0x020000
[    0.145006] pci 0000:00:03.0: reg 0x10: [mem 0xfeba0000-0xfebbffff]
[    0.145006] pci 0000:00:03.0: reg 0x10: [mem 0xfeba0000-0xfebbffff]
[    0.147007] pci 0000:00:03.0: reg 0x14: [io  0xc000-0xc03f]
[    0.147007] pci 0000:00:03.0: reg 0x14: [io  0xc000-0xc03f]
[    0.153004] pci 0000:00:03.0: reg 0x30: [mem 0xfebc0000-0xfebdffff pref]
[    0.153004] pci 0000:00:03.0: reg 0x30: [mem 0xfebc0000-0xfebdffff pref]
[    0.154374] pci 0000:00:04.0: [1af4:1001] type 00 class 0x010000
[    0.154374] pci 0000:00:04.0: [1af4:1001] type 00 class 0x010000
[    0.156509] pci 0000:00:04.0: reg 0x10: [io  0xc040-0xc07f]
[    0.156509] pci 0000:00:04.0: reg 0x10: [io  0xc040-0xc07f]
[    0.158505] pci 0000:00:04.0: reg 0x14: [mem 0xfebf1000-0xfebf1fff]
[    0.158505] pci 0000:00:04.0: reg 0x14: [mem 0xfebf1000-0xfebf1fff]
[    0.165128] pci 0000:00:05.0: [1af4:1001] type 00 class 0x010000
[    0.165128] pci 0000:00:05.0: [1af4:1001] type 00 class 0x010000
[    0.167004] pci 0000:00:05.0: reg 0x10: [io  0xc080-0xc0bf]
[    0.167004] pci 0000:00:05.0: reg 0x10: [io  0xc080-0xc0bf]
[    0.169004] pci 0000:00:05.0: reg 0x14: [mem 0xfebf2000-0xfebf2fff]
[    0.169004] pci 0000:00:05.0: reg 0x14: [mem 0xfebf2000-0xfebf2fff]
[    0.175505] pci 0000:00:06.0: [1af4:1001] type 00 class 0x010000
[    0.175505] pci 0000:00:06.0: [1af4:1001] type 00 class 0x010000
[    0.177602] pci 0000:00:06.0: reg 0x10: [io  0xc0c0-0xc0ff]
[    0.177602] pci 0000:00:06.0: reg 0x10: [io  0xc0c0-0xc0ff]
[    0.179503] pci 0000:00:06.0: reg 0x14: [mem 0xfebf3000-0xfebf3fff]
[    0.179503] pci 0000:00:06.0: reg 0x14: [mem 0xfebf3000-0xfebf3fff]
[    0.186229] pci 0000:00:07.0: [1af4:1001] type 00 class 0x010000
[    0.186229] pci 0000:00:07.0: [1af4:1001] type 00 class 0x010000
[    0.188004] pci 0000:00:07.0: reg 0x10: [io  0xc100-0xc13f]
[    0.188004] pci 0000:00:07.0: reg 0x10: [io  0xc100-0xc13f]
[    0.190005] pci 0000:00:07.0: reg 0x14: [mem 0xfebf4000-0xfebf4fff]
[    0.190005] pci 0000:00:07.0: reg 0x14: [mem 0xfebf4000-0xfebf4fff]
[    0.196523] pci 0000:00:08.0: [1af4:1001] type 00 class 0x010000
[    0.196523] pci 0000:00:08.0: [1af4:1001] type 00 class 0x010000
[    0.198506] pci 0000:00:08.0: reg 0x10: [io  0xc140-0xc17f]
[    0.198506] pci 0000:00:08.0: reg 0x10: [io  0xc140-0xc17f]
[    0.200504] pci 0000:00:08.0: reg 0x14: [mem 0xfebf5000-0xfebf5fff]
[    0.200504] pci 0000:00:08.0: reg 0x14: [mem 0xfebf5000-0xfebf5fff]
[    0.207368] pci 0000:00:09.0: [1af4:1001] type 00 class 0x010000
[    0.207368] pci 0000:00:09.0: [1af4:1001] type 00 class 0x010000
[    0.209005] pci 0000:00:09.0: reg 0x10: [io  0xc180-0xc1bf]
[    0.209005] pci 0000:00:09.0: reg 0x10: [io  0xc180-0xc1bf]
[    0.211004] pci 0000:00:09.0: reg 0x14: [mem 0xfebf6000-0xfebf6fff]
[    0.211004] pci 0000:00:09.0: reg 0x14: [mem 0xfebf6000-0xfebf6fff]
[    0.218100] pci 0000:00:0a.0: [8086:25ab] type 00 class 0x088000
[    0.218100] pci 0000:00:0a.0: [8086:25ab] type 00 class 0x088000
[    0.219537] pci 0000:00:0a.0: reg 0x10: [mem 0xfebf7000-0xfebf700f]
[    0.219537] pci 0000:00:0a.0: reg 0x10: [mem 0xfebf7000-0xfebf700f]
[    0.225226] pci_bus 0000:00: on NUMA node 0
[    0.225226] pci_bus 0000:00: on NUMA node 0
[    0.227787] ACPI: PCI Interrupt Link [LNKA] (IRQs
[    0.227787] ACPI: PCI Interrupt Link [LNKA] (IRQs 5 5 *10 *10 11 11))

[    0.229222] ACPI: PCI Interrupt Link [LNKB] (IRQs
[    0.229222] ACPI: PCI Interrupt Link [LNKB] (IRQs 5 5 *10 *10 11 11))

[    0.230290] ACPI: PCI Interrupt Link [LNKC] (IRQs
[    0.230290] ACPI: PCI Interrupt Link [LNKC] (IRQs 5 5 10 10 *11 *11))

[    0.231390] ACPI: PCI Interrupt Link [LNKD] (IRQs
[    0.231390] ACPI: PCI Interrupt Link [LNKD] (IRQs 5 5 10 10 *11 *11))

[    0.232306] ACPI: PCI Interrupt Link [LNKS] (IRQs
[    0.232306] ACPI: PCI Interrupt Link [LNKS] (IRQs *9 *9))

[    0.233646] ACPI:=20
[    0.233646] ACPI: Enabled 16 GPEs in block 00 to 0FEnabled 16 GPEs in bl=
ock 00 to 0F

[    0.235197] vgaarb: device added: PCI:0000:00:02.0,decodes=3Dio+mem,owns=
=3Dio+mem,locks=3Dnone
[    0.235197] vgaarb: device added: PCI:0000:00:02.0,decodes=3Dio+mem,owns=
=3Dio+mem,locks=3Dnone
[    0.236008] vgaarb: loaded
[    0.236008] vgaarb: loaded
[    0.236448] vgaarb: bridge control possible 0000:00:02.0
[    0.236448] vgaarb: bridge control possible 0000:00:02.0
[    0.238963] ACPI: bus type USB registered
[    0.238963] ACPI: bus type USB registered
[    0.239075] usbcore: registered new interface driver usbfs
[    0.239075] usbcore: registered new interface driver usbfs
[    0.240037] usbcore: registered new interface driver hub
[    0.240037] usbcore: registered new interface driver hub
[    0.241075] usbcore: registered new device driver usb
[    0.241075] usbcore: registered new device driver usb
[    0.242284] pps_core: LinuxPPS API ver. 1 registered
[    0.242284] pps_core: LinuxPPS API ver. 1 registered
[    0.243003] pps_core: Software ver. 5.3.6 - Copyright 2005-2007 Rodolfo =
Giometti <giometti@linux.it>
[    0.243003] pps_core: Software ver. 5.3.6 - Copyright 2005-2007 Rodolfo =
Giometti <giometti@linux.it>
[    0.244070] EDAC MC: Ver: 3.0.0
[    0.244070] EDAC MC: Ver: 3.0.0
[    0.245293] wmi: Mapper loaded
[    0.245293] wmi: Mapper loaded
[    0.245954] PCI: Using ACPI for IRQ routing
[    0.245954] PCI: Using ACPI for IRQ routing
[    0.246007] PCI: pci_cache_line_size set to 64 bytes
[    0.246007] PCI: pci_cache_line_size set to 64 bytes
[    0.247197] e820: reserve RAM buffer [mem 0x0009fc00-0x0009ffff]
[    0.247197] e820: reserve RAM buffer [mem 0x0009fc00-0x0009ffff]
[    0.248011] e820: reserve RAM buffer [mem 0x13ffe000-0x13ffffff]
[    0.248011] e820: reserve RAM buffer [mem 0x13ffe000-0x13ffffff]
[    0.250690] HPET: 3 timers in total, 0 timers will be used for per-cpu t=
imer
[    0.250690] HPET: 3 timers in total, 0 timers will be used for per-cpu t=
imer
[    0.251169] Switched to clocksource kvm-clock
[    0.251169] Switched to clocksource kvm-clock
[    0.251989] pnp: PnP ACPI init
[    0.251989] pnp: PnP ACPI init
[    0.252516] ACPI: bus type PNP registered
[    0.252516] ACPI: bus type PNP registered
[    0.253242] IOAPIC[0]: Set routing entry (0-8 -> 0x38 -> IRQ 8 Mode:0 Ac=
tive:0 Dest:1)
[    0.253242] IOAPIC[0]: Set routing entry (0-8 -> 0x38 -> IRQ 8 Mode:0 Ac=
tive:0 Dest:1)
[    0.254662] pnp 00:00: Plug and Play ACPI device, IDs PNP0b00 (active)
[    0.254662] pnp 00:00: Plug and Play ACPI device, IDs PNP0b00 (active)
[    0.256050] IOAPIC[0]: Set routing entry (0-1 -> 0x31 -> IRQ 1 Mode:0 Ac=
tive:0 Dest:1)
[    0.256050] IOAPIC[0]: Set routing entry (0-1 -> 0x31 -> IRQ 1 Mode:0 Ac=
tive:0 Dest:1)
[    0.257396] pnp 00:01: Plug and Play ACPI device, IDs PNP0303 (active)
[    0.257396] pnp 00:01: Plug and Play ACPI device, IDs PNP0303 (active)
[    0.258476] IOAPIC[0]: Set routing entry (0-12 -> 0x3c -> IRQ 12 Mode:0 =
Active:0 Dest:1)
[    0.258476] IOAPIC[0]: Set routing entry (0-12 -> 0x3c -> IRQ 12 Mode:0 =
Active:0 Dest:1)
[    0.259835] pnp 00:02: Plug and Play ACPI device, IDs PNP0f13 (active)
[    0.259835] pnp 00:02: Plug and Play ACPI device, IDs PNP0f13 (active)
[    0.260919] IOAPIC[0]: Set routing entry (0-6 -> 0x36 -> IRQ 6 Mode:0 Ac=
tive:0 Dest:1)
[    0.260919] IOAPIC[0]: Set routing entry (0-6 -> 0x36 -> IRQ 6 Mode:0 Ac=
tive:0 Dest:1)
[    0.262195] pnp 00:03: [dma 2]
[    0.262195] pnp 00:03: [dma 2]
[    0.262746] pnp 00:03: Plug and Play ACPI device, IDs PNP0700 (active)
[    0.262746] pnp 00:03: Plug and Play ACPI device, IDs PNP0700 (active)
[    0.263845] IOAPIC[0]: Set routing entry (0-7 -> 0x37 -> IRQ 7 Mode:0 Ac=
tive:0 Dest:1)
[    0.263845] IOAPIC[0]: Set routing entry (0-7 -> 0x37 -> IRQ 7 Mode:0 Ac=
tive:0 Dest:1)
[    0.265176] pnp 00:04: Plug and Play ACPI device, IDs PNP0400 (active)
[    0.265176] pnp 00:04: Plug and Play ACPI device, IDs PNP0400 (active)
[    0.266272] IOAPIC[0]: Set routing entry (0-4 -> 0x34 -> IRQ 4 Mode:0 Ac=
tive:0 Dest:1)
[    0.266272] IOAPIC[0]: Set routing entry (0-4 -> 0x34 -> IRQ 4 Mode:0 Ac=
tive:0 Dest:1)
[    0.267585] pnp 00:05: Plug and Play ACPI device, IDs PNP0501 (active)
[    0.267585] pnp 00:05: Plug and Play ACPI device, IDs PNP0501 (active)
[    0.268693] IOAPIC[0]: Set routing entry (0-3 -> 0x33 -> IRQ 3 Mode:0 Ac=
tive:0 Dest:1)
[    0.268693] IOAPIC[0]: Set routing entry (0-3 -> 0x33 -> IRQ 3 Mode:0 Ac=
tive:0 Dest:1)
[    0.270031] pnp 00:06: Plug and Play ACPI device, IDs PNP0501 (active)
[    0.270031] pnp 00:06: Plug and Play ACPI device, IDs PNP0501 (active)
[    0.271480] pnp: PnP ACPI: found 7 devices
[    0.271480] pnp: PnP ACPI: found 7 devices
[    0.272143] ACPI: bus type PNP unregistered
[    0.272143] ACPI: bus type PNP unregistered
[    0.272810] PnPBIOS: Disabled
[    0.272810] PnPBIOS: Disabled
[    0.308808] pci_bus 0000:00: resource 4 [io  0x0000-0x0cf7]
[    0.308808] pci_bus 0000:00: resource 4 [io  0x0000-0x0cf7]
[    0.309695] pci_bus 0000:00: resource 5 [io  0x0d00-0xffff]
[    0.309695] pci_bus 0000:00: resource 5 [io  0x0d00-0xffff]
[    0.310572] pci_bus 0000:00: resource 6 [mem 0x000a0000-0x000bffff]
[    0.310572] pci_bus 0000:00: resource 6 [mem 0x000a0000-0x000bffff]
[    0.311552] pci_bus 0000:00: resource 7 [mem 0x80000000-0xfebfffff]
[    0.311552] pci_bus 0000:00: resource 7 [mem 0x80000000-0xfebfffff]
[    0.312555] NET: Registered protocol family 1
[    0.312555] NET: Registered protocol family 1
[    0.313268] pci 0000:00:00.0: Limiting direct PCI/PCI transfers
[    0.313268] pci 0000:00:00.0: Limiting direct PCI/PCI transfers
[    0.314210] pci 0000:00:01.0: PIIX3: Enabling Passive Release
[    0.314210] pci 0000:00:01.0: PIIX3: Enabling Passive Release
[    0.315129] pci 0000:00:01.0: Activating ISA DMA hang workarounds
[    0.315129] pci 0000:00:01.0: Activating ISA DMA hang workarounds
[    0.316116] pci 0000:00:02.0: Boot video device
[    0.316116] pci 0000:00:02.0: Boot video device
[    0.316898] PCI: CLS 0 bytes, default 64
[    0.316898] PCI: CLS 0 bytes, default 64
[    0.317745] Unpacking initramfs...
[    0.317745] Unpacking initramfs...
[    0.418659] debug: unmapping init [mem 0xc3cbd000-0xc3feffff]
[    0.418659] debug: unmapping init [mem 0xc3cbd000-0xc3feffff]
[    0.420466] Scanning for low memory corruption every 60 seconds
[    0.420466] Scanning for low memory corruption every 60 seconds
[    0.422048] PCLMULQDQ-NI instructions are not detected.
[    0.422048] PCLMULQDQ-NI instructions are not detected.
[    0.422877] NatSemi SCx200 Driver
[    0.422877] NatSemi SCx200 Driver
[    0.423502] spin_lock-torture:--- Start of test: nwriters_stress=3D2 sta=
t_interval=3D60 verbose=3D1 shuffle_interval=3D3 stutter=3D5 shutdown_secs=
=3D0 onoff_interval=3D0 onoff_holdoff=3D0
[    0.423502] spin_lock-torture:--- Start of test: nwriters_stress=3D2 sta=
t_interval=3D60 verbose=3D1 shuffle_interval=3D3 stutter=3D5 shutdown_secs=
=3D0 onoff_interval=3D0 onoff_holdoff=3D0
[    0.425944] spin_lock-torture: Creating torture_shuffle task
[    0.425944] spin_lock-torture: Creating torture_shuffle task
[    0.426891] spin_lock-torture: Creating torture_stutter task
[    0.426891] spin_lock-torture: Creating torture_stutter task
[    0.427827] spin_lock-torture: torture_shuffle task started
[    0.427827] spin_lock-torture: torture_shuffle task started
[    0.428732] spin_lock-torture: Creating lock_torture_writer task
[    0.428732] spin_lock-torture: Creating lock_torture_writer task
[    0.429762] spin_lock-torture: torture_stutter task started
[    0.429762] spin_lock-torture: torture_stutter task started
[    0.430669] spin_lock-torture: Creating lock_torture_writer task
[    0.430669] spin_lock-torture: Creating lock_torture_writer task
[    0.431688] spin_lock-torture: lock_torture_writer task started
[    0.431688] spin_lock-torture: lock_torture_writer task started
[    0.432649] spin_lock-torture: Creating lock_torture_stats task
[    0.432649] spin_lock-torture: Creating lock_torture_stats task
[    0.433628] spin_lock-torture: lock_torture_writer task started
[    0.433628] spin_lock-torture: lock_torture_writer task started
[    0.434964] futex hash table entries: 256 (order: 1, 13312 bytes)
[    0.434964] futex hash table entries: 256 (order: 1, 13312 bytes)
[    0.436272] spin_lock-torture: lock_torture_stats task started
[    0.436272] spin_lock-torture: lock_torture_stats task started
[    0.437272] HugeTLB registered 4 MB page size, pre-allocated 0 pages
[    0.437272] HugeTLB registered 4 MB page size, pre-allocated 0 pages
[    0.438380] VFS: Disk quotas dquot_6.5.2
[    0.438380] VFS: Disk quotas dquot_6.5.2
[    0.439030] Dquot-cache hash table entries: 1024 (order 0, 4096 bytes)
[    0.439030] Dquot-cache hash table entries: 1024 (order 0, 4096 bytes)
[    0.440660] fuse init (API version 7.23)
[    0.440660] fuse init (API version 7.23)
[    0.447550] alg: No test for lz4hc (lz4hc-generic)
[    0.447550] alg: No test for lz4hc (lz4hc-generic)
[    0.448389] alg: No test for stdrng (krng)
[    0.448389] alg: No test for stdrng (krng)
[    0.449218] Key type asymmetric registered
[    0.449218] Key type asymmetric registered
[    0.449876] list_sort_test: start testing list_sort()
[    0.449876] list_sort_test: start testing list_sort()
[    0.450973] test_string_helpers: Running tests...
[    0.450973] test_string_helpers: Running tests...
[    0.451902] rbtree testing
[    0.451902] rbtree testing -> 10102 cycles
 -> 10102 cycles
[    0.857134] augmented rbtree testing
[    0.857134] augmented rbtree testing -> 14426 cycles
 -> 14426 cycles
[    1.432050] tsc: Refined TSC clocksource calibration: 2693.356 MHz
[    1.432050] tsc: Refined TSC clocksource calibration: 2693.356 MHz
[    1.433590] pci_hotplug: PCI Hot Plug PCI Core version: 0.5
[    1.433590] pci_hotplug: PCI Hot Plug PCI Core version: 0.5
[    1.434487] cpqphp: Compaq Hot Plug PCI Controller Driver version: 0.9.8
[    1.434487] cpqphp: Compaq Hot Plug PCI Controller Driver version: 0.9.8
[    1.435680] shpchp: Standard Hot Plug PCI Controller Driver version: 0.4
[    1.435680] shpchp: Standard Hot Plug PCI Controller Driver version: 0.4
[    1.437076] rivafb_setup START
[    1.437076] rivafb_setup START
[    1.437694] VIA Graphics Integration Chipset framebuffer 2.4 initializing
[    1.437694] VIA Graphics Integration Chipset framebuffer 2.4 initializing
[    1.439134] no IO addresses supplied
[    1.439134] no IO addresses supplied
[    1.439834] cirrusfb 0000:00:02.0: Cirrus Logic chipset on PCI bus, RAM =
(4096 kB) at 0xfc000000
[    1.439834] cirrusfb 0000:00:02.0: Cirrus Logic chipset on PCI bus, RAM =
(4096 kB) at 0xfc000000
[    1.441583] usbcore: registered new interface driver udlfb
[    1.441583] usbcore: registered new interface driver udlfb
[    1.442483] usbcore: registered new interface driver smscufx
[    1.442483] usbcore: registered new interface driver smscufx
[    1.443466] ipmi message handler version 39.2
[    1.443466] ipmi message handler version 39.2
[    1.444202] IPMI System Interface driver.
[    1.444202] IPMI System Interface driver.
[    1.444946] ipmi_si: Adding default-specified kcs state machine
[    1.444946] ipmi_si: Adding default-specified kcs state machine

[    1.445920] ipmi_si: Trying default-specified kcs state machine at i/o a=
ddress 0xca2, slave address 0x0, irq 0
[    1.445920] ipmi_si: Trying default-specified kcs state machine at i/o a=
ddress 0xca2, slave address 0x0, irq 0
[    1.447477] ipmi_si: Interface detection failed
[    1.447477] ipmi_si: Interface detection failed
[    1.448204] ipmi_si: Adding default-specified smic state machine
[    1.448204] ipmi_si: Adding default-specified smic state machine

[    1.449165] ipmi_si: Trying default-specified smic state machine at i/o =
address 0xca9, slave address 0x0, irq 0
[    1.449165] ipmi_si: Trying default-specified smic state machine at i/o =
address 0xca9, slave address 0x0, irq 0
[    1.450747] ipmi_si: Interface detection failed
[    1.450747] ipmi_si: Interface detection failed
[    1.451472] ipmi_si: Adding default-specified bt state machine
[    1.451472] ipmi_si: Adding default-specified bt state machine

[    1.452398] ipmi_si: Trying default-specified bt state machine at i/o ad=
dress 0xe4, slave address 0x0, irq 0
[    1.452398] ipmi_si: Trying default-specified bt state machine at i/o ad=
dress 0xe4, slave address 0x0, irq 0
[    1.453930] ipmi_si: Interface detection failed
[    1.453930] ipmi_si: Interface detection failed
[    1.454758] ipmi_si: Unable to find any System Interface(s)
[    1.454758] ipmi_si: Unable to find any System Interface(s)
[    1.455669] IPMI Watchdog: driver initialized
[    1.455669] IPMI Watchdog: driver initialized
[    1.456382] Copyright (C) 2004 MontaVista Software - IPMI Powerdown via =
sys_reboot.
[    1.456382] Copyright (C) 2004 MontaVista Software - IPMI Powerdown via =
sys_reboot.
[    1.457600] IPMI poweroff: Unable to register powercycle sysctl
[    1.457600] IPMI poweroff: Unable to register powercycle sysctl
[    1.458774] input: Power Button as /devices/LNXSYSTM:00/LNXPWRBN:00/inpu=
t/input0
[    1.458774] input: Power Button as /devices/LNXSYSTM:00/LNXPWRBN:00/inpu=
t/input0
[    1.459984] ACPI: Power Button [PWRF]
[    1.459984] ACPI: Power Button [PWRF]
[    1.462105] ACPI: PCI Interrupt Link [LNKD] enabled at IRQ 11
[    1.462105] ACPI: PCI Interrupt Link [LNKD] enabled at IRQ 11
[    1.463015] IOAPIC[0]: Set routing entry (0-11 -> 0x3b -> IRQ 11 Mode:1 =
Active:0 Dest:1)
[    1.463015] IOAPIC[0]: Set routing entry (0-11 -> 0x3b -> IRQ 11 Mode:1 =
Active:0 Dest:1)
[    1.466480] ACPI: PCI Interrupt Link [LNKA] enabled at IRQ 10
[    1.466480] ACPI: PCI Interrupt Link [LNKA] enabled at IRQ 10
[    1.467395] IOAPIC[0]: Set routing entry (0-10 -> 0x3a -> IRQ 10 Mode:1 =
Active:0 Dest:1)
[    1.467395] IOAPIC[0]: Set routing entry (0-10 -> 0x3a -> IRQ 10 Mode:1 =
Active:0 Dest:1)
[    1.470836] ACPI: PCI Interrupt Link [LNKB] enabled at IRQ 10
[    1.470836] ACPI: PCI Interrupt Link [LNKB] enabled at IRQ 10
[    1.474227] ACPI: PCI Interrupt Link [LNKC] enabled at IRQ 11
[    1.474227] ACPI: PCI Interrupt Link [LNKC] enabled at IRQ 11
[    1.509637] Serial: 8250/16550 driver, 4 ports, IRQ sharing disabled
[    1.509637] Serial: 8250/16550 driver, 4 ports, IRQ sharing disabled
[    1.534939] 00:05: ttyS0 at I/O 0x3f8 (irq =3D 4, base_baud =3D 115200) =
is a 16550A
[    1.534939] 00:05: ttyS0 at I/O 0x3f8 (irq =3D 4, base_baud =3D 115200) =
is a 16550A
[    1.537242] lp: driver loaded but no devices found
[    1.537242] lp: driver loaded but no devices found
[    1.538057] DoubleTalk PC - not found
[    1.538057] DoubleTalk PC - not found
[    1.538646] Applicom driver: $Id: ac.c,v 1.30 2000/03/22 16:03:57 dwmw2 =
Exp $
[    1.538646] Applicom driver: $Id: ac.c,v 1.30 2000/03/22 16:03:57 dwmw2 =
Exp $
[    1.539775] ac.o: No PCI boards found.
[    1.539775] ac.o: No PCI boards found.
[    1.540380] ac.o: For an ISA board you must supply memory and irq parame=
ters.
[    1.540380] ac.o: For an ISA board you must supply memory and irq parame=
ters.
[    1.541491] sonypi: Sony Programmable I/O Controller Driver v1.26.
[    1.541491] sonypi: Sony Programmable I/O Controller Driver v1.26.
[    1.542462] toshiba: not a supported Toshiba laptop
[    1.542462] toshiba: not a supported Toshiba laptop
[    1.543246] ppdev: user-space parallel port driver
[    1.543246] ppdev: user-space parallel port driver
[    1.544004] scx200_gpio: no SCx200 gpio present
[    1.544004] scx200_gpio: no SCx200 gpio present
[    1.544706] nsc_gpio initializing
[    1.544706] nsc_gpio initializing
[    1.545259] telclk_interrupt =3D 0xf non-mcpbl0010 hw.
[    1.545259] telclk_interrupt =3D 0xf non-mcpbl0010 hw.
[    1.546055] Linux agpgart interface v0.103
[    1.546055] Linux agpgart interface v0.103
[    1.547413] [drm] Initialized drm 1.1.0 20060810
[    1.547413] [drm] Initialized drm 1.1.0 20060810
[    1.548381] [drm] radeon kernel modesetting enabled.
[    1.548381] [drm] radeon kernel modesetting enabled.
[    1.549527] usbcore: registered new interface driver udl
[    1.549527] usbcore: registered new interface driver udl
[    1.550509] intelfb: intelfb_init
[    1.550509] intelfb: intelfb_init
[    1.551049] intelfb: Framebuffer driver for Intel(R) 830M/845G/852GM/855=
GM/865G/915G/915GM/945G/945GM/945GME/965G/965GM chipsets
[    1.551049] intelfb: Framebuffer driver for Intel(R) 830M/845G/852GM/855=
GM/865G/915G/915GM/945G/945GM/945GME/965G/965GM chipsets
[    1.552843] intelfb: Version 0.9.6
[    1.552843] intelfb: Version 0.9.6
[    1.553385] intelfb: intelfb_setup
[    1.553385] intelfb: intelfb_setup
[    1.553926] intelfb: no options
[    1.553926] intelfb: no options
[    1.555037] parport_pc 00:04: reported by Plug and Play ACPI
[    1.555037] parport_pc 00:04: reported by Plug and Play ACPI
[    1.556040] parport0: PC-style at 0x378
[    1.556040] parport0: PC-style at 0x378, irq 7, irq 7 [ [PCSPPPCSPP,TRIS=
TATE,TRISTATE]
]
[    1.639223] lp0: using parport0 (interrupt-driven).
[    1.639223] lp0: using parport0 (interrupt-driven).
[    1.640916] Phantom Linux Driver, version n0.9.8, init OK
[    1.640916] Phantom Linux Driver, version n0.9.8, init OK
[    1.642134] Guest personality initialized and is inactive
[    1.642134] Guest personality initialized and is inactive
[    1.643087] VMCI host device registered (name=3Dvmci, major=3D10, minor=
=3D61)
[    1.643087] VMCI host device registered (name=3Dvmci, major=3D10, minor=
=3D61)
[    1.644234] Initialized host personality
[    1.644234] Initialized host personality
[    1.645027] usbcore: registered new interface driver rtsx_usb
[    1.645027] usbcore: registered new interface driver rtsx_usb
[    1.646469] parport0: powerup/reset Butterfly
[    1.646469] parport0: powerup/reset Butterfly
[    1.754046] parport_pc 00:04: registered master spi42
[    1.754046] parport_pc 00:04: registered master spi42
[    1.755022] spi spi42.1: spi_bitbang_setup, 66 nsec/bit
[    1.755022] spi spi42.1: spi_bitbang_setup, 66 nsec/bit
[    1.755926] spi spi42.1: setup mode 0, 8 bits/w, 15000000 Hz max --> 0
[    1.755926] spi spi42.1: setup mode 0, 8 bits/w, 15000000 Hz max --> 0
[    1.757108] parport_pc 00:04: registered child spi42.1
[    1.757108] parport_pc 00:04: registered child spi42.1
[    1.758003] parport0: dataflash at spi42.1
[    1.758003] parport0: dataflash at spi42.1
[    1.758649] parport0: AVR Butterfly
[    1.758649] parport0: AVR Butterfly
[    1.759490] I2O subsystem v1.325
[    1.759490] I2O subsystem v1.325
[    1.760087] i2o: max drivers =3D 8
[    1.760087] i2o: max drivers =3D 8
[    1.760782] I2O Configuration OSM v1.323
[    1.760782] I2O Configuration OSM v1.323
[    1.761440] I2O ProcFS OSM v1.316
[    1.761440] I2O ProcFS OSM v1.316
[    1.762441] usbcore: registered new interface driver hwa-rc
[    1.762441] usbcore: registered new interface driver hwa-rc
[    1.763387] usbcore: registered new interface driver i1480-dfu-usb
[    1.763387] usbcore: registered new interface driver i1480-dfu-usb
[    1.764734] ehci_hcd: USB 2.0 'Enhanced' Host Controller (EHCI) Driver
[    1.764734] ehci_hcd: USB 2.0 'Enhanced' Host Controller (EHCI) Driver
[    1.765860] ehci-pci: EHCI PCI platform driver
[    1.765860] ehci-pci: EHCI PCI platform driver
[    1.766625] ehci-platform: EHCI generic platform driver
[    1.766625] ehci-platform: EHCI generic platform driver
[    1.767641] ohci_hcd: USB 1.1 'Open' Host Controller (OHCI) Driver
[    1.767641] ohci_hcd: USB 1.1 'Open' Host Controller (OHCI) Driver
[    1.768670] ohci-platform: OHCI generic platform driver
[    1.768670] ohci-platform: OHCI generic platform driver
[    1.769537] driver u132_hcd
[    1.769537] driver u132_hcd
[    1.770239] usbcore: registered new interface driver hwa-hc
[    1.770239] usbcore: registered new interface driver hwa-hc
[    1.771222] fusbh200_hcd: FUSBH200 Host Controller (EHCI) Driver
[    1.771222] fusbh200_hcd: FUSBH200 Host Controller (EHCI) Driver
[    1.772231] Warning! fusbh200_hcd should always be loaded before uhci_hc=
d and ohci_hcd, not after
[    1.772231] Warning! fusbh200_hcd should always be loaded before uhci_hc=
d and ohci_hcd, not after
[    1.773663] fotg210_hcd: FOTG210 Host Controller (EHCI) Driver
[    1.773663] fotg210_hcd: FOTG210 Host Controller (EHCI) Driver
[    1.776269] usbcore: registered new interface driver cdc_wdm
[    1.776269] usbcore: registered new interface driver cdc_wdm
[    1.777304] usbcore: registered new interface driver appledisplay
[    1.777304] usbcore: registered new interface driver appledisplay
[    1.778384] usbcore: registered new interface driver cypress_cy7c63
[    1.778384] usbcore: registered new interface driver cypress_cy7c63
[    1.779453] usbcore: registered new interface driver emi26 - firmware lo=
ader
[    1.779453] usbcore: registered new interface driver emi26 - firmware lo=
ader
[    1.780670] ftdi_elan: driver ftdi-elan
[    1.780670] ftdi_elan: driver ftdi-elan
[    1.781500] usbcore: registered new interface driver ftdi-elan
[    1.781500] usbcore: registered new interface driver ftdi-elan
[    1.782468] usbcore: registered new interface driver idmouse
[    1.782468] usbcore: registered new interface driver idmouse
[    1.783446] usbcore: registered new interface driver isight_firmware
[    1.783446] usbcore: registered new interface driver isight_firmware
[    1.784550] usbcore: registered new interface driver usbled
[    1.784550] usbcore: registered new interface driver usbled
[    1.785478] usbcore: registered new interface driver legousbtower
[    1.785478] usbcore: registered new interface driver legousbtower
[    1.786486] usbcore: registered new interface driver usbtest
[    1.786486] usbcore: registered new interface driver usbtest
[    1.787485] usbcore: registered new interface driver trancevibrator
[    1.787485] usbcore: registered new interface driver trancevibrator
[    1.788511] usbcore: registered new interface driver uss720
[    1.788511] usbcore: registered new interface driver uss720
[    1.789395] uss720: v0.6:USB Parport Cable driver for Cables using the L=
ucent Technologies USS720 Chip
[    1.789395] uss720: v0.6:USB Parport Cable driver for Cables using the L=
ucent Technologies USS720 Chip
[    1.790856] uss720: NOTE: this is a special purpose driver to allow nons=
tandard
[    1.790856] uss720: NOTE: this is a special purpose driver to allow nons=
tandard
[    1.792074] uss720: protocols (eg. bitbang) over USS720 usb to parallel =
cables
[    1.792074] uss720: protocols (eg. bitbang) over USS720 usb to parallel =
cables
[    1.793206] uss720: If you just want to connect to a printer, use usblp =
instead
[    1.793206] uss720: If you just want to connect to a printer, use usblp =
instead
[    1.794379] usbcore: registered new interface driver usbsevseg
[    1.794379] usbcore: registered new interface driver usbsevseg
[    1.795348] usbcore: registered new interface driver yurex
[    1.795348] usbcore: registered new interface driver yurex
[    1.796421] usbcore: registered new interface driver sisusb
[    1.796421] usbcore: registered new interface driver sisusb
[    1.797868] g_ffs: gfs_init()
[    1.797868] g_ffs: gfs_init()
[    1.798375] functionfs_init()
[    1.798375] functionfs_init()
[    1.798854] file system registered
[    1.798854] file system registered
[    1.799545] i8042: PNP: PS/2 Controller [PNP0303:KBD,PNP0f13:MOU] at 0x6=
0,0x64 irq 1,12
[    1.799545] i8042: PNP: PS/2 Controller [PNP0303:KBD,PNP0f13:MOU] at 0x6=
0,0x64 irq 1,12
[    1.801517] serio: i8042 KBD port at 0x60,0x64 irq 1
[    1.801517] serio: i8042 KBD port at 0x60,0x64 irq 1
[    1.802330] serio: i8042 AUX port at 0x60,0x64 irq 12
[    1.802330] serio: i8042 AUX port at 0x60,0x64 irq 12
[    1.803447] parport0: cannot grant exclusive access for device parkbd
[    1.803447] parport0: cannot grant exclusive access for device parkbd
[    1.846413] mousedev: PS/2 mouse device common for all mice
[    1.846413] mousedev: PS/2 mouse device common for all mice
[    1.848074] input: AT Translated Set 2 keyboard as /devices/platform/i80=
42/serio0/input/input1
[    1.848074] input: AT Translated Set 2 keyboard as /devices/platform/i80=
42/serio0/input/input1
[    1.849691] usbcore: registered new interface driver appletouch
[    1.849691] usbcore: registered new interface driver appletouch
[    1.850697] inport.c: Didn't find InPort mouse at 0x23c
[    1.850697] inport.c: Didn't find InPort mouse at 0x23c
[    1.851681] logibm.c: Didn't find Logitech busmouse at 0x23c
[    1.851681] logibm.c: Didn't find Logitech busmouse at 0x23c
[    1.852644] usbcore: registered new interface driver synaptics_usb
[    1.852644] usbcore: registered new interface driver synaptics_usb
[    1.854097] usbcore: registered new interface driver xpad
[    1.854097] usbcore: registered new interface driver xpad
[    1.855051] usbcore: registered new interface driver aiptek
[    1.855051] usbcore: registered new interface driver aiptek
[    1.856085] usbcore: registered new interface driver gtco
[    1.856085] usbcore: registered new interface driver gtco
[    1.857001] usbcore: registered new interface driver wacom
[    1.857001] usbcore: registered new interface driver wacom
[    1.858282] mk712: device not present
[    1.858282] mk712: device not present
[    1.859170] apanel: Fujitsu BIOS signature 'FJKEYINF' not found...
[    1.859170] apanel: Fujitsu BIOS signature 'FJKEYINF' not found...
[    1.860289] usbcore: registered new interface driver ati_remote2
[    1.860289] usbcore: registered new interface driver ati_remote2
[    1.861340] usbcore: registered new interface driver ims_pcu
[    1.861340] usbcore: registered new interface driver ims_pcu
[    1.862290] usbcore: registered new interface driver keyspan_remote
[    1.862290] usbcore: registered new interface driver keyspan_remote
[    1.863533] usbcore: registered new interface driver powermate
[    1.863533] usbcore: registered new interface driver powermate
[    1.864592] usbcore: registered new interface driver yealink
[    1.864592] usbcore: registered new interface driver yealink
[    1.865622] rtc_cmos 00:00: RTC can wake from S4
[    1.865622] rtc_cmos 00:00: RTC can wake from S4
[    1.866578] rtc (null): alarm rollover: day
[    1.866578] rtc (null): alarm rollover: day
[    1.867519] rtc rtc0: rtc_cmos: dev (254:0)
[    1.867519] rtc rtc0: rtc_cmos: dev (254:0)
[    1.868214] rtc_cmos 00:00: rtc core: registered rtc_cmos as rtc0
[    1.868214] rtc_cmos 00:00: rtc core: registered rtc_cmos as rtc0
[    1.869322] rtc_cmos 00:00: alarms up to one day, 114 bytes nvram, hpet =
irqs
[    1.869322] rtc_cmos 00:00: alarms up to one day, 114 bytes nvram, hpet =
irqs
[    1.871308] rtc (null): invalid alarm value: 1900-1-22 0:0:0
[    1.871308] rtc (null): invalid alarm value: 1900-1-22 0:0:0
[    1.872443] rtc rtc1: test: dev (254:1)
[    1.872443] rtc rtc1: test: dev (254:1)
[    1.873283] rtc-test rtc-test.0: rtc core: registered test as rtc1
[    1.873283] rtc-test rtc-test.0: rtc core: registered test as rtc1
[    1.874386] rtc (null): invalid alarm value: 1900-1-22 0:0:0
[    1.874386] rtc (null): invalid alarm value: 1900-1-22 0:0:0
[    1.875457] rtc rtc2: test: dev (254:2)
[    1.875457] rtc rtc2: test: dev (254:2)
[    1.876093] rtc-test rtc-test.1: rtc core: registered test as rtc2
[    1.876093] rtc-test rtc-test.1: rtc core: registered test as rtc2
[    1.877645] usbcore: registered new interface driver i2c-diolan-u2c
[    1.877645] usbcore: registered new interface driver i2c-diolan-u2c
[    1.878656] i2c-parport: adapter type unspecified
[    1.878656] i2c-parport: adapter type unspecified
[    1.879449] i2c-parport-light: adapter type unspecified
[    1.879449] i2c-parport-light: adapter type unspecified
[    1.880368] usbcore: registered new interface driver RobotFuzz Open Sour=
ce InterFace, OSIF
[    1.880368] usbcore: registered new interface driver RobotFuzz Open Sour=
ce InterFace, OSIF
[    1.881762] isa i2c-pca-isa.0: Please specify I/O base
[    1.881762] isa i2c-pca-isa.0: Please specify I/O base
[    1.882700] scx200_i2c: no SCx200 gpio pins available
[    1.882700] scx200_i2c: no SCx200 gpio pins available
[    1.883969] b2c2-flexcop: B2C2 FlexcopII/II(b)/III digital TV receiver c=
hip loaded successfully
[    1.883969] b2c2-flexcop: B2C2 FlexcopII/II(b)/III digital TV receiver c=
hip loaded successfully
[    1.885442] usbcore: registered new interface driver ttusb-dec
[    1.885442] usbcore: registered new interface driver ttusb-dec
[    1.886415] usbcore: registered new interface driver ttusb
[    1.886415] usbcore: registered new interface driver ttusb
[    1.887377] usbcore: registered new interface driver dvb_usb_vp7045
[    1.887377] usbcore: registered new interface driver dvb_usb_vp7045
[    1.888495] usbcore: registered new interface driver dvb_usb_gp8psk
[    1.888495] usbcore: registered new interface driver dvb_usb_gp8psk
[    1.889523] usbcore: registered new interface driver dvb_usb_dtt200u
[    1.889523] usbcore: registered new interface driver dvb_usb_dtt200u
[    1.890570] usbcore: registered new interface driver dvb_usb_nova_t_usb2
[    1.890570] usbcore: registered new interface driver dvb_usb_nova_t_usb2
[    1.891724] usbcore: registered new interface driver dvb_usb_m920x
[    1.891724] usbcore: registered new interface driver dvb_usb_m920x
[    1.892751] usbcore: registered new interface driver dvb_usb_digitv
[    1.892751] usbcore: registered new interface driver dvb_usb_digitv
[    1.894066] usbcore: registered new interface driver dvb_usb_cxusb
[    1.894066] usbcore: registered new interface driver dvb_usb_cxusb
[    1.895098] usbcore: registered new interface driver dvb_usb_ttusb2
[    1.895098] usbcore: registered new interface driver dvb_usb_ttusb2
[    1.896210] usbcore: registered new interface driver dvb_usb_dib0700
[    1.896210] usbcore: registered new interface driver dvb_usb_dib0700
[    1.897263] usbcore: registered new interface driver opera1
[    1.897263] usbcore: registered new interface driver opera1
[    1.898184] usbcore: registered new interface driver pctv452e
[    1.898184] usbcore: registered new interface driver pctv452e
[    1.899142] usbcore: registered new interface driver dw2102
[    1.899142] usbcore: registered new interface driver dw2102
[    1.900163] usbcore: registered new interface driver cinergyT2
[    1.900163] usbcore: registered new interface driver cinergyT2
[    1.901155] usbcore: registered new interface driver dvb_usb_technisat_u=
sb2
[    1.901155] usbcore: registered new interface driver dvb_usb_technisat_u=
sb2
[    1.902276] usbcore: registered new interface driver dvb_usb_af9035
[    1.902276] usbcore: registered new interface driver dvb_usb_af9035
[    1.903301] usbcore: registered new interface driver dvb_usb_au6610
[    1.903301] usbcore: registered new interface driver dvb_usb_au6610
[    1.904431] usbcore: registered new interface driver dvb_usb_ce6230
[    1.904431] usbcore: registered new interface driver dvb_usb_ce6230
[    1.905476] usbcore: registered new interface driver dvb_usb_lmedm04
[    1.905476] usbcore: registered new interface driver dvb_usb_lmedm04
[    1.906512] usbcore: registered new interface driver dvb_usb_mxl111sf
[    1.906512] usbcore: registered new interface driver dvb_usb_mxl111sf
[    1.907689] usbcore: registered new interface driver dvb_usb_rtl28xxu
[    1.907689] usbcore: registered new interface driver dvb_usb_rtl28xxu
[    1.908981] usbcore: registered new interface driver b2c2_flexcop_usb
[    1.908981] usbcore: registered new interface driver b2c2_flexcop_usb
[    1.910477] smssdio: Siano SMS1xxx SDIO driver
[    1.910477] smssdio: Siano SMS1xxx SDIO driver
[    1.911626] smssdio: Copyright Pierre Ossman
[    1.911626] smssdio: Copyright Pierre Ossman
[    1.912531] pps pps0: new PPS source ktimer
[    1.912531] pps pps0: new PPS source ktimer
[    1.913255] pps pps0: ktimer PPS source registered
[    1.913255] pps pps0: ktimer PPS source registered
[    1.914152] Driver for 1-wire Dallas network protocol.
[    1.914152] Driver for 1-wire Dallas network protocol.
[    1.916327] usbcore: registered new interface driver DS9490R
[    1.916327] usbcore: registered new interface driver DS9490R
[    1.917658] 1-Wire driver for the DS2760 battery monitor  chip  - (c) 20=
04-2005, Szabolcs Gyurko
[    1.917658] 1-Wire driver for the DS2760 battery monitor  chip  - (c) 20=
04-2005, Szabolcs Gyurko
[    1.920592] w83781d: Detection failed at step 2
[    1.920592] w83781d: Detection failed at step 2
[    1.921580] applesmc: supported laptop not found!
[    1.921580] applesmc: supported laptop not found!
[    1.922343] applesmc: driver init failed (ret=3D-19)!
[    1.922343] applesmc: driver init failed (ret=3D-19)!
[    1.924379] pc87360: PC8736x not detected, module not inserted
[    1.924379] pc87360: PC8736x not detected, module not inserted
[    1.926137] usbcore: registered new interface driver pcwd_usb
[    1.926137] usbcore: registered new interface driver pcwd_usb
[    1.927118] acquirewdt: WDT driver for Acquire single board computer ini=
tialising
[    1.927118] acquirewdt: WDT driver for Acquire single board computer ini=
tialising
[    1.928504] acquirewdt: I/O address 0x0043 already in use
[    1.928504] acquirewdt: I/O address 0x0043 already in use
[    1.929397] acquirewdt: probe of acquirewdt failed with error -5
[    1.929397] acquirewdt: probe of acquirewdt failed with error -5
[    1.930413] advantechwdt: WDT driver for Advantech single board computer=
 initialising
[    1.930413] advantechwdt: WDT driver for Advantech single board computer=
 initialising
[    1.931891] advantechwdt: initialized. timeout=3D60 sec (nowayout=3D0)
[    1.931891] advantechwdt: initialized. timeout=3D60 sec (nowayout=3D0)
[    1.932904] alim7101_wdt: Steve Hill <steve@navaho.co.uk>
[    1.932904] alim7101_wdt: Steve Hill <steve@navaho.co.uk>
[    1.933783] alim7101_wdt: ALi M7101 PMU not present - WDT not set
[    1.933783] alim7101_wdt: ALi M7101 PMU not present - WDT not set
[    1.934769] sp5100_tco: SP5100/SB800 TCO WatchDog Timer Driver v0.05
[    1.934769] sp5100_tco: SP5100/SB800 TCO WatchDog Timer Driver v0.05
[    1.936068] i6300esb: Intel 6300ESB WatchDog Timer Driver v0.05
[    1.936068] i6300esb: Intel 6300ESB WatchDog Timer Driver v0.05
[    1.937146] i6300esb: cannot register miscdev on minor=3D130 (err=3D-16)
[    1.937146] i6300esb: cannot register miscdev on minor=3D130 (err=3D-16)
[    1.938185] i6300ESB timer: probe of 0000:00:0a.0 failed with error -16
[    1.938185] i6300ESB timer: probe of 0000:00:0a.0 failed with error -16
[    1.939261] iTCO_wdt: Intel TCO WatchDog Timer Driver v1.11
[    1.939261] iTCO_wdt: Intel TCO WatchDog Timer Driver v1.11
[    1.940298] iTCO_vendor_support: vendor-support=3D0
[    1.940298] iTCO_vendor_support: vendor-support=3D0
[    1.941117] it87_wdt: no device
[    1.941117] it87_wdt: no device
[    1.941655] sc1200wdt: build 20020303
[    1.941655] sc1200wdt: build 20020303
[    1.942274] sc1200wdt: io parameter must be specified
[    1.942274] sc1200wdt: io parameter must be specified
[    1.943104] pc87413_wdt: Version 1.1 at io 0x2E
[    1.943104] pc87413_wdt: Version 1.1 at io 0x2E
[    1.943951] pc87413_wdt: cannot register miscdev on minor=3D130 (err=3D-=
16)
[    1.943951] pc87413_wdt: cannot register miscdev on minor=3D130 (err=3D-=
16)
[    1.945004] nv_tco: NV TCO WatchDog Timer Driver v0.01
[    1.945004] nv_tco: NV TCO WatchDog Timer Driver v0.01
[    1.945954] sbc8360: failed to register misc device
[    1.945954] sbc8360: failed to register misc device
[    1.946739] sbc7240_wdt: I/O address 0x0443 already in use
[    1.946739] sbc7240_wdt: I/O address 0x0443 already in use
[    1.947746] cpu5wdt: misc_register failed
[    1.947746] cpu5wdt: misc_register failed
[    1.948469] w83877f_wdt: I/O address 0x0443 already in use
[    1.948469] w83877f_wdt: I/O address 0x0443 already in use
[    1.949347] machzwd: MachZ ZF-Logic Watchdog driver initializing
[    1.949347] machzwd: MachZ ZF-Logic Watchdog driver initializing
[    1.950297] machzwd: no ZF-Logic found
[    1.950297] machzwd: no ZF-Logic found
[    1.951057] watchdog: Software Watchdog: cannot register miscdev on mino=
r=3D130 (err=3D-16).
[    1.951057] watchdog: Software Watchdog: cannot register miscdev on mino=
r=3D130 (err=3D-16).
[    1.952434] watchdog: Software Watchdog: a legacy watchdog module is pro=
bably present.
[    1.952434] watchdog: Software Watchdog: a legacy watchdog module is pro=
bably present.
[    1.953777] softdog: Software Watchdog Timer: 0.08 initialized. soft_nob=
oot=3D0 soft_margin=3D60 sec soft_panic=3D0 (nowayout=3D0)
[    1.953777] softdog: Software Watchdog Timer: 0.08 initialized. soft_nob=
oot=3D0 soft_margin=3D60 sec soft_panic=3D0 (nowayout=3D0)
[    1.956144] platform eisa.0: Probing EISA bus 0
[    1.956144] platform eisa.0: Probing EISA bus 0
[    1.956891] platform eisa.0: EISA: Cannot allocate resource for mainboard
[    1.956891] platform eisa.0: EISA: Cannot allocate resource for mainboard
[    1.957973] platform eisa.0: Cannot allocate resource for EISA slot 1
[    1.957973] platform eisa.0: Cannot allocate resource for EISA slot 1
[    1.958994] platform eisa.0: Cannot allocate resource for EISA slot 2
[    1.958994] platform eisa.0: Cannot allocate resource for EISA slot 2
[    1.960060] platform eisa.0: Cannot allocate resource for EISA slot 3
[    1.960060] platform eisa.0: Cannot allocate resource for EISA slot 3
[    1.961077] platform eisa.0: Cannot allocate resource for EISA slot 4
[    1.961077] platform eisa.0: Cannot allocate resource for EISA slot 4
[    1.962093] platform eisa.0: Cannot allocate resource for EISA slot 5
[    1.962093] platform eisa.0: Cannot allocate resource for EISA slot 5
[    1.963101] platform eisa.0: Cannot allocate resource for EISA slot 6
[    1.963101] platform eisa.0: Cannot allocate resource for EISA slot 6
[    1.964222] platform eisa.0: Cannot allocate resource for EISA slot 7
[    1.964222] platform eisa.0: Cannot allocate resource for EISA slot 7
[    1.965242] platform eisa.0: Cannot allocate resource for EISA slot 8
[    1.965242] platform eisa.0: Cannot allocate resource for EISA slot 8
[    1.966260] platform eisa.0: EISA: Detected 0 cards
[    1.966260] platform eisa.0: EISA: Detected 0 cards
[    1.967098] sdhci: Secure Digital Host Controller Interface driver
[    1.967098] sdhci: Secure Digital Host Controller Interface driver
[    1.968178] sdhci: Copyright(c) Pierre Ossman
[    1.968178] sdhci: Copyright(c) Pierre Ossman
[    1.968971] VUB300 Driver rom wait states =3D 1C irqpoll timeout =3D 0400
[    1.968971] VUB300 Driver rom wait states =3D 1C irqpoll timeout =3D 0400

[    1.970200] usbcore: registered new interface driver vub300
[    1.970200] usbcore: registered new interface driver vub300
[    1.971156] usbcore: registered new interface driver ushc
[    1.971156] usbcore: registered new interface driver ushc
[    1.972205] sdhci-pltfm: SDHCI platform and OF driver helper
[    1.972205] sdhci-pltfm: SDHCI platform and OF driver helper
[    1.973541] ledtrig-cpu: registered to indicate activity on CPUs
[    1.973541] ledtrig-cpu: registered to indicate activity on CPUs
[    1.974657] dcdbas dcdbas: Dell Systems Management Base Driver (version =
5.6.0-3.2)
[    1.974657] dcdbas dcdbas: Dell Systems Management Base Driver (version =
5.6.0-3.2)
[    1.976046] Driver for HIFN 795x crypto accelerator chip has been succes=
sfully registered.
[    1.976046] Driver for HIFN 795x crypto accelerator chip has been succes=
sfully registered.
[    1.977402] hidraw: raw HID events driver (C) Jiri Kosina
[    1.977402] hidraw: raw HID events driver (C) Jiri Kosina
[    1.979832] usbcore: registered new interface driver usbhid
[    1.979832] usbcore: registered new interface driver usbhid
[    1.980728] usbhid: USB HID core driver
[    1.980728] usbhid: USB HID core driver
[    1.982856]  fake-fmc-carrier: mezzanine 0
[    1.982856]  fake-fmc-carrier: mezzanine 0
[    1.983620]       Manufacturer: fake-vendor
[    1.983620]       Manufacturer: fake-vendor
[    1.984311]       Product name: fake-design-for-testing
[    1.984311]       Product name: fake-design-for-testing
[    1.985200] fmc fake-design-for-testing-f001: Driver has no ID: matches =
all
[    1.985200] fmc fake-design-for-testing-f001: Driver has no ID: matches =
all
[    1.986308] fmc_trivial: probe of fake-design-for-testing-f001 failed wi=
th error -95
[    1.986308] fmc_trivial: probe of fake-design-for-testing-f001 failed wi=
th error -95
[    1.987680] fmc fake-design-for-testing-f001: Driver has no ID: matches =
all
[    1.987680] fmc fake-design-for-testing-f001: Driver has no ID: matches =
all
[    1.988794] fmc_write_eeprom fake-design-for-testing-f001: fmc_write_eep=
rom: no busid passed, refusing all cards
[    1.988794] fmc_write_eeprom fake-design-for-testing-f001: fmc_write_eep=
rom: no busid passed, refusing all cards
[    1.990479] intel_rapl: driver does not support CPU family 15 model 6
[    1.990479] intel_rapl: driver does not support CPU family 15 model 6
[    1.992125]=20
[    1.992125] printing PIC contents
[    1.992125]=20
[    1.992125] printing PIC contents
[    1.992885] ... PIC  IMR: ffff
[    1.992885] ... PIC  IMR: ffff
[    1.992910] ... PIC  IRR: 1113
[    1.992910] ... PIC  IRR: 1113
[    1.993868] ... PIC  ISR: 0000
[    1.993868] ... PIC  ISR: 0000
[    1.994361] ... PIC ELCR: 0c00
[    1.994361] ... PIC ELCR: 0c00
[    1.994845] printing local APIC contents on CPU#0/0:
[    1.994845] printing local APIC contents on CPU#0/0:
[    1.995352] ... APIC ID:      00000000 (0)
[    1.995352] ... APIC ID:      00000000 (0)
[    1.995352] ... APIC VERSION: 00050014
[    1.995352] ... APIC VERSION: 00050014
[    1.995352] ... APIC TASKPRI: 00000000 (00)
[    1.995352] ... APIC TASKPRI: 00000000 (00)
[    1.995352] ... APIC PROCPRI: 00000000
[    1.995352] ... APIC PROCPRI: 00000000
[    1.995352] ... APIC LDR: 01000000
[    1.995352] ... APIC LDR: 01000000
[    1.995352] ... APIC DFR: ffffffff
[    1.995352] ... APIC DFR: ffffffff
[    1.995352] ... APIC SPIV: 000001ff
[    1.995352] ... APIC SPIV: 000001ff
[    1.995352] ... APIC ISR field:
[    1.995352] ... APIC ISR field:
[    1.995352] 00000000
[    1.995352] 000000000000000000000000000000000000000000000000000000000000=
000000000000000000000000000000000000000000000000000000000000

[    1.995352] ... APIC TMR field:
[    1.995352] ... APIC TMR field:
[    1.995352] 00000000
[    1.995352] 000000000200000002000000000000000000000000000000000000000000=
000000000000000000000000000000000000000000000000000000000000

[    1.995352] ... APIC IRR field:
[    1.995352] ... APIC IRR field:
[    1.995352] 00000000
[    1.995352] 000000000000000000000000000000000000000000000000000000000000=
000000000000000000000000000000000000000000000000800000008000

[    1.995352] ... APIC ESR: 00000000
[    1.995352] ... APIC ESR: 00000000
[    1.995352] ... APIC ICR: 00000831
[    1.995352] ... APIC ICR: 00000831
[    1.995352] ... APIC ICR2: 01000000
[    1.995352] ... APIC ICR2: 01000000
[    1.995352] ... APIC LVTT: 000200ef
[    1.995352] ... APIC LVTT: 000200ef
[    1.995352] ... APIC LVTPC: 00010000
[    1.995352] ... APIC LVTPC: 00010000
[    1.995352] ... APIC LVT0: 00010700
[    1.995352] ... APIC LVT0: 00010700
[    1.995352] ... APIC LVT1: 00000400
[    1.995352] ... APIC LVT1: 00000400
[    1.995352] ... APIC LVTERR: 000000fe
[    1.995352] ... APIC LVTERR: 000000fe
[    1.995352] ... APIC TMICT: 0000f420
[    1.995352] ... APIC TMICT: 0000f420
[    1.995352] ... APIC TMCCT: 000092db
[    1.995352] ... APIC TMCCT: 000092db
[    1.995352] ... APIC TDCR: 00000003
[    1.995352] ... APIC TDCR: 00000003
[    1.995352]=20
[    1.995352]=20
[    2.011777] number of MP IRQ sources: 15.
[    2.011777] number of MP IRQ sources: 15.
[    2.012409] number of IO-APIC #0 registers: 24.
[    2.012409] number of IO-APIC #0 registers: 24.
[    2.013123] testing the IO APIC.......................
[    2.013123] testing the IO APIC.......................
[    2.013945] IO APIC #0......
[    2.013945] IO APIC #0......
[    2.014392] .... register #00: 00000000
[    2.014392] .... register #00: 00000000
[    2.014995] .......    : physical APIC id: 00
[    2.014995] .......    : physical APIC id: 00
[    2.015794] .......    : Delivery Type: 0
[    2.015794] .......    : Delivery Type: 0
[    2.016428] .......    : LTS          : 0
[    2.016428] .......    : LTS          : 0
[    2.017104] .... register #01: 00170011
[    2.017104] .... register #01: 00170011
[    2.017698] .......     : max redirection entries: 17
[    2.017698] .......     : max redirection entries: 17
[    2.018485] .......     : PRQ implemented: 0
[    2.018485] .......     : PRQ implemented: 0
[    2.019153] .......     : IO APIC version: 11
[    2.019153] .......     : IO APIC version: 11
[    2.019888] .... register #02: 00000000
[    2.019888] .... register #02: 00000000
[    2.020495] .......     : arbitration: 00
[    2.020495] .......     : arbitration: 00
[    2.021132] .... IRQ redirection table:
[    2.021132] .... IRQ redirection table:
[    2.021736] 1    0    0   0   0    0    0    00
[    2.021736] 1    0    0   0   0    0    0    00
[    2.022454] 0    0    0   0   0    1    1    31
[    2.022454] 0    0    0   0   0    1    1    31
[    2.023175] 0    0    0   0   0    1    1    30
[    2.023175] 0    0    0   0   0    1    1    30
[    2.023947] 0    0    0   0   0    1    1    33
[    2.023947] 0    0    0   0   0    1    1    33
[    2.024660] 1    0    0   0   0    1    1    34
[    2.024660] 1    0    0   0   0    1    1    34
[    2.025379] 1    1    0   0   0    1    1    35
[    2.025379] 1    1    0   0   0    1    1    35
[    2.026101] 0    0    0   0   0    1    1    36
[    2.026101] 0    0    0   0   0    1    1    36
[    2.026813] 0    0    0   0   0    1    1    37
[    2.026813] 0    0    0   0   0    1    1    37
[    2.027633] 0    0    0   0   0    1    1    38
[    2.027633] 0    0    0   0   0    1    1    38
[    2.028360] 0    1    0   0   0    1    1    39
[    2.028360] 0    1    0   0   0    1    1    39
[    2.029083] 1    1    0   0   0    1    1    3A
[    2.029083] 1    1    0   0   0    1    1    3A
[    2.029796] 1    1    0   0   0    1    1    3B
[    2.029796] 1    1    0   0   0    1    1    3B
[    2.030518] 0    0    0   0   0    1    1    3C
[    2.030518] 0    0    0   0   0    1    1    3C
[    2.031245] 0    0    0   0   0    1    1    3D
[    2.031245] 0    0    0   0   0    1    1    3D
[    2.032031] 0    0    0   0   0    1    1    3E
[    2.032031] 0    0    0   0   0    1    1    3E
[    2.032743] 0    0    0   0   0    1    1    3F
[    2.032743] 0    0    0   0   0    1    1    3F
[    2.033460] 1    0    0   0   0    0    0    00
[    2.033460] 1    0    0   0   0    0    0    00
[    2.034181] 1    0    0   0   0    0    0    00
[    2.034181] 1    0    0   0   0    0    0    00
[    2.034886] 1    0    0   0   0    0    0    00
[    2.034886] 1    0    0   0   0    0    0    00
[    2.035714] 1    0    0   0   0    0    0    00
[    2.035714] 1    0    0   0   0    0    0    00
[    2.036434] 1    0    0   0   0    0    0    00
[    2.036434] 1    0    0   0   0    0    0    00
[    2.037161] 1    0    0   0   0    0    0    00
[    2.037161] 1    0    0   0   0    0    0    00
[    2.037873] 1    0    0   0   0    0    0    00
[    2.037873] 1    0    0   0   0    0    0    00
[    2.038600] 1    0    0   0   0    0    0    00
[    2.038600] 1    0    0   0   0    0    0    00
[    2.039313] IRQ to pin mappings:
[    2.039313] IRQ to pin mappings:
[    2.039889] IRQ0=20
[    2.039889] IRQ0 -> 0:2-> 0:2

[    2.040311] IRQ1=20
[    2.040311] IRQ1 -> 0:1-> 0:1

[    2.040723] IRQ3=20
[    2.040723] IRQ3 -> 0:3-> 0:3

[    2.041141] IRQ4=20
[    2.041141] IRQ4 -> 0:4-> 0:4

[    2.041545] IRQ5=20
[    2.041545] IRQ5 -> 0:5-> 0:5

[    2.041967] IRQ6=20
[    2.041967] IRQ6 -> 0:6-> 0:6

[    2.042372] IRQ7=20
[    2.042372] IRQ7 -> 0:7-> 0:7

[    2.042782] IRQ8=20
[    2.042782] IRQ8 -> 0:8-> 0:8

[    2.043200] IRQ9=20
[    2.043200] IRQ9 -> 0:9-> 0:9

[    2.043659] IRQ10=20
[    2.043659] IRQ10 -> 0:10-> 0:10

[    2.044103] IRQ11=20
[    2.044103] IRQ11 -> 0:11-> 0:11

[    2.044533] IRQ12=20
[    2.044533] IRQ12 -> 0:12-> 0:12

[    2.044983] IRQ13=20
[    2.044983] IRQ13 -> 0:13-> 0:13

[    2.045418] IRQ14=20
[    2.045418] IRQ14 -> 0:14-> 0:14

[    2.045854] IRQ15=20
[    2.045854] IRQ15 -> 0:15-> 0:15

[    2.046297] .................................... done.
[    2.046297] .................................... done.
[    2.047120] Using IPI Shortcut mode
[    2.047120] Using IPI Shortcut mode
[    2.048067] bootconsole [earlyser0] disabled
[    2.048067] bootconsole [earlyser0] disabled
[    2.049297] Key type trusted registered
[    2.049965] Key type encrypted registered
[    2.050411] ima: No TPM chip found, activating TPM-bypass!
[    2.051046] evm: HMAC attrs: 0x0
[    2.052107]   Magic number: 6:816:401
[    2.052566] BIOS EDD facility v0.16 2004-Jun-25, 0 devices found
[    2.053071] EDD information not available.
[    2.054083] debug: unmapping init [mem 0xb48be000-0xb490ffff]
[    2.054646] Write protecting the kernel text: 6640k
[    2.055106] Write protecting the kernel read-only data: 4012k
[    2.056047] BUG: unable to handle kernel NULL pointer dereference at 000=
00104
[    2.056648] IP: [<b3c81d3e>] get_unmapped_area+0x40/0xef
[    2.056905] *pde =3D 00000000=20
[    2.056905] Oops: 0000 [#1] DEBUG_PAGEALLOC
[    2.056905] CPU: 0 PID: 1 Comm: init Not tainted 3.16.0-rc5-00231-gbc2d5=
10 #2
[    2.056905] task: b0030010 ti: b0032000 task.ti: b0032000
[    2.056905] EIP: 0060:[<b3c81d3e>] EFLAGS: 00010246 CPU: 0
[    2.056905] EIP is at get_unmapped_area+0x40/0xef
[    2.056905] EAX: c290ddc0 EBX: 00000000 ECX: 00003000 EDX: 00000000
[    2.056905] ESI: b427f198 EDI: b3c81ed4 EBP: b0033eac ESP: b0033e98
[    2.056905]  DS: 007b ES: 007b FS: 0000 GS: 0000 SS: 0068
[    2.056905] CR0: 8005003b CR2: 00000104 CR3: 12916000 CR4: 00000690
[    2.056905] Stack:
[    2.056905]  00000000 00003000 47e77cc0 b427f198 b0030010 b0033ed0 b3c1b=
ff5 00000000
[    2.056905]  00000000 c290de1c c290ddc0 47e77cc0 47e767c8 c2901800 b0033=
f50 b3cb5d6c
[    2.056905]  b0032000 00002000 00000006 0001d000 00000000 00000001 47e77=
cc0 0804fad4
[    2.056905] Call Trace:
[    2.056905]  [<b3c1bff5>] arch_setup_additional_pages+0x4e/0x188
[    2.056905]  [<b3cb5d6c>] load_elf_binary+0x9c5/0xff7
[    2.056905]  [<b3c95585>] search_binary_handler+0x41/0x95
[    2.056905]  [<b3c95955>] do_execve+0x37c/0x48a
[    2.056905]  [<b3c0035c>] run_init_process+0x1c/0x1e
[    2.056905]  [<b426a586>] kernel_init+0x34/0xb8
[    2.056905]  [<b427a7c0>] ret_from_kernel_thread+0x20/0x30
[    2.056905]  [<b426a552>] ? rest_init+0x10e/0x10e
[    2.056905] Code: 76 0a be f4 ff ff ff e9 c4 00 00 00 89 c3 a1 20 a9 67 =
b4 8b 80 10 02 00 00 85 db 8b 78 0c 74 0b 8b 43 14 8b 40 58 85 c0 0f 45 f8 =
<8b> b3 04 01 00 00 85 f6 74 54 83 c6 14 31 c9 8d 41 01 89 c2 89
[    2.056905] EIP: [<b3c81d3e>] get_unmapped_area+0x40/0xef SS:ESP 0068:b0=
033e98
[    2.056905] CR2: 0000000000000104
[    2.070596] ---[ end trace 10ed763858844c61 ]---
[    2.070973] Kernel panic - not syncing: Fatal exception
[    2.071431] Kernel Offset: 0x2c00000 from 0xb1000000 (relocation range: =
0xb0000000-0xc47fdfff)
[    2.071970] Rebooting in 10 seconds..
Elapsed time: 5
qemu-system-x86_64 -cpu kvm64 -enable-kvm -kernel /kernel/i386-randconfig-r=
2-0722/bc2d5105254034778034487d8f3aec42db2a5285/vmlinuz-3.16.0-rc5-00231-gb=
c2d510 -append 'hung_task_panic=3D1 earlyprintk=3DttyS0,115200 debug apic=
=3Ddebug sysrq_always_enabled rcupdate.rcu_cpu_stall_timeout=3D100 panic=3D=
10 softlockup_panic=3D1 nmi_watchdog=3Dpanic  prompt_ramdisk=3D0 console=3D=
ttyS0,115200 console=3Dtty0 vga=3Dnormal  root=3D/dev/ram0 rw link=3D/kbuil=
d-tests/run-queue/kvm/i386-randconfig-r2-0722/linux-devel:devel-roam-i386-2=
01407222107:bc2d5105254034778034487d8f3aec42db2a5285:bisect-linux-8/.vmlinu=
z-bc2d5105254034778034487d8f3aec42db2a5285-20140722222240-21-vp branch=3Dli=
nux-devel/devel-roam-i386-201407222107 BOOT_IMAGE=3D/kernel/i386-randconfig=
-r2-0722/bc2d5105254034778034487d8f3aec42db2a5285/vmlinuz-3.16.0-rc5-00231-=
gbc2d510 drbd.minor_count=3D8'  -initrd /kernel-tests/initrd/yocto-minimal-=
i386.cgz -m 320 -smp 1 -net nic,vlan=3D1,model=3De1000 -net user,vlan=3D1 -=
boot order=3Dnc -no-reboot -watchdog i6300esb -rtc base=3Dlocaltime -drive =
file=3D/fs/LABEL=3DKVM/disk0-yocto-vp-8,media=3Ddisk,if=3Dvirtio -drive fil=
e=3D/fs/LABEL=3DKVM/disk1-yocto-vp-8,media=3Ddisk,if=3Dvirtio -drive file=
=3D/fs/LABEL=3DKVM/disk2-yocto-vp-8,media=3Ddisk,if=3Dvirtio -drive file=3D=
/fs/LABEL=3DKVM/disk3-yocto-vp-8,media=3Ddisk,if=3Dvirtio -drive file=3D/fs=
/LABEL=3DKVM/disk4-yocto-vp-8,media=3Ddisk,if=3Dvirtio -drive file=3D/fs/LA=
BEL=3DKVM/disk5-yocto-vp-8,media=3Ddisk,if=3Dvirtio -pidfile /dev/shm/kboot=
/pid-yocto-vp-8 -serial file:/dev/shm/kboot/serial-yocto-vp-8 -daemonize -d=
isplay none -monitor null=20

--Ah40dssYA/cDqAW1
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="dmesg-quantal-ivb41-121:20140722222354:i386-randconfig-r2-0722::"
Content-Transfer-Encoding: quoted-printable

early console in setup code
early console in decompress_kernel
KASLR using RDTSC...

Decompressing Linux... Parsing ELF... Performing relocations... done.
Booting the kernel.
[    0.000000] Initializing cgroup subsys cpu
[    0.000000] Linux version 3.16.0-rc5-00230-g47702c7 (kbuild@jaketown) (g=
cc version 4.8.2 (Debian 4.8.2-18) ) #1 Tue Jul 22 22:07:51 CST 2014
[    0.000000] KERNEL supported cpus:
[    0.000000]   NSC Geode by NSC
[    0.000000]   Cyrix CyrixInstead
[    0.000000]   Centaur CentaurHauls
[    0.000000] CPU: vendor_id 'GenuineIntel' unknown, using generic init.
[    0.000000] CPU: Your system may be unstable.
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
[    0.000000] Scan for SMP in [mem 0x00000000-0x000003ff]
[    0.000000] Scan for SMP in [mem 0x0009fc00-0x0009ffff]
[    0.000000] Scan for SMP in [mem 0x000f0000-0x000fffff]
[    0.000000] found SMP MP-table at [mem 0x000f0eb0-0x000f0ebf] mapped at =
[b00f0eb0]
[    0.000000]   mpc: f0ec0-f0fa4
[    0.000000] Scanning 1 areas for low memory corruption
[    0.000000] initial memory mapped: [mem 0x00000000-0x12bfffff]
[    0.000000] Base memory trampoline at [b009b000] 9b000 size 16384
[    0.000000] init_memory_mapping: [mem 0x00000000-0x000fffff]
[    0.000000]  [mem 0x00000000-0x000fffff] page 4k
[    0.000000] init_memory_mapping: [mem 0x11000000-0x113fffff]
[    0.000000]  [mem 0x11000000-0x113fffff] page 4k
[    0.000000] init_memory_mapping: [mem 0x10000000-0x10ffffff]
[    0.000000]  [mem 0x10000000-0x10ffffff] page 4k
[    0.000000] init_memory_mapping: [mem 0x00100000-0x0fffffff]
[    0.000000]  [mem 0x00100000-0x0fffffff] page 4k
[    0.000000] init_memory_mapping: [mem 0x11400000-0x13ffdfff]
[    0.000000]  [mem 0x11400000-0x13ffdfff] page 4k
[    0.000000] RAMDISK: [mem 0x127ab000-0x13feffff]
[    0.000000] ACPI: Early table checksum verification disabled
[    0.000000] ACPI: RSDP 0x000F0D00 000014 (v00 BOCHS )
[    0.000000] ACPI: RSDT 0x13FFFC2A 000034 (v01 BOCHS  BXPCRSDT 00000001 B=
XPC 00000001)
[    0.000000] ACPI: FACP 0x13FFF1C0 000074 (v01 BOCHS  BXPCFACP 00000001 B=
XPC 00000001)
[    0.000000] ACPI: DSDT 0x13FFE040 001180 (v01 BOCHS  BXPCDSDT 00000001 B=
XPC 00000001)
[    0.000000] ACPI: FACS 0x13FFE000 000040
[    0.000000] ACPI: SSDT 0x13FFF234 00093E (v01 BOCHS  BXPCSSDT 00000001 B=
XPC 00000001)
[    0.000000] ACPI: APIC 0x13FFFB72 000080 (v01 BOCHS  BXPCAPIC 00000001 B=
XPC 00000001)
[    0.000000] ACPI: HPET 0x13FFFBF2 000038 (v01 BOCHS  BXPCHPET 00000001 B=
XPC 00000001)
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] mapped APIC to         ffffc000 (        fee00000)
[    0.000000] 319MB LOWMEM available.
[    0.000000]   mapped low ram: 0 - 13ffe000
[    0.000000]   low ram: 0 - 13ffe000
[    0.000000] kvm-clock: Using msrs 4b564d01 and 4b564d00
[    0.000000] kvm-clock: cpu 0, msr 0:13ffd001, primary cpu clock
[    0.000000] Zone ranges:
[    0.000000]   Normal   [mem 0x00001000-0x13ffdfff]
[    0.000000] Movable zone start for each node
[    0.000000] Early memory node ranges
[    0.000000]   node   0: [mem 0x00001000-0x0009efff]
[    0.000000]   node   0: [mem 0x00100000-0x13ffdfff]
[    0.000000] On node 0 totalpages: 81820
[    0.000000] free_area_init_node: node 0, pgdat c20a0884, node_mem_map c1=
12b024
[    0.000000]   Normal zone: 720 pages used for memmap
[    0.000000]   Normal zone: 0 pages reserved
[    0.000000]   Normal zone: 81820 pages, LIFO batch:15
[    0.000000] Using APIC driver default
[    0.000000] ACPI: PM-Timer IO Port: 0x608
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] mapped APIC to         ffffc000 (        fee00000)
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
[    0.000000] mapped IOAPIC to ffffb000 (fec00000)
[    0.000000] nr_irqs_gsi: 40
[    0.000000] KVM setup async PF for cpu 0
[    0.000000] kvm-stealtime: cpu 0, msr 11e7a280
[    0.000000] e820: [mem 0x14000000-0xfeffbfff] available for PCI devices
[    0.000000] Booting paravirtualized kernel on KVM
[    0.000000] pcpu-alloc: s0 r0 d32768 u32768 alloc=3D1*32768
[    0.000000] pcpu-alloc: [0] 0=20
[    0.000000] Built 1 zonelists in Zone order, mobility grouping on.  Tota=
l pages: 81100
[    0.000000] Kernel command line: hung_task_panic=3D1 earlyprintk=3DttyS0=
,115200 debug apic=3Ddebug sysrq_always_enabled rcupdate.rcu_cpu_stall_time=
out=3D100 panic=3D10 softlockup_panic=3D1 nmi_watchdog=3Dpanic  prompt_ramd=
isk=3D0 console=3DttyS0,115200 console=3Dtty0 vga=3Dnormal  root=3D/dev/ram=
0 rw link=3D/kbuild-tests/run-queue/kvm/i386-randconfig-r2-0722/linux-devel=
:devel-roam-i386-201407222107:47702c7c4c9c1e8514ca52e367cf0b71e50177f8:bise=
ct-linux-8/.vmlinuz-47702c7c4c9c1e8514ca52e367cf0b71e50177f8-20140722222355=
-37-ivb41 branch=3Dlinux-devel/devel-roam-i386-201407222107 BOOT_IMAGE=3D/k=
ernel/i386-randconfig-r2-0722/47702c7c4c9c1e8514ca52e367cf0b71e50177f8/vmli=
nuz-3.16.0-rc5-00230-g47702c7 drbd.minor_count=3D8
[    0.000000] sysrq: sysrq always enabled.
[    0.000000] PID hash table entries: 2048 (order: 1, 8192 bytes)
[    0.000000] Dentry cache hash table entries: 65536 (order: 6, 262144 byt=
es)
[    0.000000] Inode-cache hash table entries: 32768 (order: 5, 131072 byte=
s)
[    0.000000] Initializing CPU#0
[    0.000000] Memory: 278852K/327280K available (6632K kernel code, 2384K =
rwdata, 4008K rodata, 328K init, 8188K bss, 48428K reserved)
[    0.000000] virtual kernel memory layout:
[    0.000000]     fixmap  : 0xfffa3000 - 0xfffff000   ( 368 kB)
[    0.000000]     vmalloc : 0xc47fe000 - 0xfffa1000   ( 951 MB)
[    0.000000]     lowmem  : 0xb0000000 - 0xc3ffe000   ( 319 MB)
[    0.000000]       .init : 0xc20bc000 - 0xc210e000   ( 328 kB)
[    0.000000]       .data : 0xc1a7a38c - 0xc20ba000   (6399 kB)
[    0.000000]       .text : 0xc1400000 - 0xc1a7a38c   (6632 kB)
[    0.000000] Checking if this processor honours the WP bit even in superv=
isor mode...Ok.
[    0.000000] NR_IRQS:2304 nr_irqs:256 16
[    0.000000] CPU 0 irqstacks, hard=3Db0094000 soft=3Db0096000
[    0.000000] Initializing cgroup subsys cpu
[    0.000000] Linux version 3.16.0-rc5-00230-g47702c7 (kbuild@jaketown) (g=
cc version 4.8.2 (Debian 4.8.2-18) ) #1 Tue Jul 22 22:07:51 CST 2014
[    0.000000] KERNEL supported cpus:
[    0.000000]   NSC Geode by NSC
[    0.000000]   Cyrix CyrixInstead
[    0.000000]   Centaur CentaurHauls
[    0.000000] CPU: vendor_id 'GenuineIntel' unknown, using generic init.
[    0.000000] CPU: Your system may be unstable.
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
[    0.000000] Scan for SMP in [mem 0x00000000-0x000003ff]
[    0.000000] Scan for SMP in [mem 0x0009fc00-0x0009ffff]
[    0.000000] Scan for SMP in [mem 0x000f0000-0x000fffff]
[    0.000000] found SMP MP-table at [mem 0x000f0eb0-0x000f0ebf] mapped at =
[b00f0eb0]
[    0.000000]   mpc: f0ec0-f0fa4
[    0.000000] Scanning 1 areas for low memory corruption
[    0.000000] initial memory mapped: [mem 0x00000000-0x12bfffff]
[    0.000000] Base memory trampoline at [b009b000] 9b000 size 16384
[    0.000000] init_memory_mapping: [mem 0x00000000-0x000fffff]
[    0.000000]  [mem 0x00000000-0x000fffff] page 4k
[    0.000000] init_memory_mapping: [mem 0x11000000-0x113fffff]
[    0.000000]  [mem 0x11000000-0x113fffff] page 4k
[    0.000000] init_memory_mapping: [mem 0x10000000-0x10ffffff]
[    0.000000]  [mem 0x10000000-0x10ffffff] page 4k
[    0.000000] init_memory_mapping: [mem 0x00100000-0x0fffffff]
[    0.000000]  [mem 0x00100000-0x0fffffff] page 4k
[    0.000000] init_memory_mapping: [mem 0x11400000-0x13ffdfff]
[    0.000000]  [mem 0x11400000-0x13ffdfff] page 4k
[    0.000000] RAMDISK: [mem 0x127ab000-0x13feffff]
[    0.000000] ACPI: Early table checksum verification disabled
[    0.000000] ACPI: RSDP 0x000F0D00 000014 (v00 BOCHS )
[    0.000000] ACPI: RSDT 0x13FFFC2A 000034 (v01 BOCHS  BXPCRSDT 00000001 B=
XPC 00000001)
[    0.000000] ACPI: FACP 0x13FFF1C0 000074 (v01 BOCHS  BXPCFACP 00000001 B=
XPC 00000001)
[    0.000000] ACPI: DSDT 0x13FFE040 001180 (v01 BOCHS  BXPCDSDT 00000001 B=
XPC 00000001)
[    0.000000] ACPI: FACS 0x13FFE000 000040
[    0.000000] ACPI: SSDT 0x13FFF234 00093E (v01 BOCHS  BXPCSSDT 00000001 B=
XPC 00000001)
[    0.000000] ACPI: APIC 0x13FFFB72 000080 (v01 BOCHS  BXPCAPIC 00000001 B=
XPC 00000001)
[    0.000000] ACPI: HPET 0x13FFFBF2 000038 (v01 BOCHS  BXPCHPET 00000001 B=
XPC 00000001)
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] mapped APIC to         ffffc000 (        fee00000)
[    0.000000] 319MB LOWMEM available.
[    0.000000]   mapped low ram: 0 - 13ffe000
[    0.000000]   low ram: 0 - 13ffe000
[    0.000000] kvm-clock: Using msrs 4b564d01 and 4b564d00
[    0.000000] kvm-clock: cpu 0, msr 0:13ffd001, primary cpu clock
[    0.000000] Zone ranges:
[    0.000000]   Normal   [mem 0x00001000-0x13ffdfff]
[    0.000000] Movable zone start for each node
[    0.000000] Early memory node ranges
[    0.000000]   node   0: [mem 0x00001000-0x0009efff]
[    0.000000]   node   0: [mem 0x00100000-0x13ffdfff]
[    0.000000] On node 0 totalpages: 81820
[    0.000000] free_area_init_node: node 0, pgdat c20a0884, node_mem_map c1=
12b024
[    0.000000]   Normal zone: 720 pages used for memmap
[    0.000000]   Normal zone: 0 pages reserved
[    0.000000]   Normal zone: 81820 pages, LIFO batch:15
[    0.000000] Using APIC driver default
[    0.000000] ACPI: PM-Timer IO Port: 0x608
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] mapped APIC to         ffffc000 (        fee00000)
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
[    0.000000] mapped IOAPIC to ffffb000 (fec00000)
[    0.000000] nr_irqs_gsi: 40
[    0.000000] KVM setup async PF for cpu 0
[    0.000000] kvm-stealtime: cpu 0, msr 11e7a280
[    0.000000] e820: [mem 0x14000000-0xfeffbfff] available for PCI devices
[    0.000000] Booting paravirtualized kernel on KVM
[    0.000000] pcpu-alloc: s0 r0 d32768 u32768 alloc=3D1*32768
[    0.000000] pcpu-alloc: [0] 0=20
[    0.000000] Built 1 zonelists in Zone order, mobility grouping on.  Tota=
l pages: 81100
[    0.000000] Kernel command line: hung_task_panic=3D1 earlyprintk=3DttyS0=
,115200 debug apic=3Ddebug sysrq_always_enabled rcupdate.rcu_cpu_stall_time=
out=3D100 panic=3D10 softlockup_panic=3D1 nmi_watchdog=3Dpanic  prompt_ramd=
isk=3D0 console=3DttyS0,115200 console=3Dtty0 vga=3Dnormal  root=3D/dev/ram=
0 rw link=3D/kbuild-tests/run-queue/kvm/i386-randconfig-r2-0722/linux-devel=
:devel-roam-i386-201407222107:47702c7c4c9c1e8514ca52e367cf0b71e50177f8:bise=
ct-linux-8/.vmlinuz-47702c7c4c9c1e8514ca52e367cf0b71e50177f8-20140722222355=
-37-ivb41 branch=3Dlinux-devel/devel-roam-i386-201407222107 BOOT_IMAGE=3D/k=
ernel/i386-randconfig-r2-0722/47702c7c4c9c1e8514ca52e367cf0b71e50177f8/vmli=
nuz-3.16.0-rc5-00230-g47702c7 drbd.minor_count=3D8
[    0.000000] sysrq: sysrq always enabled.
[    0.000000] PID hash table entries: 2048 (order: 1, 8192 bytes)
[    0.000000] Dentry cache hash table entries: 65536 (order: 6, 262144 byt=
es)
[    0.000000] Inode-cache hash table entries: 32768 (order: 5, 131072 byte=
s)
[    0.000000] Initializing CPU#0
[    0.000000] Memory: 278852K/327280K available (6632K kernel code, 2384K =
rwdata, 4008K rodata, 328K init, 8188K bss, 48428K reserved)
[    0.000000] virtual kernel memory layout:
[    0.000000]     fixmap  : 0xfffa3000 - 0xfffff000   ( 368 kB)
[    0.000000]     vmalloc : 0xc47fe000 - 0xfffa1000   ( 951 MB)
[    0.000000]     lowmem  : 0xb0000000 - 0xc3ffe000   ( 319 MB)
[    0.000000]       .init : 0xc20bc000 - 0xc210e000   ( 328 kB)
[    0.000000]       .data : 0xc1a7a38c - 0xc20ba000   (6399 kB)
[    0.000000]       .text : 0xc1400000 - 0xc1a7a38c   (6632 kB)
[    0.000000] Checking if this processor honours the WP bit even in superv=
isor mode...Ok.
[    0.000000] NR_IRQS:2304 nr_irqs:256 16
[    0.000000] CPU 0 irqstacks, hard=3Db0094000 soft=3Db0096000
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
[    0.000000]  memory used by lock dependency info: 5167 kB
[    0.000000]  memory used by lock dependency info: 5167 kB
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
[    0.000000] hpet clockevent registered
[    0.000000] hpet clockevent registered
[    0.000000] tsc: Detected 2693.506 MHz processor
[    0.000000] tsc: Detected 2693.506 MHz processor
[    0.003000] Calibrating delay loop (skipped) preset value..=20
[    0.003000] Calibrating delay loop (skipped) preset value.. 5387.01 Bogo=
MIPS (lpj=3D2693506)
5387.01 BogoMIPS (lpj=3D2693506)
[    0.003424] pid_max: default: 32768 minimum: 301
[    0.003424] pid_max: default: 32768 minimum: 301
[    0.004036] ACPI: Core revision 20140424
[    0.004036] ACPI: Core revision 20140424
[    0.007664] ACPI:=20
[    0.007664] ACPI: All ACPI Tables successfully acquiredAll ACPI Tables s=
uccessfully acquired

[    0.008134] Security Framework initialized
[    0.008134] Security Framework initialized
[    0.009010] Yama: becoming mindful.
[    0.009010] Yama: becoming mindful.
[    0.009556] Mount-cache hash table entries: 1024 (order: 0, 4096 bytes)
[    0.009556] Mount-cache hash table entries: 1024 (order: 0, 4096 bytes)
[    0.010011] Mountpoint-cache hash table entries: 1024 (order: 0, 4096 by=
tes)
[    0.010011] Mountpoint-cache hash table entries: 1024 (order: 0, 4096 by=
tes)
[    0.011369] Initializing cgroup subsys devices
[    0.011369] Initializing cgroup subsys devices
[    0.012050] Initializing cgroup subsys freezer
[    0.012050] Initializing cgroup subsys freezer
[    0.012747] Initializing cgroup subsys perf_event
[    0.012747] Initializing cgroup subsys perf_event
[    0.013051] Last level iTLB entries: 4KB 0, 2MB 0, 4MB 0
[    0.013051] Last level dTLB entries: 4KB 0, 2MB 0, 4MB 0, 1GB 0
[    0.013051] tlb_flushall_shift: -1
[    0.013051] Last level iTLB entries: 4KB 0, 2MB 0, 4MB 0
[    0.013051] Last level dTLB entries: 4KB 0, 2MB 0, 4MB 0, 1GB 0
[    0.013051] tlb_flushall_shift: -1
[    0.014005] CPU:=20
[    0.014005] CPU: GenuineIntel GenuineIntel Common KVM processorCommon KV=
M processor (fam: 0f, model: 06 (fam: 0f, model: 06, stepping: 01)
, stepping: 01)
[    0.016540] Performance Events:=20
[    0.016540] Performance Events: no PMU driver, software events only.
no PMU driver, software events only.
[    0.019335] Enabling APIC mode:  Flat.  Using 1 I/O APICs
[    0.019335] Enabling APIC mode:  Flat.  Using 1 I/O APICs
[    0.020006] Getting VERSION: 1050014
[    0.020006] Getting VERSION: 1050014
[    0.020552] Getting VERSION: 1050014
[    0.020552] Getting VERSION: 1050014
[    0.021006] Getting ID: 0
[    0.021006] Getting ID: 0
[    0.021407] Getting ID: f000000
[    0.021407] Getting ID: f000000
[    0.022009] Getting LVT0: 8700
[    0.022009] Getting LVT0: 8700
[    0.022467] Getting LVT1: 8400
[    0.022467] Getting LVT1: 8400
[    0.023023] enabled ExtINT on CPU#0
[    0.023023] enabled ExtINT on CPU#0
[    0.024583] ENABLING IO-APIC IRQs
[    0.024583] ENABLING IO-APIC IRQs
[    0.025005] init IO_APIC IRQs
[    0.025005] init IO_APIC IRQs
[    0.025462]  apic 0 pin 0 not connected
[    0.025462]  apic 0 pin 0 not connected
[    0.026019] NMI watchdog: disabled (cpu0): hardware events not enabled
[    0.026019] NMI watchdog: disabled (cpu0): hardware events not enabled
[    0.027045] IOAPIC[0]: Set routing entry (0-1 -> 0x31 -> IRQ 1 Mode:0 Ac=
tive:0 Dest:1)
[    0.027045] IOAPIC[0]: Set routing entry (0-1 -> 0x31 -> IRQ 1 Mode:0 Ac=
tive:0 Dest:1)
[    0.028022] IOAPIC[0]: Set routing entry (0-2 -> 0x30 -> IRQ 0 Mode:0 Ac=
tive:0 Dest:1)
[    0.028022] IOAPIC[0]: Set routing entry (0-2 -> 0x30 -> IRQ 0 Mode:0 Ac=
tive:0 Dest:1)
[    0.029021] IOAPIC[0]: Set routing entry (0-3 -> 0x33 -> IRQ 3 Mode:0 Ac=
tive:0 Dest:1)
[    0.029021] IOAPIC[0]: Set routing entry (0-3 -> 0x33 -> IRQ 3 Mode:0 Ac=
tive:0 Dest:1)
[    0.030020] IOAPIC[0]: Set routing entry (0-4 -> 0x34 -> IRQ 4 Mode:0 Ac=
tive:0 Dest:1)
[    0.030020] IOAPIC[0]: Set routing entry (0-4 -> 0x34 -> IRQ 4 Mode:0 Ac=
tive:0 Dest:1)
[    0.031020] IOAPIC[0]: Set routing entry (0-5 -> 0x35 -> IRQ 5 Mode:1 Ac=
tive:0 Dest:1)
[    0.031020] IOAPIC[0]: Set routing entry (0-5 -> 0x35 -> IRQ 5 Mode:1 Ac=
tive:0 Dest:1)
[    0.032020] IOAPIC[0]: Set routing entry (0-6 -> 0x36 -> IRQ 6 Mode:0 Ac=
tive:0 Dest:1)
[    0.032020] IOAPIC[0]: Set routing entry (0-6 -> 0x36 -> IRQ 6 Mode:0 Ac=
tive:0 Dest:1)
[    0.033020] IOAPIC[0]: Set routing entry (0-7 -> 0x37 -> IRQ 7 Mode:0 Ac=
tive:0 Dest:1)
[    0.033020] IOAPIC[0]: Set routing entry (0-7 -> 0x37 -> IRQ 7 Mode:0 Ac=
tive:0 Dest:1)
[    0.034020] IOAPIC[0]: Set routing entry (0-8 -> 0x38 -> IRQ 8 Mode:0 Ac=
tive:0 Dest:1)
[    0.034020] IOAPIC[0]: Set routing entry (0-8 -> 0x38 -> IRQ 8 Mode:0 Ac=
tive:0 Dest:1)
[    0.035020] IOAPIC[0]: Set routing entry (0-9 -> 0x39 -> IRQ 9 Mode:1 Ac=
tive:0 Dest:1)
[    0.035020] IOAPIC[0]: Set routing entry (0-9 -> 0x39 -> IRQ 9 Mode:1 Ac=
tive:0 Dest:1)
[    0.036021] IOAPIC[0]: Set routing entry (0-10 -> 0x3a -> IRQ 10 Mode:1 =
Active:0 Dest:1)
[    0.036021] IOAPIC[0]: Set routing entry (0-10 -> 0x3a -> IRQ 10 Mode:1 =
Active:0 Dest:1)
[    0.037020] IOAPIC[0]: Set routing entry (0-11 -> 0x3b -> IRQ 11 Mode:1 =
Active:0 Dest:1)
[    0.037020] IOAPIC[0]: Set routing entry (0-11 -> 0x3b -> IRQ 11 Mode:1 =
Active:0 Dest:1)
[    0.038020] IOAPIC[0]: Set routing entry (0-12 -> 0x3c -> IRQ 12 Mode:0 =
Active:0 Dest:1)
[    0.038020] IOAPIC[0]: Set routing entry (0-12 -> 0x3c -> IRQ 12 Mode:0 =
Active:0 Dest:1)
[    0.039020] IOAPIC[0]: Set routing entry (0-13 -> 0x3d -> IRQ 13 Mode:0 =
Active:0 Dest:1)
[    0.039020] IOAPIC[0]: Set routing entry (0-13 -> 0x3d -> IRQ 13 Mode:0 =
Active:0 Dest:1)
[    0.040021] IOAPIC[0]: Set routing entry (0-14 -> 0x3e -> IRQ 14 Mode:0 =
Active:0 Dest:1)
[    0.040021] IOAPIC[0]: Set routing entry (0-14 -> 0x3e -> IRQ 14 Mode:0 =
Active:0 Dest:1)
[    0.041021] IOAPIC[0]: Set routing entry (0-15 -> 0x3f -> IRQ 15 Mode:0 =
Active:0 Dest:1)
[    0.041021] IOAPIC[0]: Set routing entry (0-15 -> 0x3f -> IRQ 15 Mode:0 =
Active:0 Dest:1)
[    0.042018]  apic 0 pin 16 not connected
[    0.042018]  apic 0 pin 16 not connected
[    0.043003]  apic 0 pin 17 not connected
[    0.043003]  apic 0 pin 17 not connected
[    0.044003]  apic 0 pin 18 not connected
[    0.044003]  apic 0 pin 18 not connected
[    0.044593]  apic 0 pin 19 not connected
[    0.044593]  apic 0 pin 19 not connected
[    0.045003]  apic 0 pin 20 not connected
[    0.045003]  apic 0 pin 20 not connected
[    0.045593]  apic 0 pin 21 not connected
[    0.045593]  apic 0 pin 21 not connected
[    0.046003]  apic 0 pin 22 not connected
[    0.046003]  apic 0 pin 22 not connected
[    0.047003]  apic 0 pin 23 not connected
[    0.047003]  apic 0 pin 23 not connected
[    0.047737] ..TIMER: vector=3D0x30 apic1=3D0 pin1=3D2 apic2=3D-1 pin2=3D=
-1
[    0.047737] ..TIMER: vector=3D0x30 apic1=3D0 pin1=3D2 apic2=3D-1 pin2=3D=
-1
[    0.048004] Using local APIC timer interrupts.
[    0.048004] calibrating APIC timer ...
[    0.048004] Using local APIC timer interrupts.
[    0.048004] calibrating APIC timer ...
[    0.050000] ... lapic delta =3D 6249908
[    0.050000] ... lapic delta =3D 6249908
[    0.050000] ... PM-Timer delta =3D 357937
[    0.050000] ... PM-Timer delta =3D 357937
[    0.050000] ... PM-Timer result ok
[    0.050000] ... PM-Timer result ok
[    0.050000] ..... delta 6249908
[    0.050000] ..... delta 6249908
[    0.050000] ..... mult: 268431504
[    0.050000] ..... mult: 268431504
[    0.050000] ..... calibration result: 999985
[    0.050000] ..... calibration result: 999985
[    0.050000] ..... CPU clock speed is 2693.0326 MHz.
[    0.050000] ..... CPU clock speed is 2693.0326 MHz.
[    0.050000] ..... host bus clock speed is 999.0985 MHz.
[    0.050000] ..... host bus clock speed is 999.0985 MHz.
[    0.050522] devtmpfs: initialized
[    0.050522] devtmpfs: initialized
[    0.051825] evm: security.ima
[    0.051825] evm: security.ima
[    0.052003] evm: security.capability
[    0.052003] evm: security.capability
[    0.054151] atomic64_test: passed for i586+ platform with CX8 and with S=
SE
[    0.054151] atomic64_test: passed for i586+ platform with CX8 and with S=
SE
[    0.055103] RTC time: 22:23:49, date: 07/22/14
[    0.055103] RTC time: 22:23:49, date: 07/22/14
[    0.056139] NET: Registered protocol family 16
[    0.056139] NET: Registered protocol family 16
[    0.058592] EISA bus registered
[    0.058592] EISA bus registered
[    0.059014] cpuidle: using governor ladder
[    0.059014] cpuidle: using governor ladder
[    0.060007] cpuidle: using governor menu
[    0.060007] cpuidle: using governor menu
[    0.061537] ACPI: bus type PCI registered
[    0.061537] ACPI: bus type PCI registered
[    0.062043] PCI: PCI BIOS revision 2.10 entry at 0xfd456, last bus=3D0
[    0.062043] PCI: PCI BIOS revision 2.10 entry at 0xfd456, last bus=3D0
[    0.076578] ACPI: Added _OSI(Module Device)
[    0.076578] ACPI: Added _OSI(Module Device)
[    0.077006] ACPI: Added _OSI(Processor Device)
[    0.077006] ACPI: Added _OSI(Processor Device)
[    0.078004] ACPI: Added _OSI(3.0 _SCP Extensions)
[    0.078004] ACPI: Added _OSI(3.0 _SCP Extensions)
[    0.079004] ACPI: Added _OSI(Processor Aggregator Device)
[    0.079004] ACPI: Added _OSI(Processor Aggregator Device)
[    0.087644] ACPI: Interpreter enabled
[    0.087644] ACPI: Interpreter enabled
[    0.088006] ACPI Exception: AE_NOT_FOUND,=20
[    0.088006] ACPI Exception: AE_NOT_FOUND, While evaluating Sleep State [=
\_S1_]While evaluating Sleep State [\_S1_] (20140424/hwxface-580)
 (20140424/hwxface-580)
[    0.090006] ACPI Exception: AE_NOT_FOUND,=20
[    0.090006] ACPI Exception: AE_NOT_FOUND, While evaluating Sleep State [=
\_S2_]While evaluating Sleep State [\_S2_] (20140424/hwxface-580)
 (20140424/hwxface-580)
[    0.092034] ACPI: (supports S0 S3 S5)
[    0.092034] ACPI: (supports S0 S3 S5)
[    0.092748] ACPI: Using IOAPIC for interrupt routing
[    0.092748] ACPI: Using IOAPIC for interrupt routing
[    0.093044] PCI: Using host bridge windows from ACPI; if necessary, use =
"pci=3Dnocrs" and report a bug
[    0.093044] PCI: Using host bridge windows from ACPI; if necessary, use =
"pci=3Dnocrs" and report a bug
[    0.104149] ACPI: PCI Root Bridge [PCI0] (domain 0000 [bus 00-ff])
[    0.104149] ACPI: PCI Root Bridge [PCI0] (domain 0000 [bus 00-ff])
[    0.105011] acpi PNP0A03:00: _OSC: OS supports [ASPM ClockPM Segments MS=
I]
[    0.105011] acpi PNP0A03:00: _OSC: OS supports [ASPM ClockPM Segments MS=
I]
[    0.106035] acpi PNP0A03:00: _OSC failed (AE_NOT_FOUND); disabling ASPM
[    0.106035] acpi PNP0A03:00: _OSC failed (AE_NOT_FOUND); disabling ASPM
[    0.107390] PCI host bridge to bus 0000:00
[    0.107390] PCI host bridge to bus 0000:00
[    0.108006] pci_bus 0000:00: root bus resource [bus 00-ff]
[    0.108006] pci_bus 0000:00: root bus resource [bus 00-ff]
[    0.109008] pci_bus 0000:00: root bus resource [io  0x0000-0x0cf7]
[    0.109008] pci_bus 0000:00: root bus resource [io  0x0000-0x0cf7]
[    0.110005] pci_bus 0000:00: root bus resource [io  0x0d00-0xadff]
[    0.110005] pci_bus 0000:00: root bus resource [io  0x0d00-0xadff]
[    0.111005] pci_bus 0000:00: root bus resource [io  0xae0f-0xaeff]
[    0.111005] pci_bus 0000:00: root bus resource [io  0xae0f-0xaeff]
[    0.112004] pci_bus 0000:00: root bus resource [io  0xaf20-0xafdf]
[    0.112004] pci_bus 0000:00: root bus resource [io  0xaf20-0xafdf]
[    0.113005] pci_bus 0000:00: root bus resource [io  0xafe4-0xffff]
[    0.113005] pci_bus 0000:00: root bus resource [io  0xafe4-0xffff]
[    0.114005] pci_bus 0000:00: root bus resource [mem 0x000a0000-0x000bfff=
f]
[    0.114005] pci_bus 0000:00: root bus resource [mem 0x000a0000-0x000bfff=
f]
[    0.115005] pci_bus 0000:00: root bus resource [mem 0x14000000-0xfebffff=
f]
[    0.115005] pci_bus 0000:00: root bus resource [mem 0x14000000-0xfebffff=
f]
[    0.116056] pci 0000:00:00.0: [8086:1237] type 00 class 0x060000
[    0.116056] pci 0000:00:00.0: [8086:1237] type 00 class 0x060000
[    0.118147] pci 0000:00:01.0: [8086:7000] type 00 class 0x060100
[    0.118147] pci 0000:00:01.0: [8086:7000] type 00 class 0x060100
[    0.119619] pci 0000:00:01.1: [8086:7010] type 00 class 0x010180
[    0.119619] pci 0000:00:01.1: [8086:7010] type 00 class 0x010180
[    0.122214] pci 0000:00:01.1: reg 0x20: [io  0xc040-0xc04f]
[    0.122214] pci 0000:00:01.1: reg 0x20: [io  0xc040-0xc04f]
[    0.124238] pci 0000:00:01.1: legacy IDE quirk: reg 0x10: [io  0x01f0-0x=
01f7]
[    0.124238] pci 0000:00:01.1: legacy IDE quirk: reg 0x10: [io  0x01f0-0x=
01f7]
[    0.125004] pci 0000:00:01.1: legacy IDE quirk: reg 0x14: [io  0x03f6]
[    0.125004] pci 0000:00:01.1: legacy IDE quirk: reg 0x14: [io  0x03f6]
[    0.126004] pci 0000:00:01.1: legacy IDE quirk: reg 0x18: [io  0x0170-0x=
0177]
[    0.126004] pci 0000:00:01.1: legacy IDE quirk: reg 0x18: [io  0x0170-0x=
0177]
[    0.127004] pci 0000:00:01.1: legacy IDE quirk: reg 0x1c: [io  0x0376]
[    0.127004] pci 0000:00:01.1: legacy IDE quirk: reg 0x1c: [io  0x0376]
[    0.129100] pci 0000:00:01.3: [8086:7113] type 00 class 0x068000
[    0.129100] pci 0000:00:01.3: [8086:7113] type 00 class 0x068000
[    0.130317] pci 0000:00:01.3: quirk: [io  0x0600-0x063f] claimed by PIIX=
4 ACPI
[    0.130317] pci 0000:00:01.3: quirk: [io  0x0600-0x063f] claimed by PIIX=
4 ACPI
[    0.131022] pci 0000:00:01.3: quirk: [io  0x0700-0x070f] claimed by PIIX=
4 SMB
[    0.131022] pci 0000:00:01.3: quirk: [io  0x0700-0x070f] claimed by PIIX=
4 SMB
[    0.132394] pci 0000:00:02.0: [1013:00b8] type 00 class 0x030000
[    0.132394] pci 0000:00:02.0: [1013:00b8] type 00 class 0x030000
[    0.134009] pci 0000:00:02.0: reg 0x10: [mem 0xfc000000-0xfdffffff pref]
[    0.134009] pci 0000:00:02.0: reg 0x10: [mem 0xfc000000-0xfdffffff pref]
[    0.136009] pci 0000:00:02.0: reg 0x14: [mem 0xfebf0000-0xfebf0fff]
[    0.136009] pci 0000:00:02.0: reg 0x14: [mem 0xfebf0000-0xfebf0fff]
[    0.142487] pci 0000:00:02.0: reg 0x30: [mem 0xfebe0000-0xfebeffff pref]
[    0.142487] pci 0000:00:02.0: reg 0x30: [mem 0xfebe0000-0xfebeffff pref]
[    0.144307] pci 0000:00:03.0: [8086:100e] type 00 class 0x020000
[    0.144307] pci 0000:00:03.0: [8086:100e] type 00 class 0x020000
[    0.146005] pci 0000:00:03.0: reg 0x10: [mem 0xfebc0000-0xfebdffff]
[    0.146005] pci 0000:00:03.0: reg 0x10: [mem 0xfebc0000-0xfebdffff]
[    0.148005] pci 0000:00:03.0: reg 0x14: [io  0xc000-0xc03f]
[    0.148005] pci 0000:00:03.0: reg 0x14: [io  0xc000-0xc03f]
[    0.153005] pci 0000:00:03.0: reg 0x30: [mem 0xfeb80000-0xfebbffff pref]
[    0.153005] pci 0000:00:03.0: reg 0x30: [mem 0xfeb80000-0xfebbffff pref]
[    0.154337] pci 0000:00:04.0: [8086:25ab] type 00 class 0x088000
[    0.154337] pci 0000:00:04.0: [8086:25ab] type 00 class 0x088000
[    0.155431] pci 0000:00:04.0: reg 0x10: [mem 0xfebf1000-0xfebf100f]
[    0.155431] pci 0000:00:04.0: reg 0x10: [mem 0xfebf1000-0xfebf100f]
[    0.159529] pci_bus 0000:00: on NUMA node 0
[    0.159529] pci_bus 0000:00: on NUMA node 0
[    0.161424] ACPI: PCI Interrupt Link [LNKA] (IRQs
[    0.161424] ACPI: PCI Interrupt Link [LNKA] (IRQs 5 5 *10 *10 11 11))

[    0.162487] ACPI: PCI Interrupt Link [LNKB] (IRQs
[    0.162487] ACPI: PCI Interrupt Link [LNKB] (IRQs 5 5 *10 *10 11 11))

[    0.164199] ACPI: PCI Interrupt Link [LNKC] (IRQs
[    0.164199] ACPI: PCI Interrupt Link [LNKC] (IRQs 5 5 10 10 *11 *11))

[    0.165493] ACPI: PCI Interrupt Link [LNKD] (IRQs
[    0.165493] ACPI: PCI Interrupt Link [LNKD] (IRQs 5 5 10 10 *11 *11))

[    0.166360] ACPI: PCI Interrupt Link [LNKS] (IRQs
[    0.166360] ACPI: PCI Interrupt Link [LNKS] (IRQs *9 *9))

[    0.168731] ACPI:=20
[    0.168731] ACPI: Enabled 16 GPEs in block 00 to 0FEnabled 16 GPEs in bl=
ock 00 to 0F

[    0.170136] vgaarb: device added: PCI:0000:00:02.0,decodes=3Dio+mem,owns=
=3Dio+mem,locks=3Dnone
[    0.170136] vgaarb: device added: PCI:0000:00:02.0,decodes=3Dio+mem,owns=
=3Dio+mem,locks=3Dnone
[    0.171005] vgaarb: loaded
[    0.171005] vgaarb: loaded
[    0.172003] vgaarb: bridge control possible 0000:00:02.0
[    0.172003] vgaarb: bridge control possible 0000:00:02.0
[    0.173585] ACPI: bus type USB registered
[    0.173585] ACPI: bus type USB registered
[    0.174055] usbcore: registered new interface driver usbfs
[    0.174055] usbcore: registered new interface driver usbfs
[    0.175030] usbcore: registered new interface driver hub
[    0.175030] usbcore: registered new interface driver hub
[    0.177088] usbcore: registered new device driver usb
[    0.177088] usbcore: registered new device driver usb
[    0.178326] pps_core: LinuxPPS API ver. 1 registered
[    0.178326] pps_core: LinuxPPS API ver. 1 registered
[    0.179005] pps_core: Software ver. 5.3.6 - Copyright 2005-2007 Rodolfo =
Giometti <giometti@linux.it>
[    0.179005] pps_core: Software ver. 5.3.6 - Copyright 2005-2007 Rodolfo =
Giometti <giometti@linux.it>
[    0.180052] EDAC MC: Ver: 3.0.0
[    0.180052] EDAC MC: Ver: 3.0.0
[    0.181311] wmi: Mapper loaded
[    0.181311] wmi: Mapper loaded
[    0.182079] PCI: Using ACPI for IRQ routing
[    0.182079] PCI: Using ACPI for IRQ routing
[    0.182903] PCI: pci_cache_line_size set to 64 bytes
[    0.182903] PCI: pci_cache_line_size set to 64 bytes
[    0.183095] e820: reserve RAM buffer [mem 0x0009fc00-0x0009ffff]
[    0.183095] e820: reserve RAM buffer [mem 0x0009fc00-0x0009ffff]
[    0.184011] e820: reserve RAM buffer [mem 0x13ffe000-0x13ffffff]
[    0.184011] e820: reserve RAM buffer [mem 0x13ffe000-0x13ffffff]
[    0.186386] HPET: 3 timers in total, 0 timers will be used for per-cpu t=
imer
[    0.186386] HPET: 3 timers in total, 0 timers will be used for per-cpu t=
imer
[    0.187159] Switched to clocksource kvm-clock
[    0.187159] Switched to clocksource kvm-clock
[    0.188167] pnp: PnP ACPI init
[    0.188167] pnp: PnP ACPI init
[    0.188829] ACPI: bus type PNP registered
[    0.188829] ACPI: bus type PNP registered
[    0.189705] IOAPIC[0]: Set routing entry (0-8 -> 0x38 -> IRQ 8 Mode:0 Ac=
tive:0 Dest:1)
[    0.189705] IOAPIC[0]: Set routing entry (0-8 -> 0x38 -> IRQ 8 Mode:0 Ac=
tive:0 Dest:1)
[    0.191367] pnp 00:00: Plug and Play ACPI device, IDs PNP0b00 (active)
[    0.191367] pnp 00:00: Plug and Play ACPI device, IDs PNP0b00 (active)
[    0.192706] IOAPIC[0]: Set routing entry (0-1 -> 0x31 -> IRQ 1 Mode:0 Ac=
tive:0 Dest:1)
[    0.192706] IOAPIC[0]: Set routing entry (0-1 -> 0x31 -> IRQ 1 Mode:0 Ac=
tive:0 Dest:1)
[    0.194339] pnp 00:01: Plug and Play ACPI device, IDs PNP0303 (active)
[    0.194339] pnp 00:01: Plug and Play ACPI device, IDs PNP0303 (active)
[    0.195684] IOAPIC[0]: Set routing entry (0-12 -> 0x3c -> IRQ 12 Mode:0 =
Active:0 Dest:1)
[    0.195684] IOAPIC[0]: Set routing entry (0-12 -> 0x3c -> IRQ 12 Mode:0 =
Active:0 Dest:1)
[    0.197369] pnp 00:02: Plug and Play ACPI device, IDs PNP0f13 (active)
[    0.197369] pnp 00:02: Plug and Play ACPI device, IDs PNP0f13 (active)
[    0.198723] IOAPIC[0]: Set routing entry (0-6 -> 0x36 -> IRQ 6 Mode:0 Ac=
tive:0 Dest:1)
[    0.198723] IOAPIC[0]: Set routing entry (0-6 -> 0x36 -> IRQ 6 Mode:0 Ac=
tive:0 Dest:1)
[    0.200313] pnp 00:03: [dma 2]
[    0.200313] pnp 00:03: [dma 2]
[    0.200961] pnp 00:03: Plug and Play ACPI device, IDs PNP0700 (active)
[    0.200961] pnp 00:03: Plug and Play ACPI device, IDs PNP0700 (active)
[    0.202317] IOAPIC[0]: Set routing entry (0-7 -> 0x37 -> IRQ 7 Mode:0 Ac=
tive:0 Dest:1)
[    0.202317] IOAPIC[0]: Set routing entry (0-7 -> 0x37 -> IRQ 7 Mode:0 Ac=
tive:0 Dest:1)
[    0.203950] pnp 00:04: Plug and Play ACPI device, IDs PNP0400 (active)
[    0.203950] pnp 00:04: Plug and Play ACPI device, IDs PNP0400 (active)
[    0.205305] IOAPIC[0]: Set routing entry (0-4 -> 0x34 -> IRQ 4 Mode:0 Ac=
tive:0 Dest:1)
[    0.205305] IOAPIC[0]: Set routing entry (0-4 -> 0x34 -> IRQ 4 Mode:0 Ac=
tive:0 Dest:1)
[    0.206931] pnp 00:05: Plug and Play ACPI device, IDs PNP0501 (active)
[    0.206931] pnp 00:05: Plug and Play ACPI device, IDs PNP0501 (active)
[    0.208756] pnp: PnP ACPI: found 6 devices
[    0.208756] pnp: PnP ACPI: found 6 devices
[    0.209603] ACPI: bus type PNP unregistered
[    0.209603] ACPI: bus type PNP unregistered
[    0.210422] PnPBIOS: Disabled
[    0.210422] PnPBIOS: Disabled
[    0.246550] pci_bus 0000:00: resource 4 [io  0x0000-0x0cf7]
[    0.246550] pci_bus 0000:00: resource 4 [io  0x0000-0x0cf7]
[    0.247700] pci_bus 0000:00: resource 5 [io  0x0d00-0xadff]
[    0.247700] pci_bus 0000:00: resource 5 [io  0x0d00-0xadff]
[    0.248806] pci_bus 0000:00: resource 6 [io  0xae0f-0xaeff]
[    0.248806] pci_bus 0000:00: resource 6 [io  0xae0f-0xaeff]
[    0.249889] pci_bus 0000:00: resource 7 [io  0xaf20-0xafdf]
[    0.249889] pci_bus 0000:00: resource 7 [io  0xaf20-0xafdf]
[    0.250984] pci_bus 0000:00: resource 8 [io  0xafe4-0xffff]
[    0.250984] pci_bus 0000:00: resource 8 [io  0xafe4-0xffff]
[    0.252093] pci_bus 0000:00: resource 9 [mem 0x000a0000-0x000bffff]
[    0.252093] pci_bus 0000:00: resource 9 [mem 0x000a0000-0x000bffff]
[    0.253340] pci_bus 0000:00: resource 10 [mem 0x14000000-0xfebfffff]
[    0.253340] pci_bus 0000:00: resource 10 [mem 0x14000000-0xfebfffff]
[    0.254617] NET: Registered protocol family 1
[    0.254617] NET: Registered protocol family 1
[    0.255487] pci 0000:00:00.0: Limiting direct PCI/PCI transfers
[    0.255487] pci 0000:00:00.0: Limiting direct PCI/PCI transfers
[    0.256690] pci 0000:00:01.0: PIIX3: Enabling Passive Release
[    0.256690] pci 0000:00:01.0: PIIX3: Enabling Passive Release
[    0.257833] pci 0000:00:01.0: Activating ISA DMA hang workarounds
[    0.257833] pci 0000:00:01.0: Activating ISA DMA hang workarounds
[    0.259053] pci 0000:00:02.0: Boot video device
[    0.259053] pci 0000:00:02.0: Boot video device
[    0.259978] PCI: CLS 0 bytes, default 64
[    0.259978] PCI: CLS 0 bytes, default 64
[    0.261012] Unpacking initramfs...
[    0.261012] Unpacking initramfs...
[    0.261751] Initramfs unpacking failed: junk in compressed archive
[    0.261751] Initramfs unpacking failed: junk in compressed archive
[    0.262952] debug: unmapping init [mem 0xc27ab000-0xc3feffff]
[    0.262952] debug: unmapping init [mem 0xc27ab000-0xc3feffff]

BUG: kernel boot crashed
Elapsed time: 5
qemu-system-x86_64 -cpu kvm64 -enable-kvm -kernel /kernel/i386-randconfig-r=
2-0722/47702c7c4c9c1e8514ca52e367cf0b71e50177f8/vmlinuz-3.16.0-rc5-00230-g4=
7702c7 -append 'hung_task_panic=3D1 earlyprintk=3DttyS0,115200 debug apic=
=3Ddebug sysrq_always_enabled rcupdate.rcu_cpu_stall_timeout=3D100 panic=3D=
10 softlockup_panic=3D1 nmi_watchdog=3Dpanic  prompt_ramdisk=3D0 console=3D=
ttyS0,115200 console=3Dtty0 vga=3Dnormal  root=3D/dev/ram0 rw link=3D/kbuil=
d-tests/run-queue/kvm/i386-randconfig-r2-0722/linux-devel:devel-roam-i386-2=
01407222107:47702c7c4c9c1e8514ca52e367cf0b71e50177f8:bisect-linux-8/.vmlinu=
z-47702c7c4c9c1e8514ca52e367cf0b71e50177f8-20140722222355-37-ivb41 branch=
=3Dlinux-devel/devel-roam-i386-201407222107 BOOT_IMAGE=3D/kernel/i386-randc=
onfig-r2-0722/47702c7c4c9c1e8514ca52e367cf0b71e50177f8/vmlinuz-3.16.0-rc5-0=
0230-g47702c7 drbd.minor_count=3D8'  -initrd /kernel-tests/initrd/quantal-c=
ore-i386.cgz -m 320 -smp 2 -net nic,vlan=3D1,model=3De1000 -net user,vlan=
=3D1 -boot order=3Dnc -no-reboot -watchdog i6300esb -rtc base=3Dlocaltime -=
pidfile /dev/shm/kboot/pid-quantal-ivb41-121 -serial file:/dev/shm/kboot/se=
rial-quantal-ivb41-121 -daemonize -display none -monitor null=20

--Ah40dssYA/cDqAW1
Content-Type: application/octet-stream
Content-Disposition: attachment; filename="i386-randconfig-r2-0722-988a7cce9cf281d8954af4f421419713e2d6499a-BUG:-unable-to-handle-kernel-NULL-pointer-dereference-47769.log"
Content-Transfer-Encoding: base64

SEVBRCBpcyBub3cgYXQgOTg4YTdjYy4uLiAwZGF5IGhlYWQgZ3VhcmQgZm9yICdkZXZlbC1y
b2FtLWkzODYtMjAxNDA3MjIyMTA3JwpnaXQgY2hlY2tvdXQgOWEzYzQxNDVhZjMyMTI1YzVl
ZTM5YzAyNzI2NjJiNDczMDdhODMyMwpscyAtYSAva2J1aWxkLXRlc3RzL3J1bi1xdWV1ZS9r
dm0vaTM4Ni1yYW5kY29uZmlnLXIyLTA3MjIvbGludXgtZGV2ZWw6ZGV2ZWwtcm9hbS1pMzg2
LTIwMTQwNzIyMjEwNzo5YTNjNDE0NWFmMzIxMjVjNWVlMzljMDI3MjY2MmI0NzMwN2E4MzIz
OmJpc2VjdC1saW51eC04CgoyMDE0LTA3LTIyLTIxOjUzOjIzIDlhM2M0MTQ1YWYzMjEyNWM1
ZWUzOWMwMjcyNjYyYjQ3MzA3YTgzMjMgcmV1c2UgL2tlcm5lbC9pMzg2LXJhbmRjb25maWct
cjItMDcyMi85YTNjNDE0NWFmMzIxMjVjNWVlMzljMDI3MjY2MmI0NzMwN2E4MzIzL3ZtbGlu
dXotMy4xNi4wLXJjNgoKMjAxNC0wNy0yMi0yMTo1MzoyMyBkZXRlY3RpbmcgYm9vdCBzdGF0
ZSAJMgk3CTkJMTkJMjAgU1VDQ0VTUwoKYmlzZWN0OiBnb29kIGNvbW1pdCA5YTNjNDE0NWFm
MzIxMjVjNWVlMzljMDI3MjY2MmI0NzMwN2E4MzIzCmdpdCBiaXNlY3Qgc3RhcnQgOTg4YTdj
Y2U5Y2YyODFkODk1NGFmNGY0MjE0MTk3MTNlMmQ2NDk5YSA5YTNjNDE0NWFmMzIxMjVjNWVl
MzljMDI3MjY2MmI0NzMwN2E4MzIzIC0tCi9jL2tlcm5lbC10ZXN0cy9saW5lYXItYmlzZWN0
OiBbIi1iIiwgIjk4OGE3Y2NlOWNmMjgxZDg5NTRhZjRmNDIxNDE5NzEzZTJkNjQ5OWEiLCAi
LWciLCAiOWEzYzQxNDVhZjMyMTI1YzVlZTM5YzAyNzI2NjJiNDczMDdhODMyMyIsICIvYy9r
ZXJuZWwtdGVzdHMvYmlzZWN0LXRlc3QtYm9vdC1mYWlsdXJlLnNoIiwgIi9jL2Jvb3QtYmlz
ZWN0L2xpbnV4LTgvb2JqLWJpc2VjdCJdCkJpc2VjdGluZzogNjggcmV2aXNpb25zIGxlZnQg
dG8gdGVzdCBhZnRlciB0aGlzIChyb3VnaGx5IDcgc3RlcHMpClswYjZmZTJiOTg4Y2FlZTgw
OGYzY2NiNjE2ZmEyMmYyYTU2YTA0MmU4XSBNZXJnZSAnd3NhL2kyYy9mb3ItbmV4dCcgaW50
byBkZXZlbC1yb2FtLWkzODYtMjAxNDA3MjIyMTA3CnJ1bm5pbmcgL2Mva2VybmVsLXRlc3Rz
L2Jpc2VjdC10ZXN0LWJvb3QtZmFpbHVyZS5zaCAvYy9ib290LWJpc2VjdC9saW51eC04L29i
ai1iaXNlY3QKbHMgLWEgL2tidWlsZC10ZXN0cy9ydW4tcXVldWUva3ZtL2kzODYtcmFuZGNv
bmZpZy1yMi0wNzIyL2xpbnV4LWRldmVsOmRldmVsLXJvYW0taTM4Ni0yMDE0MDcyMjIxMDc6
MGI2ZmUyYjk4OGNhZWU4MDhmM2NjYjYxNmZhMjJmMmE1NmEwNDJlODpiaXNlY3QtbGludXgt
OAoKMjAxNC0wNy0yMi0yMTo1NTo1MyAwYjZmZTJiOTg4Y2FlZTgwOGYzY2NiNjE2ZmEyMmYy
YTU2YTA0MmU4IGNvbXBpbGluZwpRdWV1ZWQgYnVpbGQgdGFzayB0byAva2J1aWxkLXRlc3Rz
L2J1aWxkLXF1ZXVlL2kzODYtcmFuZGNvbmZpZy1yMi0wNzIyLTBiNmZlMmI5ODhjYWVlODA4
ZjNjY2I2MTZmYTIyZjJhNTZhMDQyZTgKQ2hlY2sgZm9yIGtlcm5lbCBpbiAva2VybmVsL2kz
ODYtcmFuZGNvbmZpZy1yMi0wNzIyLzBiNmZlMmI5ODhjYWVlODA4ZjNjY2I2MTZmYTIyZjJh
NTZhMDQyZTgKd2FpdGluZyBmb3IgY29tcGxldGlvbiBvZiAva2J1aWxkLXRlc3RzL2J1aWxk
LXF1ZXVlL2kzODYtcmFuZGNvbmZpZy1yMi0wNzIyLTBiNmZlMmI5ODhjYWVlODA4ZjNjY2I2
MTZmYTIyZjJhNTZhMDQyZTgKa2VybmVsOiAva2VybmVsL2kzODYtcmFuZGNvbmZpZy1yMi0w
NzIyLzBiNmZlMmI5ODhjYWVlODA4ZjNjY2I2MTZmYTIyZjJhNTZhMDQyZTgvdm1saW51ei0z
LjE2LjAtcmM2LTAwMDM5LWcwYjZmZTJiCgoyMDE0LTA3LTIyLTIxOjU3OjUzIGRldGVjdGlu
ZyBib290IHN0YXRlIAkyMCBTVUNDRVNTCgpCaXNlY3Rpbmc6IDI5IHJldmlzaW9ucyBsZWZ0
IHRvIHRlc3QgYWZ0ZXIgdGhpcyAocm91Z2hseSA1IHN0ZXBzKQpbZDEyNzI0MGQ0MzM4MGU5
ZTE0NjNmZDhjZGUwMTM0Zjg1YjY2YzI2MV0gTWVyZ2UgJ2xpbnV4LXN0aS9zdGktZHQtZm9y
LXYzLjE3LTEnIGludG8gZGV2ZWwtcm9hbS1pMzg2LTIwMTQwNzIyMjEwNwpydW5uaW5nIC9j
L2tlcm5lbC10ZXN0cy9iaXNlY3QtdGVzdC1ib290LWZhaWx1cmUuc2ggL2MvYm9vdC1iaXNl
Y3QvbGludXgtOC9vYmotYmlzZWN0CmxzIC1hIC9rYnVpbGQtdGVzdHMvcnVuLXF1ZXVlL2t2
bS9pMzg2LXJhbmRjb25maWctcjItMDcyMi9saW51eC1kZXZlbDpkZXZlbC1yb2FtLWkzODYt
MjAxNDA3MjIyMTA3OmQxMjcyNDBkNDMzODBlOWUxNDYzZmQ4Y2RlMDEzNGY4NWI2NmMyNjE6
YmlzZWN0LWxpbnV4LTgKCjIwMTQtMDctMjItMjE6NTg6MjQgZDEyNzI0MGQ0MzM4MGU5ZTE0
NjNmZDhjZGUwMTM0Zjg1YjY2YzI2MSBjb21waWxpbmcKUXVldWVkIGJ1aWxkIHRhc2sgdG8g
L2tidWlsZC10ZXN0cy9idWlsZC1xdWV1ZS9pMzg2LXJhbmRjb25maWctcjItMDcyMi1kMTI3
MjQwZDQzMzgwZTllMTQ2M2ZkOGNkZTAxMzRmODViNjZjMjYxCkNoZWNrIGZvciBrZXJuZWwg
aW4gL2tlcm5lbC9pMzg2LXJhbmRjb25maWctcjItMDcyMi9kMTI3MjQwZDQzMzgwZTllMTQ2
M2ZkOGNkZTAxMzRmODViNjZjMjYxCndhaXRpbmcgZm9yIGNvbXBsZXRpb24gb2YgL2tidWls
ZC10ZXN0cy9idWlsZC1xdWV1ZS9pMzg2LXJhbmRjb25maWctcjItMDcyMi1kMTI3MjQwZDQz
MzgwZTllMTQ2M2ZkOGNkZTAxMzRmODViNjZjMjYxCmtlcm5lbDogL2tlcm5lbC9pMzg2LXJh
bmRjb25maWctcjItMDcyMi9kMTI3MjQwZDQzMzgwZTllMTQ2M2ZkOGNkZTAxMzRmODViNjZj
MjYxL3ZtbGludXotMy4xNi4wLXJjNi0wMDA1Ny1nZDEyNzI0MAoKMjAxNC0wNy0yMi0yMjow
MDoyNCBkZXRlY3RpbmcgYm9vdCBzdGF0ZSAJMjAgU1VDQ0VTUwoKQmlzZWN0aW5nOiAxMSBy
ZXZpc2lvbnMgbGVmdCB0byB0ZXN0IGFmdGVyIHRoaXMgKHJvdWdobHkgNCBzdGVwcykKWzE3
MTNiMTI2MzZiM2RhYWI3ZWEyNjI1ZWZhMzc2MTE5YzdiNDkwZGVdIE1lcmdlICdkdmRocm0v
Zm9wcycgaW50byBkZXZlbC1yb2FtLWkzODYtMjAxNDA3MjIyMTA3CnJ1bm5pbmcgL2Mva2Vy
bmVsLXRlc3RzL2Jpc2VjdC10ZXN0LWJvb3QtZmFpbHVyZS5zaCAvYy9ib290LWJpc2VjdC9s
aW51eC04L29iai1iaXNlY3QKbHMgLWEgL2tidWlsZC10ZXN0cy9ydW4tcXVldWUva3ZtL2kz
ODYtcmFuZGNvbmZpZy1yMi0wNzIyL2xpbnV4LWRldmVsOmRldmVsLXJvYW0taTM4Ni0yMDE0
MDcyMjIxMDc6MTcxM2IxMjYzNmIzZGFhYjdlYTI2MjVlZmEzNzYxMTljN2I0OTBkZTpiaXNl
Y3QtbGludXgtOAoKMjAxNC0wNy0yMi0yMjowMDo1NCAxNzEzYjEyNjM2YjNkYWFiN2VhMjYy
NWVmYTM3NjExOWM3YjQ5MGRlIGNvbXBpbGluZwpRdWV1ZWQgYnVpbGQgdGFzayB0byAva2J1
aWxkLXRlc3RzL2J1aWxkLXF1ZXVlL2kzODYtcmFuZGNvbmZpZy1yMi0wNzIyLTE3MTNiMTI2
MzZiM2RhYWI3ZWEyNjI1ZWZhMzc2MTE5YzdiNDkwZGUKQ2hlY2sgZm9yIGtlcm5lbCBpbiAv
a2VybmVsL2kzODYtcmFuZGNvbmZpZy1yMi0wNzIyLzE3MTNiMTI2MzZiM2RhYWI3ZWEyNjI1
ZWZhMzc2MTE5YzdiNDkwZGUKd2FpdGluZyBmb3IgY29tcGxldGlvbiBvZiAva2J1aWxkLXRl
c3RzL2J1aWxkLXF1ZXVlL2kzODYtcmFuZGNvbmZpZy1yMi0wNzIyLTE3MTNiMTI2MzZiM2Rh
YWI3ZWEyNjI1ZWZhMzc2MTE5YzdiNDkwZGUKa2VybmVsOiAva2VybmVsL2kzODYtcmFuZGNv
bmZpZy1yMi0wNzIyLzE3MTNiMTI2MzZiM2RhYWI3ZWEyNjI1ZWZhMzc2MTE5YzdiNDkwZGUv
dm1saW51ei0zLjE2LjAtcmM2LTAwMDY3LWcxNzEzYjEyCgoyMDE0LTA3LTIyLTIyOjAzOjU0
IGRldGVjdGluZyBib290IHN0YXRlIAkxIFRFU1QgRkFJTFVSRQpbICAgIDMuNDkyNzk1XSBk
ZWJ1ZzogdW5tYXBwaW5nIGluaXQgW21lbSAweGI1ZWJkMDAwLTB4YjVmMGVmZmZdClsgICAg
My40OTM2NjldIFdyaXRlIHByb3RlY3RpbmcgdGhlIGtlcm5lbCB0ZXh0OiA2NjQwawpbICAg
IDMuNDk0MzQ1XSBXcml0ZSBwcm90ZWN0aW5nIHRoZSBrZXJuZWwgcmVhZC1vbmx5IGRhdGE6
IDQwMTJrClsgICAgMy40OTU1ODRdIEJVRzogdW5hYmxlIHRvIGhhbmRsZSBrZXJuZWwgTlVM
TCBwb2ludGVyIGRlcmVmZXJlbmNlIGF0IDAwMDAwMTA0ClsgICAgMy40OTYwNDRdIElQOiBb
PGI1MjgxZDk1Pl0gZ2V0X3VubWFwcGVkX2FyZWErMHgzYS8weGM2ClsgICAgMy40OTYwNDRd
ICpwZGUgPSAwMDAwMDAwMCAKWyAgICAzLjQ5NjA0NF0gT29wczogMDAwMCBbIzFdIERFQlVH
X1BBR0VBTExPQwpbICAgIDMuNDk2MDQ0XSBDUFU6IDAgUElEOiAxIENvbW06IGluaXQgTm90
IHRhaW50ZWQgMy4xNi4wLXJjNi0wMDA2Ny1nMTcxM2IxMiAjMwpbICAgIDMuNDk2MDQ0XSB0
YXNrOiBiMDAzMDAxMCB0aTogYjAwMzIwMDAgdGFzay50aTogYjAwMzIwMDAKWyAgICAzLjQ5
NjA0NF0gRUlQOiAwMDYwOls8YjUyODFkOTU+XSBFRkxBR1M6IDAwMDEwMjQ2IENQVTogMApb
ICAgIDMuNDk2MDQ0XSBFSVAgaXMgYXQgZ2V0X3VubWFwcGVkX2FyZWErMHgzYS8weGM2Clsg
ICAgMy40OTYwNDRdIEVBWDogYzI5MGZkYzAgRUJYOiAwMDAwMDAwMCBFQ1g6IDAwMDAzMDAw
IEVEWDogMDAwMDAwMDAKWyAgICAzLjQ5NjA0NF0gRVNJOiAwMDAwMzAwMCBFREk6IGI1Mjgx
ZjA4IEVCUDogYjAwMzNlYWMgRVNQOiBiMDAzM2U5YwpbICAgIDMuNDk2MDQ0XSAgRFM6IDAw
N2IgRVM6IDAwN2IgRlM6IDAwMDAgR1M6IDAwMDAgU1M6IDAwNjgKWyAgICAzLjQ5NjA0NF0g
Q1IwOiA4MDA1MDAzMyBDUjI6IDAwMDAwMTA0IENSMzogMTI5MTAwMDAgQ1I0OiAwMDA0MDY5
MApbICAgIDMuNDk2MDQ0XSBTdGFjazoKWyAgICAzLjQ5NjA0NF0gIDQ3ZTc3Y2MwIDQ3ZTc3
Y2MwIGI1ODdmMTk4IGIwMDMwMDEwIGIwMDMzZWQwIGI1MjFiZmY1IDAwMDAwMDAwIDAwMDAw
MDAwClsgICAgMy40OTYwNDRdICBjMjkwZmUxYyBjMjkwZmRjMCA0N2U3N2NjMCA0N2U3Njdj
OCBjMjhmYjI4MCBiMDAzM2Y1MCBiNTJiNWQ3MiBiMDAzMjAwMApbICAgIDMuNDk2MDQ0XSAg
MDAwMDIwMDAgMDAwMDAwMDYgMDAwMWQwMDAgMDAwMDAwMDAgMDAwMDAwMDEgNDdlNzdjYzAg
MDgwNGZhZDQgMDgwNGYwMDAKWyAgICAzLjQ5NjA0NF0gQ2FsbCBUcmFjZToKWyAgICAzLjQ5
NjA0NF0gIFs8YjUyMWJmZjU+XSBhcmNoX3NldHVwX2FkZGl0aW9uYWxfcGFnZXMrMHg0ZS8w
eDE4OApbICAgIDMuNDk2MDQ0XSAgWzxiNTJiNWQ3Mj5dIGxvYWRfZWxmX2JpbmFyeSsweDlj
NS8weGZmNwpbICAgIDMuNDk2MDQ0XSAgWzxiNTI5NTU3OD5dIHNlYXJjaF9iaW5hcnlfaGFu
ZGxlcisweDQxLzB4OTUKWyAgICAzLjQ5NjA0NF0gIFs8YjUyOTU5NDg+XSBkb19leGVjdmUr
MHgzN2MvMHg0OGEKWyAgICAzLjQ5NjA0NF0gIFs8YjUyMDAzNWM+XSBydW5faW5pdF9wcm9j
ZXNzKzB4MWMvMHgxZQpbICAgIDMuNDk2MDQ0XSAgWzxiNTg2YWE3Nj5dIGtlcm5lbF9pbml0
KzB4MzQvMHhiOApbICAgIDMuNDk2MDQ0XSAgWzxiNTg3YWNjMD5dIHJldF9mcm9tX2tlcm5l
bF90aHJlYWQrMHgyMC8weDMwClsgICAgMy40OTYwNDRdICBbPGI1ODZhYTQyPl0gPyByZXN0
X2luaXQrMHgxMGUvMHgxMGUKWyAgICAzLjQ5NjA0NF0gQ29kZTogNzYgMGEgYjkgZjQgZmYg
ZmYgZmYgZTkgYTEgMDAgMDAgMDAgODkgYzMgYTEgMjAgYTkgYzcgYjUgOGIgODAgMTAgMDIg
MDAgMDAgODUgZGIgOGIgNzggMGMgNzQgMGIgOGIgNDMgMTQgOGIgNDAgNTggODUgYzAgMGYg
NDUgZjggPDgzPiBiYiAwNCAwMSAwMCAwMCAwMCA3NCAzMSA4OSBkOCA4OSA1NSBmMCBlOCBm
NyBlYSBmZiBmZiBiOSBlZApbICAgIDMuNDk2MDQ0XSBFSVA6IFs8YjUyODFkOTU+XSBnZXRf
dW5tYXBwZWRfYXJlYSsweDNhLzB4YzYgU1M6RVNQIDAwNjg6YjAwMzNlOWMKWyAgICAzLjQ5
NjA0NF0gQ1IyOiAwMDAwMDAwMDAwMDAwMTA0ClsgICAgMy41MjcwMzRdIC0tLVsgZW5kIHRy
YWNlIDUwYzY4ZGQ5ZThhN2U5OTggXS0tLQpbICAgIDMuNTI3NjExXSBLZXJuZWwgcGFuaWMg
LSBub3Qgc3luY2luZzogRmF0YWwgZXhjZXB0aW9uCi9rZXJuZWwvaTM4Ni1yYW5kY29uZmln
LXIyLTA3MjIvMTcxM2IxMjYzNmIzZGFhYjdlYTI2MjVlZmEzNzYxMTljN2I0OTBkZS9kbWVz
Zy15b2N0by12cC0zODoyMDE0MDcyMjIyMDQzMjppMzg2LXJhbmRjb25maWctcjItMDcyMjoz
LjE2LjAtcmM2LTAwMDY3LWcxNzEzYjEyOjMKL2tlcm5lbC9pMzg2LXJhbmRjb25maWctcjIt
MDcyMi8xNzEzYjEyNjM2YjNkYWFiN2VhMjYyNWVmYTM3NjExOWM3YjQ5MGRlL2RtZXNnLXlv
Y3RvLXZwLTc6MjAxNDA3MjIyMjA0MzI6aTM4Ni1yYW5kY29uZmlnLXIyLTA3MjI6My4xNi4w
LXJjNi0wMDA2Ny1nMTcxM2IxMjozCi9rZXJuZWwvaTM4Ni1yYW5kY29uZmlnLXIyLTA3MjIv
MTcxM2IxMjYzNmIzZGFhYjdlYTI2MjVlZmEzNzYxMTljN2I0OTBkZS9kbWVzZy15b2N0by12
cC00NDoyMDE0MDcyMjIyMDQzNTppMzg2LXJhbmRjb25maWctcjItMDcyMjozLjE2LjAtcmM2
LTAwMDY3LWcxNzEzYjEyOjMKL2tlcm5lbC9pMzg2LXJhbmRjb25maWctcjItMDcyMi8xNzEz
YjEyNjM2YjNkYWFiN2VhMjYyNWVmYTM3NjExOWM3YjQ5MGRlL2RtZXNnLXlvY3RvLXZwLTUz
OjIwMTQwNzIyMjIwNDM0OmkzODYtcmFuZGNvbmZpZy1yMi0wNzIyOjMuMTYuMC1yYzYtMDAw
NjctZzE3MTNiMTI6Mwova2VybmVsL2kzODYtcmFuZGNvbmZpZy1yMi0wNzIyLzE3MTNiMTI2
MzZiM2RhYWI3ZWEyNjI1ZWZhMzc2MTE5YzdiNDkwZGUvZG1lc2cteW9jdG8tdnAtNjoyMDE0
MDcyMjIyMDQzNDppMzg2LXJhbmRjb25maWctcjItMDcyMjozLjE2LjAtcmM2LTAwMDY3LWcx
NzEzYjEyOjMKL2tlcm5lbC9pMzg2LXJhbmRjb25maWctcjItMDcyMi8xNzEzYjEyNjM2YjNk
YWFiN2VhMjYyNWVmYTM3NjExOWM3YjQ5MGRlL2RtZXNnLXlvY3RvLWtidWlsZC0xNDoyMDE0
MDcyMjIyMDIzMjppMzg2LXJhbmRjb25maWctcjItMDcyMjozLjE2LjAtcmM2LTAwMDY3LWcx
NzEzYjEyOjMKL2tlcm5lbC9pMzg2LXJhbmRjb25maWctcjItMDcyMi8xNzEzYjEyNjM2YjNk
YWFiN2VhMjYyNWVmYTM3NjExOWM3YjQ5MGRlL2RtZXNnLXlvY3RvLXZwLTEwOjIwMTQwNzIy
MjIwNDQzOmkzODYtcmFuZGNvbmZpZy1yMi0wNzIyOjMuMTYuMC1yYzYtMDAwNjctZzE3MTNi
MTI6Mwova2VybmVsL2kzODYtcmFuZGNvbmZpZy1yMi0wNzIyLzE3MTNiMTI2MzZiM2RhYWI3
ZWEyNjI1ZWZhMzc2MTE5YzdiNDkwZGUvZG1lc2cteW9jdG8tdnAtNjQ6MjAxNDA3MjIyMjA0
NDM6aTM4Ni1yYW5kY29uZmlnLXIyLTA3MjI6My4xNi4wLXJjNi0wMDA2Ny1nMTcxM2IxMjoz
Ci9rZXJuZWwvaTM4Ni1yYW5kY29uZmlnLXIyLTA3MjIvMTcxM2IxMjYzNmIzZGFhYjdlYTI2
MjVlZmEzNzYxMTljN2I0OTBkZS9kbWVzZy15b2N0by12cC05OjIwMTQwNzIyMjIwNDQzOmkz
ODYtcmFuZGNvbmZpZy1yMi0wNzIyOjMuMTYuMC1yYzYtMDAwNjctZzE3MTNiMTI6MwowOjk6
MTAgYWxsX2dvb2Q6YmFkOmFsbF9iYWQgYm9vdHMKG1sxOzM1bTIwMTQtMDctMjIgMjI6MDQ6
MjUgUkVQRUFUIENPVU5UOiAyMSAgIyAvYy9ib290LWJpc2VjdC9saW51eC04L29iai1iaXNl
Y3QvLnJlcGVhdBtbMG0KCmxpbmVhci1iaXNlY3Q6IGJhZCBicmFuY2ggbWF5IGJlIGR2ZGhy
bS9mb3BzCmxpbmVhci1iaXNlY3Q6IGhhbmRsZSBvdmVyIHRvIGdpdCBiaXNlY3QKbGluZWFy
LWJpc2VjdDogZ2l0IGJpc2VjdCBzdGFydCAxNzEzYjEyNjM2YjNkYWFiN2VhMjYyNWVmYTM3
NjExOWM3YjQ5MGRlIGQxMjcyNDBkNDMzODBlOWUxNDYzZmQ4Y2RlMDEzNGY4NWI2NmMyNjEg
LS0KUHJldmlvdXMgSEVBRCBwb3NpdGlvbiB3YXMgMTcxM2IxMi4uLiBNZXJnZSAnZHZkaHJt
L2ZvcHMnIGludG8gZGV2ZWwtcm9hbS1pMzg2LTIwMTQwNzIyMjEwNwpIRUFEIGlzIG5vdyBh
dCBiNGQzMzE4Li4uIE1lcmdlIHJlbW90ZS10cmFja2luZyBicmFuY2ggJ2NyeXB0by9tYXN0
ZXInCkJpc2VjdGluZzogNCByZXZpc2lvbnMgbGVmdCB0byB0ZXN0IGFmdGVyIHRoaXMgKHJv
dWdobHkgMiBzdGVwcykKWzQ3NzAyYzdjNGM5YzFlODUxNGNhNTJlMzY3Y2YwYjcxZTUwMTc3
ZjhdIGthY3RpdmU6IG1ha2Uga2VybmZzICJhY3RpdmUtcmVmIiBnZW5lcmljCmxpbmVhci1i
aXNlY3Q6IGdpdCBiaXNlY3QgcnVuIC9jL2tlcm5lbC10ZXN0cy9iaXNlY3QtdGVzdC1ib290
LWZhaWx1cmUuc2ggL2MvYm9vdC1iaXNlY3QvbGludXgtOC9vYmotYmlzZWN0CnJ1bm5pbmcg
L2Mva2VybmVsLXRlc3RzL2Jpc2VjdC10ZXN0LWJvb3QtZmFpbHVyZS5zaCAvYy9ib290LWJp
c2VjdC9saW51eC04L29iai1iaXNlY3QKbHMgLWEgL2tidWlsZC10ZXN0cy9ydW4tcXVldWUv
a3ZtL2kzODYtcmFuZGNvbmZpZy1yMi0wNzIyL2xpbnV4LWRldmVsOmRldmVsLXJvYW0taTM4
Ni0yMDE0MDcyMjIxMDc6NDc3MDJjN2M0YzljMWU4NTE0Y2E1MmUzNjdjZjBiNzFlNTAxNzdm
ODpiaXNlY3QtbGludXgtOAoKMjAxNC0wNy0yMi0yMjowNDoyOCA0NzcwMmM3YzRjOWMxZTg1
MTRjYTUyZTM2N2NmMGI3MWU1MDE3N2Y4IGNvbXBpbGluZwpRdWV1ZWQgYnVpbGQgdGFzayB0
byAva2J1aWxkLXRlc3RzL2J1aWxkLXF1ZXVlL2kzODYtcmFuZGNvbmZpZy1yMi0wNzIyLTQ3
NzAyYzdjNGM5YzFlODUxNGNhNTJlMzY3Y2YwYjcxZTUwMTc3ZjgKQ2hlY2sgZm9yIGtlcm5l
bCBpbiAva2VybmVsL2kzODYtcmFuZGNvbmZpZy1yMi0wNzIyLzQ3NzAyYzdjNGM5YzFlODUx
NGNhNTJlMzY3Y2YwYjcxZTUwMTc3ZjgKd2FpdGluZyBmb3IgY29tcGxldGlvbiBvZiAva2J1
aWxkLXRlc3RzL2J1aWxkLXF1ZXVlL2kzODYtcmFuZGNvbmZpZy1yMi0wNzIyLTQ3NzAyYzdj
NGM5YzFlODUxNGNhNTJlMzY3Y2YwYjcxZTUwMTc3ZjgKd2FpdGluZyBmb3IgY29tcGxldGlv
biBvZiAva2J1aWxkLXRlc3RzL2J1aWxkLXF1ZXVlL2pha2V0b3duLWNvbnN1bWVyL2kzODYt
cmFuZGNvbmZpZy1yMi0wNzIyLTQ3NzAyYzdjNGM5YzFlODUxNGNhNTJlMzY3Y2YwYjcxZTUw
MTc3ZjgKa2VybmVsOiAva2VybmVsL2kzODYtcmFuZGNvbmZpZy1yMi0wNzIyLzQ3NzAyYzdj
NGM5YzFlODUxNGNhNTJlMzY3Y2YwYjcxZTUwMTc3Zjgvdm1saW51ei0zLjE2LjAtcmM1LTAw
MjMwLWc0NzcwMmM3CgoyMDE0LTA3LTIyLTIyOjA4OjI4IGRldGVjdGluZyBib290IHN0YXRl
IC4uCTIJMjEgU1VDQ0VTUwoKQmlzZWN0aW5nOiAyIHJldmlzaW9ucyBsZWZ0IHRvIHRlc3Qg
YWZ0ZXIgdGhpcyAocm91Z2hseSAxIHN0ZXApClszNGU2YjdkZWE4YmIyYzM1OWMyOWQ0YjAw
MjE5NjdjNmRlMGYxYjdhXSBmczogdHJhY2sgZm9wcy1kZXB0aCBpbiB0YXNrX3N0cnVjdApy
dW5uaW5nIC9jL2tlcm5lbC10ZXN0cy9iaXNlY3QtdGVzdC1ib290LWZhaWx1cmUuc2ggL2Mv
Ym9vdC1iaXNlY3QvbGludXgtOC9vYmotYmlzZWN0CmxzIC1hIC9rYnVpbGQtdGVzdHMvcnVu
LXF1ZXVlL2t2bS9pMzg2LXJhbmRjb25maWctcjItMDcyMi9saW51eC1kZXZlbDpkZXZlbC1y
b2FtLWkzODYtMjAxNDA3MjIyMTA3OjM0ZTZiN2RlYThiYjJjMzU5YzI5ZDRiMDAyMTk2N2M2
ZGUwZjFiN2E6YmlzZWN0LWxpbnV4LTgKCjIwMTQtMDctMjItMjI6MTA6NDYgMzRlNmI3ZGVh
OGJiMmMzNTljMjlkNGIwMDIxOTY3YzZkZTBmMWI3YSBjb21waWxpbmcKUXVldWVkIGJ1aWxk
IHRhc2sgdG8gL2tidWlsZC10ZXN0cy9idWlsZC1xdWV1ZS9pMzg2LXJhbmRjb25maWctcjIt
MDcyMi0zNGU2YjdkZWE4YmIyYzM1OWMyOWQ0YjAwMjE5NjdjNmRlMGYxYjdhCkNoZWNrIGZv
ciBrZXJuZWwgaW4gL2tlcm5lbC9pMzg2LXJhbmRjb25maWctcjItMDcyMi8zNGU2YjdkZWE4
YmIyYzM1OWMyOWQ0YjAwMjE5NjdjNmRlMGYxYjdhCndhaXRpbmcgZm9yIGNvbXBsZXRpb24g
b2YgL2tidWlsZC10ZXN0cy9idWlsZC1xdWV1ZS9pMzg2LXJhbmRjb25maWctcjItMDcyMi0z
NGU2YjdkZWE4YmIyYzM1OWMyOWQ0YjAwMjE5NjdjNmRlMGYxYjdhCndhaXRpbmcgZm9yIGNv
bXBsZXRpb24gb2YgL2tidWlsZC10ZXN0cy9idWlsZC1xdWV1ZS9yb2FtLWkzODYvaTM4Ni1y
YW5kY29uZmlnLXIyLTA3MjItMzRlNmI3ZGVhOGJiMmMzNTljMjlkNGIwMDIxOTY3YzZkZTBm
MWI3YQprZXJuZWw6IC9rZXJuZWwvaTM4Ni1yYW5kY29uZmlnLXIyLTA3MjIvMzRlNmI3ZGVh
OGJiMmMzNTljMjlkNGIwMDIxOTY3YzZkZTBmMWI3YS92bWxpbnV6LTMuMTYuMC1yYzUtMDAy
MzItZzM0ZTZiN2QKCjIwMTQtMDctMjItMjI6MTY6NDkgZGV0ZWN0aW5nIGJvb3Qgc3RhdGUg
LiBURVNUIEZBSUxVUkUKWyAgICAzLjM2OTAzOF0gZGVidWc6IHVubWFwcGluZyBpbml0IFtt
ZW0gMHhiYTZiYzAwMC0weGJhNzBkZmZmXQpbICAgIDMuMzY5OTMzXSBXcml0ZSBwcm90ZWN0
aW5nIHRoZSBrZXJuZWwgdGV4dDogNjY0MGsKWyAgICAzLjM3MDc4NV0gV3JpdGUgcHJvdGVj
dGluZyB0aGUga2VybmVsIHJlYWQtb25seSBkYXRhOiA0MDA4awpbICAgIDMuMzcyMTE2XSBC
VUc6IHVuYWJsZSB0byBoYW5kbGUga2VybmVsIE5VTEwgcG9pbnRlciBkZXJlZmVyZW5jZSBh
dCAwMDAwMDEwNApbICAgIDMuMzczMDE1XSBJUDogWzxiOWE4MWRhOD5dIGdldF91bm1hcHBl
ZF9hcmVhKzB4M2EvMHhjNgpbICAgIDMuMzczMDE1XSAqcGRlID0gMDAwMDAwMDAgClsgICAg
My4zNzMwMTVdIE9vcHM6IDAwMDAgWyMxXSBERUJVR19QQUdFQUxMT0MKWyAgICAzLjM3MzAx
NV0gQ1BVOiAwIFBJRDogMSBDb21tOiBpbml0IE5vdCB0YWludGVkIDMuMTYuMC1yYzUtMDAy
MzItZzM0ZTZiN2QgIzIwMgpbICAgIDMuMzczMDE1XSB0YXNrOiBiMDAzMDAxMCB0aTogYjAw
MzIwMDAgdGFzay50aTogYjAwMzIwMDAKWyAgICAzLjM3MzAxNV0gRUlQOiAwMDYwOls8Yjlh
ODFkYTg+XSBFRkxBR1M6IDAwMDEwMjQ2IENQVTogMApbICAgIDMuMzczMDE1XSBFSVAgaXMg
YXQgZ2V0X3VubWFwcGVkX2FyZWErMHgzYS8weGM2ClsgICAgMy4zNzMwMTVdIEVBWDogYzI5
MTNkYzAgRUJYOiAwMDAwMDAwMCBFQ1g6IDAwMDAzMDAwIEVEWDogMDAwMDAwMDAKWyAgICAz
LjM3MzAxNV0gRVNJOiAwMDAwMzAwMCBFREk6IGI5YTgxZjFiIEVCUDogYjAwMzNlYWMgRVNQ
OiBiMDAzM2U5YwpbICAgIDMuMzczMDE1XSAgRFM6IDAwN2IgRVM6IDAwN2IgRlM6IDAwMDAg
R1M6IDAwMDAgU1M6IDAwNjgKWyAgICAzLjM3MzAxNV0gQ1IwOiA4MDA1MDAzMyBDUjI6IDAw
MDAwMTA0IENSMzogMTI5MTQwMDAgQ1I0OiAwMDA0MDY5MApbICAgIDMuMzczMDE1XSBTdGFj
azoKWyAgICAzLjM3MzAxNV0gIDQ3ZTc3Y2MwIDQ3ZTc3Y2MwIGJhMDdmMTkwIGIwMDMwMDEw
IGIwMDMzZWQwIGI5YTFiZmY1IDAwMDAwMDAwIDAwMDAwMDAwClsgICAgMy4zNzMwMTVdICBj
MjkxM2UxYyBjMjkxM2RjMCA0N2U3N2NjMCA0N2U3NjdjOCBjMjhmYTI4MCBiMDAzM2Y1MCBi
OWFiNWQ4NSBiMDAzMjAwMApbICAgIDMuMzczMDE1XSAgMDAwMDIwMDAgMDAwMDAwMDYgMDAw
MWQwMDAgMDAwMDAwMDAgMDAwMDAwMDEgNDdlNzdjYzAgMDgwNGZhZDQgMDgwNGYwMDAKWyAg
ICAzLjM3MzAxNV0gQ2FsbCBUcmFjZToKWyAgICAzLjM3MzAxNV0gIFs8YjlhMWJmZjU+XSBh
cmNoX3NldHVwX2FkZGl0aW9uYWxfcGFnZXMrMHg0ZS8weDE4OApbICAgIDMuMzczMDE1XSAg
WzxiOWFiNWQ4NT5dIGxvYWRfZWxmX2JpbmFyeSsweDljNS8weGZmNwpbICAgIDMuMzczMDE1
XSAgWzxiOWE5NTU4Yj5dIHNlYXJjaF9iaW5hcnlfaGFuZGxlcisweDQxLzB4OTUKWyAgICAz
LjM3MzAxNV0gIFs8YjlhOTU5NWI+XSBkb19leGVjdmUrMHgzN2MvMHg0OGEKWyAgICAzLjM3
MzAxNV0gIFs8YjlhMDAzNWM+XSBydW5faW5pdF9wcm9jZXNzKzB4MWMvMHgxZQpbICAgIDMu
MzczMDE1XSAgWzxiYTA2YTViNj5dIGtlcm5lbF9pbml0KzB4MzQvMHhiOApbICAgIDMuMzcz
MDE1XSAgWzxiYTA3YTgwMD5dIHJldF9mcm9tX2tlcm5lbF90aHJlYWQrMHgyMC8weDMwClsg
ICAgMy4zNzMwMTVdICBbPGJhMDZhNTgyPl0gPyByZXN0X2luaXQrMHgxMGUvMHgxMGUKWyAg
ICAzLjM3MzAxNV0gQ29kZTogNzYgMGEgYjkgZjQgZmYgZmYgZmYgZTkgYTEgMDAgMDAgMDAg
ODkgYzMgYTEgMjAgODkgNDcgYmEgOGIgODAgMTAgMDIgMDAgMDAgODUgZGIgOGIgNzggMGMg
NzQgMGIgOGIgNDMgMTQgOGIgNDAgNTggODUgYzAgMGYgNDUgZjggPDgzPiBiYiAwNCAwMSAw
MCAwMCAwMCA3NCAzMSA4OSBkOCA4OSA1NSBmMCBlOCBmNyBlYSBmZiBmZiBiOSBlZApbICAg
IDMuMzczMDE1XSBFSVA6IFs8YjlhODFkYTg+XSBnZXRfdW5tYXBwZWRfYXJlYSsweDNhLzB4
YzYgU1M6RVNQIDAwNjg6YjAwMzNlOWMKWyAgICAzLjM3MzAxNV0gQ1IyOiAwMDAwMDAwMDAw
MDAwMTA0ClsgICAgMy4zOTU4OTldIC0tLVsgZW5kIHRyYWNlIDczNzViMzJjZGJhZjcwOTEg
XS0tLQpbICAgIDMuMzk2NTE5XSBLZXJuZWwgcGFuaWMgLSBub3Qgc3luY2luZzogRmF0YWwg
ZXhjZXB0aW9uCi9rZXJuZWwvaTM4Ni1yYW5kY29uZmlnLXIyLTA3MjIvMzRlNmI3ZGVhOGJi
MmMzNTljMjlkNGIwMDIxOTY3YzZkZTBmMWI3YS9kbWVzZy15b2N0by1rYnVpbGQtMTQ6MjAx
NDA3MjIyMjE0MjM6aTM4Ni1yYW5kY29uZmlnLXIyLTA3MjI6My4xNi4wLXJjNS0wMDIzMi1n
MzRlNmI3ZDoyMDIKL2tlcm5lbC9pMzg2LXJhbmRjb25maWctcjItMDcyMi8zNGU2YjdkZWE4
YmIyYzM1OWMyOWQ0YjAwMjE5NjdjNmRlMGYxYjdhL2RtZXNnLXlvY3RvLWtidWlsZC0xODoy
MDE0MDcyMjIyMTQyNjppMzg2LXJhbmRjb25maWctcjItMDcyMjozLjE2LjAtcmM1LTAwMjMy
LWczNGU2YjdkOjIwMgova2VybmVsL2kzODYtcmFuZGNvbmZpZy1yMi0wNzIyLzM0ZTZiN2Rl
YThiYjJjMzU5YzI5ZDRiMDAyMTk2N2M2ZGUwZjFiN2EvZG1lc2cteW9jdG8ta2J1aWxkLTE6
MjAxNDA3MjIyMjE0MjQ6aTM4Ni1yYW5kY29uZmlnLXIyLTA3MjI6My4xNi4wLXJjNS0wMDIz
Mi1nMzRlNmI3ZDoyMDIKL2tlcm5lbC9pMzg2LXJhbmRjb25maWctcjItMDcyMi8zNGU2Yjdk
ZWE4YmIyYzM1OWMyOWQ0YjAwMjE5NjdjNmRlMGYxYjdhL2RtZXNnLXlvY3RvLWtidWlsZC0y
MDoyMDE0MDcyMjIyMTQyMzppMzg2LXJhbmRjb25maWctcjItMDcyMjozLjE2LjAtcmM1LTAw
MjMyLWczNGU2YjdkOjIwMgova2VybmVsL2kzODYtcmFuZGNvbmZpZy1yMi0wNzIyLzM0ZTZi
N2RlYThiYjJjMzU5YzI5ZDRiMDAyMTk2N2M2ZGUwZjFiN2EvZG1lc2cteW9jdG8ta2J1aWxk
LTIxOjIwMTQwNzIyMjIxNDIyOmkzODYtcmFuZGNvbmZpZy1yMi0wNzIyOjMuMTYuMC1yYzUt
MDAyMzItZzM0ZTZiN2Q6MjAyCi9rZXJuZWwvaTM4Ni1yYW5kY29uZmlnLXIyLTA3MjIvMzRl
NmI3ZGVhOGJiMmMzNTljMjlkNGIwMDIxOTY3YzZkZTBmMWI3YS9kbWVzZy15b2N0by1rYnVp
bGQtMjI6MjAxNDA3MjIyMjE0MjY6aTM4Ni1yYW5kY29uZmlnLXIyLTA3MjI6My4xNi4wLXJj
NS0wMDIzMi1nMzRlNmI3ZDoyMDIKL2tlcm5lbC9pMzg2LXJhbmRjb25maWctcjItMDcyMi8z
NGU2YjdkZWE4YmIyYzM1OWMyOWQ0YjAwMjE5NjdjNmRlMGYxYjdhL2RtZXNnLXlvY3RvLWti
dWlsZC0yNToyMDE0MDcyMjIyMTQyNTppMzg2LXJhbmRjb25maWctcjItMDcyMjozLjE2LjAt
cmM1LTAwMjMyLWczNGU2YjdkOjIwMgova2VybmVsL2kzODYtcmFuZGNvbmZpZy1yMi0wNzIy
LzM0ZTZiN2RlYThiYjJjMzU5YzI5ZDRiMDAyMTk2N2M2ZGUwZjFiN2EvZG1lc2cteW9jdG8t
a2J1aWxkLTI3OjIwMTQwNzIyMjIxNDI1OmkzODYtcmFuZGNvbmZpZy1yMi0wNzIyOjMuMTYu
MC1yYzUtMDAyMzItZzM0ZTZiN2Q6MjAyCi9rZXJuZWwvaTM4Ni1yYW5kY29uZmlnLXIyLTA3
MjIvMzRlNmI3ZGVhOGJiMmMzNTljMjlkNGIwMDIxOTY3YzZkZTBmMWI3YS9kbWVzZy15b2N0
by1rYnVpbGQtMzE6MjAxNDA3MjIyMjE0MjI6aTM4Ni1yYW5kY29uZmlnLXIyLTA3MjI6My4x
Ni4wLXJjNS0wMDIzMi1nMzRlNmI3ZDoyMDIKL2tlcm5lbC9pMzg2LXJhbmRjb25maWctcjIt
MDcyMi8zNGU2YjdkZWE4YmIyYzM1OWMyOWQ0YjAwMjE5NjdjNmRlMGYxYjdhL2RtZXNnLXlv
Y3RvLWtidWlsZC02OjIwMTQwNzIyMjIxNDI0OmkzODYtcmFuZGNvbmZpZy1yMi0wNzIyOjMu
MTYuMC1yYzUtMDAyMzItZzM0ZTZiN2Q6MjAyCi9rZXJuZWwvaTM4Ni1yYW5kY29uZmlnLXIy
LTA3MjIvMzRlNmI3ZGVhOGJiMmMzNTljMjlkNGIwMDIxOTY3YzZkZTBmMWI3YS9kbWVzZy15
b2N0by1rYnVpbGQtMTY6MjAxNDA3MjIyMjE0MzE6aTM4Ni1yYW5kY29uZmlnLXIyLTA3MjI6
My4xNi4wLXJjNS0wMDIzMi1nMzRlNmI3ZDoyMDIKL2tlcm5lbC9pMzg2LXJhbmRjb25maWct
cjItMDcyMi8zNGU2YjdkZWE4YmIyYzM1OWMyOWQ0YjAwMjE5NjdjNmRlMGYxYjdhL2RtZXNn
LXlvY3RvLWtidWlsZC0xOToyMDE0MDcyMjIyMTQzMTppMzg2LXJhbmRjb25maWctcjItMDcy
MjozLjE2LjAtcmM1LTAwMjMyLWczNGU2YjdkOjIwMgova2VybmVsL2kzODYtcmFuZGNvbmZp
Zy1yMi0wNzIyLzM0ZTZiN2RlYThiYjJjMzU5YzI5ZDRiMDAyMTk2N2M2ZGUwZjFiN2EvZG1l
c2cteW9jdG8ta2J1aWxkLTI2OjIwMTQwNzIyMjIxNDMxOmkzODYtcmFuZGNvbmZpZy1yMi0w
NzIyOjMuMTYuMC1yYzUtMDAyMzItZzM0ZTZiN2Q6MjAyCi9rZXJuZWwvaTM4Ni1yYW5kY29u
ZmlnLXIyLTA3MjIvMzRlNmI3ZGVhOGJiMmMzNTljMjlkNGIwMDIxOTY3YzZkZTBmMWI3YS9k
bWVzZy15b2N0by1rYnVpbGQtMzI6MjAxNDA3MjIyMjE0MzE6aTM4Ni1yYW5kY29uZmlnLXIy
LTA3MjI6My4xNi4wLXJjNS0wMDIzMi1nMzRlNmI3ZDoyMDIKL2tlcm5lbC9pMzg2LXJhbmRj
b25maWctcjItMDcyMi8zNGU2YjdkZWE4YmIyYzM1OWMyOWQ0YjAwMjE5NjdjNmRlMGYxYjdh
L2RtZXNnLXlvY3RvLWtidWlsZC0xMDoyMDE0MDcyMjIyMTQzMTppMzg2LXJhbmRjb25maWct
cjItMDcyMjozLjE2LjAtcmM1LTAwMjMyLWczNGU2YjdkOjIwMgova2VybmVsL2kzODYtcmFu
ZGNvbmZpZy1yMi0wNzIyLzM0ZTZiN2RlYThiYjJjMzU5YzI5ZDRiMDAyMTk2N2M2ZGUwZjFi
N2EvZG1lc2cteW9jdG8ta2J1aWxkLTExOjIwMTQwNzIyMjIxNDMxOmkzODYtcmFuZGNvbmZp
Zy1yMi0wNzIyOjMuMTYuMC1yYzUtMDAyMzItZzM0ZTZiN2Q6MjAyCi9rZXJuZWwvaTM4Ni1y
YW5kY29uZmlnLXIyLTA3MjIvMzRlNmI3ZGVhOGJiMmMzNTljMjlkNGIwMDIxOTY3YzZkZTBm
MWI3YS9kbWVzZy15b2N0by1rYnVpbGQtMTU6MjAxNDA3MjIyMjE0MzY6aTM4Ni1yYW5kY29u
ZmlnLXIyLTA3MjI6My4xNi4wLXJjNS0wMDIzMi1nMzRlNmI3ZDoyMDIKL2tlcm5lbC9pMzg2
LXJhbmRjb25maWctcjItMDcyMi8zNGU2YjdkZWE4YmIyYzM1OWMyOWQ0YjAwMjE5NjdjNmRl
MGYxYjdhL2RtZXNnLXlvY3RvLWtidWlsZC0zMToyMDE0MDcyMjIyMTQzNDppMzg2LXJhbmRj
b25maWctcjItMDcyMjozLjE2LjAtcmM1LTAwMjMyLWczNGU2YjdkOjIwMgova2VybmVsL2kz
ODYtcmFuZGNvbmZpZy1yMi0wNzIyLzM0ZTZiN2RlYThiYjJjMzU5YzI5ZDRiMDAyMTk2N2M2
ZGUwZjFiN2EvZG1lc2cteW9jdG8ta2J1aWxkLTM6MjAxNDA3MjIyMjE0MzI6aTM4Ni1yYW5k
Y29uZmlnLXIyLTA3MjI6My4xNi4wLXJjNS0wMDIzMi1nMzRlNmI3ZDoyMDIKL2tlcm5lbC9p
Mzg2LXJhbmRjb25maWctcjItMDcyMi8zNGU2YjdkZWE4YmIyYzM1OWMyOWQ0YjAwMjE5Njdj
NmRlMGYxYjdhL2RtZXNnLXlvY3RvLWtidWlsZC03OjIwMTQwNzIyMjIxNDM2OmkzODYtcmFu
ZGNvbmZpZy1yMi0wNzIyOjMuMTYuMC1yYzUtMDAyMzItZzM0ZTZiN2Q6MjAyCi9rZXJuZWwv
aTM4Ni1yYW5kY29uZmlnLXIyLTA3MjIvMzRlNmI3ZGVhOGJiMmMzNTljMjlkNGIwMDIxOTY3
YzZkZTBmMWI3YS9kbWVzZy15b2N0by1rYnVpbGQtOToyMDE0MDcyMjIyMTQzNTppMzg2LXJh
bmRjb25maWctcjItMDcyMjozLjE2LjAtcmM1LTAwMjMyLWczNGU2YjdkOjIwMgowOjIxOjIx
IGFsbF9nb29kOmJhZDphbGxfYmFkIGJvb3RzCgpCaXNlY3Rpbmc6IDAgcmV2aXNpb25zIGxl
ZnQgdG8gdGVzdCBhZnRlciB0aGlzIChyb3VnaGx5IDAgc3RlcHMpCltiYzJkNTEwNTI1NDAz
NDc3ODAzNDQ4N2Q4ZjNhZWM0MmRiMmE1Mjg1XSBmczogYWRkIGFjdGl2ZSByZWZlcmVuY2Ug
Y291bnRlciB0byAic3RydWN0IGZpbGUiCnJ1bm5pbmcgL2Mva2VybmVsLXRlc3RzL2Jpc2Vj
dC10ZXN0LWJvb3QtZmFpbHVyZS5zaCAvYy9ib290LWJpc2VjdC9saW51eC04L29iai1iaXNl
Y3QKbHMgLWEgL2tidWlsZC10ZXN0cy9ydW4tcXVldWUva3ZtL2kzODYtcmFuZGNvbmZpZy1y
Mi0wNzIyL2xpbnV4LWRldmVsOmRldmVsLXJvYW0taTM4Ni0yMDE0MDcyMjIxMDc6YmMyZDUx
MDUyNTQwMzQ3NzgwMzQ0ODdkOGYzYWVjNDJkYjJhNTI4NTpiaXNlY3QtbGludXgtOAoKMjAx
NC0wNy0yMi0yMjoxNzoyMSBiYzJkNTEwNTI1NDAzNDc3ODAzNDQ4N2Q4ZjNhZWM0MmRiMmE1
Mjg1IGNvbXBpbGluZwpRdWV1ZWQgYnVpbGQgdGFzayB0byAva2J1aWxkLXRlc3RzL2J1aWxk
LXF1ZXVlL2kzODYtcmFuZGNvbmZpZy1yMi0wNzIyLWJjMmQ1MTA1MjU0MDM0Nzc4MDM0NDg3
ZDhmM2FlYzQyZGIyYTUyODUKQ2hlY2sgZm9yIGtlcm5lbCBpbiAva2VybmVsL2kzODYtcmFu
ZGNvbmZpZy1yMi0wNzIyL2JjMmQ1MTA1MjU0MDM0Nzc4MDM0NDg3ZDhmM2FlYzQyZGIyYTUy
ODUKd2FpdGluZyBmb3IgY29tcGxldGlvbiBvZiAva2J1aWxkLXRlc3RzL2J1aWxkLXF1ZXVl
L2kzODYtcmFuZGNvbmZpZy1yMi0wNzIyLWJjMmQ1MTA1MjU0MDM0Nzc4MDM0NDg3ZDhmM2Fl
YzQyZGIyYTUyODUKd2FpdGluZyBmb3IgY29tcGxldGlvbiBvZiAva2J1aWxkLXRlc3RzL2J1
aWxkLXF1ZXVlL2pha2V0b3duLWNvbnN1bWVyL2kzODYtcmFuZGNvbmZpZy1yMi0wNzIyLWJj
MmQ1MTA1MjU0MDM0Nzc4MDM0NDg3ZDhmM2FlYzQyZGIyYTUyODUKa2VybmVsOiAva2VybmVs
L2kzODYtcmFuZGNvbmZpZy1yMi0wNzIyL2JjMmQ1MTA1MjU0MDM0Nzc4MDM0NDg3ZDhmM2Fl
YzQyZGIyYTUyODUvdm1saW51ei0zLjE2LjAtcmM1LTAwMjMxLWdiYzJkNTEwCgoyMDE0LTA3
LTIyLTIyOjIzOjIxIGRldGVjdGluZyBib290IHN0YXRlIC4gVEVTVCBGQUlMVVJFClsgICAg
Mi42OTA0NzldIGRlYnVnOiB1bm1hcHBpbmcgaW5pdCBbbWVtIDB4YmY2YmUwMDAtMHhiZjcw
ZmZmZl0KWyAgICAyLjY5MTEyOF0gV3JpdGUgcHJvdGVjdGluZyB0aGUga2VybmVsIHRleHQ6
IDY2NDBrClsgICAgMi42OTE2NDFdIFdyaXRlIHByb3RlY3RpbmcgdGhlIGtlcm5lbCByZWFk
LW9ubHkgZGF0YTogNDAxMmsKWyAgICAyLjY5MjQ5Ml0gQlVHOiB1bmFibGUgdG8gaGFuZGxl
IGtlcm5lbCBOVUxMIHBvaW50ZXIgZGVyZWZlcmVuY2UgYXQgMDAwMDAxMDQKWyAgICAyLjY5
MzIxMl0gSVA6IFs8YmVhODFkM2U+XSBnZXRfdW5tYXBwZWRfYXJlYSsweDQwLzB4ZWYKWyAg
ICAyLjY5MzIxNF0gKnBkZSA9IDAwMDAwMDAwIApbICAgIDIuNjkzMjE0XSBPb3BzOiAwMDAw
IFsjMV0gREVCVUdfUEFHRUFMTE9DClsgICAgMi42OTMyMTRdIENQVTogMCBQSUQ6IDEgQ29t
bTogaW5pdCBOb3QgdGFpbnRlZCAzLjE2LjAtcmM1LTAwMjMxLWdiYzJkNTEwICMyClsgICAg
Mi42OTMyMTRdIHRhc2s6IGIwMDMwMDEwIHRpOiBiMDAzMjAwMCB0YXNrLnRpOiBiMDAzMjAw
MApbICAgIDIuNjkzMjE0XSBFSVA6IDAwNjA6WzxiZWE4MWQzZT5dIEVGTEFHUzogMDAwMTAy
NDYgQ1BVOiAwClsgICAgMi42OTMyMTRdIEVJUCBpcyBhdCBnZXRfdW5tYXBwZWRfYXJlYSsw
eDQwLzB4ZWYKWyAgICAyLjY5MzIxNF0gRUFYOiBiYjE3M2RjMCBFQlg6IDAwMDAwMDAwIEVD
WDogMDAwMDMwMDAgRURYOiAwMDAwMDAwMApbICAgIDIuNjkzMjE0XSBFU0k6IGJmMDdmMTk4
IEVESTogYmVhODFlZDQgRUJQOiBiMDAzM2VhYyBFU1A6IGIwMDMzZTk4ClsgICAgMi42OTMy
MTRdICBEUzogMDA3YiBFUzogMDA3YiBGUzogMDAwMCBHUzogMDAwMCBTUzogMDA2OApbICAg
IDIuNjkzMjE0XSBDUjA6IDgwMDUwMDNiIENSMjogMDAwMDAxMDQgQ1IzOiAwYjE3NDAwMCBD
UjQ6IDAwMDAwNjkwClsgICAgMi42OTMyMTRdIFN0YWNrOgpbICAgIDIuNjkzMjE0XSAgMDAw
MDAwMDAgMDAwMDMwMDAgMDAwMjBjYTAgYmYwN2YxOTggYjAwMzAwMTAgYjAwMzNlZDAgYmVh
MWJmZjUgMDAwMDAwMDAKWyAgICAyLjY5MzIxNF0gIDAwMDAwMDAwIGJiMTczZTFjIGJiMTcz
ZGMwIDAwMDIwY2EwIGE3NmVkNjA4IGJiMTVkMjgwIGIwMDMzZjUwIGJlYWI1ZDZjClsgICAg
Mi42OTMyMTRdICBiMDAzMjAwMCAwMDAwMjAwMCAwMDAwMDAwNyAwMDAxZjAwMCAwMDAwMDAw
MCAwMDAwMDAwMSAwMDAyMGNhMCAwMDAyZjI3YwpbICAgIDIuNjkzMjE0XSBDYWxsIFRyYWNl
OgpbICAgIDIuNjkzMjE0XSAgWzxiZWExYmZmNT5dIGFyY2hfc2V0dXBfYWRkaXRpb25hbF9w
YWdlcysweDRlLzB4MTg4ClsgICAgMi42OTMyMTRdICBbPGJlYWI1ZDZjPl0gbG9hZF9lbGZf
YmluYXJ5KzB4OWM1LzB4ZmY3ClsgICAgMi42OTMyMTRdICBbPGJlYTk1NTg1Pl0gc2VhcmNo
X2JpbmFyeV9oYW5kbGVyKzB4NDEvMHg5NQpbICAgIDIuNjkzMjE0XSAgWzxiZWE5NTk1NT5d
IGRvX2V4ZWN2ZSsweDM3Yy8weDQ4YQpbICAgIDIuNjkzMjE0XSAgWzxiZWEwMDM1Yz5dIHJ1
bl9pbml0X3Byb2Nlc3MrMHgxYy8weDFlClsgICAgMi42OTMyMTRdICBbPGJmMDZhNTg2Pl0g
a2VybmVsX2luaXQrMHgzNC8weGI4ClsgICAgMi42OTMyMTRdICBbPGJmMDdhN2MwPl0gcmV0
X2Zyb21fa2VybmVsX3RocmVhZCsweDIwLzB4MzAKWyAgICAyLjY5MzIxNF0gIFs8YmYwNmE1
NTI+XSA/IHJlc3RfaW5pdCsweDEwZS8weDEwZQpbICAgIDIuNjkzMjE0XSBDb2RlOiA3NiAw
YSBiZSBmNCBmZiBmZiBmZiBlOSBjNCAwMCAwMCAwMCA4OSBjMyBhMSAyMCBhOSA0NyBiZiA4
YiA4MCAxMCAwMiAwMCAwMCA4NSBkYiA4YiA3OCAwYyA3NCAwYiA4YiA0MyAxNCA4YiA0MCA1
OCA4NSBjMCAwZiA0NSBmOCA8OGI+IGIzIDA0IDAxIDAwIDAwIDg1IGY2IDc0IDU0IDgzIGM2
IDE0IDMxIGM5IDhkIDQxIDAxIDg5IGMyIDg5ClsgICAgMi42OTMyMTRdIEVJUDogWzxiZWE4
MWQzZT5dIGdldF91bm1hcHBlZF9hcmVhKzB4NDAvMHhlZiBTUzpFU1AgMDA2ODpiMDAzM2U5
OApbICAgIDIuNjkzMjE0XSBDUjI6IDAwMDAwMDAwMDAwMDAxMDQKWyAgICAyLjcwOTUxNl0g
LS0tWyBlbmQgdHJhY2UgYmZjMzhmZDk0Yjk2ZWVhMyBdLS0tClsgICAgMi43MDk5NjBdIEtl
cm5lbCBwYW5pYyAtIG5vdCBzeW5jaW5nOiBGYXRhbCBleGNlcHRpb24KL2tlcm5lbC9pMzg2
LXJhbmRjb25maWctcjItMDcyMi9iYzJkNTEwNTI1NDAzNDc3ODAzNDQ4N2Q4ZjNhZWM0MmRi
MmE1Mjg1L2RtZXNnLXlvY3RvLXZwLTY6MjAxNDA3MjIyMjIzMTY6aTM4Ni1yYW5kY29uZmln
LXIyLTA3MjI6My4xNi4wLXJjNS0wMDIzMS1nYmMyZDUxMDoyCi9rZXJuZWwvaTM4Ni1yYW5k
Y29uZmlnLXIyLTA3MjIvYmMyZDUxMDUyNTQwMzQ3NzgwMzQ0ODdkOGYzYWVjNDJkYjJhNTI4
NS9kbWVzZy15b2N0by12cC0yMzoyMDE0MDcyMjIyMjMxNjppMzg2LXJhbmRjb25maWctcjIt
MDcyMjozLjE2LjAtcmM1LTAwMjMxLWdiYzJkNTEwOjIKL2tlcm5lbC9pMzg2LXJhbmRjb25m
aWctcjItMDcyMi9iYzJkNTEwNTI1NDAzNDc3ODAzNDQ4N2Q4ZjNhZWM0MmRiMmE1Mjg1L2Rt
ZXNnLXlvY3RvLXZwLTYxOjIwMTQwNzIyMjIyMzE2OmkzODYtcmFuZGNvbmZpZy1yMi0wNzIy
OjMuMTYuMC1yYzUtMDAyMzEtZ2JjMmQ1MTA6Mgova2VybmVsL2kzODYtcmFuZGNvbmZpZy1y
Mi0wNzIyL2JjMmQ1MTA1MjU0MDM0Nzc4MDM0NDg3ZDhmM2FlYzQyZGIyYTUyODUvZG1lc2ct
cXVhbnRhbC1pdmI0MS0xMTE6MjAxNDA3MjIyMjIyMzI6aTM4Ni1yYW5kY29uZmlnLXIyLTA3
MjI6Ogova2VybmVsL2kzODYtcmFuZGNvbmZpZy1yMi0wNzIyL2JjMmQ1MTA1MjU0MDM0Nzc4
MDM0NDg3ZDhmM2FlYzQyZGIyYTUyODUvZG1lc2ctcXVhbnRhbC1rYnVpbGQtMTE6MjAxNDA3
MjIyMjIxMTI6aTM4Ni1yYW5kY29uZmlnLXIyLTA3MjI6My4xNi4wLXJjNS0wMDIzMS1nYmMy
ZDUxMDoyCi9rZXJuZWwvaTM4Ni1yYW5kY29uZmlnLXIyLTA3MjIvYmMyZDUxMDUyNTQwMzQ3
NzgwMzQ0ODdkOGYzYWVjNDJkYjJhNTI4NS9kbWVzZy1xdWFudGFsLWtidWlsZC0xODoyMDE0
MDcyMjIyMjExMDppMzg2LXJhbmRjb25maWctcjItMDcyMjozLjE2LjAtcmM1LTAwMjMxLWdi
YzJkNTEwOjIKL2tlcm5lbC9pMzg2LXJhbmRjb25maWctcjItMDcyMi9iYzJkNTEwNTI1NDAz
NDc3ODAzNDQ4N2Q4ZjNhZWM0MmRiMmE1Mjg1L2RtZXNnLXF1YW50YWwta2J1aWxkLTI2OjIw
MTQwNzIyMjIyMTEyOmkzODYtcmFuZGNvbmZpZy1yMi0wNzIyOjMuMTYuMC1yYzUtMDAyMzEt
Z2JjMmQ1MTA6Mgova2VybmVsL2kzODYtcmFuZGNvbmZpZy1yMi0wNzIyL2JjMmQ1MTA1MjU0
MDM0Nzc4MDM0NDg3ZDhmM2FlYzQyZGIyYTUyODUvZG1lc2ctcXVhbnRhbC1rYnVpbGQtMzoy
MDE0MDcyMjIyMjExMzppMzg2LXJhbmRjb25maWctcjItMDcyMjozLjE2LjAtcmM1LTAwMjMx
LWdiYzJkNTEwOjIKL2tlcm5lbC9pMzg2LXJhbmRjb25maWctcjItMDcyMi9iYzJkNTEwNTI1
NDAzNDc3ODAzNDQ4N2Q4ZjNhZWM0MmRiMmE1Mjg1L2RtZXNnLXF1YW50YWwta2J1aWxkLTg6
MjAxNDA3MjIyMjIxMTE6aTM4Ni1yYW5kY29uZmlnLXIyLTA3MjI6My4xNi4wLXJjNS0wMDIz
MS1nYmMyZDUxMDoyCi9rZXJuZWwvaTM4Ni1yYW5kY29uZmlnLXIyLTA3MjIvYmMyZDUxMDUy
NTQwMzQ3NzgwMzQ0ODdkOGYzYWVjNDJkYjJhNTI4NS9kbWVzZy1xdWFudGFsLWtidWlsZC05
OjIwMTQwNzIyMjIyMTEyOmkzODYtcmFuZGNvbmZpZy1yMi0wNzIyOjMuMTYuMC1yYzUtMDAy
MzEtZ2JjMmQ1MTA6Mgova2VybmVsL2kzODYtcmFuZGNvbmZpZy1yMi0wNzIyL2JjMmQ1MTA1
MjU0MDM0Nzc4MDM0NDg3ZDhmM2FlYzQyZGIyYTUyODUvZG1lc2cteW9jdG8taXZiNDEtNTA6
MjAxNDA3MjIyMjIyMzI6aTM4Ni1yYW5kY29uZmlnLXIyLTA3MjI6Ogova2VybmVsL2kzODYt
cmFuZGNvbmZpZy1yMi0wNzIyL2JjMmQ1MTA1MjU0MDM0Nzc4MDM0NDg3ZDhmM2FlYzQyZGIy
YTUyODUvZG1lc2cteW9jdG8taXZiNDEtNjI6MjAxNDA3MjIyMjIyMzA6aTM4Ni1yYW5kY29u
ZmlnLXIyLTA3MjI6Ogova2VybmVsL2kzODYtcmFuZGNvbmZpZy1yMi0wNzIyL2JjMmQ1MTA1
MjU0MDM0Nzc4MDM0NDg3ZDhmM2FlYzQyZGIyYTUyODUvZG1lc2cteW9jdG8taXZiNDEtNzoy
MDE0MDcyMjIyMjIzMDppMzg2LXJhbmRjb25maWctcjItMDcyMjo6Ci9rZXJuZWwvaTM4Ni1y
YW5kY29uZmlnLXIyLTA3MjIvYmMyZDUxMDUyNTQwMzQ3NzgwMzQ0ODdkOGYzYWVjNDJkYjJh
NTI4NS9kbWVzZy15b2N0by12cC0xNToyMDE0MDcyMjIyMjMxNzppMzg2LXJhbmRjb25maWct
cjItMDcyMjozLjE2LjAtcmM1LTAwMjMxLWdiYzJkNTEwOjIKL2tlcm5lbC9pMzg2LXJhbmRj
b25maWctcjItMDcyMi9iYzJkNTEwNTI1NDAzNDc3ODAzNDQ4N2Q4ZjNhZWM0MmRiMmE1Mjg1
L2RtZXNnLXlvY3RvLXZwLTIxOjIwMTQwNzIyMjIyMzE4OmkzODYtcmFuZGNvbmZpZy1yMi0w
NzIyOjMuMTYuMC1yYzUtMDAyMzEtZ2JjMmQ1MTA6Mgova2VybmVsL2kzODYtcmFuZGNvbmZp
Zy1yMi0wNzIyL2JjMmQ1MTA1MjU0MDM0Nzc4MDM0NDg3ZDhmM2FlYzQyZGIyYTUyODUvZG1l
c2cteW9jdG8tdnAtMjI6MjAxNDA3MjIyMjIzMTg6aTM4Ni1yYW5kY29uZmlnLXIyLTA3MjI6
My4xNi4wLXJjNS0wMDIzMS1nYmMyZDUxMDoyCi9rZXJuZWwvaTM4Ni1yYW5kY29uZmlnLXIy
LTA3MjIvYmMyZDUxMDUyNTQwMzQ3NzgwMzQ0ODdkOGYzYWVjNDJkYjJhNTI4NS9kbWVzZy15
b2N0by12cC0zNDoyMDE0MDcyMjIyMjMxODppMzg2LXJhbmRjb25maWctcjItMDcyMjozLjE2
LjAtcmM1LTAwMjMxLWdiYzJkNTEwOjIKL2tlcm5lbC9pMzg2LXJhbmRjb25maWctcjItMDcy
Mi9iYzJkNTEwNTI1NDAzNDc3ODAzNDQ4N2Q4ZjNhZWM0MmRiMmE1Mjg1L2RtZXNnLXlvY3Rv
LXZwLTM1OjIwMTQwNzIyMjIyMzE3OmkzODYtcmFuZGNvbmZpZy1yMi0wNzIyOjMuMTYuMC1y
YzUtMDAyMzEtZ2JjMmQ1MTA6Mgova2VybmVsL2kzODYtcmFuZGNvbmZpZy1yMi0wNzIyL2Jj
MmQ1MTA1MjU0MDM0Nzc4MDM0NDg3ZDhmM2FlYzQyZGIyYTUyODUvZG1lc2cteW9jdG8tdnAt
NDU6MjAxNDA3MjIyMjIzMTc6aTM4Ni1yYW5kY29uZmlnLXIyLTA3MjI6My4xNi4wLXJjNS0w
MDIzMS1nYmMyZDUxMDoyCi9rZXJuZWwvaTM4Ni1yYW5kY29uZmlnLXIyLTA3MjIvYmMyZDUx
MDUyNTQwMzQ3NzgwMzQ0ODdkOGYzYWVjNDJkYjJhNTI4NS9kbWVzZy15b2N0by12cC01NDoy
MDE0MDcyMjIyMjMxNzppMzg2LXJhbmRjb25maWctcjItMDcyMjozLjE2LjAtcmM1LTAwMjMx
LWdiYzJkNTEwOjIKL2tlcm5lbC9pMzg2LXJhbmRjb25maWctcjItMDcyMi9iYzJkNTEwNTI1
NDAzNDc3ODAzNDQ4N2Q4ZjNhZWM0MmRiMmE1Mjg1L2RtZXNnLXlvY3RvLXZwLTg6MjAxNDA3
MjIyMjIzMTg6aTM4Ni1yYW5kY29uZmlnLXIyLTA3MjI6My4xNi4wLXJjNS0wMDIzMS1nYmMy
ZDUxMDoyCjA6MjE6MjEgYWxsX2dvb2Q6YmFkOmFsbF9iYWQgYm9vdHMKCmJjMmQ1MTA1MjU0
MDM0Nzc4MDM0NDg3ZDhmM2FlYzQyZGIyYTUyODUgaXMgdGhlIGZpcnN0IGJhZCBjb21taXQK
Y29tbWl0IGJjMmQ1MTA1MjU0MDM0Nzc4MDM0NDg3ZDhmM2FlYzQyZGIyYTUyODUKQXV0aG9y
OiBEYXZpZCBIZXJybWFubiA8ZGguaGVycm1hbm5AZ21haWwuY29tPgpEYXRlOiAgIFR1ZSBK
dW4gMTcgMjI6MTA6MTIgMjAxNCArMDIwMAoKICAgIGZzOiBhZGQgYWN0aXZlIHJlZmVyZW5j
ZSBjb3VudGVyIHRvICJzdHJ1Y3QgZmlsZSIKICAgIAogICAgVGhpcyBhZGRzIGFuIGthY3Rp
dmUgcmVmZXJlbmNlIGNvdW50ZXIgdG8gInN0cnVjdCBmaWxlIi4gVGhpcyBhbGxvd3MgdG8K
ICAgIGFjcXVpcmUgYWN0aXZlIHJlZmVyZW5jZXMgb24gYW55IGZpbGUgdGhhdCBlbmFibGVk
IGl0LiBGdXJ0aGVybW9yZSwgYWxsCiAgICBmaWxlLT5mX29wLT54eSgpIGNhbGxiYWNrcyBh
cmUgbW9kaWZpZWQgdG8gYWNxdWlyZSBhbiBhY3RpdmUgcmVmZXJlbmNlCiAgICBiZWZvcmUg
ZW50ZXJpbmcgYW5kIGRyb3BwaW5nIGl0IGFmdGVyd2FyZHMuCiAgICAKICAgIERyaXZlcnMg
aGF2ZSB0byBvcHQtaW4gdG8gZW5hYmxlIHRoaXMgZmVhdHVyZS4gQnkgdXNpbmcgZm9wc19m
aWxlX2F0dGFjaCgpCiAgICBpbiB0aGUgLT5vcGVuKCkgY2FsbGJhY2ssIHRoZXkgY2FuIGVu
YWJsZSB0aGUgYWN0aXZlLWNvdW50ZXIgb24gdGhlIGZpbGUuCiAgICBGcm9tIG5vdyBvbiB0
aGV5IGNhbiB1c2UgZm9wc19maWxlX2Rpc2FibGUoKSBhbmQgZm9wc19maWxlX2RyYWluKCkg
dG8KICAgIHByZXZlbnQgYW55IG5ldyBhY3RpdmUtcmVmZXJlbmNlcyBmcm9tIGJlaW5nIGFj
cXVpcmVkIGFuZCB3YWl0aW5nIGZvciBhbGwKICAgIHRob3NlIHRvIGJlIHJlbGVhc2VkLgog
ICAgCiAgICBBbGwgdGhvc2UgcHJvdGVjdGVkIGZpbGVzIGhhdmUgdG8gYmUgbGlua2VkIHRv
IGEgcGFyZW50IGRldmljZSAoY2FsbGVkCiAgICAic3RydWN0IGZvcHNfZGV2aWNlIikuIEEg
ZHJpdmVyIGhhcyB0byBhbGxvY2F0ZSBhbmQgbWFuYWdlIHRob3NlLiBUaGUKICAgIHBhcmVu
dCBkZXZpY2UgY2FuIGJlIHVzZWQgdG8gYXRvbWljYWxseSBkaXNhYmxlIGFuZCBkcmFpbiBh
bGwgbGlua2VkCiAgICBmaWxlcy4KICAgIAogICAgU2lnbmVkLW9mZi1ieTogRGF2aWQgSGVy
cm1hbm4gPGRoLmhlcnJtYW5uQGdtYWlsLmNvbT4KCjowNDAwMDAgMDQwMDAwIGE4YWE2Njk5
YmZhYjAwMmU4MTc0ZWUwYzJlYTY2ZTM5ZTAwYzVjNjggN2FjN2VlMWVhYmUyZmZlZDBlYjNj
ZTM0ZDRlMWYxOWMwYTU0ZWI3MCBNCWZzCjowNDAwMDAgMDQwMDAwIGE3OGUzZDYyMGE4Nzg1
NjY5OGQxYjcwNTVjYWI4ZWE3ZTIwMmE1YzcgYTIyNjIyMjQxMzQ4Yzk4ZjNjNTRjYWY0ZWNh
NDRjNzE0ODVkMjNmMiBNCWluY2x1ZGUKYmlzZWN0IHJ1biBzdWNjZXNzClByZXZpb3VzIEhF
QUQgcG9zaXRpb24gd2FzIGJjMmQ1MTAuLi4gZnM6IGFkZCBhY3RpdmUgcmVmZXJlbmNlIGNv
dW50ZXIgdG8gInN0cnVjdCBmaWxlIgpIRUFEIGlzIG5vdyBhdCA0NzcwMmM3Li4uIGthY3Rp
dmU6IG1ha2Uga2VybmZzICJhY3RpdmUtcmVmIiBnZW5lcmljCmxzIC1hIC9rYnVpbGQtdGVz
dHMvcnVuLXF1ZXVlL2t2bS9pMzg2LXJhbmRjb25maWctcjItMDcyMi9saW51eC1kZXZlbDpk
ZXZlbC1yb2FtLWkzODYtMjAxNDA3MjIyMTA3OjQ3NzAyYzdjNGM5YzFlODUxNGNhNTJlMzY3
Y2YwYjcxZTUwMTc3Zjg6YmlzZWN0LWxpbnV4LTgKCjIwMTQtMDctMjItMjI6MjM6NTUgNDc3
MDJjN2M0YzljMWU4NTE0Y2E1MmUzNjdjZjBiNzFlNTAxNzdmOCByZXVzZSAva2VybmVsL2kz
ODYtcmFuZGNvbmZpZy1yMi0wNzIyLzQ3NzAyYzdjNGM5YzFlODUxNGNhNTJlMzY3Y2YwYjcx
ZTUwMTc3Zjgvdm1saW51ei0zLjE2LjAtcmM1LTAwMjMwLWc0NzcwMmM3CgoyMDE0LTA3LTIy
LTIyOjIzOjU1IGRldGVjdGluZyBib290IHN0YXRlIAkyNAkzNgk1NQk2MyBTVUNDRVNTCgpQ
cmV2aW91cyBIRUFEIHBvc2l0aW9uIHdhcyA0NzcwMmM3Li4uIGthY3RpdmU6IG1ha2Uga2Vy
bmZzICJhY3RpdmUtcmVmIiBnZW5lcmljCkhFQUQgaXMgbm93IGF0IDk4OGE3Y2MuLi4gMGRh
eSBoZWFkIGd1YXJkIGZvciAnZGV2ZWwtcm9hbS1pMzg2LTIwMTQwNzIyMjEwNycKbHMgLWEg
L2tidWlsZC10ZXN0cy9ydW4tcXVldWUva3ZtL2kzODYtcmFuZGNvbmZpZy1yMi0wNzIyL2xp
bnV4LWRldmVsOmRldmVsLXJvYW0taTM4Ni0yMDE0MDcyMjIxMDc6OTg4YTdjY2U5Y2YyODFk
ODk1NGFmNGY0MjE0MTk3MTNlMmQ2NDk5YTpiaXNlY3QtbGludXgtOAogVEVTVCBGQUlMVVJF
ClsgICAgNi4zNTQ3ODFdIGRlYnVnOiB1bm1hcHBpbmcgaW5pdCBbbWVtIDB4YmJjYmIwMDAt
MHhiYmQwY2ZmZl0KWyAgICA2LjM1NTkyM10gV3JpdGUgcHJvdGVjdGluZyB0aGUga2VybmVs
IHRleHQ6IDY2NDBrClsgICAgNi4zNTY4MzBdIFdyaXRlIHByb3RlY3RpbmcgdGhlIGtlcm5l
bCByZWFkLW9ubHkgZGF0YTogNDAwOGsKWyAgICA2LjM1ODI4M10gQlVHOiB1bmFibGUgdG8g
aGFuZGxlIGtlcm5lbCBOVUxMIHBvaW50ZXIgZGVyZWZlcmVuY2UgYXQgMDAwMDAxMDQKWyAg
ICA2LjM1OTAxNV0gSVA6IFs8YmIwODFkOTU+XSBnZXRfdW5tYXBwZWRfYXJlYSsweDNhLzB4
YzYKWyAgICA2LjM1OTAxNV0gKnBkZSA9IDAwMDAwMDAwIApbICAgIDYuMzU5MDE1XSBPb3Bz
OiAwMDAwIFsjMV0gREVCVUdfUEFHRUFMTE9DClsgICAgNi4zNTkwMTVdIENQVTogMCBQSUQ6
IDEgQ29tbTogaW5pdCBOb3QgdGFpbnRlZCAzLjE2LjAtcmM2LTAwMDUxLWc5ODhhN2NjICMx
ODUKWyAgICA2LjM1OTAxNV0gdGFzazogYjAwMzAwMTAgdGk6IGIwMDMyMDAwIHRhc2sudGk6
IGIwMDMyMDAwClsgICAgNi4zNTkwMTVdIEVJUDogMDA2MDpbPGJiMDgxZDk1Pl0gRUZMQUdT
OiAwMDAxMDI0NiBDUFU6IDAKWyAgICA2LjM1OTAxNV0gRUlQIGlzIGF0IGdldF91bm1hcHBl
ZF9hcmVhKzB4M2EvMHhjNgpbICAgIDYuMzU5MDE1XSBFQVg6IGJjOTdhZGMwIEVCWDogMDAw
MDAwMDAgRUNYOiAwMDAwMzAwMCBFRFg6IDAwMDAwMDAwClsgICAgNi4zNTkwMTVdIEVTSTog
MDAwMDMwMDAgRURJOiBiYjA4MWYwOCBFQlA6IGIwMDMzZWFjIEVTUDogYjAwMzNlOWMKWyAg
ICA2LjM1OTAxNV0gIERTOiAwMDdiIEVTOiAwMDdiIEZTOiAwMDAwIEdTOiAwMDAwIFNTOiAw
MDY4ClsgICAgNi4zNTkwMTVdIENSMDogODAwNTAwMzMgQ1IyOiAwMDAwMDEwNCBDUjM6IDBj
OTdiMDAwIENSNDogMDAwNDA2OTAKWyAgICA2LjM1OTAxNV0gU3RhY2s6ClsgICAgNi4zNTkw
MTVdICAwMDAyMGNhMCAwMDAyMGNhMCBiYjY3ZjE5MCBiMDAzMDAxMCBiMDAzM2VkMCBiYjAx
YmZmNSAwMDAwMDAwMCAwMDAwMDAwMApbICAgIDYuMzU5MDE1XSAgYmM5N2FlMWMgYmM5N2Fk
YzAgMDAwMjBjYTAgYTc3YjA2MDggYmM5NjYyMDAgYjAwMzNmNTAgYmIwYjVkNzIgYjAwMzIw
MDAKWyAgICA2LjM1OTAxNV0gIDAwMDAyMDAwIDAwMDAwMDA3IDAwMDFmMDAwIDAwMDAwMDAw
IDAwMDAwMDAxIDAwMDIwY2EwIDAwMDJmMjdjIDAwMDJlNWQ4ClsgICAgNi4zNTkwMTVdIENh
bGwgVHJhY2U6ClsgICAgNi4zNTkwMTVdICBbPGJiMDFiZmY1Pl0gYXJjaF9zZXR1cF9hZGRp
dGlvbmFsX3BhZ2VzKzB4NGUvMHgxODgKWyAgICA2LjM1OTAxNV0gIFs8YmIwYjVkNzI+XSBs
b2FkX2VsZl9iaW5hcnkrMHg5YzUvMHhmZjcKWyAgICA2LjM1OTAxNV0gIFs8YmIwOTU1Nzg+
XSBzZWFyY2hfYmluYXJ5X2hhbmRsZXIrMHg0MS8weDk1ClsgICAgNi4zNTkwMTVdICBbPGJi
MDk1OTQ4Pl0gZG9fZXhlY3ZlKzB4MzdjLzB4NDhhClsgICAgNi4zNTkwMTVdICBbPGJiMDAw
MzVjPl0gcnVuX2luaXRfcHJvY2VzcysweDFjLzB4MWUKWyAgICA2LjM1OTAxNV0gIFs8YmI2
NmFhNzY+XSBrZXJuZWxfaW5pdCsweDM0LzB4YjgKWyAgICA2LjM1OTAxNV0gIFs8YmI2N2Fj
YzA+XSByZXRfZnJvbV9rZXJuZWxfdGhyZWFkKzB4MjAvMHgzMApbICAgIDYuMzU5MDE1XSAg
WzxiYjY2YWE0Mj5dID8gcmVzdF9pbml0KzB4MTBlLzB4MTBlClsgICAgNi4zNTkwMTVdIENv
ZGU6IDc2IDBhIGI5IGY0IGZmIGZmIGZmIGU5IGExIDAwIDAwIDAwIDg5IGMzIGExIDIwIDg5
IGE3IGJiIDhiIDgwIDEwIDAyIDAwIDAwIDg1IGRiIDhiIDc4IDBjIDc0IDBiIDhiIDQzIDE0
IDhiIDQwIDU4IDg1IGMwIDBmIDQ1IGY4IDw4Mz4gYmIgMDQgMDEgMDAgMDAgMDAgNzQgMzEg
ODkgZDggODkgNTUgZjAgZTggZjcgZWEgZmYgZmYgYjkgZWQKWyAgICA2LjM1OTAxNV0gRUlQ
OiBbPGJiMDgxZDk1Pl0gZ2V0X3VubWFwcGVkX2FyZWErMHgzYS8weGM2IFNTOkVTUCAwMDY4
OmIwMDMzZTljClsgICAgNi4zNTkwMTVdIENSMjogMDAwMDAwMDAwMDAwMDEwNApbICAgIDYu
Mzg4ODY0XSAtLS1bIGVuZCB0cmFjZSAyMGRjYzUwMmFlNzhiYWYyIF0tLS0KWyAgICA2LjM4
OTY0OF0gS2VybmVsIHBhbmljIC0gbm90IHN5bmNpbmc6IEZhdGFsIGV4Y2VwdGlvbgova2Vy
bmVsL2kzODYtcmFuZGNvbmZpZy1yMi0wNzIyLzk4OGE3Y2NlOWNmMjgxZDg5NTRhZjRmNDIx
NDE5NzEzZTJkNjQ5OWEvZG1lc2ctcXVhbnRhbC1rYnVpbGQtMzoyMDE0MDcyMjIxNTA1NTpp
Mzg2LXJhbmRjb25maWctcjItMDcyMjozLjE2LjAtcmM2LTAwMDUxLWc5ODhhN2NjOjE4NQov
a2VybmVsL2kzODYtcmFuZGNvbmZpZy1yMi0wNzIyLzk4OGE3Y2NlOWNmMjgxZDg5NTRhZjRm
NDIxNDE5NzEzZTJkNjQ5OWEvZG1lc2ctcXVhbnRhbC1rYnVpbGQtMzE6MjAxNDA3MjIyMTUw
NTY6aTM4Ni1yYW5kY29uZmlnLXIyLTA3MjI6My4xNi4wLXJjNi0wMDA1MS1nOTg4YTdjYzox
ODUKL2tlcm5lbC9pMzg2LXJhbmRjb25maWctcjItMDcyMi85ODhhN2NjZTljZjI4MWQ4OTU0
YWY0ZjQyMTQxOTcxM2UyZDY0OTlhL2RtZXNnLXF1YW50YWwta2J1aWxkLTU6MjAxNDA3MjIy
MTUwNTY6aTM4Ni1yYW5kY29uZmlnLXIyLTA3MjI6My4xNi4wLXJjNi0wMDA1MS1nOTg4YTdj
YzoxODUKL2tlcm5lbC9pMzg2LXJhbmRjb25maWctcjItMDcyMi85ODhhN2NjZTljZjI4MWQ4
OTU0YWY0ZjQyMTQxOTcxM2UyZDY0OTlhL2RtZXNnLXF1YW50YWwta2J1aWxkLTEyOjIwMTQw
NzIyMjE1MDU2OmkzODYtcmFuZGNvbmZpZy1yMi0wNzIyOjMuMTYuMC1yYzYtMDAwNTEtZzk4
OGE3Y2M6MTg1Ci9rZXJuZWwvaTM4Ni1yYW5kY29uZmlnLXIyLTA3MjIvOTg4YTdjY2U5Y2Yy
ODFkODk1NGFmNGY0MjE0MTk3MTNlMmQ2NDk5YS9kbWVzZy1xdWFudGFsLWtidWlsZC02OjIw
MTQwNzIyMjE1MDUxOmkzODYtcmFuZGNvbmZpZy1yMi0wNzIyOjMuMTYuMC1yYzYtMDAwNTEt
Zzk4OGE3Y2M6MTg1Ci9rZXJuZWwvaTM4Ni1yYW5kY29uZmlnLXIyLTA3MjIvOTg4YTdjY2U5
Y2YyODFkODk1NGFmNGY0MjE0MTk3MTNlMmQ2NDk5YS9kbWVzZy15b2N0by1rYnVpbGQtMToy
MDE0MDcyMjIxNTA0NjppMzg2LXJhbmRjb25maWctcjItMDcyMjozLjE2LjAtcmM2LTAwMDUx
LWc5ODhhN2NjOjE4NQova2VybmVsL2kzODYtcmFuZGNvbmZpZy1yMi0wNzIyLzk4OGE3Y2Nl
OWNmMjgxZDg5NTRhZjRmNDIxNDE5NzEzZTJkNjQ5OWEvZG1lc2ctcXVhbnRhbC1rYnVpbGQt
ODoyMDE0MDcyMjIxNTA1NjppMzg2LXJhbmRjb25maWctcjItMDcyMjozLjE2LjAtcmM2LTAw
MDUxLWc5ODhhN2NjOjE4NQova2VybmVsL2kzODYtcmFuZGNvbmZpZy1yMi0wNzIyLzk4OGE3
Y2NlOWNmMjgxZDg5NTRhZjRmNDIxNDE5NzEzZTJkNjQ5OWEvZG1lc2ctcXVhbnRhbC1rYnVp
bGQtMjM6MjAxNDA3MjIyMTUwNTg6aTM4Ni1yYW5kY29uZmlnLXIyLTA3MjI6My4xNi4wLXJj
Ni0wMDA1MS1nOTg4YTdjYzoxODUKL2tlcm5lbC9pMzg2LXJhbmRjb25maWctcjItMDcyMi85
ODhhN2NjZTljZjI4MWQ4OTU0YWY0ZjQyMTQxOTcxM2UyZDY0OTlhL2RtZXNnLXlvY3RvLWti
dWlsZC02OjIwMTQwNzIyMjE1MDQ2OmkzODYtcmFuZGNvbmZpZy1yMi0wNzIyOjMuMTYuMC1y
YzYtMDAwNTEtZzk4OGE3Y2M6MTg1Ci9rZXJuZWwvaTM4Ni1yYW5kY29uZmlnLXIyLTA3MjIv
OTg4YTdjY2U5Y2YyODFkODk1NGFmNGY0MjE0MTk3MTNlMmQ2NDk5YS9kbWVzZy1xdWFudGFs
LWtidWlsZC03OjIwMTQwNzIyMjE1MDU1OmkzODYtcmFuZGNvbmZpZy1yMi0wNzIyOjMuMTYu
MC1yYzYtMDAwNTEtZzk4OGE3Y2M6MTg1Ci9rZXJuZWwvaTM4Ni1yYW5kY29uZmlnLXIyLTA3
MjIvOTg4YTdjY2U5Y2YyODFkODk1NGFmNGY0MjE0MTk3MTNlMmQ2NDk5YS9kbWVzZy15b2N0
by12cC0yOToyMDE0MDcyMjIxMTQ0NjppMzg2LXJhbmRjb25maWctcjItMDcyMjozLjE2LjAt
cmM2LTAwMDUxLWc5ODhhN2NjOjE4NQowOjExOjExIGFsbF9nb29kOmJhZDphbGxfYmFkIGJv
b3RzCgpIRUFEIGlzIG5vdyBhdCA5ODhhN2NjIDBkYXkgaGVhZCBndWFyZCBmb3IgJ2RldmVs
LXJvYW0taTM4Ni0yMDE0MDcyMjIxMDcnCgo9PT09PT09PT0gbGludXMvbWFzdGVyID09PT09
PT09PQpQcmV2aW91cyBIRUFEIHBvc2l0aW9uIHdhcyA5ODhhN2NjLi4uIDBkYXkgaGVhZCBn
dWFyZCBmb3IgJ2RldmVsLXJvYW0taTM4Ni0yMDE0MDcyMjIxMDcnCkhFQUQgaXMgbm93IGF0
IDE1YmEyMjMuLi4gTWVyZ2UgZ2l0Oi8vZ2l0Lmtlcm5lbC5vcmcvcHViL3NjbS9saW51eC9r
ZXJuZWwvZ2l0L2RhdmVtL25ldApscyAtYSAva2J1aWxkLXRlc3RzL3J1bi1xdWV1ZS9rdm0v
aTM4Ni1yYW5kY29uZmlnLXIyLTA3MjIvbGludXM6bWFzdGVyOjE1YmEyMjM2ZjM1NTZmYzAx
YjljYTkxMzk0NDY1MTUyYjVlYTc0YjY6YmlzZWN0LWxpbnV4LTgKCjIwMTQtMDctMjItMjI6
MjY6MDYgMTViYTIyMzZmMzU1NmZjMDFiOWNhOTEzOTQ0NjUxNTJiNWVhNzRiNiByZXVzZSAv
a2VybmVsL2kzODYtcmFuZGNvbmZpZy1yMi0wNzIyLzE1YmEyMjM2ZjM1NTZmYzAxYjljYTkx
Mzk0NDY1MTUyYjVlYTc0YjYvdm1saW51ei0zLjE2LjAtcmM2LTAwMDc1LWcxNWJhMjIzCgoy
MDE0LTA3LTIyLTIyOjI2OjA2IGRldGVjdGluZyBib290IHN0YXRlIAkzMQkzMwk0Mwk2Mi4u
Li4uLi4uLi4uLi4uLi4JNjMgU1VDQ0VTUwoKCj09PT09PT09PSBuZXh0L21hc3RlciA9PT09
PT09PT0KRnJvbSBnaXQ6Ly9naXRtaXJyb3IvbmV4dAogKyAzMThjZDJhLi4uZTBlNjM2ZCBh
a3BtICAgICAgIC0+IG5leHQvYWtwbSAgKGZvcmNlZCB1cGRhdGUpCiArIDY0ZTMyNDUuLi45
ZjJjMjZhIGFrcG0tYmFzZSAgLT4gbmV4dC9ha3BtLWJhc2UgIChmb3JjZWQgdXBkYXRlKQog
KyBhMjA0MTZjLi4uNTk0YThiYiBtYXN0ZXIgICAgIC0+IG5leHQvbWFzdGVyICAoZm9yY2Vk
IHVwZGF0ZSkKICAgMTc5NWNkOS4uZDA1NzE5MCAgc3RhYmxlICAgICAtPiBuZXh0L3N0YWJs
ZQpGcm9tIGdpdDovL2dpdG1pcnJvci9uZXh0CiAqIFtuZXcgdGFnXSAgICAgICAgIG5leHQt
MjAxNDA3MTUgLT4gbmV4dC0yMDE0MDcxNQogKiBbbmV3IHRhZ10gICAgICAgICBuZXh0LTIw
MTQwNzE2IC0+IG5leHQtMjAxNDA3MTYKICogW25ldyB0YWddICAgICAgICAgbmV4dC0yMDE0
MDcxNyAtPiBuZXh0LTIwMTQwNzE3CiAqIFtuZXcgdGFnXSAgICAgICAgIG5leHQtMjAxNDA3
MTggLT4gbmV4dC0yMDE0MDcxOAogKiBbbmV3IHRhZ10gICAgICAgICBuZXh0LTIwMTQwNzIx
IC0+IG5leHQtMjAxNDA3MjEKUHJldmlvdXMgSEVBRCBwb3NpdGlvbiB3YXMgMTViYTIyMy4u
LiBNZXJnZSBnaXQ6Ly9naXQua2VybmVsLm9yZy9wdWIvc2NtL2xpbnV4L2tlcm5lbC9naXQv
ZGF2ZW0vbmV0CkhFQUQgaXMgbm93IGF0IDU5NGE4YmIuLi4gQWRkIGxpbnV4LW5leHQgc3Bl
Y2lmaWMgZmlsZXMgZm9yIDIwMTQwNzIxCmxzIC1hIC9rYnVpbGQtdGVzdHMvcnVuLXF1ZXVl
L2t2bS9pMzg2LXJhbmRjb25maWctcjItMDcyMi9uZXh0Om1hc3Rlcjo1OTRhOGJiY2Q0MTVj
Nzk1ZjU0ZWU4YjA3ZjY0YmEzMTNjYzYwNzRlOmJpc2VjdC1saW51eC04CgoyMDE0LTA3LTIy
LTIyOjM3OjQxIDU5NGE4YmJjZDQxNWM3OTVmNTRlZThiMDdmNjRiYTMxM2NjNjA3NGUgY29t
cGlsaW5nClF1ZXVlZCBidWlsZCB0YXNrIHRvIC9rYnVpbGQtdGVzdHMvYnVpbGQtcXVldWUv
aTM4Ni1yYW5kY29uZmlnLXIyLTA3MjItNTk0YThiYmNkNDE1Yzc5NWY1NGVlOGIwN2Y2NGJh
MzEzY2M2MDc0ZQpDaGVjayBmb3Iga2VybmVsIGluIC9rZXJuZWwvaTM4Ni1yYW5kY29uZmln
LXIyLTA3MjIvNTk0YThiYmNkNDE1Yzc5NWY1NGVlOGIwN2Y2NGJhMzEzY2M2MDc0ZQp3YWl0
aW5nIGZvciBjb21wbGV0aW9uIG9mIC9rYnVpbGQtdGVzdHMvYnVpbGQtcXVldWUvaTM4Ni1y
YW5kY29uZmlnLXIyLTA3MjItNTk0YThiYmNkNDE1Yzc5NWY1NGVlOGIwN2Y2NGJhMzEzY2M2
MDc0ZQpzdGF0dXM6IEZBSUw6IGJ1aWxkIGVycm9yChtbMTszNW0yMDE0LTA3LTIyIDIyOjQx
OjQxIEtlcm5lbCBidWlsZCBmYWlsIG9yIHRpbWVvdXQbWzBtCjIwMTQtMDctMjItMjI6NDE6
NDEgNTk0YThiYmNkNDE1Yzc5NWY1NGVlOGIwN2Y2NGJhMzEzY2M2MDc0ZSBTS0lQIEJST0tF
TiBCVUlMRApDaGVjayAva2J1aWxkLXRlc3RzL2J1aWxkLXNlcnZlZC9pMzg2LXJhbmRjb25m
aWctcjItMDcyMi01OTRhOGJiY2Q0MTVjNzk1ZjU0ZWU4YjA3ZjY0YmEzMTNjYzYwNzRlCg==

--Ah40dssYA/cDqAW1
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="config-3.16.0-rc5-00231-gbc2d510"

#
# Automatically generated file; DO NOT EDIT.
# Linux/i386 3.16.0-rc5 Kernel Configuration
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
CONFIG_X86_32_LAZY_GS=y
CONFIG_ARCH_HWEIGHT_CFLAGS="-fcall-saved-ecx -fcall-saved-edx"
CONFIG_ARCH_SUPPORTS_UPROBES=y
CONFIG_FIX_EARLYCON_MEM=y
CONFIG_DEFCONFIG_LIST="/lib/modules/$UNAME_RELEASE/.config"
CONFIG_IRQ_WORK=y
CONFIG_BUILDTIME_EXTABLE_SORT=y

#
# General setup
#
CONFIG_BROKEN_ON_SMP=y
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
CONFIG_KERNEL_GZIP=y
# CONFIG_KERNEL_BZIP2 is not set
# CONFIG_KERNEL_LZMA is not set
# CONFIG_KERNEL_XZ is not set
# CONFIG_KERNEL_LZO is not set
# CONFIG_KERNEL_LZ4 is not set
CONFIG_DEFAULT_HOSTNAME="(none)"
# CONFIG_SYSVIPC is not set
# CONFIG_POSIX_MQUEUE is not set
CONFIG_CROSS_MEMORY_ATTACH=y
# CONFIG_FHANDLE is not set
CONFIG_USELIB=y
# CONFIG_AUDIT is not set
CONFIG_HAVE_ARCH_AUDITSYSCALL=y

#
# IRQ subsystem
#
CONFIG_GENERIC_IRQ_PROBE=y
CONFIG_GENERIC_IRQ_SHOW=y
CONFIG_GENERIC_IRQ_LEGACY_ALLOC_HWIRQ=y
CONFIG_GENERIC_IRQ_CHIP=y
CONFIG_IRQ_DOMAIN=y
CONFIG_IRQ_DOMAIN_DEBUG=y
CONFIG_IRQ_FORCED_THREADING=y
CONFIG_SPARSE_IRQ=y
CONFIG_CLOCKSOURCE_WATCHDOG=y
CONFIG_ARCH_CLOCKSOURCE_DATA=y
CONFIG_GENERIC_TIME_VSYSCALL=y
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
CONFIG_TICK_CPU_ACCOUNTING=y
# CONFIG_IRQ_TIME_ACCOUNTING is not set
CONFIG_BSD_PROCESS_ACCT=y
CONFIG_BSD_PROCESS_ACCT_V3=y
# CONFIG_TASKSTATS is not set

#
# RCU Subsystem
#
CONFIG_TINY_RCU=y
# CONFIG_PREEMPT_RCU is not set
CONFIG_RCU_STALL_COMMON=y
# CONFIG_TREE_RCU_TRACE is not set
CONFIG_IKCONFIG=y
CONFIG_IKCONFIG_PROC=y
CONFIG_LOG_BUF_SHIFT=17
CONFIG_HAVE_UNSTABLE_SCHED_CLOCK=y
CONFIG_ARCH_WANTS_PROT_NUMA_PROT_NONE=y
CONFIG_CGROUPS=y
# CONFIG_CGROUP_DEBUG is not set
CONFIG_CGROUP_FREEZER=y
CONFIG_CGROUP_DEVICE=y
# CONFIG_CPUSETS is not set
# CONFIG_CGROUP_CPUACCT is not set
CONFIG_RESOURCE_COUNTERS=y
# CONFIG_MEMCG is not set
# CONFIG_CGROUP_HUGETLB is not set
CONFIG_CGROUP_PERF=y
CONFIG_CGROUP_SCHED=y
# CONFIG_FAIR_GROUP_SCHED is not set
# CONFIG_RT_GROUP_SCHED is not set
# CONFIG_CHECKPOINT_RESTORE is not set
CONFIG_NAMESPACES=y
CONFIG_UTS_NS=y
CONFIG_USER_NS=y
# CONFIG_PID_NS is not set
CONFIG_NET_NS=y
# CONFIG_SCHED_AUTOGROUP is not set
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
CONFIG_HAVE_UID16=y
CONFIG_SYSCTL_EXCEPTION_TRACE=y
CONFIG_HAVE_PCSPKR_PLATFORM=y
CONFIG_EXPERT=y
CONFIG_UID16=y
# CONFIG_SGETMASK_SYSCALL is not set
# CONFIG_SYSFS_SYSCALL is not set
CONFIG_KALLSYMS=y
CONFIG_KALLSYMS_ALL=y
CONFIG_PRINTK=y
CONFIG_BUG=y
CONFIG_ELF_CORE=y
# CONFIG_PCSPKR_PLATFORM is not set
CONFIG_BASE_FULL=y
CONFIG_FUTEX=y
# CONFIG_EPOLL is not set
# CONFIG_SIGNALFD is not set
# CONFIG_TIMERFD is not set
CONFIG_EVENTFD=y
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
CONFIG_VM_EVENT_COUNTERS=y
CONFIG_COMPAT_BRK=y
CONFIG_SLAB=y
# CONFIG_SLUB is not set
# CONFIG_SLOB is not set
# CONFIG_SYSTEM_TRUSTED_KEYRING is not set
# CONFIG_PROFILING is not set
CONFIG_HAVE_OPROFILE=y
CONFIG_OPROFILE_NMI_TIMER=y
# CONFIG_JUMP_LABEL is not set
# CONFIG_UPROBES is not set
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
CONFIG_HAVE_CC_STACKPROTECTOR=y
# CONFIG_CC_STACKPROTECTOR is not set
CONFIG_CC_STACKPROTECTOR_NONE=y
# CONFIG_CC_STACKPROTECTOR_REGULAR is not set
# CONFIG_CC_STACKPROTECTOR_STRONG is not set
CONFIG_HAVE_IRQ_TIME_ACCOUNTING=y
CONFIG_HAVE_ARCH_TRANSPARENT_HUGEPAGE=y
CONFIG_MODULES_USE_ELF_REL=y
CONFIG_CLONE_BACKWARDS=y
CONFIG_OLD_SIGSUSPEND3=y
CONFIG_OLD_SIGACTION=y

#
# GCOV-based kernel profiling
#
# CONFIG_GCOV_KERNEL is not set
CONFIG_HAVE_GENERIC_DMA_COHERENT=y
CONFIG_SLABINFO=y
CONFIG_RT_MUTEXES=y
CONFIG_BASE_SMALL=0
# CONFIG_MODULES is not set
# CONFIG_BLOCK is not set
CONFIG_UNINLINE_SPIN_UNLOCK=y
CONFIG_ARCH_USE_QUEUE_RWLOCK=y
CONFIG_FREEZER=y

#
# Processor type and features
#
# CONFIG_ZONE_DMA is not set
# CONFIG_SMP is not set
CONFIG_X86_MPPARSE=y
# CONFIG_X86_EXTENDED_PLATFORM is not set
# CONFIG_X86_INTEL_LPSS is not set
# CONFIG_X86_32_IRIS is not set
# CONFIG_SCHED_OMIT_FRAME_POINTER is not set
CONFIG_HYPERVISOR_GUEST=y
CONFIG_PARAVIRT=y
# CONFIG_PARAVIRT_DEBUG is not set
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
CONFIG_PROCESSOR_SELECT=y
# CONFIG_CPU_SUP_INTEL is not set
CONFIG_CPU_SUP_CYRIX_32=y
# CONFIG_CPU_SUP_AMD is not set
CONFIG_CPU_SUP_CENTAUR=y
# CONFIG_CPU_SUP_TRANSMETA_32 is not set
# CONFIG_CPU_SUP_UMC_32 is not set
CONFIG_HPET_TIMER=y
CONFIG_HPET_EMULATE_RTC=y
# CONFIG_DMI is not set
CONFIG_NR_CPUS=1
# CONFIG_PREEMPT_NONE is not set
CONFIG_PREEMPT_VOLUNTARY=y
# CONFIG_PREEMPT is not set
CONFIG_PREEMPT_COUNT=y
CONFIG_X86_LOCAL_APIC=y
CONFIG_X86_IO_APIC=y
CONFIG_X86_REROUTE_FOR_BROKEN_BOOT_IRQS=y
# CONFIG_X86_MCE is not set
CONFIG_VM86=y
# CONFIG_X86_16BIT is not set
CONFIG_TOSHIBA=y
# CONFIG_I8K is not set
# CONFIG_X86_REBOOTFIXUPS is not set
# CONFIG_MICROCODE_INTEL_EARLY is not set
# CONFIG_MICROCODE_AMD_EARLY is not set
CONFIG_X86_MSR=y
CONFIG_X86_CPUID=y
CONFIG_NOHIGHMEM=y
# CONFIG_HIGHMEM4G is not set
# CONFIG_HIGHMEM64G is not set
# CONFIG_VMSPLIT_3G is not set
CONFIG_VMSPLIT_3G_OPT=y
# CONFIG_VMSPLIT_2G is not set
# CONFIG_VMSPLIT_2G_OPT is not set
# CONFIG_VMSPLIT_1G is not set
CONFIG_PAGE_OFFSET=0xB0000000
# CONFIG_X86_PAE is not set
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
# CONFIG_HAVE_BOOTMEM_INFO_NODE is not set
CONFIG_PAGEFLAGS_EXTENDED=y
CONFIG_SPLIT_PTLOCK_CPUS=4
# CONFIG_COMPACTION is not set
# CONFIG_PHYS_ADDR_T_64BIT is not set
CONFIG_ZONE_DMA_FLAG=0
CONFIG_VIRT_TO_BUS=y
CONFIG_KSM=y
CONFIG_DEFAULT_MMAP_MIN_ADDR=4096
# CONFIG_TRANSPARENT_HUGEPAGE is not set
CONFIG_NEED_PER_CPU_KM=y
CONFIG_CLEANCACHE=y
# CONFIG_CMA is not set
# CONFIG_ZBUD is not set
CONFIG_ZSMALLOC=y
CONFIG_PGTABLE_MAPPING=y
CONFIG_GENERIC_EARLY_IOREMAP=y
CONFIG_X86_CHECK_BIOS_CORRUPTION=y
CONFIG_X86_BOOTPARAM_MEMORY_CORRUPTION_CHECK=y
CONFIG_X86_RESERVE_LOW=64
CONFIG_MATH_EMULATION=y
# CONFIG_MTRR is not set
CONFIG_ARCH_RANDOM=y
CONFIG_X86_SMAP=y
# CONFIG_EFI is not set
CONFIG_SECCOMP=y
# CONFIG_HZ_100 is not set
# CONFIG_HZ_250 is not set
# CONFIG_HZ_300 is not set
CONFIG_HZ_1000=y
CONFIG_HZ=1000
# CONFIG_SCHED_HRTICK is not set
CONFIG_KEXEC=y
CONFIG_PHYSICAL_START=0x1000000
CONFIG_RELOCATABLE=y
CONFIG_RANDOMIZE_BASE=y
CONFIG_RANDOMIZE_BASE_MAX_OFFSET=0x20000000
CONFIG_X86_NEED_RELOCS=y
CONFIG_PHYSICAL_ALIGN=0x200000
# CONFIG_COMPAT_VDSO is not set
# CONFIG_CMDLINE_BOOL is not set

#
# Power management and ACPI options
#
CONFIG_SUSPEND=y
CONFIG_SUSPEND_FREEZER=y
CONFIG_PM_SLEEP=y
CONFIG_PM_AUTOSLEEP=y
# CONFIG_PM_WAKELOCKS is not set
# CONFIG_PM_RUNTIME is not set
CONFIG_PM=y
CONFIG_PM_DEBUG=y
# CONFIG_PM_ADVANCED_DEBUG is not set
# CONFIG_PM_TEST_SUSPEND is not set
CONFIG_PM_SLEEP_DEBUG=y
CONFIG_PM_TRACE=y
CONFIG_PM_TRACE_RTC=y
# CONFIG_WQ_POWER_EFFICIENT_DEFAULT is not set
CONFIG_ACPI=y
CONFIG_ACPI_SLEEP=y
# CONFIG_ACPI_PROCFS_POWER is not set
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
# CONFIG_ACPI_REDUCED_HARDWARE_ONLY is not set
# CONFIG_ACPI_APEI is not set
# CONFIG_SFI is not set
# CONFIG_APM is not set

#
# CPU Frequency scaling
#
CONFIG_CPU_FREQ=y
CONFIG_CPU_FREQ_GOV_COMMON=y
# CONFIG_CPU_FREQ_STAT is not set
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
CONFIG_X86_INTEL_PSTATE=y
# CONFIG_X86_PCC_CPUFREQ is not set
# CONFIG_X86_ACPI_CPUFREQ is not set
# CONFIG_X86_POWERNOW_K6 is not set
CONFIG_X86_POWERNOW_K7=y
CONFIG_X86_POWERNOW_K7_ACPI=y
CONFIG_X86_GX_SUSPMOD=y
CONFIG_X86_SPEEDSTEP_CENTRINO=y
CONFIG_X86_SPEEDSTEP_CENTRINO_TABLE=y
CONFIG_X86_SPEEDSTEP_ICH=y
CONFIG_X86_SPEEDSTEP_SMI=y
CONFIG_X86_P4_CLOCKMOD=y
# CONFIG_X86_CPUFREQ_NFORCE2 is not set
CONFIG_X86_LONGRUN=y
# CONFIG_X86_LONGHAUL is not set
# CONFIG_X86_E_POWERSAVER is not set

#
# shared options
#
CONFIG_X86_SPEEDSTEP_LIB=y
# CONFIG_X86_SPEEDSTEP_RELAXED_CAP_CHECK is not set

#
# CPU Idle
#
CONFIG_CPU_IDLE=y
CONFIG_CPU_IDLE_MULTIPLE_DRIVERS=y
CONFIG_CPU_IDLE_GOV_LADDER=y
CONFIG_CPU_IDLE_GOV_MENU=y
# CONFIG_ARCH_NEEDS_CPU_IDLE_COUPLED is not set

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
CONFIG_PCI_CNB20LE_QUIRK=y
CONFIG_PCIEPORTBUS=y
# CONFIG_HOTPLUG_PCI_PCIE is not set
CONFIG_PCIEAER=y
CONFIG_PCIE_ECRC=y
# CONFIG_PCIEAER_INJECT is not set
CONFIG_PCIEASPM=y
CONFIG_PCIEASPM_DEBUG=y
# CONFIG_PCIEASPM_DEFAULT is not set
# CONFIG_PCIEASPM_POWERSAVE is not set
CONFIG_PCIEASPM_PERFORMANCE=y
CONFIG_PCI_MSI=y
# CONFIG_PCI_DEBUG is not set
CONFIG_PCI_REALLOC_ENABLE_AUTO=y
# CONFIG_PCI_STUB is not set
CONFIG_HT_IRQ=y
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
CONFIG_ISA=y
CONFIG_EISA=y
CONFIG_EISA_VLB_PRIMING=y
CONFIG_EISA_PCI_EISA=y
CONFIG_EISA_VIRTUAL_ROOT=y
# CONFIG_EISA_NAMES is not set
CONFIG_SCx200=y
CONFIG_SCx200HR_TIMER=y
# CONFIG_OLPC is not set
# CONFIG_ALIX is not set
# CONFIG_NET5501 is not set
# CONFIG_PCCARD is not set
CONFIG_HOTPLUG_PCI=y
CONFIG_HOTPLUG_PCI_COMPAQ=y
# CONFIG_HOTPLUG_PCI_COMPAQ_NVRAM is not set
# CONFIG_HOTPLUG_PCI_IBM is not set
# CONFIG_HOTPLUG_PCI_ACPI is not set
# CONFIG_HOTPLUG_PCI_CPCI is not set
CONFIG_HOTPLUG_PCI_SHPC=y
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
CONFIG_IOSF_MBI=y
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
# CONFIG_NET_PTP_CLASSIFY is not set
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
# CONFIG_CGROUP_NET_PRIO is not set
# CONFIG_CGROUP_NET_CLASSID is not set
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
CONFIG_UEVENT_HELPER=y
CONFIG_UEVENT_HELPER_PATH=""
CONFIG_DEVTMPFS=y
# CONFIG_DEVTMPFS_MOUNT is not set
CONFIG_STANDALONE=y
# CONFIG_PREVENT_FIRMWARE_BUILD is not set
CONFIG_FW_LOADER=y
CONFIG_FIRMWARE_IN_KERNEL=y
CONFIG_EXTRA_FIRMWARE=""
CONFIG_FW_LOADER_USER_HELPER=y
# CONFIG_DEBUG_DRIVER is not set
CONFIG_DEBUG_DEVRES=y
# CONFIG_SYS_HYPERVISOR is not set
# CONFIG_GENERIC_CPU_DEVICES is not set
CONFIG_GENERIC_CPU_AUTOPROBE=y
CONFIG_REGMAP=y
CONFIG_REGMAP_I2C=y
CONFIG_REGMAP_SPI=y
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
CONFIG_PARPORT_PC=y
# CONFIG_PARPORT_SERIAL is not set
CONFIG_PARPORT_PC_FIFO=y
CONFIG_PARPORT_PC_SUPERIO=y
# CONFIG_PARPORT_GSC is not set
CONFIG_PARPORT_AX88796=y
CONFIG_PARPORT_1284=y
CONFIG_PARPORT_NOT_PC=y
CONFIG_PNP=y
# CONFIG_PNP_DEBUG_MESSAGES is not set

#
# Protocols
#
# CONFIG_ISAPNP is not set
CONFIG_PNPBIOS=y
CONFIG_PNPBIOS_PROC_FS=y
CONFIG_PNPACPI=y

#
# Misc devices
#
CONFIG_SENSORS_LIS3LV02D=y
CONFIG_AD525X_DPOT=y
CONFIG_AD525X_DPOT_I2C=y
CONFIG_AD525X_DPOT_SPI=y
# CONFIG_DUMMY_IRQ is not set
# CONFIG_IBM_ASM is not set
CONFIG_PHANTOM=y
# CONFIG_SGI_IOC4 is not set
CONFIG_TIFM_CORE=y
CONFIG_TIFM_7XX1=y
# CONFIG_ICS932S401 is not set
CONFIG_ENCLOSURE_SERVICES=y
CONFIG_HP_ILO=y
# CONFIG_APDS9802ALS is not set
CONFIG_ISL29003=y
# CONFIG_ISL29020 is not set
# CONFIG_SENSORS_TSL2550 is not set
# CONFIG_SENSORS_BH1780 is not set
# CONFIG_SENSORS_BH1770 is not set
CONFIG_SENSORS_APDS990X=y
# CONFIG_HMC6352 is not set
# CONFIG_DS1682 is not set
CONFIG_TI_DAC7512=y
# CONFIG_VMWARE_BALLOON is not set
CONFIG_BMP085=y
CONFIG_BMP085_I2C=y
# CONFIG_BMP085_SPI is not set
# CONFIG_PCH_PHUB is not set
CONFIG_USB_SWITCH_FSA9480=y
# CONFIG_LATTICE_ECP3_CONFIG is not set
# CONFIG_SRAM is not set
# CONFIG_C2PORT is not set

#
# EEPROM support
#
CONFIG_EEPROM_AT24=y
CONFIG_EEPROM_AT25=y
# CONFIG_EEPROM_LEGACY is not set
# CONFIG_EEPROM_MAX6875 is not set
# CONFIG_EEPROM_93CX6 is not set
CONFIG_EEPROM_93XX46=y
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
CONFIG_INTEL_MEI_ME=y
# CONFIG_INTEL_MEI_TXE is not set
CONFIG_VMWARE_VMCI=y

#
# Intel MIC Host Driver
#

#
# Intel MIC Card Driver
#
CONFIG_ECHO=y
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
CONFIG_FIREWIRE_OHCI=y
CONFIG_FIREWIRE_NOSY=y
CONFIG_I2O=y
CONFIG_I2O_LCT_NOTIFY_ON_CHANGES=y
CONFIG_I2O_EXT_ADAPTEC=y
CONFIG_I2O_CONFIG=y
# CONFIG_I2O_CONFIG_OLD_IOCTL is not set
# CONFIG_I2O_BUS is not set
CONFIG_I2O_PROC=y
CONFIG_MACINTOSH_DRIVERS=y
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
CONFIG_INPUT_MOUSEDEV_PSAUX=y
CONFIG_INPUT_MOUSEDEV_SCREEN_X=1024
CONFIG_INPUT_MOUSEDEV_SCREEN_Y=768
CONFIG_INPUT_JOYDEV=y
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
# CONFIG_KEYBOARD_TC3589X is not set
# CONFIG_KEYBOARD_TWL4030 is not set
# CONFIG_KEYBOARD_XTKBD is not set
# CONFIG_KEYBOARD_CROS_EC is not set
CONFIG_INPUT_MOUSE=y
# CONFIG_MOUSE_PS2 is not set
CONFIG_MOUSE_SERIAL=y
CONFIG_MOUSE_APPLETOUCH=y
# CONFIG_MOUSE_BCM5974 is not set
CONFIG_MOUSE_CYAPA=y
CONFIG_MOUSE_INPORT=y
# CONFIG_MOUSE_ATIXL is not set
CONFIG_MOUSE_LOGIBM=y
# CONFIG_MOUSE_PC110PAD is not set
CONFIG_MOUSE_VSXXXAA=y
CONFIG_MOUSE_GPIO=y
# CONFIG_MOUSE_SYNAPTICS_I2C is not set
CONFIG_MOUSE_SYNAPTICS_USB=y
CONFIG_INPUT_JOYSTICK=y
CONFIG_JOYSTICK_ANALOG=y
CONFIG_JOYSTICK_A3D=y
# CONFIG_JOYSTICK_ADI is not set
# CONFIG_JOYSTICK_COBRA is not set
CONFIG_JOYSTICK_GF2K=y
# CONFIG_JOYSTICK_GRIP is not set
CONFIG_JOYSTICK_GRIP_MP=y
CONFIG_JOYSTICK_GUILLEMOT=y
CONFIG_JOYSTICK_INTERACT=y
# CONFIG_JOYSTICK_SIDEWINDER is not set
CONFIG_JOYSTICK_TMDC=y
# CONFIG_JOYSTICK_IFORCE is not set
CONFIG_JOYSTICK_WARRIOR=y
# CONFIG_JOYSTICK_MAGELLAN is not set
# CONFIG_JOYSTICK_SPACEORB is not set
# CONFIG_JOYSTICK_SPACEBALL is not set
CONFIG_JOYSTICK_STINGER=y
# CONFIG_JOYSTICK_TWIDJOY is not set
CONFIG_JOYSTICK_ZHENHUA=y
CONFIG_JOYSTICK_DB9=y
CONFIG_JOYSTICK_GAMECON=y
CONFIG_JOYSTICK_TURBOGRAFX=y
# CONFIG_JOYSTICK_AS5011 is not set
CONFIG_JOYSTICK_JOYDUMP=y
CONFIG_JOYSTICK_XPAD=y
# CONFIG_JOYSTICK_XPAD_FF is not set
CONFIG_JOYSTICK_XPAD_LEDS=y
CONFIG_INPUT_TABLET=y
# CONFIG_TABLET_USB_ACECAD is not set
CONFIG_TABLET_USB_AIPTEK=y
CONFIG_TABLET_USB_GTCO=y
# CONFIG_TABLET_USB_HANWANG is not set
# CONFIG_TABLET_USB_KBTAB is not set
CONFIG_TABLET_USB_WACOM=y
CONFIG_INPUT_TOUCHSCREEN=y
CONFIG_TOUCHSCREEN_ADS7846=y
CONFIG_TOUCHSCREEN_AD7877=y
CONFIG_TOUCHSCREEN_AD7879=y
# CONFIG_TOUCHSCREEN_AD7879_I2C is not set
CONFIG_TOUCHSCREEN_AD7879_SPI=y
# CONFIG_TOUCHSCREEN_ATMEL_MXT is not set
CONFIG_TOUCHSCREEN_AUO_PIXCIR=y
# CONFIG_TOUCHSCREEN_BU21013 is not set
CONFIG_TOUCHSCREEN_CY8CTMG110=y
CONFIG_TOUCHSCREEN_CYTTSP_CORE=y
CONFIG_TOUCHSCREEN_CYTTSP_I2C=y
CONFIG_TOUCHSCREEN_CYTTSP_SPI=y
CONFIG_TOUCHSCREEN_CYTTSP4_CORE=y
CONFIG_TOUCHSCREEN_CYTTSP4_I2C=y
# CONFIG_TOUCHSCREEN_CYTTSP4_SPI is not set
# CONFIG_TOUCHSCREEN_DA9034 is not set
CONFIG_TOUCHSCREEN_DYNAPRO=y
# CONFIG_TOUCHSCREEN_HAMPSHIRE is not set
# CONFIG_TOUCHSCREEN_EETI is not set
# CONFIG_TOUCHSCREEN_FUJITSU is not set
CONFIG_TOUCHSCREEN_ILI210X=y
# CONFIG_TOUCHSCREEN_GUNZE is not set
# CONFIG_TOUCHSCREEN_ELO is not set
CONFIG_TOUCHSCREEN_WACOM_W8001=y
# CONFIG_TOUCHSCREEN_WACOM_I2C is not set
# CONFIG_TOUCHSCREEN_MAX11801 is not set
# CONFIG_TOUCHSCREEN_MCS5000 is not set
CONFIG_TOUCHSCREEN_MMS114=y
CONFIG_TOUCHSCREEN_MTOUCH=y
CONFIG_TOUCHSCREEN_INEXIO=y
CONFIG_TOUCHSCREEN_MK712=y
# CONFIG_TOUCHSCREEN_HTCPEN is not set
CONFIG_TOUCHSCREEN_PENMOUNT=y
CONFIG_TOUCHSCREEN_EDT_FT5X06=y
CONFIG_TOUCHSCREEN_TOUCHRIGHT=y
# CONFIG_TOUCHSCREEN_TOUCHWIN is not set
CONFIG_TOUCHSCREEN_TI_AM335X_TSC=y
CONFIG_TOUCHSCREEN_PIXCIR=y
# CONFIG_TOUCHSCREEN_WM831X is not set
# CONFIG_TOUCHSCREEN_USB_COMPOSITE is not set
CONFIG_TOUCHSCREEN_MC13783=y
CONFIG_TOUCHSCREEN_TOUCHIT213=y
# CONFIG_TOUCHSCREEN_TSC_SERIO is not set
# CONFIG_TOUCHSCREEN_TSC2005 is not set
# CONFIG_TOUCHSCREEN_TSC2007 is not set
# CONFIG_TOUCHSCREEN_ST1232 is not set
# CONFIG_TOUCHSCREEN_SUR40 is not set
CONFIG_TOUCHSCREEN_TPS6507X=y
# CONFIG_TOUCHSCREEN_ZFORCE is not set
CONFIG_INPUT_MISC=y
CONFIG_INPUT_88PM80X_ONKEY=y
# CONFIG_INPUT_AD714X is not set
CONFIG_INPUT_BMA150=y
# CONFIG_INPUT_MAX8925_ONKEY is not set
# CONFIG_INPUT_MC13783_PWRBUTTON is not set
CONFIG_INPUT_MMA8450=y
CONFIG_INPUT_MPU3050=y
CONFIG_INPUT_APANEL=y
CONFIG_INPUT_GP2A=y
# CONFIG_INPUT_GPIO_BEEPER is not set
CONFIG_INPUT_GPIO_TILT_POLLED=y
# CONFIG_INPUT_WISTRON_BTNS is not set
# CONFIG_INPUT_ATLAS_BTNS is not set
CONFIG_INPUT_ATI_REMOTE2=y
CONFIG_INPUT_KEYSPAN_REMOTE=y
CONFIG_INPUT_KXTJ9=y
CONFIG_INPUT_KXTJ9_POLLED_MODE=y
CONFIG_INPUT_POWERMATE=y
CONFIG_INPUT_YEALINK=y
# CONFIG_INPUT_CM109 is not set
# CONFIG_INPUT_RETU_PWRBUTTON is not set
CONFIG_INPUT_TWL4030_PWRBUTTON=y
CONFIG_INPUT_TWL4030_VIBRA=y
CONFIG_INPUT_TWL6040_VIBRA=y
# CONFIG_INPUT_UINPUT is not set
CONFIG_INPUT_PCF8574=y
CONFIG_INPUT_GPIO_ROTARY_ENCODER=y
CONFIG_INPUT_DA9055_ONKEY=y
# CONFIG_INPUT_WM831X_ON is not set
CONFIG_INPUT_ADXL34X=y
# CONFIG_INPUT_ADXL34X_I2C is not set
# CONFIG_INPUT_ADXL34X_SPI is not set
CONFIG_INPUT_IMS_PCU=y
# CONFIG_INPUT_CMA3000 is not set
# CONFIG_INPUT_IDEAPAD_SLIDEBAR is not set

#
# Hardware I/O ports
#
CONFIG_SERIO=y
CONFIG_ARCH_MIGHT_HAVE_PC_SERIO=y
CONFIG_SERIO_I8042=y
CONFIG_SERIO_SERPORT=y
# CONFIG_SERIO_CT82C710 is not set
CONFIG_SERIO_PARKBD=y
CONFIG_SERIO_PCIPS2=y
CONFIG_SERIO_LIBPS2=y
CONFIG_SERIO_RAW=y
CONFIG_SERIO_ALTERA_PS2=y
CONFIG_SERIO_PS2MULT=y
CONFIG_SERIO_ARC_PS2=y
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
CONFIG_LEGACY_PTYS=y
CONFIG_LEGACY_PTY_COUNT=256
# CONFIG_SERIAL_NONSTANDARD is not set
# CONFIG_NOZOMI is not set
# CONFIG_N_GSM is not set
# CONFIG_TRACE_SINK is not set
CONFIG_DEVKMEM=y

#
# Serial drivers
#
CONFIG_SERIAL_EARLYCON=y
CONFIG_SERIAL_8250=y
CONFIG_SERIAL_8250_DEPRECATED_OPTIONS=y
CONFIG_SERIAL_8250_PNP=y
CONFIG_SERIAL_8250_CONSOLE=y
CONFIG_SERIAL_8250_PCI=y
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
# CONFIG_SERIAL_SC16IS7XX is not set
# CONFIG_SERIAL_TIMBERDALE is not set
# CONFIG_SERIAL_ALTERA_JTAGUART is not set
# CONFIG_SERIAL_ALTERA_UART is not set
# CONFIG_SERIAL_IFX6X60 is not set
# CONFIG_SERIAL_PCH_UART is not set
# CONFIG_SERIAL_ARC is not set
# CONFIG_SERIAL_RP2 is not set
# CONFIG_SERIAL_FSL_LPUART is not set
# CONFIG_TTY_PRINTK is not set
CONFIG_PRINTER=y
# CONFIG_LP_CONSOLE is not set
CONFIG_PPDEV=y
# CONFIG_VIRTIO_CONSOLE is not set
CONFIG_IPMI_HANDLER=y
# CONFIG_IPMI_PANIC_EVENT is not set
# CONFIG_IPMI_DEVICE_INTERFACE is not set
CONFIG_IPMI_SI=y
CONFIG_IPMI_SI_PROBE_DEFAULTS=y
CONFIG_IPMI_WATCHDOG=y
CONFIG_IPMI_POWEROFF=y
# CONFIG_HW_RANDOM is not set
# CONFIG_NVRAM is not set
CONFIG_DTLK=y
# CONFIG_R3964 is not set
CONFIG_APPLICOM=y
CONFIG_SONYPI=y
# CONFIG_MWAVE is not set
CONFIG_SCx200_GPIO=y
# CONFIG_PC8736x_GPIO is not set
CONFIG_NSC_GPIO=y
# CONFIG_HPET is not set
# CONFIG_HANGCHECK_TIMER is not set
CONFIG_TCG_TPM=y
CONFIG_TCG_TIS=y
# CONFIG_TCG_TIS_I2C_ATMEL is not set
CONFIG_TCG_TIS_I2C_INFINEON=y
CONFIG_TCG_TIS_I2C_NUVOTON=y
CONFIG_TCG_NSC=y
CONFIG_TCG_ATMEL=y
CONFIG_TCG_INFINEON=y
CONFIG_TCG_ST33_I2C=y
CONFIG_TELCLOCK=y
CONFIG_DEVPORT=y
CONFIG_I2C=y
CONFIG_I2C_BOARDINFO=y
CONFIG_I2C_COMPAT=y
# CONFIG_I2C_CHARDEV is not set
CONFIG_I2C_MUX=y

#
# Multiplexer I2C Chip support
#
CONFIG_I2C_MUX_GPIO=y
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
# CONFIG_I2C_ISMT is not set
# CONFIG_I2C_PIIX4 is not set
CONFIG_I2C_NFORCE2=y
CONFIG_I2C_NFORCE2_S4985=y
# CONFIG_I2C_SIS5595 is not set
# CONFIG_I2C_SIS630 is not set
CONFIG_I2C_SIS96X=y
CONFIG_I2C_VIA=y
# CONFIG_I2C_VIAPRO is not set

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
# CONFIG_I2C_DESIGNWARE_PCI is not set
# CONFIG_I2C_EG20T is not set
CONFIG_I2C_GPIO=y
CONFIG_I2C_OCORES=y
CONFIG_I2C_PCA_PLATFORM=y
# CONFIG_I2C_PXA_PCI is not set
CONFIG_I2C_SIMTEC=y
# CONFIG_I2C_XILINX is not set

#
# External I2C/SMBus adapter drivers
#
CONFIG_I2C_DIOLAN_U2C=y
CONFIG_I2C_PARPORT=y
CONFIG_I2C_PARPORT_LIGHT=y
CONFIG_I2C_ROBOTFUZZ_OSIF=y
# CONFIG_I2C_TAOS_EVM is not set
# CONFIG_I2C_TINY_USB is not set

#
# Other I2C/SMBus bus drivers
#
# CONFIG_I2C_ELEKTOR is not set
CONFIG_I2C_PCA_ISA=y
# CONFIG_I2C_CROS_EC_TUNNEL is not set
CONFIG_SCx200_I2C=y
CONFIG_SCx200_I2C_SCL=12
CONFIG_SCx200_I2C_SDA=13
CONFIG_SCx200_ACB=y
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
CONFIG_SPI_BITBANG=y
CONFIG_SPI_BUTTERFLY=y
CONFIG_SPI_GPIO=y
# CONFIG_SPI_LM70_LLP is not set
# CONFIG_SPI_OC_TINY is not set
CONFIG_SPI_PXA2XX_DMA=y
CONFIG_SPI_PXA2XX=y
CONFIG_SPI_PXA2XX_PCI=y
CONFIG_SPI_SC18IS602=y
# CONFIG_SPI_TOPCLIFF_PCH is not set
CONFIG_SPI_XCOMM=y
CONFIG_SPI_XILINX=y
CONFIG_SPI_DESIGNWARE=y
CONFIG_SPI_DW_PCI=y
# CONFIG_SPI_DW_MMIO is not set

#
# SPI Protocol Masters
#
CONFIG_SPI_SPIDEV=y
CONFIG_SPI_TLE62X0=y
CONFIG_SPMI=y
# CONFIG_HSI is not set

#
# PPS support
#
CONFIG_PPS=y
# CONFIG_PPS_DEBUG is not set
# CONFIG_NTP_PPS is not set

#
# PPS clients support
#
CONFIG_PPS_CLIENT_KTIMER=y
# CONFIG_PPS_CLIENT_LDISC is not set
# CONFIG_PPS_CLIENT_PARPORT is not set
CONFIG_PPS_CLIENT_GPIO=y

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
CONFIG_GPIO_ACPI=y
CONFIG_GPIOLIB_IRQCHIP=y
# CONFIG_DEBUG_GPIO is not set
CONFIG_GPIO_SYSFS=y
CONFIG_GPIO_DA9055=y
CONFIG_GPIO_MAX730X=y

#
# Memory mapped GPIO drivers:
#
# CONFIG_GPIO_GENERIC_PLATFORM is not set
# CONFIG_GPIO_IT8761E is not set
CONFIG_GPIO_F7188X=y
CONFIG_GPIO_SCH311X=y
CONFIG_GPIO_SCH=y
CONFIG_GPIO_ICH=y
# CONFIG_GPIO_VX855 is not set
# CONFIG_GPIO_LYNXPOINT is not set

#
# I2C GPIO expanders:
#
# CONFIG_GPIO_ARIZONA is not set
# CONFIG_GPIO_MAX7300 is not set
CONFIG_GPIO_MAX732X=y
CONFIG_GPIO_MAX732X_IRQ=y
CONFIG_GPIO_PCA953X=y
# CONFIG_GPIO_PCA953X_IRQ is not set
CONFIG_GPIO_PCF857X=y
# CONFIG_GPIO_SX150X is not set
CONFIG_GPIO_TC3589X=y
CONFIG_GPIO_TPS65912=y
CONFIG_GPIO_TWL4030=y
CONFIG_GPIO_TWL6040=y
CONFIG_GPIO_WM831X=y
# CONFIG_GPIO_WM8350 is not set
CONFIG_GPIO_WM8994=y
CONFIG_GPIO_ADP5588=y
# CONFIG_GPIO_ADP5588_IRQ is not set

#
# PCI GPIO expanders:
#
CONFIG_GPIO_BT8XX=y
CONFIG_GPIO_AMD8111=y
CONFIG_GPIO_INTEL_MID=y
# CONFIG_GPIO_PCH is not set
CONFIG_GPIO_ML_IOH=y
# CONFIG_GPIO_TIMBERDALE is not set
# CONFIG_GPIO_RDC321X is not set

#
# SPI GPIO expanders:
#
CONFIG_GPIO_MAX7301=y
CONFIG_GPIO_MC33880=y

#
# AC97 GPIO expanders:
#

#
# LPC GPIO expanders:
#

#
# MODULbus GPIO expanders:
#

#
# USB GPIO expanders:
#
CONFIG_W1=y

#
# 1-wire Bus Masters
#
CONFIG_W1_MASTER_MATROX=y
CONFIG_W1_MASTER_DS2490=y
CONFIG_W1_MASTER_DS2482=y
# CONFIG_W1_MASTER_DS1WM is not set
CONFIG_W1_MASTER_GPIO=y

#
# 1-wire Slaves
#
# CONFIG_W1_SLAVE_THERM is not set
CONFIG_W1_SLAVE_SMEM=y
# CONFIG_W1_SLAVE_DS2408 is not set
# CONFIG_W1_SLAVE_DS2413 is not set
CONFIG_W1_SLAVE_DS2423=y
CONFIG_W1_SLAVE_DS2431=y
CONFIG_W1_SLAVE_DS2433=y
CONFIG_W1_SLAVE_DS2433_CRC=y
CONFIG_W1_SLAVE_DS2760=y
CONFIG_W1_SLAVE_DS2780=y
CONFIG_W1_SLAVE_DS2781=y
CONFIG_W1_SLAVE_DS28E04=y
CONFIG_W1_SLAVE_BQ27000=y
CONFIG_POWER_SUPPLY=y
# CONFIG_POWER_SUPPLY_DEBUG is not set
CONFIG_PDA_POWER=y
CONFIG_GENERIC_ADC_BATTERY=y
CONFIG_MAX8925_POWER=y
CONFIG_WM831X_BACKUP=y
CONFIG_WM831X_POWER=y
CONFIG_WM8350_POWER=y
CONFIG_TEST_POWER=y
# CONFIG_BATTERY_DS2760 is not set
CONFIG_BATTERY_DS2780=y
# CONFIG_BATTERY_DS2781 is not set
# CONFIG_BATTERY_DS2782 is not set
# CONFIG_BATTERY_SBS is not set
CONFIG_BATTERY_BQ27x00=y
CONFIG_BATTERY_BQ27X00_I2C=y
CONFIG_BATTERY_BQ27X00_PLATFORM=y
CONFIG_BATTERY_DA9030=y
# CONFIG_BATTERY_MAX17040 is not set
# CONFIG_BATTERY_MAX17042 is not set
CONFIG_BATTERY_TWL4030_MADC=y
# CONFIG_BATTERY_RX51 is not set
# CONFIG_CHARGER_ISP1704 is not set
# CONFIG_CHARGER_MAX8903 is not set
CONFIG_CHARGER_TWL4030=y
CONFIG_CHARGER_LP8727=y
CONFIG_CHARGER_GPIO=y
# CONFIG_CHARGER_BQ2415X is not set
# CONFIG_CHARGER_BQ24190 is not set
CONFIG_CHARGER_BQ24735=y
# CONFIG_CHARGER_SMB347 is not set
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
CONFIG_SENSORS_AD7418=y
# CONFIG_SENSORS_ADM1021 is not set
CONFIG_SENSORS_ADM1025=y
# CONFIG_SENSORS_ADM1026 is not set
# CONFIG_SENSORS_ADM1029 is not set
# CONFIG_SENSORS_ADM1031 is not set
CONFIG_SENSORS_ADM9240=y
# CONFIG_SENSORS_ADT7310 is not set
# CONFIG_SENSORS_ADT7410 is not set
CONFIG_SENSORS_ADT7411=y
CONFIG_SENSORS_ADT7462=y
CONFIG_SENSORS_ADT7470=y
CONFIG_SENSORS_ADT7475=y
CONFIG_SENSORS_ASC7621=y
CONFIG_SENSORS_K8TEMP=y
CONFIG_SENSORS_K10TEMP=y
CONFIG_SENSORS_FAM15H_POWER=y
CONFIG_SENSORS_APPLESMC=y
CONFIG_SENSORS_ASB100=y
# CONFIG_SENSORS_ATXP1 is not set
CONFIG_SENSORS_DS620=y
CONFIG_SENSORS_DS1621=y
# CONFIG_SENSORS_DA9055 is not set
# CONFIG_SENSORS_I5K_AMB is not set
CONFIG_SENSORS_F71805F=y
# CONFIG_SENSORS_F71882FG is not set
# CONFIG_SENSORS_F75375S is not set
CONFIG_SENSORS_MC13783_ADC=y
CONFIG_SENSORS_FSCHMD=y
CONFIG_SENSORS_GL518SM=y
CONFIG_SENSORS_GL520SM=y
# CONFIG_SENSORS_G760A is not set
CONFIG_SENSORS_G762=y
CONFIG_SENSORS_GPIO_FAN=y
CONFIG_SENSORS_HIH6130=y
CONFIG_SENSORS_IBMAEM=y
CONFIG_SENSORS_IBMPEX=y
CONFIG_SENSORS_IIO_HWMON=y
# CONFIG_SENSORS_CORETEMP is not set
CONFIG_SENSORS_IT87=y
CONFIG_SENSORS_JC42=y
CONFIG_SENSORS_LINEAGE=y
CONFIG_SENSORS_LTC2945=y
# CONFIG_SENSORS_LTC4151 is not set
CONFIG_SENSORS_LTC4215=y
CONFIG_SENSORS_LTC4222=y
CONFIG_SENSORS_LTC4245=y
# CONFIG_SENSORS_LTC4260 is not set
# CONFIG_SENSORS_LTC4261 is not set
CONFIG_SENSORS_MAX1111=y
CONFIG_SENSORS_MAX16065=y
# CONFIG_SENSORS_MAX1619 is not set
# CONFIG_SENSORS_MAX1668 is not set
CONFIG_SENSORS_MAX197=y
# CONFIG_SENSORS_MAX6639 is not set
CONFIG_SENSORS_MAX6642=y
CONFIG_SENSORS_MAX6650=y
CONFIG_SENSORS_MAX6697=y
# CONFIG_SENSORS_HTU21 is not set
# CONFIG_SENSORS_MCP3021 is not set
# CONFIG_SENSORS_ADCXX is not set
# CONFIG_SENSORS_LM63 is not set
CONFIG_SENSORS_LM70=y
# CONFIG_SENSORS_LM73 is not set
CONFIG_SENSORS_LM75=y
CONFIG_SENSORS_LM77=y
# CONFIG_SENSORS_LM78 is not set
# CONFIG_SENSORS_LM80 is not set
# CONFIG_SENSORS_LM83 is not set
CONFIG_SENSORS_LM85=y
CONFIG_SENSORS_LM87=y
CONFIG_SENSORS_LM90=y
CONFIG_SENSORS_LM92=y
# CONFIG_SENSORS_LM93 is not set
# CONFIG_SENSORS_LM95234 is not set
# CONFIG_SENSORS_LM95241 is not set
CONFIG_SENSORS_LM95245=y
CONFIG_SENSORS_PC87360=y
# CONFIG_SENSORS_PC87427 is not set
# CONFIG_SENSORS_NTC_THERMISTOR is not set
CONFIG_SENSORS_NCT6683=y
CONFIG_SENSORS_NCT6775=y
# CONFIG_SENSORS_PCF8591 is not set
# CONFIG_PMBUS is not set
CONFIG_SENSORS_SHT15=y
CONFIG_SENSORS_SHT21=y
CONFIG_SENSORS_SHTC1=y
CONFIG_SENSORS_SIS5595=y
CONFIG_SENSORS_DME1737=y
CONFIG_SENSORS_EMC1403=y
# CONFIG_SENSORS_EMC2103 is not set
CONFIG_SENSORS_EMC6W201=y
CONFIG_SENSORS_SMSC47M1=y
CONFIG_SENSORS_SMSC47M192=y
CONFIG_SENSORS_SMSC47B397=y
# CONFIG_SENSORS_SCH56XX_COMMON is not set
# CONFIG_SENSORS_SCH5627 is not set
# CONFIG_SENSORS_SCH5636 is not set
CONFIG_SENSORS_SMM665=y
# CONFIG_SENSORS_ADC128D818 is not set
# CONFIG_SENSORS_ADS1015 is not set
CONFIG_SENSORS_ADS7828=y
CONFIG_SENSORS_ADS7871=y
CONFIG_SENSORS_AMC6821=y
# CONFIG_SENSORS_INA209 is not set
# CONFIG_SENSORS_INA2XX is not set
CONFIG_SENSORS_THMC50=y
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
CONFIG_SENSORS_W83795=y
CONFIG_SENSORS_W83795_FANCTRL=y
CONFIG_SENSORS_W83L785TS=y
# CONFIG_SENSORS_W83L786NG is not set
CONFIG_SENSORS_W83627HF=y
CONFIG_SENSORS_W83627EHF=y
CONFIG_SENSORS_WM831X=y
CONFIG_SENSORS_WM8350=y

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
# CONFIG_THERMAL_EMULATION is not set
# CONFIG_ACPI_INT3403_THERMAL is not set
# CONFIG_INTEL_SOC_DTS_THERMAL is not set

#
# Texas Instruments thermal drivers
#
CONFIG_WATCHDOG=y
CONFIG_WATCHDOG_CORE=y
# CONFIG_WATCHDOG_NOWAYOUT is not set

#
# Watchdog Device Drivers
#
CONFIG_SOFT_WATCHDOG=y
CONFIG_DA9055_WATCHDOG=y
CONFIG_WM831X_WATCHDOG=y
CONFIG_WM8350_WATCHDOG=y
CONFIG_XILINX_WATCHDOG=y
# CONFIG_DW_WATCHDOG is not set
CONFIG_TWL4030_WATCHDOG=y
CONFIG_RETU_WATCHDOG=y
CONFIG_ACQUIRE_WDT=y
CONFIG_ADVANTECH_WDT=y
# CONFIG_ALIM1535_WDT is not set
CONFIG_ALIM7101_WDT=y
# CONFIG_F71808E_WDT is not set
CONFIG_SP5100_TCO=y
CONFIG_SBC_FITPC2_WATCHDOG=y
# CONFIG_EUROTECH_WDT is not set
# CONFIG_IB700_WDT is not set
# CONFIG_IBMASR is not set
# CONFIG_WAFER_WDT is not set
CONFIG_I6300ESB_WDT=y
CONFIG_IE6XX_WDT=y
CONFIG_ITCO_WDT=y
CONFIG_ITCO_VENDOR_SUPPORT=y
CONFIG_IT8712F_WDT=y
CONFIG_IT87_WDT=y
CONFIG_HP_WATCHDOG=y
# CONFIG_HPWDT_NMI_DECODING is not set
CONFIG_SC1200_WDT=y
# CONFIG_SCx200_WDT is not set
CONFIG_PC87413_WDT=y
CONFIG_NV_TCO=y
# CONFIG_60XX_WDT is not set
CONFIG_SBC8360_WDT=y
CONFIG_SBC7240_WDT=y
CONFIG_CPU5_WDT=y
CONFIG_SMSC_SCH311X_WDT=y
# CONFIG_SMSC37B787_WDT is not set
# CONFIG_VIA_WDT is not set
CONFIG_W83627HF_WDT=y
CONFIG_W83877F_WDT=y
# CONFIG_W83977F_WDT is not set
CONFIG_MACHZ_WDT=y
# CONFIG_SBC_EPX_C3_WATCHDOG is not set
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
CONFIG_USBPCWATCHDOG=y
CONFIG_SSB_POSSIBLE=y

#
# Sonics Silicon Backplane
#
CONFIG_SSB=y
CONFIG_SSB_SPROM=y
CONFIG_SSB_PCIHOST_POSSIBLE=y
CONFIG_SSB_PCIHOST=y
# CONFIG_SSB_B43_PCI_BRIDGE is not set
CONFIG_SSB_SDIOHOST_POSSIBLE=y
# CONFIG_SSB_SDIOHOST is not set
CONFIG_SSB_SILENT=y
CONFIG_SSB_DRIVER_PCICORE_POSSIBLE=y
# CONFIG_SSB_DRIVER_PCICORE is not set
CONFIG_SSB_DRIVER_GPIO=y
CONFIG_BCMA_POSSIBLE=y

#
# Broadcom specific AMBA
#
CONFIG_BCMA=y
CONFIG_BCMA_HOST_PCI_POSSIBLE=y
# CONFIG_BCMA_HOST_PCI is not set
# CONFIG_BCMA_HOST_SOC is not set
# CONFIG_BCMA_DRIVER_GMAC_CMN is not set
CONFIG_BCMA_DRIVER_GPIO=y
CONFIG_BCMA_DEBUG=y

#
# Multifunction device drivers
#
CONFIG_MFD_CORE=y
# CONFIG_MFD_CS5535 is not set
# CONFIG_MFD_AS3711 is not set
# CONFIG_PMIC_ADP5520 is not set
CONFIG_MFD_AAT2870_CORE=y
CONFIG_MFD_BCM590XX=y
# CONFIG_MFD_AXP20X is not set
CONFIG_MFD_CROS_EC=y
CONFIG_MFD_CROS_EC_I2C=y
CONFIG_PMIC_DA903X=y
# CONFIG_MFD_DA9052_SPI is not set
# CONFIG_MFD_DA9052_I2C is not set
CONFIG_MFD_DA9055=y
# CONFIG_MFD_DA9063 is not set
CONFIG_MFD_MC13XXX=y
CONFIG_MFD_MC13XXX_SPI=y
CONFIG_MFD_MC13XXX_I2C=y
CONFIG_HTC_PASIC3=y
# CONFIG_HTC_I2CPLD is not set
CONFIG_LPC_ICH=y
CONFIG_LPC_SCH=y
# CONFIG_MFD_JANZ_CMODIO is not set
# CONFIG_MFD_KEMPLD is not set
CONFIG_MFD_88PM800=y
CONFIG_MFD_88PM805=y
# CONFIG_MFD_88PM860X is not set
# CONFIG_MFD_MAX14577 is not set
CONFIG_MFD_MAX77686=y
# CONFIG_MFD_MAX77693 is not set
CONFIG_MFD_MAX8907=y
CONFIG_MFD_MAX8925=y
# CONFIG_MFD_MAX8997 is not set
CONFIG_MFD_MAX8998=y
# CONFIG_EZX_PCAP is not set
# CONFIG_MFD_VIPERBOARD is not set
CONFIG_MFD_RETU=y
# CONFIG_MFD_PCF50633 is not set
CONFIG_MFD_RDC321X=y
CONFIG_MFD_RTSX_PCI=y
CONFIG_MFD_RTSX_USB=y
# CONFIG_MFD_RC5T583 is not set
CONFIG_MFD_SEC_CORE=y
CONFIG_MFD_SI476X_CORE=y
CONFIG_MFD_SM501=y
CONFIG_MFD_SM501_GPIO=y
CONFIG_MFD_SMSC=y
CONFIG_ABX500_CORE=y
CONFIG_AB3100_CORE=y
CONFIG_AB3100_OTP=y
CONFIG_MFD_SYSCON=y
CONFIG_MFD_TI_AM335X_TSCADC=y
# CONFIG_MFD_LP3943 is not set
# CONFIG_MFD_LP8788 is not set
# CONFIG_MFD_PALMAS is not set
# CONFIG_TPS6105X is not set
# CONFIG_TPS65010 is not set
# CONFIG_TPS6507X is not set
# CONFIG_MFD_TPS65090 is not set
CONFIG_MFD_TPS65217=y
# CONFIG_MFD_TPS65218 is not set
# CONFIG_MFD_TPS6586X is not set
# CONFIG_MFD_TPS65910 is not set
CONFIG_MFD_TPS65912=y
# CONFIG_MFD_TPS65912_I2C is not set
CONFIG_MFD_TPS65912_SPI=y
# CONFIG_MFD_TPS80031 is not set
CONFIG_TWL4030_CORE=y
CONFIG_MFD_TWL4030_AUDIO=y
CONFIG_TWL6040_CORE=y
CONFIG_MFD_WL1273_CORE=y
# CONFIG_MFD_LM3533 is not set
CONFIG_MFD_TIMBERDALE=y
CONFIG_MFD_TC3589X=y
# CONFIG_MFD_TMIO is not set
CONFIG_MFD_VX855=y
CONFIG_MFD_ARIZONA=y
CONFIG_MFD_ARIZONA_I2C=y
# CONFIG_MFD_ARIZONA_SPI is not set
# CONFIG_MFD_WM5102 is not set
CONFIG_MFD_WM5110=y
CONFIG_MFD_WM8997=y
# CONFIG_MFD_WM8400 is not set
CONFIG_MFD_WM831X=y
CONFIG_MFD_WM831X_I2C=y
CONFIG_MFD_WM831X_SPI=y
CONFIG_MFD_WM8350=y
CONFIG_MFD_WM8350_I2C=y
CONFIG_MFD_WM8994=y
# CONFIG_REGULATOR is not set
CONFIG_MEDIA_SUPPORT=y

#
# Multimedia core support
#
# CONFIG_MEDIA_CAMERA_SUPPORT is not set
# CONFIG_MEDIA_ANALOG_TV_SUPPORT is not set
CONFIG_MEDIA_DIGITAL_TV_SUPPORT=y
# CONFIG_MEDIA_RADIO_SUPPORT is not set
CONFIG_MEDIA_RC_SUPPORT=y
CONFIG_VIDEO_ADV_DEBUG=y
# CONFIG_VIDEO_FIXED_MINOR_RANGES is not set
CONFIG_DVB_CORE=y
CONFIG_TTPCI_EEPROM=y
CONFIG_DVB_MAX_ADAPTERS=8
# CONFIG_DVB_DYNAMIC_MINORS is not set

#
# Media drivers
#
CONFIG_RC_CORE=y
CONFIG_RC_MAP=y
# CONFIG_RC_DECODERS is not set
# CONFIG_RC_DEVICES is not set
CONFIG_MEDIA_USB_SUPPORT=y

#
# Analog/digital TV USB devices
#
# CONFIG_VIDEO_AU0828 is not set

#
# Digital TV USB devices
#
CONFIG_DVB_USB=y
# CONFIG_DVB_USB_DEBUG is not set
# CONFIG_DVB_USB_A800 is not set
# CONFIG_DVB_USB_DIBUSB_MB is not set
# CONFIG_DVB_USB_DIBUSB_MC is not set
CONFIG_DVB_USB_DIB0700=y
# CONFIG_DVB_USB_UMT_010 is not set
CONFIG_DVB_USB_CXUSB=y
CONFIG_DVB_USB_M920X=y
CONFIG_DVB_USB_DIGITV=y
CONFIG_DVB_USB_VP7045=y
# CONFIG_DVB_USB_VP702X is not set
CONFIG_DVB_USB_GP8PSK=y
CONFIG_DVB_USB_NOVA_T_USB2=y
CONFIG_DVB_USB_TTUSB2=y
CONFIG_DVB_USB_DTT200U=y
CONFIG_DVB_USB_OPERA1=y
# CONFIG_DVB_USB_AF9005 is not set
CONFIG_DVB_USB_PCTV452E=y
CONFIG_DVB_USB_DW2102=y
CONFIG_DVB_USB_CINERGY_T2=y
# CONFIG_DVB_USB_DTV5100 is not set
# CONFIG_DVB_USB_FRIIO is not set
# CONFIG_DVB_USB_AZ6027 is not set
CONFIG_DVB_USB_TECHNISAT_USB2=y
CONFIG_DVB_USB_V2=y
# CONFIG_DVB_USB_AF9015 is not set
CONFIG_DVB_USB_AF9035=y
# CONFIG_DVB_USB_ANYSEE is not set
CONFIG_DVB_USB_AU6610=y
# CONFIG_DVB_USB_AZ6007 is not set
CONFIG_DVB_USB_CE6230=y
# CONFIG_DVB_USB_EC168 is not set
# CONFIG_DVB_USB_GL861 is not set
CONFIG_DVB_USB_LME2510=y
CONFIG_DVB_USB_MXL111SF=y
CONFIG_DVB_USB_RTL28XXU=y
CONFIG_DVB_TTUSB_BUDGET=y
CONFIG_DVB_TTUSB_DEC=y
# CONFIG_SMS_USB_DRV is not set
CONFIG_DVB_B2C2_FLEXCOP_USB=y
CONFIG_DVB_B2C2_FLEXCOP_USB_DEBUG=y

#
# Webcam, TV (analog/digital) USB devices
#
# CONFIG_MEDIA_PCI_SUPPORT is not set

#
# Supported MMC/SDIO adapters
#
CONFIG_SMS_SDIO_DRV=y

#
# Supported FireWire (IEEE 1394) Adapters
#
# CONFIG_DVB_FIREDTV is not set
CONFIG_MEDIA_COMMON_OPTIONS=y

#
# common driver options
#
CONFIG_VIDEO_TVEEPROM=y
CONFIG_CYPRESS_FIRMWARE=y
CONFIG_DVB_B2C2_FLEXCOP=y
CONFIG_DVB_B2C2_FLEXCOP_DEBUG=y
CONFIG_SMS_SIANO_MDTV=y
# CONFIG_SMS_SIANO_RC is not set

#
# Media ancillary drivers (tuners, sensors, i2c, frontends)
#
CONFIG_MEDIA_SUBDRV_AUTOSELECT=y
CONFIG_MEDIA_TUNER_SIMPLE=y
CONFIG_MEDIA_TUNER_TDA827X=y
CONFIG_MEDIA_TUNER_TDA9887=y
CONFIG_MEDIA_TUNER_MT2060=y
CONFIG_MEDIA_TUNER_MT2266=y
CONFIG_MEDIA_TUNER_QT1010=y
CONFIG_MEDIA_TUNER_XC2028=y
CONFIG_MEDIA_TUNER_XC5000=y
CONFIG_MEDIA_TUNER_XC4000=y
CONFIG_MEDIA_TUNER_MXL5005S=y
CONFIG_MEDIA_TUNER_MXL5007T=y
CONFIG_MEDIA_TUNER_MAX2165=y
CONFIG_MEDIA_TUNER_TDA18218=y
CONFIG_MEDIA_TUNER_FC0011=y
CONFIG_MEDIA_TUNER_FC0012=y
CONFIG_MEDIA_TUNER_FC0013=y
CONFIG_MEDIA_TUNER_E4000=y
CONFIG_MEDIA_TUNER_FC2580=y
CONFIG_MEDIA_TUNER_TUA9001=y
CONFIG_MEDIA_TUNER_IT913X=y
CONFIG_MEDIA_TUNER_R820T=y

#
# Multistandard (satellite) frontends
#
CONFIG_DVB_STB0899=y
CONFIG_DVB_STB6100=y
CONFIG_DVB_STV090x=y
CONFIG_DVB_STV6110x=y

#
# Multistandard (cable + terrestrial) frontends
#

#
# DVB-S (satellite) frontends
#
CONFIG_DVB_CX24123=y
CONFIG_DVB_MT312=y
CONFIG_DVB_ZL10039=y
CONFIG_DVB_S5H1420=y
CONFIG_DVB_STV0288=y
CONFIG_DVB_STB6000=y
CONFIG_DVB_STV0299=y
CONFIG_DVB_STV6110=y
CONFIG_DVB_STV0900=y
CONFIG_DVB_TDA8083=y
CONFIG_DVB_TDA10086=y
CONFIG_DVB_TUNER_ITD1000=y
CONFIG_DVB_TUNER_CX24113=y
CONFIG_DVB_TDA826X=y
CONFIG_DVB_CX24116=y
CONFIG_DVB_SI21XX=y
CONFIG_DVB_TS2020=y
CONFIG_DVB_DS3000=y

#
# DVB-T (terrestrial) frontends
#
CONFIG_DVB_CX22700=y
CONFIG_DVB_CX22702=y
CONFIG_DVB_TDA1004X=y
CONFIG_DVB_NXT6000=y
CONFIG_DVB_MT352=y
CONFIG_DVB_ZL10353=y
CONFIG_DVB_DIB3000MC=y
CONFIG_DVB_DIB7000M=y
CONFIG_DVB_DIB7000P=y
CONFIG_DVB_TDA10048=y
CONFIG_DVB_RTL2830=y
CONFIG_DVB_RTL2832=y

#
# DVB-C (cable) frontends
#
CONFIG_DVB_VES1820=y
CONFIG_DVB_TDA10023=y
CONFIG_DVB_STV0297=y

#
# ATSC (North American/Korean Terrestrial/Cable DTV) frontends
#
CONFIG_DVB_NXT200X=y
CONFIG_DVB_BCM3510=y
CONFIG_DVB_LGDT330X=y
CONFIG_DVB_LGDT3305=y
CONFIG_DVB_LG2160=y
CONFIG_DVB_S5H1411=y

#
# ISDB-T (terrestrial) frontends
#
CONFIG_DVB_DIB8000=y

#
# Digital terrestrial only tuners/PLL
#
CONFIG_DVB_PLL=y
CONFIG_DVB_TUNER_DIB0070=y
CONFIG_DVB_TUNER_DIB0090=y

#
# SEC control devices for DVB-S
#
CONFIG_DVB_LNBP21=y
CONFIG_DVB_LNBP22=y
CONFIG_DVB_ISL6421=y
CONFIG_DVB_LGS8GXX=y
CONFIG_DVB_ATBM8830=y
CONFIG_DVB_IX2505V=y
CONFIG_DVB_M88RS2000=y
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
# CONFIG_AGP_ATI is not set
CONFIG_AGP_AMD=y
CONFIG_AGP_INTEL=y
CONFIG_AGP_NVIDIA=y
# CONFIG_AGP_SIS is not set
CONFIG_AGP_SWORKS=y
CONFIG_AGP_VIA=y
CONFIG_AGP_EFFICEON=y
CONFIG_INTEL_GTT=y
CONFIG_VGA_ARB=y
CONFIG_VGA_ARB_MAX_GPUS=16
# CONFIG_VGA_SWITCHEROO is not set

#
# Direct Rendering Manager
#
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
# CONFIG_DRM_I2C_SIL164 is not set
# CONFIG_DRM_I2C_NXP_TDA998X is not set
# CONFIG_DRM_PTN3460 is not set
# CONFIG_DRM_TDFX is not set
CONFIG_DRM_R128=y
CONFIG_DRM_RADEON=y
CONFIG_DRM_RADEON_UMS=y
CONFIG_DRM_NOUVEAU=y
CONFIG_NOUVEAU_DEBUG=5
CONFIG_NOUVEAU_DEBUG_DEFAULT=3
CONFIG_DRM_NOUVEAU_BACKLIGHT=y
# CONFIG_DRM_I810 is not set
# CONFIG_DRM_I915 is not set
CONFIG_DRM_MGA=y
# CONFIG_DRM_SIS is not set
# CONFIG_DRM_VIA is not set
CONFIG_DRM_SAVAGE=y
# CONFIG_DRM_VMWGFX is not set
CONFIG_DRM_GMA500=y
CONFIG_DRM_GMA600=y
# CONFIG_DRM_GMA3600 is not set
CONFIG_DRM_UDL=y
CONFIG_DRM_AST=y
# CONFIG_DRM_MGAG200 is not set
CONFIG_DRM_CIRRUS_QEMU=y
# CONFIG_DRM_QXL is not set
CONFIG_DRM_BOCHS=y

#
# Frame buffer Devices
#
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
CONFIG_FB_BACKLIGHT=y
CONFIG_FB_MODE_HELPERS=y
CONFIG_FB_TILEBLITTING=y

#
# Frame buffer hardware drivers
#
CONFIG_FB_CIRRUS=y
# CONFIG_FB_PM2 is not set
CONFIG_FB_CYBER2000=y
CONFIG_FB_CYBER2000_DDC=y
# CONFIG_FB_ARC is not set
# CONFIG_FB_ASILIANT is not set
# CONFIG_FB_IMSTT is not set
# CONFIG_FB_VGA16 is not set
# CONFIG_FB_VESA is not set
CONFIG_FB_N411=y
# CONFIG_FB_HGA is not set
CONFIG_FB_OPENCORES=y
CONFIG_FB_S1D13XXX=y
# CONFIG_FB_NVIDIA is not set
CONFIG_FB_RIVA=y
# CONFIG_FB_RIVA_I2C is not set
CONFIG_FB_RIVA_DEBUG=y
# CONFIG_FB_RIVA_BACKLIGHT is not set
CONFIG_FB_I740=y
CONFIG_FB_I810=y
# CONFIG_FB_I810_GTF is not set
# CONFIG_FB_LE80578 is not set
CONFIG_FB_INTEL=y
CONFIG_FB_INTEL_DEBUG=y
# CONFIG_FB_INTEL_I2C is not set
CONFIG_FB_MATROX=y
# CONFIG_FB_MATROX_MILLENIUM is not set
CONFIG_FB_MATROX_MYSTIQUE=y
CONFIG_FB_MATROX_G=y
# CONFIG_FB_MATROX_I2C is not set
CONFIG_FB_RADEON=y
# CONFIG_FB_RADEON_I2C is not set
# CONFIG_FB_RADEON_BACKLIGHT is not set
# CONFIG_FB_RADEON_DEBUG is not set
# CONFIG_FB_ATY128 is not set
CONFIG_FB_ATY=y
CONFIG_FB_ATY_CT=y
CONFIG_FB_ATY_GENERIC_LCD=y
# CONFIG_FB_ATY_GX is not set
CONFIG_FB_ATY_BACKLIGHT=y
# CONFIG_FB_S3 is not set
CONFIG_FB_SAVAGE=y
# CONFIG_FB_SAVAGE_I2C is not set
# CONFIG_FB_SAVAGE_ACCEL is not set
# CONFIG_FB_SIS is not set
CONFIG_FB_VIA=y
CONFIG_FB_VIA_DIRECT_PROCFS=y
# CONFIG_FB_VIA_X_COMPATIBILITY is not set
# CONFIG_FB_NEOMAGIC is not set
CONFIG_FB_KYRO=y
CONFIG_FB_3DFX=y
# CONFIG_FB_3DFX_ACCEL is not set
CONFIG_FB_3DFX_I2C=y
# CONFIG_FB_VOODOO1 is not set
CONFIG_FB_VT8623=y
CONFIG_FB_TRIDENT=y
# CONFIG_FB_ARK is not set
CONFIG_FB_PM3=y
# CONFIG_FB_CARMINE is not set
CONFIG_FB_GEODE=y
# CONFIG_FB_GEODE_LX is not set
CONFIG_FB_GEODE_GX=y
CONFIG_FB_GEODE_GX1=y
CONFIG_FB_SM501=y
CONFIG_FB_SMSCUFX=y
CONFIG_FB_UDL=y
# CONFIG_FB_VIRTUAL is not set
# CONFIG_FB_METRONOME is not set
CONFIG_FB_MB862XX=y
CONFIG_FB_MB862XX_PCI_GDC=y
# CONFIG_FB_MB862XX_I2C is not set
# CONFIG_FB_BROADSHEET is not set
# CONFIG_FB_AUO_K190X is not set
# CONFIG_FB_SIMPLE is not set
CONFIG_BACKLIGHT_LCD_SUPPORT=y
# CONFIG_LCD_CLASS_DEVICE is not set
CONFIG_BACKLIGHT_CLASS_DEVICE=y
# CONFIG_BACKLIGHT_GENERIC is not set
CONFIG_BACKLIGHT_DA903X=y
CONFIG_BACKLIGHT_MAX8925=y
# CONFIG_BACKLIGHT_APPLE is not set
CONFIG_BACKLIGHT_SAHARA=y
CONFIG_BACKLIGHT_WM831X=y
# CONFIG_BACKLIGHT_ADP8860 is not set
# CONFIG_BACKLIGHT_ADP8870 is not set
CONFIG_BACKLIGHT_AAT2870=y
CONFIG_BACKLIGHT_LM3639=y
CONFIG_BACKLIGHT_PANDORA=y
CONFIG_BACKLIGHT_TPS65217=y
# CONFIG_BACKLIGHT_GPIO is not set
CONFIG_BACKLIGHT_LV5207LP=y
CONFIG_BACKLIGHT_BD6107=y
CONFIG_VGASTATE=y
CONFIG_HDMI=y
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
CONFIG_HIDRAW=y
CONFIG_UHID=y
CONFIG_HID_GENERIC=y

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
CONFIG_HID_CP2112=y
# CONFIG_HID_CYPRESS is not set
CONFIG_HID_DRAGONRISE=y
CONFIG_DRAGONRISE_FF=y
CONFIG_HID_EMS_FF=y
CONFIG_HID_ELECOM=y
CONFIG_HID_ELO=y
CONFIG_HID_EZKEY=y
CONFIG_HID_HOLTEK=y
# CONFIG_HOLTEK_FF is not set
# CONFIG_HID_HUION is not set
CONFIG_HID_KEYTOUCH=y
# CONFIG_HID_KYE is not set
CONFIG_HID_UCLOGIC=y
CONFIG_HID_WALTOP=y
CONFIG_HID_GYRATION=y
CONFIG_HID_ICADE=y
CONFIG_HID_TWINHAN=y
CONFIG_HID_KENSINGTON=y
CONFIG_HID_LCPOWER=y
CONFIG_HID_LENOVO_TPKBD=y
# CONFIG_HID_LOGITECH is not set
CONFIG_HID_MAGICMOUSE=y
CONFIG_HID_MICROSOFT=y
CONFIG_HID_MONTEREY=y
CONFIG_HID_MULTITOUCH=y
CONFIG_HID_NTRIG=y
# CONFIG_HID_ORTEK is not set
# CONFIG_HID_PANTHERLORD is not set
CONFIG_HID_PETALYNX=y
CONFIG_HID_PICOLCD=y
CONFIG_HID_PICOLCD_FB=y
CONFIG_HID_PICOLCD_BACKLIGHT=y
CONFIG_HID_PICOLCD_LEDS=y
# CONFIG_HID_PICOLCD_CIR is not set
CONFIG_HID_PRIMAX=y
CONFIG_HID_ROCCAT=y
CONFIG_HID_SAITEK=y
# CONFIG_HID_SAMSUNG is not set
CONFIG_HID_SONY=y
CONFIG_SONY_FF=y
CONFIG_HID_SPEEDLINK=y
CONFIG_HID_STEELSERIES=y
# CONFIG_HID_SUNPLUS is not set
CONFIG_HID_RMI=y
CONFIG_HID_GREENASIA=y
# CONFIG_GREENASIA_FF is not set
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
# CONFIG_USB_ANNOUNCE_NEW_DEVICES is not set

#
# Miscellaneous USB options
#
CONFIG_USB_DEFAULT_PERSIST=y
# CONFIG_USB_DYNAMIC_MINORS is not set
CONFIG_USB_OTG=y
# CONFIG_USB_OTG_WHITELIST is not set
CONFIG_USB_OTG_BLACKLIST_HUB=y
CONFIG_USB_OTG_FSM=y
CONFIG_USB_MON=y
CONFIG_USB_WUSB=y
# CONFIG_USB_WUSB_CBAF is not set

#
# USB Host Controller Drivers
#
CONFIG_USB_C67X00_HCD=y
# CONFIG_USB_XHCI_HCD is not set
CONFIG_USB_EHCI_HCD=y
CONFIG_USB_EHCI_ROOT_HUB_TT=y
# CONFIG_USB_EHCI_TT_NEWSCHED is not set
CONFIG_USB_EHCI_PCI=y
CONFIG_USB_EHCI_HCD_PLATFORM=y
CONFIG_USB_OXU210HP_HCD=y
CONFIG_USB_ISP116X_HCD=y
CONFIG_USB_ISP1760_HCD=y
CONFIG_USB_ISP1362_HCD=y
CONFIG_USB_FUSBH200_HCD=y
CONFIG_USB_FOTG210_HCD=y
# CONFIG_USB_MAX3421_HCD is not set
CONFIG_USB_OHCI_HCD=y
# CONFIG_USB_OHCI_HCD_PCI is not set
CONFIG_USB_OHCI_HCD_SSB=y
CONFIG_USB_OHCI_HCD_PLATFORM=y
# CONFIG_USB_UHCI_HCD is not set
CONFIG_USB_U132_HCD=y
# CONFIG_USB_SL811_HCD is not set
CONFIG_USB_R8A66597_HCD=y
CONFIG_USB_RENESAS_USBHS_HCD=y
CONFIG_USB_WHCI_HCD=y
CONFIG_USB_HWA_HCD=y
# CONFIG_USB_HCD_BCMA is not set
CONFIG_USB_HCD_SSB=y
CONFIG_USB_HCD_TEST_MODE=y
CONFIG_USB_RENESAS_USBHS=y

#
# USB Device Class drivers
#
# CONFIG_USB_ACM is not set
# CONFIG_USB_PRINTER is not set
CONFIG_USB_WDM=y
# CONFIG_USB_TMC is not set

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
CONFIG_USB_MUSB_HDRC=y
# CONFIG_USB_MUSB_HOST is not set
# CONFIG_USB_MUSB_GADGET is not set
CONFIG_USB_MUSB_DUAL_ROLE=y
CONFIG_USB_MUSB_TUSB6010=y
# CONFIG_USB_MUSB_UX500 is not set
CONFIG_MUSB_PIO_ONLY=y
CONFIG_USB_DWC3=y
CONFIG_USB_DWC3_HOST=y
# CONFIG_USB_DWC3_GADGET is not set
# CONFIG_USB_DWC3_DUAL_ROLE is not set

#
# Platform Glue Driver Support
#
CONFIG_USB_DWC3_PCI=y

#
# Debugging features
#
# CONFIG_USB_DWC3_DEBUG is not set
# CONFIG_USB_DWC2 is not set
CONFIG_USB_CHIPIDEA=y
CONFIG_USB_CHIPIDEA_UDC=y
# CONFIG_USB_CHIPIDEA_HOST is not set
# CONFIG_USB_CHIPIDEA_DEBUG is not set

#
# USB port drivers
#
CONFIG_USB_USS720=y
# CONFIG_USB_SERIAL is not set

#
# USB Miscellaneous drivers
#
# CONFIG_USB_EMI62 is not set
CONFIG_USB_EMI26=y
# CONFIG_USB_ADUTUX is not set
CONFIG_USB_SEVSEG=y
# CONFIG_USB_RIO500 is not set
CONFIG_USB_LEGOTOWER=y
# CONFIG_USB_LCD is not set
CONFIG_USB_LED=y
CONFIG_USB_CYPRESS_CY7C63=y
# CONFIG_USB_CYTHERM is not set
CONFIG_USB_IDMOUSE=y
CONFIG_USB_FTDI_ELAN=y
CONFIG_USB_APPLEDISPLAY=y
CONFIG_USB_SISUSBVGA=y
# CONFIG_USB_LD is not set
CONFIG_USB_TRANCEVIBRATOR=y
# CONFIG_USB_IOWARRIOR is not set
CONFIG_USB_TEST=y
# CONFIG_USB_EHSET_TEST_FIXTURE is not set
CONFIG_USB_ISIGHTFW=y
CONFIG_USB_YUREX=y
CONFIG_USB_EZUSB_FX2=y
CONFIG_USB_HSIC_USB3503=y

#
# USB Physical Layer drivers
#
CONFIG_USB_PHY=y
CONFIG_NOP_USB_XCEIV=y
# CONFIG_SAMSUNG_USB2PHY is not set
# CONFIG_SAMSUNG_USB3PHY is not set
CONFIG_USB_GPIO_VBUS=y
CONFIG_TAHVO_USB=y
CONFIG_TAHVO_USB_HOST_BY_DEFAULT=y
# CONFIG_USB_ISP1301 is not set
CONFIG_USB_GADGET=y
CONFIG_USB_GADGET_DEBUG=y
CONFIG_USB_GADGET_VERBOSE=y
# CONFIG_USB_GADGET_DEBUG_FILES is not set
CONFIG_USB_GADGET_DEBUG_FS=y
CONFIG_USB_GADGET_VBUS_DRAW=2
CONFIG_USB_GADGET_STORAGE_NUM_BUFFERS=2

#
# USB Peripheral Controller
#
CONFIG_USB_FUSB300=y
# CONFIG_USB_FOTG210_UDC is not set
# CONFIG_USB_GR_UDC is not set
# CONFIG_USB_R8A66597 is not set
CONFIG_USB_RENESAS_USBHS_UDC=y
CONFIG_USB_PXA27X=y
# CONFIG_USB_MV_UDC is not set
# CONFIG_USB_MV_U3D is not set
# CONFIG_USB_M66592 is not set
# CONFIG_USB_AMD5536UDC is not set
# CONFIG_USB_NET2272 is not set
CONFIG_USB_NET2280=y
CONFIG_USB_GOKU=y
CONFIG_USB_EG20T=y
# CONFIG_USB_DUMMY_HCD is not set
CONFIG_USB_LIBCOMPOSITE=y
CONFIG_USB_F_FS=y
# CONFIG_USB_CONFIGFS is not set
# CONFIG_USB_ZERO is not set
# CONFIG_USB_ETH is not set
# CONFIG_USB_G_NCM is not set
# CONFIG_USB_GADGETFS is not set
CONFIG_USB_FUNCTIONFS=y
# CONFIG_USB_FUNCTIONFS_ETH is not set
# CONFIG_USB_FUNCTIONFS_RNDIS is not set
CONFIG_USB_FUNCTIONFS_GENERIC=y
# CONFIG_USB_G_SERIAL is not set
# CONFIG_USB_G_PRINTER is not set
# CONFIG_USB_CDC_COMPOSITE is not set
# CONFIG_USB_G_HID is not set
# CONFIG_USB_G_DBGP is not set
CONFIG_UWB=y
CONFIG_UWB_HWA=y
CONFIG_UWB_WHCI=y
CONFIG_UWB_I1480U=y
CONFIG_MMC=y
CONFIG_MMC_DEBUG=y
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
# CONFIG_MMC_SDHCI_PCI is not set
# CONFIG_MMC_SDHCI_ACPI is not set
CONFIG_MMC_SDHCI_PLTFM=y
# CONFIG_MMC_WBSD is not set
CONFIG_MMC_TIFM_SD=y
CONFIG_MMC_SPI=y
CONFIG_MMC_CB710=y
# CONFIG_MMC_VIA_SDMMC is not set
CONFIG_MMC_VUB300=y
CONFIG_MMC_USHC=y
CONFIG_MMC_USDHI6ROL0=y
CONFIG_MMC_REALTEK_PCI=y
CONFIG_MMC_REALTEK_USB=y
# CONFIG_MEMSTICK is not set
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
# CONFIG_LEDS_GPIO is not set
CONFIG_LEDS_LP3944=y
CONFIG_LEDS_LP55XX_COMMON=y
CONFIG_LEDS_LP5521=y
# CONFIG_LEDS_LP5523 is not set
CONFIG_LEDS_LP5562=y
CONFIG_LEDS_LP8501=y
CONFIG_LEDS_PCA955X=y
# CONFIG_LEDS_PCA963X is not set
# CONFIG_LEDS_WM831X_STATUS is not set
CONFIG_LEDS_WM8350=y
CONFIG_LEDS_DA903X=y
CONFIG_LEDS_DAC124S085=y
# CONFIG_LEDS_BD2802 is not set
CONFIG_LEDS_LT3593=y
# CONFIG_LEDS_DELL_NETBOOKS is not set
CONFIG_LEDS_MC13783=y
CONFIG_LEDS_TCA6507=y
CONFIG_LEDS_LM355x=y
CONFIG_LEDS_OT200=y

#
# LED driver for blink(1) USB RGB LED is under Special HID drivers (HID_THINGM)
#
CONFIG_LEDS_BLINKM=y

#
# LED Triggers
#
CONFIG_LEDS_TRIGGERS=y
# CONFIG_LEDS_TRIGGER_TIMER is not set
# CONFIG_LEDS_TRIGGER_ONESHOT is not set
CONFIG_LEDS_TRIGGER_HEARTBEAT=y
CONFIG_LEDS_TRIGGER_BACKLIGHT=y
CONFIG_LEDS_TRIGGER_CPU=y
CONFIG_LEDS_TRIGGER_GPIO=y
CONFIG_LEDS_TRIGGER_DEFAULT_ON=y

#
# iptables trigger is under Netfilter config (LED target)
#
CONFIG_LEDS_TRIGGER_TRANSIENT=y
CONFIG_LEDS_TRIGGER_CAMERA=y
# CONFIG_ACCESSIBILITY is not set
CONFIG_EDAC=y
# CONFIG_EDAC_LEGACY_SYSFS is not set
# CONFIG_EDAC_DEBUG is not set
CONFIG_EDAC_MM_EDAC=y
CONFIG_EDAC_AMD76X=y
CONFIG_EDAC_E7XXX=y
# CONFIG_EDAC_E752X is not set
CONFIG_EDAC_I82875P=y
CONFIG_EDAC_I82975X=y
CONFIG_EDAC_I3000=y
# CONFIG_EDAC_I3200 is not set
CONFIG_EDAC_X38=y
CONFIG_EDAC_I5400=y
CONFIG_EDAC_I82860=y
# CONFIG_EDAC_R82600 is not set
# CONFIG_EDAC_I5000 is not set
CONFIG_EDAC_I5100=y
CONFIG_EDAC_I7300=y
CONFIG_RTC_LIB=y
CONFIG_RTC_CLASS=y
# CONFIG_RTC_HCTOSYS is not set
CONFIG_RTC_SYSTOHC=y
CONFIG_RTC_HCTOSYS_DEVICE="rtc0"
CONFIG_RTC_DEBUG=y

#
# RTC interfaces
#
CONFIG_RTC_INTF_SYSFS=y
CONFIG_RTC_INTF_PROC=y
CONFIG_RTC_INTF_DEV=y
CONFIG_RTC_INTF_DEV_UIE_EMUL=y
CONFIG_RTC_DRV_TEST=y

#
# I2C RTC drivers
#
CONFIG_RTC_DRV_88PM80X=y
CONFIG_RTC_DRV_DS1307=y
# CONFIG_RTC_DRV_DS1374 is not set
CONFIG_RTC_DRV_DS1672=y
# CONFIG_RTC_DRV_DS3232 is not set
CONFIG_RTC_DRV_MAX6900=y
CONFIG_RTC_DRV_MAX8907=y
# CONFIG_RTC_DRV_MAX8925 is not set
# CONFIG_RTC_DRV_MAX8998 is not set
CONFIG_RTC_DRV_MAX77686=y
CONFIG_RTC_DRV_RS5C372=y
# CONFIG_RTC_DRV_ISL1208 is not set
CONFIG_RTC_DRV_ISL12022=y
CONFIG_RTC_DRV_ISL12057=y
CONFIG_RTC_DRV_X1205=y
CONFIG_RTC_DRV_PCF2127=y
CONFIG_RTC_DRV_PCF8523=y
CONFIG_RTC_DRV_PCF8563=y
# CONFIG_RTC_DRV_PCF8583 is not set
CONFIG_RTC_DRV_M41T80=y
# CONFIG_RTC_DRV_M41T80_WDT is not set
# CONFIG_RTC_DRV_BQ32K is not set
CONFIG_RTC_DRV_TWL4030=y
CONFIG_RTC_DRV_S35390A=y
CONFIG_RTC_DRV_FM3130=y
CONFIG_RTC_DRV_RX8581=y
# CONFIG_RTC_DRV_RX8025 is not set
CONFIG_RTC_DRV_EM3027=y
CONFIG_RTC_DRV_RV3029C2=y
CONFIG_RTC_DRV_S5M=y

#
# SPI RTC drivers
#
CONFIG_RTC_DRV_M41T93=y
CONFIG_RTC_DRV_M41T94=y
CONFIG_RTC_DRV_DS1305=y
CONFIG_RTC_DRV_DS1343=y
# CONFIG_RTC_DRV_DS1347 is not set
CONFIG_RTC_DRV_DS1390=y
CONFIG_RTC_DRV_MAX6902=y
# CONFIG_RTC_DRV_R9701 is not set
# CONFIG_RTC_DRV_RS5C348 is not set
CONFIG_RTC_DRV_DS3234=y
# CONFIG_RTC_DRV_PCF2123 is not set
CONFIG_RTC_DRV_RX4581=y
# CONFIG_RTC_DRV_MCP795 is not set

#
# Platform RTC drivers
#
CONFIG_RTC_DRV_CMOS=y
# CONFIG_RTC_DRV_DS1286 is not set
# CONFIG_RTC_DRV_DS1511 is not set
# CONFIG_RTC_DRV_DS1553 is not set
CONFIG_RTC_DRV_DS1742=y
CONFIG_RTC_DRV_DA9055=y
CONFIG_RTC_DRV_STK17TA8=y
CONFIG_RTC_DRV_M48T86=y
# CONFIG_RTC_DRV_M48T35 is not set
CONFIG_RTC_DRV_M48T59=y
CONFIG_RTC_DRV_MSM6242=y
# CONFIG_RTC_DRV_BQ4802 is not set
# CONFIG_RTC_DRV_RP5C01 is not set
CONFIG_RTC_DRV_V3020=y
# CONFIG_RTC_DRV_DS2404 is not set
CONFIG_RTC_DRV_WM831X=y
CONFIG_RTC_DRV_WM8350=y
CONFIG_RTC_DRV_AB3100=y

#
# on-CPU RTC drivers
#
CONFIG_RTC_DRV_MC13XXX=y
# CONFIG_RTC_DRV_MOXART is not set
CONFIG_RTC_DRV_XGENE=y

#
# HID Sensor RTC drivers
#
CONFIG_RTC_DRV_HID_SENSOR_TIME=y
# CONFIG_DMADEVICES is not set
# CONFIG_AUXDISPLAY is not set
# CONFIG_UIO is not set
CONFIG_VIRT_DRIVERS=y
CONFIG_VIRTIO=y

#
# Virtio drivers
#
CONFIG_VIRTIO_PCI=y
CONFIG_VIRTIO_BALLOON=y
CONFIG_VIRTIO_MMIO=y
CONFIG_VIRTIO_MMIO_CMDLINE_DEVICES=y

#
# Microsoft Hyper-V guest support
#
# CONFIG_HYPERV is not set
# CONFIG_STAGING is not set
CONFIG_X86_PLATFORM_DEVICES=y
# CONFIG_ACER_WMI is not set
# CONFIG_ACERHDF is not set
# CONFIG_ALIENWARE_WMI is not set
# CONFIG_ASUS_LAPTOP is not set
# CONFIG_DELL_LAPTOP is not set
# CONFIG_DELL_WMI is not set
# CONFIG_DELL_WMI_AIO is not set
# CONFIG_DELL_SMO8800 is not set
# CONFIG_FUJITSU_LAPTOP is not set
# CONFIG_FUJITSU_TABLET is not set
# CONFIG_TC1100_WMI is not set
# CONFIG_HP_ACCEL is not set
# CONFIG_HP_WIRELESS is not set
# CONFIG_HP_WMI is not set
# CONFIG_PANASONIC_LAPTOP is not set
# CONFIG_THINKPAD_ACPI is not set
# CONFIG_SENSORS_HDAPS is not set
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
# CONFIG_SAMSUNG_LAPTOP is not set
CONFIG_MXM_WMI=y
# CONFIG_SAMSUNG_Q10 is not set
# CONFIG_APPLE_GMUX is not set
# CONFIG_INTEL_RST is not set
# CONFIG_INTEL_SMARTCONNECT is not set
# CONFIG_PVPANIC is not set
# CONFIG_CHROME_PLATFORMS is not set

#
# SOC (System On Chip) specific Drivers
#

#
# Hardware Spinlock drivers
#
CONFIG_CLKSRC_I8253=y
CONFIG_CLKEVT_I8253=y
CONFIG_CLKBLD_I8253=y
# CONFIG_SH_TIMER_CMT is not set
# CONFIG_SH_TIMER_MTU2 is not set
# CONFIG_SH_TIMER_TMU is not set
# CONFIG_EM_TIMER_STI is not set
# CONFIG_MAILBOX is not set
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
# CONFIG_DEVFREQ_GOV_SIMPLE_ONDEMAND is not set
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
CONFIG_MEMORY=y
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
# CONFIG_HID_SENSOR_ACCEL_3D is not set
CONFIG_IIO_ST_ACCEL_3AXIS=y
CONFIG_IIO_ST_ACCEL_I2C_3AXIS=y
CONFIG_IIO_ST_ACCEL_SPI_3AXIS=y
CONFIG_KXSD9=y
CONFIG_MMA8452=y

#
# Analog to digital converters
#
CONFIG_AD_SIGMA_DELTA=y
# CONFIG_AD7266 is not set
# CONFIG_AD7298 is not set
CONFIG_AD7476=y
CONFIG_AD7791=y
CONFIG_AD7793=y
CONFIG_AD7887=y
CONFIG_AD7923=y
# CONFIG_AD799X is not set
CONFIG_MAX1363=y
CONFIG_MCP320X=y
CONFIG_MCP3422=y
CONFIG_NAU7802=y
CONFIG_TI_ADC081C=y
CONFIG_TI_AM335X_ADC=y
CONFIG_TWL4030_MADC=y
CONFIG_TWL6030_GPADC=y

#
# Amplifiers
#
# CONFIG_AD8366 is not set

#
# Hid Sensor IIO Common
#
CONFIG_HID_SENSOR_IIO_COMMON=y
CONFIG_HID_SENSOR_IIO_TRIGGER=y
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
CONFIG_AD5624R_SPI=y
# CONFIG_AD5686 is not set
CONFIG_AD5755=y
# CONFIG_AD5764 is not set
CONFIG_AD5791=y
CONFIG_AD7303=y
# CONFIG_MAX517 is not set
CONFIG_MCP4725=y

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
# CONFIG_ADIS16080 is not set
CONFIG_ADIS16130=y
# CONFIG_ADIS16136 is not set
CONFIG_ADIS16260=y
# CONFIG_ADXRS450 is not set
# CONFIG_HID_SENSOR_GYRO_3D is not set
CONFIG_IIO_ST_GYRO_3AXIS=y
CONFIG_IIO_ST_GYRO_I2C_3AXIS=y
CONFIG_IIO_ST_GYRO_SPI_3AXIS=y
CONFIG_ITG3200=y

#
# Humidity sensors
#
CONFIG_DHT11=y
CONFIG_SI7005=y

#
# Inertial measurement units
#
CONFIG_ADIS16400=y
# CONFIG_ADIS16480 is not set
# CONFIG_INV_MPU6050_IIO is not set
CONFIG_IIO_ADIS_LIB=y
CONFIG_IIO_ADIS_LIB_BUFFER=y

#
# Light sensors
#
CONFIG_ADJD_S311=y
CONFIG_APDS9300=y
CONFIG_CM32181=y
# CONFIG_CM36651 is not set
CONFIG_GP2AP020A00F=y
# CONFIG_HID_SENSOR_ALS is not set
CONFIG_HID_SENSOR_PROX=y
CONFIG_LTR501=y
CONFIG_TCS3472=y
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
CONFIG_IIO_ST_MAGN_SPI_3AXIS=y

#
# Inclinometer sensors
#
# CONFIG_HID_SENSOR_INCLINOMETER_3D is not set
# CONFIG_HID_SENSOR_DEVICE_ROTATION is not set

#
# Triggers - standalone
#
CONFIG_IIO_INTERRUPT_TRIGGER=y
CONFIG_IIO_SYSFS_TRIGGER=y

#
# Pressure sensors
#
# CONFIG_HID_SENSOR_PRESS is not set
# CONFIG_MPL115 is not set
CONFIG_MPL3115=y
# CONFIG_IIO_ST_PRESS is not set

#
# Lightning sensors
#
CONFIG_AS3935=y

#
# Temperature sensors
#
CONFIG_MLX90614=y
# CONFIG_TMP006 is not set
# CONFIG_NTB is not set
# CONFIG_VME_BUS is not set
# CONFIG_PWM is not set
CONFIG_IPACK_BUS=y
# CONFIG_BOARD_TPCI200 is not set
# CONFIG_SERIAL_IPOCTAL is not set
# CONFIG_RESET_CONTROLLER is not set
CONFIG_FMC=y
CONFIG_FMC_FAKEDEV=y
CONFIG_FMC_TRIVIAL=y
CONFIG_FMC_WRITE_EEPROM=y
# CONFIG_FMC_CHARDEV is not set

#
# PHY Subsystem
#
CONFIG_GENERIC_PHY=y
CONFIG_BCM_KONA_USB2_PHY=y
# CONFIG_PHY_SAMSUNG_USB2 is not set
CONFIG_POWERCAP=y
CONFIG_INTEL_RAPL=y
# CONFIG_MCB is not set

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
# CONFIG_FSNOTIFY is not set
# CONFIG_DNOTIFY is not set
# CONFIG_INOTIFY_USER is not set
# CONFIG_FANOTIFY is not set
CONFIG_QUOTA=y
# CONFIG_QUOTA_NETLINK_INTERFACE is not set
CONFIG_PRINT_QUOTA_WARNING=y
CONFIG_QUOTA_DEBUG=y
CONFIG_QUOTA_TREE=y
CONFIG_QFMT_V1=y
CONFIG_QFMT_V2=y
CONFIG_QUOTACTL=y
CONFIG_AUTOFS4_FS=y
CONFIG_FUSE_FS=y
CONFIG_CUSE=y

#
# Caches
#
# CONFIG_FSCACHE is not set

#
# Pseudo filesystems
#
CONFIG_PROC_FS=y
CONFIG_PROC_KCORE=y
# CONFIG_PROC_SYSCTL is not set
CONFIG_PROC_PAGE_MONITOR=y
CONFIG_KERNFS=y
CONFIG_SYSFS=y
CONFIG_HUGETLBFS=y
CONFIG_HUGETLB_PAGE=y
CONFIG_CONFIGFS_FS=y
CONFIG_MISC_FILESYSTEMS=y
CONFIG_ECRYPT_FS=y
CONFIG_ECRYPT_FS_MESSAGING=y
# CONFIG_PSTORE is not set
CONFIG_NETWORK_FILESYSTEMS=y
CONFIG_NLS=y
CONFIG_NLS_DEFAULT="iso8859-1"
CONFIG_NLS_CODEPAGE_437=y
# CONFIG_NLS_CODEPAGE_737 is not set
CONFIG_NLS_CODEPAGE_775=y
# CONFIG_NLS_CODEPAGE_850 is not set
# CONFIG_NLS_CODEPAGE_852 is not set
CONFIG_NLS_CODEPAGE_855=y
# CONFIG_NLS_CODEPAGE_857 is not set
# CONFIG_NLS_CODEPAGE_860 is not set
CONFIG_NLS_CODEPAGE_861=y
CONFIG_NLS_CODEPAGE_862=y
CONFIG_NLS_CODEPAGE_863=y
# CONFIG_NLS_CODEPAGE_864 is not set
# CONFIG_NLS_CODEPAGE_865 is not set
CONFIG_NLS_CODEPAGE_866=y
CONFIG_NLS_CODEPAGE_869=y
# CONFIG_NLS_CODEPAGE_936 is not set
CONFIG_NLS_CODEPAGE_950=y
CONFIG_NLS_CODEPAGE_932=y
CONFIG_NLS_CODEPAGE_949=y
# CONFIG_NLS_CODEPAGE_874 is not set
CONFIG_NLS_ISO8859_8=y
CONFIG_NLS_CODEPAGE_1250=y
CONFIG_NLS_CODEPAGE_1251=y
CONFIG_NLS_ASCII=y
# CONFIG_NLS_ISO8859_1 is not set
# CONFIG_NLS_ISO8859_2 is not set
CONFIG_NLS_ISO8859_3=y
CONFIG_NLS_ISO8859_4=y
CONFIG_NLS_ISO8859_5=y
CONFIG_NLS_ISO8859_6=y
CONFIG_NLS_ISO8859_7=y
CONFIG_NLS_ISO8859_9=y
# CONFIG_NLS_ISO8859_13 is not set
# CONFIG_NLS_ISO8859_14 is not set
CONFIG_NLS_ISO8859_15=y
CONFIG_NLS_KOI8_R=y
CONFIG_NLS_KOI8_U=y
# CONFIG_NLS_MAC_ROMAN is not set
CONFIG_NLS_MAC_CELTIC=y
CONFIG_NLS_MAC_CENTEURO=y
CONFIG_NLS_MAC_CROATIAN=y
# CONFIG_NLS_MAC_CYRILLIC is not set
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
CONFIG_DYNAMIC_DEBUG=y

#
# Compile-time checks and compiler options
#
# CONFIG_DEBUG_INFO is not set
# CONFIG_ENABLE_WARN_DEPRECATED is not set
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
CONFIG_DEBUG_FORCE_WEAK_PER_CPU=y
CONFIG_MAGIC_SYSRQ=y
CONFIG_MAGIC_SYSRQ_DEFAULT_ENABLE=0x1
CONFIG_DEBUG_KERNEL=y

#
# Memory Debugging
#
CONFIG_DEBUG_PAGEALLOC=y
CONFIG_WANT_PAGE_DEBUG_FLAGS=y
CONFIG_PAGE_GUARD=y
# CONFIG_DEBUG_OBJECTS is not set
# CONFIG_DEBUG_SLAB is not set
CONFIG_HAVE_DEBUG_KMEMLEAK=y
# CONFIG_DEBUG_KMEMLEAK is not set
# CONFIG_DEBUG_STACK_USAGE is not set
CONFIG_DEBUG_VM=y
CONFIG_DEBUG_VM_VMACACHE=y
CONFIG_DEBUG_VM_RB=y
# CONFIG_DEBUG_VIRTUAL is not set
CONFIG_DEBUG_MEMORY_INIT=y
CONFIG_HAVE_DEBUG_STACKOVERFLOW=y
CONFIG_DEBUG_STACKOVERFLOW=y
CONFIG_HAVE_ARCH_KMEMCHECK=y
# CONFIG_DEBUG_SHIRQ is not set

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
CONFIG_PANIC_ON_OOPS=y
CONFIG_PANIC_ON_OOPS_VALUE=1
CONFIG_PANIC_TIMEOUT=0
CONFIG_SCHED_DEBUG=y
CONFIG_SCHEDSTATS=y
# CONFIG_TIMER_STATS is not set

#
# Lock Debugging (spinlocks, mutexes, etc...)
#
CONFIG_DEBUG_RT_MUTEXES=y
# CONFIG_RT_MUTEX_TESTER is not set
CONFIG_DEBUG_SPINLOCK=y
CONFIG_DEBUG_MUTEXES=y
CONFIG_DEBUG_WW_MUTEX_SLOWPATH=y
CONFIG_DEBUG_LOCK_ALLOC=y
CONFIG_PROVE_LOCKING=y
CONFIG_LOCKDEP=y
CONFIG_LOCK_STAT=y
CONFIG_DEBUG_LOCKDEP=y
CONFIG_DEBUG_ATOMIC_SLEEP=y
CONFIG_DEBUG_LOCKING_API_SELFTESTS=y
CONFIG_LOCK_TORTURE_TEST=y
CONFIG_TRACE_IRQFLAGS=y
CONFIG_STACKTRACE=y
# CONFIG_DEBUG_KOBJECT is not set
CONFIG_DEBUG_BUGVERBOSE=y
# CONFIG_DEBUG_LIST is not set
# CONFIG_DEBUG_PI_LIST is not set
CONFIG_DEBUG_SG=y
# CONFIG_DEBUG_NOTIFIERS is not set
# CONFIG_DEBUG_CREDENTIALS is not set

#
# RCU Debugging
#
CONFIG_PROVE_RCU=y
# CONFIG_PROVE_RCU_REPEATEDLY is not set
# CONFIG_SPARSE_RCU_POINTER is not set
CONFIG_TORTURE_TEST=y
# CONFIG_RCU_TORTURE_TEST is not set
CONFIG_RCU_CPU_STALL_TIMEOUT=21
CONFIG_RCU_TRACE=y
CONFIG_NOTIFIER_ERROR_INJECTION=y
CONFIG_PM_NOTIFIER_ERROR_INJECT=y
CONFIG_FAULT_INJECTION=y
# CONFIG_FAILSLAB is not set
CONFIG_FAIL_PAGE_ALLOC=y
CONFIG_FAIL_MMC_REQUEST=y
# CONFIG_FAULT_INJECTION_DEBUG_FS is not set
CONFIG_LATENCYTOP=y
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
CONFIG_TEST_LIST_SORT=y
# CONFIG_BACKTRACE_SELF_TEST is not set
CONFIG_RBTREE_TEST=y
CONFIG_ATOMIC64_SELFTEST=y
CONFIG_TEST_STRING_HELPERS=y
CONFIG_TEST_KSTRTOX=y
# CONFIG_PROVIDE_OHCI1394_DMA_INIT is not set
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
CONFIG_DOUBLEFAULT=y
# CONFIG_DEBUG_TLBFLUSH is not set
# CONFIG_IOMMU_STRESS is not set
CONFIG_HAVE_MMIOTRACE_SUPPORT=y
CONFIG_IO_DELAY_TYPE_0X80=0
CONFIG_IO_DELAY_TYPE_0XED=1
CONFIG_IO_DELAY_TYPE_UDELAY=2
CONFIG_IO_DELAY_TYPE_NONE=3
# CONFIG_IO_DELAY_0X80 is not set
# CONFIG_IO_DELAY_0XED is not set
CONFIG_IO_DELAY_UDELAY=y
# CONFIG_IO_DELAY_NONE is not set
CONFIG_DEFAULT_IO_DELAY_TYPE=2
CONFIG_DEBUG_BOOT_PARAMS=y
# CONFIG_CPA_DEBUG is not set
CONFIG_OPTIMIZE_INLINING=y
# CONFIG_DEBUG_NMI_SELFTEST is not set
# CONFIG_X86_DEBUG_STATIC_CPU_HAS is not set

#
# Security options
#
CONFIG_KEYS=y
CONFIG_PERSISTENT_KEYRINGS=y
CONFIG_TRUSTED_KEYS=y
CONFIG_ENCRYPTED_KEYS=y
# CONFIG_KEYS_DEBUG_PROC_KEYS is not set
# CONFIG_SECURITY_DMESG_RESTRICT is not set
CONFIG_SECURITY=y
CONFIG_SECURITYFS=y
CONFIG_SECURITY_NETWORK=y
CONFIG_SECURITY_PATH=y
# CONFIG_SECURITY_TOMOYO is not set
# CONFIG_SECURITY_APPARMOR is not set
CONFIG_SECURITY_YAMA=y
# CONFIG_SECURITY_YAMA_STACKED is not set
CONFIG_INTEGRITY=y
# CONFIG_INTEGRITY_SIGNATURE is not set
CONFIG_IMA=y
CONFIG_IMA_MEASURE_PCR_IDX=10
CONFIG_IMA_TEMPLATE=y
# CONFIG_IMA_NG_TEMPLATE is not set
# CONFIG_IMA_SIG_TEMPLATE is not set
CONFIG_IMA_DEFAULT_TEMPLATE="ima"
CONFIG_IMA_DEFAULT_HASH_SHA1=y
CONFIG_IMA_DEFAULT_HASH="sha1"
CONFIG_IMA_APPRAISE=y
CONFIG_EVM=y

#
# EVM options
#
# CONFIG_EVM_ATTR_FSUUID is not set
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
# CONFIG_CRYPTO_MANAGER_DISABLE_TESTS is not set
CONFIG_CRYPTO_GF128MUL=y
CONFIG_CRYPTO_NULL=y
CONFIG_CRYPTO_WORKQUEUE=y
CONFIG_CRYPTO_CRYPTD=y
CONFIG_CRYPTO_AUTHENC=y

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
# CONFIG_CRYPTO_LRW is not set
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
# CONFIG_CRYPTO_CRC32 is not set
CONFIG_CRYPTO_CRC32_PCLMUL=y
CONFIG_CRYPTO_CRCT10DIF=y
CONFIG_CRYPTO_GHASH=y
CONFIG_CRYPTO_MD4=y
CONFIG_CRYPTO_MD5=y
CONFIG_CRYPTO_MICHAEL_MIC=y
CONFIG_CRYPTO_RMD128=y
# CONFIG_CRYPTO_RMD160 is not set
CONFIG_CRYPTO_RMD256=y
# CONFIG_CRYPTO_RMD320 is not set
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
# CONFIG_CRYPTO_AES_NI_INTEL is not set
CONFIG_CRYPTO_ANUBIS=y
CONFIG_CRYPTO_ARC4=y
# CONFIG_CRYPTO_BLOWFISH is not set
CONFIG_CRYPTO_CAMELLIA=y
CONFIG_CRYPTO_CAST_COMMON=y
# CONFIG_CRYPTO_CAST5 is not set
CONFIG_CRYPTO_CAST6=y
CONFIG_CRYPTO_DES=y
CONFIG_CRYPTO_FCRYPT=y
# CONFIG_CRYPTO_KHAZAD is not set
CONFIG_CRYPTO_SALSA20=y
# CONFIG_CRYPTO_SALSA20_586 is not set
# CONFIG_CRYPTO_SEED is not set
CONFIG_CRYPTO_SERPENT=y
# CONFIG_CRYPTO_SERPENT_SSE2_586 is not set
# CONFIG_CRYPTO_TEA is not set
CONFIG_CRYPTO_TWOFISH=y
CONFIG_CRYPTO_TWOFISH_COMMON=y
CONFIG_CRYPTO_TWOFISH_586=y

#
# Compression
#
CONFIG_CRYPTO_DEFLATE=y
CONFIG_CRYPTO_ZLIB=y
# CONFIG_CRYPTO_LZO is not set
# CONFIG_CRYPTO_LZ4 is not set
CONFIG_CRYPTO_LZ4HC=y

#
# Random Number Generation
#
# CONFIG_CRYPTO_ANSI_CPRNG is not set
# CONFIG_CRYPTO_USER_API_HASH is not set
# CONFIG_CRYPTO_USER_API_SKCIPHER is not set
CONFIG_CRYPTO_HASH_INFO=y
CONFIG_CRYPTO_HW=y
CONFIG_CRYPTO_DEV_PADLOCK=y
# CONFIG_CRYPTO_DEV_PADLOCK_AES is not set
# CONFIG_CRYPTO_DEV_PADLOCK_SHA is not set
CONFIG_CRYPTO_DEV_GEODE=y
CONFIG_CRYPTO_DEV_HIFN_795X=y
# CONFIG_CRYPTO_DEV_HIFN_795X_RNG is not set
# CONFIG_CRYPTO_DEV_CCP is not set
CONFIG_ASYMMETRIC_KEY_TYPE=y
# CONFIG_ASYMMETRIC_PUBLIC_KEY_SUBTYPE is not set
# CONFIG_PUBLIC_KEY_ALGO_RSA is not set
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
# CONFIG_AUDIT_ARCH_COMPAT_GENERIC is not set
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
CONFIG_ASSOCIATIVE_ARRAY=y
CONFIG_HAS_IOMEM=y
CONFIG_HAS_IOPORT_MAP=y
CONFIG_HAS_DMA=y
CONFIG_CHECK_SIGNATURE=y
CONFIG_DQL=y
CONFIG_NLATTR=y
CONFIG_ARCH_HAS_ATOMIC64_DEC_IF_POSITIVE=y
CONFIG_AVERAGE=y
CONFIG_CORDIC=y
CONFIG_DDR=y

--Ah40dssYA/cDqAW1
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

_______________________________________________
LKP mailing list
LKP@linux.intel.com

--Ah40dssYA/cDqAW1--
