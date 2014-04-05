Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752866AbaDENjK (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Apr 2014 09:39:10 -0400
Received: from mga01.intel.com ([192.55.52.88]:25359 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752720AbaDENjD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Apr 2014 09:39:03 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,800,1389772800"; 
   d="log'?scan'208";a="507559162"
Date: Sat, 5 Apr 2014 21:38:56 +0800
From: Fengguang Wu <fengguang.wu@intel.com>
To: Greg Price <price@MIT.EDU>
Cc: "Theodore Ts'o" <tytso@MIT.EDU>, linux-kernel@vger.kernel.org,
        Jet Chen <jet.chen@intel.com>
Subject: [random] BUG: spinlock trylock failure on UP on CPU#0, swapper/1
Message-ID: <20140405133856.GA12354@localhost>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="ZPt4rx8FFjLCG7dd"
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--ZPt4rx8FFjLCG7dd
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Greetings,

I got the below dmesg and the first bad commit is

git://git.kernel.org/pub/scm/linux/kernel/git/next/linux-next.git master

commit 11e9ee988e8f951e4dbc765832fdf6f08c2c8b54
Author:     Greg Price <price@MIT.EDU>
AuthorDate: Thu Dec 5 19:32:19 2013 -0500
Commit:     Theodore Ts'o <tytso@mit.edu>
CommitDate: Wed Mar 5 21:28:10 2014 -0500

    random: simplify accounting code
   =20
    With this we handle "reserved" in just one place.  As a bonus the
    code becomes less nested, and the "wakeup_write" flag variable
    becomes unnecessary.  The variable "flags" was already unused.
   =20
    This code behaves identically to the previous version except in
    two pathological cases that don't occur.  If the argument "nbytes"
    is already less than "min", then we didn't previously enforce
    "min".  If r->limit is false while "reserved" is nonzero, then we
    previously applied "reserved" in checking whether we had enough
    bits, even though we don't apply it to actually limit how many we
    take.  The callers of account() never exercise either of these cases.
   =20
    Before the previous commit, it was possible for "nbytes" to be less
    than "min" if userspace chose a pathological configuration, but no
    longer.
   =20
    Cc: Jiri Kosina <jkosina@suse.cz>
    Cc: "H. Peter Anvin" <hpa@zytor.com>
    Signed-off-by: Greg Price <price@mit.edu>
    Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>

+------------------------------------------------+------------+------------=
+---------------+
|                                                | bdd80011da | 11e9ee988e =
| next-20140403 |
+------------------------------------------------+------------+------------=
+---------------+
| boot_successes                                 | 510        | 136        =
| 16            |
| boot_failures                                  | 106        | 46         =
| 7             |
| BUG:kernel_boot_hang                           | 106        | 20         =
| 2             |
| BUG:spinlock_trylock_failure_on_UP_on_CPU      | 0          | 25         =
| 5             |
| backtrace:prandom_reseed                       | 0          | 16         =
| 3             |
| backtrace:kernel_init_freeable                 | 0          | 16         =
| 2             |
| BUG:soft_lockup-CPU_stuck_for_s                | 0          | 1          =
|               |
| EIP_is_at_native_safe_halt                     | 0          | 1          =
|               |
| Kernel_panic-not_syncing:softlockup:hung_tasks | 0          | 1          =
|               |
| backtrace:cpu_startup_entry                    | 0          | 1          =
|               |
+------------------------------------------------+------------+------------=
+---------------+

[  583.725561] raid6test: test_disks(62, 63): faila=3D 62(P)  failb=3D 63(Q=
)  OK
[  583.912461] raid6test:=20
[  584.110739] raid6test: complete (2429 tests, 0 failures)
[  584.304933] BUG: spinlock trylock failure on UP on CPU#0, swapper/1
[  584.314418]  lock: lock.14477+0x0/0x40, .magic: dead4ead, .owner: swappe=
r/1, .owner_cpu: 0
[  584.314418] CPU: 0 PID: 1 Comm: swapper Not tainted 3.13.0-00009-g11e9ee=
9 #1
[  584.314418] Hardware name: Bochs Bochs, BIOS Bochs 01/01/2011
[  584.314418]  d0058000 d0058000 d0057d1c c181ac11 d0057d44 c1816b15 c1a51=
108 c1cc3080
[  584.314418]  dead4ead d00582b0 00000001 00000000 c1cc3080 c1a4c4e5 d0057=
d54 c1816b37
[  584.314418]  00000000 c1cc3080 d0057d60 c1061c4c c1cc3090 d0057d84 c1826=
9e2 00000000
[  584.314418] Call Trace:
[  584.314418]  [<c181ac11>] dump_stack+0x16/0x18
[  584.314418]  [<c1816b15>] spin_dump+0x90/0x97
[  584.314418]  [<c1816b37>] spin_bug+0x1b/0x1f
[  584.314418]  [<c1061c4c>] do_raw_spin_trylock+0x3c/0x50
[  584.314418]  [<c18269e2>] _raw_spin_lock_irqsave+0x52/0x80
[  584.314418]  [<c1261564>] ? __prandom_reseed+0x14/0xa0
[  584.314418]  [<c1261564>] __prandom_reseed+0x14/0xa0
[  584.314418]  [<c126166d>] prandom_reseed_late+0xd/0x10
[  584.314418]  [<c139918e>] credit_entropy_bits+0x20e/0x230
[  584.314418]  [<c13999ab>] _xfer_secondary_pool+0x7b/0x90

Elapsed time: 580
qemu-system-x86_64 -cpu kvm64 -enable-kvm -kernel /kernel/i386-randconfig-f=
b0-04031419/11e9ee988e8f951e4dbc765832fdf6f08c2c8b54/vmlinuz-3.13.0-00009-g=
11e9ee9 -append 'hung_task_panic=3D1 earlyprintk=3DttyS0,115200 debug apic=
=3Ddebug sysrq_always_enabled rcupdate.rcu_cpu_stall_timeout=3D100 panic=3D=
10 softlockup_panic=3D1 nmi_watchdog=3Dpanic  prompt_ramdisk=3D0 console=3D=
ttyS0,115200 console=3Dtty0 vga=3Dnormal  root=3D/dev/ram0 rw link=3D/kerne=
l-tests/run-queue/kvm/i386-randconfig-fb0-04031419/next:master:11e9ee988e8f=
951e4dbc765832fdf6f08c2c8b54:bisect-drm/.vmlinuz-11e9ee988e8f951e4dbc765832=
fdf6f08c2c8b54-20140405081535-145-loslunas branch=3Dnext/master BOOT_IMAGE=
=3D/kernel/i386-randconfig-fb0-04031419/11e9ee988e8f951e4dbc765832fdf6f08c2=
c8b54/vmlinuz-3.13.0-00009-g11e9ee9 drbd.minor_count=3D8'  -initrd /kernel-=
tests/initrd/quantal-core-i386.cgz -m 320 -smp 2 -net nic,vlan=3D1,model=3D=
e1000 -net user,vlan=3D1,hostfwd=3Dtcp::9668-:22 -boot order=3Dnc -no-reboo=
t -watchdog i6300esb -rtc base=3Dlocaltime -pidfile /dev/shm/kboot/pid-quan=
tal-loslunas-12 -serial file:/dev/shm/kboot/serial-quantal-loslunas-12 -dae=
monize -display none -monitor null=20

git bisect start 79b1d1f5860545973461d0dcb1f0e8d9c32dbdbe v3.14 --
git bisect good 66a79c5033d7e31b2e63c528000ba381df480d45  # 14:10     70+  =
    0  Merge remote-tracking branch 'renesas/next'
git bisect good 48002d979a86f9807826cac79fb4a0c0774af5ba  # 18:55     70+  =
   12  Merge remote-tracking branch 'l2-mtd/master'
git bisect good f1dacec12594c327cc25fe2c2785bae8b086eccb  # 21:57     70+  =
    9  Merge remote-tracking branch 'trivial/for-next'
git bisect good bd87b48bb4b6bad88f1e88d96a1db7c280ea1393  # 23:38     70+  =
    5  Merge remote-tracking branch 'leds/for-next'
git bisect good 0783c1fd1eb05312ff948d2f04b3236661300664  # 00:44     70+  =
   15  Merge remote-tracking branch 'pwm/for-next'
git bisect  bad 578477075e8932bb7fe117e6ad470c3c3cb580c7  # 01:21      4-  =
    5  Merge remote-tracking branch 'random/dev'
git bisect good 1f5db0cb975967a8b904050d7eeac3e05bc89fb3  # 04:05     70+  =
    1  Merge remote-tracking branch 'ktest/for-next'
git bisect good dd6120ce8d3b3606f40f00f3be6f0b2c04a8a6a9  # 05:20     70+  =
   12  Merge remote-tracking branch 'clk/clk-next'
git bisect good bdd80011daa20f828023f511c971a7ba067e6d1b  # 05:47     70+  =
   15  random: tighten bound on random_read_wakeup_thresh
git bisect  bad 5affd0650baee6b535ccbf625bd5814bef49c7dc  # 06:21     65-  =
    5  random: use the architectural HWRNG for the SHA's IV in extract_buf()
git bisect  bad 243f2627816bb018fa945a460bc872a51a3b4fb9  # 07:25     20-  =
    7  random: entropy_bytes is actually bits
git bisect  bad 11e9ee988e8f951e4dbc765832fdf6f08c2c8b54  # 08:25     12-  =
    7  random: simplify accounting code
# first bad commit: [11e9ee988e8f951e4dbc765832fdf6f08c2c8b54] random: simp=
lify accounting code
git bisect good bdd80011daa20f828023f511c971a7ba067e6d1b  # 09:11    546+  =
  106  random: tighten bound on random_read_wakeup_thresh
git bisect  bad 4b22efdd5595f0acb48f02bf664a451ee98f9a2e  # 09:12      0-  =
    7  Add linux-next specific files for 20140403
git bisect  bad 4b22efdd5595f0acb48f02bf664a451ee98f9a2e  # 09:23      0-  =
    7  Add linux-next specific files for 20140403


This script may reproduce the error.

---------------------------------------------------------------------------=
--
#!/bin/bash

kernel=3D$1
initrd=3Dquantal-core-i386.cgz

wget --no-clobber https://github.com/fengguang/reproduce-kernel-bug/blob/ma=
ster/initrd/$initrd

kvm=3D(
	qemu-system-x86_64 -cpu kvm64 -enable-kvm
	-kernel $kernel
	-initrd $initrd
	-smp 2
	-m 256M
	-net nic,vlan=3D0,macaddr=3D00:00:00:00:00:00,model=3Dvirtio
	-net user,vlan=3D0
	-net nic,vlan=3D1,model=3De1000
	-net user,vlan=3D1
	-boot order=3Dnc
	-no-reboot
	-watchdog i6300esb
	-serial stdio
	-display none
	-monitor null
)

append=3D(
	debug
	sched_debug
	apic=3Ddebug
	ignore_loglevel
	sysrq_always_enabled
	panic=3D10
	prompt_ramdisk=3D0
	earlyprintk=3DttyS0,115200
	console=3DttyS0,115200
	console=3Dtty0
	vga=3Dnormal
	root=3D/dev/ram0
	rw
)

"${kvm[@]}" --append "${append[*]}"
---------------------------------------------------------------------------=
--

Thanks,
Fengguang

--ZPt4rx8FFjLCG7dd
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="dmesg-quantal-loslunas-12:20140405082625:i386-randconfig-fb0-04031419:3.13.0-00009-g11e9ee9:1"
Content-Transfer-Encoding: quoted-printable

early console in setup code
early console in decompress_kernel

Decompressing Linux... Parsing ELF... done.
Booting the kernel.
[    0.000000] Initializing cgroup subsys cpuset
[    0.000000] Initializing cgroup subsys cpu
[    0.000000] Linux version 3.13.0-00009-g11e9ee9 (kbuild@f2) (gcc version=
 4.8.2 (Debian 4.8.2-18) ) #1 Sat Apr 5 08:11:56 CST 2014
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
[    0.000000] SMBIOS 2.4 present.
[    0.000000] DMI: Bochs Bochs, BIOS Bochs 01/01/2011
[    0.000000] Hypervisor detected: KVM
[    0.000000] e820: update [mem 0x00000000-0x00000fff] usable =3D=3D> rese=
rved
[    0.000000] e820: remove [mem 0x000a0000-0x000fffff] usable
[    0.000000] e820: last_pfn =3D 0x13ffe max_arch_pfn =3D 0x100000
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
[    0.000000] found SMP MP-table at [mem 0x000fdae0-0x000fdaef] mapped at =
[c00fdae0]
[    0.000000]   mpc: fdaf0-fdbe4
[    0.000000] initial memory mapped: [mem 0x00000000-0x027fffff]
[    0.000000] Base memory trampoline at [c009b000] 9b000 size 16384
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
[    0.000000] BRK [0x0231e000, 0x0231efff] PGTABLE
[    0.000000] cma: CMA: reserved 32 MiB at 10400000
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
[    0.000000] BRK [0x0231f000, 0x0231ffff] PGTABLE
[    0.000000] Zone ranges:
[    0.000000]   DMA      [mem 0x00001000-0x00ffffff]
[    0.000000]   Normal   [mem 0x01000000-0x13ffdfff]
[    0.000000]   HighMem  empty
[    0.000000] Movable zone start for each node
[    0.000000] Early memory node ranges
[    0.000000]   node   0: [mem 0x00001000-0x0009efff]
[    0.000000]   node   0: [mem 0x00100000-0x13ffdfff]
[    0.000000] On node 0 totalpages: 81820
[    0.000000] free_area_init_node: node 0, pgdat c1d39a80, node_mem_map d2=
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
[    0.000000] mapped IOAPIC to ffff9000 (fec00000)
[    0.000000] nr_irqs_gsi: 40
[    0.000000] KVM setup async PF for cpu 0
[    0.000000] kvm-stealtime: cpu 0, msr 1b6e880
[    0.000000] PM: Registered nosave memory: [mem 0x0009f000-0x0009ffff]
[    0.000000] PM: Registered nosave memory: [mem 0x000a0000-0x000effff]
[    0.000000] PM: Registered nosave memory: [mem 0x000f0000-0x000fffff]
[    0.000000] e820: [mem 0x14000000-0xfeffbfff] available for PCI devices
[    0.000000] Booting paravirtualized kernel on KVM
[    0.000000] pcpu-alloc: s0 r0 d32768 u32768 alloc=3D1*32768
[    0.000000] pcpu-alloc: [0] 0=20
[    0.000000] Built 1 zonelists in Zone order, mobility grouping on.  Tota=
l pages: 81180
[    0.000000] Kernel command line: hung_task_panic=3D1 earlyprintk=3DttyS0=
,115200 debug apic=3Ddebug sysrq_always_enabled rcupdate.rcu_cpu_stall_time=
out=3D100 panic=3D10 softlockup_panic=3D1 nmi_watchdog=3Dpanic  prompt_ramd=
isk=3D0 console=3DttyS0,115200 console=3Dtty0 vga=3Dnormal  root=3D/dev/ram=
0 rw link=3D/kernel-tests/run-queue/kvm/i386-randconfig-fb0-04031419/next:m=
aster:11e9ee988e8f951e4dbc765832fdf6f08c2c8b54:bisect-drm/.vmlinuz-11e9ee98=
8e8f951e4dbc765832fdf6f08c2c8b54-20140405081535-145-loslunas branch=3Dnext/=
master BOOT_IMAGE=3D/kernel/i386-randconfig-fb0-04031419/11e9ee988e8f951e4d=
bc765832fdf6f08c2c8b54/vmlinuz-3.13.0-00009-g11e9ee9 drbd.minor_count=3D8
[    0.000000] sysrq: sysrq always enabled.
[    0.000000] PID hash table entries: 2048 (order: 1, 8192 bytes)
[    0.000000] Dentry cache hash table entries: 65536 (order: 6, 262144 byt=
es)
[    0.000000] Inode-cache hash table entries: 32768 (order: 5, 131072 byte=
s)
[    0.000000] Initializing CPU#0
[    0.000000] Initializing HighMem for node 0 (00000000:00000000)
[    0.000000] Memory: 246960K/327280K available (8371K kernel code, 2063K =
rwdata, 3240K rodata, 452K init, 5396K bss, 80320K reserved, 0K highmem)
[    0.000000] virtual kernel memory layout:
[    0.000000]     fixmap  : 0xfffa0000 - 0xfffff000   ( 380 kB)
[    0.000000]     pkmap   : 0xff800000 - 0xffc00000   (4096 kB)
[    0.000000]     vmalloc : 0xd47fe000 - 0xff7fe000   ( 688 MB)
[    0.000000]     lowmem  : 0xc0000000 - 0xd3ffe000   ( 319 MB)
[    0.000000]       .init : 0xc1d5d000 - 0xc1dce000   ( 452 kB)
[    0.000000]       .data : 0xc182d11f - 0xc1d5cd40   (5311 kB)
[    0.000000]       .text : 0xc1000000 - 0xc182d11f   (8372 kB)
[    0.000000] Checking if this processor honours the WP bit even in superv=
isor mode...Ok.
[    0.000000] SLUB: HWalign=3D128, Order=3D0-3, MinObjects=3D0, CPUs=3D1, =
Nodes=3D1
[    0.000000] NR_IRQS:2304 nr_irqs:256 16
[    0.000000] CPU 0 irqstacks, hard=3Dd0008000 soft=3Dd000a000
[    0.000000] Console: colour VGA+ 80x25
[    0.000000] console [tty0] enabled
[    0.000000] bootconsole [earlyser0] disabled
[    0.000000] Initializing cgroup subsys cpuset
[    0.000000] Initializing cgroup subsys cpu
[    0.000000] Linux version 3.13.0-00009-g11e9ee9 (kbuild@f2) (gcc version=
 4.8.2 (Debian 4.8.2-18) ) #1 Sat Apr 5 08:11:56 CST 2014
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
[    0.000000] SMBIOS 2.4 present.
[    0.000000] DMI: Bochs Bochs, BIOS Bochs 01/01/2011
[    0.000000] Hypervisor detected: KVM
[    0.000000] e820: update [mem 0x00000000-0x00000fff] usable =3D=3D> rese=
rved
[    0.000000] e820: remove [mem 0x000a0000-0x000fffff] usable
[    0.000000] e820: last_pfn =3D 0x13ffe max_arch_pfn =3D 0x100000
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
[    0.000000] found SMP MP-table at [mem 0x000fdae0-0x000fdaef] mapped at =
[c00fdae0]
[    0.000000]   mpc: fdaf0-fdbe4
[    0.000000] initial memory mapped: [mem 0x00000000-0x027fffff]
[    0.000000] Base memory trampoline at [c009b000] 9b000 size 16384
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
[    0.000000] BRK [0x0231e000, 0x0231efff] PGTABLE
[    0.000000] cma: CMA: reserved 32 MiB at 10400000
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
[    0.000000] BRK [0x0231f000, 0x0231ffff] PGTABLE
[    0.000000] Zone ranges:
[    0.000000]   DMA      [mem 0x00001000-0x00ffffff]
[    0.000000]   Normal   [mem 0x01000000-0x13ffdfff]
[    0.000000]   HighMem  empty
[    0.000000] Movable zone start for each node
[    0.000000] Early memory node ranges
[    0.000000]   node   0: [mem 0x00001000-0x0009efff]
[    0.000000]   node   0: [mem 0x00100000-0x13ffdfff]
[    0.000000] On node 0 totalpages: 81820
[    0.000000] free_area_init_node: node 0, pgdat c1d39a80, node_mem_map d2=
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
[    0.000000] mapped IOAPIC to ffff9000 (fec00000)
[    0.000000] nr_irqs_gsi: 40
[    0.000000] KVM setup async PF for cpu 0
[    0.000000] kvm-stealtime: cpu 0, msr 1b6e880
[    0.000000] PM: Registered nosave memory: [mem 0x0009f000-0x0009ffff]
[    0.000000] PM: Registered nosave memory: [mem 0x000a0000-0x000effff]
[    0.000000] PM: Registered nosave memory: [mem 0x000f0000-0x000fffff]
[    0.000000] e820: [mem 0x14000000-0xfeffbfff] available for PCI devices
[    0.000000] Booting paravirtualized kernel on KVM
[    0.000000] pcpu-alloc: s0 r0 d32768 u32768 alloc=3D1*32768
[    0.000000] pcpu-alloc: [0] 0=20
[    0.000000] Built 1 zonelists in Zone order, mobility grouping on.  Tota=
l pages: 81180
[    0.000000] Kernel command line: hung_task_panic=3D1 earlyprintk=3DttyS0=
,115200 debug apic=3Ddebug sysrq_always_enabled rcupdate.rcu_cpu_stall_time=
out=3D100 panic=3D10 softlockup_panic=3D1 nmi_watchdog=3Dpanic  prompt_ramd=
isk=3D0 console=3DttyS0,115200 console=3Dtty0 vga=3Dnormal  root=3D/dev/ram=
0 rw link=3D/kernel-tests/run-queue/kvm/i386-randconfig-fb0-04031419/next:m=
aster:11e9ee988e8f951e4dbc765832fdf6f08c2c8b54:bisect-drm/.vmlinuz-11e9ee98=
8e8f951e4dbc765832fdf6f08c2c8b54-20140405081535-145-loslunas branch=3Dnext/=
master BOOT_IMAGE=3D/kernel/i386-randconfig-fb0-04031419/11e9ee988e8f951e4d=
bc765832fdf6f08c2c8b54/vmlinuz-3.13.0-00009-g11e9ee9 drbd.minor_count=3D8
[    0.000000] sysrq: sysrq always enabled.
[    0.000000] PID hash table entries: 2048 (order: 1, 8192 bytes)
[    0.000000] Dentry cache hash table entries: 65536 (order: 6, 262144 byt=
es)
[    0.000000] Inode-cache hash table entries: 32768 (order: 5, 131072 byte=
s)
[    0.000000] Initializing CPU#0
[    0.000000] Initializing HighMem for node 0 (00000000:00000000)
[    0.000000] Memory: 246960K/327280K available (8371K kernel code, 2063K =
rwdata, 3240K rodata, 452K init, 5396K bss, 80320K reserved, 0K highmem)
[    0.000000] virtual kernel memory layout:
[    0.000000]     fixmap  : 0xfffa0000 - 0xfffff000   ( 380 kB)
[    0.000000]     pkmap   : 0xff800000 - 0xffc00000   (4096 kB)
[    0.000000]     vmalloc : 0xd47fe000 - 0xff7fe000   ( 688 MB)
[    0.000000]     lowmem  : 0xc0000000 - 0xd3ffe000   ( 319 MB)
[    0.000000]       .init : 0xc1d5d000 - 0xc1dce000   ( 452 kB)
[    0.000000]       .data : 0xc182d11f - 0xc1d5cd40   (5311 kB)
[    0.000000]       .text : 0xc1000000 - 0xc182d11f   (8372 kB)
[    0.000000] Checking if this processor honours the WP bit even in superv=
isor mode...Ok.
[    0.000000] SLUB: HWalign=3D128, Order=3D0-3, MinObjects=3D0, CPUs=3D1, =
Nodes=3D1
[    0.000000] NR_IRQS:2304 nr_irqs:256 16
[    0.000000] CPU 0 irqstacks, hard=3Dd0008000 soft=3Dd000a000
[    0.000000] Console: colour VGA+ 80x25
[    0.000000] console [tty0] enabled
[    0.000000] bootconsole [earlyser0] disabled
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
[    0.000000] ODEBUG: 5 of 5 active objects replaced
[    0.000000] ODEBUG: selftest passed
[    0.000000] hpet clockevent registered
[    0.000000] tsc: Detected 2194.944 MHz processor
[    0.020000] Calibrating delay loop (skipped) preset value.. 4389.88 Bogo=
MIPS (lpj=3D21949440)
[    0.020000] pid_max: default: 32768 minimum: 301
[    0.020000] Mount-cache hash table entries: 512
[    0.020000] Initializing cgroup subsys debug
[    0.020000] Initializing cgroup subsys freezer
[    0.020018] Initializing cgroup subsys net_cls
[    0.021468] Last level iTLB entries: 4KB 0, 2MB 0, 4MB 0
[    0.021468] Last level dTLB entries: 4KB 0, 2MB 0, 4MB 0
[    0.021468] tlb_flushall_shift: 6
[    0.025247] CPU: Intel Common KVM processor (fam: 0f, model: 06, steppin=
g: 01)
[    0.033610] ACPI: Core revision 20131115
[    0.037133] ACPI: All ACPI Tables successfully acquired
[    0.039052] Performance Events: unsupported Netburst CPU model 6 no PMU =
driver, software events only.
[    0.043912] Enabling APIC mode:  Flat.  Using 1 I/O APICs
[    0.045402] Getting VERSION: 50014
[    0.046491] Getting VERSION: 50014
[    0.047664] Getting ID: 0
[    0.048619] Getting ID: f000000
[    0.050019] Getting LVT0: 8700
[    0.051089] Getting LVT1: 8400
[    0.052259] enabled ExtINT on CPU#0
[    0.054733] ENABLING IO-APIC IRQs
[    0.055863] init IO_APIC IRQs
[    0.056890]  apic 0 pin 0 not connected
[    0.058901] IOAPIC[0]: Set routing entry (0-1 -> 0x31 -> IRQ 1 Mode:0 Ac=
tive:0 Dest:1)
[    0.060037] IOAPIC[0]: Set routing entry (0-2 -> 0x30 -> IRQ 0 Mode:0 Ac=
tive:0 Dest:1)
[    0.062496] IOAPIC[0]: Set routing entry (0-3 -> 0x33 -> IRQ 3 Mode:0 Ac=
tive:0 Dest:1)
[    0.064829] IOAPIC[0]: Set routing entry (0-4 -> 0x34 -> IRQ 4 Mode:0 Ac=
tive:0 Dest:1)
[    0.067213] IOAPIC[0]: Set routing entry (0-5 -> 0x35 -> IRQ 5 Mode:1 Ac=
tive:0 Dest:1)
[    0.070033] IOAPIC[0]: Set routing entry (0-6 -> 0x36 -> IRQ 6 Mode:0 Ac=
tive:0 Dest:1)
[    0.072275] IOAPIC[0]: Set routing entry (0-7 -> 0x37 -> IRQ 7 Mode:0 Ac=
tive:0 Dest:1)
[    0.074604] IOAPIC[0]: Set routing entry (0-8 -> 0x38 -> IRQ 8 Mode:0 Ac=
tive:0 Dest:1)
[    0.076962] IOAPIC[0]: Set routing entry (0-9 -> 0x39 -> IRQ 9 Mode:1 Ac=
tive:0 Dest:1)
[    0.080033] IOAPIC[0]: Set routing entry (0-10 -> 0x3a -> IRQ 10 Mode:1 =
Active:0 Dest:1)
[    0.082398] IOAPIC[0]: Set routing entry (0-11 -> 0x3b -> IRQ 11 Mode:1 =
Active:0 Dest:1)
[    0.084735] IOAPIC[0]: Set routing entry (0-12 -> 0x3c -> IRQ 12 Mode:0 =
Active:0 Dest:1)
[    0.087054] IOAPIC[0]: Set routing entry (0-13 -> 0x3d -> IRQ 13 Mode:0 =
Active:0 Dest:1)
[    0.089353] IOAPIC[0]: Set routing entry (0-14 -> 0x3e -> IRQ 14 Mode:0 =
Active:0 Dest:1)
[    0.090037] IOAPIC[0]: Set routing entry (0-15 -> 0x3f -> IRQ 15 Mode:0 =
Active:0 Dest:1)
[    0.092354]  apic 0 pin 16 not connected
[    0.093535]  apic 0 pin 17 not connected
[    0.094666]  apic 0 pin 18 not connected
[    0.100007]  apic 0 pin 19 not connected
[    0.101291]  apic 0 pin 20 not connected
[    0.102452]  apic 0 pin 21 not connected
[    0.103640]  apic 0 pin 22 not connected
[    0.104799]  apic 0 pin 23 not connected
[    0.106211] ..TIMER: vector=3D0x30 apic1=3D0 pin1=3D2 apic2=3D-1 pin2=3D=
-1
[    0.107946] Using local APIC timer interrupts.
[    0.107946] calibrating APIC timer ...
[    0.120000] ... lapic delta =3D 6250087
[    0.120000] ... PM-Timer delta =3D 357960
[    0.120000] ... PM-Timer result ok
[    0.120000] ..... delta 6250087
[    0.120000] ..... mult: 268439192
[    0.120000] ..... calibration result: 10000139
[    0.120000] ..... CPU clock speed is 2194.9797 MHz.
[    0.120000] ..... host bus clock speed is 1000.0139 MHz.
[    0.120160] NMI watchdog: disabled (cpu0): hardware events not enabled
[    0.122648] devtmpfs: initialized
[    0.125231] xor: measuring software checksum speed
[    0.220023]    pIII_sse  :   191.600 MB/sec
[    0.320016]    prefetch64-sse:   197.600 MB/sec
[    0.321445] xor: using function: prefetch64-sse (197.600 MB/sec)
[    0.323184] prandom: seed boundary self test passed
[    0.325613] prandom: 100 self tests passed
[    0.327236] regulator-dummy: no parameters
[    0.328931] NET: Registered protocol family 16
[    0.330699] cpuidle: using governor menu
[    0.332468] ACPI: bus type PCI registered
[    0.334061] PCI: Using configuration type 1 for base access
[    0.342237] bio: create slab <bio-0> at 0
[    0.510023] raid6: mmxx1     2487 MB/s
[    0.680012] raid6: mmxx2     2695 MB/s
[    0.850008] raid6: sse1x1    3084 MB/s
[    1.020008] raid6: sse1x2    4024 MB/s
[    1.190006] raid6: sse2x1    6679 MB/s
[    1.360010] raid6: sse2x2    8357 MB/s
[    1.361082] raid6: using algorithm sse2x2 (8357 MB/s)
[    1.362384] raid6: using intx1 recovery algorithm
[    1.363805] ACPI: Added _OSI(Module Device)
[    1.364952] ACPI: Added _OSI(Processor Device)
[    1.366138] ACPI: Added _OSI(3.0 _SCP Extensions)
[    1.367372] ACPI: Added _OSI(Processor Aggregator Device)
[    1.374913] ACPI: Interpreter enabled
[    1.375975] ACPI: (supports S0 S4 S5)
[    1.376990] ACPI: Using IOAPIC for interrupt routing
[    1.378284] PCI: Using host bridge windows from ACPI; if necessary, use =
"pci=3Dnocrs" and report a bug
[    1.388015] ACPI: PCI Root Bridge [PCI0] (domain 0000 [bus 00-ff])
[    1.390009] acpi PNP0A03:00: _OSC: OS supports [Segments MSI]
[    1.391417] acpi PNP0A03:00: _OSC failed (AE_NOT_FOUND); disabling ASPM
[    1.393236] acpi PNP0A03:00: fail to add MMCONFIG information, can't acc=
ess extended PCI configuration space under this bridge.
[    1.396027] PCI host bridge to bus 0000:00
[    1.397126] pci_bus 0000:00: root bus resource [bus 00-ff]
[    1.398486] pci_bus 0000:00: root bus resource [io  0x0000-0x0cf7]
[    1.400005] pci_bus 0000:00: root bus resource [io  0x0d00-0xffff]
[    1.401471] pci_bus 0000:00: root bus resource [mem 0x000a0000-0x000bfff=
f]
[    1.403084] pci_bus 0000:00: root bus resource [mem 0x80000000-0xfebffff=
f]
[    1.404717] pci 0000:00:00.0: [8086:1237] type 00 class 0x060000
[    1.406692] pci 0000:00:01.0: [8086:7000] type 00 class 0x060100
[    1.408787] pci 0000:00:01.1: [8086:7010] type 00 class 0x010180
[    1.412628] pci 0000:00:01.1: reg 0x20: [io  0xc040-0xc04f]
[    1.415334] pci 0000:00:01.3: [8086:7113] type 00 class 0x068000
[    1.417113] pci 0000:00:01.3: quirk: [io  0xb000-0xb03f] claimed by PIIX=
4 ACPI
[    1.419041] pci 0000:00:01.3: quirk: [io  0xb100-0xb10f] claimed by PIIX=
4 SMB
[    1.420373] pci 0000:00:02.0: [1013:00b8] type 00 class 0x030000
[    1.423933] pci 0000:00:02.0: reg 0x10: [mem 0xfc000000-0xfdffffff pref]
[    1.426837] pci 0000:00:02.0: reg 0x14: [mem 0xfebf0000-0xfebf0fff]
[    1.435426] pci 0000:00:02.0: reg 0x30: [mem 0xfebe0000-0xfebeffff pref]
[    1.437644] pci 0000:00:03.0: [8086:100e] type 00 class 0x020000
[    1.440023] pci 0000:00:03.0: reg 0x10: [mem 0xfeba0000-0xfebbffff]
[    1.442486] pci 0000:00:03.0: reg 0x14: [io  0xc000-0xc03f]
[    1.448643] pci 0000:00:03.0: reg 0x30: [mem 0xfebc0000-0xfebdffff pref]
[    1.450370] pci 0000:00:04.0: [8086:25ab] type 00 class 0x088000
[    1.452350] pci 0000:00:04.0: reg 0x10: [mem 0xfebf1000-0xfebf100f]
[    1.457318] pci_bus 0000:00: on NUMA node 0
[    1.460016] ACPI: PCI Interrupt Link [LNKA] (IRQs 5 *10 11)
[    1.461931] ACPI: PCI Interrupt Link [LNKB] (IRQs 5 *10 11)
[    1.463850] ACPI: PCI Interrupt Link [LNKC] (IRQs 5 10 *11)
[    1.465781] ACPI: PCI Interrupt Link [LNKD] (IRQs 5 10 *11)
[    1.467614] ACPI: PCI Interrupt Link [LNKS] (IRQs *9)
[    1.469884] ACPI: Enabled 16 GPEs in block 00 to 0F
[    1.470017] ACPI: \_SB_.PCI0: notify handler is installed
[    1.471485] Found 1 acpi root devices
[    1.473032] vgaarb: device added: PCI:0000:00:02.0,decodes=3Dio+mem,owns=
=3Dio+mem,locks=3Dnone
[    1.475132] vgaarb: loaded
[    1.475953] vgaarb: bridge control possible 0000:00:02.0
[    1.477519] ACPI: bus type USB registered
[    1.478636] usbcore: registered new interface driver usbfs
[    1.480030] usbcore: registered new interface driver hub
[    1.481465] usbcore: registered new device driver usb
[    1.482788] pps_core: LinuxPPS API ver. 1 registered
[    1.484018] pps_core: Software ver. 5.3.6 - Copyright 2005-2007 Rodolfo =
Giometti <giometti@linux.it>
[    1.486525] wmi: Mapper loaded
[    1.487450] PCI: Using ACPI for IRQ routing
[    1.488587] PCI: pci_cache_line_size set to 64 bytes
[    1.490130] e820: reserve RAM buffer [mem 0x0009fc00-0x0009ffff]
[    1.491639] e820: reserve RAM buffer [mem 0x13ffe000-0x13ffffff]
[    1.493431] Bluetooth: Core ver 2.17
[    1.494482] NET: Registered protocol family 31
[    1.495676] Bluetooth: HCI device and connection manager initialized
[    1.497246] Bluetooth: HCI socket layer initialized
[    1.498527] Bluetooth: L2CAP socket layer initialized
[    1.500017] Bluetooth: SCO socket layer initialized
[    1.501858] HPET: 3 timers in total, 0 timers will be used for per-cpu t=
imer
[    1.503671] Switched to clocksource kvm-clock
[    1.505011] pnp: PnP ACPI init
[    1.505970] ACPI: bus type PNP registered
[    1.507144] IOAPIC[0]: Set routing entry (0-8 -> 0x38 -> IRQ 8 Mode:0 Ac=
tive:0 Dest:1)
[    1.509253] pnp 00:00: Plug and Play ACPI device, IDs PNP0b00 (active)
[    1.509253] IOAPIC[0]: Set routing entry (0-1 -> 0x31 -> IRQ 1 Mode:0 Ac=
tive:0 Dest:1)
[    1.509486] pnp 00:01: Plug and Play ACPI device, IDs PNP0303 (active)
[    1.511131] IOAPIC[0]: Set routing entry (0-12 -> 0x3c -> IRQ 12 Mode:0 =
Active:0 Dest:1)
[    1.513325] pnp 00:02: Plug and Play ACPI device, IDs PNP0f13 (active)
[    1.514957] IOAPIC[0]: Set routing entry (0-6 -> 0x36 -> IRQ 6 Mode:0 Ac=
tive:0 Dest:1)
[    1.517098] pnp 00:03: [dma 2]
[    1.518058] pnp 00:03: Plug and Play ACPI device, IDs PNP0700 (active)
[    1.519710] IOAPIC[0]: Set routing entry (0-7 -> 0x37 -> IRQ 7 Mode:0 Ac=
tive:0 Dest:1)
[    1.521923] pnp 00:04: Plug and Play ACPI device, IDs PNP0400 (active)
[    1.523574] IOAPIC[0]: Set routing entry (0-4 -> 0x34 -> IRQ 4 Mode:0 Ac=
tive:0 Dest:1)
[    1.525743] pnp 00:05: Plug and Play ACPI device, IDs PNP0501 (active)
[    1.527380] IOAPIC[0]: Set routing entry (0-3 -> 0x33 -> IRQ 3 Mode:0 Ac=
tive:0 Dest:1)
[    1.529547] pnp 00:06: Plug and Play ACPI device, IDs PNP0501 (active)
[    1.531469] pnp 00:07: Plug and Play ACPI device, IDs PNP0103 (active)
[    1.533245] pnp: PnP ACPI: found 8 devices
[    1.534396] ACPI: bus type PNP unregistered
[    1.535760] PnPBIOS: Disabled
[    1.809914] mdacon: MDA with 8K of memory detected.
[    1.809983] Console: switching consoles 13-16 to MDA-2
[    1.847418] pci_bus 0000:00: resource 4 [io  0x0000-0x0cf7]
[    1.848840] pci_bus 0000:00: resource 5 [io  0x0d00-0xffff]
[    1.850266] pci_bus 0000:00: resource 6 [mem 0x000a0000-0x000bffff]
[    1.851808] pci_bus 0000:00: resource 7 [mem 0x80000000-0xfebfffff]
[    1.853382] NET: Registered protocol family 1
[    1.854572] pci 0000:00:00.0: Limiting direct PCI/PCI transfers
[    1.856059] pci 0000:00:01.0: PIIX3: Enabling Passive Release
[    1.857514] pci 0000:00:01.0: Activating ISA DMA hang workarounds
[    1.859066] pci 0000:00:02.0: Boot video device
[    1.860328] PCI: CLS 0 bytes, default 64
[    1.861608] Unpacking initramfs...
[    2.771500] Freeing initrd memory: 24852K (d27ab000 - d3ff0000)
[    2.774178] cryptomgr_test (19) used greatest stack depth: 7392 bytes le=
ft
[    2.776259] NatSemi SCx200 Driver
[    2.777980] Initialise system trusted keyring
[    2.779431] audit: initializing netlink socket (disabled)
[    2.781148] type=3D2000 audit(1396656997.515:1): initialized
[    2.821931] VFS: Disk quotas dquot_6.5.2
[    2.823319] Dquot-cache hash table entries: 1024 (order 0, 4096 bytes)
[    2.826454] bio: create slab <bio-1> at 1
[    2.828443] Btrfs loaded, integrity-checker=3Don
[    2.829948] msgmni has been set to 594
[    2.833178] async_tx: api initialized (async)
[    2.834596] Key type asymmetric registered
[    2.835905] Asymmetric key parser 'x509' registered
[    2.837541] Block layer SCSI generic (bsg) driver version 0.4 loaded (ma=
jor 251)
[    2.839968] io scheduler noop registered (default)
[    2.841613] io scheduler cfq registered
[    2.842932] list_sort_test: start testing list_sort()
[    2.844803] rbtree testing -> 12674 cycles
[    3.455363] augmented rbtree testing -> 17171 cycles
[    4.287903] pci_hotplug: PCI Hot Plug PCI Core version: 0.5
[    4.289633] Console: switching consoles 13-16 to MDA-2
[    4.291673] rivafb_setup START
[    4.293010] VIA Graphics Integration Chipset framebuffer 2.4 initializing
[    4.298816] hgafb: HGA card not detected.
[    4.300228] hgafb: probe of hgafb.0 failed with error -22
[    4.302774] cirrusfb 0000:00:02.0: Cirrus Logic chipset on PCI bus, RAM =
(4096 kB) at 0xfc000000
[    4.305680] tsc: Refined TSC clocksource calibration: 2194.947 MHz
[    4.307684] fbcon: CL Picasso4 (fb0) is primary device
[    4.310201] [sched_delayed] sched: RT throttling activated
[    4.734465] Console: switching to colour frame buffer device 80x30
[    4.864015] usbcore: registered new interface driver smscufx
[    4.871808] input: Power Button as /devices/LNXSYSTM:00/LNXPWRBN:00/inpu=
t/input0
[    5.140400] ACPI: Power Button [PWRF]
[    5.398523] isapnp: Scanning for PnP cards...
[    5.963227] isapnp: No Plug & Play device found
[    6.210137] Serial: 8250/16550 driver, 4 ports, IRQ sharing disabled
[    6.490544] 00:05: ttyS0 at I/O 0x3f8 (irq =3D 4, base_baud =3D 115200) =
is a 16550A
[    7.015534] Cyclades driver 2.6
[    7.307251] MOXA Intellio family driver version 6.0k
[    7.577436] MOXA Smartio/Industio family driver version 2.0.5
[    7.838897] SyncLink serial driver $Revision: 4.38 $
[    8.107187] SyncLink serial driver $Revision: 4.38 $, tty major#248
[    8.367042] Applicom driver: $Id: ac.c,v 1.30 2000/03/22 16:03:57 dwmw2 =
Exp $
[    8.630526] ac.o: No PCI boards found.
[    8.901239] ac.o: For an ISA board you must supply memory and irq parame=
ters.
[    9.182826] kpnpbiosd (49) used greatest stack depth: 7240 bytes left
[    9.462308] Non-volatile memory driver v1.3
[    9.746871] toshiba: not a supported Toshiba laptop
[   10.029708] Linux agpgart interface v0.103
[   10.312190] [drm] Initialized drm 1.1.0 20060810
[   10.588877] usbcore: registered new interface driver udl
[   10.826428] loop: module loaded
[   11.110374] null_blk: softirq completions not available.
[   11.350191] null_blk: using direct completions.
[   11.602248] blk-mq: CPU -> queue map
[   11.832243]   CPU 0 -> Queue 0
[   12.079077]  nullb0: unknown partition table
[   12.335318] blk-mq: CPU -> queue map
[   12.524483]   CPU 0 -> Queue 0
[   12.747736]  nullb1: unknown partition table
[   12.943561] null: module loaded
[   13.193112] ibmasm: IBM ASM Service Processor Driver version 1.0 loaded
[   13.439076] Uniform Multi-Platform E-IDE driver
[   13.686162] slram: not enough parameters.
[   13.943934] Ramix PMC551 PCI Mezzanine Ram Driver. (C) 1999,2000 Nortel =
Networks.
[   14.458845] pmc551: not detected
[   14.714081] CAN device driver interface
[   14.960470] usbcore: registered new interface driver esd_usb2
[   15.204829] usbcore: registered new interface driver peak_usb
[   15.378717] Databook TCIC-2 PCMCIA probe: not found.
[   15.631874] ohci_hcd: USB 1.1 'Open' Host Controller (OHCI) Driver
[   15.862471] ohci-platform: OHCI generic platform driver
[   16.037612] uhci_hcd: USB Universal Host Controller Interface driver
[   16.209314] usbcore: registered new interface driver usblp
[   16.433360] usbcore: registered new interface driver mdc800
[   16.601109] mdc800: v0.7.5 (30/10/2000):USB Driver for Mustek MDC800 Dig=
ital Camera
[   16.960357] usbcore: registered new interface driver adutux
[   17.144583] usbcore: registered new interface driver emi62 - firmware lo=
ader
[   17.345468] usbcore: registered new interface driver legousbtower
[   17.565363] usbcore: registered new interface driver usbsevseg
[   17.795941] i8042: PNP: PS/2 Controller [PNP0303:KBD,PNP0f13:MOU] at 0x6=
0,0x64 irq 1,12
[   18.265867] serio: i8042 KBD port at 0x60,0x64 irq 1
[   18.512585] serio: i8042 AUX port at 0x60,0x64 irq 12
[   18.754914] usbcore: registered new interface driver appletouch
[   18.998725] logibm.c: Didn't find Logitech busmouse at 0x23c
[   19.247675] apanel: Fujitsu BIOS signature 'FJKEYINF' not found...
[   19.494953] cm109: Keymap for Komunikate KIP1000 phone loaded
[   19.738987] usbcore: registered new interface driver cm109
[   19.976161] cm109: CM109 phone driver: 20080805 (C) Alfred E. Heggestad
[   20.217572] usbcore: registered new interface driver keyspan_remote
[   20.460751] input: AT Translated Set 2 keyboard as /devices/platform/i80=
42/serio0/input/input1
[   20.919325] usbcore: registered new interface driver yealink
[   21.154829] piix4_smbus 0000:00:01.3: SMBus Host Controller at 0xb100, r=
evision 0
[   21.930741] usbcore: registered new interface driver i2c-diolan-u2c
[   22.245406] usbcore: registered new interface driver i2c-tiny-usb
[   22.492669] Driver for 1-wire Dallas network protocol.
[   22.749865] usbcore: registered new interface driver pcwd_usb
[   23.007534] ib700wdt: WDT driver for IB700 single board computer initial=
ising
[   23.262872] i6300esb: Intel 6300ESB WatchDog Timer Driver v0.05
[   23.508704] i6300esb: cannot register miscdev on minor=3D130 (err=3D-16)
[   23.756905] i6300ESB timer: probe of 0000:00:04.0 failed with error -16
[   24.020249] iTCO_wdt: Intel TCO WatchDog Timer Driver v1.10
[   24.266452] iTCO_vendor_support: vendor-support=3D0
[   24.539731] cpu5wdt: misc_register failed
[   24.772852] smsc37b787_wdt: SMsC 37B787 watchdog component driver 1.1 in=
itialising...
[   25.368369] smsc37b787_wdt: Unable to register miscdev on minor 130
[   25.658293] w83697hf_wdt: WDT driver for W83697HF/HG initializing
[   26.019276] w83697hf_wdt: watchdog not found at address 0x2e
[   26.493459] w83697hf_wdt: No W83697HF/HG could be found
[   26.748479] w83697ug_wdt: WDT driver for the Winbond(TM) W83697UG/UF Sup=
er I/O chip initialising
[   27.261772] w83697ug_wdt: No W83697UG/UF could be found
[   27.522466] w83877f_wdt: I/O address 0x0443 already in use
[   27.781609] machzwd: MachZ ZF-Logic Watchdog driver initializing
[   28.040305] machzwd: no ZF-Logic found
[   28.298092] sbc_epx_c3: cannot register miscdev on minor=3D130 (err=3D-1=
6)
[   28.562503] md: raid0 personality registered for level 0
[   28.826906] md: raid1 personality registered for level 1
[   29.084693] md: raid10 personality registered for level 10
[   29.346230] md: raid6 personality registered for level 6
[   29.598185] md: raid5 personality registered for level 5
[   29.834678] md: raid4 personality registered for level 4
[   30.063605] md: multipath personality registered for level -4
[   30.307669] usbcore: registered new interface driver bpa10x
[   30.586121] usbcore: registered new interface driver bfusb
[   30.816373] usbcore: registered new interface driver btusb
[   31.043742] lguest: mapped switcher at fff9c000
[   31.274683] wbsd: Winbond W83L51xD SD/MMC card interface driver
[   31.509652] wbsd: Copyright(c) Pierre Ossman
[   31.741886] VUB300 Driver rom wait states =3D 1C irqpoll timeout =3D 0400
[   31.754542] usbcore: registered new interface driver vub300
[   38.240171]  (null): enodev DEV ADDR =3D 0xFF
[   38.482802] ledtrig-cpu: registered to indicate activity on CPUs
[   38.727393] beceem: Beceem Communications Inc. WiMAX driver, 5.2.45
[   38.960421] Copyright 2010. Beceem Communications Inc
[   39.184403] usbcore: registered new interface driver usbbcm
[   39.421676] usbcore: registered new interface driver ft1000usb
[   39.638979] usbcore: registered new interface driver gdm_wimax
[   39.856423] dgap: dgap-1.3-16, Digi International Part Number 40002347_C
[   40.065561] dgap: For the tools package or updated drivers please visit =
http://www.digi.com
[   40.486271] goldfish_pdev_bus goldfish_pdev_bus: unable to reserve Goldf=
ish MMIO.
[   40.919399] goldfish_pdev_bus: probe of goldfish_pdev_bus failed with er=
ror -16
[   41.369646]  fake-fmc-carrier: mezzanine 0
[   41.596919]       Manufacturer: fake-vendor
[   41.823091]       Product name: fake-design-for-testing
[   42.050669] fmc fake-design-for-testing-f001: Driver has no ID: matches =
all
[   42.292014] fmc_write_eeprom fake-design-for-testing-f001: fmc_write_eep=
rom: no busid passed, refusing all cards
[   42.778298] GACT probability NOT on
[   43.019961] Simple TC action Loaded
[   43.256009] netem: version 1.3
[   43.493947] Ebtables v2.0 registered
[   43.729719] NET: Registered protocol family 5
[   43.966813] can: controller area network core (rev 20120528 abi 9)
[   44.211220] NET: Registered protocol family 29
[   44.459179] can: raw protocol (rev 20120528)
[   44.705194] NET4: DECnet for Linux: V.2.5.68s (C) 1995-2003 Linux DECnet=
 Project Team
[   45.204875] DECnet: Routing cache hash table of 256 buckets, 11Kbytes
[   45.527965] NET: Registered protocol family 12
[   45.872128] NET: Registered protocol family 35
[   46.259470] 8021q: 802.1Q VLAN Support v1.8
[   46.524078] 9pnet: Installing 9P2000 support
[   46.790844] NET: Registered protocol family 36
[   47.060705] Key type dns_resolver registered
[   47.328548] mpls_gso: MPLS GSO support
[   47.592937]=20
[   47.592937] printing PIC contents
[   48.107334] ... PIC  IMR: ffff
[   48.117145] ... PIC  IRR: 1013
[   48.584323] ... PIC  ISR: 0000
[   48.808981] ... PIC ELCR: 0c00
[   49.030321] printing local APIC contents on CPU#0/0:
[   49.040157] ... APIC ID:      00000000 (0)
[   49.040157] ... APIC VERSION: 00050014
[   49.040157] ... APIC TASKPRI: 00000000 (00)
[   49.040157] ... APIC PROCPRI: 00000000
[   49.040157] ... APIC LDR: 01000000
[   49.040157] ... APIC DFR: ffffffff
[   49.040157] ... APIC SPIV: 000001ff
[   49.040157] ... APIC ISR field:
[   49.040157] 000000000000000000000000000000000000000000000000000000000000=
0000
[   49.040157] ... APIC TMR field:
[   49.040157] 000000000200000000000000000000000000000000000000000000000000=
0000
[   49.040157] ... APIC IRR field:
[   49.040157] 000000000000000000000000000000000000000000000000000000000000=
8000
[   49.040157] ... APIC ESR: 00000000
[   49.040157] ... APIC ICR: 00000831
[   49.040157] ... APIC ICR2: 01000000
[   49.040157] ... APIC LVTT: 000000ef
[   49.040157] ... APIC LVTPC: 00010000
[   49.040157] ... APIC LVT0: 00010700
[   49.040157] ... APIC LVT1: 00000400
[   49.040157] ... APIC LVTERR: 000000fe
[   49.040157] ... APIC TMICT: 00095af0
[   49.040157] ... APIC TMCCT: 00000000
[   49.040157] ... APIC TDCR: 00000003
[   49.040157]=20
[   54.407307] number of MP IRQ sources: 15.
[   54.530801] number of IO-APIC #0 registers: 24.
[   54.672927] testing the IO APIC.......................
[   54.934169] IO APIC #0......
[   55.069484] .... register #00: 00000000
[   55.192747] .......    : physical APIC id: 00
[   55.320624] .......    : Delivery Type: 0
[   55.443784] .......    : LTS          : 0
[   55.568590] .... register #01: 00170011
[   55.696228] .......     : max redirection entries: 17
[   55.830464] .......     : PRQ implemented: 0
[   55.965315] .......     : IO APIC version: 11
[   56.103470] .... register #02: 00000000
[   56.245589] .......     : arbitration: 00
[   56.449962] .... IRQ redirection table:
[   56.598801] 1    0    0   0   0    0    0    00
[   56.755196] 0    0    0   0   0    1    1    31
[   56.914576] 0    0    0   0   0    1    1    30
[   57.073151] 0    0    0   0   0    1    1    33
[   57.240510] 1    0    0   0   0    1    1    34
[   57.406240] 1    1    0   0   0    1    1    35
[   57.703360] 0    0    0   0   0    1    1    36
[   57.864806] 0    0    0   0   0    1    1    37
[   58.030145] 0    0    0   0   0    1    1    38
[   58.188847] 0    1    0   0   0    1    1    39
[   58.349288] 1    1    0   0   0    1    1    3A
[   58.509836] 1    1    0   0   0    1    1    3B
[   58.671416] 0    0    0   0   0    1    1    3C
[   58.837070] 0    0    0   0   0    1    1    3D
[   58.999288] 0    0    0   0   0    1    1    3E
[   59.164650] 0    0    0   0   0    1    1    3F
[   59.316752] 1    0    0   0   0    0    0    00
[   59.470512] 1    0    0   0   0    0    0    00
[   59.621947] 1    0    0   0   0    0    0    00
[   59.768409] 1    0    0   0   0    0    0    00
[   59.908853] 1    0    0   0   0    0    0    00
[   60.051803] 1    0    0   0   0    0    0    00
[   60.192495] 1    0    0   0   0    0    0    00
[   60.326133] 1    0    0   0   0    0    0    00
[   60.453957] IRQ to pin mappings:
[   60.587673] IRQ0 -> 0:2
[   60.725571] IRQ1 -> 0:1
[   60.862003] IRQ3 -> 0:3
[   60.995641] IRQ4 -> 0:4
[   61.126333] IRQ5 -> 0:5
[   61.256778] IRQ6 -> 0:6
[   61.383079] IRQ7 -> 0:7
[   61.512067] IRQ8 -> 0:8
[   61.642024] IRQ9 -> 0:9
[   61.773572] IRQ10 -> 0:10
[   61.914464] IRQ11 -> 0:11
[   62.051750] IRQ12 -> 0:12
[   62.182591] IRQ13 -> 0:13
[   62.325413] IRQ14 -> 0:14
[   62.454754] IRQ15 -> 0:15
[   62.582865] .................................... done.
[   62.707289] Using IPI Shortcut mode
[   62.853444] Loading compiled-in X.509 certificates
[   62.984287] Loaded X.509 cert 'Magrathea: Glacier signing key: 0be6e5362=
bfdf505c2bc07167a41e6c34926cc34'
[   63.256653] raid6test: testing the 4-disk case...
[   63.395788] raid6test: test_disks(0, 1): faila=3D  0(D)  failb=3D  1(D) =
 OK
[   63.542572] raid6test: test_disks(0, 2): faila=3D  0(D)  failb=3D  2(P) =
 OK
[   63.691956] raid6test: test_disks(0, 3): faila=3D  0(D)  failb=3D  3(Q) =
 OK
[   63.843885] raid6test: test_disks(1, 2): faila=3D  1(D)  failb=3D  2(P) =
 OK
[   64.001986] raid6test: test_disks(1, 3): faila=3D  1(D)  failb=3D  3(Q) =
 OK
[   64.164480] raid6test: test_disks(2, 3): faila=3D  2(P)  failb=3D  3(Q) =
 OK
[   64.331983] raid6test: testing the 5-disk case...
[   64.505702] raid6test: test_disks(0, 1): faila=3D  0(D)  failb=3D  1(D) =
 OK
[   64.676888] raid6test: test_disks(0, 2): faila=3D  0(D)  failb=3D  2(D) =
 OK
[   64.850889] raid6test: test_disks(0, 3): faila=3D  0(D)  failb=3D  3(P) =
 OK
[   65.027941] raid6test: test_disks(0, 4): faila=3D  0(D)  failb=3D  4(Q) =
 OK
[   65.207521] raid6test: test_disks(1, 2): faila=3D  1(D)  failb=3D  2(D) =
 OK
[   65.390321] raid6test: test_disks(1, 3): faila=3D  1(D)  failb=3D  3(P) =
 OK
[   65.735156] raid6test: test_disks(1, 4): faila=3D  1(D)  failb=3D  4(Q) =
 OK
[   66.076493] raid6test: test_disks(2, 3): faila=3D  2(D)  failb=3D  3(P) =
 OK
[   66.391578] raid6test: test_disks(2, 4): faila=3D  2(D)  failb=3D  4(Q) =
 OK
[   66.574228] raid6test: test_disks(3, 4): faila=3D  3(P)  failb=3D  4(Q) =
 OK
[   66.756054] raid6test: testing the 11-disk case...
[   66.941152] raid6test: test_disks(0, 1): faila=3D  0(D)  failb=3D  1(D) =
 OK
[   67.132154] raid6test: test_disks(0, 2): faila=3D  0(D)  failb=3D  2(D) =
 OK
[   67.324005] raid6test: test_disks(0, 3): faila=3D  0(D)  failb=3D  3(D) =
 OK
[   67.515849] raid6test: test_disks(0, 4): faila=3D  0(D)  failb=3D  4(D) =
 OK
[   67.707036] raid6test: test_disks(0, 5): faila=3D  0(D)  failb=3D  5(D) =
 OK
[   67.899710] raid6test: test_disks(0, 6): faila=3D  0(D)  failb=3D  6(D) =
 OK
[   68.091051] raid6test: test_disks(0, 7): faila=3D  0(D)  failb=3D  7(D) =
 OK
[   68.288493] raid6test: test_disks(0, 8): faila=3D  0(D)  failb=3D  8(D) =
 OK
[   68.480748] raid6test: test_disks(0, 9): faila=3D  0(D)  failb=3D  9(P) =
 OK
[   68.669300] raid6test: test_disks(0, 10): faila=3D  0(D)  failb=3D 10(Q)=
  OK
[   68.855939] raid6test: test_disks(1, 2): faila=3D  1(D)  failb=3D  2(D) =
 OK
[   69.045005] raid6test: test_disks(1, 3): faila=3D  1(D)  failb=3D  3(D) =
 OK
[   69.233925] raid6test: test_disks(1, 4): faila=3D  1(D)  failb=3D  4(D) =
 OK
[   69.420738] raid6test: test_disks(1, 5): faila=3D  1(D)  failb=3D  5(D) =
 OK
[   69.605871] raid6test: test_disks(1, 6): faila=3D  1(D)  failb=3D  6(D) =
 OK
[   69.787932] raid6test: test_disks(1, 7): faila=3D  1(D)  failb=3D  7(D) =
 OK
[   69.965847] raid6test: test_disks(1, 8): faila=3D  1(D)  failb=3D  8(D) =
 OK
[   70.141801] raid6test: test_disks(1, 9): faila=3D  1(D)  failb=3D  9(P) =
 OK
[   70.317479] raid6test: test_disks(1, 10): faila=3D  1(D)  failb=3D 10(Q)=
  OK
[   70.494215] raid6test: test_disks(2, 3): faila=3D  2(D)  failb=3D  3(D) =
 OK
[   70.675995] raid6test: test_disks(2, 4): faila=3D  2(D)  failb=3D  4(D) =
 OK
[   70.856074] raid6test: test_disks(2, 5): faila=3D  2(D)  failb=3D  5(D) =
 OK
[   71.032459] raid6test: test_disks(2, 6): faila=3D  2(D)  failb=3D  6(D) =
 OK
[   71.205523] raid6test: test_disks(2, 7): faila=3D  2(D)  failb=3D  7(D) =
 OK
[   71.377082] raid6test: test_disks(2, 8): faila=3D  2(D)  failb=3D  8(D) =
 OK
[   71.548751] raid6test: test_disks(2, 9): faila=3D  2(D)  failb=3D  9(P) =
 OK
[   71.718131] raid6test: test_disks(2, 10): faila=3D  2(D)  failb=3D 10(Q)=
  OK
[   71.888935] raid6test: test_disks(3, 4): faila=3D  3(D)  failb=3D  4(D) =
 OK
[   72.067206] raid6test: test_disks(3, 5): faila=3D  3(D)  failb=3D  5(D) =
 OK
[   72.242691] raid6test: test_disks(3, 6): faila=3D  3(D)  failb=3D  6(D) =
 OK
[   72.413647] raid6test: test_disks(3, 7): faila=3D  3(D)  failb=3D  7(D) =
 OK
[   72.584254] raid6test: test_disks(3, 8): faila=3D  3(D)  failb=3D  8(D) =
 OK
[   72.753795] raid6test: test_disks(3, 9): faila=3D  3(D)  failb=3D  9(P) =
 OK
[   72.925275] raid6test: test_disks(3, 10): faila=3D  3(D)  failb=3D 10(Q)=
  OK
[   73.102927] raid6test: test_disks(4, 5): faila=3D  4(D)  failb=3D  5(D) =
 OK
[   73.285907] raid6test: test_disks(4, 6): faila=3D  4(D)  failb=3D  6(D) =
 OK
[   73.470554] raid6test: test_disks(4, 7): faila=3D  4(D)  failb=3D  7(D) =
 OK
[   73.651811] raid6test: test_disks(4, 8): faila=3D  4(D)  failb=3D  8(D) =
 OK
[   73.829912] raid6test: test_disks(4, 9): faila=3D  4(D)  failb=3D  9(P) =
 OK
[   74.007462] raid6test: test_disks(4, 10): faila=3D  4(D)  failb=3D 10(Q)=
  OK
[   74.184208] raid6test: test_disks(5, 6): faila=3D  5(D)  failb=3D  6(D) =
 OK
[   74.364833] raid6test: test_disks(5, 7): faila=3D  5(D)  failb=3D  7(D) =
 OK
[   74.546104] raid6test: test_disks(5, 8): faila=3D  5(D)  failb=3D  8(D) =
 OK
[   74.727687] raid6test: test_disks(5, 9): faila=3D  5(D)  failb=3D  9(P) =
 OK
[   74.910980] raid6test: test_disks(5, 10): faila=3D  5(D)  failb=3D 10(Q)=
  OK
[   75.099249] raid6test: test_disks(6, 7): faila=3D  6(D)  failb=3D  7(D) =
 OK
[   75.293686] raid6test: test_disks(6, 8): faila=3D  6(D)  failb=3D  8(D) =
 OK
[   75.487089] raid6test: test_disks(6, 9): faila=3D  6(D)  failb=3D  9(P) =
 OK
[   75.676681] raid6test: test_disks(6, 10): faila=3D  6(D)  failb=3D 10(Q)=
  OK
[   75.867134] raid6test: test_disks(7, 8): faila=3D  7(D)  failb=3D  8(D) =
 OK
[   76.062603] raid6test: test_disks(7, 9): faila=3D  7(D)  failb=3D  9(P) =
 OK
[   76.263115] raid6test: test_disks(7, 10): faila=3D  7(D)  failb=3D 10(Q)=
  OK
[   76.467471] raid6test: test_disks(8, 9): faila=3D  8(D)  failb=3D  9(P) =
 OK
[   76.679115] raid6test: test_disks(8, 10): faila=3D  8(D)  failb=3D 10(Q)=
  OK
[   76.895456] raid6test: test_disks(9, 10): faila=3D  9(P)  failb=3D 10(Q)=
  OK
[   77.111261] raid6test: testing the 12-disk case...
[   77.324660] raid6test: test_disks(0, 1): faila=3D  0(D)  failb=3D  1(D) =
 OK
[   77.534374] raid6test: test_disks(0, 2): faila=3D  0(D)  failb=3D  2(D) =
 OK
[   77.744758] raid6test: test_disks(0, 3): faila=3D  0(D)  failb=3D  3(D) =
 OK
[   77.956566] raid6test: test_disks(0, 4): faila=3D  0(D)  failb=3D  4(D) =
 OK
[   78.168050] raid6test: test_disks(0, 5): faila=3D  0(D)  failb=3D  5(D) =
 OK
[   78.379634] raid6test: test_disks(0, 6): faila=3D  0(D)  failb=3D  6(D) =
 OK
[   78.590173] raid6test: test_disks(0, 7): faila=3D  0(D)  failb=3D  7(D) =
 OK
[   78.796803] raid6test: test_disks(0, 8): faila=3D  0(D)  failb=3D  8(D) =
 OK
[   78.995824] raid6test: test_disks(0, 9): faila=3D  0(D)  failb=3D  9(D) =
 OK
[   79.197440] raid6test: test_disks(0, 10): faila=3D  0(D)  failb=3D 10(P)=
  OK
[   79.406341] raid6test: test_disks(0, 11): faila=3D  0(D)  failb=3D 11(Q)=
  OK
[   79.618079] raid6test: test_disks(1, 2): faila=3D  1(D)  failb=3D  2(D) =
 OK
[   79.832324] raid6test: test_disks(1, 3): faila=3D  1(D)  failb=3D  3(D) =
 OK
[   80.040956] raid6test: test_disks(1, 4): faila=3D  1(D)  failb=3D  4(D) =
 OK
[   80.246010] raid6test: test_disks(1, 5): faila=3D  1(D)  failb=3D  5(D) =
 OK
[   80.451116] raid6test: test_disks(1, 6): faila=3D  1(D)  failb=3D  6(D) =
 OK
[   80.657742] raid6test: test_disks(1, 7): faila=3D  1(D)  failb=3D  7(D) =
 OK
[   80.864167] raid6test: test_disks(1, 8): faila=3D  1(D)  failb=3D  8(D) =
 OK
[   81.065702] raid6test: test_disks(1, 9): faila=3D  1(D)  failb=3D  9(D) =
 OK
[   81.262461] raid6test: test_disks(1, 10): faila=3D  1(D)  failb=3D 10(P)=
  OK
[   81.465525] raid6test: test_disks(1, 11): faila=3D  1(D)  failb=3D 11(Q)=
  OK
[   81.665475] raid6test: test_disks(2, 3): faila=3D  2(D)  failb=3D  3(D) =
 OK
[   81.866822] raid6test: test_disks(2, 4): faila=3D  2(D)  failb=3D  4(D) =
 OK
[   82.067144] raid6test: test_disks(2, 5): faila=3D  2(D)  failb=3D  5(D) =
 OK
[   82.265530] raid6test: test_disks(2, 6): faila=3D  2(D)  failb=3D  6(D) =
 OK
[   82.467227] raid6test: test_disks(2, 7): faila=3D  2(D)  failb=3D  7(D) =
 OK
[   82.653121] raid6test: test_disks(2, 8): faila=3D  2(D)  failb=3D  8(D) =
 OK
[   82.866228] raid6test: test_disks(2, 9): faila=3D  2(D)  failb=3D  9(D) =
 OK
[   83.044523] raid6test: test_disks(2, 10): faila=3D  2(D)  failb=3D 10(P)=
  OK
[   83.303280] raid6test: test_disks(2, 11): faila=3D  2(D)  failb=3D 11(Q)=
  OK
[   83.617589] raid6test: test_disks(3, 4): faila=3D  3(D)  failb=3D  4(D) =
 OK
[   83.802775] raid6test: test_disks(3, 5): faila=3D  3(D)  failb=3D  5(D) =
 OK
[   83.989142] raid6test: test_disks(3, 6): faila=3D  3(D)  failb=3D  6(D) =
 OK
[   84.175651] raid6test: test_disks(3, 7): faila=3D  3(D)  failb=3D  7(D) =
 OK
[   84.361989] raid6test: test_disks(3, 8): faila=3D  3(D)  failb=3D  8(D) =
 OK
[   84.548212] raid6test: test_disks(3, 9): faila=3D  3(D)  failb=3D  9(D) =
 OK
[   84.734698] raid6test: test_disks(3, 10): faila=3D  3(D)  failb=3D 10(P)=
  OK
[   84.925345] raid6test: test_disks(3, 11): faila=3D  3(D)  failb=3D 11(Q)=
  OK
[   85.113841] raid6test: test_disks(4, 5): faila=3D  4(D)  failb=3D  5(D) =
 OK
[   85.304629] raid6test: test_disks(4, 6): faila=3D  4(D)  failb=3D  6(D) =
 OK
[   85.496472] raid6test: test_disks(4, 7): faila=3D  4(D)  failb=3D  7(D) =
 OK
[   85.682455] raid6test: test_disks(4, 8): faila=3D  4(D)  failb=3D  8(D) =
 OK
[   85.865545] raid6test: test_disks(4, 9): faila=3D  4(D)  failb=3D  9(D) =
 OK
[   86.071107] raid6test: test_disks(4, 10): faila=3D  4(D)  failb=3D 10(P)=
  OK
[   86.332849] raid6test: test_disks(4, 11): faila=3D  4(D)  failb=3D 11(Q)=
  OK
[   86.569868] raid6test: test_disks(5, 6): faila=3D  5(D)  failb=3D  6(D) =
 OK
[   86.760022] raid6test: test_disks(5, 7): faila=3D  5(D)  failb=3D  7(D) =
 OK
[   87.006346] raid6test: test_disks(5, 8): faila=3D  5(D)  failb=3D  8(D) =
 OK
[   87.306114] raid6test: test_disks(5, 9): faila=3D  5(D)  failb=3D  9(D) =
 OK
[   87.631120] raid6test: test_disks(5, 10): faila=3D  5(D)  failb=3D 10(P)=
  OK
[   87.866951] raid6test: test_disks(5, 11): faila=3D  5(D)  failb=3D 11(Q)=
  OK
[   88.073824] raid6test: test_disks(6, 7): faila=3D  6(D)  failb=3D  7(D) =
 OK
[   88.289211] raid6test: test_disks(6, 8): faila=3D  6(D)  failb=3D  8(D) =
 OK
[   88.486586] raid6test: test_disks(6, 9): faila=3D  6(D)  failb=3D  9(D) =
 OK
[   88.743549] raid6test: test_disks(6, 10): faila=3D  6(D)  failb=3D 10(P)=
  OK
[   88.994937] raid6test: test_disks(6, 11): faila=3D  6(D)  failb=3D 11(Q)=
  OK
[   89.189887] raid6test: test_disks(7, 8): faila=3D  7(D)  failb=3D  8(D) =
 OK
[   89.451964] raid6test: test_disks(7, 9): faila=3D  7(D)  failb=3D  9(D) =
 OK
[   89.758327] raid6test: test_disks(7, 10): faila=3D  7(D)  failb=3D 10(P)=
  OK
[   89.981598] raid6test: test_disks(7, 11): faila=3D  7(D)  failb=3D 11(Q)=
  OK
[   90.237099] raid6test: test_disks(8, 9): faila=3D  8(D)  failb=3D  9(D) =
 OK
[   90.435565] raid6test: test_disks(8, 10): faila=3D  8(D)  failb=3D 10(P)=
  OK
[   90.641388] raid6test: test_disks(8, 11): faila=3D  8(D)  failb=3D 11(Q)=
  OK
[   90.847626] raid6test: test_disks(9, 10): faila=3D  9(D)  failb=3D 10(P)=
  OK
[   91.055049] raid6test: test_disks(9, 11): faila=3D  9(D)  failb=3D 11(Q)=
  OK
[   91.265081] raid6test: test_disks(10, 11): faila=3D 10(P)  failb=3D 11(Q=
)  OK
[   91.478065] raid6test: testing the 24-disk case...
[   91.696911] raid6test: test_disks(0, 1): faila=3D  0(D)  failb=3D  1(D) =
 OK
[   91.912741] raid6test: test_disks(0, 2): faila=3D  0(D)  failb=3D  2(D) =
 OK
[   92.136136] raid6test: test_disks(0, 3): faila=3D  0(D)  failb=3D  3(D) =
 OK
[   92.369071] raid6test: test_disks(0, 4): faila=3D  0(D)  failb=3D  4(D) =
 OK
[   92.637635] raid6test: test_disks(0, 5): faila=3D  0(D)  failb=3D  5(D) =
 OK
[   92.948125] raid6test: test_disks(0, 6): faila=3D  0(D)  failb=3D  6(D) =
 OK
[   93.172703] raid6test: test_disks(0, 7): faila=3D  0(D)  failb=3D  7(D) =
 OK
[   93.377951] raid6test: test_disks(0, 8): faila=3D  0(D)  failb=3D  8(D) =
 OK
[   93.578274] raid6test: test_disks(0, 9): faila=3D  0(D)  failb=3D  9(D) =
 OK
[   93.777930] raid6test: test_disks(0, 10): faila=3D  0(D)  failb=3D 10(D)=
  OK
[   94.011898] raid6test: test_disks(0, 11): faila=3D  0(D)  failb=3D 11(D)=
  OK
[   94.221297] raid6test: test_disks(0, 12): faila=3D  0(D)  failb=3D 12(D)=
  OK
[   94.422749] raid6test: test_disks(0, 13): faila=3D  0(D)  failb=3D 13(D)=
  OK
[   94.624807] raid6test: test_disks(0, 14): faila=3D  0(D)  failb=3D 14(D)=
  OK
[   94.820510] raid6test: test_disks(0, 15): faila=3D  0(D)  failb=3D 15(D)=
  OK
[   95.017843] raid6test: test_disks(0, 16): faila=3D  0(D)  failb=3D 16(D)=
  OK
[   95.217483] raid6test: test_disks(0, 17): faila=3D  0(D)  failb=3D 17(D)=
  OK
[   95.385540] raid6test: test_disks(0, 18): faila=3D  0(D)  failb=3D 18(D)=
  OK
[   95.566979] raid6test: test_disks(0, 19): faila=3D  0(D)  failb=3D 19(D)=
  OK
[   95.755892] raid6test: test_disks(0, 20): faila=3D  0(D)  failb=3D 20(D)=
  OK
[   95.944139] raid6test: test_disks(0, 21): faila=3D  0(D)  failb=3D 21(D)=
  OK
[   96.113346] raid6test: test_disks(0, 22): faila=3D  0(D)  failb=3D 22(P)=
  OK
[   96.296431] raid6test: test_disks(0, 23): faila=3D  0(D)  failb=3D 23(Q)=
  OK
[   96.472221] raid6test: test_disks(1, 2): faila=3D  1(D)  failb=3D  2(D) =
 OK
[   96.649522] raid6test: test_disks(1, 3): faila=3D  1(D)  failb=3D  3(D) =
 OK
[   96.824603] raid6test: test_disks(1, 4): faila=3D  1(D)  failb=3D  4(D) =
 OK
[   96.995482] raid6test: test_disks(1, 5): faila=3D  1(D)  failb=3D  5(D) =
 OK
[   97.163465] raid6test: test_disks(1, 6): faila=3D  1(D)  failb=3D  6(D) =
 OK
[   97.332321] raid6test: test_disks(1, 7): faila=3D  1(D)  failb=3D  7(D) =
 OK
[   97.488548] raid6test: test_disks(1, 8): faila=3D  1(D)  failb=3D  8(D) =
 OK
[   97.641914] raid6test: test_disks(1, 9): faila=3D  1(D)  failb=3D  9(D) =
 OK
[   97.795720] raid6test: test_disks(1, 10): faila=3D  1(D)  failb=3D 10(D)=
  OK
[   97.953645] raid6test: test_disks(1, 11): faila=3D  1(D)  failb=3D 11(D)=
  OK
[   98.111213] raid6test: test_disks(1, 12): faila=3D  1(D)  failb=3D 12(D)=
  OK
[   98.268219] raid6test: test_disks(1, 13): faila=3D  1(D)  failb=3D 13(D)=
  OK
[   98.429705] raid6test: test_disks(1, 14): faila=3D  1(D)  failb=3D 14(D)=
  OK
[   98.589217] raid6test: test_disks(1, 15): faila=3D  1(D)  failb=3D 15(D)=
  OK
[   98.748939] raid6test: test_disks(1, 16): faila=3D  1(D)  failb=3D 16(D)=
  OK
[   98.905335] raid6test: test_disks(1, 17): faila=3D  1(D)  failb=3D 17(D)=
  OK
[   99.058926] raid6test: test_disks(1, 18): faila=3D  1(D)  failb=3D 18(D)=
  OK
[   99.214886] raid6test: test_disks(1, 19): faila=3D  1(D)  failb=3D 19(D)=
  OK
[   99.367081] raid6test: test_disks(1, 20): faila=3D  1(D)  failb=3D 20(D)=
  OK
[   99.519325] raid6test: test_disks(1, 21): faila=3D  1(D)  failb=3D 21(D)=
  OK
[   99.668221] raid6test: test_disks(1, 22): faila=3D  1(D)  failb=3D 22(P)=
  OK
[   99.818495] raid6test: test_disks(1, 23): faila=3D  1(D)  failb=3D 23(Q)=
  OK
[   99.970015] raid6test: test_disks(2, 3): faila=3D  2(D)  failb=3D  3(D) =
 OK
[  100.124737] raid6test: test_disks(2, 4): faila=3D  2(D)  failb=3D  4(D) =
 OK
[  100.280630] raid6test: test_disks(2, 5): faila=3D  2(D)  failb=3D  5(D) =
 OK
[  100.439283] raid6test: test_disks(2, 6): faila=3D  2(D)  failb=3D  6(D) =
 OK
[  100.598241] raid6test: test_disks(2, 7): faila=3D  2(D)  failb=3D  7(D) =
 OK
[  100.759548] raid6test: test_disks(2, 8): faila=3D  2(D)  failb=3D  8(D) =
 OK
[  100.917731] raid6test: test_disks(2, 9): faila=3D  2(D)  failb=3D  9(D) =
 OK
[  101.074503] raid6test: test_disks(2, 10): faila=3D  2(D)  failb=3D 10(D)=
  OK
[  101.232100] raid6test: test_disks(2, 11): faila=3D  2(D)  failb=3D 11(D)=
  OK
[  101.389628] raid6test: test_disks(2, 12): faila=3D  2(D)  failb=3D 12(D)=
  OK
[  101.547472] raid6test: test_disks(2, 13): faila=3D  2(D)  failb=3D 13(D)=
  OK
[  101.705982] raid6test: test_disks(2, 14): faila=3D  2(D)  failb=3D 14(D)=
  OK
[  101.860765] raid6test: test_disks(2, 15): faila=3D  2(D)  failb=3D 15(D)=
  OK
[  102.016537] raid6test: test_disks(2, 16): faila=3D  2(D)  failb=3D 16(D)=
  OK
[  102.173530] raid6test: test_disks(2, 17): faila=3D  2(D)  failb=3D 17(D)=
  OK
[  102.331625] raid6test: test_disks(2, 18): faila=3D  2(D)  failb=3D 18(D)=
  OK
[  102.488336] raid6test: test_disks(2, 19): faila=3D  2(D)  failb=3D 19(D)=
  OK
[  102.642534] raid6test: test_disks(2, 20): faila=3D  2(D)  failb=3D 20(D)=
  OK
[  102.796343] raid6test: test_disks(2, 21): faila=3D  2(D)  failb=3D 21(D)=
  OK
[  102.948947] raid6test: test_disks(2, 22): faila=3D  2(D)  failb=3D 22(P)=
  OK
[  103.104231] raid6test: test_disks(2, 23): faila=3D  2(D)  failb=3D 23(Q)=
  OK
[  103.261600] raid6test: test_disks(3, 4): faila=3D  3(D)  failb=3D  4(D) =
 OK
[  103.423398] raid6test: test_disks(3, 5): faila=3D  3(D)  failb=3D  5(D) =
 OK
[  103.583871] raid6test: test_disks(3, 6): faila=3D  3(D)  failb=3D  6(D) =
 OK
[  103.743384] raid6test: test_disks(3, 7): faila=3D  3(D)  failb=3D  7(D) =
 OK
[  103.903895] raid6test: test_disks(3, 8): faila=3D  3(D)  failb=3D  8(D) =
 OK
[  104.065887] raid6test: test_disks(3, 9): faila=3D  3(D)  failb=3D  9(D) =
 OK
[  104.229737] raid6test: test_disks(3, 10): faila=3D  3(D)  failb=3D 10(D)=
  OK
[  104.396593] raid6test: test_disks(3, 11): faila=3D  3(D)  failb=3D 11(D)=
  OK
[  104.559759] raid6test: test_disks(3, 12): faila=3D  3(D)  failb=3D 12(D)=
  OK
[  104.716262] raid6test: test_disks(3, 13): faila=3D  3(D)  failb=3D 13(D)=
  OK
[  104.870883] raid6test: test_disks(3, 14): faila=3D  3(D)  failb=3D 14(D)=
  OK
[  105.026702] raid6test: test_disks(3, 15): faila=3D  3(D)  failb=3D 15(D)=
  OK
[  105.182839] raid6test: test_disks(3, 16): faila=3D  3(D)  failb=3D 16(D)=
  OK
[  105.336653] raid6test: test_disks(3, 17): faila=3D  3(D)  failb=3D 17(D)=
  OK
[  105.490698] raid6test: test_disks(3, 18): faila=3D  3(D)  failb=3D 18(D)=
  OK
[  105.646392] raid6test: test_disks(3, 19): faila=3D  3(D)  failb=3D 19(D)=
  OK
[  105.875287] raid6test: test_disks(3, 20): faila=3D  3(D)  failb=3D 20(D)=
  OK
[  106.156495] raid6test: test_disks(3, 21): faila=3D  3(D)  failb=3D 21(D)=
  OK
[  106.344115] raid6test: test_disks(3, 22): faila=3D  3(D)  failb=3D 22(P)=
  OK
[  106.496452] raid6test: test_disks(3, 23): faila=3D  3(D)  failb=3D 23(Q)=
  OK
[  106.650224] raid6test: test_disks(4, 5): faila=3D  4(D)  failb=3D  5(D) =
 OK
[  106.809182] raid6test: test_disks(4, 6): faila=3D  4(D)  failb=3D  6(D) =
 OK
[  106.967057] raid6test: test_disks(4, 7): faila=3D  4(D)  failb=3D  7(D) =
 OK
[  107.123959] raid6test: test_disks(4, 8): faila=3D  4(D)  failb=3D  8(D) =
 OK
[  107.283140] raid6test: test_disks(4, 9): faila=3D  4(D)  failb=3D  9(D) =
 OK
[  107.443481] raid6test: test_disks(4, 10): faila=3D  4(D)  failb=3D 10(D)=
  OK
[  107.609180] raid6test: test_disks(4, 11): faila=3D  4(D)  failb=3D 11(D)=
  OK
[  107.776373] raid6test: test_disks(4, 12): faila=3D  4(D)  failb=3D 12(D)=
  OK
[  107.940208] raid6test: test_disks(4, 13): faila=3D  4(D)  failb=3D 13(D)=
  OK
[  108.101332] raid6test: test_disks(4, 14): faila=3D  4(D)  failb=3D 14(D)=
  OK
[  108.257205] raid6test: test_disks(4, 15): faila=3D  4(D)  failb=3D 15(D)=
  OK
[  108.415057] raid6test: test_disks(4, 16): faila=3D  4(D)  failb=3D 16(D)=
  OK
[  108.568770] raid6test: test_disks(4, 17): faila=3D  4(D)  failb=3D 17(D)=
  OK
[  108.720206] raid6test: test_disks(4, 18): faila=3D  4(D)  failb=3D 18(D)=
  OK
[  109.011141] raid6test: test_disks(4, 19): faila=3D  4(D)  failb=3D 19(D)=
  OK
[  109.313685] raid6test: test_disks(4, 20): faila=3D  4(D)  failb=3D 20(D)=
  OK
[  109.485202] raid6test: test_disks(4, 21): faila=3D  4(D)  failb=3D 21(D)=
  OK
[  109.766756] raid6test: test_disks(4, 22): faila=3D  4(D)  failb=3D 22(P)=
  OK
[  109.916229] raid6test: test_disks(4, 23): faila=3D  4(D)  failb=3D 23(Q)=
  OK
[  110.107520] raid6test: test_disks(5, 6): faila=3D  5(D)  failb=3D  6(D) =
 OK
[  110.256646] raid6test: test_disks(5, 7): faila=3D  5(D)  failb=3D  7(D) =
 OK
[  110.400503] raid6test: test_disks(5, 8): faila=3D  5(D)  failb=3D  8(D) =
 OK
[  110.552234] raid6test: test_disks(5, 9): faila=3D  5(D)  failb=3D  9(D) =
 OK
[  110.710622] raid6test: test_disks(5, 10): faila=3D  5(D)  failb=3D 10(D)=
  OK
[  110.872391] raid6test: test_disks(5, 11): faila=3D  5(D)  failb=3D 11(D)=
  OK
[  111.036576] raid6test: test_disks(5, 12): faila=3D  5(D)  failb=3D 12(D)=
  OK
[  111.210572] raid6test: test_disks(5, 13): faila=3D  5(D)  failb=3D 13(D)=
  OK
[  111.521056] raid6test: test_disks(5, 14): faila=3D  5(D)  failb=3D 14(D)=
  OK
[  111.834448] raid6test: test_disks(5, 15): faila=3D  5(D)  failb=3D 15(D)=
  OK
[  112.028687] raid6test: test_disks(5, 16): faila=3D  5(D)  failb=3D 16(D)=
  OK
[  112.348543] raid6test: test_disks(5, 17): faila=3D  5(D)  failb=3D 17(D)=
  OK
[  112.529325] raid6test: test_disks(5, 18): faila=3D  5(D)  failb=3D 18(D)=
  OK
[  112.688392] raid6test: test_disks(5, 19): faila=3D  5(D)  failb=3D 19(D)=
  OK
[  112.957923] raid6test: test_disks(5, 20): faila=3D  5(D)  failb=3D 20(D)=
  OK
[  113.117033] raid6test: test_disks(5, 21): faila=3D  5(D)  failb=3D 21(D)=
  OK
[  113.268435] raid6test: test_disks(5, 22): faila=3D  5(D)  failb=3D 22(P)=
  OK
[  113.421293] raid6test: test_disks(5, 23): faila=3D  5(D)  failb=3D 23(Q)=
  OK
[  113.575515] raid6test: test_disks(6, 7): faila=3D  6(D)  failb=3D  7(D) =
 OK
[  113.765436] raid6test: test_disks(6, 8): faila=3D  6(D)  failb=3D  8(D) =
 OK
[  113.958029] raid6test: test_disks(6, 9): faila=3D  6(D)  failb=3D  9(D) =
 OK
[  114.122026] raid6test: test_disks(6, 10): faila=3D  6(D)  failb=3D 10(D)=
  OK
[  114.300242] raid6test: test_disks(6, 11): faila=3D  6(D)  failb=3D 11(D)=
  OK
[  114.468090] raid6test: test_disks(6, 12): faila=3D  6(D)  failb=3D 12(D)=
  OK
[  114.645568] raid6test: test_disks(6, 13): faila=3D  6(D)  failb=3D 13(D)=
  OK
[  114.840304] raid6test: test_disks(6, 14): faila=3D  6(D)  failb=3D 14(D)=
  OK
[  115.010249] raid6test: test_disks(6, 15): faila=3D  6(D)  failb=3D 15(D)=
  OK
[  115.181486] raid6test: test_disks(6, 16): faila=3D  6(D)  failb=3D 16(D)=
  OK
[  115.352520] raid6test: test_disks(6, 17): faila=3D  6(D)  failb=3D 17(D)=
  OK
[  115.521176] raid6test: test_disks(6, 18): faila=3D  6(D)  failb=3D 18(D)=
  OK
[  115.681765] raid6test: test_disks(6, 19): faila=3D  6(D)  failb=3D 19(D)=
  OK
[  115.843269] raid6test: test_disks(6, 20): faila=3D  6(D)  failb=3D 20(D)=
  OK
[  116.006873] raid6test: test_disks(6, 21): faila=3D  6(D)  failb=3D 21(D)=
  OK
[  116.179735] raid6test: test_disks(6, 22): faila=3D  6(D)  failb=3D 22(P)=
  OK
[  116.345391] raid6test: test_disks(6, 23): faila=3D  6(D)  failb=3D 23(Q)=
  OK
[  116.506682] raid6test: test_disks(7, 8): faila=3D  7(D)  failb=3D  8(D) =
 OK
[  116.672294] raid6test: test_disks(7, 9): faila=3D  7(D)  failb=3D  9(D) =
 OK
[  116.837371] raid6test: test_disks(7, 10): faila=3D  7(D)  failb=3D 10(D)=
  OK
[  117.010417] raid6test: test_disks(7, 11): faila=3D  7(D)  failb=3D 11(D)=
  OK
[  117.182107] raid6test: test_disks(7, 12): faila=3D  7(D)  failb=3D 12(D)=
  OK
[  117.351508] raid6test: test_disks(7, 13): faila=3D  7(D)  failb=3D 13(D)=
  OK
[  117.521331] raid6test: test_disks(7, 14): faila=3D  7(D)  failb=3D 14(D)=
  OK
[  117.697413] raid6test: test_disks(7, 15): faila=3D  7(D)  failb=3D 15(D)=
  OK
[  117.871076] raid6test: test_disks(7, 16): faila=3D  7(D)  failb=3D 16(D)=
  OK
[  118.040781] raid6test: test_disks(7, 17): faila=3D  7(D)  failb=3D 17(D)=
  OK
[  118.208608] raid6test: test_disks(7, 18): faila=3D  7(D)  failb=3D 18(D)=
  OK
[  118.375184] raid6test: test_disks(7, 19): faila=3D  7(D)  failb=3D 19(D)=
  OK
[  118.539614] raid6test: test_disks(7, 20): faila=3D  7(D)  failb=3D 20(D)=
  OK
[  118.698668] raid6test: test_disks(7, 21): faila=3D  7(D)  failb=3D 21(D)=
  OK
[  118.857198] raid6test: test_disks(7, 22): faila=3D  7(D)  failb=3D 22(P)=
  OK
[  119.017201] raid6test: test_disks(7, 23): faila=3D  7(D)  failb=3D 23(Q)=
  OK
[  119.173475] raid6test: test_disks(8, 9): faila=3D  8(D)  failb=3D  9(D) =
 OK
[  119.336105] raid6test: test_disks(8, 10): faila=3D  8(D)  failb=3D 10(D)=
  OK
[  119.505742] raid6test: test_disks(8, 11): faila=3D  8(D)  failb=3D 11(D)=
  OK
[  119.675699] raid6test: test_disks(8, 12): faila=3D  8(D)  failb=3D 12(D)=
  OK
[  119.842981] raid6test: test_disks(8, 13): faila=3D  8(D)  failb=3D 13(D)=
  OK
[  120.007696] raid6test: test_disks(8, 14): faila=3D  8(D)  failb=3D 14(D)=
  OK
[  120.174692] raid6test: test_disks(8, 15): faila=3D  8(D)  failb=3D 15(D)=
  OK
[  120.341910] raid6test: test_disks(8, 16): faila=3D  8(D)  failb=3D 16(D)=
  OK
[  120.509667] raid6test: test_disks(8, 17): faila=3D  8(D)  failb=3D 17(D)=
  OK
[  120.675998] raid6test: test_disks(8, 18): faila=3D  8(D)  failb=3D 18(D)=
  OK
[  120.841229] raid6test: test_disks(8, 19): faila=3D  8(D)  failb=3D 19(D)=
  OK
[  121.004012] raid6test: test_disks(8, 20): faila=3D  8(D)  failb=3D 20(D)=
  OK
[  121.168962] raid6test: test_disks(8, 21): faila=3D  8(D)  failb=3D 21(D)=
  OK
[  121.337642] raid6test: test_disks(8, 22): faila=3D  8(D)  failb=3D 22(P)=
  OK
[  121.494620] raid6test: test_disks(8, 23): faila=3D  8(D)  failb=3D 23(Q)=
  OK
[  121.652570] raid6test: test_disks(9, 10): faila=3D  9(D)  failb=3D 10(D)=
  OK
[  121.810674] raid6test: test_disks(9, 11): faila=3D  9(D)  failb=3D 11(D)=
  OK
[  121.968522] raid6test: test_disks(9, 12): faila=3D  9(D)  failb=3D 12(D)=
  OK
[  122.126670] raid6test: test_disks(9, 13): faila=3D  9(D)  failb=3D 13(D)=
  OK
[  122.284652] raid6test: test_disks(9, 14): faila=3D  9(D)  failb=3D 14(D)=
  OK
[  122.442659] raid6test: test_disks(9, 15): faila=3D  9(D)  failb=3D 15(D)=
  OK
[  122.602944] raid6test: test_disks(9, 16): faila=3D  9(D)  failb=3D 16(D)=
  OK
[  122.764462] raid6test: test_disks(9, 17): faila=3D  9(D)  failb=3D 17(D)=
  OK
[  122.928475] raid6test: test_disks(9, 18): faila=3D  9(D)  failb=3D 18(D)=
  OK
[  123.088958] raid6test: test_disks(9, 19): faila=3D  9(D)  failb=3D 19(D)=
  OK
[  123.262649] raid6test: test_disks(9, 20): faila=3D  9(D)  failb=3D 20(D)=
  OK
[  123.433861] raid6test: test_disks(9, 21): faila=3D  9(D)  failb=3D 21(D)=
  OK
[  123.597825] raid6test: test_disks(9, 22): faila=3D  9(D)  failb=3D 22(P)=
  OK
[  123.763134] raid6test: test_disks(9, 23): faila=3D  9(D)  failb=3D 23(Q)=
  OK
[  123.923910] raid6test: test_disks(10, 11): faila=3D 10(D)  failb=3D 11(D=
)  OK
[  124.081876] raid6test: test_disks(10, 12): faila=3D 10(D)  failb=3D 12(D=
)  OK
[  124.238228] raid6test: test_disks(10, 13): faila=3D 10(D)  failb=3D 13(D=
)  OK
[  124.394681] raid6test: test_disks(10, 14): faila=3D 10(D)  failb=3D 14(D=
)  OK
[  124.549733] raid6test: test_disks(10, 15): faila=3D 10(D)  failb=3D 15(D=
)  OK
[  124.709910] raid6test: test_disks(10, 16): faila=3D 10(D)  failb=3D 16(D=
)  OK
[  124.863865] raid6test: test_disks(10, 17): faila=3D 10(D)  failb=3D 17(D=
)  OK
[  125.017662] raid6test: test_disks(10, 18): faila=3D 10(D)  failb=3D 18(D=
)  OK
[  125.174188] raid6test: test_disks(10, 19): faila=3D 10(D)  failb=3D 19(D=
)  OK
[  125.367247] raid6test: test_disks(10, 20): faila=3D 10(D)  failb=3D 20(D=
)  OK
[  125.642360] raid6test: test_disks(10, 21): faila=3D 10(D)  failb=3D 21(D=
)  OK
[  125.879638] raid6test: test_disks(10, 22): faila=3D 10(D)  failb=3D 22(P=
)  OK
[  126.160441] raid6test: test_disks(10, 23): faila=3D 10(D)  failb=3D 23(Q=
)  OK
[  126.321053] raid6test: test_disks(11, 12): faila=3D 11(D)  failb=3D 12(D=
)  OK
[  126.487118] raid6test: test_disks(11, 13): faila=3D 11(D)  failb=3D 13(D=
)  OK
[  126.718737] raid6test: test_disks(11, 14): faila=3D 11(D)  failb=3D 14(D=
)  OK
[  126.932798] raid6test: test_disks(11, 15): faila=3D 11(D)  failb=3D 15(D=
)  OK
[  127.143901] raid6test: test_disks(11, 16): faila=3D 11(D)  failb=3D 16(D=
)  OK
[  127.341910] raid6test: test_disks(11, 17): faila=3D 11(D)  failb=3D 17(D=
)  OK
[  127.539793] raid6test: test_disks(11, 18): faila=3D 11(D)  failb=3D 18(D=
)  OK
[  127.698196] raid6test: test_disks(11, 19): faila=3D 11(D)  failb=3D 19(D=
)  OK
[  127.862792] raid6test: test_disks(11, 20): faila=3D 11(D)  failb=3D 20(D=
)  OK
[  128.035471] raid6test: test_disks(11, 21): faila=3D 11(D)  failb=3D 21(D=
)  OK
[  128.201924] raid6test: test_disks(11, 22): faila=3D 11(D)  failb=3D 22(P=
)  OK
[  128.416587] raid6test: test_disks(11, 23): faila=3D 11(D)  failb=3D 23(Q=
)  OK
[  128.699936] raid6test: test_disks(12, 13): faila=3D 12(D)  failb=3D 13(D=
)  OK
[  128.869986] raid6test: test_disks(12, 14): faila=3D 12(D)  failb=3D 14(D=
)  OK
[  129.099666] raid6test: test_disks(12, 15): faila=3D 12(D)  failb=3D 15(D=
)  OK
[  129.390349] raid6test: test_disks(12, 16): faila=3D 12(D)  failb=3D 16(D=
)  OK
[  129.748244] raid6test: test_disks(12, 17): faila=3D 12(D)  failb=3D 17(D=
)  OK
[  130.059973] raid6test: test_disks(12, 18): faila=3D 12(D)  failb=3D 18(D=
)  OK
[  130.272439] raid6test: test_disks(12, 19): faila=3D 12(D)  failb=3D 19(D=
)  OK
[  130.477865] raid6test: test_disks(12, 20): faila=3D 12(D)  failb=3D 20(D=
)  OK
[  130.798512] raid6test: test_disks(12, 21): faila=3D 12(D)  failb=3D 21(D=
)  OK
[  131.072891] raid6test: test_disks(12, 22): faila=3D 12(D)  failb=3D 22(P=
)  OK
[  131.389585] raid6test: test_disks(12, 23): faila=3D 12(D)  failb=3D 23(Q=
)  OK
[  131.628510] raid6test: test_disks(13, 14): faila=3D 13(D)  failb=3D 14(D=
)  OK
[  131.920925] raid6test: test_disks(13, 15): faila=3D 13(D)  failb=3D 15(D=
)  OK
[  132.148320] raid6test: test_disks(13, 16): faila=3D 13(D)  failb=3D 16(D=
)  OK
[  132.450122] raid6test: test_disks(13, 17): faila=3D 13(D)  failb=3D 17(D=
)  OK
[  132.680230] raid6test: test_disks(13, 18): faila=3D 13(D)  failb=3D 18(D=
)  OK
[  132.885800] raid6test: test_disks(13, 19): faila=3D 13(D)  failb=3D 19(D=
)  OK
[  133.166824] raid6test: test_disks(13, 20): faila=3D 13(D)  failb=3D 20(D=
)  OK
[  133.372770] raid6test: test_disks(13, 21): faila=3D 13(D)  failb=3D 21(D=
)  OK
[  133.691877] raid6test: test_disks(13, 22): faila=3D 13(D)  failb=3D 22(P=
)  OK
[  133.952051] raid6test: test_disks(13, 23): faila=3D 13(D)  failb=3D 23(Q=
)  OK
[  134.210684] raid6test: test_disks(14, 15): faila=3D 14(D)  failb=3D 15(D=
)  OK
[  134.475899] raid6test: test_disks(14, 16): faila=3D 14(D)  failb=3D 16(D=
)  OK
[  134.650506] raid6test: test_disks(14, 17): faila=3D 14(D)  failb=3D 17(D=
)  OK
[  134.902073] raid6test: test_disks(14, 18): faila=3D 14(D)  failb=3D 18(D=
)  OK
[  135.183991] raid6test: test_disks(14, 19): faila=3D 14(D)  failb=3D 19(D=
)  OK
[  135.446891] raid6test: test_disks(14, 20): faila=3D 14(D)  failb=3D 20(D=
)  OK
[  135.673668] raid6test: test_disks(14, 21): faila=3D 14(D)  failb=3D 21(D=
)  OK
[  135.901502] raid6test: test_disks(14, 22): faila=3D 14(D)  failb=3D 22(P=
)  OK
[  136.064640] raid6test: test_disks(14, 23): faila=3D 14(D)  failb=3D 23(Q=
)  OK
[  136.301023] raid6test: test_disks(15, 16): faila=3D 15(D)  failb=3D 16(D=
)  OK
[  136.585637] raid6test: test_disks(15, 17): faila=3D 15(D)  failb=3D 17(D=
)  OK
[  136.763902] raid6test: test_disks(15, 18): faila=3D 15(D)  failb=3D 18(D=
)  OK
[  136.943804] raid6test: test_disks(15, 19): faila=3D 15(D)  failb=3D 19(D=
)  OK
[  137.154023] raid6test: test_disks(15, 20): faila=3D 15(D)  failb=3D 20(D=
)  OK
[  137.472330] raid6test: test_disks(15, 21): faila=3D 15(D)  failb=3D 21(D=
)  OK
[  137.699304] raid6test: test_disks(15, 22): faila=3D 15(D)  failb=3D 22(P=
)  OK
[  137.876785] raid6test: test_disks(15, 23): faila=3D 15(D)  failb=3D 23(Q=
)  OK
[  138.047134] raid6test: test_disks(16, 17): faila=3D 16(D)  failb=3D 17(D=
)  OK
[  138.393651] raid6test: test_disks(16, 18): faila=3D 16(D)  failb=3D 18(D=
)  OK
[  138.711570] raid6test: test_disks(16, 19): faila=3D 16(D)  failb=3D 19(D=
)  OK
[  138.892291] raid6test: test_disks(16, 20): faila=3D 16(D)  failb=3D 20(D=
)  OK
[  139.110328] raid6test: test_disks(16, 21): faila=3D 16(D)  failb=3D 21(D=
)  OK
[  139.463223] raid6test: test_disks(16, 22): faila=3D 16(D)  failb=3D 22(P=
)  OK
[  139.719145] raid6test: test_disks(16, 23): faila=3D 16(D)  failb=3D 23(Q=
)  OK
[  139.923705] raid6test: test_disks(17, 18): faila=3D 17(D)  failb=3D 18(D=
)  OK
[  140.250067] raid6test: test_disks(17, 19): faila=3D 17(D)  failb=3D 19(D=
)  OK
[  140.498288] raid6test: test_disks(17, 20): faila=3D 17(D)  failb=3D 20(D=
)  OK
[  140.836592] raid6test: test_disks(17, 21): faila=3D 17(D)  failb=3D 21(D=
)  OK
[  141.062930] raid6test: test_disks(17, 22): faila=3D 17(D)  failb=3D 22(P=
)  OK
[  141.382147] raid6test: test_disks(17, 23): faila=3D 17(D)  failb=3D 23(Q=
)  OK
[  141.608180] raid6test: test_disks(18, 19): faila=3D 18(D)  failb=3D 19(D=
)  OK
[  141.936806] raid6test: test_disks(18, 20): faila=3D 18(D)  failb=3D 20(D=
)  OK
[  142.271410] raid6test: test_disks(18, 21): faila=3D 18(D)  failb=3D 21(D=
)  OK
[  142.525286] raid6test: test_disks(18, 22): faila=3D 18(D)  failb=3D 22(P=
)  OK
[  142.850910] raid6test: test_disks(18, 23): faila=3D 18(D)  failb=3D 23(Q=
)  OK
[  143.153933] raid6test: test_disks(19, 20): faila=3D 19(D)  failb=3D 20(D=
)  OK
[  143.364741] raid6test: test_disks(19, 21): faila=3D 19(D)  failb=3D 21(D=
)  OK
[  143.766235] raid6test: test_disks(19, 22): faila=3D 19(D)  failb=3D 22(P=
)  OK
[  144.120442] raid6test: test_disks(19, 23): faila=3D 19(D)  failb=3D 23(Q=
)  OK
[  144.459394] raid6test: test_disks(20, 21): faila=3D 20(D)  failb=3D 21(D=
)  OK
[  144.703862] raid6test: test_disks(20, 22): faila=3D 20(D)  failb=3D 22(P=
)  OK
[  144.931918] raid6test: test_disks(20, 23): faila=3D 20(D)  failb=3D 23(Q=
)  OK
[  145.197152] raid6test: test_disks(21, 22): faila=3D 21(D)  failb=3D 22(P=
)  OK
[  145.485882] raid6test: test_disks(21, 23): faila=3D 21(D)  failb=3D 23(Q=
)  OK
[  145.831756] raid6test: test_disks(22, 23): faila=3D 22(P)  failb=3D 23(Q=
)  OK
[  146.125472] raid6test: testing the 64-disk case...
[  146.442603] raid6test: test_disks(0, 1): faila=3D  0(D)  failb=3D  1(D) =
 OK
[  146.823823] raid6test: test_disks(0, 2): faila=3D  0(D)  failb=3D  2(D) =
 OK
[  147.190853] raid6test: test_disks(0, 3): faila=3D  0(D)  failb=3D  3(D) =
 OK
[  147.576679] raid6test: test_disks(0, 4): faila=3D  0(D)  failb=3D  4(D) =
 OK
[  147.853310] raid6test: test_disks(0, 5): faila=3D  0(D)  failb=3D  5(D) =
 OK
[  148.155591] raid6test: test_disks(0, 6): faila=3D  0(D)  failb=3D  6(D) =
 OK
[  148.495830] raid6test: test_disks(0, 7): faila=3D  0(D)  failb=3D  7(D) =
 OK
[  148.858251] raid6test: test_disks(0, 8): faila=3D  0(D)  failb=3D  8(D) =
 OK
[  149.101893] raid6test: test_disks(0, 9): faila=3D  0(D)  failb=3D  9(D) =
 OK
[  149.434975] raid6test: test_disks(0, 10): faila=3D  0(D)  failb=3D 10(D)=
  OK
[  149.694255] raid6test: test_disks(0, 11): faila=3D  0(D)  failb=3D 11(D)=
  OK
[  150.007836] raid6test: test_disks(0, 12): faila=3D  0(D)  failb=3D 12(D)=
  OK
[  150.303158] raid6test: test_disks(0, 13): faila=3D  0(D)  failb=3D 13(D)=
  OK
[  150.572200] raid6test: test_disks(0, 14): faila=3D  0(D)  failb=3D 14(D)=
  OK
[  150.933493] raid6test: test_disks(0, 15): faila=3D  0(D)  failb=3D 15(D)=
  OK
[  151.223420] raid6test: test_disks(0, 16): faila=3D  0(D)  failb=3D 16(D)=
  OK
[  151.594591] raid6test: test_disks(0, 17): faila=3D  0(D)  failb=3D 17(D)=
  OK
[  151.969969] raid6test: test_disks(0, 18): faila=3D  0(D)  failb=3D 18(D)=
  OK
[  152.325510] raid6test: test_disks(0, 19): faila=3D  0(D)  failb=3D 19(D)=
  OK
[  152.569784] raid6test: test_disks(0, 20): faila=3D  0(D)  failb=3D 20(D)=
  OK
[  152.903604] raid6test: test_disks(0, 21): faila=3D  0(D)  failb=3D 21(D)=
  OK
[  153.273419] raid6test: test_disks(0, 22): faila=3D  0(D)  failb=3D 22(D)=
  OK
[  153.627975] raid6test: test_disks(0, 23): faila=3D  0(D)  failb=3D 23(D)=
  OK
[  153.925957] raid6test: test_disks(0, 24): faila=3D  0(D)  failb=3D 24(D)=
  OK
[  154.283578] raid6test: test_disks(0, 25): faila=3D  0(D)  failb=3D 25(D)=
  OK
[  154.549085] raid6test: test_disks(0, 26): faila=3D  0(D)  failb=3D 26(D)=
  OK
[  154.916331] raid6test: test_disks(0, 27): faila=3D  0(D)  failb=3D 27(D)=
  OK
[  155.260337] raid6test: test_disks(0, 28): faila=3D  0(D)  failb=3D 28(D)=
  OK
[  155.445701] raid6test: test_disks(0, 29): faila=3D  0(D)  failb=3D 29(D)=
  OK
[  155.654157] raid6test: test_disks(0, 30): faila=3D  0(D)  failb=3D 30(D)=
  OK
[  155.912833] raid6test: test_disks(0, 31): faila=3D  0(D)  failb=3D 31(D)=
  OK
[  156.203324] raid6test: test_disks(0, 32): faila=3D  0(D)  failb=3D 32(D)=
  OK
[  156.356079] raid6test: test_disks(0, 33): faila=3D  0(D)  failb=3D 33(D)=
  OK
[  156.613844] raid6test: test_disks(0, 34): faila=3D  0(D)  failb=3D 34(D)=
  OK
[  156.920234] raid6test: test_disks(0, 35): faila=3D  0(D)  failb=3D 35(D)=
  OK
[  157.092544] raid6test: test_disks(0, 36): faila=3D  0(D)  failb=3D 36(D)=
  OK
[  157.244101] raid6test: test_disks(0, 37): faila=3D  0(D)  failb=3D 37(D)=
  OK
[  157.415064] raid6test: test_disks(0, 38): faila=3D  0(D)  failb=3D 38(D)=
  OK
[  157.581643] raid6test: test_disks(0, 39): faila=3D  0(D)  failb=3D 39(D)=
  OK
[  157.725491] raid6test: test_disks(0, 40): faila=3D  0(D)  failb=3D 40(D)=
  OK
[  157.990898] raid6test: test_disks(0, 41): faila=3D  0(D)  failb=3D 41(D)=
  OK
[  158.278815] raid6test: test_disks(0, 42): faila=3D  0(D)  failb=3D 42(D)=
  OK
[  158.493800] raid6test: test_disks(0, 43): faila=3D  0(D)  failb=3D 43(D)=
  OK
[  158.763218] raid6test: test_disks(0, 44): faila=3D  0(D)  failb=3D 44(D)=
  OK
[  159.063729] raid6test: test_disks(0, 45): faila=3D  0(D)  failb=3D 45(D)=
  OK
[  159.211375] raid6test: test_disks(0, 46): faila=3D  0(D)  failb=3D 46(D)=
  OK
[  159.436955] raid6test: test_disks(0, 47): faila=3D  0(D)  failb=3D 47(D)=
  OK
[  159.621352] raid6test: test_disks(0, 48): faila=3D  0(D)  failb=3D 48(D)=
  OK
[  159.819012] raid6test: test_disks(0, 49): faila=3D  0(D)  failb=3D 49(D)=
  OK
[  160.007628] raid6test: test_disks(0, 50): faila=3D  0(D)  failb=3D 50(D)=
  OK
[  160.289174] raid6test: test_disks(0, 51): faila=3D  0(D)  failb=3D 51(D)=
  OK
[  160.576672] raid6test: test_disks(0, 52): faila=3D  0(D)  failb=3D 52(D)=
  OK
[  160.869991] raid6test: test_disks(0, 53): faila=3D  0(D)  failb=3D 53(D)=
  OK
[  161.162343] raid6test: test_disks(0, 54): faila=3D  0(D)  failb=3D 54(D)=
  OK
[  161.443436] raid6test: test_disks(0, 55): faila=3D  0(D)  failb=3D 55(D)=
  OK
[  161.594057] raid6test: test_disks(0, 56): faila=3D  0(D)  failb=3D 56(D)=
  OK
[  161.881001] raid6test: test_disks(0, 57): faila=3D  0(D)  failb=3D 57(D)=
  OK
[  162.025656] raid6test: test_disks(0, 58): faila=3D  0(D)  failb=3D 58(D)=
  OK
[  162.196161] raid6test: test_disks(0, 59): faila=3D  0(D)  failb=3D 59(D)=
  OK
[  162.345528] raid6test: test_disks(0, 60): faila=3D  0(D)  failb=3D 60(D)=
  OK
[  162.500805] raid6test: test_disks(0, 61): faila=3D  0(D)  failb=3D 61(D)=
  OK
[  162.652887] raid6test: test_disks(0, 62): faila=3D  0(D)  failb=3D 62(P)=
  OK
[  162.851007] raid6test: test_disks(0, 63): faila=3D  0(D)  failb=3D 63(Q)=
  OK
[  163.081212] raid6test: test_disks(1, 2): faila=3D  1(D)  failb=3D  2(D) =
 OK
[  163.417143] raid6test: test_disks(1, 3): faila=3D  1(D)  failb=3D  3(D) =
 OK
[  163.725766] raid6test: test_disks(1, 4): faila=3D  1(D)  failb=3D  4(D) =
 OK
[  164.051725] raid6test: test_disks(1, 5): faila=3D  1(D)  failb=3D  5(D) =
 OK
[  164.405773] raid6test: test_disks(1, 6): faila=3D  1(D)  failb=3D  6(D) =
 OK
[  164.722084] raid6test: test_disks(1, 7): faila=3D  1(D)  failb=3D  7(D) =
 OK
[  164.976546] raid6test: test_disks(1, 8): faila=3D  1(D)  failb=3D  8(D) =
 OK
[  165.243242] raid6test: test_disks(1, 9): faila=3D  1(D)  failb=3D  9(D) =
 OK
[  165.572215] raid6test: test_disks(1, 10): faila=3D  1(D)  failb=3D 10(D)=
  OK
[  165.825192] raid6test: test_disks(1, 11): faila=3D  1(D)  failb=3D 11(D)=
  OK
[  166.118103] raid6test: test_disks(1, 12): faila=3D  1(D)  failb=3D 12(D)=
  OK
[  166.438739] raid6test: test_disks(1, 13): faila=3D  1(D)  failb=3D 13(D)=
  OK
[  166.658655] raid6test: test_disks(1, 14): faila=3D  1(D)  failb=3D 14(D)=
  OK
[  166.902805] raid6test: test_disks(1, 15): faila=3D  1(D)  failb=3D 15(D)=
  OK
[  167.233135] raid6test: test_disks(1, 16): faila=3D  1(D)  failb=3D 16(D)=
  OK
[  167.551772] raid6test: test_disks(1, 17): faila=3D  1(D)  failb=3D 17(D)=
  OK
[  167.793103] raid6test: test_disks(1, 18): faila=3D  1(D)  failb=3D 18(D)=
  OK
[  168.042714] raid6test: test_disks(1, 19): faila=3D  1(D)  failb=3D 19(D)=
  OK
[  168.211313] raid6test: test_disks(1, 20): faila=3D  1(D)  failb=3D 20(D)=
  OK
[  168.491617] raid6test: test_disks(1, 21): faila=3D  1(D)  failb=3D 21(D)=
  OK
[  168.715683] raid6test: test_disks(1, 22): faila=3D  1(D)  failb=3D 22(D)=
  OK
[  168.955651] raid6test: test_disks(1, 23): faila=3D  1(D)  failb=3D 23(D)=
  OK
[  169.174829] raid6test: test_disks(1, 24): faila=3D  1(D)  failb=3D 24(D)=
  OK
[  169.412583] raid6test: test_disks(1, 25): faila=3D  1(D)  failb=3D 25(D)=
  OK
[  169.732340] raid6test: test_disks(1, 26): faila=3D  1(D)  failb=3D 26(D)=
  OK
[  170.017536] raid6test: test_disks(1, 27): faila=3D  1(D)  failb=3D 27(D)=
  OK
[  170.257388] raid6test: test_disks(1, 28): faila=3D  1(D)  failb=3D 28(D)=
  OK
[  170.443910] raid6test: test_disks(1, 29): faila=3D  1(D)  failb=3D 29(D)=
  OK
[  170.649903] raid6test: test_disks(1, 30): faila=3D  1(D)  failb=3D 30(D)=
  OK
[  170.917378] raid6test: test_disks(1, 31): faila=3D  1(D)  failb=3D 31(D)=
  OK
[  171.219016] raid6test: test_disks(1, 32): faila=3D  1(D)  failb=3D 32(D)=
  OK
[  171.485695] raid6test: test_disks(1, 33): faila=3D  1(D)  failb=3D 33(D)=
  OK
[  171.694518] raid6test: test_disks(1, 34): faila=3D  1(D)  failb=3D 34(D)=
  OK
[  171.986621] raid6test: test_disks(1, 35): faila=3D  1(D)  failb=3D 35(D)=
  OK
[  172.262954] raid6test: test_disks(1, 36): faila=3D  1(D)  failb=3D 36(D)=
  OK
[  172.575590] raid6test: test_disks(1, 37): faila=3D  1(D)  failb=3D 37(D)=
  OK
[  172.858305] raid6test: test_disks(1, 38): faila=3D  1(D)  failb=3D 38(D)=
  OK
[  173.118683] raid6test: test_disks(1, 39): faila=3D  1(D)  failb=3D 39(D)=
  OK
[  173.443016] raid6test: test_disks(1, 40): faila=3D  1(D)  failb=3D 40(D)=
  OK
[  173.760179] raid6test: test_disks(1, 41): faila=3D  1(D)  failb=3D 41(D)=
  OK
[  173.960128] raid6test: test_disks(1, 42): faila=3D  1(D)  failb=3D 42(D)=
  OK
[  174.124158] raid6test: test_disks(1, 43): faila=3D  1(D)  failb=3D 43(D)=
  OK
[  174.277112] raid6test: test_disks(1, 44): faila=3D  1(D)  failb=3D 44(D)=
  OK
[  174.493070] raid6test: test_disks(1, 45): faila=3D  1(D)  failb=3D 45(D)=
  OK
[  174.772556] raid6test: test_disks(1, 46): faila=3D  1(D)  failb=3D 46(D)=
  OK
[  174.970241] raid6test: test_disks(1, 47): faila=3D  1(D)  failb=3D 47(D)=
  OK
[  175.276795] raid6test: test_disks(1, 48): faila=3D  1(D)  failb=3D 48(D)=
  OK
[  175.471138] raid6test: test_disks(1, 49): faila=3D  1(D)  failb=3D 49(D)=
  OK
[  175.628050] raid6test: test_disks(1, 50): faila=3D  1(D)  failb=3D 50(D)=
  OK
[  175.842257] raid6test: test_disks(1, 51): faila=3D  1(D)  failb=3D 51(D)=
  OK
[  176.033611] raid6test: test_disks(1, 52): faila=3D  1(D)  failb=3D 52(D)=
  OK
[  176.347650] raid6test: test_disks(1, 53): faila=3D  1(D)  failb=3D 53(D)=
  OK
[  176.587689] raid6test: test_disks(1, 54): faila=3D  1(D)  failb=3D 54(D)=
  OK
[  176.806314] raid6test: test_disks(1, 55): faila=3D  1(D)  failb=3D 55(D)=
  OK
[  176.978999] raid6test: test_disks(1, 56): faila=3D  1(D)  failb=3D 56(D)=
  OK
[  177.226882] raid6test: test_disks(1, 57): faila=3D  1(D)  failb=3D 57(D)=
  OK
[  177.412894] raid6test: test_disks(1, 58): faila=3D  1(D)  failb=3D 58(D)=
  OK
[  177.660378] raid6test: test_disks(1, 59): faila=3D  1(D)  failb=3D 59(D)=
  OK
[  177.842874] raid6test: test_disks(1, 60): faila=3D  1(D)  failb=3D 60(D)=
  OK
[  178.103060] raid6test: test_disks(1, 61): faila=3D  1(D)  failb=3D 61(D)=
  OK
[  178.292207] raid6test: test_disks(1, 62): faila=3D  1(D)  failb=3D 62(P)=
  OK
[  178.487766] raid6test: test_disks(1, 63): faila=3D  1(D)  failb=3D 63(Q)=
  OK
[  178.726487] raid6test: test_disks(2, 3): faila=3D  2(D)  failb=3D  3(D) =
 OK
[  178.886207] raid6test: test_disks(2, 4): faila=3D  2(D)  failb=3D  4(D) =
 OK
[  179.197584] raid6test: test_disks(2, 5): faila=3D  2(D)  failb=3D  5(D) =
 OK
[  179.497104] raid6test: test_disks(2, 6): faila=3D  2(D)  failb=3D  6(D) =
 OK
[  179.719350] raid6test: test_disks(2, 7): faila=3D  2(D)  failb=3D  7(D) =
 OK
[  179.907158] raid6test: test_disks(2, 8): faila=3D  2(D)  failb=3D  8(D) =
 OK
[  180.140339] raid6test: test_disks(2, 9): faila=3D  2(D)  failb=3D  9(D) =
 OK
[  180.450162] raid6test: test_disks(2, 10): faila=3D  2(D)  failb=3D 10(D)=
  OK
[  180.615633] raid6test: test_disks(2, 11): faila=3D  2(D)  failb=3D 11(D)=
  OK
[  180.812898] raid6test: test_disks(2, 12): faila=3D  2(D)  failb=3D 12(D)=
  OK
[  181.019005] raid6test: test_disks(2, 13): faila=3D  2(D)  failb=3D 13(D)=
  OK
[  181.188209] raid6test: test_disks(2, 14): faila=3D  2(D)  failb=3D 14(D)=
  OK
[  181.371122] raid6test: test_disks(2, 15): faila=3D  2(D)  failb=3D 15(D)=
  OK
[  181.558852] raid6test: test_disks(2, 16): faila=3D  2(D)  failb=3D 16(D)=
  OK
[  181.845818] raid6test: test_disks(2, 17): faila=3D  2(D)  failb=3D 17(D)=
  OK
[  182.123024] raid6test: test_disks(2, 18): faila=3D  2(D)  failb=3D 18(D)=
  OK
[  182.463949] raid6test: test_disks(2, 19): faila=3D  2(D)  failb=3D 19(D)=
  OK
[  182.763903] raid6test: test_disks(2, 20): faila=3D  2(D)  failb=3D 20(D)=
  OK
[  183.112118] raid6test: test_disks(2, 21): faila=3D  2(D)  failb=3D 21(D)=
  OK
[  183.446549] raid6test: test_disks(2, 22): faila=3D  2(D)  failb=3D 22(D)=
  OK
[  183.784073] raid6test: test_disks(2, 23): faila=3D  2(D)  failb=3D 23(D)=
  OK
[  184.097990] raid6test: test_disks(2, 24): faila=3D  2(D)  failb=3D 24(D)=
  OK
[  184.433940] raid6test: test_disks(2, 25): faila=3D  2(D)  failb=3D 25(D)=
  OK
[  184.762915] raid6test: test_disks(2, 26): faila=3D  2(D)  failb=3D 26(D)=
  OK
[  185.055352] raid6test: test_disks(2, 27): faila=3D  2(D)  failb=3D 27(D)=
  OK
[  185.236387] raid6test: test_disks(2, 28): faila=3D  2(D)  failb=3D 28(D)=
  OK
[  185.581729] raid6test: test_disks(2, 29): faila=3D  2(D)  failb=3D 29(D)=
  OK
[  185.874555] raid6test: test_disks(2, 30): faila=3D  2(D)  failb=3D 30(D)=
  OK
[  186.134014] raid6test: test_disks(2, 31): faila=3D  2(D)  failb=3D 31(D)=
  OK
[  186.366123] raid6test: test_disks(2, 32): faila=3D  2(D)  failb=3D 32(D)=
  OK
[  186.548039] raid6test: test_disks(2, 33): faila=3D  2(D)  failb=3D 33(D)=
  OK
[  186.703722] raid6test: test_disks(2, 34): faila=3D  2(D)  failb=3D 34(D)=
  OK
[  186.908725] raid6test: test_disks(2, 35): faila=3D  2(D)  failb=3D 35(D)=
  OK
[  187.168085] raid6test: test_disks(2, 36): faila=3D  2(D)  failb=3D 36(D)=
  OK
[  187.493830] raid6test: test_disks(2, 37): faila=3D  2(D)  failb=3D 37(D)=
  OK
[  187.734492] raid6test: test_disks(2, 38): faila=3D  2(D)  failb=3D 38(D)=
  OK
[  188.058374] raid6test: test_disks(2, 39): faila=3D  2(D)  failb=3D 39(D)=
  OK
[  188.374393] raid6test: test_disks(2, 40): faila=3D  2(D)  failb=3D 40(D)=
  OK
[  188.650766] raid6test: test_disks(2, 41): faila=3D  2(D)  failb=3D 41(D)=
  OK
[  188.905576] raid6test: test_disks(2, 42): faila=3D  2(D)  failb=3D 42(D)=
  OK
[  189.057504] raid6test: test_disks(2, 43): faila=3D  2(D)  failb=3D 43(D)=
  OK
[  189.363210] raid6test: test_disks(2, 44): faila=3D  2(D)  failb=3D 44(D)=
  OK
[  189.674617] raid6test: test_disks(2, 45): faila=3D  2(D)  failb=3D 45(D)=
  OK
[  189.839985] raid6test: test_disks(2, 46): faila=3D  2(D)  failb=3D 46(D)=
  OK
[  190.145111] raid6test: test_disks(2, 47): faila=3D  2(D)  failb=3D 47(D)=
  OK
[  190.297379] raid6test: test_disks(2, 48): faila=3D  2(D)  failb=3D 48(D)=
  OK
[  190.507686] raid6test: test_disks(2, 49): faila=3D  2(D)  failb=3D 49(D)=
  OK
[  190.831226] raid6test: test_disks(2, 50): faila=3D  2(D)  failb=3D 50(D)=
  OK
[  191.121074] raid6test: test_disks(2, 51): faila=3D  2(D)  failb=3D 51(D)=
  OK
[  191.427727] raid6test: test_disks(2, 52): faila=3D  2(D)  failb=3D 52(D)=
  OK
[  191.647890] raid6test: test_disks(2, 53): faila=3D  2(D)  failb=3D 53(D)=
  OK
[  191.872731] raid6test: test_disks(2, 54): faila=3D  2(D)  failb=3D 54(D)=
  OK
[  192.102566] raid6test: test_disks(2, 55): faila=3D  2(D)  failb=3D 55(D)=
  OK
[  192.302030] raid6test: test_disks(2, 56): faila=3D  2(D)  failb=3D 56(D)=
  OK
[  192.502136] raid6test: test_disks(2, 57): faila=3D  2(D)  failb=3D 57(D)=
  OK
[  192.791858] raid6test: test_disks(2, 58): faila=3D  2(D)  failb=3D 58(D)=
  OK
[  193.093568] raid6test: test_disks(2, 59): faila=3D  2(D)  failb=3D 59(D)=
  OK
[  193.327484] raid6test: test_disks(2, 60): faila=3D  2(D)  failb=3D 60(D)=
  OK
[  193.571710] raid6test: test_disks(2, 61): faila=3D  2(D)  failb=3D 61(D)=
  OK
[  193.786408] raid6test: test_disks(2, 62): faila=3D  2(D)  failb=3D 62(P)=
  OK
[  194.100718] raid6test: test_disks(2, 63): faila=3D  2(D)  failb=3D 63(Q)=
  OK
[  194.338962] raid6test: test_disks(3, 4): faila=3D  3(D)  failb=3D  4(D) =
 OK
[  194.631829] raid6test: test_disks(3, 5): faila=3D  3(D)  failb=3D  5(D) =
 OK
[  194.920835] raid6test: test_disks(3, 6): faila=3D  3(D)  failb=3D  6(D) =
 OK
[  195.216473] raid6test: test_disks(3, 7): faila=3D  3(D)  failb=3D  7(D) =
 OK
[  195.373734] raid6test: test_disks(3, 8): faila=3D  3(D)  failb=3D  8(D) =
 OK
[  195.609613] raid6test: test_disks(3, 9): faila=3D  3(D)  failb=3D  9(D) =
 OK
[  195.884169] raid6test: test_disks(3, 10): faila=3D  3(D)  failb=3D 10(D)=
  OK
[  196.090140] raid6test: test_disks(3, 11): faila=3D  3(D)  failb=3D 11(D)=
  OK
[  196.316110] raid6test: test_disks(3, 12): faila=3D  3(D)  failb=3D 12(D)=
  OK
[  196.549280] raid6test: test_disks(3, 13): faila=3D  3(D)  failb=3D 13(D)=
  OK
[  196.782311] raid6test: test_disks(3, 14): faila=3D  3(D)  failb=3D 14(D)=
  OK
[  197.010023] raid6test: test_disks(3, 15): faila=3D  3(D)  failb=3D 15(D)=
  OK
[  197.234116] raid6test: test_disks(3, 16): faila=3D  3(D)  failb=3D 16(D)=
  OK
[  197.546909] raid6test: test_disks(3, 17): faila=3D  3(D)  failb=3D 17(D)=
  OK
[  197.749190] raid6test: test_disks(3, 18): faila=3D  3(D)  failb=3D 18(D)=
  OK
[  197.969965] raid6test: test_disks(3, 19): faila=3D  3(D)  failb=3D 19(D)=
  OK
[  198.254677] raid6test: test_disks(3, 20): faila=3D  3(D)  failb=3D 20(D)=
  OK
[  198.426721] raid6test: test_disks(3, 21): faila=3D  3(D)  failb=3D 21(D)=
  OK
[  198.644621] raid6test: test_disks(3, 22): faila=3D  3(D)  failb=3D 22(D)=
  OK
[  198.819361] raid6test: test_disks(3, 23): faila=3D  3(D)  failb=3D 23(D)=
  OK
[  199.070364] raid6test: test_disks(3, 24): faila=3D  3(D)  failb=3D 24(D)=
  OK
[  199.356224] raid6test: test_disks(3, 25): faila=3D  3(D)  failb=3D 25(D)=
  OK
[  199.576579] raid6test: test_disks(3, 26): faila=3D  3(D)  failb=3D 26(D)=
  OK
[  199.768118] raid6test: test_disks(3, 27): faila=3D  3(D)  failb=3D 27(D)=
  OK
[  200.025456] raid6test: test_disks(3, 28): faila=3D  3(D)  failb=3D 28(D)=
  OK
[  200.213758] raid6test: test_disks(3, 29): faila=3D  3(D)  failb=3D 29(D)=
  OK
[  200.392290] raid6test: test_disks(3, 30): faila=3D  3(D)  failb=3D 30(D)=
  OK
[  200.565239] raid6test: test_disks(3, 31): faila=3D  3(D)  failb=3D 31(D)=
  OK
[  200.802160] raid6test: test_disks(3, 32): faila=3D  3(D)  failb=3D 32(D)=
  OK
[  201.042945] raid6test: test_disks(3, 33): faila=3D  3(D)  failb=3D 33(D)=
  OK
[  201.256934] raid6test: test_disks(3, 34): faila=3D  3(D)  failb=3D 34(D)=
  OK
[  201.503189] raid6test: test_disks(3, 35): faila=3D  3(D)  failb=3D 35(D)=
  OK
[  201.679597] raid6test: test_disks(3, 36): faila=3D  3(D)  failb=3D 36(D)=
  OK
[  201.953896] raid6test: test_disks(3, 37): faila=3D  3(D)  failb=3D 37(D)=
  OK
[  202.205640] raid6test: test_disks(3, 38): faila=3D  3(D)  failb=3D 38(D)=
  OK
[  202.458847] raid6test: test_disks(3, 39): faila=3D  3(D)  failb=3D 39(D)=
  OK
[  202.670769] raid6test: test_disks(3, 40): faila=3D  3(D)  failb=3D 40(D)=
  OK
[  202.842804] raid6test: test_disks(3, 41): faila=3D  3(D)  failb=3D 41(D)=
  OK
[  203.075913] raid6test: test_disks(3, 42): faila=3D  3(D)  failb=3D 42(D)=
  OK
[  203.381820] raid6test: test_disks(3, 43): faila=3D  3(D)  failb=3D 43(D)=
  OK
[  203.568615] raid6test: test_disks(3, 44): faila=3D  3(D)  failb=3D 44(D)=
  OK
[  203.777944] raid6test: test_disks(3, 45): faila=3D  3(D)  failb=3D 45(D)=
  OK
[  204.004806] raid6test: test_disks(3, 46): faila=3D  3(D)  failb=3D 46(D)=
  OK
[  204.298834] raid6test: test_disks(3, 47): faila=3D  3(D)  failb=3D 47(D)=
  OK
[  204.587591] raid6test: test_disks(3, 48): faila=3D  3(D)  failb=3D 48(D)=
  OK
[  204.875053] raid6test: test_disks(3, 49): faila=3D  3(D)  failb=3D 49(D)=
  OK
[  205.163292] raid6test: test_disks(3, 50): faila=3D  3(D)  failb=3D 50(D)=
  OK
[  205.454700] raid6test: test_disks(3, 51): faila=3D  3(D)  failb=3D 51(D)=
  OK
[  205.675219] raid6test: test_disks(3, 52): faila=3D  3(D)  failb=3D 52(D)=
  OK
[  205.959858] raid6test: test_disks(3, 53): faila=3D  3(D)  failb=3D 53(D)=
  OK
[  206.243671] raid6test: test_disks(3, 54): faila=3D  3(D)  failb=3D 54(D)=
  OK
[  206.500655] raid6test: test_disks(3, 55): faila=3D  3(D)  failb=3D 55(D)=
  OK
[  206.744691] raid6test: test_disks(3, 56): faila=3D  3(D)  failb=3D 56(D)=
  OK
[  207.005777] raid6test: test_disks(3, 57): faila=3D  3(D)  failb=3D 57(D)=
  OK
[  207.235947] raid6test: test_disks(3, 58): faila=3D  3(D)  failb=3D 58(D)=
  OK
[  207.515387] raid6test: test_disks(3, 59): faila=3D  3(D)  failb=3D 59(D)=
  OK
[  207.723649] raid6test: test_disks(3, 60): faila=3D  3(D)  failb=3D 60(D)=
  OK
[  207.901046] raid6test: test_disks(3, 61): faila=3D  3(D)  failb=3D 61(D)=
  OK
[  208.137126] raid6test: test_disks(3, 62): faila=3D  3(D)  failb=3D 62(P)=
  OK
[  208.435925] raid6test: test_disks(3, 63): faila=3D  3(D)  failb=3D 63(Q)=
  OK
[  208.679468] raid6test: test_disks(4, 5): faila=3D  4(D)  failb=3D  5(D) =
 OK
[  208.986963] raid6test: test_disks(4, 6): faila=3D  4(D)  failb=3D  6(D) =
 OK
[  209.298927] raid6test: test_disks(4, 7): faila=3D  4(D)  failb=3D  7(D) =
 OK
[  209.546298] raid6test: test_disks(4, 8): faila=3D  4(D)  failb=3D  8(D) =
 OK
[  209.863882] raid6test: test_disks(4, 9): faila=3D  4(D)  failb=3D  9(D) =
 OK
[  210.180086] raid6test: test_disks(4, 10): faila=3D  4(D)  failb=3D 10(D)=
  OK
[  210.502939] raid6test: test_disks(4, 11): faila=3D  4(D)  failb=3D 11(D)=
  OK
[  210.761617] raid6test: test_disks(4, 12): faila=3D  4(D)  failb=3D 12(D)=
  OK
[  211.076699] raid6test: test_disks(4, 13): faila=3D  4(D)  failb=3D 13(D)=
  OK
[  211.390955] raid6test: test_disks(4, 14): faila=3D  4(D)  failb=3D 14(D)=
  OK
[  211.658219] raid6test: test_disks(4, 15): faila=3D  4(D)  failb=3D 15(D)=
  OK
[  211.986009] raid6test: test_disks(4, 16): faila=3D  4(D)  failb=3D 16(D)=
  OK
[  212.241352] raid6test: test_disks(4, 17): faila=3D  4(D)  failb=3D 17(D)=
  OK
[  212.566555] raid6test: test_disks(4, 18): faila=3D  4(D)  failb=3D 18(D)=
  OK
[  212.769737] raid6test: test_disks(4, 19): faila=3D  4(D)  failb=3D 19(D)=
  OK
[  213.087473] raid6test: test_disks(4, 20): faila=3D  4(D)  failb=3D 20(D)=
  OK
[  213.418727] raid6test: test_disks(4, 21): faila=3D  4(D)  failb=3D 21(D)=
  OK
[  213.744722] raid6test: test_disks(4, 22): faila=3D  4(D)  failb=3D 22(D)=
  OK
[  214.000339] raid6test: test_disks(4, 23): faila=3D  4(D)  failb=3D 23(D)=
  OK
[  214.339720] raid6test: test_disks(4, 24): faila=3D  4(D)  failb=3D 24(D)=
  OK
[  214.665806] raid6test: test_disks(4, 25): faila=3D  4(D)  failb=3D 25(D)=
  OK
[  214.987747] raid6test: test_disks(4, 26): faila=3D  4(D)  failb=3D 26(D)=
  OK
[  215.310391] raid6test: test_disks(4, 27): faila=3D  4(D)  failb=3D 27(D)=
  OK
[  215.639681] raid6test: test_disks(4, 28): faila=3D  4(D)  failb=3D 28(D)=
  OK
[  215.924921] raid6test: test_disks(4, 29): faila=3D  4(D)  failb=3D 29(D)=
  OK
[  216.148677] raid6test: test_disks(4, 30): faila=3D  4(D)  failb=3D 30(D)=
  OK
[  216.466364] raid6test: test_disks(4, 31): faila=3D  4(D)  failb=3D 31(D)=
  OK
[  216.785362] raid6test: test_disks(4, 32): faila=3D  4(D)  failb=3D 32(D)=
  OK
[  217.105901] raid6test: test_disks(4, 33): faila=3D  4(D)  failb=3D 33(D)=
  OK
[  217.425270] raid6test: test_disks(4, 34): faila=3D  4(D)  failb=3D 34(D)=
  OK
[  217.676896] raid6test: test_disks(4, 35): faila=3D  4(D)  failb=3D 35(D)=
  OK
[  217.979025] raid6test: test_disks(4, 36): faila=3D  4(D)  failb=3D 36(D)=
  OK
[  218.272946] raid6test: test_disks(4, 37): faila=3D  4(D)  failb=3D 37(D)=
  OK
[  218.589026] raid6test: test_disks(4, 38): faila=3D  4(D)  failb=3D 38(D)=
  OK
[  218.891196] raid6test: test_disks(4, 39): faila=3D  4(D)  failb=3D 39(D)=
  OK
[  219.071612] raid6test: test_disks(4, 40): faila=3D  4(D)  failb=3D 40(D)=
  OK
[  219.351893] raid6test: test_disks(4, 41): faila=3D  4(D)  failb=3D 41(D)=
  OK
[  219.645304] raid6test: test_disks(4, 42): faila=3D  4(D)  failb=3D 42(D)=
  OK
[  219.902535] raid6test: test_disks(4, 43): faila=3D  4(D)  failb=3D 43(D)=
  OK
[  220.053249] raid6test: test_disks(4, 44): faila=3D  4(D)  failb=3D 44(D)=
  OK
[  220.234885] raid6test: test_disks(4, 45): faila=3D  4(D)  failb=3D 45(D)=
  OK
[  220.418041] raid6test: test_disks(4, 46): faila=3D  4(D)  failb=3D 46(D)=
  OK
[  220.603595] raid6test: test_disks(4, 47): faila=3D  4(D)  failb=3D 47(D)=
  OK
[  220.876798] raid6test: test_disks(4, 48): faila=3D  4(D)  failb=3D 48(D)=
  OK
[  221.160516] raid6test: test_disks(4, 49): faila=3D  4(D)  failb=3D 49(D)=
  OK
[  221.463001] raid6test: test_disks(4, 50): faila=3D  4(D)  failb=3D 50(D)=
  OK
[  221.751576] raid6test: test_disks(4, 51): faila=3D  4(D)  failb=3D 51(D)=
  OK
[  222.038585] raid6test: test_disks(4, 52): faila=3D  4(D)  failb=3D 52(D)=
  OK
[  222.338700] raid6test: test_disks(4, 53): faila=3D  4(D)  failb=3D 53(D)=
  OK
[  222.628776] raid6test: test_disks(4, 54): faila=3D  4(D)  failb=3D 54(D)=
  OK
[  222.898187] raid6test: test_disks(4, 55): faila=3D  4(D)  failb=3D 55(D)=
  OK
[  223.199940] raid6test: test_disks(4, 56): faila=3D  4(D)  failb=3D 56(D)=
  OK
[  223.396173] raid6test: test_disks(4, 57): faila=3D  4(D)  failb=3D 57(D)=
  OK
[  223.565702] raid6test: test_disks(4, 58): faila=3D  4(D)  failb=3D 58(D)=
  OK
[  223.721004] raid6test: test_disks(4, 59): faila=3D  4(D)  failb=3D 59(D)=
  OK
[  223.936663] raid6test: test_disks(4, 60): faila=3D  4(D)  failb=3D 60(D)=
  OK
[  224.124086] raid6test: test_disks(4, 61): faila=3D  4(D)  failb=3D 61(D)=
  OK
[  224.273836] raid6test: test_disks(4, 62): faila=3D  4(D)  failb=3D 62(P)=
  OK
[  224.504952] raid6test: test_disks(4, 63): faila=3D  4(D)  failb=3D 63(Q)=
  OK
[  224.803112] raid6test: test_disks(5, 6): faila=3D  5(D)  failb=3D  6(D) =
 OK
[  225.160859] raid6test: test_disks(5, 7): faila=3D  5(D)  failb=3D  7(D) =
 OK
[  225.400186] raid6test: test_disks(5, 8): faila=3D  5(D)  failb=3D  8(D) =
 OK
[  225.720912] raid6test: test_disks(5, 9): faila=3D  5(D)  failb=3D  9(D) =
 OK
[  225.925597] raid6test: test_disks(5, 10): faila=3D  5(D)  failb=3D 10(D)=
  OK
[  226.250884] raid6test: test_disks(5, 11): faila=3D  5(D)  failb=3D 11(D)=
  OK
[  226.600327] raid6test: test_disks(5, 12): faila=3D  5(D)  failb=3D 12(D)=
  OK
[  226.921285] raid6test: test_disks(5, 13): faila=3D  5(D)  failb=3D 13(D)=
  OK
[  227.281799] raid6test: test_disks(5, 14): faila=3D  5(D)  failb=3D 14(D)=
  OK
[  227.597179] raid6test: test_disks(5, 15): faila=3D  5(D)  failb=3D 15(D)=
  OK
[  227.943041] raid6test: test_disks(5, 16): faila=3D  5(D)  failb=3D 16(D)=
  OK
[  228.260380] raid6test: test_disks(5, 17): faila=3D  5(D)  failb=3D 17(D)=
  OK
[  228.587724] raid6test: test_disks(5, 18): faila=3D  5(D)  failb=3D 18(D)=
  OK
[  228.917767] raid6test: test_disks(5, 19): faila=3D  5(D)  failb=3D 19(D)=
  OK
[  229.183842] raid6test: test_disks(5, 20): faila=3D  5(D)  failb=3D 20(D)=
  OK
[  229.383504] raid6test: test_disks(5, 21): faila=3D  5(D)  failb=3D 21(D)=
  OK
[  229.619763] raid6test: test_disks(5, 22): faila=3D  5(D)  failb=3D 22(D)=
  OK
[  229.835074] raid6test: test_disks(5, 23): faila=3D  5(D)  failb=3D 23(D)=
  OK
[  230.031473] raid6test: test_disks(5, 24): faila=3D  5(D)  failb=3D 24(D)=
  OK
[  230.258279] raid6test: test_disks(5, 25): faila=3D  5(D)  failb=3D 25(D)=
  OK
[  230.452507] raid6test: test_disks(5, 26): faila=3D  5(D)  failb=3D 26(D)=
  OK
[  230.633877] raid6test: test_disks(5, 27): faila=3D  5(D)  failb=3D 27(D)=
  OK
[  230.801782] raid6test: test_disks(5, 28): faila=3D  5(D)  failb=3D 28(D)=
  OK
[  231.003727] raid6test: test_disks(5, 29): faila=3D  5(D)  failb=3D 29(D)=
  OK
[  231.328875] raid6test: test_disks(5, 30): faila=3D  5(D)  failb=3D 30(D)=
  OK
[  231.586401] raid6test: test_disks(5, 31): faila=3D  5(D)  failb=3D 31(D)=
  OK
[  231.798016] raid6test: test_disks(5, 32): faila=3D  5(D)  failb=3D 32(D)=
  OK
[  232.033738] raid6test: test_disks(5, 33): faila=3D  5(D)  failb=3D 33(D)=
  OK
[  232.259572] raid6test: test_disks(5, 34): faila=3D  5(D)  failb=3D 34(D)=
  OK
[  232.430685] raid6test: test_disks(5, 35): faila=3D  5(D)  failb=3D 35(D)=
  OK
[  232.737920] raid6test: test_disks(5, 36): faila=3D  5(D)  failb=3D 36(D)=
  OK
[  233.045809] raid6test: test_disks(5, 37): faila=3D  5(D)  failb=3D 37(D)=
  OK
[  233.343519] raid6test: test_disks(5, 38): faila=3D  5(D)  failb=3D 38(D)=
  OK
[  233.523376] raid6test: test_disks(5, 39): faila=3D  5(D)  failb=3D 39(D)=
  OK
[  233.705156] raid6test: test_disks(5, 40): faila=3D  5(D)  failb=3D 40(D)=
  OK
[  233.892691] raid6test: test_disks(5, 41): faila=3D  5(D)  failb=3D 41(D)=
  OK
[  234.047265] raid6test: test_disks(5, 42): faila=3D  5(D)  failb=3D 42(D)=
  OK
[  234.195676] raid6test: test_disks(5, 43): faila=3D  5(D)  failb=3D 43(D)=
  OK
[  234.421780] raid6test: test_disks(5, 44): faila=3D  5(D)  failb=3D 44(D)=
  OK
[  234.656759] raid6test: test_disks(5, 45): faila=3D  5(D)  failb=3D 45(D)=
  OK
[  234.837824] raid6test: test_disks(5, 46): faila=3D  5(D)  failb=3D 46(D)=
  OK
[  234.990608] raid6test: test_disks(5, 47): faila=3D  5(D)  failb=3D 47(D)=
  OK
[  235.252744] raid6test: test_disks(5, 48): faila=3D  5(D)  failb=3D 48(D)=
  OK
[  235.438199] raid6test: test_disks(5, 49): faila=3D  5(D)  failb=3D 49(D)=
  OK
[  235.682375] raid6test: test_disks(5, 50): faila=3D  5(D)  failb=3D 50(D)=
  OK
[  235.851003] raid6test: test_disks(5, 51): faila=3D  5(D)  failb=3D 51(D)=
  OK
[  236.063800] raid6test: test_disks(5, 52): faila=3D  5(D)  failb=3D 52(D)=
  OK
[  236.249953] raid6test: test_disks(5, 53): faila=3D  5(D)  failb=3D 53(D)=
  OK
[  236.505734] raid6test: test_disks(5, 54): faila=3D  5(D)  failb=3D 54(D)=
  OK
[  236.750021] raid6test: test_disks(5, 55): faila=3D  5(D)  failb=3D 55(D)=
  OK
[  236.924086] raid6test: test_disks(5, 56): faila=3D  5(D)  failb=3D 56(D)=
  OK
[  237.155758] raid6test: test_disks(5, 57): faila=3D  5(D)  failb=3D 57(D)=
  OK
[  237.354916] raid6test: test_disks(5, 58): faila=3D  5(D)  failb=3D 58(D)=
  OK
[  237.535856] raid6test: test_disks(5, 59): faila=3D  5(D)  failb=3D 59(D)=
  OK
[  237.704192] raid6test: test_disks(5, 60): faila=3D  5(D)  failb=3D 60(D)=
  OK
[  237.851320] raid6test: test_disks(5, 61): faila=3D  5(D)  failb=3D 61(D)=
  OK
[  237.994258] raid6test: test_disks(5, 62): faila=3D  5(D)  failb=3D 62(P)=
  OK
[  238.245131] raid6test: test_disks(5, 63): faila=3D  5(D)  failb=3D 63(Q)=
  OK
[  238.464508] raid6test: test_disks(6, 7): faila=3D  6(D)  failb=3D  7(D) =
 OK
[  238.765400] raid6test: test_disks(6, 8): faila=3D  6(D)  failb=3D  8(D) =
 OK
[  238.932113] raid6test: test_disks(6, 9): faila=3D  6(D)  failb=3D  9(D) =
 OK
[  239.126033] raid6test: test_disks(6, 10): faila=3D  6(D)  failb=3D 10(D)=
  OK
[  239.316417] raid6test: test_disks(6, 11): faila=3D  6(D)  failb=3D 11(D)=
  OK
[  239.509647] raid6test: test_disks(6, 12): faila=3D  6(D)  failb=3D 12(D)=
  OK
[  239.763062] raid6test: test_disks(6, 13): faila=3D  6(D)  failb=3D 13(D)=
  OK
[  240.016392] raid6test: test_disks(6, 14): faila=3D  6(D)  failb=3D 14(D)=
  OK
[  240.258674] raid6test: test_disks(6, 15): faila=3D  6(D)  failb=3D 15(D)=
  OK
[  240.510757] raid6test: test_disks(6, 16): faila=3D  6(D)  failb=3D 16(D)=
  OK
[  240.845931] raid6test: test_disks(6, 17): faila=3D  6(D)  failb=3D 17(D)=
  OK
[  241.115514] raid6test: test_disks(6, 18): faila=3D  6(D)  failb=3D 18(D)=
  OK
[  241.430805] raid6test: test_disks(6, 19): faila=3D  6(D)  failb=3D 19(D)=
  OK
[  241.755504] raid6test: test_disks(6, 20): faila=3D  6(D)  failb=3D 20(D)=
  OK
[  241.979604] raid6test: test_disks(6, 21): faila=3D  6(D)  failb=3D 21(D)=
  OK
[  242.242704] raid6test: test_disks(6, 22): faila=3D  6(D)  failb=3D 22(D)=
  OK
[  242.470582] raid6test: test_disks(6, 23): faila=3D  6(D)  failb=3D 23(D)=
  OK
[  242.788434] raid6test: test_disks(6, 24): faila=3D  6(D)  failb=3D 24(D)=
  OK
[  243.036865] raid6test: test_disks(6, 25): faila=3D  6(D)  failb=3D 25(D)=
  OK
[  243.298062] raid6test: test_disks(6, 26): faila=3D  6(D)  failb=3D 26(D)=
  OK
[  243.609777] raid6test: test_disks(6, 27): faila=3D  6(D)  failb=3D 27(D)=
  OK
[  243.775257] raid6test: test_disks(6, 28): faila=3D  6(D)  failb=3D 28(D)=
  OK
[  244.062832] raid6test: test_disks(6, 29): faila=3D  6(D)  failb=3D 29(D)=
  OK
[  244.373140] raid6test: test_disks(6, 30): faila=3D  6(D)  failb=3D 30(D)=
  OK
[  244.683611] raid6test: test_disks(6, 31): faila=3D  6(D)  failb=3D 31(D)=
  OK
[  244.845167] raid6test: test_disks(6, 32): faila=3D  6(D)  failb=3D 32(D)=
  OK
[  245.163311] raid6test: test_disks(6, 33): faila=3D  6(D)  failb=3D 33(D)=
  OK
[  245.510667] raid6test: test_disks(6, 34): faila=3D  6(D)  failb=3D 34(D)=
  OK
[  245.855689] raid6test: test_disks(6, 35): faila=3D  6(D)  failb=3D 35(D)=
  OK
[  246.145432] raid6test: test_disks(6, 36): faila=3D  6(D)  failb=3D 36(D)=
  OK
[  246.446523] raid6test: test_disks(6, 37): faila=3D  6(D)  failb=3D 37(D)=
  OK
[  246.747617] raid6test: test_disks(6, 38): faila=3D  6(D)  failb=3D 38(D)=
  OK
[  247.044461] raid6test: test_disks(6, 39): faila=3D  6(D)  failb=3D 39(D)=
  OK
[  247.334135] raid6test: test_disks(6, 40): faila=3D  6(D)  failb=3D 40(D)=
  OK
[  247.627345] raid6test: test_disks(6, 41): faila=3D  6(D)  failb=3D 41(D)=
  OK
[  247.918613] raid6test: test_disks(6, 42): faila=3D  6(D)  failb=3D 42(D)=
  OK
[  248.209057] raid6test: test_disks(6, 43): faila=3D  6(D)  failb=3D 43(D)=
  OK
[  248.608564] raid6test: test_disks(6, 44): faila=3D  6(D)  failb=3D 44(D)=
  OK
[  248.864214] raid6test: test_disks(6, 45): faila=3D  6(D)  failb=3D 45(D)=
  OK
[  249.141312] raid6test: test_disks(6, 46): faila=3D  6(D)  failb=3D 46(D)=
  OK
[  249.442740] raid6test: test_disks(6, 47): faila=3D  6(D)  failb=3D 47(D)=
  OK
[  249.737772] raid6test: test_disks(6, 48): faila=3D  6(D)  failb=3D 48(D)=
  OK
[  250.055184] raid6test: test_disks(6, 49): faila=3D  6(D)  failb=3D 49(D)=
  OK
[  250.347753] raid6test: test_disks(6, 50): faila=3D  6(D)  failb=3D 50(D)=
  OK
[  250.634228] raid6test: test_disks(6, 51): faila=3D  6(D)  failb=3D 51(D)=
  OK
[  250.934926] raid6test: test_disks(6, 52): faila=3D  6(D)  failb=3D 52(D)=
  OK
[  251.263868] raid6test: test_disks(6, 53): faila=3D  6(D)  failb=3D 53(D)=
  OK
[  251.573247] raid6test: test_disks(6, 54): faila=3D  6(D)  failb=3D 54(D)=
  OK
[  251.855886] raid6test: test_disks(6, 55): faila=3D  6(D)  failb=3D 55(D)=
  OK
[  252.069729] raid6test: test_disks(6, 56): faila=3D  6(D)  failb=3D 56(D)=
  OK
[  252.264917] raid6test: test_disks(6, 57): faila=3D  6(D)  failb=3D 57(D)=
  OK
[  252.486634] raid6test: test_disks(6, 58): faila=3D  6(D)  failb=3D 58(D)=
  OK
[  252.684044] raid6test: test_disks(6, 59): faila=3D  6(D)  failb=3D 59(D)=
  OK
[  252.891705] raid6test: test_disks(6, 60): faila=3D  6(D)  failb=3D 60(D)=
  OK
[  253.191160] raid6test: test_disks(6, 61): faila=3D  6(D)  failb=3D 61(D)=
  OK
[  253.494916] raid6test: test_disks(6, 62): faila=3D  6(D)  failb=3D 62(P)=
  OK
[  253.705653] raid6test: test_disks(6, 63): faila=3D  6(D)  failb=3D 63(Q)=
  OK
[  253.924792] raid6test: test_disks(7, 8): faila=3D  7(D)  failb=3D  8(D) =
 OK
[  254.132203] raid6test: test_disks(7, 9): faila=3D  7(D)  failb=3D  9(D) =
 OK
[  254.298283] raid6test: test_disks(7, 10): faila=3D  7(D)  failb=3D 10(D)=
  OK
[  254.471776] raid6test: test_disks(7, 11): faila=3D  7(D)  failb=3D 11(D)=
  OK
[  254.637574] raid6test: test_disks(7, 12): faila=3D  7(D)  failb=3D 12(D)=
  OK
[  254.904398] raid6test: test_disks(7, 13): faila=3D  7(D)  failb=3D 13(D)=
  OK
[  255.232755] raid6test: test_disks(7, 14): faila=3D  7(D)  failb=3D 14(D)=
  OK
[  255.506118] raid6test: test_disks(7, 15): faila=3D  7(D)  failb=3D 15(D)=
  OK
[  255.689735] raid6test: test_disks(7, 16): faila=3D  7(D)  failb=3D 16(D)=
  OK
[  255.951717] raid6test: test_disks(7, 17): faila=3D  7(D)  failb=3D 17(D)=
  OK
[  256.137137] raid6test: test_disks(7, 18): faila=3D  7(D)  failb=3D 18(D)=
  OK
[  256.336393] raid6test: test_disks(7, 19): faila=3D  7(D)  failb=3D 19(D)=
  OK
[  256.559777] raid6test: test_disks(7, 20): faila=3D  7(D)  failb=3D 20(D)=
  OK
[  256.807972] raid6test: test_disks(7, 21): faila=3D  7(D)  failb=3D 21(D)=
  OK
[  256.963998] raid6test: test_disks(7, 22): faila=3D  7(D)  failb=3D 22(D)=
  OK
[  257.152570] raid6test: test_disks(7, 23): faila=3D  7(D)  failb=3D 23(D)=
  OK
[  257.371450] raid6test: test_disks(7, 24): faila=3D  7(D)  failb=3D 24(D)=
  OK
[  257.588380] raid6test: test_disks(7, 25): faila=3D  7(D)  failb=3D 25(D)=
  OK
[  257.744555] raid6test: test_disks(7, 26): faila=3D  7(D)  failb=3D 26(D)=
  OK
[  258.059863] raid6test: test_disks(7, 27): faila=3D  7(D)  failb=3D 27(D)=
  OK
[  258.305715] raid6test: test_disks(7, 28): faila=3D  7(D)  failb=3D 28(D)=
  OK
[  258.487778] raid6test: test_disks(7, 29): faila=3D  7(D)  failb=3D 29(D)=
  OK
[  258.707322] raid6test: test_disks(7, 30): faila=3D  7(D)  failb=3D 30(D)=
  OK
[  259.019331] raid6test: test_disks(7, 31): faila=3D  7(D)  failb=3D 31(D)=
  OK
[  259.306638] raid6test: test_disks(7, 32): faila=3D  7(D)  failb=3D 32(D)=
  OK
[  259.473507] raid6test: test_disks(7, 33): faila=3D  7(D)  failb=3D 33(D)=
  OK
[  259.665067] raid6test: test_disks(7, 34): faila=3D  7(D)  failb=3D 34(D)=
  OK
[  259.980749] raid6test: test_disks(7, 35): faila=3D  7(D)  failb=3D 35(D)=
  OK
[  260.206708] raid6test: test_disks(7, 36): faila=3D  7(D)  failb=3D 36(D)=
  OK
[  260.448775] raid6test: test_disks(7, 37): faila=3D  7(D)  failb=3D 37(D)=
  OK
[  260.697734] raid6test: test_disks(7, 38): faila=3D  7(D)  failb=3D 38(D)=
  OK
[  260.997324] raid6test: test_disks(7, 39): faila=3D  7(D)  failb=3D 39(D)=
  OK
[  261.316531] raid6test: test_disks(7, 40): faila=3D  7(D)  failb=3D 40(D)=
  OK
[  261.611146] raid6test: test_disks(7, 41): faila=3D  7(D)  failb=3D 41(D)=
  OK
[  261.806285] raid6test: test_disks(7, 42): faila=3D  7(D)  failb=3D 42(D)=
  OK
[  262.012631] raid6test: test_disks(7, 43): faila=3D  7(D)  failb=3D 43(D)=
  OK
[  262.217872] raid6test: test_disks(7, 44): faila=3D  7(D)  failb=3D 44(D)=
  OK
[  262.530520] raid6test: test_disks(7, 45): faila=3D  7(D)  failb=3D 45(D)=
  OK
[  262.863809] raid6test: test_disks(7, 46): faila=3D  7(D)  failb=3D 46(D)=
  OK
[  263.013706] raid6test: test_disks(7, 47): faila=3D  7(D)  failb=3D 47(D)=
  OK
[  263.279991] raid6test: test_disks(7, 48): faila=3D  7(D)  failb=3D 48(D)=
  OK
[  263.525354] raid6test: test_disks(7, 49): faila=3D  7(D)  failb=3D 49(D)=
  OK
[  263.672890] raid6test: test_disks(7, 50): faila=3D  7(D)  failb=3D 50(D)=
  OK
[  263.854975] raid6test: test_disks(7, 51): faila=3D  7(D)  failb=3D 51(D)=
  OK
[  264.025972] raid6test: test_disks(7, 52): faila=3D  7(D)  failb=3D 52(D)=
  OK
[  264.200729] raid6test: test_disks(7, 53): faila=3D  7(D)  failb=3D 53(D)=
  OK
[  264.454371] raid6test: test_disks(7, 54): faila=3D  7(D)  failb=3D 54(D)=
  OK
[  264.614854] raid6test: test_disks(7, 55): faila=3D  7(D)  failb=3D 55(D)=
  OK
[  264.775287] raid6test: test_disks(7, 56): faila=3D  7(D)  failb=3D 56(D)=
  OK
[  264.932618] raid6test: test_disks(7, 57): faila=3D  7(D)  failb=3D 57(D)=
  OK
[  265.083866] raid6test: test_disks(7, 58): faila=3D  7(D)  failb=3D 58(D)=
  OK
[  265.268689] raid6test: test_disks(7, 59): faila=3D  7(D)  failb=3D 59(D)=
  OK
[  265.464839] raid6test: test_disks(7, 60): faila=3D  7(D)  failb=3D 60(D)=
  OK
[  265.759358] raid6test: test_disks(7, 61): faila=3D  7(D)  failb=3D 61(D)=
  OK
[  266.043839] raid6test: test_disks(7, 62): faila=3D  7(D)  failb=3D 62(P)=
  OK
[  266.348499] raid6test: test_disks(7, 63): faila=3D  7(D)  failb=3D 63(Q)=
  OK
[  266.637058] raid6test: test_disks(8, 9): faila=3D  8(D)  failb=3D  9(D) =
 OK
[  266.970021] raid6test: test_disks(8, 10): faila=3D  8(D)  failb=3D 10(D)=
  OK
[  267.281289] raid6test: test_disks(8, 11): faila=3D  8(D)  failb=3D 11(D)=
  OK
[  267.611998] raid6test: test_disks(8, 12): faila=3D  8(D)  failb=3D 12(D)=
  OK
[  267.854048] raid6test: test_disks(8, 13): faila=3D  8(D)  failb=3D 13(D)=
  OK
[  268.165833] raid6test: test_disks(8, 14): faila=3D  8(D)  failb=3D 14(D)=
  OK
[  268.417411] raid6test: test_disks(8, 15): faila=3D  8(D)  failb=3D 15(D)=
  OK
[  268.724409] raid6test: test_disks(8, 16): faila=3D  8(D)  failb=3D 16(D)=
  OK
[  268.900214] raid6test: test_disks(8, 17): faila=3D  8(D)  failb=3D 17(D)=
  OK
[  269.251088] raid6test: test_disks(8, 18): faila=3D  8(D)  failb=3D 18(D)=
  OK
[  269.565257] raid6test: test_disks(8, 19): faila=3D  8(D)  failb=3D 19(D)=
  OK
[  269.905265] raid6test: test_disks(8, 20): faila=3D  8(D)  failb=3D 20(D)=
  OK
[  270.176872] raid6test: test_disks(8, 21): faila=3D  8(D)  failb=3D 21(D)=
  OK
[  270.387713] raid6test: test_disks(8, 22): faila=3D  8(D)  failb=3D 22(D)=
  OK
[  270.686059] raid6test: test_disks(8, 23): faila=3D  8(D)  failb=3D 23(D)=
  OK
[  271.020511] raid6test: test_disks(8, 24): faila=3D  8(D)  failb=3D 24(D)=
  OK
[  271.334740] raid6test: test_disks(8, 25): faila=3D  8(D)  failb=3D 25(D)=
  OK
[  271.657793] raid6test: test_disks(8, 26): faila=3D  8(D)  failb=3D 26(D)=
  OK
[  271.927730] raid6test: test_disks(8, 27): faila=3D  8(D)  failb=3D 27(D)=
  OK
[  272.151521] raid6test: test_disks(8, 28): faila=3D  8(D)  failb=3D 28(D)=
  OK
[  272.380531] raid6test: test_disks(8, 29): faila=3D  8(D)  failb=3D 29(D)=
  OK
[  272.601397] raid6test: test_disks(8, 30): faila=3D  8(D)  failb=3D 30(D)=
  OK
[  272.762261] raid6test: test_disks(8, 31): faila=3D  8(D)  failb=3D 31(D)=
  OK
[  273.010163] raid6test: test_disks(8, 32): faila=3D  8(D)  failb=3D 32(D)=
  OK
[  273.330655] raid6test: test_disks(8, 33): faila=3D  8(D)  failb=3D 33(D)=
  OK
[  273.545863] raid6test: test_disks(8, 34): faila=3D  8(D)  failb=3D 34(D)=
  OK
[  273.784681] raid6test: test_disks(8, 35): faila=3D  8(D)  failb=3D 35(D)=
  OK
[  274.041601] raid6test: test_disks(8, 36): faila=3D  8(D)  failb=3D 36(D)=
  OK
[  274.379804] raid6test: test_disks(8, 37): faila=3D  8(D)  failb=3D 37(D)=
  OK
[  274.669114] raid6test: test_disks(8, 38): faila=3D  8(D)  failb=3D 38(D)=
  OK
[  274.907391] raid6test: test_disks(8, 39): faila=3D  8(D)  failb=3D 39(D)=
  OK
[  275.093861] raid6test: test_disks(8, 40): faila=3D  8(D)  failb=3D 40(D)=
  OK
[  275.267632] raid6test: test_disks(8, 41): faila=3D  8(D)  failb=3D 41(D)=
  OK
[  275.417337] raid6test: test_disks(8, 42): faila=3D  8(D)  failb=3D 42(D)=
  OK
[  275.659060] raid6test: test_disks(8, 43): faila=3D  8(D)  failb=3D 43(D)=
  OK
[  275.962448] raid6test: test_disks(8, 44): faila=3D  8(D)  failb=3D 44(D)=
  OK
[  276.262703] raid6test: test_disks(8, 45): faila=3D  8(D)  failb=3D 45(D)=
  OK
[  276.505881] raid6test: test_disks(8, 46): faila=3D  8(D)  failb=3D 46(D)=
  OK
[  276.655068] raid6test: test_disks(8, 47): faila=3D  8(D)  failb=3D 47(D)=
  OK
[  276.855344] raid6test: test_disks(8, 48): faila=3D  8(D)  failb=3D 48(D)=
  OK
[  277.022590] raid6test: test_disks(8, 49): faila=3D  8(D)  failb=3D 49(D)=
  OK
[  277.272653] raid6test: test_disks(8, 50): faila=3D  8(D)  failb=3D 50(D)=
  OK
[  277.514632] raid6test: test_disks(8, 51): faila=3D  8(D)  failb=3D 51(D)=
  OK
[  277.825539] raid6test: test_disks(8, 52): faila=3D  8(D)  failb=3D 52(D)=
  OK
[  278.116253] raid6test: test_disks(8, 53): faila=3D  8(D)  failb=3D 53(D)=
  OK
[  278.303470] raid6test: test_disks(8, 54): faila=3D  8(D)  failb=3D 54(D)=
  OK
[  278.483019] raid6test: test_disks(8, 55): faila=3D  8(D)  failb=3D 55(D)=
  OK
[  278.823144] raid6test: test_disks(8, 56): faila=3D  8(D)  failb=3D 56(D)=
  OK
[  279.029987] raid6test: test_disks(8, 57): faila=3D  8(D)  failb=3D 57(D)=
  OK
[  279.274994] raid6test: test_disks(8, 58): faila=3D  8(D)  failb=3D 58(D)=
  OK
[  279.462367] raid6test: test_disks(8, 59): faila=3D  8(D)  failb=3D 59(D)=
  OK
[  279.636195] raid6test: test_disks(8, 60): faila=3D  8(D)  failb=3D 60(D)=
  OK
[  279.856072] raid6test: test_disks(8, 61): faila=3D  8(D)  failb=3D 61(D)=
  OK
[  280.157595] raid6test: test_disks(8, 62): faila=3D  8(D)  failb=3D 62(P)=
  OK
[  280.378177] raid6test: test_disks(8, 63): faila=3D  8(D)  failb=3D 63(Q)=
  OK
[  280.600983] raid6test: test_disks(9, 10): faila=3D  9(D)  failb=3D 10(D)=
  OK
[  280.825299] raid6test: test_disks(9, 11): faila=3D  9(D)  failb=3D 11(D)=
  OK
[  281.146581] raid6test: test_disks(9, 12): faila=3D  9(D)  failb=3D 12(D)=
  OK
[  281.378119] raid6test: test_disks(9, 13): faila=3D  9(D)  failb=3D 13(D)=
  OK
[  281.679608] raid6test: test_disks(9, 14): faila=3D  9(D)  failb=3D 14(D)=
  OK
[  281.901209] raid6test: test_disks(9, 15): faila=3D  9(D)  failb=3D 15(D)=
  OK
[  282.142632] raid6test: test_disks(9, 16): faila=3D  9(D)  failb=3D 16(D)=
  OK
[  282.349151] raid6test: test_disks(9, 17): faila=3D  9(D)  failb=3D 17(D)=
  OK
[  282.657462] raid6test: test_disks(9, 18): faila=3D  9(D)  failb=3D 18(D)=
  OK
[  282.829762] raid6test: test_disks(9, 19): faila=3D  9(D)  failb=3D 19(D)=
  OK
[  283.051557] raid6test: test_disks(9, 20): faila=3D  9(D)  failb=3D 20(D)=
  OK
[  283.268468] raid6test: test_disks(9, 21): faila=3D  9(D)  failb=3D 21(D)=
  OK
[  283.485864] raid6test: test_disks(9, 22): faila=3D  9(D)  failb=3D 22(D)=
  OK
[  283.724983] raid6test: test_disks(9, 23): faila=3D  9(D)  failb=3D 23(D)=
  OK
[  283.921304] raid6test: test_disks(9, 24): faila=3D  9(D)  failb=3D 24(D)=
  OK
[  284.176120] raid6test: test_disks(9, 25): faila=3D  9(D)  failb=3D 25(D)=
  OK
[  284.492201] raid6test: test_disks(9, 26): faila=3D  9(D)  failb=3D 26(D)=
  OK
[  284.716075] raid6test: test_disks(9, 27): faila=3D  9(D)  failb=3D 27(D)=
  OK
[  284.960698] raid6test: test_disks(9, 28): faila=3D  9(D)  failb=3D 28(D)=
  OK
[  285.121748] raid6test: test_disks(9, 29): faila=3D  9(D)  failb=3D 29(D)=
  OK
[  285.352056] raid6test: test_disks(9, 30): faila=3D  9(D)  failb=3D 30(D)=
  OK
[  285.678124] raid6test: test_disks(9, 31): faila=3D  9(D)  failb=3D 31(D)=
  OK
[  285.980452] raid6test: test_disks(9, 32): faila=3D  9(D)  failb=3D 32(D)=
  OK
[  286.319260] raid6test: test_disks(9, 33): faila=3D  9(D)  failb=3D 33(D)=
  OK
[  286.627125] raid6test: test_disks(9, 34): faila=3D  9(D)  failb=3D 34(D)=
  OK
[  286.999169] raid6test: test_disks(9, 35): faila=3D  9(D)  failb=3D 35(D)=
  OK
[  287.290387] raid6test: test_disks(9, 36): faila=3D  9(D)  failb=3D 36(D)=
  OK
[  287.606672] raid6test: test_disks(9, 37): faila=3D  9(D)  failb=3D 37(D)=
  OK
[  287.906041] raid6test: test_disks(9, 38): faila=3D  9(D)  failb=3D 38(D)=
  OK
[  288.186503] raid6test: test_disks(9, 39): faila=3D  9(D)  failb=3D 39(D)=
  OK
[  288.489602] raid6test: test_disks(9, 40): faila=3D  9(D)  failb=3D 40(D)=
  OK
[  288.775085] raid6test: test_disks(9, 41): faila=3D  9(D)  failb=3D 41(D)=
  OK
[  289.071567] raid6test: test_disks(9, 42): faila=3D  9(D)  failb=3D 42(D)=
  OK
[  289.361744] raid6test: test_disks(9, 43): faila=3D  9(D)  failb=3D 43(D)=
  OK
[  289.649180] raid6test: test_disks(9, 44): faila=3D  9(D)  failb=3D 44(D)=
  OK
[  289.947189] raid6test: test_disks(9, 45): faila=3D  9(D)  failb=3D 45(D)=
  OK
[  290.227946] raid6test: test_disks(9, 46): faila=3D  9(D)  failb=3D 46(D)=
  OK
[  290.445234] raid6test: test_disks(9, 47): faila=3D  9(D)  failb=3D 47(D)=
  OK
[  290.599153] raid6test: test_disks(9, 48): faila=3D  9(D)  failb=3D 48(D)=
  OK
[  290.881216] raid6test: test_disks(9, 49): faila=3D  9(D)  failb=3D 49(D)=
  OK
[  291.179476] raid6test: test_disks(9, 50): faila=3D  9(D)  failb=3D 50(D)=
  OK
[  291.477533] raid6test: test_disks(9, 51): faila=3D  9(D)  failb=3D 51(D)=
  OK
[  291.762172] raid6test: test_disks(9, 52): faila=3D  9(D)  failb=3D 52(D)=
  OK
[  292.060818] raid6test: test_disks(9, 53): faila=3D  9(D)  failb=3D 53(D)=
  OK
[  292.360479] raid6test: test_disks(9, 54): faila=3D  9(D)  failb=3D 54(D)=
  OK
[  292.648665] raid6test: test_disks(9, 55): faila=3D  9(D)  failb=3D 55(D)=
  OK
[  292.935019] raid6test: test_disks(9, 56): faila=3D  9(D)  failb=3D 56(D)=
  OK
[  293.274800] raid6test: test_disks(9, 57): faila=3D  9(D)  failb=3D 57(D)=
  OK
[  293.535744] raid6test: test_disks(9, 58): faila=3D  9(D)  failb=3D 58(D)=
  OK
[  293.699806] raid6test: test_disks(9, 59): faila=3D  9(D)  failb=3D 59(D)=
  OK
[  293.849234] raid6test: test_disks(9, 60): faila=3D  9(D)  failb=3D 60(D)=
  OK
[  294.123685] raid6test: test_disks(9, 61): faila=3D  9(D)  failb=3D 61(D)=
  OK
[  294.430197] raid6test: test_disks(9, 62): faila=3D  9(D)  failb=3D 62(P)=
  OK
[  294.754586] raid6test: test_disks(9, 63): faila=3D  9(D)  failb=3D 63(Q)=
  OK
[  295.046428] raid6test: test_disks(10, 11): faila=3D 10(D)  failb=3D 11(D=
)  OK
[  295.363446] raid6test: test_disks(10, 12): faila=3D 10(D)  failb=3D 12(D=
)  OK
[  295.516602] raid6test: test_disks(10, 13): faila=3D 10(D)  failb=3D 13(D=
)  OK
[  295.696355] raid6test: test_disks(10, 14): faila=3D 10(D)  failb=3D 14(D=
)  OK
[  295.850093] raid6test: test_disks(10, 15): faila=3D 10(D)  failb=3D 15(D=
)  OK
[  296.170859] raid6test: test_disks(10, 16): faila=3D 10(D)  failb=3D 16(D=
)  OK
[  296.484005] raid6test: test_disks(10, 17): faila=3D 10(D)  failb=3D 17(D=
)  OK
[  296.803215] raid6test: test_disks(10, 18): faila=3D 10(D)  failb=3D 18(D=
)  OK
[  297.107379] raid6test: test_disks(10, 19): faila=3D 10(D)  failb=3D 19(D=
)  OK
[  297.403878] raid6test: test_disks(10, 20): faila=3D 10(D)  failb=3D 20(D=
)  OK
[  297.715672] raid6test: test_disks(10, 21): faila=3D 10(D)  failb=3D 21(D=
)  OK
[  298.023735] raid6test: test_disks(10, 22): faila=3D 10(D)  failb=3D 22(D=
)  OK
[  298.188888] raid6test: test_disks(10, 23): faila=3D 10(D)  failb=3D 23(D=
)  OK
[  298.520412] raid6test: test_disks(10, 24): faila=3D 10(D)  failb=3D 24(D=
)  OK
[  298.834926] raid6test: test_disks(10, 25): faila=3D 10(D)  failb=3D 25(D=
)  OK
[  299.161373] raid6test: test_disks(10, 26): faila=3D 10(D)  failb=3D 26(D=
)  OK
[  299.454684] raid6test: test_disks(10, 27): faila=3D 10(D)  failb=3D 27(D=
)  OK
[  299.773985] raid6test: test_disks(10, 28): faila=3D 10(D)  failb=3D 28(D=
)  OK
[  300.044416] raid6test: test_disks(10, 29): faila=3D 10(D)  failb=3D 29(D=
)  OK
[  300.192858] raid6test: test_disks(10, 30): faila=3D 10(D)  failb=3D 30(D=
)  OK
[  300.345256] raid6test: test_disks(10, 31): faila=3D 10(D)  failb=3D 31(D=
)  OK
[  300.500243] raid6test: test_disks(10, 32): faila=3D 10(D)  failb=3D 32(D=
)  OK
[  300.676229] raid6test: test_disks(10, 33): faila=3D 10(D)  failb=3D 33(D=
)  OK
[  300.852553] raid6test: test_disks(10, 34): faila=3D 10(D)  failb=3D 34(D=
)  OK
[  301.003050] raid6test: test_disks(10, 35): faila=3D 10(D)  failb=3D 35(D=
)  OK
[  301.193856] raid6test: test_disks(10, 36): faila=3D 10(D)  failb=3D 36(D=
)  OK
[  301.513401] raid6test: test_disks(10, 37): faila=3D 10(D)  failb=3D 37(D=
)  OK
[  301.823489] raid6test: test_disks(10, 38): faila=3D 10(D)  failb=3D 38(D=
)  OK
[  302.077551] raid6test: test_disks(10, 39): faila=3D 10(D)  failb=3D 39(D=
)  OK
[  302.250484] raid6test: test_disks(10, 40): faila=3D 10(D)  failb=3D 40(D=
)  OK
[  302.403521] raid6test: test_disks(10, 41): faila=3D 10(D)  failb=3D 41(D=
)  OK
[  302.563116] raid6test: test_disks(10, 42): faila=3D 10(D)  failb=3D 42(D=
)  OK
[  302.720156] raid6test: test_disks(10, 43): faila=3D 10(D)  failb=3D 43(D=
)  OK
[  302.873832] raid6test: test_disks(10, 44): faila=3D 10(D)  failb=3D 44(D=
)  OK
[  303.040980] raid6test: test_disks(10, 45): faila=3D 10(D)  failb=3D 45(D=
)  OK
[  303.191639] raid6test: test_disks(10, 46): faila=3D 10(D)  failb=3D 46(D=
)  OK
[  303.488451] raid6test: test_disks(10, 47): faila=3D 10(D)  failb=3D 47(D=
)  OK
[  303.794511] raid6test: test_disks(10, 48): faila=3D 10(D)  failb=3D 48(D=
)  OK
[  304.106066] raid6test: test_disks(10, 49): faila=3D 10(D)  failb=3D 49(D=
)  OK
[  304.406487] raid6test: test_disks(10, 50): faila=3D 10(D)  failb=3D 50(D=
)  OK
[  304.704107] raid6test: test_disks(10, 51): faila=3D 10(D)  failb=3D 51(D=
)  OK
[  304.878299] raid6test: test_disks(10, 52): faila=3D 10(D)  failb=3D 52(D=
)  OK
[  305.026365] raid6test: test_disks(10, 53): faila=3D 10(D)  failb=3D 53(D=
)  OK
[  305.300960] raid6test: test_disks(10, 54): faila=3D 10(D)  failb=3D 54(D=
)  OK
[  305.578063] raid6test: test_disks(10, 55): faila=3D 10(D)  failb=3D 55(D=
)  OK
[  305.799873] raid6test: test_disks(10, 56): faila=3D 10(D)  failb=3D 56(D=
)  OK
[  306.049348] raid6test: test_disks(10, 57): faila=3D 10(D)  failb=3D 57(D=
)  OK
[  306.286410] raid6test: test_disks(10, 58): faila=3D 10(D)  failb=3D 58(D=
)  OK
[  306.582635] raid6test: test_disks(10, 59): faila=3D 10(D)  failb=3D 59(D=
)  OK
[  306.845872] raid6test: test_disks(10, 60): faila=3D 10(D)  failb=3D 60(D=
)  OK
[  306.997457] raid6test: test_disks(10, 61): faila=3D 10(D)  failb=3D 61(D=
)  OK
[  307.197849] raid6test: test_disks(10, 62): faila=3D 10(D)  failb=3D 62(P=
)  OK
[  307.518815] raid6test: test_disks(10, 63): faila=3D 10(D)  failb=3D 63(Q=
)  OK
[  307.827758] raid6test: test_disks(11, 12): faila=3D 11(D)  failb=3D 12(D=
)  OK
[  308.123699] raid6test: test_disks(11, 13): faila=3D 11(D)  failb=3D 13(D=
)  OK
[  308.338323] raid6test: test_disks(11, 14): faila=3D 11(D)  failb=3D 14(D=
)  OK
[  308.602408] raid6test: test_disks(11, 15): faila=3D 11(D)  failb=3D 15(D=
)  OK
[  308.919412] raid6test: test_disks(11, 16): faila=3D 11(D)  failb=3D 16(D=
)  OK
[  309.110663] raid6test: test_disks(11, 17): faila=3D 11(D)  failb=3D 17(D=
)  OK
[  309.373337] raid6test: test_disks(11, 18): faila=3D 11(D)  failb=3D 18(D=
)  OK
[  309.681286] raid6test: test_disks(11, 19): faila=3D 11(D)  failb=3D 19(D=
)  OK
[  309.969449] raid6test: test_disks(11, 20): faila=3D 11(D)  failb=3D 20(D=
)  OK
[  310.288851] raid6test: test_disks(11, 21): faila=3D 11(D)  failb=3D 21(D=
)  OK
[  310.551031] raid6test: test_disks(11, 22): faila=3D 11(D)  failb=3D 22(D=
)  OK
[  310.850702] raid6test: test_disks(11, 23): faila=3D 11(D)  failb=3D 23(D=
)  OK
[  311.115858] raid6test: test_disks(11, 24): faila=3D 11(D)  failb=3D 24(D=
)  OK
[  311.320165] raid6test: test_disks(11, 25): faila=3D 11(D)  failb=3D 25(D=
)  OK
[  311.550121] raid6test: test_disks(11, 26): faila=3D 11(D)  failb=3D 26(D=
)  OK
[  311.756904] raid6test: test_disks(11, 27): faila=3D 11(D)  failb=3D 27(D=
)  OK
[  312.003760] raid6test: test_disks(11, 28): faila=3D 11(D)  failb=3D 28(D=
)  OK
[  312.219316] raid6test: test_disks(11, 29): faila=3D 11(D)  failb=3D 29(D=
)  OK
[  312.417211] raid6test: test_disks(11, 30): faila=3D 11(D)  failb=3D 30(D=
)  OK
[  312.596632] raid6test: test_disks(11, 31): faila=3D 11(D)  failb=3D 31(D=
)  OK
[  312.833422] raid6test: test_disks(11, 32): faila=3D 11(D)  failb=3D 32(D=
)  OK
[  313.042984] raid6test: test_disks(11, 33): faila=3D 11(D)  failb=3D 33(D=
)  OK
[  313.363823] raid6test: test_disks(11, 34): faila=3D 11(D)  failb=3D 34(D=
)  OK
[  313.665042] raid6test: test_disks(11, 35): faila=3D 11(D)  failb=3D 35(D=
)  OK
[  313.972101] raid6test: test_disks(11, 36): faila=3D 11(D)  failb=3D 36(D=
)  OK
[  314.280627] raid6test: test_disks(11, 37): faila=3D 11(D)  failb=3D 37(D=
)  OK
[  314.593919] raid6test: test_disks(11, 38): faila=3D 11(D)  failb=3D 38(D=
)  OK
[  314.901355] raid6test: test_disks(11, 39): faila=3D 11(D)  failb=3D 39(D=
)  OK
[  315.200564] raid6test: test_disks(11, 40): faila=3D 11(D)  failb=3D 40(D=
)  OK
[  315.514385] raid6test: test_disks(11, 41): faila=3D 11(D)  failb=3D 41(D=
)  OK
[  315.798634] raid6test: test_disks(11, 42): faila=3D 11(D)  failb=3D 42(D=
)  OK
[  315.949161] raid6test: test_disks(11, 43): faila=3D 11(D)  failb=3D 43(D=
)  OK
[  316.095812] raid6test: test_disks(11, 44): faila=3D 11(D)  failb=3D 44(D=
)  OK
[  316.242781] raid6test: test_disks(11, 45): faila=3D 11(D)  failb=3D 45(D=
)  OK
[  316.388903] raid6test: test_disks(11, 46): faila=3D 11(D)  failb=3D 46(D=
)  OK
[  316.531799] raid6test: test_disks(11, 47): faila=3D 11(D)  failb=3D 47(D=
)  OK
[  316.675324] raid6test: test_disks(11, 48): faila=3D 11(D)  failb=3D 48(D=
)  OK
[  316.822323] raid6test: test_disks(11, 49): faila=3D 11(D)  failb=3D 49(D=
)  OK
[  316.979089] raid6test: test_disks(11, 50): faila=3D 11(D)  failb=3D 50(D=
)  OK
[  317.126670] raid6test: test_disks(11, 51): faila=3D 11(D)  failb=3D 51(D=
)  OK
[  317.272383] raid6test: test_disks(11, 52): faila=3D 11(D)  failb=3D 52(D=
)  OK
[  317.415860] raid6test: test_disks(11, 53): faila=3D 11(D)  failb=3D 53(D=
)  OK
[  317.557804] raid6test: test_disks(11, 54): faila=3D 11(D)  failb=3D 54(D=
)  OK
[  317.776730] raid6test: test_disks(11, 55): faila=3D 11(D)  failb=3D 55(D=
)  OK
[  317.967490] raid6test: test_disks(11, 56): faila=3D 11(D)  failb=3D 56(D=
)  OK
[  318.243366] raid6test: test_disks(11, 57): faila=3D 11(D)  failb=3D 57(D=
)  OK
[  318.406511] raid6test: test_disks(11, 58): faila=3D 11(D)  failb=3D 58(D=
)  OK
[  318.550535] raid6test: test_disks(11, 59): faila=3D 11(D)  failb=3D 59(D=
)  OK
[  318.744464] raid6test: test_disks(11, 60): faila=3D 11(D)  failb=3D 60(D=
)  OK
[  318.964165] raid6test: test_disks(11, 61): faila=3D 11(D)  failb=3D 61(D=
)  OK
[  319.100774] raid6test: test_disks(11, 62): faila=3D 11(D)  failb=3D 62(P=
)  OK
[  319.242333] raid6test: test_disks(11, 63): faila=3D 11(D)  failb=3D 63(Q=
)  OK
[  319.385269] raid6test: test_disks(12, 13): faila=3D 12(D)  failb=3D 13(D=
)  OK
[  319.527940] raid6test: test_disks(12, 14): faila=3D 12(D)  failb=3D 14(D=
)  OK
[  319.759485] raid6test: test_disks(12, 15): faila=3D 12(D)  failb=3D 15(D=
)  OK
[  319.934063] raid6test: test_disks(12, 16): faila=3D 12(D)  failb=3D 16(D=
)  OK
[  320.075187] raid6test: test_disks(12, 17): faila=3D 12(D)  failb=3D 17(D=
)  OK
[  320.217632] raid6test: test_disks(12, 18): faila=3D 12(D)  failb=3D 18(D=
)  OK
[  320.410587] raid6test: test_disks(12, 19): faila=3D 12(D)  failb=3D 19(D=
)  OK
[  320.564675] raid6test: test_disks(12, 20): faila=3D 12(D)  failb=3D 20(D=
)  OK
[  320.848629] raid6test: test_disks(12, 21): faila=3D 12(D)  failb=3D 21(D=
)  OK
[  321.096682] raid6test: test_disks(12, 22): faila=3D 12(D)  failb=3D 22(D=
)  OK
[  321.244601] raid6test: test_disks(12, 23): faila=3D 12(D)  failb=3D 23(D=
)  OK
[  321.422405] raid6test: test_disks(12, 24): faila=3D 12(D)  failb=3D 24(D=
)  OK
[  321.608580] raid6test: test_disks(12, 25): faila=3D 12(D)  failb=3D 25(D=
)  OK
[  321.891144] raid6test: test_disks(12, 26): faila=3D 12(D)  failb=3D 26(D=
)  OK
[  322.095702] raid6test: test_disks(12, 27): faila=3D 12(D)  failb=3D 27(D=
)  OK
[  322.390896] raid6test: test_disks(12, 28): faila=3D 12(D)  failb=3D 28(D=
)  OK
[  322.692115] raid6test: test_disks(12, 29): faila=3D 12(D)  failb=3D 29(D=
)  OK
[  322.967416] raid6test: test_disks(12, 30): faila=3D 12(D)  failb=3D 30(D=
)  OK
[  323.181629] raid6test: test_disks(12, 31): faila=3D 12(D)  failb=3D 31(D=
)  OK
[  323.486377] raid6test: test_disks(12, 32): faila=3D 12(D)  failb=3D 32(D=
)  OK
[  323.786103] raid6test: test_disks(12, 33): faila=3D 12(D)  failb=3D 33(D=
)  OK
[  324.034539] raid6test: test_disks(12, 34): faila=3D 12(D)  failb=3D 34(D=
)  OK
[  324.194251] raid6test: test_disks(12, 35): faila=3D 12(D)  failb=3D 35(D=
)  OK
[  324.400537] raid6test: test_disks(12, 36): faila=3D 12(D)  failb=3D 36(D=
)  OK
[  324.680905] raid6test: test_disks(12, 37): faila=3D 12(D)  failb=3D 37(D=
)  OK
[  324.899461] raid6test: test_disks(12, 38): faila=3D 12(D)  failb=3D 38(D=
)  OK
[  325.057696] raid6test: test_disks(12, 39): faila=3D 12(D)  failb=3D 39(D=
)  OK
[  325.279882] raid6test: test_disks(12, 40): faila=3D 12(D)  failb=3D 40(D=
)  OK
[  325.508976] raid6test: test_disks(12, 41): faila=3D 12(D)  failb=3D 41(D=
)  OK
[  325.713768] raid6test: test_disks(12, 42): faila=3D 12(D)  failb=3D 42(D=
)  OK
[  325.933604] raid6test: test_disks(12, 43): faila=3D 12(D)  failb=3D 43(D=
)  OK
[  326.098741] raid6test: test_disks(12, 44): faila=3D 12(D)  failb=3D 44(D=
)  OK
[  326.263891] raid6test: test_disks(12, 45): faila=3D 12(D)  failb=3D 45(D=
)  OK
[  326.590130] raid6test: test_disks(12, 46): faila=3D 12(D)  failb=3D 46(D=
)  OK
[  326.871164] raid6test: test_disks(12, 47): faila=3D 12(D)  failb=3D 47(D=
)  OK
[  327.188047] raid6test: test_disks(12, 48): faila=3D 12(D)  failb=3D 48(D=
)  OK
[  327.471438] raid6test: test_disks(12, 49): faila=3D 12(D)  failb=3D 49(D=
)  OK
[  327.761319] raid6test: test_disks(12, 50): faila=3D 12(D)  failb=3D 50(D=
)  OK
[  328.061802] raid6test: test_disks(12, 51): faila=3D 12(D)  failb=3D 51(D=
)  OK
[  328.343905] raid6test: test_disks(12, 52): faila=3D 12(D)  failb=3D 52(D=
)  OK
[  328.645075] raid6test: test_disks(12, 53): faila=3D 12(D)  failb=3D 53(D=
)  OK
[  328.910664] raid6test: test_disks(12, 54): faila=3D 12(D)  failb=3D 54(D=
)  OK
[  329.222266] raid6test: test_disks(12, 55): faila=3D 12(D)  failb=3D 55(D=
)  OK
[  329.534686] raid6test: test_disks(12, 56): faila=3D 12(D)  failb=3D 56(D=
)  OK
[  329.826639] raid6test: test_disks(12, 57): faila=3D 12(D)  failb=3D 57(D=
)  OK
[  330.040868] raid6test: test_disks(12, 58): faila=3D 12(D)  failb=3D 58(D=
)  OK
[  330.318218] raid6test: test_disks(12, 59): faila=3D 12(D)  failb=3D 59(D=
)  OK
[  330.577882] raid6test: test_disks(12, 60): faila=3D 12(D)  failb=3D 60(D=
)  OK
[  330.792695] raid6test: test_disks(12, 61): faila=3D 12(D)  failb=3D 61(D=
)  OK
[  331.065105] raid6test: test_disks(12, 62): faila=3D 12(D)  failb=3D 62(P=
)  OK
[  331.362102] raid6test: test_disks(12, 63): faila=3D 12(D)  failb=3D 63(Q=
)  OK
[  331.618881] raid6test: test_disks(13, 14): faila=3D 13(D)  failb=3D 14(D=
)  OK
[  331.833756] raid6test: test_disks(13, 15): faila=3D 13(D)  failb=3D 15(D=
)  OK
[  332.130086] raid6test: test_disks(13, 16): faila=3D 13(D)  failb=3D 16(D=
)  OK
[  332.449235] raid6test: test_disks(13, 17): faila=3D 13(D)  failb=3D 17(D=
)  OK
[  332.784909] raid6test: test_disks(13, 18): faila=3D 13(D)  failb=3D 18(D=
)  OK
[  333.105637] raid6test: test_disks(13, 19): faila=3D 13(D)  failb=3D 19(D=
)  OK
[  333.427838] raid6test: test_disks(13, 20): faila=3D 13(D)  failb=3D 20(D=
)  OK
[  333.760921] raid6test: test_disks(13, 21): faila=3D 13(D)  failb=3D 21(D=
)  OK
[  334.071867] raid6test: test_disks(13, 22): faila=3D 13(D)  failb=3D 22(D=
)  OK
[  334.390300] raid6test: test_disks(13, 23): faila=3D 13(D)  failb=3D 23(D=
)  OK
[  334.694157] raid6test: test_disks(13, 24): faila=3D 13(D)  failb=3D 24(D=
)  OK
[  334.999466] raid6test: test_disks(13, 25): faila=3D 13(D)  failb=3D 25(D=
)  OK
[  335.313739] raid6test: test_disks(13, 26): faila=3D 13(D)  failb=3D 26(D=
)  OK
[  335.632906] raid6test: test_disks(13, 27): faila=3D 13(D)  failb=3D 27(D=
)  OK
[  335.937679] raid6test: test_disks(13, 28): faila=3D 13(D)  failb=3D 28(D=
)  OK
[  336.253913] raid6test: test_disks(13, 29): faila=3D 13(D)  failb=3D 29(D=
)  OK
[  336.575669] raid6test: test_disks(13, 30): faila=3D 13(D)  failb=3D 30(D=
)  OK
[  336.873536] raid6test: test_disks(13, 31): faila=3D 13(D)  failb=3D 31(D=
)  OK
[  337.170102] raid6test: test_disks(13, 32): faila=3D 13(D)  failb=3D 32(D=
)  OK
[  337.484076] raid6test: test_disks(13, 33): faila=3D 13(D)  failb=3D 33(D=
)  OK
[  337.800181] raid6test: test_disks(13, 34): faila=3D 13(D)  failb=3D 34(D=
)  OK
[  337.958610] raid6test: test_disks(13, 35): faila=3D 13(D)  failb=3D 35(D=
)  OK
[  338.113531] raid6test: test_disks(13, 36): faila=3D 13(D)  failb=3D 36(D=
)  OK
[  338.269823] raid6test: test_disks(13, 37): faila=3D 13(D)  failb=3D 37(D=
)  OK
[  338.431743] raid6test: test_disks(13, 38): faila=3D 13(D)  failb=3D 38(D=
)  OK
[  338.588438] raid6test: test_disks(13, 39): faila=3D 13(D)  failb=3D 39(D=
)  OK
[  338.744418] raid6test: test_disks(13, 40): faila=3D 13(D)  failb=3D 40(D=
)  OK
[  338.896701] raid6test: test_disks(13, 41): faila=3D 13(D)  failb=3D 41(D=
)  OK
[  339.125694] raid6test: test_disks(13, 42): faila=3D 13(D)  failb=3D 42(D=
)  OK
[  339.288532] raid6test: test_disks(13, 43): faila=3D 13(D)  failb=3D 43(D=
)  OK
[  339.433659] raid6test: test_disks(13, 44): faila=3D 13(D)  failb=3D 44(D=
)  OK
[  339.599567] raid6test: test_disks(13, 45): faila=3D 13(D)  failb=3D 45(D=
)  OK
[  339.807029] raid6test: test_disks(13, 46): faila=3D 13(D)  failb=3D 46(D=
)  OK
[  340.088526] raid6test: test_disks(13, 47): faila=3D 13(D)  failb=3D 47(D=
)  OK
[  340.376373] raid6test: test_disks(13, 48): faila=3D 13(D)  failb=3D 48(D=
)  OK
[  340.529443] raid6test: test_disks(13, 49): faila=3D 13(D)  failb=3D 49(D=
)  OK
[  340.719479] raid6test: test_disks(13, 50): faila=3D 13(D)  failb=3D 50(D=
)  OK
[  340.923798] raid6test: test_disks(13, 51): faila=3D 13(D)  failb=3D 51(D=
)  OK
[  341.064220] raid6test: test_disks(13, 52): faila=3D 13(D)  failb=3D 52(D=
)  OK
[  341.210869] raid6test: test_disks(13, 53): faila=3D 13(D)  failb=3D 53(D=
)  OK
[  341.366593] raid6test: test_disks(13, 54): faila=3D 13(D)  failb=3D 54(D=
)  OK
[  341.505766] raid6test: test_disks(13, 55): faila=3D 13(D)  failb=3D 55(D=
)  OK
[  341.643350] raid6test: test_disks(13, 56): faila=3D 13(D)  failb=3D 56(D=
)  OK
[  341.849290] raid6test: test_disks(13, 57): faila=3D 13(D)  failb=3D 57(D=
)  OK
[  342.135014] raid6test: test_disks(13, 58): faila=3D 13(D)  failb=3D 58(D=
)  OK
[  342.409032] raid6test: test_disks(13, 59): faila=3D 13(D)  failb=3D 59(D=
)  OK
[  342.693352] raid6test: test_disks(13, 60): faila=3D 13(D)  failb=3D 60(D=
)  OK
[  342.969975] raid6test: test_disks(13, 61): faila=3D 13(D)  failb=3D 61(D=
)  OK
[  343.162086] raid6test: test_disks(13, 62): faila=3D 13(D)  failb=3D 62(P=
)  OK
[  343.449370] raid6test: test_disks(13, 63): faila=3D 13(D)  failb=3D 63(Q=
)  OK
[  343.730528] raid6test: test_disks(14, 15): faila=3D 14(D)  failb=3D 15(D=
)  OK
[  344.024730] raid6test: test_disks(14, 16): faila=3D 14(D)  failb=3D 16(D=
)  OK
[  344.310979] raid6test: test_disks(14, 17): faila=3D 14(D)  failb=3D 17(D=
)  OK
[  344.536824] raid6test: test_disks(14, 18): faila=3D 14(D)  failb=3D 18(D=
)  OK
[  344.679324] raid6test: test_disks(14, 19): faila=3D 14(D)  failb=3D 19(D=
)  OK
[  344.826375] raid6test: test_disks(14, 20): faila=3D 14(D)  failb=3D 20(D=
)  OK
[  345.120412] raid6test: test_disks(14, 21): faila=3D 14(D)  failb=3D 21(D=
)  OK
[  345.420364] raid6test: test_disks(14, 22): faila=3D 14(D)  failb=3D 22(D=
)  OK
[  345.718976] raid6test: test_disks(14, 23): faila=3D 14(D)  failb=3D 23(D=
)  OK
[  345.937271] raid6test: test_disks(14, 24): faila=3D 14(D)  failb=3D 24(D=
)  OK
[  346.121908] raid6test: test_disks(14, 25): faila=3D 14(D)  failb=3D 25(D=
)  OK
[  346.274246] raid6test: test_disks(14, 26): faila=3D 14(D)  failb=3D 26(D=
)  OK
[  346.548694] raid6test: test_disks(14, 27): faila=3D 14(D)  failb=3D 27(D=
)  OK
[  346.845617] raid6test: test_disks(14, 28): faila=3D 14(D)  failb=3D 28(D=
)  OK
[  347.145753] raid6test: test_disks(14, 29): faila=3D 14(D)  failb=3D 29(D=
)  OK
[  347.452835] raid6test: test_disks(14, 30): faila=3D 14(D)  failb=3D 30(D=
)  OK
[  347.757406] raid6test: test_disks(14, 31): faila=3D 14(D)  failb=3D 31(D=
)  OK
[  348.047354] raid6test: test_disks(14, 32): faila=3D 14(D)  failb=3D 32(D=
)  OK
[  348.366744] raid6test: test_disks(14, 33): faila=3D 14(D)  failb=3D 33(D=
)  OK
[  348.668923] raid6test: test_disks(14, 34): faila=3D 14(D)  failb=3D 34(D=
)  OK
[  348.976615] raid6test: test_disks(14, 35): faila=3D 14(D)  failb=3D 35(D=
)  OK
[  349.280517] raid6test: test_disks(14, 36): faila=3D 14(D)  failb=3D 36(D=
)  OK
[  349.490093] raid6test: test_disks(14, 37): faila=3D 14(D)  failb=3D 37(D=
)  OK
[  349.734899] raid6test: test_disks(14, 38): faila=3D 14(D)  failb=3D 38(D=
)  OK
[  349.935757] raid6test: test_disks(14, 39): faila=3D 14(D)  failb=3D 39(D=
)  OK
[  350.225782] raid6test: test_disks(14, 40): faila=3D 14(D)  failb=3D 40(D=
)  OK
[  350.447057] raid6test: test_disks(14, 41): faila=3D 14(D)  failb=3D 41(D=
)  OK
[  350.761389] raid6test: test_disks(14, 42): faila=3D 14(D)  failb=3D 42(D=
)  OK
[  351.050358] raid6test: test_disks(14, 43): faila=3D 14(D)  failb=3D 43(D=
)  OK
[  351.240912] raid6test: test_disks(14, 44): faila=3D 14(D)  failb=3D 44(D=
)  OK
[  351.415775] raid6test: test_disks(14, 45): faila=3D 14(D)  failb=3D 45(D=
)  OK
[  351.707978] raid6test: test_disks(14, 46): faila=3D 14(D)  failb=3D 46(D=
)  OK
[  351.859919] raid6test: test_disks(14, 47): faila=3D 14(D)  failb=3D 47(D=
)  OK
[  352.113029] raid6test: test_disks(14, 48): faila=3D 14(D)  failb=3D 48(D=
)  OK
[  352.274687] raid6test: test_disks(14, 49): faila=3D 14(D)  failb=3D 49(D=
)  OK
[  352.435888] raid6test: test_disks(14, 50): faila=3D 14(D)  failb=3D 50(D=
)  OK
[  352.595391] raid6test: test_disks(14, 51): faila=3D 14(D)  failb=3D 51(D=
)  OK
[  352.760364] raid6test: test_disks(14, 52): faila=3D 14(D)  failb=3D 52(D=
)  OK
[  352.918032] raid6test: test_disks(14, 53): faila=3D 14(D)  failb=3D 53(D=
)  OK
[  353.106678] raid6test: test_disks(14, 54): faila=3D 14(D)  failb=3D 54(D=
)  OK
[  353.263019] raid6test: test_disks(14, 55): faila=3D 14(D)  failb=3D 55(D=
)  OK
[  353.422227] raid6test: test_disks(14, 56): faila=3D 14(D)  failb=3D 56(D=
)  OK
[  353.615719] raid6test: test_disks(14, 57): faila=3D 14(D)  failb=3D 57(D=
)  OK
[  353.830518] raid6test: test_disks(14, 58): faila=3D 14(D)  failb=3D 58(D=
)  OK
[  354.132606] raid6test: test_disks(14, 59): faila=3D 14(D)  failb=3D 59(D=
)  OK
[  354.341479] raid6test: test_disks(14, 60): faila=3D 14(D)  failb=3D 60(D=
)  OK
[  354.562455] raid6test: test_disks(14, 61): faila=3D 14(D)  failb=3D 61(D=
)  OK
[  354.715713] raid6test: test_disks(14, 62): faila=3D 14(D)  failb=3D 62(P=
)  OK
[  354.922133] raid6test: test_disks(14, 63): faila=3D 14(D)  failb=3D 63(Q=
)  OK
[  355.120474] raid6test: test_disks(15, 16): faila=3D 15(D)  failb=3D 16(D=
)  OK
[  355.303472] raid6test: test_disks(15, 17): faila=3D 15(D)  failb=3D 17(D=
)  OK
[  355.541701] raid6test: test_disks(15, 18): faila=3D 15(D)  failb=3D 18(D=
)  OK
[  355.699985] raid6test: test_disks(15, 19): faila=3D 15(D)  failb=3D 19(D=
)  OK
[  355.923833] raid6test: test_disks(15, 20): faila=3D 15(D)  failb=3D 20(D=
)  OK
[  356.080075] raid6test: test_disks(15, 21): faila=3D 15(D)  failb=3D 21(D=
)  OK
[  356.334163] raid6test: test_disks(15, 22): faila=3D 15(D)  failb=3D 22(D=
)  OK
[  356.488139] raid6test: test_disks(15, 23): faila=3D 15(D)  failb=3D 23(D=
)  OK
[  356.655988] raid6test: test_disks(15, 24): faila=3D 15(D)  failb=3D 24(D=
)  OK
[  356.907124] raid6test: test_disks(15, 25): faila=3D 15(D)  failb=3D 25(D=
)  OK
[  357.058565] raid6test: test_disks(15, 26): faila=3D 15(D)  failb=3D 26(D=
)  OK
[  357.299522] raid6test: test_disks(15, 27): faila=3D 15(D)  failb=3D 27(D=
)  OK
[  357.459213] raid6test: test_disks(15, 28): faila=3D 15(D)  failb=3D 28(D=
)  OK
[  357.662385] raid6test: test_disks(15, 29): faila=3D 15(D)  failb=3D 29(D=
)  OK
[  357.952690] raid6test: test_disks(15, 30): faila=3D 15(D)  failb=3D 30(D=
)  OK
[  358.276567] raid6test: test_disks(15, 31): faila=3D 15(D)  failb=3D 31(D=
)  OK
[  358.581843] raid6test: test_disks(15, 32): faila=3D 15(D)  failb=3D 32(D=
)  OK
[  358.882980] raid6test: test_disks(15, 33): faila=3D 15(D)  failb=3D 33(D=
)  OK
[  359.182792] raid6test: test_disks(15, 34): faila=3D 15(D)  failb=3D 34(D=
)  OK
[  359.498027] raid6test: test_disks(15, 35): faila=3D 15(D)  failb=3D 35(D=
)  OK
[  359.776911] raid6test: test_disks(15, 36): faila=3D 15(D)  failb=3D 36(D=
)  OK
[  359.931036] raid6test: test_disks(15, 37): faila=3D 15(D)  failb=3D 37(D=
)  OK
[  360.151862] raid6test: test_disks(15, 38): faila=3D 15(D)  failb=3D 38(D=
)  OK
[  360.308179] raid6test: test_disks(15, 39): faila=3D 15(D)  failb=3D 39(D=
)  OK
[  360.497103] raid6test: test_disks(15, 40): faila=3D 15(D)  failb=3D 40(D=
)  OK
[  360.666318] raid6test: test_disks(15, 41): faila=3D 15(D)  failb=3D 41(D=
)  OK
[  360.965065] raid6test: test_disks(15, 42): faila=3D 15(D)  failb=3D 42(D=
)  OK
[  361.266625] raid6test: test_disks(15, 43): faila=3D 15(D)  failb=3D 43(D=
)  OK
[  361.582762] raid6test: test_disks(15, 44): faila=3D 15(D)  failb=3D 44(D=
)  OK
[  361.882451] raid6test: test_disks(15, 45): faila=3D 15(D)  failb=3D 45(D=
)  OK
[  362.050870] raid6test: test_disks(15, 46): faila=3D 15(D)  failb=3D 46(D=
)  OK
[  362.266475] raid6test: test_disks(15, 47): faila=3D 15(D)  failb=3D 47(D=
)  OK
[  362.416066] raid6test: test_disks(15, 48): faila=3D 15(D)  failb=3D 48(D=
)  OK
[  362.634053] raid6test: test_disks(15, 49): faila=3D 15(D)  failb=3D 49(D=
)  OK
[  362.824463] raid6test: test_disks(15, 50): faila=3D 15(D)  failb=3D 50(D=
)  OK
[  363.037630] raid6test: test_disks(15, 51): faila=3D 15(D)  failb=3D 51(D=
)  OK
[  363.228029] raid6test: test_disks(15, 52): faila=3D 15(D)  failb=3D 52(D=
)  OK
[  363.386279] raid6test: test_disks(15, 53): faila=3D 15(D)  failb=3D 53(D=
)  OK
[  363.619309] raid6test: test_disks(15, 54): faila=3D 15(D)  failb=3D 54(D=
)  OK
[  363.900225] raid6test: test_disks(15, 55): faila=3D 15(D)  failb=3D 55(D=
)  OK
[  364.205955] raid6test: test_disks(15, 56): faila=3D 15(D)  failb=3D 56(D=
)  OK
[  364.503076] raid6test: test_disks(15, 57): faila=3D 15(D)  failb=3D 57(D=
)  OK
[  364.685444] raid6test: test_disks(15, 58): faila=3D 15(D)  failb=3D 58(D=
)  OK
[  364.842428] raid6test: test_disks(15, 59): faila=3D 15(D)  failb=3D 59(D=
)  OK
[  365.012466] raid6test: test_disks(15, 60): faila=3D 15(D)  failb=3D 60(D=
)  OK
[  365.303396] raid6test: test_disks(15, 61): faila=3D 15(D)  failb=3D 61(D=
)  OK
[  365.597721] raid6test: test_disks(15, 62): faila=3D 15(D)  failb=3D 62(P=
)  OK
[  365.783430] raid6test: test_disks(15, 63): faila=3D 15(D)  failb=3D 63(Q=
)  OK
[  366.021272] raid6test: test_disks(16, 17): faila=3D 16(D)  failb=3D 17(D=
)  OK
[  366.237905] raid6test: test_disks(16, 18): faila=3D 16(D)  failb=3D 18(D=
)  OK
[  366.457532] raid6test: test_disks(16, 19): faila=3D 16(D)  failb=3D 19(D=
)  OK
[  366.721358] raid6test: test_disks(16, 20): faila=3D 16(D)  failb=3D 20(D=
)  OK
[  366.920683] raid6test: test_disks(16, 21): faila=3D 16(D)  failb=3D 21(D=
)  OK
[  367.155293] raid6test: test_disks(16, 22): faila=3D 16(D)  failb=3D 22(D=
)  OK
[  367.340892] raid6test: test_disks(16, 23): faila=3D 16(D)  failb=3D 23(D=
)  OK
[  367.498797] raid6test: test_disks(16, 24): faila=3D 16(D)  failb=3D 24(D=
)  OK
[  367.657354] raid6test: test_disks(16, 25): faila=3D 16(D)  failb=3D 25(D=
)  OK
[  367.814397] raid6test: test_disks(16, 26): faila=3D 16(D)  failb=3D 26(D=
)  OK
[  367.972376] raid6test: test_disks(16, 27): faila=3D 16(D)  failb=3D 27(D=
)  OK
[  368.165982] raid6test: test_disks(16, 28): faila=3D 16(D)  failb=3D 28(D=
)  OK
[  368.329238] raid6test: test_disks(16, 29): faila=3D 16(D)  failb=3D 29(D=
)  OK
[  368.490563] raid6test: test_disks(16, 30): faila=3D 16(D)  failb=3D 30(D=
)  OK
[  368.644771] raid6test: test_disks(16, 31): faila=3D 16(D)  failb=3D 31(D=
)  OK
[  368.798282] raid6test: test_disks(16, 32): faila=3D 16(D)  failb=3D 32(D=
)  OK
[  369.074424] raid6test: test_disks(16, 33): faila=3D 16(D)  failb=3D 33(D=
)  OK
[  369.252363] raid6test: test_disks(16, 34): faila=3D 16(D)  failb=3D 34(D=
)  OK
[  369.408969] raid6test: test_disks(16, 35): faila=3D 16(D)  failb=3D 35(D=
)  OK
[  369.569944] raid6test: test_disks(16, 36): faila=3D 16(D)  failb=3D 36(D=
)  OK
[  369.724775] raid6test: test_disks(16, 37): faila=3D 16(D)  failb=3D 37(D=
)  OK
[  369.880521] raid6test: test_disks(16, 38): faila=3D 16(D)  failb=3D 38(D=
)  OK
[  370.033138] raid6test: test_disks(16, 39): faila=3D 16(D)  failb=3D 39(D=
)  OK
[  370.313162] raid6test: test_disks(16, 40): faila=3D 16(D)  failb=3D 40(D=
)  OK
[  370.467190] raid6test: test_disks(16, 41): faila=3D 16(D)  failb=3D 41(D=
)  OK
[  370.620719] raid6test: test_disks(16, 42): faila=3D 16(D)  failb=3D 42(D=
)  OK
[  370.771795] raid6test: test_disks(16, 43): faila=3D 16(D)  failb=3D 43(D=
)  OK
[  370.928021] raid6test: test_disks(16, 44): faila=3D 16(D)  failb=3D 44(D=
)  OK
[  371.081580] raid6test: test_disks(16, 45): faila=3D 16(D)  failb=3D 45(D=
)  OK
[  371.233036] raid6test: test_disks(16, 46): faila=3D 16(D)  failb=3D 46(D=
)  OK
[  371.379124] raid6test: test_disks(16, 47): faila=3D 16(D)  failb=3D 47(D=
)  OK
[  371.525252] raid6test: test_disks(16, 48): faila=3D 16(D)  failb=3D 48(D=
)  OK
[  371.670518] raid6test: test_disks(16, 49): faila=3D 16(D)  failb=3D 49(D=
)  OK
[  371.852841] raid6test: test_disks(16, 50): faila=3D 16(D)  failb=3D 50(D=
)  OK
[  372.004330] raid6test: test_disks(16, 51): faila=3D 16(D)  failb=3D 51(D=
)  OK
[  372.157444] raid6test: test_disks(16, 52): faila=3D 16(D)  failb=3D 52(D=
)  OK
[  372.299618] raid6test: test_disks(16, 53): faila=3D 16(D)  failb=3D 53(D=
)  OK
[  372.441034] raid6test: test_disks(16, 54): faila=3D 16(D)  failb=3D 54(D=
)  OK
[  372.584129] raid6test: test_disks(16, 55): faila=3D 16(D)  failb=3D 55(D=
)  OK
[  372.758205] raid6test: test_disks(16, 56): faila=3D 16(D)  failb=3D 56(D=
)  OK
[  372.896486] raid6test: test_disks(16, 57): faila=3D 16(D)  failb=3D 57(D=
)  OK
[  373.068274] raid6test: test_disks(16, 58): faila=3D 16(D)  failb=3D 58(D=
)  OK
[  373.214367] raid6test: test_disks(16, 59): faila=3D 16(D)  failb=3D 59(D=
)  OK
[  373.357770] raid6test: test_disks(16, 60): faila=3D 16(D)  failb=3D 60(D=
)  OK
[  373.504817] raid6test: test_disks(16, 61): faila=3D 16(D)  failb=3D 61(D=
)  OK
[  373.642882] raid6test: test_disks(16, 62): faila=3D 16(D)  failb=3D 62(P=
)  OK
[  373.781852] raid6test: test_disks(16, 63): faila=3D 16(D)  failb=3D 63(Q=
)  OK
[  373.975411] raid6test: test_disks(17, 18): faila=3D 17(D)  failb=3D 18(D=
)  OK
[  374.117641] raid6test: test_disks(17, 19): faila=3D 17(D)  failb=3D 19(D=
)  OK
[  374.261699] raid6test: test_disks(17, 20): faila=3D 17(D)  failb=3D 20(D=
)  OK
[  374.419304] raid6test: test_disks(17, 21): faila=3D 17(D)  failb=3D 21(D=
)  OK
[  374.697209] raid6test: test_disks(17, 22): faila=3D 17(D)  failb=3D 22(D=
)  OK
[  374.936775] raid6test: test_disks(17, 23): faila=3D 17(D)  failb=3D 23(D=
)  OK
[  375.197880] raid6test: test_disks(17, 24): faila=3D 17(D)  failb=3D 24(D=
)  OK
[  375.369453] raid6test: test_disks(17, 25): faila=3D 17(D)  failb=3D 25(D=
)  OK
[  375.548784] raid6test: test_disks(17, 26): faila=3D 17(D)  failb=3D 26(D=
)  OK
[  375.688156] raid6test: test_disks(17, 27): faila=3D 17(D)  failb=3D 27(D=
)  OK
[  375.918410] raid6test: test_disks(17, 28): faila=3D 17(D)  failb=3D 28(D=
)  OK
[  376.103169] raid6test: test_disks(17, 29): faila=3D 17(D)  failb=3D 29(D=
)  OK
[  376.306394] raid6test: test_disks(17, 30): faila=3D 17(D)  failb=3D 30(D=
)  OK
[  376.487115] raid6test: test_disks(17, 31): faila=3D 17(D)  failb=3D 31(D=
)  OK
[  376.630094] raid6test: test_disks(17, 32): faila=3D 17(D)  failb=3D 32(D=
)  OK
[  376.919945] raid6test: test_disks(17, 33): faila=3D 17(D)  failb=3D 33(D=
)  OK
[  377.205938] raid6test: test_disks(17, 34): faila=3D 17(D)  failb=3D 34(D=
)  OK
[  377.492929] raid6test: test_disks(17, 35): faila=3D 17(D)  failb=3D 35(D=
)  OK
[  377.747652] raid6test: test_disks(17, 36): faila=3D 17(D)  failb=3D 36(D=
)  OK
[  377.905655] raid6test: test_disks(17, 37): faila=3D 17(D)  failb=3D 37(D=
)  OK
[  378.184341] raid6test: test_disks(17, 38): faila=3D 17(D)  failb=3D 38(D=
)  OK
[  378.443514] raid6test: test_disks(17, 39): faila=3D 17(D)  failb=3D 39(D=
)  OK
[  378.742956] raid6test: test_disks(17, 40): faila=3D 17(D)  failb=3D 40(D=
)  OK
[  378.909002] raid6test: test_disks(17, 41): faila=3D 17(D)  failb=3D 41(D=
)  OK
[  379.118276] raid6test: test_disks(17, 42): faila=3D 17(D)  failb=3D 42(D=
)  OK
[  379.428650] raid6test: test_disks(17, 43): faila=3D 17(D)  failb=3D 43(D=
)  OK
[  379.735189] raid6test: test_disks(17, 44): faila=3D 17(D)  failb=3D 44(D=
)  OK
[  379.928786] raid6test: test_disks(17, 45): faila=3D 17(D)  failb=3D 45(D=
)  OK
[  380.114533] raid6test: test_disks(17, 46): faila=3D 17(D)  failb=3D 46(D=
)  OK
[  380.459244] raid6test: test_disks(17, 47): faila=3D 17(D)  failb=3D 47(D=
)  OK
[  380.645506] raid6test: test_disks(17, 48): faila=3D 17(D)  failb=3D 48(D=
)  OK
[  380.803280] raid6test: test_disks(17, 49): faila=3D 17(D)  failb=3D 49(D=
)  OK
[  380.948601] raid6test: test_disks(17, 50): faila=3D 17(D)  failb=3D 50(D=
)  OK
[  381.104284] raid6test: test_disks(17, 51): faila=3D 17(D)  failb=3D 51(D=
)  OK
[  381.406257] raid6test: test_disks(17, 52): faila=3D 17(D)  failb=3D 52(D=
)  OK
[  381.605483] raid6test: test_disks(17, 53): faila=3D 17(D)  failb=3D 53(D=
)  OK
[  381.890966] raid6test: test_disks(17, 54): faila=3D 17(D)  failb=3D 54(D=
)  OK
[  382.092657] raid6test: test_disks(17, 55): faila=3D 17(D)  failb=3D 55(D=
)  OK
[  382.392026] raid6test: test_disks(17, 56): faila=3D 17(D)  failb=3D 56(D=
)  OK
[  382.715356] raid6test: test_disks(17, 57): faila=3D 17(D)  failb=3D 57(D=
)  OK
[  383.065844] raid6test: test_disks(17, 58): faila=3D 17(D)  failb=3D 58(D=
)  OK
[  383.282363] raid6test: test_disks(17, 59): faila=3D 17(D)  failb=3D 59(D=
)  OK
[  383.560347] raid6test: test_disks(17, 60): faila=3D 17(D)  failb=3D 60(D=
)  OK
[  383.710816] raid6test: test_disks(17, 61): faila=3D 17(D)  failb=3D 61(D=
)  OK
[  383.858670] raid6test: test_disks(17, 62): faila=3D 17(D)  failb=3D 62(P=
)  OK
[  384.007864] raid6test: test_disks(17, 63): faila=3D 17(D)  failb=3D 63(Q=
)  OK
[  384.193158] raid6test: test_disks(18, 19): faila=3D 18(D)  failb=3D 19(D=
)  OK
[  384.464963] raid6test: test_disks(18, 20): faila=3D 18(D)  failb=3D 20(D=
)  OK
[  384.696522] raid6test: test_disks(18, 21): faila=3D 18(D)  failb=3D 21(D=
)  OK
[  384.847855] raid6test: test_disks(18, 22): faila=3D 18(D)  failb=3D 22(D=
)  OK
[  385.011036] raid6test: test_disks(18, 23): faila=3D 18(D)  failb=3D 23(D=
)  OK
[  385.240093] raid6test: test_disks(18, 24): faila=3D 18(D)  failb=3D 24(D=
)  OK
[  385.546320] raid6test: test_disks(18, 25): faila=3D 18(D)  failb=3D 25(D=
)  OK
[  385.723719] raid6test: test_disks(18, 26): faila=3D 18(D)  failb=3D 26(D=
)  OK
[  385.874600] raid6test: test_disks(18, 27): faila=3D 18(D)  failb=3D 27(D=
)  OK
[  386.030088] raid6test: test_disks(18, 28): faila=3D 18(D)  failb=3D 28(D=
)  OK
[  386.179955] raid6test: test_disks(18, 29): faila=3D 18(D)  failb=3D 29(D=
)  OK
[  386.335883] raid6test: test_disks(18, 30): faila=3D 18(D)  failb=3D 30(D=
)  OK
[  386.575985] raid6test: test_disks(18, 31): faila=3D 18(D)  failb=3D 31(D=
)  OK
[  386.816319] raid6test: test_disks(18, 32): faila=3D 18(D)  failb=3D 32(D=
)  OK
[  387.110296] raid6test: test_disks(18, 33): faila=3D 18(D)  failb=3D 33(D=
)  OK
[  387.342259] raid6test: test_disks(18, 34): faila=3D 18(D)  failb=3D 34(D=
)  OK
[  387.651192] raid6test: test_disks(18, 35): faila=3D 18(D)  failb=3D 35(D=
)  OK
[  387.912634] raid6test: test_disks(18, 36): faila=3D 18(D)  failb=3D 36(D=
)  OK
[  388.139228] raid6test: test_disks(18, 37): faila=3D 18(D)  failb=3D 37(D=
)  OK
[  388.327996] raid6test: test_disks(18, 38): faila=3D 18(D)  failb=3D 38(D=
)  OK
[  388.516059] raid6test: test_disks(18, 39): faila=3D 18(D)  failb=3D 39(D=
)  OK
[  388.830365] raid6test: test_disks(18, 40): faila=3D 18(D)  failb=3D 40(D=
)  OK
[  389.115878] raid6test: test_disks(18, 41): faila=3D 18(D)  failb=3D 41(D=
)  OK
[  389.390604] raid6test: test_disks(18, 42): faila=3D 18(D)  failb=3D 42(D=
)  OK
[  389.718328] raid6test: test_disks(18, 43): faila=3D 18(D)  failb=3D 43(D=
)  OK
[  389.926269] raid6test: test_disks(18, 44): faila=3D 18(D)  failb=3D 44(D=
)  OK
[  390.109358] raid6test: test_disks(18, 45): faila=3D 18(D)  failb=3D 45(D=
)  OK
[  390.399640] raid6test: test_disks(18, 46): faila=3D 18(D)  failb=3D 46(D=
)  OK
[  390.646076] raid6test: test_disks(18, 47): faila=3D 18(D)  failb=3D 47(D=
)  OK
[  390.789062] raid6test: test_disks(18, 48): faila=3D 18(D)  failb=3D 48(D=
)  OK
[  390.975520] raid6test: test_disks(18, 49): faila=3D 18(D)  failb=3D 49(D=
)  OK
[  391.248788] raid6test: test_disks(18, 50): faila=3D 18(D)  failb=3D 50(D=
)  OK
[  391.433549] raid6test: test_disks(18, 51): faila=3D 18(D)  failb=3D 51(D=
)  OK
[  391.723758] raid6test: test_disks(18, 52): faila=3D 18(D)  failb=3D 52(D=
)  OK
[  391.956367] raid6test: test_disks(18, 53): faila=3D 18(D)  failb=3D 53(D=
)  OK
[  392.177318] raid6test: test_disks(18, 54): faila=3D 18(D)  failb=3D 54(D=
)  OK
[  392.332479] raid6test: test_disks(18, 55): faila=3D 18(D)  failb=3D 55(D=
)  OK
[  392.574189] raid6test: test_disks(18, 56): faila=3D 18(D)  failb=3D 56(D=
)  OK
[  392.713422] raid6test: test_disks(18, 57): faila=3D 18(D)  failb=3D 57(D=
)  OK
[  392.865271] raid6test: test_disks(18, 58): faila=3D 18(D)  failb=3D 58(D=
)  OK
[  393.160426] raid6test: test_disks(18, 59): faila=3D 18(D)  failb=3D 59(D=
)  OK
[  393.433415] raid6test: test_disks(18, 60): faila=3D 18(D)  failb=3D 60(D=
)  OK
[  393.581537] raid6test: test_disks(18, 61): faila=3D 18(D)  failb=3D 61(D=
)  OK
[  393.828461] raid6test: test_disks(18, 62): faila=3D 18(D)  failb=3D 62(P=
)  OK
[  393.992156] raid6test: test_disks(18, 63): faila=3D 18(D)  failb=3D 63(Q=
)  OK
[  394.254702] raid6test: test_disks(19, 20): faila=3D 19(D)  failb=3D 20(D=
)  OK
[  394.408812] raid6test: test_disks(19, 21): faila=3D 19(D)  failb=3D 21(D=
)  OK
[  394.574533] raid6test: test_disks(19, 22): faila=3D 19(D)  failb=3D 22(D=
)  OK
[  394.721567] raid6test: test_disks(19, 23): faila=3D 19(D)  failb=3D 23(D=
)  OK
[  394.873861] raid6test: test_disks(19, 24): faila=3D 19(D)  failb=3D 24(D=
)  OK
[  395.026922] raid6test: test_disks(19, 25): faila=3D 19(D)  failb=3D 25(D=
)  OK
[  395.232210] raid6test: test_disks(19, 26): faila=3D 19(D)  failb=3D 26(D=
)  OK
[  395.449702] raid6test: test_disks(19, 27): faila=3D 19(D)  failb=3D 27(D=
)  OK
[  395.622248] raid6test: test_disks(19, 28): faila=3D 19(D)  failb=3D 28(D=
)  OK
[  395.827573] raid6test: test_disks(19, 29): faila=3D 19(D)  failb=3D 29(D=
)  OK
[  396.117599] raid6test: test_disks(19, 30): faila=3D 19(D)  failb=3D 30(D=
)  OK
[  396.356249] raid6test: test_disks(19, 31): faila=3D 19(D)  failb=3D 31(D=
)  OK
[  396.506722] raid6test: test_disks(19, 32): faila=3D 19(D)  failb=3D 32(D=
)  OK
[  396.754878] raid6test: test_disks(19, 33): faila=3D 19(D)  failb=3D 33(D=
)  OK
[  396.905330] raid6test: test_disks(19, 34): faila=3D 19(D)  failb=3D 34(D=
)  OK
[  397.112631] raid6test: test_disks(19, 35): faila=3D 19(D)  failb=3D 35(D=
)  OK
[  397.364731] raid6test: test_disks(19, 36): faila=3D 19(D)  failb=3D 36(D=
)  OK
[  397.544388] raid6test: test_disks(19, 37): faila=3D 19(D)  failb=3D 37(D=
)  OK
[  397.866913] raid6test: test_disks(19, 38): faila=3D 19(D)  failb=3D 38(D=
)  OK
[  398.040579] raid6test: test_disks(19, 39): faila=3D 19(D)  failb=3D 39(D=
)  OK
[  398.189568] raid6test: test_disks(19, 40): faila=3D 19(D)  failb=3D 40(D=
)  OK
[  398.449995] raid6test: test_disks(19, 41): faila=3D 19(D)  failb=3D 41(D=
)  OK
[  398.654851] raid6test: test_disks(19, 42): faila=3D 19(D)  failb=3D 42(D=
)  OK
[  398.830380] raid6test: test_disks(19, 43): faila=3D 19(D)  failb=3D 43(D=
)  OK
[  399.036004] raid6test: test_disks(19, 44): faila=3D 19(D)  failb=3D 44(D=
)  OK
[  399.224633] raid6test: test_disks(19, 45): faila=3D 19(D)  failb=3D 45(D=
)  OK
[  399.443005] raid6test: test_disks(19, 46): faila=3D 19(D)  failb=3D 46(D=
)  OK
[  399.749142] raid6test: test_disks(19, 47): faila=3D 19(D)  failb=3D 47(D=
)  OK
[  399.962759] raid6test: test_disks(19, 48): faila=3D 19(D)  failb=3D 48(D=
)  OK
[  400.239647] raid6test: test_disks(19, 49): faila=3D 19(D)  failb=3D 49(D=
)  OK
[  400.386219] raid6test: test_disks(19, 50): faila=3D 19(D)  failb=3D 50(D=
)  OK
[  400.588852] raid6test: test_disks(19, 51): faila=3D 19(D)  failb=3D 51(D=
)  OK
[  400.734104] raid6test: test_disks(19, 52): faila=3D 19(D)  failb=3D 52(D=
)  OK
[  400.880422] raid6test: test_disks(19, 53): faila=3D 19(D)  failb=3D 53(D=
)  OK
[  401.020410] raid6test: test_disks(19, 54): faila=3D 19(D)  failb=3D 54(D=
)  OK
[  401.161427] raid6test: test_disks(19, 55): faila=3D 19(D)  failb=3D 55(D=
)  OK
[  401.416325] raid6test: test_disks(19, 56): faila=3D 19(D)  failb=3D 56(D=
)  OK
[  401.650117] raid6test: test_disks(19, 57): faila=3D 19(D)  failb=3D 57(D=
)  OK
[  401.796909] raid6test: test_disks(19, 58): faila=3D 19(D)  failb=3D 58(D=
)  OK
[  401.965934] raid6test: test_disks(19, 59): faila=3D 19(D)  failb=3D 59(D=
)  OK
[  402.168508] raid6test: test_disks(19, 60): faila=3D 19(D)  failb=3D 60(D=
)  OK
[  402.387016] raid6test: test_disks(19, 61): faila=3D 19(D)  failb=3D 61(D=
)  OK
[  402.640300] raid6test: test_disks(19, 62): faila=3D 19(D)  failb=3D 62(P=
)  OK
[  402.860944] raid6test: test_disks(19, 63): faila=3D 19(D)  failb=3D 63(Q=
)  OK
[  403.162047] raid6test: test_disks(20, 21): faila=3D 20(D)  failb=3D 21(D=
)  OK
[  403.410173] raid6test: test_disks(20, 22): faila=3D 20(D)  failb=3D 22(D=
)  OK
[  403.615046] raid6test: test_disks(20, 23): faila=3D 20(D)  failb=3D 23(D=
)  OK
[  403.871598] raid6test: test_disks(20, 24): faila=3D 20(D)  failb=3D 24(D=
)  OK
[  404.101761] raid6test: test_disks(20, 25): faila=3D 20(D)  failb=3D 25(D=
)  OK
[  404.262175] raid6test: test_disks(20, 26): faila=3D 20(D)  failb=3D 26(D=
)  OK
[  404.465871] raid6test: test_disks(20, 27): faila=3D 20(D)  failb=3D 27(D=
)  OK
[  404.631288] raid6test: test_disks(20, 28): faila=3D 20(D)  failb=3D 28(D=
)  OK
[  404.877174] raid6test: test_disks(20, 29): faila=3D 20(D)  failb=3D 29(D=
)  OK
[  405.172998] raid6test: test_disks(20, 30): faila=3D 20(D)  failb=3D 30(D=
)  OK
[  405.395022] raid6test: test_disks(20, 31): faila=3D 20(D)  failb=3D 31(D=
)  OK
[  405.600558] raid6test: test_disks(20, 32): faila=3D 20(D)  failb=3D 32(D=
)  OK
[  405.754675] raid6test: test_disks(20, 33): faila=3D 20(D)  failb=3D 33(D=
)  OK
[  405.906301] raid6test: test_disks(20, 34): faila=3D 20(D)  failb=3D 34(D=
)  OK
[  406.061669] raid6test: test_disks(20, 35): faila=3D 20(D)  failb=3D 35(D=
)  OK
[  406.252911] raid6test: test_disks(20, 36): faila=3D 20(D)  failb=3D 36(D=
)  OK
[  406.404789] raid6test: test_disks(20, 37): faila=3D 20(D)  failb=3D 37(D=
)  OK
[  406.556034] raid6test: test_disks(20, 38): faila=3D 20(D)  failb=3D 38(D=
)  OK
[  406.745755] raid6test: test_disks(20, 39): faila=3D 20(D)  failb=3D 39(D=
)  OK
[  406.923330] raid6test: test_disks(20, 40): faila=3D 20(D)  failb=3D 40(D=
)  OK
[  407.071137] raid6test: test_disks(20, 41): faila=3D 20(D)  failb=3D 41(D=
)  OK
[  407.220515] raid6test: test_disks(20, 42): faila=3D 20(D)  failb=3D 42(D=
)  OK
[  407.467979] raid6test: test_disks(20, 43): faila=3D 20(D)  failb=3D 43(D=
)  OK
[  407.781140] raid6test: test_disks(20, 44): faila=3D 20(D)  failb=3D 44(D=
)  OK
[  407.985602] raid6test: test_disks(20, 45): faila=3D 20(D)  failb=3D 45(D=
)  OK
[  408.139085] raid6test: test_disks(20, 46): faila=3D 20(D)  failb=3D 46(D=
)  OK
[  408.291733] raid6test: test_disks(20, 47): faila=3D 20(D)  failb=3D 47(D=
)  OK
[  408.445364] raid6test: test_disks(20, 48): faila=3D 20(D)  failb=3D 48(D=
)  OK
[  408.596666] raid6test: test_disks(20, 49): faila=3D 20(D)  failb=3D 49(D=
)  OK
[  408.746580] raid6test: test_disks(20, 50): faila=3D 20(D)  failb=3D 50(D=
)  OK
[  408.890257] raid6test: test_disks(20, 51): faila=3D 20(D)  failb=3D 51(D=
)  OK
[  409.033918] raid6test: test_disks(20, 52): faila=3D 20(D)  failb=3D 52(D=
)  OK
[  409.180985] raid6test: test_disks(20, 53): faila=3D 20(D)  failb=3D 53(D=
)  OK
[  409.326055] raid6test: test_disks(20, 54): faila=3D 20(D)  failb=3D 54(D=
)  OK
[  409.468791] raid6test: test_disks(20, 55): faila=3D 20(D)  failb=3D 55(D=
)  OK
[  409.729569] raid6test: test_disks(20, 56): faila=3D 20(D)  failb=3D 56(D=
)  OK
[  409.939280] raid6test: test_disks(20, 57): faila=3D 20(D)  failb=3D 57(D=
)  OK
[  410.216420] raid6test: test_disks(20, 58): faila=3D 20(D)  failb=3D 58(D=
)  OK
[  410.444751] raid6test: test_disks(20, 59): faila=3D 20(D)  failb=3D 59(D=
)  OK
[  410.593871] raid6test: test_disks(20, 60): faila=3D 20(D)  failb=3D 60(D=
)  OK
[  410.730878] raid6test: test_disks(20, 61): faila=3D 20(D)  failb=3D 61(D=
)  OK
[  410.869403] raid6test: test_disks(20, 62): faila=3D 20(D)  failb=3D 62(P=
)  OK
[  411.088298] raid6test: test_disks(20, 63): faila=3D 20(D)  failb=3D 63(Q=
)  OK
[  411.227504] raid6test: test_disks(21, 22): faila=3D 21(D)  failb=3D 22(D=
)  OK
[  411.370378] raid6test: test_disks(21, 23): faila=3D 21(D)  failb=3D 23(D=
)  OK
[  411.511902] raid6test: test_disks(21, 24): faila=3D 21(D)  failb=3D 24(D=
)  OK
[  411.747018] raid6test: test_disks(21, 25): faila=3D 21(D)  failb=3D 25(D=
)  OK
[  412.009762] raid6test: test_disks(21, 26): faila=3D 21(D)  failb=3D 26(D=
)  OK
[  412.307125] raid6test: test_disks(21, 27): faila=3D 21(D)  failb=3D 27(D=
)  OK
[  412.514554] raid6test: test_disks(21, 28): faila=3D 21(D)  failb=3D 28(D=
)  OK
[  412.695769] raid6test: test_disks(21, 29): faila=3D 21(D)  failb=3D 29(D=
)  OK
[  412.931904] raid6test: test_disks(21, 30): faila=3D 21(D)  failb=3D 30(D=
)  OK
[  413.166667] raid6test: test_disks(21, 31): faila=3D 21(D)  failb=3D 31(D=
)  OK
[  413.312039] raid6test: test_disks(21, 32): faila=3D 21(D)  failb=3D 32(D=
)  OK
[  413.454307] raid6test: test_disks(21, 33): faila=3D 21(D)  failb=3D 33(D=
)  OK
[  413.595677] raid6test: test_disks(21, 34): faila=3D 21(D)  failb=3D 34(D=
)  OK
[  413.750847] raid6test: test_disks(21, 35): faila=3D 21(D)  failb=3D 35(D=
)  OK
[  413.947977] raid6test: test_disks(21, 36): faila=3D 21(D)  failb=3D 36(D=
)  OK
[  414.202019] raid6test: test_disks(21, 37): faila=3D 21(D)  failb=3D 37(D=
)  OK
[  414.476599] raid6test: test_disks(21, 38): faila=3D 21(D)  failb=3D 38(D=
)  OK
[  414.719324] raid6test: test_disks(21, 39): faila=3D 21(D)  failb=3D 39(D=
)  OK
[  414.909720] raid6test: test_disks(21, 40): faila=3D 21(D)  failb=3D 40(D=
)  OK
[  415.200166] raid6test: test_disks(21, 41): faila=3D 21(D)  failb=3D 41(D=
)  OK
[  415.394979] raid6test: test_disks(21, 42): faila=3D 21(D)  failb=3D 42(D=
)  OK
[  415.681573] raid6test: test_disks(21, 43): faila=3D 21(D)  failb=3D 43(D=
)  OK
[  415.872822] raid6test: test_disks(21, 44): faila=3D 21(D)  failb=3D 44(D=
)  OK
[  416.021317] raid6test: test_disks(21, 45): faila=3D 21(D)  failb=3D 45(D=
)  OK
[  416.177655] raid6test: test_disks(21, 46): faila=3D 21(D)  failb=3D 46(D=
)  OK
[  416.323717] raid6test: test_disks(21, 47): faila=3D 21(D)  failb=3D 47(D=
)  OK
[  416.487917] raid6test: test_disks(21, 48): faila=3D 21(D)  failb=3D 48(D=
)  OK
[  416.638740] raid6test: test_disks(21, 49): faila=3D 21(D)  failb=3D 49(D=
)  OK
[  416.787336] raid6test: test_disks(21, 50): faila=3D 21(D)  failb=3D 50(D=
)  OK
[  416.928323] raid6test: test_disks(21, 51): faila=3D 21(D)  failb=3D 51(D=
)  OK
[  417.075287] raid6test: test_disks(21, 52): faila=3D 21(D)  failb=3D 52(D=
)  OK
[  417.293428] raid6test: test_disks(21, 53): faila=3D 21(D)  failb=3D 53(D=
)  OK
[  417.432925] raid6test: test_disks(21, 54): faila=3D 21(D)  failb=3D 54(D=
)  OK
[  417.634177] raid6test: test_disks(21, 55): faila=3D 21(D)  failb=3D 55(D=
)  OK
[  417.917378] raid6test: test_disks(21, 56): faila=3D 21(D)  failb=3D 56(D=
)  OK
[  418.077493] raid6test: test_disks(21, 57): faila=3D 21(D)  failb=3D 57(D=
)  OK
[  418.221777] raid6test: test_disks(21, 58): faila=3D 21(D)  failb=3D 58(D=
)  OK
[  418.368234] raid6test: test_disks(21, 59): faila=3D 21(D)  failb=3D 59(D=
)  OK
[  418.522241] raid6test: test_disks(21, 60): faila=3D 21(D)  failb=3D 60(D=
)  OK
[  418.734609] raid6test: test_disks(21, 61): faila=3D 21(D)  failb=3D 61(D=
)  OK
[  418.878878] raid6test: test_disks(21, 62): faila=3D 21(D)  failb=3D 62(P=
)  OK
[  419.024850] raid6test: test_disks(21, 63): faila=3D 21(D)  failb=3D 63(Q=
)  OK
[  419.203678] raid6test: test_disks(22, 23): faila=3D 22(D)  failb=3D 23(D=
)  OK
[  419.437614] raid6test: test_disks(22, 24): faila=3D 22(D)  failb=3D 24(D=
)  OK
[  419.601964] raid6test: test_disks(22, 25): faila=3D 22(D)  failb=3D 25(D=
)  OK
[  419.829847] raid6test: test_disks(22, 26): faila=3D 22(D)  failb=3D 26(D=
)  OK
[  419.993998] raid6test: test_disks(22, 27): faila=3D 22(D)  failb=3D 27(D=
)  OK
[  420.152459] raid6test: test_disks(22, 28): faila=3D 22(D)  failb=3D 28(D=
)  OK
[  420.305021] raid6test: test_disks(22, 29): faila=3D 22(D)  failb=3D 29(D=
)  OK
[  420.468908] raid6test: test_disks(22, 30): faila=3D 22(D)  failb=3D 30(D=
)  OK
[  420.620547] raid6test: test_disks(22, 31): faila=3D 22(D)  failb=3D 31(D=
)  OK
[  420.844587] raid6test: test_disks(22, 32): faila=3D 22(D)  failb=3D 32(D=
)  OK
[  420.995453] raid6test: test_disks(22, 33): faila=3D 22(D)  failb=3D 33(D=
)  OK
[  421.145142] raid6test: test_disks(22, 34): faila=3D 22(D)  failb=3D 34(D=
)  OK
[  421.301785] raid6test: test_disks(22, 35): faila=3D 22(D)  failb=3D 35(D=
)  OK
[  421.446787] raid6test: test_disks(22, 36): faila=3D 22(D)  failb=3D 36(D=
)  OK
[  421.693752] raid6test: test_disks(22, 37): faila=3D 22(D)  failb=3D 37(D=
)  OK
[  421.924226] raid6test: test_disks(22, 38): faila=3D 22(D)  failb=3D 38(D=
)  OK
[  422.087125] raid6test: test_disks(22, 39): faila=3D 22(D)  failb=3D 39(D=
)  OK
[  422.262328] raid6test: test_disks(22, 40): faila=3D 22(D)  failb=3D 40(D=
)  OK
[  422.573734] raid6test: test_disks(22, 41): faila=3D 22(D)  failb=3D 41(D=
)  OK
[  422.793246] raid6test: test_disks(22, 42): faila=3D 22(D)  failb=3D 42(D=
)  OK
[  423.033845] raid6test: test_disks(22, 43): faila=3D 22(D)  failb=3D 43(D=
)  OK
[  423.327432] raid6test: test_disks(22, 44): faila=3D 22(D)  failb=3D 44(D=
)  OK
[  423.548672] raid6test: test_disks(22, 45): faila=3D 22(D)  failb=3D 45(D=
)  OK
[  423.830249] raid6test: test_disks(22, 46): faila=3D 22(D)  failb=3D 46(D=
)  OK
[  424.065760] raid6test: test_disks(22, 47): faila=3D 22(D)  failb=3D 47(D=
)  OK
[  424.377214] raid6test: test_disks(22, 48): faila=3D 22(D)  failb=3D 48(D=
)  OK
[  424.632564] raid6test: test_disks(22, 49): faila=3D 22(D)  failb=3D 49(D=
)  OK
[  424.782796] raid6test: test_disks(22, 50): faila=3D 22(D)  failb=3D 50(D=
)  OK
[  424.930443] raid6test: test_disks(22, 51): faila=3D 22(D)  failb=3D 51(D=
)  OK
[  425.074993] raid6test: test_disks(22, 52): faila=3D 22(D)  failb=3D 52(D=
)  OK
[  425.216688] raid6test: test_disks(22, 53): faila=3D 22(D)  failb=3D 53(D=
)  OK
[  425.358215] raid6test: test_disks(22, 54): faila=3D 22(D)  failb=3D 54(D=
)  OK
[  425.513319] raid6test: test_disks(22, 55): faila=3D 22(D)  failb=3D 55(D=
)  OK
[  425.708122] raid6test: test_disks(22, 56): faila=3D 22(D)  failb=3D 56(D=
)  OK
[  425.881173] raid6test: test_disks(22, 57): faila=3D 22(D)  failb=3D 57(D=
)  OK
[  426.049583] raid6test: test_disks(22, 58): faila=3D 22(D)  failb=3D 58(D=
)  OK
[  426.219862] raid6test: test_disks(22, 59): faila=3D 22(D)  failb=3D 59(D=
)  OK
[  426.399551] raid6test: test_disks(22, 60): faila=3D 22(D)  failb=3D 60(D=
)  OK
[  426.574215] raid6test: test_disks(22, 61): faila=3D 22(D)  failb=3D 61(D=
)  OK
[  426.754409] raid6test: test_disks(22, 62): faila=3D 22(D)  failb=3D 62(P=
)  OK
[  426.949635] raid6test: test_disks(22, 63): faila=3D 22(D)  failb=3D 63(Q=
)  OK
[  427.094068] raid6test: test_disks(23, 24): faila=3D 23(D)  failb=3D 24(D=
)  OK
[  427.269887] raid6test: test_disks(23, 25): faila=3D 23(D)  failb=3D 25(D=
)  OK
[  427.523825] raid6test: test_disks(23, 26): faila=3D 23(D)  failb=3D 26(D=
)  OK
[  427.683198] raid6test: test_disks(23, 27): faila=3D 23(D)  failb=3D 27(D=
)  OK
[  427.839355] raid6test: test_disks(23, 28): faila=3D 23(D)  failb=3D 28(D=
)  OK
[  428.037461] raid6test: test_disks(23, 29): faila=3D 23(D)  failb=3D 29(D=
)  OK
[  428.186072] raid6test: test_disks(23, 30): faila=3D 23(D)  failb=3D 30(D=
)  OK
[  428.339625] raid6test: test_disks(23, 31): faila=3D 23(D)  failb=3D 31(D=
)  OK
[  428.487446] raid6test: test_disks(23, 32): faila=3D 23(D)  failb=3D 32(D=
)  OK
[  428.651505] raid6test: test_disks(23, 33): faila=3D 23(D)  failb=3D 33(D=
)  OK
[  428.797841] raid6test: test_disks(23, 34): faila=3D 23(D)  failb=3D 34(D=
)  OK
[  428.995985] raid6test: test_disks(23, 35): faila=3D 23(D)  failb=3D 35(D=
)  OK
[  429.193521] raid6test: test_disks(23, 36): faila=3D 23(D)  failb=3D 36(D=
)  OK
[  429.353228] raid6test: test_disks(23, 37): faila=3D 23(D)  failb=3D 37(D=
)  OK
[  429.502026] raid6test: test_disks(23, 38): faila=3D 23(D)  failb=3D 38(D=
)  OK
[  429.651612] raid6test: test_disks(23, 39): faila=3D 23(D)  failb=3D 39(D=
)  OK
[  429.801280] raid6test: test_disks(23, 40): faila=3D 23(D)  failb=3D 40(D=
)  OK
[  430.000036] raid6test: test_disks(23, 41): faila=3D 23(D)  failb=3D 41(D=
)  OK
[  430.182648] raid6test: test_disks(23, 42): faila=3D 23(D)  failb=3D 42(D=
)  OK
[  430.338307] raid6test: test_disks(23, 43): faila=3D 23(D)  failb=3D 43(D=
)  OK
[  430.555079] raid6test: test_disks(23, 44): faila=3D 23(D)  failb=3D 44(D=
)  OK
[  430.781484] raid6test: test_disks(23, 45): faila=3D 23(D)  failb=3D 45(D=
)  OK
[  430.948179] raid6test: test_disks(23, 46): faila=3D 23(D)  failb=3D 46(D=
)  OK
[  431.176189] raid6test: test_disks(23, 47): faila=3D 23(D)  failb=3D 47(D=
)  OK
[  431.422673] raid6test: test_disks(23, 48): faila=3D 23(D)  failb=3D 48(D=
)  OK
[  431.662058] raid6test: test_disks(23, 49): faila=3D 23(D)  failb=3D 49(D=
)  OK
[  431.823969] raid6test: test_disks(23, 50): faila=3D 23(D)  failb=3D 50(D=
)  OK
[  432.006077] raid6test: test_disks(23, 51): faila=3D 23(D)  failb=3D 51(D=
)  OK
[  432.241382] raid6test: test_disks(23, 52): faila=3D 23(D)  failb=3D 52(D=
)  OK
[  432.388854] raid6test: test_disks(23, 53): faila=3D 23(D)  failb=3D 53(D=
)  OK
[  432.620887] raid6test: test_disks(23, 54): faila=3D 23(D)  failb=3D 54(D=
)  OK
[  432.842417] raid6test: test_disks(23, 55): faila=3D 23(D)  failb=3D 55(D=
)  OK
[  433.012845] raid6test: test_disks(23, 56): faila=3D 23(D)  failb=3D 56(D=
)  OK
[  433.156196] raid6test: test_disks(23, 57): faila=3D 23(D)  failb=3D 57(D=
)  OK
[  433.333401] raid6test: test_disks(23, 58): faila=3D 23(D)  failb=3D 58(D=
)  OK
[  433.481918] raid6test: test_disks(23, 59): faila=3D 23(D)  failb=3D 59(D=
)  OK
[  433.624187] raid6test: test_disks(23, 60): faila=3D 23(D)  failb=3D 60(D=
)  OK
[  433.853424] raid6test: test_disks(23, 61): faila=3D 23(D)  failb=3D 61(D=
)  OK
[  434.085921] raid6test: test_disks(23, 62): faila=3D 23(D)  failb=3D 62(P=
)  OK
[  434.344911] raid6test: test_disks(23, 63): faila=3D 23(D)  failb=3D 63(Q=
)  OK
[  434.503275] raid6test: test_disks(24, 25): faila=3D 24(D)  failb=3D 25(D=
)  OK
[  434.653845] raid6test: test_disks(24, 26): faila=3D 24(D)  failb=3D 26(D=
)  OK
[  434.803675] raid6test: test_disks(24, 27): faila=3D 24(D)  failb=3D 27(D=
)  OK
[  434.990533] raid6test: test_disks(24, 28): faila=3D 24(D)  failb=3D 28(D=
)  OK
[  435.149841] raid6test: test_disks(24, 29): faila=3D 24(D)  failb=3D 29(D=
)  OK
[  435.301651] raid6test: test_disks(24, 30): faila=3D 24(D)  failb=3D 30(D=
)  OK
[  435.447896] raid6test: test_disks(24, 31): faila=3D 24(D)  failb=3D 31(D=
)  OK
[  435.630268] raid6test: test_disks(24, 32): faila=3D 24(D)  failb=3D 32(D=
)  OK
[  435.931738] raid6test: test_disks(24, 33): faila=3D 24(D)  failb=3D 33(D=
)  OK
[  436.102016] raid6test: test_disks(24, 34): faila=3D 24(D)  failb=3D 34(D=
)  OK
[  436.246903] raid6test: test_disks(24, 35): faila=3D 24(D)  failb=3D 35(D=
)  OK
[  436.459423] raid6test: test_disks(24, 36): faila=3D 24(D)  failb=3D 36(D=
)  OK
[  436.712647] raid6test: test_disks(24, 37): faila=3D 24(D)  failb=3D 37(D=
)  OK
[  436.912969] raid6test: test_disks(24, 38): faila=3D 24(D)  failb=3D 38(D=
)  OK
[  437.179090] raid6test: test_disks(24, 39): faila=3D 24(D)  failb=3D 39(D=
)  OK
[  437.463042] raid6test: test_disks(24, 40): faila=3D 24(D)  failb=3D 40(D=
)  OK
[  437.643572] raid6test: test_disks(24, 41): faila=3D 24(D)  failb=3D 41(D=
)  OK
[  437.788906] raid6test: test_disks(24, 42): faila=3D 24(D)  failb=3D 42(D=
)  OK
[  437.992666] raid6test: test_disks(24, 43): faila=3D 24(D)  failb=3D 43(D=
)  OK
[  438.154768] raid6test: test_disks(24, 44): faila=3D 24(D)  failb=3D 44(D=
)  OK
[  438.301605] raid6test: test_disks(24, 45): faila=3D 24(D)  failb=3D 45(D=
)  OK
[  438.450898] raid6test: test_disks(24, 46): faila=3D 24(D)  failb=3D 46(D=
)  OK
[  438.615259] raid6test: test_disks(24, 47): faila=3D 24(D)  failb=3D 47(D=
)  OK
[  438.762434] raid6test: test_disks(24, 48): faila=3D 24(D)  failb=3D 48(D=
)  OK
[  438.907285] raid6test: test_disks(24, 49): faila=3D 24(D)  failb=3D 49(D=
)  OK
[  439.153931] raid6test: test_disks(24, 50): faila=3D 24(D)  failb=3D 50(D=
)  OK
[  439.352102] raid6test: test_disks(24, 51): faila=3D 24(D)  failb=3D 51(D=
)  OK
[  439.516307] raid6test: test_disks(24, 52): faila=3D 24(D)  failb=3D 52(D=
)  OK
[  439.666471] raid6test: test_disks(24, 53): faila=3D 24(D)  failb=3D 53(D=
)  OK
[  439.829012] raid6test: test_disks(24, 54): faila=3D 24(D)  failb=3D 54(D=
)  OK
[  439.974920] raid6test: test_disks(24, 55): faila=3D 24(D)  failb=3D 55(D=
)  OK
[  440.123284] raid6test: test_disks(24, 56): faila=3D 24(D)  failb=3D 56(D=
)  OK
[  440.265298] raid6test: test_disks(24, 57): faila=3D 24(D)  failb=3D 57(D=
)  OK
[  440.428787] raid6test: test_disks(24, 58): faila=3D 24(D)  failb=3D 58(D=
)  OK
[  440.571372] raid6test: test_disks(24, 59): faila=3D 24(D)  failb=3D 59(D=
)  OK
[  440.771563] raid6test: test_disks(24, 60): faila=3D 24(D)  failb=3D 60(D=
)  OK
[  440.952699] raid6test: test_disks(24, 61): faila=3D 24(D)  failb=3D 61(D=
)  OK
[  441.098663] raid6test: test_disks(24, 62): faila=3D 24(D)  failb=3D 62(P=
)  OK
[  441.263403] raid6test: test_disks(24, 63): faila=3D 24(D)  failb=3D 63(Q=
)  OK
[  441.418252] raid6test: test_disks(25, 26): faila=3D 25(D)  failb=3D 26(D=
)  OK
[  441.575909] raid6test: test_disks(25, 27): faila=3D 25(D)  failb=3D 27(D=
)  OK
[  441.725082] raid6test: test_disks(25, 28): faila=3D 25(D)  failb=3D 28(D=
)  OK
[  441.874905] raid6test: test_disks(25, 29): faila=3D 25(D)  failb=3D 29(D=
)  OK
[  442.029726] raid6test: test_disks(25, 30): faila=3D 25(D)  failb=3D 30(D=
)  OK
[  442.187875] raid6test: test_disks(25, 31): faila=3D 25(D)  failb=3D 31(D=
)  OK
[  442.347880] raid6test: test_disks(25, 32): faila=3D 25(D)  failb=3D 32(D=
)  OK
[  442.551773] raid6test: test_disks(25, 33): faila=3D 25(D)  failb=3D 33(D=
)  OK
[  442.756296] raid6test: test_disks(25, 34): faila=3D 25(D)  failb=3D 34(D=
)  OK
[  442.900691] raid6test: test_disks(25, 35): faila=3D 25(D)  failb=3D 35(D=
)  OK
[  443.046506] raid6test: test_disks(25, 36): faila=3D 25(D)  failb=3D 36(D=
)  OK
[  443.254984] raid6test: test_disks(25, 37): faila=3D 25(D)  failb=3D 37(D=
)  OK
[  443.415913] raid6test: test_disks(25, 38): faila=3D 25(D)  failb=3D 38(D=
)  OK
[  443.563509] raid6test: test_disks(25, 39): faila=3D 25(D)  failb=3D 39(D=
)  OK
[  443.714230] raid6test: test_disks(25, 40): faila=3D 25(D)  failb=3D 40(D=
)  OK
[  443.863210] raid6test: test_disks(25, 41): faila=3D 25(D)  failb=3D 41(D=
)  OK
[  444.009667] raid6test: test_disks(25, 42): faila=3D 25(D)  failb=3D 42(D=
)  OK
[  444.159868] raid6test: test_disks(25, 43): faila=3D 25(D)  failb=3D 43(D=
)  OK
[  444.359706] raid6test: test_disks(25, 44): faila=3D 25(D)  failb=3D 44(D=
)  OK
[  444.537914] raid6test: test_disks(25, 45): faila=3D 25(D)  failb=3D 45(D=
)  OK
[  444.688128] raid6test: test_disks(25, 46): faila=3D 25(D)  failb=3D 46(D=
)  OK
[  444.970125] raid6test: test_disks(25, 47): faila=3D 25(D)  failb=3D 47(D=
)  OK
[  445.257006] raid6test: test_disks(25, 48): faila=3D 25(D)  failb=3D 48(D=
)  OK
[  445.468423] raid6test: test_disks(25, 49): faila=3D 25(D)  failb=3D 49(D=
)  OK
[  445.656657] raid6test: test_disks(25, 50): faila=3D 25(D)  failb=3D 50(D=
)  OK
[  445.913572] raid6test: test_disks(25, 51): faila=3D 25(D)  failb=3D 51(D=
)  OK
[  446.125322] raid6test: test_disks(25, 52): faila=3D 25(D)  failb=3D 52(D=
)  OK
[  446.356424] raid6test: test_disks(25, 53): faila=3D 25(D)  failb=3D 53(D=
)  OK
[  446.528100] raid6test: test_disks(25, 54): faila=3D 25(D)  failb=3D 54(D=
)  OK
[  446.842096] raid6test: test_disks(25, 55): faila=3D 25(D)  failb=3D 55(D=
)  OK
[  447.049080] raid6test: test_disks(25, 56): faila=3D 25(D)  failb=3D 56(D=
)  OK
[  447.262228] raid6test: test_disks(25, 57): faila=3D 25(D)  failb=3D 57(D=
)  OK
[  447.494487] raid6test: test_disks(25, 58): faila=3D 25(D)  failb=3D 58(D=
)  OK
[  447.689494] raid6test: test_disks(25, 59): faila=3D 25(D)  failb=3D 59(D=
)  OK
[  447.981232] raid6test: test_disks(25, 60): faila=3D 25(D)  failb=3D 60(D=
)  OK
[  448.140345] raid6test: test_disks(25, 61): faila=3D 25(D)  failb=3D 61(D=
)  OK
[  448.349941] raid6test: test_disks(25, 62): faila=3D 25(D)  failb=3D 62(P=
)  OK
[  448.601679] raid6test: test_disks(25, 63): faila=3D 25(D)  failb=3D 63(Q=
)  OK
[  448.782788] raid6test: test_disks(26, 27): faila=3D 26(D)  failb=3D 27(D=
)  OK
[  449.030303] raid6test: test_disks(26, 28): faila=3D 26(D)  failb=3D 28(D=
)  OK
[  449.182251] raid6test: test_disks(26, 29): faila=3D 26(D)  failb=3D 29(D=
)  OK
[  449.438106] raid6test: test_disks(26, 30): faila=3D 26(D)  failb=3D 30(D=
)  OK
[  449.641651] raid6test: test_disks(26, 31): faila=3D 26(D)  failb=3D 31(D=
)  OK
[  449.868536] raid6test: test_disks(26, 32): faila=3D 26(D)  failb=3D 32(D=
)  OK
[  450.025237] raid6test: test_disks(26, 33): faila=3D 26(D)  failb=3D 33(D=
)  OK
[  450.216046] raid6test: test_disks(26, 34): faila=3D 26(D)  failb=3D 34(D=
)  OK
[  450.435141] raid6test: test_disks(26, 35): faila=3D 26(D)  failb=3D 35(D=
)  OK
[  450.653979] raid6test: test_disks(26, 36): faila=3D 26(D)  failb=3D 36(D=
)  OK
[  450.853046] raid6test: test_disks(26, 37): faila=3D 26(D)  failb=3D 37(D=
)  OK
[  451.085370] raid6test: test_disks(26, 38): faila=3D 26(D)  failb=3D 38(D=
)  OK
[  451.396863] raid6test: test_disks(26, 39): faila=3D 26(D)  failb=3D 39(D=
)  OK
[  451.620610] raid6test: test_disks(26, 40): faila=3D 26(D)  failb=3D 40(D=
)  OK
[  451.847093] raid6test: test_disks(26, 41): faila=3D 26(D)  failb=3D 41(D=
)  OK
[  451.994673] raid6test: test_disks(26, 42): faila=3D 26(D)  failb=3D 42(D=
)  OK
[  452.142792] raid6test: test_disks(26, 43): faila=3D 26(D)  failb=3D 43(D=
)  OK
[  452.290773] raid6test: test_disks(26, 44): faila=3D 26(D)  failb=3D 44(D=
)  OK
[  452.563814] raid6test: test_disks(26, 45): faila=3D 26(D)  failb=3D 45(D=
)  OK
[  452.737941] raid6test: test_disks(26, 46): faila=3D 26(D)  failb=3D 46(D=
)  OK
[  452.984435] raid6test: test_disks(26, 47): faila=3D 26(D)  failb=3D 47(D=
)  OK
[  453.171209] raid6test: test_disks(26, 48): faila=3D 26(D)  failb=3D 48(D=
)  OK
[  453.465086] raid6test: test_disks(26, 49): faila=3D 26(D)  failb=3D 49(D=
)  OK
[  453.724138] raid6test: test_disks(26, 50): faila=3D 26(D)  failb=3D 50(D=
)  OK
[  453.895740] raid6test: test_disks(26, 51): faila=3D 26(D)  failb=3D 51(D=
)  OK
[  454.189636] raid6test: test_disks(26, 52): faila=3D 26(D)  failb=3D 52(D=
)  OK
[  454.368831] raid6test: test_disks(26, 53): faila=3D 26(D)  failb=3D 53(D=
)  OK
[  454.602073] raid6test: test_disks(26, 54): faila=3D 26(D)  failb=3D 54(D=
)  OK
[  454.815432] raid6test: test_disks(26, 55): faila=3D 26(D)  failb=3D 55(D=
)  OK
[  455.051110] raid6test: test_disks(26, 56): faila=3D 26(D)  failb=3D 56(D=
)  OK
[  455.275060] raid6test: test_disks(26, 57): faila=3D 26(D)  failb=3D 57(D=
)  OK
[  455.423668] raid6test: test_disks(26, 58): faila=3D 26(D)  failb=3D 58(D=
)  OK
[  455.697533] raid6test: test_disks(26, 59): faila=3D 26(D)  failb=3D 59(D=
)  OK
[  455.918646] raid6test: test_disks(26, 60): faila=3D 26(D)  failb=3D 60(D=
)  OK
[  456.127173] raid6test: test_disks(26, 61): faila=3D 26(D)  failb=3D 61(D=
)  OK
[  456.271991] raid6test: test_disks(26, 62): faila=3D 26(D)  failb=3D 62(P=
)  OK
[  456.435873] raid6test: test_disks(26, 63): faila=3D 26(D)  failb=3D 63(Q=
)  OK
[  456.625563] raid6test: test_disks(27, 28): faila=3D 27(D)  failb=3D 28(D=
)  OK
[  456.845048] raid6test: test_disks(27, 29): faila=3D 27(D)  failb=3D 29(D=
)  OK
[  457.013444] raid6test: test_disks(27, 30): faila=3D 27(D)  failb=3D 30(D=
)  OK
[  457.214366] raid6test: test_disks(27, 31): faila=3D 27(D)  failb=3D 31(D=
)  OK
[  457.411814] raid6test: test_disks(27, 32): faila=3D 27(D)  failb=3D 32(D=
)  OK
[  457.625417] raid6test: test_disks(27, 33): faila=3D 27(D)  failb=3D 33(D=
)  OK
[  457.920218] raid6test: test_disks(27, 34): faila=3D 27(D)  failb=3D 34(D=
)  OK
[  458.217410] raid6test: test_disks(27, 35): faila=3D 27(D)  failb=3D 35(D=
)  OK
[  458.451486] raid6test: test_disks(27, 36): faila=3D 27(D)  failb=3D 36(D=
)  OK
[  458.631226] raid6test: test_disks(27, 37): faila=3D 27(D)  failb=3D 37(D=
)  OK
[  458.838281] raid6test: test_disks(27, 38): faila=3D 27(D)  failb=3D 38(D=
)  OK
[  459.099199] raid6test: test_disks(27, 39): faila=3D 27(D)  failb=3D 39(D=
)  OK
[  459.359072] raid6test: test_disks(27, 40): faila=3D 27(D)  failb=3D 40(D=
)  OK
[  459.634549] raid6test: test_disks(27, 41): faila=3D 27(D)  failb=3D 41(D=
)  OK
[  459.866807] raid6test: test_disks(27, 42): faila=3D 27(D)  failb=3D 42(D=
)  OK
[  460.113102] raid6test: test_disks(27, 43): faila=3D 27(D)  failb=3D 43(D=
)  OK
[  460.279267] raid6test: test_disks(27, 44): faila=3D 27(D)  failb=3D 44(D=
)  OK
[  460.505002] raid6test: test_disks(27, 45): faila=3D 27(D)  failb=3D 45(D=
)  OK
[  460.666434] raid6test: test_disks(27, 46): faila=3D 27(D)  failb=3D 46(D=
)  OK
[  460.892995] raid6test: test_disks(27, 47): faila=3D 27(D)  failb=3D 47(D=
)  OK
[  461.048973] raid6test: test_disks(27, 48): faila=3D 27(D)  failb=3D 48(D=
)  OK
[  461.278636] raid6test: test_disks(27, 49): faila=3D 27(D)  failb=3D 49(D=
)  OK
[  461.568227] raid6test: test_disks(27, 50): faila=3D 27(D)  failb=3D 50(D=
)  OK
[  461.888952] raid6test: test_disks(27, 51): faila=3D 27(D)  failb=3D 51(D=
)  OK
[  462.144188] raid6test: test_disks(27, 52): faila=3D 27(D)  failb=3D 52(D=
)  OK
[  462.329075] raid6test: test_disks(27, 53): faila=3D 27(D)  failb=3D 53(D=
)  OK
[  462.559169] raid6test: test_disks(27, 54): faila=3D 27(D)  failb=3D 54(D=
)  OK
[  462.803459] raid6test: test_disks(27, 55): faila=3D 27(D)  failb=3D 55(D=
)  OK
[  463.013583] raid6test: test_disks(27, 56): faila=3D 27(D)  failb=3D 56(D=
)  OK
[  463.188816] raid6test: test_disks(27, 57): faila=3D 27(D)  failb=3D 57(D=
)  OK
[  463.381763] raid6test: test_disks(27, 58): faila=3D 27(D)  failb=3D 58(D=
)  OK
[  463.620755] raid6test: test_disks(27, 59): faila=3D 27(D)  failb=3D 59(D=
)  OK
[  463.825309] raid6test: test_disks(27, 60): faila=3D 27(D)  failb=3D 60(D=
)  OK
[  464.003181] raid6test: test_disks(27, 61): faila=3D 27(D)  failb=3D 61(D=
)  OK
[  464.262713] raid6test: test_disks(27, 62): faila=3D 27(D)  failb=3D 62(P=
)  OK
[  464.415627] raid6test: test_disks(27, 63): faila=3D 27(D)  failb=3D 63(Q=
)  OK
[  464.630769] raid6test: test_disks(28, 29): faila=3D 28(D)  failb=3D 29(D=
)  OK
[  464.785315] raid6test: test_disks(28, 30): faila=3D 28(D)  failb=3D 30(D=
)  OK
[  464.939655] raid6test: test_disks(28, 31): faila=3D 28(D)  failb=3D 31(D=
)  OK
[  465.092037] raid6test: test_disks(28, 32): faila=3D 28(D)  failb=3D 32(D=
)  OK
[  465.241348] raid6test: test_disks(28, 33): faila=3D 28(D)  failb=3D 33(D=
)  OK
[  465.394117] raid6test: test_disks(28, 34): faila=3D 28(D)  failb=3D 34(D=
)  OK
[  465.542545] raid6test: test_disks(28, 35): faila=3D 28(D)  failb=3D 35(D=
)  OK
[  465.689265] raid6test: test_disks(28, 36): faila=3D 28(D)  failb=3D 36(D=
)  OK
[  465.837484] raid6test: test_disks(28, 37): faila=3D 28(D)  failb=3D 37(D=
)  OK
[  465.985493] raid6test: test_disks(28, 38): faila=3D 28(D)  failb=3D 38(D=
)  OK
[  466.130565] raid6test: test_disks(28, 39): faila=3D 28(D)  failb=3D 39(D=
)  OK
[  466.277917] raid6test: test_disks(28, 40): faila=3D 28(D)  failb=3D 40(D=
)  OK
[  466.501760] raid6test: test_disks(28, 41): faila=3D 28(D)  failb=3D 41(D=
)  OK
[  466.795604] raid6test: test_disks(28, 42): faila=3D 28(D)  failb=3D 42(D=
)  OK
[  466.980408] raid6test: test_disks(28, 43): faila=3D 28(D)  failb=3D 43(D=
)  OK
[  467.190611] raid6test: test_disks(28, 44): faila=3D 28(D)  failb=3D 44(D=
)  OK
[  467.335516] raid6test: test_disks(28, 45): faila=3D 28(D)  failb=3D 45(D=
)  OK
[  467.488235] raid6test: test_disks(28, 46): faila=3D 28(D)  failb=3D 46(D=
)  OK
[  467.786678] raid6test: test_disks(28, 47): faila=3D 28(D)  failb=3D 47(D=
)  OK
[  467.962054] raid6test: test_disks(28, 48): faila=3D 28(D)  failb=3D 48(D=
)  OK
[  468.120559] raid6test: test_disks(28, 49): faila=3D 28(D)  failb=3D 49(D=
)  OK
[  468.269729] raid6test: test_disks(28, 50): faila=3D 28(D)  failb=3D 50(D=
)  OK
[  468.419530] raid6test: test_disks(28, 51): faila=3D 28(D)  failb=3D 51(D=
)  OK
[  468.598854] raid6test: test_disks(28, 52): faila=3D 28(D)  failb=3D 52(D=
)  OK
[  468.840494] raid6test: test_disks(28, 53): faila=3D 28(D)  failb=3D 53(D=
)  OK
[  468.986423] raid6test: test_disks(28, 54): faila=3D 28(D)  failb=3D 54(D=
)  OK
[  469.177362] raid6test: test_disks(28, 55): faila=3D 28(D)  failb=3D 55(D=
)  OK
[  469.327529] raid6test: test_disks(28, 56): faila=3D 28(D)  failb=3D 56(D=
)  OK
[  469.551852] raid6test: test_disks(28, 57): faila=3D 28(D)  failb=3D 57(D=
)  OK
[  469.809330] raid6test: test_disks(28, 58): faila=3D 28(D)  failb=3D 58(D=
)  OK
[  470.109067] raid6test: test_disks(28, 59): faila=3D 28(D)  failb=3D 59(D=
)  OK
[  470.277871] raid6test: test_disks(28, 60): faila=3D 28(D)  failb=3D 60(D=
)  OK
[  470.446535] raid6test: test_disks(28, 61): faila=3D 28(D)  failb=3D 61(D=
)  OK
[  470.588718] raid6test: test_disks(28, 62): faila=3D 28(D)  failb=3D 62(P=
)  OK
[  470.734107] raid6test: test_disks(28, 63): faila=3D 28(D)  failb=3D 63(Q=
)  OK
[  470.883833] raid6test: test_disks(29, 30): faila=3D 29(D)  failb=3D 30(D=
)  OK
[  471.082091] raid6test: test_disks(29, 31): faila=3D 29(D)  failb=3D 31(D=
)  OK
[  471.243596] raid6test: test_disks(29, 32): faila=3D 29(D)  failb=3D 32(D=
)  OK
[  471.401592] raid6test: test_disks(29, 33): faila=3D 29(D)  failb=3D 33(D=
)  OK
[  471.553769] raid6test: test_disks(29, 34): faila=3D 29(D)  failb=3D 34(D=
)  OK
[  471.707796] raid6test: test_disks(29, 35): faila=3D 29(D)  failb=3D 35(D=
)  OK
[  471.919642] raid6test: test_disks(29, 36): faila=3D 29(D)  failb=3D 36(D=
)  OK
[  472.078935] raid6test: test_disks(29, 37): faila=3D 29(D)  failb=3D 37(D=
)  OK
[  472.255641] raid6test: test_disks(29, 38): faila=3D 29(D)  failb=3D 38(D=
)  OK
[  472.405375] raid6test: test_disks(29, 39): faila=3D 29(D)  failb=3D 39(D=
)  OK
[  472.648877] raid6test: test_disks(29, 40): faila=3D 29(D)  failb=3D 40(D=
)  OK
[  472.796767] raid6test: test_disks(29, 41): faila=3D 29(D)  failb=3D 41(D=
)  OK
[  472.947893] raid6test: test_disks(29, 42): faila=3D 29(D)  failb=3D 42(D=
)  OK
[  473.099676] raid6test: test_disks(29, 43): faila=3D 29(D)  failb=3D 43(D=
)  OK
[  473.351997] raid6test: test_disks(29, 44): faila=3D 29(D)  failb=3D 44(D=
)  OK
[  473.536886] raid6test: test_disks(29, 45): faila=3D 29(D)  failb=3D 45(D=
)  OK
[  473.770364] raid6test: test_disks(29, 46): faila=3D 29(D)  failb=3D 46(D=
)  OK
[  473.957104] raid6test: test_disks(29, 47): faila=3D 29(D)  failb=3D 47(D=
)  OK
[  474.140775] raid6test: test_disks(29, 48): faila=3D 29(D)  failb=3D 48(D=
)  OK
[  474.287092] raid6test: test_disks(29, 49): faila=3D 29(D)  failb=3D 49(D=
)  OK
[  474.438584] raid6test: test_disks(29, 50): faila=3D 29(D)  failb=3D 50(D=
)  OK
[  474.585177] raid6test: test_disks(29, 51): faila=3D 29(D)  failb=3D 51(D=
)  OK
[  474.767011] raid6test: test_disks(29, 52): faila=3D 29(D)  failb=3D 52(D=
)  OK
[  474.988866] raid6test: test_disks(29, 53): faila=3D 29(D)  failb=3D 53(D=
)  OK
[  475.222130] raid6test: test_disks(29, 54): faila=3D 29(D)  failb=3D 54(D=
)  OK
[  475.490218] raid6test: test_disks(29, 55): faila=3D 29(D)  failb=3D 55(D=
)  OK
[  475.683438] raid6test: test_disks(29, 56): faila=3D 29(D)  failb=3D 56(D=
)  OK
[  475.912169] raid6test: test_disks(29, 57): faila=3D 29(D)  failb=3D 57(D=
)  OK
[  476.052161] raid6test: test_disks(29, 58): faila=3D 29(D)  failb=3D 58(D=
)  OK
[  476.279438] raid6test: test_disks(29, 59): faila=3D 29(D)  failb=3D 59(D=
)  OK
[  476.472652] raid6test: test_disks(29, 60): faila=3D 29(D)  failb=3D 60(D=
)  OK
[  476.610940] raid6test: test_disks(29, 61): faila=3D 29(D)  failb=3D 61(D=
)  OK
[  476.799086] raid6test: test_disks(29, 62): faila=3D 29(D)  failb=3D 62(P=
)  OK
[  477.026310] raid6test: test_disks(29, 63): faila=3D 29(D)  failb=3D 63(Q=
)  OK
[  477.245435] raid6test: test_disks(30, 31): faila=3D 30(D)  failb=3D 31(D=
)  OK
[  477.384357] raid6test: test_disks(30, 32): faila=3D 30(D)  failb=3D 32(D=
)  OK
[  477.551080] raid6test: test_disks(30, 33): faila=3D 30(D)  failb=3D 33(D=
)  OK
[  477.693909] raid6test: test_disks(30, 34): faila=3D 30(D)  failb=3D 34(D=
)  OK
[  477.871099] raid6test: test_disks(30, 35): faila=3D 30(D)  failb=3D 35(D=
)  OK
[  478.053998] raid6test: test_disks(30, 36): faila=3D 30(D)  failb=3D 36(D=
)  OK
[  478.199092] raid6test: test_disks(30, 37): faila=3D 30(D)  failb=3D 37(D=
)  OK
[  478.390936] raid6test: test_disks(30, 38): faila=3D 30(D)  failb=3D 38(D=
)  OK
[  478.655295] raid6test: test_disks(30, 39): faila=3D 30(D)  failb=3D 39(D=
)  OK
[  478.893080] raid6test: test_disks(30, 40): faila=3D 30(D)  failb=3D 40(D=
)  OK
[  479.036234] raid6test: test_disks(30, 41): faila=3D 30(D)  failb=3D 41(D=
)  OK
[  479.188341] raid6test: test_disks(30, 42): faila=3D 30(D)  failb=3D 42(D=
)  OK
[  479.360467] raid6test: test_disks(30, 43): faila=3D 30(D)  failb=3D 43(D=
)  OK
[  479.511271] raid6test: test_disks(30, 44): faila=3D 30(D)  failb=3D 44(D=
)  OK
[  479.711783] raid6test: test_disks(30, 45): faila=3D 30(D)  failb=3D 45(D=
)  OK
[  479.864332] raid6test: test_disks(30, 46): faila=3D 30(D)  failb=3D 46(D=
)  OK
[  480.007013] raid6test: test_disks(30, 47): faila=3D 30(D)  failb=3D 47(D=
)  OK
[  480.155963] raid6test: test_disks(30, 48): faila=3D 30(D)  failb=3D 48(D=
)  OK
[  480.302272] raid6test: test_disks(30, 49): faila=3D 30(D)  failb=3D 49(D=
)  OK
[  480.456053] raid6test: test_disks(30, 50): faila=3D 30(D)  failb=3D 50(D=
)  OK
[  480.610104] raid6test: test_disks(30, 51): faila=3D 30(D)  failb=3D 51(D=
)  OK
[  480.892012] raid6test: test_disks(30, 52): faila=3D 30(D)  failb=3D 52(D=
)  OK
[  481.191780] raid6test: test_disks(30, 53): faila=3D 30(D)  failb=3D 53(D=
)  OK
[  481.450622] raid6test: test_disks(30, 54): faila=3D 30(D)  failb=3D 54(D=
)  OK
[  481.608053] raid6test: test_disks(30, 55): faila=3D 30(D)  failb=3D 55(D=
)  OK
[  481.777033] raid6test: test_disks(30, 56): faila=3D 30(D)  failb=3D 56(D=
)  OK
[  481.985346] raid6test: test_disks(30, 57): faila=3D 30(D)  failb=3D 57(D=
)  OK
[  482.214857] raid6test: test_disks(30, 58): faila=3D 30(D)  failb=3D 58(D=
)  OK
[  482.450345] raid6test: test_disks(30, 59): faila=3D 30(D)  failb=3D 59(D=
)  OK
[  482.590924] raid6test: test_disks(30, 60): faila=3D 30(D)  failb=3D 60(D=
)  OK
[  482.807087] raid6test: test_disks(30, 61): faila=3D 30(D)  failb=3D 61(D=
)  OK
[  482.990092] raid6test: test_disks(30, 62): faila=3D 30(D)  failb=3D 62(P=
)  OK
[  483.167912] raid6test: test_disks(30, 63): faila=3D 30(D)  failb=3D 63(Q=
)  OK
[  483.309698] raid6test: test_disks(31, 32): faila=3D 31(D)  failb=3D 32(D=
)  OK
[  483.545545] raid6test: test_disks(31, 33): faila=3D 31(D)  failb=3D 33(D=
)  OK
[  483.726858] raid6test: test_disks(31, 34): faila=3D 31(D)  failb=3D 34(D=
)  OK
[  483.927762] raid6test: test_disks(31, 35): faila=3D 31(D)  failb=3D 35(D=
)  OK
[  484.071869] raid6test: test_disks(31, 36): faila=3D 31(D)  failb=3D 36(D=
)  OK
[  484.215225] raid6test: test_disks(31, 37): faila=3D 31(D)  failb=3D 37(D=
)  OK
[  484.359488] raid6test: test_disks(31, 38): faila=3D 31(D)  failb=3D 38(D=
)  OK
[  484.530380] raid6test: test_disks(31, 39): faila=3D 31(D)  failb=3D 39(D=
)  OK
[  484.804923] raid6test: test_disks(31, 40): faila=3D 31(D)  failb=3D 40(D=
)  OK
[  484.948963] raid6test: test_disks(31, 41): faila=3D 31(D)  failb=3D 41(D=
)  OK
[  485.093651] raid6test: test_disks(31, 42): faila=3D 31(D)  failb=3D 42(D=
)  OK
[  485.238493] raid6test: test_disks(31, 43): faila=3D 31(D)  failb=3D 43(D=
)  OK
[  485.404514] raid6test: test_disks(31, 44): faila=3D 31(D)  failb=3D 44(D=
)  OK
[  485.546980] raid6test: test_disks(31, 45): faila=3D 31(D)  failb=3D 45(D=
)  OK
[  485.729063] raid6test: test_disks(31, 46): faila=3D 31(D)  failb=3D 46(D=
)  OK
[  485.885869] raid6test: test_disks(31, 47): faila=3D 31(D)  failb=3D 47(D=
)  OK
[  486.125587] raid6test: test_disks(31, 48): faila=3D 31(D)  failb=3D 48(D=
)  OK
[  486.359422] raid6test: test_disks(31, 49): faila=3D 31(D)  failb=3D 49(D=
)  OK
[  486.505366] raid6test: test_disks(31, 50): faila=3D 31(D)  failb=3D 50(D=
)  OK
[  486.699612] raid6test: test_disks(31, 51): faila=3D 31(D)  failb=3D 51(D=
)  OK
[  486.909963] raid6test: test_disks(31, 52): faila=3D 31(D)  failb=3D 52(D=
)  OK
[  487.143218] raid6test: test_disks(31, 53): faila=3D 31(D)  failb=3D 53(D=
)  OK
[  487.360874] raid6test: test_disks(31, 54): faila=3D 31(D)  failb=3D 54(D=
)  OK
[  487.651065] raid6test: test_disks(31, 55): faila=3D 31(D)  failb=3D 55(D=
)  OK
[  487.902083] raid6test: test_disks(31, 56): faila=3D 31(D)  failb=3D 56(D=
)  OK
[  488.156526] raid6test: test_disks(31, 57): faila=3D 31(D)  failb=3D 57(D=
)  OK
[  488.303717] raid6test: test_disks(31, 58): faila=3D 31(D)  failb=3D 58(D=
)  OK
[  488.449111] raid6test: test_disks(31, 59): faila=3D 31(D)  failb=3D 59(D=
)  OK
[  488.593917] raid6test: test_disks(31, 60): faila=3D 31(D)  failb=3D 60(D=
)  OK
[  488.776742] raid6test: test_disks(31, 61): faila=3D 31(D)  failb=3D 61(D=
)  OK
[  488.981460] raid6test: test_disks(31, 62): faila=3D 31(D)  failb=3D 62(P=
)  OK
[  489.122717] raid6test: test_disks(31, 63): faila=3D 31(D)  failb=3D 63(Q=
)  OK
[  489.267918] raid6test: test_disks(32, 33): faila=3D 32(D)  failb=3D 33(D=
)  OK
[  489.415655] raid6test: test_disks(32, 34): faila=3D 32(D)  failb=3D 34(D=
)  OK
[  489.560174] raid6test: test_disks(32, 35): faila=3D 32(D)  failb=3D 35(D=
)  OK
[  489.706553] raid6test: test_disks(32, 36): faila=3D 32(D)  failb=3D 36(D=
)  OK
[  489.861369] raid6test: test_disks(32, 37): faila=3D 32(D)  failb=3D 37(D=
)  OK
[  490.007785] raid6test: test_disks(32, 38): faila=3D 32(D)  failb=3D 38(D=
)  OK
[  490.152467] raid6test: test_disks(32, 39): faila=3D 32(D)  failb=3D 39(D=
)  OK
[  490.296165] raid6test: test_disks(32, 40): faila=3D 32(D)  failb=3D 40(D=
)  OK
[  490.440027] raid6test: test_disks(32, 41): faila=3D 32(D)  failb=3D 41(D=
)  OK
[  490.583327] raid6test: test_disks(32, 42): faila=3D 32(D)  failb=3D 42(D=
)  OK
[  490.726404] raid6test: test_disks(32, 43): faila=3D 32(D)  failb=3D 43(D=
)  OK
[  490.870206] raid6test: test_disks(32, 44): faila=3D 32(D)  failb=3D 44(D=
)  OK
[  491.095779] raid6test: test_disks(32, 45): faila=3D 32(D)  failb=3D 45(D=
)  OK
[  491.278594] raid6test: test_disks(32, 46): faila=3D 32(D)  failb=3D 46(D=
)  OK
[  491.473708] raid6test: test_disks(32, 47): faila=3D 32(D)  failb=3D 47(D=
)  OK
[  491.645769] raid6test: test_disks(32, 48): faila=3D 32(D)  failb=3D 48(D=
)  OK
[  491.947133] raid6test: test_disks(32, 49): faila=3D 32(D)  failb=3D 49(D=
)  OK
[  492.188021] raid6test: test_disks(32, 50): faila=3D 32(D)  failb=3D 50(D=
)  OK
[  492.396120] raid6test: test_disks(32, 51): faila=3D 32(D)  failb=3D 51(D=
)  OK
[  492.618311] raid6test: test_disks(32, 52): faila=3D 32(D)  failb=3D 52(D=
)  OK
[  492.812469] raid6test: test_disks(32, 53): faila=3D 32(D)  failb=3D 53(D=
)  OK
[  493.062766] raid6test: test_disks(32, 54): faila=3D 32(D)  failb=3D 54(D=
)  OK
[  493.214540] raid6test: test_disks(32, 55): faila=3D 32(D)  failb=3D 55(D=
)  OK
[  493.389596] raid6test: test_disks(32, 56): faila=3D 32(D)  failb=3D 56(D=
)  OK
[  493.603242] raid6test: test_disks(32, 57): faila=3D 32(D)  failb=3D 57(D=
)  OK
[  493.801859] raid6test: test_disks(32, 58): faila=3D 32(D)  failb=3D 58(D=
)  OK
[  493.951833] raid6test: test_disks(32, 59): faila=3D 32(D)  failb=3D 59(D=
)  OK
[  494.101068] raid6test: test_disks(32, 60): faila=3D 32(D)  failb=3D 60(D=
)  OK
[  494.342719] raid6test: test_disks(32, 61): faila=3D 32(D)  failb=3D 61(D=
)  OK
[  494.491097] raid6test: test_disks(32, 62): faila=3D 32(D)  failb=3D 62(P=
)  OK
[  494.701009] raid6test: test_disks(32, 63): faila=3D 32(D)  failb=3D 63(Q=
)  OK
[  494.941915] raid6test: test_disks(33, 34): faila=3D 33(D)  failb=3D 34(D=
)  OK
[  495.197519] raid6test: test_disks(33, 35): faila=3D 33(D)  failb=3D 35(D=
)  OK
[  495.431896] raid6test: test_disks(33, 36): faila=3D 33(D)  failb=3D 36(D=
)  OK
[  495.586357] raid6test: test_disks(33, 37): faila=3D 33(D)  failb=3D 37(D=
)  OK
[  495.771836] raid6test: test_disks(33, 38): faila=3D 33(D)  failb=3D 38(D=
)  OK
[  495.927107] raid6test: test_disks(33, 39): faila=3D 33(D)  failb=3D 39(D=
)  OK
[  496.088060] raid6test: test_disks(33, 40): faila=3D 33(D)  failb=3D 40(D=
)  OK
[  496.267318] raid6test: test_disks(33, 41): faila=3D 33(D)  failb=3D 41(D=
)  OK
[  496.427327] raid6test: test_disks(33, 42): faila=3D 33(D)  failb=3D 42(D=
)  OK
[  496.582485] raid6test: test_disks(33, 43): faila=3D 33(D)  failb=3D 43(D=
)  OK
[  496.738272] raid6test: test_disks(33, 44): faila=3D 33(D)  failb=3D 44(D=
)  OK
[  496.907183] raid6test: test_disks(33, 45): faila=3D 33(D)  failb=3D 45(D=
)  OK
[  497.117622] raid6test: test_disks(33, 46): faila=3D 33(D)  failb=3D 46(D=
)  OK
[  497.313741] raid6test: test_disks(33, 47): faila=3D 33(D)  failb=3D 47(D=
)  OK
[  497.481675] raid6test: test_disks(33, 48): faila=3D 33(D)  failb=3D 48(D=
)  OK
[  497.637114] raid6test: test_disks(33, 49): faila=3D 33(D)  failb=3D 49(D=
)  OK
[  497.792765] raid6test: test_disks(33, 50): faila=3D 33(D)  failb=3D 50(D=
)  OK
[  497.990428] raid6test: test_disks(33, 51): faila=3D 33(D)  failb=3D 51(D=
)  OK
[  498.299799] raid6test: test_disks(33, 52): faila=3D 33(D)  failb=3D 52(D=
)  OK
[  498.451074] raid6test: test_disks(33, 53): faila=3D 33(D)  failb=3D 53(D=
)  OK
[  498.600193] raid6test: test_disks(33, 54): faila=3D 33(D)  failb=3D 54(D=
)  OK
[  498.746801] raid6test: test_disks(33, 55): faila=3D 33(D)  failb=3D 55(D=
)  OK
[  498.986557] raid6test: test_disks(33, 56): faila=3D 33(D)  failb=3D 56(D=
)  OK
[  499.134778] raid6test: test_disks(33, 57): faila=3D 33(D)  failb=3D 57(D=
)  OK
[  499.286022] raid6test: test_disks(33, 58): faila=3D 33(D)  failb=3D 58(D=
)  OK
[  499.431871] raid6test: test_disks(33, 59): faila=3D 33(D)  failb=3D 59(D=
)  OK
[  499.577247] raid6test: test_disks(33, 60): faila=3D 33(D)  failb=3D 60(D=
)  OK
[  499.735030] raid6test: test_disks(33, 61): faila=3D 33(D)  failb=3D 61(D=
)  OK
[  499.925980] raid6test: test_disks(33, 62): faila=3D 33(D)  failb=3D 62(P=
)  OK
[  500.135603] raid6test: test_disks(33, 63): faila=3D 33(D)  failb=3D 63(Q=
)  OK
[  500.302644] raid6test: test_disks(34, 35): faila=3D 34(D)  failb=3D 35(D=
)  OK
[  500.450445] raid6test: test_disks(34, 36): faila=3D 34(D)  failb=3D 36(D=
)  OK
[  500.622367] raid6test: test_disks(34, 37): faila=3D 34(D)  failb=3D 37(D=
)  OK
[  500.768167] raid6test: test_disks(34, 38): faila=3D 34(D)  failb=3D 38(D=
)  OK
[  500.913261] raid6test: test_disks(34, 39): faila=3D 34(D)  failb=3D 39(D=
)  OK
[  501.197194] raid6test: test_disks(34, 40): faila=3D 34(D)  failb=3D 40(D=
)  OK
[  501.349403] raid6test: test_disks(34, 41): faila=3D 34(D)  failb=3D 41(D=
)  OK
[  501.497198] raid6test: test_disks(34, 42): faila=3D 34(D)  failb=3D 42(D=
)  OK
[  501.644207] raid6test: test_disks(34, 43): faila=3D 34(D)  failb=3D 43(D=
)  OK
[  501.805191] raid6test: test_disks(34, 44): faila=3D 34(D)  failb=3D 44(D=
)  OK
[  502.088221] raid6test: test_disks(34, 45): faila=3D 34(D)  failb=3D 45(D=
)  OK
[  502.337466] raid6test: test_disks(34, 46): faila=3D 34(D)  failb=3D 46(D=
)  OK
[  502.509026] raid6test: test_disks(34, 47): faila=3D 34(D)  failb=3D 47(D=
)  OK
[  502.718485] raid6test: test_disks(34, 48): faila=3D 34(D)  failb=3D 48(D=
)  OK
[  502.861820] raid6test: test_disks(34, 49): faila=3D 34(D)  failb=3D 49(D=
)  OK
[  503.005681] raid6test: test_disks(34, 50): faila=3D 34(D)  failb=3D 50(D=
)  OK
[  503.150299] raid6test: test_disks(34, 51): faila=3D 34(D)  failb=3D 51(D=
)  OK
[  503.296763] raid6test: test_disks(34, 52): faila=3D 34(D)  failb=3D 52(D=
)  OK
[  503.437710] raid6test: test_disks(34, 53): faila=3D 34(D)  failb=3D 53(D=
)  OK
[  503.579664] raid6test: test_disks(34, 54): faila=3D 34(D)  failb=3D 54(D=
)  OK
[  503.722685] raid6test: test_disks(34, 55): faila=3D 34(D)  failb=3D 55(D=
)  OK
[  503.866832] raid6test: test_disks(34, 56): faila=3D 34(D)  failb=3D 56(D=
)  OK
[  504.021111] raid6test: test_disks(34, 57): faila=3D 34(D)  failb=3D 57(D=
)  OK
[  504.322120] raid6test: test_disks(34, 58): faila=3D 34(D)  failb=3D 58(D=
)  OK
[  504.467614] raid6test: test_disks(34, 59): faila=3D 34(D)  failb=3D 59(D=
)  OK
[  504.612293] raid6test: test_disks(34, 60): faila=3D 34(D)  failb=3D 60(D=
)  OK
[  504.756697] raid6test: test_disks(34, 61): faila=3D 34(D)  failb=3D 61(D=
)  OK
[  504.967494] raid6test: test_disks(34, 62): faila=3D 34(D)  failb=3D 62(P=
)  OK
[  505.116835] raid6test: test_disks(34, 63): faila=3D 34(D)  failb=3D 63(Q=
)  OK
[  505.303419] raid6test: test_disks(35, 36): faila=3D 35(D)  failb=3D 36(D=
)  OK
[  505.448081] raid6test: test_disks(35, 37): faila=3D 35(D)  failb=3D 37(D=
)  OK
[  505.598268] raid6test: test_disks(35, 38): faila=3D 35(D)  failb=3D 38(D=
)  OK
[  505.743339] raid6test: test_disks(35, 39): faila=3D 35(D)  failb=3D 39(D=
)  OK
[  505.925901] raid6test: test_disks(35, 40): faila=3D 35(D)  failb=3D 40(D=
)  OK
[  506.069820] raid6test: test_disks(35, 41): faila=3D 35(D)  failb=3D 41(D=
)  OK
[  506.215075] raid6test: test_disks(35, 42): faila=3D 35(D)  failb=3D 42(D=
)  OK
[  506.493377] raid6test: test_disks(35, 43): faila=3D 35(D)  failb=3D 43(D=
)  OK
[  506.723935] raid6test: test_disks(35, 44): faila=3D 35(D)  failb=3D 44(D=
)  OK
[  506.867681] raid6test: test_disks(35, 45): faila=3D 35(D)  failb=3D 45(D=
)  OK
[  507.015121] raid6test: test_disks(35, 46): faila=3D 35(D)  failb=3D 46(D=
)  OK
[  507.161140] raid6test: test_disks(35, 47): faila=3D 35(D)  failb=3D 47(D=
)  OK
[  507.443932] raid6test: test_disks(35, 48): faila=3D 35(D)  failb=3D 48(D=
)  OK
[  507.703247] raid6test: test_disks(35, 49): faila=3D 35(D)  failb=3D 49(D=
)  OK
[  508.005387] raid6test: test_disks(35, 50): faila=3D 35(D)  failb=3D 50(D=
)  OK
[  508.154970] raid6test: test_disks(35, 51): faila=3D 35(D)  failb=3D 51(D=
)  OK
[  508.303042] raid6test: test_disks(35, 52): faila=3D 35(D)  failb=3D 52(D=
)  OK
[  508.452006] raid6test: test_disks(35, 53): faila=3D 35(D)  failb=3D 53(D=
)  OK
[  508.637835] raid6test: test_disks(35, 54): faila=3D 35(D)  failb=3D 54(D=
)  OK
[  508.936577] raid6test: test_disks(35, 55): faila=3D 35(D)  failb=3D 55(D=
)  OK
[  509.151311] raid6test: test_disks(35, 56): faila=3D 35(D)  failb=3D 56(D=
)  OK
[  509.463324] raid6test: test_disks(35, 57): faila=3D 35(D)  failb=3D 57(D=
)  OK
[  509.630673] raid6test: test_disks(35, 58): faila=3D 35(D)  failb=3D 58(D=
)  OK
[  509.779937] raid6test: test_disks(35, 59): faila=3D 35(D)  failb=3D 59(D=
)  OK
[  509.927628] raid6test: test_disks(35, 60): faila=3D 35(D)  failb=3D 60(D=
)  OK
[  510.110821] raid6test: test_disks(35, 61): faila=3D 35(D)  failb=3D 61(D=
)  OK
[  510.357495] raid6test: test_disks(35, 62): faila=3D 35(D)  failb=3D 62(P=
)  OK
[  510.509700] raid6test: test_disks(35, 63): faila=3D 35(D)  failb=3D 63(Q=
)  OK
[  510.705175] raid6test: test_disks(36, 37): faila=3D 36(D)  failb=3D 37(D=
)  OK
[  510.856061] raid6test: test_disks(36, 38): faila=3D 36(D)  failb=3D 38(D=
)  OK
[  511.074951] raid6test: test_disks(36, 39): faila=3D 36(D)  failb=3D 39(D=
)  OK
[  511.398195] raid6test: test_disks(36, 40): faila=3D 36(D)  failb=3D 40(D=
)  OK
[  511.699853] raid6test: test_disks(36, 41): faila=3D 36(D)  failb=3D 41(D=
)  OK
[  511.987562] raid6test: test_disks(36, 42): faila=3D 36(D)  failb=3D 42(D=
)  OK
[  512.248209] raid6test: test_disks(36, 43): faila=3D 36(D)  failb=3D 43(D=
)  OK
[  512.475378] raid6test: test_disks(36, 44): faila=3D 36(D)  failb=3D 44(D=
)  OK
[  512.660563] raid6test: test_disks(36, 45): faila=3D 36(D)  failb=3D 45(D=
)  OK
[  512.809196] raid6test: test_disks(36, 46): faila=3D 36(D)  failb=3D 46(D=
)  OK
[  513.023758] raid6test: test_disks(36, 47): faila=3D 36(D)  failb=3D 47(D=
)  OK
[  513.239423] raid6test: test_disks(36, 48): faila=3D 36(D)  failb=3D 48(D=
)  OK
[  513.477703] raid6test: test_disks(36, 49): faila=3D 36(D)  failb=3D 49(D=
)  OK
[  513.623660] raid6test: test_disks(36, 50): faila=3D 36(D)  failb=3D 50(D=
)  OK
[  513.771135] raid6test: test_disks(36, 51): faila=3D 36(D)  failb=3D 51(D=
)  OK
[  513.922999] raid6test: test_disks(36, 52): faila=3D 36(D)  failb=3D 52(D=
)  OK
[  514.065335] raid6test: test_disks(36, 53): faila=3D 36(D)  failb=3D 53(D=
)  OK
[  514.209989] raid6test: test_disks(36, 54): faila=3D 36(D)  failb=3D 54(D=
)  OK
[  514.390972] raid6test: test_disks(36, 55): faila=3D 36(D)  failb=3D 55(D=
)  OK
[  514.535070] raid6test: test_disks(36, 56): faila=3D 36(D)  failb=3D 56(D=
)  OK
[  514.696905] raid6test: test_disks(36, 57): faila=3D 36(D)  failb=3D 57(D=
)  OK
[  514.839954] raid6test: test_disks(36, 58): faila=3D 36(D)  failb=3D 58(D=
)  OK
[  514.997703] raid6test: test_disks(36, 59): faila=3D 36(D)  failb=3D 59(D=
)  OK
[  515.140063] raid6test: test_disks(36, 60): faila=3D 36(D)  failb=3D 60(D=
)  OK
[  515.361491] raid6test: test_disks(36, 61): faila=3D 36(D)  failb=3D 61(D=
)  OK
[  515.643155] raid6test: test_disks(36, 62): faila=3D 36(D)  failb=3D 62(P=
)  OK
[  515.884933] raid6test: test_disks(36, 63): faila=3D 36(D)  failb=3D 63(Q=
)  OK
[  516.027810] raid6test: test_disks(37, 38): faila=3D 37(D)  failb=3D 38(D=
)  OK
[  516.176756] raid6test: test_disks(37, 39): faila=3D 37(D)  failb=3D 39(D=
)  OK
[  516.386150] raid6test: test_disks(37, 40): faila=3D 37(D)  failb=3D 40(D=
)  OK
[  516.528323] raid6test: test_disks(37, 41): faila=3D 37(D)  failb=3D 41(D=
)  OK
[  516.712191] raid6test: test_disks(37, 42): faila=3D 37(D)  failb=3D 42(D=
)  OK
[  516.858638] raid6test: test_disks(37, 43): faila=3D 37(D)  failb=3D 43(D=
)  OK
[  517.113203] raid6test: test_disks(37, 44): faila=3D 37(D)  failb=3D 44(D=
)  OK
[  517.282932] raid6test: test_disks(37, 45): faila=3D 37(D)  failb=3D 45(D=
)  OK
[  517.440600] raid6test: test_disks(37, 46): faila=3D 37(D)  failb=3D 46(D=
)  OK
[  517.624789] raid6test: test_disks(37, 47): faila=3D 37(D)  failb=3D 47(D=
)  OK
[  517.888295] raid6test: test_disks(37, 48): faila=3D 37(D)  failb=3D 48(D=
)  OK
[  518.067169] raid6test: test_disks(37, 49): faila=3D 37(D)  failb=3D 49(D=
)  OK
[  518.249308] raid6test: test_disks(37, 50): faila=3D 37(D)  failb=3D 50(D=
)  OK
[  518.404875] raid6test: test_disks(37, 51): faila=3D 37(D)  failb=3D 51(D=
)  OK
[  518.658565] raid6test: test_disks(37, 52): faila=3D 37(D)  failb=3D 52(D=
)  OK
[  518.798428] raid6test: test_disks(37, 53): faila=3D 37(D)  failb=3D 53(D=
)  OK
[  519.005263] raid6test: test_disks(37, 54): faila=3D 37(D)  failb=3D 54(D=
)  OK
[  519.177728] raid6test: test_disks(37, 55): faila=3D 37(D)  failb=3D 55(D=
)  OK
[  519.321034] raid6test: test_disks(37, 56): faila=3D 37(D)  failb=3D 56(D=
)  OK
[  519.501151] raid6test: test_disks(37, 57): faila=3D 37(D)  failb=3D 57(D=
)  OK
[  519.651920] raid6test: test_disks(37, 58): faila=3D 37(D)  failb=3D 58(D=
)  OK
[  519.795431] raid6test: test_disks(37, 59): faila=3D 37(D)  failb=3D 59(D=
)  OK
[  519.959277] raid6test: test_disks(37, 60): faila=3D 37(D)  failb=3D 60(D=
)  OK
[  520.142301] raid6test: test_disks(37, 61): faila=3D 37(D)  failb=3D 61(D=
)  OK
[  520.298032] raid6test: test_disks(37, 62): faila=3D 37(D)  failb=3D 62(P=
)  OK
[  520.532099] raid6test: test_disks(37, 63): faila=3D 37(D)  failb=3D 63(Q=
)  OK
[  520.731315] raid6test: test_disks(38, 39): faila=3D 38(D)  failb=3D 39(D=
)  OK
[  520.893457] raid6test: test_disks(38, 40): faila=3D 38(D)  failb=3D 40(D=
)  OK
[  521.041083] raid6test: test_disks(38, 41): faila=3D 38(D)  failb=3D 41(D=
)  OK
[  521.200926] raid6test: test_disks(38, 42): faila=3D 38(D)  failb=3D 42(D=
)  OK
[  521.474723] raid6test: test_disks(38, 43): faila=3D 38(D)  failb=3D 43(D=
)  OK
[  521.681977] raid6test: test_disks(38, 44): faila=3D 38(D)  failb=3D 44(D=
)  OK
[  521.831963] raid6test: test_disks(38, 45): faila=3D 38(D)  failb=3D 45(D=
)  OK
[  522.045395] raid6test: test_disks(38, 46): faila=3D 38(D)  failb=3D 46(D=
)  OK
[  522.190463] raid6test: test_disks(38, 47): faila=3D 38(D)  failb=3D 47(D=
)  OK
[  522.335410] raid6test: test_disks(38, 48): faila=3D 38(D)  failb=3D 48(D=
)  OK
[  522.481072] raid6test: test_disks(38, 49): faila=3D 38(D)  failb=3D 49(D=
)  OK
[  522.630570] raid6test: test_disks(38, 50): faila=3D 38(D)  failb=3D 50(D=
)  OK
[  522.809732] raid6test: test_disks(38, 51): faila=3D 38(D)  failb=3D 51(D=
)  OK
[  522.980850] raid6test: test_disks(38, 52): faila=3D 38(D)  failb=3D 52(D=
)  OK
[  523.152099] raid6test: test_disks(38, 53): faila=3D 38(D)  failb=3D 53(D=
)  OK
[  523.389278] raid6test: test_disks(38, 54): faila=3D 38(D)  failb=3D 54(D=
)  OK
[  523.548002] raid6test: test_disks(38, 55): faila=3D 38(D)  failb=3D 55(D=
)  OK
[  523.717177] raid6test: test_disks(38, 56): faila=3D 38(D)  failb=3D 56(D=
)  OK
[  523.911848] raid6test: test_disks(38, 57): faila=3D 38(D)  failb=3D 57(D=
)  OK
[  524.069408] raid6test: test_disks(38, 58): faila=3D 38(D)  failb=3D 58(D=
)  OK
[  524.368139] raid6test: test_disks(38, 59): faila=3D 38(D)  failb=3D 59(D=
)  OK
[  524.676241] raid6test: test_disks(38, 60): faila=3D 38(D)  failb=3D 60(D=
)  OK
[  524.887931] raid6test: test_disks(38, 61): faila=3D 38(D)  failb=3D 61(D=
)  OK
[  525.091983] raid6test: test_disks(38, 62): faila=3D 38(D)  failb=3D 62(P=
)  OK
[  525.287109] raid6test: test_disks(38, 63): faila=3D 38(D)  failb=3D 63(Q=
)  OK
[  525.467771] raid6test: test_disks(39, 40): faila=3D 39(D)  failb=3D 40(D=
)  OK
[  525.620244] raid6test: test_disks(39, 41): faila=3D 39(D)  failb=3D 41(D=
)  OK
[  525.782022] raid6test: test_disks(39, 42): faila=3D 39(D)  failb=3D 42(D=
)  OK
[  525.947746] raid6test: test_disks(39, 43): faila=3D 39(D)  failb=3D 43(D=
)  OK
[  526.159614] raid6test: test_disks(39, 44): faila=3D 39(D)  failb=3D 44(D=
)  OK
[  526.397904] raid6test: test_disks(39, 45): faila=3D 39(D)  failb=3D 45(D=
)  OK
[  526.660067] raid6test: test_disks(39, 46): faila=3D 39(D)  failb=3D 46(D=
)  OK
[  526.803487] raid6test: test_disks(39, 47): faila=3D 39(D)  failb=3D 47(D=
)  OK
[  526.959308] raid6test: test_disks(39, 48): faila=3D 39(D)  failb=3D 48(D=
)  OK
[  527.102763] raid6test: test_disks(39, 49): faila=3D 39(D)  failb=3D 49(D=
)  OK
[  527.248204] raid6test: test_disks(39, 50): faila=3D 39(D)  failb=3D 50(D=
)  OK
[  527.454376] raid6test: test_disks(39, 51): faila=3D 39(D)  failb=3D 51(D=
)  OK
[  527.640419] raid6test: test_disks(39, 52): faila=3D 39(D)  failb=3D 52(D=
)  OK
[  527.849415] raid6test: test_disks(39, 53): faila=3D 39(D)  failb=3D 53(D=
)  OK
[  527.992655] raid6test: test_disks(39, 54): faila=3D 39(D)  failb=3D 54(D=
)  OK
[  528.143132] raid6test: test_disks(39, 55): faila=3D 39(D)  failb=3D 55(D=
)  OK
[  528.381603] raid6test: test_disks(39, 56): faila=3D 39(D)  failb=3D 56(D=
)  OK
[  528.676243] raid6test: test_disks(39, 57): faila=3D 39(D)  failb=3D 57(D=
)  OK
[  528.927211] raid6test: test_disks(39, 58): faila=3D 39(D)  failb=3D 58(D=
)  OK
[  529.139959] raid6test: test_disks(39, 59): faila=3D 39(D)  failb=3D 59(D=
)  OK
[  529.284594] raid6test: test_disks(39, 60): faila=3D 39(D)  failb=3D 60(D=
)  OK
[  529.483975] raid6test: test_disks(39, 61): faila=3D 39(D)  failb=3D 61(D=
)  OK
[  529.654680] raid6test: test_disks(39, 62): faila=3D 39(D)  failb=3D 62(P=
)  OK
[  529.802960] raid6test: test_disks(39, 63): faila=3D 39(D)  failb=3D 63(Q=
)  OK
[  529.954735] raid6test: test_disks(40, 41): faila=3D 40(D)  failb=3D 41(D=
)  OK
[  530.118619] raid6test: test_disks(40, 42): faila=3D 40(D)  failb=3D 42(D=
)  OK
[  530.293321] raid6test: test_disks(40, 43): faila=3D 40(D)  failb=3D 43(D=
)  OK
[  530.485846] raid6test: test_disks(40, 44): faila=3D 40(D)  failb=3D 44(D=
)  OK
[  530.733434] raid6test: test_disks(40, 45): faila=3D 40(D)  failb=3D 45(D=
)  OK
[  530.888064] raid6test: test_disks(40, 46): faila=3D 40(D)  failb=3D 46(D=
)  OK
[  531.032445] raid6test: test_disks(40, 47): faila=3D 40(D)  failb=3D 47(D=
)  OK
[  531.280181] raid6test: test_disks(40, 48): faila=3D 40(D)  failb=3D 48(D=
)  OK
[  531.512113] raid6test: test_disks(40, 49): faila=3D 40(D)  failb=3D 49(D=
)  OK
[  531.655926] raid6test: test_disks(40, 50): faila=3D 40(D)  failb=3D 50(D=
)  OK
[  531.859822] raid6test: test_disks(40, 51): faila=3D 40(D)  failb=3D 51(D=
)  OK
[  532.001453] raid6test: test_disks(40, 52): faila=3D 40(D)  failb=3D 52(D=
)  OK
[  532.212368] raid6test: test_disks(40, 53): faila=3D 40(D)  failb=3D 53(D=
)  OK
[  532.449074] raid6test: test_disks(40, 54): faila=3D 40(D)  failb=3D 54(D=
)  OK
[  532.594958] raid6test: test_disks(40, 55): faila=3D 40(D)  failb=3D 55(D=
)  OK
[  532.738525] raid6test: test_disks(40, 56): faila=3D 40(D)  failb=3D 56(D=
)  OK
[  532.884574] raid6test: test_disks(40, 57): faila=3D 40(D)  failb=3D 57(D=
)  OK
[  533.027143] raid6test: test_disks(40, 58): faila=3D 40(D)  failb=3D 58(D=
)  OK
[  533.172855] raid6test: test_disks(40, 59): faila=3D 40(D)  failb=3D 59(D=
)  OK
[  533.315531] raid6test: test_disks(40, 60): faila=3D 40(D)  failb=3D 60(D=
)  OK
[  533.492098] raid6test: test_disks(40, 61): faila=3D 40(D)  failb=3D 61(D=
)  OK
[  533.762316] raid6test: test_disks(40, 62): faila=3D 40(D)  failb=3D 62(P=
)  OK
[  533.967790] raid6test: test_disks(40, 63): faila=3D 40(D)  failb=3D 63(Q=
)  OK
[  534.195335] raid6test: test_disks(41, 42): faila=3D 41(D)  failb=3D 42(D=
)  OK
[  534.347215] raid6test: test_disks(41, 43): faila=3D 41(D)  failb=3D 43(D=
)  OK
[  534.498904] raid6test: test_disks(41, 44): faila=3D 41(D)  failb=3D 44(D=
)  OK
[  534.647546] raid6test: test_disks(41, 45): faila=3D 41(D)  failb=3D 45(D=
)  OK
[  534.795317] raid6test: test_disks(41, 46): faila=3D 41(D)  failb=3D 46(D=
)  OK
[  535.011950] raid6test: test_disks(41, 47): faila=3D 41(D)  failb=3D 47(D=
)  OK
[  535.174812] raid6test: test_disks(41, 48): faila=3D 41(D)  failb=3D 48(D=
)  OK
[  535.382948] raid6test: test_disks(41, 49): faila=3D 41(D)  failb=3D 49(D=
)  OK
[  535.547233] raid6test: test_disks(41, 50): faila=3D 41(D)  failb=3D 50(D=
)  OK
[  535.689302] raid6test: test_disks(41, 51): faila=3D 41(D)  failb=3D 51(D=
)  OK
[  535.855884] raid6test: test_disks(41, 52): faila=3D 41(D)  failb=3D 52(D=
)  OK
[  536.002478] raid6test: test_disks(41, 53): faila=3D 41(D)  failb=3D 53(D=
)  OK
[  536.155406] raid6test: test_disks(41, 54): faila=3D 41(D)  failb=3D 54(D=
)  OK
[  536.299351] raid6test: test_disks(41, 55): faila=3D 41(D)  failb=3D 55(D=
)  OK
[  536.442640] raid6test: test_disks(41, 56): faila=3D 41(D)  failb=3D 56(D=
)  OK
[  536.641798] raid6test: test_disks(41, 57): faila=3D 41(D)  failb=3D 57(D=
)  OK
[  536.925962] raid6test: test_disks(41, 58): faila=3D 41(D)  failb=3D 58(D=
)  OK
[  537.162667] raid6test: test_disks(41, 59): faila=3D 41(D)  failb=3D 59(D=
)  OK
[  537.317395] raid6test: test_disks(41, 60): faila=3D 41(D)  failb=3D 60(D=
)  OK
[  537.468069] raid6test: test_disks(41, 61): faila=3D 41(D)  failb=3D 61(D=
)  OK
[  537.611481] raid6test: test_disks(41, 62): faila=3D 41(D)  failb=3D 62(P=
)  OK
[  537.850376] raid6test: test_disks(41, 63): faila=3D 41(D)  failb=3D 63(Q=
)  OK
[  537.999823] raid6test: test_disks(42, 43): faila=3D 42(D)  failb=3D 43(D=
)  OK
[  538.182597] raid6test: test_disks(42, 44): faila=3D 42(D)  failb=3D 44(D=
)  OK
[  538.412710] raid6test: test_disks(42, 45): faila=3D 42(D)  failb=3D 45(D=
)  OK
[  538.598342] raid6test: test_disks(42, 46): faila=3D 42(D)  failb=3D 46(D=
)  OK
[  538.761767] raid6test: test_disks(42, 47): faila=3D 42(D)  failb=3D 47(D=
)  OK
[  538.963582] raid6test: test_disks(42, 48): faila=3D 42(D)  failb=3D 48(D=
)  OK
[  539.258931] raid6test: test_disks(42, 49): faila=3D 42(D)  failb=3D 49(D=
)  OK
[  539.541921] raid6test: test_disks(42, 50): faila=3D 42(D)  failb=3D 50(D=
)  OK
[  539.744646] raid6test: test_disks(42, 51): faila=3D 42(D)  failb=3D 51(D=
)  OK
[  539.887681] raid6test: test_disks(42, 52): faila=3D 42(D)  failb=3D 52(D=
)  OK
[  540.032868] raid6test: test_disks(42, 53): faila=3D 42(D)  failb=3D 53(D=
)  OK
[  540.292238] raid6test: test_disks(42, 54): faila=3D 42(D)  failb=3D 54(D=
)  OK
[  540.440571] raid6test: test_disks(42, 55): faila=3D 42(D)  failb=3D 55(D=
)  OK
[  540.584489] raid6test: test_disks(42, 56): faila=3D 42(D)  failb=3D 56(D=
)  OK
[  540.741882] raid6test: test_disks(42, 57): faila=3D 42(D)  failb=3D 57(D=
)  OK
[  540.888948] raid6test: test_disks(42, 58): faila=3D 42(D)  failb=3D 58(D=
)  OK
[  541.094598] raid6test: test_disks(42, 59): faila=3D 42(D)  failb=3D 59(D=
)  OK
[  541.323832] raid6test: test_disks(42, 60): faila=3D 42(D)  failb=3D 60(D=
)  OK
[  541.550454] raid6test: test_disks(42, 61): faila=3D 42(D)  failb=3D 61(D=
)  OK
[  541.695563] raid6test: test_disks(42, 62): faila=3D 42(D)  failb=3D 62(P=
)  OK
[  541.841311] raid6test: test_disks(42, 63): faila=3D 42(D)  failb=3D 63(Q=
)  OK
[  542.074075] raid6test: test_disks(43, 44): faila=3D 43(D)  failb=3D 44(D=
)  OK
[  542.268951] raid6test: test_disks(43, 45): faila=3D 43(D)  failb=3D 45(D=
)  OK
[  542.421675] raid6test: test_disks(43, 46): faila=3D 43(D)  failb=3D 46(D=
)  OK
[  542.572847] raid6test: test_disks(43, 47): faila=3D 43(D)  failb=3D 47(D=
)  OK
[  542.728165] raid6test: test_disks(43, 48): faila=3D 43(D)  failb=3D 48(D=
)  OK
[  542.939507] raid6test: test_disks(43, 49): faila=3D 43(D)  failb=3D 49(D=
)  OK
[  543.090082] raid6test: test_disks(43, 50): faila=3D 43(D)  failb=3D 50(D=
)  OK
[  543.315208] raid6test: test_disks(43, 51): faila=3D 43(D)  failb=3D 51(D=
)  OK
[  543.488720] raid6test: test_disks(43, 52): faila=3D 43(D)  failb=3D 52(D=
)  OK
[  543.657509] raid6test: test_disks(43, 53): faila=3D 43(D)  failb=3D 53(D=
)  OK
[  543.827697] raid6test: test_disks(43, 54): faila=3D 43(D)  failb=3D 54(D=
)  OK
[  544.033147] raid6test: test_disks(43, 55): faila=3D 43(D)  failb=3D 55(D=
)  OK
[  544.207941] raid6test: test_disks(43, 56): faila=3D 43(D)  failb=3D 56(D=
)  OK
[  544.380691] raid6test: test_disks(43, 57): faila=3D 43(D)  failb=3D 57(D=
)  OK
[  544.657518] raid6test: test_disks(43, 58): faila=3D 43(D)  failb=3D 58(D=
)  OK
[  544.919764] raid6test: test_disks(43, 59): faila=3D 43(D)  failb=3D 59(D=
)  OK
[  545.087849] raid6test: test_disks(43, 60): faila=3D 43(D)  failb=3D 60(D=
)  OK
[  545.356184] raid6test: test_disks(43, 61): faila=3D 43(D)  failb=3D 61(D=
)  OK
[  545.549292] raid6test: test_disks(43, 62): faila=3D 43(D)  failb=3D 62(P=
)  OK
[  545.689274] raid6test: test_disks(43, 63): faila=3D 43(D)  failb=3D 63(Q=
)  OK
[  545.862614] raid6test: test_disks(44, 45): faila=3D 44(D)  failb=3D 45(D=
)  OK
[  546.019941] raid6test: test_disks(44, 46): faila=3D 44(D)  failb=3D 46(D=
)  OK
[  546.216104] raid6test: test_disks(44, 47): faila=3D 44(D)  failb=3D 47(D=
)  OK
[  546.367892] raid6test: test_disks(44, 48): faila=3D 44(D)  failb=3D 48(D=
)  OK
[  546.544327] raid6test: test_disks(44, 49): faila=3D 44(D)  failb=3D 49(D=
)  OK
[  546.729325] raid6test: test_disks(44, 50): faila=3D 44(D)  failb=3D 50(D=
)  OK
[  546.995106] raid6test: test_disks(44, 51): faila=3D 44(D)  failb=3D 51(D=
)  OK
[  547.246907] raid6test: test_disks(44, 52): faila=3D 44(D)  failb=3D 52(D=
)  OK
[  547.516781] raid6test: test_disks(44, 53): faila=3D 44(D)  failb=3D 53(D=
)  OK
[  547.703757] raid6test: test_disks(44, 54): faila=3D 44(D)  failb=3D 54(D=
)  OK
[  547.876043] raid6test: test_disks(44, 55): faila=3D 44(D)  failb=3D 55(D=
)  OK
[  548.058115] raid6test: test_disks(44, 56): faila=3D 44(D)  failb=3D 56(D=
)  OK
[  548.320727] raid6test: test_disks(44, 57): faila=3D 44(D)  failb=3D 57(D=
)  OK
[  548.465873] raid6test: test_disks(44, 58): faila=3D 44(D)  failb=3D 58(D=
)  OK
[  548.610425] raid6test: test_disks(44, 59): faila=3D 44(D)  failb=3D 59(D=
)  OK
[  548.782221] raid6test: test_disks(44, 60): faila=3D 44(D)  failb=3D 60(D=
)  OK
[  548.996947] raid6test: test_disks(44, 61): faila=3D 44(D)  failb=3D 61(D=
)  OK
[  549.231674] raid6test: test_disks(44, 62): faila=3D 44(D)  failb=3D 62(P=
)  OK
[  549.493832] raid6test: test_disks(44, 63): faila=3D 44(D)  failb=3D 63(Q=
)  OK
[  549.688029] raid6test: test_disks(45, 46): faila=3D 45(D)  failb=3D 46(D=
)  OK
[  549.841633] raid6test: test_disks(45, 47): faila=3D 45(D)  failb=3D 47(D=
)  OK
[  549.992733] raid6test: test_disks(45, 48): faila=3D 45(D)  failb=3D 48(D=
)  OK
[  550.142804] raid6test: test_disks(45, 49): faila=3D 45(D)  failb=3D 49(D=
)  OK
[  550.294367] raid6test: test_disks(45, 50): faila=3D 45(D)  failb=3D 50(D=
)  OK
[  550.459677] raid6test: test_disks(45, 51): faila=3D 45(D)  failb=3D 51(D=
)  OK
[  550.611094] raid6test: test_disks(45, 52): faila=3D 45(D)  failb=3D 52(D=
)  OK
[  550.761716] raid6test: test_disks(45, 53): faila=3D 45(D)  failb=3D 53(D=
)  OK
[  550.913220] raid6test: test_disks(45, 54): faila=3D 45(D)  failb=3D 54(D=
)  OK
[  551.063704] raid6test: test_disks(45, 55): faila=3D 45(D)  failb=3D 55(D=
)  OK
[  551.235169] raid6test: test_disks(45, 56): faila=3D 45(D)  failb=3D 56(D=
)  OK
[  551.432954] raid6test: test_disks(45, 57): faila=3D 45(D)  failb=3D 57(D=
)  OK
[  551.631553] raid6test: test_disks(45, 58): faila=3D 45(D)  failb=3D 58(D=
)  OK
[  551.779505] raid6test: test_disks(45, 59): faila=3D 45(D)  failb=3D 59(D=
)  OK
[  551.929160] raid6test: test_disks(45, 60): faila=3D 45(D)  failb=3D 60(D=
)  OK
[  552.093092] raid6test: test_disks(45, 61): faila=3D 45(D)  failb=3D 61(D=
)  OK
[  552.269661] raid6test: test_disks(45, 62): faila=3D 45(D)  failb=3D 62(P=
)  OK
[  552.421998] raid6test: test_disks(45, 63): faila=3D 45(D)  failb=3D 63(Q=
)  OK
[  552.573750] raid6test: test_disks(46, 47): faila=3D 46(D)  failb=3D 47(D=
)  OK
[  552.729182] raid6test: test_disks(46, 48): faila=3D 46(D)  failb=3D 48(D=
)  OK
[  552.880155] raid6test: test_disks(46, 49): faila=3D 46(D)  failb=3D 49(D=
)  OK
[  553.058848] raid6test: test_disks(46, 50): faila=3D 46(D)  failb=3D 50(D=
)  OK
[  553.212745] raid6test: test_disks(46, 51): faila=3D 46(D)  failb=3D 51(D=
)  OK
[  553.369716] raid6test: test_disks(46, 52): faila=3D 46(D)  failb=3D 52(D=
)  OK
[  553.523999] raid6test: test_disks(46, 53): faila=3D 46(D)  failb=3D 53(D=
)  OK
[  553.680346] raid6test: test_disks(46, 54): faila=3D 46(D)  failb=3D 54(D=
)  OK
[  553.843417] raid6test: test_disks(46, 55): faila=3D 46(D)  failb=3D 55(D=
)  OK
[  554.005769] raid6test: test_disks(46, 56): faila=3D 46(D)  failb=3D 56(D=
)  OK
[  554.159067] raid6test: test_disks(46, 57): faila=3D 46(D)  failb=3D 57(D=
)  OK
[  554.311681] raid6test: test_disks(46, 58): faila=3D 46(D)  failb=3D 58(D=
)  OK
[  554.458806] raid6test: test_disks(46, 59): faila=3D 46(D)  failb=3D 59(D=
)  OK
[  554.607762] raid6test: test_disks(46, 60): faila=3D 46(D)  failb=3D 60(D=
)  OK
[  554.757172] raid6test: test_disks(46, 61): faila=3D 46(D)  failb=3D 61(D=
)  OK
[  554.917580] raid6test: test_disks(46, 62): faila=3D 46(D)  failb=3D 62(P=
)  OK
[  555.201966] raid6test: test_disks(46, 63): faila=3D 46(D)  failb=3D 63(Q=
)  OK
[  555.356138] raid6test: test_disks(47, 48): faila=3D 47(D)  failb=3D 48(D=
)  OK
[  555.516684] raid6test: test_disks(47, 49): faila=3D 47(D)  failb=3D 49(D=
)  OK
[  555.674653] raid6test: test_disks(47, 50): faila=3D 47(D)  failb=3D 50(D=
)  OK
[  555.833534] raid6test: test_disks(47, 51): faila=3D 47(D)  failb=3D 51(D=
)  OK
[  555.988150] raid6test: test_disks(47, 52): faila=3D 47(D)  failb=3D 52(D=
)  OK
[  556.292440] raid6test: test_disks(47, 53): faila=3D 47(D)  failb=3D 53(D=
)  OK
[  556.547776] raid6test: test_disks(47, 54): faila=3D 47(D)  failb=3D 54(D=
)  OK
[  556.700769] raid6test: test_disks(47, 55): faila=3D 47(D)  failb=3D 55(D=
)  OK
[  556.866651] raid6test: test_disks(47, 56): faila=3D 47(D)  failb=3D 56(D=
)  OK
[  557.017550] raid6test: test_disks(47, 57): faila=3D 47(D)  failb=3D 57(D=
)  OK
[  557.169392] raid6test: test_disks(47, 58): faila=3D 47(D)  failb=3D 58(D=
)  OK
[  557.362507] raid6test: test_disks(47, 59): faila=3D 47(D)  failb=3D 59(D=
)  OK
[  557.558382] raid6test: test_disks(47, 60): faila=3D 47(D)  failb=3D 60(D=
)  OK
[  557.729045] raid6test: test_disks(47, 61): faila=3D 47(D)  failb=3D 61(D=
)  OK
[  557.888496] raid6test: test_disks(47, 62): faila=3D 47(D)  failb=3D 62(P=
)  OK
[  558.043840] raid6test: test_disks(47, 63): faila=3D 47(D)  failb=3D 63(Q=
)  OK
[  558.208231] raid6test: test_disks(48, 49): faila=3D 48(D)  failb=3D 49(D=
)  OK
[  558.423433] raid6test: test_disks(48, 50): faila=3D 48(D)  failb=3D 50(D=
)  OK
[  558.577219] raid6test: test_disks(48, 51): faila=3D 48(D)  failb=3D 51(D=
)  OK
[  558.810349] raid6test: test_disks(48, 52): faila=3D 48(D)  failb=3D 52(D=
)  OK
[  558.998996] raid6test: test_disks(48, 53): faila=3D 48(D)  failb=3D 53(D=
)  OK
[  559.263014] raid6test: test_disks(48, 54): faila=3D 48(D)  failb=3D 54(D=
)  OK
[  559.516684] raid6test: test_disks(48, 55): faila=3D 48(D)  failb=3D 55(D=
)  OK
[  559.821482] raid6test: test_disks(48, 56): faila=3D 48(D)  failb=3D 56(D=
)  OK
[  559.998512] raid6test: test_disks(48, 57): faila=3D 48(D)  failb=3D 57(D=
)  OK
[  560.226524] raid6test: test_disks(48, 58): faila=3D 48(D)  failb=3D 58(D=
)  OK
[  560.524027] raid6test: test_disks(48, 59): faila=3D 48(D)  failb=3D 59(D=
)  OK
[  560.772623] raid6test: test_disks(48, 60): faila=3D 48(D)  failb=3D 60(D=
)  OK
[  561.029718] raid6test: test_disks(48, 61): faila=3D 48(D)  failb=3D 61(D=
)  OK
[  561.246378] raid6test: test_disks(48, 62): faila=3D 48(D)  failb=3D 62(P=
)  OK
[  561.426258] raid6test: test_disks(48, 63): faila=3D 48(D)  failb=3D 63(Q=
)  OK
[  561.604085] raid6test: test_disks(49, 50): faila=3D 49(D)  failb=3D 50(D=
)  OK
[  561.770384] raid6test: test_disks(49, 51): faila=3D 49(D)  failb=3D 51(D=
)  OK
[  561.928237] raid6test: test_disks(49, 52): faila=3D 49(D)  failb=3D 52(D=
)  OK
[  562.136573] raid6test: test_disks(49, 53): faila=3D 49(D)  failb=3D 53(D=
)  OK
[  562.345006] raid6test: test_disks(49, 54): faila=3D 49(D)  failb=3D 54(D=
)  OK
[  562.502042] raid6test: test_disks(49, 55): faila=3D 49(D)  failb=3D 55(D=
)  OK
[  562.728221] raid6test: test_disks(49, 56): faila=3D 49(D)  failb=3D 56(D=
)  OK
[  562.889677] raid6test: test_disks(49, 57): faila=3D 49(D)  failb=3D 57(D=
)  OK
[  563.048656] raid6test: test_disks(49, 58): faila=3D 49(D)  failb=3D 58(D=
)  OK
[  563.206228] raid6test: test_disks(49, 59): faila=3D 49(D)  failb=3D 59(D=
)  OK
[  563.397786] raid6test: test_disks(49, 60): faila=3D 49(D)  failb=3D 60(D=
)  OK
[  563.642158] raid6test: test_disks(49, 61): faila=3D 49(D)  failb=3D 61(D=
)  OK
[  563.801903] raid6test: test_disks(49, 62): faila=3D 49(D)  failb=3D 62(P=
)  OK
[  563.971290] raid6test: test_disks(49, 63): faila=3D 49(D)  failb=3D 63(Q=
)  OK
[  564.134454] raid6test: test_disks(50, 51): faila=3D 50(D)  failb=3D 51(D=
)  OK
[  564.299203] raid6test: test_disks(50, 52): faila=3D 50(D)  failb=3D 52(D=
)  OK
[  564.458884] raid6test: test_disks(50, 53): faila=3D 50(D)  failb=3D 53(D=
)  OK
[  564.723674] raid6test: test_disks(50, 54): faila=3D 50(D)  failb=3D 54(D=
)  OK
[  564.882234] raid6test: test_disks(50, 55): faila=3D 50(D)  failb=3D 55(D=
)  OK
[  565.167545] raid6test: test_disks(50, 56): faila=3D 50(D)  failb=3D 56(D=
)  OK
[  565.486972] raid6test: test_disks(50, 57): faila=3D 50(D)  failb=3D 57(D=
)  OK
[  565.655273] raid6test: test_disks(50, 58): faila=3D 50(D)  failb=3D 58(D=
)  OK
[  565.817782] raid6test: test_disks(50, 59): faila=3D 50(D)  failb=3D 59(D=
)  OK
[  565.972731] raid6test: test_disks(50, 60): faila=3D 50(D)  failb=3D 60(D=
)  OK
[  566.163733] raid6test: test_disks(50, 61): faila=3D 50(D)  failb=3D 61(D=
)  OK
[  566.317252] raid6test: test_disks(50, 62): faila=3D 50(D)  failb=3D 62(P=
)  OK
[  566.472173] raid6test: test_disks(50, 63): faila=3D 50(D)  failb=3D 63(Q=
)  OK
[  566.626466] raid6test: test_disks(51, 52): faila=3D 51(D)  failb=3D 52(D=
)  OK
[  566.796965] raid6test: test_disks(51, 53): faila=3D 51(D)  failb=3D 53(D=
)  OK
[  566.958728] raid6test: test_disks(51, 54): faila=3D 51(D)  failb=3D 54(D=
)  OK
[  567.112296] raid6test: test_disks(51, 55): faila=3D 51(D)  failb=3D 55(D=
)  OK
[  567.315461] raid6test: test_disks(51, 56): faila=3D 51(D)  failb=3D 56(D=
)  OK
[  567.512929] raid6test: test_disks(51, 57): faila=3D 51(D)  failb=3D 57(D=
)  OK
[  567.690999] raid6test: test_disks(51, 58): faila=3D 51(D)  failb=3D 58(D=
)  OK
[  567.961290] raid6test: test_disks(51, 59): faila=3D 51(D)  failb=3D 59(D=
)  OK
[  568.165066] raid6test: test_disks(51, 60): faila=3D 51(D)  failb=3D 60(D=
)  OK
[  568.437264] raid6test: test_disks(51, 61): faila=3D 51(D)  failb=3D 61(D=
)  OK
[  568.700251] raid6test: test_disks(51, 62): faila=3D 51(D)  failb=3D 62(P=
)  OK
[  568.909818] raid6test: test_disks(51, 63): faila=3D 51(D)  failb=3D 63(Q=
)  OK
[  569.081745] raid6test: test_disks(52, 53): faila=3D 52(D)  failb=3D 53(D=
)  OK
[  569.246021] raid6test: test_disks(52, 54): faila=3D 52(D)  failb=3D 54(D=
)  OK
[  569.476232] raid6test: test_disks(52, 55): faila=3D 52(D)  failb=3D 55(D=
)  OK
[  569.736387] raid6test: test_disks(52, 56): faila=3D 52(D)  failb=3D 56(D=
)  OK
[  570.072424] raid6test: test_disks(52, 57): faila=3D 52(D)  failb=3D 57(D=
)  OK
[  570.268731] raid6test: test_disks(52, 58): faila=3D 52(D)  failb=3D 58(D=
)  OK
[  570.466929] raid6test: test_disks(52, 59): faila=3D 52(D)  failb=3D 59(D=
)  OK
[  570.719129] raid6test: test_disks(52, 60): faila=3D 52(D)  failb=3D 60(D=
)  OK
[  570.995234] raid6test: test_disks(52, 61): faila=3D 52(D)  failb=3D 61(D=
)  OK
[  571.255568] raid6test: test_disks(52, 62): faila=3D 52(D)  failb=3D 62(P=
)  OK
[  571.457421] raid6test: test_disks(52, 63): faila=3D 52(D)  failb=3D 63(Q=
)  OK
[  571.730391] raid6test: test_disks(53, 54): faila=3D 53(D)  failb=3D 54(D=
)  OK
[  571.986741] raid6test: test_disks(53, 55): faila=3D 53(D)  failb=3D 55(D=
)  OK
[  572.195355] raid6test: test_disks(53, 56): faila=3D 53(D)  failb=3D 56(D=
)  OK
[  572.428132] raid6test: test_disks(53, 57): faila=3D 53(D)  failb=3D 57(D=
)  OK
[  572.692667] raid6test: test_disks(53, 58): faila=3D 53(D)  failb=3D 58(D=
)  OK
[  572.955282] raid6test: test_disks(53, 59): faila=3D 53(D)  failb=3D 59(D=
)  OK
[  573.214239] raid6test: test_disks(53, 60): faila=3D 53(D)  failb=3D 60(D=
)  OK
[  573.504249] raid6test: test_disks(53, 61): faila=3D 53(D)  failb=3D 61(D=
)  OK
[  573.705340] raid6test: test_disks(53, 62): faila=3D 53(D)  failb=3D 62(P=
)  OK
[  573.974599] raid6test: test_disks(53, 63): faila=3D 53(D)  failb=3D 63(Q=
)  OK
[  574.296230] raid6test: test_disks(54, 55): faila=3D 54(D)  failb=3D 55(D=
)  OK
[  574.521049] raid6test: test_disks(54, 56): faila=3D 54(D)  failb=3D 56(D=
)  OK
[  574.689564] raid6test: test_disks(54, 57): faila=3D 54(D)  failb=3D 57(D=
)  OK
[  574.854042] raid6test: test_disks(54, 58): faila=3D 54(D)  failb=3D 58(D=
)  OK
[  575.097596] raid6test: test_disks(54, 59): faila=3D 54(D)  failb=3D 59(D=
)  OK
[  575.301740] raid6test: test_disks(54, 60): faila=3D 54(D)  failb=3D 60(D=
)  OK
[  575.520115] raid6test: test_disks(54, 61): faila=3D 54(D)  failb=3D 61(D=
)  OK
[  575.719191] raid6test: test_disks(54, 62): faila=3D 54(D)  failb=3D 62(P=
)  OK
[  575.941872] raid6test: test_disks(54, 63): faila=3D 54(D)  failb=3D 63(Q=
)  OK
[  576.206105] raid6test: test_disks(55, 56): faila=3D 55(D)  failb=3D 56(D=
)  OK
[  576.501417] raid6test: test_disks(55, 57): faila=3D 55(D)  failb=3D 57(D=
)  OK
[  576.738433] raid6test: test_disks(55, 58): faila=3D 55(D)  failb=3D 58(D=
)  OK
[  576.963491] raid6test: test_disks(55, 59): faila=3D 55(D)  failb=3D 59(D=
)  OK
[  577.164712] raid6test: test_disks(55, 60): faila=3D 55(D)  failb=3D 60(D=
)  OK
[  577.393372] raid6test: test_disks(55, 61): faila=3D 55(D)  failb=3D 61(D=
)  OK
[  577.594294] raid6test: test_disks(55, 62): faila=3D 55(D)  failb=3D 62(P=
)  OK
[  577.824866] raid6test: test_disks(55, 63): faila=3D 55(D)  failb=3D 63(Q=
)  OK
[  578.086036] raid6test: test_disks(56, 57): faila=3D 56(D)  failb=3D 57(D=
)  OK
[  578.284749] raid6test: test_disks(56, 58): faila=3D 56(D)  failb=3D 58(D=
)  OK
[  578.481906] raid6test: test_disks(56, 59): faila=3D 56(D)  failb=3D 59(D=
)  OK
[  578.741000] raid6test: test_disks(56, 60): faila=3D 56(D)  failb=3D 60(D=
)  OK
[  578.946898] raid6test: test_disks(56, 61): faila=3D 56(D)  failb=3D 61(D=
)  OK
[  579.112495] raid6test: test_disks(56, 62): faila=3D 56(D)  failb=3D 62(P=
)  OK
[  579.356453] raid6test: test_disks(56, 63): faila=3D 56(D)  failb=3D 63(Q=
)  OK
[  579.531181] raid6test: test_disks(57, 58): faila=3D 57(D)  failb=3D 58(D=
)  OK
[  579.747253] raid6test: test_disks(57, 59): faila=3D 57(D)  failb=3D 59(D=
)  OK
[  579.970256] raid6test: test_disks(57, 60): faila=3D 57(D)  failb=3D 60(D=
)  OK
[  580.204380] raid6test: test_disks(57, 61): faila=3D 57(D)  failb=3D 61(D=
)  OK
[  580.380475] raid6test: test_disks(57, 62): faila=3D 57(D)  failb=3D 62(P=
)  OK
[  580.556233] raid6test: test_disks(57, 63): faila=3D 57(D)  failb=3D 63(Q=
)  OK
[  580.782099] raid6test: test_disks(58, 59): faila=3D 58(D)  failb=3D 59(D=
)  OK
[  580.957053] raid6test: test_disks(58, 60): faila=3D 58(D)  failb=3D 60(D=
)  OK
[  581.134858] raid6test: test_disks(58, 61): faila=3D 58(D)  failb=3D 61(D=
)  OK
[  581.313856] raid6test: test_disks(58, 62): faila=3D 58(D)  failb=3D 62(P=
)  OK
[  581.491603] raid6test: test_disks(58, 63): faila=3D 58(D)  failb=3D 63(Q=
)  OK
[  581.670646] raid6test: test_disks(59, 60): faila=3D 59(D)  failb=3D 60(D=
)  OK
[  581.964914] raid6test: test_disks(59, 61): faila=3D 59(D)  failb=3D 61(D=
)  OK
[  582.294464] raid6test: test_disks(59, 62): faila=3D 59(D)  failb=3D 62(P=
)  OK
[  582.601247] raid6test: test_disks(59, 63): faila=3D 59(D)  failb=3D 63(Q=
)  OK
[  582.781363] raid6test: test_disks(60, 61): faila=3D 60(D)  failb=3D 61(D=
)  OK
[  582.965177] raid6test: test_disks(60, 62): faila=3D 60(D)  failb=3D 62(P=
)  OK
[  583.149408] raid6test: test_disks(60, 63): faila=3D 60(D)  failb=3D 63(Q=
)  OK
[  583.343773] raid6test: test_disks(61, 62): faila=3D 61(D)  failb=3D 62(P=
)  OK
[  583.537122] raid6test: test_disks(61, 63): faila=3D 61(D)  failb=3D 63(Q=
)  OK
[  583.725561] raid6test: test_disks(62, 63): faila=3D 62(P)  failb=3D 63(Q=
)  OK
[  583.912461] raid6test:=20
[  584.110739] raid6test: complete (2429 tests, 0 failures)
[  584.304933] BUG: spinlock trylock failure on UP on CPU#0, swapper/1
[  584.314418]  lock: lock.14477+0x0/0x40, .magic: dead4ead, .owner: swappe=
r/1, .owner_cpu: 0
[  584.314418] CPU: 0 PID: 1 Comm: swapper Not tainted 3.13.0-00009-g11e9ee=
9 #1
[  584.314418] Hardware name: Bochs Bochs, BIOS Bochs 01/01/2011
[  584.314418]  d0058000 d0058000 d0057d1c c181ac11 d0057d44 c1816b15 c1a51=
108 c1cc3080
[  584.314418]  dead4ead d00582b0 00000001 00000000 c1cc3080 c1a4c4e5 d0057=
d54 c1816b37
[  584.314418]  00000000 c1cc3080 d0057d60 c1061c4c c1cc3090 d0057d84 c1826=
9e2 00000000
[  584.314418] Call Trace:
[  584.314418]  [<c181ac11>] dump_stack+0x16/0x18
[  584.314418]  [<c1816b15>] spin_dump+0x90/0x97
[  584.314418]  [<c1816b37>] spin_bug+0x1b/0x1f
[  584.314418]  [<c1061c4c>] do_raw_spin_trylock+0x3c/0x50
[  584.314418]  [<c18269e2>] _raw_spin_lock_irqsave+0x52/0x80
[  584.314418]  [<c1261564>] ? __prandom_reseed+0x14/0xa0
[  584.314418]  [<c1261564>] __prandom_reseed+0x14/0xa0
[  584.314418]  [<c126166d>] prandom_reseed_late+0xd/0x10
[  584.314418]  [<c139918e>] credit_entropy_bits+0x20e/0x230
[  584.314418]  [<c13999ab>] _xfer_secondary_pool+0x7b/0x90

Elapsed time: 580
qemu-system-x86_64 -cpu kvm64 -enable-kvm -kernel /kernel/i386-randconfig-f=
b0-04031419/11e9ee988e8f951e4dbc765832fdf6f08c2c8b54/vmlinuz-3.13.0-00009-g=
11e9ee9 -append 'hung_task_panic=3D1 earlyprintk=3DttyS0,115200 debug apic=
=3Ddebug sysrq_always_enabled rcupdate.rcu_cpu_stall_timeout=3D100 panic=3D=
10 softlockup_panic=3D1 nmi_watchdog=3Dpanic  prompt_ramdisk=3D0 console=3D=
ttyS0,115200 console=3Dtty0 vga=3Dnormal  root=3D/dev/ram0 rw link=3D/kerne=
l-tests/run-queue/kvm/i386-randconfig-fb0-04031419/next:master:11e9ee988e8f=
951e4dbc765832fdf6f08c2c8b54:bisect-drm/.vmlinuz-11e9ee988e8f951e4dbc765832=
fdf6f08c2c8b54-20140405081535-145-loslunas branch=3Dnext/master BOOT_IMAGE=
=3D/kernel/i386-randconfig-fb0-04031419/11e9ee988e8f951e4dbc765832fdf6f08c2=
c8b54/vmlinuz-3.13.0-00009-g11e9ee9 drbd.minor_count=3D8'  -initrd /kernel-=
tests/initrd/quantal-core-i386.cgz -m 320 -smp 2 -net nic,vlan=3D1,model=3D=
e1000 -net user,vlan=3D1,hostfwd=3Dtcp::9668-:22 -boot order=3Dnc -no-reboo=
t -watchdog i6300esb -rtc base=3Dlocaltime -pidfile /dev/shm/kboot/pid-quan=
tal-loslunas-12 -serial file:/dev/shm/kboot/serial-quantal-loslunas-12 -dae=
monize -display none -monitor null=20

--ZPt4rx8FFjLCG7dd
Content-Type: application/octet-stream
Content-Disposition: attachment; filename="i386-randconfig-fb0-04031419-4b22efdd5595f0acb48f02bf664a451ee98f9a2e-BUG:-spinlock-trylock-failure-on-UP-on-CPU-62576.log"
Content-Transfer-Encoding: base64

Tm8gcGF0Y2ggcmVtb3ZlZApIRUFEIGlzIG5vdyBhdCA0YjIyZWZkLi4uIEFkZCBsaW51eC1u
ZXh0IHNwZWNpZmljIGZpbGVzIGZvciAyMDE0MDQwMwpnaXQgY2hlY2tvdXQgNzliMWQxZjU4
NjA1NDU5NzM0NjFkMGRjYjFmMGU4ZDljMzJkYmRiZQpscyAtYSAva2VybmVsLXRlc3RzL3J1
bi1xdWV1ZS9rdm0vaTM4Ni1yYW5kY29uZmlnLWZiMC0wNDAzMTQxOS9uZXh0Om1hc3Rlcjo3
OWIxZDFmNTg2MDU0NTk3MzQ2MWQwZGNiMWYwZThkOWMzMmRiZGJlOmJpc2VjdC1kcm0KCjIw
MTQtMDQtMDQtMTE6MzQ6MTUgNzliMWQxZjU4NjA1NDU5NzM0NjFkMGRjYjFmMGU4ZDljMzJk
YmRiZSBjb21waWxpbmcKUXVldWVkIGJ1aWxkIHRhc2sgdG8gL2tlcm5lbC10ZXN0cy9idWls
ZC1xdWV1ZS9pMzg2LXJhbmRjb25maWctZmIwLTA0MDMxNDE5LTc5YjFkMWY1ODYwNTQ1OTcz
NDYxZDBkY2IxZjBlOGQ5YzMyZGJkYmUKQ2hlY2sgZm9yIGtlcm5lbCBpbiAva2VybmVsL2kz
ODYtcmFuZGNvbmZpZy1mYjAtMDQwMzE0MTkvNzliMWQxZjU4NjA1NDU5NzM0NjFkMGRjYjFm
MGU4ZDljMzJkYmRiZQp3YWl0aW5nIGZvciBjb21wbGV0aW9uIG9mIC9rZXJuZWwtdGVzdHMv
YnVpbGQtcXVldWUvaTM4Ni1yYW5kY29uZmlnLWZiMC0wNDAzMTQxOS03OWIxZDFmNTg2MDU0
NTk3MzQ2MWQwZGNiMWYwZThkOWMzMmRiZGJlCndhaXRpbmcgZm9yIGNvbXBsZXRpb24gb2Yg
L2tlcm5lbC10ZXN0cy9idWlsZC1xdWV1ZS8uaTM4Ni1yYW5kY29uZmlnLWZiMC0wNDAzMTQx
OS03OWIxZDFmNTg2MDU0NTk3MzQ2MWQwZGNiMWYwZThkOWMzMmRiZGJlCmtlcm5lbDogL2tl
cm5lbC9pMzg2LXJhbmRjb25maWctZmIwLTA0MDMxNDE5Lzc5YjFkMWY1ODYwNTQ1OTczNDYx
ZDBkY2IxZjBlOGQ5YzMyZGJkYmUvdm1saW51ei0zLjE0LjAtMTIzMDAtZzc5YjFkMWYKCjIw
MTQtMDQtMDQtMTI6MzE6MTUgZGV0ZWN0aW5nIGJvb3Qgc3RhdGUgLi4uLi4uLi4uLi4uLi4u
Li4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4u
Li4uLi4uLi4uLi4uLi4JMS4uCTIuLi4uLgkzLgk1LiBURVNUIEZBSUxVUkUKWyAgIDU2LjM1
OTMwM10gaW8gc2NoZWR1bGVyIGNmcSByZWdpc3RlcmVkClsgICA1Ni4zNTk2NDFdIGxpc3Rf
c29ydF90ZXN0OiBzdGFydCB0ZXN0aW5nIGxpc3Rfc29ydCgpClsgICA1Ni4zNzgxMDFdIHJi
dHJlZSB0ZXN0aW5nClsgICA4MC45NjAxNDNdIEJVRzogc29mdCBsb2NrdXAgLSBDUFUjMCBz
dHVjayBmb3IgMjJzISBbc3dhcHBlcjoxXQpbICAgODAuOTYwMTQzXSBNb2R1bGVzIGxpbmtl
ZCBpbjoKWyAgIDgwLjk2MDE0M10gQ1BVOiAwIFBJRDogMSBDb21tOiBzd2FwcGVyIE5vdCB0
YWludGVkIDMuMTQuMC0xMjMwMC1nNzliMWQxZiAjMQpbICAgODAuOTYwMTQzXSBIYXJkd2Fy
ZSBuYW1lOiBCb2NocyBCb2NocywgQklPUyBCb2NocyAwMS8wMS8yMDExClsgICA4MC45NjAx
NDNdIHRhc2s6IGQwMDU4MDAwIHRpOiBkMDA1NDAwMCB0YXNrLnRpOiBkMDA1NDAwMApbICAg
ODAuOTYwMTQzXSBFSVA6IDAwNjA6WzxjMTI2NmMxMD5dIEVGTEFHUzogMDAwMDAyNDYgQ1BV
OiAwClsgICA4MC45NjAxNDNdIEVJUCBpcyBhdCByYl9pbnNlcnRfY29sb3IrMHgwLzB4MTMw
ClsgICA4MC45NjAxNDNdIEVBWDogYzIzNDVlZGMgRUJYOiBjMjM0NWQ0NCBFQ1g6IGMyMzQ1
ZDRjIEVEWDogYzIzNDY2YTAKWyAgIDgwLjk2MDE0M10gRVNJOiAyNjlmMjJkYSBFREk6IGMy
MzQ1ZWQ4IEVCUDogZDAwNTVlZDAgRVNQOiBkMDA1NWVjMApbICAgODAuOTYwMTQzXSAgRFM6
IDAwN2IgRVM6IDAwN2IgRlM6IDAwMDAgR1M6IDAwZTAgU1M6IDAwNjgKWyAgIDgwLjk2MDE0
M10gQ1IwOiA4MDA1MDAzYiBDUjI6IDAwMDAwMDAwIENSMzogMDFlMjkwMDAgQ1I0OiAwMDMw
MDY5MApbICAgODAuOTYwMTQzXSBEUjA6IDAwMDAwMDAwIERSMTogMDAwMDAwMDAgRFIyOiAw
MDAwMDAwMCBEUjM6IDAwMDAwMDAwClsgICA4MC45NjAxNDNdIERSNjogMDAwMDAwMDAgRFI3
OiAwMDAwMDAwMApbICAgODAuOTYwMTQzXSBTdGFjazoKWyAgIDgwLjk2MDE0M10gIGMxODRh
ZmNkIDAwMDAxMzhkIGMyMzQ1ZWYwIDAwMDAwMWMxIGQwMDU1ZWZjIGMxZGQwZDc0IGMxYWMy
YzcwIGQwMDU1ZWY0ClsgICA4MC45NjAxNDNdICBjMWRjNzRkMiAwMDAwMDAwOCBkZWJiZjQy
NyAwMDAwMDA0NiAwMDAwMDAwMCBjMWRkMGQxMiAwMDAwMDFjMSBkMDA1NWY3NApbICAgODAu
OTYwMTQzXSAgYzEwMDA0NmEgMDAwMDAwZTAgZmZmZmZmMTAgYzEyNmJkNTAgZDNmZjc2ODMg
ZDAwNTVmMzAgYzEwNDgzZDMgZDNmZjc2OTQKWyAgIDgwLjk2MDE0M10gQ2FsbCBUcmFjZToK
WyAgIDgwLjk2MDE0M10gIFs8YzE4NGFmY2Q+XSA/IGluc2VydC5jb25zdHByb3AuNysweDQ3
LzB4NGMKWyAgIDgwLjk2MDE0M10gIFs8YzFkZDBkNzQ+XSByYnRyZWVfdGVzdF9pbml0KzB4
NjIvMHgyMTkKWyAgIDgwLjk2MDE0M10gIFs8YzFkYzc0ZDI+XSA/IGF1ZGl0X3JlZ2lzdGVy
X2NsYXNzKzB4MWIvMHg3YgpbICAgODAuOTYwMTQzXSAgWzxjMWRkMGQxMj5dID8gZHluYW1p
Y19kZWJ1Z19pbml0KzB4MjM1LzB4MjM1ClsgICA4MC45NjAxNDNdICBbPGMxMDAwNDZhPl0g
ZG9fb25lX2luaXRjYWxsKzB4Y2EvMHgxOTAKWyAgIDgwLjk2MDE0M10gIFs8YzEyNmJkNTA+
XSA/IHN0cmNocisweDIwLzB4MjAKWyAgIDgwLjk2MDE0M10gIFs8YzEwNDgzZDM+XSA/IHBh
cmFtZXErMHgxMy8weDcwClsgICA4MC45NjAxNDNdICBbPGMxZGIzNTAwPl0gPyByZXBhaXJf
ZW52X3N0cmluZysweGUvMHg1MQpbICAgODAuOTYwMTQzXSAgWzxjMTA0ODY2OT5dID8gcGFy
c2VfYXJncysweDIzOS8weDQyMApbICAgODAuOTYwMTQzXSAgWzxjMWRiM2MxOD5dIGtlcm5l
bF9pbml0X2ZyZWVhYmxlKzB4MTgzLzB4MjFhClsgICA4MC45NjAxNDNdICBbPGMxZGIzNGYy
Pl0gPyBkb19lYXJseV9wYXJhbSsweDc4LzB4NzgKWyAgIDgwLjk2MDE0M10gIFs8YzE4NDMy
M2I+XSBrZXJuZWxfaW5pdCsweGIvMHhkMApbICAgODAuOTYwMTQzXSAgWzxjMTA1MmMxMj5d
ID8gc2NoZWR1bGVfdGFpbCsweDEyLzB4NDAKWyAgIDgwLjk2MDE0M10gIFs8YzE4NWMzNDA+
XSByZXRfZnJvbV9rZXJuZWxfdGhyZWFkKzB4MjAvMHgzMApbICAgODAuOTYwMTQzXSAgWzxj
MTg0MzIzMD5dID8gcmVzdF9pbml0KzB4YzAvMHhjMApbICAgODAuOTYwMTQzXSBDb2RlOiAw
MCAwMCAwMCA4OSBkMSA4YiA1MSAwNCA4NSBkMiA3NSBmNyA4OSBjOCA1ZCBjMyA4ZCA3NiAw
MCAzYiA0MSAwOCA3NSBmNCA4YiAxMSA4OSBjOCA4OSBkMSA4MyBlMSBmYyA3NSBmMCA4OSBj
OCBlYiBlNyAzMSBjMCA1ZCBjMyA8OGI+IDA4IDg1IGM5IDBmIDg0IDA2IDAxIDAwIDAwIDU1
IDg5IGU1IDU3IDU2IDUzIDhiIDE5IGY2IGMzIDAxCi9rZXJuZWwvaTM4Ni1yYW5kY29uZmln
LWZiMC0wNDAzMTQxOS83OWIxZDFmNTg2MDU0NTk3MzQ2MWQwZGNiMWYwZThkOWMzMmRiZGJl
L2RtZXNnLXlvY3RvLWxrcC1pYjA0LTczOjIwMTQwNDA0MTMxODUwOmkzODYtcmFuZGNvbmZp
Zy1mYjAtMDQwMzE0MTk6My4xNC4wLTEyMzAwLWc3OWIxZDFmOjEKMDoxOjYgYWxsX2dvb2Q6
YmFkOmFsbF9iYWQgYm9vdHMKG1sxOzM1bTIwMTQtMDQtMDQgMTM6MTk6MTggUkVQRUFUIENP
VU5UOiA3MCAgIyAvY2Mvd2ZnL2xpbnV4LWRybS8ucmVwZWF0G1swbQoKYmlzZWN0OiBiYWQg
Y29tbWl0IDc5YjFkMWY1ODYwNTQ1OTczNDYxZDBkY2IxZjBlOGQ5YzMyZGJkYmUKZ2l0IGNo
ZWNrb3V0IHYzLjE0CmxzIC1hIC9rZXJuZWwtdGVzdHMvcnVuLXF1ZXVlL2t2bS9pMzg2LXJh
bmRjb25maWctZmIwLTA0MDMxNDE5L25leHQ6bWFzdGVyOjQ1NWM2ZmRiZDIxOTE2MWJkMDli
MTE2NWYxMTY5OWQ2ZDczZGUxMWM6YmlzZWN0LWRybQoKMjAxNC0wNC0wNC0xMzoxOTozNiA0
NTVjNmZkYmQyMTkxNjFiZDA5YjExNjVmMTE2OTlkNmQ3M2RlMTFjIHJldXNlIC9rZXJuZWwv
aTM4Ni1yYW5kY29uZmlnLWZiMC0wNDAzMTQxOS80NTVjNmZkYmQyMTkxNjFiZDA5YjExNjVm
MTE2OTlkNmQ3M2RlMTFjL3ZtbGludXotMy4xNC4wCgoyMDE0LTA0LTA0LTEzOjE5OjM2IGRl
dGVjdGluZyBib290IHN0YXRlIC4uLi4uLi4uLi4uCTMzLgkzNQkzNi4uLi4uLi4JMzgJNDIu
CTQzLi4uCTQ2CTUyCTUzCTU2CTU5CTY2CTY3CTY4CTY5CTcwIFNVQ0NFU1MKCmJpc2VjdDog
Z29vZCBjb21taXQgdjMuMTQKZ2l0IGJpc2VjdCBzdGFydCA3OWIxZDFmNTg2MDU0NTk3MzQ2
MWQwZGNiMWYwZThkOWMzMmRiZGJlIHYzLjE0IC0tCi9jL2tlcm5lbC10ZXN0cy9saW5lYXIt
YmlzZWN0OiBbIi1iIiwgIjc5YjFkMWY1ODYwNTQ1OTczNDYxZDBkY2IxZjBlOGQ5YzMyZGJk
YmUiLCAiLWciLCAidjMuMTQiLCAiL2Mva2VybmVsLXRlc3RzL2Jpc2VjdC10ZXN0LWJvb3Qt
ZmFpbHVyZS5zaCIsICIvaG9tZS93ZmcvZHJtL29iai1iaXNlY3QiXQpCaXNlY3Rpbmc6IDEy
MzAwIHJldmlzaW9ucyBsZWZ0IHRvIHRlc3QgYWZ0ZXIgdGhpcyAocm91Z2hseSAxNCBzdGVw
cykKWzY2YTc5YzUwMzNkN2UzMWIyZTYzYzUyODAwMGJhMzgxZGY0ODBkNDVdIE1lcmdlIHJl
bW90ZS10cmFja2luZyBicmFuY2ggJ3JlbmVzYXMvbmV4dCcKcnVubmluZyAvYy9rZXJuZWwt
dGVzdHMvYmlzZWN0LXRlc3QtYm9vdC1mYWlsdXJlLnNoIC9ob21lL3dmZy9kcm0vb2JqLWJp
c2VjdApscyAtYSAva2VybmVsLXRlc3RzL3J1bi1xdWV1ZS9rdm0vaTM4Ni1yYW5kY29uZmln
LWZiMC0wNDAzMTQxOS9uZXh0Om1hc3Rlcjo2NmE3OWM1MDMzZDdlMzFiMmU2M2M1MjgwMDBi
YTM4MWRmNDgwZDQ1OmJpc2VjdC1kcm0KCjIwMTQtMDQtMDQtMTM6Mzk6MTggNjZhNzljNTAz
M2Q3ZTMxYjJlNjNjNTI4MDAwYmEzODFkZjQ4MGQ0NSBjb21waWxpbmcKUXVldWVkIGJ1aWxk
IHRhc2sgdG8gL2tlcm5lbC10ZXN0cy9idWlsZC1xdWV1ZS9pMzg2LXJhbmRjb25maWctZmIw
LTA0MDMxNDE5LTY2YTc5YzUwMzNkN2UzMWIyZTYzYzUyODAwMGJhMzgxZGY0ODBkNDUKQ2hl
Y2sgZm9yIGtlcm5lbCBpbiAva2VybmVsL2kzODYtcmFuZGNvbmZpZy1mYjAtMDQwMzE0MTkv
NjZhNzljNTAzM2Q3ZTMxYjJlNjNjNTI4MDAwYmEzODFkZjQ4MGQ0NQp3YWl0aW5nIGZvciBj
b21wbGV0aW9uIG9mIC9rZXJuZWwtdGVzdHMvYnVpbGQtcXVldWUvaTM4Ni1yYW5kY29uZmln
LWZiMC0wNDAzMTQxOS02NmE3OWM1MDMzZDdlMzFiMmU2M2M1MjgwMDBiYTM4MWRmNDgwZDQ1
CndhaXRpbmcgZm9yIGNvbXBsZXRpb24gb2YgL2tlcm5lbC10ZXN0cy9idWlsZC1xdWV1ZS8u
aTM4Ni1yYW5kY29uZmlnLWZiMC0wNDAzMTQxOS02NmE3OWM1MDMzZDdlMzFiMmU2M2M1Mjgw
MDBiYTM4MWRmNDgwZDQ1Cmtlcm5lbDogL2tlcm5lbC9pMzg2LXJhbmRjb25maWctZmIwLTA0
MDMxNDE5LzY2YTc5YzUwMzNkN2UzMWIyZTYzYzUyODAwMGJhMzgxZGY0ODBkNDUvdm1saW51
ei0zLjE0LjAtMDY2MjgtZzY2YTc5YzUKCjIwMTQtMDQtMDQtMTM6NTQ6MTkgZGV0ZWN0aW5n
IGJvb3Qgc3RhdGUgLi4uLi4uLi4uCTEJNQkxNwkyOAkzMQkzMwkzOQk1Nwk2NAk2OC4uLi4u
Li4uLi4uLgk3MCBTVUNDRVNTCgpCaXNlY3Rpbmc6IDU2NzIgcmV2aXNpb25zIGxlZnQgdG8g
dGVzdCBhZnRlciB0aGlzIChyb3VnaGx5IDEzIHN0ZXBzKQpbNDgwMDJkOTc5YTg2Zjk4MDc4
MjZjYWM3OWZiNGEwYzA3NzRhZjViYV0gTWVyZ2UgcmVtb3RlLXRyYWNraW5nIGJyYW5jaCAn
bDItbXRkL21hc3RlcicKcnVubmluZyAvYy9rZXJuZWwtdGVzdHMvYmlzZWN0LXRlc3QtYm9v
dC1mYWlsdXJlLnNoIC9ob21lL3dmZy9kcm0vb2JqLWJpc2VjdApscyAtYSAva2VybmVsLXRl
c3RzL3J1bi1xdWV1ZS9rdm0vaTM4Ni1yYW5kY29uZmlnLWZiMC0wNDAzMTQxOS9uZXh0Om1h
c3Rlcjo0ODAwMmQ5NzlhODZmOTgwNzgyNmNhYzc5ZmI0YTBjMDc3NGFmNWJhOmJpc2VjdC1k
cm0KCjIwMTQtMDQtMDQtMTQ6MTA6MjkgNDgwMDJkOTc5YTg2Zjk4MDc4MjZjYWM3OWZiNGEw
YzA3NzRhZjViYSBjb21waWxpbmcKUXVldWVkIGJ1aWxkIHRhc2sgdG8gL2tlcm5lbC10ZXN0
cy9idWlsZC1xdWV1ZS9pMzg2LXJhbmRjb25maWctZmIwLTA0MDMxNDE5LTQ4MDAyZDk3OWE4
NmY5ODA3ODI2Y2FjNzlmYjRhMGMwNzc0YWY1YmEKQ2hlY2sgZm9yIGtlcm5lbCBpbiAva2Vy
bmVsL2kzODYtcmFuZGNvbmZpZy1mYjAtMDQwMzE0MTkvNDgwMDJkOTc5YTg2Zjk4MDc4MjZj
YWM3OWZiNGEwYzA3NzRhZjViYQp3YWl0aW5nIGZvciBjb21wbGV0aW9uIG9mIC9rZXJuZWwt
dGVzdHMvYnVpbGQtcXVldWUvaTM4Ni1yYW5kY29uZmlnLWZiMC0wNDAzMTQxOS00ODAwMmQ5
NzlhODZmOTgwNzgyNmNhYzc5ZmI0YTBjMDc3NGFmNWJhCnRpbWVvdXQKUmV0cnkgYnVpbGQg
Li4Kd2FpdGluZyBmb3IgY29tcGxldGlvbiBvZiAva2VybmVsLXRlc3RzL2J1aWxkLXF1ZXVl
L2kzODYtcmFuZGNvbmZpZy1mYjAtMDQwMzE0MTktNDgwMDJkOTc5YTg2Zjk4MDc4MjZjYWM3
OWZiNGEwYzA3NzRhZjViYQp3YWl0aW5nIGZvciBjb21wbGV0aW9uIG9mIC9rZXJuZWwtdGVz
dHMvYnVpbGQtcXVldWUvLmkzODYtcmFuZGNvbmZpZy1mYjAtMDQwMzE0MTktNDgwMDJkOTc5
YTg2Zjk4MDc4MjZjYWM3OWZiNGEwYzA3NzRhZjViYQprZXJuZWw6IC9rZXJuZWwvaTM4Ni1y
YW5kY29uZmlnLWZiMC0wNDAzMTQxOS80ODAwMmQ5NzlhODZmOTgwNzgyNmNhYzc5ZmI0YTBj
MDc3NGFmNWJhL3ZtbGludXotMy4xNC4wLTEwMzg0LWc0ODAwMmQ5CgoyMDE0LTA0LTA0LTE4
OjM2OjMwIGRldGVjdGluZyBib290IHN0YXRlIC4uLi4uLi4uCTIJNAk3CTEyCTE0CTE1CTI3
CTMxCTM5CTQxCTQ1CTQ4CTU0CTU2CTU3CTU4Li4uLi4JNTkuLgk2Mgk2Mwk2NAk2Nwk2OAk3
MCBTVUNDRVNTCgpCaXNlY3Rpbmc6IDE5MTYgcmV2aXNpb25zIGxlZnQgdG8gdGVzdCBhZnRl
ciB0aGlzIChyb3VnaGx5IDExIHN0ZXBzKQpbZjFkYWNlYzEyNTk0YzMyN2NjMjVmZTJjMjc4
NWJhZThiMDg2ZWNjYl0gTWVyZ2UgcmVtb3RlLXRyYWNraW5nIGJyYW5jaCAndHJpdmlhbC9m
b3ItbmV4dCcKcnVubmluZyAvYy9rZXJuZWwtdGVzdHMvYmlzZWN0LXRlc3QtYm9vdC1mYWls
dXJlLnNoIC9ob21lL3dmZy9kcm0vb2JqLWJpc2VjdApscyAtYSAva2VybmVsLXRlc3RzL3J1
bi1xdWV1ZS9rdm0vaTM4Ni1yYW5kY29uZmlnLWZiMC0wNDAzMTQxOS9uZXh0Om1hc3Rlcjpm
MWRhY2VjMTI1OTRjMzI3Y2MyNWZlMmMyNzg1YmFlOGIwODZlY2NiOmJpc2VjdC1kcm0KCjIw
MTQtMDQtMDQtMTg6NTU6MzYgZjFkYWNlYzEyNTk0YzMyN2NjMjVmZTJjMjc4NWJhZThiMDg2
ZWNjYiBjb21waWxpbmcKUXVldWVkIGJ1aWxkIHRhc2sgdG8gL2tlcm5lbC10ZXN0cy9idWls
ZC1xdWV1ZS9pMzg2LXJhbmRjb25maWctZmIwLTA0MDMxNDE5LWYxZGFjZWMxMjU5NGMzMjdj
YzI1ZmUyYzI3ODViYWU4YjA4NmVjY2IKQ2hlY2sgZm9yIGtlcm5lbCBpbiAva2VybmVsL2kz
ODYtcmFuZGNvbmZpZy1mYjAtMDQwMzE0MTkvZjFkYWNlYzEyNTk0YzMyN2NjMjVmZTJjMjc4
NWJhZThiMDg2ZWNjYgp3YWl0aW5nIGZvciBjb21wbGV0aW9uIG9mIC9rZXJuZWwtdGVzdHMv
YnVpbGQtcXVldWUvaTM4Ni1yYW5kY29uZmlnLWZiMC0wNDAzMTQxOS1mMWRhY2VjMTI1OTRj
MzI3Y2MyNWZlMmMyNzg1YmFlOGIwODZlY2NiCndhaXRpbmcgZm9yIGNvbXBsZXRpb24gb2Yg
L2tlcm5lbC10ZXN0cy9idWlsZC1xdWV1ZS8uaTM4Ni1yYW5kY29uZmlnLWZiMC0wNDAzMTQx
OS1mMWRhY2VjMTI1OTRjMzI3Y2MyNWZlMmMyNzg1YmFlOGIwODZlY2NiCmtlcm5lbDogL2tl
cm5lbC9pMzg2LXJhbmRjb25maWctZmIwLTA0MDMxNDE5L2YxZGFjZWMxMjU5NGMzMjdjYzI1
ZmUyYzI3ODViYWU4YjA4NmVjY2Ivdm1saW51ei0zLjE0LjAtMTE4MDAtZ2YxZGFjZWMKCjIw
MTQtMDQtMDQtMjE6NDE6MzcgZGV0ZWN0aW5nIGJvb3Qgc3RhdGUgLi4uLi4uLgkxCTYJMTcJ
MjgJMzgJNDIJNTUJNjEuLi4uLi4uLi4uLi4uLi4JNjYJNzAgU1VDQ0VTUwoKQmlzZWN0aW5n
OiA1MDAgcmV2aXNpb25zIGxlZnQgdG8gdGVzdCBhZnRlciB0aGlzIChyb3VnaGx5IDkgc3Rl
cHMpCltiZDg3YjQ4YmI0YjZiYWQ4OGYxZTg4ZDk2YTFkYjdjMjgwZWExMzkzXSBNZXJnZSBy
ZW1vdGUtdHJhY2tpbmcgYnJhbmNoICdsZWRzL2Zvci1uZXh0JwpydW5uaW5nIC9jL2tlcm5l
bC10ZXN0cy9iaXNlY3QtdGVzdC1ib290LWZhaWx1cmUuc2ggL2hvbWUvd2ZnL2RybS9vYmot
YmlzZWN0CmxzIC1hIC9rZXJuZWwtdGVzdHMvcnVuLXF1ZXVlL2t2bS9pMzg2LXJhbmRjb25m
aWctZmIwLTA0MDMxNDE5L25leHQ6bWFzdGVyOmJkODdiNDhiYjRiNmJhZDg4ZjFlODhkOTZh
MWRiN2MyODBlYTEzOTM6YmlzZWN0LWRybQoKMjAxNC0wNC0wNC0yMTo1Nzo0OCBiZDg3YjQ4
YmI0YjZiYWQ4OGYxZTg4ZDk2YTFkYjdjMjgwZWExMzkzIGNvbXBpbGluZwpRdWV1ZWQgYnVp
bGQgdGFzayB0byAva2VybmVsLXRlc3RzL2J1aWxkLXF1ZXVlL2kzODYtcmFuZGNvbmZpZy1m
YjAtMDQwMzE0MTktYmQ4N2I0OGJiNGI2YmFkODhmMWU4OGQ5NmExZGI3YzI4MGVhMTM5MwpD
aGVjayBmb3Iga2VybmVsIGluIC9rZXJuZWwvaTM4Ni1yYW5kY29uZmlnLWZiMC0wNDAzMTQx
OS9iZDg3YjQ4YmI0YjZiYWQ4OGYxZTg4ZDk2YTFkYjdjMjgwZWExMzkzCndhaXRpbmcgZm9y
IGNvbXBsZXRpb24gb2YgL2tlcm5lbC10ZXN0cy9idWlsZC1xdWV1ZS9pMzg2LXJhbmRjb25m
aWctZmIwLTA0MDMxNDE5LWJkODdiNDhiYjRiNmJhZDg4ZjFlODhkOTZhMWRiN2MyODBlYTEz
OTMKd2FpdGluZyBmb3IgY29tcGxldGlvbiBvZiAva2VybmVsLXRlc3RzL2J1aWxkLXF1ZXVl
Ly5pMzg2LXJhbmRjb25maWctZmIwLTA0MDMxNDE5LWJkODdiNDhiYjRiNmJhZDg4ZjFlODhk
OTZhMWRiN2MyODBlYTEzOTMKa2VybmVsOiAva2VybmVsL2kzODYtcmFuZGNvbmZpZy1mYjAt
MDQwMzE0MTkvYmQ4N2I0OGJiNGI2YmFkODhmMWU4OGQ5NmExZGI3YzI4MGVhMTM5My92bWxp
bnV6LTMuMTQuMC0xMTk2OC1nYmQ4N2I0OAoKMjAxNC0wNC0wNC0yMzoyMTo0OCBkZXRlY3Rp
bmcgYm9vdCBzdGF0ZSAuLi4uLi4uCTQJMTYJMjcJMzkJNDAJNDkJNTUJNTgJNjIuLi4uLi4u
Li4uLi4uLi4JNjQJNjgJNzAgU1VDQ0VTUwoKQmlzZWN0aW5nOiAzMzIgcmV2aXNpb25zIGxl
ZnQgdG8gdGVzdCBhZnRlciB0aGlzIChyb3VnaGx5IDkgc3RlcHMpClswNzgzYzFmZDFlYjA1
MzEyZmY5NDhkMmYwNGIzMjM2NjYxMzAwNjY0XSBNZXJnZSByZW1vdGUtdHJhY2tpbmcgYnJh
bmNoICdwd20vZm9yLW5leHQnCnJ1bm5pbmcgL2Mva2VybmVsLXRlc3RzL2Jpc2VjdC10ZXN0
LWJvb3QtZmFpbHVyZS5zaCAvaG9tZS93ZmcvZHJtL29iai1iaXNlY3QKbHMgLWEgL2tlcm5l
bC10ZXN0cy9ydW4tcXVldWUva3ZtL2kzODYtcmFuZGNvbmZpZy1mYjAtMDQwMzE0MTkvbmV4
dDptYXN0ZXI6MDc4M2MxZmQxZWIwNTMxMmZmOTQ4ZDJmMDRiMzIzNjY2MTMwMDY2NDpiaXNl
Y3QtZHJtCgoyMDE0LTA0LTA0LTIzOjM4OjUyIDA3ODNjMWZkMWViMDUzMTJmZjk0OGQyZjA0
YjMyMzY2NjEzMDA2NjQgY29tcGlsaW5nClF1ZXVlZCBidWlsZCB0YXNrIHRvIC9rZXJuZWwt
dGVzdHMvYnVpbGQtcXVldWUvaTM4Ni1yYW5kY29uZmlnLWZiMC0wNDAzMTQxOS0wNzgzYzFm
ZDFlYjA1MzEyZmY5NDhkMmYwNGIzMjM2NjYxMzAwNjY0CkNoZWNrIGZvciBrZXJuZWwgaW4g
L2tlcm5lbC9pMzg2LXJhbmRjb25maWctZmIwLTA0MDMxNDE5LzA3ODNjMWZkMWViMDUzMTJm
Zjk0OGQyZjA0YjMyMzY2NjEzMDA2NjQKd2FpdGluZyBmb3IgY29tcGxldGlvbiBvZiAva2Vy
bmVsLXRlc3RzL2J1aWxkLXF1ZXVlL2kzODYtcmFuZGNvbmZpZy1mYjAtMDQwMzE0MTktMDc4
M2MxZmQxZWIwNTMxMmZmOTQ4ZDJmMDRiMzIzNjY2MTMwMDY2NAp3YWl0aW5nIGZvciBjb21w
bGV0aW9uIG9mIC9rZXJuZWwtdGVzdHMvYnVpbGQtcXVldWUvLmkzODYtcmFuZGNvbmZpZy1m
YjAtMDQwMzE0MTktMDc4M2MxZmQxZWIwNTMxMmZmOTQ4ZDJmMDRiMzIzNjY2MTMwMDY2NApr
ZXJuZWw6IC9rZXJuZWwvaTM4Ni1yYW5kY29uZmlnLWZiMC0wNDAzMTQxOS8wNzgzYzFmZDFl
YjA1MzEyZmY5NDhkMmYwNGIzMjM2NjYxMzAwNjY0L3ZtbGludXotMy4xNC4wLTEyMTk1LWcw
NzgzYzFmCgoyMDE0LTA0LTA1LTAwOjI3OjUyIGRldGVjdGluZyBib290IHN0YXRlIC4uLi4u
Li4JNQkyMAkyOAkzMC4JMzMJMzYJNDUJNTIuCTU0CTU1Li4uLi4uLi4uLi4JNTgJNjgJNzAg
U1VDQ0VTUwoKQmlzZWN0aW5nOiAxMDUgcmV2aXNpb25zIGxlZnQgdG8gdGVzdCBhZnRlciB0
aGlzIChyb3VnaGx5IDcgc3RlcHMpCls1Nzg0NzcwNzVlODkzMmJiN2ZlMTE3ZTZhZDQ3MGMz
YzNjYjU4MGM3XSBNZXJnZSByZW1vdGUtdHJhY2tpbmcgYnJhbmNoICdyYW5kb20vZGV2Jwpy
dW5uaW5nIC9jL2tlcm5lbC10ZXN0cy9iaXNlY3QtdGVzdC1ib290LWZhaWx1cmUuc2ggL2hv
bWUvd2ZnL2RybS9vYmotYmlzZWN0CmxzIC1hIC9rZXJuZWwtdGVzdHMvcnVuLXF1ZXVlL2t2
bS9pMzg2LXJhbmRjb25maWctZmIwLTA0MDMxNDE5L25leHQ6bWFzdGVyOjU3ODQ3NzA3NWU4
OTMyYmI3ZmUxMTdlNmFkNDcwYzNjM2NiNTgwYzc6YmlzZWN0LWRybQoKMjAxNC0wNC0wNS0w
MDo0NDoyNyA1Nzg0NzcwNzVlODkzMmJiN2ZlMTE3ZTZhZDQ3MGMzYzNjYjU4MGM3IGNvbXBp
bGluZwpRdWV1ZWQgYnVpbGQgdGFzayB0byAva2VybmVsLXRlc3RzL2J1aWxkLXF1ZXVlL2kz
ODYtcmFuZGNvbmZpZy1mYjAtMDQwMzE0MTktNTc4NDc3MDc1ZTg5MzJiYjdmZTExN2U2YWQ0
NzBjM2MzY2I1ODBjNwpDaGVjayBmb3Iga2VybmVsIGluIC9rZXJuZWwvaTM4Ni1yYW5kY29u
ZmlnLWZiMC0wNDAzMTQxOS81Nzg0NzcwNzVlODkzMmJiN2ZlMTE3ZTZhZDQ3MGMzYzNjYjU4
MGM3CndhaXRpbmcgZm9yIGNvbXBsZXRpb24gb2YgL2tlcm5lbC10ZXN0cy9idWlsZC1xdWV1
ZS9pMzg2LXJhbmRjb25maWctZmIwLTA0MDMxNDE5LTU3ODQ3NzA3NWU4OTMyYmI3ZmUxMTdl
NmFkNDcwYzNjM2NiNTgwYzcKG1sxOzM1bTIwMTQtMDQtMDUgMDA6NDc6MjcgTm8gYnVpbGQg
c2VydmVkIGZpbGUgL2tlcm5lbC10ZXN0cy9idWlsZC1zZXJ2ZWQvaTM4Ni1yYW5kY29uZmln
LWZiMC0wNDAzMTQxOS01Nzg0NzcwNzVlODkzMmJiN2ZlMTE3ZTZhZDQ3MGMzYzNjYjU4MGM3
G1swbQpSZXRyeSBidWlsZCAuLgpRdWV1ZWQgYnVpbGQgdGFzayB0byAva2VybmVsLXRlc3Rz
L2J1aWxkLXF1ZXVlL2kzODYtcmFuZGNvbmZpZy1mYjAtMDQwMzE0MTktNTc4NDc3MDc1ZTg5
MzJiYjdmZTExN2U2YWQ0NzBjM2MzY2I1ODBjNwpDaGVjayBmb3Iga2VybmVsIGluIC9rZXJu
ZWwvaTM4Ni1yYW5kY29uZmlnLWZiMC0wNDAzMTQxOS81Nzg0NzcwNzVlODkzMmJiN2ZlMTE3
ZTZhZDQ3MGMzYzNjYjU4MGM3CndhaXRpbmcgZm9yIGNvbXBsZXRpb24gb2YgL2tlcm5lbC10
ZXN0cy9idWlsZC1xdWV1ZS9pMzg2LXJhbmRjb25maWctZmIwLTA0MDMxNDE5LTU3ODQ3NzA3
NWU4OTMyYmI3ZmUxMTdlNmFkNDcwYzNjM2NiNTgwYzcKd2FpdGluZyBmb3IgY29tcGxldGlv
biBvZiAva2VybmVsLXRlc3RzL2J1aWxkLXF1ZXVlLy5pMzg2LXJhbmRjb25maWctZmIwLTA0
MDMxNDE5LTU3ODQ3NzA3NWU4OTMyYmI3ZmUxMTdlNmFkNDcwYzNjM2NiNTgwYzcKa2VybmVs
OiAva2VybmVsL2kzODYtcmFuZGNvbmZpZy1mYjAtMDQwMzE0MTkvNTc4NDc3MDc1ZTg5MzJi
YjdmZTExN2U2YWQ0NzBjM2MzY2I1ODBjNy92bWxpbnV6LTMuMTQuMC0xMjI4Ni1nNTc4NDc3
MAoKMjAxNC0wNC0wNS0wMToxNzoyNyBkZXRlY3RpbmcgYm9vdCBzdGF0ZSAuLi4uLi4uCTQg
VEVTVCBGQUlMVVJFClsgIDIyMi44NTg0NzNdIHJhaWQ2dGVzdDogdGVzdF9kaXNrcyg2Miwg
NjMpOiBmYWlsYT0gNjIoUCkgIGZhaWxiPSA2MyhRKSAgT0sKWyAgMjIyLjkyNjk0NV0gcmFp
ZDZ0ZXN0OiAKWyAgMjIyLjk5ODU3N10gcmFpZDZ0ZXN0OiBjb21wbGV0ZSAoMjQyOSB0ZXN0
cywgMCBmYWlsdXJlcykKWyAgMjIzLjA3NTUyN10gQlVHOiBzcGlubG9jayB0cnlsb2NrIGZh
aWx1cmUgb24gVVAgb24gQ1BVIzAsIHN3YXBwZXIvMQpbICAyMjMuMDg0MzU2XSAgbG9jazog
bG9jay4xMzI0MSsweDAvMHg0MCwgLm1hZ2ljOiBkZWFkNGVhZCwgLm93bmVyOiBzd2FwcGVy
LzEsIC5vd25lcl9jcHU6IDAKWyAgMjIzLjA4NDM1Nl0gQ1BVOiAwIFBJRDogMSBDb21tOiBz
d2FwcGVyIE5vdCB0YWludGVkIDMuMTQuMC0xMjI4Ni1nNTc4NDc3MCAjMQpbICAyMjMuMDg0
MzU2XSBIYXJkd2FyZSBuYW1lOiBCb2NocyBCb2NocywgQklPUyBCb2NocyAwMS8wMS8yMDEx
ClsgIDIyMy4wODQzNTZdICBkMDA1ODAwMCBkMDA1ODAwMCBkMDA1NWQyNCBjMTg0YTYyZSBk
MDA1NWQ0YyBjMTg0NmFhMiBjMWFhNDI0YyBjMWQxZTJjMApbICAyMjMuMDg0MzU2XSAgZGVh
ZDRlYWQgZDAwNTgzNDggMDAwMDAwMDEgMDAwMDAwMDAgYzFkMWUyYzAgYzFhOWY0MWYgZDAw
NTVkNWMgYzE4NDZhYzQKWyAgMjIzLjA4NDM1Nl0gIDAwMDAwMDAwIDAwMDAwMDAxIGQwMDU1
ZDY4IGMxMDY1ODJjIGMxZDFlMmMwIGQwMDU1ZDg0IGMxODU2M2I0IDAwMDAwMDQ2ClsgIDIy
My4wODQzNTZdIENhbGwgVHJhY2U6ClsgIDIyMy4wODQzNTZdICBbPGMxODRhNjJlPl0gZHVt
cF9zdGFjaysweDE2LzB4MTgKWyAgMjIzLjA4NDM1Nl0gIFs8YzE4NDZhYTI+XSBzcGluX2R1
bXArMHg5MC8weDk3ClsgIDIyMy4wODQzNTZdICBbPGMxODQ2YWM0Pl0gc3Bpbl9idWcrMHgx
Yi8weDFmClsgIDIyMy4wODQzNTZdICBbPGMxMDY1ODJjPl0gZG9fcmF3X3NwaW5fdHJ5bG9j
aysweDNjLzB4NTAKWyAgMjIzLjA4NDM1Nl0gIFs8YzE4NTYzYjQ+XSBfcmF3X3NwaW5fdHJ5
bG9jaysweDE0LzB4NjAKWyAgMjIzLjA4NDM1Nl0gIFs8YzEyNmQ1NjI+XSBfX3ByYW5kb21f
cmVzZWVkKzB4MjIvMHhkMApbICAyMjMuMDg0MzU2XSAgWzxjMTI2ZDY4ZD5dIHByYW5kb21f
cmVzZWVkX2xhdGUrMHhkLzB4MTAKWyAgMjIzLjA4NDM1Nl0gIFs8YzEzYTgwYWU+XSBjcmVk
aXRfZW50cm9weV9iaXRzKzB4MjBlLzB4MjMwClsgIDIyMy4wODQzNTZdICBbPGMxM2E4YTVi
Pl0gX3hmZXJfc2Vjb25kYXJ5X3Bvb2wrMHg3Yi8weDkwClsgIDIyMy4wODQzNTZdICBbPGMx
MDAzM2U5Pl0gPyBkdW1wX3RyYWNlKzB4OTkvMHgxYTAKWyAgMjIzLjA4NDM1Nl0gIFs8YzEw
NjFlYTQ+XSA/IF9fbG9ja19hY3F1aXJlLmlzcmEuMzErMHgzNzQvMHg5ZjAKWyAgMjIzLjA4
NDM1Nl0gIFs8YzE4NTY2Y2Q+XSA/IF9yYXdfc3Bpbl91bmxvY2srMHgxZC8weDMwClsgIDIy
My4wODQzNTZdICBbPGMxM2E4YWY1Pl0geGZlcl9zZWNvbmRhcnlfcG9vbCsweDU1LzB4NjAK
WyAgMjIzLjA4NDM1Nl0gIFs8YzEzYTg5NTU+XSBleHRyYWN0X2VudHJvcHkrMHgyNS8weGIw
ClsgIDIyMy4wODQzNTZdICBbPGMxM2E4YjIzPl0gZ2V0X3JhbmRvbV9ieXRlcysweDIzLzB4
MzAKWyAgMjIzLjA4NDM1Nl0gIFs8YzEyNmQ1OTU+XSBfX3ByYW5kb21fcmVzZWVkKzB4NTUv
MHhkMApbICAyMjMuMDg0MzU2XSAgWzxjMTI0Nzk2Nz5dID8gcmFpZDZfdGVzdCsweDEwNy8w
eDEyMApbICAyMjMuMDg0MzU2XSAgWzxjMWRjZmQyND5dID8gcHJhbmRvbV9pbml0KzB4MTNh
LzB4MTNhClsgIDIyMy4wODQzNTZdICBbPGMxZGNmZDJlPl0gcHJhbmRvbV9yZXNlZWQrMHhh
LzB4M2UKWyAgMjIzLjA4NDM1Nl0gIFs8YzEwMDA0NmE+XSBkb19vbmVfaW5pdGNhbGwrMHhj
YS8weDE5MApbICAyMjMuMDg0MzU2XSAgWzxjMTA0ODNkMz5dID8gcGFyYW1lcSsweDEzLzB4
NzAKWyAgMjIzLjA4NDM1Nl0gIFs8YzFkYjM1MDA+XSA/IHJlcGFpcl9lbnZfc3RyaW5nKzB4
ZS8weDUxClsgIDIyMy4wODQzNTZdICBbPGMxMDQ4NjY5Pl0gPyBwYXJzZV9hcmdzKzB4MjM5
LzB4NDIwClsgIDIyMy4wODQzNTZdICBbPGMxZGIzYzE4Pl0ga2VybmVsX2luaXRfZnJlZWFi
bGUrMHgxODMvMHgyMWEKWyAgMjIzLjA4NDM1Nl0gIFs8YzFkYjM0ZjI+XSA/IGRvX2Vhcmx5
X3BhcmFtKzB4NzgvMHg3OApbICAyMjMuMDg0MzU2XSAgWzxjMTg0MzI5Yj5dIGtlcm5lbF9p
bml0KzB4Yi8weGQwClsgIDIyMy4wODQzNTZdICBbPGMxMDUyYzEyPl0gPyBzY2hlZHVsZV90
YWlsKzB4MTIvMHg0MApbICAyMjMuMDg0MzU2XSAgWzxjMTg1YzM4MD5dIHJldF9mcm9tX2tl
cm5lbF90aHJlYWQrMHgyMC8weDMwClsgIDIyMy4wODQzNTZdICBbPGMxODQzMjkwPl0gPyBy
ZXN0X2luaXQrMHhjMC8weGMwClsgIDIyMy4wODQzNTZdIHJhbmRvbTogbm9uYmxvY2tpbmcg
cG9vbCBpcyBpbml0aWFsaXplZAoKRWxhcHNlZCB0aW1lOiAyMzUKL2tlcm5lbC9pMzg2LXJh
bmRjb25maWctZmIwLTA0MDMxNDE5LzU3ODQ3NzA3NWU4OTMyYmI3ZmUxMTdlNmFkNDcwYzNj
M2NiNTgwYzcvZG1lc2ctcXVhbnRhbC1mMi05MDoyMDE0MDQwNTAxMjA1NDppMzg2LXJhbmRj
b25maWctZmIwLTA0MDMxNDE5OjMuMTQuMC0xMjI4Ni1nNTc4NDc3MDoxCi9rZXJuZWwvaTM4
Ni1yYW5kY29uZmlnLWZiMC0wNDAzMTQxOS81Nzg0NzcwNzVlODkzMmJiN2ZlMTE3ZTZhZDQ3
MGMzYzNjYjU4MGM3L2RtZXNnLXF1YW50YWwtZjQtMTEzOjIwMTQwNDA1MDEyMTE5OmkzODYt
cmFuZGNvbmZpZy1mYjAtMDQwMzE0MTk6My4xNC4wLTEyMjg2LWc1Nzg0NzcwOjEKL2tlcm5l
bC9pMzg2LXJhbmRjb25maWctZmIwLTA0MDMxNDE5LzU3ODQ3NzA3NWU4OTMyYmI3ZmUxMTdl
NmFkNDcwYzNjM2NiNTgwYzcvZG1lc2ctcXVhbnRhbC1mNC02MDoyMDE0MDQwNTAxMjExODpp
Mzg2LXJhbmRjb25maWctZmIwLTA0MDMxNDE5OjMuMTQuMC0xMjI4Ni1nNTc4NDc3MDoxCi9r
ZXJuZWwvaTM4Ni1yYW5kY29uZmlnLWZiMC0wNDAzMTQxOS81Nzg0NzcwNzVlODkzMmJiN2Zl
MTE3ZTZhZDQ3MGMzYzNjYjU4MGM3L2RtZXNnLXF1YW50YWwtZjQtODoyMDE0MDQwNTAxMjEx
NjppMzg2LXJhbmRjb25maWctZmIwLTA0MDMxNDE5OjMuMTQuMC0xMjI4Ni1nNTc4NDc3MDox
CjM6NDo1IGFsbF9nb29kOmJhZDphbGxfYmFkIGJvb3RzCgpCaXNlY3Rpbmc6IDkxIHJldmlz
aW9ucyBsZWZ0IHRvIHRlc3QgYWZ0ZXIgdGhpcyAocm91Z2hseSA3IHN0ZXBzKQpbMWY1ZGIw
Y2I5NzU5NjdhOGI5MDQwNTBkN2VlYWMzZTA1YmM4OWZiM10gTWVyZ2UgcmVtb3RlLXRyYWNr
aW5nIGJyYW5jaCAna3Rlc3QvZm9yLW5leHQnCnJ1bm5pbmcgL2Mva2VybmVsLXRlc3RzL2Jp
c2VjdC10ZXN0LWJvb3QtZmFpbHVyZS5zaCAvaG9tZS93ZmcvZHJtL29iai1iaXNlY3QKbHMg
LWEgL2tlcm5lbC10ZXN0cy9ydW4tcXVldWUva3ZtL2kzODYtcmFuZGNvbmZpZy1mYjAtMDQw
MzE0MTkvbmV4dDptYXN0ZXI6MWY1ZGIwY2I5NzU5NjdhOGI5MDQwNTBkN2VlYWMzZTA1YmM4
OWZiMzpiaXNlY3QtZHJtCgoyMDE0LTA0LTA1LTAxOjIxOjMwIDFmNWRiMGNiOTc1OTY3YThi
OTA0MDUwZDdlZWFjM2UwNWJjODlmYjMgY29tcGlsaW5nClF1ZXVlZCBidWlsZCB0YXNrIHRv
IC9rZXJuZWwtdGVzdHMvYnVpbGQtcXVldWUvaTM4Ni1yYW5kY29uZmlnLWZiMC0wNDAzMTQx
OS0xZjVkYjBjYjk3NTk2N2E4YjkwNDA1MGQ3ZWVhYzNlMDViYzg5ZmIzCkNoZWNrIGZvciBr
ZXJuZWwgaW4gL2tlcm5lbC9pMzg2LXJhbmRjb25maWctZmIwLTA0MDMxNDE5LzFmNWRiMGNi
OTc1OTY3YThiOTA0MDUwZDdlZWFjM2UwNWJjODlmYjMKd2FpdGluZyBmb3IgY29tcGxldGlv
biBvZiAva2VybmVsLXRlc3RzL2J1aWxkLXF1ZXVlL2kzODYtcmFuZGNvbmZpZy1mYjAtMDQw
MzE0MTktMWY1ZGIwY2I5NzU5NjdhOGI5MDQwNTBkN2VlYWMzZTA1YmM4OWZiMwp3YWl0aW5n
IGZvciBjb21wbGV0aW9uIG9mIC9rZXJuZWwtdGVzdHMvYnVpbGQtcXVldWUvLmkzODYtcmFu
ZGNvbmZpZy1mYjAtMDQwMzE0MTktMWY1ZGIwY2I5NzU5NjdhOGI5MDQwNTBkN2VlYWMzZTA1
YmM4OWZiMwprZXJuZWw6IC9rZXJuZWwvaTM4Ni1yYW5kY29uZmlnLWZiMC0wNDAzMTQxOS8x
ZjVkYjBjYjk3NTk2N2E4YjkwNDA1MGQ3ZWVhYzNlMDViYzg5ZmIzL3ZtbGludXotMy4xNC4w
LTEyMTk3LWcxZjVkYjBjCgoyMDE0LTA0LTA1LTAzOjQ2OjMwIGRldGVjdGluZyBib290IHN0
YXRlIC4uLi4uLi4uLgkxNwkyOAkzNQk0OQk1NQk2MS4JNjIJNjMuLi4JNjQuLi4uLi4JNjUu
CTY4Li4uLgk2OS4JNzAgU1VDQ0VTUwoKQmlzZWN0aW5nOiA4OSByZXZpc2lvbnMgbGVmdCB0
byB0ZXN0IGFmdGVyIHRoaXMgKHJvdWdobHkgNyBzdGVwcykKW2RkNjEyMGNlOGQzYjM2MDZm
NDBmMDBmM2JlNmYwYjJjMDRhOGE2YTldIE1lcmdlIHJlbW90ZS10cmFja2luZyBicmFuY2gg
J2Nsay9jbGstbmV4dCcKcnVubmluZyAvYy9rZXJuZWwtdGVzdHMvYmlzZWN0LXRlc3QtYm9v
dC1mYWlsdXJlLnNoIC9ob21lL3dmZy9kcm0vb2JqLWJpc2VjdApscyAtYSAva2VybmVsLXRl
c3RzL3J1bi1xdWV1ZS9rdm0vaTM4Ni1yYW5kY29uZmlnLWZiMC0wNDAzMTQxOS9uZXh0Om1h
c3RlcjpkZDYxMjBjZThkM2IzNjA2ZjQwZjAwZjNiZTZmMGIyYzA0YThhNmE5OmJpc2VjdC1k
cm0KCjIwMTQtMDQtMDUtMDQ6MDU6MzQgZGQ2MTIwY2U4ZDNiMzYwNmY0MGYwMGYzYmU2ZjBi
MmMwNGE4YTZhOSBjb21waWxpbmcKUXVldWVkIGJ1aWxkIHRhc2sgdG8gL2tlcm5lbC10ZXN0
cy9idWlsZC1xdWV1ZS9pMzg2LXJhbmRjb25maWctZmIwLTA0MDMxNDE5LWRkNjEyMGNlOGQz
YjM2MDZmNDBmMDBmM2JlNmYwYjJjMDRhOGE2YTkKQ2hlY2sgZm9yIGtlcm5lbCBpbiAva2Vy
bmVsL2kzODYtcmFuZGNvbmZpZy1mYjAtMDQwMzE0MTkvZGQ2MTIwY2U4ZDNiMzYwNmY0MGYw
MGYzYmU2ZjBiMmMwNGE4YTZhOQp3YWl0aW5nIGZvciBjb21wbGV0aW9uIG9mIC9rZXJuZWwt
dGVzdHMvYnVpbGQtcXVldWUvaTM4Ni1yYW5kY29uZmlnLWZiMC0wNDAzMTQxOS1kZDYxMjBj
ZThkM2IzNjA2ZjQwZjAwZjNiZTZmMGIyYzA0YThhNmE5CndhaXRpbmcgZm9yIGNvbXBsZXRp
b24gb2YgL2tlcm5lbC10ZXN0cy9idWlsZC1xdWV1ZS8uaTM4Ni1yYW5kY29uZmlnLWZiMC0w
NDAzMTQxOS1kZDYxMjBjZThkM2IzNjA2ZjQwZjAwZjNiZTZmMGIyYzA0YThhNmE5Cmtlcm5l
bDogL2tlcm5lbC9pMzg2LXJhbmRjb25maWctZmIwLTA0MDMxNDE5L2RkNjEyMGNlOGQzYjM2
MDZmNDBmMDBmM2JlNmYwYjJjMDRhOGE2YTkvdm1saW51ei0zLjE0LjAtMTIyNjktZ2RkNjEy
MGMKCjIwMTQtMDQtMDUtMDU6MDE6MzQgZGV0ZWN0aW5nIGJvb3Qgc3RhdGUgLi4uLi4uLi4u
LgkzLi4JOC4uCTE3Li4JMjQJMzguLgk0My4uLgk0Ni4uCTUzLi4JNjUuLgk3MCBTVUNDRVNT
CgpsaW5lYXItYmlzZWN0OiBiYWQgYnJhbmNoIG1heSBiZSByZW1vdGUtdHJhY2tpbmcgYnJh
bmNoICdyYW5kb20vZGV2JwpsaW5lYXItYmlzZWN0OiBoYW5kbGUgb3ZlciB0byBnaXQgYmlz
ZWN0CmxpbmVhci1iaXNlY3Q6IGdpdCBiaXNlY3Qgc3RhcnQgNTc4NDc3MDc1ZTg5MzJiYjdm
ZTExN2U2YWQ0NzBjM2MzY2I1ODBjNyBkZDYxMjBjZThkM2IzNjA2ZjQwZjAwZjNiZTZmMGIy
YzA0YThhNmE5IC0tClByZXZpb3VzIEhFQUQgcG9zaXRpb24gd2FzIGRkNjEyMGMuLi4gTWVy
Z2UgcmVtb3RlLXRyYWNraW5nIGJyYW5jaCAnY2xrL2Nsay1uZXh0JwpIRUFEIGlzIG5vdyBh
dCA2ZTQ2NjQ1Li4uIExpbnV4IDMuMTEKQmlzZWN0aW5nOiA4IHJldmlzaW9ucyBsZWZ0IHRv
IHRlc3QgYWZ0ZXIgdGhpcyAocm91Z2hseSAzIHN0ZXBzKQpbYmRkODAwMTFkYWEyMGY4Mjgw
MjNmNTExYzk3MWE3YmEwNjdlNmQxYl0gcmFuZG9tOiB0aWdodGVuIGJvdW5kIG9uIHJhbmRv
bV9yZWFkX3dha2V1cF90aHJlc2gKbGluZWFyLWJpc2VjdDogZ2l0IGJpc2VjdCBydW4gL2Mv
a2VybmVsLXRlc3RzL2Jpc2VjdC10ZXN0LWJvb3QtZmFpbHVyZS5zaCAvaG9tZS93ZmcvZHJt
L29iai1iaXNlY3QKcnVubmluZyAvYy9rZXJuZWwtdGVzdHMvYmlzZWN0LXRlc3QtYm9vdC1m
YWlsdXJlLnNoIC9ob21lL3dmZy9kcm0vb2JqLWJpc2VjdApscyAtYSAva2VybmVsLXRlc3Rz
L3J1bi1xdWV1ZS9rdm0vaTM4Ni1yYW5kY29uZmlnLWZiMC0wNDAzMTQxOS9uZXh0Om1hc3Rl
cjpiZGQ4MDAxMWRhYTIwZjgyODAyM2Y1MTFjOTcxYTdiYTA2N2U2ZDFiOmJpc2VjdC1kcm0K
CjIwMTQtMDQtMDUtMDU6MjA6NTAgYmRkODAwMTFkYWEyMGY4MjgwMjNmNTExYzk3MWE3YmEw
NjdlNmQxYiBjb21waWxpbmcKUXVldWVkIGJ1aWxkIHRhc2sgdG8gL2tlcm5lbC10ZXN0cy9i
dWlsZC1xdWV1ZS9pMzg2LXJhbmRjb25maWctZmIwLTA0MDMxNDE5LWJkZDgwMDExZGFhMjBm
ODI4MDIzZjUxMWM5NzFhN2JhMDY3ZTZkMWIKQ2hlY2sgZm9yIGtlcm5lbCBpbiAva2VybmVs
L2kzODYtcmFuZGNvbmZpZy1mYjAtMDQwMzE0MTkvYmRkODAwMTFkYWEyMGY4MjgwMjNmNTEx
Yzk3MWE3YmEwNjdlNmQxYgp3YWl0aW5nIGZvciBjb21wbGV0aW9uIG9mIC9rZXJuZWwtdGVz
dHMvYnVpbGQtcXVldWUvaTM4Ni1yYW5kY29uZmlnLWZiMC0wNDAzMTQxOS1iZGQ4MDAxMWRh
YTIwZjgyODAyM2Y1MTFjOTcxYTdiYTA2N2U2ZDFiCndhaXRpbmcgZm9yIGNvbXBsZXRpb24g
b2YgL2tlcm5lbC10ZXN0cy9idWlsZC1xdWV1ZS8uaTM4Ni1yYW5kY29uZmlnLWZiMC0wNDAz
MTQxOS1iZGQ4MDAxMWRhYTIwZjgyODAyM2Y1MTFjOTcxYTdiYTA2N2U2ZDFiCmtlcm5lbDog
L2tlcm5lbC9pMzg2LXJhbmRjb25maWctZmIwLTA0MDMxNDE5L2JkZDgwMDExZGFhMjBmODI4
MDIzZjUxMWM5NzFhN2JhMDY3ZTZkMWIvdm1saW51ei0zLjEzLjAtMDAwMDgtZ2JkZDgwMDEK
CjIwMTQtMDQtMDUtMDU6MzA6NTAgZGV0ZWN0aW5nIGJvb3Qgc3RhdGUgLi4uLi4uLi4uLi4u
CTExLi4uCTM2Li4uLgk0MS4uCTQ1CTQ4Li4JNTUuLi4uCTcwIFNVQ0NFU1MKCkJpc2VjdGlu
ZzogNCByZXZpc2lvbnMgbGVmdCB0byB0ZXN0IGFmdGVyIHRoaXMgKHJvdWdobHkgMiBzdGVw
cykKWzVhZmZkMDY1MGJhZWU2YjUzNWNjYmY2MjViZDU4MTRiZWY0OWM3ZGNdIHJhbmRvbTog
dXNlIHRoZSBhcmNoaXRlY3R1cmFsIEhXUk5HIGZvciB0aGUgU0hBJ3MgSVYgaW4gZXh0cmFj
dF9idWYoKQpydW5uaW5nIC9jL2tlcm5lbC10ZXN0cy9iaXNlY3QtdGVzdC1ib290LWZhaWx1
cmUuc2ggL2hvbWUvd2ZnL2RybS9vYmotYmlzZWN0CmxzIC1hIC9rZXJuZWwtdGVzdHMvcnVu
LXF1ZXVlL2t2bS9pMzg2LXJhbmRjb25maWctZmIwLTA0MDMxNDE5L25leHQ6bWFzdGVyOjVh
ZmZkMDY1MGJhZWU2YjUzNWNjYmY2MjViZDU4MTRiZWY0OWM3ZGM6YmlzZWN0LWRybQoKMjAx
NC0wNC0wNS0wNTo0Nzo1MyA1YWZmZDA2NTBiYWVlNmI1MzVjY2JmNjI1YmQ1ODE0YmVmNDlj
N2RjIGNvbXBpbGluZwpRdWV1ZWQgYnVpbGQgdGFzayB0byAva2VybmVsLXRlc3RzL2J1aWxk
LXF1ZXVlL2kzODYtcmFuZGNvbmZpZy1mYjAtMDQwMzE0MTktNWFmZmQwNjUwYmFlZTZiNTM1
Y2NiZjYyNWJkNTgxNGJlZjQ5YzdkYwpDaGVjayBmb3Iga2VybmVsIGluIC9rZXJuZWwvaTM4
Ni1yYW5kY29uZmlnLWZiMC0wNDAzMTQxOS81YWZmZDA2NTBiYWVlNmI1MzVjY2JmNjI1YmQ1
ODE0YmVmNDljN2RjCndhaXRpbmcgZm9yIGNvbXBsZXRpb24gb2YgL2tlcm5lbC10ZXN0cy9i
dWlsZC1xdWV1ZS9pMzg2LXJhbmRjb25maWctZmIwLTA0MDMxNDE5LTVhZmZkMDY1MGJhZWU2
YjUzNWNjYmY2MjViZDU4MTRiZWY0OWM3ZGMKd2FpdGluZyBmb3IgY29tcGxldGlvbiBvZiAv
a2VybmVsLXRlc3RzL2J1aWxkLXF1ZXVlLy5pMzg2LXJhbmRjb25maWctZmIwLTA0MDMxNDE5
LTVhZmZkMDY1MGJhZWU2YjUzNWNjYmY2MjViZDU4MTRiZWY0OWM3ZGMKa2VybmVsOiAva2Vy
bmVsL2kzODYtcmFuZGNvbmZpZy1mYjAtMDQwMzE0MTkvNWFmZmQwNjUwYmFlZTZiNTM1Y2Ni
ZjYyNWJkNTgxNGJlZjQ5YzdkYy92bWxpbnV6LTMuMTMuMC0wMDAxMi1nNWFmZmQwNgoKMjAx
NC0wNC0wNS0wNjowNTo1MyBkZXRlY3RpbmcgYm9vdCBzdGF0ZSAuLi4uLi4uLi4JNC4uLgkx
NgkzNS4uCTQwCTY1Li4uLi4uLi4uLi4uLiBURVNUIEZBSUxVUkUKWyAgMjAwLjI1MjQ2MV0g
Y2FuOiByZXF1ZXN0X21vZHVsZSAoY2FuLXByb3RvLTUpIGZhaWxlZC4KWyAgMjAwLjQyMzEz
NV0gY2FuOiByZXF1ZXN0X21vZHVsZSAoY2FuLXByb3RvLTIpIGZhaWxlZC4KCkJVRzoga2Vy
bmVsIHRlc3QgY3Jhc2hlZApFbGFwc2VkIHRpbWU6IDIxMApxZW11LXN5c3RlbS14ODZfNjQg
LWNwdSBIYXN3ZWxsLCtzbWVwLCtzbWFwIC1rZXJuZWwgL2tlcm5lbC9pMzg2LXJhbmRjb25m
aWctZmIwLTA0MDMxNDE5LzVhZmZkMDY1MGJhZWU2YjUzNWNjYmY2MjViZDU4MTRiZWY0OWM3
ZGMvdm1saW51ei0zLjEzLjAtMDAwMTItZzVhZmZkMDYgLWFwcGVuZCAnaHVuZ190YXNrX3Bh
bmljPTEgZWFybHlwcmludGs9dHR5UzAsMTE1MjAwIGRlYnVnIGFwaWM9ZGVidWcgc3lzcnFf
YWx3YXlzX2VuYWJsZWQgcmN1cGRhdGUucmN1X2NwdV9zdGFsbF90aW1lb3V0PTEwMCBwYW5p
Yz0xMCBzb2Z0bG9ja3VwX3BhbmljPTEgbm1pX3dhdGNoZG9nPXBhbmljICBwcm9tcHRfcmFt
ZGlzaz0wIGNvbnNvbGU9dHR5UzAsMTE1MjAwIGNvbnNvbGU9dHR5MCB2Z2E9bm9ybWFsICBy
b290PS9kZXYvcmFtMCBydyBsaW5rPS9rZXJuZWwtdGVzdHMvcnVuLXF1ZXVlL2t2bS9pMzg2
LXJhbmRjb25maWctZmIwLTA0MDMxNDE5L25leHQ6bWFzdGVyOjVhZmZkMDY1MGJhZWU2YjUz
NWNjYmY2MjViZDU4MTRiZWY0OWM3ZGM6YmlzZWN0LWRybS8udm1saW51ei01YWZmZDA2NTBi
YWVlNmI1MzVjY2JmNjI1YmQ1ODE0YmVmNDljN2RjLTIwMTQwNDA1MDYwNTQ1LTIyLWYzIGJy
YW5jaD1uZXh0L21hc3RlciBCT09UX0lNQUdFPS9rZXJuZWwvaTM4Ni1yYW5kY29uZmlnLWZi
MC0wNDAzMTQxOS81YWZmZDA2NTBiYWVlNmI1MzVjY2JmNjI1YmQ1ODE0YmVmNDljN2RjL3Zt
bGludXotMy4xMy4wLTAwMDEyLWc1YWZmZDA2IGRyYmQubWlub3JfY291bnQ9OCcgIC1pbml0
cmQgL2tlcm5lbC10ZXN0cy9pbml0cmQvcXVhbnRhbC1jb3JlLWkzODYuY2d6IC1tIDMyMCAt
c21wIDIgLW5ldCBuaWMsdmxhbj0xLG1vZGVsPWUxMDAwIC1uZXQgdXNlcix2bGFuPTEsaG9z
dGZ3ZD10Y3A6OjUyNzgyLToyMiAtYm9vdCBvcmRlcj1uYyAtbm8tcmVib290IC13YXRjaGRv
ZyBpNjMwMGVzYiAtcnRjIGJhc2U9bG9jYWx0aW1lIC1waWRmaWxlIC9kZXYvc2htL2tib290
L3BpZC1xdWFudGFsLWYzLTU4IC1zZXJpYWwgZmlsZTovZGV2L3NobS9rYm9vdC9zZXJpYWwt
cXVhbnRhbC1mMy01OCAtZGFlbW9uaXplIC1kaXNwbGF5IG5vbmUgLW1vbml0b3IgbnVsbCAK
L2tlcm5lbC9pMzg2LXJhbmRjb25maWctZmIwLTA0MDMxNDE5LzVhZmZkMDY1MGJhZWU2YjUz
NWNjYmY2MjViZDU4MTRiZWY0OWM3ZGMvZG1lc2ctcXVhbnRhbC1qYWtldG93bi0yMDoyMDE0
MDQwNTA2MjEwNTppMzg2LXJhbmRjb25maWctZmIwLTA0MDMxNDE5OjoKL2tlcm5lbC9pMzg2
LXJhbmRjb25maWctZmIwLTA0MDMxNDE5LzVhZmZkMDY1MGJhZWU2YjUzNWNjYmY2MjViZDU4
MTRiZWY0OWM3ZGMvZG1lc2ctcXVhbnRhbC1qYWtldG93bi0yODoyMDE0MDQwNTA2MTk1Nzpp
Mzg2LXJhbmRjb25maWctZmIwLTA0MDMxNDE5OjoKL2tlcm5lbC9pMzg2LXJhbmRjb25maWct
ZmIwLTA0MDMxNDE5LzVhZmZkMDY1MGJhZWU2YjUzNWNjYmY2MjViZDU4MTRiZWY0OWM3ZGMv
ZG1lc2ctcXVhbnRhbC1qYWtldG93bi0zNDoyMDE0MDQwNTA2MTk1NjppMzg2LXJhbmRjb25m
aWctZmIwLTA0MDMxNDE5OjoKL2tlcm5lbC9pMzg2LXJhbmRjb25maWctZmIwLTA0MDMxNDE5
LzVhZmZkMDY1MGJhZWU2YjUzNWNjYmY2MjViZDU4MTRiZWY0OWM3ZGMvZG1lc2ctcXVhbnRh
bC1qYWtldG93bi04OjIwMTQwNDA1MDYyMDE1OmkzODYtcmFuZGNvbmZpZy1mYjAtMDQwMzE0
MTk6Ogo2NDo0OjUgYWxsX2dvb2Q6YmFkOmFsbF9iYWQgYm9vdHMKG1sxOzM1bTIwMTQtMDQt
MDUgMDY6MjE6NTUgUkVQRUFUIENPVU5UOiAxODIgICMgL2NjL3dmZy9saW51eC1kcm0vLnJl
cGVhdBtbMG0KCkJpc2VjdGluZzogMSByZXZpc2lvbiBsZWZ0IHRvIHRlc3QgYWZ0ZXIgdGhp
cyAocm91Z2hseSAxIHN0ZXApClsyNDNmMjYyNzgxNmJiMDE4ZmE5NDVhNDYwYmM4NzJhNTFh
M2I0ZmI5XSByYW5kb206IGVudHJvcHlfYnl0ZXMgaXMgYWN0dWFsbHkgYml0cwpydW5uaW5n
IC9jL2tlcm5lbC10ZXN0cy9iaXNlY3QtdGVzdC1ib290LWZhaWx1cmUuc2ggL2hvbWUvd2Zn
L2RybS9vYmotYmlzZWN0CmxzIC1hIC9rZXJuZWwtdGVzdHMvcnVuLXF1ZXVlL2t2bS9pMzg2
LXJhbmRjb25maWctZmIwLTA0MDMxNDE5L25leHQ6bWFzdGVyOjI0M2YyNjI3ODE2YmIwMThm
YTk0NWE0NjBiYzg3MmE1MWEzYjRmYjk6YmlzZWN0LWRybQoKMjAxNC0wNC0wNS0wNjoyMTo1
NiAyNDNmMjYyNzgxNmJiMDE4ZmE5NDVhNDYwYmM4NzJhNTFhM2I0ZmI5IGNvbXBpbGluZwpR
dWV1ZWQgYnVpbGQgdGFzayB0byAva2VybmVsLXRlc3RzL2J1aWxkLXF1ZXVlL2kzODYtcmFu
ZGNvbmZpZy1mYjAtMDQwMzE0MTktMjQzZjI2Mjc4MTZiYjAxOGZhOTQ1YTQ2MGJjODcyYTUx
YTNiNGZiOQpDaGVjayBmb3Iga2VybmVsIGluIC9rZXJuZWwvaTM4Ni1yYW5kY29uZmlnLWZi
MC0wNDAzMTQxOS8yNDNmMjYyNzgxNmJiMDE4ZmE5NDVhNDYwYmM4NzJhNTFhM2I0ZmI5Cndh
aXRpbmcgZm9yIGNvbXBsZXRpb24gb2YgL2tlcm5lbC10ZXN0cy9idWlsZC1xdWV1ZS9pMzg2
LXJhbmRjb25maWctZmIwLTA0MDMxNDE5LTI0M2YyNjI3ODE2YmIwMThmYTk0NWE0NjBiYzg3
MmE1MWEzYjRmYjkKd2FpdGluZyBmb3IgY29tcGxldGlvbiBvZiAva2VybmVsLXRlc3RzL2J1
aWxkLXF1ZXVlLy5pMzg2LXJhbmRjb25maWctZmIwLTA0MDMxNDE5LTI0M2YyNjI3ODE2YmIw
MThmYTk0NWE0NjBiYzg3MmE1MWEzYjRmYjkKa2VybmVsOiAva2VybmVsL2kzODYtcmFuZGNv
bmZpZy1mYjAtMDQwMzE0MTkvMjQzZjI2Mjc4MTZiYjAxOGZhOTQ1YTQ2MGJjODcyYTUxYTNi
NGZiOS92bWxpbnV6LTMuMTMuMC0wMDAxMC1nMjQzZjI2MgoKMjAxNC0wNC0wNS0wNzoxNjo1
NyBkZXRlY3RpbmcgYm9vdCBzdGF0ZSAuLi4uLi4uLi4uLi4uCTEyCTE3Li4JMjAgVEVTVCBG
QUlMVVJFClsgIDMxNS4wMzUzMjNdIHJhaWQ2dGVzdDogdGVzdF9kaXNrcyg2MiwgNjMpOiBm
YWlsYT0gNjIoUCkgIGZhaWxiPSA2MyhRKSAgT0sKWyAgMzE1LjA5NDIxMF0gcmFpZDZ0ZXN0
OiAKWyAgMzE1LjE2OTA4OF0gcmFpZDZ0ZXN0OiBjb21wbGV0ZSAoMjQyOSB0ZXN0cywgMCBm
YWlsdXJlcykKWyAgMzE1LjI1MDE2MV0gQlVHOiBzcGlubG9jayB0cnlsb2NrIGZhaWx1cmUg
b24gVVAgb24gQ1BVIzAsIHN3YXBwZXIvMQpbICAzMTUuMjU4NzUxXSAgbG9jazogbG9jay4x
NDQ3NysweDAvMHg0MCwgLm1hZ2ljOiBkZWFkNGVhZCwgLm93bmVyOiBzd2FwcGVyLzEsIC5v
d25lcl9jcHU6IDAKWyAgMzE1LjI1ODc1MV0gQ1BVOiAwIFBJRDogMSBDb21tOiBzd2FwcGVy
IE5vdCB0YWludGVkIDMuMTMuMC0wMDAxMC1nMjQzZjI2MiAjMQpbICAzMTUuMjU4NzUxXSBI
YXJkd2FyZSBuYW1lOiBCb2NocyBCb2NocywgQklPUyBCb2NocyAwMS8wMS8yMDExClsgIDMx
NS4yNTg3NTFdICBkMDA1ODAwMCBkMDA1ODAwMCBkMDA1N2QxYyBjMTgxYWMxMSBkMDA1N2Q0
NCBjMTgxNmIxNSBjMWE1MTEwOCBjMWNjMzA4MApbICAzMTUuMjU4NzUxXSAgZGVhZDRlYWQg
ZDAwNTgyYjAgMDAwMDAwMDEgMDAwMDAwMDAgYzFjYzMwODAgYzFhNGM0ZTUgZDAwNTdkNTQg
YzE4MTZiMzcKWyAgMzE1LjI1ODc1MV0gIDAwMDAwMDAwIGMxY2MzMDgwIGQwMDU3ZDYwIGMx
MDYxYzRjIGMxY2MzMDkwIGQwMDU3ZDg0IGMxODI2OWUyIDAwMDAwMDAwClsgIDMxNS4yNTg3
NTFdIENhbGwgVHJhY2U6ClsgIDMxNS4yNTg3NTFdICBbPGMxODFhYzExPl0gZHVtcF9zdGFj
aysweDE2LzB4MTgKWyAgMzE1LjI1ODc1MV0gIFs8YzE4MTZiMTU+XSBzcGluX2R1bXArMHg5
MC8weDk3ClsgIDMxNS4yNTg3NTFdICBbPGMxODE2YjM3Pl0gc3Bpbl9idWcrMHgxYi8weDFm
ClsgIDMxNS4yNTg3NTFdICBbPGMxMDYxYzRjPl0gZG9fcmF3X3NwaW5fdHJ5bG9jaysweDNj
LzB4NTAKWyAgMzE1LjI1ODc1MV0gIFs8YzE4MjY5ZTI+XSBfcmF3X3NwaW5fbG9ja19pcnFz
YXZlKzB4NTIvMHg4MApbICAzMTUuMjU4NzUxXSAgWzxjMTI2MTU2ND5dID8gX19wcmFuZG9t
X3Jlc2VlZCsweDE0LzB4YTAKWyAgMzE1LjI1ODc1MV0gIFs8YzEyNjE1NjQ+XSBfX3ByYW5k
b21fcmVzZWVkKzB4MTQvMHhhMApbICAzMTUuMjU4NzUxXSAgWzxjMTI2MTY2ZD5dIHByYW5k
b21fcmVzZWVkX2xhdGUrMHhkLzB4MTAKWyAgMzE1LjI1ODc1MV0gIFs8YzEzOTkxOGU+XSBj
cmVkaXRfZW50cm9weV9iaXRzKzB4MjBlLzB4MjMwClsgIDMxNS4yNTg3NTFdICBbPGMxMzk5
OWFiPl0gX3hmZXJfc2Vjb25kYXJ5X3Bvb2wrMHg3Yi8weDkwClsgIDMxNS4yNTg3NTFdICBb
PGMxMDAzNTc3Pl0gPyBkdW1wX3RyYWNlKzB4OTcvMHgxMDAKWyAgMzE1LjI1ODc1MV0gIFs8
YzEwNWU0NWM+XSA/IF9fbG9ja19hY3F1aXJlLmlzcmEuMzErMHgzN2MvMHhhMDAKWyAgMzE1
LjI1ODc1MV0gIFs8YzEzOTlhNDU+XSB4ZmVyX3NlY29uZGFyeV9wb29sKzB4NTUvMHg2MApb
ICAzMTUuMjU4NzUxXSAgWzxjMTM5OWE3NT5dIGV4dHJhY3RfZW50cm9weSsweDI1LzB4YjAK
WyAgMzE1LjI1ODc1MV0gIFs8YzEzOTliMjM+XSBnZXRfcmFuZG9tX2J5dGVzKzB4MjMvMHgz
MApbICAzMTUuMjU4NzUxXSAgWzxjMTI2MTU4OT5dIF9fcHJhbmRvbV9yZXNlZWQrMHgzOS8w
eGEwClsgIDMxNS4yNTg3NTFdICBbPGMxMjNjMTg3Pl0gPyByYWlkNl90ZXN0KzB4MTA3LzB4
MTIwClsgIDMxNS4yNTg3NTFdICBbPGMxZDc5MWVkPl0gPyBwcmFuZG9tX2luaXQrMHgxM2Ev
MHgxM2EKWyAgMzE1LjI1ODc1MV0gIFs8YzFkNzkxZjc+XSBwcmFuZG9tX3Jlc2VlZCsweGEv
MHgzZQpbICAzMTUuMjU4NzUxXSAgWzxjMTAwMDQ1YT5dIGRvX29uZV9pbml0Y2FsbCsweGNh
LzB4MTkwClsgIDMxNS4yNTg3NTFdICBbPGMxMDQ2ODQzPl0gPyBwYXJhbWVxKzB4MTMvMHg3
MApbICAzMTUuMjU4NzUxXSAgWzxjMWQ1ZDQwMD5dID8gcXVpZXRfa2VybmVsKzB4ZS8weDEx
ClsgIDMxNS4yNTg3NTFdICBbPGMxMDQ2YWQ5Pl0gPyBwYXJzZV9hcmdzKzB4MjM5LzB4NDIw
ClsgIDMxNS4yNTg3NTFdICBbPGMxZDVkYmU0Pl0ga2VybmVsX2luaXRfZnJlZWFibGUrMHgx
ODMvMHgyMWEKWyAgMzE1LjI1ODc1MV0gIFs8YzFkNWQ0ZWE+XSA/IGRvX2Vhcmx5X3BhcmFt
KzB4NzgvMHg3OApbICAzMTUuMjU4NzUxXSAgWzxjMTgxMzI4Yj5dIGtlcm5lbF9pbml0KzB4
Yi8weDEwMApbICAzMTUuMjU4NzUxXSAgWzxjMTA1MDg4Mj5dID8gc2NoZWR1bGVfdGFpbCsw
eDEyLzB4NDAKWyAgMzE1LjI1ODc1MV0gIFs8YzE4MmMwMzc+XSByZXRfZnJvbV9rZXJuZWxf
dGhyZWFkKzB4MWIvMHgyOApbICAzMTUuMjU4NzUxXSAgWzxjMTgxMzI4MD5dID8gcmVzdF9p
bml0KzB4YzAvMHhjMAoKRWxhcHNlZCB0aW1lOiAzMzAKcWVtdS1zeXN0ZW0teDg2XzY0IC1j
cHUgSGFzd2VsbCwrc21lcCwrc21hcCAta2VybmVsIC9rZXJuZWwvaTM4Ni1yYW5kY29uZmln
LWZiMC0wNDAzMTQxOS8yNDNmMjYyNzgxNmJiMDE4ZmE5NDVhNDYwYmM4NzJhNTFhM2I0ZmI5
L3ZtbGludXotMy4xMy4wLTAwMDEwLWcyNDNmMjYyIC1hcHBlbmQgJ2h1bmdfdGFza19wYW5p
Yz0xIGVhcmx5cHJpbnRrPXR0eVMwLDExNTIwMCBkZWJ1ZyBhcGljPWRlYnVnIHN5c3JxX2Fs
d2F5c19lbmFibGVkIHJjdXBkYXRlLnJjdV9jcHVfc3RhbGxfdGltZW91dD0xMDAgcGFuaWM9
MTAgc29mdGxvY2t1cF9wYW5pYz0xIG5taV93YXRjaGRvZz1wYW5pYyAgcHJvbXB0X3JhbWRp
c2s9MCBjb25zb2xlPXR0eVMwLDExNTIwMCBjb25zb2xlPXR0eTAgdmdhPW5vcm1hbCAgcm9v
dD0vZGV2L3JhbTAgcncgbGluaz0va2VybmVsLXRlc3RzL3J1bi1xdWV1ZS9rdm0vaTM4Ni1y
YW5kY29uZmlnLWZiMC0wNDAzMTQxOS9uZXh0Om1hc3RlcjoyNDNmMjYyNzgxNmJiMDE4ZmE5
NDVhNDYwYmM4NzJhNTFhM2I0ZmI5OmJpc2VjdC1kcm0vLnZtbGludXotMjQzZjI2Mjc4MTZi
YjAxOGZhOTQ1YTQ2MGJjODcyYTUxYTNiNGZiOS0yMDE0MDQwNTA3MTYwNi03LWYzIGJyYW5j
aD1uZXh0L21hc3RlciBCT09UX0lNQUdFPS9rZXJuZWwvaTM4Ni1yYW5kY29uZmlnLWZiMC0w
NDAzMTQxOS8yNDNmMjYyNzgxNmJiMDE4ZmE5NDVhNDYwYmM4NzJhNTFhM2I0ZmI5L3ZtbGlu
dXotMy4xMy4wLTAwMDEwLWcyNDNmMjYyIGRyYmQubWlub3JfY291bnQ9OCcgIC1pbml0cmQg
L2tlcm5lbC10ZXN0cy9pbml0cmQvcXVhbnRhbC1jb3JlLWkzODYuY2d6IC1tIDMyMCAtc21w
IDIgLW5ldCBuaWMsdmxhbj0xLG1vZGVsPWUxMDAwIC1uZXQgdXNlcix2bGFuPTEsaG9zdGZ3
ZD10Y3A6OjE5NjQyLToyMiAtYm9vdCBvcmRlcj1uYyAtbm8tcmVib290IC13YXRjaGRvZyBp
NjMwMGVzYiAtcnRjIGJhc2U9bG9jYWx0aW1lIC1waWRmaWxlIC9kZXYvc2htL2tib290L3Bp
ZC1xdWFudGFsLWYzLTEwIC1zZXJpYWwgZmlsZTovZGV2L3NobS9rYm9vdC9zZXJpYWwtcXVh
bnRhbC1mMy0xMCAtZGFlbW9uaXplIC1kaXNwbGF5IG5vbmUgLW1vbml0b3IgbnVsbCAKL2tl
cm5lbC9pMzg2LXJhbmRjb25maWctZmIwLTA0MDMxNDE5LzI0M2YyNjI3ODE2YmIwMThmYTk0
NWE0NjBiYzg3MmE1MWEzYjRmYjkvZG1lc2ctcXVhbnRhbC1mMy0xMDoyMDE0MDQwNTA3MjQ1
MTppMzg2LXJhbmRjb25maWctZmIwLTA0MDMxNDE5OjMuMTMuMC0wMDAxMC1nMjQzZjI2Mjox
Ci9rZXJuZWwvaTM4Ni1yYW5kY29uZmlnLWZiMC0wNDAzMTQxOS8yNDNmMjYyNzgxNmJiMDE4
ZmE5NDVhNDYwYmM4NzJhNTFhM2I0ZmI5L2RtZXNnLXF1YW50YWwtZjMtMTEzOjIwMTQwNDA1
MDcyNTAyOmkzODYtcmFuZGNvbmZpZy1mYjAtMDQwMzE0MTk6My4xMy4wLTAwMDEwLWcyNDNm
MjYyOjEKL2tlcm5lbC9pMzg2LXJhbmRjb25maWctZmIwLTA0MDMxNDE5LzI0M2YyNjI3ODE2
YmIwMThmYTk0NWE0NjBiYzg3MmE1MWEzYjRmYjkvZG1lc2ctcXVhbnRhbC1mMy0xMjA6MjAx
NDA0MDUwNzI0MDg6aTM4Ni1yYW5kY29uZmlnLWZiMC0wNDAzMTQxOTozLjEzLjAtMDAwMTAt
ZzI0M2YyNjI6MQova2VybmVsL2kzODYtcmFuZGNvbmZpZy1mYjAtMDQwMzE0MTkvMjQzZjI2
Mjc4MTZiYjAxOGZhOTQ1YTQ2MGJjODcyYTUxYTNiNGZiOS9kbWVzZy1xdWFudGFsLWYzLTEz
OjIwMTQwNDA1MDcyNDUxOmkzODYtcmFuZGNvbmZpZy1mYjAtMDQwMzE0MTk6My4xMy4wLTAw
MDEwLWcyNDNmMjYyOjEKL2tlcm5lbC9pMzg2LXJhbmRjb25maWctZmIwLTA0MDMxNDE5LzI0
M2YyNjI3ODE2YmIwMThmYTk0NWE0NjBiYzg3MmE1MWEzYjRmYjkvZG1lc2ctcXVhbnRhbC1m
My0zMjoyMDE0MDQwNTA3MjQzODppMzg2LXJhbmRjb25maWctZmIwLTA0MDMxNDE5OjMuMTMu
MC0wMDAxMC1nMjQzZjI2MjoxCi9rZXJuZWwvaTM4Ni1yYW5kY29uZmlnLWZiMC0wNDAzMTQx
OS8yNDNmMjYyNzgxNmJiMDE4ZmE5NDVhNDYwYmM4NzJhNTFhM2I0ZmI5L2RtZXNnLXF1YW50
YWwtZjMtNTI6MjAxNDA0MDUwNzI0Mjg6aTM4Ni1yYW5kY29uZmlnLWZiMC0wNDAzMTQxOToz
LjEzLjAtMDAwMTAtZzI0M2YyNjI6MQova2VybmVsL2kzODYtcmFuZGNvbmZpZy1mYjAtMDQw
MzE0MTkvMjQzZjI2Mjc4MTZiYjAxOGZhOTQ1YTQ2MGJjODcyYTUxYTNiNGZiOS9kbWVzZy1x
dWFudGFsLWYzLTYyOjIwMTQwNDA1MDcyNTIwOmkzODYtcmFuZGNvbmZpZy1mYjAtMDQwMzE0
MTk6My4xMy4wLTAwMDEwLWcyNDNmMjYyOjEKL2tlcm5lbC9pMzg2LXJhbmRjb25maWctZmIw
LTA0MDMxNDE5LzI0M2YyNjI3ODE2YmIwMThmYTk0NWE0NjBiYzg3MmE1MWEzYjRmYjkvZG1l
c2ctcXVhbnRhbC1mMy02NDoyMDE0MDQwNTA3MjMwOTppMzg2LXJhbmRjb25maWctZmIwLTA0
MDMxNDE5OjMuMTMuMC0wMDAxMC1nMjQzZjI2MjoxCjIwOjg6NyBhbGxfZ29vZDpiYWQ6YWxs
X2JhZCBib290cwoKQmlzZWN0aW5nOiAwIHJldmlzaW9ucyBsZWZ0IHRvIHRlc3QgYWZ0ZXIg
dGhpcyAocm91Z2hseSAwIHN0ZXBzKQpbMTFlOWVlOTg4ZThmOTUxZTRkYmM3NjU4MzJmZGY2
ZjA4YzJjOGI1NF0gcmFuZG9tOiBzaW1wbGlmeSBhY2NvdW50aW5nIGNvZGUKcnVubmluZyAv
Yy9rZXJuZWwtdGVzdHMvYmlzZWN0LXRlc3QtYm9vdC1mYWlsdXJlLnNoIC9ob21lL3dmZy9k
cm0vb2JqLWJpc2VjdApscyAtYSAva2VybmVsLXRlc3RzL3J1bi1xdWV1ZS9rdm0vaTM4Ni1y
YW5kY29uZmlnLWZiMC0wNDAzMTQxOS9uZXh0Om1hc3RlcjoxMWU5ZWU5ODhlOGY5NTFlNGRi
Yzc2NTgzMmZkZjZmMDhjMmM4YjU0OmJpc2VjdC1kcm0KCjIwMTQtMDQtMDUtMDc6MjY6MDUg
MTFlOWVlOTg4ZThmOTUxZTRkYmM3NjU4MzJmZGY2ZjA4YzJjOGI1NCBjb21waWxpbmcKUXVl
dWVkIGJ1aWxkIHRhc2sgdG8gL2tlcm5lbC10ZXN0cy9idWlsZC1xdWV1ZS9pMzg2LXJhbmRj
b25maWctZmIwLTA0MDMxNDE5LTExZTllZTk4OGU4Zjk1MWU0ZGJjNzY1ODMyZmRmNmYwOGMy
YzhiNTQKQ2hlY2sgZm9yIGtlcm5lbCBpbiAva2VybmVsL2kzODYtcmFuZGNvbmZpZy1mYjAt
MDQwMzE0MTkvMTFlOWVlOTg4ZThmOTUxZTRkYmM3NjU4MzJmZGY2ZjA4YzJjOGI1NAp3YWl0
aW5nIGZvciBjb21wbGV0aW9uIG9mIC9rZXJuZWwtdGVzdHMvYnVpbGQtcXVldWUvaTM4Ni1y
YW5kY29uZmlnLWZiMC0wNDAzMTQxOS0xMWU5ZWU5ODhlOGY5NTFlNGRiYzc2NTgzMmZkZjZm
MDhjMmM4YjU0CndhaXRpbmcgZm9yIGNvbXBsZXRpb24gb2YgL2tlcm5lbC10ZXN0cy9idWls
ZC1xdWV1ZS8uaTM4Ni1yYW5kY29uZmlnLWZiMC0wNDAzMTQxOS0xMWU5ZWU5ODhlOGY5NTFl
NGRiYzc2NTgzMmZkZjZmMDhjMmM4YjU0Cmtlcm5lbDogL2tlcm5lbC9pMzg2LXJhbmRjb25m
aWctZmIwLTA0MDMxNDE5LzExZTllZTk4OGU4Zjk1MWU0ZGJjNzY1ODMyZmRmNmYwOGMyYzhi
NTQvdm1saW51ei0zLjEzLjAtMDAwMDktZzExZTllZTkKCjIwMTQtMDQtMDUtMDg6MTY6MDUg
ZGV0ZWN0aW5nIGJvb3Qgc3RhdGUgLi4uLi4uLi4uLi4uLi4uLi4JMQkxMiBURVNUIEZBSUxV
UkUKWyAgMjM2LjI5NzUwMV0gcmFpZDZ0ZXN0OiB0ZXN0X2Rpc2tzKDYyLCA2Myk6IGZhaWxh
PSA2MihQKSAgZmFpbGI9IDYzKFEpICBPSwpbICAyMzYuMzU0MDI2XSByYWlkNnRlc3Q6IApb
ICAyMzYuNDEyMTgzXSByYWlkNnRlc3Q6IGNvbXBsZXRlICgyNDI5IHRlc3RzLCAwIGZhaWx1
cmVzKQpbICAyMzYuNDcwNzk4XSBCVUc6IHNwaW5sb2NrIHRyeWxvY2sgZmFpbHVyZSBvbiBV
UCBvbiBDUFUjMCwgc3dhcHBlci8xClsgIDIzNi40ODAwODBdICBsb2NrOiBsb2NrLjE0NDc3
KzB4MC8weDQwLCAubWFnaWM6IGRlYWQ0ZWFkLCAub3duZXI6IHN3YXBwZXIvMSwgLm93bmVy
X2NwdTogMApbICAyMzYuNDgwMDgwXSBDUFU6IDAgUElEOiAxIENvbW06IHN3YXBwZXIgTm90
IHRhaW50ZWQgMy4xMy4wLTAwMDA5LWcxMWU5ZWU5ICMxClsgIDIzNi40ODAwODBdIEhhcmR3
YXJlIG5hbWU6IEJvY2hzIEJvY2hzLCBCSU9TIEJvY2hzIDAxLzAxLzIwMTEKWyAgMjM2LjQ4
MDA4MF0gIGQwMDU4MDAwIGQwMDU4MDAwIGQwMDU3ZDFjIGMxODFhYzExIGQwMDU3ZDQ0IGMx
ODE2YjE1IGMxYTUxMTA4IGMxY2MzMDgwClsgIDIzNi40ODAwODBdICBkZWFkNGVhZCBkMDA1
ODJiMCAwMDAwMDAwMSAwMDAwMDAwMCBjMWNjMzA4MCBjMWE0YzRlNSBkMDA1N2Q1NCBjMTgx
NmIzNwpbICAyMzYuNDgwMDgwXSAgMDAwMDAwMDAgYzFjYzMwODAgZDAwNTdkNjAgYzEwNjFj
NGMgYzFjYzMwOTAgZDAwNTdkODQgYzE4MjY5ZTIgMDAwMDAwMDAKWyAgMjM2LjQ4MDA4MF0g
Q2FsbCBUcmFjZToKWyAgMjM2LjQ4MDA4MF0gIFs8YzE4MWFjMTE+XSBkdW1wX3N0YWNrKzB4
MTYvMHgxOApbICAyMzYuNDgwMDgwXSAgWzxjMTgxNmIxNT5dIHNwaW5fZHVtcCsweDkwLzB4
OTcKWyAgMjM2LjQ4MDA4MF0gIFs8YzE4MTZiMzc+XSBzcGluX2J1ZysweDFiLzB4MWYKWyAg
MjM2LjQ4MDA4MF0gIFs8YzEwNjFjNGM+XSBkb19yYXdfc3Bpbl90cnlsb2NrKzB4M2MvMHg1
MApbICAyMzYuNDgwMDgwXSAgWzxjMTgyNjllMj5dIF9yYXdfc3Bpbl9sb2NrX2lycXNhdmUr
MHg1Mi8weDgwClsgIDIzNi40ODAwODBdICBbPGMxMjYxNTY0Pl0gPyBfX3ByYW5kb21fcmVz
ZWVkKzB4MTQvMHhhMApbICAyMzYuNDgwMDgwXSAgWzxjMTI2MTU2ND5dIF9fcHJhbmRvbV9y
ZXNlZWQrMHgxNC8weGEwClsgIDIzNi40ODAwODBdICBbPGMxMjYxNjZkPl0gcHJhbmRvbV9y
ZXNlZWRfbGF0ZSsweGQvMHgxMApbICAyMzYuNDgwMDgwXSAgWzxjMTM5OTE4ZT5dIGNyZWRp
dF9lbnRyb3B5X2JpdHMrMHgyMGUvMHgyMzAKWyAgMjM2LjQ4MDA4MF0gIFs8YzEzOTk5YWI+
XSBfeGZlcl9zZWNvbmRhcnlfcG9vbCsweDdiLzB4OTAKWyAgMjM2LjQ4MDA4MF0gIFs8YzEw
MDM1Nzc+XSA/IGR1bXBfdHJhY2UrMHg5Ny8weDEwMApbICAyMzYuNDgwMDgwXSAgWzxjMTA1
ZTQ1Yz5dID8gX19sb2NrX2FjcXVpcmUuaXNyYS4zMSsweDM3Yy8weGEwMApbICAyMzYuNDgw
MDgwXSAgWzxjMTM5OWE0NT5dIHhmZXJfc2Vjb25kYXJ5X3Bvb2wrMHg1NS8weDYwClsgIDIz
Ni40ODAwODBdICBbPGMxMzk5YTc1Pl0gZXh0cmFjdF9lbnRyb3B5KzB4MjUvMHhiMApbICAy
MzYuNDgwMDgwXSAgWzxjMTM5OWIyMz5dIGdldF9yYW5kb21fYnl0ZXMrMHgyMy8weDMwClsg
IDIzNi40ODAwODBdICBbPGMxMjYxNTg5Pl0gX19wcmFuZG9tX3Jlc2VlZCsweDM5LzB4YTAK
WyAgMjM2LjQ4MDA4MF0gIFs8YzEyM2MxODc+XSA/IHJhaWQ2X3Rlc3QrMHgxMDcvMHgxMjAK
WyAgMjM2LjQ4MDA4MF0gIFs8YzFkNzkxZWQ+XSA/IHByYW5kb21faW5pdCsweDEzYS8weDEz
YQpbICAyMzYuNDgwMDgwXSAgWzxjMWQ3OTFmNz5dIHByYW5kb21fcmVzZWVkKzB4YS8weDNl
ClsgIDIzNi40ODAwODBdICBbPGMxMDAwNDVhPl0gZG9fb25lX2luaXRjYWxsKzB4Y2EvMHgx
OTAKWyAgMjM2LjQ4MDA4MF0gIFs8YzEwNDY4NDM+XSA/IHBhcmFtZXErMHgxMy8weDcwClsg
IDIzNi40ODAwODBdICBbPGMxZDVkNDAwPl0gPyBxdWlldF9rZXJuZWwrMHhlLzB4MTEKWyAg
MjM2LjQ4MDA4MF0gIFs8YzEwNDZhZDk+XSA/IHBhcnNlX2FyZ3MrMHgyMzkvMHg0MjAKWyAg
MjM2LjQ4MDA4MF0gIFs8YzFkNWRiZTQ+XSBrZXJuZWxfaW5pdF9mcmVlYWJsZSsweDE4My8w
eDIxYQpbICAyMzYuNDgwMDgwXSAgWzxjMWQ1ZDRlYT5dID8gZG9fZWFybHlfcGFyYW0rMHg3
OC8weDc4ClsgIDIzNi40ODAwODBdICBbPGMxODEzMjhiPl0ga2VybmVsX2luaXQrMHhiLzB4
MTAwClsgIDIzNi40ODAwODBdICBbPGMxMDUwODgyPl0gPyBzY2hlZHVsZV90YWlsKzB4MTIv
MHg0MApbICAyMzYuNDgwMDgwXSAgWzxjMTgyYzAzNz5dIHJldF9mcm9tX2tlcm5lbF90aHJl
YWQrMHgxYi8weDI4ClsgIDIzNi40ODAwODBdICBbPGMxODEzMjgwPl0gPyByZXN0X2luaXQr
MHhjMC8weGMwCgpFbGFwc2VkIHRpbWU6IDI1MApxZW11LXN5c3RlbS14ODZfNjQgLWNwdSBI
YXN3ZWxsLCtzbWVwLCtzbWFwIC1rZXJuZWwgL2tlcm5lbC9pMzg2LXJhbmRjb25maWctZmIw
LTA0MDMxNDE5LzExZTllZTk4OGU4Zjk1MWU0ZGJjNzY1ODMyZmRmNmYwOGMyYzhiNTQvdm1s
aW51ei0zLjEzLjAtMDAwMDktZzExZTllZTkgLWFwcGVuZCAnaHVuZ190YXNrX3BhbmljPTEg
ZWFybHlwcmludGs9dHR5UzAsMTE1MjAwIGRlYnVnIGFwaWM9ZGVidWcgc3lzcnFfYWx3YXlz
X2VuYWJsZWQgcmN1cGRhdGUucmN1X2NwdV9zdGFsbF90aW1lb3V0PTEwMCBwYW5pYz0xMCBz
b2Z0bG9ja3VwX3BhbmljPTEgbm1pX3dhdGNoZG9nPXBhbmljICBwcm9tcHRfcmFtZGlzaz0w
IGNvbnNvbGU9dHR5UzAsMTE1MjAwIGNvbnNvbGU9dHR5MCB2Z2E9bm9ybWFsICByb290PS9k
ZXYvcmFtMCBydyBsaW5rPS9rZXJuZWwtdGVzdHMvcnVuLXF1ZXVlL2t2bS9pMzg2LXJhbmRj
b25maWctZmIwLTA0MDMxNDE5L25leHQ6bWFzdGVyOjExZTllZTk4OGU4Zjk1MWU0ZGJjNzY1
ODMyZmRmNmYwOGMyYzhiNTQ6YmlzZWN0LWRybS8udm1saW51ei0xMWU5ZWU5ODhlOGY5NTFl
NGRiYzc2NTgzMmZkZjZmMDhjMmM4YjU0LTIwMTQwNDA1MDgxNTM1LTk4LWYzIGJyYW5jaD1u
ZXh0L21hc3RlciBCT09UX0lNQUdFPS9rZXJuZWwvaTM4Ni1yYW5kY29uZmlnLWZiMC0wNDAz
MTQxOS8xMWU5ZWU5ODhlOGY5NTFlNGRiYzc2NTgzMmZkZjZmMDhjMmM4YjU0L3ZtbGludXot
My4xMy4wLTAwMDA5LWcxMWU5ZWU5IGRyYmQubWlub3JfY291bnQ9OCcgIC1pbml0cmQgL2tl
cm5lbC10ZXN0cy9pbml0cmQvcXVhbnRhbC1jb3JlLWkzODYuY2d6IC1tIDMyMCAtc21wIDIg
LW5ldCBuaWMsdmxhbj0xLG1vZGVsPWUxMDAwIC1uZXQgdXNlcix2bGFuPTEsaG9zdGZ3ZD10
Y3A6OjU4MjIxLToyMiAtYm9vdCBvcmRlcj1uYyAtbm8tcmVib290IC13YXRjaGRvZyBpNjMw
MGVzYiAtcnRjIGJhc2U9bG9jYWx0aW1lIC1waWRmaWxlIC9kZXYvc2htL2tib290L3BpZC1x
dWFudGFsLWYzLTEwMSAtc2VyaWFsIGZpbGU6L2Rldi9zaG0va2Jvb3Qvc2VyaWFsLXF1YW50
YWwtZjMtMTAxIC1kYWVtb25pemUgLWRpc3BsYXkgbm9uZSAtbW9uaXRvciBudWxsIAova2Vy
bmVsL2kzODYtcmFuZGNvbmZpZy1mYjAtMDQwMzE0MTkvMTFlOWVlOTg4ZThmOTUxZTRkYmM3
NjU4MzJmZGY2ZjA4YzJjOGI1NC9kbWVzZy1xdWFudGFsLWYzLTEwMToyMDE0MDQwNTA4MjMy
MzppMzg2LXJhbmRjb25maWctZmIwLTA0MDMxNDE5OjMuMTMuMC0wMDAwOS1nMTFlOWVlOTox
Ci9rZXJuZWwvaTM4Ni1yYW5kY29uZmlnLWZiMC0wNDAzMTQxOS8xMWU5ZWU5ODhlOGY5NTFl
NGRiYzc2NTgzMmZkZjZmMDhjMmM4YjU0L2RtZXNnLXF1YW50YWwtZjMtMTA0OjIwMTQwNDA1
MDgyMjI5OmkzODYtcmFuZGNvbmZpZy1mYjAtMDQwMzE0MTk6My4xMy4wLTAwMDA5LWcxMWU5
ZWU5OjEKL2tlcm5lbC9pMzg2LXJhbmRjb25maWctZmIwLTA0MDMxNDE5LzExZTllZTk4OGU4
Zjk1MWU0ZGJjNzY1ODMyZmRmNmYwOGMyYzhiNTQvZG1lc2ctcXVhbnRhbC1mMy0xMTc6MjAx
NDA0MDUwODIyMTc6aTM4Ni1yYW5kY29uZmlnLWZiMC0wNDAzMTQxOTozLjEzLjAtMDAwMDkt
ZzExZTllZTk6MQova2VybmVsL2kzODYtcmFuZGNvbmZpZy1mYjAtMDQwMzE0MTkvMTFlOWVl
OTg4ZThmOTUxZTRkYmM3NjU4MzJmZGY2ZjA4YzJjOGI1NC9kbWVzZy1xdWFudGFsLWYzLTIy
OjIwMTQwNDA1MDgyMjUyOmkzODYtcmFuZGNvbmZpZy1mYjAtMDQwMzE0MTk6My4xMy4wLTAw
MDA5LWcxMWU5ZWU5OjEKL2tlcm5lbC9pMzg2LXJhbmRjb25maWctZmIwLTA0MDMxNDE5LzEx
ZTllZTk4OGU4Zjk1MWU0ZGJjNzY1ODMyZmRmNmYwOGMyYzhiNTQvZG1lc2ctcXVhbnRhbC1m
My0yNDoyMDE0MDQwNTA4MjIzOTppMzg2LXJhbmRjb25maWctZmIwLTA0MDMxNDE5OjMuMTMu
MC0wMDAwOS1nMTFlOWVlOToxCi9rZXJuZWwvaTM4Ni1yYW5kY29uZmlnLWZiMC0wNDAzMTQx
OS8xMWU5ZWU5ODhlOGY5NTFlNGRiYzc2NTgzMmZkZjZmMDhjMmM4YjU0L2RtZXNnLXF1YW50
YWwtZjMtNDQ6MjAxNDA0MDUwODIyMTk6aTM4Ni1yYW5kY29uZmlnLWZiMC0wNDAzMTQxOToz
LjEzLjAtMDAwMDktZzExZTllZTk6MQova2VybmVsL2kzODYtcmFuZGNvbmZpZy1mYjAtMDQw
MzE0MTkvMTFlOWVlOTg4ZThmOTUxZTRkYmM3NjU4MzJmZGY2ZjA4YzJjOGI1NC9kbWVzZy1x
dWFudGFsLWYzLTUwOjIwMTQwNDA1MDgyMjQyOmkzODYtcmFuZGNvbmZpZy1mYjAtMDQwMzE0
MTk6My4xMy4wLTAwMDA5LWcxMWU5ZWU5OjEKMTM6Nzo3IGFsbF9nb29kOmJhZDphbGxfYmFk
IGJvb3RzCgoxMWU5ZWU5ODhlOGY5NTFlNGRiYzc2NTgzMmZkZjZmMDhjMmM4YjU0IGlzIHRo
ZSBmaXJzdCBiYWQgY29tbWl0CmNvbW1pdCAxMWU5ZWU5ODhlOGY5NTFlNGRiYzc2NTgzMmZk
ZjZmMDhjMmM4YjU0CkF1dGhvcjogR3JlZyBQcmljZSA8cHJpY2VATUlULkVEVT4KRGF0ZTog
ICBUaHUgRGVjIDUgMTk6MzI6MTkgMjAxMyAtMDUwMAoKICAgIHJhbmRvbTogc2ltcGxpZnkg
YWNjb3VudGluZyBjb2RlCiAgICAKICAgIFdpdGggdGhpcyB3ZSBoYW5kbGUgInJlc2VydmVk
IiBpbiBqdXN0IG9uZSBwbGFjZS4gIEFzIGEgYm9udXMgdGhlCiAgICBjb2RlIGJlY29tZXMg
bGVzcyBuZXN0ZWQsIGFuZCB0aGUgIndha2V1cF93cml0ZSIgZmxhZyB2YXJpYWJsZQogICAg
YmVjb21lcyB1bm5lY2Vzc2FyeS4gIFRoZSB2YXJpYWJsZSAiZmxhZ3MiIHdhcyBhbHJlYWR5
IHVudXNlZC4KICAgIAogICAgVGhpcyBjb2RlIGJlaGF2ZXMgaWRlbnRpY2FsbHkgdG8gdGhl
IHByZXZpb3VzIHZlcnNpb24gZXhjZXB0IGluCiAgICB0d28gcGF0aG9sb2dpY2FsIGNhc2Vz
IHRoYXQgZG9uJ3Qgb2NjdXIuICBJZiB0aGUgYXJndW1lbnQgIm5ieXRlcyIKICAgIGlzIGFs
cmVhZHkgbGVzcyB0aGFuICJtaW4iLCB0aGVuIHdlIGRpZG4ndCBwcmV2aW91c2x5IGVuZm9y
Y2UKICAgICJtaW4iLiAgSWYgci0+bGltaXQgaXMgZmFsc2Ugd2hpbGUgInJlc2VydmVkIiBp
cyBub256ZXJvLCB0aGVuIHdlCiAgICBwcmV2aW91c2x5IGFwcGxpZWQgInJlc2VydmVkIiBp
biBjaGVja2luZyB3aGV0aGVyIHdlIGhhZCBlbm91Z2gKICAgIGJpdHMsIGV2ZW4gdGhvdWdo
IHdlIGRvbid0IGFwcGx5IGl0IHRvIGFjdHVhbGx5IGxpbWl0IGhvdyBtYW55IHdlCiAgICB0
YWtlLiAgVGhlIGNhbGxlcnMgb2YgYWNjb3VudCgpIG5ldmVyIGV4ZXJjaXNlIGVpdGhlciBv
ZiB0aGVzZSBjYXNlcy4KICAgIAogICAgQmVmb3JlIHRoZSBwcmV2aW91cyBjb21taXQsIGl0
IHdhcyBwb3NzaWJsZSBmb3IgIm5ieXRlcyIgdG8gYmUgbGVzcwogICAgdGhhbiAibWluIiBp
ZiB1c2Vyc3BhY2UgY2hvc2UgYSBwYXRob2xvZ2ljYWwgY29uZmlndXJhdGlvbiwgYnV0IG5v
CiAgICBsb25nZXIuCiAgICAKICAgIENjOiBKaXJpIEtvc2luYSA8amtvc2luYUBzdXNlLmN6
PgogICAgQ2M6ICJILiBQZXRlciBBbnZpbiIgPGhwYUB6eXRvci5jb20+CiAgICBTaWduZWQt
b2ZmLWJ5OiBHcmVnIFByaWNlIDxwcmljZUBtaXQuZWR1PgogICAgU2lnbmVkLW9mZi1ieTog
IlRoZW9kb3JlIFRzJ28iIDx0eXRzb0BtaXQuZWR1PgoKOjA0MDAwMCAwNDAwMDAgYzdjNTA1
MTMxYjk2MThlNDBiNmY0YjcxZDRmNTg5MDEwYjBjNTYxZiAyYWE0MmFlZTY5NmI5YWU1OTFl
MzlmNzk1ZGYyOGVjM2ZiMDc1YTU3IE0JZHJpdmVycwpiaXNlY3QgcnVuIHN1Y2Nlc3MKUHJl
dmlvdXMgSEVBRCBwb3NpdGlvbiB3YXMgMTFlOWVlOS4uLiByYW5kb206IHNpbXBsaWZ5IGFj
Y291bnRpbmcgY29kZQpIRUFEIGlzIG5vdyBhdCBiZGQ4MDAxLi4uIHJhbmRvbTogdGlnaHRl
biBib3VuZCBvbiByYW5kb21fcmVhZF93YWtldXBfdGhyZXNoCmxzIC1hIC9rZXJuZWwtdGVz
dHMvcnVuLXF1ZXVlL2t2bS9pMzg2LXJhbmRjb25maWctZmIwLTA0MDMxNDE5L25leHQ6bWFz
dGVyOmJkZDgwMDExZGFhMjBmODI4MDIzZjUxMWM5NzFhN2JhMDY3ZTZkMWI6YmlzZWN0LWRy
bQoKMjAxNC0wNC0wNS0wODoyNTo0NiBiZGQ4MDAxMWRhYTIwZjgyODAyM2Y1MTFjOTcxYTdi
YTA2N2U2ZDFiIHJldXNlIC9rZXJuZWwvaTM4Ni1yYW5kY29uZmlnLWZiMC0wNDAzMTQxOS9i
ZGQ4MDAxMWRhYTIwZjgyODAyM2Y1MTFjOTcxYTdiYTA2N2U2ZDFiL3ZtbGludXotMy4xMy4w
LTAwMDA4LWdiZGQ4MDAxCgoyMDE0LTA0LTA1LTA4OjI1OjQ3IGRldGVjdGluZyBib290IHN0
YXRlIC4uLi4uLi4uLi4uLi4uLi4uCTIuLi4uLgkxNQkyMS4uLi4uCTI2CTQxCTUxLi4uLi4u
Lgk2Mwk4MQk5NwkxMTMJMTI0CTEyOAkxNDgJMTUxLi4uLi4uLgkxNjQJMTgwCTE5OAkyMTUJ
MjI2Li4uCTIzOAkyNTQJMjcxCTI4NgkyOTQuCTMwNAkzMjAJMzM3CTM1MgkzNjcJMzgzCTM5
My4JMzk1CTQxMQk0MjcJNDQ1CTQ2Mgk0NzguCTQ4NAk1MDIJNTE5CTUzNi4uLgk1NDYgU1VD
Q0VTUwoKUHJldmlvdXMgSEVBRCBwb3NpdGlvbiB3YXMgYmRkODAwMS4uLiByYW5kb206IHRp
Z2h0ZW4gYm91bmQgb24gcmFuZG9tX3JlYWRfd2FrZXVwX3RocmVzaApIRUFEIGlzIG5vdyBh
dCA0YjIyZWZkLi4uIEFkZCBsaW51eC1uZXh0IHNwZWNpZmljIGZpbGVzIGZvciAyMDE0MDQw
MwpscyAtYSAva2VybmVsLXRlc3RzL3J1bi1xdWV1ZS9rdm0vaTM4Ni1yYW5kY29uZmlnLWZi
MC0wNDAzMTQxOS9uZXh0Om1hc3Rlcjo0YjIyZWZkZDU1OTVmMGFjYjQ4ZjAyYmY2NjRhNDUx
ZWU5OGY5YTJlOmJpc2VjdC1kcm0KIFRFU1QgRkFJTFVSRQpbICAyMDEuMzYzNjU2XSByYWlk
NnRlc3Q6IHRlc3RfZGlza3MoNjIsIDYzKTogZmFpbGE9IDYyKFApICBmYWlsYj0gNjMoUSkg
IE9LClsgIDIwMS40Mzk1ODNdIHJhaWQ2dGVzdDogClsgIDIwMS40OTgzMzFdIHJhaWQ2dGVz
dDogY29tcGxldGUgKDI0MjkgdGVzdHMsIDAgZmFpbHVyZXMpClsgIDIwMS41NTc0MzRdIEJV
Rzogc3BpbmxvY2sgdHJ5bG9jayBmYWlsdXJlIG9uIFVQIG9uIENQVSMwLCBzd2FwcGVyLzEK
WyAgMjAxLjU2NjQ1NF0gIGxvY2s6IGxvY2suMTMyNTArMHgwLzB4NDAsIC5tYWdpYzogZGVh
ZDRlYWQsIC5vd25lcjogc3dhcHBlci8xLCAub3duZXJfY3B1OiAwClsgIDIwMS41NjY0NTRd
IENQVTogMCBQSUQ6IDEgQ29tbTogc3dhcHBlciBOb3QgdGFpbnRlZCAzLjE0LjAtbmV4dC0y
MDE0MDQwMyAjMQpbICAyMDEuNTY2NDU0XSBIYXJkd2FyZSBuYW1lOiBCb2NocyBCb2Nocywg
QklPUyBCb2NocyAwMS8wMS8yMDExClsgIDIwMS41NjY0NTRdICBkMDA1ODAwMCBkMDA1ODAw
MCBkMDA1NWQyNCBjMTg0YmYzYSBkMDA1NWQ0YyBjMTg0ODM3NiBjMWFhNTYzOCBjMWQyMDNj
MApbICAyMDEuNTY2NDU0XSAgZGVhZDRlYWQgZDAwNTgzNWMgMDAwMDAwMDEgMDAwMDAwMDAg
YzFkMjAzYzAgYzFhYTA4N2EgZDAwNTVkNWMgYzE4NDgzOTgKWyAgMjAxLjU2NjQ1NF0gIDAw
MDAwMDAwIDAwMDAwMDAxIGQwMDU1ZDY4IGMxMDY1NmNjIGMxZDIwM2MwIGQwMDU1ZDg0IGMx
ODU3Y2M0IDAwMDAwMDQ2ClsgIDIwMS41NjY0NTRdIENhbGwgVHJhY2U6ClsgIDIwMS41NjY0
NTRdICBbPGMxODRiZjNhPl0gZHVtcF9zdGFjaysweDE2LzB4MTgKWyAgMjAxLjU2NjQ1NF0g
IFs8YzE4NDgzNzY+XSBzcGluX2R1bXArMHg5MC8weDk3ClsgIDIwMS41NjY0NTRdICBbPGMx
ODQ4Mzk4Pl0gc3Bpbl9idWcrMHgxYi8weDFmClsgIDIwMS41NjY0NTRdICBbPGMxMDY1NmNj
Pl0gZG9fcmF3X3NwaW5fdHJ5bG9jaysweDNjLzB4NTAKWyAgMjAxLjU2NjQ1NF0gIFs8YzE4
NTdjYzQ+XSBfcmF3X3NwaW5fdHJ5bG9jaysweDE0LzB4NjAKWyAgMjAxLjU2NjQ1NF0gIFs8
YzEyNmU5MjI+XSBfX3ByYW5kb21fcmVzZWVkKzB4MjIvMHhkMApbICAyMDEuNTY2NDU0XSAg
WzxjMTI2ZWE0ZD5dIHByYW5kb21fcmVzZWVkX2xhdGUrMHhkLzB4MTAKWyAgMjAxLjU2NjQ1
NF0gIFs8YzEzYTk0ZGU+XSBjcmVkaXRfZW50cm9weV9iaXRzKzB4MjBlLzB4MjMwClsgIDIw
MS41NjY0NTRdICBbPGMxM2E5ZThiPl0gX3hmZXJfc2Vjb25kYXJ5X3Bvb2wrMHg3Yi8weDkw
ClsgIDIwMS41NjY0NTRdICBbPGMxMDAzM2U5Pl0gPyBkdW1wX3RyYWNlKzB4OTkvMHgxYTAK
WyAgMjAxLjU2NjQ1NF0gIFs8YzEwNjFkNDQ+XSA/IF9fbG9ja19hY3F1aXJlLmlzcmEuMzIr
MHgzNzQvMHg5ZjAKWyAgMjAxLjU2NjQ1NF0gIFs8YzE4NTdmZGQ+XSA/IF9yYXdfc3Bpbl91
bmxvY2srMHgxZC8weDMwClsgIDIwMS41NjY0NTRdICBbPGMxM2E5ZjI1Pl0geGZlcl9zZWNv
bmRhcnlfcG9vbCsweDU1LzB4NjAKWyAgMjAxLjU2NjQ1NF0gIFs8YzEzYTlkODU+XSBleHRy
YWN0X2VudHJvcHkrMHgyNS8weGIwClsgIDIwMS41NjY0NTRdICBbPGMxM2E5ZjUzPl0gZ2V0
X3JhbmRvbV9ieXRlcysweDIzLzB4MzAKWyAgMjAxLjU2NjQ1NF0gIFs8YzEyNmU5NTU+XSBf
X3ByYW5kb21fcmVzZWVkKzB4NTUvMHhkMApbICAyMDEuNTY2NDU0XSAgWzxjMTI0OGM2Nz5d
ID8gcmFpZDZfdGVzdCsweDEwNy8weDEyMApbICAyMDEuNTY2NDU0XSAgWzxjMWRkM2UxZT5d
ID8gcHJhbmRvbV9pbml0KzB4MTNhLzB4MTNhClsgIDIwMS41NjY0NTRdICBbPGMxZGQzZTI4
Pl0gcHJhbmRvbV9yZXNlZWQrMHhhLzB4M2UKWyAgMjAxLjU2NjQ1NF0gIFs8YzEwMDA0NmE+
XSBkb19vbmVfaW5pdGNhbGwrMHhjYS8weDE5MApbICAyMDEuNTY2NDU0XSAgWzxjMTI2ZDE3
ZD5dID8gc3RybGVuKzB4ZC8weDIwClsgIDIwMS41NjY0NTRdICBbPGMxMDQ4NDEzPl0gPyBw
YXJhbWVxKzB4MTMvMHg3MApbICAyMDEuNTY2NDU0XSAgWzxjMWRiNzUwMD5dID8gcmVwYWly
X2Vudl9zdHJpbmcrMHhlLzB4NTEKWyAgMjAxLjU2NjQ1NF0gIFs8YzEwNDg2YTk+XSA/IHBh
cnNlX2FyZ3MrMHgyMzkvMHg0MjAKWyAgMjAxLjU2NjQ1NF0gIFs8YzFkYjdjMTg+XSBrZXJu
ZWxfaW5pdF9mcmVlYWJsZSsweDE4My8weDIxYQpbICAyMDEuNTY2NDU0XSAgWzxjMWRiNzRm
Mj5dID8gZG9fZWFybHlfcGFyYW0rMHg3OC8weDc4ClsgIDIwMS41NjY0NTRdICBbPGMxODQ0
YjViPl0ga2VybmVsX2luaXQrMHhiLzB4ZDAKWyAgMjAxLjU2NjQ1NF0gIFs8YzEwNTJjNTI+
XSA/IHNjaGVkdWxlX3RhaWwrMHgxMi8weDQwClsgIDIwMS41NjY0NTRdICBbPGMxODVkYzgw
Pl0gcmV0X2Zyb21fa2VybmVsX3RocmVhZCsweDIwLzB4MzAKWyAgMjAxLjU2NjQ1NF0gIFs8
YzE4NDRiNTA+XSA/IHJlc3RfaW5pdCsweGMwLzB4YzAKWyAgMjAxLjU2NjQ1NF0gcmFuZG9t
OiBub25ibG9ja2luZyBwb29sIGlzIGluaXRpYWxpemVkCgpFbGFwc2VkIHRpbWU6IDIxNQov
a2VybmVsL2kzODYtcmFuZGNvbmZpZy1mYjAtMDQwMzE0MTkvNGIyMmVmZGQ1NTk1ZjBhY2I0
OGYwMmJmNjY0YTQ1MWVlOThmOWEyZS9kbWVzZy1xdWFudGFsLWYyLTk0OjIwMTQwNDA0MTEz
MjU1OmkzODYtcmFuZGNvbmZpZy1mYjAtMDQwMzE0MTk6My4xNC4wLW5leHQtMjAxNDA0MDM6
MQova2VybmVsL2kzODYtcmFuZGNvbmZpZy1mYjAtMDQwMzE0MTkvNGIyMmVmZGQ1NTk1ZjBh
Y2I0OGYwMmJmNjY0YTQ1MWVlOThmOWEyZS9kbWVzZy15b2N0by1sa3AtaWIwNC00NDoyMDE0
MDQwMzE1NDI1NjppMzg2LXJhbmRjb25maWctZmIwLTA0MDMxNDE5OjMuMTQuMC1uZXh0LTIw
MTQwNDAzOjEKL2tlcm5lbC9pMzg2LXJhbmRjb25maWctZmIwLTA0MDMxNDE5LzRiMjJlZmRk
NTU5NWYwYWNiNDhmMDJiZjY2NGE0NTFlZTk4ZjlhMmUvZG1lc2ctcXVhbnRhbC1sa3AtaWIw
NC0yNDoyMDE0MDQwMzE1MjYyMjppMzg2LXJhbmRjb25maWctZmIwLTA0MDMxNDE5OjMuMTQu
MC1uZXh0LTIwMTQwNDAzOjEKL2tlcm5lbC9pMzg2LXJhbmRjb25maWctZmIwLTA0MDMxNDE5
LzRiMjJlZmRkNTU5NWYwYWNiNDhmMDJiZjY2NGE0NTFlZTk4ZjlhMmUvZG1lc2ctcXVhbnRh
bC1qYWtldG93bi0zODoyMDE0MDQwNDExNDEyOTppMzg2LXJhbmRjb25maWctZmIwLTA0MDMx
NDE5OjoKL2tlcm5lbC9pMzg2LXJhbmRjb25maWctZmIwLTA0MDMxNDE5LzRiMjJlZmRkNTU5
NWYwYWNiNDhmMDJiZjY2NGE0NTFlZTk4ZjlhMmUvZG1lc2ctcXVhbnRhbC1mMi0xMTA6MjAx
NDA0MDQxMTMyNTU6aTM4Ni1yYW5kY29uZmlnLWZiMC0wNDAzMTQxOTozLjE0LjAtbmV4dC0y
MDE0MDQwMzoxCjE2OjU6NyBhbGxfZ29vZDpiYWQ6YWxsX2JhZCBib290cwoKSEVBRCBpcyBu
b3cgYXQgNGIyMmVmZCBBZGQgbGludXgtbmV4dCBzcGVjaWZpYyBmaWxlcyBmb3IgMjAxNDA0
MDMKCj09PT09PT09PSB1cHN0cmVhbSA9PT09PT09PT0KUHJldmlvdXMgSEVBRCBwb3NpdGlv
biB3YXMgNGIyMmVmZC4uLiBBZGQgbGludXgtbmV4dCBzcGVjaWZpYyBmaWxlcyBmb3IgMjAx
NDA0MDMKSEVBRCBpcyBub3cgYXQgZDE1ZTAzMS4uLiBNZXJnZSB0YWcgJ3hmcy1mb3ItbGlu
dXMtMy4xNS1yYzEnIG9mIGdpdDovL29zcy5zZ2kuY29tL3hmcy94ZnMKbHMgLWEgL2tlcm5l
bC10ZXN0cy9ydW4tcXVldWUva3ZtL2kzODYtcmFuZGNvbmZpZy1mYjAtMDQwMzE0MTkvbmV4
dDptYXN0ZXI6ZDE1ZTAzMTA0ZWI5YTRmOGUyNDRhYjZlZDNjYTVhMTA3ZTQ2ZGIxMzpiaXNl
Y3QtZHJtCgoyMDE0LTA0LTA1LTA5OjEyOjU1IGQxNWUwMzEwNGViOWE0ZjhlMjQ0YWI2ZWQz
Y2E1YTEwN2U0NmRiMTMgY29tcGlsaW5nClF1ZXVlZCBidWlsZCB0YXNrIHRvIC9rZXJuZWwt
dGVzdHMvYnVpbGQtcXVldWUvaTM4Ni1yYW5kY29uZmlnLWZiMC0wNDAzMTQxOS1kMTVlMDMx
MDRlYjlhNGY4ZTI0NGFiNmVkM2NhNWExMDdlNDZkYjEzCkNoZWNrIGZvciBrZXJuZWwgaW4g
L2tlcm5lbC9pMzg2LXJhbmRjb25maWctZmIwLTA0MDMxNDE5L2QxNWUwMzEwNGViOWE0Zjhl
MjQ0YWI2ZWQzY2E1YTEwN2U0NmRiMTMKd2FpdGluZyBmb3IgY29tcGxldGlvbiBvZiAva2Vy
bmVsLXRlc3RzL2J1aWxkLXF1ZXVlL2kzODYtcmFuZGNvbmZpZy1mYjAtMDQwMzE0MTktZDE1
ZTAzMTA0ZWI5YTRmOGUyNDRhYjZlZDNjYTVhMTA3ZTQ2ZGIxMwobWzE7MzVtMjAxNC0wNC0w
NSAwOToyMzo1NSBLZXJuZWwgYnVpbGQgZmFpbCBvciB0aW1lb3V0G1swbQoyMDE0LTA0LTA1
LTA5OjIzOjU1IGQxNWUwMzEwNGViOWE0ZjhlMjQ0YWI2ZWQzY2E1YTEwN2U0NmRiMTMgU0tJ
UCBCUk9LRU4gQlVJTEQKQ2hlY2sgL2tlcm5lbC10ZXN0cy9idWlsZC1zZXJ2ZWQvaTM4Ni1y
YW5kY29uZmlnLWZiMC0wNDAzMTQxOS1kMTVlMDMxMDRlYjlhNGY4ZTI0NGFiNmVkM2NhNWEx
MDdlNDZkYjEzCgo9PT09PT09PT0gbGludXgtbmV4dCA9PT09PT09PT0KUHJldmlvdXMgSEVB
RCBwb3NpdGlvbiB3YXMgZDE1ZTAzMS4uLiBNZXJnZSB0YWcgJ3hmcy1mb3ItbGludXMtMy4x
NS1yYzEnIG9mIGdpdDovL29zcy5zZ2kuY29tL3hmcy94ZnMKSEVBRCBpcyBub3cgYXQgNGIy
MmVmZC4uLiBBZGQgbGludXgtbmV4dCBzcGVjaWZpYyBmaWxlcyBmb3IgMjAxNDA0MDMKbHMg
LWEgL2tlcm5lbC10ZXN0cy9ydW4tcXVldWUva3ZtL2kzODYtcmFuZGNvbmZpZy1mYjAtMDQw
MzE0MTkvbmV4dDptYXN0ZXI6NGIyMmVmZGQ1NTk1ZjBhY2I0OGYwMmJmNjY0YTQ1MWVlOThm
OWEyZTpiaXNlY3QtZHJtCiBURVNUIEZBSUxVUkUKWyAgMjAxLjM2MzY1Nl0gcmFpZDZ0ZXN0
OiB0ZXN0X2Rpc2tzKDYyLCA2Myk6IGZhaWxhPSA2MihQKSAgZmFpbGI9IDYzKFEpICBPSwpb
ICAyMDEuNDM5NTgzXSByYWlkNnRlc3Q6IApbICAyMDEuNDk4MzMxXSByYWlkNnRlc3Q6IGNv
bXBsZXRlICgyNDI5IHRlc3RzLCAwIGZhaWx1cmVzKQpbICAyMDEuNTU3NDM0XSBCVUc6IHNw
aW5sb2NrIHRyeWxvY2sgZmFpbHVyZSBvbiBVUCBvbiBDUFUjMCwgc3dhcHBlci8xClsgIDIw
MS41NjY0NTRdICBsb2NrOiBsb2NrLjEzMjUwKzB4MC8weDQwLCAubWFnaWM6IGRlYWQ0ZWFk
LCAub3duZXI6IHN3YXBwZXIvMSwgLm93bmVyX2NwdTogMApbICAyMDEuNTY2NDU0XSBDUFU6
IDAgUElEOiAxIENvbW06IHN3YXBwZXIgTm90IHRhaW50ZWQgMy4xNC4wLW5leHQtMjAxNDA0
MDMgIzEKWyAgMjAxLjU2NjQ1NF0gSGFyZHdhcmUgbmFtZTogQm9jaHMgQm9jaHMsIEJJT1Mg
Qm9jaHMgMDEvMDEvMjAxMQpbICAyMDEuNTY2NDU0XSAgZDAwNTgwMDAgZDAwNTgwMDAgZDAw
NTVkMjQgYzE4NGJmM2EgZDAwNTVkNGMgYzE4NDgzNzYgYzFhYTU2MzggYzFkMjAzYzAKWyAg
MjAxLjU2NjQ1NF0gIGRlYWQ0ZWFkIGQwMDU4MzVjIDAwMDAwMDAxIDAwMDAwMDAwIGMxZDIw
M2MwIGMxYWEwODdhIGQwMDU1ZDVjIGMxODQ4Mzk4ClsgIDIwMS41NjY0NTRdICAwMDAwMDAw
MCAwMDAwMDAwMSBkMDA1NWQ2OCBjMTA2NTZjYyBjMWQyMDNjMCBkMDA1NWQ4NCBjMTg1N2Nj
NCAwMDAwMDA0NgpbICAyMDEuNTY2NDU0XSBDYWxsIFRyYWNlOgpbICAyMDEuNTY2NDU0XSAg
WzxjMTg0YmYzYT5dIGR1bXBfc3RhY2srMHgxNi8weDE4ClsgIDIwMS41NjY0NTRdICBbPGMx
ODQ4Mzc2Pl0gc3Bpbl9kdW1wKzB4OTAvMHg5NwpbICAyMDEuNTY2NDU0XSAgWzxjMTg0ODM5
OD5dIHNwaW5fYnVnKzB4MWIvMHgxZgpbICAyMDEuNTY2NDU0XSAgWzxjMTA2NTZjYz5dIGRv
X3Jhd19zcGluX3RyeWxvY2srMHgzYy8weDUwClsgIDIwMS41NjY0NTRdICBbPGMxODU3Y2M0
Pl0gX3Jhd19zcGluX3RyeWxvY2srMHgxNC8weDYwClsgIDIwMS41NjY0NTRdICBbPGMxMjZl
OTIyPl0gX19wcmFuZG9tX3Jlc2VlZCsweDIyLzB4ZDAKWyAgMjAxLjU2NjQ1NF0gIFs8YzEy
NmVhNGQ+XSBwcmFuZG9tX3Jlc2VlZF9sYXRlKzB4ZC8weDEwClsgIDIwMS41NjY0NTRdICBb
PGMxM2E5NGRlPl0gY3JlZGl0X2VudHJvcHlfYml0cysweDIwZS8weDIzMApbICAyMDEuNTY2
NDU0XSAgWzxjMTNhOWU4Yj5dIF94ZmVyX3NlY29uZGFyeV9wb29sKzB4N2IvMHg5MApbICAy
MDEuNTY2NDU0XSAgWzxjMTAwMzNlOT5dID8gZHVtcF90cmFjZSsweDk5LzB4MWEwClsgIDIw
MS41NjY0NTRdICBbPGMxMDYxZDQ0Pl0gPyBfX2xvY2tfYWNxdWlyZS5pc3JhLjMyKzB4Mzc0
LzB4OWYwClsgIDIwMS41NjY0NTRdICBbPGMxODU3ZmRkPl0gPyBfcmF3X3NwaW5fdW5sb2Nr
KzB4MWQvMHgzMApbICAyMDEuNTY2NDU0XSAgWzxjMTNhOWYyNT5dIHhmZXJfc2Vjb25kYXJ5
X3Bvb2wrMHg1NS8weDYwClsgIDIwMS41NjY0NTRdICBbPGMxM2E5ZDg1Pl0gZXh0cmFjdF9l
bnRyb3B5KzB4MjUvMHhiMApbICAyMDEuNTY2NDU0XSAgWzxjMTNhOWY1Mz5dIGdldF9yYW5k
b21fYnl0ZXMrMHgyMy8weDMwClsgIDIwMS41NjY0NTRdICBbPGMxMjZlOTU1Pl0gX19wcmFu
ZG9tX3Jlc2VlZCsweDU1LzB4ZDAKWyAgMjAxLjU2NjQ1NF0gIFs8YzEyNDhjNjc+XSA/IHJh
aWQ2X3Rlc3QrMHgxMDcvMHgxMjAKWyAgMjAxLjU2NjQ1NF0gIFs8YzFkZDNlMWU+XSA/IHBy
YW5kb21faW5pdCsweDEzYS8weDEzYQpbICAyMDEuNTY2NDU0XSAgWzxjMWRkM2UyOD5dIHBy
YW5kb21fcmVzZWVkKzB4YS8weDNlClsgIDIwMS41NjY0NTRdICBbPGMxMDAwNDZhPl0gZG9f
b25lX2luaXRjYWxsKzB4Y2EvMHgxOTAKWyAgMjAxLjU2NjQ1NF0gIFs8YzEyNmQxN2Q+XSA/
IHN0cmxlbisweGQvMHgyMApbICAyMDEuNTY2NDU0XSAgWzxjMTA0ODQxMz5dID8gcGFyYW1l
cSsweDEzLzB4NzAKWyAgMjAxLjU2NjQ1NF0gIFs8YzFkYjc1MDA+XSA/IHJlcGFpcl9lbnZf
c3RyaW5nKzB4ZS8weDUxClsgIDIwMS41NjY0NTRdICBbPGMxMDQ4NmE5Pl0gPyBwYXJzZV9h
cmdzKzB4MjM5LzB4NDIwClsgIDIwMS41NjY0NTRdICBbPGMxZGI3YzE4Pl0ga2VybmVsX2lu
aXRfZnJlZWFibGUrMHgxODMvMHgyMWEKWyAgMjAxLjU2NjQ1NF0gIFs8YzFkYjc0ZjI+XSA/
IGRvX2Vhcmx5X3BhcmFtKzB4NzgvMHg3OApbICAyMDEuNTY2NDU0XSAgWzxjMTg0NGI1Yj5d
IGtlcm5lbF9pbml0KzB4Yi8weGQwClsgIDIwMS41NjY0NTRdICBbPGMxMDUyYzUyPl0gPyBz
Y2hlZHVsZV90YWlsKzB4MTIvMHg0MApbICAyMDEuNTY2NDU0XSAgWzxjMTg1ZGM4MD5dIHJl
dF9mcm9tX2tlcm5lbF90aHJlYWQrMHgyMC8weDMwClsgIDIwMS41NjY0NTRdICBbPGMxODQ0
YjUwPl0gPyByZXN0X2luaXQrMHhjMC8weGMwClsgIDIwMS41NjY0NTRdIHJhbmRvbTogbm9u
YmxvY2tpbmcgcG9vbCBpcyBpbml0aWFsaXplZAoKRWxhcHNlZCB0aW1lOiAyMTUKL2tlcm5l
bC9pMzg2LXJhbmRjb25maWctZmIwLTA0MDMxNDE5LzRiMjJlZmRkNTU5NWYwYWNiNDhmMDJi
ZjY2NGE0NTFlZTk4ZjlhMmUvZG1lc2ctcXVhbnRhbC1mMi05NDoyMDE0MDQwNDExMzI1NTpp
Mzg2LXJhbmRjb25maWctZmIwLTA0MDMxNDE5OjMuMTQuMC1uZXh0LTIwMTQwNDAzOjEKL2tl
cm5lbC9pMzg2LXJhbmRjb25maWctZmIwLTA0MDMxNDE5LzRiMjJlZmRkNTU5NWYwYWNiNDhm
MDJiZjY2NGE0NTFlZTk4ZjlhMmUvZG1lc2cteW9jdG8tbGtwLWliMDQtNDQ6MjAxNDA0MDMx
NTQyNTY6aTM4Ni1yYW5kY29uZmlnLWZiMC0wNDAzMTQxOTozLjE0LjAtbmV4dC0yMDE0MDQw
MzoxCi9rZXJuZWwvaTM4Ni1yYW5kY29uZmlnLWZiMC0wNDAzMTQxOS80YjIyZWZkZDU1OTVm
MGFjYjQ4ZjAyYmY2NjRhNDUxZWU5OGY5YTJlL2RtZXNnLXF1YW50YWwtbGtwLWliMDQtMjQ6
MjAxNDA0MDMxNTI2MjI6aTM4Ni1yYW5kY29uZmlnLWZiMC0wNDAzMTQxOTozLjE0LjAtbmV4
dC0yMDE0MDQwMzoxCi9rZXJuZWwvaTM4Ni1yYW5kY29uZmlnLWZiMC0wNDAzMTQxOS80YjIy
ZWZkZDU1OTVmMGFjYjQ4ZjAyYmY2NjRhNDUxZWU5OGY5YTJlL2RtZXNnLXF1YW50YWwtamFr
ZXRvd24tMzg6MjAxNDA0MDQxMTQxMjk6aTM4Ni1yYW5kY29uZmlnLWZiMC0wNDAzMTQxOTo6
Ci9rZXJuZWwvaTM4Ni1yYW5kY29uZmlnLWZiMC0wNDAzMTQxOS80YjIyZWZkZDU1OTVmMGFj
YjQ4ZjAyYmY2NjRhNDUxZWU5OGY5YTJlL2RtZXNnLXF1YW50YWwtZjItMTEwOjIwMTQwNDA0
MTEzMjU1OmkzODYtcmFuZGNvbmZpZy1mYjAtMDQwMzE0MTk6My4xNC4wLW5leHQtMjAxNDA0
MDM6MQoxNjo1OjcgYWxsX2dvb2Q6YmFkOmFsbF9iYWQgYm9vdHMKCg==

--ZPt4rx8FFjLCG7dd
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="config-3.13.0-00009-g11e9ee9"

#
# Automatically generated file; DO NOT EDIT.
# Linux/i386 3.13.0 Kernel Configuration
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
CONFIG_KERNEL_XZ=y
# CONFIG_KERNEL_LZO is not set
# CONFIG_KERNEL_LZ4 is not set
CONFIG_DEFAULT_HOSTNAME="(none)"
CONFIG_SWAP=y
CONFIG_SYSVIPC=y
CONFIG_SYSVIPC_SYSCTL=y
# CONFIG_POSIX_MQUEUE is not set
# CONFIG_FHANDLE is not set
CONFIG_AUDIT=y
# CONFIG_AUDITSYSCALL is not set

#
# IRQ subsystem
#
CONFIG_GENERIC_IRQ_PROBE=y
CONFIG_GENERIC_IRQ_SHOW=y
CONFIG_GENERIC_IRQ_CHIP=y
CONFIG_IRQ_DOMAIN=y
# CONFIG_IRQ_DOMAIN_DEBUG is not set
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
CONFIG_HZ_PERIODIC=y
# CONFIG_NO_HZ_IDLE is not set
CONFIG_NO_HZ=y
CONFIG_HIGH_RES_TIMERS=y

#
# CPU/Task time and stats accounting
#
# CONFIG_TICK_CPU_ACCOUNTING is not set
CONFIG_IRQ_TIME_ACCOUNTING=y
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
# CONFIG_IKCONFIG_PROC is not set
CONFIG_LOG_BUF_SHIFT=17
CONFIG_HAVE_UNSTABLE_SCHED_CLOCK=y
CONFIG_ARCH_SUPPORTS_NUMA_BALANCING=y
CONFIG_ARCH_WANTS_PROT_NUMA_PROT_NONE=y
CONFIG_CGROUPS=y
CONFIG_CGROUP_DEBUG=y
CONFIG_CGROUP_FREEZER=y
# CONFIG_CGROUP_DEVICE is not set
CONFIG_CPUSETS=y
# CONFIG_PROC_PID_CPUSET is not set
# CONFIG_CGROUP_CPUACCT is not set
CONFIG_RESOURCE_COUNTERS=y
# CONFIG_MEMCG is not set
# CONFIG_CGROUP_PERF is not set
CONFIG_CGROUP_SCHED=y
CONFIG_FAIR_GROUP_SCHED=y
# CONFIG_CFS_BANDWIDTH is not set
CONFIG_RT_GROUP_SCHED=y
# CONFIG_BLK_CGROUP is not set
# CONFIG_CHECKPOINT_RESTORE is not set
CONFIG_NAMESPACES=y
CONFIG_UTS_NS=y
CONFIG_IPC_NS=y
# CONFIG_USER_NS is not set
# CONFIG_PID_NS is not set
CONFIG_NET_NS=y
# CONFIG_UIDGID_STRICT_TYPE_CHECKS is not set
CONFIG_SCHED_AUTOGROUP=y
# CONFIG_SYSFS_DEPRECATED is not set
# CONFIG_RELAY is not set
CONFIG_BLK_DEV_INITRD=y
CONFIG_INITRAMFS_SOURCE=""
CONFIG_RD_GZIP=y
CONFIG_RD_BZIP2=y
CONFIG_RD_LZMA=y
CONFIG_RD_XZ=y
CONFIG_RD_LZO=y
CONFIG_RD_LZ4=y
# CONFIG_CC_OPTIMIZE_FOR_SIZE is not set
CONFIG_SYSCTL=y
CONFIG_ANON_INODES=y
CONFIG_HAVE_UID16=y
CONFIG_SYSCTL_EXCEPTION_TRACE=y
CONFIG_HAVE_PCSPKR_PLATFORM=y
# CONFIG_EXPERT is not set
CONFIG_UID16=y
# CONFIG_SYSCTL_SYSCALL is not set
CONFIG_KALLSYMS=y
CONFIG_KALLSYMS_ALL=y
CONFIG_PRINTK=y
CONFIG_BUG=y
CONFIG_ELF_CORE=y
CONFIG_PCSPKR_PLATFORM=y
CONFIG_BASE_FULL=y
CONFIG_FUTEX=y
CONFIG_EPOLL=y
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
CONFIG_VM_EVENT_COUNTERS=y
CONFIG_SLUB_DEBUG=y
# CONFIG_COMPAT_BRK is not set
# CONFIG_SLAB is not set
CONFIG_SLUB=y
# CONFIG_PROFILING is not set
CONFIG_HAVE_OPROFILE=y
CONFIG_OPROFILE_NMI_TIMER=y
CONFIG_KPROBES=y
CONFIG_JUMP_LABEL=y
CONFIG_OPTPROBES=y
# CONFIG_HAVE_64BIT_ALIGNED_ACCESS is not set
CONFIG_HAVE_EFFICIENT_UNALIGNED_ACCESS=y
CONFIG_ARCH_USE_BUILTIN_BSWAP=y
CONFIG_KRETPROBES=y
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
CONFIG_SLABINFO=y
CONFIG_RT_MUTEXES=y
CONFIG_BASE_SMALL=0
CONFIG_SYSTEM_TRUSTED_KEYRING=y
CONFIG_MODULES=y
# CONFIG_MODULE_FORCE_LOAD is not set
CONFIG_MODULE_UNLOAD=y
CONFIG_MODULE_FORCE_UNLOAD=y
CONFIG_MODVERSIONS=y
# CONFIG_MODULE_SRCVERSION_ALL is not set
CONFIG_MODULE_SIG=y
# CONFIG_MODULE_SIG_FORCE is not set
# CONFIG_MODULE_SIG_ALL is not set
# CONFIG_MODULE_SIG_SHA1 is not set
# CONFIG_MODULE_SIG_SHA224 is not set
# CONFIG_MODULE_SIG_SHA256 is not set
CONFIG_MODULE_SIG_SHA384=y
# CONFIG_MODULE_SIG_SHA512 is not set
CONFIG_MODULE_SIG_HASH="sha384"
CONFIG_BLOCK=y
# CONFIG_LBDAF is not set
CONFIG_BLK_DEV_BSG=y
CONFIG_BLK_DEV_BSGLIB=y
CONFIG_BLK_DEV_INTEGRITY=y
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
# CONFIG_IOSCHED_DEADLINE is not set
CONFIG_IOSCHED_CFQ=y
# CONFIG_DEFAULT_CFQ is not set
CONFIG_DEFAULT_NOOP=y
CONFIG_DEFAULT_IOSCHED="noop"
CONFIG_ASN1=y
CONFIG_UNINLINE_SPIN_UNLOCK=y
CONFIG_FREEZER=y

#
# Processor type and features
#
CONFIG_ZONE_DMA=y
# CONFIG_SMP is not set
CONFIG_X86_MPPARSE=y
CONFIG_GOLDFISH=y
CONFIG_X86_EXTENDED_PLATFORM=y
CONFIG_X86_GOLDFISH=y
# CONFIG_X86_WANT_INTEL_MID is not set
# CONFIG_X86_INTEL_LPSS is not set
CONFIG_X86_RDC321X=y
# CONFIG_X86_32_IRIS is not set
# CONFIG_SCHED_OMIT_FRAME_POINTER is not set
CONFIG_HYPERVISOR_GUEST=y
CONFIG_PARAVIRT=y
# CONFIG_PARAVIRT_DEBUG is not set
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
CONFIG_MPENTIUMIII=y
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
CONFIG_X86_INTEL_USERCOPY=y
CONFIG_X86_USE_PPRO_CHECKSUM=y
CONFIG_X86_TSC=y
CONFIG_X86_CMPXCHG64=y
CONFIG_X86_CMOV=y
CONFIG_X86_MINIMUM_CPU_FAMILY=5
CONFIG_X86_DEBUGCTLMSR=y
CONFIG_CPU_SUP_INTEL=y
CONFIG_CPU_SUP_AMD=y
CONFIG_CPU_SUP_CENTAUR=y
CONFIG_CPU_SUP_TRANSMETA_32=y
CONFIG_HPET_TIMER=y
CONFIG_HPET_EMULATE_RTC=y
CONFIG_DMI=y
CONFIG_NR_CPUS=1
CONFIG_PREEMPT_NONE=y
# CONFIG_PREEMPT_VOLUNTARY is not set
# CONFIG_PREEMPT is not set
CONFIG_PREEMPT_COUNT=y
CONFIG_X86_LOCAL_APIC=y
CONFIG_X86_IO_APIC=y
CONFIG_X86_REROUTE_FOR_BROKEN_BOOT_IRQS=y
# CONFIG_X86_MCE is not set
CONFIG_VM86=y
CONFIG_TOSHIBA=y
# CONFIG_I8K is not set
CONFIG_X86_REBOOTFIXUPS=y
# CONFIG_MICROCODE is not set
# CONFIG_MICROCODE_INTEL_EARLY is not set
# CONFIG_MICROCODE_AMD_EARLY is not set
CONFIG_X86_MSR=m
CONFIG_X86_CPUID=m
# CONFIG_NOHIGHMEM is not set
CONFIG_HIGHMEM4G=y
# CONFIG_HIGHMEM64G is not set
CONFIG_PAGE_OFFSET=0xC0000000
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
# CONFIG_TRANSPARENT_HUGEPAGE is not set
# CONFIG_CROSS_MEMORY_ATTACH is not set
CONFIG_NEED_PER_CPU_KM=y
CONFIG_CLEANCACHE=y
# CONFIG_FRONTSWAP is not set
CONFIG_CMA=y
# CONFIG_CMA_DEBUG is not set
# CONFIG_ZBUD is not set
CONFIG_HIGHPTE=y
CONFIG_X86_CHECK_BIOS_CORRUPTION=y
# CONFIG_X86_BOOTPARAM_MEMORY_CORRUPTION_CHECK is not set
CONFIG_X86_RESERVE_LOW=64
CONFIG_MATH_EMULATION=y
CONFIG_MTRR=y
# CONFIG_MTRR_SANITIZER is not set
CONFIG_X86_PAT=y
CONFIG_ARCH_USES_PG_UNCACHED=y
CONFIG_ARCH_RANDOM=y
CONFIG_X86_SMAP=y
# CONFIG_EFI is not set
CONFIG_SECCOMP=y
CONFIG_CC_STACKPROTECTOR=y
CONFIG_HZ_100=y
# CONFIG_HZ_250 is not set
# CONFIG_HZ_300 is not set
# CONFIG_HZ_1000 is not set
CONFIG_HZ=100
CONFIG_SCHED_HRTICK=y
# CONFIG_KEXEC is not set
CONFIG_CRASH_DUMP=y
CONFIG_PHYSICAL_START=0x1000000
# CONFIG_RELOCATABLE is not set
CONFIG_PHYSICAL_ALIGN=0x200000
CONFIG_COMPAT_VDSO=y
# CONFIG_CMDLINE_BOOL is not set
CONFIG_ARCH_ENABLE_MEMORY_HOTPLUG=y

#
# Power management and ACPI options
#
# CONFIG_SUSPEND is not set
CONFIG_HIBERNATE_CALLBACKS=y
CONFIG_HIBERNATION=y
CONFIG_PM_STD_PARTITION=""
CONFIG_PM_SLEEP=y
# CONFIG_PM_AUTOSLEEP is not set
CONFIG_PM_WAKELOCKS=y
CONFIG_PM_WAKELOCKS_LIMIT=100
CONFIG_PM_WAKELOCKS_GC=y
CONFIG_PM_RUNTIME=y
CONFIG_PM=y
CONFIG_PM_DEBUG=y
# CONFIG_PM_ADVANCED_DEBUG is not set
CONFIG_PM_SLEEP_DEBUG=y
# CONFIG_PM_TRACE_RTC is not set
CONFIG_WQ_POWER_EFFICIENT_DEFAULT=y
CONFIG_ACPI=y
CONFIG_ACPI_SLEEP=y
# CONFIG_ACPI_PROCFS is not set
# CONFIG_ACPI_EC_DEBUGFS is not set
CONFIG_ACPI_AC=y
CONFIG_ACPI_BATTERY=y
CONFIG_ACPI_BUTTON=y
CONFIG_ACPI_VIDEO=y
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
# CONFIG_SFI is not set
# CONFIG_APM is not set

#
# CPU Frequency scaling
#
# CONFIG_CPU_FREQ is not set

#
# CPU Idle
#
CONFIG_CPU_IDLE=y
CONFIG_CPU_IDLE_MULTIPLE_DRIVERS=y
# CONFIG_CPU_IDLE_GOV_LADDER is not set
CONFIG_CPU_IDLE_GOV_MENU=y
# CONFIG_ARCH_NEEDS_CPU_IDLE_COUPLED is not set
CONFIG_INTEL_IDLE=y

#
# Bus options (PCI etc.)
#
CONFIG_PCI=y
# CONFIG_PCI_GOBIOS is not set
CONFIG_PCI_GOMMCONFIG=y
# CONFIG_PCI_GODIRECT is not set
# CONFIG_PCI_GOANY is not set
CONFIG_PCI_DIRECT=y
CONFIG_PCI_MMCONFIG=y
CONFIG_PCI_DOMAINS=y
# CONFIG_PCIEPORTBUS is not set
CONFIG_PCI_MSI=y
# CONFIG_PCI_DEBUG is not set
# CONFIG_PCI_REALLOC_ENABLE_AUTO is not set
CONFIG_PCI_STUB=m
# CONFIG_HT_IRQ is not set
CONFIG_PCI_ATS=y
# CONFIG_PCI_IOV is not set
# CONFIG_PCI_PRI is not set
CONFIG_PCI_PASID=y
# CONFIG_PCI_IOAPIC is not set
CONFIG_PCI_LABEL=y

#
# PCI host controller drivers
#
CONFIG_ISA_DMA_API=y
CONFIG_ISA=y
# CONFIG_EISA is not set
CONFIG_SCx200=y
CONFIG_SCx200HR_TIMER=m
# CONFIG_OLPC is not set
CONFIG_ALIX=y
# CONFIG_NET5501 is not set
# CONFIG_GEOS is not set
CONFIG_AMD_NB=y
CONFIG_PCCARD=y
CONFIG_PCMCIA=y
# CONFIG_PCMCIA_LOAD_CIS is not set
CONFIG_CARDBUS=y

#
# PC-card bridges
#
CONFIG_YENTA=y
CONFIG_YENTA_O2=y
CONFIG_YENTA_RICOH=y
CONFIG_YENTA_TI=y
CONFIG_YENTA_ENE_TUNE=y
CONFIG_YENTA_TOSHIBA=y
CONFIG_PD6729=y
# CONFIG_I82092 is not set
CONFIG_I82365=m
CONFIG_TCIC=y
CONFIG_PCMCIA_PROBE=y
CONFIG_PCCARD_NONSTATIC=y
CONFIG_HOTPLUG_PCI=y
# CONFIG_HOTPLUG_PCI_ACPI is not set
CONFIG_HOTPLUG_PCI_CPCI=y
# CONFIG_HOTPLUG_PCI_CPCI_ZT5550 is not set
# CONFIG_HOTPLUG_PCI_CPCI_GENERIC is not set
CONFIG_HOTPLUG_PCI_SHPC=m
CONFIG_RAPIDIO=m
CONFIG_RAPIDIO_DISC_TIMEOUT=30
CONFIG_RAPIDIO_ENABLE_RX_TX_PORTS=y
# CONFIG_RAPIDIO_DMA_ENGINE is not set
CONFIG_RAPIDIO_DEBUG=y
CONFIG_RAPIDIO_ENUM_BASIC=m

#
# RapidIO Switch drivers
#
CONFIG_RAPIDIO_TSI57X=m
CONFIG_RAPIDIO_CPS_XX=m
CONFIG_RAPIDIO_TSI568=m
CONFIG_RAPIDIO_CPS_GEN2=m
CONFIG_X86_SYSFB=y

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
CONFIG_XFRM_ALGO=m
CONFIG_XFRM_SUB_POLICY=y
CONFIG_XFRM_MIGRATE=y
CONFIG_NET_KEY=m
CONFIG_NET_KEY_MIGRATE=y
# CONFIG_INET is not set
# CONFIG_NETWORK_SECMARK is not set
CONFIG_NETWORK_PHY_TIMESTAMPING=y
CONFIG_NETFILTER=y
# CONFIG_NETFILTER_DEBUG is not set
# CONFIG_NETFILTER_ADVANCED is not set
CONFIG_NETFILTER_XTABLES=y
CONFIG_BRIDGE_NF_EBTABLES=y
# CONFIG_BRIDGE_EBT_BROUTE is not set
CONFIG_BRIDGE_EBT_T_FILTER=y
CONFIG_BRIDGE_EBT_T_NAT=y
CONFIG_BRIDGE_EBT_802_3=y
# CONFIG_BRIDGE_EBT_AMONG is not set
CONFIG_BRIDGE_EBT_ARP=y
# CONFIG_BRIDGE_EBT_IP is not set
# CONFIG_BRIDGE_EBT_LIMIT is not set
CONFIG_BRIDGE_EBT_MARK=y
# CONFIG_BRIDGE_EBT_PKTTYPE is not set
CONFIG_BRIDGE_EBT_STP=m
# CONFIG_BRIDGE_EBT_VLAN is not set
CONFIG_BRIDGE_EBT_DNAT=y
# CONFIG_BRIDGE_EBT_MARK_T is not set
CONFIG_BRIDGE_EBT_REDIRECT=m
CONFIG_BRIDGE_EBT_SNAT=m
CONFIG_BRIDGE_EBT_LOG=y
CONFIG_BRIDGE_EBT_ULOG=m
CONFIG_BRIDGE_EBT_NFLOG=y
# CONFIG_ATM is not set
CONFIG_STP=y
CONFIG_BRIDGE=y
CONFIG_BRIDGE_VLAN_FILTERING=y
CONFIG_VLAN_8021Q=y
# CONFIG_VLAN_8021Q_GVRP is not set
# CONFIG_VLAN_8021Q_MVRP is not set
CONFIG_DECNET=y
# CONFIG_DECNET_ROUTER is not set
CONFIG_LLC=y
# CONFIG_LLC2 is not set
CONFIG_IPX=m
# CONFIG_IPX_INTERN is not set
CONFIG_ATALK=y
CONFIG_DEV_APPLETALK=m
CONFIG_LTPC=m
# CONFIG_COPS is not set
CONFIG_IPDDP=m
# CONFIG_IPDDP_ENCAP is not set
CONFIG_X25=m
# CONFIG_LAPB is not set
CONFIG_PHONET=y
CONFIG_IEEE802154=y
# CONFIG_MAC802154 is not set
CONFIG_NET_SCHED=y

#
# Queueing/Scheduling
#
CONFIG_NET_SCH_CBQ=y
CONFIG_NET_SCH_HTB=y
CONFIG_NET_SCH_HFSC=y
CONFIG_NET_SCH_PRIO=y
# CONFIG_NET_SCH_MULTIQ is not set
CONFIG_NET_SCH_RED=y
CONFIG_NET_SCH_SFB=m
CONFIG_NET_SCH_SFQ=y
# CONFIG_NET_SCH_TEQL is not set
# CONFIG_NET_SCH_TBF is not set
CONFIG_NET_SCH_GRED=m
CONFIG_NET_SCH_DSMARK=m
CONFIG_NET_SCH_NETEM=y
CONFIG_NET_SCH_DRR=m
# CONFIG_NET_SCH_MQPRIO is not set
CONFIG_NET_SCH_CHOKE=y
CONFIG_NET_SCH_QFQ=y
CONFIG_NET_SCH_CODEL=y
CONFIG_NET_SCH_FQ_CODEL=y
CONFIG_NET_SCH_FQ=y
CONFIG_NET_SCH_INGRESS=y
# CONFIG_NET_SCH_PLUG is not set

#
# Classification
#
CONFIG_NET_CLS=y
# CONFIG_NET_CLS_BASIC is not set
CONFIG_NET_CLS_TCINDEX=m
# CONFIG_NET_CLS_FW is not set
# CONFIG_NET_CLS_U32 is not set
CONFIG_NET_CLS_RSVP=m
# CONFIG_NET_CLS_RSVP6 is not set
CONFIG_NET_CLS_FLOW=m
CONFIG_NET_CLS_CGROUP=y
CONFIG_NET_CLS_BPF=m
CONFIG_NET_EMATCH=y
CONFIG_NET_EMATCH_STACK=32
# CONFIG_NET_EMATCH_CMP is not set
CONFIG_NET_EMATCH_NBYTE=m
CONFIG_NET_EMATCH_U32=y
CONFIG_NET_EMATCH_META=y
# CONFIG_NET_EMATCH_TEXT is not set
# CONFIG_NET_EMATCH_CANID is not set
CONFIG_NET_CLS_ACT=y
CONFIG_NET_ACT_POLICE=m
CONFIG_NET_ACT_GACT=y
# CONFIG_GACT_PROB is not set
CONFIG_NET_ACT_MIRRED=m
# CONFIG_NET_ACT_NAT is not set
CONFIG_NET_ACT_PEDIT=m
CONFIG_NET_ACT_SIMP=y
CONFIG_NET_ACT_SKBEDIT=m
CONFIG_NET_SCH_FIFO=y
CONFIG_DCB=y
CONFIG_DNS_RESOLVER=y
# CONFIG_BATMAN_ADV is not set
CONFIG_OPENVSWITCH=m
CONFIG_VSOCKETS=m
CONFIG_NETLINK_MMAP=y
CONFIG_NETLINK_DIAG=m
CONFIG_NET_MPLS_GSO=y
# CONFIG_HSR is not set
# CONFIG_NETPRIO_CGROUP is not set
CONFIG_NET_RX_BUSY_POLL=y
CONFIG_BQL=y

#
# Network testing
#
# CONFIG_HAMRADIO is not set
CONFIG_CAN=y
CONFIG_CAN_RAW=y
CONFIG_CAN_BCM=m
# CONFIG_CAN_GW is not set

#
# CAN Device Drivers
#
CONFIG_CAN_VCAN=m
CONFIG_CAN_SLCAN=m
CONFIG_CAN_DEV=y
CONFIG_CAN_CALC_BITTIMING=y
CONFIG_CAN_LEDS=y
CONFIG_CAN_MCP251X=m
CONFIG_CAN_JANZ_ICAN3=m
# CONFIG_PCH_CAN is not set
# CONFIG_CAN_SJA1000 is not set
# CONFIG_CAN_C_CAN is not set
CONFIG_CAN_CC770=m
# CONFIG_CAN_CC770_ISA is not set
CONFIG_CAN_CC770_PLATFORM=m

#
# CAN USB interfaces
#
# CONFIG_CAN_EMS_USB is not set
CONFIG_CAN_ESD_USB2=y
CONFIG_CAN_KVASER_USB=m
CONFIG_CAN_PEAK_USB=y
CONFIG_CAN_8DEV_USB=m
# CONFIG_CAN_SOFTING is not set
# CONFIG_CAN_DEBUG_DEVICES is not set
CONFIG_IRDA=m

#
# IrDA protocols
#
CONFIG_IRLAN=m
CONFIG_IRCOMM=m
CONFIG_IRDA_ULTRA=y

#
# IrDA options
#
CONFIG_IRDA_CACHE_LAST_LSAP=y
# CONFIG_IRDA_FAST_RR is not set
# CONFIG_IRDA_DEBUG is not set

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
CONFIG_KINGSUN_DONGLE=m
CONFIG_KSDAZZLE_DONGLE=m
CONFIG_KS959_DONGLE=m

#
# FIR device drivers
#
# CONFIG_USB_IRDA is not set
# CONFIG_SIGMATEL_FIR is not set
# CONFIG_NSC_FIR is not set
CONFIG_WINBOND_FIR=m
CONFIG_TOSHIBA_FIR=m
# CONFIG_SMC_IRCC_FIR is not set
CONFIG_ALI_FIR=m
# CONFIG_VLSI_FIR is not set
CONFIG_VIA_FIR=m
# CONFIG_MCS_FIR is not set
CONFIG_BT=y
# CONFIG_BT_RFCOMM is not set
# CONFIG_BT_BNEP is not set
CONFIG_BT_HIDP=m

#
# Bluetooth device drivers
#
CONFIG_BT_HCIBTUSB=y
# CONFIG_BT_HCIBTSDIO is not set
CONFIG_BT_HCIUART=m
# CONFIG_BT_HCIUART_H4 is not set
# CONFIG_BT_HCIUART_BCSP is not set
CONFIG_BT_HCIUART_ATH3K=y
CONFIG_BT_HCIUART_LL=y
# CONFIG_BT_HCIUART_3WIRE is not set
CONFIG_BT_HCIBCM203X=m
CONFIG_BT_HCIBPA10X=y
CONFIG_BT_HCIBFUSB=y
# CONFIG_BT_HCIDTL1 is not set
CONFIG_BT_HCIBT3C=m
CONFIG_BT_HCIBLUECARD=m
CONFIG_BT_HCIBTUART=m
# CONFIG_BT_HCIVHCI is not set
# CONFIG_BT_MRVL is not set
CONFIG_BT_ATH3K=m
CONFIG_BT_WILINK=m
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
CONFIG_RFKILL_REGULATOR=y
CONFIG_RFKILL_GPIO=y
CONFIG_NET_9P=y
# CONFIG_NET_9P_VIRTIO is not set
# CONFIG_NET_9P_DEBUG is not set
CONFIG_CAIF=m
# CONFIG_CAIF_DEBUG is not set
CONFIG_CAIF_NETDEV=m
CONFIG_CAIF_USB=m
CONFIG_NFC=m
CONFIG_NFC_DIGITAL=m
CONFIG_NFC_NCI=m
# CONFIG_NFC_NCI_SPI is not set
# CONFIG_NFC_HCI is not set

#
# Near Field Communication (NFC) devices
#
CONFIG_NFC_PN533=m
CONFIG_NFC_WILINK=m
CONFIG_NFC_SIM=m
CONFIG_NFC_PORT100=m

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
# CONFIG_FIRMWARE_IN_KERNEL is not set
CONFIG_EXTRA_FIRMWARE=""
CONFIG_FW_LOADER_USER_HELPER=y
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
CONFIG_MTD_TESTS=m
# CONFIG_MTD_REDBOOT_PARTS is not set
# CONFIG_MTD_CMDLINE_PARTS is not set
# CONFIG_MTD_AR7_PARTS is not set

#
# User Modules And Translation Layers
#
CONFIG_MTD_BLKDEVS=y
# CONFIG_MTD_BLOCK is not set
CONFIG_MTD_BLOCK_RO=y
# CONFIG_FTL is not set
CONFIG_NFTL=y
# CONFIG_NFTL_RW is not set
CONFIG_INFTL=y
CONFIG_RFD_FTL=m
# CONFIG_SSFDC is not set
CONFIG_SM_FTL=m
# CONFIG_MTD_OOPS is not set
CONFIG_MTD_SWAP=y

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
CONFIG_MTD_OTP=y
CONFIG_MTD_CFI_INTELEXT=y
CONFIG_MTD_CFI_AMDSTD=y
# CONFIG_MTD_CFI_STAA is not set
CONFIG_MTD_CFI_UTIL=y
CONFIG_MTD_RAM=y
CONFIG_MTD_ROM=y
CONFIG_MTD_ABSENT=m

#
# Mapping drivers for chip access
#
CONFIG_MTD_COMPLEX_MAPPINGS=y
# CONFIG_MTD_PHYSMAP is not set
# CONFIG_MTD_SC520CDP is not set
# CONFIG_MTD_NETSC520 is not set
# CONFIG_MTD_TS5500 is not set
CONFIG_MTD_SBC_GXX=m
# CONFIG_MTD_SCx200_DOCFLASH is not set
# CONFIG_MTD_AMD76XROM is not set
CONFIG_MTD_ICHXROM=m
CONFIG_MTD_ESB2ROM=m
# CONFIG_MTD_CK804XROM is not set
CONFIG_MTD_SCB2_FLASH=y
# CONFIG_MTD_NETtel is not set
CONFIG_MTD_L440GX=m
# CONFIG_MTD_PCI is not set
CONFIG_MTD_PCMCIA=y
# CONFIG_MTD_PCMCIA_ANONYMOUS is not set
CONFIG_MTD_GPIO_ADDR=m
CONFIG_MTD_INTEL_VR_NOR=y
CONFIG_MTD_PLATRAM=y
# CONFIG_MTD_LATCH_ADDR is not set

#
# Self-contained MTD device drivers
#
CONFIG_MTD_PMC551=y
# CONFIG_MTD_PMC551_BUGFIX is not set
CONFIG_MTD_PMC551_DEBUG=y
CONFIG_MTD_DATAFLASH=m
# CONFIG_MTD_DATAFLASH_WRITE_VERIFY is not set
CONFIG_MTD_DATAFLASH_OTP=y
# CONFIG_MTD_M25P80 is not set
# CONFIG_MTD_SST25L is not set
CONFIG_MTD_SLRAM=y
CONFIG_MTD_PHRAM=y
# CONFIG_MTD_MTDRAM is not set
CONFIG_MTD_BLOCK2MTD=m

#
# Disk-On-Chip Device Drivers
#
# CONFIG_MTD_DOCG3 is not set
CONFIG_MTD_NAND_ECC=y
CONFIG_MTD_NAND_ECC_SMC=y
CONFIG_MTD_NAND=y
CONFIG_MTD_NAND_BCH=y
CONFIG_MTD_NAND_ECC_BCH=y
# CONFIG_MTD_SM_COMMON is not set
CONFIG_MTD_NAND_DENALI=m
CONFIG_MTD_NAND_DENALI_PCI=m
CONFIG_MTD_NAND_DENALI_SCRATCH_REG_ADDR=0xFF108018
CONFIG_MTD_NAND_GPIO=m
CONFIG_MTD_NAND_IDS=y
# CONFIG_MTD_NAND_RICOH is not set
CONFIG_MTD_NAND_DISKONCHIP=m
# CONFIG_MTD_NAND_DISKONCHIP_PROBE_ADVANCED is not set
CONFIG_MTD_NAND_DISKONCHIP_PROBE_ADDRESS=0
# CONFIG_MTD_NAND_DISKONCHIP_BBTWRITE is not set
# CONFIG_MTD_NAND_DOCG4 is not set
# CONFIG_MTD_NAND_CAFE is not set
CONFIG_MTD_NAND_CS553X=y
# CONFIG_MTD_NAND_NANDSIM is not set
# CONFIG_MTD_NAND_PLATFORM is not set
CONFIG_MTD_ONENAND=m
CONFIG_MTD_ONENAND_VERIFY_WRITE=y
CONFIG_MTD_ONENAND_GENERIC=m
# CONFIG_MTD_ONENAND_OTP is not set
CONFIG_MTD_ONENAND_2X_PROGRAM=y

#
# LPDDR flash memory drivers
#
CONFIG_MTD_LPDDR=m
CONFIG_MTD_QINFO_PROBE=m
# CONFIG_MTD_UBI is not set
# CONFIG_PARPORT is not set
CONFIG_ARCH_MIGHT_HAVE_PC_PARPORT=y
CONFIG_PNP=y
# CONFIG_PNP_DEBUG_MESSAGES is not set

#
# Protocols
#
CONFIG_ISAPNP=y
CONFIG_PNPBIOS=y
CONFIG_PNPBIOS_PROC_FS=y
CONFIG_PNPACPI=y
CONFIG_BLK_DEV=y
CONFIG_BLK_DEV_NULL_BLK=y
# CONFIG_BLK_DEV_FD is not set
# CONFIG_BLK_DEV_PCIESSD_MTIP32XX is not set
CONFIG_BLK_CPQ_CISS_DA=m
CONFIG_BLK_DEV_DAC960=y
# CONFIG_BLK_DEV_UMEM is not set
# CONFIG_BLK_DEV_COW_COMMON is not set
CONFIG_BLK_DEV_LOOP=y
CONFIG_BLK_DEV_LOOP_MIN_COUNT=8
CONFIG_BLK_DEV_CRYPTOLOOP=m

#
# DRBD disabled because PROC_FS or INET not selected
#
# CONFIG_BLK_DEV_NBD is not set
# CONFIG_BLK_DEV_NVME is not set
CONFIG_BLK_DEV_SX8=m
CONFIG_BLK_DEV_RAM=m
CONFIG_BLK_DEV_RAM_COUNT=16
CONFIG_BLK_DEV_RAM_SIZE=4096
# CONFIG_BLK_DEV_XIP is not set
CONFIG_CDROM_PKTCDVD=y
CONFIG_CDROM_PKTCDVD_BUFFERS=8
CONFIG_CDROM_PKTCDVD_WCACHE=y
# CONFIG_ATA_OVER_ETH is not set
# CONFIG_VIRTIO_BLK is not set
CONFIG_BLK_DEV_HD=y
CONFIG_BLK_DEV_RSXX=m

#
# Misc devices
#
# CONFIG_SENSORS_LIS3LV02D is not set
# CONFIG_AD525X_DPOT is not set
CONFIG_DUMMY_IRQ=m
CONFIG_IBM_ASM=y
CONFIG_PHANTOM=m
# CONFIG_INTEL_MID_PTI is not set
CONFIG_SGI_IOC4=m
# CONFIG_TIFM_CORE is not set
# CONFIG_ICS932S401 is not set
CONFIG_ATMEL_SSC=m
CONFIG_ENCLOSURE_SERVICES=m
CONFIG_HP_ILO=y
CONFIG_APDS9802ALS=m
CONFIG_ISL29003=m
CONFIG_ISL29020=m
CONFIG_SENSORS_TSL2550=y
CONFIG_SENSORS_BH1780=y
# CONFIG_SENSORS_BH1770 is not set
# CONFIG_SENSORS_APDS990X is not set
CONFIG_HMC6352=m
# CONFIG_DS1682 is not set
CONFIG_TI_DAC7512=m
# CONFIG_VMWARE_BALLOON is not set
# CONFIG_BMP085_I2C is not set
# CONFIG_BMP085_SPI is not set
CONFIG_PCH_PHUB=y
# CONFIG_USB_SWITCH_FSA9480 is not set
CONFIG_LATTICE_ECP3_CONFIG=m
# CONFIG_SRAM is not set
CONFIG_C2PORT=m
# CONFIG_C2PORT_DURAMAR_2150 is not set

#
# EEPROM support
#
CONFIG_EEPROM_AT24=y
# CONFIG_EEPROM_AT25 is not set
CONFIG_EEPROM_LEGACY=y
# CONFIG_EEPROM_MAX6875 is not set
CONFIG_EEPROM_93CX6=y
CONFIG_EEPROM_93XX46=m
CONFIG_CB710_CORE=y
# CONFIG_CB710_DEBUG is not set
CONFIG_CB710_DEBUG_ASSUMPTIONS=y

#
# Texas Instruments shared transport line discipline
#
CONFIG_TI_ST=y
# CONFIG_SENSORS_LIS3_I2C is not set

#
# Altera FPGA firmware download module
#
CONFIG_ALTERA_STAPL=y
CONFIG_INTEL_MEI=y
CONFIG_INTEL_MEI_ME=m
# CONFIG_VMWARE_VMCI is not set

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
CONFIG_IDE_LEGACY=y
# CONFIG_BLK_DEV_IDE_SATA is not set
CONFIG_IDE_GD=m
# CONFIG_IDE_GD_ATA is not set
# CONFIG_IDE_GD_ATAPI is not set
CONFIG_BLK_DEV_IDECS=m
CONFIG_BLK_DEV_DELKIN=m
# CONFIG_BLK_DEV_IDECD is not set
CONFIG_BLK_DEV_IDETAPE=y
# CONFIG_BLK_DEV_IDEACPI is not set
CONFIG_IDE_TASK_IOCTL=y
CONFIG_IDE_PROC_FS=y

#
# IDE chipset support/bugfixes
#
CONFIG_IDE_GENERIC=m
CONFIG_BLK_DEV_PLATFORM=y
CONFIG_BLK_DEV_CMD640=m
# CONFIG_BLK_DEV_CMD640_ENHANCED is not set
CONFIG_BLK_DEV_IDEPNP=m
CONFIG_BLK_DEV_IDEDMA_SFF=y

#
# PCI IDE chipsets support
#
CONFIG_BLK_DEV_IDEPCI=y
# CONFIG_IDEPCI_PCIBUS_ORDER is not set
CONFIG_BLK_DEV_OFFBOARD=y
# CONFIG_BLK_DEV_GENERIC is not set
CONFIG_BLK_DEV_OPTI621=m
CONFIG_BLK_DEV_RZ1000=m
CONFIG_BLK_DEV_IDEDMA_PCI=y
# CONFIG_BLK_DEV_AEC62XX is not set
# CONFIG_BLK_DEV_ALI15X3 is not set
# CONFIG_BLK_DEV_AMD74XX is not set
CONFIG_BLK_DEV_ATIIXP=m
# CONFIG_BLK_DEV_CMD64X is not set
CONFIG_BLK_DEV_TRIFLEX=m
CONFIG_BLK_DEV_CS5520=y
CONFIG_BLK_DEV_CS5530=m
# CONFIG_BLK_DEV_CS5535 is not set
CONFIG_BLK_DEV_CS5536=m
# CONFIG_BLK_DEV_HPT366 is not set
CONFIG_BLK_DEV_JMICRON=m
CONFIG_BLK_DEV_SC1200=y
CONFIG_BLK_DEV_PIIX=m
CONFIG_BLK_DEV_IT8172=y
# CONFIG_BLK_DEV_IT8213 is not set
CONFIG_BLK_DEV_IT821X=y
# CONFIG_BLK_DEV_NS87415 is not set
CONFIG_BLK_DEV_PDC202XX_OLD=y
CONFIG_BLK_DEV_PDC202XX_NEW=m
# CONFIG_BLK_DEV_SVWKS is not set
CONFIG_BLK_DEV_SIIMAGE=m
CONFIG_BLK_DEV_SIS5513=y
# CONFIG_BLK_DEV_SLC90E66 is not set
CONFIG_BLK_DEV_TRM290=m
CONFIG_BLK_DEV_VIA82CXXX=y
CONFIG_BLK_DEV_TC86C001=m

#
# Other IDE chipsets support
#

#
# Note: most of these also require special kernel boot parameters
#
# CONFIG_BLK_DEV_4DRIVES is not set
CONFIG_BLK_DEV_ALI14XX=m
CONFIG_BLK_DEV_DTC2278=y
CONFIG_BLK_DEV_HT6560B=y
CONFIG_BLK_DEV_QD65XX=y
CONFIG_BLK_DEV_UMC8672=y
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
CONFIG_BLK_DEV_MD=y
# CONFIG_MD_AUTODETECT is not set
# CONFIG_MD_LINEAR is not set
CONFIG_MD_RAID0=y
CONFIG_MD_RAID1=y
CONFIG_MD_RAID10=y
CONFIG_MD_RAID456=y
CONFIG_MD_MULTIPATH=y
# CONFIG_MD_FAULTY is not set
CONFIG_BCACHE=y
# CONFIG_BCACHE_DEBUG is not set
# CONFIG_BCACHE_CLOSURES_DEBUG is not set
# CONFIG_BLK_DEV_DM is not set
CONFIG_FUSION=y
CONFIG_FUSION_MAX_SGE=128
# CONFIG_FUSION_LOGGING is not set

#
# IEEE 1394 (FireWire) support
#
# CONFIG_FIREWIRE is not set
CONFIG_FIREWIRE_NOSY=y
CONFIG_I2O=m
CONFIG_I2O_LCT_NOTIFY_ON_CHANGES=y
CONFIG_I2O_EXT_ADAPTEC=y
CONFIG_I2O_CONFIG=m
# CONFIG_I2O_CONFIG_OLD_IOCTL is not set
# CONFIG_I2O_BUS is not set
CONFIG_I2O_BLOCK=m
# CONFIG_I2O_PROC is not set
# CONFIG_MACINTOSH_DRIVERS is not set
# CONFIG_NETDEVICES is not set
CONFIG_VHOST_NET=y
CONFIG_VHOST_RING=y
CONFIG_VHOST=y

#
# Input device support
#
CONFIG_INPUT=y
CONFIG_INPUT_FF_MEMLESS=y
CONFIG_INPUT_POLLDEV=y
CONFIG_INPUT_SPARSEKMAP=m
CONFIG_INPUT_MATRIXKMAP=m

#
# Userland interfaces
#
CONFIG_INPUT_MOUSEDEV=m
CONFIG_INPUT_MOUSEDEV_PSAUX=y
CONFIG_INPUT_MOUSEDEV_SCREEN_X=1024
CONFIG_INPUT_MOUSEDEV_SCREEN_Y=768
# CONFIG_INPUT_JOYDEV is not set
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
# CONFIG_KEYBOARD_GOLDFISH_EVENTS is not set
# CONFIG_KEYBOARD_STOWAWAY is not set
# CONFIG_KEYBOARD_SUNKBD is not set
# CONFIG_KEYBOARD_SH_KEYSC is not set
# CONFIG_KEYBOARD_TWL4030 is not set
# CONFIG_KEYBOARD_XTKBD is not set
CONFIG_INPUT_MOUSE=y
# CONFIG_MOUSE_PS2 is not set
CONFIG_MOUSE_SERIAL=m
CONFIG_MOUSE_APPLETOUCH=y
CONFIG_MOUSE_BCM5974=m
CONFIG_MOUSE_CYAPA=m
# CONFIG_MOUSE_INPORT is not set
CONFIG_MOUSE_LOGIBM=y
CONFIG_MOUSE_PC110PAD=y
CONFIG_MOUSE_VSXXXAA=m
# CONFIG_MOUSE_GPIO is not set
CONFIG_MOUSE_SYNAPTICS_I2C=m
# CONFIG_MOUSE_SYNAPTICS_USB is not set
# CONFIG_INPUT_JOYSTICK is not set
# CONFIG_INPUT_TABLET is not set
# CONFIG_INPUT_TOUCHSCREEN is not set
CONFIG_INPUT_MISC=y
# CONFIG_INPUT_88PM860X_ONKEY is not set
# CONFIG_INPUT_AD714X is not set
CONFIG_INPUT_BMA150=y
CONFIG_INPUT_PCSPKR=m
CONFIG_INPUT_MC13783_PWRBUTTON=m
CONFIG_INPUT_MMA8450=m
CONFIG_INPUT_MPU3050=y
CONFIG_INPUT_APANEL=y
CONFIG_INPUT_GP2A=y
CONFIG_INPUT_GPIO_TILT_POLLED=m
# CONFIG_INPUT_WISTRON_BTNS is not set
# CONFIG_INPUT_ATLAS_BTNS is not set
# CONFIG_INPUT_ATI_REMOTE2 is not set
CONFIG_INPUT_KEYSPAN_REMOTE=y
CONFIG_INPUT_KXTJ9=y
CONFIG_INPUT_KXTJ9_POLLED_MODE=y
# CONFIG_INPUT_POWERMATE is not set
CONFIG_INPUT_YEALINK=y
CONFIG_INPUT_CM109=y
CONFIG_INPUT_RETU_PWRBUTTON=m
CONFIG_INPUT_TWL4030_PWRBUTTON=y
CONFIG_INPUT_TWL4030_VIBRA=m
CONFIG_INPUT_TWL6040_VIBRA=y
CONFIG_INPUT_UINPUT=y
CONFIG_INPUT_PCF50633_PMU=y
CONFIG_INPUT_PCF8574=m
CONFIG_INPUT_GPIO_ROTARY_ENCODER=y
CONFIG_INPUT_DA9055_ONKEY=m
CONFIG_INPUT_WM831X_ON=m
CONFIG_INPUT_ADXL34X=m
# CONFIG_INPUT_ADXL34X_I2C is not set
CONFIG_INPUT_ADXL34X_SPI=m
CONFIG_INPUT_IMS_PCU=m
CONFIG_INPUT_CMA3000=m
CONFIG_INPUT_CMA3000_I2C=m
# CONFIG_INPUT_IDEAPAD_SLIDEBAR is not set

#
# Hardware I/O ports
#
CONFIG_SERIO=y
CONFIG_SERIO_I8042=y
CONFIG_SERIO_SERPORT=m
CONFIG_SERIO_CT82C710=y
CONFIG_SERIO_PCIPS2=m
CONFIG_SERIO_LIBPS2=y
# CONFIG_SERIO_RAW is not set
CONFIG_SERIO_ALTERA_PS2=y
CONFIG_SERIO_PS2MULT=y
# CONFIG_SERIO_ARC_PS2 is not set
# CONFIG_GAMEPORT is not set

#
# Character devices
#
CONFIG_TTY=y
CONFIG_VT=y
CONFIG_CONSOLE_TRANSLATIONS=y
CONFIG_VT_CONSOLE=y
CONFIG_VT_CONSOLE_SLEEP=y
CONFIG_HW_CONSOLE=y
CONFIG_VT_HW_CONSOLE_BINDING=y
CONFIG_UNIX98_PTYS=y
CONFIG_DEVPTS_MULTIPLE_INSTANCES=y
# CONFIG_LEGACY_PTYS is not set
CONFIG_SERIAL_NONSTANDARD=y
# CONFIG_ROCKETPORT is not set
CONFIG_CYCLADES=y
# CONFIG_CYZ_INTR is not set
CONFIG_MOXA_INTELLIO=y
CONFIG_MOXA_SMARTIO=y
CONFIG_SYNCLINK=y
# CONFIG_SYNCLINKMP is not set
# CONFIG_SYNCLINK_GT is not set
CONFIG_NOZOMI=m
CONFIG_ISI=y
CONFIG_N_HDLC=m
CONFIG_N_GSM=y
CONFIG_TRACE_ROUTER=m
CONFIG_TRACE_SINK=y
CONFIG_GOLDFISH_TTY=m
# CONFIG_DEVKMEM is not set

#
# Serial drivers
#
CONFIG_SERIAL_8250=y
# CONFIG_SERIAL_8250_DEPRECATED_OPTIONS is not set
CONFIG_SERIAL_8250_PNP=y
CONFIG_SERIAL_8250_CONSOLE=y
CONFIG_FIX_EARLYCON_MEM=y
CONFIG_SERIAL_8250_DMA=y
CONFIG_SERIAL_8250_PCI=y
CONFIG_SERIAL_8250_CS=m
CONFIG_SERIAL_8250_NR_UARTS=4
CONFIG_SERIAL_8250_RUNTIME_UARTS=4
# CONFIG_SERIAL_8250_EXTENDED is not set
CONFIG_SERIAL_8250_DW=m

#
# Non-8250 serial port support
#
CONFIG_SERIAL_MAX3100=y
CONFIG_SERIAL_MAX310X=y
CONFIG_SERIAL_MRST_MAX3110=m
# CONFIG_SERIAL_MFD_HSU is not set
CONFIG_SERIAL_CORE=y
CONFIG_SERIAL_CORE_CONSOLE=y
CONFIG_SERIAL_JSM=m
# CONFIG_SERIAL_SCCNXP is not set
# CONFIG_SERIAL_TIMBERDALE is not set
CONFIG_SERIAL_ALTERA_JTAGUART=m
CONFIG_SERIAL_ALTERA_UART=m
CONFIG_SERIAL_ALTERA_UART_MAXPORTS=4
CONFIG_SERIAL_ALTERA_UART_BAUDRATE=115200
CONFIG_SERIAL_IFX6X60=y
CONFIG_SERIAL_PCH_UART=m
CONFIG_SERIAL_ARC=m
CONFIG_SERIAL_ARC_NR_PORTS=1
# CONFIG_SERIAL_RP2 is not set
# CONFIG_SERIAL_FSL_LPUART is not set
# CONFIG_SERIAL_ST_ASC is not set
CONFIG_HVC_DRIVER=y
CONFIG_VIRTIO_CONSOLE=y
# CONFIG_IPMI_HANDLER is not set
# CONFIG_HW_RANDOM is not set
CONFIG_NVRAM=y
# CONFIG_DTLK is not set
# CONFIG_R3964 is not set
CONFIG_APPLICOM=y
# CONFIG_SONYPI is not set

#
# PCMCIA character devices
#
# CONFIG_SYNCLINK_CS is not set
# CONFIG_CARDMAN_4000 is not set
CONFIG_CARDMAN_4040=y
CONFIG_MWAVE=m
CONFIG_SCx200_GPIO=m
CONFIG_PC8736x_GPIO=m
CONFIG_NSC_GPIO=m
CONFIG_RAW_DRIVER=m
CONFIG_MAX_RAW_DEVS=256
# CONFIG_HPET is not set
# CONFIG_HANGCHECK_TIMER is not set
CONFIG_TCG_TPM=y
CONFIG_TCG_TIS=m
CONFIG_TCG_TIS_I2C_ATMEL=y
# CONFIG_TCG_TIS_I2C_INFINEON is not set
# CONFIG_TCG_TIS_I2C_NUVOTON is not set
CONFIG_TCG_NSC=y
CONFIG_TCG_ATMEL=y
CONFIG_TCG_INFINEON=m
CONFIG_TCG_ST33_I2C=y
CONFIG_TELCLOCK=m
CONFIG_DEVPORT=y
CONFIG_I2C=y
CONFIG_I2C_BOARDINFO=y
CONFIG_I2C_COMPAT=y
CONFIG_I2C_CHARDEV=m
CONFIG_I2C_MUX=m

#
# Multiplexer I2C Chip support
#
CONFIG_I2C_MUX_GPIO=m
CONFIG_I2C_MUX_PCA9541=m
# CONFIG_I2C_MUX_PCA954x is not set
# CONFIG_I2C_HELPER_AUTO is not set
CONFIG_I2C_SMBUS=y

#
# I2C Algorithms
#
CONFIG_I2C_ALGOBIT=y
CONFIG_I2C_ALGOPCF=y
CONFIG_I2C_ALGOPCA=y

#
# I2C Hardware Bus support
#

#
# PC SMBus host controller drivers
#
# CONFIG_I2C_ALI1535 is not set
CONFIG_I2C_ALI1563=m
CONFIG_I2C_ALI15X3=y
CONFIG_I2C_AMD756=m
# CONFIG_I2C_AMD756_S4882 is not set
# CONFIG_I2C_AMD8111 is not set
# CONFIG_I2C_I801 is not set
CONFIG_I2C_ISCH=y
CONFIG_I2C_ISMT=m
CONFIG_I2C_PIIX4=y
CONFIG_I2C_NFORCE2=y
# CONFIG_I2C_NFORCE2_S4985 is not set
# CONFIG_I2C_SIS5595 is not set
CONFIG_I2C_SIS630=y
CONFIG_I2C_SIS96X=y
CONFIG_I2C_VIA=m
CONFIG_I2C_VIAPRO=m

#
# ACPI drivers
#
# CONFIG_I2C_SCMI is not set

#
# I2C system bus drivers (mostly embedded / system-on-chip)
#
# CONFIG_I2C_CBUS_GPIO is not set
CONFIG_I2C_DESIGNWARE_CORE=y
CONFIG_I2C_DESIGNWARE_PCI=y
CONFIG_I2C_EG20T=m
CONFIG_I2C_GPIO=m
# CONFIG_I2C_KEMPLD is not set
CONFIG_I2C_OCORES=m
CONFIG_I2C_PCA_PLATFORM=m
# CONFIG_I2C_PXA_PCI is not set
CONFIG_I2C_SH_MOBILE=m
CONFIG_I2C_SIMTEC=m
CONFIG_I2C_XILINX=m
CONFIG_I2C_RCAR=m

#
# External I2C/SMBus adapter drivers
#
CONFIG_I2C_DIOLAN_U2C=y
# CONFIG_I2C_PARPORT_LIGHT is not set
CONFIG_I2C_TAOS_EVM=m
CONFIG_I2C_TINY_USB=y

#
# Other I2C/SMBus bus drivers
#
CONFIG_I2C_ELEKTOR=y
CONFIG_I2C_PCA_ISA=m
CONFIG_SCx200_I2C=m
CONFIG_SCx200_I2C_SCL=12
CONFIG_SCx200_I2C_SDA=13
# CONFIG_SCx200_ACB is not set
CONFIG_I2C_STUB=m
# CONFIG_I2C_DEBUG_CORE is not set
# CONFIG_I2C_DEBUG_ALGO is not set
# CONFIG_I2C_DEBUG_BUS is not set
CONFIG_SPI=y
# CONFIG_SPI_DEBUG is not set
CONFIG_SPI_MASTER=y

#
# SPI Master Controller Drivers
#
CONFIG_SPI_ALTERA=m
CONFIG_SPI_ATMEL=m
CONFIG_SPI_BCM2835=m
CONFIG_SPI_BITBANG=y
# CONFIG_SPI_EP93XX is not set
CONFIG_SPI_GPIO=y
# CONFIG_SPI_IMX is not set
CONFIG_SPI_FSL_DSPI=m
# CONFIG_SPI_OC_TINY is not set
# CONFIG_SPI_OMAP24XX is not set
CONFIG_SPI_TI_QSPI=m
CONFIG_SPI_OMAP_100K=m
CONFIG_SPI_ORION=y
CONFIG_SPI_PXA2XX_DMA=y
CONFIG_SPI_PXA2XX=m
CONFIG_SPI_PXA2XX_PCI=m
CONFIG_SPI_SC18IS602=y
CONFIG_SPI_SH=y
# CONFIG_SPI_SH_HSPI is not set
# CONFIG_SPI_TEGRA114 is not set
# CONFIG_SPI_TEGRA20_SFLASH is not set
# CONFIG_SPI_TEGRA20_SLINK is not set
# CONFIG_SPI_TOPCLIFF_PCH is not set
CONFIG_SPI_TXX9=y
CONFIG_SPI_XCOMM=y
CONFIG_SPI_XILINX=m
CONFIG_SPI_DESIGNWARE=y
CONFIG_SPI_DW_PCI=m
CONFIG_SPI_DW_MID_DMA=y

#
# SPI Protocol Masters
#
CONFIG_SPI_SPIDEV=m
# CONFIG_SPI_TLE62X0 is not set
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
# CONFIG_PPS_CLIENT_LDISC is not set
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
CONFIG_PTP_1588_CLOCK_PCH=m
CONFIG_ARCH_WANT_OPTIONAL_GPIOLIB=y
CONFIG_GPIOLIB=y
CONFIG_GPIO_DEVRES=y
CONFIG_GPIO_ACPI=y
# CONFIG_DEBUG_GPIO is not set
# CONFIG_GPIO_SYSFS is not set
CONFIG_GPIO_GENERIC=y
CONFIG_GPIO_DA9055=m
CONFIG_GPIO_MAX730X=y

#
# Memory mapped GPIO drivers:
#
CONFIG_GPIO_GENERIC_PLATFORM=y
CONFIG_GPIO_IT8761E=m
CONFIG_GPIO_F7188X=m
# CONFIG_GPIO_TS5500 is not set
CONFIG_GPIO_SCH=m
CONFIG_GPIO_ICH=y
CONFIG_GPIO_VX855=y
# CONFIG_GPIO_LYNXPOINT is not set

#
# I2C GPIO expanders:
#
CONFIG_GPIO_ARIZONA=m
CONFIG_GPIO_MAX7300=y
# CONFIG_GPIO_MAX732X is not set
# CONFIG_GPIO_PCA953X is not set
# CONFIG_GPIO_PCF857X is not set
CONFIG_GPIO_RC5T583=y
CONFIG_GPIO_SX150X=y
CONFIG_GPIO_TPS65912=y
CONFIG_GPIO_TWL4030=m
# CONFIG_GPIO_TWL6040 is not set
# CONFIG_GPIO_WM831X is not set
# CONFIG_GPIO_WM8994 is not set
CONFIG_GPIO_ADP5588=y
# CONFIG_GPIO_ADP5588_IRQ is not set

#
# PCI GPIO expanders:
#
CONFIG_GPIO_BT8XX=m
# CONFIG_GPIO_AMD8111 is not set
CONFIG_GPIO_INTEL_MID=y
CONFIG_GPIO_PCH=m
CONFIG_GPIO_ML_IOH=m
# CONFIG_GPIO_RDC321X is not set

#
# SPI GPIO expanders:
#
# CONFIG_GPIO_MAX7301 is not set
# CONFIG_GPIO_MCP23S08 is not set
# CONFIG_GPIO_MC33880 is not set
# CONFIG_GPIO_74X164 is not set

#
# AC97 GPIO expanders:
#

#
# LPC GPIO expanders:
#
CONFIG_GPIO_KEMPLD=m

#
# MODULbus GPIO expanders:
#
CONFIG_GPIO_JANZ_TTL=m
# CONFIG_GPIO_PALMAS is not set
CONFIG_GPIO_TPS65910=y

#
# USB GPIO expanders:
#
CONFIG_W1=y

#
# 1-wire Bus Masters
#
# CONFIG_W1_MASTER_MATROX is not set
CONFIG_W1_MASTER_DS2490=m
CONFIG_W1_MASTER_DS2482=m
# CONFIG_W1_MASTER_DS1WM is not set
CONFIG_W1_MASTER_GPIO=m

#
# 1-wire Slaves
#
# CONFIG_W1_SLAVE_THERM is not set
CONFIG_W1_SLAVE_SMEM=m
CONFIG_W1_SLAVE_DS2408=y
CONFIG_W1_SLAVE_DS2408_READBACK=y
CONFIG_W1_SLAVE_DS2413=m
CONFIG_W1_SLAVE_DS2423=y
# CONFIG_W1_SLAVE_DS2431 is not set
CONFIG_W1_SLAVE_DS2433=y
CONFIG_W1_SLAVE_DS2433_CRC=y
# CONFIG_W1_SLAVE_DS2760 is not set
CONFIG_W1_SLAVE_DS2780=y
CONFIG_W1_SLAVE_DS2781=y
CONFIG_W1_SLAVE_DS28E04=m
CONFIG_W1_SLAVE_BQ27000=y
CONFIG_POWER_SUPPLY=y
# CONFIG_POWER_SUPPLY_DEBUG is not set
CONFIG_PDA_POWER=y
CONFIG_WM831X_BACKUP=y
# CONFIG_WM831X_POWER is not set
CONFIG_TEST_POWER=y
# CONFIG_BATTERY_88PM860X is not set
# CONFIG_BATTERY_DS2780 is not set
CONFIG_BATTERY_DS2781=y
CONFIG_BATTERY_DS2782=m
CONFIG_BATTERY_SBS=m
CONFIG_BATTERY_BQ27x00=m
CONFIG_BATTERY_BQ27X00_I2C=y
# CONFIG_BATTERY_BQ27X00_PLATFORM is not set
# CONFIG_BATTERY_MAX17040 is not set
# CONFIG_BATTERY_MAX17042 is not set
# CONFIG_CHARGER_PCF50633 is not set
CONFIG_CHARGER_ISP1704=m
# CONFIG_CHARGER_MAX8903 is not set
CONFIG_CHARGER_TWL4030=y
# CONFIG_CHARGER_LP8727 is not set
CONFIG_CHARGER_GPIO=y
# CONFIG_CHARGER_MANAGER is not set
# CONFIG_CHARGER_BQ2415X is not set
CONFIG_CHARGER_BQ24190=m
CONFIG_CHARGER_BQ24735=m
CONFIG_CHARGER_SMB347=m
CONFIG_BATTERY_GOLDFISH=m
CONFIG_POWER_RESET=y
CONFIG_POWER_AVS=y
CONFIG_HWMON=m
CONFIG_HWMON_VID=m
# CONFIG_HWMON_DEBUG_CHIP is not set

#
# Native drivers
#
CONFIG_SENSORS_ABITUGURU=m
# CONFIG_SENSORS_ABITUGURU3 is not set
CONFIG_SENSORS_AD7314=m
CONFIG_SENSORS_AD7414=m
# CONFIG_SENSORS_AD7418 is not set
CONFIG_SENSORS_ADCXX=m
CONFIG_SENSORS_ADM1021=m
CONFIG_SENSORS_ADM1025=m
# CONFIG_SENSORS_ADM1026 is not set
CONFIG_SENSORS_ADM1029=m
# CONFIG_SENSORS_ADM1031 is not set
# CONFIG_SENSORS_ADM9240 is not set
CONFIG_SENSORS_ADT7X10=m
# CONFIG_SENSORS_ADT7310 is not set
CONFIG_SENSORS_ADT7410=m
CONFIG_SENSORS_ADT7411=m
# CONFIG_SENSORS_ADT7462 is not set
# CONFIG_SENSORS_ADT7470 is not set
# CONFIG_SENSORS_ADT7475 is not set
CONFIG_SENSORS_ASC7621=m
CONFIG_SENSORS_K8TEMP=m
# CONFIG_SENSORS_K10TEMP is not set
# CONFIG_SENSORS_FAM15H_POWER is not set
CONFIG_SENSORS_ASB100=m
CONFIG_SENSORS_ATXP1=m
CONFIG_SENSORS_DS620=m
# CONFIG_SENSORS_DS1621 is not set
# CONFIG_SENSORS_DA9055 is not set
CONFIG_SENSORS_I5K_AMB=m
CONFIG_SENSORS_F71805F=m
CONFIG_SENSORS_F71882FG=m
CONFIG_SENSORS_F75375S=m
# CONFIG_SENSORS_FSCHMD is not set
CONFIG_SENSORS_G760A=m
CONFIG_SENSORS_G762=m
CONFIG_SENSORS_GL518SM=m
# CONFIG_SENSORS_GL520SM is not set
CONFIG_SENSORS_GPIO_FAN=m
CONFIG_SENSORS_HIH6130=m
CONFIG_SENSORS_HTU21=m
CONFIG_SENSORS_CORETEMP=m
# CONFIG_SENSORS_IT87 is not set
CONFIG_SENSORS_JC42=m
CONFIG_SENSORS_LINEAGE=m
CONFIG_SENSORS_LM63=m
CONFIG_SENSORS_LM70=m
CONFIG_SENSORS_LM73=m
CONFIG_SENSORS_LM75=m
# CONFIG_SENSORS_LM77 is not set
CONFIG_SENSORS_LM78=m
CONFIG_SENSORS_LM80=m
CONFIG_SENSORS_LM83=m
CONFIG_SENSORS_LM85=m
# CONFIG_SENSORS_LM87 is not set
# CONFIG_SENSORS_LM90 is not set
CONFIG_SENSORS_LM92=m
CONFIG_SENSORS_LM93=m
# CONFIG_SENSORS_LTC4151 is not set
# CONFIG_SENSORS_LTC4215 is not set
CONFIG_SENSORS_LTC4245=m
# CONFIG_SENSORS_LTC4261 is not set
# CONFIG_SENSORS_LM95234 is not set
CONFIG_SENSORS_LM95241=m
CONFIG_SENSORS_LM95245=m
CONFIG_SENSORS_MAX1111=m
CONFIG_SENSORS_MAX16065=m
CONFIG_SENSORS_MAX1619=m
# CONFIG_SENSORS_MAX1668 is not set
CONFIG_SENSORS_MAX197=m
CONFIG_SENSORS_MAX6639=m
CONFIG_SENSORS_MAX6642=m
# CONFIG_SENSORS_MAX6650 is not set
CONFIG_SENSORS_MAX6697=m
CONFIG_SENSORS_MCP3021=m
CONFIG_SENSORS_NCT6775=m
CONFIG_SENSORS_NTC_THERMISTOR=m
CONFIG_SENSORS_PC87360=m
CONFIG_SENSORS_PC87427=m
# CONFIG_SENSORS_PCF8591 is not set
CONFIG_PMBUS=m
# CONFIG_SENSORS_PMBUS is not set
# CONFIG_SENSORS_ADM1275 is not set
CONFIG_SENSORS_LM25066=m
CONFIG_SENSORS_LTC2978=m
CONFIG_SENSORS_MAX16064=m
# CONFIG_SENSORS_MAX34440 is not set
CONFIG_SENSORS_MAX8688=m
# CONFIG_SENSORS_UCD9000 is not set
# CONFIG_SENSORS_UCD9200 is not set
# CONFIG_SENSORS_ZL6100 is not set
# CONFIG_SENSORS_SHT15 is not set
# CONFIG_SENSORS_SHT21 is not set
CONFIG_SENSORS_SIS5595=m
# CONFIG_SENSORS_SMM665 is not set
# CONFIG_SENSORS_DME1737 is not set
CONFIG_SENSORS_EMC1403=m
CONFIG_SENSORS_EMC2103=m
CONFIG_SENSORS_EMC6W201=m
CONFIG_SENSORS_SMSC47M1=m
CONFIG_SENSORS_SMSC47M192=m
CONFIG_SENSORS_SMSC47B397=m
CONFIG_SENSORS_SCH56XX_COMMON=m
# CONFIG_SENSORS_SCH5627 is not set
CONFIG_SENSORS_SCH5636=m
CONFIG_SENSORS_ADS1015=m
# CONFIG_SENSORS_ADS7828 is not set
# CONFIG_SENSORS_ADS7871 is not set
# CONFIG_SENSORS_AMC6821 is not set
CONFIG_SENSORS_INA209=m
CONFIG_SENSORS_INA2XX=m
CONFIG_SENSORS_THMC50=m
# CONFIG_SENSORS_TMP102 is not set
CONFIG_SENSORS_TMP401=m
# CONFIG_SENSORS_TMP421 is not set
CONFIG_SENSORS_VIA_CPUTEMP=m
CONFIG_SENSORS_VIA686A=m
CONFIG_SENSORS_VT1211=m
CONFIG_SENSORS_VT8231=m
CONFIG_SENSORS_W83781D=m
# CONFIG_SENSORS_W83791D is not set
# CONFIG_SENSORS_W83792D is not set
# CONFIG_SENSORS_W83793 is not set
CONFIG_SENSORS_W83795=m
CONFIG_SENSORS_W83795_FANCTRL=y
# CONFIG_SENSORS_W83L785TS is not set
# CONFIG_SENSORS_W83L786NG is not set
CONFIG_SENSORS_W83627HF=m
CONFIG_SENSORS_W83627EHF=m
CONFIG_SENSORS_WM831X=m
CONFIG_SENSORS_APPLESMC=m
# CONFIG_SENSORS_MC13783_ADC is not set

#
# ACPI drivers
#
# CONFIG_SENSORS_ACPI_POWER is not set
# CONFIG_SENSORS_ATK0110 is not set
CONFIG_THERMAL=y
# CONFIG_THERMAL_DEFAULT_GOV_STEP_WISE is not set
# CONFIG_THERMAL_DEFAULT_GOV_FAIR_SHARE is not set
CONFIG_THERMAL_DEFAULT_GOV_USER_SPACE=y
# CONFIG_THERMAL_GOV_FAIR_SHARE is not set
CONFIG_THERMAL_GOV_STEP_WISE=y
CONFIG_THERMAL_GOV_USER_SPACE=y
CONFIG_THERMAL_EMULATION=y
CONFIG_INTEL_POWERCLAMP=m

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
CONFIG_DA9055_WATCHDOG=m
# CONFIG_WM831X_WATCHDOG is not set
CONFIG_TWL4030_WATCHDOG=y
CONFIG_RETU_WATCHDOG=m
# CONFIG_ACQUIRE_WDT is not set
# CONFIG_ADVANTECH_WDT is not set
CONFIG_ALIM1535_WDT=y
# CONFIG_ALIM7101_WDT is not set
CONFIG_F71808E_WDT=m
CONFIG_SP5100_TCO=m
# CONFIG_SC520_WDT is not set
CONFIG_SBC_FITPC2_WATCHDOG=m
# CONFIG_EUROTECH_WDT is not set
CONFIG_IB700_WDT=y
# CONFIG_IBMASR is not set
# CONFIG_WAFER_WDT is not set
CONFIG_I6300ESB_WDT=y
CONFIG_IE6XX_WDT=m
CONFIG_ITCO_WDT=y
CONFIG_ITCO_VENDOR_SUPPORT=y
CONFIG_IT8712F_WDT=m
# CONFIG_IT87_WDT is not set
CONFIG_HP_WATCHDOG=y
# CONFIG_KEMPLD_WDT is not set
# CONFIG_HPWDT_NMI_DECODING is not set
CONFIG_SC1200_WDT=m
CONFIG_SCx200_WDT=m
# CONFIG_PC87413_WDT is not set
CONFIG_NV_TCO=m
# CONFIG_RDC321X_WDT is not set
# CONFIG_60XX_WDT is not set
CONFIG_SBC8360_WDT=m
CONFIG_SBC7240_WDT=m
CONFIG_CPU5_WDT=y
# CONFIG_SMSC_SCH311X_WDT is not set
CONFIG_SMSC37B787_WDT=y
# CONFIG_VIA_WDT is not set
# CONFIG_W83627HF_WDT is not set
CONFIG_W83697HF_WDT=y
CONFIG_W83697UG_WDT=y
CONFIG_W83877F_WDT=y
CONFIG_W83977F_WDT=m
CONFIG_MACHZ_WDT=y
CONFIG_SBC_EPX_C3_WATCHDOG=y
CONFIG_MEN_A21_WDT=y

#
# ISA-based Watchdog Cards
#
CONFIG_PCWATCHDOG=y
CONFIG_MIXCOMWD=m
# CONFIG_WDT is not set

#
# PCI-based Watchdog Cards
#
CONFIG_PCIPCWATCHDOG=m
CONFIG_WDTPCI=m

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
CONFIG_BCMA=m
CONFIG_BCMA_HOST_PCI_POSSIBLE=y
CONFIG_BCMA_HOST_PCI=y
# CONFIG_BCMA_HOST_SOC is not set
# CONFIG_BCMA_DRIVER_GMAC_CMN is not set
# CONFIG_BCMA_DRIVER_GPIO is not set
CONFIG_BCMA_DEBUG=y

#
# Multifunction device drivers
#
CONFIG_MFD_CORE=y
# CONFIG_MFD_CS5535 is not set
# CONFIG_MFD_AS3711 is not set
# CONFIG_PMIC_ADP5520 is not set
# CONFIG_MFD_AAT2870_CORE is not set
# CONFIG_MFD_CROS_EC is not set
# CONFIG_PMIC_DA903X is not set
# CONFIG_MFD_DA9052_SPI is not set
# CONFIG_MFD_DA9052_I2C is not set
CONFIG_MFD_DA9055=y
# CONFIG_MFD_DA9063 is not set
CONFIG_MFD_MC13783=m
CONFIG_MFD_MC13XXX=m
CONFIG_MFD_MC13XXX_SPI=m
CONFIG_MFD_MC13XXX_I2C=m
CONFIG_HTC_PASIC3=y
CONFIG_HTC_I2CPLD=y
CONFIG_LPC_ICH=y
CONFIG_LPC_SCH=y
CONFIG_MFD_JANZ_CMODIO=m
CONFIG_MFD_KEMPLD=m
# CONFIG_MFD_88PM800 is not set
# CONFIG_MFD_88PM805 is not set
CONFIG_MFD_88PM860X=y
# CONFIG_MFD_MAX77686 is not set
CONFIG_MFD_MAX77693=y
CONFIG_MFD_MAX8907=y
# CONFIG_MFD_MAX8925 is not set
# CONFIG_MFD_MAX8997 is not set
# CONFIG_MFD_MAX8998 is not set
# CONFIG_EZX_PCAP is not set
# CONFIG_MFD_VIPERBOARD is not set
CONFIG_MFD_RETU=m
CONFIG_MFD_PCF50633=y
CONFIG_PCF50633_ADC=y
CONFIG_PCF50633_GPIO=m
CONFIG_MFD_RDC321X=m
CONFIG_MFD_RTSX_PCI=m
CONFIG_MFD_RC5T583=y
CONFIG_MFD_SEC_CORE=y
CONFIG_MFD_SI476X_CORE=y
CONFIG_MFD_SM501=m
# CONFIG_MFD_SM501_GPIO is not set
# CONFIG_MFD_SMSC is not set
CONFIG_ABX500_CORE=y
# CONFIG_AB3100_CORE is not set
# CONFIG_MFD_STMPE is not set
# CONFIG_MFD_SYSCON is not set
CONFIG_MFD_TI_AM335X_TSCADC=y
# CONFIG_MFD_LP8788 is not set
CONFIG_MFD_PALMAS=y
CONFIG_TPS6105X=m
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
CONFIG_MFD_WL1273_CORE=y
CONFIG_MFD_LM3533=y
# CONFIG_MFD_TIMBERDALE is not set
# CONFIG_MFD_TC3589X is not set
# CONFIG_MFD_TMIO is not set
CONFIG_MFD_VX855=y
CONFIG_MFD_ARIZONA=y
CONFIG_MFD_ARIZONA_I2C=m
CONFIG_MFD_ARIZONA_SPI=y
CONFIG_MFD_WM5102=y
CONFIG_MFD_WM5110=y
CONFIG_MFD_WM8997=y
# CONFIG_MFD_WM8400 is not set
CONFIG_MFD_WM831X=y
# CONFIG_MFD_WM831X_I2C is not set
CONFIG_MFD_WM831X_SPI=y
# CONFIG_MFD_WM8350_I2C is not set
CONFIG_MFD_WM8994=y
CONFIG_REGULATOR=y
CONFIG_REGULATOR_DEBUG=y
CONFIG_REGULATOR_FIXED_VOLTAGE=y
# CONFIG_REGULATOR_VIRTUAL_CONSUMER is not set
# CONFIG_REGULATOR_USERSPACE_CONSUMER is not set
CONFIG_REGULATOR_88PM8607=m
CONFIG_REGULATOR_AD5398=m
CONFIG_REGULATOR_DA9055=y
CONFIG_REGULATOR_DA9210=m
CONFIG_REGULATOR_FAN53555=y
CONFIG_REGULATOR_GPIO=m
CONFIG_REGULATOR_ISL6271A=y
CONFIG_REGULATOR_LP3971=y
CONFIG_REGULATOR_LP3972=y
CONFIG_REGULATOR_LP872X=y
CONFIG_REGULATOR_LP8755=y
# CONFIG_REGULATOR_MAX1586 is not set
CONFIG_REGULATOR_MAX8649=m
CONFIG_REGULATOR_MAX8660=m
CONFIG_REGULATOR_MAX8907=m
# CONFIG_REGULATOR_MAX8952 is not set
CONFIG_REGULATOR_MAX8973=y
CONFIG_REGULATOR_MAX77693=y
CONFIG_REGULATOR_MC13XXX_CORE=m
CONFIG_REGULATOR_MC13783=m
# CONFIG_REGULATOR_MC13892 is not set
# CONFIG_REGULATOR_PALMAS is not set
CONFIG_REGULATOR_PCF50633=y
CONFIG_REGULATOR_PFUZE100=m
# CONFIG_REGULATOR_RC5T583 is not set
CONFIG_REGULATOR_S2MPS11=m
CONFIG_REGULATOR_S5M8767=y
# CONFIG_REGULATOR_TPS51632 is not set
# CONFIG_REGULATOR_TPS6105X is not set
# CONFIG_REGULATOR_TPS62360 is not set
CONFIG_REGULATOR_TPS65023=y
CONFIG_REGULATOR_TPS6507X=m
CONFIG_REGULATOR_TPS6524X=y
CONFIG_REGULATOR_TPS65910=y
CONFIG_REGULATOR_TPS65912=m
CONFIG_REGULATOR_TWL4030=y
CONFIG_REGULATOR_WM831X=m
CONFIG_REGULATOR_WM8994=y
CONFIG_MEDIA_SUPPORT=m

#
# Multimedia core support
#
CONFIG_MEDIA_CAMERA_SUPPORT=y
# CONFIG_MEDIA_ANALOG_TV_SUPPORT is not set
CONFIG_MEDIA_DIGITAL_TV_SUPPORT=y
# CONFIG_MEDIA_RADIO_SUPPORT is not set
# CONFIG_MEDIA_RC_SUPPORT is not set
CONFIG_MEDIA_CONTROLLER=y
CONFIG_VIDEO_DEV=m
# CONFIG_VIDEO_V4L2_SUBDEV_API is not set
CONFIG_VIDEO_V4L2=m
# CONFIG_VIDEO_ADV_DEBUG is not set
# CONFIG_VIDEO_FIXED_MINOR_RANGES is not set
CONFIG_VIDEO_TUNER=m
CONFIG_V4L2_MEM2MEM_DEV=m
CONFIG_VIDEOBUF_GEN=m
CONFIG_VIDEOBUF_VMALLOC=m
CONFIG_VIDEOBUF_DMA_CONTIG=m
CONFIG_VIDEOBUF2_CORE=m
CONFIG_VIDEOBUF2_MEMOPS=m
CONFIG_VIDEOBUF2_DMA_CONTIG=m
CONFIG_VIDEOBUF2_VMALLOC=m
# CONFIG_VIDEO_V4L2_INT_DEVICE is not set
CONFIG_DVB_CORE=m
# CONFIG_TTPCI_EEPROM is not set
CONFIG_DVB_MAX_ADAPTERS=8
# CONFIG_DVB_DYNAMIC_MINORS is not set

#
# Media drivers
#
CONFIG_MEDIA_USB_SUPPORT=y

#
# Webcam devices
#
CONFIG_USB_VIDEO_CLASS=m
CONFIG_USB_VIDEO_CLASS_INPUT_EVDEV=y
CONFIG_USB_GSPCA=m
# CONFIG_USB_M5602 is not set
# CONFIG_USB_STV06XX is not set
CONFIG_USB_GL860=m
CONFIG_USB_GSPCA_BENQ=m
CONFIG_USB_GSPCA_CONEX=m
CONFIG_USB_GSPCA_CPIA1=m
# CONFIG_USB_GSPCA_ETOMS is not set
# CONFIG_USB_GSPCA_FINEPIX is not set
CONFIG_USB_GSPCA_JEILINJ=m
# CONFIG_USB_GSPCA_JL2005BCD is not set
CONFIG_USB_GSPCA_KINECT=m
CONFIG_USB_GSPCA_KONICA=m
# CONFIG_USB_GSPCA_MARS is not set
CONFIG_USB_GSPCA_MR97310A=m
CONFIG_USB_GSPCA_NW80X=m
CONFIG_USB_GSPCA_OV519=m
CONFIG_USB_GSPCA_OV534=m
# CONFIG_USB_GSPCA_OV534_9 is not set
# CONFIG_USB_GSPCA_PAC207 is not set
CONFIG_USB_GSPCA_PAC7302=m
CONFIG_USB_GSPCA_PAC7311=m
CONFIG_USB_GSPCA_SE401=m
CONFIG_USB_GSPCA_SN9C2028=m
# CONFIG_USB_GSPCA_SN9C20X is not set
CONFIG_USB_GSPCA_SONIXB=m
# CONFIG_USB_GSPCA_SONIXJ is not set
CONFIG_USB_GSPCA_SPCA500=m
CONFIG_USB_GSPCA_SPCA501=m
# CONFIG_USB_GSPCA_SPCA505 is not set
# CONFIG_USB_GSPCA_SPCA506 is not set
CONFIG_USB_GSPCA_SPCA508=m
CONFIG_USB_GSPCA_SPCA561=m
CONFIG_USB_GSPCA_SPCA1528=m
# CONFIG_USB_GSPCA_SQ905 is not set
CONFIG_USB_GSPCA_SQ905C=m
CONFIG_USB_GSPCA_SQ930X=m
CONFIG_USB_GSPCA_STK014=m
CONFIG_USB_GSPCA_STK1135=m
CONFIG_USB_GSPCA_STV0680=m
CONFIG_USB_GSPCA_SUNPLUS=m
CONFIG_USB_GSPCA_T613=m
# CONFIG_USB_GSPCA_TOPRO is not set
# CONFIG_USB_GSPCA_TV8532 is not set
CONFIG_USB_GSPCA_VC032X=m
CONFIG_USB_GSPCA_VICAM=m
CONFIG_USB_GSPCA_XIRLINK_CIT=m
# CONFIG_USB_GSPCA_ZC3XX is not set
CONFIG_USB_PWC=m
# CONFIG_USB_PWC_DEBUG is not set
CONFIG_USB_PWC_INPUT_EVDEV=y
CONFIG_VIDEO_CPIA2=m
# CONFIG_USB_ZR364XX is not set
CONFIG_USB_STKWEBCAM=m
# CONFIG_USB_S2255 is not set
CONFIG_USB_SN9C102=m
CONFIG_VIDEO_USBTV=m

#
# Analog/digital TV USB devices
#
CONFIG_VIDEO_AU0828=m
CONFIG_VIDEO_AU0828_V4L2=y

#
# Digital TV USB devices
#
# CONFIG_DVB_USB_V2 is not set
CONFIG_DVB_TTUSB_BUDGET=m
# CONFIG_DVB_TTUSB_DEC is not set
CONFIG_SMS_USB_DRV=m
CONFIG_DVB_B2C2_FLEXCOP_USB=m
CONFIG_DVB_B2C2_FLEXCOP_USB_DEBUG=y

#
# Webcam, TV (analog/digital) USB devices
#
CONFIG_VIDEO_EM28XX=m
CONFIG_VIDEO_EM28XX_DVB=m
# CONFIG_MEDIA_PCI_SUPPORT is not set
CONFIG_V4L_PLATFORM_DRIVERS=y
CONFIG_VIDEO_CAFE_CCIC=m
# CONFIG_VIDEO_VIA_CAMERA is not set
CONFIG_VIDEO_TIMBERDALE=m
# CONFIG_SOC_CAMERA is not set
# CONFIG_V4L_MEM2MEM_DRIVERS is not set
CONFIG_V4L_TEST_DRIVERS=y
# CONFIG_VIDEO_VIVI is not set
CONFIG_VIDEO_MEM2MEM_TESTDEV=m

#
# Supported MMC/SDIO adapters
#
CONFIG_SMS_SDIO_DRV=m
CONFIG_MEDIA_PARPORT_SUPPORT=y
CONFIG_VIDEO_PMS=m
CONFIG_MEDIA_COMMON_OPTIONS=y

#
# common driver options
#
CONFIG_VIDEO_TVEEPROM=m
CONFIG_CYPRESS_FIRMWARE=m
CONFIG_DVB_B2C2_FLEXCOP=m
CONFIG_DVB_B2C2_FLEXCOP_DEBUG=y
CONFIG_SMS_SIANO_MDTV=m

#
# Media ancillary drivers (tuners, sensors, i2c, frontends)
#
CONFIG_MEDIA_SUBDRV_AUTOSELECT=y
CONFIG_MEDIA_ATTACH=y

#
# Audio decoders, processors and mixers
#
CONFIG_VIDEO_MSP3400=m

#
# RDS decoders
#

#
# Video decoders
#
CONFIG_VIDEO_ADV7180=m
CONFIG_VIDEO_SAA711X=m
CONFIG_VIDEO_TVP5150=m

#
# Video and audio decoders
#

#
# Video encoders
#

#
# Camera sensor devices
#
CONFIG_VIDEO_OV7670=m
CONFIG_VIDEO_MT9V011=m

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
CONFIG_MEDIA_TUNER_SIMPLE=m
CONFIG_MEDIA_TUNER_TDA18271=m
CONFIG_MEDIA_TUNER_TDA9887=m
CONFIG_MEDIA_TUNER_QT1010=m
CONFIG_MEDIA_TUNER_XC5000=m
CONFIG_MEDIA_TUNER_MXL5007T=m

#
# Multistandard (satellite) frontends
#

#
# Multistandard (cable + terrestrial) frontends
#
CONFIG_DVB_DRXK=m
CONFIG_DVB_TDA18271C2DD=m

#
# DVB-S (satellite) frontends
#
CONFIG_DVB_CX24123=m
CONFIG_DVB_MT312=m
CONFIG_DVB_S5H1420=m
CONFIG_DVB_STV0299=m
CONFIG_DVB_TDA8083=m
CONFIG_DVB_TUNER_ITD1000=m
CONFIG_DVB_TUNER_CX24113=m
CONFIG_DVB_TDA10071=m

#
# DVB-T (terrestrial) frontends
#
CONFIG_DVB_CX22700=m
CONFIG_DVB_DRXD=m
CONFIG_DVB_TDA1004X=m
CONFIG_DVB_MT352=m
CONFIG_DVB_ZL10353=m
CONFIG_DVB_CXD2820R=m

#
# DVB-C (cable) frontends
#
CONFIG_DVB_VES1820=m
CONFIG_DVB_TDA10023=m
CONFIG_DVB_STV0297=m

#
# ATSC (North American/Korean Terrestrial/Cable DTV) frontends
#
CONFIG_DVB_NXT200X=m
CONFIG_DVB_BCM3510=m
CONFIG_DVB_LGDT330X=m
CONFIG_DVB_LGDT3305=m
CONFIG_DVB_S5H1409=m
CONFIG_DVB_AU8522=m
CONFIG_DVB_AU8522_DTV=m
CONFIG_DVB_AU8522_V4L=m

#
# ISDB-T (terrestrial) frontends
#
CONFIG_DVB_S921=m
CONFIG_DVB_MB86A20S=m

#
# Digital terrestrial only tuners/PLL
#
CONFIG_DVB_PLL=m

#
# SEC control devices for DVB-S
#
CONFIG_DVB_LNBP21=m
CONFIG_DVB_ISL6421=m
CONFIG_DVB_A8293=m

#
# Tools to develop new frontends
#
# CONFIG_DVB_DUMMY_FE is not set

#
# Graphics support
#
CONFIG_AGP=y
CONFIG_AGP_ALI=m
CONFIG_AGP_ATI=m
CONFIG_AGP_AMD=m
CONFIG_AGP_AMD64=m
CONFIG_AGP_INTEL=y
# CONFIG_AGP_NVIDIA is not set
CONFIG_AGP_SIS=y
CONFIG_AGP_SWORKS=m
# CONFIG_AGP_VIA is not set
CONFIG_AGP_EFFICEON=y
CONFIG_VGA_ARB=y
CONFIG_VGA_ARB_MAX_GPUS=16
# CONFIG_VGA_SWITCHEROO is not set
CONFIG_DRM=y
CONFIG_DRM_USB=y
CONFIG_DRM_KMS_HELPER=y
CONFIG_DRM_KMS_FB_HELPER=y
CONFIG_DRM_LOAD_EDID_FIRMWARE=y
CONFIG_DRM_TTM=y

#
# I2C encoder or helper chips
#
CONFIG_DRM_I2C_CH7006=m
# CONFIG_DRM_I2C_SIL164 is not set
# CONFIG_DRM_I2C_NXP_TDA998X is not set
CONFIG_DRM_TDFX=y
CONFIG_DRM_R128=y
# CONFIG_DRM_RADEON is not set
CONFIG_DRM_NOUVEAU=y
CONFIG_NOUVEAU_DEBUG=5
CONFIG_NOUVEAU_DEBUG_DEFAULT=3
CONFIG_DRM_NOUVEAU_BACKLIGHT=y
CONFIG_DRM_I810=m
CONFIG_DRM_I915=y
# CONFIG_DRM_I915_KMS is not set
# CONFIG_DRM_I915_FBDEV is not set
CONFIG_DRM_I915_PRELIMINARY_HW_SUPPORT=y
CONFIG_DRM_MGA=m
CONFIG_DRM_SIS=m
# CONFIG_DRM_VIA is not set
# CONFIG_DRM_SAVAGE is not set
# CONFIG_DRM_VMWGFX is not set
# CONFIG_DRM_GMA500 is not set
CONFIG_DRM_UDL=y
CONFIG_DRM_AST=y
CONFIG_DRM_MGAG200=m
CONFIG_DRM_CIRRUS_QEMU=y
CONFIG_DRM_QXL=y
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
CONFIG_FB_BOTH_ENDIAN=y
# CONFIG_FB_BIG_ENDIAN is not set
# CONFIG_FB_LITTLE_ENDIAN is not set
CONFIG_FB_SYS_FOPS=y
CONFIG_FB_DEFERRED_IO=y
CONFIG_FB_HECUBA=m
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
CONFIG_FB_PM2_FIFO_DISCONNECT=y
CONFIG_FB_CYBER2000=y
# CONFIG_FB_CYBER2000_DDC is not set
CONFIG_FB_ARC=y
# CONFIG_FB_ASILIANT is not set
CONFIG_FB_IMSTT=y
# CONFIG_FB_VGA16 is not set
CONFIG_FB_VESA=y
CONFIG_FB_N411=m
CONFIG_FB_HGA=y
CONFIG_FB_S1D13XXX=y
# CONFIG_FB_NVIDIA is not set
CONFIG_FB_RIVA=y
# CONFIG_FB_RIVA_I2C is not set
CONFIG_FB_RIVA_DEBUG=y
# CONFIG_FB_RIVA_BACKLIGHT is not set
CONFIG_FB_I740=y
# CONFIG_FB_I810 is not set
CONFIG_FB_LE80578=m
# CONFIG_FB_CARILLO_RANCH is not set
# CONFIG_FB_MATROX is not set
CONFIG_FB_RADEON=m
CONFIG_FB_RADEON_I2C=y
CONFIG_FB_RADEON_BACKLIGHT=y
CONFIG_FB_RADEON_DEBUG=y
CONFIG_FB_ATY128=y
CONFIG_FB_ATY128_BACKLIGHT=y
CONFIG_FB_ATY=y
# CONFIG_FB_ATY_CT is not set
# CONFIG_FB_ATY_GX is not set
# CONFIG_FB_ATY_BACKLIGHT is not set
# CONFIG_FB_S3 is not set
# CONFIG_FB_SAVAGE is not set
CONFIG_FB_SIS=y
CONFIG_FB_SIS_300=y
# CONFIG_FB_SIS_315 is not set
CONFIG_FB_VIA=y
CONFIG_FB_VIA_DIRECT_PROCFS=y
# CONFIG_FB_VIA_X_COMPATIBILITY is not set
CONFIG_FB_NEOMAGIC=m
# CONFIG_FB_KYRO is not set
CONFIG_FB_3DFX=y
# CONFIG_FB_3DFX_ACCEL is not set
# CONFIG_FB_3DFX_I2C is not set
CONFIG_FB_VOODOO1=m
CONFIG_FB_VT8623=m
# CONFIG_FB_TRIDENT is not set
CONFIG_FB_ARK=y
CONFIG_FB_PM3=y
# CONFIG_FB_CARMINE is not set
# CONFIG_FB_GEODE is not set
CONFIG_FB_TMIO=m
CONFIG_FB_TMIO_ACCELL=y
CONFIG_FB_SM501=m
CONFIG_FB_SMSCUFX=y
# CONFIG_FB_UDL is not set
CONFIG_FB_GOLDFISH=m
CONFIG_FB_VIRTUAL=y
CONFIG_FB_METRONOME=m
# CONFIG_FB_MB862XX is not set
CONFIG_FB_BROADSHEET=m
CONFIG_FB_AUO_K190X=y
CONFIG_FB_AUO_K1900=y
CONFIG_FB_AUO_K1901=m
CONFIG_FB_SIMPLE=y
# CONFIG_EXYNOS_VIDEO is not set
CONFIG_BACKLIGHT_LCD_SUPPORT=y
CONFIG_LCD_CLASS_DEVICE=m
CONFIG_LCD_L4F00242T03=m
CONFIG_LCD_LMS283GF05=m
# CONFIG_LCD_LTV350QV is not set
CONFIG_LCD_ILI922X=m
CONFIG_LCD_ILI9320=m
CONFIG_LCD_TDO24M=m
# CONFIG_LCD_VGG2432A4 is not set
CONFIG_LCD_PLATFORM=m
# CONFIG_LCD_S6E63M0 is not set
CONFIG_LCD_LD9040=m
# CONFIG_LCD_AMS369FG06 is not set
CONFIG_LCD_LMS501KF03=m
CONFIG_LCD_HX8357=m
CONFIG_BACKLIGHT_CLASS_DEVICE=y
CONFIG_BACKLIGHT_GENERIC=m
CONFIG_BACKLIGHT_LM3533=m
# CONFIG_BACKLIGHT_CARILLO_RANCH is not set
CONFIG_BACKLIGHT_PWM=y
# CONFIG_BACKLIGHT_APPLE is not set
# CONFIG_BACKLIGHT_SAHARA is not set
CONFIG_BACKLIGHT_WM831X=m
# CONFIG_BACKLIGHT_ADP8860 is not set
CONFIG_BACKLIGHT_ADP8870=y
CONFIG_BACKLIGHT_88PM860X=y
# CONFIG_BACKLIGHT_PCF50633 is not set
# CONFIG_BACKLIGHT_LM3630A is not set
# CONFIG_BACKLIGHT_LM3639 is not set
CONFIG_BACKLIGHT_LP855X=m
CONFIG_BACKLIGHT_PANDORA=y
CONFIG_BACKLIGHT_GPIO=m
CONFIG_BACKLIGHT_LV5207LP=y
CONFIG_BACKLIGHT_BD6107=y

#
# Console display driver support
#
CONFIG_VGA_CONSOLE=y
CONFIG_VGACON_SOFT_SCROLLBACK=y
CONFIG_VGACON_SOFT_SCROLLBACK_SIZE=64
CONFIG_MDA_CONSOLE=y
CONFIG_DUMMY_CONSOLE=y
CONFIG_FRAMEBUFFER_CONSOLE=y
CONFIG_FRAMEBUFFER_CONSOLE_DETECT_PRIMARY=y
# CONFIG_FRAMEBUFFER_CONSOLE_ROTATION is not set
# CONFIG_LOGO is not set
# CONFIG_SOUND is not set

#
# HID support
#
CONFIG_HID=y
# CONFIG_HID_BATTERY_STRENGTH is not set
# CONFIG_HIDRAW is not set
# CONFIG_UHID is not set
CONFIG_HID_GENERIC=y

#
# Special HID drivers
#
CONFIG_HID_A4TECH=y
CONFIG_HID_ACRUX=m
CONFIG_HID_ACRUX_FF=y
CONFIG_HID_APPLE=y
# CONFIG_HID_AUREAL is not set
CONFIG_HID_BELKIN=y
CONFIG_HID_CHERRY=y
CONFIG_HID_CHICONY=y
CONFIG_HID_CYPRESS=y
CONFIG_HID_DRAGONRISE=y
CONFIG_DRAGONRISE_FF=y
CONFIG_HID_EMS_FF=m
CONFIG_HID_ELECOM=m
CONFIG_HID_EZKEY=y
CONFIG_HID_KEYTOUCH=y
CONFIG_HID_KYE=y
# CONFIG_HID_UCLOGIC is not set
CONFIG_HID_WALTOP=y
# CONFIG_HID_GYRATION is not set
CONFIG_HID_ICADE=m
# CONFIG_HID_TWINHAN is not set
CONFIG_HID_KENSINGTON=y
CONFIG_HID_LCPOWER=y
# CONFIG_HID_LENOVO_TPKBD is not set
CONFIG_HID_LOGITECH=y
# CONFIG_HID_LOGITECH_DJ is not set
CONFIG_LOGITECH_FF=y
CONFIG_LOGIRUMBLEPAD2_FF=y
CONFIG_LOGIG940_FF=y
# CONFIG_LOGIWHEELS_FF is not set
CONFIG_HID_MAGICMOUSE=y
CONFIG_HID_MICROSOFT=y
CONFIG_HID_MONTEREY=y
CONFIG_HID_MULTITOUCH=y
CONFIG_HID_ORTEK=y
CONFIG_HID_PANTHERLORD=y
CONFIG_PANTHERLORD_FF=y
CONFIG_HID_PETALYNX=m
CONFIG_HID_PICOLCD=y
CONFIG_HID_PICOLCD_FB=y
CONFIG_HID_PICOLCD_BACKLIGHT=y
CONFIG_HID_PICOLCD_LEDS=y
# CONFIG_HID_PRIMAX is not set
CONFIG_HID_SAITEK=m
CONFIG_HID_SAMSUNG=m
CONFIG_HID_SPEEDLINK=m
# CONFIG_HID_STEELSERIES is not set
# CONFIG_HID_SUNPLUS is not set
# CONFIG_HID_GREENASIA is not set
CONFIG_HID_SMARTJOYPLUS=y
CONFIG_SMARTJOYPLUS_FF=y
# CONFIG_HID_TIVO is not set
CONFIG_HID_TOPSEED=y
CONFIG_HID_THINGM=y
CONFIG_HID_THRUSTMASTER=y
# CONFIG_THRUSTMASTER_FF is not set
CONFIG_HID_WACOM=y
CONFIG_HID_WIIMOTE=m
# CONFIG_HID_XINMO is not set
CONFIG_HID_ZEROPLUS=y
CONFIG_ZEROPLUS_FF=y
CONFIG_HID_ZYDACRON=m
CONFIG_HID_SENSOR_HUB=m

#
# USB HID support
#
# CONFIG_USB_HID is not set
CONFIG_HID_PID=y

#
# I2C HID support
#
CONFIG_I2C_HID=m
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
CONFIG_USB_DYNAMIC_MINORS=y
CONFIG_USB_OTG=y
# CONFIG_USB_OTG_WHITELIST is not set
CONFIG_USB_OTG_BLACKLIST_HUB=y
CONFIG_USB_MON=y
CONFIG_USB_WUSB_CBAF=m
# CONFIG_USB_WUSB_CBAF_DEBUG is not set

#
# USB Host Controller Drivers
#
CONFIG_USB_C67X00_HCD=y
CONFIG_USB_XHCI_HCD=m
# CONFIG_USB_EHCI_HCD is not set
CONFIG_USB_OXU210HP_HCD=m
# CONFIG_USB_ISP116X_HCD is not set
CONFIG_USB_ISP1760_HCD=y
CONFIG_USB_ISP1362_HCD=y
# CONFIG_USB_FUSBH200_HCD is not set
CONFIG_USB_FOTG210_HCD=m
CONFIG_USB_OHCI_HCD=y
# CONFIG_USB_OHCI_HCD_PCI is not set
CONFIG_USB_OHCI_HCD_PLATFORM=y
CONFIG_USB_UHCI_HCD=y
# CONFIG_USB_SL811_HCD is not set
CONFIG_USB_R8A66597_HCD=m
CONFIG_USB_HCD_BCMA=m
# CONFIG_USB_HCD_TEST_MODE is not set

#
# USB Device Class drivers
#
# CONFIG_USB_ACM is not set
CONFIG_USB_PRINTER=y
# CONFIG_USB_WDM is not set
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
CONFIG_USB_MDC800=y
# CONFIG_USB_DWC3 is not set

#
# USB port drivers
#
# CONFIG_USB_SERIAL is not set

#
# USB Miscellaneous drivers
#
CONFIG_USB_EMI62=y
# CONFIG_USB_EMI26 is not set
CONFIG_USB_ADUTUX=y
CONFIG_USB_SEVSEG=y
CONFIG_USB_RIO500=m
CONFIG_USB_LEGOTOWER=y
# CONFIG_USB_LCD is not set
# CONFIG_USB_LED is not set
CONFIG_USB_CYPRESS_CY7C63=m
CONFIG_USB_CYTHERM=m
CONFIG_USB_IDMOUSE=m
# CONFIG_USB_FTDI_ELAN is not set
# CONFIG_USB_APPLEDISPLAY is not set
# CONFIG_USB_LD is not set
# CONFIG_USB_TRANCEVIBRATOR is not set
CONFIG_USB_IOWARRIOR=m
CONFIG_USB_TEST=m
# CONFIG_USB_EHSET_TEST_FIXTURE is not set
CONFIG_USB_ISIGHTFW=m
CONFIG_USB_YUREX=m
CONFIG_USB_EZUSB_FX2=m
# CONFIG_USB_HSIC_USB3503 is not set

#
# USB Physical Layer drivers
#
CONFIG_USB_PHY=y
CONFIG_NOP_USB_XCEIV=y
# CONFIG_OMAP_CONTROL_USB is not set
# CONFIG_OMAP_USB3 is not set
CONFIG_AM335X_CONTROL_USB=y
CONFIG_AM335X_PHY_USB=y
CONFIG_SAMSUNG_USBPHY=y
CONFIG_SAMSUNG_USB2PHY=y
CONFIG_SAMSUNG_USB3PHY=y
CONFIG_USB_GPIO_VBUS=y
CONFIG_USB_ISP1301=m
# CONFIG_USB_RCAR_PHY is not set
CONFIG_USB_RCAR_GEN2_PHY=y
# CONFIG_USB_GADGET is not set
# CONFIG_UWB is not set
CONFIG_MMC=y
# CONFIG_MMC_DEBUG is not set
# CONFIG_MMC_UNSAFE_RESUME is not set
CONFIG_MMC_CLKGATE=y

#
# MMC/SD/SDIO Card Drivers
#
# CONFIG_MMC_BLOCK is not set
CONFIG_SDIO_UART=y
CONFIG_MMC_TEST=y

#
# MMC/SD/SDIO Host Controller Drivers
#
# CONFIG_MMC_SDHCI is not set
CONFIG_MMC_OMAP_HS=m
CONFIG_MMC_WBSD=y
# CONFIG_MMC_TIFM_SD is not set
# CONFIG_MMC_GOLDFISH is not set
# CONFIG_MMC_SDRICOH_CS is not set
CONFIG_MMC_CB710=y
CONFIG_MMC_VIA_SDMMC=m
CONFIG_MMC_VUB300=y
# CONFIG_MMC_USHC is not set
# CONFIG_MMC_REALTEK_PCI is not set
CONFIG_MEMSTICK=m
CONFIG_MEMSTICK_DEBUG=y

#
# MemoryStick drivers
#
CONFIG_MEMSTICK_UNSAFE_RESUME=y
# CONFIG_MSPRO_BLOCK is not set
# CONFIG_MS_BLOCK is not set

#
# MemoryStick Host Controller Drivers
#
# CONFIG_MEMSTICK_TIFM_MS is not set
CONFIG_MEMSTICK_JMICRON_38X=m
# CONFIG_MEMSTICK_R592 is not set
# CONFIG_MEMSTICK_REALTEK_PCI is not set
CONFIG_NEW_LEDS=y
CONFIG_LEDS_CLASS=y

#
# LED drivers
#
# CONFIG_LEDS_88PM860X is not set
CONFIG_LEDS_LM3530=m
CONFIG_LEDS_LM3533=y
CONFIG_LEDS_LM3642=m
# CONFIG_LEDS_NET48XX is not set
CONFIG_LEDS_WRAP=m
CONFIG_LEDS_PCA9532=m
# CONFIG_LEDS_PCA9532_GPIO is not set
CONFIG_LEDS_GPIO=m
CONFIG_LEDS_LP3944=y
CONFIG_LEDS_LP55XX_COMMON=y
CONFIG_LEDS_LP5521=y
CONFIG_LEDS_LP5523=m
# CONFIG_LEDS_LP5562 is not set
CONFIG_LEDS_LP8501=y
CONFIG_LEDS_CLEVO_MAIL=y
# CONFIG_LEDS_PCA955X is not set
# CONFIG_LEDS_PCA963X is not set
# CONFIG_LEDS_PCA9685 is not set
CONFIG_LEDS_WM831X_STATUS=y
CONFIG_LEDS_DAC124S085=y
CONFIG_LEDS_PWM=m
CONFIG_LEDS_REGULATOR=m
# CONFIG_LEDS_BD2802 is not set
# CONFIG_LEDS_INTEL_SS4200 is not set
CONFIG_LEDS_LT3593=y
# CONFIG_LEDS_DELL_NETBOOKS is not set
# CONFIG_LEDS_MC13783 is not set
CONFIG_LEDS_TCA6507=m
# CONFIG_LEDS_LM355x is not set
# CONFIG_LEDS_OT200 is not set
CONFIG_LEDS_BLINKM=y

#
# LED Triggers
#
CONFIG_LEDS_TRIGGERS=y
CONFIG_LEDS_TRIGGER_TIMER=m
CONFIG_LEDS_TRIGGER_ONESHOT=y
# CONFIG_LEDS_TRIGGER_HEARTBEAT is not set
CONFIG_LEDS_TRIGGER_BACKLIGHT=m
CONFIG_LEDS_TRIGGER_CPU=y
# CONFIG_LEDS_TRIGGER_GPIO is not set
CONFIG_LEDS_TRIGGER_DEFAULT_ON=m

#
# iptables trigger is under Netfilter config (LED target)
#
CONFIG_LEDS_TRIGGER_TRANSIENT=m
# CONFIG_LEDS_TRIGGER_CAMERA is not set
CONFIG_ACCESSIBILITY=y
# CONFIG_A11Y_BRAILLE_CONSOLE is not set
# CONFIG_INFINIBAND is not set
# CONFIG_EDAC is not set
CONFIG_RTC_LIB=y
CONFIG_RTC_CLASS=y
CONFIG_RTC_HCTOSYS=y
# CONFIG_RTC_SYSTOHC is not set
CONFIG_RTC_HCTOSYS_DEVICE="rtc0"
# CONFIG_RTC_DEBUG is not set

#
# RTC interfaces
#
CONFIG_RTC_INTF_SYSFS=y
CONFIG_RTC_INTF_PROC=y
CONFIG_RTC_INTF_DEV=y
CONFIG_RTC_INTF_DEV_UIE_EMUL=y
# CONFIG_RTC_DRV_TEST is not set

#
# I2C RTC drivers
#
CONFIG_RTC_DRV_88PM860X=m
# CONFIG_RTC_DRV_DS1307 is not set
# CONFIG_RTC_DRV_DS1374 is not set
CONFIG_RTC_DRV_DS1672=m
CONFIG_RTC_DRV_DS3232=y
# CONFIG_RTC_DRV_MAX6900 is not set
CONFIG_RTC_DRV_MAX8907=m
CONFIG_RTC_DRV_RS5C372=m
# CONFIG_RTC_DRV_ISL1208 is not set
CONFIG_RTC_DRV_ISL12022=y
# CONFIG_RTC_DRV_X1205 is not set
CONFIG_RTC_DRV_PALMAS=m
CONFIG_RTC_DRV_PCF2127=y
# CONFIG_RTC_DRV_PCF8523 is not set
CONFIG_RTC_DRV_PCF8563=m
CONFIG_RTC_DRV_PCF8583=m
CONFIG_RTC_DRV_M41T80=m
# CONFIG_RTC_DRV_M41T80_WDT is not set
CONFIG_RTC_DRV_BQ32K=y
CONFIG_RTC_DRV_TWL4030=y
CONFIG_RTC_DRV_TPS65910=y
CONFIG_RTC_DRV_RC5T583=y
CONFIG_RTC_DRV_S35390A=y
CONFIG_RTC_DRV_FM3130=m
CONFIG_RTC_DRV_RX8581=m
CONFIG_RTC_DRV_RX8025=m
CONFIG_RTC_DRV_EM3027=y
CONFIG_RTC_DRV_RV3029C2=m
CONFIG_RTC_DRV_S5M=y

#
# SPI RTC drivers
#
CONFIG_RTC_DRV_M41T93=m
CONFIG_RTC_DRV_M41T94=m
CONFIG_RTC_DRV_DS1305=y
CONFIG_RTC_DRV_DS1390=m
CONFIG_RTC_DRV_MAX6902=m
CONFIG_RTC_DRV_R9701=m
# CONFIG_RTC_DRV_RS5C348 is not set
CONFIG_RTC_DRV_DS3234=y
CONFIG_RTC_DRV_PCF2123=y
CONFIG_RTC_DRV_RX4581=m

#
# Platform RTC drivers
#
CONFIG_RTC_DRV_CMOS=m
CONFIG_RTC_DRV_DS1286=m
CONFIG_RTC_DRV_DS1511=y
CONFIG_RTC_DRV_DS1553=m
CONFIG_RTC_DRV_DS1742=y
CONFIG_RTC_DRV_DA9055=m
CONFIG_RTC_DRV_STK17TA8=y
# CONFIG_RTC_DRV_M48T86 is not set
# CONFIG_RTC_DRV_M48T35 is not set
CONFIG_RTC_DRV_M48T59=m
# CONFIG_RTC_DRV_MSM6242 is not set
CONFIG_RTC_DRV_BQ4802=y
# CONFIG_RTC_DRV_RP5C01 is not set
CONFIG_RTC_DRV_V3020=m
CONFIG_RTC_DRV_DS2404=y
CONFIG_RTC_DRV_WM831X=y
CONFIG_RTC_DRV_PCF50633=y

#
# on-CPU RTC drivers
#
CONFIG_RTC_DRV_MC13XXX=m
CONFIG_RTC_DRV_MOXART=m

#
# HID Sensor RTC drivers
#
CONFIG_DMADEVICES=y
# CONFIG_DMADEVICES_DEBUG is not set

#
# DMA Devices
#
CONFIG_INTEL_MID_DMAC=y
CONFIG_INTEL_IOATDMA=m
CONFIG_DW_DMAC_CORE=m
# CONFIG_DW_DMAC is not set
# CONFIG_DW_DMAC_PCI is not set
CONFIG_TIMB_DMA=m
CONFIG_PCH_DMA=m
CONFIG_DMA_ENGINE=y
CONFIG_DMA_ACPI=y

#
# DMA Clients
#
# CONFIG_ASYNC_TX_DMA is not set
CONFIG_DMATEST=m
CONFIG_DMA_ENGINE_RAID=y
CONFIG_DCA=m
# CONFIG_AUXDISPLAY is not set
CONFIG_UIO=y
CONFIG_UIO_CIF=m
CONFIG_UIO_PDRV_GENIRQ=y
CONFIG_UIO_DMEM_GENIRQ=m
# CONFIG_UIO_AEC is not set
# CONFIG_UIO_SERCOS3 is not set
CONFIG_UIO_PCI_GENERIC=m
# CONFIG_UIO_NETX is not set
CONFIG_UIO_MF624=m
# CONFIG_VIRT_DRIVERS is not set
CONFIG_VIRTIO=y

#
# Virtio drivers
#
CONFIG_VIRTIO_PCI=m
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
CONFIG_ECHO=m
CONFIG_COMEDI=m
CONFIG_COMEDI_DEBUG=y
CONFIG_COMEDI_DEFAULT_BUF_SIZE_KB=2048
CONFIG_COMEDI_DEFAULT_BUF_MAXSIZE_KB=20480
# CONFIG_COMEDI_MISC_DRIVERS is not set
# CONFIG_COMEDI_ISA_DRIVERS is not set
CONFIG_COMEDI_PCI_DRIVERS=y
CONFIG_COMEDI_8255_PCI=m
CONFIG_COMEDI_ADDI_WATCHDOG=m
CONFIG_COMEDI_ADDI_APCI_035=m
CONFIG_COMEDI_ADDI_APCI_1032=m
# CONFIG_COMEDI_ADDI_APCI_1500 is not set
# CONFIG_COMEDI_ADDI_APCI_1516 is not set
# CONFIG_COMEDI_ADDI_APCI_1564 is not set
CONFIG_COMEDI_ADDI_APCI_16XX=m
CONFIG_COMEDI_ADDI_APCI_2032=m
CONFIG_COMEDI_ADDI_APCI_2200=m
CONFIG_COMEDI_ADDI_APCI_3120=m
# CONFIG_COMEDI_ADDI_APCI_3501 is not set
CONFIG_COMEDI_ADDI_APCI_3XXX=m
CONFIG_COMEDI_ADL_PCI6208=m
# CONFIG_COMEDI_ADL_PCI7X3X is not set
# CONFIG_COMEDI_ADL_PCI8164 is not set
CONFIG_COMEDI_ADL_PCI9111=m
CONFIG_COMEDI_ADL_PCI9118=m
CONFIG_COMEDI_ADV_PCI1710=m
CONFIG_COMEDI_ADV_PCI1723=m
CONFIG_COMEDI_ADV_PCI1724=m
CONFIG_COMEDI_ADV_PCI_DIO=m
CONFIG_COMEDI_AMPLC_DIO200_PCI=m
CONFIG_COMEDI_AMPLC_PC236_PCI=m
CONFIG_COMEDI_AMPLC_PC263_PCI=m
# CONFIG_COMEDI_AMPLC_PCI224 is not set
# CONFIG_COMEDI_AMPLC_PCI230 is not set
CONFIG_COMEDI_CONTEC_PCI_DIO=m
# CONFIG_COMEDI_DAS08_PCI is not set
# CONFIG_COMEDI_DT3000 is not set
CONFIG_COMEDI_DYNA_PCI10XX=m
CONFIG_COMEDI_GSC_HPDI=m
CONFIG_COMEDI_ICP_MULTI=m
# CONFIG_COMEDI_DAQBOARD2000 is not set
CONFIG_COMEDI_JR3_PCI=m
CONFIG_COMEDI_KE_COUNTER=m
CONFIG_COMEDI_CB_PCIDAS64=m
# CONFIG_COMEDI_CB_PCIDAS is not set
# CONFIG_COMEDI_CB_PCIDDA is not set
CONFIG_COMEDI_CB_PCIMDAS=m
CONFIG_COMEDI_CB_PCIMDDA=m
CONFIG_COMEDI_ME4000=m
CONFIG_COMEDI_ME_DAQ=m
# CONFIG_COMEDI_NI_6527 is not set
# CONFIG_COMEDI_NI_65XX is not set
# CONFIG_COMEDI_NI_660X is not set
CONFIG_COMEDI_NI_670X=m
# CONFIG_COMEDI_NI_LABPC_PCI is not set
CONFIG_COMEDI_NI_PCIDIO=m
CONFIG_COMEDI_NI_PCIMIO=m
CONFIG_COMEDI_RTD520=m
CONFIG_COMEDI_S626=m
CONFIG_COMEDI_MITE=m
CONFIG_COMEDI_NI_TIOCMD=m
CONFIG_COMEDI_PCMCIA_DRIVERS=y
CONFIG_COMEDI_CB_DAS16_CS=m
CONFIG_COMEDI_DAS08_CS=m
CONFIG_COMEDI_NI_DAQ_700_CS=m
CONFIG_COMEDI_NI_DAQ_DIO24_CS=m
CONFIG_COMEDI_NI_LABPC_CS=m
CONFIG_COMEDI_NI_MIO_CS=m
CONFIG_COMEDI_QUATECH_DAQP_CS=m
CONFIG_COMEDI_USB_DRIVERS=y
CONFIG_COMEDI_DT9812=m
CONFIG_COMEDI_USBDUX=m
# CONFIG_COMEDI_USBDUXFAST is not set
CONFIG_COMEDI_USBDUXSIGMA=m
CONFIG_COMEDI_VMK80XX=m
CONFIG_COMEDI_8255=m
CONFIG_COMEDI_FC=m
CONFIG_COMEDI_AMPLC_DIO200=m
CONFIG_COMEDI_AMPLC_PC236=m
CONFIG_COMEDI_DAS08=m
CONFIG_COMEDI_NI_LABPC=m
CONFIG_COMEDI_NI_TIO=m
# CONFIG_TRANZPORT is not set
CONFIG_DX_SEP=y
CONFIG_ZSMALLOC=y
# CONFIG_ZRAM is not set
# CONFIG_FB_SM7XX is not set
# CONFIG_CRYSTALHD is not set
CONFIG_FB_XGI=y
# CONFIG_ACPI_QUICKSTART is not set
CONFIG_BCM_WIMAX=y
CONFIG_FT1000=y
CONFIG_FT1000_USB=y
CONFIG_FT1000_PCMCIA=m

#
# Speakup console speech
#
CONFIG_SPEAKUP=m
CONFIG_SPEAKUP_SYNTH_ACNTSA=m
# CONFIG_SPEAKUP_SYNTH_ACNTPC is not set
# CONFIG_SPEAKUP_SYNTH_APOLLO is not set
# CONFIG_SPEAKUP_SYNTH_AUDPTR is not set
# CONFIG_SPEAKUP_SYNTH_BNS is not set
CONFIG_SPEAKUP_SYNTH_DECTLK=m
# CONFIG_SPEAKUP_SYNTH_DECEXT is not set
# CONFIG_SPEAKUP_SYNTH_DECPC is not set
CONFIG_SPEAKUP_SYNTH_DTLK=m
CONFIG_SPEAKUP_SYNTH_KEYPC=m
# CONFIG_SPEAKUP_SYNTH_LTLK is not set
CONFIG_SPEAKUP_SYNTH_SOFT=m
CONFIG_SPEAKUP_SYNTH_SPKOUT=m
CONFIG_SPEAKUP_SYNTH_TXPRT=m
CONFIG_SPEAKUP_SYNTH_DUMMY=m
# CONFIG_TOUCHSCREEN_CLEARPAD_TM1217 is not set
# CONFIG_TOUCHSCREEN_SYNAPTICS_I2C_RMI4 is not set
CONFIG_STAGING_MEDIA=y
CONFIG_DVB_AS102=m
CONFIG_DVB_CXD2099=m
CONFIG_VIDEO_DT3155=m
# CONFIG_DT3155_CCIR is not set
# CONFIG_DT3155_STREAMING is not set
CONFIG_USB_MSI3101=m

#
# Android
#
# CONFIG_ANDROID is not set
CONFIG_USB_WPAN_HCD=m
CONFIG_WIMAX_GDM72XX=y
# CONFIG_WIMAX_GDM72XX_QOS is not set
# CONFIG_WIMAX_GDM72XX_K_MODE is not set
# CONFIG_WIMAX_GDM72XX_WIMAX2 is not set
CONFIG_WIMAX_GDM72XX_USB=y
# CONFIG_WIMAX_GDM72XX_SDIO is not set
CONFIG_WIMAX_GDM72XX_USB_PM=y
# CONFIG_LTE_GDM724X is not set
CONFIG_CED1401=m
CONFIG_DGRP=m
CONFIG_GOLDFISH_AUDIO=m
CONFIG_MTD_GOLDFISH_NAND=y
# CONFIG_MTD_SPINAND_MT29F is not set
CONFIG_USB_DWC2=y
CONFIG_USB_DWC2_DEBUG=y
CONFIG_USB_DWC2_VERBOSE=y
CONFIG_USB_DWC2_TRACK_MISSED_SOFS=y
# CONFIG_USB_DWC2_DEBUG_PERIODIC is not set
# CONFIG_USB_BTMTK is not set
CONFIG_XILLYBUS=y
# CONFIG_XILLYBUS_PCIE is not set
CONFIG_DGNC=m
CONFIG_DGAP=y
CONFIG_X86_PLATFORM_DEVICES=y
# CONFIG_ACER_WMI is not set
# CONFIG_ACERHDF is not set
# CONFIG_ASUS_LAPTOP is not set
# CONFIG_DELL_LAPTOP is not set
# CONFIG_DELL_WMI is not set
# CONFIG_DELL_WMI_AIO is not set
# CONFIG_FUJITSU_LAPTOP is not set
# CONFIG_FUJITSU_TABLET is not set
# CONFIG_AMILO_RFKILL is not set
# CONFIG_TC1100_WMI is not set
# CONFIG_HP_ACCEL is not set
# CONFIG_HP_WMI is not set
# CONFIG_MSI_LAPTOP is not set
# CONFIG_PANASONIC_LAPTOP is not set
# CONFIG_COMPAL_LAPTOP is not set
# CONFIG_SONY_LAPTOP is not set
# CONFIG_IDEAPAD_LAPTOP is not set
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
# CONFIG_XO15_EBOOK is not set
# CONFIG_SAMSUNG_LAPTOP is not set
CONFIG_MXM_WMI=y
# CONFIG_INTEL_OAKTRAIL is not set
# CONFIG_SAMSUNG_Q10 is not set
# CONFIG_APPLE_GMUX is not set
# CONFIG_INTEL_RST is not set
# CONFIG_INTEL_SMARTCONNECT is not set
# CONFIG_PVPANIC is not set
CONFIG_GOLDFISH_PIPE=y
# CONFIG_CHROME_PLATFORMS is not set

#
# Hardware Spinlock drivers
#
CONFIG_CLKSRC_I8253=y
CONFIG_CLKEVT_I8253=y
CONFIG_I8253_LOCK=y
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
# CONFIG_PM_DEVFREQ is not set
# CONFIG_EXTCON is not set
CONFIG_MEMORY=y
# CONFIG_IIO is not set
CONFIG_NTB=m
# CONFIG_VME_BUS is not set
CONFIG_PWM=y
CONFIG_PWM_SYSFS=y
CONFIG_PWM_TWL=y
# CONFIG_PWM_TWL_LED is not set
CONFIG_IPACK_BUS=m
CONFIG_BOARD_TPCI200=m
# CONFIG_SERIAL_IPOCTAL is not set
# CONFIG_RESET_CONTROLLER is not set
CONFIG_FMC=y
CONFIG_FMC_FAKEDEV=y
CONFIG_FMC_TRIVIAL=m
CONFIG_FMC_WRITE_EEPROM=y
CONFIG_FMC_CHARDEV=m

#
# PHY Subsystem
#
CONFIG_GENERIC_PHY=y
CONFIG_PHY_EXYNOS_MIPI_VIDEO=m
# CONFIG_POWERCAP is not set

#
# Firmware Drivers
#
# CONFIG_EDD is not set
CONFIG_FIRMWARE_MEMMAP=y
CONFIG_DELL_RBU=y
CONFIG_DCDBAS=m
CONFIG_DMIID=y
CONFIG_DMI_SYSFS=m
# CONFIG_ISCSI_IBFT_FIND is not set
CONFIG_GOOGLE_FIRMWARE=y

#
# Google Firmware Drivers
#
# CONFIG_GOOGLE_SMI is not set
CONFIG_GOOGLE_MEMCONSOLE=m

#
# File systems
#
CONFIG_DCACHE_WORD_ACCESS=y
CONFIG_EXT2_FS=m
# CONFIG_EXT2_FS_XATTR is not set
# CONFIG_EXT2_FS_XIP is not set
CONFIG_EXT3_FS=y
CONFIG_EXT3_DEFAULTS_TO_ORDERED=y
# CONFIG_EXT3_FS_XATTR is not set
# CONFIG_EXT4_FS is not set
CONFIG_JBD=y
# CONFIG_JBD_DEBUG is not set
# CONFIG_REISERFS_FS is not set
CONFIG_JFS_FS=m
CONFIG_JFS_POSIX_ACL=y
CONFIG_JFS_SECURITY=y
# CONFIG_JFS_DEBUG is not set
CONFIG_JFS_STATISTICS=y
CONFIG_XFS_FS=m
# CONFIG_XFS_QUOTA is not set
# CONFIG_XFS_POSIX_ACL is not set
# CONFIG_XFS_RT is not set
CONFIG_XFS_DEBUG=y
# CONFIG_OCFS2_FS is not set
CONFIG_BTRFS_FS=y
# CONFIG_BTRFS_FS_POSIX_ACL is not set
CONFIG_BTRFS_FS_CHECK_INTEGRITY=y
# CONFIG_BTRFS_FS_RUN_SANITY_TESTS is not set
# CONFIG_BTRFS_DEBUG is not set
# CONFIG_BTRFS_ASSERT is not set
# CONFIG_NILFS2_FS is not set
CONFIG_FS_POSIX_ACL=y
CONFIG_EXPORTFS=m
CONFIG_FILE_LOCKING=y
CONFIG_FSNOTIFY=y
CONFIG_DNOTIFY=y
# CONFIG_INOTIFY_USER is not set
# CONFIG_FANOTIFY is not set
CONFIG_QUOTA=y
# CONFIG_QUOTA_NETLINK_INTERFACE is not set
CONFIG_PRINT_QUOTA_WARNING=y
# CONFIG_QUOTA_DEBUG is not set
CONFIG_QUOTA_TREE=y
CONFIG_QFMT_V1=y
CONFIG_QFMT_V2=y
CONFIG_QUOTACTL=y
CONFIG_AUTOFS4_FS=y
# CONFIG_FUSE_FS is not set

#
# Caches
#
# CONFIG_FSCACHE is not set

#
# CD-ROM/DVD Filesystems
#
CONFIG_ISO9660_FS=m
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
CONFIG_NTFS_FS=m
CONFIG_NTFS_DEBUG=y
# CONFIG_NTFS_RW is not set

#
# Pseudo filesystems
#
CONFIG_PROC_FS=y
# CONFIG_PROC_KCORE is not set
# CONFIG_PROC_VMCORE is not set
CONFIG_PROC_SYSCTL=y
CONFIG_PROC_PAGE_MONITOR=y
CONFIG_SYSFS=y
CONFIG_TMPFS=y
# CONFIG_TMPFS_POSIX_ACL is not set
CONFIG_TMPFS_XATTR=y
# CONFIG_HUGETLBFS is not set
# CONFIG_HUGETLB_PAGE is not set
CONFIG_CONFIGFS_FS=y
# CONFIG_MISC_FILESYSTEMS is not set
CONFIG_NETWORK_FILESYSTEMS=y
CONFIG_NCP_FS=m
# CONFIG_NCPFS_PACKET_SIGNING is not set
# CONFIG_NCPFS_IOCTL_LOCKING is not set
# CONFIG_NCPFS_STRONG is not set
CONFIG_NCPFS_NFS_NS=y
# CONFIG_NCPFS_OS2_NS is not set
CONFIG_NCPFS_SMALLDOS=y
# CONFIG_NCPFS_NLS is not set
# CONFIG_NCPFS_EXTRAS is not set
CONFIG_NLS=y
CONFIG_NLS_DEFAULT="iso8859-1"
# CONFIG_NLS_CODEPAGE_437 is not set
# CONFIG_NLS_CODEPAGE_737 is not set
# CONFIG_NLS_CODEPAGE_775 is not set
# CONFIG_NLS_CODEPAGE_850 is not set
# CONFIG_NLS_CODEPAGE_852 is not set
CONFIG_NLS_CODEPAGE_855=m
CONFIG_NLS_CODEPAGE_857=y
# CONFIG_NLS_CODEPAGE_860 is not set
CONFIG_NLS_CODEPAGE_861=m
CONFIG_NLS_CODEPAGE_862=y
CONFIG_NLS_CODEPAGE_863=y
# CONFIG_NLS_CODEPAGE_864 is not set
CONFIG_NLS_CODEPAGE_865=y
# CONFIG_NLS_CODEPAGE_866 is not set
CONFIG_NLS_CODEPAGE_869=m
# CONFIG_NLS_CODEPAGE_936 is not set
CONFIG_NLS_CODEPAGE_950=m
CONFIG_NLS_CODEPAGE_932=y
# CONFIG_NLS_CODEPAGE_949 is not set
CONFIG_NLS_CODEPAGE_874=y
CONFIG_NLS_ISO8859_8=m
CONFIG_NLS_CODEPAGE_1250=y
CONFIG_NLS_CODEPAGE_1251=y
CONFIG_NLS_ASCII=m
# CONFIG_NLS_ISO8859_1 is not set
CONFIG_NLS_ISO8859_2=y
# CONFIG_NLS_ISO8859_3 is not set
CONFIG_NLS_ISO8859_4=y
# CONFIG_NLS_ISO8859_5 is not set
CONFIG_NLS_ISO8859_6=m
# CONFIG_NLS_ISO8859_7 is not set
# CONFIG_NLS_ISO8859_9 is not set
CONFIG_NLS_ISO8859_13=y
# CONFIG_NLS_ISO8859_14 is not set
CONFIG_NLS_ISO8859_15=m
CONFIG_NLS_KOI8_R=y
CONFIG_NLS_KOI8_U=m
CONFIG_NLS_MAC_ROMAN=y
CONFIG_NLS_MAC_CELTIC=y
# CONFIG_NLS_MAC_CENTEURO is not set
CONFIG_NLS_MAC_CROATIAN=m
CONFIG_NLS_MAC_CYRILLIC=m
CONFIG_NLS_MAC_GAELIC=m
# CONFIG_NLS_MAC_GREEK is not set
# CONFIG_NLS_MAC_ICELAND is not set
CONFIG_NLS_MAC_INUIT=m
# CONFIG_NLS_MAC_ROMANIAN is not set
# CONFIG_NLS_MAC_TURKISH is not set
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
CONFIG_ENABLE_WARN_DEPRECATED=y
CONFIG_ENABLE_MUST_CHECK=y
CONFIG_FRAME_WARN=1024
CONFIG_STRIP_ASM_SYMS=y
# CONFIG_READABLE_ASM is not set
CONFIG_UNUSED_SYMBOLS=y
CONFIG_DEBUG_FS=y
# CONFIG_HEADERS_CHECK is not set
CONFIG_DEBUG_SECTION_MISMATCH=y
CONFIG_ARCH_WANT_FRAME_POINTERS=y
CONFIG_FRAME_POINTER=y
CONFIG_DEBUG_FORCE_WEAK_PER_CPU=y
CONFIG_MAGIC_SYSRQ=y
CONFIG_MAGIC_SYSRQ_DEFAULT_ENABLE=0x1
CONFIG_DEBUG_KERNEL=y

#
# Memory Debugging
#
# CONFIG_DEBUG_PAGEALLOC is not set
CONFIG_DEBUG_OBJECTS=y
CONFIG_DEBUG_OBJECTS_SELFTEST=y
# CONFIG_DEBUG_OBJECTS_FREE is not set
# CONFIG_DEBUG_OBJECTS_TIMERS is not set
CONFIG_DEBUG_OBJECTS_WORK=y
# CONFIG_DEBUG_OBJECTS_RCU_HEAD is not set
CONFIG_DEBUG_OBJECTS_PERCPU_COUNTER=y
CONFIG_DEBUG_OBJECTS_ENABLE_DEFAULT=1
# CONFIG_SLUB_DEBUG_ON is not set
# CONFIG_SLUB_STATS is not set
CONFIG_HAVE_DEBUG_KMEMLEAK=y
# CONFIG_DEBUG_KMEMLEAK is not set
CONFIG_DEBUG_STACK_USAGE=y
# CONFIG_DEBUG_VM is not set
# CONFIG_DEBUG_VIRTUAL is not set
CONFIG_DEBUG_MEMORY_INIT=y
# CONFIG_DEBUG_HIGHMEM is not set
CONFIG_HAVE_DEBUG_STACKOVERFLOW=y
# CONFIG_DEBUG_STACKOVERFLOW is not set
CONFIG_HAVE_ARCH_KMEMCHECK=y
# CONFIG_KMEMCHECK is not set
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
CONFIG_PANIC_ON_OOPS=y
CONFIG_PANIC_ON_OOPS_VALUE=1
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
# CONFIG_PROVE_LOCKING is not set
CONFIG_LOCKDEP=y
CONFIG_LOCK_STAT=y
CONFIG_DEBUG_LOCKDEP=y
CONFIG_DEBUG_ATOMIC_SLEEP=y
CONFIG_DEBUG_LOCKING_API_SELFTESTS=y
CONFIG_STACKTRACE=y
# CONFIG_DEBUG_KOBJECT is not set
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
# CONFIG_RCU_TORTURE_TEST is not set
CONFIG_RCU_CPU_STALL_TIMEOUT=21
CONFIG_RCU_TRACE=y
# CONFIG_DEBUG_BLOCK_EXT_DEVT is not set
CONFIG_NOTIFIER_ERROR_INJECTION=m
CONFIG_PM_NOTIFIER_ERROR_INJECT=m
CONFIG_FAULT_INJECTION=y
CONFIG_FAILSLAB=y
CONFIG_FAIL_PAGE_ALLOC=y
# CONFIG_FAIL_MAKE_REQUEST is not set
# CONFIG_FAIL_IO_TIMEOUT is not set
CONFIG_FAIL_MMC_REQUEST=y
CONFIG_FAULT_INJECTION_DEBUG_FS=y
CONFIG_FAULT_INJECTION_STACKTRACE_FILTER=y
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
CONFIG_LKDTM=m
CONFIG_TEST_LIST_SORT=y
# CONFIG_KPROBES_SANITY_TEST is not set
# CONFIG_BACKTRACE_SELF_TEST is not set
CONFIG_RBTREE_TEST=y
CONFIG_INTERVAL_TREE_TEST=m
CONFIG_PERCPU_TEST=m
# CONFIG_ATOMIC64_SELFTEST is not set
CONFIG_ASYNC_RAID6_TEST=y
# CONFIG_TEST_STRING_HELPERS is not set
# CONFIG_TEST_KSTRTOX is not set
CONFIG_PROVIDE_OHCI1394_DMA_INIT=y
# CONFIG_DMA_API_DEBUG is not set
# CONFIG_SAMPLES is not set
CONFIG_HAVE_ARCH_KGDB=y
# CONFIG_KGDB is not set
CONFIG_STRICT_DEVMEM=y
CONFIG_X86_VERBOSE_BOOTUP=y
CONFIG_EARLY_PRINTK=y
CONFIG_EARLY_PRINTK_DBGP=y
# CONFIG_X86_PTDUMP is not set
# CONFIG_DEBUG_RODATA is not set
CONFIG_DEBUG_SET_MODULE_RONX=y
CONFIG_DEBUG_NX_TEST=m
CONFIG_DOUBLEFAULT=y
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
# CONFIG_DEBUG_BOOT_PARAMS is not set
# CONFIG_CPA_DEBUG is not set
CONFIG_OPTIMIZE_INLINING=y
# CONFIG_DEBUG_NMI_SELFTEST is not set
# CONFIG_X86_DEBUG_STATIC_CPU_HAS is not set

#
# Security options
#
CONFIG_KEYS=y
# CONFIG_PERSISTENT_KEYRINGS is not set
# CONFIG_BIG_KEYS is not set
CONFIG_TRUSTED_KEYS=m
# CONFIG_ENCRYPTED_KEYS is not set
# CONFIG_KEYS_DEBUG_PROC_KEYS is not set
CONFIG_SECURITY_DMESG_RESTRICT=y
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
CONFIG_CRYPTO_AEAD=m
CONFIG_CRYPTO_AEAD2=y
CONFIG_CRYPTO_BLKCIPHER=y
CONFIG_CRYPTO_BLKCIPHER2=y
CONFIG_CRYPTO_HASH=y
CONFIG_CRYPTO_HASH2=y
CONFIG_CRYPTO_RNG=m
CONFIG_CRYPTO_RNG2=y
CONFIG_CRYPTO_PCOMP=y
CONFIG_CRYPTO_PCOMP2=y
CONFIG_CRYPTO_MANAGER=y
CONFIG_CRYPTO_MANAGER2=y
# CONFIG_CRYPTO_USER is not set
CONFIG_CRYPTO_MANAGER_DISABLE_TESTS=y
CONFIG_CRYPTO_GF128MUL=y
CONFIG_CRYPTO_NULL=y
CONFIG_CRYPTO_WORKQUEUE=y
CONFIG_CRYPTO_CRYPTD=m
# CONFIG_CRYPTO_AUTHENC is not set
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
CONFIG_CRYPTO_CBC=m
CONFIG_CRYPTO_CTR=m
# CONFIG_CRYPTO_CTS is not set
CONFIG_CRYPTO_ECB=y
CONFIG_CRYPTO_LRW=m
# CONFIG_CRYPTO_PCBC is not set
CONFIG_CRYPTO_XTS=y

#
# Hash modes
#
CONFIG_CRYPTO_CMAC=y
CONFIG_CRYPTO_HMAC=m
# CONFIG_CRYPTO_XCBC is not set
CONFIG_CRYPTO_VMAC=y

#
# Digest
#
CONFIG_CRYPTO_CRC32C=y
CONFIG_CRYPTO_CRC32C_INTEL=m
CONFIG_CRYPTO_CRC32=y
# CONFIG_CRYPTO_CRC32_PCLMUL is not set
CONFIG_CRYPTO_CRCT10DIF=m
CONFIG_CRYPTO_GHASH=m
CONFIG_CRYPTO_MD4=y
CONFIG_CRYPTO_MD5=m
# CONFIG_CRYPTO_MICHAEL_MIC is not set
# CONFIG_CRYPTO_RMD128 is not set
CONFIG_CRYPTO_RMD160=y
CONFIG_CRYPTO_RMD256=y
# CONFIG_CRYPTO_RMD320 is not set
CONFIG_CRYPTO_SHA1=m
CONFIG_CRYPTO_SHA256=y
CONFIG_CRYPTO_SHA512=y
# CONFIG_CRYPTO_TGR192 is not set
CONFIG_CRYPTO_WP512=m

#
# Ciphers
#
CONFIG_CRYPTO_AES=y
CONFIG_CRYPTO_AES_586=m
CONFIG_CRYPTO_AES_NI_INTEL=m
CONFIG_CRYPTO_ANUBIS=y
CONFIG_CRYPTO_ARC4=y
CONFIG_CRYPTO_BLOWFISH=y
CONFIG_CRYPTO_BLOWFISH_COMMON=y
CONFIG_CRYPTO_CAMELLIA=m
CONFIG_CRYPTO_CAST_COMMON=y
# CONFIG_CRYPTO_CAST5 is not set
CONFIG_CRYPTO_CAST6=y
# CONFIG_CRYPTO_DES is not set
# CONFIG_CRYPTO_FCRYPT is not set
CONFIG_CRYPTO_KHAZAD=m
# CONFIG_CRYPTO_SALSA20 is not set
CONFIG_CRYPTO_SALSA20_586=y
# CONFIG_CRYPTO_SEED is not set
CONFIG_CRYPTO_SERPENT=m
CONFIG_CRYPTO_SERPENT_SSE2_586=m
CONFIG_CRYPTO_TEA=y
CONFIG_CRYPTO_TWOFISH=m
CONFIG_CRYPTO_TWOFISH_COMMON=m
CONFIG_CRYPTO_TWOFISH_586=m

#
# Compression
#
CONFIG_CRYPTO_DEFLATE=m
CONFIG_CRYPTO_ZLIB=y
CONFIG_CRYPTO_LZO=m
CONFIG_CRYPTO_LZ4=m
# CONFIG_CRYPTO_LZ4HC is not set

#
# Random Number Generation
#
# CONFIG_CRYPTO_ANSI_CPRNG is not set
CONFIG_CRYPTO_USER_API=m
CONFIG_CRYPTO_USER_API_HASH=m
CONFIG_CRYPTO_USER_API_SKCIPHER=m
CONFIG_CRYPTO_HASH_INFO=y
# CONFIG_CRYPTO_HW is not set
CONFIG_ASYMMETRIC_KEY_TYPE=y
CONFIG_ASYMMETRIC_PUBLIC_KEY_SUBTYPE=y
CONFIG_PUBLIC_KEY_ALGO_RSA=y
CONFIG_X509_CERTIFICATE_PARSER=y
CONFIG_HAVE_KVM=y
CONFIG_VIRTUALIZATION=y
# CONFIG_KVM is not set
CONFIG_LGUEST=y
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
CONFIG_CRC_CCITT=m
CONFIG_CRC16=y
# CONFIG_CRC_T10DIF is not set
CONFIG_CRC_ITU_T=y
CONFIG_CRC32=y
# CONFIG_CRC32_SELFTEST is not set
# CONFIG_CRC32_SLICEBY8 is not set
# CONFIG_CRC32_SLICEBY4 is not set
CONFIG_CRC32_SARWATE=y
# CONFIG_CRC32_BIT is not set
CONFIG_CRC7=m
CONFIG_LIBCRC32C=y
CONFIG_CRC8=y
CONFIG_AUDIT_GENERIC=y
CONFIG_RANDOM32_SELFTEST=y
CONFIG_ZLIB_INFLATE=y
CONFIG_ZLIB_DEFLATE=y
CONFIG_LZO_COMPRESS=y
CONFIG_LZO_DECOMPRESS=y
CONFIG_LZ4_COMPRESS=m
CONFIG_LZ4_DECOMPRESS=y
CONFIG_XZ_DEC=y
CONFIG_XZ_DEC_X86=y
CONFIG_XZ_DEC_POWERPC=y
CONFIG_XZ_DEC_IA64=y
CONFIG_XZ_DEC_ARM=y
CONFIG_XZ_DEC_ARMTHUMB=y
CONFIG_XZ_DEC_SPARC=y
CONFIG_XZ_DEC_BCJ=y
CONFIG_XZ_DEC_TEST=m
CONFIG_DECOMPRESS_GZIP=y
CONFIG_DECOMPRESS_BZIP2=y
CONFIG_DECOMPRESS_LZMA=y
CONFIG_DECOMPRESS_XZ=y
CONFIG_DECOMPRESS_LZO=y
CONFIG_DECOMPRESS_LZ4=y
CONFIG_REED_SOLOMON=m
CONFIG_REED_SOLOMON_DEC16=y
CONFIG_BCH=y
CONFIG_ASSOCIATIVE_ARRAY=y
CONFIG_HAS_IOMEM=y
CONFIG_HAS_IOPORT=y
CONFIG_HAS_DMA=y
CONFIG_CHECK_SIGNATURE=y
CONFIG_DQL=y
CONFIG_NLATTR=y
CONFIG_ARCH_HAS_ATOMIC64_DEC_IF_POSITIVE=y
CONFIG_AVERAGE=y
CONFIG_CLZ_TAB=y
CONFIG_CORDIC=m
# CONFIG_DDR is not set
CONFIG_MPILIB=y
CONFIG_OID_REGISTRY=y
CONFIG_FONT_SUPPORT=y
# CONFIG_FONTS is not set
CONFIG_FONT_8x8=y
CONFIG_FONT_8x16=y

--ZPt4rx8FFjLCG7dd--
