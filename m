Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752668AbaCXJfK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Mar 2014 05:35:10 -0400
Received: from mga02.intel.com ([134.134.136.20]:11047 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752454AbaCXJfE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Mar 2014 05:35:04 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,719,1389772800"; 
   d="log'?scan'208";a="498186345"
Date: Mon, 24 Mar 2014 17:34:26 +0800
From: Fengguang Wu <fengguang.wu@intel.com>
To: Kees Cook <keescook@chromium.org>
Cc: linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org
Subject: [LSM] Kernel panic - not syncing: Could not register MntRestrict
 security module
Message-ID: <20140324093426.GA10565@localhost>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="HcAYCG3uE/tztfnV"
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--HcAYCG3uE/tztfnV
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi Kees,

I got the below dmesg and the first bad commit is

git://git.kernel.org/pub/scm/linux/kernel/git/kees/linux.git lsm-mnt-restrict

commit 2301503dfef14f2fd017a850f080c63ac5c022b7
Author:     Kees Cook <keescook@chromium.org>
AuthorDate: Sat Sep 21 15:52:51 2013 -0700
Commit:     Kees Cook <keescook@chromium.org>
CommitDate: Sat Mar 22 21:21:26 2014 -0700

    LSM: MntRestrict blocks mounts on symlink targets
    
    On systems where certain filesystem contents cannot be entirely trusted,
    it is beneficial to block mounts on symlinks. This makes sure that
    malicious filesystem contents cannot trigger the over-mounting of trusted
    filesystems. (For example, a bind-mounted subdirectory of /var cannot be
    redirected to mount on /etc via a symlink: a daemon cannot elevate privs
    to uid-0.)
    
    Signed-off-by: Kees Cook <keescook@chromium.org>

+-------------------------------------------------------------------------+------------+
|                                                                         | 2301503dfe |
+-------------------------------------------------------------------------+------------+
| boot_successes                                                          | 0          |
| boot_failures                                                           | 20         |
| Kernel_panic-not_syncing:Could_not_register_MntRestrict_security_module | 20         |
| backtrace:panic                                                         | 20         |
| backtrace:mntrestrict_init                                              | 20         |
| backtrace:security_init                                                 | 20         |
+-------------------------------------------------------------------------+------------+

[    0.014599] ACPI: All ACPI Tables successfully acquired
[    0.016134] Security Framework initialized
[    0.017212] AppArmor: AppArmor initialized
[    0.018274] Kernel panic - not syncing: Could not register MntRestrict security module
[    0.020000] CPU: 0 PID: 0 Comm: swapper Not tainted 3.14.0-rc7-00067-g2301503 #8
[    0.020000] Hardware name: Bochs Bochs, BIOS Bochs 01/01/2011
[    0.020000]  c1d321b4 c1d321b4 c1a8bf88 c17517b0 c1a8bfa8 c17497a4 c199edd4 c1d4c280
[    0.020000]  c1cc2c55 c1d321b4 00000000 c1d41800 c1a8bfb4 c1cc3d6d c19e5a2c c1a8bfc4
[    0.020000]  c1cc2c1b c19e5170 00000000 c1a8bfec c1c9face 00000139 ffffffff ffffffff
[    0.020000] Call Trace:
[    0.020000]  [<c17517b0>] dump_stack+0x16/0x18
[    0.020000]  [<c17497a4>] panic+0x87/0x16f
[    0.020000]  [<c1cc2c55>] ? register_security+0x12/0x4d
[    0.020000]  [<c1cc3d6d>] mntrestrict_init+0x1e/0x2e
[    0.020000]  [<c1cc2c1b>] security_init+0x2e/0x3f
[    0.020000]  [<c1c9face>] start_kernel+0x35a/0x3f1
[    0.020000]  [<c1c9f569>] ? repair_env_string+0x51/0x51
[    0.020000]  [<c1c9f384>] i386_start_kernel+0x12e/0x131

git bisect start 9d75006403b56a9702d32c686d983177154a15cf dcb99fd9b08cfe1afe426af4d8d3cbc429190f15 --
git bisect  bad c38bb1f78b1ebfad745879c1827d17e4d3b9d5d5  # 14:25      0-     20  Merge 'kees/ptdump' into devel-hourly-2014032413
git bisect good c561c526ad68116fea77947b2996c7b0f0b94431  # 14:30     20+      0  Merge 'pm/acpi-video' into devel-hourly-2014032413
git bisect  bad d8e463d588233b2bc3badcc38beeb82c190cde07  # 14:42      0-     16  Merge 'kees/lsm-mnt-restrict' into devel-hourly-2014032413
git bisect good 9b40431289e8e1dc51919a30a34c32bacf426975  # 14:56     20+      0  Merge 'rusty/virtio-next' into devel-hourly-2014032413
git bisect good 259cc2d0f7882b58f398e0cbf5760633517652d9  # 15:07     20+      1  Merge 'pm/master' into devel-hourly-2014032413
git bisect  bad 2301503dfef14f2fd017a850f080c63ac5c022b7  # 15:12      0-     12  LSM: MntRestrict blocks mounts on symlink targets
# first bad commit: [2301503dfef14f2fd017a850f080c63ac5c022b7] LSM: MntRestrict blocks mounts on symlink targets
git bisect good 774868c7094d35b4518be3d0e654de000a5d11fc  # 15:16     60+      0  Merge branch 'perf-urgent-for-linus' of git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip
git bisect  bad 9d75006403b56a9702d32c686d983177154a15cf  # 15:16      0-     19  0day head guard for 'devel-hourly-2014032413'
git bisect good 774868c7094d35b4518be3d0e654de000a5d11fc  # 15:17     60+      0  Merge branch 'perf-urgent-for-linus' of git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip
git bisect good 06ed26d1de59ce7cbbe68378b7e470be169750e5  # 15:22     60+      0  Add linux-next specific files for 20140321


This script may reproduce the error.

-----------------------------------------------------------------------------
#!/bin/bash

kernel=$1
initrd=yocto-minimal-i386.cgz

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

--HcAYCG3uE/tztfnV
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="dmesg-yocto-jaketown-10:20140324151244:i386-randconfig-iv4-0324::"
Content-Transfer-Encoding: quoted-printable

early console in setup code
Probing EDD (edd=3Doff to disable)... ok
[    0.000000] Initializing cgroup subsys cpu
[    0.000000] Linux version 3.14.0-rc7-00067-g2301503 (kbuild@ivytown2) (g=
cc version 4.8.1 (Debian 4.8.1-8) ) #8 Mon Mar 24 15:11:38 CST 2014
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
[    0.000000] NX (Execute Disable) protection: active
[    0.000000] SMBIOS 2.4 present.
[    0.000000] DMI: Bochs Bochs, BIOS Bochs 01/01/2011
[    0.000000] Hypervisor detected: KVM
[    0.000000] e820: update [mem 0x00000000-0x00000fff] usable =3D=3D> rese=
rved
[    0.000000] e820: remove [mem 0x000a0000-0x000fffff] usable
[    0.000000] e820: last_pfn =3D 0xfffe max_arch_pfn =3D 0x1000000
[    0.000000] Scanning 1 areas for low memory corruption
[    0.000000] initial memory mapped: [mem 0x00000000-0x027fffff]
[    0.000000] Base memory trampoline at [c009b000] 9b000 size 16384
[    0.000000] init_memory_mapping: [mem 0x00000000-0x000fffff]
[    0.000000]  [mem 0x00000000-0x000fffff] page 4k
[    0.000000] init_memory_mapping: [mem 0x0fa00000-0x0fbfffff]
[    0.000000]  [mem 0x0fa00000-0x0fbfffff] page 4k
[    0.000000] BRK [0x022b0000, 0x022b0fff] PGTABLE
[    0.000000] init_memory_mapping: [mem 0x0c000000-0x0f9fffff]
[    0.000000]  [mem 0x0c000000-0x0f9fffff] page 4k
[    0.000000] BRK [0x022b1000, 0x022b1fff] PGTABLE
[    0.000000] BRK [0x022b2000, 0x022b2fff] PGTABLE
[    0.000000] BRK [0x022b3000, 0x022b3fff] PGTABLE
[    0.000000] BRK [0x022b4000, 0x022b4fff] PGTABLE
[    0.000000] BRK [0x022b5000, 0x022b5fff] PGTABLE
[    0.000000] init_memory_mapping: [mem 0x00100000-0x0bffffff]
[    0.000000]  [mem 0x00100000-0x0bffffff] page 4k
[    0.000000] init_memory_mapping: [mem 0x0fc00000-0x0fffdfff]
[    0.000000]  [mem 0x0fc00000-0x0fffdfff] page 4k
[    0.000000] RAMDISK: [mem 0x0fcbd000-0x0ffeffff]
[    0.000000] ACPI: RSDP 000fd950 000014 (v00 BOCHS )
[    0.000000] ACPI: RSDT 0fffe450 000034 (v01 BOCHS  BXPCRSDT 00000001 BXP=
C 00000001)
[    0.000000] ACPI: FACP 0fffff80 000074 (v01 BOCHS  BXPCFACP 00000001 BXP=
C 00000001)
[    0.000000] ACPI: DSDT 0fffe490 0011A9 (v01   BXPC   BXDSDT 00000001 INT=
L 20100528)
[    0.000000] ACPI: FACS 0fffff40 000040
[    0.000000] ACPI: SSDT 0ffff7a0 000796 (v01 BOCHS  BXPCSSDT 00000001 BXP=
C 00000001)
[    0.000000] ACPI: APIC 0ffff680 000080 (v01 BOCHS  BXPCAPIC 00000001 BXP=
C 00000001)
[    0.000000] ACPI: HPET 0ffff640 000038 (v01 BOCHS  BXPCHPET 00000001 BXP=
C 00000001)
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] mapped APIC to         ffffb000 (        fee00000)
[    0.000000] 255MB LOWMEM available.
[    0.000000]   mapped low ram: 0 - 0fffe000
[    0.000000]   low ram: 0 - 0fffe000
[    0.000000] kvm-clock: Using msrs 4b564d01 and 4b564d00
[    0.000000] kvm-clock: cpu 0, msr 0:fffd001, boot clock
[    0.000000] Zone ranges:
[    0.000000]   Normal   [mem 0x00001000-0x0fffdfff]
[    0.000000] Movable zone start for each node
[    0.000000] Early memory node ranges
[    0.000000]   node   0: [mem 0x00001000-0x0009efff]
[    0.000000]   node   0: [mem 0x00100000-0x0fffdfff]
[    0.000000] On node 0 totalpages: 65436
[    0.000000] free_area_init_node: node 0, pgdat c1c58a20, node_mem_map cf=
95a024
[    0.000000]   Normal zone: 576 pages used for memmap
[    0.000000]   Normal zone: 0 pages reserved
[    0.000000]   Normal zone: 65436 pages, LIFO batch:15
[    0.000000] Using APIC driver default
[    0.000000] ACPI: PM-Timer IO Port: 0xb008
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] mapped APIC to         ffffb000 (        fee00000)
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
[    0.000000] mapped IOAPIC to ffffa000 (fec00000)
[    0.000000] nr_irqs_gsi: 40
[    0.000000] KVM setup async PF for cpu 0
[    0.000000] kvm-stealtime: cpu 0, msr 1a9eec0
[    0.000000] e820: [mem 0x10000000-0xfeffbfff] available for PCI devices
[    0.000000] Booting paravirtualized kernel on KVM
[    0.000000] pcpu-alloc: s0 r0 d32768 u32768 alloc=3D1*32768
[    0.000000] pcpu-alloc: [0] 0=20
[    0.000000] Built 1 zonelists in Zone order, mobility grouping on.  Tota=
l pages: 64860
[    0.000000] Kernel command line: hung_task_panic=3D1 earlyprintk=3DttyS0=
,115200 debug apic=3Ddebug sysrq_always_enabled rcupdate.rcu_cpu_stall_time=
out=3D100 panic=3D10 softlockup_panic=3D1 nmi_watchdog=3Dpanic  prompt_ramd=
isk=3D0 console=3DttyS0,115200 console=3Dtty0 vga=3Dnormal  root=3D/dev/ram=
0 rw link=3D/kernel-tests/run-queue/kvm/i386-randconfig-iv4-0324/linux-deve=
l:devel-hourly-2014032413:2301503dfef14f2fd017a850f080c63ac5c022b7:bisect-u=
sb/.vmlinuz-2301503dfef14f2fd017a850f080c63ac5c022b7-20140324151155-1-jaket=
own branch=3Dlinux-devel/devel-hourly-2014032413 BOOT_IMAGE=3D/kernel/i386-=
randconfig-iv4-0324/2301503dfef14f2fd017a850f080c63ac5c022b7/vmlinuz-3.14.0=
-rc7-00067-g2301503 drbd.minor_count=3D8
[    0.000000] sysrq: sysrq always enabled.
[    0.000000] PID hash table entries: 1024 (order: 0, 4096 bytes)
[    0.000000] Dentry cache hash table entries: 32768 (order: 5, 131072 byt=
es)
[    0.000000] Inode-cache hash table entries: 16384 (order: 4, 65536 bytes)
[    0.000000] Initializing CPU#0
[    0.000000] Memory: 236268K/261744K available (7562K kernel code, 2132K =
rwdata, 3220K rodata, 632K init, 5496K bss, 25476K reserved)
[    0.000000] virtual kernel memory layout:
[    0.000000]     fixmap  : 0xfffa1000 - 0xfffff000   ( 376 kB)
[    0.000000]     vmalloc : 0xd07fe000 - 0xfff9f000   ( 759 MB)
[    0.000000]     lowmem  : 0xc0000000 - 0xcfffe000   ( 255 MB)
[    0.000000]       .init : 0xc1c9f000 - 0xc1d3d000   ( 632 kB)
[    0.000000]       .data : 0xc1762ce6 - 0xc1c9e080   (5356 kB)
[    0.000000]       .text : 0xc1000000 - 0xc1762ce6   (7563 kB)
[    0.000000] Checking if this processor honours the WP bit even in superv=
isor mode...Ok.
[    0.000000] NR_IRQS:2304 nr_irqs:256 16
[    0.000000] CPU 0 irqstacks, hard=3Dc0096000 soft=3Dc0080000
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
[    0.000000] ODEBUG: 0 of 0 active objects replaced
[    0.000000] ODEBUG: selftest passed
[    0.000000] hpet clockevent registered
[    0.000000] tsc: Detected 1600.074 MHz processor
[    0.008000] Calibrating delay loop (skipped) preset value.. 3200.14 Bogo=
MIPS (lpj=3D6400296)
[    0.008014] pid_max: default: 32768 minimum: 301
[    0.009238] ACPI: Core revision 20131218
[    0.014599] ACPI: All ACPI Tables successfully acquired
[    0.016134] Security Framework initialized
[    0.017212] AppArmor: AppArmor initialized
[    0.018274] Kernel panic - not syncing: Could not register MntRestrict s=
ecurity module
[    0.020000] CPU: 0 PID: 0 Comm: swapper Not tainted 3.14.0-rc7-00067-g23=
01503 #8
[    0.020000] Hardware name: Bochs Bochs, BIOS Bochs 01/01/2011
[    0.020000]  c1d321b4 c1d321b4 c1a8bf88 c17517b0 c1a8bfa8 c17497a4 c199e=
dd4 c1d4c280
[    0.020000]  c1cc2c55 c1d321b4 00000000 c1d41800 c1a8bfb4 c1cc3d6d c19e5=
a2c c1a8bfc4
[    0.020000]  c1cc2c1b c19e5170 00000000 c1a8bfec c1c9face 00000139 fffff=
fff ffffffff
[    0.020000] Call Trace:
[    0.020000]  [<c17517b0>] dump_stack+0x16/0x18
[    0.020000]  [<c17497a4>] panic+0x87/0x16f
[    0.020000]  [<c1cc2c55>] ? register_security+0x12/0x4d
[    0.020000]  [<c1cc3d6d>] mntrestrict_init+0x1e/0x2e
[    0.020000]  [<c1cc2c1b>] security_init+0x2e/0x3f
[    0.020000]  [<c1c9face>] start_kernel+0x35a/0x3f1
[    0.020000]  [<c1c9f569>] ? repair_env_string+0x51/0x51
[    0.020000]  [<c1c9f384>] i386_start_kernel+0x12e/0x131

Elapsed time: 5
qemu-system-x86_64 -cpu kvm64 -enable-kvm -kernel /kernel/i386-randconfig-i=
v4-0324/2301503dfef14f2fd017a850f080c63ac5c022b7/vmlinuz-3.14.0-rc7-00067-g=
2301503 -append 'hung_task_panic=3D1 earlyprintk=3DttyS0,115200 debug apic=
=3Ddebug sysrq_always_enabled rcupdate.rcu_cpu_stall_timeout=3D100 panic=3D=
10 softlockup_panic=3D1 nmi_watchdog=3Dpanic  prompt_ramdisk=3D0 console=3D=
ttyS0,115200 console=3Dtty0 vga=3Dnormal  root=3D/dev/ram0 rw link=3D/kerne=
l-tests/run-queue/kvm/i386-randconfig-iv4-0324/linux-devel:devel-hourly-201=
4032413:2301503dfef14f2fd017a850f080c63ac5c022b7:bisect-usb/.vmlinuz-230150=
3dfef14f2fd017a850f080c63ac5c022b7-20140324151155-1-jaketown branch=3Dlinux=
-devel/devel-hourly-2014032413 BOOT_IMAGE=3D/kernel/i386-randconfig-iv4-032=
4/2301503dfef14f2fd017a850f080c63ac5c022b7/vmlinuz-3.14.0-rc7-00067-g230150=
3 drbd.minor_count=3D8'  -initrd /kernel-tests/initrd/yocto-minimal-i386.cg=
z -m 256 -smp 2 -net nic,vlan=3D1,model=3De1000 -net user,vlan=3D1,hostfwd=
=3Dtcp::10494-:22 -boot order=3Dnc -no-reboot -watchdog i6300esb -rtc base=
=3Dlocaltime -pidfile /dev/shm/kboot/pid-yocto-jaketown-10 -serial file:/de=
v/shm/kboot/serial-yocto-jaketown-10 -daemonize -display none -monitor null=
=20

--HcAYCG3uE/tztfnV
Content-Type: application/octet-stream
Content-Disposition: attachment; filename="i386-randconfig-iv4-0324-9d75006403b56a9702d32c686d983177154a15cf-Kernel-panic---not-syncing:-Could-not-register-MntRestrict-security-module-91194.log"
Content-Transfer-Encoding: base64

