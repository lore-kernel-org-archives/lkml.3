Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755314AbaI3H6I (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Sep 2014 03:58:08 -0400
Received: from mga03.intel.com ([134.134.136.65]:43836 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750988AbaI3H6F (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Sep 2014 03:58:05 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.04,625,1406617200"; 
   d="log'?scan'208";a="581099611"
Date: Tue, 30 Sep 2014 15:57:51 +0800
From: Fengguang Wu <fengguang.wu@intel.com>
To: Andy Lutomirski <luto@amacapital.net>
Cc: Jet Chen <jet.chen@intel.com>, Su Tao <tao.su@intel.com>,
        Yuanhan Liu <yuanhan.liu@intel.com>, LKP <lkp@01.org>,
        linux-kernel@vger.kernel.org, xen-devel@lists.xenproject.org
Subject: [x86_64,vsyscall] Kernel panic - not syncing: Attempted to kill
 init! exitcode=0x0000000b
Message-ID: <20140930075751.GB9561@wfg-t540p.sh.intel.com>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="St7VIuEGZ6dlpu13"
Content-Disposition: inline
User-Agent: Heirloom mailx 12.5 6/20/10
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--St7VIuEGZ6dlpu13
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi Andy,

0day kernel testing robot got the below dmesg and the first bad commit is

git://git.kernel.org/pub/scm/linux/kernel/git/luto/linux.git x86/vsyscall

commit caae204be184a575af2c02b837d818278f921323
Author:     Andy Lutomirski <luto@amacapital.net>
AuthorDate: Mon Jun 16 18:50:12 2014 -0700
Commit:     Andy Lutomirski <luto@amacapital.net>
CommitDate: Tue Sep 23 10:02:10 2014 -0700

    x86_64,vsyscall: Make vsyscall emulation configurable
    
    This adds CONFIG_X86_VSYSCALL_EMULATION, guarded by CONFIG_EXPERT.
    Turning it off completely disables vsyscall emulation, saving ~3.5k
    for vsyscall_64.c, 4k for vsyscall_emu_64.S (the fake vsyscall
    page), some tiny amount of core mm code that supports a gate area,
    and possibly 4k for a wasted pagetable.  The latter is because the
    vsyscall addresses are misaligned and fit poorly in the fixmap.
    
    Signed-off-by: Andy Lutomirski <luto@amacapital.net>

+-----------------------------------------------------------+------------+------------+------------------+
|                                                           | 2df87bdfa6 | caae204be1 | v3.17-rc6_092402 |
+-----------------------------------------------------------+------------+------------+------------------+
| boot_successes                                            | 156        | 27         | 47               |
| boot_failures                                             | 0          | 25         | 264              |
| Kernel_panic-not_syncing:Attempted_to_kill_init_exitcode= | 0          | 25         | 264              |
+-----------------------------------------------------------+------------+------------+------------------+

[    5.248382] input: AT Translated Set 2 keyboard as /devices/platform/i8042/serio0/input/input1
[    5.356741] init[1]: segfault at ffffffffff600400 ip ffffffffff600400 sp 00007fff5e2eecf8 error 15
[    5.357984] init[1]: segfault at ffffffffff600400 ip ffffffffff600400 sp 00007fff5e2ee1b8 error 15
[    5.359253] Kernel panic - not syncing: Attempted to kill init! exitcode=0x0000000b
[    5.359253] 
[    5.360439] CPU: 0 PID: 1 Comm: init Not tainted 3.17.0-rc1-00169-gcaae204 #1
[    5.361364] Hardware name: Bochs Bochs, BIOS Bochs 01/01/2011
[    5.362114]  0000000000000000 ffff88001284fcb0 ffffffff814a2ce5 ffff88001284fd30
[    5.363152]  ffffffff814a1c51 0000000000000010 ffff88001284fd40 ffff88001284fcd8
[    5.363611]  ffff88001284fd78 000000000000000b 0000000000000000 ffff880012848740
[    5.363611] Call Trace:
[    5.363611]  [<ffffffff814a2ce5>] dump_stack+0x19/0x1b
[    5.363611]  [<ffffffff814a1c51>] panic+0xc4/0x1ef
[    5.363611]  [<ffffffff81090d2c>] do_exit+0x3bb/0x81e
[    5.363611]  [<ffffffff811198c5>] ? __kmem_cache_free+0x11/0x2e
[    5.363611]  [<ffffffff8111992c>] ? kmem_cache_free+0x31/0x33
[    5.363611]  [<ffffffff810962eb>] ? __sigqueue_free+0x33/0x36
[    5.363611]  [<ffffffff81091e90>] do_group_exit+0x45/0xbf
[    5.363611]  [<ffffffff81098df9>] get_signal+0x53d/0x568
[    5.363611]  [<ffffffff81043039>] ? bad_area_nosemaphore+0xe/0x10
[    5.363611]  [<ffffffff81028218>] do_signal+0x23/0x885
[    5.363611]  [<ffffffff814a0000>] ? free_area_init_node+0xac/0x36e
[    5.363611]  [<ffffffff81028a96>] do_notify_resume+0x1c/0x75
[    5.363611]  [<ffffffff814a927b>] retint_signal+0x48/0x8d
[    5.363611] Kernel Offset: 0x0 from 0xffffffff81000000 (relocation range: 0xffffffff80000000-0xffffffff9fffffff)

Elapsed time: 10

git bisect start ddc5057b07ef7126431d5df5f5b176154896f560 0f33be009b89d2268e94194dc4fd01a7851b6d51 --
git bisect good ca66f746334c4a3abf469f758c9b0633987bc876  # 19:56     21+      0  Merge 'linuxtv-media/devel-3.17-rc6' into devel-hourly-2014092402
git bisect good 46eba17a40aaafce6a606447c1fba1f316c331f7  # 20:09     21+      0  Merge 'xen-tip/devel/for-linus-3.18' into devel-hourly-2014092402
git bisect good c68691d04897b6ecdeea62d994db0442388df6ff  # 20:59     21+      0  Merge 'pinctrl/devel' into devel-hourly-2014092402
git bisect  bad 4c8c7dc7eaee7651e7f551879bcbf4bf47accc3d  # 21:24     16-      5  Merge 'kgene-samsung/for-next' into devel-hourly-2014092402
git bisect good 351b6700979b25afd3bf9bac32ebad2d0d89a696  # 21:34     52+      0  Merge 'pinctrl/for-next' into devel-hourly-2014092402
git bisect  bad 34e91dce5b5a0df1dea8628d0ab8a349128a5d78  # 21:46      0-     52  Merge 'luto/x86/vsyscall' into devel-hourly-2014092402
git bisect good fcfee6f8749af14d96373a9e2656354ad0b95499  # 21:59     52+      0  x86_64,vdso: Remove jiffies from the vvar page
git bisect good 2dee11c0eb4eb9a767fa87764c91fda18d14eff1  # 22:07     52+      0  x86_64,vsyscall: Turn vsyscalls all the way off when vsyscall=none
git bisect  bad caae204be184a575af2c02b837d818278f921323  # 22:14      0-      2  x86_64,vsyscall: Make vsyscall emulation configurable
git bisect good 2df87bdfa6ac9076ed80bb83764b8b0f3ec396bd  # 22:22     52+      0  x86_64,vsyscall: Rewrite comment and clean up headers in vsyscall code
# first bad commit: [caae204be184a575af2c02b837d818278f921323] x86_64,vsyscall: Make vsyscall emulation configurable
git bisect good 2df87bdfa6ac9076ed80bb83764b8b0f3ec396bd  # 22:24    156+      0  x86_64,vsyscall: Rewrite comment and clean up headers in vsyscall code
git bisect  bad ddc5057b07ef7126431d5df5f5b176154896f560  # 22:24      0-    264  0day head guard for 'devel-hourly-2014092402'
git bisect good f4cb707e7ad9727a046b463232f2de166e327d3e  # 23:06    156+      0  Merge tag 'pm+acpi-3.17-rc7' of git://git.kernel.org/pub/scm/linux/kernel/git/rafael/linux-pm
git bisect good 4d8426f9ac601db2a64fa7be64051d02b9c9fe01  # 23:22    156+      0  Add linux-next specific files for 20140926


This script may reproduce the error.

----------------------------------------------------------------------------
#!/bin/bash

kernel=$1
initrd=yocto-minimal-x86_64.cgz

wget --no-clobber https://github.com/fengguang/reproduce-kernel-bug/raw/master/initrd/$initrd

kvm=(
	qemu-system-x86_64
	-enable-kvm
	-cpu Haswell,+smep,+smap
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

--St7VIuEGZ6dlpu13
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="dmesg-yocto-kbuild-29:20140926221247:x86_64-randconfig-s1-09240351:3.17.0-rc1-00169-gcaae204:1"
Content-Transfer-Encoding: quoted-printable

early console in setup code
Probing EDD (edd=3Doff to disable)... ok
[    0.000000] Linux version 3.17.0-rc1-00169-gcaae204 (kbuild@snb) (gcc ve=
rsion 4.9.1 (Debian 4.9.1-11) ) #1 Fri Sep 26 22:13:15 CST 2014
[    0.000000] Command line: hung_task_panic=3D1 earlyprintk=3DttyS0,115200=
 debug apic=3Ddebug sysrq_always_enabled rcupdate.rcu_cpu_stall_timeout=3D1=
00 panic=3D-1 softlockup_panic=3D1 nmi_watchdog=3Dpanic oops=3Dpanic load_r=
amdisk=3D2 prompt_ramdisk=3D0 console=3DttyS0,115200 console=3Dtty0 vga=3Dn=
ormal  root=3D/dev/ram0 rw link=3D/kbuild-tests/run-queue/kvm/x86_64-randco=
nfig-s1-09240351/linux-devel:devel-hourly-2014092402:caae204be184a575af2c02=
b837d818278f921323:bisect-linux-6/.vmlinuz-caae204be184a575af2c02b837d81827=
8f921323-20140926221333-24-kbuild branch=3Dlinux-devel/devel-hourly-2014092=
402 BOOT_IMAGE=3D/kernel/x86_64-randconfig-s1-09240351/caae204be184a575af2c=
02b837d818278f921323/vmlinuz-3.17.0-rc1-00169-gcaae204 drbd.minor_count=3D8
[    0.000000] KERNEL supported cpus:
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
[    0.000000] NX (Execute Disable) protection: active
[    0.000000] SMBIOS 2.4 present.
[    0.000000] DMI: Bochs Bochs, BIOS Bochs 01/01/2011
[    0.000000] Hypervisor detected: KVM
[    0.000000] e820: update [mem 0x00000000-0x00000fff] usable =3D=3D> rese=
rved
[    0.000000] e820: remove [mem 0x000a0000-0x000fffff] usable
[    0.000000] e820: last_pfn =3D 0x13ffe max_arch_pfn =3D 0x400000000
[    0.000000] Scan for SMP in [mem 0x00000000-0x000003ff]
[    0.000000] Scan for SMP in [mem 0x0009fc00-0x0009ffff]
[    0.000000] Scan for SMP in [mem 0x000f0000-0x000fffff]
[    0.000000] found SMP MP-table at [mem 0x000fdb00-0x000fdb0f] mapped at =
[ffff8800000fdb00]
[    0.000000]   mpc: fdb10-fdbf0
[    0.000000] Base memory trampoline at [ffff880000099000] 99000 size 24576
[    0.000000] init_memory_mapping: [mem 0x00000000-0x000fffff]
[    0.000000]  [mem 0x00000000-0x000fffff] page 4k
[    0.000000] BRK [0x026de000, 0x026defff] PGTABLE
[    0.000000] BRK [0x026df000, 0x026dffff] PGTABLE
[    0.000000] BRK [0x026e0000, 0x026e0fff] PGTABLE
[    0.000000] init_memory_mapping: [mem 0x13a00000-0x13bfffff]
[    0.000000]  [mem 0x13a00000-0x13bfffff] page 2M
[    0.000000] init_memory_mapping: [mem 0x10000000-0x139fffff]
[    0.000000]  [mem 0x10000000-0x139fffff] page 2M
[    0.000000] init_memory_mapping: [mem 0x00100000-0x0fffffff]
[    0.000000]  [mem 0x00100000-0x001fffff] page 4k
[    0.000000]  [mem 0x00200000-0x0fffffff] page 2M
[    0.000000] init_memory_mapping: [mem 0x13c00000-0x13ffdfff]
[    0.000000]  [mem 0x13c00000-0x13dfffff] page 2M
[    0.000000]  [mem 0x13e00000-0x13ffdfff] page 4k
[    0.000000] BRK [0x026e1000, 0x026e1fff] PGTABLE
[    0.000000] RAMDISK: [mem 0x13ce6000-0x13feffff]
[    0.000000] ACPI: Early table checksum verification disabled
[    0.000000] ACPI: RSDP 0x00000000000FD9A0 000014 (v00 BOCHS )
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
[    0.000000] mapped APIC to ffffffffff7fc000 (        fee00000)
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
[    0.000000] On node 0 totalpages: 81820
[    0.000000]   DMA zone: 56 pages used for memmap
[    0.000000]   DMA zone: 21 pages reserved
[    0.000000]   DMA zone: 3998 pages, LIFO batch:0
[    0.000000]   DMA32 zone: 1064 pages used for memmap
[    0.000000]   DMA32 zone: 77822 pages, LIFO batch:15
[    0.000000] ACPI: PM-Timer IO Port: 0xb008
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] mapped APIC to ffffffffff7fc000 (        fee00000)
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
[    0.000000] mapped IOAPIC to ffffffffff7fb000 (fec00000)
[    0.000000] KVM setup async PF for cpu 0
[    0.000000] kvm-stealtime: cpu 0, msr 1a2a500
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
-randconfig-s1-09240351/linux-devel:devel-hourly-2014092402:caae204be184a57=
5af2c02b837d818278f921323:bisect-linux-6/.vmlinuz-caae204be184a575af2c02b83=
7d818278f921323-20140926221333-24-kbuild branch=3Dlinux-devel/devel-hourly-=
2014092402 BOOT_IMAGE=3D/kernel/x86_64-randconfig-s1-09240351/caae204be184a=
575af2c02b837d818278f921323/vmlinuz-3.17.0-rc1-00169-gcaae204 drbd.minor_co=
unt=3D8
[    0.000000] PID hash table entries: 2048 (order: 2, 16384 bytes)
[    0.000000] Dentry cache hash table entries: 65536 (order: 7, 524288 byt=
es)
[    0.000000] Inode-cache hash table entries: 32768 (order: 6, 262144 byte=
s)
[    0.000000] xsave: enabled xstate_bv 0x7, cntxt size 0x340 using standar=
d form
[    0.000000] Memory: 293856K/327280K available (4783K kernel code, 555K r=
wdata, 2556K rodata, 704K init, 11908K bss, 33424K reserved)
[    0.000000] NR_IRQS:4352 nr_irqs:256 0
[    0.000000] console [ttyS0] enabled
[    0.000000] Lock dependency validator: Copyright (c) 2006 Red Hat, Inc.,=
 Ingo Molnar
[    0.000000] ... MAX_LOCKDEP_SUBCLASSES:  8
[    0.000000] ... MAX_LOCK_DEPTH:          48
[    0.000000] ... MAX_LOCKDEP_KEYS:        8191
[    0.000000] ... CLASSHASH_SIZE:          4096
[    0.000000] ... MAX_LOCKDEP_ENTRIES:     32768
[    0.000000] ... MAX_LOCKDEP_CHAINS:      65536
[    0.000000] ... CHAINHASH_SIZE:          32768
[    0.000000]  memory used by lock dependency info: 8127 kB
[    0.000000]  per task-struct memory footprint: 1920 bytes
[    0.000000] hpet clockevent registered
[    0.000000] tsc: Detected 2693.452 MHz processor
[    0.020000] Calibrating delay loop (skipped) preset value.. 5386.90 Bogo=
MIPS (lpj=3D26934520)
[    0.020000] pid_max: default: 32768 minimum: 301
[    0.020000] ACPI: Core revision 20140724
[    0.023037] ACPI: All ACPI Tables successfully acquired
[    0.023847] Security Framework initialized
[    0.024412] Smack:  Initializing.
[    0.030015] AppArmor: AppArmor disabled by boot time parameter
[    0.030812] Mount-cache hash table entries: 1024 (order: 1, 8192 bytes)
[    0.037435] Mountpoint-cache hash table entries: 1024 (order: 1, 8192 by=
tes)
[    0.038806] Last level iTLB entries: 4KB 0, 2MB 0, 4MB 0
[    0.038806] Last level dTLB entries: 4KB 0, 2MB 0, 4MB 0, 1GB 0
[    0.040008] CPU: GenuineIntel Intel Core Processor (Haswell) (fam: 06, m=
odel: 3c, stepping: 01)
[    0.051178] Performance Events: no PMU driver, software events only.
[    0.054538] Getting VERSION: 1050014
[    0.055042] Getting VERSION: 1050014
[    0.055581] Getting ID: 0
[    0.055946] Getting ID: ff000000
[    0.060022] Getting LVT0: 8700
[    0.060445] Getting LVT1: 8400
[    0.060928] enabled ExtINT on CPU#0
[    0.065925] ENABLING IO-APIC IRQs
[    0.066410] NMI watchdog: disabled (cpu0): hardware events not enabled
[    0.067316] init IO_APIC IRQs
[    0.067719]  apic 0 pin 0 not connected
[    0.070030] IOAPIC[0]: Set routing entry (0-1 -> 0x31 -> IRQ 1 Mode:0 Ac=
tive:0 Dest:1)
[    0.071839] IOAPIC[0]: Set routing entry (0-2 -> 0x30 -> IRQ 0 Mode:0 Ac=
tive:0 Dest:1)
[    0.072966] IOAPIC[0]: Set routing entry (0-3 -> 0x33 -> IRQ 3 Mode:0 Ac=
tive:0 Dest:1)
[    0.080037] IOAPIC[0]: Set routing entry (0-4 -> 0x34 -> IRQ 4 Mode:0 Ac=
tive:0 Dest:1)
[    0.082820] IOAPIC[0]: Set routing entry (0-5 -> 0x35 -> IRQ 5 Mode:1 Ac=
tive:0 Dest:1)
[    0.083875] IOAPIC[0]: Set routing entry (0-6 -> 0x36 -> IRQ 6 Mode:0 Ac=
tive:0 Dest:1)
[    0.084927] IOAPIC[0]: Set routing entry (0-7 -> 0x37 -> IRQ 7 Mode:0 Ac=
tive:0 Dest:1)
[    0.090030] IOAPIC[0]: Set routing entry (0-8 -> 0x38 -> IRQ 8 Mode:0 Ac=
tive:0 Dest:1)
[    0.091088] IOAPIC[0]: Set routing entry (0-9 -> 0x39 -> IRQ 9 Mode:1 Ac=
tive:0 Dest:1)
[    0.097294] IOAPIC[0]: Set routing entry (0-10 -> 0x3a -> IRQ 10 Mode:1 =
Active:0 Dest:1)
[    0.098424] IOAPIC[0]: Set routing entry (0-11 -> 0x3b -> IRQ 11 Mode:1 =
Active:0 Dest:1)
[    0.100031] IOAPIC[0]: Set routing entry (0-12 -> 0x3c -> IRQ 12 Mode:0 =
Active:0 Dest:1)
[    0.101175] IOAPIC[0]: Set routing entry (0-13 -> 0x3d -> IRQ 13 Mode:0 =
Active:0 Dest:1)
[    0.103983] IOAPIC[0]: Set routing entry (0-14 -> 0x3e -> IRQ 14 Mode:0 =
Active:0 Dest:1)
[    0.105065] IOAPIC[0]: Set routing entry (0-15 -> 0x3f -> IRQ 15 Mode:0 =
Active:0 Dest:1)
[    0.110026]  apic 0 pin 16 not connected
[    0.110607]  apic 0 pin 17 not connected
[    0.111115]  apic 0 pin 18 not connected
[    0.117539]  apic 0 pin 19 not connected
[    0.118127]  apic 0 pin 20 not connected
[    0.118637]  apic 0 pin 21 not connected
[    0.119172]  apic 0 pin 22 not connected
[    0.120010]  apic 0 pin 23 not connected
[    0.120675] ..TIMER: vector=3D0x30 apic1=3D0 pin1=3D2 apic2=3D-1 pin2=3D=
-1
[    0.122074] TSC deadline timer enabled
[    0.129227] evm: security.selinux
[    0.130015] evm: security.SMACK64
[    0.130512] evm: security.capability
[    0.131654] regulator-dummy: no parameters
[    0.133844] NET: Registered protocol family 16
[    0.136219] cpuidle: using governor ladder
[    0.136768] cpuidle: using governor menu
[    0.137529] ACPI: bus type PCI registered
[    0.138239] PCI: Using configuration type 1 for base access
[    0.143720] Running resizable hashtable tests...
[    0.144345]   Adding 2048 keys
[    0.149228]   Traversal complete: counted=3D2048, nelems=3D2048, entries=
=3D2048
[    0.150124]   Table expansion iteration 0...
[    0.150958]   Verifying lookups...
[    0.151521]   Table expansion iteration 1...
[    0.153120]   Verifying lookups...
[    0.153713]   Table expansion iteration 2...
[    0.159581]   Verifying lookups...
[    0.160121]   Table expansion iteration 3...
[    0.164152]   Verifying lookups...
[    0.164836]   Table shrinkage iteration 0...
[    0.166334]   Verifying lookups...
[    0.166881]   Table shrinkage iteration 1...
[    0.167567]   Verifying lookups...
[    0.168126]   Table shrinkage iteration 2...
[    0.170081]   Verifying lookups...
[    0.170666]   Table shrinkage iteration 3...
[    0.172564]   Verifying lookups...
[    0.173105]   Deleting 2048 keys
[    0.174264] ACPI: Added _OSI(Module Device)
[    0.174823] ACPI: Added _OSI(Processor Device)
[    0.178926] ACPI: Added _OSI(3.0 _SCP Extensions)
[    0.179586] ACPI: Added _OSI(Processor Aggregator Device)
[    0.195701] ACPI: Interpreter enabled
[    0.196218] ACPI: (supports S0 S5)
[    0.196658] ACPI: Using IOAPIC for interrupt routing
[    0.197342] PCI: Using host bridge windows from ACPI; if necessary, use =
"pci=3Dnocrs" and report a bug
[    0.219227] ACPI: PCI Root Bridge [PCI0] (domain 0000 [bus 00-ff])
[    0.220016] acpi PNP0A03:00: _OSC: OS supports [Segments]
[    0.225376] acpi PNP0A03:00: _OSC failed (AE_NOT_FOUND); disabling ASPM
[    0.227511] PCI host bridge to bus 0000:00
[    0.228053] pci_bus 0000:00: root bus resource [bus 00-ff]
[    0.228759] pci_bus 0000:00: root bus resource [io  0x0000-0x0cf7]
[    0.230015] pci_bus 0000:00: root bus resource [io  0x0d00-0xffff]
[    0.230798] pci_bus 0000:00: root bus resource [mem 0x000a0000-0x000bfff=
f]
[    0.231713] pci_bus 0000:00: root bus resource [mem 0x80000000-0xfebffff=
f]
[    0.232713] pci 0000:00:00.0: [8086:1237] type 00 class 0x060000
[    0.237038] pci 0000:00:01.0: [8086:7000] type 00 class 0x060100
[    0.238546] pci 0000:00:01.1: [8086:7010] type 00 class 0x010180
[    0.243127] pci 0000:00:01.1: reg 0x20: [io  0xc040-0xc04f]
[    0.248566] pci 0000:00:01.1: legacy IDE quirk: reg 0x10: [io  0x01f0-0x=
01f7]
[    0.249573] pci 0000:00:01.1: legacy IDE quirk: reg 0x14: [io  0x03f6]
[    0.250015] pci 0000:00:01.1: legacy IDE quirk: reg 0x18: [io  0x0170-0x=
0177]
[    0.250923] pci 0000:00:01.1: legacy IDE quirk: reg 0x1c: [io  0x0376]
[    0.254385] pci 0000:00:01.3: [8086:7113] type 00 class 0x068000
[    0.256293] pci 0000:00:01.3: quirk: [io  0xb000-0xb03f] claimed by PIIX=
4 ACPI
[    0.257424] pci 0000:00:01.3: quirk: [io  0xb100-0xb10f] claimed by PIIX=
4 SMB
[    0.260460] pci 0000:00:02.0: [1013:00b8] type 00 class 0x030000
[    0.270077] pci 0000:00:02.0: reg 0x10: [mem 0xfc000000-0xfdffffff pref]
[    0.273839] pci 0000:00:02.0: reg 0x14: [mem 0xfebf0000-0xfebf0fff]
[    0.295670] pci 0000:00:02.0: reg 0x30: [mem 0xfebe0000-0xfebeffff pref]
[    0.297364] pci 0000:00:03.0: [8086:100e] type 00 class 0x020000
[    0.301839] pci 0000:00:03.0: reg 0x10: [mem 0xfeba0000-0xfebbffff]
[    0.308418] pci 0000:00:03.0: reg 0x14: [io  0xc000-0xc03f]
[    0.320019] pci 0000:00:03.0: reg 0x30: [mem 0xfebc0000-0xfebdffff pref]
[    0.321344] pci 0000:00:04.0: [8086:25ab] type 00 class 0x088000
[    0.324982] pci 0000:00:04.0: reg 0x10: [mem 0xfebf1000-0xfebf100f]
[    0.335388] pci_bus 0000:00: on NUMA node 0
[    0.341103] ACPI: PCI Interrupt Link [LNKA] (IRQs 5 *10 11)
[    0.342227] ACPI: PCI Interrupt Link [LNKB] (IRQs 5 *10 11)
[    0.343464] ACPI: PCI Interrupt Link [LNKC] (IRQs 5 10 *11)
[    0.349574] ACPI: PCI Interrupt Link [LNKD] (IRQs 5 10 *11)
[    0.350346] ACPI: PCI Interrupt Link [LNKS] (IRQs *9)
[    0.351638] ACPI: Enabled 16 GPEs in block 00 to 0F
[    0.354996] vgaarb: device added: PCI:0000:00:02.0,decodes=3Dio+mem,owns=
=3Dio+mem,locks=3Dnone
[    0.356703] vgaarb: loaded
[    0.357080] vgaarb: bridge control possible 0000:00:02.0
[    0.358078] pps_core: LinuxPPS API ver. 1 registered
[    0.358721] pps_core: Software ver. 5.3.6 - Copyright 2005-2007 Rodolfo =
Giometti <giometti@linux.it>
[    0.360043] PTP clock support registered
[    0.360892] PCI: Using ACPI for IRQ routing
[    0.366036] PCI: pci_cache_line_size set to 64 bytes
[    0.366807] e820: reserve RAM buffer [mem 0x0009fc00-0x0009ffff]
[    0.367583] e820: reserve RAM buffer [mem 0x13ffe000-0x13ffffff]
[    0.370588] NetLabel: Initializing
[    0.371067] NetLabel:  domain hash size =3D 128
[    0.375156] NetLabel:  protocols =3D UNLABELED CIPSOv4
[    0.375901] NetLabel:  unlabeled traffic allowed by default
[    0.376811] nfc: nfc_init: NFC Core ver 0.1
[    0.377436] NET: Registered protocol family 39
[    0.380293] cfg80211: Calling CRDA to update world regulatory domain
[    0.385173] Switched to clocksource kvm-clock
[    0.386020] FS-Cache: Loaded
[    0.386517] pnp: PnP ACPI init
[    0.387106] pnp 00:00: Plug and Play ACPI device, IDs PNP0b00 (active)
[    0.387106] pnp 00:01: Plug and Play ACPI device, IDs PNP0303 (active)
[    0.390376] pnp 00:02: Plug and Play ACPI device, IDs PNP0f13 (active)
[    0.391294] pnp 00:03: [dma 2]
[    0.391764] pnp 00:03: Plug and Play ACPI device, IDs PNP0700 (active)
[    0.392880] pnp 00:04: Plug and Play ACPI device, IDs PNP0400 (active)
[    0.393870] pnp 00:05: Plug and Play ACPI device, IDs PNP0501 (active)
[    0.399984] pnp 00:06: Plug and Play ACPI device, IDs PNP0501 (active)
[    0.401315] pnp: PnP ACPI: found 7 devices
[    0.412510] pci_bus 0000:00: resource 4 [io  0x0000-0x0cf7]
[    0.413247] pci_bus 0000:00: resource 5 [io  0x0d00-0xffff]
[    0.413969] pci_bus 0000:00: resource 6 [mem 0x000a0000-0x000bffff]
[    0.419359] pci_bus 0000:00: resource 7 [mem 0x80000000-0xfebfffff]
[    0.420299] NET: Registered protocol family 2
[    0.421289] TCP established hash table entries: 4096 (order: 3, 32768 by=
tes)
[    0.422272] TCP bind hash table entries: 4096 (order: 6, 262144 bytes)
[    0.427327] TCP: Hash tables configured (established 4096 bind 4096)
[    0.428244] TCP: reno registered
[    0.428678] UDP hash table entries: 256 (order: 3, 40960 bytes)
[    0.432948] UDP-Lite hash table entries: 256 (order: 3, 40960 bytes)
[    0.434079] NET: Registered protocol family 1
[    0.436485] pci 0000:00:00.0: Limiting direct PCI/PCI transfers
[    0.437308] pci 0000:00:01.0: PIIX3: Enabling Passive Release
[    0.438079] pci 0000:00:01.0: Activating ISA DMA hang workarounds
[    0.438952] pci 0000:00:02.0: Boot video device
[    0.443096] PCI: CLS 0 bytes, default 64
[    0.443907] Unpacking initramfs...
[    0.656538] Freeing initrd memory: 3112K (ffff880013ce6000 - ffff880013f=
f0000)
[    0.658510] cryptomgr_test (16) used greatest stack depth: 14888 bytes l=
eft
[    0.664451] AVX version of gcm_enc/dec engaged.
[    0.666792] AES CTR mode by8 optimization enabled
[    0.673688] futex hash table entries: 256 (order: 2, 20480 bytes)
[    0.674521] Initialise system trusted keyring
[    0.676474] audit: initializing netlink subsys (disabled)
[    0.677274] audit: type=3D2000 audit(1411740757.417:1): initialized
[    0.678295] Kprobe smoke test: started
[    0.697846] Kprobe smoke test: passed successfully
[    0.702725] HugeTLB registered 2 MB page size, pre-allocated 0 pages
[    0.704248] DLM installed
[    0.709898] FS-Cache: Netfs 'cifs' registered for caching
[    0.710668] Key type cifs.spnego registered
[    0.711227] fuse init (API version 7.23)
[    0.711877] 9p: Installing v9fs 9p2000 file system support
[    0.714825] FS-Cache: Netfs '9p' registered for caching
[    0.715557] FS-Cache: Netfs 'ceph' registered for caching
[    0.719806] ceph: loaded (mds proto 32)
[    0.720356] msgmni has been set to 580
[    0.725098] Key type asymmetric registered
[    0.729693] Asymmetric key parser 'x509' registered
[    0.730365] test_string_helpers: Running tests...
[    0.731191] rbtree testing -> 26118 cycles
[    1.801774] augmented rbtree testing -> 39138 cycles
[    3.357964] tsc: Refined TSC clocksource calibration: 2693.503 MHz
[    3.358934] no IO addresses supplied
[    3.359585] ipmi message handler version 39.2
[    3.360223] ipmi device interface
[    3.360719] IPMI Watchdog: driver initialized
[    3.361584] input: Power Button as /devices/LNXSYSTM:00/LNXPWRBN:00/inpu=
t/input0
[    3.362608] ACPI: Power Button [PWRF]
[    3.467567] Serial: 8250/16550 driver, 4 ports, IRQ sharing disabled
[    3.518506] 00:05: ttyS0 at I/O 0x3f8 (irq =3D 4, base_baud =3D 115200) =
is a 16550A
[    3.520736] Non-volatile memory driver v1.3
[    3.521346] Silicon Labs C2 port support v. 0.51.0 - (C) 2007 Rodolfo Gi=
ometti
[    3.522564] c2port c2port0: C2 port uc added
[    3.523114] c2port c2port0: uc flash has 30 blocks x 512 bytes (15360 by=
tes total)
[    3.533923] Ethernet Channel Bonding Driver: v3.7.1 (April 27, 2011)
[    3.536677] libphy: Fixed MDIO Bus: probed
[    3.537653] vcan: Virtual CAN interface driver
[    3.538247] CAN device driver interface
[    3.538830] sja1000 CAN netdevice driver
[    3.539918] ieee802154fakelb ieee802154fakelb: added ieee802154 hardware
[    3.540983] i8042: PNP: PS/2 Controller [PNP0303:KBD,PNP0f13:MOU] at 0x6=
0,0x64 irq 1,12
[    3.542953] serio: i8042 KBD port at 0x60,0x64 irq 1
[    3.554804] serio: i8042 AUX port at 0x60,0x64 irq 12
[    3.555565] Driver for 1-wire Dallas network protocol.
[    3.556525] 1-Wire driver for the DS2760 battery monitor chip - (c) 2004=
-2005, Szabolcs Gyurko
[    3.557763] acquirewdt: WDT driver for Acquire single board computer ini=
tialising
[    3.558872] acquirewdt: I/O address 0x0043 already in use
[    3.559570] acquirewdt: probe of acquirewdt failed with error -5
[    3.560643] it87_wdt: no device
[    3.561166] cpu5wdt: init success
[    3.561675] w83877f_wdt: cannot register miscdev on minor=3D130 (err=3D-=
16)
[    3.562569] w83977f_wdt: driver v1.00
[    3.563062] w83977f_wdt: cannot register miscdev on minor=3D130 (err=3D-=
16)
[    3.563955] sbc_epx_c3: cannot register miscdev on minor=3D130 (err=3D-1=
6)
[    3.576872] dcdbas dcdbas: Dell Systems Management Base Driver (version =
5.6.0-3.2)
[    3.578095] pktgen: Packet Generator for packet performance testing. Ver=
sion: 2.74
[    3.579250] Netfilter messages via NETLINK v0.30.
[    3.579880] nfnl_acct: registering with nfnetlink.
[    3.580810] ipip: IPv4 over IPv4 tunneling driver
[    3.581843] ip_tables: (C) 2000-2006 Netfilter Core Team
[    3.582579] arp_tables: (C) 2002 David S. Miller
[    3.583193] TCP: cubic registered
[    3.583641] NET: Registered protocol family 17
[    3.584316] Bridge firewalling registered
[    3.594661] Ebtables v2.0 registered
[    3.595267] NET: Registered protocol family 9
[    3.595859] X25: Linux Version 0.2
[    3.596321] can: controller area network core (rev 20120528 abi 9)
[    3.605334] NET: Registered protocol family 29
[    3.605939] can: netlink gateway (rev 20130117) max_hops=3D1
[    3.606767] NET: Registered protocol family 35
[    3.607387] 8021q: 802.1Q VLAN Support v1.8
[    3.608377] sctp: Hash tables configured (established 2340 bind 2048)
[    3.612476] sctp_probe: probe registered (port=3D0/fwmark=3D0) bufsize=
=3D65536
[    3.613354] tipc: Activated (version 2.0.0)
[    3.624689] NET: Registered protocol family 30
[    3.625548] tipc: Started in single node mode
[    3.626225] 9pnet: Installing 9P2000 support
[    3.626859] NET: Registered protocol family 36
[    3.627474] Key type dns_resolver registered
[    3.628064] Key type ceph registered
[    3.628613] libceph: loaded (mon/osd proto 15/24)
[    3.629508] batman_adv: B.A.T.M.A.N. advanced 2014.4.0 (compatibility ve=
rsion 15) loaded
[    3.630807]=20
[    3.630807] printing PIC contents
[    3.631445] ... PIC  IMR: ffff
[    3.631888] ... PIC  IRR: 1012
[    3.632298] ... PIC  ISR: 0000
[    3.632720] ... PIC ELCR: 0c00
[    3.633176] printing local APIC contents on CPU#0/0:
[    3.640614] ... APIC ID:      00000000 (0)
[    3.640614] ... APIC VERSION: 01050014
[    3.640614] ... APIC TASKPRI: 00000000 (00)
[    3.640614] ... APIC PROCPRI: 00000000
[    3.640614] ... APIC LDR: 01000000
[    3.640614] ... APIC DFR: ffffffff
[    3.640614] ... APIC SPIV: 000001ff
[    3.640614] ... APIC ISR field:
[    3.640614] 000000000000000000000000000000000000000000000000000000000000=
0000
[    3.640614] ... APIC TMR field:
[    3.640614] 000000000200000000000000000000000000000000000000000000000000=
0000
[    3.640614] ... APIC IRR field:
[    3.640614] 000000000000000000000000000000000000000000000000000000000000=
8000
[    3.640614] ... APIC ESR: 00000000
[    3.640614] ... APIC ICR: 00000831
[    3.640614] ... APIC ICR2: 01000000
[    3.640614] ... APIC LVTT: 000400ef
[    3.640614] ... APIC LVTPC: 00010000
[    3.640614] ... APIC LVT0: 00010700
[    3.640614] ... APIC LVT1: 00000400
[    3.640614] ... APIC LVTERR: 000000fe
[    3.640614] ... APIC TMICT: 00000000
[    3.640614] ... APIC TMCCT: 00000000
[    3.640614] ... APIC TDCR: 00000000
[    3.640614]=20
[    3.667608] number of MP IRQ sources: 15.
[    3.668129] number of IO-APIC #0 registers: 24.
[    3.668719] testing the IO APIC.......................
[    3.669392] IO APIC #0......
[    3.669779] .... register #00: 00000000
[    3.670289] .......    : physical APIC id: 00
[    3.670858] .......    : Delivery Type: 0
[    3.671373] .......    : LTS          : 0
[    3.671898] .... register #01: 00170011
[    3.672391] .......     : max redirection entries: 17
[    3.673045] .......     : PRQ implemented: 0
[    3.673595] .......     : IO APIC version: 11
[    3.685285] .... register #02: 00000000
[    3.685797] .......     : arbitration: 00
[    3.686303] .... IRQ redirection table:
[    3.686867] 1    0    0   0   0    0    0    00
[    3.687460] 0    0    0   0   0    1    1    31
[    3.688173] 0    0    0   0   0    1    1    30
[    3.688792] 0    0    0   0   0    1    1    33
[    3.689431] 1    0    0   0   0    1    1    34
[    3.690037] 1    1    0   0   0    1    1    35
[    3.690629] 0    0    0   0   0    1    1    36
[    3.691269] 0    0    0   0   0    1    1    37
[    3.691895] 0    0    0   0   0    1    1    38
[    3.692570] 0    1    0   0   0    1    1    39
[    3.693178] 1    1    0   0   0    1    1    3A
[    3.695278] 1    1    0   0   0    1    1    3B
[    3.695891] 0    0    0   0   0    1    1    3C
[    3.696487] 0    0    0   0   0    1    1    3D
[    3.697090] 0    0    0   0   0    1    1    3E
[    3.697692] 0    0    0   0   0    1    1    3F
[    3.698286] 1    0    0   0   0    0    0    00
[    3.698886] 1    0    0   0   0    0    0    00
[    3.699479] 1    0    0   0   0    0    0    00
[    3.700104] 1    0    0   0   0    0    0    00
[    3.700708] 1    0    0   0   0    0    0    00
[    3.701302] 1    0    0   0   0    0    0    00
[    3.701904] 1    0    0   0   0    0    0    00
[    3.702502] 1    0    0   0   0    0    0    00
[    3.703093] IRQ to pin mappings:
[    3.703514] IRQ0 -> 0:2
[    3.703897] IRQ1 -> 0:1
[    3.704265] IRQ3 -> 0:3
[    3.714713] IRQ4 -> 0:4
[    3.715081] IRQ5 -> 0:5
[    3.715486] IRQ6 -> 0:6
[    3.715854] IRQ7 -> 0:7
[    3.716231] IRQ8 -> 0:8
[    3.716594] IRQ9 -> 0:9
[    3.716969] IRQ10 -> 0:10
[    3.717385] IRQ11 -> 0:11
[    3.717762] IRQ12 -> 0:12
[    3.718199] IRQ13 -> 0:13
[    3.718584] IRQ14 -> 0:14
[    3.718988] IRQ15 -> 0:15
[    3.719402] .................................... done.
[    3.720616] Loading compiled-in X.509 certificates
[    3.722422] Loaded X.509 cert 'Magrathea: Glacier signing key: ef1e43c96=
fb751d0e1f4cebc584a90b84fa08085'
[    3.734134] registered taskstats version 1
[    3.735210] kworker/u2:1 (102) used greatest stack depth: 14520 bytes le=
ft
[    3.736503] Key type encrypted registered
[    3.737102] cryptomgr_probe (105) used greatest stack depth: 14272 bytes=
 left
[    3.738443] evm: HMAC attrs: 0x1
[    3.756635] Freeing unused kernel memory: 704K (ffffffff81a8c000 - fffff=
fff81b3c000)
[    3.757706] Write protecting the kernel read-only data: 10240k
[    3.764364] Freeing unused kernel memory: 1352K (ffff8800014ae000 - ffff=
880001600000)
[    3.772279] Freeing unused kernel memory: 1540K (ffff88000187f000 - ffff=
880001a00000)
/etc/rcS.d/S00fbsetup: line 3: /sbin/modprobe: not found
[    3.802104] S00fbsetup (120) used greatest stack depth: 14168 bytes left
[    3.803977] rc (123) used greatest stack depth: 14000 bytes left

Please wait: booting...
Starting udev
mount: mounting none on /dev failed: Invalid argument
/etc/rcS.d/S03udev: line 72: can't create /proc/sys/kernel/hotplug: nonexis=
tent directory
[    3.858723] udev[138]: starting version 164
[    4.560305] udevadm (140) used greatest stack depth: 13944 bytes left
[    5.248382] input: AT Translated Set 2 keyboard as /devices/platform/i80=
42/serio0/input/input1
[    5.356741] init[1]: segfault at ffffffffff600400 ip ffffffffff600400 sp=
 00007fff5e2eecf8 error 15
[    5.357984] init[1]: segfault at ffffffffff600400 ip ffffffffff600400 sp=
 00007fff5e2ee1b8 error 15
[    5.359253] Kernel panic - not syncing: Attempted to kill init! exitcode=
=3D0x0000000b
[    5.359253]=20
[    5.360439] CPU: 0 PID: 1 Comm: init Not tainted 3.17.0-rc1-00169-gcaae2=
04 #1
[    5.361364] Hardware name: Bochs Bochs, BIOS Bochs 01/01/2011
[    5.362114]  0000000000000000 ffff88001284fcb0 ffffffff814a2ce5 ffff8800=
1284fd30
[    5.363152]  ffffffff814a1c51 0000000000000010 ffff88001284fd40 ffff8800=
1284fcd8
[    5.363611]  ffff88001284fd78 000000000000000b 0000000000000000 ffff8800=
12848740
[    5.363611] Call Trace:
[    5.363611]  [<ffffffff814a2ce5>] dump_stack+0x19/0x1b
[    5.363611]  [<ffffffff814a1c51>] panic+0xc4/0x1ef
[    5.363611]  [<ffffffff81090d2c>] do_exit+0x3bb/0x81e
[    5.363611]  [<ffffffff811198c5>] ? __kmem_cache_free+0x11/0x2e
[    5.363611]  [<ffffffff8111992c>] ? kmem_cache_free+0x31/0x33
[    5.363611]  [<ffffffff810962eb>] ? __sigqueue_free+0x33/0x36
[    5.363611]  [<ffffffff81091e90>] do_group_exit+0x45/0xbf
[    5.363611]  [<ffffffff81098df9>] get_signal+0x53d/0x568
[    5.363611]  [<ffffffff81043039>] ? bad_area_nosemaphore+0xe/0x10
[    5.363611]  [<ffffffff81028218>] do_signal+0x23/0x885
[    5.363611]  [<ffffffff814a0000>] ? free_area_init_node+0xac/0x36e
[    5.363611]  [<ffffffff81028a96>] do_notify_resume+0x1c/0x75
[    5.363611]  [<ffffffff814a927b>] retint_signal+0x48/0x8d
[    5.363611] Kernel Offset: 0x0 from 0xffffffff81000000 (relocation range=
: 0xffffffff80000000-0xffffffff9fffffff)

Elapsed time: 10
qemu-system-x86_64 -enable-kvm -cpu Haswell,+smep,+smap -kernel /kernel/x86=
_64-randconfig-s1-09240351/caae204be184a575af2c02b837d818278f921323/vmlinuz=
-3.17.0-rc1-00169-gcaae204 -append 'hung_task_panic=3D1 earlyprintk=3DttyS0=
,115200 debug apic=3Ddebug sysrq_always_enabled rcupdate.rcu_cpu_stall_time=
out=3D100 panic=3D-1 softlockup_panic=3D1 nmi_watchdog=3Dpanic oops=3Dpanic=
 load_ramdisk=3D2 prompt_ramdisk=3D0 console=3DttyS0,115200 console=3Dtty0 =
vga=3Dnormal  root=3D/dev/ram0 rw link=3D/kbuild-tests/run-queue/kvm/x86_64=
-randconfig-s1-09240351/linux-devel:devel-hourly-2014092402:caae204be184a57=
5af2c02b837d818278f921323:bisect-linux-6/.vmlinuz-caae204be184a575af2c02b83=
7d818278f921323-20140926221333-24-kbuild branch=3Dlinux-devel/devel-hourly-=
2014092402 BOOT_IMAGE=3D/kernel/x86_64-randconfig-s1-09240351/caae204be184a=
575af2c02b837d818278f921323/vmlinuz-3.17.0-rc1-00169-gcaae204 drbd.minor_co=
unt=3D8'  -initrd /kernel-tests/initrd/yocto-minimal-x86_64.cgz -m 320 -smp=
 1 -net nic,vlan=3D1,model=3De1000 -net user,vlan=3D1 -boot order=3Dnc -no-=
reboot -watchdog i6300esb -rtc base=3Dlocaltime -pidfile /dev/shm/kboot/pid=
-yocto-kbuild-29 -serial file:/dev/shm/kboot/serial-yocto-kbuild-29 -daemon=
ize -display none -monitor null=20

--St7VIuEGZ6dlpu13
Content-Type: application/octet-stream
Content-Disposition: attachment; filename="x86_64-randconfig-s1-09240351-ddc5057b07ef7126431d5df5f5b176154896f560-Kernel-panic---not-syncing:-Attempted-to-kill----exitcode--92847.log"
Content-Transfer-Encoding: base64

SEVBRCBpcyBub3cgYXQgZGRjNTA1N2IuLi4gMGRheSBoZWFkIGd1YXJkIGZvciAnZGV2ZWwt
aG91cmx5LTIwMTQwOTI0MDInCmdpdCBjaGVja291dCAwZjMzYmUwMDliODlkMjI2OGU5NDE5
NGRjNGZkMDFhNzg1MWI2ZDUxCmxzIC1hIC9rYnVpbGQtdGVzdHMvcnVuLXF1ZXVlL2t2bS94
ODZfNjQtcmFuZGNvbmZpZy1zMS0wOTI0MDM1MS9saW51eC1kZXZlbDpkZXZlbC1ob3VybHkt
MjAxNDA5MjQwMjowZjMzYmUwMDliODlkMjI2OGU5NDE5NGRjNGZkMDFhNzg1MWI2ZDUxOmJp
c2VjdC1saW51eC02CgoyMDE0LTA5LTI2IDE4OjI0OjU5IDBmMzNiZTAwOWI4OWQyMjY4ZTk0
MTk0ZGM0ZmQwMWE3ODUxYjZkNTEgY29tcGlsaW5nClF1ZXVlZCBidWlsZCB0YXNrIHRvIC9r
YnVpbGQtdGVzdHMvYnVpbGQtcXVldWUvc25iL3g4Nl82NC1yYW5kY29uZmlnLXMxLTA5MjQw
MzUxLTBmMzNiZTAwOWI4OWQyMjY4ZTk0MTk0ZGM0ZmQwMWE3ODUxYjZkNTEKQ2hlY2sgZm9y
IGtlcm5lbCBpbiAva2VybmVsL3g4Nl82NC1yYW5kY29uZmlnLXMxLTA5MjQwMzUxLzBmMzNi
ZTAwOWI4OWQyMjY4ZTk0MTk0ZGM0ZmQwMWE3ODUxYjZkNTEKd2FpdGluZyBmb3IgY29tcGxl
dGlvbiBvZiAva2J1aWxkLXRlc3RzL2J1aWxkLXF1ZXVlL3NuYi94ODZfNjQtcmFuZGNvbmZp
Zy1zMS0wOTI0MDM1MS0wZjMzYmUwMDliODlkMjI2OGU5NDE5NGRjNGZkMDFhNzg1MWI2ZDUx
ChtbMTszNW0yMDE0LTA5LTI2IDE4OjUwOjU5IE5vIGJ1aWxkIHNlcnZlZCBmaWxlIC9rYnVp
bGQtdGVzdHMvYnVpbGQtc2VydmVkL3g4Nl82NC1yYW5kY29uZmlnLXMxLTA5MjQwMzUxLTBm
MzNiZTAwOWI4OWQyMjY4ZTk0MTk0ZGM0ZmQwMWE3ODUxYjZkNTEbWzBtClJldHJ5IGJ1aWxk
IC4uCndhaXRpbmcgZm9yIGNvbXBsZXRpb24gb2YgL2tidWlsZC10ZXN0cy9idWlsZC1xdWV1
ZS9zbmItc21va2UveDg2XzY0LXJhbmRjb25maWctczEtMDkyNDAzNTEtMGYzM2JlMDA5Yjg5
ZDIyNjhlOTQxOTRkYzRmZDAxYTc4NTFiNmQ1MQprZXJuZWw6IC9rZXJuZWwveDg2XzY0LXJh
bmRjb25maWctczEtMDkyNDAzNTEvMGYzM2JlMDA5Yjg5ZDIyNjhlOTQxOTRkYzRmZDAxYTc4
NTFiNmQ1MS92bWxpbnV6LTMuMTcuMC1yYzYKCjIwMTQtMDktMjYgMTg6NTI6NTkgZGV0ZWN0
aW5nIGJvb3Qgc3RhdGUgLi4uLi4uCTIJNwkxNgkxOQkyMSBTVUNDRVNTCgpiaXNlY3Q6IGdv
b2QgY29tbWl0IDBmMzNiZTAwOWI4OWQyMjY4ZTk0MTk0ZGM0ZmQwMWE3ODUxYjZkNTEKZ2l0
IGJpc2VjdCBzdGFydCBkZGM1MDU3YjA3ZWY3MTI2NDMxZDVkZjVmNWIxNzYxNTQ4OTZmNTYw
IDBmMzNiZTAwOWI4OWQyMjY4ZTk0MTk0ZGM0ZmQwMWE3ODUxYjZkNTEgLS0KL2Mva2VybmVs
LXRlc3RzL2xpbmVhci1iaXNlY3Q6IFsiLWIiLCAiZGRjNTA1N2IwN2VmNzEyNjQzMWQ1ZGY1
ZjViMTc2MTU0ODk2ZjU2MCIsICItZyIsICIwZjMzYmUwMDliODlkMjI2OGU5NDE5NGRjNGZk
MDFhNzg1MWI2ZDUxIiwgIi9jL2tlcm5lbC10ZXN0cy9iaXNlY3QtdGVzdC1ib290LWZhaWx1
cmUuc2giLCAiL2MvYm9vdC1iaXNlY3QvbGludXgtNi9vYmotYmlzZWN0Il0KQmlzZWN0aW5n
OiA0NDc4IHJldmlzaW9ucyBsZWZ0IHRvIHRlc3QgYWZ0ZXIgdGhpcyAocm91Z2hseSAxMyBz
dGVwcykKW2NhNjZmNzQ2MzM0YzRhM2FiZjQ2OWY3NThjOWIwNjMzOTg3YmM4NzZdIE1lcmdl
ICdsaW51eHR2LW1lZGlhL2RldmVsLTMuMTctcmM2JyBpbnRvIGRldmVsLWhvdXJseS0yMDE0
MDkyNDAyCnJ1bm5pbmcgL2Mva2VybmVsLXRlc3RzL2Jpc2VjdC10ZXN0LWJvb3QtZmFpbHVy
ZS5zaCAvYy9ib290LWJpc2VjdC9saW51eC02L29iai1iaXNlY3QKbHMgLWEgL2tidWlsZC10
ZXN0cy9ydW4tcXVldWUva3ZtL3g4Nl82NC1yYW5kY29uZmlnLXMxLTA5MjQwMzUxL2xpbnV4
LWRldmVsOmRldmVsLWhvdXJseS0yMDE0MDkyNDAyOmNhNjZmNzQ2MzM0YzRhM2FiZjQ2OWY3
NThjOWIwNjMzOTg3YmM4NzY6YmlzZWN0LWxpbnV4LTYKCjIwMTQtMDktMjYgMTk6MTI6Mjkg
Y2E2NmY3NDYzMzRjNGEzYWJmNDY5Zjc1OGM5YjA2MzM5ODdiYzg3NiBjb21waWxpbmcKUXVl
dWVkIGJ1aWxkIHRhc2sgdG8gL2tidWlsZC10ZXN0cy9idWlsZC1xdWV1ZS9zbmIveDg2XzY0
LXJhbmRjb25maWctczEtMDkyNDAzNTEtY2E2NmY3NDYzMzRjNGEzYWJmNDY5Zjc1OGM5YjA2
MzM5ODdiYzg3NgpDaGVjayBmb3Iga2VybmVsIGluIC9rZXJuZWwveDg2XzY0LXJhbmRjb25m
aWctczEtMDkyNDAzNTEvY2E2NmY3NDYzMzRjNGEzYWJmNDY5Zjc1OGM5YjA2MzM5ODdiYzg3
Ngp3YWl0aW5nIGZvciBjb21wbGV0aW9uIG9mIC9rYnVpbGQtdGVzdHMvYnVpbGQtcXVldWUv
c25iL3g4Nl82NC1yYW5kY29uZmlnLXMxLTA5MjQwMzUxLWNhNjZmNzQ2MzM0YzRhM2FiZjQ2
OWY3NThjOWIwNjMzOTg3YmM4NzYKG1sxOzM1bTIwMTQtMDktMjYgMTk6MzA6MjkgTm8gYnVp
bGQgc2VydmVkIGZpbGUgL2tidWlsZC10ZXN0cy9idWlsZC1zZXJ2ZWQveDg2XzY0LXJhbmRj
b25maWctczEtMDkyNDAzNTEtY2E2NmY3NDYzMzRjNGEzYWJmNDY5Zjc1OGM5YjA2MzM5ODdi
Yzg3NhtbMG0KUmV0cnkgYnVpbGQgLi4Kd2FpdGluZyBmb3IgY29tcGxldGlvbiBvZiAva2J1
aWxkLXRlc3RzL2J1aWxkLXF1ZXVlL3NuYi1zbW9rZS94ODZfNjQtcmFuZGNvbmZpZy1zMS0w
OTI0MDM1MS1jYTY2Zjc0NjMzNGM0YTNhYmY0NjlmNzU4YzliMDYzMzk4N2JjODc2Cmtlcm5l
bDogL2tlcm5lbC94ODZfNjQtcmFuZGNvbmZpZy1zMS0wOTI0MDM1MS9jYTY2Zjc0NjMzNGM0
YTNhYmY0NjlmNzU4YzliMDYzMzk4N2JjODc2L3ZtbGludXotMy4xNy4wLXJjNi0wMjAzMi1n
Y2E2NmY3NAoKMjAxNC0wOS0yNiAxOTo0NToyOSBkZXRlY3RpbmcgYm9vdCBzdGF0ZSAuLi4u
Li4uLi4uLi4uLi4uLi4uLgk5CTIxIFNVQ0NFU1MKCkJpc2VjdGluZzogMjQ0NiByZXZpc2lv
bnMgbGVmdCB0byB0ZXN0IGFmdGVyIHRoaXMgKHJvdWdobHkgMTIgc3RlcHMpCls0NmViYTE3
YTQwYWFhZmNlNmE2MDY0NDdjMWZiYTFmMzE2YzMzMWY3XSBNZXJnZSAneGVuLXRpcC9kZXZl
bC9mb3ItbGludXMtMy4xOCcgaW50byBkZXZlbC1ob3VybHktMjAxNDA5MjQwMgpydW5uaW5n
IC9jL2tlcm5lbC10ZXN0cy9iaXNlY3QtdGVzdC1ib290LWZhaWx1cmUuc2ggL2MvYm9vdC1i
aXNlY3QvbGludXgtNi9vYmotYmlzZWN0CmxzIC1hIC9rYnVpbGQtdGVzdHMvcnVuLXF1ZXVl
L2t2bS94ODZfNjQtcmFuZGNvbmZpZy1zMS0wOTI0MDM1MS9saW51eC1kZXZlbDpkZXZlbC1o
b3VybHktMjAxNDA5MjQwMjo0NmViYTE3YTQwYWFhZmNlNmE2MDY0NDdjMWZiYTFmMzE2YzMz
MWY3OmJpc2VjdC1saW51eC02CgoyMDE0LTA5LTI2IDE5OjU2OjMwIDQ2ZWJhMTdhNDBhYWFm
Y2U2YTYwNjQ0N2MxZmJhMWYzMTZjMzMxZjcgY29tcGlsaW5nClF1ZXVlZCBidWlsZCB0YXNr
IHRvIC9rYnVpbGQtdGVzdHMvYnVpbGQtcXVldWUvc25iL3g4Nl82NC1yYW5kY29uZmlnLXMx
LTA5MjQwMzUxLTQ2ZWJhMTdhNDBhYWFmY2U2YTYwNjQ0N2MxZmJhMWYzMTZjMzMxZjcKQ2hl
Y2sgZm9yIGtlcm5lbCBpbiAva2VybmVsL3g4Nl82NC1yYW5kY29uZmlnLXMxLTA5MjQwMzUx
LzQ2ZWJhMTdhNDBhYWFmY2U2YTYwNjQ0N2MxZmJhMWYzMTZjMzMxZjcKd2FpdGluZyBmb3Ig
Y29tcGxldGlvbiBvZiAva2J1aWxkLXRlc3RzL2J1aWxkLXF1ZXVlL3NuYi94ODZfNjQtcmFu
ZGNvbmZpZy1zMS0wOTI0MDM1MS00NmViYTE3YTQwYWFhZmNlNmE2MDY0NDdjMWZiYTFmMzE2
YzMzMWY3ChtbMTszNW0yMDE0LTA5LTI2IDE5OjU4OjMxIE5vIGJ1aWxkIHNlcnZlZCBmaWxl
IC9rYnVpbGQtdGVzdHMvYnVpbGQtc2VydmVkL3g4Nl82NC1yYW5kY29uZmlnLXMxLTA5MjQw
MzUxLTQ2ZWJhMTdhNDBhYWFmY2U2YTYwNjQ0N2MxZmJhMWYzMTZjMzMxZjcbWzBtClJldHJ5
IGJ1aWxkIC4uCndhaXRpbmcgZm9yIGNvbXBsZXRpb24gb2YgL2tidWlsZC10ZXN0cy9idWls
ZC1xdWV1ZS9zbmItc21va2UveDg2XzY0LXJhbmRjb25maWctczEtMDkyNDAzNTEtNDZlYmEx
N2E0MGFhYWZjZTZhNjA2NDQ3YzFmYmExZjMxNmMzMzFmNwprZXJuZWw6IC9rZXJuZWwveDg2
XzY0LXJhbmRjb25maWctczEtMDkyNDAzNTEvNDZlYmExN2E0MGFhYWZjZTZhNjA2NDQ3YzFm
YmExZjMxNmMzMzFmNy92bWxpbnV6LTMuMTcuMC1yYzYtd2wtMDI5MzYtZzQ2ZWJhMTcKCjIw
MTQtMDktMjYgMjA6MDA6MzEgZGV0ZWN0aW5nIGJvb3Qgc3RhdGUgLi4uLi4uLi4uLi4uLi4J
OQkxNAkxOAkyMSBTVUNDRVNTCgpCaXNlY3Rpbmc6IDE1NDIgcmV2aXNpb25zIGxlZnQgdG8g
dGVzdCBhZnRlciB0aGlzIChyb3VnaGx5IDExIHN0ZXBzKQpbYzY4NjkxZDA0ODk3YjZlY2Rl
ZWE2MmQ5OTRkYjA0NDIzODhkZjZmZl0gTWVyZ2UgJ3BpbmN0cmwvZGV2ZWwnIGludG8gZGV2
ZWwtaG91cmx5LTIwMTQwOTI0MDIKcnVubmluZyAvYy9rZXJuZWwtdGVzdHMvYmlzZWN0LXRl
c3QtYm9vdC1mYWlsdXJlLnNoIC9jL2Jvb3QtYmlzZWN0L2xpbnV4LTYvb2JqLWJpc2VjdAps
cyAtYSAva2J1aWxkLXRlc3RzL3J1bi1xdWV1ZS9rdm0veDg2XzY0LXJhbmRjb25maWctczEt
MDkyNDAzNTEvbGludXgtZGV2ZWw6ZGV2ZWwtaG91cmx5LTIwMTQwOTI0MDI6YzY4NjkxZDA0
ODk3YjZlY2RlZWE2MmQ5OTRkYjA0NDIzODhkZjZmZjpiaXNlY3QtbGludXgtNgoKMjAxNC0w
OS0yNiAyMDowOTozMiBjNjg2OTFkMDQ4OTdiNmVjZGVlYTYyZDk5NGRiMDQ0MjM4OGRmNmZm
IGNvbXBpbGluZwpRdWV1ZWQgYnVpbGQgdGFzayB0byAva2J1aWxkLXRlc3RzL2J1aWxkLXF1
ZXVlL3NuYi94ODZfNjQtcmFuZGNvbmZpZy1zMS0wOTI0MDM1MS1jNjg2OTFkMDQ4OTdiNmVj
ZGVlYTYyZDk5NGRiMDQ0MjM4OGRmNmZmCkNoZWNrIGZvciBrZXJuZWwgaW4gL2tlcm5lbC94
ODZfNjQtcmFuZGNvbmZpZy1zMS0wOTI0MDM1MS9jNjg2OTFkMDQ4OTdiNmVjZGVlYTYyZDk5
NGRiMDQ0MjM4OGRmNmZmCndhaXRpbmcgZm9yIGNvbXBsZXRpb24gb2YgL2tidWlsZC10ZXN0
cy9idWlsZC1xdWV1ZS9zbmIveDg2XzY0LXJhbmRjb25maWctczEtMDkyNDAzNTEtYzY4Njkx
ZDA0ODk3YjZlY2RlZWE2MmQ5OTRkYjA0NDIzODhkZjZmZgobWzE7MzVtMjAxNC0wOS0yNiAy
MDoyNjozMiBObyBidWlsZCBzZXJ2ZWQgZmlsZSAva2J1aWxkLXRlc3RzL2J1aWxkLXNlcnZl
ZC94ODZfNjQtcmFuZGNvbmZpZy1zMS0wOTI0MDM1MS1jNjg2OTFkMDQ4OTdiNmVjZGVlYTYy
ZDk5NGRiMDQ0MjM4OGRmNmZmG1swbQpSZXRyeSBidWlsZCAuLgp3YWl0aW5nIGZvciBjb21w
bGV0aW9uIG9mIC9rYnVpbGQtdGVzdHMvYnVpbGQtcXVldWUvc25iLXNtb2tlL3g4Nl82NC1y
YW5kY29uZmlnLXMxLTA5MjQwMzUxLWM2ODY5MWQwNDg5N2I2ZWNkZWVhNjJkOTk0ZGIwNDQy
Mzg4ZGY2ZmYKa2VybmVsOiAva2VybmVsL3g4Nl82NC1yYW5kY29uZmlnLXMxLTA5MjQwMzUx
L2M2ODY5MWQwNDg5N2I2ZWNkZWVhNjJkOTk0ZGIwNDQyMzg4ZGY2ZmYvdm1saW51ei0zLjE3
LjAtcmM2LXdsLTA0Mzc2LWdjNjg2OTFkCgoyMDE0LTA5LTI2IDIwOjUyOjMyIGRldGVjdGlu
ZyBib290IHN0YXRlIC4uCTIJNAk1CTcJOQkxMAkxMwkxNC4JMjAJMjEgU1VDQ0VTUwoKQmlz
ZWN0aW5nOiAxMDIgcmV2aXNpb25zIGxlZnQgdG8gdGVzdCBhZnRlciB0aGlzIChyb3VnaGx5
IDcgc3RlcHMpCls0YzhjN2RjN2VhZWU3NjUxZTdmNTUxODc5YmNiZjRiZjQ3YWNjYzNkXSBN
ZXJnZSAna2dlbmUtc2Ftc3VuZy9mb3ItbmV4dCcgaW50byBkZXZlbC1ob3VybHktMjAxNDA5
MjQwMgpydW5uaW5nIC9jL2tlcm5lbC10ZXN0cy9iaXNlY3QtdGVzdC1ib290LWZhaWx1cmUu
c2ggL2MvYm9vdC1iaXNlY3QvbGludXgtNi9vYmotYmlzZWN0CmxzIC1hIC9rYnVpbGQtdGVz
dHMvcnVuLXF1ZXVlL2t2bS94ODZfNjQtcmFuZGNvbmZpZy1zMS0wOTI0MDM1MS9saW51eC1k
ZXZlbDpkZXZlbC1ob3VybHktMjAxNDA5MjQwMjo0YzhjN2RjN2VhZWU3NjUxZTdmNTUxODc5
YmNiZjRiZjQ3YWNjYzNkOmJpc2VjdC1saW51eC02CgoyMDE0LTA5LTI2IDIxOjAxOjQwIDRj
OGM3ZGM3ZWFlZTc2NTFlN2Y1NTE4NzliY2JmNGJmNDdhY2NjM2QgY29tcGlsaW5nClF1ZXVl
ZCBidWlsZCB0YXNrIHRvIC9rYnVpbGQtdGVzdHMvYnVpbGQtcXVldWUvc25iL3g4Nl82NC1y
YW5kY29uZmlnLXMxLTA5MjQwMzUxLTRjOGM3ZGM3ZWFlZTc2NTFlN2Y1NTE4NzliY2JmNGJm
NDdhY2NjM2QKQ2hlY2sgZm9yIGtlcm5lbCBpbiAva2VybmVsL3g4Nl82NC1yYW5kY29uZmln
LXMxLTA5MjQwMzUxLzRjOGM3ZGM3ZWFlZTc2NTFlN2Y1NTE4NzliY2JmNGJmNDdhY2NjM2QK
d2FpdGluZyBmb3IgY29tcGxldGlvbiBvZiAva2J1aWxkLXRlc3RzL2J1aWxkLXF1ZXVlL3Nu
Yi94ODZfNjQtcmFuZGNvbmZpZy1zMS0wOTI0MDM1MS00YzhjN2RjN2VhZWU3NjUxZTdmNTUx
ODc5YmNiZjRiZjQ3YWNjYzNkChtbMTszNW0yMDE0LTA5LTI2IDIxOjA0OjQwIE5vIGJ1aWxk
IHNlcnZlZCBmaWxlIC9rYnVpbGQtdGVzdHMvYnVpbGQtc2VydmVkL3g4Nl82NC1yYW5kY29u
ZmlnLXMxLTA5MjQwMzUxLTRjOGM3ZGM3ZWFlZTc2NTFlN2Y1NTE4NzliY2JmNGJmNDdhY2Nj
M2QbWzBtClJldHJ5IGJ1aWxkIC4uCndhaXRpbmcgZm9yIGNvbXBsZXRpb24gb2YgL2tidWls
ZC10ZXN0cy9idWlsZC1xdWV1ZS9zbmItc21va2UveDg2XzY0LXJhbmRjb25maWctczEtMDky
NDAzNTEtNGM4YzdkYzdlYWVlNzY1MWU3ZjU1MTg3OWJjYmY0YmY0N2FjY2MzZAprZXJuZWw6
IC9rZXJuZWwveDg2XzY0LXJhbmRjb25maWctczEtMDkyNDAzNTEvNGM4YzdkYzdlYWVlNzY1
MWU3ZjU1MTg3OWJjYmY0YmY0N2FjY2MzZC92bWxpbnV6LTMuMTcuMC1yYzYtd2wtMDQ0NjEt
ZzRjOGM3ZGMKCjIwMTQtMDktMjYgMjE6MjM6NDAgZGV0ZWN0aW5nIGJvb3Qgc3RhdGUgCTE2
IFRFU1QgRkFJTFVSRQpbICAgIDEuNDgwODM3XSB0c2M6IFJlZmluZWQgVFNDIGNsb2Nrc291
cmNlIGNhbGlicmF0aW9uOiAyNjkzLjUwNiBNSHoKWyAgICAxLjU0MjczMV0gaW5pdFsxXTog
c2VnZmF1bHQgYXQgZmZmZmZmZmZmZjYwMDQwMCBpcCBmZmZmZmZmZmZmNjAwNDAwIHNwIDAw
MDA3ZmZmZDgxYmEwNjggZXJyb3IgMTUKWyAgICAxLjU0NDAyNF0gaW5pdFsxXTogc2VnZmF1
bHQgYXQgZmZmZmZmZmZmZjYwMDQwMCBpcCBmZmZmZmZmZmZmNjAwNDAwIHNwIDAwMDA3ZmZm
ZDgxYjk2NzggZXJyb3IgMTUKWyAgICAxLjU0NTM1MV0gS2VybmVsIHBhbmljIC0gbm90IHN5
bmNpbmc6IEF0dGVtcHRlZCB0byBraWxsIGluaXQhIGV4aXRjb2RlPTB4MDAwMDAwMGIKWyAg
ICAxLjU0NTM1MV0gClsgICAgMS41NDY2MTFdIENQVTogMCBQSUQ6IDEgQ29tbTogaW5pdCBO
b3QgdGFpbnRlZCAzLjE3LjAtcmM2LXdsLTA0NDYxLWc0YzhjN2RjICMxClsgICAgMS41NDc2
MjBdIEhhcmR3YXJlIG5hbWU6IFFFTVUgU3RhbmRhcmQgUEMgKGk0NDBGWCArIFBJSVgsIDE5
OTYpLCBCSU9TIDEuNy41LTIwMTQwNTMxXzA4MzAzMC1nYW5kYWxmIDA0LzAxLzIwMTQKWyAg
ICAxLjU0OTAxNF0gIDAwMDAwMDAwMDAwMDAwMDAgZmZmZjg4MDAxMjg0ZmNiMCBmZmZmZmZm
ZjgxNGEzYmE1IGZmZmY4ODAwMTI4NGZkMzAKWyAgICAxLjU1MDAxMF0gIGZmZmZmZmZmODE0
YTJiMTEgMDAwMDAwMDAwMDAwMDAxMCBmZmZmODgwMDEyODRmZDQwIGZmZmY4ODAwMTI4NGZj
ZDgKWyAgICAxLjU1MDAxMF0gIGZmZmY4ODAwMTI4NGZkNzggMDAwMDAwMDAwMDAwMDAwYiBm
ZmZmODgwMDEyODQ4MDAwIDAwMDAwMDAwMDAwMDAwMDAKWyAgICAxLjU1MDAxMF0gQ2FsbCBU
cmFjZToKWyAgICAxLjU1MDAxMF0gIFs8ZmZmZmZmZmY4MTRhM2JhNT5dIGR1bXBfc3RhY2sr
MHgxOS8weDFiClsgICAgMS41NTAwMTBdICBbPGZmZmZmZmZmODE0YTJiMTE+XSBwYW5pYysw
eGM0LzB4MWVmClsgICAgMS41NTAwMTBdICBbPGZmZmZmZmZmODEwOTBkNjE+XSBkb19leGl0
KzB4M2NhLzB4ODNjClsgICAgMS41NTAwMTBdICBbPGZmZmZmZmZmODExMWEyMmM+XSA/IF9f
a21lbV9jYWNoZV9mcmVlKzB4MTEvMHgyZQpbICAgIDEuNTUwMDEwXSAgWzxmZmZmZmZmZjgx
MTFhMjkzPl0gPyBrbWVtX2NhY2hlX2ZyZWUrMHgzMS8weDMzClsgICAgMS41NTAwMTBdICBb
PGZmZmZmZmZmODEwOTYzZjI+XSA/IF9fc2lncXVldWVfZnJlZSsweDMzLzB4MzYKWyAgICAx
LjU1MDAxMF0gIFs8ZmZmZmZmZmY4MTA5MWVkND5dIGRvX2dyb3VwX2V4aXQrMHg0NS8weGJm
ClsgICAgMS41NTAwMTBdICBbPGZmZmZmZmZmODEwOThmMDA+XSBnZXRfc2lnbmFsKzB4NTNk
LzB4NTY4ClsgICAgMS41NTAwMTBdICBbPGZmZmZmZmZmODEwNDMwMzM+XSA/IGJhZF9hcmVh
X25vc2VtYXBob3JlKzB4ZS8weDEwClsgICAgMS41NTAwMTBdICBbPGZmZmZmZmZmODEwMjgy
MTg+XSBkb19zaWduYWwrMHgyMy8weDg4NQpbICAgIDEuNTUwMDEwXSAgWzxmZmZmZmZmZjgx
NGEwMDAwPl0gPyBzYXZlX21yKzB4MjMvMHgzZQpbICAgIDEuNTUwMDEwXSAgWzxmZmZmZmZm
ZjgxMDI4YTk2Pl0gZG9fbm90aWZ5X3Jlc3VtZSsweDFjLzB4NzUKWyAgICAxLjU1MDAxMF0g
IFs8ZmZmZmZmZmY4MTRhYTEzYj5dIHJldGludF9zaWduYWwrMHg0OC8weDhkClsgICAgMS41
NTAwMTBdIEtlcm5lbCBPZmZzZXQ6IDB4MCBmcm9tIDB4ZmZmZmZmZmY4MTAwMDAwMCAocmVs
b2NhdGlvbiByYW5nZTogMHhmZmZmZmZmZjgwMDAwMDAwLTB4ZmZmZmZmZmY5ZmZmZmZmZikK
CkVsYXBzZWQgdGltZTogNQova2VybmVsL3g4Nl82NC1yYW5kY29uZmlnLXMxLTA5MjQwMzUx
LzRjOGM3ZGM3ZWFlZTc2NTFlN2Y1NTE4NzliY2JmNGJmNDdhY2NjM2QvZG1lc2cteW9jdG8t
aXZiNDEtMTI6MjAxNDA5MjYyMTIzMjc6eDg2XzY0LXJhbmRjb25maWctczEtMDkyNDAzNTE6
Ogova2VybmVsL3g4Nl82NC1yYW5kY29uZmlnLXMxLTA5MjQwMzUxLzRjOGM3ZGM3ZWFlZTc2
NTFlN2Y1NTE4NzliY2JmNGJmNDdhY2NjM2QvZG1lc2cteW9jdG8taXZiNDEtMjQ6MjAxNDA5
MjYyMTIzMjc6eDg2XzY0LXJhbmRjb25maWctczEtMDkyNDAzNTE6Ogova2VybmVsL3g4Nl82
NC1yYW5kY29uZmlnLXMxLTA5MjQwMzUxLzRjOGM3ZGM3ZWFlZTc2NTFlN2Y1NTE4NzliY2Jm
NGJmNDdhY2NjM2QvZG1lc2cteW9jdG8taXZiNDEtMjc6MjAxNDA5MjYyMTIzMjc6eDg2XzY0
LXJhbmRjb25maWctczEtMDkyNDAzNTE6Ogova2VybmVsL3g4Nl82NC1yYW5kY29uZmlnLXMx
LTA5MjQwMzUxLzRjOGM3ZGM3ZWFlZTc2NTFlN2Y1NTE4NzliY2JmNGJmNDdhY2NjM2QvZG1l
c2cteW9jdG8taXZiNDEtOTY6MjAxNDA5MjYyMTIzMjc6eDg2XzY0LXJhbmRjb25maWctczEt
MDkyNDAzNTE6Ogova2VybmVsL3g4Nl82NC1yYW5kY29uZmlnLXMxLTA5MjQwMzUxLzRjOGM3
ZGM3ZWFlZTc2NTFlN2Y1NTE4NzliY2JmNGJmNDdhY2NjM2QvZG1lc2cteW9jdG8tdnAtNTg6
MjAxNDA5MjYyMTIzMjc6eDg2XzY0LXJhbmRjb25maWctczEtMDkyNDAzNTE6My4xNy4wLXJj
Ni13bC0wNDQ2MS1nNGM4YzdkYzoxCjE2OjU6NSBhbGxfZ29vZDpiYWQ6YWxsX2JhZCBib290
cwobWzE7MzVtMjAxNC0wOS0yNiAyMToyNDoxMSBSRVBFQVQgQ09VTlQ6IDUyICAjIC9jL2Jv
b3QtYmlzZWN0L2xpbnV4LTYvb2JqLWJpc2VjdC8ucmVwZWF0G1swbQoKQmlzZWN0aW5nOiA4
NSByZXZpc2lvbnMgbGVmdCB0byB0ZXN0IGFmdGVyIHRoaXMgKHJvdWdobHkgNyBzdGVwcykK
WzM1MWI2NzAwOTc5YjI1YWZkM2JmOWJhYzMyZWJhZDJkMGQ4OWE2OTZdIE1lcmdlICdwaW5j
dHJsL2Zvci1uZXh0JyBpbnRvIGRldmVsLWhvdXJseS0yMDE0MDkyNDAyCnJ1bm5pbmcgL2Mv
a2VybmVsLXRlc3RzL2Jpc2VjdC10ZXN0LWJvb3QtZmFpbHVyZS5zaCAvYy9ib290LWJpc2Vj
dC9saW51eC02L29iai1iaXNlY3QKbHMgLWEgL2tidWlsZC10ZXN0cy9ydW4tcXVldWUva3Zt
L3g4Nl82NC1yYW5kY29uZmlnLXMxLTA5MjQwMzUxL2xpbnV4LWRldmVsOmRldmVsLWhvdXJs
eS0yMDE0MDkyNDAyOjM1MWI2NzAwOTc5YjI1YWZkM2JmOWJhYzMyZWJhZDJkMGQ4OWE2OTY6
YmlzZWN0LWxpbnV4LTYKCjIwMTQtMDktMjYgMjE6MjQ6MTIgMzUxYjY3MDA5NzliMjVhZmQz
YmY5YmFjMzJlYmFkMmQwZDg5YTY5NiBjb21waWxpbmcKUXVldWVkIGJ1aWxkIHRhc2sgdG8g
L2tidWlsZC10ZXN0cy9idWlsZC1xdWV1ZS9zbmIveDg2XzY0LXJhbmRjb25maWctczEtMDky
NDAzNTEtMzUxYjY3MDA5NzliMjVhZmQzYmY5YmFjMzJlYmFkMmQwZDg5YTY5NgpDaGVjayBm
b3Iga2VybmVsIGluIC9rZXJuZWwveDg2XzY0LXJhbmRjb25maWctczEtMDkyNDAzNTEvMzUx
YjY3MDA5NzliMjVhZmQzYmY5YmFjMzJlYmFkMmQwZDg5YTY5Ngp3YWl0aW5nIGZvciBjb21w
bGV0aW9uIG9mIC9rYnVpbGQtdGVzdHMvYnVpbGQtcXVldWUvc25iL3g4Nl82NC1yYW5kY29u
ZmlnLXMxLTA5MjQwMzUxLTM1MWI2NzAwOTc5YjI1YWZkM2JmOWJhYzMyZWJhZDJkMGQ4OWE2
OTYKG1sxOzM1bTIwMTQtMDktMjYgMjE6Mjg6MTIgTm8gYnVpbGQgc2VydmVkIGZpbGUgL2ti
dWlsZC10ZXN0cy9idWlsZC1zZXJ2ZWQveDg2XzY0LXJhbmRjb25maWctczEtMDkyNDAzNTEt
MzUxYjY3MDA5NzliMjVhZmQzYmY5YmFjMzJlYmFkMmQwZDg5YTY5NhtbMG0KUmV0cnkgYnVp
bGQgLi4Kd2FpdGluZyBmb3IgY29tcGxldGlvbiBvZiAva2J1aWxkLXRlc3RzL2J1aWxkLXF1
ZXVlL3NuYi1zbW9rZS94ODZfNjQtcmFuZGNvbmZpZy1zMS0wOTI0MDM1MS0zNTFiNjcwMDk3
OWIyNWFmZDNiZjliYWMzMmViYWQyZDBkODlhNjk2Cmtlcm5lbDogL2tlcm5lbC94ODZfNjQt
cmFuZGNvbmZpZy1zMS0wOTI0MDM1MS8zNTFiNjcwMDk3OWIyNWFmZDNiZjliYWMzMmViYWQy
ZDBkODlhNjk2L3ZtbGludXotMy4xNy4wLXJjNi13bC0wNDM3OC1nMzUxYjY3MAoKMjAxNC0w
OS0yNiAyMTozMDoxMiBkZXRlY3RpbmcgYm9vdCBzdGF0ZSAJNwkxMQkyNQkzOQk0Mgk0NQk1
MAk1MiBTVUNDRVNTCgpCaXNlY3Rpbmc6IDgzIHJldmlzaW9ucyBsZWZ0IHRvIHRlc3QgYWZ0
ZXIgdGhpcyAocm91Z2hseSA3IHN0ZXBzKQpbMzRlOTFkY2U1YjVhMGRmMWRlYTg2MjhkMGFi
OGEzNDkxMjhhNWQ3OF0gTWVyZ2UgJ2x1dG8veDg2L3ZzeXNjYWxsJyBpbnRvIGRldmVsLWhv
dXJseS0yMDE0MDkyNDAyCnJ1bm5pbmcgL2Mva2VybmVsLXRlc3RzL2Jpc2VjdC10ZXN0LWJv
b3QtZmFpbHVyZS5zaCAvYy9ib290LWJpc2VjdC9saW51eC02L29iai1iaXNlY3QKbHMgLWEg
L2tidWlsZC10ZXN0cy9ydW4tcXVldWUva3ZtL3g4Nl82NC1yYW5kY29uZmlnLXMxLTA5MjQw
MzUxL2xpbnV4LWRldmVsOmRldmVsLWhvdXJseS0yMDE0MDkyNDAyOjM0ZTkxZGNlNWI1YTBk
ZjFkZWE4NjI4ZDBhYjhhMzQ5MTI4YTVkNzg6YmlzZWN0LWxpbnV4LTYKCjIwMTQtMDktMjYg
MjE6MzQ6MTMgMzRlOTFkY2U1YjVhMGRmMWRlYTg2MjhkMGFiOGEzNDkxMjhhNWQ3OCBjb21w
aWxpbmcKUXVldWVkIGJ1aWxkIHRhc2sgdG8gL2tidWlsZC10ZXN0cy9idWlsZC1xdWV1ZS9z
bmIveDg2XzY0LXJhbmRjb25maWctczEtMDkyNDAzNTEtMzRlOTFkY2U1YjVhMGRmMWRlYTg2
MjhkMGFiOGEzNDkxMjhhNWQ3OApDaGVjayBmb3Iga2VybmVsIGluIC9rZXJuZWwveDg2XzY0
LXJhbmRjb25maWctczEtMDkyNDAzNTEvMzRlOTFkY2U1YjVhMGRmMWRlYTg2MjhkMGFiOGEz
NDkxMjhhNWQ3OAp3YWl0aW5nIGZvciBjb21wbGV0aW9uIG9mIC9rYnVpbGQtdGVzdHMvYnVp
bGQtcXVldWUvc25iL3g4Nl82NC1yYW5kY29uZmlnLXMxLTA5MjQwMzUxLTM0ZTkxZGNlNWI1
YTBkZjFkZWE4NjI4ZDBhYjhhMzQ5MTI4YTVkNzgKG1sxOzM1bTIwMTQtMDktMjYgMjE6NDI6
MTMgTm8gYnVpbGQgc2VydmVkIGZpbGUgL2tidWlsZC10ZXN0cy9idWlsZC1zZXJ2ZWQveDg2
XzY0LXJhbmRjb25maWctczEtMDkyNDAzNTEtMzRlOTFkY2U1YjVhMGRmMWRlYTg2MjhkMGFi
OGEzNDkxMjhhNWQ3OBtbMG0KUmV0cnkgYnVpbGQgLi4Kd2FpdGluZyBmb3IgY29tcGxldGlv
biBvZiAva2J1aWxkLXRlc3RzL2J1aWxkLXF1ZXVlL3NuYi1zbW9rZS94ODZfNjQtcmFuZGNv
bmZpZy1zMS0wOTI0MDM1MS0zNGU5MWRjZTViNWEwZGYxZGVhODYyOGQwYWI4YTM0OTEyOGE1
ZDc4Cmtlcm5lbDogL2tlcm5lbC94ODZfNjQtcmFuZGNvbmZpZy1zMS0wOTI0MDM1MS8zNGU5
MWRjZTViNWEwZGYxZGVhODYyOGQwYWI4YTM0OTEyOGE1ZDc4L3ZtbGludXotMy4xNy4wLXJj
Ni13bC0wNDM5MC1nMzRlOTFkYwoKMjAxNC0wOS0yNiAyMTo0NjoxMyBkZXRlY3RpbmcgYm9v
dCBzdGF0ZSAuIFRFU1QgRkFJTFVSRQpbICAgIDQuMDc4NDE1XSBpbnB1dDogQVQgVHJhbnNs
YXRlZCBTZXQgMiBrZXlib2FyZCBhcyAvZGV2aWNlcy9wbGF0Zm9ybS9pODA0Mi9zZXJpbzAv
aW5wdXQvaW5wdXQxClsgICAgNC4xNDg1OTldIGluaXRbMV06IHNlZ2ZhdWx0IGF0IGZmZmZm
ZmZmZmY2MDA0MDAgaXAgZmZmZmZmZmZmZjYwMDQwMCBzcCAwMDAwN2ZmZmYyNzlmYmE4IGVy
cm9yIDE1ClsgICAgNC4xNTAyMTldIGluaXRbMV06IHNlZ2ZhdWx0IGF0IGZmZmZmZmZmZmY2
MDA0MDAgaXAgZmZmZmZmZmZmZjYwMDQwMCBzcCAwMDAwN2ZmZmYyNzlmMWI4IGVycm9yIDE1
ClsgICAgNC4xNTE4MTNdIEtlcm5lbCBwYW5pYyAtIG5vdCBzeW5jaW5nOiBBdHRlbXB0ZWQg
dG8ga2lsbCBpbml0ISBleGl0Y29kZT0weDAwMDAwMDBiClsgICAgNC4xNTE4MTNdIApbICAg
IDQuMTUzMzEyXSBDUFU6IDAgUElEOiAxIENvbW06IGluaXQgTm90IHRhaW50ZWQgMy4xNy4w
LXJjNi13bC0wNDM5MC1nMzRlOTFkYyAjMQpbICAgIDQuMTU0NTAzXSBIYXJkd2FyZSBuYW1l
OiBRRU1VIFN0YW5kYXJkIFBDIChpNDQwRlggKyBQSUlYLCAxOTk2KSwgQklPUyAxLjcuNS0y
MDE0MDUzMV8wODMwMzAtZ2FuZGFsZiAwNC8wMS8yMDE0ClsgICAgNC4xNTYxNTZdICAwMDAw
MDAwMDAwMDAwMDAwIGZmZmY4ODAwMTI4NGZjYjAgZmZmZmZmZmY4MTRhM2JhNSBmZmZmODgw
MDEyODRmZDMwClsgICAgNC4xNTc0NjhdICBmZmZmZmZmZjgxNGEyYjExIDAwMDAwMDAwMDAw
MDAwMTAgZmZmZjg4MDAxMjg0ZmQ0MCBmZmZmODgwMDEyODRmY2Q4ClsgICAgNC4xNTg4MTld
ICBmZmZmODgwMDEyODRmZDc4IDAwMDAwMDAwMDAwMDAwMGIgZmZmZjg4MDAxMjg0ODAwMCAw
MDAwMDAwMDAwMDAwMDAwClsgICAgNC4xNjAwODJdIENhbGwgVHJhY2U6ClsgICAgNC4xNjAw
ODJdICBbPGZmZmZmZmZmODE0YTNiYTU+XSBkdW1wX3N0YWNrKzB4MTkvMHgxYgpbICAgIDQu
MTYwMDgyXSAgWzxmZmZmZmZmZjgxNGEyYjExPl0gcGFuaWMrMHhjNC8weDFlZgpbICAgIDQu
MTYwMDgyXSAgWzxmZmZmZmZmZjgxMDkwZDYxPl0gZG9fZXhpdCsweDNjYS8weDgzYwpbICAg
IDQuMTYwMDgyXSAgWzxmZmZmZmZmZjgxMTFhMjJjPl0gPyBfX2ttZW1fY2FjaGVfZnJlZSsw
eDExLzB4MmUKWyAgICA0LjE2MDA4Ml0gIFs8ZmZmZmZmZmY4MTExYTI5Mz5dID8ga21lbV9j
YWNoZV9mcmVlKzB4MzEvMHgzMwpbICAgIDQuMTYwMDgyXSAgWzxmZmZmZmZmZjgxMDk2M2Yy
Pl0gPyBfX3NpZ3F1ZXVlX2ZyZWUrMHgzMy8weDM2ClsgICAgNC4xNjAwODJdICBbPGZmZmZm
ZmZmODEwOTFlZDQ+XSBkb19ncm91cF9leGl0KzB4NDUvMHhiZgpbICAgIDQuMTYwMDgyXSAg
WzxmZmZmZmZmZjgxMDk4ZjAwPl0gZ2V0X3NpZ25hbCsweDUzZC8weDU2OApbICAgIDQuMTYw
MDgyXSAgWzxmZmZmZmZmZjgxMDQzMDMzPl0gPyBiYWRfYXJlYV9ub3NlbWFwaG9yZSsweGUv
MHgxMApbICAgIDQuMTYwMDgyXSAgWzxmZmZmZmZmZjgxMDI4MjE4Pl0gZG9fc2lnbmFsKzB4
MjMvMHg4ODUKWyAgICA0LjE2MDA4Ml0gIFs8ZmZmZmZmZmY4MTRhMDAwMD5dID8gc2F2ZV9t
cisweDIzLzB4M2UKWyAgICA0LjE2MDA4Ml0gIFs8ZmZmZmZmZmY4MTAyOGE5Nj5dIGRvX25v
dGlmeV9yZXN1bWUrMHgxYy8weDc1ClsgICAgNC4xNjAwODJdICBbPGZmZmZmZmZmODE0YWEx
M2I+XSByZXRpbnRfc2lnbmFsKzB4NDgvMHg4ZApbICAgIDQuMTYwMDgyXSBLZXJuZWwgT2Zm
c2V0OiAweDAgZnJvbSAweGZmZmZmZmZmODEwMDAwMDAgKHJlbG9jYXRpb24gcmFuZ2U6IDB4
ZmZmZmZmZmY4MDAwMDAwMC0weGZmZmZmZmZmOWZmZmZmZmYpCgpFbGFwc2VkIHRpbWU6IDEw
Ci9rZXJuZWwveDg2XzY0LXJhbmRjb25maWctczEtMDkyNDAzNTEvMzRlOTFkY2U1YjVhMGRm
MWRlYTg2MjhkMGFiOGEzNDkxMjhhNWQ3OC9kbWVzZy15b2N0by1sa3AtbmV4MDQtMTA5OjIw
MTQwOTI2MjE0NjA5Ong4Nl82NC1yYW5kY29uZmlnLXMxLTA5MjQwMzUxOjoKL2tlcm5lbC94
ODZfNjQtcmFuZGNvbmZpZy1zMS0wOTI0MDM1MS8zNGU5MWRjZTViNWEwZGYxZGVhODYyOGQw
YWI4YTM0OTEyOGE1ZDc4L2RtZXNnLXlvY3RvLWxrcC1uZXgwNC0xMToyMDE0MDkyNjIxNDYw
ODp4ODZfNjQtcmFuZGNvbmZpZy1zMS0wOTI0MDM1MTo6Ci9rZXJuZWwveDg2XzY0LXJhbmRj
b25maWctczEtMDkyNDAzNTEvMzRlOTFkY2U1YjVhMGRmMWRlYTg2MjhkMGFiOGEzNDkxMjhh
NWQ3OC9kbWVzZy15b2N0by1sa3AtbmV4MDQtMTMwOjIwMTQwOTI2MjE0NjA5Ong4Nl82NC1y
YW5kY29uZmlnLXMxLTA5MjQwMzUxOjoKL2tlcm5lbC94ODZfNjQtcmFuZGNvbmZpZy1zMS0w
OTI0MDM1MS8zNGU5MWRjZTViNWEwZGYxZGVhODYyOGQwYWI4YTM0OTEyOGE1ZDc4L2RtZXNn
LXlvY3RvLWxrcC1uZXgwNC0xMzE6MjAxNDA5MjYyMTQ2MDg6eDg2XzY0LXJhbmRjb25maWct
czEtMDkyNDAzNTE6Ogova2VybmVsL3g4Nl82NC1yYW5kY29uZmlnLXMxLTA5MjQwMzUxLzM0
ZTkxZGNlNWI1YTBkZjFkZWE4NjI4ZDBhYjhhMzQ5MTI4YTVkNzgvZG1lc2cteW9jdG8tbGtw
LW5leDA0LTE0MToyMDE0MDkyNjIxNDYwODp4ODZfNjQtcmFuZGNvbmZpZy1zMS0wOTI0MDM1
MTo6Ci9rZXJuZWwveDg2XzY0LXJhbmRjb25maWctczEtMDkyNDAzNTEvMzRlOTFkY2U1YjVh
MGRmMWRlYTg2MjhkMGFiOGEzNDkxMjhhNWQ3OC9kbWVzZy15b2N0by1sa3AtbmV4MDQtMTQ2
OjIwMTQwOTI2MjE0NjEwOng4Nl82NC1yYW5kY29uZmlnLXMxLTA5MjQwMzUxOjoKL2tlcm5l
bC94ODZfNjQtcmFuZGNvbmZpZy1zMS0wOTI0MDM1MS8zNGU5MWRjZTViNWEwZGYxZGVhODYy
OGQwYWI4YTM0OTEyOGE1ZDc4L2RtZXNnLXlvY3RvLWxrcC1uZXgwNC0xNDk6MjAxNDA5MjYy
MTQ2MTA6eDg2XzY0LXJhbmRjb25maWctczEtMDkyNDAzNTE6Ogova2VybmVsL3g4Nl82NC1y
YW5kY29uZmlnLXMxLTA5MjQwMzUxLzM0ZTkxZGNlNWI1YTBkZjFkZWE4NjI4ZDBhYjhhMzQ5
MTI4YTVkNzgvZG1lc2cteW9jdG8tbGtwLW5leDA0LTE3NzoyMDE0MDkyNjIxNDYxMDp4ODZf
NjQtcmFuZGNvbmZpZy1zMS0wOTI0MDM1MTo6Ci9rZXJuZWwveDg2XzY0LXJhbmRjb25maWct
czEtMDkyNDAzNTEvMzRlOTFkY2U1YjVhMGRmMWRlYTg2MjhkMGFiOGEzNDkxMjhhNWQ3OC9k
bWVzZy15b2N0by1sa3AtbmV4MDQtNDA6MjAxNDA5MjYyMTQ2MDg6eDg2XzY0LXJhbmRjb25m
aWctczEtMDkyNDAzNTE6Ogova2VybmVsL3g4Nl82NC1yYW5kY29uZmlnLXMxLTA5MjQwMzUx
LzM0ZTkxZGNlNWI1YTBkZjFkZWE4NjI4ZDBhYjhhMzQ5MTI4YTVkNzgvZG1lc2cteW9jdG8t
bGtwLW5leDA0LTQ0OjIwMTQwOTI2MjE0NjA4Ong4Nl82NC1yYW5kY29uZmlnLXMxLTA5MjQw
MzUxOjoKL2tlcm5lbC94ODZfNjQtcmFuZGNvbmZpZy1zMS0wOTI0MDM1MS8zNGU5MWRjZTVi
NWEwZGYxZGVhODYyOGQwYWI4YTM0OTEyOGE1ZDc4L2RtZXNnLXlvY3RvLWxrcC1uZXgwNC02
ODoyMDE0MDkyNjIxNDYwODp4ODZfNjQtcmFuZGNvbmZpZy1zMS0wOTI0MDM1MTo6Ci9rZXJu
ZWwveDg2XzY0LXJhbmRjb25maWctczEtMDkyNDAzNTEvMzRlOTFkY2U1YjVhMGRmMWRlYTg2
MjhkMGFiOGEzNDkxMjhhNWQ3OC9kbWVzZy15b2N0by1sa3AtbmV4MDQtNzA6MjAxNDA5MjYy
MTQ2MDg6eDg2XzY0LXJhbmRjb25maWctczEtMDkyNDAzNTE6Ogova2VybmVsL3g4Nl82NC1y
YW5kY29uZmlnLXMxLTA5MjQwMzUxLzM0ZTkxZGNlNWI1YTBkZjFkZWE4NjI4ZDBhYjhhMzQ5
MTI4YTVkNzgvZG1lc2cteW9jdG8tbGtwLW5leDA0LTc1OjIwMTQwOTI2MjE0NjA4Ong4Nl82
NC1yYW5kY29uZmlnLXMxLTA5MjQwMzUxOjoKL2tlcm5lbC94ODZfNjQtcmFuZGNvbmZpZy1z
MS0wOTI0MDM1MS8zNGU5MWRjZTViNWEwZGYxZGVhODYyOGQwYWI4YTM0OTEyOGE1ZDc4L2Rt
ZXNnLXlvY3RvLWxrcC1uZXgwNC04MzoyMDE0MDkyNjIxNDYxMDp4ODZfNjQtcmFuZGNvbmZp
Zy1zMS0wOTI0MDM1MTo6Ci9rZXJuZWwveDg2XzY0LXJhbmRjb25maWctczEtMDkyNDAzNTEv
MzRlOTFkY2U1YjVhMGRmMWRlYTg2MjhkMGFiOGEzNDkxMjhhNWQ3OC9kbWVzZy15b2N0by1s
a3AtbmV4MDQtODk6MjAxNDA5MjYyMTQ2MTA6eDg2XzY0LXJhbmRjb25maWctczEtMDkyNDAz
NTE6Ogova2VybmVsL3g4Nl82NC1yYW5kY29uZmlnLXMxLTA5MjQwMzUxLzM0ZTkxZGNlNWI1
YTBkZjFkZWE4NjI4ZDBhYjhhMzQ5MTI4YTVkNzgvZG1lc2cteW9jdG8tbGtwLW5leDA0LTk5
OjIwMTQwOTI2MjE0NjEwOng4Nl82NC1yYW5kY29uZmlnLXMxLTA5MjQwMzUxOjoKL2tlcm5l
bC94ODZfNjQtcmFuZGNvbmZpZy1zMS0wOTI0MDM1MS8zNGU5MWRjZTViNWEwZGYxZGVhODYy
OGQwYWI4YTM0OTEyOGE1ZDc4L2RtZXNnLXlvY3RvLWxrcC1uZXgwNC0xMDU6MjAxNDA5MjYy
MTQ2MTU6eDg2XzY0LXJhbmRjb25maWctczEtMDkyNDAzNTE6Ogova2VybmVsL3g4Nl82NC1y
YW5kY29uZmlnLXMxLTA5MjQwMzUxLzM0ZTkxZGNlNWI1YTBkZjFkZWE4NjI4ZDBhYjhhMzQ5
MTI4YTVkNzgvZG1lc2cteW9jdG8tbGtwLW5leDA0LTExMDoyMDE0MDkyNjIxNDYxNTp4ODZf
NjQtcmFuZGNvbmZpZy1zMS0wOTI0MDM1MTo6Ci9rZXJuZWwveDg2XzY0LXJhbmRjb25maWct
czEtMDkyNDAzNTEvMzRlOTFkY2U1YjVhMGRmMWRlYTg2MjhkMGFiOGEzNDkxMjhhNWQ3OC9k
bWVzZy15b2N0by1sa3AtbmV4MDQtMTEzOjIwMTQwOTI2MjE0NjE1Ong4Nl82NC1yYW5kY29u
ZmlnLXMxLTA5MjQwMzUxOjoKL2tlcm5lbC94ODZfNjQtcmFuZGNvbmZpZy1zMS0wOTI0MDM1
MS8zNGU5MWRjZTViNWEwZGYxZGVhODYyOGQwYWI4YTM0OTEyOGE1ZDc4L2RtZXNnLXlvY3Rv
LWxrcC1uZXgwNC0xMTQ6MjAxNDA5MjYyMTQ2MTU6eDg2XzY0LXJhbmRjb25maWctczEtMDky
NDAzNTE6Ogova2VybmVsL3g4Nl82NC1yYW5kY29uZmlnLXMxLTA5MjQwMzUxLzM0ZTkxZGNl
NWI1YTBkZjFkZWE4NjI4ZDBhYjhhMzQ5MTI4YTVkNzgvZG1lc2cteW9jdG8tbGtwLW5leDA0
LTEyMjoyMDE0MDkyNjIxNDYxNTp4ODZfNjQtcmFuZGNvbmZpZy1zMS0wOTI0MDM1MTo6Ci9r
ZXJuZWwveDg2XzY0LXJhbmRjb25maWctczEtMDkyNDAzNTEvMzRlOTFkY2U1YjVhMGRmMWRl
YTg2MjhkMGFiOGEzNDkxMjhhNWQ3OC9kbWVzZy15b2N0by1sa3AtbmV4MDQtMTI5OjIwMTQw
OTI2MjE0NjE1Ong4Nl82NC1yYW5kY29uZmlnLXMxLTA5MjQwMzUxOjoKL2tlcm5lbC94ODZf
NjQtcmFuZGNvbmZpZy1zMS0wOTI0MDM1MS8zNGU5MWRjZTViNWEwZGYxZGVhODYyOGQwYWI4
YTM0OTEyOGE1ZDc4L2RtZXNnLXlvY3RvLWxrcC1uZXgwNC0xMzM6MjAxNDA5MjYyMTQ2MTU6
eDg2XzY0LXJhbmRjb25maWctczEtMDkyNDAzNTE6Ogova2VybmVsL3g4Nl82NC1yYW5kY29u
ZmlnLXMxLTA5MjQwMzUxLzM0ZTkxZGNlNWI1YTBkZjFkZWE4NjI4ZDBhYjhhMzQ5MTI4YTVk
NzgvZG1lc2cteW9jdG8tbGtwLW5leDA0LTEzNToyMDE0MDkyNjIxNDYxNTp4ODZfNjQtcmFu
ZGNvbmZpZy1zMS0wOTI0MDM1MTo6Ci9rZXJuZWwveDg2XzY0LXJhbmRjb25maWctczEtMDky
NDAzNTEvMzRlOTFkY2U1YjVhMGRmMWRlYTg2MjhkMGFiOGEzNDkxMjhhNWQ3OC9kbWVzZy15
b2N0by1sa3AtbmV4MDQtMTM4OjIwMTQwOTI2MjE0NjE1Ong4Nl82NC1yYW5kY29uZmlnLXMx
LTA5MjQwMzUxOjoKL2tlcm5lbC94ODZfNjQtcmFuZGNvbmZpZy1zMS0wOTI0MDM1MS8zNGU5
MWRjZTViNWEwZGYxZGVhODYyOGQwYWI4YTM0OTEyOGE1ZDc4L2RtZXNnLXlvY3RvLWxrcC1u
ZXgwNC0xNDA6MjAxNDA5MjYyMTQ2MjA6eDg2XzY0LXJhbmRjb25maWctczEtMDkyNDAzNTE6
Ogova2VybmVsL3g4Nl82NC1yYW5kY29uZmlnLXMxLTA5MjQwMzUxLzM0ZTkxZGNlNWI1YTBk
ZjFkZWE4NjI4ZDBhYjhhMzQ5MTI4YTVkNzgvZG1lc2cteW9jdG8tbGtwLW5leDA0LTE0NToy
MDE0MDkyNjIxNDYxNTp4ODZfNjQtcmFuZGNvbmZpZy1zMS0wOTI0MDM1MTo6Ci9rZXJuZWwv
eDg2XzY0LXJhbmRjb25maWctczEtMDkyNDAzNTEvMzRlOTFkY2U1YjVhMGRmMWRlYTg2Mjhk
MGFiOGEzNDkxMjhhNWQ3OC9kbWVzZy15b2N0by1sa3AtbmV4MDQtMTUwOjIwMTQwOTI2MjE0
NjE1Ong4Nl82NC1yYW5kY29uZmlnLXMxLTA5MjQwMzUxOjoKL2tlcm5lbC94ODZfNjQtcmFu
ZGNvbmZpZy1zMS0wOTI0MDM1MS8zNGU5MWRjZTViNWEwZGYxZGVhODYyOGQwYWI4YTM0OTEy
OGE1ZDc4L2RtZXNnLXlvY3RvLWxrcC1uZXgwNC0xNTQ6MjAxNDA5MjYyMTQ2MTU6eDg2XzY0
LXJhbmRjb25maWctczEtMDkyNDAzNTE6Ogova2VybmVsL3g4Nl82NC1yYW5kY29uZmlnLXMx
LTA5MjQwMzUxLzM0ZTkxZGNlNWI1YTBkZjFkZWE4NjI4ZDBhYjhhMzQ5MTI4YTVkNzgvZG1l
c2cteW9jdG8tbGtwLW5leDA0LTE1NzoyMDE0MDkyNjIxNDYxNTp4ODZfNjQtcmFuZGNvbmZp
Zy1zMS0wOTI0MDM1MTo6Ci9rZXJuZWwveDg2XzY0LXJhbmRjb25maWctczEtMDkyNDAzNTEv
MzRlOTFkY2U1YjVhMGRmMWRlYTg2MjhkMGFiOGEzNDkxMjhhNWQ3OC9kbWVzZy15b2N0by1s
a3AtbmV4MDQtMTU5OjIwMTQwOTI2MjE0NjE1Ong4Nl82NC1yYW5kY29uZmlnLXMxLTA5MjQw
MzUxOjoKL2tlcm5lbC94ODZfNjQtcmFuZGNvbmZpZy1zMS0wOTI0MDM1MS8zNGU5MWRjZTVi
NWEwZGYxZGVhODYyOGQwYWI4YTM0OTEyOGE1ZDc4L2RtZXNnLXlvY3RvLWxrcC1uZXgwNC0x
NToyMDE0MDkyNjIxNDYyMDp4ODZfNjQtcmFuZGNvbmZpZy1zMS0wOTI0MDM1MTo6Ci9rZXJu
ZWwveDg2XzY0LXJhbmRjb25maWctczEtMDkyNDAzNTEvMzRlOTFkY2U1YjVhMGRmMWRlYTg2
MjhkMGFiOGEzNDkxMjhhNWQ3OC9kbWVzZy15b2N0by1sa3AtbmV4MDQtMTY0OjIwMTQwOTI2
MjE0NjE1Ong4Nl82NC1yYW5kY29uZmlnLXMxLTA5MjQwMzUxOjoKL2tlcm5lbC94ODZfNjQt
cmFuZGNvbmZpZy1zMS0wOTI0MDM1MS8zNGU5MWRjZTViNWEwZGYxZGVhODYyOGQwYWI4YTM0
OTEyOGE1ZDc4L2RtZXNnLXlvY3RvLWxrcC1uZXgwNC0xNjg6MjAxNDA5MjYyMTQ2MTU6eDg2
XzY0LXJhbmRjb25maWctczEtMDkyNDAzNTE6Ogova2VybmVsL3g4Nl82NC1yYW5kY29uZmln
LXMxLTA5MjQwMzUxLzM0ZTkxZGNlNWI1YTBkZjFkZWE4NjI4ZDBhYjhhMzQ5MTI4YTVkNzgv
ZG1lc2cteW9jdG8tbGtwLW5leDA0LTE3MDoyMDE0MDkyNjIxNDYxNTp4ODZfNjQtcmFuZGNv
bmZpZy1zMS0wOTI0MDM1MTo6Ci9rZXJuZWwveDg2XzY0LXJhbmRjb25maWctczEtMDkyNDAz
NTEvMzRlOTFkY2U1YjVhMGRmMWRlYTg2MjhkMGFiOGEzNDkxMjhhNWQ3OC9kbWVzZy15b2N0
by1sa3AtbmV4MDQtMTc2OjIwMTQwOTI2MjE0NjE1Ong4Nl82NC1yYW5kY29uZmlnLXMxLTA5
MjQwMzUxOjoKL2tlcm5lbC94ODZfNjQtcmFuZGNvbmZpZy1zMS0wOTI0MDM1MS8zNGU5MWRj
ZTViNWEwZGYxZGVhODYyOGQwYWI4YTM0OTEyOGE1ZDc4L2RtZXNnLXlvY3RvLWxrcC1uZXgw
NC0xNzoyMDE0MDkyNjIxNDYxNTp4ODZfNjQtcmFuZGNvbmZpZy1zMS0wOTI0MDM1MTo6Ci9r
ZXJuZWwveDg2XzY0LXJhbmRjb25maWctczEtMDkyNDAzNTEvMzRlOTFkY2U1YjVhMGRmMWRl
YTg2MjhkMGFiOGEzNDkxMjhhNWQ3OC9kbWVzZy15b2N0by1sa3AtbmV4MDQtMTkxOjIwMTQw
OTI2MjE0NjE1Ong4Nl82NC1yYW5kY29uZmlnLXMxLTA5MjQwMzUxOjoKL2tlcm5lbC94ODZf
NjQtcmFuZGNvbmZpZy1zMS0wOTI0MDM1MS8zNGU5MWRjZTViNWEwZGYxZGVhODYyOGQwYWI4
YTM0OTEyOGE1ZDc4L2RtZXNnLXlvY3RvLWxrcC1uZXgwNC0yOToyMDE0MDkyNjIxNDYxNTp4
ODZfNjQtcmFuZGNvbmZpZy1zMS0wOTI0MDM1MTo6Ci9rZXJuZWwveDg2XzY0LXJhbmRjb25m
aWctczEtMDkyNDAzNTEvMzRlOTFkY2U1YjVhMGRmMWRlYTg2MjhkMGFiOGEzNDkxMjhhNWQ3
OC9kbWVzZy15b2N0by1sa3AtbmV4MDQtMzM6MjAxNDA5MjYyMTQ2MTU6eDg2XzY0LXJhbmRj
b25maWctczEtMDkyNDAzNTE6Ogova2VybmVsL3g4Nl82NC1yYW5kY29uZmlnLXMxLTA5MjQw
MzUxLzM0ZTkxZGNlNWI1YTBkZjFkZWE4NjI4ZDBhYjhhMzQ5MTI4YTVkNzgvZG1lc2cteW9j
dG8tbGtwLW5leDA0LTM6MjAxNDA5MjYyMTQ2MjA6eDg2XzY0LXJhbmRjb25maWctczEtMDky
NDAzNTE6Ogova2VybmVsL3g4Nl82NC1yYW5kY29uZmlnLXMxLTA5MjQwMzUxLzM0ZTkxZGNl
NWI1YTBkZjFkZWE4NjI4ZDBhYjhhMzQ5MTI4YTVkNzgvZG1lc2cteW9jdG8tbGtwLW5leDA0
LTQ2OjIwMTQwOTI2MjE0NjE1Ong4Nl82NC1yYW5kY29uZmlnLXMxLTA5MjQwMzUxOjoKL2tl
cm5lbC94ODZfNjQtcmFuZGNvbmZpZy1zMS0wOTI0MDM1MS8zNGU5MWRjZTViNWEwZGYxZGVh
ODYyOGQwYWI4YTM0OTEyOGE1ZDc4L2RtZXNnLXlvY3RvLWxrcC1uZXgwNC01MzoyMDE0MDky
NjIxNDYxNTp4ODZfNjQtcmFuZGNvbmZpZy1zMS0wOTI0MDM1MTo6Ci9rZXJuZWwveDg2XzY0
LXJhbmRjb25maWctczEtMDkyNDAzNTEvMzRlOTFkY2U1YjVhMGRmMWRlYTg2MjhkMGFiOGEz
NDkxMjhhNWQ3OC9kbWVzZy15b2N0by1sa3AtbmV4MDQtNjE6MjAxNDA5MjYyMTQ2MTU6eDg2
XzY0LXJhbmRjb25maWctczEtMDkyNDAzNTE6Ogova2VybmVsL3g4Nl82NC1yYW5kY29uZmln
LXMxLTA5MjQwMzUxLzM0ZTkxZGNlNWI1YTBkZjFkZWE4NjI4ZDBhYjhhMzQ5MTI4YTVkNzgv
ZG1lc2cteW9jdG8tbGtwLW5leDA0LTY1OjIwMTQwOTI2MjE0NjE1Ong4Nl82NC1yYW5kY29u
ZmlnLXMxLTA5MjQwMzUxOjoKL2tlcm5lbC94ODZfNjQtcmFuZGNvbmZpZy1zMS0wOTI0MDM1
MS8zNGU5MWRjZTViNWEwZGYxZGVhODYyOGQwYWI4YTM0OTEyOGE1ZDc4L2RtZXNnLXlvY3Rv
LWxrcC1uZXgwNC02OToyMDE0MDkyNjIxNDYxNTp4ODZfNjQtcmFuZGNvbmZpZy1zMS0wOTI0
MDM1MTo6Ci9rZXJuZWwveDg2XzY0LXJhbmRjb25maWctczEtMDkyNDAzNTEvMzRlOTFkY2U1
YjVhMGRmMWRlYTg2MjhkMGFiOGEzNDkxMjhhNWQ3OC9kbWVzZy15b2N0by1sa3AtbmV4MDQt
NzM6MjAxNDA5MjYyMTQ2MTU6eDg2XzY0LXJhbmRjb25maWctczEtMDkyNDAzNTE6Ogova2Vy
bmVsL3g4Nl82NC1yYW5kY29uZmlnLXMxLTA5MjQwMzUxLzM0ZTkxZGNlNWI1YTBkZjFkZWE4
NjI4ZDBhYjhhMzQ5MTI4YTVkNzgvZG1lc2cteW9jdG8tbGtwLW5leDA0LTc2OjIwMTQwOTI2
MjE0NjE1Ong4Nl82NC1yYW5kY29uZmlnLXMxLTA5MjQwMzUxOjoKL2tlcm5lbC94ODZfNjQt
cmFuZGNvbmZpZy1zMS0wOTI0MDM1MS8zNGU5MWRjZTViNWEwZGYxZGVhODYyOGQwYWI4YTM0
OTEyOGE1ZDc4L2RtZXNnLXlvY3RvLWxrcC1uZXgwNC03OToyMDE0MDkyNjIxNDYxNTp4ODZf
NjQtcmFuZGNvbmZpZy1zMS0wOTI0MDM1MTo6Ci9rZXJuZWwveDg2XzY0LXJhbmRjb25maWct
czEtMDkyNDAzNTEvMzRlOTFkY2U1YjVhMGRmMWRlYTg2MjhkMGFiOGEzNDkxMjhhNWQ3OC9k
bWVzZy15b2N0by1sa3AtbmV4MDQtODI6MjAxNDA5MjYyMTQ2MTU6eDg2XzY0LXJhbmRjb25m
aWctczEtMDkyNDAzNTE6Ogova2VybmVsL3g4Nl82NC1yYW5kY29uZmlnLXMxLTA5MjQwMzUx
LzM0ZTkxZGNlNWI1YTBkZjFkZWE4NjI4ZDBhYjhhMzQ5MTI4YTVkNzgvZG1lc2cteW9jdG8t
bGtwLW5leDA0LTkyOjIwMTQwOTI2MjE0NjE1Ong4Nl82NC1yYW5kY29uZmlnLXMxLTA5MjQw
MzUxOjoKL2tlcm5lbC94ODZfNjQtcmFuZGNvbmZpZy1zMS0wOTI0MDM1MS8zNGU5MWRjZTVi
NWEwZGYxZGVhODYyOGQwYWI4YTM0OTEyOGE1ZDc4L2RtZXNnLXlvY3RvLWxrcC1uZXgwNC05
ODoyMDE0MDkyNjIxNDYxNTp4ODZfNjQtcmFuZGNvbmZpZy1zMS0wOTI0MDM1MTo6CjA6NTI6
NTIgYWxsX2dvb2Q6YmFkOmFsbF9iYWQgYm9vdHMKCmxpbmVhci1iaXNlY3Q6IGJhZCBicmFu
Y2ggbWF5IGJlIGx1dG8veDg2L3ZzeXNjYWxsCmxpbmVhci1iaXNlY3Q6IGhhbmRsZSBvdmVy
IHRvIGdpdCBiaXNlY3QKbGluZWFyLWJpc2VjdDogZ2l0IGJpc2VjdCBzdGFydCAzNGU5MWRj
ZTViNWEwZGYxZGVhODYyOGQwYWI4YTM0OTEyOGE1ZDc4IDM1MWI2NzAwOTc5YjI1YWZkM2Jm
OWJhYzMyZWJhZDJkMGQ4OWE2OTYgLS0KUHJldmlvdXMgSEVBRCBwb3NpdGlvbiB3YXMgMzRl
OTFkYy4uLiBNZXJnZSAnbHV0by94ODYvdnN5c2NhbGwnIGludG8gZGV2ZWwtaG91cmx5LTIw
MTQwOTI0MDIKSEVBRCBpcyBub3cgYXQgYjRkMzMxOC4uLiBNZXJnZSByZW1vdGUtdHJhY2tp
bmcgYnJhbmNoICdjcnlwdG8vbWFzdGVyJwpCaXNlY3Rpbmc6IDUgcmV2aXNpb25zIGxlZnQg
dG8gdGVzdCBhZnRlciB0aGlzIChyb3VnaGx5IDMgc3RlcHMpCltmY2ZlZTZmODc0OWFmMTRk
OTYzNzNhOWUyNjU2MzU0YWQwYjk1NDk5XSB4ODZfNjQsdmRzbzogUmVtb3ZlIGppZmZpZXMg
ZnJvbSB0aGUgdnZhciBwYWdlCmxpbmVhci1iaXNlY3Q6IGdpdCBiaXNlY3QgcnVuIC9jL2tl
cm5lbC10ZXN0cy9iaXNlY3QtdGVzdC1ib290LWZhaWx1cmUuc2ggL2MvYm9vdC1iaXNlY3Qv
bGludXgtNi9vYmotYmlzZWN0CnJ1bm5pbmcgL2Mva2VybmVsLXRlc3RzL2Jpc2VjdC10ZXN0
LWJvb3QtZmFpbHVyZS5zaCAvYy9ib290LWJpc2VjdC9saW51eC02L29iai1iaXNlY3QKbHMg
LWEgL2tidWlsZC10ZXN0cy9ydW4tcXVldWUva3ZtL3g4Nl82NC1yYW5kY29uZmlnLXMxLTA5
MjQwMzUxL2xpbnV4LWRldmVsOmRldmVsLWhvdXJseS0yMDE0MDkyNDAyOmZjZmVlNmY4NzQ5
YWYxNGQ5NjM3M2E5ZTI2NTYzNTRhZDBiOTU0OTk6YmlzZWN0LWxpbnV4LTYKCjIwMTQtMDkt
MjYgMjE6NDY6NTIgZmNmZWU2Zjg3NDlhZjE0ZDk2MzczYTllMjY1NjM1NGFkMGI5NTQ5OSBj
b21waWxpbmcKUXVldWVkIGJ1aWxkIHRhc2sgdG8gL2tidWlsZC10ZXN0cy9idWlsZC1xdWV1
ZS9zbmIveDg2XzY0LXJhbmRjb25maWctczEtMDkyNDAzNTEtZmNmZWU2Zjg3NDlhZjE0ZDk2
MzczYTllMjY1NjM1NGFkMGI5NTQ5OQpDaGVjayBmb3Iga2VybmVsIGluIC9rZXJuZWwveDg2
XzY0LXJhbmRjb25maWctczEtMDkyNDAzNTEvZmNmZWU2Zjg3NDlhZjE0ZDk2MzczYTllMjY1
NjM1NGFkMGI5NTQ5OQp3YWl0aW5nIGZvciBjb21wbGV0aW9uIG9mIC9rYnVpbGQtdGVzdHMv
YnVpbGQtcXVldWUvc25iL3g4Nl82NC1yYW5kY29uZmlnLXMxLTA5MjQwMzUxLWZjZmVlNmY4
NzQ5YWYxNGQ5NjM3M2E5ZTI2NTYzNTRhZDBiOTU0OTkKG1sxOzM1bTIwMTQtMDktMjYgMjE6
NTE6NTIgTm8gYnVpbGQgc2VydmVkIGZpbGUgL2tidWlsZC10ZXN0cy9idWlsZC1zZXJ2ZWQv
eDg2XzY0LXJhbmRjb25maWctczEtMDkyNDAzNTEtZmNmZWU2Zjg3NDlhZjE0ZDk2MzczYTll
MjY1NjM1NGFkMGI5NTQ5ORtbMG0KUmV0cnkgYnVpbGQgLi4Kd2FpdGluZyBmb3IgY29tcGxl
dGlvbiBvZiAva2J1aWxkLXRlc3RzL2J1aWxkLXF1ZXVlL3NuYi1zbW9rZS94ODZfNjQtcmFu
ZGNvbmZpZy1zMS0wOTI0MDM1MS1mY2ZlZTZmODc0OWFmMTRkOTYzNzNhOWUyNjU2MzU0YWQw
Yjk1NDk5Cmtlcm5lbDogL2tlcm5lbC94ODZfNjQtcmFuZGNvbmZpZy1zMS0wOTI0MDM1MS9m
Y2ZlZTZmODc0OWFmMTRkOTYzNzNhOWUyNjU2MzU0YWQwYjk1NDk5L3ZtbGludXotMy4xNy4w
LXJjMS0wMDE2NC1nZmNmZWU2ZgoKMjAxNC0wOS0yNiAyMTo1NDo1MiBkZXRlY3RpbmcgYm9v
dCBzdGF0ZSAJMQkzCTgJMTgJMjQJMjcJNDUuCTUyIFNVQ0NFU1MKCkJpc2VjdGluZzogMiBy
ZXZpc2lvbnMgbGVmdCB0byB0ZXN0IGFmdGVyIHRoaXMgKHJvdWdobHkgMiBzdGVwcykKWzJk
ZWUxMWMwZWI0ZWI5YTc2N2ZhODc3NjRjOTFmZGExOGQxNGVmZjFdIHg4Nl82NCx2c3lzY2Fs
bDogVHVybiB2c3lzY2FsbHMgYWxsIHRoZSB3YXkgb2ZmIHdoZW4gdnN5c2NhbGw9bm9uZQpy
dW5uaW5nIC9jL2tlcm5lbC10ZXN0cy9iaXNlY3QtdGVzdC1ib290LWZhaWx1cmUuc2ggL2Mv
Ym9vdC1iaXNlY3QvbGludXgtNi9vYmotYmlzZWN0CmxzIC1hIC9rYnVpbGQtdGVzdHMvcnVu
LXF1ZXVlL2t2bS94ODZfNjQtcmFuZGNvbmZpZy1zMS0wOTI0MDM1MS9saW51eC1kZXZlbDpk
ZXZlbC1ob3VybHktMjAxNDA5MjQwMjoyZGVlMTFjMGViNGViOWE3NjdmYTg3NzY0YzkxZmRh
MThkMTRlZmYxOmJpc2VjdC1saW51eC02CgoyMDE0LTA5LTI2IDIxOjU5OjIzIDJkZWUxMWMw
ZWI0ZWI5YTc2N2ZhODc3NjRjOTFmZGExOGQxNGVmZjEgY29tcGlsaW5nClF1ZXVlZCBidWls
ZCB0YXNrIHRvIC9rYnVpbGQtdGVzdHMvYnVpbGQtcXVldWUvc25iL3g4Nl82NC1yYW5kY29u
ZmlnLXMxLTA5MjQwMzUxLTJkZWUxMWMwZWI0ZWI5YTc2N2ZhODc3NjRjOTFmZGExOGQxNGVm
ZjEKQ2hlY2sgZm9yIGtlcm5lbCBpbiAva2VybmVsL3g4Nl82NC1yYW5kY29uZmlnLXMxLTA5
MjQwMzUxLzJkZWUxMWMwZWI0ZWI5YTc2N2ZhODc3NjRjOTFmZGExOGQxNGVmZjEKd2FpdGlu
ZyBmb3IgY29tcGxldGlvbiBvZiAva2J1aWxkLXRlc3RzL2J1aWxkLXF1ZXVlL3NuYi1zbW9r
ZS94ODZfNjQtcmFuZGNvbmZpZy1zMS0wOTI0MDM1MS0yZGVlMTFjMGViNGViOWE3NjdmYTg3
NzY0YzkxZmRhMThkMTRlZmYxCmtlcm5lbDogL2tlcm5lbC94ODZfNjQtcmFuZGNvbmZpZy1z
MS0wOTI0MDM1MS8yZGVlMTFjMGViNGViOWE3NjdmYTg3NzY0YzkxZmRhMThkMTRlZmYxL3Zt
bGludXotMy4xNy4wLXJjMS0wMDE2Ny1nMmRlZTExYwoKMjAxNC0wOS0yNiAyMjowMzoyMyBk
ZXRlY3RpbmcgYm9vdCBzdGF0ZSAJMwk0CTI0CTI4CTQwCTQyCTQ2CTQ5CTUyIFNVQ0NFU1MK
CkJpc2VjdGluZzogMCByZXZpc2lvbnMgbGVmdCB0byB0ZXN0IGFmdGVyIHRoaXMgKHJvdWdo
bHkgMSBzdGVwKQpbY2FhZTIwNGJlMTg0YTU3NWFmMmMwMmI4MzdkODE4Mjc4ZjkyMTMyM10g
eDg2XzY0LHZzeXNjYWxsOiBNYWtlIHZzeXNjYWxsIGVtdWxhdGlvbiBjb25maWd1cmFibGUK
cnVubmluZyAvYy9rZXJuZWwtdGVzdHMvYmlzZWN0LXRlc3QtYm9vdC1mYWlsdXJlLnNoIC9j
L2Jvb3QtYmlzZWN0L2xpbnV4LTYvb2JqLWJpc2VjdApscyAtYSAva2J1aWxkLXRlc3RzL3J1
bi1xdWV1ZS9rdm0veDg2XzY0LXJhbmRjb25maWctczEtMDkyNDAzNTEvbGludXgtZGV2ZWw6
ZGV2ZWwtaG91cmx5LTIwMTQwOTI0MDI6Y2FhZTIwNGJlMTg0YTU3NWFmMmMwMmI4MzdkODE4
Mjc4ZjkyMTMyMzpiaXNlY3QtbGludXgtNgoKMjAxNC0wOS0yNiAyMjowNzo1NCBjYWFlMjA0
YmUxODRhNTc1YWYyYzAyYjgzN2Q4MTgyNzhmOTIxMzIzIGNvbXBpbGluZwpRdWV1ZWQgYnVp
bGQgdGFzayB0byAva2J1aWxkLXRlc3RzL2J1aWxkLXF1ZXVlL3NuYi94ODZfNjQtcmFuZGNv
bmZpZy1zMS0wOTI0MDM1MS1jYWFlMjA0YmUxODRhNTc1YWYyYzAyYjgzN2Q4MTgyNzhmOTIx
MzIzCkNoZWNrIGZvciBrZXJuZWwgaW4gL2tlcm5lbC94ODZfNjQtcmFuZGNvbmZpZy1zMS0w
OTI0MDM1MS9jYWFlMjA0YmUxODRhNTc1YWYyYzAyYjgzN2Q4MTgyNzhmOTIxMzIzCndhaXRp
bmcgZm9yIGNvbXBsZXRpb24gb2YgL2tidWlsZC10ZXN0cy9idWlsZC1xdWV1ZS9zbmIveDg2
XzY0LXJhbmRjb25maWctczEtMDkyNDAzNTEtY2FhZTIwNGJlMTg0YTU3NWFmMmMwMmI4Mzdk
ODE4Mjc4ZjkyMTMyMwobWzE7MzVtMjAxNC0wOS0yNiAyMjoxMTo1NCBObyBidWlsZCBzZXJ2
ZWQgZmlsZSAva2J1aWxkLXRlc3RzL2J1aWxkLXNlcnZlZC94ODZfNjQtcmFuZGNvbmZpZy1z
MS0wOTI0MDM1MS1jYWFlMjA0YmUxODRhNTc1YWYyYzAyYjgzN2Q4MTgyNzhmOTIxMzIzG1sw
bQpSZXRyeSBidWlsZCAuLgp3YWl0aW5nIGZvciBjb21wbGV0aW9uIG9mIC9rYnVpbGQtdGVz
dHMvYnVpbGQtcXVldWUvc25iLXNtb2tlL3g4Nl82NC1yYW5kY29uZmlnLXMxLTA5MjQwMzUx
LWNhYWUyMDRiZTE4NGE1NzVhZjJjMDJiODM3ZDgxODI3OGY5MjEzMjMKa2VybmVsOiAva2Vy
bmVsL3g4Nl82NC1yYW5kY29uZmlnLXMxLTA5MjQwMzUxL2NhYWUyMDRiZTE4NGE1NzVhZjJj
MDJiODM3ZDgxODI3OGY5MjEzMjMvdm1saW51ei0zLjE3LjAtcmMxLTAwMTY5LWdjYWFlMjA0
CgoyMDE0LTA5LTI2IDIyOjEzOjU0IGRldGVjdGluZyBib290IHN0YXRlIC4gVEVTVCBGQUlM
VVJFClsgICAgMy44NTIzMzBdIGlucHV0OiBBVCBUcmFuc2xhdGVkIFNldCAyIGtleWJvYXJk
IGFzIC9kZXZpY2VzL3BsYXRmb3JtL2k4MDQyL3NlcmlvMC9pbnB1dC9pbnB1dDEKWyAgICAz
Ljk4NDM4M10gaW5pdFsxXTogc2VnZmF1bHQgYXQgZmZmZmZmZmZmZjYwMDQwMCBpcCBmZmZm
ZmZmZmZmNjAwNDAwIHNwIDAwMDA3ZmZmYmFkOGRkMzggZXJyb3IgMTUKWyAgICA0LjAxMDI4
Ml0gaW5pdFsxXTogc2VnZmF1bHQgYXQgZmZmZmZmZmZmZjYwMDQwMCBpcCBmZmZmZmZmZmZm
NjAwNDAwIHNwIDAwMDA3ZmZmYmFkOGQxZjggZXJyb3IgMTUKWyAgICA0LjAxMTY5OF0gS2Vy
bmVsIHBhbmljIC0gbm90IHN5bmNpbmc6IEF0dGVtcHRlZCB0byBraWxsIGluaXQhIGV4aXRj
b2RlPTB4MDAwMDAwMGIKWyAgICA0LjAxMTY5OF0gClsgICAgNC4wMTI5NDBdIENQVTogMCBQ
SUQ6IDEgQ29tbTogaW5pdCBOb3QgdGFpbnRlZCAzLjE3LjAtcmMxLTAwMTY5LWdjYWFlMjA0
ICMxClsgICAgNC4wMTM4OTJdIEhhcmR3YXJlIG5hbWU6IEJvY2hzIEJvY2hzLCBCSU9TIEJv
Y2hzIDAxLzAxLzIwMTEKWyAgICA0LjAxNDYzNl0gIDAwMDAwMDAwMDAwMDAwMDAgZmZmZjg4
MDAxMjg0ZmNiMCBmZmZmZmZmZjgxNGEyY2U1IGZmZmY4ODAwMTI4NGZkMzAKWyAgICA0LjAx
NTcyM10gIGZmZmZmZmZmODE0YTFjNTEgMDAwMDAwMDAwMDAwMDAxMCBmZmZmODgwMDEyODRm
ZDQwIGZmZmY4ODAwMTI4NGZjZDgKWyAgICA0LjAyMDEwMl0gIGZmZmY4ODAwMTI4NGZkNzgg
MDAwMDAwMDAwMDAwMDAwYiAwMDAwMDAwMDAwMDAwMDAwIGZmZmY4ODAwMTI4NDg3NDAKWyAg
ICA0LjAyMDEwMl0gQ2FsbCBUcmFjZToKWyAgICA0LjAyMDEwMl0gIFs8ZmZmZmZmZmY4MTRh
MmNlNT5dIGR1bXBfc3RhY2srMHgxOS8weDFiClsgICAgNC4wMjAxMDJdICBbPGZmZmZmZmZm
ODE0YTFjNTE+XSBwYW5pYysweGM0LzB4MWVmClsgICAgNC4wMjAxMDJdICBbPGZmZmZmZmZm
ODEwOTBkMmM+XSBkb19leGl0KzB4M2JiLzB4ODFlClsgICAgNC4wMjAxMDJdICBbPGZmZmZm
ZmZmODExMTk4YzU+XSA/IF9fa21lbV9jYWNoZV9mcmVlKzB4MTEvMHgyZQpbICAgIDQuMDIw
MTAyXSAgWzxmZmZmZmZmZjgxMTE5OTJjPl0gPyBrbWVtX2NhY2hlX2ZyZWUrMHgzMS8weDMz
ClsgICAgNC4wMjAxMDJdICBbPGZmZmZmZmZmODEwOTYyZWI+XSA/IF9fc2lncXVldWVfZnJl
ZSsweDMzLzB4MzYKWyAgICA0LjAyMDEwMl0gIFs8ZmZmZmZmZmY4MTA5MWU5MD5dIGRvX2dy
b3VwX2V4aXQrMHg0NS8weGJmClsgICAgNC4wMjAxMDJdICBbPGZmZmZmZmZmODEwOThkZjk+
XSBnZXRfc2lnbmFsKzB4NTNkLzB4NTY4ClsgICAgNC4wMjAxMDJdICBbPGZmZmZmZmZmODEw
NDMwMzk+XSA/IGJhZF9hcmVhX25vc2VtYXBob3JlKzB4ZS8weDEwClsgICAgNC4wMjAxMDJd
ICBbPGZmZmZmZmZmODEwMjgyMTg+XSBkb19zaWduYWwrMHgyMy8weDg4NQpbICAgIDQuMDIw
MTAyXSAgWzxmZmZmZmZmZjgxNGEwMDAwPl0gPyBmcmVlX2FyZWFfaW5pdF9ub2RlKzB4YWMv
MHgzNmUKWyAgICA0LjAyMDEwMl0gIFs8ZmZmZmZmZmY4MTAyOGE5Nj5dIGRvX25vdGlmeV9y
ZXN1bWUrMHgxYy8weDc1ClsgICAgNC4wMjAxMDJdICBbPGZmZmZmZmZmODE0YTkyN2I+XSBy
ZXRpbnRfc2lnbmFsKzB4NDgvMHg4ZApbICAgIDQuMDIwMTAyXSBLZXJuZWwgT2Zmc2V0OiAw
eDAgZnJvbSAweGZmZmZmZmZmODEwMDAwMDAgKHJlbG9jYXRpb24gcmFuZ2U6IDB4ZmZmZmZm
ZmY4MDAwMDAwMC0weGZmZmZmZmZmOWZmZmZmZmYpCgpFbGFwc2VkIHRpbWU6IDEwCi9rZXJu
ZWwveDg2XzY0LXJhbmRjb25maWctczEtMDkyNDAzNTEvY2FhZTIwNGJlMTg0YTU3NWFmMmMw
MmI4MzdkODE4Mjc4ZjkyMTMyMy9kbWVzZy15b2N0by1rYnVpbGQtMTU6MjAxNDA5MjYyMjEx
MTc6eDg2XzY0LXJhbmRjb25maWctczEtMDkyNDAzNTE6My4xNy4wLXJjMS0wMDE2OS1nY2Fh
ZTIwNDoxCi9rZXJuZWwveDg2XzY0LXJhbmRjb25maWctczEtMDkyNDAzNTEvY2FhZTIwNGJl
MTg0YTU3NWFmMmMwMmI4MzdkODE4Mjc4ZjkyMTMyMy9kbWVzZy15b2N0by1rYnVpbGQtNzoy
MDE0MDkyNjIyMTExNzp4ODZfNjQtcmFuZGNvbmZpZy1zMS0wOTI0MDM1MTozLjE3LjAtcmMx
LTAwMTY5LWdjYWFlMjA0OjEKMDoyOjIgYWxsX2dvb2Q6YmFkOmFsbF9iYWQgYm9vdHMKCkJp
c2VjdGluZzogMCByZXZpc2lvbnMgbGVmdCB0byB0ZXN0IGFmdGVyIHRoaXMgKHJvdWdobHkg
MCBzdGVwcykKWzJkZjg3YmRmYTZhYzkwNzZlZDgwYmI4Mzc2NGI4YjBmM2VjMzk2YmRdIHg4
Nl82NCx2c3lzY2FsbDogUmV3cml0ZSBjb21tZW50IGFuZCBjbGVhbiB1cCBoZWFkZXJzIGlu
IHZzeXNjYWxsIGNvZGUKcnVubmluZyAvYy9rZXJuZWwtdGVzdHMvYmlzZWN0LXRlc3QtYm9v
dC1mYWlsdXJlLnNoIC9jL2Jvb3QtYmlzZWN0L2xpbnV4LTYvb2JqLWJpc2VjdApscyAtYSAv
a2J1aWxkLXRlc3RzL3J1bi1xdWV1ZS9rdm0veDg2XzY0LXJhbmRjb25maWctczEtMDkyNDAz
NTEvbGludXgtZGV2ZWw6ZGV2ZWwtaG91cmx5LTIwMTQwOTI0MDI6MmRmODdiZGZhNmFjOTA3
NmVkODBiYjgzNzY0YjhiMGYzZWMzOTZiZDpiaXNlY3QtbGludXgtNgoKMjAxNC0wOS0yNiAy
MjoxNDoyNiAyZGY4N2JkZmE2YWM5MDc2ZWQ4MGJiODM3NjRiOGIwZjNlYzM5NmJkIGNvbXBp
bGluZwpRdWV1ZWQgYnVpbGQgdGFzayB0byAva2J1aWxkLXRlc3RzL2J1aWxkLXF1ZXVlL3Nu
Yi94ODZfNjQtcmFuZGNvbmZpZy1zMS0wOTI0MDM1MS0yZGY4N2JkZmE2YWM5MDc2ZWQ4MGJi
ODM3NjRiOGIwZjNlYzM5NmJkCkNoZWNrIGZvciBrZXJuZWwgaW4gL2tlcm5lbC94ODZfNjQt
cmFuZGNvbmZpZy1zMS0wOTI0MDM1MS8yZGY4N2JkZmE2YWM5MDc2ZWQ4MGJiODM3NjRiOGIw
ZjNlYzM5NmJkCndhaXRpbmcgZm9yIGNvbXBsZXRpb24gb2YgL2tidWlsZC10ZXN0cy9idWls
ZC1xdWV1ZS9zbmIveDg2XzY0LXJhbmRjb25maWctczEtMDkyNDAzNTEtMmRmODdiZGZhNmFj
OTA3NmVkODBiYjgzNzY0YjhiMGYzZWMzOTZiZAobWzE7MzVtMjAxNC0wOS0yNiAyMjoxODoy
NiBObyBidWlsZCBzZXJ2ZWQgZmlsZSAva2J1aWxkLXRlc3RzL2J1aWxkLXNlcnZlZC94ODZf
NjQtcmFuZGNvbmZpZy1zMS0wOTI0MDM1MS0yZGY4N2JkZmE2YWM5MDc2ZWQ4MGJiODM3NjRi
OGIwZjNlYzM5NmJkG1swbQpSZXRyeSBidWlsZCAuLgp3YWl0aW5nIGZvciBjb21wbGV0aW9u
IG9mIC9rYnVpbGQtdGVzdHMvYnVpbGQtcXVldWUvc25iLXNtb2tlL3g4Nl82NC1yYW5kY29u
ZmlnLXMxLTA5MjQwMzUxLTJkZjg3YmRmYTZhYzkwNzZlZDgwYmI4Mzc2NGI4YjBmM2VjMzk2
YmQKa2VybmVsOiAva2VybmVsL3g4Nl82NC1yYW5kY29uZmlnLXMxLTA5MjQwMzUxLzJkZjg3
YmRmYTZhYzkwNzZlZDgwYmI4Mzc2NGI4YjBmM2VjMzk2YmQvdm1saW51ei0zLjE3LjAtcmMx
LTAwMTY4LWcyZGY4N2JkCgoyMDE0LTA5LTI2IDIyOjIxOjI2IGRldGVjdGluZyBib290IHN0
YXRlIAkzMQk0MQk1MiBTVUNDRVNTCgpjYWFlMjA0YmUxODRhNTc1YWYyYzAyYjgzN2Q4MTgy
NzhmOTIxMzIzIGlzIHRoZSBmaXJzdCBiYWQgY29tbWl0CmNvbW1pdCBjYWFlMjA0YmUxODRh
NTc1YWYyYzAyYjgzN2Q4MTgyNzhmOTIxMzIzCkF1dGhvcjogQW5keSBMdXRvbWlyc2tpIDxs
dXRvQGFtYWNhcGl0YWwubmV0PgpEYXRlOiAgIE1vbiBKdW4gMTYgMTg6NTA6MTIgMjAxNCAt
MDcwMAoKICAgIHg4Nl82NCx2c3lzY2FsbDogTWFrZSB2c3lzY2FsbCBlbXVsYXRpb24gY29u
ZmlndXJhYmxlCiAgICAKICAgIFRoaXMgYWRkcyBDT05GSUdfWDg2X1ZTWVNDQUxMX0VNVUxB
VElPTiwgZ3VhcmRlZCBieSBDT05GSUdfRVhQRVJULgogICAgVHVybmluZyBpdCBvZmYgY29t
cGxldGVseSBkaXNhYmxlcyB2c3lzY2FsbCBlbXVsYXRpb24sIHNhdmluZyB+My41awogICAg
Zm9yIHZzeXNjYWxsXzY0LmMsIDRrIGZvciB2c3lzY2FsbF9lbXVfNjQuUyAodGhlIGZha2Ug
dnN5c2NhbGwKICAgIHBhZ2UpLCBzb21lIHRpbnkgYW1vdW50IG9mIGNvcmUgbW0gY29kZSB0
aGF0IHN1cHBvcnRzIGEgZ2F0ZSBhcmVhLAogICAgYW5kIHBvc3NpYmx5IDRrIGZvciBhIHdh
c3RlZCBwYWdldGFibGUuICBUaGUgbGF0dGVyIGlzIGJlY2F1c2UgdGhlCiAgICB2c3lzY2Fs
bCBhZGRyZXNzZXMgYXJlIG1pc2FsaWduZWQgYW5kIGZpdCBwb29ybHkgaW4gdGhlIGZpeG1h
cC4KICAgIAogICAgU2lnbmVkLW9mZi1ieTogQW5keSBMdXRvbWlyc2tpIDxsdXRvQGFtYWNh
cGl0YWwubmV0PgoKOjA0MDAwMCAwNDAwMDAgMDlkM2I2MGI0YjY0ZDdlOTAzNzkyOTJlMzA0
Y2QxNWU2ZGZhMmYzOSAyYzliNWIzNmNmYWUxNWExODdhZmM0ZjMyZmEzOWEyMWIwMDk5MTVi
IE0JYXJjaApiaXNlY3QgcnVuIHN1Y2Nlc3MKSEVBRCBpcyBub3cgYXQgMmRmODdiZC4uLiB4
ODZfNjQsdnN5c2NhbGw6IFJld3JpdGUgY29tbWVudCBhbmQgY2xlYW4gdXAgaGVhZGVycyBp
biB2c3lzY2FsbCBjb2RlCmxzIC1hIC9rYnVpbGQtdGVzdHMvcnVuLXF1ZXVlL2t2bS94ODZf
NjQtcmFuZGNvbmZpZy1zMS0wOTI0MDM1MS9saW51eC1kZXZlbDpkZXZlbC1ob3VybHktMjAx
NDA5MjQwMjoyZGY4N2JkZmE2YWM5MDc2ZWQ4MGJiODM3NjRiOGIwZjNlYzM5NmJkOmJpc2Vj
dC1saW51eC02CgoyMDE0LTA5LTI2IDIyOjIyOjU3IDJkZjg3YmRmYTZhYzkwNzZlZDgwYmI4
Mzc2NGI4YjBmM2VjMzk2YmQgcmV1c2UgL2tlcm5lbC94ODZfNjQtcmFuZGNvbmZpZy1zMS0w
OTI0MDM1MS8yZGY4N2JkZmE2YWM5MDc2ZWQ4MGJiODM3NjRiOGIwZjNlYzM5NmJkL3ZtbGlu
dXotMy4xNy4wLXJjMS0wMDE2OC1nMmRmODdiZAoKMjAxNC0wOS0yNiAyMjoyMjo1NyBkZXRl
Y3RpbmcgYm9vdCBzdGF0ZSAJNjMJMTAyCTExNAkxNTYgU1VDQ0VTUwoKUHJldmlvdXMgSEVB
RCBwb3NpdGlvbiB3YXMgMmRmODdiZC4uLiB4ODZfNjQsdnN5c2NhbGw6IFJld3JpdGUgY29t
bWVudCBhbmQgY2xlYW4gdXAgaGVhZGVycyBpbiB2c3lzY2FsbCBjb2RlCkhFQUQgaXMgbm93
IGF0IGRkYzUwNTdiLi4uIDBkYXkgaGVhZCBndWFyZCBmb3IgJ2RldmVsLWhvdXJseS0yMDE0
MDkyNDAyJwpscyAtYSAva2J1aWxkLXRlc3RzL3J1bi1xdWV1ZS9rdm0veDg2XzY0LXJhbmRj
b25maWctczEtMDkyNDAzNTEvbGludXgtZGV2ZWw6ZGV2ZWwtaG91cmx5LTIwMTQwOTI0MDI6
ZGRjNTA1N2IwN2VmNzEyNjQzMWQ1ZGY1ZjViMTc2MTU0ODk2ZjU2MDpiaXNlY3QtbGludXgt
NgogVEVTVCBGQUlMVVJFClsgICAgNC41MDgyODNdIHVkZXZbMTM5XTogc3RhcnRpbmcgdmVy
c2lvbiAxNjQKWyAgICA2Ljc0MjM0NV0gaW5pdFsxXTogc2VnZmF1bHQgYXQgZmZmZmZmZmZm
ZjYwMDQwMCBpcCBmZmZmZmZmZmZmNjAwNDAwIHNwIDAwMDA3ZmZmYjg5YTRhYjggZXJyb3Ig
MTUKWyAgICA2Ljc0MzYzMl0gaW5pdFsxXTogc2VnZmF1bHQgYXQgZmZmZmZmZmZmZjYwMDQw
MCBpcCBmZmZmZmZmZmZmNjAwNDAwIHNwIDAwMDA3ZmZmYjg5YTNmNzggZXJyb3IgMTUKWyAg
ICA2Ljc2MzY3NF0gS2VybmVsIHBhbmljIC0gbm90IHN5bmNpbmc6IEF0dGVtcHRlZCB0byBr
aWxsIGluaXQhIGV4aXRjb2RlPTB4MDAwMDAwMGIKWyAgICA2Ljc2MzY3NF0gClsgICAgNi43
NzAwMTJdIENQVTogMCBQSUQ6IDEgQ29tbTogaW5pdCBOb3QgdGFpbnRlZCAzLjE3LjAtcmM2
LXdsLTA0NDc4LWdkZGM1MDU3YiAjNTcwClsgICAgNi43NzAwMTJdIEhhcmR3YXJlIG5hbWU6
IEJvY2hzIEJvY2hzLCBCSU9TIEJvY2hzIDAxLzAxLzIwMTEKWyAgICA2Ljc3MDAxMl0gIDAw
MDAwMDAwMDAwMDAwMDAgZmZmZjg4MDAxMjg0ZmNiMCBmZmZmZmZmZjgxNGEzYmE1IGZmZmY4
ODAwMTI4NGZkMzAKWyAgICA2Ljc3MDAxMl0gIGZmZmZmZmZmODE0YTJiMTEgMDAwMDAwMDAw
MDAwMDAxMCBmZmZmODgwMDEyODRmZDQwIGZmZmY4ODAwMTI4NGZjZDgKWyAgICA2Ljc3MDAx
Ml0gIGZmZmY4ODAwMTI4NGZkNzggMDAwMDAwMDAwMDAwMDAwYiBmZmZmODgwMDEyODQ4MDAw
IDAwMDAwMDAwMDAwMDAwMDAKWyAgICA2Ljc3MDAxMl0gQ2FsbCBUcmFjZToKWyAgICA2Ljc3
MDAxMl0gIFs8ZmZmZmZmZmY4MTRhM2JhNT5dIGR1bXBfc3RhY2srMHgxOS8weDFiClsgICAg
Ni43NzAwMTJdICBbPGZmZmZmZmZmODE0YTJiMTE+XSBwYW5pYysweGM0LzB4MWVmClsgICAg
Ni43NzAwMTJdICBbPGZmZmZmZmZmODEwOTBkNjE+XSBkb19leGl0KzB4M2NhLzB4ODNjClsg
ICAgNi43NzAwMTJdICBbPGZmZmZmZmZmODExMWEyMmM+XSA/IF9fa21lbV9jYWNoZV9mcmVl
KzB4MTEvMHgyZQpbICAgIDYuNzcwMDEyXSAgWzxmZmZmZmZmZjgxMTFhMjkzPl0gPyBrbWVt
X2NhY2hlX2ZyZWUrMHgzMS8weDMzClsgICAgNi43NzAwMTJdICBbPGZmZmZmZmZmODEwOTYz
ZjI+XSA/IF9fc2lncXVldWVfZnJlZSsweDMzLzB4MzYKWyAgICA2Ljc3MDAxMl0gIFs8ZmZm
ZmZmZmY4MTA5MWVkND5dIGRvX2dyb3VwX2V4aXQrMHg0NS8weGJmClsgICAgNi43NzAwMTJd
ICBbPGZmZmZmZmZmODEwOThmMDA+XSBnZXRfc2lnbmFsKzB4NTNkLzB4NTY4ClsgICAgNi43
NzAwMTJdICBbPGZmZmZmZmZmODEwNDMwMzM+XSA/IGJhZF9hcmVhX25vc2VtYXBob3JlKzB4
ZS8weDEwClsgICAgNi43NzAwMTJdICBbPGZmZmZmZmZmODEwMjgyMTg+XSBkb19zaWduYWwr
MHgyMy8weDg4NQpbICAgIDYuNzcwMDEyXSAgWzxmZmZmZmZmZjgxNGEwMDAwPl0gPyBzYXZl
X21yKzB4MjMvMHgzZQpbICAgIDYuNzcwMDEyXSAgWzxmZmZmZmZmZjgxMDI4YTk2Pl0gZG9f
bm90aWZ5X3Jlc3VtZSsweDFjLzB4NzUKWyAgICA2Ljc3MDAxMl0gIFs8ZmZmZmZmZmY4MTRh
YTEzYj5dIHJldGludF9zaWduYWwrMHg0OC8weDhkClsgICAgNi43NzAwMTJdIEtlcm5lbCBP
ZmZzZXQ6IDB4MCBmcm9tIDB4ZmZmZmZmZmY4MTAwMDAwMCAocmVsb2NhdGlvbiByYW5nZTog
MHhmZmZmZmZmZjgwMDAwMDAwLTB4ZmZmZmZmZmY5ZmZmZmZmZikKCkVsYXBzZWQgdGltZTog
MTUKL2tlcm5lbC94ODZfNjQtcmFuZGNvbmZpZy1zMS0wOTI0MDM1MS9kZGM1MDU3YjA3ZWY3
MTI2NDMxZDVkZjVmNWIxNzYxNTQ4OTZmNTYwL2RtZXNnLXlvY3RvLWxrcC1uZXgwNC0xNzc6
MjAxNDA5MjYxODI0MTc6eDg2XzY0LXJhbmRjb25maWctczEtMDkyNDAzNTE6Ogova2VybmVs
L3g4Nl82NC1yYW5kY29uZmlnLXMxLTA5MjQwMzUxL2RkYzUwNTdiMDdlZjcxMjY0MzFkNWRm
NWY1YjE3NjE1NDg5NmY1NjAvZG1lc2cteW9jdG8ta2J1aWxkLTY6MjAxNDA5MjQwNDMxNTc6
eDg2XzY0LXJhbmRjb25maWctczEtMDkyNDAzNTE6My4xNy4wLXJjNi13bC0wNDQ3OC1nZGRj
NTA1N2I6NTcwCi9rZXJuZWwveDg2XzY0LXJhbmRjb25maWctczEtMDkyNDAzNTEvZGRjNTA1
N2IwN2VmNzEyNjQzMWQ1ZGY1ZjViMTc2MTU0ODk2ZjU2MC9kbWVzZy15b2N0by1rYnVpbGQt
ODoyMDE0MDkyNDA0MjQzMzp4ODZfNjQtcmFuZGNvbmZpZy1zMS0wOTI0MDM1MTozLjE3LjAt
cmM2LXdsLTA0NDc4LWdkZGM1MDU3Yjo1NzAKL2tlcm5lbC94ODZfNjQtcmFuZGNvbmZpZy1z
MS0wOTI0MDM1MS9kZGM1MDU3YjA3ZWY3MTI2NDMxZDVkZjVmNWIxNzYxNTQ4OTZmNTYwL2Rt
ZXNnLXlvY3RvLXZwLTYxOjIwMTQwOTI0MDQxMDUzOng4Nl82NC1yYW5kY29uZmlnLXMxLTA5
MjQwMzUxOjMuMTcuMC1yYzYtd2wtMDQ0NzgtZ2RkYzUwNTdiOjU3MAova2VybmVsL3g4Nl82
NC1yYW5kY29uZmlnLXMxLTA5MjQwMzUxL2RkYzUwNTdiMDdlZjcxMjY0MzFkNWRmNWY1YjE3
NjE1NDg5NmY1NjAvZG1lc2cteW9jdG8ta2J1aWxkLTMyOjIwMTQwOTI0MDQyNzQ0Ong4Nl82
NC1yYW5kY29uZmlnLXMxLTA5MjQwMzUxOjMuMTcuMC1yYzYtd2wtMDQ0NzgtZ2RkYzUwNTdi
OjU3MAova2VybmVsL3g4Nl82NC1yYW5kY29uZmlnLXMxLTA5MjQwMzUxL2RkYzUwNTdiMDdl
ZjcxMjY0MzFkNWRmNWY1YjE3NjE1NDg5NmY1NjAvZG1lc2cteW9jdG8ta2J1aWxkLTI3OjIw
MTQwOTI0MDQyNDM1Ong4Nl82NC1yYW5kY29uZmlnLXMxLTA5MjQwMzUxOjMuMTcuMC1yYzYt
d2wtMDQ0NzgtZ2RkYzUwNTdiOjU3MAova2VybmVsL3g4Nl82NC1yYW5kY29uZmlnLXMxLTA5
MjQwMzUxL2RkYzUwNTdiMDdlZjcxMjY0MzFkNWRmNWY1YjE3NjE1NDg5NmY1NjAvZG1lc2ct
eW9jdG8tdnAtMzoyMDE0MDkyNDA0MDAxMjp4ODZfNjQtcmFuZGNvbmZpZy1zMS0wOTI0MDM1
MTozLjE3LjAtcmM2LXdsLTA0NDc4LWdkZGM1MDU3Yjo1NzAKL2tlcm5lbC94ODZfNjQtcmFu
ZGNvbmZpZy1zMS0wOTI0MDM1MS9kZGM1MDU3YjA3ZWY3MTI2NDMxZDVkZjVmNWIxNzYxNTQ4
OTZmNTYwL2RtZXNnLXlvY3RvLWtidWlsZC04OjIwMTQwOTI0MDQxMzE5Ong4Nl82NC1yYW5k
Y29uZmlnLXMxLTA5MjQwMzUxOjMuMTcuMC1yYzYtd2wtMDQ0NzgtZ2RkYzUwNTdiOjU3MAov
a2VybmVsL3g4Nl82NC1yYW5kY29uZmlnLXMxLTA5MjQwMzUxL2RkYzUwNTdiMDdlZjcxMjY0
MzFkNWRmNWY1YjE3NjE1NDg5NmY1NjAvZG1lc2cteW9jdG8ta2J1aWxkLTE3OjIwMTQwOTI0
MDQzMTU4Ong4Nl82NC1yYW5kY29uZmlnLXMxLTA5MjQwMzUxOjMuMTcuMC1yYzYtd2wtMDQ0
NzgtZ2RkYzUwNTdiOjU3MAova2VybmVsL3g4Nl82NC1yYW5kY29uZmlnLXMxLTA5MjQwMzUx
L2RkYzUwNTdiMDdlZjcxMjY0MzFkNWRmNWY1YjE3NjE1NDg5NmY1NjAvZG1lc2cteW9jdG8t
a2J1aWxkLTk6MjAxNDA5MjQwNDEyNDY6eDg2XzY0LXJhbmRjb25maWctczEtMDkyNDAzNTE6
My4xNy4wLXJjNi13bC0wNDQ3OC1nZGRjNTA1N2I6NTcwCi9rZXJuZWwveDg2XzY0LXJhbmRj
b25maWctczEtMDkyNDAzNTEvZGRjNTA1N2IwN2VmNzEyNjQzMWQ1ZGY1ZjViMTc2MTU0ODk2
ZjU2MC9kbWVzZy15b2N0by1rYnVpbGQtMTU6MjAxNDA5MjQwNDE1MjA6eDg2XzY0LXJhbmRj
b25maWctczEtMDkyNDAzNTE6My4xNy4wLXJjNi13bC0wNDQ3OC1nZGRjNTA1N2I6NTcwCi9r
ZXJuZWwveDg2XzY0LXJhbmRjb25maWctczEtMDkyNDAzNTEvZGRjNTA1N2IwN2VmNzEyNjQz
MWQ1ZGY1ZjViMTc2MTU0ODk2ZjU2MC9kbWVzZy15b2N0by1rYnVpbGQtMTA6MjAxNDA5MjQw
NDM3MjQ6eDg2XzY0LXJhbmRjb25maWctczEtMDkyNDAzNTE6My4xNy4wLXJjNi13bC0wNDQ3
OC1nZGRjNTA1N2I6NTcwCi9rZXJuZWwveDg2XzY0LXJhbmRjb25maWctczEtMDkyNDAzNTEv
ZGRjNTA1N2IwN2VmNzEyNjQzMWQ1ZGY1ZjViMTc2MTU0ODk2ZjU2MC9kbWVzZy15b2N0by12
cC02OjIwMTQwOTI0MDQwNTE2Ong4Nl82NC1yYW5kY29uZmlnLXMxLTA5MjQwMzUxOjMuMTcu
MC1yYzYtd2wtMDQ0NzgtZ2RkYzUwNTdiOjU3MAova2VybmVsL3g4Nl82NC1yYW5kY29uZmln
LXMxLTA5MjQwMzUxL2RkYzUwNTdiMDdlZjcxMjY0MzFkNWRmNWY1YjE3NjE1NDg5NmY1NjAv
ZG1lc2cteW9jdG8ta2J1aWxkLTEzOjIwMTQwOTI0MDQxNTIwOng4Nl82NC1yYW5kY29uZmln
LXMxLTA5MjQwMzUxOjMuMTcuMC1yYzYtd2wtMDQ0NzgtZ2RkYzUwNTdiOjU3MAova2VybmVs
L3g4Nl82NC1yYW5kY29uZmlnLXMxLTA5MjQwMzUxL2RkYzUwNTdiMDdlZjcxMjY0MzFkNWRm
NWY1YjE3NjE1NDg5NmY1NjAvZG1lc2cteW9jdG8ta2J1aWxkLTIzOjIwMTQwOTI0MDQxODM0
Ong4Nl82NC1yYW5kY29uZmlnLXMxLTA5MjQwMzUxOjMuMTcuMC1yYzYtd2wtMDQ0NzgtZ2Rk
YzUwNTdiOjU3MAova2VybmVsL3g4Nl82NC1yYW5kY29uZmlnLXMxLTA5MjQwMzUxL2RkYzUw
NTdiMDdlZjcxMjY0MzFkNWRmNWY1YjE3NjE1NDg5NmY1NjAvZG1lc2cteW9jdG8ta2J1aWxk
LTEyOjIwMTQwOTI0MDQxMzIwOng4Nl82NC1yYW5kY29uZmlnLXMxLTA5MjQwMzUxOjMuMTcu
MC1yYzYtd2wtMDQ0NzgtZ2RkYzUwNTdiOjU3MAova2VybmVsL3g4Nl82NC1yYW5kY29uZmln
LXMxLTA5MjQwMzUxL2RkYzUwNTdiMDdlZjcxMjY0MzFkNWRmNWY1YjE3NjE1NDg5NmY1NjAv
ZG1lc2cteW9jdG8ta2J1aWxkLTQ6MjAxNDA5MjQwNDQwMTk6eDg2XzY0LXJhbmRjb25maWct
czEtMDkyNDAzNTE6My4xNy4wLXJjNi13bC0wNDQ3OC1nZGRjNTA1N2I6NTcwCi9rZXJuZWwv
eDg2XzY0LXJhbmRjb25maWctczEtMDkyNDAzNTEvZGRjNTA1N2IwN2VmNzEyNjQzMWQ1ZGY1
ZjViMTc2MTU0ODk2ZjU2MC9kbWVzZy15b2N0by1rYnVpbGQtMTU6MjAxNDA5MjQwNDE2NTY6
eDg2XzY0LXJhbmRjb25maWctczEtMDkyNDAzNTE6My4xNy4wLXJjNi13bC0wNDQ3OC1nZGRj
NTA1N2I6NTcwCi9rZXJuZWwveDg2XzY0LXJhbmRjb25maWctczEtMDkyNDAzNTEvZGRjNTA1
N2IwN2VmNzEyNjQzMWQ1ZGY1ZjViMTc2MTU0ODk2ZjU2MC9kbWVzZy15b2N0by1rYnVpbGQt
MjM6MjAxNDA5MjQwNDAxMTQ6eDg2XzY0LXJhbmRjb25maWctczEtMDkyNDAzNTE6My4xNy4w
LXJjNi13bC0wNDQ3OC1nZGRjNTA1N2I6NTcwCi9rZXJuZWwveDg2XzY0LXJhbmRjb25maWct
czEtMDkyNDAzNTEvZGRjNTA1N2IwN2VmNzEyNjQzMWQ1ZGY1ZjViMTc2MTU0ODk2ZjU2MC9k
bWVzZy15b2N0by1rYnVpbGQtMTM6MjAxNDA5MjQwNDIwMTM6eDg2XzY0LXJhbmRjb25maWct
czEtMDkyNDAzNTE6My4xNy4wLXJjNi13bC0wNDQ3OC1nZGRjNTA1N2I6NTcwCi9rZXJuZWwv
eDg2XzY0LXJhbmRjb25maWctczEtMDkyNDAzNTEvZGRjNTA1N2IwN2VmNzEyNjQzMWQ1ZGY1
ZjViMTc2MTU0ODk2ZjU2MC9kbWVzZy15b2N0by1rYnVpbGQtODoyMDE0MDkyNDA0MTI0NDp4
ODZfNjQtcmFuZGNvbmZpZy1zMS0wOTI0MDM1MTozLjE3LjAtcmM2LXdsLTA0NDc4LWdkZGM1
MDU3Yjo1NzAKL2tlcm5lbC94ODZfNjQtcmFuZGNvbmZpZy1zMS0wOTI0MDM1MS9kZGM1MDU3
YjA3ZWY3MTI2NDMxZDVkZjVmNWIxNzYxNTQ4OTZmNTYwL2RtZXNnLXlvY3RvLWtidWlsZC0x
OjIwMTQwOTI0MDQxNTE2Ong4Nl82NC1yYW5kY29uZmlnLXMxLTA5MjQwMzUxOjMuMTcuMC1y
YzYtd2wtMDQ0NzgtZ2RkYzUwNTdiOjU3MAova2VybmVsL3g4Nl82NC1yYW5kY29uZmlnLXMx
LTA5MjQwMzUxL2RkYzUwNTdiMDdlZjcxMjY0MzFkNWRmNWY1YjE3NjE1NDg5NmY1NjAvZG1l
c2cteW9jdG8ta2J1aWxkLTc6MjAxNDA5MjQwNDMzMzk6eDg2XzY0LXJhbmRjb25maWctczEt
MDkyNDAzNTE6My4xNy4wLXJjNi13bC0wNDQ3OC1nZGRjNTA1N2I6NTcwCi9rZXJuZWwveDg2
XzY0LXJhbmRjb25maWctczEtMDkyNDAzNTEvZGRjNTA1N2IwN2VmNzEyNjQzMWQ1ZGY1ZjVi
MTc2MTU0ODk2ZjU2MC9kbWVzZy15b2N0by1rYnVpbGQtMjoyMDE0MDkyNDA0NDAxOTp4ODZf
NjQtcmFuZGNvbmZpZy1zMS0wOTI0MDM1MTozLjE3LjAtcmM2LXdsLTA0NDc4LWdkZGM1MDU3
Yjo1NzAKL2tlcm5lbC94ODZfNjQtcmFuZGNvbmZpZy1zMS0wOTI0MDM1MS9kZGM1MDU3YjA3
ZWY3MTI2NDMxZDVkZjVmNWIxNzYxNTQ4OTZmNTYwL2RtZXNnLXlvY3RvLWtidWlsZC0yODoy
MDE0MDkyNDA0NDAxNzp4ODZfNjQtcmFuZGNvbmZpZy1zMS0wOTI0MDM1MTozLjE3LjAtcmM2
LXdsLTA0NDc4LWdkZGM1MDU3Yjo1NzAKL2tlcm5lbC94ODZfNjQtcmFuZGNvbmZpZy1zMS0w
OTI0MDM1MS9kZGM1MDU3YjA3ZWY3MTI2NDMxZDVkZjVmNWIxNzYxNTQ4OTZmNTYwL2RtZXNn
LXlvY3RvLWtidWlsZC0xMzoyMDE0MDkyNDA0MjUwNDp4ODZfNjQtcmFuZGNvbmZpZy1zMS0w
OTI0MDM1MTozLjE3LjAtcmM2LXdsLTA0NDc4LWdkZGM1MDU3Yjo1NzAKL2tlcm5lbC94ODZf
NjQtcmFuZGNvbmZpZy1zMS0wOTI0MDM1MS9kZGM1MDU3YjA3ZWY3MTI2NDMxZDVkZjVmNWIx
NzYxNTQ4OTZmNTYwL2RtZXNnLXlvY3RvLWtidWlsZC0xNjoyMDE0MDkyNDA0MjQzMzp4ODZf
NjQtcmFuZGNvbmZpZy1zMS0wOTI0MDM1MTozLjE3LjAtcmM2LXdsLTA0NDc4LWdkZGM1MDU3
Yjo1NzAKL2tlcm5lbC94ODZfNjQtcmFuZGNvbmZpZy1zMS0wOTI0MDM1MS9kZGM1MDU3YjA3
ZWY3MTI2NDMxZDVkZjVmNWIxNzYxNTQ4OTZmNTYwL2RtZXNnLXlvY3RvLWtidWlsZC0zMjoy
MDE0MDkyNDA0NDA1MTp4ODZfNjQtcmFuZGNvbmZpZy1zMS0wOTI0MDM1MTozLjE3LjAtcmM2
LXdsLTA0NDc4LWdkZGM1MDU3Yjo1NzAKL2tlcm5lbC94ODZfNjQtcmFuZGNvbmZpZy1zMS0w
OTI0MDM1MS9kZGM1MDU3YjA3ZWY3MTI2NDMxZDVkZjVmNWIxNzYxNTQ4OTZmNTYwL2RtZXNn
LXlvY3RvLWtidWlsZC0zMDoyMDE0MDkyNDA0MDkyNjp4ODZfNjQtcmFuZGNvbmZpZy1zMS0w
OTI0MDM1MTozLjE3LjAtcmM2LXdsLTA0NDc4LWdkZGM1MDU3Yjo1NzAKL2tlcm5lbC94ODZf
NjQtcmFuZGNvbmZpZy1zMS0wOTI0MDM1MS9kZGM1MDU3YjA3ZWY3MTI2NDMxZDVkZjVmNWIx
NzYxNTQ4OTZmNTYwL2RtZXNnLXlvY3RvLWtidWlsZC0xMToyMDE0MDkyNDA0MjYwNjp4ODZf
NjQtcmFuZGNvbmZpZy1zMS0wOTI0MDM1MTozLjE3LjAtcmM2LXdsLTA0NDc4LWdkZGM1MDU3
Yjo1NzAKL2tlcm5lbC94ODZfNjQtcmFuZGNvbmZpZy1zMS0wOTI0MDM1MS9kZGM1MDU3YjA3
ZWY3MTI2NDMxZDVkZjVmNWIxNzYxNTQ4OTZmNTYwL2RtZXNnLXlvY3RvLWtidWlsZC03OjIw
MTQwOTI0MDQxNjU1Ong4Nl82NC1yYW5kY29uZmlnLXMxLTA5MjQwMzUxOjMuMTcuMC1yYzYt
d2wtMDQ0NzgtZ2RkYzUwNTdiOjU3MAova2VybmVsL3g4Nl82NC1yYW5kY29uZmlnLXMxLTA5
MjQwMzUxL2RkYzUwNTdiMDdlZjcxMjY0MzFkNWRmNWY1YjE3NjE1NDg5NmY1NjAvZG1lc2ct
eW9jdG8ta2J1aWxkLTE6MjAxNDA5MjQwNDM0MDk6eDg2XzY0LXJhbmRjb25maWctczEtMDky
NDAzNTE6My4xNy4wLXJjNi13bC0wNDQ3OC1nZGRjNTA1N2I6NTcwCi9rZXJuZWwveDg2XzY0
LXJhbmRjb25maWctczEtMDkyNDAzNTEvZGRjNTA1N2IwN2VmNzEyNjQzMWQ1ZGY1ZjViMTc2
MTU0ODk2ZjU2MC9kbWVzZy15b2N0by1rYnVpbGQtMjk6MjAxNDA5MjQwNDIyNTE6eDg2XzY0
LXJhbmRjb25maWctczEtMDkyNDAzNTE6My4xNy4wLXJjNi13bC0wNDQ3OC1nZGRjNTA1N2I6
NTcwCi9rZXJuZWwveDg2XzY0LXJhbmRjb25maWctczEtMDkyNDAzNTEvZGRjNTA1N2IwN2Vm
NzEyNjQzMWQ1ZGY1ZjViMTc2MTU0ODk2ZjU2MC9kbWVzZy15b2N0by12cC00NDoyMDE0MDky
NDA0MDI0Mzp4ODZfNjQtcmFuZGNvbmZpZy1zMS0wOTI0MDM1MTozLjE3LjAtcmM2LXdsLTA0
NDc4LWdkZGM1MDU3Yjo1NzAKL2tlcm5lbC94ODZfNjQtcmFuZGNvbmZpZy1zMS0wOTI0MDM1
MS9kZGM1MDU3YjA3ZWY3MTI2NDMxZDVkZjVmNWIxNzYxNTQ4OTZmNTYwL2RtZXNnLXlvY3Rv
LWtidWlsZC0xOToyMDE0MDkyNDA0MjIxODp4ODZfNjQtcmFuZGNvbmZpZy1zMS0wOTI0MDM1
MTozLjE3LjAtcmM2LXdsLTA0NDc4LWdkZGM1MDU3Yjo1NzAKL2tlcm5lbC94ODZfNjQtcmFu
ZGNvbmZpZy1zMS0wOTI0MDM1MS9kZGM1MDU3YjA3ZWY3MTI2NDMxZDVkZjVmNWIxNzYxNTQ4
OTZmNTYwL2RtZXNnLXlvY3RvLWtidWlsZC0yOjIwMTQwOTI0MDQzOTE4Ong4Nl82NC1yYW5k
Y29uZmlnLXMxLTA5MjQwMzUxOjMuMTcuMC1yYzYtd2wtMDQ0NzgtZ2RkYzUwNTdiOjU3MAov
a2VybmVsL3g4Nl82NC1yYW5kY29uZmlnLXMxLTA5MjQwMzUxL2RkYzUwNTdiMDdlZjcxMjY0
MzFkNWRmNWY1YjE3NjE1NDg5NmY1NjAvZG1lc2cteW9jdG8ta2J1aWxkLTU6MjAxNDA5MjQw
NDM1NDc6eDg2XzY0LXJhbmRjb25maWctczEtMDkyNDAzNTE6My4xNy4wLXJjNi13bC0wNDQ3
OC1nZGRjNTA1N2I6NTcwCi9rZXJuZWwveDg2XzY0LXJhbmRjb25maWctczEtMDkyNDAzNTEv
ZGRjNTA1N2IwN2VmNzEyNjQzMWQ1ZGY1ZjViMTc2MTU0ODk2ZjU2MC9kbWVzZy15b2N0by12
cC0xOjIwMTQwOTI0MDQwMjQyOng4Nl82NC1yYW5kY29uZmlnLXMxLTA5MjQwMzUxOjMuMTcu
MC1yYzYtd2wtMDQ0NzgtZ2RkYzUwNTdiOjU3MAova2VybmVsL3g4Nl82NC1yYW5kY29uZmln
LXMxLTA5MjQwMzUxL2RkYzUwNTdiMDdlZjcxMjY0MzFkNWRmNWY1YjE3NjE1NDg5NmY1NjAv
ZG1lc2cteW9jdG8ta2J1aWxkLTI5OjIwMTQwOTI0MDQyMjE2Ong4Nl82NC1yYW5kY29uZmln
LXMxLTA5MjQwMzUxOjMuMTcuMC1yYzYtd2wtMDQ0NzgtZ2RkYzUwNTdiOjU3MAova2VybmVs
L3g4Nl82NC1yYW5kY29uZmlnLXMxLTA5MjQwMzUxL2RkYzUwNTdiMDdlZjcxMjY0MzFkNWRm
NWY1YjE3NjE1NDg5NmY1NjAvZG1lc2cteW9jdG8tdnAtNTI6MjAxNDA5MjQwNDEwNTM6eDg2
XzY0LXJhbmRjb25maWctczEtMDkyNDAzNTE6My4xNy4wLXJjNi13bC0wNDQ3OC1nZGRjNTA1
N2I6NTcwCi9rZXJuZWwveDg2XzY0LXJhbmRjb25maWctczEtMDkyNDAzNTEvZGRjNTA1N2Iw
N2VmNzEyNjQzMWQ1ZGY1ZjViMTc2MTU0ODk2ZjU2MC9kbWVzZy15b2N0by1rYnVpbGQtODoy
MDE0MDkyNDA0MTg0MDp4ODZfNjQtcmFuZGNvbmZpZy1zMS0wOTI0MDM1MTozLjE3LjAtcmM2
LXdsLTA0NDc4LWdkZGM1MDU3Yjo1NzAKL2tlcm5lbC94ODZfNjQtcmFuZGNvbmZpZy1zMS0w
OTI0MDM1MS9kZGM1MDU3YjA3ZWY3MTI2NDMxZDVkZjVmNWIxNzYxNTQ4OTZmNTYwL2RtZXNn
LXlvY3RvLWtidWlsZC01OjIwMTQwOTI0MDQzOTE5Ong4Nl82NC1yYW5kY29uZmlnLXMxLTA5
MjQwMzUxOjMuMTcuMC1yYzYtd2wtMDQ0NzgtZ2RkYzUwNTdiOjU3MAova2VybmVsL3g4Nl82
NC1yYW5kY29uZmlnLXMxLTA5MjQwMzUxL2RkYzUwNTdiMDdlZjcxMjY0MzFkNWRmNWY1YjE3
NjE1NDg5NmY1NjAvZG1lc2cteW9jdG8ta2J1aWxkLTMyOjIwMTQwOTI0MDQzOTIwOng4Nl82
NC1yYW5kY29uZmlnLXMxLTA5MjQwMzUxOjMuMTcuMC1yYzYtd2wtMDQ0NzgtZ2RkYzUwNTdi
OjU3MAova2VybmVsL3g4Nl82NC1yYW5kY29uZmlnLXMxLTA5MjQwMzUxL2RkYzUwNTdiMDdl
ZjcxMjY0MzFkNWRmNWY1YjE3NjE1NDg5NmY1NjAvZG1lc2cteW9jdG8ta2J1aWxkLTMyOjIw
MTQwOTI0MDQxMjQ1Ong4Nl82NC1yYW5kY29uZmlnLXMxLTA5MjQwMzUxOjMuMTcuMC1yYzYt
d2wtMDQ0NzgtZ2RkYzUwNTdiOjU3MAova2VybmVsL3g4Nl82NC1yYW5kY29uZmlnLXMxLTA5
MjQwMzUxL2RkYzUwNTdiMDdlZjcxMjY0MzFkNWRmNWY1YjE3NjE1NDg5NmY1NjAvZG1lc2ct
eW9jdG8ta2J1aWxkLTc6MjAxNDA5MjQwNDI4NDY6eDg2XzY0LXJhbmRjb25maWctczEtMDky
NDAzNTE6My4xNy4wLXJjNi13bC0wNDQ3OC1nZGRjNTA1N2I6NTcwCi9rZXJuZWwveDg2XzY0
LXJhbmRjb25maWctczEtMDkyNDAzNTEvZGRjNTA1N2IwN2VmNzEyNjQzMWQ1ZGY1ZjViMTc2
MTU0ODk2ZjU2MC9kbWVzZy15b2N0by1rYnVpbGQtMzE6MjAxNDA5MjQwNDE5NDE6eDg2XzY0
LXJhbmRjb25maWctczEtMDkyNDAzNTE6My4xNy4wLXJjNi13bC0wNDQ3OC1nZGRjNTA1N2I6
NTcwCi9rZXJuZWwveDg2XzY0LXJhbmRjb25maWctczEtMDkyNDAzNTEvZGRjNTA1N2IwN2Vm
NzEyNjQzMWQ1ZGY1ZjViMTc2MTU0ODk2ZjU2MC9kbWVzZy15b2N0by1rYnVpbGQtMzI6MjAx
NDA5MjQwNDI5MTk6eDg2XzY0LXJhbmRjb25maWctczEtMDkyNDAzNTE6My4xNy4wLXJjNi13
bC0wNDQ3OC1nZGRjNTA1N2I6NTcwCi9rZXJuZWwveDg2XzY0LXJhbmRjb25maWctczEtMDky
NDAzNTEvZGRjNTA1N2IwN2VmNzEyNjQzMWQ1ZGY1ZjViMTc2MTU0ODk2ZjU2MC9kbWVzZy15
b2N0by1rYnVpbGQtNzoyMDE0MDkyNDA0NDAxOTp4ODZfNjQtcmFuZGNvbmZpZy1zMS0wOTI0
MDM1MTozLjE3LjAtcmM2LXdsLTA0NDc4LWdkZGM1MDU3Yjo1NzAKL2tlcm5lbC94ODZfNjQt
cmFuZGNvbmZpZy1zMS0wOTI0MDM1MS9kZGM1MDU3YjA3ZWY3MTI2NDMxZDVkZjVmNWIxNzYx
NTQ4OTZmNTYwL2RtZXNnLXlvY3RvLWtidWlsZC0zOjIwMTQwOTI0MDQzNzIyOng4Nl82NC1y
YW5kY29uZmlnLXMxLTA5MjQwMzUxOjMuMTcuMC1yYzYtd2wtMDQ0NzgtZ2RkYzUwNTdiOjU3
MAova2VybmVsL3g4Nl82NC1yYW5kY29uZmlnLXMxLTA5MjQwMzUxL2RkYzUwNTdiMDdlZjcx
MjY0MzFkNWRmNWY1YjE3NjE1NDg5NmY1NjAvZG1lc2cteW9jdG8ta2J1aWxkLTIzOjIwMTQw
OTI0MDQxMjEzOng4Nl82NC1yYW5kY29uZmlnLXMxLTA5MjQwMzUxOjMuMTcuMC1yYzYtd2wt
MDQ0NzgtZ2RkYzUwNTdiOjU3MAova2VybmVsL3g4Nl82NC1yYW5kY29uZmlnLXMxLTA5MjQw
MzUxL2RkYzUwNTdiMDdlZjcxMjY0MzFkNWRmNWY1YjE3NjE1NDg5NmY1NjAvZG1lc2cteW9j
dG8ta2J1aWxkLTY6MjAxNDA5MjQwNDE2NTU6eDg2XzY0LXJhbmRjb25maWctczEtMDkyNDAz
NTE6My4xNy4wLXJjNi13bC0wNDQ3OC1nZGRjNTA1N2I6NTcwCi9rZXJuZWwveDg2XzY0LXJh
bmRjb25maWctczEtMDkyNDAzNTEvZGRjNTA1N2IwN2VmNzEyNjQzMWQ1ZGY1ZjViMTc2MTU0
ODk2ZjU2MC9kbWVzZy15b2N0by1rYnVpbGQtMTA6MjAxNDA5MjQwNDA3NDY6eDg2XzY0LXJh
bmRjb25maWctczEtMDkyNDAzNTE6My4xNy4wLXJjNi13bC0wNDQ3OC1nZGRjNTA1N2I6NTcw
Ci9rZXJuZWwveDg2XzY0LXJhbmRjb25maWctczEtMDkyNDAzNTEvZGRjNTA1N2IwN2VmNzEy
NjQzMWQ1ZGY1ZjViMTc2MTU0ODk2ZjU2MC9kbWVzZy15b2N0by1rYnVpbGQtMjY6MjAxNDA5
MjQwNDIyMTg6eDg2XzY0LXJhbmRjb25maWctczEtMDkyNDAzNTE6My4xNy4wLXJjNi13bC0w
NDQ3OC1nZGRjNTA1N2I6NTcwCi9rZXJuZWwveDg2XzY0LXJhbmRjb25maWctczEtMDkyNDAz
NTEvZGRjNTA1N2IwN2VmNzEyNjQzMWQ1ZGY1ZjViMTc2MTU0ODk2ZjU2MC9kbWVzZy15b2N0
by1rYnVpbGQtMzE6MjAxNDA5MjQwNDE2NTU6eDg2XzY0LXJhbmRjb25maWctczEtMDkyNDAz
NTE6My4xNy4wLXJjNi13bC0wNDQ3OC1nZGRjNTA1N2I6NTcwCi9rZXJuZWwveDg2XzY0LXJh
bmRjb25maWctczEtMDkyNDAzNTEvZGRjNTA1N2IwN2VmNzEyNjQzMWQ1ZGY1ZjViMTc2MTU0
ODk2ZjU2MC9kbWVzZy15b2N0by1rYnVpbGQtMTE6MjAxNDA5MjQwMzU2NTI6eDg2XzY0LXJh
bmRjb25maWctczEtMDkyNDAzNTE6My4xNy4wLXJjNi13bC0wNDQ3OC1nZGRjNTA1N2I6NTcw
Ci9rZXJuZWwveDg2XzY0LXJhbmRjb25maWctczEtMDkyNDAzNTEvZGRjNTA1N2IwN2VmNzEy
NjQzMWQ1ZGY1ZjViMTc2MTU0ODk2ZjU2MC9kbWVzZy15b2N0by1rYnVpbGQtMjI6MjAxNDA5
MjQwNDE1MjE6eDg2XzY0LXJhbmRjb25maWctczEtMDkyNDAzNTE6My4xNy4wLXJjNi13bC0w
NDQ3OC1nZGRjNTA1N2I6NTcwCi9rZXJuZWwveDg2XzY0LXJhbmRjb25maWctczEtMDkyNDAz
NTEvZGRjNTA1N2IwN2VmNzEyNjQzMWQ1ZGY1ZjViMTc2MTU0ODk2ZjU2MC9kbWVzZy15b2N0
by1rYnVpbGQtMTY6MjAxNDA5MjQwMzU2NTU6eDg2XzY0LXJhbmRjb25maWctczEtMDkyNDAz
NTE6My4xNy4wLXJjNi13bC0wNDQ3OC1nZGRjNTA1N2I6NTcwCi9rZXJuZWwveDg2XzY0LXJh
bmRjb25maWctczEtMDkyNDAzNTEvZGRjNTA1N2IwN2VmNzEyNjQzMWQ1ZGY1ZjViMTc2MTU0
ODk2ZjU2MC9kbWVzZy15b2N0by12cC0yNzoyMDE0MDkyNDA0MTIwNTp4ODZfNjQtcmFuZGNv
bmZpZy1zMS0wOTI0MDM1MTozLjE3LjAtcmM2LXdsLTA0NDc4LWdkZGM1MDU3Yjo1NzAKL2tl
cm5lbC94ODZfNjQtcmFuZGNvbmZpZy1zMS0wOTI0MDM1MS9kZGM1MDU3YjA3ZWY3MTI2NDMx
ZDVkZjVmNWIxNzYxNTQ4OTZmNTYwL2RtZXNnLXlvY3RvLWxrcC1uZXgwNC0xNTM6MjAxNDA5
MjYxODI0MTQ6eDg2XzY0LXJhbmRjb25maWctczEtMDkyNDAzNTE6Ogova2VybmVsL3g4Nl82
NC1yYW5kY29uZmlnLXMxLTA5MjQwMzUxL2RkYzUwNTdiMDdlZjcxMjY0MzFkNWRmNWY1YjE3
NjE1NDg5NmY1NjAvZG1lc2cteW9jdG8ta2J1aWxkLTMyOjIwMTQwOTI0MDQxMDMwOng4Nl82
NC1yYW5kY29uZmlnLXMxLTA5MjQwMzUxOjMuMTcuMC1yYzYtd2wtMDQ0NzgtZ2RkYzUwNTdi
OjU3MAova2VybmVsL3g4Nl82NC1yYW5kY29uZmlnLXMxLTA5MjQwMzUxL2RkYzUwNTdiMDdl
ZjcxMjY0MzFkNWRmNWY1YjE3NjE1NDg5NmY1NjAvZG1lc2cteW9jdG8ta2J1aWxkLTE3OjIw
MTQwOTI0MDQzOTE5Ong4Nl82NC1yYW5kY29uZmlnLXMxLTA5MjQwMzUxOjMuMTcuMC1yYzYt
d2wtMDQ0NzgtZ2RkYzUwNTdiOjU3MAova2VybmVsL3g4Nl82NC1yYW5kY29uZmlnLXMxLTA5
MjQwMzUxL2RkYzUwNTdiMDdlZjcxMjY0MzFkNWRmNWY1YjE3NjE1NDg5NmY1NjAvZG1lc2ct
eW9jdG8ta2J1aWxkLTE3OjIwMTQwOTI0MDQwMTEzOng4Nl82NC1yYW5kY29uZmlnLXMxLTA5
MjQwMzUxOjMuMTcuMC1yYzYtd2wtMDQ0NzgtZ2RkYzUwNTdiOjU3MAova2VybmVsL3g4Nl82
NC1yYW5kY29uZmlnLXMxLTA5MjQwMzUxL2RkYzUwNTdiMDdlZjcxMjY0MzFkNWRmNWY1YjE3
NjE1NDg5NmY1NjAvZG1lc2cteW9jdG8ta2J1aWxkLTk6MjAxNDA5MjQwNDEzMjE6eDg2XzY0
LXJhbmRjb25maWctczEtMDkyNDAzNTE6My4xNy4wLXJjNi13bC0wNDQ3OC1nZGRjNTA1N2I6
NTcwCi9rZXJuZWwveDg2XzY0LXJhbmRjb25maWctczEtMDkyNDAzNTEvZGRjNTA1N2IwN2Vm
NzEyNjQzMWQ1ZGY1ZjViMTc2MTU0ODk2ZjU2MC9kbWVzZy15b2N0by1rYnVpbGQtMzA6MjAx
NDA5MjQwNDA4NTE6eDg2XzY0LXJhbmRjb25maWctczEtMDkyNDAzNTE6My4xNy4wLXJjNi13
bC0wNDQ3OC1nZGRjNTA1N2I6NTcwCi9rZXJuZWwveDg2XzY0LXJhbmRjb25maWctczEtMDky
NDAzNTEvZGRjNTA1N2IwN2VmNzEyNjQzMWQ1ZGY1ZjViMTc2MTU0ODk2ZjU2MC9kbWVzZy15
b2N0by1rYnVpbGQtMjE6MjAxNDA5MjQwNDM5MjA6eDg2XzY0LXJhbmRjb25maWctczEtMDky
NDAzNTE6My4xNy4wLXJjNi13bC0wNDQ3OC1nZGRjNTA1N2I6NTcwCi9rZXJuZWwveDg2XzY0
LXJhbmRjb25maWctczEtMDkyNDAzNTEvZGRjNTA1N2IwN2VmNzEyNjQzMWQ1ZGY1ZjViMTc2
MTU0ODk2ZjU2MC9kbWVzZy15b2N0by1rYnVpbGQtODoyMDE0MDkyNDA0MTgwMDp4ODZfNjQt
cmFuZGNvbmZpZy1zMS0wOTI0MDM1MTozLjE3LjAtcmM2LXdsLTA0NDc4LWdkZGM1MDU3Yjo1
NzAKL2tlcm5lbC94ODZfNjQtcmFuZGNvbmZpZy1zMS0wOTI0MDM1MS9kZGM1MDU3YjA3ZWY3
MTI2NDMxZDVkZjVmNWIxNzYxNTQ4OTZmNTYwL2RtZXNnLXlvY3RvLWxrcC1uZXgwNC03OToy
MDE0MDkyNjE4MjQxNzp4ODZfNjQtcmFuZGNvbmZpZy1zMS0wOTI0MDM1MTo6Ci9rZXJuZWwv
eDg2XzY0LXJhbmRjb25maWctczEtMDkyNDAzNTEvZGRjNTA1N2IwN2VmNzEyNjQzMWQ1ZGY1
ZjViMTc2MTU0ODk2ZjU2MC9kbWVzZy15b2N0by12cC0xMToyMDE0MDkyNDA0MDAxMzp4ODZf
NjQtcmFuZGNvbmZpZy1zMS0wOTI0MDM1MTozLjE3LjAtcmM2LXdsLTA0NDc4LWdkZGM1MDU3
Yjo1NzAKL2tlcm5lbC94ODZfNjQtcmFuZGNvbmZpZy1zMS0wOTI0MDM1MS9kZGM1MDU3YjA3
ZWY3MTI2NDMxZDVkZjVmNWIxNzYxNTQ4OTZmNTYwL2RtZXNnLXlvY3RvLWtidWlsZC05OjIw
MTQwOTI0MDQ0MDUxOng4Nl82NC1yYW5kY29uZmlnLXMxLTA5MjQwMzUxOjMuMTcuMC1yYzYt
d2wtMDQ0NzgtZ2RkYzUwNTdiOjU3MAova2VybmVsL3g4Nl82NC1yYW5kY29uZmlnLXMxLTA5
MjQwMzUxL2RkYzUwNTdiMDdlZjcxMjY0MzFkNWRmNWY1YjE3NjE1NDg5NmY1NjAvZG1lc2ct
eW9jdG8ta2J1aWxkLTE0OjIwMTQwOTI0MDQyOTUyOng4Nl82NC1yYW5kY29uZmlnLXMxLTA5
MjQwMzUxOjMuMTcuMC1yYzYtd2wtMDQ0NzgtZ2RkYzUwNTdiOjU3MAova2VybmVsL3g4Nl82
NC1yYW5kY29uZmlnLXMxLTA5MjQwMzUxL2RkYzUwNTdiMDdlZjcxMjY0MzFkNWRmNWY1YjE3
NjE1NDg5NmY1NjAvZG1lc2cteW9jdG8ta2J1aWxkLTEzOjIwMTQwOTI0MDQyMjUzOng4Nl82
NC1yYW5kY29uZmlnLXMxLTA5MjQwMzUxOjMuMTcuMC1yYzYtd2wtMDQ0NzgtZ2RkYzUwNTdi
OjU3MAova2VybmVsL3g4Nl82NC1yYW5kY29uZmlnLXMxLTA5MjQwMzUxL2RkYzUwNTdiMDdl
ZjcxMjY0MzFkNWRmNWY1YjE3NjE1NDg5NmY1NjAvZG1lc2cteW9jdG8ta2J1aWxkLTE0OjIw
MTQwOTI0MDQwMTE4Ong4Nl82NC1yYW5kY29uZmlnLXMxLTA5MjQwMzUxOjMuMTcuMC1yYzYt
d2wtMDQ0NzgtZ2RkYzUwNTdiOjU3MAova2VybmVsL3g4Nl82NC1yYW5kY29uZmlnLXMxLTA5
MjQwMzUxL2RkYzUwNTdiMDdlZjcxMjY0MzFkNWRmNWY1YjE3NjE1NDg5NmY1NjAvZG1lc2ct
eW9jdG8ta2J1aWxkLTI0OjIwMTQwOTI0MDQxOTQwOng4Nl82NC1yYW5kY29uZmlnLXMxLTA5
MjQwMzUxOjMuMTcuMC1yYzYtd2wtMDQ0NzgtZ2RkYzUwNTdiOjU3MAova2VybmVsL3g4Nl82
NC1yYW5kY29uZmlnLXMxLTA5MjQwMzUxL2RkYzUwNTdiMDdlZjcxMjY0MzFkNWRmNWY1YjE3
NjE1NDg5NmY1NjAvZG1lc2cteW9jdG8ta2J1aWxkLTE0OjIwMTQwOTI0MDQzNzIzOng4Nl82
NC1yYW5kY29uZmlnLXMxLTA5MjQwMzUxOjMuMTcuMC1yYzYtd2wtMDQ0NzgtZ2RkYzUwNTdi
OjU3MAova2VybmVsL3g4Nl82NC1yYW5kY29uZmlnLXMxLTA5MjQwMzUxL2RkYzUwNTdiMDdl
ZjcxMjY0MzFkNWRmNWY1YjE3NjE1NDg5NmY1NjAvZG1lc2cteW9jdG8tdnAtNTQ6MjAxNDA5
MjQwNDA1MTY6eDg2XzY0LXJhbmRjb25maWctczEtMDkyNDAzNTE6My4xNy4wLXJjNi13bC0w
NDQ3OC1nZGRjNTA1N2I6NTcwCi9rZXJuZWwveDg2XzY0LXJhbmRjb25maWctczEtMDkyNDAz
NTEvZGRjNTA1N2IwN2VmNzEyNjQzMWQ1ZGY1ZjViMTc2MTU0ODk2ZjU2MC9kbWVzZy15b2N0
by1rYnVpbGQtMzoyMDE0MDkyNDA0MzU0Njp4ODZfNjQtcmFuZGNvbmZpZy1zMS0wOTI0MDM1
MTozLjE3LjAtcmM2LXdsLTA0NDc4LWdkZGM1MDU3Yjo1NzAKL2tlcm5lbC94ODZfNjQtcmFu
ZGNvbmZpZy1zMS0wOTI0MDM1MS9kZGM1MDU3YjA3ZWY3MTI2NDMxZDVkZjVmNWIxNzYxNTQ4
OTZmNTYwL2RtZXNnLXlvY3RvLWtidWlsZC0yODoyMDE0MDkyNDA0MTk0NTp4ODZfNjQtcmFu
ZGNvbmZpZy1zMS0wOTI0MDM1MTozLjE3LjAtcmM2LXdsLTA0NDc4LWdkZGM1MDU3Yjo1NzAK
L2tlcm5lbC94ODZfNjQtcmFuZGNvbmZpZy1zMS0wOTI0MDM1MS9kZGM1MDU3YjA3ZWY3MTI2
NDMxZDVkZjVmNWIxNzYxNTQ4OTZmNTYwL2RtZXNnLXlvY3RvLWtidWlsZC0xMDoyMDE0MDky
NDA0MjYxMDp4ODZfNjQtcmFuZGNvbmZpZy1zMS0wOTI0MDM1MTozLjE3LjAtcmM2LXdsLTA0
NDc4LWdkZGM1MDU3Yjo1NzAKL2tlcm5lbC94ODZfNjQtcmFuZGNvbmZpZy1zMS0wOTI0MDM1
MS9kZGM1MDU3YjA3ZWY3MTI2NDMxZDVkZjVmNWIxNzYxNTQ4OTZmNTYwL2RtZXNnLXlvY3Rv
LWtidWlsZC0yNDoyMDE0MDkyNDA0MzE1ODp4ODZfNjQtcmFuZGNvbmZpZy1zMS0wOTI0MDM1
MTozLjE3LjAtcmM2LXdsLTA0NDc4LWdkZGM1MDU3Yjo1NzAKL2tlcm5lbC94ODZfNjQtcmFu
ZGNvbmZpZy1zMS0wOTI0MDM1MS9kZGM1MDU3YjA3ZWY3MTI2NDMxZDVkZjVmNWIxNzYxNTQ4
OTZmNTYwL2RtZXNnLXlvY3RvLWtidWlsZC0xOjIwMTQwOTI0MDQzNTQ1Ong4Nl82NC1yYW5k
Y29uZmlnLXMxLTA5MjQwMzUxOjMuMTcuMC1yYzYtd2wtMDQ0NzgtZ2RkYzUwNTdiOjU3MAov
a2VybmVsL3g4Nl82NC1yYW5kY29uZmlnLXMxLTA5MjQwMzUxL2RkYzUwNTdiMDdlZjcxMjY0
MzFkNWRmNWY1YjE3NjE1NDg5NmY1NjAvZG1lc2cteW9jdG8ta2J1aWxkLTU6MjAxNDA5MjQw
NDM4MTg6eDg2XzY0LXJhbmRjb25maWctczEtMDkyNDAzNTE6My4xNy4wLXJjNi13bC0wNDQ3
OC1nZGRjNTA1N2I6NTcwCi9rZXJuZWwveDg2XzY0LXJhbmRjb25maWctczEtMDkyNDAzNTEv
ZGRjNTA1N2IwN2VmNzEyNjQzMWQ1ZGY1ZjViMTc2MTU0ODk2ZjU2MC9kbWVzZy15b2N0by12
cC0xOToyMDE0MDkyNDA0MDUxNjp4ODZfNjQtcmFuZGNvbmZpZy1zMS0wOTI0MDM1MTozLjE3
LjAtcmM2LXdsLTA0NDc4LWdkZGM1MDU3Yjo1NzAKL2tlcm5lbC94ODZfNjQtcmFuZGNvbmZp
Zy1zMS0wOTI0MDM1MS9kZGM1MDU3YjA3ZWY3MTI2NDMxZDVkZjVmNWIxNzYxNTQ4OTZmNTYw
L2RtZXNnLXlvY3RvLWtidWlsZC0xNDoyMDE0MDkyNDA0MzkyMDp4ODZfNjQtcmFuZGNvbmZp
Zy1zMS0wOTI0MDM1MTozLjE3LjAtcmM2LXdsLTA0NDc4LWdkZGM1MDU3Yjo1NzAKL2tlcm5l
bC94ODZfNjQtcmFuZGNvbmZpZy1zMS0wOTI0MDM1MS9kZGM1MDU3YjA3ZWY3MTI2NDMxZDVk
ZjVmNWIxNzYxNTQ4OTZmNTYwL2RtZXNnLXlvY3RvLWtidWlsZC0yNToyMDE0MDkyNDA0MTYy
Mjp4ODZfNjQtcmFuZGNvbmZpZy1zMS0wOTI0MDM1MTozLjE3LjAtcmM2LXdsLTA0NDc4LWdk
ZGM1MDU3Yjo1NzAKL2tlcm5lbC94ODZfNjQtcmFuZGNvbmZpZy1zMS0wOTI0MDM1MS9kZGM1
MDU3YjA3ZWY3MTI2NDMxZDVkZjVmNWIxNzYxNTQ4OTZmNTYwL2RtZXNnLXlvY3RvLWxrcC1u
ZXgwNC0xNDU6MjAxNDA5MjYxODI0MTY6eDg2XzY0LXJhbmRjb25maWctczEtMDkyNDAzNTE6
Ogova2VybmVsL3g4Nl82NC1yYW5kY29uZmlnLXMxLTA5MjQwMzUxL2RkYzUwNTdiMDdlZjcx
MjY0MzFkNWRmNWY1YjE3NjE1NDg5NmY1NjAvZG1lc2cteW9jdG8ta2J1aWxkLTMxOjIwMTQw
OTI0MDM1NzI0Ong4Nl82NC1yYW5kY29uZmlnLXMxLTA5MjQwMzUxOjMuMTcuMC1yYzYtd2wt
MDQ0NzgtZ2RkYzUwNTdiOjU3MAova2VybmVsL3g4Nl82NC1yYW5kY29uZmlnLXMxLTA5MjQw
MzUxL2RkYzUwNTdiMDdlZjcxMjY0MzFkNWRmNWY1YjE3NjE1NDg5NmY1NjAvZG1lc2cteW9j
dG8tdnAtNTI6MjAxNDA5MjQwNDAxMjg6eDg2XzY0LXJhbmRjb25maWctczEtMDkyNDAzNTE6
My4xNy4wLXJjNi13bC0wNDQ3OC1nZGRjNTA1N2I6NTcwCi9rZXJuZWwveDg2XzY0LXJhbmRj
b25maWctczEtMDkyNDAzNTEvZGRjNTA1N2IwN2VmNzEyNjQzMWQ1ZGY1ZjViMTc2MTU0ODk2
ZjU2MC9kbWVzZy15b2N0by1rYnVpbGQtMTQ6MjAxNDA5MjQwNDIyMTU6eDg2XzY0LXJhbmRj
b25maWctczEtMDkyNDAzNTE6My4xNy4wLXJjNi13bC0wNDQ3OC1nZGRjNTA1N2I6NTcwCi9r
ZXJuZWwveDg2XzY0LXJhbmRjb25maWctczEtMDkyNDAzNTEvZGRjNTA1N2IwN2VmNzEyNjQz
MWQ1ZGY1ZjViMTc2MTU0ODk2ZjU2MC9kbWVzZy15b2N0by1rYnVpbGQtMTg6MjAxNDA5MjQw
NDE2NTU6eDg2XzY0LXJhbmRjb25maWctczEtMDkyNDAzNTE6My4xNy4wLXJjNi13bC0wNDQ3
OC1nZGRjNTA1N2I6NTcwCi9rZXJuZWwveDg2XzY0LXJhbmRjb25maWctczEtMDkyNDAzNTEv
ZGRjNTA1N2IwN2VmNzEyNjQzMWQ1ZGY1ZjViMTc2MTU0ODk2ZjU2MC9kbWVzZy15b2N0by12
cC01NDoyMDE0MDkyNDA0MTQ1ODp4ODZfNjQtcmFuZGNvbmZpZy1zMS0wOTI0MDM1MTozLjE3
LjAtcmM2LXdsLTA0NDc4LWdkZGM1MDU3Yjo1NzAKL2tlcm5lbC94ODZfNjQtcmFuZGNvbmZp
Zy1zMS0wOTI0MDM1MS9kZGM1MDU3YjA3ZWY3MTI2NDMxZDVkZjVmNWIxNzYxNTQ4OTZmNTYw
L2RtZXNnLXlvY3RvLWtidWlsZC0xNjoyMDE0MDkyNDA0MTMxOTp4ODZfNjQtcmFuZGNvbmZp
Zy1zMS0wOTI0MDM1MTozLjE3LjAtcmM2LXdsLTA0NDc4LWdkZGM1MDU3Yjo1NzAKL2tlcm5l
bC94ODZfNjQtcmFuZGNvbmZpZy1zMS0wOTI0MDM1MS9kZGM1MDU3YjA3ZWY3MTI2NDMxZDVk
ZjVmNWIxNzYxNTQ4OTZmNTYwL2RtZXNnLXlvY3RvLWtidWlsZC0xODoyMDE0MDkyNDA0Mzgx
Nzp4ODZfNjQtcmFuZGNvbmZpZy1zMS0wOTI0MDM1MTozLjE3LjAtcmM2LXdsLTA0NDc4LWdk
ZGM1MDU3Yjo1NzAKL2tlcm5lbC94ODZfNjQtcmFuZGNvbmZpZy1zMS0wOTI0MDM1MS9kZGM1
MDU3YjA3ZWY3MTI2NDMxZDVkZjVmNWIxNzYxNTQ4OTZmNTYwL2RtZXNnLXlvY3RvLXZwLTEy
OjIwMTQwOTI0MDQxMDUzOng4Nl82NC1yYW5kY29uZmlnLXMxLTA5MjQwMzUxOjMuMTcuMC1y
YzYtd2wtMDQ0NzgtZ2RkYzUwNTdiOjU3MAova2VybmVsL3g4Nl82NC1yYW5kY29uZmlnLXMx
LTA5MjQwMzUxL2RkYzUwNTdiMDdlZjcxMjY0MzFkNWRmNWY1YjE3NjE1NDg5NmY1NjAvZG1l
c2cteW9jdG8ta2J1aWxkLTExOjIwMTQwOTI0MDQxMDI3Ong4Nl82NC1yYW5kY29uZmlnLXMx
LTA5MjQwMzUxOjMuMTcuMC1yYzYtd2wtMDQ0NzgtZ2RkYzUwNTdiOjU3MAova2VybmVsL3g4
Nl82NC1yYW5kY29uZmlnLXMxLTA5MjQwMzUxL2RkYzUwNTdiMDdlZjcxMjY0MzFkNWRmNWY1
YjE3NjE1NDg5NmY1NjAvZG1lc2cteW9jdG8ta2J1aWxkLTE6MjAxNDA5MjQwNDAxMTI6eDg2
XzY0LXJhbmRjb25maWctczEtMDkyNDAzNTE6My4xNy4wLXJjNi13bC0wNDQ3OC1nZGRjNTA1
N2I6NTcwCi9rZXJuZWwveDg2XzY0LXJhbmRjb25maWctczEtMDkyNDAzNTEvZGRjNTA1N2Iw
N2VmNzEyNjQzMWQ1ZGY1ZjViMTc2MTU0ODk2ZjU2MC9kbWVzZy15b2N0by1rYnVpbGQtMjA6
MjAxNDA5MjQwNDExNDM6eDg2XzY0LXJhbmRjb25maWctczEtMDkyNDAzNTE6My4xNy4wLXJj
Ni13bC0wNDQ3OC1nZGRjNTA1N2I6NTcwCi9rZXJuZWwveDg2XzY0LXJhbmRjb25maWctczEt
MDkyNDAzNTEvZGRjNTA1N2IwN2VmNzEyNjQzMWQ1ZGY1ZjViMTc2MTU0ODk2ZjU2MC9kbWVz
Zy15b2N0by12cC01NToyMDE0MDkyNDA0MDEyNDp4ODZfNjQtcmFuZGNvbmZpZy1zMS0wOTI0
MDM1MTozLjE3LjAtcmM2LXdsLTA0NDc4LWdkZGM1MDU3Yjo1NzAKL2tlcm5lbC94ODZfNjQt
cmFuZGNvbmZpZy1zMS0wOTI0MDM1MS9kZGM1MDU3YjA3ZWY3MTI2NDMxZDVkZjVmNWIxNzYx
NTQ4OTZmNTYwL2RtZXNnLXlvY3RvLWtidWlsZC0yNToyMDE0MDkyNDA0MjIyMjp4ODZfNjQt
cmFuZGNvbmZpZy1zMS0wOTI0MDM1MTozLjE3LjAtcmM2LXdsLTA0NDc4LWdkZGM1MDU3Yjo1
NzAKL2tlcm5lbC94ODZfNjQtcmFuZGNvbmZpZy1zMS0wOTI0MDM1MS9kZGM1MDU3YjA3ZWY3
MTI2NDMxZDVkZjVmNWIxNzYxNTQ4OTZmNTYwL2RtZXNnLXlvY3RvLWtidWlsZC0yOToyMDE0
MDkyNDA0MzMzOTp4ODZfNjQtcmFuZGNvbmZpZy1zMS0wOTI0MDM1MTozLjE3LjAtcmM2LXds
LTA0NDc4LWdkZGM1MDU3Yjo1NzAKL2tlcm5lbC94ODZfNjQtcmFuZGNvbmZpZy1zMS0wOTI0
MDM1MS9kZGM1MDU3YjA3ZWY3MTI2NDMxZDVkZjVmNWIxNzYxNTQ4OTZmNTYwL2RtZXNnLXlv
Y3RvLWtidWlsZC0yMDoyMDE0MDkyNDA0MTgzNzp4ODZfNjQtcmFuZGNvbmZpZy1zMS0wOTI0
MDM1MTozLjE3LjAtcmM2LXdsLTA0NDc4LWdkZGM1MDU3Yjo1NzAKL2tlcm5lbC94ODZfNjQt
cmFuZGNvbmZpZy1zMS0wOTI0MDM1MS9kZGM1MDU3YjA3ZWY3MTI2NDMxZDVkZjVmNWIxNzYx
NTQ4OTZmNTYwL2RtZXNnLXlvY3RvLWtidWlsZC03OjIwMTQwOTI0MDQxMzE5Ong4Nl82NC1y
YW5kY29uZmlnLXMxLTA5MjQwMzUxOjMuMTcuMC1yYzYtd2wtMDQ0NzgtZ2RkYzUwNTdiOjU3
MAova2VybmVsL3g4Nl82NC1yYW5kY29uZmlnLXMxLTA5MjQwMzUxL2RkYzUwNTdiMDdlZjcx
MjY0MzFkNWRmNWY1YjE3NjE1NDg5NmY1NjAvZG1lc2cteW9jdG8ta2J1aWxkLTEwOjIwMTQw
OTI0MDQxMDI3Ong4Nl82NC1yYW5kY29uZmlnLXMxLTA5MjQwMzUxOjMuMTcuMC1yYzYtd2wt
MDQ0NzgtZ2RkYzUwNTdiOjU3MAova2VybmVsL3g4Nl82NC1yYW5kY29uZmlnLXMxLTA5MjQw
MzUxL2RkYzUwNTdiMDdlZjcxMjY0MzFkNWRmNWY1YjE3NjE1NDg5NmY1NjAvZG1lc2cteW9j
dG8ta2J1aWxkLTg6MjAxNDA5MjQwNDMyMDE6eDg2XzY0LXJhbmRjb25maWctczEtMDkyNDAz
NTE6My4xNy4wLXJjNi13bC0wNDQ3OC1nZGRjNTA1N2I6NTcwCi9rZXJuZWwveDg2XzY0LXJh
bmRjb25maWctczEtMDkyNDAzNTEvZGRjNTA1N2IwN2VmNzEyNjQzMWQ1ZGY1ZjViMTc2MTU0
ODk2ZjU2MC9kbWVzZy15b2N0by1rYnVpbGQtNjoyMDE0MDkyNDA0MzcyMDp4ODZfNjQtcmFu
ZGNvbmZpZy1zMS0wOTI0MDM1MTozLjE3LjAtcmM2LXdsLTA0NDc4LWdkZGM1MDU3Yjo1NzAK
L2tlcm5lbC94ODZfNjQtcmFuZGNvbmZpZy1zMS0wOTI0MDM1MS9kZGM1MDU3YjA3ZWY3MTI2
NDMxZDVkZjVmNWIxNzYxNTQ4OTZmNTYwL2RtZXNnLXlvY3RvLWtidWlsZC0yOjIwMTQwOTI0
MDQxOTQ2Ong4Nl82NC1yYW5kY29uZmlnLXMxLTA5MjQwMzUxOjMuMTcuMC1yYzYtd2wtMDQ0
NzgtZ2RkYzUwNTdiOjU3MAova2VybmVsL3g4Nl82NC1yYW5kY29uZmlnLXMxLTA5MjQwMzUx
L2RkYzUwNTdiMDdlZjcxMjY0MzFkNWRmNWY1YjE3NjE1NDg5NmY1NjAvZG1lc2cteW9jdG8t
a2J1aWxkLTIyOjIwMTQwOTI0MDQzODE5Ong4Nl82NC1yYW5kY29uZmlnLXMxLTA5MjQwMzUx
OjMuMTcuMC1yYzYtd2wtMDQ0NzgtZ2RkYzUwNTdiOjU3MAova2VybmVsL3g4Nl82NC1yYW5k
Y29uZmlnLXMxLTA5MjQwMzUxL2RkYzUwNTdiMDdlZjcxMjY0MzFkNWRmNWY1YjE3NjE1NDg5
NmY1NjAvZG1lc2cteW9jdG8ta2J1aWxkLTE5OjIwMTQwOTI0MDQyNDMzOng4Nl82NC1yYW5k
Y29uZmlnLXMxLTA5MjQwMzUxOjMuMTcuMC1yYzYtd2wtMDQ0NzgtZ2RkYzUwNTdiOjU3MAov
a2VybmVsL3g4Nl82NC1yYW5kY29uZmlnLXMxLTA5MjQwMzUxL2RkYzUwNTdiMDdlZjcxMjY0
MzFkNWRmNWY1YjE3NjE1NDg5NmY1NjAvZG1lc2cteW9jdG8ta2J1aWxkLTY6MjAxNDA5MjQw
NDI2MDk6eDg2XzY0LXJhbmRjb25maWctczEtMDkyNDAzNTE6My4xNy4wLXJjNi13bC0wNDQ3
OC1nZGRjNTA1N2I6NTcwCi9rZXJuZWwveDg2XzY0LXJhbmRjb25maWctczEtMDkyNDAzNTEv
ZGRjNTA1N2IwN2VmNzEyNjQzMWQ1ZGY1ZjViMTc2MTU0ODk2ZjU2MC9kbWVzZy15b2N0by1r
YnVpbGQtMTI6MjAxNDA5MjQwNDE1MTU6eDg2XzY0LXJhbmRjb25maWctczEtMDkyNDAzNTE6
My4xNy4wLXJjNi13bC0wNDQ3OC1nZGRjNTA1N2I6NTcwCi9rZXJuZWwveDg2XzY0LXJhbmRj
b25maWctczEtMDkyNDAzNTEvZGRjNTA1N2IwN2VmNzEyNjQzMWQ1ZGY1ZjViMTc2MTU0ODk2
ZjU2MC9kbWVzZy15b2N0by1rYnVpbGQtODoyMDE0MDkyNDA0MTYyNTp4ODZfNjQtcmFuZGNv
bmZpZy1zMS0wOTI0MDM1MTozLjE3LjAtcmM2LXdsLTA0NDc4LWdkZGM1MDU3Yjo1NzAKL2tl
cm5lbC94ODZfNjQtcmFuZGNvbmZpZy1zMS0wOTI0MDM1MS9kZGM1MDU3YjA3ZWY3MTI2NDMx
ZDVkZjVmNWIxNzYxNTQ4OTZmNTYwL2RtZXNnLXlvY3RvLWtidWlsZC0yOToyMDE0MDkyNDA0
MzYxODp4ODZfNjQtcmFuZGNvbmZpZy1zMS0wOTI0MDM1MTozLjE3LjAtcmM2LXdsLTA0NDc4
LWdkZGM1MDU3Yjo1NzAKL2tlcm5lbC94ODZfNjQtcmFuZGNvbmZpZy1zMS0wOTI0MDM1MS9k
ZGM1MDU3YjA3ZWY3MTI2NDMxZDVkZjVmNWIxNzYxNTQ4OTZmNTYwL2RtZXNnLXlvY3RvLWti
dWlsZC0xNToyMDE0MDkyNDA0MjAxMjp4ODZfNjQtcmFuZGNvbmZpZy1zMS0wOTI0MDM1MToz
LjE3LjAtcmM2LXdsLTA0NDc4LWdkZGM1MDU3Yjo1NzAKL2tlcm5lbC94ODZfNjQtcmFuZGNv
bmZpZy1zMS0wOTI0MDM1MS9kZGM1MDU3YjA3ZWY3MTI2NDMxZDVkZjVmNWIxNzYxNTQ4OTZm
NTYwL2RtZXNnLXlvY3RvLWtidWlsZC0xODoyMDE0MDkyNDA0MzU0Njp4ODZfNjQtcmFuZGNv
bmZpZy1zMS0wOTI0MDM1MTozLjE3LjAtcmM2LXdsLTA0NDc4LWdkZGM1MDU3Yjo1NzAKL2tl
cm5lbC94ODZfNjQtcmFuZGNvbmZpZy1zMS0wOTI0MDM1MS9kZGM1MDU3YjA3ZWY3MTI2NDMx
ZDVkZjVmNWIxNzYxNTQ4OTZmNTYwL2RtZXNnLXlvY3RvLXZwLTEwOjIwMTQwOTI0MDQxMDUz
Ong4Nl82NC1yYW5kY29uZmlnLXMxLTA5MjQwMzUxOjMuMTcuMC1yYzYtd2wtMDQ0NzgtZ2Rk
YzUwNTdiOjU3MAova2VybmVsL3g4Nl82NC1yYW5kY29uZmlnLXMxLTA5MjQwMzUxL2RkYzUw
NTdiMDdlZjcxMjY0MzFkNWRmNWY1YjE3NjE1NDg5NmY1NjAvZG1lc2cteW9jdG8ta2J1aWxk
LTE3OjIwMTQwOTI0MDQxMzIwOng4Nl82NC1yYW5kY29uZmlnLXMxLTA5MjQwMzUxOjMuMTcu
MC1yYzYtd2wtMDQ0NzgtZ2RkYzUwNTdiOjU3MAova2VybmVsL3g4Nl82NC1yYW5kY29uZmln
LXMxLTA5MjQwMzUxL2RkYzUwNTdiMDdlZjcxMjY0MzFkNWRmNWY1YjE3NjE1NDg5NmY1NjAv
ZG1lc2cteW9jdG8ta2J1aWxkLTIxOjIwMTQwOTI0MDQzNzI0Ong4Nl82NC1yYW5kY29uZmln
LXMxLTA5MjQwMzUxOjMuMTcuMC1yYzYtd2wtMDQ0NzgtZ2RkYzUwNTdiOjU3MAova2VybmVs
L3g4Nl82NC1yYW5kY29uZmlnLXMxLTA5MjQwMzUxL2RkYzUwNTdiMDdlZjcxMjY0MzFkNWRm
NWY1YjE3NjE1NDg5NmY1NjAvZG1lc2cteW9jdG8ta2J1aWxkLTE5OjIwMTQwOTI0MDQwOTI0
Ong4Nl82NC1yYW5kY29uZmlnLXMxLTA5MjQwMzUxOjMuMTcuMC1yYzYtd2wtMDQ0NzgtZ2Rk
YzUwNTdiOjU3MAova2VybmVsL3g4Nl82NC1yYW5kY29uZmlnLXMxLTA5MjQwMzUxL2RkYzUw
NTdiMDdlZjcxMjY0MzFkNWRmNWY1YjE3NjE1NDg5NmY1NjAvZG1lc2cteW9jdG8ta2J1aWxk
LTE3OjIwMTQwOTI0MDQyNzQ1Ong4Nl82NC1yYW5kY29uZmlnLXMxLTA5MjQwMzUxOjMuMTcu
MC1yYzYtd2wtMDQ0NzgtZ2RkYzUwNTdiOjU3MAova2VybmVsL3g4Nl82NC1yYW5kY29uZmln
LXMxLTA5MjQwMzUxL2RkYzUwNTdiMDdlZjcxMjY0MzFkNWRmNWY1YjE3NjE1NDg5NmY1NjAv
ZG1lc2cteW9jdG8ta2J1aWxkLTI1OjIwMTQwOTI0MDQxMTAyOng4Nl82NC1yYW5kY29uZmln
LXMxLTA5MjQwMzUxOjMuMTcuMC1yYzYtd2wtMDQ0NzgtZ2RkYzUwNTdiOjU3MAova2VybmVs
L3g4Nl82NC1yYW5kY29uZmlnLXMxLTA5MjQwMzUxL2RkYzUwNTdiMDdlZjcxMjY0MzFkNWRm
NWY1YjE3NjE1NDg5NmY1NjAvZG1lc2cteW9jdG8ta2J1aWxkLTEyOjIwMTQwOTI0MDQ0MDE2
Ong4Nl82NC1yYW5kY29uZmlnLXMxLTA5MjQwMzUxOjMuMTcuMC1yYzYtd2wtMDQ0NzgtZ2Rk
YzUwNTdiOjU3MAova2VybmVsL3g4Nl82NC1yYW5kY29uZmlnLXMxLTA5MjQwMzUxL2RkYzUw
NTdiMDdlZjcxMjY0MzFkNWRmNWY1YjE3NjE1NDg5NmY1NjAvZG1lc2cteW9jdG8ta2J1aWxk
LTEzOjIwMTQwOTI0MDQzNzIxOng4Nl82NC1yYW5kY29uZmlnLXMxLTA5MjQwMzUxOjMuMTcu
MC1yYzYtd2wtMDQ0NzgtZ2RkYzUwNTdiOjU3MAova2VybmVsL3g4Nl82NC1yYW5kY29uZmln
LXMxLTA5MjQwMzUxL2RkYzUwNTdiMDdlZjcxMjY0MzFkNWRmNWY1YjE3NjE1NDg5NmY1NjAv
ZG1lc2cteW9jdG8ta2J1aWxkLTE0OjIwMTQwOTI0MDQzODI0Ong4Nl82NC1yYW5kY29uZmln
LXMxLTA5MjQwMzUxOjMuMTcuMC1yYzYtd2wtMDQ0NzgtZ2RkYzUwNTdiOjU3MAova2VybmVs
L3g4Nl82NC1yYW5kY29uZmlnLXMxLTA5MjQwMzUxL2RkYzUwNTdiMDdlZjcxMjY0MzFkNWRm
NWY1YjE3NjE1NDg5NmY1NjAvZG1lc2cteW9jdG8ta2J1aWxkLTI6MjAxNDA5MjQwNDMzMDg6
eDg2XzY0LXJhbmRjb25maWctczEtMDkyNDAzNTE6My4xNy4wLXJjNi13bC0wNDQ3OC1nZGRj
NTA1N2I6NTcwCi9rZXJuZWwveDg2XzY0LXJhbmRjb25maWctczEtMDkyNDAzNTEvZGRjNTA1
N2IwN2VmNzEyNjQzMWQ1ZGY1ZjViMTc2MTU0ODk2ZjU2MC9kbWVzZy15b2N0by1sa3AtbmV4
MDQtMTc6MjAxNDA5MjYxODI0MTc6eDg2XzY0LXJhbmRjb25maWctczEtMDkyNDAzNTE6Ogov
a2VybmVsL3g4Nl82NC1yYW5kY29uZmlnLXMxLTA5MjQwMzUxL2RkYzUwNTdiMDdlZjcxMjY0
MzFkNWRmNWY1YjE3NjE1NDg5NmY1NjAvZG1lc2cteW9jdG8tdnAtMjE6MjAxNDA5MjQwNDA1
MTQ6eDg2XzY0LXJhbmRjb25maWctczEtMDkyNDAzNTE6My4xNy4wLXJjNi13bC0wNDQ3OC1n
ZGRjNTA1N2I6NTcwCi9rZXJuZWwveDg2XzY0LXJhbmRjb25maWctczEtMDkyNDAzNTEvZGRj
NTA1N2IwN2VmNzEyNjQzMWQ1ZGY1ZjViMTc2MTU0ODk2ZjU2MC9kbWVzZy15b2N0by1rYnVp
bGQtMTM6MjAxNDA5MjQwNDI4MTI6eDg2XzY0LXJhbmRjb25maWctczEtMDkyNDAzNTE6My4x
Ny4wLXJjNi13bC0wNDQ3OC1nZGRjNTA1N2I6NTcwCi9rZXJuZWwveDg2XzY0LXJhbmRjb25m
aWctczEtMDkyNDAzNTEvZGRjNTA1N2IwN2VmNzEyNjQzMWQ1ZGY1ZjViMTc2MTU0ODk2ZjU2
MC9kbWVzZy15b2N0by12cC0xOToyMDE0MDkyNDA0MTA1NDp4ODZfNjQtcmFuZGNvbmZpZy1z
MS0wOTI0MDM1MTozLjE3LjAtcmM2LXdsLTA0NDc4LWdkZGM1MDU3Yjo1NzAKL2tlcm5lbC94
ODZfNjQtcmFuZGNvbmZpZy1zMS0wOTI0MDM1MS9kZGM1MDU3YjA3ZWY3MTI2NDMxZDVkZjVm
NWIxNzYxNTQ4OTZmNTYwL2RtZXNnLXlvY3RvLWtidWlsZC04OjIwMTQwOTI0MDQxMjExOng4
Nl82NC1yYW5kY29uZmlnLXMxLTA5MjQwMzUxOjMuMTcuMC1yYzYtd2wtMDQ0NzgtZ2RkYzUw
NTdiOjU3MAova2VybmVsL3g4Nl82NC1yYW5kY29uZmlnLXMxLTA5MjQwMzUxL2RkYzUwNTdi
MDdlZjcxMjY0MzFkNWRmNWY1YjE3NjE1NDg5NmY1NjAvZG1lc2cteW9jdG8tdnAtNDM6MjAx
NDA5MjQwNDAxMjM6eDg2XzY0LXJhbmRjb25maWctczEtMDkyNDAzNTE6My4xNy4wLXJjNi13
bC0wNDQ3OC1nZGRjNTA1N2I6NTcwCi9rZXJuZWwveDg2XzY0LXJhbmRjb25maWctczEtMDky
NDAzNTEvZGRjNTA1N2IwN2VmNzEyNjQzMWQ1ZGY1ZjViMTc2MTU0ODk2ZjU2MC9kbWVzZy15
b2N0by1rYnVpbGQtNzoyMDE0MDkyNDAzNTYyNTp4ODZfNjQtcmFuZGNvbmZpZy1zMS0wOTI0
MDM1MTozLjE3LjAtcmM2LXdsLTA0NDc4LWdkZGM1MDU3Yjo1NzAKL2tlcm5lbC94ODZfNjQt
cmFuZGNvbmZpZy1zMS0wOTI0MDM1MS9kZGM1MDU3YjA3ZWY3MTI2NDMxZDVkZjVmNWIxNzYx
NTQ4OTZmNTYwL2RtZXNnLXlvY3RvLXZwLTIwOjIwMTQwOTI0MDQwMDEyOng4Nl82NC1yYW5k
Y29uZmlnLXMxLTA5MjQwMzUxOjMuMTcuMC1yYzYtd2wtMDQ0NzgtZ2RkYzUwNTdiOjU3MAov
a2VybmVsL3g4Nl82NC1yYW5kY29uZmlnLXMxLTA5MjQwMzUxL2RkYzUwNTdiMDdlZjcxMjY0
MzFkNWRmNWY1YjE3NjE1NDg5NmY1NjAvZG1lc2cteW9jdG8ta2J1aWxkLTEwOjIwMTQwOTI0
MDQyNzQ1Ong4Nl82NC1yYW5kY29uZmlnLXMxLTA5MjQwMzUxOjMuMTcuMC1yYzYtd2wtMDQ0
NzgtZ2RkYzUwNTdiOjU3MAova2VybmVsL3g4Nl82NC1yYW5kY29uZmlnLXMxLTA5MjQwMzUx
L2RkYzUwNTdiMDdlZjcxMjY0MzFkNWRmNWY1YjE3NjE1NDg5NmY1NjAvZG1lc2cteW9jdG8t
a2J1aWxkLTEwOjIwMTQwOTI0MDQyOTE5Ong4Nl82NC1yYW5kY29uZmlnLXMxLTA5MjQwMzUx
OjMuMTcuMC1yYzYtd2wtMDQ0NzgtZ2RkYzUwNTdiOjU3MAova2VybmVsL3g4Nl82NC1yYW5k
Y29uZmlnLXMxLTA5MjQwMzUxL2RkYzUwNTdiMDdlZjcxMjY0MzFkNWRmNWY1YjE3NjE1NDg5
NmY1NjAvZG1lc2cteW9jdG8tdnAtMzY6MjAxNDA5MjQwNDAyNDM6eDg2XzY0LXJhbmRjb25m
aWctczEtMDkyNDAzNTE6My4xNy4wLXJjNi13bC0wNDQ3OC1nZGRjNTA1N2I6NTcwCi9rZXJu
ZWwveDg2XzY0LXJhbmRjb25maWctczEtMDkyNDAzNTEvZGRjNTA1N2IwN2VmNzEyNjQzMWQ1
ZGY1ZjViMTc2MTU0ODk2ZjU2MC9kbWVzZy15b2N0by1rYnVpbGQtMTc6MjAxNDA5MjQwNDI5
NTQ6eDg2XzY0LXJhbmRjb25maWctczEtMDkyNDAzNTE6My4xNy4wLXJjNi13bC0wNDQ3OC1n
ZGRjNTA1N2I6NTcwCi9rZXJuZWwveDg2XzY0LXJhbmRjb25maWctczEtMDkyNDAzNTEvZGRj
NTA1N2IwN2VmNzEyNjQzMWQ1ZGY1ZjViMTc2MTU0ODk2ZjU2MC9kbWVzZy15b2N0by12cC0z
NjoyMDE0MDkyNDA0MDUxNDp4ODZfNjQtcmFuZGNvbmZpZy1zMS0wOTI0MDM1MTozLjE3LjAt
cmM2LXdsLTA0NDc4LWdkZGM1MDU3Yjo1NzAKL2tlcm5lbC94ODZfNjQtcmFuZGNvbmZpZy1z
MS0wOTI0MDM1MS9kZGM1MDU3YjA3ZWY3MTI2NDMxZDVkZjVmNWIxNzYxNTQ4OTZmNTYwL2Rt
ZXNnLXlvY3RvLWtidWlsZC0yMzoyMDE0MDkyNDA0MDc0Mjp4ODZfNjQtcmFuZGNvbmZpZy1z
MS0wOTI0MDM1MTozLjE3LjAtcmM2LXdsLTA0NDc4LWdkZGM1MDU3Yjo1NzAKL2tlcm5lbC94
ODZfNjQtcmFuZGNvbmZpZy1zMS0wOTI0MDM1MS9kZGM1MDU3YjA3ZWY3MTI2NDMxZDVkZjVm
NWIxNzYxNTQ4OTZmNTYwL2RtZXNnLXlvY3RvLXZwLTU3OjIwMTQwOTI0MDQwNTE0Ong4Nl82
NC1yYW5kY29uZmlnLXMxLTA5MjQwMzUxOjMuMTcuMC1yYzYtd2wtMDQ0NzgtZ2RkYzUwNTdi
OjU3MAova2VybmVsL3g4Nl82NC1yYW5kY29uZmlnLXMxLTA5MjQwMzUxL2RkYzUwNTdiMDdl
ZjcxMjY0MzFkNWRmNWY1YjE3NjE1NDg5NmY1NjAvZG1lc2cteW9jdG8ta2J1aWxkLTY6MjAx
NDA5MjQwMzU2MjU6eDg2XzY0LXJhbmRjb25maWctczEtMDkyNDAzNTE6My4xNy4wLXJjNi13
bC0wNDQ3OC1nZGRjNTA1N2I6NTcwCi9rZXJuZWwveDg2XzY0LXJhbmRjb25maWctczEtMDky
NDAzNTEvZGRjNTA1N2IwN2VmNzEyNjQzMWQ1ZGY1ZjViMTc2MTU0ODk2ZjU2MC9kbWVzZy15
b2N0by1rYnVpbGQtMjY6MjAxNDA5MjQwNDE2MjM6eDg2XzY0LXJhbmRjb25maWctczEtMDky
NDAzNTE6My4xNy4wLXJjNi13bC0wNDQ3OC1nZGRjNTA1N2I6NTcwCi9rZXJuZWwveDg2XzY0
LXJhbmRjb25maWctczEtMDkyNDAzNTEvZGRjNTA1N2IwN2VmNzEyNjQzMWQ1ZGY1ZjViMTc2
MTU0ODk2ZjU2MC9kbWVzZy15b2N0by12cC0xNToyMDE0MDkyNDA0MDUxODp4ODZfNjQtcmFu
ZGNvbmZpZy1zMS0wOTI0MDM1MTozLjE3LjAtcmM2LXdsLTA0NDc4LWdkZGM1MDU3Yjo1NzAK
L2tlcm5lbC94ODZfNjQtcmFuZGNvbmZpZy1zMS0wOTI0MDM1MS9kZGM1MDU3YjA3ZWY3MTI2
NDMxZDVkZjVmNWIxNzYxNTQ4OTZmNTYwL2RtZXNnLXlvY3RvLWtidWlsZC0yNDoyMDE0MDky
NDA0Mjk1Mzp4ODZfNjQtcmFuZGNvbmZpZy1zMS0wOTI0MDM1MTozLjE3LjAtcmM2LXdsLTA0
NDc4LWdkZGM1MDU3Yjo1NzAKL2tlcm5lbC94ODZfNjQtcmFuZGNvbmZpZy1zMS0wOTI0MDM1
MS9kZGM1MDU3YjA3ZWY3MTI2NDMxZDVkZjVmNWIxNzYxNTQ4OTZmNTYwL2RtZXNnLXlvY3Rv
LWtidWlsZC0xMjoyMDE0MDkyNDA0MzEyNTp4ODZfNjQtcmFuZGNvbmZpZy1zMS0wOTI0MDM1
MTozLjE3LjAtcmM2LXdsLTA0NDc4LWdkZGM1MDU3Yjo1NzAKL2tlcm5lbC94ODZfNjQtcmFu
ZGNvbmZpZy1zMS0wOTI0MDM1MS9kZGM1MDU3YjA3ZWY3MTI2NDMxZDVkZjVmNWIxNzYxNTQ4
OTZmNTYwL2RtZXNnLXlvY3RvLWtidWlsZC0yNToyMDE0MDkyNDA0MDc0Mjp4ODZfNjQtcmFu
ZGNvbmZpZy1zMS0wOTI0MDM1MTozLjE3LjAtcmM2LXdsLTA0NDc4LWdkZGM1MDU3Yjo1NzAK
L2tlcm5lbC94ODZfNjQtcmFuZGNvbmZpZy1zMS0wOTI0MDM1MS9kZGM1MDU3YjA3ZWY3MTI2
NDMxZDVkZjVmNWIxNzYxNTQ4OTZmNTYwL2RtZXNnLXlvY3RvLWtidWlsZC0yMToyMDE0MDky
NDA0MzY0OTp4ODZfNjQtcmFuZGNvbmZpZy1zMS0wOTI0MDM1MTozLjE3LjAtcmM2LXdsLTA0
NDc4LWdkZGM1MDU3Yjo1NzAKL2tlcm5lbC94ODZfNjQtcmFuZGNvbmZpZy1zMS0wOTI0MDM1
MS9kZGM1MDU3YjA3ZWY3MTI2NDMxZDVkZjVmNWIxNzYxNTQ4OTZmNTYwL2RtZXNnLXlvY3Rv
LWtidWlsZC0yOToyMDE0MDkyNDA0MjYxMDp4ODZfNjQtcmFuZGNvbmZpZy1zMS0wOTI0MDM1
MTozLjE3LjAtcmM2LXdsLTA0NDc4LWdkZGM1MDU3Yjo1NzAKL2tlcm5lbC94ODZfNjQtcmFu
ZGNvbmZpZy1zMS0wOTI0MDM1MS9kZGM1MDU3YjA3ZWY3MTI2NDMxZDVkZjVmNWIxNzYxNTQ4
OTZmNTYwL2RtZXNnLXlvY3RvLWtidWlsZC0xNToyMDE0MDkyNDA0MjI1Mzp4ODZfNjQtcmFu
ZGNvbmZpZy1zMS0wOTI0MDM1MTozLjE3LjAtcmM2LXdsLTA0NDc4LWdkZGM1MDU3Yjo1NzAK
L2tlcm5lbC94ODZfNjQtcmFuZGNvbmZpZy1zMS0wOTI0MDM1MS9kZGM1MDU3YjA3ZWY3MTI2
NDMxZDVkZjVmNWIxNzYxNTQ4OTZmNTYwL2RtZXNnLXlvY3RvLWtidWlsZC0yMjoyMDE0MDky
NDA0Mjk1Mzp4ODZfNjQtcmFuZGNvbmZpZy1zMS0wOTI0MDM1MTozLjE3LjAtcmM2LXdsLTA0
NDc4LWdkZGM1MDU3Yjo1NzAKL2tlcm5lbC94ODZfNjQtcmFuZGNvbmZpZy1zMS0wOTI0MDM1
MS9kZGM1MDU3YjA3ZWY3MTI2NDMxZDVkZjVmNWIxNzYxNTQ4OTZmNTYwL2RtZXNnLXlvY3Rv
LWtidWlsZC0yMjoyMDE0MDkyNDA0MDExNDp4ODZfNjQtcmFuZGNvbmZpZy1zMS0wOTI0MDM1
MTozLjE3LjAtcmM2LXdsLTA0NDc4LWdkZGM1MDU3Yjo1NzAKL2tlcm5lbC94ODZfNjQtcmFu
ZGNvbmZpZy1zMS0wOTI0MDM1MS9kZGM1MDU3YjA3ZWY3MTI2NDMxZDVkZjVmNWIxNzYxNTQ4
OTZmNTYwL2RtZXNnLXlvY3RvLWtidWlsZC0zMjoyMDE0MDkyNDA0MjcxMTp4ODZfNjQtcmFu
ZGNvbmZpZy1zMS0wOTI0MDM1MTozLjE3LjAtcmM2LXdsLTA0NDc4LWdkZGM1MDU3Yjo1NzAK
L2tlcm5lbC94ODZfNjQtcmFuZGNvbmZpZy1zMS0wOTI0MDM1MS9kZGM1MDU3YjA3ZWY3MTI2
NDMxZDVkZjVmNWIxNzYxNTQ4OTZmNTYwL2RtZXNnLXlvY3RvLWtidWlsZC0xNDoyMDE0MDky
NDA0MjkxNzp4ODZfNjQtcmFuZGNvbmZpZy1zMS0wOTI0MDM1MTozLjE3LjAtcmM2LXdsLTA0
NDc4LWdkZGM1MDU3Yjo1NzAKL2tlcm5lbC94ODZfNjQtcmFuZGNvbmZpZy1zMS0wOTI0MDM1
MS9kZGM1MDU3YjA3ZWY3MTI2NDMxZDVkZjVmNWIxNzYxNTQ4OTZmNTYwL2RtZXNnLXlvY3Rv
LWtidWlsZC0yMDoyMDE0MDkyNDA0MDc0MDp4ODZfNjQtcmFuZGNvbmZpZy1zMS0wOTI0MDM1
MTozLjE3LjAtcmM2LXdsLTA0NDc4LWdkZGM1MDU3Yjo1NzAKL2tlcm5lbC94ODZfNjQtcmFu
ZGNvbmZpZy1zMS0wOTI0MDM1MS9kZGM1MDU3YjA3ZWY3MTI2NDMxZDVkZjVmNWIxNzYxNTQ4
OTZmNTYwL2RtZXNnLXlvY3RvLWtidWlsZC0yNDoyMDE0MDkyNDA0MTgwMDp4ODZfNjQtcmFu
ZGNvbmZpZy1zMS0wOTI0MDM1MTozLjE3LjAtcmM2LXdsLTA0NDc4LWdkZGM1MDU3Yjo1NzAK
L2tlcm5lbC94ODZfNjQtcmFuZGNvbmZpZy1zMS0wOTI0MDM1MS9kZGM1MDU3YjA3ZWY3MTI2
NDMxZDVkZjVmNWIxNzYxNTQ4OTZmNTYwL2RtZXNnLXlvY3RvLWtidWlsZC0zMDoyMDE0MDky
NDA0MTgzNDp4ODZfNjQtcmFuZGNvbmZpZy1zMS0wOTI0MDM1MTozLjE3LjAtcmM2LXdsLTA0
NDc4LWdkZGM1MDU3Yjo1NzAKL2tlcm5lbC94ODZfNjQtcmFuZGNvbmZpZy1zMS0wOTI0MDM1
MS9kZGM1MDU3YjA3ZWY3MTI2NDMxZDVkZjVmNWIxNzYxNTQ4OTZmNTYwL2RtZXNnLXlvY3Rv
LWtidWlsZC0xNDoyMDE0MDkyNDA0MzMwNzp4ODZfNjQtcmFuZGNvbmZpZy1zMS0wOTI0MDM1
MTozLjE3LjAtcmM2LXdsLTA0NDc4LWdkZGM1MDU3Yjo1NzAKL2tlcm5lbC94ODZfNjQtcmFu
ZGNvbmZpZy1zMS0wOTI0MDM1MS9kZGM1MDU3YjA3ZWY3MTI2NDMxZDVkZjVmNWIxNzYxNTQ4
OTZmNTYwL2RtZXNnLXlvY3RvLWtidWlsZC05OjIwMTQwOTI0MDQzNzIwOng4Nl82NC1yYW5k
Y29uZmlnLXMxLTA5MjQwMzUxOjMuMTcuMC1yYzYtd2wtMDQ0NzgtZ2RkYzUwNTdiOjU3MAov
a2VybmVsL3g4Nl82NC1yYW5kY29uZmlnLXMxLTA5MjQwMzUxL2RkYzUwNTdiMDdlZjcxMjY0
MzFkNWRmNWY1YjE3NjE1NDg5NmY1NjAvZG1lc2cteW9jdG8ta2J1aWxkLTIxOjIwMTQwOTI0
MDQxMDMwOng4Nl82NC1yYW5kY29uZmlnLXMxLTA5MjQwMzUxOjMuMTcuMC1yYzYtd2wtMDQ0
NzgtZ2RkYzUwNTdiOjU3MAova2VybmVsL3g4Nl82NC1yYW5kY29uZmlnLXMxLTA5MjQwMzUx
L2RkYzUwNTdiMDdlZjcxMjY0MzFkNWRmNWY1YjE3NjE1NDg5NmY1NjAvZG1lc2cteW9jdG8t
a2J1aWxkLTMxOjIwMTQwOTI0MDM1MzIxOng4Nl82NC1yYW5kY29uZmlnLXMxLTA5MjQwMzUx
OjMuMTcuMC1yYzYtd2wtMDQ0NzgtZ2RkYzUwNTdiOjU3MAova2VybmVsL3g4Nl82NC1yYW5k
Y29uZmlnLXMxLTA5MjQwMzUxL2RkYzUwNTdiMDdlZjcxMjY0MzFkNWRmNWY1YjE3NjE1NDg5
NmY1NjAvZG1lc2cteW9jdG8tdnAtMjg6MjAxNDA5MjQwNDEwNTM6eDg2XzY0LXJhbmRjb25m
aWctczEtMDkyNDAzNTE6My4xNy4wLXJjNi13bC0wNDQ3OC1nZGRjNTA1N2I6NTcwCi9rZXJu
ZWwveDg2XzY0LXJhbmRjb25maWctczEtMDkyNDAzNTEvZGRjNTA1N2IwN2VmNzEyNjQzMWQ1
ZGY1ZjViMTc2MTU0ODk2ZjU2MC9kbWVzZy15b2N0by1rYnVpbGQtOToyMDE0MDkyNDA0MTIx
Njp4ODZfNjQtcmFuZGNvbmZpZy1zMS0wOTI0MDM1MTozLjE3LjAtcmM2LXdsLTA0NDc4LWdk
ZGM1MDU3Yjo1NzAKL2tlcm5lbC94ODZfNjQtcmFuZGNvbmZpZy1zMS0wOTI0MDM1MS9kZGM1
MDU3YjA3ZWY3MTI2NDMxZDVkZjVmNWIxNzYxNTQ4OTZmNTYwL2RtZXNnLXlvY3RvLWtidWls
ZC04OjIwMTQwOTI0MDQzMDUxOng4Nl82NC1yYW5kY29uZmlnLXMxLTA5MjQwMzUxOjMuMTcu
MC1yYzYtd2wtMDQ0NzgtZ2RkYzUwNTdiOjU3MAova2VybmVsL3g4Nl82NC1yYW5kY29uZmln
LXMxLTA5MjQwMzUxL2RkYzUwNTdiMDdlZjcxMjY0MzFkNWRmNWY1YjE3NjE1NDg5NmY1NjAv
ZG1lc2cteW9jdG8ta2J1aWxkLTMxOjIwMTQwOTI0MDQwMTIwOng4Nl82NC1yYW5kY29uZmln
LXMxLTA5MjQwMzUxOjMuMTcuMC1yYzYtd2wtMDQ0NzgtZ2RkYzUwNTdiOjU3MAova2VybmVs
L3g4Nl82NC1yYW5kY29uZmlnLXMxLTA5MjQwMzUxL2RkYzUwNTdiMDdlZjcxMjY0MzFkNWRm
NWY1YjE3NjE1NDg5NmY1NjAvZG1lc2cteW9jdG8ta2J1aWxkLTY6MjAxNDA5MjQwNDE1MTk6
eDg2XzY0LXJhbmRjb25maWctczEtMDkyNDAzNTE6My4xNy4wLXJjNi13bC0wNDQ3OC1nZGRj
NTA1N2I6NTcwCi9rZXJuZWwveDg2XzY0LXJhbmRjb25maWctczEtMDkyNDAzNTEvZGRjNTA1
N2IwN2VmNzEyNjQzMWQ1ZGY1ZjViMTc2MTU0ODk2ZjU2MC9kbWVzZy15b2N0by1rYnVpbGQt
NDoyMDE0MDkyNDA0MzgxODp4ODZfNjQtcmFuZGNvbmZpZy1zMS0wOTI0MDM1MTozLjE3LjAt
cmM2LXdsLTA0NDc4LWdkZGM1MDU3Yjo1NzAKL2tlcm5lbC94ODZfNjQtcmFuZGNvbmZpZy1z
MS0wOTI0MDM1MS9kZGM1MDU3YjA3ZWY3MTI2NDMxZDVkZjVmNWIxNzYxNTQ4OTZmNTYwL2Rt
ZXNnLXlvY3RvLXZwLTIzOjIwMTQwOTI0MDQxMjAyOng4Nl82NC1yYW5kY29uZmlnLXMxLTA5
MjQwMzUxOjMuMTcuMC1yYzYtd2wtMDQ0NzgtZ2RkYzUwNTdiOjU3MAova2VybmVsL3g4Nl82
NC1yYW5kY29uZmlnLXMxLTA5MjQwMzUxL2RkYzUwNTdiMDdlZjcxMjY0MzFkNWRmNWY1YjE3
NjE1NDg5NmY1NjAvZG1lc2cteW9jdG8ta2J1aWxkLTEzOjIwMTQwOTI0MDQzNDQyOng4Nl82
NC1yYW5kY29uZmlnLXMxLTA5MjQwMzUxOjMuMTcuMC1yYzYtd2wtMDQ0NzgtZ2RkYzUwNTdi
OjU3MAova2VybmVsL3g4Nl82NC1yYW5kY29uZmlnLXMxLTA5MjQwMzUxL2RkYzUwNTdiMDdl
ZjcxMjY0MzFkNWRmNWY1YjE3NjE1NDg5NmY1NjAvZG1lc2cteW9jdG8ta2J1aWxkLTI0OjIw
MTQwOTI0MDQyMjIxOng4Nl82NC1yYW5kY29uZmlnLXMxLTA5MjQwMzUxOjMuMTcuMC1yYzYt
d2wtMDQ0NzgtZ2RkYzUwNTdiOjU3MAova2VybmVsL3g4Nl82NC1yYW5kY29uZmlnLXMxLTA5
MjQwMzUxL2RkYzUwNTdiMDdlZjcxMjY0MzFkNWRmNWY1YjE3NjE1NDg5NmY1NjAvZG1lc2ct
eW9jdG8ta2J1aWxkLTI6MjAxNDA5MjQwNDM0NDM6eDg2XzY0LXJhbmRjb25maWctczEtMDky
NDAzNTE6My4xNy4wLXJjNi13bC0wNDQ3OC1nZGRjNTA1N2I6NTcwCi9rZXJuZWwveDg2XzY0
LXJhbmRjb25maWctczEtMDkyNDAzNTEvZGRjNTA1N2IwN2VmNzEyNjQzMWQ1ZGY1ZjViMTc2
MTU0ODk2ZjU2MC9kbWVzZy15b2N0by1rYnVpbGQtMjQ6MjAxNDA5MjQwNDI5MTc6eDg2XzY0
LXJhbmRjb25maWctczEtMDkyNDAzNTE6My4xNy4wLXJjNi13bC0wNDQ3OC1nZGRjNTA1N2I6
NTcwCi9rZXJuZWwveDg2XzY0LXJhbmRjb25maWctczEtMDkyNDAzNTEvZGRjNTA1N2IwN2Vm
NzEyNjQzMWQ1ZGY1ZjViMTc2MTU0ODk2ZjU2MC9kbWVzZy15b2N0by1rYnVpbGQtMTg6MjAx
NDA5MjQwNDM3Mjc6eDg2XzY0LXJhbmRjb25maWctczEtMDkyNDAzNTE6My4xNy4wLXJjNi13
bC0wNDQ3OC1nZGRjNTA1N2I6NTcwCi9rZXJuZWwveDg2XzY0LXJhbmRjb25maWctczEtMDky
NDAzNTEvZGRjNTA1N2IwN2VmNzEyNjQzMWQ1ZGY1ZjViMTc2MTU0ODk2ZjU2MC9kbWVzZy15
b2N0by1rYnVpbGQtMzI6MjAxNDA5MjQwNDEyMTI6eDg2XzY0LXJhbmRjb25maWctczEtMDky
NDAzNTE6My4xNy4wLXJjNi13bC0wNDQ3OC1nZGRjNTA1N2I6NTcwCi9rZXJuZWwveDg2XzY0
LXJhbmRjb25maWctczEtMDkyNDAzNTEvZGRjNTA1N2IwN2VmNzEyNjQzMWQ1ZGY1ZjViMTc2
MTU0ODk2ZjU2MC9kbWVzZy15b2N0by1rYnVpbGQtMjU6MjAxNDA5MjQwNDEyMTY6eDg2XzY0
LXJhbmRjb25maWctczEtMDkyNDAzNTE6My4xNy4wLXJjNi13bC0wNDQ3OC1nZGRjNTA1N2I6
NTcwCi9rZXJuZWwveDg2XzY0LXJhbmRjb25maWctczEtMDkyNDAzNTEvZGRjNTA1N2IwN2Vm
NzEyNjQzMWQ1ZGY1ZjViMTc2MTU0ODk2ZjU2MC9kbWVzZy15b2N0by1rYnVpbGQtOToyMDE0
MDkyNDA0MzE1ODp4ODZfNjQtcmFuZGNvbmZpZy1zMS0wOTI0MDM1MTozLjE3LjAtcmM2LXds
LTA0NDc4LWdkZGM1MDU3Yjo1NzAKL2tlcm5lbC94ODZfNjQtcmFuZGNvbmZpZy1zMS0wOTI0
MDM1MS9kZGM1MDU3YjA3ZWY3MTI2NDMxZDVkZjVmNWIxNzYxNTQ4OTZmNTYwL2RtZXNnLXlv
Y3RvLXZwLTc6MjAxNDA5MjQwNDEwNTI6eDg2XzY0LXJhbmRjb25maWctczEtMDkyNDAzNTE6
My4xNy4wLXJjNi13bC0wNDQ3OC1nZGRjNTA1N2I6NTcwCi9rZXJuZWwveDg2XzY0LXJhbmRj
b25maWctczEtMDkyNDAzNTEvZGRjNTA1N2IwN2VmNzEyNjQzMWQ1ZGY1ZjViMTc2MTU0ODk2
ZjU2MC9kbWVzZy15b2N0by1rYnVpbGQtMTI6MjAxNDA5MjQwNDI2MDg6eDg2XzY0LXJhbmRj
b25maWctczEtMDkyNDAzNTE6My4xNy4wLXJjNi13bC0wNDQ3OC1nZGRjNTA1N2I6NTcwCi9r
ZXJuZWwveDg2XzY0LXJhbmRjb25maWctczEtMDkyNDAzNTEvZGRjNTA1N2IwN2VmNzEyNjQz
MWQ1ZGY1ZjViMTc2MTU0ODk2ZjU2MC9kbWVzZy15b2N0by1rYnVpbGQtMTg6MjAxNDA5MjQw
NDM5MTk6eDg2XzY0LXJhbmRjb25maWctczEtMDkyNDAzNTE6My4xNy4wLXJjNi13bC0wNDQ3
OC1nZGRjNTA1N2I6NTcwCi9rZXJuZWwveDg2XzY0LXJhbmRjb25maWctczEtMDkyNDAzNTEv
ZGRjNTA1N2IwN2VmNzEyNjQzMWQ1ZGY1ZjViMTc2MTU0ODk2ZjU2MC9kbWVzZy15b2N0by1r
YnVpbGQtMzE6MjAxNDA5MjQwNDM4MjQ6eDg2XzY0LXJhbmRjb25maWctczEtMDkyNDAzNTE6
My4xNy4wLXJjNi13bC0wNDQ3OC1nZGRjNTA1N2I6NTcwCi9rZXJuZWwveDg2XzY0LXJhbmRj
b25maWctczEtMDkyNDAzNTEvZGRjNTA1N2IwN2VmNzEyNjQzMWQ1ZGY1ZjViMTc2MTU0ODk2
ZjU2MC9kbWVzZy15b2N0by1rYnVpbGQtMjI6MjAxNDA5MjQwNDM5MTk6eDg2XzY0LXJhbmRj
b25maWctczEtMDkyNDAzNTE6My4xNy4wLXJjNi13bC0wNDQ3OC1nZGRjNTA1N2I6NTcwCi9r
ZXJuZWwveDg2XzY0LXJhbmRjb25maWctczEtMDkyNDAzNTEvZGRjNTA1N2IwN2VmNzEyNjQz
MWQ1ZGY1ZjViMTc2MTU0ODk2ZjU2MC9kbWVzZy15b2N0by1rYnVpbGQtMTA6MjAxNDA5MjQw
NDI5NTQ6eDg2XzY0LXJhbmRjb25maWctczEtMDkyNDAzNTE6My4xNy4wLXJjNi13bC0wNDQ3
OC1nZGRjNTA1N2I6NTcwCi9rZXJuZWwveDg2XzY0LXJhbmRjb25maWctczEtMDkyNDAzNTEv
ZGRjNTA1N2IwN2VmNzEyNjQzMWQ1ZGY1ZjViMTc2MTU0ODk2ZjU2MC9kbWVzZy15b2N0by1r
YnVpbGQtNjoyMDE0MDkyNDA0MzU0NTp4ODZfNjQtcmFuZGNvbmZpZy1zMS0wOTI0MDM1MToz
LjE3LjAtcmM2LXdsLTA0NDc4LWdkZGM1MDU3Yjo1NzAKL2tlcm5lbC94ODZfNjQtcmFuZGNv
bmZpZy1zMS0wOTI0MDM1MS9kZGM1MDU3YjA3ZWY3MTI2NDMxZDVkZjVmNWIxNzYxNTQ4OTZm
NTYwL2RtZXNnLXlvY3RvLWtidWlsZC0xNToyMDE0MDkyNDA0MTgzNzp4ODZfNjQtcmFuZGNv
bmZpZy1zMS0wOTI0MDM1MTozLjE3LjAtcmM2LXdsLTA0NDc4LWdkZGM1MDU3Yjo1NzAKL2tl
cm5lbC94ODZfNjQtcmFuZGNvbmZpZy1zMS0wOTI0MDM1MS9kZGM1MDU3YjA3ZWY3MTI2NDMx
ZDVkZjVmNWIxNzYxNTQ4OTZmNTYwL2RtZXNnLXlvY3RvLWtidWlsZC0yMjoyMDE0MDkyNDA0
MDkyNTp4ODZfNjQtcmFuZGNvbmZpZy1zMS0wOTI0MDM1MTozLjE3LjAtcmM2LXdsLTA0NDc4
LWdkZGM1MDU3Yjo1NzAKL2tlcm5lbC94ODZfNjQtcmFuZGNvbmZpZy1zMS0wOTI0MDM1MS9k
ZGM1MDU3YjA3ZWY3MTI2NDMxZDVkZjVmNWIxNzYxNTQ4OTZmNTYwL2RtZXNnLXlvY3RvLWti
dWlsZC05OjIwMTQwOTI0MDQyOTU0Ong4Nl82NC1yYW5kY29uZmlnLXMxLTA5MjQwMzUxOjMu
MTcuMC1yYzYtd2wtMDQ0NzgtZ2RkYzUwNTdiOjU3MAova2VybmVsL3g4Nl82NC1yYW5kY29u
ZmlnLXMxLTA5MjQwMzUxL2RkYzUwNTdiMDdlZjcxMjY0MzFkNWRmNWY1YjE3NjE1NDg5NmY1
NjAvZG1lc2cteW9jdG8ta2J1aWxkLTE4OjIwMTQwOTI0MDQwMTE0Ong4Nl82NC1yYW5kY29u
ZmlnLXMxLTA5MjQwMzUxOjMuMTcuMC1yYzYtd2wtMDQ0NzgtZ2RkYzUwNTdiOjU3MAova2Vy
bmVsL3g4Nl82NC1yYW5kY29uZmlnLXMxLTA5MjQwMzUxL2RkYzUwNTdiMDdlZjcxMjY0MzFk
NWRmNWY1YjE3NjE1NDg5NmY1NjAvZG1lc2cteW9jdG8ta2J1aWxkLTI3OjIwMTQwOTI0MDQz
MzA3Ong4Nl82NC1yYW5kY29uZmlnLXMxLTA5MjQwMzUxOjMuMTcuMC1yYzYtd2wtMDQ0Nzgt
Z2RkYzUwNTdiOjU3MAova2VybmVsL3g4Nl82NC1yYW5kY29uZmlnLXMxLTA5MjQwMzUxL2Rk
YzUwNTdiMDdlZjcxMjY0MzFkNWRmNWY1YjE3NjE1NDg5NmY1NjAvZG1lc2cteW9jdG8ta2J1
aWxkLTE3OjIwMTQwOTI0MDQxMjQ1Ong4Nl82NC1yYW5kY29uZmlnLXMxLTA5MjQwMzUxOjMu
MTcuMC1yYzYtd2wtMDQ0NzgtZ2RkYzUwNTdiOjU3MAova2VybmVsL3g4Nl82NC1yYW5kY29u
ZmlnLXMxLTA5MjQwMzUxL2RkYzUwNTdiMDdlZjcxMjY0MzFkNWRmNWY1YjE3NjE1NDg5NmY1
NjAvZG1lc2cteW9jdG8ta2J1aWxkLTIxOjIwMTQwOTI0MDQxMjEzOng4Nl82NC1yYW5kY29u
ZmlnLXMxLTA5MjQwMzUxOjMuMTcuMC1yYzYtd2wtMDQ0NzgtZ2RkYzUwNTdiOjU3MAova2Vy
bmVsL3g4Nl82NC1yYW5kY29uZmlnLXMxLTA5MjQwMzUxL2RkYzUwNTdiMDdlZjcxMjY0MzFk
NWRmNWY1YjE3NjE1NDg5NmY1NjAvZG1lc2cteW9jdG8ta2J1aWxkLTE3OjIwMTQwOTI0MDQw
OTI1Ong4Nl82NC1yYW5kY29uZmlnLXMxLTA5MjQwMzUxOjMuMTcuMC1yYzYtd2wtMDQ0Nzgt
Z2RkYzUwNTdiOjU3MAova2VybmVsL3g4Nl82NC1yYW5kY29uZmlnLXMxLTA5MjQwMzUxL2Rk
YzUwNTdiMDdlZjcxMjY0MzFkNWRmNWY1YjE3NjE1NDg5NmY1NjAvZG1lc2cteW9jdG8ta2J1
aWxkLTE0OjIwMTQwOTI0MDQzMTU3Ong4Nl82NC1yYW5kY29uZmlnLXMxLTA5MjQwMzUxOjMu
MTcuMC1yYzYtd2wtMDQ0NzgtZ2RkYzUwNTdiOjU3MAova2VybmVsL3g4Nl82NC1yYW5kY29u
ZmlnLXMxLTA5MjQwMzUxL2RkYzUwNTdiMDdlZjcxMjY0MzFkNWRmNWY1YjE3NjE1NDg5NmY1
NjAvZG1lc2cteW9jdG8ta2J1aWxkLTEwOjIwMTQwOTI0MDQxMTAyOng4Nl82NC1yYW5kY29u
ZmlnLXMxLTA5MjQwMzUxOjMuMTcuMC1yYzYtd2wtMDQ0NzgtZ2RkYzUwNTdiOjU3MAova2Vy
bmVsL3g4Nl82NC1yYW5kY29uZmlnLXMxLTA5MjQwMzUxL2RkYzUwNTdiMDdlZjcxMjY0MzFk
NWRmNWY1YjE3NjE1NDg5NmY1NjAvZG1lc2cteW9jdG8ta2J1aWxkLTEyOjIwMTQwOTI0MDQy
NzQzOng4Nl82NC1yYW5kY29uZmlnLXMxLTA5MjQwMzUxOjMuMTcuMC1yYzYtd2wtMDQ0Nzgt
Z2RkYzUwNTdiOjU3MAova2VybmVsL3g4Nl82NC1yYW5kY29uZmlnLXMxLTA5MjQwMzUxL2Rk
YzUwNTdiMDdlZjcxMjY0MzFkNWRmNWY1YjE3NjE1NDg5NmY1NjAvZG1lc2cteW9jdG8ta2J1
aWxkLTMyOjIwMTQwOTI0MDQyOTUzOng4Nl82NC1yYW5kY29uZmlnLXMxLTA5MjQwMzUxOjMu
MTcuMC1yYzYtd2wtMDQ0NzgtZ2RkYzUwNTdiOjU3MAova2VybmVsL3g4Nl82NC1yYW5kY29u
ZmlnLXMxLTA5MjQwMzUxL2RkYzUwNTdiMDdlZjcxMjY0MzFkNWRmNWY1YjE3NjE1NDg5NmY1
NjAvZG1lc2cteW9jdG8tdnAtNTI6MjAxNDA5MjQwNDA1MTY6eDg2XzY0LXJhbmRjb25maWct
czEtMDkyNDAzNTE6My4xNy4wLXJjNi13bC0wNDQ3OC1nZGRjNTA1N2I6NTcwCi9rZXJuZWwv
eDg2XzY0LXJhbmRjb25maWctczEtMDkyNDAzNTEvZGRjNTA1N2IwN2VmNzEyNjQzMWQ1ZGY1
ZjViMTc2MTU0ODk2ZjU2MC9kbWVzZy15b2N0by1rYnVpbGQtNToyMDE0MDkyNDA0MzcyMzp4
ODZfNjQtcmFuZGNvbmZpZy1zMS0wOTI0MDM1MTozLjE3LjAtcmM2LXdsLTA0NDc4LWdkZGM1
MDU3Yjo1NzAKL2tlcm5lbC94ODZfNjQtcmFuZGNvbmZpZy1zMS0wOTI0MDM1MS9kZGM1MDU3
YjA3ZWY3MTI2NDMxZDVkZjVmNWIxNzYxNTQ4OTZmNTYwL2RtZXNnLXlvY3RvLWxrcC1uZXgw
NC0yMDoyMDE0MDkyNjE4MjQxNjp4ODZfNjQtcmFuZGNvbmZpZy1zMS0wOTI0MDM1MTo6Ci9r
ZXJuZWwveDg2XzY0LXJhbmRjb25maWctczEtMDkyNDAzNTEvZGRjNTA1N2IwN2VmNzEyNjQz
MWQ1ZGY1ZjViMTc2MTU0ODk2ZjU2MC9kbWVzZy15b2N0by1rYnVpbGQtMTE6MjAxNDA5MjQw
NDEyMTY6eDg2XzY0LXJhbmRjb25maWctczEtMDkyNDAzNTE6My4xNy4wLXJjNi13bC0wNDQ3
OC1nZGRjNTA1N2I6NTcwCi9rZXJuZWwveDg2XzY0LXJhbmRjb25maWctczEtMDkyNDAzNTEv
ZGRjNTA1N2IwN2VmNzEyNjQzMWQ1ZGY1ZjViMTc2MTU0ODk2ZjU2MC9kbWVzZy15b2N0by1r
YnVpbGQtOToyMDE0MDkyNDA0Mjc0NDp4ODZfNjQtcmFuZGNvbmZpZy1zMS0wOTI0MDM1MToz
LjE3LjAtcmM2LXdsLTA0NDc4LWdkZGM1MDU3Yjo1NzAKL2tlcm5lbC94ODZfNjQtcmFuZGNv
bmZpZy1zMS0wOTI0MDM1MS9kZGM1MDU3YjA3ZWY3MTI2NDMxZDVkZjVmNWIxNzYxNTQ4OTZm
NTYwL2RtZXNnLXlvY3RvLWtidWlsZC0zMDoyMDE0MDkyNDA0NDAxODp4ODZfNjQtcmFuZGNv
bmZpZy1zMS0wOTI0MDM1MTozLjE3LjAtcmM2LXdsLTA0NDc4LWdkZGM1MDU3Yjo1NzAKL2tl
cm5lbC94ODZfNjQtcmFuZGNvbmZpZy1zMS0wOTI0MDM1MS9kZGM1MDU3YjA3ZWY3MTI2NDMx
ZDVkZjVmNWIxNzYxNTQ4OTZmNTYwL2RtZXNnLXlvY3RvLWtidWlsZC0xMjoyMDE0MDkyNDA0
MjAxNzp4ODZfNjQtcmFuZGNvbmZpZy1zMS0wOTI0MDM1MTozLjE3LjAtcmM2LXdsLTA0NDc4
LWdkZGM1MDU3Yjo1NzAKL2tlcm5lbC94ODZfNjQtcmFuZGNvbmZpZy1zMS0wOTI0MDM1MS9k
ZGM1MDU3YjA3ZWY3MTI2NDMxZDVkZjVmNWIxNzYxNTQ4OTZmNTYwL2RtZXNnLXlvY3RvLWti
dWlsZC0yNDoyMDE0MDkyNDA0MTUyMDp4ODZfNjQtcmFuZGNvbmZpZy1zMS0wOTI0MDM1MToz
LjE3LjAtcmM2LXdsLTA0NDc4LWdkZGM1MDU3Yjo1NzAKL2tlcm5lbC94ODZfNjQtcmFuZGNv
bmZpZy1zMS0wOTI0MDM1MS9kZGM1MDU3YjA3ZWY3MTI2NDMxZDVkZjVmNWIxNzYxNTQ4OTZm
NTYwL2RtZXNnLXlvY3RvLWtidWlsZC0xODoyMDE0MDkyNDA0MTk0MTp4ODZfNjQtcmFuZGNv
bmZpZy1zMS0wOTI0MDM1MTozLjE3LjAtcmM2LXdsLTA0NDc4LWdkZGM1MDU3Yjo1NzAKL2tl
cm5lbC94ODZfNjQtcmFuZGNvbmZpZy1zMS0wOTI0MDM1MS9kZGM1MDU3YjA3ZWY3MTI2NDMx
ZDVkZjVmNWIxNzYxNTQ4OTZmNTYwL2RtZXNnLXlvY3RvLWtidWlsZC0zOjIwMTQwOTI0MDQz
ODIzOng4Nl82NC1yYW5kY29uZmlnLXMxLTA5MjQwMzUxOjMuMTcuMC1yYzYtd2wtMDQ0Nzgt
Z2RkYzUwNTdiOjU3MAova2VybmVsL3g4Nl82NC1yYW5kY29uZmlnLXMxLTA5MjQwMzUxL2Rk
YzUwNTdiMDdlZjcxMjY0MzFkNWRmNWY1YjE3NjE1NDg5NmY1NjAvZG1lc2cteW9jdG8ta2J1
aWxkLTEyOjIwMTQwOTI0MDQwMDA0Ong4Nl82NC1yYW5kY29uZmlnLXMxLTA5MjQwMzUxOjMu
MTcuMC1yYzYtd2wtMDQ0NzgtZ2RkYzUwNTdiOjU3MAova2VybmVsL3g4Nl82NC1yYW5kY29u
ZmlnLXMxLTA5MjQwMzUxL2RkYzUwNTdiMDdlZjcxMjY0MzFkNWRmNWY1YjE3NjE1NDg5NmY1
NjAvZG1lc2cteW9jdG8ta2J1aWxkLTI6MjAxNDA5MjQwNDI3NDY6eDg2XzY0LXJhbmRjb25m
aWctczEtMDkyNDAzNTE6My4xNy4wLXJjNi13bC0wNDQ3OC1nZGRjNTA1N2I6NTcwCi9rZXJu
ZWwveDg2XzY0LXJhbmRjb25maWctczEtMDkyNDAzNTEvZGRjNTA1N2IwN2VmNzEyNjQzMWQ1
ZGY1ZjViMTc2MTU0ODk2ZjU2MC9kbWVzZy15b2N0by1rYnVpbGQtMzE6MjAxNDA5MjQwNDM5
MjA6eDg2XzY0LXJhbmRjb25maWctczEtMDkyNDAzNTE6My4xNy4wLXJjNi13bC0wNDQ3OC1n
ZGRjNTA1N2I6NTcwCi9rZXJuZWwveDg2XzY0LXJhbmRjb25maWctczEtMDkyNDAzNTEvZGRj
NTA1N2IwN2VmNzEyNjQzMWQ1ZGY1ZjViMTc2MTU0ODk2ZjU2MC9kbWVzZy15b2N0by12cC02
OjIwMTQwOTI0MDQxMDUzOng4Nl82NC1yYW5kY29uZmlnLXMxLTA5MjQwMzUxOjMuMTcuMC1y
YzYtd2wtMDQ0NzgtZ2RkYzUwNTdiOjU3MAova2VybmVsL3g4Nl82NC1yYW5kY29uZmlnLXMx
LTA5MjQwMzUxL2RkYzUwNTdiMDdlZjcxMjY0MzFkNWRmNWY1YjE3NjE1NDg5NmY1NjAvZG1l
c2cteW9jdG8ta2J1aWxkLTI5OjIwMTQwOTI0MDQwOTI2Ong4Nl82NC1yYW5kY29uZmlnLXMx
LTA5MjQwMzUxOjMuMTcuMC1yYzYtd2wtMDQ0NzgtZ2RkYzUwNTdiOjU3MAova2VybmVsL3g4
Nl82NC1yYW5kY29uZmlnLXMxLTA5MjQwMzUxL2RkYzUwNTdiMDdlZjcxMjY0MzFkNWRmNWY1
YjE3NjE1NDg5NmY1NjAvZG1lc2cteW9jdG8ta2J1aWxkLTEzOjIwMTQwOTI0MDQyODQ2Ong4
Nl82NC1yYW5kY29uZmlnLXMxLTA5MjQwMzUxOjMuMTcuMC1yYzYtd2wtMDQ0NzgtZ2RkYzUw
NTdiOjU3MAova2VybmVsL3g4Nl82NC1yYW5kY29uZmlnLXMxLTA5MjQwMzUxL2RkYzUwNTdi
MDdlZjcxMjY0MzFkNWRmNWY1YjE3NjE1NDg5NmY1NjAvZG1lc2cteW9jdG8ta2J1aWxkLTM6
MjAxNDA5MjQwNDA3NDI6eDg2XzY0LXJhbmRjb25maWctczEtMDkyNDAzNTE6My4xNy4wLXJj
Ni13bC0wNDQ3OC1nZGRjNTA1N2I6NTcwCi9rZXJuZWwveDg2XzY0LXJhbmRjb25maWctczEt
MDkyNDAzNTEvZGRjNTA1N2IwN2VmNzEyNjQzMWQ1ZGY1ZjViMTc2MTU0ODk2ZjU2MC9kbWVz
Zy15b2N0by1rYnVpbGQtMjc6MjAxNDA5MjQwNDEyNDQ6eDg2XzY0LXJhbmRjb25maWctczEt
MDkyNDAzNTE6My4xNy4wLXJjNi13bC0wNDQ3OC1nZGRjNTA1N2I6NTcwCi9rZXJuZWwveDg2
XzY0LXJhbmRjb25maWctczEtMDkyNDAzNTEvZGRjNTA1N2IwN2VmNzEyNjQzMWQ1ZGY1ZjVi
MTc2MTU0ODk2ZjU2MC9kbWVzZy15b2N0by1rYnVpbGQtMTM6MjAxNDA5MjQwNDEzMTk6eDg2
XzY0LXJhbmRjb25maWctczEtMDkyNDAzNTE6My4xNy4wLXJjNi13bC0wNDQ3OC1nZGRjNTA1
N2I6NTcwCi9rZXJuZWwveDg2XzY0LXJhbmRjb25maWctczEtMDkyNDAzNTEvZGRjNTA1N2Iw
N2VmNzEyNjQzMWQ1ZGY1ZjViMTc2MTU0ODk2ZjU2MC9kbWVzZy15b2N0by12cC00OToyMDE0
MDkyNDA0MDUxNjp4ODZfNjQtcmFuZGNvbmZpZy1zMS0wOTI0MDM1MTozLjE3LjAtcmM2LXds
LTA0NDc4LWdkZGM1MDU3Yjo1NzAKL2tlcm5lbC94ODZfNjQtcmFuZGNvbmZpZy1zMS0wOTI0
MDM1MS9kZGM1MDU3YjA3ZWY3MTI2NDMxZDVkZjVmNWIxNzYxNTQ4OTZmNTYwL2RtZXNnLXlv
Y3RvLWtidWlsZC0yOToyMDE0MDkyNDA0MzU0Mzp4ODZfNjQtcmFuZGNvbmZpZy1zMS0wOTI0
MDM1MTozLjE3LjAtcmM2LXdsLTA0NDc4LWdkZGM1MDU3Yjo1NzAKL2tlcm5lbC94ODZfNjQt
cmFuZGNvbmZpZy1zMS0wOTI0MDM1MS9kZGM1MDU3YjA3ZWY3MTI2NDMxZDVkZjVmNWIxNzYx
NTQ4OTZmNTYwL2RtZXNnLXlvY3RvLWtidWlsZC0yMToyMDE0MDkyNDA0MzgyMDp4ODZfNjQt
cmFuZGNvbmZpZy1zMS0wOTI0MDM1MTozLjE3LjAtcmM2LXdsLTA0NDc4LWdkZGM1MDU3Yjo1
NzAKL2tlcm5lbC94ODZfNjQtcmFuZGNvbmZpZy1zMS0wOTI0MDM1MS9kZGM1MDU3YjA3ZWY3
MTI2NDMxZDVkZjVmNWIxNzYxNTQ4OTZmNTYwL2RtZXNnLXlvY3RvLXZwLTE1OjIwMTQwOTI0
MDQxMDU0Ong4Nl82NC1yYW5kY29uZmlnLXMxLTA5MjQwMzUxOjMuMTcuMC1yYzYtd2wtMDQ0
NzgtZ2RkYzUwNTdiOjU3MAova2VybmVsL3g4Nl82NC1yYW5kY29uZmlnLXMxLTA5MjQwMzUx
L2RkYzUwNTdiMDdlZjcxMjY0MzFkNWRmNWY1YjE3NjE1NDg5NmY1NjAvZG1lc2cteW9jdG8t
a2J1aWxkLTExOjIwMTQwOTI0MDQzOTIwOng4Nl82NC1yYW5kY29uZmlnLXMxLTA5MjQwMzUx
OjMuMTcuMC1yYzYtd2wtMDQ0NzgtZ2RkYzUwNTdiOjU3MAova2VybmVsL3g4Nl82NC1yYW5k
Y29uZmlnLXMxLTA5MjQwMzUxL2RkYzUwNTdiMDdlZjcxMjY0MzFkNWRmNWY1YjE3NjE1NDg5
NmY1NjAvZG1lc2cteW9jdG8ta2J1aWxkLTEzOjIwMTQwOTI0MDQyMjE4Ong4Nl82NC1yYW5k
Y29uZmlnLXMxLTA5MjQwMzUxOjMuMTcuMC1yYzYtd2wtMDQ0NzgtZ2RkYzUwNTdiOjU3MAov
a2VybmVsL3g4Nl82NC1yYW5kY29uZmlnLXMxLTA5MjQwMzUxL2RkYzUwNTdiMDdlZjcxMjY0
MzFkNWRmNWY1YjE3NjE1NDg5NmY1NjAvZG1lc2cteW9jdG8ta2J1aWxkLTIyOjIwMTQwOTI0
MDQzMTU4Ong4Nl82NC1yYW5kY29uZmlnLXMxLTA5MjQwMzUxOjMuMTcuMC1yYzYtd2wtMDQ0
NzgtZ2RkYzUwNTdiOjU3MAova2VybmVsL3g4Nl82NC1yYW5kY29uZmlnLXMxLTA5MjQwMzUx
L2RkYzUwNTdiMDdlZjcxMjY0MzFkNWRmNWY1YjE3NjE1NDg5NmY1NjAvZG1lc2cteW9jdG8t
a2J1aWxkLTY6MjAxNDA5MjQwNDI5NTI6eDg2XzY0LXJhbmRjb25maWctczEtMDkyNDAzNTE6
My4xNy4wLXJjNi13bC0wNDQ3OC1nZGRjNTA1N2I6NTcwCi9rZXJuZWwveDg2XzY0LXJhbmRj
b25maWctczEtMDkyNDAzNTEvZGRjNTA1N2IwN2VmNzEyNjQzMWQ1ZGY1ZjViMTc2MTU0ODk2
ZjU2MC9kbWVzZy15b2N0by1rYnVpbGQtMTM6MjAxNDA5MjQwNDI0Mjk6eDg2XzY0LXJhbmRj
b25maWctczEtMDkyNDAzNTE6My4xNy4wLXJjNi13bC0wNDQ3OC1nZGRjNTA1N2I6NTcwCi9r
ZXJuZWwveDg2XzY0LXJhbmRjb25maWctczEtMDkyNDAzNTEvZGRjNTA1N2IwN2VmNzEyNjQz
MWQ1ZGY1ZjViMTc2MTU0ODk2ZjU2MC9kbWVzZy15b2N0by1rYnVpbGQtMToyMDE0MDkyNDA0
MjUwNjp4ODZfNjQtcmFuZGNvbmZpZy1zMS0wOTI0MDM1MTozLjE3LjAtcmM2LXdsLTA0NDc4
LWdkZGM1MDU3Yjo1NzAKL2tlcm5lbC94ODZfNjQtcmFuZGNvbmZpZy1zMS0wOTI0MDM1MS9k
ZGM1MDU3YjA3ZWY3MTI2NDMxZDVkZjVmNWIxNzYxNTQ4OTZmNTYwL2RtZXNnLXlvY3RvLXZw
LTI4OjIwMTQwOTI0MDQwNTE2Ong4Nl82NC1yYW5kY29uZmlnLXMxLTA5MjQwMzUxOjMuMTcu
MC1yYzYtd2wtMDQ0NzgtZ2RkYzUwNTdiOjU3MAova2VybmVsL3g4Nl82NC1yYW5kY29uZmln
LXMxLTA5MjQwMzUxL2RkYzUwNTdiMDdlZjcxMjY0MzFkNWRmNWY1YjE3NjE1NDg5NmY1NjAv
ZG1lc2cteW9jdG8ta2J1aWxkLTEyOjIwMTQwOTI0MDQzMjAwOng4Nl82NC1yYW5kY29uZmln
LXMxLTA5MjQwMzUxOjMuMTcuMC1yYzYtd2wtMDQ0NzgtZ2RkYzUwNTdiOjU3MAova2VybmVs
L3g4Nl82NC1yYW5kY29uZmlnLXMxLTA5MjQwMzUxL2RkYzUwNTdiMDdlZjcxMjY0MzFkNWRm
NWY1YjE3NjE1NDg5NmY1NjAvZG1lc2cteW9jdG8ta2J1aWxkLTI1OjIwMTQwOTI0MDQyNjA5
Ong4Nl82NC1yYW5kY29uZmlnLXMxLTA5MjQwMzUxOjMuMTcuMC1yYzYtd2wtMDQ0NzgtZ2Rk
YzUwNTdiOjU3MAova2VybmVsL3g4Nl82NC1yYW5kY29uZmlnLXMxLTA5MjQwMzUxL2RkYzUw
NTdiMDdlZjcxMjY0MzFkNWRmNWY1YjE3NjE1NDg5NmY1NjAvZG1lc2cteW9jdG8ta2J1aWxk
LTEwOjIwMTQwOTI0MDQzNjUwOng4Nl82NC1yYW5kY29uZmlnLXMxLTA5MjQwMzUxOjMuMTcu
MC1yYzYtd2wtMDQ0NzgtZ2RkYzUwNTdiOjU3MAova2VybmVsL3g4Nl82NC1yYW5kY29uZmln
LXMxLTA5MjQwMzUxL2RkYzUwNTdiMDdlZjcxMjY0MzFkNWRmNWY1YjE3NjE1NDg5NmY1NjAv
ZG1lc2cteW9jdG8ta2J1aWxkLTI3OjIwMTQwOTI0MDQyNjA5Ong4Nl82NC1yYW5kY29uZmln
LXMxLTA5MjQwMzUxOjMuMTcuMC1yYzYtd2wtMDQ0NzgtZ2RkYzUwNTdiOjU3MAova2VybmVs
L3g4Nl82NC1yYW5kY29uZmlnLXMxLTA5MjQwMzUxL2RkYzUwNTdiMDdlZjcxMjY0MzFkNWRm
NWY1YjE3NjE1NDg5NmY1NjAvZG1lc2cteW9jdG8ta2J1aWxkLTY6MjAxNDA5MjQwNDI0MzQ6
eDg2XzY0LXJhbmRjb25maWctczEtMDkyNDAzNTE6My4xNy4wLXJjNi13bC0wNDQ3OC1nZGRj
NTA1N2I6NTcwCi9rZXJuZWwveDg2XzY0LXJhbmRjb25maWctczEtMDkyNDAzNTEvZGRjNTA1
N2IwN2VmNzEyNjQzMWQ1ZGY1ZjViMTc2MTU0ODk2ZjU2MC9kbWVzZy15b2N0by1sa3AtbmV4
MDQtMTg0OjIwMTQwOTI2MTgyNDE1Ong4Nl82NC1yYW5kY29uZmlnLXMxLTA5MjQwMzUxOjoK
L2tlcm5lbC94ODZfNjQtcmFuZGNvbmZpZy1zMS0wOTI0MDM1MS9kZGM1MDU3YjA3ZWY3MTI2
NDMxZDVkZjVmNWIxNzYxNTQ4OTZmNTYwL2RtZXNnLXlvY3RvLXZwLTE4OjIwMTQwOTI0MDQx
MjA0Ong4Nl82NC1yYW5kY29uZmlnLXMxLTA5MjQwMzUxOjMuMTcuMC1yYzYtd2wtMDQ0Nzgt
Z2RkYzUwNTdiOjU3MAova2VybmVsL3g4Nl82NC1yYW5kY29uZmlnLXMxLTA5MjQwMzUxL2Rk
YzUwNTdiMDdlZjcxMjY0MzFkNWRmNWY1YjE3NjE1NDg5NmY1NjAvZG1lc2cteW9jdG8ta2J1
aWxkLTEzOjIwMTQwOTI0MDQxNjU1Ong4Nl82NC1yYW5kY29uZmlnLXMxLTA5MjQwMzUxOjMu
MTcuMC1yYzYtd2wtMDQ0NzgtZ2RkYzUwNTdiOjU3MAova2VybmVsL3g4Nl82NC1yYW5kY29u
ZmlnLXMxLTA5MjQwMzUxL2RkYzUwNTdiMDdlZjcxMjY0MzFkNWRmNWY1YjE3NjE1NDg5NmY1
NjAvZG1lc2cteW9jdG8ta2J1aWxkLTExOjIwMTQwOTI0MDQxMzIxOng4Nl82NC1yYW5kY29u
ZmlnLXMxLTA5MjQwMzUxOjMuMTcuMC1yYzYtd2wtMDQ0NzgtZ2RkYzUwNTdiOjU3MAova2Vy
bmVsL3g4Nl82NC1yYW5kY29uZmlnLXMxLTA5MjQwMzUxL2RkYzUwNTdiMDdlZjcxMjY0MzFk
NWRmNWY1YjE3NjE1NDg5NmY1NjAvZG1lc2cteW9jdG8ta2J1aWxkLTE0OjIwMTQwOTI0MDQz
NDQzOng4Nl82NC1yYW5kY29uZmlnLXMxLTA5MjQwMzUxOjMuMTcuMC1yYzYtd2wtMDQ0Nzgt
Z2RkYzUwNTdiOjU3MAova2VybmVsL3g4Nl82NC1yYW5kY29uZmlnLXMxLTA5MjQwMzUxL2Rk
YzUwNTdiMDdlZjcxMjY0MzFkNWRmNWY1YjE3NjE1NDg5NmY1NjAvZG1lc2cteW9jdG8ta2J1
aWxkLTg6MjAxNDA5MjQwNDI4MTI6eDg2XzY0LXJhbmRjb25maWctczEtMDkyNDAzNTE6My4x
Ny4wLXJjNi13bC0wNDQ3OC1nZGRjNTA1N2I6NTcwCi9rZXJuZWwveDg2XzY0LXJhbmRjb25m
aWctczEtMDkyNDAzNTEvZGRjNTA1N2IwN2VmNzEyNjQzMWQ1ZGY1ZjViMTc2MTU0ODk2ZjU2
MC9kbWVzZy15b2N0by1rYnVpbGQtMTE6MjAxNDA5MjQwNDE1MTU6eDg2XzY0LXJhbmRjb25m
aWctczEtMDkyNDAzNTE6My4xNy4wLXJjNi13bC0wNDQ3OC1nZGRjNTA1N2I6NTcwCi9rZXJu
ZWwveDg2XzY0LXJhbmRjb25maWctczEtMDkyNDAzNTEvZGRjNTA1N2IwN2VmNzEyNjQzMWQ1
ZGY1ZjViMTc2MTU0ODk2ZjU2MC9kbWVzZy15b2N0by12cC04OjIwMTQwOTI0MDQxMjAyOng4
Nl82NC1yYW5kY29uZmlnLXMxLTA5MjQwMzUxOjMuMTcuMC1yYzYtd2wtMDQ0NzgtZ2RkYzUw
NTdiOjU3MAova2VybmVsL3g4Nl82NC1yYW5kY29uZmlnLXMxLTA5MjQwMzUxL2RkYzUwNTdi
MDdlZjcxMjY0MzFkNWRmNWY1YjE3NjE1NDg5NmY1NjAvZG1lc2cteW9jdG8ta2J1aWxkLTI3
OjIwMTQwOTI0MDQxMzE5Ong4Nl82NC1yYW5kY29uZmlnLXMxLTA5MjQwMzUxOjMuMTcuMC1y
YzYtd2wtMDQ0NzgtZ2RkYzUwNTdiOjU3MAova2VybmVsL3g4Nl82NC1yYW5kY29uZmlnLXMx
LTA5MjQwMzUxL2RkYzUwNTdiMDdlZjcxMjY0MzFkNWRmNWY1YjE3NjE1NDg5NmY1NjAvZG1l
c2cteW9jdG8tdnAtMjM6MjAxNDA5MjQwNDE0NTk6eDg2XzY0LXJhbmRjb25maWctczEtMDky
NDAzNTE6My4xNy4wLXJjNi13bC0wNDQ3OC1nZGRjNTA1N2I6NTcwCi9rZXJuZWwveDg2XzY0
LXJhbmRjb25maWctczEtMDkyNDAzNTEvZGRjNTA1N2IwN2VmNzEyNjQzMWQ1ZGY1ZjViMTc2
MTU0ODk2ZjU2MC9kbWVzZy15b2N0by1rYnVpbGQtODoyMDE0MDkyNDA0NDAxNjp4ODZfNjQt
cmFuZGNvbmZpZy1zMS0wOTI0MDM1MTozLjE3LjAtcmM2LXdsLTA0NDc4LWdkZGM1MDU3Yjo1
NzAKL2tlcm5lbC94ODZfNjQtcmFuZGNvbmZpZy1zMS0wOTI0MDM1MS9kZGM1MDU3YjA3ZWY3
MTI2NDMxZDVkZjVmNWIxNzYxNTQ4OTZmNTYwL2RtZXNnLXlvY3RvLWtidWlsZC0xNToyMDE0
MDkyNDA0MTAzMDp4ODZfNjQtcmFuZGNvbmZpZy1zMS0wOTI0MDM1MTozLjE3LjAtcmM2LXds
LTA0NDc4LWdkZGM1MDU3Yjo1NzAKL2tlcm5lbC94ODZfNjQtcmFuZGNvbmZpZy1zMS0wOTI0
MDM1MS9kZGM1MDU3YjA3ZWY3MTI2NDMxZDVkZjVmNWIxNzYxNTQ4OTZmNTYwL2RtZXNnLXlv
Y3RvLWtidWlsZC05OjIwMTQwOTI0MDQyOTE5Ong4Nl82NC1yYW5kY29uZmlnLXMxLTA5MjQw
MzUxOjMuMTcuMC1yYzYtd2wtMDQ0NzgtZ2RkYzUwNTdiOjU3MAova2VybmVsL3g4Nl82NC1y
YW5kY29uZmlnLXMxLTA5MjQwMzUxL2RkYzUwNTdiMDdlZjcxMjY0MzFkNWRmNWY1YjE3NjE1
NDg5NmY1NjAvZG1lc2cteW9jdG8ta2J1aWxkLTk6MjAxNDA5MjQwNDE1MTU6eDg2XzY0LXJh
bmRjb25maWctczEtMDkyNDAzNTE6My4xNy4wLXJjNi13bC0wNDQ3OC1nZGRjNTA1N2I6NTcw
Ci9rZXJuZWwveDg2XzY0LXJhbmRjb25maWctczEtMDkyNDAzNTEvZGRjNTA1N2IwN2VmNzEy
NjQzMWQ1ZGY1ZjViMTc2MTU0ODk2ZjU2MC9kbWVzZy15b2N0by1rYnVpbGQtMTM6MjAxNDA5
MjQwNDE5MzY6eDg2XzY0LXJhbmRjb25maWctczEtMDkyNDAzNTE6My4xNy4wLXJjNi13bC0w
NDQ3OC1nZGRjNTA1N2I6NTcwCi9rZXJuZWwveDg2XzY0LXJhbmRjb25maWctczEtMDkyNDAz
NTEvZGRjNTA1N2IwN2VmNzEyNjQzMWQ1ZGY1ZjViMTc2MTU0ODk2ZjU2MC9kbWVzZy15b2N0
by1rYnVpbGQtOToyMDE0MDkyNDA0MDExNDp4ODZfNjQtcmFuZGNvbmZpZy1zMS0wOTI0MDM1
MTozLjE3LjAtcmM2LXdsLTA0NDc4LWdkZGM1MDU3Yjo1NzAKL2tlcm5lbC94ODZfNjQtcmFu
ZGNvbmZpZy1zMS0wOTI0MDM1MS9kZGM1MDU3YjA3ZWY3MTI2NDMxZDVkZjVmNWIxNzYxNTQ4
OTZmNTYwL2RtZXNnLXlvY3RvLWtidWlsZC0xMToyMDE0MDkyNDA0MzA1Mzp4ODZfNjQtcmFu
ZGNvbmZpZy1zMS0wOTI0MDM1MTozLjE3LjAtcmM2LXdsLTA0NDc4LWdkZGM1MDU3Yjo1NzAK
L2tlcm5lbC94ODZfNjQtcmFuZGNvbmZpZy1zMS0wOTI0MDM1MS9kZGM1MDU3YjA3ZWY3MTI2
NDMxZDVkZjVmNWIxNzYxNTQ4OTZmNTYwL2RtZXNnLXlvY3RvLXZwLTI0OjIwMTQwOTI0MDQw
MTI0Ong4Nl82NC1yYW5kY29uZmlnLXMxLTA5MjQwMzUxOjMuMTcuMC1yYzYtd2wtMDQ0Nzgt
Z2RkYzUwNTdiOjU3MAova2VybmVsL3g4Nl82NC1yYW5kY29uZmlnLXMxLTA5MjQwMzUxL2Rk
YzUwNTdiMDdlZjcxMjY0MzFkNWRmNWY1YjE3NjE1NDg5NmY1NjAvZG1lc2cteW9jdG8ta2J1
aWxkLTE3OjIwMTQwOTI0MDQyOTE5Ong4Nl82NC1yYW5kY29uZmlnLXMxLTA5MjQwMzUxOjMu
MTcuMC1yYzYtd2wtMDQ0NzgtZ2RkYzUwNTdiOjU3MAova2VybmVsL3g4Nl82NC1yYW5kY29u
ZmlnLXMxLTA5MjQwMzUxL2RkYzUwNTdiMDdlZjcxMjY0MzFkNWRmNWY1YjE3NjE1NDg5NmY1
NjAvZG1lc2cteW9jdG8ta2J1aWxkLTg6MjAxNDA5MjQwNDEwMjk6eDg2XzY0LXJhbmRjb25m
aWctczEtMDkyNDAzNTE6My4xNy4wLXJjNi13bC0wNDQ3OC1nZGRjNTA1N2I6NTcwCi9rZXJu
ZWwveDg2XzY0LXJhbmRjb25maWctczEtMDkyNDAzNTEvZGRjNTA1N2IwN2VmNzEyNjQzMWQ1
ZGY1ZjViMTc2MTU0ODk2ZjU2MC9kbWVzZy15b2N0by1rYnVpbGQtMjE6MjAxNDA5MjQwNDEz
MjU6eDg2XzY0LXJhbmRjb25maWctczEtMDkyNDAzNTE6My4xNy4wLXJjNi13bC0wNDQ3OC1n
ZGRjNTA1N2I6NTcwCi9rZXJuZWwveDg2XzY0LXJhbmRjb25maWctczEtMDkyNDAzNTEvZGRj
NTA1N2IwN2VmNzEyNjQzMWQ1ZGY1ZjViMTc2MTU0ODk2ZjU2MC9kbWVzZy15b2N0by1rYnVp
bGQtMTE6MjAxNDA5MjQwNDA3NDM6eDg2XzY0LXJhbmRjb25maWctczEtMDkyNDAzNTE6My4x
Ny4wLXJjNi13bC0wNDQ3OC1nZGRjNTA1N2I6NTcwCi9rZXJuZWwveDg2XzY0LXJhbmRjb25m
aWctczEtMDkyNDAzNTEvZGRjNTA1N2IwN2VmNzEyNjQzMWQ1ZGY1ZjViMTc2MTU0ODk2ZjU2
MC9kbWVzZy15b2N0by12cC0yNDoyMDE0MDkyNDA0MDI0Mjp4ODZfNjQtcmFuZGNvbmZpZy1z
MS0wOTI0MDM1MTozLjE3LjAtcmM2LXdsLTA0NDc4LWdkZGM1MDU3Yjo1NzAKL2tlcm5lbC94
ODZfNjQtcmFuZGNvbmZpZy1zMS0wOTI0MDM1MS9kZGM1MDU3YjA3ZWY3MTI2NDMxZDVkZjVm
NWIxNzYxNTQ4OTZmNTYwL2RtZXNnLXlvY3RvLWtidWlsZC0zMjoyMDE0MDkyNDA0MjYxMTp4
ODZfNjQtcmFuZGNvbmZpZy1zMS0wOTI0MDM1MTozLjE3LjAtcmM2LXdsLTA0NDc4LWdkZGM1
MDU3Yjo1NzAKL2tlcm5lbC94ODZfNjQtcmFuZGNvbmZpZy1zMS0wOTI0MDM1MS9kZGM1MDU3
YjA3ZWY3MTI2NDMxZDVkZjVmNWIxNzYxNTQ4OTZmNTYwL2RtZXNnLXlvY3RvLWtidWlsZC0x
NzoyMDE0MDkyNDA0MjYxMDp4ODZfNjQtcmFuZGNvbmZpZy1zMS0wOTI0MDM1MTozLjE3LjAt
cmM2LXdsLTA0NDc4LWdkZGM1MDU3Yjo1NzAKL2tlcm5lbC94ODZfNjQtcmFuZGNvbmZpZy1z
MS0wOTI0MDM1MS9kZGM1MDU3YjA3ZWY3MTI2NDMxZDVkZjVmNWIxNzYxNTQ4OTZmNTYwL2Rt
ZXNnLXlvY3RvLXZwLTUzOjIwMTQwOTI0MDQwMjQyOng4Nl82NC1yYW5kY29uZmlnLXMxLTA5
MjQwMzUxOjMuMTcuMC1yYzYtd2wtMDQ0NzgtZ2RkYzUwNTdiOjU3MAova2VybmVsL3g4Nl82
NC1yYW5kY29uZmlnLXMxLTA5MjQwMzUxL2RkYzUwNTdiMDdlZjcxMjY0MzFkNWRmNWY1YjE3
NjE1NDg5NmY1NjAvZG1lc2cteW9jdG8ta2J1aWxkLTMwOjIwMTQwOTI0MDQxNTIxOng4Nl82
NC1yYW5kY29uZmlnLXMxLTA5MjQwMzUxOjMuMTcuMC1yYzYtd2wtMDQ0NzgtZ2RkYzUwNTdi
OjU3MAova2VybmVsL3g4Nl82NC1yYW5kY29uZmlnLXMxLTA5MjQwMzUxL2RkYzUwNTdiMDdl
ZjcxMjY0MzFkNWRmNWY1YjE3NjE1NDg5NmY1NjAvZG1lc2cteW9jdG8ta2J1aWxkLTQ6MjAx
NDA5MjQwNDI4NDc6eDg2XzY0LXJhbmRjb25maWctczEtMDkyNDAzNTE6My4xNy4wLXJjNi13
bC0wNDQ3OC1nZGRjNTA1N2I6NTcwCi9rZXJuZWwveDg2XzY0LXJhbmRjb25maWctczEtMDky
NDAzNTEvZGRjNTA1N2IwN2VmNzEyNjQzMWQ1ZGY1ZjViMTc2MTU0ODk2ZjU2MC9kbWVzZy15
b2N0by1rYnVpbGQtMzI6MjAxNDA5MjQwNDMxNTk6eDg2XzY0LXJhbmRjb25maWctczEtMDky
NDAzNTE6My4xNy4wLXJjNi13bC0wNDQ3OC1nZGRjNTA1N2I6NTcwCi9rZXJuZWwveDg2XzY0
LXJhbmRjb25maWctczEtMDkyNDAzNTEvZGRjNTA1N2IwN2VmNzEyNjQzMWQ1ZGY1ZjViMTc2
MTU0ODk2ZjU2MC9kbWVzZy15b2N0by1rYnVpbGQtMjoyMDE0MDkyNDA0MzYxODp4ODZfNjQt
cmFuZGNvbmZpZy1zMS0wOTI0MDM1MTozLjE3LjAtcmM2LXdsLTA0NDc4LWdkZGM1MDU3Yjo1
NzAKL2tlcm5lbC94ODZfNjQtcmFuZGNvbmZpZy1zMS0wOTI0MDM1MS9kZGM1MDU3YjA3ZWY3
MTI2NDMxZDVkZjVmNWIxNzYxNTQ4OTZmNTYwL2RtZXNnLXlvY3RvLWtidWlsZC0xNjoyMDE0
MDkyNDA0MTY1NTp4ODZfNjQtcmFuZGNvbmZpZy1zMS0wOTI0MDM1MTozLjE3LjAtcmM2LXds
LTA0NDc4LWdkZGM1MDU3Yjo1NzAKL2tlcm5lbC94ODZfNjQtcmFuZGNvbmZpZy1zMS0wOTI0
MDM1MS9kZGM1MDU3YjA3ZWY3MTI2NDMxZDVkZjVmNWIxNzYxNTQ4OTZmNTYwL2RtZXNnLXlv
Y3RvLWtidWlsZC0yMToyMDE0MDkyNDA0MTI0Njp4ODZfNjQtcmFuZGNvbmZpZy1zMS0wOTI0
MDM1MTozLjE3LjAtcmM2LXdsLTA0NDc4LWdkZGM1MDU3Yjo1NzAKL2tlcm5lbC94ODZfNjQt
cmFuZGNvbmZpZy1zMS0wOTI0MDM1MS9kZGM1MDU3YjA3ZWY3MTI2NDMxZDVkZjVmNWIxNzYx
NTQ4OTZmNTYwL2RtZXNnLXlvY3RvLWtidWlsZC0xOjIwMTQwOTI0MDQzNzIwOng4Nl82NC1y
YW5kY29uZmlnLXMxLTA5MjQwMzUxOjMuMTcuMC1yYzYtd2wtMDQ0NzgtZ2RkYzUwNTdiOjU3
MAova2VybmVsL3g4Nl82NC1yYW5kY29uZmlnLXMxLTA5MjQwMzUxL2RkYzUwNTdiMDdlZjcx
MjY0MzFkNWRmNWY1YjE3NjE1NDg5NmY1NjAvZG1lc2cteW9jdG8ta2J1aWxkLTMwOjIwMTQw
OTI0MDQwODE1Ong4Nl82NC1yYW5kY29uZmlnLXMxLTA5MjQwMzUxOjMuMTcuMC1yYzYtd2wt
MDQ0NzgtZ2RkYzUwNTdiOjU3MAova2VybmVsL3g4Nl82NC1yYW5kY29uZmlnLXMxLTA5MjQw
MzUxL2RkYzUwNTdiMDdlZjcxMjY0MzFkNWRmNWY1YjE3NjE1NDg5NmY1NjAvZG1lc2cteW9j
dG8ta2J1aWxkLTEzOjIwMTQwOTI0MDQzMzA2Ong4Nl82NC1yYW5kY29uZmlnLXMxLTA5MjQw
MzUxOjMuMTcuMC1yYzYtd2wtMDQ0NzgtZ2RkYzUwNTdiOjU3MAova2VybmVsL3g4Nl82NC1y
YW5kY29uZmlnLXMxLTA5MjQwMzUxL2RkYzUwNTdiMDdlZjcxMjY0MzFkNWRmNWY1YjE3NjE1
NDg5NmY1NjAvZG1lc2cteW9jdG8ta2J1aWxkLTI1OjIwMTQwOTI0MDQwMTE1Ong4Nl82NC1y
YW5kY29uZmlnLXMxLTA5MjQwMzUxOjMuMTcuMC1yYzYtd2wtMDQ0NzgtZ2RkYzUwNTdiOjU3
MAova2VybmVsL3g4Nl82NC1yYW5kY29uZmlnLXMxLTA5MjQwMzUxL2RkYzUwNTdiMDdlZjcx
MjY0MzFkNWRmNWY1YjE3NjE1NDg5NmY1NjAvZG1lc2cteW9jdG8ta2J1aWxkLTg6MjAxNDA5
MjQwNDI4NDY6eDg2XzY0LXJhbmRjb25maWctczEtMDkyNDAzNTE6My4xNy4wLXJjNi13bC0w
NDQ3OC1nZGRjNTA1N2I6NTcwCjQ3OjI2NDoyNjQgYWxsX2dvb2Q6YmFkOmFsbF9iYWQgYm9v
dHMKCkhFQUQgaXMgbm93IGF0IGRkYzUwNTdiIDBkYXkgaGVhZCBndWFyZCBmb3IgJ2RldmVs
LWhvdXJseS0yMDE0MDkyNDAyJwoKPT09PT09PT09IGxpbnVzL21hc3RlciA9PT09PT09PT0K
Tm90ZTogY2hlY2tpbmcgb3V0ICdsaW51cy9tYXN0ZXInLgoKWW91IGFyZSBpbiAnZGV0YWNo
ZWQgSEVBRCcgc3RhdGUuIFlvdSBjYW4gbG9vayBhcm91bmQsIG1ha2UgZXhwZXJpbWVudGFs
CmNoYW5nZXMgYW5kIGNvbW1pdCB0aGVtLCBhbmQgeW91IGNhbiBkaXNjYXJkIGFueSBjb21t
aXRzIHlvdSBtYWtlIGluIHRoaXMKc3RhdGUgd2l0aG91dCBpbXBhY3RpbmcgYW55IGJyYW5j
aGVzIGJ5IHBlcmZvcm1pbmcgYW5vdGhlciBjaGVja291dC4KCklmIHlvdSB3YW50IHRvIGNy
ZWF0ZSBhIG5ldyBicmFuY2ggdG8gcmV0YWluIGNvbW1pdHMgeW91IGNyZWF0ZSwgeW91IG1h
eQpkbyBzbyAobm93IG9yIGxhdGVyKSBieSB1c2luZyAtYiB3aXRoIHRoZSBjaGVja291dCBj
b21tYW5kIGFnYWluLiBFeGFtcGxlOgoKICBnaXQgY2hlY2tvdXQgLWIgbmV3X2JyYW5jaF9u
YW1lCgpIRUFEIGlzIG5vdyBhdCBmNGNiNzA3Li4uIE1lcmdlIHRhZyAncG0rYWNwaS0zLjE3
LXJjNycgb2YgZ2l0Oi8vZ2l0Lmtlcm5lbC5vcmcvcHViL3NjbS9saW51eC9rZXJuZWwvZ2l0
L3JhZmFlbC9saW51eC1wbQpscyAtYSAva2J1aWxkLXRlc3RzL3J1bi1xdWV1ZS9rdm0veDg2
XzY0LXJhbmRjb25maWctczEtMDkyNDAzNTEvbGludXM6bWFzdGVyOmY0Y2I3MDdlN2FkOTcy
N2EwNDZiNDYzMjMyZjJkZTE2NmUzMjdkM2U6YmlzZWN0LWxpbnV4LTYKCjIwMTQtMDktMjYg
MjI6MjU6MDMgZjRjYjcwN2U3YWQ5NzI3YTA0NmI0NjMyMzJmMmRlMTY2ZTMyN2QzZSBjb21w
aWxpbmcKUXVldWVkIGJ1aWxkIHRhc2sgdG8gL2tidWlsZC10ZXN0cy9idWlsZC1xdWV1ZS9z
bmIveDg2XzY0LXJhbmRjb25maWctczEtMDkyNDAzNTEtZjRjYjcwN2U3YWQ5NzI3YTA0NmI0
NjMyMzJmMmRlMTY2ZTMyN2QzZQpDaGVjayBmb3Iga2VybmVsIGluIC9rZXJuZWwveDg2XzY0
LXJhbmRjb25maWctczEtMDkyNDAzNTEvZjRjYjcwN2U3YWQ5NzI3YTA0NmI0NjMyMzJmMmRl
MTY2ZTMyN2QzZQp3YWl0aW5nIGZvciBjb21wbGV0aW9uIG9mIC9rYnVpbGQtdGVzdHMvYnVp
bGQtcXVldWUvc25iL3g4Nl82NC1yYW5kY29uZmlnLXMxLTA5MjQwMzUxLWY0Y2I3MDdlN2Fk
OTcyN2EwNDZiNDYzMjMyZjJkZTE2NmUzMjdkM2UKG1sxOzM1bTIwMTQtMDktMjYgMjI6Mjk6
MDMgTm8gYnVpbGQgc2VydmVkIGZpbGUgL2tidWlsZC10ZXN0cy9idWlsZC1zZXJ2ZWQveDg2
XzY0LXJhbmRjb25maWctczEtMDkyNDAzNTEtZjRjYjcwN2U3YWQ5NzI3YTA0NmI0NjMyMzJm
MmRlMTY2ZTMyN2QzZRtbMG0KUmV0cnkgYnVpbGQgLi4Kd2FpdGluZyBmb3IgY29tcGxldGlv
biBvZiAva2J1aWxkLXRlc3RzL2J1aWxkLXF1ZXVlL3NuYi1zbW9rZS94ODZfNjQtcmFuZGNv
bmZpZy1zMS0wOTI0MDM1MS1mNGNiNzA3ZTdhZDk3MjdhMDQ2YjQ2MzIzMmYyZGUxNjZlMzI3
ZDNlCmtlcm5lbDogL2tlcm5lbC94ODZfNjQtcmFuZGNvbmZpZy1zMS0wOTI0MDM1MS9mNGNi
NzA3ZTdhZDk3MjdhMDQ2YjQ2MzIzMmYyZGUxNjZlMzI3ZDNlL3ZtbGludXotMy4xNy4wLXJj
Ni0wMDI3OC1nZjRjYjcwNwoKMjAxNC0wOS0yNiAyMjozOTowMyBkZXRlY3RpbmcgYm9vdCBz
dGF0ZSAJMQkyCTE4CTI3CTI4CTMxCTM1CTQxLgk0Mi4JNDUuLgk0Ny4JNDguLgk1MS4JNTYu
Lgk2MAk2Mgk2NQk3NS4JODEJODMuCTg4Lgk5Mgk5My4JOTUuCTk2Li4JOTkuCTEwMC4JMTAx
CTEwNgkxMTEJMTE4CTEyMAkxMjYJMTQ0CTE1MgkxNTYgU1VDQ0VTUwoKCj09PT09PT09PSBu
ZXh0L21hc3RlciA9PT09PT09PT0KRnJvbSBnaXQ6Ly9naXRtaXJyb3IvbmV4dAogKyA0ODEw
MGNhLi4uNGYzN2FmMSBha3BtICAgICAgIC0+IG5leHQvYWtwbSAgKGZvcmNlZCB1cGRhdGUp
CiArIDJjZjUwNzYuLi5hMjVjMWQ4IGFrcG0tYmFzZSAgLT4gbmV4dC9ha3BtLWJhc2UgIChm
b3JjZWQgdXBkYXRlKQogKyA4ZGQyYzgxLi4uNGQ4NDI2ZiBtYXN0ZXIgICAgIC0+IG5leHQv
bWFzdGVyICAoZm9yY2VkIHVwZGF0ZSkKICAgMDA1ZjgwMC4uZjRjYjcwNyAgc3RhYmxlICAg
ICAtPiBuZXh0L3N0YWJsZQpGcm9tIGdpdDovL2dpdG1pcnJvci9uZXh0CiAqIFtuZXcgdGFn
XSAgICAgICAgIG5leHQtMjAxNDA5MjYgLT4gbmV4dC0yMDE0MDkyNgpQcmV2aW91cyBIRUFE
IHBvc2l0aW9uIHdhcyBmNGNiNzA3Li4uIE1lcmdlIHRhZyAncG0rYWNwaS0zLjE3LXJjNycg
b2YgZ2l0Oi8vZ2l0Lmtlcm5lbC5vcmcvcHViL3NjbS9saW51eC9rZXJuZWwvZ2l0L3JhZmFl
bC9saW51eC1wbQpIRUFEIGlzIG5vdyBhdCA0ZDg0MjZmLi4uIEFkZCBsaW51eC1uZXh0IHNw
ZWNpZmljIGZpbGVzIGZvciAyMDE0MDkyNgpscyAtYSAva2J1aWxkLXRlc3RzL3J1bi1xdWV1
ZS9rdm0veDg2XzY0LXJhbmRjb25maWctczEtMDkyNDAzNTEvbmV4dDptYXN0ZXI6NGQ4NDI2
ZjlhYzYwMWRiMmE2NGZhN2JlNjQwNTFkMDJiOWM5ZmUwMTpiaXNlY3QtbGludXgtNgoKMjAx
NC0wOS0yNiAyMzowNzo0NiA0ZDg0MjZmOWFjNjAxZGIyYTY0ZmE3YmU2NDA1MWQwMmI5Yzlm
ZTAxIGNvbXBpbGluZwpRdWV1ZWQgYnVpbGQgdGFzayB0byAva2J1aWxkLXRlc3RzL2J1aWxk
LXF1ZXVlL3NuYi94ODZfNjQtcmFuZGNvbmZpZy1zMS0wOTI0MDM1MS00ZDg0MjZmOWFjNjAx
ZGIyYTY0ZmE3YmU2NDA1MWQwMmI5YzlmZTAxCkNoZWNrIGZvciBrZXJuZWwgaW4gL2tlcm5l
bC94ODZfNjQtcmFuZGNvbmZpZy1zMS0wOTI0MDM1MS80ZDg0MjZmOWFjNjAxZGIyYTY0ZmE3
YmU2NDA1MWQwMmI5YzlmZTAxCndhaXRpbmcgZm9yIGNvbXBsZXRpb24gb2YgL2tidWlsZC10
ZXN0cy9idWlsZC1xdWV1ZS9zbmIveDg2XzY0LXJhbmRjb25maWctczEtMDkyNDAzNTEtNGQ4
NDI2ZjlhYzYwMWRiMmE2NGZhN2JlNjQwNTFkMDJiOWM5ZmUwMQobWzE7MzVtMjAxNC0wOS0y
NiAyMzoxNzo0NiBObyBidWlsZCBzZXJ2ZWQgZmlsZSAva2J1aWxkLXRlc3RzL2J1aWxkLXNl
cnZlZC94ODZfNjQtcmFuZGNvbmZpZy1zMS0wOTI0MDM1MS00ZDg0MjZmOWFjNjAxZGIyYTY0
ZmE3YmU2NDA1MWQwMmI5YzlmZTAxG1swbQpSZXRyeSBidWlsZCAuLgp3YWl0aW5nIGZvciBj
b21wbGV0aW9uIG9mIC9rYnVpbGQtdGVzdHMvYnVpbGQtcXVldWUvc25iLXNtb2tlL3g4Nl82
NC1yYW5kY29uZmlnLXMxLTA5MjQwMzUxLTRkODQyNmY5YWM2MDFkYjJhNjRmYTdiZTY0MDUx
ZDAyYjljOWZlMDEKa2VybmVsOiAva2VybmVsL3g4Nl82NC1yYW5kY29uZmlnLXMxLTA5MjQw
MzUxLzRkODQyNmY5YWM2MDFkYjJhNjRmYTdiZTY0MDUxZDAyYjljOWZlMDEvdm1saW51ei0z
LjE3LjAtcmM2LW5leHQtMjAxNDA5MjYKCjIwMTQtMDktMjYgMjM6MjA6NDYgZGV0ZWN0aW5n
IGJvb3Qgc3RhdGUgLi4JMTE2CTE1NiBTVUNDRVNTCgo=

--St7VIuEGZ6dlpu13
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="config-3.17.0-rc1-00169-gcaae204"

#
# Automatically generated file; DO NOT EDIT.
# Linux/x86_64 3.17.0-rc1 Kernel Configuration
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
CONFIG_ARCH_HWEIGHT_CFLAGS="-fcall-saved-rdi -fcall-saved-rsi -fcall-saved-rdx -fcall-saved-rcx -fcall-saved-r8 -fcall-saved-r9 -fcall-saved-r10 -fcall-saved-r11"
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
# CONFIG_KERNEL_GZIP is not set
# CONFIG_KERNEL_BZIP2 is not set
# CONFIG_KERNEL_LZMA is not set
# CONFIG_KERNEL_XZ is not set
# CONFIG_KERNEL_LZO is not set
CONFIG_KERNEL_LZ4=y
CONFIG_DEFAULT_HOSTNAME="(none)"
CONFIG_SYSVIPC=y
CONFIG_POSIX_MQUEUE=y
# CONFIG_CROSS_MEMORY_ATTACH is not set
# CONFIG_FHANDLE is not set
# CONFIG_USELIB is not set
CONFIG_AUDIT=y
CONFIG_HAVE_ARCH_AUDITSYSCALL=y
CONFIG_AUDITSYSCALL=y
CONFIG_AUDIT_WATCH=y
CONFIG_AUDIT_TREE=y

#
# IRQ subsystem
#
CONFIG_GENERIC_IRQ_PROBE=y
CONFIG_GENERIC_IRQ_SHOW=y
CONFIG_GENERIC_IRQ_LEGACY_ALLOC_HWIRQ=y
CONFIG_IRQ_DOMAIN=y
CONFIG_IRQ_DOMAIN_DEBUG=y
CONFIG_IRQ_FORCED_THREADING=y
CONFIG_SPARSE_IRQ=y
CONFIG_CLOCKSOURCE_WATCHDOG=y
CONFIG_ARCH_CLOCKSOURCE_DATA=y
CONFIG_CLOCKSOURCE_VALIDATE_LAST_CYCLE=y
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
CONFIG_TASKSTATS=y
CONFIG_TASK_DELAY_ACCT=y
# CONFIG_TASK_XACCT is not set

#
# RCU Subsystem
#
CONFIG_TINY_RCU=y
# CONFIG_PREEMPT_RCU is not set
CONFIG_RCU_STALL_COMMON=y
CONFIG_CONTEXT_TRACKING=y
# CONFIG_CONTEXT_TRACKING_FORCE is not set
# CONFIG_TREE_RCU_TRACE is not set
CONFIG_BUILD_BIN2C=y
CONFIG_IKCONFIG=y
# CONFIG_IKCONFIG_PROC is not set
CONFIG_LOG_BUF_SHIFT=17
CONFIG_LOG_CPU_MAX_BUF_SHIFT=12
CONFIG_HAVE_UNSTABLE_SCHED_CLOCK=y
CONFIG_ARCH_SUPPORTS_NUMA_BALANCING=y
CONFIG_ARCH_SUPPORTS_INT128=y
CONFIG_ARCH_WANTS_PROT_NUMA_PROT_NONE=y
# CONFIG_CGROUPS is not set
CONFIG_CHECKPOINT_RESTORE=y
# CONFIG_NAMESPACES is not set
# CONFIG_SCHED_AUTOGROUP is not set
# CONFIG_SYSFS_DEPRECATED is not set
# CONFIG_RELAY is not set
CONFIG_BLK_DEV_INITRD=y
CONFIG_INITRAMFS_SOURCE=""
CONFIG_RD_GZIP=y
CONFIG_RD_BZIP2=y
# CONFIG_RD_LZMA is not set
CONFIG_RD_XZ=y
CONFIG_RD_LZO=y
# CONFIG_RD_LZ4 is not set
CONFIG_CC_OPTIMIZE_FOR_SIZE=y
CONFIG_ANON_INODES=y
CONFIG_HAVE_UID16=y
CONFIG_SYSCTL_EXCEPTION_TRACE=y
CONFIG_HAVE_PCSPKR_PLATFORM=y
CONFIG_EXPERT=y
# CONFIG_UID16 is not set
CONFIG_SGETMASK_SYSCALL=y
CONFIG_SYSFS_SYSCALL=y
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
# CONFIG_EMBEDDED is not set
CONFIG_HAVE_PERF_EVENTS=y
CONFIG_PERF_USE_VMALLOC=y

#
# Kernel Performance Events And Counters
#
CONFIG_PERF_EVENTS=y
CONFIG_DEBUG_PERF_USE_VMALLOC=y
# CONFIG_VM_EVENT_COUNTERS is not set
CONFIG_COMPAT_BRK=y
# CONFIG_SLAB is not set
# CONFIG_SLUB is not set
CONFIG_SLOB=y
CONFIG_SYSTEM_TRUSTED_KEYRING=y
# CONFIG_PROFILING is not set
CONFIG_HAVE_OPROFILE=y
CONFIG_OPROFILE_NMI_TIMER=y
CONFIG_KPROBES=y
# CONFIG_JUMP_LABEL is not set
CONFIG_OPTPROBES=y
# CONFIG_UPROBES is not set
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
CONFIG_ARCH_WANT_COMPAT_IPC_PARSE_VERSION=y
CONFIG_ARCH_WANT_OLD_COMPAT_IPC=y
CONFIG_HAVE_ARCH_SECCOMP_FILTER=y
CONFIG_HAVE_CC_STACKPROTECTOR=y
# CONFIG_CC_STACKPROTECTOR is not set
CONFIG_CC_STACKPROTECTOR_NONE=y
# CONFIG_CC_STACKPROTECTOR_REGULAR is not set
# CONFIG_CC_STACKPROTECTOR_STRONG is not set
CONFIG_HAVE_CONTEXT_TRACKING=y
CONFIG_HAVE_VIRT_CPU_ACCOUNTING_GEN=y
CONFIG_HAVE_IRQ_TIME_ACCOUNTING=y
CONFIG_HAVE_ARCH_TRANSPARENT_HUGEPAGE=y
CONFIG_HAVE_ARCH_SOFT_DIRTY=y
CONFIG_MODULES_USE_ELF_RELA=y
CONFIG_HAVE_IRQ_EXIT_ON_IRQ_STACK=y
CONFIG_OLD_SIGSUSPEND3=y
CONFIG_COMPAT_OLD_SIGACTION=y

#
# GCOV-based kernel profiling
#
# CONFIG_GCOV_KERNEL is not set
# CONFIG_HAVE_GENERIC_DMA_COHERENT is not set
CONFIG_RT_MUTEXES=y
CONFIG_BASE_SMALL=0
CONFIG_MODULES=y
# CONFIG_MODULE_FORCE_LOAD is not set
# CONFIG_MODULE_UNLOAD is not set
CONFIG_MODVERSIONS=y
CONFIG_MODULE_SRCVERSION_ALL=y
CONFIG_MODULE_SIG=y
# CONFIG_MODULE_SIG_FORCE is not set
CONFIG_MODULE_SIG_ALL=y
# CONFIG_MODULE_SIG_SHA1 is not set
# CONFIG_MODULE_SIG_SHA224 is not set
CONFIG_MODULE_SIG_SHA256=y
# CONFIG_MODULE_SIG_SHA384 is not set
# CONFIG_MODULE_SIG_SHA512 is not set
CONFIG_MODULE_SIG_HASH="sha256"
# CONFIG_BLOCK is not set
CONFIG_PREEMPT_NOTIFIERS=y
CONFIG_ASN1=y
CONFIG_UNINLINE_SPIN_UNLOCK=y
CONFIG_ARCH_SUPPORTS_ATOMIC_RMW=y
CONFIG_ARCH_USE_QUEUE_RWLOCK=y
# CONFIG_FREEZER is not set

#
# Processor type and features
#
CONFIG_ZONE_DMA=y
# CONFIG_SMP is not set
CONFIG_X86_MPPARSE=y
CONFIG_X86_EXTENDED_PLATFORM=y
# CONFIG_X86_GOLDFISH is not set
# CONFIG_X86_INTEL_LPSS is not set
# CONFIG_SCHED_OMIT_FRAME_POINTER is not set
CONFIG_HYPERVISOR_GUEST=y
CONFIG_PARAVIRT=y
# CONFIG_PARAVIRT_DEBUG is not set
# CONFIG_XEN is not set
CONFIG_KVM_GUEST=y
# CONFIG_KVM_DEBUG_FS is not set
# CONFIG_PARAVIRT_TIME_ACCOUNTING is not set
CONFIG_PARAVIRT_CLOCK=y
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
CONFIG_PROCESSOR_SELECT=y
# CONFIG_CPU_SUP_INTEL is not set
# CONFIG_CPU_SUP_AMD is not set
# CONFIG_CPU_SUP_CENTAUR is not set
CONFIG_HPET_TIMER=y
CONFIG_DMI=y
# CONFIG_CALGARY_IOMMU is not set
CONFIG_SWIOTLB=y
CONFIG_IOMMU_HELPER=y
CONFIG_NR_CPUS=1
# CONFIG_PREEMPT_NONE is not set
CONFIG_PREEMPT_VOLUNTARY=y
# CONFIG_PREEMPT is not set
CONFIG_PREEMPT_COUNT=y
CONFIG_X86_LOCAL_APIC=y
CONFIG_X86_IO_APIC=y
# CONFIG_X86_REROUTE_FOR_BROKEN_BOOT_IRQS is not set
# CONFIG_X86_MCE is not set
# CONFIG_X86_16BIT is not set
# CONFIG_X86_VSYSCALL_EMULATION is not set
CONFIG_I8K=m
# CONFIG_MICROCODE_INTEL_EARLY is not set
# CONFIG_MICROCODE_AMD_EARLY is not set
CONFIG_X86_MSR=y
CONFIG_X86_CPUID=y
CONFIG_ARCH_PHYS_ADDR_T_64BIT=y
CONFIG_ARCH_DMA_ADDR_T_64BIT=y
CONFIG_DIRECT_GBPAGES=y
CONFIG_ARCH_SPARSEMEM_ENABLE=y
CONFIG_ARCH_SPARSEMEM_DEFAULT=y
CONFIG_ARCH_SELECT_MEMORY_MODEL=y
CONFIG_ARCH_MEMORY_PROBE=y
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
CONFIG_MEMORY_HOTPLUG=y
CONFIG_MEMORY_HOTPLUG_SPARSE=y
# CONFIG_MEMORY_HOTREMOVE is not set
CONFIG_PAGEFLAGS_EXTENDED=y
CONFIG_SPLIT_PTLOCK_CPUS=4
CONFIG_ARCH_ENABLE_SPLIT_PMD_PTLOCK=y
# CONFIG_BALLOON_COMPACTION is not set
CONFIG_COMPACTION=y
CONFIG_MIGRATION=y
CONFIG_ARCH_ENABLE_HUGEPAGE_MIGRATION=y
CONFIG_PHYS_ADDR_T_64BIT=y
CONFIG_ZONE_DMA_FLAG=1
CONFIG_VIRT_TO_BUS=y
CONFIG_MMU_NOTIFIER=y
CONFIG_KSM=y
CONFIG_DEFAULT_MMAP_MIN_ADDR=4096
CONFIG_TRANSPARENT_HUGEPAGE=y
CONFIG_TRANSPARENT_HUGEPAGE_ALWAYS=y
# CONFIG_TRANSPARENT_HUGEPAGE_MADVISE is not set
CONFIG_NEED_PER_CPU_KM=y
# CONFIG_CLEANCACHE is not set
# CONFIG_CMA is not set
# CONFIG_MEM_SOFT_DIRTY is not set
CONFIG_ZPOOL=m
CONFIG_ZBUD=m
# CONFIG_ZSMALLOC is not set
CONFIG_GENERIC_EARLY_IOREMAP=y
CONFIG_X86_CHECK_BIOS_CORRUPTION=y
# CONFIG_X86_BOOTPARAM_MEMORY_CORRUPTION_CHECK is not set
CONFIG_X86_RESERVE_LOW=64
# CONFIG_MTRR is not set
# CONFIG_ARCH_RANDOM is not set
CONFIG_X86_SMAP=y
# CONFIG_EFI is not set
# CONFIG_SECCOMP is not set
CONFIG_HZ_100=y
# CONFIG_HZ_250 is not set
# CONFIG_HZ_300 is not set
# CONFIG_HZ_1000 is not set
CONFIG_HZ=100
CONFIG_SCHED_HRTICK=y
CONFIG_KEXEC=y
CONFIG_KEXEC_VERIFY_SIG=y
# CONFIG_CRASH_DUMP is not set
CONFIG_PHYSICAL_START=0x1000000
# CONFIG_RELOCATABLE is not set
CONFIG_PHYSICAL_ALIGN=0x200000
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
# CONFIG_PM_ADVANCED_DEBUG is not set
CONFIG_WQ_POWER_EFFICIENT_DEFAULT=y
CONFIG_ACPI=y
CONFIG_ACPI_LEGACY_TABLES_LOOKUP=y
CONFIG_ARCH_MIGHT_HAVE_ACPI_PDC=y
# CONFIG_ACPI_PROCFS_POWER is not set
# CONFIG_ACPI_EC_DEBUGFS is not set
CONFIG_ACPI_AC=y
CONFIG_ACPI_BATTERY=y
CONFIG_ACPI_BUTTON=y
CONFIG_ACPI_FAN=y
# CONFIG_ACPI_DOCK is not set
CONFIG_ACPI_PROCESSOR=y
# CONFIG_ACPI_IPMI is not set
# CONFIG_ACPI_PROCESSOR_AGGREGATOR is not set
CONFIG_ACPI_THERMAL=y
CONFIG_ACPI_CUSTOM_DSDT_FILE=""
# CONFIG_ACPI_CUSTOM_DSDT is not set
# CONFIG_ACPI_INITRD_TABLE_OVERRIDE is not set
# CONFIG_ACPI_DEBUG is not set
# CONFIG_ACPI_PCI_SLOT is not set
CONFIG_X86_PM_TIMER=y
# CONFIG_ACPI_CONTAINER is not set
# CONFIG_ACPI_HOTPLUG_MEMORY is not set
# CONFIG_ACPI_SBS is not set
# CONFIG_ACPI_HED is not set
# CONFIG_ACPI_CUSTOM_METHOD is not set
# CONFIG_ACPI_REDUCED_HARDWARE_ONLY is not set
CONFIG_HAVE_ACPI_APEI=y
CONFIG_HAVE_ACPI_APEI_NMI=y
# CONFIG_ACPI_APEI is not set
# CONFIG_SFI is not set

#
# CPU Frequency scaling
#
CONFIG_CPU_FREQ=y
CONFIG_CPU_FREQ_GOV_COMMON=y
# CONFIG_CPU_FREQ_STAT is not set
# CONFIG_CPU_FREQ_DEFAULT_GOV_PERFORMANCE is not set
# CONFIG_CPU_FREQ_DEFAULT_GOV_POWERSAVE is not set
# CONFIG_CPU_FREQ_DEFAULT_GOV_USERSPACE is not set
CONFIG_CPU_FREQ_DEFAULT_GOV_ONDEMAND=y
# CONFIG_CPU_FREQ_DEFAULT_GOV_CONSERVATIVE is not set
CONFIG_CPU_FREQ_GOV_PERFORMANCE=y
# CONFIG_CPU_FREQ_GOV_POWERSAVE is not set
# CONFIG_CPU_FREQ_GOV_USERSPACE is not set
CONFIG_CPU_FREQ_GOV_ONDEMAND=y
CONFIG_CPU_FREQ_GOV_CONSERVATIVE=m

#
# x86 CPU frequency scaling drivers
#
CONFIG_X86_INTEL_PSTATE=y
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
CONFIG_CPU_IDLE_GOV_LADDER=y
CONFIG_CPU_IDLE_GOV_MENU=y
# CONFIG_ARCH_NEEDS_CPU_IDLE_COUPLED is not set

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
# CONFIG_ISA_DMA_API is not set
# CONFIG_PCCARD is not set
# CONFIG_HOTPLUG_PCI is not set
# CONFIG_RAPIDIO is not set
CONFIG_X86_SYSFB=y

#
# Executable file formats / Emulations
#
CONFIG_BINFMT_ELF=y
CONFIG_COMPAT_BINFMT_ELF=y
CONFIG_ARCH_BINFMT_ELF_RANDOMIZE_PIE=y
CONFIG_BINFMT_SCRIPT=y
# CONFIG_HAVE_AOUT is not set
CONFIG_BINFMT_MISC=m
# CONFIG_COREDUMP is not set
CONFIG_IA32_EMULATION=y
# CONFIG_IA32_AOUT is not set
CONFIG_X86_X32=y
CONFIG_COMPAT=y
CONFIG_COMPAT_FOR_U64_ALIGNMENT=y
CONFIG_SYSVIPC_COMPAT=y
CONFIG_KEYS_COMPAT=y
CONFIG_X86_DEV_DMA_OPS=y
CONFIG_IOSF_MBI=m
CONFIG_PMC_ATOM=y
CONFIG_NET=y
CONFIG_COMPAT_NETLINK_MESSAGES=y

#
# Networking options
#
CONFIG_PACKET=y
CONFIG_PACKET_DIAG=y
CONFIG_UNIX=y
CONFIG_UNIX_DIAG=m
CONFIG_XFRM=y
CONFIG_XFRM_ALGO=y
CONFIG_XFRM_USER=m
# CONFIG_XFRM_SUB_POLICY is not set
# CONFIG_XFRM_MIGRATE is not set
CONFIG_XFRM_STATISTICS=y
CONFIG_NET_KEY=m
# CONFIG_NET_KEY_MIGRATE is not set
CONFIG_INET=y
# CONFIG_IP_MULTICAST is not set
# CONFIG_IP_ADVANCED_ROUTER is not set
CONFIG_IP_ROUTE_CLASSID=y
CONFIG_IP_PNP=y
# CONFIG_IP_PNP_DHCP is not set
CONFIG_IP_PNP_BOOTP=y
# CONFIG_IP_PNP_RARP is not set
CONFIG_NET_IPIP=y
# CONFIG_NET_IPGRE_DEMUX is not set
CONFIG_NET_IP_TUNNEL=y
# CONFIG_SYN_COOKIES is not set
# CONFIG_NET_UDP_TUNNEL is not set
CONFIG_INET_AH=m
CONFIG_INET_ESP=y
# CONFIG_INET_IPCOMP is not set
# CONFIG_INET_XFRM_TUNNEL is not set
CONFIG_INET_TUNNEL=y
# CONFIG_INET_XFRM_MODE_TRANSPORT is not set
# CONFIG_INET_XFRM_MODE_TUNNEL is not set
CONFIG_INET_XFRM_MODE_BEET=m
CONFIG_INET_LRO=y
CONFIG_INET_DIAG=m
CONFIG_INET_TCP_DIAG=m
CONFIG_INET_UDP_DIAG=m
# CONFIG_TCP_CONG_ADVANCED is not set
CONFIG_TCP_CONG_CUBIC=y
CONFIG_DEFAULT_TCP_CONG="cubic"
CONFIG_TCP_MD5SIG=y
# CONFIG_IPV6 is not set
CONFIG_NETLABEL=y
CONFIG_NETWORK_SECMARK=y
CONFIG_NET_PTP_CLASSIFY=y
CONFIG_NETWORK_PHY_TIMESTAMPING=y
CONFIG_NETFILTER=y
# CONFIG_NETFILTER_DEBUG is not set
CONFIG_NETFILTER_ADVANCED=y
CONFIG_BRIDGE_NETFILTER=y

#
# Core Netfilter Configuration
#
CONFIG_NETFILTER_NETLINK=y
CONFIG_NETFILTER_NETLINK_ACCT=y
CONFIG_NETFILTER_NETLINK_QUEUE=y
CONFIG_NETFILTER_NETLINK_LOG=m
# CONFIG_NF_CONNTRACK is not set
CONFIG_NF_LOG_COMMON=y
# CONFIG_NF_TABLES is not set
CONFIG_NETFILTER_XTABLES=y

#
# Xtables combined modules
#
CONFIG_NETFILTER_XT_MARK=y
CONFIG_NETFILTER_XT_SET=m

#
# Xtables targets
#
# CONFIG_NETFILTER_XT_TARGET_AUDIT is not set
CONFIG_NETFILTER_XT_TARGET_CLASSIFY=m
# CONFIG_NETFILTER_XT_TARGET_HMARK is not set
CONFIG_NETFILTER_XT_TARGET_IDLETIMER=y
CONFIG_NETFILTER_XT_TARGET_LED=m
CONFIG_NETFILTER_XT_TARGET_MARK=y
CONFIG_NETFILTER_XT_TARGET_NFLOG=m
# CONFIG_NETFILTER_XT_TARGET_NFQUEUE is not set
CONFIG_NETFILTER_XT_TARGET_RATEEST=y
CONFIG_NETFILTER_XT_TARGET_TEE=m
# CONFIG_NETFILTER_XT_TARGET_TRACE is not set
# CONFIG_NETFILTER_XT_TARGET_SECMARK is not set
CONFIG_NETFILTER_XT_TARGET_TCPMSS=y

#
# Xtables matches
#
CONFIG_NETFILTER_XT_MATCH_ADDRTYPE=m
CONFIG_NETFILTER_XT_MATCH_BPF=m
# CONFIG_NETFILTER_XT_MATCH_COMMENT is not set
CONFIG_NETFILTER_XT_MATCH_CPU=m
CONFIG_NETFILTER_XT_MATCH_DCCP=m
CONFIG_NETFILTER_XT_MATCH_DEVGROUP=y
CONFIG_NETFILTER_XT_MATCH_DSCP=y
CONFIG_NETFILTER_XT_MATCH_ECN=m
CONFIG_NETFILTER_XT_MATCH_ESP=m
CONFIG_NETFILTER_XT_MATCH_HASHLIMIT=m
CONFIG_NETFILTER_XT_MATCH_HL=m
CONFIG_NETFILTER_XT_MATCH_IPCOMP=y
# CONFIG_NETFILTER_XT_MATCH_IPRANGE is not set
# CONFIG_NETFILTER_XT_MATCH_L2TP is not set
CONFIG_NETFILTER_XT_MATCH_LENGTH=m
CONFIG_NETFILTER_XT_MATCH_LIMIT=y
CONFIG_NETFILTER_XT_MATCH_MAC=m
# CONFIG_NETFILTER_XT_MATCH_MARK is not set
# CONFIG_NETFILTER_XT_MATCH_MULTIPORT is not set
CONFIG_NETFILTER_XT_MATCH_NFACCT=m
CONFIG_NETFILTER_XT_MATCH_OSF=m
# CONFIG_NETFILTER_XT_MATCH_OWNER is not set
CONFIG_NETFILTER_XT_MATCH_POLICY=m
CONFIG_NETFILTER_XT_MATCH_PHYSDEV=m
CONFIG_NETFILTER_XT_MATCH_PKTTYPE=m
CONFIG_NETFILTER_XT_MATCH_QUOTA=y
CONFIG_NETFILTER_XT_MATCH_RATEEST=m
# CONFIG_NETFILTER_XT_MATCH_REALM is not set
CONFIG_NETFILTER_XT_MATCH_RECENT=y
CONFIG_NETFILTER_XT_MATCH_SCTP=y
# CONFIG_NETFILTER_XT_MATCH_SOCKET is not set
# CONFIG_NETFILTER_XT_MATCH_STATISTIC is not set
CONFIG_NETFILTER_XT_MATCH_STRING=m
CONFIG_NETFILTER_XT_MATCH_TCPMSS=y
CONFIG_NETFILTER_XT_MATCH_TIME=m
# CONFIG_NETFILTER_XT_MATCH_U32 is not set
CONFIG_IP_SET=m
CONFIG_IP_SET_MAX=256
CONFIG_IP_SET_BITMAP_IP=m
CONFIG_IP_SET_BITMAP_IPMAC=m
CONFIG_IP_SET_BITMAP_PORT=m
CONFIG_IP_SET_HASH_IP=m
CONFIG_IP_SET_HASH_IPMARK=m
# CONFIG_IP_SET_HASH_IPPORT is not set
CONFIG_IP_SET_HASH_IPPORTIP=m
# CONFIG_IP_SET_HASH_IPPORTNET is not set
CONFIG_IP_SET_HASH_NETPORTNET=m
# CONFIG_IP_SET_HASH_NET is not set
CONFIG_IP_SET_HASH_NETNET=m
CONFIG_IP_SET_HASH_NETPORT=m
CONFIG_IP_SET_HASH_NETIFACE=m
CONFIG_IP_SET_LIST_SET=m
CONFIG_IP_VS=m
CONFIG_IP_VS_DEBUG=y
CONFIG_IP_VS_TAB_BITS=12

#
# IPVS transport protocol load balancing support
#
CONFIG_IP_VS_PROTO_TCP=y
CONFIG_IP_VS_PROTO_UDP=y
CONFIG_IP_VS_PROTO_AH_ESP=y
# CONFIG_IP_VS_PROTO_ESP is not set
CONFIG_IP_VS_PROTO_AH=y
# CONFIG_IP_VS_PROTO_SCTP is not set

#
# IPVS scheduler
#
CONFIG_IP_VS_RR=m
# CONFIG_IP_VS_WRR is not set
CONFIG_IP_VS_LC=m
# CONFIG_IP_VS_WLC is not set
CONFIG_IP_VS_LBLC=m
# CONFIG_IP_VS_LBLCR is not set
CONFIG_IP_VS_DH=m
# CONFIG_IP_VS_SH is not set
CONFIG_IP_VS_SED=m
CONFIG_IP_VS_NQ=m

#
# IPVS SH scheduler
#
CONFIG_IP_VS_SH_TAB_BITS=8

#
# IPVS application helper
#

#
# IP: Netfilter Configuration
#
# CONFIG_NF_DEFRAG_IPV4 is not set
CONFIG_NF_LOG_ARP=y
CONFIG_NF_LOG_IPV4=y
CONFIG_IP_NF_IPTABLES=y
CONFIG_IP_NF_MATCH_AH=m
# CONFIG_IP_NF_MATCH_ECN is not set
# CONFIG_IP_NF_MATCH_RPFILTER is not set
CONFIG_IP_NF_MATCH_TTL=m
CONFIG_IP_NF_FILTER=y
CONFIG_IP_NF_TARGET_REJECT=m
# CONFIG_IP_NF_MANGLE is not set
CONFIG_IP_NF_RAW=m
# CONFIG_IP_NF_SECURITY is not set
CONFIG_IP_NF_ARPTABLES=y
CONFIG_IP_NF_ARPFILTER=m
CONFIG_IP_NF_ARP_MANGLE=y

#
# DECnet: Netfilter Configuration
#
CONFIG_DECNET_NF_GRABULATOR=m
CONFIG_BRIDGE_NF_EBTABLES=y
CONFIG_BRIDGE_EBT_BROUTE=m
# CONFIG_BRIDGE_EBT_T_FILTER is not set
CONFIG_BRIDGE_EBT_T_NAT=m
CONFIG_BRIDGE_EBT_802_3=m
CONFIG_BRIDGE_EBT_AMONG=y
CONFIG_BRIDGE_EBT_ARP=m
CONFIG_BRIDGE_EBT_IP=y
# CONFIG_BRIDGE_EBT_LIMIT is not set
# CONFIG_BRIDGE_EBT_MARK is not set
# CONFIG_BRIDGE_EBT_PKTTYPE is not set
CONFIG_BRIDGE_EBT_STP=y
# CONFIG_BRIDGE_EBT_VLAN is not set
CONFIG_BRIDGE_EBT_ARPREPLY=y
# CONFIG_BRIDGE_EBT_DNAT is not set
CONFIG_BRIDGE_EBT_MARK_T=m
# CONFIG_BRIDGE_EBT_REDIRECT is not set
# CONFIG_BRIDGE_EBT_SNAT is not set
CONFIG_BRIDGE_EBT_LOG=m
# CONFIG_BRIDGE_EBT_NFLOG is not set
CONFIG_IP_DCCP=m
CONFIG_INET_DCCP_DIAG=m

#
# DCCP CCIDs Configuration
#
# CONFIG_IP_DCCP_CCID2_DEBUG is not set
CONFIG_IP_DCCP_CCID3=y
CONFIG_IP_DCCP_CCID3_DEBUG=y
CONFIG_IP_DCCP_TFRC_LIB=y
CONFIG_IP_DCCP_TFRC_DEBUG=y

#
# DCCP Kernel Hacking
#
CONFIG_IP_DCCP_DEBUG=y
CONFIG_NET_DCCPPROBE=m
CONFIG_IP_SCTP=y
CONFIG_NET_SCTPPROBE=y
CONFIG_SCTP_DBG_OBJCNT=y
# CONFIG_SCTP_DEFAULT_COOKIE_HMAC_MD5 is not set
# CONFIG_SCTP_DEFAULT_COOKIE_HMAC_SHA1 is not set
CONFIG_SCTP_DEFAULT_COOKIE_HMAC_NONE=y
# CONFIG_SCTP_COOKIE_HMAC_MD5 is not set
# CONFIG_SCTP_COOKIE_HMAC_SHA1 is not set
# CONFIG_RDS is not set
CONFIG_TIPC=y
CONFIG_TIPC_PORTS=8191
# CONFIG_ATM is not set
# CONFIG_L2TP is not set
CONFIG_STP=y
CONFIG_BRIDGE=y
# CONFIG_BRIDGE_IGMP_SNOOPING is not set
CONFIG_BRIDGE_VLAN_FILTERING=y
CONFIG_HAVE_NET_DSA=y
CONFIG_NET_DSA=y
CONFIG_NET_DSA_TAG_EDSA=y
CONFIG_NET_DSA_TAG_TRAILER=y
CONFIG_VLAN_8021Q=y
# CONFIG_VLAN_8021Q_GVRP is not set
# CONFIG_VLAN_8021Q_MVRP is not set
CONFIG_DECNET=m
CONFIG_DECNET_ROUTER=y
CONFIG_LLC=y
CONFIG_LLC2=m
CONFIG_IPX=m
CONFIG_IPX_INTERN=y
CONFIG_ATALK=m
CONFIG_DEV_APPLETALK=m
CONFIG_IPDDP=m
# CONFIG_IPDDP_ENCAP is not set
CONFIG_X25=y
# CONFIG_LAPB is not set
CONFIG_PHONET=y
CONFIG_IEEE802154=y
CONFIG_MAC802154=y
CONFIG_NET_SCHED=y

#
# Queueing/Scheduling
#
# CONFIG_NET_SCH_CBQ is not set
# CONFIG_NET_SCH_HTB is not set
CONFIG_NET_SCH_HFSC=m
# CONFIG_NET_SCH_PRIO is not set
CONFIG_NET_SCH_MULTIQ=m
# CONFIG_NET_SCH_RED is not set
CONFIG_NET_SCH_SFB=m
# CONFIG_NET_SCH_SFQ is not set
# CONFIG_NET_SCH_TEQL is not set
# CONFIG_NET_SCH_TBF is not set
# CONFIG_NET_SCH_GRED is not set
CONFIG_NET_SCH_DSMARK=y
# CONFIG_NET_SCH_NETEM is not set
# CONFIG_NET_SCH_DRR is not set
CONFIG_NET_SCH_MQPRIO=m
CONFIG_NET_SCH_CHOKE=m
CONFIG_NET_SCH_QFQ=y
# CONFIG_NET_SCH_CODEL is not set
CONFIG_NET_SCH_FQ_CODEL=y
CONFIG_NET_SCH_FQ=m
CONFIG_NET_SCH_HHF=y
# CONFIG_NET_SCH_PIE is not set
CONFIG_NET_SCH_PLUG=y

#
# Classification
#
CONFIG_NET_CLS=y
CONFIG_NET_CLS_BASIC=y
CONFIG_NET_CLS_TCINDEX=m
CONFIG_NET_CLS_ROUTE4=y
CONFIG_NET_CLS_FW=m
# CONFIG_NET_CLS_U32 is not set
CONFIG_NET_CLS_RSVP=m
CONFIG_NET_CLS_RSVP6=m
CONFIG_NET_CLS_FLOW=y
CONFIG_NET_CLS_BPF=m
# CONFIG_NET_EMATCH is not set
# CONFIG_NET_CLS_ACT is not set
CONFIG_NET_CLS_IND=y
CONFIG_NET_SCH_FIFO=y
# CONFIG_DCB is not set
CONFIG_DNS_RESOLVER=y
CONFIG_BATMAN_ADV=y
CONFIG_BATMAN_ADV_BLA=y
CONFIG_BATMAN_ADV_DAT=y
# CONFIG_BATMAN_ADV_NC is not set
# CONFIG_BATMAN_ADV_MCAST is not set
# CONFIG_BATMAN_ADV_DEBUG is not set
# CONFIG_OPENVSWITCH is not set
CONFIG_VSOCKETS=y
CONFIG_NETLINK_MMAP=y
CONFIG_NETLINK_DIAG=y
CONFIG_NET_MPLS_GSO=m
CONFIG_HSR=m
CONFIG_NET_RX_BUSY_POLL=y
CONFIG_BQL=y
# CONFIG_BPF_JIT is not set

#
# Network testing
#
CONFIG_NET_PKTGEN=y
# CONFIG_NET_TCPPROBE is not set
# CONFIG_HAMRADIO is not set
CONFIG_CAN=y
CONFIG_CAN_RAW=m
CONFIG_CAN_BCM=m
CONFIG_CAN_GW=y

#
# CAN Device Drivers
#
CONFIG_CAN_VCAN=y
# CONFIG_CAN_SLCAN is not set
CONFIG_CAN_DEV=y
CONFIG_CAN_CALC_BITTIMING=y
CONFIG_CAN_LEDS=y
CONFIG_CAN_SJA1000=y
CONFIG_CAN_SJA1000_ISA=m
# CONFIG_CAN_SJA1000_PLATFORM is not set
# CONFIG_CAN_EMS_PCI is not set
# CONFIG_CAN_PEAK_PCI is not set
# CONFIG_CAN_KVASER_PCI is not set
# CONFIG_CAN_PLX_PCI is not set
CONFIG_CAN_C_CAN=y
# CONFIG_CAN_C_CAN_PLATFORM is not set
# CONFIG_CAN_C_CAN_PCI is not set
# CONFIG_CAN_CC770 is not set

#
# CAN USB interfaces
#
CONFIG_CAN_EMS_USB=m
# CONFIG_CAN_ESD_USB2 is not set
CONFIG_CAN_GS_USB=m
CONFIG_CAN_KVASER_USB=m
CONFIG_CAN_PEAK_USB=m
CONFIG_CAN_8DEV_USB=m
CONFIG_CAN_SOFTING=m
# CONFIG_CAN_DEBUG_DEVICES is not set
# CONFIG_IRDA is not set
# CONFIG_BT is not set
CONFIG_AF_RXRPC=m
# CONFIG_AF_RXRPC_DEBUG is not set
# CONFIG_RXKAD is not set
CONFIG_FIB_RULES=y
CONFIG_WIRELESS=y
CONFIG_WEXT_CORE=y
CONFIG_WEXT_PROC=y
CONFIG_CFG80211=y
CONFIG_NL80211_TESTMODE=y
# CONFIG_CFG80211_DEVELOPER_WARNINGS is not set
CONFIG_CFG80211_REG_DEBUG=y
# CONFIG_CFG80211_CERTIFICATION_ONUS is not set
CONFIG_CFG80211_DEFAULT_PS=y
CONFIG_CFG80211_DEBUGFS=y
# CONFIG_CFG80211_INTERNAL_REGDB is not set
CONFIG_CFG80211_WEXT=y
# CONFIG_LIB80211 is not set
# CONFIG_MAC80211 is not set
CONFIG_WIMAX=y
CONFIG_WIMAX_DEBUG_LEVEL=8
CONFIG_RFKILL=y
CONFIG_RFKILL_LEDS=y
# CONFIG_RFKILL_INPUT is not set
CONFIG_RFKILL_REGULATOR=m
CONFIG_RFKILL_GPIO=y
CONFIG_NET_9P=y
# CONFIG_NET_9P_VIRTIO is not set
CONFIG_NET_9P_DEBUG=y
CONFIG_CAIF=m
CONFIG_CAIF_DEBUG=y
# CONFIG_CAIF_NETDEV is not set
# CONFIG_CAIF_USB is not set
CONFIG_CEPH_LIB=y
CONFIG_CEPH_LIB_PRETTYDEBUG=y
CONFIG_CEPH_LIB_USE_DNS_RESOLVER=y
CONFIG_NFC=y
CONFIG_NFC_DIGITAL=m
# CONFIG_NFC_NCI is not set
# CONFIG_NFC_HCI is not set

#
# Near Field Communication (NFC) devices
#
# CONFIG_NFC_PN533 is not set
CONFIG_NFC_SIM=y
CONFIG_NFC_PORT100=m
CONFIG_HAVE_BPF_JIT=y

#
# Device Drivers
#

#
# Generic Driver Options
#
# CONFIG_UEVENT_HELPER is not set
# CONFIG_DEVTMPFS is not set
# CONFIG_STANDALONE is not set
CONFIG_PREVENT_FIRMWARE_BUILD=y
CONFIG_FW_LOADER=y
CONFIG_FIRMWARE_IN_KERNEL=y
CONFIG_EXTRA_FIRMWARE=""
CONFIG_FW_LOADER_USER_HELPER=y
CONFIG_FW_LOADER_USER_HELPER_FALLBACK=y
# CONFIG_DEBUG_DRIVER is not set
# CONFIG_DEBUG_DEVRES is not set
# CONFIG_SYS_HYPERVISOR is not set
# CONFIG_GENERIC_CPU_DEVICES is not set
CONFIG_GENERIC_CPU_AUTOPROBE=y
CONFIG_REGMAP=y
CONFIG_REGMAP_I2C=m
CONFIG_REGMAP_MMIO=y
CONFIG_REGMAP_IRQ=y
CONFIG_DMA_SHARED_BUFFER=y
# CONFIG_FENCE_TRACE is not set

#
# Bus devices
#
CONFIG_CONNECTOR=y
# CONFIG_PROC_EVENTS is not set
CONFIG_MTD=m
CONFIG_MTD_TESTS=m
CONFIG_MTD_REDBOOT_PARTS=m
CONFIG_MTD_REDBOOT_DIRECTORY_BLOCK=-1
# CONFIG_MTD_REDBOOT_PARTS_UNALLOCATED is not set
CONFIG_MTD_REDBOOT_PARTS_READONLY=y
CONFIG_MTD_CMDLINE_PARTS=m
# CONFIG_MTD_AR7_PARTS is not set

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
# CONFIG_MTD_CFI_NOSWAP is not set
CONFIG_MTD_CFI_BE_BYTE_SWAP=y
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
CONFIG_MTD_CFI_INTELEXT=m
CONFIG_MTD_CFI_AMDSTD=m
CONFIG_MTD_CFI_STAA=m
CONFIG_MTD_CFI_UTIL=m
CONFIG_MTD_RAM=m
# CONFIG_MTD_ROM is not set
CONFIG_MTD_ABSENT=m

#
# Mapping drivers for chip access
#
CONFIG_MTD_COMPLEX_MAPPINGS=y
# CONFIG_MTD_PHYSMAP is not set
CONFIG_MTD_SBC_GXX=m
# CONFIG_MTD_AMD76XROM is not set
CONFIG_MTD_ICHXROM=m
# CONFIG_MTD_ESB2ROM is not set
# CONFIG_MTD_CK804XROM is not set
# CONFIG_MTD_SCB2_FLASH is not set
CONFIG_MTD_NETtel=m
CONFIG_MTD_L440GX=m
# CONFIG_MTD_PCI is not set
# CONFIG_MTD_GPIO_ADDR is not set
# CONFIG_MTD_INTEL_VR_NOR is not set
# CONFIG_MTD_PLATRAM is not set
CONFIG_MTD_LATCH_ADDR=m

#
# Self-contained MTD device drivers
#
# CONFIG_MTD_PMC551 is not set
# CONFIG_MTD_SLRAM is not set
CONFIG_MTD_PHRAM=m
# CONFIG_MTD_MTDRAM is not set

#
# Disk-On-Chip Device Drivers
#
CONFIG_MTD_DOCG3=m
CONFIG_BCH_CONST_M=14
CONFIG_BCH_CONST_T=4
# CONFIG_MTD_NAND is not set
CONFIG_MTD_ONENAND=m
CONFIG_MTD_ONENAND_VERIFY_WRITE=y
CONFIG_MTD_ONENAND_GENERIC=m
# CONFIG_MTD_ONENAND_OTP is not set
CONFIG_MTD_ONENAND_2X_PROGRAM=y

#
# LPDDR & LPDDR2 PCM memory drivers
#
CONFIG_MTD_LPDDR=m
CONFIG_MTD_QINFO_PROBE=m
CONFIG_MTD_SPI_NOR=m
CONFIG_MTD_UBI=m
CONFIG_MTD_UBI_WL_THRESHOLD=4096
CONFIG_MTD_UBI_BEB_LIMIT=20
# CONFIG_MTD_UBI_FASTMAP is not set
CONFIG_MTD_UBI_GLUEBI=m
CONFIG_ARCH_MIGHT_HAVE_PC_PARPORT=y
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
CONFIG_SENSORS_LIS3LV02D=m
# CONFIG_AD525X_DPOT is not set
CONFIG_DUMMY_IRQ=m
# CONFIG_IBM_ASM is not set
# CONFIG_PHANTOM is not set
# CONFIG_SGI_IOC4 is not set
# CONFIG_TIFM_CORE is not set
CONFIG_ICS932S401=m
CONFIG_ENCLOSURE_SERVICES=m
# CONFIG_HP_ILO is not set
CONFIG_APDS9802ALS=m
CONFIG_ISL29003=m
# CONFIG_ISL29020 is not set
CONFIG_SENSORS_TSL2550=m
CONFIG_SENSORS_BH1780=m
CONFIG_SENSORS_BH1770=m
# CONFIG_SENSORS_APDS990X is not set
CONFIG_HMC6352=m
CONFIG_DS1682=m
# CONFIG_VMWARE_BALLOON is not set
# CONFIG_BMP085_I2C is not set
CONFIG_USB_SWITCH_FSA9480=m
CONFIG_SRAM=y
CONFIG_C2PORT=y
CONFIG_C2PORT_DURAMAR_2150=y

#
# EEPROM support
#
CONFIG_EEPROM_AT24=m
CONFIG_EEPROM_LEGACY=m
CONFIG_EEPROM_MAX6875=m
# CONFIG_EEPROM_93CX6 is not set
# CONFIG_CB710_CORE is not set

#
# Texas Instruments shared transport line discipline
#
# CONFIG_TI_ST is not set
CONFIG_SENSORS_LIS3_I2C=m

#
# Altera FPGA firmware download module
#
CONFIG_ALTERA_STAPL=m
# CONFIG_INTEL_MEI is not set
# CONFIG_INTEL_MEI_ME is not set
# CONFIG_INTEL_MEI_TXE is not set
# CONFIG_VMWARE_VMCI is not set

#
# Intel MIC Bus Driver
#
# CONFIG_INTEL_MIC_BUS is not set

#
# Intel MIC Host Driver
#

#
# Intel MIC Card Driver
#
# CONFIG_GENWQE is not set
# CONFIG_ECHO is not set
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
CONFIG_MACINTOSH_DRIVERS=y
CONFIG_NETDEVICES=y
CONFIG_MII=y
CONFIG_NET_CORE=y
CONFIG_BONDING=y
# CONFIG_DUMMY is not set
# CONFIG_EQUALIZER is not set
CONFIG_NET_TEAM=y
CONFIG_NET_TEAM_MODE_BROADCAST=y
CONFIG_NET_TEAM_MODE_ROUNDROBIN=y
# CONFIG_NET_TEAM_MODE_RANDOM is not set
CONFIG_NET_TEAM_MODE_ACTIVEBACKUP=m
CONFIG_NET_TEAM_MODE_LOADBALANCE=y
# CONFIG_MACVLAN is not set
# CONFIG_VXLAN is not set
CONFIG_NETCONSOLE=m
# CONFIG_NETCONSOLE_DYNAMIC is not set
CONFIG_NETPOLL=y
CONFIG_NET_POLL_CONTROLLER=y
# CONFIG_TUN is not set
# CONFIG_VETH is not set
# CONFIG_VIRTIO_NET is not set
# CONFIG_NLMON is not set
# CONFIG_ARCNET is not set

#
# CAIF transport drivers
#
# CONFIG_CAIF_TTY is not set
CONFIG_CAIF_SPI_SLAVE=m
CONFIG_CAIF_SPI_SYNC=y
CONFIG_CAIF_HSI=m
CONFIG_CAIF_VIRTIO=m
# CONFIG_VHOST_NET is not set
CONFIG_VHOST_RING=m

#
# Distributed Switch Architecture drivers
#
CONFIG_NET_DSA_MV88E6XXX=m
CONFIG_NET_DSA_MV88E6060=y
# CONFIG_NET_DSA_MV88E6XXX_NEED_PPU is not set
# CONFIG_NET_DSA_MV88E6131 is not set
CONFIG_NET_DSA_MV88E6123_61_65=m
CONFIG_ETHERNET=y
CONFIG_NET_VENDOR_3COM=y
# CONFIG_VORTEX is not set
# CONFIG_TYPHOON is not set
CONFIG_NET_VENDOR_ADAPTEC=y
# CONFIG_ADAPTEC_STARFIRE is not set
CONFIG_NET_VENDOR_ALTEON=y
# CONFIG_ACENIC is not set
CONFIG_ALTERA_TSE=y
CONFIG_NET_VENDOR_AMD=y
# CONFIG_AMD8111_ETH is not set
# CONFIG_PCNET32 is not set
CONFIG_NET_XGENE=y
CONFIG_NET_VENDOR_ARC=y
CONFIG_NET_VENDOR_ATHEROS=y
# CONFIG_ATL2 is not set
# CONFIG_ATL1 is not set
# CONFIG_ATL1E is not set
# CONFIG_ATL1C is not set
# CONFIG_ALX is not set
# CONFIG_NET_VENDOR_BROADCOM is not set
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
# CONFIG_CX_ECAT is not set
CONFIG_DNET=y
CONFIG_NET_VENDOR_DEC=y
# CONFIG_NET_TULIP is not set
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
# CONFIG_E100 is not set
# CONFIG_E1000 is not set
# CONFIG_E1000E is not set
# CONFIG_IGB is not set
# CONFIG_IGBVF is not set
# CONFIG_IXGB is not set
# CONFIG_IXGBE is not set
# CONFIG_I40E is not set
CONFIG_NET_VENDOR_I825XX=y
# CONFIG_IP1000 is not set
# CONFIG_JME is not set
CONFIG_NET_VENDOR_MARVELL=y
CONFIG_MVMDIO=m
# CONFIG_SKGE is not set
# CONFIG_SKY2 is not set
CONFIG_NET_VENDOR_MELLANOX=y
# CONFIG_MLX4_EN is not set
# CONFIG_MLX4_CORE is not set
# CONFIG_MLX5_CORE is not set
CONFIG_NET_VENDOR_MICREL=y
CONFIG_KS8842=y
CONFIG_KS8851_MLL=y
# CONFIG_KSZ884X_PCI is not set
CONFIG_NET_VENDOR_MYRI=y
# CONFIG_MYRI10GE is not set
# CONFIG_FEALNX is not set
# CONFIG_NET_VENDOR_NATSEMI is not set
CONFIG_NET_VENDOR_NVIDIA=y
# CONFIG_FORCEDETH is not set
CONFIG_NET_VENDOR_OKI=y
# CONFIG_ETHOC is not set
CONFIG_NET_PACKET_ENGINE=y
# CONFIG_HAMACHI is not set
# CONFIG_YELLOWFIN is not set
CONFIG_NET_VENDOR_QLOGIC=y
# CONFIG_QLA3XXX is not set
# CONFIG_QLCNIC is not set
# CONFIG_QLGE is not set
# CONFIG_NETXEN_NIC is not set
CONFIG_NET_VENDOR_REALTEK=y
# CONFIG_8139CP is not set
# CONFIG_8139TOO is not set
# CONFIG_R8169 is not set
# CONFIG_SH_ETH is not set
CONFIG_NET_VENDOR_RDC=y
# CONFIG_R6040 is not set
# CONFIG_NET_VENDOR_SAMSUNG is not set
CONFIG_NET_VENDOR_SEEQ=y
CONFIG_NET_VENDOR_SILAN=y
# CONFIG_SC92031 is not set
CONFIG_NET_VENDOR_SIS=y
# CONFIG_SIS900 is not set
# CONFIG_SIS190 is not set
# CONFIG_SFC is not set
CONFIG_NET_VENDOR_SMSC=y
# CONFIG_EPIC100 is not set
# CONFIG_SMSC911X is not set
# CONFIG_SMSC9420 is not set
# CONFIG_NET_VENDOR_STMICRO is not set
CONFIG_NET_VENDOR_SUN=y
# CONFIG_HAPPYMEAL is not set
# CONFIG_SUNGEM is not set
# CONFIG_CASSINI is not set
# CONFIG_NIU is not set
CONFIG_NET_VENDOR_TEHUTI=y
# CONFIG_TEHUTI is not set
CONFIG_NET_VENDOR_TI=y
# CONFIG_TLAN is not set
# CONFIG_NET_VENDOR_VIA is not set
# CONFIG_NET_VENDOR_WIZNET is not set
# CONFIG_FDDI is not set
# CONFIG_HIPPI is not set
# CONFIG_NET_SB1000 is not set
CONFIG_PHYLIB=y

#
# MII PHY device drivers
#
# CONFIG_AT803X_PHY is not set
CONFIG_AMD_PHY=m
# CONFIG_MARVELL_PHY is not set
CONFIG_DAVICOM_PHY=m
CONFIG_QSEMI_PHY=m
CONFIG_LXT_PHY=m
# CONFIG_CICADA_PHY is not set
CONFIG_VITESSE_PHY=m
# CONFIG_SMSC_PHY is not set
# CONFIG_BROADCOM_PHY is not set
CONFIG_BCM7XXX_PHY=y
CONFIG_BCM87XX_PHY=m
CONFIG_ICPLUS_PHY=y
CONFIG_REALTEK_PHY=m
CONFIG_NATIONAL_PHY=y
CONFIG_STE10XP=m
CONFIG_LSI_ET1011C_PHY=y
CONFIG_MICREL_PHY=y
CONFIG_FIXED_PHY=y
CONFIG_MDIO_BITBANG=m
CONFIG_MDIO_GPIO=m
CONFIG_PPP=m
CONFIG_PPP_BSDCOMP=m
CONFIG_PPP_DEFLATE=m
# CONFIG_PPP_FILTER is not set
# CONFIG_PPP_MPPE is not set
CONFIG_PPP_MULTILINK=y
CONFIG_PPPOE=m
# CONFIG_PPP_ASYNC is not set
# CONFIG_PPP_SYNC_TTY is not set
# CONFIG_SLIP is not set
CONFIG_SLHC=m

#
# Host-side USB support is needed for USB Network Adapter support
#
CONFIG_USB_NET_DRIVERS=m
CONFIG_USB_CATC=m
# CONFIG_USB_KAWETH is not set
CONFIG_USB_PEGASUS=m
# CONFIG_USB_RTL8150 is not set
CONFIG_USB_RTL8152=m
CONFIG_USB_USBNET=m
CONFIG_USB_NET_AX8817X=m
# CONFIG_USB_NET_AX88179_178A is not set
CONFIG_USB_NET_CDCETHER=m
# CONFIG_USB_NET_CDC_EEM is not set
CONFIG_USB_NET_CDC_NCM=m
# CONFIG_USB_NET_HUAWEI_CDC_NCM is not set
CONFIG_USB_NET_CDC_MBIM=m
CONFIG_USB_NET_DM9601=m
CONFIG_USB_NET_SR9700=m
# CONFIG_USB_NET_SR9800 is not set
# CONFIG_USB_NET_SMSC75XX is not set
CONFIG_USB_NET_SMSC95XX=m
CONFIG_USB_NET_GL620A=m
CONFIG_USB_NET_NET1080=m
# CONFIG_USB_NET_PLUSB is not set
# CONFIG_USB_NET_MCS7830 is not set
CONFIG_USB_NET_RNDIS_HOST=m
CONFIG_USB_NET_CDC_SUBSET=m
# CONFIG_USB_ALI_M5632 is not set
# CONFIG_USB_AN2720 is not set
# CONFIG_USB_BELKIN is not set
# CONFIG_USB_ARMLINUX is not set
CONFIG_USB_EPSON2888=y
# CONFIG_USB_KC2190 is not set
CONFIG_USB_NET_ZAURUS=m
CONFIG_USB_NET_CX82310_ETH=m
CONFIG_USB_NET_KALMIA=m
# CONFIG_USB_NET_QMI_WWAN is not set
# CONFIG_USB_HSO is not set
CONFIG_USB_NET_INT51X1=m
CONFIG_USB_CDC_PHONET=m
CONFIG_USB_IPHETH=m
CONFIG_USB_SIERRA_NET=m
# CONFIG_USB_VL600 is not set
# CONFIG_WLAN is not set

#
# WiMAX Wireless Broadband devices
#
CONFIG_WIMAX_I2400M=m
CONFIG_WIMAX_I2400M_USB=m
CONFIG_WIMAX_I2400M_DEBUG_LEVEL=8
# CONFIG_WAN is not set
CONFIG_IEEE802154_DRIVERS=y
# CONFIG_IEEE802154_FAKEHARD is not set
CONFIG_IEEE802154_FAKELB=y
# CONFIG_VMXNET3 is not set
# CONFIG_ISDN is not set

#
# Input device support
#
CONFIG_INPUT=y
CONFIG_INPUT_FF_MEMLESS=m
CONFIG_INPUT_POLLDEV=m
CONFIG_INPUT_SPARSEKMAP=m
CONFIG_INPUT_MATRIXKMAP=m

#
# Userland interfaces
#
# CONFIG_INPUT_MOUSEDEV is not set
CONFIG_INPUT_JOYDEV=m
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
CONFIG_INPUT_MOUSE=y
# CONFIG_MOUSE_PS2 is not set
# CONFIG_MOUSE_SERIAL is not set
# CONFIG_MOUSE_APPLETOUCH is not set
# CONFIG_MOUSE_BCM5974 is not set
# CONFIG_MOUSE_CYAPA is not set
# CONFIG_MOUSE_VSXXXAA is not set
CONFIG_MOUSE_GPIO=m
# CONFIG_MOUSE_SYNAPTICS_I2C is not set
CONFIG_MOUSE_SYNAPTICS_USB=m
CONFIG_INPUT_JOYSTICK=y
# CONFIG_JOYSTICK_ANALOG is not set
CONFIG_JOYSTICK_A3D=m
CONFIG_JOYSTICK_ADI=m
CONFIG_JOYSTICK_COBRA=m
# CONFIG_JOYSTICK_GF2K is not set
CONFIG_JOYSTICK_GRIP=m
# CONFIG_JOYSTICK_GRIP_MP is not set
# CONFIG_JOYSTICK_GUILLEMOT is not set
# CONFIG_JOYSTICK_INTERACT is not set
# CONFIG_JOYSTICK_SIDEWINDER is not set
CONFIG_JOYSTICK_TMDC=m
# CONFIG_JOYSTICK_IFORCE is not set
CONFIG_JOYSTICK_WARRIOR=m
CONFIG_JOYSTICK_MAGELLAN=m
# CONFIG_JOYSTICK_SPACEORB is not set
# CONFIG_JOYSTICK_SPACEBALL is not set
CONFIG_JOYSTICK_STINGER=m
CONFIG_JOYSTICK_TWIDJOY=m
CONFIG_JOYSTICK_ZHENHUA=m
# CONFIG_JOYSTICK_AS5011 is not set
CONFIG_JOYSTICK_JOYDUMP=m
CONFIG_JOYSTICK_XPAD=m
# CONFIG_JOYSTICK_XPAD_FF is not set
CONFIG_JOYSTICK_XPAD_LEDS=y
# CONFIG_INPUT_TABLET is not set
CONFIG_INPUT_TOUCHSCREEN=y
CONFIG_TOUCHSCREEN_AD7879=m
CONFIG_TOUCHSCREEN_AD7879_I2C=m
CONFIG_TOUCHSCREEN_ATMEL_MXT=m
CONFIG_TOUCHSCREEN_AUO_PIXCIR=m
# CONFIG_TOUCHSCREEN_BU21013 is not set
CONFIG_TOUCHSCREEN_CY8CTMG110=m
CONFIG_TOUCHSCREEN_CYTTSP_CORE=m
CONFIG_TOUCHSCREEN_CYTTSP_I2C=m
CONFIG_TOUCHSCREEN_CYTTSP4_CORE=m
# CONFIG_TOUCHSCREEN_CYTTSP4_I2C is not set
CONFIG_TOUCHSCREEN_DYNAPRO=m
CONFIG_TOUCHSCREEN_HAMPSHIRE=m
CONFIG_TOUCHSCREEN_EETI=m
CONFIG_TOUCHSCREEN_FUJITSU=m
CONFIG_TOUCHSCREEN_ILI210X=m
CONFIG_TOUCHSCREEN_GUNZE=m
# CONFIG_TOUCHSCREEN_ELO is not set
# CONFIG_TOUCHSCREEN_WACOM_W8001 is not set
CONFIG_TOUCHSCREEN_WACOM_I2C=m
CONFIG_TOUCHSCREEN_MAX11801=m
CONFIG_TOUCHSCREEN_MCS5000=m
# CONFIG_TOUCHSCREEN_MMS114 is not set
# CONFIG_TOUCHSCREEN_MTOUCH is not set
# CONFIG_TOUCHSCREEN_INEXIO is not set
CONFIG_TOUCHSCREEN_MK712=m
CONFIG_TOUCHSCREEN_PENMOUNT=m
# CONFIG_TOUCHSCREEN_EDT_FT5X06 is not set
CONFIG_TOUCHSCREEN_TOUCHRIGHT=m
# CONFIG_TOUCHSCREEN_TOUCHWIN is not set
CONFIG_TOUCHSCREEN_TI_AM335X_TSC=m
CONFIG_TOUCHSCREEN_PIXCIR=m
CONFIG_TOUCHSCREEN_USB_COMPOSITE=m
# CONFIG_TOUCHSCREEN_MC13783 is not set
# CONFIG_TOUCHSCREEN_USB_EGALAX is not set
CONFIG_TOUCHSCREEN_USB_PANJIT=y
# CONFIG_TOUCHSCREEN_USB_3M is not set
CONFIG_TOUCHSCREEN_USB_ITM=y
# CONFIG_TOUCHSCREEN_USB_ETURBO is not set
# CONFIG_TOUCHSCREEN_USB_GUNZE is not set
CONFIG_TOUCHSCREEN_USB_DMC_TSC10=y
# CONFIG_TOUCHSCREEN_USB_IRTOUCH is not set
CONFIG_TOUCHSCREEN_USB_IDEALTEK=y
CONFIG_TOUCHSCREEN_USB_GENERAL_TOUCH=y
# CONFIG_TOUCHSCREEN_USB_GOTOP is not set
# CONFIG_TOUCHSCREEN_USB_JASTEC is not set
CONFIG_TOUCHSCREEN_USB_ELO=y
CONFIG_TOUCHSCREEN_USB_E2I=y
CONFIG_TOUCHSCREEN_USB_ZYTRONIC=y
# CONFIG_TOUCHSCREEN_USB_ETT_TC45USB is not set
# CONFIG_TOUCHSCREEN_USB_NEXIO is not set
CONFIG_TOUCHSCREEN_USB_EASYTOUCH=y
CONFIG_TOUCHSCREEN_TOUCHIT213=m
# CONFIG_TOUCHSCREEN_TSC_SERIO is not set
CONFIG_TOUCHSCREEN_TSC2007=m
CONFIG_TOUCHSCREEN_ST1232=m
CONFIG_TOUCHSCREEN_SUR40=m
CONFIG_TOUCHSCREEN_TPS6507X=m
CONFIG_TOUCHSCREEN_ZFORCE=m
CONFIG_INPUT_MISC=y
CONFIG_INPUT_AD714X=m
# CONFIG_INPUT_AD714X_I2C is not set
# CONFIG_INPUT_BMA150 is not set
# CONFIG_INPUT_MC13783_PWRBUTTON is not set
# CONFIG_INPUT_MMA8450 is not set
# CONFIG_INPUT_MPU3050 is not set
CONFIG_INPUT_APANEL=m
# CONFIG_INPUT_GP2A is not set
CONFIG_INPUT_GPIO_BEEPER=m
# CONFIG_INPUT_GPIO_TILT_POLLED is not set
# CONFIG_INPUT_ATLAS_BTNS is not set
CONFIG_INPUT_ATI_REMOTE2=m
CONFIG_INPUT_KEYSPAN_REMOTE=m
CONFIG_INPUT_KXTJ9=m
# CONFIG_INPUT_KXTJ9_POLLED_MODE is not set
# CONFIG_INPUT_POWERMATE is not set
CONFIG_INPUT_YEALINK=m
CONFIG_INPUT_CM109=m
# CONFIG_INPUT_RETU_PWRBUTTON is not set
# CONFIG_INPUT_UINPUT is not set
# CONFIG_INPUT_PCF50633_PMU is not set
CONFIG_INPUT_PCF8574=m
# CONFIG_INPUT_GPIO_ROTARY_ENCODER is not set
# CONFIG_INPUT_ADXL34X is not set
CONFIG_INPUT_IMS_PCU=m
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
CONFIG_SERIO_CT82C710=m
# CONFIG_SERIO_PCIPS2 is not set
CONFIG_SERIO_LIBPS2=y
CONFIG_SERIO_RAW=m
CONFIG_SERIO_ALTERA_PS2=m
CONFIG_SERIO_PS2MULT=m
CONFIG_SERIO_ARC_PS2=m
CONFIG_GAMEPORT=m
# CONFIG_GAMEPORT_NS558 is not set
# CONFIG_GAMEPORT_L4 is not set
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
# CONFIG_SERIAL_SC16IS7XX is not set
# CONFIG_SERIAL_ALTERA_JTAGUART is not set
# CONFIG_SERIAL_ALTERA_UART is not set
# CONFIG_SERIAL_ARC is not set
# CONFIG_SERIAL_RP2 is not set
# CONFIG_SERIAL_FSL_LPUART is not set
# CONFIG_SERIAL_MEN_Z135 is not set
# CONFIG_TTY_PRINTK is not set
# CONFIG_VIRTIO_CONSOLE is not set
CONFIG_IPMI_HANDLER=y
# CONFIG_IPMI_PANIC_EVENT is not set
CONFIG_IPMI_DEVICE_INTERFACE=y
CONFIG_IPMI_SI=m
# CONFIG_IPMI_SI_PROBE_DEFAULTS is not set
CONFIG_IPMI_WATCHDOG=y
CONFIG_IPMI_POWEROFF=m
# CONFIG_HW_RANDOM is not set
CONFIG_NVRAM=y
# CONFIG_R3964 is not set
# CONFIG_APPLICOM is not set
# CONFIG_MWAVE is not set
# CONFIG_HPET is not set
CONFIG_HANGCHECK_TIMER=m
CONFIG_TCG_TPM=m
# CONFIG_TCG_TIS is not set
# CONFIG_TCG_TIS_I2C_ATMEL is not set
CONFIG_TCG_TIS_I2C_INFINEON=m
CONFIG_TCG_TIS_I2C_NUVOTON=m
CONFIG_TCG_NSC=m
CONFIG_TCG_ATMEL=m
# CONFIG_TCG_INFINEON is not set
CONFIG_TCG_ST33_I2C=m
CONFIG_TELCLOCK=m
CONFIG_DEVPORT=y

#
# I2C support
#
CONFIG_I2C=m
CONFIG_I2C_BOARDINFO=y
CONFIG_I2C_COMPAT=y
CONFIG_I2C_CHARDEV=m
CONFIG_I2C_MUX=m

#
# Multiplexer I2C Chip support
#
# CONFIG_I2C_MUX_GPIO is not set
# CONFIG_I2C_MUX_PCA9541 is not set
CONFIG_I2C_MUX_PCA954x=m
CONFIG_I2C_HELPER_AUTO=y
CONFIG_I2C_SMBUS=m
CONFIG_I2C_ALGOBIT=m
CONFIG_I2C_ALGOPCA=m

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
# CONFIG_I2C_CBUS_GPIO is not set
# CONFIG_I2C_DESIGNWARE_PLATFORM is not set
# CONFIG_I2C_DESIGNWARE_PCI is not set
# CONFIG_I2C_GPIO is not set
CONFIG_I2C_KEMPLD=m
CONFIG_I2C_OCORES=m
CONFIG_I2C_PCA_PLATFORM=m
# CONFIG_I2C_PXA_PCI is not set
CONFIG_I2C_SIMTEC=m
# CONFIG_I2C_XILINX is not set

#
# External I2C/SMBus adapter drivers
#
# CONFIG_I2C_DIOLAN_U2C is not set
CONFIG_I2C_PARPORT_LIGHT=m
# CONFIG_I2C_ROBOTFUZZ_OSIF is not set
# CONFIG_I2C_TAOS_EVM is not set
CONFIG_I2C_TINY_USB=m

#
# Other I2C/SMBus bus drivers
#
CONFIG_I2C_STUB=m
# CONFIG_I2C_DEBUG_CORE is not set
# CONFIG_I2C_DEBUG_ALGO is not set
# CONFIG_I2C_DEBUG_BUS is not set
# CONFIG_SPI is not set
CONFIG_SPMI=m
CONFIG_HSI=m
CONFIG_HSI_BOARDINFO=y

#
# HSI controllers
#

#
# HSI clients
#
# CONFIG_HSI_CHAR is not set

#
# PPS support
#
CONFIG_PPS=y
# CONFIG_PPS_DEBUG is not set
# CONFIG_NTP_PPS is not set

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
CONFIG_PTP_1588_CLOCK=y
CONFIG_DP83640_PHY=m
CONFIG_ARCH_WANT_OPTIONAL_GPIOLIB=y
CONFIG_GPIOLIB=y
CONFIG_GPIO_DEVRES=y
CONFIG_GPIO_ACPI=y
CONFIG_DEBUG_GPIO=y
CONFIG_GPIO_SYSFS=y
CONFIG_GPIO_GENERIC=m

#
# Memory mapped GPIO drivers:
#
CONFIG_GPIO_GENERIC_PLATFORM=m
# CONFIG_GPIO_IT8761E is not set
CONFIG_GPIO_F7188X=m
# CONFIG_GPIO_SCH311X is not set
# CONFIG_GPIO_SCH is not set
# CONFIG_GPIO_ICH is not set
# CONFIG_GPIO_VX855 is not set
# CONFIG_GPIO_LYNXPOINT is not set

#
# I2C GPIO expanders:
#
# CONFIG_GPIO_ARIZONA is not set
# CONFIG_GPIO_MAX7300 is not set
CONFIG_GPIO_MAX732X=m
CONFIG_GPIO_PCA953X=m
CONFIG_GPIO_PCF857X=m
# CONFIG_GPIO_ADP5588 is not set

#
# PCI GPIO expanders:
#
# CONFIG_GPIO_BT8XX is not set
# CONFIG_GPIO_AMD8111 is not set
# CONFIG_GPIO_INTEL_MID is not set
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
# CONFIG_GPIO_KEMPLD is not set

#
# MODULbus GPIO expanders:
#

#
# USB GPIO expanders:
#
CONFIG_W1=y
# CONFIG_W1_CON is not set

#
# 1-wire Bus Masters
#
# CONFIG_W1_MASTER_MATROX is not set
CONFIG_W1_MASTER_DS2490=m
CONFIG_W1_MASTER_DS2482=m
# CONFIG_W1_MASTER_DS1WM is not set
CONFIG_W1_MASTER_GPIO=y

#
# 1-wire Slaves
#
CONFIG_W1_SLAVE_THERM=y
# CONFIG_W1_SLAVE_SMEM is not set
CONFIG_W1_SLAVE_DS2408=m
CONFIG_W1_SLAVE_DS2408_READBACK=y
# CONFIG_W1_SLAVE_DS2413 is not set
# CONFIG_W1_SLAVE_DS2406 is not set
# CONFIG_W1_SLAVE_DS2423 is not set
# CONFIG_W1_SLAVE_DS2431 is not set
CONFIG_W1_SLAVE_DS2433=m
CONFIG_W1_SLAVE_DS2433_CRC=y
CONFIG_W1_SLAVE_DS2760=y
CONFIG_W1_SLAVE_DS2780=m
CONFIG_W1_SLAVE_DS2781=y
# CONFIG_W1_SLAVE_DS28E04 is not set
CONFIG_W1_SLAVE_BQ27000=y
CONFIG_POWER_SUPPLY=y
# CONFIG_POWER_SUPPLY_DEBUG is not set
# CONFIG_PDA_POWER is not set
CONFIG_GENERIC_ADC_BATTERY=y
# CONFIG_TEST_POWER is not set
CONFIG_BATTERY_DS2760=m
CONFIG_BATTERY_DS2780=m
CONFIG_BATTERY_DS2781=y
CONFIG_BATTERY_DS2782=m
CONFIG_BATTERY_SBS=m
CONFIG_BATTERY_BQ27x00=m
# CONFIG_BATTERY_BQ27X00_I2C is not set
CONFIG_BATTERY_BQ27X00_PLATFORM=y
CONFIG_BATTERY_MAX17040=m
CONFIG_BATTERY_MAX17042=m
CONFIG_CHARGER_PCF50633=m
CONFIG_CHARGER_ISP1704=y
CONFIG_CHARGER_MAX8903=y
CONFIG_CHARGER_LP8727=m
# CONFIG_CHARGER_GPIO is not set
# CONFIG_CHARGER_BQ2415X is not set
CONFIG_CHARGER_BQ24190=m
CONFIG_CHARGER_BQ24735=m
CONFIG_CHARGER_SMB347=m
# CONFIG_POWER_RESET is not set
CONFIG_POWER_AVS=y
CONFIG_HWMON=m
CONFIG_HWMON_VID=m
# CONFIG_HWMON_DEBUG_CHIP is not set

#
# Native drivers
#
CONFIG_SENSORS_ABITUGURU=m
CONFIG_SENSORS_ABITUGURU3=m
CONFIG_SENSORS_AD7414=m
# CONFIG_SENSORS_AD7418 is not set
CONFIG_SENSORS_ADM1021=m
CONFIG_SENSORS_ADM1025=m
# CONFIG_SENSORS_ADM1026 is not set
# CONFIG_SENSORS_ADM1029 is not set
CONFIG_SENSORS_ADM1031=m
# CONFIG_SENSORS_ADM9240 is not set
# CONFIG_SENSORS_ADT7410 is not set
# CONFIG_SENSORS_ADT7411 is not set
# CONFIG_SENSORS_ADT7462 is not set
# CONFIG_SENSORS_ADT7470 is not set
CONFIG_SENSORS_ADT7475=m
CONFIG_SENSORS_ASC7621=m
# CONFIG_SENSORS_K8TEMP is not set
# CONFIG_SENSORS_K10TEMP is not set
# CONFIG_SENSORS_FAM15H_POWER is not set
# CONFIG_SENSORS_APPLESMC is not set
CONFIG_SENSORS_ASB100=m
# CONFIG_SENSORS_ATXP1 is not set
CONFIG_SENSORS_DS620=m
CONFIG_SENSORS_DS1621=m
# CONFIG_SENSORS_I5K_AMB is not set
# CONFIG_SENSORS_F71805F is not set
CONFIG_SENSORS_F71882FG=m
# CONFIG_SENSORS_F75375S is not set
CONFIG_SENSORS_MC13783_ADC=m
CONFIG_SENSORS_FSCHMD=m
# CONFIG_SENSORS_GL518SM is not set
CONFIG_SENSORS_GL520SM=m
CONFIG_SENSORS_G760A=m
CONFIG_SENSORS_G762=m
CONFIG_SENSORS_GPIO_FAN=m
CONFIG_SENSORS_HIH6130=m
CONFIG_SENSORS_IBMAEM=m
# CONFIG_SENSORS_IBMPEX is not set
# CONFIG_SENSORS_IIO_HWMON is not set
CONFIG_SENSORS_CORETEMP=m
CONFIG_SENSORS_IT87=m
CONFIG_SENSORS_JC42=m
CONFIG_SENSORS_POWR1220=m
CONFIG_SENSORS_LINEAGE=m
# CONFIG_SENSORS_LTC2945 is not set
CONFIG_SENSORS_LTC4151=m
# CONFIG_SENSORS_LTC4215 is not set
CONFIG_SENSORS_LTC4222=m
CONFIG_SENSORS_LTC4245=m
CONFIG_SENSORS_LTC4260=m
CONFIG_SENSORS_LTC4261=m
CONFIG_SENSORS_MAX16065=m
CONFIG_SENSORS_MAX1619=m
CONFIG_SENSORS_MAX1668=m
# CONFIG_SENSORS_MAX197 is not set
CONFIG_SENSORS_MAX6639=m
CONFIG_SENSORS_MAX6642=m
CONFIG_SENSORS_MAX6650=m
# CONFIG_SENSORS_MAX6697 is not set
CONFIG_SENSORS_HTU21=m
# CONFIG_SENSORS_MCP3021 is not set
CONFIG_SENSORS_LM63=m
CONFIG_SENSORS_LM73=m
# CONFIG_SENSORS_LM75 is not set
# CONFIG_SENSORS_LM77 is not set
CONFIG_SENSORS_LM78=m
# CONFIG_SENSORS_LM80 is not set
CONFIG_SENSORS_LM83=m
CONFIG_SENSORS_LM85=m
# CONFIG_SENSORS_LM87 is not set
# CONFIG_SENSORS_LM90 is not set
CONFIG_SENSORS_LM92=m
# CONFIG_SENSORS_LM93 is not set
# CONFIG_SENSORS_LM95234 is not set
CONFIG_SENSORS_LM95241=m
CONFIG_SENSORS_LM95245=m
# CONFIG_SENSORS_PC87360 is not set
CONFIG_SENSORS_PC87427=m
CONFIG_SENSORS_NTC_THERMISTOR=m
# CONFIG_SENSORS_NCT6683 is not set
CONFIG_SENSORS_NCT6775=m
CONFIG_SENSORS_PCF8591=m
# CONFIG_PMBUS is not set
CONFIG_SENSORS_SHT15=m
CONFIG_SENSORS_SHT21=m
# CONFIG_SENSORS_SHTC1 is not set
# CONFIG_SENSORS_SIS5595 is not set
CONFIG_SENSORS_DME1737=m
CONFIG_SENSORS_EMC1403=m
CONFIG_SENSORS_EMC2103=m
# CONFIG_SENSORS_EMC6W201 is not set
CONFIG_SENSORS_SMSC47M1=m
CONFIG_SENSORS_SMSC47M192=m
CONFIG_SENSORS_SMSC47B397=m
CONFIG_SENSORS_SCH56XX_COMMON=m
CONFIG_SENSORS_SCH5627=m
CONFIG_SENSORS_SCH5636=m
# CONFIG_SENSORS_SMM665 is not set
CONFIG_SENSORS_ADC128D818=m
CONFIG_SENSORS_ADS1015=m
# CONFIG_SENSORS_ADS7828 is not set
CONFIG_SENSORS_AMC6821=m
CONFIG_SENSORS_INA209=m
CONFIG_SENSORS_INA2XX=m
CONFIG_SENSORS_THMC50=m
# CONFIG_SENSORS_TMP102 is not set
CONFIG_SENSORS_TMP103=m
CONFIG_SENSORS_TMP401=m
CONFIG_SENSORS_TMP421=m
# CONFIG_SENSORS_VIA_CPUTEMP is not set
# CONFIG_SENSORS_VIA686A is not set
# CONFIG_SENSORS_VT1211 is not set
# CONFIG_SENSORS_VT8231 is not set
CONFIG_SENSORS_W83781D=m
CONFIG_SENSORS_W83791D=m
CONFIG_SENSORS_W83792D=m
# CONFIG_SENSORS_W83793 is not set
# CONFIG_SENSORS_W83795 is not set
CONFIG_SENSORS_W83L785TS=m
# CONFIG_SENSORS_W83L786NG is not set
# CONFIG_SENSORS_W83627HF is not set
# CONFIG_SENSORS_W83627EHF is not set

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
CONFIG_THERMAL_GOV_STEP_WISE=y
CONFIG_THERMAL_GOV_USER_SPACE=y
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
# CONFIG_SOFT_WATCHDOG is not set
CONFIG_XILINX_WATCHDOG=m
CONFIG_DW_WATCHDOG=m
CONFIG_RETU_WATCHDOG=m
CONFIG_ACQUIRE_WDT=y
# CONFIG_ADVANTECH_WDT is not set
# CONFIG_ALIM1535_WDT is not set
# CONFIG_ALIM7101_WDT is not set
# CONFIG_F71808E_WDT is not set
# CONFIG_SP5100_TCO is not set
CONFIG_SBC_FITPC2_WATCHDOG=y
# CONFIG_EUROTECH_WDT is not set
CONFIG_IB700_WDT=m
CONFIG_IBMASR=y
# CONFIG_WAFER_WDT is not set
# CONFIG_I6300ESB_WDT is not set
# CONFIG_IE6XX_WDT is not set
# CONFIG_ITCO_WDT is not set
CONFIG_IT8712F_WDT=y
CONFIG_IT87_WDT=y
# CONFIG_HP_WATCHDOG is not set
# CONFIG_KEMPLD_WDT is not set
# CONFIG_SC1200_WDT is not set
CONFIG_PC87413_WDT=m
# CONFIG_NV_TCO is not set
CONFIG_60XX_WDT=m
CONFIG_CPU5_WDT=y
CONFIG_SMSC_SCH311X_WDT=y
CONFIG_SMSC37B787_WDT=m
# CONFIG_VIA_WDT is not set
CONFIG_W83627HF_WDT=m
CONFIG_W83877F_WDT=y
CONFIG_W83977F_WDT=y
# CONFIG_MACHZ_WDT is not set
CONFIG_SBC_EPX_C3_WATCHDOG=y
CONFIG_MEN_A21_WDT=y

#
# PCI-based Watchdog Cards
#
# CONFIG_PCIPCWATCHDOG is not set
# CONFIG_WDTPCI is not set

#
# USB-based Watchdog Cards
#
CONFIG_USBPCWATCHDOG=m
CONFIG_SSB_POSSIBLE=y

#
# Sonics Silicon Backplane
#
CONFIG_SSB=m
CONFIG_SSB_SPROM=y
CONFIG_SSB_PCIHOST_POSSIBLE=y
CONFIG_SSB_PCIHOST=y
# CONFIG_SSB_B43_PCI_BRIDGE is not set
CONFIG_SSB_SILENT=y
CONFIG_SSB_DRIVER_PCICORE_POSSIBLE=y
# CONFIG_SSB_DRIVER_PCICORE is not set
# CONFIG_SSB_DRIVER_GPIO is not set
CONFIG_BCMA_POSSIBLE=y

#
# Broadcom specific AMBA
#
CONFIG_BCMA=m
CONFIG_BCMA_HOST_PCI_POSSIBLE=y
CONFIG_BCMA_HOST_PCI=y
# CONFIG_BCMA_HOST_SOC is not set
# CONFIG_BCMA_DRIVER_GMAC_CMN is not set
CONFIG_BCMA_DRIVER_GPIO=y
# CONFIG_BCMA_DEBUG is not set

#
# Multifunction device drivers
#
CONFIG_MFD_CORE=y
CONFIG_MFD_BCM590XX=m
# CONFIG_MFD_CROS_EC is not set
CONFIG_MFD_MC13XXX=m
CONFIG_MFD_MC13XXX_I2C=m
CONFIG_HTC_PASIC3=m
# CONFIG_LPC_ICH is not set
# CONFIG_LPC_SCH is not set
# CONFIG_MFD_JANZ_CMODIO is not set
CONFIG_MFD_KEMPLD=m
# CONFIG_MFD_VIPERBOARD is not set
CONFIG_MFD_RETU=m
CONFIG_MFD_PCF50633=m
CONFIG_PCF50633_ADC=m
CONFIG_PCF50633_GPIO=m
# CONFIG_MFD_RDC321X is not set
# CONFIG_MFD_RTSX_PCI is not set
# CONFIG_MFD_RTSX_USB is not set
# CONFIG_MFD_SI476X_CORE is not set
CONFIG_MFD_SM501=m
# CONFIG_MFD_SM501_GPIO is not set
CONFIG_ABX500_CORE=y
CONFIG_MFD_SYSCON=y
CONFIG_MFD_TI_AM335X_TSCADC=y
# CONFIG_MFD_LP3943 is not set
CONFIG_TPS6105X=m
# CONFIG_TPS65010 is not set
CONFIG_TPS6507X=m
CONFIG_MFD_TPS65217=m
CONFIG_MFD_TPS65218=m
CONFIG_MFD_TPS65912=y
CONFIG_MFD_WL1273_CORE=m
CONFIG_MFD_LM3533=m
# CONFIG_MFD_TMIO is not set
# CONFIG_MFD_VX855 is not set
CONFIG_MFD_ARIZONA=y
CONFIG_MFD_ARIZONA_I2C=m
CONFIG_MFD_WM5102=y
# CONFIG_MFD_WM5110 is not set
# CONFIG_MFD_WM8997 is not set
CONFIG_REGULATOR=y
# CONFIG_REGULATOR_DEBUG is not set
CONFIG_REGULATOR_FIXED_VOLTAGE=y
CONFIG_REGULATOR_VIRTUAL_CONSUMER=m
CONFIG_REGULATOR_USERSPACE_CONSUMER=m
CONFIG_REGULATOR_ACT8865=m
CONFIG_REGULATOR_AD5398=m
CONFIG_REGULATOR_ANATOP=m
CONFIG_REGULATOR_BCM590XX=m
CONFIG_REGULATOR_DA9210=m
CONFIG_REGULATOR_DA9211=m
CONFIG_REGULATOR_FAN53555=m
CONFIG_REGULATOR_GPIO=y
# CONFIG_REGULATOR_ISL6271A is not set
CONFIG_REGULATOR_LP3971=m
# CONFIG_REGULATOR_LP3972 is not set
CONFIG_REGULATOR_LP872X=m
CONFIG_REGULATOR_LP8755=m
CONFIG_REGULATOR_LTC3589=m
# CONFIG_REGULATOR_MAX1586 is not set
# CONFIG_REGULATOR_MAX8649 is not set
CONFIG_REGULATOR_MAX8660=m
CONFIG_REGULATOR_MAX8952=m
CONFIG_REGULATOR_MAX8973=m
CONFIG_REGULATOR_MC13XXX_CORE=m
# CONFIG_REGULATOR_MC13783 is not set
CONFIG_REGULATOR_MC13892=m
CONFIG_REGULATOR_PCF50633=m
CONFIG_REGULATOR_PFUZE100=m
# CONFIG_REGULATOR_TPS51632 is not set
CONFIG_REGULATOR_TPS6105X=m
CONFIG_REGULATOR_TPS62360=m
CONFIG_REGULATOR_TPS65023=m
CONFIG_REGULATOR_TPS6507X=m
# CONFIG_REGULATOR_TPS65217 is not set
# CONFIG_MEDIA_SUPPORT is not set

#
# Graphics support
#
# CONFIG_AGP is not set
CONFIG_VGA_ARB=y
CONFIG_VGA_ARB_MAX_GPUS=16
# CONFIG_VGA_SWITCHEROO is not set

#
# Direct Rendering Manager
#
CONFIG_DRM=m
CONFIG_DRM_USB=m
CONFIG_DRM_KMS_HELPER=m
CONFIG_DRM_KMS_FB_HELPER=y
# CONFIG_DRM_LOAD_EDID_FIRMWARE is not set

#
# I2C encoder or helper chips
#
# CONFIG_DRM_I2C_CH7006 is not set
# CONFIG_DRM_I2C_SIL164 is not set
CONFIG_DRM_I2C_NXP_TDA998X=m
CONFIG_DRM_PTN3460=m
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
CONFIG_DRM_UDL=m
# CONFIG_DRM_AST is not set
# CONFIG_DRM_MGAG200 is not set
# CONFIG_DRM_CIRRUS_QEMU is not set
# CONFIG_DRM_QXL is not set
# CONFIG_DRM_BOCHS is not set

#
# Frame buffer Devices
#
CONFIG_FB=y
CONFIG_FIRMWARE_EDID=y
# CONFIG_FB_DDC is not set
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
CONFIG_FB_ARC=y
# CONFIG_FB_ASILIANT is not set
# CONFIG_FB_IMSTT is not set
# CONFIG_FB_VGA16 is not set
CONFIG_FB_UVESA=m
CONFIG_FB_VESA=y
CONFIG_FB_N411=y
CONFIG_FB_HGA=m
CONFIG_FB_OPENCORES=m
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
CONFIG_FB_SM501=m
# CONFIG_FB_SMSCUFX is not set
CONFIG_FB_UDL=m
CONFIG_FB_VIRTUAL=m
CONFIG_FB_METRONOME=y
# CONFIG_FB_MB862XX is not set
# CONFIG_FB_BROADSHEET is not set
# CONFIG_FB_AUO_K190X is not set
CONFIG_FB_SIMPLE=y
CONFIG_BACKLIGHT_LCD_SUPPORT=y
CONFIG_LCD_CLASS_DEVICE=y
# CONFIG_LCD_PLATFORM is not set
# CONFIG_BACKLIGHT_CLASS_DEVICE is not set
# CONFIG_VGASTATE is not set
CONFIG_HDMI=y
CONFIG_LOGO=y
CONFIG_LOGO_LINUX_MONO=y
# CONFIG_LOGO_LINUX_VGA16 is not set
# CONFIG_LOGO_LINUX_CLUT224 is not set
# CONFIG_SOUND is not set

#
# HID support
#
CONFIG_HID=m
# CONFIG_HIDRAW is not set
# CONFIG_UHID is not set
CONFIG_HID_GENERIC=m

#
# Special HID drivers
#
CONFIG_HID_A4TECH=m
# CONFIG_HID_ACRUX is not set
# CONFIG_HID_APPLE is not set
CONFIG_HID_APPLEIR=m
CONFIG_HID_AUREAL=m
CONFIG_HID_BELKIN=m
# CONFIG_HID_CHERRY is not set
# CONFIG_HID_CHICONY is not set
CONFIG_HID_CP2112=m
# CONFIG_HID_CYPRESS is not set
CONFIG_HID_DRAGONRISE=m
# CONFIG_DRAGONRISE_FF is not set
CONFIG_HID_EMS_FF=m
CONFIG_HID_ELECOM=m
# CONFIG_HID_ELO is not set
CONFIG_HID_EZKEY=m
CONFIG_HID_HOLTEK=m
CONFIG_HOLTEK_FF=y
CONFIG_HID_GT683R=m
CONFIG_HID_HUION=m
# CONFIG_HID_KEYTOUCH is not set
CONFIG_HID_KYE=m
CONFIG_HID_UCLOGIC=m
CONFIG_HID_WALTOP=m
CONFIG_HID_GYRATION=m
# CONFIG_HID_ICADE is not set
CONFIG_HID_TWINHAN=m
CONFIG_HID_KENSINGTON=m
CONFIG_HID_LCPOWER=m
# CONFIG_HID_LENOVO is not set
CONFIG_HID_LOGITECH=m
# CONFIG_LOGITECH_FF is not set
# CONFIG_LOGIRUMBLEPAD2_FF is not set
CONFIG_LOGIG940_FF=y
# CONFIG_LOGIWHEELS_FF is not set
CONFIG_HID_MAGICMOUSE=m
# CONFIG_HID_MICROSOFT is not set
CONFIG_HID_MONTEREY=m
CONFIG_HID_MULTITOUCH=m
# CONFIG_HID_NTRIG is not set
CONFIG_HID_ORTEK=m
CONFIG_HID_PANTHERLORD=m
CONFIG_PANTHERLORD_FF=y
CONFIG_HID_PETALYNX=m
# CONFIG_HID_PICOLCD is not set
# CONFIG_HID_PRIMAX is not set
CONFIG_HID_ROCCAT=m
# CONFIG_HID_SAITEK is not set
CONFIG_HID_SAMSUNG=m
CONFIG_HID_SONY=m
# CONFIG_SONY_FF is not set
# CONFIG_HID_SPEEDLINK is not set
CONFIG_HID_STEELSERIES=m
# CONFIG_HID_SUNPLUS is not set
# CONFIG_HID_RMI is not set
CONFIG_HID_GREENASIA=m
CONFIG_GREENASIA_FF=y
CONFIG_HID_SMARTJOYPLUS=m
# CONFIG_SMARTJOYPLUS_FF is not set
# CONFIG_HID_TIVO is not set
# CONFIG_HID_TOPSEED is not set
# CONFIG_HID_THINGM is not set
# CONFIG_HID_THRUSTMASTER is not set
CONFIG_HID_WACOM=m
CONFIG_HID_WIIMOTE=m
CONFIG_HID_XINMO=m
# CONFIG_HID_ZEROPLUS is not set
# CONFIG_HID_ZYDACRON is not set
CONFIG_HID_SENSOR_HUB=m

#
# USB HID support
#
CONFIG_USB_HID=m
# CONFIG_HID_PID is not set
CONFIG_USB_HIDDEV=y

#
# USB HID Boot Protocol drivers
#
# CONFIG_USB_KBD is not set
# CONFIG_USB_MOUSE is not set

#
# I2C HID support
#
CONFIG_I2C_HID=m
CONFIG_USB_OHCI_LITTLE_ENDIAN=y
CONFIG_USB_SUPPORT=y
CONFIG_USB_COMMON=m
CONFIG_USB_ARCH_HAS_HCD=y
CONFIG_USB=m
# CONFIG_USB_ANNOUNCE_NEW_DEVICES is not set

#
# Miscellaneous USB options
#
# CONFIG_USB_DEFAULT_PERSIST is not set
# CONFIG_USB_DYNAMIC_MINORS is not set
# CONFIG_USB_OTG is not set
# CONFIG_USB_OTG_WHITELIST is not set
# CONFIG_USB_OTG_BLACKLIST_HUB is not set
# CONFIG_USB_OTG_FSM is not set
CONFIG_USB_MON=m
# CONFIG_USB_WUSB_CBAF is not set

#
# USB Host Controller Drivers
#
CONFIG_USB_C67X00_HCD=m
CONFIG_USB_XHCI_HCD=m
CONFIG_USB_XHCI_PLATFORM=m
CONFIG_USB_EHCI_HCD=m
# CONFIG_USB_EHCI_ROOT_HUB_TT is not set
CONFIG_USB_EHCI_TT_NEWSCHED=y
CONFIG_USB_EHCI_PCI=m
CONFIG_USB_EHCI_HCD_PLATFORM=m
# CONFIG_USB_OXU210HP_HCD is not set
CONFIG_USB_ISP116X_HCD=m
CONFIG_USB_ISP1760_HCD=m
# CONFIG_USB_ISP1362_HCD is not set
# CONFIG_USB_FUSBH200_HCD is not set
CONFIG_USB_FOTG210_HCD=m
# CONFIG_USB_OHCI_HCD is not set
# CONFIG_USB_UHCI_HCD is not set
# CONFIG_USB_SL811_HCD is not set
# CONFIG_USB_R8A66597_HCD is not set
# CONFIG_USB_HCD_BCMA is not set
CONFIG_USB_HCD_SSB=m
CONFIG_USB_HCD_TEST_MODE=y

#
# USB Device Class drivers
#
# CONFIG_USB_ACM is not set
CONFIG_USB_PRINTER=m
CONFIG_USB_WDM=m
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
# CONFIG_USB_MUSB_HDRC is not set
CONFIG_USB_DWC3=m
CONFIG_USB_DWC3_HOST=y

#
# Platform Glue Driver Support
#
CONFIG_USB_DWC3_PCI=m

#
# Debugging features
#
# CONFIG_USB_DWC3_DEBUG is not set
CONFIG_DWC3_HOST_USB3_LPM_ENABLE=y
CONFIG_USB_DWC2=y
CONFIG_USB_DWC2_HOST=m
# CONFIG_USB_DWC2_PLATFORM is not set
CONFIG_USB_DWC2_PCI=y

#
# Gadget mode requires USB Gadget support to be enabled
#
CONFIG_USB_DWC2_DEBUG=y
# CONFIG_USB_DWC2_VERBOSE is not set
CONFIG_USB_DWC2_TRACK_MISSED_SOFS=y
CONFIG_USB_DWC2_DEBUG_PERIODIC=y
# CONFIG_USB_CHIPIDEA is not set

#
# USB port drivers
#
# CONFIG_USB_SERIAL is not set

#
# USB Miscellaneous drivers
#
CONFIG_USB_EMI62=m
CONFIG_USB_EMI26=m
CONFIG_USB_ADUTUX=m
# CONFIG_USB_SEVSEG is not set
CONFIG_USB_RIO500=m
CONFIG_USB_LEGOTOWER=m
CONFIG_USB_LCD=m
CONFIG_USB_LED=m
CONFIG_USB_CYPRESS_CY7C63=m
CONFIG_USB_CYTHERM=m
CONFIG_USB_IDMOUSE=m
# CONFIG_USB_FTDI_ELAN is not set
# CONFIG_USB_APPLEDISPLAY is not set
CONFIG_USB_SISUSBVGA=m
CONFIG_USB_LD=m
CONFIG_USB_TRANCEVIBRATOR=m
# CONFIG_USB_IOWARRIOR is not set
# CONFIG_USB_TEST is not set
CONFIG_USB_EHSET_TEST_FIXTURE=m
CONFIG_USB_ISIGHTFW=m
CONFIG_USB_YUREX=m
CONFIG_USB_EZUSB_FX2=m
CONFIG_USB_HSIC_USB3503=m
CONFIG_USB_LINK_LAYER_TEST=m

#
# USB Physical Layer drivers
#
CONFIG_USB_PHY=y
CONFIG_NOP_USB_XCEIV=y
CONFIG_SAMSUNG_USBPHY=m
# CONFIG_SAMSUNG_USB2PHY is not set
CONFIG_SAMSUNG_USB3PHY=m
CONFIG_USB_GPIO_VBUS=m
CONFIG_TAHVO_USB=m
# CONFIG_TAHVO_USB_HOST_BY_DEFAULT is not set
CONFIG_USB_ISP1301=m
# CONFIG_USB_GADGET is not set
# CONFIG_UWB is not set
# CONFIG_MMC is not set
CONFIG_MEMSTICK=m
# CONFIG_MEMSTICK_DEBUG is not set

#
# MemoryStick drivers
#
# CONFIG_MEMSTICK_UNSAFE_RESUME is not set

#
# MemoryStick Host Controller Drivers
#
# CONFIG_MEMSTICK_TIFM_MS is not set
# CONFIG_MEMSTICK_JMICRON_38X is not set
# CONFIG_MEMSTICK_R592 is not set
CONFIG_NEW_LEDS=y
CONFIG_LEDS_CLASS=y

#
# LED drivers
#
CONFIG_LEDS_LM3530=m
# CONFIG_LEDS_LM3533 is not set
CONFIG_LEDS_LM3642=m
CONFIG_LEDS_PCA9532=m
# CONFIG_LEDS_PCA9532_GPIO is not set
# CONFIG_LEDS_GPIO is not set
CONFIG_LEDS_LP3944=m
CONFIG_LEDS_LP55XX_COMMON=m
# CONFIG_LEDS_LP5521 is not set
# CONFIG_LEDS_LP5523 is not set
CONFIG_LEDS_LP5562=m
# CONFIG_LEDS_LP8501 is not set
CONFIG_LEDS_CLEVO_MAIL=m
CONFIG_LEDS_PCA955X=m
CONFIG_LEDS_PCA963X=m
CONFIG_LEDS_REGULATOR=m
CONFIG_LEDS_BD2802=m
# CONFIG_LEDS_INTEL_SS4200 is not set
CONFIG_LEDS_LT3593=m
CONFIG_LEDS_MC13783=m
# CONFIG_LEDS_TCA6507 is not set
CONFIG_LEDS_LM355x=m

#
# LED driver for blink(1) USB RGB LED is under Special HID drivers (HID_THINGM)
#
CONFIG_LEDS_BLINKM=m

#
# LED Triggers
#
CONFIG_LEDS_TRIGGERS=y
CONFIG_LEDS_TRIGGER_TIMER=m
# CONFIG_LEDS_TRIGGER_ONESHOT is not set
# CONFIG_LEDS_TRIGGER_HEARTBEAT is not set
# CONFIG_LEDS_TRIGGER_BACKLIGHT is not set
# CONFIG_LEDS_TRIGGER_CPU is not set
CONFIG_LEDS_TRIGGER_GPIO=y
CONFIG_LEDS_TRIGGER_DEFAULT_ON=y

#
# iptables trigger is under Netfilter config (LED target)
#
CONFIG_LEDS_TRIGGER_TRANSIENT=m
CONFIG_LEDS_TRIGGER_CAMERA=y
CONFIG_ACCESSIBILITY=y
# CONFIG_INFINIBAND is not set
# CONFIG_EDAC is not set
CONFIG_RTC_LIB=y
# CONFIG_RTC_CLASS is not set
CONFIG_DMADEVICES=y
# CONFIG_DMADEVICES_DEBUG is not set

#
# DMA Devices
#
# CONFIG_INTEL_MID_DMAC is not set
# CONFIG_INTEL_IOATDMA is not set
CONFIG_DW_DMAC_CORE=m
CONFIG_DW_DMAC=m
# CONFIG_DW_DMAC_PCI is not set
CONFIG_DMA_ENGINE=y
CONFIG_DMA_ACPI=y

#
# DMA Clients
#
# CONFIG_ASYNC_TX_DMA is not set
# CONFIG_DMATEST is not set
# CONFIG_AUXDISPLAY is not set
CONFIG_UIO=y
# CONFIG_UIO_CIF is not set
CONFIG_UIO_PDRV_GENIRQ=m
# CONFIG_UIO_DMEM_GENIRQ is not set
# CONFIG_UIO_AEC is not set
# CONFIG_UIO_SERCOS3 is not set
# CONFIG_UIO_PCI_GENERIC is not set
# CONFIG_UIO_NETX is not set
# CONFIG_UIO_MF624 is not set
# CONFIG_VIRT_DRIVERS is not set
CONFIG_VIRTIO=m

#
# Virtio drivers
#
# CONFIG_VIRTIO_PCI is not set
CONFIG_VIRTIO_BALLOON=m
CONFIG_VIRTIO_MMIO=m
# CONFIG_VIRTIO_MMIO_CMDLINE_DEVICES is not set

#
# Microsoft Hyper-V guest support
#
# CONFIG_HYPERV is not set
# CONFIG_STAGING is not set
# CONFIG_X86_PLATFORM_DEVICES is not set
# CONFIG_CHROME_PLATFORMS is not set

#
# SOC (System On Chip) specific Drivers
#

#
# Hardware Spinlock drivers
#

#
# Clock Source drivers
#
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
CONFIG_REMOTEPROC=m
CONFIG_STE_MODEM_RPROC=m

#
# Rpmsg drivers
#
CONFIG_PM_DEVFREQ=y

#
# DEVFREQ Governors
#
CONFIG_DEVFREQ_GOV_SIMPLE_ONDEMAND=y
CONFIG_DEVFREQ_GOV_PERFORMANCE=y
# CONFIG_DEVFREQ_GOV_POWERSAVE is not set
# CONFIG_DEVFREQ_GOV_USERSPACE is not set

#
# DEVFREQ Drivers
#
CONFIG_EXTCON=m

#
# Extcon Device Drivers
#
CONFIG_EXTCON_ADC_JACK=m
CONFIG_EXTCON_GPIO=m
CONFIG_EXTCON_SM5502=m
CONFIG_MEMORY=y
CONFIG_IIO=y
CONFIG_IIO_BUFFER=y
# CONFIG_IIO_BUFFER_CB is not set
CONFIG_IIO_KFIFO_BUF=y
CONFIG_IIO_TRIGGERED_BUFFER=m
CONFIG_IIO_TRIGGER=y
CONFIG_IIO_CONSUMERS_PER_TRIGGER=2

#
# Accelerometers
#
CONFIG_BMA180=m
CONFIG_HID_SENSOR_ACCEL_3D=m
CONFIG_IIO_ST_ACCEL_3AXIS=m
CONFIG_IIO_ST_ACCEL_I2C_3AXIS=m
# CONFIG_MMA8452 is not set
CONFIG_KXCJK1013=m

#
# Analog to digital converters
#
CONFIG_AD7291=m
CONFIG_AD799X=m
CONFIG_MAX1363=m
CONFIG_MCP3422=m
CONFIG_MEN_Z188_ADC=m
CONFIG_NAU7802=m
CONFIG_TI_ADC081C=m
# CONFIG_TI_AM335X_ADC is not set

#
# Amplifiers
#

#
# Hid Sensor IIO Common
#
CONFIG_HID_SENSOR_IIO_COMMON=m
CONFIG_HID_SENSOR_IIO_TRIGGER=m
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
CONFIG_HID_SENSOR_GYRO_3D=m
CONFIG_IIO_ST_GYRO_3AXIS=m
CONFIG_IIO_ST_GYRO_I2C_3AXIS=m
CONFIG_ITG3200=m

#
# Humidity sensors
#
CONFIG_DHT11=m
# CONFIG_SI7005 is not set

#
# Inertial measurement units
#
# CONFIG_INV_MPU6050_IIO is not set

#
# Light sensors
#
# CONFIG_ADJD_S311 is not set
CONFIG_APDS9300=m
CONFIG_CM32181=m
CONFIG_CM36651=m
# CONFIG_GP2AP020A00F is not set
CONFIG_ISL29125=m
CONFIG_HID_SENSOR_ALS=m
CONFIG_HID_SENSOR_PROX=m
CONFIG_SENSORS_LM3533=m
CONFIG_LTR501=m
CONFIG_TCS3414=m
CONFIG_TCS3472=m
# CONFIG_SENSORS_TSL2563 is not set
CONFIG_TSL4531=m
CONFIG_VCNL4000=m

#
# Magnetometer sensors
#
# CONFIG_AK8975 is not set
CONFIG_AK09911=m
# CONFIG_MAG3110 is not set
CONFIG_HID_SENSOR_MAGNETOMETER_3D=m
CONFIG_IIO_ST_MAGN_3AXIS=m
CONFIG_IIO_ST_MAGN_I2C_3AXIS=m

#
# Inclinometer sensors
#
# CONFIG_HID_SENSOR_INCLINOMETER_3D is not set
# CONFIG_HID_SENSOR_DEVICE_ROTATION is not set

#
# Triggers - standalone
#
CONFIG_IIO_INTERRUPT_TRIGGER=m
# CONFIG_IIO_SYSFS_TRIGGER is not set

#
# Pressure sensors
#
CONFIG_HID_SENSOR_PRESS=m
CONFIG_MPL115=m
# CONFIG_MPL3115 is not set
CONFIG_IIO_ST_PRESS=m
CONFIG_IIO_ST_PRESS_I2C=m
CONFIG_T5403=m

#
# Lightning sensors
#

#
# Temperature sensors
#
CONFIG_MLX90614=m
# CONFIG_TMP006 is not set
# CONFIG_NTB is not set
# CONFIG_VME_BUS is not set
# CONFIG_PWM is not set
# CONFIG_IPACK_BUS is not set
CONFIG_RESET_CONTROLLER=y
CONFIG_FMC=y
# CONFIG_FMC_FAKEDEV is not set
CONFIG_FMC_TRIVIAL=m
CONFIG_FMC_WRITE_EEPROM=m
# CONFIG_FMC_CHARDEV is not set

#
# PHY Subsystem
#
CONFIG_GENERIC_PHY=y
# CONFIG_BCM_KONA_USB2_PHY is not set
CONFIG_PHY_SAMSUNG_USB2=m
# CONFIG_PHY_EXYNOS4210_USB2 is not set
# CONFIG_PHY_EXYNOS4X12_USB2 is not set
# CONFIG_PHY_EXYNOS5250_USB2 is not set
# CONFIG_PHY_ST_SPEAR1310_MIPHY is not set
# CONFIG_PHY_ST_SPEAR1340_MIPHY is not set
CONFIG_POWERCAP=y
# CONFIG_INTEL_RAPL is not set
CONFIG_MCB=m
# CONFIG_MCB_PCI is not set
# CONFIG_THUNDERBOLT is not set

#
# Firmware Drivers
#
CONFIG_EDD=m
# CONFIG_EDD_OFF is not set
CONFIG_FIRMWARE_MEMMAP=y
CONFIG_DELL_RBU=m
CONFIG_DCDBAS=y
CONFIG_DMIID=y
CONFIG_DMI_SYSFS=y
CONFIG_DMI_SCAN_MACHINE_NON_EFI_FALLBACK=y
# CONFIG_ISCSI_IBFT_FIND is not set
CONFIG_GOOGLE_FIRMWARE=y

#
# Google Firmware Drivers
#
CONFIG_GOOGLE_MEMCONSOLE=m

#
# File systems
#
CONFIG_DCACHE_WORD_ACCESS=y
CONFIG_FS_POSIX_ACL=y
# CONFIG_FILE_LOCKING is not set
CONFIG_FSNOTIFY=y
CONFIG_DNOTIFY=y
CONFIG_INOTIFY_USER=y
CONFIG_FANOTIFY=y
CONFIG_FANOTIFY_ACCESS_PERMISSIONS=y
# CONFIG_QUOTA is not set
# CONFIG_QUOTACTL is not set
CONFIG_AUTOFS4_FS=m
CONFIG_FUSE_FS=y
CONFIG_CUSE=m

#
# Caches
#
CONFIG_FSCACHE=y
CONFIG_FSCACHE_STATS=y
# CONFIG_FSCACHE_HISTOGRAM is not set
CONFIG_FSCACHE_DEBUG=y
CONFIG_FSCACHE_OBJECT_LIST=y

#
# Pseudo filesystems
#
CONFIG_PROC_FS=y
# CONFIG_PROC_KCORE is not set
# CONFIG_PROC_SYSCTL is not set
# CONFIG_PROC_PAGE_MONITOR is not set
CONFIG_KERNFS=y
CONFIG_SYSFS=y
# CONFIG_TMPFS is not set
CONFIG_HUGETLBFS=y
CONFIG_HUGETLB_PAGE=y
CONFIG_CONFIGFS_FS=y
CONFIG_MISC_FILESYSTEMS=y
# CONFIG_ECRYPT_FS is not set
# CONFIG_JFFS2_FS is not set
CONFIG_UBIFS_FS=m
# CONFIG_UBIFS_FS_ADVANCED_COMPR is not set
CONFIG_UBIFS_FS_LZO=y
CONFIG_UBIFS_FS_ZLIB=y
# CONFIG_LOGFS is not set
# CONFIG_ROMFS_FS is not set
# CONFIG_PSTORE is not set
CONFIG_NETWORK_FILESYSTEMS=y
CONFIG_CEPH_FS=y
CONFIG_CEPH_FSCACHE=y
CONFIG_CEPH_FS_POSIX_ACL=y
CONFIG_CIFS=y
# CONFIG_CIFS_STATS is not set
CONFIG_CIFS_WEAK_PW_HASH=y
CONFIG_CIFS_UPCALL=y
# CONFIG_CIFS_XATTR is not set
CONFIG_CIFS_DEBUG=y
CONFIG_CIFS_DEBUG2=y
# CONFIG_CIFS_DFS_UPCALL is not set
CONFIG_CIFS_SMB2=y
CONFIG_CIFS_FSCACHE=y
CONFIG_NCP_FS=y
CONFIG_NCPFS_PACKET_SIGNING=y
# CONFIG_NCPFS_IOCTL_LOCKING is not set
# CONFIG_NCPFS_STRONG is not set
# CONFIG_NCPFS_NFS_NS is not set
CONFIG_NCPFS_OS2_NS=y
CONFIG_NCPFS_SMALLDOS=y
# CONFIG_NCPFS_NLS is not set
# CONFIG_NCPFS_EXTRAS is not set
CONFIG_CODA_FS=y
CONFIG_AFS_FS=m
CONFIG_AFS_DEBUG=y
CONFIG_AFS_FSCACHE=y
CONFIG_9P_FS=y
CONFIG_9P_FSCACHE=y
CONFIG_9P_FS_POSIX_ACL=y
CONFIG_9P_FS_SECURITY=y
CONFIG_NLS=y
CONFIG_NLS_DEFAULT="iso8859-1"
CONFIG_NLS_CODEPAGE_437=y
# CONFIG_NLS_CODEPAGE_737 is not set
# CONFIG_NLS_CODEPAGE_775 is not set
# CONFIG_NLS_CODEPAGE_850 is not set
CONFIG_NLS_CODEPAGE_852=m
CONFIG_NLS_CODEPAGE_855=m
# CONFIG_NLS_CODEPAGE_857 is not set
# CONFIG_NLS_CODEPAGE_860 is not set
CONFIG_NLS_CODEPAGE_861=y
# CONFIG_NLS_CODEPAGE_862 is not set
CONFIG_NLS_CODEPAGE_863=y
CONFIG_NLS_CODEPAGE_864=y
# CONFIG_NLS_CODEPAGE_865 is not set
# CONFIG_NLS_CODEPAGE_866 is not set
CONFIG_NLS_CODEPAGE_869=y
CONFIG_NLS_CODEPAGE_936=m
# CONFIG_NLS_CODEPAGE_950 is not set
# CONFIG_NLS_CODEPAGE_932 is not set
# CONFIG_NLS_CODEPAGE_949 is not set
CONFIG_NLS_CODEPAGE_874=y
CONFIG_NLS_ISO8859_8=m
CONFIG_NLS_CODEPAGE_1250=m
# CONFIG_NLS_CODEPAGE_1251 is not set
CONFIG_NLS_ASCII=m
CONFIG_NLS_ISO8859_1=y
CONFIG_NLS_ISO8859_2=y
CONFIG_NLS_ISO8859_3=m
CONFIG_NLS_ISO8859_4=y
# CONFIG_NLS_ISO8859_5 is not set
# CONFIG_NLS_ISO8859_6 is not set
# CONFIG_NLS_ISO8859_7 is not set
CONFIG_NLS_ISO8859_9=y
# CONFIG_NLS_ISO8859_13 is not set
# CONFIG_NLS_ISO8859_14 is not set
CONFIG_NLS_ISO8859_15=m
# CONFIG_NLS_KOI8_R is not set
CONFIG_NLS_KOI8_U=y
CONFIG_NLS_MAC_ROMAN=m
CONFIG_NLS_MAC_CELTIC=m
CONFIG_NLS_MAC_CENTEURO=y
CONFIG_NLS_MAC_CROATIAN=y
CONFIG_NLS_MAC_CYRILLIC=m
# CONFIG_NLS_MAC_GAELIC is not set
CONFIG_NLS_MAC_GREEK=m
CONFIG_NLS_MAC_ICELAND=m
CONFIG_NLS_MAC_INUIT=m
# CONFIG_NLS_MAC_ROMANIAN is not set
CONFIG_NLS_MAC_TURKISH=m
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
CONFIG_MESSAGE_LOGLEVEL_DEFAULT=4
CONFIG_BOOT_PRINTK_DELAY=y
# CONFIG_DYNAMIC_DEBUG is not set

#
# Compile-time checks and compiler options
#
# CONFIG_DEBUG_INFO is not set
# CONFIG_ENABLE_WARN_DEPRECATED is not set
CONFIG_ENABLE_MUST_CHECK=y
CONFIG_FRAME_WARN=2048
CONFIG_STRIP_ASM_SYMS=y
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
# CONFIG_DEBUG_PAGEALLOC is not set
CONFIG_DEBUG_OBJECTS=y
# CONFIG_DEBUG_OBJECTS_SELFTEST is not set
# CONFIG_DEBUG_OBJECTS_FREE is not set
# CONFIG_DEBUG_OBJECTS_TIMERS is not set
# CONFIG_DEBUG_OBJECTS_WORK is not set
CONFIG_DEBUG_OBJECTS_RCU_HEAD=y
# CONFIG_DEBUG_OBJECTS_PERCPU_COUNTER is not set
CONFIG_DEBUG_OBJECTS_ENABLE_DEFAULT=1
CONFIG_HAVE_DEBUG_KMEMLEAK=y
# CONFIG_DEBUG_KMEMLEAK is not set
CONFIG_DEBUG_STACK_USAGE=y
# CONFIG_DEBUG_VM is not set
CONFIG_DEBUG_VIRTUAL=y
CONFIG_DEBUG_MEMORY_INIT=y
CONFIG_MEMORY_NOTIFIER_ERROR_INJECT=m
CONFIG_HAVE_DEBUG_STACKOVERFLOW=y
# CONFIG_DEBUG_STACKOVERFLOW is not set
CONFIG_HAVE_ARCH_KMEMCHECK=y
# CONFIG_DEBUG_SHIRQ is not set

#
# Debug Lockups and Hangs
#
CONFIG_LOCKUP_DETECTOR=y
CONFIG_HARDLOCKUP_DETECTOR=y
# CONFIG_BOOTPARAM_HARDLOCKUP_PANIC is not set
CONFIG_BOOTPARAM_HARDLOCKUP_PANIC_VALUE=0
CONFIG_BOOTPARAM_SOFTLOCKUP_PANIC=y
CONFIG_BOOTPARAM_SOFTLOCKUP_PANIC_VALUE=1
# CONFIG_DETECT_HUNG_TASK is not set
CONFIG_PANIC_ON_OOPS=y
CONFIG_PANIC_ON_OOPS_VALUE=1
CONFIG_PANIC_TIMEOUT=0
CONFIG_SCHED_DEBUG=y
CONFIG_SCHEDSTATS=y
CONFIG_TIMER_STATS=y

#
# Lock Debugging (spinlocks, mutexes, etc...)
#
# CONFIG_DEBUG_RT_MUTEXES is not set
CONFIG_DEBUG_SPINLOCK=y
CONFIG_DEBUG_MUTEXES=y
CONFIG_DEBUG_WW_MUTEX_SLOWPATH=y
CONFIG_DEBUG_LOCK_ALLOC=y
# CONFIG_PROVE_LOCKING is not set
CONFIG_LOCKDEP=y
# CONFIG_LOCK_STAT is not set
# CONFIG_DEBUG_LOCKDEP is not set
CONFIG_DEBUG_ATOMIC_SLEEP=y
# CONFIG_DEBUG_LOCKING_API_SELFTESTS is not set
CONFIG_LOCK_TORTURE_TEST=m
CONFIG_STACKTRACE=y
# CONFIG_DEBUG_KOBJECT is not set
CONFIG_DEBUG_BUGVERBOSE=y
CONFIG_DEBUG_LIST=y
# CONFIG_DEBUG_PI_LIST is not set
CONFIG_DEBUG_SG=y
CONFIG_DEBUG_NOTIFIERS=y
CONFIG_DEBUG_CREDENTIALS=y

#
# RCU Debugging
#
# CONFIG_SPARSE_RCU_POINTER is not set
CONFIG_TORTURE_TEST=m
CONFIG_RCU_TORTURE_TEST=m
CONFIG_RCU_CPU_STALL_TIMEOUT=21
CONFIG_RCU_TRACE=y
CONFIG_NOTIFIER_ERROR_INJECTION=m
CONFIG_PM_NOTIFIER_ERROR_INJECT=m
# CONFIG_FAULT_INJECTION is not set
# CONFIG_LATENCYTOP is not set
CONFIG_ARCH_HAS_DEBUG_STRICT_USER_COPY_CHECKS=y
# CONFIG_DEBUG_STRICT_USER_COPY_CHECKS is not set
CONFIG_USER_STACKTRACE_SUPPORT=y
CONFIG_HAVE_FUNCTION_TRACER=y
CONFIG_HAVE_FUNCTION_GRAPH_TRACER=y
CONFIG_HAVE_FUNCTION_GRAPH_FP_TEST=y
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
CONFIG_KPROBES_SANITY_TEST=y
# CONFIG_BACKTRACE_SELF_TEST is not set
CONFIG_RBTREE_TEST=y
# CONFIG_INTERVAL_TREE_TEST is not set
CONFIG_PERCPU_TEST=m
# CONFIG_ATOMIC64_SELFTEST is not set
CONFIG_TEST_STRING_HELPERS=y
CONFIG_TEST_KSTRTOX=y
CONFIG_TEST_RHASHTABLE=y
# CONFIG_PROVIDE_OHCI1394_DMA_INIT is not set
CONFIG_BUILD_DOCSRC=y
# CONFIG_DMA_API_DEBUG is not set
CONFIG_TEST_MODULE=m
# CONFIG_TEST_USER_COPY is not set
# CONFIG_TEST_BPF is not set
CONFIG_TEST_FIRMWARE=m
CONFIG_TEST_UDELAY=m
# CONFIG_SAMPLES is not set
CONFIG_HAVE_ARCH_KGDB=y
# CONFIG_KGDB is not set
# CONFIG_STRICT_DEVMEM is not set
CONFIG_X86_VERBOSE_BOOTUP=y
# CONFIG_EARLY_PRINTK is not set
# CONFIG_X86_PTDUMP is not set
CONFIG_DEBUG_RODATA=y
CONFIG_DEBUG_RODATA_TEST=y
# CONFIG_DEBUG_SET_MODULE_RONX is not set
CONFIG_DEBUG_NX_TEST=m
# CONFIG_DOUBLEFAULT is not set
CONFIG_DEBUG_TLBFLUSH=y
# CONFIG_IOMMU_STRESS is not set
CONFIG_HAVE_MMIOTRACE_SUPPORT=y
# CONFIG_X86_DECODER_SELFTEST is not set
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
# CONFIG_OPTIMIZE_INLINING is not set
# CONFIG_DEBUG_NMI_SELFTEST is not set
CONFIG_X86_DEBUG_STATIC_CPU_HAS=y

#
# Security options
#
CONFIG_KEYS=y
# CONFIG_PERSISTENT_KEYRINGS is not set
CONFIG_TRUSTED_KEYS=m
CONFIG_ENCRYPTED_KEYS=y
CONFIG_KEYS_DEBUG_PROC_KEYS=y
CONFIG_SECURITY_DMESG_RESTRICT=y
CONFIG_SECURITY=y
CONFIG_SECURITYFS=y
CONFIG_SECURITY_NETWORK=y
# CONFIG_SECURITY_NETWORK_XFRM is not set
CONFIG_SECURITY_PATH=y
CONFIG_LSM_MMAP_MIN_ADDR=65536
CONFIG_SECURITY_SELINUX=y
CONFIG_SECURITY_SELINUX_BOOTPARAM=y
CONFIG_SECURITY_SELINUX_BOOTPARAM_VALUE=1
# CONFIG_SECURITY_SELINUX_DISABLE is not set
# CONFIG_SECURITY_SELINUX_DEVELOP is not set
CONFIG_SECURITY_SELINUX_AVC_STATS=y
CONFIG_SECURITY_SELINUX_CHECKREQPROT_VALUE=1
CONFIG_SECURITY_SELINUX_POLICYDB_VERSION_MAX=y
CONFIG_SECURITY_SELINUX_POLICYDB_VERSION_MAX_VALUE=19
CONFIG_SECURITY_SMACK=y
# CONFIG_SECURITY_TOMOYO is not set
CONFIG_SECURITY_APPARMOR=y
CONFIG_SECURITY_APPARMOR_BOOTPARAM_VALUE=1
# CONFIG_SECURITY_APPARMOR_HASH is not set
# CONFIG_SECURITY_YAMA is not set
CONFIG_INTEGRITY=y
# CONFIG_INTEGRITY_SIGNATURE is not set
# CONFIG_INTEGRITY_AUDIT is not set
# CONFIG_IMA is not set
CONFIG_EVM=y

#
# EVM options
#
CONFIG_EVM_ATTR_FSUUID=y
# CONFIG_EVM_EXTRA_SMACK_XATTRS is not set
# CONFIG_DEFAULT_SECURITY_SELINUX is not set
CONFIG_DEFAULT_SECURITY_SMACK=y
# CONFIG_DEFAULT_SECURITY_APPARMOR is not set
# CONFIG_DEFAULT_SECURITY_DAC is not set
CONFIG_DEFAULT_SECURITY="smack"
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
CONFIG_CRYPTO_WORKQUEUE=y
CONFIG_CRYPTO_CRYPTD=y
CONFIG_CRYPTO_AUTHENC=y
# CONFIG_CRYPTO_TEST is not set
CONFIG_CRYPTO_ABLK_HELPER=y
CONFIG_CRYPTO_GLUE_HELPER_X86=y

#
# Authenticated Encryption with Associated Data
#
CONFIG_CRYPTO_CCM=y
CONFIG_CRYPTO_GCM=m
CONFIG_CRYPTO_SEQIV=y

#
# Block modes
#
CONFIG_CRYPTO_CBC=y
CONFIG_CRYPTO_CTR=y
# CONFIG_CRYPTO_CTS is not set
CONFIG_CRYPTO_ECB=y
CONFIG_CRYPTO_LRW=y
CONFIG_CRYPTO_PCBC=m
CONFIG_CRYPTO_XTS=y

#
# Hash modes
#
CONFIG_CRYPTO_CMAC=y
CONFIG_CRYPTO_HMAC=y
# CONFIG_CRYPTO_XCBC is not set
CONFIG_CRYPTO_VMAC=m

#
# Digest
#
CONFIG_CRYPTO_CRC32C=y
CONFIG_CRYPTO_CRC32C_INTEL=y
# CONFIG_CRYPTO_CRC32 is not set
# CONFIG_CRYPTO_CRC32_PCLMUL is not set
CONFIG_CRYPTO_CRCT10DIF=m
CONFIG_CRYPTO_CRCT10DIF_PCLMUL=m
CONFIG_CRYPTO_GHASH=m
CONFIG_CRYPTO_MD4=y
CONFIG_CRYPTO_MD5=y
# CONFIG_CRYPTO_MICHAEL_MIC is not set
# CONFIG_CRYPTO_RMD128 is not set
CONFIG_CRYPTO_RMD160=m
CONFIG_CRYPTO_RMD256=m
# CONFIG_CRYPTO_RMD320 is not set
CONFIG_CRYPTO_SHA1=y
CONFIG_CRYPTO_SHA1_SSSE3=m
CONFIG_CRYPTO_SHA256_SSSE3=m
CONFIG_CRYPTO_SHA512_SSSE3=m
CONFIG_CRYPTO_SHA256=y
CONFIG_CRYPTO_SHA512=m
# CONFIG_CRYPTO_TGR192 is not set
# CONFIG_CRYPTO_WP512 is not set
CONFIG_CRYPTO_GHASH_CLMUL_NI_INTEL=y

#
# Ciphers
#
CONFIG_CRYPTO_AES=y
CONFIG_CRYPTO_AES_X86_64=y
CONFIG_CRYPTO_AES_NI_INTEL=y
CONFIG_CRYPTO_ANUBIS=y
CONFIG_CRYPTO_ARC4=y
CONFIG_CRYPTO_BLOWFISH=m
CONFIG_CRYPTO_BLOWFISH_COMMON=m
CONFIG_CRYPTO_BLOWFISH_X86_64=m
# CONFIG_CRYPTO_CAMELLIA is not set
CONFIG_CRYPTO_CAMELLIA_X86_64=y
CONFIG_CRYPTO_CAMELLIA_AESNI_AVX_X86_64=m
CONFIG_CRYPTO_CAMELLIA_AESNI_AVX2_X86_64=m
CONFIG_CRYPTO_CAST_COMMON=y
CONFIG_CRYPTO_CAST5=y
CONFIG_CRYPTO_CAST5_AVX_X86_64=y
CONFIG_CRYPTO_CAST6=y
CONFIG_CRYPTO_CAST6_AVX_X86_64=m
CONFIG_CRYPTO_DES=y
# CONFIG_CRYPTO_DES3_EDE_X86_64 is not set
CONFIG_CRYPTO_FCRYPT=m
# CONFIG_CRYPTO_KHAZAD is not set
# CONFIG_CRYPTO_SALSA20 is not set
CONFIG_CRYPTO_SALSA20_X86_64=m
# CONFIG_CRYPTO_SEED is not set
CONFIG_CRYPTO_SERPENT=y
CONFIG_CRYPTO_SERPENT_SSE2_X86_64=y
CONFIG_CRYPTO_SERPENT_AVX_X86_64=y
CONFIG_CRYPTO_SERPENT_AVX2_X86_64=m
CONFIG_CRYPTO_TEA=y
# CONFIG_CRYPTO_TWOFISH is not set
CONFIG_CRYPTO_TWOFISH_COMMON=m
CONFIG_CRYPTO_TWOFISH_X86_64=m
CONFIG_CRYPTO_TWOFISH_X86_64_3WAY=m
CONFIG_CRYPTO_TWOFISH_AVX_X86_64=m

#
# Compression
#
CONFIG_CRYPTO_DEFLATE=m
# CONFIG_CRYPTO_ZLIB is not set
CONFIG_CRYPTO_LZO=y
# CONFIG_CRYPTO_LZ4 is not set
CONFIG_CRYPTO_LZ4HC=y

#
# Random Number Generation
#
CONFIG_CRYPTO_ANSI_CPRNG=m
# CONFIG_CRYPTO_DRBG_MENU is not set
CONFIG_CRYPTO_USER_API=m
CONFIG_CRYPTO_USER_API_HASH=m
CONFIG_CRYPTO_USER_API_SKCIPHER=m
CONFIG_CRYPTO_HASH_INFO=y
CONFIG_CRYPTO_HW=y
CONFIG_CRYPTO_DEV_PADLOCK=y
CONFIG_CRYPTO_DEV_PADLOCK_AES=m
CONFIG_CRYPTO_DEV_PADLOCK_SHA=y
# CONFIG_CRYPTO_DEV_CCP is not set
# CONFIG_CRYPTO_DEV_QAT_DH895xCC is not set
CONFIG_ASYMMETRIC_KEY_TYPE=y
CONFIG_ASYMMETRIC_PUBLIC_KEY_SUBTYPE=y
CONFIG_PUBLIC_KEY_ALGO_RSA=y
CONFIG_X509_CERTIFICATE_PARSER=y
CONFIG_PKCS7_MESSAGE_PARSER=m
CONFIG_PKCS7_TEST_KEY=m
CONFIG_HAVE_KVM=y
CONFIG_HAVE_KVM_IRQCHIP=y
CONFIG_HAVE_KVM_IRQFD=y
CONFIG_HAVE_KVM_IRQ_ROUTING=y
CONFIG_HAVE_KVM_EVENTFD=y
CONFIG_KVM_APIC_ARCHITECTURE=y
CONFIG_KVM_MMIO=y
CONFIG_KVM_ASYNC_PF=y
CONFIG_HAVE_KVM_MSI=y
CONFIG_HAVE_KVM_CPU_RELAX_INTERCEPT=y
CONFIG_KVM_VFIO=y
CONFIG_VIRTUALIZATION=y
CONFIG_KVM=y
CONFIG_KVM_AMD=m
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
CONFIG_CRC_T10DIF=m
CONFIG_CRC_ITU_T=y
CONFIG_CRC32=y
# CONFIG_CRC32_SELFTEST is not set
# CONFIG_CRC32_SLICEBY8 is not set
# CONFIG_CRC32_SLICEBY4 is not set
# CONFIG_CRC32_SARWATE is not set
CONFIG_CRC32_BIT=y
# CONFIG_CRC7 is not set
CONFIG_LIBCRC32C=y
# CONFIG_CRC8 is not set
# CONFIG_AUDIT_ARCH_COMPAT_GENERIC is not set
# CONFIG_RANDOM32_SELFTEST is not set
CONFIG_ZLIB_INFLATE=y
CONFIG_ZLIB_DEFLATE=m
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
# CONFIG_XZ_DEC_SPARC is not set
CONFIG_XZ_DEC_BCJ=y
CONFIG_XZ_DEC_TEST=m
CONFIG_DECOMPRESS_GZIP=y
CONFIG_DECOMPRESS_BZIP2=y
CONFIG_DECOMPRESS_XZ=y
CONFIG_DECOMPRESS_LZO=y
CONFIG_GENERIC_ALLOCATOR=y
CONFIG_BCH=m
CONFIG_BCH_CONST_PARAMS=y
CONFIG_TEXTSEARCH=y
CONFIG_TEXTSEARCH_KMP=m
CONFIG_TEXTSEARCH_BM=m
CONFIG_TEXTSEARCH_FSM=m
CONFIG_ASSOCIATIVE_ARRAY=y
CONFIG_HAS_IOMEM=y
CONFIG_HAS_IOPORT_MAP=y
CONFIG_HAS_DMA=y
CONFIG_CHECK_SIGNATURE=y
CONFIG_DQL=y
CONFIG_NLATTR=y
CONFIG_ARCH_HAS_ATOMIC64_DEC_IF_POSITIVE=y
CONFIG_AVERAGE=y
CONFIG_CLZ_TAB=y
CONFIG_CORDIC=y
# CONFIG_DDR is not set
CONFIG_MPILIB=y
CONFIG_OID_REGISTRY=y
CONFIG_ARCH_HAS_SG_CHAIN=y

--St7VIuEGZ6dlpu13
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

_______________________________________________
LKP mailing list
LKP@linux.intel.com

--St7VIuEGZ6dlpu13--
