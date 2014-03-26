Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754635AbaCZO1d (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Mar 2014 10:27:33 -0400
Received: from mga01.intel.com ([192.55.52.88]:10973 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753842AbaCZO10 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Mar 2014 10:27:26 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,735,1389772800"; 
   d="log'?scan'208";a="499938952"
Date: Wed, 26 Mar 2014 22:26:46 +0800
From: Fengguang Wu <fengguang.wu@intel.com>
To: Fabian Frederick <fabf@skynet.be>
Cc: linux-kernel@vger.kernel.org
Subject: [ufs] WARNING: CPU: 0 PID: 483 at kernel/locking/mutex-debug.c:117
 mutex_destroy()
Message-ID: <20140326142646.GA26473@localhost>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="DocE+STaALJfprDB"
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--DocE+STaALJfprDB
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Greetings,

I got the below dmesg and the first bad commit is

git://git.kernel.org/pub/scm/linux/kernel/git/next/linux-next.git master

commit c7d2e322dd6eac1e3b44d2ea13f9818ad0f903de
Author:     Fabian Frederick <fabf@skynet.be>
AuthorDate: Sat Mar 22 12:49:51 2014 +1100
Commit:     Stephen Rothwell <sfr@canb.auug.org.au>
CommitDate: Mon Mar 24 17:32:07 2014 +1100

    ufs: sb mutex merge + mutex_destroy
    
    788257d6101d9 ("ufs: remove the BKL") replaced BKL with mutex protection
    using functions lock_ufs, unlock_ufs and struct mutex 'mutex' in sb_info.
    
    b6963327e052 ("ufs: drop lock/unlock super") removed lock/unlock super and
    added struct mutex 's_lock' in sb_info.
    
    Those 2 mutexes are generally locked/unlocked at the same time except in
    allocation (balloc, ialloc).
    
    This patch merges the 2 mutexes and propagates first commit solution.  It
    also adds mutex destruction before kfree during ufs_fill_super failure and
    ufs_put_super.
    
    Signed-off-by: Fabian Frederick <fabf@skynet.be>
    Cc: Evgeniy Dushistov <dushistov@mail.ru>
    Signed-off-by: Andrew Morton <akpm@linux-foundation.org>

+-----------------------------------------------------------------+------------+---------------+
|                                                                 | c7d2e322dd | next-20140324 |
+-----------------------------------------------------------------+------------+---------------+
| boot_successes                                                  | 31         | 4             |
| boot_failures                                                   | 26         | 15            |
| WARNING:CPU:PID:at_kernel/locking/mutex-debug.c:mutex_destroy() | 26         | 15            |
| INFO:rcu_preempt_detected_stalls_on_CPUs/tasks                  | 25         | 15            |
| INFO:task_blocked_for_more_than_seconds                         | 26         | 15            |
| RIP:flat_send_IPI_mask                                          | 26         | 15            |
| Kernel_panic-not_syncing:hung_task:blocked_tasks                | 26         | 15            |
| backtrace:do_mount                                              | 26         | 15            |
| backtrace:SyS_mount                                             | 26         | 15            |
| backtrace:user_path_create                                      | 25         | 15            |
| backtrace:SyS_mknodat                                           | 25         | 15            |
| backtrace:SyS_mknod                                             | 25         | 15            |
| backtrace:watchdog                                              | 26         | 15            |
| backtrace:work_fn                                               | 1          |               |
+-----------------------------------------------------------------+------------+---------------+

[    7.661278] UFSD (fs/ufs/super.c, 1264): ufs_fill_super:
[    7.664618] ufs was compiled with read-only support, can't be mounted as read-write
[    7.667790] UFSD (fs/ufs/super.c, 1264): ufs_fill_super:
[    7.670703] WARNING: CPU: 0 PID: 483 at kernel/locking/mutex-debug.c:117 mutex_destroy+0x4c/0x65()
[    7.674108] ufs was compiled with read-only support, can't be mounted as read-write
[    7.676652] flag 0
[    7.677363] ufs was compiled with read-only support, can't be mounted as read-write

git bisect start 098bc161bfc7697f7e2ca15400f13ca1ac60e9dd 9b28ec4b41883a83c3b0960e61739162443c5bba --
git bisect  bad 46a1de3d4918d4210affec733d665fd0ff2391e3  # 20:06     15-      4  Merge branch 'akpm/master'
git bisect good c51fabb1e3b203382616ca21f7cf4e7b0912d50e  # 20:20     57+      1  Revert "vmstat: use raw_cpu_ops to avoid false positives on preemption checks"
git bisect good bc82fcdfe572cea8d21ad97f1fab2d8cf3d412bc  # 20:45     57+      0  net: replace __this_cpu_inc in route.c with raw_cpu_inc
git bisect good 855370bf10fd8eb8877e197b6cbcd0262a9b34b7  # 21:04     57+      0  arm64: initialize pgprot info earlier in boot
git bisect good a5a8c89e515b8617f232d1a3375a086c4bfcae24  # 21:28     57+      0  fs/ufs: remove unused ufs_super_block_second pointer
git bisect  bad c7d2e322dd6eac1e3b44d2ea13f9818ad0f903de  # 21:48     22-      5  ufs: sb mutex merge + mutex_destroy
git bisect good e68aadb9f813be874722b4ef1e84b32557688364  # 22:11     57+      0  fs/ufs: remove unused ufs_super_block_third pointer
# first bad commit: [c7d2e322dd6eac1e3b44d2ea13f9818ad0f903de] ufs: sb mutex merge + mutex_destroy
git bisect good e68aadb9f813be874722b4ef1e84b32557688364  # 22:21    171+      0  fs/ufs: remove unused ufs_super_block_third pointer
git bisect  bad 098bc161bfc7697f7e2ca15400f13ca1ac60e9dd  # 22:21      0-     15  Add linux-next specific files for 20140324
git bisect good b098d6726bbfb94c06d6e1097466187afddae61f  # 23:12    171+      2  Linux 3.14-rc8
git bisect  bad 2ec6ab7445b659589abf5b9cf6c087c420d439bd  # 23:22     50-      1  Add linux-next specific files for 20140325


This script may reproduce the error.

-----------------------------------------------------------------------------
#!/bin/bash

kernel=$1
initrd=yocto-minimal-x86_64.cgz

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

--DocE+STaALJfprDB
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="dmesg-yocto-ivytown2-39:20140325215015:x86_64-randconfig-r3-03251014:3.14.0-rc7-11620-gc7d2e32:1"
Content-Transfer-Encoding: quoted-printable

early console in setup code
Probing EDD (edd=3Doff to disable)... ok
[    0.000000] Linux version 3.14.0-rc7-11620-gc7d2e32 (kbuild@inn) (gcc ve=
rsion 4.8.2 (Debian 4.8.2-16) ) #1 PREEMPT Tue Mar 25 21:43:34 CST 2014
[    0.000000] Command line: hung_task_panic=3D1 earlyprintk=3DttyS0,115200=
 debug apic=3Ddebug sysrq_always_enabled rcupdate.rcu_cpu_stall_timeout=3D1=
00 panic=3D10 softlockup_panic=3D1 nmi_watchdog=3Dpanic  prompt_ramdisk=3D0=
 console=3DttyS0,115200 console=3Dtty0 vga=3Dnormal  root=3D/dev/ram0 rw li=
nk=3D/kernel-tests/run-queue/kvm/x86_64-randconfig-r3-03251014/next:master:=
c7d2e322dd6eac1e3b44d2ea13f9818ad0f903de:bisect-linux5/.vmlinuz-c7d2e322dd6=
eac1e3b44d2ea13f9818ad0f903de-20140325214349-34-ivytown2 branch=3Dnext/mast=
er BOOT_IMAGE=3D/kernel/x86_64-randconfig-r3-03251014/c7d2e322dd6eac1e3b44d=
2ea13f9818ad0f903de/vmlinuz-3.14.0-rc7-11620-gc7d2e32 drbd.minor_count=3D8
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
[    0.000000] Base memory trampoline at [ffff880000099000] 99000 size 24576
[    0.000000] init_memory_mapping: [mem 0x00000000-0x000fffff]
[    0.000000]  [mem 0x00000000-0x000fffff] page 4k
[    0.000000] BRK [0x02704000, 0x02704fff] PGTABLE
[    0.000000] BRK [0x02705000, 0x02705fff] PGTABLE
[    0.000000] BRK [0x02706000, 0x02706fff] PGTABLE
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
[    0.000000] BRK [0x02707000, 0x02707fff] PGTABLE
[    0.000000] RAMDISK: [mem 0x13ce6000-0x13feffff]
[    0.000000] ACPI: RSDP 0x00000000000FD950 000014 (v00 BOCHS )
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
[    0.000000] mapped APIC to ffffffffff5fa000 (        fee00000)
[    0.000000] kvm-clock: Using msrs 4b564d01 and 4b564d00
[    0.000000] kvm-clock: cpu 0, msr 0:13ffd001, primary cpu clock
[    0.000000]  [ffffea0000000000-ffffea00005fffff] PMD -> [ffff880012e0000=
0-ffff8800133fffff] on node 0
[    0.000000] Zone ranges:
[    0.000000]   DMA      [mem 0x00001000-0x00ffffff]
[    0.000000]   DMA32    [mem 0x01000000-0xffffffff]
[    0.000000]   Normal   empty
[    0.000000] Movable zone start for each node
[    0.000000] Early memory node ranges
[    0.000000]   node   0: [mem 0x00001000-0x0009efff]
[    0.000000]   node   0: [mem 0x00100000-0x13ffdfff]
[    0.000000] On node 0 totalpages: 81820
[    0.000000]   DMA zone: 64 pages used for memmap
[    0.000000]   DMA zone: 21 pages reserved
[    0.000000]   DMA zone: 3998 pages, LIFO batch:0
[    0.000000]   DMA32 zone: 1216 pages used for memmap
[    0.000000]   DMA32 zone: 77822 pages, LIFO batch:15
[    0.000000] ACPI: PM-Timer IO Port: 0xb008
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] mapped APIC to ffffffffff5fa000 (        fee00000)
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
[    0.000000] mapped IOAPIC to ffffffffff5f9000 (fec00000)
[    0.000000] nr_irqs_gsi: 40
[    0.000000] KVM setup async PF for cpu 0
[    0.000000] kvm-stealtime: cpu 0, msr 2261840
[    0.000000] e820: [mem 0x14000000-0xfeffbfff] available for PCI devices
[    0.000000] Booting paravirtualized kernel on KVM
[    0.000000] pcpu-alloc: s0 r0 d32768 u32768 alloc=3D1*32768
[    0.000000] pcpu-alloc: [0] 0=20
[    0.000000] Built 1 zonelists in Zone order, mobility grouping on.  Tota=
l pages: 80519
[    0.000000] Kernel command line: hung_task_panic=3D1 earlyprintk=3DttyS0=
,115200 debug apic=3Ddebug sysrq_always_enabled rcupdate.rcu_cpu_stall_time=
out=3D100 panic=3D10 softlockup_panic=3D1 nmi_watchdog=3Dpanic  prompt_ramd=
isk=3D0 console=3DttyS0,115200 console=3Dtty0 vga=3Dnormal  root=3D/dev/ram=
0 rw link=3D/kernel-tests/run-queue/kvm/x86_64-randconfig-r3-03251014/next:=
master:c7d2e322dd6eac1e3b44d2ea13f9818ad0f903de:bisect-linux5/.vmlinuz-c7d2=
e322dd6eac1e3b44d2ea13f9818ad0f903de-20140325214349-34-ivytown2 branch=3Dne=
xt/master BOOT_IMAGE=3D/kernel/x86_64-randconfig-r3-03251014/c7d2e322dd6eac=
1e3b44d2ea13f9818ad0f903de/vmlinuz-3.14.0-rc7-11620-gc7d2e32 drbd.minor_cou=
nt=3D8
[    0.000000] sysrq: sysrq always enabled.
[    0.000000] PID hash table entries: 2048 (order: 2, 16384 bytes)
[    0.000000] Dentry cache hash table entries: 65536 (order: 7, 524288 byt=
es)
[    0.000000] Inode-cache hash table entries: 32768 (order: 6, 262144 byte=
s)
[    0.000000] Memory: 293496K/327280K available (13903K kernel code, 1928K=
 rwdata, 4680K rodata, 1660K init, 1372K bss, 33784K reserved)
[    0.000000] SLUB: HWalign=3D64, Order=3D0-3, MinObjects=3D0, CPUs=3D1, N=
odes=3D1
[    0.000000] Preemptible hierarchical RCU implementation.
[    0.000000] NR_IRQS:4352 nr_irqs:256 16
[    0.000000] console [ttyS0] enabled
[    0.000000] ------------------------
[    0.000000] | Locking API testsuite:
[    0.000000] ------------------------------------------------------------=
----------------
[    0.000000]                                  | spin |wlock |rlock |mutex=
 | wsem | rsem |
[    0.000000]   ----------------------------------------------------------=
----------------
[    0.000000]                      A-A deadlock:failed|failed|  ok  |faile=
d|failed|failed|
[    0.000000]                  A-B-B-A deadlock:failed|failed|  ok  |faile=
d|failed|failed|
[    0.000000]              A-B-B-C-C-A deadlock:failed|failed|  ok  |faile=
d|failed|failed|
[    0.000000]              A-B-C-A-B-C deadlock:failed|failed|  ok  |faile=
d|failed|failed|
[    0.000000]          A-B-B-C-C-D-D-A deadlock:failed|failed|  ok  |faile=
d|failed|failed|
[    0.000000]          A-B-C-D-B-D-D-A deadlock:failed|failed|  ok  |faile=
d|failed|failed|
[    0.000000]          A-B-C-D-B-C-D-A deadlock:failed|failed|  ok  |faile=
d|failed|failed|
[    0.000000]                     double unlock:failed|failed|failed|  ok =
 |failed|failed|
[    0.000000]                   initialize held:failed|failed|failed|faile=
d|failed|failed|
[    0.000000]                  bad unlock order:  ok  |  ok  |  ok  |  ok =
 |  ok  |  ok  |
[    0.000000]   ----------------------------------------------------------=
----------------
[    0.000000]               recursive read-lock:             |  ok  |     =
        |failed|
[    0.000000]            recursive read-lock #2:             |  ok  |     =
        |failed|
[    0.000000]             mixed read-write-lock:             |failed|     =
        |failed|
[    0.000000]             mixed write-read-lock:             |failed|     =
        |failed|
[    0.000000]   ----------------------------------------------------------=
----------------
[    0.000000]      hard-irqs-on + irq-safe-A/12:failed|failed|  ok  |
[    0.000000]      soft-irqs-on + irq-safe-A/12:failed|failed|  ok  |
[    0.000000]      hard-irqs-on + irq-safe-A/21:failed|failed|  ok  |
[    0.000000]      soft-irqs-on + irq-safe-A/21:failed|failed|  ok  |
[    0.000000]        sirq-safe-A =3D> hirqs-on/12:failed|failed|  ok  |
[    0.000000]        sirq-safe-A =3D> hirqs-on/21:failed|failed|  ok  |
[    0.000000]          hard-safe-A + irqs-on/12:failed|failed|  ok  |
[    0.000000]          soft-safe-A + irqs-on/12:failed|failed|  ok  |
[    0.000000]          hard-safe-A + irqs-on/21:failed|failed|  ok  |
[    0.000000]          soft-safe-A + irqs-on/21:failed|failed|  ok  |
[    0.000000]     hard-safe-A + unsafe-B #1/123:failed|failed|  ok  |
[    0.000000]     soft-safe-A + unsafe-B #1/123:failed|failed|  ok  |
[    0.000000]     hard-safe-A + unsafe-B #1/132:failed|failed|  ok  |
[    0.000000]     soft-safe-A + unsafe-B #1/132:failed|failed|  ok  |
[    0.000000]     hard-safe-A + unsafe-B #1/213:failed|failed|  ok  |
[    0.000000]     soft-safe-A + unsafe-B #1/213:failed|failed|  ok  |
[    0.000000]     hard-safe-A + unsafe-B #1/231:failed|failed|  ok  |
[    0.000000]     soft-safe-A + unsafe-B #1/231:failed|failed|  ok  |
[    0.000000]     hard-safe-A + unsafe-B #1/312:failed|failed|  ok  |
[    0.000000]     soft-safe-A + unsafe-B #1/312:failed|failed|  ok  |
[    0.000000]     hard-safe-A + unsafe-B #1/321:failed|failed|  ok  |
[    0.000000]     soft-safe-A + unsafe-B #1/321:failed|failed|  ok  |
[    0.000000]     hard-safe-A + unsafe-B #2/123:failed|failed|  ok  |
[    0.000000]     soft-safe-A + unsafe-B #2/123:failed|failed|  ok  |
[    0.000000]     hard-safe-A + unsafe-B #2/132:failed|failed|  ok  |
[    0.000000]     soft-safe-A + unsafe-B #2/132:failed|failed|  ok  |
[    0.000000]     hard-safe-A + unsafe-B #2/213:failed|failed|  ok  |
[    0.000000]     soft-safe-A + unsafe-B #2/213:failed|failed|  ok  |
[    0.000000]     hard-safe-A + unsafe-B #2/231:failed|failed|  ok  |
[    0.000000]     soft-safe-A + unsafe-B #2/231:failed|failed|  ok  |
[    0.000000]     hard-safe-A + unsafe-B #2/312:failed|failed|  ok  |
[    0.000000]     soft-safe-A + unsafe-B #2/312:failed|failed|  ok  |
[    0.000000]     hard-safe-A + unsafe-B #2/321:failed|failed|  ok  |
[    0.000000]     soft-safe-A + unsafe-B #2/321:failed|failed|  ok  |
[    0.000000]       hard-irq lock-inversion/123:failed|failed|  ok  |
[    0.000000]       soft-irq lock-inversion/123:failed|failed|  ok  |
[    0.000000]       hard-irq lock-inversion/132:failed|failed|  ok  |
[    0.000000]       soft-irq lock-inversion/132:failed|failed|  ok  |
[    0.000000]       hard-irq lock-inversion/213:failed|failed|  ok  |
[    0.000000]       soft-irq lock-inversion/213:failed|failed|  ok  |
[    0.000000]       hard-irq lock-inversion/231:failed|failed|  ok  |
[    0.000000]       soft-irq lock-inversion/231:failed|failed|  ok  |
[    0.000000]       hard-irq lock-inversion/312:failed|failed|  ok  |
[    0.000000]       soft-irq lock-inversion/312:failed|failed|  ok  |
[    0.000000]       hard-irq lock-inversion/321:failed|failed|  ok  |
[    0.000000]       soft-irq lock-inversion/321:failed|failed|  ok  |
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
[    0.000000]   ----------------------------------------------------------=
----------------
[    0.000000]   | Wound/wait tests |
[    0.000000]   ---------------------
[    0.000000]                   ww api failures:  ok  |  ok  |  ok  |
[    0.000000]                ww contexts mixing:failed|  ok  |
[    0.000000]              finishing ww context:  ok  |  ok  |  ok  |  ok =
 |
[    0.000000]                locking mismatches:  ok  |  ok  |  ok  |
[    0.000000]                  EDEADLK handling:  ok  |  ok  |  ok  |  ok =
 |  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |
[    0.000000]            spinlock nest unlocked:failed|
[    0.000000]   -----------------------------------------------------
[    0.000000]                                  |block | try  |context|
[    0.000000]   -----------------------------------------------------
[    0.000000]                           context:failed|  ok  |  ok  |
[    0.000000]                               try:failed|  ok  |failed|
[    0.000000]                             block:failed|  ok  |failed|
[    0.000000]                          spinlock:failed|  ok  |failed|
[    0.000000] --------------------------------------------------------
[    0.000000] 153 out of 253 testcases failed, as expected. |
[    0.000000] ----------------------------------------------------
[    0.000000] ODEBUG: 11 of 11 active objects replaced
[    0.000000] hpet clockevent registered
[    0.000000] tsc: Detected 2493.976 MHz processor
[    0.003000] Calibrating delay loop (skipped) preset value.. 4987.95 Bogo=
MIPS (lpj=3D2493976)
[    0.003481] pid_max: default: 4096 minimum: 301
[    0.004017] ACPI: Core revision 20140214
[    0.006595] ACPI: All ACPI Tables successfully acquired
[    0.007109] Security Framework initialized
[    0.008009] AppArmor: AppArmor disabled by boot time parameter
[    0.009023] Mount-cache hash table entries: 256
[    0.011825] mce: CPU supports 10 MCE banks
[    0.012065] Last level iTLB entries: 4KB 0, 2MB 0, 4MB 0
[    0.012065] Last level dTLB entries: 4KB 0, 2MB 0, 4MB 0, 1GB 0
[    0.012065] tlb_flushall_shift: 6
[    0.013039] CPU: Intel Common KVM processor (fam: 0f, model: 06, steppin=
g: 01)
[    0.043075] ftrace: allocating 49408 entries in 194 pages
[    0.063115] Performance Events: unsupported Netburst CPU model 6 no PMU =
driver, software events only.
[    0.066432] Getting VERSION: 50014
[    0.067011] Getting VERSION: 50014
[    0.068006] Getting ID: 0
[    0.068635] Getting ID: ff000000
[    0.069012] Getting LVT0: 8700
[    0.070046] NMI watchdog: disabled (cpu0): hardware events not enabled
[    0.071014] Getting LVT1: 8400
[    0.072032] enabled ExtINT on CPU#0
[    0.075037] ENABLING IO-APIC IRQs
[    0.075841] init IO_APIC IRQs
[    0.076006]  apic 0 pin 0 not connected
[    0.077011] IOAPIC[0]: Set routing entry (0-1 -> 0x31 -> IRQ 1 Mode:0 Ac=
tive:0 Dest:1)
[    0.078029] IOAPIC[0]: Set routing entry (0-2 -> 0x30 -> IRQ 0 Mode:0 Ac=
tive:0 Dest:1)
[    0.079036] IOAPIC[0]: Set routing entry (0-3 -> 0x33 -> IRQ 3 Mode:0 Ac=
tive:0 Dest:1)
[    0.080028] IOAPIC[0]: Set routing entry (0-4 -> 0x34 -> IRQ 4 Mode:0 Ac=
tive:0 Dest:1)
[    0.081025] IOAPIC[0]: Set routing entry (0-5 -> 0x35 -> IRQ 5 Mode:1 Ac=
tive:0 Dest:1)
[    0.082027] IOAPIC[0]: Set routing entry (0-6 -> 0x36 -> IRQ 6 Mode:0 Ac=
tive:0 Dest:1)
[    0.083026] IOAPIC[0]: Set routing entry (0-7 -> 0x37 -> IRQ 7 Mode:0 Ac=
tive:0 Dest:1)
[    0.084026] IOAPIC[0]: Set routing entry (0-8 -> 0x38 -> IRQ 8 Mode:0 Ac=
tive:0 Dest:1)
[    0.085026] IOAPIC[0]: Set routing entry (0-9 -> 0x39 -> IRQ 9 Mode:1 Ac=
tive:0 Dest:1)
[    0.086057] IOAPIC[0]: Set routing entry (0-10 -> 0x3a -> IRQ 10 Mode:1 =
Active:0 Dest:1)
[    0.087026] IOAPIC[0]: Set routing entry (0-11 -> 0x3b -> IRQ 11 Mode:1 =
Active:0 Dest:1)
[    0.088062] IOAPIC[0]: Set routing entry (0-12 -> 0x3c -> IRQ 12 Mode:0 =
Active:0 Dest:1)
[    0.089025] IOAPIC[0]: Set routing entry (0-13 -> 0x3d -> IRQ 13 Mode:0 =
Active:0 Dest:1)
[    0.090027] IOAPIC[0]: Set routing entry (0-14 -> 0x3e -> IRQ 14 Mode:0 =
Active:0 Dest:1)
[    0.091025] IOAPIC[0]: Set routing entry (0-15 -> 0x3f -> IRQ 15 Mode:0 =
Active:0 Dest:1)
[    0.092061]  apic 0 pin 16 not connected
[    0.093004]  apic 0 pin 17 not connected
[    0.094004]  apic 0 pin 18 not connected
[    0.095004]  apic 0 pin 19 not connected
[    0.096004]  apic 0 pin 20 not connected
[    0.097004]  apic 0 pin 21 not connected
[    0.098004]  apic 0 pin 22 not connected
[    0.099004]  apic 0 pin 23 not connected
[    0.100207] ..TIMER: vector=3D0x30 apic1=3D0 pin1=3D2 apic2=3D-1 pin2=3D=
-1
[    0.101004] Using local APIC timer interrupts.
[    0.101004] calibrating APIC timer ...
[    0.103000] ... lapic delta =3D 6249860
[    0.103000] ... PM-Timer delta =3D 358141
[    0.103000] ... PM-Timer result ok
[    0.103000] ..... delta 6249860
[    0.103000] ..... mult: 268429443
[    0.103000] ..... calibration result: 999977
[    0.103000] ..... CPU clock speed is 2494.0153 MHz.
[    0.103000] ..... host bus clock speed is 999.0977 MHz.
[    0.106003] xor: measuring software checksum speed
[    0.117007]    prefetch64-sse:  6864.000 MB/sec
[    0.128008]    generic_sse:  6376.000 MB/sec
[    0.129005] xor: using function: prefetch64-sse (6864.000 MB/sec)
[    0.130010] prandom: seed boundary self test passed
[    0.132210] prandom: 100 self tests passed
[    0.133006] atomic64 test passed for x86-64 platform with CX8 and with S=
SE
[    0.134142] regulator-dummy: no parameters
[    0.135150] NET: Registered protocol family 16
[    0.137818] cpuidle: using governor menu
[    0.139321] ACPI: bus type PCI registered
[    0.140149] PCI: Using configuration type 1 for base access
[    0.170026] raid6: sse2x1    2726 MB/s
[    0.188010] raid6: sse2x2    4074 MB/s
[    0.206015] raid6: sse2x4    4710 MB/s
[    0.207004] raid6: using algorithm sse2x4 (4710 MB/s)
[    0.208004] raid6: using intx1 recovery algorithm
[    0.209107] ACPI: Added _OSI(Module Device)
[    0.210004] ACPI: Added _OSI(Processor Device)
[    0.211004] ACPI: Added _OSI(3.0 _SCP Extensions)
[    0.212005] ACPI: Added _OSI(Processor Aggregator Device)
[    0.216970] ACPI: Interpreter enabled
[    0.217010] ACPI Exception: AE_NOT_FOUND, While evaluating Sleep State [=
\_S1_] (20140214/hwxface-580)
[    0.220007] ACPI Exception: AE_NOT_FOUND, While evaluating Sleep State [=
\_S2_] (20140214/hwxface-580)
[    0.223020] ACPI: (supports S0 S3 S5)
[    0.224004] ACPI: Using IOAPIC for interrupt routing
[    0.226018] PCI: Using host bridge windows from ACPI; if necessary, use =
"pci=3Dnocrs" and report a bug
[    0.232630] ACPI: PCI Root Bridge [PCI0] (domain 0000 [bus 00-ff])
[    0.233011] acpi PNP0A03:00: _OSC: OS supports [Segments MSI]
[    0.234013] acpi PNP0A03:00: _OSC failed (AE_NOT_FOUND); disabling ASPM
[    0.235266] PCI host bridge to bus 0000:00
[    0.236007] pci_bus 0000:00: root bus resource [bus 00-ff]
[    0.237006] pci_bus 0000:00: root bus resource [io  0x0000-0x0cf7]
[    0.238006] pci_bus 0000:00: root bus resource [io  0x0d00-0xffff]
[    0.239006] pci_bus 0000:00: root bus resource [mem 0x000a0000-0x000bfff=
f]
[    0.240006] pci_bus 0000:00: root bus resource [mem 0x80000000-0xfebffff=
f]
[    0.242005] pci 0000:00:00.0: [8086:1237] type 00 class 0x060000
[    0.243805] pci 0000:00:01.0: [8086:7000] type 00 class 0x060100
[    0.245922] pci 0000:00:01.1: [8086:7010] type 00 class 0x010180
[    0.251007] pci 0000:00:01.1: reg 0x20: [io  0xc040-0xc04f]
[    0.254045] pci 0000:00:01.1: legacy IDE quirk: reg 0x10: [io  0x01f0-0x=
01f7]
[    0.255037] pci 0000:00:01.1: legacy IDE quirk: reg 0x14: [io  0x03f6]
[    0.256005] pci 0000:00:01.1: legacy IDE quirk: reg 0x18: [io  0x0170-0x=
0177]
[    0.257005] pci 0000:00:01.1: legacy IDE quirk: reg 0x1c: [io  0x0376]
[    0.259005] pci 0000:00:01.3: [8086:7113] type 00 class 0x068000
[    0.260753] pci 0000:00:01.3: quirk: [io  0xb000-0xb03f] claimed by PIIX=
4 ACPI
[    0.261020] pci 0000:00:01.3: quirk: [io  0xb100-0xb10f] claimed by PIIX=
4 SMB
[    0.263075] pci 0000:00:02.0: [1013:00b8] type 00 class 0x030000
[    0.266188] pci 0000:00:02.0: reg 0x10: [mem 0xfc000000-0xfdffffff pref]
[    0.269057] pci 0000:00:02.0: reg 0x14: [mem 0xfebf0000-0xfebf0fff]
[    0.281060] pci 0000:00:02.0: reg 0x30: [mem 0xfebe0000-0xfebeffff pref]
[    0.283974] pci 0000:00:03.0: [8086:100e] type 00 class 0x020000
[    0.286007] pci 0000:00:03.0: reg 0x10: [mem 0xfeba0000-0xfebbffff]
[    0.289011] pci 0000:00:03.0: reg 0x14: [io  0xc000-0xc03f]
[    0.297804] pci 0000:00:03.0: reg 0x30: [mem 0xfebc0000-0xfebdffff pref]
[    0.298579] pci 0000:00:04.0: [8086:25ab] type 00 class 0x088000
[    0.300550] pci 0000:00:04.0: reg 0x10: [mem 0xfebf1000-0xfebf100f]
[    0.307604] pci_bus 0000:00: on NUMA node 0
[    0.308775] ACPI: PCI Interrupt Link [LNKA] (IRQs 5 *10 11)
[    0.310292] ACPI: PCI Interrupt Link [LNKB] (IRQs 5 *10 11)
[    0.312782] ACPI: PCI Interrupt Link [LNKC] (IRQs 5 10 *11)
[    0.314277] ACPI: PCI Interrupt Link [LNKD] (IRQs 5 10 *11)
[    0.316661] ACPI: PCI Interrupt Link [LNKS] (IRQs *9)
[    0.318000] ACPI: Enabled 16 GPEs in block 00 to 0F
[    0.319411] vgaarb: device added: PCI:0000:00:02.0,decodes=3Dio+mem,owns=
=3Dio+mem,locks=3Dnone
[    0.320005] vgaarb: loaded
[    0.321004] vgaarb: bridge control possible 0000:00:02.0
[    0.323234] SCSI subsystem initialized
[    0.324109] libata version 3.00 loaded.
[    0.325142] ACPI: bus type USB registered
[    0.326082] usbcore: registered new interface driver usbfs
[    0.327035] usbcore: registered new interface driver hub
[    0.328073] usbcore: registered new device driver usb
[    0.330190] Linux video capture interface: v2.00
[    0.331040] pps_core: LinuxPPS API ver. 1 registered
[    0.332017] pps_core: Software ver. 5.3.6 - Copyright 2005-2007 Rodolfo =
Giometti <giometti@linux.it>
[    0.333025] PTP clock support registered
[    0.334578] Advanced Linux Sound Architecture Driver Initialized.
[    0.335040] PCI: Using ACPI for IRQ routing
[    0.336016] PCI: pci_cache_line_size set to 64 bytes
[    0.337192] e820: reserve RAM buffer [mem 0x0009fc00-0x0009ffff]
[    0.338017] e820: reserve RAM buffer [mem 0x13ffe000-0x13ffffff]
[    0.339508] NET: Registered protocol family 8
[    0.340004] NET: Registered protocol family 20
[    0.344108] HPET: 3 timers in total, 0 timers will be used for per-cpu t=
imer
[    0.345095] cfg80211: Calling CRDA to update world regulatory domain
[    0.346066] Switched to clocksource kvm-clock
[    0.347658] Could not create debugfs 'set_ftrace_filter' entry
[    0.349554] Could not create debugfs 'set_ftrace_notrace' entry
[    0.368148] pnp: PnP ACPI init
[    0.369272] ACPI: bus type PNP registered
[    0.370837] IOAPIC[0]: Set routing entry (0-8 -> 0x38 -> IRQ 8 Mode:0 Ac=
tive:0 Dest:1)
[    0.373629] pnp 00:00: Plug and Play ACPI device, IDs PNP0b00 (active)
[    0.376029] IOAPIC[0]: Set routing entry (0-1 -> 0x31 -> IRQ 1 Mode:0 Ac=
tive:0 Dest:1)
[    0.379000] pnp 00:01: Plug and Play ACPI device, IDs PNP0303 (active)
[    0.381292] IOAPIC[0]: Set routing entry (0-12 -> 0x3c -> IRQ 12 Mode:0 =
Active:0 Dest:1)
[    0.384214] pnp 00:02: Plug and Play ACPI device, IDs PNP0f13 (active)
[    0.386486] IOAPIC[0]: Set routing entry (0-6 -> 0x36 -> IRQ 6 Mode:0 Ac=
tive:0 Dest:1)
[    0.389303] pnp 00:03: [dma 2]
[    0.390429] pnp 00:03: Plug and Play ACPI device, IDs PNP0700 (active)
[    0.392894] IOAPIC[0]: Set routing entry (0-7 -> 0x37 -> IRQ 7 Mode:0 Ac=
tive:0 Dest:1)
[    0.395745] pnp 00:04: Plug and Play ACPI device, IDs PNP0400 (active)
[    0.398202] IOAPIC[0]: Set routing entry (0-4 -> 0x34 -> IRQ 4 Mode:0 Ac=
tive:0 Dest:1)
[    0.401186] pnp 00:05: Plug and Play ACPI device, IDs PNP0501 (active)
[    0.403874] pnp 00:06: Plug and Play ACPI device, IDs PNP0103 (active)
[    0.406306] pnp: PnP ACPI: found 7 devices
[    0.407857] ACPI: bus type PNP unregistered
[    0.414625] pci_bus 0000:00: resource 4 [io  0x0000-0x0cf7]
[    0.416511] pci_bus 0000:00: resource 5 [io  0x0d00-0xffff]
[    0.418488] pci_bus 0000:00: resource 6 [mem 0x000a0000-0x000bffff]
[    0.420613] pci_bus 0000:00: resource 7 [mem 0x80000000-0xfebfffff]
[    0.422811] NET: Registered protocol family 1
[    0.424298] pci 0000:00:00.0: Limiting direct PCI/PCI transfers
[    0.426287] pci 0000:00:01.0: PIIX3: Enabling Passive Release
[    0.428303] pci 0000:00:01.0: Activating ISA DMA hang workarounds
[    0.430436] pci 0000:00:02.0: Boot video device
[    0.432127] PCI: CLS 0 bytes, default 64
[    0.433925] Unpacking initramfs...
[    0.550594] Freeing initrd memory: 3112K (ffff880013ce6000 - ffff880013f=
f0000)
[    0.554867] Machine check injector initialized
[    0.556807] camellia-x86_64: performance on this CPU would be suboptimal=
: disabling camellia-x86_64.
[    0.560133] blowfish-x86_64: performance on this CPU would be suboptimal=
: disabling blowfish-x86_64.
[    0.563540] twofish-x86_64-3way: performance on this CPU would be subopt=
imal: disabling twofish-x86_64-3way.
[    0.567665] sha1_ssse3: Neither AVX nor AVX2 nor SSSE3 is available/usab=
le.
[    0.570209] PCLMULQDQ-NI instructions are not detected.
[    0.572245] sha256_ssse3: Neither AVX nor SSSE3 is available/usable.
[    0.574716] sha512_ssse3: Neither AVX nor SSSE3 is available/usable.
[    0.577068] AVX or AES-NI instructions are not detected.
[    0.579183] AVX instructions are not detected.
[    0.580798] AVX instructions are not detected.
[    0.582400] AVX instructions are not detected.
[    0.584162] AVX instructions are not detected.
[    0.585768] AVX2 instructions are not detected.
[    0.588125] Initializing RT-Tester: OK
[    0.589526] spin_lock-torture:--- Start of test: nwriters_stress=3D2 sta=
t_interval=3D60 verbose=3D1 shuffle_interval=3D3 stutter=3D5 shutdown_secs=
=3D0 onoff_interval=3D0 onoff_holdoff=3D0
[    0.595140] spin_lock-torture: Creating torture_shuffle task
[    0.597103] spin_lock-torture: Creating torture_stutter task
[    0.599364] spin_lock-torture: torture_shuffle task started
[    0.601503] spin_lock-torture: Creating lock_torture_writer task
[    0.603733] spin_lock-torture: torture_stutter task started
[    0.605907] spin_lock-torture: Creating lock_torture_writer task
[    0.608069] spin_lock-torture: lock_torture_writer task started
[    0.610324] spin_lock-torture: Creating lock_torture_stats task
[    0.612553] spin_lock-torture: lock_torture_writer task started
[    0.615190] futex hash table entries: 16 (order: -4, 384 bytes)
[    0.617361] spin_lock-torture: lock_torture_stats task started
[    0.619526] Initialise system trusted keyring
[    0.621128] audit: initializing netlink subsys (disabled)
[    0.623165] audit: type=3D2000 audit(1395755164.108:1): initialized
[    0.625941] HugeTLB registered 2 MB page size, pre-allocated 0 pages
[    0.631613] VFS: Disk quotas dquot_6.5.2
[    0.633073] Dquot-cache hash table entries: 512 (order 0, 4096 bytes)
[    0.636471] ntfs: driver 2.1.30 [Flags: R/W].
[    0.638321] ROMFS MTD (C) 2007 Red Hat, Inc.
[    0.640032] QNX4 filesystem 0.2.3 registered.
[    0.641848] fuse init (API version 7.22)
[    0.643514] befs: version: 0.9.3
[    0.645106] ocfs2 stack glue: unable to register sysctl
[    0.646974] ocfs2: Registered cluster interface o2cb
[    0.649025] OCFS2 User DLM kernel interface loaded
[    0.652763] gfs2: GFS2 installed
[    0.654287] msgmni has been set to 579
[    0.658042] NET: Registered protocol family 38
[    0.659835] Key type asymmetric registered
[    0.661354] Asymmetric key parser 'x509' registered
[    0.663278] Block layer SCSI generic (bsg) driver version 0.4 loaded (ma=
jor 250)
[    0.666070] io scheduler noop registered
[    0.667476] io scheduler deadline registered (default)
[    0.669366] test_string_helpers: Running tests...
[    0.671241] rbtree testing -> 19315 cycles
[    1.503857] augmented rbtree testing
[    1.618508] tsc: Refined TSC clocksource calibration: 2492.754 MHz
[    2.391292]  -> 22103 cycles
[    2.450243] vmlfb: initializing
[    2.451286] Could not find Carillo Ranch MCH device.
[    2.452900] no IO addresses supplied
[    2.454109] hgafb: HGA card not detected.
[    2.455652] hgafb: probe of hgafb.0 failed with error -22
[    2.457513] usbcore: registered new interface driver udlfb
[    2.460560] uvesafb: VGABIOS Cirrus extension, VGABIOS Cirrus extension,=
 1.0, OEM: VGABIOS Cirrus extension, VBE v2.0
[    2.466145] uvesafb: no monitor limits have been set, default refresh ra=
te will be used
[    2.468624] uvesafb: VBE state buffer size cannot be determined (eax=3D0=
x14f, err=3D0)
[    2.470871] uvesafb: scrolling: redraw
[    2.472564] uvesafb: framebuffer at 0xfc000000, mapped to 0xffffc9000008=
0000, using 4096k, total 4096k
[    2.475430] fb0: VESA VGA frame buffer device
[    2.481589] ipmi message handler version 39.2
[    2.482913] ipmi device interface
[    2.483950] IPMI System Interface driver.
[    2.485228] ipmi_si: Adding default-specified kcs state machine
[    2.487103] ipmi_si: Trying default-specified kcs state machine at i/o a=
ddress 0xca2, slave address 0x0, irq 0
[    2.490000] ipmi_si: Interface detection failed
[    2.491419] ipmi_si: Adding default-specified smic state machine
[    2.493278] ipmi_si: Trying default-specified smic state machine at i/o =
address 0xca9, slave address 0x0, irq 0
[    2.496246] ipmi_si: Interface detection failed
[    2.497590] ipmi_si: Adding default-specified bt state machine
[    2.499530] ipmi_si: Trying default-specified bt state machine at i/o ad=
dress 0xe4, slave address 0x0, irq 0
[    2.502602] ipmi_si: Interface detection failed
[    2.504000] ipmi_si: Unable to find any System Interface(s)
[    2.505848] input: Power Button as /devices/LNXSYSTM:00/LNXPWRBN:00/inpu=
t/input0
[    2.508007] ACPI: Power Button [PWRF]
[    2.523063] HDLC line discipline maxframe=3D4096
[    2.524470] N_HDLC line discipline registered.
[    2.525935] r3964: Philips r3964 Driver $Revision: 1.10 $
[    2.527527] Serial: 8250/16550 driver, 4 ports, IRQ sharing disabled
[    2.557611] 00:05: ttyS0 at I/O 0x3f8 (irq =3D 4, base_baud =3D 115200) =
is a 16550A
[    2.561008] SuperH (H)SCI(F) driver initialized
[    2.562804] STMicroelectronics ASC driver initialized
[    2.564633] serial: Freescale lpuart driver
[    2.566159] Cyclades driver 2.6
[    2.567326] MOXA Intellio family driver version 6.0k
[    2.569114] Initializing Nozomi driver 2.1d
[    2.570631] RocketPort device driver module, version 2.09, 12-June-2003
[    2.572967] No rocketport ports found; unloading driver
[    2.574691] SyncLink GT
[    2.575677] SyncLink GT, tty major#243
[    2.576981] SyncLink GT no devices found
[    2.578350] SyncLink MultiPort driver $Revision: 4.38 $
[    2.584625] SyncLink MultiPort driver $Revision: 4.38 $, tty major#242
[    2.586852] Non-volatile memory driver v1.3
[    2.588460] ppdev: user-space parallel port driver
[    2.590047] smapi::smapi_init, ERROR invalid usSmapiID
[    2.591778] mwave: tp3780i::tp3780I_InitializeBoardData: Error: SMAPI is=
 not available on this machine
[    2.594829] mwave: mwavedd::mwave_init: Error: Failed to initialize boar=
d data
[    2.597165] mwave: mwavedd::mwave_init: Error: Failed to initialize
[    2.599467] Linux agpgart interface v0.103
[    2.602601] parport_pc 00:04: reported by Plug and Play ACPI
[    2.604460] parport0: PC-style at 0x378, irq 7 [PCSPP(,...)]
[    2.607231] HP CISS Driver (v 3.6.26)
[    2.608864] Floppy drive(s): fd0 is 1.44M
[    2.610998] nbd: registered device at major 43
[    2.614991] ibmasm: IBM ASM Service Processor Driver version 1.0 loaded
[    2.617091] dummy-irq: no IRQ given.  Use irq=3DN
[    2.618788] lkdtm: No crash points registered, enable through debugfs
[    2.620970] Phantom Linux Driver, version n0.9.8, init OK
[    2.622837] Silicon Labs C2 port support v. 0.51.0 - (C) 2007 Rodolfo Gi=
ometti
[    2.625204] c2port c2port0: C2 port uc added
[    2.626706] c2port c2port0: uc flash has 30 blocks x 512 bytes (15360 by=
tes total)
[    2.629516] mic_init not running on X100 ret -19
[    2.631190] usbcore: registered new interface driver rtsx_usb
[    2.633897] FDC 0 is a S82078B
[    2.635796] usbcore: registered new interface driver viperboard
[    2.637853] Uniform Multi-Platform E-IDE driver
[    2.639693] piix 0000:00:01.1: IDE controller (0x8086:0x7010 rev 0x00)
[    2.642085] piix 0000:00:01.1: not 100% native mode: will probe irqs lat=
er
[    2.645454]     ide0: BM-DMA at 0xc040-0xc047
[    2.647234]     ide1: BM-DMA at 0xc048-0xc04f
[    2.649078] Probing IDE interface ide0...
[    3.173347] Probing IDE interface ide1...
[    3.846393] hdc: QEMU DVD-ROM, ATAPI CD/DVD-ROM drive
[    4.459366] hdc: host max PIO4 wanted PIO255(auto-tune) selected PIO0
[    4.460762] hdc: MWDMA2 mode selected
[    4.461793] ide0 at 0x1f0-0x1f7,0x3f6 on irq 14
[    4.462816] ide1 at 0x170-0x177,0x376 on irq 15
[    4.464116] ide_generic: please use "probe_mask=3D0x3f" module parameter=
 for probing all legacy ISA IDE ports
[    4.467368] ide-gd driver 1.18
[    4.468448] ide-cd driver 5.00
[    4.470013] ide-cd: hdc: ATAPI 4X DVD-ROM drive, 512kB Cache
[    4.472104] cdrom: Uniform CD-ROM driver Revision: 3.20
[    4.480063] st: Version 20101219, fixed bufsize 32768, s/g segs 256
[    4.483800] osst :I: Tape driver with OnStream support version 0.99.4
[    4.483800] osst :I: $Id: osst.c,v 1.73 2005/01/01 21:13:34 wriede Exp $
[    4.493741] SCSI Media Changer driver v0.25=20
[    4.495433] Error: Driver 'pata_platform' is already registered, abortin=
g...
[    4.500566] Rounding down aligned max_sectors from 4294967295 to 4294967=
288
[    4.503907] vcan: Virtual CAN interface driver
[    4.507383] slcan: serial line CAN interface driver
[    4.509964] slcan: 10 dynamic interface channels.
[    4.513133] CAN device driver interface
[    4.514474] usbcore: registered new interface driver ems_usb
[    4.517557] usbcore: registered new interface driver esd_usb2
[    4.521425] usbcore: registered new interface driver peak_usb
[    4.523255] sja1000 CAN netdevice driver
[    4.524653] cc770: CAN netdevice driver
[    4.525825] mkiss: AX.25 Multikiss, Hans Albas PE1AYX
[    4.527440] AX.25: 6pack driver, Revision: 0.3.0
[    4.528931] YAM driver version 0.8 by F1OAT/F6FBB
[    4.531132] AX.25: bpqether driver version 004
[    4.532620] baycom_ser_fdx: (C) 1996-2000 Thomas Sailer, HB9JNX/AE4WA
[    4.532620] baycom_ser_fdx: version 0.10
[    4.537659] hdlcdrv: (C) 1996-2000 Thomas Sailer HB9JNX/AE4WA
[    4.539380] hdlcdrv: version 0.8
[    4.540483] baycom_ser_hdx: (C) 1996-2000 Thomas Sailer, HB9JNX/AE4WA
[    4.540483] baycom_ser_hdx: version 0.10
[    4.544118] baycom_par: (C) 1996-2000 Thomas Sailer, HB9JNX/AE4WA
[    4.544118] baycom_par: version 0.9
[    4.548357] I2O subsystem v1.325
[    4.549423] i2o: max drivers =3D 8
[    4.550709] I2O Bus Adapter OSM v1.317
[    4.552023] I2O SCSI Peripheral OSM v1.316
[    4.553457] I2O ProcFS OSM v1.316
[    4.554591] Fusion MPT base driver 3.04.20
[    4.555974] Copyright (c) 1999-2008 LSI Corporation
[    4.557640] Fusion MPT SPI Host driver 3.04.20
[    4.559038] Fusion MPT FC Host driver 3.04.20
[    4.560427] Fusion MPT SAS Host driver 3.04.20
[    4.561864] Fusion MPT misc device (ioctl) driver 3.04.20
[    4.563616] mptctl: Registered with Fusion MPT base driver
[    4.565202] mptctl: /dev/mptctl @ (major,minor=3D10,220)
[    4.567529] aoe: AoE v85 initialised.
[    4.568744] usbcore: registered new interface driver hwa-rc
[    4.570531] usbcore: registered new interface driver i1480-dfu-usb
[    4.572718] ehci_hcd: USB 2.0 'Enhanced' Host Controller (EHCI) Driver
[    4.574925] ehci-pci: EHCI PCI platform driver
[    4.576475] ehci-platform: EHCI generic platform driver
[    4.578276] uhci_hcd: USB Universal Host Controller Interface driver
[    4.581021] usbcore: registered new interface driver hwa-hc
[    4.582713] fotg210_hcd: FOTG210 Host Controller (EHCI) Driver
[    4.587419] usbcore: registered new interface driver wusb-cbaf
[    4.589317] usbcore: registered new interface driver cdc_acm
[    4.591064] cdc_acm: USB Abstract Control Model driver for USB modems an=
d ISDN adapters
[    4.593595] usbcore: registered new interface driver usblp
[    4.595433] usbcore: registered new interface driver uas
[    4.597268] usbcore: registered new interface driver usb-storage
[    4.599254] usbcore: registered new interface driver ums-alauda
[    4.601256] usbcore: registered new interface driver ums-freecom
[    4.603143] usbcore: registered new interface driver ums-isd200
[    4.604975] usbcore: registered new interface driver ums-jumpshot
[    4.606933] usbcore: registered new interface driver ums-karma
[    4.608739] usbcore: registered new interface driver ums-onetouch
[    4.610682] usbcore: registered new interface driver ums-realtek
[    4.612538] usbcore: registered new interface driver ums-sddr09
[    4.614378] usbcore: registered new interface driver ums-sddr55
[    4.616383] usbcore: registered new interface driver ums-usbat
[    4.618342] usbcore: registered new interface driver mdc800
[    4.620228] mdc800: v0.7.5 (30/10/2000):USB Driver for Mustek MDC800 Dig=
ital Camera
[    4.622723] usbcore: registered new interface driver microtekX6
[    4.624815] usbcore: registered new interface driver usbserial
[    4.626655] usbcore: registered new interface driver belkin_sa
[    4.628503] usbserial: USB Serial support registered for Belkin / Peraco=
m / GoHubs USB Serial Adapter
[    4.631274] usbcore: registered new interface driver ch341
[    4.633052] usbserial: USB Serial support registered for ch341-uart
[    4.634891] usbcore: registered new interface driver cp210x
[    4.636616] usbserial: USB Serial support registered for cp210x
[    4.638612] usbcore: registered new interface driver cyberjack
[    4.640587] usbserial: USB Serial support registered for Reiner SCT Cybe=
rjack USB card reader
[    4.643452] usbcore: registered new interface driver cypress_m8
[    4.645396] usbserial: USB Serial support registered for DeLorme Earthma=
te USB
[    4.647605] usbserial: USB Serial support registered for HID->COM RS232 =
Adapter
[    4.649912] usbserial: USB Serial support registered for Nokia CA-42 V2 =
Adapter
[    4.652104] usbcore: registered new interface driver usb_debug
[    4.653933] usbserial: USB Serial support registered for debug
[    4.655780] usbcore: registered new interface driver io_edgeport
[    4.657705] usbserial: USB Serial support registered for Edgeport 2 port=
 adapter
[    4.660093] usbserial: USB Serial support registered for Edgeport 4 port=
 adapter
[    4.662542] usbserial: USB Serial support registered for Edgeport 8 port=
 adapter
[    4.664864] usbserial: USB Serial support registered for EPiC device
[    4.666818] usbcore: registered new interface driver ipw
[    4.668346] usbserial: USB Serial support registered for IPWireless conv=
erter
[    4.670505] usbcore: registered new interface driver iuu_phoenix
[    4.672381] usbserial: USB Serial support registered for iuu_phoenix
[    4.674316] usbcore: registered new interface driver keyspan_pda
[    4.676256] usbserial: USB Serial support registered for Keyspan PDA
[    4.678150] usbserial: USB Serial support registered for Keyspan PDA - (=
prerenumeration)
[    4.680817] usbserial: USB Serial support registered for Xircom / Entreg=
ra PGS - (prerenumeration)
[    4.683796] usbcore: registered new interface driver kobil_sct
[    4.685731] usbserial: USB Serial support registered for KOBIL USB smart=
 card terminal
[    4.688186] usbcore: registered new interface driver metro_usb
[    4.690025] usbserial: USB Serial support registered for Metrologic USB =
to Serial
[    4.692247] usbcore: registered new interface driver mos7720
[    4.694047] usbserial: USB Serial support registered for Moschip 2 port =
adapter
[    4.696243] usbcore: registered new interface driver mxuport
[    4.698041] usbserial: USB Serial support registered for MOXA UPort
[    4.700201] usbcore: registered new interface driver navman
[    4.702060] usbserial: USB Serial support registered for navman
[    4.704115] usbcore: registered new interface driver opticon
[    4.705860] usbserial: USB Serial support registered for opticon
[    4.707706] usbcore: registered new interface driver option
[    4.709458] usbserial: USB Serial support registered for GSM modem (1-po=
rt)
[    4.711537] usbcore: registered new interface driver oti6858
[    4.713158] usbserial: USB Serial support registered for oti6858
[    4.714647] usbcore: registered new interface driver pl2303
[    4.715936] usbserial: USB Serial support registered for pl2303
[    4.717628] usbcore: registered new interface driver qcaux
[    4.719116] usbserial: USB Serial support registered for qcaux
[    4.720796] usbcore: registered new interface driver qcserial
[    4.722412] usbserial: USB Serial support registered for Qualcomm USB mo=
dem
[    4.724218] usbcore: registered new interface driver quatech2
[    4.725674] usbserial: USB Serial support registered for Quatech 2nd gen=
 USB to Serial Driver
[    4.727787] usbcore: registered new interface driver safe_serial
[    4.729174] usbserial: USB Serial support registered for safe_serial
[    4.734269] usbcore: registered new interface driver ti_usb_3410_5052
[    4.735657] usbserial: USB Serial support registered for TI USB 3410 1 p=
ort adapter
[    4.741889] usbserial: USB Serial support registered for TI USB 5052 2 p=
ort adapter
[    4.746186] usbcore: registered new interface driver visor
[    4.749300] usbserial: USB Serial support registered for Handspring Viso=
r / Palm OS
[    4.753703] usbserial: USB Serial support registered for Sony Clie 5.0
[    4.757034] usbserial: USB Serial support registered for Sony Clie 3.5
[    4.760271] usbcore: registered new interface driver whiteheat
[    4.763424] usbserial: USB Serial support registered for Connect Tech - =
WhiteHEAT - (prerenumeration)
[    4.766597] usbserial: USB Serial support registered for Connect Tech - =
WhiteHEAT
[    4.770212] usbcore: registered new interface driver xsens_mt
[    4.773539] usbserial: USB Serial support registered for xsens_mt
[    4.777370] usbcore: registered new interface driver zte_ev
[    4.780821] usbserial: USB Serial support registered for zte_ev
[    4.784156] usbcore: registered new interface driver adutux
[    4.786526] usbcore: registered new interface driver appledisplay
[    4.790943] usbcore: registered new interface driver cypress_cy7c63
[    4.793620] usbcore: registered new interface driver cytherm
[    4.797241] usbcore: registered new interface driver emi26 - firmware lo=
ader
[    4.800473] usbcore: registered new interface driver emi62 - firmware lo=
ader
[    4.804819] usbcore: registered new interface driver iowarrior
[    4.808031] usbcore: registered new interface driver usblcd
[    4.810374] usbcore: registered new interface driver usbled
[    4.814035] usbcore: registered new interface driver legousbtower
[    4.816558] usbcore: registered new interface driver usbtest
[    4.819964] usbcore: registered new interface driver usb_ehset_test
[    4.823570] usbcore: registered new interface driver trancevibrator
[    4.826607] usbcore: registered new interface driver uss720
[    4.830391] uss720: v0.6:USB Parport Cable driver for Cables using the L=
ucent Technologies USS720 Chip
[    4.836032] uss720: NOTE: this is a special purpose driver to allow nons=
tandard
[    4.840320] uss720: protocols (eg. bitbang) over USS720 usb to parallel =
cables
[    4.844697] uss720: If you just want to connect to a printer, use usblp =
instead
[    4.856666] usbcore: registered new interface driver usbsevseg
[    4.858118] usbcore: registered new interface driver sisusb
[    4.859499] usbcore: registered new interface driver cxacru
[    4.860872] usbcore: registered new interface driver speedtch
[    4.862267] usbcore: registered new interface driver ueagle-atm
[    4.863621] xusbatm: malformed module parameters
[    4.864913] i8042: PNP: PS/2 Controller [PNP0303:KBD,PNP0f13:MOU] at 0x6=
0,0x64 irq 1,12
[    4.880982] serio: i8042 KBD port at 0x60,0x64 irq 1
[    4.882272] serio: i8042 AUX port at 0x60,0x64 irq 12
[    4.883562] serio: PARKBD AT adapter on parport0
[    5.054057] mousedev: PS/2 mouse device common for all mice
[    5.055417] evbug: Connected device: input0 (Power Button at LNXPWRBN/bu=
tton/input0)
[    5.057806] input: AT Translated Set 2 keyboard as /devices/platform/i80=
42/serio0/input/input1
[    5.060076] evbug: Connected device: input1 (AT Translated Set 2 keyboar=
d at isa0060/serio0/input0)
[    5.062715] usbcore: registered new interface driver appletouch
[    5.064139] usbcore: registered new interface driver synaptics_usb
[    5.065768] usbcore: registered new interface driver iforce
[    5.067251] usbcore: registered new interface driver xpad
[    5.068547] usbcore: registered new interface driver usb_acecad
[    5.069965] usbcore: registered new interface driver aiptek
[    5.071271] usbcore: registered new interface driver gtco
[    5.072416] usbcore: registered new interface driver kbtab
[    5.073733] usbcore: registered new interface driver wacom
[    5.075375] usbcore: registered new interface driver RobotFuzz Open Sour=
ce InterFace, OSIF
[    5.077368] usbcore: registered new interface driver i2c-tiny-usb
[    5.078956] Colour QuickCam for Video4Linux v0.06
[    5.080088] parport0: no more devices allowed
[    5.081137] c-qcam: couldn't register for parport0.
[    5.082320] parport0: no more devices allowed
[    5.083334] bw-qcam0: couldn't register for parport0.
[    5.084575] usbcore: registered new interface driver radioshark
[    5.086040] usbcore: registered new interface driver radioshark2
[    5.087424] usbcore: registered new interface driver dsbr100
[    5.088706] usbcore: registered new interface driver radio-keene
[    5.090161] usbcore: registered new interface driver radio-ma901
[    5.091630] usbcore: registered new interface driver radio-raremono
[    5.093209] pps pps0: new PPS source ktimer
[    5.094223] pps pps0: ktimer PPS source registered
[    5.095343] pps_ldisc: PPS line discipline registered
[    5.096560] Driver for 1-wire Dallas network protocol.
[    5.097877] usbcore: registered new interface driver DS9490R
[    5.099244] DS1WM w1 busmaster driver - (c) 2004 Szabolcs Gyurko
[    5.102324] pc87360: PC8736x not detected, module not inserted
[    5.103713] sch56xx_common: Unsupported device id: 0xff
[    5.104998] sch56xx_common: Unsupported device id: 0xff
[    5.106618] usbcore: registered new interface driver pcwd_usb
[    5.108016] acquirewdt: WDT driver for Acquire single board computer ini=
tialising
[    5.109865] acquirewdt: I/O address 0x0043 already in use
[    5.111157] acquirewdt: probe of acquirewdt failed with error -5
[    5.112596] alim7101_wdt: Steve Hill <steve@navaho.co.uk>
[    5.113890] alim7101_wdt: ALi M7101 PMU not present - WDT not set
[    5.115316] wafer5823wdt: WDT driver for Wafer 5823 single board compute=
r initialising
[    5.117226] wafer5823wdt: initialized. timeout=3D60 sec (nowayout=3D1)
[    5.118703] i6300esb: Intel 6300ESB WatchDog Timer Driver v0.05
[    5.120264] i6300esb: cannot register miscdev on minor=3D130 (err=3D-16)
[    5.121774] i6300ESB timer: probe of 0000:00:04.0 failed with error -16
[    5.123337] iTCO_wdt: Intel TCO WatchDog Timer Driver v1.11
[    5.124786] it87_wdt: no device
[    5.125586] sc1200wdt: build 20020303
[    5.126512] sc1200wdt: io parameter must be specified
[    5.127865] w83697hf_wdt: WDT driver for W83697HF/HG initializing
[    5.129338] w83697hf_wdt: watchdog not found at address 0x2e
[    5.130831] w83697hf_wdt: No W83697HF/HG could be found
[    5.132042] w83877f_wdt: I/O address 0x0443 already in use
[    5.133345] w83977f_wdt: driver v1.00
[    5.134236] w83977f_wdt: cannot register miscdev on minor=3D130 (err=3D-=
16)
[    5.135784] machzwd: MachZ ZF-Logic Watchdog driver initializing
[    5.137220] machzwd: no ZF-Logic found
[    5.138179] md: linear personality registered for level -1
[    5.139433] md: raid0 personality registered for level 0
[    5.140712] md: raid1 personality registered for level 1
[    5.141982] md: raid10 personality registered for level 10
[    5.143357] md: raid6 personality registered for level 6
[    5.144631] md: raid5 personality registered for level 5
[    5.145890] md: raid4 personality registered for level 4
[    5.147142] md: multipath personality registered for level -4
[    5.148480] md: faulty personality registered for level -5
[    5.149961] device-mapper: ioctl: 4.27.0-ioctl (2013-10-30) initialised:=
 dm-devel@redhat.com
[    5.152064] device-mapper: multipath: version 1.7.0 loaded
[    5.153383] device-mapper: multipath round-robin: version 1.0.0 loaded
[    5.154932] device-mapper: multipath queue-length: version 0.1.0 loaded
[    5.156484] device-mapper: raid: Loading target version 1.5.2
[    5.157873] device-mapper: cache-policy-mq: version 1.2.0 loaded
[    5.159285] device-mapper: cache cleaner: version 1.0.0 loaded
[    5.160670] sdhci: Secure Digital Host Controller Interface driver
[    5.162146] sdhci: Copyright(c) Pierre Ossman
[    5.163311] usbcore: registered new interface driver ushc
[    5.164631] sdhci-pltfm: SDHCI platform and OF driver helper
[    5.166637] dcdbas dcdbas: Dell Systems Management Base Driver (version =
5.6.0-3.2)
[    5.168322] hidraw: raw HID events driver (C) Jiri Kosina
[    5.170186] usbcore: registered new interface driver usbhid
[    5.171479] usbhid: USB HID core driver
[    5.172474] usbcore: registered new interface driver go7007
[    5.173823] usbip_core: usbip_core_init:786: USB/IP Core v1.0.0
[    5.175307] vhci_hcd: vhci_hcd_probe:998: name vhci_hcd id -1
[    5.176677] vhci_hcd vhci_hcd: USB/IP Virtual Host Controller
[    5.178133] vhci_hcd vhci_hcd: new USB bus registered, assigned bus numb=
er 1
[    5.179750] vhci_hcd: vhci_start:882: enter vhci_start
[    5.181254] usb usb1: New USB device found, idVendor=3D1d6b, idProduct=
=3D0002
[    5.182853] usb usb1: New USB device strings: Mfr=3D3, Product=3D2, Seri=
alNumber=3D1
[    5.184521] usb usb1: Product: USB/IP Virtual Host Controller
[    5.185931] usb usb1: Manufacturer: Linux 3.14.0-rc7-11620-gc7d2e32 vhci=
_hcd
[    5.187543] usb usb1: SerialNumber: vhci_hcd
[    5.188763] hub 1-0:1.0: USB hub found
[    5.189690] vhci_hcd: vhci_hub_control:244: typeReq a006 wValue 2900 wIn=
dex 0
[    5.191347] vhci_hcd: vhci_hub_control:302:  GetHubDescriptor
[    5.192696] vhci_hcd: vhci_hub_control:396: port -1
[    5.193863] vhci_hcd: vhci_hub_control:403:  bye
[    5.194988] hub 1-0:1.0: 8 ports detected
[    5.195925] vhci_hcd: vhci_hub_control:244: typeReq a000 wValue 0 wIndex=
 0
[    5.197545] vhci_hcd: vhci_hub_control:306:  GetHubStatus
[    5.198811] vhci_hcd: vhci_hub_control:396: port -1
[    5.199929] vhci_hcd: vhci_hub_control:403:  bye
[    5.201262] vhci_hcd: vhci_hub_control:244: typeReq 2303 wValue 8 wIndex=
 1
[    5.202879] vhci_hcd: vhci_hub_control:382:  SetPortFeature: default 8
[    5.204259] vhci_hcd: vhci_hub_control:396: port 0
[    5.205399] vhci_hcd: dump_port_status_diff:101: status prev -> new: 000=
00000 -> 00000100
[    5.207311] vhci_hcd: dump_port_status_diff:115:  +POWER
[    5.208411] vhci_hcd: dump_port_status_diff:119:=20
[    5.209530] vhci_hcd: vhci_hub_control:403:  bye
[    5.210644] vhci_hcd: vhci_hub_control:244: typeReq 2303 wValue 8 wIndex=
 2
[    5.212235] vhci_hcd: vhci_hub_control:382:  SetPortFeature: default 8
[    5.213749] vhci_hcd: vhci_hub_control:396: port 1
[    5.214885] vhci_hcd: dump_port_status_diff:101: status prev -> new: 000=
00000 -> 00000100
[    5.216746] vhci_hcd: dump_port_status_diff:115:  +POWER
[    5.218006] vhci_hcd: dump_port_status_diff:119:=20
[    5.219118] vhci_hcd: vhci_hub_control:403:  bye
[    5.220141] vhci_hcd: vhci_hub_control:244: typeReq 2303 wValue 8 wIndex=
 3
[    5.221761] vhci_hcd: vhci_hub_control:382:  SetPortFeature: default 8
[    5.223284] vhci_hcd: vhci_hub_control:396: port 2
[    5.224417] vhci_hcd: dump_port_status_diff:101: status prev -> new: 000=
00000 -> 00000100
[    5.226329] vhci_hcd: dump_port_status_diff:115:  +POWER
[    5.227520] vhci_hcd: dump_port_status_diff:119:=20
[    5.228641] vhci_hcd: vhci_hub_control:403:  bye
[    5.229772] vhci_hcd: vhci_hub_control:244: typeReq 2303 wValue 8 wIndex=
 4
[    5.231371] vhci_hcd: vhci_hub_control:382:  SetPortFeature: default 8
[    5.232896] vhci_hcd: vhci_hub_control:396: port 3
[    5.234053] vhci_hcd: dump_port_status_diff:101: status prev -> new: 000=
00000 -> 00000100
[    5.235811] vhci_hcd: dump_port_status_diff:115:  +POWER
[    5.237083] vhci_hcd: dump_port_status_diff:119:=20
[    5.238205] vhci_hcd: vhci_hub_control:403:  bye
[    5.239290] vhci_hcd: vhci_hub_control:244: typeReq 2303 wValue 8 wIndex=
 5
[    5.240779] vhci_hcd: vhci_hub_control:382:  SetPortFeature: default 8
[    5.242319] vhci_hcd: vhci_hub_control:396: port 4
[    5.243419] vhci_hcd: dump_port_status_diff:101: status prev -> new: 000=
00000 -> 00000100
[    5.245348] vhci_hcd: dump_port_status_diff:115:  +POWER
[    5.246605] vhci_hcd: dump_port_status_diff:119:=20
[    5.247678] vhci_hcd: vhci_hub_control:403:  bye
[    5.248796] vhci_hcd: vhci_hub_control:244: typeReq 2303 wValue 8 wIndex=
 6
[    5.250425] vhci_hcd: vhci_hub_control:382:  SetPortFeature: default 8
[    5.251924] vhci_hcd: vhci_hub_control:396: port 5
[    5.253060] vhci_hcd: dump_port_status_diff:101: status prev -> new: 000=
00000 -> 00000100
[    5.254990] vhci_hcd: dump_port_status_diff:115:  +POWER
[    5.256206] vhci_hcd: dump_port_status_diff:119:=20
[    5.257326] vhci_hcd: vhci_hub_control:403:  bye
[    5.258443] vhci_hcd: vhci_hub_control:244: typeReq 2303 wValue 8 wIndex=
 7
[    5.260022] vhci_hcd: vhci_hub_control:382:  SetPortFeature: default 8
[    5.261551] vhci_hcd: vhci_hub_control:396: port 6
[    5.262687] vhci_hcd: dump_port_status_diff:101: status prev -> new: 000=
00000 -> 00000100
[    5.264565] vhci_hcd: dump_port_status_diff:115:  +POWER
[    5.265824] vhci_hcd: dump_port_status_diff:119:=20
[    5.266956] vhci_hcd: vhci_hub_control:403:  bye
[    5.268025] vhci_hcd: vhci_hub_control:244: typeReq 2303 wValue 8 wIndex=
 8
[    5.269642] vhci_hcd: vhci_hub_control:382:  SetPortFeature: default 8
[    5.271182] vhci_hcd: vhci_hub_control:396: port 7
[    5.272295] vhci_hcd: dump_port_status_diff:101: status prev -> new: 000=
00000 -> 00000100
[    5.274201] vhci_hcd: dump_port_status_diff:115:  +POWER
[    5.275422] vhci_hcd: dump_port_status_diff:119:=20
[    5.276536] vhci_hcd: vhci_hub_control:403:  bye
[    5.277767] vhci_hcd: vhci_hcd_probe:1026: bye
[    5.278842] vhci_hcd: vhci_hcd_init:1149: USB/IP 'Virtual' Host Controll=
er (VHCI) Driver v1.0.0
[    5.280882] usbcore: registered new device driver usbip-host
[    5.282239] usbip_host: usbip_host_init:306: USB/IP Host Driver v1.0.0
[    5.283729] parport0: no more devices allowed
[    5.284785] panel: panel_attach: port->number=3D0 parport=3D0, parport_r=
egister_device() failed
[    5.286795] panel: driver version 0.9.5 not yet registered
[    5.288051] usbcore: registered new interface driver rts5139
[    5.289388] rts5208: Initializing Realtek PCIE storage driver...
[    5.290858] usbcore: registered new interface driver line6usb
[    5.292218] usbcore: registered new interface driver serqt_usb2
[    5.293645] usbserial: USB Serial support registered for Quatech USB to =
Serial Driver
[    5.295454] vme_user: VME User Space Access Driver
[    5.296595] vme_user: No cards, skipping registration
[    5.298108] beceem: Beceem Communications Inc. WiMAX driver, 5.2.45
[    5.299514] Copyright 2010. Beceem Communications Inc
[    5.300676] usbcore: registered new interface driver usbbcm
[    5.302114] dgap-1.3-16, Digi International Part Number 40002347_C
[    5.303538] For the tools package please visit http://www.digi.com
[    5.305084] hdaps: supported laptop not found!
[    5.306167] hdaps: driver init failed (ret=3D-19)!
[    5.307861]  fake-fmc-carrier: mezzanine 0
[    5.308856]       Manufacturer: fake-vendor
[    5.309868]       Product name: fake-design-for-testing
[    5.311162] fmc fake-design-for-testing-f001: Driver has no ID: matches =
all
[    5.312774] fmc_trivial: probe of fake-design-for-testing-f001 failed wi=
th error -95
[    5.314623] fmc fake-design-for-testing-f001: Driver has no ID: matches =
all
[    5.316150] fmc_write_eeprom fake-design-for-testing-f001: fmc_write_eep=
rom: no busid passed, refusing all cards
[    5.318531] fmc fake-design-for-testing-f001: Driver has no ID: matches =
all
[    5.320206] fmc_chardev fake-design-for-testing-f001: Created misc devic=
e "fake-design-for-testing-f001"
[    5.322494] intel_rapl: driver does not support CPU family 15 model 6
[    5.324122] Audio Excel DSP 16 init driver Copyright (C) Riccardo Facche=
tti 1995-98
[    5.325954] aedsp16: I/O, IRQ and DMA are mandatory
[    5.327125] MediaTrix audio driver Copyright (C) by Hannu Savolainen 199=
3-1996
[    5.328728] I/O, IRQ, DMA and type are mandatory
[    5.329834] ad1848/cs4248 codec driver Copyright (C) by Hannu Savolainen=
 1993-1996
[    5.331508] ad1848: No ISAPnP cards found, trying standard ones...
[    5.332949] Pro Audio Spectrum driver Copyright (C) by Hannu Savolainen =
1993-1996
[    5.334703] I/O, IRQ, DMA and type are mandatory
[    5.335757] sb: Init: Starting Probe...
[    5.336715] sb: Init: Done
[    5.337511] YM3812 and OPL-3 driver Copyright (C) by Hannu Savolainen, R=
ob Hooft 1993-1996
[    5.340389] ASIHPI driver 4.10.01
[    5.341964] usbcore: registered new interface driver snd-ua101
[    5.343615] usbcore: registered new interface driver snd-usb-usx2y
[    5.345332] usbcore: registered new interface driver snd-usb-caiaq
[    5.346995] usbcore: registered new interface driver snd-usb-6fire
[    5.348738] NET: Registered protocol family 26
[    5.349959] NET: Registered protocol family 15
[    5.351226] NET: Registered protocol family 4
[    5.353005] NET: Registered protocol family 6
[    5.355359] NET: Registered protocol family 11
[    5.356603] NET: Registered protocol family 3
[    5.370649] can: controller area network core (rev 20120528 abi 9)
[    5.372270] NET: Registered protocol family 29
[    5.373300] can: broadcast manager protocol (rev 20120528 t)
[    5.374468] can: netlink gateway (rev 20130117) max_hops=3D1
[    5.375667] NET4: DECnet for Linux: V.2.5.68s (C) 1995-2003 Linux DECnet=
 Project Team
[    5.377317] DECnet: Routing cache hash table of 1024 buckets, 8Kbytes
[    5.378776] NET: Registered protocol family 12
[    5.379899] 8021q: 802.1Q VLAN Support v1.8
[    5.380946] 9pnet: Installing 9P2000 support
[    5.381896] NET: Registered protocol family 37
[    5.386115] Key type dns_resolver registered
[    5.387243] batman_adv: B.A.T.M.A.N. advanced 2014.1.0 (compatibility ve=
rsion 15) loaded
[    5.389116] openvswitch: Open vSwitch switching datapath
[    5.390426] mpls_gso: MPLS GSO support
[    5.392520]=20
[    5.392520] printing PIC contents
[    5.393568] ... PIC  IMR: ffff
[    5.394382] ... PIC  IRR: 9053
[    5.395206] ... PIC  ISR: 0000
[    5.395854] ... PIC ELCR: 0c00
[    5.396665] printing local APIC contents on CPU#0/0:
[    5.397655] ... APIC ID:      00000000 (0)
[    5.397655] ... APIC VERSION: 00050014
[    5.397655] ... APIC TASKPRI: 00000000 (00)
[    5.397655] ... APIC PROCPRI: 00000000
[    5.397655] ... APIC LDR: 01000000
[    5.397655] ... APIC DFR: ffffffff
[    5.397655] ... APIC SPIV: 000001ff
[    5.397655] ... APIC ISR field:
[    5.397655] 000000000000000000000000000000000000000000000000000000000000=
0000
[    5.397655] ... APIC TMR field:
[    5.397655] 000000000200000000000000000000000000000000000000000000000000=
0000
[    5.397655] ... APIC IRR field:
[    5.397655] 000000000000000000000000000000000000000000000000000000000000=
8000
[    5.397655] ... APIC ESR: 00000000
[    5.397655] ... APIC ICR: 000400f6
[    5.397655] ... APIC ICR2: 01000000
[    5.397655] ... APIC LVTT: 000200ef
[    5.397655] ... APIC LVTPC: 00010000
[    5.397655] ... APIC LVT0: 00010700
[    5.397655] ... APIC LVT1: 00000400
[    5.397655] ... APIC LVTERR: 000000fe
[    5.397655] ... APIC TMICT: 0000f422
[    5.397655] ... APIC TMCCT: 0000a308
[    5.397655] ... APIC TDCR: 00000003
[    5.397655]=20
[    5.447997] number of MP IRQ sources: 15.
[    5.449167] number of IO-APIC #0 registers: 24.
[    5.450356] testing the IO APIC.......................
[    5.451911] IO APIC #0......
[    5.452781] .... register #00: 00000000
[    5.453961] .......    : physical APIC id: 00
[    5.455241] .......    : Delivery Type: 0
[    5.456402] .......    : LTS          : 0
[    5.457570] .... register #01: 00170011
[    5.458677] .......     : max redirection entries: 17
[    5.460196] .......     : PRQ implemented: 0
[    5.461398] .......     : IO APIC version: 11
[    5.462658] .... register #02: 00000000
[    5.463811] .......     : arbitration: 00
[    5.464999] .... IRQ redirection table:
[    5.466128] 1    0    0   0   0    0    0    00
[    5.467677] 0    0    0   0   0    1    1    31
[    5.469022] 0    0    0   0   0    1    1    30
[    5.470354] 0    0    0   0   0    1    1    33
[    5.471741] vhci_hcd: vhci_hub_control:244: typeReq a300 wValue 0 wIndex=
 1
[    5.473682] vhci_hcd: vhci_hub_control:310:  GetPortStatus port 1
[    5.475436] vhci_hcd: vhci_hub_control:353:  GetPortStatus bye 100 0
[    5.477375] vhci_hcd: vhci_hub_control:396: port 0
[    5.478756] vhci_hcd: dump_port_status_diff:101: status prev -> new: 000=
00100 -> 00000100
[    5.481138] vhci_hcd: dump_port_status_diff:115:   POWER
[    5.482677] vhci_hcd: dump_port_status_diff:119:=20
[    5.484116] vhci_hcd: vhci_hub_control:403:  bye
[    5.485700] 1    0    0   0   0    1    1    34
[    5.487143] 1    1    0   0   0    1    1    35
[    5.488560] 0    0    0   0   0    1    1    36
[    5.489928] vhci_hcd: vhci_hub_control:244: typeReq a300 wValue 0 wIndex=
 2
[    5.491991] vhci_hcd: vhci_hub_control:310:  GetPortStatus port 2
[    5.493712] vhci_hcd: vhci_hub_control:353:  GetPortStatus bye 100 0
[    5.495620] vhci_hcd: vhci_hub_control:396: port 1
[    5.497010] vhci_hcd: dump_port_status_diff:101: status prev -> new: 000=
00100 -> 00000100
[    5.499399] vhci_hcd: dump_port_status_diff:115:   POWER
[    5.500977] vhci_hcd: dump_port_status_diff:119:=20
[    5.502366] vhci_hcd: vhci_hub_control:403:  bye
[    5.503757] 0    0    0   0   0    1    1    37
[    5.505112] 0    0    0   0   0    1    1    38
[    5.506461] vhci_hcd: vhci_hub_control:244: typeReq a300 wValue 0 wIndex=
 3
[    5.508571] vhci_hcd: vhci_hub_control:310:  GetPortStatus port 3
[    5.510414] vhci_hcd: vhci_hub_control:353:  GetPortStatus bye 100 0
[    5.512317] vhci_hcd: vhci_hub_control:396: port 2
[    5.513768] vhci_hcd: dump_port_status_diff:101: status prev -> new: 000=
00100 -> 00000100
[    5.516481] vhci_hcd: dump_port_status_diff:115:   POWER
[    5.518001] vhci_hcd: dump_port_status_diff:119:=20
[    5.519467] vhci_hcd: vhci_hub_control:403:  bye
[    5.520843] 0    1    0   0   0    1    1    39
[    5.522208] 1    1    0   0   0    1    1    3A
[    5.523593] 1    1    0   0   0    1    1    3B
[    5.524928] 0    0    0   0   0    1    1    3C
[    5.526244] 0    0    0   0   0    1    1    3D
[    5.527678] 0    0    0   0   0    1    1    3E
[    5.529013] 0    0    0   0   0    1    1    3F
[    5.530407] 1    0    0   0   0    0    0    00
[    5.531785] 1    0    0   0   0    0    0    00
[    5.533102] 1    0    0   0   0    0    0    00
[    5.534458] vhci_hcd: vhci_hub_control:244: typeReq a300 wValue 0 wIndex=
 4
[    5.536512] vhci_hcd: vhci_hub_control:310:  GetPortStatus port 4
[    5.538363] vhci_hcd: vhci_hub_control:353:  GetPortStatus bye 100 0
[    5.540294] vhci_hcd: vhci_hub_control:396: port 3
[    5.541751] vhci_hcd: dump_port_status_diff:101: status prev -> new: 000=
00100 -> 00000100
[    5.544274] vhci_hcd: dump_port_status_diff:115:   POWER
[    5.546056] vhci_hcd: dump_port_status_diff:119:=20
[    5.547597] vhci_hcd: vhci_hub_control:403:  bye
[    5.548975] 1    0    0   0   0    0    0    00
[    5.550352] 1    0    0   0   0    0    0    00
[    5.551745] 1    0    0   0   0    0    0    00
[    5.553076] vhci_hcd: vhci_hub_control:244: typeReq a300 wValue 0 wIndex=
 5
[    5.555006] vhci_hcd: vhci_hub_control:310:  GetPortStatus port 5
[    5.556786] vhci_hcd: vhci_hub_control:353:  GetPortStatus bye 100 0
[    5.558647] vhci_hcd: vhci_hub_control:396: port 4
[    5.560110] vhci_hcd: dump_port_status_diff:101: status prev -> new: 000=
00100 -> 00000100
[    5.562402] vhci_hcd: dump_port_status_diff:115:   POWER
[    5.564065] vhci_hcd: dump_port_status_diff:119:=20
[    5.565379] vhci_hcd: vhci_hub_control:403:  bye
[    5.566975] 1    0    0   0   0    0    0    00
[    5.568524] 1    0    0   0   0    0    0    00
[    5.569883] vhci_hcd: vhci_hub_control:244: typeReq a300 wValue 0 wIndex=
 6
[    5.572080] IRQ to pin mappings:
[    5.573017] IRQ0 -> 0:2
[    5.573793] IRQ1=20
[    5.574356] vhci_hcd: vhci_hub_control:310:  GetPortStatus port 6
[    5.576275] vhci_hcd: vhci_hub_control:353:  GetPortStatus bye 100 0
[    5.578114] vhci_hcd: vhci_hub_control:396: port 5
[    5.579534] vhci_hcd: dump_port_status_diff:101: status prev -> new: 000=
00100 -> 00000100
[    5.581855] vhci_hcd: dump_port_status_diff:115:   POWER
[    5.583470] vhci_hcd: dump_port_status_diff:119:=20
[    5.584853] vhci_hcd: vhci_hub_control:403:  bye
[    5.586247] -> 0:1
[    5.586915] IRQ3 -> 0:3
[    5.587740] IRQ4 -> 0:4
[    5.588605] IRQ5 -> 0:5
[    5.589383] IRQ6 -> 0:6
[    5.590159] IRQ7 -> 0:7
[    5.590954] IRQ8 -> 0:8
[    5.591816] IRQ9 -> 0:9
[    5.592761] IRQ10 -> 0:10
[    5.593578] IRQ11 -> 0:11
[    5.594475] IRQ12 -> 0:12
[    5.595339] IRQ13 -> 0:13
[    5.596223] vhci_hcd: vhci_hub_control:244: typeReq a300 wValue 0 wIndex=
 7
[    5.598195] IRQ14 -> 0:14
[    5.599057] IRQ15 -> 0:15
[    5.599958] .................................... done.
[    5.601484] vhci_hcd: vhci_hub_control:310:  GetPortStatus port 7
[    5.603359] vhci_hcd: vhci_hub_control:353:  GetPortStatus bye 100 0
[    5.605427] vhci_hcd: vhci_hub_control:396: port 6
[    5.606772] vhci_hcd: dump_port_status_diff:101: status prev -> new: 000=
00100 -> 00000100
[    5.609157] vhci_hcd: dump_port_status_diff:115:   POWER
[    5.610758] vhci_hcd: dump_port_status_diff:119:=20
[    5.612206] vhci_hcd: vhci_hub_control:403:  bye
[    5.613487] vhci_hcd: vhci_hub_control:244: typeReq a300 wValue 0 wIndex=
 8
[    5.615475] vhci_hcd: vhci_hub_control:310:  GetPortStatus port 8
[    5.617273] vhci_hcd: vhci_hub_control:353:  GetPortStatus bye 100 0
[    5.619123] vhci_hcd: vhci_hub_control:396: port 7
[    5.620602] vhci_hcd: dump_port_status_diff:101: status prev -> new: 000=
00100 -> 00000100
[    5.622940] vhci_hcd: dump_port_status_diff:115:   POWER
[    5.624533] vhci_hcd: dump_port_status_diff:119:=20
[    5.625856] vhci_hcd: vhci_hub_control:403:  bye
[    5.627344] Loading compiled-in X.509 certificates
[    5.628937] Key type encrypted registered
[    5.630283] usb usb1: vhci_bus_suspend
[    5.631516] ima: No TPM chip found, activating TPM-bypass!
[    5.633575] register_blkdev: cannot get major 3 for hd
[    5.635174] BIOS EDD facility v0.16 2004-Jun-25, 0 devices found
[    5.636985] EDD information not available.
[    5.638173] ALSA device list:
[    5.639094]   No soundcards found.
[    5.642914] Freeing unused kernel memory: 1660K (ffffffff8240d000 - ffff=
ffff825ac000)
/etc/rcS.d/S00fbsetup: line 3: /sbin/modprobe: not found

Please wait: booting...
Starting udev
/etc/rcS.d/S03udev: line 72: can't create /proc/sys/kernel/hotplug: nonexis=
tent directory
[    5.993023] block nbd10: Attempted send on closed socket
[    5.995485] block nbd11: Attempted send on closed socket
[    6.017881] block nbd0: Attempted send on closed socket
[    6.036698] block nbd12: Attempted send on closed socket
[    6.038414] block nbd13: Attempted send on closed socket
[    6.045739] block nbd15: Attempted send on closed socket
[    6.049835] block nbd14: Attempted send on closed socket
[    6.080239] block nbd1: Attempted send on closed socket
[    6.117304] block nbd3: Attempted send on closed socket
[    6.158065] end_request: I/O error, dev nbd10, sector 0
[    6.173609] block nbd2: Attempted send on closed socket
[    6.176821] block nbd7: Attempted send on closed socket
[    6.181844] end_request: I/O error, dev nbd13, sector 0
[    6.202013] end_request: I/O error, dev nbd11, sector 0
[    6.206828] block nbd8: Attempted send on closed socket
[    6.210709] block nbd6: Attempted send on closed socket
[    6.220395] end_request: I/O error, dev nbd0, sector 0
[    6.226295] end_request: I/O error, dev nbd1, sector 0
[    6.227250] random: nonblocking pool is initialized
[    6.244156] end_request: I/O error, dev nbd12, sector 0
[    6.249392] end_request: I/O error, dev nbd14, sector 0
[    6.261801] end_request: I/O error, dev nbd15, sector 0
[    6.270165] block nbd9: Attempted send on closed socket
[    6.281269] FAT-fs (nbd11): unable to read boot sector
[    6.284784] FAT-fs (nbd13): unable to read boot sector
[    6.295002] end_request: I/O error, dev nbd7, sector 0
[    6.297874] block nbd4: Attempted send on closed socket
[    6.302818] block nbd5: Attempted send on closed socket
[    6.306646] end_request: I/O error, dev nbd2, sector 0
[    6.311443] FAT-fs (nbd8): unable to read boot sector
[    6.317389] FAT-fs (nbd0): unable to read boot sector
[    6.328429] FAT-fs (nbd14): unable to read boot sector
[    6.334392] FAT-fs (nbd15): unable to read boot sector
[    6.336973] block nbd0: Attempted send on closed socket
[    6.340763] block nbd13: Attempted send on closed socket
[    6.343665] FAT-fs (nbd12): unable to read boot sector
[    6.348529] FAT-fs (nbd7): unable to read boot sector
[    6.352611] block nbd11: Attempted send on closed socket
[    6.393234] floppy: error -5 while reading block 0
[    6.396633] FAT-fs (nbd4): unable to read boot sector
[    6.399522] block nbd8: Attempted send on closed socket
[    6.402535] FAT-fs (nbd2): unable to read boot sector
[    6.407039] FAT-fs (nbd1): unable to read boot sector
[    6.412431] FAT-fs (nbd5): unable to read boot sector
[    6.414795] FAT-fs (nbd6): unable to read boot sector
[    6.421412] FAT-fs (nbd9): unable to read boot sector
[    6.433235] floppy: error -5 while reading block 0
[    6.437242] block nbd14: Attempted send on closed socket
[    6.443363] block nbd7: Attempted send on closed socket
[    6.445753] MINIX-fs: unable to read superblock
[    6.449028] block nbd2: Attempted send on closed socket
[    6.451422] block nbd12: Attempted send on closed socket
[    6.453770] block nbd15: Attempted send on closed socket
[    6.457281] block nbd4: Attempted send on closed socket
[    6.467246] floppy: error -5 while reading block 0
[    6.471793] MINIX-fs: unable to read superblock
[    6.474085] MINIX-fs: unable to read superblock
[    6.477487] block nbd5: Attempted send on closed socket
[    6.481461] block nbd6: Attempted send on closed socket
[    6.483835] MINIX-fs: unable to read superblock
[    6.493660] block nbd1: Attempted send on closed socket
[    6.497906] MINIX-fs: unable to read superblock
[    6.500127] floppy: error -5 while reading block 0
[    6.502619] block nbd9: Attempted send on closed socket
[    6.506113] MINIX-fs: unable to read superblock
[    6.510853] MINIX-fs: unable to read superblock
[    6.513070] MINIX-fs: unable to read superblock
[    6.517229] MINIX-fs: unable to read superblock
[    6.519563] block nbd11: Attempted send on closed socket
[    6.523147] block nbd8: Attempted send on closed socket
[    6.525546] FAT-fs (nbd3): unable to read boot sector
[    6.528488] block nbd13: Attempted send on closed socket
[    6.530885] MINIX-fs: unable to read superblock
[    6.534170] MINIX-fs: unable to read superblock
[    6.544337] floppy: error -5 while reading block 0
[    6.548358] MINIX-fs: unable to read superblock
[    6.550665] MINIX-fs: unable to read superblock
[    6.552945] block nbd0: Attempted send on closed socket
[    6.555387] block nbd14: Attempted send on closed socket
[    6.565404] block nbd2: Attempted send on closed socket
[    6.568956] block nbd12: Attempted send on closed socket
[    6.572763] block nbd4: Attempted send on closed socket
[    6.577221] floppy: error -5 while reading block 0
[    6.580896] block nbd6: Attempted send on closed socket
[    6.583376] REISERFS warning (device nbd8): sh-2006 read_super_block: br=
ead failed (dev nbd8, block 2, size 4096)
[    6.594048] REISERFS warning (device nbd13): sh-2006 read_super_block: b=
read failed (dev nbd13, block 2, size 4096)
[    6.598307] MINIX-fs: unable to read superblock
[    6.606700] block nbd3: Attempted send on closed socket
[    6.611533] block nbd1: Attempted send on closed socket
[    6.616626] block nbd5: Attempted send on closed socket
[    6.619109] floppy: error -5 while reading block 0
[    6.622677] REISERFS warning (device nbd0): sh-2006 read_super_block: br=
ead failed (dev nbd0, block 2, size 4096)
[    6.630850] block nbd7: Attempted send on closed socket
[    6.634495] FAT-fs (nbd10): unable to read boot sector
[    6.636467] REISERFS warning (device nbd11): sh-2006 read_super_block: b=
read failed (dev nbd11, block 2, size 4096)
[    6.645289] REISERFS warning (device nbd12): sh-2006 read_super_block: b=
read failed (dev nbd12, block 2, size 4096)
[    6.666419] block nbd15: Attempted send on closed socket
[    6.671219] floppy: error -5 while reading block 0
[    6.675478] REISERFS warning (device nbd4): sh-2006 read_super_block: br=
ead failed (dev nbd4, block 2, size 4096)
[    6.687896] REISERFS warning (device nbd14): sh-2006 read_super_block: b=
read failed (dev nbd14, block 2, size 4096)
[    6.694797] block nbd9: Attempted send on closed socket
[    6.698651] REISERFS warning (device nbd6): sh-2006 read_super_block: br=
ead failed (dev nbd6, block 2, size 4096)
[    6.701308] REISERFS warning (device nbd2): sh-2006 read_super_block: br=
ead failed (dev nbd2, block 2, size 4096)
[    6.711412] block nbd10: Attempted send on closed socket
[    6.715856] floppy: error -5 while reading block 0
[    6.729342] block nbd13: Attempted send on closed socket
[    6.731571] REISERFS warning (device nbd15): sh-2006 read_super_block: b=
read failed (dev nbd15, block 2, size 4096)
[    6.737309] MINIX-fs: unable to read superblock
[    6.739476] REISERFS warning (device nbd7): sh-2006 read_super_block: br=
ead failed (dev nbd7, block 2, size 4096)
[    6.745273] REISERFS warning (device nbd1): sh-2006 read_super_block: br=
ead failed (dev nbd1, block 2, size 4096)
[    6.751156] REISERFS warning (device nbd9): sh-2006 read_super_block: br=
ead failed (dev nbd9, block 2, size 4096)
[    6.759218] floppy: error -5 while reading block 0
[    6.764139] REISERFS warning (device nbd5): sh-2006 read_super_block: br=
ead failed (dev nbd5, block 2, size 4096)
[    6.779298] block nbd6: Attempted send on closed socket
[    6.783416] block nbd8: Attempted send on closed socket
[    6.789502] block nbd11: Attempted send on closed socket
[    6.807569] REISERFS warning (device nbd13): sh-2006 read_super_block: b=
read failed (dev nbd13, block 16, size 4096)
[    6.812913] block nbd3: Attempted send on closed socket
[    6.816609] block nbd4: Attempted send on closed socket
[    6.818975] floppy: error -5 while reading block 0
[    6.827870] REISERFS warning (device nbd3): sh-2006 read_super_block: br=
ead failed (dev nbd3, block 2, size 4096)
[    6.830645] MINIX-fs: unable to read superblock
[    6.834566] block nbd14: Attempted send on closed socket
[    6.839286] REISERFS warning (device nbd8): sh-2006 read_super_block: br=
ead failed (dev nbd8, block 16, size 4096)
[    6.842267] REISERFS warning (device nbd11): sh-2006 read_super_block: b=
read failed (dev nbd11, block 16, size 4096)
[    6.846274] floppy: error -5 while reading block 0
[    6.849190] REISERFS warning (device nbd6): sh-2006 read_super_block: br=
ead failed (dev nbd6, block 16, size 4096)
[    6.858635] REISERFS warning (device nbd4): sh-2006 read_super_block: br=
ead failed (dev nbd4, block 16, size 4096)
[    6.861280] block nbd0: Attempted send on closed socket
[    6.862706] block nbd10: Attempted send on closed socket
[    6.864101] REISERFS warning (device nbd14): sh-2006 read_super_block: b=
read failed (dev nbd14, block 16, size 4096)
[    6.871547] block nbd1: Attempted send on closed socket
[    6.873137] floppy: error -5 while reading block 0
[    6.878890] block nbd15: Attempted send on closed socket
[    6.880333] block nbd3: Attempted send on closed socket
[    6.881711] block nbd2: Attempted send on closed socket
[    6.885579] block nbd7: Attempted send on closed socket
[    6.886906] REISERFS warning (device nbd0): sh-2006 read_super_block: br=
ead failed (dev nbd0, block 16, size 4096)
[    6.891952] REISERFS warning (device nbd10): sh-2006 read_super_block: b=
read failed (dev nbd10, block 2, size 4096)
[    6.895782] block nbd5: Attempted send on closed socket
[    6.899939] block nbd8: Attempted send on closed socket
[    6.901291] floppy: error -5 while reading block 0
[    6.902800] block nbd11: Attempted send on closed socket
[    6.905341] block nbd13: Attempted send on closed socket
[    6.906816] REISERFS warning (device nbd1): sh-2006 read_super_block: br=
ead failed (dev nbd1, block 16, size 4096)
[    6.912778] block nbd6: Attempted send on closed socket
[    6.914111] REISERFS warning (device nbd15): sh-2006 read_super_block: b=
read failed (dev nbd15, block 16, size 4096)
[    6.916715] block nbd9: Attempted send on closed socket
[    6.918316] REISERFS warning (device nbd3): sh-2006 read_super_block: br=
ead failed (dev nbd3, block 16, size 4096)
[    6.926426] REISERFS warning (device nbd2): sh-2006 read_super_block: br=
ead failed (dev nbd2, block 16, size 4096)
[    6.929204] floppy: error -5 while reading block 0
[    6.931273] block nbd4: Attempted send on closed socket
[    6.932772] REISERFS warning (device nbd7): sh-2006 read_super_block: br=
ead failed (dev nbd7, block 16, size 4096)
[    6.937263] block nbd14: Attempted send on closed socket
[    6.938762] REISERFS warning (device nbd5): sh-2006 read_super_block: br=
ead failed (dev nbd5, block 16, size 4096)
[    6.949716] MINIX-fs: unable to read superblock
[    6.951362] MINIX-fs: unable to read superblock
[    6.953111] REISERFS warning (device nbd9): sh-2006 read_super_block: br=
ead failed (dev nbd9, block 16, size 4096)
[    6.955947] MINIX-fs: unable to read superblock
[    6.957142] floppy: error -5 while reading block 0
[    6.958627] MINIX-fs: unable to read superblock
[    6.959979] block nbd0: Attempted send on closed socket
[    6.961413] MINIX-fs: unable to read superblock
[    6.962603] block nbd10: Attempted send on closed socket
[    6.971250] block nbd1: Attempted send on closed socket
[    6.972714] block nbd13: Attempted send on closed socket
[    6.974279] MINIX-fs: unable to read superblock
[    6.975695] block nbd8: Attempted send on closed socket
[    6.977209] block nbd11: Attempted send on closed socket
[    6.978688] block nbd15: Attempted send on closed socket
[    6.980199] floppy: error -5 while reading block 0
[    6.981776] block nbd6: Attempted send on closed socket
[    6.987808] block nbd3: Attempted send on closed socket
[    6.989296] block nbd2: Attempted send on closed socket
[    6.990748] block nbd4: Attempted send on closed socket
[    6.999428] MINIX-fs: unable to read superblock
[    7.000793] block nbd7: Attempted send on closed socket
[    7.002790] REISERFS warning (device nbd10): sh-2006 read_super_block: b=
read failed (dev nbd10, block 16, size 4096)
[    7.007206] floppy: error -5 while reading block 0
[    7.008753] block nbd5: Attempted send on closed socket
[    7.010479] block nbd14: Attempted send on closed socket
[    7.012009] MINIX-fs: unable to read superblock
[    7.013274] FAT-fs (nbd11): unable to read boot sector
[    7.014654] FAT-fs (nbd8): unable to read boot sector
[    7.016032] FAT-fs (nbd13): unable to read boot sector
[    7.017482] block nbd9: Attempted send on closed socket
[    7.018912] MINIX-fs: unable to read superblock
[    7.020367] FAT-fs (nbd6): unable to read boot sector
[    7.026681] MINIX-fs: unable to read superblock
[    7.027952] MINIX-fs: unable to read superblock
[    7.029143] FAT-fs (nbd4): unable to read boot sector
[    7.030694] block nbd0: Attempted send on closed socket
[    7.033215] floppy: error -5 while reading block 0
[    7.035768] MINIX-fs: unable to read superblock
[    7.040577] block nbd1: Attempted send on closed socket
[    7.042126] block nbd15: Attempted send on closed socket
[    7.043617] MINIX-fs: unable to read superblock
[    7.044860] block nbd11: Attempted send on closed socket
[    7.046341] block nbd8: Attempted send on closed socket
[    7.047801] block nbd13: Attempted send on closed socket
[    7.049220] FAT-fs (nbd14): unable to read boot sector
[    7.052827] MINIX-fs: unable to read superblock
[    7.054089] block nbd6: Attempted send on closed socket
[    7.055610] block nbd3: Attempted send on closed socket
[    7.057021] block nbd2: Attempted send on closed socket
[    7.059361] floppy: error -5 while reading block 0
[    7.065352] block nbd4: Attempted send on closed socket
[    7.066996] block nbd10: Attempted send on closed socket
[    7.070563] block nbd7: Attempted send on closed socket
[    7.072230] FAT-fs (nbd7): unable to read boot sector
[    7.073631] FAT-fs (nbd0): unable to read boot sector
[    7.075030] block nbd5: Attempted send on closed socket
[    7.082213] floppy: error -5 while reading block 0
[    7.105389] FAT-fs (nbd1): unable to read boot sector
[    7.108613] FAT-fs (nbd15): unable to read boot sector
[    7.110000] FAT-fs (nbd11): unable to read boot sector
[    7.111366] FAT-fs (nbd8): unable to read boot sector
[    7.112839] block nbd9: Attempted send on closed socket
[    7.114367] FAT-fs (nbd13): unable to read boot sector
[    7.115912] block nbd14: Attempted send on closed socket
[    7.117363] FAT-fs (nbd3): unable to read boot sector
[    7.118722] FAT-fs (nbd6): unable to read boot sector
[    7.124066] FAT-fs (nbd2): unable to read boot sector
[    7.128473] block nbd0: Attempted send on closed socket
[    7.129841] MINIX-fs: unable to read superblock
[    7.131176] FAT-fs (nbd4): unable to read boot sector
[    7.134598] FAT-fs (nbd5): unable to read boot sector
[    7.137542] block nbd15: Attempted send on closed socket
[    7.139055] block nbd11: Attempted send on closed socket
[    7.140704] block nbd8: Attempted send on closed socket
[    7.148357] block nbd13: Attempted send on closed socket
[    7.149885] block nbd7: Attempted send on closed socket
[    7.151564] FAT-fs (nbd14): unable to read boot sector
[    7.153102] FAT-fs (nbd9): unable to read boot sector
[    7.154580] block nbd3: Attempted send on closed socket
[    7.155959] block nbd12: Attempted send on closed socket
[    7.157837] block nbd6: Attempted send on closed socket
[    7.159397] block nbd2: Attempted send on closed socket
[    7.162251] block nbd10: Attempted send on closed socket
[    7.164514] FAT-fs (nbd0): unable to read boot sector
[    7.167714] block nbd4: Attempted send on closed socket
[    7.169209] block nbd5: Attempted send on closed socket
[    7.181252] FAT-fs (nbd15): unable to read boot sector
[    7.183317] block nbd14: Attempted send on closed socket
[    7.185746] FAT-fs (nbd7): unable to read boot sector
[    7.187632] block nbd8: Attempted send on closed socket
[    7.189239] block nbd11: Attempted send on closed socket
[    7.191179] block nbd9: Attempted send on closed socket
[    7.192675] block nbd13: Attempted send on closed socket
[    7.194344] FAT-fs (nbd3): unable to read boot sector
[    7.195902] block nbd1: Attempted send on closed socket
[    7.197484] block nbd6: Attempted send on closed socket
[    7.198861] FAT-fs (nbd2): unable to read boot sector
[    7.201190] REISERFS warning (device nbd12): sh-2006 read_super_block: b=
read failed (dev nbd12, block 16, size 4096)
[    7.204082] FAT-fs (nbd10): unable to read boot sector
[    7.205610] block nbd0: Attempted send on closed socket
[    7.207217] block nbd4: Attempted send on closed socket
[    7.208761] FAT-fs (nbd5): unable to read boot sector
[    7.215673] block nbd15: Attempted send on closed socket
[    7.217276] block nbd14: Attempted send on closed socket
[    7.218785] block nbd7: Attempted send on closed socket
[    7.226033] FAT-fs (nbd9): unable to read boot sector
[    7.227520] block nbd8: Attempted send on closed socket
[    7.229100] block nbd3: Attempted send on closed socket
[    7.230707] block nbd11: Attempted send on closed socket
[    7.232170] FAT-fs (nbd1): unable to read boot sector
[    7.233578] block nbd13: Attempted send on closed socket
[    7.235210] block nbd6: Attempted send on closed socket
[    7.236829] block nbd2: Attempted send on closed socket
[    7.238476] block nbd10: Attempted send on closed socket
[    7.241762] block nbd0: Attempted send on closed socket
[    7.244835] block nbd5: Attempted send on closed socket
[    7.246469] block nbd4: Attempted send on closed socket
[    7.250231] block nbd9: Attempted send on closed socket
[    7.251709] block nbd7: Attempted send on closed socket
[    7.253176] block nbd15: Attempted send on closed socket
[    7.254749] block nbd14: Attempted send on closed socket
[    7.256379] block nbd1: Attempted send on closed socket
[    7.257967] block nbd11: Attempted send on closed socket
[    7.259536] block nbd3: Attempted send on closed socket
[    7.261036] block nbd8: Attempted send on closed socket
[    7.262911] block nbd13: Attempted send on closed socket
[    7.264473] block nbd6: Attempted send on closed socket
[    7.266037] block nbd12: Attempted send on closed socket
[    7.267609] block nbd2: Attempted send on closed socket
[    7.269178] FAT-fs (nbd10): unable to read boot sector
[    7.271096] block nbd0: Attempted send on closed socket
[    7.272651] block nbd5: Attempted send on closed socket
[    7.274149] block nbd4: Attempted send on closed socket
[    7.278231] block nbd9: Attempted send on closed socket
[    7.279803] block nbd7: Attempted send on closed socket
[    7.281336] block nbd15: Attempted send on closed socket
[    7.282944] block nbd14: Attempted send on closed socket
[    7.284680] block nbd11: Attempted send on closed socket
[    7.286247] block nbd1: Attempted send on closed socket
[    7.287810] block nbd3: Attempted send on closed socket
[    7.289298] block nbd13: Attempted send on closed socket
[    7.290829] block nbd6: Attempted send on closed socket
[    7.292303] MINIX-fs: unable to read superblock
[    7.293814] block nbd2: Attempted send on closed socket
[    7.295696] block nbd8: Attempted send on closed socket
[    7.297186] block nbd0: Attempted send on closed socket
[    7.299146] block nbd5: Attempted send on closed socket
[    7.301064] block nbd10: Attempted send on closed socket
[    7.302972] block nbd4: Attempted send on closed socket
[    7.304897] block nbd9: Attempted send on closed socket
[    7.306766] block nbd7: Attempted send on closed socket
[    7.308497] block nbd15: Attempted send on closed socket
[    7.310099] block nbd11: Attempted send on closed socket
[    7.311684] block nbd1: Attempted send on closed socket
[    7.313308] block nbd3: Attempted send on closed socket
[    7.316181] block nbd14: Attempted send on closed socket
[    7.317736] block nbd13: Attempted send on closed socket
[    7.319254] block nbd6: Attempted send on closed socket
[    7.321211] block nbd12: Attempted send on closed socket
[    7.322784] block nbd8: Attempted send on closed socket
[    7.324253] block nbd2: Attempted send on closed socket
[    7.325751] block nbd0: Attempted send on closed socket
[    7.329182] block nbd5: Attempted send on closed socket
[    7.330696] block nbd4: Attempted send on closed socket
[    7.332560] block nbd10: Attempted send on closed socket
[    7.334507] block nbd7: Attempted send on closed socket
[    7.336339] block nbd11: Attempted send on closed socket
[    7.338264] block nbd15: Attempted send on closed socket
[    7.340191] block nbd9: Attempted send on closed socket
[    7.341863] block nbd1: Attempted send on closed socket
[    7.343551] block nbd14: Attempted send on closed socket
[    7.345206] block nbd13: Attempted send on closed socket
[    7.346983] block nbd8: Attempted send on closed socket
[    7.348852] block nbd3: Attempted send on closed socket
[    7.350661] FAT-fs (nbd12): unable to read boot sector
[    7.352485] block nbd6: Attempted send on closed socket
[    7.354347] block nbd0: Attempted send on closed socket
[    7.356218] block nbd2: Attempted send on closed socket
[    7.359248] block nbd5: Attempted send on closed socket
[    7.360845] block nbd4: Attempted send on closed socket
[    7.362401] block nbd7: Attempted send on closed socket
[    7.363990] block nbd9: Attempted send on closed socket
[    7.365688] block nbd10: Attempted send on closed socket
[    7.367259] block nbd14: Attempted send on closed socket
[    7.368826] block nbd1: Attempted send on closed socket
[    7.370350] block nbd11: Attempted send on closed socket
[    7.371898] block nbd13: Attempted send on closed socket
[    7.373414] block nbd15: Attempted send on closed socket
[    7.375056] block nbd12: Attempted send on closed socket
[    7.378525] block nbd3: Attempted send on closed socket
[    7.380043] block nbd8: Attempted send on closed socket
[    7.381598] block nbd2: Attempted send on closed socket
[    7.383096] block nbd0: Attempted send on closed socket
[    7.384622] block nbd6: Attempted send on closed socket
[    7.386134] block nbd5: Attempted send on closed socket
[    7.387677] block nbd4: Attempted send on closed socket
[    7.389185] block nbd7: Attempted send on closed socket
[    7.390724] block nbd1: Attempted send on closed socket
[    7.392224] block nbd9: Attempted send on closed socket
[    7.393841] block nbd14: Attempted send on closed socket
[    7.395361] block nbd10: Attempted send on closed socket
[    7.396988] block nbd13: Attempted send on closed socket
[    7.398613] block nbd11: Attempted send on closed socket
[    7.400153] block nbd15: Attempted send on closed socket
[    7.401720] block nbd3: Attempted send on closed socket
[    7.404232] block nbd8: Attempted send on closed socket
[    7.405773] FAT-fs (nbd12): unable to read boot sector
[    7.407266] block nbd2: Attempted send on closed socket
[    7.408842] block nbd6: Attempted send on closed socket
[    7.410370] block nbd0: Attempted send on closed socket
[    7.411957] block nbd4: Attempted send on closed socket
[    7.413514] block nbd5: Attempted send on closed socket
[    7.416224] block nbd7: Attempted send on closed socket
[    7.417778] block nbd1: Attempted send on closed socket
[    7.419332] block nbd14: Attempted send on closed socket
[    7.420905] block nbd10: Attempted send on closed socket
[    7.422432] block nbd9: Attempted send on closed socket
[    7.423966] VFS: could not find a valid V7 on nbd11.
[    7.425379] block nbd15: Attempted send on closed socket
[    7.426941] VFS: could not find a valid V7 on nbd13.
[    7.428364] block nbd3: Attempted send on closed socket
[    7.430272] block nbd12: Attempted send on closed socket
[    7.431850] VFS: could not find a valid V7 on nbd8.
[    7.433260] block nbd2: Attempted send on closed socket
[    7.434857] block nbd0: Attempted send on closed socket
[    7.436365] VFS: could not find a valid V7 on nbd6.
[    7.437817] VFS: could not find a valid V7 on nbd4.
[    7.440219] block nbd5: Attempted send on closed socket
[    7.441807] block nbd3: Attempted send on closed socket
[    7.443324] block nbd1: Attempted send on closed socket
[    7.444903] block nbd7: Attempted send on closed socket
[    7.446505] block nbd11: Attempted send on closed socket
[    7.448052] block nbd10: Attempted send on closed socket
[    7.449626] block nbd9: Attempted send on closed socket
[    7.451192] block nbd13: Attempted send on closed socket
[    7.452730] VFS: could not find a valid V7 on nbd14.
[    7.454219] block nbd15: Attempted send on closed socket
[    7.455817] block nbd8: Attempted send on closed socket
[    7.457362] block nbd12: Attempted send on closed socket
[    7.460225] block nbd6: Attempted send on closed socket
[    7.461817] block nbd2: Attempted send on closed socket
[    7.463317] VFS: could not find a valid V7 on nbd0.
[    7.464808] block nbd4: Attempted send on closed socket
[    7.466365] block nbd5: Attempted send on closed socket
[    7.467903] VFS: could not find a valid V7 on nbd3.
[    7.469357] block nbd1: Attempted send on closed socket
[    7.470895] VFS: could not find a valid V7 on nbd7.
[    7.472365] block nbd14: Attempted send on closed socket
[    7.474241] block nbd9: Attempted send on closed socket
[    7.475781] block nbd10: Attempted send on closed socket
[    7.477306] HPFS: hpfs_map_sector: read error
[    7.480170] HPFS: hpfs_map_sector: read error
[    7.481783] HPFS: hpfs_map_sector: read error
[    7.483054] VFS: could not find a valid V7 on nbd15.
[    7.484582] block nbd12: Attempted send on closed socket
[    7.486184] block nbd0: Attempted send on closed socket
[    7.487713] VFS: could not find a valid V7 on nbd2.
[    7.489107] HPFS: hpfs_map_sector: read error
[    7.490372] HPFS: hpfs_map_sector: read error
[    7.491657] VFS: could not find a valid V7 on nbd5.
[    7.493116] block nbd3: Attempted send on closed socket
[    7.494829] UFSD (fs/ufs/super.c, 787): ufs_fill_super:
[    7.497042] block nbd7: Attempted send on closed socket
[    7.498718] UFSD (fs/ufs/super.c, 787): ufs_fill_super:
[    7.500886] VFS: could not find a valid V7 on nbd1.
[    7.502400] floppy: error -5 while reading block 0
[    7.503810] gfs2: gfs2 mount does not exist
[    7.505409] UFSD (fs/ufs/super.c, 787): ufs_fill_super:
[    7.507636] HPFS: hpfs_map_sector: read error
[    7.508992] block nbd10: Attempted send on closed socket
[    7.510553] VFS: could not find a valid V7 on nbd9.
[    7.513227] block nbd15: Attempted send on closed socket
[    7.514859] UFSD (fs/ufs/super.c, 787): ufs_fill_super:
[    7.517079] block nbd2: Attempted send on closed socket
[    7.518715] block nbd12: Attempted send on closed socket
[    7.520238] HPFS: hpfs_map_sector: read error
[    7.521596] UFSD (fs/ufs/super.c, 787): ufs_fill_super:
[    7.523801] block nbd5: Attempted send on closed socket
[    7.525389] HPFS: hpfs_map_sector: read error
[    7.528227] UFSD (fs/ufs/super.c, 787): ufs_fill_super:
[    7.530461] block nbd1: Attempted send on closed socket
[    7.532426] block nbd9: Attempted send on closed socket
[    7.534012] floppy: error -5 while reading block 0
[    7.535724] HPFS: hpfs_map_sector: read error
[    7.537213] block nbd10: Attempted send on closed socket
[    7.538781] HPFS: hpfs_map_sector: read error
[    7.540048] ENTER
[    7.540660] UFSD (fs/ufs/super.c, 795): ufs_fill_super:
[    7.542859] UFSD (fs/ufs/super.c, 787): ufs_fill_super:
[    7.545177] block nbd12: Attempted send on closed socket
[    7.546773] ENTER
[    7.547374] UFSD (fs/ufs/super.c, 795): ufs_fill_super:
[    7.549621] HPFS: hpfs_map_sector: read error
[    7.551809] ENTER
[    7.552426] UFSD (fs/ufs/super.c, 795): ufs_fill_super:
[    7.554718] HPFS: hpfs_map_sector: read error
[    7.556069] ENTER
[    7.556691] UFSD (fs/ufs/super.c, 795): ufs_fill_super:
[    7.558953] HPFS: hpfs_map_sector: read error
[    7.560432] UFSD (fs/ufs/super.c, 787): ufs_fill_super:
[    7.562685] ENTER
[    7.563336] UFSD (fs/ufs/super.c, 795): ufs_fill_super:
[    7.567269] UFSD (fs/ufs/super.c, 787): ufs_fill_super:HPFS: hpfs_map_se=
ctor: read error
[    7.573143] UFSD (fs/ufs/super.c, 787): ufs_fill_super:
[    7.575410] VFS: could not find a valid V7 on nbd10.
[    7.577090] UFSD (fs/ufs/super.c, 787): ufs_fill_super:
[    7.579348] ENTER
[    7.580050] UFSD (fs/ufs/super.c, 795): ufs_fill_super:
[    7.582283] block nbd12: Attempted send on closed socket
[    7.584745] UFSD (fs/ufs/super.c, 787): ufs_fill_super:
[    7.586964] UFSD (fs/ufs/super.c, 787): ufs_fill_super:UFSD (fs/ufs/supe=
r.c, 787): ufs_fill_super:
[    7.591238] ENTER
[    7.591893] UFSD (fs/ufs/super.c, 795): ufs_fill_super:
[    7.596221] flag 0
[    7.596916] ufs was compiled with read-only support, can't be mounted as=
 read-write
[    7.599101] block nbd12: Attempted send on closed socket
[    7.600671] block nbd10: Attempted send on closed socket
[    7.602205] flag 0
[    7.602822] ufs was compiled with read-only support, can't be mounted as=
 read-write
[    7.604988] ENTER
[    7.605612] UFSD (fs/ufs/super.c, 795): ufs_fill_super:
[    7.607815] flag 0
[    7.608548] ufs was compiled with read-only support, can't be mounted as=
 read-write
[    7.611959] ENTER
[    7.612593] UFSD (fs/ufs/super.c, 795): ufs_fill_super:
[    7.614824] flag 0
[    7.615563] ufs was compiled with read-only support, can't be mounted as=
 read-write
[    7.617796] ENTER
[    7.618390] UFSD (fs/ufs/super.c, 795): ufs_fill_super:
[    7.622160] flag 0
[    7.622880] ufs was compiled with read-only support, can't be mounted as=
 read-write
[    7.625341] ENTER
[    7.626078] UFSD (fs/ufs/super.c, 795): ufs_fill_super:
[    7.628767] ENTER
[    7.629639] ENTER
[    7.630343] UFSD (fs/ufs/super.c, 795): ufs_fill_super:
[    7.633062] block nbd12: Attempted send on closed socket
[    7.634995] ENTER
[    7.636040] UFSD (fs/ufs/super.c, 795): ufs_fill_super:
[    7.638744] HPFS: hpfs_map_sector: read error
[    7.640373] flag 0
[    7.641147] ufs was compiled with read-only support, can't be mounted as=
 read-write
[    7.643851] UFSD (fs/ufs/super.c, 795): ufs_fill_super:
[    7.648298] flag 0
[    7.649189] ------------[ cut here ]------------
[    7.650820] UFSD (fs/ufs/super.c, 1264): ufs_fill_super:
[    7.653539] flag 0
[    7.654370] ufs was compiled with read-only support, can't be mounted as=
 read-write
[    7.657102] flag 0
[    7.657853] ufs was compiled with read-only support, can't be mounted as=
 read-write
[    7.660484] flag 0
[    7.661278] UFSD (fs/ufs/super.c, 1264): ufs_fill_super:
[    7.664618] ufs was compiled with read-only support, can't be mounted as=
 read-write
[    7.667790] UFSD (fs/ufs/super.c, 1264): ufs_fill_super:
[    7.670703] WARNING: CPU: 0 PID: 483 at kernel/locking/mutex-debug.c:117=
 mutex_destroy+0x4c/0x65()
[    7.674108] ufs was compiled with read-only support, can't be mounted as=
 read-write
[    7.676652] flag 0
[    7.677363] ufs was compiled with read-only support, can't be mounted as=
 read-write
[    7.680075] UFSD (fs/ufs/super.c, 1264): ufs_fill_super:
[    7.682762] flag 0
[    7.683612] flag 0
[    7.684322] ufs was compiled with read-only support, can't be mounted as=
 read-write
[    7.687377] flag 0
[    7.688127] ufs was compiled with read-only support, can't be mounted as=
 read-write
[    7.690845] UFSD (fs/ufs/super.c, 1264): ufs_fill_super:
[    7.693637] ufs was compiled with read-only support, can't be mounted as=
 read-write
[    7.696393] EXIT (FAILED)
[    7.697357] UFSD (fs/ufs/super.c, 1264): ufs_fill_super:
[    7.700077] UFSD (fs/ufs/super.c, 1264): ufs_fill_super:UFSD (fs/ufs/sup=
er.c, 1264): ufs_fill_super:
[    7.705134] UFSD (fs/ufs/super.c, 1264): ufs_fill_super:UFSD (fs/ufs/sup=
er.c, 1264): ufs_fill_super:
[    7.710174] EXIT (FAILED)
[    7.711055] EXIT (FAILED)
[    7.711850] EXIT (FAILED)
[    7.712652] DEBUG_LOCKS_WARN_ON(mutex_is_locked(lock))
[    7.714098] UFSD (fs/ufs/super.c, 1264): ufs_fill_super:EXIT (FAILED)
[    7.716807] UFSD (fs/ufs/super.c, 1264): ufs_fill_super:
[    7.719214] UFSD (fs/ufs/super.c, 1264): ufs_fill_super:EXIT (FAILED)
[    7.722549] EXIT (FAILED)
[    7.723464] EXIT (FAILED)
[    7.724284] CPU: 0 PID: 483 Comm: mount Not tainted 3.14.0-rc7-11620-gc7=
d2e32 #1
[    7.726403] EXIT (FAILED)
[    7.727197] EXIT (FAILED)
[    7.728003] EXIT (FAILED)
[    7.728801] EXIT (FAILED)
[    7.729619] EXIT (FAILED)
[    7.730375] Hardware name: Bochs Bochs, BIOS Bochs 01/01/2011
[    7.732173]  0000000000000009 ffff88001085bc68 ffffffff81d81782 ffff8800=
1085bca0
[    7.735025]  ffffffff810c83ae ffff88001121b088 00000000ffffffea 00000000=
00008010
[    7.737830]  ffff88001111fc00 ffff880013412380 ffff88001085bd00 ffffffff=
810c8433
[    7.740687] Call Trace:
[    7.741617]  [<ffffffff81d81782>] dump_stack+0x19/0x1b
[    7.743422]  [<ffffffff810c83ae>] warn_slowpath_common+0x71/0x8b
[    7.745206]  [<ffffffff810c8433>] warn_slowpath_fmt+0x4c/0x4e
[    7.746938]  [<ffffffff810f6b97>] mutex_destroy+0x4c/0x65
[    7.748560]  [<ffffffff812802b3>] ufs_fill_super+0x201a/0x217c
[    7.750269]  [<ffffffff81437d17>] ? snprintf+0x39/0x3b
[    7.751790]  [<ffffffff8115957f>] ? register_shrinker+0x6a/0x76
[    7.753574]  [<ffffffff8118b43b>] mount_bdev+0x15b/0x1cd
[    7.755122]  [<ffffffff8127e299>] ? ufs_warning+0x7c/0x7c
[    7.756735]  [<ffffffff8117f45b>] ? __kmalloc_track_caller+0x76/0x15b
[    7.758620]  [<ffffffff8127cba5>] ufs_mount+0x15/0x17
[    7.760088]  [<ffffffff8118b6c5>] mount_fs+0x74/0x161
[    7.761619]  [<ffffffff811a3eed>] vfs_kern_mount+0x5c/0x106
[    7.763262]  [<ffffffff811a5d34>] do_mount+0x85d/0xa3d
[    7.764790]  [<ffffffff8115d934>] ? strndup_user+0x3a/0x4e
[    7.766409]  [<ffffffff811a621e>] SyS_mount+0x87/0xc0
[    7.767947]  [<ffffffff81d903bb>] system_call_fastpath+0x1a/0x1f
[    7.769743] ---[ end trace 6522caed031b1086 ]---
[    7.771101] UFSD (fs/ufs/super.c, 1264): ufs_fill_super:EXIT (FAILED)
[   62.408068] spin_lock-torture: Writes:  Total: 2  Max/Min: 0/0   Fail: 0=
=20
[  111.662094] INFO: rcu_preempt detected stalls on CPUs/tasks: {} (detecte=
d by 0, t=3D100002 jiffies, g=3D497, c=3D496, q=3D0)
[  111.663086] INFO: Stall ended before state dump start
[  122.975832] spin_lock-torture: Writes:  Total: 2  Max/Min: 0/0   Fail: 0=
=20
[  183.685586] spin_lock-torture: Writes:  Total: 2  Max/Min: 0/0   Fail: 0=
=20
[  243.986347] INFO: task init:1 blocked for more than 120 seconds.
[  243.987773]       Tainted: G        W     3.14.0-rc7-11620-gc7d2e32 #1
[  243.989069] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables =
this message.
[  243.990484] init            D 0000000000000282     0     1      0 0x0000=
0000
[  243.991827]  ffff880013837d60 0000000000000086 ffff880013858000 ffff8800=
13837fd8
[  243.993696]  ffffffff81191460 ffff880010bcc025 ffff880013858000 ffff8800=
13837cb8
[  243.995645]  ffffffff811914ac ffff880013837d48 ffffffff81191ff6 ffff8800=
119ad140
[  243.997553] Call Trace:
[  243.998163]  [<ffffffff81191460>] ? __inode_permission+0x7e/0x8a
[  243.999590]  [<ffffffff811914ac>] ? inode_permission+0x40/0x42
[  244.003229]  [<ffffffff81191ff6>] ? link_path_walk+0x73/0x801
[  244.005309]  [<ffffffff810ed209>] ? preempt_count_sub+0x2d/0x39
[  244.009496]  [<ffffffff810ed209>] ? preempt_count_sub+0x2d/0x39
[  244.011163]  [<ffffffff8143a3f6>] ? lockref_get_not_dead+0x30/0x45
[  244.016226]  [<ffffffff8119096d>] ? complete_walk+0xa3/0xf1
[  244.017867]  [<ffffffff81d8bf3f>] schedule+0x5c/0x5e
[  244.022469]  [<ffffffff81d8bf59>] schedule_preempt_disabled+0x18/0x24
[  244.024018]  [<ffffffff81d8e187>] __mutex_lock_slowpath+0x193/0x2ea
[  244.025525]  [<ffffffff81d8e306>] mutex_lock+0x28/0x37
[  244.029543]  [<ffffffff81195106>] kern_path_create+0x9a/0x15b
[  244.030928]  [<ffffffff811910f8>] ? getname_flags+0x2c/0x10f
[  244.035767]  [<ffffffff81191120>] ? getname_flags+0x54/0x10f
[  244.037402]  [<ffffffff8119524d>] user_path_create+0x41/0x58
[  244.038995]  [<ffffffff811953e4>] SyS_mknodat+0x9d/0x1c1
[  244.043147]  [<ffffffff81195525>] SyS_mknod+0x1d/0x1f
[  244.044734]  [<ffffffff81d903bb>] system_call_fastpath+0x1a/0x1f
[  244.050016] sending NMI to all CPUs:
[  244.051170] NMI backtrace for cpu 0
[  244.052152] CPU: 0 PID: 17 Comm: khungtaskd Tainted: G        W     3.14=
=2E0-rc7-11620-gc7d2e32 #1
[  244.052152] Hardware name: Bochs Bochs, BIOS Bochs 01/01/2011
[  244.052152] task: ffff88001385ea00 ti: ffff8800139a8000 task.ti: ffff880=
0139a8000
[  244.052152] RIP: 0010:[<ffffffff8103a51f>]  [<ffffffff8103a51f>] flat_se=
nd_IPI_mask+0x9f/0xbb
[  244.052152] RSP: 0018:ffff8800139a9e30  EFLAGS: 00000006
[  244.052152] RAX: 0000000000000000 RBX: 0000000000000c00 RCX: 00000000000=
00000
[  244.052152] RDX: 0000000001000000 RSI: 0000000000000c00 RDI: 00000000000=
00282
[  244.052152] RBP: ffff8800139a9e50 R08: 20676e69646e6573 R09: 00000000000=
00698
[  244.052152] R10: 61206f7420494d4e R11: 3a73555043206c6c R12: 00000000000=
00001
[  244.052152] R13: 00000000000003ff R14: ffff880013858000 R15: 00000000000=
07fff
[  244.052152] FS:  0000000000000000(0000) GS:ffffffff82251000(0000) knlGS:=
0000000000000000
[  244.052152] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[  244.052152] CR2: 000000000061d3e0 CR3: 0000000011598000 CR4: 00000000000=
006f0
[  244.052152] Stack:
[  244.052152]  0000000000000282 0000000281014a2e ffff880013858000 00000000=
00007fff
[  244.052152]  ffff8800139a9e60 ffffffff8103a55a ffff8800139a9e78 ffffffff=
81037c32
[  244.052152]  ffff880013858000 ffff8800139a9ed8 ffffffff811201b6 00000000=
00000078
[  244.052152] Call Trace:
[  244.052152]  [<ffffffff8103a55a>] flat_send_IPI_all+0x1f/0x58
[  244.052152]  [<ffffffff81037c32>] arch_trigger_all_cpu_backtrace+0x45/0x=
83
[  244.052152]  [<ffffffff811201b6>] watchdog+0x23f/0x2f6
[  244.052152]  [<ffffffff8111ff77>] ? hung_task_panic+0x17/0x17
[  244.052152]  [<ffffffff810e46c8>] kthread+0xdc/0xe4
[  244.052152]  [<ffffffff810e45ec>] ? __kthread_unpark+0x2f/0x2f
[  244.052152]  [<ffffffff81d9030a>] ret_from_fork+0x7a/0xb0
[  244.052152]  [<ffffffff810e45ec>] ? __kthread_unpark+0x2f/0x2f
[  244.052152] Code: 00 a3 5f ff 80 e6 10 75 f2 44 89 e2 c1 e2 18 89 14 25 =
10 a3 5f ff 83 fe 02 74 04 09 de eb 05 80 cf 04 89 de 89 34 25 00 a3 5f ff =
<48> 83 3d a1 77 22 01 00 75 02 0f 0b 57 9d 0f 1f 44 00 00 48 83=20
[  244.052152] INFO: NMI handler (arch_trigger_all_cpu_backtrace_handler) t=
ook too long to run: 80.584 msecs
[  244.133592] Kernel panic - not syncing: hung_task: blocked tasks
[  244.134574] CPU: 0 PID: 17 Comm: khungtaskd Tainted: G        W     3.14=
=2E0-rc7-11620-gc7d2e32 #1
[  244.134574] Hardware name: Bochs Bochs, BIOS Bochs 01/01/2011
[  244.134574]  0000000000007fff ffff8800139a9e00 ffffffff81d81782 ffff8800=
139a9e78
[  244.134574]  ffffffff81d7d4fa 0000000000000008 ffff8800139a9e88 ffff8800=
139a9e28
[  244.134574]  0000000000000018 0000000000000c00 0000000001000000 00000000=
00000000
[  244.134574] Call Trace:
[  244.134574]  [<ffffffff81d81782>] dump_stack+0x19/0x1b
[  244.134574]  [<ffffffff81d7d4fa>] panic+0xc9/0x1f1
[  244.134574]  [<ffffffff811201c4>] watchdog+0x24d/0x2f6
[  244.134574]  [<ffffffff8111ff77>] ? hung_task_panic+0x17/0x17
[  244.134574]  [<ffffffff810e46c8>] kthread+0xdc/0xe4
[  244.134574]  [<ffffffff810e45ec>] ? __kthread_unpark+0x2f/0x2f
[  244.134574]  [<ffffffff81d9030a>] ret_from_fork+0x7a/0xb0
[  244.134574]  [<ffffffff810e45ec>] ? __kthread_unpark+0x2f/0x2f
[  244.134574] Kernel Offset: 0x0 from 0xffffffff81000000 (relocation range=
: 0xffffffff80000000-0xffffffff9fffffff)
[  244.134574] Rebooting in 10 seconds..
Elapsed time: 250
qemu-system-x86_64 -cpu kvm64 -enable-kvm -kernel /kernel/x86_64-randconfig=
-r3-03251014/c7d2e322dd6eac1e3b44d2ea13f9818ad0f903de/vmlinuz-3.14.0-rc7-11=
620-gc7d2e32 -append 'hung_task_panic=3D1 earlyprintk=3DttyS0,115200 debug =
apic=3Ddebug sysrq_always_enabled rcupdate.rcu_cpu_stall_timeout=3D100 pani=
c=3D10 softlockup_panic=3D1 nmi_watchdog=3Dpanic  prompt_ramdisk=3D0 consol=
e=3DttyS0,115200 console=3Dtty0 vga=3Dnormal  root=3D/dev/ram0 rw link=3D/k=
ernel-tests/run-queue/kvm/x86_64-randconfig-r3-03251014/next:master:c7d2e32=
2dd6eac1e3b44d2ea13f9818ad0f903de:bisect-linux5/.vmlinuz-c7d2e322dd6eac1e3b=
44d2ea13f9818ad0f903de-20140325214349-34-ivytown2 branch=3Dnext/master BOOT=
_IMAGE=3D/kernel/x86_64-randconfig-r3-03251014/c7d2e322dd6eac1e3b44d2ea13f9=
818ad0f903de/vmlinuz-3.14.0-rc7-11620-gc7d2e32 drbd.minor_count=3D8'  -init=
rd /kernel-tests/initrd/yocto-minimal-x86_64.cgz -m 320 -smp 2 -net nic,vla=
n=3D1,model=3De1000 -net user,vlan=3D1,hostfwd=3Dtcp::18632-:22 -boot order=
=3Dnc -no-reboot -watchdog i6300esb -rtc base=3Dlocaltime -pidfile /dev/shm=
/kboot/pid-yocto-ivytown2-39 -serial file:/dev/shm/kboot/serial-yocto-ivyto=
wn2-39 -daemonize -display none -monitor null=20

--DocE+STaALJfprDB
Content-Type: application/octet-stream
Content-Disposition: attachment; filename="x86_64-randconfig-r3-03251014-098bc161bfc7697f7e2ca15400f13ca1ac60e9dd-WARNING:---at----mutex_destroy+-x-77588.log"
Content-Transfer-Encoding: base64

SEVBRCBpcyBub3cgYXQgMDk4YmMxNi4uLiBBZGQgbGludXgtbmV4dCBzcGVjaWZpYyBmaWxl
cyBmb3IgMjAxNDAzMjQKZ2l0IGNoZWNrb3V0IDliMjhlYzRiNDE4ODNhODNjM2IwOTYwZTYx
NzM5MTYyNDQzYzViYmEKbHMgLWEgL2tlcm5lbC10ZXN0cy9ydW4tcXVldWUva3ZtL3g4Nl82
NC1yYW5kY29uZmlnLXIzLTAzMjUxMDE0L25leHQ6bWFzdGVyOjliMjhlYzRiNDE4ODNhODNj
M2IwOTYwZTYxNzM5MTYyNDQzYzViYmE6YmlzZWN0LWxpbnV4NQoKMjAxNC0wMy0yNS0xOToy
NjoyMSA5YjI4ZWM0YjQxODgzYTgzYzNiMDk2MGU2MTczOTE2MjQ0M2M1YmJhIGNvbXBpbGlu
ZwpRdWV1ZWQgYnVpbGQgdGFzayB0byAva2VybmVsLXRlc3RzL2J1aWxkLXF1ZXVlL3g4Nl82
NC1yYW5kY29uZmlnLXIzLTAzMjUxMDE0LTliMjhlYzRiNDE4ODNhODNjM2IwOTYwZTYxNzM5
MTYyNDQzYzViYmEKQ2hlY2sgZm9yIGtlcm5lbCBpbiAva2VybmVsL3g4Nl82NC1yYW5kY29u
ZmlnLXIzLTAzMjUxMDE0LzliMjhlYzRiNDE4ODNhODNjM2IwOTYwZTYxNzM5MTYyNDQzYzVi
YmEKd2FpdGluZyBmb3IgY29tcGxldGlvbiBvZiAva2VybmVsLXRlc3RzL2J1aWxkLXF1ZXVl
L3g4Nl82NC1yYW5kY29uZmlnLXIzLTAzMjUxMDE0LTliMjhlYzRiNDE4ODNhODNjM2IwOTYw
ZTYxNzM5MTYyNDQzYzViYmEKd2FpdGluZyBmb3IgY29tcGxldGlvbiBvZiAva2VybmVsLXRl
c3RzL2J1aWxkLXF1ZXVlLy54ODZfNjQtcmFuZGNvbmZpZy1yMy0wMzI1MTAxNC05YjI4ZWM0
YjQxODgzYTgzYzNiMDk2MGU2MTczOTE2MjQ0M2M1YmJhCmtlcm5lbDogL2tlcm5lbC94ODZf
NjQtcmFuZGNvbmZpZy1yMy0wMzI1MTAxNC85YjI4ZWM0YjQxODgzYTgzYzNiMDk2MGU2MTcz
OTE2MjQ0M2M1YmJhL3ZtbGludXotMy4xNC4wLXJjNy0xMTEzNi1nOWIyOGVjNAoKMjAxNC0w
My0yNS0xOToyOToyMSBkZXRlY3RpbmcgYm9vdCBzdGF0ZSAuLgkyCTQJOAkxMQkxNQkxNwky
NCBTVUNDRVNTCgpiaXNlY3Q6IGdvb2QgY29tbWl0IDliMjhlYzRiNDE4ODNhODNjM2IwOTYw
ZTYxNzM5MTYyNDQzYzViYmEKZ2l0IGJpc2VjdCBzdGFydCAwOThiYzE2MWJmYzc2OTdmN2Uy
Y2ExNTQwMGYxM2NhMWFjNjBlOWRkIDliMjhlYzRiNDE4ODNhODNjM2IwOTYwZTYxNzM5MTYy
NDQzYzViYmEgLS0KL2Mva2VybmVsLXRlc3RzL2xpbmVhci1iaXNlY3Q6IFsiLWIiLCAiMDk4
YmMxNjFiZmM3Njk3ZjdlMmNhMTU0MDBmMTNjYTFhYzYwZTlkZCIsICItZyIsICI5YjI4ZWM0
YjQxODgzYTgzYzNiMDk2MGU2MTczOTE2MjQ0M2M1YmJhIiwgIi9jL2tlcm5lbC10ZXN0cy9i
aXNlY3QtdGVzdC1ib290LWZhaWx1cmUuc2giLCAiL2tlcm5lbC10ZXN0cy9saW51eDUvb2Jq
LWJpc2VjdCJdCkJpc2VjdGluZzogNDg4IHJldmlzaW9ucyBsZWZ0IHRvIHRlc3QgYWZ0ZXIg
dGhpcyAocm91Z2hseSA5IHN0ZXBzKQpbYWJiNWJkZjU4YzlkYmUxNTYxZjAxNWE5NTNkZmNj
MTgzZWVlMGVmOV0gUmV2ZXJ0ICJ2bXN0YXQtdXNlLXJhd19jcHVfb3BzLXRvLWF2b2lkLWZh
bHNlLXBvc2l0aXZlcy1vbi1wcmVlbXB0aW9uLWNoZWNrcy1maXgiCnJ1bm5pbmcgL2Mva2Vy
bmVsLXRlc3RzL2Jpc2VjdC10ZXN0LWJvb3QtZmFpbHVyZS5zaCAva2VybmVsLXRlc3RzL2xp
bnV4NS9vYmotYmlzZWN0CmxzIC1hIC9rZXJuZWwtdGVzdHMvcnVuLXF1ZXVlL2t2bS94ODZf
NjQtcmFuZGNvbmZpZy1yMy0wMzI1MTAxNC9uZXh0Om1hc3RlcjphYmI1YmRmNThjOWRiZTE1
NjFmMDE1YTk1M2RmY2MxODNlZWUwZWY5OmJpc2VjdC1saW51eDUKCjIwMTQtMDMtMjUtMTk6
MzM6NTIgYWJiNWJkZjU4YzlkYmUxNTYxZjAxNWE5NTNkZmNjMTgzZWVlMGVmOSBjb21waWxp
bmcKUXVldWVkIGJ1aWxkIHRhc2sgdG8gL2tlcm5lbC10ZXN0cy9idWlsZC1xdWV1ZS94ODZf
NjQtcmFuZGNvbmZpZy1yMy0wMzI1MTAxNC1hYmI1YmRmNThjOWRiZTE1NjFmMDE1YTk1M2Rm
Y2MxODNlZWUwZWY5CkNoZWNrIGZvciBrZXJuZWwgaW4gL2tlcm5lbC94ODZfNjQtcmFuZGNv
bmZpZy1yMy0wMzI1MTAxNC9hYmI1YmRmNThjOWRiZTE1NjFmMDE1YTk1M2RmY2MxODNlZWUw
ZWY5CndhaXRpbmcgZm9yIGNvbXBsZXRpb24gb2YgL2tlcm5lbC10ZXN0cy9idWlsZC1xdWV1
ZS94ODZfNjQtcmFuZGNvbmZpZy1yMy0wMzI1MTAxNC1hYmI1YmRmNThjOWRiZTE1NjFmMDE1
YTk1M2RmY2MxODNlZWUwZWY5CnN0YXR1czogRkFJTDogYnVpbGQgZXJyb3IKMjAxNC0wMy0y
NS0xOTozODo1MiBhYmI1YmRmNThjOWRiZTE1NjFmMDE1YTk1M2RmY2MxODNlZWUwZWY5IFNL
SVAgQlJPS0VOIEJVSUxECk5vIGtlcm5lbCBpbiAva2VybmVsL3g4Nl82NC1yYW5kY29uZmln
LXIzLTAzMjUxMDE0L2FiYjViZGY1OGM5ZGJlMTU2MWYwMTVhOTUzZGZjYzE4M2VlZTBlZjkK
QmlzZWN0aW5nOiA0ODggcmV2aXNpb25zIGxlZnQgdG8gdGVzdCBhZnRlciB0aGlzIChyb3Vn
aGx5IDkgc3RlcHMpCls5MjdmODI3Y2JkODA1ZjRhZWMxYmQ5MTkzZDRjYmNkYmZlMWViNDEy
XSBNZXJnZSBicmFuY2ggJ2FrcG0tY3VycmVudC9jdXJyZW50JwpydW5uaW5nIC9jL2tlcm5l
bC10ZXN0cy9iaXNlY3QtdGVzdC1ib290LWZhaWx1cmUuc2ggL2tlcm5lbC10ZXN0cy9saW51
eDUvb2JqLWJpc2VjdApscyAtYSAva2VybmVsLXRlc3RzL3J1bi1xdWV1ZS9rdm0veDg2XzY0
LXJhbmRjb25maWctcjMtMDMyNTEwMTQvbmV4dDptYXN0ZXI6OTI3ZjgyN2NiZDgwNWY0YWVj
MWJkOTE5M2Q0Y2JjZGJmZTFlYjQxMjpiaXNlY3QtbGludXg1CgoyMDE0LTAzLTI1LTE5OjM4
OjUzIDkyN2Y4MjdjYmQ4MDVmNGFlYzFiZDkxOTNkNGNiY2RiZmUxZWI0MTIgY29tcGlsaW5n
ClF1ZXVlZCBidWlsZCB0YXNrIHRvIC9rZXJuZWwtdGVzdHMvYnVpbGQtcXVldWUveDg2XzY0
LXJhbmRjb25maWctcjMtMDMyNTEwMTQtOTI3ZjgyN2NiZDgwNWY0YWVjMWJkOTE5M2Q0Y2Jj
ZGJmZTFlYjQxMgpDaGVjayBmb3Iga2VybmVsIGluIC9rZXJuZWwveDg2XzY0LXJhbmRjb25m
aWctcjMtMDMyNTEwMTQvOTI3ZjgyN2NiZDgwNWY0YWVjMWJkOTE5M2Q0Y2JjZGJmZTFlYjQx
Mgp3YWl0aW5nIGZvciBjb21wbGV0aW9uIG9mIC9rZXJuZWwtdGVzdHMvYnVpbGQtcXVldWUv
eDg2XzY0LXJhbmRjb25maWctcjMtMDMyNTEwMTQtOTI3ZjgyN2NiZDgwNWY0YWVjMWJkOTE5
M2Q0Y2JjZGJmZTFlYjQxMgpzdGF0dXM6IEZBSUw6IGJ1aWxkIGVycm9yCjIwMTQtMDMtMjUt
MTk6NTE6NTMgOTI3ZjgyN2NiZDgwNWY0YWVjMWJkOTE5M2Q0Y2JjZGJmZTFlYjQxMiBTS0lQ
IEJST0tFTiBCVUlMRApObyBrZXJuZWwgaW4gL2tlcm5lbC94ODZfNjQtcmFuZGNvbmZpZy1y
My0wMzI1MTAxNC85MjdmODI3Y2JkODA1ZjRhZWMxYmQ5MTkzZDRjYmNkYmZlMWViNDEyCkJp
c2VjdGluZzogNDg4IHJldmlzaW9ucyBsZWZ0IHRvIHRlc3QgYWZ0ZXIgdGhpcyAocm91Z2hs
eSA5IHN0ZXBzKQpbNDZhMWRlM2Q0OTE4ZDQyMTBhZmZlYzczM2Q2NjVmZDBmZjIzOTFlM10g
TWVyZ2UgYnJhbmNoICdha3BtL21hc3RlcicKcnVubmluZyAvYy9rZXJuZWwtdGVzdHMvYmlz
ZWN0LXRlc3QtYm9vdC1mYWlsdXJlLnNoIC9rZXJuZWwtdGVzdHMvbGludXg1L29iai1iaXNl
Y3QKbHMgLWEgL2tlcm5lbC10ZXN0cy9ydW4tcXVldWUva3ZtL3g4Nl82NC1yYW5kY29uZmln
LXIzLTAzMjUxMDE0L25leHQ6bWFzdGVyOjQ2YTFkZTNkNDkxOGQ0MjEwYWZmZWM3MzNkNjY1
ZmQwZmYyMzkxZTM6YmlzZWN0LWxpbnV4NQoKMjAxNC0wMy0yNS0xOTo1MTo1NCA0NmExZGUz
ZDQ5MThkNDIxMGFmZmVjNzMzZDY2NWZkMGZmMjM5MWUzIGNvbXBpbGluZwpRdWV1ZWQgYnVp
bGQgdGFzayB0byAva2VybmVsLXRlc3RzL2J1aWxkLXF1ZXVlL3g4Nl82NC1yYW5kY29uZmln
LXIzLTAzMjUxMDE0LTQ2YTFkZTNkNDkxOGQ0MjEwYWZmZWM3MzNkNjY1ZmQwZmYyMzkxZTMK
Q2hlY2sgZm9yIGtlcm5lbCBpbiAva2VybmVsL3g4Nl82NC1yYW5kY29uZmlnLXIzLTAzMjUx
MDE0LzQ2YTFkZTNkNDkxOGQ0MjEwYWZmZWM3MzNkNjY1ZmQwZmYyMzkxZTMKd2FpdGluZyBm
b3IgY29tcGxldGlvbiBvZiAva2VybmVsLXRlc3RzL2J1aWxkLXF1ZXVlL3g4Nl82NC1yYW5k
Y29uZmlnLXIzLTAzMjUxMDE0LTQ2YTFkZTNkNDkxOGQ0MjEwYWZmZWM3MzNkNjY1ZmQwZmYy
MzkxZTMKd2FpdGluZyBmb3IgY29tcGxldGlvbiBvZiAva2VybmVsLXRlc3RzL2J1aWxkLXF1
ZXVlLy54ODZfNjQtcmFuZGNvbmZpZy1yMy0wMzI1MTAxNC00NmExZGUzZDQ5MThkNDIxMGFm
ZmVjNzMzZDY2NWZkMGZmMjM5MWUzCmtlcm5lbDogL2tlcm5lbC94ODZfNjQtcmFuZGNvbmZp
Zy1yMy0wMzI1MTAxNC80NmExZGUzZDQ5MThkNDIxMGFmZmVjNzMzZDY2NWZkMGZmMjM5MWUz
L3ZtbGludXotMy4xNC4wLXJjNy0xMTYyMy1nNDZhMWRlMwoKMjAxNC0wMy0yNS0yMDowMTo1
NCBkZXRlY3RpbmcgYm9vdCBzdGF0ZSAuLgkyCTkJMTMJMTUuLi4uIFRFU1QgRkFJTFVSRQpb
ICAgIDYuNTE0MzIwXSBVRlNEIChmcy91ZnMvc3VwZXIuYywgMTI2NCk6IHVmc19maWxsX3N1
cGVyOgpbICAgIDYuNTE2NTYwXSBVRlNEIChmcy91ZnMvc3VwZXIuYywgMTI2NCk6IHVmc19m
aWxsX3N1cGVyOmZsYWcgMApbICAgIDYuNTE5Mzc3XSB1ZnMgd2FzIGNvbXBpbGVkIHdpdGgg
cmVhZC1vbmx5IHN1cHBvcnQsIGNhbid0IGJlIG1vdW50ZWQgYXMgcmVhZC13cml0ZQpbICAg
IDYuNTIxODA0XSBXQVJOSU5HOiBDUFU6IDAgUElEOiA2MTggYXQga2VybmVsL2xvY2tpbmcv
bXV0ZXgtZGVidWcuYzoxMTcgbXV0ZXhfZGVzdHJveSsweDRjLzB4NjUoKQpbICAgIDYuNTI1
MTc4XSBFWElUIChGQUlMRUQpClsgICAgNi41MjU5NzBdIEVYSVQgKEZBSUxFRCkKWyAgICA2
LjUyNjc3Nl0gZmxhZyAwCi9rZXJuZWwveDg2XzY0LXJhbmRjb25maWctcjMtMDMyNTEwMTQv
NDZhMWRlM2Q0OTE4ZDQyMTBhZmZlYzczM2Q2NjVmZDBmZjIzOTFlMy9kbWVzZy15b2N0by1s
a3Atc2IwNC01MToyMDE0MDMyNTIwMDYwMjp4ODZfNjQtcmFuZGNvbmZpZy1yMy0wMzI1MTAx
NDozLjE0LjAtcmM3LTExNjIzLWc0NmExZGUzOjEKL2tlcm5lbC94ODZfNjQtcmFuZGNvbmZp
Zy1yMy0wMzI1MTAxNC80NmExZGUzZDQ5MThkNDIxMGFmZmVjNzMzZDY2NWZkMGZmMjM5MWUz
L2RtZXNnLXlvY3RvLWl2eXRvd24yLTg1OjIwMTQwMzI1MjAwNjEzOng4Nl82NC1yYW5kY29u
ZmlnLXIzLTAzMjUxMDE0OjMuMTQuMC1yYzctMTE2MjMtZzQ2YTFkZTM6MQova2VybmVsL3g4
Nl82NC1yYW5kY29uZmlnLXIzLTAzMjUxMDE0LzQ2YTFkZTNkNDkxOGQ0MjEwYWZmZWM3MzNk
NjY1ZmQwZmYyMzkxZTMvZG1lc2cteW9jdG8tbGtwLXNiMDQtMTc6MjAxNDAzMjUyMDA2MDc6
eDg2XzY0LXJhbmRjb25maWctcjMtMDMyNTEwMTQ6My4xNC4wLXJjNy0xMTYyMy1nNDZhMWRl
MzoxCi9rZXJuZWwveDg2XzY0LXJhbmRjb25maWctcjMtMDMyNTEwMTQvNDZhMWRlM2Q0OTE4
ZDQyMTBhZmZlYzczM2Q2NjVmZDBmZjIzOTFlMy9kbWVzZy15b2N0by1sa3Atc2IwNC00OToy
MDE0MDMyNTIwMDYwNjp4ODZfNjQtcmFuZGNvbmZpZy1yMy0wMzI1MTAxNDozLjE0LjAtcmM3
LTExNjIzLWc0NmExZGUzOjEKMTU6NDo0IGFsbF9nb29kOmJhZDphbGxfYmFkIGJvb3RzChtb
MTszNW0yMDE0LTAzLTI1IDIwOjA2OjU1IFJFUEVBVCBDT1VOVDogNTcgICMgL2tlcm5lbC10
ZXN0cy9saW51eDUvb2JqLWJpc2VjdC8ucmVwZWF0G1swbQoKQmlzZWN0aW5nOiA0ODcgcmV2
aXNpb25zIGxlZnQgdG8gdGVzdCBhZnRlciB0aGlzIChyb3VnaGx5IDkgc3RlcHMpCltjNTFm
YWJiMWUzYjIwMzM4MjYxNmNhMjFmN2NmNGU3YjA5MTJkNTBlXSBSZXZlcnQgInZtc3RhdDog
dXNlIHJhd19jcHVfb3BzIHRvIGF2b2lkIGZhbHNlIHBvc2l0aXZlcyBvbiBwcmVlbXB0aW9u
IGNoZWNrcyIKcnVubmluZyAvYy9rZXJuZWwtdGVzdHMvYmlzZWN0LXRlc3QtYm9vdC1mYWls
dXJlLnNoIC9rZXJuZWwtdGVzdHMvbGludXg1L29iai1iaXNlY3QKbHMgLWEgL2tlcm5lbC10
ZXN0cy9ydW4tcXVldWUva3ZtL3g4Nl82NC1yYW5kY29uZmlnLXIzLTAzMjUxMDE0L25leHQ6
bWFzdGVyOmM1MWZhYmIxZTNiMjAzMzgyNjE2Y2EyMWY3Y2Y0ZTdiMDkxMmQ1MGU6YmlzZWN0
LWxpbnV4NQoKMjAxNC0wMy0yNS0yMDowNjo1NiBjNTFmYWJiMWUzYjIwMzM4MjYxNmNhMjFm
N2NmNGU3YjA5MTJkNTBlIGNvbXBpbGluZwpRdWV1ZWQgYnVpbGQgdGFzayB0byAva2VybmVs
LXRlc3RzL2J1aWxkLXF1ZXVlL3g4Nl82NC1yYW5kY29uZmlnLXIzLTAzMjUxMDE0LWM1MWZh
YmIxZTNiMjAzMzgyNjE2Y2EyMWY3Y2Y0ZTdiMDkxMmQ1MGUKQ2hlY2sgZm9yIGtlcm5lbCBp
biAva2VybmVsL3g4Nl82NC1yYW5kY29uZmlnLXIzLTAzMjUxMDE0L2M1MWZhYmIxZTNiMjAz
MzgyNjE2Y2EyMWY3Y2Y0ZTdiMDkxMmQ1MGUKd2FpdGluZyBmb3IgY29tcGxldGlvbiBvZiAv
a2VybmVsLXRlc3RzL2J1aWxkLXF1ZXVlL3g4Nl82NC1yYW5kY29uZmlnLXIzLTAzMjUxMDE0
LWM1MWZhYmIxZTNiMjAzMzgyNjE2Y2EyMWY3Y2Y0ZTdiMDkxMmQ1MGUKd2FpdGluZyBmb3Ig
Y29tcGxldGlvbiBvZiAva2VybmVsLXRlc3RzL2J1aWxkLXF1ZXVlLy54ODZfNjQtcmFuZGNv
bmZpZy1yMy0wMzI1MTAxNC1jNTFmYWJiMWUzYjIwMzM4MjYxNmNhMjFmN2NmNGU3YjA5MTJk
NTBlCmtlcm5lbDogL2tlcm5lbC94ODZfNjQtcmFuZGNvbmZpZy1yMy0wMzI1MTAxNC9jNTFm
YWJiMWUzYjIwMzM4MjYxNmNhMjFmN2NmNGU3YjA5MTJkNTBlL3ZtbGludXotMy4xNC4wLXJj
Ny0xMTU4NC1nYzUxZmFiYgoKMjAxNC0wMy0yNS0yMDoxNzo1NiBkZXRlY3RpbmcgYm9vdCBz
dGF0ZSAJMQk5CTE5CTMzCTQzCTU3IFNVQ0NFU1MKCmxpbmVhci1iaXNlY3Q6IGJhZCBicmFu
Y2ggbWF5IGJlIGJyYW5jaCAnYWtwbS9tYXN0ZXInCmxpbmVhci1iaXNlY3Q6IGhhbmRsZSBv
dmVyIHRvIGdpdCBiaXNlY3QKbGluZWFyLWJpc2VjdDogZ2l0IGJpc2VjdCBzdGFydCA0NmEx
ZGUzZDQ5MThkNDIxMGFmZmVjNzMzZDY2NWZkMGZmMjM5MWUzIGM1MWZhYmIxZTNiMjAzMzgy
NjE2Y2EyMWY3Y2Y0ZTdiMDkxMmQ1MGUgLS0KUHJldmlvdXMgSEVBRCBwb3NpdGlvbiB3YXMg
YzUxZmFiYi4uLiBSZXZlcnQgInZtc3RhdDogdXNlIHJhd19jcHVfb3BzIHRvIGF2b2lkIGZh
bHNlIHBvc2l0aXZlcyBvbiBwcmVlbXB0aW9uIGNoZWNrcyIKSEVBRCBpcyBub3cgYXQgMWQx
ZmRkOTUuLi4gTWVyZ2UgdGFnICdjaGFyLW1pc2MtMy4xMi1yYzEnIG9mIGdpdDovL2dpdC5r
ZXJuZWwub3JnL3B1Yi9zY20vbGludXgva2VybmVsL2dpdC9ncmVna2gvY2hhci1taXNjCkJp
c2VjdGluZzogMTkgcmV2aXNpb25zIGxlZnQgdG8gdGVzdCBhZnRlciB0aGlzIChyb3VnaGx5
IDQgc3RlcHMpCltiYzgyZmNkZmU1NzJjZWE4ZDIxYWQ5N2YxZmFiMmQ4Y2YzZDQxMmJjXSBu
ZXQ6IHJlcGxhY2UgX190aGlzX2NwdV9pbmMgaW4gcm91dGUuYyB3aXRoIHJhd19jcHVfaW5j
CmxpbmVhci1iaXNlY3Q6IGdpdCBiaXNlY3QgcnVuIC9jL2tlcm5lbC10ZXN0cy9iaXNlY3Qt
dGVzdC1ib290LWZhaWx1cmUuc2ggL2tlcm5lbC10ZXN0cy9saW51eDUvb2JqLWJpc2VjdApy
dW5uaW5nIC9jL2tlcm5lbC10ZXN0cy9iaXNlY3QtdGVzdC1ib290LWZhaWx1cmUuc2ggL2tl
cm5lbC10ZXN0cy9saW51eDUvb2JqLWJpc2VjdApscyAtYSAva2VybmVsLXRlc3RzL3J1bi1x
dWV1ZS9rdm0veDg2XzY0LXJhbmRjb25maWctcjMtMDMyNTEwMTQvbmV4dDptYXN0ZXI6YmM4
MmZjZGZlNTcyY2VhOGQyMWFkOTdmMWZhYjJkOGNmM2Q0MTJiYzpiaXNlY3QtbGludXg1Cgoy
MDE0LTAzLTI1LTIwOjIxOjA3IGJjODJmY2RmZTU3MmNlYThkMjFhZDk3ZjFmYWIyZDhjZjNk
NDEyYmMgY29tcGlsaW5nClF1ZXVlZCBidWlsZCB0YXNrIHRvIC9rZXJuZWwtdGVzdHMvYnVp
bGQtcXVldWUveDg2XzY0LXJhbmRjb25maWctcjMtMDMyNTEwMTQtYmM4MmZjZGZlNTcyY2Vh
OGQyMWFkOTdmMWZhYjJkOGNmM2Q0MTJiYwpDaGVjayBmb3Iga2VybmVsIGluIC9rZXJuZWwv
eDg2XzY0LXJhbmRjb25maWctcjMtMDMyNTEwMTQvYmM4MmZjZGZlNTcyY2VhOGQyMWFkOTdm
MWZhYjJkOGNmM2Q0MTJiYwp3YWl0aW5nIGZvciBjb21wbGV0aW9uIG9mIC9rZXJuZWwtdGVz
dHMvYnVpbGQtcXVldWUveDg2XzY0LXJhbmRjb25maWctcjMtMDMyNTEwMTQtYmM4MmZjZGZl
NTcyY2VhOGQyMWFkOTdmMWZhYjJkOGNmM2Q0MTJiYwp3YWl0aW5nIGZvciBjb21wbGV0aW9u
IG9mIC9rZXJuZWwtdGVzdHMvYnVpbGQtcXVldWUvLng4Nl82NC1yYW5kY29uZmlnLXIzLTAz
MjUxMDE0LWJjODJmY2RmZTU3MmNlYThkMjFhZDk3ZjFmYWIyZDhjZjNkNDEyYmMKa2VybmVs
OiAva2VybmVsL3g4Nl82NC1yYW5kY29uZmlnLXIzLTAzMjUxMDE0L2JjODJmY2RmZTU3MmNl
YThkMjFhZDk3ZjFmYWIyZDhjZjNkNDEyYmMvdm1saW51ei0zLjE0LjAtcmM3LTExNjAzLWdi
YzgyZmNkCgoyMDE0LTAzLTI1LTIwOjQxOjA3IGRldGVjdGluZyBib290IHN0YXRlIC4JMQk5
CTE5CTI2CTM5CTQ2CTUyCTU3IFNVQ0NFU1MKCkJpc2VjdGluZzogOSByZXZpc2lvbnMgbGVm
dCB0byB0ZXN0IGFmdGVyIHRoaXMgKHJvdWdobHkgMyBzdGVwcykKWzg1NTM3MGJmMTBmZDhl
Yjg4NzdlMTk3YjZjYmNkMDI2MmE5YjM0YjddIGFybTY0OiBpbml0aWFsaXplIHBncHJvdCBp
bmZvIGVhcmxpZXIgaW4gYm9vdApydW5uaW5nIC9jL2tlcm5lbC10ZXN0cy9iaXNlY3QtdGVz
dC1ib290LWZhaWx1cmUuc2ggL2tlcm5lbC10ZXN0cy9saW51eDUvb2JqLWJpc2VjdApscyAt
YSAva2VybmVsLXRlc3RzL3J1bi1xdWV1ZS9rdm0veDg2XzY0LXJhbmRjb25maWctcjMtMDMy
NTEwMTQvbmV4dDptYXN0ZXI6ODU1MzcwYmYxMGZkOGViODg3N2UxOTdiNmNiY2QwMjYyYTli
MzRiNzpiaXNlY3QtbGludXg1CgoyMDE0LTAzLTI1LTIwOjQ1OjM4IDg1NTM3MGJmMTBmZDhl
Yjg4NzdlMTk3YjZjYmNkMDI2MmE5YjM0YjcgY29tcGlsaW5nClF1ZXVlZCBidWlsZCB0YXNr
IHRvIC9rZXJuZWwtdGVzdHMvYnVpbGQtcXVldWUveDg2XzY0LXJhbmRjb25maWctcjMtMDMy
NTEwMTQtODU1MzcwYmYxMGZkOGViODg3N2UxOTdiNmNiY2QwMjYyYTliMzRiNwpDaGVjayBm
b3Iga2VybmVsIGluIC9rZXJuZWwveDg2XzY0LXJhbmRjb25maWctcjMtMDMyNTEwMTQvODU1
MzcwYmYxMGZkOGViODg3N2UxOTdiNmNiY2QwMjYyYTliMzRiNwp3YWl0aW5nIGZvciBjb21w
bGV0aW9uIG9mIC9rZXJuZWwtdGVzdHMvYnVpbGQtcXVldWUveDg2XzY0LXJhbmRjb25maWct
cjMtMDMyNTEwMTQtODU1MzcwYmYxMGZkOGViODg3N2UxOTdiNmNiY2QwMjYyYTliMzRiNwp3
YWl0aW5nIGZvciBjb21wbGV0aW9uIG9mIC9rZXJuZWwtdGVzdHMvYnVpbGQtcXVldWUvLng4
Nl82NC1yYW5kY29uZmlnLXIzLTAzMjUxMDE0LTg1NTM3MGJmMTBmZDhlYjg4NzdlMTk3YjZj
YmNkMDI2MmE5YjM0YjcKa2VybmVsOiAva2VybmVsL3g4Nl82NC1yYW5kY29uZmlnLXIzLTAz
MjUxMDE0Lzg1NTM3MGJmMTBmZDhlYjg4NzdlMTk3YjZjYmNkMDI2MmE5YjM0Yjcvdm1saW51
ei0zLjE0LjAtcmM3LTExNjEzLWc4NTUzNzBiCgoyMDE0LTAzLTI1LTIwOjU3OjM4IGRldGVj
dGluZyBib290IHN0YXRlIC4uCTEJMwk3CTE3CTE4CTE5CTIzCTI1CTM1CTUwCTU0CTU3IFNV
Q0NFU1MKCkJpc2VjdGluZzogNCByZXZpc2lvbnMgbGVmdCB0byB0ZXN0IGFmdGVyIHRoaXMg
KHJvdWdobHkgMiBzdGVwcykKW2E1YThjODllNTE1Yjg2MTdmMjMyZDFhMzM3NWEwODZjNGJm
Y2FlMjRdIGZzL3VmczogcmVtb3ZlIHVudXNlZCB1ZnNfc3VwZXJfYmxvY2tfc2Vjb25kIHBv
aW50ZXIKcnVubmluZyAvYy9rZXJuZWwtdGVzdHMvYmlzZWN0LXRlc3QtYm9vdC1mYWlsdXJl
LnNoIC9rZXJuZWwtdGVzdHMvbGludXg1L29iai1iaXNlY3QKbHMgLWEgL2tlcm5lbC10ZXN0
cy9ydW4tcXVldWUva3ZtL3g4Nl82NC1yYW5kY29uZmlnLXIzLTAzMjUxMDE0L25leHQ6bWFz
dGVyOmE1YThjODllNTE1Yjg2MTdmMjMyZDFhMzM3NWEwODZjNGJmY2FlMjQ6YmlzZWN0LWxp
bnV4NQoKMjAxNC0wMy0yNS0yMTowNDozOSBhNWE4Yzg5ZTUxNWI4NjE3ZjIzMmQxYTMzNzVh
MDg2YzRiZmNhZTI0IGNvbXBpbGluZwpRdWV1ZWQgYnVpbGQgdGFzayB0byAva2VybmVsLXRl
c3RzL2J1aWxkLXF1ZXVlL3g4Nl82NC1yYW5kY29uZmlnLXIzLTAzMjUxMDE0LWE1YThjODll
NTE1Yjg2MTdmMjMyZDFhMzM3NWEwODZjNGJmY2FlMjQKQ2hlY2sgZm9yIGtlcm5lbCBpbiAv
a2VybmVsL3g4Nl82NC1yYW5kY29uZmlnLXIzLTAzMjUxMDE0L2E1YThjODllNTE1Yjg2MTdm
MjMyZDFhMzM3NWEwODZjNGJmY2FlMjQKd2FpdGluZyBmb3IgY29tcGxldGlvbiBvZiAva2Vy
bmVsLXRlc3RzL2J1aWxkLXF1ZXVlL3g4Nl82NC1yYW5kY29uZmlnLXIzLTAzMjUxMDE0LWE1
YThjODllNTE1Yjg2MTdmMjMyZDFhMzM3NWEwODZjNGJmY2FlMjQKd2FpdGluZyBmb3IgY29t
cGxldGlvbiBvZiAva2VybmVsLXRlc3RzL2J1aWxkLXF1ZXVlLy54ODZfNjQtcmFuZGNvbmZp
Zy1yMy0wMzI1MTAxNC1hNWE4Yzg5ZTUxNWI4NjE3ZjIzMmQxYTMzNzVhMDg2YzRiZmNhZTI0
Cmtlcm5lbDogL2tlcm5lbC94ODZfNjQtcmFuZGNvbmZpZy1yMy0wMzI1MTAxNC9hNWE4Yzg5
ZTUxNWI4NjE3ZjIzMmQxYTMzNzVhMDg2YzRiZmNhZTI0L3ZtbGludXotMy4xNC4wLXJjNy0x
MTYxOC1nYTVhOGM4OQoKMjAxNC0wMy0yNS0yMToyMzo0MCBkZXRlY3RpbmcgYm9vdCBzdGF0
ZSAuCTIJOQkxNAkxOAkzMAkzNAk0MQk1Ngk1NyBTVUNDRVNTCgpCaXNlY3Rpbmc6IDIgcmV2
aXNpb25zIGxlZnQgdG8gdGVzdCBhZnRlciB0aGlzIChyb3VnaGx5IDEgc3RlcCkKW2M3ZDJl
MzIyZGQ2ZWFjMWUzYjQ0ZDJlYTEzZjk4MThhZDBmOTAzZGVdIHVmczogc2IgbXV0ZXggbWVy
Z2UgKyBtdXRleF9kZXN0cm95CnJ1bm5pbmcgL2Mva2VybmVsLXRlc3RzL2Jpc2VjdC10ZXN0
LWJvb3QtZmFpbHVyZS5zaCAva2VybmVsLXRlc3RzL2xpbnV4NS9vYmotYmlzZWN0CmxzIC1h
IC9rZXJuZWwtdGVzdHMvcnVuLXF1ZXVlL2t2bS94ODZfNjQtcmFuZGNvbmZpZy1yMy0wMzI1
MTAxNC9uZXh0Om1hc3RlcjpjN2QyZTMyMmRkNmVhYzFlM2I0NGQyZWExM2Y5ODE4YWQwZjkw
M2RlOmJpc2VjdC1saW51eDUKCjIwMTQtMDMtMjUtMjE6Mjg6NDAgYzdkMmUzMjJkZDZlYWMx
ZTNiNDRkMmVhMTNmOTgxOGFkMGY5MDNkZSBjb21waWxpbmcKUXVldWVkIGJ1aWxkIHRhc2sg
dG8gL2tlcm5lbC10ZXN0cy9idWlsZC1xdWV1ZS94ODZfNjQtcmFuZGNvbmZpZy1yMy0wMzI1
MTAxNC1jN2QyZTMyMmRkNmVhYzFlM2I0NGQyZWExM2Y5ODE4YWQwZjkwM2RlCkNoZWNrIGZv
ciBrZXJuZWwgaW4gL2tlcm5lbC94ODZfNjQtcmFuZGNvbmZpZy1yMy0wMzI1MTAxNC9jN2Qy
ZTMyMmRkNmVhYzFlM2I0NGQyZWExM2Y5ODE4YWQwZjkwM2RlCndhaXRpbmcgZm9yIGNvbXBs
ZXRpb24gb2YgL2tlcm5lbC10ZXN0cy9idWlsZC1xdWV1ZS94ODZfNjQtcmFuZGNvbmZpZy1y
My0wMzI1MTAxNC1jN2QyZTMyMmRkNmVhYzFlM2I0NGQyZWExM2Y5ODE4YWQwZjkwM2RlCndh
aXRpbmcgZm9yIGNvbXBsZXRpb24gb2YgL2tlcm5lbC10ZXN0cy9idWlsZC1xdWV1ZS8ueDg2
XzY0LXJhbmRjb25maWctcjMtMDMyNTEwMTQtYzdkMmUzMjJkZDZlYWMxZTNiNDRkMmVhMTNm
OTgxOGFkMGY5MDNkZQprZXJuZWw6IC9rZXJuZWwveDg2XzY0LXJhbmRjb25maWctcjMtMDMy
NTEwMTQvYzdkMmUzMjJkZDZlYWMxZTNiNDRkMmVhMTNmOTgxOGFkMGY5MDNkZS92bWxpbnV6
LTMuMTQuMC1yYzctMTE2MjAtZ2M3ZDJlMzIKCjIwMTQtMDMtMjUtMjE6NDQ6NDAgZGV0ZWN0
aW5nIGJvb3Qgc3RhdGUgLgk1CTcJMTQJMTUJMTgJMjAJMjIgVEVTVCBGQUlMVVJFClsgICAg
Ny4yOTg4MDBdIC0tLS0tLS0tLS0tLVsgY3V0IGhlcmUgXS0tLS0tLS0tLS0tLQpbICAgIDcu
Mjk5ODMzXSBmbGFnIDAKWyAgICA3LjMwMDQzOF0gdWZzIHdhcyBjb21waWxlZCB3aXRoIHJl
YWQtb25seSBzdXBwb3J0LCBjYW4ndCBiZSBtb3VudGVkIGFzIHJlYWQtd3JpdGUKWyAgICA3
LjMwMjQ2MV0gV0FSTklORzogQ1BVOiAwIFBJRDogNjU5IGF0IGtlcm5lbC9sb2NraW5nL211
dGV4LWRlYnVnLmM6MTE3IG11dGV4X2Rlc3Ryb3krMHg0Yy8weDY1KCkKWyAgICA3LjMwNTI4
N10gZmxhZyAwClsgICAgNy4zMDU4MTFdIHVmcyB3YXMgY29tcGlsZWQgd2l0aCByZWFkLW9u
bHkgc3VwcG9ydCwgY2FuJ3QgYmUgbW91bnRlZCBhcyByZWFkLXdyaXRlClsgICAgNy4zMDgz
NjZdIGZsYWcgMAova2VybmVsL3g4Nl82NC1yYW5kY29uZmlnLXIzLTAzMjUxMDE0L2M3ZDJl
MzIyZGQ2ZWFjMWUzYjQ0ZDJlYTEzZjk4MThhZDBmOTAzZGUvZG1lc2cteW9jdG8tbGtwLXN0
MDEtMTU6MjAxNDAzMjUyMTQ4MTI6eDg2XzY0LXJhbmRjb25maWctcjMtMDMyNTEwMTQ6My4x
NC4wLXJjNy0xMTYyMC1nYzdkMmUzMjoxCi9rZXJuZWwveDg2XzY0LXJhbmRjb25maWctcjMt
MDMyNTEwMTQvYzdkMmUzMjJkZDZlYWMxZTNiNDRkMmVhMTNmOTgxOGFkMGY5MDNkZS9kbWVz
Zy15b2N0by1pdnl0b3duMi00MzoyMDE0MDMyNTIxNDgyMDp4ODZfNjQtcmFuZGNvbmZpZy1y
My0wMzI1MTAxNDozLjE0LjAtcmM3LTExNjIwLWdjN2QyZTMyOjEKL2tlcm5lbC94ODZfNjQt
cmFuZGNvbmZpZy1yMy0wMzI1MTAxNC9jN2QyZTMyMmRkNmVhYzFlM2I0NGQyZWExM2Y5ODE4
YWQwZjkwM2RlL2RtZXNnLXlvY3RvLWl2eXRvd24yLTQ5OjIwMTQwMzI1MjE0ODMwOng4Nl82
NC1yYW5kY29uZmlnLXIzLTAzMjUxMDE0OjMuMTQuMC1yYzctMTE2MjAtZ2M3ZDJlMzI6MQov
a2VybmVsL3g4Nl82NC1yYW5kY29uZmlnLXIzLTAzMjUxMDE0L2M3ZDJlMzIyZGQ2ZWFjMWUz
YjQ0ZDJlYTEzZjk4MThhZDBmOTAzZGUvZG1lc2cteW9jdG8taXZ5dG93bjItNjU6MjAxNDAz
MjUyMTQ4MzA6eDg2XzY0LXJhbmRjb25maWctcjMtMDMyNTEwMTQ6My4xNC4wLXJjNy0xMTYy
MC1nYzdkMmUzMjoxCi9rZXJuZWwveDg2XzY0LXJhbmRjb25maWctcjMtMDMyNTEwMTQvYzdk
MmUzMjJkZDZlYWMxZTNiNDRkMmVhMTNmOTgxOGFkMGY5MDNkZS9kbWVzZy15b2N0by1pdnl0
b3duMi04MjoyMDE0MDMyNTIxNDgzMzp4ODZfNjQtcmFuZGNvbmZpZy1yMy0wMzI1MTAxNDoz
LjE0LjAtcmM3LTExNjIwLWdjN2QyZTMyOjEKL2tlcm5lbC94ODZfNjQtcmFuZGNvbmZpZy1y
My0wMzI1MTAxNC9jN2QyZTMyMmRkNmVhYzFlM2I0NGQyZWExM2Y5ODE4YWQwZjkwM2RlL2Rt
ZXNnLXlvY3RvLWxrcC1zdDAxLTg6MjAxNDAzMjUyMTQ4MjY6eDg2XzY0LXJhbmRjb25maWct
cjMtMDMyNTEwMTQ6My4xNC4wLXJjNy0xMTYyMC1nYzdkMmUzMjoxCjIyOjY6NSBhbGxfZ29v
ZDpiYWQ6YWxsX2JhZCBib290cwoKQmlzZWN0aW5nOiAwIHJldmlzaW9ucyBsZWZ0IHRvIHRl
c3QgYWZ0ZXIgdGhpcyAocm91Z2hseSAwIHN0ZXBzKQpbZTY4YWFkYjlmODEzYmU4NzQ3MjJi
NGVmMWU4NGIzMjU1NzY4ODM2NF0gZnMvdWZzOiByZW1vdmUgdW51c2VkIHVmc19zdXBlcl9i
bG9ja190aGlyZCBwb2ludGVyCnJ1bm5pbmcgL2Mva2VybmVsLXRlc3RzL2Jpc2VjdC10ZXN0
LWJvb3QtZmFpbHVyZS5zaCAva2VybmVsLXRlc3RzL2xpbnV4NS9vYmotYmlzZWN0CmxzIC1h
IC9rZXJuZWwtdGVzdHMvcnVuLXF1ZXVlL2t2bS94ODZfNjQtcmFuZGNvbmZpZy1yMy0wMzI1
MTAxNC9uZXh0Om1hc3RlcjplNjhhYWRiOWY4MTNiZTg3NDcyMmI0ZWYxZTg0YjMyNTU3Njg4
MzY0OmJpc2VjdC1saW51eDUKCjIwMTQtMDMtMjUtMjE6NDg6NDIgZTY4YWFkYjlmODEzYmU4
NzQ3MjJiNGVmMWU4NGIzMjU1NzY4ODM2NCBjb21waWxpbmcKUXVldWVkIGJ1aWxkIHRhc2sg
dG8gL2tlcm5lbC10ZXN0cy9idWlsZC1xdWV1ZS94ODZfNjQtcmFuZGNvbmZpZy1yMy0wMzI1
MTAxNC1lNjhhYWRiOWY4MTNiZTg3NDcyMmI0ZWYxZTg0YjMyNTU3Njg4MzY0CkNoZWNrIGZv
ciBrZXJuZWwgaW4gL2tlcm5lbC94ODZfNjQtcmFuZGNvbmZpZy1yMy0wMzI1MTAxNC9lNjhh
YWRiOWY4MTNiZTg3NDcyMmI0ZWYxZTg0YjMyNTU3Njg4MzY0CndhaXRpbmcgZm9yIGNvbXBs
ZXRpb24gb2YgL2tlcm5lbC10ZXN0cy9idWlsZC1xdWV1ZS94ODZfNjQtcmFuZGNvbmZpZy1y
My0wMzI1MTAxNC1lNjhhYWRiOWY4MTNiZTg3NDcyMmI0ZWYxZTg0YjMyNTU3Njg4MzY0Cndh
aXRpbmcgZm9yIGNvbXBsZXRpb24gb2YgL2tlcm5lbC10ZXN0cy9idWlsZC1xdWV1ZS8ueDg2
XzY0LXJhbmRjb25maWctcjMtMDMyNTEwMTQtZTY4YWFkYjlmODEzYmU4NzQ3MjJiNGVmMWU4
NGIzMjU1NzY4ODM2NAprZXJuZWw6IC9rZXJuZWwveDg2XzY0LXJhbmRjb25maWctcjMtMDMy
NTEwMTQvZTY4YWFkYjlmODEzYmU4NzQ3MjJiNGVmMWU4NGIzMjU1NzY4ODM2NC92bWxpbnV6
LTMuMTQuMC1yYzctMTE2MTktZ2U2OGFhZGIKCjIwMTQtMDMtMjUtMjI6MDQ6NDIgZGV0ZWN0
aW5nIGJvb3Qgc3RhdGUgLi4uCTMJMTEJMTcJMjAuCTM0CTQ2CTQ4CTUzCTU3IFNVQ0NFU1MK
CmM3ZDJlMzIyZGQ2ZWFjMWUzYjQ0ZDJlYTEzZjk4MThhZDBmOTAzZGUgaXMgdGhlIGZpcnN0
IGJhZCBjb21taXQKY29tbWl0IGM3ZDJlMzIyZGQ2ZWFjMWUzYjQ0ZDJlYTEzZjk4MThhZDBm
OTAzZGUKQXV0aG9yOiBGYWJpYW4gRnJlZGVyaWNrIDxmYWJmQHNreW5ldC5iZT4KRGF0ZTog
ICBTYXQgTWFyIDIyIDEyOjQ5OjUxIDIwMTQgKzExMDAKCiAgICB1ZnM6IHNiIG11dGV4IG1l
cmdlICsgbXV0ZXhfZGVzdHJveQogICAgCiAgICA3ODgyNTdkNjEwMWQ5ICgidWZzOiByZW1v
dmUgdGhlIEJLTCIpIHJlcGxhY2VkIEJLTCB3aXRoIG11dGV4IHByb3RlY3Rpb24KICAgIHVz
aW5nIGZ1bmN0aW9ucyBsb2NrX3VmcywgdW5sb2NrX3VmcyBhbmQgc3RydWN0IG11dGV4ICdt
dXRleCcgaW4gc2JfaW5mby4KICAgIAogICAgYjY5NjMzMjdlMDUyICgidWZzOiBkcm9wIGxv
Y2svdW5sb2NrIHN1cGVyIikgcmVtb3ZlZCBsb2NrL3VubG9jayBzdXBlciBhbmQKICAgIGFk
ZGVkIHN0cnVjdCBtdXRleCAnc19sb2NrJyBpbiBzYl9pbmZvLgogICAgCiAgICBUaG9zZSAy
IG11dGV4ZXMgYXJlIGdlbmVyYWxseSBsb2NrZWQvdW5sb2NrZWQgYXQgdGhlIHNhbWUgdGlt
ZSBleGNlcHQgaW4KICAgIGFsbG9jYXRpb24gKGJhbGxvYywgaWFsbG9jKS4KICAgIAogICAg
VGhpcyBwYXRjaCBtZXJnZXMgdGhlIDIgbXV0ZXhlcyBhbmQgcHJvcGFnYXRlcyBmaXJzdCBj
b21taXQgc29sdXRpb24uICBJdAogICAgYWxzbyBhZGRzIG11dGV4IGRlc3RydWN0aW9uIGJl
Zm9yZSBrZnJlZSBkdXJpbmcgdWZzX2ZpbGxfc3VwZXIgZmFpbHVyZSBhbmQKICAgIHVmc19w
dXRfc3VwZXIuCiAgICAKICAgIFNpZ25lZC1vZmYtYnk6IEZhYmlhbiBGcmVkZXJpY2sgPGZh
YmZAc2t5bmV0LmJlPgogICAgQ2M6IEV2Z2VuaXkgRHVzaGlzdG92IDxkdXNoaXN0b3ZAbWFp
bC5ydT4KICAgIFNpZ25lZC1vZmYtYnk6IEFuZHJldyBNb3J0b24gPGFrcG1AbGludXgtZm91
bmRhdGlvbi5vcmc+Cgo6MDQwMDAwIDA0MDAwMCBjNTkzMDYxODJjMDVlZWZhMWZkMWQ1M2E2
ZTY1NTk0NWZkMzQwYjhmIDM1MDYyMGJmY2FmMTI2NGY1ZTA1YmZjYjlkZDY3NTcyOTk4MWZm
YWEgTQlmcwpiaXNlY3QgcnVuIHN1Y2Nlc3MKSEVBRCBpcyBub3cgYXQgZTY4YWFkYi4uLiBm
cy91ZnM6IHJlbW92ZSB1bnVzZWQgdWZzX3N1cGVyX2Jsb2NrX3RoaXJkIHBvaW50ZXIKbHMg
LWEgL2tlcm5lbC10ZXN0cy9ydW4tcXVldWUva3ZtL3g4Nl82NC1yYW5kY29uZmlnLXIzLTAz
MjUxMDE0L25leHQ6bWFzdGVyOmU2OGFhZGI5ZjgxM2JlODc0NzIyYjRlZjFlODRiMzI1NTc2
ODgzNjQ6YmlzZWN0LWxpbnV4NQoKMjAxNC0wMy0yNS0yMjoxMToxNCBlNjhhYWRiOWY4MTNi
ZTg3NDcyMmI0ZWYxZTg0YjMyNTU3Njg4MzY0IHJldXNlIC9rZXJuZWwveDg2XzY0LXJhbmRj
b25maWctcjMtMDMyNTEwMTQvZTY4YWFkYjlmODEzYmU4NzQ3MjJiNGVmMWU4NGIzMjU1NzY4
ODM2NC92bWxpbnV6LTMuMTQuMC1yYzctMTE2MTktZ2U2OGFhZGIKCjIwMTQtMDMtMjUtMjI6
MTE6MTQgZGV0ZWN0aW5nIGJvb3Qgc3RhdGUgLi4uCTYyCTY3CTY5CTc0CTg2CTkyCTEwNAkx
MDkJMTE1CTExNgkxMTcJMTI1CTEzNQkxNDAJMTQ3CTE1NQkxNjQJMTcxIFNVQ0NFU1MKClBy
ZXZpb3VzIEhFQUQgcG9zaXRpb24gd2FzIGU2OGFhZGIuLi4gZnMvdWZzOiByZW1vdmUgdW51
c2VkIHVmc19zdXBlcl9ibG9ja190aGlyZCBwb2ludGVyCkhFQUQgaXMgbm93IGF0IDA5OGJj
MTYuLi4gQWRkIGxpbnV4LW5leHQgc3BlY2lmaWMgZmlsZXMgZm9yIDIwMTQwMzI0CmxzIC1h
IC9rZXJuZWwtdGVzdHMvcnVuLXF1ZXVlL2t2bS94ODZfNjQtcmFuZGNvbmZpZy1yMy0wMzI1
MTAxNC9uZXh0Om1hc3RlcjowOThiYzE2MWJmYzc2OTdmN2UyY2ExNTQwMGYxM2NhMWFjNjBl
OWRkOmJpc2VjdC1saW51eDUKIFRFU1QgRkFJTFVSRQpbICAgIDYuMjMxOTIzXSBmbGFnIDAK
WyAgICA2LjIzMzkyN10gRU5URVIKWyAgICA2LjIzNDg0Ml0gZmxhZyAwClsgICAgNi4yMzYw
MjJdIFdBUk5JTkc6IENQVTogMCBQSUQ6IDUyNiBhdCBrZXJuZWwvbG9ja2luZy9tdXRleC1k
ZWJ1Zy5jOjExNyBtdXRleF9kZXN0cm95KzB4NGMvMHg2NSgpClsgICAgNi4yNDM0OTJdIEVO
VEVSClsgICAgNi4yNDQ4NzRdIFVGU0QgKGZzL3Vmcy9zdXBlci5jLCA3OTUpOiB1ZnNfZmls
bF9zdXBlcjoKWyAgICA2LjI0ODkwN10gdWZzIHdhcyBjb21waWxlZCB3aXRoIHJlYWQtb25s
eSBzdXBwb3J0LCBjYW4ndCBiZSBtb3VudGVkIGFzIHJlYWQtd3JpdGUKL2tlcm5lbC94ODZf
NjQtcmFuZGNvbmZpZy1yMy0wMzI1MTAxNC8wOThiYzE2MWJmYzc2OTdmN2UyY2ExNTQwMGYx
M2NhMWFjNjBlOWRkL2RtZXNnLXlvY3RvLWxrcC1zdDAxLTEyOjIwMTQwMzI1MTkyNjUxOng4
Nl82NC1yYW5kY29uZmlnLXIzLTAzMjUxMDE0OjMuMTQuMC1yYzctbmV4dC0yMDE0MDMyNDoz
Ci9rZXJuZWwveDg2XzY0LXJhbmRjb25maWctcjMtMDMyNTEwMTQvMDk4YmMxNjFiZmM3Njk3
ZjdlMmNhMTU0MDBmMTNjYTFhYzYwZTlkZC9kbWVzZy15b2N0by1sa3Atc2IwNC0yOjIwMTQw
MzI1MTkyNjA0Ong4Nl82NC1yYW5kY29uZmlnLXIzLTAzMjUxMDE0OjMuMTQuMC1yYzctbmV4
dC0yMDE0MDMyNDozCi9rZXJuZWwveDg2XzY0LXJhbmRjb25maWctcjMtMDMyNTEwMTQvMDk4
YmMxNjFiZmM3Njk3ZjdlMmNhMTU0MDBmMTNjYTFhYzYwZTlkZC9kbWVzZy15b2N0by1zdG9h
a2xleS03OjIwMTQwMzI1MTAyOTM4Ong4Nl82NC1yYW5kY29uZmlnLXIzLTAzMjUxMDE0OjMu
MTQuMC1yYzctbmV4dC0yMDE0MDMyNDozCi9rZXJuZWwveDg2XzY0LXJhbmRjb25maWctcjMt
MDMyNTEwMTQvMDk4YmMxNjFiZmM3Njk3ZjdlMmNhMTU0MDBmMTNjYTFhYzYwZTlkZC9kbWVz
Zy15b2N0by1pbm4tMjk6MjAxNDAzMjUxMDI5Mzg6eDg2XzY0LXJhbmRjb25maWctcjMtMDMy
NTEwMTQ6Ogova2VybmVsL3g4Nl82NC1yYW5kY29uZmlnLXIzLTAzMjUxMDE0LzA5OGJjMTYx
YmZjNzY5N2Y3ZTJjYTE1NDAwZjEzY2ExYWM2MGU5ZGQvZG1lc2cteW9jdG8tbGtwLXNiMDQt
MzY6MjAxNDAzMjUxOTI3Mjc6eDg2XzY0LXJhbmRjb25maWctcjMtMDMyNTEwMTQ6My4xNC4w
LXJjNy1uZXh0LTIwMTQwMzI0OjMKL2tlcm5lbC94ODZfNjQtcmFuZGNvbmZpZy1yMy0wMzI1
MTAxNC8wOThiYzE2MWJmYzc2OTdmN2UyY2ExNTQwMGYxM2NhMWFjNjBlOWRkL2RtZXNnLXlv
Y3RvLWxrcC1zYjA0LTg6MjAxNDAzMjUxOTI2MTY6eDg2XzY0LXJhbmRjb25maWctcjMtMDMy
NTEwMTQ6My4xNC4wLXJjNy1uZXh0LTIwMTQwMzI0OjMKL2tlcm5lbC94ODZfNjQtcmFuZGNv
bmZpZy1yMy0wMzI1MTAxNC8wOThiYzE2MWJmYzc2OTdmN2UyY2ExNTQwMGYxM2NhMWFjNjBl
OWRkL2RtZXNnLXlvY3RvLWxrcC1zYjA0LTMyOjIwMTQwMzI1MTkyNjI3Ong4Nl82NC1yYW5k
Y29uZmlnLXIzLTAzMjUxMDE0OjMuMTQuMC1yYzctbmV4dC0yMDE0MDMyNDozCi9rZXJuZWwv
eDg2XzY0LXJhbmRjb25maWctcjMtMDMyNTEwMTQvMDk4YmMxNjFiZmM3Njk3ZjdlMmNhMTU0
MDBmMTNjYTFhYzYwZTlkZC9kbWVzZy15b2N0by1zbmItMzg6MjAxNDAzMjUxMDI5Mzk6eDg2
XzY0LXJhbmRjb25maWctcjMtMDMyNTEwMTQ6Ogova2VybmVsL3g4Nl82NC1yYW5kY29uZmln
LXIzLTAzMjUxMDE0LzA5OGJjMTYxYmZjNzY5N2Y3ZTJjYTE1NDAwZjEzY2ExYWM2MGU5ZGQv
ZG1lc2cteW9jdG8taW5uLTQyOjIwMTQwMzI1MTAyOTM5Ong4Nl82NC1yYW5kY29uZmlnLXIz
LTAzMjUxMDE0OjoKL2tlcm5lbC94ODZfNjQtcmFuZGNvbmZpZy1yMy0wMzI1MTAxNC8wOThi
YzE2MWJmYzc2OTdmN2UyY2ExNTQwMGYxM2NhMWFjNjBlOWRkL2RtZXNnLXlvY3RvLWxrcC1z
YjA0LTU0OjIwMTQwMzI1MTAyOTQxOng4Nl82NC1yYW5kY29uZmlnLXIzLTAzMjUxMDE0OjMu
MTQuMC1yYzctbmV4dC0yMDE0MDMyNDozCi9rZXJuZWwveDg2XzY0LXJhbmRjb25maWctcjMt
MDMyNTEwMTQvMDk4YmMxNjFiZmM3Njk3ZjdlMmNhMTU0MDBmMTNjYTFhYzYwZTlkZC9kbWVz
Zy15b2N0by1pbm4tNDM6MjAxNDAzMjUxMDI5NDA6eDg2XzY0LXJhbmRjb25maWctcjMtMDMy
NTEwMTQ6Ogova2VybmVsL3g4Nl82NC1yYW5kY29uZmlnLXIzLTAzMjUxMDE0LzA5OGJjMTYx
YmZjNzY5N2Y3ZTJjYTE1NDAwZjEzY2ExYWM2MGU5ZGQvZG1lc2cteW9jdG8teGlhbi0xNToy
MDE0MDMyNTEwMjk0ODp4ODZfNjQtcmFuZGNvbmZpZy1yMy0wMzI1MTAxNDozLjE0LjAtcmM3
LW5leHQtMjAxNDAzMjQ6Mwova2VybmVsL3g4Nl82NC1yYW5kY29uZmlnLXIzLTAzMjUxMDE0
LzA5OGJjMTYxYmZjNzY5N2Y3ZTJjYTE1NDAwZjEzY2ExYWM2MGU5ZGQvZG1lc2cteW9jdG8t
aXZ5dG93bjItMjI6MjAxNDAzMjUxOTI3MjQ6eDg2XzY0LXJhbmRjb25maWctcjMtMDMyNTEw
MTQ6My4xNC4wLXJjNy1uZXh0LTIwMTQwMzI0OjMKL2tlcm5lbC94ODZfNjQtcmFuZGNvbmZp
Zy1yMy0wMzI1MTAxNC8wOThiYzE2MWJmYzc2OTdmN2UyY2ExNTQwMGYxM2NhMWFjNjBlOWRk
L2RtZXNnLXlvY3RvLWl2eXRvd24yLTc5OjIwMTQwMzI1MTkyNzMwOng4Nl82NC1yYW5kY29u
ZmlnLXIzLTAzMjUxMDE0OjMuMTQuMC1yYzctbmV4dC0yMDE0MDMyNDozCi9rZXJuZWwveDg2
XzY0LXJhbmRjb25maWctcjMtMDMyNTEwMTQvMDk4YmMxNjFiZmM3Njk3ZjdlMmNhMTU0MDBm
MTNjYTFhYzYwZTlkZC9kbWVzZy15b2N0by1pbm4tNjoyMDE0MDMyNTEwMjk0MDp4ODZfNjQt
cmFuZGNvbmZpZy1yMy0wMzI1MTAxNDo6CjQ6MTU6MTUgYWxsX2dvb2Q6YmFkOmFsbF9iYWQg
Ym9vdHMKCltkZXRhY2hlZCBIRUFEIGE5NDhkYjNdIFJldmVydCAidWZzOiBzYiBtdXRleCBt
ZXJnZSArIG11dGV4X2Rlc3Ryb3kiCiA0IGZpbGVzIGNoYW5nZWQsIDM2IGluc2VydGlvbnMo
KyksIDI1IGRlbGV0aW9ucygtKQpscyAtYSAva2VybmVsLXRlc3RzL3J1bi1xdWV1ZS9rdm0v
eDg2XzY0LXJhbmRjb25maWctcjMtMDMyNTEwMTQvbmV4dDptYXN0ZXI6YTk0OGRiMzhiN2Zh
ODYxZDZlNjg1MzhiNTU4Njc1ODc4Yzk3NmViODpiaXNlY3QtbGludXg1CgoyMDE0LTAzLTI1
LTIyOjIxOjQ3IGE5NDhkYjM4YjdmYTg2MWQ2ZTY4NTM4YjU1ODY3NTg3OGM5NzZlYjggY29t
cGlsaW5nClF1ZXVlZCBidWlsZCB0YXNrIHRvIC9rZXJuZWwtdGVzdHMvYnVpbGQtcXVldWUv
eDg2XzY0LXJhbmRjb25maWctcjMtMDMyNTEwMTQtYTk0OGRiMzhiN2ZhODYxZDZlNjg1Mzhi
NTU4Njc1ODc4Yzk3NmViOApDaGVjayBmb3Iga2VybmVsIGluIC9rZXJuZWwveDg2XzY0LXJh
bmRjb25maWctcjMtMDMyNTEwMTQvYTk0OGRiMzhiN2ZhODYxZDZlNjg1MzhiNTU4Njc1ODc4
Yzk3NmViOAp3YWl0aW5nIGZvciBjb21wbGV0aW9uIG9mIC9rZXJuZWwtdGVzdHMvYnVpbGQt
cXVldWUveDg2XzY0LXJhbmRjb25maWctcjMtMDMyNTEwMTQtYTk0OGRiMzhiN2ZhODYxZDZl
Njg1MzhiNTU4Njc1ODc4Yzk3NmViOApzdGF0dXM6IEZBSUw6IG5vIGNvbW1pdCBhOTQ4ZGIz
OGI3ZmE4NjFkNmU2ODUzOGI1NTg2NzU4NzhjOTc2ZWI4IGZvciBidWlsZCB0YXNrIHg4Nl82
NC1yYW5kY29uZmlnLXIzLTAzMjUxMDE0LWE5NDhkYjM4YjdmYTg2MWQ2ZTY4NTM4YjU1ODY3
NTg3OGM5NzZlYjgKMjAxNC0wMy0yNS0yMjo0NDo0NyBhOTQ4ZGIzOGI3ZmE4NjFkNmU2ODUz
OGI1NTg2NzU4NzhjOTc2ZWI4IFNLSVAgQlJPS0VOIEJVSUxECk5vIGtlcm5lbCBpbiAva2Vy
bmVsL3g4Nl82NC1yYW5kY29uZmlnLXIzLTAzMjUxMDE0L2E5NDhkYjM4YjdmYTg2MWQ2ZTY4
NTM4YjU1ODY3NTg3OGM5NzZlYjgKCj09PT09PT09PSB1cHN0cmVhbSA9PT09PT09PT0KV2Fy
bmluZzogeW91IGFyZSBsZWF2aW5nIDEgY29tbWl0IGJlaGluZCwgbm90IGNvbm5lY3RlZCB0
bwphbnkgb2YgeW91ciBicmFuY2hlczoKCiAgYTk0OGRiMyBSZXZlcnQgInVmczogc2IgbXV0
ZXggbWVyZ2UgKyBtdXRleF9kZXN0cm95IgoKSWYgeW91IHdhbnQgdG8ga2VlcCB0aGVtIGJ5
IGNyZWF0aW5nIGEgbmV3IGJyYW5jaCwgdGhpcyBtYXkgYmUgYSBnb29kIHRpbWUKdG8gZG8g
c28gd2l0aDoKCiBnaXQgYnJhbmNoIG5ld19icmFuY2hfbmFtZSBhOTQ4ZGIzCgpIRUFEIGlz
IG5vdyBhdCBiMDk4ZDY3Li4uIExpbnV4IDMuMTQtcmM4CmxzIC1hIC9rZXJuZWwtdGVzdHMv
cnVuLXF1ZXVlL2t2bS94ODZfNjQtcmFuZGNvbmZpZy1yMy0wMzI1MTAxNC9uZXh0Om1hc3Rl
cjpiMDk4ZDY3MjZiYmZiOTRjMDZkNmUxMDk3NDY2MTg3YWZkZGFlNjFmOmJpc2VjdC1saW51
eDUKCjIwMTQtMDMtMjUtMjI6NDQ6NTIgYjA5OGQ2NzI2YmJmYjk0YzA2ZDZlMTA5NzQ2NjE4
N2FmZGRhZTYxZiBjb21waWxpbmcKUXVldWVkIGJ1aWxkIHRhc2sgdG8gL2tlcm5lbC10ZXN0
cy9idWlsZC1xdWV1ZS94ODZfNjQtcmFuZGNvbmZpZy1yMy0wMzI1MTAxNC1iMDk4ZDY3MjZi
YmZiOTRjMDZkNmUxMDk3NDY2MTg3YWZkZGFlNjFmCkNoZWNrIGZvciBrZXJuZWwgaW4gL2tl
cm5lbC94ODZfNjQtcmFuZGNvbmZpZy1yMy0wMzI1MTAxNC9iMDk4ZDY3MjZiYmZiOTRjMDZk
NmUxMDk3NDY2MTg3YWZkZGFlNjFmCndhaXRpbmcgZm9yIGNvbXBsZXRpb24gb2YgL2tlcm5l
bC10ZXN0cy9idWlsZC1xdWV1ZS94ODZfNjQtcmFuZGNvbmZpZy1yMy0wMzI1MTAxNC1iMDk4
ZDY3MjZiYmZiOTRjMDZkNmUxMDk3NDY2MTg3YWZkZGFlNjFmCndhaXRpbmcgZm9yIGNvbXBs
ZXRpb24gb2YgL2tlcm5lbC10ZXN0cy9idWlsZC1xdWV1ZS8ueDg2XzY0LXJhbmRjb25maWct
cjMtMDMyNTEwMTQtYjA5OGQ2NzI2YmJmYjk0YzA2ZDZlMTA5NzQ2NjE4N2FmZGRhZTYxZgpr
ZXJuZWw6IC9rZXJuZWwveDg2XzY0LXJhbmRjb25maWctcjMtMDMyNTEwMTQvYjA5OGQ2NzI2
YmJmYjk0YzA2ZDZlMTA5NzQ2NjE4N2FmZGRhZTYxZi92bWxpbnV6LTMuMTQuMC1yYzgKCjIw
MTQtMDMtMjUtMjM6MDE6NTIgZGV0ZWN0aW5nIGJvb3Qgc3RhdGUgLgkyCTQJOQkxNwkyMwkz
OQk1MAk1MQk1NQk2OQk4Mgk5Mwk5OQkxMDMJMTE1CTExOAkxMzAJMTM2CTE1NQkxNjMJMTcx
IFNVQ0NFU1MKCgo9PT09PT09PT0gbGludXgtbmV4dCA9PT09PT09PT0KUHJldmlvdXMgSEVB
RCBwb3NpdGlvbiB3YXMgYjA5OGQ2Ny4uLiBMaW51eCAzLjE0LXJjOApIRUFEIGlzIG5vdyBh
dCAyZWM2YWI3Li4uIEFkZCBsaW51eC1uZXh0IHNwZWNpZmljIGZpbGVzIGZvciAyMDE0MDMy
NQpscyAtYSAva2VybmVsLXRlc3RzL3J1bi1xdWV1ZS9rdm0veDg2XzY0LXJhbmRjb25maWct
cjMtMDMyNTEwMTQvbmV4dDptYXN0ZXI6MmVjNmFiNzQ0NWI2NTk1ODlhYmY1YjljZjZjMDg3
YzQyMGQ0MzliZDpiaXNlY3QtbGludXg1CgoyMDE0LTAzLTI1LTIzOjE1OjE5IDJlYzZhYjc0
NDViNjU5NTg5YWJmNWI5Y2Y2YzA4N2M0MjBkNDM5YmQgY29tcGlsaW5nClF1ZXVlZCBidWls
ZCB0YXNrIHRvIC9rZXJuZWwtdGVzdHMvYnVpbGQtcXVldWUveDg2XzY0LXJhbmRjb25maWct
cjMtMDMyNTEwMTQtMmVjNmFiNzQ0NWI2NTk1ODlhYmY1YjljZjZjMDg3YzQyMGQ0MzliZApD
aGVjayBmb3Iga2VybmVsIGluIC9rZXJuZWwveDg2XzY0LXJhbmRjb25maWctcjMtMDMyNTEw
MTQvMmVjNmFiNzQ0NWI2NTk1ODlhYmY1YjljZjZjMDg3YzQyMGQ0MzliZAp3YWl0aW5nIGZv
ciBjb21wbGV0aW9uIG9mIC9rZXJuZWwtdGVzdHMvYnVpbGQtcXVldWUveDg2XzY0LXJhbmRj
b25maWctcjMtMDMyNTEwMTQtMmVjNmFiNzQ0NWI2NTk1ODlhYmY1YjljZjZjMDg3YzQyMGQ0
MzliZAp3YWl0aW5nIGZvciBjb21wbGV0aW9uIG9mIC9rZXJuZWwtdGVzdHMvYnVpbGQtcXVl
dWUvLng4Nl82NC1yYW5kY29uZmlnLXIzLTAzMjUxMDE0LTJlYzZhYjc0NDViNjU5NTg5YWJm
NWI5Y2Y2YzA4N2M0MjBkNDM5YmQKa2VybmVsOiAva2VybmVsL3g4Nl82NC1yYW5kY29uZmln
LXIzLTAzMjUxMDE0LzJlYzZhYjc0NDViNjU5NTg5YWJmNWI5Y2Y2YzA4N2M0MjBkNDM5YmQv
dm1saW51ei0zLjE0LjAtcmM3LW5leHQtMjAxNDAzMjUKCjIwMTQtMDMtMjUtMjM6MTg6MTkg
ZGV0ZWN0aW5nIGJvb3Qgc3RhdGUgLi4JMwk4CTEzCTIzCTI3CTQ3CTUwIFRFU1QgRkFJTFVS
RQpbICAgIDYuMDg3MTkwXSBmbGFnIDAKWyAgICA2LjA4NzU4Ml0gdWZzIHdhcyBjb21waWxl
ZCB3aXRoIHJlYWQtb25seSBzdXBwb3J0LCBjYW4ndCBiZSBtb3VudGVkIGFzIHJlYWQtd3Jp
dGUKWyAgICA2LjA4OTA1NF0gLS0tLS0tLS0tLS0tWyBjdXQgaGVyZSBdLS0tLS0tLS0tLS0t
ClsgICAgNi4wODk5NjBdIFdBUk5JTkc6IENQVTogMCBQSUQ6IDU4NCBhdCBrZXJuZWwvbG9j
a2luZy9tdXRleC1kZWJ1Zy5jOjExNyBtdXRleF9kZXN0cm95KzB4NGMvMHg2NSgpClsgICAg
Ni4wOTIxMzRdIEhQRlM6IGhwZnNfbWFwX3NlY3RvcjogcmVhZCBlcnJvcgpbICAgIDYuMDky
OTY2XSBmbGFnIDAKWyAgICA2LjA5MzM3OV0gdWZzIHdhcyBjb21waWxlZCB3aXRoIHJlYWQt
b25seSBzdXBwb3J0LCBjYW4ndCBiZSBtb3VudGVkIGFzIHJlYWQtd3JpdGUKL2tlcm5lbC94
ODZfNjQtcmFuZGNvbmZpZy1yMy0wMzI1MTAxNC8yZWM2YWI3NDQ1YjY1OTU4OWFiZjViOWNm
NmMwODdjNDIwZDQzOWJkL2RtZXNnLXlvY3RvLWxrcC1zYjA0LTIzOjIwMTQwMzI1MjMyMjMz
Ong4Nl82NC1yYW5kY29uZmlnLXIzLTAzMjUxMDE0OjMuMTQuMC1yYzctbmV4dC0yMDE0MDMy
NToxCjUyOjE6MSBhbGxfZ29vZDpiYWQ6YWxsX2JhZCBib290cwobWzE7MzVtMjAxNC0wMy0y
NSAyMzoyMjo1MSBSRVBFQVQgQ09VTlQ6IDU0MCAgIyAva2VybmVsLXRlc3RzL2xpbnV4NS9v
YmotYmlzZWN0Ly5yZXBlYXQbWzBtCgo=

--DocE+STaALJfprDB
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="config-3.14.0-rc7-11620-gc7d2e32"

#
# Automatically generated file; DO NOT EDIT.
# Linux/x86_64 3.14.0-rc7 Kernel Configuration
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
# CONFIG_KERNEL_LZMA is not set
# CONFIG_KERNEL_XZ is not set
CONFIG_KERNEL_LZO=y
# CONFIG_KERNEL_LZ4 is not set
CONFIG_DEFAULT_HOSTNAME="(none)"
# CONFIG_SWAP is not set
CONFIG_SYSVIPC=y
# CONFIG_POSIX_MQUEUE is not set
CONFIG_FHANDLE=y
# CONFIG_USELIB is not set
CONFIG_AUDIT=y
CONFIG_HAVE_ARCH_AUDITSYSCALL=y
# CONFIG_AUDITSYSCALL is not set

#
# IRQ subsystem
#
CONFIG_GENERIC_IRQ_PROBE=y
CONFIG_GENERIC_IRQ_SHOW=y
CONFIG_IRQ_DOMAIN=y
# CONFIG_IRQ_DOMAIN_DEBUG is not set
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
CONFIG_NO_HZ=y
# CONFIG_HIGH_RES_TIMERS is not set

#
# CPU/Task time and stats accounting
#
CONFIG_TICK_CPU_ACCOUNTING=y
# CONFIG_VIRT_CPU_ACCOUNTING_GEN is not set
# CONFIG_IRQ_TIME_ACCOUNTING is not set
# CONFIG_BSD_PROCESS_ACCT is not set
# CONFIG_TASKSTATS is not set

#
# RCU Subsystem
#
CONFIG_TREE_PREEMPT_RCU=y
CONFIG_PREEMPT_RCU=y
CONFIG_RCU_STALL_COMMON=y
CONFIG_RCU_FANOUT=64
CONFIG_RCU_FANOUT_LEAF=16
# CONFIG_RCU_FANOUT_EXACT is not set
# CONFIG_TREE_RCU_TRACE is not set
CONFIG_RCU_BOOST=y
CONFIG_RCU_BOOST_PRIO=1
CONFIG_RCU_BOOST_DELAY=500
CONFIG_RCU_NOCB_CPU=y
# CONFIG_RCU_NOCB_CPU_NONE is not set
CONFIG_RCU_NOCB_CPU_ZERO=y
# CONFIG_RCU_NOCB_CPU_ALL is not set
CONFIG_IKCONFIG=y
CONFIG_IKCONFIG_PROC=y
CONFIG_LOG_BUF_SHIFT=17
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
# CONFIG_KALLSYMS_ALL is not set
CONFIG_PRINTK=y
CONFIG_BUG=y
# CONFIG_ELF_CORE is not set
# CONFIG_PCSPKR_PLATFORM is not set
# CONFIG_BASE_FULL is not set
CONFIG_FUTEX=y
CONFIG_EPOLL=y
CONFIG_SIGNALFD=y
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
# CONFIG_SLUB_DEBUG is not set
# CONFIG_COMPAT_BRK is not set
# CONFIG_SLAB is not set
CONFIG_SLUB=y
# CONFIG_SLOB is not set
# CONFIG_PROFILING is not set
CONFIG_TRACEPOINTS=y
CONFIG_HAVE_OPROFILE=y
CONFIG_OPROFILE_NMI_TIMER=y
CONFIG_JUMP_LABEL=y
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
CONFIG_HAVE_CC_STACKPROTECTOR=y
CONFIG_CC_STACKPROTECTOR=y
# CONFIG_CC_STACKPROTECTOR_NONE is not set
CONFIG_CC_STACKPROTECTOR_REGULAR=y
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
CONFIG_GCOV_KERNEL=y
# CONFIG_GCOV_PROFILE_ALL is not set
# CONFIG_GCOV_FORMAT_AUTODETECT is not set
CONFIG_GCOV_FORMAT_3_4=y
# CONFIG_GCOV_FORMAT_4_7 is not set
# CONFIG_HAVE_GENERIC_DMA_COHERENT is not set
CONFIG_RT_MUTEXES=y
CONFIG_BASE_SMALL=1
CONFIG_SYSTEM_TRUSTED_KEYRING=y
# CONFIG_MODULES is not set
CONFIG_BLOCK=y
CONFIG_BLK_DEV_BSG=y
CONFIG_BLK_DEV_BSGLIB=y
CONFIG_BLK_DEV_INTEGRITY=y
CONFIG_BLK_CMDLINE_PARSER=y

#
# Partition Types
#
CONFIG_PARTITION_ADVANCED=y
CONFIG_ACORN_PARTITION=y
CONFIG_ACORN_PARTITION_CUMANA=y
# CONFIG_ACORN_PARTITION_EESOX is not set
CONFIG_ACORN_PARTITION_ICS=y
CONFIG_ACORN_PARTITION_ADFS=y
# CONFIG_ACORN_PARTITION_POWERTEC is not set
# CONFIG_ACORN_PARTITION_RISCIX is not set
# CONFIG_AIX_PARTITION is not set
CONFIG_OSF_PARTITION=y
CONFIG_AMIGA_PARTITION=y
CONFIG_ATARI_PARTITION=y
CONFIG_MAC_PARTITION=y
# CONFIG_MSDOS_PARTITION is not set
# CONFIG_LDM_PARTITION is not set
CONFIG_SGI_PARTITION=y
CONFIG_ULTRIX_PARTITION=y
CONFIG_SUN_PARTITION=y
CONFIG_KARMA_PARTITION=y
# CONFIG_EFI_PARTITION is not set
# CONFIG_SYSV68_PARTITION is not set
CONFIG_CMDLINE_PARTITION=y
CONFIG_BLOCK_COMPAT=y

#
# IO Schedulers
#
CONFIG_IOSCHED_NOOP=y
CONFIG_IOSCHED_DEADLINE=y
# CONFIG_IOSCHED_CFQ is not set
CONFIG_DEFAULT_DEADLINE=y
# CONFIG_DEFAULT_NOOP is not set
CONFIG_DEFAULT_IOSCHED="deadline"
CONFIG_ASN1=y
CONFIG_UNINLINE_SPIN_UNLOCK=y
CONFIG_FREEZER=y

#
# Processor type and features
#
CONFIG_ZONE_DMA=y
# CONFIG_SMP is not set
# CONFIG_X86_MPPARSE is not set
# CONFIG_X86_EXTENDED_PLATFORM is not set
# CONFIG_X86_INTEL_LPSS is not set
CONFIG_X86_SUPPORTS_MEMORY_FAILURE=y
# CONFIG_SCHED_OMIT_FRAME_POINTER is not set
CONFIG_HYPERVISOR_GUEST=y
CONFIG_PARAVIRT=y
CONFIG_PARAVIRT_DEBUG=y
CONFIG_XEN=y
CONFIG_XEN_DOM0=y
CONFIG_XEN_PVHVM=y
CONFIG_XEN_MAX_DOMAIN_MEMORY=500
CONFIG_XEN_SAVE_RESTORE=y
CONFIG_XEN_DEBUG_FS=y
# CONFIG_XEN_PVH is not set
CONFIG_KVM_GUEST=y
# CONFIG_KVM_DEBUG_FS is not set
# CONFIG_PARAVIRT_TIME_ACCOUNTING is not set
CONFIG_PARAVIRT_CLOCK=y
CONFIG_NO_BOOTMEM=y
CONFIG_MEMTEST=y
# CONFIG_MK8 is not set
CONFIG_MPSC=y
# CONFIG_MCORE2 is not set
# CONFIG_MATOM is not set
# CONFIG_GENERIC_CPU is not set
CONFIG_X86_INTERNODE_CACHE_SHIFT=7
CONFIG_X86_L1_CACHE_SHIFT=7
CONFIG_X86_P6_NOP=y
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
CONFIG_DMI=y
# CONFIG_GART_IOMMU is not set
# CONFIG_CALGARY_IOMMU is not set
CONFIG_SWIOTLB=y
CONFIG_IOMMU_HELPER=y
CONFIG_NR_CPUS=1
# CONFIG_PREEMPT_NONE is not set
# CONFIG_PREEMPT_VOLUNTARY is not set
CONFIG_PREEMPT=y
CONFIG_PREEMPT_COUNT=y
CONFIG_X86_LOCAL_APIC=y
CONFIG_X86_IO_APIC=y
CONFIG_X86_REROUTE_FOR_BROKEN_BOOT_IRQS=y
CONFIG_X86_MCE=y
CONFIG_X86_MCE_INTEL=y
CONFIG_X86_MCE_AMD=y
CONFIG_X86_MCE_THRESHOLD=y
CONFIG_X86_MCE_INJECT=y
CONFIG_X86_THERMAL_VECTOR=y
CONFIG_I8K=y
# CONFIG_MICROCODE is not set
# CONFIG_MICROCODE_INTEL_EARLY is not set
# CONFIG_MICROCODE_AMD_EARLY is not set
CONFIG_X86_MSR=y
CONFIG_X86_CPUID=y
CONFIG_ARCH_PHYS_ADDR_T_64BIT=y
CONFIG_ARCH_DMA_ADDR_T_64BIT=y
# CONFIG_DIRECT_GBPAGES is not set
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
CONFIG_SPARSEMEM_VMEMMAP=y
CONFIG_HAVE_MEMBLOCK=y
CONFIG_HAVE_MEMBLOCK_NODE_MAP=y
CONFIG_ARCH_DISCARD_MEMBLOCK=y
CONFIG_MEMORY_ISOLATION=y
# CONFIG_HAVE_BOOTMEM_INFO_NODE is not set
# CONFIG_MEMORY_HOTPLUG is not set
CONFIG_PAGEFLAGS_EXTENDED=y
CONFIG_SPLIT_PTLOCK_CPUS=4
CONFIG_ARCH_ENABLE_SPLIT_PMD_PTLOCK=y
CONFIG_COMPACTION=y
CONFIG_MIGRATION=y
CONFIG_PHYS_ADDR_T_64BIT=y
CONFIG_ZONE_DMA_FLAG=1
CONFIG_BOUNCE=y
CONFIG_VIRT_TO_BUS=y
CONFIG_MMU_NOTIFIER=y
# CONFIG_KSM is not set
CONFIG_DEFAULT_MMAP_MIN_ADDR=4096
CONFIG_ARCH_SUPPORTS_MEMORY_FAILURE=y
# CONFIG_MEMORY_FAILURE is not set
CONFIG_TRANSPARENT_HUGEPAGE=y
# CONFIG_TRANSPARENT_HUGEPAGE_ALWAYS is not set
CONFIG_TRANSPARENT_HUGEPAGE_MADVISE=y
# CONFIG_CROSS_MEMORY_ATTACH is not set
CONFIG_NEED_PER_CPU_KM=y
# CONFIG_CLEANCACHE is not set
CONFIG_CMA=y
# CONFIG_CMA_DEBUG is not set
# CONFIG_ZBUD is not set
# CONFIG_MEM_SOFT_DIRTY is not set
# CONFIG_ZSMALLOC is not set
CONFIG_GENERIC_EARLY_IOREMAP=y
# CONFIG_X86_CHECK_BIOS_CORRUPTION is not set
CONFIG_X86_RESERVE_LOW=64
# CONFIG_MTRR is not set
CONFIG_ARCH_RANDOM=y
# CONFIG_X86_SMAP is not set
# CONFIG_EFI is not set
CONFIG_SECCOMP=y
# CONFIG_HZ_100 is not set
# CONFIG_HZ_250 is not set
# CONFIG_HZ_300 is not set
CONFIG_HZ_1000=y
CONFIG_HZ=1000
# CONFIG_SCHED_HRTICK is not set
CONFIG_KEXEC=y
CONFIG_CRASH_DUMP=y
CONFIG_PHYSICAL_START=0x1000000
# CONFIG_RELOCATABLE is not set
CONFIG_PHYSICAL_ALIGN=0x200000
# CONFIG_COMPAT_VDSO is not set
# CONFIG_CMDLINE_BOOL is not set
CONFIG_ARCH_ENABLE_MEMORY_HOTPLUG=y

#
# Power management and ACPI options
#
CONFIG_SUSPEND=y
CONFIG_SUSPEND_FREEZER=y
CONFIG_HIBERNATE_CALLBACKS=y
CONFIG_PM_SLEEP=y
# CONFIG_PM_AUTOSLEEP is not set
CONFIG_PM_WAKELOCKS=y
CONFIG_PM_WAKELOCKS_LIMIT=100
# CONFIG_PM_WAKELOCKS_GC is not set
CONFIG_PM_RUNTIME=y
CONFIG_PM=y
# CONFIG_PM_DEBUG is not set
# CONFIG_WQ_POWER_EFFICIENT_DEFAULT is not set
CONFIG_ACPI=y
CONFIG_ACPI_SLEEP=y
# CONFIG_ACPI_EC_DEBUGFS is not set
CONFIG_ACPI_AC=y
CONFIG_ACPI_BATTERY=y
CONFIG_ACPI_BUTTON=y
# CONFIG_ACPI_VIDEO is not set
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
# CONFIG_ACPI_EXTLOG is not set
CONFIG_SFI=y

#
# CPU Frequency scaling
#
CONFIG_CPU_FREQ=y
CONFIG_CPU_FREQ_GOV_COMMON=y
# CONFIG_CPU_FREQ_STAT is not set
# CONFIG_CPU_FREQ_DEFAULT_GOV_PERFORMANCE is not set
CONFIG_CPU_FREQ_DEFAULT_GOV_POWERSAVE=y
# CONFIG_CPU_FREQ_DEFAULT_GOV_USERSPACE is not set
# CONFIG_CPU_FREQ_DEFAULT_GOV_ONDEMAND is not set
# CONFIG_CPU_FREQ_DEFAULT_GOV_CONSERVATIVE is not set
CONFIG_CPU_FREQ_GOV_PERFORMANCE=y
CONFIG_CPU_FREQ_GOV_POWERSAVE=y
CONFIG_CPU_FREQ_GOV_USERSPACE=y
CONFIG_CPU_FREQ_GOV_ONDEMAND=y
CONFIG_CPU_FREQ_GOV_CONSERVATIVE=y

#
# x86 CPU frequency scaling drivers
#
CONFIG_X86_INTEL_PSTATE=y
# CONFIG_X86_PCC_CPUFREQ is not set
# CONFIG_X86_ACPI_CPUFREQ is not set
# CONFIG_X86_SPEEDSTEP_CENTRINO is not set
CONFIG_X86_P4_CLOCKMOD=y

#
# shared options
#
CONFIG_X86_SPEEDSTEP_LIB=y

#
# CPU Idle
#
CONFIG_CPU_IDLE=y
# CONFIG_CPU_IDLE_MULTIPLE_DRIVERS is not set
# CONFIG_CPU_IDLE_GOV_LADDER is not set
CONFIG_CPU_IDLE_GOV_MENU=y
# CONFIG_ARCH_NEEDS_CPU_IDLE_COUPLED is not set
CONFIG_INTEL_IDLE=y

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
CONFIG_PCI_XEN=y
CONFIG_PCI_DOMAINS=y
# CONFIG_PCI_CNB20LE_QUIRK is not set
# CONFIG_PCIEPORTBUS is not set
CONFIG_PCI_MSI=y
# CONFIG_PCI_DEBUG is not set
# CONFIG_PCI_REALLOC_ENABLE_AUTO is not set
# CONFIG_PCI_STUB is not set
CONFIG_XEN_PCIDEV_FRONTEND=y
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
CONFIG_AMD_NB=y
# CONFIG_PCCARD is not set
# CONFIG_HOTPLUG_PCI is not set
CONFIG_RAPIDIO=y
CONFIG_RAPIDIO_DISC_TIMEOUT=30
CONFIG_RAPIDIO_ENABLE_RX_TX_PORTS=y
# CONFIG_RAPIDIO_DMA_ENGINE is not set
# CONFIG_RAPIDIO_DEBUG is not set
CONFIG_RAPIDIO_ENUM_BASIC=y

#
# RapidIO Switch drivers
#
# CONFIG_RAPIDIO_TSI57X is not set
CONFIG_RAPIDIO_CPS_XX=y
CONFIG_RAPIDIO_TSI568=y
# CONFIG_RAPIDIO_CPS_GEN2 is not set
# CONFIG_X86_SYSFB is not set

#
# Executable file formats / Emulations
#
CONFIG_BINFMT_ELF=y
CONFIG_COMPAT_BINFMT_ELF=y
CONFIG_ARCH_BINFMT_ELF_RANDOMIZE_PIE=y
CONFIG_BINFMT_SCRIPT=y
# CONFIG_HAVE_AOUT is not set
CONFIG_BINFMT_MISC=y
CONFIG_COREDUMP=y
CONFIG_IA32_EMULATION=y
# CONFIG_IA32_AOUT is not set
CONFIG_X86_X32=y
CONFIG_COMPAT=y
CONFIG_COMPAT_FOR_U64_ALIGNMENT=y
CONFIG_SYSVIPC_COMPAT=y
CONFIG_KEYS_COMPAT=y
CONFIG_X86_DEV_DMA_OPS=y
CONFIG_IOSF_MBI=y
CONFIG_NET=y

#
# Networking options
#
# CONFIG_PACKET is not set
CONFIG_UNIX=y
CONFIG_UNIX_DIAG=y
CONFIG_XFRM=y
CONFIG_XFRM_ALGO=y
CONFIG_XFRM_SUB_POLICY=y
# CONFIG_XFRM_MIGRATE is not set
CONFIG_NET_KEY=y
# CONFIG_NET_KEY_MIGRATE is not set
# CONFIG_INET is not set
# CONFIG_NETWORK_SECMARK is not set
# CONFIG_NETWORK_PHY_TIMESTAMPING is not set
CONFIG_NETFILTER=y
# CONFIG_NETFILTER_DEBUG is not set
CONFIG_NETFILTER_ADVANCED=y

#
# DECnet: Netfilter Configuration
#
CONFIG_DECNET_NF_GRABULATOR=y
CONFIG_ATM=y
# CONFIG_ATM_LANE is not set
CONFIG_STP=y
CONFIG_GARP=y
CONFIG_MRP=y
# CONFIG_BRIDGE is not set
CONFIG_VLAN_8021Q=y
CONFIG_VLAN_8021Q_GVRP=y
CONFIG_VLAN_8021Q_MVRP=y
CONFIG_DECNET=y
# CONFIG_DECNET_ROUTER is not set
CONFIG_LLC=y
CONFIG_LLC2=y
CONFIG_IPX=y
# CONFIG_IPX_INTERN is not set
# CONFIG_ATALK is not set
# CONFIG_X25 is not set
CONFIG_LAPB=y
# CONFIG_PHONET is not set
# CONFIG_IEEE802154 is not set
# CONFIG_NET_SCHED is not set
# CONFIG_DCB is not set
CONFIG_DNS_RESOLVER=y
CONFIG_BATMAN_ADV=y
CONFIG_BATMAN_ADV_NC=y
# CONFIG_BATMAN_ADV_DEBUG is not set
CONFIG_OPENVSWITCH=y
CONFIG_VSOCKETS=y
# CONFIG_NETLINK_MMAP is not set
CONFIG_NETLINK_DIAG=y
CONFIG_NET_MPLS_GSO=y
# CONFIG_HSR is not set
CONFIG_NET_RX_BUSY_POLL=y
CONFIG_BQL=y

#
# Network testing
#
CONFIG_HAMRADIO=y

#
# Packet Radio protocols
#
CONFIG_AX25=y
# CONFIG_AX25_DAMA_SLAVE is not set
CONFIG_NETROM=y
CONFIG_ROSE=y

#
# AX.25 network device drivers
#
CONFIG_MKISS=y
CONFIG_6PACK=y
CONFIG_BPQETHER=y
CONFIG_BAYCOM_SER_FDX=y
CONFIG_BAYCOM_SER_HDX=y
CONFIG_BAYCOM_PAR=y
CONFIG_YAM=y
CONFIG_CAN=y
# CONFIG_CAN_RAW is not set
CONFIG_CAN_BCM=y
CONFIG_CAN_GW=y

#
# CAN Device Drivers
#
CONFIG_CAN_VCAN=y
CONFIG_CAN_SLCAN=y
CONFIG_CAN_DEV=y
# CONFIG_CAN_CALC_BITTIMING is not set
CONFIG_CAN_LEDS=y
CONFIG_CAN_JANZ_ICAN3=y
CONFIG_PCH_CAN=y
CONFIG_CAN_SJA1000=y
# CONFIG_CAN_SJA1000_ISA is not set
CONFIG_CAN_SJA1000_PLATFORM=y
CONFIG_CAN_EMS_PCI=y
CONFIG_CAN_PEAK_PCI=y
# CONFIG_CAN_PEAK_PCIEC is not set
CONFIG_CAN_KVASER_PCI=y
CONFIG_CAN_PLX_PCI=y
CONFIG_CAN_C_CAN=y
CONFIG_CAN_C_CAN_PLATFORM=y
# CONFIG_CAN_C_CAN_PCI is not set
CONFIG_CAN_CC770=y
# CONFIG_CAN_CC770_ISA is not set
CONFIG_CAN_CC770_PLATFORM=y

#
# CAN USB interfaces
#
CONFIG_CAN_EMS_USB=y
CONFIG_CAN_ESD_USB2=y
# CONFIG_CAN_KVASER_USB is not set
CONFIG_CAN_PEAK_USB=y
# CONFIG_CAN_8DEV_USB is not set
CONFIG_CAN_SOFTING=y
# CONFIG_CAN_DEBUG_DEVICES is not set
# CONFIG_IRDA is not set
# CONFIG_BT is not set
CONFIG_WIRELESS=y
CONFIG_CFG80211=y
CONFIG_NL80211_TESTMODE=y
CONFIG_CFG80211_DEVELOPER_WARNINGS=y
# CONFIG_CFG80211_REG_DEBUG is not set
# CONFIG_CFG80211_CERTIFICATION_ONUS is not set
# CONFIG_CFG80211_DEFAULT_PS is not set
CONFIG_CFG80211_DEBUGFS=y
# CONFIG_CFG80211_INTERNAL_REGDB is not set
# CONFIG_CFG80211_WEXT is not set
# CONFIG_LIB80211 is not set
# CONFIG_MAC80211 is not set
# CONFIG_WIMAX is not set
CONFIG_RFKILL=y
CONFIG_RFKILL_LEDS=y
# CONFIG_RFKILL_INPUT is not set
# CONFIG_RFKILL_REGULATOR is not set
CONFIG_NET_9P=y
# CONFIG_NET_9P_VIRTIO is not set
# CONFIG_NET_9P_DEBUG is not set
CONFIG_CAIF=y
CONFIG_CAIF_DEBUG=y
CONFIG_CAIF_NETDEV=y
CONFIG_CAIF_USB=y
# CONFIG_NFC is not set
CONFIG_HAVE_BPF_JIT=y

#
# Device Drivers
#

#
# Generic Driver Options
#
CONFIG_UEVENT_HELPER_PATH=""
# CONFIG_DEVTMPFS is not set
CONFIG_STANDALONE=y
CONFIG_PREVENT_FIRMWARE_BUILD=y
CONFIG_FW_LOADER=y
# CONFIG_FIRMWARE_IN_KERNEL is not set
CONFIG_EXTRA_FIRMWARE=""
# CONFIG_FW_LOADER_USER_HELPER is not set
# CONFIG_DEBUG_DRIVER is not set
# CONFIG_DEBUG_DEVRES is not set
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
# CONFIG_PARPORT_PC_FIFO is not set
CONFIG_PARPORT_PC_SUPERIO=y
# CONFIG_PARPORT_GSC is not set
# CONFIG_PARPORT_AX88796 is not set
# CONFIG_PARPORT_1284 is not set
CONFIG_PARPORT_NOT_PC=y
CONFIG_PNP=y
CONFIG_PNP_DEBUG_MESSAGES=y

#
# Protocols
#
CONFIG_PNPACPI=y
CONFIG_BLK_DEV=y
# CONFIG_BLK_DEV_NULL_BLK is not set
CONFIG_BLK_DEV_FD=y
# CONFIG_PARIDE is not set
# CONFIG_BLK_DEV_PCIESSD_MTIP32XX is not set
CONFIG_BLK_CPQ_CISS_DA=y
CONFIG_CISS_SCSI_TAPE=y
CONFIG_BLK_DEV_DAC960=y
# CONFIG_BLK_DEV_UMEM is not set
# CONFIG_BLK_DEV_COW_COMMON is not set
# CONFIG_BLK_DEV_LOOP is not set

#
# DRBD disabled because PROC_FS or INET not selected
#
CONFIG_BLK_DEV_NBD=y
CONFIG_BLK_DEV_NVME=y
# CONFIG_BLK_DEV_SKD is not set
# CONFIG_BLK_DEV_SX8 is not set
# CONFIG_BLK_DEV_RAM is not set
CONFIG_CDROM_PKTCDVD=y
CONFIG_CDROM_PKTCDVD_BUFFERS=8
# CONFIG_CDROM_PKTCDVD_WCACHE is not set
CONFIG_ATA_OVER_ETH=y
CONFIG_XEN_BLKDEV_FRONTEND=y
# CONFIG_XEN_BLKDEV_BACKEND is not set
# CONFIG_VIRTIO_BLK is not set
CONFIG_BLK_DEV_HD=y
# CONFIG_BLK_DEV_RSXX is not set

#
# Misc devices
#
CONFIG_SENSORS_LIS3LV02D=y
CONFIG_AD525X_DPOT=y
CONFIG_AD525X_DPOT_I2C=y
CONFIG_DUMMY_IRQ=y
CONFIG_IBM_ASM=y
CONFIG_PHANTOM=y
CONFIG_INTEL_MID_PTI=y
CONFIG_SGI_IOC4=y
CONFIG_TIFM_CORE=y
CONFIG_TIFM_7XX1=y
CONFIG_ICS932S401=y
CONFIG_ATMEL_SSC=y
CONFIG_ENCLOSURE_SERVICES=y
CONFIG_HP_ILO=y
# CONFIG_APDS9802ALS is not set
# CONFIG_ISL29003 is not set
# CONFIG_ISL29020 is not set
CONFIG_SENSORS_TSL2550=y
CONFIG_SENSORS_BH1780=y
# CONFIG_SENSORS_BH1770 is not set
# CONFIG_SENSORS_APDS990X is not set
# CONFIG_HMC6352 is not set
CONFIG_DS1682=y
CONFIG_VMWARE_BALLOON=y
# CONFIG_BMP085_I2C is not set
CONFIG_PCH_PHUB=y
CONFIG_USB_SWITCH_FSA9480=y
CONFIG_SRAM=y
CONFIG_C2PORT=y
CONFIG_C2PORT_DURAMAR_2150=y

#
# EEPROM support
#
# CONFIG_EEPROM_AT24 is not set
CONFIG_EEPROM_LEGACY=y
CONFIG_EEPROM_MAX6875=y
# CONFIG_EEPROM_93CX6 is not set
CONFIG_CB710_CORE=y
CONFIG_CB710_DEBUG=y
CONFIG_CB710_DEBUG_ASSUMPTIONS=y

#
# Texas Instruments shared transport line discipline
#
CONFIG_SENSORS_LIS3_I2C=y

#
# Altera FPGA firmware download module
#
CONFIG_ALTERA_STAPL=y
CONFIG_INTEL_MEI=y
# CONFIG_INTEL_MEI_ME is not set
CONFIG_INTEL_MEI_TXE=y
# CONFIG_VMWARE_VMCI is not set

#
# Intel MIC Host Driver
#
CONFIG_INTEL_MIC_HOST=y

#
# Intel MIC Card Driver
#
CONFIG_INTEL_MIC_CARD=y
# CONFIG_GENWQE is not set
CONFIG_ECHO=y
CONFIG_HAVE_IDE=y
CONFIG_IDE=y

#
# Please see Documentation/ide/ide.txt for help/info on IDE drives
#
CONFIG_IDE_XFER_MODE=y
CONFIG_IDE_TIMINGS=y
CONFIG_IDE_ATAPI=y
CONFIG_BLK_DEV_IDE_SATA=y
CONFIG_IDE_GD=y
CONFIG_IDE_GD_ATA=y
# CONFIG_IDE_GD_ATAPI is not set
CONFIG_BLK_DEV_IDECD=y
CONFIG_BLK_DEV_IDECD_VERBOSE_ERRORS=y
# CONFIG_BLK_DEV_IDETAPE is not set
# CONFIG_BLK_DEV_IDEACPI is not set
CONFIG_IDE_TASK_IOCTL=y
CONFIG_IDE_PROC_FS=y

#
# IDE chipset support/bugfixes
#
CONFIG_IDE_GENERIC=y
CONFIG_BLK_DEV_PLATFORM=y
# CONFIG_BLK_DEV_CMD640 is not set
# CONFIG_BLK_DEV_IDEPNP is not set
CONFIG_BLK_DEV_IDEDMA_SFF=y

#
# PCI IDE chipsets support
#
CONFIG_BLK_DEV_IDEPCI=y
# CONFIG_IDEPCI_PCIBUS_ORDER is not set
# CONFIG_BLK_DEV_OFFBOARD is not set
# CONFIG_BLK_DEV_GENERIC is not set
# CONFIG_BLK_DEV_OPTI621 is not set
CONFIG_BLK_DEV_RZ1000=y
CONFIG_BLK_DEV_IDEDMA_PCI=y
# CONFIG_BLK_DEV_AEC62XX is not set
CONFIG_BLK_DEV_ALI15X3=y
CONFIG_BLK_DEV_AMD74XX=y
# CONFIG_BLK_DEV_ATIIXP is not set
CONFIG_BLK_DEV_CMD64X=y
# CONFIG_BLK_DEV_TRIFLEX is not set
CONFIG_BLK_DEV_CS5520=y
CONFIG_BLK_DEV_CS5530=y
# CONFIG_BLK_DEV_HPT366 is not set
CONFIG_BLK_DEV_JMICRON=y
# CONFIG_BLK_DEV_SC1200 is not set
CONFIG_BLK_DEV_PIIX=y
# CONFIG_BLK_DEV_IT8172 is not set
# CONFIG_BLK_DEV_IT8213 is not set
CONFIG_BLK_DEV_IT821X=y
CONFIG_BLK_DEV_NS87415=y
# CONFIG_BLK_DEV_PDC202XX_OLD is not set
CONFIG_BLK_DEV_PDC202XX_NEW=y
# CONFIG_BLK_DEV_SVWKS is not set
CONFIG_BLK_DEV_SIIMAGE=y
CONFIG_BLK_DEV_SIS5513=y
CONFIG_BLK_DEV_SLC90E66=y
CONFIG_BLK_DEV_TRM290=y
CONFIG_BLK_DEV_VIA82CXXX=y
CONFIG_BLK_DEV_TC86C001=y
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
CONFIG_CHR_DEV_ST=y
CONFIG_CHR_DEV_OSST=y
CONFIG_BLK_DEV_SR=y
# CONFIG_BLK_DEV_SR_VENDOR is not set
CONFIG_CHR_DEV_SG=y
CONFIG_CHR_DEV_SCH=y
CONFIG_SCSI_ENCLOSURE=y
# CONFIG_SCSI_MULTI_LUN is not set
CONFIG_SCSI_CONSTANTS=y
# CONFIG_SCSI_LOGGING is not set
# CONFIG_SCSI_SCAN_ASYNC is not set

#
# SCSI Transports
#
CONFIG_SCSI_SPI_ATTRS=y
CONFIG_SCSI_FC_ATTRS=y
# CONFIG_SCSI_ISCSI_ATTRS is not set
CONFIG_SCSI_SAS_ATTRS=y
# CONFIG_SCSI_SAS_LIBSAS is not set
CONFIG_SCSI_SRP_ATTRS=y
# CONFIG_SCSI_LOWLEVEL is not set
# CONFIG_SCSI_DH is not set
# CONFIG_SCSI_OSD_INITIATOR is not set
CONFIG_ATA=y
# CONFIG_ATA_NONSTANDARD is not set
# CONFIG_ATA_VERBOSE_ERROR is not set
CONFIG_ATA_ACPI=y
# CONFIG_SATA_ZPODD is not set
CONFIG_SATA_PMP=y

#
# Controllers with non-SFF native interface
#
CONFIG_SATA_AHCI=y
CONFIG_SATA_AHCI_PLATFORM=y
CONFIG_AHCI_IMX=y
CONFIG_AHCI_XGENE=y
# CONFIG_SATA_INIC162X is not set
# CONFIG_SATA_ACARD_AHCI is not set
# CONFIG_SATA_SIL24 is not set
CONFIG_ATA_SFF=y

#
# SFF controllers with custom DMA interface
#
CONFIG_PDC_ADMA=y
CONFIG_SATA_QSTOR=y
CONFIG_SATA_SX4=y
# CONFIG_ATA_BMDMA is not set

#
# PIO-only SFF controllers
#
# CONFIG_PATA_CMD640_PCI is not set
CONFIG_PATA_MPIIX=y
# CONFIG_PATA_NS87410 is not set
CONFIG_PATA_OPTI=y
CONFIG_PATA_PLATFORM=y
# CONFIG_PATA_RZ1000 is not set

#
# Generic fallback / legacy drivers
#
CONFIG_PATA_LEGACY=y
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
CONFIG_BLK_DEV_DM_BUILTIN=y
CONFIG_BLK_DEV_DM=y
CONFIG_DM_DEBUG=y
CONFIG_DM_BUFIO=y
CONFIG_DM_BIO_PRISON=y
CONFIG_DM_PERSISTENT_DATA=y
CONFIG_DM_DEBUG_BLOCK_STACK_TRACING=y
CONFIG_DM_CRYPT=y
CONFIG_DM_SNAPSHOT=y
CONFIG_DM_THIN_PROVISIONING=y
CONFIG_DM_CACHE=y
CONFIG_DM_CACHE_MQ=y
CONFIG_DM_CACHE_CLEANER=y
# CONFIG_DM_ERA is not set
# CONFIG_DM_MIRROR is not set
CONFIG_DM_RAID=y
CONFIG_DM_ZERO=y
CONFIG_DM_MULTIPATH=y
CONFIG_DM_MULTIPATH_QL=y
# CONFIG_DM_MULTIPATH_ST is not set
# CONFIG_DM_DELAY is not set
# CONFIG_DM_UEVENT is not set
CONFIG_DM_FLAKEY=y
# CONFIG_DM_VERITY is not set
CONFIG_DM_SWITCH=y
CONFIG_TARGET_CORE=y
CONFIG_TCM_IBLOCK=y
CONFIG_TCM_FILEIO=y
# CONFIG_TCM_PSCSI is not set
CONFIG_LOOPBACK_TARGET=y
CONFIG_ISCSI_TARGET=y
# CONFIG_SBP_TARGET is not set
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
CONFIG_FIREWIRE=y
CONFIG_FIREWIRE_OHCI=y
# CONFIG_FIREWIRE_SBP2 is not set
CONFIG_FIREWIRE_NOSY=y
CONFIG_I2O=y
CONFIG_I2O_LCT_NOTIFY_ON_CHANGES=y
# CONFIG_I2O_EXT_ADAPTEC is not set
# CONFIG_I2O_CONFIG is not set
CONFIG_I2O_BUS=y
# CONFIG_I2O_BLOCK is not set
CONFIG_I2O_SCSI=y
CONFIG_I2O_PROC=y
# CONFIG_MACINTOSH_DRIVERS is not set
# CONFIG_NETDEVICES is not set
CONFIG_VHOST_RING=y

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
CONFIG_INPUT_EVDEV=y
CONFIG_INPUT_EVBUG=y

#
# Input Device Drivers
#
CONFIG_INPUT_KEYBOARD=y
# CONFIG_KEYBOARD_ADP5588 is not set
# CONFIG_KEYBOARD_ADP5589 is not set
CONFIG_KEYBOARD_ATKBD=y
CONFIG_KEYBOARD_QT1070=y
# CONFIG_KEYBOARD_QT2160 is not set
# CONFIG_KEYBOARD_LKKBD is not set
CONFIG_KEYBOARD_TCA6416=y
CONFIG_KEYBOARD_TCA8418=y
CONFIG_KEYBOARD_LM8323=y
CONFIG_KEYBOARD_LM8333=y
CONFIG_KEYBOARD_MAX7359=y
CONFIG_KEYBOARD_MCS=y
CONFIG_KEYBOARD_MPR121=y
CONFIG_KEYBOARD_NEWTON=y
CONFIG_KEYBOARD_OPENCORES=y
# CONFIG_KEYBOARD_STOWAWAY is not set
CONFIG_KEYBOARD_SUNKBD=y
# CONFIG_KEYBOARD_SH_KEYSC is not set
# CONFIG_KEYBOARD_TC3589X is not set
CONFIG_KEYBOARD_TWL4030=y
CONFIG_KEYBOARD_XTKBD=y
CONFIG_INPUT_LEDS=y
CONFIG_INPUT_MOUSE=y
# CONFIG_MOUSE_PS2 is not set
CONFIG_MOUSE_SERIAL=y
CONFIG_MOUSE_APPLETOUCH=y
# CONFIG_MOUSE_BCM5974 is not set
CONFIG_MOUSE_CYAPA=y
CONFIG_MOUSE_VSXXXAA=y
CONFIG_MOUSE_SYNAPTICS_I2C=y
CONFIG_MOUSE_SYNAPTICS_USB=y
CONFIG_INPUT_JOYSTICK=y
CONFIG_JOYSTICK_ANALOG=y
CONFIG_JOYSTICK_A3D=y
# CONFIG_JOYSTICK_ADI is not set
CONFIG_JOYSTICK_COBRA=y
CONFIG_JOYSTICK_GF2K=y
CONFIG_JOYSTICK_GRIP=y
CONFIG_JOYSTICK_GRIP_MP=y
# CONFIG_JOYSTICK_GUILLEMOT is not set
CONFIG_JOYSTICK_INTERACT=y
# CONFIG_JOYSTICK_SIDEWINDER is not set
CONFIG_JOYSTICK_TMDC=y
CONFIG_JOYSTICK_IFORCE=y
CONFIG_JOYSTICK_IFORCE_USB=y
# CONFIG_JOYSTICK_IFORCE_232 is not set
CONFIG_JOYSTICK_WARRIOR=y
# CONFIG_JOYSTICK_MAGELLAN is not set
CONFIG_JOYSTICK_SPACEORB=y
# CONFIG_JOYSTICK_SPACEBALL is not set
# CONFIG_JOYSTICK_STINGER is not set
CONFIG_JOYSTICK_TWIDJOY=y
# CONFIG_JOYSTICK_ZHENHUA is not set
CONFIG_JOYSTICK_DB9=y
# CONFIG_JOYSTICK_GAMECON is not set
CONFIG_JOYSTICK_TURBOGRAFX=y
CONFIG_JOYSTICK_AS5011=y
CONFIG_JOYSTICK_JOYDUMP=y
CONFIG_JOYSTICK_XPAD=y
CONFIG_JOYSTICK_XPAD_FF=y
CONFIG_JOYSTICK_XPAD_LEDS=y
CONFIG_INPUT_TABLET=y
CONFIG_TABLET_USB_ACECAD=y
CONFIG_TABLET_USB_AIPTEK=y
CONFIG_TABLET_USB_GTCO=y
# CONFIG_TABLET_USB_HANWANG is not set
CONFIG_TABLET_USB_KBTAB=y
CONFIG_TABLET_USB_WACOM=y
# CONFIG_INPUT_TOUCHSCREEN is not set
# CONFIG_INPUT_MISC is not set

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
CONFIG_SERIO_PS2MULT=y
CONFIG_SERIO_ARC_PS2=y
CONFIG_GAMEPORT=y
CONFIG_GAMEPORT_NS558=y
# CONFIG_GAMEPORT_L4 is not set
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
CONFIG_MOXA_INTELLIO=y
# CONFIG_MOXA_SMARTIO is not set
# CONFIG_SYNCLINK is not set
CONFIG_SYNCLINKMP=y
CONFIG_SYNCLINK_GT=y
CONFIG_NOZOMI=y
CONFIG_ISI=y
CONFIG_N_HDLC=y
CONFIG_N_GSM=y
CONFIG_TRACE_ROUTER=y
CONFIG_TRACE_SINK=y
# CONFIG_DEVKMEM is not set

#
# Serial drivers
#
CONFIG_SERIAL_8250=y
# CONFIG_SERIAL_8250_DEPRECATED_OPTIONS is not set
CONFIG_SERIAL_8250_PNP=y
CONFIG_SERIAL_8250_CONSOLE=y
CONFIG_FIX_EARLYCON_MEM=y
# CONFIG_SERIAL_8250_PCI is not set
CONFIG_SERIAL_8250_NR_UARTS=4
CONFIG_SERIAL_8250_RUNTIME_UARTS=4
# CONFIG_SERIAL_8250_EXTENDED is not set
# CONFIG_SERIAL_8250_DW is not set

#
# Non-8250 serial port support
#
CONFIG_SERIAL_CLPS711X=y
# CONFIG_SERIAL_CLPS711X_CONSOLE is not set
CONFIG_SERIAL_MFD_HSU=y
# CONFIG_SERIAL_MFD_HSU_CONSOLE is not set
CONFIG_SERIAL_SH_SCI=y
CONFIG_SERIAL_SH_SCI_NR_UARTS=2
# CONFIG_SERIAL_SH_SCI_CONSOLE is not set
CONFIG_SERIAL_CORE=y
CONFIG_SERIAL_CORE_CONSOLE=y
CONFIG_SERIAL_JSM=y
CONFIG_SERIAL_SCCNXP=y
# CONFIG_SERIAL_SCCNXP_CONSOLE is not set
CONFIG_SERIAL_TIMBERDALE=y
# CONFIG_SERIAL_ALTERA_JTAGUART is not set
CONFIG_SERIAL_ALTERA_UART=y
CONFIG_SERIAL_ALTERA_UART_MAXPORTS=4
CONFIG_SERIAL_ALTERA_UART_BAUDRATE=115200
# CONFIG_SERIAL_ALTERA_UART_CONSOLE is not set
# CONFIG_SERIAL_PCH_UART is not set
# CONFIG_SERIAL_ARC is not set
# CONFIG_SERIAL_RP2 is not set
CONFIG_SERIAL_FSL_LPUART=y
CONFIG_SERIAL_FSL_LPUART_CONSOLE=y
CONFIG_SERIAL_ST_ASC=y
CONFIG_SERIAL_ST_ASC_CONSOLE=y
CONFIG_TTY_PRINTK=y
# CONFIG_PRINTER is not set
CONFIG_PPDEV=y
CONFIG_HVC_DRIVER=y
CONFIG_HVC_IRQ=y
CONFIG_HVC_XEN=y
CONFIG_HVC_XEN_FRONTEND=y
# CONFIG_VIRTIO_CONSOLE is not set
CONFIG_IPMI_HANDLER=y
# CONFIG_IPMI_PANIC_EVENT is not set
CONFIG_IPMI_DEVICE_INTERFACE=y
CONFIG_IPMI_SI=y
# CONFIG_IPMI_WATCHDOG is not set
# CONFIG_IPMI_POWEROFF is not set
CONFIG_HW_RANDOM=y
CONFIG_HW_RANDOM_TIMERIOMEM=y
# CONFIG_HW_RANDOM_INTEL is not set
CONFIG_HW_RANDOM_AMD=y
CONFIG_HW_RANDOM_VIA=y
CONFIG_HW_RANDOM_VIRTIO=y
CONFIG_HW_RANDOM_TPM=y
CONFIG_NVRAM=y
CONFIG_R3964=y
# CONFIG_APPLICOM is not set
CONFIG_MWAVE=y
# CONFIG_RAW_DRIVER is not set
# CONFIG_HPET is not set
# CONFIG_HANGCHECK_TIMER is not set
CONFIG_TCG_TPM=y
CONFIG_TCG_TIS=y
# CONFIG_TCG_TIS_I2C_ATMEL is not set
# CONFIG_TCG_TIS_I2C_INFINEON is not set
CONFIG_TCG_TIS_I2C_NUVOTON=y
CONFIG_TCG_NSC=y
# CONFIG_TCG_ATMEL is not set
# CONFIG_TCG_INFINEON is not set
CONFIG_TCG_XEN=y
# CONFIG_TELCLOCK is not set
CONFIG_DEVPORT=y
CONFIG_I2C=y
CONFIG_I2C_BOARDINFO=y
# CONFIG_I2C_COMPAT is not set
# CONFIG_I2C_CHARDEV is not set
CONFIG_I2C_MUX=y

#
# Multiplexer I2C Chip support
#
# CONFIG_I2C_MUX_PCA9541 is not set
CONFIG_I2C_MUX_PCA954x=y
# CONFIG_I2C_HELPER_AUTO is not set
# CONFIG_I2C_SMBUS is not set

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
CONFIG_I2C_ALI1563=y
# CONFIG_I2C_ALI15X3 is not set
CONFIG_I2C_AMD756=y
CONFIG_I2C_AMD756_S4882=y
CONFIG_I2C_AMD8111=y
CONFIG_I2C_I801=y
CONFIG_I2C_ISCH=y
CONFIG_I2C_ISMT=y
# CONFIG_I2C_PIIX4 is not set
CONFIG_I2C_NFORCE2=y
CONFIG_I2C_NFORCE2_S4985=y
# CONFIG_I2C_SIS5595 is not set
CONFIG_I2C_SIS630=y
CONFIG_I2C_SIS96X=y
CONFIG_I2C_VIA=y
CONFIG_I2C_VIAPRO=y

#
# ACPI drivers
#
# CONFIG_I2C_SCMI is not set

#
# I2C system bus drivers (mostly embedded / system-on-chip)
#
CONFIG_I2C_DESIGNWARE_CORE=y
CONFIG_I2C_DESIGNWARE_PLATFORM=y
# CONFIG_I2C_DESIGNWARE_PCI is not set
CONFIG_I2C_EG20T=y
CONFIG_I2C_KEMPLD=y
CONFIG_I2C_OCORES=y
CONFIG_I2C_PCA_PLATFORM=y
# CONFIG_I2C_PXA_PCI is not set
CONFIG_I2C_RIIC=y
CONFIG_I2C_SH_MOBILE=y
# CONFIG_I2C_SIMTEC is not set
# CONFIG_I2C_XILINX is not set
CONFIG_I2C_RCAR=y

#
# External I2C/SMBus adapter drivers
#
# CONFIG_I2C_DIOLAN_U2C is not set
# CONFIG_I2C_PARPORT is not set
# CONFIG_I2C_PARPORT_LIGHT is not set
CONFIG_I2C_ROBOTFUZZ_OSIF=y
CONFIG_I2C_TAOS_EVM=y
CONFIG_I2C_TINY_USB=y
CONFIG_I2C_VIPERBOARD=y

#
# Other I2C/SMBus bus drivers
#
# CONFIG_I2C_DEBUG_CORE is not set
# CONFIG_I2C_DEBUG_ALGO is not set
# CONFIG_I2C_DEBUG_BUS is not set
# CONFIG_SPI is not set
# CONFIG_SPMI is not set
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
CONFIG_PPS_CLIENT_KTIMER=y
CONFIG_PPS_CLIENT_LDISC=y
# CONFIG_PPS_CLIENT_PARPORT is not set
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
# CONFIG_GPIOLIB is not set
CONFIG_W1=y
CONFIG_W1_CON=y

#
# 1-wire Bus Masters
#
CONFIG_W1_MASTER_MATROX=y
CONFIG_W1_MASTER_DS2490=y
CONFIG_W1_MASTER_DS2482=y
# CONFIG_W1_MASTER_MXC is not set
CONFIG_W1_MASTER_DS1WM=y

#
# 1-wire Slaves
#
# CONFIG_W1_SLAVE_THERM is not set
# CONFIG_W1_SLAVE_SMEM is not set
CONFIG_W1_SLAVE_DS2408=y
CONFIG_W1_SLAVE_DS2408_READBACK=y
# CONFIG_W1_SLAVE_DS2413 is not set
CONFIG_W1_SLAVE_DS2423=y
# CONFIG_W1_SLAVE_DS2431 is not set
CONFIG_W1_SLAVE_DS2433=y
CONFIG_W1_SLAVE_DS2433_CRC=y
# CONFIG_W1_SLAVE_DS2760 is not set
CONFIG_W1_SLAVE_DS2780=y
CONFIG_W1_SLAVE_DS2781=y
CONFIG_W1_SLAVE_DS28E04=y
CONFIG_W1_SLAVE_BQ27000=y
CONFIG_POWER_SUPPLY=y
# CONFIG_POWER_SUPPLY_DEBUG is not set
CONFIG_PDA_POWER=y
CONFIG_GENERIC_ADC_BATTERY=y
# CONFIG_WM831X_BACKUP is not set
CONFIG_WM831X_POWER=y
CONFIG_TEST_POWER=y
# CONFIG_BATTERY_88PM860X is not set
CONFIG_BATTERY_DS2780=y
CONFIG_BATTERY_DS2781=y
CONFIG_BATTERY_DS2782=y
# CONFIG_BATTERY_SBS is not set
# CONFIG_BATTERY_BQ27x00 is not set
# CONFIG_BATTERY_DA9030 is not set
# CONFIG_BATTERY_DA9052 is not set
CONFIG_BATTERY_MAX17040=y
CONFIG_BATTERY_MAX17042=y
CONFIG_BATTERY_TWL4030_MADC=y
# CONFIG_CHARGER_PCF50633 is not set
# CONFIG_BATTERY_RX51 is not set
# CONFIG_CHARGER_ISP1704 is not set
# CONFIG_CHARGER_MAX8903 is not set
# CONFIG_CHARGER_TWL4030 is not set
CONFIG_CHARGER_LP8727=y
# CONFIG_CHARGER_LP8788 is not set
# CONFIG_CHARGER_MAX14577 is not set
CONFIG_CHARGER_MAX8997=y
# CONFIG_CHARGER_BQ2415X is not set
CONFIG_CHARGER_SMB347=y
CONFIG_CHARGER_TPS65090=y
CONFIG_BATTERY_GOLDFISH=y
# CONFIG_POWER_RESET is not set
CONFIG_POWER_AVS=y
CONFIG_HWMON=y
CONFIG_HWMON_VID=y
CONFIG_HWMON_DEBUG_CHIP=y

#
# Native drivers
#
# CONFIG_SENSORS_ABITUGURU is not set
# CONFIG_SENSORS_ABITUGURU3 is not set
# CONFIG_SENSORS_AD7414 is not set
# CONFIG_SENSORS_AD7418 is not set
CONFIG_SENSORS_ADM1021=y
CONFIG_SENSORS_ADM1025=y
# CONFIG_SENSORS_ADM1026 is not set
CONFIG_SENSORS_ADM1029=y
CONFIG_SENSORS_ADM1031=y
CONFIG_SENSORS_ADM9240=y
CONFIG_SENSORS_ADT7X10=y
CONFIG_SENSORS_ADT7410=y
# CONFIG_SENSORS_ADT7411 is not set
CONFIG_SENSORS_ADT7462=y
CONFIG_SENSORS_ADT7470=y
CONFIG_SENSORS_ADT7475=y
CONFIG_SENSORS_ASC7621=y
# CONFIG_SENSORS_K8TEMP is not set
CONFIG_SENSORS_K10TEMP=y
CONFIG_SENSORS_FAM15H_POWER=y
# CONFIG_SENSORS_APPLESMC is not set
CONFIG_SENSORS_ASB100=y
# CONFIG_SENSORS_ATXP1 is not set
CONFIG_SENSORS_DS620=y
CONFIG_SENSORS_DS1621=y
CONFIG_SENSORS_DA9052_ADC=y
# CONFIG_SENSORS_DA9055 is not set
# CONFIG_SENSORS_I5K_AMB is not set
CONFIG_SENSORS_F71805F=y
# CONFIG_SENSORS_F71882FG is not set
CONFIG_SENSORS_F75375S=y
CONFIG_SENSORS_MC13783_ADC=y
CONFIG_SENSORS_FSCHMD=y
CONFIG_SENSORS_GL518SM=y
CONFIG_SENSORS_GL520SM=y
CONFIG_SENSORS_G760A=y
CONFIG_SENSORS_G762=y
# CONFIG_SENSORS_HIH6130 is not set
# CONFIG_SENSORS_IBMAEM is not set
CONFIG_SENSORS_IBMPEX=y
CONFIG_SENSORS_IIO_HWMON=y
CONFIG_SENSORS_CORETEMP=y
CONFIG_SENSORS_IT87=y
CONFIG_SENSORS_JC42=y
CONFIG_SENSORS_LINEAGE=y
CONFIG_SENSORS_LTC2945=y
CONFIG_SENSORS_LTC4151=y
# CONFIG_SENSORS_LTC4215 is not set
CONFIG_SENSORS_LTC4222=y
# CONFIG_SENSORS_LTC4245 is not set
CONFIG_SENSORS_LTC4260=y
CONFIG_SENSORS_LTC4261=y
# CONFIG_SENSORS_MAX16065 is not set
CONFIG_SENSORS_MAX1619=y
# CONFIG_SENSORS_MAX1668 is not set
CONFIG_SENSORS_MAX197=y
CONFIG_SENSORS_MAX6639=y
# CONFIG_SENSORS_MAX6642 is not set
CONFIG_SENSORS_MAX6650=y
CONFIG_SENSORS_MAX6697=y
CONFIG_SENSORS_HTU21=y
CONFIG_SENSORS_MCP3021=y
CONFIG_SENSORS_LM63=y
CONFIG_SENSORS_LM73=y
# CONFIG_SENSORS_LM75 is not set
CONFIG_SENSORS_LM77=y
CONFIG_SENSORS_LM78=y
CONFIG_SENSORS_LM80=y
CONFIG_SENSORS_LM83=y
CONFIG_SENSORS_LM85=y
CONFIG_SENSORS_LM87=y
# CONFIG_SENSORS_LM90 is not set
# CONFIG_SENSORS_LM92 is not set
# CONFIG_SENSORS_LM93 is not set
CONFIG_SENSORS_LM95234=y
# CONFIG_SENSORS_LM95241 is not set
CONFIG_SENSORS_LM95245=y
CONFIG_SENSORS_PC87360=y
# CONFIG_SENSORS_PC87427 is not set
CONFIG_SENSORS_NCT6775=y
CONFIG_SENSORS_PCF8591=y
# CONFIG_PMBUS is not set
CONFIG_SENSORS_SHT21=y
CONFIG_SENSORS_SIS5595=y
# CONFIG_SENSORS_DME1737 is not set
CONFIG_SENSORS_EMC1403=y
# CONFIG_SENSORS_EMC2103 is not set
CONFIG_SENSORS_EMC6W201=y
CONFIG_SENSORS_SMSC47M1=y
CONFIG_SENSORS_SMSC47M192=y
# CONFIG_SENSORS_SMSC47B397 is not set
CONFIG_SENSORS_SCH56XX_COMMON=y
CONFIG_SENSORS_SCH5627=y
CONFIG_SENSORS_SCH5636=y
CONFIG_SENSORS_SMM665=y
CONFIG_SENSORS_ADC128D818=y
CONFIG_SENSORS_ADS1015=y
# CONFIG_SENSORS_ADS7828 is not set
CONFIG_SENSORS_AMC6821=y
CONFIG_SENSORS_INA209=y
# CONFIG_SENSORS_INA2XX is not set
# CONFIG_SENSORS_THMC50 is not set
# CONFIG_SENSORS_TMP102 is not set
CONFIG_SENSORS_TMP401=y
CONFIG_SENSORS_TMP421=y
CONFIG_SENSORS_TWL4030_MADC=y
CONFIG_SENSORS_VIA_CPUTEMP=y
# CONFIG_SENSORS_VIA686A is not set
CONFIG_SENSORS_VT1211=y
CONFIG_SENSORS_VT8231=y
CONFIG_SENSORS_W83781D=y
# CONFIG_SENSORS_W83791D is not set
CONFIG_SENSORS_W83792D=y
CONFIG_SENSORS_W83793=y
# CONFIG_SENSORS_W83795 is not set
# CONFIG_SENSORS_W83L785TS is not set
# CONFIG_SENSORS_W83L786NG is not set
# CONFIG_SENSORS_W83627HF is not set
CONFIG_SENSORS_W83627EHF=y
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
# CONFIG_RCAR_THERMAL is not set
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
# CONFIG_SOFT_WATCHDOG is not set
CONFIG_DA9052_WATCHDOG=y
CONFIG_DA9055_WATCHDOG=y
# CONFIG_WM831X_WATCHDOG is not set
CONFIG_XILINX_WATCHDOG=y
CONFIG_DW_WATCHDOG=y
# CONFIG_TWL4030_WATCHDOG is not set
CONFIG_RETU_WATCHDOG=y
# CONFIG_TEGRA_WATCHDOG is not set
CONFIG_ACQUIRE_WDT=y
# CONFIG_ADVANTECH_WDT is not set
CONFIG_ALIM1535_WDT=y
CONFIG_ALIM7101_WDT=y
# CONFIG_F71808E_WDT is not set
# CONFIG_SP5100_TCO is not set
# CONFIG_SBC_FITPC2_WATCHDOG is not set
# CONFIG_EUROTECH_WDT is not set
# CONFIG_IB700_WDT is not set
# CONFIG_IBMASR is not set
CONFIG_WAFER_WDT=y
CONFIG_I6300ESB_WDT=y
CONFIG_IE6XX_WDT=y
CONFIG_ITCO_WDT=y
# CONFIG_ITCO_VENDOR_SUPPORT is not set
CONFIG_IT8712F_WDT=y
CONFIG_IT87_WDT=y
CONFIG_HP_WATCHDOG=y
# CONFIG_KEMPLD_WDT is not set
CONFIG_HPWDT_NMI_DECODING=y
CONFIG_SC1200_WDT=y
# CONFIG_PC87413_WDT is not set
# CONFIG_NV_TCO is not set
# CONFIG_60XX_WDT is not set
# CONFIG_SBC8360_WDT is not set
# CONFIG_CPU5_WDT is not set
CONFIG_SMSC_SCH311X_WDT=y
# CONFIG_SMSC37B787_WDT is not set
CONFIG_VIA_WDT=y
CONFIG_W83627HF_WDT=y
CONFIG_W83697HF_WDT=y
# CONFIG_W83697UG_WDT is not set
CONFIG_W83877F_WDT=y
CONFIG_W83977F_WDT=y
CONFIG_MACHZ_WDT=y
# CONFIG_SBC_EPX_C3_WATCHDOG is not set
CONFIG_XEN_WDT=y

#
# PCI-based Watchdog Cards
#
CONFIG_PCIPCWATCHDOG=y
CONFIG_WDTPCI=y

#
# USB-based Watchdog Cards
#
CONFIG_USBPCWATCHDOG=y
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
# CONFIG_BCMA_HOST_PCI is not set
# CONFIG_BCMA_HOST_SOC is not set
CONFIG_BCMA_DRIVER_GMAC_CMN=y
# CONFIG_BCMA_DEBUG is not set

#
# Multifunction device drivers
#
CONFIG_MFD_CORE=y
# CONFIG_MFD_CS5535 is not set
# CONFIG_MFD_AS3711 is not set
# CONFIG_PMIC_ADP5520 is not set
# CONFIG_MFD_BCM590XX is not set
# CONFIG_MFD_CROS_EC is not set
CONFIG_PMIC_DA903X=y
CONFIG_PMIC_DA9052=y
CONFIG_MFD_DA9052_I2C=y
CONFIG_MFD_DA9055=y
CONFIG_MFD_DA9063=y
CONFIG_MFD_MC13XXX=y
CONFIG_MFD_MC13XXX_I2C=y
# CONFIG_HTC_PASIC3 is not set
CONFIG_LPC_ICH=y
CONFIG_LPC_SCH=y
CONFIG_MFD_JANZ_CMODIO=y
CONFIG_MFD_KEMPLD=y
CONFIG_MFD_88PM800=y
# CONFIG_MFD_88PM805 is not set
CONFIG_MFD_88PM860X=y
CONFIG_MFD_MAX14577=y
CONFIG_MFD_MAX77686=y
# CONFIG_MFD_MAX77693 is not set
CONFIG_MFD_MAX8907=y
# CONFIG_MFD_MAX8925 is not set
CONFIG_MFD_MAX8997=y
# CONFIG_MFD_MAX8998 is not set
CONFIG_MFD_VIPERBOARD=y
CONFIG_MFD_RETU=y
CONFIG_MFD_PCF50633=y
CONFIG_PCF50633_ADC=y
CONFIG_PCF50633_GPIO=y
CONFIG_MFD_RDC321X=y
CONFIG_MFD_RTSX_PCI=y
CONFIG_MFD_RTSX_USB=y
# CONFIG_MFD_RC5T583 is not set
# CONFIG_MFD_SEC_CORE is not set
CONFIG_MFD_SI476X_CORE=y
CONFIG_MFD_SM501=y
CONFIG_MFD_SMSC=y
CONFIG_ABX500_CORE=y
CONFIG_AB3100_CORE=y
CONFIG_AB3100_OTP=y
# CONFIG_MFD_STMPE is not set
CONFIG_MFD_SYSCON=y
CONFIG_MFD_TI_AM335X_TSCADC=y
CONFIG_MFD_LP3943=y
CONFIG_MFD_LP8788=y
# CONFIG_MFD_PALMAS is not set
CONFIG_TPS6105X=y
CONFIG_TPS6507X=y
CONFIG_MFD_TPS65090=y
# CONFIG_MFD_TPS65217 is not set
CONFIG_MFD_TPS65218=y
CONFIG_MFD_TPS6586X=y
CONFIG_MFD_TPS80031=y
CONFIG_TWL4030_CORE=y
CONFIG_MFD_TWL4030_AUDIO=y
CONFIG_TWL6040_CORE=y
CONFIG_MFD_WL1273_CORE=y
CONFIG_MFD_LM3533=y
CONFIG_MFD_TC3589X=y
# CONFIG_MFD_TMIO is not set
CONFIG_MFD_VX855=y
# CONFIG_MFD_ARIZONA_I2C is not set
CONFIG_MFD_WM8400=y
CONFIG_MFD_WM831X=y
CONFIG_MFD_WM831X_I2C=y
# CONFIG_MFD_WM8350_I2C is not set
# CONFIG_MFD_WM8994 is not set
CONFIG_REGULATOR=y
CONFIG_REGULATOR_DEBUG=y
CONFIG_REGULATOR_FIXED_VOLTAGE=y
CONFIG_REGULATOR_VIRTUAL_CONSUMER=y
CONFIG_REGULATOR_USERSPACE_CONSUMER=y
# CONFIG_REGULATOR_88PM800 is not set
# CONFIG_REGULATOR_88PM8607 is not set
CONFIG_REGULATOR_ACT8865=y
CONFIG_REGULATOR_AD5398=y
# CONFIG_REGULATOR_ANATOP is not set
CONFIG_REGULATOR_AB3100=y
# CONFIG_REGULATOR_DA903X is not set
# CONFIG_REGULATOR_DA9052 is not set
CONFIG_REGULATOR_DA9055=y
CONFIG_REGULATOR_DA9063=y
CONFIG_REGULATOR_DA9210=y
CONFIG_REGULATOR_FAN53555=y
CONFIG_REGULATOR_ISL6271A=y
CONFIG_REGULATOR_LP3971=y
# CONFIG_REGULATOR_LP3972 is not set
CONFIG_REGULATOR_LP872X=y
# CONFIG_REGULATOR_LP8755 is not set
CONFIG_REGULATOR_LP8788=y
# CONFIG_REGULATOR_MAX14577 is not set
# CONFIG_REGULATOR_MAX1586 is not set
CONFIG_REGULATOR_MAX8649=y
CONFIG_REGULATOR_MAX8660=y
# CONFIG_REGULATOR_MAX8907 is not set
CONFIG_REGULATOR_MAX8952=y
# CONFIG_REGULATOR_MAX8973 is not set
CONFIG_REGULATOR_MAX8997=y
CONFIG_REGULATOR_MAX77686=y
CONFIG_REGULATOR_MC13XXX_CORE=y
CONFIG_REGULATOR_MC13783=y
CONFIG_REGULATOR_MC13892=y
CONFIG_REGULATOR_PBIAS=y
CONFIG_REGULATOR_PCF50633=y
CONFIG_REGULATOR_PFUZE100=y
CONFIG_REGULATOR_TPS51632=y
# CONFIG_REGULATOR_TPS6105X is not set
CONFIG_REGULATOR_TPS62360=y
# CONFIG_REGULATOR_TPS65023 is not set
# CONFIG_REGULATOR_TPS6507X is not set
# CONFIG_REGULATOR_TPS65090 is not set
CONFIG_REGULATOR_TPS6586X=y
CONFIG_REGULATOR_TPS80031=y
CONFIG_REGULATOR_TWL4030=y
CONFIG_REGULATOR_WM831X=y
CONFIG_REGULATOR_WM8400=y
CONFIG_MEDIA_SUPPORT=y

#
# Multimedia core support
#
CONFIG_MEDIA_CAMERA_SUPPORT=y
CONFIG_MEDIA_ANALOG_TV_SUPPORT=y
# CONFIG_MEDIA_DIGITAL_TV_SUPPORT is not set
CONFIG_MEDIA_RADIO_SUPPORT=y
# CONFIG_MEDIA_RC_SUPPORT is not set
# CONFIG_MEDIA_CONTROLLER is not set
CONFIG_VIDEO_DEV=y
CONFIG_VIDEO_V4L2=y
CONFIG_VIDEO_ADV_DEBUG=y
# CONFIG_VIDEO_FIXED_MINOR_RANGES is not set
CONFIG_VIDEO_TUNER=y
CONFIG_V4L2_MEM2MEM_DEV=y
CONFIG_VIDEOBUF_GEN=y
CONFIG_VIDEOBUF_DMA_CONTIG=y
CONFIG_VIDEOBUF2_CORE=y
CONFIG_VIDEOBUF2_MEMOPS=y
CONFIG_VIDEOBUF2_DMA_CONTIG=y
CONFIG_VIDEOBUF2_VMALLOC=y
CONFIG_VIDEOBUF2_DMA_SG=y
# CONFIG_TTPCI_EEPROM is not set

#
# Media drivers
#
# CONFIG_MEDIA_USB_SUPPORT is not set
# CONFIG_MEDIA_PCI_SUPPORT is not set
CONFIG_V4L_PLATFORM_DRIVERS=y
# CONFIG_VIDEO_CAFE_CCIC is not set
CONFIG_VIDEO_SH_VOU=y
# CONFIG_SOC_CAMERA is not set
CONFIG_V4L_MEM2MEM_DRIVERS=y
CONFIG_VIDEO_SH_VEU=y
# CONFIG_V4L_TEST_DRIVERS is not set

#
# Supported MMC/SDIO adapters
#
CONFIG_MEDIA_PARPORT_SUPPORT=y
CONFIG_VIDEO_BWQCAM=y
CONFIG_VIDEO_CQCAM=y
CONFIG_RADIO_ADAPTERS=y
CONFIG_RADIO_TEA575X=y
# CONFIG_RADIO_SI470X is not set
CONFIG_RADIO_SI4713=y
# CONFIG_USB_SI4713 is not set
# CONFIG_PLATFORM_SI4713 is not set
CONFIG_I2C_SI4713=y
# CONFIG_USB_MR800 is not set
CONFIG_USB_DSBR=y
CONFIG_RADIO_MAXIRADIO=y
CONFIG_RADIO_SHARK=y
CONFIG_RADIO_SHARK2=y
CONFIG_USB_KEENE=y
CONFIG_USB_RAREMONO=y
CONFIG_USB_MA901=y
CONFIG_RADIO_TEA5764=y
CONFIG_RADIO_TEA5764_XTAL=y
# CONFIG_RADIO_SAA7706H is not set
CONFIG_RADIO_TEF6862=y
CONFIG_RADIO_WL1273=y

#
# Texas Instruments WL128x FM driver (ST based)
#
CONFIG_CYPRESS_FIRMWARE=y

#
# Media ancillary drivers (tuners, sensors, i2c, frontends)
#
CONFIG_MEDIA_SUBDRV_AUTOSELECT=y

#
# Audio decoders, processors and mixers
#
CONFIG_VIDEO_UDA1342=y
CONFIG_VIDEO_SONY_BTF_MPX=y

#
# RDS decoders
#

#
# Video decoders
#
CONFIG_VIDEO_SAA711X=y
CONFIG_VIDEO_TW2804=y
CONFIG_VIDEO_TW9903=y
CONFIG_VIDEO_TW9906=y

#
# Video and audio decoders
#

#
# Video encoders
#

#
# Camera sensor devices
#
CONFIG_VIDEO_OV7640=y

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
CONFIG_AGP_AMD64=y
# CONFIG_AGP_INTEL is not set
CONFIG_AGP_SIS=y
CONFIG_AGP_VIA=y
CONFIG_VGA_ARB=y
CONFIG_VGA_ARB_MAX_GPUS=16
# CONFIG_VGA_SWITCHEROO is not set

#
# Direct Rendering Manager
#
# CONFIG_DRM is not set

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
CONFIG_FB_FOREIGN_ENDIAN=y
CONFIG_FB_BOTH_ENDIAN=y
# CONFIG_FB_BIG_ENDIAN is not set
# CONFIG_FB_LITTLE_ENDIAN is not set
CONFIG_FB_SYS_FOPS=y
CONFIG_FB_DEFERRED_IO=y
CONFIG_FB_HECUBA=y
# CONFIG_FB_SVGALIB is not set
# CONFIG_FB_MACMODES is not set
CONFIG_FB_BACKLIGHT=y
CONFIG_FB_MODE_HELPERS=y
# CONFIG_FB_TILEBLITTING is not set

#
# Frame buffer hardware drivers
#
# CONFIG_FB_CIRRUS is not set
CONFIG_FB_PM2=y
CONFIG_FB_PM2_FIFO_DISCONNECT=y
CONFIG_FB_CYBER2000=y
# CONFIG_FB_CYBER2000_DDC is not set
CONFIG_FB_ARC=y
# CONFIG_FB_ASILIANT is not set
CONFIG_FB_IMSTT=y
# CONFIG_FB_VGA16 is not set
CONFIG_FB_UVESA=y
CONFIG_FB_VESA=y
CONFIG_FB_N411=y
CONFIG_FB_HGA=y
CONFIG_FB_OPENCORES=y
# CONFIG_FB_S1D13XXX is not set
CONFIG_FB_NVIDIA=y
# CONFIG_FB_NVIDIA_I2C is not set
# CONFIG_FB_NVIDIA_DEBUG is not set
CONFIG_FB_NVIDIA_BACKLIGHT=y
CONFIG_FB_RIVA=y
# CONFIG_FB_RIVA_I2C is not set
# CONFIG_FB_RIVA_DEBUG is not set
CONFIG_FB_RIVA_BACKLIGHT=y
CONFIG_FB_I740=y
CONFIG_FB_LE80578=y
CONFIG_FB_CARILLO_RANCH=y
# CONFIG_FB_MATROX is not set
# CONFIG_FB_RADEON is not set
CONFIG_FB_ATY128=y
CONFIG_FB_ATY128_BACKLIGHT=y
CONFIG_FB_ATY=y
# CONFIG_FB_ATY_CT is not set
CONFIG_FB_ATY_GX=y
# CONFIG_FB_ATY_BACKLIGHT is not set
# CONFIG_FB_S3 is not set
CONFIG_FB_SAVAGE=y
# CONFIG_FB_SAVAGE_I2C is not set
CONFIG_FB_SAVAGE_ACCEL=y
# CONFIG_FB_SIS is not set
# CONFIG_FB_VIA is not set
CONFIG_FB_NEOMAGIC=y
CONFIG_FB_KYRO=y
# CONFIG_FB_3DFX is not set
CONFIG_FB_VOODOO1=y
# CONFIG_FB_VT8623 is not set
# CONFIG_FB_TRIDENT is not set
# CONFIG_FB_ARK is not set
CONFIG_FB_PM3=y
CONFIG_FB_CARMINE=y
CONFIG_FB_CARMINE_DRAM_EVAL=y
# CONFIG_CARMINE_DRAM_CUSTOM is not set
# CONFIG_FB_GEODE is not set
CONFIG_FB_TMIO=y
# CONFIG_FB_TMIO_ACCELL is not set
CONFIG_FB_SM501=y
# CONFIG_FB_SMSCUFX is not set
CONFIG_FB_UDL=y
CONFIG_FB_GOLDFISH=y
CONFIG_FB_VIRTUAL=y
# CONFIG_XEN_FBDEV_FRONTEND is not set
CONFIG_FB_METRONOME=y
CONFIG_FB_MB862XX=y
CONFIG_FB_MB862XX_PCI_GDC=y
# CONFIG_FB_MB862XX_I2C is not set
CONFIG_FB_BROADSHEET=y
# CONFIG_FB_AUO_K190X is not set
CONFIG_FB_SIMPLE=y
CONFIG_EXYNOS_VIDEO=y
CONFIG_BACKLIGHT_LCD_SUPPORT=y
# CONFIG_LCD_CLASS_DEVICE is not set
CONFIG_BACKLIGHT_CLASS_DEVICE=y
CONFIG_BACKLIGHT_GENERIC=y
CONFIG_BACKLIGHT_LM3533=y
CONFIG_BACKLIGHT_PWM=y
CONFIG_BACKLIGHT_DA903X=y
CONFIG_BACKLIGHT_DA9052=y
# CONFIG_BACKLIGHT_APPLE is not set
CONFIG_BACKLIGHT_SAHARA=y
CONFIG_BACKLIGHT_WM831X=y
CONFIG_BACKLIGHT_ADP8860=y
# CONFIG_BACKLIGHT_ADP8870 is not set
CONFIG_BACKLIGHT_88PM860X=y
# CONFIG_BACKLIGHT_PCF50633 is not set
CONFIG_BACKLIGHT_LM3630A=y
CONFIG_BACKLIGHT_LM3639=y
CONFIG_BACKLIGHT_LP855X=y
CONFIG_BACKLIGHT_LP8788=y
# CONFIG_BACKLIGHT_PANDORA is not set
CONFIG_BACKLIGHT_LV5207LP=y
CONFIG_BACKLIGHT_BD6107=y
CONFIG_VGASTATE=y
# CONFIG_LOGO is not set
CONFIG_SOUND=y
CONFIG_SOUND_OSS_CORE=y
# CONFIG_SOUND_OSS_CORE_PRECLAIM is not set
CONFIG_SND=y
CONFIG_SND_TIMER=y
CONFIG_SND_PCM=y
CONFIG_SND_HWDEP=y
CONFIG_SND_RAWMIDI=y
CONFIG_SND_JACK=y
# CONFIG_SND_SEQUENCER is not set
# CONFIG_SND_MIXER_OSS is not set
# CONFIG_SND_PCM_OSS is not set
CONFIG_SND_DYNAMIC_MINORS=y
CONFIG_SND_MAX_CARDS=32
# CONFIG_SND_SUPPORT_OLD_API is not set
CONFIG_SND_VERBOSE_PROCFS=y
# CONFIG_SND_VERBOSE_PRINTK is not set
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
CONFIG_SND_MPU401_UART=y
CONFIG_SND_OPL3_LIB=y
CONFIG_SND_VX_LIB=y
CONFIG_SND_AC97_CODEC=y
# CONFIG_SND_DRIVERS is not set
CONFIG_SND_SB_COMMON=y
CONFIG_SND_SB16_DSP=y
CONFIG_SND_PCI=y
# CONFIG_SND_AD1889 is not set
CONFIG_SND_ALS300=y
# CONFIG_SND_ALS4000 is not set
CONFIG_SND_ALI5451=y
CONFIG_SND_ASIHPI=y
# CONFIG_SND_ATIIXP is not set
CONFIG_SND_ATIIXP_MODEM=y
# CONFIG_SND_AU8810 is not set
CONFIG_SND_AU8820=y
CONFIG_SND_AU8830=y
CONFIG_SND_AW2=y
CONFIG_SND_AZT3328=y
CONFIG_SND_BT87X=y
CONFIG_SND_BT87X_OVERCLOCK=y
CONFIG_SND_CA0106=y
# CONFIG_SND_CMIPCI is not set
CONFIG_SND_OXYGEN_LIB=y
# CONFIG_SND_OXYGEN is not set
CONFIG_SND_CS4281=y
CONFIG_SND_CS46XX=y
# CONFIG_SND_CS46XX_NEW_DSP is not set
CONFIG_SND_CS5530=y
# CONFIG_SND_CS5535AUDIO is not set
CONFIG_SND_CTXFI=y
# CONFIG_SND_DARLA20 is not set
CONFIG_SND_GINA20=y
CONFIG_SND_LAYLA20=y
CONFIG_SND_DARLA24=y
CONFIG_SND_GINA24=y
CONFIG_SND_LAYLA24=y
# CONFIG_SND_MONA is not set
CONFIG_SND_MIA=y
CONFIG_SND_ECHO3G=y
# CONFIG_SND_INDIGO is not set
CONFIG_SND_INDIGOIO=y
CONFIG_SND_INDIGODJ=y
# CONFIG_SND_INDIGOIOX is not set
# CONFIG_SND_INDIGODJX is not set
CONFIG_SND_EMU10K1=y
CONFIG_SND_EMU10K1X=y
# CONFIG_SND_ENS1370 is not set
CONFIG_SND_ENS1371=y
CONFIG_SND_ES1938=y
# CONFIG_SND_ES1968 is not set
CONFIG_SND_FM801=y
CONFIG_SND_FM801_TEA575X_BOOL=y
CONFIG_SND_HDSP=y

#
# Don't forget to add built-in firmwares for HDSP driver
#
CONFIG_SND_HDSPM=y
CONFIG_SND_ICE1712=y
CONFIG_SND_ICE1724=y
CONFIG_SND_INTEL8X0=y
CONFIG_SND_INTEL8X0M=y
CONFIG_SND_KORG1212=y
CONFIG_SND_LOLA=y
# CONFIG_SND_LX6464ES is not set
CONFIG_SND_MAESTRO3=y
# CONFIG_SND_MAESTRO3_INPUT is not set
# CONFIG_SND_MIXART is not set
CONFIG_SND_NM256=y
CONFIG_SND_PCXHR=y
# CONFIG_SND_RIPTIDE is not set
# CONFIG_SND_RME32 is not set
CONFIG_SND_RME96=y
# CONFIG_SND_RME9652 is not set
CONFIG_SND_SONICVIBES=y
# CONFIG_SND_TRIDENT is not set
CONFIG_SND_VIA82XX=y
# CONFIG_SND_VIA82XX_MODEM is not set
CONFIG_SND_VIRTUOSO=y
CONFIG_SND_VX222=y
CONFIG_SND_YMFPCI=y

#
# HD-Audio
#
CONFIG_SND_HDA=y
CONFIG_SND_HDA_INTEL=y
CONFIG_SND_HDA_DSP_LOADER=y
CONFIG_SND_HDA_PREALLOC_SIZE=64
# CONFIG_SND_HDA_HWDEP is not set
# CONFIG_SND_HDA_RECONFIG is not set
# CONFIG_SND_HDA_INPUT_BEEP is not set
CONFIG_SND_HDA_INPUT_JACK=y
# CONFIG_SND_HDA_PATCH_LOADER is not set
# CONFIG_SND_HDA_CODEC_REALTEK is not set
# CONFIG_SND_HDA_CODEC_ANALOG is not set
# CONFIG_SND_HDA_CODEC_SIGMATEL is not set
CONFIG_SND_HDA_CODEC_VIA=y
CONFIG_SND_HDA_CODEC_HDMI=y
CONFIG_SND_HDA_CODEC_CIRRUS=y
CONFIG_SND_HDA_CODEC_CONEXANT=y
CONFIG_SND_HDA_CODEC_CA0110=y
CONFIG_SND_HDA_CODEC_CA0132=y
CONFIG_SND_HDA_CODEC_CA0132_DSP=y
# CONFIG_SND_HDA_CODEC_CMEDIA is not set
CONFIG_SND_HDA_CODEC_SI3054=y
CONFIG_SND_HDA_GENERIC=y
CONFIG_SND_HDA_POWER_SAVE_DEFAULT=0
CONFIG_SND_USB=y
# CONFIG_SND_USB_AUDIO is not set
CONFIG_SND_USB_UA101=y
CONFIG_SND_USB_USX2Y=y
CONFIG_SND_USB_CAIAQ=y
CONFIG_SND_USB_CAIAQ_INPUT=y
# CONFIG_SND_USB_US122L is not set
CONFIG_SND_USB_6FIRE=y
# CONFIG_SND_USB_HIFACE is not set
CONFIG_SND_FIREWIRE=y
CONFIG_SND_FIREWIRE_LIB=y
CONFIG_SND_DICE=y
CONFIG_SND_FIREWIRE_SPEAKERS=y
CONFIG_SND_ISIGHT=y
CONFIG_SND_SCS1X=y
# CONFIG_SND_SOC is not set
CONFIG_SOUND_PRIME=y
CONFIG_SOUND_OSS=y
# CONFIG_SOUND_TRACEINIT is not set
CONFIG_SOUND_DMAP=y
# CONFIG_SOUND_VMIDI is not set
CONFIG_SOUND_TRIX=y
CONFIG_SOUND_MSS=y
# CONFIG_SOUND_MPU401 is not set
CONFIG_SOUND_PAS=y
# CONFIG_PAS_JOYSTICK is not set
# CONFIG_SOUND_PSS is not set
# CONFIG_SOUND_SB is not set
CONFIG_SOUND_YM3812=y
# CONFIG_SOUND_UART6850 is not set
CONFIG_SOUND_AEDSP16=y
# CONFIG_SC6600 is not set
CONFIG_AC97_BUS=y

#
# HID support
#
CONFIG_HID=y
CONFIG_HID_BATTERY_STRENGTH=y
CONFIG_HIDRAW=y
# CONFIG_UHID is not set
CONFIG_HID_GENERIC=y

#
# Special HID drivers
#
CONFIG_HID_A4TECH=y
CONFIG_HID_ACRUX=y
CONFIG_HID_ACRUX_FF=y
CONFIG_HID_APPLE=y
CONFIG_HID_APPLEIR=y
CONFIG_HID_AUREAL=y
# CONFIG_HID_BELKIN is not set
# CONFIG_HID_CHERRY is not set
CONFIG_HID_CHICONY=y
CONFIG_HID_PRODIKEYS=y
# CONFIG_HID_CYPRESS is not set
CONFIG_HID_DRAGONRISE=y
CONFIG_DRAGONRISE_FF=y
CONFIG_HID_EMS_FF=y
# CONFIG_HID_ELECOM is not set
# CONFIG_HID_ELO is not set
# CONFIG_HID_EZKEY is not set
CONFIG_HID_HOLTEK=y
CONFIG_HOLTEK_FF=y
CONFIG_HID_HUION=y
# CONFIG_HID_KEYTOUCH is not set
CONFIG_HID_KYE=y
# CONFIG_HID_UCLOGIC is not set
CONFIG_HID_WALTOP=y
CONFIG_HID_GYRATION=y
# CONFIG_HID_ICADE is not set
# CONFIG_HID_TWINHAN is not set
CONFIG_HID_KENSINGTON=y
# CONFIG_HID_LCPOWER is not set
CONFIG_HID_LENOVO_TPKBD=y
# CONFIG_HID_LOGITECH is not set
# CONFIG_HID_MAGICMOUSE is not set
# CONFIG_HID_MICROSOFT is not set
# CONFIG_HID_MONTEREY is not set
# CONFIG_HID_MULTITOUCH is not set
CONFIG_HID_NTRIG=y
# CONFIG_HID_ORTEK is not set
# CONFIG_HID_PANTHERLORD is not set
# CONFIG_HID_PETALYNX is not set
CONFIG_HID_PICOLCD=y
# CONFIG_HID_PICOLCD_FB is not set
# CONFIG_HID_PICOLCD_BACKLIGHT is not set
CONFIG_HID_PICOLCD_LEDS=y
# CONFIG_HID_PRIMAX is not set
CONFIG_HID_ROCCAT=y
CONFIG_HID_SAITEK=y
CONFIG_HID_SAMSUNG=y
# CONFIG_HID_SONY is not set
CONFIG_HID_SPEEDLINK=y
# CONFIG_HID_STEELSERIES is not set
# CONFIG_HID_SUNPLUS is not set
CONFIG_HID_GREENASIA=y
CONFIG_GREENASIA_FF=y
CONFIG_HID_SMARTJOYPLUS=y
CONFIG_SMARTJOYPLUS_FF=y
# CONFIG_HID_TIVO is not set
# CONFIG_HID_TOPSEED is not set
CONFIG_HID_THINGM=y
# CONFIG_HID_THRUSTMASTER is not set
CONFIG_HID_WACOM=y
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
# CONFIG_HID_PID is not set
# CONFIG_USB_HIDDEV is not set

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
# CONFIG_USB_DEFAULT_PERSIST is not set
# CONFIG_USB_DYNAMIC_MINORS is not set
CONFIG_USB_OTG=y
CONFIG_USB_OTG_WHITELIST=y
# CONFIG_USB_OTG_BLACKLIST_HUB is not set
CONFIG_USB_MON=y
CONFIG_USB_WUSB=y
CONFIG_USB_WUSB_CBAF=y
CONFIG_USB_WUSB_CBAF_DEBUG=y

#
# USB Host Controller Drivers
#
CONFIG_USB_C67X00_HCD=y
CONFIG_USB_XHCI_HCD=y
CONFIG_USB_EHCI_HCD=y
CONFIG_USB_EHCI_ROOT_HUB_TT=y
# CONFIG_USB_EHCI_TT_NEWSCHED is not set
CONFIG_USB_EHCI_PCI=y
CONFIG_USB_EHCI_HCD_PLATFORM=y
# CONFIG_USB_OXU210HP_HCD is not set
CONFIG_USB_ISP116X_HCD=y
CONFIG_USB_ISP1760_HCD=y
CONFIG_USB_ISP1362_HCD=y
# CONFIG_USB_FUSBH200_HCD is not set
CONFIG_USB_FOTG210_HCD=y
# CONFIG_USB_OHCI_HCD is not set
CONFIG_USB_UHCI_HCD=y
CONFIG_USB_SL811_HCD=y
# CONFIG_USB_SL811_HCD_ISO is not set
CONFIG_USB_R8A66597_HCD=y
# CONFIG_USB_WHCI_HCD is not set
CONFIG_USB_HWA_HCD=y
CONFIG_USB_HCD_BCMA=y
CONFIG_USB_HCD_TEST_MODE=y

#
# USB Device Class drivers
#
CONFIG_USB_ACM=y
CONFIG_USB_PRINTER=y
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
CONFIG_USB_STORAGE_REALTEK=y
CONFIG_REALTEK_AUTOPM=y
# CONFIG_USB_STORAGE_DATAFAB is not set
CONFIG_USB_STORAGE_FREECOM=y
CONFIG_USB_STORAGE_ISD200=y
CONFIG_USB_STORAGE_USBAT=y
CONFIG_USB_STORAGE_SDDR09=y
CONFIG_USB_STORAGE_SDDR55=y
CONFIG_USB_STORAGE_JUMPSHOT=y
CONFIG_USB_STORAGE_ALAUDA=y
CONFIG_USB_STORAGE_ONETOUCH=y
CONFIG_USB_STORAGE_KARMA=y
# CONFIG_USB_STORAGE_CYPRESS_ATACB is not set
# CONFIG_USB_STORAGE_ENE_UB6250 is not set
CONFIG_USB_UAS=y

#
# USB Imaging devices
#
CONFIG_USB_MDC800=y
CONFIG_USB_MICROTEK=y
CONFIG_USB_MUSB_HDRC=y
CONFIG_USB_MUSB_HOST=y
CONFIG_USB_MUSB_TUSB6010=y
# CONFIG_USB_MUSB_UX500 is not set
CONFIG_MUSB_PIO_ONLY=y
# CONFIG_USB_DWC3 is not set
CONFIG_USB_DWC2=y
# CONFIG_USB_DWC2_DEBUG is not set
# CONFIG_USB_DWC2_TRACK_MISSED_SOFS is not set
CONFIG_USB_CHIPIDEA=y
# CONFIG_USB_CHIPIDEA_HOST is not set
CONFIG_USB_CHIPIDEA_DEBUG=y

#
# USB port drivers
#
CONFIG_USB_USS720=y
CONFIG_USB_SERIAL=y
CONFIG_USB_SERIAL_CONSOLE=y
# CONFIG_USB_SERIAL_GENERIC is not set
# CONFIG_USB_SERIAL_SIMPLE is not set
# CONFIG_USB_SERIAL_AIRCABLE is not set
# CONFIG_USB_SERIAL_ARK3116 is not set
CONFIG_USB_SERIAL_BELKIN=y
CONFIG_USB_SERIAL_CH341=y
CONFIG_USB_SERIAL_WHITEHEAT=y
# CONFIG_USB_SERIAL_DIGI_ACCELEPORT is not set
CONFIG_USB_SERIAL_CP210X=y
CONFIG_USB_SERIAL_CYPRESS_M8=y
# CONFIG_USB_SERIAL_EMPEG is not set
# CONFIG_USB_SERIAL_FTDI_SIO is not set
CONFIG_USB_SERIAL_VISOR=y
# CONFIG_USB_SERIAL_IPAQ is not set
# CONFIG_USB_SERIAL_IR is not set
CONFIG_USB_SERIAL_EDGEPORT=y
# CONFIG_USB_SERIAL_EDGEPORT_TI is not set
# CONFIG_USB_SERIAL_F81232 is not set
# CONFIG_USB_SERIAL_GARMIN is not set
CONFIG_USB_SERIAL_IPW=y
CONFIG_USB_SERIAL_IUU=y
CONFIG_USB_SERIAL_KEYSPAN_PDA=y
# CONFIG_USB_SERIAL_KEYSPAN is not set
# CONFIG_USB_SERIAL_KLSI is not set
CONFIG_USB_SERIAL_KOBIL_SCT=y
# CONFIG_USB_SERIAL_MCT_U232 is not set
CONFIG_USB_SERIAL_METRO=y
CONFIG_USB_SERIAL_MOS7720=y
CONFIG_USB_SERIAL_MOS7715_PARPORT=y
# CONFIG_USB_SERIAL_MOS7840 is not set
CONFIG_USB_SERIAL_MXUPORT=y
CONFIG_USB_SERIAL_NAVMAN=y
CONFIG_USB_SERIAL_PL2303=y
CONFIG_USB_SERIAL_OTI6858=y
CONFIG_USB_SERIAL_QCAUX=y
CONFIG_USB_SERIAL_QUALCOMM=y
# CONFIG_USB_SERIAL_SPCP8X5 is not set
CONFIG_USB_SERIAL_SAFE=y
CONFIG_USB_SERIAL_SAFE_PADDED=y
# CONFIG_USB_SERIAL_SIERRAWIRELESS is not set
# CONFIG_USB_SERIAL_SYMBOL is not set
CONFIG_USB_SERIAL_TI=y
CONFIG_USB_SERIAL_CYBERJACK=y
CONFIG_USB_SERIAL_XIRCOM=y
CONFIG_USB_SERIAL_WWAN=y
CONFIG_USB_SERIAL_OPTION=y
# CONFIG_USB_SERIAL_OMNINET is not set
CONFIG_USB_SERIAL_OPTICON=y
CONFIG_USB_SERIAL_XSENS_MT=y
# CONFIG_USB_SERIAL_WISHBONE is not set
CONFIG_USB_SERIAL_ZTE=y
# CONFIG_USB_SERIAL_SSU100 is not set
CONFIG_USB_SERIAL_QT2=y
CONFIG_USB_SERIAL_DEBUG=y

#
# USB Miscellaneous drivers
#
CONFIG_USB_EMI62=y
CONFIG_USB_EMI26=y
CONFIG_USB_ADUTUX=y
CONFIG_USB_SEVSEG=y
# CONFIG_USB_RIO500 is not set
CONFIG_USB_LEGOTOWER=y
CONFIG_USB_LCD=y
CONFIG_USB_LED=y
CONFIG_USB_CYPRESS_CY7C63=y
CONFIG_USB_CYTHERM=y
# CONFIG_USB_IDMOUSE is not set
# CONFIG_USB_FTDI_ELAN is not set
CONFIG_USB_APPLEDISPLAY=y
CONFIG_USB_SISUSBVGA=y
# CONFIG_USB_LD is not set
CONFIG_USB_TRANCEVIBRATOR=y
CONFIG_USB_IOWARRIOR=y
CONFIG_USB_TEST=y
CONFIG_USB_EHSET_TEST_FIXTURE=y
# CONFIG_USB_ISIGHTFW is not set
# CONFIG_USB_YUREX is not set
CONFIG_USB_EZUSB_FX2=y
CONFIG_USB_HSIC_USB3503=y
CONFIG_USB_ATM=y
CONFIG_USB_SPEEDTOUCH=y
CONFIG_USB_CXACRU=y
CONFIG_USB_UEAGLEATM=y
CONFIG_USB_XUSBATM=y

#
# USB Physical Layer drivers
#
CONFIG_USB_PHY=y
CONFIG_USB_OTG_FSM=y
# CONFIG_KEYSTONE_USB_PHY is not set
CONFIG_NOP_USB_XCEIV=y
CONFIG_AM335X_CONTROL_USB=y
CONFIG_AM335X_PHY_USB=y
CONFIG_SAMSUNG_USBPHY=y
# CONFIG_SAMSUNG_USB2PHY is not set
CONFIG_SAMSUNG_USB3PHY=y
CONFIG_TAHVO_USB=y
CONFIG_TAHVO_USB_HOST_BY_DEFAULT=y
CONFIG_USB_ISP1301=y
# CONFIG_USB_RCAR_PHY is not set
# CONFIG_USB_RCAR_GEN2_PHY is not set
# CONFIG_USB_GADGET is not set
CONFIG_UWB=y
CONFIG_UWB_HWA=y
# CONFIG_UWB_WHCI is not set
CONFIG_UWB_I1480U=y
CONFIG_MMC=y
CONFIG_MMC_DEBUG=y
CONFIG_MMC_CLKGATE=y

#
# MMC/SD/SDIO Card Drivers
#
CONFIG_MMC_BLOCK=y
CONFIG_MMC_BLOCK_MINORS=8
# CONFIG_MMC_BLOCK_BOUNCE is not set
# CONFIG_SDIO_UART is not set
# CONFIG_MMC_TEST is not set

#
# MMC/SD/SDIO Host Controller Drivers
#
CONFIG_MMC_SDHCI=y
# CONFIG_MMC_SDHCI_PCI is not set
# CONFIG_MMC_SDHCI_ACPI is not set
CONFIG_MMC_SDHCI_PLTFM=y
CONFIG_MMC_OMAP_HS=y
# CONFIG_MMC_WBSD is not set
CONFIG_MMC_TIFM_SD=y
# CONFIG_MMC_CB710 is not set
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
# CONFIG_MSPRO_BLOCK is not set
CONFIG_MS_BLOCK=y

#
# MemoryStick Host Controller Drivers
#
CONFIG_MEMSTICK_TIFM_MS=y
# CONFIG_MEMSTICK_JMICRON_38X is not set
# CONFIG_MEMSTICK_R592 is not set
CONFIG_MEMSTICK_REALTEK_PCI=y
CONFIG_NEW_LEDS=y
CONFIG_LEDS_CLASS=y

#
# LED drivers
#
CONFIG_LEDS_88PM860X=y
# CONFIG_LEDS_LM3530 is not set
CONFIG_LEDS_LM3533=y
CONFIG_LEDS_LM3642=y
CONFIG_LEDS_PCA9532=y
CONFIG_LEDS_LP3944=y
CONFIG_LEDS_LP55XX_COMMON=y
# CONFIG_LEDS_LP5521 is not set
CONFIG_LEDS_LP5523=y
CONFIG_LEDS_LP5562=y
# CONFIG_LEDS_LP8501 is not set
CONFIG_LEDS_LP8788=y
CONFIG_LEDS_CLEVO_MAIL=y
CONFIG_LEDS_PCA955X=y
CONFIG_LEDS_PCA963X=y
CONFIG_LEDS_PCA9685=y
CONFIG_LEDS_WM831X_STATUS=y
# CONFIG_LEDS_DA903X is not set
CONFIG_LEDS_DA9052=y
CONFIG_LEDS_PWM=y
# CONFIG_LEDS_REGULATOR is not set
CONFIG_LEDS_BD2802=y
# CONFIG_LEDS_INTEL_SS4200 is not set
CONFIG_LEDS_MC13783=y
# CONFIG_LEDS_TCA6507 is not set
CONFIG_LEDS_MAX8997=y
# CONFIG_LEDS_LM355x is not set
CONFIG_LEDS_OT200=y
CONFIG_LEDS_BLINKM=y

#
# LED Triggers
#
CONFIG_LEDS_TRIGGERS=y
CONFIG_LEDS_TRIGGER_TIMER=y
CONFIG_LEDS_TRIGGER_ONESHOT=y
# CONFIG_LEDS_TRIGGER_IDE_DISK is not set
# CONFIG_LEDS_TRIGGER_HEARTBEAT is not set
# CONFIG_LEDS_TRIGGER_BACKLIGHT is not set
# CONFIG_LEDS_TRIGGER_CPU is not set
CONFIG_LEDS_TRIGGER_DEFAULT_ON=y

#
# iptables trigger is under Netfilter config (LED target)
#
CONFIG_LEDS_TRIGGER_TRANSIENT=y
# CONFIG_LEDS_TRIGGER_CAMERA is not set
CONFIG_ACCESSIBILITY=y
# CONFIG_EDAC is not set
CONFIG_RTC_LIB=y
# CONFIG_RTC_CLASS is not set
# CONFIG_DMADEVICES is not set
# CONFIG_AUXDISPLAY is not set
CONFIG_UIO=y
CONFIG_UIO_CIF=y
CONFIG_UIO_PDRV_GENIRQ=y
CONFIG_UIO_DMEM_GENIRQ=y
CONFIG_UIO_AEC=y
CONFIG_UIO_SERCOS3=y
CONFIG_UIO_PCI_GENERIC=y
CONFIG_UIO_NETX=y
CONFIG_UIO_MF624=y
CONFIG_VIRT_DRIVERS=y
CONFIG_VIRTIO=y

#
# Virtio drivers
#
CONFIG_VIRTIO_PCI=y
# CONFIG_VIRTIO_BALLOON is not set
CONFIG_VIRTIO_MMIO=y
# CONFIG_VIRTIO_MMIO_CMDLINE_DEVICES is not set

#
# Microsoft Hyper-V guest support
#
# CONFIG_HYPERV is not set

#
# Xen driver support
#
# CONFIG_XEN_BALLOON is not set
# CONFIG_XEN_DEV_EVTCHN is not set
CONFIG_XEN_BACKEND=y
# CONFIG_XENFS is not set
# CONFIG_XEN_SYS_HYPERVISOR is not set
CONFIG_XEN_XENBUS_FRONTEND=y
CONFIG_XEN_GNTDEV=y
CONFIG_XEN_GRANT_DEV_ALLOC=y
CONFIG_SWIOTLB_XEN=y
CONFIG_XEN_PCIDEV_BACKEND=y
CONFIG_XEN_PRIVCMD=y
CONFIG_XEN_ACPI_PROCESSOR=y
# CONFIG_XEN_MCE_LOG is not set
CONFIG_XEN_HAVE_PVMMU=y
CONFIG_STAGING=y
# CONFIG_SLICOSS is not set
CONFIG_USBIP_CORE=y
CONFIG_USBIP_VHCI_HCD=y
CONFIG_USBIP_HOST=y
CONFIG_USBIP_DEBUG=y
CONFIG_PANEL=y
CONFIG_PANEL_PARPORT=0
CONFIG_PANEL_PROFILE=5
CONFIG_PANEL_CHANGE_MESSAGE=y
CONFIG_PANEL_BOOT_MESSAGE=""
CONFIG_RTS5139=y
CONFIG_RTS5139_DEBUG=y
CONFIG_RTS5208=y
CONFIG_RTS5208_DEBUG=y
# CONFIG_TRANZPORT is not set
CONFIG_LINE6_USB=y
# CONFIG_LINE6_USB_IMPULSE_RESPONSE is not set
CONFIG_USB_SERIAL_QUATECH2=y
CONFIG_DX_SEP=y

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
# CONFIG_AD799X is not set
# CONFIG_LPC32XX_ADC is not set
CONFIG_MXS_LRADC=y
# CONFIG_SPEAR_ADC is not set

#
# Analog digital bi-direction converters
#

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
# CONFIG_SENSORS_ISL29018 is not set
CONFIG_SENSORS_ISL29028=y
CONFIG_TSL2583=y
CONFIG_TSL2x7x=y

#
# Magnetometer sensors
#
CONFIG_SENSORS_HMC5843=y

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
CONFIG_IIO_DUMMY_EVGEN=y
CONFIG_IIO_SIMPLE_DUMMY=y
CONFIG_IIO_SIMPLE_DUMMY_EVENTS=y
CONFIG_IIO_SIMPLE_DUMMY_BUFFER=y
# CONFIG_CRYSTALHD is not set
CONFIG_FB_XGI=y
# CONFIG_ACPI_QUICKSTART is not set
CONFIG_BCM_WIMAX=y
# CONFIG_FT1000 is not set

#
# Speakup console speech
#
# CONFIG_TOUCHSCREEN_SYNAPTICS_I2C_RMI4 is not set
CONFIG_STAGING_MEDIA=y
# CONFIG_I2C_BCM2048 is not set
CONFIG_VIDEO_DT3155=y
CONFIG_DT3155_CCIR=y
CONFIG_DT3155_STREAMING=y
CONFIG_VIDEO_GO7007=y
CONFIG_VIDEO_GO7007_USB=y
# CONFIG_VIDEO_GO7007_LOADER is not set
CONFIG_VIDEO_GO7007_USB_S2250_BOARD=y
# CONFIG_VIDEO_TCM825X is not set
CONFIG_SOLO6X10=y

#
# Android
#
# CONFIG_ANDROID is not set
# CONFIG_USB_WPAN_HCD is not set
# CONFIG_WIMAX_GDM72XX is not set
# CONFIG_CED1401 is not set
CONFIG_DGRP=y
# CONFIG_FIREWIRE_SERIAL is not set
# CONFIG_XILLYBUS is not set
# CONFIG_DGNC is not set
CONFIG_DGAP=y
# CONFIG_GS_FPGABOOT is not set
# CONFIG_UNISYSSPAR is not set
CONFIG_X86_PLATFORM_DEVICES=y
# CONFIG_ACERHDF is not set
# CONFIG_ASUS_LAPTOP is not set
# CONFIG_DELL_LAPTOP is not set
# CONFIG_FUJITSU_LAPTOP is not set
# CONFIG_FUJITSU_TABLET is not set
# CONFIG_AMILO_RFKILL is not set
# CONFIG_HP_ACCEL is not set
# CONFIG_HP_WIRELESS is not set
# CONFIG_MSI_LAPTOP is not set
# CONFIG_PANASONIC_LAPTOP is not set
# CONFIG_COMPAL_LAPTOP is not set
# CONFIG_SONY_LAPTOP is not set
# CONFIG_IDEAPAD_LAPTOP is not set
# CONFIG_THINKPAD_ACPI is not set
CONFIG_SENSORS_HDAPS=y
# CONFIG_INTEL_MENLOW is not set
# CONFIG_ACPI_WMI is not set
# CONFIG_TOPSTAR_LAPTOP is not set
# CONFIG_TOSHIBA_BT_RFKILL is not set
# CONFIG_ACPI_CMPC is not set
# CONFIG_INTEL_IPS is not set
CONFIG_IBM_RTL=y
# CONFIG_XO15_EBOOK is not set
CONFIG_SAMSUNG_LAPTOP=y
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
CONFIG_CLKEVT_I8253=y
CONFIG_CLKBLD_I8253=y
CONFIG_SH_TIMER_CMT=y
# CONFIG_SH_TIMER_MTU2 is not set
# CONFIG_SH_TIMER_TMU is not set
CONFIG_EM_TIMER_STI=y
# CONFIG_MAILBOX is not set
# CONFIG_IOMMU_SUPPORT is not set

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
# CONFIG_EXTCON_ADC_JACK is not set
CONFIG_EXTCON_MAX14577=y
CONFIG_EXTCON_MAX8997=y
# CONFIG_MEMORY is not set
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
# CONFIG_BMA180 is not set
CONFIG_HID_SENSOR_ACCEL_3D=y
# CONFIG_IIO_ST_ACCEL_3AXIS is not set

#
# Analog to digital converters
#
CONFIG_LP8788_ADC=y
CONFIG_MAX1363=y
CONFIG_MCP3422=y
CONFIG_NAU7802=y
CONFIG_TI_ADC081C=y
CONFIG_TI_AM335X_ADC=y
CONFIG_TWL4030_MADC=y
# CONFIG_TWL6030_GPADC is not set
# CONFIG_VIPERBOARD_ADC is not set
CONFIG_XILINX_XADC=y

#
# Amplifiers
#

#
# Hid Sensor IIO Common
#
CONFIG_HID_SENSOR_IIO_COMMON=y
CONFIG_HID_SENSOR_IIO_TRIGGER=y
CONFIG_IIO_ST_SENSORS_I2C=y
CONFIG_IIO_ST_SENSORS_CORE=y

#
# Digital to analog converters
#
CONFIG_AD5064=y
CONFIG_AD5380=y
CONFIG_AD5446=y
CONFIG_MAX517=y
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
CONFIG_HID_SENSOR_GYRO_3D=y
CONFIG_IIO_ST_GYRO_3AXIS=y
CONFIG_IIO_ST_GYRO_I2C_3AXIS=y
# CONFIG_ITG3200 is not set

#
# Humidity sensors
#
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
CONFIG_HID_SENSOR_ALS=y
CONFIG_HID_SENSOR_PROX=y
CONFIG_SENSORS_LM3533=y
# CONFIG_LTR501 is not set
CONFIG_TCS3472=y
# CONFIG_SENSORS_TSL2563 is not set
CONFIG_TSL4531=y
CONFIG_VCNL4000=y

#
# Magnetometer sensors
#
CONFIG_MAG3110=y
# CONFIG_HID_SENSOR_MAGNETOMETER_3D is not set
CONFIG_IIO_ST_MAGN_3AXIS=y
CONFIG_IIO_ST_MAGN_I2C_3AXIS=y

#
# Inclinometer sensors
#
CONFIG_HID_SENSOR_INCLINOMETER_3D=y

#
# Triggers - standalone
#
CONFIG_IIO_INTERRUPT_TRIGGER=y
CONFIG_IIO_SYSFS_TRIGGER=y

#
# Pressure sensors
#
# CONFIG_HID_SENSOR_PRESS is not set
CONFIG_MPL3115=y
# CONFIG_IIO_ST_PRESS is not set

#
# Temperature sensors
#
# CONFIG_TMP006 is not set
CONFIG_NTB=y
CONFIG_VME_BUS=y

#
# VME Bridge Drivers
#
# CONFIG_VME_CA91CX42 is not set
# CONFIG_VME_TSI148 is not set

#
# VME Board Drivers
#
# CONFIG_VMIVME_7805 is not set

#
# VME Device Drivers
#
CONFIG_VME_USER=y
CONFIG_PWM=y
CONFIG_PWM_SYSFS=y
CONFIG_PWM_CLPS711X=y
# CONFIG_PWM_LP3943 is not set
# CONFIG_PWM_RENESAS_TPU is not set
CONFIG_PWM_TWL=y
CONFIG_PWM_TWL_LED=y
# CONFIG_IPACK_BUS is not set
CONFIG_RESET_CONTROLLER=y
CONFIG_FMC=y
CONFIG_FMC_FAKEDEV=y
CONFIG_FMC_TRIVIAL=y
CONFIG_FMC_WRITE_EEPROM=y
CONFIG_FMC_CHARDEV=y

#
# PHY Subsystem
#
CONFIG_GENERIC_PHY=y
CONFIG_PHY_EXYNOS_MIPI_VIDEO=y
CONFIG_OMAP_CONTROL_PHY=y
# CONFIG_BCM_KONA_USB2_PHY is not set
CONFIG_PHY_SAMSUNG_USB2=y
CONFIG_PHY_XGENE=y
CONFIG_POWERCAP=y
CONFIG_INTEL_RAPL=y
# CONFIG_MCB is not set

#
# Firmware Drivers
#
CONFIG_EDD=y
# CONFIG_EDD_OFF is not set
# CONFIG_FIRMWARE_MEMMAP is not set
# CONFIG_DELL_RBU is not set
CONFIG_DCDBAS=y
CONFIG_DMIID=y
CONFIG_DMI_SYSFS=y
CONFIG_DMI_SCAN_MACHINE_NON_EFI_FALLBACK=y
# CONFIG_ISCSI_IBFT_FIND is not set
# CONFIG_GOOGLE_FIRMWARE is not set

#
# File systems
#
CONFIG_DCACHE_WORD_ACCESS=y
# CONFIG_EXT2_FS is not set
# CONFIG_EXT3_FS is not set
# CONFIG_EXT4_FS is not set
CONFIG_JBD2=y
CONFIG_JBD2_DEBUG=y
CONFIG_REISERFS_FS=y
# CONFIG_REISERFS_CHECK is not set
CONFIG_REISERFS_PROC_INFO=y
# CONFIG_REISERFS_FS_XATTR is not set
# CONFIG_JFS_FS is not set
# CONFIG_XFS_FS is not set
CONFIG_GFS2_FS=y
CONFIG_OCFS2_FS=y
CONFIG_OCFS2_FS_O2CB=y
CONFIG_OCFS2_FS_STATS=y
CONFIG_OCFS2_DEBUG_MASKLOG=y
CONFIG_OCFS2_DEBUG_FS=y
# CONFIG_BTRFS_FS is not set
# CONFIG_NILFS2_FS is not set
CONFIG_FS_POSIX_ACL=y
CONFIG_EXPORTFS=y
CONFIG_FILE_LOCKING=y
CONFIG_FSNOTIFY=y
CONFIG_DNOTIFY=y
CONFIG_INOTIFY_USER=y
CONFIG_FANOTIFY=y
# CONFIG_FANOTIFY_ACCESS_PERMISSIONS is not set
CONFIG_QUOTA=y
# CONFIG_QUOTA_NETLINK_INTERFACE is not set
# CONFIG_PRINT_QUOTA_WARNING is not set
# CONFIG_QUOTA_DEBUG is not set
CONFIG_QUOTA_TREE=y
# CONFIG_QFMT_V1 is not set
CONFIG_QFMT_V2=y
CONFIG_QUOTACTL=y
CONFIG_QUOTACTL_COMPAT=y
# CONFIG_AUTOFS4_FS is not set
CONFIG_FUSE_FS=y
CONFIG_CUSE=y

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
# CONFIG_PROC_KCORE is not set
# CONFIG_PROC_VMCORE is not set
# CONFIG_PROC_SYSCTL is not set
# CONFIG_PROC_PAGE_MONITOR is not set
CONFIG_KERNFS=y
CONFIG_SYSFS=y
CONFIG_HUGETLBFS=y
CONFIG_HUGETLB_PAGE=y
CONFIG_CONFIGFS_FS=y
CONFIG_MISC_FILESYSTEMS=y
CONFIG_ADFS_FS=y
# CONFIG_ADFS_FS_RW is not set
# CONFIG_AFFS_FS is not set
# CONFIG_ECRYPT_FS is not set
# CONFIG_HFS_FS is not set
CONFIG_HFSPLUS_FS=y
# CONFIG_HFSPLUS_FS_POSIX_ACL is not set
CONFIG_BEFS_FS=y
CONFIG_BEFS_DEBUG=y
# CONFIG_BFS_FS is not set
# CONFIG_EFS_FS is not set
# CONFIG_LOGFS is not set
CONFIG_CRAMFS=y
# CONFIG_SQUASHFS is not set
CONFIG_VXFS_FS=y
CONFIG_MINIX_FS=y
# CONFIG_OMFS_FS is not set
CONFIG_HPFS_FS=y
CONFIG_QNX4FS_FS=y
# CONFIG_QNX6FS_FS is not set
CONFIG_ROMFS_FS=y
CONFIG_ROMFS_BACKED_BY_BLOCK=y
CONFIG_ROMFS_ON_BLOCK=y
CONFIG_PSTORE=y
# CONFIG_PSTORE_CONSOLE is not set
CONFIG_PSTORE_FTRACE=y
CONFIG_PSTORE_RAM=y
CONFIG_SYSV_FS=y
CONFIG_UFS_FS=y
# CONFIG_UFS_FS_WRITE is not set
CONFIG_UFS_DEBUG=y
CONFIG_F2FS_FS=y
# CONFIG_F2FS_STAT_FS is not set
CONFIG_F2FS_FS_XATTR=y
CONFIG_F2FS_FS_POSIX_ACL=y
# CONFIG_F2FS_FS_SECURITY is not set
# CONFIG_F2FS_CHECK_FS is not set
# CONFIG_NETWORK_FILESYSTEMS is not set
CONFIG_NLS=y
CONFIG_NLS_DEFAULT="iso8859-1"
CONFIG_NLS_CODEPAGE_437=y
# CONFIG_NLS_CODEPAGE_737 is not set
CONFIG_NLS_CODEPAGE_775=y
# CONFIG_NLS_CODEPAGE_850 is not set
# CONFIG_NLS_CODEPAGE_852 is not set
CONFIG_NLS_CODEPAGE_855=y
CONFIG_NLS_CODEPAGE_857=y
CONFIG_NLS_CODEPAGE_860=y
# CONFIG_NLS_CODEPAGE_861 is not set
# CONFIG_NLS_CODEPAGE_862 is not set
CONFIG_NLS_CODEPAGE_863=y
# CONFIG_NLS_CODEPAGE_864 is not set
CONFIG_NLS_CODEPAGE_865=y
# CONFIG_NLS_CODEPAGE_866 is not set
CONFIG_NLS_CODEPAGE_869=y
# CONFIG_NLS_CODEPAGE_936 is not set
# CONFIG_NLS_CODEPAGE_950 is not set
CONFIG_NLS_CODEPAGE_932=y
# CONFIG_NLS_CODEPAGE_949 is not set
CONFIG_NLS_CODEPAGE_874=y
CONFIG_NLS_ISO8859_8=y
CONFIG_NLS_CODEPAGE_1250=y
CONFIG_NLS_CODEPAGE_1251=y
# CONFIG_NLS_ASCII is not set
CONFIG_NLS_ISO8859_1=y
# CONFIG_NLS_ISO8859_2 is not set
CONFIG_NLS_ISO8859_3=y
# CONFIG_NLS_ISO8859_4 is not set
CONFIG_NLS_ISO8859_5=y
# CONFIG_NLS_ISO8859_6 is not set
CONFIG_NLS_ISO8859_7=y
# CONFIG_NLS_ISO8859_9 is not set
CONFIG_NLS_ISO8859_13=y
CONFIG_NLS_ISO8859_14=y
CONFIG_NLS_ISO8859_15=y
CONFIG_NLS_KOI8_R=y
# CONFIG_NLS_KOI8_U is not set
CONFIG_NLS_MAC_ROMAN=y
CONFIG_NLS_MAC_CELTIC=y
CONFIG_NLS_MAC_CENTEURO=y
# CONFIG_NLS_MAC_CROATIAN is not set
CONFIG_NLS_MAC_CYRILLIC=y
CONFIG_NLS_MAC_GAELIC=y
CONFIG_NLS_MAC_GREEK=y
CONFIG_NLS_MAC_ICELAND=y
# CONFIG_NLS_MAC_INUIT is not set
# CONFIG_NLS_MAC_ROMANIAN is not set
CONFIG_NLS_MAC_TURKISH=y
CONFIG_NLS_UTF8=y

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
CONFIG_FRAME_WARN=2048
# CONFIG_STRIP_ASM_SYMS is not set
CONFIG_READABLE_ASM=y
CONFIG_UNUSED_SYMBOLS=y
CONFIG_DEBUG_FS=y
# CONFIG_HEADERS_CHECK is not set
# CONFIG_DEBUG_SECTION_MISMATCH is not set
CONFIG_ARCH_WANT_FRAME_POINTERS=y
CONFIG_FRAME_POINTER=y
# CONFIG_DEBUG_FORCE_WEAK_PER_CPU is not set
CONFIG_MAGIC_SYSRQ=y
CONFIG_MAGIC_SYSRQ_DEFAULT_ENABLE=0x1
CONFIG_DEBUG_KERNEL=y

#
# Memory Debugging
#
# CONFIG_DEBUG_PAGEALLOC is not set
CONFIG_DEBUG_OBJECTS=y
# CONFIG_DEBUG_OBJECTS_SELFTEST is not set
CONFIG_DEBUG_OBJECTS_FREE=y
CONFIG_DEBUG_OBJECTS_TIMERS=y
CONFIG_DEBUG_OBJECTS_WORK=y
CONFIG_DEBUG_OBJECTS_RCU_HEAD=y
# CONFIG_DEBUG_OBJECTS_PERCPU_COUNTER is not set
CONFIG_DEBUG_OBJECTS_ENABLE_DEFAULT=1
# CONFIG_SLUB_STATS is not set
CONFIG_HAVE_DEBUG_KMEMLEAK=y
# CONFIG_DEBUG_KMEMLEAK is not set
# CONFIG_DEBUG_STACK_USAGE is not set
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
CONFIG_LOCKUP_DETECTOR=y
CONFIG_HARDLOCKUP_DETECTOR=y
CONFIG_BOOTPARAM_HARDLOCKUP_PANIC=y
CONFIG_BOOTPARAM_HARDLOCKUP_PANIC_VALUE=1
# CONFIG_BOOTPARAM_SOFTLOCKUP_PANIC is not set
CONFIG_BOOTPARAM_SOFTLOCKUP_PANIC_VALUE=0
CONFIG_DETECT_HUNG_TASK=y
CONFIG_DEFAULT_HUNG_TASK_TIMEOUT=120
CONFIG_BOOTPARAM_HUNG_TASK_PANIC=y
CONFIG_BOOTPARAM_HUNG_TASK_PANIC_VALUE=1
# CONFIG_PANIC_ON_OOPS is not set
CONFIG_PANIC_ON_OOPS_VALUE=0
CONFIG_PANIC_TIMEOUT=0
CONFIG_SCHED_DEBUG=y
# CONFIG_SCHEDSTATS is not set
CONFIG_TIMER_STATS=y
# CONFIG_DEBUG_PREEMPT is not set

#
# Lock Debugging (spinlocks, mutexes, etc...)
#
# CONFIG_DEBUG_RT_MUTEXES is not set
CONFIG_RT_MUTEX_TESTER=y
# CONFIG_DEBUG_SPINLOCK is not set
CONFIG_DEBUG_MUTEXES=y
# CONFIG_DEBUG_WW_MUTEX_SLOWPATH is not set
# CONFIG_DEBUG_LOCK_ALLOC is not set
# CONFIG_PROVE_LOCKING is not set
# CONFIG_LOCK_STAT is not set
CONFIG_DEBUG_ATOMIC_SLEEP=y
CONFIG_DEBUG_LOCKING_API_SELFTESTS=y
CONFIG_LOCK_TORTURE_TEST=y
CONFIG_STACKTRACE=y
# CONFIG_DEBUG_KOBJECT is not set
# CONFIG_DEBUG_KOBJECT_RELEASE is not set
CONFIG_DEBUG_BUGVERBOSE=y
CONFIG_DEBUG_WRITECOUNT=y
# CONFIG_DEBUG_LIST is not set
CONFIG_DEBUG_SG=y
# CONFIG_DEBUG_NOTIFIERS is not set
# CONFIG_DEBUG_CREDENTIALS is not set

#
# RCU Debugging
#
# CONFIG_PROVE_RCU_DELAY is not set
CONFIG_SPARSE_RCU_POINTER=y
CONFIG_TORTURE_TEST=y
# CONFIG_RCU_TORTURE_TEST is not set
CONFIG_RCU_CPU_STALL_TIMEOUT=21
# CONFIG_RCU_CPU_STALL_VERBOSE is not set
# CONFIG_RCU_CPU_STALL_INFO is not set
# CONFIG_RCU_TRACE is not set
# CONFIG_DEBUG_BLOCK_EXT_DEVT is not set
CONFIG_NOTIFIER_ERROR_INJECTION=y
CONFIG_PM_NOTIFIER_ERROR_INJECT=y
# CONFIG_FAULT_INJECTION is not set
# CONFIG_LATENCYTOP is not set
CONFIG_ARCH_HAS_DEBUG_STRICT_USER_COPY_CHECKS=y
# CONFIG_DEBUG_STRICT_USER_COPY_CHECKS is not set
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
# CONFIG_FUNCTION_GRAPH_TRACER is not set
# CONFIG_IRQSOFF_TRACER is not set
CONFIG_PREEMPT_TRACER=y
# CONFIG_SCHED_TRACER is not set
# CONFIG_FTRACE_SYSCALLS is not set
CONFIG_TRACER_SNAPSHOT=y
CONFIG_TRACER_SNAPSHOT_PER_CPU_SWAP=y
CONFIG_BRANCH_PROFILE_NONE=y
# CONFIG_PROFILE_ANNOTATED_BRANCHES is not set
# CONFIG_PROFILE_ALL_BRANCHES is not set
CONFIG_STACK_TRACER=y
# CONFIG_BLK_DEV_IO_TRACE is not set
# CONFIG_UPROBE_EVENT is not set
# CONFIG_PROBE_EVENTS is not set
CONFIG_DYNAMIC_FTRACE=y
CONFIG_DYNAMIC_FTRACE_WITH_REGS=y
CONFIG_FUNCTION_PROFILER=y
CONFIG_FTRACE_MCOUNT_RECORD=y
# CONFIG_FTRACE_STARTUP_TEST is not set
CONFIG_MMIOTRACE=y
# CONFIG_RING_BUFFER_BENCHMARK is not set
# CONFIG_RING_BUFFER_STARTUP_TEST is not set

#
# Runtime Testing
#
CONFIG_LKDTM=y
# CONFIG_TEST_LIST_SORT is not set
# CONFIG_BACKTRACE_SELF_TEST is not set
CONFIG_RBTREE_TEST=y
CONFIG_ATOMIC64_SELFTEST=y
# CONFIG_ASYNC_RAID6_TEST is not set
CONFIG_TEST_STRING_HELPERS=y
# CONFIG_TEST_KSTRTOX is not set
# CONFIG_PROVIDE_OHCI1394_DMA_INIT is not set
# CONFIG_DMA_API_DEBUG is not set
# CONFIG_SAMPLES is not set
CONFIG_HAVE_ARCH_KGDB=y
# CONFIG_KGDB is not set
# CONFIG_STRICT_DEVMEM is not set
CONFIG_X86_VERBOSE_BOOTUP=y
# CONFIG_EARLY_PRINTK is not set
CONFIG_X86_PTDUMP=y
# CONFIG_DEBUG_RODATA is not set
# CONFIG_DOUBLEFAULT is not set
# CONFIG_DEBUG_TLBFLUSH is not set
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
# CONFIG_OPTIMIZE_INLINING is not set
CONFIG_DEBUG_NMI_SELFTEST=y
# CONFIG_X86_DEBUG_STATIC_CPU_HAS is not set

#
# Security options
#
CONFIG_KEYS=y
# CONFIG_PERSISTENT_KEYRINGS is not set
# CONFIG_TRUSTED_KEYS is not set
CONFIG_ENCRYPTED_KEYS=y
CONFIG_KEYS_DEBUG_PROC_KEYS=y
# CONFIG_SECURITY_DMESG_RESTRICT is not set
CONFIG_SECURITY=y
CONFIG_SECURITYFS=y
CONFIG_SECURITY_NETWORK=y
CONFIG_SECURITY_NETWORK_XFRM=y
CONFIG_SECURITY_PATH=y
# CONFIG_SECURITY_TOMOYO is not set
CONFIG_SECURITY_APPARMOR=y
CONFIG_SECURITY_APPARMOR_BOOTPARAM_VALUE=1
CONFIG_SECURITY_APPARMOR_HASH=y
CONFIG_SECURITY_YAMA=y
# CONFIG_SECURITY_YAMA_STACKED is not set
CONFIG_INTEGRITY=y
# CONFIG_INTEGRITY_SIGNATURE is not set
CONFIG_INTEGRITY_AUDIT=y
CONFIG_IMA=y
CONFIG_IMA_MEASURE_PCR_IDX=10
# CONFIG_IMA_TEMPLATE is not set
# CONFIG_IMA_NG_TEMPLATE is not set
CONFIG_IMA_SIG_TEMPLATE=y
CONFIG_IMA_DEFAULT_TEMPLATE="ima-sig"
# CONFIG_IMA_DEFAULT_HASH_SHA1 is not set
# CONFIG_IMA_DEFAULT_HASH_SHA256 is not set
# CONFIG_IMA_DEFAULT_HASH_SHA512 is not set
CONFIG_IMA_DEFAULT_HASH_WP512=y
CONFIG_IMA_DEFAULT_HASH="wp512"
# CONFIG_IMA_APPRAISE is not set
# CONFIG_EVM is not set
# CONFIG_DEFAULT_SECURITY_APPARMOR is not set
# CONFIG_DEFAULT_SECURITY_YAMA is not set
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
CONFIG_CRYPTO_RNG=y
CONFIG_CRYPTO_RNG2=y
CONFIG_CRYPTO_PCOMP=y
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
CONFIG_CRYPTO_ABLK_HELPER=y
CONFIG_CRYPTO_GLUE_HELPER_X86=y

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
CONFIG_CRYPTO_CTS=y
# CONFIG_CRYPTO_ECB is not set
CONFIG_CRYPTO_LRW=y
CONFIG_CRYPTO_PCBC=y
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
CONFIG_CRYPTO_CRC32C_INTEL=y
CONFIG_CRYPTO_CRC32=y
CONFIG_CRYPTO_CRC32_PCLMUL=y
CONFIG_CRYPTO_CRCT10DIF=y
CONFIG_CRYPTO_CRCT10DIF_PCLMUL=y
CONFIG_CRYPTO_GHASH=y
CONFIG_CRYPTO_MD4=y
CONFIG_CRYPTO_MD5=y
CONFIG_CRYPTO_MICHAEL_MIC=y
CONFIG_CRYPTO_RMD128=y
# CONFIG_CRYPTO_RMD160 is not set
CONFIG_CRYPTO_RMD256=y
CONFIG_CRYPTO_RMD320=y
CONFIG_CRYPTO_SHA1=y
CONFIG_CRYPTO_SHA1_SSSE3=y
CONFIG_CRYPTO_SHA256_SSSE3=y
CONFIG_CRYPTO_SHA512_SSSE3=y
CONFIG_CRYPTO_SHA256=y
CONFIG_CRYPTO_SHA512=y
# CONFIG_CRYPTO_TGR192 is not set
CONFIG_CRYPTO_WP512=y
CONFIG_CRYPTO_GHASH_CLMUL_NI_INTEL=y

#
# Ciphers
#
CONFIG_CRYPTO_AES=y
CONFIG_CRYPTO_AES_X86_64=y
CONFIG_CRYPTO_AES_NI_INTEL=y
# CONFIG_CRYPTO_ANUBIS is not set
CONFIG_CRYPTO_ARC4=y
# CONFIG_CRYPTO_BLOWFISH is not set
CONFIG_CRYPTO_BLOWFISH_COMMON=y
CONFIG_CRYPTO_BLOWFISH_X86_64=y
# CONFIG_CRYPTO_CAMELLIA is not set
CONFIG_CRYPTO_CAMELLIA_X86_64=y
CONFIG_CRYPTO_CAMELLIA_AESNI_AVX_X86_64=y
# CONFIG_CRYPTO_CAMELLIA_AESNI_AVX2_X86_64 is not set
CONFIG_CRYPTO_CAST_COMMON=y
CONFIG_CRYPTO_CAST5=y
CONFIG_CRYPTO_CAST5_AVX_X86_64=y
CONFIG_CRYPTO_CAST6=y
CONFIG_CRYPTO_CAST6_AVX_X86_64=y
CONFIG_CRYPTO_DES=y
# CONFIG_CRYPTO_FCRYPT is not set
# CONFIG_CRYPTO_KHAZAD is not set
CONFIG_CRYPTO_SALSA20=y
# CONFIG_CRYPTO_SALSA20_X86_64 is not set
CONFIG_CRYPTO_SEED=y
CONFIG_CRYPTO_SERPENT=y
CONFIG_CRYPTO_SERPENT_SSE2_X86_64=y
CONFIG_CRYPTO_SERPENT_AVX_X86_64=y
CONFIG_CRYPTO_SERPENT_AVX2_X86_64=y
# CONFIG_CRYPTO_TEA is not set
# CONFIG_CRYPTO_TWOFISH is not set
CONFIG_CRYPTO_TWOFISH_COMMON=y
CONFIG_CRYPTO_TWOFISH_X86_64=y
CONFIG_CRYPTO_TWOFISH_X86_64_3WAY=y
CONFIG_CRYPTO_TWOFISH_AVX_X86_64=y

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
CONFIG_CRYPTO_HW=y
CONFIG_CRYPTO_DEV_PADLOCK=y
CONFIG_CRYPTO_DEV_PADLOCK_AES=y
CONFIG_CRYPTO_DEV_PADLOCK_SHA=y
# CONFIG_CRYPTO_DEV_CCP is not set
CONFIG_ASYMMETRIC_KEY_TYPE=y
CONFIG_ASYMMETRIC_PUBLIC_KEY_SUBTYPE=y
CONFIG_PUBLIC_KEY_ALGO_RSA=y
CONFIG_X509_CERTIFICATE_PARSER=y
CONFIG_HAVE_KVM=y
# CONFIG_VIRTUALIZATION is not set
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
CONFIG_STMP_DEVICE=y
CONFIG_ARCH_USE_CMPXCHG_LOCKREF=y
CONFIG_CRC_CCITT=y
CONFIG_CRC16=y
CONFIG_CRC_T10DIF=y
CONFIG_CRC_ITU_T=y
CONFIG_CRC32=y
# CONFIG_CRC32_SELFTEST is not set
# CONFIG_CRC32_SLICEBY8 is not set
CONFIG_CRC32_SLICEBY4=y
# CONFIG_CRC32_SARWATE is not set
# CONFIG_CRC32_BIT is not set
CONFIG_CRC7=y
CONFIG_LIBCRC32C=y
# CONFIG_CRC8 is not set
CONFIG_CRC64_ECMA=y
# CONFIG_AUDIT_ARCH_COMPAT_GENERIC is not set
CONFIG_RANDOM32_SELFTEST=y
CONFIG_ZLIB_INFLATE=y
CONFIG_ZLIB_DEFLATE=y
CONFIG_LZO_COMPRESS=y
CONFIG_LZO_DECOMPRESS=y
CONFIG_LZ4_COMPRESS=y
CONFIG_LZ4_DECOMPRESS=y
CONFIG_XZ_DEC=y
CONFIG_XZ_DEC_X86=y
CONFIG_XZ_DEC_POWERPC=y
# CONFIG_XZ_DEC_IA64 is not set
# CONFIG_XZ_DEC_ARM is not set
# CONFIG_XZ_DEC_ARMTHUMB is not set
CONFIG_XZ_DEC_SPARC=y
CONFIG_XZ_DEC_BCJ=y
# CONFIG_XZ_DEC_TEST is not set
CONFIG_DECOMPRESS_GZIP=y
CONFIG_GENERIC_ALLOCATOR=y
CONFIG_REED_SOLOMON=y
CONFIG_REED_SOLOMON_ENC8=y
CONFIG_REED_SOLOMON_DEC8=y
CONFIG_ASSOCIATIVE_ARRAY=y
CONFIG_HAS_IOMEM=y
CONFIG_HAS_IOPORT_MAP=y
CONFIG_HAS_DMA=y
CONFIG_CHECK_SIGNATURE=y
CONFIG_DQL=y
CONFIG_NLATTR=y
CONFIG_ARCH_HAS_ATOMIC64_DEC_IF_POSITIVE=y
# CONFIG_AVERAGE is not set
CONFIG_CLZ_TAB=y
CONFIG_CORDIC=y
CONFIG_DDR=y
CONFIG_MPILIB=y
CONFIG_OID_REGISTRY=y
CONFIG_FONT_SUPPORT=y
CONFIG_FONT_8x16=y
CONFIG_FONT_AUTOSELECT=y

--DocE+STaALJfprDB--