Z2l0IGNoZWNrb3V0IGRjYjk5ZmQ5YjA4Y2ZlMWFmZTQyNmFmNGQ4ZDNjYmM0MjkxOTBmMTUK
bHMgLWEgL2tlcm5lbC10ZXN0cy9ydW4tcXVldWUva3ZtL2kzODYtcmFuZGNvbmZpZy1pdjQt
MDMyNC9saW51eC1kZXZlbDpkZXZlbC1ob3VybHktMjAxNDAzMjQxMzpkY2I5OWZkOWIwOGNm
ZTFhZmU0MjZhZjRkOGQzY2JjNDI5MTkwZjE1OmJpc2VjdC11c2IKCjIwMTQtMDMtMjQtMTQ6
MTg6MDAgZGNiOTlmZDliMDhjZmUxYWZlNDI2YWY0ZDhkM2NiYzQyOTE5MGYxNSBjb21waWxp
bmcKUXVldWVkIGJ1aWxkIHRhc2sgdG8gL2tlcm5lbC10ZXN0cy9idWlsZC1xdWV1ZS9pMzg2
LXJhbmRjb25maWctaXY0LTAzMjQtZGNiOTlmZDliMDhjZmUxYWZlNDI2YWY0ZDhkM2NiYzQy
OTE5MGYxNQpDaGVjayBmb3Iga2VybmVsIGluIC9rZXJuZWwvaTM4Ni1yYW5kY29uZmlnLWl2
NC0wMzI0L2RjYjk5ZmQ5YjA4Y2ZlMWFmZTQyNmFmNGQ4ZDNjYmM0MjkxOTBmMTUKd2FpdGlu
ZyBmb3IgY29tcGxldGlvbiBvZiAva2VybmVsLXRlc3RzL2J1aWxkLXF1ZXVlL2kzODYtcmFu
ZGNvbmZpZy1pdjQtMDMyNC1kY2I5OWZkOWIwOGNmZTFhZmU0MjZhZjRkOGQzY2JjNDI5MTkw
ZjE1CndhaXRpbmcgZm9yIGNvbXBsZXRpb24gb2YgL2tlcm5lbC10ZXN0cy9idWlsZC1xdWV1
ZS8uaTM4Ni1yYW5kY29uZmlnLWl2NC0wMzI0LWRjYjk5ZmQ5YjA4Y2ZlMWFmZTQyNmFmNGQ4
ZDNjYmM0MjkxOTBmMTUKa2VybmVsOiAva2VybmVsL2kzODYtcmFuZGNvbmZpZy1pdjQtMDMy
NC9kY2I5OWZkOWIwOGNmZTFhZmU0MjZhZjRkOGQzY2JjNDI5MTkwZjE1L3ZtbGludXotMy4x
NC4wLXJjNwoKMjAxNC0wMy0yNC0xNDoyMDowMCBkZXRlY3RpbmcgYm9vdCBzdGF0ZSAJMTYu
CTE4CTIwIFNVQ0NFU1MKCmJpc2VjdDogZ29vZCBjb21taXQgZGNiOTlmZDliMDhjZmUxYWZl
NDI2YWY0ZDhkM2NiYzQyOTE5MGYxNQpnaXQgYmlzZWN0IHN0YXJ0IDlkNzUwMDY0MDNiNTZh
OTcwMmQzMmM2ODZkOTgzMTc3MTU0YTE1Y2YgZGNiOTlmZDliMDhjZmUxYWZlNDI2YWY0ZDhk
M2NiYzQyOTE5MGYxNSAtLQovYy9rZXJuZWwtdGVzdHMvbGluZWFyLWJpc2VjdDogWyItYiIs
ICI5ZDc1MDA2NDAzYjU2YTk3MDJkMzJjNjg2ZDk4MzE3NzE1NGExNWNmIiwgIi1nIiwgImRj
Yjk5ZmQ5YjA4Y2ZlMWFmZTQyNmFmNGQ4ZDNjYmM0MjkxOTBmMTUiLCAiL2Mva2VybmVsLXRl
c3RzL2Jpc2VjdC10ZXN0LWJvb3QtZmFpbHVyZS5zaCIsICIvaG9tZS93ZmcvdXNiL29iai1i
aXNlY3QiXQpCaXNlY3Rpbmc6IDk2NSByZXZpc2lvbnMgbGVmdCB0byB0ZXN0IGFmdGVyIHRo
aXMgKHJvdWdobHkgMTAgc3RlcHMpCltjMzhiYjFmNzhiMWViZmFkNzQ1ODc5YzE4MjdkMTdl
NGQzYjlkNWQ1XSBNZXJnZSAna2Vlcy9wdGR1bXAnIGludG8gZGV2ZWwtaG91cmx5LTIwMTQw
MzI0MTMKcnVubmluZyAvYy9rZXJuZWwtdGVzdHMvYmlzZWN0LXRlc3QtYm9vdC1mYWlsdXJl
LnNoIC9ob21lL3dmZy91c2Ivb2JqLWJpc2VjdApscyAtYSAva2VybmVsLXRlc3RzL3J1bi1x
dWV1ZS9rdm0vaTM4Ni1yYW5kY29uZmlnLWl2NC0wMzI0L2xpbnV4LWRldmVsOmRldmVsLWhv
dXJseS0yMDE0MDMyNDEzOmMzOGJiMWY3OGIxZWJmYWQ3NDU4NzljMTgyN2QxN2U0ZDNiOWQ1
ZDU6YmlzZWN0LXVzYgoKMjAxNC0wMy0yNC0xNDoyMjowMiBjMzhiYjFmNzhiMWViZmFkNzQ1
ODc5YzE4MjdkMTdlNGQzYjlkNWQ1IGNvbXBpbGluZwpRdWV1ZWQgYnVpbGQgdGFzayB0byAv
a2VybmVsLXRlc3RzL2J1aWxkLXF1ZXVlL2kzODYtcmFuZGNvbmZpZy1pdjQtMDMyNC1jMzhi
YjFmNzhiMWViZmFkNzQ1ODc5YzE4MjdkMTdlNGQzYjlkNWQ1CkNoZWNrIGZvciBrZXJuZWwg
aW4gL2tlcm5lbC9pMzg2LXJhbmRjb25maWctaXY0LTAzMjQvYzM4YmIxZjc4YjFlYmZhZDc0
NTg3OWMxODI3ZDE3ZTRkM2I5ZDVkNQp3YWl0aW5nIGZvciBjb21wbGV0aW9uIG9mIC9rZXJu
ZWwtdGVzdHMvYnVpbGQtcXVldWUvaTM4Ni1yYW5kY29uZmlnLWl2NC0wMzI0LWMzOGJiMWY3
OGIxZWJmYWQ3NDU4NzljMTgyN2QxN2U0ZDNiOWQ1ZDUKd2FpdGluZyBmb3IgY29tcGxldGlv
biBvZiAva2VybmVsLXRlc3RzL2J1aWxkLXF1ZXVlLy5pMzg2LXJhbmRjb25maWctaXY0LTAz
MjQtYzM4YmIxZjc4YjFlYmZhZDc0NTg3OWMxODI3ZDE3ZTRkM2I5ZDVkNQprZXJuZWw6IC9r
ZXJuZWwvaTM4Ni1yYW5kY29uZmlnLWl2NC0wMzI0L2MzOGJiMWY3OGIxZWJmYWQ3NDU4Nzlj
MTgyN2QxN2U0ZDNiOWQ1ZDUvdm1saW51ei0zLjE0LjAtcmM3LTAwNDE5LWdjMzhiYjFmCgoy
MDE0LTAzLTI0LTE0OjI1OjAyIGRldGVjdGluZyBib290IHN0YXRlIC4gVEVTVCBGQUlMVVJF
ClsgICAgMC4wMTA2ODddIEFDUEk6IEFsbCBBQ1BJIFRhYmxlcyBzdWNjZXNzZnVsbHkgYWNx
dWlyZWQKWyAgICAwLjAxMTQ4NV0gU2VjdXJpdHkgRnJhbWV3b3JrIGluaXRpYWxpemVkClsg
ICAgMC4wMTIwMjNdIEFwcEFybW9yOiBBcHBBcm1vciBpbml0aWFsaXplZApbICAgIDAuMDEy
NTUwXSBLZXJuZWwgcGFuaWMgLSBub3Qgc3luY2luZzogQ291bGQgbm90IHJlZ2lzdGVyIE1u
dFJlc3RyaWN0IHNlY3VyaXR5IG1vZHVsZQpbICAgIDAuMDEzNTI5XSBDUFU6IDAgUElEOiAw
IENvbW06IHN3YXBwZXIgTm90IHRhaW50ZWQgMy4xNC4wLXJjNy0wMDQxOS1nYzM4YmIxZiAj
MwpbICAgIDAuMDE0NDM4XSBIYXJkd2FyZSBuYW1lOiBCb2NocyBCb2NocywgQklPUyBCb2No
cyAwMS8wMS8yMDExClsgICAgMC4wMTUxNjNdICBjMWQzMjIxOCBjMWQzMjIxOCBjMWE4YmY4
OCBjMTc1MTZlMCBjMWE4YmZhOCBjMTc0OTZkNCBjMTk5ZWY1NCBjMWQ0YzI4MApbICAgIDAu
MDE2MDAwXSAgYzFjYzJjZjMgYzFkMzIyMTggMDAwMDAwMDAgYzFkNDE4MDAgYzFhOGJmYjQg
YzFjYzNlMGIgYzE5ZTViYTAgYzFhOGJmYzQKWyAgICAwLjAxNjAwMF0gIGMxY2MyY2I5IGMx
OWU1MmU0IDAwMDAwMDAwIGMxYThiZmVjIGMxYzlmYWNlIDAwMDAwMTM5IGZmZmZmZmZmIGZm
ZmZmZmZmClsgICAgMC4wMTYwMDBdIENhbGwgVHJhY2U6ClsgICAgMC4wMTYwMDBdICBbPGMx
NzUxNmUwPl0gZHVtcF9zdGFjaysweDE2LzB4MTgKWyAgICAwLjAxNjAwMF0gIFs8YzE3NDk2
ZDQ+XSBwYW5pYysweDg3LzB4MTZmClsgICAgMC4wMTYwMDBdICBbPGMxY2MyY2YzPl0gPyBy
ZWdpc3Rlcl9zZWN1cml0eSsweDEyLzB4NGQKWyAgICAwLjAxNjAwMF0gIFs8YzFjYzNlMGI+
XSBtbnRyZXN0cmljdF9pbml0KzB4MWUvMHgyZQpbICAgIDAuMDE2MDAwXSAgWzxjMWNjMmNi
OT5dIHNlY3VyaXR5X2luaXQrMHgyZS8weDNmClsgICAgMC4wMTYwMDBdICBbPGMxYzlmYWNl
Pl0gc3RhcnRfa2VybmVsKzB4MzVhLzB4M2YxClsgICAgMC4wMTYwMDBdICBbPGMxYzlmNTY5
Pl0gPyByZXBhaXJfZW52X3N0cmluZysweDUxLzB4NTEKWyAgICAwLjAxNjAwMF0gIFs8YzFj
OWYzODQ+XSBpMzg2X3N0YXJ0X2tlcm5lbCsweDEyZS8weDEzMQoKRWxhcHNlZCB0aW1lOiA1
CnFlbXUtc3lzdGVtLXg4Nl82NCAtY3B1IGt2bTY0IC1lbmFibGUta3ZtIC1rZXJuZWwgL2tl
cm5lbC9pMzg2LXJhbmRjb25maWctaXY0LTAzMjQvYzM4YmIxZjc4YjFlYmZhZDc0NTg3OWMx
ODI3ZDE3ZTRkM2I5ZDVkNS92bWxpbnV6LTMuMTQuMC1yYzctMDA0MTktZ2MzOGJiMWYgLWFw
cGVuZCAnaHVuZ190YXNrX3BhbmljPTEgZWFybHlwcmludGs9dHR5UzAsMTE1MjAwIGRlYnVn
IGFwaWM9ZGVidWcgc3lzcnFfYWx3YXlzX2VuYWJsZWQgcmN1cGRhdGUucmN1X2NwdV9zdGFs
bF90aW1lb3V0PTEwMCBwYW5pYz0xMCBzb2Z0bG9ja3VwX3BhbmljPTEgbm1pX3dhdGNoZG9n
PXBhbmljICBwcm9tcHRfcmFtZGlzaz0wIGNvbnNvbGU9dHR5UzAsMTE1MjAwIGNvbnNvbGU9
dHR5MCB2Z2E9bm9ybWFsICByb290PS9kZXYvcmFtMCBydyBsaW5rPS9rZXJuZWwtdGVzdHMv
cnVuLXF1ZXVlL2t2bS9pMzg2LXJhbmRjb25maWctaXY0LTAzMjQvbGludXgtZGV2ZWw6ZGV2
ZWwtaG91cmx5LTIwMTQwMzI0MTM6YzM4YmIxZjc4YjFlYmZhZDc0NTg3OWMxODI3ZDE3ZTRk
M2I5ZDVkNTpiaXNlY3QtdXNiLy52bWxpbnV6LWMzOGJiMWY3OGIxZWJmYWQ3NDU4NzljMTgy
N2QxN2U0ZDNiOWQ1ZDUtMjAxNDAzMjQxNDI0MTUtMTQtY2Fpcm8gYnJhbmNoPWxpbnV4LWRl
dmVsL2RldmVsLWhvdXJseS0yMDE0MDMyNDEzIEJPT1RfSU1BR0U9L2tlcm5lbC9pMzg2LXJh
bmRjb25maWctaXY0LTAzMjQvYzM4YmIxZjc4YjFlYmZhZDc0NTg3OWMxODI3ZDE3ZTRkM2I5
ZDVkNS92bWxpbnV6LTMuMTQuMC1yYzctMDA0MTktZ2MzOGJiMWYgZHJiZC5taW5vcl9jb3Vu
dD04JyAgLWluaXRyZCAva2VybmVsLXRlc3RzL2luaXRyZC9xdWFudGFsLWNvcmUtaTM4Ni5j
Z3ogLW0gMjU2IC1zbXAgMiAtbmV0IG5pYyx2bGFuPTEsbW9kZWw9ZTEwMDAgLW5ldCB1c2Vy
LHZsYW49MSxob3N0ZndkPXRjcDo6MTMxOTQtOjIyIC1ib290IG9yZGVyPW5jIC1uby1yZWJv
b3QgLXdhdGNoZG9nIGk2MzAwZXNiIC1ydGMgYmFzZT1sb2NhbHRpbWUgLWRyaXZlIGZpbGU9
L2ZzL0xBQkVMPUtWTS9kaXNrMC1xdWFudGFsLWNhaXJvLTI0LG1lZGlhPWRpc2ssaWY9dmly
dGlvIC1kcml2ZSBmaWxlPS9mcy9MQUJFTD1LVk0vZGlzazEtcXVhbnRhbC1jYWlyby0yNCxt
ZWRpYT1kaXNrLGlmPXZpcnRpbyAtZHJpdmUgZmlsZT0vZnMvTEFCRUw9S1ZNL2Rpc2syLXF1
YW50YWwtY2Fpcm8tMjQsbWVkaWE9ZGlzayxpZj12aXJ0aW8gLWRyaXZlIGZpbGU9L2ZzL0xB
QkVMPUtWTS9kaXNrMy1xdWFudGFsLWNhaXJvLTI0LG1lZGlhPWRpc2ssaWY9dmlydGlvIC1k
cml2ZSBmaWxlPS9mcy9MQUJFTD1LVk0vZGlzazQtcXVhbnRhbC1jYWlyby0yNCxtZWRpYT1k
aXNrLGlmPXZpcnRpbyAtZHJpdmUgZmlsZT0vZnMvTEFCRUw9S1ZNL2Rpc2s1LXF1YW50YWwt
Y2Fpcm8tMjQsbWVkaWE9ZGlzayxpZj12aXJ0aW8gLXBpZGZpbGUgL2Rldi9zaG0va2Jvb3Qv
cGlkLXF1YW50YWwtY2Fpcm8tMjQgLXNlcmlhbCBmaWxlOi9kZXYvc2htL2tib290L3Nlcmlh
bC1xdWFudGFsLWNhaXJvLTI0IC1kYWVtb25pemUgLWRpc3BsYXkgbm9uZSAtbW9uaXRvciBu
dWxsIAova2VybmVsL2kzODYtcmFuZGNvbmZpZy1pdjQtMDMyNC9jMzhiYjFmNzhiMWViZmFk
NzQ1ODc5YzE4MjdkMTdlNGQzYjlkNWQ1L2RtZXNnLXF1YW50YWwtY2Fpcm8tMzE6MjAxNDAz
MjQxNDI0Mzg6aTM4Ni1yYW5kY29uZmlnLWl2NC0wMzI0OjMuMTQuMC1yYzctMDA0MTktZ2Mz
OGJiMWY6Mwova2VybmVsL2kzODYtcmFuZGNvbmZpZy1pdjQtMDMyNC9jMzhiYjFmNzhiMWVi
ZmFkNzQ1ODc5YzE4MjdkMTdlNGQzYjlkNWQ1L2RtZXNnLXF1YW50YWwtY2Fpcm8tNDQ6MjAx
NDAzMjQxNDI0Mzg6aTM4Ni1yYW5kY29uZmlnLWl2NC0wMzI0OjMuMTQuMC1yYzctMDA0MTkt
Z2MzOGJiMWY6Mwova2VybmVsL2kzODYtcmFuZGNvbmZpZy1pdjQtMDMyNC9jMzhiYjFmNzhi
MWViZmFkNzQ1ODc5YzE4MjdkMTdlNGQzYjlkNWQ1L2RtZXNnLXlvY3RvLWNhaXJvLTk6MjAx
NDAzMjQxNDI0Mzg6aTM4Ni1yYW5kY29uZmlnLWl2NC0wMzI0OjMuMTQuMC1yYzctMDA0MTkt
Z2MzOGJiMWY6Mwova2VybmVsL2kzODYtcmFuZGNvbmZpZy1pdjQtMDMyNC9jMzhiYjFmNzhi
MWViZmFkNzQ1ODc5YzE4MjdkMTdlNGQzYjlkNWQ1L2RtZXNnLXF1YW50YWwtY2Fpcm8tMjQ6
MjAxNDAzMjQxNDI0NDU6aTM4Ni1yYW5kY29uZmlnLWl2NC0wMzI0OjMuMTQuMC1yYzctMDA0
MTktZ2MzOGJiMWY6Mwova2VybmVsL2kzODYtcmFuZGNvbmZpZy1pdjQtMDMyNC9jMzhiYjFm
NzhiMWViZmFkNzQ1ODc5YzE4MjdkMTdlNGQzYjlkNWQ1L2RtZXNnLXF1YW50YWwtbGtwLXNi
MDQtNDU6MjAxNDAzMjQxNDI0NDc6aTM4Ni1yYW5kY29uZmlnLWl2NC0wMzI0OjMuMTQuMC1y
YzctMDA0MTktZ2MzOGJiMWY6Mwova2VybmVsL2kzODYtcmFuZGNvbmZpZy1pdjQtMDMyNC9j
MzhiYjFmNzhiMWViZmFkNzQ1ODc5YzE4MjdkMTdlNGQzYjlkNWQ1L2RtZXNnLXF1YW50YWwt
bGtwLXNiMDQtNjE6MjAxNDAzMjQxNDI0NDY6aTM4Ni1yYW5kY29uZmlnLWl2NC0wMzI0OjMu
MTQuMC1yYzctMDA0MTktZ2MzOGJiMWY6Mwova2VybmVsL2kzODYtcmFuZGNvbmZpZy1pdjQt
MDMyNC9jMzhiYjFmNzhiMWViZmFkNzQ1ODc5YzE4MjdkMTdlNGQzYjlkNWQ1L2RtZXNnLXF1
YW50YWwtcm9hbS00MzoyMDE0MDMyNDE0MjQ0NjppMzg2LXJhbmRjb25maWctaXY0LTAzMjQ6
My4xNC4wLXJjNy0wMDQxOS1nYzM4YmIxZjozCi9rZXJuZWwvaTM4Ni1yYW5kY29uZmlnLWl2
NC0wMzI0L2MzOGJiMWY3OGIxZWJmYWQ3NDU4NzljMTgyN2QxN2U0ZDNiOWQ1ZDUvZG1lc2ct
eW9jdG8tYXRoZW5zLTQ4OjIwMTQwMzI0MTQyNDQ3OmkzODYtcmFuZGNvbmZpZy1pdjQtMDMy
NDozLjE0LjAtcmM3LTAwNDE5LWdjMzhiYjFmOjMKL2tlcm5lbC9pMzg2LXJhbmRjb25maWct
aXY0LTAzMjQvYzM4YmIxZjc4YjFlYmZhZDc0NTg3OWMxODI3ZDE3ZTRkM2I5ZDVkNS9kbWVz
Zy15b2N0by1hdGhlbnMtOToyMDE0MDMyNDE0MjQ0OTppMzg2LXJhbmRjb25maWctaXY0LTAz
MjQ6My4xNC4wLXJjNy0wMDQxOS1nYzM4YmIxZjozCi9rZXJuZWwvaTM4Ni1yYW5kY29uZmln
LWl2NC0wMzI0L2MzOGJiMWY3OGIxZWJmYWQ3NDU4NzljMTgyN2QxN2U0ZDNiOWQ1ZDUvZG1l
c2cteW9jdG8tY2Fpcm8tMjk6MjAxNDAzMjQxNDI0NDM6aTM4Ni1yYW5kY29uZmlnLWl2NC0w
MzI0OjMuMTQuMC1yYzctMDA0MTktZ2MzOGJiMWY6Mwova2VybmVsL2kzODYtcmFuZGNvbmZp
Zy1pdjQtMDMyNC9jMzhiYjFmNzhiMWViZmFkNzQ1ODc5YzE4MjdkMTdlNGQzYjlkNWQ1L2Rt
ZXNnLXlvY3RvLWlubi0yNzoyMDE0MDMyNDE0MjQ0ODppMzg2LXJhbmRjb25maWctaXY0LTAz
MjQ6Ogova2VybmVsL2kzODYtcmFuZGNvbmZpZy1pdjQtMDMyNC9jMzhiYjFmNzhiMWViZmFk
NzQ1ODc5YzE4MjdkMTdlNGQzYjlkNWQ1L2RtZXNnLXlvY3RvLWpha2V0b3duLTQzOjIwMTQw
MzI0MTQyNDQyOmkzODYtcmFuZGNvbmZpZy1pdjQtMDMyNDo6Ci9rZXJuZWwvaTM4Ni1yYW5k
Y29uZmlnLWl2NC0wMzI0L2MzOGJiMWY3OGIxZWJmYWQ3NDU4NzljMTgyN2QxN2U0ZDNiOWQ1
ZDUvZG1lc2ctcXVhbnRhbC1pdnl0b3duMi0zMToyMDE0MDMyNDE0MjQ1MTppMzg2LXJhbmRj
b25maWctaXY0LTAzMjQ6My4xNC4wLXJjNy0wMDQxOS1nYzM4YmIxZjozCi9rZXJuZWwvaTM4
Ni1yYW5kY29uZmlnLWl2NC0wMzI0L2MzOGJiMWY3OGIxZWJmYWQ3NDU4NzljMTgyN2QxN2U0
ZDNiOWQ1ZDUvZG1lc2ctcXVhbnRhbC1pdnl0b3duMi03MzoyMDE0MDMyNDE0MjQ1MDppMzg2
LXJhbmRjb25maWctaXY0LTAzMjQ6My4xNC4wLXJjNy0wMDQxOS1nYzM4YmIxZjozCi9rZXJu
ZWwvaTM4Ni1yYW5kY29uZmlnLWl2NC0wMzI0L2MzOGJiMWY3OGIxZWJmYWQ3NDU4NzljMTgy
N2QxN2U0ZDNiOWQ1ZDUvZG1lc2cteW9jdG8tY2Fpcm8tNDY6MjAxNDAzMjQxNDI0NTA6aTM4
Ni1yYW5kY29uZmlnLWl2NC0wMzI0OjMuMTQuMC1yYzctMDA0MTktZ2MzOGJiMWY6Mwova2Vy
bmVsL2kzODYtcmFuZGNvbmZpZy1pdjQtMDMyNC9jMzhiYjFmNzhiMWViZmFkNzQ1ODc5YzE4
MjdkMTdlNGQzYjlkNWQ1L2RtZXNnLXlvY3RvLWl2eXRvd24yLTMwOjIwMTQwMzI0MTQyNDUw
OmkzODYtcmFuZGNvbmZpZy1pdjQtMDMyNDozLjE0LjAtcmM3LTAwNDE5LWdjMzhiYjFmOjMK
L2tlcm5lbC9pMzg2LXJhbmRjb25maWctaXY0LTAzMjQvYzM4YmIxZjc4YjFlYmZhZDc0NTg3
OWMxODI3ZDE3ZTRkM2I5ZDVkNS9kbWVzZy15b2N0by1pdnl0b3duMi0zMzoyMDE0MDMyNDE0
MjQ1MDppMzg2LXJhbmRjb25maWctaXY0LTAzMjQ6My4xNC4wLXJjNy0wMDQxOS1nYzM4YmIx
ZjozCi9rZXJuZWwvaTM4Ni1yYW5kY29uZmlnLWl2NC0wMzI0L2MzOGJiMWY3OGIxZWJmYWQ3
NDU4NzljMTgyN2QxN2U0ZDNiOWQ1ZDUvZG1lc2cteW9jdG8taXZ5dG93bjItNjY6MjAxNDAz
MjQxNDI0NTE6aTM4Ni1yYW5kY29uZmlnLWl2NC0wMzI0OjMuMTQuMC1yYzctMDA0MTktZ2Mz
OGJiMWY6Mwova2VybmVsL2kzODYtcmFuZGNvbmZpZy1pdjQtMDMyNC9jMzhiYjFmNzhiMWVi
ZmFkNzQ1ODc5YzE4MjdkMTdlNGQzYjlkNWQ1L2RtZXNnLXlvY3RvLWl2eXRvd24yLTkyOjIw
MTQwMzI0MTQyNDUwOmkzODYtcmFuZGNvbmZpZy1pdjQtMDMyNDozLjE0LjAtcmM3LTAwNDE5
LWdjMzhiYjFmOjMKL2tlcm5lbC9pMzg2LXJhbmRjb25maWctaXY0LTAzMjQvYzM4YmIxZjc4
YjFlYmZhZDc0NTg3OWMxODI3ZDE3ZTRkM2I5ZDVkNS9kbWVzZy1xdWFudGFsLWl2eXRvd24y
LTUwOjIwMTQwMzI0MTQyNDUxOmkzODYtcmFuZGNvbmZpZy1pdjQtMDMyNDozLjE0LjAtcmM3
LTAwNDE5LWdjMzhiYjFmOjMKMDoyMDoyMCBhbGxfZ29vZDpiYWQ6YWxsX2JhZCBib290cwob
WzE7MzVtMjAxNC0wMy0yNCAxNDoyNTozMyBSRVBFQVQgQ09VTlQ6IDIwICAjIC9jYy93Zmcv
dXNiLWJpc2VjdC8ucmVwZWF0G1swbQoKQmlzZWN0aW5nOiA0MTkgcmV2aXNpb25zIGxlZnQg
dG8gdGVzdCBhZnRlciB0aGlzIChyb3VnaGx5IDkgc3RlcHMpCltjNTYxYzUyNmFkNjgxMTZm
ZWE3Nzk0N2IyOTk2YzdiMGYwYjk0NDMxXSBNZXJnZSAncG0vYWNwaS12aWRlbycgaW50byBk
ZXZlbC1ob3VybHktMjAxNDAzMjQxMwpydW5uaW5nIC9jL2tlcm5lbC10ZXN0cy9iaXNlY3Qt
dGVzdC1ib290LWZhaWx1cmUuc2ggL2hvbWUvd2ZnL3VzYi9vYmotYmlzZWN0CmxzIC1hIC9r
ZXJuZWwtdGVzdHMvcnVuLXF1ZXVlL2t2bS9pMzg2LXJhbmRjb25maWctaXY0LTAzMjQvbGlu
dXgtZGV2ZWw6ZGV2ZWwtaG91cmx5LTIwMTQwMzI0MTM6YzU2MWM1MjZhZDY4MTE2ZmVhNzc5
NDdiMjk5NmM3YjBmMGI5NDQzMTpiaXNlY3QtdXNiCgoyMDE0LTAzLTI0LTE0OjI1OjM0IGM1
NjFjNTI2YWQ2ODExNmZlYTc3OTQ3YjI5OTZjN2IwZjBiOTQ0MzEgY29tcGlsaW5nClF1ZXVl
ZCBidWlsZCB0YXNrIHRvIC9rZXJuZWwtdGVzdHMvYnVpbGQtcXVldWUvaTM4Ni1yYW5kY29u
ZmlnLWl2NC0wMzI0LWM1NjFjNTI2YWQ2ODExNmZlYTc3OTQ3YjI5OTZjN2IwZjBiOTQ0MzEK
Q2hlY2sgZm9yIGtlcm5lbCBpbiAva2VybmVsL2kzODYtcmFuZGNvbmZpZy1pdjQtMDMyNC9j
NTYxYzUyNmFkNjgxMTZmZWE3Nzk0N2IyOTk2YzdiMGYwYjk0NDMxCndhaXRpbmcgZm9yIGNv
bXBsZXRpb24gb2YgL2tlcm5lbC10ZXN0cy9idWlsZC1xdWV1ZS9pMzg2LXJhbmRjb25maWct
aXY0LTAzMjQtYzU2MWM1MjZhZDY4MTE2ZmVhNzc5NDdiMjk5NmM3YjBmMGI5NDQzMQp3YWl0
aW5nIGZvciBjb21wbGV0aW9uIG9mIC9rZXJuZWwtdGVzdHMvYnVpbGQtcXVldWUvLmkzODYt
cmFuZGNvbmZpZy1pdjQtMDMyNC1jNTYxYzUyNmFkNjgxMTZmZWE3Nzk0N2IyOTk2YzdiMGYw
Yjk0NDMxCmtlcm5lbDogL2tlcm5lbC9pMzg2LXJhbmRjb25maWctaXY0LTAzMjQvYzU2MWM1
MjZhZDY4MTE2ZmVhNzc5NDdiMjk5NmM3YjBmMGI5NDQzMS92bWxpbnV6LTMuMTQuMC1yYzct
MDAxMTQtZ2M1NjFjNTIKCjIwMTQtMDMtMjQtMTQ6Mjg6MzQgZGV0ZWN0aW5nIGJvb3Qgc3Rh
dGUgCTE0CTE3CTIwIFNVQ0NFU1MKCkJpc2VjdGluZzogMzA1IHJldmlzaW9ucyBsZWZ0IHRv
IHRlc3QgYWZ0ZXIgdGhpcyAocm91Z2hseSA5IHN0ZXBzKQpbZDhlNDYzZDU4ODIzM2IyYmMz
YmFkY2MzOGJlZWI4MmMxOTBjZGUwN10gTWVyZ2UgJ2tlZXMvbHNtLW1udC1yZXN0cmljdCcg
aW50byBkZXZlbC1ob3VybHktMjAxNDAzMjQxMwpydW5uaW5nIC9jL2tlcm5lbC10ZXN0cy9i
aXNlY3QtdGVzdC1ib290LWZhaWx1cmUuc2ggL2hvbWUvd2ZnL3VzYi9vYmotYmlzZWN0Cmxz
IC1hIC9rZXJuZWwtdGVzdHMvcnVuLXF1ZXVlL2t2bS9pMzg2LXJhbmRjb25maWctaXY0LTAz
MjQvbGludXgtZGV2ZWw6ZGV2ZWwtaG91cmx5LTIwMTQwMzI0MTM6ZDhlNDYzZDU4ODIzM2Iy
YmMzYmFkY2MzOGJlZWI4MmMxOTBjZGUwNzpiaXNlY3QtdXNiCgoyMDE0LTAzLTI0LTE0OjMw
OjA1IGQ4ZTQ2M2Q1ODgyMzNiMmJjM2JhZGNjMzhiZWViODJjMTkwY2RlMDcgY29tcGlsaW5n
ClF1ZXVlZCBidWlsZCB0YXNrIHRvIC9rZXJuZWwtdGVzdHMvYnVpbGQtcXVldWUvaTM4Ni1y
YW5kY29uZmlnLWl2NC0wMzI0LWQ4ZTQ2M2Q1ODgyMzNiMmJjM2JhZGNjMzhiZWViODJjMTkw
Y2RlMDcKQ2hlY2sgZm9yIGtlcm5lbCBpbiAva2VybmVsL2kzODYtcmFuZGNvbmZpZy1pdjQt
MDMyNC9kOGU0NjNkNTg4MjMzYjJiYzNiYWRjYzM4YmVlYjgyYzE5MGNkZTA3CndhaXRpbmcg
Zm9yIGNvbXBsZXRpb24gb2YgL2tlcm5lbC10ZXN0cy9idWlsZC1xdWV1ZS9pMzg2LXJhbmRj
b25maWctaXY0LTAzMjQtZDhlNDYzZDU4ODIzM2IyYmMzYmFkY2MzOGJlZWI4MmMxOTBjZGUw
Nwp3YWl0aW5nIGZvciBjb21wbGV0aW9uIG9mIC9rZXJuZWwtdGVzdHMvYnVpbGQtcXVldWUv
LmkzODYtcmFuZGNvbmZpZy1pdjQtMDMyNC1kOGU0NjNkNTg4MjMzYjJiYzNiYWRjYzM4YmVl
YjgyYzE5MGNkZTA3Cmtlcm5lbDogL2tlcm5lbC9pMzg2LXJhbmRjb25maWctaXY0LTAzMjQv
ZDhlNDYzZDU4ODIzM2IyYmMzYmFkY2MzOGJlZWI4MmMxOTBjZGUwNy92bWxpbnV6LTMuMTQu
MC1yYzctMDAzMjQtZ2Q4ZTQ2M2QKCjIwMTQtMDMtMjQtMTQ6NDI6MDUgZGV0ZWN0aW5nIGJv
b3Qgc3RhdGUgLiBURVNUIEZBSUxVUkUKWyAgICAwLjAwOTU4M10gQUNQSTogQWxsIEFDUEkg
VGFibGVzIHN1Y2Nlc3NmdWxseSBhY3F1aXJlZApbICAgIDAuMDEwMzM5XSBTZWN1cml0eSBG
cmFtZXdvcmsgaW5pdGlhbGl6ZWQKWyAgICAwLjAxMDgyN10gQXBwQXJtb3I6IEFwcEFybW9y
IGluaXRpYWxpemVkClsgICAgMC4wMTE0MDZdIEtlcm5lbCBwYW5pYyAtIG5vdCBzeW5jaW5n
OiBDb3VsZCBub3QgcmVnaXN0ZXIgTW50UmVzdHJpY3Qgc2VjdXJpdHkgbW9kdWxlClsgICAg
MC4wMTIwMDBdIENQVTogMCBQSUQ6IDAgQ29tbTogc3dhcHBlciBOb3QgdGFpbnRlZCAzLjE0
LjAtcmM3LTAwMzI0LWdkOGU0NjNkICM1ClsgICAgMC4wMTIwMDBdIEhhcmR3YXJlIG5hbWU6
IEJvY2hzIEJvY2hzLCBCSU9TIEJvY2hzIDAxLzAxLzIwMTEKWyAgICAwLjAxMjAwMF0gIGMx
ZDMyMWUwIGMxZDMyMWUwIGMxYThiZjg4IGMxNzUyMDAwIGMxYThiZmE4IGMxNzQ5ZmY0IGMx
OTlmZTY4IGMxZDRjMjgwClsgICAgMC4wMTIwMDBdICBjMWNjMmM1ZCBjMWQzMjFlMCAwMDAw
MDAwMCBjMWQ0MTgwMCBjMWE4YmZiNCBjMWNjM2Q3NSBjMTllNmFjMCBjMWE4YmZjNApbICAg
IDAuMDEyMDAwXSAgYzFjYzJjMjMgYzE5ZTYyMDQgMDAwMDAwMDAgYzFhOGJmZWMgYzFjOWZh
Y2UgMDAwMDAxMzkgZmZmZmZmZmYgZmZmZmZmZmYKWyAgICAwLjAxMjAwMF0gQ2FsbCBUcmFj
ZToKWyAgICAwLjAxMjAwMF0gIFs8YzE3NTIwMDA+XSBkdW1wX3N0YWNrKzB4MTYvMHgxOApb
ICAgIDAuMDEyMDAwXSAgWzxjMTc0OWZmND5dIHBhbmljKzB4ODcvMHgxNmYKWyAgICAwLjAx
MjAwMF0gIFs8YzFjYzJjNWQ+XSA/IHJlZ2lzdGVyX3NlY3VyaXR5KzB4MTIvMHg0ZApbICAg
IDAuMDEyMDAwXSAgWzxjMWNjM2Q3NT5dIG1udHJlc3RyaWN0X2luaXQrMHgxZS8weDJlClsg
ICAgMC4wMTIwMDBdICBbPGMxY2MyYzIzPl0gc2VjdXJpdHlfaW5pdCsweDJlLzB4M2YKWyAg
ICAwLjAxMjAwMF0gIFs8YzFjOWZhY2U+XSBzdGFydF9rZXJuZWwrMHgzNWEvMHgzZjEKWyAg
ICAwLjAxMjAwMF0gIFs8YzFjOWY1Njk+XSA/IHJlcGFpcl9lbnZfc3RyaW5nKzB4NTEvMHg1
MQpbICAgIDAuMDEyMDAwXSAgWzxjMWM5ZjM4ND5dIGkzODZfc3RhcnRfa2VybmVsKzB4MTJl
LzB4MTMxCgpFbGFwc2VkIHRpbWU6IDEwCnFlbXUtc3lzdGVtLXg4Nl82NCAtY3B1IGt2bTY0
IC1lbmFibGUta3ZtIC1rZXJuZWwgL2tlcm5lbC9pMzg2LXJhbmRjb25maWctaXY0LTAzMjQv
ZDhlNDYzZDU4ODIzM2IyYmMzYmFkY2MzOGJlZWI4MmMxOTBjZGUwNy92bWxpbnV6LTMuMTQu
MC1yYzctMDAzMjQtZ2Q4ZTQ2M2QgLWFwcGVuZCAnaHVuZ190YXNrX3BhbmljPTEgZWFybHlw
cmludGs9dHR5UzAsMTE1MjAwIGRlYnVnIGFwaWM9ZGVidWcgc3lzcnFfYWx3YXlzX2VuYWJs
ZWQgcmN1cGRhdGUucmN1X2NwdV9zdGFsbF90aW1lb3V0PTEwMCBwYW5pYz0xMCBzb2Z0bG9j
a3VwX3BhbmljPTEgbm1pX3dhdGNoZG9nPXBhbmljICBwcm9tcHRfcmFtZGlzaz0wIGNvbnNv
bGU9dHR5UzAsMTE1MjAwIGNvbnNvbGU9dHR5MCB2Z2E9bm9ybWFsICByb290PS9kZXYvcmFt
MCBydyBsaW5rPS9rZXJuZWwtdGVzdHMvcnVuLXF1ZXVlL2t2bS9pMzg2LXJhbmRjb25maWct
aXY0LTAzMjQvbGludXgtZGV2ZWw6ZGV2ZWwtaG91cmx5LTIwMTQwMzI0MTM6ZDhlNDYzZDU4
ODIzM2IyYmMzYmFkY2MzOGJlZWI4MmMxOTBjZGUwNzpiaXNlY3QtdXNiLy52bWxpbnV6LWQ4
ZTQ2M2Q1ODgyMzNiMmJjM2JhZGNjMzhiZWViODJjMTkwY2RlMDctMjAxNDAzMjQxNDQxMTgt
MjAtbGtwLXNiMDQgYnJhbmNoPWxpbnV4LWRldmVsL2RldmVsLWhvdXJseS0yMDE0MDMyNDEz
IEJPT1RfSU1BR0U9L2tlcm5lbC9pMzg2LXJhbmRjb25maWctaXY0LTAzMjQvZDhlNDYzZDU4
ODIzM2IyYmMzYmFkY2MzOGJlZWI4MmMxOTBjZGUwNy92bWxpbnV6LTMuMTQuMC1yYzctMDAz
MjQtZ2Q4ZTQ2M2QgZHJiZC5taW5vcl9jb3VudD04JyAgLWluaXRyZCAva2VybmVsLXRlc3Rz
L2luaXRyZC9xdWFudGFsLWNvcmUtaTM4Ni5jZ3ogLW0gMzIwIC1zbXAgMiAtbmV0IG5pYyx2
bGFuPTEsbW9kZWw9ZTEwMDAgLW5ldCB1c2VyLHZsYW49MSxob3N0ZndkPXRjcDo6MTEwODAt
OjIyIC1ib290IG9yZGVyPW5jIC1uby1yZWJvb3QgLXdhdGNoZG9nIGk2MzAwZXNiIC1ydGMg
YmFzZT1sb2NhbHRpbWUgLXBpZGZpbGUgL2Rldi9zaG0va2Jvb3QvcGlkLXF1YW50YWwtbGtw
LXNiMDQtMTYgLXNlcmlhbCBmaWxlOi9kZXYvc2htL2tib290L3NlcmlhbC1xdWFudGFsLWxr
cC1zYjA0LTE2IC1kYWVtb25pemUgLWRpc3BsYXkgbm9uZSAtbW9uaXRvciBudWxsIAova2Vy
bmVsL2kzODYtcmFuZGNvbmZpZy1pdjQtMDMyNC9kOGU0NjNkNTg4MjMzYjJiYzNiYWRjYzM4
YmVlYjgyYzE5MGNkZTA3L2RtZXNnLXlvY3RvLWxrcC1zYjA0LTM2OjIwMTQwMzI0MTQ0MTUy
OmkzODYtcmFuZGNvbmZpZy1pdjQtMDMyNDozLjE0LjAtcmM3LTAwMzI0LWdkOGU0NjNkOjUK
L2tlcm5lbC9pMzg2LXJhbmRjb25maWctaXY0LTAzMjQvZDhlNDYzZDU4ODIzM2IyYmMzYmFk
Y2MzOGJlZWI4MmMxOTBjZGUwNy9kbWVzZy15b2N0by1sa3Atc2IwNC02NDoyMDE0MDMyNDE0
NDE1NzppMzg2LXJhbmRjb25maWctaXY0LTAzMjQ6My4xNC4wLXJjNy0wMDMyNC1nZDhlNDYz
ZDo1Ci9rZXJuZWwvaTM4Ni1yYW5kY29uZmlnLWl2NC0wMzI0L2Q4ZTQ2M2Q1ODgyMzNiMmJj
M2JhZGNjMzhiZWViODJjMTkwY2RlMDcvZG1lc2ctcXVhbnRhbC1sa3Atc2IwNC01ODoyMDE0
MDMyNDE0NDE1OTppMzg2LXJhbmRjb25maWctaXY0LTAzMjQ6My4xNC4wLXJjNy0wMDMyNC1n
ZDhlNDYzZDo1Ci9rZXJuZWwvaTM4Ni1yYW5kY29uZmlnLWl2NC0wMzI0L2Q4ZTQ2M2Q1ODgy
MzNiMmJjM2JhZGNjMzhiZWViODJjMTkwY2RlMDcvZG1lc2ctcXVhbnRhbC1sa3Atc2IwNC03
OjIwMTQwMzI0MTQ0MjAwOmkzODYtcmFuZGNvbmZpZy1pdjQtMDMyNDozLjE0LjAtcmM3LTAw
MzI0LWdkOGU0NjNkOjUKL2tlcm5lbC9pMzg2LXJhbmRjb25maWctaXY0LTAzMjQvZDhlNDYz
ZDU4ODIzM2IyYmMzYmFkY2MzOGJlZWI4MmMxOTBjZGUwNy9kbWVzZy1xdWFudGFsLWxrcC1z
YjA0LTMxOjIwMTQwMzI0MTQ0MjIxOmkzODYtcmFuZGNvbmZpZy1pdjQtMDMyNDozLjE0LjAt
cmM3LTAwMzI0LWdkOGU0NjNkOjUKL2tlcm5lbC9pMzg2LXJhbmRjb25maWctaXY0LTAzMjQv
ZDhlNDYzZDU4ODIzM2IyYmMzYmFkY2MzOGJlZWI4MmMxOTBjZGUwNy9kbWVzZy1xdWFudGFs
LWxrcC1zYjA0LTUxOjIwMTQwMzI0MTQ0MjIzOmkzODYtcmFuZGNvbmZpZy1pdjQtMDMyNDoz
LjE0LjAtcmM3LTAwMzI0LWdkOGU0NjNkOjUKL2tlcm5lbC9pMzg2LXJhbmRjb25maWctaXY0
LTAzMjQvZDhlNDYzZDU4ODIzM2IyYmMzYmFkY2MzOGJlZWI4MmMxOTBjZGUwNy9kbWVzZy1x
dWFudGFsLWxrcC1zYjA0LTU4OjIwMTQwMzI0MTQ0MjIxOmkzODYtcmFuZGNvbmZpZy1pdjQt
MDMyNDozLjE0LjAtcmM3LTAwMzI0LWdkOGU0NjNkOjUKL2tlcm5lbC9pMzg2LXJhbmRjb25m
aWctaXY0LTAzMjQvZDhlNDYzZDU4ODIzM2IyYmMzYmFkY2MzOGJlZWI4MmMxOTBjZGUwNy9k
bWVzZy1xdWFudGFsLWxrcC1zYjA0LTc6MjAxNDAzMjQxNDQyMjE6aTM4Ni1yYW5kY29uZmln
LWl2NC0wMzI0OjMuMTQuMC1yYzctMDAzMjQtZ2Q4ZTQ2M2Q6NQova2VybmVsL2kzODYtcmFu
ZGNvbmZpZy1pdjQtMDMyNC9kOGU0NjNkNTg4MjMzYjJiYzNiYWRjYzM4YmVlYjgyYzE5MGNk
ZTA3L2RtZXNnLXlvY3RvLWxrcC1zYjA0LTEyOjIwMTQwMzI0MTQ0MjIzOmkzODYtcmFuZGNv
bmZpZy1pdjQtMDMyNDozLjE0LjAtcmM3LTAwMzI0LWdkOGU0NjNkOjUKL2tlcm5lbC9pMzg2
LXJhbmRjb25maWctaXY0LTAzMjQvZDhlNDYzZDU4ODIzM2IyYmMzYmFkY2MzOGJlZWI4MmMx
OTBjZGUwNy9kbWVzZy15b2N0by1sa3Atc2IwNC0xOjIwMTQwMzI0MTQ0MjIwOmkzODYtcmFu
ZGNvbmZpZy1pdjQtMDMyNDozLjE0LjAtcmM3LTAwMzI0LWdkOGU0NjNkOjUKL2tlcm5lbC9p
Mzg2LXJhbmRjb25maWctaXY0LTAzMjQvZDhlNDYzZDU4ODIzM2IyYmMzYmFkY2MzOGJlZWI4
MmMxOTBjZGUwNy9kbWVzZy15b2N0by1sa3Atc2IwNC0yOjIwMTQwMzI0MTQ0MjE4OmkzODYt
cmFuZGNvbmZpZy1pdjQtMDMyNDozLjE0LjAtcmM3LTAwMzI0LWdkOGU0NjNkOjUKL2tlcm5l
bC9pMzg2LXJhbmRjb25maWctaXY0LTAzMjQvZDhlNDYzZDU4ODIzM2IyYmMzYmFkY2MzOGJl
ZWI4MmMxOTBjZGUwNy9kbWVzZy15b2N0by1sa3Atc2IwNC01MzoyMDE0MDMyNDE0NDIxODpp
Mzg2LXJhbmRjb25maWctaXY0LTAzMjQ6My4xNC4wLXJjNy0wMDMyNC1nZDhlNDYzZDo1Ci9r
ZXJuZWwvaTM4Ni1yYW5kY29uZmlnLWl2NC0wMzI0L2Q4ZTQ2M2Q1ODgyMzNiMmJjM2JhZGNj
MzhiZWViODJjMTkwY2RlMDcvZG1lc2cteW9jdG8tbGtwLXNiMDQtNjQ6MjAxNDAzMjQxNDQy
MjM6aTM4Ni1yYW5kY29uZmlnLWl2NC0wMzI0OjMuMTQuMC1yYzctMDAzMjQtZ2Q4ZTQ2M2Q6
NQova2VybmVsL2kzODYtcmFuZGNvbmZpZy1pdjQtMDMyNC9kOGU0NjNkNTg4MjMzYjJiYzNi
YWRjYzM4YmVlYjgyYzE5MGNkZTA3L2RtZXNnLXlvY3RvLWxrcC1zYjA0LTk6MjAxNDAzMjQx
NDQyMTY6aTM4Ni1yYW5kY29uZmlnLWl2NC0wMzI0OjMuMTQuMC1yYzctMDAzMjQtZ2Q4ZTQ2
M2Q6NQova2VybmVsL2kzODYtcmFuZGNvbmZpZy1pdjQtMDMyNC9kOGU0NjNkNTg4MjMzYjJi
YzNiYWRjYzM4YmVlYjgyYzE5MGNkZTA3L2RtZXNnLXF1YW50YWwtbGtwLXNiMDQtMTY6MjAx
NDAzMjQxNDQyMjY6aTM4Ni1yYW5kY29uZmlnLWl2NC0wMzI0OjMuMTQuMC1yYzctMDAzMjQt
Z2Q4ZTQ2M2Q6NQova2VybmVsL2kzODYtcmFuZGNvbmZpZy1pdjQtMDMyNC9kOGU0NjNkNTg4
MjMzYjJiYzNiYWRjYzM4YmVlYjgyYzE5MGNkZTA3L2RtZXNnLXlvY3RvLWxrcC1zdDAxLTI6
MjAxNDAzMjQxNDQyMjQ6aTM4Ni1yYW5kY29uZmlnLWl2NC0wMzI0OjMuMTQuMC1yYzctMDAz
MjQtZ2Q4ZTQ2M2Q6NQowOjE2OjE2IGFsbF9nb29kOmJhZDphbGxfYmFkIGJvb3RzChtbMTsz
NW0yMDE0LTAzLTI0IDE0OjQyOjM2IFJFUEVBVCBDT1VOVDogMjAgICMgL2NjL3dmZy91c2It
YmlzZWN0Ly5yZXBlYXQbWzBtCgpCaXNlY3Rpbmc6IDIxMCByZXZpc2lvbnMgbGVmdCB0byB0
ZXN0IGFmdGVyIHRoaXMgKHJvdWdobHkgOCBzdGVwcykKWzliNDA0MzEyODllOGUxZGM1MTkx
OWEzMGEzNGMzMmJhY2Y0MjY5NzVdIE1lcmdlICdydXN0eS92aXJ0aW8tbmV4dCcgaW50byBk
ZXZlbC1ob3VybHktMjAxNDAzMjQxMwpydW5uaW5nIC9jL2tlcm5lbC10ZXN0cy9iaXNlY3Qt
dGVzdC1ib290LWZhaWx1cmUuc2ggL2hvbWUvd2ZnL3VzYi9vYmotYmlzZWN0CmxzIC1hIC9r
ZXJuZWwtdGVzdHMvcnVuLXF1ZXVlL2t2bS9pMzg2LXJhbmRjb25maWctaXY0LTAzMjQvbGlu
dXgtZGV2ZWw6ZGV2ZWwtaG91cmx5LTIwMTQwMzI0MTM6OWI0MDQzMTI4OWU4ZTFkYzUxOTE5
YTMwYTM0YzMyYmFjZjQyNjk3NTpiaXNlY3QtdXNiCgoyMDE0LTAzLTI0LTE0OjQyOjM3IDli
NDA0MzEyODllOGUxZGM1MTkxOWEzMGEzNGMzMmJhY2Y0MjY5NzUgY29tcGlsaW5nClF1ZXVl
ZCBidWlsZCB0YXNrIHRvIC9rZXJuZWwtdGVzdHMvYnVpbGQtcXVldWUvaTM4Ni1yYW5kY29u
ZmlnLWl2NC0wMzI0LTliNDA0MzEyODllOGUxZGM1MTkxOWEzMGEzNGMzMmJhY2Y0MjY5NzUK
Q2hlY2sgZm9yIGtlcm5lbCBpbiAva2VybmVsL2kzODYtcmFuZGNvbmZpZy1pdjQtMDMyNC85
YjQwNDMxMjg5ZThlMWRjNTE5MTlhMzBhMzRjMzJiYWNmNDI2OTc1CndhaXRpbmcgZm9yIGNv
bXBsZXRpb24gb2YgL2tlcm5lbC10ZXN0cy9idWlsZC1xdWV1ZS9pMzg2LXJhbmRjb25maWct
aXY0LTAzMjQtOWI0MDQzMTI4OWU4ZTFkYzUxOTE5YTMwYTM0YzMyYmFjZjQyNjk3NQp3YWl0
aW5nIGZvciBjb21wbGV0aW9uIG9mIC9rZXJuZWwtdGVzdHMvYnVpbGQtcXVldWUvLmkzODYt
cmFuZGNvbmZpZy1pdjQtMDMyNC05YjQwNDMxMjg5ZThlMWRjNTE5MTlhMzBhMzRjMzJiYWNm
NDI2OTc1Cmtlcm5lbDogL2tlcm5lbC9pMzg2LXJhbmRjb25maWctaXY0LTAzMjQvOWI0MDQz
MTI4OWU4ZTFkYzUxOTE5YTMwYTM0YzMyYmFjZjQyNjk3NS92bWxpbnV6LTMuMTQuMC1yYzct
MDAxMzYtZzliNDA0MzEKCjIwMTQtMDMtMjQtMTQ6NTQ6MzcgZGV0ZWN0aW5nIGJvb3Qgc3Rh
dGUgCTcJOAkyMCBTVUNDRVNTCgpCaXNlY3Rpbmc6IDE4OCByZXZpc2lvbnMgbGVmdCB0byB0
ZXN0IGFmdGVyIHRoaXMgKHJvdWdobHkgOCBzdGVwcykKWzI1OWNjMmQwZjc4ODJiNThmMzk4
ZTBjYmY1NzYwNjMzNTE3NjUyZDldIE1lcmdlICdwbS9tYXN0ZXInIGludG8gZGV2ZWwtaG91
cmx5LTIwMTQwMzI0MTMKcnVubmluZyAvYy9rZXJuZWwtdGVzdHMvYmlzZWN0LXRlc3QtYm9v
dC1mYWlsdXJlLnNoIC9ob21lL3dmZy91c2Ivb2JqLWJpc2VjdApscyAtYSAva2VybmVsLXRl
c3RzL3J1bi1xdWV1ZS9rdm0vaTM4Ni1yYW5kY29uZmlnLWl2NC0wMzI0L2xpbnV4LWRldmVs
OmRldmVsLWhvdXJseS0yMDE0MDMyNDEzOjI1OWNjMmQwZjc4ODJiNThmMzk4ZTBjYmY1NzYw
NjMzNTE3NjUyZDk6YmlzZWN0LXVzYgoKMjAxNC0wMy0yNC0xNDo1NjowOCAyNTljYzJkMGY3
ODgyYjU4ZjM5OGUwY2JmNTc2MDYzMzUxNzY1MmQ5IGNvbXBpbGluZwpRdWV1ZWQgYnVpbGQg
dGFzayB0byAva2VybmVsLXRlc3RzL2J1aWxkLXF1ZXVlL2kzODYtcmFuZGNvbmZpZy1pdjQt
MDMyNC0yNTljYzJkMGY3ODgyYjU4ZjM5OGUwY2JmNTc2MDYzMzUxNzY1MmQ5CkNoZWNrIGZv
ciBrZXJuZWwgaW4gL2tlcm5lbC9pMzg2LXJhbmRjb25maWctaXY0LTAzMjQvMjU5Y2MyZDBm
Nzg4MmI1OGYzOThlMGNiZjU3NjA2MzM1MTc2NTJkOQp3YWl0aW5nIGZvciBjb21wbGV0aW9u
IG9mIC9rZXJuZWwtdGVzdHMvYnVpbGQtcXVldWUvaTM4Ni1yYW5kY29uZmlnLWl2NC0wMzI0
LTI1OWNjMmQwZjc4ODJiNThmMzk4ZTBjYmY1NzYwNjMzNTE3NjUyZDkKd2FpdGluZyBmb3Ig
Y29tcGxldGlvbiBvZiAva2VybmVsLXRlc3RzL2J1aWxkLXF1ZXVlLy5pMzg2LXJhbmRjb25m
aWctaXY0LTAzMjQtMjU5Y2MyZDBmNzg4MmI1OGYzOThlMGNiZjU3NjA2MzM1MTc2NTJkOQpr
ZXJuZWw6IC9rZXJuZWwvaTM4Ni1yYW5kY29uZmlnLWl2NC0wMzI0LzI1OWNjMmQwZjc4ODJi
NThmMzk4ZTBjYmY1NzYwNjMzNTE3NjUyZDkvdm1saW51ei0zLjE0LjAtcmM3LTAwMzIyLWcy
NTljYzJkCgoyMDE0LTAzLTI0LTE1OjA2OjA5IGRldGVjdGluZyBib290IHN0YXRlIAkxMwkx
NQkyMCBTVUNDRVNTCgpsaW5lYXItYmlzZWN0OiBiYWQgYnJhbmNoIG1heSBiZSBrZWVzL2xz
bS1tbnQtcmVzdHJpY3QKbGluZWFyLWJpc2VjdDogaGFuZGxlIG92ZXIgdG8gZ2l0IGJpc2Vj
dApsaW5lYXItYmlzZWN0OiBnaXQgYmlzZWN0IHN0YXJ0IGQ4ZTQ2M2Q1ODgyMzNiMmJjM2Jh
ZGNjMzhiZWViODJjMTkwY2RlMDcgMjU5Y2MyZDBmNzg4MmI1OGYzOThlMGNiZjU3NjA2MzM1
MTc2NTJkOSAtLQpQcmV2aW91cyBIRUFEIHBvc2l0aW9uIHdhcyAyNTljYzJkLi4uIE1lcmdl
ICdwbS9tYXN0ZXInIGludG8gZGV2ZWwtaG91cmx5LTIwMTQwMzI0MTMKSEVBRCBpcyBub3cg
YXQgNmU0NjY0NS4uLiBMaW51eCAzLjExCkJpc2VjdGluZzogMCByZXZpc2lvbnMgbGVmdCB0
byB0ZXN0IGFmdGVyIHRoaXMgKHJvdWdobHkgMCBzdGVwcykKWzIzMDE1MDNkZmVmMTRmMmZk
MDE3YTg1MGYwODBjNjNhYzVjMDIyYjddIExTTTogTW50UmVzdHJpY3QgYmxvY2tzIG1vdW50
cyBvbiBzeW1saW5rIHRhcmdldHMKbGluZWFyLWJpc2VjdDogZ2l0IGJpc2VjdCBydW4gL2Mv
a2VybmVsLXRlc3RzL2Jpc2VjdC10ZXN0LWJvb3QtZmFpbHVyZS5zaCAvaG9tZS93ZmcvdXNi
L29iai1iaXNlY3QKcnVubmluZyAvYy9rZXJuZWwtdGVzdHMvYmlzZWN0LXRlc3QtYm9vdC1m
YWlsdXJlLnNoIC9ob21lL3dmZy91c2Ivb2JqLWJpc2VjdApscyAtYSAva2VybmVsLXRlc3Rz
L3J1bi1xdWV1ZS9rdm0vaTM4Ni1yYW5kY29uZmlnLWl2NC0wMzI0L2xpbnV4LWRldmVsOmRl
dmVsLWhvdXJseS0yMDE0MDMyNDEzOjIzMDE1MDNkZmVmMTRmMmZkMDE3YTg1MGYwODBjNjNh
YzVjMDIyYjc6YmlzZWN0LXVzYgoKMjAxNC0wMy0yNC0xNTowNzo1OCAyMzAxNTAzZGZlZjE0
ZjJmZDAxN2E4NTBmMDgwYzYzYWM1YzAyMmI3IGNvbXBpbGluZwpRdWV1ZWQgYnVpbGQgdGFz
ayB0byAva2VybmVsLXRlc3RzL2J1aWxkLXF1ZXVlL2kzODYtcmFuZGNvbmZpZy1pdjQtMDMy
NC0yMzAxNTAzZGZlZjE0ZjJmZDAxN2E4NTBmMDgwYzYzYWM1YzAyMmI3CkNoZWNrIGZvciBr
ZXJuZWwgaW4gL2tlcm5lbC9pMzg2LXJhbmRjb25maWctaXY0LTAzMjQvMjMwMTUwM2RmZWYx
NGYyZmQwMTdhODUwZjA4MGM2M2FjNWMwMjJiNwp3YWl0aW5nIGZvciBjb21wbGV0aW9uIG9m
IC9rZXJuZWwtdGVzdHMvYnVpbGQtcXVldWUvaTM4Ni1yYW5kY29uZmlnLWl2NC0wMzI0LTIz
MDE1MDNkZmVmMTRmMmZkMDE3YTg1MGYwODBjNjNhYzVjMDIyYjcKd2FpdGluZyBmb3IgY29t
cGxldGlvbiBvZiAva2VybmVsLXRlc3RzL2J1aWxkLXF1ZXVlLy5pMzg2LXJhbmRjb25maWct
aXY0LTAzMjQtMjMwMTUwM2RmZWYxNGYyZmQwMTdhODUwZjA4MGM2M2FjNWMwMjJiNwprZXJu
ZWw6IC9rZXJuZWwvaTM4Ni1yYW5kY29uZmlnLWl2NC0wMzI0LzIzMDE1MDNkZmVmMTRmMmZk
MDE3YTg1MGYwODBjNjNhYzVjMDIyYjcvdm1saW51ei0zLjE0LjAtcmM3LTAwMDY3LWcyMzAx
NTAzCgoyMDE0LTAzLTI0LTE1OjExOjU4IGRldGVjdGluZyBib290IHN0YXRlIC4uIFRFU1Qg
RkFJTFVSRQpbICAgIDAuMDA4Mjk5XSBBQ1BJOiBBbGwgQUNQSSBUYWJsZXMgc3VjY2Vzc2Z1
bGx5IGFjcXVpcmVkClsgICAgMC4wMDg5NDFdIFNlY3VyaXR5IEZyYW1ld29yayBpbml0aWFs
aXplZApbICAgIDAuMDA5Mzc5XSBBcHBBcm1vcjogQXBwQXJtb3IgaW5pdGlhbGl6ZWQKWyAg
ICAwLjAwOTgxOF0gS2VybmVsIHBhbmljIC0gbm90IHN5bmNpbmc6IENvdWxkIG5vdCByZWdp
c3RlciBNbnRSZXN0cmljdCBzZWN1cml0eSBtb2R1bGUKWyAgICAwLjAxMDYxOF0gQ1BVOiAw
IFBJRDogMCBDb21tOiBzd2FwcGVyIE5vdCB0YWludGVkIDMuMTQuMC1yYzctMDAwNjctZzIz
MDE1MDMgIzgKWyAgICAwLjAxMTM3OF0gSGFyZHdhcmUgbmFtZTogQm9jaHMgQm9jaHMsIEJJ
T1MgQm9jaHMgMDEvMDEvMjAxMQpbICAgIDAuMDExOTY3XSAgYzFkMzIxYjQgYzFkMzIxYjQg
YzFhOGJmODggYzE3NTE3YjAgYzFhOGJmYTggYzE3NDk3YTQgYzE5OWVkZDQgYzFkNGMyODAK
WyAgICAwLjAxMjAwMF0gIGMxY2MyYzU1IGMxZDMyMWI0IDAwMDAwMDAwIGMxZDQxODAwIGMx
YThiZmI0IGMxY2MzZDZkIGMxOWU1YTJjIGMxYThiZmM0ClsgICAgMC4wMTIwMDBdICBjMWNj
MmMxYiBjMTllNTE3MCAwMDAwMDAwMCBjMWE4YmZlYyBjMWM5ZmFjZSAwMDAwMDEzOSBmZmZm
ZmZmZiBmZmZmZmZmZgpbICAgIDAuMDEyMDAwXSBDYWxsIFRyYWNlOgpbICAgIDAuMDEyMDAw
XSAgWzxjMTc1MTdiMD5dIGR1bXBfc3RhY2srMHgxNi8weDE4ClsgICAgMC4wMTIwMDBdICBb
PGMxNzQ5N2E0Pl0gcGFuaWMrMHg4Ny8weDE2ZgpbICAgIDAuMDEyMDAwXSAgWzxjMWNjMmM1
NT5dID8gcmVnaXN0ZXJfc2VjdXJpdHkrMHgxMi8weDRkClsgICAgMC4wMTIwMDBdICBbPGMx
Y2MzZDZkPl0gbW50cmVzdHJpY3RfaW5pdCsweDFlLzB4MmUKWyAgICAwLjAxMjAwMF0gIFs8
YzFjYzJjMWI+XSBzZWN1cml0eV9pbml0KzB4MmUvMHgzZgpbICAgIDAuMDEyMDAwXSAgWzxj
MWM5ZmFjZT5dIHN0YXJ0X2tlcm5lbCsweDM1YS8weDNmMQpbICAgIDAuMDEyMDAwXSAgWzxj
MWM5ZjU2OT5dID8gcmVwYWlyX2Vudl9zdHJpbmcrMHg1MS8weDUxClsgICAgMC4wMTIwMDBd
ICBbPGMxYzlmMzg0Pl0gaTM4Nl9zdGFydF9rZXJuZWwrMHgxMmUvMHgxMzEKCkVsYXBzZWQg
dGltZTogNQpxZW11LXN5c3RlbS14ODZfNjQgLWNwdSBrdm02NCAtZW5hYmxlLWt2bSAta2Vy
bmVsIC9rZXJuZWwvaTM4Ni1yYW5kY29uZmlnLWl2NC0wMzI0LzIzMDE1MDNkZmVmMTRmMmZk
MDE3YTg1MGYwODBjNjNhYzVjMDIyYjcvdm1saW51ei0zLjE0LjAtcmM3LTAwMDY3LWcyMzAx
NTAzIC1hcHBlbmQgJ2h1bmdfdGFza19wYW5pYz0xIGVhcmx5cHJpbnRrPXR0eVMwLDExNTIw
MCBkZWJ1ZyBhcGljPWRlYnVnIHN5c3JxX2Fsd2F5c19lbmFibGVkIHJjdXBkYXRlLnJjdV9j
cHVfc3RhbGxfdGltZW91dD0xMDAgcGFuaWM9MTAgc29mdGxvY2t1cF9wYW5pYz0xIG5taV93
YXRjaGRvZz1wYW5pYyAgcHJvbXB0X3JhbWRpc2s9MCBjb25zb2xlPXR0eVMwLDExNTIwMCBj
b25zb2xlPXR0eTAgdmdhPW5vcm1hbCAgcm9vdD0vZGV2L3JhbTAgcncgbGluaz0va2VybmVs
LXRlc3RzL3J1bi1xdWV1ZS9rdm0vaTM4Ni1yYW5kY29uZmlnLWl2NC0wMzI0L2xpbnV4LWRl
dmVsOmRldmVsLWhvdXJseS0yMDE0MDMyNDEzOjIzMDE1MDNkZmVmMTRmMmZkMDE3YTg1MGYw
ODBjNjNhYzVjMDIyYjc6YmlzZWN0LXVzYi8udm1saW51ei0yMzAxNTAzZGZlZjE0ZjJmZDAx
N2E4NTBmMDgwYzYzYWM1YzAyMmI3LTIwMTQwMzI0MTUxMTU1LTctaXZ5dG93bjIgYnJhbmNo
PWxpbnV4LWRldmVsL2RldmVsLWhvdXJseS0yMDE0MDMyNDEzIEJPT1RfSU1BR0U9L2tlcm5l
bC9pMzg2LXJhbmRjb25maWctaXY0LTAzMjQvMjMwMTUwM2RmZWYxNGYyZmQwMTdhODUwZjA4
MGM2M2FjNWMwMjJiNy92bWxpbnV6LTMuMTQuMC1yYzctMDAwNjctZzIzMDE1MDMgZHJiZC5t
aW5vcl9jb3VudD04JyAgLWluaXRyZCAva2VybmVsLXRlc3RzL2luaXRyZC9xdWFudGFsLWNv
cmUtaTM4Ni5jZ3ogLW0gMzIwIC1zbXAgMiAtbmV0IG5pYyx2bGFuPTEsbW9kZWw9ZTEwMDAg
LW5ldCB1c2VyLHZsYW49MSxob3N0ZndkPXRjcDo6MTY3NTctOjIyIC1ib290IG9yZGVyPW5j
IC1uby1yZWJvb3QgLXdhdGNoZG9nIGk2MzAwZXNiIC1ydGMgYmFzZT1sb2NhbHRpbWUgLXBp
ZGZpbGUgL2Rldi9zaG0va2Jvb3QvcGlkLXF1YW50YWwtaXZ5dG93bjItMzUgLXNlcmlhbCBm
aWxlOi9kZXYvc2htL2tib290L3NlcmlhbC1xdWFudGFsLWl2eXRvd24yLTM1IC1kYWVtb25p
emUgLWRpc3BsYXkgbm9uZSAtbW9uaXRvciBudWxsIAova2VybmVsL2kzODYtcmFuZGNvbmZp
Zy1pdjQtMDMyNC8yMzAxNTAzZGZlZjE0ZjJmZDAxN2E4NTBmMDgwYzYzYWM1YzAyMmI3L2Rt
ZXNnLXF1YW50YWwtcm9hbS0yMToyMDE0MDMyNDE1MTI0NzppMzg2LXJhbmRjb25maWctaXY0
LTAzMjQ6My4xNC4wLXJjNy0wMDA2Ny1nMjMwMTUwMzo4Ci9rZXJuZWwvaTM4Ni1yYW5kY29u
ZmlnLWl2NC0wMzI0LzIzMDE1MDNkZmVmMTRmMmZkMDE3YTg1MGYwODBjNjNhYzVjMDIyYjcv
ZG1lc2cteW9jdG8tYXRoZW5zLTQxOjIwMTQwMzI0MTUxMjQ0OmkzODYtcmFuZGNvbmZpZy1p
djQtMDMyNDozLjE0LjAtcmM3LTAwMDY3LWcyMzAxNTAzOjgKL2tlcm5lbC9pMzg2LXJhbmRj
b25maWctaXY0LTAzMjQvMjMwMTUwM2RmZWYxNGYyZmQwMTdhODUwZjA4MGM2M2FjNWMwMjJi
Ny9kbWVzZy15b2N0by1jYWlyby0yNDoyMDE0MDMyNDE1MTI0NjppMzg2LXJhbmRjb25maWct
aXY0LTAzMjQ6My4xNC4wLXJjNy0wMDA2Ny1nMjMwMTUwMzo4Ci9rZXJuZWwvaTM4Ni1yYW5k
Y29uZmlnLWl2NC0wMzI0LzIzMDE1MDNkZmVmMTRmMmZkMDE3YTg1MGYwODBjNjNhYzVjMDIy
YjcvZG1lc2cteW9jdG8tamFrZXRvd24tMTA6MjAxNDAzMjQxNTEyNDQ6aTM4Ni1yYW5kY29u
ZmlnLWl2NC0wMzI0OjoKL2tlcm5lbC9pMzg2LXJhbmRjb25maWctaXY0LTAzMjQvMjMwMTUw
M2RmZWYxNGYyZmQwMTdhODUwZjA4MGM2M2FjNWMwMjJiNy9kbWVzZy15b2N0by1sa3Atc2Iw
NC0yMjoyMDE0MDMyNDE1MTI0NTppMzg2LXJhbmRjb25maWctaXY0LTAzMjQ6My4xNC4wLXJj
Ny0wMDA2Ny1nMjMwMTUwMzo4Ci9rZXJuZWwvaTM4Ni1yYW5kY29uZmlnLWl2NC0wMzI0LzIz
MDE1MDNkZmVmMTRmMmZkMDE3YTg1MGYwODBjNjNhYzVjMDIyYjcvZG1lc2cteW9jdG8tbGtw
LXNiMDQtMjU6MjAxNDAzMjQxNTEyNDg6aTM4Ni1yYW5kY29uZmlnLWl2NC0wMzI0OjMuMTQu
MC1yYzctMDAwNjctZzIzMDE1MDM6OAova2VybmVsL2kzODYtcmFuZGNvbmZpZy1pdjQtMDMy
NC8yMzAxNTAzZGZlZjE0ZjJmZDAxN2E4NTBmMDgwYzYzYWM1YzAyMmI3L2RtZXNnLXlvY3Rv
LXNuYi0xOjIwMTQwMzI0MTUxMjQ0OmkzODYtcmFuZGNvbmZpZy1pdjQtMDMyNDo6Ci9rZXJu
ZWwvaTM4Ni1yYW5kY29uZmlnLWl2NC0wMzI0LzIzMDE1MDNkZmVmMTRmMmZkMDE3YTg1MGYw
ODBjNjNhYzVjMDIyYjcvZG1lc2ctcXVhbnRhbC1pdnl0b3duMi0zNToyMDE0MDMyNDE1MTI0
ODppMzg2LXJhbmRjb25maWctaXY0LTAzMjQ6My4xNC4wLXJjNy0wMDA2Ny1nMjMwMTUwMzo4
Ci9rZXJuZWwvaTM4Ni1yYW5kY29uZmlnLWl2NC0wMzI0LzIzMDE1MDNkZmVmMTRmMmZkMDE3
YTg1MGYwODBjNjNhYzVjMDIyYjcvZG1lc2ctcXVhbnRhbC1zbmItMzk6MjAxNDAzMjQxNTEy
NDg6aTM4Ni1yYW5kY29uZmlnLWl2NC0wMzI0OjoKL2tlcm5lbC9pMzg2LXJhbmRjb25maWct
aXY0LTAzMjQvMjMwMTUwM2RmZWYxNGYyZmQwMTdhODUwZjA4MGM2M2FjNWMwMjJiNy9kbWVz
Zy1xdWFudGFsLXhpYW4tMjI6MjAxNDAzMjQxNTEyNDk6aTM4Ni1yYW5kY29uZmlnLWl2NC0w
MzI0OjMuMTQuMC1yYzctMDAwNjctZzIzMDE1MDM6OAova2VybmVsL2kzODYtcmFuZGNvbmZp
Zy1pdjQtMDMyNC8yMzAxNTAzZGZlZjE0ZjJmZDAxN2E4NTBmMDgwYzYzYWM1YzAyMmI3L2Rt
ZXNnLXlvY3RvLWF0aGVucy0xOjIwMTQwMzI0MTUxMjQ5OmkzODYtcmFuZGNvbmZpZy1pdjQt
MDMyNDozLjE0LjAtcmM3LTAwMDY3LWcyMzAxNTAzOjgKL2tlcm5lbC9pMzg2LXJhbmRjb25m
aWctaXY0LTAzMjQvMjMwMTUwM2RmZWYxNGYyZmQwMTdhODUwZjA4MGM2M2FjNWMwMjJiNy9k
bWVzZy15b2N0by1sa3Atc2IwNC04OjIwMTQwMzI0MTUxMjQ4OmkzODYtcmFuZGNvbmZpZy1p
djQtMDMyNDozLjE0LjAtcmM3LTAwMDY3LWcyMzAxNTAzOjgKMDoxMjoxMiBhbGxfZ29vZDpi
YWQ6YWxsX2JhZCBib290cwobWzE7MzVtMjAxNC0wMy0yNCAxNToxMjo1OSBSRVBFQVQgQ09V
TlQ6IDIwICAjIC9jYy93ZmcvdXNiLWJpc2VjdC8ucmVwZWF0G1swbQoKMjMwMTUwM2RmZWYx
NGYyZmQwMTdhODUwZjA4MGM2M2FjNWMwMjJiNyBpcyB0aGUgZmlyc3QgYmFkIGNvbW1pdApj
b21taXQgMjMwMTUwM2RmZWYxNGYyZmQwMTdhODUwZjA4MGM2M2FjNWMwMjJiNwpBdXRob3I6
IEtlZXMgQ29vayA8a2Vlc2Nvb2tAY2hyb21pdW0ub3JnPgpEYXRlOiAgIFNhdCBTZXAgMjEg
MTU6NTI6NTEgMjAxMyAtMDcwMAoKICAgIExTTTogTW50UmVzdHJpY3QgYmxvY2tzIG1vdW50
cyBvbiBzeW1saW5rIHRhcmdldHMKICAgIAogICAgT24gc3lzdGVtcyB3aGVyZSBjZXJ0YWlu
IGZpbGVzeXN0ZW0gY29udGVudHMgY2Fubm90IGJlIGVudGlyZWx5IHRydXN0ZWQsCiAgICBp
dCBpcyBiZW5lZmljaWFsIHRvIGJsb2NrIG1vdW50cyBvbiBzeW1saW5rcy4gVGhpcyBtYWtl
cyBzdXJlIHRoYXQKICAgIG1hbGljaW91cyBmaWxlc3lzdGVtIGNvbnRlbnRzIGNhbm5vdCB0
cmlnZ2VyIHRoZSBvdmVyLW1vdW50aW5nIG9mIHRydXN0ZWQKICAgIGZpbGVzeXN0ZW1zLiAo
Rm9yIGV4YW1wbGUsIGEgYmluZC1tb3VudGVkIHN1YmRpcmVjdG9yeSBvZiAvdmFyIGNhbm5v
dCBiZQogICAgcmVkaXJlY3RlZCB0byBtb3VudCBvbiAvZXRjIHZpYSBhIHN5bWxpbms6IGEg
ZGFlbW9uIGNhbm5vdCBlbGV2YXRlIHByaXZzCiAgICB0byB1aWQtMC4pCiAgICAKICAgIFNp
Z25lZC1vZmYtYnk6IEtlZXMgQ29vayA8a2Vlc2Nvb2tAY2hyb21pdW0ub3JnPgoKOjA0MDAw
MCAwNDAwMDAgODRkZDJjY2NhMzdmZDkxYjViOWFhMWFjZDlhMTA3ZDA4NGUxMTM5MCBiN2Zi
N2M5MDEwNjZmMzE1YTE1NjJkYmI2MTk1MmVmMzJhYTRhN2RkIE0Jc2VjdXJpdHkKYmlzZWN0
IHJ1biBzdWNjZXNzCmxzIC1hIC9rZXJuZWwtdGVzdHMvcnVuLXF1ZXVlL2t2bS9pMzg2LXJh
bmRjb25maWctaXY0LTAzMjQvbGludXgtZGV2ZWw6ZGV2ZWwtaG91cmx5LTIwMTQwMzI0MTM6
Nzc0ODY4YzcwOTRkMzViNDUxOGJlM2QwZTY1NGRlMDAwYTVkMTFmYzpiaXNlY3QtdXNiCgoy
MDE0LTAzLTI0LTE1OjEzOjAyIDc3NDg2OGM3MDk0ZDM1YjQ1MThiZTNkMGU2NTRkZTAwMGE1
ZDExZmMgY29tcGlsaW5nClF1ZXVlZCBidWlsZCB0YXNrIHRvIC9rZXJuZWwtdGVzdHMvYnVp
bGQtcXVldWUvaTM4Ni1yYW5kY29uZmlnLWl2NC0wMzI0LTc3NDg2OGM3MDk0ZDM1YjQ1MThi
ZTNkMGU2NTRkZTAwMGE1ZDExZmMKQ2hlY2sgZm9yIGtlcm5lbCBpbiAva2VybmVsL2kzODYt
cmFuZGNvbmZpZy1pdjQtMDMyNC83NzQ4NjhjNzA5NGQzNWI0NTE4YmUzZDBlNjU0ZGUwMDBh
NWQxMWZjCndhaXRpbmcgZm9yIGNvbXBsZXRpb24gb2YgL2tlcm5lbC10ZXN0cy9idWlsZC1x
dWV1ZS9pMzg2LXJhbmRjb25maWctaXY0LTAzMjQtNzc0ODY4YzcwOTRkMzViNDUxOGJlM2Qw
ZTY1NGRlMDAwYTVkMTFmYwprZXJuZWw6IC9rZXJuZWwvaTM4Ni1yYW5kY29uZmlnLWl2NC0w
MzI0Lzc3NDg2OGM3MDk0ZDM1YjQ1MThiZTNkMGU2NTRkZTAwMGE1ZDExZmMvdm1saW51ei0z
LjE0LjAtcmM3LTAwMDY2LWc3NzQ4NjhjCgoyMDE0LTAzLTI0LTE1OjE0OjAyIGRldGVjdGlu
ZyBib290IHN0YXRlIAkxCTMxCTM1CTYwIFNVQ0NFU1MKCmxzIC1hIC9rZXJuZWwtdGVzdHMv
cnVuLXF1ZXVlL2t2bS9pMzg2LXJhbmRjb25maWctaXY0LTAzMjQvbGludXgtZGV2ZWw6ZGV2
ZWwtaG91cmx5LTIwMTQwMzI0MTM6OWQ3NTAwNjQwM2I1NmE5NzAyZDMyYzY4NmQ5ODMxNzcx
NTRhMTVjZjpiaXNlY3QtdXNiCiBURVNUIEZBSUxVUkUKWyAgICAwLjAxMDIyOF0gQUNQSTog
QWxsIEFDUEkgVGFibGVzIHN1Y2Nlc3NmdWxseSBhY3F1aXJlZApbICAgIDAuMDExMTQ2XSBT
ZWN1cml0eSBGcmFtZXdvcmsgaW5pdGlhbGl6ZWQKWyAgICAwLjAxMTc4Nl0gQXBwQXJtb3I6
IEFwcEFybW9yIGluaXRpYWxpemVkClsgICAgMC4wMTIwMjddIEtlcm5lbCBwYW5pYyAtIG5v
dCBzeW5jaW5nOiBDb3VsZCBub3QgcmVnaXN0ZXIgTW50UmVzdHJpY3Qgc2VjdXJpdHkgbW9k
dWxlClsgICAgMC4wMTMyNTddIENQVTogMCBQSUQ6IDAgQ29tbTogc3dhcHBlciBOb3QgdGFp
bnRlZCAzLjE0LjAtcmM3LTAwOTY1LWc5ZDc1MDA2ICMxClsgICAgMC4wMTQ0MTVdIEhhcmR3
YXJlIG5hbWU6IEJvY2hzIEJvY2hzLCBCSU9TIEJvY2hzIDAxLzAxLzIwMTEKWyAgICAwLjAx
NTMxMl0gIGMxZDMyMjVjIGMxZDMyMjVjIGMxYThiZjg4IGMxNzUxZTYwIGMxYThiZmE4IGMx
NzQ5ZTU0IGMxOWEwMGZjIGMxZDRjMjgwClsgICAgMC4wMTYwMDBdICBjMWNjMmNmMyBjMWQz
MjI1YyAwMDAwMDAwMCBjMWQ0MTgwMCBjMWE4YmZiNCBjMWNjM2UxZSBjMTllNmQ2YyBjMWE4
YmZjNApbICAgIDAuMDE2MDAwXSAgYzFjYzJjYjkgYzE5ZTY0YjAgMDAwMDAwMDAgYzFhOGJm
ZWMgYzFjOWZhY2UgMDAwMDAxMzkgZmZmZmZmZmYgZmZmZmZmZmYKWyAgICAwLjAxNjAwMF0g
Q2FsbCBUcmFjZToKWyAgICAwLjAxNjAwMF0gIFs8YzE3NTFlNjA+XSBkdW1wX3N0YWNrKzB4
MTYvMHgxOApbICAgIDAuMDE2MDAwXSAgWzxjMTc0OWU1ND5dIHBhbmljKzB4ODcvMHgxNmYK
WyAgICAwLjAxNjAwMF0gIFs8YzFjYzJjZjM+XSA/IHJlZ2lzdGVyX3NlY3VyaXR5KzB4MTIv
MHg0ZApbICAgIDAuMDE2MDAwXSAgWzxjMWNjM2UxZT5dIG1udHJlc3RyaWN0X2luaXQrMHgx
ZS8weDJlClsgICAgMC4wMTYwMDBdICBbPGMxY2MyY2I5Pl0gc2VjdXJpdHlfaW5pdCsweDJl
LzB4M2YKWyAgICAwLjAxNjAwMF0gIFs8YzFjOWZhY2U+XSBzdGFydF9rZXJuZWwrMHgzNWEv
MHgzZjEKWyAgICAwLjAxNjAwMF0gIFs8YzFjOWY1Njk+XSA/IHJlcGFpcl9lbnZfc3RyaW5n
KzB4NTEvMHg1MQpbICAgIDAuMDE2MDAwXSAgWzxjMWM5ZjM4ND5dIGkzODZfc3RhcnRfa2Vy
bmVsKzB4MTJlLzB4MTMxCgpFbGFwc2VkIHRpbWU6IDUKcWVtdS1zeXN0ZW0teDg2XzY0IC1j
cHUga3ZtNjQgLWVuYWJsZS1rdm0gLWtlcm5lbCAva2VybmVsL2kzODYtcmFuZGNvbmZpZy1p
djQtMDMyNC85ZDc1MDA2NDAzYjU2YTk3MDJkMzJjNjg2ZDk4MzE3NzE1NGExNWNmL3ZtbGlu
dXotMy4xNC4wLXJjNy0wMDk2NS1nOWQ3NTAwNiAtYXBwZW5kICdodW5nX3Rhc2tfcGFuaWM9
MSBlYXJseXByaW50az10dHlTMCwxMTUyMDAgZGVidWcgYXBpYz1kZWJ1ZyBzeXNycV9hbHdh
eXNfZW5hYmxlZCByY3VwZGF0ZS5yY3VfY3B1X3N0YWxsX3RpbWVvdXQ9MTAwIHBhbmljPTEw
IHNvZnRsb2NrdXBfcGFuaWM9MSBubWlfd2F0Y2hkb2c9cGFuaWMgIHByb21wdF9yYW1kaXNr
PTAgY29uc29sZT10dHlTMCwxMTUyMDAgY29uc29sZT10dHkwIHZnYT1ub3JtYWwgIHJvb3Q9
L2Rldi9yYW0wIHJ3IGxpbms9L2tlcm5lbC10ZXN0cy9ydW4tcXVldWUva3ZtL2kzODYtcmFu
ZGNvbmZpZy1pdjQtMDMyNC9saW51eC1kZXZlbDpkZXZlbC1ob3VybHktMjAxNDAzMjQxMzo5
ZDc1MDA2NDAzYjU2YTk3MDJkMzJjNjg2ZDk4MzE3NzE1NGExNWNmOmJpc2VjdC11c2IvLnZt
bGludXotOWQ3NTAwNjQwM2I1NmE5NzAyZDMyYzY4NmQ5ODMxNzcxNTRhMTVjZi0yMDE0MDMy
NDE0MTYyNy0xMC1jYWlybyBicmFuY2g9bGludXgtZGV2ZWwvZGV2ZWwtaG91cmx5LTIwMTQw
MzI0MTMgQk9PVF9JTUFHRT0va2VybmVsL2kzODYtcmFuZGNvbmZpZy1pdjQtMDMyNC85ZDc1
MDA2NDAzYjU2YTk3MDJkMzJjNjg2ZDk4MzE3NzE1NGExNWNmL3ZtbGludXotMy4xNC4wLXJj
Ny0wMDk2NS1nOWQ3NTAwNiBkcmJkLm1pbm9yX2NvdW50PTgnICAtaW5pdHJkIC9rZXJuZWwt
dGVzdHMvaW5pdHJkL3F1YW50YWwtY29yZS1pMzg2LmNneiAtbSAyNTYgLXNtcCAyIC1uZXQg
bmljLHZsYW49MSxtb2RlbD1lMTAwMCAtbmV0IHVzZXIsdmxhbj0xLGhvc3Rmd2Q9dGNwOjox
MDg4Ny06MjIgLWJvb3Qgb3JkZXI9bmMgLW5vLXJlYm9vdCAtd2F0Y2hkb2cgaTYzMDBlc2Ig
LXJ0YyBiYXNlPWxvY2FsdGltZSAtZHJpdmUgZmlsZT0vZnMvTEFCRUw9S1ZNL2Rpc2swLXF1
YW50YWwtY2Fpcm8tMTEsbWVkaWE9ZGlzayxpZj12aXJ0aW8gLWRyaXZlIGZpbGU9L2ZzL0xB
QkVMPUtWTS9kaXNrMS1xdWFudGFsLWNhaXJvLTExLG1lZGlhPWRpc2ssaWY9dmlydGlvIC1k
cml2ZSBmaWxlPS9mcy9MQUJFTD1LVk0vZGlzazItcXVhbnRhbC1jYWlyby0xMSxtZWRpYT1k
aXNrLGlmPXZpcnRpbyAtZHJpdmUgZmlsZT0vZnMvTEFCRUw9S1ZNL2Rpc2szLXF1YW50YWwt
Y2Fpcm8tMTEsbWVkaWE9ZGlzayxpZj12aXJ0aW8gLWRyaXZlIGZpbGU9L2ZzL0xBQkVMPUtW
TS9kaXNrNC1xdWFudGFsLWNhaXJvLTExLG1lZGlhPWRpc2ssaWY9dmlydGlvIC1kcml2ZSBm
aWxlPS9mcy9MQUJFTD1LVk0vZGlzazUtcXVhbnRhbC1jYWlyby0xMSxtZWRpYT1kaXNrLGlm
PXZpcnRpbyAtcGlkZmlsZSAvZGV2L3NobS9rYm9vdC9waWQtcXVhbnRhbC1jYWlyby0xMSAt
c2VyaWFsIGZpbGU6L2Rldi9zaG0va2Jvb3Qvc2VyaWFsLXF1YW50YWwtY2Fpcm8tMTEgLWRh
ZW1vbml6ZSAtZGlzcGxheSBub25lIC1tb25pdG9yIG51bGwgCi9rZXJuZWwvaTM4Ni1yYW5k
Y29uZmlnLWl2NC0wMzI0LzlkNzUwMDY0MDNiNTZhOTcwMmQzMmM2ODZkOTgzMTc3MTU0YTE1
Y2YvZG1lc2ctcXVhbnRhbC1sa3Atc3QwMS02OjIwMTQwMzI0MTQwODExOmkzODYtcmFuZGNv
bmZpZy1pdjQtMDMyNDozLjE0LjAtcmM3LTAwOTY1LWc5ZDc1MDA2OjEKL2tlcm5lbC9pMzg2
LXJhbmRjb25maWctaXY0LTAzMjQvOWQ3NTAwNjQwM2I1NmE5NzAyZDMyYzY4NmQ5ODMxNzcx
NTRhMTVjZi9kbWVzZy1xdWFudGFsLWNhaXJvLTI3OjIwMTQwMzI0MTQxNjM3OmkzODYtcmFu
ZGNvbmZpZy1pdjQtMDMyNDozLjE0LjAtcmM3LTAwOTY1LWc5ZDc1MDA2OjEKL2tlcm5lbC9p
Mzg2LXJhbmRjb25maWctaXY0LTAzMjQvOWQ3NTAwNjQwM2I1NmE5NzAyZDMyYzY4NmQ5ODMx
NzcxNTRhMTVjZi9kbWVzZy1xdWFudGFsLWxrcC1zdDAxLTExOjIwMTQwMzI0MTQwODA3Omkz
ODYtcmFuZGNvbmZpZy1pdjQtMDMyNDozLjE0LjAtcmM3LTAwOTY1LWc5ZDc1MDA2OjEKL2tl
cm5lbC9pMzg2LXJhbmRjb25maWctaXY0LTAzMjQvOWQ3NTAwNjQwM2I1NmE5NzAyZDMyYzY4
NmQ5ODMxNzcxNTRhMTVjZi9kbWVzZy1xdWFudGFsLWl2eXRvd24yLTY2OjIwMTQwMzI0MTQx
NjQwOmkzODYtcmFuZGNvbmZpZy1pdjQtMDMyNDozLjE0LjAtcmM3LTAwOTY1LWc5ZDc1MDA2
OjEKL2tlcm5lbC9pMzg2LXJhbmRjb25maWctaXY0LTAzMjQvOWQ3NTAwNjQwM2I1NmE5NzAy
ZDMyYzY4NmQ5ODMxNzcxNTRhMTVjZi9kbWVzZy15b2N0by1sa3Atc3QwMS03OjIwMTQwMzI0
MTQwODE5OmkzODYtcmFuZGNvbmZpZy1pdjQtMDMyNDozLjE0LjAtcmM3LTAwOTY1LWc5ZDc1
MDA2OjEKL2tlcm5lbC9pMzg2LXJhbmRjb25maWctaXY0LTAzMjQvOWQ3NTAwNjQwM2I1NmE5
NzAyZDMyYzY4NmQ5ODMxNzcxNTRhMTVjZi9kbWVzZy15b2N0by1sa3Atc3QwMS0xMjoyMDE0
MDMyNDE0MTYzOTppMzg2LXJhbmRjb25maWctaXY0LTAzMjQ6My4xNC4wLXJjNy0wMDk2NS1n
OWQ3NTAwNjoxCi9rZXJuZWwvaTM4Ni1yYW5kY29uZmlnLWl2NC0wMzI0LzlkNzUwMDY0MDNi
NTZhOTcwMmQzMmM2ODZkOTgzMTc3MTU0YTE1Y2YvZG1lc2cteW9jdG8tbGtwLXN0MDEtNToy
MDE0MDMyNDE0MDgxNDppMzg2LXJhbmRjb25maWctaXY0LTAzMjQ6My4xNC4wLXJjNy0wMDk2
NS1nOWQ3NTAwNjoxCi9rZXJuZWwvaTM4Ni1yYW5kY29uZmlnLWl2NC0wMzI0LzlkNzUwMDY0
MDNiNTZhOTcwMmQzMmM2ODZkOTgzMTc3MTU0YTE1Y2YvZG1lc2cteW9jdG8tbGtwLXN0MDEt
MTI6MjAxNDAzMjQxNDA4MTY6aTM4Ni1yYW5kY29uZmlnLWl2NC0wMzI0OjMuMTQuMC1yYzct
MDA5NjUtZzlkNzUwMDY6MQova2VybmVsL2kzODYtcmFuZGNvbmZpZy1pdjQtMDMyNC85ZDc1
MDA2NDAzYjU2YTk3MDJkMzJjNjg2ZDk4MzE3NzE1NGExNWNmL2RtZXNnLXlvY3RvLXhpYW4t
Mzg6MjAxNDAzMjQxNDE2NDM6aTM4Ni1yYW5kY29uZmlnLWl2NC0wMzI0OjMuMTQuMC1yYzct
MDA5NjUtZzlkNzUwMDY6MQova2VybmVsL2kzODYtcmFuZGNvbmZpZy1pdjQtMDMyNC85ZDc1
MDA2NDAzYjU2YTk3MDJkMzJjNjg2ZDk4MzE3NzE1NGExNWNmL2RtZXNnLXlvY3RvLWxrcC1z
dDAxLTU6MjAxNDAzMjQxNDA3NTc6aTM4Ni1yYW5kY29uZmlnLWl2NC0wMzI0OjMuMTQuMC1y
YzctMDA5NjUtZzlkNzUwMDY6MQova2VybmVsL2kzODYtcmFuZGNvbmZpZy1pdjQtMDMyNC85
ZDc1MDA2NDAzYjU2YTk3MDJkMzJjNjg2ZDk4MzE3NzE1NGExNWNmL2RtZXNnLXlvY3RvLXNu
Yi0zOjIwMTQwMzI0MTQxNjQzOmkzODYtcmFuZGNvbmZpZy1pdjQtMDMyNDo6Ci9rZXJuZWwv
aTM4Ni1yYW5kY29uZmlnLWl2NC0wMzI0LzlkNzUwMDY0MDNiNTZhOTcwMmQzMmM2ODZkOTgz
MTc3MTU0YTE1Y2YvZG1lc2ctcXVhbnRhbC1zdG9ha2xleS0zOjIwMTQwMzI0MTQwODE2Omkz
ODYtcmFuZGNvbmZpZy1pdjQtMDMyNDozLjE0LjAtcmM3LTAwOTY1LWc5ZDc1MDA2OjEKL2tl
cm5lbC9pMzg2LXJhbmRjb25maWctaXY0LTAzMjQvOWQ3NTAwNjQwM2I1NmE5NzAyZDMyYzY4
NmQ5ODMxNzcxNTRhMTVjZi9kbWVzZy1xdWFudGFsLWl2eXRvd24yLTEwOjIwMTQwMzI0MTQx
NjQwOmkzODYtcmFuZGNvbmZpZy1pdjQtMDMyNDozLjE0LjAtcmM3LTAwOTY1LWc5ZDc1MDA2
OjEKL2tlcm5lbC9pMzg2LXJhbmRjb25maWctaXY0LTAzMjQvOWQ3NTAwNjQwM2I1NmE5NzAy
ZDMyYzY4NmQ5ODMxNzcxNTRhMTVjZi9kbWVzZy1xdWFudGFsLWNhaXJvLTExOjIwMTQwMzI0
MTQxNjM3OmkzODYtcmFuZGNvbmZpZy1pdjQtMDMyNDozLjE0LjAtcmM3LTAwOTY1LWc5ZDc1
MDA2OjEKL2tlcm5lbC9pMzg2LXJhbmRjb25maWctaXY0LTAzMjQvOWQ3NTAwNjQwM2I1NmE5
NzAyZDMyYzY4NmQ5ODMxNzcxNTRhMTVjZi9kbWVzZy15b2N0by1pbm4tNDU6MjAxNDAzMjQx
NDE2NDM6aTM4Ni1yYW5kY29uZmlnLWl2NC0wMzI0OjoKL2tlcm5lbC9pMzg2LXJhbmRjb25m
aWctaXY0LTAzMjQvOWQ3NTAwNjQwM2I1NmE5NzAyZDMyYzY4NmQ5ODMxNzcxNTRhMTVjZi9k
bWVzZy1xdWFudGFsLXN0b2FrbGV5LTc6MjAxNDAzMjQxNDA4MTU6aTM4Ni1yYW5kY29uZmln
LWl2NC0wMzI0OjMuMTQuMC1yYzctMDA5NjUtZzlkNzUwMDY6MQova2VybmVsL2kzODYtcmFu
ZGNvbmZpZy1pdjQtMDMyNC85ZDc1MDA2NDAzYjU2YTk3MDJkMzJjNjg2ZDk4MzE3NzE1NGEx
NWNmL2RtZXNnLXlvY3RvLWxrcC1zdDAxLTc6MjAxNDAzMjQxNDA4MDU6aTM4Ni1yYW5kY29u
ZmlnLWl2NC0wMzI0OjMuMTQuMC1yYzctMDA5NjUtZzlkNzUwMDY6MQova2VybmVsL2kzODYt
cmFuZGNvbmZpZy1pdjQtMDMyNC85ZDc1MDA2NDAzYjU2YTk3MDJkMzJjNjg2ZDk4MzE3NzE1
NGExNWNmL2RtZXNnLXF1YW50YWwteGJtLTM6MjAxNDAzMjQxNDE2NDQ6aTM4Ni1yYW5kY29u
ZmlnLWl2NC0wMzI0OjMuMTQuMC1yYzctMDA5NjUtZzlkNzUwMDY6MQova2VybmVsL2kzODYt
cmFuZGNvbmZpZy1pdjQtMDMyNC85ZDc1MDA2NDAzYjU2YTk3MDJkMzJjNjg2ZDk4MzE3NzE1
NGExNWNmL2RtZXNnLXlvY3RvLWF0aGVucy00MjoyMDE0MDMyNDE0MTYzOTppMzg2LXJhbmRj
b25maWctaXY0LTAzMjQ6My4xNC4wLXJjNy0wMDk2NS1nOWQ3NTAwNjoxCjA6MTk6MTkgYWxs
X2dvb2Q6YmFkOmFsbF9iYWQgYm9vdHMKCltkZXRhY2hlZCBIRUFEIGRjYmY2MzldIFJldmVy
dCAiTFNNOiBNbnRSZXN0cmljdCBibG9ja3MgbW91bnRzIG9uIHN5bWxpbmsgdGFyZ2V0cyIK
IDUgZmlsZXMgY2hhbmdlZCwgODUgZGVsZXRpb25zKC0pCiBkZWxldGUgbW9kZSAxMDA2NDQg
c2VjdXJpdHkvbW50cmVzdHJpY3QvS2NvbmZpZwogZGVsZXRlIG1vZGUgMTAwNjQ0IHNlY3Vy
aXR5L21udHJlc3RyaWN0L01ha2VmaWxlCiBkZWxldGUgbW9kZSAxMDA2NDQgc2VjdXJpdHkv
bW50cmVzdHJpY3QvbW50cmVzdHJpY3QuYwpscyAtYSAva2VybmVsLXRlc3RzL3J1bi1xdWV1
ZS9rdm0vaTM4Ni1yYW5kY29uZmlnLWl2NC0wMzI0L2xpbnV4LWRldmVsOmRldmVsLWhvdXJs
eS0yMDE0MDMyNDEzOmRjYmY2Mzk3ZTExN2ZhNGY4MjA5YmM4MTYxYzgyNTMxOTlmMGFmYTc6
YmlzZWN0LXVzYgoKMjAxNC0wMy0yNC0xNToxNjowNiBkY2JmNjM5N2UxMTdmYTRmODIwOWJj
ODE2MWM4MjUzMTk5ZjBhZmE3IGNvbXBpbGluZwpRdWV1ZWQgYnVpbGQgdGFzayB0byAva2Vy
bmVsLXRlc3RzL2J1aWxkLXF1ZXVlL2kzODYtcmFuZGNvbmZpZy1pdjQtMDMyNC1kY2JmNjM5
N2UxMTdmYTRmODIwOWJjODE2MWM4MjUzMTk5ZjBhZmE3CkNoZWNrIGZvciBrZXJuZWwgaW4g
L2tlcm5lbC9pMzg2LXJhbmRjb25maWctaXY0LTAzMjQvZGNiZjYzOTdlMTE3ZmE0ZjgyMDli
YzgxNjFjODI1MzE5OWYwYWZhNwp3YWl0aW5nIGZvciBjb21wbGV0aW9uIG9mIC9rZXJuZWwt
dGVzdHMvYnVpbGQtcXVldWUvaTM4Ni1yYW5kY29uZmlnLWl2NC0wMzI0LWRjYmY2Mzk3ZTEx
N2ZhNGY4MjA5YmM4MTYxYzgyNTMxOTlmMGFmYTcKc3RhdHVzOiBGQUlMOiBubyBjb21taXQg
ZGNiZjYzOTdlMTE3ZmE0ZjgyMDliYzgxNjFjODI1MzE5OWYwYWZhNyBmb3IgYnVpbGQgdGFz
ayBpMzg2LXJhbmRjb25maWctaXY0LTAzMjQtZGNiZjYzOTdlMTE3ZmE0ZjgyMDliYzgxNjFj
ODI1MzE5OWYwYWZhNwoyMDE0LTAzLTI0LTE1OjE3OjA2IGRjYmY2Mzk3ZTExN2ZhNGY4MjA5
YmM4MTYxYzgyNTMxOTlmMGFmYTcgU0tJUCBCUk9LRU4gQlVJTEQKTm8ga2VybmVsIGluIC9r
ZXJuZWwvaTM4Ni1yYW5kY29uZmlnLWl2NC0wMzI0L2RjYmY2Mzk3ZTExN2ZhNGY4MjA5YmM4
MTYxYzgyNTMxOTlmMGFmYTcKCj09PT09PT09PSB1cHN0cmVhbSA9PT09PT09PT0KV2Fybmlu
ZzogeW91IGFyZSBsZWF2aW5nIDEgY29tbWl0IGJlaGluZCwgbm90IGNvbm5lY3RlZCB0bwph
bnkgb2YgeW91ciBicmFuY2hlczoKCiAgZGNiZjYzOSBSZXZlcnQgIkxTTTogTW50UmVzdHJp
Y3QgYmxvY2tzIG1vdW50cyBvbiBzeW1saW5rIHRhcmdldHMiCgpJZiB5b3Ugd2FudCB0byBr
ZWVwIHRoZW0gYnkgY3JlYXRpbmcgYSBuZXcgYnJhbmNoLCB0aGlzIG1heSBiZSBhIGdvb2Qg
dGltZQp0byBkbyBzbyB3aXRoOgoKIGdpdCBicmFuY2ggbmV3X2JyYW5jaF9uYW1lIGRjYmY2
MzkKCkhFQUQgaXMgbm93IGF0IDc3NDg2OGMuLi4gTWVyZ2UgYnJhbmNoICdwZXJmLXVyZ2Vu
dC1mb3ItbGludXMnIG9mIGdpdDovL2dpdC5rZXJuZWwub3JnL3B1Yi9zY20vbGludXgva2Vy
bmVsL2dpdC90aXAvdGlwCmxzIC1hIC9rZXJuZWwtdGVzdHMvcnVuLXF1ZXVlL2t2bS9pMzg2
LXJhbmRjb25maWctaXY0LTAzMjQvbGludXgtZGV2ZWw6ZGV2ZWwtaG91cmx5LTIwMTQwMzI0
MTM6Nzc0ODY4YzcwOTRkMzViNDUxOGJlM2QwZTY1NGRlMDAwYTVkMTFmYzpiaXNlY3QtdXNi
CiBTVUNDRVNTCgoKPT09PT09PT09IGxpbnV4LW5leHQgPT09PT09PT09ClByZXZpb3VzIEhF
QUQgcG9zaXRpb24gd2FzIDc3NDg2OGMuLi4gTWVyZ2UgYnJhbmNoICdwZXJmLXVyZ2VudC1m
b3ItbGludXMnIG9mIGdpdDovL2dpdC5rZXJuZWwub3JnL3B1Yi9zY20vbGludXgva2VybmVs
L2dpdC90aXAvdGlwCkhFQUQgaXMgbm93IGF0IDA2ZWQyNmQuLi4gQWRkIGxpbnV4LW5leHQg
c3BlY2lmaWMgZmlsZXMgZm9yIDIwMTQwMzIxCmxzIC1hIC9rZXJuZWwtdGVzdHMvcnVuLXF1
ZXVlL2t2bS9pMzg2LXJhbmRjb25maWctaXY0LTAzMjQvbGludXgtZGV2ZWw6ZGV2ZWwtaG91
cmx5LTIwMTQwMzI0MTM6MDZlZDI2ZDFkZTU5Y2U3Y2JiZTY4Mzc4YjdlNDcwYmUxNjk3NTBl
NTpiaXNlY3QtdXNiCgoyMDE0LTAzLTI0LTE1OjE3OjE0IDA2ZWQyNmQxZGU1OWNlN2NiYmU2
ODM3OGI3ZTQ3MGJlMTY5NzUwZTUgY29tcGlsaW5nClF1ZXVlZCBidWlsZCB0YXNrIHRvIC9r
ZXJuZWwtdGVzdHMvYnVpbGQtcXVldWUvaTM4Ni1yYW5kY29uZmlnLWl2NC0wMzI0LTA2ZWQy
NmQxZGU1OWNlN2NiYmU2ODM3OGI3ZTQ3MGJlMTY5NzUwZTUKQ2hlY2sgZm9yIGtlcm5lbCBp
biAva2VybmVsL2kzODYtcmFuZGNvbmZpZy1pdjQtMDMyNC8wNmVkMjZkMWRlNTljZTdjYmJl
NjgzNzhiN2U0NzBiZTE2OTc1MGU1CndhaXRpbmcgZm9yIGNvbXBsZXRpb24gb2YgL2tlcm5l
bC10ZXN0cy9idWlsZC1xdWV1ZS9pMzg2LXJhbmRjb25maWctaXY0LTAzMjQtMDZlZDI2ZDFk
ZTU5Y2U3Y2JiZTY4Mzc4YjdlNDcwYmUxNjk3NTBlNQp3YWl0aW5nIGZvciBjb21wbGV0aW9u
IG9mIC9rZXJuZWwtdGVzdHMvYnVpbGQtcXVldWUvLmkzODYtcmFuZGNvbmZpZy1pdjQtMDMy
NC0wNmVkMjZkMWRlNTljZTdjYmJlNjgzNzhiN2U0NzBiZTE2OTc1MGU1Cmtlcm5lbDogL2tl
cm5lbC9pMzg2LXJhbmRjb25maWctaXY0LTAzMjQvMDZlZDI2ZDFkZTU5Y2U3Y2JiZTY4Mzc4
YjdlNDcwYmUxNjk3NTBlNS92bWxpbnV6LTMuMTQuMC1yYzctbmV4dC0yMDE0MDMyMQoKMjAx
NC0wMy0yNC0xNToyMDoxNCBkZXRlY3RpbmcgYm9vdCBzdGF0ZSAJMzQJMzgJNTMJNjAgU1VD
Q0VTUwoK

