Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754088Ab3GTNOA (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Jul 2013 09:14:00 -0400
Received: from mga02.intel.com ([134.134.136.20]:33586 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753723Ab3GTNNy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Jul 2013 09:13:54 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.89,708,1367996400"; 
   d="log'?scan'208";a="368320527"
Date: Sat, 20 Jul 2013 21:13:44 +0800
From: Fengguang Wu <fengguang.wu@intel.com>
To: fengguang.wu@intel.com, Davidlohr Bueso <davidlohr.bueso@hp.com>
Cc: linux-kernel@vger.kernel.org
Subject: [ipc,shm] BUG: lock held when returning to user space!
Message-ID: <20130720131343.GB13893@localhost>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="ZoaI/ZTpAVc4A5k6"
Content-Disposition: inline
User-Agent: Heirloom mailx 12.5 6/20/10
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--ZoaI/ZTpAVc4A5k6
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Greetings,

I got the below dmesg and the first bad commit is

commit c5d0282a0405b0a81fa3390e4230e4cbb3ced7a2
Author: Davidlohr Bueso <davidlohr.bueso@hp.com>
Date:   Fri Jul 19 09:56:58 2013 +1000

    ipc,shm: shorten critical region for shmat
    
    Similar to other system calls, acquire the kern_ipc_perm lock after doing
    the initial permission and security checks.
    
    Signed-off-by: Davidlohr Bueso <davidlohr.bueso@hp.com>
    Tested-by: Sedat Dilek <sedat.dilek@gmail.com>
    Cc: Rik van Riel <riel@redhat.com>
    Cc: Manfred Spraul <manfred@colorfullife.com>
    Signed-off-by: Andrew Morton <akpm@linux-foundation.org>

[   20.702156] 
[   20.702493] ================================================
[   20.703511] [ BUG: lock held when returning to user space! ]
[   20.704532] 3.11.0-rc1-next-20130719 #50 Not tainted
[   20.705416] ------------------------------------------------
[   20.706425] trinity-child0/174 is leaving the kernel with locks still held!
[   20.707638] 1 lock held by trinity-child0/174:
[   20.708475]  #0:  (rcu_read_lock){.+.+..}, at: [<ffffffff814a8491>] do_shmat+0xe1/0x500

git bisect start c1f631b9a68251007a6353041ae90f9f7dca771c d03792f9db9b892f494d3aa19d767ddf0365d1ff --
git bisect good 10a3f1f902465ae1320cc95a3284fd3697e05dd8  # 11:14     65+  binfmt_elf.c: use get_random_int() to fix entropy depleting
git bisect  bad dac28788378838efb63e37a7eabd7729d97aba6b  # 11:32      0-  dcache: remove dentries from LRU before putting on dispose list
git bisect good 3140b2ed6dfe5c9e5eca371c77ca85dca05321d4  # 11:50     65+  ipc,shm: introduce shmctl_nolock
git bisect  bad 48a91248649fa3327bd8a31c114ee9149a07f3a7  # 12:04      0-  staging/lustre/ldlm: convert to shrinkers to count/scan API
git bisect good 98b78126a51aa5d3ee6d5dae5768e0d16deeeaa3  # 12:14     65+  ipc,shm: cleanup do_shmat pasta
git bisect  bad 36ccfd799cad33e2edd5c14ac8776b33e63d195b  # 12:14      0-  ipc: rename ids->rw_mutex
git bisect  bad c5d0282a0405b0a81fa3390e4230e4cbb3ced7a2  # 12:14      0-  ipc,shm: shorten critical region for shmat
git bisect good 98b78126a51aa5d3ee6d5dae5768e0d16deeeaa3  # 15:34    195+  ipc,shm: cleanup do_shmat pasta
git bisect  bad c1f631b9a68251007a6353041ae90f9f7dca771c  # 15:34      0-  Add linux-next specific files for 20130719
git bisect good 709b465ee655387c4ec056383fa27f16c64f48db  # 18:21    195+  Revert "ipc,shm: shorten critical region for shmat"
git bisect good d471ce53b1fab60110e4e9f647a345cea31752de  # 18:44    195+  Merge branch 'for-linus' of git://git.kernel.org/pub/scm/linux/kernel/git/rw/uml
git bisect  bad c1f631b9a68251007a6353041ae90f9f7dca771c  # 18:44      0-  Add linux-next specific files for 20130719

Thanks,
Fengguang

--ZoaI/ZTpAVc4A5k6
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="dmesg-kvm-inn-6308-20130719220433-3.11.0-rc1-next-20130719-50"
Content-Transfer-Encoding: quoted-printable

[    0.000000] Initializing cgroup subsys cpu
[    0.000000] Linux version 3.11.0-rc1-next-20130719 (kbuild@xian) (gcc ve=
rsion 4.8.1 (Debian 4.8.1-3) ) #50 PREEMPT Fri Jul 19 21:52:02 CST 2013
[    0.000000] Command line: hung_task_panic=3D1 rcutree.rcu_cpu_stall_time=
out=3D100 log_buf_len=3D8M ignore_loglevel debug sched_debug apic=3Ddebug d=
ynamic_printk sysrq_always_enabled panic=3D10  prompt_ramdisk=3D0 console=
=3DttyS0,115200 console=3Dtty0 vga=3Dnormal  root=3D/dev/ram0 rw link=3D/ke=
rnel-tests/run-queue/kvm/x86_64-randconfig-x02-0719/next:master/.vmlinuz-c1=
f631b9a68251007a6353041ae90f9f7dca771c-20130719215229-9-inn branch=3Dnext/m=
aster  BOOT_IMAGE=3D/kernel/x86_64-randconfig-x02-0719/c1f631b9a68251007a63=
53041ae90f9f7dca771c/vmlinuz-3.11.0-rc1-next-20130719
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
[    0.000000] debug: ignoring loglevel setting.
[    0.000000] NX (Execute Disable) protection: active
[    0.000000] SMBIOS 2.4 present.
[    0.000000] DMI: Bochs Bochs, BIOS Bochs 01/01/2011
[    0.000000] Hypervisor detected: KVM
[    0.000000] e820: update [mem 0x00000000-0x00000fff] usable =3D=3D> rese=
rved
[    0.000000] e820: remove [mem 0x000a0000-0x000fffff] usable
[    0.000000] e820: last_pfn =3D 0xfffe max_arch_pfn =3D 0x400000000
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
[    0.000000] Scanning 1 areas for low memory corruption
[    0.000000] Base memory trampoline at [ffff880000099000] 99000 size 24576
[    0.000000] init_memory_mapping: [mem 0x00000000-0x000fffff]
[    0.000000]  [mem 0x00000000-0x000fffff] page 4k
[    0.000000] BRK [0x03736000, 0x03736fff] PGTABLE
[    0.000000] BRK [0x03737000, 0x03737fff] PGTABLE
[    0.000000] BRK [0x03738000, 0x03738fff] PGTABLE
[    0.000000] init_memory_mapping: [mem 0x0e600000-0x0e7fffff]
[    0.000000]  [mem 0x0e600000-0x0e7fffff] page 4k
[    0.000000] BRK [0x03739000, 0x03739fff] PGTABLE
[    0.000000] init_memory_mapping: [mem 0x0c000000-0x0e5fffff]
[    0.000000]  [mem 0x0c000000-0x0e5fffff] page 4k
[    0.000000] BRK [0x0373a000, 0x0373afff] PGTABLE
[    0.000000] init_memory_mapping: [mem 0x00100000-0x0bffffff]
[    0.000000]  [mem 0x00100000-0x0bffffff] page 4k
[    0.000000] init_memory_mapping: [mem 0x0e800000-0x0fffdfff]
[    0.000000]  [mem 0x0e800000-0x0fffdfff] page 4k
[    0.000000] log_buf_len: 8388608
[    0.000000] early log buf free: 127684(97%)
[    0.000000] RAMDISK: [mem 0x0e8d6000-0x0ffeffff]
[    0.000000] ACPI: RSDP 00000000000fd920 00014 (v00 BOCHS )
[    0.000000] ACPI: RSDT 000000000fffe450 00034 (v01 BOCHS  BXPCRSDT 00000=
001 BXPC 00000001)
[    0.000000] ACPI: FACP 000000000fffff80 00074 (v01 BOCHS  BXPCFACP 00000=
001 BXPC 00000001)
[    0.000000] ACPI: DSDT 000000000fffe490 011A9 (v01   BXPC   BXDSDT 00000=
001 INTL 20100528)
[    0.000000] ACPI: FACS 000000000fffff40 00040
[    0.000000] ACPI: SSDT 000000000ffff7a0 00796 (v01 BOCHS  BXPCSSDT 00000=
001 BXPC 00000001)
[    0.000000] ACPI: APIC 000000000ffff680 00080 (v01 BOCHS  BXPCAPIC 00000=
001 BXPC 00000001)
[    0.000000] ACPI: HPET 000000000ffff640 00038 (v01 BOCHS  BXPCHPET 00000=
001 BXPC 00000001)
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] mapped APIC to ffffffffff5fa000 (        fee00000)
[    0.000000] kvm-clock: Using msrs 4b564d01 and 4b564d00
[    0.000000] kvm-clock: cpu 0, msr 0:fffd001, boot clock
[    0.000000]  [ffffea0000000000-ffffea00003fffff] PMD -> [ffff88000d20000=
0-ffff88000d5fffff] on node 0
[    0.000000] Zone ranges:
[    0.000000]   DMA      [mem 0x00001000-0x00ffffff]
[    0.000000]   DMA32    [mem 0x01000000-0xffffffff]
[    0.000000]   Normal   empty
[    0.000000] Movable zone start for each node
[    0.000000] Early memory node ranges
[    0.000000]   node   0: [mem 0x00001000-0x0009efff]
[    0.000000]   node   0: [mem 0x00100000-0x0fffdfff]
[    0.000000] On node 0 totalpages: 65436
[    0.000000]   DMA zone: 64 pages used for memmap
[    0.000000]   DMA zone: 21 pages reserved
[    0.000000]   DMA zone: 3998 pages, LIFO batch:0
[    0.000000]   DMA32 zone: 960 pages used for memmap
[    0.000000]   DMA32 zone: 61438 pages, LIFO batch:15
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
[    0.000000] kvm-stealtime: cpu 0, msr 2b62d00
[    0.000000] e820: [mem 0x10000000-0xfeffbfff] available for PCI devices
[    0.000000] Booting paravirtualized kernel on KVM
[    0.000000] pcpu-alloc: s0 r0 d32768 u32768 alloc=3D1*32768
[    0.000000] pcpu-alloc: [0] 0=20
[    0.000000] Built 1 zonelists in Zone order, mobility grouping on.  Tota=
l pages: 64391
[    0.000000] Kernel command line: hung_task_panic=3D1 rcutree.rcu_cpu_sta=
ll_timeout=3D100 log_buf_len=3D8M ignore_loglevel debug sched_debug apic=3D=
debug dynamic_printk sysrq_always_enabled panic=3D10  prompt_ramdisk=3D0 co=
nsole=3DttyS0,115200 console=3Dtty0 vga=3Dnormal  root=3D/dev/ram0 rw link=
=3D/kernel-tests/run-queue/kvm/x86_64-randconfig-x02-0719/next:master/.vmli=
nuz-c1f631b9a68251007a6353041ae90f9f7dca771c-20130719215229-9-inn branch=3D=
next/master  BOOT_IMAGE=3D/kernel/x86_64-randconfig-x02-0719/c1f631b9a68251=
007a6353041ae90f9f7dca771c/vmlinuz-3.11.0-rc1-next-20130719
[    0.000000] sysrq: sysrq always enabled.
[    0.000000] PID hash table entries: 1024 (order: 1, 8192 bytes)
[    0.000000] Dentry cache hash table entries: 32768 (order: 6, 262144 byt=
es)
[    0.000000] Inode-cache hash table entries: 16384 (order: 5, 131072 byte=
s)
[    0.000000] Calgary: detecting Calgary via BIOS EBDA area
[    0.000000] Calgary: Unable to locate Rio Grande table in EBDA - bailing!
[    0.000000] Memory: 184572K/261744K available (19592K kernel code, 1932K=
 rwdata, 8272K rodata, 976K init, 9364K bss, 77172K reserved)
[    0.000000] Preemptible hierarchical RCU implementation.
[    0.000000]=20
[    0.000000] NR_IRQS:4352 nr_irqs:256 16
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
[    0.000000] allocated 1048576 bytes of page_cgroup
[    0.000000] please try 'cgroup_disable=3Dmemory' option if you don't wan=
t memory cgroups
[    0.000000] hpet clockevent registered
[    0.000000] tsc: Detected 2693.514 MHz processor
[    0.003000] Calibrating delay loop (skipped) preset value.. 5387.02 Bogo=
MIPS (lpj=3D2693514)
[    0.003406] pid_max: default: 4096 minimum: 301
[    0.004056] Mount-cache hash table entries: 256
[    0.005330] Initializing cgroup subsys memory
[    0.006056] Initializing cgroup subsys devices
[    0.006689] Initializing cgroup subsys freezer
[    0.007018] Initializing cgroup subsys blkio
[    0.008008] Initializing cgroup subsys net_prio
[    0.008647] Initializing cgroup subsys hugetlb
[    0.009096] mce: CPU supports 10 MCE banks
[    0.010058] Last level iTLB entries: 4KB 0, 2MB 0, 4MB 0
[    0.010058] Last level dTLB entries: 4KB 0, 2MB 0, 4MB 0
[    0.010058] tlb_flushall_shift: 6
[    0.011005] CPU: Intel Common KVM processor (fam: 0f, model: 06, steppin=
g: 01)
[    0.016361] ACPI: Core revision 20130517
[    0.020036] ACPI: All ACPI Tables successfully acquired
[    0.020933] Performance Events: unsupported Netburst CPU model 6 no PMU =
driver, software events only.
[    0.022584] Getting VERSION: 50014
[    0.023013] Getting VERSION: 50014
[    0.023484] Getting ID: 0
[    0.024016] Getting ID: ff000000
[    0.024471] Getting LVT0: 8700
[    0.025009] Getting LVT1: 8400
[    0.025505] enabled ExtINT on CPU#0
[    0.026019] NMI watchdog: disabled (cpu0): hardware events not enabled
[    0.028491] ENABLING IO-APIC IRQs
[    0.028933] init IO_APIC IRQs
[    0.029005]  apic 0 pin 0 not connected
[    0.029514] IOAPIC[0]: Set routing entry (0-1 -> 0x31 -> IRQ 1 Mode:0 Ac=
tive:0 Dest:1)
[    0.031008] IOAPIC[0]: Set routing entry (0-2 -> 0x30 -> IRQ 0 Mode:0 Ac=
tive:0 Dest:1)
[    0.032025] IOAPIC[0]: Set routing entry (0-3 -> 0x33 -> IRQ 3 Mode:0 Ac=
tive:0 Dest:1)
[    0.033023] IOAPIC[0]: Set routing entry (0-4 -> 0x34 -> IRQ 4 Mode:0 Ac=
tive:0 Dest:1)
[    0.034030] IOAPIC[0]: Set routing entry (0-5 -> 0x35 -> IRQ 5 Mode:1 Ac=
tive:0 Dest:1)
[    0.035022] IOAPIC[0]: Set routing entry (0-6 -> 0x36 -> IRQ 6 Mode:0 Ac=
tive:0 Dest:1)
[    0.036027] IOAPIC[0]: Set routing entry (0-7 -> 0x37 -> IRQ 7 Mode:0 Ac=
tive:0 Dest:1)
[    0.037025] IOAPIC[0]: Set routing entry (0-8 -> 0x38 -> IRQ 8 Mode:0 Ac=
tive:0 Dest:1)
[    0.038025] IOAPIC[0]: Set routing entry (0-9 -> 0x39 -> IRQ 9 Mode:1 Ac=
tive:0 Dest:1)
[    0.039025] IOAPIC[0]: Set routing entry (0-10 -> 0x3a -> IRQ 10 Mode:1 =
Active:0 Dest:1)
[    0.040025] IOAPIC[0]: Set routing entry (0-11 -> 0x3b -> IRQ 11 Mode:1 =
Active:0 Dest:1)
[    0.041025] IOAPIC[0]: Set routing entry (0-12 -> 0x3c -> IRQ 12 Mode:0 =
Active:0 Dest:1)
[    0.042025] IOAPIC[0]: Set routing entry (0-13 -> 0x3d -> IRQ 13 Mode:0 =
Active:0 Dest:1)
[    0.043025] IOAPIC[0]: Set routing entry (0-14 -> 0x3e -> IRQ 14 Mode:0 =
Active:0 Dest:1)
[    0.044025] IOAPIC[0]: Set routing entry (0-15 -> 0x3f -> IRQ 15 Mode:0 =
Active:0 Dest:1)
[    0.045021]  apic 0 pin 16 not connected
[    0.046003]  apic 0 pin 17 not connected
[    0.046513]  apic 0 pin 18 not connected
[    0.047003]  apic 0 pin 19 not connected
[    0.047513]  apic 0 pin 20 not connected
[    0.048003]  apic 0 pin 21 not connected
[    0.048511]  apic 0 pin 22 not connected
[    0.049003]  apic 0 pin 23 not connected
[    0.049649] ..TIMER: vector=3D0x30 apic1=3D0 pin1=3D2 apic2=3D-1 pin2=3D=
-1
[    0.050003] Using local APIC timer interrupts.
[    0.050003] calibrating APIC timer ...
[    0.052000] ... lapic delta =3D 10810840
[    0.052000] ... PM-Timer delta =3D 619160
[    0.052000] APIC calibration not consistent with PM-Timer: 172ms instead=
 of 100ms
[    0.052000] APIC delta adjusted to PM-Timer: 6250053 (10810840)
[    0.052000] TSC delta adjusted to PM-Timer: 269349001 (465898209)
[    0.052000] ..... delta 6250053
[    0.052000] ..... mult: 268437732
[    0.052000] ..... calibration result: 1000008
[    0.052000] ..... CPU clock speed is 2693.0490 MHz.
[    0.052000] ..... host bus clock speed is 1000.0008 MHz.
[    0.054702] xor: measuring software checksum speed
[    0.065016]    prefetch64-sse:  9660.000 MB/sec
[    0.075008]    generic_sse:  8032.000 MB/sec
[    0.076003] xor: using function: prefetch64-sse (9660.000 MB/sec)
[    0.077346] regulator-dummy: no parameters
[    0.079021] NET: Registered protocol family 16
[    0.080561] cpuidle: using governor ladder
[    0.090480] ACPI: bus type PCI registered
[    0.091004] acpiphp: ACPI Hot Plug PCI Controller Driver version: 0.5
[    0.092057] PCI: Using configuration type 1 for base access
[    0.107762] bio: create slab <bio-0> at 0
[    0.125023] raid6: sse2x1    4621 MB/s
[    0.143008] raid6: sse2x2    5148 MB/s
[    0.161009] raid6: sse2x4    7421 MB/s
[    0.162004] raid6: using algorithm sse2x4 (7421 MB/s)
[    0.163000] raid6: using intx1 recovery algorithm
[    0.163047] ACPI: Added _OSI(Module Device)
[    0.164004] ACPI: Added _OSI(Processor Device)
[    0.165004] ACPI: Added _OSI(3.0 _SCP Extensions)
[    0.166004] ACPI: Added _OSI(Processor Aggregator Device)
[    0.168864] ACPI: EC: Look up EC in DSDT
[    0.175523] ACPI: Interpreter enabled
[    0.176013] ACPI: (supports S0 S5)
[    0.176704] ACPI: Using IOAPIC for interrupt routing
[    0.177030] PCI: Using host bridge windows from ACPI; if necessary, use =
"pci=3Dnocrs" and report a bug
[    0.193057] ACPI: PCI Root Bridge [PCI0] (domain 0000 [bus 00-ff])
[    0.194580] acpi PNP0A03:00: fail to add MMCONFIG information, can't acc=
ess extended PCI configuration space under this bridge.
[    0.196934] acpiphp: Slot [3] registered
[    0.197093] acpiphp: Slot [4] registered
[    0.197946] acpiphp: Slot [5] registered
[    0.198000] acpiphp: Slot [6] registered
[    0.198002] acpiphp: Slot [7] registered
[    0.198855] acpiphp: Slot [8] registered
[    0.199061] acpiphp: Slot [9] registered
[    0.200075] acpiphp: Slot [10] registered
[    0.201060] acpiphp: Slot [11] registered
[    0.202061] acpiphp: Slot [12] registered
[    0.203072] acpiphp: Slot [13] registered
[    0.204067] acpiphp: Slot [14] registered
[    0.205062] acpiphp: Slot [15] registered
[    0.205940] acpiphp: Slot [16] registered
[    0.206061] acpiphp: Slot [17] registered
[    0.207060] acpiphp: Slot [18] registered
[    0.208073] acpiphp: Slot [19] registered
[    0.209060] acpiphp: Slot [20] registered
[    0.210060] acpiphp: Slot [21] registered
[    0.211060] acpiphp: Slot [22] registered
[    0.212073] acpiphp: Slot [23] registered
[    0.212938] acpiphp: Slot [24] registered
[    0.213066] acpiphp: Slot [25] registered
[    0.214078] acpiphp: Slot [26] registered
[    0.215066] acpiphp: Slot [27] registered
[    0.216062] acpiphp: Slot [28] registered
[    0.217080] acpiphp: Slot [29] registered
[    0.218067] acpiphp: Slot [30] registered
[    0.219073] acpiphp: Slot [31] registered
[    0.220020] PCI host bridge to bus 0000:00
[    0.221007] pci_bus 0000:00: root bus resource [bus 00-ff]
[    0.222006] pci_bus 0000:00: root bus resource [io  0x0000-0x0cf7]
[    0.223005] pci_bus 0000:00: root bus resource [io  0x0d00-0xffff]
[    0.224005] pci_bus 0000:00: root bus resource [mem 0x000a0000-0x000bfff=
f]
[    0.225000] pci_bus 0000:00: root bus resource [mem 0x80000000-0xfebffff=
f]
[    0.225000] pci 0000:00:00.0: [8086:1237] type 00 class 0x060000
[    0.225096] pci 0000:00:01.0: [8086:7000] type 00 class 0x060100
[    0.227422] pci 0000:00:01.1: [8086:7010] type 00 class 0x010180
[    0.232420] pci 0000:00:01.1: reg 0x20: [io  0xc1e0-0xc1ef]
[    0.235421] pci 0000:00:01.3: [8086:7113] type 00 class 0x068000
[    0.237452] pci 0000:00:01.3: quirk: [io  0xb000-0xb03f] claimed by PIIX=
4 ACPI
[    0.238017] pci 0000:00:01.3: quirk: [io  0xb100-0xb10f] claimed by PIIX=
4 SMB
[    0.240248] pci 0000:00:02.0: [1013:00b8] type 00 class 0x030000
[    0.243011] pci 0000:00:02.0: reg 0x10: [mem 0xfc000000-0xfdffffff pref]
[    0.246011] pci 0000:00:02.0: reg 0x14: [mem 0xfebe0000-0xfebe0fff]
[    0.256022] pci 0000:00:02.0: reg 0x30: [mem 0xfebc0000-0xfebcffff pref]
[    0.258215] pci 0000:00:03.0: [1af4:1000] type 00 class 0x020000
[    0.261005] pci 0000:00:03.0: reg 0x10: [io  0xc1c0-0xc1df]
[    0.263004] pci 0000:00:03.0: reg 0x14: [mem 0xfebe1000-0xfebe1fff]
[    0.272005] pci 0000:00:03.0: reg 0x30: [mem 0xfebd0000-0xfebdffff pref]
[    0.274066] pci 0000:00:04.0: [8086:100e] type 00 class 0x020000
[    0.276784] pci 0000:00:04.0: reg 0x10: [mem 0xfeb80000-0xfeb9ffff]
[    0.278000] pci 0000:00:04.0: reg 0x14: [io  0xc000-0xc03f]
[    0.278000] pci 0000:00:04.0: reg 0x30: [mem 0xfeba0000-0xfebbffff pref]
[    0.278306] pci 0000:00:05.0: [1af4:1001] type 00 class 0x010000
[    0.279000] pci 0000:00:05.0: reg 0x10: [io  0xc040-0xc07f]
[    0.279000] pci 0000:00:05.0: reg 0x14: [mem 0xfebe2000-0xfebe2fff]
[    0.279000] pci 0000:00:06.0: [1af4:1001] type 00 class 0x010000
[    0.279000] pci 0000:00:06.0: reg 0x10: [io  0xc080-0xc0bf]
[    0.279000] pci 0000:00:06.0: reg 0x14: [mem 0xfebe3000-0xfebe3fff]
[    0.284450] pci 0000:00:07.0: [1af4:1001] type 00 class 0x010000
[    0.286000] pci 0000:00:07.0: reg 0x10: [io  0xc0c0-0xc0ff]
[    0.286000] pci 0000:00:07.0: reg 0x14: [mem 0xfebe4000-0xfebe4fff]
[    0.286000] pci 0000:00:08.0: [1af4:1001] type 00 class 0x010000
[    0.286000] pci 0000:00:08.0: reg 0x10: [io  0xc100-0xc13f]
[    0.286000] pci 0000:00:08.0: reg 0x14: [mem 0xfebe5000-0xfebe5fff]
[    0.286000] pci 0000:00:09.0: [1af4:1001] type 00 class 0x010000
[    0.287735] pci 0000:00:09.0: reg 0x10: [io  0xc140-0xc17f]
[    0.290005] pci 0000:00:09.0: reg 0x14: [mem 0xfebe6000-0xfebe6fff]
[    0.299466] pci 0000:00:0a.0: [1af4:1001] type 00 class 0x010000
[    0.301000] pci 0000:00:0a.0: reg 0x10: [io  0xc180-0xc1bf]
[    0.301000] pci 0000:00:0a.0: reg 0x14: [mem 0xfebe7000-0xfebe7fff]
[    0.301063] pci 0000:00:0b.0: [8086:25ab] type 00 class 0x088000
[    0.303005] pci 0000:00:0b.0: reg 0x10: [mem 0xfebe8000-0xfebe800f]
[    0.309207] pci_bus 0000:00: on NUMA node 0
[    0.310009] acpi PNP0A03:00: ACPI _OSC support notification failed, disa=
bling PCIe ASPM
[    0.311005] acpi PNP0A03:00: Unable to request _OSC control (_OSC suppor=
t mask: 0x08)
[    0.314585] ACPI: PCI Interrupt Link [LNKA] (IRQs 5 *10 11)
[    0.316327] ACPI: PCI Interrupt Link [LNKB] (IRQs 5 *10 11)
[    0.318039] ACPI: PCI Interrupt Link [LNKC] (IRQs 5 10 *11)
[    0.319711] ACPI: PCI Interrupt Link [LNKD] (IRQs 5 10 *11)
[    0.321185] ACPI: PCI Interrupt Link [LNKS] (IRQs *9)
[    0.323486] ACPI: Enabled 16 GPEs in block 00 to 0F
[    0.324012] ACPI: \_SB_.PCI0: notify handler is installed
[    0.325086] Found 1 acpi root devices
[    0.327187] vgaarb: device added: PCI:0000:00:02.0,decodes=3Dio+mem,owns=
=3Dio+mem,locks=3Dnone
[    0.328007] vgaarb: loaded
[    0.329002] vgaarb: bridge control possible 0000:00:02.0
[    0.331031] SCSI subsystem initialized
[    0.331879] ACPI: bus type USB registered
[    0.332045] usbcore: registered new interface driver usbfs
[    0.333030] usbcore: registered new interface driver hub
[    0.334053] usbcore: registered new device driver usb
[    0.335000] pps_core: LinuxPPS API ver. 1 registered
[    0.335000] pps_core: Software ver. 5.3.6 - Copyright 2005-2007 Rodolfo =
Giometti <giometti@linux.it>
[    0.335000] PTP clock support registered
[    0.335253] wmi: Mapper loaded
[    0.335986] PCI: Using ACPI for IRQ routing
[    0.336004] PCI: pci_cache_line_size set to 64 bytes
[    0.338225] e820: reserve RAM buffer [mem 0x0009fc00-0x0009ffff]
[    0.339012] e820: reserve RAM buffer [mem 0x0fffe000-0x0fffffff]
[    0.341037] NET: Registered protocol family 8
[    0.341920] NET: Registered protocol family 20
[    0.343101] cfg80211: Calling CRDA to update world regulatory domain
[    0.344174] nfc: nfc_init: NFC Core ver 0.1
[    0.345049] NET: Registered protocol family 39
[    0.346473] HPET: 3 timers in total, 0 timers will be used for per-cpu t=
imer
[    0.347058] Switched to clocksource kvm-clock
[    0.348063] FS-Cache: Loaded
[    0.348759] pnp: PnP ACPI init
[    0.349432] ACPI: bus type PNP registered
[    0.350298] IOAPIC[0]: Set routing entry (0-8 -> 0x38 -> IRQ 8 Mode:0 Ac=
tive:0 Dest:1)
[    0.351951] pnp 00:00: Plug and Play ACPI device, IDs PNP0b00 (active)
[    0.353373] IOAPIC[0]: Set routing entry (0-1 -> 0x31 -> IRQ 1 Mode:0 Ac=
tive:0 Dest:1)
[    0.355014] pnp 00:01: Plug and Play ACPI device, IDs PNP0303 (active)
[    0.356368] IOAPIC[0]: Set routing entry (0-12 -> 0x3c -> IRQ 12 Mode:0 =
Active:0 Dest:1)
[    0.358030] pnp 00:02: Plug and Play ACPI device, IDs PNP0f13 (active)
[    0.359508] IOAPIC[0]: Set routing entry (0-6 -> 0x36 -> IRQ 6 Mode:0 Ac=
tive:0 Dest:1)
[    0.361215] pnp 00:03: [dma 2]
[    0.361922] pnp 00:03: Plug and Play ACPI device, IDs PNP0700 (active)
[    0.363359] IOAPIC[0]: Set routing entry (0-7 -> 0x37 -> IRQ 7 Mode:0 Ac=
tive:0 Dest:1)
[    0.365070] pnp 00:04: Plug and Play ACPI device, IDs PNP0400 (active)
[    0.366570] IOAPIC[0]: Set routing entry (0-4 -> 0x34 -> IRQ 4 Mode:0 Ac=
tive:0 Dest:1)
[    0.368322] pnp 00:05: Plug and Play ACPI device, IDs PNP0501 (active)
[    0.370011] pnp 00:06: Plug and Play ACPI device, IDs PNP0103 (active)
[    0.371683] pnp: PnP ACPI: found 7 devices
[    0.372519] ACPI: bus type PNP unregistered
[    0.373365] INFO_MDMA: LNW DMA Driver Version 1.1.0
[    0.379456] pci_bus 0000:00: resource 4 [io  0x0000-0x0cf7]
[    0.380639] pci_bus 0000:00: resource 5 [io  0x0d00-0xffff]
[    0.381815] pci_bus 0000:00: resource 6 [mem 0x000a0000-0x000bffff]
[    0.382809] pci_bus 0000:00: resource 7 [mem 0x80000000-0xfebfffff]
[    0.382809] NET: Registered protocol family 2
[    0.382809] TCP established hash table entries: 2048 (order: 3, 32768 by=
tes)
[    0.387124] TCP bind hash table entries: 2048 (order: 5, 131072 bytes)
[    0.388084] TCP: Hash tables configured (established 2048 bind 2048)
[    0.389972] TCP: reno registered
[    0.390633] UDP hash table entries: 128 (order: 2, 20480 bytes)
[    0.390929] UDP-Lite hash table entries: 128 (order: 2, 20480 bytes)
[    0.393255] NET: Registered protocol family 1
[    0.394146] pci 0000:00:00.0: Limiting direct PCI/PCI transfers
[    0.395345] pci 0000:00:01.0: PIIX3: Enabling Passive Release
[    0.398526] pci 0000:00:01.0: Activating ISA DMA hang workarounds
[    0.399496] pci 0000:00:02.0: Boot video device
[    0.399496] PCI: CLS 0 bytes, default 64
[    0.409406] Trying to unpack rootfs image as initramfs...
[    1.534147] debug: unmapping init [mem 0xffff88000e8d6000-0xffff88000ffe=
ffff]
[    1.776332] DMA-API: preallocated 65536 debug entries
[    1.777125] DMA-API: debugging enabled by kernel config
[    1.788847] microcode: CPU0 sig=3D0xf61, pf=3D0x1, revision=3D0x1
[    1.789753] microcode: Microcode Update Driver: v2.00 <tigran@aivazian.f=
snet.co.uk>, Peter Oruba
[    1.791065] Scanning for low memory corruption every 60 seconds
[    1.792028] camellia-x86_64: performance on this CPU would be suboptimal=
: disabling camellia-x86_64.
[    1.793526] twofish-x86_64-3way: performance on this CPU would be subopt=
imal: disabling twofish-x86_64-3way.
[    1.795199] cryptomgr_test (30) used greatest stack depth: 6792 bytes le=
ft
[    1.795999] sha1_ssse3: Neither AVX nor SSSE3 is available/usable.
[    1.795999] sha512_ssse3: Neither AVX nor SSSE3 is available/usable.
[    1.795999] AVX or AES-NI instructions are not detected.
[    1.795999] AVX instructions are not detected.
[    1.795999] AVX instructions are not detected.
[    1.795999] AVX instructions are not detected.
[    1.811791] cryptomgr_test (27) used greatest stack depth: 6616 bytes le=
ft
[    1.814189] Initializing RT-Tester: OK
[    1.814811] audit: initializing netlink socket (disabled)
[    1.815762] type=3D2000 audit(1374242598.605:1): initialized
[    1.817103] HugeTLB registered 2 MB page size, pre-allocated 0 pages
[    1.828500] VFS: Disk quotas dquot_6.5.2
[    1.829123] Dquot-cache hash table entries: 512 (order 0, 4096 bytes)
[    1.830792] DLM installed
[    1.831792] NTFS driver 2.1.30 [Flags: R/W].
[    1.832477] EFS: 1.0a - http://aeschi.ch.eu.org/efs/
[    1.833252] ROMFS MTD (C) 2007 Red Hat, Inc.
[    1.833922] QNX4 filesystem 0.2.3 registered.
[    1.834593] QNX6 filesystem 1.0.0 registered.
[    1.835455] JFS: nTxBlock =3D 1441, nTxLock =3D 11535
[    1.837449] SGI XFS with ACLs, security attributes, large block/inode nu=
mbers, debug enabled
[    1.849357] NILFS version 2 loaded
[    1.849928] OCFS2 1.5.0
[    1.850787] ocfs2 stack glue: unable to register sysctl
[    1.851628] ocfs2: Registered cluster interface user
[    1.852396] OCFS2 DLMFS 1.5.0
[    1.852990] OCFS2 User DLM kernel interface loaded
[    1.853740] OCFS2 Node Manager 1.5.0
[    1.854917] bio: create slab <bio-1> at 1
[    1.855734] Btrfs loaded
[    1.856330] msgmni has been set to 360
[    1.865488] NET: Registered protocol family 38
[    1.866266] async_tx: api initialized (async)
[    1.866994] Block layer SCSI generic (bsg) driver version 0.4 loaded (ma=
jor 252)
[    1.868220] io scheduler noop registered (default)
[    1.869028] io scheduler deadline registered
[    1.871115] test_string_helpers: Running tests...
[    1.872856] pci_hotplug: PCI Hot Plug PCI Core version: 0.5
[    1.873862] pciehp: PCI Express Hot Plug Controller Driver version: 0.4
[    1.874927] cpcihp_zt5550: ZT5550 CompactPCI Hot Plug Driver version: 0.2
[    1.876010] cpcihp_generic: Generic port I/O CompactPCI Hot Plug Driver =
version: 0.1
[    1.877251] cpcihp_generic: not configured, disabling.
[    1.878158] shpchp: Standard Hot Plug PCI Controller Driver version: 0.4
[    1.889958] cr_bllcd: INTEL CARILLO RANCH LPC not found.
[    1.890819] cr_bllcd: Carillo Ranch Backlight Driver Initialized.
[    1.892055] rivafb_setup START
[    1.892576] nvidiafb_setup START
[    1.893241] VIA Graphics Integration Chipset framebuffer 2.4 initializing
[    1.894572] vmlfb: initializing
[    1.895107] Could not find Carillo Ranch MCH device.
[    1.896076] hgafb: HGA card not detected.
[    1.896730] hgafb: probe of hgafb.0 failed with error -22
[    1.898158] cirrusfb 0000:00:02.0: Cirrus Logic chipset on PCI bus, RAM =
(4096 kB) at 0xfc000000
[    1.918547] CL Picasso4: enable CONFIG_FB_LITTLE_ENDIAN to support this =
framebuffer
[    1.919503] cirrusfb 0000:00:02.0: could not register fb device; err =3D=
 -38!
[    1.919503] cirrusfb: probe of 0000:00:02.0 failed with error -38
[    1.923108] usbcore: registered new interface driver udlfb
[    1.924221] usbcore: registered new interface driver smscufx
[    1.925883] kworker/u2:0 (107) used greatest stack depth: 6232 bytes left
[    1.927333] uvesafb: failed to execute /sbin/v86d
[    1.928304] uvesafb: make sure that the v86d helper is installed and exe=
cutable
[    1.939589] uvesafb: Getting VBE info block failed (eax=3D0x4f00, err=3D=
-2)
[    1.940580] uvesafb: vbe_init() failed with -22
[    1.940580] uvesafb: probe of uvesafb.0 failed with error -22
[    1.943469] ERST DBG: ERST support is disabled.
[    1.946562] ACPI: PCI Interrupt Link [LNKC] enabled at IRQ 11
[    1.947741] IOAPIC[0]: Set routing entry (0-11 -> 0x3b -> IRQ 11 Mode:1 =
Active:0 Dest:1)
[    1.950130] virtio-pci 0000:00:03.0: setting latency timer to 64
[    1.961296] ACPI: PCI Interrupt Link [LNKA] enabled at IRQ 10
[    1.962520] IOAPIC[0]: Set routing entry (0-10 -> 0x3a -> IRQ 10 Mode:1 =
Active:0 Dest:1)
[    1.965133] virtio-pci 0000:00:05.0: setting latency timer to 64
[    1.971692] ACPI: PCI Interrupt Link [LNKB] enabled at IRQ 10
[    1.973848] virtio-pci 0000:00:06.0: setting latency timer to 64
[    1.983172] virtio-pci 0000:00:07.0: setting latency timer to 64
[    1.998684] ACPI: PCI Interrupt Link [LNKD] enabled at IRQ 11
[    2.000885] virtio-pci 0000:00:08.0: setting latency timer to 64
[    2.007173] virtio-pci 0000:00:09.0: setting latency timer to 64
[    2.024690] virtio-pci 0000:00:0a.0: setting latency timer to 64
[    2.071108] Serial: 8250/16550 driver, 4 ports, IRQ sharing disabled
[    2.128707] serial8250: ttyS0 at I/O 0x3f8 (irq =3D 4) is a 16550A
[    2.131978] Initializing Nozomi driver 2.1d
[    2.133237] telclk_interrupt =3D 0xf non-mcpbl0010 hw.
[    2.134314] smapi::smapi_init, ERROR invalid usSmapiID
[    2.135346] mwave: tp3780i::tp3780I_InitializeBoardData: Error: SMAPI is=
 not available on this machine
[    2.138476] mwave: mwavedd::mwave_init: Error: Failed to initialize boar=
d data
[    2.139473] mwave: mwavedd::mwave_init: Error: Failed to initialize
[    2.149751] Linux agpgart interface v0.103
[    2.151161] Hangcheck: starting hangcheck timer 0.9.1 (tick is 180 secon=
ds, margin is 60 seconds).
[    2.152965] Hangcheck: Using getrawmonotonic().
[    2.153962] [drm:drm_core_init] *ERROR* Cannot create /proc/dri
[    2.155494] [drm] radeon kernel modesetting enabled.
[    2.157404] [drm:drm_proc_init] *ERROR* Cannot create /proc/dri/0
[    2.168667] [drm:drm_get_minor] *ERROR* DRM: Failed to initialize /proc/=
dri.
[    2.170307] cirrus: probe of 0000:00:02.0 failed with error -1
[    2.171923] usbcore: registered new interface driver udl
[    2.174123] Floppy drive(s): fd0 is 1.44M
[    2.180428] brd: module loaded
[    2.192023] loop: module loaded
[    2.192702] Compaq SMART2 Driver (v 2.6.0)
[    2.194310] MM: desc_per_page =3D 128
[    2.196539] nbd: registered device at major 43
[    2.214373] mtip32xx Version 1.2.6os3
[    2.215579] dummy-irq: no IRQ given.  Use irq=3DN
[    2.216657] Phantom Linux Driver, version n0.9.8, init OK
[    2.218303] Guest personality initialized and is inactive
[    2.219628] VMCI host device registered (name=3Dvmci, major=3D10, minor=
=3D56)
[    2.221068] Initialized host personality
[    2.222065] Driver for timberdale has been successfully registered.
[    2.223892] usbcore: registered new interface driver viperboard
[    2.225157] usbcore: registered new interface driver pn533
[    2.226946] Loading iSCSI transport class v2.0-870.
[    2.228517] rdac: device handler registered
[    2.230457] hp_sw: device handler registered
[    2.231355] emc: device handler registered
[    2.232562] fnic: Cisco FCoE HBA Driver, ver 1.5.0.22
[    2.233763] fnic: Successfully Initialized Trace Buffer
[    2.234967] bnx2fc: Broadcom NetXtreme II FCoE Driver bnx2fc v1.0.14 (Ma=
r 08, 2013)
[    2.237090] FDC 0 is a S82078B
[    2.238828] iscsi: registered transport (tcp)
[    2.239993] Loading Adaptec I2O RAID: Version 2.4 Build 5go
[    2.241103] Detecting Adaptec I2O RAID controllers...
[    2.242303] aic94xx: Adaptec aic94xx SAS/SATA driver version 1.0.3 loaded
[    2.243858] isci: Intel(R) C600 SAS Controller Driver - version 1.1.0
[    2.245498] scsi: <fdomain> Detection failed (no card)
[    2.246693] iscsi: registered transport (qla4xxx)
[    2.247665] QLogic iSCSI HBA Driver
[    2.248403] csiostor: Chelsio FCoE driver 1.0.0
[    2.249828] DC390: clustering now enabled by default. If you get problem=
s load
[    2.251312]        with "disable_clustering=3D1" and report to maintaine=
rs
[    2.252823] megasas: 06.600.18.00-rc1 Wed. May. 15 17:00:00 PDT 2013
[    2.254277] GDT-HA: Storage RAID Controller Driver. Version: 3.05
[    2.255673] 3ware Storage Controller device driver for Linux v1.26.02.00=
3.
[    2.257186] 3ware 9000 Storage Controller device driver for Linux v2.26.=
02.014.
[    2.258853] LSI 3ware SAS/SATA-RAID Controller device driver for Linux v=
3.26.02.000.
[    2.260493] RocketRAID 3xxx/4xxx Controller driver v1.8
[    2.261373] stex: Promise SuperTrak EX Driver version: 4.6.0000.4
[    2.262927] libcxgbi:libcxgbi_init_module: tag itt 0x1fff, 13 bits, age =
0xf, 4 bits.
[    2.264653] libcxgbi:ddp_setup_host_page_size: system PAGE 4096, ddp idx=
 0.
[    2.266140] Chelsio T3 iSCSI Driver cxgb3i v2.0.0 (Jun. 2010)
[    2.267137] iscsi: registered transport (cxgb3i)
[    2.267137] Broadcom NetXtreme II iSCSI Driver bnx2i v2.7.2.2 (Apr 25, 2=
012)
[    2.269885] iscsi: registered transport (bnx2i)
[    2.270854] iscsi: registered transport (be2iscsi)
[    2.270854] In beiscsi_module_init, tt=3Dffffffff82c29ba0
[    2.270854] VMware PVSCSI driver - version 1.0.2.0-k
[    2.270854] st: Version 20101219, fixed bufsize 32768, s/g segs 256
[    2.270854] osst :I: Tape driver with OnStream support version 0.99.4
[    2.270854] osst :I: $Id: osst.c,v 1.73 2005/01/01 21:13:34 wriede Exp $
[    2.279204] Rounding down aligned max_sectors from 4294967295 to 4294967=
288
[    2.284852] bonding: Ethernet Channel Bonding Driver: v3.7.1 (April 27, =
2011)
[    2.289373] libphy: Fixed MDIO Bus: probed
[    2.291408] virtio-pci 0000:00:03.0: irq 40 for MSI/MSI-X
[    2.292564] virtio-pci 0000:00:03.0: irq 41 for MSI/MSI-X
[    2.293708] virtio-pci 0000:00:03.0: irq 42 for MSI/MSI-X
[    2.296473] arcnet loaded.
[    2.297055] arcnet: RFC1051 "simple standard" (`s') encapsulation suppor=
t loaded.
[    2.298592] arcnet: RIM I (entirely mem-mapped) support
[    2.299621] E-mail me if you actually test the RIM I driver, please!
[    2.300867] Given: node 00h, shmem 0h, irq 0
[    2.301704] No autoprobe for RIM I; you must specify the shmem and irq!
[    2.301864] arcnet: COM20020 PCI support
[    2.304457] vcan: Virtual CAN interface driver
[    2.305367] CAN device driver interface
[    2.306157] usbcore: registered new interface driver ems_usb
[    2.307302] usbcore: registered new interface driver esd_usb2
[    2.308620] usbcore: registered new interface driver kvaser_usb
[    2.309854] usbcore: registered new interface driver usb_8dev
[    2.310829] sja1000 CAN netdevice driver
[    2.310829] sja1000_isa: insufficient parameters supplied
[    2.313347] cc770: CAN netdevice driver
[    2.314149] cc770_isa: insufficient parameters supplied
[    2.315756] pcnet32: pcnet32.c:v1.35 21.Apr.2008 tsbogend@alpha.franken.=
de
[    2.317346] cnic: Broadcom NetXtreme II CNIC Driver cnic v2.5.16 (Dec 05=
, 2012)
[    2.318903] bnx2x: Broadcom NetXtreme II 5771x/578xx 10/20-Gigabit Ether=
net Driver bnx2x 1.78.17-0 (2013/04/11)
[    2.321537] dmfe: Davicom DM9xxx net driver, version 1.36.4 (2002-01-17)
[    2.322902] v1.01-e (2.4 port) Sep-11-2006  Donald Becker <becker@scyld.=
com>
[    2.322902]   http://www.scyld.com/network/drivers.html
[    2.325507] uli526x: ULi M5261/M5263 net driver, version 0.9.3 (2005-7-2=
9)
[    2.326331] jme: JMicron JMC2XX ethernet driver version 1.0.8
[    2.328374] pch_gbe: EG20T PCH Gigabit Ethernet Driver - version 1.01
[    2.329869] QLogic 1/10 GbE Converged/Intelligent Ethernet Driver v5.2.44
[    2.331414] QLogic/NetXen Network Driver v4.0.81
[    2.332726] tehuti: Tehuti Networks(R) Network Driver, 7.29.3
[    2.333919] tehuti: Options: hw_csum=20
[    2.334852] mkiss: AX.25 Multikiss, Hans Albas PE1AYX
[    2.335914] YAM driver version 0.8 by F1OAT/F6FBB
[    2.338192] baycom_ser_hdx: (C) 1996-2000 Thomas Sailer, HB9JNX/AE4WA
[    2.338192] baycom_ser_hdx: version 0.10
[    2.351255] hdlcdrv: (C) 1996-2000 Thomas Sailer HB9JNX/AE4WA
[    2.352452] hdlcdrv: version 0.8
[    2.353132] SLIP: version 0.8.4-NET3.019-NEWTTY (dynamic channels, max=
=3D256) (6 bit encapsulation enabled).
[    2.355108] CSLIP: code copyright 1989 Regents of the University of Cali=
fornia.
[    2.356106] hdlc: HDLC support module revision 1.22
[    2.357848] ipw2100: Intel(R) PRO/Wireless 2100 Network Driver, git-1.2.2
[    2.359310] ipw2100: Copyright(c) 2003-2006 Intel Corporation
[    2.369307] libipw: 802.11 data/management/control stack, git-1.1.13
[    2.370629] libipw: Copyright (C) 2004-2005 Intel Corporation <jketreno@=
linux.intel.com>
[    2.372295] airo(): Probing for PCI adapters
[    2.373201] airo(): Finished probing for PCI adapters
[    2.373292] Loaded prism54 driver, version 1.2
[    2.375960] Broadcom 43xx driver loaded [ Features: PMNLS ]
[    2.377136] Broadcom 43xx-legacy driver loaded [ Features: PLID ]
[    2.378478] usbcore: registered new interface driver rtl8187
[    2.389436] usbcore: registered new interface driver rtl8192cu
[    2.390864] usbcore: registered new interface driver rndis_wlan
[    2.392195] usbcore: registered new interface driver zd1201
[    2.393455] usbcore: registered new interface driver lbtf_usb
[    2.394793] iwl3945: Intel(R) PRO/Wireless 3945ABG/BG Network Connection=
 driver for Linux, in-tree:ds
[    2.396666] iwl3945: Copyright(c) 2003-2011 Intel Corporation
[    2.398037] usbcore: registered new interface driver ath6kl_usb
[    2.399311] usbcore: registered new interface driver ar5523
[    2.401036] usbcore: registered new interface driver brcmfmac
[    2.402935] ieee802154hardmac ieee802154hardmac: Added ieee802154 HardMA=
C hardware
[    2.404857] ieee802154fakelb ieee802154fakelb: added ieee802154 hardware
[    2.406415] VMware vmxnet3 virtual NIC driver - version 1.1.30.0-k-NAPI
[    2.407951] usbcore: registered new interface driver kaweth
[    2.408896] pegasus: v0.9.3 (2013/04/25), Pegasus/Pegasus II USB Etherne=
t driver
[    2.408896] usbcore: registered new interface driver pegasus
[    2.408896] usbcore: registered new interface driver rtl8150
[    2.408896] hso: drivers/net/usb/hso.c: Option Wireless
[    2.414745] usbcore: registered new interface driver hso
[    2.416155] usbcore: registered new interface driver ax88179_178a
[    2.417383] usbcore: registered new interface driver cdc_ether
[    2.418595] usbcore: registered new interface driver r815x
[    2.419751] usbcore: registered new interface driver dm9601
[    2.420723] usbcore: registered new interface driver smsc75xx
[    2.422254] usbcore: registered new interface driver smsc95xx
[    2.423490] usbcore: registered new interface driver gl620a
[    2.424690] usbcore: registered new interface driver net1080
[    2.425839] usbcore: registered new interface driver plusb
[    2.426813] usbcore: registered new interface driver rndis_host
[    2.428128] usbcore: registered new interface driver cdc_subset
[    2.429482] usbcore: registered new interface driver zaurus
[    2.430666] usbcore: registered new interface driver cdc_phonet
[    2.431901] usbcore: registered new interface driver sierra_net
[    2.432878] usbcore: registered new interface driver cx82310_eth
[    2.432878] usbcore: registered new interface driver cdc_ncm
[    2.432878] usbcore: registered new interface driver lg-vl600
[    2.432878] usbcore: registered new interface driver qmi_wwan
[    2.438106] usbcore: registered new interface driver cdc_mbim
[    2.438995] fore200e: FORE Systems 200E-series ATM driver - version 0.3e
[    2.438995] idt77252_init: at ffffffff82d59205
[    2.438995] Solos PCI Driver Version 1.04
[    2.438995] adummy: version 1.0
[    2.444314] uhci_hcd: USB Universal Host Controller Interface driver
[    2.446136] usbcore: registered new interface driver cdc_acm
[    2.446792] cdc_acm: USB Abstract Control Model driver for USB modems an=
d ISDN adapters
[    2.446792] usbcore: registered new interface driver usblp
[    2.446792] usbcore: registered new interface driver cdc_wdm
[    2.451293] usbcore: registered new interface driver usbtmc
[    2.452418] usbcore: registered new interface driver usb-storage
[    2.453618] usbcore: registered new interface driver ums-alauda
[    2.454806] usbcore: registered new interface driver ums-datafab
[    2.455783] usbcore: registered new interface driver ums-freecom
[    2.455783] usbcore: registered new interface driver ums-isd200
[    2.455783] usbcore: registered new interface driver ums-karma
[    2.455783] usbcore: registered new interface driver ums-realtek
[    2.460940] usbcore: registered new interface driver ums-sddr09
[    2.462309] usbcore: registered new interface driver ums-sddr55
[    2.463557] usbcore: registered new interface driver ums-usbat
[    2.464801] usbcore: registered new interface driver mdc800
[    2.465768] mdc800: v0.7.5 (30/10/2000):USB Driver for Mustek MDC800 Dig=
ital Camera
[    2.467620] usbcore: registered new interface driver microtekX6
[    2.468932] usbcore: registered new interface driver usbserial
[    2.469860] usbcore: registered new interface driver belkin_sa
[    2.471567] usbserial: USB Serial support registered for Belkin / Peraco=
m / GoHubs USB Serial Adapter
[    2.473394] usbcore: registered new interface driver ch341
[    2.474366] usbserial: USB Serial support registered for ch341-uart
[    2.474366] usbcore: registered new interface driver cyberjack
[    2.476940] usbserial: USB Serial support registered for Reiner SCT Cybe=
rjack USB card reader
[    2.478907] usbcore: registered new interface driver cypress_m8
[    2.480152] usbserial: USB Serial support registered for DeLorme Earthma=
te USB
[    2.481663] usbserial: USB Serial support registered for HID->COM RS232 =
Adapter
[    2.483191] usbserial: USB Serial support registered for Nokia CA-42 V2 =
Adapter
[    2.484808] usbcore: registered new interface driver usb_debug
[    2.486035] usbserial: USB Serial support registered for debug
[    2.487404] usbcore: registered new interface driver digi_acceleport
[    2.489871] usbserial: USB Serial support registered for Digi 2 port USB=
 adapter
[    2.490838] usbserial: USB Serial support registered for Digi 4 port USB=
 adapter
[    2.492936] usbcore: registered new interface driver io_edgeport
[    2.493795] usbserial: USB Serial support registered for Edgeport 2 port=
 adapter
[    2.493795] usbserial: USB Serial support registered for Edgeport 4 port=
 adapter
[    2.493795] usbserial: USB Serial support registered for Edgeport 8 port=
 adapter
[    2.499023] usbserial: USB Serial support registered for EPiC device
[    2.500807] usbcore: registered new interface driver empeg
[    2.501967] usbserial: USB Serial support registered for empeg
[    2.503190] usbcore: registered new interface driver f81232
[    2.504451] usbserial: USB Serial support registered for f81232
[    2.505693] usbcore: registered new interface driver funsoft
[    2.506884] usbserial: USB Serial support registered for funsoft
[    2.507856] usbcore: registered new interface driver hp4x
[    2.509275] usbserial: USB Serial support registered for hp4X
[    2.510607] usbcore: registered new interface driver ir_usb
[    2.511748] usbserial: USB Serial support registered for IR Dongle
[    2.512718] usbcore: registered new interface driver keyspan
[    2.512718] usbserial: USB Serial support registered for Keyspan - (with=
out firmware)
[    2.515835] usbserial: USB Serial support registered for Keyspan 1 port =
adapter
[    2.517301] usbserial: USB Serial support registered for Keyspan 2 port =
adapter
[    2.519055] usbserial: USB Serial support registered for Keyspan 4 port =
adapter
[    2.520024] usbcore: registered new interface driver kl5kusb105
[    2.520024] usbserial: USB Serial support registered for KL5KUSB105D / P=
almConnect
[    2.520024] usbcore: registered new interface driver kobil_sct
[    2.524699] usbserial: USB Serial support registered for KOBIL USB smart=
 card terminal
[    2.526344] usbcore: registered new interface driver mct_u232
[    2.527317] usbserial: USB Serial support registered for MCT U232
[    2.528931] usbcore: registered new interface driver metro_usb
[    2.530109] usbserial: USB Serial support registered for Metrologic USB =
to Serial
[    2.531604] usbcore: registered new interface driver mos7720
[    2.532747] usbserial: USB Serial support registered for Moschip 2 port =
adapter
[    2.533719] usbcore: registered new interface driver mos7840
[    2.533719] usbserial: USB Serial support registered for Moschip 7840/78=
20 USB Serial Driver
[    2.533719] usbcore: registered new interface driver moto_modem
[    2.533719] usbserial: USB Serial support registered for moto-modem
[    2.533719] usbcore: registered new interface driver navman
[    2.533719] usbserial: USB Serial support registered for navman
[    2.533719] usbcore: registered new interface driver opticon
[    2.533719] usbserial: USB Serial support registered for opticon
[    2.533719] usbcore: registered new interface driver pl2303
[    2.533719] usbserial: USB Serial support registered for pl2303
[    2.533719] usbcore: registered new interface driver qcserial
[    2.533719] usbserial: USB Serial support registered for Qualcomm USB mo=
dem
[    2.533719] usbcore: registered new interface driver quatech2
[    2.533719] usbserial: USB Serial support registered for Quatech 2nd gen=
 USB to Serial Driver
[    2.533719] usbcore: registered new interface driver safe_serial
[    2.533719] usbserial: USB Serial support registered for safe_serial
[    2.533719] usbcore: registered new interface driver ssu100
[    2.533719] usbserial: USB Serial support registered for Quatech SSU-100=
 USB to Serial Driver
[    2.558998] usbcore: registered new interface driver symbolserial
[    2.559883] usbserial: USB Serial support registered for symbol
[    2.559883] usbcore: registered new interface driver ti_usb_3410_5052
[    2.562841] usbserial: USB Serial support registered for TI USB 3410 1 p=
ort adapter
[    2.564426] usbserial: USB Serial support registered for TI USB 5052 2 p=
ort adapter
[    2.566087] usbcore: registered new interface driver whiteheat
[    2.566985] usbserial: USB Serial support registered for Connect Tech - =
WhiteHEAT - (prerenumeration)
[    2.566985] usbserial: USB Serial support registered for Connect Tech - =
WhiteHEAT
[    2.566985] usbcore: registered new interface driver xsens_mt
[    2.566985] usbserial: USB Serial support registered for xsens_mt
[    2.566985] usbcore: registered new interface driver zte_ev
[    2.574276] usbserial: USB Serial support registered for zte_ev
[    2.575248] usbcore: registered new interface driver adutux
[    2.576765] usbcore: registered new interface driver appledisplay
[    2.578003] usbcore: registered new interface driver cypress_cy7c63
[    2.579369] usbcore: registered new interface driver cytherm
[    2.580644] usbcore: registered new interface driver emi62 - firmware lo=
ader
[    2.582119] usbcore: registered new interface driver idmouse
[    2.583091] usbcore: registered new interface driver iowarrior
[    2.583091] usbcore: registered new interface driver usblcd
[    2.585790] usbcore: registered new interface driver usbled
[    2.586961] usbcore: registered new interface driver legousbtower
[    2.588261] usbcore: registered new interface driver rio500
[    2.589399] usbcore: registered new interface driver usbtest
[    2.599438] usbcore: registered new interface driver trancevibrator
[    2.600334] usbcore: registered new interface driver usbsevseg
[    2.601915] usbcore: registered new interface driver speedtch
[    2.603146] usbcore: registered new interface driver ueagle-atm
[    2.604333] xusbatm: malformed module parameters
[    2.606077] dummy_hcd dummy_hcd.0: USB Host+Gadget Emulator, driver 02 M=
ay 2005
[    2.607544] dummy_hcd dummy_hcd.0: Dummy host controller
[    2.608693] dummy_hcd dummy_hcd.0: new USB bus registered, assigned bus =
number 1
[    2.620456] hub 1-0:1.0: USB hub found
[    2.621678] hub 1-0:1.0: 1 port detected
[    2.623567] using random self ethernet address
[    2.624483] using random host ethernet address
[    2.625507] using random self ethernet address
[    2.626420] using random host ethernet address
[    2.627731] usb0: HOST MAC 4a:86:50:5e:6d:38
[    2.628636] usb0: MAC 6a:38:26:11:73:46
[    2.633828] g_cdc gadget: CDC Composite Gadget, version: King Kamehameha=
 Day 2008
[    2.635318] g_cdc gadget: g_cdc ready
[    2.636318] i8042: PNP: PS/2 Controller [PNP0303:KBD,PNP0f13:MOU] at 0x6=
0,0x64 irq 1,12
[    2.648869] serio: i8042 KBD port at 0x60,0x64 irq 1
[    2.650133] serio: i8042 AUX port at 0x60,0x64 irq 12
[    2.651751] mousedev: PS/2 mouse device common for all mice
[    2.653739] input: AT Translated Set 2 keyboard as /devices/platform/i80=
42/serio0/input/input0
[    2.655705] I2O subsystem v1.325
[    2.656367] i2o: max drivers =3D 8
[    2.657248] I2O Configuration OSM v1.323
[    2.658061] I2O SCSI Peripheral OSM v1.316
[    2.658920] I2O ProcFS OSM v1.316
[    2.660246] piix4_smbus 0000:00:01.3: SMBus Host Controller at 0xb100, r=
evision 0
[    2.671159] i2c-parport-light: adapter type unspecified
[    2.672368] usbcore: registered new interface driver i2c-tiny-usb
[    2.673792] pps pps0: new PPS source ktimer
[    2.674629] pps pps0: ktimer PPS source registered
[    2.675589] pps_ldisc: PPS line discipline registered
[    2.676631] Driver for 1-wire Dallas network protocol.
[    2.678315] 1-Wire driver for the DS2760 battery monitor  chip  - (c) 20=
04-2005, Szabolcs Gyurko
[    2.690148] power_supply test_ac: uevent
[    2.690939] power_supply test_ac: POWER_SUPPLY_NAME=3Dtest_ac
[    2.690974] power_supply test_ac: prop ONLINE=3D1
[    2.690974] power_supply test_ac: power_supply_changed
[    2.690974] power_supply test_ac: power_supply_changed_work
[    2.690974] power_supply test_ac: power_supply_update_gen_leds 1
[    2.696775] power_supply test_ac: uevent
[    2.697560] power_supply test_ac: POWER_SUPPLY_NAME=3Dtest_ac
[    2.698686] power_supply test_ac: prop ONLINE=3D1
[    2.699783] power_supply test_battery: uevent
[    2.706674] power_supply test_battery: POWER_SUPPLY_NAME=3Dtest_battery
[    2.707950] power_supply test_battery: prop STATUS=3DDischarging
[    2.709145] power_supply test_battery: prop CHARGE_TYPE=3DFast
[    2.710267] power_supply test_battery: prop HEALTH=3DGood
[    2.711314] power_supply test_battery: prop PRESENT=3D1
[    2.712324] power_supply test_battery: prop TECHNOLOGY=3DLi-ion
[    2.713469] power_supply test_battery: prop CHARGE_FULL_DESIGN=3D100
[    2.719406] power_supply test_battery: prop CHARGE_FULL=3D100
[    2.720400] power_supply test_battery: prop CHARGE_NOW=3D50
[    2.721581] power_supply test_battery: prop CAPACITY=3D50
[    2.722628] power_supply test_battery: prop CAPACITY_LEVEL=3DNormal
[    2.723842] power_supply test_battery: prop TIME_TO_EMPTY_AVG=3D3600
[    2.729355] power_supply test_battery: prop TIME_TO_FULL_NOW=3D3600
[    2.730565] power_supply test_battery: prop MODEL_NAME=3DTest battery
[    2.731810] power_supply test_battery: prop MANUFACTURER=3DLinux
[    2.732805] power_supply test_battery: prop SERIAL_NUMBER=3D3.11.0-rc1-n=
ext-20130719
[    2.732805] power_supply test_battery: prop TEMP=3D26
[    2.732805] power_supply test_battery: prop VOLTAGE_NOW=3D3300
[    2.732805] power_supply test_battery: power_supply_changed
[    2.732805] power_supply test_battery: power_supply_changed_work
[    2.732805] power_supply test_battery: power_supply_update_bat_leds 2
[    2.732805] power_supply test_battery: uevent
[    2.732805] power_supply test_battery: POWER_SUPPLY_NAME=3Dtest_battery
[    2.732805] power_supply test_battery: prop STATUS=3DDischarging
[    2.753214] power_supply test_usb: uevent
[    2.759004] power_supply test_usb: POWER_SUPPLY_NAME=3Dtest_usb
[    2.760147] power_supply test_usb: prop ONLINE=3D1
[    2.761085] power_supply test_usb: power_supply_changed
[    2.762940] power_supply test_battery: prop CHARGE_TYPE=3DFast
[    2.764077] power_supply test_battery: prop HEALTH=3DGood
[    2.769384] power_supply test_battery: prop PRESENT=3D1
[    2.770326] power_supply test_battery: prop TECHNOLOGY=3DLi-ion
[    2.770326] power_supply test_battery: prop CHARGE_FULL_DESIGN=3D100
[    2.770326] power_supply test_battery: prop CHARGE_FULL=3D100
[    2.770326] power_supply test_battery: prop CHARGE_NOW=3D50
[    2.770326] power_supply test_battery: prop CAPACITY=3D50
[    2.770326] power_supply test_battery: prop CAPACITY_LEVEL=3DNormal
[    2.782203] power_supply test_battery: prop TIME_TO_EMPTY_AVG=3D3600
[    2.783193] power_supply test_battery: prop TIME_TO_FULL_NOW=3D3600
[    2.783193] power_supply test_battery: prop MODEL_NAME=3DTest battery
[    2.785727] power_supply test_battery: prop MANUFACTURER=3DLinux
[    2.786822] power_supply test_battery: prop SERIAL_NUMBER=3D3.11.0-rc1-n=
ext-20130719
[    2.798293] power_supply test_battery: prop TEMP=3D26
[    2.799240] power_supply test_battery: prop VOLTAGE_NOW=3D3300
[    2.800399] power_supply test_usb: power_supply_changed_work
[    2.801458] power_supply test_usb: power_supply_update_gen_leds 1
[    2.802702] power_supply test_usb: uevent
[    2.803479] power_supply test_usb: POWER_SUPPLY_NAME=3Dtest_usb
[    2.804580] power_supply test_usb: prop ONLINE=3D1
[    2.839750] w83793: Detection failed at check vendor id
[    2.846743] w83793: Detection failed at check vendor id
[    2.853746] w83793: Detection failed at check vendor id
[    2.860744] w83793: Detection failed at check vendor id
[    2.865746] i2c i2c-0: Detection of w83781d chip failed at step 3
[    2.870745] i2c i2c-0: Detection of w83781d chip failed at step 3
[    2.875744] i2c i2c-0: Detection of w83781d chip failed at step 3
[    2.880745] i2c i2c-0: Detection of w83781d chip failed at step 3
[    2.885744] i2c i2c-0: Detection of w83781d chip failed at step 3
[    2.890745] i2c i2c-0: Detection of w83781d chip failed at step 3
[    2.895744] i2c i2c-0: Detection of w83781d chip failed at step 3
[    2.900746] i2c i2c-0: Detection of w83781d chip failed at step 3
[    2.921747] i2c i2c-0: ADM1025 detection failed at 0x2c
[    2.926745] i2c i2c-0: ADM1025 detection failed at 0x2d
[    2.931745] i2c i2c-0: ADM1025 detection failed at 0x2e
[    2.938951] i2c i2c-0: Detecting device at 0,0x2c with COMPANY: 0xff and=
 VERSTEP: 0xff
[    2.940482] i2c i2c-0: Autodetecting device at 0,0x2c...
[    2.941473] i2c i2c-0: Autodetection failed
[    2.947749] i2c i2c-0: Detecting device at 0,0x2d with COMPANY: 0xff and=
 VERSTEP: 0xff
[    2.949238] i2c i2c-0: Autodetecting device at 0,0x2d...
[    2.950247] i2c i2c-0: Autodetection failed
[    2.956745] i2c i2c-0: Detecting device at 0,0x2e with COMPANY: 0xff and=
 VERSTEP: 0xff
[    2.958199] i2c i2c-0: Autodetecting device at 0,0x2e...
[    2.958915] i2c i2c-0: Autodetection failed
[    2.962749] i2c i2c-0: detect fail: address match, 0x2c
[    2.966744] i2c i2c-0: detect fail: address match, 0x2d
[    2.970745] i2c i2c-0: detect fail: address match, 0x2e
[    2.974745] i2c i2c-0: detect fail: address match, 0x2f
[    3.013749] applesmc: supported laptop not found!
[    3.014371] applesmc: driver init failed (ret=3D-19)!
[    3.040756] usb 1-1: new high-speed USB device number 2 using dummy_hcd
[    3.084821] f71882fg: Not a Fintek device
[    3.085423] f71882fg: Not a Fintek device
[    3.117749]  (null): Unknown chip type, skipping
[    3.121746]  (null): Unknown chip type, skipping
[    3.164735] g_cdc gadget: high-speed config #1: CDC Composite (ECM + ACM)
[    3.169185] cdc_ether 1-1:1.0 usb1: register 'cdc_ether' at usb-dummy_hc=
d.0-1, CDC Ethernet Device, 4a:86:50:5e:6d:38
[    3.171893] cdc_acm 1-1:1.2: This device cannot do calls on its own. It =
is not a modem.
[    3.173047] cdc_acm 1-1:1.2: ttyACM0: USB ACM device
[    3.243754] i2c i2c-0: Detecting device at 0x2c with COMPANY: 0xff and V=
ERSTEP: 0xff
[    3.244817] i2c i2c-0: Autodetection failed: unsupported version
[    3.250744] i2c i2c-0: Detecting device at 0x2d with COMPANY: 0xff and V=
ERSTEP: 0xff
[    3.251688] i2c i2c-0: Autodetection failed: unsupported version
[    3.257745] i2c i2c-0: Detecting device at 0x2e with COMPANY: 0xff and V=
ERSTEP: 0xff
[    3.258782] i2c i2c-0: Autodetection failed: unsupported version
[    3.268751] i2c i2c-0: Unsupported chip at 0x18 (man_id=3D0xFF, chip_id=
=3D0xFF)
[    3.278760] i2c i2c-0: Unsupported chip at 0x19 (man_id=3D0xFF, chip_id=
=3D0xFF)
[    3.289746] i2c i2c-0: Unsupported chip at 0x1a (man_id=3D0xFF, chip_id=
=3D0xFF)
[    3.299747] i2c i2c-0: Unsupported chip at 0x29 (man_id=3D0xFF, chip_id=
=3D0xFF)
[    3.309752] i2c i2c-0: Unsupported chip at 0x2a (man_id=3D0xFF, chip_id=
=3D0xFF)
[    3.320743] i2c i2c-0: Unsupported chip at 0x2b (man_id=3D0xFF, chip_id=
=3D0xFF)
[    3.330747] i2c i2c-0: Unsupported chip at 0x48 (man_id=3D0xFF, chip_id=
=3D0xFF)
[    3.340744] i2c i2c-0: Unsupported chip at 0x49 (man_id=3D0xFF, chip_id=
=3D0xFF)
[    3.350747] i2c i2c-0: Unsupported chip at 0x4a (man_id=3D0xFF, chip_id=
=3D0xFF)
[    3.353845] tsc: Refined TSC clocksource calibration: 2693.506 MHz
[    3.360743] i2c i2c-0: Unsupported chip at 0x4b (man_id=3D0xFF, chip_id=
=3D0xFF)
[    3.370749] i2c i2c-0: Unsupported chip at 0x4c (man_id=3D0xFF, chip_id=
=3D0xFF)
[    3.381744] i2c i2c-0: Unsupported chip at 0x4d (man_id=3D0xFF, chip_id=
=3D0xFF)
[    3.391748] i2c i2c-0: Unsupported chip at 0x4e (man_id=3D0xFF, chip_id=
=3D0xFF)
[    3.401743] i2c i2c-0: Unsupported chip at 0x4f (man_id=3D0xFF, chip_id=
=3D0xFF)
[    3.406742] i2c i2c-0: detect failed, bad manufacturer id 0xff!
[    3.410749] i2c i2c-0: detect failed, bad manufacturer id 0xff!
[    3.414746] i2c i2c-0: detect failed, bad manufacturer id 0xff!
[    3.455748] i2c i2c-0: MAX1619 detection failed at 0x18
[    3.463750] i2c i2c-0: MAX1619 detection failed at 0x19
[    3.471745] i2c i2c-0: MAX1619 detection failed at 0x1a
[    3.479747] i2c i2c-0: MAX1619 detection failed at 0x29
[    3.487748] i2c i2c-0: MAX1619 detection failed at 0x2a
[    3.495745] i2c i2c-0: MAX1619 detection failed at 0x2b
[    3.503749] i2c i2c-0: MAX1619 detection failed at 0x4c
[    3.511745] i2c i2c-0: MAX1619 detection failed at 0x4d
[    3.519747] i2c i2c-0: MAX1619 detection failed at 0x4e
[    3.576748] i2c i2c-0: SMSC47M192 detection failed at 0x2c
[    3.582752] i2c i2c-0: SMSC47M192 detection failed at 0x2d
[    3.584741] i2c i2c-0: amc6821_detect called.
[    3.588747] i2c i2c-0: amc6821: detection failed at 0x18.
[    3.590741] i2c i2c-0: amc6821_detect called.
[    3.594746] i2c i2c-0: amc6821: detection failed at 0x19.
[    3.596740] i2c i2c-0: amc6821_detect called.
[    3.600745] i2c i2c-0: amc6821: detection failed at 0x1a.
[    3.602743] i2c i2c-0: amc6821_detect called.
[    3.606745] i2c i2c-0: amc6821: detection failed at 0x2c.
[    3.608742] i2c i2c-0: amc6821_detect called.
[    3.612749] i2c i2c-0: amc6821: detection failed at 0x2d.
[    3.614740] i2c i2c-0: amc6821_detect called.
[    3.618747] i2c i2c-0: amc6821: detection failed at 0x2e.
[    3.620739] i2c i2c-0: amc6821_detect called.
[    3.624749] i2c i2c-0: amc6821: detection failed at 0x4c.
[    3.626739] i2c i2c-0: amc6821_detect called.
[    3.630745] i2c i2c-0: amc6821: detection failed at 0x4d.
[    3.632744] i2c i2c-0: amc6821_detect called.
[    3.636745] i2c i2c-0: amc6821: detection failed at 0x4e.
[    3.641744] i2c i2c-0: w83l785ts: Read 0xff from register 0x40.
[    3.642671] i2c i2c-0: W83L785TS-S detection failed at 0x2e
[    3.647745] i2c i2c-0: W83L786NG detection failed at 0x2e
[    3.652750] i2c i2c-0: W83L786NG detection failed at 0x2f
[    3.653683] intel_powerclamp: Intel powerclamp does not run on family 15=
 model 6
[    3.654874] md: linear personality registered for level -1
[    3.655728] md: raid10 personality registered for level 10
[    3.655825] md: raid6 personality registered for level 6
[    3.655825] md: raid5 personality registered for level 5
[    3.655825] md: raid4 personality registered for level 4
[    3.659053] md: faulty personality registered for level -5
[    3.660049] device-mapper: ioctl: 4.25.0-ioctl (2013-06-26) initialised:=
 dm-devel@redhat.com
[    3.660049] device-mapper: multipath: version 1.5.1 loaded
[    3.660049] device-mapper: multipath round-robin: version 1.0.0 loaded
[    3.660049] device-mapper: multipath queue-length: version 0.1.0 loaded
[    3.665087] device-mapper: dm-log-userspace: version 1.1.0 loaded
[    3.666079] device-mapper: cache-policy-mq: version 1.0.0 loaded
[    3.667025] device-mapper: cache cleaner: version 1.0.0 loaded
[    3.667932] gigaset: Driver for Gigaset 307x
[    3.678770] gigaset: no ISDN subsystem interface
[    3.680198] usbcore: registered new interface driver bas_gigaset
[    3.681461] bas_gigaset: USB Driver for Gigaset 307x
[    3.682686] sdhci: Secure Digital Host Controller Interface driver
[    3.683962] sdhci: Copyright(c) Pierre Ossman
[    3.684932] wbsd: Winbond W83L51xD SD/MMC card interface driver
[    3.686149] wbsd: Copyright(c) Pierre Ossman
[    3.689366] usbcore: registered new interface driver ushc
[    3.690946] leds_ss4200: no LED devices found
[    6.309754]  (null): enodev DEV ADDR =3D 0xFF
[    6.310395] ledtrig-cpu: registered to indicate activity on CPUs
[    6.311854] dcdbas dcdbas: Dell Systems Management Base Driver (version =
5.6.0-3.2)
[    6.313448] hidraw: raw HID events driver (C) Jiri Kosina
[    6.316818] usbcore: registered new interface driver usbhid
[    6.317616] usbhid: USB HID core driver
[    6.318205] asus_wmi: Asus Management GUID not found
[    6.319441] asus_wmi: Management GUID not found
[    6.320475] msi_laptop: Brightness ignored, must be controlled by ACPI v=
ideo driver
[    6.322537] compal_laptop: Motherboard not recognized (You could try the=
 module's force-parameter)
[    6.330289] acer_wmi: Acer Laptop ACPI-WMI Extras
[    6.331284] acer_wmi: No or unsupported WMI interface, unable to load
[    6.331284] acerhdf: Acer Aspire One Fan driver, v.0.5.26
[    6.334049] acerhdf: unknown (unsupported) BIOS version Bochs/Bochs/Boch=
s, please report, aborting!
[    6.338283] hdaps: supported laptop not found!
[    6.339193] hdaps: driver init failed (ret=3D-19)!
[    6.348650] fujitsu_tablet: Unknown (using defaults)
[    6.349863] msi_wmi: This machine doesn't have neither MSI-hotkeys nor b=
acklight through WMI
[    6.351915] intel_oaktrail: Platform not recognized (You could try the m=
odule's force-parameter) fake-fmc-carrier: mezzanine 0
[    6.355272]       Manufacturer: fake-vendor
[    6.356235]       Product name: fake-design-for-testing
[    6.357517] fmc fake-design-for-testing-f001: Driver has no ID: matches =
all
[    6.369025] fmc_trivial: probe of fake-design-for-testing-f001 failed wi=
th error -95
[    6.370831] fmc fake-design-for-testing-f001: Driver has no ID: matches =
all
[    6.371796] fmc_write_eeprom fake-design-for-testing-f001: fmc_write_eep=
rom: no busid passed, refusing all cards
[    6.374869] fmc fake-design-for-testing-f001: Driver has no ID: matches =
all
[    6.376552] fmc_chardev fake-design-for-testing-f001: Created misc devic=
e "fake-design-for-testing-f001"
[    6.378825] u32 classifier
[    6.379432]     Performance counters on
[    6.388282]     input device check on
[    6.389147] ipip: IPv4 over IPv4 tunneling driver
[    6.390640] gre: GRE over IPv4 demultiplexor driver
[    6.391768] ip_gre: GRE over IPv4 tunneling driver
[    6.393609] TCP: cubic registered
[    6.394448] NET: Registered protocol family 10
[    6.396840] ip6_gre: GRE over IPv6 tunneling driver
[    6.399184] NET: Registered protocol family 17
[    6.399741] NET: Registered protocol family 15
[    6.399741] NET: Registered protocol family 4
[    6.399741] NET: Registered protocol family 5
[    6.399741] NET: Registered protocol family 9
[    6.399741] X.25 for Linux Version 0.2
[    6.416127] NET: Registered protocol family 6
[    6.420241] NET: Registered protocol family 11
[    6.429248] NET: Registered protocol family 3
[    6.430203] can: controller area network core (rev 20120528 abi 9)
[    6.431563] can: failed to create /proc/net/can . CONFIG_PROC_FS missing?
[    6.433045] NET: Registered protocol family 29
[    6.434013] can: raw protocol (rev 20120528)
[    6.434042] can: broadcast manager protocol (rev 20120528 t)
[    6.434042] can: netlink gateway (rev 20130117) max_hops=3D1
[    6.434042] NET: Registered protocol family 33
[    6.440980] Key type rxrpc registered
[    6.448859] Key type rxrpc_s registered
[    6.450004] RxRPC: Registered security type 2 'rxkad'
[    6.451176] lec:lane_module_init: lec.c: initialized
[    6.452291] mpoa:atm_mpoa_init: mpc.c: initialized
[    6.453388] l2tp_core: L2TP core driver, V2.0
[    6.454529] l2tp_debugfs: L2TP debugfs support
[    6.455526] NET4: DECnet for Linux: V.2.5.68s (C) 1995-2003 Linux DECnet=
 Project Team
[    6.458907] DECnet: Routing cache hash table of 128 buckets, 8Kbytes
[    6.468531] NET: Registered protocol family 12
[    6.472012] DCCP: Activated CCID 2 (TCP-like)
[    6.472640] DCCP: Activated CCID 3 (TCP-Friendly Rate Control)
[    6.473727] sctp: Hash tables configured (established 1170 bind 1024)
[    6.474744] lib80211: common routines for IEEE802.11 drivers
[    6.475519] lib80211_crypt: registered algorithm 'NULL'
[    6.476244] lib80211_crypt: registered algorithm 'WEP'
[    6.476918] lib80211_crypt: registered algorithm 'CCMP'
[    6.477806] lib80211_crypt: registered algorithm 'TKIP'
[    6.479005] NET: Registered protocol family 37
[    6.480043] NET: Registered protocol family 36
[    6.481261] Key type dns_resolver registered
[    6.489516] batman_adv: B.A.T.M.A.N. advanced 2013.3.0 (compatibility ve=
rsion 14) loaded
[    6.491368] openvswitch: Open vSwitch switching datapath
[    6.492364] mpls_gso: MPLS GSO support
[    6.494356]=20
[    6.494356] printing PIC contents
[    6.495472] ... PIC  IMR: ffff
[    6.496179] ... PIC  IRR: 1053
[    6.496904] ... PIC  ISR: 0000
[    6.497632] ... PIC ELCR: 0c00
[    6.498371] printing local APIC contents on CPU#0/0:
[    6.499362] ... APIC ID:      00000000 (0)
[    6.499362] ... APIC VERSION: 00050014
[    6.499362] ... APIC TASKPRI: 00000000 (00)
[    6.499362] ... APIC PROCPRI: 00000000
[    6.499362] ... APIC LDR: 01000000
[    6.499362] ... APIC DFR: ffffffff
[    6.499362] ... APIC SPIV: 000001ff
[    6.499362] ... APIC ISR field:
[    6.499362] 000000000000000000000000000000000000000000000000000000000000=
0000
[    6.499362] ... APIC TMR field:
[    6.499362] 000000000200000000000000000000000000000000000000000000000000=
0000
[    6.499362] ... APIC IRR field:
[    6.499362] 000000000000000000000000000000000000000000000000000000000000=
8000
[    6.499362] ... APIC ESR: 00000000
[    6.499362] ... APIC ICR: 000400f6
[    6.499362] ... APIC ICR2: 01000000
[    6.499362] ... APIC LVTT: 000200ef
[    6.499362] ... APIC LVTPC: 00010000
[    6.499362] ... APIC LVT0: 00010700
[    6.499362] ... APIC LVT1: 00000400
[    6.499362] ... APIC LVTERR: 000000fe
[    6.499362] ... APIC TMICT: 0000f424
[    6.499362] ... APIC TMCCT: 0000011c
[    6.499362] ... APIC TDCR: 00000003
[    6.499362]=20
[    6.523628] number of MP IRQ sources: 15.
[    6.524516] number of IO-APIC #0 registers: 24.
[    6.524616] testing the IO APIC.......................
[    6.526668] IO APIC #0......
[    6.527325] .... register #00: 00000000
[    6.528170] .......    : physical APIC id: 00
[    6.529205] .......    : Delivery Type: 0
[    6.530125] .......    : LTS          : 0
[    6.531045] .... register #01: 00170011
[    6.531922] .......     : max redirection entries: 17
[    6.533072] .......     : PRQ implemented: 0
[    6.534054] .......     : IO APIC version: 11
[    6.535048] .... register #02: 00000000
[    6.535924] .......     : arbitration: 00
[    6.536834] .... IRQ redirection table:
[    6.537738] 1    0    0   0   0    0    0    00
[    6.538797] 0    0    0   0   0    1    1    31
[    6.539821] 0    0    0   0   0    1    1    30
[    6.540847] 0    0    0   0   0    1    1    33
[    6.541866] 1    0    0   0   0    1    1    34
[    6.542885] 1    1    0   0   0    1    1    35
[    6.543906] 0    0    0   0   0    1    1    36
[    6.544923] 0    0    0   0   0    1    1    37
[    6.545939] 0    0    0   0   0    1    1    38
[    6.546956] 0    1    0   0   0    1    1    39
[    6.547978] 1    1    0   0   0    1    1    3A
[    6.549031] 1    1    0   0   0    1    1    3B
[    6.550085] 0    0    0   0   0    1    1    3C
[    6.551128] 0    0    0   0   0    1    1    3D
[    6.552176] 0    0    0   0   0    1    1    3E
[    6.558363] 0    0    0   0   0    1    1    3F
[    6.559425] 1    0    0   0   0    0    0    00
[    6.560478] 1    0    0   0   0    0    0    00
[    6.561543] 1    0    0   0   0    0    0    00
[    6.562595] 1    0    0   0   0    0    0    00
[    6.563649] 1    0    0   0   0    0    0    00
[    6.568506] 1    0    0   0   0    0    0    00
[    6.569577] 1    0    0   0   0    0    0    00
[    6.570632] 1    0    0   0   0    0    0    00
[    6.571663] IRQ to pin mappings:
[    6.572418] IRQ0 -> 0:2
[    6.578459] IRQ1 -> 0:1
[    6.579076] IRQ3 -> 0:3
[    6.579237] IRQ4 -> 0:4
[    6.579237] IRQ5 -> 0:5
[    6.579237] IRQ6 -> 0:6
[    6.579237] IRQ7 -> 0:7
[    6.579237] IRQ8 -> 0:8
[    6.579237] IRQ9 -> 0:9
[    6.579237] IRQ10 -> 0:10
[    6.579237] IRQ11 -> 0:11
[    6.584775] IRQ12 -> 0:12
[    6.588889] IRQ13 -> 0:13
[    6.589564] IRQ14 -> 0:14
[    6.590244] IRQ15 -> 0:15
[    6.590912] .................................... done.
[    6.592831] Key type trusted registered
[    6.599297] Key type encrypted registered
[    6.600483] raid6test: testing the 4-disk case...
[    6.601649] raid6test: test_disks(0, 1): faila=3D  0(D)  failb=3D  1(D) =
 OK
[    6.603249] raid6test: test_disks(0, 2): faila=3D  0(D)  failb=3D  2(P) =
 OK
[    6.609042] raid6test: test_disks(0, 3): faila=3D  0(D)  failb=3D  3(Q) =
 OK
[    6.610605] raid6test: test_disks(1, 2): faila=3D  1(D)  failb=3D  2(P) =
 OK
[    6.612161] raid6test: test_disks(1, 3): faila=3D  1(D)  failb=3D  3(Q) =
 OK
[    6.618637] raid6test: test_disks(2, 3): faila=3D  2(P)  failb=3D  3(Q) =
 OK
[    6.620210] raid6test: testing the 5-disk case...
[    6.621356] raid6test: test_disks(0, 1): faila=3D  0(D)  failb=3D  1(D) =
 OK
[    6.622901] raid6test: test_disks(0, 2): faila=3D  0(D)  failb=3D  2(D) =
 OK
[    6.624438] raid6test: test_disks(0, 3): faila=3D  0(D)  failb=3D  3(P) =
 OK
[    6.625974] raid6test: test_disks(0, 4): faila=3D  0(D)  failb=3D  4(Q) =
 OK
[    6.627513] raid6test: test_disks(1, 2): faila=3D  1(D)  failb=3D  2(D) =
 OK
[    6.628963] raid6test: test_disks(1, 3): faila=3D  1(D)  failb=3D  3(P) =
 OK
[    6.630296] raid6test: test_disks(1, 4): faila=3D  1(D)  failb=3D  4(Q) =
 OK
[    6.631628] raid6test: test_disks(2, 3): faila=3D  2(D)  failb=3D  3(P) =
 OK
[    6.632960] raid6test: test_disks(2, 4): faila=3D  2(D)  failb=3D  4(Q) =
 OK
[    6.634290] raid6test: test_disks(3, 4): faila=3D  3(P)  failb=3D  4(Q) =
 OK
[    6.635722] raid6test: testing the 11-disk case...
[    6.636718] raid6test: test_disks(0, 1): faila=3D  0(D)  failb=3D  1(D) =
 OK
[    6.638058] raid6test: test_disks(0, 2): faila=3D  0(D)  failb=3D  2(D) =
 OK
[    6.639616] raid6test: test_disks(0, 3): faila=3D  0(D)  failb=3D  3(D) =
 OK
[    6.641161] raid6test: test_disks(0, 4): faila=3D  0(D)  failb=3D  4(D) =
 OK
[    6.642716] raid6test: test_disks(0, 5): faila=3D  0(D)  failb=3D  5(D) =
 OK
[    6.644263] raid6test: test_disks(0, 6): faila=3D  0(D)  failb=3D  6(D) =
 OK
[    6.645817] raid6test: test_disks(0, 7): faila=3D  0(D)  failb=3D  7(D) =
 OK
[    6.647360] raid6test: test_disks(0, 8): faila=3D  0(D)  failb=3D  8(D) =
 OK
[    6.648893] raid6test: test_disks(0, 9): faila=3D  0(D)  failb=3D  9(P) =
 OK
[    6.650229] raid6test: test_disks(0, 10): faila=3D  0(D)  failb=3D 10(Q)=
  OK
[    6.651584] raid6test: test_disks(1, 2): faila=3D  1(D)  failb=3D  2(D) =
 OK
[    6.652972] raid6test: test_disks(1, 3): faila=3D  1(D)  failb=3D  3(D) =
 OK
[    6.654313] raid6test: test_disks(1, 4): faila=3D  1(D)  failb=3D  4(D) =
 OK
[    6.655647] raid6test: test_disks(1, 5): faila=3D  1(D)  failb=3D  5(D) =
 OK
[    6.656992] raid6test: test_disks(1, 6): faila=3D  1(D)  failb=3D  6(D) =
 OK
[    6.658373] raid6test: test_disks(1, 7): faila=3D  1(D)  failb=3D  7(D) =
 OK
[    6.659916] raid6test: test_disks(1, 8): faila=3D  1(D)  failb=3D  8(D) =
 OK
[    6.661460] raid6test: test_disks(1, 9): faila=3D  1(D)  failb=3D  9(P) =
 OK
[    6.662987] raid6test: test_disks(1, 10): faila=3D  1(D)  failb=3D 10(Q)=
  OK
[    6.664540] raid6test: test_disks(2, 3): faila=3D  2(D)  failb=3D  3(D) =
 OK
[    6.666089] raid6test: test_disks(2, 4): faila=3D  2(D)  failb=3D  4(D) =
 OK
[    6.667627] raid6test: test_disks(2, 5): faila=3D  2(D)  failb=3D  5(D) =
 OK
[    6.669066] raid6test: test_disks(2, 6): faila=3D  2(D)  failb=3D  6(D) =
 OK
[    6.670416] raid6test: test_disks(2, 7): faila=3D  2(D)  failb=3D  7(D) =
 OK
[    6.671762] raid6test: test_disks(2, 8): faila=3D  2(D)  failb=3D  8(D) =
 OK
[    6.673096] raid6test: test_disks(2, 9): faila=3D  2(D)  failb=3D  9(P) =
 OK
[    6.674431] raid6test: test_disks(2, 10): faila=3D  2(D)  failb=3D 10(Q)=
  OK
[    6.675790] raid6test: test_disks(3, 4): faila=3D  3(D)  failb=3D  4(D) =
 OK
[    6.677122] raid6test: test_disks(3, 5): faila=3D  3(D)  failb=3D  5(D) =
 OK
[    6.678529] raid6test: test_disks(3, 6): faila=3D  3(D)  failb=3D  6(D) =
 OK
[    6.680066] raid6test: test_disks(3, 7): faila=3D  3(D)  failb=3D  7(D) =
 OK
[    6.681635] raid6test: test_disks(3, 8): faila=3D  3(D)  failb=3D  8(D) =
 OK
[    6.683179] raid6test: test_disks(3, 9): faila=3D  3(D)  failb=3D  9(P) =
 OK
[    6.688514] raid6test: test_disks(3, 10): faila=3D  3(D)  failb=3D 10(Q)=
  OK
[    6.689843] raid6test: test_disks(4, 5): faila=3D  4(D)  failb=3D  5(D) =
 OK
[    6.691126] raid6test: test_disks(4, 6): faila=3D  4(D)  failb=3D  6(D) =
 OK
[    6.692414] raid6test: test_disks(4, 7): faila=3D  4(D)  failb=3D  7(D) =
 OK
[    6.693708] raid6test: test_disks(4, 8): faila=3D  4(D)  failb=3D  8(D) =
 OK
[    6.694971] raid6test: test_disks(4, 9): faila=3D  4(D)  failb=3D  9(P) =
 OK
[    6.696238] raid6test: test_disks(4, 10): faila=3D  4(D)  failb=3D 10(Q)=
  OK
[    6.697537] raid6test: test_disks(5, 6): faila=3D  5(D)  failb=3D  6(D) =
 OK
[    6.707109] raid6test: test_disks(5, 7): faila=3D  5(D)  failb=3D  7(D) =
 OK
[    6.718442] raid6test: test_disks(5, 8): faila=3D  5(D)  failb=3D  8(D) =
 OK
[    6.719708] raid6test: test_disks(5, 9): faila=3D  5(D)  failb=3D  9(P) =
 OK
[    6.720945] raid6test: test_disks(5, 10): faila=3D  5(D)  failb=3D 10(Q)=
  OK
[    6.722231] raid6test: test_disks(6, 7): faila=3D  6(D)  failb=3D  7(D) =
 OK
[    6.723500] raid6test: test_disks(6, 8): faila=3D  6(D)  failb=3D  8(D) =
 OK
[    6.724791] raid6test: test_disks(6, 9): faila=3D  6(D)  failb=3D  9(P) =
 OK
[    6.726062] raid6test: test_disks(6, 10): faila=3D  6(D)  failb=3D 10(Q)=
  OK
[    6.727374] raid6test: test_disks(7, 8): faila=3D  7(D)  failb=3D  8(D) =
 OK
[    6.738689] raid6test: test_disks(7, 9): faila=3D  7(D)  failb=3D  9(P) =
 OK
[    6.739950] raid6test: test_disks(7, 10): faila=3D  7(D)  failb=3D 10(Q)=
  OK
[    6.741261] raid6test: test_disks(8, 9): faila=3D  8(D)  failb=3D  9(P) =
 OK
[    6.742511] raid6test: test_disks(8, 10): faila=3D  8(D)  failb=3D 10(Q)=
  OK
[    6.743765] raid6test: test_disks(9, 10): faila=3D  9(P)  failb=3D 10(Q)=
  OK
[    6.745221] raid6test: testing the 12-disk case...
[    6.746243] raid6test: test_disks(0, 1): faila=3D  0(D)  failb=3D  1(D) =
 OK
[    6.747590] raid6test: test_disks(0, 2): faila=3D  0(D)  failb=3D  2(D) =
 OK
[    6.749042] raid6test: test_disks(0, 3): faila=3D  0(D)  failb=3D  3(D) =
 OK
[    6.754079] raid6test: test_disks(0, 4): faila=3D  0(D)  failb=3D  4(D) =
 OK
[    6.755447] raid6test: test_disks(0, 5): faila=3D  0(D)  failb=3D  5(D) =
 OK
[    6.756808] raid6test: test_disks(0, 6): faila=3D  0(D)  failb=3D  6(D) =
 OK
[    6.759130] raid6test: test_disks(0, 7): faila=3D  0(D)  failb=3D  7(D) =
 OK
[    6.769385] raid6test: test_disks(0, 8): faila=3D  0(D)  failb=3D  8(D) =
 OK
[    6.770751] raid6test: test_disks(0, 9): faila=3D  0(D)  failb=3D  9(D) =
 OK
[    6.772102] raid6test: test_disks(0, 10): faila=3D  0(D)  failb=3D 10(P)=
  OK
[    6.773478] raid6test: test_disks(0, 11): faila=3D  0(D)  failb=3D 11(Q)=
  OK
[    6.774858] raid6test: test_disks(1, 2): faila=3D  1(D)  failb=3D  2(D) =
 OK
[    6.776223] raid6test: test_disks(1, 3): faila=3D  1(D)  failb=3D  3(D) =
 OK
[    6.777580] raid6test: test_disks(1, 4): faila=3D  1(D)  failb=3D  4(D) =
 OK
[    6.778954] raid6test: test_disks(1, 5): faila=3D  1(D)  failb=3D  5(D) =
 OK
[    6.789598] raid6test: test_disks(1, 6): faila=3D  1(D)  failb=3D  6(D) =
 OK
[    6.790968] raid6test: test_disks(1, 7): faila=3D  1(D)  failb=3D  7(D) =
 OK
[    6.792336] raid6test: test_disks(1, 8): faila=3D  1(D)  failb=3D  8(D) =
 OK
[    6.793696] raid6test: test_disks(1, 9): faila=3D  1(D)  failb=3D  9(D) =
 OK
[    6.795056] raid6test: test_disks(1, 10): faila=3D  1(D)  failb=3D 10(P)=
  OK
[    6.796425] raid6test: test_disks(1, 11): faila=3D  1(D)  failb=3D 11(Q)=
  OK
[    6.797806] raid6test: test_disks(2, 3): faila=3D  2(D)  failb=3D  3(D) =
 OK
[    6.799174] raid6test: test_disks(2, 4): faila=3D  2(D)  failb=3D  4(D) =
 OK
[    6.808915] raid6test: test_disks(2, 5): faila=3D  2(D)  failb=3D  5(D) =
 OK
[    6.810286] raid6test: test_disks(2, 6): faila=3D  2(D)  failb=3D  6(D) =
 OK
[    6.811648] raid6test: test_disks(2, 7): faila=3D  2(D)  failb=3D  7(D) =
 OK
[    6.813007] raid6test: test_disks(2, 8): faila=3D  2(D)  failb=3D  8(D) =
 OK
[    6.814371] raid6test: test_disks(2, 9): faila=3D  2(D)  failb=3D  9(D) =
 OK
[    6.815725] raid6test: test_disks(2, 10): faila=3D  2(D)  failb=3D 10(P)=
  OK
[    6.817086] raid6test: test_disks(2, 11): faila=3D  2(D)  failb=3D 11(Q)=
  OK
[    6.828447] raid6test: test_disks(3, 4): faila=3D  3(D)  failb=3D  4(D) =
 OK
[    6.829807] raid6test: test_disks(3, 5): faila=3D  3(D)  failb=3D  5(D) =
 OK
[    6.831160] raid6test: test_disks(3, 6): faila=3D  3(D)  failb=3D  6(D) =
 OK
[    6.832522] raid6test: test_disks(3, 7): faila=3D  3(D)  failb=3D  7(D) =
 OK
[    6.833877] raid6test: test_disks(3, 8): faila=3D  3(D)  failb=3D  8(D) =
 OK
[    6.835234] raid6test: test_disks(3, 9): faila=3D  3(D)  failb=3D  9(D) =
 OK
[    6.836584] raid6test: test_disks(3, 10): faila=3D  3(D)  failb=3D 10(P)=
  OK
[    6.837947] raid6test: test_disks(3, 11): faila=3D  3(D)  failb=3D 11(Q)=
  OK
[    6.839336] raid6test: test_disks(4, 5): faila=3D  4(D)  failb=3D  5(D) =
 OK
[    6.849104] raid6test: test_disks(4, 6): faila=3D  4(D)  failb=3D  6(D) =
 OK
[    6.850466] raid6test: test_disks(4, 7): faila=3D  4(D)  failb=3D  7(D) =
 OK
[    6.851826] raid6test: test_disks(4, 8): faila=3D  4(D)  failb=3D  8(D) =
 OK
[    6.853175] raid6test: test_disks(4, 9): faila=3D  4(D)  failb=3D  9(D) =
 OK
[    6.854531] raid6test: test_disks(4, 10): faila=3D  4(D)  failb=3D 10(P)=
  OK
[    6.855894] raid6test: test_disks(4, 11): faila=3D  4(D)  failb=3D 11(Q)=
  OK
[    6.857268] raid6test: test_disks(5, 6): faila=3D  5(D)  failb=3D  6(D) =
 OK
[    6.863071] raid6test: test_disks(5, 7): faila=3D  5(D)  failb=3D  7(D) =
 OK
[    6.864438] raid6test: test_disks(5, 8): faila=3D  5(D)  failb=3D  8(D) =
 OK
[    6.865803] raid6test: test_disks(5, 9): faila=3D  5(D)  failb=3D  9(D) =
 OK
[    6.867157] raid6test: test_disks(5, 10): faila=3D  5(D)  failb=3D 10(P)=
  OK
[    6.878623] raid6test: test_disks(5, 11): faila=3D  5(D)  failb=3D 11(Q)=
  OK
[    6.880008] raid6test: test_disks(6, 7): faila=3D  6(D)  failb=3D  7(D) =
 OK
[    6.881372] raid6test: test_disks(6, 8): faila=3D  6(D)  failb=3D  8(D) =
 OK
[    6.882734] raid6test: test_disks(6, 9): faila=3D  6(D)  failb=3D  9(D) =
 OK
[    6.884086] raid6test: test_disks(6, 10): faila=3D  6(D)  failb=3D 10(P)=
  OK
[    6.885453] raid6test: test_disks(6, 11): faila=3D  6(D)  failb=3D 11(Q)=
  OK
[    6.886830] raid6test: test_disks(7, 8): faila=3D  7(D)  failb=3D  8(D) =
 OK
[    6.888186] raid6test: test_disks(7, 9): faila=3D  7(D)  failb=3D  9(D) =
 OK
[    6.889610] raid6test: test_disks(7, 10): faila=3D  7(D)  failb=3D 10(P)=
  OK
[    6.899487] raid6test: test_disks(7, 11): faila=3D  7(D)  failb=3D 11(Q)=
  OK
[    6.900868] raid6test: test_disks(8, 9): faila=3D  8(D)  failb=3D  9(D) =
 OK
[    6.902235] raid6test: test_disks(8, 10): faila=3D  8(D)  failb=3D 10(P)=
  OK
[    6.903603] raid6test: test_disks(8, 11): faila=3D  8(D)  failb=3D 11(Q)=
  OK
[    6.904975] raid6test: test_disks(9, 10): faila=3D  9(D)  failb=3D 10(P)=
  OK
[    6.906345] raid6test: test_disks(9, 11): faila=3D  9(D)  failb=3D 11(Q)=
  OK
[    6.907710] raid6test: test_disks(10, 11): faila=3D 10(P)  failb=3D 11(Q=
)  OK
[    6.918851] raid6test: testing the 16-disk case...
[    6.920006] raid6test: test_disks(0, 1): faila=3D  0(D)  failb=3D  1(D) =
 OK
[    6.921377] raid6test: test_disks(0, 2): faila=3D  0(D)  failb=3D  2(D) =
 OK
[    6.922741] raid6test: test_disks(0, 3): faila=3D  0(D)  failb=3D  3(D) =
 OK
[    6.924099] raid6test: test_disks(0, 4): faila=3D  0(D)  failb=3D  4(D) =
 OK
[    6.925458] raid6test: test_disks(0, 5): faila=3D  0(D)  failb=3D  5(D) =
 OK
[    6.926818] raid6test: test_disks(0, 6): faila=3D  0(D)  failb=3D  6(D) =
 OK
[    6.928172] raid6test: test_disks(0, 7): faila=3D  0(D)  failb=3D  7(D) =
 OK
[    6.938964] raid6test: test_disks(0, 8): faila=3D  0(D)  failb=3D  8(D) =
 OK
[    6.940331] raid6test: test_disks(0, 9): faila=3D  0(D)  failb=3D  9(D) =
 OK
[    6.941692] raid6test: test_disks(0, 10): faila=3D  0(D)  failb=3D 10(D)=
  OK
[    6.943065] raid6test: test_disks(0, 11): faila=3D  0(D)  failb=3D 11(D)=
  OK
[    6.944439] raid6test: test_disks(0, 12): faila=3D  0(D)  failb=3D 12(D)=
  OK
[    6.945821] raid6test: test_disks(0, 13): faila=3D  0(D)  failb=3D 13(D)=
  OK
[    6.947188] raid6test: test_disks(0, 14): faila=3D  0(D)  failb=3D 14(P)=
  OK
[    6.958586] raid6test: test_disks(0, 15): faila=3D  0(D)  failb=3D 15(Q)=
  OK
[    6.959959] raid6test: test_disks(1, 2): faila=3D  1(D)  failb=3D  2(D) =
 OK
[    6.961335] raid6test: test_disks(1, 3): faila=3D  1(D)  failb=3D  3(D) =
 OK
[    6.962694] raid6test: test_disks(1, 4): faila=3D  1(D)  failb=3D  4(D) =
 OK
[    6.964050] raid6test: test_disks(1, 5): faila=3D  1(D)  failb=3D  5(D) =
 OK
[    6.965414] raid6test: test_disks(1, 6): faila=3D  1(D)  failb=3D  6(D) =
 OK
[    6.966765] raid6test: test_disks(1, 7): faila=3D  1(D)  failb=3D  7(D) =
 OK
[    6.968127] raid6test: test_disks(1, 8): faila=3D  1(D)  failb=3D  8(D) =
 OK
[    6.988269] raid6test: test_disks(1, 9): faila=3D  1(D)  failb=3D  9(D) =
 OK
[    6.989329] raid6test: test_disks(1, 10): faila=3D  1(D)  failb=3D 10(D)=
  OK
[    6.990412] raid6test: test_disks(1, 11): faila=3D  1(D)  failb=3D 11(D)=
  OK
[    6.991474] raid6test: test_disks(1, 12): faila=3D  1(D)  failb=3D 12(D)=
  OK
[    6.992535] raid6test: test_disks(1, 13): faila=3D  1(D)  failb=3D 13(D)=
  OK
[    6.993618] raid6test: test_disks(1, 14): faila=3D  1(D)  failb=3D 14(P)=
  OK
[    6.994686] raid6test: test_disks(1, 15): faila=3D  1(D)  failb=3D 15(Q)=
  OK
[    6.995778] raid6test: test_disks(2, 3): faila=3D  2(D)  failb=3D  3(D) =
 OK
[    6.996828] raid6test: test_disks(2, 4): faila=3D  2(D)  failb=3D  4(D) =
 OK
[    7.017999] raid6test: test_disks(2, 5): faila=3D  2(D)  failb=3D  5(D) =
 OK
[    7.019396] raid6test: test_disks(2, 6): faila=3D  2(D)  failb=3D  6(D) =
 OK
[    7.028717] raid6test: test_disks(2, 7): faila=3D  2(D)  failb=3D  7(D) =
 OK
[    7.030076] raid6test: test_disks(2, 8): faila=3D  2(D)  failb=3D  8(D) =
 OK
[    7.031436] raid6test: test_disks(2, 9): faila=3D  2(D)  failb=3D  9(D) =
 OK
[    7.032802] raid6test: test_disks(2, 10): faila=3D  2(D)  failb=3D 10(D)=
  OK
[    7.034174] raid6test: test_disks(2, 11): faila=3D  2(D)  failb=3D 11(D)=
  OK
[    7.039205] raid6test: test_disks(2, 12): faila=3D  2(D)  failb=3D 12(D)=
  OK
[    7.040778] raid6test: test_disks(2, 13): faila=3D  2(D)  failb=3D 13(D)=
  OK
[    7.043755] raid6test: test_disks(2, 14): faila=3D  2(D)  failb=3D 14(P)=
  OK
[    7.048582] raid6test: test_disks(2, 15): faila=3D  2(D)  failb=3D 15(Q)=
  OK
[    7.058634] raid6test: test_disks(3, 4): faila=3D  3(D)  failb=3D  4(D) =
 OK
[    7.060147] raid6test: test_disks(3, 5): faila=3D  3(D)  failb=3D  5(D) =
 OK
[    7.061758] raid6test: test_disks(3, 6): faila=3D  3(D)  failb=3D  6(D) =
 OK
[    7.063291] raid6test: test_disks(3, 7): faila=3D  3(D)  failb=3D  7(D) =
 OK
[    7.064779] raid6test: test_disks(3, 8): faila=3D  3(D)  failb=3D  8(D) =
 OK
[    7.066272] raid6test: test_disks(3, 9): faila=3D  3(D)  failb=3D  9(D) =
 OK
[    7.069265] raid6test: test_disks(3, 10): faila=3D  3(D)  failb=3D 10(D)=
  OK
[    7.079278] raid6test: test_disks(3, 11): faila=3D  3(D)  failb=3D 11(D)=
  OK
[    7.081273] raid6test: test_disks(3, 12): faila=3D  3(D)  failb=3D 12(D)=
  OK
[    7.082892] raid6test: test_disks(3, 13): faila=3D  3(D)  failb=3D 13(D)=
  OK
[    7.084319] raid6test: test_disks(3, 14): faila=3D  3(D)  failb=3D 14(P)=
  OK
[    7.085739] raid6test: test_disks(3, 15): faila=3D  3(D)  failb=3D 15(Q)=
  OK
[    7.087160] raid6test: test_disks(4, 5): faila=3D  4(D)  failb=3D  5(D) =
 OK
[    7.098598] raid6test: test_disks(4, 6): faila=3D  4(D)  failb=3D  6(D) =
 OK
[    7.100190] raid6test: test_disks(4, 7): faila=3D  4(D)  failb=3D  7(D) =
 OK
[    7.101748] raid6test: test_disks(4, 8): faila=3D  4(D)  failb=3D  8(D) =
 OK
[    7.103312] raid6test: test_disks(4, 9): faila=3D  4(D)  failb=3D  9(D) =
 OK
[    7.104878] raid6test: test_disks(4, 10): faila=3D  4(D)  failb=3D 10(D)=
  OK
[    7.106458] raid6test: test_disks(4, 11): faila=3D  4(D)  failb=3D 11(D)=
  OK
[    7.108044] raid6test: test_disks(4, 12): faila=3D  4(D)  failb=3D 12(D)=
  OK
[    7.109515] raid6test: test_disks(4, 13): faila=3D  4(D)  failb=3D 13(D)=
  OK
[    7.118932] raid6test: test_disks(4, 14): faila=3D  4(D)  failb=3D 14(P)=
  OK
[    7.120515] raid6test: test_disks(4, 15): faila=3D  4(D)  failb=3D 15(Q)=
  OK
[    7.122086] raid6test: test_disks(5, 6): faila=3D  5(D)  failb=3D  6(D) =
 OK
[    7.123643] raid6test: test_disks(5, 7): faila=3D  5(D)  failb=3D  7(D) =
 OK
[    7.125193] raid6test: test_disks(5, 8): faila=3D  5(D)  failb=3D  8(D) =
 OK
[    7.126746] raid6test: test_disks(5, 9): faila=3D  5(D)  failb=3D  9(D) =
 OK
[    7.128200] raid6test: test_disks(5, 10): faila=3D  5(D)  failb=3D 10(D)=
  OK
[    7.129640] raid6test: test_disks(5, 11): faila=3D  5(D)  failb=3D 11(D)=
  OK
[    7.131061] raid6test: test_disks(5, 12): faila=3D  5(D)  failb=3D 12(D)=
  OK
[    7.132485] raid6test: test_disks(5, 13): faila=3D  5(D)  failb=3D 13(D)=
  OK
[    7.133914] raid6test: test_disks(5, 14): faila=3D  5(D)  failb=3D 14(P)=
  OK
[    7.135329] raid6test: test_disks(5, 15): faila=3D  5(D)  failb=3D 15(Q)=
  OK
[    7.136757] raid6test: test_disks(6, 7): faila=3D  6(D)  failb=3D  7(D) =
 OK
[    7.138130] raid6test: test_disks(6, 8): faila=3D  6(D)  failb=3D  8(D) =
 OK
[    7.139690] raid6test: test_disks(6, 9): faila=3D  6(D)  failb=3D  9(D) =
 OK
[    7.141249] raid6test: test_disks(6, 10): faila=3D  6(D)  failb=3D 10(D)=
  OK
[    7.142820] raid6test: test_disks(6, 11): faila=3D  6(D)  failb=3D 11(D)=
  OK
[    7.144390] raid6test: test_disks(6, 12): faila=3D  6(D)  failb=3D 12(D)=
  OK
[    7.145952] raid6test: test_disks(6, 13): faila=3D  6(D)  failb=3D 13(D)=
  OK
[    7.147487] raid6test: test_disks(6, 14): faila=3D  6(D)  failb=3D 14(P)=
  OK
[    7.148861] raid6test: test_disks(6, 15): faila=3D  6(D)  failb=3D 15(Q)=
  OK
[    7.150239] raid6test: test_disks(7, 8): faila=3D  7(D)  failb=3D  8(D) =
 OK
[    7.151595] raid6test: test_disks(7, 9): faila=3D  7(D)  failb=3D  9(D) =
 OK
[    7.152952] raid6test: test_disks(7, 10): faila=3D  7(D)  failb=3D 10(D)=
  OK
[    7.154330] raid6test: test_disks(7, 11): faila=3D  7(D)  failb=3D 11(D)=
  OK
[    7.155708] raid6test: test_disks(7, 12): faila=3D  7(D)  failb=3D 12(D)=
  OK
[    7.157081] raid6test: test_disks(7, 13): faila=3D  7(D)  failb=3D 13(D)=
  OK
[    7.158521] raid6test: test_disks(7, 14): faila=3D  7(D)  failb=3D 14(P)=
  OK
[    7.159935] raid6test: test_disks(7, 15): faila=3D  7(D)  failb=3D 15(Q)=
  OK
[    7.161361] raid6test: test_disks(8, 9): faila=3D  8(D)  failb=3D  9(D) =
 OK
[    7.162766] raid6test: test_disks(8, 10): faila=3D  8(D)  failb=3D 10(D)=
  OK
[    7.164185] raid6test: test_disks(8, 11): faila=3D  8(D)  failb=3D 11(D)=
  OK
[    7.165615] raid6test: test_disks(8, 12): faila=3D  8(D)  failb=3D 12(D)=
  OK
[    7.167039] raid6test: test_disks(8, 13): faila=3D  8(D)  failb=3D 13(D)=
  OK
[    7.168506] raid6test: test_disks(8, 14): faila=3D  8(D)  failb=3D 14(P)=
  OK
[    7.170063] raid6test: test_disks(8, 15): faila=3D  8(D)  failb=3D 15(Q)=
  OK
[    7.171634] raid6test: test_disks(9, 10): faila=3D  9(D)  failb=3D 10(D)=
  OK
[    7.173198] raid6test: test_disks(9, 11): faila=3D  9(D)  failb=3D 11(D)=
  OK
[    7.174767] raid6test: test_disks(9, 12): faila=3D  9(D)  failb=3D 12(D)=
  OK
[    7.176341] raid6test: test_disks(9, 13): faila=3D  9(D)  failb=3D 13(D)=
  OK
[    7.177902] raid6test: test_disks(9, 14): faila=3D  9(D)  failb=3D 14(P)=
  OK
[    7.179360] raid6test: test_disks(9, 15): faila=3D  9(D)  failb=3D 15(Q)=
  OK
[    7.180775] raid6test: test_disks(10, 11): faila=3D 10(D)  failb=3D 11(D=
)  OK
[    7.182196] raid6test: test_disks(10, 12): faila=3D 10(D)  failb=3D 12(D=
)  OK
[    7.183624] raid6test: test_disks(10, 13): faila=3D 10(D)  failb=3D 13(D=
)  OK
[    7.185049] raid6test: test_disks(10, 14): faila=3D 10(D)  failb=3D 14(P=
)  OK
[    7.186469] raid6test: test_disks(10, 15): faila=3D 10(D)  failb=3D 15(Q=
)  OK
[    7.187901] raid6test: test_disks(11, 12): faila=3D 11(D)  failb=3D 12(D=
)  OK
[    7.189461] raid6test: test_disks(11, 13): faila=3D 11(D)  failb=3D 13(D=
)  OK
[    7.191040] raid6test: test_disks(11, 14): faila=3D 11(D)  failb=3D 14(P=
)  OK
[    7.192621] raid6test: test_disks(11, 15): faila=3D 11(D)  failb=3D 15(Q=
)  OK
[    7.194205] raid6test: test_disks(12, 13): faila=3D 12(D)  failb=3D 13(D=
)  OK
[    7.195800] raid6test: test_disks(12, 14): faila=3D 12(D)  failb=3D 14(P=
)  OK
[    7.197372] raid6test: test_disks(12, 15): faila=3D 12(D)  failb=3D 15(Q=
)  OK
[    7.198916] raid6test: test_disks(13, 14): faila=3D 13(D)  failb=3D 14(P=
)  OK
[    7.200337] raid6test: test_disks(13, 15): faila=3D 13(D)  failb=3D 15(Q=
)  OK
[    7.201759] raid6test: test_disks(14, 15): faila=3D 14(P)  failb=3D 15(Q=
)  OK
[    7.203125] raid6test:=20
[    7.203633] raid6test: complete (257 tests, 0 failures)
[    7.206049] RIO: rio_register_scan for mport_id=3D-1
[    7.207671] dmaengine: __dma_request_channel: fail ((null))
[    7.209070] BIOS EDD facility v0.16 2004-Jun-25, 6 devices found
[    7.212048] debug: unmapping init [mem 0xffffffff82d1c000-0xffffffff82e0=
ffff]
[    7.229045] hostname (153) used greatest stack depth: 5800 bytes left
/bin/sh: /proc/self/fd/9: No such file or directory
[    7.248307] sh (158) used greatest stack depth: 5704 bytes left
/bin/sh: /proc/self/fd/9: No such file or directory
/bin/sh: /proc/self/fd/9: No such file or directory
[   20.702156]=20
[   20.702493] =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D
[   20.703511] [ BUG: lock held when returning to user space! ]
[   20.704532] 3.11.0-rc1-next-20130719 #50 Not tainted
[   20.705416] ------------------------------------------------
[   20.706425] trinity-child0/174 is leaving the kernel with locks still he=
ld!
[   20.707638] 1 lock held by trinity-child0/174:
[   20.708475]  #0:  (rcu_read_lock){.+.+..}, at: [<ffffffff814a8491>] do_s=
hmat+0xe1/0x500
[   20.710075] BUG: sleeping function called from invalid context at mm/mem=
ory.c:4228
[   20.711772] in_atomic(): 0, irqs_disabled(): 0, pid: 174, name: trinity-=
child0
[   20.712768] INFO: lockdep is turned off.
[   20.719779] CPU: 0 PID: 174 Comm: trinity-child0 Not tainted 3.11.0-rc1-=
next-20130719 #50
[   20.721198] Hardware name: Bochs Bochs, BIOS Bochs 01/01/2011
[   20.722189]  0000000000000000 ffff880004cbff08 ffffffff82312111 ffff8800=
04cbff18
[   20.723568]  ffffffff8109968a ffff880004cbff38 ffffffff810f72a6 00000000=
00000000
[   20.724973]  0000000000000000 ffff880004cbff78 ffffffff81081fa1 00000000=
00000000
[   20.726373] Call Trace:
[   20.726817]  [<ffffffff82312111>] dump_stack+0x19/0x1b
[   20.727722]  [<ffffffff8109968a>] __might_sleep+0x12a/0x140
[   20.738739]  [<ffffffff810f72a6>] might_fault+0x46/0xb0
[   20.739686]  [<ffffffff81081fa1>] SyS_rt_sigprocmask+0x91/0xc0
[   20.739730]  [<ffffffff823207e7>] system_call_fastpath+0x16/0x1b
[   20.744229] warning: process `trinity-child0' used the deprecated sysctl=
 system call with=20
[   23.747681] BUG: sleeping function called from invalid context at includ=
e/linux/freezer.h:56
[   23.749553] in_atomic(): 0, irqs_disabled(): 0, pid: 174, name: trinity-=
child0
[   23.750781] INFO: lockdep is turned off.
[   23.751471] CPU: 0 PID: 174 Comm: trinity-child0 Not tainted 3.11.0-rc1-=
next-20130719 #50
[   23.751777] Hardware name: Bochs Bochs, BIOS Bochs 01/01/2011
[   23.751777]  ffff880004cb8000 ffff880004cbfe60 ffffffff82312111 ffff8800=
04cbfe70
[   23.751777]  ffffffff8109968a ffff880004cbfea8 ffffffff8231cc25 00000000=
0000c350
[   23.751777]  0000000000000001 0000000001070000 ffff880004cbff40 00000000=
01070000
[   23.751777] Call Trace:
[   23.751777]  [<ffffffff82312111>] dump_stack+0x19/0x1b
[   23.751777]  [<ffffffff8109968a>] __might_sleep+0x12a/0x140
[   23.751777]  [<ffffffff8231cc25>] do_nanosleep+0xa5/0x130
[   23.751777]  [<ffffffff81092eb2>] hrtimer_nanosleep+0xb2/0x130
[   23.751777]  [<ffffffff810926e0>] ? __hrtimer_init+0xb0/0xb0
[   23.751777]  [<ffffffff8108e08e>] common_nsleep+0x1e/0x20
[   23.751777]  [<ffffffff8108f6ba>] SyS_clock_nanosleep+0xca/0xe0
[   23.765045]  [<ffffffff823207e7>] system_call_fastpath+0x16/0x1b
[   29.879503] BUG: sleeping function called from invalid context at mm/mem=
ory.c:4228
[   29.881009] in_atomic(): 0, irqs_disabled(): 0, pid: 180, name: trinity-=
child0
[   29.882113] INFO: lockdep is turned off.
[   29.882725] CPU: 0 PID: 180 Comm: trinity-child0 Not tainted 3.11.0-rc1-=
next-20130719 #50
[   29.883997] Hardware name: Bochs Bochs, BIOS Bochs 01/01/2011
[   29.884873]  0000000000000000 ffff880004d2bf08 ffffffff82312111 ffff8800=
04d2bf18
[   29.886082]  ffffffff8109968a ffff880004d2bf38 ffffffff810f72a6 00000000=
000000f0
[   29.897322]  0000000000000000 ffff880004d2bf78 ffffffff81081fa1 00000000=
00000000
[   29.898610] Call Trace:
[   29.899002]  [<ffffffff82312111>] dump_stack+0x19/0x1b
[   29.899845]  [<ffffffff8109968a>] __might_sleep+0x12a/0x140
[   29.900705]  [<ffffffff810f72a6>] might_fault+0x46/0xb0
[   29.901500]  [<ffffffff81081fa1>] SyS_rt_sigprocmask+0x91/0xc0
[   29.902383]  [<ffffffff823207e7>] system_call_fastpath+0x16/0x1b
[   32.907664] BUG: sleeping function called from invalid context at includ=
e/linux/freezer.h:56
[   32.909720] in_atomic(): 0, irqs_disabled(): 0, pid: 180, name: trinity-=
child0
[   32.910715] INFO: lockdep is turned off.
[   32.910715] CPU: 0 PID: 180 Comm: trinity-child0 Not tainted 3.11.0-rc1-=
next-20130719 #50
[   32.910715] Hardware name: Bochs Bochs, BIOS Bochs 01/01/2011
[   32.910715]  ffff880004cdf000 ffff880004d2be60 ffffffff82312111 ffff8800=
04d2be70
[   32.910715]  ffffffff8109968a ffff880004d2bea8 ffffffff8231cc25 00000000=
0000c350
[   32.910715]  0000000000000001 0000000000000ffc ffff880004d2bf40 00000000=
00000ffc
[   32.920715] Call Trace:
[   32.921238]  [<ffffffff82312111>] dump_stack+0x19/0x1b
[   32.921644]  [<ffffffff8109968a>] __might_sleep+0x12a/0x140
[   32.921644]  [<ffffffff8231cc25>] do_nanosleep+0xa5/0x130
[   32.928617]  [<ffffffff81092eb2>] hrtimer_nanosleep+0xb2/0x130
[   32.929751]  [<ffffffff810926e0>] ? __hrtimer_init+0xb0/0xb0
[   32.930746]  [<ffffffff8108e08e>] common_nsleep+0x1e/0x20
[   32.930746]  [<ffffffff8108f6ba>] SyS_clock_nanosleep+0xca/0xe0
[   32.930746]  [<ffffffff823207e7>] system_call_fastpath+0x16/0x1b
[   35.973658] BUG: sleeping function called from invalid context at mm/mem=
ory.c:4228
[   35.975172] in_atomic(): 0, irqs_disabled(): 0, pid: 182, name: trinity-=
child0
[   35.976089] INFO: lockdep is turned off.
[   35.976606] CPU: 0 PID: 182 Comm: trinity-child0 Not tainted 3.11.0-rc1-=
next-20130719 #50
[   35.977647] Hardware name: Bochs Bochs, BIOS Bochs 01/01/2011
[   35.978571]  ffff880004ccff40 ffff880004ccfe90 ffffffff82312111 ffff8800=
04ccfea0
[   35.980225]  ffffffff8109968a ffff880004ccfec0 ffffffff810f72a6 ffff8800=
04ccffd8
[   35.981823]  00000000fffffffa ffff880004ccff20 ffffffff81091e25 00000000=
00000000
[   35.983440] Call Trace:
[   35.983960]  [<ffffffff82312111>] dump_stack+0x19/0x1b
[   35.985009]  [<ffffffff8109968a>] __might_sleep+0x12a/0x140
[   35.986145]  [<ffffffff810f72a6>] might_fault+0x46/0xb0
[   35.987240]  [<ffffffff81091e25>] posix_cpu_nsleep+0xb5/0x100
[   35.988419]  [<ffffffff81091e7e>] process_cpu_nsleep+0xe/0x10
[   35.989587]  [<ffffffff8108f6ba>] SyS_clock_nanosleep+0xca/0xe0
[   35.990816]  [<ffffffff823207e7>] system_call_fastpath+0x16/0x1b
[   45.030518] BUG: sleeping function called from invalid context at mm/mem=
ory.c:4228
[   45.032817] in_atomic(): 0, irqs_disabled(): 0, pid: 188, name: trinity-=
child0
[   45.034497] INFO: lockdep is turned off.
[   45.038967] CPU: 0 PID: 188 Comm: trinity-child0 Not tainted 3.11.0-rc1-=
next-20130719 #50
[   45.039962] Hardware name: Bochs Bochs, BIOS Bochs 01/01/2011
[   45.041689]  0000000000000000 ffff880004d77f08 ffffffff82312111 ffff8800=
04d77f18
[   45.049030]  ffffffff8109968a ffff880004d77f38 ffffffff810f72a6 00000000=
000000f0
[   45.050878]  0000000000000000 ffff880004d77f78 ffffffff81081fa1 00000000=
00000000
[   45.052727] Call Trace:
[   45.053317]  [<ffffffff82312111>] dump_stack+0x19/0x1b
[   45.054523]  [<ffffffff8109968a>] __might_sleep+0x12a/0x140
[   45.058886]  [<ffffffff810f72a6>] might_fault+0x46/0xb0
[   45.059879]  [<ffffffff81081fa1>] SyS_rt_sigprocmask+0x91/0xc0
[   45.059879]  [<ffffffff823207e7>] system_call_fastpath+0x16/0x1b
[   48.072626] BUG: sleeping function called from invalid context at includ=
e/linux/freezer.h:56
[   48.074093] in_atomic(): 0, irqs_disabled(): 0, pid: 188, name: trinity-=
child0
[   48.075095] INFO: lockdep is turned off.
[   48.075656] CPU: 0 PID: 188 Comm: trinity-child0 Not tainted 3.11.0-rc1-=
next-20130719 #50
[   48.076778] Hardware name: Bochs Bochs, BIOS Bochs 01/01/2011
[   48.077677]  ffff880004ce2000 ffff880004d77e60 ffffffff82312111 ffff8800=
04d77e70
[   48.078958]  ffffffff8109968a ffff880004d77ea8 ffffffff8231cc25 00000000=
0000c350
[   48.080200]  0000000000000001 0000000000000ff8 ffff880004d77f40 00000000=
00000ff8
[   48.081770] Call Trace:
[   48.082276]  [<ffffffff82312111>] dump_stack+0x19/0x1b
[   48.083307]  [<ffffffff8109968a>] __might_sleep+0x12a/0x140
[   48.084419]  [<ffffffff8231cc25>] do_nanosleep+0xa5/0x130
[   48.085505]  [<ffffffff81092eb2>] hrtimer_nanosleep+0xb2/0x130
[   48.086675]  [<ffffffff810926e0>] ? __hrtimer_init+0xb0/0xb0
[   48.087670]  [<ffffffff8108e08e>] common_nsleep+0x1e/0x20
[   48.087670]  [<ffffffff8108f6ba>] SyS_clock_nanosleep+0xca/0xe0
[   48.087670]  [<ffffffff823207e7>] system_call_fastpath+0x16/0x1b
[   66.119674] BUG: sleeping function called from invalid context at mm/mem=
ory.c:4228
[   66.121145] in_atomic(): 0, irqs_disabled(): 0, pid: 195, name: trinity-=
child0
[   66.122222] INFO: lockdep is turned off.
[   66.122815] CPU: 0 PID: 195 Comm: trinity-child0 Not tainted 3.11.0-rc1-=
next-20130719 #50
[   66.124024] Hardware name: Bochs Bochs, BIOS Bochs 01/01/2011
[   66.124876]  0000000000000000 ffff880004d77f08 ffffffff82312111 ffff8800=
04d77f18
[   66.126695]  ffffffff8109968a ffff880004d77f38 ffffffff810f72a6 00000000=
000000f0
[   66.128630]  0000000000000000 ffff880004d77f78 ffffffff81081fa1 00000000=
00000000
[   66.139167] Call Trace:
[   66.139846]  [<ffffffff82312111>] dump_stack+0x19/0x1b
[   66.141158]  [<ffffffff8109968a>] __might_sleep+0x12a/0x140
[   66.142508]  [<ffffffff810f72a6>] might_fault+0x46/0xb0
[   66.143779]  [<ffffffff81081fa1>] SyS_rt_sigprocmask+0x91/0xc0
[   66.144772]  [<ffffffff823207e7>] system_call_fastpath+0x16/0x1b
[   67.284125] 99-trinity (159) used greatest stack depth: 5560 bytes left
 * Asking all remaining processes to terminate...      =20
killall5[217]: mount returned non-zero exit status
killall5[217]: /proc not mounted, failed to mount.

mount: proc has wrong device number or fs type proc not supported
killall5[225]: mount returned non-zero exit status
killall5[225]: /proc not mounted, failed to mount.
 * All processes ended within 1 seconds....      =20
/etc/rc6.d/S40umountfs: line 20: /proc/mounts: No such file or directory
cat: /proc/1/maps: No such file or directory
cat: /proc/1/maps: No such file or directory
[   69.152572] BUG: sleeping function called from invalid context at includ=
e/linux/freezer.h:56
[   69.154125] in_atomic(): 0, irqs_disabled(): 0, pid: 195, name: trinity-=
child0
[   69.155166] INFO: lockdep is turned off.
[   69.155744] CPU: 0 PID: 195 Comm: trinity-child0 Not tainted 3.11.0-rc1-=
next-20130719 #50
[   69.156911] Hardware name: Bochs Bochs, BIOS Bochs 01/01/2011
[   69.157684]  ffff880004d77e78 ffff880004d77db0 ffffffff82312111 ffff8800=
04d77dc0
[   69.159046]  ffffffff8109968a ffff880004d77e38 ffffffff8108164e ffff8800=
00000000
[   69.160617]  ffff880004d77e40 ffff880004d77e58 ffff880004dd58c0 00000000=
00000000
[   69.162178] Call Trace:
[   69.162684]  [<ffffffff82312111>] dump_stack+0x19/0x1b
[   69.163712]  [<ffffffff8109968a>] __might_sleep+0x12a/0x140
[   69.164823]  [<ffffffff8108164e>] get_signal_to_deliver+0x6e/0x620
[   69.166055]  [<ffffffff81001f82>] do_signal+0x42/0x510
[   69.169271]  [<ffffffff81002477>] do_notify_resume+0x27/0x60
[   69.170265]  [<ffffffff82320a9a>] int_signal+0x12/0x17
cat: /proc/1/maps: No such file or directory
cat: /proc/1/maps: No such file or directory
cat: /proc/1/maps: No such file or directory
[   72.346566] BUG: sleeping function called from invalid context at includ=
e/linux/freezer.h:56
[   72.347884] in_atomic(): 0, irqs_disabled(): 0, pid: 262, name: trinity-=
child0
[   72.348792] INFO: lockdep is turned off.
[   72.349288] CPU: 0 PID: 262 Comm: trinity-child0 Not tainted 3.11.0-rc1-=
next-20130719 #50
[   72.350317] Hardware name: Bochs Bochs, BIOS Bochs 01/01/2011
[   72.351038]  ffff880004ef7e78 ffff880004ef7db0 ffffffff82312111 ffff8800=
04ef7dc0
[   72.352022]  ffffffff8109968a ffff880004ef7e38 ffffffff8108164e ffff8800=
06343c00
[   72.353848]  ffff880004ef7de8 ffff880004ef7e58 ffff880004e048c0 ffffffff=
810d8ba9
[   72.355433] Call Trace:
[   72.355944]  [<ffffffff82312111>] dump_stack+0x19/0x1b
[   72.357023]  [<ffffffff8109968a>] __might_sleep+0x12a/0x140
[   72.358170]  [<ffffffff8108164e>] get_signal_to_deliver+0x6e/0x620
[   72.359396]  [<ffffffff810d8ba9>] ? generic_file_aio_write+0x89/0xb0
[   72.361011]  [<ffffffff81001f82>] do_signal+0x42/0x510
[   72.362004]  [<ffffffff820ef96f>] ? __sys_recvmmsg+0xdf/0x220
[   72.362004]  [<ffffffff81002477>] do_notify_resume+0x27/0x60
[   72.362004]  [<ffffffff82320a9a>] int_signal+0x12/0x17
[   72.373706] trinity-child0 (262) used greatest stack depth: 5424 bytes l=
eft
cat: /proc/1/maps: No such file or directory
umount: /var/run: not mounted
umount: /var/lock: not mounted
umount: /dev/shm: not mounted
mount: / is busy
 * Will now restart
[   72.711996] Unregister pv shared memory for cpu 0
[   72.719030] no ifx modem active;
[   72.738583] reboot: Restarting system
[   72.739325] reboot: machine restart
Elapsed time: 80
qemu-system-x86_64 -cpu kvm64 -enable-kvm -kernel /tmp//kernel/x86_64-randc=
onfig-x02-0719/c1f631b9a68251007a6353041ae90f9f7dca771c/vmlinuz-3.11.0-rc1-=
next-20130719-6308 -append 'hung_task_panic=3D1 rcutree.rcu_cpu_stall_timeo=
ut=3D100 log_buf_len=3D8M ignore_loglevel debug sched_debug apic=3Ddebug dy=
namic_printk sysrq_always_enabled panic=3D10  prompt_ramdisk=3D0 console=3D=
ttyS0,115200 console=3Dtty0 vga=3Dnormal  root=3D/dev/ram0 rw link=3D/kerne=
l-tests/run-queue/kvm/x86_64-randconfig-x02-0719/next:master/.vmlinuz-c1f63=
1b9a68251007a6353041ae90f9f7dca771c-20130719215229-9-inn branch=3Dnext/mast=
er  BOOT_IMAGE=3D/kernel/x86_64-randconfig-x02-0719/c1f631b9a68251007a63530=
41ae90f9f7dca771c/vmlinuz-3.11.0-rc1-next-20130719'  -initrd /kernel-tests/=
initrd/quantal-core-x86_64.cgz -m 256M -smp 2 -net nic,vlan=3D0,macaddr=3D0=
0:00:00:00:00:00,model=3Dvirtio -net user,vlan=3D0,hostfwd=3Dtcp::10404-:22=
 -net nic,vlan=3D1,model=3De1000 -net user,vlan=3D1 -boot order=3Dnc -no-re=
boot -watchdog i6300esb -drive file=3D/fs/LABEL=3DKVM/disk0-inn-6308,media=
=3Ddisk,if=3Dvirtio -drive file=3D/fs/LABEL=3DKVM/disk1-inn-6308,media=3Ddi=
sk,if=3Dvirtio -drive file=3D/fs/LABEL=3DKVM/disk2-inn-6308,media=3Ddisk,if=
=3Dvirtio -drive file=3D/fs/LABEL=3DKVM/disk3-inn-6308,media=3Ddisk,if=3Dvi=
rtio -drive file=3D/fs/LABEL=3DKVM/disk4-inn-6308,media=3Ddisk,if=3Dvirtio =
-drive file=3D/fs/LABEL=3DKVM/disk5-inn-6308,media=3Ddisk,if=3Dvirtio -pidf=
ile /dev/shm/kboot/pid-inn-lkp-6308 -serial file:/dev/shm/kboot/serial-inn-=
lkp-6308 -daemonize -display none -monitor null=20

--ZoaI/ZTpAVc4A5k6
Content-Type: application/octet-stream
Content-Disposition: attachment; filename="bisect-c1f631b9a68251007a6353041ae90f9f7dca771c-x86_64-randconfig-x02-0719-BUG:-lock-held-when-returning-to-user-space-88052.log"
Content-Transfer-Encoding: base64

Z2l0IGNoZWNrb3V0IGQwMzc5MmY5ZGI5Yjg5MmY0OTRkM2FhMTlkNzY3ZGRmMDM2NWQxZmYK
UHJldmlvdXMgSEVBRCBwb3NpdGlvbiB3YXMgYzFmNjMxYi4uLiBBZGQgbGludXgtbmV4dCBz
cGVjaWZpYyBmaWxlcyBmb3IgMjAxMzA3MTkKSEVBRCBpcyBub3cgYXQgZDAzNzkyZi4uLiBN
ZXJnZSByZW1vdGUtdHJhY2tpbmcgYnJhbmNoICdhaW8vbWFzdGVyJwpscyAtYSAva2VybmVs
LXRlc3RzL3J1bi1xdWV1ZS9rdm0veDg2XzY0LXJhbmRjb25maWcteDAyLTA3MTkvbmV4dDpt
YXN0ZXI6ZDAzNzkyZjlkYjliODkyZjQ5NGQzYWExOWQ3NjdkZGYwMzY1ZDFmZjpiaXNlY3Qt
dXNiCgoyMDEzLTA3LTIwLTA5OjAzOjM2IGQwMzc5MmY5ZGI5Yjg5MmY0OTRkM2FhMTlkNzY3
ZGRmMDM2NWQxZmYgcmV1c2UgL2tlcm5lbC94ODZfNjQtcmFuZGNvbmZpZy14MDItMDcxOS9k
MDM3OTJmOWRiOWI4OTJmNDk0ZDNhYTE5ZDc2N2RkZjAzNjVkMWZmL3ZtbGludXotMy4xMS4w
LXJjMS0wMTM2OS1nZDAzNzkyZgoKMjAxMy0wNy0yMC0wOTowMzozNiBkZXRlY3RpbmcgYm9v
dCBzdGF0ZSAuLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4u
LgkzMS4uLi4uLi4uLi4uLgkzMi4uLi4uLi4uLi4uCTMzLi4uCTM0CTM2LgkzNy4uLi4uLi4u
Li4uCTM4Li4JMzkJNDAuLgk0MS4JNDIuLgk0My4uLi4uLi4uLi4JNDQuLi4uCTQ2Li4JNDcJ
NDkuLi4JNTEuCTUyLi4uLi4uCTUzCTU0Li4uLi4JNTUJNTYJNTcJNTguLi4uLi4JNjAJNjEu
Li4uLi4uCTYyLgk2My4JNjQuLi4uCTY1IFNVQ0NFU1MKCmJpc2VjdDogZ29vZCBjb21taXQg
ZDAzNzkyZjlkYjliODkyZjQ5NGQzYWExOWQ3NjdkZGYwMzY1ZDFmZgpnaXQgYmlzZWN0IHN0
YXJ0IGMxZjYzMWI5YTY4MjUxMDA3YTYzNTMwNDFhZTkwZjlmN2RjYTc3MWMgZDAzNzkyZjlk
YjliODkyZjQ5NGQzYWExOWQ3NjdkZGYwMzY1ZDFmZiAtLQpQcmV2aW91cyBIRUFEIHBvc2l0
aW9uIHdhcyBkMDM3OTJmLi4uIE1lcmdlIHJlbW90ZS10cmFja2luZyBicmFuY2ggJ2Fpby9t
YXN0ZXInCkhFQUQgaXMgbm93IGF0IGMxYmU1YTUuLi4gTGludXggMy45CkJpc2VjdGluZzog
NzYgcmV2aXNpb25zIGxlZnQgdG8gdGVzdCBhZnRlciB0aGlzIChyb3VnaGx5IDYgc3RlcHMp
ClsxMGEzZjFmOTAyNDY1YWUxMzIwY2M5NWEzMjg0ZmQzNjk3ZTA1ZGQ4XSBiaW5mbXRfZWxm
LmM6IHVzZSBnZXRfcmFuZG9tX2ludCgpIHRvIGZpeCBlbnRyb3B5IGRlcGxldGluZwpnaXQg
YmlzZWN0IHJ1biAvYy9rZXJuZWwtdGVzdHMvYmlzZWN0LXRlc3QtYm9vdC1mYWlsdXJlLnNo
IC9ob21lL3dmZy91c2Ivb2JqLWJpc2VjdApydW5uaW5nIC9jL2tlcm5lbC10ZXN0cy9iaXNl
Y3QtdGVzdC1ib290LWZhaWx1cmUuc2ggL2hvbWUvd2ZnL3VzYi9vYmotYmlzZWN0CmxzIC1h
IC9rZXJuZWwtdGVzdHMvcnVuLXF1ZXVlL2t2bS94ODZfNjQtcmFuZGNvbmZpZy14MDItMDcx
OS9uZXh0Om1hc3RlcjoxMGEzZjFmOTAyNDY1YWUxMzIwY2M5NWEzMjg0ZmQzNjk3ZTA1ZGQ4
OmJpc2VjdC11c2IKCjIwMTMtMDctMjAtMTA6MzA6MDMgMTBhM2YxZjkwMjQ2NWFlMTMyMGNj
OTVhMzI4NGZkMzY5N2UwNWRkOCBjb21waWxpbmcKMTM0MCByZWFsICAyNDEzIHVzZXIgIDIw
MiBzeXMgIDE5NS4xNSUgY3B1IAl4ODZfNjQtcmFuZGNvbmZpZy14MDItMDcxOQoKMjAxMy0w
Ny0yMC0xMDo1NTozOCBkZXRlY3RpbmcgYm9vdCBzdGF0ZSAzLjExLjAtcmMxLTEwMzM0LWcx
MGEzZjFmLi4JNQkxMy4uLgkxNgkzOQk0My4JNDQJNDcuLgk0OC4JNTIJNjEuLi4uLi4uLi4u
Li4uLi4uCTYzCTY1IFNVQ0NFU1MKCkJpc2VjdGluZzogMzggcmV2aXNpb25zIGxlZnQgdG8g
dGVzdCBhZnRlciB0aGlzIChyb3VnaGx5IDUgc3RlcHMpCltkYWMyODc4ODM3ODgzOGVmYjYz
ZTM3YTdlYWJkNzcyOWQ5N2FiYTZiXSBkY2FjaGU6IHJlbW92ZSBkZW50cmllcyBmcm9tIExS
VSBiZWZvcmUgcHV0dGluZyBvbiBkaXNwb3NlIGxpc3QKcnVubmluZyAvYy9rZXJuZWwtdGVz
dHMvYmlzZWN0LXRlc3QtYm9vdC1mYWlsdXJlLnNoIC9ob21lL3dmZy91c2Ivb2JqLWJpc2Vj
dApscyAtYSAva2VybmVsLXRlc3RzL3J1bi1xdWV1ZS9rdm0veDg2XzY0LXJhbmRjb25maWct
eDAyLTA3MTkvbmV4dDptYXN0ZXI6ZGFjMjg3ODgzNzg4MzhlZmI2M2UzN2E3ZWFiZDc3Mjlk
OTdhYmE2YjpiaXNlY3QtdXNiCgoyMDEzLTA3LTIwLTExOjE0OjExIGRhYzI4Nzg4Mzc4ODM4
ZWZiNjNlMzdhN2VhYmQ3NzI5ZDk3YWJhNmIgY29tcGlsaW5nCjgwNCByZWFsICAyNDMxIHVz
ZXIgIDE5NSBzeXMgIDMyNi42OCUgY3B1IAl4ODZfNjQtcmFuZGNvbmZpZy14MDItMDcxOQoK
MjAxMy0wNy0yMC0xMToyOTo1OSBkZXRlY3RpbmcgYm9vdCBzdGF0ZSAzLjExLjAtcmMxLTEx
NjU5LWdkYWMyODc4Li4uLi4gVEVTVCBGQUlMVVJFClsgICAxNi45OTUxNjddIApbICAgMTYu
OTk1MzkzXSA9PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09
PT0KWyAgIDE2Ljk5NjEyOF0gWyBCVUc6IGxvY2sgaGVsZCB3aGVuIHJldHVybmluZyB0byB1
c2VyIHNwYWNlISBdClsgICAxNi45OTY4MzldIDMuMTEuMC1yYzEtMTE2NTktZ2RhYzI4Nzgg
IzIyMSBOb3QgdGFpbnRlZApbICAgMTYuOTk3NDc3XSAtLS0tLS0tLS0tLS0tLS0tLS0tLS0t
LS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0KWyAgIDE2Ljk5ODE4Nl0gdHJpbml0eS1jaGls
ZDAvMTc0IGlzIGxlYXZpbmcgdGhlIGtlcm5lbCB3aXRoIGxvY2tzIHN0aWxsIGhlbGQhClsg
ICAxNi45OTkwNTBdIDEgbG9jayBoZWxkIGJ5IHRyaW5pdHktY2hpbGQwLzE3NDoKWyAgIDE2
Ljk5OTYwMF0gICMwOiAgKHJjdV9yZWFkX2xvY2spey4rLisuLn0sIGF0OiBbPGZmZmZmZmZm
ODE0YTgzZDE+XSBkb19zaG1hdCsweGUxLzB4NTAwCi9rZXJuZWwveDg2XzY0LXJhbmRjb25m
aWcteDAyLTA3MTkvZGFjMjg3ODgzNzg4MzhlZmI2M2UzN2E3ZWFiZDc3MjlkOTdhYmE2Yi9k
bWVzZy1rdm0tbmhtLTM2ODMtMjAxMzA3MjAxMDU5MDQtMy4xMS4wLXJjMS0xMTY1OS1nZGFj
Mjg3OC0yMjEKCkJpc2VjdGluZzogMTggcmV2aXNpb25zIGxlZnQgdG8gdGVzdCBhZnRlciB0
aGlzIChyb3VnaGx5IDQgc3RlcHMpClszMTQwYjJlZDZkZmU1YzllNWVjYTM3MWM3N2NhODVk
Y2EwNTMyMWQ0XSBpcGMsc2htOiBpbnRyb2R1Y2Ugc2htY3RsX25vbG9jawpydW5uaW5nIC9j
L2tlcm5lbC10ZXN0cy9iaXNlY3QtdGVzdC1ib290LWZhaWx1cmUuc2ggL2hvbWUvd2ZnL3Vz
Yi9vYmotYmlzZWN0CmxzIC1hIC9rZXJuZWwtdGVzdHMvcnVuLXF1ZXVlL2t2bS94ODZfNjQt
cmFuZGNvbmZpZy14MDItMDcxOS9uZXh0Om1hc3RlcjozMTQwYjJlZDZkZmU1YzllNWVjYTM3
MWM3N2NhODVkY2EwNTMyMWQ0OmJpc2VjdC11c2IKCjIwMTMtMDctMjAtMTE6MzI6MzEgMzE0
MGIyZWQ2ZGZlNWM5ZTVlY2EzNzFjNzdjYTg1ZGNhMDUzMjFkNCByZXVzZSAva2VybmVsL3g4
Nl82NC1yYW5kY29uZmlnLXgwMi0wNzE5LzMxNDBiMmVkNmRmZTVjOWU1ZWNhMzcxYzc3Y2E4
NWRjYTA1MzIxZDQvdm1saW51ei0zLjExLjAtcmMxLTAwMTc4LWczMTQwYjJlCgoyMDEzLTA3
LTIwLTExOjMyOjMxIGRldGVjdGluZyBib290IHN0YXRlIC4uLgkyLgkzCTQJNS4uLgk4CTEw
CTExLgkxMgkxNAkxNS4uCTE2CTIwCTIzCTI4CTM2CTQwCTQ1CTUzCTU5CTYxCTYyCTYzCTY0
Li4JNjUgU1VDQ0VTUwoKQmlzZWN0aW5nOiA5IHJldmlzaW9ucyBsZWZ0IHRvIHRlc3QgYWZ0
ZXIgdGhpcyAocm91Z2hseSAzIHN0ZXBzKQpbNDhhOTEyNDg2NDlmYTMzMjdiZDhhMzFjMTE0
ZWU5MTQ5YTA3ZjNhN10gc3RhZ2luZy9sdXN0cmUvbGRsbTogY29udmVydCB0byBzaHJpbmtl
cnMgdG8gY291bnQvc2NhbiBBUEkKcnVubmluZyAvYy9rZXJuZWwtdGVzdHMvYmlzZWN0LXRl
c3QtYm9vdC1mYWlsdXJlLnNoIC9ob21lL3dmZy91c2Ivb2JqLWJpc2VjdApscyAtYSAva2Vy
bmVsLXRlc3RzL3J1bi1xdWV1ZS9rdm0veDg2XzY0LXJhbmRjb25maWcteDAyLTA3MTkvbmV4
dDptYXN0ZXI6NDhhOTEyNDg2NDlmYTMzMjdiZDhhMzFjMTE0ZWU5MTQ5YTA3ZjNhNzpiaXNl
Y3QtdXNiCgoyMDEzLTA3LTIwLTExOjUwOjM0IDQ4YTkxMjQ4NjQ5ZmEzMzI3YmQ4YTMxYzEx
NGVlOTE0OWEwN2YzYTcgY29tcGlsaW5nCjQxMyByZWFsICAyNDI5IHVzZXIgIDE5NSBzeXMg
IDYzNC42OCUgY3B1IAl4ODZfNjQtcmFuZGNvbmZpZy14MDItMDcxOQoKMjAxMy0wNy0yMC0x
MjowMjoxOSBkZXRlY3RpbmcgYm9vdCBzdGF0ZSAzLjExLjAtcmMxLTEwMzYyLWc0OGE5MTI0
Li4uLi4gVEVTVCBGQUlMVVJFClsgICAxMC45NTE1NTJdIApbICAgMTAuOTUxNzQ1XSA9PT09
PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT0KWyAgIDEwLjk1
MjM2N10gWyBCVUc6IGxvY2sgaGVsZCB3aGVuIHJldHVybmluZyB0byB1c2VyIHNwYWNlISBd
ClsgICAxMC45NTI5ODZdIDMuMTEuMC1yYzEtMTAzNjItZzQ4YTkxMjQgIzIyMiBOb3QgdGFp
bnRlZApbICAgMTAuOTUzNTc2XSAtLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0t
LS0tLS0tLS0tLS0tLS0KWyAgIDEwLjk1NDIwMF0gdHJpbml0eS1jaGlsZDAvMTczIGlzIGxl
YXZpbmcgdGhlIGtlcm5lbCB3aXRoIGxvY2tzIHN0aWxsIGhlbGQhClsgICAxMC45NTQ5NDhd
IDEgbG9jayBoZWxkIGJ5IHRyaW5pdHktY2hpbGQwLzE3MzoKWyAgIDEwLjk1NTQ0NF0gICMw
OiAgKHJjdV9yZWFkX2xvY2spey4rLisuLn0sIGF0OiBbPGZmZmZmZmZmODE0YTM5YTE+XSBk
b19zaG1hdCsweGUxLzB4NTAwCi9rZXJuZWwveDg2XzY0LXJhbmRjb25maWcteDAyLTA3MTkv
NDhhOTEyNDg2NDlmYTMzMjdiZDhhMzFjMTE0ZWU5MTQ5YTA3ZjNhNy9kbWVzZy1rdm0ta2J1
aWxkLTE3MzUzLTIwMTMwNzIwMTIwNTU4LTMuMTEuMC1yYzEtMTAzNjItZzQ4YTkxMjQtMjIy
Ci9rZXJuZWwveDg2XzY0LXJhbmRjb25maWcteDAyLTA3MTkvNDhhOTEyNDg2NDlmYTMzMjdi
ZDhhMzFjMTE0ZWU5MTQ5YTA3ZjNhNy9kbWVzZy1rdm0ta2J1aWxkLTQ5NTk2LTIwMTMwNzIw
MTIwNjIyLTMuMTEuMC1yYzEtMDAwMTMtZ2E2NDRhN2UtMTQxCgpCaXNlY3Rpbmc6IDQgcmV2
aXNpb25zIGxlZnQgdG8gdGVzdCBhZnRlciB0aGlzIChyb3VnaGx5IDIgc3RlcHMpCls5OGI3
ODEyNmE1MWFhNWQzZWU2ZDVkYWU1NzY4ZTBkMTZkZWVlYWEzXSBpcGMsc2htOiBjbGVhbnVw
IGRvX3NobWF0IHBhc3RhCnJ1bm5pbmcgL2Mva2VybmVsLXRlc3RzL2Jpc2VjdC10ZXN0LWJv
b3QtZmFpbHVyZS5zaCAvaG9tZS93ZmcvdXNiL29iai1iaXNlY3QKbHMgLWEgL2tlcm5lbC10
ZXN0cy9ydW4tcXVldWUva3ZtL3g4Nl82NC1yYW5kY29uZmlnLXgwMi0wNzE5L25leHQ6bWFz
dGVyOjk4Yjc4MTI2YTUxYWE1ZDNlZTZkNWRhZTU3NjhlMGQxNmRlZWVhYTM6YmlzZWN0LXVz
YgoKMjAxMy0wNy0yMC0xMjowNDo1MSA5OGI3ODEyNmE1MWFhNWQzZWU2ZDVkYWU1NzY4ZTBk
MTZkZWVlYWEzIHJldXNlIC9rZXJuZWwveDg2XzY0LXJhbmRjb25maWcteDAyLTA3MTkvOThi
NzgxMjZhNTFhYTVkM2VlNmQ1ZGFlNTc2OGUwZDE2ZGVlZWFhMy92bWxpbnV6LTMuMTEuMC1y
YzEtMDAxODItZzk4Yjc4MTIKCjIwMTMtMDctMjAtMTI6MDQ6NTEgZGV0ZWN0aW5nIGJvb3Qg
c3RhdGUgLi4uLi4JMgkzCTcJMjMJNTcJNjMuLi4uLgk2NC4JNjUgU1VDQ0VTUwoKQmlzZWN0
aW5nOiAyIHJldmlzaW9ucyBsZWZ0IHRvIHRlc3QgYWZ0ZXIgdGhpcyAocm91Z2hseSAxIHN0
ZXApClszNmNjZmQ3OTljYWQzM2UyZWRkNWMxNGFjODc3NmIzM2U2M2QxOTViXSBpcGM6IHJl
bmFtZSBpZHMtPnJ3X211dGV4CnJ1bm5pbmcgL2Mva2VybmVsLXRlc3RzL2Jpc2VjdC10ZXN0
LWJvb3QtZmFpbHVyZS5zaCAvaG9tZS93ZmcvdXNiL29iai1iaXNlY3QKbHMgLWEgL2tlcm5l
bC10ZXN0cy9ydW4tcXVldWUva3ZtL3g4Nl82NC1yYW5kY29uZmlnLXgwMi0wNzE5L25leHQ6
bWFzdGVyOjM2Y2NmZDc5OWNhZDMzZTJlZGQ1YzE0YWM4Nzc2YjMzZTYzZDE5NWI6YmlzZWN0
LXVzYgogVEVTVCBGQUlMVVJFClsgICAyNi4wMzg2OTJdIApbICAgMjYuMDM5NTU0XSA9PT09
PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT0KWyAgIDI2LjA0
MjIzOF0gWyBCVUc6IGxvY2sgaGVsZCB3aGVuIHJldHVybmluZyB0byB1c2VyIHNwYWNlISBd
ClsgICAyNi4wNDU1MDRdIDMuMTEuMC1yYzEtMDAxODQtZzM2Y2NmZDcgIzQ0IE5vdCB0YWlu
dGVkClsgICAyNi4wNDY0NzldIC0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0t
LS0tLS0tLS0tLS0tLQpbICAgMjYuMDQ2NDc5XSB0cmluaXR5LWNoaWxkMC8xNzMgaXMgbGVh
dmluZyB0aGUga2VybmVsIHdpdGggbG9ja3Mgc3RpbGwgaGVsZCEKWyAgIDI2LjA0NjQ3OV0g
MSBsb2NrIGhlbGQgYnkgdHJpbml0eS1jaGlsZDAvMTczOgpbICAgMjYuMDYyNDE4XSAgIzA6
ICAocmN1X3JlYWRfbG9jayl7LisuKy4ufSwgYXQ6IFs8ZmZmZmZmZmY4MTRhMzlhMT5dIGRv
X3NobWF0KzB4ZTEvMHg1MDAKL2tlcm5lbC94ODZfNjQtcmFuZGNvbmZpZy14MDItMDcxOS8z
NmNjZmQ3OTljYWQzM2UyZWRkNWMxNGFjODc3NmIzM2U2M2QxOTViL2RtZXNnLWt2bS1rYnVp
bGQtMTczNTMtMjAxMzA3MTkyMzA5NTEtMy4xMS4wLXJjMS0wMDE4NC1nMzZjY2ZkNy00NAoK
QmlzZWN0aW5nOiAwIHJldmlzaW9ucyBsZWZ0IHRvIHRlc3QgYWZ0ZXIgdGhpcyAocm91Z2hs
eSAwIHN0ZXBzKQpbYzVkMDI4MmEwNDA1YjBhODFmYTMzOTBlNDIzMGU0Y2JiM2NlZDdhMl0g
aXBjLHNobTogc2hvcnRlbiBjcml0aWNhbCByZWdpb24gZm9yIHNobWF0CnJ1bm5pbmcgL2Mv
a2VybmVsLXRlc3RzL2Jpc2VjdC10ZXN0LWJvb3QtZmFpbHVyZS5zaCAvaG9tZS93ZmcvdXNi
L29iai1iaXNlY3QKbHMgLWEgL2tlcm5lbC10ZXN0cy9ydW4tcXVldWUva3ZtL3g4Nl82NC1y
YW5kY29uZmlnLXgwMi0wNzE5L25leHQ6bWFzdGVyOmM1ZDAyODJhMDQwNWIwYTgxZmEzMzkw
ZTQyMzBlNGNiYjNjZWQ3YTI6YmlzZWN0LXVzYgogVEVTVCBGQUlMVVJFClsgICAyOC41MDg4
NzFdIApbICAgMjguNTA5NzU4XSA9PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09
PT09PT09PT09PT09PT0KWyAgIDI4LjUxMjg2Ml0gWyBCVUc6IGxvY2sgaGVsZCB3aGVuIHJl
dHVybmluZyB0byB1c2VyIHNwYWNlISBdClsgICAyOC41MTg5MTNdIDMuMTEuMC1yYzEtMDAx
ODMtZ2M1ZDAyODIgIzQzIE5vdCB0YWludGVkClsgICAyOC41MjAxNjFdIC0tLS0tLS0tLS0t
LS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLQpbICAgMjguNTIzMTQ1XSB0
cmluaXR5LWNoaWxkMC8xNzMgaXMgbGVhdmluZyB0aGUga2VybmVsIHdpdGggbG9ja3Mgc3Rp
bGwgaGVsZCEKWyAgIDI4LjUyNDEzM10gMSBsb2NrIGhlbGQgYnkgdHJpbml0eS1jaGlsZDAv
MTczOgpbICAgMjguNTI0MTMzXSAgIzA6ICAocmN1X3JlYWRfbG9jayl7LisuKy4ufSwgYXQ6
IFs8ZmZmZmZmZmY4MTRhMzlhMT5dIGRvX3NobWF0KzB4ZTEvMHg1MDAKL2tlcm5lbC94ODZf
NjQtcmFuZGNvbmZpZy14MDItMDcxOS9jNWQwMjgyYTA0MDViMGE4MWZhMzM5MGU0MjMwZTRj
YmIzY2VkN2EyL2RtZXNnLWt2bS1pbm4tMzkyNi0yMDEzMDcxOTIzMTEwMi0zLjExLjAtcmMx
LTAwMTgzLWdjNWQwMjgyLTQzCgpjNWQwMjgyYTA0MDViMGE4MWZhMzM5MGU0MjMwZTRjYmIz
Y2VkN2EyIGlzIHRoZSBmaXJzdCBiYWQgY29tbWl0CmNvbW1pdCBjNWQwMjgyYTA0MDViMGE4
MWZhMzM5MGU0MjMwZTRjYmIzY2VkN2EyCkF1dGhvcjogRGF2aWRsb2hyIEJ1ZXNvIDxkYXZp
ZGxvaHIuYnVlc29AaHAuY29tPgpEYXRlOiAgIEZyaSBKdWwgMTkgMDk6NTY6NTggMjAxMyAr
MTAwMAoKICAgIGlwYyxzaG06IHNob3J0ZW4gY3JpdGljYWwgcmVnaW9uIGZvciBzaG1hdAog
ICAgCiAgICBTaW1pbGFyIHRvIG90aGVyIHN5c3RlbSBjYWxscywgYWNxdWlyZSB0aGUga2Vy
bl9pcGNfcGVybSBsb2NrIGFmdGVyIGRvaW5nCiAgICB0aGUgaW5pdGlhbCBwZXJtaXNzaW9u
IGFuZCBzZWN1cml0eSBjaGVja3MuCiAgICAKICAgIFNpZ25lZC1vZmYtYnk6IERhdmlkbG9o
ciBCdWVzbyA8ZGF2aWRsb2hyLmJ1ZXNvQGhwLmNvbT4KICAgIFRlc3RlZC1ieTogU2VkYXQg
RGlsZWsgPHNlZGF0LmRpbGVrQGdtYWlsLmNvbT4KICAgIENjOiBSaWsgdmFuIFJpZWwgPHJp
ZWxAcmVkaGF0LmNvbT4KICAgIENjOiBNYW5mcmVkIFNwcmF1bCA8bWFuZnJlZEBjb2xvcmZ1
bGxpZmUuY29tPgogICAgU2lnbmVkLW9mZi1ieTogQW5kcmV3IE1vcnRvbiA8YWtwbUBsaW51
eC1mb3VuZGF0aW9uLm9yZz4KCjowNDAwMDAgMDQwMDAwIDg4YTk3YzlmNTkwMjAzOTdlYTVi
MTE5MWYxZmQ4YWUyYjExZmFjYmYgYmM3YzU5MTc1NTM2ZjMzNjRhYTMxZjY0OTJhMDczZTk4
NjA1YzcyZCBNCWlwYwpiaXNlY3QgcnVuIHN1Y2Nlc3MKbHMgLWEgL2tlcm5lbC10ZXN0cy9y
dW4tcXVldWUva3ZtL3g4Nl82NC1yYW5kY29uZmlnLXgwMi0wNzE5L25leHQ6bWFzdGVyOjk4
Yjc4MTI2YTUxYWE1ZDNlZTZkNWRhZTU3NjhlMGQxNmRlZWVhYTM6YmlzZWN0LXVzYgoKMjAx
My0wNy0yMC0xMjoxNDozMCA5OGI3ODEyNmE1MWFhNWQzZWU2ZDVkYWU1NzY4ZTBkMTZkZWVl
YWEzIHJldXNlIC9rZXJuZWwveDg2XzY0LXJhbmRjb25maWcteDAyLTA3MTkvOThiNzgxMjZh
NTFhYTVkM2VlNmQ1ZGFlNTc2OGUwZDE2ZGVlZWFhMy92bWxpbnV6LTMuMTEuMC1yYzEtMDAx
ODItZzk4Yjc4MTIKCjIwMTMtMDctMjAtMTI6MTQ6MzIgZGV0ZWN0aW5nIGJvb3Qgc3RhdGUg
Li4uLi4JNjcJNzEJOTIJMTIwCTEzNQkxNzQJMTg4LgkxODkJMTkxLgkxOTMuLi4uLi4uLi4u
Li4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4u
Li4uLi4uLi4uLi4uCTE5NC4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4u
Li4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4u
Li4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4u
Li4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4u
Li4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4u
Li4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4bWzE7MzVt
YWRkX3RvX3J1bl9xdWV1ZSAxG1swbQouLgkxOTUgU1VDQ0VTUwoKbHMgLWEgL2tlcm5lbC10
ZXN0cy9ydW4tcXVldWUva3ZtL3g4Nl82NC1yYW5kY29uZmlnLXgwMi0wNzE5L25leHQ6bWFz
dGVyOmMxZjYzMWI5YTY4MjUxMDA3YTYzNTMwNDFhZTkwZjlmN2RjYTc3MWM6YmlzZWN0LXVz
YgogVEVTVCBGQUlMVVJFClsgICAxNy4yMDM2MzBdIApbICAgMTcuMjA0NDQ3XSA9PT09PT09
PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT0KWyAgIDE3LjIwNzEw
NF0gWyBCVUc6IGxvY2sgaGVsZCB3aGVuIHJldHVybmluZyB0byB1c2VyIHNwYWNlISBdClsg
ICAxNy4yMDk5MjddIDMuMTEuMC1yYzEtbmV4dC0yMDEzMDcxOSAjNTAgTm90IHRhaW50ZWQK
WyAgIDE3LjIxMjIzMV0gLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0t
LS0tLS0tLS0tClsgICAxNy4yMTMzODldIHRyaW5pdHktY2hpbGQwLzE3NSBpcyBsZWF2aW5n
IHRoZSBrZXJuZWwgd2l0aCBsb2NrcyBzdGlsbCBoZWxkIQpbICAgMTcuMjE0Mzg0XSAxIGxv
Y2sgaGVsZCBieSB0cmluaXR5LWNoaWxkMC8xNzU6ClsgICAxNy4yMTQzODRdICAjMDogIChy
Y3VfcmVhZF9sb2NrKXsuKy4rLi59LCBhdDogWzxmZmZmZmZmZjgxNGE4NDkxPl0gZG9fc2ht
YXQrMHhlMS8weDUwMAova2VybmVsL3g4Nl82NC1yYW5kY29uZmlnLXgwMi0wNzE5L2MxZjYz
MWI5YTY4MjUxMDA3YTYzNTMwNDFhZTkwZjlmN2RjYTc3MWMvZG1lc2cta3ZtLWF0aGVucy0z
ODU4LTIwMTMwNzIwMDkyMzE3LTMuMTEuMC1yYzEtbmV4dC0yMDEzMDcxOS01MAova2VybmVs
L3g4Nl82NC1yYW5kY29uZmlnLXgwMi0wNzE5L2MxZjYzMWI5YTY4MjUxMDA3YTYzNTMwNDFh
ZTkwZjlmN2RjYTc3MWMvZG1lc2cta3ZtLWlubi02MzA4LTIwMTMwNzE5MjIwNDMzLTMuMTEu
MC1yYzEtbmV4dC0yMDEzMDcxOS01MAova2VybmVsL3g4Nl82NC1yYW5kY29uZmlnLXgwMi0w
NzE5L2MxZjYzMWI5YTY4MjUxMDA3YTYzNTMwNDFhZTkwZjlmN2RjYTc3MWMvZG1lc2cta3Zt
LWlubi04NzY0LTIwMTMwNzE5MjI0OTU4LTMuMTEuMC1yYzEtbmV4dC0yMDEzMDcxOS01MAov
a2VybmVsL3g4Nl82NC1yYW5kY29uZmlnLXgwMi0wNzE5L2MxZjYzMWI5YTY4MjUxMDA3YTYz
NTMwNDFhZTkwZjlmN2RjYTc3MWMvZG1lc2cta3ZtLWtidWlsZC0xMDc1MS0yMDEzMDcxOTIy
NDQ0MS0zLjExLjAtcmMxLTAwMDA0LWdiOGViZmQzLTE2Ci9rZXJuZWwveDg2XzY0LXJhbmRj
b25maWcteDAyLTA3MTkvYzFmNjMxYjlhNjgyNTEwMDdhNjM1MzA0MWFlOTBmOWY3ZGNhNzcx
Yy9kbWVzZy1rdm0ta2J1aWxkLTI5MDUxLTIwMTMwNzIwMDk1MzU4LTMuMTEuMC1yYzEtMDAx
NTQtZzA4ODdhNTctNzUKL2tlcm5lbC94ODZfNjQtcmFuZGNvbmZpZy14MDItMDcxOS9jMWY2
MzFiOWE2ODI1MTAwN2E2MzUzMDQxYWU5MGY5ZjdkY2E3NzFjL2RtZXNnLWt2bS1rYnVpbGQt
MzM0ODctMjAxMzA3MjAxMDA1NTQtMy4xMS4wLXJjMS0wMDE3NC1nYzEwZmI1Zi0xMQova2Vy
bmVsL3g4Nl82NC1yYW5kY29uZmlnLXgwMi0wNzE5L2MxZjYzMWI5YTY4MjUxMDA3YTYzNTMw
NDFhZTkwZjlmN2RjYTc3MWMvZG1lc2cta3ZtLWtidWlsZC0zNTMzNi0yMDEzMDcxOTIyNDQz
NS0zLjExLjAtcmMxLTAwMzM2LWdjOWQwZThjLTUyCi9rZXJuZWwveDg2XzY0LXJhbmRjb25m
aWcteDAyLTA3MTkvYzFmNjMxYjlhNjgyNTEwMDdhNjM1MzA0MWFlOTBmOWY3ZGNhNzcxYy9k
bWVzZy1rdm0ta2J1aWxkLTQxMzA0LTIwMTMwNzIwMDk0MzEzLS0KL2tlcm5lbC94ODZfNjQt
cmFuZGNvbmZpZy14MDItMDcxOS9jMWY2MzFiOWE2ODI1MTAwN2E2MzUzMDQxYWU5MGY5Zjdk
Y2E3NzFjL2RtZXNnLWt2bS1rYnVpbGQtNDIzNTYtMjAxMzA3MjAwOTUzNDItMy4xMS4wLXJj
MS0wMDE3MC1nZmJmNjA4OC0zCi9rZXJuZWwveDg2XzY0LXJhbmRjb25maWcteDAyLTA3MTkv
YzFmNjMxYjlhNjgyNTEwMDdhNjM1MzA0MWFlOTBmOWY3ZGNhNzcxYy9kbWVzZy1rdm0ta2J1
aWxkLTQ0MTE4LTIwMTMwNzE5MjIzNjQ5LTMuMTEuMC1yYzEtbmV4dC0yMDEzMDcxOS01MAov
a2VybmVsL3g4Nl82NC1yYW5kY29uZmlnLXgwMi0wNzE5L2MxZjYzMWI5YTY4MjUxMDA3YTYz
NTMwNDFhZTkwZjlmN2RjYTc3MWMvZG1lc2cta3ZtLWtidWlsZC00NjY0Ny0yMDEzMDcyMDA5
NTI1Ni0zLjExLjAtcmMxLTAwMDIwLWdiYTU3ZWE2LTc4Ci9rZXJuZWwveDg2XzY0LXJhbmRj
b25maWcteDAyLTA3MTkvYzFmNjMxYjlhNjgyNTEwMDdhNjM1MzA0MWFlOTBmOWY3ZGNhNzcx
Yy9kbWVzZy1rdm0ta2J1aWxkLTQ2OTU4LTIwMTMwNzIwMTAwNDEwLTMuMTEuMC1yYzEtMDAx
NjUtZzY1MWU5MjctNzQKL2tlcm5lbC94ODZfNjQtcmFuZGNvbmZpZy14MDItMDcxOS9jMWY2
MzFiOWE2ODI1MTAwN2E2MzUzMDQxYWU5MGY5ZjdkY2E3NzFjL2RtZXNnLWt2bS1rYnVpbGQt
NTA1MzctMjAxMzA3MjAwOTI0MDMtMy4xMS4wLXJjMS1uZXh0LTIwMTMwNzE5LTUwCi9rZXJu
ZWwveDg2XzY0LXJhbmRjb25maWcteDAyLTA3MTkvYzFmNjMxYjlhNjgyNTEwMDdhNjM1MzA0
MWFlOTBmOWY3ZGNhNzcxYy9kbWVzZy1rdm0ta2J1aWxkLTY5MDUtMjAxMzA3MjAxMDAzMDAt
My4xMS4wLXJjMS0wMDE3NC1nYzEwZmI1Zi0xMQova2VybmVsL3g4Nl82NC1yYW5kY29uZmln
LXgwMi0wNzE5L2MxZjYzMWI5YTY4MjUxMDA3YTYzNTMwNDFhZTkwZjlmN2RjYTc3MWMvZG1l
c2cta3ZtLW5obS0xMzE3LTIwMTMwNzE5MjIzMzM3LTMuMTEuMC1yYzEtbmV4dC0yMDEzMDcx
OS01MAova2VybmVsL3g4Nl82NC1yYW5kY29uZmlnLXgwMi0wNzE5L2MxZjYzMWI5YTY4MjUx
MDA3YTYzNTMwNDFhZTkwZjlmN2RjYTc3MWMvZG1lc2cta3ZtLW5obS0xMzg1LTIwMTMwNzIw
MDgyODU1LTMuMTEuMC1yYzEtbmV4dC0yMDEzMDcxOS01MAova2VybmVsL3g4Nl82NC1yYW5k
Y29uZmlnLXgwMi0wNzE5L2MxZjYzMWI5YTY4MjUxMDA3YTYzNTMwNDFhZTkwZjlmN2RjYTc3
MWMvZG1lc2cta3ZtLW5obS0yODI0LTIwMTMwNzE5MjEzMDA5LTMuMTEuMC1yYzEtbmV4dC0y
MDEzMDcxOS01MAova2VybmVsL3g4Nl82NC1yYW5kY29uZmlnLXgwMi0wNzE5L2MxZjYzMWI5
YTY4MjUxMDA3YTYzNTMwNDFhZTkwZjlmN2RjYTc3MWMvZG1lc2cta3ZtLW5obS0zMDU1NS0y
MDEzMDcyMDA5MzQzMi0zLjExLjAtcmMxLW5leHQtMjAxMzA3MTktNTAKL2tlcm5lbC94ODZf
NjQtcmFuZGNvbmZpZy14MDItMDcxOS9jMWY2MzFiOWE2ODI1MTAwN2E2MzUzMDQxYWU5MGY5
ZjdkY2E3NzFjL2RtZXNnLWt2bS1uaG0tMzA3MDAtMjAxMzA3MTkyMjM4MzQtMy4xMS4wLXJj
MS1uZXh0LTIwMTMwNzE5LTUwCi9rZXJuZWwveDg2XzY0LXJhbmRjb25maWcteDAyLTA3MTkv
YzFmNjMxYjlhNjgyNTEwMDdhNjM1MzA0MWFlOTBmOWY3ZGNhNzcxYy9kbWVzZy1rdm0tbmht
LTMyMjEyLTIwMTMwNzE5MjI0MzM1LTMuMTEuMC1yYzEtMDM0ODEtZzY0MWU5N2QtNzcKL2tl
cm5lbC94ODZfNjQtcmFuZGNvbmZpZy14MDItMDcxOS9jMWY2MzFiOWE2ODI1MTAwN2E2MzUz
MDQxYWU5MGY5ZjdkY2E3NzFjL2RtZXNnLWt2bS1uaG0tMzI5My0yMDEzMDcyMDA5Mjk0NS0z
LjExLjAtcmMxLTAwMTU0LWcwODg3YTU3LTEyOAova2VybmVsL3g4Nl82NC1yYW5kY29uZmln
LXgwMi0wNzE5L2MxZjYzMWI5YTY4MjUxMDA3YTYzNTMwNDFhZTkwZjlmN2RjYTc3MWMvZG1l
c2cta3ZtLW5obS01ODctMjAxMzA3MjAwODQyNTctMy4xMS4wLXJjMS1uZXh0LTIwMTMwNzE5
LTUwCi9rZXJuZWwveDg2XzY0LXJhbmRjb25maWcteDAyLTA3MTkvYzFmNjMxYjlhNjgyNTEw
MDdhNjM1MzA0MWFlOTBmOWY3ZGNhNzcxYy9kbWVzZy1rdm0td2FpbWVhLTMwODI4LTIwMTMw
NzIwMDk1NTQ5LTMuMTEuMC1yYzEtMDAxNzYtZzJmMGE5YWYtMTEyCi9rZXJuZWwveDg2XzY0
LXJhbmRjb25maWcteDAyLTA3MTkvYzFmNjMxYjlhNjgyNTEwMDdhNjM1MzA0MWFlOTBmOWY3
ZGNhNzcxYy9kbWVzZy1rdm0td2FpbWVhLTMxNDgxLTIwMTMwNzIwMDk1NDAxLTMuMTEuMC1y
YzEtbmV4dC0yMDEzMDcxOS01MAova2VybmVsL3g4Nl82NC1yYW5kY29uZmlnLXgwMi0wNzE5
L2MxZjYzMWI5YTY4MjUxMDA3YTYzNTMwNDFhZTkwZjlmN2RjYTc3MWMvZG1lc2cta3ZtLXdh
aW1lYS0zMTQ4MS0yMDEzMDcyMDA5NTUyNi0zLjExLjAtcmMxLW5leHQtMjAxMzA3MTktNTAK
L2tlcm5lbC94ODZfNjQtcmFuZGNvbmZpZy14MDItMDcxOS9jMWY2MzFiOWE2ODI1MTAwN2E2
MzUzMDQxYWU5MGY5ZjdkY2E3NzFjL2RtZXNnLWt2bS13YWltZWEtMzIyNDctMjAxMzA3MjAx
MDAzMjgtMy4xMS4wLXJjMS1uZXh0LTIwMTMwNzE5LTUwCgpbZGV0YWNoZWQgSEVBRCA3MDli
NDY1XSBSZXZlcnQgImlwYyxzaG06IHNob3J0ZW4gY3JpdGljYWwgcmVnaW9uIGZvciBzaG1h
dCIKIDEgZmlsZSBjaGFuZ2VkLCAzIGluc2VydGlvbnMoKyksIDkgZGVsZXRpb25zKC0pCmxz
IC1hIC9rZXJuZWwtdGVzdHMvcnVuLXF1ZXVlL2t2bS94ODZfNjQtcmFuZGNvbmZpZy14MDIt
MDcxOS9uZXh0Om1hc3Rlcjo3MDliNDY1ZWU2NTUzODdjNGVjMDU2MzgzZmEyN2YxNmM2NGY0
OGRiOmJpc2VjdC11c2IKCjIwMTMtMDctMjAtMTU6MzQ6MDYgNzA5YjQ2NWVlNjU1Mzg3YzRl
YzA1NjM4M2ZhMjdmMTZjNjRmNDhkYiBjb21waWxpbmcKCjIwMTMtMDctMjAtMTU6Mzk6MzMg
ZGV0ZWN0aW5nIGJvb3Qgc3RhdGUgMy4xMS4wLXJjMS1uZXh0LTIwMTMwNzE5LTExNjk5LWc3
MDliNDY1Li4JMgkxOAkyMQkyOAkzNwk0MAk0Mwk1Nwk1OAk3NAkxMDEJMTY0CTE2NgkxODIJ
MTkxLgkxOTIJMTkzLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4u
Li4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4u
Li4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4u
Li4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4u
Li4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4u
Li4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLhtbMTszNW1hZGRf
dG9fcnVuX3F1ZXVlIDIbWzBtCi4uCTE5NSBTVUNDRVNTCgoKPT09PT09PT09IHVwc3RyZWFt
ID09PT09PT09PQpGZXRjaGluZyBsaW51cwpscyAtYSAva2VybmVsLXRlc3RzL3J1bi1xdWV1
ZS9rdm0veDg2XzY0LXJhbmRjb25maWcteDAyLTA3MTkvbmV4dDptYXN0ZXI6ZDQ3MWNlNTNi
MWZhYjYwMTEwZTRlOWY2NDdhMzQ1Y2VhMzE3NTJkZTpiaXNlY3QtdXNiCgoyMDEzLTA3LTIw
LTE4OjIxOjQwIGQ0NzFjZTUzYjFmYWI2MDExMGU0ZTlmNjQ3YTM0NWNlYTMxNzUyZGUgcmV1
c2UgL2tlcm5lbC94ODZfNjQtcmFuZGNvbmZpZy14MDItMDcxOS9kNDcxY2U1M2IxZmFiNjAx
MTBlNGU5ZjY0N2EzNDVjZWEzMTc1MmRlL3ZtbGludXotMy4xMS4wLXJjMS0wMDE5OS1nZDQ3
MWNlNQoKMjAxMy0wNy0yMC0xODoyMTo0MSBkZXRlY3RpbmcgYm9vdCBzdGF0ZSAuLi4JMTEJ
MjYJMzYJNDcJNjMJNzIJODMJODcJOTMJMTAxCTEwOAkxMTEJMTE0CTEyOAkxNTcJMTkwCTE5
MgkxOTQuLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4JMTk1IFNVQ0NFU1MKCgo9PT09PT09PT0g
bGludXgtbmV4dCA9PT09PT09PT0KRmV0Y2hpbmcgbmV4dApscyAtYSAva2VybmVsLXRlc3Rz
L3J1bi1xdWV1ZS9rdm0veDg2XzY0LXJhbmRjb25maWcteDAyLTA3MTkvbmV4dDptYXN0ZXI6
YzFmNjMxYjlhNjgyNTEwMDdhNjM1MzA0MWFlOTBmOWY3ZGNhNzcxYzpiaXNlY3QtdXNiCiBU
RVNUIEZBSUxVUkUKWyAgIDE3LjIwMzYzMF0gClsgICAxNy4yMDQ0NDddID09PT09PT09PT09
PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PQpbICAgMTcuMjA3MTA0XSBb
IEJVRzogbG9jayBoZWxkIHdoZW4gcmV0dXJuaW5nIHRvIHVzZXIgc3BhY2UhIF0KWyAgIDE3
LjIwOTkyN10gMy4xMS4wLXJjMS1uZXh0LTIwMTMwNzE5ICM1MCBOb3QgdGFpbnRlZApbICAg
MTcuMjEyMjMxXSAtLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0t
LS0tLS0KWyAgIDE3LjIxMzM4OV0gdHJpbml0eS1jaGlsZDAvMTc1IGlzIGxlYXZpbmcgdGhl
IGtlcm5lbCB3aXRoIGxvY2tzIHN0aWxsIGhlbGQhClsgICAxNy4yMTQzODRdIDEgbG9jayBo
ZWxkIGJ5IHRyaW5pdHktY2hpbGQwLzE3NToKWyAgIDE3LjIxNDM4NF0gICMwOiAgKHJjdV9y
ZWFkX2xvY2spey4rLisuLn0sIGF0OiBbPGZmZmZmZmZmODE0YTg0OTE+XSBkb19zaG1hdCsw
eGUxLzB4NTAwCi9rZXJuZWwveDg2XzY0LXJhbmRjb25maWcteDAyLTA3MTkvYzFmNjMxYjlh
NjgyNTEwMDdhNjM1MzA0MWFlOTBmOWY3ZGNhNzcxYy9kbWVzZy1rdm0tYXRoZW5zLTM4NTgt
MjAxMzA3MjAwOTIzMTctMy4xMS4wLXJjMS1uZXh0LTIwMTMwNzE5LTUwCi9rZXJuZWwveDg2
XzY0LXJhbmRjb25maWcteDAyLTA3MTkvYzFmNjMxYjlhNjgyNTEwMDdhNjM1MzA0MWFlOTBm
OWY3ZGNhNzcxYy9kbWVzZy1rdm0taW5uLTYzMDgtMjAxMzA3MTkyMjA0MzMtMy4xMS4wLXJj
MS1uZXh0LTIwMTMwNzE5LTUwCi9rZXJuZWwveDg2XzY0LXJhbmRjb25maWcteDAyLTA3MTkv
YzFmNjMxYjlhNjgyNTEwMDdhNjM1MzA0MWFlOTBmOWY3ZGNhNzcxYy9kbWVzZy1rdm0taW5u
LTg3NjQtMjAxMzA3MTkyMjQ5NTgtMy4xMS4wLXJjMS1uZXh0LTIwMTMwNzE5LTUwCi9rZXJu
ZWwveDg2XzY0LXJhbmRjb25maWcteDAyLTA3MTkvYzFmNjMxYjlhNjgyNTEwMDdhNjM1MzA0
MWFlOTBmOWY3ZGNhNzcxYy9kbWVzZy1rdm0ta2J1aWxkLTEwNzUxLTIwMTMwNzE5MjI0NDQx
LTMuMTEuMC1yYzEtMDAwMDQtZ2I4ZWJmZDMtMTYKL2tlcm5lbC94ODZfNjQtcmFuZGNvbmZp
Zy14MDItMDcxOS9jMWY2MzFiOWE2ODI1MTAwN2E2MzUzMDQxYWU5MGY5ZjdkY2E3NzFjL2Rt
ZXNnLWt2bS1rYnVpbGQtMjkwNTEtMjAxMzA3MjAwOTUzNTgtMy4xMS4wLXJjMS0wMDE1NC1n
MDg4N2E1Ny03NQova2VybmVsL3g4Nl82NC1yYW5kY29uZmlnLXgwMi0wNzE5L2MxZjYzMWI5
YTY4MjUxMDA3YTYzNTMwNDFhZTkwZjlmN2RjYTc3MWMvZG1lc2cta3ZtLWtidWlsZC0zMzQ4
Ny0yMDEzMDcyMDEwMDU1NC0zLjExLjAtcmMxLTAwMTc0LWdjMTBmYjVmLTExCi9rZXJuZWwv
eDg2XzY0LXJhbmRjb25maWcteDAyLTA3MTkvYzFmNjMxYjlhNjgyNTEwMDdhNjM1MzA0MWFl
OTBmOWY3ZGNhNzcxYy9kbWVzZy1rdm0ta2J1aWxkLTM1MzM2LTIwMTMwNzE5MjI0NDM1LTMu
MTEuMC1yYzEtMDAzMzYtZ2M5ZDBlOGMtNTIKL2tlcm5lbC94ODZfNjQtcmFuZGNvbmZpZy14
MDItMDcxOS9jMWY2MzFiOWE2ODI1MTAwN2E2MzUzMDQxYWU5MGY5ZjdkY2E3NzFjL2RtZXNn
LWt2bS1rYnVpbGQtNDEzMDQtMjAxMzA3MjAwOTQzMTMtLQova2VybmVsL3g4Nl82NC1yYW5k
Y29uZmlnLXgwMi0wNzE5L2MxZjYzMWI5YTY4MjUxMDA3YTYzNTMwNDFhZTkwZjlmN2RjYTc3
MWMvZG1lc2cta3ZtLWtidWlsZC00MjM1Ni0yMDEzMDcyMDA5NTM0Mi0zLjExLjAtcmMxLTAw
MTcwLWdmYmY2MDg4LTMKL2tlcm5lbC94ODZfNjQtcmFuZGNvbmZpZy14MDItMDcxOS9jMWY2
MzFiOWE2ODI1MTAwN2E2MzUzMDQxYWU5MGY5ZjdkY2E3NzFjL2RtZXNnLWt2bS1rYnVpbGQt
NDQxMTgtMjAxMzA3MTkyMjM2NDktMy4xMS4wLXJjMS1uZXh0LTIwMTMwNzE5LTUwCi9rZXJu
ZWwveDg2XzY0LXJhbmRjb25maWcteDAyLTA3MTkvYzFmNjMxYjlhNjgyNTEwMDdhNjM1MzA0
MWFlOTBmOWY3ZGNhNzcxYy9kbWVzZy1rdm0ta2J1aWxkLTQ2NjQ3LTIwMTMwNzIwMDk1MjU2
LTMuMTEuMC1yYzEtMDAwMjAtZ2JhNTdlYTYtNzgKL2tlcm5lbC94ODZfNjQtcmFuZGNvbmZp
Zy14MDItMDcxOS9jMWY2MzFiOWE2ODI1MTAwN2E2MzUzMDQxYWU5MGY5ZjdkY2E3NzFjL2Rt
ZXNnLWt2bS1rYnVpbGQtNDY5NTgtMjAxMzA3MjAxMDA0MTAtMy4xMS4wLXJjMS0wMDE2NS1n
NjUxZTkyNy03NAova2VybmVsL3g4Nl82NC1yYW5kY29uZmlnLXgwMi0wNzE5L2MxZjYzMWI5
YTY4MjUxMDA3YTYzNTMwNDFhZTkwZjlmN2RjYTc3MWMvZG1lc2cta3ZtLWtidWlsZC01MDUz
Ny0yMDEzMDcyMDA5MjQwMy0zLjExLjAtcmMxLW5leHQtMjAxMzA3MTktNTAKL2tlcm5lbC94
ODZfNjQtcmFuZGNvbmZpZy14MDItMDcxOS9jMWY2MzFiOWE2ODI1MTAwN2E2MzUzMDQxYWU5
MGY5ZjdkY2E3NzFjL2RtZXNnLWt2bS1rYnVpbGQtNjkwNS0yMDEzMDcyMDEwMDMwMC0zLjEx
LjAtcmMxLTAwMTc0LWdjMTBmYjVmLTExCi9rZXJuZWwveDg2XzY0LXJhbmRjb25maWcteDAy
LTA3MTkvYzFmNjMxYjlhNjgyNTEwMDdhNjM1MzA0MWFlOTBmOWY3ZGNhNzcxYy9kbWVzZy1r
dm0tbmhtLTEzMTctMjAxMzA3MTkyMjMzMzctMy4xMS4wLXJjMS1uZXh0LTIwMTMwNzE5LTUw
Ci9rZXJuZWwveDg2XzY0LXJhbmRjb25maWcteDAyLTA3MTkvYzFmNjMxYjlhNjgyNTEwMDdh
NjM1MzA0MWFlOTBmOWY3ZGNhNzcxYy9kbWVzZy1rdm0tbmhtLTEzODUtMjAxMzA3MjAwODI4
NTUtMy4xMS4wLXJjMS1uZXh0LTIwMTMwNzE5LTUwCi9rZXJuZWwveDg2XzY0LXJhbmRjb25m
aWcteDAyLTA3MTkvYzFmNjMxYjlhNjgyNTEwMDdhNjM1MzA0MWFlOTBmOWY3ZGNhNzcxYy9k
bWVzZy1rdm0tbmhtLTI4MjQtMjAxMzA3MTkyMTMwMDktMy4xMS4wLXJjMS1uZXh0LTIwMTMw
NzE5LTUwCi9rZXJuZWwveDg2XzY0LXJhbmRjb25maWcteDAyLTA3MTkvYzFmNjMxYjlhNjgy
NTEwMDdhNjM1MzA0MWFlOTBmOWY3ZGNhNzcxYy9kbWVzZy1rdm0tbmhtLTMwNTU1LTIwMTMw
NzIwMDkzNDMyLTMuMTEuMC1yYzEtbmV4dC0yMDEzMDcxOS01MAova2VybmVsL3g4Nl82NC1y
YW5kY29uZmlnLXgwMi0wNzE5L2MxZjYzMWI5YTY4MjUxMDA3YTYzNTMwNDFhZTkwZjlmN2Rj
YTc3MWMvZG1lc2cta3ZtLW5obS0zMDcwMC0yMDEzMDcxOTIyMzgzNC0zLjExLjAtcmMxLW5l
eHQtMjAxMzA3MTktNTAKL2tlcm5lbC94ODZfNjQtcmFuZGNvbmZpZy14MDItMDcxOS9jMWY2
MzFiOWE2ODI1MTAwN2E2MzUzMDQxYWU5MGY5ZjdkY2E3NzFjL2RtZXNnLWt2bS1uaG0tMzIy
MTItMjAxMzA3MTkyMjQzMzUtMy4xMS4wLXJjMS0wMzQ4MS1nNjQxZTk3ZC03Nwova2VybmVs
L3g4Nl82NC1yYW5kY29uZmlnLXgwMi0wNzE5L2MxZjYzMWI5YTY4MjUxMDA3YTYzNTMwNDFh
ZTkwZjlmN2RjYTc3MWMvZG1lc2cta3ZtLW5obS0zMjkzLTIwMTMwNzIwMDkyOTQ1LTMuMTEu
MC1yYzEtMDAxNTQtZzA4ODdhNTctMTI4Ci9rZXJuZWwveDg2XzY0LXJhbmRjb25maWcteDAy
LTA3MTkvYzFmNjMxYjlhNjgyNTEwMDdhNjM1MzA0MWFlOTBmOWY3ZGNhNzcxYy9kbWVzZy1r
dm0tbmhtLTU4Ny0yMDEzMDcyMDA4NDI1Ny0zLjExLjAtcmMxLW5leHQtMjAxMzA3MTktNTAK
L2tlcm5lbC94ODZfNjQtcmFuZGNvbmZpZy14MDItMDcxOS9jMWY2MzFiOWE2ODI1MTAwN2E2
MzUzMDQxYWU5MGY5ZjdkY2E3NzFjL2RtZXNnLWt2bS13YWltZWEtMzA4MjgtMjAxMzA3MjAw
OTU1NDktMy4xMS4wLXJjMS0wMDE3Ni1nMmYwYTlhZi0xMTIKL2tlcm5lbC94ODZfNjQtcmFu
ZGNvbmZpZy14MDItMDcxOS9jMWY2MzFiOWE2ODI1MTAwN2E2MzUzMDQxYWU5MGY5ZjdkY2E3
NzFjL2RtZXNnLWt2bS13YWltZWEtMzE0ODEtMjAxMzA3MjAwOTU0MDEtMy4xMS4wLXJjMS1u
ZXh0LTIwMTMwNzE5LTUwCi9rZXJuZWwveDg2XzY0LXJhbmRjb25maWcteDAyLTA3MTkvYzFm
NjMxYjlhNjgyNTEwMDdhNjM1MzA0MWFlOTBmOWY3ZGNhNzcxYy9kbWVzZy1rdm0td2FpbWVh
LTMxNDgxLTIwMTMwNzIwMDk1NTI2LTMuMTEuMC1yYzEtbmV4dC0yMDEzMDcxOS01MAova2Vy
bmVsL3g4Nl82NC1yYW5kY29uZmlnLXgwMi0wNzE5L2MxZjYzMWI5YTY4MjUxMDA3YTYzNTMw
NDFhZTkwZjlmN2RjYTc3MWMvZG1lc2cta3ZtLXdhaW1lYS0zMjI0Ny0yMDEzMDcyMDEwMDMy
OC0zLjExLjAtcmMxLW5leHQtMjAxMzA3MTktNTAKCg==

--ZoaI/ZTpAVc4A5k6
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="config-3.11.0-rc1-next-20130719"

#
# Automatically generated file; DO NOT EDIT.
# Linux/x86_64 3.11.0-rc1 Kernel Configuration
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
CONFIG_POSIX_MQUEUE=y
CONFIG_FHANDLE=y
CONFIG_AUDIT=y
# CONFIG_AUDITSYSCALL is not set
# CONFIG_AUDIT_LOGINUID_IMMUTABLE is not set
CONFIG_HAVE_GENERIC_HARDIRQS=y

#
# IRQ subsystem
#
CONFIG_GENERIC_HARDIRQS=y
CONFIG_GENERIC_IRQ_PROBE=y
CONFIG_GENERIC_IRQ_SHOW=y
CONFIG_GENERIC_IRQ_CHIP=y
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
CONFIG_HZ_PERIODIC=y
# CONFIG_NO_HZ_IDLE is not set
# CONFIG_NO_HZ is not set
# CONFIG_HIGH_RES_TIMERS is not set

#
# CPU/Task time and stats accounting
#
# CONFIG_TICK_CPU_ACCOUNTING is not set
# CONFIG_VIRT_CPU_ACCOUNTING_GEN is not set
CONFIG_IRQ_TIME_ACCOUNTING=y
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
CONFIG_CGROUP_FREEZER=y
CONFIG_CGROUP_DEVICE=y
# CONFIG_CPUSETS is not set
# CONFIG_CGROUP_CPUACCT is not set
CONFIG_RESOURCE_COUNTERS=y
CONFIG_MEMCG=y
CONFIG_CGROUP_HUGETLB=y
# CONFIG_CGROUP_PERF is not set
CONFIG_CGROUP_SCHED=y
CONFIG_FAIR_GROUP_SCHED=y
# CONFIG_CFS_BANDWIDTH is not set
# CONFIG_RT_GROUP_SCHED is not set
CONFIG_BLK_CGROUP=y
# CONFIG_DEBUG_BLK_CGROUP is not set
# CONFIG_CHECKPOINT_RESTORE is not set
# CONFIG_NAMESPACES is not set
CONFIG_SCHED_AUTOGROUP=y
CONFIG_MM_OWNER=y
# CONFIG_SYSFS_DEPRECATED is not set
# CONFIG_RELAY is not set
CONFIG_BLK_DEV_INITRD=y
CONFIG_INITRAMFS_SOURCE=""
CONFIG_RD_GZIP=y
# CONFIG_RD_BZIP2 is not set
CONFIG_RD_LZMA=y
# CONFIG_RD_XZ is not set
# CONFIG_RD_LZO is not set
# CONFIG_RD_LZ4 is not set
# CONFIG_CC_OPTIMIZE_FOR_SIZE is not set
CONFIG_ANON_INODES=y
CONFIG_SYSCTL_EXCEPTION_TRACE=y
CONFIG_HAVE_PCSPKR_PLATFORM=y
CONFIG_EXPERT=y
CONFIG_KALLSYMS=y
CONFIG_KALLSYMS_ALL=y
CONFIG_PRINTK=y
CONFIG_BUG=y
# CONFIG_ELF_CORE is not set
# CONFIG_PCSPKR_PLATFORM is not set
# CONFIG_BASE_FULL is not set
CONFIG_FUTEX=y
CONFIG_EPOLL=y
# CONFIG_SIGNALFD is not set
CONFIG_TIMERFD=y
CONFIG_EVENTFD=y
CONFIG_SHMEM=y
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
# CONFIG_COMPAT_BRK is not set
# CONFIG_SLAB is not set
# CONFIG_SLUB is not set
CONFIG_SLOB=y
CONFIG_PROFILING=y
# CONFIG_OPROFILE is not set
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
CONFIG_HAVE_CMPXCHG_LOCAL=y
CONFIG_HAVE_CMPXCHG_DOUBLE=y
CONFIG_HAVE_ARCH_SECCOMP_FILTER=y
CONFIG_HAVE_CONTEXT_TRACKING=y
CONFIG_HAVE_IRQ_TIME_ACCOUNTING=y
CONFIG_HAVE_ARCH_TRANSPARENT_HUGEPAGE=y
CONFIG_HAVE_ARCH_SOFT_DIRTY=y
CONFIG_MODULES_USE_ELF_RELA=y

#
# GCOV-based kernel profiling
#
CONFIG_GCOV_KERNEL=y
# CONFIG_GCOV_PROFILE_ALL is not set
# CONFIG_HAVE_GENERIC_DMA_COHERENT is not set
CONFIG_RT_MUTEXES=y
CONFIG_BASE_SMALL=1
# CONFIG_MODULES is not set
CONFIG_BLOCK=y
CONFIG_BLK_DEV_BSG=y
CONFIG_BLK_DEV_BSGLIB=y
CONFIG_BLK_DEV_INTEGRITY=y
# CONFIG_BLK_DEV_THROTTLING is not set

#
# Partition Types
#
CONFIG_PARTITION_ADVANCED=y
# CONFIG_ACORN_PARTITION is not set
CONFIG_AIX_PARTITION=y
# CONFIG_OSF_PARTITION is not set
CONFIG_AMIGA_PARTITION=y
CONFIG_ATARI_PARTITION=y
CONFIG_MAC_PARTITION=y
# CONFIG_MSDOS_PARTITION is not set
# CONFIG_LDM_PARTITION is not set
# CONFIG_SGI_PARTITION is not set
# CONFIG_ULTRIX_PARTITION is not set
# CONFIG_SUN_PARTITION is not set
# CONFIG_KARMA_PARTITION is not set
CONFIG_EFI_PARTITION=y
# CONFIG_SYSV68_PARTITION is not set

#
# IO Schedulers
#
CONFIG_IOSCHED_NOOP=y
CONFIG_IOSCHED_DEADLINE=y
# CONFIG_IOSCHED_CFQ is not set
# CONFIG_DEFAULT_DEADLINE is not set
CONFIG_DEFAULT_NOOP=y
CONFIG_DEFAULT_IOSCHED="noop"
CONFIG_UNINLINE_SPIN_UNLOCK=y
CONFIG_FREEZER=y

#
# Processor type and features
#
CONFIG_ZONE_DMA=y
# CONFIG_SMP is not set
# CONFIG_X86_MPPARSE is not set
CONFIG_X86_EXTENDED_PLATFORM=y
# CONFIG_X86_INTEL_LPSS is not set
CONFIG_X86_SUPPORTS_MEMORY_FAILURE=y
# CONFIG_SCHED_OMIT_FRAME_POINTER is not set
CONFIG_HYPERVISOR_GUEST=y
CONFIG_PARAVIRT=y
# CONFIG_PARAVIRT_DEBUG is not set
# CONFIG_XEN is not set
# CONFIG_XEN_PRIVILEGED_GUEST is not set
CONFIG_KVM_GUEST=y
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
# CONFIG_PROCESSOR_SELECT is not set
CONFIG_CPU_SUP_INTEL=y
CONFIG_CPU_SUP_AMD=y
CONFIG_CPU_SUP_CENTAUR=y
CONFIG_HPET_TIMER=y
CONFIG_DMI=y
# CONFIG_GART_IOMMU is not set
CONFIG_CALGARY_IOMMU=y
CONFIG_CALGARY_IOMMU_ENABLED_BY_DEFAULT=y
CONFIG_SWIOTLB=y
CONFIG_IOMMU_HELPER=y
CONFIG_NR_CPUS=1
# CONFIG_PREEMPT_NONE is not set
# CONFIG_PREEMPT_VOLUNTARY is not set
CONFIG_PREEMPT=y
CONFIG_PREEMPT_COUNT=y
CONFIG_X86_LOCAL_APIC=y
CONFIG_X86_IO_APIC=y
# CONFIG_X86_REROUTE_FOR_BROKEN_BOOT_IRQS is not set
CONFIG_X86_MCE=y
CONFIG_X86_MCE_INTEL=y
CONFIG_X86_MCE_AMD=y
CONFIG_X86_MCE_THRESHOLD=y
# CONFIG_X86_MCE_INJECT is not set
CONFIG_X86_THERMAL_VECTOR=y
# CONFIG_I8K is not set
CONFIG_MICROCODE=y
CONFIG_MICROCODE_INTEL=y
# CONFIG_MICROCODE_AMD is not set
CONFIG_MICROCODE_OLD_INTERFACE=y
CONFIG_MICROCODE_INTEL_LIB=y
# CONFIG_MICROCODE_INTEL_EARLY is not set
# CONFIG_MICROCODE_AMD_EARLY is not set
# CONFIG_MICROCODE_EARLY is not set
CONFIG_X86_MSR=y
# CONFIG_X86_CPUID is not set
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
CONFIG_SPLIT_PTLOCK_CPUS=999999
CONFIG_COMPACTION=y
CONFIG_MIGRATION=y
CONFIG_PHYS_ADDR_T_64BIT=y
CONFIG_ZONE_DMA_FLAG=1
# CONFIG_BOUNCE is not set
CONFIG_NEED_BOUNCE_POOL=y
CONFIG_VIRT_TO_BUS=y
# CONFIG_KSM is not set
CONFIG_DEFAULT_MMAP_MIN_ADDR=4096
CONFIG_ARCH_SUPPORTS_MEMORY_FAILURE=y
CONFIG_MEMORY_FAILURE=y
CONFIG_TRANSPARENT_HUGEPAGE=y
# CONFIG_TRANSPARENT_HUGEPAGE_ALWAYS is not set
CONFIG_TRANSPARENT_HUGEPAGE_MADVISE=y
CONFIG_CROSS_MEMORY_ATTACH=y
CONFIG_NEED_PER_CPU_KM=y
CONFIG_CLEANCACHE=y
# CONFIG_ZBUD is not set
# CONFIG_CMA is not set
CONFIG_X86_CHECK_BIOS_CORRUPTION=y
CONFIG_X86_BOOTPARAM_MEMORY_CORRUPTION_CHECK=y
CONFIG_X86_RESERVE_LOW=64
CONFIG_MTRR=y
# CONFIG_MTRR_SANITIZER is not set
CONFIG_X86_PAT=y
CONFIG_ARCH_USES_PG_UNCACHED=y
# CONFIG_ARCH_RANDOM is not set
CONFIG_X86_SMAP=y
CONFIG_EFI=y
CONFIG_EFI_STUB=y
# CONFIG_SECCOMP is not set
# CONFIG_CC_STACKPROTECTOR is not set
# CONFIG_HZ_100 is not set
# CONFIG_HZ_250 is not set
# CONFIG_HZ_300 is not set
CONFIG_HZ_1000=y
CONFIG_HZ=1000
# CONFIG_SCHED_HRTICK is not set
# CONFIG_KEXEC is not set
# CONFIG_CRASH_DUMP is not set
CONFIG_PHYSICAL_START=0x1000000
# CONFIG_RELOCATABLE is not set
CONFIG_PHYSICAL_ALIGN=0x1000000
# CONFIG_CMDLINE_BOOL is not set
CONFIG_ARCH_ENABLE_MEMORY_HOTPLUG=y

#
# Power management and ACPI options
#
# CONFIG_SUSPEND is not set
# CONFIG_PM_RUNTIME is not set
CONFIG_ACPI=y
CONFIG_ACPI_EC_DEBUGFS=y
CONFIG_ACPI_AC=y
CONFIG_ACPI_BATTERY=y
# CONFIG_ACPI_BUTTON is not set
CONFIG_ACPI_VIDEO=y
# CONFIG_ACPI_FAN is not set
# CONFIG_ACPI_DOCK is not set
CONFIG_ACPI_I2C=y
# CONFIG_ACPI_PROCESSOR is not set
CONFIG_ACPI_CUSTOM_DSDT_FILE=""
# CONFIG_ACPI_CUSTOM_DSDT is not set
# CONFIG_ACPI_INITRD_TABLE_OVERRIDE is not set
CONFIG_ACPI_BLACKLIST_YEAR=0
# CONFIG_ACPI_DEBUG is not set
CONFIG_ACPI_PCI_SLOT=y
CONFIG_X86_PM_TIMER=y
# CONFIG_ACPI_CONTAINER is not set
CONFIG_ACPI_SBS=y
# CONFIG_ACPI_HED is not set
# CONFIG_ACPI_CUSTOM_METHOD is not set
# CONFIG_ACPI_BGRT is not set
CONFIG_ACPI_APEI=y
# CONFIG_ACPI_APEI_GHES is not set
# CONFIG_ACPI_APEI_MEMORY_FAILURE is not set
# CONFIG_ACPI_APEI_EINJ is not set
CONFIG_ACPI_APEI_ERST_DEBUG=y
CONFIG_SFI=y

#
# CPU Frequency scaling
#
CONFIG_CPU_FREQ=y
CONFIG_CPU_FREQ_TABLE=y
CONFIG_CPU_FREQ_GOV_COMMON=y
CONFIG_CPU_FREQ_STAT=y
# CONFIG_CPU_FREQ_STAT_DETAILS is not set
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
CONFIG_X86_P4_CLOCKMOD=y

#
# shared options
#
CONFIG_X86_SPEEDSTEP_LIB=y
CONFIG_CPU_IDLE=y
CONFIG_CPU_IDLE_MULTIPLE_DRIVERS=y
CONFIG_CPU_IDLE_GOV_LADDER=y
# CONFIG_CPU_IDLE_GOV_MENU is not set
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
CONFIG_PCI_MMCONFIG=y
CONFIG_PCI_DOMAINS=y
CONFIG_PCI_CNB20LE_QUIRK=y
CONFIG_PCIEPORTBUS=y
CONFIG_HOTPLUG_PCI_PCIE=y
# CONFIG_PCIEAER is not set
CONFIG_PCIEASPM=y
CONFIG_PCIEASPM_DEBUG=y
# CONFIG_PCIEASPM_DEFAULT is not set
CONFIG_PCIEASPM_POWERSAVE=y
# CONFIG_PCIEASPM_PERFORMANCE is not set
CONFIG_ARCH_SUPPORTS_MSI=y
CONFIG_PCI_MSI=y
# CONFIG_PCI_DEBUG is not set
# CONFIG_PCI_REALLOC_ENABLE_AUTO is not set
CONFIG_PCI_STUB=y
# CONFIG_HT_IRQ is not set
CONFIG_PCI_ATS=y
# CONFIG_PCI_IOV is not set
# CONFIG_PCI_PRI is not set
CONFIG_PCI_PASID=y
CONFIG_PCI_IOAPIC=y
CONFIG_PCI_LABEL=y

#
# PCI host controller drivers
#
CONFIG_ISA_DMA_API=y
CONFIG_AMD_NB=y
CONFIG_PCCARD=y
CONFIG_PCMCIA=y
CONFIG_PCMCIA_LOAD_CIS=y
CONFIG_CARDBUS=y

#
# PC-card bridges
#
# CONFIG_YENTA is not set
# CONFIG_PD6729 is not set
CONFIG_I82092=y
CONFIG_PCCARD_NONSTATIC=y
CONFIG_HOTPLUG_PCI=y
CONFIG_HOTPLUG_PCI_ACPI=y
# CONFIG_HOTPLUG_PCI_ACPI_IBM is not set
CONFIG_HOTPLUG_PCI_CPCI=y
CONFIG_HOTPLUG_PCI_CPCI_ZT5550=y
CONFIG_HOTPLUG_PCI_CPCI_GENERIC=y
CONFIG_HOTPLUG_PCI_SHPC=y
CONFIG_RAPIDIO=y
CONFIG_RAPIDIO_TSI721=y
CONFIG_RAPIDIO_DISC_TIMEOUT=30
CONFIG_RAPIDIO_ENABLE_RX_TX_PORTS=y
CONFIG_RAPIDIO_DMA_ENGINE=y
CONFIG_RAPIDIO_DEBUG=y
CONFIG_RAPIDIO_ENUM_BASIC=y

#
# RapidIO Switch drivers
#
CONFIG_RAPIDIO_TSI57X=y
# CONFIG_RAPIDIO_CPS_XX is not set
# CONFIG_RAPIDIO_TSI568 is not set
CONFIG_RAPIDIO_CPS_GEN2=y

#
# Executable file formats / Emulations
#
CONFIG_BINFMT_ELF=y
CONFIG_ARCH_BINFMT_ELF_RANDOMIZE_PIE=y
CONFIG_BINFMT_SCRIPT=y
# CONFIG_HAVE_AOUT is not set
# CONFIG_BINFMT_MISC is not set
CONFIG_COREDUMP=y
# CONFIG_IA32_EMULATION is not set
CONFIG_HAVE_TEXT_POKE_SMP=y
CONFIG_X86_DEV_DMA_OPS=y
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
# CONFIG_XFRM_SUB_POLICY is not set
CONFIG_XFRM_MIGRATE=y
CONFIG_XFRM_IPCOMP=y
CONFIG_NET_KEY=y
CONFIG_NET_KEY_MIGRATE=y
CONFIG_INET=y
# CONFIG_IP_MULTICAST is not set
CONFIG_IP_ADVANCED_ROUTER=y
CONFIG_IP_FIB_TRIE_STATS=y
CONFIG_IP_MULTIPLE_TABLES=y
CONFIG_IP_ROUTE_MULTIPATH=y
CONFIG_IP_ROUTE_VERBOSE=y
CONFIG_IP_ROUTE_CLASSID=y
# CONFIG_IP_PNP is not set
CONFIG_NET_IPIP=y
CONFIG_NET_IPGRE_DEMUX=y
CONFIG_NET_IP_TUNNEL=y
CONFIG_NET_IPGRE=y
# CONFIG_ARPD is not set
# CONFIG_SYN_COOKIES is not set
CONFIG_INET_AH=y
CONFIG_INET_ESP=y
CONFIG_INET_IPCOMP=y
CONFIG_INET_XFRM_TUNNEL=y
CONFIG_INET_TUNNEL=y
CONFIG_INET_XFRM_MODE_TRANSPORT=y
# CONFIG_INET_XFRM_MODE_TUNNEL is not set
CONFIG_INET_XFRM_MODE_BEET=y
# CONFIG_INET_LRO is not set
# CONFIG_INET_DIAG is not set
# CONFIG_TCP_CONG_ADVANCED is not set
CONFIG_TCP_CONG_CUBIC=y
CONFIG_DEFAULT_TCP_CONG="cubic"
# CONFIG_TCP_MD5SIG is not set
CONFIG_IPV6=y
CONFIG_IPV6_PRIVACY=y
# CONFIG_IPV6_ROUTER_PREF is not set
CONFIG_IPV6_OPTIMISTIC_DAD=y
CONFIG_INET6_AH=y
# CONFIG_INET6_ESP is not set
# CONFIG_INET6_IPCOMP is not set
# CONFIG_IPV6_MIP6 is not set
# CONFIG_INET6_XFRM_TUNNEL is not set
CONFIG_INET6_TUNNEL=y
# CONFIG_INET6_XFRM_MODE_TRANSPORT is not set
CONFIG_INET6_XFRM_MODE_TUNNEL=y
CONFIG_INET6_XFRM_MODE_BEET=y
# CONFIG_INET6_XFRM_MODE_ROUTEOPTIMIZATION is not set
# CONFIG_IPV6_SIT is not set
CONFIG_IPV6_TUNNEL=y
CONFIG_IPV6_GRE=y
# CONFIG_IPV6_MULTIPLE_TABLES is not set
# CONFIG_IPV6_MROUTE is not set
CONFIG_NETWORK_SECMARK=y
CONFIG_NETWORK_PHY_TIMESTAMPING=y
# CONFIG_NETFILTER is not set
CONFIG_IP_DCCP=y

#
# DCCP CCIDs Configuration
#
# CONFIG_IP_DCCP_CCID2_DEBUG is not set
CONFIG_IP_DCCP_CCID3=y
# CONFIG_IP_DCCP_CCID3_DEBUG is not set
CONFIG_IP_DCCP_TFRC_LIB=y

#
# DCCP Kernel Hacking
#
CONFIG_IP_DCCP_DEBUG=y
CONFIG_IP_SCTP=y
# CONFIG_SCTP_DEFAULT_COOKIE_HMAC_MD5 is not set
CONFIG_SCTP_DEFAULT_COOKIE_HMAC_SHA1=y
# CONFIG_SCTP_DEFAULT_COOKIE_HMAC_NONE is not set
CONFIG_SCTP_COOKIE_HMAC_MD5=y
CONFIG_SCTP_COOKIE_HMAC_SHA1=y
# CONFIG_RDS is not set
# CONFIG_TIPC is not set
CONFIG_ATM=y
# CONFIG_ATM_CLIP is not set
CONFIG_ATM_LANE=y
CONFIG_ATM_MPOA=y
# CONFIG_ATM_BR2684 is not set
CONFIG_L2TP=y
CONFIG_L2TP_DEBUGFS=y
# CONFIG_L2TP_V3 is not set
CONFIG_STP=y
CONFIG_BRIDGE=y
CONFIG_BRIDGE_IGMP_SNOOPING=y
CONFIG_HAVE_NET_DSA=y
CONFIG_NET_DSA=y
CONFIG_NET_DSA_TAG_DSA=y
CONFIG_NET_DSA_TAG_EDSA=y
CONFIG_NET_DSA_TAG_TRAILER=y
# CONFIG_VLAN_8021Q is not set
CONFIG_DECNET=y
# CONFIG_DECNET_ROUTER is not set
CONFIG_LLC=y
# CONFIG_LLC2 is not set
CONFIG_IPX=y
CONFIG_IPX_INTERN=y
CONFIG_ATALK=y
CONFIG_DEV_APPLETALK=y
# CONFIG_IPDDP is not set
CONFIG_X25=y
# CONFIG_LAPB is not set
CONFIG_PHONET=y
CONFIG_IEEE802154=y
CONFIG_IEEE802154_6LOWPAN=y
CONFIG_MAC802154=y
CONFIG_NET_SCHED=y

#
# Queueing/Scheduling
#
CONFIG_NET_SCH_CBQ=y
# CONFIG_NET_SCH_HTB is not set
CONFIG_NET_SCH_HFSC=y
# CONFIG_NET_SCH_ATM is not set
CONFIG_NET_SCH_PRIO=y
CONFIG_NET_SCH_MULTIQ=y
# CONFIG_NET_SCH_RED is not set
# CONFIG_NET_SCH_SFB is not set
CONFIG_NET_SCH_SFQ=y
# CONFIG_NET_SCH_TEQL is not set
CONFIG_NET_SCH_TBF=y
# CONFIG_NET_SCH_GRED is not set
CONFIG_NET_SCH_DSMARK=y
# CONFIG_NET_SCH_NETEM is not set
CONFIG_NET_SCH_DRR=y
# CONFIG_NET_SCH_MQPRIO is not set
CONFIG_NET_SCH_CHOKE=y
# CONFIG_NET_SCH_QFQ is not set
CONFIG_NET_SCH_CODEL=y
CONFIG_NET_SCH_FQ_CODEL=y
CONFIG_NET_SCH_PLUG=y

#
# Classification
#
CONFIG_NET_CLS=y
CONFIG_NET_CLS_BASIC=y
CONFIG_NET_CLS_TCINDEX=y
CONFIG_NET_CLS_ROUTE4=y
CONFIG_NET_CLS_FW=y
CONFIG_NET_CLS_U32=y
CONFIG_CLS_U32_PERF=y
CONFIG_CLS_U32_MARK=y
# CONFIG_NET_CLS_RSVP is not set
CONFIG_NET_CLS_RSVP6=y
CONFIG_NET_CLS_FLOW=y
# CONFIG_NET_CLS_CGROUP is not set
CONFIG_NET_EMATCH=y
CONFIG_NET_EMATCH_STACK=32
# CONFIG_NET_EMATCH_CMP is not set
CONFIG_NET_EMATCH_NBYTE=y
CONFIG_NET_EMATCH_U32=y
CONFIG_NET_EMATCH_META=y
CONFIG_NET_EMATCH_TEXT=y
CONFIG_NET_EMATCH_CANID=y
# CONFIG_NET_CLS_ACT is not set
CONFIG_NET_CLS_IND=y
CONFIG_NET_SCH_FIFO=y
CONFIG_DCB=y
CONFIG_DNS_RESOLVER=y
CONFIG_BATMAN_ADV=y
CONFIG_BATMAN_ADV_BLA=y
# CONFIG_BATMAN_ADV_DAT is not set
# CONFIG_BATMAN_ADV_NC is not set
# CONFIG_BATMAN_ADV_DEBUG is not set
CONFIG_OPENVSWITCH=y
# CONFIG_OPENVSWITCH_GRE is not set
# CONFIG_VSOCKETS is not set
# CONFIG_NETLINK_MMAP is not set
CONFIG_NETLINK_DIAG=y
CONFIG_NET_MPLS_GSO=y
CONFIG_NETPRIO_CGROUP=y
CONFIG_NET_LL_RX_POLL=y
CONFIG_BQL=y

#
# Network testing
#
CONFIG_HAMRADIO=y

#
# Packet Radio protocols
#
CONFIG_AX25=y
CONFIG_AX25_DAMA_SLAVE=y
CONFIG_NETROM=y
CONFIG_ROSE=y

#
# AX.25 network device drivers
#
CONFIG_MKISS=y
# CONFIG_6PACK is not set
# CONFIG_BPQETHER is not set
# CONFIG_BAYCOM_SER_FDX is not set
CONFIG_BAYCOM_SER_HDX=y
CONFIG_YAM=y
CONFIG_CAN=y
CONFIG_CAN_RAW=y
CONFIG_CAN_BCM=y
CONFIG_CAN_GW=y

#
# CAN Device Drivers
#
CONFIG_CAN_VCAN=y
# CONFIG_CAN_SLCAN is not set
CONFIG_CAN_DEV=y
CONFIG_CAN_CALC_BITTIMING=y
# CONFIG_CAN_LEDS is not set
# CONFIG_CAN_MCP251X is not set
CONFIG_CAN_JANZ_ICAN3=y
CONFIG_PCH_CAN=y
CONFIG_CAN_SJA1000=y
CONFIG_CAN_SJA1000_ISA=y
CONFIG_CAN_SJA1000_PLATFORM=y
CONFIG_CAN_EMS_PCMCIA=y
CONFIG_CAN_EMS_PCI=y
CONFIG_CAN_PEAK_PCMCIA=y
CONFIG_CAN_PEAK_PCI=y
CONFIG_CAN_PEAK_PCIEC=y
CONFIG_CAN_KVASER_PCI=y
CONFIG_CAN_PLX_PCI=y
CONFIG_CAN_C_CAN=y
# CONFIG_CAN_C_CAN_PLATFORM is not set
CONFIG_CAN_C_CAN_PCI=y
CONFIG_CAN_CC770=y
CONFIG_CAN_CC770_ISA=y
CONFIG_CAN_CC770_PLATFORM=y

#
# CAN USB interfaces
#
CONFIG_CAN_EMS_USB=y
CONFIG_CAN_ESD_USB2=y
CONFIG_CAN_KVASER_USB=y
# CONFIG_CAN_PEAK_USB is not set
CONFIG_CAN_8DEV_USB=y
CONFIG_CAN_SOFTING=y
CONFIG_CAN_SOFTING_CS=y
# CONFIG_CAN_DEBUG_DEVICES is not set
# CONFIG_IRDA is not set
# CONFIG_BT is not set
CONFIG_AF_RXRPC=y
# CONFIG_AF_RXRPC_DEBUG is not set
CONFIG_RXKAD=y
CONFIG_FIB_RULES=y
CONFIG_WIRELESS=y
CONFIG_WIRELESS_EXT=y
CONFIG_WEXT_CORE=y
CONFIG_WEXT_SPY=y
CONFIG_WEXT_PRIV=y
CONFIG_CFG80211=y
CONFIG_NL80211_TESTMODE=y
CONFIG_CFG80211_DEVELOPER_WARNINGS=y
# CONFIG_CFG80211_REG_DEBUG is not set
CONFIG_CFG80211_CERTIFICATION_ONUS=y
# CONFIG_CFG80211_DEFAULT_PS is not set
CONFIG_CFG80211_DEBUGFS=y
# CONFIG_CFG80211_INTERNAL_REGDB is not set
# CONFIG_CFG80211_WEXT is not set
CONFIG_LIB80211=y
CONFIG_LIB80211_CRYPT_WEP=y
CONFIG_LIB80211_CRYPT_CCMP=y
CONFIG_LIB80211_CRYPT_TKIP=y
# CONFIG_LIB80211_DEBUG is not set
CONFIG_MAC80211=y
CONFIG_MAC80211_HAS_RC=y
CONFIG_MAC80211_RC_PID=y
CONFIG_MAC80211_RC_MINSTREL=y
# CONFIG_MAC80211_RC_MINSTREL_HT is not set
# CONFIG_MAC80211_RC_DEFAULT_PID is not set
CONFIG_MAC80211_RC_DEFAULT_MINSTREL=y
CONFIG_MAC80211_RC_DEFAULT="minstrel"
# CONFIG_MAC80211_MESH is not set
CONFIG_MAC80211_LEDS=y
# CONFIG_MAC80211_DEBUGFS is not set
# CONFIG_MAC80211_MESSAGE_TRACING is not set
CONFIG_MAC80211_DEBUG_MENU=y
# CONFIG_MAC80211_NOINLINE is not set
CONFIG_MAC80211_VERBOSE_DEBUG=y
# CONFIG_MAC80211_MLME_DEBUG is not set
# CONFIG_MAC80211_STA_DEBUG is not set
CONFIG_MAC80211_HT_DEBUG=y
# CONFIG_MAC80211_IBSS_DEBUG is not set
CONFIG_MAC80211_PS_DEBUG=y
CONFIG_MAC80211_TDLS_DEBUG=y
CONFIG_WIMAX=y
CONFIG_WIMAX_DEBUG_LEVEL=8
CONFIG_RFKILL=y
CONFIG_RFKILL_LEDS=y
# CONFIG_RFKILL_INPUT is not set
# CONFIG_RFKILL_REGULATOR is not set
# CONFIG_NET_9P is not set
CONFIG_CAIF=y
# CONFIG_CAIF_DEBUG is not set
CONFIG_CAIF_NETDEV=y
# CONFIG_CAIF_USB is not set
# CONFIG_CEPH_LIB is not set
CONFIG_NFC=y
CONFIG_NFC_NCI=y
# CONFIG_NFC_NCI_SPI is not set
# CONFIG_NFC_HCI is not set

#
# Near Field Communication (NFC) devices
#
CONFIG_NFC_PN533=y
CONFIG_NFC_WILINK=y
# CONFIG_NFC_SIM is not set
CONFIG_HAVE_BPF_JIT=y

#
# Device Drivers
#

#
# Generic Driver Options
#
CONFIG_UEVENT_HELPER_PATH=""
# CONFIG_DEVTMPFS is not set
# CONFIG_STANDALONE is not set
# CONFIG_PREVENT_FIRMWARE_BUILD is not set
CONFIG_FW_LOADER=y
CONFIG_FIRMWARE_IN_KERNEL=y
CONFIG_EXTRA_FIRMWARE=""
# CONFIG_FW_LOADER_USER_HELPER is not set
# CONFIG_DEBUG_DRIVER is not set
CONFIG_DEBUG_DEVRES=y
# CONFIG_SYS_HYPERVISOR is not set
# CONFIG_GENERIC_CPU_DEVICES is not set
CONFIG_REGMAP=y
CONFIG_REGMAP_I2C=y
CONFIG_REGMAP_SPI=y
CONFIG_REGMAP_MMIO=y
CONFIG_REGMAP_IRQ=y
CONFIG_DMA_SHARED_BUFFER=y

#
# Bus devices
#
CONFIG_CONNECTOR=y
CONFIG_PROC_EVENTS=y
# CONFIG_MTD is not set
# CONFIG_PARPORT is not set
CONFIG_PNP=y
# CONFIG_PNP_DEBUG_MESSAGES is not set

#
# Protocols
#
CONFIG_PNPACPI=y
CONFIG_BLK_DEV=y
CONFIG_BLK_DEV_FD=y
CONFIG_BLK_DEV_PCIESSD_MTIP32XX=y
CONFIG_BLK_CPQ_DA=y
# CONFIG_BLK_CPQ_CISS_DA is not set
CONFIG_BLK_DEV_DAC960=y
CONFIG_BLK_DEV_UMEM=y
# CONFIG_BLK_DEV_COW_COMMON is not set
CONFIG_BLK_DEV_LOOP=y
CONFIG_BLK_DEV_LOOP_MIN_COUNT=8
# CONFIG_BLK_DEV_CRYPTOLOOP is not set

#
# DRBD disabled because PROC_FS or INET not selected
#
CONFIG_BLK_DEV_NBD=y
CONFIG_BLK_DEV_NVME=y
CONFIG_BLK_DEV_SX8=y
CONFIG_BLK_DEV_RAM=y
CONFIG_BLK_DEV_RAM_COUNT=16
CONFIG_BLK_DEV_RAM_SIZE=4096
CONFIG_BLK_DEV_XIP=y
CONFIG_CDROM_PKTCDVD=y
CONFIG_CDROM_PKTCDVD_BUFFERS=8
CONFIG_CDROM_PKTCDVD_WCACHE=y
# CONFIG_ATA_OVER_ETH is not set
# CONFIG_VIRTIO_BLK is not set
# CONFIG_BLK_DEV_HD is not set
# CONFIG_BLK_DEV_RBD is not set
CONFIG_BLK_DEV_RSXX=y
# CONFIG_BLOCKCONSOLE is not set

#
# Misc devices
#
CONFIG_SENSORS_LIS3LV02D=y
CONFIG_AD525X_DPOT=y
CONFIG_AD525X_DPOT_I2C=y
CONFIG_AD525X_DPOT_SPI=y
CONFIG_DUMMY_IRQ=y
# CONFIG_IBM_ASM is not set
CONFIG_PHANTOM=y
CONFIG_INTEL_MID_PTI=y
CONFIG_SGI_IOC4=y
CONFIG_TIFM_CORE=y
CONFIG_TIFM_7XX1=y
CONFIG_ICS932S401=y
# CONFIG_ATMEL_SSC is not set
CONFIG_ENCLOSURE_SERVICES=y
# CONFIG_CS5535_MFGPT is not set
CONFIG_HP_ILO=y
CONFIG_APDS9802ALS=y
CONFIG_ISL29003=y
CONFIG_ISL29020=y
CONFIG_SENSORS_TSL2550=y
# CONFIG_SENSORS_BH1780 is not set
# CONFIG_SENSORS_BH1770 is not set
CONFIG_SENSORS_APDS990X=y
CONFIG_HMC6352=y
CONFIG_DS1682=y
CONFIG_TI_DAC7512=y
# CONFIG_VMWARE_BALLOON is not set
CONFIG_BMP085=y
CONFIG_BMP085_I2C=y
CONFIG_BMP085_SPI=y
# CONFIG_PCH_PHUB is not set
# CONFIG_USB_SWITCH_FSA9480 is not set
CONFIG_LATTICE_ECP3_CONFIG=y
# CONFIG_SRAM is not set
# CONFIG_C2PORT is not set

#
# EEPROM support
#
CONFIG_EEPROM_AT24=y
# CONFIG_EEPROM_AT25 is not set
# CONFIG_EEPROM_LEGACY is not set
CONFIG_EEPROM_MAX6875=y
CONFIG_EEPROM_93CX6=y
CONFIG_EEPROM_93XX46=y
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
CONFIG_HAVE_IDE=y
# CONFIG_IDE is not set

#
# SCSI device support
#
CONFIG_SCSI_MOD=y
CONFIG_RAID_ATTRS=y
CONFIG_SCSI=y
CONFIG_SCSI_DMA=y
CONFIG_SCSI_TGT=y
CONFIG_SCSI_NETLINK=y

#
# SCSI support type (disk, tape, CD-ROM)
#
# CONFIG_BLK_DEV_SD is not set
CONFIG_CHR_DEV_ST=y
CONFIG_CHR_DEV_OSST=y
CONFIG_BLK_DEV_SR=y
CONFIG_BLK_DEV_SR_VENDOR=y
CONFIG_CHR_DEV_SG=y
# CONFIG_CHR_DEV_SCH is not set
# CONFIG_SCSI_ENCLOSURE is not set
CONFIG_SCSI_MULTI_LUN=y
CONFIG_SCSI_CONSTANTS=y
CONFIG_SCSI_LOGGING=y
CONFIG_SCSI_SCAN_ASYNC=y

#
# SCSI Transports
#
CONFIG_SCSI_SPI_ATTRS=y
CONFIG_SCSI_FC_ATTRS=y
# CONFIG_SCSI_FC_TGT_ATTRS is not set
CONFIG_SCSI_ISCSI_ATTRS=y
CONFIG_SCSI_SAS_ATTRS=y
CONFIG_SCSI_SAS_LIBSAS=y
CONFIG_SCSI_SAS_HOST_SMP=y
CONFIG_SCSI_SRP_ATTRS=y
# CONFIG_SCSI_SRP_TGT_ATTRS is not set
CONFIG_SCSI_LOWLEVEL=y
CONFIG_ISCSI_TCP=y
CONFIG_ISCSI_BOOT_SYSFS=y
CONFIG_SCSI_CXGB3_ISCSI=y
# CONFIG_SCSI_CXGB4_ISCSI is not set
CONFIG_SCSI_BNX2_ISCSI=y
CONFIG_SCSI_BNX2X_FCOE=y
CONFIG_BE2ISCSI=y
CONFIG_BLK_DEV_3W_XXXX_RAID=y
CONFIG_SCSI_HPSA=y
CONFIG_SCSI_3W_9XXX=y
CONFIG_SCSI_3W_SAS=y
CONFIG_SCSI_ACARD=y
# CONFIG_SCSI_AACRAID is not set
CONFIG_SCSI_AIC7XXX=y
CONFIG_AIC7XXX_CMDS_PER_DEVICE=32
CONFIG_AIC7XXX_RESET_DELAY_MS=5000
# CONFIG_AIC7XXX_BUILD_FIRMWARE is not set
# CONFIG_AIC7XXX_DEBUG_ENABLE is not set
CONFIG_AIC7XXX_DEBUG_MASK=0
# CONFIG_AIC7XXX_REG_PRETTY_PRINT is not set
CONFIG_SCSI_AIC7XXX_OLD=y
CONFIG_SCSI_AIC79XX=y
CONFIG_AIC79XX_CMDS_PER_DEVICE=32
CONFIG_AIC79XX_RESET_DELAY_MS=5000
# CONFIG_AIC79XX_BUILD_FIRMWARE is not set
CONFIG_AIC79XX_DEBUG_ENABLE=y
CONFIG_AIC79XX_DEBUG_MASK=0
# CONFIG_AIC79XX_REG_PRETTY_PRINT is not set
CONFIG_SCSI_AIC94XX=y
CONFIG_AIC94XX_DEBUG=y
CONFIG_SCSI_MVSAS=y
# CONFIG_SCSI_MVSAS_DEBUG is not set
CONFIG_SCSI_MVSAS_TASKLET=y
CONFIG_SCSI_MVUMI=y
CONFIG_SCSI_DPT_I2O=y
CONFIG_SCSI_ADVANSYS=y
CONFIG_SCSI_ARCMSR=y
CONFIG_MEGARAID_NEWGEN=y
# CONFIG_MEGARAID_MM is not set
CONFIG_MEGARAID_LEGACY=y
CONFIG_MEGARAID_SAS=y
# CONFIG_SCSI_MPT2SAS is not set
CONFIG_SCSI_MPT3SAS=y
CONFIG_SCSI_MPT3SAS_MAX_SGE=128
# CONFIG_SCSI_MPT3SAS_LOGGING is not set
# CONFIG_SCSI_UFSHCD is not set
CONFIG_SCSI_HPTIOP=y
CONFIG_SCSI_BUSLOGIC=y
CONFIG_SCSI_FLASHPOINT=y
CONFIG_VMWARE_PVSCSI=y
CONFIG_LIBFC=y
CONFIG_LIBFCOE=y
CONFIG_FCOE=y
CONFIG_FCOE_FNIC=y
# CONFIG_SCSI_DMX3191D is not set
# CONFIG_SCSI_EATA is not set
CONFIG_SCSI_FUTURE_DOMAIN=y
CONFIG_SCSI_GDTH=y
CONFIG_SCSI_ISCI=y
CONFIG_SCSI_IPS=y
CONFIG_SCSI_INITIO=y
CONFIG_SCSI_INIA100=y
CONFIG_SCSI_STEX=y
CONFIG_SCSI_SYM53C8XX_2=y
CONFIG_SCSI_SYM53C8XX_DMA_ADDRESSING_MODE=1
CONFIG_SCSI_SYM53C8XX_DEFAULT_TAGS=16
CONFIG_SCSI_SYM53C8XX_MAX_TAGS=64
CONFIG_SCSI_SYM53C8XX_MMIO=y
CONFIG_SCSI_QLOGIC_1280=y
# CONFIG_SCSI_QLA_FC is not set
CONFIG_SCSI_QLA_ISCSI=y
# CONFIG_SCSI_LPFC is not set
CONFIG_SCSI_DC395x=y
CONFIG_SCSI_DC390T=y
# CONFIG_SCSI_DEBUG is not set
# CONFIG_SCSI_PMCRAID is not set
CONFIG_SCSI_PM8001=y
CONFIG_SCSI_SRP=y
# CONFIG_SCSI_BFA_FC is not set
# CONFIG_SCSI_VIRTIO is not set
CONFIG_SCSI_CHELSIO_FCOE=y
CONFIG_SCSI_LOWLEVEL_PCMCIA=y
CONFIG_SCSI_DH=y
CONFIG_SCSI_DH_RDAC=y
CONFIG_SCSI_DH_HP_SW=y
CONFIG_SCSI_DH_EMC=y
# CONFIG_SCSI_DH_ALUA is not set
CONFIG_SCSI_OSD_INITIATOR=y
# CONFIG_SCSI_OSD_ULD is not set
CONFIG_SCSI_OSD_DPRINT_SENSE=1
# CONFIG_SCSI_OSD_DEBUG is not set
# CONFIG_ATA is not set
CONFIG_MD=y
CONFIG_BLK_DEV_MD=y
CONFIG_MD_AUTODETECT=y
CONFIG_MD_LINEAR=y
# CONFIG_MD_RAID0 is not set
# CONFIG_MD_RAID1 is not set
CONFIG_MD_RAID10=y
CONFIG_MD_RAID456=y
# CONFIG_MD_MULTIPATH is not set
CONFIG_MD_FAULTY=y
# CONFIG_BCACHE is not set
CONFIG_BLK_DEV_DM=y
# CONFIG_DM_DEBUG is not set
CONFIG_DM_BUFIO=y
CONFIG_DM_BIO_PRISON=y
CONFIG_DM_PERSISTENT_DATA=y
CONFIG_DM_CRYPT=y
# CONFIG_DM_SNAPSHOT is not set
CONFIG_DM_THIN_PROVISIONING=y
# CONFIG_DM_DEBUG_BLOCK_STACK_TRACING is not set
CONFIG_DM_CACHE=y
CONFIG_DM_CACHE_MQ=y
CONFIG_DM_CACHE_CLEANER=y
CONFIG_DM_MIRROR=y
# CONFIG_DM_RAID is not set
CONFIG_DM_LOG_USERSPACE=y
# CONFIG_DM_ZERO is not set
CONFIG_DM_MULTIPATH=y
CONFIG_DM_MULTIPATH_QL=y
# CONFIG_DM_MULTIPATH_ST is not set
CONFIG_DM_DELAY=y
# CONFIG_DM_UEVENT is not set
# CONFIG_DM_FLAKEY is not set
# CONFIG_DM_VERITY is not set
CONFIG_DM_SWITCH=y
CONFIG_TARGET_CORE=y
CONFIG_TCM_IBLOCK=y
CONFIG_TCM_FILEIO=y
CONFIG_TCM_PSCSI=y
CONFIG_LOOPBACK_TARGET=y
# CONFIG_TCM_FC is not set
CONFIG_ISCSI_TARGET=y
# CONFIG_FUSION is not set

#
# IEEE 1394 (FireWire) support
#
# CONFIG_FIREWIRE is not set
CONFIG_FIREWIRE_NOSY=y
CONFIG_I2O=y
CONFIG_I2O_LCT_NOTIFY_ON_CHANGES=y
# CONFIG_I2O_EXT_ADAPTEC is not set
CONFIG_I2O_CONFIG=y
# CONFIG_I2O_CONFIG_OLD_IOCTL is not set
# CONFIG_I2O_BUS is not set
# CONFIG_I2O_BLOCK is not set
CONFIG_I2O_SCSI=y
CONFIG_I2O_PROC=y
CONFIG_MACINTOSH_DRIVERS=y
CONFIG_NETDEVICES=y
CONFIG_MII=y
CONFIG_NET_CORE=y
CONFIG_BONDING=y
# CONFIG_DUMMY is not set
# CONFIG_EQUALIZER is not set
# CONFIG_NET_FC is not set
CONFIG_NET_TEAM=y
CONFIG_NET_TEAM_MODE_BROADCAST=y
CONFIG_NET_TEAM_MODE_ROUNDROBIN=y
CONFIG_NET_TEAM_MODE_RANDOM=y
CONFIG_NET_TEAM_MODE_ACTIVEBACKUP=y
CONFIG_NET_TEAM_MODE_LOADBALANCE=y
CONFIG_MACVLAN=y
CONFIG_MACVTAP=y
CONFIG_VXLAN=y
# CONFIG_NETCONSOLE is not set
# CONFIG_NETPOLL is not set
# CONFIG_NET_POLL_CONTROLLER is not set
# CONFIG_RIONET is not set
# CONFIG_TUN is not set
CONFIG_VETH=y
CONFIG_VIRTIO_NET=y
CONFIG_NLMON=y
CONFIG_SUNGEM_PHY=y
CONFIG_ARCNET=y
# CONFIG_ARCNET_1201 is not set
CONFIG_ARCNET_1051=y
# CONFIG_ARCNET_RAW is not set
# CONFIG_ARCNET_CAP is not set
# CONFIG_ARCNET_COM90xx is not set
# CONFIG_ARCNET_COM90xxIO is not set
CONFIG_ARCNET_RIM_I=y
CONFIG_ARCNET_COM20020=y
CONFIG_ARCNET_COM20020_PCI=y
CONFIG_ARCNET_COM20020_CS=y
CONFIG_ATM_DRIVERS=y
CONFIG_ATM_DUMMY=y
# CONFIG_ATM_TCP is not set
CONFIG_ATM_LANAI=y
# CONFIG_ATM_ENI is not set
CONFIG_ATM_FIRESTREAM=y
# CONFIG_ATM_ZATM is not set
# CONFIG_ATM_NICSTAR is not set
CONFIG_ATM_IDT77252=y
# CONFIG_ATM_IDT77252_DEBUG is not set
# CONFIG_ATM_IDT77252_RCV_ALL is not set
CONFIG_ATM_IDT77252_USE_SUNI=y
# CONFIG_ATM_AMBASSADOR is not set
# CONFIG_ATM_HORIZON is not set
CONFIG_ATM_IA=y
CONFIG_ATM_IA_DEBUG=y
CONFIG_ATM_FORE200E=y
# CONFIG_ATM_FORE200E_USE_TASKLET is not set
CONFIG_ATM_FORE200E_TX_RETRY=16
CONFIG_ATM_FORE200E_DEBUG=0
# CONFIG_ATM_HE is not set
CONFIG_ATM_SOLOS=y

#
# CAIF transport drivers
#
CONFIG_CAIF_TTY=y
# CONFIG_CAIF_SPI_SLAVE is not set
CONFIG_CAIF_HSI=y
CONFIG_CAIF_VIRTIO=y
CONFIG_VHOST_NET=y
CONFIG_VHOST_RING=y
CONFIG_VHOST=y

#
# Distributed Switch Architecture drivers
#
CONFIG_NET_DSA_MV88E6XXX=y
CONFIG_NET_DSA_MV88E6060=y
CONFIG_NET_DSA_MV88E6XXX_NEED_PPU=y
CONFIG_NET_DSA_MV88E6131=y
CONFIG_NET_DSA_MV88E6123_61_65=y
CONFIG_ETHERNET=y
CONFIG_MDIO=y
CONFIG_NET_VENDOR_3COM=y
CONFIG_PCMCIA_3C574=y
CONFIG_PCMCIA_3C589=y
# CONFIG_VORTEX is not set
CONFIG_TYPHOON=y
CONFIG_NET_VENDOR_ADAPTEC=y
CONFIG_ADAPTEC_STARFIRE=y
# CONFIG_NET_VENDOR_ALTEON is not set
CONFIG_NET_VENDOR_AMD=y
CONFIG_AMD8111_ETH=y
CONFIG_PCNET32=y
CONFIG_PCMCIA_NMCLAN=y
# CONFIG_NET_VENDOR_ARC is not set
# CONFIG_NET_VENDOR_ATHEROS is not set
# CONFIG_NET_CADENCE is not set
CONFIG_NET_VENDOR_BROADCOM=y
CONFIG_B44=y
CONFIG_B44_PCI_AUTOSELECT=y
CONFIG_B44_PCICORE_AUTOSELECT=y
CONFIG_B44_PCI=y
CONFIG_BNX2=y
CONFIG_CNIC=y
CONFIG_TIGON3=y
CONFIG_BNX2X=y
# CONFIG_NET_VENDOR_BROCADE is not set
# CONFIG_NET_CALXEDA_XGMAC is not set
CONFIG_NET_VENDOR_CHELSIO=y
CONFIG_CHELSIO_T1=y
CONFIG_CHELSIO_T1_1G=y
CONFIG_CHELSIO_T3=y
CONFIG_CHELSIO_T4=y
CONFIG_CHELSIO_T4VF=y
# CONFIG_NET_VENDOR_CISCO is not set
# CONFIG_DNET is not set
CONFIG_NET_VENDOR_DEC=y
CONFIG_NET_TULIP=y
# CONFIG_DE2104X is not set
CONFIG_TULIP=y
# CONFIG_TULIP_MWI is not set
CONFIG_TULIP_MMIO=y
CONFIG_TULIP_NAPI=y
# CONFIG_TULIP_NAPI_HW_MITIGATION is not set
CONFIG_DE4X5=y
CONFIG_WINBOND_840=y
CONFIG_DM9102=y
CONFIG_ULI526X=y
# CONFIG_PCMCIA_XIRCOM is not set
# CONFIG_NET_VENDOR_DLINK is not set
CONFIG_NET_VENDOR_EMULEX=y
# CONFIG_BE2NET is not set
CONFIG_NET_VENDOR_EXAR=y
CONFIG_S2IO=y
# CONFIG_VXGE is not set
# CONFIG_NET_VENDOR_FUJITSU is not set
CONFIG_NET_VENDOR_HP=y
CONFIG_HP100=y
# CONFIG_NET_VENDOR_INTEL is not set
CONFIG_IP1000=y
CONFIG_JME=y
# CONFIG_NET_VENDOR_MARVELL is not set
# CONFIG_NET_VENDOR_MELLANOX is not set
# CONFIG_NET_VENDOR_MICREL is not set
CONFIG_NET_VENDOR_MICROCHIP=y
# CONFIG_ENC28J60 is not set
# CONFIG_NET_VENDOR_MYRI is not set
CONFIG_FEALNX=y
CONFIG_NET_VENDOR_NATSEMI=y
CONFIG_NATSEMI=y
# CONFIG_NS83820 is not set
CONFIG_NET_VENDOR_8390=y
CONFIG_PCMCIA_AXNET=y
# CONFIG_NE2K_PCI is not set
# CONFIG_PCMCIA_PCNET is not set
CONFIG_NET_VENDOR_NVIDIA=y
CONFIG_FORCEDETH=y
CONFIG_NET_VENDOR_OKI=y
CONFIG_PCH_GBE=y
# CONFIG_ETHOC is not set
CONFIG_NET_PACKET_ENGINE=y
# CONFIG_HAMACHI is not set
CONFIG_YELLOWFIN=y
CONFIG_NET_VENDOR_QLOGIC=y
CONFIG_QLA3XXX=y
CONFIG_QLCNIC=y
CONFIG_QLGE=y
CONFIG_NETXEN_NIC=y
# CONFIG_NET_VENDOR_REALTEK is not set
CONFIG_SH_ETH=y
# CONFIG_NET_VENDOR_RDC is not set
CONFIG_NET_VENDOR_SEEQ=y
CONFIG_NET_VENDOR_SILAN=y
CONFIG_SC92031=y
# CONFIG_NET_VENDOR_SIS is not set
# CONFIG_SFC is not set
# CONFIG_NET_VENDOR_SMSC is not set
CONFIG_NET_VENDOR_STMICRO=y
CONFIG_STMMAC_ETH=y
CONFIG_STMMAC_PLATFORM=y
# CONFIG_STMMAC_PCI is not set
# CONFIG_STMMAC_DEBUG_FS is not set
# CONFIG_STMMAC_DA is not set
CONFIG_NET_VENDOR_SUN=y
CONFIG_HAPPYMEAL=y
CONFIG_SUNGEM=y
CONFIG_CASSINI=y
CONFIG_NIU=y
CONFIG_NET_VENDOR_TEHUTI=y
CONFIG_TEHUTI=y
# CONFIG_NET_VENDOR_TI is not set
# CONFIG_NET_VENDOR_VIA is not set
# CONFIG_NET_VENDOR_WIZNET is not set
CONFIG_NET_VENDOR_XIRCOM=y
CONFIG_PCMCIA_XIRC2PS=y
# CONFIG_FDDI is not set
CONFIG_HIPPI=y
CONFIG_ROADRUNNER=y
CONFIG_ROADRUNNER_LARGE_RINGS=y
CONFIG_NET_SB1000=y
CONFIG_PHYLIB=y

#
# MII PHY device drivers
#
CONFIG_AT803X_PHY=y
CONFIG_AMD_PHY=y
CONFIG_MARVELL_PHY=y
CONFIG_DAVICOM_PHY=y
# CONFIG_QSEMI_PHY is not set
CONFIG_LXT_PHY=y
CONFIG_CICADA_PHY=y
CONFIG_VITESSE_PHY=y
CONFIG_SMSC_PHY=y
CONFIG_BROADCOM_PHY=y
# CONFIG_BCM87XX_PHY is not set
CONFIG_ICPLUS_PHY=y
# CONFIG_REALTEK_PHY is not set
CONFIG_NATIONAL_PHY=y
CONFIG_STE10XP=y
CONFIG_LSI_ET1011C_PHY=y
CONFIG_MICREL_PHY=y
CONFIG_FIXED_PHY=y
CONFIG_MDIO_BITBANG=y
CONFIG_MDIO_GPIO=y
CONFIG_MICREL_KS8995MA=y
# CONFIG_PPP is not set
CONFIG_SLIP=y
CONFIG_SLHC=y
CONFIG_SLIP_COMPRESSED=y
# CONFIG_SLIP_SMART is not set
CONFIG_SLIP_MODE_SLIP6=y

#
# USB Network Adapters
#
# CONFIG_USB_CATC is not set
CONFIG_USB_KAWETH=y
CONFIG_USB_PEGASUS=y
CONFIG_USB_RTL8150=y
# CONFIG_USB_RTL8152 is not set
CONFIG_USB_USBNET=y
# CONFIG_USB_NET_AX8817X is not set
CONFIG_USB_NET_AX88179_178A=y
CONFIG_USB_NET_CDCETHER=y
# CONFIG_USB_NET_CDC_EEM is not set
CONFIG_USB_NET_CDC_NCM=y
CONFIG_USB_NET_CDC_MBIM=y
CONFIG_USB_NET_DM9601=y
CONFIG_USB_NET_SMSC75XX=y
CONFIG_USB_NET_SMSC95XX=y
CONFIG_USB_NET_GL620A=y
CONFIG_USB_NET_NET1080=y
CONFIG_USB_NET_PLUSB=y
# CONFIG_USB_NET_MCS7830 is not set
CONFIG_USB_NET_RNDIS_HOST=y
CONFIG_USB_NET_CDC_SUBSET=y
# CONFIG_USB_ALI_M5632 is not set
CONFIG_USB_AN2720=y
CONFIG_USB_BELKIN=y
# CONFIG_USB_ARMLINUX is not set
CONFIG_USB_EPSON2888=y
CONFIG_USB_KC2190=y
CONFIG_USB_NET_ZAURUS=y
CONFIG_USB_NET_CX82310_ETH=y
# CONFIG_USB_NET_KALMIA is not set
CONFIG_USB_NET_QMI_WWAN=y
CONFIG_USB_HSO=y
# CONFIG_USB_NET_INT51X1 is not set
CONFIG_USB_CDC_PHONET=y
# CONFIG_USB_IPHETH is not set
CONFIG_USB_SIERRA_NET=y
CONFIG_USB_VL600=y
CONFIG_WLAN=y
CONFIG_PCMCIA_RAYCS=y
CONFIG_LIBERTAS_THINFIRM=y
CONFIG_LIBERTAS_THINFIRM_DEBUG=y
CONFIG_LIBERTAS_THINFIRM_USB=y
CONFIG_AIRO=y
CONFIG_ATMEL=y
CONFIG_PCI_ATMEL=y
# CONFIG_PCMCIA_ATMEL is not set
# CONFIG_AT76C50X_USB is not set
CONFIG_AIRO_CS=y
# CONFIG_PCMCIA_WL3501 is not set
CONFIG_PRISM54=y
CONFIG_USB_ZD1201=y
CONFIG_USB_NET_RNDIS_WLAN=y
CONFIG_RTL8180=y
CONFIG_RTL8187=y
CONFIG_RTL8187_LEDS=y
CONFIG_ADM8211=y
# CONFIG_MAC80211_HWSIM is not set
CONFIG_MWL8K=y
CONFIG_ATH_COMMON=y
CONFIG_ATH_CARDS=y
# CONFIG_ATH_DEBUG is not set
# CONFIG_ATH5K is not set
# CONFIG_ATH5K_PCI is not set
# CONFIG_ATH9K is not set
# CONFIG_ATH9K_HTC is not set
# CONFIG_CARL9170 is not set
CONFIG_ATH6KL=y
CONFIG_ATH6KL_SDIO=y
CONFIG_ATH6KL_USB=y
CONFIG_ATH6KL_DEBUG=y
# CONFIG_ATH6KL_REGDOMAIN is not set
CONFIG_AR5523=y
CONFIG_WIL6210=y
# CONFIG_WIL6210_ISR_COR is not set
# CONFIG_ATH10K is not set
CONFIG_B43=y
CONFIG_B43_SSB=y
CONFIG_B43_PCI_AUTOSELECT=y
CONFIG_B43_PCICORE_AUTOSELECT=y
CONFIG_B43_PCMCIA=y
CONFIG_B43_SDIO=y
CONFIG_B43_PIO=y
CONFIG_B43_PHY_N=y
# CONFIG_B43_PHY_LP is not set
CONFIG_B43_LEDS=y
CONFIG_B43_HWRNG=y
CONFIG_B43_DEBUG=y
CONFIG_B43LEGACY=y
CONFIG_B43LEGACY_PCI_AUTOSELECT=y
CONFIG_B43LEGACY_PCICORE_AUTOSELECT=y
CONFIG_B43LEGACY_LEDS=y
CONFIG_B43LEGACY_HWRNG=y
# CONFIG_B43LEGACY_DEBUG is not set
CONFIG_B43LEGACY_DMA=y
CONFIG_B43LEGACY_PIO=y
CONFIG_B43LEGACY_DMA_AND_PIO_MODE=y
# CONFIG_B43LEGACY_DMA_MODE is not set
# CONFIG_B43LEGACY_PIO_MODE is not set
CONFIG_BRCMUTIL=y
CONFIG_BRCMFMAC=y
CONFIG_BRCMFMAC_SDIO=y
CONFIG_BRCMFMAC_USB=y
# CONFIG_BRCM_TRACING is not set
CONFIG_BRCMDBG=y
CONFIG_HOSTAP=y
CONFIG_HOSTAP_FIRMWARE=y
CONFIG_HOSTAP_FIRMWARE_NVRAM=y
# CONFIG_HOSTAP_PLX is not set
# CONFIG_HOSTAP_PCI is not set
# CONFIG_HOSTAP_CS is not set
CONFIG_IPW2100=y
CONFIG_IPW2100_MONITOR=y
# CONFIG_IPW2100_DEBUG is not set
CONFIG_LIBIPW=y
# CONFIG_LIBIPW_DEBUG is not set
# CONFIG_IWLWIFI is not set
CONFIG_IWLEGACY=y
# CONFIG_IWL4965 is not set
CONFIG_IWL3945=y

#
# iwl3945 / iwl4965 Debugging Options
#
CONFIG_IWLEGACY_DEBUG=y
# CONFIG_LIBERTAS is not set
CONFIG_P54_COMMON=y
# CONFIG_P54_USB is not set
CONFIG_P54_PCI=y
CONFIG_P54_SPI=y
# CONFIG_P54_SPI_DEFAULT_EEPROM is not set
CONFIG_P54_LEDS=y
# CONFIG_RT2X00 is not set
CONFIG_RTL_CARDS=y
CONFIG_RTL8192CE=y
# CONFIG_RTL8192SE is not set
CONFIG_RTL8192DE=y
CONFIG_RTL8723AE=y
CONFIG_RTL8188EE=y
CONFIG_RTL8192CU=y
CONFIG_RTLWIFI=y
CONFIG_RTLWIFI_PCI=y
CONFIG_RTLWIFI_USB=y
# CONFIG_RTLWIFI_DEBUG is not set
CONFIG_RTL8192C_COMMON=y
CONFIG_WL_TI=y
CONFIG_WL1251=y
CONFIG_WL1251_SPI=y
CONFIG_WL1251_SDIO=y
# CONFIG_WL12XX is not set
CONFIG_WL18XX=y
CONFIG_WLCORE=y
CONFIG_WLCORE_SPI=y
CONFIG_WLCORE_SDIO=y
# CONFIG_WILINK_PLATFORM_DATA is not set
# CONFIG_ZD1211RW is not set
# CONFIG_MWIFIEX is not set
# CONFIG_CW1200 is not set

#
# WiMAX Wireless Broadband devices
#
# CONFIG_WIMAX_I2400M_USB is not set
CONFIG_WAN=y
# CONFIG_LANMEDIA is not set
CONFIG_HDLC=y
CONFIG_HDLC_RAW=y
CONFIG_HDLC_RAW_ETH=y
CONFIG_HDLC_CISCO=y
CONFIG_HDLC_FR=y
# CONFIG_HDLC_PPP is not set

#
# X.25/LAPB support is disabled
#
CONFIG_PCI200SYN=y
CONFIG_WANXL=y
# CONFIG_WANXL_BUILD_FIRMWARE is not set
CONFIG_PC300TOO=y
# CONFIG_FARSYNC is not set
# CONFIG_DLCI is not set
# CONFIG_SBNI is not set
CONFIG_IEEE802154_DRIVERS=y
CONFIG_IEEE802154_FAKEHARD=y
CONFIG_IEEE802154_FAKELB=y
CONFIG_IEEE802154_AT86RF230=y
CONFIG_IEEE802154_MRF24J40=y
CONFIG_VMXNET3=y
CONFIG_ISDN=y
# CONFIG_ISDN_I4L is not set
# CONFIG_ISDN_CAPI is not set
CONFIG_ISDN_DRV_GIGASET=y
CONFIG_GIGASET_DUMMYLL=y
CONFIG_GIGASET_BASE=y
# CONFIG_GIGASET_M105 is not set
CONFIG_GIGASET_M101=y
# CONFIG_GIGASET_DEBUG is not set
# CONFIG_MISDN is not set

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
# CONFIG_INPUT_MOUSE is not set
# CONFIG_INPUT_JOYSTICK is not set
# CONFIG_INPUT_TABLET is not set
# CONFIG_INPUT_TOUCHSCREEN is not set
# CONFIG_INPUT_MISC is not set

#
# Hardware I/O ports
#
CONFIG_SERIO=y
CONFIG_SERIO_I8042=y
CONFIG_SERIO_SERPORT=y
CONFIG_SERIO_CT82C710=y
CONFIG_SERIO_PCIPS2=y
CONFIG_SERIO_LIBPS2=y
CONFIG_SERIO_RAW=y
CONFIG_SERIO_ALTERA_PS2=y
CONFIG_SERIO_PS2MULT=y
CONFIG_SERIO_ARC_PS2=y
CONFIG_GAMEPORT=y
# CONFIG_GAMEPORT_NS558 is not set
CONFIG_GAMEPORT_L4=y
CONFIG_GAMEPORT_EMU10K1=y
CONFIG_GAMEPORT_FM801=y

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
CONFIG_NOZOMI=y
CONFIG_N_GSM=y
# CONFIG_TRACE_ROUTER is not set
CONFIG_TRACE_SINK=y
# CONFIG_DEVKMEM is not set

#
# Serial drivers
#
CONFIG_SERIAL_8250=y
# CONFIG_SERIAL_8250_DEPRECATED_OPTIONS is not set
# CONFIG_SERIAL_8250_PNP is not set
CONFIG_SERIAL_8250_CONSOLE=y
CONFIG_FIX_EARLYCON_MEM=y
CONFIG_SERIAL_8250_DMA=y
# CONFIG_SERIAL_8250_PCI is not set
# CONFIG_SERIAL_8250_CS is not set
CONFIG_SERIAL_8250_NR_UARTS=4
CONFIG_SERIAL_8250_RUNTIME_UARTS=4
# CONFIG_SERIAL_8250_EXTENDED is not set
CONFIG_SERIAL_8250_DW=y

#
# Non-8250 serial port support
#
CONFIG_SERIAL_MAX3100=y
CONFIG_SERIAL_MAX310X=y
# CONFIG_SERIAL_MFD_HSU is not set
CONFIG_SERIAL_UARTLITE=y
CONFIG_SERIAL_UARTLITE_CONSOLE=y
CONFIG_SERIAL_CORE=y
CONFIG_SERIAL_CORE_CONSOLE=y
# CONFIG_SERIAL_JSM is not set
CONFIG_SERIAL_SCCNXP=y
CONFIG_SERIAL_SCCNXP_CONSOLE=y
CONFIG_SERIAL_TIMBERDALE=y
CONFIG_SERIAL_ALTERA_JTAGUART=y
CONFIG_SERIAL_ALTERA_JTAGUART_CONSOLE=y
# CONFIG_SERIAL_ALTERA_JTAGUART_CONSOLE_BYPASS is not set
CONFIG_SERIAL_ALTERA_UART=y
CONFIG_SERIAL_ALTERA_UART_MAXPORTS=4
CONFIG_SERIAL_ALTERA_UART_BAUDRATE=115200
CONFIG_SERIAL_ALTERA_UART_CONSOLE=y
CONFIG_SERIAL_IFX6X60=y
CONFIG_SERIAL_PCH_UART=y
CONFIG_SERIAL_PCH_UART_CONSOLE=y
CONFIG_SERIAL_ARC=y
CONFIG_SERIAL_ARC_CONSOLE=y
CONFIG_SERIAL_ARC_NR_PORTS=1
CONFIG_SERIAL_RP2=y
CONFIG_SERIAL_RP2_NR_UARTS=32
# CONFIG_SERIAL_FSL_LPUART is not set
# CONFIG_TTY_PRINTK is not set
CONFIG_HVC_DRIVER=y
CONFIG_VIRTIO_CONSOLE=y
# CONFIG_IPMI_HANDLER is not set
CONFIG_HW_RANDOM=y
# CONFIG_HW_RANDOM_TIMERIOMEM is not set
# CONFIG_HW_RANDOM_INTEL is not set
CONFIG_HW_RANDOM_AMD=y
CONFIG_HW_RANDOM_VIA=y
# CONFIG_HW_RANDOM_VIRTIO is not set
CONFIG_HW_RANDOM_TPM=y
# CONFIG_NVRAM is not set
# CONFIG_R3964 is not set
# CONFIG_APPLICOM is not set

#
# PCMCIA character devices
#
# CONFIG_SYNCLINK_CS is not set
CONFIG_CARDMAN_4000=y
CONFIG_CARDMAN_4040=y
# CONFIG_IPWIRELESS is not set
CONFIG_MWAVE=y
# CONFIG_RAW_DRIVER is not set
# CONFIG_HPET is not set
CONFIG_HANGCHECK_TIMER=y
CONFIG_TCG_TPM=y
CONFIG_TCG_TIS=y
# CONFIG_TCG_TIS_I2C_INFINEON is not set
# CONFIG_TCG_NSC is not set
CONFIG_TCG_ATMEL=y
# CONFIG_TCG_INFINEON is not set
# CONFIG_TCG_ST33_I2C is not set
CONFIG_TELCLOCK=y
CONFIG_DEVPORT=y
CONFIG_I2C=y
CONFIG_I2C_BOARDINFO=y
# CONFIG_I2C_COMPAT is not set
# CONFIG_I2C_CHARDEV is not set
CONFIG_I2C_MUX=y

#
# Multiplexer I2C Chip support
#
# CONFIG_I2C_MUX_GPIO is not set
CONFIG_I2C_MUX_PCA9541=y
# CONFIG_I2C_MUX_PCA954x is not set
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
CONFIG_I2C_AMD756=y
CONFIG_I2C_AMD756_S4882=y
CONFIG_I2C_AMD8111=y
CONFIG_I2C_I801=y
CONFIG_I2C_ISCH=y
CONFIG_I2C_ISMT=y
CONFIG_I2C_PIIX4=y
CONFIG_I2C_NFORCE2=y
CONFIG_I2C_NFORCE2_S4985=y
CONFIG_I2C_SIS5595=y
CONFIG_I2C_SIS630=y
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
CONFIG_I2C_CBUS_GPIO=y
# CONFIG_I2C_DESIGNWARE_PCI is not set
# CONFIG_I2C_EG20T is not set
# CONFIG_I2C_GPIO is not set
# CONFIG_I2C_KEMPLD is not set
# CONFIG_I2C_OCORES is not set
CONFIG_I2C_PCA_PLATFORM=y
# CONFIG_I2C_PXA_PCI is not set
CONFIG_I2C_SIMTEC=y
# CONFIG_I2C_XILINX is not set

#
# External I2C/SMBus adapter drivers
#
# CONFIG_I2C_DIOLAN_U2C is not set
CONFIG_I2C_PARPORT_LIGHT=y
CONFIG_I2C_TAOS_EVM=y
CONFIG_I2C_TINY_USB=y
# CONFIG_I2C_VIPERBOARD is not set

#
# Other I2C/SMBus bus drivers
#
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
CONFIG_SPI_GPIO=y
# CONFIG_SPI_OC_TINY is not set
CONFIG_SPI_PXA2XX_DMA=y
CONFIG_SPI_PXA2XX=y
CONFIG_SPI_PXA2XX_PCI=y
# CONFIG_SPI_SC18IS602 is not set
CONFIG_SPI_TOPCLIFF_PCH=y
# CONFIG_SPI_XCOMM is not set
# CONFIG_SPI_XILINX is not set
CONFIG_SPI_DESIGNWARE=y
# CONFIG_SPI_DW_PCI is not set

#
# SPI Protocol Masters
#
CONFIG_SPI_SPIDEV=y
CONFIG_SPI_TLE62X0=y
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
CONFIG_PPS_CLIENT_KTIMER=y
CONFIG_PPS_CLIENT_LDISC=y
# CONFIG_PPS_CLIENT_GPIO is not set

#
# PPS generators support
#

#
# PTP clock support
#
CONFIG_PTP_1588_CLOCK=y
CONFIG_DP83640_PHY=y
CONFIG_PTP_1588_CLOCK_PCH=y
CONFIG_ARCH_WANT_OPTIONAL_GPIOLIB=y
CONFIG_GPIO_DEVRES=y
CONFIG_GPIOLIB=y
CONFIG_GPIO_ACPI=y
CONFIG_DEBUG_GPIO=y
# CONFIG_GPIO_SYSFS is not set
CONFIG_GPIO_GENERIC=y
# CONFIG_GPIO_DA9052 is not set
CONFIG_GPIO_MAX730X=y

#
# Memory mapped GPIO drivers:
#
CONFIG_GPIO_GENERIC_PLATFORM=y
CONFIG_GPIO_IT8761E=y
CONFIG_GPIO_TS5500=y
CONFIG_GPIO_SCH=y
CONFIG_GPIO_ICH=y
# CONFIG_GPIO_VX855 is not set
# CONFIG_GPIO_LYNXPOINT is not set

#
# I2C GPIO expanders:
#
CONFIG_GPIO_MAX7300=y
CONFIG_GPIO_MAX732X=y
CONFIG_GPIO_MAX732X_IRQ=y
CONFIG_GPIO_PCA953X=y
# CONFIG_GPIO_PCA953X_IRQ is not set
# CONFIG_GPIO_PCF857X is not set
# CONFIG_GPIO_SX150X is not set
CONFIG_GPIO_TC3589X=y
# CONFIG_GPIO_TPS65912 is not set
CONFIG_GPIO_TWL4030=y
CONFIG_GPIO_TWL6040=y
# CONFIG_GPIO_WM8994 is not set
CONFIG_GPIO_ADP5588=y
# CONFIG_GPIO_ADP5588_IRQ is not set

#
# PCI GPIO expanders:
#
# CONFIG_GPIO_CS5535 is not set
CONFIG_GPIO_BT8XX=y
CONFIG_GPIO_AMD8111=y
# CONFIG_GPIO_LANGWELL is not set
CONFIG_GPIO_PCH=y
CONFIG_GPIO_ML_IOH=y
# CONFIG_GPIO_TIMBERDALE is not set
# CONFIG_GPIO_RDC321X is not set

#
# SPI GPIO expanders:
#
CONFIG_GPIO_MAX7301=y
CONFIG_GPIO_MCP23S08=y
CONFIG_GPIO_MC33880=y
# CONFIG_GPIO_74X164 is not set

#
# AC97 GPIO expanders:
#

#
# MODULbus GPIO expanders:
#
CONFIG_GPIO_JANZ_TTL=y
# CONFIG_GPIO_TPS65910 is not set

#
# USB GPIO expanders:
#
CONFIG_GPIO_VIPERBOARD=y
CONFIG_W1=y
# CONFIG_W1_CON is not set

#
# 1-wire Bus Masters
#
# CONFIG_W1_MASTER_MATROX is not set
# CONFIG_W1_MASTER_DS2490 is not set
CONFIG_W1_MASTER_DS2482=y
# CONFIG_W1_MASTER_DS1WM is not set
CONFIG_W1_MASTER_GPIO=y

#
# 1-wire Slaves
#
CONFIG_W1_SLAVE_THERM=y
CONFIG_W1_SLAVE_SMEM=y
# CONFIG_W1_SLAVE_DS2408 is not set
CONFIG_W1_SLAVE_DS2413=y
CONFIG_W1_SLAVE_DS2423=y
CONFIG_W1_SLAVE_DS2431=y
# CONFIG_W1_SLAVE_DS2433 is not set
CONFIG_W1_SLAVE_DS2760=y
CONFIG_W1_SLAVE_DS2780=y
# CONFIG_W1_SLAVE_DS2781 is not set
# CONFIG_W1_SLAVE_DS28E04 is not set
CONFIG_W1_SLAVE_BQ27000=y
CONFIG_POWER_SUPPLY=y
CONFIG_POWER_SUPPLY_DEBUG=y
CONFIG_PDA_POWER=y
CONFIG_MAX8925_POWER=y
CONFIG_TEST_POWER=y
# CONFIG_BATTERY_88PM860X is not set
# CONFIG_BATTERY_DS2760 is not set
CONFIG_BATTERY_DS2780=y
# CONFIG_BATTERY_DS2781 is not set
CONFIG_BATTERY_DS2782=y
CONFIG_BATTERY_SBS=y
CONFIG_BATTERY_BQ27x00=y
CONFIG_BATTERY_BQ27X00_I2C=y
# CONFIG_BATTERY_BQ27X00_PLATFORM is not set
CONFIG_BATTERY_DA9030=y
CONFIG_BATTERY_DA9052=y
CONFIG_BATTERY_MAX17040=y
CONFIG_BATTERY_MAX17042=y
CONFIG_CHARGER_MAX8903=y
CONFIG_CHARGER_TWL4030=y
# CONFIG_CHARGER_LP8727 is not set
CONFIG_CHARGER_GPIO=y
CONFIG_CHARGER_MAX8997=y
CONFIG_CHARGER_MAX8998=y
CONFIG_CHARGER_BQ2415X=y
CONFIG_CHARGER_SMB347=y
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
CONFIG_SENSORS_ABITUGURU3=y
CONFIG_SENSORS_AD7314=y
CONFIG_SENSORS_AD7414=y
# CONFIG_SENSORS_AD7418 is not set
CONFIG_SENSORS_ADCXX=y
# CONFIG_SENSORS_ADM1021 is not set
CONFIG_SENSORS_ADM1025=y
CONFIG_SENSORS_ADM1026=y
# CONFIG_SENSORS_ADM1029 is not set
# CONFIG_SENSORS_ADM1031 is not set
CONFIG_SENSORS_ADM9240=y
CONFIG_SENSORS_ADT7X10=y
CONFIG_SENSORS_ADT7310=y
# CONFIG_SENSORS_ADT7410 is not set
# CONFIG_SENSORS_ADT7411 is not set
CONFIG_SENSORS_ADT7462=y
CONFIG_SENSORS_ADT7470=y
CONFIG_SENSORS_ADT7475=y
CONFIG_SENSORS_ASC7621=y
# CONFIG_SENSORS_K8TEMP is not set
CONFIG_SENSORS_K10TEMP=y
CONFIG_SENSORS_FAM15H_POWER=y
CONFIG_SENSORS_ASB100=y
CONFIG_SENSORS_ATXP1=y
CONFIG_SENSORS_DS620=y
CONFIG_SENSORS_DS1621=y
CONFIG_SENSORS_DA9052_ADC=y
CONFIG_SENSORS_I5K_AMB=y
CONFIG_SENSORS_F71805F=y
CONFIG_SENSORS_F71882FG=y
CONFIG_SENSORS_F75375S=y
CONFIG_SENSORS_FSCHMD=y
CONFIG_SENSORS_G760A=y
# CONFIG_SENSORS_G762 is not set
# CONFIG_SENSORS_GL518SM is not set
CONFIG_SENSORS_GL520SM=y
CONFIG_SENSORS_GPIO_FAN=y
CONFIG_SENSORS_HIH6130=y
# CONFIG_SENSORS_CORETEMP is not set
# CONFIG_SENSORS_IT87 is not set
CONFIG_SENSORS_JC42=y
# CONFIG_SENSORS_LINEAGE is not set
# CONFIG_SENSORS_LM63 is not set
CONFIG_SENSORS_LM70=y
# CONFIG_SENSORS_LM73 is not set
# CONFIG_SENSORS_LM75 is not set
# CONFIG_SENSORS_LM77 is not set
CONFIG_SENSORS_LM78=y
# CONFIG_SENSORS_LM80 is not set
# CONFIG_SENSORS_LM83 is not set
CONFIG_SENSORS_LM85=y
# CONFIG_SENSORS_LM87 is not set
CONFIG_SENSORS_LM90=y
# CONFIG_SENSORS_LM92 is not set
CONFIG_SENSORS_LM93=y
# CONFIG_SENSORS_LTC4151 is not set
CONFIG_SENSORS_LTC4215=y
# CONFIG_SENSORS_LTC4245 is not set
CONFIG_SENSORS_LTC4261=y
# CONFIG_SENSORS_LM95234 is not set
CONFIG_SENSORS_LM95241=y
CONFIG_SENSORS_LM95245=y
CONFIG_SENSORS_MAX1111=y
# CONFIG_SENSORS_MAX16065 is not set
CONFIG_SENSORS_MAX1619=y
# CONFIG_SENSORS_MAX1668 is not set
CONFIG_SENSORS_MAX197=y
CONFIG_SENSORS_MAX6639=y
CONFIG_SENSORS_MAX6642=y
# CONFIG_SENSORS_MAX6650 is not set
CONFIG_SENSORS_MAX6697=y
CONFIG_SENSORS_MCP3021=y
CONFIG_SENSORS_NCT6775=y
# CONFIG_SENSORS_NTC_THERMISTOR is not set
# CONFIG_SENSORS_PC87360 is not set
# CONFIG_SENSORS_PC87427 is not set
CONFIG_SENSORS_PCF8591=y
CONFIG_PMBUS=y
CONFIG_SENSORS_PMBUS=y
CONFIG_SENSORS_ADM1275=y
# CONFIG_SENSORS_LM25066 is not set
# CONFIG_SENSORS_LTC2978 is not set
# CONFIG_SENSORS_MAX16064 is not set
CONFIG_SENSORS_MAX34440=y
# CONFIG_SENSORS_MAX8688 is not set
# CONFIG_SENSORS_UCD9000 is not set
# CONFIG_SENSORS_UCD9200 is not set
CONFIG_SENSORS_ZL6100=y
# CONFIG_SENSORS_SHT15 is not set
CONFIG_SENSORS_SHT21=y
CONFIG_SENSORS_SIS5595=y
CONFIG_SENSORS_SMM665=y
# CONFIG_SENSORS_DME1737 is not set
CONFIG_SENSORS_EMC1403=y
CONFIG_SENSORS_EMC2103=y
CONFIG_SENSORS_EMC6W201=y
CONFIG_SENSORS_SMSC47M1=y
CONFIG_SENSORS_SMSC47M192=y
CONFIG_SENSORS_SMSC47B397=y
# CONFIG_SENSORS_SCH56XX_COMMON is not set
CONFIG_SENSORS_ADS1015=y
CONFIG_SENSORS_ADS7828=y
CONFIG_SENSORS_ADS7871=y
CONFIG_SENSORS_AMC6821=y
# CONFIG_SENSORS_INA209 is not set
# CONFIG_SENSORS_INA2XX is not set
# CONFIG_SENSORS_THMC50 is not set
CONFIG_SENSORS_TMP102=y
# CONFIG_SENSORS_TMP401 is not set
# CONFIG_SENSORS_TMP421 is not set
CONFIG_SENSORS_VIA_CPUTEMP=y
# CONFIG_SENSORS_VIA686A is not set
CONFIG_SENSORS_VT1211=y
# CONFIG_SENSORS_VT8231 is not set
CONFIG_SENSORS_W83781D=y
CONFIG_SENSORS_W83791D=y
CONFIG_SENSORS_W83792D=y
CONFIG_SENSORS_W83793=y
# CONFIG_SENSORS_W83795 is not set
CONFIG_SENSORS_W83L785TS=y
CONFIG_SENSORS_W83L786NG=y
# CONFIG_SENSORS_W83627HF is not set
# CONFIG_SENSORS_W83627EHF is not set
CONFIG_SENSORS_APPLESMC=y
CONFIG_SENSORS_MC13783_ADC=y

#
# ACPI drivers
#
# CONFIG_SENSORS_ACPI_POWER is not set
CONFIG_SENSORS_ATK0110=y
CONFIG_THERMAL=y
CONFIG_THERMAL_HWMON=y
# CONFIG_THERMAL_DEFAULT_GOV_STEP_WISE is not set
CONFIG_THERMAL_DEFAULT_GOV_FAIR_SHARE=y
# CONFIG_THERMAL_DEFAULT_GOV_USER_SPACE is not set
CONFIG_THERMAL_GOV_FAIR_SHARE=y
# CONFIG_THERMAL_GOV_STEP_WISE is not set
# CONFIG_THERMAL_GOV_USER_SPACE is not set
CONFIG_CPU_THERMAL=y
# CONFIG_THERMAL_EMULATION is not set
CONFIG_INTEL_POWERCLAMP=y
# CONFIG_X86_PKG_TEMP_THERMAL is not set

#
# Texas Instruments thermal drivers
#
# CONFIG_WATCHDOG is not set
CONFIG_SSB_POSSIBLE=y

#
# Sonics Silicon Backplane
#
CONFIG_SSB=y
CONFIG_SSB_SPROM=y
CONFIG_SSB_BLOCKIO=y
CONFIG_SSB_PCIHOST_POSSIBLE=y
CONFIG_SSB_PCIHOST=y
CONFIG_SSB_B43_PCI_BRIDGE=y
CONFIG_SSB_PCMCIAHOST_POSSIBLE=y
CONFIG_SSB_PCMCIAHOST=y
CONFIG_SSB_SDIOHOST_POSSIBLE=y
CONFIG_SSB_SDIOHOST=y
# CONFIG_SSB_SILENT is not set
CONFIG_SSB_DEBUG=y
CONFIG_SSB_DRIVER_PCICORE_POSSIBLE=y
CONFIG_SSB_DRIVER_PCICORE=y
# CONFIG_SSB_DRIVER_GPIO is not set
CONFIG_BCMA_POSSIBLE=y

#
# Broadcom specific AMBA
#
# CONFIG_BCMA is not set

#
# Multifunction device drivers
#
CONFIG_MFD_CORE=y
CONFIG_MFD_CS5535=y
CONFIG_MFD_AS3711=y
# CONFIG_PMIC_ADP5520 is not set
# CONFIG_MFD_AAT2870_CORE is not set
CONFIG_MFD_CROS_EC=y
# CONFIG_MFD_CROS_EC_I2C is not set
# CONFIG_MFD_CROS_EC_SPI is not set
CONFIG_PMIC_DA903X=y
CONFIG_PMIC_DA9052=y
CONFIG_MFD_DA9052_SPI=y
# CONFIG_MFD_DA9052_I2C is not set
# CONFIG_MFD_DA9055 is not set
CONFIG_MFD_MC13783=y
CONFIG_MFD_MC13XXX=y
CONFIG_MFD_MC13XXX_SPI=y
# CONFIG_MFD_MC13XXX_I2C is not set
CONFIG_HTC_PASIC3=y
# CONFIG_HTC_I2CPLD is not set
CONFIG_LPC_ICH=y
CONFIG_LPC_SCH=y
CONFIG_MFD_JANZ_CMODIO=y
CONFIG_MFD_KEMPLD=y
CONFIG_MFD_88PM800=y
CONFIG_MFD_88PM805=y
CONFIG_MFD_88PM860X=y
CONFIG_MFD_MAX77686=y
# CONFIG_MFD_MAX77693 is not set
CONFIG_MFD_MAX8907=y
CONFIG_MFD_MAX8925=y
CONFIG_MFD_MAX8997=y
CONFIG_MFD_MAX8998=y
# CONFIG_EZX_PCAP is not set
CONFIG_MFD_VIPERBOARD=y
# CONFIG_MFD_RETU is not set
# CONFIG_MFD_PCF50633 is not set
CONFIG_MFD_RDC321X=y
# CONFIG_MFD_RTSX_PCI is not set
# CONFIG_MFD_RC5T583 is not set
# CONFIG_MFD_SEC_CORE is not set
CONFIG_MFD_SI476X_CORE=y
# CONFIG_MFD_SM501 is not set
# CONFIG_MFD_SMSC is not set
CONFIG_ABX500_CORE=y
# CONFIG_AB3100_CORE is not set
# CONFIG_MFD_STMPE is not set
CONFIG_MFD_SYSCON=y
CONFIG_MFD_TI_AM335X_TSCADC=y
CONFIG_MFD_LP8788=y
# CONFIG_MFD_PALMAS is not set
CONFIG_TPS6105X=y
# CONFIG_TPS65010 is not set
# CONFIG_TPS6507X is not set
# CONFIG_MFD_TPS65090 is not set
# CONFIG_MFD_TPS65217 is not set
# CONFIG_MFD_TPS6586X is not set
CONFIG_MFD_TPS65910=y
CONFIG_MFD_TPS65912=y
CONFIG_MFD_TPS65912_I2C=y
CONFIG_MFD_TPS65912_SPI=y
# CONFIG_MFD_TPS80031 is not set
CONFIG_TWL4030_CORE=y
# CONFIG_TWL4030_MADC is not set
CONFIG_MFD_TWL4030_AUDIO=y
CONFIG_TWL6040_CORE=y
# CONFIG_MFD_WL1273_CORE is not set
CONFIG_MFD_LM3533=y
CONFIG_MFD_TIMBERDALE=y
CONFIG_MFD_TC3589X=y
# CONFIG_MFD_TMIO is not set
CONFIG_MFD_VX855=y
# CONFIG_MFD_ARIZONA_I2C is not set
# CONFIG_MFD_ARIZONA_SPI is not set
CONFIG_MFD_WM8400=y
# CONFIG_MFD_WM831X_I2C is not set
# CONFIG_MFD_WM831X_SPI is not set
# CONFIG_MFD_WM8350_I2C is not set
CONFIG_MFD_WM8994=y
CONFIG_REGULATOR=y
CONFIG_REGULATOR_DEBUG=y
CONFIG_REGULATOR_DUMMY=y
CONFIG_REGULATOR_FIXED_VOLTAGE=y
CONFIG_REGULATOR_VIRTUAL_CONSUMER=y
# CONFIG_REGULATOR_USERSPACE_CONSUMER is not set
# CONFIG_REGULATOR_88PM800 is not set
# CONFIG_REGULATOR_88PM8607 is not set
CONFIG_REGULATOR_AD5398=y
# CONFIG_REGULATOR_ANATOP is not set
CONFIG_REGULATOR_AS3711=y
CONFIG_REGULATOR_DA903X=y
CONFIG_REGULATOR_DA9052=y
CONFIG_REGULATOR_FAN53555=y
# CONFIG_REGULATOR_GPIO is not set
CONFIG_REGULATOR_ISL6271A=y
CONFIG_REGULATOR_LP3971=y
CONFIG_REGULATOR_LP3972=y
CONFIG_REGULATOR_LP872X=y
CONFIG_REGULATOR_LP8755=y
CONFIG_REGULATOR_LP8788=y
# CONFIG_REGULATOR_MAX1586 is not set
CONFIG_REGULATOR_MAX8649=y
# CONFIG_REGULATOR_MAX8660 is not set
CONFIG_REGULATOR_MAX8907=y
# CONFIG_REGULATOR_MAX8925 is not set
CONFIG_REGULATOR_MAX8952=y
CONFIG_REGULATOR_MAX8973=y
CONFIG_REGULATOR_MAX8997=y
CONFIG_REGULATOR_MAX8998=y
CONFIG_REGULATOR_MAX77686=y
CONFIG_REGULATOR_MC13XXX_CORE=y
CONFIG_REGULATOR_MC13783=y
CONFIG_REGULATOR_MC13892=y
CONFIG_REGULATOR_TPS51632=y
CONFIG_REGULATOR_TPS6105X=y
# CONFIG_REGULATOR_TPS62360 is not set
CONFIG_REGULATOR_TPS65023=y
# CONFIG_REGULATOR_TPS6507X is not set
# CONFIG_REGULATOR_TPS6524X is not set
# CONFIG_REGULATOR_TPS65910 is not set
# CONFIG_REGULATOR_TPS65912 is not set
CONFIG_REGULATOR_TWL4030=y
# CONFIG_REGULATOR_WM8400 is not set
# CONFIG_REGULATOR_WM8994 is not set
# CONFIG_MEDIA_SUPPORT is not set

#
# Graphics support
#
CONFIG_AGP=y
CONFIG_AGP_AMD64=y
# CONFIG_AGP_INTEL is not set
# CONFIG_AGP_SIS is not set
# CONFIG_AGP_VIA is not set
CONFIG_VGA_ARB=y
CONFIG_VGA_ARB_MAX_GPUS=16
# CONFIG_VGA_SWITCHEROO is not set
CONFIG_DRM=y
CONFIG_DRM_USB=y
CONFIG_DRM_KMS_HELPER=y
# CONFIG_DRM_LOAD_EDID_FIRMWARE is not set
CONFIG_DRM_TTM=y

#
# I2C encoder or helper chips
#
CONFIG_DRM_I2C_CH7006=y
CONFIG_DRM_I2C_SIL164=y
CONFIG_DRM_I2C_NXP_TDA998X=y
# CONFIG_DRM_TDFX is not set
CONFIG_DRM_R128=y
CONFIG_DRM_RADEON=y
# CONFIG_DRM_RADEON_UMS is not set
CONFIG_DRM_NOUVEAU=y
CONFIG_NOUVEAU_DEBUG=5
CONFIG_NOUVEAU_DEBUG_DEFAULT=3
# CONFIG_DRM_NOUVEAU_BACKLIGHT is not set
CONFIG_DRM_MGA=y
CONFIG_DRM_SIS=y
# CONFIG_DRM_VIA is not set
CONFIG_DRM_SAVAGE=y
CONFIG_DRM_VMWGFX=y
# CONFIG_DRM_VMWGFX_FBCON is not set
# CONFIG_DRM_GMA500 is not set
CONFIG_DRM_UDL=y
CONFIG_DRM_AST=y
CONFIG_DRM_MGAG200=y
CONFIG_DRM_CIRRUS_QEMU=y
# CONFIG_DRM_QXL is not set
CONFIG_VGASTATE=y
CONFIG_VIDEO_OUTPUT_CONTROL=y
CONFIG_HDMI=y
CONFIG_FB=y
CONFIG_FIRMWARE_EDID=y
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
CONFIG_FB_BIG_ENDIAN=y
# CONFIG_FB_LITTLE_ENDIAN is not set
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
# CONFIG_FB_PM2 is not set
CONFIG_FB_CYBER2000=y
# CONFIG_FB_CYBER2000_DDC is not set
CONFIG_FB_ARC=y
CONFIG_FB_ASILIANT=y
CONFIG_FB_IMSTT=y
# CONFIG_FB_VGA16 is not set
CONFIG_FB_UVESA=y
CONFIG_FB_VESA=y
CONFIG_FB_EFI=y
# CONFIG_FB_N411 is not set
CONFIG_FB_HGA=y
# CONFIG_FB_S1D13XXX is not set
CONFIG_FB_NVIDIA=y
CONFIG_FB_NVIDIA_I2C=y
CONFIG_FB_NVIDIA_DEBUG=y
CONFIG_FB_NVIDIA_BACKLIGHT=y
CONFIG_FB_RIVA=y
# CONFIG_FB_RIVA_I2C is not set
CONFIG_FB_RIVA_DEBUG=y
CONFIG_FB_RIVA_BACKLIGHT=y
CONFIG_FB_I740=y
CONFIG_FB_LE80578=y
CONFIG_FB_CARILLO_RANCH=y
CONFIG_FB_MATROX=y
CONFIG_FB_MATROX_MILLENIUM=y
CONFIG_FB_MATROX_MYSTIQUE=y
CONFIG_FB_MATROX_G=y
CONFIG_FB_MATROX_I2C=y
# CONFIG_FB_MATROX_MAVEN is not set
CONFIG_FB_RADEON=y
# CONFIG_FB_RADEON_I2C is not set
CONFIG_FB_RADEON_BACKLIGHT=y
# CONFIG_FB_RADEON_DEBUG is not set
CONFIG_FB_ATY128=y
# CONFIG_FB_ATY128_BACKLIGHT is not set
# CONFIG_FB_ATY is not set
# CONFIG_FB_S3 is not set
CONFIG_FB_SAVAGE=y
CONFIG_FB_SAVAGE_I2C=y
# CONFIG_FB_SAVAGE_ACCEL is not set
# CONFIG_FB_SIS is not set
CONFIG_FB_VIA=y
# CONFIG_FB_VIA_DIRECT_PROCFS is not set
# CONFIG_FB_VIA_X_COMPATIBILITY is not set
CONFIG_FB_NEOMAGIC=y
CONFIG_FB_KYRO=y
# CONFIG_FB_3DFX is not set
# CONFIG_FB_VOODOO1 is not set
CONFIG_FB_VT8623=y
# CONFIG_FB_TRIDENT is not set
CONFIG_FB_ARK=y
CONFIG_FB_PM3=y
CONFIG_FB_CARMINE=y
# CONFIG_FB_CARMINE_DRAM_EVAL is not set
CONFIG_CARMINE_DRAM_CUSTOM=y
# CONFIG_FB_GEODE is not set
# CONFIG_FB_TMIO is not set
CONFIG_FB_SMSCUFX=y
CONFIG_FB_UDL=y
CONFIG_FB_GOLDFISH=y
CONFIG_FB_VIRTUAL=y
CONFIG_FB_METRONOME=y
# CONFIG_FB_MB862XX is not set
CONFIG_FB_BROADSHEET=y
# CONFIG_FB_AUO_K190X is not set
# CONFIG_EXYNOS_VIDEO is not set
CONFIG_BACKLIGHT_LCD_SUPPORT=y
CONFIG_LCD_CLASS_DEVICE=y
# CONFIG_LCD_L4F00242T03 is not set
CONFIG_LCD_LMS283GF05=y
CONFIG_LCD_LTV350QV=y
CONFIG_LCD_ILI922X=y
CONFIG_LCD_ILI9320=y
CONFIG_LCD_TDO24M=y
# CONFIG_LCD_VGG2432A4 is not set
CONFIG_LCD_PLATFORM=y
CONFIG_LCD_S6E63M0=y
CONFIG_LCD_LD9040=y
CONFIG_LCD_AMS369FG06=y
# CONFIG_LCD_LMS501KF03 is not set
CONFIG_LCD_HX8357=y
CONFIG_BACKLIGHT_CLASS_DEVICE=y
# CONFIG_BACKLIGHT_GENERIC is not set
CONFIG_BACKLIGHT_LM3533=y
CONFIG_BACKLIGHT_CARILLO_RANCH=y
CONFIG_BACKLIGHT_PWM=y
CONFIG_BACKLIGHT_DA903X=y
# CONFIG_BACKLIGHT_DA9052 is not set
# CONFIG_BACKLIGHT_MAX8925 is not set
CONFIG_BACKLIGHT_APPLE=y
# CONFIG_BACKLIGHT_SAHARA is not set
CONFIG_BACKLIGHT_ADP8860=y
CONFIG_BACKLIGHT_ADP8870=y
CONFIG_BACKLIGHT_88PM860X=y
# CONFIG_BACKLIGHT_LM3630 is not set
CONFIG_BACKLIGHT_LM3639=y
CONFIG_BACKLIGHT_LP855X=y
CONFIG_BACKLIGHT_LP8788=y
# CONFIG_BACKLIGHT_PANDORA is not set
CONFIG_BACKLIGHT_AS3711=y
# CONFIG_LOGO is not set
CONFIG_SOUND=y
# CONFIG_SOUND_OSS_CORE is not set
# CONFIG_SND is not set
# CONFIG_SOUND_PRIME is not set

#
# HID support
#
CONFIG_HID=y
CONFIG_HID_BATTERY_STRENGTH=y
CONFIG_HIDRAW=y
CONFIG_UHID=y
# CONFIG_HID_GENERIC is not set

#
# Special HID drivers
#
CONFIG_HID_A4TECH=y
CONFIG_HID_ACRUX=y
CONFIG_HID_ACRUX_FF=y
CONFIG_HID_APPLE=y
# CONFIG_HID_APPLEIR is not set
CONFIG_HID_AUREAL=y
CONFIG_HID_BELKIN=y
CONFIG_HID_CHERRY=y
# CONFIG_HID_CHICONY is not set
CONFIG_HID_CYPRESS=y
# CONFIG_HID_DRAGONRISE is not set
CONFIG_HID_EMS_FF=y
CONFIG_HID_ELECOM=y
# CONFIG_HID_ELO is not set
# CONFIG_HID_EZKEY is not set
CONFIG_HID_HOLTEK=y
CONFIG_HOLTEK_FF=y
# CONFIG_HID_HUION is not set
# CONFIG_HID_KEYTOUCH is not set
CONFIG_HID_KYE=y
CONFIG_HID_UCLOGIC=y
CONFIG_HID_WALTOP=y
CONFIG_HID_GYRATION=y
CONFIG_HID_ICADE=y
CONFIG_HID_TWINHAN=y
# CONFIG_HID_KENSINGTON is not set
CONFIG_HID_LCPOWER=y
CONFIG_HID_LENOVO_TPKBD=y
CONFIG_HID_LOGITECH=y
CONFIG_HID_LOGITECH_DJ=y
CONFIG_LOGITECH_FF=y
# CONFIG_LOGIRUMBLEPAD2_FF is not set
CONFIG_LOGIG940_FF=y
# CONFIG_LOGIWHEELS_FF is not set
CONFIG_HID_MAGICMOUSE=y
CONFIG_HID_MICROSOFT=y
CONFIG_HID_MONTEREY=y
CONFIG_HID_MULTITOUCH=y
# CONFIG_HID_NTRIG is not set
CONFIG_HID_ORTEK=y
CONFIG_HID_PANTHERLORD=y
# CONFIG_PANTHERLORD_FF is not set
CONFIG_HID_PETALYNX=y
CONFIG_HID_PICOLCD=y
# CONFIG_HID_PICOLCD_FB is not set
# CONFIG_HID_PICOLCD_BACKLIGHT is not set
CONFIG_HID_PICOLCD_LCD=y
# CONFIG_HID_PICOLCD_LEDS is not set
CONFIG_HID_PRIMAX=y
CONFIG_HID_ROCCAT=y
CONFIG_HID_SAITEK=y
CONFIG_HID_SAMSUNG=y
CONFIG_HID_SONY=y
CONFIG_HID_SPEEDLINK=y
CONFIG_HID_STEELSERIES=y
# CONFIG_HID_SUNPLUS is not set
CONFIG_HID_GREENASIA=y
# CONFIG_GREENASIA_FF is not set
CONFIG_HID_SMARTJOYPLUS=y
# CONFIG_SMARTJOYPLUS_FF is not set
# CONFIG_HID_TIVO is not set
# CONFIG_HID_TOPSEED is not set
CONFIG_HID_THINGM=y
# CONFIG_HID_THRUSTMASTER is not set
CONFIG_HID_WACOM=y
# CONFIG_HID_WIIMOTE is not set
CONFIG_HID_ZEROPLUS=y
CONFIG_ZEROPLUS_FF=y
CONFIG_HID_ZYDACRON=y
CONFIG_HID_SENSOR_HUB=y

#
# USB HID support
#
CONFIG_USB_HID=y
CONFIG_HID_PID=y
# CONFIG_USB_HIDDEV is not set

#
# I2C HID support
#
# CONFIG_I2C_HID is not set
CONFIG_USB_SUPPORT=y
CONFIG_USB_COMMON=y
CONFIG_USB_ARCH_HAS_HCD=y
CONFIG_USB=y
# CONFIG_USB_DEBUG is not set
# CONFIG_USB_ANNOUNCE_NEW_DEVICES is not set

#
# Miscellaneous USB options
#
CONFIG_USB_DEFAULT_PERSIST=y
# CONFIG_USB_DYNAMIC_MINORS is not set
CONFIG_USB_OTG_WHITELIST=y
# CONFIG_USB_OTG_BLACKLIST_HUB is not set
# CONFIG_USB_MON is not set
CONFIG_USB_WUSB_CBAF=y
CONFIG_USB_WUSB_CBAF_DEBUG=y

#
# USB Host Controller Drivers
#
# CONFIG_USB_C67X00_HCD is not set
# CONFIG_USB_XHCI_HCD is not set
# CONFIG_USB_EHCI_HCD is not set
CONFIG_USB_OXU210HP_HCD=y
CONFIG_USB_ISP116X_HCD=y
CONFIG_USB_ISP1760_HCD=y
CONFIG_USB_ISP1362_HCD=y
# CONFIG_USB_FUSBH200_HCD is not set
# CONFIG_USB_OHCI_HCD is not set
CONFIG_USB_UHCI_HCD=y
# CONFIG_USB_SL811_HCD is not set
CONFIG_USB_R8A66597_HCD=y
CONFIG_USB_HCD_SSB=y
CONFIG_USB_MUSB_HDRC=y
CONFIG_USB_MUSB_HOST=y
# CONFIG_USB_MUSB_GADGET is not set
# CONFIG_USB_MUSB_DUAL_ROLE is not set
CONFIG_USB_MUSB_TUSB6010=y
# CONFIG_USB_MUSB_DSPS is not set
# CONFIG_USB_MUSB_UX500 is not set
CONFIG_MUSB_PIO_ONLY=y
# CONFIG_USB_RENESAS_USBHS is not set

#
# USB Device Class drivers
#
CONFIG_USB_ACM=y
CONFIG_USB_PRINTER=y
CONFIG_USB_WDM=y
CONFIG_USB_TMC=y

#
# NOTE: USB_STORAGE depends on SCSI but BLK_DEV_SD may
#

#
# also be needed; see USB_STORAGE Help for more info
#
CONFIG_USB_STORAGE=y
CONFIG_USB_STORAGE_DEBUG=y
CONFIG_USB_STORAGE_REALTEK=y
CONFIG_USB_STORAGE_DATAFAB=y
CONFIG_USB_STORAGE_FREECOM=y
CONFIG_USB_STORAGE_ISD200=y
CONFIG_USB_STORAGE_USBAT=y
CONFIG_USB_STORAGE_SDDR09=y
CONFIG_USB_STORAGE_SDDR55=y
# CONFIG_USB_STORAGE_JUMPSHOT is not set
CONFIG_USB_STORAGE_ALAUDA=y
# CONFIG_USB_STORAGE_ONETOUCH is not set
CONFIG_USB_STORAGE_KARMA=y
# CONFIG_USB_STORAGE_CYPRESS_ATACB is not set
# CONFIG_USB_STORAGE_ENE_UB6250 is not set

#
# USB Imaging devices
#
CONFIG_USB_MDC800=y
CONFIG_USB_MICROTEK=y
CONFIG_USB_DWC3=y
# CONFIG_USB_DWC3_HOST is not set
CONFIG_USB_DWC3_GADGET=y
# CONFIG_USB_DWC3_DUAL_ROLE is not set
# CONFIG_USB_DWC3_DEBUG is not set
CONFIG_USB_CHIPIDEA=y
CONFIG_USB_CHIPIDEA_UDC=y
CONFIG_USB_CHIPIDEA_DEBUG=y

#
# USB port drivers
#
CONFIG_USB_SERIAL=y
# CONFIG_USB_SERIAL_CONSOLE is not set
# CONFIG_USB_SERIAL_GENERIC is not set
# CONFIG_USB_SERIAL_AIRCABLE is not set
# CONFIG_USB_SERIAL_ARK3116 is not set
CONFIG_USB_SERIAL_BELKIN=y
CONFIG_USB_SERIAL_CH341=y
CONFIG_USB_SERIAL_WHITEHEAT=y
CONFIG_USB_SERIAL_DIGI_ACCELEPORT=y
# CONFIG_USB_SERIAL_CP210X is not set
CONFIG_USB_SERIAL_CYPRESS_M8=y
CONFIG_USB_SERIAL_EMPEG=y
# CONFIG_USB_SERIAL_FTDI_SIO is not set
CONFIG_USB_SERIAL_FUNSOFT=y
# CONFIG_USB_SERIAL_VISOR is not set
# CONFIG_USB_SERIAL_IPAQ is not set
CONFIG_USB_SERIAL_IR=y
CONFIG_USB_SERIAL_EDGEPORT=y
# CONFIG_USB_SERIAL_EDGEPORT_TI is not set
CONFIG_USB_SERIAL_F81232=y
# CONFIG_USB_SERIAL_GARMIN is not set
# CONFIG_USB_SERIAL_IPW is not set
# CONFIG_USB_SERIAL_IUU is not set
# CONFIG_USB_SERIAL_KEYSPAN_PDA is not set
CONFIG_USB_SERIAL_KEYSPAN=y
# CONFIG_USB_SERIAL_KEYSPAN_MPR is not set
CONFIG_USB_SERIAL_KEYSPAN_USA28=y
# CONFIG_USB_SERIAL_KEYSPAN_USA28X is not set
CONFIG_USB_SERIAL_KEYSPAN_USA28XA=y
# CONFIG_USB_SERIAL_KEYSPAN_USA28XB is not set
CONFIG_USB_SERIAL_KEYSPAN_USA19=y
# CONFIG_USB_SERIAL_KEYSPAN_USA18X is not set
# CONFIG_USB_SERIAL_KEYSPAN_USA19W is not set
CONFIG_USB_SERIAL_KEYSPAN_USA19QW=y
# CONFIG_USB_SERIAL_KEYSPAN_USA19QI is not set
CONFIG_USB_SERIAL_KEYSPAN_USA49W=y
CONFIG_USB_SERIAL_KEYSPAN_USA49WLC=y
CONFIG_USB_SERIAL_KLSI=y
CONFIG_USB_SERIAL_KOBIL_SCT=y
CONFIG_USB_SERIAL_MCT_U232=y
CONFIG_USB_SERIAL_METRO=y
CONFIG_USB_SERIAL_MOS7720=y
CONFIG_USB_SERIAL_MOS7840=y
CONFIG_USB_SERIAL_MOTOROLA=y
CONFIG_USB_SERIAL_NAVMAN=y
CONFIG_USB_SERIAL_PL2303=y
# CONFIG_USB_SERIAL_OTI6858 is not set
# CONFIG_USB_SERIAL_QCAUX is not set
CONFIG_USB_SERIAL_QUALCOMM=y
# CONFIG_USB_SERIAL_SPCP8X5 is not set
CONFIG_USB_SERIAL_HP4X=y
CONFIG_USB_SERIAL_SAFE=y
CONFIG_USB_SERIAL_SAFE_PADDED=y
# CONFIG_USB_SERIAL_SIEMENS_MPI is not set
# CONFIG_USB_SERIAL_SIERRAWIRELESS is not set
CONFIG_USB_SERIAL_SYMBOL=y
CONFIG_USB_SERIAL_TI=y
CONFIG_USB_SERIAL_CYBERJACK=y
# CONFIG_USB_SERIAL_XIRCOM is not set
CONFIG_USB_SERIAL_WWAN=y
# CONFIG_USB_SERIAL_OPTION is not set
# CONFIG_USB_SERIAL_OMNINET is not set
CONFIG_USB_SERIAL_OPTICON=y
# CONFIG_USB_SERIAL_VIVOPAY_SERIAL is not set
CONFIG_USB_SERIAL_XSENS_MT=y
# CONFIG_USB_SERIAL_ZIO is not set
# CONFIG_USB_SERIAL_WISHBONE is not set
CONFIG_USB_SERIAL_ZTE=y
CONFIG_USB_SERIAL_SSU100=y
CONFIG_USB_SERIAL_QT2=y
# CONFIG_USB_SERIAL_FLASHLOADER is not set
CONFIG_USB_SERIAL_DEBUG=y

#
# USB Miscellaneous drivers
#
CONFIG_USB_EMI62=y
# CONFIG_USB_EMI26 is not set
CONFIG_USB_ADUTUX=y
CONFIG_USB_SEVSEG=y
CONFIG_USB_RIO500=y
CONFIG_USB_LEGOTOWER=y
CONFIG_USB_LCD=y
CONFIG_USB_LED=y
CONFIG_USB_CYPRESS_CY7C63=y
CONFIG_USB_CYTHERM=y
CONFIG_USB_IDMOUSE=y
# CONFIG_USB_FTDI_ELAN is not set
CONFIG_USB_APPLEDISPLAY=y
# CONFIG_USB_SISUSBVGA is not set
# CONFIG_USB_LD is not set
CONFIG_USB_TRANCEVIBRATOR=y
CONFIG_USB_IOWARRIOR=y
CONFIG_USB_TEST=y
# CONFIG_USB_ISIGHTFW is not set
# CONFIG_USB_YUREX is not set
CONFIG_USB_EZUSB_FX2=y
CONFIG_USB_HSIC_USB3503=y
CONFIG_USB_ATM=y
CONFIG_USB_SPEEDTOUCH=y
# CONFIG_USB_CXACRU is not set
CONFIG_USB_UEAGLEATM=y
CONFIG_USB_XUSBATM=y
# CONFIG_USB_PHY is not set
CONFIG_USB_GADGET=y
# CONFIG_USB_GADGET_DEBUG is not set
# CONFIG_USB_GADGET_DEBUG_FS is not set
CONFIG_USB_GADGET_VBUS_DRAW=2
CONFIG_USB_GADGET_STORAGE_NUM_BUFFERS=2

#
# USB Peripheral Controller
#
CONFIG_USB_FOTG210_UDC=y
# CONFIG_USB_R8A66597 is not set
CONFIG_USB_PXA27X=y
CONFIG_USB_MV_UDC=y
CONFIG_USB_MV_U3D=y
CONFIG_USB_M66592=y
CONFIG_USB_AMD5536UDC=y
CONFIG_USB_NET2272=y
CONFIG_USB_NET2272_DMA=y
CONFIG_USB_NET2280=y
CONFIG_USB_GOKU=y
# CONFIG_USB_EG20T is not set
CONFIG_USB_DUMMY_HCD=y
CONFIG_USB_LIBCOMPOSITE=y
CONFIG_USB_F_ACM=y
CONFIG_USB_U_SERIAL=y
CONFIG_USB_U_ETHER=y
CONFIG_USB_F_ECM=y
# CONFIG_USB_CONFIGFS is not set
# CONFIG_USB_ZERO is not set
# CONFIG_USB_ETH is not set
# CONFIG_USB_G_NCM is not set
# CONFIG_USB_GADGETFS is not set
# CONFIG_USB_FUNCTIONFS is not set
# CONFIG_USB_MASS_STORAGE is not set
# CONFIG_USB_GADGET_TARGET is not set
# CONFIG_USB_G_SERIAL is not set
# CONFIG_USB_G_PRINTER is not set
CONFIG_USB_CDC_COMPOSITE=y
# CONFIG_USB_G_NOKIA is not set
# CONFIG_USB_G_ACM_MS is not set
# CONFIG_USB_G_MULTI is not set
# CONFIG_USB_G_HID is not set
# CONFIG_USB_G_DBGP is not set
# CONFIG_UWB is not set
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
# CONFIG_MMC_TEST is not set

#
# MMC/SD/SDIO Host Controller Drivers
#
CONFIG_MMC_SDHCI=y
CONFIG_MMC_SDHCI_PCI=y
# CONFIG_MMC_RICOH_MMC is not set
# CONFIG_MMC_SDHCI_ACPI is not set
# CONFIG_MMC_SDHCI_PLTFM is not set
CONFIG_MMC_WBSD=y
CONFIG_MMC_TIFM_SD=y
# CONFIG_MMC_SPI is not set
CONFIG_MMC_SDRICOH_CS=y
CONFIG_MMC_CB710=y
CONFIG_MMC_VIA_SDMMC=y
# CONFIG_MMC_VUB300 is not set
CONFIG_MMC_USHC=y
# CONFIG_MEMSTICK is not set
CONFIG_NEW_LEDS=y
CONFIG_LEDS_CLASS=y

#
# LED drivers
#
# CONFIG_LEDS_88PM860X is not set
CONFIG_LEDS_LM3530=y
CONFIG_LEDS_LM3533=y
# CONFIG_LEDS_LM3642 is not set
# CONFIG_LEDS_PCA9532 is not set
CONFIG_LEDS_GPIO=y
CONFIG_LEDS_LP3944=y
CONFIG_LEDS_LP55XX_COMMON=y
# CONFIG_LEDS_LP5521 is not set
CONFIG_LEDS_LP5523=y
CONFIG_LEDS_LP5562=y
# CONFIG_LEDS_LP8501 is not set
# CONFIG_LEDS_LP8788 is not set
CONFIG_LEDS_CLEVO_MAIL=y
CONFIG_LEDS_PCA955X=y
CONFIG_LEDS_PCA9633=y
CONFIG_LEDS_DA903X=y
# CONFIG_LEDS_DA9052 is not set
# CONFIG_LEDS_DAC124S085 is not set
CONFIG_LEDS_PWM=y
CONFIG_LEDS_REGULATOR=y
# CONFIG_LEDS_BD2802 is not set
CONFIG_LEDS_INTEL_SS4200=y
# CONFIG_LEDS_LT3593 is not set
# CONFIG_LEDS_DELL_NETBOOKS is not set
CONFIG_LEDS_MC13783=y
# CONFIG_LEDS_TCA6507 is not set
CONFIG_LEDS_MAX8997=y
CONFIG_LEDS_LM355x=y
# CONFIG_LEDS_OT200 is not set
CONFIG_LEDS_BLINKM=y

#
# LED Triggers
#
CONFIG_LEDS_TRIGGERS=y
# CONFIG_LEDS_TRIGGER_TIMER is not set
CONFIG_LEDS_TRIGGER_ONESHOT=y
CONFIG_LEDS_TRIGGER_HEARTBEAT=y
CONFIG_LEDS_TRIGGER_BACKLIGHT=y
CONFIG_LEDS_TRIGGER_CPU=y
CONFIG_LEDS_TRIGGER_GPIO=y
# CONFIG_LEDS_TRIGGER_DEFAULT_ON is not set

#
# iptables trigger is under Netfilter config (LED target)
#
CONFIG_LEDS_TRIGGER_TRANSIENT=y
# CONFIG_LEDS_TRIGGER_CAMERA is not set
CONFIG_ACCESSIBILITY=y
# CONFIG_INFINIBAND is not set
CONFIG_EDAC=y
# CONFIG_EDAC_LEGACY_SYSFS is not set
CONFIG_EDAC_DEBUG=y
# CONFIG_EDAC_DECODE_MCE is not set
# CONFIG_EDAC_MM_EDAC is not set
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
CONFIG_DW_DMAC=y
CONFIG_DW_DMAC_PCI=y
CONFIG_TIMB_DMA=y
CONFIG_PCH_DMA=y
CONFIG_DMA_ENGINE=y
CONFIG_DMA_ACPI=y

#
# DMA Clients
#
CONFIG_NET_DMA=y
# CONFIG_ASYNC_TX_DMA is not set
CONFIG_DMATEST=y
CONFIG_AUXDISPLAY=y
CONFIG_UIO=y
CONFIG_UIO_CIF=y
# CONFIG_UIO_PDRV is not set
# CONFIG_UIO_PDRV_GENIRQ is not set
CONFIG_UIO_DMEM_GENIRQ=y
CONFIG_UIO_AEC=y
CONFIG_UIO_SERCOS3=y
# CONFIG_UIO_PCI_GENERIC is not set
CONFIG_UIO_NETX=y
# CONFIG_VIRT_DRIVERS is not set
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
# CONFIG_STAGING is not set
CONFIG_X86_PLATFORM_DEVICES=y
CONFIG_ACER_WMI=y
CONFIG_ACERHDF=y
# CONFIG_ASUS_LAPTOP is not set
# CONFIG_CHROMEOS_LAPTOP is not set
CONFIG_DELL_LAPTOP=y
# CONFIG_DELL_WMI is not set
# CONFIG_DELL_WMI_AIO is not set
# CONFIG_FUJITSU_LAPTOP is not set
CONFIG_FUJITSU_TABLET=y
# CONFIG_AMILO_RFKILL is not set
# CONFIG_HP_ACCEL is not set
# CONFIG_HP_WMI is not set
CONFIG_MSI_LAPTOP=y
CONFIG_PANASONIC_LAPTOP=y
CONFIG_COMPAL_LAPTOP=y
CONFIG_SONY_LAPTOP=y
# CONFIG_SONYPI_COMPAT is not set
# CONFIG_IDEAPAD_LAPTOP is not set
# CONFIG_THINKPAD_ACPI is not set
CONFIG_SENSORS_HDAPS=y
CONFIG_EEEPC_LAPTOP=y
CONFIG_ASUS_WMI=y
# CONFIG_ASUS_NB_WMI is not set
CONFIG_EEEPC_WMI=y
CONFIG_ACPI_WMI=y
CONFIG_MSI_WMI=y
CONFIG_TOPSTAR_LAPTOP=y
# CONFIG_ACPI_TOSHIBA is not set
CONFIG_TOSHIBA_BT_RFKILL=y
CONFIG_ACPI_CMPC=y
# CONFIG_INTEL_IPS is not set
CONFIG_IBM_RTL=y
# CONFIG_XO15_EBOOK is not set
CONFIG_SAMSUNG_LAPTOP=y
CONFIG_MXM_WMI=y
CONFIG_INTEL_OAKTRAIL=y
CONFIG_SAMSUNG_Q10=y
CONFIG_APPLE_GMUX=y
# CONFIG_INTEL_RST is not set
CONFIG_INTEL_SMARTCONNECT=y
CONFIG_PVPANIC=y

#
# Hardware Spinlock drivers
#
CONFIG_CLKEVT_I8253=y
CONFIG_CLKBLD_I8253=y
CONFIG_MAILBOX=y
# CONFIG_IOMMU_SUPPORT is not set

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
CONFIG_DEVFREQ_GOV_SIMPLE_ONDEMAND=y
CONFIG_DEVFREQ_GOV_PERFORMANCE=y
# CONFIG_DEVFREQ_GOV_POWERSAVE is not set
# CONFIG_DEVFREQ_GOV_USERSPACE is not set

#
# DEVFREQ Drivers
#
CONFIG_EXTCON=y

#
# Extcon Device Drivers
#
# CONFIG_EXTCON_GPIO is not set
CONFIG_EXTCON_MAX8997=y
# CONFIG_MEMORY is not set
# CONFIG_IIO is not set
# CONFIG_NTB is not set
CONFIG_VME_BUS=y

#
# VME Bridge Drivers
#
CONFIG_VME_CA91CX42=y
CONFIG_VME_TSI148=y

#
# VME Board Drivers
#
CONFIG_VMIVME_7805=y

#
# VME Device Drivers
#
CONFIG_PWM=y
CONFIG_PWM_SYSFS=y
# CONFIG_PWM_TWL is not set
CONFIG_PWM_TWL_LED=y
CONFIG_IPACK_BUS=y
# CONFIG_BOARD_TPCI200 is not set
# CONFIG_SERIAL_IPOCTAL is not set
# CONFIG_RESET_CONTROLLER is not set
CONFIG_FMC=y
CONFIG_FMC_FAKEDEV=y
CONFIG_FMC_TRIVIAL=y
CONFIG_FMC_WRITE_EEPROM=y
CONFIG_FMC_CHARDEV=y

#
# Firmware Drivers
#
CONFIG_EDD=y
# CONFIG_EDD_OFF is not set
# CONFIG_FIRMWARE_MEMMAP is not set
# CONFIG_DELL_RBU is not set
CONFIG_DCDBAS=y
# CONFIG_DMIID is not set
# CONFIG_DMI_SYSFS is not set
# CONFIG_ISCSI_IBFT_FIND is not set
CONFIG_GOOGLE_FIRMWARE=y

#
# Google Firmware Drivers
#
# CONFIG_GOOGLE_SMI is not set
CONFIG_GOOGLE_MEMCONSOLE=y

#
# EFI (Extensible Firmware Interface) Support
#
# CONFIG_EFI_VARS is not set

#
# File systems
#
CONFIG_DCACHE_WORD_ACCESS=y
# CONFIG_EXT2_FS is not set
CONFIG_EXT3_FS=y
# CONFIG_EXT3_DEFAULTS_TO_ORDERED is not set
CONFIG_EXT3_FS_XATTR=y
CONFIG_EXT3_FS_POSIX_ACL=y
CONFIG_EXT3_FS_SECURITY=y
CONFIG_EXT4_FS=y
# CONFIG_EXT4_USE_FOR_EXT23 is not set
CONFIG_EXT4_FS_POSIX_ACL=y
CONFIG_EXT4_FS_SECURITY=y
# CONFIG_EXT4_DEBUG is not set
CONFIG_JBD=y
# CONFIG_JBD_DEBUG is not set
CONFIG_JBD2=y
CONFIG_JBD2_DEBUG=y
CONFIG_FS_MBCACHE=y
# CONFIG_REISERFS_FS is not set
CONFIG_JFS_FS=y
# CONFIG_JFS_POSIX_ACL is not set
CONFIG_JFS_SECURITY=y
CONFIG_JFS_DEBUG=y
# CONFIG_JFS_STATISTICS is not set
CONFIG_XFS_FS=y
CONFIG_XFS_QUOTA=y
CONFIG_XFS_POSIX_ACL=y
# CONFIG_XFS_RT is not set
CONFIG_XFS_DEBUG=y
# CONFIG_GFS2_FS is not set
CONFIG_OCFS2_FS=y
# CONFIG_OCFS2_FS_O2CB is not set
CONFIG_OCFS2_FS_USERSPACE_CLUSTER=y
# CONFIG_OCFS2_FS_STATS is not set
CONFIG_OCFS2_DEBUG_MASKLOG=y
CONFIG_OCFS2_DEBUG_FS=y
CONFIG_BTRFS_FS=y
CONFIG_BTRFS_FS_POSIX_ACL=y
# CONFIG_BTRFS_FS_CHECK_INTEGRITY is not set
# CONFIG_BTRFS_FS_RUN_SANITY_TESTS is not set
# CONFIG_BTRFS_DEBUG is not set
CONFIG_NILFS2_FS=y
CONFIG_FS_POSIX_ACL=y
CONFIG_EXPORTFS=y
CONFIG_FILE_LOCKING=y
CONFIG_FSNOTIFY=y
CONFIG_DNOTIFY=y
CONFIG_INOTIFY_USER=y
CONFIG_FANOTIFY=y
CONFIG_QUOTA=y
CONFIG_QUOTA_NETLINK_INTERFACE=y
CONFIG_PRINT_QUOTA_WARNING=y
# CONFIG_QUOTA_DEBUG is not set
CONFIG_QUOTA_TREE=y
CONFIG_QFMT_V1=y
CONFIG_QFMT_V2=y
CONFIG_QUOTACTL=y
CONFIG_AUTOFS4_FS=y
# CONFIG_FUSE_FS is not set
CONFIG_GENERIC_ACL=y

#
# Caches
#
CONFIG_FSCACHE=y
CONFIG_FSCACHE_DEBUG=y
# CONFIG_CACHEFILES is not set

#
# CD-ROM/DVD Filesystems
#
CONFIG_ISO9660_FS=y
CONFIG_JOLIET=y
CONFIG_ZISOFS=y
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
# CONFIG_NTFS_DEBUG is not set
CONFIG_NTFS_RW=y

#
# Pseudo filesystems
#
# CONFIG_PROC_FS is not set
CONFIG_SYSFS=y
CONFIG_TMPFS=y
CONFIG_TMPFS_POSIX_ACL=y
CONFIG_TMPFS_XATTR=y
CONFIG_HUGETLBFS=y
CONFIG_HUGETLB_PAGE=y
CONFIG_CONFIGFS_FS=y
CONFIG_MISC_FILESYSTEMS=y
CONFIG_ADFS_FS=y
CONFIG_ADFS_FS_RW=y
CONFIG_AFFS_FS=y
CONFIG_ECRYPT_FS=y
# CONFIG_ECRYPT_FS_MESSAGING is not set
# CONFIG_HFS_FS is not set
CONFIG_HFSPLUS_FS=y
# CONFIG_BEFS_FS is not set
# CONFIG_BFS_FS is not set
CONFIG_EFS_FS=y
# CONFIG_LOGFS is not set
CONFIG_CRAMFS=y
# CONFIG_SQUASHFS is not set
# CONFIG_VXFS_FS is not set
CONFIG_MINIX_FS=y
CONFIG_OMFS_FS=y
CONFIG_HPFS_FS=y
CONFIG_QNX4FS_FS=y
CONFIG_QNX6FS_FS=y
CONFIG_QNX6FS_DEBUG=y
CONFIG_ROMFS_FS=y
CONFIG_ROMFS_BACKED_BY_BLOCK=y
CONFIG_ROMFS_ON_BLOCK=y
CONFIG_PSTORE=y
# CONFIG_PSTORE_CONSOLE is not set
# CONFIG_PSTORE_RAM is not set
CONFIG_SYSV_FS=y
CONFIG_UFS_FS=y
CONFIG_UFS_FS_WRITE=y
CONFIG_UFS_DEBUG=y
CONFIG_F2FS_FS=y
CONFIG_F2FS_STAT_FS=y
# CONFIG_F2FS_FS_XATTR is not set
CONFIG_EFIVAR_FS=y
# CONFIG_NETWORK_FILESYSTEMS is not set
CONFIG_NLS=y
CONFIG_NLS_DEFAULT="iso8859-1"
CONFIG_NLS_CODEPAGE_437=y
# CONFIG_NLS_CODEPAGE_737 is not set
CONFIG_NLS_CODEPAGE_775=y
CONFIG_NLS_CODEPAGE_850=y
# CONFIG_NLS_CODEPAGE_852 is not set
CONFIG_NLS_CODEPAGE_855=y
CONFIG_NLS_CODEPAGE_857=y
CONFIG_NLS_CODEPAGE_860=y
# CONFIG_NLS_CODEPAGE_861 is not set
# CONFIG_NLS_CODEPAGE_862 is not set
# CONFIG_NLS_CODEPAGE_863 is not set
CONFIG_NLS_CODEPAGE_864=y
CONFIG_NLS_CODEPAGE_865=y
CONFIG_NLS_CODEPAGE_866=y
CONFIG_NLS_CODEPAGE_869=y
CONFIG_NLS_CODEPAGE_936=y
CONFIG_NLS_CODEPAGE_950=y
CONFIG_NLS_CODEPAGE_932=y
# CONFIG_NLS_CODEPAGE_949 is not set
CONFIG_NLS_CODEPAGE_874=y
CONFIG_NLS_ISO8859_8=y
CONFIG_NLS_CODEPAGE_1250=y
CONFIG_NLS_CODEPAGE_1251=y
CONFIG_NLS_ASCII=y
# CONFIG_NLS_ISO8859_1 is not set
CONFIG_NLS_ISO8859_2=y
CONFIG_NLS_ISO8859_3=y
# CONFIG_NLS_ISO8859_4 is not set
CONFIG_NLS_ISO8859_5=y
CONFIG_NLS_ISO8859_6=y
CONFIG_NLS_ISO8859_7=y
CONFIG_NLS_ISO8859_9=y
# CONFIG_NLS_ISO8859_13 is not set
CONFIG_NLS_ISO8859_14=y
CONFIG_NLS_ISO8859_15=y
CONFIG_NLS_KOI8_R=y
CONFIG_NLS_KOI8_U=y
CONFIG_NLS_MAC_ROMAN=y
CONFIG_NLS_MAC_CELTIC=y
# CONFIG_NLS_MAC_CENTEURO is not set
CONFIG_NLS_MAC_CROATIAN=y
CONFIG_NLS_MAC_CYRILLIC=y
CONFIG_NLS_MAC_GAELIC=y
# CONFIG_NLS_MAC_GREEK is not set
CONFIG_NLS_MAC_ICELAND=y
CONFIG_NLS_MAC_INUIT=y
CONFIG_NLS_MAC_ROMANIAN=y
# CONFIG_NLS_MAC_TURKISH is not set
CONFIG_NLS_UTF8=y
CONFIG_DLM=y
CONFIG_DLM_DEBUG=y

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
# CONFIG_ENABLE_WARN_DEPRECATED is not set
CONFIG_ENABLE_MUST_CHECK=y
CONFIG_FRAME_WARN=2048
# CONFIG_STRIP_ASM_SYMS is not set
CONFIG_READABLE_ASM=y
# CONFIG_UNUSED_SYMBOLS is not set
CONFIG_DEBUG_FS=y
# CONFIG_HEADERS_CHECK is not set
# CONFIG_DEBUG_SECTION_MISMATCH is not set
CONFIG_ARCH_WANT_FRAME_POINTERS=y
CONFIG_FRAME_POINTER=y
CONFIG_DEBUG_FORCE_WEAK_PER_CPU=y
CONFIG_MAGIC_SYSRQ=y
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
CONFIG_DEBUG_STACK_USAGE=y
CONFIG_DEBUG_VM=y
# CONFIG_DEBUG_VM_RB is not set
# CONFIG_DEBUG_VIRTUAL is not set
CONFIG_DEBUG_MEMORY_INIT=y
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
# CONFIG_DEBUG_PREEMPT is not set

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
CONFIG_PROVE_LOCKING=y
CONFIG_LOCKDEP=y
# CONFIG_LOCK_STAT is not set
# CONFIG_DEBUG_LOCKDEP is not set
CONFIG_DEBUG_ATOMIC_SLEEP=y
# CONFIG_DEBUG_LOCKING_API_SELFTESTS is not set
CONFIG_TRACE_IRQFLAGS=y
CONFIG_STACKTRACE=y
# CONFIG_DEBUG_KOBJECT is not set
CONFIG_DEBUG_BUGVERBOSE=y
# CONFIG_DEBUG_WRITECOUNT is not set
CONFIG_DEBUG_LIST=y
# CONFIG_DEBUG_SG is not set
# CONFIG_DEBUG_NOTIFIERS is not set
# CONFIG_DEBUG_CREDENTIALS is not set

#
# RCU Debugging
#
# CONFIG_PROVE_RCU is not set
# CONFIG_PROVE_RCU_DELAY is not set
# CONFIG_SPARSE_RCU_POINTER is not set
# CONFIG_RCU_TORTURE_TEST is not set
CONFIG_RCU_CPU_STALL_TIMEOUT=21
CONFIG_RCU_CPU_STALL_VERBOSE=y
CONFIG_RCU_CPU_STALL_INFO=y
# CONFIG_RCU_TRACE is not set
# CONFIG_DEBUG_BLOCK_EXT_DEVT is not set
CONFIG_NOTIFIER_ERROR_INJECTION=y
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
CONFIG_HAVE_FENTRY=y
CONFIG_HAVE_C_RECORDMCOUNT=y
CONFIG_TRACING_SUPPORT=y
# CONFIG_FTRACE is not set

#
# Runtime Testing
#
# CONFIG_LKDTM is not set
# CONFIG_TEST_LIST_SORT is not set
# CONFIG_BACKTRACE_SELF_TEST is not set
# CONFIG_ATOMIC64_SELFTEST is not set
CONFIG_ASYNC_RAID6_TEST=y
CONFIG_TEST_STRING_HELPERS=y
CONFIG_TEST_KSTRTOX=y
# CONFIG_PROVIDE_OHCI1394_DMA_INIT is not set
CONFIG_DMA_API_DEBUG=y
# CONFIG_SAMPLES is not set
CONFIG_HAVE_ARCH_KGDB=y
# CONFIG_KGDB is not set
CONFIG_STRICT_DEVMEM=y
# CONFIG_X86_VERBOSE_BOOTUP is not set
CONFIG_EARLY_PRINTK=y
# CONFIG_EARLY_PRINTK_DBGP is not set
# CONFIG_X86_PTDUMP is not set
# CONFIG_DEBUG_RODATA is not set
CONFIG_DOUBLEFAULT=y
# CONFIG_DEBUG_TLBFLUSH is not set
# CONFIG_IOMMU_STRESS is not set
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
# CONFIG_DEBUG_BOOT_PARAMS is not set
# CONFIG_CPA_DEBUG is not set
CONFIG_OPTIMIZE_INLINING=y
# CONFIG_DEBUG_NMI_SELFTEST is not set
# CONFIG_X86_DEBUG_STATIC_CPU_HAS is not set

#
# Security options
#
CONFIG_KEYS=y
CONFIG_TRUSTED_KEYS=y
CONFIG_ENCRYPTED_KEYS=y
CONFIG_KEYS_DEBUG_PROC_KEYS=y
# CONFIG_SECURITY_DMESG_RESTRICT is not set
# CONFIG_SECURITY is not set
CONFIG_SECURITYFS=y
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
CONFIG_CRYPTO_ABLK_HELPER_X86=y
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
# CONFIG_CRYPTO_CTS is not set
CONFIG_CRYPTO_ECB=y
CONFIG_CRYPTO_LRW=y
CONFIG_CRYPTO_PCBC=y
CONFIG_CRYPTO_XTS=y

#
# Hash modes
#
# CONFIG_CRYPTO_CMAC is not set
CONFIG_CRYPTO_HMAC=y
CONFIG_CRYPTO_XCBC=y
CONFIG_CRYPTO_VMAC=y

#
# Digest
#
CONFIG_CRYPTO_CRC32C=y
CONFIG_CRYPTO_CRC32C_INTEL=y
# CONFIG_CRYPTO_CRC32 is not set
# CONFIG_CRYPTO_CRC32_PCLMUL is not set
CONFIG_CRYPTO_CRCT10DIF=y
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
# CONFIG_CRYPTO_SHA256_SSSE3 is not set
CONFIG_CRYPTO_SHA512_SSSE3=y
CONFIG_CRYPTO_SHA256=y
CONFIG_CRYPTO_SHA512=y
CONFIG_CRYPTO_TGR192=y
CONFIG_CRYPTO_WP512=y
CONFIG_CRYPTO_GHASH_CLMUL_NI_INTEL=y

#
# Ciphers
#
CONFIG_CRYPTO_AES=y
# CONFIG_CRYPTO_AES_X86_64 is not set
# CONFIG_CRYPTO_AES_NI_INTEL is not set
CONFIG_CRYPTO_ANUBIS=y
CONFIG_CRYPTO_ARC4=y
CONFIG_CRYPTO_BLOWFISH=y
CONFIG_CRYPTO_BLOWFISH_COMMON=y
# CONFIG_CRYPTO_BLOWFISH_X86_64 is not set
CONFIG_CRYPTO_CAMELLIA=y
CONFIG_CRYPTO_CAMELLIA_X86_64=y
CONFIG_CRYPTO_CAMELLIA_AESNI_AVX_X86_64=y
CONFIG_CRYPTO_CAMELLIA_AESNI_AVX2_X86_64=y
CONFIG_CRYPTO_CAST_COMMON=y
CONFIG_CRYPTO_CAST5=y
CONFIG_CRYPTO_CAST5_AVX_X86_64=y
CONFIG_CRYPTO_CAST6=y
# CONFIG_CRYPTO_CAST6_AVX_X86_64 is not set
CONFIG_CRYPTO_DES=y
CONFIG_CRYPTO_FCRYPT=y
CONFIG_CRYPTO_KHAZAD=y
# CONFIG_CRYPTO_SALSA20 is not set
CONFIG_CRYPTO_SALSA20_X86_64=y
# CONFIG_CRYPTO_SEED is not set
CONFIG_CRYPTO_SERPENT=y
CONFIG_CRYPTO_SERPENT_SSE2_X86_64=y
CONFIG_CRYPTO_SERPENT_AVX_X86_64=y
# CONFIG_CRYPTO_SERPENT_AVX2_X86_64 is not set
# CONFIG_CRYPTO_TEA is not set
CONFIG_CRYPTO_TWOFISH=y
CONFIG_CRYPTO_TWOFISH_COMMON=y
CONFIG_CRYPTO_TWOFISH_X86_64=y
CONFIG_CRYPTO_TWOFISH_X86_64_3WAY=y
CONFIG_CRYPTO_TWOFISH_AVX_X86_64=y

#
# Compression
#
CONFIG_CRYPTO_DEFLATE=y
CONFIG_CRYPTO_ZLIB=y
# CONFIG_CRYPTO_LZO is not set
CONFIG_CRYPTO_LZ4=y
CONFIG_CRYPTO_LZ4HC=y

#
# Random Number Generation
#
CONFIG_CRYPTO_ANSI_CPRNG=y
CONFIG_CRYPTO_USER_API=y
# CONFIG_CRYPTO_USER_API_HASH is not set
CONFIG_CRYPTO_USER_API_SKCIPHER=y
CONFIG_CRYPTO_HW=y
CONFIG_CRYPTO_DEV_PADLOCK=y
CONFIG_CRYPTO_DEV_PADLOCK_AES=y
CONFIG_CRYPTO_DEV_PADLOCK_SHA=y
# CONFIG_ASYMMETRIC_KEY_TYPE is not set
CONFIG_HAVE_KVM=y
# CONFIG_VIRTUALIZATION is not set
# CONFIG_BINARY_PRINTF is not set

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
CONFIG_CRC_CCITT=y
CONFIG_CRC16=y
# CONFIG_CRC_T10DIF is not set
CONFIG_CRC_ITU_T=y
CONFIG_CRC32=y
# CONFIG_CRC32_SELFTEST is not set
# CONFIG_CRC32_SLICEBY8 is not set
# CONFIG_CRC32_SLICEBY4 is not set
CONFIG_CRC32_SARWATE=y
# CONFIG_CRC32_BIT is not set
CONFIG_CRC7=y
CONFIG_LIBCRC32C=y
CONFIG_CRC8=y
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
CONFIG_DECOMPRESS_LZMA=y
CONFIG_GENERIC_ALLOCATOR=y
CONFIG_TEXTSEARCH=y
CONFIG_TEXTSEARCH_KMP=y
CONFIG_TEXTSEARCH_BM=y
CONFIG_TEXTSEARCH_FSM=y
CONFIG_HAS_IOMEM=y
CONFIG_HAS_IOPORT=y
CONFIG_HAS_DMA=y
CONFIG_CHECK_SIGNATURE=y
CONFIG_DQL=y
CONFIG_NLATTR=y
CONFIG_ARCH_HAS_ATOMIC64_DEC_IF_POSITIVE=y
CONFIG_AVERAGE=y
CONFIG_CORDIC=y
CONFIG_DDR=y
CONFIG_UCS2_STRING=y

--ZoaI/ZTpAVc4A5k6--
