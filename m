Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752612AbaCGCKe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Mar 2014 21:10:34 -0500
Received: from mga01.intel.com ([192.55.52.88]:22543 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752337AbaCGCKS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Mar 2014 21:10:18 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,605,1389772800"; 
   d="log'?scan'208";a="487633456"
Date: Fri, 7 Mar 2014 09:28:47 +0800
From: Fengguang Wu <fengguang.wu@intel.com>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org
Subject: [torture] BUG: soft lockup - CPU#0 stuck for 22s!
 [lock_torture_wr:26]
Message-ID: <20140307012847.GA8427@localhost>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="k1lZvvs/B4yU6o8G"
Content-Disposition: inline
User-Agent: Heirloom mailx 12.5 6/20/10
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--k1lZvvs/B4yU6o8G
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Greetings,

I got the below dmesg and the first bad commit is

git://git.kernel.org/pub/scm/linux/kernel/git/paulmck/linux-rcu.git rcu/dev
commit 1f9c26968e1a501f3a839603c9633f21abca65b3
Author:     Paul E. McKenney <paulmck@linux.vnet.ibm.com>
AuthorDate: Tue Mar 4 11:03:21 2014 -0800
Commit:     Paul E. McKenney <paulmck@linux.vnet.ibm.com>
CommitDate: Wed Mar 5 07:49:28 2014 -0800

    torture: Increase stutter-end intensity
    
+------------------------------------------------+----+
|                                                |    |
+------------------------------------------------+----+
| boot_successes                                 | 0  |
| boot_failures                                  | 19 |
| BUG:soft_lockup-CPU_stuck_for_s                | 19 |
| EIP_is_at_stutter_wait                         | 19 |
| Kernel_panic-not_syncing:softlockup:hung_tasks | 19 |
| backtrace:lock_torture_writer                  | 19 |
+------------------------------------------------+----+

[   19.853890] CE: hpet increased min_delta_ns to 16875 nsec
[   19.853890] CE: hpet increased min_delta_ns to 25312 nsec
[   19.853890] hrtimer: interrupt took 3315122 ns
[   88.019164] BUG: soft lockup - CPU#0 stuck for 22s! [lock_torture_wr:26]
[   88.019164] Modules linked in:
[   88.019164] CPU: 0 PID: 26 Comm: lock_torture_wr Not tainted 3.14.0-rc5-03857-gaafcfca #2
[   88.019164] task: 8dfd8000 ti: 8dc02000 task.ti: 88a26000
[   88.019164] EIP: 0060:[<8109afde>] EFLAGS: 00000202 CPU: 0
[   88.019164] EIP is at stutter_wait+0x1d/0x5a
[   88.019164] EAX: 00000002 EBX: 815a9cf2 ECX: 00000000 EDX: 00000000
[   88.019164] ESI: 8b0e5438 EDI: 00000000 EBP: 88a27efc ESP: 88a27ef8
[   88.019164]  DS: 007b ES: 007b FS: 0000 GS: 00e0 SS: 0068
[   88.019164] CR0: 8005003b CR2: 00000000 CR3: 0186f000 CR4: 000006f0
[   88.019164] Stack:
[   88.019164]  8b96f300 88a27f20 81060f8e 815a9a86 815abef3 815a9a65 00000000 8b96f330
[   88.019164]  8b0e5438 81060e9e 88a27fac 8104c0f8 00000000 0000000c 8b0e5438 00000000
[   88.019164]  00000001 dead4ead ffffffff ffffffff 8187c858 00000000 00000000 815a6175
[   88.019164] Call Trace:
[   88.019164]  [<81060f8e>] lock_torture_writer+0xf0/0x13c
[   88.019164]  [<81060e9e>] ? torture_lock_busted_write_unlock+0x5/0x5
[   88.019164]  [<8104c0f8>] kthread+0xb7/0xbc
[   88.019164]  [<813f10bb>] ret_from_kernel_thread+0x1b/0x30
[   88.019164]  [<8104c041>] ? kthread_stop+0xaa/0xaa
[   88.019164] Code: 00 a1 3c c7 79 81 48 74 de 5b 58 5b 5d c3 55 89 e5 53 89 c3 eb 36 83 3d 0c c6 cd 81 00 74 17 a1 0c c6 cd 81 83 f8 01 75 02 eb 15 <a1> 0c c6 cd 81 85 c0 74 11 eb f5 b8 e8 03 00 00 e8 74 e8 f9 ff

git bisect start aafcfca36a7a26409af2ec2265927ed8ad6eb4b2 0414855fdc4a40da05221fc6062cccbc0c30f169 --
git bisect good bda89c7567044071e93d8b1c4c2f6e383c0fd249  # 16:21     20+      0  Merge 'drm/drm-next' into devel-hourly-2014030612
git bisect good 8eb78a8e0bca474d486a0505a1d38488119e8602  # 16:29     20+      0  Merge 'ath6kl/ath-next-test' into devel-hourly-2014030612
git bisect  bad e4729df86820a7132e41d401525acf24e4a25040  # 16:39      0-     13  Merge 'tip/x86/reboot' into devel-hourly-2014030612
git bisect good 07c4534e0d92e9600243ec4f9e27bd337c0617ff  # 16:52     20+      0  Merge 'ipsec-next/vti6' into devel-hourly-2014030612
git bisect  bad ace3f54462b01d674389eb0627c933cb6230a57b  # 17:11      0-      5  Merge 'rcu/rcu/dev' into devel-hourly-2014030612
git bisect good c236e3c6e2862c7d2d5f2f26eaa5ff86b896d1a0  # 17:26     20+      0  Merge 'tip/x86/efi' into devel-hourly-2014030612
git bisect good b46f358ae5e3558a9072f0354128d5749a584d01  # 17:36     20+      0  rcutorture: Place kvm-test-1-run.sh output into res directory
git bisect good f5604f67fe8cbd6f2088b20b9463f721aa613d4b  # 17:44     20+      0  Merge branch 'torture.2014.02.23a' into HEAD
git bisect good dd35b81c341c685bafd15bc9a6bfa79584e07b07  # 17:51     20+      0  torture: Rename RCU_BUILDONLY to TORTURE_BUILDONLY
git bisect good 8864f0996e8b7f07a536aa07553c4461cd5f4211  # 18:12     20+      0  torture: Make "--dryrun script" output self-sufficient
git bisect good b2d777a6d9d64929b9701f1905fdeda8fc3cb16d  # 18:34     20+      0  rcutorture: Print negatives for SRCU counter wraparound
git bisect good 4c79d7d89902a2e9c96b3db5115af52b3cf94da9  # 18:41     20+      0  torture: Report diagnostics from qemu
git bisect  bad 1f9c26968e1a501f3a839603c9633f21abca65b3  # 18:43      0-      9  torture: Increase stutter-end intensity
# first bad commit: [1f9c26968e1a501f3a839603c9633f21abca65b3] torture: Increase stutter-end intensity
git bisect good 4c79d7d89902a2e9c96b3db5115af52b3cf94da9  # 20:25     60+      0  torture: Report diagnostics from qemu
git bisect  bad aafcfca36a7a26409af2ec2265927ed8ad6eb4b2  # 20:26      0-     19  0day head guard for 'devel-hourly-2014030612'
git bisect good 7cd8d1c19dd10cb6861bbf7111ba86ef7d262788  # 23:19     60+      0  Revert "torture: Increase stutter-end intensity"
git bisect good c3bebc71c4bcdafa24b506adf0c1de3c1f77e2e0  # 23:26     60+      0  Merge git://git.kernel.org/pub/scm/linux/kernel/git/davem/net
git bisect good 0ffb2fe7b9c30082876fa3a17da018bf0632cf03  # 02:08     60+      0  Add linux-next specific files for 20140306

Thanks,
Fengguang

--k1lZvvs/B4yU6o8G
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="dmesg-quantal-lkp-nex05-61:20140306141300:i386-randconfig-ba1-03061322::"
Content-Transfer-Encoding: quoted-printable

early console in setup code
[    0.000000] Linux version 3.14.0-rc5-03857-gaafcfca (kbuild@bay) (gcc ve=
rsion 4.8.1 (Debian 4.8.1-8) ) #2 Thu Mar 6 14:09:51 CST 2014
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
[    0.000000] e820: last_pfn =3D 0xfffe max_arch_pfn =3D 0x1000000
[    0.000000] Scanning 1 areas for low memory corruption
[    0.000000] initial memory mapped: [mem 0x00000000-0x025fffff]
[    0.000000] Base memory trampoline at [8009b000] 9b000 size 16384
[    0.000000] init_memory_mapping: [mem 0x00000000-0x000fffff]
[    0.000000]  [mem 0x00000000-0x000fffff] page 4k
[    0.000000] init_memory_mapping: [mem 0x0e400000-0x0e5fffff]
[    0.000000]  [mem 0x0e400000-0x0e5fffff] page 4k
[    0.000000] BRK [0x01d0f000, 0x01d0ffff] PGTABLE
[    0.000000] init_memory_mapping: [mem 0x0c000000-0x0e3fffff]
[    0.000000]  [mem 0x0c000000-0x0e3fffff] page 4k
[    0.000000] BRK [0x01d10000, 0x01d10fff] PGTABLE
[    0.000000] BRK [0x01d11000, 0x01d11fff] PGTABLE
[    0.000000] BRK [0x01d12000, 0x01d12fff] PGTABLE
[    0.000000] BRK [0x01d13000, 0x01d13fff] PGTABLE
[    0.000000] BRK [0x01d14000, 0x01d14fff] PGTABLE
[    0.000000] init_memory_mapping: [mem 0x00100000-0x0bffffff]
[    0.000000]  [mem 0x00100000-0x0bffffff] page 4k
[    0.000000] init_memory_mapping: [mem 0x0e600000-0x0fffdfff]
[    0.000000]  [mem 0x0e600000-0x0fffdfff] page 4k
[    0.000000] RAMDISK: [mem 0x0e7ab000-0x0ffeffff]
[    0.000000] ACPI: RSDP 0x000F1960 000014 (v00 BOCHS )
[    0.000000] ACPI: RSDT 0x0FFFFB3C 000034 (v01 BOCHS  BXPCRSDT 00000001 B=
XPC 00000001)
[    0.000000] ACPI: FACP 0x0FFFF177 000074 (v01 BOCHS  BXPCFACP 00000001 B=
XPC 00000001)
[    0.000000] ACPI: DSDT 0x0FFFE040 001137 (v01 BXPC   BXDSDT   00000001 I=
NTL 20130823)
[    0.000000] ACPI: FACS 0x0FFFE000 000040
[    0.000000] ACPI: SSDT 0x0FFFF1EB 000899 (v01 BOCHS  BXPCSSDT 00000001 B=
XPC 00000001)
[    0.000000] ACPI: APIC 0x0FFFFA84 000080 (v01 BOCHS  BXPCAPIC 00000001 B=
XPC 00000001)
[    0.000000] ACPI: HPET 0x0FFFFB04 000038 (v01 BOCHS  BXPCHPET 00000001 B=
XPC 00000001)
[    0.000000] 255MB LOWMEM available.
[    0.000000]   mapped low ram: 0 - 0fffe000
[    0.000000]   low ram: 0 - 0fffe000
[    0.000000] kvm-clock: Using msrs 4b564d01 and 4b564d00
[    0.000000] kvm-clock: cpu 0, msr 0:fffd001, boot clock
[    0.000000] Zone ranges:
[    0.000000]   DMA      [mem 0x00001000-0x00ffffff]
[    0.000000]   Normal   [mem 0x01000000-0x0fffdfff]
[    0.000000] Movable zone start for each node
[    0.000000] Early memory node ranges
[    0.000000]   node   0: [mem 0x00001000-0x0009efff]
[    0.000000]   node   0: [mem 0x00100000-0x0fffdfff]
[    0.000000] On node 0 totalpages: 65436
[    0.000000] free_area_init_node: node 0, pgdat 817cd5a8, node_mem_map 8e=
359024
[    0.000000]   DMA zone: 36 pages used for memmap
[    0.000000]   DMA zone: 0 pages reserved
[    0.000000]   DMA zone: 3998 pages, LIFO batch:0
[    0.000000]   Normal zone: 540 pages used for memmap
[    0.000000]   Normal zone: 61438 pages, LIFO batch:15
[    0.000000] ACPI: PM-Timer IO Port: 0xb008
[    0.000000] ACPI: HPET id: 0x8086a201 base: 0xfed00000
[    0.000000] KVM setup async PF for cpu 0
[    0.000000] kvm-stealtime: cpu 0, msr 1654d00
[    0.000000] e820: [mem 0x10000000-0xfeffbfff] available for PCI devices
[    0.000000] Booting paravirtualized kernel on KVM
[    0.000000] pcpu-alloc: s0 r0 d32768 u32768 alloc=3D1*32768
[    0.000000] pcpu-alloc: [0] 0=20
[    0.000000] Built 1 zonelists in Zone order, mobility grouping on.  Tota=
l pages: 64860
[    0.000000] Kernel command line: hung_task_panic=3D1 earlyprintk=3DttyS0=
,115200 debug apic=3Ddebug sysrq_always_enabled panic=3D10 softlockup_panic=
=3D1 nmi_watchdog=3Dpanic  prompt_ramdisk=3D0 console=3DttyS0,115200 consol=
e=3Dtty0 vga=3Dnormal  root=3D/dev/ram0 rw link=3D/kernel-tests/run-queue/k=
vm/i386-randconfig-ba1-03061322/linux-devel:devel-hourly-2014030612/.vmlinu=
z-aafcfca36a7a26409af2ec2265927ed8ad6eb4b2-20140306141026-3-lkp-nex05 branc=
h=3Dlinux-devel/devel-hourly-2014030612 BOOT_IMAGE=3D/kernel/i386-randconfi=
g-ba1-03061322/aafcfca36a7a26409af2ec2265927ed8ad6eb4b2/vmlinuz-3.14.0-rc5-=
03857-gaafcfca
[    0.000000] sysrq: sysrq always enabled.
[    0.000000] PID hash table entries: 1024 (order: 0, 4096 bytes)
[    0.000000] Dentry cache hash table entries: 32768 (order: 5, 131072 byt=
es)
[    0.000000] Inode-cache hash table entries: 16384 (order: 4, 65536 bytes)
[    0.000000] Initializing CPU#0
[    0.000000] Memory: 220452K/261744K available (4038K kernel code, 1894K =
rwdata, 2356K rodata, 320K init, 4676K bss, 41292K reserved)
[    0.000000] virtual kernel memory layout:
[    0.000000]     fixmap  : 0xfffe0000 - 0xfffff000   ( 124 kB)
[    0.000000]     vmalloc : 0x907fe000 - 0xfffde000   (1783 MB)
[    0.000000]     lowmem  : 0x80000000 - 0x8fffe000   ( 255 MB)
[    0.000000]       .init : 0x8181b000 - 0x8186b000   ( 320 kB)
[    0.000000]       .data : 0x813f1e3a - 0x818199f0   (4254 kB)
[    0.000000]       .text : 0x81000000 - 0x813f1e3a   (4039 kB)
[    0.000000] Checking if this processor honours the WP bit even in superv=
isor mode...Ok.
[    0.000000] NR_IRQS:16 nr_irqs:16 16
[    0.000000] CPU 0 irqstacks, hard=3D8dc02000 soft=3D8dc04000
[    0.000000] ACPI: Core revision 20140214
[    0.000000] ACPI: All ACPI Tables successfully acquired
[    0.000000] ACPI: setting ELCR to 0200 (from 0c00)
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
[    0.000000]                     double unlock:  ok  |  ok  |  ok  |  ok =
 |  ok  |  ok  |
[    0.000000]                   initialize held:  ok  |  ok  |  ok  |  ok =
 |  ok  |  ok  |
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
[    0.000000]            spinlock nest unlocked:  ok  |
[    0.000000]   -----------------------------------------------------
[    0.000000]                                  |block | try  |context|
[    0.000000]   -----------------------------------------------------
[    0.000000]                           context:failed|  ok  |  ok  |
[    0.000000]                               try:failed|  ok  |failed|
[    0.000000]                             block:failed|  ok  |failed|
[    0.000000]                          spinlock:failed|  ok  |failed|
[    0.000000] --------------------------------------------------------
[    0.000000] 141 out of 253 testcases failed, as expected. |
[    0.000000] ----------------------------------------------------
[    0.000000] hpet clockevent registered
[    0.000000] tsc: Detected 1995.134 MHz processor
[    0.003000] Calibrating delay loop (skipped) preset value.. 3990.26 Bogo=
MIPS (lpj=3D1995134)
[    0.003409] pid_max: default: 32768 minimum: 301
[    0.004123] Mount-cache hash table entries: 512
[    0.006049] mce: CPU supports 10 MCE banks
[    0.006707] Last level iTLB entries: 4KB 0, 2MB 0, 4MB 0
[    0.006707] Last level dTLB entries: 4KB 0, 2MB 0, 4MB 0, 1GB 0
[    0.007008] CPU: Intel Common KVM processor (fam: 0f, model: 06, steppin=
g: 01)
[    0.012530] Performance Events: unsupported Netburst CPU model 6 no PMU =
driver, software events only.
[    0.014385] ftrace: Allocated trace_printk buffers
[    0.018355] NMI watchdog: disabled (cpu0): hardware events not enabled
[    0.019576] devtmpfs: initialized
[    0.022778] regulator-dummy: no parameters
[    0.023266] NET: Registered protocol family 16
[    0.025035] cpuidle: using governor ladder
[    0.025744] cpuidle: using governor menu
[    0.026329] ACPI: bus type PCI registered
[    0.027251] PCI : PCI BIOS area is rw and x. Use pci=3Dnobios if you wan=
t it NX.
[    0.028016] PCI: PCI BIOS revision 2.10 entry at 0xfd467, last bus=3D0
[    0.029009] PCI: Using configuration type 1 for base access
[    0.038468] ACPI: Added _OSI(Module Device)
[    0.039011] ACPI: Added _OSI(Processor Device)
[    0.039654] ACPI: Added _OSI(3.0 _SCP Extensions)
[    0.040011] ACPI: Added _OSI(Processor Aggregator Device)
[    0.063063] ACPI: Interpreter enabled
[    0.063614] ACPI: (supports S0)
[    0.064010] ACPI: Using PIC for interrupt routing
[    0.064795] PCI: Using host bridge windows from ACPI; if necessary, use =
"pci=3Dnocrs" and report a bug
[    0.095132] ACPI: PCI Root Bridge [PCI0] (domain 0000 [bus 00-ff])
[    0.096019] acpi PNP0A03:00: _OSC: OS supports [Segments]
[    0.096812] acpi PNP0A03:00: _OSC failed (AE_NOT_FOUND); disabling ASPM
[    0.098456] acpi PNP0A03:00: fail to add MMCONFIG information, can't acc=
ess extended PCI configuration space under this bridge.
[    0.102175] PCI host bridge to bus 0000:00
[    0.103023] pci_bus 0000:00: root bus resource [bus 00-ff]
[    0.104017] pci_bus 0000:00: root bus resource [io  0x0000-0x0cf7]
[    0.105016] pci_bus 0000:00: root bus resource [io  0x0d00-0xffff]
[    0.107015] pci_bus 0000:00: root bus resource [mem 0x000a0000-0x000bfff=
f]
[    0.108018] pci_bus 0000:00: root bus resource [mem 0x80000000-0xfebffff=
f]
[    0.109117] pci 0000:00:00.0: [8086:1237] type 00 class 0x060000
[    0.112367] pci 0000:00:01.0: [8086:7000] type 00 class 0x060100
[    0.114925] pci 0000:00:01.1: [8086:7010] type 00 class 0x010180
[    0.119920] pci 0000:00:01.1: reg 0x20: [io  0xc040-0xc04f]
[    0.123431] pci 0000:00:01.3: [8086:7113] type 00 class 0x068000
[    0.125183] pci 0000:00:01.3: quirk: [io  0xb000-0xb03f] claimed by PIIX=
4 ACPI
[    0.126031] pci 0000:00:01.3: quirk: [io  0xb100-0xb10f] claimed by PIIX=
4 SMB
[    0.128806] pci 0000:00:02.0: [1013:00b8] type 00 class 0x030000
[    0.132000] pci 0000:00:02.0: reg 0x10: [mem 0xfc000000-0xfdffffff pref]
[    0.134000] pci 0000:00:02.0: reg 0x14: [mem 0xfebf0000-0xfebf0fff]
[    0.146000] pci 0000:00:02.0: reg 0x30: [mem 0xfebe0000-0xfebeffff pref]
[    0.147483] pci 0000:00:03.0: [8086:100e] type 00 class 0x020000
[    0.149904] pci 0000:00:03.0: reg 0x10: [mem 0xfebc0000-0xfebdffff]
[    0.151901] pci 0000:00:03.0: reg 0x14: [io  0xc000-0xc03f]
[    0.161909] pci 0000:00:03.0: reg 0x30: [mem 0xfeb80000-0xfebbffff pref]
[    0.163514] pci 0000:00:04.0: [8086:25ab] type 00 class 0x088000
[    0.165488] pci 0000:00:04.0: reg 0x10: [mem 0xfebf1000-0xfebf100f]
[    0.174029] pci_bus 0000:00: on NUMA node 0
[    0.177025] ACPI: PCI Interrupt Link [LNKA] (IRQs 5 *10 11)
[    0.178665] ACPI: PCI Interrupt Link [LNKB] (IRQs 5 *10 11)
[    0.180549] ACPI: PCI Interrupt Link [LNKC] (IRQs 5 10 *11)
[    0.182310] ACPI: PCI Interrupt Link [LNKD] (IRQs 5 10 *11)
[    0.183579] ACPI: PCI Interrupt Link [LNKS] (IRQs *9)
[    0.185570] acpi LNXCPU:00: Invalid PBLK length [0]
[    0.187746] ACPI: Enabled 16 GPEs in block 00 to 0F
[    0.189639] vgaarb: device added: PCI:0000:00:02.0,decodes=3Dio+mem,owns=
=3Dio+mem,locks=3Dnone
[    0.190015] vgaarb: loaded
[    0.190496] vgaarb: bridge control possible 0000:00:02.0
[    0.192830] PCI: Using ACPI for IRQ routing
[    0.193013] PCI: pci_cache_line_size set to 64 bytes
[    0.194229] e820: reserve RAM buffer [mem 0x0009fc00-0x0009ffff]
[    0.195018] e820: reserve RAM buffer [mem 0x0fffe000-0x0fffffff]
[    0.197748] Bluetooth: Core ver 2.19
[    0.198081] NET: Registered protocol family 31
[    0.199011] Bluetooth: HCI device and connection manager initialized
[    0.200026] Bluetooth: HCI socket layer initialized
[    0.201013] Bluetooth: L2CAP socket layer initialized
[    0.202064] Bluetooth: SCO socket layer initialized
[    0.204144] Switched to clocksource kvm-clock
[    0.205916] Warning: could not register annotated branches stats
[    0.235751] pnp: PnP ACPI init
[    0.236480] ACPI: bus type PNP registered
[    0.237558] pnp 00:00: Plug and Play ACPI device, IDs PNP0b00 (active)
[    0.239243] pnp 00:01: Plug and Play ACPI device, IDs PNP0303 (active)
[    0.240713] pnp 00:02: Plug and Play ACPI device, IDs PNP0f13 (active)
[    0.242224] pnp 00:03: [dma 2]
[    0.242987] pnp 00:03: Plug and Play ACPI device, IDs PNP0700 (active)
[    0.244518] pnp 00:04: Plug and Play ACPI device, IDs PNP0400 (active)
[    0.246187] pnp 00:05: Plug and Play ACPI device, IDs PNP0501 (active)
[    0.247743] pnp 00:06: Plug and Play ACPI device, IDs PNP0501 (active)
[    0.250347] pnp 00:07: Plug and Play ACPI device, IDs PNP0103 (active)
[    0.252313] pnp: PnP ACPI: found 8 devices
[    0.253019] ACPI: bus type PNP unregistered
[    0.290776] pci_bus 0000:00: resource 4 [io  0x0000-0x0cf7]
[    0.291799] pci_bus 0000:00: resource 5 [io  0x0d00-0xffff]
[    0.292893] pci_bus 0000:00: resource 6 [mem 0x000a0000-0x000bffff]
[    0.294140] pci_bus 0000:00: resource 7 [mem 0x80000000-0xfebfffff]
[    0.295372] NET: Registered protocol family 2
[    0.296586] TCP established hash table entries: 2048 (order: 1, 8192 byt=
es)
[    0.297923] TCP bind hash table entries: 2048 (order: 4, 90112 bytes)
[    0.299283] TCP: Hash tables configured (established 2048 bind 2048)
[    0.300693] TCP: reno registered
[    0.301389] UDP hash table entries: 256 (order: 2, 24576 bytes)
[    0.302546] UDP-Lite hash table entries: 256 (order: 2, 24576 bytes)
[    0.303949] NET: Registered protocol family 1
[    0.304791] pci 0000:00:00.0: Limiting direct PCI/PCI transfers
[    0.305916] pci 0000:00:01.0: PIIX3: Enabling Passive Release
[    0.307133] pci 0000:00:01.0: Activating ISA DMA hang workarounds
[    0.308333] pci 0000:00:02.0: Boot video device
[    0.309318] PCI: CLS 0 bytes, default 64
[    0.310548] Unpacking initramfs...
[    2.392025] debug: unmapping init [mem 0x8e7ab000-0x8ffeffff]
[    2.396025] Scanning for low memory corruption every 60 seconds
[    2.398998] Initializing RT-Tester: OK
[    2.399679] spin_lock-torture:--- Start of test: nwriters_stress=3D2 sta=
t_interval=3D60 verbose=3D1 shuffle_interval=3D3 stutter=3D5 shutdown_secs=
=3D0 onoff_interval=3D0 onoff_holdoff=3D0
[    2.401800] spin_lock-torture: Creating torture_shuffle task
[    2.402795] spin_lock-torture: Creating torture_stutter task
[    2.403778] spin_lock-torture: torture_shuffle task started
[    2.404638] spin_lock-torture: Creating lock_torture_writer task
[    2.405618] spin_lock-torture: torture_stutter task started
[    2.406563] spin_lock-torture: Creating lock_torture_writer task
[    2.407543] spin_lock-torture: lock_torture_writer task started
[    2.408471] spin_lock-torture: Creating lock_torture_stats task
[    2.409407] spin_lock-torture: lock_torture_writer task started
[    2.411220] futex hash table entries: 256 (order: 1, 12288 bytes)
[    2.412172] Initialise system trusted keyring
[    2.414788] spin_lock-torture: lock_torture_stats task started
[    2.417325] jffs2: version 2.2. (NAND)=20
[    2.425785] Key type asymmetric registered
[    2.426543] Asymmetric key parser 'x509' registered
[    2.436063] list_sort_test: start testing list_sort()
[    2.438225] test_string_helpers: Running tests...
[    2.447671] crc32: CRC_LE_BITS =3D 1, CRC_BE BITS =3D 1
[    2.448455] crc32: self tests passed, processed 225944 bytes in 4171223 =
nsec
[    2.455242] crc32c: CRC_LE_BITS =3D 1
[    2.455835] crc32c: self tests passed, processed 225944 bytes in 2645747=
 nsec
[    3.131650] crc32_combine: 8373 self tests passed
[    3.396268] tsc: Refined TSC clocksource calibration: 1995.000 MHz
[    8.296162] random: nonblocking pool is initialized
[   19.853890] CE: hpet increased min_delta_ns to 5000 nsec
[   19.853890] CE: hpet increased min_delta_ns to 7500 nsec
[   19.853890] CE: hpet increased min_delta_ns to 11250 nsec
[   19.853890] CE: hpet increased min_delta_ns to 16875 nsec
[   19.853890] CE: hpet increased min_delta_ns to 25312 nsec
[   19.853890] hrtimer: interrupt took 3315122 ns
[   88.019164] BUG: soft lockup - CPU#0 stuck for 22s! [lock_torture_wr:26]
[   88.019164] Modules linked in:
[   88.019164] CPU: 0 PID: 26 Comm: lock_torture_wr Not tainted 3.14.0-rc5-=
03857-gaafcfca #2
[   88.019164] task: 8dfd8000 ti: 8dc02000 task.ti: 88a26000
[   88.019164] EIP: 0060:[<8109afde>] EFLAGS: 00000202 CPU: 0
[   88.019164] EIP is at stutter_wait+0x1d/0x5a
[   88.019164] EAX: 00000002 EBX: 815a9cf2 ECX: 00000000 EDX: 00000000
[   88.019164] ESI: 8b0e5438 EDI: 00000000 EBP: 88a27efc ESP: 88a27ef8
[   88.019164]  DS: 007b ES: 007b FS: 0000 GS: 00e0 SS: 0068
[   88.019164] CR0: 8005003b CR2: 00000000 CR3: 0186f000 CR4: 000006f0
[   88.019164] Stack:
[   88.019164]  8b96f300 88a27f20 81060f8e 815a9a86 815abef3 815a9a65 00000=
000 8b96f330
[   88.019164]  8b0e5438 81060e9e 88a27fac 8104c0f8 00000000 0000000c 8b0e5=
438 00000000
[   88.019164]  00000001 dead4ead ffffffff ffffffff 8187c858 00000000 00000=
000 815a6175
[   88.019164] Call Trace:
[   88.019164]  [<81060f8e>] lock_torture_writer+0xf0/0x13c
[   88.019164]  [<81060e9e>] ? torture_lock_busted_write_unlock+0x5/0x5
[   88.019164]  [<8104c0f8>] kthread+0xb7/0xbc
[   88.019164]  [<813f10bb>] ret_from_kernel_thread+0x1b/0x30
[   88.019164]  [<8104c041>] ? kthread_stop+0xaa/0xaa
[   88.019164] Code: 00 a1 3c c7 79 81 48 74 de 5b 58 5b 5d c3 55 89 e5 53 =
89 c3 eb 36 83 3d 0c c6 cd 81 00 74 17 a1 0c c6 cd 81 83 f8 01 75 02 eb 15 =
<a1> 0c c6 cd 81 85 c0 74 11 eb f5 b8 e8 03 00 00 e8 74 e8 f9 ff
[   88.019164] Kernel panic - not syncing: softlockup: hung tasks
[   88.019164] CPU: 0 PID: 26 Comm: lock_torture_wr Not tainted 3.14.0-rc5-=
03857-gaafcfca #2
[   88.019164]  00000000 00000000 8dc03ecc 813e81a1 8dc03eec 813e55a4 815a6=
26f 8187a464
[   88.019164]  8109aff2 00000001 88a27ebc 00000016 8dc03f24 8107aab9 815ad=
036 00000000
[   88.019164]  00000016 8dfd8220 0000001a ee6b2800 00000000 7e59f15c 00000=
014 00000000
[   88.019164] Call Trace:
[   88.019164]  [<813e81a1>] dump_stack+0x16/0x18
[   88.019164]  [<813e55a4>] panic+0xa6/0x1ba
[   88.019164]  [<8109aff2>] ? stutter_wait+0x31/0x5a
[   88.019164]  [<8107aab9>] watchdog_timer_fn+0x13d/0x15a
[   88.019164]  [<8107a97c>] ? __touch_watchdog+0x16/0x16
[   88.019164]  [<8104e6fe>] __run_hrtimer+0xd8/0x21c
[   88.019164]  [<8104f146>] hrtimer_interrupt+0xfe/0x228
[   88.019164]  [<8100482a>] timer_interrupt+0xd/0x14
[   88.019164]  [<81064e51>] handle_irq_event_percpu+0x4b/0x262
[   88.019164]  [<81060b1d>] ? do_raw_spin_unlock+0x98/0xc0
[   88.019164]  [<81065094>] handle_irq_event+0x2c/0x43
[   88.019164]  [<81067233>] handle_level_irq+0xad/0xc0
[   88.019164]  [<81067186>] ? cond_unmask_irq+0x26/0x26
[   88.019164]  <IRQ>  [<81004200>] ? do_IRQ+0x34/0x99
[   88.019164]  [<813eb9f3>] ? schedule_timeout+0x12b/0x15e
[   88.019164]  [<8105c288>] ? lock_release_holdtime+0xc1/0xcd
[   88.019164]  [<813f15d0>] ? common_interrupt+0x30/0x35
[   88.019164]  [<8109afde>] ? stutter_wait+0x1d/0x5a
[   88.019164]  [<81060f8e>] ? lock_torture_writer+0xf0/0x13c
[   88.019164]  [<81060e9e>] ? torture_lock_busted_write_unlock+0x5/0x5
[   88.019164]  [<8104c0f8>] ? kthread+0xb7/0xbc
[   88.019164]  [<813f10bb>] ? ret_from_kernel_thread+0x1b/0x30
[   88.019164]  [<8104c041>] ? kthread_stop+0xaa/0xaa
[   88.019164] Kernel Offset: 0x0 from 0x81000000 (relocation range: 0x8000=
0000-0x907fdfff)

Elapsed time: 100
qemu-system-x86_64 -cpu kvm64 -enable-kvm -kernel /kernel/i386-randconfig-b=
a1-03061322/aafcfca36a7a26409af2ec2265927ed8ad6eb4b2/vmlinuz-3.14.0-rc5-038=
57-gaafcfca -append 'hung_task_panic=3D1 earlyprintk=3DttyS0,115200 debug a=
pic=3Ddebug sysrq_always_enabled panic=3D10 softlockup_panic=3D1 nmi_watchd=
og=3Dpanic  prompt_ramdisk=3D0 console=3DttyS0,115200 console=3Dtty0 vga=3D=
normal  root=3D/dev/ram0 rw link=3D/kernel-tests/run-queue/kvm/i386-randcon=
fig-ba1-03061322/linux-devel:devel-hourly-2014030612/.vmlinuz-aafcfca36a7a2=
6409af2ec2265927ed8ad6eb4b2-20140306141026-3-lkp-nex05 branch=3Dlinux-devel=
/devel-hourly-2014030612 BOOT_IMAGE=3D/kernel/i386-randconfig-ba1-03061322/=
aafcfca36a7a26409af2ec2265927ed8ad6eb4b2/vmlinuz-3.14.0-rc5-03857-gaafcfca'=
  -initrd /kernel-tests/initrd/quantal-core-i386.cgz -m 256 -smp 2 -net nic=
,vlan=3D1,model=3De1000 -net user,vlan=3D1,hostfwd=3Dtcp::26465-:22 -boot o=
rder=3Dnc -no-reboot -watchdog i6300esb -rtc base=3Dlocaltime -pidfile /dev=
/shm/kboot/pid-quantal-lkp-nex05-61 -serial file:/dev/shm/kboot/serial-quan=
tal-lkp-nex05-61 -daemonize -display none -monitor null=20

--k1lZvvs/B4yU6o8G
Content-Type: application/octet-stream
Content-Disposition: attachment; filename="i386-randconfig-ba1-03061322-aafcfca36a7a26409af2ec2265927ed8ad6eb4b2-lock_torture_writer+-x-79189.log"
Content-Transfer-Encoding: base64

Z2l0IGNoZWNrb3V0IDA0MTQ4NTVmZGM0YTQwZGEwNTIyMWZjNjA2MmNjY2JjMGMzMGYxNjkK
bHMgLWEgL2tlcm5lbC10ZXN0cy9ydW4tcXVldWUva3ZtL2kzODYtcmFuZGNvbmZpZy1iYTEt
MDMwNjEzMjIvbGludXgtZGV2ZWw6ZGV2ZWwtaG91cmx5LTIwMTQwMzA2MTI6MDQxNDg1NWZk
YzRhNDBkYTA1MjIxZmM2MDYyY2NjYmMwYzMwZjE2OTpiaXNlY3QtbGludXg1CgoyMDE0LTAz
LTA2LTE1OjU3OjI5IDA0MTQ4NTVmZGM0YTQwZGEwNTIyMWZjNjA2MmNjY2JjMGMzMGYxNjkg
Y29tcGlsaW5nCjI4OCByZWFsICAxNTc1IHVzZXIgIDE0NyBzeXMgIDU5Ni44NSUgY3B1IAlp
Mzg2LXJhbmRjb25maWctYmExLTAzMDYxMzIyCgoyMDE0LTAzLTA2LTE2OjAzOjM3IGRldGVj
dGluZyBib290IHN0YXRlIDMuMTQuMC1yYzUuLi4JNAkxMAkyMCBTVUNDRVNTCgpiaXNlY3Q6
IGdvb2QgY29tbWl0IDA0MTQ4NTVmZGM0YTQwZGEwNTIyMWZjNjA2MmNjY2JjMGMzMGYxNjkK
Z2l0IGJpc2VjdCBzdGFydCBhYWZjZmNhMzZhN2EyNjQwOWFmMmVjMjI2NTkyN2VkOGFkNmVi
NGIyIDA0MTQ4NTVmZGM0YTQwZGEwNTIyMWZjNjA2MmNjY2JjMGMzMGYxNjkgLS0KL2Mva2Vy
bmVsLXRlc3RzL2xpbmVhci1iaXNlY3Q6IFsiLWIiLCAiYWFmY2ZjYTM2YTdhMjY0MDlhZjJl
YzIyNjU5MjdlZDhhZDZlYjRiMiIsICItZyIsICIwNDE0ODU1ZmRjNGE0MGRhMDUyMjFmYzYw
NjJjY2NiYzBjMzBmMTY5IiwgIi9jL2tlcm5lbC10ZXN0cy9iaXNlY3QtdGVzdC1ib290LWZh
aWx1cmUuc2giLCAiL2tlcm5lbC10ZXN0cy9saW51eDUvb2JqLWJpc2VjdCJdCkJpc2VjdGlu
ZzogMzg1NyByZXZpc2lvbnMgbGVmdCB0byB0ZXN0IGFmdGVyIHRoaXMgKHJvdWdobHkgMTIg
c3RlcHMpCltiZGE4OWM3NTY3MDQ0MDcxZTkzZDhiMWM0YzJmNmUzODNjMGZkMjQ5XSBNZXJn
ZSAnZHJtL2RybS1uZXh0JyBpbnRvIGRldmVsLWhvdXJseS0yMDE0MDMwNjEyCnJ1bm5pbmcg
L2Mva2VybmVsLXRlc3RzL2Jpc2VjdC10ZXN0LWJvb3QtZmFpbHVyZS5zaCAva2VybmVsLXRl
c3RzL2xpbnV4NS9vYmotYmlzZWN0CmxzIC1hIC9rZXJuZWwtdGVzdHMvcnVuLXF1ZXVlL2t2
bS9pMzg2LXJhbmRjb25maWctYmExLTAzMDYxMzIyL2xpbnV4LWRldmVsOmRldmVsLWhvdXJs
eS0yMDE0MDMwNjEyOmJkYTg5Yzc1NjcwNDQwNzFlOTNkOGIxYzRjMmY2ZTM4M2MwZmQyNDk6
YmlzZWN0LWxpbnV4NQoKMjAxNC0wMy0wNi0xNjowNjo0NiBiZGE4OWM3NTY3MDQ0MDcxZTkz
ZDhiMWM0YzJmNmUzODNjMGZkMjQ5IGNvbXBpbGluZwo0NDkgcmVhbCAgMTU5MCB1c2VyICAx
NDggc3lzICAzODYuOTUlIGNwdSAJaTM4Ni1yYW5kY29uZmlnLWJhMS0wMzA2MTMyMgoKMjAx
NC0wMy0wNi0xNjoxNTozOCBkZXRlY3RpbmcgYm9vdCBzdGF0ZSAzLjE0LjAtcmM1LTAyMzMw
LWdiZGE4OWM3Li4uLi4uLi4uCTkJMTkJMjAgU1VDQ0VTUwoKQmlzZWN0aW5nOiAxNTI3IHJl
dmlzaW9ucyBsZWZ0IHRvIHRlc3QgYWZ0ZXIgdGhpcyAocm91Z2hseSAxMSBzdGVwcykKWzhl
Yjc4YThlMGJjYTQ3NGQ0ODZhMDUwNWExZDM4NDg4MTE5ZTg2MDJdIE1lcmdlICdhdGg2a2wv
YXRoLW5leHQtdGVzdCcgaW50byBkZXZlbC1ob3VybHktMjAxNDAzMDYxMgpydW5uaW5nIC9j
L2tlcm5lbC10ZXN0cy9iaXNlY3QtdGVzdC1ib290LWZhaWx1cmUuc2ggL2tlcm5lbC10ZXN0
cy9saW51eDUvb2JqLWJpc2VjdApscyAtYSAva2VybmVsLXRlc3RzL3J1bi1xdWV1ZS9rdm0v
aTM4Ni1yYW5kY29uZmlnLWJhMS0wMzA2MTMyMi9saW51eC1kZXZlbDpkZXZlbC1ob3VybHkt
MjAxNDAzMDYxMjo4ZWI3OGE4ZTBiY2E0NzRkNDg2YTA1MDVhMWQzODQ4ODExOWU4NjAyOmJp
c2VjdC1saW51eDUKCjIwMTQtMDMtMDYtMTY6MjE6NTIgOGViNzhhOGUwYmNhNDc0ZDQ4NmEw
NTA1YTFkMzg0ODgxMTllODYwMiBjb21waWxpbmcKMTM0IHJlYWwgIDEyODcgdXNlciAgMTE5
IHN5cyAgMTA0Ny45NiUgY3B1IAlpMzg2LXJhbmRjb25maWctYmExLTAzMDYxMzIyCgoyMDE0
LTAzLTA2LTE2OjI1OjU4IGRldGVjdGluZyBib290IHN0YXRlIDMuMTQuMC1yYzUtMDMzNjAt
ZzhlYjc4YTguLi4uLi4JMTkJMjAgU1VDQ0VTUwoKQmlzZWN0aW5nOiA0OTcgcmV2aXNpb25z
IGxlZnQgdG8gdGVzdCBhZnRlciB0aGlzIChyb3VnaGx5IDkgc3RlcHMpCltlNDcyOWRmODY4
MjBhNzEzMmU0MWQ0MDE1MjVhY2YyNGU0YTI1MDQwXSBNZXJnZSAndGlwL3g4Ni9yZWJvb3Qn
IGludG8gZGV2ZWwtaG91cmx5LTIwMTQwMzA2MTIKcnVubmluZyAvYy9rZXJuZWwtdGVzdHMv
YmlzZWN0LXRlc3QtYm9vdC1mYWlsdXJlLnNoIC9rZXJuZWwtdGVzdHMvbGludXg1L29iai1i
aXNlY3QKbHMgLWEgL2tlcm5lbC10ZXN0cy9ydW4tcXVldWUva3ZtL2kzODYtcmFuZGNvbmZp
Zy1iYTEtMDMwNjEzMjIvbGludXgtZGV2ZWw6ZGV2ZWwtaG91cmx5LTIwMTQwMzA2MTI6ZTQ3
MjlkZjg2ODIwYTcxMzJlNDFkNDAxNTI1YWNmMjRlNGEyNTA0MDpiaXNlY3QtbGludXg1Cgoy
MDE0LTAzLTA2LTE2OjMwOjA3IGU0NzI5ZGY4NjgyMGE3MTMyZTQxZDQwMTUyNWFjZjI0ZTRh
MjUwNDAgY29tcGlsaW5nCjE1NCByZWFsICAxNjEzIHVzZXIgIDE0OCBzeXMgIDExNDAuMTQl
IGNwdSAJaTM4Ni1yYW5kY29uZmlnLWJhMS0wMzA2MTMyMgoKMjAxNC0wMy0wNi0xNjozNTo1
MyBkZXRlY3RpbmcgYm9vdCBzdGF0ZSAzLjE0LjAtcmM1LTAzNzk1LWdlNDcyOWRmLi4uLi4u
Li4gVEVTVCBGQUlMVVJFClsgICAgNC4yOTM5MTZdIHNwaW5fbG9jay10b3J0dXJlOiBDcmVh
dGluZyBsb2NrX3RvcnR1cmVfc3RhdHMgdGFzawpbICAgIDQuMjk4NTk3XSBzcGluX2xvY2st
dG9ydHVyZTogbG9ja190b3J0dXJlX3dyaXRlciB0YXNrIHN0YXJ0ZWQKWyAgIDExLjExMDM3
OF0gcmFuZG9tOiBub25ibG9ja2luZyBwb29sIGlzIGluaXRpYWxpemVkClsgICA0OC4wMjgz
ODZdIEJVRzogc29mdCBsb2NrdXAgLSBDUFUjMCBzdHVjayBmb3IgMjJzISBbbG9ja190b3J0
dXJlX3dyOjI3XQpbICAgNDguMDI5MzcxXSBNb2R1bGVzIGxpbmtlZCBpbjoKWyAgIDQ4LjAy
OTM3MV0gQ1BVOiAwIFBJRDogMjcgQ29tbTogbG9ja190b3J0dXJlX3dyIE5vdCB0YWludGVk
IDMuMTQuMC1yYzUtMDM3OTUtZ2U0NzI5ZGYgIzQxClsgICA0OC4wMjkzNzFdIHRhc2s6IDg4
YTJmMDAwIHRpOiA4ZGMwMjAwMCB0YXNrLnRpOiA4ZGZkODAwMApbICAgNDguMDI5MzcxXSBF
SVA6IDAwNjA6Wzw4MTA5YjEwZj5dIEVGTEFHUzogMDAwMDAyMDIgQ1BVOiAwClsgICA0OC4w
MjkzNzFdIEVJUCBpcyBhdCBzdHV0dGVyX3dhaXQrMHgyNi8weDVhClsgICA0OC4wMjkzNzFd
IEVBWDogMDAwMDAwMDIgRUJYOiA4MTVhOWFjZSBFQ1g6IDAwMDAwMDAwIEVEWDogMDAwMDAw
MDAKWyAgIDQ4LjAyOTM3MV0gRVNJOiA4ZDQ4ZDFmMCBFREk6IDAwMDAwMDAwIEVCUDogOGRm
ZDllZmMgRVNQOiA4ZGZkOWVmOApbICAgNDguMDI5MzcxXSAgRFM6IDAwN2IgRVM6IDAwN2Ig
RlM6IDAwMDAgR1M6IDAwZTAgU1M6IDAwNjgKWyAgIDQ4LjAyOTM3MV0gQ1IwOiA4MDA1MDAz
YiBDUjI6IDhkZGM0MDAwIENSMzogMDE4NzAwMDAgQ1I0OiAwMDAwMDZmMApbICAgNDguMDI5
MzcxXSBTdGFjazoKWyAgIDQ4LjAyOTM3MV0gIDhkNDgzZjAwIDhkZmQ5ZjIwIDgxMDYxMDBh
IDgxNWE5ODY2IDgxNWFiYzVmIDgxNWE5ODQ1IDAwMDAwMDAwIDhkNDgzZmUwClsgICA0OC4w
MjkzNzFdICA4ZDQ4ZDFmMCA4MTA2MGYxYSA4ZGZkOWZhYyA4MTA0YzE2MiAwMDAwMDAwMCAw
MDAwMDAwYyA4ZDQ4ZDFmMCAwMDAwMDAwMApbICAgNDguMDI5MzcxXSAgMDAwMDAwMDEgZGVh
ZDRlYWQgZmZmZmZmZmYgZmZmZmZmZmYgODE4N2Q4NTggMDAwMDAwMDAgMDAwMDAwMDAgODE1
YTYwMmQKWyAgIDQ4LjAyOTM3MV0gQ2FsbCBUcmFjZToKWyAgIDQ4LjAyOTM3MV0gIFs8ODEw
NjEwMGE+XSBsb2NrX3RvcnR1cmVfd3JpdGVyKzB4ZjAvMHgxM2MKWyAgIDQ4LjAyOTM3MV0g
IFs8ODEwNjBmMWE+XSA/IHRvcnR1cmVfbG9ja19idXN0ZWRfd3JpdGVfdW5sb2NrKzB4NS8w
eDUKWyAgIDQ4LjAyOTM3MV0gIFs8ODEwNGMxNjI+XSBrdGhyZWFkKzB4YjcvMHhiYwpbICAg
NDguMDI5MzcxXSAgWzw4MTNmMTZmYj5dIHJldF9mcm9tX2tlcm5lbF90aHJlYWQrMHgxYi8w
eDMwClsgICA0OC4wMjkzNzFdICBbPDgxMDRjMGFiPl0gPyBrdGhyZWFkX3N0b3ArMHhhYS8w
eGFhClsgICA0OC4wMjkzNzFdIENvZGU6IDViIDU4IDViIDVkIGMzIDU1IDg5IGU1IDUzIDg5
IGMzIGViIDM2IDgzIDNkIDBjIGQ2IGNkIDgxIDAwIDc0IDE3IGExIDBjIGQ2IGNkIDgxIDgz
IGY4IDAxIDc1IDAyIGViIDE1IGExIDBjIGQ2IGNkIDgxIDg1IGMwIDc0IDExIDxlYj4gZjUg
YjggZTggMDMgMDAgMDAgZTggYjYgZTcgZjkgZmYgZTggNTYgMGYgMzUgMDAgODkgZDggZTgg
OTAKL2tlcm5lbC9pMzg2LXJhbmRjb25maWctYmExLTAzMDYxMzIyL2U0NzI5ZGY4NjgyMGE3
MTMyZTQxZDQwMTUyNWFjZjI0ZTRhMjUwNDAvZG1lc2ctcXVhbnRhbC1zbmItMjI6MjAxNDAz
MDYxNjM5MjE6aTM4Ni1yYW5kY29uZmlnLWJhMS0wMzA2MTMyMjo6Ci9rZXJuZWwvaTM4Ni1y
YW5kY29uZmlnLWJhMS0wMzA2MTMyMi9lNDcyOWRmODY4MjBhNzEzMmU0MWQ0MDE1MjVhY2Yy
NGU0YTI1MDQwL2RtZXNnLXF1YW50YWwtc3RvYWtsZXktNDoyMDE0MDMwNjE2MzkyMjppMzg2
LXJhbmRjb25maWctYmExLTAzMDYxMzIyOjMuMTQuMC1yYzUtMDM3OTUtZ2U0NzI5ZGY6NDEK
L2tlcm5lbC9pMzg2LXJhbmRjb25maWctYmExLTAzMDYxMzIyL2U0NzI5ZGY4NjgyMGE3MTMy
ZTQxZDQwMTUyNWFjZjI0ZTRhMjUwNDAvZG1lc2ctcXVhbnRhbC1zdG9ha2xleS01OjIwMTQw
MzA2MTYzOTE4OmkzODYtcmFuZGNvbmZpZy1iYTEtMDMwNjEzMjI6My4xNC4wLXJjNS0wMzc5
NS1nZTQ3MjlkZjo0MQova2VybmVsL2kzODYtcmFuZGNvbmZpZy1iYTEtMDMwNjEzMjIvZTQ3
MjlkZjg2ODIwYTcxMzJlNDFkNDAxNTI1YWNmMjRlNGEyNTA0MC9kbWVzZy15b2N0by1zbmIt
MTg6MjAxNDAzMDYxNjM5MjA6aTM4Ni1yYW5kY29uZmlnLWJhMS0wMzA2MTMyMjo6Ci9rZXJu
ZWwvaTM4Ni1yYW5kY29uZmlnLWJhMS0wMzA2MTMyMi9lNDcyOWRmODY4MjBhNzEzMmU0MWQ0
MDE1MjVhY2YyNGU0YTI1MDQwL2RtZXNnLXlvY3RvLXNuYi00ODoyMDE0MDMwNjE2MzkyMTpp
Mzg2LXJhbmRjb25maWctYmExLTAzMDYxMzIyOjoKL2tlcm5lbC9pMzg2LXJhbmRjb25maWct
YmExLTAzMDYxMzIyL2U0NzI5ZGY4NjgyMGE3MTMyZTQxZDQwMTUyNWFjZjI0ZTRhMjUwNDAv
ZG1lc2ctcXVhbnRhbC1zbmItMzU6MjAxNDAzMDYxNjM5MjQ6aTM4Ni1yYW5kY29uZmlnLWJh
MS0wMzA2MTMyMjo6Ci9rZXJuZWwvaTM4Ni1yYW5kY29uZmlnLWJhMS0wMzA2MTMyMi9lNDcy
OWRmODY4MjBhNzEzMmU0MWQ0MDE1MjVhY2YyNGU0YTI1MDQwL2RtZXNnLXlvY3RvLXNuYi01
OjIwMTQwMzA2MTYzOTI5OmkzODYtcmFuZGNvbmZpZy1iYTEtMDMwNjEzMjI6Ogova2VybmVs
L2kzODYtcmFuZGNvbmZpZy1iYTEtMDMwNjEzMjIvZTQ3MjlkZjg2ODIwYTcxMzJlNDFkNDAx
NTI1YWNmMjRlNGEyNTA0MC9kbWVzZy15b2N0by14Z3dvLTY6MjAxNDAzMDYxNjM5MzE6aTM4
Ni1yYW5kY29uZmlnLWJhMS0wMzA2MTMyMjozLjE0LjAtcmM1LTAzNzk1LWdlNDcyOWRmOjQx
Ci9rZXJuZWwvaTM4Ni1yYW5kY29uZmlnLWJhMS0wMzA2MTMyMi9lNDcyOWRmODY4MjBhNzEz
MmU0MWQ0MDE1MjVhY2YyNGU0YTI1MDQwL2RtZXNnLXF1YW50YWwteGJtLTM6MjAxNDAzMDYx
NjM5Mzc6aTM4Ni1yYW5kY29uZmlnLWJhMS0wMzA2MTMyMjozLjE0LjAtcmM1LTAzNzk1LWdl
NDcyOWRmOjQxCi9rZXJuZWwvaTM4Ni1yYW5kY29uZmlnLWJhMS0wMzA2MTMyMi9lNDcyOWRm
ODY4MjBhNzEzMmU0MWQ0MDE1MjVhY2YyNGU0YTI1MDQwL2RtZXNnLXF1YW50YWwteGd3by0y
OjIwMTQwMzA2MTYzOTM1OmkzODYtcmFuZGNvbmZpZy1iYTEtMDMwNjEzMjI6My4xNC4wLXJj
NS0wMzc5NS1nZTQ3MjlkZjo0MQova2VybmVsL2kzODYtcmFuZGNvbmZpZy1iYTEtMDMwNjEz
MjIvZTQ3MjlkZjg2ODIwYTcxMzJlNDFkNDAxNTI1YWNmMjRlNGEyNTA0MC9kbWVzZy1xdWFu
dGFsLXhnd28tNToyMDE0MDMwNjE2Mzk0MjppMzg2LXJhbmRjb25maWctYmExLTAzMDYxMzIy
OjMuMTQuMC1yYzUtMDM3OTUtZ2U0NzI5ZGY6NDEKL2tlcm5lbC9pMzg2LXJhbmRjb25maWct
YmExLTAzMDYxMzIyL2U0NzI5ZGY4NjgyMGE3MTMyZTQxZDQwMTUyNWFjZjI0ZTRhMjUwNDAv
ZG1lc2cteW9jdG8tc25iLTExOjIwMTQwMzA2MTYzOTM4OmkzODYtcmFuZGNvbmZpZy1iYTEt
MDMwNjEzMjI6Ogova2VybmVsL2kzODYtcmFuZGNvbmZpZy1iYTEtMDMwNjEzMjIvZTQ3Mjlk
Zjg2ODIwYTcxMzJlNDFkNDAxNTI1YWNmMjRlNGEyNTA0MC9kbWVzZy15b2N0by1zdG9ha2xl
eS02OjIwMTQwMzA2MTYzOTM0OmkzODYtcmFuZGNvbmZpZy1iYTEtMDMwNjEzMjI6My4xNC4w
LXJjNS0wMzc5NS1nZTQ3MjlkZjo0MQova2VybmVsL2kzODYtcmFuZGNvbmZpZy1iYTEtMDMw
NjEzMjIvZTQ3MjlkZjg2ODIwYTcxMzJlNDFkNDAxNTI1YWNmMjRlNGEyNTA0MC9kbWVzZy1x
dWFudGFsLXNuYi00MzoyMDE0MDMwNjE2Mzk0NjppMzg2LXJhbmRjb25maWctYmExLTAzMDYx
MzIyOjoKL2tlcm5lbC9pMzg2LXJhbmRjb25maWctYmExLTAzMDYxMzIyL2U0NzI5ZGY4Njgy
MGE3MTMyZTQxZDQwMTUyNWFjZjI0ZTRhMjUwNDAvZG1lc2ctcXVhbnRhbC14Z3dvLTE6MjAx
NDAzMDYxNjM5NTE6aTM4Ni1yYW5kY29uZmlnLWJhMS0wMzA2MTMyMjozLjE0LjAtcmM1LTAz
Nzk1LWdlNDcyOWRmOjQxCi9rZXJuZWwvaTM4Ni1yYW5kY29uZmlnLWJhMS0wMzA2MTMyMi9l
NDcyOWRmODY4MjBhNzEzMmU0MWQ0MDE1MjVhY2YyNGU0YTI1MDQwL2RtZXNnLXF1YW50YWwt
eGd3by02OjIwMTQwMzA2MTYzOTQ5OmkzODYtcmFuZGNvbmZpZy1iYTEtMDMwNjEzMjI6My4x
NC4wLXJjNS0wMzc5NS1nZTQ3MjlkZjo0MQova2VybmVsL2kzODYtcmFuZGNvbmZpZy1iYTEt
MDMwNjEzMjIvZTQ3MjlkZjg2ODIwYTcxMzJlNDFkNDAxNTI1YWNmMjRlNGEyNTA0MC9kbWVz
Zy15b2N0by1iZW5zLTY6MjAxNDAzMDYxNjM5NDc6aTM4Ni1yYW5kY29uZmlnLWJhMS0wMzA2
MTMyMjozLjE0LjAtcmM1LTAzNzk1LWdlNDcyOWRmOjQxCjA6MTc6MTMgYWxsX2dvb2Q6YmFk
OmFsbF9iYWQgYm9vdHMKCkJpc2VjdGluZzogNDM1IHJldmlzaW9ucyBsZWZ0IHRvIHRlc3Qg
YWZ0ZXIgdGhpcyAocm91Z2hseSA5IHN0ZXBzKQpbMDdjNDUzNGUwZDkyZTk2MDAyNDNlYzRm
OWUyN2JkMzM3YzA2MTdmZl0gTWVyZ2UgJ2lwc2VjLW5leHQvdnRpNicgaW50byBkZXZlbC1o
b3VybHktMjAxNDAzMDYxMgpydW5uaW5nIC9jL2tlcm5lbC10ZXN0cy9iaXNlY3QtdGVzdC1i
b290LWZhaWx1cmUuc2ggL2tlcm5lbC10ZXN0cy9saW51eDUvb2JqLWJpc2VjdApscyAtYSAv
a2VybmVsLXRlc3RzL3J1bi1xdWV1ZS9rdm0vaTM4Ni1yYW5kY29uZmlnLWJhMS0wMzA2MTMy
Mi9saW51eC1kZXZlbDpkZXZlbC1ob3VybHktMjAxNDAzMDYxMjowN2M0NTM0ZTBkOTJlOTYw
MDI0M2VjNGY5ZTI3YmQzMzdjMDYxN2ZmOmJpc2VjdC1saW51eDUKCjIwMTQtMDMtMDYtMTY6
NDA6MTQgMDdjNDUzNGUwZDkyZTk2MDAyNDNlYzRmOWUyN2JkMzM3YzA2MTdmZiBjb21waWxp
bmcKNDA3IHJlYWwgIDE2MTAgdXNlciAgMTUwIHN5cyAgNDMyLjMyJSBjcHUgCWkzODYtcmFu
ZGNvbmZpZy1iYTEtMDMwNjEzMjIKCjIwMTQtMDMtMDYtMTY6NDk6MDQgZGV0ZWN0aW5nIGJv
b3Qgc3RhdGUgMy4xNC4wLXJjNS0wMzUzOS1nMDdjNDUzNC4uCTUJMTMJMTcJMjAgU1VDQ0VT
UwoKQmlzZWN0aW5nOiAyNTYgcmV2aXNpb25zIGxlZnQgdG8gdGVzdCBhZnRlciB0aGlzIChy
b3VnaGx5IDkgc3RlcHMpClthY2UzZjU0NDYyYjAxZDY3NDM4OWViMDYyN2M5MzNjYjYyMzBh
NTdiXSBNZXJnZSAncmN1L3JjdS9kZXYnIGludG8gZGV2ZWwtaG91cmx5LTIwMTQwMzA2MTIK
cnVubmluZyAvYy9rZXJuZWwtdGVzdHMvYmlzZWN0LXRlc3QtYm9vdC1mYWlsdXJlLnNoIC9r
ZXJuZWwtdGVzdHMvbGludXg1L29iai1iaXNlY3QKbHMgLWEgL2tlcm5lbC10ZXN0cy9ydW4t
cXVldWUva3ZtL2kzODYtcmFuZGNvbmZpZy1iYTEtMDMwNjEzMjIvbGludXgtZGV2ZWw6ZGV2
ZWwtaG91cmx5LTIwMTQwMzA2MTI6YWNlM2Y1NDQ2MmIwMWQ2NzQzODllYjA2MjdjOTMzY2I2
MjMwYTU3YjpiaXNlY3QtbGludXg1CgoyMDE0LTAzLTA2LTE2OjUyOjIyIGFjZTNmNTQ0NjJi
MDFkNjc0Mzg5ZWIwNjI3YzkzM2NiNjIzMGE1N2IgY29tcGlsaW5nCjgxNiByZWFsICAxNjE0
IHVzZXIgIDE1MCBzeXMgIDIxNi4xNiUgY3B1IAlpMzg2LXJhbmRjb25maWctYmExLTAzMDYx
MzIyCgoyMDE0LTAzLTA2LTE3OjA4OjMyIGRldGVjdGluZyBib290IHN0YXRlIDMuMTQuMC1y
YzUtMDM2NzgtZ2FjZTNmNTQuLi4uLiBURVNUIEZBSUxVUkUKWyAgICAyLjU4NTQ5OV0gYXVn
bWVudGVkIHJidHJlZSB0ZXN0aW5nIC0+IDEzNDA4IGN5Y2xlcwpbICAgIDMuMTM1Mzg0XSB0
c2M6IFJlZmluZWQgVFNDIGNsb2Nrc291cmNlIGNhbGlicmF0aW9uOiAyODkyLjk0OCBNSHoK
WyAgICA4LjI1NzExOV0gcmFuZG9tOiBub25ibG9ja2luZyBwb29sIGlzIGluaXRpYWxpemVk
ClsgICA0MC4wMTYwNjZdIEJVRzogc29mdCBsb2NrdXAgLSBDUFUjMCBzdHVjayBmb3IgMjNz
ISBbbG9ja190b3J0dXJlX3dyOjI2XQpbICAgNDAuMDE2MDY2XSBNb2R1bGVzIGxpbmtlZCBp
bjoKWyAgIDQwLjAxNjA2Nl0gQ1BVOiAwIFBJRDogMjYgQ29tbTogbG9ja190b3J0dXJlX3dy
IE5vdCB0YWludGVkIDMuMTQuMC1yYzUtMDM2NzgtZ2FjZTNmNTQgIzQzClsgICA0MC4wMTYw
NjZdIHRhc2s6IDg4YTJlMDAwIHRpOiA4ZGMwMjAwMCB0YXNrLnRpOiA4ZGZkNjAwMApbICAg
NDAuMDE2MDY2XSBFSVA6IDAwNjA6Wzw4MTA5YjBmZj5dIEVGTEFHUzogMDAwMDAyMDIgQ1BV
OiAwClsgICA0MC4wMTYwNjZdIEVJUCBpcyBhdCBzdHV0dGVyX3dhaXQrMHgyNi8weDVhClsg
ICA0MC4wMTYwNjZdIEVBWDogMDAwMDAwMDIgRUJYOiA4MTVhOWI1MiBFQ1g6IDAwMDAwMDAw
IEVEWDogMDAwMDAwMDAKWyAgIDQwLjAxNjA2Nl0gRVNJOiA4YjQ5MjE5OCBFREk6IDAwMDAw
MDAwIEVCUDogOGRmZDdlZmMgRVNQOiA4ZGZkN2VmOApbICAgNDAuMDE2MDY2XSAgRFM6IDAw
N2IgRVM6IDAwN2IgRlM6IDAwMDAgR1M6IDAwZTAgU1M6IDAwNjgKWyAgIDQwLjAxNjA2Nl0g
Q1IwOiA4MDA1MDAzYiBDUjI6IDAwMDAwMDAwIENSMzogMDE4NzAwMDAgQ1I0OiAwMDAwMDZm
MApbICAgNDAuMDE2MDY2XSBTdGFjazoKWyAgIDQwLjAxNjA2Nl0gIDhiOWM1MTAwIDhkZmQ3
ZjIwIDgxMDYwZmZhIDgxNWE5OGVhIDgxNWFiY2UzIDgxNWE5OGM5IDAwMDAwMDAwIDhiOWM1
MWIwClsgICA0MC4wMTYwNjZdICA4YjQ5MjE5OCA4MTA2MGYwYSA4ZGZkN2ZhYyA4MTA0YzE1
MiAwMDAwMDAwMCAwMDAwMDAwYyA4YjQ5MjE5OCAwMDAwMDAwMApbICAgNDAuMDE2MDY2XSAg
MDAwMDAwMDEgZGVhZDRlYWQgZmZmZmZmZmYgZmZmZmZmZmYgODE4N2Q4NTggMDAwMDAwMDAg
MDAwMDAwMDAgODE1YTYwYjEKWyAgIDQwLjAxNjA2Nl0gQ2FsbCBUcmFjZToKWyAgIDQwLjAx
NjA2Nl0gIFs8ODEwNjBmZmE+XSBsb2NrX3RvcnR1cmVfd3JpdGVyKzB4ZjAvMHgxM2MKWyAg
IDQwLjAxNjA2Nl0gIFs8ODEwNjBmMGE+XSA/IHRvcnR1cmVfbG9ja19idXN0ZWRfd3JpdGVf
dW5sb2NrKzB4NS8weDUKWyAgIDQwLjAxNjA2Nl0gIFs8ODEwNGMxNTI+XSBrdGhyZWFkKzB4
YjcvMHhiYwpbICAgNDAuMDE2MDY2XSAgWzw4MTNmMTc5Yj5dIHJldF9mcm9tX2tlcm5lbF90
aHJlYWQrMHgxYi8weDMwClsgICA0MC4wMTYwNjZdICBbPDgxMDRjMDliPl0gPyBrdGhyZWFk
X3N0b3ArMHhhYS8weGFhClsgICA0MC4wMTYwNjZdIENvZGU6IDViIDU4IDViIDVkIGMzIDU1
IDg5IGU1IDUzIDg5IGMzIGViIDM2IDgzIDNkIDBjIGQ2IGNkIDgxIDAwIDc0IDE3IGExIDBj
IGQ2IGNkIDgxIDgzIGY4IDAxIDc1IDAyIGViIDE1IGExIDBjIGQ2IGNkIDgxIDg1IGMwIDc0
IDExIDxlYj4gZjUgYjggZTggMDMgMDAgMDAgZTggYjYgZTcgZjkgZmYgZTggZjYgMGYgMzUg
MDAgODkgZDggZTggOTAKL2tlcm5lbC9pMzg2LXJhbmRjb25maWctYmExLTAzMDYxMzIyL2Fj
ZTNmNTQ0NjJiMDFkNjc0Mzg5ZWIwNjI3YzkzM2NiNjIzMGE1N2IvZG1lc2ctcXVhbnRhbC1h
dGhlbnMtNDg6MjAxNDAzMDYxNzEwMjU6aTM4Ni1yYW5kY29uZmlnLWJhMS0wMzA2MTMyMjoz
LjE0LjAtcmM1LTAzNjc4LWdhY2UzZjU0OjQzCi9rZXJuZWwvaTM4Ni1yYW5kY29uZmlnLWJh
MS0wMzA2MTMyMi9hY2UzZjU0NDYyYjAxZDY3NDM4OWViMDYyN2M5MzNjYjYyMzBhNTdiL2Rt
ZXNnLXlvY3RvLXhnd28tNzoyMDE0MDMwNjE3MTAyNjppMzg2LXJhbmRjb25maWctYmExLTAz
MDYxMzIyOjMuMTQuMC1yYzUtMDM2NzgtZ2FjZTNmNTQ6NDMKL2tlcm5lbC9pMzg2LXJhbmRj
b25maWctYmExLTAzMDYxMzIyL2FjZTNmNTQ0NjJiMDFkNjc0Mzg5ZWIwNjI3YzkzM2NiNjIz
MGE1N2IvZG1lc2ctcXVhbnRhbC1qYWtldG93bi0xMzoyMDE0MDMwNjE3MTAzNDppMzg2LXJh
bmRjb25maWctYmExLTAzMDYxMzIyOjoKL2tlcm5lbC9pMzg2LXJhbmRjb25maWctYmExLTAz
MDYxMzIyL2FjZTNmNTQ0NjJiMDFkNjc0Mzg5ZWIwNjI3YzkzM2NiNjIzMGE1N2IvZG1lc2ct
cXVhbnRhbC14aWFuLTM1OjIwMTQwMzA2MTcxMDM5OmkzODYtcmFuZGNvbmZpZy1iYTEtMDMw
NjEzMjI6My4xNC4wLXJjNS0wMzY3OC1nYWNlM2Y1NDo0Mwova2VybmVsL2kzODYtcmFuZGNv
bmZpZy1iYTEtMDMwNjEzMjIvYWNlM2Y1NDQ2MmIwMWQ2NzQzODllYjA2MjdjOTMzY2I2MjMw
YTU3Yi9kbWVzZy1xdWFudGFsLWxrcC1zdDAxLTExOjIwMTQwMzA2MTcxMDQ0OmkzODYtcmFu
ZGNvbmZpZy1iYTEtMDMwNjEzMjI6My4xNC4wLXJjNS0wMzY3OC1nYWNlM2Y1NDo0Mwova2Vy
bmVsL2kzODYtcmFuZGNvbmZpZy1iYTEtMDMwNjEzMjIvYWNlM2Y1NDQ2MmIwMWQ2NzQzODll
YjA2MjdjOTMzY2I2MjMwYTU3Yi9kbWVzZy1xdWFudGFsLWJlbnMtMToyMDE0MDMwNjE3MTEw
MDppMzg2LXJhbmRjb25maWctYmExLTAzMDYxMzIyOjMuMTQuMC1yYzUtMDM2NzgtZ2FjZTNm
NTQ6NDMKMDo2OjUgYWxsX2dvb2Q6YmFkOmFsbF9iYWQgYm9vdHMKCkJpc2VjdGluZzogMTM5
IHJldmlzaW9ucyBsZWZ0IHRvIHRlc3QgYWZ0ZXIgdGhpcyAocm91Z2hseSA4IHN0ZXBzKQpb
YzIzNmUzYzZlMjg2MmM3ZDJkNWYyZjI2ZWFhNWZmODZiODk2ZDFhMF0gTWVyZ2UgJ3RpcC94
ODYvZWZpJyBpbnRvIGRldmVsLWhvdXJseS0yMDE0MDMwNjEyCnJ1bm5pbmcgL2Mva2VybmVs
LXRlc3RzL2Jpc2VjdC10ZXN0LWJvb3QtZmFpbHVyZS5zaCAva2VybmVsLXRlc3RzL2xpbnV4
NS9vYmotYmlzZWN0CmxzIC1hIC9rZXJuZWwtdGVzdHMvcnVuLXF1ZXVlL2t2bS9pMzg2LXJh
bmRjb25maWctYmExLTAzMDYxMzIyL2xpbnV4LWRldmVsOmRldmVsLWhvdXJseS0yMDE0MDMw
NjEyOmMyMzZlM2M2ZTI4NjJjN2QyZDVmMmYyNmVhYTVmZjg2Yjg5NmQxYTA6YmlzZWN0LWxp
bnV4NQoKMjAxNC0wMy0wNi0xNzoxMToxOCBjMjM2ZTNjNmUyODYyYzdkMmQ1ZjJmMjZlYWE1
ZmY4NmI4OTZkMWEwIGNvbXBpbGluZwo0MzMgcmVhbCAgMTU5MSB1c2VyICAxNDUgc3lzICA0
MDAuNTAlIGNwdSAJaTM4Ni1yYW5kY29uZmlnLWJhMS0wMzA2MTMyMgoKMjAxNC0wMy0wNi0x
NzoyMDoxMSBkZXRlY3RpbmcgYm9vdCBzdGF0ZSAzLjE0LjAtcmM1LTAzNTczLWdjMjM2ZTNj
Li4uLi4uLi4uCTEJMTYJMjAgU1VDQ0VTUwoKbGluZWFyLWJpc2VjdDogYmFkIGJyYW5jaCBt
YXkgYmUgcmN1L3JjdS9kZXYKbGluZWFyLWJpc2VjdDogaGFuZGxlIG92ZXIgdG8gZ2l0IGJp
c2VjdApsaW5lYXItYmlzZWN0OiBnaXQgYmlzZWN0IHN0YXJ0IGFjZTNmNTQ0NjJiMDFkNjc0
Mzg5ZWIwNjI3YzkzM2NiNjIzMGE1N2IgYzIzNmUzYzZlMjg2MmM3ZDJkNWYyZjI2ZWFhNWZm
ODZiODk2ZDFhMCAtLQpCaXNlY3Rpbmc6IDUyIHJldmlzaW9ucyBsZWZ0IHRvIHRlc3QgYWZ0
ZXIgdGhpcyAocm91Z2hseSA2IHN0ZXBzKQpbYjQ2ZjM1OGFlNWUzNTU4YTkwNzJmMDM1NDEy
OGQ1NzQ5YTU4NGQwMV0gcmN1dG9ydHVyZTogUGxhY2Uga3ZtLXRlc3QtMS1ydW4uc2ggb3V0
cHV0IGludG8gcmVzIGRpcmVjdG9yeQpsaW5lYXItYmlzZWN0OiBnaXQgYmlzZWN0IHJ1biAv
Yy9rZXJuZWwtdGVzdHMvYmlzZWN0LXRlc3QtYm9vdC1mYWlsdXJlLnNoIC9rZXJuZWwtdGVz
dHMvbGludXg1L29iai1iaXNlY3QKcnVubmluZyAvYy9rZXJuZWwtdGVzdHMvYmlzZWN0LXRl
c3QtYm9vdC1mYWlsdXJlLnNoIC9rZXJuZWwtdGVzdHMvbGludXg1L29iai1iaXNlY3QKbHMg
LWEgL2tlcm5lbC10ZXN0cy9ydW4tcXVldWUva3ZtL2kzODYtcmFuZGNvbmZpZy1iYTEtMDMw
NjEzMjIvbGludXgtZGV2ZWw6ZGV2ZWwtaG91cmx5LTIwMTQwMzA2MTI6YjQ2ZjM1OGFlNWUz
NTU4YTkwNzJmMDM1NDEyOGQ1NzQ5YTU4NGQwMTpiaXNlY3QtbGludXg1CgoyMDE0LTAzLTA2
LTE3OjI2OjI5IGI0NmYzNThhZTVlMzU1OGE5MDcyZjAzNTQxMjhkNTc0OWE1ODRkMDEgY29t
cGlsaW5nCjI4OCByZWFsICAxNjA1IHVzZXIgIDE0OSBzeXMgIDYwNy41NCUgY3B1IAlpMzg2
LXJhbmRjb25maWctYmExLTAzMDYxMzIyCgoyMDE0LTAzLTA2LTE3OjMzOjUyIGRldGVjdGlu
ZyBib290IHN0YXRlIDMuMTQuMC1yYzMtMDAwNTItZ2I0NmYzNTguLi4JMTUJMjAgU1VDQ0VT
UwoKQmlzZWN0aW5nOiAyNiByZXZpc2lvbnMgbGVmdCB0byB0ZXN0IGFmdGVyIHRoaXMgKHJv
dWdobHkgNSBzdGVwcykKW2Y1NjA0ZjY3ZmU4Y2JkNmYyMDg4YjIwYjk0NjNmNzIxYWE2MTNk
NGJdIE1lcmdlIGJyYW5jaCAndG9ydHVyZS4yMDE0LjAyLjIzYScgaW50byBIRUFECnJ1bm5p
bmcgL2Mva2VybmVsLXRlc3RzL2Jpc2VjdC10ZXN0LWJvb3QtZmFpbHVyZS5zaCAva2VybmVs
LXRlc3RzL2xpbnV4NS9vYmotYmlzZWN0CmxzIC1hIC9rZXJuZWwtdGVzdHMvcnVuLXF1ZXVl
L2t2bS9pMzg2LXJhbmRjb25maWctYmExLTAzMDYxMzIyL2xpbnV4LWRldmVsOmRldmVsLWhv
dXJseS0yMDE0MDMwNjEyOmY1NjA0ZjY3ZmU4Y2JkNmYyMDg4YjIwYjk0NjNmNzIxYWE2MTNk
NGI6YmlzZWN0LWxpbnV4NQoKMjAxNC0wMy0wNi0xNzozNjoyNiBmNTYwNGY2N2ZlOGNiZDZm
MjA4OGIyMGI5NDYzZjcyMWFhNjEzZDRiIGNvbXBpbGluZwoyNTUgcmVhbCAgMTU2MyB1c2Vy
ICAxNDMgc3lzICA2NjcuODMlIGNwdSAJaTM4Ni1yYW5kY29uZmlnLWJhMS0wMzA2MTMyMgoK
MjAxNC0wMy0wNi0xNzo0MTo1NyBkZXRlY3RpbmcgYm9vdCBzdGF0ZSAzLjE0LjAtcmMzLTAw
MDc4LWdmNTYwNGY2Li4uCTExCTE2CTIwIFNVQ0NFU1MKCkJpc2VjdGluZzogMTMgcmV2aXNp
b25zIGxlZnQgdG8gdGVzdCBhZnRlciB0aGlzIChyb3VnaGx5IDQgc3RlcHMpCltkZDM1Yjgx
YzM0MWM2ODViYWZkMTViYzlhNmJmYTc5NTg0ZTA3YjA3XSB0b3J0dXJlOiBSZW5hbWUgUkNV
X0JVSUxET05MWSB0byBUT1JUVVJFX0JVSUxET05MWQpydW5uaW5nIC9jL2tlcm5lbC10ZXN0
cy9iaXNlY3QtdGVzdC1ib290LWZhaWx1cmUuc2ggL2tlcm5lbC10ZXN0cy9saW51eDUvb2Jq
LWJpc2VjdApscyAtYSAva2VybmVsLXRlc3RzL3J1bi1xdWV1ZS9rdm0vaTM4Ni1yYW5kY29u
ZmlnLWJhMS0wMzA2MTMyMi9saW51eC1kZXZlbDpkZXZlbC1ob3VybHktMjAxNDAzMDYxMjpk
ZDM1YjgxYzM0MWM2ODViYWZkMTViYzlhNmJmYTc5NTg0ZTA3YjA3OmJpc2VjdC1saW51eDUK
CjIwMTQtMDMtMDYtMTc6NDU6MDAgZGQzNWI4MWMzNDFjNjg1YmFmZDE1YmM5YTZiZmE3OTU4
NGUwN2IwNyBjb21waWxpbmcKMTA3IHJlYWwgIDE1ODQgdXNlciAgMTQ0IHN5cyAgMTYxMS43
MCUgY3B1IAlpMzg2LXJhbmRjb25maWctYmExLTAzMDYxMzIyCgoyMDE0LTAzLTA2LTE3OjQ4
OjA0IGRldGVjdGluZyBib290IHN0YXRlIDMuMTQuMC1yYzMtMDAwOTEtZ2RkMzViODEuLi4u
Li4JMjAgU1VDQ0VTUwoKQmlzZWN0aW5nOiA2IHJldmlzaW9ucyBsZWZ0IHRvIHRlc3QgYWZ0
ZXIgdGhpcyAocm91Z2hseSAzIHN0ZXBzKQpbODg2NGYwOTk2ZThiN2YwN2E1MzZhYTA3NTUz
YzQ0NjFjZDVmNDIxMV0gdG9ydHVyZTogTWFrZSAiLS1kcnlydW4gc2NyaXB0IiBvdXRwdXQg
c2VsZi1zdWZmaWNpZW50CnJ1bm5pbmcgL2Mva2VybmVsLXRlc3RzL2Jpc2VjdC10ZXN0LWJv
b3QtZmFpbHVyZS5zaCAva2VybmVsLXRlc3RzL2xpbnV4NS9vYmotYmlzZWN0CmxzIC1hIC9r
ZXJuZWwtdGVzdHMvcnVuLXF1ZXVlL2t2bS9pMzg2LXJhbmRjb25maWctYmExLTAzMDYxMzIy
L2xpbnV4LWRldmVsOmRldmVsLWhvdXJseS0yMDE0MDMwNjEyOjg4NjRmMDk5NmU4YjdmMDdh
NTM2YWEwNzU1M2M0NDYxY2Q1ZjQyMTE6YmlzZWN0LWxpbnV4NQoKMjAxNC0wMy0wNi0xNzo1
MTozOCA4ODY0ZjA5OTZlOGI3ZjA3YTUzNmFhMDc1NTNjNDQ2MWNkNWY0MjExIGNvbXBpbGlu
ZwozNyByZWFsICAxMDggdXNlciAgMTUgc3lzICAzMjcuMzUlIGNwdSAJaTM4Ni1yYW5kY29u
ZmlnLWJhMS0wMzA2MTMyMgoKMjAxNC0wMy0wNi0xNzo1Mzo1MCBkZXRlY3RpbmcgYm9vdCBz
dGF0ZSAzLjE0LjAtcmMzLTAwMDk4LWc4ODY0ZjA5Li4uLi4uLi4uLi4uLi4uLi4uLi4uLi4u
Li4uLgk2CTExCTEzCTE5Li4uLgkyMCBTVUNDRVNTCgpCaXNlY3Rpbmc6IDMgcmV2aXNpb25z
IGxlZnQgdG8gdGVzdCBhZnRlciB0aGlzIChyb3VnaGx5IDIgc3RlcHMpCltiMmQ3NzdhNmQ5
ZDY0OTI5Yjk3MDFmMTkwNWZkZWRhOGZjM2NiMTZkXSByY3V0b3J0dXJlOiBQcmludCBuZWdh
dGl2ZXMgZm9yIFNSQ1UgY291bnRlciB3cmFwYXJvdW5kCnJ1bm5pbmcgL2Mva2VybmVsLXRl
c3RzL2Jpc2VjdC10ZXN0LWJvb3QtZmFpbHVyZS5zaCAva2VybmVsLXRlc3RzL2xpbnV4NS9v
YmotYmlzZWN0CmxzIC1hIC9rZXJuZWwtdGVzdHMvcnVuLXF1ZXVlL2t2bS9pMzg2LXJhbmRj
b25maWctYmExLTAzMDYxMzIyL2xpbnV4LWRldmVsOmRldmVsLWhvdXJseS0yMDE0MDMwNjEy
OmIyZDc3N2E2ZDlkNjQ5MjliOTcwMWYxOTA1ZmRlZGE4ZmMzY2IxNmQ6YmlzZWN0LWxpbnV4
NQoKMjAxNC0wMy0wNi0xODoxMjoyMyBiMmQ3NzdhNmQ5ZDY0OTI5Yjk3MDFmMTkwNWZkZWRh
OGZjM2NiMTZkIGNvbXBpbGluZwoyMSByZWFsICAxMDUgdXNlciAgMTUgc3lzICA1NTkuMTIl
IGNwdSAJaTM4Ni1yYW5kY29uZmlnLWJhMS0wMzA2MTMyMgoKMjAxNC0wMy0wNi0xODoxMzow
MCBkZXRlY3RpbmcgYm9vdCBzdGF0ZSAzLjE0LjAtcmMzLTAwMTAxLWdiMmQ3NzdhLi4uLi4u
Li4uLi4uLi4uLi4uLi4uLi4uCTEJNS4uLi4uLi4uLi4uLi4JNgkxOQkyMCBTVUNDRVNTCgpC
aXNlY3Rpbmc6IDEgcmV2aXNpb24gbGVmdCB0byB0ZXN0IGFmdGVyIHRoaXMgKHJvdWdobHkg
MSBzdGVwKQpbNGM3OWQ3ZDg5OTAyYTJlOWM5NmIzZGI1MTE1YWY1MmIzY2Y5NGRhOV0gdG9y
dHVyZTogUmVwb3J0IGRpYWdub3N0aWNzIGZyb20gcWVtdQpydW5uaW5nIC9jL2tlcm5lbC10
ZXN0cy9iaXNlY3QtdGVzdC1ib290LWZhaWx1cmUuc2ggL2tlcm5lbC10ZXN0cy9saW51eDUv
b2JqLWJpc2VjdApscyAtYSAva2VybmVsLXRlc3RzL3J1bi1xdWV1ZS9rdm0vaTM4Ni1yYW5k
Y29uZmlnLWJhMS0wMzA2MTMyMi9saW51eC1kZXZlbDpkZXZlbC1ob3VybHktMjAxNDAzMDYx
Mjo0Yzc5ZDdkODk5MDJhMmU5Yzk2YjNkYjUxMTVhZjUyYjNjZjk0ZGE5OmJpc2VjdC1saW51
eDUKCjIwMTQtMDMtMDYtMTg6MzQ6MDYgNGM3OWQ3ZDg5OTAyYTJlOWM5NmIzZGI1MTE1YWY1
MmIzY2Y5NGRhOSBjb21waWxpbmcKNjcgcmVhbCAgMTA0IHVzZXIgIDE1IHN5cyAgMTc5LjQ2
JSBjcHUgCWkzODYtcmFuZGNvbmZpZy1iYTEtMDMwNjEzMjIKCjIwMTQtMDMtMDYtMTg6MzY6
NDkgZGV0ZWN0aW5nIGJvb3Qgc3RhdGUgMy4xNC4wLXJjMy0wMDEwMy1nNGM3OWQ3ZC4uLi4u
CTEJOAkxNQkyMCBTVUNDRVNTCgpCaXNlY3Rpbmc6IDAgcmV2aXNpb25zIGxlZnQgdG8gdGVz
dCBhZnRlciB0aGlzIChyb3VnaGx5IDAgc3RlcHMpClsxZjljMjY5NjhlMWE1MDFmM2E4Mzk2
MDNjOTYzM2YyMWFiY2E2NWIzXSB0b3J0dXJlOiBJbmNyZWFzZSBzdHV0dGVyLWVuZCBpbnRl
bnNpdHkKcnVubmluZyAvYy9rZXJuZWwtdGVzdHMvYmlzZWN0LXRlc3QtYm9vdC1mYWlsdXJl
LnNoIC9rZXJuZWwtdGVzdHMvbGludXg1L29iai1iaXNlY3QKbHMgLWEgL2tlcm5lbC10ZXN0
cy9ydW4tcXVldWUva3ZtL2kzODYtcmFuZGNvbmZpZy1iYTEtMDMwNjEzMjIvbGludXgtZGV2
ZWw6ZGV2ZWwtaG91cmx5LTIwMTQwMzA2MTI6MWY5YzI2OTY4ZTFhNTAxZjNhODM5NjAzYzk2
MzNmMjFhYmNhNjViMzpiaXNlY3QtbGludXg1CgoyMDE0LTAzLTA2LTE4OjQxOjIwIDFmOWMy
Njk2OGUxYTUwMWYzYTgzOTYwM2M5NjMzZjIxYWJjYTY1YjMgY29tcGlsaW5nCjE5IHJlYWwg
IDEwMiB1c2VyICAxNCBzeXMgIDU5OC40OSUgY3B1IAlpMzg2LXJhbmRjb25maWctYmExLTAz
MDYxMzIyCgoyMDE0LTAzLTA2LTE4OjQxOjUxIGRldGVjdGluZyBib290IHN0YXRlIDMuMTQu
MC1yYzMtMDAxMDQtZzFmOWMyNjkuLi4gVEVTVCBGQUlMVVJFClsgICAgMi4xMTU5ODJdIGZ1
dGV4IGhhc2ggdGFibGUgZW50cmllczogMjU2IChvcmRlcjogMSwgMTIyODggYnl0ZXMpClsg
ICAgMi4xMTc3NTZdIEluaXRpYWxpc2Ugc3lzdGVtIHRydXN0ZWQga2V5cmluZwpbICAgIDgu
NDMyMTQ5XSByYW5kb206IG5vbmJsb2NraW5nIHBvb2wgaXMgaW5pdGlhbGl6ZWQKWyAgIDQ4
LjAyMTA1OF0gQlVHOiBzb2Z0IGxvY2t1cCAtIENQVSMwIHN0dWNrIGZvciAyMnMhIFtsb2Nr
X3RvcnR1cmVfd3I6MjddClsgICA0OC4wMjEwNThdIE1vZHVsZXMgbGlua2VkIGluOgpbICAg
NDguMDIxMDU4XSBDUFU6IDAgUElEOiAyNyBDb21tOiBsb2NrX3RvcnR1cmVfd3IgTm90IHRh
aW50ZWQgMy4xNC4wLXJjMy0wMDEwNC1nMWY5YzI2OSAjNTEKWyAgIDQ4LjAyMTA1OF0gdGFz
azogODhhMmYwMDAgdGk6IDhkYzAyMDAwIHRhc2sudGk6IDhkZmQ4MDAwClsgICA0OC4wMjEw
NThdIEVJUDogMDA2MDpbPDgxMDlhMzFiPl0gRUZMQUdTOiAwMDAwMDIwMiBDUFU6IDAKWyAg
IDQ4LjAyMTA1OF0gRUlQIGlzIGF0IHN0dXR0ZXJfd2FpdCsweDI2LzB4NWEKWyAgIDQ4LjAy
MTA1OF0gRUFYOiAwMDAwMDAwMiBFQlg6IDgxNWEwZjEwIEVDWDogMDAwMDAwMDAgRURYOiAw
MDAwMDAwMApbICAgNDguMDIxMDU4XSBFU0k6IDhkMTE3NDMwIEVESTogMDAwMDAwMDAgRUJQ
OiA4ZGZkOWVmYyBFU1A6IDhkZmQ5ZWY4ClsgICA0OC4wMjEwNThdICBEUzogMDA3YiBFUzog
MDA3YiBGUzogMDAwMCBHUzogMDBlMCBTUzogMDA2OApbICAgNDguMDIxMDU4XSBDUjA6IDgw
MDUwMDNiIENSMjogMDAwMDAwMDAgQ1IzOiAwMTg2MjAwMCBDUjQ6IDAwMDAwNmYwClsgICA0
OC4wMjEwNThdIFN0YWNrOgpbICAgNDguMDIxMDU4XSAgOGQ2OGQ0MDAgOGRmZDlmMjAgODEw
NWZlZTMgODE1YTBjYTggODE1YTMwYzMgODE1YTBjODcgMDAwMDAwMDAgOGQ2OGQ0MTgKWyAg
IDQ4LjAyMTA1OF0gIDhkMTE3NDMwIDgxMDVmZGYzIDhkZmQ5ZmFjIDgxMDRiNWNiIDAwMDAw
MDAwIDAwMDAwMDBjIDhkMTE3NDMwIDAwMDAwMDAwClsgICA0OC4wMjEwNThdICAwMDAwMDAw
MSBkZWFkNGVhZCBmZmZmZmZmZiBmZmZmZmZmZiA4MTg2Zjg1OCAwMDAwMDAwMCAwMDAwMDAw
MCA4MTU5ZDU0YwpbICAgNDguMDIxMDU4XSBDYWxsIFRyYWNlOgpbICAgNDguMDIxMDU4XSAg
Wzw4MTA1ZmVlMz5dIGxvY2tfdG9ydHVyZV93cml0ZXIrMHhmMC8weDEzYwpbICAgNDguMDIx
MDU4XSAgWzw4MTA1ZmRmMz5dID8gdG9ydHVyZV9sb2NrX2J1c3RlZF93cml0ZV91bmxvY2sr
MHg1LzB4NQpbICAgNDguMDIxMDU4XSAgWzw4MTA0YjVjYj5dIGt0aHJlYWQrMHhiNy8weGJj
ClsgICA0OC4wMjEwNThdICBbPDgxM2U5ZjdiPl0gcmV0X2Zyb21fa2VybmVsX3RocmVhZCsw
eDFiLzB4MzAKWyAgIDQ4LjAyMTA1OF0gIFs8ODEwNGI1MTQ+XSA/IGt0aHJlYWRfc3RvcCsw
eGFhLzB4YWEKWyAgIDQ4LjAyMTA1OF0gQ29kZTogNWIgNTggNWIgNWQgYzMgNTUgODkgZTUg
NTMgODkgYzMgZWIgMzYgODMgM2QgZWMgZjUgY2MgODEgMDAgNzQgMTcgYTEgZWMgZjUgY2Mg
ODEgODMgZjggMDEgNzUgMDIgZWIgMTUgYTEgZWMgZjUgY2MgODEgODUgYzAgNzQgMTEgPGVi
PiBmNSBiOCBlOCAwMyAwMCAwMCBlOCAxNyBlYSBmOSBmZiBlOCBmYSBhNSAzNCAwMCA4OSBk
OCBlOCA5MAova2VybmVsL2kzODYtcmFuZGNvbmZpZy1iYTEtMDMwNjEzMjIvMWY5YzI2OTY4
ZTFhNTAxZjNhODM5NjAzYzk2MzNmMjFhYmNhNjViMy9kbWVzZy1xdWFudGFsLXN0b2FrbGV5
LTQ6MjAxNDAzMDYxODQyNDY6aTM4Ni1yYW5kY29uZmlnLWJhMS0wMzA2MTMyMjozLjE0LjAt
cmMzLTAwMTA0LWcxZjljMjY5OjUxCi9rZXJuZWwvaTM4Ni1yYW5kY29uZmlnLWJhMS0wMzA2
MTMyMi8xZjljMjY5NjhlMWE1MDFmM2E4Mzk2MDNjOTYzM2YyMWFiY2E2NWIzL2RtZXNnLXlv
Y3RvLXhpYW4tMTU6MjAxNDAzMDYxODQyNDY6aTM4Ni1yYW5kY29uZmlnLWJhMS0wMzA2MTMy
MjozLjE0LjAtcmMzLTAwMTA0LWcxZjljMjY5OjUxCi9rZXJuZWwvaTM4Ni1yYW5kY29uZmln
LWJhMS0wMzA2MTMyMi8xZjljMjY5NjhlMWE1MDFmM2E4Mzk2MDNjOTYzM2YyMWFiY2E2NWIz
L2RtZXNnLXlvY3RvLXhpYW4tODoyMDE0MDMwNjE4NDI0NjppMzg2LXJhbmRjb25maWctYmEx
LTAzMDYxMzIyOjMuMTQuMC1yYzMtMDAxMDQtZzFmOWMyNjk6NTEKL2tlcm5lbC9pMzg2LXJh
bmRjb25maWctYmExLTAzMDYxMzIyLzFmOWMyNjk2OGUxYTUwMWYzYTgzOTYwM2M5NjMzZjIx
YWJjYTY1YjMvZG1lc2ctcXVhbnRhbC1hdGhlbnMtNDY6MjAxNDAzMDYxODQyNTM6aTM4Ni1y
YW5kY29uZmlnLWJhMS0wMzA2MTMyMjozLjE0LjAtcmMzLTAwMTA0LWcxZjljMjY5OjUxCi9r
ZXJuZWwvaTM4Ni1yYW5kY29uZmlnLWJhMS0wMzA2MTMyMi8xZjljMjY5NjhlMWE1MDFmM2E4
Mzk2MDNjOTYzM2YyMWFiY2E2NWIzL2RtZXNnLXlvY3RvLWF0aGVucy0yNToyMDE0MDMwNjE4
NDI1ODppMzg2LXJhbmRjb25maWctYmExLTAzMDYxMzIyOjMuMTQuMC1yYzMtMDAxMDQtZzFm
OWMyNjk6NTEKL2tlcm5lbC9pMzg2LXJhbmRjb25maWctYmExLTAzMDYxMzIyLzFmOWMyNjk2
OGUxYTUwMWYzYTgzOTYwM2M5NjMzZjIxYWJjYTY1YjMvZG1lc2cteW9jdG8teGlhbi00OjIw
MTQwMzA2MTg0MjU4OmkzODYtcmFuZGNvbmZpZy1iYTEtMDMwNjEzMjI6My4xNC4wLXJjMy0w
MDEwNC1nMWY5YzI2OTo1MQova2VybmVsL2kzODYtcmFuZGNvbmZpZy1iYTEtMDMwNjEzMjIv
MWY5YzI2OTY4ZTFhNTAxZjNhODM5NjAzYzk2MzNmMjFhYmNhNjViMy9kbWVzZy1xdWFudGFs
LXhpYW4tNToyMDE0MDMwNjE4NDMwNTppMzg2LXJhbmRjb25maWctYmExLTAzMDYxMzIyOjMu
MTQuMC1yYzMtMDAxMDQtZzFmOWMyNjk6NTEKL2tlcm5lbC9pMzg2LXJhbmRjb25maWctYmEx
LTAzMDYxMzIyLzFmOWMyNjk2OGUxYTUwMWYzYTgzOTYwM2M5NjMzZjIxYWJjYTY1YjMvZG1l
c2ctcXVhbnRhbC14aWFuLTY6MjAxNDAzMDYxODQzMDU6aTM4Ni1yYW5kY29uZmlnLWJhMS0w
MzA2MTMyMjozLjE0LjAtcmMzLTAwMTA0LWcxZjljMjY5OjUxCi9rZXJuZWwvaTM4Ni1yYW5k
Y29uZmlnLWJhMS0wMzA2MTMyMi8xZjljMjY5NjhlMWE1MDFmM2E4Mzk2MDNjOTYzM2YyMWFi
Y2E2NWIzL2RtZXNnLXlvY3RvLWxrcC1zdDAxLTExOjIwMTQwMzA2MTg0MzEyOmkzODYtcmFu
ZGNvbmZpZy1iYTEtMDMwNjEzMjI6My4xNC4wLXJjMy0wMDEwNC1nMWY5YzI2OTo1MQowOjk6
OSBhbGxfZ29vZDpiYWQ6YWxsX2JhZCBib290cwobWzE7MzVtMjAxNC0wMy0wNiAxODo0Mzoy
MyBSRVBFQVQgQ09VTlQ6IDIwICAjIC9rZXJuZWwtdGVzdHMvbGludXg1L29iai1iaXNlY3Qv
LnJlcGVhdBtbMG0KCjFmOWMyNjk2OGUxYTUwMWYzYTgzOTYwM2M5NjMzZjIxYWJjYTY1YjMg
aXMgdGhlIGZpcnN0IGJhZCBjb21taXQKY29tbWl0IDFmOWMyNjk2OGUxYTUwMWYzYTgzOTYw
M2M5NjMzZjIxYWJjYTY1YjMKQXV0aG9yOiBQYXVsIEUuIE1jS2VubmV5IDxwYXVsbWNrQGxp
bnV4LnZuZXQuaWJtLmNvbT4KRGF0ZTogICBUdWUgTWFyIDQgMTE6MDM6MjEgMjAxNCAtMDgw
MAoKICAgIHRvcnR1cmU6IEluY3JlYXNlIHN0dXR0ZXItZW5kIGludGVuc2l0eQogICAgCiAg
ICBDdXJyZW50bHksIGFsbCBzdHV0dGVyZWQga3RocmVhZHMgYmxvY2sgYSBqaWZmeSBhdCBh
IHRpbWUsIHdoaWNoIGNhbgogICAgcmVzdWx0IGluIHRoZW0gc3RhcnRpbmcgYXQgZGlmZmVy
ZW50IHRpbWVzLiAgKE5vdGU6IFRoaXMgaXMgbm90IGFuCiAgICBlbmVyZ3ktZWZmaWNpZW5j
eSBwcm9ibGVtIHVubGVzcyB5b3UgcnVuIHRvcnR1cmUgdGVzdHMgaW4gcHJvZHVjdGlvbiwK
ICAgIGluIHdoaWNoIGNhc2UgeW91IGhhdmUgb3RoZXIgcHJvYmxlbXMhKSAgVGhpcyBjb21t
aXQgaW5jcmVhc2VzIHRoZQogICAgaW50ZW5zaXR5IG9mIHRoZSByZXN0YXJ0IGV2ZW50IGJ5
IGNhdXNpbmcga3RocmVhZHMgdG8gc3BpbiB0aHJvdWdoIHRoZQogICAgbGFzdCBqaWZmeSwg
cmVzdGFydGluZyB3aGVuIHRoZXkgc2VlIHRoZSB2YXJpYWJsZSBjaGFuZ2UuCiAgICAKICAg
IFNpZ25lZC1vZmYtYnk6IFBhdWwgRS4gTWNLZW5uZXkgPHBhdWxtY2tAbGludXgudm5ldC5p
Ym0uY29tPgoKOjA0MDAwMCAwNDAwMDAgNDhjNDYzNThhYzQwYTNmZjllNGJlYjRlYzljMzM0
MzcyMmMyMGY1ZSBkYTU0NjE5MjM3NmM3ZDBjYmViMDg2MTBlMTU2NjExY2FkODZjYmY2IE0J
a2VybmVsCmJpc2VjdCBydW4gc3VjY2VzcwpscyAtYSAva2VybmVsLXRlc3RzL3J1bi1xdWV1
ZS9rdm0vaTM4Ni1yYW5kY29uZmlnLWJhMS0wMzA2MTMyMi9saW51eC1kZXZlbDpkZXZlbC1o
b3VybHktMjAxNDAzMDYxMjo0Yzc5ZDdkODk5MDJhMmU5Yzk2YjNkYjUxMTVhZjUyYjNjZjk0
ZGE5OmJpc2VjdC1saW51eDUKCjIwMTQtMDMtMDYtMTg6NDM6MjQgNGM3OWQ3ZDg5OTAyYTJl
OWM5NmIzZGI1MTE1YWY1MmIzY2Y5NGRhOSByZXVzZSAva2VybmVsL2kzODYtcmFuZGNvbmZp
Zy1iYTEtMDMwNjEzMjIvNGM3OWQ3ZDg5OTAyYTJlOWM5NmIzZGI1MTE1YWY1MmIzY2Y5NGRh
OS92bWxpbnV6LTMuMTQuMC1yYzMtMDAxMDMtZzRjNzlkN2QKCjIwMTQtMDMtMDYtMTg6NDM6
MjQgZGV0ZWN0aW5nIGJvb3Qgc3RhdGUgLi4JMjAJMjkuCTM4CTQwCTQ1CTUyCTU2Li4uLi4u
Li4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4u
Li4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4u
Li4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4u
Li4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uCTU5CTYwIFNVQ0NFU1MKCmxzIC1hIC9rZXJuZWwt
dGVzdHMvcnVuLXF1ZXVlL2t2bS9pMzg2LXJhbmRjb25maWctYmExLTAzMDYxMzIyL2xpbnV4
LWRldmVsOmRldmVsLWhvdXJseS0yMDE0MDMwNjEyOmFhZmNmY2EzNmE3YTI2NDA5YWYyZWMy
MjY1OTI3ZWQ4YWQ2ZWI0YjI6YmlzZWN0LWxpbnV4NQogVEVTVCBGQUlMVVJFClsgICAgNS44
MDQ0NjddIHNwaW5fbG9jay10b3J0dXJlOiBDcmVhdGluZyBsb2NrX3RvcnR1cmVfc3RhdHMg
dGFzawpbICAgIDUuODA1NjcwXSBzcGluX2xvY2stdG9ydHVyZTogbG9ja190b3J0dXJlX3dy
aXRlciB0YXNrIHN0YXJ0ZWQKWyAgICA5Ljk5NTE1MF0gcmFuZG9tOiBub25ibG9ja2luZyBw
b29sIGlzIGluaXRpYWxpemVkClsgICA1Mi4wNTAwMzldIEJVRzogc29mdCBsb2NrdXAgLSBD
UFUjMCBzdHVjayBmb3IgMjJzISBbbG9ja190b3J0dXJlX3dyOjI3XQpbICAgNTIuMDUwMDM5
XSBNb2R1bGVzIGxpbmtlZCBpbjoKWyAgIDUyLjA1MDAzOV0gQ1BVOiAwIFBJRDogMjcgQ29t
bTogbG9ja190b3J0dXJlX3dyIE5vdCB0YWludGVkIDMuMTQuMC1yYzUtMDM4NTctZ2FhZmNm
Y2EgIzIKWyAgIDUyLjA1MDAzOV0gdGFzazogOTFmYTkwMDAgdGk6IDkxYzAyMDAwIHRhc2su
dGk6IDkxZmJhMDAwClsgICA1Mi4wNTAwMzldIEVJUDogMDA2MDpbPDgxMDlhZmRlPl0gRUZM
QUdTOiAwMDAwMDIwMiBDUFU6IDAKWyAgIDUyLjA1MDAzOV0gRUlQIGlzIGF0IHN0dXR0ZXJf
d2FpdCsweDFkLzB4NWEKWyAgIDUyLjA1MDAzOV0gRUFYOiAwMDAwMDAwMiBFQlg6IDgxNWE5
Y2YyIEVDWDogMDAwMDAwMDAgRURYOiAwMDAwMDAwMApbICAgNTIuMDUwMDM5XSBFU0k6IDhl
NjdjMzIwIEVESTogMDAwMDAwMDAgRUJQOiA5MWZiYmVmYyBFU1A6IDkxZmJiZWY4ClsgICA1
Mi4wNTAwMzldICBEUzogMDA3YiBFUzogMDA3YiBGUzogMDAwMCBHUzogMDBlMCBTUzogMDA2
OApbICAgNTIuMDUwMDM5XSBDUjA6IDgwMDUwMDNiIENSMjogOTFkYzQwMDAgQ1IzOiAwMTg2
ZjAwMCBDUjQ6IDAwMDAwNmYwClsgICA1Mi4wNTAwMzldIFN0YWNrOgpbICAgNTIuMDUwMDM5
XSAgOGYyMzU0MDAgOTFmYmJmMjAgODEwNjBmOGUgODE1YTlhODYgODE1YWJlZjMgODE1YTlh
NjUgMDAwMDAwMDAgOGYyMzU0YjAKWyAgIDUyLjA1MDAzOV0gIDhlNjdjMzIwIDgxMDYwZTll
IDkxZmJiZmFjIDgxMDRjMGY4IDAwMDAwMDAwIDAwMDAwMDBjIDhlNjdjMzIwIDAwMDAwMDAw
ClsgICA1Mi4wNTAwMzldICAwMDAwMDAwMSBkZWFkNGVhZCBmZmZmZmZmZiBmZmZmZmZmZiA4
MTg3Yzg1OCAwMDAwMDAwMCAwMDAwMDAwMCA4MTVhNjE3NQpbICAgNTIuMDUwMDM5XSBDYWxs
IFRyYWNlOgpbICAgNTIuMDUwMDM5XSAgWzw4MTA2MGY4ZT5dIGxvY2tfdG9ydHVyZV93cml0
ZXIrMHhmMC8weDEzYwpbICAgNTIuMDUwMDM5XSAgWzw4MTA2MGU5ZT5dID8gdG9ydHVyZV9s
b2NrX2J1c3RlZF93cml0ZV91bmxvY2srMHg1LzB4NQpbICAgNTIuMDUwMDM5XSAgWzw4MTA0
YzBmOD5dIGt0aHJlYWQrMHhiNy8weGJjClsgICA1Mi4wNTAwMzldICBbPDgxM2YxMGJiPl0g
cmV0X2Zyb21fa2VybmVsX3RocmVhZCsweDFiLzB4MzAKWyAgIDUyLjA1MDAzOV0gIFs8ODEw
NGMwNDE+XSA/IGt0aHJlYWRfc3RvcCsweGFhLzB4YWEKWyAgIDUyLjA1MDAzOV0gQ29kZTog
MDAgYTEgM2MgYzcgNzkgODEgNDggNzQgZGUgNWIgNTggNWIgNWQgYzMgNTUgODkgZTUgNTMg
ODkgYzMgZWIgMzYgODMgM2QgMGMgYzYgY2QgODEgMDAgNzQgMTcgYTEgMGMgYzYgY2QgODEg
ODMgZjggMDEgNzUgMDIgZWIgMTUgPGExPiAwYyBjNiBjZCA4MSA4NSBjMCA3NCAxMSBlYiBm
NSBiOCBlOCAwMyAwMCAwMCBlOCA3NCBlOCBmOSBmZgova2VybmVsL2kzODYtcmFuZGNvbmZp
Zy1iYTEtMDMwNjEzMjIvYWFmY2ZjYTM2YTdhMjY0MDlhZjJlYzIyNjU5MjdlZDhhZDZlYjRi
Mi9kbWVzZy15b2N0by1sa3AtbmV4MDUtODM6MjAxNDAzMDYxNTU3MDY6aTM4Ni1yYW5kY29u
ZmlnLWJhMS0wMzA2MTMyMjo6Ci9rZXJuZWwvaTM4Ni1yYW5kY29uZmlnLWJhMS0wMzA2MTMy
Mi9hYWZjZmNhMzZhN2EyNjQwOWFmMmVjMjI2NTkyN2VkOGFkNmViNGIyL2RtZXNnLXF1YW50
YWwtbGtwLW5leDA1LTYxOjIwMTQwMzA2MTQxMzAwOmkzODYtcmFuZGNvbmZpZy1iYTEtMDMw
NjEzMjI6Ogova2VybmVsL2kzODYtcmFuZGNvbmZpZy1iYTEtMDMwNjEzMjIvYWFmY2ZjYTM2
YTdhMjY0MDlhZjJlYzIyNjU5MjdlZDhhZDZlYjRiMi9kbWVzZy1xdWFudGFsLWxrcC1uZXgw
NS05NToyMDE0MDMwNjE0MTIyMTppMzg2LXJhbmRjb25maWctYmExLTAzMDYxMzIyOjoKL2tl
cm5lbC9pMzg2LXJhbmRjb25maWctYmExLTAzMDYxMzIyL2FhZmNmY2EzNmE3YTI2NDA5YWYy
ZWMyMjY1OTI3ZWQ4YWQ2ZWI0YjIvZG1lc2cteW9jdG8teGd3by02OjIwMTQwMzA2MTU1NjU4
OmkzODYtcmFuZGNvbmZpZy1iYTEtMDMwNjEzMjI6My4xNC4wLXJjNS0wMzg1Ny1nYWFmY2Zj
YToyCi9rZXJuZWwvaTM4Ni1yYW5kY29uZmlnLWJhMS0wMzA2MTMyMi9hYWZjZmNhMzZhN2Ey
NjQwOWFmMmVjMjI2NTkyN2VkOGFkNmViNGIyL2RtZXNnLXlvY3RvLWxrcC1uZXgwNS03ODoy
MDE0MDMwNjE1NTY1MTppMzg2LXJhbmRjb25maWctYmExLTAzMDYxMzIyOjoKL2tlcm5lbC9p
Mzg2LXJhbmRjb25maWctYmExLTAzMDYxMzIyL2FhZmNmY2EzNmE3YTI2NDA5YWYyZWMyMjY1
OTI3ZWQ4YWQ2ZWI0YjIvZG1lc2ctcXVhbnRhbC1sa3AtbmV4MDUtMzoyMDE0MDMwNjE1NTY0
ODppMzg2LXJhbmRjb25maWctYmExLTAzMDYxMzIyOjoKL2tlcm5lbC9pMzg2LXJhbmRjb25m
aWctYmExLTAzMDYxMzIyL2FhZmNmY2EzNmE3YTI2NDA5YWYyZWMyMjY1OTI3ZWQ4YWQ2ZWI0
YjIvZG1lc2ctcXVhbnRhbC1sa3AtbmV4MDUtMjg6MjAxNDAzMDYxNDEyMjM6aTM4Ni1yYW5k
Y29uZmlnLWJhMS0wMzA2MTMyMjo6Ci9rZXJuZWwvaTM4Ni1yYW5kY29uZmlnLWJhMS0wMzA2
MTMyMi9hYWZjZmNhMzZhN2EyNjQwOWFmMmVjMjI2NTkyN2VkOGFkNmViNGIyL2RtZXNnLXlv
Y3RvLXNuYi0zNToyMDE0MDMwNjE0MTI1MTppMzg2LXJhbmRjb25maWctYmExLTAzMDYxMzIy
OjoKL2tlcm5lbC9pMzg2LXJhbmRjb25maWctYmExLTAzMDYxMzIyL2FhZmNmY2EzNmE3YTI2
NDA5YWYyZWMyMjY1OTI3ZWQ4YWQ2ZWI0YjIvZG1lc2cteW9jdG8tbGtwLW5leDA1LTY4OjIw
MTQwMzA2MTQxMjI1OmkzODYtcmFuZGNvbmZpZy1iYTEtMDMwNjEzMjI6Ogova2VybmVsL2kz
ODYtcmFuZGNvbmZpZy1iYTEtMDMwNjEzMjIvYWFmY2ZjYTM2YTdhMjY0MDlhZjJlYzIyNjU5
MjdlZDhhZDZlYjRiMi9kbWVzZy15b2N0by1sa3AtbmV4MDUtMzoyMDE0MDMwNjE1NTYzNzpp
Mzg2LXJhbmRjb25maWctYmExLTAzMDYxMzIyOjoKL2tlcm5lbC9pMzg2LXJhbmRjb25maWct
YmExLTAzMDYxMzIyL2FhZmNmY2EzNmE3YTI2NDA5YWYyZWMyMjY1OTI3ZWQ4YWQ2ZWI0YjIv
ZG1lc2cteW9jdG8tbGtwLW5leDA1LTY3OjIwMTQwMzA2MTU1NjQ1OmkzODYtcmFuZGNvbmZp
Zy1iYTEtMDMwNjEzMjI6Ogova2VybmVsL2kzODYtcmFuZGNvbmZpZy1iYTEtMDMwNjEzMjIv
YWFmY2ZjYTM2YTdhMjY0MDlhZjJlYzIyNjU5MjdlZDhhZDZlYjRiMi9kbWVzZy1xdWFudGFs
LWJlbnMtNjoyMDE0MDMwNjE1NTcwOTppMzg2LXJhbmRjb25maWctYmExLTAzMDYxMzIyOjMu
MTQuMC1yYzUtMDM4NTctZ2FhZmNmY2E6Mgova2VybmVsL2kzODYtcmFuZGNvbmZpZy1iYTEt
MDMwNjEzMjIvYWFmY2ZjYTM2YTdhMjY0MDlhZjJlYzIyNjU5MjdlZDhhZDZlYjRiMi9kbWVz
Zy1xdWFudGFsLWxrcC1uZXgwNS00NDoyMDE0MDMwNjE0MTIxMTppMzg2LXJhbmRjb25maWct
YmExLTAzMDYxMzIyOjoKL2tlcm5lbC9pMzg2LXJhbmRjb25maWctYmExLTAzMDYxMzIyL2Fh
ZmNmY2EzNmE3YTI2NDA5YWYyZWMyMjY1OTI3ZWQ4YWQ2ZWI0YjIvZG1lc2cteW9jdG8tbGtw
LW5leDA1LTQwOjIwMTQwMzA2MTQxMjU3OmkzODYtcmFuZGNvbmZpZy1iYTEtMDMwNjEzMjI6
Ogova2VybmVsL2kzODYtcmFuZGNvbmZpZy1iYTEtMDMwNjEzMjIvYWFmY2ZjYTM2YTdhMjY0
MDlhZjJlYzIyNjU5MjdlZDhhZDZlYjRiMi9kbWVzZy15b2N0by1sa3AtbmV4MDUtODU6MjAx
NDAzMDYxNTU3MDM6aTM4Ni1yYW5kY29uZmlnLWJhMS0wMzA2MTMyMjo6Ci9rZXJuZWwvaTM4
Ni1yYW5kY29uZmlnLWJhMS0wMzA2MTMyMi9hYWZjZmNhMzZhN2EyNjQwOWFmMmVjMjI2NTky
N2VkOGFkNmViNGIyL2RtZXNnLXF1YW50YWwtbGtwLW5leDA0LTg1OjIwMTQwMzA2MTQxMjU0
OmkzODYtcmFuZGNvbmZpZy1iYTEtMDMwNjEzMjI6Ogova2VybmVsL2kzODYtcmFuZGNvbmZp
Zy1iYTEtMDMwNjEzMjIvYWFmY2ZjYTM2YTdhMjY0MDlhZjJlYzIyNjU5MjdlZDhhZDZlYjRi
Mi9kbWVzZy15b2N0by1sa3AtbmV4MDUtMzM6MjAxNDAzMDYxNTU3MzI6aTM4Ni1yYW5kY29u
ZmlnLWJhMS0wMzA2MTMyMjo6Ci9rZXJuZWwvaTM4Ni1yYW5kY29uZmlnLWJhMS0wMzA2MTMy
Mi9hYWZjZmNhMzZhN2EyNjQwOWFmMmVjMjI2NTkyN2VkOGFkNmViNGIyL2RtZXNnLXF1YW50
YWwtbGtwLW5leDA1LTMxOjIwMTQwMzA2MTQxMjU1OmkzODYtcmFuZGNvbmZpZy1iYTEtMDMw
NjEzMjI6Ogova2VybmVsL2kzODYtcmFuZGNvbmZpZy1iYTEtMDMwNjEzMjIvYWFmY2ZjYTM2
YTdhMjY0MDlhZjJlYzIyNjU5MjdlZDhhZDZlYjRiMi9kbWVzZy1xdWFudGFsLWxrcC1uZXgw
NS04MDoyMDE0MDMwNjE1NTY1NjppMzg2LXJhbmRjb25maWctYmExLTAzMDYxMzIyOjoKMDox
OToxOSBhbGxfZ29vZDpiYWQ6YWxsX2JhZCBib290cwoKW2RldGFjaGVkIEhFQUQgN2NkOGQx
Y10gUmV2ZXJ0ICJ0b3J0dXJlOiBJbmNyZWFzZSBzdHV0dGVyLWVuZCBpbnRlbnNpdHkiCiBD
b21taXR0ZXI6IFd1IEZlbmdndWFuZyA8a2J1aWxkQGJlZT4KWW91ciBuYW1lIGFuZCBlbWFp
bCBhZGRyZXNzIHdlcmUgY29uZmlndXJlZCBhdXRvbWF0aWNhbGx5IGJhc2VkCm9uIHlvdXIg
dXNlcm5hbWUgYW5kIGhvc3RuYW1lLiBQbGVhc2UgY2hlY2sgdGhhdCB0aGV5IGFyZSBhY2N1
cmF0ZS4KWW91IGNhbiBzdXBwcmVzcyB0aGlzIG1lc3NhZ2UgYnkgc2V0dGluZyB0aGVtIGV4
cGxpY2l0bHk6CgogICAgZ2l0IGNvbmZpZyAtLWdsb2JhbCB1c2VyLm5hbWUgIllvdXIgTmFt
ZSIKICAgIGdpdCBjb25maWcgLS1nbG9iYWwgdXNlci5lbWFpbCB5b3VAZXhhbXBsZS5jb20K
CkFmdGVyIGRvaW5nIHRoaXMsIHlvdSBtYXkgZml4IHRoZSBpZGVudGl0eSB1c2VkIGZvciB0
aGlzIGNvbW1pdCB3aXRoOgoKICAgIGdpdCBjb21taXQgLS1hbWVuZCAtLXJlc2V0LWF1dGhv
cgoKIDEgZmlsZSBjaGFuZ2VkLCAyIGluc2VydGlvbnMoKyksIDEwIGRlbGV0aW9ucygtKQps
cyAtYSAva2VybmVsLXRlc3RzL3J1bi1xdWV1ZS9rdm0vaTM4Ni1yYW5kY29uZmlnLWJhMS0w
MzA2MTMyMi9saW51eC1kZXZlbDpkZXZlbC1ob3VybHktMjAxNDAzMDYxMjo3Y2Q4ZDFjMTlk
ZDEwY2I2ODYxYmJmNzExMWJhODZlZjdkMjYyNzg4OmJpc2VjdC1saW51eDUKCjIwMTQtMDMt
MDYtMjA6MjY6NDQgN2NkOGQxYzE5ZGQxMGNiNjg2MWJiZjcxMTFiYTg2ZWY3ZDI2Mjc4OCBj
b21waWxpbmcKCjIwMTQtMDMtMDYtMjA6MzU6MTcgZGV0ZWN0aW5nIGJvb3Qgc3RhdGUgMy4x
NC4wLXJjNS0wMzg1OC1nN2NkOGQxYy4uLgkzCTYJOAkxNAkyMwkyOC4JMzQJNTEJNTQJNTcu
Li4uLi4uLi4JNTguLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4u
Li4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4u
Li4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4u
Li4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4u
Li4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4u
Li4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uG1sxOzM1bTIwMTQt
MDMtMDYgMjM6MTc6NTcgYWRkX3RvX3J1bl9xdWV1ZSAyG1swbQouLgk2MCBTVUNDRVNTCgoK
PT09PT09PT09IHVwc3RyZWFtID09PT09PT09PQpXYXJuaW5nOiB5b3UgYXJlIGxlYXZpbmcg
MSBjb21taXQgYmVoaW5kLCBub3QgY29ubmVjdGVkIHRvCmFueSBvZiB5b3VyIGJyYW5jaGVz
OgoKICA3Y2Q4ZDFjIFJldmVydCAidG9ydHVyZTogSW5jcmVhc2Ugc3R1dHRlci1lbmQgaW50
ZW5zaXR5IgoKSWYgeW91IHdhbnQgdG8ga2VlcCB0aGVtIGJ5IGNyZWF0aW5nIGEgbmV3IGJy
YW5jaCwgdGhpcyBtYXkgYmUgYSBnb29kIHRpbWUKdG8gZG8gc28gd2l0aDoKCiBnaXQgYnJh
bmNoIG5ld19icmFuY2hfbmFtZSA3Y2Q4ZDFjCgpIRUFEIGlzIG5vdyBhdCBjM2JlYmM3Li4u
IE1lcmdlIGdpdDovL2dpdC5rZXJuZWwub3JnL3B1Yi9zY20vbGludXgva2VybmVsL2dpdC9k
YXZlbS9uZXQKbHMgLWEgL2tlcm5lbC10ZXN0cy9ydW4tcXVldWUva3ZtL2kzODYtcmFuZGNv
bmZpZy1iYTEtMDMwNjEzMjIvbGludXgtZGV2ZWw6ZGV2ZWwtaG91cmx5LTIwMTQwMzA2MTI6
YzNiZWJjNzFjNGJjZGFmYTI0YjUwNmFkZjBjMWRlM2MxZjc3ZTJlMDpiaXNlY3QtbGludXg1
CgoyMDE0LTAzLTA2LTIzOjE5OjI4IGMzYmViYzcxYzRiY2RhZmEyNGI1MDZhZGYwYzFkZTNj
MWY3N2UyZTAgY29tcGlsaW5nCgoyMDE0LTAzLTA2LTIzOjIxOjMzIGRldGVjdGluZyBib290
IHN0YXRlIDMuMTQuMC1yYzUtMDAxODUtZ2MzYmViYzcuLi4JNgkxOQkzMAk0NQk1OQk2MCBT
VUNDRVNTCgoKPT09PT09PT09IGxpbnV4LW5leHQgPT09PT09PT09CkZldGNoaW5nIG5leHQK
RnJvbSBnaXQ6Ly9naXRtaXJyb3IvbmV4dAogKyA2ZTc2ZDg1Li4uZDRiYjJlYiBha3BtICAg
ICAgIC0+IG5leHQvYWtwbSAgKGZvcmNlZCB1cGRhdGUpCiArIDVhMzk3MzkuLi4wOWRlMTky
IGFrcG0tYmFzZSAgLT4gbmV4dC9ha3BtLWJhc2UgIChmb3JjZWQgdXBkYXRlKQogKyAxZDlm
MzhiLi4uMGZmYjJmZSBtYXN0ZXIgICAgIC0+IG5leHQvbWFzdGVyICAoZm9yY2VkIHVwZGF0
ZSkKICAgMGMwYmQzNC4uYzNiZWJjNyAgc3RhYmxlICAgICAtPiBuZXh0L3N0YWJsZQogKiBb
bmV3IHRhZ10gICAgICAgICBuZXh0LTIwMTQwMzA2IC0+IG5leHQtMjAxNDAzMDYKUHJldmlv
dXMgSEVBRCBwb3NpdGlvbiB3YXMgYzNiZWJjNy4uLiBNZXJnZSBnaXQ6Ly9naXQua2VybmVs
Lm9yZy9wdWIvc2NtL2xpbnV4L2tlcm5lbC9naXQvZGF2ZW0vbmV0CkhFQUQgaXMgbm93IGF0
IDBmZmIyZmUuLi4gQWRkIGxpbnV4LW5leHQgc3BlY2lmaWMgZmlsZXMgZm9yIDIwMTQwMzA2
CmxzIC1hIC9rZXJuZWwtdGVzdHMvcnVuLXF1ZXVlL2t2bS9pMzg2LXJhbmRjb25maWctYmEx
LTAzMDYxMzIyL2xpbnV4LWRldmVsOmRldmVsLWhvdXJseS0yMDE0MDMwNjEyOjBmZmIyZmU3
YjljMzAwODI4NzZmYTNhMTdkYTAxOGJmMDYzMmNmMDM6YmlzZWN0LWxpbnV4NQoKMjAxNC0w
My0wNi0yMzoyNjo0OCAwZmZiMmZlN2I5YzMwMDgyODc2ZmEzYTE3ZGEwMThiZjA2MzJjZjAz
IGNvbXBpbGluZwoKMjAxNC0wMy0wNi0yMzoyODo0OSBkZXRlY3RpbmcgYm9vdCBzdGF0ZSAz
LjE0LjAtcmM1LW5leHQtMjAxNDAzMDYuLgkxCTEwCTI4CTQyCTU1Lgk1Ngk1OC4uLgk1OS4u
Li4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4u
Li4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4u
Li4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4u
Li4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4u
Li4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4u
Li4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4bWzE7MzVtMjAxNC0wMy0wNyAwMjowNjoy
OSBhZGRfdG9fcnVuX3F1ZXVlIDEbWzBtCi4uLi4JNjAgU1VDQ0VTUwoK

--k1lZvvs/B4yU6o8G
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="config-3.14.0-rc5-03857-gaafcfca"

#
# Automatically generated file; DO NOT EDIT.
# Linux/i386 3.14.0-rc5 Kernel Configuration
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
CONFIG_KERNEL_LZO=y
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
CONFIG_GENERIC_CLOCKEVENTS_MIN_ADJUST=y
CONFIG_GENERIC_CMOS_UPDATE=y

#
# Timers subsystem
#
CONFIG_TICK_ONESHOT=y
CONFIG_HZ_PERIODIC=y
# CONFIG_NO_HZ_IDLE is not set
# CONFIG_NO_HZ is not set
CONFIG_HIGH_RES_TIMERS=y

#
# CPU/Task time and stats accounting
#
CONFIG_TICK_CPU_ACCOUNTING=y
# CONFIG_IRQ_TIME_ACCOUNTING is not set
# CONFIG_BSD_PROCESS_ACCT is not set
# CONFIG_TASKSTATS is not set

#
# RCU Subsystem
#
CONFIG_TINY_RCU=y
# CONFIG_PREEMPT_RCU is not set
# CONFIG_RCU_STALL_COMMON is not set
# CONFIG_TREE_RCU_TRACE is not set
CONFIG_IKCONFIG=y
CONFIG_LOG_BUF_SHIFT=17
CONFIG_HAVE_UNSTABLE_SCHED_CLOCK=y
CONFIG_ARCH_SUPPORTS_NUMA_BALANCING=y
CONFIG_ARCH_WANTS_PROT_NUMA_PROT_NONE=y
# CONFIG_CGROUPS is not set
CONFIG_CHECKPOINT_RESTORE=y
# CONFIG_NAMESPACES is not set
# CONFIG_SCHED_AUTOGROUP is not set
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
CONFIG_CC_OPTIMIZE_FOR_SIZE=y
CONFIG_ANON_INODES=y
CONFIG_HAVE_UID16=y
CONFIG_SYSCTL_EXCEPTION_TRACE=y
CONFIG_HAVE_PCSPKR_PLATFORM=y
CONFIG_EXPERT=y
# CONFIG_UID16 is not set
CONFIG_KALLSYMS=y
CONFIG_KALLSYMS_ALL=y
CONFIG_PRINTK=y
CONFIG_BUG=y
CONFIG_PCSPKR_PLATFORM=y
CONFIG_BASE_FULL=y
CONFIG_FUTEX=y
CONFIG_EPOLL=y
# CONFIG_SIGNALFD is not set
# CONFIG_TIMERFD is not set
CONFIG_EVENTFD=y
# CONFIG_SHMEM is not set
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
# CONFIG_PROFILING is not set
CONFIG_TRACEPOINTS=y
CONFIG_HAVE_OPROFILE=y
CONFIG_OPROFILE_NMI_TIMER=y
# CONFIG_KPROBES is not set
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
# CONFIG_GCOV_KERNEL is not set
CONFIG_HAVE_GENERIC_DMA_COHERENT=y
CONFIG_RT_MUTEXES=y
CONFIG_BASE_SMALL=0
CONFIG_SYSTEM_TRUSTED_KEYRING=y
CONFIG_MODULES=y
# CONFIG_MODULE_FORCE_LOAD is not set
# CONFIG_MODULE_UNLOAD is not set
CONFIG_MODVERSIONS=y
CONFIG_MODULE_SRCVERSION_ALL=y
CONFIG_MODULE_SIG=y
CONFIG_MODULE_SIG_FORCE=y
# CONFIG_MODULE_SIG_ALL is not set

#
# Do not forget to sign required modules with scripts/sign-file
#
# CONFIG_MODULE_SIG_SHA1 is not set
# CONFIG_MODULE_SIG_SHA224 is not set
CONFIG_MODULE_SIG_SHA256=y
# CONFIG_MODULE_SIG_SHA384 is not set
# CONFIG_MODULE_SIG_SHA512 is not set
CONFIG_MODULE_SIG_HASH="sha256"
# CONFIG_BLOCK is not set
CONFIG_ASN1=y
CONFIG_UNINLINE_SPIN_UNLOCK=y
# CONFIG_FREEZER is not set

#
# Processor type and features
#
CONFIG_ZONE_DMA=y
# CONFIG_SMP is not set
CONFIG_GOLDFISH=y
CONFIG_X86_EXTENDED_PLATFORM=y
CONFIG_X86_GOLDFISH=y
# CONFIG_X86_INTEL_LPSS is not set
# CONFIG_X86_RDC321X is not set
CONFIG_X86_SUPPORTS_MEMORY_FAILURE=y
CONFIG_X86_32_IRIS=m
# CONFIG_SCHED_OMIT_FRAME_POINTER is not set
CONFIG_HYPERVISOR_GUEST=y
CONFIG_PARAVIRT=y
CONFIG_PARAVIRT_DEBUG=y
# CONFIG_XEN_PRIVILEGED_GUEST is not set
CONFIG_KVM_GUEST=y
CONFIG_KVM_DEBUG_FS=y
CONFIG_LGUEST_GUEST=y
# CONFIG_PARAVIRT_TIME_ACCOUNTING is not set
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
# CONFIG_DMI is not set
CONFIG_NR_CPUS=1
# CONFIG_PREEMPT_NONE is not set
CONFIG_PREEMPT_VOLUNTARY=y
# CONFIG_PREEMPT is not set
CONFIG_PREEMPT_COUNT=y
# CONFIG_X86_UP_APIC is not set
CONFIG_X86_MCE=y
CONFIG_X86_ANCIENT_MCE=y
# CONFIG_X86_MCE_INJECT is not set
CONFIG_VM86=y
# CONFIG_TOSHIBA is not set
# CONFIG_I8K is not set
CONFIG_X86_REBOOTFIXUPS=y
CONFIG_MICROCODE=m
# CONFIG_MICROCODE_INTEL is not set
CONFIG_MICROCODE_AMD=y
CONFIG_MICROCODE_OLD_INTERFACE=y
# CONFIG_MICROCODE_INTEL_EARLY is not set
# CONFIG_MICROCODE_AMD_EARLY is not set
# CONFIG_X86_MSR is not set
CONFIG_X86_CPUID=y
CONFIG_NOHIGHMEM=y
# CONFIG_HIGHMEM4G is not set
# CONFIG_VMSPLIT_3G is not set
CONFIG_VMSPLIT_2G=y
# CONFIG_VMSPLIT_1G is not set
CONFIG_PAGE_OFFSET=0x80000000
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
# CONFIG_COMPACTION is not set
CONFIG_MIGRATION=y
CONFIG_PHYS_ADDR_T_64BIT=y
CONFIG_ZONE_DMA_FLAG=1
CONFIG_VIRT_TO_BUS=y
CONFIG_KSM=y
CONFIG_DEFAULT_MMAP_MIN_ADDR=4096
CONFIG_ARCH_SUPPORTS_MEMORY_FAILURE=y
# CONFIG_MEMORY_FAILURE is not set
# CONFIG_TRANSPARENT_HUGEPAGE is not set
# CONFIG_CROSS_MEMORY_ATTACH is not set
CONFIG_NEED_PER_CPU_KM=y
# CONFIG_CLEANCACHE is not set
CONFIG_CMA=y
# CONFIG_CMA_DEBUG is not set
# CONFIG_ZBUD is not set
CONFIG_ZSMALLOC=y
CONFIG_PGTABLE_MAPPING=y
CONFIG_X86_CHECK_BIOS_CORRUPTION=y
CONFIG_X86_BOOTPARAM_MEMORY_CORRUPTION_CHECK=y
CONFIG_X86_RESERVE_LOW=64
CONFIG_MATH_EMULATION=y
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
CONFIG_SCHED_HRTICK=y
CONFIG_KEXEC=y
CONFIG_PHYSICAL_START=0x1000000
# CONFIG_RELOCATABLE is not set
CONFIG_PHYSICAL_ALIGN=0x200000
# CONFIG_COMPAT_VDSO is not set
# CONFIG_CMDLINE_BOOL is not set

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
# CONFIG_ACPI_EC_DEBUGFS is not set
CONFIG_ACPI_AC=y
CONFIG_ACPI_BATTERY=y
CONFIG_ACPI_BUTTON=y
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
# CONFIG_ACPI_REDUCED_HARDWARE_ONLY is not set
# CONFIG_ACPI_APEI is not set
CONFIG_SFI=y

#
# CPU Frequency scaling
#
# CONFIG_CPU_FREQ is not set

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
# CONFIG_PCI_IOV is not set
# CONFIG_PCI_PRI is not set
# CONFIG_PCI_PASID is not set
CONFIG_PCI_LABEL=y

#
# PCI host controller drivers
#
CONFIG_ISA_DMA_API=y
# CONFIG_ISA is not set
CONFIG_SCx200=m
CONFIG_SCx200HR_TIMER=m
# CONFIG_ALIX is not set
# CONFIG_NET5501 is not set
CONFIG_AMD_NB=y
CONFIG_PCCARD=y
CONFIG_PCMCIA=m
# CONFIG_PCMCIA_LOAD_CIS is not set
CONFIG_CARDBUS=y

#
# PC-card bridges
#
# CONFIG_YENTA is not set
# CONFIG_PD6729 is not set
# CONFIG_I82092 is not set
# CONFIG_HOTPLUG_PCI is not set
# CONFIG_RAPIDIO is not set
CONFIG_X86_SYSFB=y

#
# Executable file formats / Emulations
#
CONFIG_BINFMT_ELF=y
CONFIG_ARCH_BINFMT_ELF_RANDOMIZE_PIE=y
CONFIG_BINFMT_SCRIPT=y
CONFIG_HAVE_AOUT=y
# CONFIG_BINFMT_AOUT is not set
CONFIG_BINFMT_MISC=y
# CONFIG_COREDUMP is not set
CONFIG_HAVE_ATOMIC_IOMAP=y
CONFIG_NET=y

#
# Networking options
#
# CONFIG_PACKET is not set
CONFIG_UNIX=y
CONFIG_UNIX_DIAG=m
CONFIG_XFRM=y
CONFIG_XFRM_ALGO=y
CONFIG_XFRM_USER=m
CONFIG_XFRM_SUB_POLICY=y
CONFIG_XFRM_MIGRATE=y
CONFIG_XFRM_IPCOMP=m
# CONFIG_NET_KEY is not set
CONFIG_INET=y
# CONFIG_IP_MULTICAST is not set
# CONFIG_IP_ADVANCED_ROUTER is not set
# CONFIG_IP_PNP is not set
CONFIG_NET_IPIP=m
# CONFIG_NET_IPGRE_DEMUX is not set
CONFIG_NET_IP_TUNNEL=m
CONFIG_SYN_COOKIES=y
CONFIG_NET_IPVTI=m
CONFIG_INET_AH=y
CONFIG_INET_ESP=y
# CONFIG_INET_IPCOMP is not set
# CONFIG_INET_XFRM_TUNNEL is not set
CONFIG_INET_TUNNEL=m
CONFIG_INET_XFRM_MODE_TRANSPORT=y
CONFIG_INET_XFRM_MODE_TUNNEL=y
CONFIG_INET_XFRM_MODE_BEET=m
CONFIG_INET_LRO=m
# CONFIG_INET_DIAG is not set
# CONFIG_TCP_CONG_ADVANCED is not set
CONFIG_TCP_CONG_CUBIC=y
CONFIG_DEFAULT_TCP_CONG="cubic"
CONFIG_TCP_MD5SIG=y
CONFIG_IPV6=m
CONFIG_IPV6_ROUTER_PREF=y
CONFIG_IPV6_ROUTE_INFO=y
CONFIG_IPV6_OPTIMISTIC_DAD=y
CONFIG_INET6_AH=m
# CONFIG_INET6_ESP is not set
CONFIG_INET6_IPCOMP=m
CONFIG_IPV6_MIP6=m
CONFIG_INET6_XFRM_TUNNEL=m
CONFIG_INET6_TUNNEL=m
CONFIG_INET6_XFRM_MODE_TRANSPORT=m
CONFIG_INET6_XFRM_MODE_TUNNEL=m
# CONFIG_INET6_XFRM_MODE_BEET is not set
CONFIG_INET6_XFRM_MODE_ROUTEOPTIMIZATION=m
CONFIG_IPV6_VTI=m
CONFIG_IPV6_SIT=m
CONFIG_IPV6_SIT_6RD=y
CONFIG_IPV6_NDISC_NODETYPE=y
CONFIG_IPV6_TUNNEL=m
CONFIG_IPV6_GRE=m
CONFIG_IPV6_MULTIPLE_TABLES=y
# CONFIG_IPV6_SUBTREES is not set
CONFIG_IPV6_MROUTE=y
CONFIG_IPV6_MROUTE_MULTIPLE_TABLES=y
CONFIG_IPV6_PIMSM_V2=y
CONFIG_NETWORK_SECMARK=y
# CONFIG_NETWORK_PHY_TIMESTAMPING is not set
CONFIG_NETFILTER=y
CONFIG_NETFILTER_DEBUG=y
CONFIG_NETFILTER_ADVANCED=y

#
# Core Netfilter Configuration
#
CONFIG_NETFILTER_NETLINK=y
CONFIG_NETFILTER_NETLINK_ACCT=y
CONFIG_NETFILTER_NETLINK_QUEUE=y
CONFIG_NETFILTER_NETLINK_LOG=y
CONFIG_NF_CONNTRACK=y
CONFIG_NF_CONNTRACK_MARK=y
CONFIG_NF_CONNTRACK_SECMARK=y
# CONFIG_NF_CONNTRACK_ZONES is not set
CONFIG_NF_CONNTRACK_EVENTS=y
CONFIG_NF_CONNTRACK_TIMEOUT=y
CONFIG_NF_CONNTRACK_TIMESTAMP=y
CONFIG_NF_CONNTRACK_LABELS=y
CONFIG_NF_CT_PROTO_DCCP=m
CONFIG_NF_CT_PROTO_GRE=y
CONFIG_NF_CT_PROTO_SCTP=y
# CONFIG_NF_CT_PROTO_UDPLITE is not set
CONFIG_NF_CONNTRACK_AMANDA=m
CONFIG_NF_CONNTRACK_FTP=y
# CONFIG_NF_CONNTRACK_H323 is not set
# CONFIG_NF_CONNTRACK_IRC is not set
CONFIG_NF_CONNTRACK_BROADCAST=m
# CONFIG_NF_CONNTRACK_NETBIOS_NS is not set
CONFIG_NF_CONNTRACK_SNMP=m
CONFIG_NF_CONNTRACK_PPTP=y
CONFIG_NF_CONNTRACK_SANE=y
CONFIG_NF_CONNTRACK_SIP=y
CONFIG_NF_CONNTRACK_TFTP=m
CONFIG_NF_CT_NETLINK=m
CONFIG_NF_CT_NETLINK_TIMEOUT=y
# CONFIG_NF_CT_NETLINK_HELPER is not set
CONFIG_NETFILTER_NETLINK_QUEUE_CT=y
CONFIG_NETFILTER_SYNPROXY=m
# CONFIG_NF_TABLES is not set
CONFIG_NETFILTER_XTABLES=y

#
# Xtables combined modules
#
CONFIG_NETFILTER_XT_MARK=y
CONFIG_NETFILTER_XT_CONNMARK=m
# CONFIG_NETFILTER_XT_SET is not set

#
# Xtables targets
#
CONFIG_NETFILTER_XT_TARGET_CHECKSUM=y
CONFIG_NETFILTER_XT_TARGET_CLASSIFY=y
CONFIG_NETFILTER_XT_TARGET_CONNMARK=m
# CONFIG_NETFILTER_XT_TARGET_CONNSECMARK is not set
CONFIG_NETFILTER_XT_TARGET_CT=m
CONFIG_NETFILTER_XT_TARGET_DSCP=m
CONFIG_NETFILTER_XT_TARGET_HL=y
CONFIG_NETFILTER_XT_TARGET_HMARK=m
CONFIG_NETFILTER_XT_TARGET_IDLETIMER=y
CONFIG_NETFILTER_XT_TARGET_LOG=m
# CONFIG_NETFILTER_XT_TARGET_MARK is not set
CONFIG_NETFILTER_XT_TARGET_NFLOG=y
CONFIG_NETFILTER_XT_TARGET_NFQUEUE=m
# CONFIG_NETFILTER_XT_TARGET_NOTRACK is not set
# CONFIG_NETFILTER_XT_TARGET_RATEEST is not set
# CONFIG_NETFILTER_XT_TARGET_TEE is not set
# CONFIG_NETFILTER_XT_TARGET_TPROXY is not set
CONFIG_NETFILTER_XT_TARGET_TRACE=y
# CONFIG_NETFILTER_XT_TARGET_SECMARK is not set
CONFIG_NETFILTER_XT_TARGET_TCPMSS=m
CONFIG_NETFILTER_XT_TARGET_TCPOPTSTRIP=y

#
# Xtables matches
#
CONFIG_NETFILTER_XT_MATCH_ADDRTYPE=y
CONFIG_NETFILTER_XT_MATCH_BPF=m
# CONFIG_NETFILTER_XT_MATCH_CLUSTER is not set
CONFIG_NETFILTER_XT_MATCH_COMMENT=m
# CONFIG_NETFILTER_XT_MATCH_CONNBYTES is not set
CONFIG_NETFILTER_XT_MATCH_CONNLABEL=y
# CONFIG_NETFILTER_XT_MATCH_CONNLIMIT is not set
CONFIG_NETFILTER_XT_MATCH_CONNMARK=m
CONFIG_NETFILTER_XT_MATCH_CONNTRACK=y
CONFIG_NETFILTER_XT_MATCH_CPU=y
# CONFIG_NETFILTER_XT_MATCH_DCCP is not set
CONFIG_NETFILTER_XT_MATCH_DEVGROUP=y
CONFIG_NETFILTER_XT_MATCH_DSCP=y
CONFIG_NETFILTER_XT_MATCH_ECN=y
# CONFIG_NETFILTER_XT_MATCH_ESP is not set
# CONFIG_NETFILTER_XT_MATCH_HASHLIMIT is not set
CONFIG_NETFILTER_XT_MATCH_HELPER=m
CONFIG_NETFILTER_XT_MATCH_HL=y
CONFIG_NETFILTER_XT_MATCH_IPCOMP=m
CONFIG_NETFILTER_XT_MATCH_IPRANGE=m
# CONFIG_NETFILTER_XT_MATCH_IPVS is not set
CONFIG_NETFILTER_XT_MATCH_L2TP=m
CONFIG_NETFILTER_XT_MATCH_LENGTH=m
# CONFIG_NETFILTER_XT_MATCH_LIMIT is not set
# CONFIG_NETFILTER_XT_MATCH_MAC is not set
CONFIG_NETFILTER_XT_MATCH_MARK=y
# CONFIG_NETFILTER_XT_MATCH_MULTIPORT is not set
CONFIG_NETFILTER_XT_MATCH_NFACCT=y
# CONFIG_NETFILTER_XT_MATCH_OSF is not set
CONFIG_NETFILTER_XT_MATCH_OWNER=y
CONFIG_NETFILTER_XT_MATCH_POLICY=y
CONFIG_NETFILTER_XT_MATCH_PKTTYPE=m
# CONFIG_NETFILTER_XT_MATCH_QUOTA is not set
# CONFIG_NETFILTER_XT_MATCH_RATEEST is not set
# CONFIG_NETFILTER_XT_MATCH_REALM is not set
CONFIG_NETFILTER_XT_MATCH_RECENT=y
CONFIG_NETFILTER_XT_MATCH_SCTP=y
CONFIG_NETFILTER_XT_MATCH_SOCKET=m
# CONFIG_NETFILTER_XT_MATCH_STATE is not set
CONFIG_NETFILTER_XT_MATCH_STATISTIC=m
CONFIG_NETFILTER_XT_MATCH_STRING=y
CONFIG_NETFILTER_XT_MATCH_TCPMSS=y
CONFIG_NETFILTER_XT_MATCH_TIME=y
CONFIG_NETFILTER_XT_MATCH_U32=y
CONFIG_IP_SET=y
CONFIG_IP_SET_MAX=256
CONFIG_IP_SET_BITMAP_IP=y
CONFIG_IP_SET_BITMAP_IPMAC=m
# CONFIG_IP_SET_BITMAP_PORT is not set
# CONFIG_IP_SET_HASH_IP is not set
CONFIG_IP_SET_HASH_IPPORT=y
CONFIG_IP_SET_HASH_IPPORTIP=y
CONFIG_IP_SET_HASH_IPPORTNET=m
# CONFIG_IP_SET_HASH_NETPORTNET is not set
CONFIG_IP_SET_HASH_NET=y
CONFIG_IP_SET_HASH_NETNET=y
CONFIG_IP_SET_HASH_NETPORT=y
CONFIG_IP_SET_HASH_NETIFACE=m
# CONFIG_IP_SET_LIST_SET is not set
CONFIG_IP_VS=y
# CONFIG_IP_VS_DEBUG is not set
CONFIG_IP_VS_TAB_BITS=12

#
# IPVS transport protocol load balancing support
#
CONFIG_IP_VS_PROTO_TCP=y
# CONFIG_IP_VS_PROTO_UDP is not set
CONFIG_IP_VS_PROTO_AH_ESP=y
CONFIG_IP_VS_PROTO_ESP=y
# CONFIG_IP_VS_PROTO_AH is not set
CONFIG_IP_VS_PROTO_SCTP=y

#
# IPVS scheduler
#
CONFIG_IP_VS_RR=y
CONFIG_IP_VS_WRR=m
# CONFIG_IP_VS_LC is not set
CONFIG_IP_VS_WLC=y
CONFIG_IP_VS_LBLC=m
# CONFIG_IP_VS_LBLCR is not set
# CONFIG_IP_VS_DH is not set
# CONFIG_IP_VS_SH is not set
CONFIG_IP_VS_SED=y
CONFIG_IP_VS_NQ=y

#
# IPVS SH scheduler
#
CONFIG_IP_VS_SH_TAB_BITS=8

#
# IPVS application helper
#
# CONFIG_IP_VS_NFCT is not set

#
# IP: Netfilter Configuration
#
CONFIG_NF_DEFRAG_IPV4=m
# CONFIG_NF_CONNTRACK_IPV4 is not set
CONFIG_IP_NF_IPTABLES=y
CONFIG_IP_NF_MATCH_AH=y
CONFIG_IP_NF_MATCH_ECN=y
CONFIG_IP_NF_MATCH_RPFILTER=y
CONFIG_IP_NF_MATCH_TTL=m
# CONFIG_IP_NF_FILTER is not set
CONFIG_IP_NF_TARGET_SYNPROXY=m
CONFIG_IP_NF_TARGET_ULOG=y
CONFIG_IP_NF_MANGLE=y
CONFIG_IP_NF_TARGET_ECN=y
CONFIG_IP_NF_TARGET_TTL=y
CONFIG_IP_NF_RAW=y
# CONFIG_IP_NF_ARPTABLES is not set

#
# IPv6: Netfilter Configuration
#
CONFIG_NF_DEFRAG_IPV6=m
CONFIG_NF_CONNTRACK_IPV6=m
# CONFIG_IP6_NF_IPTABLES is not set
CONFIG_IP_DCCP=y

#
# DCCP CCIDs Configuration
#
CONFIG_IP_DCCP_CCID2_DEBUG=y
# CONFIG_IP_DCCP_CCID3 is not set

#
# DCCP Kernel Hacking
#
# CONFIG_IP_DCCP_DEBUG is not set
CONFIG_IP_SCTP=m
# CONFIG_SCTP_DEFAULT_COOKIE_HMAC_MD5 is not set
CONFIG_SCTP_DEFAULT_COOKIE_HMAC_SHA1=y
# CONFIG_SCTP_DEFAULT_COOKIE_HMAC_NONE is not set
CONFIG_SCTP_COOKIE_HMAC_MD5=y
CONFIG_SCTP_COOKIE_HMAC_SHA1=y
CONFIG_RDS=y
CONFIG_RDS_TCP=m
CONFIG_RDS_DEBUG=y
CONFIG_TIPC=m
CONFIG_TIPC_PORTS=8191
# CONFIG_ATM is not set
CONFIG_L2TP=m
# CONFIG_L2TP_DEBUGFS is not set
# CONFIG_L2TP_V3 is not set
CONFIG_STP=m
CONFIG_GARP=m
CONFIG_MRP=m
# CONFIG_BRIDGE is not set
CONFIG_HAVE_NET_DSA=y
CONFIG_NET_DSA=m
CONFIG_NET_DSA_TAG_DSA=y
CONFIG_NET_DSA_TAG_EDSA=y
CONFIG_NET_DSA_TAG_TRAILER=y
CONFIG_VLAN_8021Q=m
CONFIG_VLAN_8021Q_GVRP=y
CONFIG_VLAN_8021Q_MVRP=y
# CONFIG_DECNET is not set
CONFIG_LLC=y
CONFIG_LLC2=y
CONFIG_IPX=m
CONFIG_IPX_INTERN=y
# CONFIG_ATALK is not set
CONFIG_X25=y
CONFIG_LAPB=y
CONFIG_PHONET=m
CONFIG_IEEE802154=y
CONFIG_IEEE802154_6LOWPAN=m
CONFIG_6LOWPAN_IPHC=y
# CONFIG_MAC802154 is not set
# CONFIG_NET_SCHED is not set
CONFIG_DCB=y
CONFIG_DNS_RESOLVER=m
CONFIG_BATMAN_ADV=y
# CONFIG_BATMAN_ADV_BLA is not set
CONFIG_BATMAN_ADV_DAT=y
# CONFIG_BATMAN_ADV_NC is not set
# CONFIG_BATMAN_ADV_DEBUG is not set
CONFIG_OPENVSWITCH=y
CONFIG_VSOCKETS=y
CONFIG_NETLINK_MMAP=y
# CONFIG_NETLINK_DIAG is not set
# CONFIG_NET_MPLS_GSO is not set
CONFIG_HSR=m
CONFIG_NET_RX_BUSY_POLL=y
CONFIG_BQL=y

#
# Network testing
#
CONFIG_NET_DROP_MONITOR=y
CONFIG_HAMRADIO=y

#
# Packet Radio protocols
#
# CONFIG_AX25 is not set
# CONFIG_CAN is not set
CONFIG_IRDA=m

#
# IrDA protocols
#
# CONFIG_IRLAN is not set
CONFIG_IRNET=m
# CONFIG_IRCOMM is not set
CONFIG_IRDA_ULTRA=y

#
# IrDA options
#
# CONFIG_IRDA_CACHE_LAST_LSAP is not set
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
# CONFIG_NSC_FIR is not set
CONFIG_WINBOND_FIR=m
# CONFIG_TOSHIBA_FIR is not set
CONFIG_SMC_IRCC_FIR=m
# CONFIG_ALI_FIR is not set
# CONFIG_VLSI_FIR is not set
CONFIG_VIA_FIR=m
CONFIG_BT=y
CONFIG_BT_RFCOMM=y
# CONFIG_BT_RFCOMM_TTY is not set
# CONFIG_BT_BNEP is not set
CONFIG_BT_CMTP=y
CONFIG_BT_HIDP=m

#
# Bluetooth device drivers
#
CONFIG_BT_HCIBTSDIO=m
CONFIG_BT_HCIUART=m
CONFIG_BT_HCIUART_H4=y
# CONFIG_BT_HCIUART_BCSP is not set
# CONFIG_BT_HCIUART_ATH3K is not set
# CONFIG_BT_HCIUART_LL is not set
CONFIG_BT_HCIUART_3WIRE=y
CONFIG_BT_HCIDTL1=m
# CONFIG_BT_HCIBT3C is not set
# CONFIG_BT_HCIBLUECARD is not set
CONFIG_BT_HCIBTUART=m
CONFIG_BT_HCIVHCI=y
CONFIG_BT_MRVL=y
CONFIG_BT_MRVL_SDIO=m
CONFIG_AF_RXRPC=y
CONFIG_AF_RXRPC_DEBUG=y
# CONFIG_RXKAD is not set
CONFIG_FIB_RULES=y
CONFIG_WIRELESS=y
CONFIG_WIRELESS_EXT=y
CONFIG_WEXT_CORE=y
CONFIG_WEXT_SPY=y
CONFIG_WEXT_PRIV=y
CONFIG_CFG80211=m
CONFIG_NL80211_TESTMODE=y
# CONFIG_CFG80211_DEVELOPER_WARNINGS is not set
# CONFIG_CFG80211_REG_DEBUG is not set
# CONFIG_CFG80211_CERTIFICATION_ONUS is not set
# CONFIG_CFG80211_DEFAULT_PS is not set
CONFIG_CFG80211_DEBUGFS=y
# CONFIG_CFG80211_INTERNAL_REGDB is not set
# CONFIG_CFG80211_WEXT is not set
# CONFIG_LIB80211 is not set
CONFIG_MAC80211=m
CONFIG_MAC80211_HAS_RC=y
CONFIG_MAC80211_RC_PID=y
# CONFIG_MAC80211_RC_MINSTREL is not set
CONFIG_MAC80211_RC_DEFAULT_PID=y
CONFIG_MAC80211_RC_DEFAULT="pid"
# CONFIG_MAC80211_MESH is not set
# CONFIG_MAC80211_DEBUGFS is not set
# CONFIG_MAC80211_MESSAGE_TRACING is not set
# CONFIG_MAC80211_DEBUG_MENU is not set
CONFIG_WIMAX=m
CONFIG_WIMAX_DEBUG_LEVEL=8
CONFIG_RFKILL=y
# CONFIG_RFKILL_INPUT is not set
CONFIG_RFKILL_REGULATOR=m
CONFIG_NET_9P=y
# CONFIG_NET_9P_VIRTIO is not set
CONFIG_NET_9P_DEBUG=y
# CONFIG_CAIF is not set
# CONFIG_CEPH_LIB is not set
# CONFIG_NFC is not set

#
# Device Drivers
#

#
# Generic Driver Options
#
CONFIG_UEVENT_HELPER_PATH=""
CONFIG_DEVTMPFS=y
CONFIG_DEVTMPFS_MOUNT=y
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
CONFIG_REGMAP=y
CONFIG_REGMAP_I2C=y
CONFIG_REGMAP_MMIO=y
CONFIG_REGMAP_IRQ=y
CONFIG_DMA_SHARED_BUFFER=y
# CONFIG_DMA_CMA is not set

#
# Bus devices
#
CONFIG_CONNECTOR=m
CONFIG_MTD=y
# CONFIG_MTD_TESTS is not set
CONFIG_MTD_REDBOOT_PARTS=m
CONFIG_MTD_REDBOOT_DIRECTORY_BLOCK=-1
# CONFIG_MTD_REDBOOT_PARTS_UNALLOCATED is not set
# CONFIG_MTD_REDBOOT_PARTS_READONLY is not set
CONFIG_MTD_CMDLINE_PARTS=m
CONFIG_MTD_AR7_PARTS=m

#
# User Modules And Translation Layers
#
# CONFIG_MTD_OOPS is not set

#
# RAM/ROM/Flash chip drivers
#
# CONFIG_MTD_CFI is not set
CONFIG_MTD_JEDECPROBE=m
CONFIG_MTD_GEN_PROBE=m
CONFIG_MTD_CFI_ADV_OPTIONS=y
CONFIG_MTD_CFI_NOSWAP=y
# CONFIG_MTD_CFI_BE_BYTE_SWAP is not set
# CONFIG_MTD_CFI_LE_BYTE_SWAP is not set
CONFIG_MTD_CFI_GEOMETRY=y
# CONFIG_MTD_MAP_BANK_WIDTH_1 is not set
# CONFIG_MTD_MAP_BANK_WIDTH_2 is not set
CONFIG_MTD_MAP_BANK_WIDTH_4=y
# CONFIG_MTD_MAP_BANK_WIDTH_8 is not set
# CONFIG_MTD_MAP_BANK_WIDTH_16 is not set
CONFIG_MTD_MAP_BANK_WIDTH_32=y
CONFIG_MTD_CFI_I1=y
# CONFIG_MTD_CFI_I2 is not set
# CONFIG_MTD_CFI_I4 is not set
# CONFIG_MTD_CFI_I8 is not set
# CONFIG_MTD_OTP is not set
CONFIG_MTD_CFI_INTELEXT=m
CONFIG_MTD_CFI_AMDSTD=m
CONFIG_MTD_CFI_STAA=m
CONFIG_MTD_CFI_UTIL=m
CONFIG_MTD_RAM=y
# CONFIG_MTD_ROM is not set
CONFIG_MTD_ABSENT=m

#
# Mapping drivers for chip access
#
# CONFIG_MTD_COMPLEX_MAPPINGS is not set
CONFIG_MTD_PHYSMAP=m
CONFIG_MTD_PHYSMAP_COMPAT=y
CONFIG_MTD_PHYSMAP_START=0x8000000
CONFIG_MTD_PHYSMAP_LEN=0
CONFIG_MTD_PHYSMAP_BANKWIDTH=2
# CONFIG_MTD_AMD76XROM is not set
# CONFIG_MTD_ICHXROM is not set
# CONFIG_MTD_ESB2ROM is not set
# CONFIG_MTD_CK804XROM is not set
# CONFIG_MTD_SCB2_FLASH is not set
# CONFIG_MTD_NETtel is not set
# CONFIG_MTD_L440GX is not set
# CONFIG_MTD_INTEL_VR_NOR is not set
CONFIG_MTD_PLATRAM=m

#
# Self-contained MTD device drivers
#
# CONFIG_MTD_PMC551 is not set
CONFIG_MTD_SLRAM=m
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
CONFIG_MTD_ONENAND_VERIFY_WRITE=y
# CONFIG_MTD_ONENAND_GENERIC is not set
CONFIG_MTD_ONENAND_OTP=y
CONFIG_MTD_ONENAND_2X_PROGRAM=y

#
# LPDDR flash memory drivers
#
# CONFIG_MTD_LPDDR is not set
# CONFIG_MTD_UBI is not set
CONFIG_PARPORT=y
CONFIG_ARCH_MIGHT_HAVE_PC_PARPORT=y
# CONFIG_PARPORT_PC is not set
# CONFIG_PARPORT_GSC is not set
CONFIG_PARPORT_AX88796=m
CONFIG_PARPORT_1284=y
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
# CONFIG_SENSORS_LIS3LV02D is not set
# CONFIG_AD525X_DPOT is not set
CONFIG_DUMMY_IRQ=m
# CONFIG_IBM_ASM is not set
# CONFIG_PHANTOM is not set
# CONFIG_SGI_IOC4 is not set
# CONFIG_TIFM_CORE is not set
CONFIG_ICS932S401=y
CONFIG_ATMEL_SSC=y
CONFIG_ENCLOSURE_SERVICES=m
# CONFIG_HP_ILO is not set
# CONFIG_APDS9802ALS is not set
CONFIG_ISL29003=m
CONFIG_ISL29020=m
CONFIG_SENSORS_TSL2550=m
CONFIG_SENSORS_BH1780=y
CONFIG_SENSORS_BH1770=m
CONFIG_SENSORS_APDS990X=m
CONFIG_HMC6352=y
CONFIG_DS1682=y
# CONFIG_VMWARE_BALLOON is not set
CONFIG_BMP085=y
CONFIG_BMP085_I2C=m
# CONFIG_PCH_PHUB is not set
CONFIG_USB_SWITCH_FSA9480=y
# CONFIG_SRAM is not set
# CONFIG_C2PORT is not set

#
# EEPROM support
#
# CONFIG_EEPROM_AT24 is not set
CONFIG_EEPROM_LEGACY=y
CONFIG_EEPROM_MAX6875=y
# CONFIG_EEPROM_93CX6 is not set
# CONFIG_CB710_CORE is not set

#
# Texas Instruments shared transport line discipline
#
# CONFIG_SENSORS_LIS3_I2C is not set

#
# Altera FPGA firmware download module
#
CONFIG_ALTERA_STAPL=m
# CONFIG_INTEL_MEI is not set
# CONFIG_INTEL_MEI_ME is not set
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
CONFIG_MACINTOSH_DRIVERS=y
CONFIG_NETDEVICES=y
CONFIG_NET_CORE=y
CONFIG_BONDING=m
CONFIG_DUMMY=m
CONFIG_EQUALIZER=y
# CONFIG_NET_TEAM is not set
# CONFIG_MACVLAN is not set
CONFIG_VXLAN=m
# CONFIG_NETCONSOLE is not set
# CONFIG_NETPOLL is not set
# CONFIG_NET_POLL_CONTROLLER is not set
# CONFIG_TUN is not set
CONFIG_VETH=y
CONFIG_VIRTIO_NET=m
# CONFIG_NLMON is not set
CONFIG_ARCNET=m
CONFIG_ARCNET_1201=m
# CONFIG_ARCNET_1051 is not set
CONFIG_ARCNET_RAW=m
# CONFIG_ARCNET_CAP is not set
CONFIG_ARCNET_COM90xx=m
# CONFIG_ARCNET_COM90xxIO is not set
CONFIG_ARCNET_RIM_I=m
# CONFIG_ARCNET_COM20020 is not set

#
# CAIF transport drivers
#
CONFIG_VHOST_NET=y
CONFIG_VHOST_RING=y
CONFIG_VHOST=y

#
# Distributed Switch Architecture drivers
#
CONFIG_NET_DSA_MV88E6XXX=m
CONFIG_NET_DSA_MV88E6060=m
CONFIG_NET_DSA_MV88E6XXX_NEED_PPU=y
CONFIG_NET_DSA_MV88E6131=m
CONFIG_NET_DSA_MV88E6123_61_65=m
# CONFIG_ETHERNET is not set
# CONFIG_FDDI is not set
# CONFIG_HIPPI is not set
# CONFIG_NET_SB1000 is not set
CONFIG_PHYLIB=m

#
# MII PHY device drivers
#
# CONFIG_AT803X_PHY is not set
# CONFIG_AMD_PHY is not set
# CONFIG_MARVELL_PHY is not set
# CONFIG_DAVICOM_PHY is not set
# CONFIG_QSEMI_PHY is not set
CONFIG_LXT_PHY=m
# CONFIG_CICADA_PHY is not set
# CONFIG_VITESSE_PHY is not set
# CONFIG_SMSC_PHY is not set
CONFIG_BROADCOM_PHY=m
CONFIG_BCM7XXX_PHY=m
# CONFIG_BCM87XX_PHY is not set
CONFIG_ICPLUS_PHY=m
# CONFIG_REALTEK_PHY is not set
# CONFIG_NATIONAL_PHY is not set
CONFIG_STE10XP=m
CONFIG_LSI_ET1011C_PHY=m
# CONFIG_MICREL_PHY is not set
# CONFIG_MDIO_BITBANG is not set
CONFIG_PLIP=m
CONFIG_PPP=y
CONFIG_PPP_BSDCOMP=y
CONFIG_PPP_DEFLATE=y
CONFIG_PPP_FILTER=y
CONFIG_PPP_MPPE=y
# CONFIG_PPP_MULTILINK is not set
CONFIG_PPPOE=y
# CONFIG_PPPOL2TP is not set
CONFIG_PPP_ASYNC=y
CONFIG_PPP_SYNC_TTY=y
CONFIG_SLIP=y
CONFIG_SLHC=y
# CONFIG_SLIP_COMPRESSED is not set
# CONFIG_SLIP_SMART is not set
CONFIG_SLIP_MODE_SLIP6=y
CONFIG_WLAN=y
CONFIG_PCMCIA_RAYCS=m
CONFIG_LIBERTAS_THINFIRM=m
# CONFIG_LIBERTAS_THINFIRM_DEBUG is not set
# CONFIG_AIRO is not set
CONFIG_ATMEL=m
# CONFIG_PCI_ATMEL is not set
# CONFIG_PCMCIA_ATMEL is not set
CONFIG_AIRO_CS=m
CONFIG_PCMCIA_WL3501=m
# CONFIG_PRISM54 is not set
# CONFIG_RTL8180 is not set
# CONFIG_ADM8211 is not set
CONFIG_MAC80211_HWSIM=m
# CONFIG_MWL8K is not set
# CONFIG_ATH_CARDS is not set
# CONFIG_B43 is not set
# CONFIG_B43LEGACY is not set
# CONFIG_BRCMSMAC is not set
# CONFIG_BRCMFMAC is not set
# CONFIG_HOSTAP is not set
# CONFIG_IPW2100 is not set
# CONFIG_IWLWIFI is not set
# CONFIG_IWL4965 is not set
# CONFIG_IWL3945 is not set
# CONFIG_LIBERTAS is not set
# CONFIG_P54_COMMON is not set
# CONFIG_RT2X00 is not set
CONFIG_RTL_CARDS=m
# CONFIG_RTL8192CE is not set
# CONFIG_RTL8192SE is not set
# CONFIG_RTL8192DE is not set
# CONFIG_RTL8723AE is not set
# CONFIG_RTL8188EE is not set
# CONFIG_WL_TI is not set
CONFIG_MWIFIEX=m
CONFIG_MWIFIEX_SDIO=m
# CONFIG_MWIFIEX_PCIE is not set
CONFIG_CW1200=m
CONFIG_CW1200_WLAN_SDIO=m

#
# WiMAX Wireless Broadband devices
#

#
# Enable USB support to see WiMAX USB drivers
#
# CONFIG_WAN is not set
CONFIG_IEEE802154_DRIVERS=y
CONFIG_IEEE802154_FAKEHARD=m
# CONFIG_VMXNET3 is not set
CONFIG_ISDN=y
# CONFIG_ISDN_I4L is not set
CONFIG_ISDN_CAPI=y
CONFIG_ISDN_DRV_AVMB1_VERBOSE_REASON=y
CONFIG_CAPI_TRACE=y
# CONFIG_ISDN_CAPI_MIDDLEWARE is not set
CONFIG_ISDN_CAPI_CAPI20=y

#
# CAPI hardware drivers
#
CONFIG_CAPI_AVM=y
# CONFIG_ISDN_DRV_AVMB1_B1PCI is not set
CONFIG_ISDN_DRV_AVMB1_B1PCMCIA=m
CONFIG_ISDN_DRV_AVMB1_AVM_CS=m
# CONFIG_ISDN_DRV_AVMB1_T1PCI is not set
# CONFIG_ISDN_DRV_AVMB1_C4 is not set
# CONFIG_CAPI_EICON is not set
CONFIG_ISDN_DRV_GIGASET=m
# CONFIG_GIGASET_CAPI is not set
CONFIG_GIGASET_DUMMYLL=y
CONFIG_GIGASET_M101=m
# CONFIG_GIGASET_DEBUG is not set
# CONFIG_MISDN is not set

#
# Input device support
#
CONFIG_INPUT=y
CONFIG_INPUT_FF_MEMLESS=m
CONFIG_INPUT_POLLDEV=m
CONFIG_INPUT_SPARSEKMAP=m
# CONFIG_INPUT_MATRIXKMAP is not set

#
# Userland interfaces
#
# CONFIG_INPUT_MOUSEDEV is not set
# CONFIG_INPUT_JOYDEV is not set
# CONFIG_INPUT_EVDEV is not set
CONFIG_INPUT_EVBUG=m

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
# CONFIG_KEYBOARD_TCA6416 is not set
# CONFIG_KEYBOARD_TCA8418 is not set
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
# CONFIG_KEYBOARD_CROS_EC is not set
# CONFIG_INPUT_MOUSE is not set
CONFIG_INPUT_JOYSTICK=y
# CONFIG_JOYSTICK_ANALOG is not set
CONFIG_JOYSTICK_A3D=m
CONFIG_JOYSTICK_ADI=m
CONFIG_JOYSTICK_COBRA=m
CONFIG_JOYSTICK_GF2K=m
# CONFIG_JOYSTICK_GRIP is not set
# CONFIG_JOYSTICK_GRIP_MP is not set
CONFIG_JOYSTICK_GUILLEMOT=m
CONFIG_JOYSTICK_INTERACT=m
CONFIG_JOYSTICK_SIDEWINDER=m
CONFIG_JOYSTICK_TMDC=m
# CONFIG_JOYSTICK_IFORCE is not set
CONFIG_JOYSTICK_WARRIOR=m
# CONFIG_JOYSTICK_MAGELLAN is not set
CONFIG_JOYSTICK_SPACEORB=m
CONFIG_JOYSTICK_SPACEBALL=m
CONFIG_JOYSTICK_STINGER=m
CONFIG_JOYSTICK_TWIDJOY=m
CONFIG_JOYSTICK_ZHENHUA=m
CONFIG_JOYSTICK_DB9=m
CONFIG_JOYSTICK_GAMECON=m
CONFIG_JOYSTICK_TURBOGRAFX=m
# CONFIG_JOYSTICK_AS5011 is not set
CONFIG_JOYSTICK_JOYDUMP=m
# CONFIG_JOYSTICK_XPAD is not set
# CONFIG_JOYSTICK_WALKERA0701 is not set
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
# CONFIG_SERIO_PARKBD is not set
# CONFIG_SERIO_PCIPS2 is not set
CONFIG_SERIO_LIBPS2=y
CONFIG_SERIO_RAW=m
# CONFIG_SERIO_ALTERA_PS2 is not set
CONFIG_SERIO_PS2MULT=y
CONFIG_SERIO_ARC_PS2=m
CONFIG_GAMEPORT=m
CONFIG_GAMEPORT_NS558=m
# CONFIG_GAMEPORT_L4 is not set
# CONFIG_GAMEPORT_EMU10K1 is not set
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
# CONFIG_ROCKETPORT is not set
# CONFIG_CYCLADES is not set
# CONFIG_MOXA_INTELLIO is not set
# CONFIG_MOXA_SMARTIO is not set
# CONFIG_SYNCLINK is not set
# CONFIG_SYNCLINKMP is not set
# CONFIG_SYNCLINK_GT is not set
# CONFIG_NOZOMI is not set
# CONFIG_ISI is not set
# CONFIG_N_HDLC is not set
# CONFIG_N_GSM is not set
# CONFIG_TRACE_SINK is not set
CONFIG_GOLDFISH_TTY=m
# CONFIG_DEVKMEM is not set

#
# Serial drivers
#
CONFIG_SERIAL_8250=y
CONFIG_SERIAL_8250_DEPRECATED_OPTIONS=y
CONFIG_SERIAL_8250_PNP=y
CONFIG_SERIAL_8250_CONSOLE=y
CONFIG_FIX_EARLYCON_MEM=y
# CONFIG_SERIAL_8250_DMA is not set
CONFIG_SERIAL_8250_PCI=y
CONFIG_SERIAL_8250_CS=m
CONFIG_SERIAL_8250_NR_UARTS=4
CONFIG_SERIAL_8250_RUNTIME_UARTS=4
CONFIG_SERIAL_8250_EXTENDED=y
# CONFIG_SERIAL_8250_MANY_PORTS is not set
# CONFIG_SERIAL_8250_SHARE_IRQ is not set
CONFIG_SERIAL_8250_DETECT_IRQ=y
# CONFIG_SERIAL_8250_RSA is not set
# CONFIG_SERIAL_8250_DW is not set

#
# Non-8250 serial port support
#
# CONFIG_SERIAL_MFD_HSU is not set
CONFIG_SERIAL_CORE=y
CONFIG_SERIAL_CORE_CONSOLE=y
# CONFIG_SERIAL_JSM is not set
# CONFIG_SERIAL_SCCNXP is not set
CONFIG_SERIAL_TIMBERDALE=y
CONFIG_SERIAL_ALTERA_JTAGUART=y
# CONFIG_SERIAL_ALTERA_JTAGUART_CONSOLE is not set
CONFIG_SERIAL_ALTERA_UART=y
CONFIG_SERIAL_ALTERA_UART_MAXPORTS=4
CONFIG_SERIAL_ALTERA_UART_BAUDRATE=115200
# CONFIG_SERIAL_ALTERA_UART_CONSOLE is not set
# CONFIG_SERIAL_PCH_UART is not set
# CONFIG_SERIAL_ARC is not set
# CONFIG_SERIAL_RP2 is not set
# CONFIG_SERIAL_FSL_LPUART is not set
# CONFIG_TTY_PRINTK is not set
# CONFIG_PRINTER is not set
# CONFIG_PPDEV is not set
CONFIG_HVC_DRIVER=y
CONFIG_VIRTIO_CONSOLE=y
# CONFIG_IPMI_HANDLER is not set
CONFIG_HW_RANDOM=y
# CONFIG_HW_RANDOM_TIMERIOMEM is not set
CONFIG_HW_RANDOM_INTEL=y
CONFIG_HW_RANDOM_AMD=y
CONFIG_HW_RANDOM_GEODE=y
# CONFIG_HW_RANDOM_VIA is not set
CONFIG_HW_RANDOM_VIRTIO=m
# CONFIG_HW_RANDOM_TPM is not set
# CONFIG_NVRAM is not set
CONFIG_R3964=y
# CONFIG_APPLICOM is not set
# CONFIG_SONYPI is not set

#
# PCMCIA character devices
#
CONFIG_SYNCLINK_CS=m
CONFIG_CARDMAN_4000=m
CONFIG_CARDMAN_4040=m
CONFIG_IPWIRELESS=m
CONFIG_MWAVE=y
CONFIG_SCx200_GPIO=m
# CONFIG_PC8736x_GPIO is not set
CONFIG_NSC_GPIO=m
# CONFIG_HPET is not set
CONFIG_HANGCHECK_TIMER=m
CONFIG_TCG_TPM=y
# CONFIG_TCG_TIS is not set
# CONFIG_TCG_TIS_I2C_ATMEL is not set
# CONFIG_TCG_TIS_I2C_INFINEON is not set
CONFIG_TCG_TIS_I2C_NUVOTON=m
# CONFIG_TCG_NSC is not set
CONFIG_TCG_ATMEL=y
# CONFIG_TCG_INFINEON is not set
# CONFIG_TELCLOCK is not set
CONFIG_DEVPORT=y
CONFIG_I2C=y
CONFIG_I2C_BOARDINFO=y
CONFIG_I2C_COMPAT=y
CONFIG_I2C_CHARDEV=m
CONFIG_I2C_MUX=y

#
# Multiplexer I2C Chip support
#
CONFIG_I2C_MUX_PCA9541=y
# CONFIG_I2C_MUX_PCA954x is not set
# CONFIG_I2C_HELPER_AUTO is not set
CONFIG_I2C_SMBUS=y

#
# I2C Algorithms
#
CONFIG_I2C_ALGOBIT=y
CONFIG_I2C_ALGOPCF=y
# CONFIG_I2C_ALGOPCA is not set

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
CONFIG_I2C_DESIGNWARE_CORE=m
CONFIG_I2C_DESIGNWARE_PLATFORM=m
# CONFIG_I2C_DESIGNWARE_PCI is not set
# CONFIG_I2C_EG20T is not set
# CONFIG_I2C_OCORES is not set
# CONFIG_I2C_PCA_PLATFORM is not set
# CONFIG_I2C_PXA_PCI is not set
CONFIG_I2C_SIMTEC=y
# CONFIG_I2C_XILINX is not set

#
# External I2C/SMBus adapter drivers
#
# CONFIG_I2C_PARPORT is not set
CONFIG_I2C_PARPORT_LIGHT=m
CONFIG_I2C_TAOS_EVM=y

#
# Other I2C/SMBus bus drivers
#
CONFIG_SCx200_I2C=m
CONFIG_SCx200_I2C_SCL=12
CONFIG_SCx200_I2C_SDA=13
# CONFIG_SCx200_ACB is not set
# CONFIG_I2C_STUB is not set
# CONFIG_I2C_DEBUG_CORE is not set
# CONFIG_I2C_DEBUG_ALGO is not set
# CONFIG_I2C_DEBUG_BUS is not set
# CONFIG_SPI is not set
CONFIG_HSI=m
CONFIG_HSI_BOARDINFO=y

#
# HSI clients
#
# CONFIG_HSI_CHAR is not set

#
# PPS support
#
CONFIG_PPS=m
# CONFIG_PPS_DEBUG is not set
# CONFIG_NTP_PPS is not set

#
# PPS clients support
#
CONFIG_PPS_CLIENT_KTIMER=m
CONFIG_PPS_CLIENT_LDISC=m
CONFIG_PPS_CLIENT_PARPORT=m
CONFIG_PPS_CLIENT_GPIO=m

#
# PPS generators support
#

#
# PTP clock support
#
CONFIG_PTP_1588_CLOCK=m

#
# Enable PHYLIB and NETWORK_PHY_TIMESTAMPING to see the additional clocks.
#
# CONFIG_PTP_1588_CLOCK_PCH is not set
CONFIG_ARCH_WANT_OPTIONAL_GPIOLIB=y
# CONFIG_GPIOLIB is not set
CONFIG_W1=y
# CONFIG_W1_CON is not set

#
# 1-wire Bus Masters
#
# CONFIG_W1_MASTER_MATROX is not set
CONFIG_W1_MASTER_DS2482=m
CONFIG_W1_MASTER_DS1WM=y

#
# 1-wire Slaves
#
CONFIG_W1_SLAVE_THERM=m
CONFIG_W1_SLAVE_SMEM=m
# CONFIG_W1_SLAVE_DS2408 is not set
# CONFIG_W1_SLAVE_DS2413 is not set
CONFIG_W1_SLAVE_DS2423=y
CONFIG_W1_SLAVE_DS2431=y
CONFIG_W1_SLAVE_DS2433=y
CONFIG_W1_SLAVE_DS2433_CRC=y
# CONFIG_W1_SLAVE_DS2760 is not set
CONFIG_W1_SLAVE_DS2780=m
# CONFIG_W1_SLAVE_DS2781 is not set
# CONFIG_W1_SLAVE_DS28E04 is not set
CONFIG_W1_SLAVE_BQ27000=m
CONFIG_POWER_SUPPLY=y
# CONFIG_POWER_SUPPLY_DEBUG is not set
# CONFIG_PDA_POWER is not set
# CONFIG_GENERIC_ADC_BATTERY is not set
# CONFIG_MAX8925_POWER is not set
# CONFIG_WM8350_POWER is not set
# CONFIG_TEST_POWER is not set
# CONFIG_BATTERY_88PM860X is not set
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
# CONFIG_CHARGER_LP8788 is not set
# CONFIG_CHARGER_MAX8997 is not set
# CONFIG_CHARGER_BQ2415X is not set
# CONFIG_CHARGER_SMB347 is not set
# CONFIG_CHARGER_TPS65090 is not set
# CONFIG_BATTERY_GOLDFISH is not set
# CONFIG_POWER_RESET is not set
CONFIG_POWER_AVS=y
# CONFIG_HWMON is not set
CONFIG_THERMAL=y
CONFIG_THERMAL_DEFAULT_GOV_STEP_WISE=y
# CONFIG_THERMAL_DEFAULT_GOV_FAIR_SHARE is not set
# CONFIG_THERMAL_DEFAULT_GOV_USER_SPACE is not set
CONFIG_THERMAL_GOV_FAIR_SHARE=y
CONFIG_THERMAL_GOV_STEP_WISE=y
# CONFIG_THERMAL_GOV_USER_SPACE is not set
CONFIG_THERMAL_EMULATION=y
# CONFIG_INTEL_POWERCLAMP is not set
# CONFIG_ACPI_INT3403_THERMAL is not set

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
CONFIG_DA9052_WATCHDOG=m
CONFIG_DA9055_WATCHDOG=m
# CONFIG_WM8350_WATCHDOG is not set
CONFIG_DW_WATCHDOG=m
CONFIG_ACQUIRE_WDT=y
# CONFIG_ADVANTECH_WDT is not set
# CONFIG_ALIM1535_WDT is not set
# CONFIG_ALIM7101_WDT is not set
CONFIG_F71808E_WDT=y
# CONFIG_SP5100_TCO is not set
CONFIG_SC520_WDT=m
CONFIG_SBC_FITPC2_WATCHDOG=m
# CONFIG_EUROTECH_WDT is not set
# CONFIG_IB700_WDT is not set
# CONFIG_IBMASR is not set
# CONFIG_WAFER_WDT is not set
# CONFIG_I6300ESB_WDT is not set
# CONFIG_IE6XX_WDT is not set
# CONFIG_ITCO_WDT is not set
# CONFIG_IT8712F_WDT is not set
# CONFIG_IT87_WDT is not set
# CONFIG_HP_WATCHDOG is not set
# CONFIG_SC1200_WDT is not set
# CONFIG_SCx200_WDT is not set
CONFIG_PC87413_WDT=y
# CONFIG_NV_TCO is not set
CONFIG_60XX_WDT=y
CONFIG_SBC8360_WDT=y
CONFIG_SBC7240_WDT=y
CONFIG_CPU5_WDT=m
CONFIG_SMSC_SCH311X_WDT=y
CONFIG_SMSC37B787_WDT=m
# CONFIG_VIA_WDT is not set
CONFIG_W83627HF_WDT=m
CONFIG_W83697HF_WDT=y
CONFIG_W83697UG_WDT=y
# CONFIG_W83877F_WDT is not set
CONFIG_W83977F_WDT=y
# CONFIG_MACHZ_WDT is not set
CONFIG_SBC_EPX_C3_WATCHDOG=y

#
# PCI-based Watchdog Cards
#
# CONFIG_PCIPCWATCHDOG is not set
# CONFIG_WDTPCI is not set
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
# CONFIG_SSB_PCMCIAHOST is not set
CONFIG_SSB_SDIOHOST_POSSIBLE=y
# CONFIG_SSB_SDIOHOST is not set
# CONFIG_SSB_SILENT is not set
CONFIG_SSB_DEBUG=y
CONFIG_SSB_DRIVER_PCICORE_POSSIBLE=y
# CONFIG_SSB_DRIVER_PCICORE is not set
CONFIG_BCMA_POSSIBLE=y

#
# Broadcom specific AMBA
#
CONFIG_BCMA=m
CONFIG_BCMA_HOST_PCI_POSSIBLE=y
CONFIG_BCMA_HOST_PCI=y
CONFIG_BCMA_HOST_SOC=y
CONFIG_BCMA_DRIVER_GMAC_CMN=y
CONFIG_BCMA_DEBUG=y

#
# Multifunction device drivers
#
CONFIG_MFD_CORE=y
# CONFIG_MFD_CS5535 is not set
# CONFIG_MFD_AS3711 is not set
# CONFIG_PMIC_ADP5520 is not set
CONFIG_MFD_CROS_EC=y
CONFIG_MFD_CROS_EC_I2C=y
CONFIG_PMIC_DA903X=y
CONFIG_PMIC_DA9052=y
CONFIG_MFD_DA9052_I2C=y
CONFIG_MFD_DA9055=y
CONFIG_MFD_DA9063=y
# CONFIG_MFD_MC13XXX_I2C is not set
CONFIG_HTC_PASIC3=m
# CONFIG_LPC_ICH is not set
# CONFIG_LPC_SCH is not set
# CONFIG_MFD_JANZ_CMODIO is not set
# CONFIG_MFD_KEMPLD is not set
# CONFIG_MFD_88PM800 is not set
CONFIG_MFD_88PM805=m
CONFIG_MFD_88PM860X=y
# CONFIG_MFD_MAX14577 is not set
# CONFIG_MFD_MAX77686 is not set
CONFIG_MFD_MAX77693=y
# CONFIG_MFD_MAX8907 is not set
CONFIG_MFD_MAX8925=y
CONFIG_MFD_MAX8997=y
# CONFIG_MFD_MAX8998 is not set
# CONFIG_MFD_RETU is not set
CONFIG_MFD_PCF50633=y
CONFIG_PCF50633_ADC=y
# CONFIG_PCF50633_GPIO is not set
# CONFIG_MFD_RDC321X is not set
# CONFIG_MFD_RTSX_PCI is not set
# CONFIG_MFD_RC5T583 is not set
# CONFIG_MFD_SEC_CORE is not set
# CONFIG_MFD_SI476X_CORE is not set
CONFIG_MFD_SM501=m
# CONFIG_MFD_SMSC is not set
# CONFIG_ABX500_CORE is not set
CONFIG_MFD_STMPE=y

#
# STMicroelectronics STMPE Interface Drivers
#
# CONFIG_STMPE_I2C is not set
CONFIG_MFD_SYSCON=y
# CONFIG_MFD_TI_AM335X_TSCADC is not set
CONFIG_MFD_LP3943=m
CONFIG_MFD_LP8788=y
CONFIG_MFD_PALMAS=y
CONFIG_TPS6105X=y
# CONFIG_TPS6507X is not set
CONFIG_MFD_TPS65090=y
# CONFIG_MFD_TPS65217 is not set
# CONFIG_MFD_TPS6586X is not set
# CONFIG_MFD_TPS80031 is not set
# CONFIG_TWL4030_CORE is not set
CONFIG_TWL6040_CORE=y
CONFIG_MFD_WL1273_CORE=y
CONFIG_MFD_LM3533=y
# CONFIG_MFD_TC3589X is not set
# CONFIG_MFD_TMIO is not set
# CONFIG_MFD_VX855 is not set
# CONFIG_MFD_ARIZONA_I2C is not set
CONFIG_MFD_WM8400=y
# CONFIG_MFD_WM831X_I2C is not set
CONFIG_MFD_WM8350=y
CONFIG_MFD_WM8350_I2C=y
CONFIG_MFD_WM8994=y
CONFIG_REGULATOR=y
# CONFIG_REGULATOR_DEBUG is not set
CONFIG_REGULATOR_FIXED_VOLTAGE=y
CONFIG_REGULATOR_VIRTUAL_CONSUMER=y
CONFIG_REGULATOR_USERSPACE_CONSUMER=m
CONFIG_REGULATOR_88PM8607=y
# CONFIG_REGULATOR_ACT8865 is not set
# CONFIG_REGULATOR_AD5398 is not set
CONFIG_REGULATOR_ANATOP=y
CONFIG_REGULATOR_DA903X=m
# CONFIG_REGULATOR_DA9052 is not set
CONFIG_REGULATOR_DA9055=m
CONFIG_REGULATOR_DA9063=m
CONFIG_REGULATOR_DA9210=y
# CONFIG_REGULATOR_FAN53555 is not set
CONFIG_REGULATOR_ISL6271A=m
CONFIG_REGULATOR_LP3971=m
# CONFIG_REGULATOR_LP3972 is not set
CONFIG_REGULATOR_LP872X=y
# CONFIG_REGULATOR_LP8755 is not set
# CONFIG_REGULATOR_LP8788 is not set
CONFIG_REGULATOR_MAX1586=m
CONFIG_REGULATOR_MAX8649=m
# CONFIG_REGULATOR_MAX8660 is not set
# CONFIG_REGULATOR_MAX8925 is not set
# CONFIG_REGULATOR_MAX8952 is not set
# CONFIG_REGULATOR_MAX8973 is not set
CONFIG_REGULATOR_MAX8997=y
# CONFIG_REGULATOR_MAX77693 is not set
CONFIG_REGULATOR_PALMAS=m
CONFIG_REGULATOR_PCF50633=m
# CONFIG_REGULATOR_PFUZE100 is not set
CONFIG_REGULATOR_TPS51632=m
CONFIG_REGULATOR_TPS6105X=m
# CONFIG_REGULATOR_TPS62360 is not set
# CONFIG_REGULATOR_TPS65023 is not set
CONFIG_REGULATOR_TPS6507X=y
# CONFIG_REGULATOR_TPS65090 is not set
CONFIG_REGULATOR_WM8350=y
# CONFIG_REGULATOR_WM8400 is not set
# CONFIG_REGULATOR_WM8994 is not set
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
# CONFIG_DRM_GMA500 is not set
# CONFIG_DRM_UDL is not set
# CONFIG_DRM_AST is not set
# CONFIG_DRM_MGAG200 is not set
# CONFIG_DRM_CIRRUS_QEMU is not set
# CONFIG_DRM_QXL is not set
# CONFIG_DRM_BOCHS is not set
# CONFIG_VGASTATE is not set
# CONFIG_VIDEO_OUTPUT_CONTROL is not set
CONFIG_HDMI=y
# CONFIG_FB is not set
CONFIG_EXYNOS_VIDEO=y
# CONFIG_BACKLIGHT_LCD_SUPPORT is not set
# CONFIG_SOUND is not set

#
# HID support
#
CONFIG_HID=m
# CONFIG_HIDRAW is not set
# CONFIG_UHID is not set
# CONFIG_HID_GENERIC is not set

#
# Special HID drivers
#
CONFIG_HID_A4TECH=m
CONFIG_HID_ACRUX=m
CONFIG_HID_ACRUX_FF=y
CONFIG_HID_APPLE=m
CONFIG_HID_AUREAL=m
CONFIG_HID_BELKIN=m
# CONFIG_HID_CHERRY is not set
# CONFIG_HID_CHICONY is not set
CONFIG_HID_CYPRESS=m
# CONFIG_HID_DRAGONRISE is not set
CONFIG_HID_EMS_FF=m
CONFIG_HID_ELECOM=m
# CONFIG_HID_EZKEY is not set
CONFIG_HID_KEYTOUCH=m
CONFIG_HID_KYE=m
CONFIG_HID_UCLOGIC=m
CONFIG_HID_WALTOP=m
# CONFIG_HID_GYRATION is not set
CONFIG_HID_ICADE=m
CONFIG_HID_TWINHAN=m
CONFIG_HID_KENSINGTON=m
CONFIG_HID_LCPOWER=m
# CONFIG_HID_LENOVO_TPKBD is not set
# CONFIG_HID_LOGITECH is not set
# CONFIG_HID_MAGICMOUSE is not set
CONFIG_HID_MICROSOFT=m
CONFIG_HID_MONTEREY=m
CONFIG_HID_MULTITOUCH=m
CONFIG_HID_ORTEK=m
# CONFIG_HID_PANTHERLORD is not set
CONFIG_HID_PETALYNX=m
CONFIG_HID_PICOLCD=m
CONFIG_HID_PRIMAX=m
CONFIG_HID_SAITEK=m
# CONFIG_HID_SAMSUNG is not set
CONFIG_HID_SPEEDLINK=m
# CONFIG_HID_STEELSERIES is not set
# CONFIG_HID_SUNPLUS is not set
# CONFIG_HID_GREENASIA is not set
# CONFIG_HID_SMARTJOYPLUS is not set
CONFIG_HID_TIVO=m
CONFIG_HID_TOPSEED=m
# CONFIG_HID_THRUSTMASTER is not set
# CONFIG_HID_XINMO is not set
# CONFIG_HID_ZEROPLUS is not set
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
# CONFIG_USB_GADGET is not set
# CONFIG_UWB is not set
CONFIG_MMC=y
CONFIG_MMC_DEBUG=y
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
# CONFIG_MMC_SDHCI is not set
CONFIG_MMC_WBSD=y
# CONFIG_MMC_TIFM_SD is not set
CONFIG_MMC_GOLDFISH=y
# CONFIG_MMC_SDRICOH_CS is not set
# CONFIG_MMC_CB710 is not set
# CONFIG_MMC_VIA_SDMMC is not set
CONFIG_MEMSTICK=y
CONFIG_MEMSTICK_DEBUG=y

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
# CONFIG_NEW_LEDS is not set
CONFIG_ACCESSIBILITY=y
# CONFIG_INFINIBAND is not set
CONFIG_EDAC=y
CONFIG_EDAC_LEGACY_SYSFS=y
# CONFIG_EDAC_DEBUG is not set
# CONFIG_EDAC_MM_EDAC is not set
CONFIG_RTC_LIB=y
# CONFIG_RTC_CLASS is not set
CONFIG_DMADEVICES=y
# CONFIG_DMADEVICES_DEBUG is not set

#
# DMA Devices
#
# CONFIG_INTEL_MID_DMAC is not set
# CONFIG_INTEL_IOATDMA is not set
CONFIG_DW_DMAC_CORE=y
CONFIG_DW_DMAC=y
# CONFIG_DW_DMAC_PCI is not set
CONFIG_TIMB_DMA=m
# CONFIG_PCH_DMA is not set
CONFIG_DMA_ENGINE=y
CONFIG_DMA_ACPI=y

#
# DMA Clients
#
CONFIG_ASYNC_TX_DMA=y
# CONFIG_DMATEST is not set
# CONFIG_AUXDISPLAY is not set
# CONFIG_UIO is not set
# CONFIG_VIRT_DRIVERS is not set
CONFIG_VIRTIO=y

#
# Virtio drivers
#
# CONFIG_VIRTIO_PCI is not set
CONFIG_VIRTIO_BALLOON=m
# CONFIG_VIRTIO_MMIO is not set

#
# Microsoft Hyper-V guest support
#
# CONFIG_STAGING is not set
# CONFIG_X86_PLATFORM_DEVICES is not set
CONFIG_GOLDFISH_PIPE=m
# CONFIG_CHROME_PLATFORMS is not set

#
# Hardware Spinlock drivers
#
CONFIG_CLKSRC_I8253=y
CONFIG_CLKEVT_I8253=y
CONFIG_I8253_LOCK=y
CONFIG_CLKBLD_I8253=y
CONFIG_MAILBOX=y
# CONFIG_IOMMU_SUPPORT is not set

#
# Remoteproc drivers
#
CONFIG_REMOTEPROC=m
CONFIG_STE_MODEM_RPROC=m

#
# Rpmsg drivers
#
# CONFIG_PM_DEVFREQ is not set
# CONFIG_EXTCON is not set
CONFIG_MEMORY=y
CONFIG_IIO=m
CONFIG_IIO_BUFFER=y
# CONFIG_IIO_BUFFER_CB is not set
CONFIG_IIO_KFIFO_BUF=m
CONFIG_IIO_TRIGGERED_BUFFER=m
CONFIG_IIO_TRIGGER=y
CONFIG_IIO_CONSUMERS_PER_TRIGGER=2

#
# Accelerometers
#
CONFIG_BMA180=m
# CONFIG_HID_SENSOR_ACCEL_3D is not set
# CONFIG_IIO_ST_ACCEL_3AXIS is not set

#
# Analog to digital converters
#
CONFIG_LP8788_ADC=y
CONFIG_MAX1363=m
CONFIG_MCP3422=m
CONFIG_NAU7802=m
CONFIG_TI_ADC081C=m

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
# CONFIG_IIO_ST_GYRO_3AXIS is not set
# CONFIG_ITG3200 is not set

#
# Humidity sensors
#

#
# Inertial measurement units
#
CONFIG_INV_MPU6050_IIO=m

#
# Light sensors
#
CONFIG_ADJD_S311=m
# CONFIG_APDS9300 is not set
CONFIG_CM32181=m
CONFIG_CM36651=m
CONFIG_GP2AP020A00F=m
CONFIG_HID_SENSOR_ALS=m
CONFIG_SENSORS_LM3533=m
CONFIG_TCS3472=m
CONFIG_SENSORS_TSL2563=m
CONFIG_TSL4531=m
# CONFIG_VCNL4000 is not set

#
# Magnetometer sensors
#
# CONFIG_MAG3110 is not set
# CONFIG_HID_SENSOR_MAGNETOMETER_3D is not set
CONFIG_IIO_ST_MAGN_3AXIS=m
CONFIG_IIO_ST_MAGN_I2C_3AXIS=m

#
# Inclinometer sensors
#
CONFIG_HID_SENSOR_INCLINOMETER_3D=m

#
# Triggers - standalone
#
CONFIG_IIO_INTERRUPT_TRIGGER=m
CONFIG_IIO_SYSFS_TRIGGER=m

#
# Pressure sensors
#
# CONFIG_MPL3115 is not set
CONFIG_IIO_ST_PRESS=m
CONFIG_IIO_ST_PRESS_I2C=m

#
# Temperature sensors
#
# CONFIG_TMP006 is not set
# CONFIG_NTB is not set
# CONFIG_VME_BUS is not set
CONFIG_PWM=y
CONFIG_PWM_SYSFS=y
CONFIG_PWM_LP3943=m
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
# CONFIG_EDD is not set
CONFIG_FIRMWARE_MEMMAP=y
CONFIG_DELL_RBU=m
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
CONFIG_FSNOTIFY=y
# CONFIG_DNOTIFY is not set
CONFIG_INOTIFY_USER=y
# CONFIG_FANOTIFY is not set
# CONFIG_QUOTA is not set
# CONFIG_QUOTACTL is not set
CONFIG_AUTOFS4_FS=m
# CONFIG_FUSE_FS is not set

#
# Caches
#
CONFIG_FSCACHE=m
# CONFIG_FSCACHE_DEBUG is not set

#
# Pseudo filesystems
#
# CONFIG_PROC_FS is not set
CONFIG_SYSFS=y
# CONFIG_HUGETLBFS is not set
# CONFIG_HUGETLB_PAGE is not set
CONFIG_CONFIGFS_FS=m
CONFIG_MISC_FILESYSTEMS=y
CONFIG_ECRYPT_FS=m
# CONFIG_ECRYPT_FS_MESSAGING is not set
CONFIG_JFFS2_FS=y
CONFIG_JFFS2_FS_DEBUG=0
CONFIG_JFFS2_FS_WRITEBUFFER=y
# CONFIG_JFFS2_FS_WBUF_VERIFY is not set
# CONFIG_JFFS2_SUMMARY is not set
CONFIG_JFFS2_FS_XATTR=y
# CONFIG_JFFS2_FS_POSIX_ACL is not set
CONFIG_JFFS2_FS_SECURITY=y
# CONFIG_JFFS2_COMPRESSION_OPTIONS is not set
CONFIG_JFFS2_ZLIB=y
# CONFIG_JFFS2_LZO is not set
CONFIG_JFFS2_RTIME=y
# CONFIG_JFFS2_RUBIN is not set
# CONFIG_LOGFS is not set
# CONFIG_ROMFS_FS is not set
# CONFIG_PSTORE is not set
# CONFIG_NETWORK_FILESYSTEMS is not set
CONFIG_NLS=y
CONFIG_NLS_DEFAULT="iso8859-1"
# CONFIG_NLS_CODEPAGE_437 is not set
# CONFIG_NLS_CODEPAGE_737 is not set
# CONFIG_NLS_CODEPAGE_775 is not set
# CONFIG_NLS_CODEPAGE_850 is not set
CONFIG_NLS_CODEPAGE_852=m
CONFIG_NLS_CODEPAGE_855=y
CONFIG_NLS_CODEPAGE_857=m
# CONFIG_NLS_CODEPAGE_860 is not set
CONFIG_NLS_CODEPAGE_861=y
CONFIG_NLS_CODEPAGE_862=m
# CONFIG_NLS_CODEPAGE_863 is not set
CONFIG_NLS_CODEPAGE_864=m
CONFIG_NLS_CODEPAGE_865=m
CONFIG_NLS_CODEPAGE_866=y
CONFIG_NLS_CODEPAGE_869=y
CONFIG_NLS_CODEPAGE_936=m
# CONFIG_NLS_CODEPAGE_950 is not set
CONFIG_NLS_CODEPAGE_932=y
CONFIG_NLS_CODEPAGE_949=y
CONFIG_NLS_CODEPAGE_874=y
CONFIG_NLS_ISO8859_8=m
CONFIG_NLS_CODEPAGE_1250=m
CONFIG_NLS_CODEPAGE_1251=m
CONFIG_NLS_ASCII=y
CONFIG_NLS_ISO8859_1=m
# CONFIG_NLS_ISO8859_2 is not set
CONFIG_NLS_ISO8859_3=m
CONFIG_NLS_ISO8859_4=y
# CONFIG_NLS_ISO8859_5 is not set
# CONFIG_NLS_ISO8859_6 is not set
CONFIG_NLS_ISO8859_7=m
CONFIG_NLS_ISO8859_9=y
CONFIG_NLS_ISO8859_13=m
CONFIG_NLS_ISO8859_14=m
CONFIG_NLS_ISO8859_15=y
# CONFIG_NLS_KOI8_R is not set
# CONFIG_NLS_KOI8_U is not set
# CONFIG_NLS_MAC_ROMAN is not set
CONFIG_NLS_MAC_CELTIC=m
CONFIG_NLS_MAC_CENTEURO=y
CONFIG_NLS_MAC_CROATIAN=y
CONFIG_NLS_MAC_CYRILLIC=y
CONFIG_NLS_MAC_GAELIC=m
# CONFIG_NLS_MAC_GREEK is not set
CONFIG_NLS_MAC_ICELAND=y
# CONFIG_NLS_MAC_INUIT is not set
CONFIG_NLS_MAC_ROMANIAN=m
CONFIG_NLS_MAC_TURKISH=y
CONFIG_NLS_UTF8=y
CONFIG_DLM=m
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
CONFIG_DYNAMIC_DEBUG=y

#
# Compile-time checks and compiler options
#
# CONFIG_DEBUG_INFO is not set
# CONFIG_ENABLE_WARN_DEPRECATED is not set
# CONFIG_ENABLE_MUST_CHECK is not set
CONFIG_FRAME_WARN=1024
# CONFIG_STRIP_ASM_SYMS is not set
CONFIG_READABLE_ASM=y
CONFIG_UNUSED_SYMBOLS=y
CONFIG_DEBUG_FS=y
CONFIG_HEADERS_CHECK=y
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
CONFIG_HAVE_DEBUG_KMEMLEAK=y
# CONFIG_DEBUG_KMEMLEAK is not set
# CONFIG_DEBUG_STACK_USAGE is not set
# CONFIG_DEBUG_VM is not set
CONFIG_DEBUG_VIRTUAL=y
# CONFIG_DEBUG_MEMORY_INIT is not set
CONFIG_HAVE_DEBUG_STACKOVERFLOW=y
# CONFIG_DEBUG_STACKOVERFLOW is not set
CONFIG_HAVE_ARCH_KMEMCHECK=y
CONFIG_DEBUG_SHIRQ=y

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
# CONFIG_DEBUG_LOCKDEP is not set
CONFIG_DEBUG_ATOMIC_SLEEP=y
CONFIG_DEBUG_LOCKING_API_SELFTESTS=y
CONFIG_LOCK_TORTURE_TEST=y
CONFIG_STACKTRACE=y
# CONFIG_DEBUG_KOBJECT is not set
CONFIG_DEBUG_BUGVERBOSE=y
# CONFIG_DEBUG_WRITECOUNT is not set
CONFIG_DEBUG_LIST=y
CONFIG_DEBUG_SG=y
# CONFIG_DEBUG_NOTIFIERS is not set
# CONFIG_DEBUG_CREDENTIALS is not set

#
# RCU Debugging
#
CONFIG_SPARSE_RCU_POINTER=y
CONFIG_TORTURE_TEST=y
# CONFIG_RCU_TORTURE_TEST is not set
# CONFIG_RCU_TRACE is not set
CONFIG_NOTIFIER_ERROR_INJECTION=m
CONFIG_PM_NOTIFIER_ERROR_INJECT=m
CONFIG_FAULT_INJECTION=y
CONFIG_FAIL_PAGE_ALLOC=y
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
CONFIG_SCHED_TRACER=y
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
# CONFIG_UPROBE_EVENT is not set
# CONFIG_PROBE_EVENTS is not set
# CONFIG_FTRACE_STARTUP_TEST is not set
# CONFIG_MMIOTRACE is not set
CONFIG_RING_BUFFER_BENCHMARK=y
# CONFIG_RING_BUFFER_STARTUP_TEST is not set

#
# Runtime Testing
#
CONFIG_TEST_LIST_SORT=y
# CONFIG_BACKTRACE_SELF_TEST is not set
CONFIG_RBTREE_TEST=y
CONFIG_INTERVAL_TREE_TEST=m
CONFIG_PERCPU_TEST=m
# CONFIG_ATOMIC64_SELFTEST is not set
CONFIG_TEST_STRING_HELPERS=y
# CONFIG_TEST_KSTRTOX is not set
# CONFIG_PROVIDE_OHCI1394_DMA_INIT is not set
# CONFIG_BUILD_DOCSRC is not set
# CONFIG_DMA_API_DEBUG is not set
# CONFIG_TEST_MODULE is not set
# CONFIG_TEST_USER_COPY is not set
# CONFIG_SAMPLES is not set
CONFIG_HAVE_ARCH_KGDB=y
# CONFIG_KGDB is not set
# CONFIG_STRICT_DEVMEM is not set
CONFIG_X86_VERBOSE_BOOTUP=y
# CONFIG_EARLY_PRINTK is not set
CONFIG_X86_PTDUMP=y
# CONFIG_DEBUG_RODATA is not set
CONFIG_DEBUG_SET_MODULE_RONX=y
CONFIG_DEBUG_NX_TEST=m
CONFIG_DOUBLEFAULT=y
# CONFIG_DEBUG_TLBFLUSH is not set
CONFIG_IOMMU_STRESS=y
CONFIG_HAVE_MMIOTRACE_SUPPORT=y
CONFIG_IO_DELAY_TYPE_0X80=0
CONFIG_IO_DELAY_TYPE_0XED=1
CONFIG_IO_DELAY_TYPE_UDELAY=2
CONFIG_IO_DELAY_TYPE_NONE=3
CONFIG_IO_DELAY_0X80=y
# CONFIG_IO_DELAY_0XED is not set
# CONFIG_IO_DELAY_UDELAY is not set
# CONFIG_IO_DELAY_NONE is not set
CONFIG_DEFAULT_IO_DELAY_TYPE=0
CONFIG_DEBUG_BOOT_PARAMS=y
# CONFIG_CPA_DEBUG is not set
# CONFIG_OPTIMIZE_INLINING is not set
# CONFIG_X86_DEBUG_STATIC_CPU_HAS is not set

#
# Security options
#
CONFIG_KEYS=y
CONFIG_PERSISTENT_KEYRINGS=y
CONFIG_TRUSTED_KEYS=y
CONFIG_ENCRYPTED_KEYS=m
CONFIG_KEYS_DEBUG_PROC_KEYS=y
# CONFIG_SECURITY_DMESG_RESTRICT is not set
# CONFIG_SECURITY is not set
CONFIG_SECURITYFS=y
CONFIG_EVM_HMAC_ATTRS="fsuuid"
CONFIG_EVM_HMAC_XATTRS="security.selinux security.SMACK64 security.ima security.capability"
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
CONFIG_CRYPTO_USER=y
CONFIG_CRYPTO_MANAGER_DISABLE_TESTS=y
CONFIG_CRYPTO_GF128MUL=y
CONFIG_CRYPTO_NULL=y
CONFIG_CRYPTO_WORKQUEUE=y
CONFIG_CRYPTO_CRYPTD=y
CONFIG_CRYPTO_AUTHENC=y
CONFIG_CRYPTO_TEST=m
CONFIG_CRYPTO_ABLK_HELPER=m
CONFIG_CRYPTO_GLUE_HELPER_X86=m

#
# Authenticated Encryption with Associated Data
#
CONFIG_CRYPTO_CCM=m
CONFIG_CRYPTO_GCM=y
CONFIG_CRYPTO_SEQIV=y

#
# Block modes
#
CONFIG_CRYPTO_CBC=y
CONFIG_CRYPTO_CTR=y
CONFIG_CRYPTO_CTS=y
CONFIG_CRYPTO_ECB=y
CONFIG_CRYPTO_LRW=m
# CONFIG_CRYPTO_PCBC is not set
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
# CONFIG_CRYPTO_CRC32C_INTEL is not set
# CONFIG_CRYPTO_CRC32 is not set
# CONFIG_CRYPTO_CRC32_PCLMUL is not set
CONFIG_CRYPTO_CRCT10DIF=y
CONFIG_CRYPTO_GHASH=y
CONFIG_CRYPTO_MD4=y
CONFIG_CRYPTO_MD5=y
CONFIG_CRYPTO_MICHAEL_MIC=y
CONFIG_CRYPTO_RMD128=y
CONFIG_CRYPTO_RMD160=y
CONFIG_CRYPTO_RMD256=m
CONFIG_CRYPTO_RMD320=m
CONFIG_CRYPTO_SHA1=y
CONFIG_CRYPTO_SHA256=y
# CONFIG_CRYPTO_SHA512 is not set
CONFIG_CRYPTO_TGR192=m
# CONFIG_CRYPTO_WP512 is not set

#
# Ciphers
#
CONFIG_CRYPTO_AES=y
CONFIG_CRYPTO_AES_586=y
# CONFIG_CRYPTO_AES_NI_INTEL is not set
# CONFIG_CRYPTO_ANUBIS is not set
CONFIG_CRYPTO_ARC4=y
CONFIG_CRYPTO_BLOWFISH=y
CONFIG_CRYPTO_BLOWFISH_COMMON=y
CONFIG_CRYPTO_CAMELLIA=y
# CONFIG_CRYPTO_CAST5 is not set
# CONFIG_CRYPTO_CAST6 is not set
CONFIG_CRYPTO_DES=y
CONFIG_CRYPTO_FCRYPT=m
CONFIG_CRYPTO_KHAZAD=m
# CONFIG_CRYPTO_SALSA20 is not set
CONFIG_CRYPTO_SALSA20_586=y
# CONFIG_CRYPTO_SEED is not set
CONFIG_CRYPTO_SERPENT=m
CONFIG_CRYPTO_SERPENT_SSE2_586=m
# CONFIG_CRYPTO_TEA is not set
CONFIG_CRYPTO_TWOFISH=y
CONFIG_CRYPTO_TWOFISH_COMMON=y
CONFIG_CRYPTO_TWOFISH_586=m

#
# Compression
#
CONFIG_CRYPTO_DEFLATE=y
CONFIG_CRYPTO_ZLIB=y
CONFIG_CRYPTO_LZO=m
CONFIG_CRYPTO_LZ4=m
CONFIG_CRYPTO_LZ4HC=m

#
# Random Number Generation
#
CONFIG_CRYPTO_ANSI_CPRNG=y
CONFIG_CRYPTO_USER_API=m
CONFIG_CRYPTO_USER_API_HASH=m
# CONFIG_CRYPTO_USER_API_SKCIPHER is not set
CONFIG_CRYPTO_HASH_INFO=y
CONFIG_CRYPTO_HW=y
CONFIG_CRYPTO_DEV_PADLOCK=y
CONFIG_CRYPTO_DEV_PADLOCK_AES=m
# CONFIG_CRYPTO_DEV_PADLOCK_SHA is not set
# CONFIG_CRYPTO_DEV_GEODE is not set
# CONFIG_CRYPTO_DEV_HIFN_795X is not set
# CONFIG_CRYPTO_DEV_CCP is not set
CONFIG_ASYMMETRIC_KEY_TYPE=y
CONFIG_ASYMMETRIC_PUBLIC_KEY_SUBTYPE=y
CONFIG_PUBLIC_KEY_ALGO_RSA=y
CONFIG_X509_CERTIFICATE_PARSER=y
CONFIG_HAVE_KVM=y
CONFIG_VIRTUALIZATION=y
# CONFIG_KVM is not set
CONFIG_LGUEST=y
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
CONFIG_CRC_CCITT=y
CONFIG_CRC16=y
CONFIG_CRC_T10DIF=y
CONFIG_CRC_ITU_T=m
CONFIG_CRC32=y
CONFIG_CRC32_SELFTEST=y
# CONFIG_CRC32_SLICEBY8 is not set
# CONFIG_CRC32_SLICEBY4 is not set
# CONFIG_CRC32_SARWATE is not set
CONFIG_CRC32_BIT=y
CONFIG_CRC7=y
CONFIG_LIBCRC32C=y
CONFIG_CRC8=y
# CONFIG_RANDOM32_SELFTEST is not set
CONFIG_ZLIB_INFLATE=y
CONFIG_ZLIB_DEFLATE=y
CONFIG_LZO_COMPRESS=y
CONFIG_LZO_DECOMPRESS=y
CONFIG_LZ4_COMPRESS=m
CONFIG_LZ4HC_COMPRESS=m
CONFIG_LZ4_DECOMPRESS=m
CONFIG_XZ_DEC=m
# CONFIG_XZ_DEC_X86 is not set
CONFIG_XZ_DEC_POWERPC=y
# CONFIG_XZ_DEC_IA64 is not set
# CONFIG_XZ_DEC_ARM is not set
# CONFIG_XZ_DEC_ARMTHUMB is not set
CONFIG_XZ_DEC_SPARC=y
CONFIG_XZ_DEC_BCJ=y
CONFIG_XZ_DEC_TEST=m
CONFIG_DECOMPRESS_GZIP=y
CONFIG_BCH=y
CONFIG_BCH_CONST_PARAMS=y
CONFIG_TEXTSEARCH=y
CONFIG_TEXTSEARCH_KMP=y
CONFIG_TEXTSEARCH_BM=y
CONFIG_TEXTSEARCH_FSM=y
CONFIG_ASSOCIATIVE_ARRAY=y
CONFIG_HAS_IOMEM=y
CONFIG_HAS_IOPORT=y
CONFIG_HAS_DMA=y
CONFIG_DQL=y
CONFIG_NLATTR=y
CONFIG_ARCH_HAS_ATOMIC64_DEC_IF_POSITIVE=y
CONFIG_AVERAGE=y
CONFIG_CLZ_TAB=y
# CONFIG_CORDIC is not set
CONFIG_DDR=y
CONFIG_MPILIB=y
CONFIG_OID_REGISTRY=y

--k1lZvvs/B4yU6o8G
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

_______________________________________________
LKP mailing list
LKP@linux.intel.com

--k1lZvvs/B4yU6o8G--