--HcAYCG3uE/tztfnV
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="config-3.14.0-rc7-00067-g2301503"

#
# Automatically generated file; DO NOT EDIT.
# Linux/i386 3.14.0-rc7 Kernel Configuration
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
CONFIG_ARCH_HWEIGHT_CFLAGS="-fcall-saved-ecx -fcall-saved-edx"
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
# CONFIG_KERNEL_BZIP2 is not set
# CONFIG_KERNEL_LZMA is not set
# CONFIG_KERNEL_XZ is not set
# CONFIG_KERNEL_LZO is not set
CONFIG_KERNEL_LZ4=y
CONFIG_DEFAULT_HOSTNAME="(none)"
# CONFIG_SWAP is not set
# CONFIG_SYSVIPC is not set
CONFIG_POSIX_MQUEUE=y
# CONFIG_FHANDLE is not set
CONFIG_AUDIT=y
CONFIG_AUDITSYSCALL=y
CONFIG_AUDIT_WATCH=y
CONFIG_AUDIT_TREE=y

#
# IRQ subsystem
#
CONFIG_GENERIC_IRQ_PROBE=y
CONFIG_GENERIC_IRQ_SHOW=y
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
CONFIG_BSD_PROCESS_ACCT=y
CONFIG_BSD_PROCESS_ACCT_V3=y
CONFIG_TASKSTATS=y
CONFIG_TASK_DELAY_ACCT=y
CONFIG_TASK_XACCT=y
# CONFIG_TASK_IO_ACCOUNTING is not set

