Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753391AbaBSMV6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Feb 2014 07:21:58 -0500
Received: from mga03.intel.com ([143.182.124.21]:58573 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751321AbaBSMVz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Feb 2014 07:21:55 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,505,1389772800"; 
   d="log'?scan'208";a="477620435"
Date: Wed, 19 Feb 2014 20:21:32 +0800
From: Fengguang Wu <fengguang.wu@intel.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Ingo Molnar <mingo@kernel.org>, linux-kernel@vger.kernel.org
Subject: [sched] BUG: unable to handle kernel NULL pointer dereference at
 00000040
Message-ID: <20140219122132.GB7735@localhost>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="OgqxwSJOaUobr8KG"
Content-Disposition: inline
User-Agent: Heirloom mailx 12.5 6/20/10
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--OgqxwSJOaUobr8KG
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Greetings,

I got the below dmesg and the first bad commit is

git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip.git sched/core

commit 38033c37faab850ed5d33bb675c4de6c66be84d8
Author:     Peter Zijlstra <peterz@infradead.org>
AuthorDate: Thu Jan 23 20:32:21 2014 +0100
Commit:     Ingo Molnar <mingo@kernel.org>
CommitDate: Tue Feb 11 09:58:10 2014 +0100

    sched: Push down pre_schedule() and idle_balance()
    
    This patch both merged idle_balance() and pre_schedule() and pushes
    both of them into pick_next_task().
    
    Conceptually pre_schedule() and idle_balance() are rather similar,
    both are used to pull more work onto the current CPU.
    
    We cannot however first move idle_balance() into pre_schedule_fair()
    since there is no guarantee the last runnable task is a fair task, and
    thus we would miss newidle balances.
    
    Similarly, the dl and rt pre_schedule calls must be ran before
    idle_balance() since their respective tasks have higher priority and
    it would not do to delay their execution searching for less important
    tasks first.
    
    However, by noticing that pick_next_tasks() already traverses the
    sched_class hierarchy in the right order, we can get the right
    behaviour and do away with both calls.
    
    We must however change the special case optimization to also require
    that prev is of sched_class_fair, otherwise we can miss doing a dl or
    rt pull where we needed one.
    
    Signed-off-by: Peter Zijlstra <peterz@infradead.org>
    Cc: Linus Torvalds <torvalds@linux-foundation.org>
    Cc: Andrew Morton <akpm@linux-foundation.org>
    Cc: Peter Zijlstra <peterz@infradead.org>
    Cc: Thomas Gleixner <tglx@linutronix.de>
    Link: http://lkml.kernel.org/n/tip-a8k6vvaebtn64nie345kx1je@git.kernel.org
    Signed-off-by: Ingo Molnar <mingo@kernel.org>

[    2.405319] .................................... done.
[    2.405948] Using IPI No-Shortcut mode
[   10.376683] Unregister pv shared memory for cpu 0
[   10.388424] BUG: unable to handle kernel NULL pointer dereference at 00000040
[   10.389307] IP: [<cc65d2c2>] pick_next_task+0xa/0x48
[   10.389880] *pdpt = 0000000000000000 *pde = f000ff53f000ff53 
[   10.390617] Oops: 0000 [#1] SMP DEBUG_PAGEALLOC
[   10.390948] CPU: 0 PID: 9 Comm: migration/0 Not tainted 3.14.0-rc2-next-20140214-03226-gda8d308 #1
[   10.390948] task: cc05d580 ti: cc09c000 task.ti: cc09c000
[   10.390948] EIP: 0060:[<cc65d2c2>] EFLAGS: 00010046 CPU: 0
[   10.390948] EIP is at pick_next_task+0xa/0x48
[   10.390948] EAX: cfcae100 EBX: cfcae100 ECX: 00000002 EDX: 00000000
[   10.390948] ESI: cfcae100 EDI: 00000000 EBP: cc09ddc0 ESP: cc09ddb4
[   10.390948]  DS: 007b ES: 007b FS: 00d8 GS: 0000 SS: 0068
[   10.390948] CR0: 8005003b CR2: 00000040 CR3: 0cd73000 CR4: 000006b0
[   10.390948] Stack:
[   10.390948]  cfcae100 cfcae100 ccc5b930 cc09dde4 cc661de5 00000200 cc05d580 00000082
[   10.390948]  00000000 ccc5c864 00000000 ccc5b930 cc09de00 cc659574 00000000 00000008
[   10.390948]  ffffffff cc055e6c 00000000 cc09de14 cc65982c fffffffb 00000000 00000000
[   10.390948] Call Trace:
[   10.390948]  [<cc661de5>] migration_call+0x10b/0x188
[   10.390948]  [<cc659574>] notifier_call_chain+0x32/0x4b
[   10.390948]  [<cc65982c>] __raw_notifier_call_chain+0x1e/0x23
[   10.390948]  [<cc63d7b1>] __cpu_notify+0x24/0x3e
[   10.390948]  [<cc63d7e3>] cpu_notify+0x18/0x1a
[   10.390948]  [<cc9f693d>] take_cpu_down+0x22/0x32
[   10.390948]  [<cc69b491>] multi_cpu_stop+0x80/0xce
[   10.390948]  [<cc69b411>] ? __stop_cpus+0x55/0x55
[   10.390948]  [<cc69b240>] cpu_stopper_thread+0x80/0x111
[   10.390948]  [<cc65cbd5>] ? finish_task_switch+0x33/0xba
[   10.390948]  [<cc9ff35e>] ? __schedule+0x377/0x55e
[   10.390948]  [<cc67368b>] ? __lock_acquire.isra.27+0x1be/0x4dd
[   10.390948]  [<cc673c81>] ? lock_acquire+0x93/0xe0
[   10.390948]  [<cc674039>] ? lock_release+0x16d/0x1b1
[   10.390948]  [<cca02421>] ? _raw_spin_unlock_irqrestore+0x44/0x4f
[   10.390948]  [<cc65b444>] smpboot_thread_fn+0x15d/0x173
[   10.390948]  [<cc65b2e7>] ? smpboot_unpark_thread+0x2e/0x2e
[   10.390948]  [<cc656225>] kthread+0x8d/0x92
[   10.390948]  [<cc650000>] ? __queue_work+0xb6/0x205
[   10.390948]  [<cca03677>] ret_from_kernel_thread+0x1b/0x28
[   10.390948]  [<cc656198>] ? __kthread_parkme+0x55/0x55
[   10.390948] Code: 00 ba 01 00 00 00 89 f0 eb 0e 89 f0 e8 b9 4f 3a 00 ba 01 00 00 00 89 d8 e8 04 57 3a 00 5b 5e 5d c3 55 89 e5 57 89 d7 56 89 c6 53 <81> 7a 40 74 03 a1 cc 74 07 bb a0 04 a1 cc eb 23 8b 40 6c 39 46
[   10.390948] EIP: [<cc65d2c2>] pick_next_task+0xa/0x48 SS:ESP 0068:cc09ddb4
[   10.390948] CR2: 0000000000000040
[   10.390948] ---[ end trace a546538b11268dcc ]---
[   10.390948] Kernel panic - not syncing: Fatal exception

git bisect start 5d1caa385f1675caf09e13afcd2b1db7a1c9b8e8 v3.13 --
git bisect good 595bf999e3a864f40e049c67c42ecee50fb7a78a  # 23:39     22+      5  Merge branch 'sched-urgent-for-linus' of git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip
git bisect good 55177c171200d841cdc23603f196e21a2d664c8f  # 23:47     22+      5  Merge remote-tracking branch 'arm-perf/for-next/perf'
git bisect good 12915522027525880c8fdd3fe08a7c8a74213f31  # 00:06     22+      7  Merge remote-tracking branch 'wireless-next/master'
git bisect good cb628c275dcd8bbdd61df2d96355a88e96a26c04  # 00:21     22+      3  Merge remote-tracking branch 'selinux/next'
git bisect  bad 3c1530d6101118e3a025114883f03578d4db4b66  # 00:24      0-      1  Merge remote-tracking branch 'regmap/for-next'
git bisect  bad 782f3c7e70bbcd03be9f5f9119a10dee790c5349  # 00:28      1-      1  Merge remote-tracking branch 'tip/auto-latest'
git bisect good b35e7aede6fb0226b4865450f62362e85bf6a306  # 00:54     30+     10  Merge remote-tracking branch 'trivial/for-next'
git bisect good 16af830af77fbfde49779f58328a2308593c9552  # 01:58     30+      5  Merge remote-tracking branch 'devicetree/devicetree/next'
git bisect good b74fcf317cca175426c2fee78ce8640ac91b6749  # 02:11     30+     10  Merge remote-tracking branch 'spi/for-next'
git bisect  bad 3f67d962c64d9b6de9dab81bdbe6d5c94c80d9b9  # 02:13      0-      1  cpuidle/pseries: Fix fallout caused due to cleanup in pseries cpuidle backend driver
git bisect good e5fc66119ec97054eefc83f173a7ee9e133c3c3a  # 03:10     30+      6  sched: Fix race in idle_balance()
git bisect  bad 27f17580fd2c7514c8f5cce22ab903c6f3ddf458  # 03:16      4-      3  sched: Delete is_same_group() outside CONFIG_FAIR_GROUP_SCHED
git bisect good f10447998a59b97747c16258a9c6e6a1512f27f3  # 03:59     60+     10  sched/fair: Clean up the __clear_buddies_*() functions
git bisect good 6c3b4d44ba2838f00614a5a2d777d4401e0bfd71  # 04:35     60+     10  sched: Clean up idle task SMP logic
git bisect  bad 38033c37faab850ed5d33bb675c4de6c66be84d8  # 04:36      0-      1  sched: Push down pre_schedule() and idle_balance()
# first bad commit: [38033c37faab850ed5d33bb675c4de6c66be84d8] sched: Push down pre_schedule() and idle_balance()
git bisect good 6c3b4d44ba2838f00614a5a2d777d4401e0bfd71  # 06:32    180+     43  sched: Clean up idle task SMP logic
git bisect  bad da8d308fbdb8360078786b3e125238122c4fc611  # 06:32      0-     15  Add linux-next specific files for 20140214
git bisect good da85a25b62dd9ca75ec64f6e0d6cdcbaa5752479  # 08:03    180+     38  Revert "sched: Push down pre_schedule() and idle_balance()"
git bisect good 6d0abeca3242a88cab8232e4acd7e2bf088f3bc2  # 12:31    180+     33  Linux 3.14-rc3
git bisect  bad da8d308fbdb8360078786b3e125238122c4fc611  # 12:31      0-     15  Add linux-next specific files for 20140214

Thanks,
Fengguang

--OgqxwSJOaUobr8KG
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="dmesg-yocto-lkp-sbx04-56:20140215221715:i386-randconfig-x1-02152208::"
Content-Transfer-Encoding: quoted-printable

early console in setup code
[    0.000000] Initializing cgroup subsys cpuset
[    0.000000] Initializing cgroup subsys cpu
[    0.000000] Linux version 3.14.0-rc2-next-20140214-03226-gda8d308 (kbuil=
d@xian) (gcc version 4.8.1 (Debian 4.8.1-8) ) #1 SMP Sat Feb 15 22:15:18 CS=
T 2014
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
[    0.000000] x86 PAT enabled: cpu 0, old 0x70406, new 0x7010600070106
[    0.000000] Scan for SMP in [mem 0x00000000-0x000003ff]
[    0.000000] Scan for SMP in [mem 0x0009fc00-0x0009ffff]
[    0.000000] Scan for SMP in [mem 0x000f0000-0x000fffff]
[    0.000000] found SMP MP-table at [mem 0x000f1af0-0x000f1aff] mapped at =
[c00f1af0]
[    0.000000]   mpc: f1b00-f1be4
[    0.000000] initial memory mapped: [mem 0x00000000-0x0d7fffff]
[    0.000000] Base memory trampoline at [c009b000] 9b000 size 16384
[    0.000000] init_memory_mapping: [mem 0x00000000-0x000fffff]
[    0.000000]  [mem 0x00000000-0x000fffff] page 4k
[    0.000000] init_memory_mapping: [mem 0x0fa00000-0x0fbfffff]
[    0.000000]  [mem 0x0fa00000-0x0fbfffff] page 4k
[    0.000000] BRK [0x0d2ab000, 0x0d2abfff] PGTABLE
[    0.000000] init_memory_mapping: [mem 0x0c000000-0x0f9fffff]
[    0.000000]  [mem 0x0c000000-0x0f9fffff] page 4k
[    0.000000] init_memory_mapping: [mem 0x00100000-0x0bffffff]
[    0.000000]  [mem 0x00100000-0x0bffffff] page 4k
[    0.000000] init_memory_mapping: [mem 0x0fc00000-0x0fffdfff]
[    0.000000]  [mem 0x0fc00000-0x0fffdfff] page 4k
[    0.000000] BRK [0x0d2ac000, 0x0d2acfff] PGTABLE
[    0.000000] BRK [0x0d2ad000, 0x0d2adfff] PGTABLE
[    0.000000] cma: CMA: reserved 28 MiB at 0dc00000
[    0.000000] RAMDISK: [mem 0x0fcbd000-0x0ffeffff]
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
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] mapped APIC to         ffffb000 (        fee00000)
[    0.000000] 0MB HIGHMEM available.
[    0.000000] 255MB LOWMEM available.
[    0.000000]   mapped low ram: 0 - 0fffe000
[    0.000000]   low ram: 0 - 0fffe000
[    0.000000] kvm-clock: Using msrs 4b564d01 and 4b564d00
[    0.000000] kvm-clock: cpu 0, msr 0:fffd001, boot clock
[    0.000000] BRK [0x0d2ae000, 0x0d2aefff] PGTABLE
[    0.000000] Zone ranges:
[    0.000000]   DMA      [mem 0x00001000-0x00ffffff]
[    0.000000]   Normal   [mem 0x01000000-0x0fffdfff]
[    0.000000]   HighMem  empty
[    0.000000] Movable zone start for each node
[    0.000000] Early memory node ranges
[    0.000000]   node   0: [mem 0x00001000-0x0009efff]
[    0.000000]   node   0: [mem 0x00100000-0x0fffdfff]
[    0.000000] On node 0 totalpages: 65436
[    0.000000]   DMA zone: 40 pages used for memmap
[    0.000000]   DMA zone: 0 pages reserved
[    0.000000]   DMA zone: 3998 pages, LIFO batch:0
[    0.000000]   Normal zone: 600 pages used for memmap
[    0.000000]   Normal zone: 61438 pages, LIFO batch:15
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
[    0.000000] e820: [mem 0x10000000-0xfeffbfff] available for PCI devices
[    0.000000] Booting paravirtualized kernel on KVM
[    0.000000] setup_percpu: NR_CPUS:8 nr_cpumask_bits:2 nr_cpu_ids:2 nr_no=
de_ids:1
[    0.000000] PERCPU: Embedded 11 pages/cpu @cfca7000 s30976 r0 d14080 u45=
056
[    0.000000] pcpu-alloc: s30976 r0 d14080 u45056 alloc=3D11*4096
[    0.000000] pcpu-alloc: [0] 0 [0] 1=20
[    0.000000] kvm-clock: cpu 0, msr 0:fffd001, primary cpu clock
[    0.000000] KVM setup async PF for cpu 0
[    0.000000] kvm-stealtime: cpu 0, msr fca9600
[    0.000000] Built 1 zonelists in Zone order, mobility grouping on.  Tota=
l pages: 64796
[    0.000000] Kernel command line: hung_task_panic=3D1 earlyprintk=3DttyS0=
,115200 debug apic=3Ddebug sysrq_always_enabled panic=3D10 softlockup_panic=
=3D1 nmi_watchdog=3Dpanic  prompt_ramdisk=3D0 console=3DttyS0,115200 consol=
e=3Dtty0 vga=3Dnormal  root=3D/dev/ram0 rw link=3D/kernel-tests/run-queue/k=
vm/i386-randconfig-x1-02152208/next:master/.vmlinuz-da8d308fbdb8360078786b3=
e125238122c4fc611-20140215221646-9-lkp-sbx04 branch=3Dnext/master BOOT_IMAG=
E=3D/kernel/i386-randconfig-x1-02152208/da8d308fbdb8360078786b3e125238122c4=
fc611/vmlinuz-3.14.0-rc2-next-20140214-03226-gda8d308
[    0.000000] PID hash table entries: 1024 (order: 0, 4096 bytes)
[    0.000000] Dentry cache hash table entries: 32768 (order: 5, 131072 byt=
es)
[    0.000000] Inode-cache hash table entries: 16384 (order: 4, 65536 bytes)
[    0.000000] Initializing CPU#0
[    0.000000] Initializing HighMem for node 0 (00000000:00000000)
[    0.000000] Memory: 211228K/261744K available (4112K kernel code, 643K r=
wdata, 2316K rodata, 528K init, 4924K bss, 50516K reserved, 0K highmem)
[    0.000000] virtual kernel memory layout:
[    0.000000]     fixmap  : 0xfff15000 - 0xfffff000   ( 936 kB)
[    0.000000]     pkmap   : 0xffc00000 - 0xffe00000   (2048 kB)
[    0.000000]     vmalloc : 0xd07fe000 - 0xffbfe000   ( 756 MB)
[    0.000000]     lowmem  : 0xc0000000 - 0xcfffe000   ( 255 MB)
[    0.000000]       .init : 0xcccea000 - 0xccd6e000   ( 528 kB)
[    0.000000]       .data : 0xcca045ad - 0xccce9e40   (2966 kB)
[    0.000000]       .text : 0xcc600000 - 0xcca045ad   (4113 kB)
[    0.000000] Checking if this processor honours the WP bit even in superv=
isor mode...Ok.
[    0.000000] SLUB: HWalign=3D128, Order=3D0-3, MinObjects=3D0, CPUs=3D2, =
Nodes=3D1
[    0.000000] Hierarchical RCU implementation.
[    0.000000]=20
[    0.000000]=20
[    0.000000]=20
[    0.000000] RCU: Adjusting geometry for rcu_fanout_leaf=3D16, nr_cpu_ids=
=3D2
[    0.000000] NR_IRQS:2304 nr_irqs:512 16
[    0.000000] CPU 0 irqstacks, hard=3Dcc00a000 soft=3Dcc00c000
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
[    0.000000]  memory used by lock dependency info: 3551 kB
[    0.000000]  per task-struct memory footprint: 1152 bytes
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
[    0.000000] ODEBUG: 13 of 13 active objects replaced
[    0.000000] ODEBUG: selftest passed
[    0.000000] hpet clockevent registered
[    0.000000] tsc: Detected 2693.638 MHz processor
[    0.008000] Calibrating delay loop (skipped) preset value.. 5387.27 Bogo=
MIPS (lpj=3D10774552)
[    0.008000] pid_max: default: 4096 minimum: 301
[    0.008000] Mount-cache hash table entries: 512
[    0.008000] Initializing cgroup subsys perf_event
[    0.008000] Last level iTLB entries: 4KB 0, 2MB 0, 4MB 0
[    0.008000] Last level dTLB entries: 4KB 0, 2MB 0, 4MB 0, 1GB 0
[    0.008000] tlb_flushall_shift: 6
[    0.008236] debug: unmapping init [mem 0xccd6e000-0xccd6ffff]
[    0.009800] ftrace: allocating 22589 entries in 45 pages
[    0.020063] Getting VERSION: 50014
[    0.020428] Getting VERSION: 50014
[    0.020788] Getting ID: 0
[    0.021031] Getting ID: f000000
[    0.021329] Getting LVT0: 8700
[    0.021607] Getting LVT1: 8400
[    0.021908] Enabling APIC mode:  Flat.  Using 1 I/O APICs
[    0.022454] enabled ExtINT on CPU#0
[    0.023967] ENABLING IO-APIC IRQs
[    0.024012] init IO_APIC IRQs
[    0.024298]  apic 0 pin 0 not connected
[    0.024646] IOAPIC[0]: Set routing entry (0-1 -> 0x31 -> IRQ 1 Mode:0 Ac=
tive:0 Dest:1)
[    0.025457] IOAPIC[0]: Set routing entry (0-2 -> 0x30 -> IRQ 0 Mode:0 Ac=
tive:0 Dest:1)
[    0.026167] IOAPIC[0]: Set routing entry (0-3 -> 0x33 -> IRQ 3 Mode:0 Ac=
tive:0 Dest:1)
[    0.026984] IOAPIC[0]: Set routing entry (0-4 -> 0x34 -> IRQ 4 Mode:0 Ac=
tive:0 Dest:1)
[    0.028021] IOAPIC[0]: Set routing entry (0-5 -> 0x35 -> IRQ 5 Mode:1 Ac=
tive:0 Dest:1)
[    0.028735] IOAPIC[0]: Set routing entry (0-6 -> 0x36 -> IRQ 6 Mode:0 Ac=
tive:0 Dest:1)
[    0.029444] IOAPIC[0]: Set routing entry (0-7 -> 0x37 -> IRQ 7 Mode:0 Ac=
tive:0 Dest:1)
[    0.030158] IOAPIC[0]: Set routing entry (0-8 -> 0x38 -> IRQ 8 Mode:0 Ac=
tive:0 Dest:1)
[    0.030927] IOAPIC[0]: Set routing entry (0-9 -> 0x39 -> IRQ 9 Mode:1 Ac=
tive:0 Dest:1)
[    0.031630] IOAPIC[0]: Set routing entry (0-10 -> 0x3a -> IRQ 10 Mode:1 =
Active:0 Dest:1)
[    0.032030] IOAPIC[0]: Set routing entry (0-11 -> 0x3b -> IRQ 11 Mode:1 =
Active:0 Dest:1)
[    0.032809] IOAPIC[0]: Set routing entry (0-12 -> 0x3c -> IRQ 12 Mode:0 =
Active:0 Dest:1)
[    0.033643] IOAPIC[0]: Set routing entry (0-13 -> 0x3d -> IRQ 13 Mode:0 =
Active:0 Dest:1)
[    0.034365] IOAPIC[0]: Set routing entry (0-14 -> 0x3e -> IRQ 14 Mode:0 =
Active:0 Dest:1)
[    0.035135] IOAPIC[0]: Set routing entry (0-15 -> 0x3f -> IRQ 15 Mode:0 =
Active:0 Dest:1)
[    0.036018]  apic 0 pin 16 not connected
[    0.036381]  apic 0 pin 17 not connected
[    0.036783]  apic 0 pin 18 not connected
[    0.037123]  apic 0 pin 19 not connected
[    0.037486]  apic 0 pin 20 not connected
[    0.037839]  apic 0 pin 21 not connected
[    0.038201]  apic 0 pin 22 not connected
[    0.038543]  apic 0 pin 23 not connected
[    0.039053] ..TIMER: vector=3D0x30 apic1=3D0 pin1=3D2 apic2=3D-1 pin2=3D=
-1
[    0.040004] smpboot: CPU0: Intel Common KVM processor (fam: 0f, model: 0=
6, stepping: 01)
[    0.041306] Using local APIC timer interrupts.
[    0.041306] calibrating APIC timer ...
[    0.044000] ... lapic delta =3D 6250677
[    0.044000] ... PM-Timer delta =3D 358057
[    0.044000] ... PM-Timer result ok
[    0.044000] ..... delta 6250677
[    0.044000] ..... mult: 268464532
[    0.044000] ..... calibration result: 4000433
[    0.044000] ..... CPU clock speed is 2694.1209 MHz.
[    0.044000] ..... host bus clock speed is 1000.0433 MHz.
[    0.044097] Performance Events: unsupported Netburst CPU model 6 no PMU =
driver, software events only.
[    0.045986] ftrace: Allocated trace_printk buffers
[    0.049338] CPU 1 irqstacks, hard=3Dcc390000 soft=3Dcc392000
[    0.050239] x86: Booting SMP configuration:
[    0.050936] .... node  #0, CPUs:      #1
[    0.004000] Initializing CPU#1
[    0.008000] kvm-clock: cpu 1, msr 0:fffd041, secondary cpu clock
[    0.008000] masked ExtINT on CPU#1
[    0.064118] x86: Booted up 1 node, 2 CPUs
[    0.064078] KVM setup async PF for cpu 1
[    0.064078] kvm-stealtime: cpu 1, msr fcb4600
[    0.068009] ----------------
[    0.068383] | NMI testsuite:
[    0.068757] --------------------
[    0.069171]   remote IPI:  ok  |
[    0.080171]    local IPI:  ok  |
[    0.104012] --------------------
[    0.104465] Good, all   2 testcases passed! |
[    0.105051] ---------------------------------
[    0.105626] smpboot: Total of 2 processors activated (10774.55 BogoMIPS)
[    0.113281] NET: Registered protocol family 16
[    0.114622] EISA bus registered
[    0.115042] cpuidle: using governor menu
[    0.116150] ACPI: bus type PCI registered
[    0.116865] PCI : PCI BIOS area is rw and x. Use pci=3Dnobios if you wan=
t it NX.
[    0.117781] PCI: PCI BIOS revision 2.10 entry at 0xfd467, last bus=3D0
[    0.118585] PCI: Using configuration type 1 for base access
[    0.132387] ACPI: Added _OSI(Module Device)
[    0.132978] ACPI: Added _OSI(Processor Device)
[    0.133562] ACPI: Added _OSI(3.0 _SCP Extensions)
[    0.134176] ACPI: Added _OSI(Processor Aggregator Device)
[    0.140307] ACPI: Interpreter enabled
[    0.140827] ACPI Exception: AE_NOT_FOUND, While evaluating Sleep State [=
\_S1_] (20140114/hwxface-580)
[    0.142054] ACPI Exception: AE_NOT_FOUND, While evaluating Sleep State [=
\_S2_] (20140114/hwxface-580)
[    0.143292] ACPI: (supports S0 S3 S5)
[    0.143779] ACPI: Using IOAPIC for interrupt routing
[    0.144039] PCI: Using host bridge windows from ACPI; if necessary, use =
"pci=3Dnocrs" and report a bug
[    0.153119] ACPI: PCI Root Bridge [PCI0] (domain 0000 [bus 00-ff])
[    0.153941] acpi PNP0A03:00: _OSC: OS supports [Segments]
[    0.154657] acpi PNP0A03:00: _OSC failed (AE_NOT_FOUND); disabling ASPM
[    0.155694] acpi PNP0A03:00: fail to add MMCONFIG information, can't acc=
ess extended PCI configuration space under this bridge.
[    0.156127] PCI host bridge to bus 0000:00
[    0.156671] pci_bus 0000:00: root bus resource [bus 00-ff]
[    0.157378] pci_bus 0000:00: root bus resource [io  0x0000-0x0cf7]
[    0.157894] pci_bus 0000:00: root bus resource [io  0x0d00-0xffff]
[    0.158528] pci_bus 0000:00: root bus resource [mem 0x000a0000-0x000bfff=
f]
[    0.160007] pci_bus 0000:00: root bus resource [mem 0x80000000-0xfebffff=
f]
[    0.160711] pci 0000:00:00.0: [8086:1237] type 00 class 0x060000
[    0.162126] pci 0000:00:01.0: [8086:7000] type 00 class 0x060100
[    0.163365] pci 0000:00:01.1: [8086:7010] type 00 class 0x010180
[    0.166535] pci 0000:00:01.1: reg 0x20: [io  0xc040-0xc04f]
[    0.168243] pci 0000:00:01.3: [8086:7113] type 00 class 0x068000
[    0.169087] pci 0000:00:01.3: quirk: [io  0xb000-0xb03f] claimed by PIIX=
4 ACPI
[    0.169812] pci 0000:00:01.3: quirk: [io  0xb100-0xb10f] claimed by PIIX=
4 SMB
[    0.170683] pci 0000:00:02.0: [1013:00b8] type 00 class 0x030000
[    0.172512] pci 0000:00:02.0: reg 0x10: [mem 0xfc000000-0xfdffffff pref]
[    0.174218] pci 0000:00:02.0: reg 0x14: [mem 0xfebf0000-0xfebf0fff]
[    0.180006] pci 0000:00:02.0: reg 0x30: [mem 0xfebe0000-0xfebeffff pref]
[    0.181324] pci 0000:00:03.0: [8086:100e] type 00 class 0x020000
[    0.182780] pci 0000:00:03.0: reg 0x10: [mem 0xfebc0000-0xfebdffff]
[    0.184006] pci 0000:00:03.0: reg 0x14: [io  0xc000-0xc03f]
[    0.188905] pci 0000:00:03.0: reg 0x30: [mem 0xfeb80000-0xfebbffff pref]
[    0.190067] pci 0000:00:04.0: [8086:25ab] type 00 class 0x088000
[    0.191382] pci 0000:00:04.0: reg 0x10: [mem 0xfebf1000-0xfebf100f]
[    0.195199] pci_bus 0000:00: on NUMA node 0
[    0.196434] ACPI: PCI Interrupt Link [LNKA] (IRQs 5 *10 11)
[    0.197102] ACPI: PCI Interrupt Link [LNKB] (IRQs 5 *10 11)
[    0.197808] ACPI: PCI Interrupt Link [LNKC] (IRQs 5 10 *11)
[    0.198500] ACPI: PCI Interrupt Link [LNKD] (IRQs 5 10 *11)
[    0.199087] ACPI: PCI Interrupt Link [LNKS] (IRQs *9)
[    0.199772] acpi LNXCPU:00: Invalid PBLK length [0]
[    0.200110] acpi LNXCPU:01: Invalid PBLK length [0]
[    0.200812] ACPI: Enabled 16 GPEs in block 00 to 0F
[    0.201463] vgaarb: device added: PCI:0000:00:02.0,decodes=3Dio+mem,owns=
=3Dio+mem,locks=3Dnone
[    0.202199] vgaarb: loaded
[    0.202443] vgaarb: bridge control possible 0000:00:02.0
[    0.203357] pps_core: LinuxPPS API ver. 1 registered
[    0.204004] pps_core: Software ver. 5.3.6 - Copyright 2005-2007 Rodolfo =
Giometti <giometti@linux.it>
[    0.204891] PTP clock support registered
[    0.205242] EDAC MC: Ver: 3.0.0
[    0.205828] Advanced Linux Sound Architecture Driver Initialized.
[    0.205828] PCI: Using ACPI for IRQ routing
[    0.205828] PCI: pci_cache_line_size set to 64 bytes
[    0.205828] e820: reserve RAM buffer [mem 0x0009fc00-0x0009ffff]
[    0.208006] e820: reserve RAM buffer [mem 0x0fffe000-0x0fffffff]
[    0.209205] Switched to clocksource kvm-clock
[    0.214664] pnp: PnP ACPI init
[    0.215057] ACPI: bus type PNP registered
[    0.215451] IOAPIC[0]: Set routing entry (0-8 -> 0x38 -> IRQ 8 Mode:0 Ac=
tive:0 Dest:3)
[    0.216392] pnp 00:00: Plug and Play ACPI device, IDs PNP0b00 (active)
[    0.217085] IOAPIC[0]: Set routing entry (0-1 -> 0x31 -> IRQ 1 Mode:0 Ac=
tive:0 Dest:3)
[    0.217874] pnp 00:01: Plug and Play ACPI device, IDs PNP0303 (active)
[    0.218498] IOAPIC[0]: Set routing entry (0-12 -> 0x3c -> IRQ 12 Mode:0 =
Active:0 Dest:3)
[    0.219288] pnp 00:02: Plug and Play ACPI device, IDs PNP0f13 (active)
[    0.219976] IOAPIC[0]: Set routing entry (0-6 -> 0x36 -> IRQ 6 Mode:0 Ac=
tive:0 Dest:3)
[    0.220711] pnp 00:03: [dma 2]
[    0.221043] pnp 00:03: Plug and Play ACPI device, IDs PNP0700 (active)
[    0.221975] IOAPIC[0]: Set routing entry (0-7 -> 0x37 -> IRQ 7 Mode:0 Ac=
tive:0 Dest:3)
[    0.222939] pnp 00:04: Plug and Play ACPI device, IDs PNP0400 (active)
[    0.223638] IOAPIC[0]: Set routing entry (0-4 -> 0x34 -> IRQ 4 Mode:0 Ac=
tive:0 Dest:3)
[    0.224459] pnp 00:05: Plug and Play ACPI device, IDs PNP0501 (active)
[    0.225140] IOAPIC[0]: Set routing entry (0-3 -> 0x33 -> IRQ 3 Mode:0 Ac=
tive:0 Dest:3)
[    0.225903] pnp 00:06: Plug and Play ACPI device, IDs PNP0501 (active)
[    0.226795] pnp 00:07: Plug and Play ACPI device, IDs PNP0103 (active)
[    0.227492] pnp: PnP ACPI: found 8 devices
[    0.227927] ACPI: bus type PNP unregistered
[    0.263405] pci_bus 0000:00: resource 4 [io  0x0000-0x0cf7]
[    0.264146] pci_bus 0000:00: resource 5 [io  0x0d00-0xffff]
[    0.264873] pci_bus 0000:00: resource 6 [mem 0x000a0000-0x000bffff]
[    0.265639] pci_bus 0000:00: resource 7 [mem 0x80000000-0xfebfffff]
[    0.266473] NET: Registered protocol family 1
[    0.267047] pci 0000:00:00.0: Limiting direct PCI/PCI transfers
[    0.267824] pci 0000:00:01.0: PIIX3: Enabling Passive Release
[    0.268572] pci 0000:00:01.0: Activating ISA DMA hang workarounds
[    0.269362] pci 0000:00:02.0: Boot video device
[    0.269965] PCI: CLS 0 bytes, default 64
[    0.270668] Unpacking initramfs...
[    0.370568] debug: unmapping init [mem 0xcfcbd000-0xcffeffff]
[    0.372418] microcode: CPU0 sig=3D0xf61, pf=3D0x1, revision=3D0x1
[    0.373155] microcode: CPU1 sig=3D0xf61, pf=3D0x1, revision=3D0x1
[    0.373859] microcode: Microcode Update Driver: v2.00 <tigran@aivazian.f=
snet.co.uk>, Peter Oruba
[    0.378231] PCLMULQDQ-NI instructions are not detected.
[    0.378916] The force parameter has not been set to 1. The Iris poweroff=
 handler will not be installed.
[    0.381344] Initializing RT-Tester: OK
[    0.381836] spin_lock-torture:--- Start of test: nwriters_stress=3D4 sta=
t_interval=3D60 verbose=3D1 shuffle_interval=3D3 stutter=3D5 shutdown_secs=
=3D0 onoff_interval=3D0 onoff_holdoff=3D0
[    0.383750] spin_lock-torture: Creating torture_shuffle task
[    0.384604] spin_lock-torture: torture_shuffle task started
[    0.384607] spin_lock-torture: Creating torture_stutter task
[    0.384647] spin_lock-torture: Creating lock_torture_writer task
[    0.384669] spin_lock-torture: torture_stutter task started
[    0.387325] spin_lock-torture: Creating lock_torture_writer task
[    0.387350] spin_lock-torture: lock_torture_writer task started
[    0.388926] spin_lock-torture: Creating lock_torture_writer task
[    0.388933] spin_lock-torture: lock_torture_writer task started
[    0.390547] spin_lock-torture: Creating lock_torture_writer task
[    0.390552] spin_lock-torture: lock_torture_writer task started
[    0.392137] spin_lock-torture: Creating lock_torture_stats task
[    0.392143] spin_lock-torture: lock_torture_writer task started
[    0.393694] spin_lock-torture: lock_torture_stats task started
[    0.394233] futex hash table entries: 16 (order: -2, 1024 bytes)
[    0.396772] HugeTLB registered 2 MB page size, pre-allocated 0 pages
[    0.403362] VFS: Disk quotas dquot_6.5.2
[    0.404035] Dquot-cache hash table entries: 1024 (order 0, 4096 bytes)
[    0.405200] fuse init (API version 7.22)
[    0.420044] alg: No test for crc32 (crc32-table)
[    0.421312] alg: No test for lz4 (lz4-generic)
[    0.422051] alg: No test for lz4hc (lz4hc-generic)
[    0.422891] alg: No test for stdrng (krng)
[    0.434566] alg: No test for fips(ansi_cprng) (fips_ansi_cprng)
[    0.437222] test_string_helpers: Running tests...
[    0.438627] xz_dec_test: module loaded
[    0.439121] xz_dec_test: Create a device node with 'mknod xz_dec_test c =
252 0' and write .xz files to it.
[    0.440687] ipmi message handler version 39.2
[    0.441362] IPMI Watchdog: driver initialized
[    0.442101] input: Power Button as /devices/LNXSYSTM:00/LNXPWRBN:00/inpu=
t/input0
[    0.443092] ACPI: Power Button [PWRF]
[    0.468826] Serial: 8250/16550 driver, 4 ports, IRQ sharing disabled
[    0.495097] 00:05: ttyS0 at I/O 0x3f8 (irq =3D 4, base_baud =3D 115200) =
is a 16550A
[    0.497041] lp: driver loaded but no devices found
[    0.497733] DoubleTalk PC - not found
[    0.498591] Non-volatile memory driver v1.3
[    0.499133] toshiba: not a supported Toshiba laptop
[    0.499837] platform pc8736x_gpio.0: NatSemi pc8736x GPIO Driver Initial=
izing
[    0.500889] platform pc8736x_gpio.0: no device found
[    0.501805] nsc_gpio initializing
[    0.502299] telclk_interrupt =3D 0xf non-mcpbl0010 hw.
[    0.502967] Hangcheck: starting hangcheck timer 0.9.1 (tick is 180 secon=
ds, margin is 60 seconds).
[    0.504185] Hangcheck: Using getrawmonotonic().
[    0.505011] [drm] Initialized drm 1.1.0 20060810
[    0.505680] parport_pc 00:04: reported by Plug and Play ACPI
[    0.506694] parport0: PC-style at 0x378, irq 7 [PCSPP,TRISTATE]
[    1.406229] lp0: using parport0 (interrupt-driven).
[    1.406678] lp0: console ready
[    1.407573] dummy-irq: no IRQ given.  Use irq=3DN
[    1.408262] Silicon Labs C2 port support v. 0.51.0 - (C) 2007 Rodolfo Gi=
ometti
[    1.409251] c2port c2port0: C2 port uc added
[    1.409797] c2port c2port0: uc flash has 30 blocks x 512 bytes (15360 by=
tes total)
[    1.411122] platform physmap-flash.0: failed to claim resource 0
[    1.411945] Could not find PAR responsible for SC520CDP Flash Bank #0
[    1.412735] Trying default address 0x8400000
[    1.413303] SC520 CDP flash device: 0x800000 at 0x8400000
[    1.413958] Failed to ioremap_nocache
[    1.450054] No valid DiskOnChip devices found
[    1.450727] [nandsim] warning: read_byte: unexpected data output cycle, =
state is STATE_READY return 0x0
[    1.451685] [nandsim] warning: read_byte: unexpected data output cycle, =
state is STATE_READY return 0x0
[    1.452721] [nandsim] warning: read_byte: unexpected data output cycle, =
state is STATE_READY return 0x0
[    1.453889] [nandsim] warning: read_byte: unexpected data output cycle, =
state is STATE_READY return 0x0
[    1.455086] [nandsim] warning: read_byte: unexpected data output cycle, =
state is STATE_READY return 0x0
[    1.456252] [nandsim] warning: read_byte: unexpected data output cycle, =
state is STATE_READY return 0x0
[    1.456408] tsc: Refined TSC clocksource calibration: 2693.505 MHz
[    1.457877] nand: device found, Manufacturer ID: 0x98, Chip ID: 0x39
[    1.458685] nand: Toshiba NAND 128MiB 1,8V 8-bit
[    1.459297] nand: 128MiB, SLC, page size: 512, OOB size: 16
[    1.460042] flash size: 128 MiB
[    1.460469] page size: 512 bytes
[    1.460899] OOB area size: 16 bytes
[    1.461356] sector size: 16 KiB
[    1.461763] pages number: 262144
[    1.462202] pages per sector: 32
[    1.462615] bus width: 8
[    1.462930] bits in sector size: 14
[    1.463401] bits in page size: 9
[    1.463808] bits in OOB size: 4
[    1.464096] flash size with OOB: 135168 KiB
[    1.464442] page address bytes: 4
[    1.464778] sector address bytes: 3
[    1.465236] options: 0x42
[    1.466539] Scanning device for bad blocks
[    1.492237] Creating 1 MTD partitions on "NAND 128MiB 1,8V 8-bit":
[    1.493059] 0x000000000000-0x000008000000 : "NAND simulator partition 0"
[    1.494307] parport0: cannot grant exclusive access for device spi-lm70l=
lp
[    1.495191] spi-lm70llp: spi_lm70llp probe fail, status -12
[    1.495897] HSI/SSI char device loaded
[    1.496224] parport0: cannot grant exclusive access for device ks0108
[    1.496873] ks0108: ERROR: parport didn't register new device
[    1.497677] i8042: PNP: PS/2 Controller [PNP0303:KBD,PNP0f13:MOU] at 0x6=
0,0x64 irq 1,12
[    1.499628] serio: i8042 KBD port at 0x60,0x64 irq 1
[    1.500277] serio: i8042 AUX port at 0x60,0x64 irq 12
[    1.501164] mousedev: PS/2 mouse device common for all mice
[    1.501951] evbug: Connected device: input0 (Power Button at LNXPWRBN/bu=
tton/input0)
[    1.503559] input: AT Translated Set 2 keyboard as /devices/platform/i80=
42/serio0/input/input1
[    1.504789] evbug: Connected device: input1 (AT Translated Set 2 keyboar=
d at isa0060/serio0/input0)
[    1.506580] mk712: device not present
[    1.507301] apanel: Fujitsu BIOS signature 'FJKEYINF' not found...
[    1.508294] ideapad_slidebar: DMI does not match
[    1.508984] rtc_cmos 00:00: RTC can wake from S4
[    1.509916] rtc_cmos 00:00: rtc core: registered rtc_cmos as rtc0
[    1.510959] rtc_cmos 00:00: alarms up to one day, 114 bytes nvram, hpet =
irqs
[    1.512370] rtc-test rtc-test.0: rtc core: registered test as rtc1
[    1.513093] rtc-test rtc-test.1: rtc core: registered test as rtc2
[    1.513686] i2c /dev entries driver
[    1.514075] i2c-parport: adapter type unspecified
[    1.514787] isa i2c-pca-isa.0: Please specify I/O base
[    1.515622] pps pps0: new PPS source ktimer
[    1.516164] pps pps0: ktimer PPS source registered
[    1.516770] pps_parport: parallel port PPS client
[    1.517375] parport0: cannot grant exclusive access for device pps_parpo=
rt
[    1.518248] pps_parport: couldn't register with parport0
[    1.518986] Driver for 1-wire Dallas network protocol.
[    1.519733] DS1WM w1 busmaster driver - (c) 2004 Szabolcs Gyurko
[    1.520544] 1-Wire driver for the DS2760 battery monitor  chip  - (c) 20=
04-2005, Szabolcs Gyurko
[    1.521811] power_supply test_ac: uevent
[    1.522345] power_supply test_ac: POWER_SUPPLY_NAME=3Dtest_ac
[    1.522917] power_supply test_ac: prop ONLINE=3D1
[    1.523338] power_supply test_ac: power_supply_changed
[    1.524039] power_supply test_ac: power_supply_changed_work
[    1.524758] power_supply test_ac: power_supply_update_gen_leds 1
[    1.525540] power_supply test_ac: uevent
[    1.526048] power_supply test_ac: POWER_SUPPLY_NAME=3Dtest_ac
[    1.526884] power_supply test_ac: prop ONLINE=3D1
[    1.527615] power_supply test_battery: uevent
[    1.528196] power_supply test_battery: POWER_SUPPLY_NAME=3Dtest_battery
[    1.529033] power_supply test_battery: prop STATUS=3DDischarging
[    1.529783] power_supply test_battery: prop CHARGE_TYPE=3DFast
[    1.530516] power_supply test_battery: prop HEALTH=3DGood
[    1.531233] power_supply test_battery: prop PRESENT=3D1
[    1.531881] power_supply test_battery: prop TECHNOLOGY=3DLi-ion
[    1.532612] power_supply test_battery: prop CHARGE_FULL_DESIGN=3D100
[    1.533403] power_supply test_battery: prop CHARGE_FULL=3D100
[    1.534127] power_supply test_battery: prop CHARGE_NOW=3D50
[    1.534821] power_supply test_battery: prop CAPACITY=3D50
[    1.535518] power_supply test_battery: prop CAPACITY_LEVEL=3DNormal
[    1.536309] power_supply test_battery: prop TIME_TO_EMPTY_AVG=3D3600
[    1.537098] power_supply test_battery: prop TIME_TO_FULL_NOW=3D3600
[    1.537823] power_supply test_battery: prop MODEL_NAME=3DTest battery
[    1.538605] power_supply test_battery: prop MANUFACTURER=3DLinux
[    1.539370] power_supply test_battery: prop SERIAL_NUMBER=3D3.14.0-rc2-n=
ext-20140214-03226-gda8d308
[    1.540485] power_supply test_battery: prop TEMP=3D26
[    1.541111] power_supply test_battery: prop VOLTAGE_NOW=3D3300
[    1.542010] power_supply test_battery: power_supply_changed
[    1.542772] power_supply test_battery: power_supply_changed_work
[    1.543563] power_supply test_battery: power_supply_update_bat_leds 2
[    1.544201] power_supply test_battery: uevent
[    1.544565] power_supply test_battery: POWER_SUPPLY_NAME=3Dtest_battery
[    1.545363] power_supply test_battery: prop STATUS=3DDischarging
[    1.546125] power_supply test_battery: prop CHARGE_TYPE=3DFast
[    1.546843] power_supply test_battery: prop HEALTH=3DGood
[    1.547543] power_supply test_battery: prop PRESENT=3D1
[    1.548212] power_supply test_battery: prop TECHNOLOGY=3DLi-ion
[    1.548979] power_supply test_battery: prop CHARGE_FULL_DESIGN=3D100
[    1.549788] power_supply test_battery: prop CHARGE_FULL=3D100
[    1.550510] power_supply test_battery: prop CHARGE_NOW=3D50
[    1.551223] power_supply test_battery: prop CAPACITY=3D50
[    1.551902] power_supply test_battery: prop CAPACITY_LEVEL=3DNormal
[    1.552683] power_supply test_battery: prop TIME_TO_EMPTY_AVG=3D3600
[    1.553476] power_supply test_battery: prop TIME_TO_FULL_NOW=3D3600
[    1.554273] power_supply test_battery: prop MODEL_NAME=3DTest battery
[    1.555105] power_supply test_battery: prop MANUFACTURER=3DLinux
[    1.555867] power_supply test_battery: prop SERIAL_NUMBER=3D3.14.0-rc2-n=
ext-20140214-03226-gda8d308
[    1.556999] power_supply test_battery: prop TEMP=3D26
[    1.557630] power_supply test_battery: prop VOLTAGE_NOW=3D3300
[    1.558453] power_supply test_usb: uevent
[    1.559002] power_supply test_usb: POWER_SUPPLY_NAME=3Dtest_usb
[    1.559762] power_supply test_usb: prop ONLINE=3D1
[    1.560363] power_supply test_usb: power_supply_changed
[    1.561345] w83781d: Detection failed at step 2
[    1.562163] applesmc: supported laptop not found!
[    1.562773] applesmc: driver init failed (ret=3D-19)!
[    1.563625] f71882fg: Not a Fintek device
[    1.564184] f71882fg: Not a Fintek device
[    1.565215] pc87360: PC8736x not detected, module not inserted
[    1.566268] intel_powerclamp: Intel powerclamp does not run on family 15=
 model 6
[    1.567225] sdhci: Secure Digital Host Controller Interface driver
[    1.567762] sdhci: Copyright(c) Pierre Ossman
[    1.568172] sdhci-pltfm: SDHCI platform and OF driver helper
[    1.568896] power_supply test_usb: power_supply_changed_work
[    1.569631] power_supply test_usb: power_supply_update_gen_leds 1
[    1.570401] power_supply test_usb: uevent
[    1.570916] power_supply test_usb: POWER_SUPPLY_NAME=3Dtest_usb
[    1.571662] power_supply test_usb: prop ONLINE=3D1
[    1.572659] ledtrig-cpu: registered to indicate activity on CPUs
[    1.573678] dcdbas dcdbas: Dell Systems Management Base Driver (version =
5.6.0-3.2)
[    1.574712] hidraw: raw HID events driver (C) Jiri Kosina
[    1.576105] hdaps: supported laptop not found!
[    1.576699] hdaps: driver init failed (ret=3D-19)!
[    1.577856]  fake-fmc-carrier: mezzanine 0
[    1.578418]       Manufacturer: fake-vendor
[    1.578951]       Product name: fake-design-for-testing
[    1.579720] fmc fake-design-for-testing-f001: Driver has no ID: matches =
all
[    1.580636] fmc_trivial: probe of fake-design-for-testing-f001 failed wi=
th error -95
[    1.581667] fmc fake-design-for-testing-f001: Driver has no ID: matches =
all
[    1.582608] fmc_write_eeprom fake-design-for-testing-f001: fmc_write_eep=
rom: no busid passed, refusing all cards
[    1.583951] fmc fake-design-for-testing-f001: Driver has no ID: matches =
all
[    1.584941] fmc_chardev fake-design-for-testing-f001: Created misc devic=
e "fake-design-for-testing-f001"
[    1.591592] sc6000: specify IO port
[    1.596761] isa ad1848.0: please specify port
[    1.602130] isa azt1605.0: please specify port
[    1.604506] isa azt2316.0: please specify port
[    1.606609] ALSA gus_main.c:180 gus: can't grab synth port 0x320
[    2.362893] ALSA jazz16.c:191 please specify port
[    2.366862]=20
[    2.366862] printing PIC contents
[    2.367294] ... PIC  IMR: ffff
[    2.367555] ... PIC  IRR: 1113
[    2.367820] ... PIC  ISR: 0000
[    2.368083] ... PIC ELCR: 0c00
[    2.368373] printing local APIC contents on CPU#0/0:
[    2.369095] ... APIC ID:      00000000 (0)
[    2.369460] ... APIC VERSION: 00050014
[    2.369780] ... APIC TASKPRI: 00000000 (00)
[    2.370303] ... APIC PROCPRI: 00000000
[    2.370466] ... APIC LDR: 01000000
[    2.370466] ... APIC DFR: ffffffff
[    2.370466] ... APIC SPIV: 000001ff
[    2.370466] ... APIC ISR field:
[    2.370466] 000000000000000000000000000000000000000000000000000000000000=
0000
[    2.370466] ... APIC TMR field:
[    2.370466] 000000000200000000000000000000000000000000000000000000000000=
0000
[    2.370466] ... APIC IRR field:
[    2.370466] 000000000000000000000000000000000000000000000000000000000000=
8000
[    2.370466] ... APIC ESR: 00000000
[    2.370466] ... APIC ICR: 000008fd
[    2.370466] ... APIC ICR2: 02000000
[    2.370466] ... APIC LVTT: 000200ef
[    2.370466] ... APIC LVTPC: 00010000
[    2.370466] ... APIC LVT0: 00010700
[    2.370466] ... APIC LVT1: 00000400
[    2.370466] ... APIC LVTERR: 000000fe
[    2.370466] ... APIC TMICT: 0003d0ab
[    2.370466] ... APIC TMCCT: 000337da
[    2.370466] ... APIC TDCR: 00000003
[    2.370466]=20
[    2.379844] number of MP IRQ sources: 15.
[    2.380338] number of IO-APIC #0 registers: 24.
[    2.380890] testing the IO APIC.......................
[    2.381583] IO APIC #0......
[    2.381949] .... register #00: 00000000
[    2.382437] .......    : physical APIC id: 00
[    2.382970] .......    : Delivery Type: 0
[    2.383337] .......    : LTS          : 0
[    2.383669] .... register #01: 00170011
[    2.383988] .......     : max redirection entries: 17
[    2.384503] .......     : PRQ implemented: 0
[    2.385030] .......     : IO APIC version: 11
[    2.385573] .... register #02: 00000000
[    2.386062] .......     : arbitration: 00
[    2.386585] .... IRQ redirection table:
[    2.387105] 1    0    0   0   0    0    0    00
[    2.387683] 0    0    0   0   0    1    1    31
[    2.388264] 0    0    0   0   0    1    1    30
[    2.388839] 0    0    0   0   0    1    1    33
[    2.389344] 1    0    0   0   0    1    1    34
[    2.389730] 1    1    0   0   0    1    1    35
[    2.390329] 0    0    0   0   0    1    1    36
[    2.390926] 0    0    0   0   0    1    1    37
[    2.391538] 0    0    0   0   0    1    1    38
[    2.392124] 0    1    0   0   0    1    1    39
[    2.392624] 1    1    0   0   0    1    1    3A
[    2.393007] 1    1    0   0   0    1    1    3B
[    2.393389] 0    0    0   0   0    1    1    3C
[    2.393826] 0    0    0   0   0    1    1    3D
[    2.394439] 0    0    0   0   0    1    1    3E
[    2.395054] 0    0    0   0   0    1    1    3F
[    2.395640] 1    0    0   0   0    0    0    00
[    2.396221] 1    0    0   0   0    0    0    00
[    2.396800] 1    0    0   0   0    0    0    00
[    2.397384] 1    0    0   0   0    0    0    00
[    2.397978] 1    0    0   0   0    0    0    00
[    2.398581] 1    0    0   0   0    0    0    00
[    2.399006] 1    0    0   0   0    0    0    00
[    2.399429] 1    0    0   0   0    0    0    00
[    2.400001] IRQ to pin mappings:
[    2.400410] IRQ0 -> 0:2
[    2.400759] IRQ1 -> 0:1
[    2.401108] IRQ3 -> 0:3
[    2.401461] IRQ4 -> 0:4
[    2.401824] IRQ5 -> 0:5
[    2.402065] IRQ6 -> 0:6
[    2.402309] IRQ7 -> 0:7
[    2.402590] IRQ8 -> 0:8
[    2.402835] IRQ9 -> 0:9
[    2.403077] IRQ10 -> 0:10
[    2.403450] IRQ11 -> 0:11
[    2.403819] IRQ12 -> 0:12
[    2.404195] IRQ13 -> 0:13
[    2.404574] IRQ14 -> 0:14
[    2.404949] IRQ15 -> 0:15
[    2.405319] .................................... done.
[    2.405948] Using IPI No-Shortcut mode
[   10.376683] Unregister pv shared memory for cpu 0
[   10.388424] BUG: unable to handle kernel NULL pointer dereference at 000=
00040
[   10.389307] IP: [<cc65d2c2>] pick_next_task+0xa/0x48
[   10.389880] *pdpt =3D 0000000000000000 *pde =3D f000ff53f000ff53=20
[   10.390617] Oops: 0000 [#1] SMP DEBUG_PAGEALLOC
[   10.390948] CPU: 0 PID: 9 Comm: migration/0 Not tainted 3.14.0-rc2-next-=
20140214-03226-gda8d308 #1
[   10.390948] task: cc05d580 ti: cc09c000 task.ti: cc09c000
[   10.390948] EIP: 0060:[<cc65d2c2>] EFLAGS: 00010046 CPU: 0
[   10.390948] EIP is at pick_next_task+0xa/0x48
[   10.390948] EAX: cfcae100 EBX: cfcae100 ECX: 00000002 EDX: 00000000
[   10.390948] ESI: cfcae100 EDI: 00000000 EBP: cc09ddc0 ESP: cc09ddb4
[   10.390948]  DS: 007b ES: 007b FS: 00d8 GS: 0000 SS: 0068
[   10.390948] CR0: 8005003b CR2: 00000040 CR3: 0cd73000 CR4: 000006b0
[   10.390948] Stack:
[   10.390948]  cfcae100 cfcae100 ccc5b930 cc09dde4 cc661de5 00000200 cc05d=
580 00000082
[   10.390948]  00000000 ccc5c864 00000000 ccc5b930 cc09de00 cc659574 00000=
000 00000008
[   10.390948]  ffffffff cc055e6c 00000000 cc09de14 cc65982c fffffffb 00000=
000 00000000
[   10.390948] Call Trace:
[   10.390948]  [<cc661de5>] migration_call+0x10b/0x188
[   10.390948]  [<cc659574>] notifier_call_chain+0x32/0x4b
[   10.390948]  [<cc65982c>] __raw_notifier_call_chain+0x1e/0x23
[   10.390948]  [<cc63d7b1>] __cpu_notify+0x24/0x3e
[   10.390948]  [<cc63d7e3>] cpu_notify+0x18/0x1a
[   10.390948]  [<cc9f693d>] take_cpu_down+0x22/0x32
[   10.390948]  [<cc69b491>] multi_cpu_stop+0x80/0xce
[   10.390948]  [<cc69b411>] ? __stop_cpus+0x55/0x55
[   10.390948]  [<cc69b240>] cpu_stopper_thread+0x80/0x111
[   10.390948]  [<cc65cbd5>] ? finish_task_switch+0x33/0xba
[   10.390948]  [<cc9ff35e>] ? __schedule+0x377/0x55e
[   10.390948]  [<cc67368b>] ? __lock_acquire.isra.27+0x1be/0x4dd
[   10.390948]  [<cc673c81>] ? lock_acquire+0x93/0xe0
[   10.390948]  [<cc674039>] ? lock_release+0x16d/0x1b1
[   10.390948]  [<cca02421>] ? _raw_spin_unlock_irqrestore+0x44/0x4f
[   10.390948]  [<cc65b444>] smpboot_thread_fn+0x15d/0x173
[   10.390948]  [<cc65b2e7>] ? smpboot_unpark_thread+0x2e/0x2e
[   10.390948]  [<cc656225>] kthread+0x8d/0x92
[   10.390948]  [<cc650000>] ? __queue_work+0xb6/0x205
[   10.390948]  [<cca03677>] ret_from_kernel_thread+0x1b/0x28
[   10.390948]  [<cc656198>] ? __kthread_parkme+0x55/0x55
[   10.390948] Code: 00 ba 01 00 00 00 89 f0 eb 0e 89 f0 e8 b9 4f 3a 00 ba =
01 00 00 00 89 d8 e8 04 57 3a 00 5b 5e 5d c3 55 89 e5 57 89 d7 56 89 c6 53 =
<81> 7a 40 74 03 a1 cc 74 07 bb a0 04 a1 cc eb 23 8b 40 6c 39 46
[   10.390948] EIP: [<cc65d2c2>] pick_next_task+0xa/0x48 SS:ESP 0068:cc09dd=
b4
[   10.390948] CR2: 0000000000000040
[   10.390948] ---[ end trace a546538b11268dcc ]---
[   10.390948] Kernel panic - not syncing: Fatal exception
[   10.390948] Kernel Offset: 0xb600000 from 0xc1000000 (relocation range: =
0xc0000000-0xd07fdfff)
[   10.390948] Rebooting in 10 seconds..
Elapsed time: 15
qemu-system-x86_64 -cpu kvm64 -enable-kvm -kernel /kernel/i386-randconfig-x=
1-02152208/da8d308fbdb8360078786b3e125238122c4fc611/vmlinuz-3.14.0-rc2-next=
-20140214-03226-gda8d308 -append 'hung_task_panic=3D1 earlyprintk=3DttyS0,1=
15200 debug apic=3Ddebug sysrq_always_enabled panic=3D10 softlockup_panic=
=3D1 nmi_watchdog=3Dpanic  prompt_ramdisk=3D0 console=3DttyS0,115200 consol=
e=3Dtty0 vga=3Dnormal  root=3D/dev/ram0 rw link=3D/kernel-tests/run-queue/k=
vm/i386-randconfig-x1-02152208/next:master/.vmlinuz-da8d308fbdb8360078786b3=
e125238122c4fc611-20140215221646-9-lkp-sbx04 branch=3Dnext/master BOOT_IMAG=
E=3D/kernel/i386-randconfig-x1-02152208/da8d308fbdb8360078786b3e125238122c4=
fc611/vmlinuz-3.14.0-rc2-next-20140214-03226-gda8d308'  -initrd /kernel-tes=
ts/initrd/yocto-minimal-i386.cgz -m 256 -smp 2 -net nic,vlan=3D1,model=3De1=
000 -net user,vlan=3D1,hostfwd=3Dtcp::7988-:22 -boot order=3Dnc -no-reboot =
-watchdog i6300esb -rtc base=3Dlocaltime -pidfile /dev/shm/kboot/pid-yocto-=
lkp-sbx04-56 -serial file:/dev/shm/kboot/serial-yocto-lkp-sbx04-56 -daemoni=
ze -display none -monitor null=20

--OgqxwSJOaUobr8KG
Content-Type: application/octet-stream
Content-Disposition: attachment; filename="i386-randconfig-x1-02152208-da8d308fbdb8360078786b3e125238122c4fc611-EIP-is-at-pick_next_task+-x-24028.log"
Content-Transfer-Encoding: base64

Z2l0IGNoZWNrb3V0IDVkMWNhYTM4NWYxNjc1Y2FmMDllMTNhZmNkMmIxZGI3YTFjOWI4ZTgK
bHMgLWEgL2tlcm5lbC10ZXN0cy9ydW4tcXVldWUva3ZtL2kzODYtcmFuZGNvbmZpZy14MS0w
MjE1MjIwOC9uZXh0Om1hc3Rlcjo1ZDFjYWEzODVmMTY3NWNhZjA5ZTEzYWZjZDJiMWRiN2Ex
YzliOGU4OmJpc2VjdC1saW51eAoyMDE0LTAyLTE2IDIzOjE0OjU1OiBjbWRfZmFpbDogJy9i
aW4vZ3JlcCcgJy1yJyAnLS1pbmNsdWRlPWRtZXNnLSonICctcycgJy1sJyAnRUlQIGlzIGF0
IHBpY2tfbmV4dF90YXNrKzB4JyAnL2tlcm5lbC9pMzg2LXJhbmRjb25maWcteDEtMDIxNTIy
MDgvNWQxY2FhMzg1ZjE2NzVjYWYwOWUxM2FmY2QyYjFkYjdhMWM5YjhlOCcgLCByZXQ9Miwg
cmVmOiAva2VybmVsLXRlc3RzL2ZhaWxlZC1jbWQvYmVlLWdyZXAta2J1aWxkLmxvZwoKMjAx
NC0wMi0xNi0yMzoxNDo1NSA1ZDFjYWEzODVmMTY3NWNhZjA5ZTEzYWZjZDJiMWRiN2ExYzli
OGU4IGNvbXBpbGluZwo0NCByZWFsICA3NDAgdXNlciAgNTIgc3lzICAxNzY5LjExJSBjcHUg
CWkzODYtcmFuZGNvbmZpZy14MS0wMjE1MjIwOAoKMjAxNC0wMi0xNi0yMzoxNTo0OSBkZXRl
Y3RpbmcgYm9vdCBzdGF0ZSAzLjE0LjAtcmMyLTAzMDIxLWc1ZDFjYWEzLi4uLi4uLi4uLi4u
IFRFU1QgRkFJTFVSRQpbICAgIDIuMTkzNzIzXSAuLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4u
Li4uLi4uLi4uLi4gZG9uZS4KWyAgICAyLjE5NDU4NV0gVXNpbmcgSVBJIE5vLVNob3J0Y3V0
IG1vZGUKWyAgICAyLjE5NjMyOV0gVW5yZWdpc3RlciBwdiBzaGFyZWQgbWVtb3J5IGZvciBj
cHUgMApbICAgIDIuMjExODM4XSBCVUc6IHVuYWJsZSB0byBoYW5kbGUga2VybmVsIE5VTEwg
cG9pbnRlciBkZXJlZmVyZW5jZSBhdCAwMDAwMDA0MApbICAgIDIuMjEzMDcwXSBJUDogWzxk
MDA1ZDJmZD5dIHBpY2tfbmV4dF90YXNrKzB4YS8weDQ4ClsgICAgMi4yMTM4MTJdICpwZHB0
ID0gMDAwMDAwMDAwMDAwMDAwMCAqcGRlID0gZjAwMGZmNTNmMDAwZmY1MyAKWyAgICAyLjIx
NDI2Nl0gT29wczogMDAwMCBbIzFdIFNNUCBERUJVR19QQUdFQUxMT0MKWyAgICAyLjIxNDI2
Nl0gQ1BVOiAwIFBJRDogOSBDb21tOiBtaWdyYXRpb24vMCBOb3QgdGFpbnRlZCAzLjE0LjAt
cmMyLTAzMDIxLWc1ZDFjYWEzICMxMDEKWyAgICAyLjIxNDI2Nl0gdGFzazogY2ZjNWQ1ODAg
dGk6IGNmYzljMDAwIHRhc2sudGk6IGNmYzljMDAwClsgICAgMi4yMTQyNjZdIEVJUDogMDA2
MDpbPGQwMDVkMmZkPl0gRUZMQUdTOiAwMDAxMDA0NiBDUFU6IDAKWyAgICAyLjIxNDI2Nl0g
RUlQIGlzIGF0IHBpY2tfbmV4dF90YXNrKzB4YS8weDQ4ClsgICAgMi4yMTQyNjZdIEVBWDog
ZDNjYWUxMDAgRUJYOiBkM2NhZTEwMCBFQ1g6IDAwMDAwMDAwIEVEWDogMDAwMDAwMDAKWyAg
ICAyLjIxNDI2Nl0gRVNJOiBkM2NhZTEwMCBFREk6IDAwMDAwMDAwIEVCUDogY2ZjOWRkYzAg
RVNQOiBjZmM5ZGRiNApbICAgIDIuMjE0MjY2XSAgRFM6IDAwN2IgRVM6IDAwN2IgRlM6IDAw
ZDggR1M6IDAwMDAgU1M6IDAwNjgKWyAgICAyLjIxNDI2Nl0gQ1IwOiA4MDA1MDAzYiBDUjI6
IDAwMDAwMDQwIENSMzogMTA3NzAwMDAgQ1I0OiAwMDAwMDZiMApbICAgIDIuMjE0MjY2XSBT
dGFjazoKWyAgICAyLjIxNDI2Nl0gIGQzY2FlMTAwIGQzY2FlMTAwIGQwNjU5OTMwIGNmYzlk
ZGU0IGQwMDYxZTJlIDAwMDAwMjAwIGNmYzVkNTgwIDAwMDAwMDgyClsgICAgMi4yMTQyNjZd
ICAwMDAwMDAwMCBkMDY1YTg2NCAwMDAwMDAwMCBkMDY1OTkzMCBjZmM5ZGUwMCBkMDA1OTVh
OCAwMDAwMDAwMCAwMDAwMDAwOApbICAgIDIuMjE0MjY2XSAgZmZmZmZmZmYgY2ZjNTVlNmMg
MDAwMDAwMDAgY2ZjOWRlMTQgZDAwNTk4NjAgZmZmZmZmZmIgMDAwMDAwMDAgMDAwMDAwMDAK
WyAgICAyLjIxNDI2Nl0gQ2FsbCBUcmFjZToKWyAgICAyLjIxNDI2Nl0gIFs8ZDAwNjFlMmU+
XSBtaWdyYXRpb25fY2FsbCsweDEwYi8weDE4OApbICAgIDIuMjE0MjY2XSAgWzxkMDA1OTVh
OD5dIG5vdGlmaWVyX2NhbGxfY2hhaW4rMHgzMi8weDRiClsgICAgMi4yMTQyNjZdICBbPGQw
MDU5ODYwPl0gX19yYXdfbm90aWZpZXJfY2FsbF9jaGFpbisweDFlLzB4MjMKWyAgICAyLjIx
NDI2Nl0gIFs8ZDAwM2Q4MDE+XSBfX2NwdV9ub3RpZnkrMHgyNC8weDNlClsgICAgMi4yMTQy
NjZdICBbPGQwMDNkODMzPl0gY3B1X25vdGlmeSsweDE4LzB4MWEKWyAgICAyLjIxNDI2Nl0g
IFs8ZDAzZjY1ZGQ+XSB0YWtlX2NwdV9kb3duKzB4MjIvMHgzMgpbICAgIDIuMjE0MjY2XSAg
WzxkMDA5YjRlND5dIG11bHRpX2NwdV9zdG9wKzB4ODAvMHhjZQpbICAgIDIuMjE0MjY2XSAg
WzxkMDA5YjQ2ND5dID8gX19zdG9wX2NwdXMrMHg1NS8weDU1ClsgICAgMi4yMTQyNjZdICBb
PGQwMDliMjkzPl0gY3B1X3N0b3BwZXJfdGhyZWFkKzB4ODAvMHgxMTEKWyAgICAyLjIxNDI2
Nl0gIFs8ZDAwNzM2ZTc+XSA/IF9fbG9ja19hY3F1aXJlLmlzcmEuMjcrMHgxYzUvMHg0ZTQK
WyAgICAyLjIxNDI2Nl0gIFs8ZDAzZmVmYzQ+XSA/IF9fc2NoZWR1bGUrMHgzNzUvMHg1NWMK
WyAgICAyLjIxNDI2Nl0gIFs8ZDAwNzNjZGI+XSA/IGxvY2tfYWNxdWlyZSsweDkzLzB4ZTAK
WyAgICAyLjIxNDI2Nl0gIFs8ZDAwNzQwOTM+XSA/IGxvY2tfcmVsZWFzZSsweDE2ZC8weDFi
MQpbICAgIDIuMjE0MjY2XSAgWzxkMDQwMjA4MT5dID8gX3Jhd19zcGluX3VubG9ja19pcnFy
ZXN0b3JlKzB4NDQvMHg0ZgpbICAgIDIuMjE0MjY2XSAgWzxkMDA1YjQ3OD5dIHNtcGJvb3Rf
dGhyZWFkX2ZuKzB4MTVkLzB4MTczClsgICAgMi4yMTQyNjZdICBbPGQwMDViMzFiPl0gPyBz
bXBib290X3VucGFya190aHJlYWQrMHgyZS8weDJlClsgICAgMi4yMTQyNjZdICBbPGQwMDU2
Mjc2Pl0ga3RocmVhZCsweDhkLzB4OTIKWyAgICAyLjIxNDI2Nl0gIFs8ZDAwNTAwMDA+XSA/
IF9fcXVldWVfd29yaysweDY1LzB4MjA1ClsgICAgMi4yMTQyNjZdICBbPGQwNDAzMmI3Pl0g
cmV0X2Zyb21fa2VybmVsX3RocmVhZCsweDFiLzB4MjgKWyAgICAyLjIxNDI2Nl0gIFs8ZDAw
NTYxZTk+XSA/IF9fa3RocmVhZF9wYXJrbWUrMHg1NS8weDU1ClsgICAgMi4yMTQyNjZdIENv
ZGU6IDAwIGJhIDAxIDAwIDAwIDAwIDg5IGYwIGViIDBlIDg5IGYwIGU4IGRlIDRiIDNhIDAw
IGJhIDAxIDAwIDAwIDAwIDg5IGQ4IGU4IDI5IDUzIDNhIDAwIDViIDVlIDVkIGMzIDU1IDg5
IGU1IDU3IDg5IGQ3IDU2IDg5IGM2IDUzIDw4MT4gN2EgNDAgNzQgMDMgNDEgZDAgNzQgMDcg
YmIgYTAgMDQgNDEgZDAgZWIgMjMgOGIgNDAgNmMgMzkgNDYKWyAgICAyLjIxNDI2Nl0gRUlQ
OiBbPGQwMDVkMmZkPl0gcGlja19uZXh0X3Rhc2srMHhhLzB4NDggU1M6RVNQIDAwNjg6Y2Zj
OWRkYjQKWyAgICAyLjIxNDI2Nl0gQ1IyOiAwMDAwMDAwMDAwMDAwMDQwClsgICAgMi4yMTQy
NjZdIC0tLVsgZW5kIHRyYWNlIDliNTgzYjc4MDNjYzMyYzYgXS0tLQpbICAgIDIuMjE0MjY2
XSBLZXJuZWwgcGFuaWMgLSBub3Qgc3luY2luZzogRmF0YWwgZXhjZXB0aW9uCi9rZXJuZWwv
aTM4Ni1yYW5kY29uZmlnLXgxLTAyMTUyMjA4LzVkMWNhYTM4NWYxNjc1Y2FmMDllMTNhZmNk
MmIxZGI3YTFjOWI4ZTgvZG1lc2cteW9jdG8teGlhbi01NjoyMDE0MDIxNjIzMjEzMzppMzg2
LXJhbmRjb25maWcteDEtMDIxNTIyMDg6My4xNC4wLXJjMi0wMzAyMS1nNWQxY2FhMzoxMDEK
MDoxOjEgYWxsX2dvb2Q6YmFkOmFsbF9iYWQgYm9vdHMKCmJpc2VjdDogYmFkIGNvbW1pdCA1
ZDFjYWEzODVmMTY3NWNhZjA5ZTEzYWZjZDJiMWRiN2ExYzliOGU4CmdpdCBjaGVja291dCB2
My4xMwpscyAtYSAva2VybmVsLXRlc3RzL3J1bi1xdWV1ZS9rdm0vaTM4Ni1yYW5kY29uZmln
LXgxLTAyMTUyMjA4L25leHQ6bWFzdGVyOmQ4ZWMyNmQ3ZjgyODdmNTc4OGE0OTRmNTZlODgx
NDIxMGYwZTY0YmU6YmlzZWN0LWxpbnV4CjIwMTQtMDItMTYgMjM6MjE6NTI6IGNtZF9mYWls
OiAnL2Jpbi9ncmVwJyAnLXInICctLWluY2x1ZGU9ZG1lc2ctKicgJy1zJyAnLWwnICdFSVAg
aXMgYXQgcGlja19uZXh0X3Rhc2srMHgnICcva2VybmVsL2kzODYtcmFuZGNvbmZpZy14MS0w
MjE1MjIwOC9kOGVjMjZkN2Y4Mjg3ZjU3ODhhNDk0ZjU2ZTg4MTQyMTBmMGU2NGJlJyAsIHJl
dD0yLCByZWY6IC9rZXJuZWwtdGVzdHMvZmFpbGVkLWNtZC9iZWUtZ3JlcC1rYnVpbGQubG9n
CgoyMDE0LTAyLTE2LTIzOjIxOjUyIGQ4ZWMyNmQ3ZjgyODdmNTc4OGE0OTRmNTZlODgxNDIx
MGYwZTY0YmUgY29tcGlsaW5nCjQxIHJlYWwgIDczMyB1c2VyICA1MiBzeXMgIDE5MTIuMDkl
IGNwdSAJaTM4Ni1yYW5kY29uZmlnLXgxLTAyMTUyMjA4CgoyMDE0LTAyLTE2LTIzOjIyOjM5
IGRldGVjdGluZyBib290IHN0YXRlIDMuMTMuMC4JMgkzCTQJNy4uLgk5CTEwCTEzCTE1CTE2
CTE5Li4JMjAJMjEJMjIgU1VDQ0VTUwoKYmlzZWN0OiBnb29kIGNvbW1pdCB2My4xMwpnaXQg
YmlzZWN0IHN0YXJ0IDVkMWNhYTM4NWYxNjc1Y2FmMDllMTNhZmNkMmIxZGI3YTFjOWI4ZTgg
djMuMTMgLS0KL2Mva2VybmVsLXRlc3RzL2xpbmVhci1iaXNlY3Q6IFsiLWIiLCAiNWQxY2Fh
Mzg1ZjE2NzVjYWYwOWUxM2FmY2QyYjFkYjdhMWM5YjhlOCIsICItZyIsICJ2My4xMyIsICIv
Yy9rZXJuZWwtdGVzdHMvYmlzZWN0LXRlc3QtYm9vdC1mYWlsdXJlLnNoIiwgIi9rZXJuZWwt
dGVzdHMvbGludXgvb2JqLWJpc2VjdCJdCkJpc2VjdGluZzogMTQ2MDAgcmV2aXNpb25zIGxl
ZnQgdG8gdGVzdCBhZnRlciB0aGlzIChyb3VnaGx5IDE0IHN0ZXBzKQpbNTk1YmY5OTllM2E4
NjRmNDBlMDQ5YzY3YzQyZWNlZTUwZmI3YTc4YV0gTWVyZ2UgYnJhbmNoICdzY2hlZC11cmdl
bnQtZm9yLWxpbnVzJyBvZiBnaXQ6Ly9naXQua2VybmVsLm9yZy9wdWIvc2NtL2xpbnV4L2tl
cm5lbC9naXQvdGlwL3RpcApydW5uaW5nIC9jL2tlcm5lbC10ZXN0cy9iaXNlY3QtdGVzdC1i
b290LWZhaWx1cmUuc2ggL2tlcm5lbC10ZXN0cy9saW51eC9vYmotYmlzZWN0CmxzIC1hIC9r
ZXJuZWwtdGVzdHMvcnVuLXF1ZXVlL2t2bS9pMzg2LXJhbmRjb25maWcteDEtMDIxNTIyMDgv
bmV4dDptYXN0ZXI6NTk1YmY5OTllM2E4NjRmNDBlMDQ5YzY3YzQyZWNlZTUwZmI3YTc4YTpi
aXNlY3QtbGludXgKMjAxNC0wMi0xNiAyMzozMjoxMjogY21kX2ZhaWw6ICcvYmluL2dyZXAn
ICctcicgJy0taW5jbHVkZT1kbWVzZy0qJyAnLXMnICctbCcgJ0VJUCBpcyBhdCBwaWNrX25l
eHRfdGFzaysweCcgJy9rZXJuZWwvaTM4Ni1yYW5kY29uZmlnLXgxLTAyMTUyMjA4LzU5NWJm
OTk5ZTNhODY0ZjQwZTA0OWM2N2M0MmVjZWU1MGZiN2E3OGEnICwgcmV0PTIsIHJlZjogL2tl
cm5lbC10ZXN0cy9mYWlsZWQtY21kL2JlZS1ncmVwLWtidWlsZC5sb2cKCjIwMTQtMDItMTYt
MjM6MzI6MTMgNTk1YmY5OTllM2E4NjRmNDBlMDQ5YzY3YzQyZWNlZTUwZmI3YTc4YSBjb21w
aWxpbmcKNDUgcmVhbCAgNzQyIHVzZXIgIDUzIHN5cyAgMTc1NS42OSUgY3B1IAlpMzg2LXJh
bmRjb25maWcteDEtMDIxNTIyMDgKCjIwMTQtMDItMTYtMjM6MzM6MDYgZGV0ZWN0aW5nIGJv
b3Qgc3RhdGUgMy4xMy4wLTEwNzA2LWc1OTViZjk5Li4JMQk1CTcJMTMJMTUJMTcuCTE4CTIx
CTIyIFNVQ0NFU1MKCkJpc2VjdGluZzogMzg5NCByZXZpc2lvbnMgbGVmdCB0byB0ZXN0IGFm
dGVyIHRoaXMgKHJvdWdobHkgMTIgc3RlcHMpCls1NTE3N2MxNzEyMDBkODQxY2RjMjM2MDNm
MTk2ZTIxYTJkNjY0YzhmXSBNZXJnZSByZW1vdGUtdHJhY2tpbmcgYnJhbmNoICdhcm0tcGVy
Zi9mb3ItbmV4dC9wZXJmJwpydW5uaW5nIC9jL2tlcm5lbC10ZXN0cy9iaXNlY3QtdGVzdC1i
b290LWZhaWx1cmUuc2ggL2tlcm5lbC10ZXN0cy9saW51eC9vYmotYmlzZWN0CmxzIC1hIC9r
ZXJuZWwtdGVzdHMvcnVuLXF1ZXVlL2t2bS9pMzg2LXJhbmRjb25maWcteDEtMDIxNTIyMDgv
bmV4dDptYXN0ZXI6NTUxNzdjMTcxMjAwZDg0MWNkYzIzNjAzZjE5NmUyMWEyZDY2NGM4Zjpi
aXNlY3QtbGludXgKMjAxNC0wMi0xNiAyMzozOTowODogY21kX2ZhaWw6ICcvYmluL2dyZXAn
ICctcicgJy0taW5jbHVkZT1kbWVzZy0qJyAnLXMnICctbCcgJ0VJUCBpcyBhdCBwaWNrX25l
eHRfdGFzaysweCcgJy9rZXJuZWwvaTM4Ni1yYW5kY29uZmlnLXgxLTAyMTUyMjA4LzU1MTc3
YzE3MTIwMGQ4NDFjZGMyMzYwM2YxOTZlMjFhMmQ2NjRjOGYnICwgcmV0PTIsIHJlZjogL2tl
cm5lbC10ZXN0cy9mYWlsZWQtY21kL2JlZS1ncmVwLWtidWlsZC5sb2cKCjIwMTQtMDItMTYt
MjM6Mzk6MDggNTUxNzdjMTcxMjAwZDg0MWNkYzIzNjAzZjE5NmUyMWEyZDY2NGM4ZiBjb21w
aWxpbmcKNDkgcmVhbCAgNzAwIHVzZXIgIDQ5IHN5cyAgMTUwNC41NiUgY3B1IAlpMzg2LXJh
bmRjb25maWcteDEtMDIxNTIyMDgKCjIwMTQtMDItMTYtMjM6NDA6MDQgZGV0ZWN0aW5nIGJv
b3Qgc3RhdGUgMy4xNC4wLXJjMi0wMDQ5Ny1nNTUxNzdjMS4uLi4JMi4JOQkxMwkxNgkxOAky
MC4uLgkyMiBTVUNDRVNTCgpCaXNlY3Rpbmc6IDI1MjQgcmV2aXNpb25zIGxlZnQgdG8gdGVz
dCBhZnRlciB0aGlzIChyb3VnaGx5IDEyIHN0ZXBzKQpbMTI5MTU1MjIwMjc1MjU4ODBjOGZk
ZDNmZTA4YTdjOGE3NDIxM2YzMV0gTWVyZ2UgcmVtb3RlLXRyYWNraW5nIGJyYW5jaCAnd2ly
ZWxlc3MtbmV4dC9tYXN0ZXInCnJ1bm5pbmcgL2Mva2VybmVsLXRlc3RzL2Jpc2VjdC10ZXN0
LWJvb3QtZmFpbHVyZS5zaCAva2VybmVsLXRlc3RzL2xpbnV4L29iai1iaXNlY3QKbHMgLWEg
L2tlcm5lbC10ZXN0cy9ydW4tcXVldWUva3ZtL2kzODYtcmFuZGNvbmZpZy14MS0wMjE1MjIw
OC9uZXh0Om1hc3RlcjoxMjkxNTUyMjAyNzUyNTg4MGM4ZmRkM2ZlMDhhN2M4YTc0MjEzZjMx
OmJpc2VjdC1saW51eAoyMDE0LTAyLTE2IDIzOjQ3OjM2OiBjbWRfZmFpbDogJy9iaW4vZ3Jl
cCcgJy1yJyAnLS1pbmNsdWRlPWRtZXNnLSonICctcycgJy1sJyAnRUlQIGlzIGF0IHBpY2tf
bmV4dF90YXNrKzB4JyAnL2tlcm5lbC9pMzg2LXJhbmRjb25maWcteDEtMDIxNTIyMDgvMTI5
MTU1MjIwMjc1MjU4ODBjOGZkZDNmZTA4YTdjOGE3NDIxM2YzMScgLCByZXQ9MiwgcmVmOiAv
a2VybmVsLXRlc3RzL2ZhaWxlZC1jbWQvYmVlLWdyZXAta2J1aWxkLmxvZwoKMjAxNC0wMi0x
Ni0yMzo0NzozNiAxMjkxNTUyMjAyNzUyNTg4MGM4ZmRkM2ZlMDhhN2M4YTc0MjEzZjMxIGNv
bXBpbGluZwo1NSByZWFsICA2NzYgdXNlciAgNDcgc3lzICAxMzAzLjY0JSBjcHUgCWkzODYt
cmFuZGNvbmZpZy14MS0wMjE1MjIwOAoKMjAxNC0wMi0xNi0yMzo0ODozOSBkZXRlY3Rpbmcg
Ym9vdCBzdGF0ZSAzLjE0LjAtcmMyLTAxNzI1LWcxMjkxNTUyLgkyLgk0CTUJOS4uLi4uLi4u
Li4uLi4uLi4uLi4uLi4uLi4uLgkxNAkxNgkyMiBTVUNDRVNTCgpCaXNlY3Rpbmc6IDEyOTYg
cmV2aXNpb25zIGxlZnQgdG8gdGVzdCBhZnRlciB0aGlzIChyb3VnaGx5IDExIHN0ZXBzKQpb
Y2I2MjhjMjc1ZGNkOGJiZGQ2MWRmMmQ5NjM1NWE4OGU5NmEyNmMwNF0gTWVyZ2UgcmVtb3Rl
LXRyYWNraW5nIGJyYW5jaCAnc2VsaW51eC9uZXh0JwpydW5uaW5nIC9jL2tlcm5lbC10ZXN0
cy9iaXNlY3QtdGVzdC1ib290LWZhaWx1cmUuc2ggL2tlcm5lbC10ZXN0cy9saW51eC9vYmot
YmlzZWN0CmxzIC1hIC9rZXJuZWwtdGVzdHMvcnVuLXF1ZXVlL2t2bS9pMzg2LXJhbmRjb25m
aWcteDEtMDIxNTIyMDgvbmV4dDptYXN0ZXI6Y2I2MjhjMjc1ZGNkOGJiZGQ2MWRmMmQ5NjM1
NWE4OGU5NmEyNmMwNDpiaXNlY3QtbGludXgKMjAxNC0wMi0xNyAwMDowNjo0MTogY21kX2Zh
aWw6ICcvYmluL2dyZXAnICctcicgJy0taW5jbHVkZT1kbWVzZy0qJyAnLXMnICctbCcgJ0VJ
UCBpcyBhdCBwaWNrX25leHRfdGFzaysweCcgJy9rZXJuZWwvaTM4Ni1yYW5kY29uZmlnLXgx
LTAyMTUyMjA4L2NiNjI4YzI3NWRjZDhiYmRkNjFkZjJkOTYzNTVhODhlOTZhMjZjMDQnICwg
cmV0PTIsIHJlZjogL2tlcm5lbC10ZXN0cy9mYWlsZWQtY21kL2JlZS1ncmVwLWtidWlsZC5s
b2cKCjIwMTQtMDItMTctMDA6MDY6NDEgY2I2MjhjMjc1ZGNkOGJiZGQ2MWRmMmQ5NjM1NWE4
OGU5NmEyNmMwNCBjb21waWxpbmcKNDYgcmVhbCAgNjI4IHVzZXIgIDQyIHN5cyAgMTQzMi4w
OSUgY3B1IAlpMzg2LXJhbmRjb25maWcteDEtMDIxNTIyMDgKCjIwMTQtMDItMTctMDA6MDc6
MzYgZGV0ZWN0aW5nIGJvb3Qgc3RhdGUgMy4xNC4wLXJjMi0wMjM1Ny1nY2I2MjhjMi4uLi4u
Li4uLi4uLi4JMi4JNi4uCTcuLi4JOAkxMAkxMgkxNwkxOQkyMiBTVUNDRVNTCgpCaXNlY3Rp
bmc6IDY2NCByZXZpc2lvbnMgbGVmdCB0byB0ZXN0IGFmdGVyIHRoaXMgKHJvdWdobHkgMTAg
c3RlcHMpClszYzE1MzBkNjEwMTExOGUzYTAyNTExNDg4M2YwMzU3OGQ0ZGI0YjY2XSBNZXJn
ZSByZW1vdGUtdHJhY2tpbmcgYnJhbmNoICdyZWdtYXAvZm9yLW5leHQnCnJ1bm5pbmcgL2Mv
a2VybmVsLXRlc3RzL2Jpc2VjdC10ZXN0LWJvb3QtZmFpbHVyZS5zaCAva2VybmVsLXRlc3Rz
L2xpbnV4L29iai1iaXNlY3QKbHMgLWEgL2tlcm5lbC10ZXN0cy9ydW4tcXVldWUva3ZtL2kz
ODYtcmFuZGNvbmZpZy14MS0wMjE1MjIwOC9uZXh0Om1hc3RlcjozYzE1MzBkNjEwMTExOGUz
YTAyNTExNDg4M2YwMzU3OGQ0ZGI0YjY2OmJpc2VjdC1saW51eAoyMDE0LTAyLTE3IDAwOjIx
OjM4OiBjbWRfZmFpbDogJy9iaW4vZ3JlcCcgJy1yJyAnLS1pbmNsdWRlPWRtZXNnLSonICct
cycgJy1sJyAnRUlQIGlzIGF0IHBpY2tfbmV4dF90YXNrKzB4JyAnL2tlcm5lbC9pMzg2LXJh
bmRjb25maWcteDEtMDIxNTIyMDgvM2MxNTMwZDYxMDExMThlM2EwMjUxMTQ4ODNmMDM1Nzhk
NGRiNGI2NicgLCByZXQ9MiwgcmVmOiAva2VybmVsLXRlc3RzL2ZhaWxlZC1jbWQvYmVlLWdy
ZXAta2J1aWxkLmxvZwoKMjAxNC0wMi0xNy0wMDoyMTozOCAzYzE1MzBkNjEwMTExOGUzYTAy
NTExNDg4M2YwMzU3OGQ0ZGI0YjY2IGNvbXBpbGluZwo1OSByZWFsICA3MjkgdXNlciAgNTEg
c3lzICAxMzE0LjEzJSBjcHUgCWkzODYtcmFuZGNvbmZpZy14MS0wMjE1MjIwOAoKMjAxNC0w
Mi0xNy0wMDoyMjo0NSBkZXRlY3RpbmcgYm9vdCBzdGF0ZSAzLjE0LjAtcmMyLTAyNjM3LWcz
YzE1MzBkLi4uLiBURVNUIEZBSUxVUkUKWyAgICAzLjI3ODU3OV0gVXNpbmcgSVBJIE5vLVNo
b3J0Y3V0IG1vZGUKWyAgICAzLjI3OTgxNF0gdHNjOiBSZWZpbmVkIFRTQyBjbG9ja3NvdXJj
ZSBjYWxpYnJhdGlvbjogMjg5Mi45NDcgTUh6ClsgICAgMy4yODA4ODFdIFVucmVnaXN0ZXIg
cHYgc2hhcmVkIG1lbW9yeSBmb3IgY3B1IDAKWyAgICAzLjI5NzI3OV0gQlVHOiB1bmFibGUg
dG8gaGFuZGxlIGtlcm5lbCBOVUxMIHBvaW50ZXIgZGVyZWZlcmVuY2UgYXQgMDAwMDAwNDAK
WyAgICAzLjI5ODE5NV0gSVA6IFs8Y2FlNWQyZmQ+XSBwaWNrX25leHRfdGFzaysweGEvMHg0
OApbICAgIDMuMjk4ODc2XSAqcGRwdCA9IDAwMDAwMDAwMDAwMDAwMDAgKnBkZSA9IGYwMDBm
ZjUzZjAwMGZmNTMgClsgICAgMy4yOTk1NDZdIE9vcHM6IDAwMDAgWyMxXSBTTVAgREVCVUdf
UEFHRUFMTE9DClsgICAgMy4yOTk3NDZdIENQVTogMCBQSUQ6IDkgQ29tbTogbWlncmF0aW9u
LzAgTm90IHRhaW50ZWQgMy4xNC4wLXJjMi0wMjYzNy1nM2MxNTMwZCAjMTA3ClsgICAgMy4y
OTk3NDZdIHRhc2s6IGNmODVkNTgwIHRpOiBjZjg5YzAwMCB0YXNrLnRpOiBjZjg5YzAwMApb
ICAgIDMuMjk5NzQ2XSBFSVA6IDAwNjA6WzxjYWU1ZDJmZD5dIEVGTEFHUzogMDAwMTAwNDYg
Q1BVOiAwClsgICAgMy4yOTk3NDZdIEVJUCBpcyBhdCBwaWNrX25leHRfdGFzaysweGEvMHg0
OApbICAgIDMuMjk5NzQ2XSBFQVg6IGQyNzljMTAwIEVCWDogZDI3OWMxMDAgRUNYOiAwMDAw
MDAwMCBFRFg6IDAwMDAwMDAwClsgICAgMy4yOTk3NDZdIEVTSTogZDI3OWMxMDAgRURJOiAw
MDAwMDAwMCBFQlA6IGNmODlkZGMwIEVTUDogY2Y4OWRkYjQKWyAgICAzLjI5OTc0Nl0gIERT
OiAwMDdiIEVTOiAwMDdiIEZTOiAwMGQ4IEdTOiAwMDAwIFNTOiAwMDY4ClsgICAgMy4yOTk3
NDZdIENSMDogODAwNTAwM2IgQ1IyOiAwMDAwMDA0MCBDUjM6IDBiNTcxMDAwIENSNDogMDAw
MDA2YjAKWyAgICAzLjI5OTc0Nl0gU3RhY2s6ClsgICAgMy4yOTk3NDZdICBkMjc5YzEwMCBk
Mjc5YzEwMCBjYjQ1OTkzMCBjZjg5ZGRlNCBjYWU2MWU0ZiAwMDAwMDIwMCBjZjg1ZDU4MCAw
MDAwMDA4MgpbICAgIDMuMjk5NzQ2XSAgMDAwMDAwMDAgY2I0NWE4MjQgMDAwMDAwMDAgY2I0
NTk5MzAgY2Y4OWRlMDAgY2FlNTk1YTggMDAwMDAwMDAgMDAwMDAwMDgKWyAgICAzLjI5OTc0
Nl0gIGZmZmZmZmZmIGNmODU1ZTZjIDAwMDAwMDAwIGNmODlkZTE0IGNhZTU5ODYwIGZmZmZm
ZmZiIDAwMDAwMDAwIDAwMDAwMDAwClsgICAgMy4yOTk3NDZdIENhbGwgVHJhY2U6ClsgICAg
My4yOTk3NDZdICBbPGNhZTYxZTRmPl0gbWlncmF0aW9uX2NhbGwrMHgxMGIvMHgxODgKWyAg
ICAzLjI5OTc0Nl0gIFs8Y2FlNTk1YTg+XSBub3RpZmllcl9jYWxsX2NoYWluKzB4MzIvMHg0
YgpbICAgIDMuMjk5NzQ2XSAgWzxjYWU1OTg2MD5dIF9fcmF3X25vdGlmaWVyX2NhbGxfY2hh
aW4rMHgxZS8weDIzClsgICAgMy4yOTk3NDZdICBbPGNhZTNkODAxPl0gX19jcHVfbm90aWZ5
KzB4MjQvMHgzZQpbICAgIDMuMjk5NzQ2XSAgWzxjYWUzZDgzMz5dIGNwdV9ub3RpZnkrMHgx
OC8weDFhClsgICAgMy4yOTk3NDZdICBbPGNiMWY2YjlkPl0gdGFrZV9jcHVfZG93bisweDIy
LzB4MzIKWyAgICAzLjI5OTc0Nl0gIFs8Y2FlOWMxZWY+XSBtdWx0aV9jcHVfc3RvcCsweDgw
LzB4Y2UKWyAgICAzLjI5OTc0Nl0gIFs8Y2FlOWMxNmY+XSA/IF9fc3RvcF9jcHVzKzB4NTUv
MHg1NQpbICAgIDMuMjk5NzQ2XSAgWzxjYWU5YmY5ZT5dIGNwdV9zdG9wcGVyX3RocmVhZCsw
eDgwLzB4MTExClsgICAgMy4yOTk3NDZdICBbPGNhZTczNzI0Pl0gPyBfX2xvY2tfYWNxdWly
ZS5pc3JhLjI3KzB4MWM1LzB4NGU0ClsgICAgMy4yOTk3NDZdICBbPGNiMWZmNTg0Pl0gPyBf
X3NjaGVkdWxlKzB4Mzc1LzB4NTVjClsgICAgMy4yOTk3NDZdICBbPGNhZTczZDE4Pl0gPyBs
b2NrX2FjcXVpcmUrMHg5My8weGUwClsgICAgMy4yOTk3NDZdICBbPGNhZTc0MGQwPl0gPyBs
b2NrX3JlbGVhc2UrMHgxNmQvMHgxYjEKWyAgICAzLjI5OTc0Nl0gIFs8Y2IyMDI2NDE+XSA/
IF9yYXdfc3Bpbl91bmxvY2tfaXJxcmVzdG9yZSsweDQ0LzB4NGYKWyAgICAzLjI5OTc0Nl0g
IFs8Y2FlNWI0Nzg+XSBzbXBib290X3RocmVhZF9mbisweDE1ZC8weDE3MwpbICAgIDMuMjk5
NzQ2XSAgWzxjYWU1YjMxYj5dID8gc21wYm9vdF91bnBhcmtfdGhyZWFkKzB4MmUvMHgyZQpb
ICAgIDMuMjk5NzQ2XSAgWzxjYWU1NjI3Nj5dIGt0aHJlYWQrMHg4ZC8weDkyClsgICAgMy4y
OTk3NDZdICBbPGNhZTUwMDAwPl0gPyBfX3F1ZXVlX3dvcmsrMHg2NS8weDIwNQpbICAgIDMu
Mjk5NzQ2XSAgWzxjYjIwMzg3Nz5dIHJldF9mcm9tX2tlcm5lbF90aHJlYWQrMHgxYi8weDI4
ClsgICAgMy4yOTk3NDZdICBbPGNhZTU2MWU5Pl0gPyBfX2t0aHJlYWRfcGFya21lKzB4NTUv
MHg1NQpbICAgIDMuMjk5NzQ2XSBDb2RlOiAwMCBiYSAwMSAwMCAwMCAwMCA4OSBmMCBlYiAw
ZSA4OSBmMCBlOCA5ZSA1MSAzYSAwMCBiYSAwMSAwMCAwMCAwMCA4OSBkOCBlOCBlOSA1OCAz
YSAwMCA1YiA1ZSA1ZCBjMyA1NSA4OSBlNSA1NyA4OSBkNyA1NiA4OSBjNiA1MyA8ODE+IDdh
IDQwIDc0IDAzIDIxIGNiIDc0IDA3IGJiIGEwIDA0IDIxIGNiIGViIDIzIDhiIDQwIDZjIDM5
IDQ2ClsgICAgMy4yOTk3NDZdIEVJUDogWzxjYWU1ZDJmZD5dIHBpY2tfbmV4dF90YXNrKzB4
YS8weDQ4IFNTOkVTUCAwMDY4OmNmODlkZGI0ClsgICAgMy4yOTk3NDZdIENSMjogMDAwMDAw
MDAwMDAwMDA0MApbICAgIDMuMjk5NzQ2XSAtLS1bIGVuZCB0cmFjZSAyNjUwODRhYTg5NWU0
Yzg0IF0tLS0KWyAgICAzLjI5OTc0Nl0gS2VybmVsIHBhbmljIC0gbm90IHN5bmNpbmc6IEZh
dGFsIGV4Y2VwdGlvbgova2VybmVsL2kzODYtcmFuZGNvbmZpZy14MS0wMjE1MjIwOC8zYzE1
MzBkNjEwMTExOGUzYTAyNTExNDg4M2YwMzU3OGQ0ZGI0YjY2L2RtZXNnLXF1YW50YWwtYXRo
ZW5zLTUxOjIwMTQwMjE3MDAyNDMwOmkzODYtcmFuZGNvbmZpZy14MS0wMjE1MjIwODozLjE0
LjAtcmMyLTAyNjM3LWczYzE1MzBkOjEwNwowOjE6MSBhbGxfZ29vZDpiYWQ6YWxsX2JhZCBi
b290cwoKQmlzZWN0aW5nOiAyODAgcmV2aXNpb25zIGxlZnQgdG8gdGVzdCBhZnRlciB0aGlz
IChyb3VnaGx5IDkgc3RlcHMpCls3ODJmM2M3ZTcwYmJjZDAzYmU5ZjVmOTExOWExMGRlZTc5
MGM1MzQ5XSBNZXJnZSByZW1vdGUtdHJhY2tpbmcgYnJhbmNoICd0aXAvYXV0by1sYXRlc3Qn
CnJ1bm5pbmcgL2Mva2VybmVsLXRlc3RzL2Jpc2VjdC10ZXN0LWJvb3QtZmFpbHVyZS5zaCAv
a2VybmVsLXRlc3RzL2xpbnV4L29iai1iaXNlY3QKbHMgLWEgL2tlcm5lbC10ZXN0cy9ydW4t
cXVldWUva3ZtL2kzODYtcmFuZGNvbmZpZy14MS0wMjE1MjIwOC9uZXh0Om1hc3Rlcjo3ODJm
M2M3ZTcwYmJjZDAzYmU5ZjVmOTExOWExMGRlZTc5MGM1MzQ5OmJpc2VjdC1saW51eAoyMDE0
LTAyLTE3IDAwOjI0OjQ2OiBjbWRfZmFpbDogJy9iaW4vZ3JlcCcgJy1yJyAnLS1pbmNsdWRl
PWRtZXNnLSonICctcycgJy1sJyAnRUlQIGlzIGF0IHBpY2tfbmV4dF90YXNrKzB4JyAnL2tl
cm5lbC9pMzg2LXJhbmRjb25maWcteDEtMDIxNTIyMDgvNzgyZjNjN2U3MGJiY2QwM2JlOWY1
ZjkxMTlhMTBkZWU3OTBjNTM0OScgLCByZXQ9MiwgcmVmOiAva2VybmVsLXRlc3RzL2ZhaWxl
ZC1jbWQvYmVlLWdyZXAta2J1aWxkLmxvZwoKMjAxNC0wMi0xNy0wMDoyNDo0NiA3ODJmM2M3
ZTcwYmJjZDAzYmU5ZjVmOTExOWExMGRlZTc5MGM1MzQ5IGNvbXBpbGluZwo0NiByZWFsICA3
MjIgdXNlciAgNTEgc3lzICAxNjc1LjYxJSBjcHUgCWkzODYtcmFuZGNvbmZpZy14MS0wMjE1
MjIwOAoKMjAxNC0wMi0xNy0wMDoyNTozOSBkZXRlY3RpbmcgYm9vdCBzdGF0ZSAzLjE0LjAt
cmMyLTAyNTM4LWc3ODJmM2M3Li4uLgkxIFRFU1QgRkFJTFVSRQpbICAgMTMuMTAxNDc1XSAu
Li4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4gZG9uZS4KWyAgIDEzLjEwMjI3
Nl0gVXNpbmcgSVBJIE5vLVNob3J0Y3V0IG1vZGUKWyAgIDEzLjEzNjQxN10gVW5yZWdpc3Rl
ciBwdiBzaGFyZWQgbWVtb3J5IGZvciBjcHUgMApbICAgMTMuMTU5MjIwXSBCVUc6IHVuYWJs
ZSB0byBoYW5kbGUga2VybmVsIE5VTEwgcG9pbnRlciBkZXJlZmVyZW5jZSBhdCAwMDAwMDA0
MApbICAgMTMuMTU5MzczXSBJUDogWzxkMjA1ZDJmZD5dIHBpY2tfbmV4dF90YXNrKzB4YS8w
eDQ4ClsgICAxMy4xNTkzNzNdICpwZHB0ID0gMDAwMDAwMDAwMDAwMDAwMCAqcGRlID0gZjAw
MGZmNTNmMDAwZmY1MyAKWyAgIDEzLjE1OTM3M10gT29wczogMDAwMCBbIzFdIFNNUCBERUJV
R19QQUdFQUxMT0MKWyAgIDEzLjE1OTM3M10gQ1BVOiAwIFBJRDogOSBDb21tOiBtaWdyYXRp
b24vMCBOb3QgdGFpbnRlZCAzLjE0LjAtcmMyLTAyNTM4LWc3ODJmM2M3ICMxMDgKWyAgIDEz
LjE1OTM3M10gdGFzazogZDMwNWQ1ODAgdGk6IGQzMDljMDAwIHRhc2sudGk6IGQzMDljMDAw
ClsgICAxMy4xNTkzNzNdIEVJUDogMDA2MDpbPGQyMDVkMmZkPl0gRUZMQUdTOiAwMDAxMDA0
NiBDUFU6IDAKWyAgIDEzLjE1OTM3M10gRUlQIGlzIGF0IHBpY2tfbmV4dF90YXNrKzB4YS8w
eDQ4ClsgICAxMy4xNTkzNzNdIEVBWDogZDNjYWUxMDAgRUJYOiBkM2NhZTEwMCBFQ1g6IDAw
MDAwMDAzIEVEWDogMDAwMDAwMDAKWyAgIDEzLjE1OTM3M10gRVNJOiBkM2NhZTEwMCBFREk6
IDAwMDAwMDAwIEVCUDogZDMwOWRkYzAgRVNQOiBkMzA5ZGRiNApbICAgMTMuMTU5MzczXSAg
RFM6IDAwN2IgRVM6IDAwN2IgRlM6IDAwZDggR1M6IDAwMDAgU1M6IDAwNjgKWyAgIDEzLjE1
OTM3M10gQ1IwOiA4MDA1MDAzYiBDUjI6IDAwMDAwMDQwIENSMzogMTI3NmUwMDAgQ1I0OiAw
MDAwMDZiMApbICAgMTMuMTU5MzczXSBTdGFjazoKWyAgIDEzLjE1OTM3M10gIGQzY2FlMTAw
IGQzY2FlMTAwIGQyNjU3OTMwIGQzMDlkZGU0IGQyMDYxZTRmIDAwMDAwMjAwIGQzMDVkNTgw
IDAwMDAwMDgyClsgICAxMy4xNTkzNzNdICAwMDAwMDAwMCBkMjY1ODgyNCAwMDAwMDAwMCBk
MjY1NzkzMCBkMzA5ZGUwMCBkMjA1OTVhOCAwMDAwMDAwMCAwMDAwMDAwOApbICAgMTMuMTU5
MzczXSAgZmZmZmZmZmYgZDMwNTVlNmMgMDAwMDAwMDAgZDMwOWRlMTQgZDIwNTk4NjAgZmZm
ZmZmZmIgMDAwMDAwMDAgMDAwMDAwMDAKWyAgIDEzLjE1OTM3M10gQ2FsbCBUcmFjZToKWyAg
IDEzLjE1OTM3M10gIFs8ZDIwNjFlNGY+XSBtaWdyYXRpb25fY2FsbCsweDEwYi8weDE4OApb
ICAgMTMuMTU5MzczXSAgWzxkMjA1OTVhOD5dIG5vdGlmaWVyX2NhbGxfY2hhaW4rMHgzMi8w
eDRiClsgICAxMy4xNTkzNzNdICBbPGQyMDU5ODYwPl0gX19yYXdfbm90aWZpZXJfY2FsbF9j
aGFpbisweDFlLzB4MjMKWyAgIDEzLjE1OTM3M10gIFs8ZDIwM2Q4MDE+XSBfX2NwdV9ub3Rp
ZnkrMHgyNC8weDNlClsgICAxMy4xNTkzNzNdICBbPGQyMDNkODMzPl0gY3B1X25vdGlmeSsw
eDE4LzB4MWEKWyAgIDEzLjE1OTM3M10gIFs8ZDIzZjU5YjU+XSB0YWtlX2NwdV9kb3duKzB4
MjIvMHgzMgpbICAgMTMuMTU5MzczXSAgWzxkMjA5YmQ5MT5dIG11bHRpX2NwdV9zdG9wKzB4
ODAvMHhjZQpbICAgMTMuMTU5MzczXSAgWzxkMjA5YmQxMT5dID8gX19zdG9wX2NwdXMrMHg1
NS8weDU1ClsgICAxMy4xNTkzNzNdICBbPGQyMDliYjQwPl0gY3B1X3N0b3BwZXJfdGhyZWFk
KzB4ODAvMHgxMTEKWyAgIDEzLjE1OTM3M10gIFs8ZDIwNzM3MjQ+XSA/IF9fbG9ja19hY3F1
aXJlLmlzcmEuMjcrMHgxYzUvMHg0ZTQKWyAgIDEzLjE1OTM3M10gIFs8ZDIzZmUzN2M+XSA/
IF9fc2NoZWR1bGUrMHgzNzUvMHg1NWMKWyAgIDEzLjE1OTM3M10gIFs8ZDIwNzNkMTg+XSA/
IGxvY2tfYWNxdWlyZSsweDkzLzB4ZTAKWyAgIDEzLjE1OTM3M10gIFs8ZDIwNzQwZDA+XSA/
IGxvY2tfcmVsZWFzZSsweDE2ZC8weDFiMQpbICAgMTMuMTU5MzczXSAgWzxkMjQwMTQzOT5d
ID8gX3Jhd19zcGluX3VubG9ja19pcnFyZXN0b3JlKzB4NDQvMHg0ZgpbICAgMTMuMTU5Mzcz
XSAgWzxkMjA1YjQ3OD5dIHNtcGJvb3RfdGhyZWFkX2ZuKzB4MTVkLzB4MTczClsgICAxMy4x
NTkzNzNdICBbPGQyMDViMzFiPl0gPyBzbXBib290X3VucGFya190aHJlYWQrMHgyZS8weDJl
ClsgICAxMy4xNTkzNzNdICBbPGQyMDU2Mjc2Pl0ga3RocmVhZCsweDhkLzB4OTIKWyAgIDEz
LjE1OTM3M10gIFs8ZDIwNTAwMDA+XSA/IF9fcXVldWVfd29yaysweDY1LzB4MjA1ClsgICAx
My4xNTkzNzNdICBbPGQyNDAyNjc3Pl0gcmV0X2Zyb21fa2VybmVsX3RocmVhZCsweDFiLzB4
MjgKWyAgIDEzLjE1OTM3M10gIFs8ZDIwNTYxZTk+XSA/IF9fa3RocmVhZF9wYXJrbWUrMHg1
NS8weDU1ClsgICAxMy4xNTkzNzNdIENvZGU6IDAwIGJhIDAxIDAwIDAwIDAwIDg5IGYwIGVi
IDBlIDg5IGYwIGU4IDk2IDNmIDNhIDAwIGJhIDAxIDAwIDAwIDAwIDg5IGQ4IGU4IGUxIDQ2
IDNhIDAwIDViIDVlIDVkIGMzIDU1IDg5IGU1IDU3IDg5IGQ3IDU2IDg5IGM2IDUzIDw4MT4g
N2EgNDAgNzQgZjMgNDAgZDIgNzQgMDcgYmIgYTAgZjQgNDAgZDIgZWIgMjMgOGIgNDAgNmMg
MzkgNDYKWyAgIDEzLjE1OTM3M10gRUlQOiBbPGQyMDVkMmZkPl0gcGlja19uZXh0X3Rhc2sr
MHhhLzB4NDggU1M6RVNQIDAwNjg6ZDMwOWRkYjQKWyAgIDEzLjE1OTM3M10gQ1IyOiAwMDAw
MDAwMDAwMDAwMDQwClsgICAxMy4xNTkzNzNdIC0tLVsgZW5kIHRyYWNlIDY1YjM1ZTM2Y2M2
Y2VmNDcgXS0tLQpbICAgMTMuMTU5MzczXSBLZXJuZWwgcGFuaWMgLSBub3Qgc3luY2luZzog
RmF0YWwgZXhjZXB0aW9uCi9rZXJuZWwvaTM4Ni1yYW5kY29uZmlnLXgxLTAyMTUyMjA4Lzc4
MmYzYzdlNzBiYmNkMDNiZTlmNWY5MTE5YTEwZGVlNzkwYzUzNDkvZG1lc2cteW9jdG8teGlh
bi0zNjoyMDE0MDIxNzAwMjc1NzppMzg2LXJhbmRjb25maWcteDEtMDIxNTIyMDg6My4xNC4w
LXJjMi0wMjUzOC1nNzgyZjNjNzoxMDgKMToxOjEgYWxsX2dvb2Q6YmFkOmFsbF9iYWQgYm9v
dHMKG1sxOzM1bTIwMTQtMDItMTcgMDA6Mjg6MTAgUkVQRUFUIENPVU5UOiAzMCAgIyAva2Vy
bmVsLXRlc3RzL2xpbnV4L29iai1iaXNlY3QvLnJlcGVhdBtbMG0KCkJpc2VjdGluZzogMTgx
IHJldmlzaW9ucyBsZWZ0IHRvIHRlc3QgYWZ0ZXIgdGhpcyAocm91Z2hseSA4IHN0ZXBzKQpb
YjM1ZTdhZWRlNmZiMDIyNmI0ODY1NDUwZjYyMzYyZTg1YmY2YTMwNl0gTWVyZ2UgcmVtb3Rl
LXRyYWNraW5nIGJyYW5jaCAndHJpdmlhbC9mb3ItbmV4dCcKcnVubmluZyAvYy9rZXJuZWwt
dGVzdHMvYmlzZWN0LXRlc3QtYm9vdC1mYWlsdXJlLnNoIC9rZXJuZWwtdGVzdHMvbGludXgv
b2JqLWJpc2VjdApscyAtYSAva2VybmVsLXRlc3RzL3J1bi1xdWV1ZS9rdm0vaTM4Ni1yYW5k
Y29uZmlnLXgxLTAyMTUyMjA4L25leHQ6bWFzdGVyOmIzNWU3YWVkZTZmYjAyMjZiNDg2NTQ1
MGY2MjM2MmU4NWJmNmEzMDY6YmlzZWN0LWxpbnV4CjIwMTQtMDItMTcgMDA6Mjg6MTA6IGNt
ZF9mYWlsOiAnL2Jpbi9ncmVwJyAnLXInICctLWluY2x1ZGU9ZG1lc2ctKicgJy1zJyAnLWwn
ICdFSVAgaXMgYXQgcGlja19uZXh0X3Rhc2srMHgnICcva2VybmVsL2kzODYtcmFuZGNvbmZp
Zy14MS0wMjE1MjIwOC9iMzVlN2FlZGU2ZmIwMjI2YjQ4NjU0NTBmNjIzNjJlODViZjZhMzA2
JyAsIHJldD0yLCByZWY6IC9rZXJuZWwtdGVzdHMvZmFpbGVkLWNtZC9iZWUtZ3JlcC1rYnVp
bGQubG9nCgoyMDE0LTAyLTE3LTAwOjI4OjEwIGIzNWU3YWVkZTZmYjAyMjZiNDg2NTQ1MGY2
MjM2MmU4NWJmNmEzMDYgY29tcGlsaW5nCjQyIHJlYWwgIDczOSB1c2VyICA1MSBzeXMgIDE4
NDIuOTElIGNwdSAJaTM4Ni1yYW5kY29uZmlnLXgxLTAyMTUyMjA4CgoyMDE0LTAyLTE3LTAw
OjI5OjAxIGRldGVjdGluZyBib290IHN0YXRlIDMuMTQuMC1yYzItMDIzNjItZ2IzNWU3YWUu
LgkzCTkJMTAJMTEJMTIJMTMJMTUJMTcJMjAuLgkyMS4uCTI1LgkyNy4uLi4JMjguLi4uLi4u
Li4uLi4uLi4uLgkyOS4uLi4uLi4uCTMwIFNVQ0NFU1MKCkJpc2VjdGluZzogMTc2IHJldmlz
aW9ucyBsZWZ0IHRvIHRlc3QgYWZ0ZXIgdGhpcyAocm91Z2hseSA4IHN0ZXBzKQpbMTZhZjgz
MGFmNzdmYmZkZTQ5Nzc5ZjU4MzI4YTIzMDg1OTNjOTU1Ml0gTWVyZ2UgcmVtb3RlLXRyYWNr
aW5nIGJyYW5jaCAnZGV2aWNldHJlZS9kZXZpY2V0cmVlL25leHQnCnJ1bm5pbmcgL2Mva2Vy
bmVsLXRlc3RzL2Jpc2VjdC10ZXN0LWJvb3QtZmFpbHVyZS5zaCAva2VybmVsLXRlc3RzL2xp
bnV4L29iai1iaXNlY3QKbHMgLWEgL2tlcm5lbC10ZXN0cy9ydW4tcXVldWUva3ZtL2kzODYt
cmFuZGNvbmZpZy14MS0wMjE1MjIwOC9uZXh0Om1hc3RlcjoxNmFmODMwYWY3N2ZiZmRlNDk3
NzlmNTgzMjhhMjMwODU5M2M5NTUyOmJpc2VjdC1saW51eAoyMDE0LTAyLTE3IDAwOjU0OjMx
OiBjbWRfZmFpbDogJy9iaW4vZ3JlcCcgJy1yJyAnLS1pbmNsdWRlPWRtZXNnLSonICctcycg
Jy1sJyAnRUlQIGlzIGF0IHBpY2tfbmV4dF90YXNrKzB4JyAnL2tlcm5lbC9pMzg2LXJhbmRj
b25maWcteDEtMDIxNTIyMDgvMTZhZjgzMGFmNzdmYmZkZTQ5Nzc5ZjU4MzI4YTIzMDg1OTNj
OTU1MicgLCByZXQ9MiwgcmVmOiAva2VybmVsLXRlc3RzL2ZhaWxlZC1jbWQvYmVlLWdyZXAt
a2J1aWxkLmxvZwoKMjAxNC0wMi0xNy0wMDo1NDozMSAxNmFmODMwYWY3N2ZiZmRlNDk3Nzlm
NTgzMjhhMjMwODU5M2M5NTUyIGNvbXBpbGluZwoxNiByZWFsICAxNTEgdXNlciAgMTEgc3lz
ICA5OTYuNTAlIGNwdSAJaTM4Ni1yYW5kY29uZmlnLXgxLTAyMTUyMjA4CgoyMDE0LTAyLTE3
LTAwOjU0OjU0IGRldGVjdGluZyBib290IHN0YXRlIDMuMTQuMC1yYzItMDIzNzMtZzE2YWY4
MzAuLi4uLi4uLi4uLi4uLi4uLi4uLi4uLgkyLgk2CTcJOAkxMAkxMQkxNC4JMTUJMTYuCTE3
Li4uLi4uLgkxOAkxOS4uCTIwCTIxCTIzLi4JMjQJMjUuLi4uLi4uCTI2Li4uLi4uLi4uLi4u
Li4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uCTI3
LgkzMCBTVUNDRVNTCgpCaXNlY3Rpbmc6IDE2NSByZXZpc2lvbnMgbGVmdCB0byB0ZXN0IGFm
dGVyIHRoaXMgKHJvdWdobHkgOCBzdGVwcykKW2I3NGZjZjMxN2NjYTE3NTQyNmMyZmVlNzhj
ZTg2NDBhYzkxYjY3NDldIE1lcmdlIHJlbW90ZS10cmFja2luZyBicmFuY2ggJ3NwaS9mb3It
bmV4dCcKcnVubmluZyAvYy9rZXJuZWwtdGVzdHMvYmlzZWN0LXRlc3QtYm9vdC1mYWlsdXJl
LnNoIC9rZXJuZWwtdGVzdHMvbGludXgvb2JqLWJpc2VjdApscyAtYSAva2VybmVsLXRlc3Rz
L3J1bi1xdWV1ZS9rdm0vaTM4Ni1yYW5kY29uZmlnLXgxLTAyMTUyMjA4L25leHQ6bWFzdGVy
OmI3NGZjZjMxN2NjYTE3NTQyNmMyZmVlNzhjZTg2NDBhYzkxYjY3NDk6YmlzZWN0LWxpbnV4
CjIwMTQtMDItMTcgMDE6NTg6NTY6IGNtZF9mYWlsOiAnL2Jpbi9ncmVwJyAnLXInICctLWlu
Y2x1ZGU9ZG1lc2ctKicgJy1zJyAnLWwnICdFSVAgaXMgYXQgcGlja19uZXh0X3Rhc2srMHgn
ICcva2VybmVsL2kzODYtcmFuZGNvbmZpZy14MS0wMjE1MjIwOC9iNzRmY2YzMTdjY2ExNzU0
MjZjMmZlZTc4Y2U4NjQwYWM5MWI2NzQ5JyAsIHJldD0yLCByZWY6IC9rZXJuZWwtdGVzdHMv
ZmFpbGVkLWNtZC9iZWUtZ3JlcC1rYnVpbGQubG9nCgoyMDE0LTAyLTE3LTAxOjU4OjU2IGI3
NGZjZjMxN2NjYTE3NTQyNmMyZmVlNzhjZTg2NDBhYzkxYjY3NDkgY29tcGlsaW5nCjE2IHJl
YWwgIDQzIHVzZXIgIDMgc3lzICAyOTMuODAlIGNwdSAJaTM4Ni1yYW5kY29uZmlnLXgxLTAy
MTUyMjA4CgoyMDE0LTAyLTE3LTAxOjU5OjIxIGRldGVjdGluZyBib290IHN0YXRlIDMuMTQu
MC1yYzItMDI0NDQtZ2I3NGZjZjMuLi4JMQkzCTYuCTcJOQkxMAkxNAkxOS4JMjAJMjIuLgky
NQkyNgkyOC4uLgkzMCBTVUNDRVNTCgpsaW5lYXItYmlzZWN0OiBiYWQgYnJhbmNoIG1heSBi
ZSByZW1vdGUtdHJhY2tpbmcgYnJhbmNoICd0aXAvYXV0by1sYXRlc3QnCmxpbmVhci1iaXNl
Y3Q6IGhhbmRsZSBvdmVyIHRvIGdpdCBiaXNlY3QKbGluZWFyLWJpc2VjdDogZ2l0IGJpc2Vj
dCBzdGFydCA3ODJmM2M3ZTcwYmJjZDAzYmU5ZjVmOTExOWExMGRlZTc5MGM1MzQ5IGI3NGZj
ZjMxN2NjYTE3NTQyNmMyZmVlNzhjZTg2NDBhYzkxYjY3NDkgLS0KUHJldmlvdXMgSEVBRCBw
b3NpdGlvbiB3YXMgYjc0ZmNmMy4uLiBNZXJnZSByZW1vdGUtdHJhY2tpbmcgYnJhbmNoICdz
cGkvZm9yLW5leHQnCkhFQUQgaXMgbm93IGF0IDVlMzAwMjUuLi4gTWVyZ2UgYnJhbmNoICdj
b3JlLWxvY2tpbmctZm9yLWxpbnVzJyBvZiBnaXQ6Ly9naXQua2VybmVsLm9yZy9wdWIvc2Nt
L2xpbnV4L2tlcm5lbC9naXQvdGlwL3RpcApCaXNlY3Rpbmc6IDYwIHJldmlzaW9ucyBsZWZ0
IHRvIHRlc3QgYWZ0ZXIgdGhpcyAocm91Z2hseSA2IHN0ZXBzKQpbM2Y2N2Q5NjJjNjRkOWI2
ZGU5ZGFiODFiZGJlNmQ1Yzk0YzgwZDliOV0gY3B1aWRsZS9wc2VyaWVzOiBGaXggZmFsbG91
dCBjYXVzZWQgZHVlIHRvIGNsZWFudXAgaW4gcHNlcmllcyBjcHVpZGxlIGJhY2tlbmQgZHJp
dmVyCmxpbmVhci1iaXNlY3Q6IGdpdCBiaXNlY3QgcnVuIC9jL2tlcm5lbC10ZXN0cy9iaXNl
Y3QtdGVzdC1ib290LWZhaWx1cmUuc2ggL2tlcm5lbC10ZXN0cy9saW51eC9vYmotYmlzZWN0
CnJ1bm5pbmcgL2Mva2VybmVsLXRlc3RzL2Jpc2VjdC10ZXN0LWJvb3QtZmFpbHVyZS5zaCAv
a2VybmVsLXRlc3RzL2xpbnV4L29iai1iaXNlY3QKbHMgLWEgL2tlcm5lbC10ZXN0cy9ydW4t
cXVldWUva3ZtL2kzODYtcmFuZGNvbmZpZy14MS0wMjE1MjIwOC9uZXh0Om1hc3RlcjozZjY3
ZDk2MmM2NGQ5YjZkZTlkYWI4MWJkYmU2ZDVjOTRjODBkOWI5OmJpc2VjdC1saW51eAoyMDE0
LTAyLTE3IDAyOjExOjI2OiBjbWRfZmFpbDogJy9iaW4vZ3JlcCcgJy1yJyAnLS1pbmNsdWRl
PWRtZXNnLSonICctcycgJy1sJyAnRUlQIGlzIGF0IHBpY2tfbmV4dF90YXNrKzB4JyAnL2tl
cm5lbC9pMzg2LXJhbmRjb25maWcteDEtMDIxNTIyMDgvM2Y2N2Q5NjJjNjRkOWI2ZGU5ZGFi
ODFiZGJlNmQ1Yzk0YzgwZDliOScgLCByZXQ9MiwgcmVmOiAva2VybmVsLXRlc3RzL2ZhaWxl
ZC1jbWQvYmVlLWdyZXAta2J1aWxkLmxvZwoKMjAxNC0wMi0xNy0wMjoxMToyNiAzZjY3ZDk2
MmM2NGQ5YjZkZTlkYWI4MWJkYmU2ZDVjOTRjODBkOWI5IGNvbXBpbGluZwo2MiByZWFsICA3
MTkgdXNlciAgNTAgc3lzICAxMjI0Ljg2JSBjcHUgCWkzODYtcmFuZGNvbmZpZy14MS0wMjE1
MjIwOAoKMjAxNC0wMi0xNy0wMjoxMjozOCBkZXRlY3RpbmcgYm9vdCBzdGF0ZSAzLjEzLjAt
MTEzNDAtZzNmNjdkOTYuIFRFU1QgRkFJTFVSRQpbICAgIDQuMzIwMjc5XSAuLi4uLi4uLi4u
Li4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4gZG9uZS4KWyAgICA0LjMyMTA3NF0gVXNpbmcg
SVBJIE5vLVNob3J0Y3V0IG1vZGUKWyAgICA0LjMyMzA0Nl0gVW5yZWdpc3RlciBwdiBzaGFy
ZWQgbWVtb3J5IGZvciBjcHUgMApbICAgIDQuMzM5MjgzXSBCVUc6IHVuYWJsZSB0byBoYW5k
bGUga2VybmVsIE5VTEwgcG9pbnRlciBkZXJlZmVyZW5jZSBhdCAwMDAwMDA0MApbICAgIDQu
MzQwNDIxXSBJUDogWzxjMjA1ZDMyMj5dIHBpY2tfbmV4dF90YXNrKzB4YS8weDQ4ClsgICAg
NC4zNDExODZdICpwZHB0ID0gMDAwMDAwMDAwMDAwMDAwMCAqcGRlID0gZjAwMGZmNTNmMDAw
ZmY1MyAKWyAgICA0LjM0MTcwN10gT29wczogMDAwMCBbIzFdIFNNUCBERUJVR19QQUdFQUxM
T0MKWyAgICA0LjM0MTcwN10gQ1BVOiAwIFBJRDogOSBDb21tOiBtaWdyYXRpb24vMCBOb3Qg
dGFpbnRlZCAzLjEzLjAtMTEzNDAtZzNmNjdkOTYgIzExMgpbICAgIDQuMzQxNzA3XSB0YXNr
OiBjZjg1ZDU4MCB0aTogY2Y4OWMwMDAgdGFzay50aTogY2Y4OWMwMDAKWyAgICA0LjM0MTcw
N10gRUlQOiAwMDYwOls8YzIwNWQzMjI+XSBFRkxBR1M6IDAwMDEwMDQ2IENQVTogMApbICAg
IDQuMzQxNzA3XSBFSVAgaXMgYXQgcGlja19uZXh0X3Rhc2srMHhhLzB4NDgKWyAgICA0LjM0
MTcwN10gRUFYOiBkMjc5YzEwMCBFQlg6IGQyNzljMTAwIEVDWDogMDAwMDAwMDEgRURYOiAw
MDAwMDAwMApbICAgIDQuMzQxNzA3XSBFU0k6IGQyNzljMTAwIEVESTogMDAwMDAwMDAgRUJQ
OiBjZjg5ZGRjMCBFU1A6IGNmODlkZGI0ClsgICAgNC4zNDE3MDddICBEUzogMDA3YiBFUzog
MDA3YiBGUzogMDBkOCBHUzogMDAwMCBTUzogMDA2OApbICAgIDQuMzQxNzA3XSBDUjA6IDgw
MDUwMDNiIENSMjogMDAwMDAwNDAgQ1IzOiAwMjc2OTAwMCBDUjQ6IDAwMDAwNmIwClsgICAg
NC4zNDE3MDddIFN0YWNrOgpbICAgIDQuMzQxNzA3XSAgZDI3OWMxMDAgZDI3OWMxMDAgYzI2
NTM4NzAgY2Y4OWRkZTQgYzIwNjFlNzQgMDAwMDAyMDAgY2Y4NWQ1ODAgMDAwMDAwODIKWyAg
ICA0LjM0MTcwN10gIDAwMDAwMDAwIGMyNjU0NzY0IDAwMDAwMDAwIGMyNjUzODcwIGNmODlk
ZTAwIGMyMDU5NWNkIDAwMDAwMDAwIDAwMDAwMDA4ClsgICAgNC4zNDE3MDddICBmZmZmZmZm
ZiBjZjg1NWU2YyAwMDAwMDAwMCBjZjg5ZGUxNCBjMjA1OTg4NSBmZmZmZmZmYiAwMDAwMDAw
MCAwMDAwMDAwMApbICAgIDQuMzQxNzA3XSBDYWxsIFRyYWNlOgpbICAgIDQuMzQxNzA3XSAg
WzxjMjA2MWU3ND5dIG1pZ3JhdGlvbl9jYWxsKzB4MTBiLzB4MTg4ClsgICAgNC4zNDE3MDdd
ICBbPGMyMDU5NWNkPl0gbm90aWZpZXJfY2FsbF9jaGFpbisweDMyLzB4NGIKWyAgICA0LjM0
MTcwN10gIFs8YzIwNTk4ODU+XSBfX3Jhd19ub3RpZmllcl9jYWxsX2NoYWluKzB4MWUvMHgy
MwpbICAgIDQuMzQxNzA3XSAgWzxjMjAzZDgyMT5dIF9fY3B1X25vdGlmeSsweDI0LzB4M2UK
WyAgICA0LjM0MTcwN10gIFs8YzIwM2Q4NTM+XSBjcHVfbm90aWZ5KzB4MTgvMHgxYQpbICAg
IDQuMzQxNzA3XSAgWzxjMjNmMmRiZj5dIHRha2VfY3B1X2Rvd24rMHgyMi8weDMyClsgICAg
NC4zNDE3MDddICBbPGMyMDliYjE4Pl0gbXVsdGlfY3B1X3N0b3ArMHg4MC8weGNlClsgICAg
NC4zNDE3MDddICBbPGMyMDliYTk4Pl0gPyBfX3N0b3BfY3B1cysweDU1LzB4NTUKWyAgICA0
LjM0MTcwN10gIFs8YzIwOWI4Yzc+XSBjcHVfc3RvcHBlcl90aHJlYWQrMHg4MC8weDExMQpb
ICAgIDQuMzQxNzA3XSAgWzxjMjA3Mzc0Zj5dID8gX19sb2NrX2FjcXVpcmUuaXNyYS4yNysw
eDFjYi8weDRlYQpbICAgIDQuMzQxNzA3XSAgWzxjMjNmYjY2Yz5dID8gX19zY2hlZHVsZSsw
eDM3NS8weDU1YwpbICAgIDQuMzQxNzA3XSAgWzxjMjA3M2Q0Mz5dID8gbG9ja19hY3F1aXJl
KzB4OTMvMHhlMApbICAgIDQuMzQxNzA3XSAgWzxjMjA3NDBmYj5dID8gbG9ja19yZWxlYXNl
KzB4MTZkLzB4MWIxClsgICAgNC4zNDE3MDddICBbPGMyM2ZlNzI5Pl0gPyBfcmF3X3NwaW5f
dW5sb2NrX2lycXJlc3RvcmUrMHg0NC8weDRmClsgICAgNC4zNDE3MDddICBbPGMyMDViNDlk
Pl0gc21wYm9vdF90aHJlYWRfZm4rMHgxNWQvMHgxNzMKWyAgICA0LjM0MTcwN10gIFs8YzIw
NWIzNDA+XSA/IHNtcGJvb3RfdW5wYXJrX3RocmVhZCsweDJlLzB4MmUKWyAgICA0LjM0MTcw
N10gIFs8YzIwNTYyOWI+XSBrdGhyZWFkKzB4OGQvMHg5MgpbICAgIDQuMzQxNzA3XSAgWzxj
MjA1MDAwMD5dID8gX19xdWV1ZV93b3JrKzB4NDAvMHgyMDUKWyAgICA0LjM0MTcwN10gIFs8
YzIzZmY5Nzc+XSByZXRfZnJvbV9rZXJuZWxfdGhyZWFkKzB4MWIvMHgyOApbICAgIDQuMzQx
NzA3XSAgWzxjMjA1NjIwZT5dID8gX19rdGhyZWFkX3BhcmttZSsweDU1LzB4NTUKWyAgICA0
LjM0MTcwN10gQ29kZTogMDAgYmEgMDEgMDAgMDAgMDAgODkgZjAgZWIgMGUgODkgZjAgZTgg
NjEgMTIgM2EgMDAgYmEgMDEgMDAgMDAgMDAgODkgZDggZTggYWMgMTkgM2EgMDAgNWIgNWUg
NWQgYzMgNTUgODkgZTUgNTcgODkgZDcgNTYgODkgYzYgNTMgPDgxPiA3YSA0MCAzNCBjMyA0
MCBjMiA3NCAwNyBiYiA2MCBjNCA0MCBjMiBlYiAyMyA4YiA0MCA2YyAzOSA0NgpbICAgIDQu
MzQxNzA3XSBFSVA6IFs8YzIwNWQzMjI+XSBwaWNrX25leHRfdGFzaysweGEvMHg0OCBTUzpF
U1AgMDA2ODpjZjg5ZGRiNApbICAgIDQuMzQxNzA3XSBDUjI6IDAwMDAwMDAwMDAwMDAwNDAK
WyAgICA0LjM0MTcwN10gLS0tWyBlbmQgdHJhY2UgNzViNzZiZGM5YTc4Y2IzMCBdLS0tClsg
ICAgNC4zNDE3MDddIEtlcm5lbCBwYW5pYyAtIG5vdCBzeW5jaW5nOiBGYXRhbCBleGNlcHRp
b24KL2tlcm5lbC9pMzg2LXJhbmRjb25maWcteDEtMDIxNTIyMDgvM2Y2N2Q5NjJjNjRkOWI2
ZGU5ZGFiODFiZGJlNmQ1Yzk0YzgwZDliOS9kbWVzZy1xdWFudGFsLXhpYW4tNTE6MjAxNDAy
MTcwMjEyNTU6aTM4Ni1yYW5kY29uZmlnLXgxLTAyMTUyMjA4OjMuMTMuMC0xMTM0MC1nM2Y2
N2Q5NjoxMTIKMDoxOjEgYWxsX2dvb2Q6YmFkOmFsbF9iYWQgYm9vdHMKCkJpc2VjdGluZzog
MTYgcmV2aXNpb25zIGxlZnQgdG8gdGVzdCBhZnRlciB0aGlzIChyb3VnaGx5IDQgc3RlcHMp
CltlNWZjNjYxMTllYzk3MDU0ZWVmYzgzZjE3M2E3ZWU5ZTEzM2MzYzNhXSBzY2hlZDogRml4
IHJhY2UgaW4gaWRsZV9iYWxhbmNlKCkKcnVubmluZyAvYy9rZXJuZWwtdGVzdHMvYmlzZWN0
LXRlc3QtYm9vdC1mYWlsdXJlLnNoIC9rZXJuZWwtdGVzdHMvbGludXgvb2JqLWJpc2VjdAps
cyAtYSAva2VybmVsLXRlc3RzL3J1bi1xdWV1ZS9rdm0vaTM4Ni1yYW5kY29uZmlnLXgxLTAy
MTUyMjA4L25leHQ6bWFzdGVyOmU1ZmM2NjExOWVjOTcwNTRlZWZjODNmMTczYTdlZTllMTMz
YzNjM2E6YmlzZWN0LWxpbnV4CjIwMTQtMDItMTcgMDI6MTM6MDk6IGNtZF9mYWlsOiAnL2Jp
bi9ncmVwJyAnLXInICctLWluY2x1ZGU9ZG1lc2ctKicgJy1zJyAnLWwnICdFSVAgaXMgYXQg
cGlja19uZXh0X3Rhc2srMHgnICcva2VybmVsL2kzODYtcmFuZGNvbmZpZy14MS0wMjE1MjIw
OC9lNWZjNjYxMTllYzk3MDU0ZWVmYzgzZjE3M2E3ZWU5ZTEzM2MzYzNhJyAsIHJldD0yLCBy
ZWY6IC9rZXJuZWwtdGVzdHMvZmFpbGVkLWNtZC9iZWUtZ3JlcC1rYnVpbGQubG9nCgoyMDE0
LTAyLTE3LTAyOjEzOjA5IGU1ZmM2NjExOWVjOTcwNTRlZWZjODNmMTczYTdlZTllMTMzYzNj
M2EgY29tcGlsaW5nCjUzIHJlYWwgIDU0NiB1c2VyICAzNiBzeXMgIDEwODAuODYlIGNwdSAJ
aTM4Ni1yYW5kY29uZmlnLXgxLTAyMTUyMjA4CgoyMDE0LTAyLTE3LTAyOjE0OjA5IGRldGVj
dGluZyBib290IHN0YXRlIDMuMTMuMC0xMTMyMy1nZTVmYzY2MS4uLi4JMgkzLi4uLi4uLi4u
Li4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4u
Li4uLgk0CTUJNwkxMQkxNQkxOAkxOQkyMQkyMgkyMy4uCTI1Li4uLi4uCTI2CTI3LgkyOC4u
Li4JMjkuLi4uLi4uLi4uLgkzMCBTVUNDRVNTCgpCaXNlY3Rpbmc6IDggcmV2aXNpb25zIGxl
ZnQgdG8gdGVzdCBhZnRlciB0aGlzIChyb3VnaGx5IDMgc3RlcHMpClsyN2YxNzU4MGZkMmM3
NTE0YzhmNWNjZTIyYWI5MDNjNmYzZGRmNDU4XSBzY2hlZDogRGVsZXRlIGlzX3NhbWVfZ3Jv
dXAoKSBvdXRzaWRlIENPTkZJR19GQUlSX0dST1VQX1NDSEVECnJ1bm5pbmcgL2Mva2VybmVs
LXRlc3RzL2Jpc2VjdC10ZXN0LWJvb3QtZmFpbHVyZS5zaCAva2VybmVsLXRlc3RzL2xpbnV4
L29iai1iaXNlY3QKbHMgLWEgL2tlcm5lbC10ZXN0cy9ydW4tcXVldWUva3ZtL2kzODYtcmFu
ZGNvbmZpZy14MS0wMjE1MjIwOC9uZXh0Om1hc3RlcjoyN2YxNzU4MGZkMmM3NTE0YzhmNWNj
ZTIyYWI5MDNjNmYzZGRmNDU4OmJpc2VjdC1saW51eAoyMDE0LTAyLTE3IDAzOjEwOjQwOiBj
bWRfZmFpbDogJy9iaW4vZ3JlcCcgJy1yJyAnLS1pbmNsdWRlPWRtZXNnLSonICctcycgJy1s
JyAnRUlQIGlzIGF0IHBpY2tfbmV4dF90YXNrKzB4JyAnL2tlcm5lbC9pMzg2LXJhbmRjb25m
aWcteDEtMDIxNTIyMDgvMjdmMTc1ODBmZDJjNzUxNGM4ZjVjY2UyMmFiOTAzYzZmM2RkZjQ1
OCcgLCByZXQ9MiwgcmVmOiAva2VybmVsLXRlc3RzL2ZhaWxlZC1jbWQvYmVlLWdyZXAta2J1
aWxkLmxvZwoKMjAxNC0wMi0xNy0wMzoxMDo0MCAyN2YxNzU4MGZkMmM3NTE0YzhmNWNjZTIy
YWI5MDNjNmYzZGRmNDU4IGNvbXBpbGluZwo1MyByZWFsICA1NDggdXNlciAgMzcgc3lzICAx
MTAxLjYxJSBjcHUgCWkzODYtcmFuZGNvbmZpZy14MS0wMjE1MjIwOAoKMjAxNC0wMi0xNy0w
MzoxMTo0MSBkZXRlY3RpbmcgYm9vdCBzdGF0ZSAzLjEzLjAtMTEzMzEtZzI3ZjE3NTgJMgkz
CTQuLi4uLi4gVEVTVCBGQUlMVVJFClsgICAgMC43ODQzMjZdIFVucGFja2luZyBpbml0cmFt
ZnMuLi4KWyAgICAwLjc4NTc1MV0gSW5pdHJhbWZzIHVucGFja2luZyBmYWlsZWQ6IGp1bmsg
aW4gY29tcHJlc3NlZCBhcmNoaXZlClsgICAgMC43ODg0MjRdIGRlYnVnOiB1bm1hcHBpbmcg
aW5pdCBbbWVtIDB4Y2U3YWIwMDAtMHhjZmZlZmZmZl0KWyAgICAwLjc5MTE5OV0gQlVHOiB1
bmFibGUgdG8gaGFuZGxlIGtlcm5lbCBwYWdpbmcgcmVxdWVzdCBhdCBjZThhOTAwMApbICAg
IDAuNzkzNzk4XSBJUDogWzxjZGMyYzQ5NT5dIF9fY2hhbmdlX3BhZ2VfYXR0cl9zZXRfY2xy
KzB4ZDkvMHg1ZjUKWyAgICAwLjc5NDczOV0gKnBkcHQgPSAwMDAwMDAwMDBlMzY2MDAxICpw
ZGUgPSAwMDAwMDAwMDBlOGE4MDY3IApFbGFwc2VkIHRpbWU6IDEwCnFlbXUtc3lzdGVtLXg4
Nl82NCAtY3B1IGt2bTY0IC1lbmFibGUta3ZtIC1rZXJuZWwgL2tlcm5lbC9pMzg2LXJhbmRj
b25maWcteDEtMDIxNTIyMDgvMjdmMTc1ODBmZDJjNzUxNGM4ZjVjY2UyMmFiOTAzYzZmM2Rk
ZjQ1OC92bWxpbnV6LTMuMTMuMC0xMTMzMS1nMjdmMTc1OCAtYXBwZW5kICdodW5nX3Rhc2tf
cGFuaWM9MSBlYXJseXByaW50az10dHlTMCwxMTUyMDAgZGVidWcgYXBpYz1kZWJ1ZyBzeXNy
cV9hbHdheXNfZW5hYmxlZCBwYW5pYz0xMCBzb2Z0bG9ja3VwX3BhbmljPTEgbm1pX3dhdGNo
ZG9nPXBhbmljICBwcm9tcHRfcmFtZGlzaz0wIGNvbnNvbGU9dHR5UzAsMTE1MjAwIGNvbnNv
bGU9dHR5MCB2Z2E9bm9ybWFsICByb290PS9kZXYvcmFtMCBydyBsaW5rPS9rZXJuZWwtdGVz
dHMvcnVuLXF1ZXVlL2t2bS9pMzg2LXJhbmRjb25maWcteDEtMDIxNTIyMDgvbmV4dDptYXN0
ZXI6MjdmMTc1ODBmZDJjNzUxNGM4ZjVjY2UyMmFiOTAzYzZmM2RkZjQ1ODpiaXNlY3QtbGlu
dXgvLnZtbGludXotMjdmMTc1ODBmZDJjNzUxNGM4ZjVjY2UyMmFiOTAzYzZmM2RkZjQ1OC0y
MDE0MDIxNzAzMTEzOS0xLWpha2V0b3duIGJyYW5jaD1uZXh0L21hc3RlciBCT09UX0lNQUdF
PS9rZXJuZWwvaTM4Ni1yYW5kY29uZmlnLXgxLTAyMTUyMjA4LzI3ZjE3NTgwZmQyYzc1MTRj
OGY1Y2NlMjJhYjkwM2M2ZjNkZGY0NTgvdm1saW51ei0zLjEzLjAtMTEzMzEtZzI3ZjE3NTgn
ICAtaW5pdHJkIC9rZXJuZWwtdGVzdHMvaW5pdHJkL3F1YW50YWwtY29yZS1pMzg2LmNneiAt
bSAyNTYgLXNtcCAyIC1uZXQgbmljLHZsYW49MSxtb2RlbD1lMTAwMCAtbmV0IHVzZXIsdmxh
bj0xLGhvc3Rmd2Q9dGNwOjo0ODYzOS06MjIgLWJvb3Qgb3JkZXI9bmMgLW5vLXJlYm9vdCAt
d2F0Y2hkb2cgaTYzMDBlc2IgLXJ0YyBiYXNlPWxvY2FsdGltZSAtcGlkZmlsZSAvZGV2L3No
bS9rYm9vdC9waWQtcXVhbnRhbC1qYWtldG93bi0yOCAtc2VyaWFsIGZpbGU6L2Rldi9zaG0v
a2Jvb3Qvc2VyaWFsLXF1YW50YWwtamFrZXRvd24tMjggLWRhZW1vbml6ZSAtZGlzcGxheSBu
b25lIC1tb25pdG9yIG51bGwgCi9rZXJuZWwvaTM4Ni1yYW5kY29uZmlnLXgxLTAyMTUyMjA4
LzI3ZjE3NTgwZmQyYzc1MTRjOGY1Y2NlMjJhYjkwM2M2ZjNkZGY0NTgvZG1lc2ctcXVhbnRh
bC1zbmItNDA6MjAxNDAyMTcwMzE2MDA6aTM4Ni1yYW5kY29uZmlnLXgxLTAyMTUyMjA4OjMu
MTMuMC0xMTMzMS1nMjdmMTc1ODoxMTQKMjoxOjMgYWxsX2dvb2Q6YmFkOmFsbF9iYWQgYm9v
dHMKG1sxOzM1bTIwMTQtMDItMTcgMDM6MTY6MTEgUkVQRUFUIENPVU5UOiA2MCAgIyAva2Vy
bmVsLXRlc3RzL2xpbnV4L29iai1iaXNlY3QvLnJlcGVhdBtbMG0KCkJpc2VjdGluZzogMyBy
ZXZpc2lvbnMgbGVmdCB0byB0ZXN0IGFmdGVyIHRoaXMgKHJvdWdobHkgMiBzdGVwcykKW2Yx
MDQ0Nzk5OGE1OWI5Nzc0N2MxNjI1OGE5YzZlNmExNTEyZjI3ZjNdIHNjaGVkL2ZhaXI6IENs
ZWFuIHVwIHRoZSBfX2NsZWFyX2J1ZGRpZXNfKigpIGZ1bmN0aW9ucwpydW5uaW5nIC9jL2tl
cm5lbC10ZXN0cy9iaXNlY3QtdGVzdC1ib290LWZhaWx1cmUuc2ggL2tlcm5lbC10ZXN0cy9s
aW51eC9vYmotYmlzZWN0CmxzIC1hIC9rZXJuZWwtdGVzdHMvcnVuLXF1ZXVlL2t2bS9pMzg2
LXJhbmRjb25maWcteDEtMDIxNTIyMDgvbmV4dDptYXN0ZXI6ZjEwNDQ3OTk4YTU5Yjk3NzQ3
YzE2MjU4YTljNmU2YTE1MTJmMjdmMzpiaXNlY3QtbGludXgKMjAxNC0wMi0xNyAwMzoxNjox
MjogY21kX2ZhaWw6ICcvYmluL2dyZXAnICctcicgJy0taW5jbHVkZT1kbWVzZy0qJyAnLXMn
ICctbCcgJ0VJUCBpcyBhdCBwaWNrX25leHRfdGFzaysweCcgJy9rZXJuZWwvaTM4Ni1yYW5k
Y29uZmlnLXgxLTAyMTUyMjA4L2YxMDQ0Nzk5OGE1OWI5Nzc0N2MxNjI1OGE5YzZlNmExNTEy
ZjI3ZjMnICwgcmV0PTIsIHJlZjogL2tlcm5lbC10ZXN0cy9mYWlsZWQtY21kL2JlZS1ncmVw
LWtidWlsZC5sb2cKCjIwMTQtMDItMTctMDM6MTY6MTIgZjEwNDQ3OTk4YTU5Yjk3NzQ3YzE2
MjU4YTljNmU2YTE1MTJmMjdmMyBjb21waWxpbmcKMTEgcmVhbCAgMjcgdXNlciAgMiBzeXMg
IDI1OS4xMCUgY3B1IAlpMzg2LXJhbmRjb25maWcteDEtMDIxNTIyMDgKCjIwMTQtMDItMTct
MDM6MTY6MjkgZGV0ZWN0aW5nIGJvb3Qgc3RhdGUgMy4xMy4wLTExMzI3LWdmMTA0NDc5Lgkx
CTIJNgk3CTkJMTAuLgkxMQkxNAkyMQkyNi4JMzAJMzEJMzIuLi4uLgkzMwkzNC4JMzUuCTM5
CTQxLgk0My4uLi4uCTQ0Li4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLgk0Ngk0OAk1Mwk1
OC4uLi4JNTkuLi4uLi4uLi4uLgk2MCBTVUNDRVNTCgpCaXNlY3Rpbmc6IDEgcmV2aXNpb24g
bGVmdCB0byB0ZXN0IGFmdGVyIHRoaXMgKHJvdWdobHkgMSBzdGVwKQpbNmMzYjRkNDRiYTI4
MzhmMDA2MTRhNWEyZDc3N2Q0NDAxZTBiZmQ3MV0gc2NoZWQ6IENsZWFuIHVwIGlkbGUgdGFz
ayBTTVAgbG9naWMKcnVubmluZyAvYy9rZXJuZWwtdGVzdHMvYmlzZWN0LXRlc3QtYm9vdC1m
YWlsdXJlLnNoIC9rZXJuZWwtdGVzdHMvbGludXgvb2JqLWJpc2VjdApscyAtYSAva2VybmVs
LXRlc3RzL3J1bi1xdWV1ZS9rdm0vaTM4Ni1yYW5kY29uZmlnLXgxLTAyMTUyMjA4L25leHQ6
bWFzdGVyOjZjM2I0ZDQ0YmEyODM4ZjAwNjE0YTVhMmQ3NzdkNDQwMWUwYmZkNzE6YmlzZWN0
LWxpbnV4CjIwMTQtMDItMTcgMDM6NTk6MzA6IGNtZF9mYWlsOiAnL2Jpbi9ncmVwJyAnLXIn
ICctLWluY2x1ZGU9ZG1lc2ctKicgJy1zJyAnLWwnICdFSVAgaXMgYXQgcGlja19uZXh0X3Rh
c2srMHgnICcva2VybmVsL2kzODYtcmFuZGNvbmZpZy14MS0wMjE1MjIwOC82YzNiNGQ0NGJh
MjgzOGYwMDYxNGE1YTJkNzc3ZDQ0MDFlMGJmZDcxJyAsIHJldD0yLCByZWY6IC9rZXJuZWwt
dGVzdHMvZmFpbGVkLWNtZC9iZWUtZ3JlcC1rYnVpbGQubG9nCgoyMDE0LTAyLTE3LTAzOjU5
OjMwIDZjM2I0ZDQ0YmEyODM4ZjAwNjE0YTVhMmQ3NzdkNDQwMWUwYmZkNzEgY29tcGlsaW5n
CjExIHJlYWwgIDIyIHVzZXIgIDEgc3lzICAyMTMuODglIGNwdSAJaTM4Ni1yYW5kY29uZmln
LXgxLTAyMTUyMjA4CgoyMDE0LTAyLTE3LTAzOjU5OjQ3IGRldGVjdGluZyBib290IHN0YXRl
IDMuMTMuMC0xMTMyOS1nNmMzYjRkNC4uLgkyLgk1Li4JNgk3CTgJMTAJMTIJMTQuCTE3CTE4
Li4JMjAJMjEJMjIuCTI0Li4JMjUuCTI2Li4uLi4uLi4uCTI3CTI4Li4uLgkyOS4JMzAuCTM1
LgkzNi4JMzcJNDAuCTQ1CTQ5Lgk1NC4JNTcuLi4uCTU4Li4JNTkuLgk2MCBTVUNDRVNTCgpC
aXNlY3Rpbmc6IDAgcmV2aXNpb25zIGxlZnQgdG8gdGVzdCBhZnRlciB0aGlzIChyb3VnaGx5
IDAgc3RlcHMpClszODAzM2MzN2ZhYWI4NTBlZDVkMzNiYjY3NWM0ZGU2YzY2YmU4NGQ4XSBz
Y2hlZDogUHVzaCBkb3duIHByZV9zY2hlZHVsZSgpIGFuZCBpZGxlX2JhbGFuY2UoKQpydW5u
aW5nIC9jL2tlcm5lbC10ZXN0cy9iaXNlY3QtdGVzdC1ib290LWZhaWx1cmUuc2ggL2tlcm5l
bC10ZXN0cy9saW51eC9vYmotYmlzZWN0CmxzIC1hIC9rZXJuZWwtdGVzdHMvcnVuLXF1ZXVl
L2t2bS9pMzg2LXJhbmRjb25maWcteDEtMDIxNTIyMDgvbmV4dDptYXN0ZXI6MzgwMzNjMzdm
YWFiODUwZWQ1ZDMzYmI2NzVjNGRlNmM2NmJlODRkODpiaXNlY3QtbGludXgKMjAxNC0wMi0x
NyAwNDozNTo0ODogY21kX2ZhaWw6ICcvYmluL2dyZXAnICctcicgJy0taW5jbHVkZT1kbWVz
Zy0qJyAnLXMnICctbCcgJ0VJUCBpcyBhdCBwaWNrX25leHRfdGFzaysweCcgJy9rZXJuZWwv
aTM4Ni1yYW5kY29uZmlnLXgxLTAyMTUyMjA4LzM4MDMzYzM3ZmFhYjg1MGVkNWQzM2JiNjc1
YzRkZTZjNjZiZTg0ZDgnICwgcmV0PTIsIHJlZjogL2tlcm5lbC10ZXN0cy9mYWlsZWQtY21k
L2JlZS1ncmVwLWtidWlsZC5sb2cKCjIwMTQtMDItMTctMDQ6MzU6NDggMzgwMzNjMzdmYWFi
ODUwZWQ1ZDMzYmI2NzVjNGRlNmM2NmJlODRkOCBjb21waWxpbmcKMTEgcmVhbCAgMjcgdXNl
ciAgMiBzeXMgIDI2NC43MCUgY3B1IAlpMzg2LXJhbmRjb25maWcteDEtMDIxNTIyMDgKCjIw
MTQtMDItMTctMDQ6MzY6MDQgZGV0ZWN0aW5nIGJvb3Qgc3RhdGUgMy4xMy4wLTExMzMwLWcz
ODAzM2MzLiBURVNUIEZBSUxVUkUKWyAgICAyLjk1NTIxOF0gLi4uLi4uLi4uLi4uLi4uLi4u
Li4uLi4uLi4uLi4uLi4uLi4uIGRvbmUuClsgICAgMi45NTU5MTRdIFVzaW5nIElQSSBOby1T
aG9ydGN1dCBtb2RlClsgICAgMi45NTk3OTBdIFVucmVnaXN0ZXIgcHYgc2hhcmVkIG1lbW9y
eSBmb3IgY3B1IDAKWyAgICAyLjk4MDk4Nl0gQlVHOiB1bmFibGUgdG8gaGFuZGxlIGtlcm5l
bCBOVUxMIHBvaW50ZXIgZGVyZWZlcmVuY2UgYXQgMDAwMDAwNDAKWyAgICAyLjk4MjA5Nl0g
SVA6IFs8YzMwNWQzNDI+XSBwaWNrX25leHRfdGFzaysweGEvMHg0OApbICAgIDIuOTgyODU0
XSAqcGRwdCA9IDAwMDAwMDAwMDAwMDAwMDAgKnBkZSA9IGYwMDBmZjUzZjAwMGZmNTMgClsg
ICAgMi45ODMyNDddIE9vcHM6IDAwMDAgWyMxXSBTTVAgREVCVUdfUEFHRUFMTE9DClsgICAg
Mi45ODMyNDddIENQVTogMCBQSUQ6IDkgQ29tbTogbWlncmF0aW9uLzAgTm90IHRhaW50ZWQg
My4xMy4wLTExMzMwLWczODAzM2MzICMxMTcKWyAgICAyLjk4MzI0N10gdGFzazogY2JjNWQ1
ODAgdGk6IGNiYzljMDAwIHRhc2sudGk6IGNiYzljMDAwClsgICAgMi45ODMyNDddIEVJUDog
MDA2MDpbPGMzMDVkMzQyPl0gRUZMQUdTOiAwMDAxMDA0NiBDUFU6IDAKWyAgICAyLjk4MzI0
N10gRUlQIGlzIGF0IHBpY2tfbmV4dF90YXNrKzB4YS8weDQ4ClsgICAgMi45ODMyNDddIEVB
WDogY2U3OWMxMDAgRUJYOiBjZTc5YzEwMCBFQ1g6IDAwMDAwMDAwIEVEWDogMDAwMDAwMDAK
WyAgICAyLjk4MzI0N10gRVNJOiBjZTc5YzEwMCBFREk6IDAwMDAwMDAwIEVCUDogY2JjOWRk
YzAgRVNQOiBjYmM5ZGRiNApbICAgIDIuOTgzMjQ3XSAgRFM6IDAwN2IgRVM6IDAwN2IgRlM6
IDAwZDggR1M6IDAwMDAgU1M6IDAwNjgKWyAgICAyLjk4MzI0N10gQ1IwOiA4MDA1MDAzYiBD
UjI6IDAwMDAwMDQwIENSMzogMDM3NjkwMDAgQ1I0OiAwMDAwMDZiMApbICAgIDIuOTgzMjQ3
XSBTdGFjazoKWyAgICAyLjk4MzI0N10gIGNlNzljMTAwIGNlNzljMTAwIGMzNjUzODcwIGNi
YzlkZGU0IGMzMDYxZTY0IDAwMDAwMjAwIGNiYzVkNTgwIDAwMDAwMDgyClsgICAgMi45ODMy
NDddICAwMDAwMDAwMCBjMzY1NDc2NCAwMDAwMDAwMCBjMzY1Mzg3MCBjYmM5ZGUwMCBjMzA1
OTVlZCAwMDAwMDAwMCAwMDAwMDAwOApbICAgIDIuOTgzMjQ3XSAgZmZmZmZmZmYgY2JjNTVl
NmMgMDAwMDAwMDAgY2JjOWRlMTQgYzMwNTk4YTUgZmZmZmZmZmIgMDAwMDAwMDAgMDAwMDAw
MDAKWyAgICAyLjk4MzI0N10gQ2FsbCBUcmFjZToKWyAgICAyLjk4MzI0N10gIFs8YzMwNjFl
NjQ+XSBtaWdyYXRpb25fY2FsbCsweDEwYi8weDE4OApbICAgIDIuOTgzMjQ3XSAgWzxjMzA1
OTVlZD5dIG5vdGlmaWVyX2NhbGxfY2hhaW4rMHgzMi8weDRiClsgICAgMi45ODMyNDddICBb
PGMzMDU5OGE1Pl0gX19yYXdfbm90aWZpZXJfY2FsbF9jaGFpbisweDFlLzB4MjMKWyAgICAy
Ljk4MzI0N10gIFs8YzMwM2Q4NDE+XSBfX2NwdV9ub3RpZnkrMHgyNC8weDNlClsgICAgMi45
ODMyNDddICBbPGMzMDNkODczPl0gY3B1X25vdGlmeSsweDE4LzB4MWEKWyAgICAyLjk4MzI0
N10gIFs8YzMzZjJkMmY+XSB0YWtlX2NwdV9kb3duKzB4MjIvMHgzMgpbICAgIDIuOTgzMjQ3
XSAgWzxjMzA5YmE4Yz5dIG11bHRpX2NwdV9zdG9wKzB4ODAvMHhjZQpbICAgIDIuOTgzMjQ3
XSAgWzxjMzA5YmEwYz5dID8gX19zdG9wX2NwdXMrMHg1NS8weDU1ClsgICAgMi45ODMyNDdd
ICBbPGMzMDliODNiPl0gY3B1X3N0b3BwZXJfdGhyZWFkKzB4ODAvMHgxMTEKWyAgICAyLjk4
MzI0N10gIFs8YzMwNzM0NzQ+XSA/IF9fbG9ja19hY3F1aXJlLmlzcmEuMjcrMHgxY2IvMHg0
ZWEKWyAgICAyLjk4MzI0N10gIFs8YzMzZmI1ZGM+XSA/IF9fc2NoZWR1bGUrMHgzNzUvMHg1
NWMKWyAgICAyLjk4MzI0N10gIFs8YzMwNzNhNjg+XSA/IGxvY2tfYWNxdWlyZSsweDkzLzB4
ZTAKWyAgICAyLjk4MzI0N10gIFs8YzMwNzNlMjA+XSA/IGxvY2tfcmVsZWFzZSsweDE2ZC8w
eDFiMQpbICAgIDIuOTgzMjQ3XSAgWzxjMzNmZTY5OT5dID8gX3Jhd19zcGluX3VubG9ja19p
cnFyZXN0b3JlKzB4NDQvMHg0ZgpbICAgIDIuOTgzMjQ3XSAgWzxjMzA1YjRiZD5dIHNtcGJv
b3RfdGhyZWFkX2ZuKzB4MTVkLzB4MTczClsgICAgMi45ODMyNDddICBbPGMzMDViMzYwPl0g
PyBzbXBib290X3VucGFya190aHJlYWQrMHgyZS8weDJlClsgICAgMi45ODMyNDddICBbPGMz
MDU2MmJiPl0ga3RocmVhZCsweDhkLzB4OTIKWyAgICAyLjk4MzI0N10gIFs8YzMwNTAwMDA+
XSA/IF9fcXVldWVfd29yaysweDIwLzB4MjA1ClsgICAgMi45ODMyNDddICBbPGMzM2ZmOGY3
Pl0gcmV0X2Zyb21fa2VybmVsX3RocmVhZCsweDFiLzB4MjgKWyAgICAyLjk4MzI0N10gIFs8
YzMwNTYyMmU+XSA/IF9fa3RocmVhZF9wYXJrbWUrMHg1NS8weDU1ClsgICAgMi45ODMyNDdd
IENvZGU6IDAwIGJhIDAxIDAwIDAwIDAwIDg5IGYwIGViIDBlIDg5IGYwIGU4IGIxIDExIDNh
IDAwIGJhIDAxIDAwIDAwIDAwIDg5IGQ4IGU4IGZjIDE4IDNhIDAwIDViIDVlIDVkIGMzIDU1
IDg5IGU1IDU3IDg5IGQ3IDU2IDg5IGM2IDUzIDw4MT4gN2EgNDAgMzQgYzMgNDAgYzMgNzQg
MDcgYmIgNjAgYzQgNDAgYzMgZWIgMjMgOGIgNDAgNmMgMzkgNDYKWyAgICAyLjk4MzI0N10g
RUlQOiBbPGMzMDVkMzQyPl0gcGlja19uZXh0X3Rhc2srMHhhLzB4NDggU1M6RVNQIDAwNjg6
Y2JjOWRkYjQKWyAgICAyLjk4MzI0N10gQ1IyOiAwMDAwMDAwMDAwMDAwMDQwClsgICAgMi45
ODMyNDddIC0tLVsgZW5kIHRyYWNlIDZhOGNhNDU2YWZjYmUyZGMgXS0tLQpbICAgIDIuOTgz
MjQ3XSBLZXJuZWwgcGFuaWMgLSBub3Qgc3luY2luZzogRmF0YWwgZXhjZXB0aW9uCi9rZXJu
ZWwvaTM4Ni1yYW5kY29uZmlnLXgxLTAyMTUyMjA4LzM4MDMzYzM3ZmFhYjg1MGVkNWQzM2Ji
Njc1YzRkZTZjNjZiZTg0ZDgvZG1lc2ctcXVhbnRhbC1pbm4tMTk6MjAxNDAyMTcwNDM2MjQ6
aTM4Ni1yYW5kY29uZmlnLXgxLTAyMTUyMjA4OjMuMTMuMC0xMTMzMC1nMzgwMzNjMzoxMTcK
MDoxOjEgYWxsX2dvb2Q6YmFkOmFsbF9iYWQgYm9vdHMKCjM4MDMzYzM3ZmFhYjg1MGVkNWQz
M2JiNjc1YzRkZTZjNjZiZTg0ZDggaXMgdGhlIGZpcnN0IGJhZCBjb21taXQKY29tbWl0IDM4
MDMzYzM3ZmFhYjg1MGVkNWQzM2JiNjc1YzRkZTZjNjZiZTg0ZDgKQXV0aG9yOiBQZXRlciBa
aWpsc3RyYSA8cGV0ZXJ6QGluZnJhZGVhZC5vcmc+CkRhdGU6ICAgVGh1IEphbiAyMyAyMDoz
MjoyMSAyMDE0ICswMTAwCgogICAgc2NoZWQ6IFB1c2ggZG93biBwcmVfc2NoZWR1bGUoKSBh
bmQgaWRsZV9iYWxhbmNlKCkKICAgIAogICAgVGhpcyBwYXRjaCBib3RoIG1lcmdlZCBpZGxl
X2JhbGFuY2UoKSBhbmQgcHJlX3NjaGVkdWxlKCkgYW5kIHB1c2hlcwogICAgYm90aCBvZiB0
aGVtIGludG8gcGlja19uZXh0X3Rhc2soKS4KICAgIAogICAgQ29uY2VwdHVhbGx5IHByZV9z
Y2hlZHVsZSgpIGFuZCBpZGxlX2JhbGFuY2UoKSBhcmUgcmF0aGVyIHNpbWlsYXIsCiAgICBi
b3RoIGFyZSB1c2VkIHRvIHB1bGwgbW9yZSB3b3JrIG9udG8gdGhlIGN1cnJlbnQgQ1BVLgog
ICAgCiAgICBXZSBjYW5ub3QgaG93ZXZlciBmaXJzdCBtb3ZlIGlkbGVfYmFsYW5jZSgpIGlu
dG8gcHJlX3NjaGVkdWxlX2ZhaXIoKQogICAgc2luY2UgdGhlcmUgaXMgbm8gZ3VhcmFudGVl
IHRoZSBsYXN0IHJ1bm5hYmxlIHRhc2sgaXMgYSBmYWlyIHRhc2ssIGFuZAogICAgdGh1cyB3
ZSB3b3VsZCBtaXNzIG5ld2lkbGUgYmFsYW5jZXMuCiAgICAKICAgIFNpbWlsYXJseSwgdGhl
IGRsIGFuZCBydCBwcmVfc2NoZWR1bGUgY2FsbHMgbXVzdCBiZSByYW4gYmVmb3JlCiAgICBp
ZGxlX2JhbGFuY2UoKSBzaW5jZSB0aGVpciByZXNwZWN0aXZlIHRhc2tzIGhhdmUgaGlnaGVy
IHByaW9yaXR5IGFuZAogICAgaXQgd291bGQgbm90IGRvIHRvIGRlbGF5IHRoZWlyIGV4ZWN1
dGlvbiBzZWFyY2hpbmcgZm9yIGxlc3MgaW1wb3J0YW50CiAgICB0YXNrcyBmaXJzdC4KICAg
IAogICAgSG93ZXZlciwgYnkgbm90aWNpbmcgdGhhdCBwaWNrX25leHRfdGFza3MoKSBhbHJl
YWR5IHRyYXZlcnNlcyB0aGUKICAgIHNjaGVkX2NsYXNzIGhpZXJhcmNoeSBpbiB0aGUgcmln
aHQgb3JkZXIsIHdlIGNhbiBnZXQgdGhlIHJpZ2h0CiAgICBiZWhhdmlvdXIgYW5kIGRvIGF3
YXkgd2l0aCBib3RoIGNhbGxzLgogICAgCiAgICBXZSBtdXN0IGhvd2V2ZXIgY2hhbmdlIHRo
ZSBzcGVjaWFsIGNhc2Ugb3B0aW1pemF0aW9uIHRvIGFsc28gcmVxdWlyZQogICAgdGhhdCBw
cmV2IGlzIG9mIHNjaGVkX2NsYXNzX2ZhaXIsIG90aGVyd2lzZSB3ZSBjYW4gbWlzcyBkb2lu
ZyBhIGRsIG9yCiAgICBydCBwdWxsIHdoZXJlIHdlIG5lZWRlZCBvbmUuCiAgICAKICAgIFNp
Z25lZC1vZmYtYnk6IFBldGVyIFppamxzdHJhIDxwZXRlcnpAaW5mcmFkZWFkLm9yZz4KICAg
IENjOiBMaW51cyBUb3J2YWxkcyA8dG9ydmFsZHNAbGludXgtZm91bmRhdGlvbi5vcmc+CiAg
ICBDYzogQW5kcmV3IE1vcnRvbiA8YWtwbUBsaW51eC1mb3VuZGF0aW9uLm9yZz4KICAgIENj
OiBQZXRlciBaaWpsc3RyYSA8cGV0ZXJ6QGluZnJhZGVhZC5vcmc+CiAgICBDYzogVGhvbWFz
IEdsZWl4bmVyIDx0Z2x4QGxpbnV0cm9uaXguZGU+CiAgICBMaW5rOiBodHRwOi8vbGttbC5r
ZXJuZWwub3JnL24vdGlwLWE4azZ2dmFlYnRuNjRuaWUzNDVreDFqZUBnaXQua2VybmVsLm9y
ZwogICAgU2lnbmVkLW9mZi1ieTogSW5nbyBNb2xuYXIgPG1pbmdvQGtlcm5lbC5vcmc+Cgo6
MDQwMDAwIDA0MDAwMCBkMmY5MDk1ZWIxMzJhMGFjZGNlNGFiZWEyYTg2MTc4ZjNjNDEyMmY3
IGRhMDlhZWU4ZDRjMGU0NTU3ZjExMWE0OWJiMjYyNDY3NDMxOTIyOTkgTQlrZXJuZWwKYmlz
ZWN0IHJ1biBzdWNjZXNzCmV4aXQKL2Mva2VybmVsLXRlc3RzL2xpbmVhci1iaXNlY3Q6MTYz
OmluIGBleGl0JwovYy9rZXJuZWwtdGVzdHMvbGluZWFyLWJpc2VjdDoxNjM6aW4gYGdpdF9i
aXNlY3QnCi9jL2tlcm5lbC10ZXN0cy9saW5lYXItYmlzZWN0OjI5MDppbiBgbGluZWFyX2Jp
c2VjdCcKL2Mva2VybmVsLXRlc3RzL2xpbmVhci1iaXNlY3Q6Mjk0OmluIGA8bWFpbj4nCmV4
aXQKL2Mva2VybmVsLXRlc3RzL2xpbmVhci1iaXNlY3Q6MTYzOmluIGBleGl0JwovYy9rZXJu
ZWwtdGVzdHMvbGluZWFyLWJpc2VjdDoxNjM6aW4gYGdpdF9iaXNlY3QnCi9jL2tlcm5lbC10
ZXN0cy9saW5lYXItYmlzZWN0OjI5MDppbiBgbGluZWFyX2Jpc2VjdCcKL2Mva2VybmVsLXRl
c3RzL2xpbmVhci1iaXNlY3Q6Mjk0OmluIGA8bWFpbj4nCmxzIC1hIC9rZXJuZWwtdGVzdHMv
cnVuLXF1ZXVlL2t2bS9pMzg2LXJhbmRjb25maWcteDEtMDIxNTIyMDgvbmV4dDptYXN0ZXI6
NmMzYjRkNDRiYTI4MzhmMDA2MTRhNWEyZDc3N2Q0NDAxZTBiZmQ3MTpiaXNlY3QtbGludXgK
CjIwMTQtMDItMTctMDQ6MzY6MzYgNmMzYjRkNDRiYTI4MzhmMDA2MTRhNWEyZDc3N2Q0NDAx
ZTBiZmQ3MSByZXVzZSAva2VybmVsL2kzODYtcmFuZGNvbmZpZy14MS0wMjE1MjIwOC82YzNi
NGQ0NGJhMjgzOGYwMDYxNGE1YTJkNzc3ZDQ0MDFlMGJmZDcxL3ZtbGludXotMy4xMy4wLTEx
MzI5LWc2YzNiNGQ0CgoyMDE0LTAyLTE3LTA0OjM2OjM2IGRldGVjdGluZyBib290IHN0YXRl
IC4uCTEuCTMuCTQuLi4JNQk3CTEwLgkxMS4JMTIuCTEzLi4uCTE0CTE4CTIwCTIxCTIzCTI1
CTI3CTMwCTMxCTMyLgkzMwkzNAkzNwk0MAk0Mgk0NC4JNDcJNDkJNTIJNTUJNjAJNjIJNjMJ
NjQJNjUuLi4uLi4uLi4uCTY3CTY4Lgk3MC4uLgk3Mgk3Mwk4My4uLgk4NC4uLi4uLi4JODUu
Li4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uCTg5CTk0CTEwMgkxMDcJMTExCTExOS4u
CTEyMC4uLgkxMjEuCTEyMwkxMjQuLi4uCTEyNS4uLi4uLi4uLi4uLi4uLi4uLgkxMjYuLi4u
Li4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4u
Li4uLi4JMTQ3CTE0OAkxNDkJMTUxLi4uLgkxNTIJMTU0CTE1Ni4JMTY4CTE3MwkxNzcJMTgw
IFNVQ0NFU1MKCmxzIC1hIC9rZXJuZWwtdGVzdHMvcnVuLXF1ZXVlL2t2bS9pMzg2LXJhbmRj
b25maWcteDEtMDIxNTIyMDgvbmV4dDptYXN0ZXI6ZGE4ZDMwOGZiZGI4MzYwMDc4Nzg2YjNl
MTI1MjM4MTIyYzRmYzYxMTpiaXNlY3QtbGludXgKIFRFU1QgRkFJTFVSRQpbICAgMTQuMTMy
NDM0XSAuLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4gZG9uZS4KWyAgIDE0
LjEzNDYyM10gVXNpbmcgSVBJIE5vLVNob3J0Y3V0IG1vZGUKWyAgIDE0LjEzODg2Ml0gVW5y
ZWdpc3RlciBwdiBzaGFyZWQgbWVtb3J5IGZvciBjcHUgMApbICAgMTQuMjY2NzQ4XSBCVUc6
IHVuYWJsZSB0byBoYW5kbGUga2VybmVsIE5VTEwgcG9pbnRlciBkZXJlZmVyZW5jZSBhdCAw
MDAwMDA0MApbICAgMTQuMjY4MjU1XSBJUDogWzxjMjg1ZDJjMj5dIHBpY2tfbmV4dF90YXNr
KzB4YS8weDQ4ClsgICAxNC4yNjgyNTVdICpwZHB0ID0gMDAwMDAwMDAwMDAwMDAwMCAqcGRl
ID0gZjAwMGZmNTNmMDAwZmY1MyAKWyAgIDE0LjI2ODI1NV0gT29wczogMDAwMCBbIzFdIFNN
UCBERUJVR19QQUdFQUxMT0MKWyAgIDE0LjI2ODI1NV0gQ1BVOiAwIFBJRDogOSBDb21tOiBt
aWdyYXRpb24vMCBOb3QgdGFpbnRlZCAzLjE0LjAtcmMyLW5leHQtMjAxNDAyMTQtMDMyMjYt
Z2RhOGQzMDggIzEKWyAgIDE0LjI2ODI1NV0gdGFzazogY2JjNWQ1ODAgdGk6IGNiYzljMDAw
IHRhc2sudGk6IGNiYzljMDAwClsgICAxNC4yNjgyNTVdIEVJUDogMDA2MDpbPGMyODVkMmMy
Pl0gRUZMQUdTOiAwMDAxMDA0NiBDUFU6IDAKWyAgIDE0LjI2ODI1NV0gRUlQIGlzIGF0IHBp
Y2tfbmV4dF90YXNrKzB4YS8weDQ4ClsgICAxNC4yNjgyNTVdIEVBWDogY2U3OWMxMDAgRUJY
OiBjZTc5YzEwMCBFQ1g6IDAwMDAwMDAzIEVEWDogMDAwMDAwMDAKWyAgIDE0LjI2ODI1NV0g
RVNJOiBjZTc5YzEwMCBFREk6IDAwMDAwMDAwIEVCUDogY2JjOWRkYzAgRVNQOiBjYmM5ZGRi
NApbICAgMTQuMjY4MjU1XSAgRFM6IDAwN2IgRVM6IDAwN2IgRlM6IDAwZDggR1M6IDAwMDAg
U1M6IDAwNjgKWyAgIDE0LjI2ODI1NV0gQ1IwOiA4MDA1MDAzYiBDUjI6IDAwMDAwMDQwIENS
MzogMDJmNzMwMDAgQ1I0OiAwMDAwMDZiMApbICAgMTQuMjY4MjU1XSBTdGFjazoKWyAgIDE0
LjI2ODI1NV0gIGNlNzljMTAwIGNlNzljMTAwIGMyZTViOTMwIGNiYzlkZGU0IGMyODYxZGU1
IDAwMDAwMjAwIGNiYzVkNTgwIDAwMDAwMDgyClsgICAxNC4yNjgyNTVdICAwMDAwMDAwMCBj
MmU1Yzg2NCAwMDAwMDAwMCBjMmU1YjkzMCBjYmM5ZGUwMCBjMjg1OTU3NCAwMDAwMDAwMCAw
MDAwMDAwOApbICAgMTQuMjY4MjU1XSAgZmZmZmZmZmYgY2JjNTVlNmMgMDAwMDAwMDAgY2Jj
OWRlMTQgYzI4NTk4MmMgZmZmZmZmZmIgMDAwMDAwMDAgMDAwMDAwMDAKWyAgIDE0LjI2ODI1
NV0gQ2FsbCBUcmFjZToKWyAgIDE0LjI2ODI1NV0gIFs8YzI4NjFkZTU+XSBtaWdyYXRpb25f
Y2FsbCsweDEwYi8weDE4OApbICAgMTQuMjY4MjU1XSAgWzxjMjg1OTU3ND5dIG5vdGlmaWVy
X2NhbGxfY2hhaW4rMHgzMi8weDRiClsgICAxNC4yNjgyNTVdICBbPGMyODU5ODJjPl0gX19y
YXdfbm90aWZpZXJfY2FsbF9jaGFpbisweDFlLzB4MjMKWyAgIDE0LjI2ODI1NV0gIFs8YzI4
M2Q3YjE+XSBfX2NwdV9ub3RpZnkrMHgyNC8weDNlClsgICAxNC4yNjgyNTVdICBbPGMyODNk
N2UzPl0gY3B1X25vdGlmeSsweDE4LzB4MWEKWyAgIDE0LjI2ODI1NV0gIFs8YzJiZjY5M2Q+
XSB0YWtlX2NwdV9kb3duKzB4MjIvMHgzMgpbICAgMTQuMjY4MjU1XSAgWzxjMjg5YjQ5MT5d
IG11bHRpX2NwdV9zdG9wKzB4ODAvMHhjZQpbICAgMTQuMjY4MjU1XSAgWzxjMjg5YjQxMT5d
ID8gX19zdG9wX2NwdXMrMHg1NS8weDU1ClsgICAxNC4yNjgyNTVdICBbPGMyODliMjQwPl0g
Y3B1X3N0b3BwZXJfdGhyZWFkKzB4ODAvMHgxMTEKWyAgIDE0LjI2ODI1NV0gIFs8YzI4NWNi
ZDU+XSA/IGZpbmlzaF90YXNrX3N3aXRjaCsweDMzLzB4YmEKWyAgIDE0LjI2ODI1NV0gIFs8
YzJiZmYzNWU+XSA/IF9fc2NoZWR1bGUrMHgzNzcvMHg1NWUKWyAgIDE0LjI2ODI1NV0gIFs8
YzI4NzM2OGI+XSA/IF9fbG9ja19hY3F1aXJlLmlzcmEuMjcrMHgxYmUvMHg0ZGQKWyAgIDE0
LjI2ODI1NV0gIFs8YzI4NzNjODE+XSA/IGxvY2tfYWNxdWlyZSsweDkzLzB4ZTAKWyAgIDE0
LjI2ODI1NV0gIFs8YzI4NzQwMzk+XSA/IGxvY2tfcmVsZWFzZSsweDE2ZC8weDFiMQpbICAg
MTQuMjY4MjU1XSAgWzxjMmMwMjQyMT5dID8gX3Jhd19zcGluX3VubG9ja19pcnFyZXN0b3Jl
KzB4NDQvMHg0ZgpbICAgMTQuMjY4MjU1XSAgWzxjMjg1YjQ0ND5dIHNtcGJvb3RfdGhyZWFk
X2ZuKzB4MTVkLzB4MTczClsgICAxNC4yNjgyNTVdICBbPGMyODViMmU3Pl0gPyBzbXBib290
X3VucGFya190aHJlYWQrMHgyZS8weDJlClsgICAxNC4yNjgyNTVdICBbPGMyODU2MjI1Pl0g
a3RocmVhZCsweDhkLzB4OTIKWyAgIDE0LjI2ODI1NV0gIFs8YzI4NTAwMDA+XSA/IF9fcXVl
dWVfd29yaysweGI2LzB4MjA1ClsgICAxNC4yNjgyNTVdICBbPGMyYzAzNjc3Pl0gcmV0X2Zy
b21fa2VybmVsX3RocmVhZCsweDFiLzB4MjgKWyAgIDE0LjI2ODI1NV0gIFs8YzI4NTYxOTg+
XSA/IF9fa3RocmVhZF9wYXJrbWUrMHg1NS8weDU1ClsgICAxNC4yNjgyNTVdIENvZGU6IDAw
IGJhIDAxIDAwIDAwIDAwIDg5IGYwIGViIDBlIDg5IGYwIGU4IGI5IDRmIDNhIDAwIGJhIDAx
IDAwIDAwIDAwIDg5IGQ4IGU4IDA0IDU3IDNhIDAwIDViIDVlIDVkIGMzIDU1IDg5IGU1IDU3
IDg5IGQ3IDU2IDg5IGM2IDUzIDw4MT4gN2EgNDAgNzQgMDMgYzEgYzIgNzQgMDcgYmIgYTAg
MDQgYzEgYzIgZWIgMjMgOGIgNDAgNmMgMzkgNDYKWyAgIDE0LjI2ODI1NV0gRUlQOiBbPGMy
ODVkMmMyPl0gcGlja19uZXh0X3Rhc2srMHhhLzB4NDggU1M6RVNQIDAwNjg6Y2JjOWRkYjQK
WyAgIDE0LjI2ODI1NV0gQ1IyOiAwMDAwMDAwMDAwMDAwMDQwClsgICAxNC4yNjgyNTVdIC0t
LVsgZW5kIHRyYWNlIGM4NDQ4MzI5NmVlMDhlZDUgXS0tLQpbICAgMTQuMjY4MjU1XSBLZXJu
ZWwgcGFuaWMgLSBub3Qgc3luY2luZzogRmF0YWwgZXhjZXB0aW9uCi9rZXJuZWwvaTM4Ni1y
YW5kY29uZmlnLXgxLTAyMTUyMjA4L2RhOGQzMDhmYmRiODM2MDA3ODc4NmIzZTEyNTIzODEy
MmM0ZmM2MTEvZG1lc2ctcXVhbnRhbC1zbmItMjoyMDE0MDIxNjIzMTQxNDppMzg2LXJhbmRj
b25maWcteDEtMDIxNTIyMDg6My4xNC4wLXJjMi1uZXh0LTIwMTQwMjE0LTAzMjI2LWdkYThk
MzA4OjEKL2tlcm5lbC9pMzg2LXJhbmRjb25maWcteDEtMDIxNTIyMDgvZGE4ZDMwOGZiZGI4
MzYwMDc4Nzg2YjNlMTI1MjM4MTIyYzRmYzYxMS9kbWVzZy15b2N0by1zbmItNzoyMDE0MDIx
NjIzMTM1ODppMzg2LXJhbmRjb25maWcteDEtMDIxNTIyMDg6My4xNC4wLXJjMi1uZXh0LTIw
MTQwMjE0LTAzMjI2LWdkYThkMzA4OjEKL2tlcm5lbC9pMzg2LXJhbmRjb25maWcteDEtMDIx
NTIyMDgvZGE4ZDMwOGZiZGI4MzYwMDc4Nzg2YjNlMTI1MjM4MTIyYzRmYzYxMS9kbWVzZy15
b2N0by14Z3dvLTY6MjAxNDAyMTYyMzEzMjQ6aTM4Ni1yYW5kY29uZmlnLXgxLTAyMTUyMjA4
OjMuMTQuMC1yYzItbmV4dC0yMDE0MDIxNC0wMzIyNi1nZGE4ZDMwODoxCi9rZXJuZWwvaTM4
Ni1yYW5kY29uZmlnLXgxLTAyMTUyMjA4L2RhOGQzMDhmYmRiODM2MDA3ODc4NmIzZTEyNTIz
ODEyMmM0ZmM2MTEvZG1lc2cteW9jdG8tbGtwLXNieDA0LTU2OjIwMTQwMjE1MjIxNzE1Omkz
ODYtcmFuZGNvbmZpZy14MS0wMjE1MjIwODo6Ci9rZXJuZWwvaTM4Ni1yYW5kY29uZmlnLXgx
LTAyMTUyMjA4L2RhOGQzMDhmYmRiODM2MDA3ODc4NmIzZTEyNTIzODEyMmM0ZmM2MTEvZG1l
c2cteW9jdG8taW5uLTE3OjIwMTQwMjE2MjMxMzU1OmkzODYtcmFuZGNvbmZpZy14MS0wMjE1
MjIwODozLjE0LjAtcmMyLW5leHQtMjAxNDAyMTQtMDMyMjYtZ2RhOGQzMDg6MQova2VybmVs
L2kzODYtcmFuZGNvbmZpZy14MS0wMjE1MjIwOC9kYThkMzA4ZmJkYjgzNjAwNzg3ODZiM2Ux
MjUyMzgxMjJjNGZjNjExL2RtZXNnLXlvY3RvLWxrcC1zYngwNC0yMDoyMDE0MDIxNTIyMTY1
ODppMzg2LXJhbmRjb25maWcteDEtMDIxNTIyMDg6Ogova2VybmVsL2kzODYtcmFuZGNvbmZp
Zy14MS0wMjE1MjIwOC9kYThkMzA4ZmJkYjgzNjAwNzg3ODZiM2UxMjUyMzgxMjJjNGZjNjEx
L2RtZXNnLXlvY3RvLWxrcC1zYngwNC0yNjoyMDE0MDIxNTIyMTY1NjppMzg2LXJhbmRjb25m
aWcteDEtMDIxNTIyMDg6Ogova2VybmVsL2kzODYtcmFuZGNvbmZpZy14MS0wMjE1MjIwOC9k
YThkMzA4ZmJkYjgzNjAwNzg3ODZiM2UxMjUyMzgxMjJjNGZjNjExL2RtZXNnLXF1YW50YWwt
bGtwLXNieDA0LTI4OjIwMTQwMjE1MjIxNzAyOmkzODYtcmFuZGNvbmZpZy14MS0wMjE1MjIw
ODo6Ci9rZXJuZWwvaTM4Ni1yYW5kY29uZmlnLXgxLTAyMTUyMjA4L2RhOGQzMDhmYmRiODM2
MDA3ODc4NmIzZTEyNTIzODEyMmM0ZmM2MTEvZG1lc2ctcXVhbnRhbC1zdG9ha2xleS00OjIw
MTQwMjE1MjIxNzE1OmkzODYtcmFuZGNvbmZpZy14MS0wMjE1MjIwODozLjE0LjAtcmMyLW5l
eHQtMjAxNDAyMTQtMDMyMjYtZ2RhOGQzMDg6MQova2VybmVsL2kzODYtcmFuZGNvbmZpZy14
MS0wMjE1MjIwOC9kYThkMzA4ZmJkYjgzNjAwNzg3ODZiM2UxMjUyMzgxMjJjNGZjNjExL2Rt
ZXNnLXlvY3RvLWpha2V0b3duLTEyOjIwMTQwMjE2MjMxNDA1OmkzODYtcmFuZGNvbmZpZy14
MS0wMjE1MjIwODozLjE0LjAtcmMyLW5leHQtMjAxNDAyMTQtMDMyMjYtZ2RhOGQzMDg6MQov
a2VybmVsL2kzODYtcmFuZGNvbmZpZy14MS0wMjE1MjIwOC9kYThkMzA4ZmJkYjgzNjAwNzg3
ODZiM2UxMjUyMzgxMjJjNGZjNjExL2RtZXNnLXF1YW50YWwtc25iLTM6MjAxNDAyMTYyMzE0
MTA6aTM4Ni1yYW5kY29uZmlnLXgxLTAyMTUyMjA4OjMuMTQuMC1yYzItbmV4dC0yMDE0MDIx
NC0wMzIyNi1nZGE4ZDMwODoxCi9rZXJuZWwvaTM4Ni1yYW5kY29uZmlnLXgxLTAyMTUyMjA4
L2RhOGQzMDhmYmRiODM2MDA3ODc4NmIzZTEyNTIzODEyMmM0ZmM2MTEvZG1lc2ctcXVhbnRh
bC1sa3Atc2J4MDQtODY6MjAxNDAyMTUyMjE3MDE6aTM4Ni1yYW5kY29uZmlnLXgxLTAyMTUy
MjA4OjoKL2tlcm5lbC9pMzg2LXJhbmRjb25maWcteDEtMDIxNTIyMDgvZGE4ZDMwOGZiZGI4
MzYwMDc4Nzg2YjNlMTI1MjM4MTIyYzRmYzYxMS9kbWVzZy1xdWFudGFsLWxrcC1zYngwNC0y
MToyMDE0MDIxNTIyMTcwNDppMzg2LXJhbmRjb25maWcteDEtMDIxNTIyMDg6Ogova2VybmVs
L2kzODYtcmFuZGNvbmZpZy14MS0wMjE1MjIwOC9kYThkMzA4ZmJkYjgzNjAwNzg3ODZiM2Ux
MjUyMzgxMjJjNGZjNjExL2RtZXNnLXF1YW50YWwtamFrZXRvd24tMTA6MjAxNDAyMTYyMzEz
NTE6aTM4Ni1yYW5kY29uZmlnLXgxLTAyMTUyMjA4OjMuMTQuMC1yYzItbmV4dC0yMDE0MDIx
NC0wMzIyNi1nZGE4ZDMwODoxCjQ6MTQ6MTUgYWxsX2dvb2Q6YmFkOmFsbF9iYWQgYm9vdHMK
CltkZXRhY2hlZCBIRUFEIGRhODVhMjVdIFJldmVydCAic2NoZWQ6IFB1c2ggZG93biBwcmVf
c2NoZWR1bGUoKSBhbmQgaWRsZV9iYWxhbmNlKCkiCiBDb21taXR0ZXI6IFd1IEZlbmdndWFu
ZyA8a2J1aWxkQGJlZT4KWW91ciBuYW1lIGFuZCBlbWFpbCBhZGRyZXNzIHdlcmUgY29uZmln
dXJlZCBhdXRvbWF0aWNhbGx5IGJhc2VkCm9uIHlvdXIgdXNlcm5hbWUgYW5kIGhvc3RuYW1l
LiBQbGVhc2UgY2hlY2sgdGhhdCB0aGV5IGFyZSBhY2N1cmF0ZS4KWW91IGNhbiBzdXBwcmVz
cyB0aGlzIG1lc3NhZ2UgYnkgc2V0dGluZyB0aGVtIGV4cGxpY2l0bHk6CgogICAgZ2l0IGNv
bmZpZyAtLWdsb2JhbCB1c2VyLm5hbWUgIllvdXIgTmFtZSIKICAgIGdpdCBjb25maWcgLS1n
bG9iYWwgdXNlci5lbWFpbCB5b3VAZXhhbXBsZS5jb20KCkFmdGVyIGRvaW5nIHRoaXMsIHlv
dSBtYXkgZml4IHRoZSBpZGVudGl0eSB1c2VkIGZvciB0aGlzIGNvbW1pdCB3aXRoOgoKICAg
IGdpdCBjb21taXQgLS1hbWVuZCAtLXJlc2V0LWF1dGhvcgoKIDYgZmlsZXMgY2hhbmdlZCwg
NTIgaW5zZXJ0aW9ucygrKSwgNDQgZGVsZXRpb25zKC0pCmxzIC1hIC9rZXJuZWwtdGVzdHMv
cnVuLXF1ZXVlL2t2bS9pMzg2LXJhbmRjb25maWcteDEtMDIxNTIyMDgvbmV4dDptYXN0ZXI6
ZGE4NWEyNWI2MmRkOWNhNzVlYzY0ZjZlMGQ2Y2RjYmFhNTc1MjQ3OTpiaXNlY3QtbGludXgK
CjIwMTQtMDItMTctMDY6MzI6MTAgZGE4NWEyNWI2MmRkOWNhNzVlYzY0ZjZlMGQ2Y2RjYmFh
NTc1MjQ3OSBjb21waWxpbmcKCjIwMTQtMDItMTctMDY6MzI6NTkgZGV0ZWN0aW5nIGJvb3Qg
c3RhdGUgMy4xNC4wLXJjMi1uZXh0LTIwMTQwMjE0LTAzMjI3LWdkYTg1YTI1Li4uLi4uLi4u
Li4uLi4uLgkxCTcJMTEJMTMJMTgJMjEJMjQuCTI1Li4uCTI3CTI4CTI5Li4uLi4uLi4uLi4u
Li4uLi4uLi4uLi4uLi4uLi4JMzAuCTQzCTUzCTY3CTczCTc3CTc4Lgk4Mi4JODQJODUJODYu
CTg3Li4JODkJOTAJOTEJOTMuCTk0Lgk5NQk5NgkxMDAJMTAxCTEwMwkxMDQuCTEwNQkxMDgJ
MTA5CTExMC4uCTExMQkxMTYJMTE3CTExOS4JMTIxCTEyMgkxMjMJMTI0CTEyNS4uLgkxMjYu
Li4uLi4JMTI3LgkxMjguLi4uCTEyOS4JMTMxLi4uCTEzMi4uLi4uLi4uLi4uLi4uLi4uLi4u
Li4uLi4uLi4uCTEzOAkxNTcJMTYxCTE3OC4uLi4uLi4JMTc5Li4uLi4uLi4JMTgwIFNVQ0NF
U1MKCgo9PT09PT09PT0gdXBzdHJlYW0gPT09PT09PT09CkZldGNoaW5nIGxpbnVzCkZyb20g
Z2l0Oi8vZ2l0bWlycm9yL2xpbnVzCiAgIDk0NmRkNjguLjZkMGFiZWMgIG1hc3RlciAgICAg
LT4gbGludXMvbWFzdGVyCiAqIFtuZXcgdGFnXSAgICAgICAgIHYzLjE0LXJjMyAgLT4gdjMu
MTQtcmMzCldhcm5pbmc6IHlvdSBhcmUgbGVhdmluZyAxIGNvbW1pdCBiZWhpbmQsIG5vdCBj
b25uZWN0ZWQgdG8KYW55IG9mIHlvdXIgYnJhbmNoZXM6CgogIGRhODVhMjUgUmV2ZXJ0ICJz
Y2hlZDogUHVzaCBkb3duIHByZV9zY2hlZHVsZSgpIGFuZCBpZGxlX2JhbGFuY2UoKSIKCklm
IHlvdSB3YW50IHRvIGtlZXAgdGhlbSBieSBjcmVhdGluZyBhIG5ldyBicmFuY2gsIHRoaXMg
bWF5IGJlIGEgZ29vZCB0aW1lCnRvIGRvIHNvIHdpdGg6CgogZ2l0IGJyYW5jaCBuZXdfYnJh
bmNoX25hbWUgZGE4NWEyNQoKSEVBRCBpcyBub3cgYXQgNmQwYWJlYy4uLiBMaW51eCAzLjE0
LXJjMwpscyAtYSAva2VybmVsLXRlc3RzL3J1bi1xdWV1ZS9rdm0vaTM4Ni1yYW5kY29uZmln
LXgxLTAyMTUyMjA4L25leHQ6bWFzdGVyOjZkMGFiZWNhMzI0MmE4OGNhYjgyMzJlNGFjZDdl
MmJmMDg4ZjNiYzI6YmlzZWN0LWxpbnV4CgoyMDE0LTAyLTE3LTA4OjA0OjA0IDZkMGFiZWNh
MzI0MmE4OGNhYjgyMzJlNGFjZDdlMmJmMDg4ZjNiYzIgY29tcGlsaW5nCgoyMDE0LTAyLTE3
LTA4OjA0OjQ4IGRldGVjdGluZyBib290IHN0YXRlIDMuMTQuMC1yYzMuLi4uLi4uLi4uLi4u
Li4uLgkxCTQuLgk1CTYuCTcJMTAJMTEuCTEzLi4JMTQuLi4uLi4JMTUuLgkxNgkxOAkyMwky
NAkyNgkyOAkyOQkzMAkzMwkzNgk0MC4uLi4JNDEJNDIuLi4uLi4uLi4JNDMJNDQJNDUuLgk0
Ny4JNDgJNDkJNTEuLi4uLi4uLgk1Mgk1OAk2MAk2MS4JNjIJNjQJNjkuCTcwCTczCTc2Lgk3
OQk4MQk4Mgk4NAk4Ni4JODcJODkJOTQJOTUJOTcuLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4u
Li4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uCTk4CTEwMQkxMTEJMTM0CTE0
MAkxNjAJMTcyCTE3NgkxNzcJMTc4Li4uLi4uLi4uLi4uLgkxNzkuLi4uLi4uLi4uLi4uLi4u
Li4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4u
Li4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4u
Li4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4u
Li4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4u
Li4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4u
Li4uLi4uLi4uLi4uLi4uG1sxOzM1bTIwMTQtMDItMTcgMTI6MTI6MjAgYWRkX3RvX3J1bl9x
dWV1ZSAxG1swbQouLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uCTE4MCBT
VUNDRVNTCgoKPT09PT09PT09IGxpbnV4LW5leHQgPT09PT09PT09ClByZXZpb3VzIEhFQUQg
cG9zaXRpb24gd2FzIDZkMGFiZWMuLi4gTGludXggMy4xNC1yYzMKSEVBRCBpcyBub3cgYXQg
ZGE4ZDMwOC4uLiBBZGQgbGludXgtbmV4dCBzcGVjaWZpYyBmaWxlcyBmb3IgMjAxNDAyMTQK
bHMgLWEgL2tlcm5lbC10ZXN0cy9ydW4tcXVldWUva3ZtL2kzODYtcmFuZGNvbmZpZy14MS0w
MjE1MjIwOC9uZXh0Om1hc3RlcjpkYThkMzA4ZmJkYjgzNjAwNzg3ODZiM2UxMjUyMzgxMjJj
NGZjNjExOmJpc2VjdC1saW51eAogVEVTVCBGQUlMVVJFClsgICAxNC4xMzI0MzRdIC4uLi4u
Li4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLiBkb25lLgpbICAgMTQuMTM0NjIzXSBV
c2luZyBJUEkgTm8tU2hvcnRjdXQgbW9kZQpbICAgMTQuMTM4ODYyXSBVbnJlZ2lzdGVyIHB2
IHNoYXJlZCBtZW1vcnkgZm9yIGNwdSAwClsgICAxNC4yNjY3NDhdIEJVRzogdW5hYmxlIHRv
IGhhbmRsZSBrZXJuZWwgTlVMTCBwb2ludGVyIGRlcmVmZXJlbmNlIGF0IDAwMDAwMDQwClsg
ICAxNC4yNjgyNTVdIElQOiBbPGMyODVkMmMyPl0gcGlja19uZXh0X3Rhc2srMHhhLzB4NDgK
WyAgIDE0LjI2ODI1NV0gKnBkcHQgPSAwMDAwMDAwMDAwMDAwMDAwICpwZGUgPSBmMDAwZmY1
M2YwMDBmZjUzIApbICAgMTQuMjY4MjU1XSBPb3BzOiAwMDAwIFsjMV0gU01QIERFQlVHX1BB
R0VBTExPQwpbICAgMTQuMjY4MjU1XSBDUFU6IDAgUElEOiA5IENvbW06IG1pZ3JhdGlvbi8w
IE5vdCB0YWludGVkIDMuMTQuMC1yYzItbmV4dC0yMDE0MDIxNC0wMzIyNi1nZGE4ZDMwOCAj
MQpbICAgMTQuMjY4MjU1XSB0YXNrOiBjYmM1ZDU4MCB0aTogY2JjOWMwMDAgdGFzay50aTog
Y2JjOWMwMDAKWyAgIDE0LjI2ODI1NV0gRUlQOiAwMDYwOls8YzI4NWQyYzI+XSBFRkxBR1M6
IDAwMDEwMDQ2IENQVTogMApbICAgMTQuMjY4MjU1XSBFSVAgaXMgYXQgcGlja19uZXh0X3Rh
c2srMHhhLzB4NDgKWyAgIDE0LjI2ODI1NV0gRUFYOiBjZTc5YzEwMCBFQlg6IGNlNzljMTAw
IEVDWDogMDAwMDAwMDMgRURYOiAwMDAwMDAwMApbICAgMTQuMjY4MjU1XSBFU0k6IGNlNzlj
MTAwIEVESTogMDAwMDAwMDAgRUJQOiBjYmM5ZGRjMCBFU1A6IGNiYzlkZGI0ClsgICAxNC4y
NjgyNTVdICBEUzogMDA3YiBFUzogMDA3YiBGUzogMDBkOCBHUzogMDAwMCBTUzogMDA2OApb
ICAgMTQuMjY4MjU1XSBDUjA6IDgwMDUwMDNiIENSMjogMDAwMDAwNDAgQ1IzOiAwMmY3MzAw
MCBDUjQ6IDAwMDAwNmIwClsgICAxNC4yNjgyNTVdIFN0YWNrOgpbICAgMTQuMjY4MjU1XSAg
Y2U3OWMxMDAgY2U3OWMxMDAgYzJlNWI5MzAgY2JjOWRkZTQgYzI4NjFkZTUgMDAwMDAyMDAg
Y2JjNWQ1ODAgMDAwMDAwODIKWyAgIDE0LjI2ODI1NV0gIDAwMDAwMDAwIGMyZTVjODY0IDAw
MDAwMDAwIGMyZTViOTMwIGNiYzlkZTAwIGMyODU5NTc0IDAwMDAwMDAwIDAwMDAwMDA4Clsg
ICAxNC4yNjgyNTVdICBmZmZmZmZmZiBjYmM1NWU2YyAwMDAwMDAwMCBjYmM5ZGUxNCBjMjg1
OTgyYyBmZmZmZmZmYiAwMDAwMDAwMCAwMDAwMDAwMApbICAgMTQuMjY4MjU1XSBDYWxsIFRy
YWNlOgpbICAgMTQuMjY4MjU1XSAgWzxjMjg2MWRlNT5dIG1pZ3JhdGlvbl9jYWxsKzB4MTBi
LzB4MTg4ClsgICAxNC4yNjgyNTVdICBbPGMyODU5NTc0Pl0gbm90aWZpZXJfY2FsbF9jaGFp
bisweDMyLzB4NGIKWyAgIDE0LjI2ODI1NV0gIFs8YzI4NTk4MmM+XSBfX3Jhd19ub3RpZmll
cl9jYWxsX2NoYWluKzB4MWUvMHgyMwpbICAgMTQuMjY4MjU1XSAgWzxjMjgzZDdiMT5dIF9f
Y3B1X25vdGlmeSsweDI0LzB4M2UKWyAgIDE0LjI2ODI1NV0gIFs8YzI4M2Q3ZTM+XSBjcHVf
bm90aWZ5KzB4MTgvMHgxYQpbICAgMTQuMjY4MjU1XSAgWzxjMmJmNjkzZD5dIHRha2VfY3B1
X2Rvd24rMHgyMi8weDMyClsgICAxNC4yNjgyNTVdICBbPGMyODliNDkxPl0gbXVsdGlfY3B1
X3N0b3ArMHg4MC8weGNlClsgICAxNC4yNjgyNTVdICBbPGMyODliNDExPl0gPyBfX3N0b3Bf
Y3B1cysweDU1LzB4NTUKWyAgIDE0LjI2ODI1NV0gIFs8YzI4OWIyNDA+XSBjcHVfc3RvcHBl
cl90aHJlYWQrMHg4MC8weDExMQpbICAgMTQuMjY4MjU1XSAgWzxjMjg1Y2JkNT5dID8gZmlu
aXNoX3Rhc2tfc3dpdGNoKzB4MzMvMHhiYQpbICAgMTQuMjY4MjU1XSAgWzxjMmJmZjM1ZT5d
ID8gX19zY2hlZHVsZSsweDM3Ny8weDU1ZQpbICAgMTQuMjY4MjU1XSAgWzxjMjg3MzY4Yj5d
ID8gX19sb2NrX2FjcXVpcmUuaXNyYS4yNysweDFiZS8weDRkZApbICAgMTQuMjY4MjU1XSAg
WzxjMjg3M2M4MT5dID8gbG9ja19hY3F1aXJlKzB4OTMvMHhlMApbICAgMTQuMjY4MjU1XSAg
WzxjMjg3NDAzOT5dID8gbG9ja19yZWxlYXNlKzB4MTZkLzB4MWIxClsgICAxNC4yNjgyNTVd
ICBbPGMyYzAyNDIxPl0gPyBfcmF3X3NwaW5fdW5sb2NrX2lycXJlc3RvcmUrMHg0NC8weDRm
ClsgICAxNC4yNjgyNTVdICBbPGMyODViNDQ0Pl0gc21wYm9vdF90aHJlYWRfZm4rMHgxNWQv
MHgxNzMKWyAgIDE0LjI2ODI1NV0gIFs8YzI4NWIyZTc+XSA/IHNtcGJvb3RfdW5wYXJrX3Ro
cmVhZCsweDJlLzB4MmUKWyAgIDE0LjI2ODI1NV0gIFs8YzI4NTYyMjU+XSBrdGhyZWFkKzB4
OGQvMHg5MgpbICAgMTQuMjY4MjU1XSAgWzxjMjg1MDAwMD5dID8gX19xdWV1ZV93b3JrKzB4
YjYvMHgyMDUKWyAgIDE0LjI2ODI1NV0gIFs8YzJjMDM2Nzc+XSByZXRfZnJvbV9rZXJuZWxf
dGhyZWFkKzB4MWIvMHgyOApbICAgMTQuMjY4MjU1XSAgWzxjMjg1NjE5OD5dID8gX19rdGhy
ZWFkX3BhcmttZSsweDU1LzB4NTUKWyAgIDE0LjI2ODI1NV0gQ29kZTogMDAgYmEgMDEgMDAg
MDAgMDAgODkgZjAgZWIgMGUgODkgZjAgZTggYjkgNGYgM2EgMDAgYmEgMDEgMDAgMDAgMDAg
ODkgZDggZTggMDQgNTcgM2EgMDAgNWIgNWUgNWQgYzMgNTUgODkgZTUgNTcgODkgZDcgNTYg
ODkgYzYgNTMgPDgxPiA3YSA0MCA3NCAwMyBjMSBjMiA3NCAwNyBiYiBhMCAwNCBjMSBjMiBl
YiAyMyA4YiA0MCA2YyAzOSA0NgpbICAgMTQuMjY4MjU1XSBFSVA6IFs8YzI4NWQyYzI+XSBw
aWNrX25leHRfdGFzaysweGEvMHg0OCBTUzpFU1AgMDA2ODpjYmM5ZGRiNApbICAgMTQuMjY4
MjU1XSBDUjI6IDAwMDAwMDAwMDAwMDAwNDAKWyAgIDE0LjI2ODI1NV0gLS0tWyBlbmQgdHJh
Y2UgYzg0NDgzMjk2ZWUwOGVkNSBdLS0tClsgICAxNC4yNjgyNTVdIEtlcm5lbCBwYW5pYyAt
IG5vdCBzeW5jaW5nOiBGYXRhbCBleGNlcHRpb24KL2tlcm5lbC9pMzg2LXJhbmRjb25maWct
eDEtMDIxNTIyMDgvZGE4ZDMwOGZiZGI4MzYwMDc4Nzg2YjNlMTI1MjM4MTIyYzRmYzYxMS9k
bWVzZy1xdWFudGFsLXNuYi0yOjIwMTQwMjE2MjMxNDE0OmkzODYtcmFuZGNvbmZpZy14MS0w
MjE1MjIwODozLjE0LjAtcmMyLW5leHQtMjAxNDAyMTQtMDMyMjYtZ2RhOGQzMDg6MQova2Vy
bmVsL2kzODYtcmFuZGNvbmZpZy14MS0wMjE1MjIwOC9kYThkMzA4ZmJkYjgzNjAwNzg3ODZi
M2UxMjUyMzgxMjJjNGZjNjExL2RtZXNnLXlvY3RvLXNuYi03OjIwMTQwMjE2MjMxMzU4Omkz
ODYtcmFuZGNvbmZpZy14MS0wMjE1MjIwODozLjE0LjAtcmMyLW5leHQtMjAxNDAyMTQtMDMy
MjYtZ2RhOGQzMDg6MQova2VybmVsL2kzODYtcmFuZGNvbmZpZy14MS0wMjE1MjIwOC9kYThk
MzA4ZmJkYjgzNjAwNzg3ODZiM2UxMjUyMzgxMjJjNGZjNjExL2RtZXNnLXlvY3RvLXhnd28t
NjoyMDE0MDIxNjIzMTMyNDppMzg2LXJhbmRjb25maWcteDEtMDIxNTIyMDg6My4xNC4wLXJj
Mi1uZXh0LTIwMTQwMjE0LTAzMjI2LWdkYThkMzA4OjEKL2tlcm5lbC9pMzg2LXJhbmRjb25m
aWcteDEtMDIxNTIyMDgvZGE4ZDMwOGZiZGI4MzYwMDc4Nzg2YjNlMTI1MjM4MTIyYzRmYzYx
MS9kbWVzZy15b2N0by1sa3Atc2J4MDQtNTY6MjAxNDAyMTUyMjE3MTU6aTM4Ni1yYW5kY29u
ZmlnLXgxLTAyMTUyMjA4OjoKL2tlcm5lbC9pMzg2LXJhbmRjb25maWcteDEtMDIxNTIyMDgv
ZGE4ZDMwOGZiZGI4MzYwMDc4Nzg2YjNlMTI1MjM4MTIyYzRmYzYxMS9kbWVzZy15b2N0by1p
bm4tMTc6MjAxNDAyMTYyMzEzNTU6aTM4Ni1yYW5kY29uZmlnLXgxLTAyMTUyMjA4OjMuMTQu
MC1yYzItbmV4dC0yMDE0MDIxNC0wMzIyNi1nZGE4ZDMwODoxCi9rZXJuZWwvaTM4Ni1yYW5k
Y29uZmlnLXgxLTAyMTUyMjA4L2RhOGQzMDhmYmRiODM2MDA3ODc4NmIzZTEyNTIzODEyMmM0
ZmM2MTEvZG1lc2cteW9jdG8tbGtwLXNieDA0LTIwOjIwMTQwMjE1MjIxNjU4OmkzODYtcmFu
ZGNvbmZpZy14MS0wMjE1MjIwODo6Ci9rZXJuZWwvaTM4Ni1yYW5kY29uZmlnLXgxLTAyMTUy
MjA4L2RhOGQzMDhmYmRiODM2MDA3ODc4NmIzZTEyNTIzODEyMmM0ZmM2MTEvZG1lc2cteW9j
dG8tbGtwLXNieDA0LTI2OjIwMTQwMjE1MjIxNjU2OmkzODYtcmFuZGNvbmZpZy14MS0wMjE1
MjIwODo6Ci9rZXJuZWwvaTM4Ni1yYW5kY29uZmlnLXgxLTAyMTUyMjA4L2RhOGQzMDhmYmRi
ODM2MDA3ODc4NmIzZTEyNTIzODEyMmM0ZmM2MTEvZG1lc2ctcXVhbnRhbC1sa3Atc2J4MDQt
Mjg6MjAxNDAyMTUyMjE3MDI6aTM4Ni1yYW5kY29uZmlnLXgxLTAyMTUyMjA4OjoKL2tlcm5l
bC9pMzg2LXJhbmRjb25maWcteDEtMDIxNTIyMDgvZGE4ZDMwOGZiZGI4MzYwMDc4Nzg2YjNl
MTI1MjM4MTIyYzRmYzYxMS9kbWVzZy1xdWFudGFsLXN0b2FrbGV5LTQ6MjAxNDAyMTUyMjE3
MTU6aTM4Ni1yYW5kY29uZmlnLXgxLTAyMTUyMjA4OjMuMTQuMC1yYzItbmV4dC0yMDE0MDIx
NC0wMzIyNi1nZGE4ZDMwODoxCi9rZXJuZWwvaTM4Ni1yYW5kY29uZmlnLXgxLTAyMTUyMjA4
L2RhOGQzMDhmYmRiODM2MDA3ODc4NmIzZTEyNTIzODEyMmM0ZmM2MTEvZG1lc2cteW9jdG8t
amFrZXRvd24tMTI6MjAxNDAyMTYyMzE0MDU6aTM4Ni1yYW5kY29uZmlnLXgxLTAyMTUyMjA4
OjMuMTQuMC1yYzItbmV4dC0yMDE0MDIxNC0wMzIyNi1nZGE4ZDMwODoxCi9rZXJuZWwvaTM4
Ni1yYW5kY29uZmlnLXgxLTAyMTUyMjA4L2RhOGQzMDhmYmRiODM2MDA3ODc4NmIzZTEyNTIz
ODEyMmM0ZmM2MTEvZG1lc2ctcXVhbnRhbC1zbmItMzoyMDE0MDIxNjIzMTQxMDppMzg2LXJh
bmRjb25maWcteDEtMDIxNTIyMDg6My4xNC4wLXJjMi1uZXh0LTIwMTQwMjE0LTAzMjI2LWdk
YThkMzA4OjEKL2tlcm5lbC9pMzg2LXJhbmRjb25maWcteDEtMDIxNTIyMDgvZGE4ZDMwOGZi
ZGI4MzYwMDc4Nzg2YjNlMTI1MjM4MTIyYzRmYzYxMS9kbWVzZy1xdWFudGFsLWxrcC1zYngw
NC04NjoyMDE0MDIxNTIyMTcwMTppMzg2LXJhbmRjb25maWcteDEtMDIxNTIyMDg6Ogova2Vy
bmVsL2kzODYtcmFuZGNvbmZpZy14MS0wMjE1MjIwOC9kYThkMzA4ZmJkYjgzNjAwNzg3ODZi
M2UxMjUyMzgxMjJjNGZjNjExL2RtZXNnLXF1YW50YWwtbGtwLXNieDA0LTIxOjIwMTQwMjE1
MjIxNzA0OmkzODYtcmFuZGNvbmZpZy14MS0wMjE1MjIwODo6Ci9rZXJuZWwvaTM4Ni1yYW5k
Y29uZmlnLXgxLTAyMTUyMjA4L2RhOGQzMDhmYmRiODM2MDA3ODc4NmIzZTEyNTIzODEyMmM0
ZmM2MTEvZG1lc2ctcXVhbnRhbC1qYWtldG93bi0xMDoyMDE0MDIxNjIzMTM1MTppMzg2LXJh
bmRjb25maWcteDEtMDIxNTIyMDg6My4xNC4wLXJjMi1uZXh0LTIwMTQwMjE0LTAzMjI2LWdk
YThkMzA4OjEKNDoxNDoxNSBhbGxfZ29vZDpiYWQ6YWxsX2JhZCBib290cwoK

--OgqxwSJOaUobr8KG
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="config-3.14.0-rc2-next-20140214-03226-gda8d308"

#
# Automatically generated file; DO NOT EDIT.
# Linux/i386 3.14.0-rc2 Kernel Configuration
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
# CONFIG_SYSVIPC is not set
# CONFIG_POSIX_MQUEUE is not set
CONFIG_FHANDLE=y
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
CONFIG_TREE_RCU=y
# CONFIG_PREEMPT_RCU is not set
CONFIG_RCU_STALL_COMMON=y
CONFIG_RCU_FANOUT=32
CONFIG_RCU_FANOUT_LEAF=16
CONFIG_RCU_FANOUT_EXACT=y
# CONFIG_RCU_FAST_NO_HZ is not set
CONFIG_TREE_RCU_TRACE=y
# CONFIG_RCU_NOCB_CPU is not set
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
CONFIG_CPUSETS=y
CONFIG_PROC_PID_CPUSET=y
# CONFIG_CGROUP_CPUACCT is not set
# CONFIG_RESOURCE_COUNTERS is not set
CONFIG_CGROUP_PERF=y
CONFIG_CGROUP_SCHED=y
CONFIG_FAIR_GROUP_SCHED=y
# CONFIG_CFS_BANDWIDTH is not set
CONFIG_RT_GROUP_SCHED=y
# CONFIG_CHECKPOINT_RESTORE is not set
CONFIG_NAMESPACES=y
CONFIG_UTS_NS=y
# CONFIG_USER_NS is not set
CONFIG_PID_NS=y
CONFIG_NET_NS=y
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
CONFIG_CC_OPTIMIZE_FOR_SIZE=y
CONFIG_SYSCTL=y
CONFIG_ANON_INODES=y
CONFIG_HAVE_UID16=y
CONFIG_SYSCTL_EXCEPTION_TRACE=y
CONFIG_HAVE_PCSPKR_PLATFORM=y
CONFIG_EXPERT=y
# CONFIG_UID16 is not set
CONFIG_SYSCTL_SYSCALL=y
CONFIG_KALLSYMS=y
CONFIG_KALLSYMS_ALL=y
CONFIG_PRINTK=y
CONFIG_BUG=y
# CONFIG_PCSPKR_PLATFORM is not set
# CONFIG_BASE_FULL is not set
CONFIG_FUTEX=y
# CONFIG_EPOLL is not set
CONFIG_SIGNALFD=y
# CONFIG_TIMERFD is not set
CONFIG_EVENTFD=y
# CONFIG_SHMEM is not set
CONFIG_AIO=y
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
CONFIG_BASE_SMALL=1
# CONFIG_MODULES is not set
CONFIG_STOP_MACHINE=y
# CONFIG_BLOCK is not set
CONFIG_UNINLINE_SPIN_UNLOCK=y
CONFIG_FREEZER=y

#
# Processor type and features
#
CONFIG_ZONE_DMA=y
CONFIG_SMP=y
CONFIG_X86_MPPARSE=y
# CONFIG_X86_BIGSMP is not set
# CONFIG_X86_EXTENDED_PLATFORM is not set
# CONFIG_X86_INTEL_LPSS is not set
CONFIG_X86_32_IRIS=y
# CONFIG_SCHED_OMIT_FRAME_POINTER is not set
CONFIG_HYPERVISOR_GUEST=y
CONFIG_PARAVIRT=y
# CONFIG_PARAVIRT_DEBUG is not set
# CONFIG_PARAVIRT_SPINLOCKS is not set
# CONFIG_XEN is not set
# CONFIG_XEN_PRIVILEGED_GUEST is not set
CONFIG_KVM_GUEST=y
# CONFIG_KVM_DEBUG_FS is not set
# CONFIG_LGUEST_GUEST is not set
# CONFIG_PARAVIRT_TIME_ACCOUNTING is not set
CONFIG_PARAVIRT_CLOCK=y
CONFIG_NO_BOOTMEM=y
# CONFIG_MEMTEST is not set
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
CONFIG_HPET_EMULATE_RTC=y
# CONFIG_DMI is not set
CONFIG_NR_CPUS=8
# CONFIG_SCHED_SMT is not set
CONFIG_SCHED_MC=y
# CONFIG_PREEMPT_NONE is not set
CONFIG_PREEMPT_VOLUNTARY=y
# CONFIG_PREEMPT is not set
CONFIG_PREEMPT_COUNT=y
CONFIG_X86_LOCAL_APIC=y
CONFIG_X86_IO_APIC=y
# CONFIG_X86_REROUTE_FOR_BROKEN_BOOT_IRQS is not set
# CONFIG_X86_MCE is not set
# CONFIG_VM86 is not set
CONFIG_TOSHIBA=y
# CONFIG_I8K is not set
# CONFIG_X86_REBOOTFIXUPS is not set
CONFIG_MICROCODE=y
CONFIG_MICROCODE_INTEL=y
CONFIG_MICROCODE_AMD=y
CONFIG_MICROCODE_OLD_INTERFACE=y
CONFIG_MICROCODE_INTEL_EARLY=y
CONFIG_MICROCODE_AMD_EARLY=y
CONFIG_MICROCODE_EARLY=y
CONFIG_X86_MSR=y
# CONFIG_X86_CPUID is not set
# CONFIG_NOHIGHMEM is not set
# CONFIG_HIGHMEM4G is not set
CONFIG_HIGHMEM64G=y
CONFIG_VMSPLIT_3G=y
# CONFIG_VMSPLIT_2G is not set
# CONFIG_VMSPLIT_1G is not set
CONFIG_PAGE_OFFSET=0xC0000000
CONFIG_HIGHMEM=y
CONFIG_X86_PAE=y
CONFIG_ARCH_PHYS_ADDR_T_64BIT=y
CONFIG_ARCH_DMA_ADDR_T_64BIT=y
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
CONFIG_MEMORY_ISOLATION=y
# CONFIG_HAVE_BOOTMEM_INFO_NODE is not set
# CONFIG_MEMORY_HOTPLUG is not set
CONFIG_SPLIT_PTLOCK_CPUS=4
CONFIG_ARCH_ENABLE_SPLIT_PMD_PTLOCK=y
CONFIG_BALLOON_COMPACTION=y
CONFIG_COMPACTION=y
CONFIG_MIGRATION=y
CONFIG_PHYS_ADDR_T_64BIT=y
CONFIG_ZONE_DMA_FLAG=1
CONFIG_VIRT_TO_BUS=y
# CONFIG_KSM is not set
CONFIG_DEFAULT_MMAP_MIN_ADDR=4096
CONFIG_TRANSPARENT_HUGEPAGE=y
# CONFIG_TRANSPARENT_HUGEPAGE_ALWAYS is not set
CONFIG_TRANSPARENT_HUGEPAGE_MADVISE=y
CONFIG_CROSS_MEMORY_ATTACH=y
# CONFIG_CLEANCACHE is not set
CONFIG_CMA=y
# CONFIG_CMA_DEBUG is not set
# CONFIG_ZBUD is not set
CONFIG_ZSMALLOC=y
# CONFIG_PGTABLE_MAPPING is not set
# CONFIG_HIGHPTE is not set
# CONFIG_X86_CHECK_BIOS_CORRUPTION is not set
CONFIG_X86_RESERVE_LOW=64
# CONFIG_MATH_EMULATION is not set
CONFIG_MTRR=y
CONFIG_MTRR_SANITIZER=y
CONFIG_MTRR_SANITIZER_ENABLE_DEFAULT=0
CONFIG_MTRR_SANITIZER_SPARE_REG_NR_DEFAULT=1
CONFIG_X86_PAT=y
CONFIG_ARCH_USES_PG_UNCACHED=y
# CONFIG_ARCH_RANDOM is not set
CONFIG_X86_SMAP=y
# CONFIG_EFI is not set
CONFIG_SECCOMP=y
# CONFIG_HZ_100 is not set
CONFIG_HZ_250=y
# CONFIG_HZ_300 is not set
# CONFIG_HZ_1000 is not set
CONFIG_HZ=250
# CONFIG_SCHED_HRTICK is not set
CONFIG_KEXEC=y
CONFIG_CRASH_DUMP=y
CONFIG_PHYSICAL_START=0x1000000
CONFIG_RELOCATABLE=y
CONFIG_RANDOMIZE_BASE=y
CONFIG_RANDOMIZE_BASE_MAX_OFFSET=0x20000000
CONFIG_X86_NEED_RELOCS=y
CONFIG_PHYSICAL_ALIGN=0x200000
CONFIG_HOTPLUG_CPU=y
CONFIG_BOOTPARAM_HOTPLUG_CPU0=y
CONFIG_DEBUG_HOTPLUG_CPU0=y
# CONFIG_COMPAT_VDSO is not set
# CONFIG_CMDLINE_BOOL is not set
CONFIG_ARCH_ENABLE_MEMORY_HOTPLUG=y

#
# Power management and ACPI options
#
CONFIG_SUSPEND=y
CONFIG_SUSPEND_FREEZER=y
CONFIG_PM_SLEEP=y
CONFIG_PM_SLEEP_SMP=y
CONFIG_PM_AUTOSLEEP=y
CONFIG_PM_WAKELOCKS=y
CONFIG_PM_WAKELOCKS_LIMIT=100
# CONFIG_PM_WAKELOCKS_GC is not set
CONFIG_PM_RUNTIME=y
CONFIG_PM=y
CONFIG_PM_DEBUG=y
CONFIG_PM_ADVANCED_DEBUG=y
CONFIG_PM_TEST_SUSPEND=y
CONFIG_PM_SLEEP_DEBUG=y
# CONFIG_PM_TRACE_RTC is not set
# CONFIG_WQ_POWER_EFFICIENT_DEFAULT is not set
CONFIG_ACPI=y
CONFIG_ACPI_SLEEP=y
# CONFIG_ACPI_PROCFS is not set
# CONFIG_ACPI_EC_DEBUGFS is not set
CONFIG_ACPI_AC=y
CONFIG_ACPI_BATTERY=y
CONFIG_ACPI_BUTTON=y
CONFIG_ACPI_FAN=y
# CONFIG_ACPI_DOCK is not set
CONFIG_ACPI_PROCESSOR=y
CONFIG_ACPI_HOTPLUG_CPU=y
# CONFIG_ACPI_PROCESSOR_AGGREGATOR is not set
CONFIG_ACPI_THERMAL=y
# CONFIG_ACPI_CUSTOM_DSDT is not set
# CONFIG_ACPI_INITRD_TABLE_OVERRIDE is not set
# CONFIG_ACPI_DEBUG is not set
# CONFIG_ACPI_PCI_SLOT is not set
CONFIG_X86_PM_TIMER=y
CONFIG_ACPI_CONTAINER=y
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
# CONFIG_CPU_FREQ_DEFAULT_GOV_PERFORMANCE is not set
# CONFIG_CPU_FREQ_DEFAULT_GOV_POWERSAVE is not set
CONFIG_CPU_FREQ_DEFAULT_GOV_USERSPACE=y
# CONFIG_CPU_FREQ_DEFAULT_GOV_ONDEMAND is not set
# CONFIG_CPU_FREQ_DEFAULT_GOV_CONSERVATIVE is not set
CONFIG_CPU_FREQ_GOV_PERFORMANCE=y
# CONFIG_CPU_FREQ_GOV_POWERSAVE is not set
CONFIG_CPU_FREQ_GOV_USERSPACE=y
CONFIG_CPU_FREQ_GOV_ONDEMAND=y
CONFIG_CPU_FREQ_GOV_CONSERVATIVE=y

#
# x86 CPU frequency scaling drivers
#
CONFIG_X86_INTEL_PSTATE=y
# CONFIG_X86_PCC_CPUFREQ is not set
# CONFIG_X86_ACPI_CPUFREQ is not set
CONFIG_X86_POWERNOW_K6=y
CONFIG_X86_POWERNOW_K7=y
CONFIG_X86_POWERNOW_K7_ACPI=y
# CONFIG_X86_GX_SUSPMOD is not set
# CONFIG_X86_SPEEDSTEP_CENTRINO is not set
# CONFIG_X86_SPEEDSTEP_ICH is not set
CONFIG_X86_SPEEDSTEP_SMI=y
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
# CONFIG_CPU_IDLE_MULTIPLE_DRIVERS is not set
# CONFIG_CPU_IDLE_GOV_LADDER is not set
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
# CONFIG_EISA_VIRTUAL_ROOT is not set
# CONFIG_EISA_NAMES is not set
# CONFIG_SCx200 is not set
# CONFIG_ALIX is not set
CONFIG_NET5501=y
CONFIG_AMD_NB=y
CONFIG_PCCARD=y
# CONFIG_PCMCIA is not set
CONFIG_CARDBUS=y

#
# PC-card bridges
#
# CONFIG_YENTA is not set
CONFIG_PCMCIA_PROBE=y
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
# CONFIG_NET_9P is not set
# CONFIG_CAIF is not set
# CONFIG_NFC is not set

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
# CONFIG_DEBUG_DEVRES is not set
# CONFIG_SYS_HYPERVISOR is not set
# CONFIG_GENERIC_CPU_DEVICES is not set
CONFIG_REGMAP=y
CONFIG_REGMAP_I2C=y
CONFIG_REGMAP_SPI=y
CONFIG_REGMAP_MMIO=y
CONFIG_REGMAP_IRQ=y
CONFIG_DMA_SHARED_BUFFER=y
CONFIG_DMA_CMA=y

#
# Default contiguous memory area size:
#
CONFIG_CMA_SIZE_PERCENTAGE=10
# CONFIG_CMA_SIZE_SEL_MBYTES is not set
CONFIG_CMA_SIZE_SEL_PERCENTAGE=y
# CONFIG_CMA_SIZE_SEL_MIN is not set
# CONFIG_CMA_SIZE_SEL_MAX is not set
CONFIG_CMA_ALIGNMENT=8
CONFIG_CMA_AREAS=7

#
# Bus devices
#
# CONFIG_CONNECTOR is not set
CONFIG_MTD=y
CONFIG_MTD_REDBOOT_PARTS=y
CONFIG_MTD_REDBOOT_DIRECTORY_BLOCK=-1
CONFIG_MTD_REDBOOT_PARTS_UNALLOCATED=y
CONFIG_MTD_REDBOOT_PARTS_READONLY=y
# CONFIG_MTD_CMDLINE_PARTS is not set
# CONFIG_MTD_AR7_PARTS is not set

#
# User Modules And Translation Layers
#
# CONFIG_MTD_OOPS is not set

#
# RAM/ROM/Flash chip drivers
#
CONFIG_MTD_CFI=y
# CONFIG_MTD_JEDECPROBE is not set
CONFIG_MTD_GEN_PROBE=y
CONFIG_MTD_CFI_ADV_OPTIONS=y
CONFIG_MTD_CFI_NOSWAP=y
# CONFIG_MTD_CFI_BE_BYTE_SWAP is not set
# CONFIG_MTD_CFI_LE_BYTE_SWAP is not set
CONFIG_MTD_CFI_GEOMETRY=y
# CONFIG_MTD_MAP_BANK_WIDTH_1 is not set
# CONFIG_MTD_MAP_BANK_WIDTH_2 is not set
# CONFIG_MTD_MAP_BANK_WIDTH_4 is not set
CONFIG_MTD_MAP_BANK_WIDTH_8=y
CONFIG_MTD_MAP_BANK_WIDTH_16=y
CONFIG_MTD_MAP_BANK_WIDTH_32=y
CONFIG_MTD_CFI_I1=y
# CONFIG_MTD_CFI_I2 is not set
CONFIG_MTD_CFI_I4=y
# CONFIG_MTD_CFI_I8 is not set
CONFIG_MTD_OTP=y
CONFIG_MTD_CFI_INTELEXT=y
CONFIG_MTD_CFI_AMDSTD=y
CONFIG_MTD_CFI_STAA=y
CONFIG_MTD_CFI_UTIL=y
CONFIG_MTD_RAM=y
# CONFIG_MTD_ROM is not set
CONFIG_MTD_ABSENT=y

#
# Mapping drivers for chip access
#
# CONFIG_MTD_COMPLEX_MAPPINGS is not set
CONFIG_MTD_PHYSMAP=y
CONFIG_MTD_PHYSMAP_COMPAT=y
CONFIG_MTD_PHYSMAP_START=0x8000000
CONFIG_MTD_PHYSMAP_LEN=0
CONFIG_MTD_PHYSMAP_BANKWIDTH=2
CONFIG_MTD_SC520CDP=y
# CONFIG_MTD_NETSC520 is not set
# CONFIG_MTD_TS5500 is not set
# CONFIG_MTD_INTEL_VR_NOR is not set
CONFIG_MTD_PLATRAM=y

#
# Self-contained MTD device drivers
#
# CONFIG_MTD_PMC551 is not set
CONFIG_MTD_DATAFLASH=y
# CONFIG_MTD_DATAFLASH_WRITE_VERIFY is not set
CONFIG_MTD_DATAFLASH_OTP=y
CONFIG_MTD_M25P80=y
# CONFIG_MTD_SST25L is not set
# CONFIG_MTD_SLRAM is not set
CONFIG_MTD_PHRAM=y
# CONFIG_MTD_MTDRAM is not set

#
# Disk-On-Chip Device Drivers
#
CONFIG_MTD_DOCG3=y
CONFIG_BCH_CONST_M=14
CONFIG_BCH_CONST_T=4
CONFIG_MTD_NAND_ECC=y
CONFIG_MTD_NAND_ECC_SMC=y
CONFIG_MTD_NAND=y
# CONFIG_MTD_NAND_ECC_BCH is not set
# CONFIG_MTD_SM_COMMON is not set
CONFIG_MTD_NAND_DENALI=y
# CONFIG_MTD_NAND_DENALI_PCI is not set
CONFIG_MTD_NAND_GPIO=y
CONFIG_MTD_NAND_IDS=y
# CONFIG_MTD_NAND_RICOH is not set
CONFIG_MTD_NAND_DISKONCHIP=y
CONFIG_MTD_NAND_DISKONCHIP_PROBE_ADVANCED=y
CONFIG_MTD_NAND_DISKONCHIP_PROBE_ADDRESS=0
# CONFIG_MTD_NAND_DISKONCHIP_PROBE_HIGH is not set
CONFIG_MTD_NAND_DISKONCHIP_BBTWRITE=y
CONFIG_MTD_NAND_DOCG4=y
# CONFIG_MTD_NAND_CAFE is not set
CONFIG_MTD_NAND_CS553X=y
CONFIG_MTD_NAND_NANDSIM=y
CONFIG_MTD_NAND_PLATFORM=y
CONFIG_MTD_NAND_SH_FLCTL=y
CONFIG_MTD_ONENAND=y
# CONFIG_MTD_ONENAND_VERIFY_WRITE is not set
CONFIG_MTD_ONENAND_GENERIC=y
# CONFIG_MTD_ONENAND_OTP is not set
CONFIG_MTD_ONENAND_2X_PROGRAM=y

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
CONFIG_PARPORT=y
CONFIG_ARCH_MIGHT_HAVE_PC_PARPORT=y
CONFIG_PARPORT_PC=y
# CONFIG_PARPORT_SERIAL is not set
CONFIG_PARPORT_PC_FIFO=y
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
# CONFIG_ISAPNP is not set
# CONFIG_PNPBIOS is not set
CONFIG_PNPACPI=y

#
# Misc devices
#
CONFIG_SENSORS_LIS3LV02D=y
CONFIG_AD525X_DPOT=y
# CONFIG_AD525X_DPOT_I2C is not set
# CONFIG_AD525X_DPOT_SPI is not set
CONFIG_DUMMY_IRQ=y
# CONFIG_IBM_ASM is not set
# CONFIG_PHANTOM is not set
# CONFIG_INTEL_MID_PTI is not set
# CONFIG_SGI_IOC4 is not set
# CONFIG_TIFM_CORE is not set
CONFIG_ICS932S401=y
CONFIG_ATMEL_SSC=y
CONFIG_ENCLOSURE_SERVICES=y
# CONFIG_HP_ILO is not set
CONFIG_APDS9802ALS=y
CONFIG_ISL29003=y
CONFIG_ISL29020=y
CONFIG_SENSORS_TSL2550=y
CONFIG_SENSORS_BH1780=y
CONFIG_SENSORS_BH1770=y
CONFIG_SENSORS_APDS990X=y
# CONFIG_HMC6352 is not set
CONFIG_DS1682=y
# CONFIG_TI_DAC7512 is not set
# CONFIG_VMWARE_BALLOON is not set
CONFIG_BMP085=y
# CONFIG_BMP085_I2C is not set
CONFIG_BMP085_SPI=y
# CONFIG_PCH_PHUB is not set
# CONFIG_USB_SWITCH_FSA9480 is not set
# CONFIG_LATTICE_ECP3_CONFIG is not set
CONFIG_SRAM=y
CONFIG_C2PORT=y
CONFIG_C2PORT_DURAMAR_2150=y

#
# EEPROM support
#
# CONFIG_EEPROM_AT24 is not set
# CONFIG_EEPROM_AT25 is not set
# CONFIG_EEPROM_LEGACY is not set
CONFIG_EEPROM_MAX6875=y
CONFIG_EEPROM_93CX6=y
# CONFIG_EEPROM_93XX46 is not set
# CONFIG_CB710_CORE is not set

#
# Texas Instruments shared transport line discipline
#
# CONFIG_TI_ST is not set
CONFIG_SENSORS_LIS3_I2C=y

#
# Altera FPGA firmware download module
#
# CONFIG_ALTERA_STAPL is not set
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
# CONFIG_VHOST_NET is not set

#
# Input device support
#
CONFIG_INPUT=y
CONFIG_INPUT_FF_MEMLESS=y
CONFIG_INPUT_POLLDEV=y
CONFIG_INPUT_SPARSEKMAP=y
# CONFIG_INPUT_MATRIXKMAP is not set

#
# Userland interfaces
#
CONFIG_INPUT_MOUSEDEV=y
CONFIG_INPUT_MOUSEDEV_PSAUX=y
CONFIG_INPUT_MOUSEDEV_SCREEN_X=1024
CONFIG_INPUT_MOUSEDEV_SCREEN_Y=768
# CONFIG_INPUT_JOYDEV is not set
CONFIG_INPUT_EVDEV=y
CONFIG_INPUT_EVBUG=y

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
# CONFIG_KEYBOARD_LM8323 is not set
# CONFIG_KEYBOARD_LM8333 is not set
# CONFIG_KEYBOARD_MAX7359 is not set
# CONFIG_KEYBOARD_MCS is not set
# CONFIG_KEYBOARD_MPR121 is not set
# CONFIG_KEYBOARD_NEWTON is not set
# CONFIG_KEYBOARD_OPENCORES is not set
# CONFIG_KEYBOARD_STOWAWAY is not set
# CONFIG_KEYBOARD_SUNKBD is not set
# CONFIG_KEYBOARD_SH_KEYSC is not set
# CONFIG_KEYBOARD_XTKBD is not set
CONFIG_INPUT_LEDS=y
# CONFIG_INPUT_MOUSE is not set
CONFIG_INPUT_JOYSTICK=y
# CONFIG_JOYSTICK_ANALOG is not set
CONFIG_JOYSTICK_A3D=y
CONFIG_JOYSTICK_ADI=y
# CONFIG_JOYSTICK_COBRA is not set
CONFIG_JOYSTICK_GF2K=y
# CONFIG_JOYSTICK_GRIP is not set
CONFIG_JOYSTICK_GRIP_MP=y
# CONFIG_JOYSTICK_GUILLEMOT is not set
CONFIG_JOYSTICK_INTERACT=y
CONFIG_JOYSTICK_SIDEWINDER=y
CONFIG_JOYSTICK_TMDC=y
# CONFIG_JOYSTICK_IFORCE is not set
CONFIG_JOYSTICK_WARRIOR=y
# CONFIG_JOYSTICK_MAGELLAN is not set
CONFIG_JOYSTICK_SPACEORB=y
CONFIG_JOYSTICK_SPACEBALL=y
CONFIG_JOYSTICK_STINGER=y
# CONFIG_JOYSTICK_TWIDJOY is not set
CONFIG_JOYSTICK_ZHENHUA=y
CONFIG_JOYSTICK_DB9=y
CONFIG_JOYSTICK_GAMECON=y
CONFIG_JOYSTICK_TURBOGRAFX=y
CONFIG_JOYSTICK_AS5011=y
CONFIG_JOYSTICK_JOYDUMP=y
# CONFIG_JOYSTICK_XPAD is not set
CONFIG_INPUT_TABLET=y
# CONFIG_TABLET_USB_ACECAD is not set
# CONFIG_TABLET_USB_AIPTEK is not set
# CONFIG_TABLET_USB_HANWANG is not set
# CONFIG_TABLET_USB_KBTAB is not set
# CONFIG_TABLET_USB_WACOM is not set
CONFIG_INPUT_TOUCHSCREEN=y
CONFIG_TOUCHSCREEN_88PM860X=y
# CONFIG_TOUCHSCREEN_ADS7846 is not set
CONFIG_TOUCHSCREEN_AD7877=y
CONFIG_TOUCHSCREEN_AD7879=y
# CONFIG_TOUCHSCREEN_AD7879_I2C is not set
CONFIG_TOUCHSCREEN_AD7879_SPI=y
CONFIG_TOUCHSCREEN_ATMEL_MXT=y
CONFIG_TOUCHSCREEN_AUO_PIXCIR=y
# CONFIG_TOUCHSCREEN_BU21013 is not set
# CONFIG_TOUCHSCREEN_CY8CTMG110 is not set
CONFIG_TOUCHSCREEN_CYTTSP_CORE=y
CONFIG_TOUCHSCREEN_CYTTSP_I2C=y
CONFIG_TOUCHSCREEN_CYTTSP_SPI=y
CONFIG_TOUCHSCREEN_CYTTSP4_CORE=y
CONFIG_TOUCHSCREEN_CYTTSP4_I2C=y
CONFIG_TOUCHSCREEN_CYTTSP4_SPI=y
# CONFIG_TOUCHSCREEN_DA9034 is not set
# CONFIG_TOUCHSCREEN_DA9052 is not set
# CONFIG_TOUCHSCREEN_DYNAPRO is not set
# CONFIG_TOUCHSCREEN_HAMPSHIRE is not set
CONFIG_TOUCHSCREEN_EETI=y
CONFIG_TOUCHSCREEN_FUJITSU=y
CONFIG_TOUCHSCREEN_ILI210X=y
CONFIG_TOUCHSCREEN_GUNZE=y
# CONFIG_TOUCHSCREEN_ELO is not set
CONFIG_TOUCHSCREEN_WACOM_W8001=y
# CONFIG_TOUCHSCREEN_WACOM_I2C is not set
# CONFIG_TOUCHSCREEN_MAX11801 is not set
CONFIG_TOUCHSCREEN_MCS5000=y
# CONFIG_TOUCHSCREEN_MMS114 is not set
CONFIG_TOUCHSCREEN_MTOUCH=y
CONFIG_TOUCHSCREEN_INEXIO=y
CONFIG_TOUCHSCREEN_MK712=y
# CONFIG_TOUCHSCREEN_HTCPEN is not set
# CONFIG_TOUCHSCREEN_PENMOUNT is not set
CONFIG_TOUCHSCREEN_EDT_FT5X06=y
# CONFIG_TOUCHSCREEN_TOUCHRIGHT is not set
CONFIG_TOUCHSCREEN_TOUCHWIN=y
# CONFIG_TOUCHSCREEN_PIXCIR is not set
# CONFIG_TOUCHSCREEN_WM831X is not set
# CONFIG_TOUCHSCREEN_USB_COMPOSITE is not set
CONFIG_TOUCHSCREEN_MC13783=y
# CONFIG_TOUCHSCREEN_TOUCHIT213 is not set
# CONFIG_TOUCHSCREEN_TSC_SERIO is not set
CONFIG_TOUCHSCREEN_TSC2005=y
CONFIG_TOUCHSCREEN_TSC2007=y
CONFIG_TOUCHSCREEN_PCAP=y
CONFIG_TOUCHSCREEN_ST1232=y
# CONFIG_TOUCHSCREEN_TPS6507X is not set
CONFIG_TOUCHSCREEN_ZFORCE=y
CONFIG_INPUT_MISC=y
# CONFIG_INPUT_88PM860X_ONKEY is not set
CONFIG_INPUT_88PM80X_ONKEY=y
CONFIG_INPUT_AD714X=y
# CONFIG_INPUT_AD714X_I2C is not set
CONFIG_INPUT_AD714X_SPI=y
CONFIG_INPUT_BMA150=y
CONFIG_INPUT_MC13783_PWRBUTTON=y
CONFIG_INPUT_MMA8450=y
CONFIG_INPUT_MPU3050=y
CONFIG_INPUT_APANEL=y
CONFIG_INPUT_GP2A=y
CONFIG_INPUT_GPIO_TILT_POLLED=y
# CONFIG_INPUT_WISTRON_BTNS is not set
# CONFIG_INPUT_ATLAS_BTNS is not set
# CONFIG_INPUT_ATI_REMOTE2 is not set
# CONFIG_INPUT_KEYSPAN_REMOTE is not set
CONFIG_INPUT_KXTJ9=y
# CONFIG_INPUT_KXTJ9_POLLED_MODE is not set
# CONFIG_INPUT_POWERMATE is not set
# CONFIG_INPUT_YEALINK is not set
# CONFIG_INPUT_CM109 is not set
CONFIG_INPUT_RETU_PWRBUTTON=y
CONFIG_INPUT_UINPUT=y
CONFIG_INPUT_PCF8574=y
CONFIG_INPUT_GPIO_ROTARY_ENCODER=y
# CONFIG_INPUT_DA9052_ONKEY is not set
# CONFIG_INPUT_WM831X_ON is not set
# CONFIG_INPUT_PCAP is not set
# CONFIG_INPUT_ADXL34X is not set
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
# CONFIG_SERIO_PARKBD is not set
# CONFIG_SERIO_PCIPS2 is not set
CONFIG_SERIO_LIBPS2=y
CONFIG_SERIO_RAW=y
CONFIG_SERIO_ALTERA_PS2=y
# CONFIG_SERIO_PS2MULT is not set
# CONFIG_SERIO_ARC_PS2 is not set
CONFIG_GAMEPORT=y
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
# CONFIG_DEVKMEM is not set

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
# CONFIG_SERIAL_8250_DW is not set

#
# Non-8250 serial port support
#
# CONFIG_SERIAL_CLPS711X is not set
# CONFIG_SERIAL_MAX3100 is not set
# CONFIG_SERIAL_MAX310X is not set
# CONFIG_SERIAL_MFD_HSU is not set
# CONFIG_SERIAL_SH_SCI is not set
CONFIG_SERIAL_CORE=y
CONFIG_SERIAL_CORE_CONSOLE=y
# CONFIG_SERIAL_JSM is not set
# CONFIG_SERIAL_SCCNXP is not set
# CONFIG_SERIAL_TIMBERDALE is not set
# CONFIG_SERIAL_ALTERA_JTAGUART is not set
# CONFIG_SERIAL_ALTERA_UART is not set
# CONFIG_SERIAL_IFX6X60 is not set
# CONFIG_SERIAL_PCH_UART is not set
# CONFIG_SERIAL_ARC is not set
# CONFIG_SERIAL_RP2 is not set
# CONFIG_SERIAL_FSL_LPUART is not set
# CONFIG_SERIAL_ST_ASC is not set
# CONFIG_TTY_PRINTK is not set
CONFIG_PRINTER=y
CONFIG_LP_CONSOLE=y
# CONFIG_PPDEV is not set
# CONFIG_VIRTIO_CONSOLE is not set
CONFIG_IPMI_HANDLER=y
# CONFIG_IPMI_PANIC_EVENT is not set
# CONFIG_IPMI_DEVICE_INTERFACE is not set
# CONFIG_IPMI_SI is not set
CONFIG_IPMI_WATCHDOG=y
# CONFIG_IPMI_POWEROFF is not set
# CONFIG_HW_RANDOM is not set
CONFIG_NVRAM=y
CONFIG_DTLK=y
# CONFIG_R3964 is not set
# CONFIG_APPLICOM is not set
# CONFIG_SONYPI is not set
# CONFIG_MWAVE is not set
CONFIG_PC8736x_GPIO=y
CONFIG_NSC_GPIO=y
# CONFIG_HPET is not set
CONFIG_HANGCHECK_TIMER=y
# CONFIG_TCG_TPM is not set
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
CONFIG_I2C_DESIGNWARE_CORE=y
CONFIG_I2C_DESIGNWARE_PLATFORM=y
# CONFIG_I2C_DESIGNWARE_PCI is not set
# CONFIG_I2C_EG20T is not set
CONFIG_I2C_GPIO=y
CONFIG_I2C_OCORES=y
CONFIG_I2C_PCA_PLATFORM=y
# CONFIG_I2C_PXA_PCI is not set
CONFIG_I2C_RIIC=y
CONFIG_I2C_SH_MOBILE=y
# CONFIG_I2C_SIMTEC is not set
CONFIG_I2C_XILINX=y
CONFIG_I2C_RCAR=y

#
# External I2C/SMBus adapter drivers
#
CONFIG_I2C_PARPORT=y
# CONFIG_I2C_PARPORT_LIGHT is not set
# CONFIG_I2C_TAOS_EVM is not set

#
# Other I2C/SMBus bus drivers
#
CONFIG_I2C_PCA_ISA=y
# CONFIG_SCx200_ACB is not set
# CONFIG_I2C_DEBUG_CORE is not set
# CONFIG_I2C_DEBUG_ALGO is not set
# CONFIG_I2C_DEBUG_BUS is not set
CONFIG_SPI=y
# CONFIG_SPI_DEBUG is not set
CONFIG_SPI_MASTER=y

#
# SPI Master Controller Drivers
#
# CONFIG_SPI_ALTERA is not set
CONFIG_SPI_ATMEL=y
# CONFIG_SPI_BCM2835 is not set
CONFIG_SPI_BCM63XX_HSSPI=y
CONFIG_SPI_BITBANG=y
# CONFIG_SPI_BUTTERFLY is not set
# CONFIG_SPI_EP93XX is not set
CONFIG_SPI_GPIO=y
CONFIG_SPI_IMX=y
CONFIG_SPI_LM70_LLP=y
CONFIG_SPI_FSL_DSPI=y
CONFIG_SPI_OC_TINY=y
CONFIG_SPI_TI_QSPI=y
CONFIG_SPI_OMAP_100K=y
CONFIG_SPI_ORION=y
# CONFIG_SPI_PXA2XX is not set
# CONFIG_SPI_PXA2XX_PCI is not set
CONFIG_SPI_SC18IS602=y
CONFIG_SPI_SH=y
CONFIG_SPI_SH_HSPI=y
CONFIG_SPI_SUN6I=y
CONFIG_SPI_TEGRA114=y
CONFIG_SPI_TEGRA20_SFLASH=y
CONFIG_SPI_TEGRA20_SLINK=y
# CONFIG_SPI_TOPCLIFF_PCH is not set
CONFIG_SPI_TXX9=y
# CONFIG_SPI_XCOMM is not set
# CONFIG_SPI_XILINX is not set
CONFIG_SPI_DESIGNWARE=y
# CONFIG_SPI_DW_PCI is not set
CONFIG_SPI_DW_MMIO=y

#
# SPI Protocol Masters
#
# CONFIG_SPI_SPIDEV is not set
CONFIG_SPI_TLE62X0=y
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

#
# PPS clients support
#
CONFIG_PPS_CLIENT_KTIMER=y
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
# CONFIG_DEBUG_GPIO is not set
CONFIG_GPIO_SYSFS=y
CONFIG_GPIO_GENERIC=y
# CONFIG_GPIO_DA9052 is not set
CONFIG_GPIO_MAX730X=y

#
# Memory mapped GPIO drivers:
#
CONFIG_GPIO_CLPS711X=y
CONFIG_GPIO_GENERIC_PLATFORM=y
CONFIG_GPIO_IT8761E=y
# CONFIG_GPIO_F7188X is not set
# CONFIG_GPIO_SCH311X is not set
CONFIG_GPIO_TS5500=y
# CONFIG_GPIO_SCH is not set
# CONFIG_GPIO_ICH is not set
# CONFIG_GPIO_VX855 is not set
# CONFIG_GPIO_LYNXPOINT is not set

#
# I2C GPIO expanders:
#
CONFIG_GPIO_ARIZONA=y
CONFIG_GPIO_LP3943=y
CONFIG_GPIO_MAX7300=y
CONFIG_GPIO_MAX732X=y
CONFIG_GPIO_MAX732X_IRQ=y
# CONFIG_GPIO_PCA953X is not set
# CONFIG_GPIO_PCF857X is not set
# CONFIG_GPIO_RC5T583 is not set
CONFIG_GPIO_SX150X=y
CONFIG_GPIO_TPS65912=y
CONFIG_GPIO_WM831X=y
# CONFIG_GPIO_WM8350 is not set
# CONFIG_GPIO_ADP5520 is not set
CONFIG_GPIO_ADP5588=y
# CONFIG_GPIO_ADP5588_IRQ is not set

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
# CONFIG_GPIO_MAX7301 is not set
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
# CONFIG_GPIO_TPS6586X is not set

#
# USB GPIO expanders:
#
CONFIG_W1=y

#
# 1-wire Bus Masters
#
# CONFIG_W1_MASTER_MATROX is not set
CONFIG_W1_MASTER_DS2482=y
CONFIG_W1_MASTER_DS1WM=y
# CONFIG_W1_MASTER_GPIO is not set

#
# 1-wire Slaves
#
# CONFIG_W1_SLAVE_THERM is not set
CONFIG_W1_SLAVE_SMEM=y
# CONFIG_W1_SLAVE_DS2408 is not set
# CONFIG_W1_SLAVE_DS2413 is not set
CONFIG_W1_SLAVE_DS2423=y
# CONFIG_W1_SLAVE_DS2431 is not set
# CONFIG_W1_SLAVE_DS2433 is not set
CONFIG_W1_SLAVE_DS2760=y
CONFIG_W1_SLAVE_DS2780=y
CONFIG_W1_SLAVE_DS2781=y
CONFIG_W1_SLAVE_DS28E04=y
# CONFIG_W1_SLAVE_BQ27000 is not set
CONFIG_POWER_SUPPLY=y
CONFIG_POWER_SUPPLY_DEBUG=y
# CONFIG_PDA_POWER is not set
CONFIG_WM831X_BACKUP=y
CONFIG_WM831X_POWER=y
CONFIG_WM8350_POWER=y
CONFIG_TEST_POWER=y
# CONFIG_BATTERY_88PM860X is not set
CONFIG_BATTERY_DS2760=y
# CONFIG_BATTERY_DS2780 is not set
CONFIG_BATTERY_DS2781=y
CONFIG_BATTERY_DS2782=y
CONFIG_BATTERY_SBS=y
CONFIG_BATTERY_BQ27x00=y
# CONFIG_BATTERY_BQ27X00_I2C is not set
# CONFIG_BATTERY_BQ27X00_PLATFORM is not set
CONFIG_BATTERY_DA9030=y
CONFIG_BATTERY_DA9052=y
CONFIG_BATTERY_MAX17040=y
CONFIG_BATTERY_MAX17042=y
# CONFIG_CHARGER_MAX8903 is not set
# CONFIG_CHARGER_LP8727 is not set
CONFIG_CHARGER_GPIO=y
# CONFIG_CHARGER_BQ2415X is not set
# CONFIG_CHARGER_BQ24190 is not set
CONFIG_CHARGER_BQ24735=y
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
# CONFIG_SENSORS_AD7314 is not set
# CONFIG_SENSORS_AD7414 is not set
CONFIG_SENSORS_AD7418=y
# CONFIG_SENSORS_ADCXX is not set
# CONFIG_SENSORS_ADM1021 is not set
CONFIG_SENSORS_ADM1025=y
CONFIG_SENSORS_ADM1026=y
# CONFIG_SENSORS_ADM1029 is not set
CONFIG_SENSORS_ADM1031=y
CONFIG_SENSORS_ADM9240=y
CONFIG_SENSORS_ADT7X10=y
CONFIG_SENSORS_ADT7310=y
# CONFIG_SENSORS_ADT7410 is not set
CONFIG_SENSORS_ADT7411=y
CONFIG_SENSORS_ADT7462=y
CONFIG_SENSORS_ADT7470=y
# CONFIG_SENSORS_ADT7475 is not set
# CONFIG_SENSORS_ASC7621 is not set
# CONFIG_SENSORS_K8TEMP is not set
# CONFIG_SENSORS_K10TEMP is not set
# CONFIG_SENSORS_FAM15H_POWER is not set
CONFIG_SENSORS_ASB100=y
CONFIG_SENSORS_ATXP1=y
CONFIG_SENSORS_DS620=y
# CONFIG_SENSORS_DS1621 is not set
CONFIG_SENSORS_DA9052_ADC=y
# CONFIG_SENSORS_I5K_AMB is not set
CONFIG_SENSORS_F71805F=y
CONFIG_SENSORS_F71882FG=y
CONFIG_SENSORS_F75375S=y
CONFIG_SENSORS_FSCHMD=y
# CONFIG_SENSORS_G760A is not set
# CONFIG_SENSORS_G762 is not set
# CONFIG_SENSORS_GL518SM is not set
CONFIG_SENSORS_GL520SM=y
# CONFIG_SENSORS_GPIO_FAN is not set
CONFIG_SENSORS_HIH6130=y
CONFIG_SENSORS_HTU21=y
# CONFIG_SENSORS_CORETEMP is not set
# CONFIG_SENSORS_IBMAEM is not set
# CONFIG_SENSORS_IBMPEX is not set
# CONFIG_SENSORS_IT87 is not set
# CONFIG_SENSORS_JC42 is not set
CONFIG_SENSORS_LINEAGE=y
CONFIG_SENSORS_LM63=y
# CONFIG_SENSORS_LM70 is not set
CONFIG_SENSORS_LM73=y
CONFIG_SENSORS_LM75=y
CONFIG_SENSORS_LM77=y
CONFIG_SENSORS_LM78=y
# CONFIG_SENSORS_LM80 is not set
CONFIG_SENSORS_LM83=y
# CONFIG_SENSORS_LM85 is not set
CONFIG_SENSORS_LM87=y
CONFIG_SENSORS_LM90=y
CONFIG_SENSORS_LM92=y
CONFIG_SENSORS_LM93=y
CONFIG_SENSORS_LTC2945=y
CONFIG_SENSORS_LTC4151=y
CONFIG_SENSORS_LTC4215=y
CONFIG_SENSORS_LTC4222=y
# CONFIG_SENSORS_LTC4245 is not set
# CONFIG_SENSORS_LTC4260 is not set
# CONFIG_SENSORS_LTC4261 is not set
CONFIG_SENSORS_LM95234=y
CONFIG_SENSORS_LM95241=y
# CONFIG_SENSORS_LM95245 is not set
CONFIG_SENSORS_MAX1111=y
# CONFIG_SENSORS_MAX16065 is not set
CONFIG_SENSORS_MAX1619=y
CONFIG_SENSORS_MAX1668=y
CONFIG_SENSORS_MAX197=y
CONFIG_SENSORS_MAX6639=y
CONFIG_SENSORS_MAX6642=y
CONFIG_SENSORS_MAX6650=y
CONFIG_SENSORS_MAX6697=y
# CONFIG_SENSORS_MCP3021 is not set
CONFIG_SENSORS_NCT6775=y
# CONFIG_SENSORS_NTC_THERMISTOR is not set
CONFIG_SENSORS_PC87360=y
CONFIG_SENSORS_PC87427=y
# CONFIG_SENSORS_PCF8591 is not set
# CONFIG_PMBUS is not set
CONFIG_SENSORS_SHT15=y
CONFIG_SENSORS_SHT21=y
# CONFIG_SENSORS_SIS5595 is not set
CONFIG_SENSORS_SMM665=y
CONFIG_SENSORS_DME1737=y
# CONFIG_SENSORS_EMC1403 is not set
CONFIG_SENSORS_EMC2103=y
# CONFIG_SENSORS_EMC6W201 is not set
CONFIG_SENSORS_SMSC47M1=y
CONFIG_SENSORS_SMSC47M192=y
CONFIG_SENSORS_SMSC47B397=y
# CONFIG_SENSORS_SCH56XX_COMMON is not set
CONFIG_SENSORS_ADS1015=y
CONFIG_SENSORS_ADS7828=y
CONFIG_SENSORS_ADS7871=y
CONFIG_SENSORS_AMC6821=y
# CONFIG_SENSORS_INA209 is not set
CONFIG_SENSORS_INA2XX=y
CONFIG_SENSORS_THMC50=y
CONFIG_SENSORS_TMP102=y
CONFIG_SENSORS_TMP401=y
# CONFIG_SENSORS_TMP421 is not set
# CONFIG_SENSORS_VIA_CPUTEMP is not set
# CONFIG_SENSORS_VIA686A is not set
CONFIG_SENSORS_VT1211=y
# CONFIG_SENSORS_VT8231 is not set
CONFIG_SENSORS_W83781D=y
CONFIG_SENSORS_W83791D=y
CONFIG_SENSORS_W83792D=y
CONFIG_SENSORS_W83793=y
CONFIG_SENSORS_W83795=y
CONFIG_SENSORS_W83795_FANCTRL=y
CONFIG_SENSORS_W83L785TS=y
CONFIG_SENSORS_W83L786NG=y
# CONFIG_SENSORS_W83627HF is not set
CONFIG_SENSORS_W83627EHF=y
CONFIG_SENSORS_WM831X=y
# CONFIG_SENSORS_WM8350 is not set
CONFIG_SENSORS_APPLESMC=y
CONFIG_SENSORS_MC13783_ADC=y

#
# ACPI drivers
#
# CONFIG_SENSORS_ACPI_POWER is not set
# CONFIG_SENSORS_ATK0110 is not set
CONFIG_THERMAL=y
CONFIG_THERMAL_HWMON=y
# CONFIG_THERMAL_DEFAULT_GOV_STEP_WISE is not set
CONFIG_THERMAL_DEFAULT_GOV_FAIR_SHARE=y
# CONFIG_THERMAL_DEFAULT_GOV_USER_SPACE is not set
CONFIG_THERMAL_GOV_FAIR_SHARE=y
# CONFIG_THERMAL_GOV_STEP_WISE is not set
CONFIG_THERMAL_GOV_USER_SPACE=y
# CONFIG_THERMAL_EMULATION is not set
# CONFIG_RCAR_THERMAL is not set
CONFIG_INTEL_POWERCLAMP=y
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
# CONFIG_BCMA_DRIVER_GPIO is not set
# CONFIG_BCMA_DEBUG is not set

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
# CONFIG_MFD_DA9052_SPI is not set
CONFIG_MFD_DA9052_I2C=y
# CONFIG_MFD_DA9055 is not set
# CONFIG_MFD_DA9063 is not set
CONFIG_MFD_MC13XXX=y
# CONFIG_MFD_MC13XXX_SPI is not set
CONFIG_MFD_MC13XXX_I2C=y
# CONFIG_HTC_PASIC3 is not set
# CONFIG_HTC_I2CPLD is not set
# CONFIG_LPC_ICH is not set
# CONFIG_LPC_SCH is not set
# CONFIG_MFD_JANZ_CMODIO is not set
# CONFIG_MFD_KEMPLD is not set
CONFIG_MFD_88PM800=y
# CONFIG_MFD_88PM805 is not set
CONFIG_MFD_88PM860X=y
# CONFIG_MFD_MAX14577 is not set
CONFIG_MFD_MAX77686=y
CONFIG_MFD_MAX77693=y
CONFIG_MFD_MAX8907=y
# CONFIG_MFD_MAX8925 is not set
CONFIG_MFD_MAX8997=y
CONFIG_MFD_MAX8998=y
CONFIG_EZX_PCAP=y
CONFIG_MFD_RETU=y
# CONFIG_MFD_PCF50633 is not set
# CONFIG_MFD_RDC321X is not set
# CONFIG_MFD_RTSX_PCI is not set
CONFIG_MFD_RC5T583=y
CONFIG_MFD_SEC_CORE=y
# CONFIG_MFD_SI476X_CORE is not set
# CONFIG_MFD_SM501 is not set
# CONFIG_MFD_SMSC is not set
CONFIG_ABX500_CORE=y
# CONFIG_AB3100_CORE is not set
# CONFIG_MFD_STMPE is not set
CONFIG_MFD_SYSCON=y
# CONFIG_MFD_TI_AM335X_TSCADC is not set
CONFIG_MFD_LP3943=y
# CONFIG_MFD_LP8788 is not set
# CONFIG_MFD_PALMAS is not set
# CONFIG_TPS6105X is not set
# CONFIG_TPS65010 is not set
CONFIG_TPS6507X=y
CONFIG_MFD_TPS65090=y
CONFIG_MFD_TPS65217=y
CONFIG_MFD_TPS6586X=y
# CONFIG_MFD_TPS65910 is not set
CONFIG_MFD_TPS65912=y
CONFIG_MFD_TPS65912_I2C=y
CONFIG_MFD_TPS65912_SPI=y
CONFIG_MFD_TPS80031=y
# CONFIG_TWL4030_CORE is not set
# CONFIG_TWL6040_CORE is not set
CONFIG_MFD_WL1273_CORE=y
CONFIG_MFD_LM3533=y
# CONFIG_MFD_TIMBERDALE is not set
# CONFIG_MFD_TC3589X is not set
# CONFIG_MFD_TMIO is not set
# CONFIG_MFD_VX855 is not set
CONFIG_MFD_ARIZONA=y
# CONFIG_MFD_ARIZONA_I2C is not set
CONFIG_MFD_ARIZONA_SPI=y
# CONFIG_MFD_WM5102 is not set
CONFIG_MFD_WM5110=y
# CONFIG_MFD_WM8997 is not set
# CONFIG_MFD_WM8400 is not set
CONFIG_MFD_WM831X=y
# CONFIG_MFD_WM831X_I2C is not set
CONFIG_MFD_WM831X_SPI=y
CONFIG_MFD_WM8350=y
CONFIG_MFD_WM8350_I2C=y
# CONFIG_MFD_WM8994 is not set
# CONFIG_REGULATOR is not set
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
CONFIG_VIDEO_OUTPUT_CONTROL=y
CONFIG_HDMI=y
# CONFIG_FB is not set
CONFIG_EXYNOS_VIDEO=y
# CONFIG_BACKLIGHT_LCD_SUPPORT is not set
CONFIG_SOUND=y
CONFIG_SOUND_OSS_CORE=y
CONFIG_SOUND_OSS_CORE_PRECLAIM=y
CONFIG_SND=y
CONFIG_SND_TIMER=y
CONFIG_SND_PCM=y
CONFIG_SND_HWDEP=y
CONFIG_SND_RAWMIDI=y
CONFIG_SND_SEQUENCER=y
CONFIG_SND_SEQ_DUMMY=y
CONFIG_SND_OSSEMUL=y
CONFIG_SND_MIXER_OSS=y
CONFIG_SND_PCM_OSS=y
CONFIG_SND_PCM_OSS_PLUGINS=y
# CONFIG_SND_SEQUENCER_OSS is not set
CONFIG_SND_DYNAMIC_MINORS=y
CONFIG_SND_MAX_CARDS=32
# CONFIG_SND_SUPPORT_OLD_API is not set
# CONFIG_SND_VERBOSE_PROCFS is not set
CONFIG_SND_VERBOSE_PRINTK=y
# CONFIG_SND_DEBUG is not set
CONFIG_SND_DMA_SGBUF=y
CONFIG_SND_RAWMIDI_SEQ=y
CONFIG_SND_OPL3_LIB_SEQ=y
CONFIG_SND_OPL4_LIB_SEQ=y
CONFIG_SND_SBAWE_SEQ=y
# CONFIG_SND_EMU10K1_SEQ is not set
CONFIG_SND_MPU401_UART=y
CONFIG_SND_OPL3_LIB=y
CONFIG_SND_OPL4_LIB=y
# CONFIG_SND_DRIVERS is not set
CONFIG_SND_WSS_LIB=y
CONFIG_SND_SB_COMMON=y
CONFIG_SND_SB8_DSP=y
CONFIG_SND_SB16_DSP=y
CONFIG_SND_ISA=y
# CONFIG_SND_ADLIB is not set
# CONFIG_SND_AD1816A is not set
CONFIG_SND_AD1848=y
# CONFIG_SND_ALS100 is not set
CONFIG_SND_AZT1605=y
CONFIG_SND_AZT2316=y
# CONFIG_SND_AZT2320 is not set
CONFIG_SND_CMI8328=y
# CONFIG_SND_CMI8330 is not set
# CONFIG_SND_CS4231 is not set
CONFIG_SND_CS4236=y
# CONFIG_SND_ES1688 is not set
CONFIG_SND_ES18XX=y
CONFIG_SND_SC6000=y
CONFIG_SND_GUSCLASSIC=y
CONFIG_SND_GUSEXTREME=y
# CONFIG_SND_GUSMAX is not set
# CONFIG_SND_INTERWAVE is not set
# CONFIG_SND_INTERWAVE_STB is not set
CONFIG_SND_JAZZ16=y
CONFIG_SND_OPL3SA2=y
CONFIG_SND_OPTI92X_AD1848=y
CONFIG_SND_OPTI92X_CS4231=y
CONFIG_SND_OPTI93X=y
CONFIG_SND_MIRO=y
# CONFIG_SND_SB8 is not set
CONFIG_SND_SB16=y
CONFIG_SND_SBAWE=y
# CONFIG_SND_SB16_CSP is not set
CONFIG_SND_SSCAPE=y
CONFIG_SND_WAVEFRONT=y
CONFIG_SND_MSND_PINNACLE=y
# CONFIG_SND_MSND_CLASSIC is not set
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
# CONFIG_SND_SIS7019 is not set
# CONFIG_SND_SONICVIBES is not set
# CONFIG_SND_TRIDENT is not set
# CONFIG_SND_VIA82XX is not set
# CONFIG_SND_VIA82XX_MODEM is not set
# CONFIG_SND_VIRTUOSO is not set
# CONFIG_SND_VX222 is not set
# CONFIG_SND_YMFPCI is not set
CONFIG_SND_SPI=y
# CONFIG_SND_AT73C213 is not set
# CONFIG_SND_SOC is not set
# CONFIG_SOUND_PRIME is not set

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
CONFIG_HID_ACRUX=y
CONFIG_HID_ACRUX_FF=y
CONFIG_HID_APPLE=y
# CONFIG_HID_AUREAL is not set
# CONFIG_HID_BELKIN is not set
CONFIG_HID_CHERRY=y
CONFIG_HID_CHICONY=y
# CONFIG_HID_PRODIKEYS is not set
CONFIG_HID_CYPRESS=y
# CONFIG_HID_DRAGONRISE is not set
# CONFIG_HID_EMS_FF is not set
CONFIG_HID_ELECOM=y
CONFIG_HID_EZKEY=y
CONFIG_HID_KEYTOUCH=y
CONFIG_HID_KYE=y
CONFIG_HID_UCLOGIC=y
CONFIG_HID_WALTOP=y
CONFIG_HID_GYRATION=y
CONFIG_HID_ICADE=y
# CONFIG_HID_TWINHAN is not set
# CONFIG_HID_KENSINGTON is not set
CONFIG_HID_LCPOWER=y
# CONFIG_HID_LENOVO_TPKBD is not set
# CONFIG_HID_LOGITECH is not set
# CONFIG_HID_MAGICMOUSE is not set
# CONFIG_HID_MICROSOFT is not set
CONFIG_HID_MONTEREY=y
# CONFIG_HID_MULTITOUCH is not set
CONFIG_HID_ORTEK=y
# CONFIG_HID_PANTHERLORD is not set
CONFIG_HID_PETALYNX=y
CONFIG_HID_PICOLCD=y
CONFIG_HID_PICOLCD_LEDS=y
CONFIG_HID_PRIMAX=y
CONFIG_HID_SAITEK=y
CONFIG_HID_SAMSUNG=y
CONFIG_HID_SPEEDLINK=y
CONFIG_HID_STEELSERIES=y
CONFIG_HID_SUNPLUS=y
CONFIG_HID_GREENASIA=y
# CONFIG_GREENASIA_FF is not set
CONFIG_HID_SMARTJOYPLUS=y
# CONFIG_SMARTJOYPLUS_FF is not set
CONFIG_HID_TIVO=y
CONFIG_HID_TOPSEED=y
# CONFIG_HID_THINGM is not set
# CONFIG_HID_THRUSTMASTER is not set
# CONFIG_HID_WACOM is not set
CONFIG_HID_WIIMOTE=y
CONFIG_HID_XINMO=y
CONFIG_HID_ZEROPLUS=y
CONFIG_ZEROPLUS_FF=y
CONFIG_HID_ZYDACRON=y
# CONFIG_HID_SENSOR_HUB is not set

#
# I2C HID support
#
CONFIG_I2C_HID=y
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
# CONFIG_KEYSTONE_USB_PHY is not set
# CONFIG_NOP_USB_XCEIV is not set
# CONFIG_OMAP_CONTROL_USB is not set
# CONFIG_OMAP_USB3 is not set
# CONFIG_AM335X_PHY_USB is not set
# CONFIG_SAMSUNG_USB2PHY is not set
# CONFIG_SAMSUNG_USB3PHY is not set
# CONFIG_USB_GPIO_VBUS is not set
# CONFIG_TAHVO_USB is not set
# CONFIG_USB_RCAR_GEN2_PHY is not set
# CONFIG_USB_GADGET is not set
# CONFIG_UWB is not set
CONFIG_MMC=y
CONFIG_MMC_DEBUG=y
# CONFIG_MMC_UNSAFE_RESUME is not set
# CONFIG_MMC_CLKGATE is not set

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
CONFIG_MMC_OMAP_HS=y
# CONFIG_MMC_WBSD is not set
# CONFIG_MMC_TIFM_SD is not set
# CONFIG_MMC_CB710 is not set
# CONFIG_MMC_VIA_SDMMC is not set
CONFIG_MEMSTICK=y
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
CONFIG_LEDS_88PM860X=y
# CONFIG_LEDS_LM3530 is not set
# CONFIG_LEDS_LM3533 is not set
# CONFIG_LEDS_LM3642 is not set
CONFIG_LEDS_PCA9532=y
# CONFIG_LEDS_PCA9532_GPIO is not set
CONFIG_LEDS_GPIO=y
# CONFIG_LEDS_LP3944 is not set
# CONFIG_LEDS_LP5521 is not set
# CONFIG_LEDS_LP5523 is not set
# CONFIG_LEDS_LP5562 is not set
# CONFIG_LEDS_LP8501 is not set
CONFIG_LEDS_PCA955X=y
CONFIG_LEDS_PCA963X=y
# CONFIG_LEDS_PCA9685 is not set
CONFIG_LEDS_WM831X_STATUS=y
# CONFIG_LEDS_WM8350 is not set
CONFIG_LEDS_DA903X=y
# CONFIG_LEDS_DA9052 is not set
# CONFIG_LEDS_DAC124S085 is not set
CONFIG_LEDS_BD2802=y
# CONFIG_LEDS_LT3593 is not set
CONFIG_LEDS_ADP5520=y
# CONFIG_LEDS_MC13783 is not set
CONFIG_LEDS_TCA6507=y
CONFIG_LEDS_MAX8997=y
# CONFIG_LEDS_LM355x is not set
CONFIG_LEDS_OT200=y
CONFIG_LEDS_BLINKM=y

#
# LED Triggers
#
CONFIG_LEDS_TRIGGERS=y
# CONFIG_LEDS_TRIGGER_TIMER is not set
CONFIG_LEDS_TRIGGER_ONESHOT=y
# CONFIG_LEDS_TRIGGER_HEARTBEAT is not set
# CONFIG_LEDS_TRIGGER_BACKLIGHT is not set
CONFIG_LEDS_TRIGGER_CPU=y
CONFIG_LEDS_TRIGGER_GPIO=y
# CONFIG_LEDS_TRIGGER_DEFAULT_ON is not set

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
# CONFIG_EDAC_AMD76X is not set
# CONFIG_EDAC_E7XXX is not set
# CONFIG_EDAC_E752X is not set
# CONFIG_EDAC_I82875P is not set
# CONFIG_EDAC_I82975X is not set
# CONFIG_EDAC_I3000 is not set
# CONFIG_EDAC_I3200 is not set
# CONFIG_EDAC_X38 is not set
# CONFIG_EDAC_I5400 is not set
# CONFIG_EDAC_I82860 is not set
# CONFIG_EDAC_R82600 is not set
# CONFIG_EDAC_I5000 is not set
# CONFIG_EDAC_I5100 is not set
# CONFIG_EDAC_I7300 is not set
CONFIG_RTC_LIB=y
CONFIG_RTC_CLASS=y
# CONFIG_RTC_HCTOSYS is not set
CONFIG_RTC_SYSTOHC=y
CONFIG_RTC_HCTOSYS_DEVICE="rtc0"
# CONFIG_RTC_DEBUG is not set

#
# RTC interfaces
#
# CONFIG_RTC_INTF_SYSFS is not set
CONFIG_RTC_INTF_PROC=y
# CONFIG_RTC_INTF_DEV is not set
CONFIG_RTC_DRV_TEST=y

#
# I2C RTC drivers
#
CONFIG_RTC_DRV_88PM860X=y
CONFIG_RTC_DRV_88PM80X=y
# CONFIG_RTC_DRV_DS1307 is not set
# CONFIG_RTC_DRV_DS1374 is not set
# CONFIG_RTC_DRV_DS1672 is not set
# CONFIG_RTC_DRV_DS3232 is not set
CONFIG_RTC_DRV_MAX6900=y
# CONFIG_RTC_DRV_MAX8907 is not set
CONFIG_RTC_DRV_MAX8998=y
CONFIG_RTC_DRV_MAX8997=y
CONFIG_RTC_DRV_MAX77686=y
CONFIG_RTC_DRV_RS5C372=y
CONFIG_RTC_DRV_ISL1208=y
CONFIG_RTC_DRV_ISL12022=y
CONFIG_RTC_DRV_ISL12057=y
CONFIG_RTC_DRV_X1205=y
CONFIG_RTC_DRV_PCF2127=y
# CONFIG_RTC_DRV_PCF8523 is not set
CONFIG_RTC_DRV_PCF8563=y
CONFIG_RTC_DRV_PCF8583=y
CONFIG_RTC_DRV_M41T80=y
# CONFIG_RTC_DRV_M41T80_WDT is not set
# CONFIG_RTC_DRV_BQ32K is not set
CONFIG_RTC_DRV_TPS6586X=y
# CONFIG_RTC_DRV_TPS80031 is not set
# CONFIG_RTC_DRV_RC5T583 is not set
CONFIG_RTC_DRV_S35390A=y
# CONFIG_RTC_DRV_FM3130 is not set
CONFIG_RTC_DRV_RX8581=y
CONFIG_RTC_DRV_RX8025=y
# CONFIG_RTC_DRV_EM3027 is not set
# CONFIG_RTC_DRV_RV3029C2 is not set
CONFIG_RTC_DRV_S5M=y

#
# SPI RTC drivers
#
CONFIG_RTC_DRV_M41T93=y
CONFIG_RTC_DRV_M41T94=y
CONFIG_RTC_DRV_DS1305=y
# CONFIG_RTC_DRV_DS1390 is not set
# CONFIG_RTC_DRV_MAX6902 is not set
CONFIG_RTC_DRV_R9701=y
CONFIG_RTC_DRV_RS5C348=y
CONFIG_RTC_DRV_DS3234=y
CONFIG_RTC_DRV_PCF2123=y
# CONFIG_RTC_DRV_RX4581 is not set

#
# Platform RTC drivers
#
CONFIG_RTC_DRV_CMOS=y
# CONFIG_RTC_DRV_DS1286 is not set
CONFIG_RTC_DRV_DS1511=y
CONFIG_RTC_DRV_DS1553=y
# CONFIG_RTC_DRV_DS1742 is not set
# CONFIG_RTC_DRV_DA9052 is not set
# CONFIG_RTC_DRV_STK17TA8 is not set
CONFIG_RTC_DRV_M48T86=y
CONFIG_RTC_DRV_M48T35=y
# CONFIG_RTC_DRV_M48T59 is not set
# CONFIG_RTC_DRV_MSM6242 is not set
# CONFIG_RTC_DRV_BQ4802 is not set
# CONFIG_RTC_DRV_RP5C01 is not set
# CONFIG_RTC_DRV_V3020 is not set
CONFIG_RTC_DRV_DS2404=y
CONFIG_RTC_DRV_WM831X=y
CONFIG_RTC_DRV_WM8350=y

#
# on-CPU RTC drivers
#
CONFIG_RTC_DRV_PCAP=y
CONFIG_RTC_DRV_MC13XXX=y
CONFIG_RTC_DRV_MOXART=y

#
# HID Sensor RTC drivers
#
# CONFIG_DMADEVICES is not set
CONFIG_AUXDISPLAY=y
CONFIG_KS0108=y
CONFIG_KS0108_PORT=0x378
CONFIG_KS0108_DELAY=2
# CONFIG_UIO is not set
CONFIG_VIRT_DRIVERS=y
CONFIG_VIRTIO=y

#
# Virtio drivers
#
# CONFIG_VIRTIO_PCI is not set
CONFIG_VIRTIO_BALLOON=y
CONFIG_VIRTIO_MMIO=y
CONFIG_VIRTIO_MMIO_CMDLINE_DEVICES=y

#
# Microsoft Hyper-V guest support
#
# CONFIG_HYPERV is not set
CONFIG_STAGING=y
# CONFIG_SLICOSS is not set
CONFIG_ECHO=y
# CONFIG_PANEL is not set
# CONFIG_DX_SEP is not set
# CONFIG_CRYSTALHD is not set
# CONFIG_ACPI_QUICKSTART is not set
CONFIG_FT1000=y

#
# Speakup console speech
#
CONFIG_TOUCHSCREEN_CLEARPAD_TM1217=y
CONFIG_TOUCHSCREEN_SYNAPTICS_I2C_RMI4=y
# CONFIG_STAGING_MEDIA is not set

#
# Android
#
# CONFIG_ANDROID is not set
# CONFIG_WIMAX_GDM72XX is not set
# CONFIG_DGRP is not set
# CONFIG_MTD_SPINAND_MT29F is not set
# CONFIG_XILLYBUS is not set
# CONFIG_DGNC is not set
# CONFIG_DGAP is not set
# CONFIG_GS_FPGABOOT is not set
CONFIG_X86_PLATFORM_DEVICES=y
# CONFIG_ACERHDF is not set
# CONFIG_ASUS_LAPTOP is not set
# CONFIG_FUJITSU_TABLET is not set
# CONFIG_HP_ACCEL is not set
# CONFIG_HP_WIRELESS is not set
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
# CONFIG_SAMSUNG_Q10 is not set
# CONFIG_INTEL_RST is not set
# CONFIG_INTEL_SMARTCONNECT is not set
# CONFIG_PVPANIC is not set
CONFIG_CHROME_PLATFORMS=y
# CONFIG_CHROMEOS_PSTORE is not set

#
# Hardware Spinlock drivers
#
CONFIG_CLKSRC_I8253=y
CONFIG_CLKEVT_I8253=y
CONFIG_CLKBLD_I8253=y
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
# CONFIG_DEVFREQ_GOV_PERFORMANCE is not set
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
CONFIG_EXTCON_MAX77693=y
# CONFIG_EXTCON_MAX8997 is not set
# CONFIG_MEMORY is not set
# CONFIG_IIO is not set
# CONFIG_NTB is not set
# CONFIG_VME_BUS is not set
# CONFIG_PWM is not set
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
# CONFIG_GENERIC_PHY is not set
CONFIG_PHY_EXYNOS_MIPI_VIDEO=y
CONFIG_POWERCAP=y
# CONFIG_INTEL_RAPL is not set

#
# Firmware Drivers
#
# CONFIG_EDD is not set
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
CONFIG_EXPORTFS=y
CONFIG_FILE_LOCKING=y
# CONFIG_FSNOTIFY is not set
# CONFIG_DNOTIFY is not set
# CONFIG_INOTIFY_USER is not set
# CONFIG_FANOTIFY is not set
CONFIG_QUOTA=y
# CONFIG_QUOTA_NETLINK_INTERFACE is not set
# CONFIG_PRINT_QUOTA_WARNING is not set
# CONFIG_QUOTA_DEBUG is not set
CONFIG_QFMT_V1=y
# CONFIG_QFMT_V2 is not set
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
CONFIG_PROC_VMCORE=y
CONFIG_PROC_SYSCTL=y
CONFIG_PROC_PAGE_MONITOR=y
CONFIG_KERNFS=y
CONFIG_SYSFS=y
CONFIG_HUGETLBFS=y
CONFIG_HUGETLB_PAGE=y
CONFIG_CONFIGFS_FS=y
# CONFIG_MISC_FILESYSTEMS is not set
CONFIG_NETWORK_FILESYSTEMS=y
CONFIG_NLS=y
CONFIG_NLS_DEFAULT="iso8859-1"
CONFIG_NLS_CODEPAGE_437=y
CONFIG_NLS_CODEPAGE_737=y
# CONFIG_NLS_CODEPAGE_775 is not set
CONFIG_NLS_CODEPAGE_850=y
CONFIG_NLS_CODEPAGE_852=y
# CONFIG_NLS_CODEPAGE_855 is not set
CONFIG_NLS_CODEPAGE_857=y
# CONFIG_NLS_CODEPAGE_860 is not set
CONFIG_NLS_CODEPAGE_861=y
CONFIG_NLS_CODEPAGE_862=y
CONFIG_NLS_CODEPAGE_863=y
CONFIG_NLS_CODEPAGE_864=y
# CONFIG_NLS_CODEPAGE_865 is not set
CONFIG_NLS_CODEPAGE_866=y
CONFIG_NLS_CODEPAGE_869=y
# CONFIG_NLS_CODEPAGE_936 is not set
CONFIG_NLS_CODEPAGE_950=y
CONFIG_NLS_CODEPAGE_932=y
CONFIG_NLS_CODEPAGE_949=y
CONFIG_NLS_CODEPAGE_874=y
CONFIG_NLS_ISO8859_8=y
CONFIG_NLS_CODEPAGE_1250=y
# CONFIG_NLS_CODEPAGE_1251 is not set
# CONFIG_NLS_ASCII is not set
CONFIG_NLS_ISO8859_1=y
# CONFIG_NLS_ISO8859_2 is not set
# CONFIG_NLS_ISO8859_3 is not set
CONFIG_NLS_ISO8859_4=y
CONFIG_NLS_ISO8859_5=y
CONFIG_NLS_ISO8859_6=y
CONFIG_NLS_ISO8859_7=y
CONFIG_NLS_ISO8859_9=y
CONFIG_NLS_ISO8859_13=y
CONFIG_NLS_ISO8859_14=y
# CONFIG_NLS_ISO8859_15 is not set
# CONFIG_NLS_KOI8_R is not set
CONFIG_NLS_KOI8_U=y
# CONFIG_NLS_MAC_ROMAN is not set
# CONFIG_NLS_MAC_CELTIC is not set
# CONFIG_NLS_MAC_CENTEURO is not set
CONFIG_NLS_MAC_CROATIAN=y
CONFIG_NLS_MAC_CYRILLIC=y
# CONFIG_NLS_MAC_GAELIC is not set
# CONFIG_NLS_MAC_GREEK is not set
# CONFIG_NLS_MAC_ICELAND is not set
CONFIG_NLS_MAC_INUIT=y
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
CONFIG_ENABLE_WARN_DEPRECATED=y
# CONFIG_ENABLE_MUST_CHECK is not set
CONFIG_FRAME_WARN=1024
# CONFIG_STRIP_ASM_SYMS is not set
# CONFIG_READABLE_ASM is not set
CONFIG_UNUSED_SYMBOLS=y
CONFIG_DEBUG_FS=y
CONFIG_HEADERS_CHECK=y
CONFIG_DEBUG_SECTION_MISMATCH=y
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
CONFIG_DEBUG_OBJECTS=y
CONFIG_DEBUG_OBJECTS_SELFTEST=y
CONFIG_DEBUG_OBJECTS_FREE=y
CONFIG_DEBUG_OBJECTS_TIMERS=y
CONFIG_DEBUG_OBJECTS_WORK=y
CONFIG_DEBUG_OBJECTS_RCU_HEAD=y
# CONFIG_DEBUG_OBJECTS_PERCPU_COUNTER is not set
CONFIG_DEBUG_OBJECTS_ENABLE_DEFAULT=1
CONFIG_SLUB_STATS=y
CONFIG_HAVE_DEBUG_KMEMLEAK=y
# CONFIG_DEBUG_KMEMLEAK is not set
# CONFIG_DEBUG_STACK_USAGE is not set
# CONFIG_DEBUG_VM is not set
CONFIG_DEBUG_VIRTUAL=y
CONFIG_DEBUG_MEMORY_INIT=y
CONFIG_DEBUG_PER_CPU_MAPS=y
# CONFIG_DEBUG_HIGHMEM is not set
CONFIG_HAVE_DEBUG_STACKOVERFLOW=y
# CONFIG_DEBUG_STACKOVERFLOW is not set
CONFIG_HAVE_ARCH_KMEMCHECK=y
# CONFIG_DEBUG_SHIRQ is not set

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
CONFIG_TIMER_STATS=y

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
# CONFIG_PROVE_LOCKING is not set
CONFIG_LOCKDEP=y
# CONFIG_LOCK_STAT is not set
# CONFIG_DEBUG_LOCKDEP is not set
CONFIG_DEBUG_ATOMIC_SLEEP=y
CONFIG_DEBUG_LOCKING_API_SELFTESTS=y
CONFIG_LOCK_TORTURE_TEST=y
CONFIG_TRACE_IRQFLAGS=y
CONFIG_STACKTRACE=y
# CONFIG_DEBUG_KOBJECT is not set
# CONFIG_DEBUG_KOBJECT_RELEASE is not set
CONFIG_DEBUG_BUGVERBOSE=y
CONFIG_DEBUG_WRITECOUNT=y
# CONFIG_DEBUG_LIST is not set
# CONFIG_DEBUG_SG is not set
# CONFIG_DEBUG_NOTIFIERS is not set
# CONFIG_DEBUG_CREDENTIALS is not set

#
# RCU Debugging
#
# CONFIG_SPARSE_RCU_POINTER is not set
CONFIG_TORTURE_TEST=y
# CONFIG_RCU_TORTURE_TEST is not set
CONFIG_RCU_CPU_STALL_TIMEOUT=21
# CONFIG_RCU_CPU_STALL_INFO is not set
CONFIG_RCU_TRACE=y
CONFIG_NOTIFIER_ERROR_INJECTION=y
# CONFIG_CPU_NOTIFIER_ERROR_INJECT is not set
# CONFIG_PM_NOTIFIER_ERROR_INJECT is not set
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
CONFIG_IRQSOFF_TRACER=y
# CONFIG_SCHED_TRACER is not set
# CONFIG_FTRACE_SYSCALLS is not set
CONFIG_TRACER_SNAPSHOT=y
CONFIG_TRACER_SNAPSHOT_PER_CPU_SWAP=y
CONFIG_BRANCH_PROFILE_NONE=y
# CONFIG_PROFILE_ANNOTATED_BRANCHES is not set
# CONFIG_PROFILE_ALL_BRANCHES is not set
# CONFIG_STACK_TRACER is not set
CONFIG_UPROBE_EVENT=y
CONFIG_PROBE_EVENTS=y
CONFIG_DYNAMIC_FTRACE=y
CONFIG_DYNAMIC_FTRACE_WITH_REGS=y
CONFIG_FUNCTION_PROFILER=y
CONFIG_FTRACE_MCOUNT_RECORD=y
# CONFIG_FTRACE_STARTUP_TEST is not set
# CONFIG_MMIOTRACE is not set
CONFIG_RING_BUFFER_BENCHMARK=y
# CONFIG_RING_BUFFER_STARTUP_TEST is not set

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
# CONFIG_BUILD_DOCSRC is not set
# CONFIG_DMA_API_DEBUG is not set
# CONFIG_SAMPLES is not set
CONFIG_HAVE_ARCH_KGDB=y
# CONFIG_KGDB is not set
CONFIG_STRICT_DEVMEM=y
CONFIG_X86_VERBOSE_BOOTUP=y
# CONFIG_EARLY_PRINTK is not set
CONFIG_X86_PTDUMP=y
CONFIG_DEBUG_RODATA=y
# CONFIG_DEBUG_RODATA_TEST is not set
# CONFIG_DOUBLEFAULT is not set
# CONFIG_DEBUG_TLBFLUSH is not set
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
CONFIG_DEBUG_BOOT_PARAMS=y
# CONFIG_CPA_DEBUG is not set
CONFIG_OPTIMIZE_INLINING=y
CONFIG_DEBUG_NMI_SELFTEST=y
CONFIG_X86_DEBUG_STATIC_CPU_HAS=y

#
# Security options
#
# CONFIG_KEYS is not set
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
# CONFIG_CRYPTO_PCRYPT is not set
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
CONFIG_CRYPTO_ECB=y
CONFIG_CRYPTO_LRW=y
# CONFIG_CRYPTO_PCBC is not set
CONFIG_CRYPTO_XTS=y

#
# Hash modes
#
CONFIG_CRYPTO_CMAC=y
# CONFIG_CRYPTO_HMAC is not set
CONFIG_CRYPTO_XCBC=y
# CONFIG_CRYPTO_VMAC is not set

#
# Digest
#
CONFIG_CRYPTO_CRC32C=y
# CONFIG_CRYPTO_CRC32C_INTEL is not set
CONFIG_CRYPTO_CRC32=y
CONFIG_CRYPTO_CRC32_PCLMUL=y
CONFIG_CRYPTO_CRCT10DIF=y
CONFIG_CRYPTO_GHASH=y
CONFIG_CRYPTO_MD4=y
CONFIG_CRYPTO_MD5=y
CONFIG_CRYPTO_MICHAEL_MIC=y
CONFIG_CRYPTO_RMD128=y
# CONFIG_CRYPTO_RMD160 is not set
# CONFIG_CRYPTO_RMD256 is not set
CONFIG_CRYPTO_RMD320=y
CONFIG_CRYPTO_SHA1=y
CONFIG_CRYPTO_SHA256=y
CONFIG_CRYPTO_SHA512=y
# CONFIG_CRYPTO_TGR192 is not set
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
# CONFIG_CRYPTO_FCRYPT is not set
CONFIG_CRYPTO_KHAZAD=y
CONFIG_CRYPTO_SALSA20=y
CONFIG_CRYPTO_SALSA20_586=y
# CONFIG_CRYPTO_SEED is not set
CONFIG_CRYPTO_SERPENT=y
CONFIG_CRYPTO_SERPENT_SSE2_586=y
CONFIG_CRYPTO_TEA=y
# CONFIG_CRYPTO_TWOFISH is not set
CONFIG_CRYPTO_TWOFISH_COMMON=y
CONFIG_CRYPTO_TWOFISH_586=y

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
CONFIG_CRYPTO_ANSI_CPRNG=y
# CONFIG_CRYPTO_USER_API_HASH is not set
# CONFIG_CRYPTO_USER_API_SKCIPHER is not set
# CONFIG_CRYPTO_HW is not set
CONFIG_HAVE_KVM=y
CONFIG_VIRTUALIZATION=y
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
# CONFIG_CRC32_SELFTEST is not set
# CONFIG_CRC32_SLICEBY8 is not set
# CONFIG_CRC32_SLICEBY4 is not set
CONFIG_CRC32_SARWATE=y
# CONFIG_CRC32_BIT is not set
CONFIG_CRC7=y
# CONFIG_LIBCRC32C is not set
CONFIG_CRC8=y
# CONFIG_CRC64_ECMA is not set
# CONFIG_RANDOM32_SELFTEST is not set
CONFIG_ZLIB_INFLATE=y
CONFIG_ZLIB_DEFLATE=y
CONFIG_LZO_COMPRESS=y
CONFIG_LZO_DECOMPRESS=y
CONFIG_LZ4_COMPRESS=y
CONFIG_LZ4HC_COMPRESS=y
CONFIG_LZ4_DECOMPRESS=y
CONFIG_XZ_DEC=y
CONFIG_XZ_DEC_X86=y
CONFIG_XZ_DEC_POWERPC=y
CONFIG_XZ_DEC_IA64=y
# CONFIG_XZ_DEC_ARM is not set
CONFIG_XZ_DEC_ARMTHUMB=y
CONFIG_XZ_DEC_SPARC=y
CONFIG_XZ_DEC_BCJ=y
CONFIG_XZ_DEC_TEST=y
CONFIG_DECOMPRESS_GZIP=y
CONFIG_GENERIC_ALLOCATOR=y
CONFIG_REED_SOLOMON=y
CONFIG_REED_SOLOMON_DEC16=y
CONFIG_BCH=y
CONFIG_BCH_CONST_PARAMS=y
CONFIG_HAS_IOMEM=y
CONFIG_HAS_IOPORT=y
CONFIG_HAS_DMA=y
CONFIG_CHECK_SIGNATURE=y
CONFIG_CPUMASK_OFFSTACK=y
CONFIG_CPU_RMAP=y
CONFIG_DQL=y
CONFIG_NLATTR=y
CONFIG_ARCH_HAS_ATOMIC64_DEC_IF_POSITIVE=y
# CONFIG_AVERAGE is not set
CONFIG_CORDIC=y
# CONFIG_DDR is not set

--OgqxwSJOaUobr8KG
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

_______________________________________________
LKP mailing list
LKP@linux.intel.com

--OgqxwSJOaUobr8KG--
