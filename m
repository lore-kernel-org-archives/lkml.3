Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752929AbaAKQOV (ORCPT <rfc822;w@1wt.eu>);
	Sat, 11 Jan 2014 11:14:21 -0500
Received: from mga03.intel.com ([143.182.124.21]:56192 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753001AbaAKQON (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 11 Jan 2014 11:14:13 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.95,643,1384329600"; 
   d="log'?scan'208";a="457212025"
Date: Sun, 12 Jan 2014 00:14:04 +0800
From: kernel test robot <fengguang.wu@intel.com>
To: Ming Lei <tom.leiming@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: [percpu_counter] WARNING: CPU: 1 PID: 1 at
 kernel/locking/lockdep.c:3537 check_flags()
Message-ID: <20140111161404.GA7744@localhost>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="/9DWx/yDrRhgMJTb"
Content-Disposition: inline
User-Agent: Heirloom mailx 12.5 6/20/10
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--/9DWx/yDrRhgMJTb
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Greetings,

I got the below dmesg and the first bad commit is

commit 97e890b9c839c191a500c3a19bfb4539f65c70be
Author:     Ming Lei <tom.leiming@gmail.com>
AuthorDate: Fri Jan 10 12:41:46 2014 +1100
Commit:     Stephen Rothwell <sfr@canb.auug.org.au>
CommitDate: Fri Jan 10 12:41:46 2014 +1100

    lib/percpu_counter.c: disable local irq when updating percpu couter
    
    __percpu_counter_add() may be called in softirq/hardirq handler (such as,
    blk_mq_queue_exit() is typically called in hardirq/softirq handler), so we
    need to disable local irq when updating the percpu counter, otherwise
    counts may be lost.
    
    The patch fixes problem that 'rmmod null_blk' may hang in blk_cleanup_queue()
    because of miscounting of request_queue->mq_usage_counter.
    
    Signed-off-by: Ming Lei <tom.leiming@gmail.com>
    Cc: Paul Gortmaker <paul.gortmaker@windriver.com>
    Cc: Andrew Morton <akpm@linux-foundation.org>
    Cc: Shaohua Li <shli@fusionio.com>
    Cc: Jens Axboe <axboe@kernel.dk>
    Cc: Fan Du <fan.du@windriver.com>
    Cc: Tejun Heo <tj@kernel.org>
    Cc: <stable@vger.kernel.org>
    Signed-off-by: Andrew Morton <akpm@linux-foundation.org>

+-----------------------------------------------------------+----+
|                                                           |    |
+-----------------------------------------------------------+----+
| boot_successes                                            | 0  |
| boot_failures                                             | 19 |
| WARNING:CPU:PID:at_kernel/locking/lockdep.c:check_flags() | 19 |
+-----------------------------------------------------------+----+

[    8.021637] Freeing unused kernel memory: 816K (ffff880001934000 - ffff880001a00000)

[    8.093354] ------------[ cut here ]------------
[    8.095469] WARNING: CPU: 1 PID: 1 at kernel/locking/lockdep.c:3537 check_flags+0x77/0x1ba()
[    8.095469] DEBUG_LOCKS_WARN_ON(current->hardirqs_enabled)
[    8.095469] CPU: 1 PID: 1 Comm: init Not tainted 3.13.0-rc7-next-20140110-08732-g1955a14 #1
[    8.095469]  0000000000000000 ffff880000077c30 ffffffff8156f277 ffff880000077c78
[    8.095469]  ffff880000077c68 ffffffff81091f0b ffffffff810c6bb2 0000000000000046
[    8.095469]  ffffffff824d27d8 ffff88000e6b8000 0000000000000246 ffff880000077cc8
[    8.095469] Call Trace:
[    8.095469]  [<ffffffff8156f277>] dump_stack+0x4d/0x66
[    8.095469]  [<ffffffff81091f0b>] warn_slowpath_common+0x70/0x89
[    8.095469]  [<ffffffff810c6bb2>] ? check_flags+0x77/0x1ba
[    8.095469]  [<ffffffff81091f85>] warn_slowpath_fmt+0x47/0x49
[    8.095469]  [<ffffffff810c6bb2>] check_flags+0x77/0x1ba
[    8.095469]  [<ffffffff810ca55a>] lock_acquire+0x50/0xc4
[    8.095469]  [<ffffffff8157b9e5>] _raw_spin_lock+0x32/0x3f
[    8.095469]  [<ffffffff811f9238>] ? __percpu_counter_add+0x45/0x73
[    8.095469]  [<ffffffff811f9238>] __percpu_counter_add+0x45/0x73
[    8.095469]  [<ffffffff81120358>] __vm_enough_memory+0x24/0x12f
[    8.095469]  [<ffffffff8119f964>] cap_vm_enough_memory+0x47/0x4c
[    8.095469]  [<ffffffff8119fade>] security_vm_enough_memory_mm+0xe/0x10
[    8.095469]  [<ffffffff81090a50>] copy_process+0xb67/0x151d
[    8.095469]  [<ffffffff81091555>] do_fork+0x87/0x244
[    8.095469]  [<ffffffff81101e64>] ? context_tracking_user_exit+0x65/0x84
[    8.095469]  [<ffffffff81091778>] SyS_clone+0x11/0x13
[    8.095469]  [<ffffffff8157d119>] stub_clone+0x69/0x90
[    8.095469]  [<ffffffff8157cf66>] ? tracesys+0xd4/0xd9
[    8.095469] ---[ end trace 23660513ccff1a6d ]---
[    8.095469] possible reason: unannotated irqs-off.

git bisect start 1955a14a5ba6e3c3b11117812d11dc550ccc37ae 7ddcdb2ccdcae0838a39b1bf7b0773c5540da847 --
git bisect  bad 83548563c157403ba219b5bd9c59141f11377182  # 20:00      0-      2  Merge branch 'akpm-current/current'
git bisect good 8b0f1c99ffb8d8af0ab66d7a115fe0873225ef45  # 20:24     20+      0  ocfs2: return EINVAL if the given range to discard is less than block size
git bisect good 201959135faa132bf817cce415cb864d80a822ff  # 20:47     20+      0  swap: add a simple detector for inappropriate swapin readahead
git bisect  bad d4c0399994314ca03ce1313c4952aa385b9355aa  # 20:55      0-      6  drivers/rtc/rtc-mxc.c: remove unneeded label
git bisect good 4e0af6dd2777122c510b4fe92e306d94c4264375  # 21:07     20+      0  backlight: omap1: use devm_backlight_device_register()
git bisect  bad 71c3c0b0f0649c71fa4ee8dd3333b7351fc76707  # 21:15      0-      2  checkpatch: warn only on "space before semicolon" at end of line
git bisect good 383f1e84a52533a6d198e8a6f3e79ff5b433269a  # 21:30     20+      0  lib/kstrtox.c: remove redundant cleanup
git bisect good 55cbfd15fd125aad68b9a958749ae2d3c192db9c  # 21:38     20+      0  lib/assoc_array.c: remove global variable
git bisect  bad 299de867cbaf576ee0aa08d3c38339dcaa70d4d1  # 21:42      0-      3  firmware/dmi_scan: generalize for use by other archs
git bisect  bad 7cd7feb13f684d5ff9219e5117e359e898ecad97  # 21:46      0-      1  lib: Add CRC64 ECMA module
git bisect  bad 97e890b9c839c191a500c3a19bfb4539f65c70be  # 21:47      0-      3  lib/percpu_counter.c: disable local irq when updating percpu couter
# first bad commit: [97e890b9c839c191a500c3a19bfb4539f65c70be] lib/percpu_counter.c: disable local irq when updating percpu couter
git bisect good 55cbfd15fd125aad68b9a958749ae2d3c192db9c  # 21:54     60+      0  lib/assoc_array.c: remove global variable
git bisect  bad 1955a14a5ba6e3c3b11117812d11dc550ccc37ae  # 21:54      0-     19  Add linux-next specific files for 20140110
git bisect good 005d44e813048aae0ae683f5902ca823b616d002  # 22:09     60+      0  Revert "lib/percpu_counter.c: disable local irq when updating percpu couter"
git bisect good 228fdc083b017eaf90e578fa86fb1ecfd5ffae87  # 22:26     60+      0  Merge git://git.kernel.org/pub/scm/linux/kernel/git/davem/net
git bisect  bad 1955a14a5ba6e3c3b11117812d11dc550ccc37ae  # 22:26      0-     19  Add linux-next specific files for 20140110

Thanks,
Fengguang

--/9DWx/yDrRhgMJTb
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="dmesg-yocto-snb-2:20140111164909:x86_64-randconfig-s2-01111628:3.13.0-rc7-next-20140110-08732-g1955a14:1"
Content-Transfer-Encoding: quoted-printable

early console in setup code
Probing EDD (edd=3Doff to disable)... ok
[    0.000000] Linux version 3.13.0-rc7-next-20140110-08732-g1955a14 (kbuil=
d@snb) (gcc version 4.8.1 (Debian 4.8.1-8) ) #1 SMP Sat Jan 11 16:44:17 CST=
 2014
[    0.000000] Command line: hung_task_panic=3D1 earlyprintk=3DttyS0,115200=
 debug apic=3Ddebug sysrq_always_enabled panic=3D10  prompt_ramdisk=3D0 con=
sole=3DttyS0,115200 console=3Dtty0 vga=3Dnormal  root=3D/dev/ram0 rw link=
=3D/kernel-tests/run-queue/kvm/x86_64-randconfig-s2-01111628/next:master/.v=
mlinuz-1955a14a5ba6e3c3b11117812d11dc550ccc37ae-20140111164600-7-snb branch=
=3Dnext/master BOOT_IMAGE=3D/kernel/x86_64-randconfig-s2-01111628/1955a14a5=
ba6e3c3b11117812d11dc550ccc37ae/vmlinuz-3.13.0-rc7-next-20140110-08732-g195=
5a14
[    0.000000] KERNEL supported cpus:
[    0.000000]   Intel GenuineIntel
[    0.000000]   AMD AuthenticAMD
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
[    0.000000] Hypervisor detected: KVM
[    0.000000] e820: update [mem 0x00000000-0x00000fff] usable =3D=3D> rese=
rved
[    0.000000] e820: remove [mem 0x000a0000-0x000fffff] usable
[    0.000000] e820: last_pfn =3D 0xfffe max_arch_pfn =3D 0x400000000
[    0.000000] Base memory trampoline at [ffff880000099000] 99000 size 24576
[    0.000000] init_memory_mapping: [mem 0x00000000-0x000fffff]
[    0.000000]  [mem 0x00000000-0x000fffff] page 4k
[    0.000000] BRK [0x024f8000, 0x024f8fff] PGTABLE
[    0.000000] BRK [0x024f9000, 0x024f9fff] PGTABLE
[    0.000000] BRK [0x024fa000, 0x024fafff] PGTABLE
[    0.000000] init_memory_mapping: [mem 0x0fa00000-0x0fbfffff]
[    0.000000]  [mem 0x0fa00000-0x0fbfffff] page 2M
[    0.000000] init_memory_mapping: [mem 0x0c000000-0x0f9fffff]
[    0.000000]  [mem 0x0c000000-0x0f9fffff] page 2M
[    0.000000] init_memory_mapping: [mem 0x00100000-0x0bffffff]
[    0.000000]  [mem 0x00100000-0x001fffff] page 4k
[    0.000000]  [mem 0x00200000-0x0bffffff] page 2M
[    0.000000] init_memory_mapping: [mem 0x0fc00000-0x0fffdfff]
[    0.000000]  [mem 0x0fc00000-0x0fdfffff] page 2M
[    0.000000]  [mem 0x0fe00000-0x0fffdfff] page 4k
[    0.000000] BRK [0x024fb000, 0x024fbfff] PGTABLE
[    0.000000] RAMDISK: [mem 0x0fce6000-0x0ffeffff]
[    0.000000] ACPI: RSDP 00000000000fd930 000014 (v00 BOCHS )
[    0.000000] ACPI: RSDT 000000000fffe450 000034 (v01 BOCHS  BXPCRSDT 0000=
0001 BXPC 00000001)
[    0.000000] ACPI: FACP 000000000fffff80 000074 (v01 BOCHS  BXPCFACP 0000=
0001 BXPC 00000001)
[    0.000000] ACPI: DSDT 000000000fffe490 0011A9 (v01   BXPC   BXDSDT 0000=
0001 INTL 20100528)
[    0.000000] ACPI: FACS 000000000fffff40 000040
[    0.000000] ACPI: SSDT 000000000ffff7a0 000796 (v01 BOCHS  BXPCSSDT 0000=
0001 BXPC 00000001)
[    0.000000] ACPI: APIC 000000000ffff680 000080 (v01 BOCHS  BXPCAPIC 0000=
0001 BXPC 00000001)
[    0.000000] ACPI: HPET 000000000ffff640 000038 (v01 BOCHS  BXPCHPET 0000=
0001 BXPC 00000001)
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] mapped APIC to ffffffffff57b000 (        fee00000)
[    0.000000] kvm-clock: Using msrs 4b564d01 and 4b564d00
[    0.000000] kvm-clock: cpu 0, msr 0:fc66001, boot clock
[    0.000000]  [ffffea0000000000-ffffea00003fffff] PMD -> [ffff88000f00000=
0-ffff88000f3fffff] on node 0
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
[    0.000000] mapped APIC to ffffffffff57b000 (        fee00000)
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
[    0.000000] mapped IOAPIC to ffffffffff57a000 (fec00000)
[    0.000000] nr_irqs_gsi: 40
[    0.000000] e820: [mem 0x10000000-0xfeffbfff] available for PCI devices
[    0.000000] Booting paravirtualized kernel on KVM
[    0.000000] setup_percpu: NR_CPUS:8192 nr_cpumask_bits:2 nr_cpu_ids:2 nr=
_node_ids:1
[    0.000000] PERCPU: Embedded 24 pages/cpu @ffff88000fa00000 s76224 r0 d2=
2080 u1048576
[    0.000000] pcpu-alloc: s76224 r0 d22080 u1048576 alloc=3D1*2097152
[    0.000000] pcpu-alloc: [0] 0 1=20
[    0.000000] kvm-clock: cpu 0, msr 0:fc66001, primary cpu clock
[    0.000000] KVM setup async PF for cpu 0
[    0.000000] kvm-stealtime: cpu 0, msr fa0cf40
[    0.000000] Built 1 zonelists in Zone order, mobility grouping on.  Tota=
l pages: 64391
[    0.000000] Kernel command line: hung_task_panic=3D1 earlyprintk=3DttyS0=
,115200 debug apic=3Ddebug sysrq_always_enabled panic=3D10  prompt_ramdisk=
=3D0 console=3DttyS0,115200 console=3Dtty0 vga=3Dnormal  root=3D/dev/ram0 r=
w link=3D/kernel-tests/run-queue/kvm/x86_64-randconfig-s2-01111628/next:mas=
ter/.vmlinuz-1955a14a5ba6e3c3b11117812d11dc550ccc37ae-20140111164600-7-snb =
branch=3Dnext/master BOOT_IMAGE=3D/kernel/x86_64-randconfig-s2-01111628/195=
5a14a5ba6e3c3b11117812d11dc550ccc37ae/vmlinuz-3.13.0-rc7-next-20140110-0873=
2-g1955a14
[    0.000000] PID hash table entries: 1024 (order: 1, 8192 bytes)
[    0.000000] Dentry cache hash table entries: 32768 (order: 6, 262144 byt=
es)
[    0.000000] Inode-cache hash table entries: 16384 (order: 5, 131072 byte=
s)
[    0.000000] Memory: 231540K/261744K available (5631K kernel code, 1372K =
rwdata, 3280K rodata, 864K init, 8972K bss, 30204K reserved)
[    0.000000] SLUB: HWalign=3D64, Order=3D0-3, MinObjects=3D0, CPUs=3D2, N=
odes=3D1
[    0.000000] Hierarchical RCU implementation.
[    0.000000]=20
[    0.000000]=20
[    0.000000]=20
[    0.000000] RCU: Adjusting geometry for rcu_fanout_leaf=3D16, nr_cpu_ids=
=3D2
[    0.000000] NR_IRQS:524544 nr_irqs:512 16
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
[    0.000000] ------------------------
[    0.000000] | Locking API testsuite:
[    0.000000] ------------------------------------------------------------=
----------------
[    0.000000]                                  | spin |wlock |rlock |mutex=
 | wsem | rsem |
[    0.000000]   ----------------------------------------------------------=
----------------
[    0.000000]                      A-A deadlock:  ok  |  ok  |  ok  |  ok =
 |  ok  |  ok  |
[    0.000000]                  A-B-B-A deadlock:  ok  |  ok  |  ok  |  ok =
 |  ok  |  ok  |
[    0.000000]              A-B-B-C-C-A deadlock:  ok  |  ok  |  ok  |  ok =
 |  ok  |  ok  |
[    0.000000]              A-B-C-A-B-C deadlock:  ok  |  ok  |  ok  |  ok =
 |  ok  |  ok  |
[    0.000000]          A-B-B-C-C-D-D-A deadlock:  ok  |  ok  |  ok  |  ok =
 |  ok  |  ok  |
[    0.000000]          A-B-C-D-B-D-D-A deadlock:  ok  |  ok  |  ok  |  ok =
 |  ok  |  ok  |
[    0.000000]          A-B-C-D-B-C-D-A deadlock:  ok  |  ok  |  ok  |  ok =
 |  ok  |  ok  |
[    0.000000]                     double unlock:  ok  |  ok  |  ok  |  ok =
 |  ok  |  ok  |
[    0.000000]                   initialize held:  ok  |  ok  |  ok  |  ok =
 |  ok  |  ok  |
[    0.000000]                  bad unlock order:  ok  |  ok  |  ok  |  ok =
 |  ok  |  ok  |
[    0.000000]   ----------------------------------------------------------=
----------------
[    0.000000]               recursive read-lock:             |  ok  |     =
        |  ok  |
[    0.000000]            recursive read-lock #2:             |  ok  |     =
        |  ok  |
[    0.000000]             mixed read-write-lock:             |  ok  |     =
        |  ok  |
[    0.000000]             mixed write-read-lock:             |  ok  |     =
        |  ok  |
[    0.000000]   ----------------------------------------------------------=
----------------
[    0.000000]      hard-irqs-on + irq-safe-A/12:  ok  |  ok  |  ok  |
[    0.000000]      soft-irqs-on + irq-safe-A/12:  ok  |  ok  |  ok  |
[    0.000000]      hard-irqs-on + irq-safe-A/21:  ok  |  ok  |  ok  |
[    0.000000]      soft-irqs-on + irq-safe-A/21:  ok  |  ok  |  ok  |
[    0.000000]        sirq-safe-A =3D> hirqs-on/12:  ok  |  ok  |  ok  |
[    0.000000]        sirq-safe-A =3D> hirqs-on/21:  ok  |  ok  |  ok  |
[    0.000000]          hard-safe-A + irqs-on/12:  ok  |  ok  |  ok  |
[    0.000000]          soft-safe-A + irqs-on/12:  ok  |  ok  |  ok  |
[    0.000000]          hard-safe-A + irqs-on/21:  ok  |  ok  |  ok  |
[    0.000000]          soft-safe-A + irqs-on/21:  ok  |  ok  |  ok  |
[    0.000000]     hard-safe-A + unsafe-B #1/123:  ok  |  ok  |  ok  |
[    0.000000]     soft-safe-A + unsafe-B #1/123:  ok  |  ok  |  ok  |
[    0.000000]     hard-safe-A + unsafe-B #1/132:  ok  |  ok  |  ok  |
[    0.000000]     soft-safe-A + unsafe-B #1/132:  ok  |  ok  |  ok  |
[    0.000000]     hard-safe-A + unsafe-B #1/213:  ok  |  ok  |  ok  |
[    0.000000]     soft-safe-A + unsafe-B #1/213:  ok  |  ok  |  ok  |
[    0.000000]     hard-safe-A + unsafe-B #1/231:  ok  |  ok  |  ok  |
[    0.000000]     soft-safe-A + unsafe-B #1/231:  ok  |  ok  |  ok  |
[    0.000000]     hard-safe-A + unsafe-B #1/312:  ok  |  ok  |  ok  |
[    0.000000]     soft-safe-A + unsafe-B #1/312:  ok  |  ok  |  ok  |
[    0.000000]     hard-safe-A + unsafe-B #1/321:  ok  |  ok  |  ok  |
[    0.000000]     soft-safe-A + unsafe-B #1/321:  ok  |  ok  |  ok  |
[    0.000000]     hard-safe-A + unsafe-B #2/123:  ok  |  ok  |  ok  |
[    0.000000]     soft-safe-A + unsafe-B #2/123:  ok  |  ok  |  ok  |
[    0.000000]     hard-safe-A + unsafe-B #2/132:  ok  |  ok  |  ok  |
[    0.000000]     soft-safe-A + unsafe-B #2/132:  ok  |  ok  |  ok  |
[    0.000000]     hard-safe-A + unsafe-B #2/213:  ok  |  ok  |  ok  |
[    0.000000]     soft-safe-A + unsafe-B #2/213:  ok  |  ok  |  ok  |
[    0.000000]     hard-safe-A + unsafe-B #2/231:  ok  |  ok  |  ok  |
[    0.000000]     soft-safe-A + unsafe-B #2/231:  ok  |  ok  |  ok  |
[    0.000000]     hard-safe-A + unsafe-B #2/312:  ok  |  ok  |  ok  |
[    0.000000]     soft-safe-A + unsafe-B #2/312:  ok  |  ok  |  ok  |
[    0.000000]     hard-safe-A + unsafe-B #2/321:  ok  |  ok  |  ok  |
[    0.000000]     soft-safe-A + unsafe-B #2/321:  ok  |  ok  |  ok  |
[    0.000000]       hard-irq lock-inversion/123:  ok  |  ok  |  ok  |
[    0.000000]       soft-irq lock-inversion/123:  ok  |  ok  |  ok  |
[    0.000000]       hard-irq lock-inversion/132:  ok  |  ok  |  ok  |
[    0.000000]       soft-irq lock-inversion/132:  ok  |  ok  |  ok  |
[    0.000000]       hard-irq lock-inversion/213:  ok  |  ok  |  ok  |
[    0.000000]       soft-irq lock-inversion/213:  ok  |  ok  |  ok  |
[    0.000000]       hard-irq lock-inversion/231:  ok  |  ok  |  ok  |
[    0.000000]       soft-irq lock-inversion/231:  ok  |  ok  |  ok  |
[    0.000000]       hard-irq lock-inversion/312:  ok  |  ok  |  ok  |
[    0.000000]       soft-irq lock-inversion/312:  ok  |  ok  |  ok  |
[    0.000000]       hard-irq lock-inversion/321:  ok  |  ok  |  ok  |
[    0.000000]       soft-irq lock-inversion/321:  ok  |  ok  |  ok  |
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
[    0.000000]                ww contexts mixing:  ok  |  ok  |
[    0.000000]              finishing ww context:  ok  |  ok  |  ok  |  ok =
 |
[    0.000000]                locking mismatches:  ok  |  ok  |  ok  |
[    0.000000]                  EDEADLK handling:  ok  |  ok  |  ok  |  ok =
 |  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |
[    0.000000]            spinlock nest unlocked:  ok  |
[    0.000000]   -----------------------------------------------------
[    0.000000]                                  |block | try  |context|
[    0.000000]   -----------------------------------------------------
[    0.000000]                           context:  ok  |  ok  |  ok  |
[    0.000000]                               try:  ok  |  ok  |  ok  |
[    0.000000]                             block:  ok  |  ok  |  ok  |
[    0.000000]                          spinlock:  ok  |  ok  |  ok  |
[    0.000000] -------------------------------------------------------
[    0.000000] Good, all 253 testcases passed! |
[    0.000000] ---------------------------------
[    0.000000] hpet clockevent registered
[    0.000000] tsc: Detected 2300.194 MHz processor
[    0.030000] Calibrating delay loop (skipped) preset value.. 4600.38 Bogo=
MIPS (lpj=3D23001940)
[    0.030000] pid_max: default: 4096 minimum: 301
[    0.030540] Security Framework initialized
[    0.040183] Mount-cache hash table entries: 256
[    0.052263] Initializing cgroup subsys devices
[    0.060212] Initializing cgroup subsys freezer
[    0.064179] Initializing cgroup subsys perf_event
[    0.070695] mce: CPU supports 10 MCE banks
[    0.080374] Last level iTLB entries: 4KB 0, 2MB 0, 4MB 0
[    0.080374] Last level dTLB entries: 4KB 0, 2MB 0, 4MB 0, 1GB 0
[    0.080374] tlb_flushall_shift: 6
[    0.090871] Freeing SMP alternatives memory: 16K (ffffffff81c31000 - fff=
fffff81c35000)
[    0.129001] ACPI: Core revision 20131218
[    0.135474] ACPI: All ACPI Tables successfully acquired
[    0.150604] Getting VERSION: 50014
[    0.154996] Getting VERSION: 50014
[    0.158943] Getting ID: 0
[    0.160245] Getting ID: ff000000
[    0.164270] Getting LVT0: 8700
[    0.167538] Getting LVT1: 8400
[    0.170759] enabled ExtINT on CPU#0
[    0.186007] ENABLING IO-APIC IRQs
[    0.190092] init IO_APIC IRQs
[    0.194240]  apic 0 pin 0 not connected
[    0.198852] IOAPIC[0]: Set routing entry (0-1 -> 0x31 -> IRQ 1 Mode:0 Ac=
tive:0 Dest:1)
[    0.200368] IOAPIC[0]: Set routing entry (0-2 -> 0x30 -> IRQ 0 Mode:0 Ac=
tive:0 Dest:1)
[    0.210191] IOAPIC[0]: Set routing entry (0-3 -> 0x33 -> IRQ 3 Mode:0 Ac=
tive:0 Dest:1)
[    0.220156] IOAPIC[0]: Set routing entry (0-4 -> 0x34 -> IRQ 4 Mode:0 Ac=
tive:0 Dest:1)
[    0.230213] IOAPIC[0]: Set routing entry (0-5 -> 0x35 -> IRQ 5 Mode:1 Ac=
tive:0 Dest:1)
[    0.240127] IOAPIC[0]: Set routing entry (0-6 -> 0x36 -> IRQ 6 Mode:0 Ac=
tive:0 Dest:1)
[    0.250233] IOAPIC[0]: Set routing entry (0-7 -> 0x37 -> IRQ 7 Mode:0 Ac=
tive:0 Dest:1)
[    0.260216] IOAPIC[0]: Set routing entry (0-8 -> 0x38 -> IRQ 8 Mode:0 Ac=
tive:0 Dest:1)
[    0.270098] IOAPIC[0]: Set routing entry (0-9 -> 0x39 -> IRQ 9 Mode:1 Ac=
tive:0 Dest:1)
[    0.280221] IOAPIC[0]: Set routing entry (0-10 -> 0x3a -> IRQ 10 Mode:1 =
Active:0 Dest:1)
[    0.290151] IOAPIC[0]: Set routing entry (0-11 -> 0x3b -> IRQ 11 Mode:1 =
Active:0 Dest:1)
[    0.300200] IOAPIC[0]: Set routing entry (0-12 -> 0x3c -> IRQ 12 Mode:0 =
Active:0 Dest:1)
[    0.310229] IOAPIC[0]: Set routing entry (0-13 -> 0x3d -> IRQ 13 Mode:0 =
Active:0 Dest:1)
[    0.320160] IOAPIC[0]: Set routing entry (0-14 -> 0x3e -> IRQ 14 Mode:0 =
Active:0 Dest:1)
[    0.330287] IOAPIC[0]: Set routing entry (0-15 -> 0x3f -> IRQ 15 Mode:0 =
Active:0 Dest:1)
[    0.340187]  apic 0 pin 16 not connected
[    0.345373]  apic 0 pin 17 not connected
[    0.350026]  apic 0 pin 18 not connected
[    0.355351]  apic 0 pin 19 not connected
[    0.360068]  apic 0 pin 20 not connected
[    0.366059]  apic 0 pin 21 not connected
[    0.370038]  apic 0 pin 22 not connected
[    0.376103]  apic 0 pin 23 not connected
[    0.380341] ..TIMER: vector=3D0x30 apic1=3D0 pin1=3D2 apic2=3D-1 pin2=3D=
-1
[    0.390023] smpboot: CPU0: Intel Common KVM processor (fam: 0f, model: 0=
6, stepping: 01)
[    0.413032] Using local APIC timer interrupts.
[    0.413032] calibrating APIC timer ...
[    0.430000] ... lapic delta =3D 6248288
[    0.430000] ... PM-Timer delta =3D 357710
[    0.430000] ... PM-Timer result ok
[    0.430000] ..... delta 6248288
[    0.430000] ..... mult: 268361926
[    0.430000] ..... calibration result: 9997260
[    0.430000] ..... CPU clock speed is 2298.2482 MHz.
[    0.430000] ..... host bus clock speed is 999.7260 MHz.
[    0.430811] Performance Events: unsupported Netburst CPU model 6 no PMU =
driver, software events only.
[    0.451890] x86: Booting SMP configuration:
[    0.457142] .... node  #0, CPUs:      #1
[    0.030000] kvm-clock: cpu 1, msr 0:fc66041, secondary cpu clock
[    0.030000] masked ExtINT on CPU#1
[    0.490940] x86: Booted up 1 node, 2 CPUs
[    0.500044] smpboot: Total of 2 processors activated (9200.77 BogoMIPS)
[    0.500065] KVM setup async PF for cpu 1
[    0.500094] kvm-stealtime: cpu 1, msr fb0cf40
[    0.521660] devtmpfs: initialized
[    0.541189] prandom: seed boundary self test passed
[    0.547072] prandom: 100 self tests passed
[    0.550074] atomic64 test passed for x86-64 platform with CX8 and with S=
SE
[    0.561438] regulator-dummy: no parameters
[    0.565640] NET: Registered protocol family 16
[    0.572523] cpuidle: using governor ladder
[    0.575615] cpuidle: using governor menu
[    0.582233] ACPI: bus type PCI registered
[    0.587805] PCI: Using configuration type 1 for base access
[    0.623723] ACPI: Added _OSI(Module Device)
[    0.630044] ACPI: Added _OSI(Processor Device)
[    0.633489] ACPI: Added _OSI(3.0 _SCP Extensions)
[    0.640042] ACPI: Added _OSI(Processor Aggregator Device)
[    0.662945] ACPI: Interpreter enabled
[    0.666023] ACPI: (supports S0 S5)
[    0.669959] ACPI: Using IOAPIC for interrupt routing
[    0.670150] PCI: Using host bridge windows from ACPI; if necessary, use =
"pci=3Dnocrs" and report a bug
[    0.718751] ACPI: PCI Root Bridge [PCI0] (domain 0000 [bus 00-ff])
[    0.720103] acpi PNP0A03:00: _OSC: OS supports [Segments]
[    0.724019] acpi PNP0A03:00: _OSC failed (AE_NOT_FOUND); disabling ASPM
[    0.731779] PCI host bridge to bus 0000:00
[    0.736300] pci_bus 0000:00: root bus resource [bus 00-ff]
[    0.740038] pci_bus 0000:00: root bus resource [io  0x0000-0x0cf7]
[    0.745392] pci_bus 0000:00: root bus resource [io  0x0d00-0xffff]
[    0.750068] pci_bus 0000:00: root bus resource [mem 0x000a0000-0x000bfff=
f]
[    0.755660] pci_bus 0000:00: root bus resource [mem 0x80000000-0xfebffff=
f]
[    0.760593] pci 0000:00:00.0: [8086:1237] type 00 class 0x060000
[    0.773264] pci 0000:00:01.0: [8086:7000] type 00 class 0x060100
[    0.784378] pci 0000:00:01.1: [8086:7010] type 00 class 0x010180
[    0.806451] pci 0000:00:01.1: reg 0x20: [io  0xc1c0-0xc1cf]
[    0.821451] pci 0000:00:01.3: [8086:7113] type 00 class 0x068000
[    0.830190] pci 0000:00:01.3: quirk: [io  0xb000-0xb03f] claimed by PIIX=
4 ACPI
[    0.835853] pci 0000:00:01.3: quirk: [io  0xb100-0xb10f] claimed by PIIX=
4 SMB
[    0.841933] pci 0000:00:02.0: [1013:00b8] type 00 class 0x030000
[    0.863074] pci 0000:00:02.0: reg 0x10: [mem 0xfc000000-0xfdffffff pref]
[    0.880199] pci 0000:00:02.0: reg 0x14: [mem 0xfebf0000-0xfebf0fff]
[    0.923479] pci 0000:00:02.0: reg 0x30: [mem 0xfebe0000-0xfebeffff pref]
[    0.934495] pci 0000:00:03.0: [8086:100e] type 00 class 0x020000
[    0.950045] pci 0000:00:03.0: reg 0x10: [mem 0xfeba0000-0xfebbffff]
[    0.962443] pci 0000:00:03.0: reg 0x14: [io  0xc000-0xc03f]
[    0.994282] pci 0000:00:03.0: reg 0x30: [mem 0xfebc0000-0xfebdffff pref]
[    1.001964] pci 0000:00:04.0: [1af4:1001] type 00 class 0x010000
[    1.012391] pci 0000:00:04.0: reg 0x10: [io  0xc040-0xc07f]
[    1.022487] pci 0000:00:04.0: reg 0x14: [mem 0xfebf1000-0xfebf1fff]
[    1.058617] pci 0000:00:05.0: [1af4:1001] type 00 class 0x010000
[    1.070047] pci 0000:00:05.0: reg 0x10: [io  0xc080-0xc0bf]
[    1.080054] pci 0000:00:05.0: reg 0x14: [mem 0xfebf2000-0xfebf2fff]
[    1.115083] pci 0000:00:06.0: [1af4:1001] type 00 class 0x010000
[    1.124998] pci 0000:00:06.0: reg 0x10: [io  0xc0c0-0xc0ff]
[    1.135607] pci 0000:00:06.0: reg 0x14: [mem 0xfebf3000-0xfebf3fff]
[    1.172611] pci 0000:00:07.0: [1af4:1001] type 00 class 0x010000
[    1.185066] pci 0000:00:07.0: reg 0x10: [io  0xc100-0xc13f]
[    1.194447] pci 0000:00:07.0: reg 0x14: [mem 0xfebf4000-0xfebf4fff]
[    1.236413] pci 0000:00:08.0: [1af4:1001] type 00 class 0x010000
[    1.250036] pci 0000:00:08.0: reg 0x10: [io  0xc140-0xc17f]
[    1.263621] pci 0000:00:08.0: reg 0x14: [mem 0xfebf5000-0xfebf5fff]
[    1.305569] pci 0000:00:09.0: [1af4:1001] type 00 class 0x010000
[    1.320052] pci 0000:00:09.0: reg 0x10: [io  0xc180-0xc1bf]
[    1.332598] pci 0000:00:09.0: reg 0x14: [mem 0xfebf6000-0xfebf6fff]
[    1.372685] pci 0000:00:0a.0: [8086:25ab] type 00 class 0x088000
[    1.381405] pci 0000:00:0a.0: reg 0x10: [mem 0xfebf7000-0xfebf700f]
[    1.410424] pci_bus 0000:00: on NUMA node 0
[    1.420507] ACPI: PCI Interrupt Link [LNKA] (IRQs 5 *10 11)
[    1.427389] ACPI: PCI Interrupt Link [LNKB] (IRQs 5 *10 11)
[    1.432186] ACPI: PCI Interrupt Link [LNKC] (IRQs 5 10 *11)
[    1.444230] ACPI: PCI Interrupt Link [LNKD] (IRQs 5 10 *11)
[    1.452483] ACPI: PCI Interrupt Link [LNKS] (IRQs *9)
[    1.467726] ACPI: Enabled 16 GPEs in block 00 to 0F
[    1.483972] vgaarb: device added: PCI:0000:00:02.0,decodes=3Dio+mem,owns=
=3Dio+mem,locks=3Dnone
[    1.488262] vgaarb: loaded
[    1.490060] vgaarb: bridge control possible 0000:00:02.0
[    1.497595] ACPI: bus type USB registered
[    1.500604] usbcore: registered new interface driver usbfs
[    1.505979] usbcore: registered new interface driver hub
[    1.511825] usbcore: registered new device driver usb
[    1.520541] Linux video capture interface: v2.00
[    1.540985] pps_core: LinuxPPS API ver. 1 registered
[    1.550069] pps_core: Software ver. 5.3.6 - Copyright 2005-2007 Rodolfo =
Giometti <giometti@linux.it>
[    1.580261] PTP clock support registered
[    1.591622] Advanced Linux Sound Architecture Driver Initialized.
[    1.597760] PCI: Using ACPI for IRQ routing
[    1.600058] PCI: pci_cache_line_size set to 64 bytes
[    1.610053] e820: reserve RAM buffer [mem 0x0009fc00-0x0009ffff]
[    1.620125] e820: reserve RAM buffer [mem 0x0fffe000-0x0fffffff]
[    1.632530] Switched to clocksource kvm-clock
[    1.638332] FS-Cache: Loaded
[    1.642705] pnp: PnP ACPI init
[    1.646911] ACPI: bus type PNP registered
[    1.652680] IOAPIC[0]: Set routing entry (0-8 -> 0x38 -> IRQ 8 Mode:0 Ac=
tive:0 Dest:3)
[    1.662576] pnp 00:00: Plug and Play ACPI device, IDs PNP0b00 (active)
[    1.670279] IOAPIC[0]: Set routing entry (0-1 -> 0x31 -> IRQ 1 Mode:0 Ac=
tive:0 Dest:3)
[    1.681940] pnp 00:01: Plug and Play ACPI device, IDs PNP0303 (active)
[    1.690002] IOAPIC[0]: Set routing entry (0-12 -> 0x3c -> IRQ 12 Mode:0 =
Active:0 Dest:3)
[    1.699974] pnp 00:02: Plug and Play ACPI device, IDs PNP0f13 (active)
[    1.708815] IOAPIC[0]: Set routing entry (0-6 -> 0x36 -> IRQ 6 Mode:0 Ac=
tive:0 Dest:3)
[    1.718258] pnp 00:03: [dma 2]
[    1.722625] pnp 00:03: Plug and Play ACPI device, IDs PNP0700 (active)
[    1.730174] IOAPIC[0]: Set routing entry (0-7 -> 0x37 -> IRQ 7 Mode:0 Ac=
tive:0 Dest:3)
[    1.740164] pnp 00:04: Plug and Play ACPI device, IDs PNP0400 (active)
[    1.748685] IOAPIC[0]: Set routing entry (0-4 -> 0x34 -> IRQ 4 Mode:0 Ac=
tive:0 Dest:3)
[    1.758405] pnp 00:05: Plug and Play ACPI device, IDs PNP0501 (active)
[    1.768421] pnp 00:06: Plug and Play ACPI device, IDs PNP0103 (active)
[    1.777390] pnp: PnP ACPI: found 7 devices
[    1.782527] ACPI: bus type PNP unregistered
[    1.802427] pci_bus 0000:00: resource 4 [io  0x0000-0x0cf7]
[    1.808329] pci_bus 0000:00: resource 5 [io  0x0d00-0xffff]
[    1.814665] pci_bus 0000:00: resource 6 [mem 0x000a0000-0x000bffff]
[    1.822155] pci_bus 0000:00: resource 7 [mem 0x80000000-0xfebfffff]
[    1.829776] NET: Registered protocol family 1
[    1.836257] pci 0000:00:00.0: Limiting direct PCI/PCI transfers
[    1.843722] pci 0000:00:01.0: PIIX3: Enabling Passive Release
[    1.851929] pci 0000:00:01.0: Activating ISA DMA hang workarounds
[    1.859547] pci 0000:00:02.0: Boot video device
[    1.866903] PCI: CLS 0 bytes, default 64
[    1.874564] Unpacking initramfs...
[    2.431621] Freeing initrd memory: 3112K (ffff88000fce6000 - ffff88000ff=
f0000)
[    2.442988] camellia-x86_64: performance on this CPU would be suboptimal=
: disabling camellia-x86_64.
[    2.449691] blowfish-x86_64: performance on this CPU would be suboptimal=
: disabling blowfish-x86_64.
[    2.459252] twofish-x86_64-3way: performance on this CPU would be subopt=
imal: disabling twofish-x86_64-3way.
[    2.475290] sha1_ssse3: Neither AVX nor SSSE3 is available/usable.
[    2.480260] AVX or AES-NI instructions are not detected.
[    2.483983] AVX instructions are not detected.
[    2.487480] AVX instructions are not detected.
[    2.490854] AVX2 or AES-NI instructions are not detected.
[    2.494819] AVX2 instructions are not detected.
[    2.524223] jffs2: version 2.2.=20
[    2.531183] ROMFS MTD (C) 2007 Red Hat, Inc.
[    2.537287] fuse init (API version 7.22)
[    2.600976] list_sort_test: start testing list_sort()
[    2.606809] crc32: CRC_LE_BITS =3D 32, CRC_BE BITS =3D 32
[    2.610870] crc32: self tests passed, processed 225944 bytes in 308918 n=
sec
[    2.617589] crc32c: CRC_LE_BITS =3D 32
[    2.620110] crc32c: self tests passed, processed 225944 bytes in 163487 =
nsec
[    2.912061] crc32_combine: 8373 self tests passed
[    3.231761] crc32c_combine: 8373 self tests passed
[    3.237976] rbtree testing -> 22083 cycles
[    4.277213] augmented rbtree testing -> 25523 cycles
[    5.494218] no IO addresses supplied
[    5.497981] usbcore: registered new interface driver udlfb
[    5.503687] usbcore: registered new interface driver smscufx
[    5.510215] input: Power Button as /devices/LNXSYSTM:00/LNXPWRBN:00/inpu=
t/input0
[    5.517076] ACPI: Power Button [PWRF]
[    6.092912] Serial: 8250/16550 driver, 4 ports, IRQ sharing disabled
[    6.141464] 00:05: ttyS0 at I/O 0x3f8 (irq =3D 4, base_baud =3D 115200) =
is a 16550A
[    6.160182] Non-volatile memory driver v1.3
[    6.164141] Hangcheck: starting hangcheck timer 0.9.1 (tick is 180 secon=
ds, margin is 60 seconds).
[    6.173400] Hangcheck: Using getrawmonotonic().
[    6.182142] Silicon Labs C2 port support v. 0.51.0 - (C) 2007 Rodolfo Gi=
ometti
[    6.191175] c2port c2port0: C2 port uc added
[    6.195009] c2port c2port0: uc flash has 30 blocks x 512 bytes (15360 by=
tes total)
[    6.203360] mic_init not running on X100 ret -19
[    6.210185] usbcore: registered new interface driver viperboard
[    6.220949] mtdoops: mtd device (mtddev=3Dname/number) must be supplied
[    6.226167] L440GX flash mapping: failed to find PIIX4 ISA bridge, canno=
t continue
[    6.234261] SBC-GXx flash: IO:0x258-0x259 MEM:0xdc000-0xdffff
[    6.243685] slram: not enough parameters.
[    6.247922] HSI/SSI char device loaded
[    6.252313] ehci_hcd: USB 2.0 'Enhanced' Host Controller (EHCI) Driver
[    6.259595] ehci-pci: EHCI PCI platform driver
[    6.263764] ehci-platform: EHCI generic platform driver
[    6.270801] fusbh200_hcd: FUSBH200 Host Controller (EHCI) Driver
[    6.277026] usbcore: registered new interface driver usbtmc
[    6.284743] usbcore: registered new interface driver adutux
[    6.291968] usbcore: registered new interface driver appledisplay
[    6.296878] usbcore: registered new interface driver cypress_cy7c63
[    6.303662] usbcore: registered new interface driver cytherm
[    6.310221] usbcore: registered new interface driver emi26 - firmware lo=
ader
[    6.317149] usbcore: registered new interface driver emi62 - firmware lo=
ader
[    6.325352] usbcore: registered new interface driver idmouse
[    6.330360] usbcore: registered new interface driver ldusb
[    6.335934] usbcore: registered new interface driver usbled
[    6.343341] usbcore: registered new interface driver legousbtower
[    6.348930] usbcore: registered new interface driver trancevibrator
[    6.355505] usbcore: registered new interface driver sisusb
[    6.365929] dummy_hcd dummy_hcd.0: USB Host+Gadget Emulator, driver 02 M=
ay 2005
[    6.373572] unable to find transceiver
[    6.376040] dummy_hcd dummy_hcd.0: Dummy host controller
[    6.381433] dummy_hcd dummy_hcd.0: new USB bus registered, assigned bus =
number 1
[    6.389907] usb usb1: New USB device found, idVendor=3D1d6b, idProduct=
=3D0002
[    6.396457] usb usb1: New USB device strings: Mfr=3D3, Product=3D2, Seri=
alNumber=3D1
[    6.402777] usb usb1: Product: Dummy host controller
[    6.407868] usb usb1: Manufacturer: Linux 3.13.0-rc7-next-20140110-08732=
-g1955a14 dummy_hcd
[    6.415327] usb usb1: SerialNumber: dummy_hcd.0
[    6.423875] hub 1-0:1.0: USB hub found
[    6.428522] hub 1-0:1.0: 1 port detected
[    6.440036] i8042: PNP: PS/2 Controller [PNP0303:KBD,PNP0f13:MOU] at 0x6=
0,0x64 irq 1,12
[    6.454169] serio: i8042 KBD port at 0x60,0x64 irq 1
[    6.459384] serio: i8042 AUX port at 0x60,0x64 irq 12
[    6.892925] mousedev: PS/2 mouse device common for all mice
[    6.909119] usbcore: registered new interface driver iforce
[    6.927775] input: AT Translated Set 2 keyboard as /devices/platform/i80=
42/serio0/input/input1
[    6.947133] usbcore: registered new interface driver xpad
[    6.959027] i2c /dev entries driver
[    6.974116] i2c-parport-light: adapter type unspecified
[    6.986196] usbcore: registered new interface driver i2c-tiny-usb
[    6.998814] lirc_dev: IR Remote Control driver registered, major 251=20
[    7.007913] IR JVC protocol handler initialized
[    7.012064] IR Sony protocol handler initialized
[    7.016679] IR RC5 (streamzap) protocol handler initialized
[    7.022303] IR SANYO protocol handler initialized
[    7.026385] IR MCE Keyboard/mouse protocol handler initialized
[    7.032767] usbcore: registered new interface driver ati_remote
[    7.038486] usbcore: registered new interface driver imon
[    7.043478] usbcore: registered new interface driver mceusb
[    7.049413] usbcore: registered new interface driver streamzap
[    7.055069] Registered IR keymap rc-empty
[    7.059559] input: rc-core loopback device as /devices/virtual/rc/rc0/in=
put3
[    7.067232] rc0: rc-core loopback device as /devices/virtual/rc/rc0
[    7.076320] input: MCE IR Keyboard/Mouse (rc-loopback) as /devices/virtu=
al/input/input4
[    7.086304] usbcore: registered new interface driver iguanair
[    7.091812] usbcore: registered new interface driver ttusbir
[    7.097987] usbcore: registered new interface driver smsusb
[    7.103914] au0828 driver loaded
[    7.106669] usbcore: registered new interface driver au0828
[    7.113042] usbcore: registered new interface driver tm6000
[    7.119335] usbcore: registered new interface driver em28xx
[    7.125632] Em28xx: Initialized (Em28xx Audio Extension) extension
[    7.130992] Em28xx: Initialized (Em28xx dvb Extension) extension
[    7.136508] smssdio: Siano SMS1xxx SDIO driver
[    7.140222] smssdio: Copyright Pierre Ossman
[    7.145370] usbcore: registered new interface driver radioshark2
[    7.151859] usbcore: registered new interface driver radio-si470x
[    7.158454] usbcore: registered new interface driver radio-mr800
[    7.163752] usbcore: registered new interface driver radio-ma901
[    7.171688] pps pps0: new PPS source ktimer
[    7.176004] pps pps0: ktimer PPS source registered
[    7.180475] Driver for 1-wire Dallas network protocol.
[    7.186276] usbcore: registered new interface driver DS9490R
[    7.192289] DS1WM w1 busmaster driver - (c) 2004 Szabolcs Gyurko
[    7.198747] 1-Wire driver for the DS2760 battery monitor  chip  - (c) 20=
04-2005, Szabolcs Gyurko
[    7.216344] applesmc: supported laptop not found!
[    7.221207] applesmc: driver init failed (ret=3D-19)!
[    7.227857] f71882fg: Not a Fintek device
[    7.231847] f71882fg: Not a Fintek device
[    7.239815] pc87360: PC8736x not detected, module not inserted
[    7.250277] sdhci: Secure Digital Host Controller Interface driver
[    7.257105] sdhci: Copyright(c) Pierre Ossman
[    7.261023] wbsd: Winbond W83L51xD SD/MMC card interface driver
[    7.266881] wbsd: Copyright(c) Pierre Ossman
[    7.270837] usbcore: registered new interface driver ushc
[    7.276225] sdhci-pltfm: SDHCI platform and OF driver helper
[    7.286194] dcdbas dcdbas: Dell Systems Management Base Driver (version =
5.6.0-3.2)
[    7.301003] usbcore: registered new interface driver usbhid
[    7.306684] usbhid: USB HID core driver
[    7.310183] usbcore: registered new interface driver Abilis Systems as10=
x usb driver
[    7.318879] I2C driver for BCM2048 FM Radio Receiver
[    7.323691] usbcore: registered new interface driver go7007-loader
[    7.329096] usbcore: registered new interface driver sdr_msi3101
[    7.355261] logger: created 256K log 'log_main'
[    7.361209] logger: created 256K log 'log_events'
[    7.367213] logger: created 256K log 'log_radio'
[    7.372407] logger: created 256K log 'log_system'
[    7.377133] usbcore: registered new interface driver cedusb
[    7.382997] hdaps: supported laptop not found!
[    7.387188] hdaps: driver init failed (ret=3D-19)!
[    7.398320] Audio Excel DSP 16 init driver Copyright (C) Riccardo Facche=
tti 1995-98
[    7.405259] aedsp16: I/O, IRQ and DMA are mandatory
[    7.409328] pss: mss_io, mss_dma, mss_irq and pss_io must be set.
[    7.414729] ad1848/cs4248 codec driver Copyright (C) by Hannu Savolainen=
 1993-1996
[    7.421284] ad1848: No ISAPnP cards found, trying standard ones...
[    7.426709] MediaTrix audio driver Copyright (C) by Hannu Savolainen 199=
3-1996
[    7.433038] I/O, IRQ, DMA and type are mandatory
[    7.436507] Pro Audio Spectrum driver Copyright (C) by Hannu Savolainen =
1993-1996
[    7.443126] I/O, IRQ, DMA and type are mandatory
[    7.447202] sb: Init: Starting Probe...
[    7.453114] sb: Init: Done
[    7.455573] uart6850: irq and io must be set.
[    7.459275] YM3812 and OPL-3 driver Copyright (C) by Hannu Savolainen, R=
ob Hooft 1993-1996
[    7.467236] MIDI Loopback device driver
[    7.510074] Motu MidiTimePiece on parallel port irq: 7 ioport: 0x378
[    7.519909]=20
[    7.519909] printing PIC contents
[    7.544645] ... PIC  IMR: ffff
[    7.547302] ... PIC  IRR: 1013
[    7.549753] ... PIC  ISR: 0000
[    7.552525] ... PIC ELCR: 0c00
[    7.555225] printing local APIC contents on CPU#0/0:
[    7.559274] ... APIC ID:      00000000 (0)
[    7.562416] ... APIC VERSION: 00050014
[    7.562416] ... APIC TASKPRI: 00000000 (00)
[    7.562416] ... APIC PROCPRI: 00000000
[    7.562416] ... APIC LDR: 01000000
[    7.562416] ... APIC DFR: ffffffff
[    7.562416] ... APIC SPIV: 000001ff
[    7.562416] ... APIC ISR field:
[    7.562416] 000000000000000000000000000000000000000000000000000000000000=
0000
[    7.562416] ... APIC TMR field:
[    7.562416] 000000000200000000000000000000000000000000000000000000000000=
0000
[    7.562416] ... APIC IRR field:
[    7.562416] 000000000000000000000000000000000000000000000000000000000000=
8000
[    7.562416] ... APIC ESR: 00000000
[    7.562416] ... APIC ICR: 000008fd
[    7.562416] ... APIC ICR2: 02000000
[    7.562416] ... APIC LVTT: 000200ef
[    7.562416] ... APIC LVTPC: 00010000
[    7.562416] ... APIC LVT0: 00010700
[    7.562416] ... APIC LVT1: 00000400
[    7.562416] ... APIC LVTERR: 000000fe
[    7.562416] ... APIC TMICT: 000988bc
[    7.562416] ... APIC TMCCT: 000788e6
[    7.562416] ... APIC TDCR: 00000003
[    7.562416]=20
[    7.640281] number of MP IRQ sources: 15.
[    7.643669] number of IO-APIC #0 registers: 24.
[    7.647653] testing the IO APIC.......................
[    7.652049] IO APIC #0......
[    7.654415] .... register #00: 00000000
[    7.657476] .......    : physical APIC id: 00
[    7.661262] .......    : Delivery Type: 0
[    7.664465] .......    : LTS          : 0
[    7.667639] .... register #01: 00170011
[    7.670964] .......     : max redirection entries: 17
[    7.674889] .......     : PRQ implemented: 0
[    7.678668] .......     : IO APIC version: 11
[    7.682304] .... register #02: 00000000
[    7.685729] .......     : arbitration: 00
[    7.688808] .... IRQ redirection table:
[    7.691699] 1    0    0   0   0    0    0    00
[    7.695018] 0    0    0   0   0    1    1    31
[    7.698321] 0    0    0   0   0    1    1    30
[    7.701813] 0    0    0   0   0    1    1    33
[    7.705139] 1    0    0   0   0    1    1    34
[    7.708790] 1    1    0   0   0    1    1    35
[    7.712273] 0    0    0   0   0    1    1    36
[    7.715853] 0    0    0   0   0    1    1    37
[    7.719312] 0    0    0   0   0    1    1    38
[    7.722711] 0    1    0   0   0    1    1    39
[    7.726503] 1    1    0   0   0    1    1    3A
[    7.730049] 1    1    0   0   0    1    1    3B
[    7.733415] 0    0    0   0   0    1    1    3C
[    7.736877] 0    0    0   0   0    1    1    3D
[    7.740677] 0    0    0   0   0    1    1    3E
[    7.743966] 0    0    0   0   0    1    1    3F
[    7.747293] 1    0    0   0   0    0    0    00
[    7.750540] 1    0    0   0   0    0    0    00
[    7.754027] 1    0    0   0   0    0    0    00
[    7.757343] 1    0    0   0   0    0    0    00
[    7.761015] 1    0    0   0   0    0    0    00
[    7.764353] 1    0    0   0   0    0    0    00
[    7.767553] 1    0    0   0   0    0    0    00
[    7.770983] 1    0    0   0   0    0    0    00
[    7.774160] IRQ to pin mappings:
[    7.776708] IRQ0 -> 0:2
[    7.779222] IRQ1 -> 0:1
[    7.781562] IRQ3 -> 0:3
[    7.783829] IRQ4 -> 0:4
[    7.788187] IRQ5 -> 0:5
[    7.790334] IRQ6 -> 0:6
[    7.792208] IRQ7 -> 0:7
[    7.794189] IRQ8 -> 0:8
[    7.797474] IRQ9 -> 0:9
[    7.799704] IRQ10 -> 0:10
[    7.802081] IRQ11 -> 0:11
[    7.804083] IRQ12 -> 0:12
[    7.807185] IRQ13 -> 0:13
[    7.809763] IRQ14 -> 0:14
[    7.812261] IRQ15 -> 0:15
[    7.815727] .................................... done.
[    7.822455] IMA: No TPM chip found, activating TPM-bypass!
[    7.836143] BIOS EDD facility v0.16 2004-Jun-25, 6 devices found
[    7.842535] Unregister pv shared memory for cpu 0
[    7.948328] CPU 0 is now offline
[    7.952393] ALSA device list:
[    7.955779]   #0: Loopback 1
[    7.959185]   #1: MTPAV on parallel port at 0x378
[    7.978188] Freeing unused kernel memory: 864K (ffffffff81b59000 - fffff=
fff81c31000)
[    7.987235] Write protecting the kernel read-only data: 10240k
[    8.001510] Freeing unused kernel memory: 504K (ffff880001582000 - ffff8=
80001600000)
[    8.021637] Freeing unused kernel memory: 816K (ffff880001934000 - ffff8=
80001a00000)

[    8.093354] ------------[ cut here ]------------
[    8.095469] WARNING: CPU: 1 PID: 1 at kernel/locking/lockdep.c:3537 chec=
k_flags+0x77/0x1ba()
[    8.095469] DEBUG_LOCKS_WARN_ON(current->hardirqs_enabled)
[    8.095469] CPU: 1 PID: 1 Comm: init Not tainted 3.13.0-rc7-next-2014011=
0-08732-g1955a14 #1
[    8.095469]  0000000000000000 ffff880000077c30 ffffffff8156f277 ffff8800=
00077c78
[    8.095469]  ffff880000077c68 ffffffff81091f0b ffffffff810c6bb2 00000000=
00000046
[    8.095469]  ffffffff824d27d8 ffff88000e6b8000 0000000000000246 ffff8800=
00077cc8
[    8.095469] Call Trace:
[    8.095469]  [<ffffffff8156f277>] dump_stack+0x4d/0x66
[    8.095469]  [<ffffffff81091f0b>] warn_slowpath_common+0x70/0x89
[    8.095469]  [<ffffffff810c6bb2>] ? check_flags+0x77/0x1ba
[    8.095469]  [<ffffffff81091f85>] warn_slowpath_fmt+0x47/0x49
[    8.095469]  [<ffffffff810c6bb2>] check_flags+0x77/0x1ba
[    8.095469]  [<ffffffff810ca55a>] lock_acquire+0x50/0xc4
[    8.095469]  [<ffffffff8157b9e5>] _raw_spin_lock+0x32/0x3f
[    8.095469]  [<ffffffff811f9238>] ? __percpu_counter_add+0x45/0x73
[    8.095469]  [<ffffffff811f9238>] __percpu_counter_add+0x45/0x73
[    8.095469]  [<ffffffff81120358>] __vm_enough_memory+0x24/0x12f
[    8.095469]  [<ffffffff8119f964>] cap_vm_enough_memory+0x47/0x4c
[    8.095469]  [<ffffffff8119fade>] security_vm_enough_memory_mm+0xe/0x10
[    8.095469]  [<ffffffff81090a50>] copy_process+0xb67/0x151d
[    8.095469]  [<ffffffff81091555>] do_fork+0x87/0x244
[    8.095469]  [<ffffffff81101e64>] ? context_tracking_user_exit+0x65/0x84
[    8.095469]  [<ffffffff81091778>] SyS_clone+0x11/0x13
[    8.095469]  [<ffffffff8157d119>] stub_clone+0x69/0x90
[    8.095469]  [<ffffffff8157cf66>] ? tracesys+0xd4/0xd9
[    8.095469] ---[ end trace 23660513ccff1a6d ]---
[    8.095469] possible reason: unannotated irqs-off.
[    8.095469] irq event stamp: 350223
[    8.095469] hardirqs last  enabled at (350223): [<ffffffff810c81db>] deb=
ug_check_no_locks_freed+0x12e/0x15c
[    8.095469] hardirqs last disabled at (350222): [<ffffffff810c80ec>] deb=
ug_check_no_locks_freed+0x3f/0x15c
[    8.095469] softirqs last  enabled at (349568): [<ffffffff81095cca>] __d=
o_softirq+0x1c7/0x222
[    8.095469] softirqs last disabled at (349543): [<ffffffff81096004>] irq=
_exit+0x45/0x9b
/etc/rcS.d/S00fbsetup: line 3: /sbin/modprobe: not found

Please wait: booting...
Starting udev
/etc/rcS.d/S03udev: line 72: can't create /proc/sys/kernel/hotplug: nonexis=
tent directory
Starting Bootlog daemon: bootlogd.
Configuring network interfaces... ifconfig: socket: Address family not supp=
orted by protocol
done.
hwclock: can't open '/dev/misc/rtc': No such file or directory
Running postinst /etc/rpm-postinsts/100...

wfg: skip syslogd
Kernel tests: Boot OK!
Kernel tests: Boot OK!
sed: /lib/modules/3.13.0-rc7-next-20140110-08732-g1955a14/modules.dep: No s=
uch file or directory
xargs: modprobe: No such file or directory
run-parts: /etc/kernel-tests/01-modprobe exited with code 127
/etc/kernel-tests/90-trinity: /etc/kernel-tests/90-trinity: line 18: /usr/s=
bin/chroot: not found/etc/kernel-tests/90-trinity:=20
line 17: /usr/sbin/chroot: not found
line 16: /trinity: not found
/etc/kernel-tests/90-trinity: line 15: /trinity: not found
lsmod: can't open '/proc/modules': No such file or directory
BusyBox v1.19.4 (2012-04-22 08:49:11 PDT) multi-call binary.

Usage: rmmod [-wfa] [MODULE]...

lsmod: can't open '/proc/modules': No such file or directory
BusyBox v1.19.4 (2012-04-22 08:49:11 PDT) multi-call binary.

Usage: rmmod [-wfa] [MODULE]...

lsmod: can't open '/proc/modules': No such file or directory
BusyBox v1.19.4 (2012-04-22 08:49:11 PDT) multi-call binary.

Usage: rmmod [-wfa] [MODULE]...

run-parts: /etc/kernel-tests/99-rmmod exited with code 123


wfg: skip syslogd
Deconfiguring network interfaces... ifconfig: socket: Address family not su=
pported by protocol
done.
Sending all processes the TERM signal...
Sending all processes the KILL signal...
Unmounting remote filesystems...
Deactivating swap...
Unmounting local filesystems...
Rebooting...=20
[   81.388322] Unregister pv shared memory for cpu 1
[   81.394569] reboot: Restarting system
[   81.396642] reboot: machine restart
Elapsed time: 90
qemu-system-x86_64 -cpu kvm64 -enable-kvm -kernel /kernel/x86_64-randconfig=
-s2-01111628/1955a14a5ba6e3c3b11117812d11dc550ccc37ae/vmlinuz-3.13.0-rc7-ne=
xt-20140110-08732-g1955a14 -append 'hung_task_panic=3D1 earlyprintk=3DttyS0=
,115200 debug apic=3Ddebug sysrq_always_enabled panic=3D10  prompt_ramdisk=
=3D0 console=3DttyS0,115200 console=3Dtty0 vga=3Dnormal  root=3D/dev/ram0 r=
w link=3D/kernel-tests/run-queue/kvm/x86_64-randconfig-s2-01111628/next:mas=
ter/.vmlinuz-1955a14a5ba6e3c3b11117812d11dc550ccc37ae-20140111164600-7-snb =
branch=3Dnext/master BOOT_IMAGE=3D/kernel/x86_64-randconfig-s2-01111628/195=
5a14a5ba6e3c3b11117812d11dc550ccc37ae/vmlinuz-3.13.0-rc7-next-20140110-0873=
2-g1955a14'  -initrd /kernel-tests/initrd/yocto-minimal-x86_64.cgz -m 256M =
-smp 2 -net nic,vlan=3D1,model=3De1000 -net user,vlan=3D1,hostfwd=3Dtcp::17=
176-:22 -boot order=3Dnc -no-reboot -watchdog i6300esb -rtc base=3Dlocaltim=
e -drive file=3D/fs/LABEL=3DKVM/disk0-yocto-snb-2,media=3Ddisk,if=3Dvirtio =
-drive file=3D/fs/LABEL=3DKVM/disk1-yocto-snb-2,media=3Ddisk,if=3Dvirtio -d=
rive file=3D/fs/LABEL=3DKVM/disk2-yocto-snb-2,media=3Ddisk,if=3Dvirtio -dri=
ve file=3D/fs/LABEL=3DKVM/disk3-yocto-snb-2,media=3Ddisk,if=3Dvirtio -drive=
 file=3D/fs/LABEL=3DKVM/disk4-yocto-snb-2,media=3Ddisk,if=3Dvirtio -drive f=
ile=3D/fs/LABEL=3DKVM/disk5-yocto-snb-2,media=3Ddisk,if=3Dvirtio -pidfile /=
dev/shm/kboot/pid-yocto-snb-2 -serial file:/dev/shm/kboot/serial-yocto-snb-=
2 -daemonize -display none -monitor null=20

--/9DWx/yDrRhgMJTb
Content-Type: application/octet-stream
Content-Disposition: attachment; filename="x86_64-randconfig-s2-01111628-1955a14a5ba6e3c3b11117812d11dc550ccc37ae-WARNING:-CPU:-100168.log"
Content-Transfer-Encoding: base64

Z2l0IGNoZWNrb3V0IDdkZGNkYjJjY2RjYWUwODM4YTM5YjFiZjdiMDc3M2M1NTQwZGE4NDcK
bHMgLWEgL2tlcm5lbC10ZXN0cy9ydW4tcXVldWUva3ZtL3g4Nl82NC1yYW5kY29uZmlnLXMy
LTAxMTExNjI4L25leHQ6bWFzdGVyOjdkZGNkYjJjY2RjYWUwODM4YTM5YjFiZjdiMDc3M2M1
NTQwZGE4NDc6YmlzZWN0LXVzYgoKMjAxNC0wMS0xMS0xOTo0NjoyNCA3ZGRjZGIyY2NkY2Fl
MDgzOGEzOWIxYmY3YjA3NzNjNTU0MGRhODQ3IGNvbXBpbGluZwo5MyByZWFsICA5NjcgdXNl
ciAgOTMgc3lzICAxMTMwLjY4JSBjcHUgCXg4Nl82NC1yYW5kY29uZmlnLXMyLTAxMTExNjI4
CgoyMDE0LTAxLTExLTE5OjQ4OjIzIGRldGVjdGluZyBib290IHN0YXRlIDMuMTMuMC1yYzct
MDgzMjQtZzdkZGNkYjIuCTIJMwk0CTcJMTEuCTEzCTE0CTIwIFNVQ0NFU1MKCmJpc2VjdDog
Z29vZCBjb21taXQgN2RkY2RiMmNjZGNhZTA4MzhhMzliMWJmN2IwNzczYzU1NDBkYTg0Nwpn
aXQgYmlzZWN0IHN0YXJ0IDE5NTVhMTRhNWJhNmUzYzNiMTExMTc4MTJkMTFkYzU1MGNjYzM3
YWUgN2RkY2RiMmNjZGNhZTA4MzhhMzliMWJmN2IwNzczYzU1NDBkYTg0NyAtLQovYy9rZXJu
ZWwtdGVzdHMvbGluZWFyLWJpc2VjdDogWyItYiIsICIxOTU1YTE0YTViYTZlM2MzYjExMTE3
ODEyZDExZGM1NTBjY2MzN2FlIiwgIi1nIiwgIjdkZGNkYjJjY2RjYWUwODM4YTM5YjFiZjdi
MDc3M2M1NTQwZGE4NDciLCAiL2Mva2VybmVsLXRlc3RzL2Jpc2VjdC10ZXN0LWJvb3QtZmFp
bHVyZS5zaCIsICIvaG9tZS93ZmcvdXNiL29iai1iaXNlY3QiXQpCaXNlY3Rpbmc6IDQwOCBy
ZXZpc2lvbnMgbGVmdCB0byB0ZXN0IGFmdGVyIHRoaXMgKHJvdWdobHkgOSBzdGVwcykKWzgz
NTQ4NTYzYzE1NzQwM2JhMjE5YjViZDljNTkxNDFmMTEzNzcxODJdIE1lcmdlIGJyYW5jaCAn
YWtwbS1jdXJyZW50L2N1cnJlbnQnCnJ1bm5pbmcgL2Mva2VybmVsLXRlc3RzL2Jpc2VjdC10
ZXN0LWJvb3QtZmFpbHVyZS5zaCAvaG9tZS93ZmcvdXNiL29iai1iaXNlY3QKbHMgLWEgL2tl
cm5lbC10ZXN0cy9ydW4tcXVldWUva3ZtL3g4Nl82NC1yYW5kY29uZmlnLXMyLTAxMTExNjI4
L25leHQ6bWFzdGVyOjgzNTQ4NTYzYzE1NzQwM2JhMjE5YjViZDljNTkxNDFmMTEzNzcxODI6
YmlzZWN0LXVzYgoKMjAxNC0wMS0xMS0xOTo1MzoyNCA4MzU0ODU2M2MxNTc0MDNiYTIxOWI1
YmQ5YzU5MTQxZjExMzc3MTgyIGNvbXBpbGluZwoyOTggcmVhbCAgOTc4IHVzZXIgIDk3IHN5
cyAgMzU5LjkyJSBjcHUgCXg4Nl82NC1yYW5kY29uZmlnLXMyLTAxMTExNjI4CgoyMDE0LTAx
LTExLTE5OjU5OjU1IGRldGVjdGluZyBib290IHN0YXRlIDMuMTMuMC1yYzctMDg3MTAtZzgz
NTQ4NTYuIFRFU1QgRkFJTFVSRQpbICAgIDAuNDAyNTYwXSBQQ0k6IENMUyAwIGJ5dGVzLCBk
ZWZhdWx0IDY0ClsgICAgMC40MDM3OTVdIFVucGFja2luZyBpbml0cmFtZnMuLi4KWyAgICAw
LjQ3Mjg2OF0gLS0tLS0tLS0tLS0tWyBjdXQgaGVyZSBdLS0tLS0tLS0tLS0tClsgICAgMC40
NzMxOThdIFdBUk5JTkc6IENQVTogMSBQSUQ6IDEgYXQga2VybmVsL2xvY2tpbmcvbG9ja2Rl
cC5jOjM1MzcgY2hlY2tfZmxhZ3MrMHg3Ny8weDFiYSgpClsgICAgMC40NzMxOThdIERFQlVH
X0xPQ0tTX1dBUk5fT04oY3VycmVudC0+aGFyZGlycXNfZW5hYmxlZCkKWyAgICAwLjQ3MzE5
OF0gQ1BVOiAxIFBJRDogMSBDb21tOiBzd2FwcGVyLzAgTm90IHRhaW50ZWQgMy4xMy4wLXJj
Ny0wODcxMC1nODM1NDg1NiAjMwpbICAgIDAuNDczMTk4XSAgMDAwMDAwMDAwMDAwMDAwMCBm
ZmZmODgwMDAwMDc3YTMwIGZmZmZmZmZmODE1NmZkMGQgZmZmZjg4MDAwMDA3N2E3OApbICAg
IDAuNDczMTk4XSAgZmZmZjg4MDAwMDA3N2E2OCBmZmZmZmZmZjgxMDkxZjBiIGZmZmZmZmZm
ODEwYzZiYjIgMDAwMDAwMDAwMDAwMDA0NgpbICAgIDAuNDczMTk4XSAgZmZmZmZmZmY4MWEw
NjMxOCBmZmZmODgwMDAwMDc3ZDFjIDAwMDAwMDAwMDAwMDAyODIgZmZmZjg4MDAwMDA3N2Fj
OApbICAgIDAuNDczMTk4XSBDYWxsIFRyYWNlOgpbICAgIDAuNDczMTk4XSAgWzxmZmZmZmZm
ZjgxNTZmZDBkPl0gZHVtcF9zdGFjaysweDRkLzB4NjYKWyAgICAwLjQ3MzE5OF0gIFs8ZmZm
ZmZmZmY4MTA5MWYwYj5dIHdhcm5fc2xvd3BhdGhfY29tbW9uKzB4NzAvMHg4OQpbICAgIDAu
NDczMTk4XSAgWzxmZmZmZmZmZjgxMGM2YmIyPl0gPyBjaGVja19mbGFncysweDc3LzB4MWJh
ClsgICAgMC40NzMxOThdICBbPGZmZmZmZmZmODEwOTFmODU+XSB3YXJuX3Nsb3dwYXRoX2Zt
dCsweDQ3LzB4NDkKWyAgICAwLjQ3MzE5OF0gIFs8ZmZmZmZmZmY4MTBjOWRjND5dID8gX19s
b2NrX2FjcXVpcmUrMHgxOTE5LzB4MTk1MwpbICAgIDAuNDczMTk4XSAgWzxmZmZmZmZmZjgx
MGM2YmIyPl0gY2hlY2tfZmxhZ3MrMHg3Ny8weDFiYQpbICAgIDAuNDczMTk4XSAgWzxmZmZm
ZmZmZjgxMGNhNTYzPl0gbG9ja19hY3F1aXJlKzB4NTAvMHhjNApbICAgIDAuNDczMTk4XSAg
WzxmZmZmZmZmZjgxNTdjNDlkPl0gX3Jhd19zcGluX2xvY2srMHgzMi8weDNmClsgICAgMC40
NzMxOThdICBbPGZmZmZmZmZmODExZjkzMDg+XSA/IF9fcGVyY3B1X2NvdW50ZXJfYWRkKzB4
NDUvMHg3MwpbICAgIDAuNDczMTk4XSAgWzxmZmZmZmZmZjgxMWY5MzA4Pl0gX19wZXJjcHVf
Y291bnRlcl9hZGQrMHg0NS8weDczClsgICAgMC40NzMxOThdICBbPGZmZmZmZmZmODExMzdh
Nzg+XSBnZXRfZW1wdHlfZmlscCsweDk5LzB4MTgwClsgICAgMC40NzMxOThdICBbPGZmZmZm
ZmZmODExNDIwYzY+XSBwYXRoX29wZW5hdCsweDM5LzB4NWJlClsgICAgMC40NzMxOThdICBb
PGZmZmZmZmZmODFiNmQ0ZDg+XSA/IGluaXRyZF9sb2FkKzB4M2YvMHgzZgpbICAgIDAuNDcz
MTk4XSAgWzxmZmZmZmZmZjgxMTQyNjgwPl0gZG9fZmlscF9vcGVuKzB4MzUvMHg3YQpbICAg
IDAuNDczMTk4XSAgWzxmZmZmZmZmZjgxNTdjNWIyPl0gPyBfcmF3X3NwaW5fdW5sb2NrKzB4
MjIvMHgyZApbICAgIDAuNDczMTk4XSAgWzxmZmZmZmZmZjgxMTRmNjc3Pl0gPyBfX2FsbG9j
X2ZkKzB4MWFjLzB4MWJlClsgICAgMC40NzMxOThdICBbPGZmZmZmZmZmODExMzVjNDU+XSBk
b19zeXNfb3BlbisweDE0OC8weDFkNwpbICAgIDAuNDczMTk4XSAgWzxmZmZmZmZmZjgxYjZk
NGQ4Pl0gPyBpbml0cmRfbG9hZCsweDNmLzB4M2YKWyAgICAwLjQ3MzE5OF0gIFs8ZmZmZmZm
ZmY4MTEzNWNlZD5dIFN5U19vcGVuKzB4MTkvMHgxYgpbICAgIDAuNDczMTk4XSAgWzxmZmZm
ZmZmZjgxYjZkZDJkPl0gZG9fbmFtZSsweGJiLzB4MjVlClsgICAgMC40NzMxOThdICBbPGZm
ZmZmZmZmODFiNmQ2N2Y+XSB3cml0ZV9idWZmZXIrMHgyMS8weDMwClsgICAgMC40NzMxOThd
ICBbPGZmZmZmZmZmODFiNmQ2Zjc+XSBmbHVzaF9idWZmZXIrMHg2OS8weDgxClsgICAgMC40
NzMxOThdICBbPGZmZmZmZmZmODFiODk1NDU+XSBndW56aXArMHgyNTEvMHgyZTAKWyAgICAw
LjQ3MzE5OF0gIFs8ZmZmZmZmZmY4MWI4OTJlYj5dID8gZGVjb21wcmVzc19tZXRob2QrMHg1
YS8weDVhClsgICAgMC40NzMxOThdICBbPGZmZmZmZmZmODFiNmQ2OGU+XSA/IHdyaXRlX2J1
ZmZlcisweDMwLzB4MzAKWyAgICAwLjQ3MzE5OF0gIFs8ZmZmZmZmZmY4MWI2ZDk4MT5dIHVu
cGFja190b19yb290ZnMrMHgxMmQvMHgyNTUKWyAgICAwLjQ3MzE5OF0gIFs8ZmZmZmZmZmY4
MWI2ZDRkOD5dID8gaW5pdHJkX2xvYWQrMHgzZi8weDNmClsgICAgMC40NzMxOThdICBbPGZm
ZmZmZmZmODFiNmUxNzg+XSA/IGRvX2hlYWRlcisweDEyZC8weDEyZApbICAgIDAuNDczMTk4
XSAgWzxmZmZmZmZmZjgxYjZlMWNlPl0gcG9wdWxhdGVfcm9vdGZzKzB4NTYvMHgxMDUKWyAg
ICAwLjQ3MzE5OF0gIFs8ZmZmZmZmZmY4MWI2ZTE3OD5dID8gZG9faGVhZGVyKzB4MTJkLzB4
MTJkClsgICAgMC40NzMxOThdICBbPGZmZmZmZmZmODFiNmNkNzM+XSBkb19vbmVfaW5pdGNh
bGwrMHg4ZS8weDEzOApbICAgIDAuNDczMTk4XSAgWzxmZmZmZmZmZjgxMGFiZDAwPl0gPyBw
YXJhbV9hcnJheV9zZXQrMHg2OS8weGY1ClsgICAgMC40NzMxOThdICBbPGZmZmZmZmZmODEw
YWJmNjE+XSA/IHBhcnNlX2FyZ3MrMHgxODAvMHgyNDgKWyAgICAwLjQ3MzE5OF0gIFs8ZmZm
ZmZmZmY4MWI2Y2YzOT5dIGtlcm5lbF9pbml0X2ZyZWVhYmxlKzB4MTFjLzB4MWE5ClsgICAg
MC40NzMxOThdICBbPGZmZmZmZmZmODFiNmM2YTY+XSA/IGRvX2Vhcmx5X3BhcmFtKzB4OGEv
MHg4YQpbICAgIDAuNDczMTk4XSAgWzxmZmZmZmZmZjgxNTY0MDIzPl0gPyByZXN0X2luaXQr
MHgxMzcvMHgxMzcKWyAgICAwLjQ3MzE5OF0gIFs8ZmZmZmZmZmY4MTU2NDAyYz5dIGtlcm5l
bF9pbml0KzB4OS8weGZmClsgICAgMC40NzMxOThdICBbPGZmZmZmZmZmODE1N2Q3Y2M+XSBy
ZXRfZnJvbV9mb3JrKzB4N2MvMHhiMApbICAgIDAuNDczMTk4XSAgWzxmZmZmZmZmZjgxNTY0
MDIzPl0gPyByZXN0X2luaXQrMHgxMzcvMHgxMzcKWyAgICAwLjQ3MzE5OF0gLS0tWyBlbmQg
dHJhY2UgODRlMTIxOTJkNzU0NzRhZiBdLS0tClsgICAgMC40NzMxOThdIHBvc3NpYmxlIHJl
YXNvbjogdW5hbm5vdGF0ZWQgaXJxcy1vZmYuCi9rZXJuZWwveDg2XzY0LXJhbmRjb25maWct
czItMDExMTE2MjgvODM1NDg1NjNjMTU3NDAzYmEyMTliNWJkOWM1OTE0MWYxMTM3NzE4Mi9k
bWVzZy1xdWFudGFsLXJvYW0tNjoyMDE0MDExMTIwMDAxMDp4ODZfNjQtcmFuZGNvbmZpZy1z
Mi0wMTExMTYyODozLjEzLjAtcmM3LTA4NzEwLWc4MzU0ODU2OjMKL2tlcm5lbC94ODZfNjQt
cmFuZGNvbmZpZy1zMi0wMTExMTYyOC84MzU0ODU2M2MxNTc0MDNiYTIxOWI1YmQ5YzU5MTQx
ZjExMzc3MTgyL2RtZXNnLXF1YW50YWwtc3RvYWtsZXktNjoyMDE0MDExMTIwMDAxMDp4ODZf
NjQtcmFuZGNvbmZpZy1zMi0wMTExMTYyODozLjEzLjAtcmM3LTA4NzEwLWc4MzU0ODU2OjMK
MDoyOjIgYWxsX2dvb2Q6YmFkOmFsbF9iYWQgYm9vdHMKG1sxOzM1bVJFUEVBVCBDT1VOVDog
MjAgICMgL2NjL3dmZy91c2ItYmlzZWN0Ly5yZXBlYXQbWzBtCgpsaW5lYXItYmlzZWN0OiBi
YWQgYnJhbmNoIG1heSBiZSBicmFuY2ggJ2FrcG0tY3VycmVudC9jdXJyZW50JwpsaW5lYXIt
YmlzZWN0OiBoYW5kbGUgb3ZlciB0byBnaXQgYmlzZWN0CmxpbmVhci1iaXNlY3Q6IGdpdCBi
aXNlY3Qgc3RhcnQgODM1NDg1NjNjMTU3NDAzYmEyMTliNWJkOWM1OTE0MWYxMTM3NzE4MiA3
ZGRjZGIyY2NkY2FlMDgzOGEzOWIxYmY3YjA3NzNjNTU0MGRhODQ3IC0tClByZXZpb3VzIEhF
QUQgcG9zaXRpb24gd2FzIDgzNTQ4NTYuLi4gTWVyZ2UgYnJhbmNoICdha3BtLWN1cnJlbnQv
Y3VycmVudCcKSEVBRCBpcyBub3cgYXQgNmU0NjY0NS4uLiBMaW51eCAzLjExCkJpc2VjdGlu
ZzogMTkyIHJldmlzaW9ucyBsZWZ0IHRvIHRlc3QgYWZ0ZXIgdGhpcyAocm91Z2hseSA4IHN0
ZXBzKQpbYzQ2NDUxMDhlNDA0M2RmMWE3OWU1MTBmNjE0YTE1YzFlZDQxMWEyMF0gbWVtY2cs
IHNsYWI6IGttZW1fY2FjaGVfY3JlYXRlX21lbWNnKCk6IGZpeCBtZW1sZWFrIG9uIGZhaWwg
cGF0aApsaW5lYXItYmlzZWN0OiBnaXQgYmlzZWN0IHJ1biAvYy9rZXJuZWwtdGVzdHMvYmlz
ZWN0LXRlc3QtYm9vdC1mYWlsdXJlLnNoIC9ob21lL3dmZy91c2Ivb2JqLWJpc2VjdApydW5u
aW5nIC9jL2tlcm5lbC10ZXN0cy9iaXNlY3QtdGVzdC1ib290LWZhaWx1cmUuc2ggL2hvbWUv
d2ZnL3VzYi9vYmotYmlzZWN0CmxzIC1hIC9rZXJuZWwtdGVzdHMvcnVuLXF1ZXVlL2t2bS94
ODZfNjQtcmFuZGNvbmZpZy1zMi0wMTExMTYyOC9uZXh0Om1hc3RlcjpjNDY0NTEwOGU0MDQz
ZGYxYTc5ZTUxMGY2MTRhMTVjMWVkNDExYTIwOmJpc2VjdC11c2IKCjIwMTQtMDEtMTEtMjA6
MDE6MDEgYzQ2NDUxMDhlNDA0M2RmMWE3OWU1MTBmNjE0YTE1YzFlZDQxMWEyMCBjb21waWxp
bmcKG1sxOzM1bXg4Nl82NC1yYW5kY29uZmlnLXMyLTAxMTExNjI4OiBtYWtlIHByZXBhcmUg
ZmFpbGVkG1swbQoyMDE0LTAxLTExLTIwOjA5OjUyIGM0NjQ1MTA4ZTQwNDNkZjFhNzllNTEw
ZjYxNGExNWMxZWQ0MTFhMjAgU0tJUCBCUk9LRU4gQlVJTEQKQ2hlY2sgZXJyb3MgaW4gL2Nj
L3dmZy91c2ItYmlzZWN0IGFuZCAvdG1wL2tlcm5lbC94ODZfNjQtcmFuZGNvbmZpZy1zMi0w
MTExMTYyOC9jNDY0NTEwOGU0MDQzZGYxYTc5ZTUxMGY2MTRhMTVjMWVkNDExYTIwCkJpc2Vj
dGluZzogMTkyIHJldmlzaW9ucyBsZWZ0IHRvIHRlc3QgYWZ0ZXIgdGhpcyAocm91Z2hseSA4
IHN0ZXBzKQpbOGIwZjFjOTlmZmI4ZDhhZjBhYjY2ZDdhMTE1ZmUwODczMjI1ZWY0NV0gb2Nm
czI6IHJldHVybiBFSU5WQUwgaWYgdGhlIGdpdmVuIHJhbmdlIHRvIGRpc2NhcmQgaXMgbGVz
cyB0aGFuIGJsb2NrIHNpemUKcnVubmluZyAvYy9rZXJuZWwtdGVzdHMvYmlzZWN0LXRlc3Qt
Ym9vdC1mYWlsdXJlLnNoIC9ob21lL3dmZy91c2Ivb2JqLWJpc2VjdApscyAtYSAva2VybmVs
LXRlc3RzL3J1bi1xdWV1ZS9rdm0veDg2XzY0LXJhbmRjb25maWctczItMDExMTE2MjgvbmV4
dDptYXN0ZXI6OGIwZjFjOTlmZmI4ZDhhZjBhYjY2ZDdhMTE1ZmUwODczMjI1ZWY0NTpiaXNl
Y3QtdXNiCgoyMDE0LTAxLTExLTIwOjA5OjUzIDhiMGYxYzk5ZmZiOGQ4YWYwYWI2NmQ3YTEx
NWZlMDg3MzIyNWVmNDUgY29tcGlsaW5nCjQ1MCByZWFsICA5NjQgdXNlciAgOTUgc3lzICAy
MzUuNTYlIGNwdSAJeDg2XzY0LXJhbmRjb25maWctczItMDExMTE2MjgKCjIwMTQtMDEtMTEt
MjA6MTc6NTIgZGV0ZWN0aW5nIGJvb3Qgc3RhdGUgMy4xMy4wLXJjNy0wMDExOC1nOGIwZjFj
OQkzCTQJOS4JMTEJMTYJMTguLgkxOS4JMjAgU1VDQ0VTUwoKQmlzZWN0aW5nOiAxNjkgcmV2
aXNpb25zIGxlZnQgdG8gdGVzdCBhZnRlciB0aGlzIChyb3VnaGx5IDcgc3RlcHMpClsyMDE5
NTkxMzVmYWExMzJiZjgxN2NjZTQxNWNiODY0ZDgwYTgyMmZmXSBzd2FwOiBhZGQgYSBzaW1w
bGUgZGV0ZWN0b3IgZm9yIGluYXBwcm9wcmlhdGUgc3dhcGluIHJlYWRhaGVhZApydW5uaW5n
IC9jL2tlcm5lbC10ZXN0cy9iaXNlY3QtdGVzdC1ib290LWZhaWx1cmUuc2ggL2hvbWUvd2Zn
L3VzYi9vYmotYmlzZWN0CmxzIC1hIC9rZXJuZWwtdGVzdHMvcnVuLXF1ZXVlL2t2bS94ODZf
NjQtcmFuZGNvbmZpZy1zMi0wMTExMTYyOC9uZXh0Om1hc3RlcjoyMDE5NTkxMzVmYWExMzJi
ZjgxN2NjZTQxNWNiODY0ZDgwYTgyMmZmOmJpc2VjdC11c2IKCjIwMTQtMDEtMTEtMjA6MjQ6
MDMgMjAxOTU5MTM1ZmFhMTMyYmY4MTdjY2U0MTVjYjg2NGQ4MGE4MjJmZiBjb21waWxpbmcK
NTY1IHJlYWwgIDk1MyB1c2VyICA5NCBzeXMgIDE4NS41NSUgY3B1IAl4ODZfNjQtcmFuZGNv
bmZpZy1zMi0wMTExMTYyOAoKMjAxNC0wMS0xMS0yMDo0MToxMCBkZXRlY3RpbmcgYm9vdCBz
dGF0ZSAzLjEzLjAtcmM3LTAwMjg4LWcyMDE5NTkxLi4JMi4JNS4JNgk5CTEwCTE0LgkxOQky
MCBTVUNDRVNTCgpCaXNlY3Rpbmc6IDg0IHJldmlzaW9ucyBsZWZ0IHRvIHRlc3QgYWZ0ZXIg
dGhpcyAocm91Z2hseSA2IHN0ZXBzKQpbZDRjMDM5OTk5NDMxNGNhMDNjZTEzMTNjNDk1MmFh
Mzg1YjkzNTVhYV0gZHJpdmVycy9ydGMvcnRjLW14Yy5jOiByZW1vdmUgdW5uZWVkZWQgbGFi
ZWwKcnVubmluZyAvYy9rZXJuZWwtdGVzdHMvYmlzZWN0LXRlc3QtYm9vdC1mYWlsdXJlLnNo
IC9ob21lL3dmZy91c2Ivb2JqLWJpc2VjdApscyAtYSAva2VybmVsLXRlc3RzL3J1bi1xdWV1
ZS9rdm0veDg2XzY0LXJhbmRjb25maWctczItMDExMTE2MjgvbmV4dDptYXN0ZXI6ZDRjMDM5
OTk5NDMxNGNhMDNjZTEzMTNjNDk1MmFhMzg1YjkzNTVhYTpiaXNlY3QtdXNiCgoyMDE0LTAx
LTExLTIwOjQ3OjUwIGQ0YzAzOTk5OTQzMTRjYTAzY2UxMzEzYzQ5NTJhYTM4NWI5MzU1YWEg
Y29tcGlsaW5nCjEyMSByZWFsICA5NTYgdXNlciAgOTUgc3lzICA4NjIuNjclIGNwdSAJeDg2
XzY0LXJhbmRjb25maWctczItMDExMTE2MjgKCjIwMTQtMDEtMTEtMjA6NTM6NDggZGV0ZWN0
aW5nIGJvb3Qgc3RhdGUgMy4xMy4wLXJjNy0wMDM3My1nZDRjMDM5OS4uLiBURVNUIEZBSUxV
UkUKWyAgICAwLjM3NzkzNl0gUENJOiBDTFMgMCBieXRlcywgZGVmYXVsdCA2NApbICAgIDAu
Mzc4OTU1XSBVbnBhY2tpbmcgaW5pdHJhbWZzLi4uClsgICAgMC40NDkyMzJdIC0tLS0tLS0t
LS0tLVsgY3V0IGhlcmUgXS0tLS0tLS0tLS0tLQpbICAgIDAuNDUwMDY3XSBXQVJOSU5HOiBD
UFU6IDAgUElEOiAxIGF0IGtlcm5lbC9sb2NraW5nL2xvY2tkZXAuYzozNTM1IGNoZWNrX2Zs
YWdzKzB4NzcvMHgxYmEoKQpbICAgIDAuNDUxNjAxXSBERUJVR19MT0NLU19XQVJOX09OKGN1
cnJlbnQtPmhhcmRpcnFzX2VuYWJsZWQpClsgICAgMC40NTI0OTRdIENQVTogMCBQSUQ6IDEg
Q29tbTogc3dhcHBlci8wIE5vdCB0YWludGVkIDMuMTMuMC1yYzctMDAzNzMtZ2Q0YzAzOTkg
IzYKWyAgICAwLjQ1Mzg2MV0gIDAwMDAwMDAwMDAwMDAwMDAgZmZmZjg4MDAwMDA3N2EzMCBm
ZmZmZmZmZjgxNTQxMjAzIGZmZmY4ODAwMDAwNzdhNzgKWyAgICAwLjQ1NTE3NV0gIGZmZmY4
ODAwMDAwNzdhNjggZmZmZmZmZmY4MTA3YWJkMCBmZmZmZmZmZjgxMGFlZDE1IDAwMDAwMDAw
MDAwMDAwNDYKWyAgICAwLjQ1NTgzOV0gIGZmZmZmZmZmODFhMDYzMTggZmZmZjg4MDAwMDA3
N2QxYyAwMDAwMDAwMDAwMDAwMjg2IGZmZmY4ODAwMDAwNzdhYzgKWyAgICAwLjQ1NTgzOV0g
Q2FsbCBUcmFjZToKWyAgICAwLjQ1NTgzOV0gIFs8ZmZmZmZmZmY4MTU0MTIwMz5dIGR1bXBf
c3RhY2srMHg0ZC8weDY2ClsgICAgMC40NTU4MzldICBbPGZmZmZmZmZmODEwN2FiZDA+XSB3
YXJuX3Nsb3dwYXRoX2NvbW1vbisweDcwLzB4ODkKWyAgICAwLjQ1NTgzOV0gIFs8ZmZmZmZm
ZmY4MTBhZWQxNT5dID8gY2hlY2tfZmxhZ3MrMHg3Ny8weDFiYQpbICAgIDAuNDU1ODM5XSAg
WzxmZmZmZmZmZjgxMDdhYzRhPl0gd2Fybl9zbG93cGF0aF9mbXQrMHg0Ny8weDQ5ClsgICAg
MC40NTU4MzldICBbPGZmZmZmZmZmODEwYWVkMTU+XSBjaGVja19mbGFncysweDc3LzB4MWJh
ClsgICAgMC40NTU4MzldICBbPGZmZmZmZmZmODEwYjI2YzY+XSBsb2NrX2FjcXVpcmUrMHg1
MC8weGM0ClsgICAgMC40NTU4MzldICBbPGZmZmZmZmZmODExMWM4YTc+XSA/IGZpbmFsX3B1
dG5hbWUrMHgyZi8weDMyClsgICAgMC40NTU4MzldICBbPGZmZmZmZmZmODE1NGQ3M2Q+XSBf
cmF3X3NwaW5fbG9jaysweDMyLzB4M2YKWyAgICAwLjQ1NTgzOV0gIFs8ZmZmZmZmZmY4MTFk
NjBkYT5dID8gX19wZXJjcHVfY291bnRlcl9hZGQrMHg0NS8weDczClsgICAgMC40NTU4Mzld
ICBbPGZmZmZmZmZmODExZDYwZGE+XSBfX3BlcmNwdV9jb3VudGVyX2FkZCsweDQ1LzB4NzMK
WyAgICAwLjQ1NTgzOV0gIFs8ZmZmZmZmZmY4MTExNWVjOT5dIGdldF9lbXB0eV9maWxwKzB4
OTkvMHgxODAKWyAgICAwLjQ1NTgzOV0gIFs8ZmZmZmZmZmY4MTEyMDU4MT5dIHBhdGhfb3Bl
bmF0KzB4MzkvMHg1YmUKWyAgICAwLjQ1NTgzOV0gIFs8ZmZmZmZmZmY4MTExODViOT5dID8g
dmZzX2ZzdGF0YXQrMHg0NC8weDkxClsgICAgMC40NTU4MzldICBbPGZmZmZmZmZmODFiNmU0
Y2U+XSA/IGluaXRyZF9sb2FkKzB4M2YvMHgzZgpbICAgIDAuNDU1ODM5XSAgWzxmZmZmZmZm
ZjgxMTIwYjNiPl0gZG9fZmlscF9vcGVuKzB4MzUvMHg3YQpbICAgIDAuNDU1ODM5XSAgWzxm
ZmZmZmZmZjgxNTRkODUyPl0gPyBfcmF3X3NwaW5fdW5sb2NrKzB4MjIvMHgyZApbICAgIDAu
NDU1ODM5XSAgWzxmZmZmZmZmZjgxMTJkYjY0Pl0gPyBfX2FsbG9jX2ZkKzB4MWE5LzB4MWJi
ClsgICAgMC40NTU4MzldICBbPGZmZmZmZmZmODExMTQwN2Y+XSBkb19zeXNfb3BlbisweDE0
OC8weDFkNwpbICAgIDAuNDU1ODM5XSAgWzxmZmZmZmZmZjgxYjZlNGNlPl0gPyBpbml0cmRf
bG9hZCsweDNmLzB4M2YKWyAgICAwLjQ1NTgzOV0gIFs8ZmZmZmZmZmY4MTExNDEyNz5dIFN5
U19vcGVuKzB4MTkvMHgxYgpbICAgIDAuNDU1ODM5XSAgWzxmZmZmZmZmZjgxYjZlZDIzPl0g
ZG9fbmFtZSsweGJiLzB4MjVlClsgICAgMC40NTU4MzldICBbPGZmZmZmZmZmODFiNmU2NzU+
XSB3cml0ZV9idWZmZXIrMHgyMS8weDMwClsgICAgMC40NTU4MzldICBbPGZmZmZmZmZmODFi
NmU2ZWQ+XSBmbHVzaF9idWZmZXIrMHg2OS8weDgxClsgICAgMC40NTU4MzldICBbPGZmZmZm
ZmZmODFiODk4NWQ+XSBndW56aXArMHgyNTEvMHgyZTAKWyAgICAwLjQ1NTgzOV0gIFs8ZmZm
ZmZmZmY4MWI4OTYwMz5dID8gZGVjb21wcmVzc19tZXRob2QrMHg1YS8weDVhClsgICAgMC40
NTU4MzldICBbPGZmZmZmZmZmODFiNmU2ODQ+XSA/IHdyaXRlX2J1ZmZlcisweDMwLzB4MzAK
WyAgICAwLjQ1NTgzOV0gIFs8ZmZmZmZmZmY4MWI2ZTk3Nz5dIHVucGFja190b19yb290ZnMr
MHgxMmQvMHgyNTUKWyAgICAwLjQ1NTgzOV0gIFs8ZmZmZmZmZmY4MWI2ZTRjZT5dID8gaW5p
dHJkX2xvYWQrMHgzZi8weDNmClsgICAgMC40NTU4MzldICBbPGZmZmZmZmZmODFiNmYxNmU+
XSA/IGRvX2hlYWRlcisweDEyZC8weDEyZApbICAgIDAuNDU1ODM5XSAgWzxmZmZmZmZmZjgx
YjZmMWM0Pl0gcG9wdWxhdGVfcm9vdGZzKzB4NTYvMHgxMDUKWyAgICAwLjQ1NTgzOV0gIFs8
ZmZmZmZmZmY4MWI2ZjE2ZT5dID8gZG9faGVhZGVyKzB4MTJkLzB4MTJkClsgICAgMC40NTU4
MzldICBbPGZmZmZmZmZmODFiNmRkNjk+XSBkb19vbmVfaW5pdGNhbGwrMHg4ZS8weDEzOApb
ICAgIDAuNDU1ODM5XSAgWzxmZmZmZmZmZjgxMDk0MDAwPl0gPyBwYXJhbWVxbisweDMzLzB4
MzYKWyAgICAwLjQ1NTgzOV0gIFs8ZmZmZmZmZmY4MTA5NDFhMj5dID8gcGFyc2VfYXJncysw
eDE4MC8weDI0OApbICAgIDAuNDU1ODM5XSAgWzxmZmZmZmZmZjgxYjZkZjJmPl0ga2VybmVs
X2luaXRfZnJlZWFibGUrMHgxMWMvMHgxYTkKWyAgICAwLjQ1NTgzOV0gIFs8ZmZmZmZmZmY4
MWI2ZDZhNj5dID8gZG9fZWFybHlfcGFyYW0rMHg4YS8weDhhClsgICAgMC40NTU4MzldICBb
PGZmZmZmZmZmODE1MzU0YzM+XSA/IHJlc3RfaW5pdCsweDEzNy8weDEzNwpbICAgIDAuNDU1
ODM5XSAgWzxmZmZmZmZmZjgxNTM1NGNjPl0ga2VybmVsX2luaXQrMHg5LzB4ZmYKWyAgICAw
LjQ1NTgzOV0gIFs8ZmZmZmZmZmY4MTU0ZWE0Yz5dIHJldF9mcm9tX2ZvcmsrMHg3Yy8weGIw
ClsgICAgMC40NTU4MzldICBbPGZmZmZmZmZmODE1MzU0YzM+XSA/IHJlc3RfaW5pdCsweDEz
Ny8weDEzNwpbICAgIDAuNDU1ODM5XSAtLS1bIGVuZCB0cmFjZSA5ZTdmZmFlZjdjYmQ1N2Zl
IF0tLS0KWyAgICAwLjQ1NTgzOV0gcG9zc2libGUgcmVhc29uOiB1bmFubm90YXRlZCBpcnFz
LW9mZi4KL2tlcm5lbC94ODZfNjQtcmFuZGNvbmZpZy1zMi0wMTExMTYyOC9kNGMwMzk5OTk0
MzE0Y2EwM2NlMTMxM2M0OTUyYWEzODViOTM1NWFhL2RtZXNnLXF1YW50YWwtYXRoZW5zLTM1
OjIwMTQwMTExMjA1NDQ1Ong4Nl82NC1yYW5kY29uZmlnLXMyLTAxMTExNjI4OjMuMTMuMC1y
YzctMDAzNzMtZ2Q0YzAzOTk6Ngova2VybmVsL3g4Nl82NC1yYW5kY29uZmlnLXMyLTAxMTEx
NjI4L2Q0YzAzOTk5OTQzMTRjYTAzY2UxMzEzYzQ5NTJhYTM4NWI5MzU1YWEvZG1lc2ctcXVh
bnRhbC1jYWlyby0zODoyMDE0MDExMTIwNTUwMTp4ODZfNjQtcmFuZGNvbmZpZy1zMi0wMTEx
MTYyODozLjEzLjAtcmM3LTAwMzczLWdkNGMwMzk5OjYKL2tlcm5lbC94ODZfNjQtcmFuZGNv
bmZpZy1zMi0wMTExMTYyOC9kNGMwMzk5OTk0MzE0Y2EwM2NlMTMxM2M0OTUyYWEzODViOTM1
NWFhL2RtZXNnLXF1YW50YWwtd2FpbWVhLTEyOjIwMTQwMTExMjA1NDU1Ong4Nl82NC1yYW5k
Y29uZmlnLXMyLTAxMTExNjI4OjMuMTMuMC1yYzctMDAzNzMtZ2Q0YzAzOTk6Ngova2VybmVs
L3g4Nl82NC1yYW5kY29uZmlnLXMyLTAxMTExNjI4L2Q0YzAzOTk5OTQzMTRjYTAzY2UxMzEz
YzQ5NTJhYTM4NWI5MzU1YWEvZG1lc2ctcXVhbnRhbC14aWFuLTI1OjIwMTQwMTExMjA1NTAw
Ong4Nl82NC1yYW5kY29uZmlnLXMyLTAxMTExNjI4OjMuMTMuMC1yYzctMDAzNzMtZ2Q0YzAz
OTk6Ngova2VybmVsL3g4Nl82NC1yYW5kY29uZmlnLXMyLTAxMTExNjI4L2Q0YzAzOTk5OTQz
MTRjYTAzY2UxMzEzYzQ5NTJhYTM4NWI5MzU1YWEvZG1lc2cteW9jdG8teGlhbi00MzoyMDE0
MDExMTIwNTQ1Nzp4ODZfNjQtcmFuZGNvbmZpZy1zMi0wMTExMTYyODozLjEzLjAtcmM3LTAw
MzczLWdkNGMwMzk5OjYKL2tlcm5lbC94ODZfNjQtcmFuZGNvbmZpZy1zMi0wMTExMTYyOC9k
NGMwMzk5OTk0MzE0Y2EwM2NlMTMxM2M0OTUyYWEzODViOTM1NWFhL2RtZXNnLXlvY3RvLXJv
YW0tMTg6MjAxNDAxMTEyMDU1MDc6eDg2XzY0LXJhbmRjb25maWctczItMDExMTE2Mjg6My4x
My4wLXJjNy0wMDM3My1nZDRjMDM5OTo2CjA6Njo2IGFsbF9nb29kOmJhZDphbGxfYmFkIGJv
b3RzChtbMTszNW1SRVBFQVQgQ09VTlQ6IDIwICAjIC9jYy93ZmcvdXNiLWJpc2VjdC8ucmVw
ZWF0G1swbQoKQmlzZWN0aW5nOiA0MSByZXZpc2lvbnMgbGVmdCB0byB0ZXN0IGFmdGVyIHRo
aXMgKHJvdWdobHkgNSBzdGVwcykKWzRlMGFmNmRkMjc3NzEyMmM1MTBiNGZlOTJlMzA2ZDk0
YzQyNjQzNzVdIGJhY2tsaWdodDogb21hcDE6IHVzZSBkZXZtX2JhY2tsaWdodF9kZXZpY2Vf
cmVnaXN0ZXIoKQpydW5uaW5nIC9jL2tlcm5lbC10ZXN0cy9iaXNlY3QtdGVzdC1ib290LWZh
aWx1cmUuc2ggL2hvbWUvd2ZnL3VzYi9vYmotYmlzZWN0CmxzIC1hIC9rZXJuZWwtdGVzdHMv
cnVuLXF1ZXVlL2t2bS94ODZfNjQtcmFuZGNvbmZpZy1zMi0wMTExMTYyOC9uZXh0Om1hc3Rl
cjo0ZTBhZjZkZDI3NzcxMjJjNTEwYjRmZTkyZTMwNmQ5NGM0MjY0Mzc1OmJpc2VjdC11c2IK
CjIwMTQtMDEtMTEtMjA6NTU6MjUgNGUwYWY2ZGQyNzc3MTIyYzUxMGI0ZmU5MmUzMDZkOTRj
NDI2NDM3NSBjb21waWxpbmcKNzEgcmVhbCAgMzcgdXNlciAgNiBzeXMgIDYxLjY0JSBjcHUg
CXg4Nl82NC1yYW5kY29uZmlnLXMyLTAxMTExNjI4CgoyMDE0LTAxLTExLTIxOjAxOjE2IGRl
dGVjdGluZyBib290IHN0YXRlIDMuMTMuMC1yYzctMDAzMzEtZzRlMGFmNmQJMQkyLgkzLi4J
Ngk3CTgJMTQJMTcJMjAgU1VDQ0VTUwoKQmlzZWN0aW5nOiAyMCByZXZpc2lvbnMgbGVmdCB0
byB0ZXN0IGFmdGVyIHRoaXMgKHJvdWdobHkgNCBzdGVwcykKWzcxYzNjMGIwZjA2NDljNzFm
YTRlZThkZDMzMzNiNzM1MWZjNzY3MDddIGNoZWNrcGF0Y2g6IHdhcm4gb25seSBvbiAic3Bh
Y2UgYmVmb3JlIHNlbWljb2xvbiIgYXQgZW5kIG9mIGxpbmUKcnVubmluZyAvYy9rZXJuZWwt
dGVzdHMvYmlzZWN0LXRlc3QtYm9vdC1mYWlsdXJlLnNoIC9ob21lL3dmZy91c2Ivb2JqLWJp
c2VjdApscyAtYSAva2VybmVsLXRlc3RzL3J1bi1xdWV1ZS9rdm0veDg2XzY0LXJhbmRjb25m
aWctczItMDExMTE2MjgvbmV4dDptYXN0ZXI6NzFjM2MwYjBmMDY0OWM3MWZhNGVlOGRkMzMz
M2I3MzUxZmM3NjcwNzpiaXNlY3QtdXNiCgoyMDE0LTAxLTExLTIxOjA3OjE5IDcxYzNjMGIw
ZjA2NDljNzFmYTRlZThkZDMzMzNiNzM1MWZjNzY3MDcgY29tcGlsaW5nCjQ0IHJlYWwgIDI5
IHVzZXIgIDUgc3lzICA3OC44MCUgY3B1IAl4ODZfNjQtcmFuZGNvbmZpZy1zMi0wMTExMTYy
OAoKMjAxNC0wMS0xMS0yMToxNToyMiBkZXRlY3RpbmcgYm9vdCBzdGF0ZSAzLjEzLjAtcmM3
LTAwMzUyLWc3MWMzYzBiLiBURVNUIEZBSUxVUkUKWyAgICAwLjMzNzgyNl0gUENJOiBDTFMg
MCBieXRlcywgZGVmYXVsdCA2NApbICAgIDAuMzM4ODExXSBVbnBhY2tpbmcgaW5pdHJhbWZz
Li4uClsgICAgMC4zOTcxODJdIC0tLS0tLS0tLS0tLVsgY3V0IGhlcmUgXS0tLS0tLS0tLS0t
LQpbICAgIDAuMzk4MDYzXSBXQVJOSU5HOiBDUFU6IDEgUElEOiAxIGF0IGtlcm5lbC9sb2Nr
aW5nL2xvY2tkZXAuYzozNTM1IGNoZWNrX2ZsYWdzKzB4NzcvMHgxYmEoKQpbICAgIDAuMzk4
MDYzXSBERUJVR19MT0NLU19XQVJOX09OKGN1cnJlbnQtPmhhcmRpcnFzX2VuYWJsZWQpClsg
ICAgMC4zOTgwNjNdIENQVTogMSBQSUQ6IDEgQ29tbTogc3dhcHBlci8wIE5vdCB0YWludGVk
IDMuMTMuMC1yYzctMDAzNTItZzcxYzNjMGIgIzgKWyAgICAwLjM5ODA2M10gIDAwMDAwMDAw
MDAwMDAwMDAgZmZmZjg4MDAwMDA3N2EzMCBmZmZmZmZmZjgxNTQwZmYyIGZmZmY4ODAwMDAw
NzdhNzgKWyAgICAwLjM5ODA2M10gIGZmZmY4ODAwMDAwNzdhNjggZmZmZmZmZmY4MTA3YWJk
MCBmZmZmZmZmZjgxMGFlZDE1IDAwMDAwMDAwMDAwMDAwNDYKWyAgICAwLjM5ODA2M10gIGZm
ZmZmZmZmODFhMDYzMTggZmZmZjg4MDAwMDA3N2QxYyAwMDAwMDAwMDAwMDAwMjgyIGZmZmY4
ODAwMDAwNzdhYzgKWyAgICAwLjM5ODA2M10gQ2FsbCBUcmFjZToKWyAgICAwLjM5ODA2M10g
IFs8ZmZmZmZmZmY4MTU0MGZmMj5dIGR1bXBfc3RhY2srMHg0ZC8weDY2ClsgICAgMC4zOTgw
NjNdICBbPGZmZmZmZmZmODEwN2FiZDA+XSB3YXJuX3Nsb3dwYXRoX2NvbW1vbisweDcwLzB4
ODkKWyAgICAwLjM5ODA2M10gIFs8ZmZmZmZmZmY4MTBhZWQxNT5dID8gY2hlY2tfZmxhZ3Mr
MHg3Ny8weDFiYQpbICAgIDAuMzk4MDYzXSAgWzxmZmZmZmZmZjgxMDdhYzRhPl0gd2Fybl9z
bG93cGF0aF9mbXQrMHg0Ny8weDQ5ClsgICAgMC4zOTgwNjNdICBbPGZmZmZmZmZmODEwYWVk
MTU+XSBjaGVja19mbGFncysweDc3LzB4MWJhClsgICAgMC4zOTgwNjNdICBbPGZmZmZmZmZm
ODEwYjI2YzY+XSBsb2NrX2FjcXVpcmUrMHg1MC8weGM0ClsgICAgMC4zOTgwNjNdICBbPGZm
ZmZmZmZmODExMWM4YTc+XSA/IGZpbmFsX3B1dG5hbWUrMHgyZi8weDMyClsgICAgMC4zOTgw
NjNdICBbPGZmZmZmZmZmODE1NGQ1MjU+XSBfcmF3X3NwaW5fbG9jaysweDMyLzB4M2YKWyAg
ICAwLjM5ODA2M10gIFs8ZmZmZmZmZmY4MTFkNWY0YT5dID8gX19wZXJjcHVfY291bnRlcl9h
ZGQrMHg0NS8weDczClsgICAgMC4zOTgwNjNdICBbPGZmZmZmZmZmODExZDVmNGE+XSBfX3Bl
cmNwdV9jb3VudGVyX2FkZCsweDQ1LzB4NzMKWyAgICAwLjM5ODA2M10gIFs8ZmZmZmZmZmY4
MTExNWVjOT5dIGdldF9lbXB0eV9maWxwKzB4OTkvMHgxODAKWyAgICAwLjM5ODA2M10gIFs8
ZmZmZmZmZmY4MTEyMDU4MT5dIHBhdGhfb3BlbmF0KzB4MzkvMHg1YmUKWyAgICAwLjM5ODA2
M10gIFs8ZmZmZmZmZmY4MTExODViOT5dID8gdmZzX2ZzdGF0YXQrMHg0NC8weDkxClsgICAg
MC4zOTgwNjNdICBbPGZmZmZmZmZmODFiNmU0Y2U+XSA/IGluaXRyZF9sb2FkKzB4M2YvMHgz
ZgpbICAgIDAuMzk4MDYzXSAgWzxmZmZmZmZmZjgxMTIwYjNiPl0gZG9fZmlscF9vcGVuKzB4
MzUvMHg3YQpbICAgIDAuMzk4MDYzXSAgWzxmZmZmZmZmZjgxNTRkNjNhPl0gPyBfcmF3X3Nw
aW5fdW5sb2NrKzB4MjIvMHgyZApbICAgIDAuMzk4MDYzXSAgWzxmZmZmZmZmZjgxMTJkYjY0
Pl0gPyBfX2FsbG9jX2ZkKzB4MWE5LzB4MWJiClsgICAgMC4zOTgwNjNdICBbPGZmZmZmZmZm
ODExMTQwN2Y+XSBkb19zeXNfb3BlbisweDE0OC8weDFkNwpbICAgIDAuMzk4MDYzXSAgWzxm
ZmZmZmZmZjgxYjZlNGNlPl0gPyBpbml0cmRfbG9hZCsweDNmLzB4M2YKWyAgICAwLjM5ODA2
M10gIFs8ZmZmZmZmZmY4MTExNDEyNz5dIFN5U19vcGVuKzB4MTkvMHgxYgpbICAgIDAuMzk4
MDYzXSAgWzxmZmZmZmZmZjgxYjZlZDIzPl0gZG9fbmFtZSsweGJiLzB4MjVlClsgICAgMC4z
OTgwNjNdICBbPGZmZmZmZmZmODFiNmU2NzU+XSB3cml0ZV9idWZmZXIrMHgyMS8weDMwClsg
ICAgMC4zOTgwNjNdICBbPGZmZmZmZmZmODFiNmU2ZWQ+XSBmbHVzaF9idWZmZXIrMHg2OS8w
eDgxClsgICAgMC4zOTgwNjNdICBbPGZmZmZmZmZmODFiODk4NWQ+XSBndW56aXArMHgyNTEv
MHgyZTAKWyAgICAwLjM5ODA2M10gIFs8ZmZmZmZmZmY4MWI4OTYwMz5dID8gZGVjb21wcmVz
c19tZXRob2QrMHg1YS8weDVhClsgICAgMC4zOTgwNjNdICBbPGZmZmZmZmZmODFiNmU2ODQ+
XSA/IHdyaXRlX2J1ZmZlcisweDMwLzB4MzAKWyAgICAwLjM5ODA2M10gIFs8ZmZmZmZmZmY4
MWI2ZTk3Nz5dIHVucGFja190b19yb290ZnMrMHgxMmQvMHgyNTUKWyAgICAwLjM5ODA2M10g
IFs8ZmZmZmZmZmY4MWI2ZTRjZT5dID8gaW5pdHJkX2xvYWQrMHgzZi8weDNmClsgICAgMC4z
OTgwNjNdICBbPGZmZmZmZmZmODFiNmYxNmU+XSA/IGRvX2hlYWRlcisweDEyZC8weDEyZApb
ICAgIDAuMzk4MDYzXSAgWzxmZmZmZmZmZjgxYjZmMWM0Pl0gcG9wdWxhdGVfcm9vdGZzKzB4
NTYvMHgxMDUKWyAgICAwLjM5ODA2M10gIFs8ZmZmZmZmZmY4MWI2ZjE2ZT5dID8gZG9faGVh
ZGVyKzB4MTJkLzB4MTJkClsgICAgMC4zOTgwNjNdICBbPGZmZmZmZmZmODFiNmRkNjk+XSBk
b19vbmVfaW5pdGNhbGwrMHg4ZS8weDEzOApbICAgIDAuMzk4MDYzXSAgWzxmZmZmZmZmZjgx
MDk0MDAwPl0gPyBwYXJhbWVxbisweDMzLzB4MzYKWyAgICAwLjM5ODA2M10gIFs8ZmZmZmZm
ZmY4MTA5NDFhMj5dID8gcGFyc2VfYXJncysweDE4MC8weDI0OApbICAgIDAuMzk4MDYzXSAg
WzxmZmZmZmZmZjgxYjZkZjJmPl0ga2VybmVsX2luaXRfZnJlZWFibGUrMHgxMWMvMHgxYTkK
WyAgICAwLjM5ODA2M10gIFs8ZmZmZmZmZmY4MWI2ZDZhNj5dID8gZG9fZWFybHlfcGFyYW0r
MHg4YS8weDhhClsgICAgMC4zOTgwNjNdICBbPGZmZmZmZmZmODE1MzUzMzM+XSA/IHJlc3Rf
aW5pdCsweDEzNy8weDEzNwpbICAgIDAuMzk4MDYzXSAgWzxmZmZmZmZmZjgxNTM1MzNjPl0g
a2VybmVsX2luaXQrMHg5LzB4ZmYKWyAgICAwLjM5ODA2M10gIFs8ZmZmZmZmZmY4MTU0ZTg0
Yz5dIHJldF9mcm9tX2ZvcmsrMHg3Yy8weGIwClsgICAgMC4zOTgwNjNdICBbPGZmZmZmZmZm
ODE1MzUzMzM+XSA/IHJlc3RfaW5pdCsweDEzNy8weDEzNwpbICAgIDAuMzk4MDYzXSAtLS1b
IGVuZCB0cmFjZSA5MjM5MjdmZDUxYzE5ODdlIF0tLS0KWyAgICAwLjM5ODA2M10gcG9zc2li
bGUgcmVhc29uOiB1bmFubm90YXRlZCBpcnFzLW9mZi4KL2tlcm5lbC94ODZfNjQtcmFuZGNv
bmZpZy1zMi0wMTExMTYyOC83MWMzYzBiMGYwNjQ5YzcxZmE0ZWU4ZGQzMzMzYjczNTFmYzc2
NzA3L2RtZXNnLXF1YW50YWwtYmVucy00OjIwMTQwMTExMjExMzE5Ong4Nl82NC1yYW5kY29u
ZmlnLXMyLTAxMTExNjI4OjMuMTMuMC1yYzctMDAzNTItZzcxYzNjMGI6OAova2VybmVsL3g4
Nl82NC1yYW5kY29uZmlnLXMyLTAxMTExNjI4LzcxYzNjMGIwZjA2NDljNzFmYTRlZThkZDMz
MzNiNzM1MWZjNzY3MDcvZG1lc2ctcXVhbnRhbC1iZW5zLTQ6MjAxNDAxMTEyMTEzMzI6eDg2
XzY0LXJhbmRjb25maWctczItMDExMTE2Mjg6My4xMy4wLXJjNy0wMDM1Mi1nNzFjM2MwYjo4
CjA6MjoyIGFsbF9nb29kOmJhZDphbGxfYmFkIGJvb3RzChtbMTszNW1SRVBFQVQgQ09VTlQ6
IDIwICAjIC9jYy93ZmcvdXNiLWJpc2VjdC8ucmVwZWF0G1swbQoKQmlzZWN0aW5nOiAxMCBy
ZXZpc2lvbnMgbGVmdCB0byB0ZXN0IGFmdGVyIHRoaXMgKHJvdWdobHkgMyBzdGVwcykKWzM4
M2YxZTg0YTUyNTMzYTZkMTk4ZThhNmYzZTc5ZmY1YjQzMzI2OWFdIGxpYi9rc3RydG94LmM6
IHJlbW92ZSByZWR1bmRhbnQgY2xlYW51cApydW5uaW5nIC9jL2tlcm5lbC10ZXN0cy9iaXNl
Y3QtdGVzdC1ib290LWZhaWx1cmUuc2ggL2hvbWUvd2ZnL3VzYi9vYmotYmlzZWN0CmxzIC1h
IC9rZXJuZWwtdGVzdHMvcnVuLXF1ZXVlL2t2bS94ODZfNjQtcmFuZGNvbmZpZy1zMi0wMTEx
MTYyOC9uZXh0Om1hc3RlcjozODNmMWU4NGE1MjUzM2E2ZDE5OGU4YTZmM2U3OWZmNWI0MzMy
NjlhOmJpc2VjdC11c2IKCjIwMTQtMDEtMTEtMjE6MTY6MDcgMzgzZjFlODRhNTI1MzNhNmQx
OThlOGE2ZjNlNzlmZjViNDMzMjY5YSBjb21waWxpbmcKMzIgcmVhbCAgMjggdXNlciAgNSBz
eXMgIDEwNi4xOSUgY3B1IAl4ODZfNjQtcmFuZGNvbmZpZy1zMi0wMTExMTYyOAoKMjAxNC0w
MS0xMS0yMToyMToxMSBkZXRlY3RpbmcgYm9vdCBzdGF0ZSAzLjEzLjAtcmM3LTAwMzQxLWcz
ODNmMWU4Lgk1Lgk2Li4JOQkxMC4uLgkxMQkxMgkxNAkxNQkxNi4JMjAgU1VDQ0VTUwoKQmlz
ZWN0aW5nOiA0IHJldmlzaW9ucyBsZWZ0IHRvIHRlc3QgYWZ0ZXIgdGhpcyAocm91Z2hseSAz
IHN0ZXBzKQpbNTVjYmZkMTVmZDEyNWFhZDY4YjlhOTU4NzQ5YWUyZDNjMTkyZGI5Y10gbGli
L2Fzc29jX2FycmF5LmM6IHJlbW92ZSBnbG9iYWwgdmFyaWFibGUKcnVubmluZyAvYy9rZXJu
ZWwtdGVzdHMvYmlzZWN0LXRlc3QtYm9vdC1mYWlsdXJlLnNoIC9ob21lL3dmZy91c2Ivb2Jq
LWJpc2VjdApscyAtYSAva2VybmVsLXRlc3RzL3J1bi1xdWV1ZS9rdm0veDg2XzY0LXJhbmRj
b25maWctczItMDExMTE2MjgvbmV4dDptYXN0ZXI6NTVjYmZkMTVmZDEyNWFhZDY4YjlhOTU4
NzQ5YWUyZDNjMTkyZGI5YzpiaXNlY3QtdXNiCgoyMDE0LTAxLTExLTIxOjMwOjEzIDU1Y2Jm
ZDE1ZmQxMjVhYWQ2OGI5YTk1ODc0OWFlMmQzYzE5MmRiOWMgY29tcGlsaW5nCjYzIHJlYWwg
IDI5IHVzZXIgIDYgc3lzICA1NS4zNSUgY3B1IAl4ODZfNjQtcmFuZGNvbmZpZy1zMi0wMTEx
MTYyOAoKMjAxNC0wMS0xMS0yMTozMTozNyBkZXRlY3RpbmcgYm9vdCBzdGF0ZSAzLjEzLjAt
cmM3LTAwMzQ3LWc1NWNiZmQxCTQJMTEuCTEyLgkxNQkxOC4JMTkuLi4uCTIwIFNVQ0NFU1MK
CkJpc2VjdGluZzogMSByZXZpc2lvbiBsZWZ0IHRvIHRlc3QgYWZ0ZXIgdGhpcyAocm91Z2hs
eSAxIHN0ZXApClsyOTlkZTg2N2NiYWY1NzZlZTBhYTA4ZDNjMzgzMzlkY2FhNzBkNGQxXSBm
aXJtd2FyZS9kbWlfc2NhbjogZ2VuZXJhbGl6ZSBmb3IgdXNlIGJ5IG90aGVyIGFyY2hzCnJ1
bm5pbmcgL2Mva2VybmVsLXRlc3RzL2Jpc2VjdC10ZXN0LWJvb3QtZmFpbHVyZS5zaCAvaG9t
ZS93ZmcvdXNiL29iai1iaXNlY3QKbHMgLWEgL2tlcm5lbC10ZXN0cy9ydW4tcXVldWUva3Zt
L3g4Nl82NC1yYW5kY29uZmlnLXMyLTAxMTExNjI4L25leHQ6bWFzdGVyOjI5OWRlODY3Y2Jh
ZjU3NmVlMGFhMDhkM2MzODMzOWRjYWE3MGQ0ZDE6YmlzZWN0LXVzYgoKMjAxNC0wMS0xMS0y
MTozODo0MSAyOTlkZTg2N2NiYWY1NzZlZTBhYTA4ZDNjMzgzMzlkY2FhNzBkNGQxIGNvbXBp
bGluZwo1NyByZWFsICAyOSB1c2VyICA1IHN5cyAgNjAuODMlIGNwdSAJeDg2XzY0LXJhbmRj
b25maWctczItMDExMTE2MjgKCjIwMTQtMDEtMTEtMjE6NDE6NTcgZGV0ZWN0aW5nIGJvb3Qg
c3RhdGUgMy4xMy4wLXJjNy0wMDM1MC1nMjk5ZGU4Ni4gVEVTVCBGQUlMVVJFClsgICAgMC4z
MDE0OTFdIFBDSTogQ0xTIDAgYnl0ZXMsIGRlZmF1bHQgNjQKWyAgICAwLjMwMjE3MF0gVW5w
YWNraW5nIGluaXRyYW1mcy4uLgpbICAgIDAuMzUwMTE1XSAtLS0tLS0tLS0tLS1bIGN1dCBo
ZXJlIF0tLS0tLS0tLS0tLS0KWyAgICAwLjM1MDcyMV0gV0FSTklORzogQ1BVOiAxIFBJRDog
MSBhdCBrZXJuZWwvbG9ja2luZy9sb2NrZGVwLmM6MzUzNSBjaGVja19mbGFncysweDc3LzB4
MWJhKCkKWyAgICAwLjM1MTc1OV0gREVCVUdfTE9DS1NfV0FSTl9PTihjdXJyZW50LT5oYXJk
aXJxc19lbmFibGVkKQpbICAgIDAuMzUyMzQyXSBDUFU6IDEgUElEOiAxIENvbW06IHN3YXBw
ZXIvMCBOb3QgdGFpbnRlZCAzLjEzLjAtcmM3LTAwMzUwLWcyOTlkZTg2ICMxMQpbICAgIDAu
MzUzMDgxXSAgMDAwMDAwMDAwMDAwMDAwMCBmZmZmODgwMDAwMDc3YTMwIGZmZmZmZmZmODE1
NDBmZjIgZmZmZjg4MDAwMDA3N2E3OApbICAgIDAuMzUzMDgxXSAgZmZmZjg4MDAwMDA3N2E2
OCBmZmZmZmZmZjgxMDdhYmQwIGZmZmZmZmZmODEwYWVkMTUgMDAwMDAwMDAwMDAwMDA0Ngpb
ICAgIDAuMzUzMDgxXSAgZmZmZmZmZmY4MWEwNjMxOCBmZmZmODgwMDAwMDc3ZDFjIDAwMDAw
MDAwMDAwMDAyODYgZmZmZjg4MDAwMDA3N2FjOApbICAgIDAuMzUzMDgxXSBDYWxsIFRyYWNl
OgpbICAgIDAuMzUzMDgxXSAgWzxmZmZmZmZmZjgxNTQwZmYyPl0gZHVtcF9zdGFjaysweDRk
LzB4NjYKWyAgICAwLjM1MzA4MV0gIFs8ZmZmZmZmZmY4MTA3YWJkMD5dIHdhcm5fc2xvd3Bh
dGhfY29tbW9uKzB4NzAvMHg4OQpbICAgIDAuMzUzMDgxXSAgWzxmZmZmZmZmZjgxMGFlZDE1
Pl0gPyBjaGVja19mbGFncysweDc3LzB4MWJhClsgICAgMC4zNTMwODFdICBbPGZmZmZmZmZm
ODEwN2FjNGE+XSB3YXJuX3Nsb3dwYXRoX2ZtdCsweDQ3LzB4NDkKWyAgICAwLjM1MzA4MV0g
IFs8ZmZmZmZmZmY4MTBhZWQxNT5dIGNoZWNrX2ZsYWdzKzB4NzcvMHgxYmEKWyAgICAwLjM1
MzA4MV0gIFs8ZmZmZmZmZmY4MTBiMjZjNj5dIGxvY2tfYWNxdWlyZSsweDUwLzB4YzQKWyAg
ICAwLjM1MzA4MV0gIFs8ZmZmZmZmZmY4MTExYzhhNz5dID8gZmluYWxfcHV0bmFtZSsweDJm
LzB4MzIKWyAgICAwLjM1MzA4MV0gIFs8ZmZmZmZmZmY4MTU0ZDUyNT5dIF9yYXdfc3Bpbl9s
b2NrKzB4MzIvMHgzZgpbICAgIDAuMzUzMDgxXSAgWzxmZmZmZmZmZjgxMWQ1ZjRhPl0gPyBf
X3BlcmNwdV9jb3VudGVyX2FkZCsweDQ1LzB4NzMKWyAgICAwLjM1MzA4MV0gIFs8ZmZmZmZm
ZmY4MTFkNWY0YT5dIF9fcGVyY3B1X2NvdW50ZXJfYWRkKzB4NDUvMHg3MwpbICAgIDAuMzUz
MDgxXSAgWzxmZmZmZmZmZjgxMTE1ZWM5Pl0gZ2V0X2VtcHR5X2ZpbHArMHg5OS8weDE4MApb
ICAgIDAuMzUzMDgxXSAgWzxmZmZmZmZmZjgxMTIwNTgxPl0gcGF0aF9vcGVuYXQrMHgzOS8w
eDViZQpbICAgIDAuMzUzMDgxXSAgWzxmZmZmZmZmZjgxMTE4NWI5Pl0gPyB2ZnNfZnN0YXRh
dCsweDQ0LzB4OTEKWyAgICAwLjM1MzA4MV0gIFs8ZmZmZmZmZmY4MWI2ZTRjZT5dID8gaW5p
dHJkX2xvYWQrMHgzZi8weDNmClsgICAgMC4zNTMwODFdICBbPGZmZmZmZmZmODExMjBiM2I+
XSBkb19maWxwX29wZW4rMHgzNS8weDdhClsgICAgMC4zNTMwODFdICBbPGZmZmZmZmZmODE1
NGQ2M2E+XSA/IF9yYXdfc3Bpbl91bmxvY2srMHgyMi8weDJkClsgICAgMC4zNTMwODFdICBb
PGZmZmZmZmZmODExMmRiNjQ+XSA/IF9fYWxsb2NfZmQrMHgxYTkvMHgxYmIKWyAgICAwLjM1
MzA4MV0gIFs8ZmZmZmZmZmY4MTExNDA3Zj5dIGRvX3N5c19vcGVuKzB4MTQ4LzB4MWQ3Clsg
ICAgMC4zNTMwODFdICBbPGZmZmZmZmZmODFiNmU0Y2U+XSA/IGluaXRyZF9sb2FkKzB4M2Yv
MHgzZgpbICAgIDAuMzUzMDgxXSAgWzxmZmZmZmZmZjgxMTE0MTI3Pl0gU3lTX29wZW4rMHgx
OS8weDFiClsgICAgMC4zNTMwODFdICBbPGZmZmZmZmZmODFiNmVkMjM+XSBkb19uYW1lKzB4
YmIvMHgyNWUKWyAgICAwLjM1MzA4MV0gIFs8ZmZmZmZmZmY4MWI2ZTY3NT5dIHdyaXRlX2J1
ZmZlcisweDIxLzB4MzAKWyAgICAwLjM1MzA4MV0gIFs8ZmZmZmZmZmY4MWI2ZTZlZD5dIGZs
dXNoX2J1ZmZlcisweDY5LzB4ODEKWyAgICAwLjM1MzA4MV0gIFs8ZmZmZmZmZmY4MWI4OTg1
ZD5dIGd1bnppcCsweDI1MS8weDJlMApbICAgIDAuMzUzMDgxXSAgWzxmZmZmZmZmZjgxYjg5
NjAzPl0gPyBkZWNvbXByZXNzX21ldGhvZCsweDVhLzB4NWEKWyAgICAwLjM1MzA4MV0gIFs8
ZmZmZmZmZmY4MWI2ZTY4ND5dID8gd3JpdGVfYnVmZmVyKzB4MzAvMHgzMApbICAgIDAuMzUz
MDgxXSAgWzxmZmZmZmZmZjgxYjZlOTc3Pl0gdW5wYWNrX3RvX3Jvb3RmcysweDEyZC8weDI1
NQpbICAgIDAuMzUzMDgxXSAgWzxmZmZmZmZmZjgxYjZlNGNlPl0gPyBpbml0cmRfbG9hZCsw
eDNmLzB4M2YKWyAgICAwLjM1MzA4MV0gIFs8ZmZmZmZmZmY4MWI2ZjE2ZT5dID8gZG9faGVh
ZGVyKzB4MTJkLzB4MTJkClsgICAgMC4zNTMwODFdICBbPGZmZmZmZmZmODFiNmYxYzQ+XSBw
b3B1bGF0ZV9yb290ZnMrMHg1Ni8weDEwNQpbICAgIDAuMzUzMDgxXSAgWzxmZmZmZmZmZjgx
YjZmMTZlPl0gPyBkb19oZWFkZXIrMHgxMmQvMHgxMmQKWyAgICAwLjM1MzA4MV0gIFs8ZmZm
ZmZmZmY4MWI2ZGQ2OT5dIGRvX29uZV9pbml0Y2FsbCsweDhlLzB4MTM4ClsgICAgMC4zNTMw
ODFdICBbPGZmZmZmZmZmODEwOTQwMDA+XSA/IHBhcmFtZXFuKzB4MzMvMHgzNgpbICAgIDAu
MzUzMDgxXSAgWzxmZmZmZmZmZjgxMDk0MWEyPl0gPyBwYXJzZV9hcmdzKzB4MTgwLzB4MjQ4
ClsgICAgMC4zNTMwODFdICBbPGZmZmZmZmZmODFiNmRmMmY+XSBrZXJuZWxfaW5pdF9mcmVl
YWJsZSsweDExYy8weDFhOQpbICAgIDAuMzUzMDgxXSAgWzxmZmZmZmZmZjgxYjZkNmE2Pl0g
PyBkb19lYXJseV9wYXJhbSsweDhhLzB4OGEKWyAgICAwLjM1MzA4MV0gIFs8ZmZmZmZmZmY4
MTUzNTMzMz5dID8gcmVzdF9pbml0KzB4MTM3LzB4MTM3ClsgICAgMC4zNTMwODFdICBbPGZm
ZmZmZmZmODE1MzUzM2M+XSBrZXJuZWxfaW5pdCsweDkvMHhmZgpbICAgIDAuMzUzMDgxXSAg
WzxmZmZmZmZmZjgxNTRlODRjPl0gcmV0X2Zyb21fZm9yaysweDdjLzB4YjAKWyAgICAwLjM1
MzA4MV0gIFs8ZmZmZmZmZmY4MTUzNTMzMz5dID8gcmVzdF9pbml0KzB4MTM3LzB4MTM3Clsg
ICAgMC4zNTMwODFdIC0tLVsgZW5kIHRyYWNlIGQxM2NiMjQyM2ExOGRhMWUgXS0tLQpbICAg
IDAuMzUzMDgxXSBwb3NzaWJsZSByZWFzb246IHVuYW5ub3RhdGVkIGlycXMtb2ZmLgova2Vy
bmVsL3g4Nl82NC1yYW5kY29uZmlnLXMyLTAxMTExNjI4LzI5OWRlODY3Y2JhZjU3NmVlMGFh
MDhkM2MzODMzOWRjYWE3MGQ0ZDEvZG1lc2ctcXVhbnRhbC1hdGhlbnMtMzU6MjAxNDAxMTEy
MTQyMDU6eDg2XzY0LXJhbmRjb25maWctczItMDExMTE2Mjg6My4xMy4wLXJjNy0wMDM1MC1n
Mjk5ZGU4NjoxMQova2VybmVsL3g4Nl82NC1yYW5kY29uZmlnLXMyLTAxMTExNjI4LzI5OWRl
ODY3Y2JhZjU3NmVlMGFhMDhkM2MzODMzOWRjYWE3MGQ0ZDEvZG1lc2ctcXVhbnRhbC1jYWly
by0yNzoyMDE0MDExMTIxNDIwNjp4ODZfNjQtcmFuZGNvbmZpZy1zMi0wMTExMTYyODozLjEz
LjAtcmM3LTAwMzUwLWcyOTlkZTg2OjExCi9rZXJuZWwveDg2XzY0LXJhbmRjb25maWctczIt
MDExMTE2MjgvMjk5ZGU4NjdjYmFmNTc2ZWUwYWEwOGQzYzM4MzM5ZGNhYTcwZDRkMS9kbWVz
Zy1xdWFudGFsLXNuYi0yOjIwMTQwMTExMjE0MjA4Ong4Nl82NC1yYW5kY29uZmlnLXMyLTAx
MTExNjI4OjMuMTMuMC1yYzctMDAzNTAtZzI5OWRlODY6MTEKMDozOjMgYWxsX2dvb2Q6YmFk
OmFsbF9iYWQgYm9vdHMKG1sxOzM1bVJFUEVBVCBDT1VOVDogMjAgICMgL2NjL3dmZy91c2It
YmlzZWN0Ly5yZXBlYXQbWzBtCgpCaXNlY3Rpbmc6IDAgcmV2aXNpb25zIGxlZnQgdG8gdGVz
dCBhZnRlciB0aGlzIChyb3VnaGx5IDEgc3RlcCkKWzdjZDdmZWIxM2Y2ODRkNWZmOTIxOWU1
MTE3ZTM1OWU4OThlY2FkOTddIGxpYjogQWRkIENSQzY0IEVDTUEgbW9kdWxlCnJ1bm5pbmcg
L2Mva2VybmVsLXRlc3RzL2Jpc2VjdC10ZXN0LWJvb3QtZmFpbHVyZS5zaCAvaG9tZS93Zmcv
dXNiL29iai1iaXNlY3QKbHMgLWEgL2tlcm5lbC10ZXN0cy9ydW4tcXVldWUva3ZtL3g4Nl82
NC1yYW5kY29uZmlnLXMyLTAxMTExNjI4L25leHQ6bWFzdGVyOjdjZDdmZWIxM2Y2ODRkNWZm
OTIxOWU1MTE3ZTM1OWU4OThlY2FkOTc6YmlzZWN0LXVzYgoKMjAxNC0wMS0xMS0yMTo0Mjoz
NSA3Y2Q3ZmViMTNmNjg0ZDVmZjkyMTllNTExN2UzNTllODk4ZWNhZDk3IGNvbXBpbGluZwo0
NCByZWFsICAzMSB1c2VyICA2IHN5cyAgODMuNzclIGNwdSAJeDg2XzY0LXJhbmRjb25maWct
czItMDExMTE2MjgKCjIwMTQtMDEtMTEtMjE6NDY6MDQgZGV0ZWN0aW5nIGJvb3Qgc3RhdGUg
My4xMy4wLXJjNy0wMDM0OS1nN2NkN2ZlYi4gVEVTVCBGQUlMVVJFClsgICAgMC40MDA0MTJd
IFBDSTogQ0xTIDAgYnl0ZXMsIGRlZmF1bHQgNjQKWyAgICAwLjQwMTA5Nl0gVW5wYWNraW5n
IGluaXRyYW1mcy4uLgpbICAgIDAuNDUyNzE0XSAtLS0tLS0tLS0tLS1bIGN1dCBoZXJlIF0t
LS0tLS0tLS0tLS0KWyAgICAwLjQ1MzI4NF0gV0FSTklORzogQ1BVOiAwIFBJRDogMSBhdCBr
ZXJuZWwvbG9ja2luZy9sb2NrZGVwLmM6MzUzNSBjaGVja19mbGFncysweDc3LzB4MWJhKCkK
WyAgICAwLjQ1NDU4Ml0gREVCVUdfTE9DS1NfV0FSTl9PTihjdXJyZW50LT5oYXJkaXJxc19l
bmFibGVkKQpbICAgIDAuNDU1MTY1XSBDUFU6IDAgUElEOiAxIENvbW06IHN3YXBwZXIvMCBO
b3QgdGFpbnRlZCAzLjEzLjAtcmM3LTAwMzQ5LWc3Y2Q3ZmViICMxMgpbICAgIDAuNDU2MDgw
XSAgMDAwMDAwMDAwMDAwMDAwMCBmZmZmODgwMDAwMDc3YTMwIGZmZmZmZmZmODE1NDBmZjIg
ZmZmZjg4MDAwMDA3N2E3OApbICAgIDAuNDU2NDQ1XSAgZmZmZjg4MDAwMDA3N2E2OCBmZmZm
ZmZmZjgxMDdhYmQwIGZmZmZmZmZmODEwYWVkMTUgMDAwMDAwMDAwMDAwMDA0NgpbICAgIDAu
NDU2NDQ1XSAgZmZmZmZmZmY4MWEwNjMxOCBmZmZmODgwMDAwMDc3ZDFjIDAwMDAwMDAwMDAw
MDAyODIgZmZmZjg4MDAwMDA3N2FjOApbICAgIDAuNDU2NDQ1XSBDYWxsIFRyYWNlOgpbICAg
IDAuNDU2NDQ1XSAgWzxmZmZmZmZmZjgxNTQwZmYyPl0gZHVtcF9zdGFjaysweDRkLzB4NjYK
WyAgICAwLjQ1NjQ0NV0gIFs8ZmZmZmZmZmY4MTA3YWJkMD5dIHdhcm5fc2xvd3BhdGhfY29t
bW9uKzB4NzAvMHg4OQpbICAgIDAuNDU2NDQ1XSAgWzxmZmZmZmZmZjgxMGFlZDE1Pl0gPyBj
aGVja19mbGFncysweDc3LzB4MWJhClsgICAgMC40NTY0NDVdICBbPGZmZmZmZmZmODEwN2Fj
NGE+XSB3YXJuX3Nsb3dwYXRoX2ZtdCsweDQ3LzB4NDkKWyAgICAwLjQ1NjQ0NV0gIFs8ZmZm
ZmZmZmY4MTBhZWQxNT5dIGNoZWNrX2ZsYWdzKzB4NzcvMHgxYmEKWyAgICAwLjQ1NjQ0NV0g
IFs8ZmZmZmZmZmY4MTBiMjZjNj5dIGxvY2tfYWNxdWlyZSsweDUwLzB4YzQKWyAgICAwLjQ1
NjQ0NV0gIFs8ZmZmZmZmZmY4MTExYzhhNz5dID8gZmluYWxfcHV0bmFtZSsweDJmLzB4MzIK
WyAgICAwLjQ1NjQ0NV0gIFs8ZmZmZmZmZmY4MTU0ZDUyNT5dIF9yYXdfc3Bpbl9sb2NrKzB4
MzIvMHgzZgpbICAgIDAuNDU2NDQ1XSAgWzxmZmZmZmZmZjgxMWQ1ZjRhPl0gPyBfX3BlcmNw
dV9jb3VudGVyX2FkZCsweDQ1LzB4NzMKWyAgICAwLjQ1NjQ0NV0gIFs8ZmZmZmZmZmY4MTFk
NWY0YT5dIF9fcGVyY3B1X2NvdW50ZXJfYWRkKzB4NDUvMHg3MwpbICAgIDAuNDU2NDQ1XSAg
WzxmZmZmZmZmZjgxMTE1ZWM5Pl0gZ2V0X2VtcHR5X2ZpbHArMHg5OS8weDE4MApbICAgIDAu
NDU2NDQ1XSAgWzxmZmZmZmZmZjgxMTIwNTgxPl0gcGF0aF9vcGVuYXQrMHgzOS8weDViZQpb
ICAgIDAuNDU2NDQ1XSAgWzxmZmZmZmZmZjgxMTE4NWI5Pl0gPyB2ZnNfZnN0YXRhdCsweDQ0
LzB4OTEKWyAgICAwLjQ1NjQ0NV0gIFs8ZmZmZmZmZmY4MWI2ZTRjZT5dID8gaW5pdHJkX2xv
YWQrMHgzZi8weDNmClsgICAgMC40NTY0NDVdICBbPGZmZmZmZmZmODExMjBiM2I+XSBkb19m
aWxwX29wZW4rMHgzNS8weDdhClsgICAgMC40NTY0NDVdICBbPGZmZmZmZmZmODE1NGQ2M2E+
XSA/IF9yYXdfc3Bpbl91bmxvY2srMHgyMi8weDJkClsgICAgMC40NTY0NDVdICBbPGZmZmZm
ZmZmODExMmRiNjQ+XSA/IF9fYWxsb2NfZmQrMHgxYTkvMHgxYmIKWyAgICAwLjQ1NjQ0NV0g
IFs8ZmZmZmZmZmY4MTExNDA3Zj5dIGRvX3N5c19vcGVuKzB4MTQ4LzB4MWQ3ClsgICAgMC40
NTY0NDVdICBbPGZmZmZmZmZmODFiNmU0Y2U+XSA/IGluaXRyZF9sb2FkKzB4M2YvMHgzZgpb
ICAgIDAuNDU2NDQ1XSAgWzxmZmZmZmZmZjgxMTE0MTI3Pl0gU3lTX29wZW4rMHgxOS8weDFi
ClsgICAgMC40NTY0NDVdICBbPGZmZmZmZmZmODFiNmVkMjM+XSBkb19uYW1lKzB4YmIvMHgy
NWUKWyAgICAwLjQ1NjQ0NV0gIFs8ZmZmZmZmZmY4MWI2ZTY3NT5dIHdyaXRlX2J1ZmZlcisw
eDIxLzB4MzAKWyAgICAwLjQ1NjQ0NV0gIFs8ZmZmZmZmZmY4MWI2ZTZlZD5dIGZsdXNoX2J1
ZmZlcisweDY5LzB4ODEKWyAgICAwLjQ1NjQ0NV0gIFs8ZmZmZmZmZmY4MWI4OTg1ZD5dIGd1
bnppcCsweDI1MS8weDJlMApbICAgIDAuNDU2NDQ1XSAgWzxmZmZmZmZmZjgxYjg5NjAzPl0g
PyBkZWNvbXByZXNzX21ldGhvZCsweDVhLzB4NWEKWyAgICAwLjQ1NjQ0NV0gIFs8ZmZmZmZm
ZmY4MWI2ZTY4ND5dID8gd3JpdGVfYnVmZmVyKzB4MzAvMHgzMApbICAgIDAuNDU2NDQ1XSAg
WzxmZmZmZmZmZjgxYjZlOTc3Pl0gdW5wYWNrX3RvX3Jvb3RmcysweDEyZC8weDI1NQpbICAg
IDAuNDU2NDQ1XSAgWzxmZmZmZmZmZjgxYjZlNGNlPl0gPyBpbml0cmRfbG9hZCsweDNmLzB4
M2YKWyAgICAwLjQ1NjQ0NV0gIFs8ZmZmZmZmZmY4MWI2ZjE2ZT5dID8gZG9faGVhZGVyKzB4
MTJkLzB4MTJkClsgICAgMC40NTY0NDVdICBbPGZmZmZmZmZmODFiNmYxYzQ+XSBwb3B1bGF0
ZV9yb290ZnMrMHg1Ni8weDEwNQpbICAgIDAuNDU2NDQ1XSAgWzxmZmZmZmZmZjgxYjZmMTZl
Pl0gPyBkb19oZWFkZXIrMHgxMmQvMHgxMmQKWyAgICAwLjQ1NjQ0NV0gIFs8ZmZmZmZmZmY4
MWI2ZGQ2OT5dIGRvX29uZV9pbml0Y2FsbCsweDhlLzB4MTM4ClsgICAgMC40NTY0NDVdICBb
PGZmZmZmZmZmODEwOTQwMDA+XSA/IHBhcmFtZXFuKzB4MzMvMHgzNgpbICAgIDAuNDU2NDQ1
XSAgWzxmZmZmZmZmZjgxMDk0MWEyPl0gPyBwYXJzZV9hcmdzKzB4MTgwLzB4MjQ4ClsgICAg
MC40NTY0NDVdICBbPGZmZmZmZmZmODFiNmRmMmY+XSBrZXJuZWxfaW5pdF9mcmVlYWJsZSsw
eDExYy8weDFhOQpbICAgIDAuNDU2NDQ1XSAgWzxmZmZmZmZmZjgxYjZkNmE2Pl0gPyBkb19l
YXJseV9wYXJhbSsweDhhLzB4OGEKWyAgICAwLjQ1NjQ0NV0gIFs8ZmZmZmZmZmY4MTUzNTMz
Mz5dID8gcmVzdF9pbml0KzB4MTM3LzB4MTM3ClsgICAgMC40NTY0NDVdICBbPGZmZmZmZmZm
ODE1MzUzM2M+XSBrZXJuZWxfaW5pdCsweDkvMHhmZgpbICAgIDAuNDU2NDQ1XSAgWzxmZmZm
ZmZmZjgxNTRlODRjPl0gcmV0X2Zyb21fZm9yaysweDdjLzB4YjAKWyAgICAwLjQ1NjQ0NV0g
IFs8ZmZmZmZmZmY4MTUzNTMzMz5dID8gcmVzdF9pbml0KzB4MTM3LzB4MTM3ClsgICAgMC40
NTY0NDVdIC0tLVsgZW5kIHRyYWNlIGE2YzQ2MGVjMmIyZjYyZTMgXS0tLQpbICAgIDAuNDU2
NDQ1XSBwb3NzaWJsZSByZWFzb246IHVuYW5ub3RhdGVkIGlycXMtb2ZmLgova2VybmVsL3g4
Nl82NC1yYW5kY29uZmlnLXMyLTAxMTExNjI4LzdjZDdmZWIxM2Y2ODRkNWZmOTIxOWU1MTE3
ZTM1OWU4OThlY2FkOTcvZG1lc2ctcXVhbnRhbC1yb2FtLTMyOjIwMTQwMTExMjE0NjE0Ong4
Nl82NC1yYW5kY29uZmlnLXMyLTAxMTExNjI4OjMuMTMuMC1yYzctMDAzNDktZzdjZDdmZWI6
MTIKMDoxOjEgYWxsX2dvb2Q6YmFkOmFsbF9iYWQgYm9vdHMKG1sxOzM1bVJFUEVBVCBDT1VO
VDogMjAgICMgL2NjL3dmZy91c2ItYmlzZWN0Ly5yZXBlYXQbWzBtCgpCaXNlY3Rpbmc6IDAg
cmV2aXNpb25zIGxlZnQgdG8gdGVzdCBhZnRlciB0aGlzIChyb3VnaGx5IDAgc3RlcHMpCls5
N2U4OTBiOWM4MzljMTkxYTUwMGMzYTE5YmZiNDUzOWY2NWM3MGJlXSBsaWIvcGVyY3B1X2Nv
dW50ZXIuYzogZGlzYWJsZSBsb2NhbCBpcnEgd2hlbiB1cGRhdGluZyBwZXJjcHUgY291dGVy
CnJ1bm5pbmcgL2Mva2VybmVsLXRlc3RzL2Jpc2VjdC10ZXN0LWJvb3QtZmFpbHVyZS5zaCAv
aG9tZS93ZmcvdXNiL29iai1iaXNlY3QKbHMgLWEgL2tlcm5lbC10ZXN0cy9ydW4tcXVldWUv
a3ZtL3g4Nl82NC1yYW5kY29uZmlnLXMyLTAxMTExNjI4L25leHQ6bWFzdGVyOjk3ZTg5MGI5
YzgzOWMxOTFhNTAwYzNhMTliZmI0NTM5ZjY1YzcwYmU6YmlzZWN0LXVzYgoKMjAxNC0wMS0x
MS0yMTo0NjozNiA5N2U4OTBiOWM4MzljMTkxYTUwMGMzYTE5YmZiNDUzOWY2NWM3MGJlIGNv
bXBpbGluZwoxNCByZWFsICAyNSB1c2VyICA1IHN5cyAgMjE0LjQ2JSBjcHUgCXg4Nl82NC1y
YW5kY29uZmlnLXMyLTAxMTExNjI4CgoyMDE0LTAxLTExLTIxOjQ2OjU4IGRldGVjdGluZyBi
b290IHN0YXRlIDMuMTMuMC1yYzctMDAzNDgtZzk3ZTg5MGIuIFRFU1QgRkFJTFVSRQpbICAg
IDAuMzk5NjI0XSBQQ0k6IENMUyAwIGJ5dGVzLCBkZWZhdWx0IDY0ClsgICAgMC40MDA3MjBd
IFVucGFja2luZyBpbml0cmFtZnMuLi4KWyAgICAwLjQ3NDk4MF0gLS0tLS0tLS0tLS0tWyBj
dXQgaGVyZSBdLS0tLS0tLS0tLS0tClsgICAgMC40NzU4NjNdIFdBUk5JTkc6IENQVTogMCBQ
SUQ6IDEgYXQga2VybmVsL2xvY2tpbmcvbG9ja2RlcC5jOjM1MzUgY2hlY2tfZmxhZ3MrMHg3
Ny8weDFiYSgpClsgICAgMC40Nzc0MTJdIERFQlVHX0xPQ0tTX1dBUk5fT04oY3VycmVudC0+
aGFyZGlycXNfZW5hYmxlZCkKWyAgICAwLjQ3ODMzMF0gQ1BVOiAwIFBJRDogMSBDb21tOiBz
d2FwcGVyLzAgTm90IHRhaW50ZWQgMy4xMy4wLXJjNy0wMDM0OC1nOTdlODkwYiAjMTMKWyAg
ICAwLjQ3OTY2MV0gIDAwMDAwMDAwMDAwMDAwMDAgZmZmZjg4MDAwMDA3N2EzMCBmZmZmZmZm
ZjgxNTQwZmYyIGZmZmY4ODAwMDAwNzdhNzgKWyAgICAwLjQ4MTAxNl0gIGZmZmY4ODAwMDAw
NzdhNjggZmZmZmZmZmY4MTA3YWJkMCBmZmZmZmZmZjgxMGFlZDE1IDAwMDAwMDAwMDAwMDAw
NDYKWyAgICAwLjQ4MjM1NV0gIGZmZmZmZmZmODFhMDYzMTggZmZmZjg4MDAwMDA3N2QxYyAw
MDAwMDAwMDAwMDAwMjgyIGZmZmY4ODAwMDAwNzdhYzgKWyAgICAwLjQ4MjQxMV0gQ2FsbCBU
cmFjZToKWyAgICAwLjQ4MjQxMV0gIFs8ZmZmZmZmZmY4MTU0MGZmMj5dIGR1bXBfc3RhY2sr
MHg0ZC8weDY2ClsgICAgMC40ODI0MTFdICBbPGZmZmZmZmZmODEwN2FiZDA+XSB3YXJuX3Ns
b3dwYXRoX2NvbW1vbisweDcwLzB4ODkKWyAgICAwLjQ4MjQxMV0gIFs8ZmZmZmZmZmY4MTBh
ZWQxNT5dID8gY2hlY2tfZmxhZ3MrMHg3Ny8weDFiYQpbICAgIDAuNDgyNDExXSAgWzxmZmZm
ZmZmZjgxMDdhYzRhPl0gd2Fybl9zbG93cGF0aF9mbXQrMHg0Ny8weDQ5ClsgICAgMC40ODI0
MTFdICBbPGZmZmZmZmZmODEwYWVkMTU+XSBjaGVja19mbGFncysweDc3LzB4MWJhClsgICAg
MC40ODI0MTFdICBbPGZmZmZmZmZmODEwYjI2YzY+XSBsb2NrX2FjcXVpcmUrMHg1MC8weGM0
ClsgICAgMC40ODI0MTFdICBbPGZmZmZmZmZmODExMWM4YTc+XSA/IGZpbmFsX3B1dG5hbWUr
MHgyZi8weDMyClsgICAgMC40ODI0MTFdICBbPGZmZmZmZmZmODE1NGQ1MjU+XSBfcmF3X3Nw
aW5fbG9jaysweDMyLzB4M2YKWyAgICAwLjQ4MjQxMV0gIFs8ZmZmZmZmZmY4MTFkNWY0YT5d
ID8gX19wZXJjcHVfY291bnRlcl9hZGQrMHg0NS8weDczClsgICAgMC40ODI0MTFdICBbPGZm
ZmZmZmZmODExZDVmNGE+XSBfX3BlcmNwdV9jb3VudGVyX2FkZCsweDQ1LzB4NzMKWyAgICAw
LjQ4MjQxMV0gIFs8ZmZmZmZmZmY4MTExNWVjOT5dIGdldF9lbXB0eV9maWxwKzB4OTkvMHgx
ODAKWyAgICAwLjQ4MjQxMV0gIFs8ZmZmZmZmZmY4MTEyMDU4MT5dIHBhdGhfb3BlbmF0KzB4
MzkvMHg1YmUKWyAgICAwLjQ4MjQxMV0gIFs8ZmZmZmZmZmY4MTExODViOT5dID8gdmZzX2Zz
dGF0YXQrMHg0NC8weDkxClsgICAgMC40ODI0MTFdICBbPGZmZmZmZmZmODFiNmU0Y2U+XSA/
IGluaXRyZF9sb2FkKzB4M2YvMHgzZgpbICAgIDAuNDgyNDExXSAgWzxmZmZmZmZmZjgxMTIw
YjNiPl0gZG9fZmlscF9vcGVuKzB4MzUvMHg3YQpbICAgIDAuNDgyNDExXSAgWzxmZmZmZmZm
ZjgxNTRkNjNhPl0gPyBfcmF3X3NwaW5fdW5sb2NrKzB4MjIvMHgyZApbICAgIDAuNDgyNDEx
XSAgWzxmZmZmZmZmZjgxMTJkYjY0Pl0gPyBfX2FsbG9jX2ZkKzB4MWE5LzB4MWJiClsgICAg
MC40ODI0MTFdICBbPGZmZmZmZmZmODExMTQwN2Y+XSBkb19zeXNfb3BlbisweDE0OC8weDFk
NwpbICAgIDAuNDgyNDExXSAgWzxmZmZmZmZmZjgxYjZlNGNlPl0gPyBpbml0cmRfbG9hZCsw
eDNmLzB4M2YKWyAgICAwLjQ4MjQxMV0gIFs8ZmZmZmZmZmY4MTExNDEyNz5dIFN5U19vcGVu
KzB4MTkvMHgxYgpbICAgIDAuNDgyNDExXSAgWzxmZmZmZmZmZjgxYjZlZDIzPl0gZG9fbmFt
ZSsweGJiLzB4MjVlClsgICAgMC40ODI0MTFdICBbPGZmZmZmZmZmODFiNmU2NzU+XSB3cml0
ZV9idWZmZXIrMHgyMS8weDMwClsgICAgMC40ODI0MTFdICBbPGZmZmZmZmZmODFiNmU2ZWQ+
XSBmbHVzaF9idWZmZXIrMHg2OS8weDgxClsgICAgMC40ODI0MTFdICBbPGZmZmZmZmZmODFi
ODk4NWQ+XSBndW56aXArMHgyNTEvMHgyZTAKWyAgICAwLjQ4MjQxMV0gIFs8ZmZmZmZmZmY4
MWI4OTYwMz5dID8gZGVjb21wcmVzc19tZXRob2QrMHg1YS8weDVhClsgICAgMC40ODI0MTFd
ICBbPGZmZmZmZmZmODFiNmU2ODQ+XSA/IHdyaXRlX2J1ZmZlcisweDMwLzB4MzAKWyAgICAw
LjQ4MjQxMV0gIFs8ZmZmZmZmZmY4MWI2ZTk3Nz5dIHVucGFja190b19yb290ZnMrMHgxMmQv
MHgyNTUKWyAgICAwLjQ4MjQxMV0gIFs8ZmZmZmZmZmY4MWI2ZTRjZT5dID8gaW5pdHJkX2xv
YWQrMHgzZi8weDNmClsgICAgMC40ODI0MTFdICBbPGZmZmZmZmZmODFiNmYxNmU+XSA/IGRv
X2hlYWRlcisweDEyZC8weDEyZApbICAgIDAuNDgyNDExXSAgWzxmZmZmZmZmZjgxYjZmMWM0
Pl0gcG9wdWxhdGVfcm9vdGZzKzB4NTYvMHgxMDUKWyAgICAwLjQ4MjQxMV0gIFs8ZmZmZmZm
ZmY4MWI2ZjE2ZT5dID8gZG9faGVhZGVyKzB4MTJkLzB4MTJkClsgICAgMC40ODI0MTFdICBb
PGZmZmZmZmZmODFiNmRkNjk+XSBkb19vbmVfaW5pdGNhbGwrMHg4ZS8weDEzOApbICAgIDAu
NDgyNDExXSAgWzxmZmZmZmZmZjgxMDk0MDAwPl0gPyBwYXJhbWVxbisweDMzLzB4MzYKWyAg
ICAwLjQ4MjQxMV0gIFs8ZmZmZmZmZmY4MTA5NDFhMj5dID8gcGFyc2VfYXJncysweDE4MC8w
eDI0OApbICAgIDAuNDgyNDExXSAgWzxmZmZmZmZmZjgxYjZkZjJmPl0ga2VybmVsX2luaXRf
ZnJlZWFibGUrMHgxMWMvMHgxYTkKWyAgICAwLjQ4MjQxMV0gIFs8ZmZmZmZmZmY4MWI2ZDZh
Nj5dID8gZG9fZWFybHlfcGFyYW0rMHg4YS8weDhhClsgICAgMC40ODI0MTFdICBbPGZmZmZm
ZmZmODE1MzUzMzM+XSA/IHJlc3RfaW5pdCsweDEzNy8weDEzNwpbICAgIDAuNDgyNDExXSAg
WzxmZmZmZmZmZjgxNTM1MzNjPl0ga2VybmVsX2luaXQrMHg5LzB4ZmYKWyAgICAwLjQ4MjQx
MV0gIFs8ZmZmZmZmZmY4MTU0ZTg0Yz5dIHJldF9mcm9tX2ZvcmsrMHg3Yy8weGIwClsgICAg
MC40ODI0MTFdICBbPGZmZmZmZmZmODE1MzUzMzM+XSA/IHJlc3RfaW5pdCsweDEzNy8weDEz
NwpbICAgIDAuNDgyNDExXSAtLS1bIGVuZCB0cmFjZSBiMzkwMDE4ZTljMmI0ZGE2IF0tLS0K
WyAgICAwLjQ4MjQxMV0gcG9zc2libGUgcmVhc29uOiB1bmFubm90YXRlZCBpcnFzLW9mZi4K
L2tlcm5lbC94ODZfNjQtcmFuZGNvbmZpZy1zMi0wMTExMTYyOC85N2U4OTBiOWM4MzljMTkx
YTUwMGMzYTE5YmZiNDUzOWY2NWM3MGJlL2RtZXNnLXF1YW50YWwtaW5uLTI6MjAxNDAxMTEy
MTQ3MTI6eDg2XzY0LXJhbmRjb25maWctczItMDExMTE2Mjg6My4xMy4wLXJjNy0wMDM0OC1n
OTdlODkwYjoxMwova2VybmVsL3g4Nl82NC1yYW5kY29uZmlnLXMyLTAxMTExNjI4Lzk3ZTg5
MGI5YzgzOWMxOTFhNTAwYzNhMTliZmI0NTM5ZjY1YzcwYmUvZG1lc2ctcXVhbnRhbC1hdGhl
bnMtMjg6MjAxNDAxMTEyMTQ3MjA6eDg2XzY0LXJhbmRjb25maWctczItMDExMTE2Mjg6My4x
My4wLXJjNy0wMDM0OC1nOTdlODkwYjoxMwova2VybmVsL3g4Nl82NC1yYW5kY29uZmlnLXMy
LTAxMTExNjI4Lzk3ZTg5MGI5YzgzOWMxOTFhNTAwYzNhMTliZmI0NTM5ZjY1YzcwYmUvZG1l
c2ctcXVhbnRhbC1jYWlyby00MToyMDE0MDExMTIxNDcyMzp4ODZfNjQtcmFuZGNvbmZpZy1z
Mi0wMTExMTYyODozLjEzLjAtcmM3LTAwMzQ4LWc5N2U4OTBiOjEzCjA6MzozIGFsbF9nb29k
OmJhZDphbGxfYmFkIGJvb3RzChtbMTszNW1SRVBFQVQgQ09VTlQ6IDIwICAjIC9jYy93Zmcv
dXNiLWJpc2VjdC8ucmVwZWF0G1swbQoKOTdlODkwYjljODM5YzE5MWE1MDBjM2ExOWJmYjQ1
MzlmNjVjNzBiZSBpcyB0aGUgZmlyc3QgYmFkIGNvbW1pdApjb21taXQgOTdlODkwYjljODM5
YzE5MWE1MDBjM2ExOWJmYjQ1MzlmNjVjNzBiZQpBdXRob3I6IE1pbmcgTGVpIDx0b20ubGVp
bWluZ0BnbWFpbC5jb20+CkRhdGU6ICAgRnJpIEphbiAxMCAxMjo0MTo0NiAyMDE0ICsxMTAw
CgogICAgbGliL3BlcmNwdV9jb3VudGVyLmM6IGRpc2FibGUgbG9jYWwgaXJxIHdoZW4gdXBk
YXRpbmcgcGVyY3B1IGNvdXRlcgogICAgCiAgICBfX3BlcmNwdV9jb3VudGVyX2FkZCgpIG1h
eSBiZSBjYWxsZWQgaW4gc29mdGlycS9oYXJkaXJxIGhhbmRsZXIgKHN1Y2ggYXMsCiAgICBi
bGtfbXFfcXVldWVfZXhpdCgpIGlzIHR5cGljYWxseSBjYWxsZWQgaW4gaGFyZGlycS9zb2Z0
aXJxIGhhbmRsZXIpLCBzbyB3ZQogICAgbmVlZCB0byBkaXNhYmxlIGxvY2FsIGlycSB3aGVu
IHVwZGF0aW5nIHRoZSBwZXJjcHUgY291bnRlciwgb3RoZXJ3aXNlCiAgICBjb3VudHMgbWF5
IGJlIGxvc3QuCiAgICAKICAgIFRoZSBwYXRjaCBmaXhlcyBwcm9ibGVtIHRoYXQgJ3JtbW9k
IG51bGxfYmxrJyBtYXkgaGFuZyBpbiBibGtfY2xlYW51cF9xdWV1ZSgpCiAgICBiZWNhdXNl
IG9mIG1pc2NvdW50aW5nIG9mIHJlcXVlc3RfcXVldWUtPm1xX3VzYWdlX2NvdW50ZXIuCiAg
ICAKICAgIFNpZ25lZC1vZmYtYnk6IE1pbmcgTGVpIDx0b20ubGVpbWluZ0BnbWFpbC5jb20+
CiAgICBDYzogUGF1bCBHb3J0bWFrZXIgPHBhdWwuZ29ydG1ha2VyQHdpbmRyaXZlci5jb20+
CiAgICBDYzogQW5kcmV3IE1vcnRvbiA8YWtwbUBsaW51eC1mb3VuZGF0aW9uLm9yZz4KICAg
IENjOiBTaGFvaHVhIExpIDxzaGxpQGZ1c2lvbmlvLmNvbT4KICAgIENjOiBKZW5zIEF4Ym9l
IDxheGJvZUBrZXJuZWwuZGs+CiAgICBDYzogRmFuIER1IDxmYW4uZHVAd2luZHJpdmVyLmNv
bT4KICAgIENjOiBUZWp1biBIZW8gPHRqQGtlcm5lbC5vcmc+CiAgICBDYzogPHN0YWJsZUB2
Z2VyLmtlcm5lbC5vcmc+CiAgICBTaWduZWQtb2ZmLWJ5OiBBbmRyZXcgTW9ydG9uIDxha3Bt
QGxpbnV4LWZvdW5kYXRpb24ub3JnPgoKOjA0MDAwMCAwNDAwMDAgYWQ0NTg1MDVlYmFhM2U4
Nzk4Njc0OWI2ZTQ3OGFmODk0NTRhYTZlZSAxMTBhYjA1NmRkYmZjNDA5ZGNhM2M0OTlhNDVh
YzdmNWQ3ZGNlNGY3IE0JbGliCmJpc2VjdCBydW4gc3VjY2VzcwpscyAtYSAva2VybmVsLXRl
c3RzL3J1bi1xdWV1ZS9rdm0veDg2XzY0LXJhbmRjb25maWctczItMDExMTE2MjgvbmV4dDpt
YXN0ZXI6NTVjYmZkMTVmZDEyNWFhZDY4YjlhOTU4NzQ5YWUyZDNjMTkyZGI5YzpiaXNlY3Qt
dXNiCgoyMDE0LTAxLTExLTIxOjQ3OjMyIDU1Y2JmZDE1ZmQxMjVhYWQ2OGI5YTk1ODc0OWFl
MmQzYzE5MmRiOWMgcmV1c2UgL2tlcm5lbC94ODZfNjQtcmFuZGNvbmZpZy1zMi0wMTExMTYy
OC81NWNiZmQxNWZkMTI1YWFkNjhiOWE5NTg3NDlhZTJkM2MxOTJkYjljL3ZtbGludXotMy4x
My4wLXJjNy0wMDM0Ny1nNTVjYmZkMQoKMjAxNC0wMS0xMS0yMTo0NzozMiBkZXRlY3Rpbmcg
Ym9vdCBzdGF0ZSAuLgkyMgkyNAkzMgkzNgk0MQk0Nwk1Mwk1NQk1OS4JNjAgU1VDQ0VTUwoK
bHMgLWEgL2tlcm5lbC10ZXN0cy9ydW4tcXVldWUva3ZtL3g4Nl82NC1yYW5kY29uZmlnLXMy
LTAxMTExNjI4L25leHQ6bWFzdGVyOjE5NTVhMTRhNWJhNmUzYzNiMTExMTc4MTJkMTFkYzU1
MGNjYzM3YWU6YmlzZWN0LXVzYgogVEVTVCBGQUlMVVJFClsgICAgMC40NjEzNTldIFBDSTog
Q0xTIDAgYnl0ZXMsIGRlZmF1bHQgNjQKWyAgICAwLjQ2MjQzOV0gVW5wYWNraW5nIGluaXRy
YW1mcy4uLgpbICAgIDAuNTM2ODQ0XSAtLS0tLS0tLS0tLS1bIGN1dCBoZXJlIF0tLS0tLS0t
LS0tLS0KWyAgICAwLjUzNzY4MF0gV0FSTklORzogQ1BVOiAxIFBJRDogMSBhdCBrZXJuZWwv
bG9ja2luZy9sb2NrZGVwLmM6MzUzNyBjaGVja19mbGFncysweDc3LzB4MWJhKCkKWyAgICAw
LjU0MDI2Ml0gREVCVUdfTE9DS1NfV0FSTl9PTihjdXJyZW50LT5oYXJkaXJxc19lbmFibGVk
KQpbICAgIDAuNTQwNDIzXSBDUFU6IDEgUElEOiAxIENvbW06IHN3YXBwZXIvMCBOb3QgdGFp
bnRlZCAzLjEzLjAtcmM3LW5leHQtMjAxNDAxMTAtMDg3MzItZzE5NTVhMTQgIzEKWyAgICAw
LjU0MDQyM10gIDAwMDAwMDAwMDAwMDAwMDAgZmZmZjg4MDAwMDA3N2EzMCBmZmZmZmZmZjgx
NTZmMjc3IGZmZmY4ODAwMDAwNzdhNzgKWyAgICAwLjU0MDQyM10gIGZmZmY4ODAwMDAwNzdh
NjggZmZmZmZmZmY4MTA5MWYwYiBmZmZmZmZmZjgxMGM2YmIyIDAwMDAwMDAwMDAwMDAwNDYK
WyAgICAwLjU0MDQyM10gIGZmZmZmZmZmODFhMDYzMTggZmZmZjg4MDAwMDA3N2QxYyAwMDAw
MDAwMDAwMDAwMjg2IGZmZmY4ODAwMDAwNzdhYzgKWyAgICAwLjU0MDQyM10gQ2FsbCBUcmFj
ZToKWyAgICAwLjU0MDQyM10gIFs8ZmZmZmZmZmY4MTU2ZjI3Nz5dIGR1bXBfc3RhY2srMHg0
ZC8weDY2ClsgICAgMC41NDA0MjNdICBbPGZmZmZmZmZmODEwOTFmMGI+XSB3YXJuX3Nsb3dw
YXRoX2NvbW1vbisweDcwLzB4ODkKWyAgICAwLjU0MDQyM10gIFs8ZmZmZmZmZmY4MTBjNmJi
Mj5dID8gY2hlY2tfZmxhZ3MrMHg3Ny8weDFiYQpbICAgIDAuNTQwNDIzXSAgWzxmZmZmZmZm
ZjgxMDkxZjg1Pl0gd2Fybl9zbG93cGF0aF9mbXQrMHg0Ny8weDQ5ClsgICAgMC41NDA0MjNd
ICBbPGZmZmZmZmZmODEwYzZiYjI+XSBjaGVja19mbGFncysweDc3LzB4MWJhClsgICAgMC41
NDA0MjNdICBbPGZmZmZmZmZmODEwY2E1NWE+XSBsb2NrX2FjcXVpcmUrMHg1MC8weGM0Clsg
ICAgMC41NDA0MjNdICBbPGZmZmZmZmZmODExM2U0MTA+XSA/IGZpbmFsX3B1dG5hbWUrMHgy
Zi8weDMyClsgICAgMC41NDA0MjNdICBbPGZmZmZmZmZmODE1N2I5ZTU+XSBfcmF3X3NwaW5f
bG9jaysweDMyLzB4M2YKWyAgICAwLjU0MDQyM10gIFs8ZmZmZmZmZmY4MTFmOTIzOD5dID8g
X19wZXJjcHVfY291bnRlcl9hZGQrMHg0NS8weDczClsgICAgMC41NDA0MjNdICBbPGZmZmZm
ZmZmODExZjkyMzg+XSBfX3BlcmNwdV9jb3VudGVyX2FkZCsweDQ1LzB4NzMKWyAgICAwLjU0
MDQyM10gIFs8ZmZmZmZmZmY4MTEzN2FiZj5dIGdldF9lbXB0eV9maWxwKzB4OTkvMHgxODAK
WyAgICAwLjU0MDQyM10gIFs8ZmZmZmZmZmY4MTE0MjEwZD5dIHBhdGhfb3BlbmF0KzB4Mzkv
MHg1YmUKWyAgICAwLjU0MDQyM10gIFs8ZmZmZmZmZmY4MTEzYTFhZj5dID8gdmZzX2ZzdGF0
YXQrMHg0NC8weDkxClsgICAgMC41NDA0MjNdICBbPGZmZmZmZmZmODFiNmQ0ZDg+XSA/IGlu
aXRyZF9sb2FkKzB4M2YvMHgzZgpbICAgIDAuNTQwNDIzXSAgWzxmZmZmZmZmZjgxMTQyNmM3
Pl0gZG9fZmlscF9vcGVuKzB4MzUvMHg3YQpbICAgIDAuNTQwNDIzXSAgWzxmZmZmZmZmZjgx
NTdiYWZhPl0gPyBfcmF3X3NwaW5fdW5sb2NrKzB4MjIvMHgyZApbICAgIDAuNTQwNDIzXSAg
WzxmZmZmZmZmZjgxMTRmNmJlPl0gPyBfX2FsbG9jX2ZkKzB4MWFjLzB4MWJlClsgICAgMC41
NDA0MjNdICBbPGZmZmZmZmZmODExMzVjOGM+XSBkb19zeXNfb3BlbisweDE0OC8weDFkNwpb
ICAgIDAuNTQwNDIzXSAgWzxmZmZmZmZmZjgxYjZkNGQ4Pl0gPyBpbml0cmRfbG9hZCsweDNm
LzB4M2YKWyAgICAwLjU0MDQyM10gIFs8ZmZmZmZmZmY4MTEzNWQzND5dIFN5U19vcGVuKzB4
MTkvMHgxYgpbICAgIDAuNTQwNDIzXSAgWzxmZmZmZmZmZjgxYjZkZDJkPl0gZG9fbmFtZSsw
eGJiLzB4MjVlClsgICAgMC41NDA0MjNdICBbPGZmZmZmZmZmODFiNmQ2N2Y+XSB3cml0ZV9i
dWZmZXIrMHgyMS8weDMwClsgICAgMC41NDA0MjNdICBbPGZmZmZmZmZmODFiNmQ2Zjc+XSBm
bHVzaF9idWZmZXIrMHg2OS8weDgxClsgICAgMC41NDA0MjNdICBbPGZmZmZmZmZmODFiODk1
M2Y+XSBndW56aXArMHgyNTEvMHgyZTAKWyAgICAwLjU0MDQyM10gIFs8ZmZmZmZmZmY4MWI4
OTJlNT5dID8gZGVjb21wcmVzc19tZXRob2QrMHg1YS8weDVhClsgICAgMC41NDA0MjNdICBb
PGZmZmZmZmZmODFiNmQ2OGU+XSA/IHdyaXRlX2J1ZmZlcisweDMwLzB4MzAKWyAgICAwLjU0
MDQyM10gIFs8ZmZmZmZmZmY4MWI2ZDk4MT5dIHVucGFja190b19yb290ZnMrMHgxMmQvMHgy
NTUKWyAgICAwLjU0MDQyM10gIFs8ZmZmZmZmZmY4MWI2ZDRkOD5dID8gaW5pdHJkX2xvYWQr
MHgzZi8weDNmClsgICAgMC41NDA0MjNdICBbPGZmZmZmZmZmODFiNmUxNzg+XSA/IGRvX2hl
YWRlcisweDEyZC8weDEyZApbICAgIDAuNTQwNDIzXSAgWzxmZmZmZmZmZjgxYjZlMWNlPl0g
cG9wdWxhdGVfcm9vdGZzKzB4NTYvMHgxMDUKWyAgICAwLjU0MDQyM10gIFs8ZmZmZmZmZmY4
MWI2ZTE3OD5dID8gZG9faGVhZGVyKzB4MTJkLzB4MTJkClsgICAgMC41NDA0MjNdICBbPGZm
ZmZmZmZmODFiNmNkNzM+XSBkb19vbmVfaW5pdGNhbGwrMHg4ZS8weDEzOApbICAgIDAuNTQw
NDIzXSAgWzxmZmZmZmZmZjgxMGFiZDAwPl0gPyBwYXJhbV9hcnJheV9zZXQrMHg1Ni8weGY1
ClsgICAgMC41NDA0MjNdICBbPGZmZmZmZmZmODEwYWJmNzQ+XSA/IHBhcnNlX2FyZ3MrMHgx
ODAvMHgyNDgKWyAgICAwLjU0MDQyM10gIFs8ZmZmZmZmZmY4MWI2Y2YzOT5dIGtlcm5lbF9p
bml0X2ZyZWVhYmxlKzB4MTFjLzB4MWE5ClsgICAgMC41NDA0MjNdICBbPGZmZmZmZmZmODFi
NmM2YTY+XSA/IGRvX2Vhcmx5X3BhcmFtKzB4OGEvMHg4YQpbICAgIDAuNTQwNDIzXSAgWzxm
ZmZmZmZmZjgxNTYzNTkzPl0gPyByZXN0X2luaXQrMHgxMzcvMHgxMzcKWyAgICAwLjU0MDQy
M10gIFs8ZmZmZmZmZmY4MTU2MzU5Yz5dIGtlcm5lbF9pbml0KzB4OS8weGZmClsgICAgMC41
NDA0MjNdICBbPGZmZmZmZmZmODE1N2NkMGM+XSByZXRfZnJvbV9mb3JrKzB4N2MvMHhiMApb
ICAgIDAuNTQwNDIzXSAgWzxmZmZmZmZmZjgxNTYzNTkzPl0gPyByZXN0X2luaXQrMHgxMzcv
MHgxMzcKWyAgICAwLjU0MDQyM10gLS0tWyBlbmQgdHJhY2UgYWE1NjM5YzI0MWM0ZWZhNSBd
LS0tClsgICAgMC41NDA0MjNdIHBvc3NpYmxlIHJlYXNvbjogdW5hbm5vdGF0ZWQgaXJxcy1v
ZmYuCi9rZXJuZWwveDg2XzY0LXJhbmRjb25maWctczItMDExMTE2MjgvMTk1NWExNGE1YmE2
ZTNjM2IxMTExNzgxMmQxMWRjNTUwY2NjMzdhZS9kbWVzZy15b2N0by1zbmItMjoyMDE0MDEx
MTE2NDkwOTp4ODZfNjQtcmFuZGNvbmZpZy1zMi0wMTExMTYyODozLjEzLjAtcmM3LW5leHQt
MjAxNDAxMTAtMDg3MzItZzE5NTVhMTQ6MQova2VybmVsL3g4Nl82NC1yYW5kY29uZmlnLXMy
LTAxMTExNjI4LzE5NTVhMTRhNWJhNmUzYzNiMTExMTc4MTJkMTFkYzU1MGNjYzM3YWUvZG1l
c2cteW9jdG8tYXRoZW5zLTk6MjAxNDAxMTExOTQ1NTI6eDg2XzY0LXJhbmRjb25maWctczIt
MDExMTE2Mjg6My4xMy4wLXJjNy1uZXh0LTIwMTQwMTEwLTA4NzMyLWcxOTU1YTE0OjEKL2tl
cm5lbC94ODZfNjQtcmFuZGNvbmZpZy1zMi0wMTExMTYyOC8xOTU1YTE0YTViYTZlM2MzYjEx
MTE3ODEyZDExZGM1NTBjY2MzN2FlL2RtZXNnLXlvY3RvLXdhaW1lYS0zOjIwMTQwMTExMTY0
ODQxOng4Nl82NC1yYW5kY29uZmlnLXMyLTAxMTExNjI4OjMuMTMuMC1yYzctbmV4dC0yMDE0
MDExMC0wODczMi1nMTk1NWExNDoxCi9rZXJuZWwveDg2XzY0LXJhbmRjb25maWctczItMDEx
MTE2MjgvMTk1NWExNGE1YmE2ZTNjM2IxMTExNzgxMmQxMWRjNTUwY2NjMzdhZS9kbWVzZy15
b2N0by1yb2FtLTQ3OjIwMTQwMTExMTk0NTU2Ong4Nl82NC1yYW5kY29uZmlnLXMyLTAxMTEx
NjI4OjMuMTMuMC1yYzctbmV4dC0yMDE0MDExMC0wODczMi1nMTk1NWExNDoxCi9rZXJuZWwv
eDg2XzY0LXJhbmRjb25maWctczItMDExMTE2MjgvMTk1NWExNGE1YmE2ZTNjM2IxMTExNzgx
MmQxMWRjNTUwY2NjMzdhZS9kbWVzZy15b2N0by1hdGhlbnMtMTE6MjAxNDAxMTExNjQ4Mzc6
eDg2XzY0LXJhbmRjb25maWctczItMDExMTE2Mjg6My4xMy4wLXJjNy1uZXh0LTIwMTQwMTEw
LTA4NzMyLWcxOTU1YTE0OjEKL2tlcm5lbC94ODZfNjQtcmFuZGNvbmZpZy1zMi0wMTExMTYy
OC8xOTU1YTE0YTViYTZlM2MzYjExMTE3ODEyZDExZGM1NTBjY2MzN2FlL2RtZXNnLXF1YW50
YWwtd2FpbWVhLTk6MjAxNDAxMTExNjQ3NTI6eDg2XzY0LXJhbmRjb25maWctczItMDExMTE2
Mjg6My4xMy4wLXJjNy1uZXh0LTIwMTQwMTEwLTA4NzMyLWcxOTU1YTE0OjEKL2tlcm5lbC94
ODZfNjQtcmFuZGNvbmZpZy1zMi0wMTExMTYyOC8xOTU1YTE0YTViYTZlM2MzYjExMTE3ODEy
ZDExZGM1NTBjY2MzN2FlL2RtZXNnLXlvY3RvLW5obTQtMToyMDE0MDExMTE2NDg1Mzp4ODZf
NjQtcmFuZGNvbmZpZy1zMi0wMTExMTYyODozLjEzLjAtcmM3LW5leHQtMjAxNDAxMTAtMDg3
MzItZzE5NTVhMTQ6MQova2VybmVsL3g4Nl82NC1yYW5kY29uZmlnLXMyLTAxMTExNjI4LzE5
NTVhMTRhNWJhNmUzYzNiMTExMTc4MTJkMTFkYzU1MGNjYzM3YWUvZG1lc2cteW9jdG8tcm9h
bS0xMzoyMDE0MDExMTE5NDU1Mjp4ODZfNjQtcmFuZGNvbmZpZy1zMi0wMTExMTYyODozLjEz
LjAtcmM3LW5leHQtMjAxNDAxMTAtMDg3MzItZzE5NTVhMTQ6MQova2VybmVsL3g4Nl82NC1y
YW5kY29uZmlnLXMyLTAxMTExNjI4LzE5NTVhMTRhNWJhNmUzYzNiMTExMTc4MTJkMTFkYzU1
MGNjYzM3YWUvZG1lc2ctcXVhbnRhbC1zbmItMjY6MjAxNDAxMTExOTQ0NDg6eDg2XzY0LXJh
bmRjb25maWctczItMDExMTE2Mjg6My4xMy4wLXJjNy1uZXh0LTIwMTQwMTEwLTA4NzMyLWcx
OTU1YTE0OjEKL2tlcm5lbC94ODZfNjQtcmFuZGNvbmZpZy1zMi0wMTExMTYyOC8xOTU1YTE0
YTViYTZlM2MzYjExMTE3ODEyZDExZGM1NTBjY2MzN2FlL2RtZXNnLXF1YW50YWwtYXRoZW5z
LTEwOjIwMTQwMTExMTY0NzMxOng4Nl82NC1yYW5kY29uZmlnLXMyLTAxMTExNjI4OjMuMTMu
MC1yYzctbmV4dC0yMDE0MDExMC0wODczMi1nMTk1NWExNDoxCi9rZXJuZWwveDg2XzY0LXJh
bmRjb25maWctczItMDExMTE2MjgvMTk1NWExNGE1YmE2ZTNjM2IxMTExNzgxMmQxMWRjNTUw
Y2NjMzdhZS9kbWVzZy1xdWFudGFsLXNuYi0xNzoyMDE0MDExMTE5NDQ1Njp4ODZfNjQtcmFu
ZGNvbmZpZy1zMi0wMTExMTYyODozLjEzLjAtcmM3LW5leHQtMjAxNDAxMTAtMDg3MzItZzE5
NTVhMTQ6MQova2VybmVsL3g4Nl82NC1yYW5kY29uZmlnLXMyLTAxMTExNjI4LzE5NTVhMTRh
NWJhNmUzYzNiMTExMTc4MTJkMTFkYzU1MGNjYzM3YWUvZG1lc2cteW9jdG8tY2Fpcm8tNDQ6
MjAxNDAxMTExNjQ4NTc6eDg2XzY0LXJhbmRjb25maWctczItMDExMTE2Mjg6My4xMy4wLXJj
Ny1uZXh0LTIwMTQwMTEwLTA4NzMyLWcxOTU1YTE0OjEKL2tlcm5lbC94ODZfNjQtcmFuZGNv
bmZpZy1zMi0wMTExMTYyOC8xOTU1YTE0YTViYTZlM2MzYjExMTE3ODEyZDExZGM1NTBjY2Mz
N2FlL2RtZXNnLXF1YW50YWwtYXRoZW5zLTE0OjIwMTQwMTExMTk0NjE0Ong4Nl82NC1yYW5k
Y29uZmlnLXMyLTAxMTExNjI4OjMuMTMuMC1yYzctbmV4dC0yMDE0MDExMC0wODczMi1nMTk1
NWExNDoxCi9rZXJuZWwveDg2XzY0LXJhbmRjb25maWctczItMDExMTE2MjgvMTk1NWExNGE1
YmE2ZTNjM2IxMTExNzgxMmQxMWRjNTUwY2NjMzdhZS9kbWVzZy15b2N0by1jYWlyby0xMDoy
MDE0MDExMTE5NDU1Njp4ODZfNjQtcmFuZGNvbmZpZy1zMi0wMTExMTYyODozLjEzLjAtcmM3
LW5leHQtMjAxNDAxMTAtMDg3MzItZzE5NTVhMTQ6MQova2VybmVsL3g4Nl82NC1yYW5kY29u
ZmlnLXMyLTAxMTExNjI4LzE5NTVhMTRhNWJhNmUzYzNiMTExMTc4MTJkMTFkYzU1MGNjYzM3
YWUvZG1lc2cteW9jdG8taW5uLTM3OjIwMTQwMTExMTk0NTU2Ong4Nl82NC1yYW5kY29uZmln
LXMyLTAxMTExNjI4OjMuMTMuMC1yYzctbmV4dC0yMDE0MDExMC0wODczMi1nMTk1NWExNDox
Ci9rZXJuZWwveDg2XzY0LXJhbmRjb25maWctczItMDExMTE2MjgvMTk1NWExNGE1YmE2ZTNj
M2IxMTExNzgxMmQxMWRjNTUwY2NjMzdhZS9kbWVzZy1xdWFudGFsLXJvYW0tNDE6MjAxNDAx
MTExOTQ2MTQ6eDg2XzY0LXJhbmRjb25maWctczItMDExMTE2Mjg6My4xMy4wLXJjNy1uZXh0
LTIwMTQwMTEwLTA4NzMyLWcxOTU1YTE0OjEKL2tlcm5lbC94ODZfNjQtcmFuZGNvbmZpZy1z
Mi0wMTExMTYyOC8xOTU1YTE0YTViYTZlM2MzYjExMTE3ODEyZDExZGM1NTBjY2MzN2FlL2Rt
ZXNnLXlvY3RvLXNuYi0yMjoyMDE0MDExMTE5NDcxOTp4ODZfNjQtcmFuZGNvbmZpZy1zMi0w
MTExMTYyODozLjEzLjAtcmM3LW5leHQtMjAxNDAxMTAtMDg3MzItZzE5NTVhMTQ6MQova2Vy
bmVsL3g4Nl82NC1yYW5kY29uZmlnLXMyLTAxMTExNjI4LzE5NTVhMTRhNWJhNmUzYzNiMTEx
MTc4MTJkMTFkYzU1MGNjYzM3YWUvZG1lc2ctcXVhbnRhbC1hdGhlbnMtNToyMDE0MDExMTE2
NDczODp4ODZfNjQtcmFuZGNvbmZpZy1zMi0wMTExMTYyODozLjEzLjAtcmM3LW5leHQtMjAx
NDAxMTAtMDg3MzItZzE5NTVhMTQ6MQova2VybmVsL3g4Nl82NC1yYW5kY29uZmlnLXMyLTAx
MTExNjI4LzE5NTVhMTRhNWJhNmUzYzNiMTExMTc4MTJkMTFkYzU1MGNjYzM3YWUvZG1lc2ct
cXVhbnRhbC1jYWlyby02OjIwMTQwMTExMTY0NzQ3Ong4Nl82NC1yYW5kY29uZmlnLXMyLTAx
MTExNjI4OjMuMTMuMC1yYzctbmV4dC0yMDE0MDExMC0wODczMi1nMTk1NWExNDoxCjA6MTk6
MTkgYWxsX2dvb2Q6YmFkOmFsbF9iYWQgYm9vdHMKCltkZXRhY2hlZCBIRUFEIDAwNWQ0NGVd
IFJldmVydCAibGliL3BlcmNwdV9jb3VudGVyLmM6IGRpc2FibGUgbG9jYWwgaXJxIHdoZW4g
dXBkYXRpbmcgcGVyY3B1IGNvdXRlciIKIDEgZmlsZSBjaGFuZ2VkLCA1IGluc2VydGlvbnMo
KyksIDUgZGVsZXRpb25zKC0pCmxzIC1hIC9rZXJuZWwtdGVzdHMvcnVuLXF1ZXVlL2t2bS94
ODZfNjQtcmFuZGNvbmZpZy1zMi0wMTExMTYyOC9uZXh0Om1hc3RlcjowMDVkNDRlODEzMDQ4
YWFlMGFlNjgzZjU5MDJjYTgyM2I2MTZkMDAyOmJpc2VjdC11c2IKCjIwMTQtMDEtMTEtMjE6
NTQ6MTQgMDA1ZDQ0ZTgxMzA0OGFhZTBhZTY4M2Y1OTAyY2E4MjNiNjE2ZDAwMiBjb21waWxp
bmcKCjIwMTQtMDEtMTEtMjE6NTg6MDkgZGV0ZWN0aW5nIGJvb3Qgc3RhdGUgMy4xMy4wLXJj
Ny1uZXh0LTIwMTQwMTEwLTA4NzMzLWcwMDVkNDRlLi4JMwk1CTgJMTIJMTQJMTYJMTgJMjEJ
MjYJMjkJMzAuLi4JMzEJMzQJNDQJNTQJNTUJNTYJNjAgU1VDQ0VTUwoKCj09PT09PT09PSB1
cHN0cmVhbSA9PT09PT09PT0KbHMgLWEgL2tlcm5lbC10ZXN0cy9ydW4tcXVldWUva3ZtL3g4
Nl82NC1yYW5kY29uZmlnLXMyLTAxMTExNjI4L25leHQ6bWFzdGVyOjIyOGZkYzA4M2IwMTdl
YWY5MGU1NzhmYTg2ZmIxZWNmZDVmZmFlODc6YmlzZWN0LXVzYgoKMjAxNC0wMS0xMS0yMjow
OTo0NiAyMjhmZGMwODNiMDE3ZWFmOTBlNTc4ZmE4NmZiMWVjZmQ1ZmZhZTg3IGNvbXBpbGlu
ZwoKMjAxNC0wMS0xMS0yMjoxNTo1MCBkZXRlY3RpbmcgYm9vdCBzdGF0ZSAzLjEzLjAtcmM3
LTAwMTI2LWcyMjhmZGMwLgkxLgkzCTQJOAk5CTE2CTE4CTIyCTIzCTMzCTM0CTM2CTM4CTQx
CTQ2CTUwCTU1CTU2CTYwIFNVQ0NFU1MKCgo9PT09PT09PT0gbGludXgtbmV4dCA9PT09PT09
PT0KbHMgLWEgL2tlcm5lbC10ZXN0cy9ydW4tcXVldWUva3ZtL3g4Nl82NC1yYW5kY29uZmln
LXMyLTAxMTExNjI4L25leHQ6bWFzdGVyOjE5NTVhMTRhNWJhNmUzYzNiMTExMTc4MTJkMTFk
YzU1MGNjYzM3YWU6YmlzZWN0LXVzYgogVEVTVCBGQUlMVVJFClsgICAgMC40NjEzNTldIFBD
STogQ0xTIDAgYnl0ZXMsIGRlZmF1bHQgNjQKWyAgICAwLjQ2MjQzOV0gVW5wYWNraW5nIGlu
aXRyYW1mcy4uLgpbICAgIDAuNTM2ODQ0XSAtLS0tLS0tLS0tLS1bIGN1dCBoZXJlIF0tLS0t
LS0tLS0tLS0KWyAgICAwLjUzNzY4MF0gV0FSTklORzogQ1BVOiAxIFBJRDogMSBhdCBrZXJu
ZWwvbG9ja2luZy9sb2NrZGVwLmM6MzUzNyBjaGVja19mbGFncysweDc3LzB4MWJhKCkKWyAg
ICAwLjU0MDI2Ml0gREVCVUdfTE9DS1NfV0FSTl9PTihjdXJyZW50LT5oYXJkaXJxc19lbmFi
bGVkKQpbICAgIDAuNTQwNDIzXSBDUFU6IDEgUElEOiAxIENvbW06IHN3YXBwZXIvMCBOb3Qg
dGFpbnRlZCAzLjEzLjAtcmM3LW5leHQtMjAxNDAxMTAtMDg3MzItZzE5NTVhMTQgIzEKWyAg
ICAwLjU0MDQyM10gIDAwMDAwMDAwMDAwMDAwMDAgZmZmZjg4MDAwMDA3N2EzMCBmZmZmZmZm
ZjgxNTZmMjc3IGZmZmY4ODAwMDAwNzdhNzgKWyAgICAwLjU0MDQyM10gIGZmZmY4ODAwMDAw
NzdhNjggZmZmZmZmZmY4MTA5MWYwYiBmZmZmZmZmZjgxMGM2YmIyIDAwMDAwMDAwMDAwMDAw
NDYKWyAgICAwLjU0MDQyM10gIGZmZmZmZmZmODFhMDYzMTggZmZmZjg4MDAwMDA3N2QxYyAw
MDAwMDAwMDAwMDAwMjg2IGZmZmY4ODAwMDAwNzdhYzgKWyAgICAwLjU0MDQyM10gQ2FsbCBU
cmFjZToKWyAgICAwLjU0MDQyM10gIFs8ZmZmZmZmZmY4MTU2ZjI3Nz5dIGR1bXBfc3RhY2sr
MHg0ZC8weDY2ClsgICAgMC41NDA0MjNdICBbPGZmZmZmZmZmODEwOTFmMGI+XSB3YXJuX3Ns
b3dwYXRoX2NvbW1vbisweDcwLzB4ODkKWyAgICAwLjU0MDQyM10gIFs8ZmZmZmZmZmY4MTBj
NmJiMj5dID8gY2hlY2tfZmxhZ3MrMHg3Ny8weDFiYQpbICAgIDAuNTQwNDIzXSAgWzxmZmZm
ZmZmZjgxMDkxZjg1Pl0gd2Fybl9zbG93cGF0aF9mbXQrMHg0Ny8weDQ5ClsgICAgMC41NDA0
MjNdICBbPGZmZmZmZmZmODEwYzZiYjI+XSBjaGVja19mbGFncysweDc3LzB4MWJhClsgICAg
MC41NDA0MjNdICBbPGZmZmZmZmZmODEwY2E1NWE+XSBsb2NrX2FjcXVpcmUrMHg1MC8weGM0
ClsgICAgMC41NDA0MjNdICBbPGZmZmZmZmZmODExM2U0MTA+XSA/IGZpbmFsX3B1dG5hbWUr
MHgyZi8weDMyClsgICAgMC41NDA0MjNdICBbPGZmZmZmZmZmODE1N2I5ZTU+XSBfcmF3X3Nw
aW5fbG9jaysweDMyLzB4M2YKWyAgICAwLjU0MDQyM10gIFs8ZmZmZmZmZmY4MTFmOTIzOD5d
ID8gX19wZXJjcHVfY291bnRlcl9hZGQrMHg0NS8weDczClsgICAgMC41NDA0MjNdICBbPGZm
ZmZmZmZmODExZjkyMzg+XSBfX3BlcmNwdV9jb3VudGVyX2FkZCsweDQ1LzB4NzMKWyAgICAw
LjU0MDQyM10gIFs8ZmZmZmZmZmY4MTEzN2FiZj5dIGdldF9lbXB0eV9maWxwKzB4OTkvMHgx
ODAKWyAgICAwLjU0MDQyM10gIFs8ZmZmZmZmZmY4MTE0MjEwZD5dIHBhdGhfb3BlbmF0KzB4
MzkvMHg1YmUKWyAgICAwLjU0MDQyM10gIFs8ZmZmZmZmZmY4MTEzYTFhZj5dID8gdmZzX2Zz
dGF0YXQrMHg0NC8weDkxClsgICAgMC41NDA0MjNdICBbPGZmZmZmZmZmODFiNmQ0ZDg+XSA/
IGluaXRyZF9sb2FkKzB4M2YvMHgzZgpbICAgIDAuNTQwNDIzXSAgWzxmZmZmZmZmZjgxMTQy
NmM3Pl0gZG9fZmlscF9vcGVuKzB4MzUvMHg3YQpbICAgIDAuNTQwNDIzXSAgWzxmZmZmZmZm
ZjgxNTdiYWZhPl0gPyBfcmF3X3NwaW5fdW5sb2NrKzB4MjIvMHgyZApbICAgIDAuNTQwNDIz
XSAgWzxmZmZmZmZmZjgxMTRmNmJlPl0gPyBfX2FsbG9jX2ZkKzB4MWFjLzB4MWJlClsgICAg
MC41NDA0MjNdICBbPGZmZmZmZmZmODExMzVjOGM+XSBkb19zeXNfb3BlbisweDE0OC8weDFk
NwpbICAgIDAuNTQwNDIzXSAgWzxmZmZmZmZmZjgxYjZkNGQ4Pl0gPyBpbml0cmRfbG9hZCsw
eDNmLzB4M2YKWyAgICAwLjU0MDQyM10gIFs8ZmZmZmZmZmY4MTEzNWQzND5dIFN5U19vcGVu
KzB4MTkvMHgxYgpbICAgIDAuNTQwNDIzXSAgWzxmZmZmZmZmZjgxYjZkZDJkPl0gZG9fbmFt
ZSsweGJiLzB4MjVlClsgICAgMC41NDA0MjNdICBbPGZmZmZmZmZmODFiNmQ2N2Y+XSB3cml0
ZV9idWZmZXIrMHgyMS8weDMwClsgICAgMC41NDA0MjNdICBbPGZmZmZmZmZmODFiNmQ2Zjc+
XSBmbHVzaF9idWZmZXIrMHg2OS8weDgxClsgICAgMC41NDA0MjNdICBbPGZmZmZmZmZmODFi
ODk1M2Y+XSBndW56aXArMHgyNTEvMHgyZTAKWyAgICAwLjU0MDQyM10gIFs8ZmZmZmZmZmY4
MWI4OTJlNT5dID8gZGVjb21wcmVzc19tZXRob2QrMHg1YS8weDVhClsgICAgMC41NDA0MjNd
ICBbPGZmZmZmZmZmODFiNmQ2OGU+XSA/IHdyaXRlX2J1ZmZlcisweDMwLzB4MzAKWyAgICAw
LjU0MDQyM10gIFs8ZmZmZmZmZmY4MWI2ZDk4MT5dIHVucGFja190b19yb290ZnMrMHgxMmQv
MHgyNTUKWyAgICAwLjU0MDQyM10gIFs8ZmZmZmZmZmY4MWI2ZDRkOD5dID8gaW5pdHJkX2xv
YWQrMHgzZi8weDNmClsgICAgMC41NDA0MjNdICBbPGZmZmZmZmZmODFiNmUxNzg+XSA/IGRv
X2hlYWRlcisweDEyZC8weDEyZApbICAgIDAuNTQwNDIzXSAgWzxmZmZmZmZmZjgxYjZlMWNl
Pl0gcG9wdWxhdGVfcm9vdGZzKzB4NTYvMHgxMDUKWyAgICAwLjU0MDQyM10gIFs8ZmZmZmZm
ZmY4MWI2ZTE3OD5dID8gZG9faGVhZGVyKzB4MTJkLzB4MTJkClsgICAgMC41NDA0MjNdICBb
PGZmZmZmZmZmODFiNmNkNzM+XSBkb19vbmVfaW5pdGNhbGwrMHg4ZS8weDEzOApbICAgIDAu
NTQwNDIzXSAgWzxmZmZmZmZmZjgxMGFiZDAwPl0gPyBwYXJhbV9hcnJheV9zZXQrMHg1Ni8w
eGY1ClsgICAgMC41NDA0MjNdICBbPGZmZmZmZmZmODEwYWJmNzQ+XSA/IHBhcnNlX2FyZ3Mr
MHgxODAvMHgyNDgKWyAgICAwLjU0MDQyM10gIFs8ZmZmZmZmZmY4MWI2Y2YzOT5dIGtlcm5l
bF9pbml0X2ZyZWVhYmxlKzB4MTFjLzB4MWE5ClsgICAgMC41NDA0MjNdICBbPGZmZmZmZmZm
ODFiNmM2YTY+XSA/IGRvX2Vhcmx5X3BhcmFtKzB4OGEvMHg4YQpbICAgIDAuNTQwNDIzXSAg
WzxmZmZmZmZmZjgxNTYzNTkzPl0gPyByZXN0X2luaXQrMHgxMzcvMHgxMzcKWyAgICAwLjU0
MDQyM10gIFs8ZmZmZmZmZmY4MTU2MzU5Yz5dIGtlcm5lbF9pbml0KzB4OS8weGZmClsgICAg
MC41NDA0MjNdICBbPGZmZmZmZmZmODE1N2NkMGM+XSByZXRfZnJvbV9mb3JrKzB4N2MvMHhi
MApbICAgIDAuNTQwNDIzXSAgWzxmZmZmZmZmZjgxNTYzNTkzPl0gPyByZXN0X2luaXQrMHgx
MzcvMHgxMzcKWyAgICAwLjU0MDQyM10gLS0tWyBlbmQgdHJhY2UgYWE1NjM5YzI0MWM0ZWZh
NSBdLS0tClsgICAgMC41NDA0MjNdIHBvc3NpYmxlIHJlYXNvbjogdW5hbm5vdGF0ZWQgaXJx
cy1vZmYuCi9rZXJuZWwveDg2XzY0LXJhbmRjb25maWctczItMDExMTE2MjgvMTk1NWExNGE1
YmE2ZTNjM2IxMTExNzgxMmQxMWRjNTUwY2NjMzdhZS9kbWVzZy15b2N0by1zbmItMjoyMDE0
MDExMTE2NDkwOTp4ODZfNjQtcmFuZGNvbmZpZy1zMi0wMTExMTYyODozLjEzLjAtcmM3LW5l
eHQtMjAxNDAxMTAtMDg3MzItZzE5NTVhMTQ6MQova2VybmVsL3g4Nl82NC1yYW5kY29uZmln
LXMyLTAxMTExNjI4LzE5NTVhMTRhNWJhNmUzYzNiMTExMTc4MTJkMTFkYzU1MGNjYzM3YWUv
ZG1lc2cteW9jdG8tYXRoZW5zLTk6MjAxNDAxMTExOTQ1NTI6eDg2XzY0LXJhbmRjb25maWct
czItMDExMTE2Mjg6My4xMy4wLXJjNy1uZXh0LTIwMTQwMTEwLTA4NzMyLWcxOTU1YTE0OjEK
L2tlcm5lbC94ODZfNjQtcmFuZGNvbmZpZy1zMi0wMTExMTYyOC8xOTU1YTE0YTViYTZlM2Mz
YjExMTE3ODEyZDExZGM1NTBjY2MzN2FlL2RtZXNnLXlvY3RvLXdhaW1lYS0zOjIwMTQwMTEx
MTY0ODQxOng4Nl82NC1yYW5kY29uZmlnLXMyLTAxMTExNjI4OjMuMTMuMC1yYzctbmV4dC0y
MDE0MDExMC0wODczMi1nMTk1NWExNDoxCi9rZXJuZWwveDg2XzY0LXJhbmRjb25maWctczIt
MDExMTE2MjgvMTk1NWExNGE1YmE2ZTNjM2IxMTExNzgxMmQxMWRjNTUwY2NjMzdhZS9kbWVz
Zy15b2N0by1yb2FtLTQ3OjIwMTQwMTExMTk0NTU2Ong4Nl82NC1yYW5kY29uZmlnLXMyLTAx
MTExNjI4OjMuMTMuMC1yYzctbmV4dC0yMDE0MDExMC0wODczMi1nMTk1NWExNDoxCi9rZXJu
ZWwveDg2XzY0LXJhbmRjb25maWctczItMDExMTE2MjgvMTk1NWExNGE1YmE2ZTNjM2IxMTEx
NzgxMmQxMWRjNTUwY2NjMzdhZS9kbWVzZy15b2N0by1hdGhlbnMtMTE6MjAxNDAxMTExNjQ4
Mzc6eDg2XzY0LXJhbmRjb25maWctczItMDExMTE2Mjg6My4xMy4wLXJjNy1uZXh0LTIwMTQw
MTEwLTA4NzMyLWcxOTU1YTE0OjEKL2tlcm5lbC94ODZfNjQtcmFuZGNvbmZpZy1zMi0wMTEx
MTYyOC8xOTU1YTE0YTViYTZlM2MzYjExMTE3ODEyZDExZGM1NTBjY2MzN2FlL2RtZXNnLXF1
YW50YWwtd2FpbWVhLTk6MjAxNDAxMTExNjQ3NTI6eDg2XzY0LXJhbmRjb25maWctczItMDEx
MTE2Mjg6My4xMy4wLXJjNy1uZXh0LTIwMTQwMTEwLTA4NzMyLWcxOTU1YTE0OjEKL2tlcm5l
bC94ODZfNjQtcmFuZGNvbmZpZy1zMi0wMTExMTYyOC8xOTU1YTE0YTViYTZlM2MzYjExMTE3
ODEyZDExZGM1NTBjY2MzN2FlL2RtZXNnLXlvY3RvLW5obTQtMToyMDE0MDExMTE2NDg1Mzp4
ODZfNjQtcmFuZGNvbmZpZy1zMi0wMTExMTYyODozLjEzLjAtcmM3LW5leHQtMjAxNDAxMTAt
MDg3MzItZzE5NTVhMTQ6MQova2VybmVsL3g4Nl82NC1yYW5kY29uZmlnLXMyLTAxMTExNjI4
LzE5NTVhMTRhNWJhNmUzYzNiMTExMTc4MTJkMTFkYzU1MGNjYzM3YWUvZG1lc2cteW9jdG8t
cm9hbS0xMzoyMDE0MDExMTE5NDU1Mjp4ODZfNjQtcmFuZGNvbmZpZy1zMi0wMTExMTYyODoz
LjEzLjAtcmM3LW5leHQtMjAxNDAxMTAtMDg3MzItZzE5NTVhMTQ6MQova2VybmVsL3g4Nl82
NC1yYW5kY29uZmlnLXMyLTAxMTExNjI4LzE5NTVhMTRhNWJhNmUzYzNiMTExMTc4MTJkMTFk
YzU1MGNjYzM3YWUvZG1lc2ctcXVhbnRhbC1zbmItMjY6MjAxNDAxMTExOTQ0NDg6eDg2XzY0
LXJhbmRjb25maWctczItMDExMTE2Mjg6My4xMy4wLXJjNy1uZXh0LTIwMTQwMTEwLTA4NzMy
LWcxOTU1YTE0OjEKL2tlcm5lbC94ODZfNjQtcmFuZGNvbmZpZy1zMi0wMTExMTYyOC8xOTU1
YTE0YTViYTZlM2MzYjExMTE3ODEyZDExZGM1NTBjY2MzN2FlL2RtZXNnLXF1YW50YWwtYXRo
ZW5zLTEwOjIwMTQwMTExMTY0NzMxOng4Nl82NC1yYW5kY29uZmlnLXMyLTAxMTExNjI4OjMu
MTMuMC1yYzctbmV4dC0yMDE0MDExMC0wODczMi1nMTk1NWExNDoxCi9rZXJuZWwveDg2XzY0
LXJhbmRjb25maWctczItMDExMTE2MjgvMTk1NWExNGE1YmE2ZTNjM2IxMTExNzgxMmQxMWRj
NTUwY2NjMzdhZS9kbWVzZy1xdWFudGFsLXNuYi0xNzoyMDE0MDExMTE5NDQ1Njp4ODZfNjQt
cmFuZGNvbmZpZy1zMi0wMTExMTYyODozLjEzLjAtcmM3LW5leHQtMjAxNDAxMTAtMDg3MzIt
ZzE5NTVhMTQ6MQova2VybmVsL3g4Nl82NC1yYW5kY29uZmlnLXMyLTAxMTExNjI4LzE5NTVh
MTRhNWJhNmUzYzNiMTExMTc4MTJkMTFkYzU1MGNjYzM3YWUvZG1lc2cteW9jdG8tY2Fpcm8t
NDQ6MjAxNDAxMTExNjQ4NTc6eDg2XzY0LXJhbmRjb25maWctczItMDExMTE2Mjg6My4xMy4w
LXJjNy1uZXh0LTIwMTQwMTEwLTA4NzMyLWcxOTU1YTE0OjEKL2tlcm5lbC94ODZfNjQtcmFu
ZGNvbmZpZy1zMi0wMTExMTYyOC8xOTU1YTE0YTViYTZlM2MzYjExMTE3ODEyZDExZGM1NTBj
Y2MzN2FlL2RtZXNnLXF1YW50YWwtYXRoZW5zLTE0OjIwMTQwMTExMTk0NjE0Ong4Nl82NC1y
YW5kY29uZmlnLXMyLTAxMTExNjI4OjMuMTMuMC1yYzctbmV4dC0yMDE0MDExMC0wODczMi1n
MTk1NWExNDoxCi9rZXJuZWwveDg2XzY0LXJhbmRjb25maWctczItMDExMTE2MjgvMTk1NWEx
NGE1YmE2ZTNjM2IxMTExNzgxMmQxMWRjNTUwY2NjMzdhZS9kbWVzZy15b2N0by1jYWlyby0x
MDoyMDE0MDExMTE5NDU1Njp4ODZfNjQtcmFuZGNvbmZpZy1zMi0wMTExMTYyODozLjEzLjAt
cmM3LW5leHQtMjAxNDAxMTAtMDg3MzItZzE5NTVhMTQ6MQova2VybmVsL3g4Nl82NC1yYW5k
Y29uZmlnLXMyLTAxMTExNjI4LzE5NTVhMTRhNWJhNmUzYzNiMTExMTc4MTJkMTFkYzU1MGNj
YzM3YWUvZG1lc2cteW9jdG8taW5uLTM3OjIwMTQwMTExMTk0NTU2Ong4Nl82NC1yYW5kY29u
ZmlnLXMyLTAxMTExNjI4OjMuMTMuMC1yYzctbmV4dC0yMDE0MDExMC0wODczMi1nMTk1NWEx
NDoxCi9rZXJuZWwveDg2XzY0LXJhbmRjb25maWctczItMDExMTE2MjgvMTk1NWExNGE1YmE2
ZTNjM2IxMTExNzgxMmQxMWRjNTUwY2NjMzdhZS9kbWVzZy1xdWFudGFsLXJvYW0tNDE6MjAx
NDAxMTExOTQ2MTQ6eDg2XzY0LXJhbmRjb25maWctczItMDExMTE2Mjg6My4xMy4wLXJjNy1u
ZXh0LTIwMTQwMTEwLTA4NzMyLWcxOTU1YTE0OjEKL2tlcm5lbC94ODZfNjQtcmFuZGNvbmZp
Zy1zMi0wMTExMTYyOC8xOTU1YTE0YTViYTZlM2MzYjExMTE3ODEyZDExZGM1NTBjY2MzN2Fl
L2RtZXNnLXlvY3RvLXNuYi0yMjoyMDE0MDExMTE5NDcxOTp4ODZfNjQtcmFuZGNvbmZpZy1z
Mi0wMTExMTYyODozLjEzLjAtcmM3LW5leHQtMjAxNDAxMTAtMDg3MzItZzE5NTVhMTQ6MQov
a2VybmVsL3g4Nl82NC1yYW5kY29uZmlnLXMyLTAxMTExNjI4LzE5NTVhMTRhNWJhNmUzYzNi
MTExMTc4MTJkMTFkYzU1MGNjYzM3YWUvZG1lc2ctcXVhbnRhbC1hdGhlbnMtNToyMDE0MDEx
MTE2NDczODp4ODZfNjQtcmFuZGNvbmZpZy1zMi0wMTExMTYyODozLjEzLjAtcmM3LW5leHQt
MjAxNDAxMTAtMDg3MzItZzE5NTVhMTQ6MQova2VybmVsL3g4Nl82NC1yYW5kY29uZmlnLXMy
LTAxMTExNjI4LzE5NTVhMTRhNWJhNmUzYzNiMTExMTc4MTJkMTFkYzU1MGNjYzM3YWUvZG1l
c2ctcXVhbnRhbC1jYWlyby02OjIwMTQwMTExMTY0NzQ3Ong4Nl82NC1yYW5kY29uZmlnLXMy
LTAxMTExNjI4OjMuMTMuMC1yYzctbmV4dC0yMDE0MDExMC0wODczMi1nMTk1NWExNDoxCjA6
MTk6MTkgYWxsX2dvb2Q6YmFkOmFsbF9iYWQgYm9vdHMKCg==

--/9DWx/yDrRhgMJTb
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="config-3.13.0-rc7-next-20140110-08732-g1955a14"

#
# Automatically generated file; DO NOT EDIT.
# Linux/x86_64 3.13.0-rc7 Kernel Configuration
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
CONFIG_CONSTRUCTORS=y
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
# CONFIG_KERNEL_BZIP2 is not set
# CONFIG_KERNEL_LZMA is not set
CONFIG_KERNEL_XZ=y
# CONFIG_KERNEL_LZO is not set
# CONFIG_KERNEL_LZ4 is not set
CONFIG_DEFAULT_HOSTNAME="(none)"
# CONFIG_SYSVIPC is not set
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
# CONFIG_NO_HZ is not set
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
CONFIG_TREE_RCU=y
# CONFIG_PREEMPT_RCU is not set
CONFIG_RCU_STALL_COMMON=y
CONFIG_CONTEXT_TRACKING=y
CONFIG_RCU_USER_QS=y
CONFIG_CONTEXT_TRACKING_FORCE=y
CONFIG_RCU_FANOUT=64
CONFIG_RCU_FANOUT_LEAF=16
# CONFIG_RCU_FANOUT_EXACT is not set
# CONFIG_RCU_FAST_NO_HZ is not set
CONFIG_TREE_RCU_TRACE=y
# CONFIG_RCU_NOCB_CPU is not set
CONFIG_IKCONFIG=y
# CONFIG_IKCONFIG_PROC is not set
CONFIG_LOG_BUF_SHIFT=17
CONFIG_HAVE_UNSTABLE_SCHED_CLOCK=y
CONFIG_ARCH_SUPPORTS_NUMA_BALANCING=y
CONFIG_ARCH_SUPPORTS_INT128=y
CONFIG_ARCH_WANTS_PROT_NUMA_PROT_NONE=y
CONFIG_CGROUPS=y
# CONFIG_CGROUP_DEBUG is not set
CONFIG_CGROUP_FREEZER=y
CONFIG_CGROUP_DEVICE=y
# CONFIG_CPUSETS is not set
# CONFIG_CGROUP_CPUACCT is not set
# CONFIG_RESOURCE_COUNTERS is not set
CONFIG_CGROUP_PERF=y
# CONFIG_CGROUP_SCHED is not set
CONFIG_CHECKPOINT_RESTORE=y
CONFIG_NAMESPACES=y
# CONFIG_UTS_NS is not set
# CONFIG_USER_NS is not set
# CONFIG_PID_NS is not set
CONFIG_NET_NS=y
CONFIG_UIDGID_STRICT_TYPE_CHECKS=y
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
CONFIG_KALLSYMS=y
CONFIG_KALLSYMS_ALL=y
CONFIG_PRINTK=y
CONFIG_BUG=y
CONFIG_PCSPKR_PLATFORM=y
# CONFIG_BASE_FULL is not set
CONFIG_FUTEX=y
# CONFIG_EPOLL is not set
CONFIG_SIGNALFD=y
# CONFIG_TIMERFD is not set
# CONFIG_EVENTFD is not set
# CONFIG_SHMEM is not set
# CONFIG_AIO is not set
CONFIG_PCI_QUIRKS=y
CONFIG_EMBEDDED=y
CONFIG_HAVE_PERF_EVENTS=y
CONFIG_PERF_USE_VMALLOC=y

#
# Kernel Performance Events And Counters
#
CONFIG_PERF_EVENTS=y
CONFIG_DEBUG_PERF_USE_VMALLOC=y
CONFIG_VM_EVENT_COUNTERS=y
# CONFIG_SLUB_DEBUG is not set
CONFIG_COMPAT_BRK=y
# CONFIG_SLAB is not set
CONFIG_SLUB=y
# CONFIG_SLOB is not set
# CONFIG_SLUB_CPU_PARTIAL is not set
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
CONFIG_GCOV_FORMAT_AUTODETECT=y
# CONFIG_GCOV_FORMAT_3_4 is not set
# CONFIG_GCOV_FORMAT_4_7 is not set
# CONFIG_HAVE_GENERIC_DMA_COHERENT is not set
CONFIG_RT_MUTEXES=y
CONFIG_BASE_SMALL=1
# CONFIG_MODULES is not set
CONFIG_STOP_MACHINE=y
# CONFIG_BLOCK is not set
CONFIG_PADATA=y
CONFIG_UNINLINE_SPIN_UNLOCK=y
CONFIG_FREEZER=y

#
# Processor type and features
#
# CONFIG_ZONE_DMA is not set
CONFIG_SMP=y
# CONFIG_X86_MPPARSE is not set
CONFIG_X86_EXTENDED_PLATFORM=y
# CONFIG_X86_VSMP is not set
# CONFIG_X86_INTEL_LPSS is not set
CONFIG_X86_SUPPORTS_MEMORY_FAILURE=y
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
CONFIG_PROCESSOR_SELECT=y
CONFIG_CPU_SUP_INTEL=y
CONFIG_CPU_SUP_AMD=y
# CONFIG_CPU_SUP_CENTAUR is not set
CONFIG_HPET_TIMER=y
# CONFIG_DMI is not set
# CONFIG_GART_IOMMU is not set
# CONFIG_CALGARY_IOMMU is not set
CONFIG_SWIOTLB=y
CONFIG_IOMMU_HELPER=y
CONFIG_MAXSMP=y
CONFIG_NR_CPUS=8192
# CONFIG_SCHED_SMT is not set
CONFIG_SCHED_MC=y
# CONFIG_PREEMPT_NONE is not set
CONFIG_PREEMPT_VOLUNTARY=y
# CONFIG_PREEMPT is not set
CONFIG_PREEMPT_COUNT=y
CONFIG_X86_LOCAL_APIC=y
CONFIG_X86_IO_APIC=y
# CONFIG_X86_REROUTE_FOR_BROKEN_BOOT_IRQS is not set
CONFIG_X86_MCE=y
CONFIG_X86_MCE_INTEL=y
# CONFIG_X86_MCE_AMD is not set
CONFIG_X86_MCE_THRESHOLD=y
# CONFIG_X86_MCE_INJECT is not set
CONFIG_X86_THERMAL_VECTOR=y
# CONFIG_I8K is not set
# CONFIG_MICROCODE is not set
# CONFIG_MICROCODE_INTEL_EARLY is not set
# CONFIG_MICROCODE_AMD_EARLY is not set
# CONFIG_X86_MSR is not set
CONFIG_X86_CPUID=y
CONFIG_ARCH_PHYS_ADDR_T_64BIT=y
CONFIG_ARCH_DMA_ADDR_T_64BIT=y
# CONFIG_DIRECT_GBPAGES is not set
# CONFIG_NUMA is not set
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
CONFIG_SPARSEMEM_VMEMMAP=y
CONFIG_HAVE_MEMBLOCK=y
CONFIG_HAVE_MEMBLOCK_NODE_MAP=y
CONFIG_ARCH_DISCARD_MEMBLOCK=y
CONFIG_MEMORY_ISOLATION=y
CONFIG_HAVE_BOOTMEM_INFO_NODE=y
CONFIG_MEMORY_HOTPLUG=y
CONFIG_MEMORY_HOTPLUG_SPARSE=y
CONFIG_MEMORY_HOTREMOVE=y
CONFIG_PAGEFLAGS_EXTENDED=y
CONFIG_SPLIT_PTLOCK_CPUS=4
CONFIG_ARCH_ENABLE_SPLIT_PMD_PTLOCK=y
# CONFIG_BALLOON_COMPACTION is not set
CONFIG_COMPACTION=y
CONFIG_MIGRATION=y
CONFIG_PHYS_ADDR_T_64BIT=y
CONFIG_ZONE_DMA_FLAG=0
CONFIG_VIRT_TO_BUS=y
# CONFIG_KSM is not set
CONFIG_DEFAULT_MMAP_MIN_ADDR=4096
CONFIG_ARCH_SUPPORTS_MEMORY_FAILURE=y
CONFIG_MEMORY_FAILURE=y
# CONFIG_HWPOISON_INJECT is not set
CONFIG_TRANSPARENT_HUGEPAGE=y
# CONFIG_TRANSPARENT_HUGEPAGE_ALWAYS is not set
CONFIG_TRANSPARENT_HUGEPAGE_MADVISE=y
CONFIG_CROSS_MEMORY_ATTACH=y
# CONFIG_CLEANCACHE is not set
CONFIG_CMA=y
# CONFIG_CMA_DEBUG is not set
# CONFIG_ZBUD is not set
# CONFIG_MEM_SOFT_DIRTY is not set
# CONFIG_ZSMALLOC is not set
# CONFIG_X86_CHECK_BIOS_CORRUPTION is not set
CONFIG_X86_RESERVE_LOW=64
# CONFIG_MTRR is not set
# CONFIG_ARCH_RANDOM is not set
CONFIG_X86_SMAP=y
# CONFIG_EFI is not set
CONFIG_SECCOMP=y
CONFIG_HZ_100=y
# CONFIG_HZ_250 is not set
# CONFIG_HZ_300 is not set
# CONFIG_HZ_1000 is not set
CONFIG_HZ=100
# CONFIG_SCHED_HRTICK is not set
CONFIG_KEXEC=y
CONFIG_CRASH_DUMP=y
CONFIG_PHYSICAL_START=0x1000000
CONFIG_RELOCATABLE=y
# CONFIG_RANDOMIZE_BASE is not set
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
CONFIG_PM_RUNTIME=y
CONFIG_PM=y
# CONFIG_PM_DEBUG is not set
CONFIG_WQ_POWER_EFFICIENT_DEFAULT=y
CONFIG_ACPI=y
# CONFIG_ACPI_PROCFS is not set
# CONFIG_ACPI_EC_DEBUGFS is not set
CONFIG_ACPI_AC=y
CONFIG_ACPI_BATTERY=y
CONFIG_ACPI_BUTTON=y
# CONFIG_ACPI_VIDEO is not set
CONFIG_ACPI_FAN=y
# CONFIG_ACPI_DOCK is not set
CONFIG_ACPI_PROCESSOR=y
CONFIG_ACPI_HOTPLUG_CPU=y
# CONFIG_ACPI_PROCESSOR_AGGREGATOR is not set
CONFIG_ACPI_THERMAL=y
CONFIG_ACPI_CUSTOM_DSDT_FILE=""
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
# CONFIG_ACPI_APEI is not set
# CONFIG_ACPI_EXTLOG is not set
CONFIG_SFI=y

#
# CPU Frequency scaling
#
CONFIG_CPU_FREQ=y
CONFIG_CPU_FREQ_GOV_COMMON=y
CONFIG_CPU_FREQ_STAT=y
# CONFIG_CPU_FREQ_STAT_DETAILS is not set
# CONFIG_CPU_FREQ_DEFAULT_GOV_PERFORMANCE is not set
CONFIG_CPU_FREQ_DEFAULT_GOV_POWERSAVE=y
# CONFIG_CPU_FREQ_DEFAULT_GOV_USERSPACE is not set
# CONFIG_CPU_FREQ_DEFAULT_GOV_ONDEMAND is not set
# CONFIG_CPU_FREQ_DEFAULT_GOV_CONSERVATIVE is not set
# CONFIG_CPU_FREQ_GOV_PERFORMANCE is not set
CONFIG_CPU_FREQ_GOV_POWERSAVE=y
CONFIG_CPU_FREQ_GOV_USERSPACE=y
CONFIG_CPU_FREQ_GOV_ONDEMAND=y
CONFIG_CPU_FREQ_GOV_CONSERVATIVE=y

#
# x86 CPU frequency scaling drivers
#
# CONFIG_X86_INTEL_PSTATE is not set
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
CONFIG_AMD_NB=y
CONFIG_PCCARD=y
# CONFIG_PCMCIA is not set
CONFIG_CARDBUS=y

#
# PC-card bridges
#
# CONFIG_YENTA is not set
# CONFIG_HOTPLUG_PCI is not set
# CONFIG_RAPIDIO is not set
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
# CONFIG_COREDUMP is not set
CONFIG_IA32_EMULATION=y
# CONFIG_IA32_AOUT is not set
CONFIG_X86_X32=y
CONFIG_COMPAT=y
CONFIG_COMPAT_FOR_U64_ALIGNMENT=y
CONFIG_X86_DEV_DMA_OPS=y
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
CONFIG_FIRMWARE_IN_KERNEL=y
CONFIG_EXTRA_FIRMWARE=""
CONFIG_FW_LOADER_USER_HELPER=y
# CONFIG_DEBUG_DRIVER is not set
CONFIG_DEBUG_DEVRES=y
# CONFIG_SYS_HYPERVISOR is not set
# CONFIG_GENERIC_CPU_DEVICES is not set
CONFIG_REGMAP=y
CONFIG_REGMAP_I2C=y
CONFIG_REGMAP_IRQ=y
CONFIG_DMA_SHARED_BUFFER=y

#
# Bus devices
#
# CONFIG_CONNECTOR is not set
CONFIG_MTD=y
CONFIG_MTD_REDBOOT_PARTS=y
CONFIG_MTD_REDBOOT_DIRECTORY_BLOCK=-1
# CONFIG_MTD_REDBOOT_PARTS_UNALLOCATED is not set
CONFIG_MTD_REDBOOT_PARTS_READONLY=y
# CONFIG_MTD_CMDLINE_PARTS is not set
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
CONFIG_MTD_CFI_ADV_OPTIONS=y
# CONFIG_MTD_CFI_NOSWAP is not set
# CONFIG_MTD_CFI_BE_BYTE_SWAP is not set
CONFIG_MTD_CFI_LE_BYTE_SWAP=y
CONFIG_MTD_CFI_GEOMETRY=y
CONFIG_MTD_MAP_BANK_WIDTH_1=y
CONFIG_MTD_MAP_BANK_WIDTH_2=y
# CONFIG_MTD_MAP_BANK_WIDTH_4 is not set
# CONFIG_MTD_MAP_BANK_WIDTH_8 is not set
CONFIG_MTD_MAP_BANK_WIDTH_16=y
CONFIG_MTD_MAP_BANK_WIDTH_32=y
CONFIG_MTD_CFI_I1=y
CONFIG_MTD_CFI_I2=y
# CONFIG_MTD_CFI_I4 is not set
CONFIG_MTD_CFI_I8=y
# CONFIG_MTD_OTP is not set
CONFIG_MTD_CFI_INTELEXT=y
# CONFIG_MTD_CFI_AMDSTD is not set
CONFIG_MTD_CFI_STAA=y
CONFIG_MTD_CFI_UTIL=y
CONFIG_MTD_RAM=y
# CONFIG_MTD_ROM is not set
CONFIG_MTD_ABSENT=y

#
# Mapping drivers for chip access
#
CONFIG_MTD_COMPLEX_MAPPINGS=y
# CONFIG_MTD_PHYSMAP is not set
# CONFIG_MTD_SC520CDP is not set
# CONFIG_MTD_NETSC520 is not set
# CONFIG_MTD_TS5500 is not set
CONFIG_MTD_SBC_GXX=y
CONFIG_MTD_AMD76XROM=y
# CONFIG_MTD_ICHXROM is not set
# CONFIG_MTD_ESB2ROM is not set
# CONFIG_MTD_CK804XROM is not set
# CONFIG_MTD_SCB2_FLASH is not set
# CONFIG_MTD_NETtel is not set
CONFIG_MTD_L440GX=y
# CONFIG_MTD_PCI is not set
# CONFIG_MTD_GPIO_ADDR is not set
# CONFIG_MTD_INTEL_VR_NOR is not set
CONFIG_MTD_PLATRAM=y
# CONFIG_MTD_LATCH_ADDR is not set

#
# Self-contained MTD device drivers
#
# CONFIG_MTD_PMC551 is not set
CONFIG_MTD_SLRAM=y
CONFIG_MTD_PHRAM=y
# CONFIG_MTD_MTDRAM is not set

#
# Disk-On-Chip Device Drivers
#
CONFIG_MTD_DOCG3=y
CONFIG_BCH_CONST_M=14
CONFIG_BCH_CONST_T=4
# CONFIG_MTD_NAND is not set
CONFIG_MTD_ONENAND=y
# CONFIG_MTD_ONENAND_VERIFY_WRITE is not set
# CONFIG_MTD_ONENAND_GENERIC is not set
# CONFIG_MTD_ONENAND_OTP is not set
# CONFIG_MTD_ONENAND_2X_PROGRAM is not set

#
# LPDDR flash memory drivers
#
CONFIG_MTD_LPDDR=y
CONFIG_MTD_QINFO_PROBE=y
CONFIG_MTD_UBI=y
CONFIG_MTD_UBI_WL_THRESHOLD=4096
CONFIG_MTD_UBI_BEB_LIMIT=20
CONFIG_MTD_UBI_FASTMAP=y
CONFIG_MTD_UBI_GLUEBI=y
# CONFIG_PARPORT is not set
CONFIG_ARCH_MIGHT_HAVE_PC_PARPORT=y
CONFIG_PNP=y
CONFIG_PNP_DEBUG_MESSAGES=y

#
# Protocols
#
CONFIG_PNPACPI=y

#
# Misc devices
#
# CONFIG_SENSORS_LIS3LV02D is not set
CONFIG_AD525X_DPOT=y
CONFIG_AD525X_DPOT_I2C=y
# CONFIG_DUMMY_IRQ is not set
# CONFIG_IBM_ASM is not set
# CONFIG_PHANTOM is not set
# CONFIG_SGI_IOC4 is not set
# CONFIG_TIFM_CORE is not set
# CONFIG_ICS932S401 is not set
CONFIG_ATMEL_SSC=y
CONFIG_ENCLOSURE_SERVICES=y
# CONFIG_HP_ILO is not set
CONFIG_APDS9802ALS=y
CONFIG_ISL29003=y
CONFIG_ISL29020=y
CONFIG_SENSORS_TSL2550=y
# CONFIG_SENSORS_BH1780 is not set
CONFIG_SENSORS_BH1770=y
# CONFIG_SENSORS_APDS990X is not set
CONFIG_HMC6352=y
# CONFIG_DS1682 is not set
# CONFIG_VMWARE_BALLOON is not set
# CONFIG_BMP085_I2C is not set
# CONFIG_PCH_PHUB is not set
# CONFIG_USB_SWITCH_FSA9480 is not set
# CONFIG_SRAM is not set
CONFIG_C2PORT=y
CONFIG_C2PORT_DURAMAR_2150=y

#
# EEPROM support
#
CONFIG_EEPROM_AT24=y
CONFIG_EEPROM_LEGACY=y
# CONFIG_EEPROM_MAX6875 is not set
# CONFIG_EEPROM_93CX6 is not set
# CONFIG_CB710_CORE is not set

#
# Texas Instruments shared transport line discipline
#
# CONFIG_TI_ST is not set
# CONFIG_SENSORS_LIS3_I2C is not set

#
# Altera FPGA firmware download module
#
CONFIG_ALTERA_STAPL=y
# CONFIG_VMWARE_VMCI is not set

#
# Intel MIC Host Driver
#
# CONFIG_INTEL_MIC_HOST is not set

#
# Intel MIC Card Driver
#
CONFIG_INTEL_MIC_CARD=y
# CONFIG_GENWQE is not set
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
CONFIG_INPUT_MOUSEDEV=y
CONFIG_INPUT_MOUSEDEV_PSAUX=y
CONFIG_INPUT_MOUSEDEV_SCREEN_X=1024
CONFIG_INPUT_MOUSEDEV_SCREEN_Y=768
CONFIG_INPUT_JOYDEV=y
CONFIG_INPUT_EVDEV=y
# CONFIG_INPUT_EVBUG is not set

#
# Input Device Drivers
#
CONFIG_INPUT_KEYBOARD=y
CONFIG_KEYBOARD_ADP5588=y
# CONFIG_KEYBOARD_ADP5589 is not set
CONFIG_KEYBOARD_ATKBD=y
# CONFIG_KEYBOARD_QT1070 is not set
CONFIG_KEYBOARD_QT2160=y
CONFIG_KEYBOARD_LKKBD=y
CONFIG_KEYBOARD_GPIO=y
CONFIG_KEYBOARD_GPIO_POLLED=y
CONFIG_KEYBOARD_TCA6416=y
CONFIG_KEYBOARD_TCA8418=y
CONFIG_KEYBOARD_MATRIX=y
CONFIG_KEYBOARD_LM8323=y
# CONFIG_KEYBOARD_LM8333 is not set
CONFIG_KEYBOARD_MAX7359=y
# CONFIG_KEYBOARD_MCS is not set
CONFIG_KEYBOARD_MPR121=y
CONFIG_KEYBOARD_NEWTON=y
CONFIG_KEYBOARD_OPENCORES=y
CONFIG_KEYBOARD_STOWAWAY=y
CONFIG_KEYBOARD_SUNKBD=y
# CONFIG_KEYBOARD_STMPE is not set
# CONFIG_KEYBOARD_TC3589X is not set
CONFIG_KEYBOARD_TWL4030=y
# CONFIG_KEYBOARD_XTKBD is not set
CONFIG_KEYBOARD_CROS_EC=y
# CONFIG_INPUT_LEDS is not set
# CONFIG_INPUT_MOUSE is not set
CONFIG_INPUT_JOYSTICK=y
CONFIG_JOYSTICK_ANALOG=y
# CONFIG_JOYSTICK_A3D is not set
CONFIG_JOYSTICK_ADI=y
CONFIG_JOYSTICK_COBRA=y
# CONFIG_JOYSTICK_GF2K is not set
CONFIG_JOYSTICK_GRIP=y
# CONFIG_JOYSTICK_GRIP_MP is not set
CONFIG_JOYSTICK_GUILLEMOT=y
CONFIG_JOYSTICK_INTERACT=y
CONFIG_JOYSTICK_SIDEWINDER=y
# CONFIG_JOYSTICK_TMDC is not set
CONFIG_JOYSTICK_IFORCE=y
CONFIG_JOYSTICK_IFORCE_USB=y
# CONFIG_JOYSTICK_IFORCE_232 is not set
CONFIG_JOYSTICK_WARRIOR=y
# CONFIG_JOYSTICK_MAGELLAN is not set
CONFIG_JOYSTICK_SPACEORB=y
CONFIG_JOYSTICK_SPACEBALL=y
CONFIG_JOYSTICK_STINGER=y
CONFIG_JOYSTICK_TWIDJOY=y
# CONFIG_JOYSTICK_ZHENHUA is not set
CONFIG_JOYSTICK_AS5011=y
CONFIG_JOYSTICK_JOYDUMP=y
CONFIG_JOYSTICK_XPAD=y
CONFIG_JOYSTICK_XPAD_FF=y
# CONFIG_JOYSTICK_XPAD_LEDS is not set
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
CONFIG_SERIO_CT82C710=y
# CONFIG_SERIO_PCIPS2 is not set
CONFIG_SERIO_LIBPS2=y
# CONFIG_SERIO_RAW is not set
# CONFIG_SERIO_ALTERA_PS2 is not set
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
# CONFIG_VIRTIO_CONSOLE is not set
# CONFIG_IPMI_HANDLER is not set
# CONFIG_HW_RANDOM is not set
CONFIG_NVRAM=y
# CONFIG_R3964 is not set
# CONFIG_APPLICOM is not set
# CONFIG_MWAVE is not set
# CONFIG_HPET is not set
CONFIG_HANGCHECK_TIMER=y
CONFIG_TCG_TPM=y
CONFIG_TCG_TIS=y
CONFIG_TCG_TIS_I2C_ATMEL=y
CONFIG_TCG_TIS_I2C_INFINEON=y
CONFIG_TCG_TIS_I2C_NUVOTON=y
# CONFIG_TCG_NSC is not set
# CONFIG_TCG_ATMEL is not set
# CONFIG_TCG_INFINEON is not set
CONFIG_TCG_ST33_I2C=y
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
# CONFIG_I2C_MUX_GPIO is not set
CONFIG_I2C_MUX_PCA9541=y
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
# CONFIG_I2C_DESIGNWARE_PCI is not set
# CONFIG_I2C_EG20T is not set
CONFIG_I2C_GPIO=y
CONFIG_I2C_KEMPLD=y
CONFIG_I2C_OCORES=y
# CONFIG_I2C_PCA_PLATFORM is not set
# CONFIG_I2C_PXA_PCI is not set
# CONFIG_I2C_SIMTEC is not set
CONFIG_I2C_XILINX=y

#
# External I2C/SMBus adapter drivers
#
# CONFIG_I2C_DIOLAN_U2C is not set
CONFIG_I2C_PARPORT_LIGHT=y
# CONFIG_I2C_TAOS_EVM is not set
CONFIG_I2C_TINY_USB=y
CONFIG_I2C_VIPERBOARD=y

#
# Other I2C/SMBus bus drivers
#
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
CONFIG_PPS=y
# CONFIG_PPS_DEBUG is not set
CONFIG_NTP_PPS=y

#
# PPS clients support
#
CONFIG_PPS_CLIENT_KTIMER=y
# CONFIG_PPS_CLIENT_LDISC is not set
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
CONFIG_GPIOLIB=y
CONFIG_GPIO_DEVRES=y
CONFIG_GPIO_ACPI=y
CONFIG_DEBUG_GPIO=y
CONFIG_GPIO_SYSFS=y
CONFIG_GPIO_GENERIC=y
CONFIG_GPIO_MAX730X=y

#
# Memory mapped GPIO drivers:
#
CONFIG_GPIO_GENERIC_PLATFORM=y
# CONFIG_GPIO_IT8761E is not set
# CONFIG_GPIO_F7188X is not set
CONFIG_GPIO_SCH311X=y
# CONFIG_GPIO_TS5500 is not set
# CONFIG_GPIO_SCH is not set
# CONFIG_GPIO_ICH is not set
# CONFIG_GPIO_VX855 is not set
# CONFIG_GPIO_LYNXPOINT is not set

#
# I2C GPIO expanders:
#
# CONFIG_GPIO_ARIZONA is not set
CONFIG_GPIO_MAX7300=y
CONFIG_GPIO_MAX732X=y
CONFIG_GPIO_MAX732X_IRQ=y
CONFIG_GPIO_PCA953X=y
CONFIG_GPIO_PCA953X_IRQ=y
# CONFIG_GPIO_PCF857X is not set
# CONFIG_GPIO_RC5T583 is not set
CONFIG_GPIO_SX150X=y
# CONFIG_GPIO_STMPE is not set
CONFIG_GPIO_TC3589X=y
CONFIG_GPIO_TPS65912=y
CONFIG_GPIO_TWL4030=y
# CONFIG_GPIO_WM831X is not set
# CONFIG_GPIO_WM8350 is not set
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
CONFIG_GPIO_MCP23S08=y

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
CONFIG_GPIO_PALMAS=y
CONFIG_GPIO_TPS6586X=y
# CONFIG_GPIO_TPS65910 is not set

#
# USB GPIO expanders:
#
CONFIG_GPIO_VIPERBOARD=y
CONFIG_W1=y

#
# 1-wire Bus Masters
#
# CONFIG_W1_MASTER_MATROX is not set
CONFIG_W1_MASTER_DS2490=y
# CONFIG_W1_MASTER_DS2482 is not set
CONFIG_W1_MASTER_DS1WM=y
CONFIG_W1_MASTER_GPIO=y

#
# 1-wire Slaves
#
CONFIG_W1_SLAVE_THERM=y
# CONFIG_W1_SLAVE_SMEM is not set
CONFIG_W1_SLAVE_DS2408=y
CONFIG_W1_SLAVE_DS2408_READBACK=y
CONFIG_W1_SLAVE_DS2413=y
CONFIG_W1_SLAVE_DS2423=y
# CONFIG_W1_SLAVE_DS2431 is not set
CONFIG_W1_SLAVE_DS2433=y
CONFIG_W1_SLAVE_DS2433_CRC=y
CONFIG_W1_SLAVE_DS2760=y
CONFIG_W1_SLAVE_DS2780=y
CONFIG_W1_SLAVE_DS2781=y
CONFIG_W1_SLAVE_DS28E04=y
# CONFIG_W1_SLAVE_BQ27000 is not set
CONFIG_POWER_SUPPLY=y
# CONFIG_POWER_SUPPLY_DEBUG is not set
CONFIG_PDA_POWER=y
# CONFIG_GENERIC_ADC_BATTERY is not set
CONFIG_MAX8925_POWER=y
CONFIG_WM831X_BACKUP=y
CONFIG_WM831X_POWER=y
# CONFIG_WM8350_POWER is not set
CONFIG_TEST_POWER=y
CONFIG_BATTERY_DS2760=y
CONFIG_BATTERY_DS2780=y
# CONFIG_BATTERY_DS2781 is not set
# CONFIG_BATTERY_DS2782 is not set
# CONFIG_BATTERY_SBS is not set
CONFIG_BATTERY_BQ27x00=y
# CONFIG_BATTERY_BQ27X00_I2C is not set
# CONFIG_BATTERY_BQ27X00_PLATFORM is not set
CONFIG_BATTERY_MAX17040=y
# CONFIG_BATTERY_MAX17042 is not set
# CONFIG_CHARGER_PCF50633 is not set
# CONFIG_CHARGER_ISP1704 is not set
# CONFIG_CHARGER_MAX8903 is not set
CONFIG_CHARGER_TWL4030=y
CONFIG_CHARGER_LP8727=y
CONFIG_CHARGER_GPIO=y
CONFIG_CHARGER_BQ2415X=y
CONFIG_CHARGER_BQ24190=y
CONFIG_CHARGER_BQ24735=y
# CONFIG_CHARGER_SMB347 is not set
CONFIG_CHARGER_TPS65090=y
CONFIG_POWER_RESET=y
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
CONFIG_SENSORS_ADM1025=y
# CONFIG_SENSORS_ADM1026 is not set
CONFIG_SENSORS_ADM1029=y
# CONFIG_SENSORS_ADM1031 is not set
CONFIG_SENSORS_ADM9240=y
CONFIG_SENSORS_ADT7X10=y
CONFIG_SENSORS_ADT7410=y
CONFIG_SENSORS_ADT7411=y
CONFIG_SENSORS_ADT7462=y
# CONFIG_SENSORS_ADT7470 is not set
# CONFIG_SENSORS_ADT7475 is not set
CONFIG_SENSORS_ASC7621=y
# CONFIG_SENSORS_K8TEMP is not set
# CONFIG_SENSORS_K10TEMP is not set
# CONFIG_SENSORS_FAM15H_POWER is not set
# CONFIG_SENSORS_ASB100 is not set
CONFIG_SENSORS_ATXP1=y
CONFIG_SENSORS_DS620=y
CONFIG_SENSORS_DS1621=y
# CONFIG_SENSORS_I5K_AMB is not set
CONFIG_SENSORS_F71805F=y
CONFIG_SENSORS_F71882FG=y
# CONFIG_SENSORS_F75375S is not set
# CONFIG_SENSORS_FSCHMD is not set
# CONFIG_SENSORS_G760A is not set
# CONFIG_SENSORS_G762 is not set
# CONFIG_SENSORS_GL518SM is not set
# CONFIG_SENSORS_GL520SM is not set
CONFIG_SENSORS_GPIO_FAN=y
# CONFIG_SENSORS_HIH6130 is not set
CONFIG_SENSORS_HTU21=y
CONFIG_SENSORS_CORETEMP=y
CONFIG_SENSORS_IIO_HWMON=y
CONFIG_SENSORS_IT87=y
CONFIG_SENSORS_JC42=y
CONFIG_SENSORS_LINEAGE=y
CONFIG_SENSORS_LM63=y
CONFIG_SENSORS_LM73=y
# CONFIG_SENSORS_LM75 is not set
CONFIG_SENSORS_LM77=y
# CONFIG_SENSORS_LM78 is not set
# CONFIG_SENSORS_LM80 is not set
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
# CONFIG_SENSORS_LM95234 is not set
# CONFIG_SENSORS_LM95241 is not set
# CONFIG_SENSORS_LM95245 is not set
CONFIG_SENSORS_MAX16065=y
# CONFIG_SENSORS_MAX1619 is not set
# CONFIG_SENSORS_MAX1668 is not set
CONFIG_SENSORS_MAX197=y
# CONFIG_SENSORS_MAX6639 is not set
CONFIG_SENSORS_MAX6642=y
# CONFIG_SENSORS_MAX6650 is not set
# CONFIG_SENSORS_MAX6697 is not set
CONFIG_SENSORS_MCP3021=y
CONFIG_SENSORS_NCT6775=y
CONFIG_SENSORS_PC87360=y
CONFIG_SENSORS_PC87427=y
CONFIG_SENSORS_PCF8591=y
CONFIG_PMBUS=y
CONFIG_SENSORS_PMBUS=y
CONFIG_SENSORS_ADM1275=y
CONFIG_SENSORS_LM25066=y
# CONFIG_SENSORS_LTC2978 is not set
CONFIG_SENSORS_MAX16064=y
# CONFIG_SENSORS_MAX34440 is not set
CONFIG_SENSORS_MAX8688=y
CONFIG_SENSORS_UCD9000=y
CONFIG_SENSORS_UCD9200=y
CONFIG_SENSORS_ZL6100=y
CONFIG_SENSORS_SHT15=y
CONFIG_SENSORS_SHT21=y
# CONFIG_SENSORS_SIS5595 is not set
CONFIG_SENSORS_SMM665=y
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
# CONFIG_SENSORS_INA209 is not set
CONFIG_SENSORS_INA2XX=y
# CONFIG_SENSORS_THMC50 is not set
CONFIG_SENSORS_TMP102=y
CONFIG_SENSORS_TMP401=y
CONFIG_SENSORS_TMP421=y
# CONFIG_SENSORS_VIA_CPUTEMP is not set
# CONFIG_SENSORS_VIA686A is not set
# CONFIG_SENSORS_VT1211 is not set
# CONFIG_SENSORS_VT8231 is not set
# CONFIG_SENSORS_W83781D is not set
# CONFIG_SENSORS_W83791D is not set
# CONFIG_SENSORS_W83792D is not set
CONFIG_SENSORS_W83793=y
# CONFIG_SENSORS_W83795 is not set
CONFIG_SENSORS_W83L785TS=y
CONFIG_SENSORS_W83L786NG=y
CONFIG_SENSORS_W83627HF=y
CONFIG_SENSORS_W83627EHF=y
# CONFIG_SENSORS_WM831X is not set
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
CONFIG_THERMAL_GOV_USER_SPACE=y
# CONFIG_THERMAL_EMULATION is not set
# CONFIG_INTEL_POWERCLAMP is not set
CONFIG_X86_PKG_TEMP_THERMAL=y
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
# CONFIG_BCMA_HOST_SOC is not set
CONFIG_BCMA_DRIVER_GMAC_CMN=y
CONFIG_BCMA_DRIVER_GPIO=y
# CONFIG_BCMA_DEBUG is not set

#
# Multifunction device drivers
#
CONFIG_MFD_CORE=y
# CONFIG_MFD_CS5535 is not set
# CONFIG_MFD_AS3711 is not set
# CONFIG_PMIC_ADP5520 is not set
# CONFIG_MFD_AAT2870_CORE is not set
CONFIG_MFD_CROS_EC=y
# CONFIG_MFD_CROS_EC_I2C is not set
# CONFIG_PMIC_DA903X is not set
# CONFIG_MFD_DA9052_I2C is not set
# CONFIG_MFD_DA9055 is not set
CONFIG_MFD_DA9063=y
CONFIG_MFD_MC13XXX=y
CONFIG_MFD_MC13XXX_I2C=y
CONFIG_HTC_PASIC3=y
# CONFIG_HTC_I2CPLD is not set
# CONFIG_LPC_ICH is not set
# CONFIG_LPC_SCH is not set
# CONFIG_MFD_JANZ_CMODIO is not set
CONFIG_MFD_KEMPLD=y
CONFIG_MFD_88PM800=y
CONFIG_MFD_88PM805=y
# CONFIG_MFD_88PM860X is not set
# CONFIG_MFD_MAX14577 is not set
CONFIG_MFD_MAX77686=y
CONFIG_MFD_MAX77693=y
CONFIG_MFD_MAX8907=y
CONFIG_MFD_MAX8925=y
# CONFIG_MFD_MAX8997 is not set
CONFIG_MFD_MAX8998=y
CONFIG_MFD_VIPERBOARD=y
CONFIG_MFD_RETU=y
CONFIG_MFD_PCF50633=y
CONFIG_PCF50633_ADC=y
CONFIG_PCF50633_GPIO=y
# CONFIG_MFD_RDC321X is not set
# CONFIG_MFD_RTSX_PCI is not set
CONFIG_MFD_RC5T583=y
# CONFIG_MFD_SEC_CORE is not set
CONFIG_MFD_SI476X_CORE=y
CONFIG_MFD_SM501=y
CONFIG_MFD_SM501_GPIO=y
# CONFIG_MFD_SMSC is not set
CONFIG_ABX500_CORE=y
CONFIG_AB3100_CORE=y
# CONFIG_AB3100_OTP is not set
CONFIG_MFD_STMPE=y

#
# STMicroelectronics STMPE Interface Drivers
#
CONFIG_STMPE_I2C=y
# CONFIG_MFD_SYSCON is not set
# CONFIG_MFD_TI_AM335X_TSCADC is not set
# CONFIG_MFD_LP3943 is not set
# CONFIG_MFD_LP8788 is not set
CONFIG_MFD_PALMAS=y
# CONFIG_TPS6105X is not set
# CONFIG_TPS65010 is not set
# CONFIG_TPS6507X is not set
CONFIG_MFD_TPS65090=y
# CONFIG_MFD_TPS65217 is not set
CONFIG_MFD_TPS6586X=y
CONFIG_MFD_TPS65910=y
CONFIG_MFD_TPS65912=y
CONFIG_MFD_TPS65912_I2C=y
CONFIG_MFD_TPS80031=y
CONFIG_TWL4030_CORE=y
# CONFIG_TWL4030_MADC is not set
CONFIG_MFD_TWL4030_AUDIO=y
# CONFIG_TWL6040_CORE is not set
CONFIG_MFD_WL1273_CORE=y
CONFIG_MFD_LM3533=y
# CONFIG_MFD_TIMBERDALE is not set
CONFIG_MFD_TC3589X=y
# CONFIG_MFD_TMIO is not set
# CONFIG_MFD_VX855 is not set
CONFIG_MFD_ARIZONA=y
CONFIG_MFD_ARIZONA_I2C=y
# CONFIG_MFD_WM5102 is not set
# CONFIG_MFD_WM5110 is not set
# CONFIG_MFD_WM8997 is not set
# CONFIG_MFD_WM8400 is not set
CONFIG_MFD_WM831X=y
CONFIG_MFD_WM831X_I2C=y
CONFIG_MFD_WM8350=y
CONFIG_MFD_WM8350_I2C=y
# CONFIG_MFD_WM8994 is not set
CONFIG_REGULATOR=y
# CONFIG_REGULATOR_DEBUG is not set
CONFIG_REGULATOR_FIXED_VOLTAGE=y
# CONFIG_REGULATOR_VIRTUAL_CONSUMER is not set
CONFIG_REGULATOR_USERSPACE_CONSUMER=y
CONFIG_REGULATOR_88PM800=y
CONFIG_REGULATOR_ACT8865=y
CONFIG_REGULATOR_AD5398=y
# CONFIG_REGULATOR_AB3100 is not set
CONFIG_REGULATOR_ARIZONA=y
CONFIG_REGULATOR_DA9063=y
# CONFIG_REGULATOR_DA9210 is not set
CONFIG_REGULATOR_FAN53555=y
# CONFIG_REGULATOR_GPIO is not set
# CONFIG_REGULATOR_ISL6271A is not set
# CONFIG_REGULATOR_LP3971 is not set
# CONFIG_REGULATOR_LP3972 is not set
# CONFIG_REGULATOR_LP872X is not set
CONFIG_REGULATOR_LP8755=y
CONFIG_REGULATOR_MAX1586=y
# CONFIG_REGULATOR_MAX8649 is not set
# CONFIG_REGULATOR_MAX8660 is not set
# CONFIG_REGULATOR_MAX8907 is not set
# CONFIG_REGULATOR_MAX8925 is not set
CONFIG_REGULATOR_MAX8952=y
# CONFIG_REGULATOR_MAX8973 is not set
# CONFIG_REGULATOR_MAX8998 is not set
CONFIG_REGULATOR_MAX77686=y
# CONFIG_REGULATOR_MAX77693 is not set
CONFIG_REGULATOR_MC13XXX_CORE=y
CONFIG_REGULATOR_MC13783=y
CONFIG_REGULATOR_MC13892=y
CONFIG_REGULATOR_PALMAS=y
CONFIG_REGULATOR_PCF50633=y
CONFIG_REGULATOR_PFUZE100=y
# CONFIG_REGULATOR_RC5T583 is not set
CONFIG_REGULATOR_TPS51632=y
CONFIG_REGULATOR_TPS62360=y
CONFIG_REGULATOR_TPS65023=y
CONFIG_REGULATOR_TPS6507X=y
CONFIG_REGULATOR_TPS65090=y
# CONFIG_REGULATOR_TPS6586X is not set
# CONFIG_REGULATOR_TPS65910 is not set
CONFIG_REGULATOR_TPS65912=y
CONFIG_REGULATOR_TPS80031=y
CONFIG_REGULATOR_TWL4030=y
CONFIG_REGULATOR_WM831X=y
CONFIG_REGULATOR_WM8350=y
CONFIG_MEDIA_SUPPORT=y

#
# Multimedia core support
#
# CONFIG_MEDIA_CAMERA_SUPPORT is not set
# CONFIG_MEDIA_ANALOG_TV_SUPPORT is not set
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
CONFIG_VIDEOBUF2_CORE=y
CONFIG_VIDEOBUF2_MEMOPS=y
CONFIG_VIDEOBUF2_VMALLOC=y
CONFIG_DVB_CORE=y
# CONFIG_TTPCI_EEPROM is not set
CONFIG_DVB_MAX_ADAPTERS=8
CONFIG_DVB_DYNAMIC_MINORS=y

#
# Media drivers
#
CONFIG_RC_CORE=y
CONFIG_RC_MAP=y
CONFIG_RC_DECODERS=y
CONFIG_LIRC=y
# CONFIG_IR_LIRC_CODEC is not set
# CONFIG_IR_NEC_DECODER is not set
# CONFIG_IR_RC5_DECODER is not set
# CONFIG_IR_RC6_DECODER is not set
CONFIG_IR_JVC_DECODER=y
CONFIG_IR_SONY_DECODER=y
CONFIG_IR_RC5_SZ_DECODER=y
CONFIG_IR_SANYO_DECODER=y
CONFIG_IR_MCE_KBD_DECODER=y
CONFIG_RC_DEVICES=y
CONFIG_RC_ATI_REMOTE=y
# CONFIG_IR_ENE is not set
CONFIG_IR_IMON=y
CONFIG_IR_MCEUSB=y
# CONFIG_IR_ITE_CIR is not set
# CONFIG_IR_FINTEK is not set
# CONFIG_IR_NUVOTON is not set
# CONFIG_IR_REDRAT3 is not set
CONFIG_IR_STREAMZAP=y
# CONFIG_IR_WINBOND_CIR is not set
CONFIG_IR_IGUANA=y
CONFIG_IR_TTUSBIR=y
CONFIG_RC_LOOPBACK=y
CONFIG_IR_GPIO_CIR=y
CONFIG_MEDIA_USB_SUPPORT=y

#
# Analog/digital TV USB devices
#
CONFIG_VIDEO_AU0828=y
CONFIG_VIDEO_AU0828_V4L2=y
# CONFIG_VIDEO_CX231XX is not set
CONFIG_VIDEO_TM6000=y
CONFIG_VIDEO_TM6000_ALSA=y
# CONFIG_VIDEO_TM6000_DVB is not set

#
# Digital TV USB devices
#
# CONFIG_DVB_USB is not set
# CONFIG_DVB_USB_V2 is not set
# CONFIG_DVB_TTUSB_BUDGET is not set
# CONFIG_DVB_TTUSB_DEC is not set
CONFIG_SMS_USB_DRV=y
# CONFIG_DVB_B2C2_FLEXCOP_USB is not set

#
# Webcam, TV (analog/digital) USB devices
#
CONFIG_VIDEO_EM28XX=y
CONFIG_VIDEO_EM28XX_ALSA=y
CONFIG_VIDEO_EM28XX_DVB=y
# CONFIG_VIDEO_EM28XX_RC is not set
# CONFIG_MEDIA_PCI_SUPPORT is not set

#
# Supported MMC/SDIO adapters
#
CONFIG_SMS_SDIO_DRV=y
CONFIG_RADIO_ADAPTERS=y
CONFIG_RADIO_SI470X=y
CONFIG_USB_SI470X=y
CONFIG_RADIO_SI4713=y
# CONFIG_USB_SI4713 is not set
CONFIG_PLATFORM_SI4713=y
CONFIG_I2C_SI4713=y
# CONFIG_RADIO_SI476X is not set
CONFIG_USB_MR800=y
# CONFIG_USB_DSBR is not set
# CONFIG_RADIO_MAXIRADIO is not set
# CONFIG_RADIO_SHARK is not set
CONFIG_RADIO_SHARK2=y
# CONFIG_USB_KEENE is not set
# CONFIG_USB_RAREMONO is not set
CONFIG_USB_MA901=y
CONFIG_RADIO_TEA5764=y
# CONFIG_RADIO_TEA5764_XTAL is not set
CONFIG_RADIO_SAA7706H=y
# CONFIG_RADIO_TEF6862 is not set
CONFIG_RADIO_WL1273=y

#
# Texas Instruments WL128x FM driver (ST based)
#
CONFIG_MEDIA_COMMON_OPTIONS=y

#
# common driver options
#
CONFIG_VIDEO_TVEEPROM=y
CONFIG_CYPRESS_FIRMWARE=y
CONFIG_SMS_SIANO_MDTV=y
# CONFIG_SMS_SIANO_RC is not set

#
# Media ancillary drivers (tuners, sensors, i2c, frontends)
#
CONFIG_MEDIA_SUBDRV_AUTOSELECT=y
CONFIG_VIDEO_IR_I2C=y

#
# Audio decoders, processors and mixers
#
CONFIG_VIDEO_MSP3400=y
CONFIG_VIDEO_UDA1342=y
CONFIG_VIDEO_SONY_BTF_MPX=y

#
# RDS decoders
#

#
# Video decoders
#
CONFIG_VIDEO_SAA711X=y
CONFIG_VIDEO_TVP5150=y
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
CONFIG_VIDEO_MT9V011=y

#
# Flash devices
#

#
# Video improvement chips
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
CONFIG_MEDIA_TUNER_QT1010=y
CONFIG_MEDIA_TUNER_XC2028=y
CONFIG_MEDIA_TUNER_XC5000=y
CONFIG_MEDIA_TUNER_XC4000=y
CONFIG_MEDIA_TUNER_MXL5007T=y
CONFIG_MEDIA_TUNER_MC44S803=y
CONFIG_MEDIA_TUNER_M88TS2022=y

#
# Multistandard (satellite) frontends
#
CONFIG_DVB_M88DS3103=y

#
# Multistandard (cable + terrestrial) frontends
#
CONFIG_DVB_DRXK=y
CONFIG_DVB_TDA18271C2DD=y

#
# DVB-S (satellite) frontends
#
CONFIG_DVB_TDA10071=y

#
# DVB-T (terrestrial) frontends
#
CONFIG_DVB_DRXD=y
CONFIG_DVB_MT352=y
CONFIG_DVB_ZL10353=y
CONFIG_DVB_CXD2820R=y

#
# DVB-C (cable) frontends
#
CONFIG_DVB_TDA10023=y

#
# ATSC (North American/Korean Terrestrial/Cable DTV) frontends
#
CONFIG_DVB_LGDT330X=y
CONFIG_DVB_LGDT3305=y
CONFIG_DVB_S5H1409=y
CONFIG_DVB_AU8522=y
CONFIG_DVB_AU8522_DTV=y
CONFIG_DVB_AU8522_V4L=y

#
# ISDB-T (terrestrial) frontends
#
CONFIG_DVB_S921=y
CONFIG_DVB_MB86A20S=y

#
# Digital terrestrial only tuners/PLL
#

#
# SEC control devices for DVB-S
#
CONFIG_DVB_A8293=y

#
# Tools to develop new frontends
#
# CONFIG_DVB_DUMMY_FE is not set

#
# Graphics support
#
# CONFIG_AGP is not set
CONFIG_VGA_ARB=y
CONFIG_VGA_ARB_MAX_GPUS=16
# CONFIG_VGA_SWITCHEROO is not set
# CONFIG_DRM is not set
# CONFIG_VGASTATE is not set
CONFIG_VIDEO_OUTPUT_CONTROL=y
CONFIG_FB=y
CONFIG_FIRMWARE_EDID=y
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
# CONFIG_FB_TILEBLITTING is not set

#
# Frame buffer hardware drivers
#
# CONFIG_FB_CIRRUS is not set
# CONFIG_FB_PM2 is not set
# CONFIG_FB_CYBER2000 is not set
# CONFIG_FB_ARC is not set
# CONFIG_FB_ASILIANT is not set
# CONFIG_FB_IMSTT is not set
# CONFIG_FB_VGA16 is not set
# CONFIG_FB_VESA is not set
CONFIG_FB_N411=y
# CONFIG_FB_HGA is not set
CONFIG_FB_S1D13XXX=y
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
# CONFIG_FB_TMIO is not set
# CONFIG_FB_SM501 is not set
CONFIG_FB_SMSCUFX=y
CONFIG_FB_UDL=y
CONFIG_FB_GOLDFISH=y
# CONFIG_FB_VIRTUAL is not set
CONFIG_FB_METRONOME=y
# CONFIG_FB_MB862XX is not set
CONFIG_FB_BROADSHEET=y
CONFIG_FB_AUO_K190X=y
CONFIG_FB_AUO_K1900=y
# CONFIG_FB_AUO_K1901 is not set
CONFIG_FB_SIMPLE=y
CONFIG_EXYNOS_VIDEO=y
CONFIG_BACKLIGHT_LCD_SUPPORT=y
CONFIG_LCD_CLASS_DEVICE=y
# CONFIG_LCD_PLATFORM is not set
CONFIG_BACKLIGHT_CLASS_DEVICE=y
CONFIG_BACKLIGHT_GENERIC=y
CONFIG_BACKLIGHT_LM3533=y
# CONFIG_BACKLIGHT_MAX8925 is not set
# CONFIG_BACKLIGHT_APPLE is not set
CONFIG_BACKLIGHT_SAHARA=y
CONFIG_BACKLIGHT_WM831X=y
# CONFIG_BACKLIGHT_ADP8860 is not set
CONFIG_BACKLIGHT_ADP8870=y
CONFIG_BACKLIGHT_PCF50633=y
# CONFIG_BACKLIGHT_LM3630A is not set
CONFIG_BACKLIGHT_LM3639=y
CONFIG_BACKLIGHT_LP855X=y
# CONFIG_BACKLIGHT_PANDORA is not set
# CONFIG_BACKLIGHT_GPIO is not set
CONFIG_BACKLIGHT_LV5207LP=y
# CONFIG_BACKLIGHT_BD6107 is not set
CONFIG_LOGO=y
# CONFIG_LOGO_LINUX_MONO is not set
# CONFIG_LOGO_LINUX_VGA16 is not set
CONFIG_LOGO_LINUX_CLUT224=y
CONFIG_SOUND=y
CONFIG_SOUND_OSS_CORE=y
CONFIG_SOUND_OSS_CORE_PRECLAIM=y
CONFIG_SND=y
CONFIG_SND_TIMER=y
CONFIG_SND_PCM=y
CONFIG_SND_RAWMIDI=y
CONFIG_SND_COMPRESS_OFFLOAD=y
CONFIG_SND_JACK=y
# CONFIG_SND_SEQUENCER is not set
# CONFIG_SND_MIXER_OSS is not set
# CONFIG_SND_PCM_OSS is not set
# CONFIG_SND_DYNAMIC_MINORS is not set
# CONFIG_SND_SUPPORT_OLD_API is not set
CONFIG_SND_VERBOSE_PROCFS=y
CONFIG_SND_VERBOSE_PRINTK=y
# CONFIG_SND_DEBUG is not set
CONFIG_SND_DMA_SGBUF=y
# CONFIG_SND_RAWMIDI_SEQ is not set
# CONFIG_SND_OPL3_LIB_SEQ is not set
# CONFIG_SND_OPL4_LIB_SEQ is not set
# CONFIG_SND_SBAWE_SEQ is not set
# CONFIG_SND_EMU10K1_SEQ is not set
CONFIG_SND_DRIVERS=y
# CONFIG_SND_DUMMY is not set
CONFIG_SND_ALOOP=y
CONFIG_SND_MTPAV=y
# CONFIG_SND_SERIAL_U16550 is not set
# CONFIG_SND_MPU401 is not set
CONFIG_SND_PCI=y
# CONFIG_SND_AD1889 is not set
# CONFIG_SND_ALS300 is not set
# CONFIG_SND_ALS4000 is not set
# CONFIG_SND_ALI5451 is not set
# CONFIG_SND_ASIHPI is not set
# CONFIG_SND_ATIIXP is not set
# CONFIG_SND_ATIIXP_MODEM is not set
# CONFIG_SND_AU8810 is not set
# CONFIG_SND_AU8820 is not set
# CONFIG_SND_AU8830 is not set
# CONFIG_SND_AW2 is not set
# CONFIG_SND_AZT3328 is not set
# CONFIG_SND_BT87X is not set
# CONFIG_SND_CA0106 is not set
# CONFIG_SND_CMIPCI is not set
# CONFIG_SND_OXYGEN is not set
# CONFIG_SND_CS4281 is not set
# CONFIG_SND_CS46XX is not set
# CONFIG_SND_CS5530 is not set
# CONFIG_SND_CS5535AUDIO is not set
# CONFIG_SND_CTXFI is not set
# CONFIG_SND_DARLA20 is not set
# CONFIG_SND_GINA20 is not set
# CONFIG_SND_LAYLA20 is not set
# CONFIG_SND_DARLA24 is not set
# CONFIG_SND_GINA24 is not set
# CONFIG_SND_LAYLA24 is not set
# CONFIG_SND_MONA is not set
# CONFIG_SND_MIA is not set
# CONFIG_SND_ECHO3G is not set
# CONFIG_SND_INDIGO is not set
# CONFIG_SND_INDIGOIO is not set
# CONFIG_SND_INDIGODJ is not set
# CONFIG_SND_INDIGOIOX is not set
# CONFIG_SND_INDIGODJX is not set
# CONFIG_SND_EMU10K1 is not set
# CONFIG_SND_EMU10K1X is not set
# CONFIG_SND_ENS1370 is not set
# CONFIG_SND_ENS1371 is not set
# CONFIG_SND_ES1938 is not set
# CONFIG_SND_ES1968 is not set
# CONFIG_SND_FM801 is not set
# CONFIG_SND_HDA_INTEL is not set
# CONFIG_SND_HDSP is not set
# CONFIG_SND_HDSPM is not set
# CONFIG_SND_ICE1712 is not set
# CONFIG_SND_ICE1724 is not set
# CONFIG_SND_INTEL8X0 is not set
# CONFIG_SND_INTEL8X0M is not set
# CONFIG_SND_KORG1212 is not set
# CONFIG_SND_LOLA is not set
# CONFIG_SND_LX6464ES is not set
# CONFIG_SND_MAESTRO3 is not set
# CONFIG_SND_MIXART is not set
# CONFIG_SND_NM256 is not set
# CONFIG_SND_PCXHR is not set
# CONFIG_SND_RIPTIDE is not set
# CONFIG_SND_RME32 is not set
# CONFIG_SND_RME96 is not set
# CONFIG_SND_RME9652 is not set
# CONFIG_SND_SONICVIBES is not set
# CONFIG_SND_TRIDENT is not set
# CONFIG_SND_VIA82XX is not set
# CONFIG_SND_VIA82XX_MODEM is not set
# CONFIG_SND_VIRTUOSO is not set
# CONFIG_SND_VX222 is not set
# CONFIG_SND_YMFPCI is not set
# CONFIG_SND_USB is not set
CONFIG_SND_SOC=y
# CONFIG_SND_ATMEL_SOC is not set
CONFIG_SND_SOC_I2C_AND_SPI=y
# CONFIG_SND_SIMPLE_CARD is not set
CONFIG_SOUND_PRIME=y
CONFIG_SOUND_OSS=y
# CONFIG_SOUND_TRACEINIT is not set
# CONFIG_SOUND_DMAP is not set
CONFIG_SOUND_VMIDI=y
CONFIG_SOUND_TRIX=y
# CONFIG_TRIX_HAVE_BOOT is not set
CONFIG_SOUND_MSS=y
CONFIG_SOUND_MPU401=y
CONFIG_SOUND_PAS=y
CONFIG_PAS_JOYSTICK=y
CONFIG_SOUND_PSS=y
CONFIG_PSS_MIXER=y
# CONFIG_PSS_HAVE_BOOT is not set
# CONFIG_SOUND_SB is not set
CONFIG_SOUND_YM3812=y
CONFIG_SOUND_UART6850=y
CONFIG_SOUND_AEDSP16=y
# CONFIG_SC6600 is not set

#
# HID support
#
CONFIG_HID=y
CONFIG_HID_BATTERY_STRENGTH=y
# CONFIG_HIDRAW is not set
CONFIG_UHID=y
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
CONFIG_HID_CHERRY=y
# CONFIG_HID_CHICONY is not set
CONFIG_HID_PRODIKEYS=y
# CONFIG_HID_CYPRESS is not set
CONFIG_HID_DRAGONRISE=y
CONFIG_DRAGONRISE_FF=y
CONFIG_HID_EMS_FF=y
# CONFIG_HID_ELECOM is not set
CONFIG_HID_ELO=y
CONFIG_HID_EZKEY=y
# CONFIG_HID_HOLTEK is not set
CONFIG_HID_HUION=y
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
CONFIG_HID_LOGITECH=y
# CONFIG_LOGITECH_FF is not set
# CONFIG_LOGIRUMBLEPAD2_FF is not set
# CONFIG_LOGIG940_FF is not set
CONFIG_LOGIWHEELS_FF=y
CONFIG_HID_MAGICMOUSE=y
CONFIG_HID_MICROSOFT=y
CONFIG_HID_MONTEREY=y
CONFIG_HID_MULTITOUCH=y
CONFIG_HID_NTRIG=y
# CONFIG_HID_ORTEK is not set
CONFIG_HID_PANTHERLORD=y
# CONFIG_PANTHERLORD_FF is not set
# CONFIG_HID_PETALYNX is not set
CONFIG_HID_PICOLCD=y
# CONFIG_HID_PICOLCD_FB is not set
# CONFIG_HID_PICOLCD_BACKLIGHT is not set
# CONFIG_HID_PICOLCD_LCD is not set
# CONFIG_HID_PICOLCD_LEDS is not set
CONFIG_HID_PICOLCD_CIR=y
CONFIG_HID_PRIMAX=y
# CONFIG_HID_ROCCAT is not set
CONFIG_HID_SAITEK=y
CONFIG_HID_SAMSUNG=y
CONFIG_HID_SONY=y
# CONFIG_SONY_FF is not set
CONFIG_HID_SPEEDLINK=y
CONFIG_HID_STEELSERIES=y
# CONFIG_HID_SUNPLUS is not set
# CONFIG_HID_GREENASIA is not set
# CONFIG_HID_SMARTJOYPLUS is not set
# CONFIG_HID_TIVO is not set
# CONFIG_HID_TOPSEED is not set
CONFIG_HID_THINGM=y
CONFIG_HID_THRUSTMASTER=y
CONFIG_THRUSTMASTER_FF=y
CONFIG_HID_WACOM=y
CONFIG_HID_WIIMOTE=y
CONFIG_HID_XINMO=y
CONFIG_HID_ZEROPLUS=y
CONFIG_ZEROPLUS_FF=y
CONFIG_HID_ZYDACRON=y
# CONFIG_HID_SENSOR_HUB is not set

#
# USB HID support
#
CONFIG_USB_HID=y
# CONFIG_HID_PID is not set
CONFIG_USB_HIDDEV=y

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
CONFIG_USB_ANNOUNCE_NEW_DEVICES=y

#
# Miscellaneous USB options
#
CONFIG_USB_DEFAULT_PERSIST=y
CONFIG_USB_DYNAMIC_MINORS=y
CONFIG_USB_OTG=y
# CONFIG_USB_OTG_WHITELIST is not set
CONFIG_USB_OTG_BLACKLIST_HUB=y
# CONFIG_USB_MON is not set
# CONFIG_USB_WUSB_CBAF is not set

#
# USB Host Controller Drivers
#
# CONFIG_USB_C67X00_HCD is not set
# CONFIG_USB_XHCI_HCD is not set
CONFIG_USB_EHCI_HCD=y
CONFIG_USB_EHCI_ROOT_HUB_TT=y
# CONFIG_USB_EHCI_TT_NEWSCHED is not set
CONFIG_USB_EHCI_PCI=y
CONFIG_USB_EHCI_HCD_PLATFORM=y
# CONFIG_USB_OXU210HP_HCD is not set
# CONFIG_USB_ISP116X_HCD is not set
CONFIG_USB_ISP1760_HCD=y
CONFIG_USB_ISP1362_HCD=y
CONFIG_USB_FUSBH200_HCD=y
# CONFIG_USB_FOTG210_HCD is not set
# CONFIG_USB_OHCI_HCD is not set
# CONFIG_USB_UHCI_HCD is not set
CONFIG_USB_SL811_HCD=y
CONFIG_USB_SL811_HCD_ISO=y
# CONFIG_USB_R8A66597_HCD is not set
CONFIG_USB_HCD_BCMA=y
CONFIG_USB_HCD_TEST_MODE=y
# CONFIG_USB_RENESAS_USBHS is not set

#
# USB Device Class drivers
#
# CONFIG_USB_ACM is not set
# CONFIG_USB_PRINTER is not set
# CONFIG_USB_WDM is not set
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
CONFIG_USB_MUSB_HDRC=y
# CONFIG_USB_MUSB_HOST is not set
# CONFIG_USB_MUSB_GADGET is not set
CONFIG_USB_MUSB_DUAL_ROLE=y
CONFIG_USB_MUSB_TUSB6010=y
# CONFIG_USB_MUSB_UX500 is not set
CONFIG_MUSB_PIO_ONLY=y
CONFIG_USB_DWC3=y
# CONFIG_USB_DWC3_HOST is not set
CONFIG_USB_DWC3_GADGET=y
# CONFIG_USB_DWC3_DUAL_ROLE is not set

#
# Platform Glue Driver Support
#
CONFIG_USB_DWC3_OMAP=y
CONFIG_USB_DWC3_EXYNOS=y
CONFIG_USB_DWC3_PCI=y
# CONFIG_USB_DWC3_KEYSTONE is not set

#
# Debugging features
#
CONFIG_USB_DWC3_DEBUG=y
CONFIG_USB_DWC3_VERBOSE=y
CONFIG_USB_CHIPIDEA=y
# CONFIG_USB_CHIPIDEA_UDC is not set
CONFIG_USB_CHIPIDEA_HOST=y
# CONFIG_USB_CHIPIDEA_DEBUG is not set

#
# USB port drivers
#
# CONFIG_USB_SERIAL is not set

#
# USB Miscellaneous drivers
#
CONFIG_USB_EMI62=y
CONFIG_USB_EMI26=y
CONFIG_USB_ADUTUX=y
# CONFIG_USB_SEVSEG is not set
# CONFIG_USB_RIO500 is not set
CONFIG_USB_LEGOTOWER=y
# CONFIG_USB_LCD is not set
CONFIG_USB_LED=y
CONFIG_USB_CYPRESS_CY7C63=y
CONFIG_USB_CYTHERM=y
CONFIG_USB_IDMOUSE=y
# CONFIG_USB_FTDI_ELAN is not set
CONFIG_USB_APPLEDISPLAY=y
CONFIG_USB_SISUSBVGA=y
CONFIG_USB_LD=y
CONFIG_USB_TRANCEVIBRATOR=y
# CONFIG_USB_IOWARRIOR is not set
# CONFIG_USB_TEST is not set
# CONFIG_USB_EHSET_TEST_FIXTURE is not set
# CONFIG_USB_ISIGHTFW is not set
# CONFIG_USB_YUREX is not set
CONFIG_USB_EZUSB_FX2=y
CONFIG_USB_HSIC_USB3503=y

#
# USB Physical Layer drivers
#
CONFIG_USB_PHY=y
CONFIG_USB_OTG_FSM=y
CONFIG_NOP_USB_XCEIV=y
CONFIG_SAMSUNG_USBPHY=y
CONFIG_SAMSUNG_USB2PHY=y
CONFIG_SAMSUNG_USB3PHY=y
CONFIG_USB_GPIO_VBUS=y
# CONFIG_TAHVO_USB is not set
CONFIG_USB_ISP1301=y
# CONFIG_USB_RCAR_PHY is not set
CONFIG_USB_GADGET=y
# CONFIG_USB_GADGET_DEBUG is not set
# CONFIG_USB_GADGET_DEBUG_FILES is not set
# CONFIG_USB_GADGET_DEBUG_FS is not set
CONFIG_USB_GADGET_VBUS_DRAW=2
CONFIG_USB_GADGET_STORAGE_NUM_BUFFERS=2

#
# USB Peripheral Controller
#
# CONFIG_USB_FOTG210_UDC is not set
CONFIG_USB_GR_UDC=y
CONFIG_USB_R8A66597=y
CONFIG_USB_PXA27X=y
CONFIG_USB_MV_UDC=y
CONFIG_USB_MV_U3D=y
CONFIG_USB_M66592=y
# CONFIG_USB_AMD5536UDC is not set
CONFIG_USB_NET2272=y
# CONFIG_USB_NET2272_DMA is not set
# CONFIG_USB_NET2280 is not set
# CONFIG_USB_GOKU is not set
# CONFIG_USB_EG20T is not set
CONFIG_USB_DUMMY_HCD=y
CONFIG_USB_LIBCOMPOSITE=y
CONFIG_USB_F_FS=y
CONFIG_USB_CONFIGFS=y
# CONFIG_USB_CONFIGFS_SERIAL is not set
# CONFIG_USB_CONFIGFS_ACM is not set
# CONFIG_USB_CONFIGFS_OBEX is not set
# CONFIG_USB_CONFIGFS_NCM is not set
# CONFIG_USB_CONFIGFS_ECM is not set
# CONFIG_USB_CONFIGFS_ECM_SUBSET is not set
# CONFIG_USB_CONFIGFS_RNDIS is not set
# CONFIG_USB_CONFIGFS_EEM is not set
# CONFIG_USB_CONFIGFS_F_LB_SS is not set
CONFIG_USB_CONFIGFS_F_FS=y
# CONFIG_USB_ZERO is not set
# CONFIG_USB_AUDIO is not set
# CONFIG_USB_ETH is not set
# CONFIG_USB_G_NCM is not set
# CONFIG_USB_GADGETFS is not set
# CONFIG_USB_FUNCTIONFS is not set
# CONFIG_USB_G_SERIAL is not set
# CONFIG_USB_MIDI_GADGET is not set
# CONFIG_USB_G_PRINTER is not set
# CONFIG_USB_CDC_COMPOSITE is not set
# CONFIG_USB_G_HID is not set
# CONFIG_USB_G_DBGP is not set
# CONFIG_USB_G_WEBCAM is not set
# CONFIG_UWB is not set
CONFIG_MMC=y
# CONFIG_MMC_DEBUG is not set
# CONFIG_MMC_UNSAFE_RESUME is not set
# CONFIG_MMC_CLKGATE is not set

#
# MMC/SD/SDIO Card Drivers
#
# CONFIG_SDIO_UART is not set
# CONFIG_MMC_TEST is not set

#
# MMC/SD/SDIO Host Controller Drivers
#
CONFIG_MMC_SDHCI=y
# CONFIG_MMC_SDHCI_PCI is not set
# CONFIG_MMC_SDHCI_ACPI is not set
CONFIG_MMC_SDHCI_PLTFM=y
CONFIG_MMC_WBSD=y
# CONFIG_MMC_TIFM_SD is not set
# CONFIG_MMC_CB710 is not set
# CONFIG_MMC_VIA_SDMMC is not set
# CONFIG_MMC_VUB300 is not set
CONFIG_MMC_USHC=y
# CONFIG_MEMSTICK is not set
CONFIG_NEW_LEDS=y
CONFIG_LEDS_CLASS=y

#
# LED drivers
#
CONFIG_LEDS_LM3530=y
# CONFIG_LEDS_LM3533 is not set
CONFIG_LEDS_LM3642=y
CONFIG_LEDS_PCA9532=y
# CONFIG_LEDS_PCA9532_GPIO is not set
CONFIG_LEDS_GPIO=y
# CONFIG_LEDS_LP3944 is not set
CONFIG_LEDS_LP55XX_COMMON=y
CONFIG_LEDS_LP5521=y
CONFIG_LEDS_LP5523=y
CONFIG_LEDS_LP5562=y
CONFIG_LEDS_LP8501=y
CONFIG_LEDS_PCA955X=y
CONFIG_LEDS_PCA963X=y
CONFIG_LEDS_PCA9685=y
CONFIG_LEDS_WM831X_STATUS=y
CONFIG_LEDS_WM8350=y
CONFIG_LEDS_REGULATOR=y
CONFIG_LEDS_BD2802=y
# CONFIG_LEDS_LT3593 is not set
CONFIG_LEDS_MC13783=y
# CONFIG_LEDS_TCA6507 is not set
CONFIG_LEDS_LM355x=y
CONFIG_LEDS_OT200=y
CONFIG_LEDS_BLINKM=y

#
# LED Triggers
#
# CONFIG_LEDS_TRIGGERS is not set
CONFIG_ACCESSIBILITY=y
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
CONFIG_TIMB_DMA=y
# CONFIG_PCH_DMA is not set
CONFIG_DMA_ENGINE=y
CONFIG_DMA_ACPI=y

#
# DMA Clients
#
CONFIG_ASYNC_TX_DMA=y
CONFIG_DMATEST=y
# CONFIG_AUXDISPLAY is not set
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
CONFIG_STAGING=y
# CONFIG_SLICOSS is not set
# CONFIG_USBIP_CORE is not set
CONFIG_ECHO=y
# CONFIG_TRANZPORT is not set
# CONFIG_LINE6_USB is not set
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
# CONFIG_AD7291 is not set
CONFIG_AD7606=y
CONFIG_AD7606_IFACE_PARALLEL=y
CONFIG_AD799X=y
CONFIG_AD799X_RING_BUFFER=y

#
# Analog digital bi-direction converters
#
CONFIG_ADT7316=y
CONFIG_ADT7316_I2C=y

#
# Capacitance to digital converters
#
CONFIG_AD7150=y
# CONFIG_AD7152 is not set
CONFIG_AD7746=y

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
# CONFIG_SENSORS_ISL29028 is not set
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
# CONFIG_ADE7854_I2C is not set

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
# CONFIG_BCM_WIMAX is not set
# CONFIG_FT1000 is not set

#
# Speakup console speech
#
CONFIG_TOUCHSCREEN_CLEARPAD_TM1217=y
CONFIG_TOUCHSCREEN_SYNAPTICS_I2C_RMI4=y
CONFIG_STAGING_MEDIA=y
CONFIG_DVB_AS102=y
CONFIG_I2C_BCM2048=y
# CONFIG_DVB_CXD2099 is not set
# CONFIG_VIDEO_DT3155 is not set
CONFIG_VIDEO_GO7007=y
# CONFIG_VIDEO_GO7007_USB is not set
CONFIG_VIDEO_GO7007_LOADER=y
CONFIG_USB_MSI3101=y
# CONFIG_USB_SN9C102 is not set
# CONFIG_SOLO6X10 is not set
# CONFIG_LIRC_STAGING is not set

#
# Android
#
CONFIG_ANDROID=y
CONFIG_ANDROID_BINDER_IPC=y
CONFIG_ANDROID_LOGGER=y
CONFIG_ANDROID_TIMED_OUTPUT=y
CONFIG_ANDROID_TIMED_GPIO=y
# CONFIG_ANDROID_LOW_MEMORY_KILLER is not set
# CONFIG_SYNC is not set
# CONFIG_ION is not set
# CONFIG_USB_WPAN_HCD is not set
# CONFIG_WIMAX_GDM72XX is not set
CONFIG_CED1401=y
# CONFIG_DGRP is not set
CONFIG_USB_DWC2=y
CONFIG_USB_DWC2_DEBUG=y
# CONFIG_USB_DWC2_VERBOSE is not set
# CONFIG_USB_DWC2_TRACK_MISSED_SOFS is not set
# CONFIG_USB_DWC2_DEBUG_PERIODIC is not set
# CONFIG_XILLYBUS is not set
# CONFIG_DGNC is not set
# CONFIG_DGAP is not set
CONFIG_X86_PLATFORM_DEVICES=y
# CONFIG_ACERHDF is not set
# CONFIG_ASUS_LAPTOP is not set
CONFIG_DELL_LAPTOP=y
# CONFIG_FUJITSU_LAPTOP is not set
# CONFIG_FUJITSU_TABLET is not set
# CONFIG_HP_ACCEL is not set
# CONFIG_PANASONIC_LAPTOP is not set
# CONFIG_THINKPAD_ACPI is not set
CONFIG_SENSORS_HDAPS=y
# CONFIG_INTEL_MENLOW is not set
# CONFIG_ACPI_WMI is not set
# CONFIG_TOPSTAR_LAPTOP is not set
# CONFIG_TOSHIBA_BT_RFKILL is not set
# CONFIG_ACPI_CMPC is not set
# CONFIG_INTEL_IPS is not set
# CONFIG_IBM_RTL is not set
# CONFIG_XO15_EBOOK is not set
CONFIG_SAMSUNG_LAPTOP=y
# CONFIG_SAMSUNG_Q10 is not set
# CONFIG_APPLE_GMUX is not set
# CONFIG_INTEL_RST is not set
# CONFIG_INTEL_SMARTCONNECT is not set
# CONFIG_PVPANIC is not set
CONFIG_CHROME_PLATFORMS=y
# CONFIG_CHROMEOS_PSTORE is not set

#
# Hardware Spinlock drivers
#
CONFIG_CLKEVT_I8253=y
CONFIG_I8253_LOCK=y
CONFIG_CLKBLD_I8253=y
# CONFIG_MAILBOX is not set
CONFIG_IOMMU_SUPPORT=y
# CONFIG_AMD_IOMMU is not set

#
# Remoteproc drivers
#
# CONFIG_STE_MODEM_RPROC is not set

#
# Rpmsg drivers
#
CONFIG_PM_DEVFREQ=y

#
# DEVFREQ Governors
#
# CONFIG_DEVFREQ_GOV_SIMPLE_ONDEMAND is not set
CONFIG_DEVFREQ_GOV_PERFORMANCE=y
# CONFIG_DEVFREQ_GOV_POWERSAVE is not set
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
CONFIG_EXTCON_MAX77693=y
CONFIG_EXTCON_ARIZONA=y
# CONFIG_EXTCON_PALMAS is not set
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
CONFIG_IIO_ST_ACCEL_3AXIS=y
CONFIG_IIO_ST_ACCEL_I2C_3AXIS=y

#
# Analog to digital converters
#
# CONFIG_MAX1363 is not set
# CONFIG_MCP3422 is not set
CONFIG_NAU7802=y
# CONFIG_TI_ADC081C is not set
CONFIG_TWL6030_GPADC=y
# CONFIG_VIPERBOARD_ADC is not set

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
# CONFIG_AD5380 is not set
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
CONFIG_IIO_ST_GYRO_3AXIS=y
CONFIG_IIO_ST_GYRO_I2C_3AXIS=y
# CONFIG_ITG3200 is not set

#
# Humidity sensors
#
CONFIG_DHT11=y

#
# Inertial measurement units
#
CONFIG_INV_MPU6050_IIO=y

#
# Light sensors
#
# CONFIG_ADJD_S311 is not set
# CONFIG_APDS9300 is not set
# CONFIG_CM32181 is not set
# CONFIG_CM36651 is not set
CONFIG_GP2AP020A00F=y
CONFIG_SENSORS_LM3533=y
# CONFIG_TCS3472 is not set
CONFIG_SENSORS_TSL2563=y
CONFIG_TSL4531=y
# CONFIG_VCNL4000 is not set

#
# Magnetometer sensors
#
CONFIG_AK8975=y
# CONFIG_MAG3110 is not set
CONFIG_IIO_ST_MAGN_3AXIS=y
CONFIG_IIO_ST_MAGN_I2C_3AXIS=y

#
# Inclinometer sensors
#

#
# Triggers - standalone
#
CONFIG_IIO_INTERRUPT_TRIGGER=y
# CONFIG_IIO_SYSFS_TRIGGER is not set

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
# CONFIG_PWM is not set
CONFIG_IPACK_BUS=y
# CONFIG_BOARD_TPCI200 is not set
# CONFIG_SERIAL_IPOCTAL is not set
CONFIG_RESET_CONTROLLER=y
# CONFIG_FMC is not set

#
# PHY Subsystem
#
# CONFIG_GENERIC_PHY is not set
CONFIG_PHY_EXYNOS_MIPI_VIDEO=y
# CONFIG_POWERCAP is not set

#
# Firmware Drivers
#
CONFIG_EDD=y
# CONFIG_EDD_OFF is not set
# CONFIG_FIRMWARE_MEMMAP is not set
CONFIG_DELL_RBU=y
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
# CONFIG_FILE_LOCKING is not set
CONFIG_FSNOTIFY=y
# CONFIG_DNOTIFY is not set
CONFIG_INOTIFY_USER=y
# CONFIG_FANOTIFY is not set
# CONFIG_QUOTA is not set
# CONFIG_QUOTACTL is not set
CONFIG_AUTOFS4_FS=y
CONFIG_FUSE_FS=y
# CONFIG_CUSE is not set

#
# Caches
#
CONFIG_FSCACHE=y
CONFIG_FSCACHE_STATS=y
CONFIG_FSCACHE_HISTOGRAM=y
# CONFIG_FSCACHE_DEBUG is not set
# CONFIG_FSCACHE_OBJECT_LIST is not set

#
# Pseudo filesystems
#
CONFIG_PROC_FS=y
# CONFIG_PROC_KCORE is not set
CONFIG_PROC_VMCORE=y
# CONFIG_PROC_SYSCTL is not set
# CONFIG_PROC_PAGE_MONITOR is not set
CONFIG_SYSFS=y
# CONFIG_HUGETLBFS is not set
# CONFIG_HUGETLB_PAGE is not set
CONFIG_CONFIGFS_FS=y
CONFIG_MISC_FILESYSTEMS=y
CONFIG_JFFS2_FS=y
CONFIG_JFFS2_FS_DEBUG=0
# CONFIG_JFFS2_FS_WRITEBUFFER is not set
# CONFIG_JFFS2_SUMMARY is not set
# CONFIG_JFFS2_FS_XATTR is not set
CONFIG_JFFS2_COMPRESSION_OPTIONS=y
CONFIG_JFFS2_ZLIB=y
CONFIG_JFFS2_LZO=y
CONFIG_JFFS2_RTIME=y
# CONFIG_JFFS2_RUBIN is not set
CONFIG_JFFS2_CMODE_NONE=y
# CONFIG_JFFS2_CMODE_PRIORITY is not set
# CONFIG_JFFS2_CMODE_SIZE is not set
# CONFIG_JFFS2_CMODE_FAVOURLZO is not set
# CONFIG_UBIFS_FS is not set
# CONFIG_LOGFS is not set
CONFIG_ROMFS_FS=y
CONFIG_ROMFS_BACKED_BY_MTD=y
CONFIG_ROMFS_ON_MTD=y
# CONFIG_PSTORE is not set
CONFIG_NETWORK_FILESYSTEMS=y
CONFIG_NLS=y
CONFIG_NLS_DEFAULT="iso8859-1"
CONFIG_NLS_CODEPAGE_437=y
# CONFIG_NLS_CODEPAGE_737 is not set
# CONFIG_NLS_CODEPAGE_775 is not set
# CONFIG_NLS_CODEPAGE_850 is not set
CONFIG_NLS_CODEPAGE_852=y
CONFIG_NLS_CODEPAGE_855=y
CONFIG_NLS_CODEPAGE_857=y
# CONFIG_NLS_CODEPAGE_860 is not set
CONFIG_NLS_CODEPAGE_861=y
# CONFIG_NLS_CODEPAGE_862 is not set
CONFIG_NLS_CODEPAGE_863=y
CONFIG_NLS_CODEPAGE_864=y
# CONFIG_NLS_CODEPAGE_865 is not set
# CONFIG_NLS_CODEPAGE_866 is not set
CONFIG_NLS_CODEPAGE_869=y
CONFIG_NLS_CODEPAGE_936=y
CONFIG_NLS_CODEPAGE_950=y
CONFIG_NLS_CODEPAGE_932=y
# CONFIG_NLS_CODEPAGE_949 is not set
CONFIG_NLS_CODEPAGE_874=y
CONFIG_NLS_ISO8859_8=y
CONFIG_NLS_CODEPAGE_1250=y
# CONFIG_NLS_CODEPAGE_1251 is not set
# CONFIG_NLS_ASCII is not set
CONFIG_NLS_ISO8859_1=y
CONFIG_NLS_ISO8859_2=y
CONFIG_NLS_ISO8859_3=y
CONFIG_NLS_ISO8859_4=y
# CONFIG_NLS_ISO8859_5 is not set
# CONFIG_NLS_ISO8859_6 is not set
CONFIG_NLS_ISO8859_7=y
CONFIG_NLS_ISO8859_9=y
# CONFIG_NLS_ISO8859_13 is not set
CONFIG_NLS_ISO8859_14=y
CONFIG_NLS_ISO8859_15=y
CONFIG_NLS_KOI8_R=y
CONFIG_NLS_KOI8_U=y
CONFIG_NLS_MAC_ROMAN=y
CONFIG_NLS_MAC_CELTIC=y
CONFIG_NLS_MAC_CENTEURO=y
CONFIG_NLS_MAC_CROATIAN=y
CONFIG_NLS_MAC_CYRILLIC=y
CONFIG_NLS_MAC_GAELIC=y
CONFIG_NLS_MAC_GREEK=y
# CONFIG_NLS_MAC_ICELAND is not set
# CONFIG_NLS_MAC_INUIT is not set
CONFIG_NLS_MAC_ROMANIAN=y
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
# CONFIG_DEBUG_INFO is not set
# CONFIG_ENABLE_WARN_DEPRECATED is not set
# CONFIG_ENABLE_MUST_CHECK is not set
CONFIG_FRAME_WARN=2048
# CONFIG_STRIP_ASM_SYMS is not set
CONFIG_READABLE_ASM=y
# CONFIG_UNUSED_SYMBOLS is not set
CONFIG_DEBUG_FS=y
# CONFIG_HEADERS_CHECK is not set
CONFIG_DEBUG_SECTION_MISMATCH=y
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
CONFIG_SLUB_STATS=y
CONFIG_HAVE_DEBUG_KMEMLEAK=y
# CONFIG_DEBUG_KMEMLEAK is not set
# CONFIG_DEBUG_STACK_USAGE is not set
CONFIG_DEBUG_VM=y
# CONFIG_DEBUG_VM_RB is not set
CONFIG_DEBUG_VIRTUAL=y
CONFIG_DEBUG_MEMORY_INIT=y
CONFIG_MEMORY_NOTIFIER_ERROR_INJECT=y
# CONFIG_DEBUG_PER_CPU_MAPS is not set
CONFIG_HAVE_DEBUG_STACKOVERFLOW=y
# CONFIG_DEBUG_STACKOVERFLOW is not set
CONFIG_HAVE_ARCH_KMEMCHECK=y
# CONFIG_DEBUG_SHIRQ is not set

#
# Debug Lockups and Hangs
#
# CONFIG_LOCKUP_DETECTOR is not set
# CONFIG_DETECT_HUNG_TASK is not set
# CONFIG_PANIC_ON_OOPS is not set
CONFIG_PANIC_ON_OOPS_VALUE=0
CONFIG_PANIC_TIMEOUT=0
CONFIG_SCHED_DEBUG=y
CONFIG_SCHEDSTATS=y
CONFIG_TIMER_STATS=y

#
# Lock Debugging (spinlocks, mutexes, etc...)
#
# CONFIG_DEBUG_RT_MUTEXES is not set
# CONFIG_RT_MUTEX_TESTER is not set
CONFIG_DEBUG_SPINLOCK=y
CONFIG_DEBUG_MUTEXES=y
CONFIG_DEBUG_WW_MUTEX_SLOWPATH=y
CONFIG_DEBUG_LOCK_ALLOC=y
CONFIG_PROVE_LOCKING=y
CONFIG_LOCKDEP=y
# CONFIG_LOCK_STAT is not set
CONFIG_DEBUG_LOCKDEP=y
CONFIG_DEBUG_ATOMIC_SLEEP=y
CONFIG_DEBUG_LOCKING_API_SELFTESTS=y
CONFIG_TRACE_IRQFLAGS=y
CONFIG_STACKTRACE=y
# CONFIG_DEBUG_KOBJECT is not set
CONFIG_DEBUG_BUGVERBOSE=y
# CONFIG_DEBUG_WRITECOUNT is not set
# CONFIG_DEBUG_LIST is not set
CONFIG_DEBUG_SG=y
# CONFIG_DEBUG_NOTIFIERS is not set
# CONFIG_DEBUG_CREDENTIALS is not set

#
# RCU Debugging
#
CONFIG_PROVE_RCU=y
# CONFIG_PROVE_RCU_REPEATEDLY is not set
CONFIG_SPARSE_RCU_POINTER=y
# CONFIG_RCU_TORTURE_TEST is not set
CONFIG_RCU_CPU_STALL_TIMEOUT=21
# CONFIG_RCU_CPU_STALL_INFO is not set
CONFIG_RCU_TRACE=y
CONFIG_NOTIFIER_ERROR_INJECTION=y
CONFIG_CPU_NOTIFIER_ERROR_INJECT=y
# CONFIG_PM_NOTIFIER_ERROR_INJECT is not set
CONFIG_FAULT_INJECTION=y
CONFIG_FAILSLAB=y
# CONFIG_FAIL_PAGE_ALLOC is not set
CONFIG_FAIL_MMC_REQUEST=y
CONFIG_FAULT_INJECTION_DEBUG_FS=y
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
CONFIG_HAVE_FENTRY=y
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
# CONFIG_TEST_STRING_HELPERS is not set
CONFIG_TEST_KSTRTOX=y
# CONFIG_PROVIDE_OHCI1394_DMA_INIT is not set
# CONFIG_DMA_API_DEBUG is not set
# CONFIG_SAMPLES is not set
CONFIG_HAVE_ARCH_KGDB=y
# CONFIG_KGDB is not set
CONFIG_STRICT_DEVMEM=y
CONFIG_X86_VERBOSE_BOOTUP=y
# CONFIG_EARLY_PRINTK is not set
# CONFIG_X86_PTDUMP is not set
CONFIG_DEBUG_RODATA=y
CONFIG_DEBUG_RODATA_TEST=y
CONFIG_DOUBLEFAULT=y
CONFIG_DEBUG_TLBFLUSH=y
# CONFIG_IOMMU_STRESS is not set
CONFIG_HAVE_MMIOTRACE_SUPPORT=y
CONFIG_IO_DELAY_TYPE_0X80=0
CONFIG_IO_DELAY_TYPE_0XED=1
CONFIG_IO_DELAY_TYPE_UDELAY=2
CONFIG_IO_DELAY_TYPE_NONE=3
# CONFIG_IO_DELAY_0X80 is not set
# CONFIG_IO_DELAY_0XED is not set
# CONFIG_IO_DELAY_UDELAY is not set
CONFIG_IO_DELAY_NONE=y
CONFIG_DEFAULT_IO_DELAY_TYPE=3
# CONFIG_DEBUG_BOOT_PARAMS is not set
# CONFIG_CPA_DEBUG is not set
# CONFIG_OPTIMIZE_INLINING is not set
# CONFIG_DEBUG_NMI_SELFTEST is not set
CONFIG_X86_DEBUG_STATIC_CPU_HAS=y

#
# Security options
#
# CONFIG_KEYS is not set
CONFIG_SECURITY_DMESG_RESTRICT=y
CONFIG_SECURITY=y
CONFIG_SECURITYFS=y
# CONFIG_SECURITY_NETWORK is not set
CONFIG_SECURITY_PATH=y
# CONFIG_SECURITY_TOMOYO is not set
# CONFIG_SECURITY_APPARMOR is not set
# CONFIG_SECURITY_YAMA is not set
CONFIG_INTEGRITY=y
CONFIG_IMA=y
CONFIG_IMA_MEASURE_PCR_IDX=10
# CONFIG_IMA_TEMPLATE is not set
# CONFIG_IMA_NG_TEMPLATE is not set
CONFIG_IMA_SIG_TEMPLATE=y
CONFIG_IMA_DEFAULT_TEMPLATE="ima-sig"
CONFIG_IMA_DEFAULT_HASH_SHA1=y
# CONFIG_IMA_DEFAULT_HASH_WP512 is not set
CONFIG_IMA_DEFAULT_HASH="sha1"
# CONFIG_IMA_APPRAISE is not set
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
CONFIG_CRYPTO_PCOMP=y
CONFIG_CRYPTO_PCOMP2=y
CONFIG_CRYPTO_MANAGER=y
CONFIG_CRYPTO_MANAGER2=y
# CONFIG_CRYPTO_USER is not set
CONFIG_CRYPTO_MANAGER_DISABLE_TESTS=y
CONFIG_CRYPTO_GF128MUL=y
CONFIG_CRYPTO_NULL=y
CONFIG_CRYPTO_PCRYPT=y
CONFIG_CRYPTO_WORKQUEUE=y
CONFIG_CRYPTO_CRYPTD=y
# CONFIG_CRYPTO_AUTHENC is not set
CONFIG_CRYPTO_ABLK_HELPER=y
CONFIG_CRYPTO_GLUE_HELPER_X86=y

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
CONFIG_CRYPTO_VMAC=y

#
# Digest
#
# CONFIG_CRYPTO_CRC32C is not set
# CONFIG_CRYPTO_CRC32C_INTEL is not set
CONFIG_CRYPTO_CRC32=y
# CONFIG_CRYPTO_CRC32_PCLMUL is not set
CONFIG_CRYPTO_CRCT10DIF=y
# CONFIG_CRYPTO_CRCT10DIF_PCLMUL is not set
CONFIG_CRYPTO_GHASH=y
# CONFIG_CRYPTO_MD4 is not set
CONFIG_CRYPTO_MD5=y
CONFIG_CRYPTO_MICHAEL_MIC=y
CONFIG_CRYPTO_RMD128=y
CONFIG_CRYPTO_RMD160=y
CONFIG_CRYPTO_RMD256=y
CONFIG_CRYPTO_RMD320=y
CONFIG_CRYPTO_SHA1=y
CONFIG_CRYPTO_SHA1_SSSE3=y
# CONFIG_CRYPTO_SHA256_SSSE3 is not set
# CONFIG_CRYPTO_SHA512_SSSE3 is not set
# CONFIG_CRYPTO_SHA256 is not set
# CONFIG_CRYPTO_SHA512 is not set
CONFIG_CRYPTO_TGR192=y
CONFIG_CRYPTO_WP512=y
# CONFIG_CRYPTO_GHASH_CLMUL_NI_INTEL is not set

#
# Ciphers
#
CONFIG_CRYPTO_AES=y
CONFIG_CRYPTO_AES_X86_64=y
CONFIG_CRYPTO_AES_NI_INTEL=y
# CONFIG_CRYPTO_ANUBIS is not set
CONFIG_CRYPTO_ARC4=y
CONFIG_CRYPTO_BLOWFISH=y
CONFIG_CRYPTO_BLOWFISH_COMMON=y
CONFIG_CRYPTO_BLOWFISH_X86_64=y
CONFIG_CRYPTO_CAMELLIA=y
CONFIG_CRYPTO_CAMELLIA_X86_64=y
CONFIG_CRYPTO_CAMELLIA_AESNI_AVX_X86_64=y
CONFIG_CRYPTO_CAMELLIA_AESNI_AVX2_X86_64=y
CONFIG_CRYPTO_CAST_COMMON=y
CONFIG_CRYPTO_CAST5=y
# CONFIG_CRYPTO_CAST5_AVX_X86_64 is not set
CONFIG_CRYPTO_CAST6=y
CONFIG_CRYPTO_CAST6_AVX_X86_64=y
CONFIG_CRYPTO_DES=y
# CONFIG_CRYPTO_FCRYPT is not set
# CONFIG_CRYPTO_KHAZAD is not set
# CONFIG_CRYPTO_SALSA20 is not set
CONFIG_CRYPTO_SALSA20_X86_64=y
CONFIG_CRYPTO_SEED=y
CONFIG_CRYPTO_SERPENT=y
CONFIG_CRYPTO_SERPENT_SSE2_X86_64=y
CONFIG_CRYPTO_SERPENT_AVX_X86_64=y
CONFIG_CRYPTO_SERPENT_AVX2_X86_64=y
CONFIG_CRYPTO_TEA=y
CONFIG_CRYPTO_TWOFISH=y
CONFIG_CRYPTO_TWOFISH_COMMON=y
CONFIG_CRYPTO_TWOFISH_X86_64=y
CONFIG_CRYPTO_TWOFISH_X86_64_3WAY=y
# CONFIG_CRYPTO_TWOFISH_AVX_X86_64 is not set

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
CONFIG_CRYPTO_HASH_INFO=y
# CONFIG_CRYPTO_HW is not set
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
# CONFIG_LIBCRC32C is not set
CONFIG_CRC8=y
# CONFIG_CRC64_ECMA is not set
CONFIG_RANDOM32_SELFTEST=y
CONFIG_ZLIB_INFLATE=y
CONFIG_ZLIB_DEFLATE=y
CONFIG_LZO_COMPRESS=y
CONFIG_LZO_DECOMPRESS=y
CONFIG_LZ4_COMPRESS=y
CONFIG_LZ4HC_COMPRESS=y
CONFIG_LZ4_DECOMPRESS=y
# CONFIG_XZ_DEC is not set
# CONFIG_XZ_DEC_BCJ is not set
CONFIG_DECOMPRESS_GZIP=y
CONFIG_BCH=y
CONFIG_BCH_CONST_PARAMS=y
CONFIG_HAS_IOMEM=y
CONFIG_HAS_IOPORT=y
CONFIG_HAS_DMA=y
CONFIG_CPUMASK_OFFSTACK=y
CONFIG_CPU_RMAP=y
CONFIG_DQL=y
CONFIG_NLATTR=y
CONFIG_ARCH_HAS_ATOMIC64_DEC_IF_POSITIVE=y
CONFIG_AVERAGE=y
# CONFIG_CORDIC is not set
# CONFIG_DDR is not set

--/9DWx/yDrRhgMJTb
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

_______________________________________________
LKP mailing list
LKP@linux.intel.com

--/9DWx/yDrRhgMJTb--