#
# RCU Subsystem
#
CONFIG_TINY_RCU=y
# CONFIG_PREEMPT_RCU is not set
CONFIG_RCU_STALL_COMMON=y
# CONFIG_TREE_RCU_TRACE is not set
CONFIG_IKCONFIG=y
# CONFIG_IKCONFIG_PROC is not set
CONFIG_LOG_BUF_SHIFT=17
CONFIG_HAVE_UNSTABLE_SCHED_CLOCK=y
CONFIG_ARCH_SUPPORTS_NUMA_BALANCING=y
CONFIG_ARCH_WANTS_PROT_NUMA_PROT_NONE=y
CONFIG_CGROUPS=y
# CONFIG_CGROUP_DEBUG is not set
# CONFIG_CGROUP_FREEZER is not set
# CONFIG_CGROUP_DEVICE is not set
# CONFIG_CPUSETS is not set
# CONFIG_CGROUP_CPUACCT is not set
# CONFIG_RESOURCE_COUNTERS is not set
# CONFIG_CGROUP_PERF is not set
CONFIG_CGROUP_SCHED=y
CONFIG_FAIR_GROUP_SCHED=y
# CONFIG_CFS_BANDWIDTH is not set
CONFIG_RT_GROUP_SCHED=y
CONFIG_BLK_CGROUP=y
# CONFIG_DEBUG_BLK_CGROUP is not set
CONFIG_CHECKPOINT_RESTORE=y
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
CONFIG_SHMEM=y
# CONFIG_AIO is not set
CONFIG_PCI_QUIRKS=y
# CONFIG_EMBEDDED is not set
CONFIG_HAVE_PERF_EVENTS=y
CONFIG_PERF_USE_VMALLOC=y

#
# Kernel Performance Events And Counters
#
CONFIG_PERF_EVENTS=y
CONFIG_DEBUG_PERF_USE_VMALLOC=y
CONFIG_VM_EVENT_COUNTERS=y
CONFIG_COMPAT_BRK=y
CONFIG_SLAB=y
# CONFIG_SLUB is not set
# CONFIG_SLOB is not set
CONFIG_PROFILING=y
CONFIG_TRACEPOINTS=y
CONFIG_OPROFILE=y
CONFIG_OPROFILE_EVENT_MULTIPLEX=y
CONFIG_HAVE_OPROFILE=y
CONFIG_OPROFILE_NMI_TIMER=y
CONFIG_KPROBES=y
CONFIG_JUMP_LABEL=y
CONFIG_OPTPROBES=y
CONFIG_KPROBES_ON_FTRACE=y
CONFIG_UPROBES=y
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
CONFIG_CC_STACKPROTECTOR=y
# CONFIG_CC_STACKPROTECTOR_NONE is not set
CONFIG_CC_STACKPROTECTOR_REGULAR=y
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
CONFIG_GCOV_KERNEL=y
# CONFIG_GCOV_PROFILE_ALL is not set
# CONFIG_GCOV_FORMAT_AUTODETECT is not set
CONFIG_GCOV_FORMAT_3_4=y
# CONFIG_GCOV_FORMAT_4_7 is not set
CONFIG_HAVE_GENERIC_DMA_COHERENT=y
CONFIG_SLABINFO=y
CONFIG_RT_MUTEXES=y
CONFIG_BASE_SMALL=0
CONFIG_SYSTEM_TRUSTED_KEYRING=y
CONFIG_MODULES=y
# CONFIG_MODULE_FORCE_LOAD is not set
CONFIG_MODULE_UNLOAD=y
# CONFIG_MODULE_FORCE_UNLOAD is not set
# CONFIG_MODVERSIONS is not set
CONFIG_MODULE_SRCVERSION_ALL=y
CONFIG_MODULE_SIG=y
CONFIG_MODULE_SIG_FORCE=y
CONFIG_MODULE_SIG_ALL=y
# CONFIG_MODULE_SIG_SHA1 is not set
# CONFIG_MODULE_SIG_SHA224 is not set
# CONFIG_MODULE_SIG_SHA256 is not set
# CONFIG_MODULE_SIG_SHA384 is not set
CONFIG_MODULE_SIG_SHA512=y
CONFIG_MODULE_SIG_HASH="sha512"
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
CONFIG_IOSCHED_CFQ=y
# CONFIG_CFQ_GROUP_IOSCHED is not set
# CONFIG_DEFAULT_DEADLINE is not set
CONFIG_DEFAULT_CFQ=y
# CONFIG_DEFAULT_NOOP is not set
CONFIG_DEFAULT_IOSCHED="cfq"
CONFIG_PREEMPT_NOTIFIERS=y
CONFIG_ASN1=y
CONFIG_UNINLINE_SPIN_UNLOCK=y
# CONFIG_FREEZER is not set

#
# Processor type and features
#
# CONFIG_ZONE_DMA is not set
# CONFIG_SMP is not set
# CONFIG_X86_MPPARSE is not set
# CONFIG_X86_EXTENDED_PLATFORM is not set
# CONFIG_X86_INTEL_LPSS is not set
CONFIG_X86_SUPPORTS_MEMORY_FAILURE=y
CONFIG_X86_32_IRIS=y
# CONFIG_SCHED_OMIT_FRAME_POINTER is not set
CONFIG_HYPERVISOR_GUEST=y
CONFIG_PARAVIRT=y
# CONFIG_PARAVIRT_DEBUG is not set
# CONFIG_XEN is not set
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
# CONFIG_M686 is not set
# CONFIG_MPENTIUMII is not set
# CONFIG_MPENTIUMIII is not set
# CONFIG_MPENTIUMM is not set
# CONFIG_MPENTIUM4 is not set
CONFIG_MK6=y
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
CONFIG_X86_ALIGNMENT_16=y
CONFIG_X86_INTEL_USERCOPY=y
CONFIG_X86_USE_PPRO_CHECKSUM=y
CONFIG_X86_TSC=y
CONFIG_X86_CMPXCHG64=y
CONFIG_X86_MINIMUM_CPU_FAMILY=5
# CONFIG_PROCESSOR_SELECT is not set
CONFIG_CPU_SUP_INTEL=y
CONFIG_CPU_SUP_CYRIX_32=y
CONFIG_CPU_SUP_AMD=y
CONFIG_CPU_SUP_CENTAUR=y
CONFIG_CPU_SUP_TRANSMETA_32=y
CONFIG_CPU_SUP_UMC_32=y
CONFIG_HPET_TIMER=y
CONFIG_DMI=y
CONFIG_NR_CPUS=1
CONFIG_PREEMPT_NONE=y
# CONFIG_PREEMPT_VOLUNTARY is not set
# CONFIG_PREEMPT is not set
CONFIG_PREEMPT_COUNT=y
CONFIG_X86_LOCAL_APIC=y
CONFIG_X86_IO_APIC=y
# CONFIG_X86_REROUTE_FOR_BROKEN_BOOT_IRQS is not set
CONFIG_X86_MCE=y
CONFIG_X86_MCE_INTEL=y
CONFIG_X86_MCE_AMD=y
# CONFIG_X86_ANCIENT_MCE is not set
CONFIG_X86_MCE_THRESHOLD=y
# CONFIG_X86_MCE_INJECT is not set
CONFIG_X86_THERMAL_VECTOR=y
CONFIG_VM86=y
CONFIG_TOSHIBA=y
# CONFIG_I8K is not set
CONFIG_X86_REBOOTFIXUPS=y
CONFIG_MICROCODE=m
# CONFIG_MICROCODE_INTEL is not set
# CONFIG_MICROCODE_AMD is not set
CONFIG_MICROCODE_OLD_INTERFACE=y
# CONFIG_MICROCODE_INTEL_EARLY is not set
# CONFIG_MICROCODE_AMD_EARLY is not set
CONFIG_X86_MSR=y
CONFIG_X86_CPUID=y
CONFIG_NOHIGHMEM=y
# CONFIG_HIGHMEM4G is not set
# CONFIG_HIGHMEM64G is not set
CONFIG_VMSPLIT_3G=y
# CONFIG_VMSPLIT_2G is not set
# CONFIG_VMSPLIT_1G is not set
CONFIG_PAGE_OFFSET=0xC0000000
CONFIG_X86_PAE=y
CONFIG_ARCH_PHYS_ADDR_T_64BIT=y
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
CONFIG_ARCH_ENABLE_SPLIT_PMD_PTLOCK=y
CONFIG_COMPACTION=y
CONFIG_MIGRATION=y
CONFIG_PHYS_ADDR_T_64BIT=y
CONFIG_ZONE_DMA_FLAG=0
CONFIG_VIRT_TO_BUS=y
CONFIG_MMU_NOTIFIER=y
CONFIG_KSM=y
CONFIG_DEFAULT_MMAP_MIN_ADDR=4096
CONFIG_ARCH_SUPPORTS_MEMORY_FAILURE=y
CONFIG_MEMORY_FAILURE=y
# CONFIG_HWPOISON_INJECT is not set
# CONFIG_TRANSPARENT_HUGEPAGE is not set
# CONFIG_CROSS_MEMORY_ATTACH is not set
CONFIG_NEED_PER_CPU_KM=y
CONFIG_CLEANCACHE=y
# CONFIG_CMA is not set
# CONFIG_ZBUD is not set
CONFIG_MEM_SOFT_DIRTY=y
# CONFIG_ZSMALLOC is not set
CONFIG_X86_CHECK_BIOS_CORRUPTION=y
CONFIG_X86_BOOTPARAM_MEMORY_CORRUPTION_CHECK=y
CONFIG_X86_RESERVE_LOW=64
# CONFIG_MATH_EMULATION is not set
# CONFIG_MTRR is not set
CONFIG_ARCH_RANDOM=y
# CONFIG_X86_SMAP is not set
# CONFIG_EFI is not set
CONFIG_SECCOMP=y
# CONFIG_HZ_100 is not set
CONFIG_HZ_250=y
# CONFIG_HZ_300 is not set
# CONFIG_HZ_1000 is not set
CONFIG_HZ=250
CONFIG_SCHED_HRTICK=y
CONFIG_KEXEC=y
CONFIG_PHYSICAL_START=0x1000000
# CONFIG_RELOCATABLE is not set
CONFIG_PHYSICAL_ALIGN=0x200000
CONFIG_COMPAT_VDSO=y
# CONFIG_CMDLINE_BOOL is not set

#
# Power management and ACPI options
#
# CONFIG_SUSPEND is not set
# CONFIG_PM_RUNTIME is not set
CONFIG_ACPI=y
# CONFIG_ACPI_PROCFS is not set
# CONFIG_ACPI_EC_DEBUGFS is not set
CONFIG_ACPI_AC=y
CONFIG_ACPI_BATTERY=y
CONFIG_ACPI_BUTTON=y
CONFIG_ACPI_VIDEO=m
CONFIG_ACPI_FAN=y
# CONFIG_ACPI_DOCK is not set
CONFIG_ACPI_PROCESSOR=y
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
CONFIG_CPU_FREQ_STAT=m
CONFIG_CPU_FREQ_STAT_DETAILS=y
CONFIG_CPU_FREQ_DEFAULT_GOV_PERFORMANCE=y
# CONFIG_CPU_FREQ_DEFAULT_GOV_POWERSAVE is not set
# CONFIG_CPU_FREQ_DEFAULT_GOV_USERSPACE is not set
# CONFIG_CPU_FREQ_DEFAULT_GOV_ONDEMAND is not set
# CONFIG_CPU_FREQ_DEFAULT_GOV_CONSERVATIVE is not set
CONFIG_CPU_FREQ_GOV_PERFORMANCE=y
CONFIG_CPU_FREQ_GOV_POWERSAVE=m
# CONFIG_CPU_FREQ_GOV_USERSPACE is not set
# CONFIG_CPU_FREQ_GOV_ONDEMAND is not set
CONFIG_CPU_FREQ_GOV_CONSERVATIVE=m

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
# CONFIG_X86_SPEEDSTEP_ICH is not set
# CONFIG_X86_SPEEDSTEP_SMI is not set
CONFIG_X86_P4_CLOCKMOD=m
CONFIG_X86_CPUFREQ_NFORCE2=m
CONFIG_X86_LONGRUN=y
# CONFIG_X86_LONGHAUL is not set
# CONFIG_X86_E_POWERSAVER is not set

#
# shared options
#
CONFIG_X86_SPEEDSTEP_LIB=m

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
# CONFIG_PCI_GOBIOS is not set
# CONFIG_PCI_GOMMCONFIG is not set
# CONFIG_PCI_GODIRECT is not set
CONFIG_PCI_GOANY=y
CONFIG_PCI_BIOS=y
CONFIG_PCI_DIRECT=y
CONFIG_PCI_MMCONFIG=y
CONFIG_PCI_DOMAINS=y
# CONFIG_PCI_CNB20LE_QUIRK is not set
CONFIG_PCIEPORTBUS=y
CONFIG_PCIEAER=y
# CONFIG_PCIE_ECRC is not set
CONFIG_PCIEAER_INJECT=y
CONFIG_PCIEASPM=y
CONFIG_PCIEASPM_DEBUG=y
CONFIG_PCIEASPM_DEFAULT=y
# CONFIG_PCIEASPM_POWERSAVE is not set
# CONFIG_PCIEASPM_PERFORMANCE is not set
CONFIG_PCI_MSI=y
# CONFIG_PCI_DEBUG is not set
CONFIG_PCI_REALLOC_ENABLE_AUTO=y
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
CONFIG_SCx200=m
CONFIG_SCx200HR_TIMER=m
CONFIG_ALIX=y
# CONFIG_NET5501 is not set
# CONFIG_GEOS is not set
CONFIG_AMD_NB=y
CONFIG_PCCARD=y
CONFIG_PCMCIA=y
CONFIG_PCMCIA_LOAD_CIS=y
# CONFIG_CARDBUS is not set

#
# PC-card bridges
#
CONFIG_YENTA=y
# CONFIG_YENTA_O2 is not set
# CONFIG_YENTA_RICOH is not set
# CONFIG_YENTA_TI is not set
CONFIG_YENTA_TOSHIBA=y
# CONFIG_PD6729 is not set
CONFIG_I82092=y
CONFIG_PCCARD_NONSTATIC=y
# CONFIG_HOTPLUG_PCI is not set
# CONFIG_RAPIDIO is not set
# CONFIG_X86_SYSFB is not set

#
# Executable file formats / Emulations
#
CONFIG_BINFMT_ELF=y
CONFIG_ARCH_BINFMT_ELF_RANDOMIZE_PIE=y
# CONFIG_CORE_DUMP_DEFAULT_ELF_HEADERS is not set
CONFIG_BINFMT_SCRIPT=y
CONFIG_HAVE_AOUT=y
CONFIG_BINFMT_AOUT=m
CONFIG_BINFMT_MISC=m
CONFIG_COREDUMP=y
CONFIG_HAVE_ATOMIC_IOMAP=y
CONFIG_NET=y

#
# Networking options
#
# CONFIG_PACKET is not set
CONFIG_UNIX=y
# CONFIG_UNIX_DIAG is not set
CONFIG_XFRM=y
CONFIG_XFRM_ALGO=y
CONFIG_XFRM_USER=m
CONFIG_XFRM_SUB_POLICY=y
CONFIG_XFRM_MIGRATE=y
# CONFIG_XFRM_STATISTICS is not set
CONFIG_XFRM_IPCOMP=m
CONFIG_NET_KEY=y
CONFIG_NET_KEY_MIGRATE=y
CONFIG_INET=y
# CONFIG_IP_MULTICAST is not set
# CONFIG_IP_ADVANCED_ROUTER is not set
# CONFIG_IP_PNP is not set
CONFIG_NET_IPIP=m
CONFIG_NET_IPGRE_DEMUX=m
CONFIG_NET_IP_TUNNEL=y
# CONFIG_NET_IPGRE is not set
CONFIG_SYN_COOKIES=y
CONFIG_NET_IPVTI=y
# CONFIG_INET_AH is not set
CONFIG_INET_ESP=y
# CONFIG_INET_IPCOMP is not set
# CONFIG_INET_XFRM_TUNNEL is not set
CONFIG_INET_TUNNEL=y
CONFIG_INET_XFRM_MODE_TRANSPORT=y
CONFIG_INET_XFRM_MODE_TUNNEL=y
# CONFIG_INET_XFRM_MODE_BEET is not set
# CONFIG_INET_LRO is not set
CONFIG_INET_DIAG=y
CONFIG_INET_TCP_DIAG=y
CONFIG_INET_UDP_DIAG=y
# CONFIG_TCP_CONG_ADVANCED is not set
CONFIG_TCP_CONG_CUBIC=y
CONFIG_DEFAULT_TCP_CONG="cubic"
# CONFIG_TCP_MD5SIG is not set
CONFIG_IPV6=y
# CONFIG_IPV6_ROUTER_PREF is not set
# CONFIG_IPV6_OPTIMISTIC_DAD is not set
CONFIG_INET6_AH=m
CONFIG_INET6_ESP=y
CONFIG_INET6_IPCOMP=m
CONFIG_IPV6_MIP6=m
CONFIG_INET6_XFRM_TUNNEL=m
CONFIG_INET6_TUNNEL=y
# CONFIG_INET6_XFRM_MODE_TRANSPORT is not set
CONFIG_INET6_XFRM_MODE_TUNNEL=m
CONFIG_INET6_XFRM_MODE_BEET=y
# CONFIG_INET6_XFRM_MODE_ROUTEOPTIMIZATION is not set
CONFIG_IPV6_VTI=m
CONFIG_IPV6_SIT=y
# CONFIG_IPV6_SIT_6RD is not set
CONFIG_IPV6_NDISC_NODETYPE=y
CONFIG_IPV6_TUNNEL=y
CONFIG_IPV6_GRE=y
# CONFIG_IPV6_MULTIPLE_TABLES is not set
# CONFIG_IPV6_MROUTE is not set
CONFIG_NETLABEL=y
CONFIG_NETWORK_SECMARK=y
# CONFIG_NETWORK_PHY_TIMESTAMPING is not set
# CONFIG_NETFILTER is not set
# CONFIG_IP_DCCP is not set
CONFIG_IP_SCTP=y
CONFIG_NET_SCTPPROBE=m
CONFIG_SCTP_DBG_OBJCNT=y
# CONFIG_SCTP_DEFAULT_COOKIE_HMAC_MD5 is not set
# CONFIG_SCTP_DEFAULT_COOKIE_HMAC_SHA1 is not set
CONFIG_SCTP_DEFAULT_COOKIE_HMAC_NONE=y
CONFIG_SCTP_COOKIE_HMAC_MD5=y
CONFIG_SCTP_COOKIE_HMAC_SHA1=y
# CONFIG_RDS is not set
CONFIG_TIPC=y
CONFIG_TIPC_PORTS=8191
CONFIG_ATM=m
# CONFIG_ATM_CLIP is not set
CONFIG_ATM_LANE=m
# CONFIG_ATM_MPOA is not set
# CONFIG_ATM_BR2684 is not set
# CONFIG_L2TP is not set
CONFIG_STP=m
CONFIG_BRIDGE=m
# CONFIG_BRIDGE_IGMP_SNOOPING is not set
# CONFIG_VLAN_8021Q is not set
CONFIG_DECNET=m
# CONFIG_DECNET_ROUTER is not set
CONFIG_LLC=m
CONFIG_LLC2=m
# CONFIG_IPX is not set
# CONFIG_ATALK is not set
CONFIG_X25=m
CONFIG_LAPB=y
CONFIG_PHONET=m
CONFIG_IEEE802154=y
CONFIG_IEEE802154_6LOWPAN=m
CONFIG_6LOWPAN_IPHC=m
CONFIG_MAC802154=y
# CONFIG_NET_SCHED is not set
CONFIG_DCB=y
CONFIG_DNS_RESOLVER=y
CONFIG_BATMAN_ADV=y
# CONFIG_BATMAN_ADV_BLA is not set
CONFIG_BATMAN_ADV_DAT=y
# CONFIG_BATMAN_ADV_NC is not set
# CONFIG_BATMAN_ADV_DEBUG is not set
CONFIG_OPENVSWITCH=y
CONFIG_VSOCKETS=m
# CONFIG_VMWARE_VMCI_VSOCKETS is not set
# CONFIG_NETLINK_MMAP is not set
CONFIG_NETLINK_DIAG=y
CONFIG_NET_MPLS_GSO=m
# CONFIG_HSR is not set
# CONFIG_CGROUP_NET_PRIO is not set
CONFIG_CGROUP_NET_CLASSID=y
CONFIG_NET_RX_BUSY_POLL=y
CONFIG_BQL=y

#
# Network testing
#
# CONFIG_NET_PKTGEN is not set
CONFIG_NET_TCPPROBE=y
CONFIG_NET_DROP_MONITOR=m
CONFIG_HAMRADIO=y

#
# Packet Radio protocols
#
CONFIG_AX25=y
# CONFIG_AX25_DAMA_SLAVE is not set
CONFIG_NETROM=m
# CONFIG_ROSE is not set

#
# AX.25 network device drivers
#
# CONFIG_MKISS is not set
# CONFIG_6PACK is not set
# CONFIG_BPQETHER is not set
CONFIG_BAYCOM_SER_FDX=y
CONFIG_BAYCOM_SER_HDX=m
CONFIG_YAM=y
CONFIG_CAN=y
# CONFIG_CAN_RAW is not set
CONFIG_CAN_BCM=m
# CONFIG_CAN_GW is not set

#
# CAN Device Drivers
#
# CONFIG_CAN_VCAN is not set
CONFIG_CAN_SLCAN=y
CONFIG_CAN_DEV=m
CONFIG_CAN_CALC_BITTIMING=y
# CONFIG_CAN_LEDS is not set
# CONFIG_CAN_JANZ_ICAN3 is not set
CONFIG_PCH_CAN=m
# CONFIG_CAN_SJA1000 is not set
CONFIG_CAN_C_CAN=m
CONFIG_CAN_C_CAN_PLATFORM=m
CONFIG_CAN_C_CAN_PCI=m
CONFIG_CAN_CC770=m
CONFIG_CAN_CC770_ISA=m
CONFIG_CAN_CC770_PLATFORM=m
CONFIG_CAN_SOFTING=m
# CONFIG_CAN_SOFTING_CS is not set
# CONFIG_CAN_DEBUG_DEVICES is not set
CONFIG_IRDA=y

#
# IrDA protocols
#
# CONFIG_IRLAN is not set
CONFIG_IRCOMM=y
# CONFIG_IRDA_ULTRA is not set

#
# IrDA options
#
# CONFIG_IRDA_CACHE_LAST_LSAP is not set
CONFIG_IRDA_FAST_RR=y
CONFIG_IRDA_DEBUG=y

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
# CONFIG_NSC_FIR is not set
CONFIG_WINBOND_FIR=m
# CONFIG_TOSHIBA_FIR is not set
# CONFIG_SMC_IRCC_FIR is not set
CONFIG_ALI_FIR=m
CONFIG_VLSI_FIR=y
CONFIG_VIA_FIR=m
# CONFIG_BT is not set
CONFIG_AF_RXRPC=y
# CONFIG_AF_RXRPC_DEBUG is not set
CONFIG_RXKAD=m
CONFIG_WIRELESS=y
# CONFIG_CFG80211 is not set
# CONFIG_LIB80211 is not set

#
# CFG80211 needs to be enabled for MAC80211
#
CONFIG_WIMAX=y
CONFIG_WIMAX_DEBUG_LEVEL=8
CONFIG_RFKILL=y
CONFIG_RFKILL_LEDS=y
CONFIG_RFKILL_INPUT=y
# CONFIG_RFKILL_REGULATOR is not set
CONFIG_RFKILL_GPIO=y
CONFIG_NET_9P=m
CONFIG_NET_9P_VIRTIO=m
# CONFIG_NET_9P_RDMA is not set
# CONFIG_NET_9P_DEBUG is not set
CONFIG_CAIF=m
CONFIG_CAIF_DEBUG=y
CONFIG_CAIF_NETDEV=m
CONFIG_CAIF_USB=m
CONFIG_CEPH_LIB=m
# CONFIG_CEPH_LIB_PRETTYDEBUG is not set
CONFIG_CEPH_LIB_USE_DNS_RESOLVER=y
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
CONFIG_STANDALONE=y
# CONFIG_PREVENT_FIRMWARE_BUILD is not set
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

#
# Bus devices
#
CONFIG_CONNECTOR=m
CONFIG_MTD=y
CONFIG_MTD_TESTS=m
CONFIG_MTD_REDBOOT_PARTS=m
CONFIG_MTD_REDBOOT_DIRECTORY_BLOCK=-1
CONFIG_MTD_REDBOOT_PARTS_UNALLOCATED=y
CONFIG_MTD_REDBOOT_PARTS_READONLY=y
# CONFIG_MTD_CMDLINE_PARTS is not set
CONFIG_MTD_AR7_PARTS=y

#
# User Modules And Translation Layers
#
CONFIG_MTD_BLKDEVS=y
CONFIG_MTD_BLOCK=y
# CONFIG_FTL is not set
# CONFIG_NFTL is not set
CONFIG_INFTL=m
CONFIG_RFD_FTL=m
CONFIG_SSFDC=m
CONFIG_SM_FTL=y
CONFIG_MTD_OOPS=m

#
# RAM/ROM/Flash chip drivers
#
CONFIG_MTD_CFI=y
CONFIG_MTD_JEDECPROBE=m
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
# CONFIG_MTD_ABSENT is not set

#
# Mapping drivers for chip access
#
# CONFIG_MTD_COMPLEX_MAPPINGS is not set
CONFIG_MTD_PHYSMAP=y
# CONFIG_MTD_PHYSMAP_COMPAT is not set
# CONFIG_MTD_SC520CDP is not set
# CONFIG_MTD_NETSC520 is not set
# CONFIG_MTD_TS5500 is not set
# CONFIG_MTD_SCx200_DOCFLASH is not set
CONFIG_MTD_AMD76XROM=m
CONFIG_MTD_ICHXROM=m
CONFIG_MTD_ESB2ROM=m
CONFIG_MTD_CK804XROM=m
CONFIG_MTD_SCB2_FLASH=m
CONFIG_MTD_NETtel=m
CONFIG_MTD_L440GX=m
# CONFIG_MTD_INTEL_VR_NOR is not set
CONFIG_MTD_PLATRAM=y

#
# Self-contained MTD device drivers
#
# CONFIG_MTD_PMC551 is not set
# CONFIG_MTD_SLRAM is not set
# CONFIG_MTD_PHRAM is not set
CONFIG_MTD_MTDRAM=m
CONFIG_MTDRAM_TOTAL_SIZE=4096
CONFIG_MTDRAM_ERASE_SIZE=128
CONFIG_MTD_BLOCK2MTD=y

#
# Disk-On-Chip Device Drivers
#
# CONFIG_MTD_DOCG3 is not set
CONFIG_MTD_NAND_ECC=y
CONFIG_MTD_NAND_ECC_SMC=y
# CONFIG_MTD_NAND is not set
# CONFIG_MTD_ONENAND is not set

#
# LPDDR flash memory drivers
#
# CONFIG_MTD_LPDDR is not set
CONFIG_MTD_UBI=m
CONFIG_MTD_UBI_WL_THRESHOLD=4096
CONFIG_MTD_UBI_BEB_LIMIT=20
# CONFIG_MTD_UBI_FASTMAP is not set
# CONFIG_MTD_UBI_GLUEBI is not set
# CONFIG_PARPORT is not set
CONFIG_ARCH_MIGHT_HAVE_PC_PARPORT=y
CONFIG_PNP=y
CONFIG_PNP_DEBUG_MESSAGES=y

#
# Protocols
#
CONFIG_PNPACPI=y
CONFIG_BLK_DEV=y
# CONFIG_BLK_DEV_NULL_BLK is not set
# CONFIG_BLK_DEV_FD is not set
# CONFIG_BLK_DEV_PCIESSD_MTIP32XX is not set
# CONFIG_BLK_CPQ_CISS_DA is not set
# CONFIG_BLK_DEV_DAC960 is not set
# CONFIG_BLK_DEV_UMEM is not set
# CONFIG_BLK_DEV_COW_COMMON is not set
# CONFIG_BLK_DEV_LOOP is not set
# CONFIG_BLK_DEV_DRBD is not set
# CONFIG_BLK_DEV_NBD is not set
# CONFIG_BLK_DEV_NVME is not set
# CONFIG_BLK_DEV_OSD is not set
# CONFIG_BLK_DEV_SX8 is not set
# CONFIG_BLK_DEV_RAM is not set
# CONFIG_CDROM_PKTCDVD is not set
# CONFIG_ATA_OVER_ETH is not set
# CONFIG_VIRTIO_BLK is not set
# CONFIG_BLK_DEV_HD is not set
# CONFIG_BLK_DEV_RBD is not set
# CONFIG_BLK_DEV_RSXX is not set

#
# Misc devices
#
CONFIG_SENSORS_LIS3LV02D=m
CONFIG_AD525X_DPOT=y
CONFIG_AD525X_DPOT_I2C=y
CONFIG_DUMMY_IRQ=m
CONFIG_IBM_ASM=m
# CONFIG_PHANTOM is not set
# CONFIG_SGI_IOC4 is not set
CONFIG_TIFM_CORE=m
CONFIG_TIFM_7XX1=m
CONFIG_ICS932S401=m
CONFIG_ATMEL_SSC=y
# CONFIG_ENCLOSURE_SERVICES is not set
CONFIG_CS5535_MFGPT=m
CONFIG_CS5535_MFGPT_DEFAULT_IRQ=7
CONFIG_CS5535_CLOCK_EVENT_SRC=m
# CONFIG_HP_ILO is not set
# CONFIG_APDS9802ALS is not set
CONFIG_ISL29003=m
# CONFIG_ISL29020 is not set
# CONFIG_SENSORS_TSL2550 is not set
# CONFIG_SENSORS_BH1780 is not set
# CONFIG_SENSORS_BH1770 is not set
CONFIG_SENSORS_APDS990X=y
# CONFIG_HMC6352 is not set
# CONFIG_DS1682 is not set
# CONFIG_VMWARE_BALLOON is not set
# CONFIG_BMP085_I2C is not set
# CONFIG_PCH_PHUB is not set
CONFIG_USB_SWITCH_FSA9480=m
# CONFIG_SRAM is not set
CONFIG_C2PORT=y
# CONFIG_C2PORT_DURAMAR_2150 is not set

#
# EEPROM support
#
CONFIG_EEPROM_AT24=y
CONFIG_EEPROM_LEGACY=m
CONFIG_EEPROM_MAX6875=y
# CONFIG_EEPROM_93CX6 is not set
CONFIG_CB710_CORE=m
# CONFIG_CB710_DEBUG is not set
CONFIG_CB710_DEBUG_ASSUMPTIONS=y

#
# Texas Instruments shared transport line discipline
#
CONFIG_TI_ST=m
CONFIG_SENSORS_LIS3_I2C=m

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
CONFIG_IDE=m

#
# Please see Documentation/ide/ide.txt for help/info on IDE drives
#
CONFIG_IDE_XFER_MODE=y
CONFIG_IDE_TIMINGS=y
CONFIG_IDE_ATAPI=y
CONFIG_BLK_DEV_IDE_SATA=y
CONFIG_IDE_GD=m
CONFIG_IDE_GD_ATA=y
CONFIG_IDE_GD_ATAPI=y
CONFIG_BLK_DEV_IDECS=m
CONFIG_BLK_DEV_IDECD=m
# CONFIG_BLK_DEV_IDECD_VERBOSE_ERRORS is not set
CONFIG_BLK_DEV_IDETAPE=m
# CONFIG_BLK_DEV_IDEACPI is not set
# CONFIG_IDE_TASK_IOCTL is not set
CONFIG_IDE_PROC_FS=y

#
# IDE chipset support/bugfixes
#
# CONFIG_IDE_GENERIC is not set
CONFIG_BLK_DEV_PLATFORM=m
# CONFIG_BLK_DEV_CMD640 is not set
# CONFIG_BLK_DEV_IDEPNP is not set
CONFIG_BLK_DEV_IDEDMA_SFF=y

#
# PCI IDE chipsets support
#
CONFIG_BLK_DEV_IDEPCI=y
CONFIG_BLK_DEV_OFFBOARD=y
# CONFIG_BLK_DEV_GENERIC is not set
CONFIG_BLK_DEV_OPTI621=m
# CONFIG_BLK_DEV_RZ1000 is not set
CONFIG_BLK_DEV_IDEDMA_PCI=y
# CONFIG_BLK_DEV_AEC62XX is not set
CONFIG_BLK_DEV_ALI15X3=m
# CONFIG_BLK_DEV_AMD74XX is not set
# CONFIG_BLK_DEV_ATIIXP is not set
CONFIG_BLK_DEV_CMD64X=m
# CONFIG_BLK_DEV_TRIFLEX is not set
# CONFIG_BLK_DEV_CS5520 is not set
# CONFIG_BLK_DEV_CS5530 is not set
# CONFIG_BLK_DEV_CS5535 is not set
# CONFIG_BLK_DEV_CS5536 is not set
# CONFIG_BLK_DEV_HPT366 is not set
CONFIG_BLK_DEV_JMICRON=m
CONFIG_BLK_DEV_SC1200=m
# CONFIG_BLK_DEV_PIIX is not set
CONFIG_BLK_DEV_IT8172=m
# CONFIG_BLK_DEV_IT8213 is not set
CONFIG_BLK_DEV_IT821X=m
CONFIG_BLK_DEV_NS87415=m
CONFIG_BLK_DEV_PDC202XX_OLD=m
CONFIG_BLK_DEV_PDC202XX_NEW=m
CONFIG_BLK_DEV_SVWKS=m
CONFIG_BLK_DEV_SIIMAGE=m
# CONFIG_BLK_DEV_SIS5513 is not set
# CONFIG_BLK_DEV_SLC90E66 is not set
CONFIG_BLK_DEV_TRM290=m
# CONFIG_BLK_DEV_VIA82CXXX is not set
CONFIG_BLK_DEV_TC86C001=m
CONFIG_BLK_DEV_IDEDMA=y

#
# SCSI device support
#
CONFIG_SCSI_MOD=y
CONFIG_RAID_ATTRS=m
CONFIG_SCSI=y
CONFIG_SCSI_DMA=y
# CONFIG_SCSI_TGT is not set
CONFIG_SCSI_NETLINK=y
# CONFIG_SCSI_PROC_FS is not set

#
# SCSI support type (disk, tape, CD-ROM)
#
CONFIG_BLK_DEV_SD=m
# CONFIG_CHR_DEV_ST is not set
CONFIG_CHR_DEV_OSST=m
CONFIG_BLK_DEV_SR=y
CONFIG_BLK_DEV_SR_VENDOR=y
CONFIG_CHR_DEV_SG=m
# CONFIG_CHR_DEV_SCH is not set
# CONFIG_SCSI_MULTI_LUN is not set
# CONFIG_SCSI_CONSTANTS is not set
CONFIG_SCSI_LOGGING=y
CONFIG_SCSI_SCAN_ASYNC=y

#
# SCSI Transports
#
CONFIG_SCSI_SPI_ATTRS=m
CONFIG_SCSI_FC_ATTRS=y
CONFIG_SCSI_ISCSI_ATTRS=y
# CONFIG_SCSI_SAS_ATTRS is not set
# CONFIG_SCSI_SAS_LIBSAS is not set
CONFIG_SCSI_SRP_ATTRS=y
# CONFIG_SCSI_LOWLEVEL is not set
CONFIG_SCSI_LOWLEVEL_PCMCIA=y
CONFIG_PCMCIA_AHA152X=m
CONFIG_PCMCIA_FDOMAIN=m
# CONFIG_PCMCIA_NINJA_SCSI is not set
CONFIG_PCMCIA_QLOGIC=m
CONFIG_PCMCIA_SYM53C500=m
CONFIG_SCSI_DH=m
CONFIG_SCSI_DH_RDAC=m
CONFIG_SCSI_DH_HP_SW=m
CONFIG_SCSI_DH_EMC=m
# CONFIG_SCSI_DH_ALUA is not set
CONFIG_SCSI_OSD_INITIATOR=y
CONFIG_SCSI_OSD_ULD=y
CONFIG_SCSI_OSD_DPRINT_SENSE=1
CONFIG_SCSI_OSD_DEBUG=y
# CONFIG_ATA is not set
# CONFIG_MD is not set
CONFIG_TARGET_CORE=m
CONFIG_TCM_IBLOCK=m
CONFIG_TCM_FILEIO=m
CONFIG_TCM_PSCSI=m
CONFIG_LOOPBACK_TARGET=m
CONFIG_ISCSI_TARGET=m
CONFIG_SBP_TARGET=m
# CONFIG_FUSION is not set

#
# IEEE 1394 (FireWire) support
#
CONFIG_FIREWIRE=m
CONFIG_FIREWIRE_OHCI=m
# CONFIG_FIREWIRE_SBP2 is not set
CONFIG_FIREWIRE_NET=m
CONFIG_FIREWIRE_NOSY=y
CONFIG_I2O=y
# CONFIG_I2O_LCT_NOTIFY_ON_CHANGES is not set
# CONFIG_I2O_EXT_ADAPTEC is not set
CONFIG_I2O_CONFIG=m
# CONFIG_I2O_CONFIG_OLD_IOCTL is not set
CONFIG_I2O_BUS=m
CONFIG_I2O_BLOCK=m
CONFIG_I2O_SCSI=y
# CONFIG_I2O_PROC is not set
CONFIG_MACINTOSH_DRIVERS=y
# CONFIG_NETDEVICES is not set
CONFIG_VHOST_NET=y
CONFIG_VHOST_SCSI=m
CONFIG_VHOST_RING=y
CONFIG_VHOST=y

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
# CONFIG_INPUT_MOUSEDEV_PSAUX is not set
CONFIG_INPUT_MOUSEDEV_SCREEN_X=1024
CONFIG_INPUT_MOUSEDEV_SCREEN_Y=768
CONFIG_INPUT_JOYDEV=y
CONFIG_INPUT_EVDEV=m
# CONFIG_INPUT_EVBUG is not set

#
# Input Device Drivers
#
CONFIG_INPUT_KEYBOARD=y
CONFIG_KEYBOARD_ADP5520=y
CONFIG_KEYBOARD_ADP5588=y
CONFIG_KEYBOARD_ADP5589=m
CONFIG_KEYBOARD_ATKBD=y
CONFIG_KEYBOARD_QT1070=m
# CONFIG_KEYBOARD_QT2160 is not set
# CONFIG_KEYBOARD_LKKBD is not set
CONFIG_KEYBOARD_GPIO=y
CONFIG_KEYBOARD_GPIO_POLLED=m
CONFIG_KEYBOARD_TCA6416=y
# CONFIG_KEYBOARD_TCA8418 is not set
CONFIG_KEYBOARD_MATRIX=m
CONFIG_KEYBOARD_LM8323=m
CONFIG_KEYBOARD_LM8333=y
CONFIG_KEYBOARD_MAX7359=y
# CONFIG_KEYBOARD_MCS is not set
# CONFIG_KEYBOARD_MPR121 is not set
# CONFIG_KEYBOARD_NEWTON is not set
CONFIG_KEYBOARD_OPENCORES=m
CONFIG_KEYBOARD_STOWAWAY=m
CONFIG_KEYBOARD_SUNKBD=y
CONFIG_KEYBOARD_TWL4030=m
CONFIG_KEYBOARD_XTKBD=y
CONFIG_INPUT_MOUSE=y
CONFIG_MOUSE_PS2=y
# CONFIG_MOUSE_PS2_ALPS is not set
# CONFIG_MOUSE_PS2_LOGIPS2PP is not set
CONFIG_MOUSE_PS2_SYNAPTICS=y
CONFIG_MOUSE_PS2_CYPRESS=y
# CONFIG_MOUSE_PS2_LIFEBOOK is not set
# CONFIG_MOUSE_PS2_TRACKPOINT is not set
CONFIG_MOUSE_PS2_ELANTECH=y
CONFIG_MOUSE_PS2_SENTELIC=y
# CONFIG_MOUSE_PS2_TOUCHKIT is not set
CONFIG_MOUSE_SERIAL=m
# CONFIG_MOUSE_APPLETOUCH is not set
# CONFIG_MOUSE_BCM5974 is not set
CONFIG_MOUSE_CYAPA=y
CONFIG_MOUSE_VSXXXAA=y
CONFIG_MOUSE_GPIO=m
CONFIG_MOUSE_SYNAPTICS_I2C=m
# CONFIG_MOUSE_SYNAPTICS_USB is not set
# CONFIG_INPUT_JOYSTICK is not set
# CONFIG_INPUT_TABLET is not set
# CONFIG_INPUT_TOUCHSCREEN is not set
CONFIG_INPUT_MISC=y
CONFIG_INPUT_88PM860X_ONKEY=y
# CONFIG_INPUT_AD714X is not set
CONFIG_INPUT_BMA150=y
# CONFIG_INPUT_MC13783_PWRBUTTON is not set
CONFIG_INPUT_MMA8450=y
CONFIG_INPUT_MPU3050=m
CONFIG_INPUT_APANEL=y
CONFIG_INPUT_GP2A=m
# CONFIG_INPUT_GPIO_TILT_POLLED is not set
# CONFIG_INPUT_WISTRON_BTNS is not set
# CONFIG_INPUT_ATLAS_BTNS is not set
# CONFIG_INPUT_ATI_REMOTE2 is not set
# CONFIG_INPUT_KEYSPAN_REMOTE is not set
CONFIG_INPUT_KXTJ9=m
# CONFIG_INPUT_KXTJ9_POLLED_MODE is not set
# CONFIG_INPUT_POWERMATE is not set
# CONFIG_INPUT_YEALINK is not set
# CONFIG_INPUT_CM109 is not set
CONFIG_INPUT_RETU_PWRBUTTON=y
# CONFIG_INPUT_TWL4030_PWRBUTTON is not set
CONFIG_INPUT_TWL4030_VIBRA=y
CONFIG_INPUT_UINPUT=y
CONFIG_INPUT_PCF8574=m
# CONFIG_INPUT_GPIO_ROTARY_ENCODER is not set
# CONFIG_INPUT_DA9052_ONKEY is not set
CONFIG_INPUT_DA9055_ONKEY=m
CONFIG_INPUT_WM831X_ON=y
# CONFIG_INPUT_ADXL34X is not set
CONFIG_INPUT_CMA3000=m
# CONFIG_INPUT_CMA3000_I2C is not set
CONFIG_INPUT_IDEAPAD_SLIDEBAR=m

#
# Hardware I/O ports
#
CONFIG_SERIO=y
CONFIG_ARCH_MIGHT_HAVE_PC_SERIO=y
CONFIG_SERIO_I8042=y
CONFIG_SERIO_SERPORT=y
CONFIG_SERIO_CT82C710=y
# CONFIG_SERIO_PCIPS2 is not set
CONFIG_SERIO_LIBPS2=y
CONFIG_SERIO_RAW=y
CONFIG_SERIO_ALTERA_PS2=y
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
CONFIG_NOZOMI=m
CONFIG_N_GSM=y
# CONFIG_TRACE_ROUTER is not set
CONFIG_TRACE_SINK=m
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
# CONFIG_SERIAL_8250_CS is not set
CONFIG_SERIAL_8250_NR_UARTS=4
CONFIG_SERIAL_8250_RUNTIME_UARTS=4
# CONFIG_SERIAL_8250_EXTENDED is not set
# CONFIG_SERIAL_8250_DW is not set

#
# Non-8250 serial port support
#
CONFIG_SERIAL_MFD_HSU=y
CONFIG_SERIAL_MFD_HSU_CONSOLE=y
# CONFIG_SERIAL_UARTLITE is not set
CONFIG_SERIAL_CORE=y
CONFIG_SERIAL_CORE_CONSOLE=y
CONFIG_SERIAL_JSM=y
CONFIG_SERIAL_SCCNXP=m
CONFIG_SERIAL_TIMBERDALE=m
CONFIG_SERIAL_ALTERA_JTAGUART=y
CONFIG_SERIAL_ALTERA_JTAGUART_CONSOLE=y
# CONFIG_SERIAL_ALTERA_JTAGUART_CONSOLE_BYPASS is not set
CONFIG_SERIAL_ALTERA_UART=y
CONFIG_SERIAL_ALTERA_UART_MAXPORTS=4
CONFIG_SERIAL_ALTERA_UART_BAUDRATE=115200
# CONFIG_SERIAL_ALTERA_UART_CONSOLE is not set
CONFIG_SERIAL_PCH_UART=y
CONFIG_SERIAL_PCH_UART_CONSOLE=y
CONFIG_SERIAL_ARC=y
# CONFIG_SERIAL_ARC_CONSOLE is not set
CONFIG_SERIAL_ARC_NR_PORTS=1
CONFIG_SERIAL_RP2=y
CONFIG_SERIAL_RP2_NR_UARTS=32
CONFIG_SERIAL_FSL_LPUART=m
# CONFIG_TTY_PRINTK is not set
CONFIG_HVC_DRIVER=y
CONFIG_VIRTIO_CONSOLE=m
# CONFIG_IPMI_HANDLER is not set
CONFIG_HW_RANDOM=y
CONFIG_HW_RANDOM_TIMERIOMEM=y
# CONFIG_HW_RANDOM_INTEL is not set
CONFIG_HW_RANDOM_AMD=m
CONFIG_HW_RANDOM_GEODE=m
CONFIG_HW_RANDOM_VIA=m
# CONFIG_HW_RANDOM_VIRTIO is not set
CONFIG_HW_RANDOM_TPM=y
# CONFIG_NVRAM is not set
CONFIG_R3964=y
# CONFIG_APPLICOM is not set
CONFIG_SONYPI=y

#
# PCMCIA character devices
#
# CONFIG_SYNCLINK_CS is not set
CONFIG_CARDMAN_4000=y
CONFIG_CARDMAN_4040=y
# CONFIG_MWAVE is not set
CONFIG_SCx200_GPIO=m
CONFIG_PC8736x_GPIO=m
CONFIG_NSC_GPIO=y
CONFIG_RAW_DRIVER=y
CONFIG_MAX_RAW_DEVS=256
# CONFIG_HPET is not set
CONFIG_HANGCHECK_TIMER=y
CONFIG_TCG_TPM=y
CONFIG_TCG_TIS=y
# CONFIG_TCG_TIS_I2C_ATMEL is not set
# CONFIG_TCG_TIS_I2C_INFINEON is not set
CONFIG_TCG_TIS_I2C_NUVOTON=y
CONFIG_TCG_NSC=m
# CONFIG_TCG_ATMEL is not set
# CONFIG_TCG_INFINEON is not set
CONFIG_TCG_ST33_I2C=y
# CONFIG_TELCLOCK is not set
CONFIG_DEVPORT=y
CONFIG_I2C=y
CONFIG_I2C_BOARDINFO=y
# CONFIG_I2C_COMPAT is not set
CONFIG_I2C_CHARDEV=m
CONFIG_I2C_MUX=y

#
# Multiplexer I2C Chip support
#
CONFIG_I2C_MUX_GPIO=m
# CONFIG_I2C_MUX_PCA9541 is not set
CONFIG_I2C_MUX_PCA954x=m
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
CONFIG_I2C_ALI1535=y
CONFIG_I2C_ALI1563=m
CONFIG_I2C_ALI15X3=m
CONFIG_I2C_AMD756=m
CONFIG_I2C_AMD756_S4882=m
CONFIG_I2C_AMD8111=y
# CONFIG_I2C_I801 is not set
CONFIG_I2C_ISCH=y
CONFIG_I2C_ISMT=y
# CONFIG_I2C_PIIX4 is not set
CONFIG_I2C_NFORCE2=y
CONFIG_I2C_NFORCE2_S4985=y
CONFIG_I2C_SIS5595=m
CONFIG_I2C_SIS630=y
CONFIG_I2C_SIS96X=m
# CONFIG_I2C_VIA is not set
CONFIG_I2C_VIAPRO=y

#
# ACPI drivers
#
# CONFIG_I2C_SCMI is not set

#
# I2C system bus drivers (mostly embedded / system-on-chip)
#
CONFIG_I2C_CBUS_GPIO=m
CONFIG_I2C_DESIGNWARE_CORE=y
CONFIG_I2C_DESIGNWARE_PLATFORM=m
CONFIG_I2C_DESIGNWARE_PCI=y
# CONFIG_I2C_EG20T is not set
CONFIG_I2C_GPIO=m
CONFIG_I2C_KEMPLD=m
# CONFIG_I2C_OCORES is not set
CONFIG_I2C_PCA_PLATFORM=y
# CONFIG_I2C_PXA_PCI is not set
# CONFIG_I2C_SIMTEC is not set
CONFIG_I2C_XILINX=y

#
# External I2C/SMBus adapter drivers
#
CONFIG_I2C_PARPORT_LIGHT=y
CONFIG_I2C_TAOS_EVM=y

#
# Other I2C/SMBus bus drivers
#
# CONFIG_SCx200_I2C is not set
CONFIG_SCx200_ACB=m
CONFIG_I2C_STUB=m
# CONFIG_I2C_DEBUG_CORE is not set
# CONFIG_I2C_DEBUG_ALGO is not set
# CONFIG_I2C_DEBUG_BUS is not set
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
CONFIG_PPS_CLIENT_KTIMER=m
CONFIG_PPS_CLIENT_LDISC=y
CONFIG_PPS_CLIENT_GPIO=m

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
CONFIG_GPIOLIB=y
CONFIG_GPIO_DEVRES=y
CONFIG_GPIO_ACPI=y
# CONFIG_DEBUG_GPIO is not set
CONFIG_GPIO_SYSFS=y
CONFIG_GPIO_GENERIC=m
CONFIG_GPIO_DA9052=y
CONFIG_GPIO_DA9055=y
CONFIG_GPIO_MAX730X=y

#
# Memory mapped GPIO drivers:
#
CONFIG_GPIO_GENERIC_PLATFORM=m
CONFIG_GPIO_IT8761E=y
CONFIG_GPIO_F7188X=y
# CONFIG_GPIO_SCH311X is not set
CONFIG_GPIO_TS5500=m
CONFIG_GPIO_SCH=m
CONFIG_GPIO_ICH=y
# CONFIG_GPIO_VX855 is not set
# CONFIG_GPIO_LYNXPOINT is not set

#
# I2C GPIO expanders:
#
CONFIG_GPIO_LP3943=m
CONFIG_GPIO_MAX7300=y
CONFIG_GPIO_MAX732X=m
CONFIG_GPIO_PCA953X=y
# CONFIG_GPIO_PCA953X_IRQ is not set
CONFIG_GPIO_PCF857X=y
CONFIG_GPIO_SX150X=y
# CONFIG_GPIO_TPS65912 is not set
# CONFIG_GPIO_TWL4030 is not set
# CONFIG_GPIO_WM831X is not set
CONFIG_GPIO_WM8350=m
# CONFIG_GPIO_WM8994 is not set
CONFIG_GPIO_ADP5520=y
CONFIG_GPIO_ADP5588=m

#
# PCI GPIO expanders:
#
CONFIG_GPIO_CS5535=m
CONFIG_GPIO_BT8XX=m
# CONFIG_GPIO_AMD8111 is not set
# CONFIG_GPIO_INTEL_MID is not set
CONFIG_GPIO_PCH=m
# CONFIG_GPIO_ML_IOH is not set
# CONFIG_GPIO_TIMBERDALE is not set
CONFIG_GPIO_RDC321X=m

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
CONFIG_GPIO_JANZ_TTL=m
CONFIG_GPIO_PALMAS=y
CONFIG_GPIO_TPS6586X=y

#
# USB GPIO expanders:
#
CONFIG_W1=m
# CONFIG_W1_CON is not set

#
# 1-wire Bus Masters
#
CONFIG_W1_MASTER_MATROX=m
CONFIG_W1_MASTER_DS2482=m
CONFIG_W1_MASTER_DS1WM=m
CONFIG_W1_MASTER_GPIO=m

#
# 1-wire Slaves
#
CONFIG_W1_SLAVE_THERM=m
CONFIG_W1_SLAVE_SMEM=m
# CONFIG_W1_SLAVE_DS2408 is not set
CONFIG_W1_SLAVE_DS2413=m
# CONFIG_W1_SLAVE_DS2423 is not set
# CONFIG_W1_SLAVE_DS2431 is not set
# CONFIG_W1_SLAVE_DS2433 is not set
# CONFIG_W1_SLAVE_DS2760 is not set
# CONFIG_W1_SLAVE_DS2780 is not set
CONFIG_W1_SLAVE_DS2781=m
CONFIG_W1_SLAVE_DS28E04=m
CONFIG_W1_SLAVE_BQ27000=m
CONFIG_POWER_SUPPLY=y
# CONFIG_POWER_SUPPLY_DEBUG is not set
CONFIG_PDA_POWER=y
CONFIG_WM831X_BACKUP=m
CONFIG_WM831X_POWER=y
CONFIG_WM8350_POWER=y
CONFIG_TEST_POWER=m
CONFIG_BATTERY_88PM860X=m
# CONFIG_BATTERY_DS2780 is not set
CONFIG_BATTERY_DS2781=m
CONFIG_BATTERY_DS2782=y
CONFIG_BATTERY_SBS=y
# CONFIG_BATTERY_BQ27x00 is not set
CONFIG_BATTERY_DA9030=y
CONFIG_BATTERY_DA9052=m
CONFIG_BATTERY_MAX17040=y
CONFIG_BATTERY_MAX17042=m
CONFIG_BATTERY_TWL4030_MADC=y
CONFIG_CHARGER_88PM860X=m
CONFIG_BATTERY_RX51=y
CONFIG_CHARGER_MAX8903=m
CONFIG_CHARGER_TWL4030=y
# CONFIG_CHARGER_LP8727 is not set
CONFIG_CHARGER_GPIO=m
# CONFIG_CHARGER_MAX14577 is not set
CONFIG_CHARGER_MAX8997=m
# CONFIG_CHARGER_BQ2415X is not set
CONFIG_CHARGER_BQ24190=y
CONFIG_CHARGER_BQ24735=y
CONFIG_CHARGER_SMB347=y
# CONFIG_CHARGER_TPS65090 is not set
# CONFIG_POWER_RESET is not set
# CONFIG_POWER_AVS is not set
CONFIG_HWMON=m
CONFIG_HWMON_VID=m
CONFIG_HWMON_DEBUG_CHIP=y

#
# Native drivers
#
CONFIG_SENSORS_ABITUGURU=m
# CONFIG_SENSORS_ABITUGURU3 is not set
# CONFIG_SENSORS_AD7414 is not set
CONFIG_SENSORS_AD7418=m
CONFIG_SENSORS_ADM1021=m
# CONFIG_SENSORS_ADM1025 is not set
# CONFIG_SENSORS_ADM1026 is not set
# CONFIG_SENSORS_ADM1029 is not set
# CONFIG_SENSORS_ADM1031 is not set
CONFIG_SENSORS_ADM9240=m
# CONFIG_SENSORS_ADT7410 is not set
CONFIG_SENSORS_ADT7411=m
CONFIG_SENSORS_ADT7462=m
CONFIG_SENSORS_ADT7470=m
# CONFIG_SENSORS_ADT7475 is not set
CONFIG_SENSORS_ASC7621=m
# CONFIG_SENSORS_K8TEMP is not set
CONFIG_SENSORS_K10TEMP=m
CONFIG_SENSORS_FAM15H_POWER=m
# CONFIG_SENSORS_ASB100 is not set
CONFIG_SENSORS_ATXP1=m
# CONFIG_SENSORS_DS620 is not set
# CONFIG_SENSORS_DS1621 is not set
CONFIG_SENSORS_DA9052_ADC=m
# CONFIG_SENSORS_DA9055 is not set
# CONFIG_SENSORS_I5K_AMB is not set
CONFIG_SENSORS_F71805F=m
CONFIG_SENSORS_F71882FG=m
# CONFIG_SENSORS_F75375S is not set
CONFIG_SENSORS_FSCHMD=m
CONFIG_SENSORS_G760A=m
CONFIG_SENSORS_G762=m
CONFIG_SENSORS_GL518SM=m
CONFIG_SENSORS_GL520SM=m
# CONFIG_SENSORS_GPIO_FAN is not set
CONFIG_SENSORS_HIH6130=m
CONFIG_SENSORS_HTU21=m
CONFIG_SENSORS_CORETEMP=m
CONFIG_SENSORS_IT87=m
# CONFIG_SENSORS_JC42 is not set
# CONFIG_SENSORS_LINEAGE is not set
CONFIG_SENSORS_LM63=m
CONFIG_SENSORS_LM73=m
# CONFIG_SENSORS_LM75 is not set
# CONFIG_SENSORS_LM77 is not set
# CONFIG_SENSORS_LM78 is not set
# CONFIG_SENSORS_LM80 is not set
CONFIG_SENSORS_LM83=m
CONFIG_SENSORS_LM85=m
CONFIG_SENSORS_LM87=m
# CONFIG_SENSORS_LM90 is not set
# CONFIG_SENSORS_LM92 is not set
# CONFIG_SENSORS_LM93 is not set
CONFIG_SENSORS_LTC4151=m
# CONFIG_SENSORS_LTC4215 is not set
# CONFIG_SENSORS_LTC4245 is not set
# CONFIG_SENSORS_LTC4261 is not set
# CONFIG_SENSORS_LM95234 is not set
CONFIG_SENSORS_LM95241=m
# CONFIG_SENSORS_LM95245 is not set
# CONFIG_SENSORS_MAX16065 is not set
CONFIG_SENSORS_MAX1619=m
CONFIG_SENSORS_MAX1668=m
CONFIG_SENSORS_MAX197=m
# CONFIG_SENSORS_MAX6639 is not set
# CONFIG_SENSORS_MAX6642 is not set
# CONFIG_SENSORS_MAX6650 is not set
# CONFIG_SENSORS_MAX6697 is not set
CONFIG_SENSORS_MCP3021=m
# CONFIG_SENSORS_NCT6775 is not set
CONFIG_SENSORS_NTC_THERMISTOR=m
CONFIG_SENSORS_PC87360=m
CONFIG_SENSORS_PC87427=m
CONFIG_SENSORS_PCF8591=m
CONFIG_PMBUS=m
# CONFIG_SENSORS_PMBUS is not set
# CONFIG_SENSORS_ADM1275 is not set
CONFIG_SENSORS_LM25066=m
CONFIG_SENSORS_LTC2978=m
CONFIG_SENSORS_MAX16064=m
# CONFIG_SENSORS_MAX34440 is not set
# CONFIG_SENSORS_MAX8688 is not set
# CONFIG_SENSORS_UCD9000 is not set
CONFIG_SENSORS_UCD9200=m
# CONFIG_SENSORS_ZL6100 is not set
# CONFIG_SENSORS_SHT15 is not set
CONFIG_SENSORS_SHT21=m
CONFIG_SENSORS_SIS5595=m
# CONFIG_SENSORS_SMM665 is not set
# CONFIG_SENSORS_DME1737 is not set
CONFIG_SENSORS_EMC1403=m
CONFIG_SENSORS_EMC2103=m
CONFIG_SENSORS_EMC6W201=m
CONFIG_SENSORS_SMSC47M1=m
CONFIG_SENSORS_SMSC47M192=m
CONFIG_SENSORS_SMSC47B397=m
# CONFIG_SENSORS_SCH56XX_COMMON is not set
CONFIG_SENSORS_ADS1015=m
# CONFIG_SENSORS_ADS7828 is not set
# CONFIG_SENSORS_AMC6821 is not set
CONFIG_SENSORS_INA209=m
# CONFIG_SENSORS_INA2XX is not set
CONFIG_SENSORS_THMC50=m
# CONFIG_SENSORS_TMP102 is not set
CONFIG_SENSORS_TMP401=m
CONFIG_SENSORS_TMP421=m
CONFIG_SENSORS_TWL4030_MADC=m
CONFIG_SENSORS_VIA_CPUTEMP=m
# CONFIG_SENSORS_VIA686A is not set
CONFIG_SENSORS_VT1211=m
# CONFIG_SENSORS_VT8231 is not set
CONFIG_SENSORS_W83781D=m
CONFIG_SENSORS_W83791D=m
CONFIG_SENSORS_W83792D=m
# CONFIG_SENSORS_W83793 is not set
CONFIG_SENSORS_W83795=m
# CONFIG_SENSORS_W83795_FANCTRL is not set
CONFIG_SENSORS_W83L785TS=m
CONFIG_SENSORS_W83L786NG=m
# CONFIG_SENSORS_W83627HF is not set
CONFIG_SENSORS_W83627EHF=m
CONFIG_SENSORS_WM831X=m
CONFIG_SENSORS_WM8350=m
# CONFIG_SENSORS_APPLESMC is not set
# CONFIG_SENSORS_MC13783_ADC is not set

#
# ACPI drivers
#
# CONFIG_SENSORS_ACPI_POWER is not set
# CONFIG_SENSORS_ATK0110 is not set
CONFIG_THERMAL=y
# CONFIG_THERMAL_DEFAULT_GOV_STEP_WISE is not set
CONFIG_THERMAL_DEFAULT_GOV_FAIR_SHARE=y
# CONFIG_THERMAL_DEFAULT_GOV_USER_SPACE is not set
CONFIG_THERMAL_GOV_FAIR_SHARE=y
# CONFIG_THERMAL_GOV_STEP_WISE is not set
CONFIG_THERMAL_GOV_USER_SPACE=y
# CONFIG_THERMAL_EMULATION is not set
CONFIG_INTEL_POWERCLAMP=m
CONFIG_X86_PKG_TEMP_THERMAL=m
# CONFIG_ACPI_INT3403_THERMAL is not set

#
# Texas Instruments thermal drivers
#
# CONFIG_WATCHDOG is not set
CONFIG_SSB_POSSIBLE=y

#
# Sonics Silicon Backplane
#
CONFIG_SSB=m
CONFIG_SSB_SPROM=y
CONFIG_SSB_PCIHOST_POSSIBLE=y
CONFIG_SSB_PCIHOST=y
# CONFIG_SSB_B43_PCI_BRIDGE is not set
CONFIG_SSB_PCMCIAHOST_POSSIBLE=y
CONFIG_SSB_PCMCIAHOST=y
CONFIG_SSB_SDIOHOST_POSSIBLE=y
CONFIG_SSB_SDIOHOST=y
CONFIG_SSB_SILENT=y
CONFIG_SSB_DRIVER_PCICORE_POSSIBLE=y
# CONFIG_SSB_DRIVER_PCICORE is not set
CONFIG_SSB_DRIVER_GPIO=y
CONFIG_BCMA_POSSIBLE=y

#
# Broadcom specific AMBA
#
# CONFIG_BCMA is not set

#
# Multifunction device drivers
#
CONFIG_MFD_CORE=y
CONFIG_MFD_CS5535=m
# CONFIG_MFD_AS3711 is not set
CONFIG_PMIC_ADP5520=y
CONFIG_MFD_AAT2870_CORE=y
# CONFIG_MFD_CROS_EC is not set
CONFIG_PMIC_DA903X=y
CONFIG_PMIC_DA9052=y
CONFIG_MFD_DA9052_I2C=y
CONFIG_MFD_DA9055=y
CONFIG_MFD_DA9063=y
CONFIG_MFD_MC13XXX=y
CONFIG_MFD_MC13XXX_I2C=y
CONFIG_HTC_PASIC3=m
# CONFIG_HTC_I2CPLD is not set
CONFIG_LPC_ICH=y
CONFIG_LPC_SCH=y
CONFIG_MFD_JANZ_CMODIO=m
CONFIG_MFD_KEMPLD=y
# CONFIG_MFD_88PM800 is not set
CONFIG_MFD_88PM805=m
CONFIG_MFD_88PM860X=y
CONFIG_MFD_MAX14577=y
# CONFIG_MFD_MAX77686 is not set
# CONFIG_MFD_MAX77693 is not set
# CONFIG_MFD_MAX8907 is not set
# CONFIG_MFD_MAX8925 is not set
CONFIG_MFD_MAX8997=y
# CONFIG_MFD_MAX8998 is not set
CONFIG_MFD_RETU=y
# CONFIG_MFD_PCF50633 is not set
CONFIG_MFD_RDC321X=y
CONFIG_MFD_RTSX_PCI=m
# CONFIG_MFD_RC5T583 is not set
CONFIG_MFD_SEC_CORE=y
CONFIG_MFD_SI476X_CORE=m
CONFIG_MFD_SM501=y
CONFIG_MFD_SM501_GPIO=y
CONFIG_MFD_SMSC=y
# CONFIG_ABX500_CORE is not set
# CONFIG_MFD_STMPE is not set
CONFIG_MFD_SYSCON=y
CONFIG_MFD_TI_AM335X_TSCADC=m
CONFIG_MFD_LP3943=m
# CONFIG_MFD_LP8788 is not set
CONFIG_MFD_PALMAS=y
# CONFIG_TPS6105X is not set
# CONFIG_TPS65010 is not set
CONFIG_TPS6507X=y
CONFIG_MFD_TPS65090=y
CONFIG_MFD_TPS65217=y
CONFIG_MFD_TPS6586X=y
# CONFIG_MFD_TPS65910 is not set
CONFIG_MFD_TPS65912=y
CONFIG_MFD_TPS65912_I2C=y
CONFIG_MFD_TPS80031=y
CONFIG_TWL4030_CORE=y
CONFIG_TWL4030_MADC=y
CONFIG_MFD_TWL4030_AUDIO=y
# CONFIG_TWL6040_CORE is not set
# CONFIG_MFD_WL1273_CORE is not set
# CONFIG_MFD_LM3533 is not set
CONFIG_MFD_TIMBERDALE=y
# CONFIG_MFD_TC3589X is not set
# CONFIG_MFD_TMIO is not set
CONFIG_MFD_VX855=m
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
# CONFIG_REGULATOR_VIRTUAL_CONSUMER is not set
# CONFIG_REGULATOR_USERSPACE_CONSUMER is not set
CONFIG_REGULATOR_88PM8607=y
CONFIG_REGULATOR_ACT8865=m
CONFIG_REGULATOR_AD5398=y
CONFIG_REGULATOR_ANATOP=m
CONFIG_REGULATOR_AAT2870=m
# CONFIG_REGULATOR_DA903X is not set
CONFIG_REGULATOR_DA9052=y
# CONFIG_REGULATOR_DA9055 is not set
CONFIG_REGULATOR_DA9063=m
CONFIG_REGULATOR_DA9210=y
# CONFIG_REGULATOR_FAN53555 is not set
# CONFIG_REGULATOR_GPIO is not set
CONFIG_REGULATOR_ISL6271A=y
# CONFIG_REGULATOR_LP3971 is not set
CONFIG_REGULATOR_LP3972=y
CONFIG_REGULATOR_LP872X=m
CONFIG_REGULATOR_LP8755=y
CONFIG_REGULATOR_MAX14577=y
CONFIG_REGULATOR_MAX1586=m
CONFIG_REGULATOR_MAX8649=y
CONFIG_REGULATOR_MAX8660=m
# CONFIG_REGULATOR_MAX8952 is not set
CONFIG_REGULATOR_MAX8973=m
CONFIG_REGULATOR_MAX8997=m
CONFIG_REGULATOR_MC13XXX_CORE=y
CONFIG_REGULATOR_MC13783=y
# CONFIG_REGULATOR_MC13892 is not set
CONFIG_REGULATOR_PALMAS=m
CONFIG_REGULATOR_PFUZE100=m
CONFIG_REGULATOR_S2MPS11=m
CONFIG_REGULATOR_S5M8767=y
CONFIG_REGULATOR_TPS51632=m
CONFIG_REGULATOR_TPS62360=m
CONFIG_REGULATOR_TPS65023=m
CONFIG_REGULATOR_TPS6507X=y
# CONFIG_REGULATOR_TPS65090 is not set
CONFIG_REGULATOR_TPS65217=m
CONFIG_REGULATOR_TPS6586X=m
CONFIG_REGULATOR_TPS65912=m
CONFIG_REGULATOR_TPS80031=m
CONFIG_REGULATOR_TWL4030=m
CONFIG_REGULATOR_WM831X=y
# CONFIG_REGULATOR_WM8350 is not set
CONFIG_REGULATOR_WM8400=y
CONFIG_REGULATOR_WM8994=m
CONFIG_MEDIA_SUPPORT=y

#
# Multimedia core support
#
CONFIG_MEDIA_CAMERA_SUPPORT=y
CONFIG_MEDIA_ANALOG_TV_SUPPORT=y
# CONFIG_MEDIA_DIGITAL_TV_SUPPORT is not set
CONFIG_MEDIA_RADIO_SUPPORT=y
CONFIG_MEDIA_RC_SUPPORT=y
# CONFIG_MEDIA_CONTROLLER is not set
CONFIG_VIDEO_DEV=y
CONFIG_VIDEO_V4L2=y
# CONFIG_VIDEO_ADV_DEBUG is not set
# CONFIG_VIDEO_FIXED_MINOR_RANGES is not set
CONFIG_VIDEOBUF2_CORE=m
CONFIG_VIDEOBUF2_MEMOPS=m
CONFIG_VIDEOBUF2_VMALLOC=m
# CONFIG_TTPCI_EEPROM is not set

#
# Media drivers
#
CONFIG_RC_CORE=y
CONFIG_RC_MAP=m
# CONFIG_RC_DECODERS is not set
# CONFIG_RC_DEVICES is not set
# CONFIG_MEDIA_PCI_SUPPORT is not set
# CONFIG_V4L_PLATFORM_DRIVERS is not set
# CONFIG_V4L_MEM2MEM_DRIVERS is not set
CONFIG_V4L_TEST_DRIVERS=y
CONFIG_VIDEO_VIVI=m
# CONFIG_VIDEO_MEM2MEM_TESTDEV is not set

#
# Supported MMC/SDIO adapters
#
CONFIG_RADIO_ADAPTERS=y
CONFIG_RADIO_SI470X=y
# CONFIG_I2C_SI470X is not set
# CONFIG_RADIO_SI4713 is not set
# CONFIG_RADIO_SI476X is not set
# CONFIG_RADIO_MAXIRADIO is not set
CONFIG_RADIO_TEA5764=m
CONFIG_RADIO_SAA7706H=y
CONFIG_RADIO_TEF6862=y
# CONFIG_RADIO_TIMBERDALE is not set
# CONFIG_RADIO_WL1273 is not set

#
# Texas Instruments WL128x FM driver (ST based)
#
# CONFIG_RADIO_WL128X is not set

#
# Media ancillary drivers (tuners, sensors, i2c, frontends)
#
CONFIG_MEDIA_SUBDRV_AUTOSELECT=y
CONFIG_MEDIA_ATTACH=y
CONFIG_VIDEO_IR_I2C=y

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
# Audio/Video compression chips
#

#
# Miscellaneous helper chips
#

#
# Sensors used on soc_camera driver
#
CONFIG_MEDIA_TUNER=y
CONFIG_MEDIA_TUNER_SIMPLE=y
CONFIG_MEDIA_TUNER_TDA8290=y
CONFIG_MEDIA_TUNER_TDA827X=y
CONFIG_MEDIA_TUNER_TDA18271=y
CONFIG_MEDIA_TUNER_TDA9887=y
CONFIG_MEDIA_TUNER_TEA5761=y
CONFIG_MEDIA_TUNER_TEA5767=y
CONFIG_MEDIA_TUNER_MT20XX=y
CONFIG_MEDIA_TUNER_XC2028=y
CONFIG_MEDIA_TUNER_XC5000=y
CONFIG_MEDIA_TUNER_XC4000=y
CONFIG_MEDIA_TUNER_MC44S803=y

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
# CONFIG_AGP_AMD is not set
CONFIG_AGP_AMD64=y
# CONFIG_AGP_INTEL is not set
CONFIG_AGP_NVIDIA=y
CONFIG_AGP_SIS=m
CONFIG_AGP_SWORKS=y
CONFIG_AGP_VIA=y
CONFIG_AGP_EFFICEON=m
# CONFIG_VGA_ARB is not set
# CONFIG_VGA_SWITCHEROO is not set
CONFIG_DRM=m
CONFIG_DRM_KMS_HELPER=m
CONFIG_DRM_KMS_FB_HELPER=y
# CONFIG_DRM_LOAD_EDID_FIRMWARE is not set
CONFIG_DRM_TTM=m

#
# I2C encoder or helper chips
#
CONFIG_DRM_I2C_CH7006=m
# CONFIG_DRM_I2C_SIL164 is not set
# CONFIG_DRM_I2C_NXP_TDA998X is not set
# CONFIG_DRM_TDFX is not set
CONFIG_DRM_R128=m
# CONFIG_DRM_RADEON is not set
CONFIG_DRM_NOUVEAU=m
CONFIG_NOUVEAU_DEBUG=5
CONFIG_NOUVEAU_DEBUG_DEFAULT=3
CONFIG_DRM_NOUVEAU_BACKLIGHT=y
# CONFIG_DRM_I915 is not set
CONFIG_DRM_MGA=m
CONFIG_DRM_SIS=m
CONFIG_DRM_VIA=m
CONFIG_DRM_SAVAGE=m
CONFIG_DRM_VMWGFX=m
CONFIG_DRM_VMWGFX_FBCON=y
# CONFIG_DRM_GMA500 is not set
# CONFIG_DRM_UDL is not set
CONFIG_DRM_AST=m
# CONFIG_DRM_MGAG200 is not set
CONFIG_DRM_CIRRUS_QEMU=m
CONFIG_DRM_QXL=m
# CONFIG_DRM_BOCHS is not set
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
# CONFIG_FB_BOTH_ENDIAN is not set
# CONFIG_FB_BIG_ENDIAN is not set
CONFIG_FB_LITTLE_ENDIAN=y
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
# CONFIG_FB_PM2 is not set
CONFIG_FB_CYBER2000=m
# CONFIG_FB_CYBER2000_DDC is not set
CONFIG_FB_ARC=m
# CONFIG_FB_VGA16 is not set
# CONFIG_FB_UVESA is not set
CONFIG_FB_N411=m
CONFIG_FB_HGA=m
# CONFIG_FB_OPENCORES is not set
# CONFIG_FB_S1D13XXX is not set
CONFIG_FB_NVIDIA=m
# CONFIG_FB_NVIDIA_I2C is not set
# CONFIG_FB_NVIDIA_DEBUG is not set
CONFIG_FB_NVIDIA_BACKLIGHT=y
CONFIG_FB_RIVA=m
# CONFIG_FB_RIVA_I2C is not set
# CONFIG_FB_RIVA_DEBUG is not set
CONFIG_FB_RIVA_BACKLIGHT=y
# CONFIG_FB_I740 is not set
# CONFIG_FB_LE80578 is not set
CONFIG_FB_MATROX=m
# CONFIG_FB_MATROX_MILLENIUM is not set
# CONFIG_FB_MATROX_MYSTIQUE is not set
CONFIG_FB_MATROX_G=y
# CONFIG_FB_MATROX_I2C is not set
CONFIG_FB_RADEON=m
# CONFIG_FB_RADEON_I2C is not set
# CONFIG_FB_RADEON_BACKLIGHT is not set
# CONFIG_FB_RADEON_DEBUG is not set
# CONFIG_FB_ATY128 is not set
CONFIG_FB_ATY=m
CONFIG_FB_ATY_CT=y
CONFIG_FB_ATY_GENERIC_LCD=y
CONFIG_FB_ATY_GX=y
# CONFIG_FB_ATY_BACKLIGHT is not set
CONFIG_FB_S3=m
CONFIG_FB_S3_DDC=y
# CONFIG_FB_SAVAGE is not set
CONFIG_FB_SIS=m
CONFIG_FB_SIS_300=y
# CONFIG_FB_SIS_315 is not set
CONFIG_FB_VIA=m
CONFIG_FB_VIA_DIRECT_PROCFS=y
# CONFIG_FB_VIA_X_COMPATIBILITY is not set
CONFIG_FB_NEOMAGIC=m
CONFIG_FB_KYRO=m
# CONFIG_FB_3DFX is not set
# CONFIG_FB_VOODOO1 is not set
CONFIG_FB_VT8623=m
CONFIG_FB_TRIDENT=m
# CONFIG_FB_ARK is not set
CONFIG_FB_PM3=m
CONFIG_FB_CARMINE=m
CONFIG_FB_CARMINE_DRAM_EVAL=y
# CONFIG_CARMINE_DRAM_CUSTOM is not set
CONFIG_FB_GEODE=y
CONFIG_FB_GEODE_LX=m
CONFIG_FB_GEODE_GX=m
CONFIG_FB_GEODE_GX1=m
CONFIG_FB_TMIO=m
CONFIG_FB_TMIO_ACCELL=y
# CONFIG_FB_SM501 is not set
# CONFIG_FB_GOLDFISH is not set
# CONFIG_FB_VIRTUAL is not set
CONFIG_FB_METRONOME=m
CONFIG_FB_MB862XX=m
CONFIG_FB_MB862XX_PCI_GDC=y
CONFIG_FB_MB862XX_I2C=y
# CONFIG_FB_BROADSHEET is not set
CONFIG_FB_AUO_K190X=m
# CONFIG_FB_AUO_K1900 is not set
CONFIG_FB_AUO_K1901=m
CONFIG_EXYNOS_VIDEO=y
CONFIG_BACKLIGHT_LCD_SUPPORT=y
CONFIG_LCD_CLASS_DEVICE=y
# CONFIG_LCD_PLATFORM is not set
CONFIG_BACKLIGHT_CLASS_DEVICE=m
CONFIG_BACKLIGHT_GENERIC=m
CONFIG_BACKLIGHT_DA903X=m
# CONFIG_BACKLIGHT_DA9052 is not set
# CONFIG_BACKLIGHT_APPLE is not set
CONFIG_BACKLIGHT_SAHARA=m
CONFIG_BACKLIGHT_WM831X=m
CONFIG_BACKLIGHT_ADP5520=m
# CONFIG_BACKLIGHT_ADP8860 is not set
# CONFIG_BACKLIGHT_ADP8870 is not set
CONFIG_BACKLIGHT_88PM860X=m
# CONFIG_BACKLIGHT_AAT2870 is not set
CONFIG_BACKLIGHT_LM3630A=m
CONFIG_BACKLIGHT_LM3639=m
CONFIG_BACKLIGHT_LP855X=m
CONFIG_BACKLIGHT_OT200=m
CONFIG_BACKLIGHT_PANDORA=m
CONFIG_BACKLIGHT_TPS65217=m
CONFIG_BACKLIGHT_GPIO=m
# CONFIG_BACKLIGHT_LV5207LP is not set
CONFIG_BACKLIGHT_BD6107=m
# CONFIG_LOGO is not set
CONFIG_SOUND=m
CONFIG_SOUND_OSS_CORE=y
CONFIG_SOUND_OSS_CORE_PRECLAIM=y
CONFIG_SND=m
CONFIG_SND_TIMER=m
CONFIG_SND_PCM=m
CONFIG_SND_COMPRESS_OFFLOAD=m
CONFIG_SND_JACK=y
CONFIG_SND_SEQUENCER=m
CONFIG_SND_SEQ_DUMMY=m
CONFIG_SND_OSSEMUL=y
CONFIG_SND_MIXER_OSS=m
CONFIG_SND_PCM_OSS=m
# CONFIG_SND_PCM_OSS_PLUGINS is not set
# CONFIG_SND_SEQUENCER_OSS is not set
CONFIG_SND_HRTIMER=m
# CONFIG_SND_SEQ_HRTIMER_DEFAULT is not set
# CONFIG_SND_DYNAMIC_MINORS is not set
# CONFIG_SND_SUPPORT_OLD_API is not set
CONFIG_SND_VERBOSE_PROCFS=y
# CONFIG_SND_VERBOSE_PRINTK is not set
# CONFIG_SND_DEBUG is not set
CONFIG_SND_DMA_SGBUF=y
# CONFIG_SND_RAWMIDI_SEQ is not set
# CONFIG_SND_OPL3_LIB_SEQ is not set
# CONFIG_SND_OPL4_LIB_SEQ is not set
# CONFIG_SND_SBAWE_SEQ is not set
# CONFIG_SND_EMU10K1_SEQ is not set
# CONFIG_SND_DRIVERS is not set
# CONFIG_SND_PCI is not set
# CONFIG_SND_FIREWIRE is not set
# CONFIG_SND_PCMCIA is not set
CONFIG_SND_SOC=m
CONFIG_SND_ATMEL_SOC=m
CONFIG_SND_SOC_I2C_AND_SPI=m
# CONFIG_SND_SIMPLE_CARD is not set
CONFIG_SOUND_PRIME=m
# CONFIG_SOUND_OSS is not set

#
# HID support
#
CONFIG_HID=m
CONFIG_HIDRAW=y
# CONFIG_UHID is not set
CONFIG_HID_GENERIC=m

#
# Special HID drivers
#
CONFIG_HID_A4TECH=m
# CONFIG_HID_ACRUX is not set
# CONFIG_HID_APPLE is not set
# CONFIG_HID_AUREAL is not set
# CONFIG_HID_BELKIN is not set
# CONFIG_HID_CHERRY is not set
# CONFIG_HID_CHICONY is not set
# CONFIG_HID_PRODIKEYS is not set
# CONFIG_HID_CYPRESS is not set
CONFIG_HID_DRAGONRISE=m
# CONFIG_DRAGONRISE_FF is not set
# CONFIG_HID_EMS_FF is not set
# CONFIG_HID_ELECOM is not set
CONFIG_HID_EZKEY=m
# CONFIG_HID_KEYTOUCH is not set
# CONFIG_HID_KYE is not set
# CONFIG_HID_UCLOGIC is not set
CONFIG_HID_WALTOP=m
# CONFIG_HID_GYRATION is not set
# CONFIG_HID_ICADE is not set
CONFIG_HID_TWINHAN=m
CONFIG_HID_KENSINGTON=m
CONFIG_HID_LCPOWER=m
CONFIG_HID_LENOVO_TPKBD=m
CONFIG_HID_LOGITECH=m
CONFIG_HID_LOGITECH_DJ=m
# CONFIG_LOGITECH_FF is not set
# CONFIG_LOGIRUMBLEPAD2_FF is not set
# CONFIG_LOGIG940_FF is not set
# CONFIG_LOGIWHEELS_FF is not set
CONFIG_HID_MAGICMOUSE=m
# CONFIG_HID_MICROSOFT is not set
# CONFIG_HID_MONTEREY is not set
# CONFIG_HID_MULTITOUCH is not set
CONFIG_HID_ORTEK=m
CONFIG_HID_PANTHERLORD=m
CONFIG_PANTHERLORD_FF=y
CONFIG_HID_PETALYNX=m
CONFIG_HID_PICOLCD=m
CONFIG_HID_PICOLCD_FB=y
CONFIG_HID_PICOLCD_BACKLIGHT=y
# CONFIG_HID_PICOLCD_LCD is not set
CONFIG_HID_PICOLCD_LEDS=y
# CONFIG_HID_PICOLCD_CIR is not set
# CONFIG_HID_PRIMAX is not set
CONFIG_HID_SAITEK=m
CONFIG_HID_SAMSUNG=m
CONFIG_HID_SPEEDLINK=m
CONFIG_HID_STEELSERIES=m
# CONFIG_HID_SUNPLUS is not set
# CONFIG_HID_GREENASIA is not set
# CONFIG_HID_SMARTJOYPLUS is not set
CONFIG_HID_TIVO=m
# CONFIG_HID_TOPSEED is not set
# CONFIG_HID_THINGM is not set
CONFIG_HID_THRUSTMASTER=m
CONFIG_THRUSTMASTER_FF=y
# CONFIG_HID_WACOM is not set
CONFIG_HID_WIIMOTE=m
CONFIG_HID_XINMO=m
CONFIG_HID_ZEROPLUS=m
CONFIG_ZEROPLUS_FF=y
CONFIG_HID_ZYDACRON=m
CONFIG_HID_SENSOR_HUB=m

#
# I2C HID support
#
CONFIG_I2C_HID=m
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
# CONFIG_TAHVO_USB is not set
# CONFIG_USB_GADGET is not set
# CONFIG_UWB is not set
CONFIG_MMC=m
# CONFIG_MMC_DEBUG is not set
# CONFIG_MMC_UNSAFE_RESUME is not set
# CONFIG_MMC_CLKGATE is not set

#
# MMC/SD/SDIO Card Drivers
#
CONFIG_MMC_BLOCK=m
CONFIG_MMC_BLOCK_MINORS=8
# CONFIG_MMC_BLOCK_BOUNCE is not set
CONFIG_SDIO_UART=m
# CONFIG_MMC_TEST is not set

#
# MMC/SD/SDIO Host Controller Drivers
#
CONFIG_MMC_SDHCI=m
# CONFIG_MMC_SDHCI_PCI is not set
# CONFIG_MMC_SDHCI_ACPI is not set
CONFIG_MMC_SDHCI_PLTFM=m
# CONFIG_MMC_WBSD is not set
CONFIG_MMC_TIFM_SD=m
CONFIG_MMC_SDRICOH_CS=m
CONFIG_MMC_CB710=m
CONFIG_MMC_VIA_SDMMC=m
CONFIG_MMC_REALTEK_PCI=m
# CONFIG_MEMSTICK is not set
CONFIG_NEW_LEDS=y
CONFIG_LEDS_CLASS=y

#
# LED drivers
#
CONFIG_LEDS_88PM860X=y
CONFIG_LEDS_LM3530=y
# CONFIG_LEDS_LM3642 is not set
# CONFIG_LEDS_NET48XX is not set
CONFIG_LEDS_WRAP=m
CONFIG_LEDS_PCA9532=y
CONFIG_LEDS_PCA9532_GPIO=y
# CONFIG_LEDS_GPIO is not set
CONFIG_LEDS_LP3944=m
CONFIG_LEDS_LP55XX_COMMON=y
CONFIG_LEDS_LP5521=y
CONFIG_LEDS_LP5523=y
CONFIG_LEDS_LP5562=m
CONFIG_LEDS_LP8501=m
CONFIG_LEDS_CLEVO_MAIL=m
CONFIG_LEDS_PCA955X=y
CONFIG_LEDS_PCA963X=y
CONFIG_LEDS_PCA9685=y
CONFIG_LEDS_WM831X_STATUS=m
CONFIG_LEDS_WM8350=y
CONFIG_LEDS_DA903X=y
# CONFIG_LEDS_DA9052 is not set
CONFIG_LEDS_REGULATOR=y
# CONFIG_LEDS_BD2802 is not set
CONFIG_LEDS_INTEL_SS4200=y
CONFIG_LEDS_LT3593=y
CONFIG_LEDS_ADP5520=m
# CONFIG_LEDS_DELL_NETBOOKS is not set
CONFIG_LEDS_MC13783=m
CONFIG_LEDS_TCA6507=y
CONFIG_LEDS_MAX8997=y
CONFIG_LEDS_LM355x=m
# CONFIG_LEDS_OT200 is not set
CONFIG_LEDS_BLINKM=y

#
# LED Triggers
#
CONFIG_LEDS_TRIGGERS=y
# CONFIG_LEDS_TRIGGER_TIMER is not set
CONFIG_LEDS_TRIGGER_ONESHOT=m
# CONFIG_LEDS_TRIGGER_IDE_DISK is not set
CONFIG_LEDS_TRIGGER_HEARTBEAT=y
CONFIG_LEDS_TRIGGER_BACKLIGHT=m
# CONFIG_LEDS_TRIGGER_CPU is not set
CONFIG_LEDS_TRIGGER_GPIO=m
# CONFIG_LEDS_TRIGGER_DEFAULT_ON is not set

#
# iptables trigger is under Netfilter config (LED target)
#
# CONFIG_LEDS_TRIGGER_TRANSIENT is not set
CONFIG_LEDS_TRIGGER_CAMERA=m
# CONFIG_ACCESSIBILITY is not set
CONFIG_INFINIBAND=y
CONFIG_INFINIBAND_USER_MAD=m
CONFIG_INFINIBAND_USER_ACCESS=y
CONFIG_INFINIBAND_USER_MEM=y
CONFIG_INFINIBAND_ADDR_TRANS=y
# CONFIG_INFINIBAND_MTHCA is not set
CONFIG_INFINIBAND_AMSO1100=m
CONFIG_INFINIBAND_AMSO1100_DEBUG=y
# CONFIG_INFINIBAND_NES is not set
CONFIG_INFINIBAND_SRP=y
CONFIG_INFINIBAND_SRPT=m
CONFIG_INFINIBAND_ISER=y
# CONFIG_INFINIBAND_ISERT is not set
CONFIG_EDAC=y
CONFIG_EDAC_LEGACY_SYSFS=y
# CONFIG_EDAC_DEBUG is not set
CONFIG_EDAC_DECODE_MCE=m
CONFIG_EDAC_MCE_INJ=m
CONFIG_EDAC_MM_EDAC=m
# CONFIG_EDAC_AMD76X is not set
# CONFIG_EDAC_E7XXX is not set
CONFIG_EDAC_E752X=m
CONFIG_EDAC_I82875P=m
# CONFIG_EDAC_I82975X is not set
CONFIG_EDAC_I3000=m
CONFIG_EDAC_I3200=m
# CONFIG_EDAC_X38 is not set
CONFIG_EDAC_I5400=m
# CONFIG_EDAC_I7CORE is not set
CONFIG_EDAC_I82860=m
# CONFIG_EDAC_R82600 is not set
CONFIG_EDAC_I5000=m
CONFIG_EDAC_I5100=m
CONFIG_EDAC_I7300=m
CONFIG_RTC_LIB=y
# CONFIG_RTC_CLASS is not set
CONFIG_DMADEVICES=y
CONFIG_DMADEVICES_DEBUG=y
CONFIG_DMADEVICES_VDEBUG=y

#
# DMA Devices
#
CONFIG_INTEL_MID_DMAC=y
# CONFIG_INTEL_IOATDMA is not set
CONFIG_DW_DMAC_CORE=y
CONFIG_DW_DMAC=m
CONFIG_DW_DMAC_PCI=y
CONFIG_TIMB_DMA=y
# CONFIG_PCH_DMA is not set
CONFIG_DMA_ENGINE=y
CONFIG_DMA_ACPI=y

#
# DMA Clients
#
# CONFIG_ASYNC_TX_DMA is not set
CONFIG_DMATEST=m
CONFIG_AUXDISPLAY=y
CONFIG_UIO=y
CONFIG_UIO_CIF=m
# CONFIG_UIO_PDRV_GENIRQ is not set
CONFIG_UIO_DMEM_GENIRQ=y
CONFIG_UIO_AEC=m
CONFIG_UIO_SERCOS3=y
CONFIG_UIO_PCI_GENERIC=m
# CONFIG_UIO_NETX is not set
CONFIG_UIO_MF624=m
# CONFIG_VIRT_DRIVERS is not set
CONFIG_VIRTIO=y

#
# Virtio drivers
#
# CONFIG_VIRTIO_PCI is not set
# CONFIG_VIRTIO_BALLOON is not set
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
# CONFIG_DELL_WMI is not set
# CONFIG_DELL_WMI_AIO is not set
# CONFIG_FUJITSU_LAPTOP is not set
# CONFIG_FUJITSU_TABLET is not set
CONFIG_AMILO_RFKILL=m
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
CONFIG_ACPI_WMI=m
# CONFIG_MSI_WMI is not set
# CONFIG_TOPSTAR_LAPTOP is not set
# CONFIG_ACPI_TOSHIBA is not set
# CONFIG_TOSHIBA_BT_RFKILL is not set
# CONFIG_ACPI_CMPC is not set
# CONFIG_INTEL_IPS is not set
# CONFIG_IBM_RTL is not set
# CONFIG_XO15_EBOOK is not set
# CONFIG_SAMSUNG_LAPTOP is not set
CONFIG_MXM_WMI=m
# CONFIG_INTEL_OAKTRAIL is not set
# CONFIG_SAMSUNG_Q10 is not set
# CONFIG_APPLE_GMUX is not set
# CONFIG_INTEL_RST is not set
# CONFIG_INTEL_SMARTCONNECT is not set
# CONFIG_PVPANIC is not set
CONFIG_CHROME_PLATFORMS=y
# CONFIG_CHROMEOS_LAPTOP is not set
CONFIG_CHROMEOS_PSTORE=y

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
CONFIG_DEVFREQ_GOV_SIMPLE_ONDEMAND=m
CONFIG_DEVFREQ_GOV_PERFORMANCE=y
CONFIG_DEVFREQ_GOV_POWERSAVE=m
CONFIG_DEVFREQ_GOV_USERSPACE=m

#
# DEVFREQ Drivers
#
CONFIG_EXTCON=m

#
# Extcon Device Drivers
#
CONFIG_EXTCON_GPIO=m
CONFIG_EXTCON_MAX14577=m
CONFIG_EXTCON_MAX8997=m
CONFIG_EXTCON_PALMAS=m
CONFIG_MEMORY=y
# CONFIG_IIO is not set
# CONFIG_NTB is not set
# CONFIG_VME_BUS is not set
# CONFIG_PWM is not set
# CONFIG_IPACK_BUS is not set
# CONFIG_RESET_CONTROLLER is not set
# CONFIG_FMC is not set

#
# PHY Subsystem
#
CONFIG_GENERIC_PHY=y
CONFIG_PHY_EXYNOS_MIPI_VIDEO=m
CONFIG_BCM_KONA_USB2_PHY=m
CONFIG_POWERCAP=y
# CONFIG_INTEL_RAPL is not set

#
# Firmware Drivers
#
CONFIG_EDD=m
# CONFIG_EDD_OFF is not set
# CONFIG_FIRMWARE_MEMMAP is not set
CONFIG_DELL_RBU=y
# CONFIG_DCDBAS is not set
# CONFIG_DMIID is not set
CONFIG_DMI_SYSFS=y
CONFIG_DMI_SCAN_MACHINE_NON_EFI_FALLBACK=y
# CONFIG_ISCSI_IBFT_FIND is not set
# CONFIG_GOOGLE_FIRMWARE is not set

#
# File systems
#
CONFIG_DCACHE_WORD_ACCESS=y
CONFIG_EXT2_FS=y
CONFIG_EXT2_FS_XATTR=y
CONFIG_EXT2_FS_POSIX_ACL=y
CONFIG_EXT2_FS_SECURITY=y
CONFIG_EXT2_FS_XIP=y
# CONFIG_EXT3_FS is not set
# CONFIG_EXT4_FS is not set
CONFIG_FS_XIP=y
CONFIG_JBD2=m
CONFIG_JBD2_DEBUG=y
CONFIG_FS_MBCACHE=y
CONFIG_REISERFS_FS=m
# CONFIG_REISERFS_CHECK is not set
# CONFIG_REISERFS_PROC_INFO is not set
# CONFIG_REISERFS_FS_XATTR is not set
# CONFIG_JFS_FS is not set
# CONFIG_XFS_FS is not set
CONFIG_GFS2_FS=m
# CONFIG_GFS2_FS_LOCKING_DLM is not set
CONFIG_OCFS2_FS=m
# CONFIG_OCFS2_FS_O2CB is not set
# CONFIG_OCFS2_FS_USERSPACE_CLUSTER is not set
CONFIG_OCFS2_FS_STATS=y
CONFIG_OCFS2_DEBUG_MASKLOG=y
CONFIG_OCFS2_DEBUG_FS=y
# CONFIG_BTRFS_FS is not set
CONFIG_NILFS2_FS=y
CONFIG_FS_POSIX_ACL=y
CONFIG_EXPORTFS=y
CONFIG_FILE_LOCKING=y
CONFIG_FSNOTIFY=y
# CONFIG_DNOTIFY is not set
# CONFIG_INOTIFY_USER is not set
# CONFIG_FANOTIFY is not set
CONFIG_QUOTA=y
CONFIG_QUOTA_NETLINK_INTERFACE=y
# CONFIG_PRINT_QUOTA_WARNING is not set
CONFIG_QUOTA_DEBUG=y
CONFIG_QUOTA_TREE=y
# CONFIG_QFMT_V1 is not set
CONFIG_QFMT_V2=y
CONFIG_QUOTACTL=y
CONFIG_AUTOFS4_FS=m
CONFIG_FUSE_FS=y
# CONFIG_CUSE is not set

#
# Caches
#
CONFIG_FSCACHE=y
# CONFIG_FSCACHE_STATS is not set
CONFIG_FSCACHE_HISTOGRAM=y
CONFIG_FSCACHE_DEBUG=y
# CONFIG_FSCACHE_OBJECT_LIST is not set
CONFIG_CACHEFILES=y
# CONFIG_CACHEFILES_DEBUG is not set
CONFIG_CACHEFILES_HISTOGRAM=y

#
# CD-ROM/DVD Filesystems
#
CONFIG_ISO9660_FS=y
# CONFIG_JOLIET is not set
# CONFIG_ZISOFS is not set
CONFIG_UDF_FS=y
CONFIG_UDF_NLS=y

#
# DOS/FAT/NT Filesystems
#
CONFIG_FAT_FS=y
# CONFIG_MSDOS_FS is not set
CONFIG_VFAT_FS=y
CONFIG_FAT_DEFAULT_CODEPAGE=437
CONFIG_FAT_DEFAULT_IOCHARSET="iso8859-1"
CONFIG_NTFS_FS=y
# CONFIG_NTFS_DEBUG is not set
CONFIG_NTFS_RW=y

#
# Pseudo filesystems
#
CONFIG_PROC_FS=y
CONFIG_PROC_KCORE=y
# CONFIG_PROC_SYSCTL is not set
CONFIG_PROC_PAGE_MONITOR=y
CONFIG_SYSFS=y
CONFIG_TMPFS=y
CONFIG_TMPFS_POSIX_ACL=y
CONFIG_TMPFS_XATTR=y
CONFIG_HUGETLBFS=y
CONFIG_HUGETLB_PAGE=y
CONFIG_CONFIGFS_FS=y
CONFIG_MISC_FILESYSTEMS=y
# CONFIG_ADFS_FS is not set
CONFIG_AFFS_FS=m
CONFIG_ECRYPT_FS=y
CONFIG_ECRYPT_FS_MESSAGING=y
CONFIG_HFS_FS=y
CONFIG_HFSPLUS_FS=y
# CONFIG_HFSPLUS_FS_POSIX_ACL is not set
# CONFIG_BEFS_FS is not set
CONFIG_BFS_FS=m
CONFIG_EFS_FS=y
# CONFIG_JFFS2_FS is not set
# CONFIG_UBIFS_FS is not set
CONFIG_LOGFS=m
CONFIG_CRAMFS=m
CONFIG_SQUASHFS=m
CONFIG_SQUASHFS_FILE_CACHE=y
# CONFIG_SQUASHFS_FILE_DIRECT is not set
CONFIG_SQUASHFS_DECOMP_SINGLE=y
# CONFIG_SQUASHFS_DECOMP_MULTI is not set
# CONFIG_SQUASHFS_DECOMP_MULTI_PERCPU is not set
# CONFIG_SQUASHFS_XATTR is not set
# CONFIG_SQUASHFS_ZLIB is not set
# CONFIG_SQUASHFS_LZO is not set
# CONFIG_SQUASHFS_XZ is not set
CONFIG_SQUASHFS_4K_DEVBLK_SIZE=y
CONFIG_SQUASHFS_EMBEDDED=y
CONFIG_SQUASHFS_FRAGMENT_CACHE_SIZE=3
CONFIG_VXFS_FS=m
# CONFIG_MINIX_FS is not set
CONFIG_OMFS_FS=m
# CONFIG_HPFS_FS is not set
CONFIG_QNX4FS_FS=y
CONFIG_QNX6FS_FS=y
CONFIG_QNX6FS_DEBUG=y
# CONFIG_ROMFS_FS is not set
# CONFIG_PSTORE is not set
CONFIG_SYSV_FS=m
CONFIG_UFS_FS=y
CONFIG_UFS_FS_WRITE=y
# CONFIG_UFS_DEBUG is not set
CONFIG_EXOFS_FS=y
CONFIG_EXOFS_DEBUG=y
# CONFIG_F2FS_FS is not set
CONFIG_ORE=y
CONFIG_NETWORK_FILESYSTEMS=y
# CONFIG_NFS_FS is not set
CONFIG_NFSD=y
CONFIG_NFSD_V2_ACL=y
CONFIG_NFSD_V3=y
CONFIG_NFSD_V3_ACL=y
CONFIG_NFSD_V4=y
# CONFIG_NFSD_V4_SECURITY_LABEL is not set
CONFIG_NFSD_FAULT_INJECTION=y
CONFIG_LOCKD=y
CONFIG_LOCKD_V4=y
CONFIG_NFS_ACL_SUPPORT=y
CONFIG_NFS_COMMON=y
CONFIG_SUNRPC=y
CONFIG_SUNRPC_GSS=y
CONFIG_SUNRPC_XPRT_RDMA=y
CONFIG_RPCSEC_GSS_KRB5=m
CONFIG_CEPH_FS=m
# CONFIG_CEPH_FSCACHE is not set
# CONFIG_CEPH_FS_POSIX_ACL is not set
CONFIG_CIFS=y
# CONFIG_CIFS_STATS is not set
CONFIG_CIFS_WEAK_PW_HASH=y
# CONFIG_CIFS_UPCALL is not set
# CONFIG_CIFS_XATTR is not set
# CONFIG_CIFS_DEBUG is not set
# CONFIG_CIFS_DFS_UPCALL is not set
CONFIG_CIFS_SMB2=y
# CONFIG_CIFS_FSCACHE is not set
CONFIG_NCP_FS=y
CONFIG_NCPFS_PACKET_SIGNING=y
CONFIG_NCPFS_IOCTL_LOCKING=y
CONFIG_NCPFS_STRONG=y
# CONFIG_NCPFS_NFS_NS is not set
# CONFIG_NCPFS_OS2_NS is not set
# CONFIG_NCPFS_SMALLDOS is not set
# CONFIG_NCPFS_NLS is not set
# CONFIG_NCPFS_EXTRAS is not set
CONFIG_CODA_FS=y
CONFIG_AFS_FS=y
# CONFIG_AFS_DEBUG is not set
# CONFIG_AFS_FSCACHE is not set
CONFIG_9P_FS=m
# CONFIG_9P_FSCACHE is not set
CONFIG_9P_FS_POSIX_ACL=y
# CONFIG_9P_FS_SECURITY is not set
CONFIG_NLS=y
CONFIG_NLS_DEFAULT="iso8859-1"
CONFIG_NLS_CODEPAGE_437=y
CONFIG_NLS_CODEPAGE_737=y
# CONFIG_NLS_CODEPAGE_775 is not set
CONFIG_NLS_CODEPAGE_850=m
CONFIG_NLS_CODEPAGE_852=y
CONFIG_NLS_CODEPAGE_855=y
CONFIG_NLS_CODEPAGE_857=m
CONFIG_NLS_CODEPAGE_860=m
# CONFIG_NLS_CODEPAGE_861 is not set
CONFIG_NLS_CODEPAGE_862=m
CONFIG_NLS_CODEPAGE_863=y
CONFIG_NLS_CODEPAGE_864=m
CONFIG_NLS_CODEPAGE_865=y
CONFIG_NLS_CODEPAGE_866=m
CONFIG_NLS_CODEPAGE_869=m
CONFIG_NLS_CODEPAGE_936=m
CONFIG_NLS_CODEPAGE_950=y
# CONFIG_NLS_CODEPAGE_932 is not set
# CONFIG_NLS_CODEPAGE_949 is not set
# CONFIG_NLS_CODEPAGE_874 is not set
CONFIG_NLS_ISO8859_8=y
CONFIG_NLS_CODEPAGE_1250=m
# CONFIG_NLS_CODEPAGE_1251 is not set
CONFIG_NLS_ASCII=m
CONFIG_NLS_ISO8859_1=y
CONFIG_NLS_ISO8859_2=m
CONFIG_NLS_ISO8859_3=m
CONFIG_NLS_ISO8859_4=y
CONFIG_NLS_ISO8859_5=m
# CONFIG_NLS_ISO8859_6 is not set
# CONFIG_NLS_ISO8859_7 is not set
# CONFIG_NLS_ISO8859_9 is not set
CONFIG_NLS_ISO8859_13=m
CONFIG_NLS_ISO8859_14=m
CONFIG_NLS_ISO8859_15=y
CONFIG_NLS_KOI8_R=m
CONFIG_NLS_KOI8_U=y
CONFIG_NLS_MAC_ROMAN=m
CONFIG_NLS_MAC_CELTIC=m
CONFIG_NLS_MAC_CENTEURO=y
CONFIG_NLS_MAC_CROATIAN=y
# CONFIG_NLS_MAC_CYRILLIC is not set
# CONFIG_NLS_MAC_GAELIC is not set
CONFIG_NLS_MAC_GREEK=m
CONFIG_NLS_MAC_ICELAND=m
CONFIG_NLS_MAC_INUIT=m
# CONFIG_NLS_MAC_ROMANIAN is not set
# CONFIG_NLS_MAC_TURKISH is not set
CONFIG_NLS_UTF8=y
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
# CONFIG_DEBUG_INFO is not set
CONFIG_ENABLE_WARN_DEPRECATED=y
# CONFIG_ENABLE_MUST_CHECK is not set
CONFIG_FRAME_WARN=1024
# CONFIG_STRIP_ASM_SYMS is not set
CONFIG_READABLE_ASM=y
# CONFIG_UNUSED_SYMBOLS is not set
CONFIG_DEBUG_FS=y
CONFIG_HEADERS_CHECK=y
CONFIG_DEBUG_SECTION_MISMATCH=y
CONFIG_ARCH_WANT_FRAME_POINTERS=y
CONFIG_FRAME_POINTER=y
# CONFIG_DEBUG_FORCE_WEAK_PER_CPU is not set
CONFIG_MAGIC_SYSRQ=y
CONFIG_MAGIC_SYSRQ_DEFAULT_ENABLE=0x1
CONFIG_DEBUG_KERNEL=y

#
# Memory Debugging
#
CONFIG_DEBUG_PAGEALLOC=y
CONFIG_WANT_PAGE_DEBUG_FLAGS=y
CONFIG_PAGE_GUARD=y
CONFIG_DEBUG_OBJECTS=y
CONFIG_DEBUG_OBJECTS_SELFTEST=y
# CONFIG_DEBUG_OBJECTS_FREE is not set
# CONFIG_DEBUG_OBJECTS_TIMERS is not set
# CONFIG_DEBUG_OBJECTS_WORK is not set
CONFIG_DEBUG_OBJECTS_RCU_HEAD=y
# CONFIG_DEBUG_OBJECTS_PERCPU_COUNTER is not set
CONFIG_DEBUG_OBJECTS_ENABLE_DEFAULT=1
# CONFIG_DEBUG_SLAB is not set
CONFIG_HAVE_DEBUG_KMEMLEAK=y
# CONFIG_DEBUG_KMEMLEAK is not set
CONFIG_DEBUG_STACK_USAGE=y
# CONFIG_DEBUG_VM is not set
# CONFIG_DEBUG_VIRTUAL is not set
CONFIG_DEBUG_MEMORY_INIT=y
CONFIG_HAVE_DEBUG_STACKOVERFLOW=y
CONFIG_DEBUG_STACKOVERFLOW=y
CONFIG_HAVE_ARCH_KMEMCHECK=y
CONFIG_DEBUG_SHIRQ=y

#
# Debug Lockups and Hangs
#
# CONFIG_LOCKUP_DETECTOR is not set
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
CONFIG_DEBUG_PI_LIST=y
CONFIG_RT_MUTEX_TESTER=y
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
CONFIG_STACKTRACE=y
# CONFIG_DEBUG_KOBJECT is not set
CONFIG_DEBUG_BUGVERBOSE=y
# CONFIG_DEBUG_WRITECOUNT is not set
# CONFIG_DEBUG_LIST is not set
# CONFIG_DEBUG_SG is not set
# CONFIG_DEBUG_NOTIFIERS is not set
# CONFIG_DEBUG_CREDENTIALS is not set

#
# RCU Debugging
#
# CONFIG_SPARSE_RCU_POINTER is not set
# CONFIG_RCU_TORTURE_TEST is not set
CONFIG_RCU_CPU_STALL_TIMEOUT=21
CONFIG_RCU_TRACE=y
# CONFIG_DEBUG_BLOCK_EXT_DEVT is not set
# CONFIG_NOTIFIER_ERROR_INJECTION is not set
# CONFIG_FAULT_INJECTION is not set
CONFIG_LATENCYTOP=y
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
CONFIG_FUNCTION_TRACER=y
CONFIG_FUNCTION_GRAPH_TRACER=y
# CONFIG_IRQSOFF_TRACER is not set
# CONFIG_SCHED_TRACER is not set
CONFIG_FTRACE_SYSCALLS=y
CONFIG_TRACER_SNAPSHOT=y
CONFIG_TRACER_SNAPSHOT_PER_CPU_SWAP=y
CONFIG_TRACE_BRANCH_PROFILING=y
# CONFIG_BRANCH_PROFILE_NONE is not set
CONFIG_PROFILE_ANNOTATED_BRANCHES=y
# CONFIG_PROFILE_ALL_BRANCHES is not set
# CONFIG_BRANCH_TRACER is not set
CONFIG_STACK_TRACER=y
CONFIG_BLK_DEV_IO_TRACE=y
CONFIG_KPROBE_EVENT=y
CONFIG_UPROBE_EVENT=y
CONFIG_PROBE_EVENTS=y
CONFIG_DYNAMIC_FTRACE=y
CONFIG_DYNAMIC_FTRACE_WITH_REGS=y
# CONFIG_FUNCTION_PROFILER is not set
CONFIG_FTRACE_MCOUNT_RECORD=y
# CONFIG_FTRACE_STARTUP_TEST is not set
CONFIG_MMIOTRACE=y
# CONFIG_MMIOTRACE_TEST is not set
CONFIG_RING_BUFFER_BENCHMARK=y
# CONFIG_RING_BUFFER_STARTUP_TEST is not set

#
# Runtime Testing
#
# CONFIG_LKDTM is not set
CONFIG_TEST_LIST_SORT=y
CONFIG_KPROBES_SANITY_TEST=y
# CONFIG_BACKTRACE_SELF_TEST is not set
# CONFIG_RBTREE_TEST is not set
CONFIG_INTERVAL_TREE_TEST=m
# CONFIG_PERCPU_TEST is not set
CONFIG_ATOMIC64_SELFTEST=y
# CONFIG_TEST_STRING_HELPERS is not set
CONFIG_TEST_KSTRTOX=y
# CONFIG_PROVIDE_OHCI1394_DMA_INIT is not set
CONFIG_BUILD_DOCSRC=y
# CONFIG_DMA_API_DEBUG is not set
# CONFIG_TEST_MODULE is not set
# CONFIG_TEST_USER_COPY is not set
# CONFIG_SAMPLES is not set
CONFIG_HAVE_ARCH_KGDB=y
# CONFIG_KGDB is not set
# CONFIG_STRICT_DEVMEM is not set
CONFIG_X86_VERBOSE_BOOTUP=y
# CONFIG_EARLY_PRINTK is not set
# CONFIG_X86_PTDUMP is not set
# CONFIG_DEBUG_RODATA is not set
# CONFIG_DEBUG_SET_MODULE_RONX is not set
CONFIG_DEBUG_NX_TEST=m
# CONFIG_DOUBLEFAULT is not set
CONFIG_DEBUG_TLBFLUSH=y
CONFIG_IOMMU_STRESS=y
CONFIG_HAVE_MMIOTRACE_SUPPORT=y
# CONFIG_X86_DECODER_SELFTEST is not set
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
CONFIG_DEBUG_NMI_SELFTEST=y
CONFIG_X86_DEBUG_STATIC_CPU_HAS=y

#
# Security options
#
CONFIG_KEYS=y
CONFIG_PERSISTENT_KEYRINGS=y
# CONFIG_BIG_KEYS is not set
# CONFIG_TRUSTED_KEYS is not set
CONFIG_ENCRYPTED_KEYS=y
# CONFIG_KEYS_DEBUG_PROC_KEYS is not set
CONFIG_SECURITY_DMESG_RESTRICT=y
CONFIG_SECURITY=y
CONFIG_SECURITYFS=y
CONFIG_SECURITY_NETWORK=y
# CONFIG_SECURITY_NETWORK_XFRM is not set
CONFIG_SECURITY_PATH=y
# CONFIG_SECURITY_SELINUX is not set
# CONFIG_SECURITY_SMACK is not set
# CONFIG_SECURITY_TOMOYO is not set
CONFIG_SECURITY_APPARMOR=y
CONFIG_SECURITY_APPARMOR_BOOTPARAM_VALUE=1
# CONFIG_SECURITY_APPARMOR_HASH is not set
CONFIG_SECURITY_MNTRESTRICT=y
# CONFIG_SECURITY_YAMA is not set
CONFIG_INTEGRITY=y
CONFIG_INTEGRITY_SIGNATURE=y
# CONFIG_INTEGRITY_AUDIT is not set
CONFIG_INTEGRITY_ASYMMETRIC_KEYS=y
# CONFIG_IMA is not set
CONFIG_EVM=y
CONFIG_EVM_HMAC_VERSION=2
CONFIG_DEFAULT_SECURITY_APPARMOR=y
# CONFIG_DEFAULT_SECURITY_MNTRESTRICT is not set
# CONFIG_DEFAULT_SECURITY_DAC is not set
CONFIG_DEFAULT_SECURITY="apparmor"
CONFIG_XOR_BLOCKS=y
CONFIG_ASYNC_CORE=y
CONFIG_ASYNC_XOR=y
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
CONFIG_CRYPTO_NULL=m
CONFIG_CRYPTO_WORKQUEUE=y
CONFIG_CRYPTO_CRYPTD=m
CONFIG_CRYPTO_AUTHENC=y
CONFIG_CRYPTO_TEST=m
CONFIG_CRYPTO_ABLK_HELPER=m
CONFIG_CRYPTO_GLUE_HELPER_X86=m

#
# Authenticated Encryption with Associated Data
#
CONFIG_CRYPTO_CCM=m
CONFIG_CRYPTO_GCM=m
CONFIG_CRYPTO_SEQIV=m

#
# Block modes
#
CONFIG_CRYPTO_CBC=y
CONFIG_CRYPTO_CTR=m
CONFIG_CRYPTO_CTS=m
CONFIG_CRYPTO_ECB=y
CONFIG_CRYPTO_LRW=y
CONFIG_CRYPTO_PCBC=m
CONFIG_CRYPTO_XTS=m

#
# Hash modes
#
CONFIG_CRYPTO_CMAC=y
CONFIG_CRYPTO_HMAC=y
CONFIG_CRYPTO_XCBC=m
# CONFIG_CRYPTO_VMAC is not set

#
# Digest
#
CONFIG_CRYPTO_CRC32C=y
CONFIG_CRYPTO_CRC32C_INTEL=m
CONFIG_CRYPTO_CRC32=y
# CONFIG_CRYPTO_CRC32_PCLMUL is not set
CONFIG_CRYPTO_CRCT10DIF=y
CONFIG_CRYPTO_GHASH=y
CONFIG_CRYPTO_MD4=y
CONFIG_CRYPTO_MD5=y
# CONFIG_CRYPTO_MICHAEL_MIC is not set
CONFIG_CRYPTO_RMD128=y
CONFIG_CRYPTO_RMD160=y
CONFIG_CRYPTO_RMD256=y
# CONFIG_CRYPTO_RMD320 is not set
CONFIG_CRYPTO_SHA1=y
CONFIG_CRYPTO_SHA256=y
CONFIG_CRYPTO_SHA512=y
# CONFIG_CRYPTO_TGR192 is not set
CONFIG_CRYPTO_WP512=y

#
# Ciphers
#
CONFIG_CRYPTO_AES=y
# CONFIG_CRYPTO_AES_586 is not set
# CONFIG_CRYPTO_AES_NI_INTEL is not set
CONFIG_CRYPTO_ANUBIS=y
CONFIG_CRYPTO_ARC4=y
CONFIG_CRYPTO_BLOWFISH=m
CONFIG_CRYPTO_BLOWFISH_COMMON=m
# CONFIG_CRYPTO_CAMELLIA is not set
CONFIG_CRYPTO_CAST_COMMON=y
CONFIG_CRYPTO_CAST5=y
CONFIG_CRYPTO_CAST6=m
CONFIG_CRYPTO_DES=y
CONFIG_CRYPTO_FCRYPT=y
# CONFIG_CRYPTO_KHAZAD is not set
# CONFIG_CRYPTO_SALSA20 is not set
CONFIG_CRYPTO_SALSA20_586=y
CONFIG_CRYPTO_SEED=y
CONFIG_CRYPTO_SERPENT=m
CONFIG_CRYPTO_SERPENT_SSE2_586=m
# CONFIG_CRYPTO_TEA is not set
CONFIG_CRYPTO_TWOFISH=m
CONFIG_CRYPTO_TWOFISH_COMMON=y
CONFIG_CRYPTO_TWOFISH_586=y

#
# Compression
#
CONFIG_CRYPTO_DEFLATE=y
CONFIG_CRYPTO_ZLIB=y
CONFIG_CRYPTO_LZO=y
# CONFIG_CRYPTO_LZ4 is not set
CONFIG_CRYPTO_LZ4HC=y

#
# Random Number Generation
#
# CONFIG_CRYPTO_ANSI_CPRNG is not set
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
CONFIG_HAVE_KVM_IRQCHIP=y
CONFIG_HAVE_KVM_IRQ_ROUTING=y
CONFIG_HAVE_KVM_EVENTFD=y
CONFIG_KVM_APIC_ARCHITECTURE=y
CONFIG_KVM_MMIO=y
CONFIG_KVM_ASYNC_PF=y
CONFIG_HAVE_KVM_MSI=y
CONFIG_HAVE_KVM_CPU_RELAX_INTERCEPT=y
CONFIG_KVM_VFIO=y
CONFIG_VIRTUALIZATION=y
CONFIG_KVM=m
CONFIG_KVM_INTEL=m
# CONFIG_KVM_AMD is not set
CONFIG_KVM_MMU_AUDIT=y
# CONFIG_LGUEST is not set
CONFIG_BINARY_PRINTF=y

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
CONFIG_PERCPU_RWSEM=y
CONFIG_CRC_CCITT=y
CONFIG_CRC16=y
CONFIG_CRC_T10DIF=y
CONFIG_CRC_ITU_T=y
CONFIG_CRC32=y
CONFIG_CRC32_SELFTEST=y
# CONFIG_CRC32_SLICEBY8 is not set
# CONFIG_CRC32_SLICEBY4 is not set
CONFIG_CRC32_SARWATE=y
# CONFIG_CRC32_BIT is not set
# CONFIG_CRC7 is not set
CONFIG_LIBCRC32C=y
CONFIG_CRC8=m
CONFIG_AUDIT_GENERIC=y
# CONFIG_RANDOM32_SELFTEST is not set
CONFIG_ZLIB_INFLATE=y
CONFIG_ZLIB_DEFLATE=y
CONFIG_LZO_COMPRESS=y
CONFIG_LZO_DECOMPRESS=y
CONFIG_LZ4HC_COMPRESS=y
CONFIG_LZ4_DECOMPRESS=y
CONFIG_XZ_DEC=y
# CONFIG_XZ_DEC_X86 is not set
# CONFIG_XZ_DEC_POWERPC is not set
# CONFIG_XZ_DEC_IA64 is not set
# CONFIG_XZ_DEC_ARM is not set
CONFIG_XZ_DEC_ARMTHUMB=y
CONFIG_XZ_DEC_SPARC=y
CONFIG_XZ_DEC_BCJ=y
CONFIG_XZ_DEC_TEST=y
CONFIG_DECOMPRESS_GZIP=y
CONFIG_BTREE=y
CONFIG_ASSOCIATIVE_ARRAY=y
CONFIG_HAS_IOMEM=y
CONFIG_HAS_IOPORT=y
CONFIG_HAS_DMA=y
CONFIG_CHECK_SIGNATURE=y
CONFIG_DQL=y
CONFIG_NLATTR=y
CONFIG_ARCH_HAS_ATOMIC64_DEC_IF_POSITIVE=y
# CONFIG_AVERAGE is not set
CONFIG_CLZ_TAB=y
CONFIG_CORDIC=m
CONFIG_DDR=y
CONFIG_MPILIB=y
CONFIG_SIGNATURE=y
CONFIG_OID_REGISTRY=y
CONFIG_FONT_SUPPORT=m
CONFIG_FONT_8x16=y
CONFIG_FONT_AUTOSELECT=y

--HcAYCG3uE/tztfnV--
