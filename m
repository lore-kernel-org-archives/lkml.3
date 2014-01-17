Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752353AbaAQLJt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Jan 2014 06:09:49 -0500
Received: from mga03.intel.com ([143.182.124.21]:20514 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751369AbaAQLJn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Jan 2014 06:09:43 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.95,670,1384329600"; 
   d="scan'208";a="460446215"
Date: Fri, 17 Jan 2014 19:09:35 +0800
From: Fengguang Wu <fengguang.wu@intel.com>
To: Ming Lei <tom.leiming@gmail.com>
Cc: Jeff Liu <jeff.liu@oracle.com>, LKML <linux-kernel@vger.kernel.org>
Subject: [percpu_counter] a9804b7b0: xfstests.generic.226.fail
Message-ID: <20140117110935.GA11953@localhost>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="Kj7319i9nmIyA2yE"
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--Kj7319i9nmIyA2yE
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi Ming Lei,

So this xfstests regression is also caused by the known bug in below
commit?  Full dmesg is attached.

[  449.390196] EXT4-fs (vdd): mounted filesystem with ordered data mode. Opts: acl,user_xattr
[  456.122979] EXT4-fs (vdd): Delayed block allocation failed for inode 13 at logical offset 367137 with max blocks 2048 with error 28
[  456.129367] EXT4-fs (vdd): This should not happen!! Data will be lost
[  456.129367]
[  456.130985] EXT4-fs (vdd): Total free blocks count 0
[  456.132330] EXT4-fs (vdd): Free/Dirty block details
[  456.133325] EXT4-fs (vdd): free_blocks=212443
[  456.137180] EXT4-fs (vdd): dirty_blocks=208347
[  456.138048] EXT4-fs (vdd): Block reservation details
[  456.139083] EXT4-fs (vdd): i_reserved_data_blocks=9222
[  456.140076] EXT4-fs (vdd): i_reserved_meta_blocks=1111
[  456.141047] EXT4-fs (vdd): i_allocated_meta_blocks=0
[  460.182192] EXT4-fs (vda): mounted filesystem with ordered data mode. Opts: acl,user_xattr

a9804b7b0aa2bf65b7cd1979306cbac4dcb6974f is the first bad commit
commit a9804b7b0aa2bf65b7cd1979306cbac4dcb6974f
Author:     Ming Lei <tom.leiming@gmail.com>
AuthorDate: Wed Jan 15 16:54:26 2014 +1100
Commit:     Stephen Rothwell <sfr@canb.auug.org.au>
CommitDate: Wed Jan 15 16:54:26 2014 +1100

    lib/percpu_counter.c: fix __percpu_counter_add()
    
    __percpu_counter_add() may be called in softirq/hardirq handler (such as,
    blk_mq_queue_exit() is typically called in hardirq/softirq handler), so we
    need to call this_cpu_add()(irq safe helper) to update percpu counter,
    otherwise counts may be lost.
    
    The patch fixes problem that 'rmmod null_blk' hangs in blk_cleanup_queue()
    because of miscounting of request_queue->mq_usage_counter.
    
    This patch is the v1 of previous one of "lib/percpu_counter.c:
    disable local irq when updating percpu couter", and takes Andrew's
    approach which may be more efficient for ARCHs(x86, s390) that
    have optimized this_cpu_add().
    
    Signed-off-by: Ming Lei <tom.leiming@gmail.com>
    Cc: Paul Gortmaker <paul.gortmaker@windriver.com>
    Cc: Shaohua Li <shli@fusionio.com>
    Cc: Jens Axboe <axboe@kernel.dk>
    Cc: Fan Du <fan.du@windriver.com>
    Signed-off-by: Andrew Morton <akpm@linux-foundation.org>

 lib/percpu_counter.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)


--Kj7319i9nmIyA2yE
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename=".dmesg"
Content-Transfer-Encoding: quoted-printable

early console in setup code
Probing EDD (edd=3Doff to disable)... ok
early console in decompress_kernel

Decompressing Linux... Parsing ELF... done.
Booting the kernel.
[    0.000000] Initializing cgroup subsys cpuset
[    0.000000] Initializing cgroup subsys cpu
[    0.000000] Linux version 3.13.0-rc8-next-20140115-10041-g82fab9c-dirty =
(kbuild@inn) (gcc version 4.8.1 (Debian 4.8.1-8) ) #1 SMP Thu Jan 16 11:54:=
05 CST 2014
[    0.000000] Command line: user=3Dlkp job=3D/lkp/scheduled/vpx-4/cyclic_x=
fstests-generic-4HDD-ext4-generic-mid-HEAD.yaml ARCH=3Dx86_64 BOOT_IMAGE=3D=
/kernel/x86_64-lkp/82fab9c8db671c048c28350ac144805a3a5bc89b/vmlinuz-3.13.0-=
rc8-next-20140115-10041-g82fab9c-dirty kconfig=3Dx86_64-lkp commit=3D82fab9=
c8db671c048c28350ac144805a3a5bc89b bm_initrd=3D/lkp/benchmarks/xfstests.cgz=
 modules_initrd=3D/kernel/x86_64-lkp/82fab9c8db671c048c28350ac144805a3a5bc8=
9b/modules.cgz max_uptime=3D1474 RESULT_ROOT=3D/lkp/result/vpx/micro/xfstes=
ts/4HDD-ext4-generic-mid/x86_64-lkp/82fab9c8db671c048c28350ac144805a3a5bc89=
b/9 initrd=3D/kernel-tests/initrd/lkp-rootfs.cgz root=3D/dev/ram0 ip=3D::::=
vpx-4::dhcp oops=3Dpanic earlyprintk=3DttyS0,115200 debug apic=3Ddebug sysr=
q_always_enabled panic=3D10 load_ramdisk=3D2 prompt_ramdisk=3D0 console=3Dt=
tyS0,115200 console=3Dtty0 vga=3Dnormal
[    0.000000] e820: BIOS-provided physical RAM map:
[    0.000000] BIOS-e820: [mem 0x0000000000000000-0x000000000009fbff] usable
[    0.000000] BIOS-e820: [mem 0x000000000009fc00-0x000000000009ffff] reser=
ved
[    0.000000] BIOS-e820: [mem 0x00000000000f0000-0x00000000000fffff] reser=
ved
[    0.000000] BIOS-e820: [mem 0x0000000000100000-0x00000000dfffdfff] usable
[    0.000000] BIOS-e820: [mem 0x00000000dfffe000-0x00000000dfffffff] reser=
ved
[    0.000000] BIOS-e820: [mem 0x00000000feffc000-0x00000000feffffff] reser=
ved
[    0.000000] BIOS-e820: [mem 0x00000000fffc0000-0x00000000ffffffff] reser=
ved
[    0.000000] BIOS-e820: [mem 0x0000000100000000-0x000000011fffffff] usable
[    0.000000] bootconsole [earlyser0] enabled
[    0.000000] NX (Execute Disable) protection: active
[    0.000000] SMBIOS 2.4 present.
[    0.000000] DMI: Bochs Bochs, BIOS Bochs 01/01/2011
[    0.000000] Hypervisor detected: KVM
[    0.000000] e820: update [mem 0x00000000-0x00000fff] usable =3D=3D> rese=
rved
[    0.000000] e820: remove [mem 0x000a0000-0x000fffff] usable
[    0.000000] No AGP bridge found
[    0.000000] e820: last_pfn =3D 0x120000 max_arch_pfn =3D 0x400000000
[    0.000000] MTRR default type: write-back
[    0.000000] MTRR fixed ranges enabled:
[    0.000000]   00000-9FFFF write-back
[    0.000000]   A0000-BFFFF uncachable
[    0.000000]   C0000-FFFFF write-protect
[    0.000000] MTRR variable ranges enabled:
[    0.000000]   0 base 00E0000000 mask FFE0000000 uncachable
[    0.000000]   1 disabled
[    0.000000]   2 disabled
[    0.000000]   3 disabled
[    0.000000]   4 disabled
[    0.000000]   5 disabled
[    0.000000]   6 disabled
[    0.000000]   7 disabled
[    0.000000] x86 PAT enabled: cpu 0, old 0x70406, new 0x7010600070106
[    0.000000] e820: last_pfn =3D 0xdfffe max_arch_pfn =3D 0x400000000
[    0.000000] Scan for SMP in [mem 0x00000000-0x000003ff]
[    0.000000] Scan for SMP in [mem 0x0009fc00-0x0009ffff]
[    0.000000] Scan for SMP in [mem 0x000f0000-0x000fffff]
[    0.000000] found SMP MP-table at [mem 0x000fda90-0x000fda9f] mapped at =
[ffff8800000fda90]
[    0.000000]   mpc: fdaa0-fdbe4
[    0.000000] Scanning 1 areas for low memory corruption
[    0.000000] Base memory trampoline at [ffff880000099000] 99000 size 24576
[    0.000000] init_memory_mapping: [mem 0x00000000-0x000fffff]
[    0.000000]  [mem 0x00000000-0x000fffff] page 4k
[    0.000000] BRK [0x02664000, 0x02664fff] PGTABLE
[    0.000000] BRK [0x02665000, 0x02665fff] PGTABLE
[    0.000000] BRK [0x02666000, 0x02666fff] PGTABLE
[    0.000000] init_memory_mapping: [mem 0x11fe00000-0x11fffffff]
[    0.000000]  [mem 0x11fe00000-0x11fffffff] page 2M
[    0.000000] BRK [0x02667000, 0x02667fff] PGTABLE
[    0.000000] init_memory_mapping: [mem 0x11c000000-0x11fdfffff]
[    0.000000]  [mem 0x11c000000-0x11fdfffff] page 2M
[    0.000000] init_memory_mapping: [mem 0x100000000-0x11bffffff]
[    0.000000]  [mem 0x100000000-0x11bffffff] page 2M
[    0.000000] init_memory_mapping: [mem 0x00100000-0xdfffdfff]
[    0.000000]  [mem 0x00100000-0x001fffff] page 4k
[    0.000000]  [mem 0x00200000-0xdfdfffff] page 2M
[    0.000000]  [mem 0xdfe00000-0xdfffdfff] page 4k
[    0.000000] RAMDISK: [mem 0x73ce1000-0x7fffffff]
[    0.000000] ACPI: RSDP 00000000000fd880 000014 (v00 BOCHS )
[    0.000000] ACPI: RSDT 00000000dfffe380 000034 (v01 BOCHS  BXPCRSDT 0000=
0001 BXPC 00000001)
[    0.000000] ACPI: FACP 00000000dfffff80 000074 (v01 BOCHS  BXPCFACP 0000=
0001 BXPC 00000001)
[    0.000000] ACPI: DSDT 00000000dfffe3c0 0011A9 (v01   BXPC   BXDSDT 0000=
0001 INTL 20100528)
[    0.000000] ACPI: FACS 00000000dfffff40 000040
[    0.000000] ACPI: SSDT 00000000dffff6e0 000858 (v01 BOCHS  BXPCSSDT 0000=
0001 BXPC 00000001)
[    0.000000] ACPI: APIC 00000000dffff5b0 000090 (v01 BOCHS  BXPCAPIC 0000=
0001 BXPC 00000001)
[    0.000000] ACPI: HPET 00000000dffff570 000038 (v01 BOCHS  BXPCHPET 0000=
0001 BXPC 00000001)
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] mapped APIC to ffffffffff5f3000 (        fee00000)
[    0.000000] No NUMA configuration found
[    0.000000] Faking a node at [mem 0x0000000000000000-0x000000011fffffff]
[    0.000000] Initmem setup node 0 [mem 0x00000000-0x11fffffff]
[    0.000000]   NODE_DATA [mem 0xdfff9000-0xdfffdfff]
[    0.000000] kvm-clock: Using msrs 4b564d01 and 4b564d00
[    0.000000] kvm-clock: cpu 0, msr 0:dfff1001, boot clock
[   16.486400]  [ffffea0000000000-ffffea00047fffff] PMD -> [ffff8800db60000=
0-ffff8800df5fffff] on node 0
[   16.487280] Zone ranges:
[   16.487499]   DMA      [mem 0x00001000-0x00ffffff]
[   16.487924]   DMA32    [mem 0x01000000-0xffffffff]
[   16.488362]   Normal   [mem 0x100000000-0x11fffffff]
[   16.488800] Movable zone start for each node
[   16.489167] Early memory node ranges
[   16.489482]   node   0: [mem 0x00001000-0x0009efff]
[   16.489957]   node   0: [mem 0x00100000-0xdfffdfff]
[   16.490399]   node   0: [mem 0x100000000-0x11fffffff]
[   16.490885] On node 0 totalpages: 1048476
[   16.491248]   DMA zone: 64 pages used for memmap
[   16.491690]   DMA zone: 21 pages reserved
[   16.492038]   DMA zone: 3998 pages, LIFO batch:0
[   16.492549]   DMA32 zone: 14272 pages used for memmap
[   16.492985]   DMA32 zone: 913406 pages, LIFO batch:31
[   16.510190]   Normal zone: 2048 pages used for memmap
[   16.510682]   Normal zone: 131072 pages, LIFO batch:31
[   16.513970] ACPI: PM-Timer IO Port: 0xb008
[   16.514390] ACPI: Local APIC address 0xfee00000
[   16.514821] mapped APIC to ffffffffff5f3000 (        fee00000)
[   16.515418] ACPI: LAPIC (acpi_id[0x00] lapic_id[0x00] enabled)
[   16.516024] ACPI: LAPIC (acpi_id[0x01] lapic_id[0x01] enabled)
[   16.516550] ACPI: LAPIC (acpi_id[0x02] lapic_id[0x02] enabled)
[   16.517066] ACPI: LAPIC (acpi_id[0x03] lapic_id[0x03] enabled)
[   16.517579] ACPI: LAPIC_NMI (acpi_id[0xff] dfl dfl lint[0x1])
[   16.518075] ACPI: IOAPIC (id[0x00] address[0xfec00000] gsi_base[0])
[   16.518645] IOAPIC[0]: apic_id 0, version 17, address 0xfec00000, GSI 0-=
23
[   16.519242] ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
[   16.519796] Int: type 0, pol 0, trig 0, bus 00, IRQ 00, APIC ID 0, APIC =
INT 02
[   16.520421] ACPI: INT_SRC_OVR (bus 0 bus_irq 5 global_irq 5 high level)
[   16.520989] Int: type 0, pol 1, trig 3, bus 00, IRQ 05, APIC ID 0, APIC =
INT 05
[   16.521619] ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 high level)
[   16.522188] Int: type 0, pol 1, trig 3, bus 00, IRQ 09, APIC ID 0, APIC =
INT 09
[   16.522822] ACPI: INT_SRC_OVR (bus 0 bus_irq 10 global_irq 10 high level)
[   16.523409] Int: type 0, pol 1, trig 3, bus 00, IRQ 0a, APIC ID 0, APIC =
INT 0a
[   16.524030] ACPI: INT_SRC_OVR (bus 0 bus_irq 11 global_irq 11 high level)
[   16.524617] Int: type 0, pol 1, trig 3, bus 00, IRQ 0b, APIC ID 0, APIC =
INT 0b
[   16.525296] ACPI: IRQ0 used by override.
[   16.525640] Int: type 0, pol 0, trig 0, bus 00, IRQ 01, APIC ID 0, APIC =
INT 01
[   16.526291] ACPI: IRQ2 used by override.
[   16.526634] Int: type 0, pol 0, trig 0, bus 00, IRQ 03, APIC ID 0, APIC =
INT 03
[   16.527266] Int: type 0, pol 0, trig 0, bus 00, IRQ 04, APIC ID 0, APIC =
INT 04
[   16.527889] ACPI: IRQ5 used by override.
[   16.528231] Int: type 0, pol 0, trig 0, bus 00, IRQ 06, APIC ID 0, APIC =
INT 06
[   16.528861] Int: type 0, pol 0, trig 0, bus 00, IRQ 07, APIC ID 0, APIC =
INT 07
[   16.529490] Int: type 0, pol 0, trig 0, bus 00, IRQ 08, APIC ID 0, APIC =
INT 08
[   16.530115] ACPI: IRQ9 used by override.
[   16.530462] ACPI: IRQ10 used by override.
[   16.530807] ACPI: IRQ11 used by override.
[   16.531160] Int: type 0, pol 0, trig 0, bus 00, IRQ 0c, APIC ID 0, APIC =
INT 0c
[   16.531785] Int: type 0, pol 0, trig 0, bus 00, IRQ 0d, APIC ID 0, APIC =
INT 0d
[   16.532413] Int: type 0, pol 0, trig 0, bus 00, IRQ 0e, APIC ID 0, APIC =
INT 0e
[   16.533032] Int: type 0, pol 0, trig 0, bus 00, IRQ 0f, APIC ID 0, APIC =
INT 0f
[   16.533686] Using ACPI (MADT) for SMP configuration information
[   16.534234] ACPI: HPET id: 0x8086a201 base: 0xfed00000
[   16.534679] smpboot: Allowing 4 CPUs, 0 hotplug CPUs
[   16.535119] mapped IOAPIC to ffffffffff5f2000 (fec00000)
[   16.535577] nr_irqs_gsi: 40
[   16.535835] PM: Registered nosave memory: [mem 0x0009f000-0x0009ffff]
[   16.536394] PM: Registered nosave memory: [mem 0x000a0000-0x000effff]
[   16.536948] PM: Registered nosave memory: [mem 0x000f0000-0x000fffff]
[   16.537513] PM: Registered nosave memory: [mem 0xdfffe000-0xdfffffff]
[   16.538087] PM: Registered nosave memory: [mem 0xe0000000-0xfeffbfff]
[   16.538644] PM: Registered nosave memory: [mem 0xfeffc000-0xfeffffff]
[   16.539197] PM: Registered nosave memory: [mem 0xff000000-0xfffbffff]
[   16.539759] PM: Registered nosave memory: [mem 0xfffc0000-0xffffffff]
[   16.540316] e820: [mem 0xe0000000-0xfeffbfff] available for PCI devices
[   16.540882] Booting paravirtualized kernel on KVM
[   16.541299] setup_percpu: NR_CPUS:512 nr_cpumask_bits:512 nr_cpu_ids:4 n=
r_node_ids:1
[   16.542317] PERCPU: Embedded 27 pages/cpu @ffff8800dfc00000 s81088 r8192=
 d21312 u524288
[   16.543016] pcpu-alloc: s81088 r8192 d21312 u524288 alloc=3D1*2097152
[   16.543559] pcpu-alloc: [0] 0 1 2 3=20
[   16.543885] kvm-clock: cpu 0, msr 0:dfff1001, primary cpu clock
[   16.544431] KVM setup async PF for cpu 0
[   16.544771] kvm-stealtime: cpu 0, msr dfc0d040
[   16.545163] Built 1 zonelists in Node order, mobility grouping on.  Tota=
l pages: 1032071
[   16.545890] Policy zone: Normal
[   16.546166] Kernel command line: user=3Dlkp job=3D/lkp/scheduled/vpx-4/c=
yclic_xfstests-generic-4HDD-ext4-generic-mid-HEAD.yaml ARCH=3Dx86_64 BOOT_I=
MAGE=3D/kernel/x86_64-lkp/82fab9c8db671c048c28350ac144805a3a5bc89b/vmlinuz-=
3.13.0-rc8-next-20140115-10041-g82fab9c-dirty kconfig=3Dx86_64-lkp commit=
=3D82fab9c8db671c048c28350ac144805a3a5bc89b bm_initrd=3D/lkp/benchmarks/xfs=
tests.cgz modules_initrd=3D/kernel/x86_64-lkp/82fab9c8db671c048c28350ac1448=
05a3a5bc89b/modules.cgz max_uptime=3D1474 RESULT_ROOT=3D/lkp/result/vpx/mic=
ro/xfstests/4HDD-ext4-generic-mid/x86_64-lkp/82fab9c8db671c048c28350ac14480=
5a3a5bc89b/9 initrd=3D/kernel-tests/initrd/lkp-rootfs.cgz root=3D/dev/ram0 =
ip=3D::::vpx-4::dhcp oops=3Dpanic earlyprintk=3DttyS0,115200 debug apic=3Dd=
ebug sysrq_always_enabled panic=3D10 load_ramdisk=3D2 prompt_ramdisk=3D0 co=
nsole=3DttyS0,115200 console=3Dtty0 vga=3Dnormal
[   16.552924] sysrq: sysrq always enabled.
[   16.553381] PID hash table entries: 4096 (order: 3, 32768 bytes)
[   16.597230] Checking aperture...
[   16.640265] No AGP bridge found
[   16.652601] Memory: 3838724K/4193904K available (10431K kernel code, 125=
2K rwdata, 4164K rodata, 1436K init, 1748K bss, 355180K reserved)
[   16.653759] SLUB: HWalign=3D64, Order=3D0-3, MinObjects=3D0, CPUs=3D4, N=
odes=3D1
[   16.654338] Hierarchical RCU implementation.
[   16.654696]=20
[   16.655235]=20
[   16.655761] RCU: Adjusting geometry for rcu_fanout_leaf=3D16, nr_cpu_ids=
=3D4
[   16.656335] NR_IRQS:33024 nr_irqs:712 16
[   16.671168] Console: colour VGA+ 80x25
[   16.671489] console [tty0] enabled
[   16.671886] bootconsole [earlyser0] disabled
[    0.000000] Initializing cgroup subsys cpuset
[    0.000000] Initializing cgroup subsys cpu
[    0.000000] Linux version 3.13.0-rc8-next-20140115-10041-g82fab9c-dirty =
(kbuild@inn) (gcc version 4.8.1 (Debian 4.8.1-8) ) #1 SMP Thu Jan 16 11:54:=
05 CST 2014
[    0.000000] Command line: user=3Dlkp job=3D/lkp/scheduled/vpx-4/cyclic_x=
fstests-generic-4HDD-ext4-generic-mid-HEAD.yaml ARCH=3Dx86_64 BOOT_IMAGE=3D=
/kernel/x86_64-lkp/82fab9c8db671c048c28350ac144805a3a5bc89b/vmlinuz-3.13.0-=
rc8-next-20140115-10041-g82fab9c-dirty kconfig=3Dx86_64-lkp commit=3D82fab9=
c8db671c048c28350ac144805a3a5bc89b bm_initrd=3D/lkp/benchmarks/xfstests.cgz=
 modules_initrd=3D/kernel/x86_64-lkp/82fab9c8db671c048c28350ac144805a3a5bc8=
9b/modules.cgz max_uptime=3D1474 RESULT_ROOT=3D/lkp/result/vpx/micro/xfstes=
ts/4HDD-ext4-generic-mid/x86_64-lkp/82fab9c8db671c048c28350ac144805a3a5bc89=
b/9 initrd=3D/kernel-tests/initrd/lkp-rootfs.cgz root=3D/dev/ram0 ip=3D::::=
vpx-4::dhcp oops=3Dpanic earlyprintk=3DttyS0,115200 debug apic=3Ddebug sysr=
q_always_enabled panic=3D10 load_ramdisk=3D2 prompt_ramdisk=3D0 console=3Dt=
tyS0,115200 console=3Dtty0 vga=3Dnormal
[    0.000000] e820: BIOS-provided physical RAM map:
[    0.000000] BIOS-e820: [mem 0x0000000000000000-0x000000000009fbff] usable
[    0.000000] BIOS-e820: [mem 0x000000000009fc00-0x000000000009ffff] reser=
ved
[    0.000000] BIOS-e820: [mem 0x00000000000f0000-0x00000000000fffff] reser=
ved
[    0.000000] BIOS-e820: [mem 0x0000000000100000-0x00000000dfffdfff] usable
[    0.000000] BIOS-e820: [mem 0x00000000dfffe000-0x00000000dfffffff] reser=
ved
[    0.000000] BIOS-e820: [mem 0x00000000feffc000-0x00000000feffffff] reser=
ved
[    0.000000] BIOS-e820: [mem 0x00000000fffc0000-0x00000000ffffffff] reser=
ved
[    0.000000] BIOS-e820: [mem 0x0000000100000000-0x000000011fffffff] usable
[    0.000000] bootconsole [earlyser0] enabled
[    0.000000] NX (Execute Disable) protection: active
[    0.000000] SMBIOS 2.4 present.
[    0.000000] DMI: Bochs Bochs, BIOS Bochs 01/01/2011
[    0.000000] Hypervisor detected: KVM
[    0.000000] e820: update [mem 0x00000000-0x00000fff] usable =3D=3D> rese=
rved
[    0.000000] e820: remove [mem 0x000a0000-0x000fffff] usable
[    0.000000] No AGP bridge found
[    0.000000] e820: last_pfn =3D 0x120000 max_arch_pfn =3D 0x400000000
[    0.000000] MTRR default type: write-back
[    0.000000] MTRR fixed ranges enabled:
[    0.000000]   00000-9FFFF write-back
[    0.000000]   A0000-BFFFF uncachable
[    0.000000]   C0000-FFFFF write-protect
[    0.000000] MTRR variable ranges enabled:
[    0.000000]   0 base 00E0000000 mask FFE0000000 uncachable
[    0.000000]   1 disabled
[    0.000000]   2 disabled
[    0.000000]   3 disabled
[    0.000000]   4 disabled
[    0.000000]   5 disabled
[    0.000000]   6 disabled
[    0.000000]   7 disabled
[    0.000000] x86 PAT enabled: cpu 0, old 0x70406, new 0x7010600070106
[    0.000000] e820: last_pfn =3D 0xdfffe max_arch_pfn =3D 0x400000000
[    0.000000] Scan for SMP in [mem 0x00000000-0x000003ff]
[    0.000000] Scan for SMP in [mem 0x0009fc00-0x0009ffff]
[    0.000000] Scan for SMP in [mem 0x000f0000-0x000fffff]
[    0.000000] found SMP MP-table at [mem 0x000fda90-0x000fda9f] mapped at =
[ffff8800000fda90]
[    0.000000]   mpc: fdaa0-fdbe4
[    0.000000] Scanning 1 areas for low memory corruption
[    0.000000] Base memory trampoline at [ffff880000099000] 99000 size 24576
[    0.000000] init_memory_mapping: [mem 0x00000000-0x000fffff]
[    0.000000]  [mem 0x00000000-0x000fffff] page 4k
[    0.000000] BRK [0x02664000, 0x02664fff] PGTABLE
[    0.000000] BRK [0x02665000, 0x02665fff] PGTABLE
[    0.000000] BRK [0x02666000, 0x02666fff] PGTABLE
[    0.000000] init_memory_mapping: [mem 0x11fe00000-0x11fffffff]
[    0.000000]  [mem 0x11fe00000-0x11fffffff] page 2M
[    0.000000] BRK [0x02667000, 0x02667fff] PGTABLE
[    0.000000] init_memory_mapping: [mem 0x11c000000-0x11fdfffff]
[    0.000000]  [mem 0x11c000000-0x11fdfffff] page 2M
[    0.000000] init_memory_mapping: [mem 0x100000000-0x11bffffff]
[    0.000000]  [mem 0x100000000-0x11bffffff] page 2M
[    0.000000] init_memory_mapping: [mem 0x00100000-0xdfffdfff]
[    0.000000]  [mem 0x00100000-0x001fffff] page 4k
[    0.000000]  [mem 0x00200000-0xdfdfffff] page 2M
[    0.000000]  [mem 0xdfe00000-0xdfffdfff] page 4k
[    0.000000] RAMDISK: [mem 0x73ce1000-0x7fffffff]
[    0.000000] ACPI: RSDP 00000000000fd880 000014 (v00 BOCHS )
[    0.000000] ACPI: RSDT 00000000dfffe380 000034 (v01 BOCHS  BXPCRSDT 0000=
0001 BXPC 00000001)
[    0.000000] ACPI: FACP 00000000dfffff80 000074 (v01 BOCHS  BXPCFACP 0000=
0001 BXPC 00000001)
[    0.000000] ACPI: DSDT 00000000dfffe3c0 0011A9 (v01   BXPC   BXDSDT 0000=
0001 INTL 20100528)
[    0.000000] ACPI: FACS 00000000dfffff40 000040
[    0.000000] ACPI: SSDT 00000000dffff6e0 000858 (v01 BOCHS  BXPCSSDT 0000=
0001 BXPC 00000001)
[    0.000000] ACPI: APIC 00000000dffff5b0 000090 (v01 BOCHS  BXPCAPIC 0000=
0001 BXPC 00000001)
[    0.000000] ACPI: HPET 00000000dffff570 000038 (v01 BOCHS  BXPCHPET 0000=
0001 BXPC 00000001)
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] mapped APIC to ffffffffff5f3000 (        fee00000)
[    0.000000] No NUMA configuration found
[    0.000000] Faking a node at [mem 0x0000000000000000-0x000000011fffffff]
[    0.000000] Initmem setup node 0 [mem 0x00000000-0x11fffffff]
[    0.000000]   NODE_DATA [mem 0xdfff9000-0xdfffdfff]
[    0.000000] kvm-clock: Using msrs 4b564d01 and 4b564d00
[    0.000000] kvm-clock: cpu 0, msr 0:dfff1001, boot clock
[   16.486400]  [ffffea0000000000-ffffea00047fffff] PMD -> [ffff8800db60000=
0-ffff8800df5fffff] on node 0
[   16.487280] Zone ranges:
[   16.487499]   DMA      [mem 0x00001000-0x00ffffff]
[   16.487924]   DMA32    [mem 0x01000000-0xffffffff]
[   16.488362]   Normal   [mem 0x100000000-0x11fffffff]
[   16.488800] Movable zone start for each node
[   16.489167] Early memory node ranges
[   16.489482]   node   0: [mem 0x00001000-0x0009efff]
[   16.489957]   node   0: [mem 0x00100000-0xdfffdfff]
[   16.490399]   node   0: [mem 0x100000000-0x11fffffff]
[   16.490885] On node 0 totalpages: 1048476
[   16.491248]   DMA zone: 64 pages used for memmap
[   16.491690]   DMA zone: 21 pages reserved
[   16.492038]   DMA zone: 3998 pages, LIFO batch:0
[   16.492549]   DMA32 zone: 14272 pages used for memmap
[   16.492985]   DMA32 zone: 913406 pages, LIFO batch:31
[   16.510190]   Normal zone: 2048 pages used for memmap
[   16.510682]   Normal zone: 131072 pages, LIFO batch:31
[   16.513970] ACPI: PM-Timer IO Port: 0xb008
[   16.514390] ACPI: Local APIC address 0xfee00000
[   16.514821] mapped APIC to ffffffffff5f3000 (        fee00000)
[   16.515418] ACPI: LAPIC (acpi_id[0x00] lapic_id[0x00] enabled)
[   16.516024] ACPI: LAPIC (acpi_id[0x01] lapic_id[0x01] enabled)
[   16.516550] ACPI: LAPIC (acpi_id[0x02] lapic_id[0x02] enabled)
[   16.517066] ACPI: LAPIC (acpi_id[0x03] lapic_id[0x03] enabled)
[   16.517579] ACPI: LAPIC_NMI (acpi_id[0xff] dfl dfl lint[0x1])
[   16.518075] ACPI: IOAPIC (id[0x00] address[0xfec00000] gsi_base[0])
[   16.518645] IOAPIC[0]: apic_id 0, version 17, address 0xfec00000, GSI 0-=
23
[   16.519242] ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
[   16.519796] Int: type 0, pol 0, trig 0, bus 00, IRQ 00, APIC ID 0, APIC =
INT 02
[   16.520421] ACPI: INT_SRC_OVR (bus 0 bus_irq 5 global_irq 5 high level)
[   16.520989] Int: type 0, pol 1, trig 3, bus 00, IRQ 05, APIC ID 0, APIC =
INT 05
[   16.521619] ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 high level)
[   16.522188] Int: type 0, pol 1, trig 3, bus 00, IRQ 09, APIC ID 0, APIC =
INT 09
[   16.522822] ACPI: INT_SRC_OVR (bus 0 bus_irq 10 global_irq 10 high level)
[   16.523409] Int: type 0, pol 1, trig 3, bus 00, IRQ 0a, APIC ID 0, APIC =
INT 0a
[   16.524030] ACPI: INT_SRC_OVR (bus 0 bus_irq 11 global_irq 11 high level)
[   16.524617] Int: type 0, pol 1, trig 3, bus 00, IRQ 0b, APIC ID 0, APIC =
INT 0b
[   16.525296] ACPI: IRQ0 used by override.
[   16.525640] Int: type 0, pol 0, trig 0, bus 00, IRQ 01, APIC ID 0, APIC =
INT 01
[   16.526291] ACPI: IRQ2 used by override.
[   16.526634] Int: type 0, pol 0, trig 0, bus 00, IRQ 03, APIC ID 0, APIC =
INT 03
[   16.527266] Int: type 0, pol 0, trig 0, bus 00, IRQ 04, APIC ID 0, APIC =
INT 04
[   16.527889] ACPI: IRQ5 used by override.
[   16.528231] Int: type 0, pol 0, trig 0, bus 00, IRQ 06, APIC ID 0, APIC =
INT 06
[   16.528861] Int: type 0, pol 0, trig 0, bus 00, IRQ 07, APIC ID 0, APIC =
INT 07
[   16.529490] Int: type 0, pol 0, trig 0, bus 00, IRQ 08, APIC ID 0, APIC =
INT 08
[   16.530115] ACPI: IRQ9 used by override.
[   16.530462] ACPI: IRQ10 used by override.
[   16.530807] ACPI: IRQ11 used by override.
[   16.531160] Int: type 0, pol 0, trig 0, bus 00, IRQ 0c, APIC ID 0, APIC =
INT 0c
[   16.531785] Int: type 0, pol 0, trig 0, bus 00, IRQ 0d, APIC ID 0, APIC =
INT 0d
[   16.532413] Int: type 0, pol 0, trig 0, bus 00, IRQ 0e, APIC ID 0, APIC =
INT 0e
[   16.533032] Int: type 0, pol 0, trig 0, bus 00, IRQ 0f, APIC ID 0, APIC =
INT 0f
[   16.533686] Using ACPI (MADT) for SMP configuration information
[   16.534234] ACPI: HPET id: 0x8086a201 base: 0xfed00000
[   16.534679] smpboot: Allowing 4 CPUs, 0 hotplug CPUs
[   16.535119] mapped IOAPIC to ffffffffff5f2000 (fec00000)
[   16.535577] nr_irqs_gsi: 40
[   16.535835] PM: Registered nosave memory: [mem 0x0009f000-0x0009ffff]
[   16.536394] PM: Registered nosave memory: [mem 0x000a0000-0x000effff]
[   16.536948] PM: Registered nosave memory: [mem 0x000f0000-0x000fffff]
[   16.537513] PM: Registered nosave memory: [mem 0xdfffe000-0xdfffffff]
[   16.538087] PM: Registered nosave memory: [mem 0xe0000000-0xfeffbfff]
[   16.538644] PM: Registered nosave memory: [mem 0xfeffc000-0xfeffffff]
[   16.539197] PM: Registered nosave memory: [mem 0xff000000-0xfffbffff]
[   16.539759] PM: Registered nosave memory: [mem 0xfffc0000-0xffffffff]
[   16.540316] e820: [mem 0xe0000000-0xfeffbfff] available for PCI devices
[   16.540882] Booting paravirtualized kernel on KVM
[   16.541299] setup_percpu: NR_CPUS:512 nr_cpumask_bits:512 nr_cpu_ids:4 n=
r_node_ids:1
[   16.542317] PERCPU: Embedded 27 pages/cpu @ffff8800dfc00000 s81088 r8192=
 d21312 u524288
[   16.543016] pcpu-alloc: s81088 r8192 d21312 u524288 alloc=3D1*2097152
[   16.543559] pcpu-alloc: [0] 0 1 2 3=20
[   16.543885] kvm-clock: cpu 0, msr 0:dfff1001, primary cpu clock
[   16.544431] KVM setup async PF for cpu 0
[   16.544771] kvm-stealtime: cpu 0, msr dfc0d040
[   16.545163] Built 1 zonelists in Node order, mobility grouping on.  Tota=
l pages: 1032071
[   16.545890] Policy zone: Normal
[   16.546166] Kernel command line: user=3Dlkp job=3D/lkp/scheduled/vpx-4/c=
yclic_xfstests-generic-4HDD-ext4-generic-mid-HEAD.yaml ARCH=3Dx86_64 BOOT_I=
MAGE=3D/kernel/x86_64-lkp/82fab9c8db671c048c28350ac144805a3a5bc89b/vmlinuz-=
3.13.0-rc8-next-20140115-10041-g82fab9c-dirty kconfig=3Dx86_64-lkp commit=
=3D82fab9c8db671c048c28350ac144805a3a5bc89b bm_initrd=3D/lkp/benchmarks/xfs=
tests.cgz modules_initrd=3D/kernel/x86_64-lkp/82fab9c8db671c048c28350ac1448=
05a3a5bc89b/modules.cgz max_uptime=3D1474 RESULT_ROOT=3D/lkp/result/vpx/mic=
ro/xfstests/4HDD-ext4-generic-mid/x86_64-lkp/82fab9c8db671c048c28350ac14480=
5a3a5bc89b/9 initrd=3D/kernel-tests/initrd/lkp-rootfs.cgz root=3D/dev/ram0 =
ip=3D::::vpx-4::dhcp oops=3Dpanic earlyprintk=3DttyS0,115200 debug apic=3Dd=
ebug sysrq_always_enabled panic=3D10 load_ramdisk=3D2 prompt_ramdisk=3D0 co=
nsole=3DttyS0,115200 console=3Dtty0 vga=3Dnormal
[   16.552924] sysrq: sysrq always enabled.
[   16.553381] PID hash table entries: 4096 (order: 3, 32768 bytes)
[   16.597230] Checking aperture...
[   16.640265] No AGP bridge found
[   16.652601] Memory: 3838724K/4193904K available (10431K kernel code, 125=
2K rwdata, 4164K rodata, 1436K init, 1748K bss, 355180K reserved)
[   16.653759] SLUB: HWalign=3D64, Order=3D0-3, MinObjects=3D0, CPUs=3D4, N=
odes=3D1
[   16.654338] Hierarchical RCU implementation.
[   16.654696]=20
[   16.655235]=20
[   16.655761] RCU: Adjusting geometry for rcu_fanout_leaf=3D16, nr_cpu_ids=
=3D4
[   16.656335] NR_IRQS:33024 nr_irqs:712 16
[   16.671168] Console: colour VGA+ 80x25
[   16.671489] console [tty0] enabled
[   16.671886] bootconsole [earlyser0] disabled
[   16.765235] console [ttyS0] enabled
[   16.776684] allocated 16777216 bytes of page_cgroup
[   16.777302] please try 'cgroup_disable=3Dmemory' option if you don't wan=
t memory cgroups
[   16.778452] hpet clockevent registered
[   16.779002] tsc: Detected 2693.528 MHz processor
[   16.779558] Calibrating delay loop (skipped) preset value.. 5387.05 Bogo=
MIPS (lpj=3D10774112)
[   16.780562] pid_max: default: 32768 minimum: 301
[   16.781365] Dentry cache hash table entries: 524288 (order: 10, 4194304 =
bytes)
[   16.785982] Inode-cache hash table entries: 262144 (order: 9, 2097152 by=
tes)
[   16.788520] Mount-cache hash table entries: 256
[   16.789709] Initializing cgroup subsys memory
[   16.790596] Initializing cgroup subsys devices
[   16.791445] Initializing cgroup subsys freezer
[   16.792281] Initializing cgroup subsys blkio
[   16.793098] Initializing cgroup subsys perf_event
[   16.793967] Initializing cgroup subsys hugetlb
[   16.794918] mce: CPU supports 10 MCE banks
[   16.795770] Last level iTLB entries: 4KB 0, 2MB 0, 4MB 0
[   16.795770] Last level dTLB entries: 4KB 0, 2MB 0, 4MB 0, 1GB 0
[   16.795770] tlb_flushall_shift: 6
[   16.798351] Freeing SMP alternatives memory: 44K (ffffffff824a2000 - fff=
fffff824ad000)
[   16.804075] ACPI: Core revision 20131218
[   16.805557] ACPI: All ACPI Tables successfully acquired
[   16.806651] ftrace: allocating 39939 entries in 157 pages
[   16.848138] Getting VERSION: 50014
[   16.848891] Getting VERSION: 50014
[   16.849627] Getting ID: 0
[   16.850280] Getting ID: ff000000
[   16.851017] Getting LVT0: 8700
[   16.851735] Getting LVT1: 8400
[   16.852478] enabled ExtINT on CPU#0
[   16.853906] ENABLING IO-APIC IRQs
[   16.854676] init IO_APIC IRQs
[   16.855368]  apic 0 pin 0 not connected
[   16.856140] IOAPIC[0]: Set routing entry (0-1 -> 0x31 -> IRQ 1 Mode:0 Ac=
tive:0 Dest:1)
[   16.857681] IOAPIC[0]: Set routing entry (0-2 -> 0x30 -> IRQ 0 Mode:0 Ac=
tive:0 Dest:1)
[   16.859214] IOAPIC[0]: Set routing entry (0-3 -> 0x33 -> IRQ 3 Mode:0 Ac=
tive:0 Dest:1)
[   16.860740] IOAPIC[0]: Set routing entry (0-4 -> 0x34 -> IRQ 4 Mode:0 Ac=
tive:0 Dest:1)
[   16.862266] IOAPIC[0]: Set routing entry (0-5 -> 0x35 -> IRQ 5 Mode:1 Ac=
tive:0 Dest:1)
[   16.863844] IOAPIC[0]: Set routing entry (0-6 -> 0x36 -> IRQ 6 Mode:0 Ac=
tive:0 Dest:1)
[   16.865350] IOAPIC[0]: Set routing entry (0-7 -> 0x37 -> IRQ 7 Mode:0 Ac=
tive:0 Dest:1)
[   16.866897] IOAPIC[0]: Set routing entry (0-8 -> 0x38 -> IRQ 8 Mode:0 Ac=
tive:0 Dest:1)
[   16.868403] IOAPIC[0]: Set routing entry (0-9 -> 0x39 -> IRQ 9 Mode:1 Ac=
tive:0 Dest:1)
[   16.869904] IOAPIC[0]: Set routing entry (0-10 -> 0x3a -> IRQ 10 Mode:1 =
Active:0 Dest:1)
[   16.871494] IOAPIC[0]: Set routing entry (0-11 -> 0x3b -> IRQ 11 Mode:1 =
Active:0 Dest:1)
[   16.873017] IOAPIC[0]: Set routing entry (0-12 -> 0x3c -> IRQ 12 Mode:0 =
Active:0 Dest:1)
[   16.874592] IOAPIC[0]: Set routing entry (0-13 -> 0x3d -> IRQ 13 Mode:0 =
Active:0 Dest:1)
[   16.876106] IOAPIC[0]: Set routing entry (0-14 -> 0x3e -> IRQ 14 Mode:0 =
Active:0 Dest:1)
[   16.877635] IOAPIC[0]: Set routing entry (0-15 -> 0x3f -> IRQ 15 Mode:0 =
Active:0 Dest:1)
[   16.879204]  apic 0 pin 16 not connected
[   16.879980]  apic 0 pin 17 not connected
[   16.880753]  apic 0 pin 18 not connected
[   16.881533]  apic 0 pin 19 not connected
[   16.882304]  apic 0 pin 20 not connected
[   16.883138]  apic 0 pin 21 not connected
[   16.883914]  apic 0 pin 22 not connected
[   16.884687]  apic 0 pin 23 not connected
[   16.885611] ..TIMER: vector=3D0x30 apic1=3D0 pin1=3D2 apic2=3D-1 pin2=3D=
-1
[   16.886787] smpboot: CPU0: Intel Common KVM processor (fam: 0f, model: 0=
6, stepping: 01)
[   16.888757] Using local APIC timer interrupts.
[   16.888757] calibrating APIC timer ...
[   16.998501] ... lapic delta =3D 6250704
[   16.999284] ... PM-Timer delta =3D 357979
[   17.000071] ... PM-Timer result ok
[   17.000820] ..... delta 6250704
[   17.001528] ..... mult: 268465692
[   17.002282] ..... calibration result: 4000450
[   17.003212] ..... CPU clock speed is 2693.2309 MHz.
[   17.004150] ..... host bus clock speed is 1000.0450 MHz.
[   17.005193] Performance Events: unsupported Netburst CPU model 6 no PMU =
driver, software events only.
[   17.008622] x86: Booting SMP configuration:
[   17.009489] .... node  #0, CPUs:      #1
[   17.020154] kvm-clock: cpu 1, msr 0:dfff1041, secondary cpu clock
[   17.021126] masked ExtINT on CPU#1
[   17.041650] KVM setup async PF for cpu 1
[   17.042857]  #2
[   17.042857] kvm-stealtime: cpu 1, msr dfc8d040
[   17.051786] kvm-clock: cpu 2, msr 0:dfff1081, secondary cpu clock
[   17.052787] masked ExtINT on CPU#2
[   17.073295] KVM setup async PF for cpu 2
[   17.074240]  #3
[   17.074240] kvm-stealtime: cpu 2, msr dfd0d040
[   17.083451] kvm-clock: cpu 3, msr 0:dfff10c1, secondary cpu clock
[   17.084425] masked ExtINT on CPU#3
[   17.104924] x86: Booted up 1 node, 4 CPUs
[   17.104928] KVM setup async PF for cpu 3
[   17.104931] kvm-stealtime: cpu 3, msr dfd8d040
[   17.107187] smpboot: Total of 4 processors activated (21548.22 BogoMIPS)
[   17.109070] devtmpfs: initialized
[   17.113841] xor: measuring software checksum speed
[   17.153198]    prefetch64-sse:   171.000 MB/sec
[   17.193192]    generic_sse:   168.000 MB/sec
[   17.193968] xor: using function: prefetch64-sse (171.000 MB/sec)
[   17.194898] atomic64 test passed for x86-64 platform with CX8 and with S=
SE
[   17.196061] NET: Registered protocol family 16
[   17.198337] cpuidle: using governor ladder
[   17.199094] cpuidle: using governor menu
[   17.200197] ACPI: bus type PCI registered
[   17.200947] acpiphp: ACPI Hot Plug PCI Controller Driver version: 0.5
[   17.202152] PCI: Using configuration type 1 for base access
[   17.224468] bio: create slab <bio-0> at 0
[   17.293211] raid6: sse2x1    8566 MB/s
[   17.361215] raid6: sse2x2   10416 MB/s
[   17.429208] raid6: sse2x4   12600 MB/s
[   17.429952] raid6: using algorithm sse2x4 (12600 MB/s)
[   17.430793] raid6: using intx1 recovery algorithm
[   17.431654] ACPI: Added _OSI(Module Device)
[   17.432422] ACPI: Added _OSI(Processor Device)
[   17.433198] ACPI: Added _OSI(3.0 _SCP Extensions)
[   17.434007] ACPI: Added _OSI(Processor Aggregator Device)
[   17.436393] ACPI: Interpreter enabled
[   17.437103] ACPI Exception: AE_NOT_FOUND, While evaluating Sleep State [=
\_S1_] (20131218/hwxface-580)
[   17.438772] ACPI Exception: AE_NOT_FOUND, While evaluating Sleep State [=
\_S2_] (20131218/hwxface-580)
[   17.440433] ACPI: (supports S0 S3 S4 S5)
[   17.441150] ACPI: Using IOAPIC for interrupt routing
[   17.442081] PCI: Using host bridge windows from ACPI; if necessary, use =
"pci=3Dnocrs" and report a bug
[   17.443858] ACPI: No dock devices found.
[   17.449949] ACPI: PCI Root Bridge [PCI0] (domain 0000 [bus 00-ff])
[   17.450914] acpi PNP0A03:00: _OSC: OS supports [ASPM ClockPM Segments MS=
I]
[   17.451929] acpi PNP0A03:00: _OSC failed (AE_NOT_FOUND); disabling ASPM
[   17.453025] acpi PNP0A03:00: fail to add MMCONFIG information, can't acc=
ess extended PCI configuration space under this bridge.
[   17.455195] acpiphp: Slot [3] registered
[   17.456023] acpiphp: Slot [4] registered
[   17.456858] acpiphp: Slot [5] registered
[   17.457689] acpiphp: Slot [6] registered
[   17.458521] acpiphp: Slot [7] registered
[   17.459353] acpiphp: Slot [8] registered
[   17.460187] acpiphp: Slot [9] registered
[   17.461024] acpiphp: Slot [10] registered
[   17.461886] acpiphp: Slot [11] registered
[   17.462723] acpiphp: Slot [12] registered
[   17.463562] acpiphp: Slot [13] registered
[   17.464401] acpiphp: Slot [14] registered
[   17.465236] acpiphp: Slot [15] registered
[   17.466069] acpiphp: Slot [16] registered
[   17.466897] acpiphp: Slot [17] registered
[   17.467724] acpiphp: Slot [18] registered
[   17.468548] acpiphp: Slot [19] registered
[   17.469409] acpiphp: Slot [20] registered
[   17.470226] acpiphp: Slot [21] registered
[   17.471028] acpiphp: Slot [22] registered
[   17.471833] acpiphp: Slot [23] registered
[   17.472643] acpiphp: Slot [24] registered
[   17.473514] acpiphp: Slot [25] registered
[   17.474323] acpiphp: Slot [26] registered
[   17.475123] acpiphp: Slot [27] registered
[   17.475930] acpiphp: Slot [28] registered
[   17.476735] acpiphp: Slot [29] registered
[   17.477592] acpiphp: Slot [30] registered
[   17.478397] acpiphp: Slot [31] registered
[   17.479146] PCI host bridge to bus 0000:00
[   17.479894] pci_bus 0000:00: root bus resource [bus 00-ff]
[   17.480778] pci_bus 0000:00: root bus resource [io  0x0000-0x0cf7]
[   17.481782] pci_bus 0000:00: root bus resource [io  0x0d00-0xffff]
[   17.482729] pci_bus 0000:00: root bus resource [mem 0x000a0000-0x000bfff=
f]
[   17.483740] pci_bus 0000:00: root bus resource [mem 0xe0000000-0xfebffff=
f]
[   17.484768] pci 0000:00:00.0: [8086:1237] type 00 class 0x060000
[   17.486075] pci 0000:00:01.0: [8086:7000] type 00 class 0x060100
[   17.487432] pci 0000:00:01.1: [8086:7010] type 00 class 0x010180
[   17.490984] pci 0000:00:01.1: reg 0x20: [io  0xc1c0-0xc1cf]
[   17.493024] pci 0000:00:01.3: [8086:7113] type 00 class 0x068000
[   17.494273] pci 0000:00:01.3: quirk: [io  0xb000-0xb03f] claimed by PIIX=
4 ACPI
[   17.495610] pci 0000:00:01.3: quirk: [io  0xb100-0xb10f] claimed by PIIX=
4 SMB
[   17.496864] pci 0000:00:02.0: [1013:00b8] type 00 class 0x030000
[   17.503629] pci 0000:00:02.0: reg 0x10: [mem 0xfc000000-0xfdffffff pref]
[   17.505837] pci 0000:00:02.0: reg 0x14: [mem 0xfebf0000-0xfebf0fff]
[   17.512377] pci 0000:00:02.0: reg 0x30: [mem 0xfebe0000-0xfebeffff pref]
[   17.514023] pci 0000:00:03.0: [8086:100e] type 00 class 0x020000
[   17.515879] pci 0000:00:03.0: reg 0x10: [mem 0xfeba0000-0xfebbffff]
[   17.522652] pci 0000:00:03.0: reg 0x14: [io  0xc000-0xc03f]
[   17.528027] pci 0000:00:03.0: reg 0x30: [mem 0xfebc0000-0xfebdffff pref]
[   17.529280] pci 0000:00:04.0: [1af4:1001] type 00 class 0x010000
[   17.531173] pci 0000:00:04.0: reg 0x10: [io  0xc040-0xc07f]
[   17.532957] pci 0000:00:04.0: reg 0x14: [mem 0xfebf1000-0xfebf1fff]
[   17.538754] pci 0000:00:05.0: [1af4:1001] type 00 class 0x010000
[   17.540626] pci 0000:00:05.0: reg 0x10: [io  0xc080-0xc0bf]
[   17.542477] pci 0000:00:05.0: reg 0x14: [mem 0xfebf2000-0xfebf2fff]
[   17.548292] pci 0000:00:06.0: [1af4:1001] type 00 class 0x010000
[   17.550204] pci 0000:00:06.0: reg 0x10: [io  0xc0c0-0xc0ff]
[   17.551984] pci 0000:00:06.0: reg 0x14: [mem 0xfebf3000-0xfebf3fff]
[   17.557774] pci 0000:00:07.0: [1af4:1001] type 00 class 0x010000
[   17.559640] pci 0000:00:07.0: reg 0x10: [io  0xc100-0xc13f]
[   17.561433] pci 0000:00:07.0: reg 0x14: [mem 0xfebf4000-0xfebf4fff]
[   17.567267] pci 0000:00:08.0: [1af4:1001] type 00 class 0x010000
[   17.569129] pci 0000:00:08.0: reg 0x10: [io  0xc140-0xc17f]
[   17.570944] pci 0000:00:08.0: reg 0x14: [mem 0xfebf5000-0xfebf5fff]
[   17.576804] pci 0000:00:09.0: [1af4:1001] type 00 class 0x010000
[   17.578724] pci 0000:00:09.0: reg 0x10: [io  0xc180-0xc1bf]
[   17.580514] pci 0000:00:09.0: reg 0x14: [mem 0xfebf6000-0xfebf6fff]
[   17.586305] pci 0000:00:0a.0: [8086:25ab] type 00 class 0x088000
[   17.587722] pci 0000:00:0a.0: reg 0x10: [mem 0xfebf7000-0xfebf700f]
[   17.592014] ACPI: PCI Interrupt Link [LNKA] (IRQs 5 *10 11)
[   17.593315] ACPI: PCI Interrupt Link [LNKB] (IRQs 5 *10 11)
[   17.594580] ACPI: PCI Interrupt Link [LNKC] (IRQs 5 10 *11)
[   17.595837] ACPI: PCI Interrupt Link [LNKD] (IRQs 5 10 *11)
[   17.597075] ACPI: PCI Interrupt Link [LNKS] (IRQs *9)
[   17.598626] ACPI: Enabled 16 GPEs in block 00 to 0F
[   17.600298] vgaarb: device added: PCI:0000:00:02.0,decodes=3Dio+mem,owns=
=3Dio+mem,locks=3Dnone
[   17.601740] vgaarb: loaded
[   17.602356] vgaarb: bridge control possible 0000:00:02.0
[   17.603545] SCSI subsystem initialized
[   17.604720] libata version 3.00 loaded.
[   17.605846] ACPI: bus type USB registered
[   17.606737] usbcore: registered new interface driver usbfs
[   17.607685] usbcore: registered new interface driver hub
[   17.608660] usbcore: registered new device driver usb
[   17.609780] pps_core: LinuxPPS API ver. 1 registered
[   17.610616] pps_core: Software ver. 5.3.6 - Copyright 2005-2007 Rodolfo =
Giometti <giometti@linux.it>
[   17.612203] PTP clock support registered
[   17.613258] EDAC MC: Ver: 3.0.0
[   17.614318] PCI: Using ACPI for IRQ routing
[   17.615077] PCI: pci_cache_line_size set to 64 bytes
[   17.616062] e820: reserve RAM buffer [mem 0x0009fc00-0x0009ffff]
[   17.617035] e820: reserve RAM buffer [mem 0xdfffe000-0xdfffffff]
[   17.618826] HPET: 3 timers in total, 0 timers will be used for per-cpu t=
imer
[   17.619908] hpet0: at MMIO 0xfed00000, IRQs 2, 8, 0
[   17.620979] hpet0: 3 comparators, 64-bit 100.000000 MHz counter
[   17.626757] Switched to clocksource kvm-clock
[   17.642020] pnp: PnP ACPI init
[   17.642711] ACPI: bus type PNP registered
[   17.643508] IOAPIC[0]: Set routing entry (0-8 -> 0x38 -> IRQ 8 Mode:0 Ac=
tive:0 Dest:15)
[   17.645058] pnp 00:00: Plug and Play ACPI device, IDs PNP0b00 (active)
[   17.646069] IOAPIC[0]: Set routing entry (0-1 -> 0x31 -> IRQ 1 Mode:0 Ac=
tive:0 Dest:15)
[   17.647639] pnp 00:01: Plug and Play ACPI device, IDs PNP0303 (active)
[   17.648650] IOAPIC[0]: Set routing entry (0-12 -> 0x3c -> IRQ 12 Mode:0 =
Active:0 Dest:15)
[   17.650205] pnp 00:02: Plug and Play ACPI device, IDs PNP0f13 (active)
[   17.651257] IOAPIC[0]: Set routing entry (0-6 -> 0x36 -> IRQ 6 Mode:0 Ac=
tive:0 Dest:15)
[   17.652690] pnp 00:03: [dma 2]
[   17.653448] pnp 00:03: Plug and Play ACPI device, IDs PNP0700 (active)
[   17.654468] IOAPIC[0]: Set routing entry (0-7 -> 0x37 -> IRQ 7 Mode:0 Ac=
tive:0 Dest:15)
[   17.656042] pnp 00:04: Plug and Play ACPI device, IDs PNP0400 (active)
[   17.657061] IOAPIC[0]: Set routing entry (0-4 -> 0x34 -> IRQ 4 Mode:0 Ac=
tive:0 Dest:15)
[   17.658588] pnp 00:05: Plug and Play ACPI device, IDs PNP0501 (active)
[   17.659809] pnp 00:06: Plug and Play ACPI device, IDs PNP0103 (active)
[   17.660879] pnp: PnP ACPI: found 7 devices
[   17.661627] ACPI: bus type PNP unregistered
[   17.675697] pci_bus 0000:00: resource 4 [io  0x0000-0x0cf7]
[   17.676599] pci_bus 0000:00: resource 5 [io  0x0d00-0xffff]
[   17.677490] pci_bus 0000:00: resource 6 [mem 0x000a0000-0x000bffff]
[   17.678442] pci_bus 0000:00: resource 7 [mem 0xe0000000-0xfebfffff]
[   17.679534] NET: Registered protocol family 2
[   17.680504] TCP established hash table entries: 32768 (order: 6, 262144 =
bytes)
[   17.681969] TCP bind hash table entries: 32768 (order: 7, 524288 bytes)
[   17.683046] TCP: Hash tables configured (established 32768 bind 32768)
[   17.684130] TCP: reno registered
[   17.684806] UDP hash table entries: 2048 (order: 4, 65536 bytes)
[   17.685790] UDP-Lite hash table entries: 2048 (order: 4, 65536 bytes)
[   17.686910] NET: Registered protocol family 1
[   17.688023] RPC: Registered named UNIX socket transport module.
[   17.688956] RPC: Registered udp transport module.
[   17.689758] RPC: Registered tcp transport module.
[   17.690565] RPC: Registered tcp NFSv4.1 backchannel transport module.
[   17.691563] pci 0000:00:00.0: Limiting direct PCI/PCI transfers
[   17.692501] pci 0000:00:01.0: PIIX3: Enabling Passive Release
[   17.693428] pci 0000:00:01.0: Activating ISA DMA hang workarounds
[   17.694398] pci 0000:00:02.0: Boot video device
[   17.695257] PCI: CLS 0 bytes, default 64
[   17.696066] Trying to unpack rootfs image as initramfs...
[   21.268452] Freeing initrd memory: 199804K (ffff880073ce1000 - ffff88008=
0000000)
[   21.269948] PCI-DMA: Using software bounce buffering for IO (SWIOTLB)
[   21.270947] software IO TLB [mem 0xd7600000-0xdb600000] (64MB) mapped at=
 [ffff8800d7600000-ffff8800db5fffff]
[   21.273021] kvm: no hardware support
[   21.274336] Scanning for low memory corruption every 60 seconds
[   21.275683] camellia-x86_64: performance on this CPU would be suboptimal=
: disabling camellia-x86_64.
[   21.277226] blowfish-x86_64: performance on this CPU would be suboptimal=
: disabling blowfish-x86_64.
[   21.278877] twofish-x86_64-3way: performance on this CPU would be subopt=
imal: disabling twofish-x86_64-3way.
[   21.281490] sha1_ssse3: Neither AVX nor SSSE3 is available/usable.
[   21.282452] PCLMULQDQ-NI instructions are not detected.
[   21.283346] AVX or AES-NI instructions are not detected.
[   21.284248] AVX instructions are not detected.
[   21.285051] AVX instructions are not detected.
[   21.285877] AVX instructions are not detected.
[   21.286681] AVX instructions are not detected.
[   21.289207] futex hash table entries: 1024 (order: 4, 65536 bytes)
[   21.309888] bounce pool size: 64 pages
[   21.310672] HugeTLB registered 2 MB page size, pre-allocated 0 pages
[   21.317594] VFS: Disk quotas dquot_6.5.2
[   21.318470] Dquot-cache hash table entries: 512 (order 0, 4096 bytes)
[   21.321645] NFS: Registering the id_resolver key type
[   21.322507] Key type id_resolver registered
[   21.323287] Key type id_legacy registered
[   21.324038] nfs4filelayout_init: NFSv4 File Layout Driver Registering...
[   21.325094] Installing knfsd (copyright (C) 1996 okir@monad.swb.de).
[   21.326750] ROMFS MTD (C) 2007 Red Hat, Inc.
[   21.327733] fuse init (API version 7.22)
[   21.328807] SGI XFS with ACLs, security attributes, realtime, large bloc=
k/inode numbers, no debug enabled
[   21.331948] bio: create slab <bio-1> at 1
[   21.333362] Btrfs loaded
[   21.333973] msgmni has been set to 7887
[   21.338185] NET: Registered protocol family 38
[   21.339033] Key type asymmetric registered
[   21.339983] Block layer SCSI generic (bsg) driver version 0.4 loaded (ma=
jor 250)
[   21.341486] io scheduler noop registered
[   21.342255] io scheduler deadline registered
[   21.343097] io scheduler cfq registered (default)
[   21.344263] pci_hotplug: PCI Hot Plug PCI Core version: 0.5
[   21.345360] pciehp: PCI Express Hot Plug Controller Driver version: 0.4
[   21.346565] input: Power Button as /devices/LNXSYSTM:00/LNXPWRBN:00/inpu=
t/input0
[   21.347990] ACPI: Power Button [PWRF]
[   21.349200] GHES: HEST is not enabled!
[   21.350444] ACPI: PCI Interrupt Link [LNKD] enabled at IRQ 11
[   21.351441] IOAPIC[0]: Set routing entry (0-11 -> 0x3b -> IRQ 11 Mode:1 =
Active:0 Dest:15)
[   21.354519] ACPI: PCI Interrupt Link [LNKA] enabled at IRQ 10
[   21.355515] IOAPIC[0]: Set routing entry (0-10 -> 0x3a -> IRQ 10 Mode:1 =
Active:0 Dest:15)
[   21.358658] ACPI: PCI Interrupt Link [LNKB] enabled at IRQ 10
[   21.361547] ACPI: PCI Interrupt Link [LNKC] enabled at IRQ 11
[   21.369845] Serial: 8250/16550 driver, 4 ports, IRQ sharing enabled
[   21.392297] 00:05: ttyS0 at I/O 0x3f8 (irq =3D 4, base_baud =3D 115200) =
is a 16550A
[   21.396065] Non-volatile memory driver v1.3
[   21.400371] brd: module loaded
[   21.402630] loop: module loaded
[   21.403510] virtio-pci 0000:00:04.0: irq 40 for MSI/MSI-X
[   21.404459] virtio-pci 0000:00:04.0: irq 41 for MSI/MSI-X
[   21.405513] blk-mq: CPU -> queue map
[   21.406214]   CPU 0 -> Queue 0
[   21.406902]   CPU 1 -> Queue 0
[   21.407607]   CPU 2 -> Queue 0
[   21.408260]   CPU 3 -> Queue 0
[   21.409526]  vda: unknown partition table
[   21.412119] virtio-pci 0000:00:05.0: irq 42 for MSI/MSI-X
[   21.413039] virtio-pci 0000:00:05.0: irq 43 for MSI/MSI-X
[   21.414112] blk-mq: CPU -> queue map
[   21.414859]   CPU 0 -> Queue 0
[   21.415532]   CPU 1 -> Queue 0
[   21.416205]   CPU 2 -> Queue 0
[   21.416846]   CPU 3 -> Queue 0
[   21.418384]  vdb: unknown partition table
[   21.420950] virtio-pci 0000:00:06.0: irq 44 for MSI/MSI-X
[   21.421938] virtio-pci 0000:00:06.0: irq 45 for MSI/MSI-X
[   21.428378] blk-mq: CPU -> queue map
[   21.429159]   CPU 0 -> Queue 0
[   21.429890]   CPU 1 -> Queue 0
[   21.430600]   CPU 2 -> Queue 0
[   21.431353]   CPU 3 -> Queue 0
[   21.432849]  vdc: unknown partition table
[   21.435203] virtio-pci 0000:00:07.0: irq 46 for MSI/MSI-X
[   21.436176] virtio-pci 0000:00:07.0: irq 47 for MSI/MSI-X
[   21.437246] blk-mq: CPU -> queue map
[   21.437972]   CPU 0 -> Queue 0
[   21.438690]   CPU 1 -> Queue 0
[   21.439406]   CPU 2 -> Queue 0
[   21.440116]   CPU 3 -> Queue 0
[   21.441372]  vdd: unknown partition table
[   21.443852] virtio-pci 0000:00:08.0: irq 48 for MSI/MSI-X
[   21.444775] virtio-pci 0000:00:08.0: irq 49 for MSI/MSI-X
[   21.445873] blk-mq: CPU -> queue map
[   21.446622]   CPU 0 -> Queue 0
[   21.447376]   CPU 1 -> Queue 0
[   21.448069]   CPU 2 -> Queue 0
[   21.448724]   CPU 3 -> Queue 0
[   21.450438]  vde: unknown partition table
[   21.453102] virtio-pci 0000:00:09.0: irq 50 for MSI/MSI-X
[   21.454067] virtio-pci 0000:00:09.0: irq 51 for MSI/MSI-X
[   21.455183] blk-mq: CPU -> queue map
[   21.455928]   CPU 0 -> Queue 0
[   21.456624]   CPU 1 -> Queue 0
[   21.457354]   CPU 2 -> Queue 0
[   21.458044]   CPU 3 -> Queue 0
[   21.459638]  vdf: unknown partition table
[   21.462028] lkdtm: No crash points registered, enable through debugfs
[   21.464140] Loading iSCSI transport class v2.0-870.
[   21.466064] Adaptec aacraid driver 1.2-0[30200]-ms
[   21.467064] aic94xx: Adaptec aic94xx SAS/SATA driver version 1.0.3 loaded
[   21.468354] qla2xxx [0000:00:00.0]-0005: : QLogic Fibre Channel HBA Driv=
er: 8.06.00.12-k.
[   21.470099] megaraid cmm: 2.20.2.7 (Release Date: Sun Jul 16 00:01:03 ES=
T 2006)
[   21.471737] megaraid: 2.20.5.1 (Release Date: Thu Nov 16 15:32:35 EST 20=
06)
[   21.472964] megasas: 06.700.06.00-rc1 Sat. Aug. 31 17:00:00 PDT 2013
[   21.474210] GDT-HA: Storage RAID Controller Driver. Version: 3.05
[   21.475344] RocketRAID 3xxx/4xxx Controller driver v1.8
[   21.476710] ata_piix 0000:00:01.1: version 2.13
[   21.479975] scsi0 : ata_piix
[   21.480934] scsi1 : ata_piix
[   21.481793] ata1: PATA max MWDMA2 cmd 0x1f0 ctl 0x3f6 bmdma 0xc1c0 irq 14
[   21.482916] ata2: PATA max MWDMA2 cmd 0x170 ctl 0x376 bmdma 0xc1c8 irq 15
[   21.484824] tun: Universal TUN/TAP device driver, 1.6
[   21.485758] tun: (C) 1999-2004 Max Krasnyansky <maxk@qualcomm.com>
[   21.487169] pcnet32: pcnet32.c:v1.35 21.Apr.2008 tsbogend@alpha.franken.=
de
[   21.488424] Atheros(R) L2 Ethernet Driver - version 2.2.3
[   21.489396] Copyright (c) 2007 Atheros Corporation.
[   21.490636] dmfe: Davicom DM9xxx net driver, version 1.36.4 (2002-01-17)
[   21.491834] v1.01-e (2.4 port) Sep-11-2006  Donald Becker <becker@scyld.=
com>
[   21.491834]   http://www.scyld.com/network/drivers.html
[   21.494056] uli526x: ULi M5261/M5263 net driver, version 0.9.3 (2005-7-2=
9)
[   21.495337] e100: Intel(R) PRO/100 Network Driver, 3.5.24-k2-NAPI
[   21.496374] e100: Copyright(c) 1999-2006 Intel Corporation
[   21.497415] e1000: Intel(R) PRO/1000 Network Driver - version 7.3.21-k8-=
NAPI
[   21.498557] e1000: Copyright (c) 1999-2006 Intel Corporation.
[   21.639241] ata2.01: NODEV after polling detection
[   21.640328] ata2.00: ATAPI: QEMU DVD-ROM, 1.6.0, max UDMA/100
[   21.641660] ata2.00: configured for MWDMA2
[   21.643019] scsi 1:0:0:0: CD-ROM            QEMU     QEMU DVD-ROM     1.=
6. PQ: 0 ANSI: 5
[   21.647151] scsi 1:0:0:0: Attached scsi generic sg0 type 5
[   21.823462] e1000 0000:00:03.0 eth0: (PCI:33MHz:32-bit) 52:54:00:12:34:56
[   21.824550] e1000 0000:00:03.0 eth0: Intel(R) PRO/1000 Network Connection
[   21.825850] e1000e: Intel(R) PRO/1000 Network Driver - 2.3.2-k
[   21.826835] e1000e: Copyright(c) 1999 - 2013 Intel Corporation.
[   21.828119] igb: Intel(R) Gigabit Ethernet Network Driver - version 5.0.=
5-k
[   21.829164] igb: Copyright (c) 2007-2013 Intel Corporation.
[   21.830393] ixgbe: Intel(R) 10 Gigabit PCI Express Network Driver - vers=
ion 3.15.1-k
[   21.831846] ixgbe: Copyright (c) 1999-2013 Intel Corporation.
[   21.833080] ixgb: Intel(R) PRO/10GbE Network Driver - version 1.0.135-k2=
-NAPI
[   21.834161] ixgb: Copyright (c) 1999-2008 Intel Corporation.
[   21.835695] sky2: driver version 1.30
[   21.838033] usbcore: registered new interface driver catc
[   21.839127] usbcore: registered new interface driver kaweth
[   21.840114] pegasus: v0.9.3 (2013/04/25), Pegasus/Pegasus II USB Etherne=
t driver
[   21.841732] usbcore: registered new interface driver pegasus
[   21.842853] usbcore: registered new interface driver rtl8150
[   21.843966] usbcore: registered new interface driver asix
[   21.845045] usbcore: registered new interface driver ax88179_178a
[   21.846201] usbcore: registered new interface driver cdc_ether
[   21.847336] usbcore: registered new interface driver r815x
[   21.848415] usbcore: registered new interface driver cdc_eem
[   21.849509] usbcore: registered new interface driver dm9601
[   21.850612] usbcore: registered new interface driver smsc75xx
[   21.851741] usbcore: registered new interface driver smsc95xx
[   21.852873] usbcore: registered new interface driver gl620a
[   21.854020] usbcore: registered new interface driver net1080
[   21.855210] usbcore: registered new interface driver plusb
[   21.856325] usbcore: registered new interface driver rndis_host
[   21.857475] usbcore: registered new interface driver cdc_subset
[   21.858597] usbcore: registered new interface driver zaurus
[   21.859805] usbcore: registered new interface driver MOSCHIP usb-etherne=
t driver
[   21.861509] usbcore: registered new interface driver int51x1
[   21.862658] usbcore: registered new interface driver ipheth
[   21.863819] usbcore: registered new interface driver sierra_net
[   21.865011] usbcore: registered new interface driver cdc_ncm
[   21.866045] Fusion MPT base driver 3.04.20
[   21.866904] Copyright (c) 1999-2008 LSI Corporation
[   21.867856] Fusion MPT SPI Host driver 3.04.20
[   21.868854] Fusion MPT FC Host driver 3.04.20
[   21.869860] Fusion MPT SAS Host driver 3.04.20
[   21.870881] Fusion MPT misc device (ioctl) driver 3.04.20
[   21.872116] mptctl: Registered with Fusion MPT base driver
[   21.873145] mptctl: /dev/mptctl @ (major,minor=3D10,220)
[   21.874547] ehci_hcd: USB 2.0 'Enhanced' Host Controller (EHCI) Driver
[   21.875697] ehci-pci: EHCI PCI platform driver
[   21.876697] ohci_hcd: USB 1.1 'Open' Host Controller (OHCI) Driver
[   21.877784] ohci-pci: OHCI PCI platform driver
[   21.878790] uhci_hcd: USB Universal Host Controller Interface driver
[   21.880144] usbcore: registered new interface driver usb-storage
[   21.881394] usbcore: registered new interface driver ums-alauda
[   21.882955] usbcore: registered new interface driver ums-datafab
[   21.884207] usbcore: registered new interface driver ums-freecom
[   21.885433] usbcore: registered new interface driver ums-isd200
[   21.887020] usbcore: registered new interface driver ums-jumpshot
[   21.888310] usbcore: registered new interface driver ums-sddr09
[   21.889503] usbcore: registered new interface driver ums-sddr55
[   21.890664] usbcore: registered new interface driver ums-usbat
[   21.891937] usbcore: registered new interface driver usbtest
[   21.893172] i8042: PNP: PS/2 Controller [PNP0303:KBD,PNP0f13:MOU] at 0x6=
0,0x64 irq 1,12
[   21.895553] serio: i8042 KBD port at 0x60,0x64 irq 1
[   21.896510] serio: i8042 AUX port at 0x60,0x64 irq 12
[   21.897818] mousedev: PS/2 mouse device common for all mice
[   21.899570] input: AT Translated Set 2 keyboard as /devices/platform/i80=
42/serio0/input/input1
[   21.901479] rtc_cmos 00:00: RTC can wake from S4
[   21.903088] rtc_cmos 00:00: rtc core: registered rtc_cmos as rtc0
[   21.904448] rtc_cmos 00:00: alarms up to one day, 114 bytes nvram, hpet =
irqs
[   21.905845] i6300esb: Intel 6300ESB WatchDog Timer Driver v0.05
[   21.907433] i6300esb: initialized (0xffffc9000072a000). heartbeat=3D30 s=
ec (nowayout=3D0)
[   21.909211] iTCO_wdt: Intel TCO WatchDog Timer Driver v1.10
[   21.910366] iTCO_vendor_support: vendor-support=3D0
[   21.911428] watchdog: Software Watchdog: cannot register miscdev on mino=
r=3D130 (err=3D-16).
[   21.913169] watchdog: Software Watchdog: a legacy watchdog module is pro=
bably present.
[   21.915186] softdog: Software Watchdog Timer: 0.08 initialized. soft_nob=
oot=3D0 soft_margin=3D60 sec soft_panic=3D0 (nowayout=3D0)
[   21.917403] md: linear personality registered for level -1
[   21.918443] md: raid0 personality registered for level 0
[   21.919483] md: raid1 personality registered for level 1
[   21.920555] md: raid10 personality registered for level 10
[   21.921825] md: raid6 personality registered for level 6
[   21.922903] md: raid5 personality registered for level 5
[   21.923919] md: raid4 personality registered for level 4
[   21.924932] md: multipath personality registered for level -4
[   21.925997] md: faulty personality registered for level -5
[   21.927884] device-mapper: ioctl: 4.27.0-ioctl (2013-10-30) initialised:=
 dm-devel@redhat.com
[   21.930090] device-mapper: multipath: version 1.6.0 loaded
[   21.931190] device-mapper: multipath round-robin: version 1.0.0 loaded
[   21.932379] device-mapper: cache-policy-mq: version 1.2.0 loaded
[   21.933484] device-mapper: cache cleaner: version 1.0.0 loaded
[   21.934856] dcdbas dcdbas: Dell Systems Management Base Driver (version =
5.6.0-3.2)
[   21.938293] usbcore: registered new interface driver usbhid
[   21.939366] usbhid: USB HID core driver
[   21.940423] TCP: bic registered
[   21.941177] Initializing XFRM netlink socket
[   21.942402] NET: Registered protocol family 10
[   21.943541] sit: IPv6 over IPv4 tunneling driver
[   21.944757] NET: Registered protocol family 17
[   21.945683] 8021q: 802.1Q VLAN Support v1.8
[   21.947557] sctp: Hash tables configured (established 65536 bind 65536)
[   21.948907] Key type dns_resolver registered
[   21.950693]=20
[   21.950693] printing PIC contents
[   21.951990] ... PIC  IMR: ffff
[   21.952722] ... PIC  IRR: 9113
[   21.953461] ... PIC  ISR: 0000
[   21.959714] ... PIC ELCR: 0c00
[   21.960469] printing local APIC contents on CPU#0/0:
[   21.961425] ... APIC ID:      00000000 (0)
[   21.962276] ... APIC VERSION: 00050014
[   21.963055] ... APIC TASKPRI: 00000000 (00)
[   21.963831] ... APIC PROCPRI: 00000000
[   21.964595] ... APIC LDR: 01000000
[   21.965301] ... APIC DFR: ffffffff
[   21.966001] ... APIC SPIV: 000001ff
[   21.966704] ... APIC ISR field:
[   21.967418] 000000000000000000000000000000000000000000000000000000000000=
0000
[   21.968996] ... APIC TMR field:
[   21.969663] 000000000200000000000000000000000000000000000000000000000000=
0000
[   21.971275] ... APIC IRR field:
[   21.971945] 000000000000000000000000000000000000000000000000000000000000=
0000
[   21.973540] ... APIC ESR: 00000000
[   21.974258] ... APIC ICR: 000008fd
[   21.974996] ... APIC ICR2: 04000000
[   21.975699] ... APIC LVTT: 000000ef
[   21.976415] ... APIC LVTPC: 00010000
[   21.977130] ... APIC LVT0: 00010700
[   21.977839] ... APIC LVT1: 00000400
[   21.978545] ... APIC LVTERR: 000000fe
[   21.979306] ... APIC TMICT: 0131ba62
[   21.980022] ... APIC TMCCT: 01154cb2
[   21.980734] ... APIC TDCR: 00000003
[   21.981438]=20
[   21.981953] number of MP IRQ sources: 15.
[   21.982747] number of IO-APIC #0 registers: 24.
[   21.983589] testing the IO APIC.......................
[   21.984502] IO APIC #0......
[   21.985156] .... register #00: 00000000
[   21.985899] .......    : physical APIC id: 00
[   21.986698] .......    : Delivery Type: 0
[   21.987537] .......    : LTS          : 0
[   21.988303] .... register #01: 00170011
[   21.989050] .......     : max redirection entries: 17
[   21.989970] .......     : PRQ implemented: 0
[   21.990847] .......     : IO APIC version: 11
[   21.991649] .... register #02: 00000000
[   21.992397] .......     : arbitration: 00
[   21.993186] .... IRQ redirection table:
[   21.993944] 1    0    0   0   0    0    0    00
[   21.994817] 0    0    0   0   0    1    1    31
[   21.995681] 0    0    0   0   0    1    1    30
[   21.996526] 0    0    0   0   0    1    1    33
[   21.997347] 1    0    0   0   0    1    1    34
[   21.998210] 1    1    0   0   0    1    1    35
[   21.999135] 0    0    0   0   0    1    1    36
[   22.000042] 0    0    0   0   0    1    1    37
[   22.000938] 0    0    0   0   0    1    1    38
[   22.001787] 0    1    0   0   0    1    1    39
[   22.002613] 1    1    0   0   0    1    1    3A
[   22.003476] 1    1    0   0   0    1    1    3B
[   22.004299] 0    0    0   0   0    1    1    3C
[   22.005144] 0    0    0   0   0    1    1    3D
[   22.005961] 0    0    0   0   0    1    1    3E
[   22.006804] 0    0    0   0   0    1    1    3F
[   22.007664] 1    0    0   0   0    0    0    00
[   22.008486] 1    0    0   0   0    0    0    00
[   22.009309] 1    0    0   0   0    0    0    00
[   22.010160] 1    0    0   0   0    0    0    00
[   22.011014] 1    0    0   0   0    0    0    00
[   22.011836] 1    0    0   0   0    0    0    00
[   22.012657] 1    0    0   0   0    0    0    00
[   22.013504] 1    0    0   0   0    0    0    00
[   22.014316] IRQ to pin mappings:
[   22.015036] IRQ0 -> 0:2
[   22.015798] IRQ1 -> 0:1
[   22.016538] IRQ3 -> 0:3
[   22.017284] IRQ4 -> 0:4
[   22.018024] IRQ5 -> 0:5
[   22.018807] IRQ6 -> 0:6
[   22.019559] IRQ7 -> 0:7
[   22.020298] IRQ8 -> 0:8
[   22.021058] IRQ9 -> 0:9
[   22.021818] IRQ10 -> 0:10
[   22.022599] IRQ11 -> 0:11
[   22.023389] IRQ12 -> 0:12
[   22.024166] IRQ13 -> 0:13
[   22.024914] IRQ14 -> 0:14
[   22.025669] IRQ15 -> 0:15
[   22.026422] .................................... done.
[   22.028251] registered taskstats version 1
[   22.029734] rtc_cmos 00:00: setting system clock to 2014-01-16 11:57:35 =
UTC (1389873455)
[   22.031296] BIOS EDD facility v0.16 2004-Jun-25, 6 devices found
[   22.036663] IPv6: ADDRCONF(NETDEV_UP): eth0: link is not ready
[   22.037647] 8021q: adding VLAN 0 to HW filter on device eth0
[   22.270856] tsc: Refined TSC clocksource calibration: 2693.414 MHz
[   22.533817] input: ImExPS/2 Generic Explorer Mouse as /devices/platform/=
i8042/serio1/input/input3
[   24.043355] e1000: eth0 NIC Link is Up 1000 Mbps Full Duplex, Flow Contr=
ol: RX
[   24.046805] IPv6: ADDRCONF(NETDEV_CHANGE): eth0: link becomes ready
[   24.062792] Sending DHCP requests ., OK
[   24.118798] IP-Config: Got DHCP answer from 10.0.2.2, my address is 10.0=
=2E2.15
[   24.120156] IP-Config: Complete:
[   24.120923]      device=3Deth0, hwaddr=3D52:54:00:12:34:56, ipaddr=3D10.=
0.2.15, mask=3D255.255.255.0, gw=3D10.0.2.2
[   24.122689]      host=3Dvpx-4, domain=3D, nis-domain=3D(none)
[   24.123688]      bootserver=3D10.0.2.2, rootserver=3D10.0.2.2, rootpath=
=3D
[   24.124425]      nameserver0=3D10.0.2.3
[   24.125737] PM: Hibernation image not present or could not be loaded.
[   24.128394] Freeing unused kernel memory: 1436K (ffffffff8233b000 - ffff=
ffff824a2000)
[   24.129998] Write protecting the kernel read-only data: 18432k
[   24.135434] Freeing unused kernel memory: 1844K (ffff880001a33000 - ffff=
880001c00000)
[   24.141174] Freeing unused kernel memory: 1980K (ffff880002011000 - ffff=
880002200000)
[   24.328746] microcode: CPU0 sig=3D0xf61, pf=3D0x1, revision=3D0x1
[   24.332726] microcode: CPU1 sig=3D0xf61, pf=3D0x1, revision=3D0x1
[   24.333833] microcode: CPU2 sig=3D0xf61, pf=3D0x1, revision=3D0x1
[   24.334939] microcode: CPU3 sig=3D0xf61, pf=3D0x1, revision=3D0x1
[   24.336584] microcode: Microcode Update Driver: v2.00 <tigran@aivazian.f=
snet.co.uk>, Peter Oruba
[   24.640295] random: vgscan urandom read with 20 bits of entropy available

=3D=3D> /tmp/run_log <=3D=3D
Kernel tests: Boot OK!
PATH=3D/sbin:/usr/sbin:/bin:/usr/bin

=3D=3D> /tmp/err_log <=3D=3D

=3D=3D> /tmp/run_log <=3D=3D
downloading latest lkp src code
Kernel tests: Boot OK 2!
/lkp/lkp/src/bin/run-lkp
LKP_SRC_DIR=3D/lkp/lkp/src
RESULT_ROOT=3D/lkp/result/vpx/micro/xfstests/4HDD-ext4-generic-mid/x86_64-l=
kp/82fab9c8db671c048c28350ac144805a3a5bc89b/9
job=3D/lkp/scheduled/vpx-4/cyclic_xfstests-generic-4HDD-ext4-generic-mid-HE=
AD.yaml
2014-01-16 11:57:52 mount -t debugfs none /sys/kernel/debug
run-job /lkp/scheduled/vpx-4/cyclic_xfstests-generic-4HDD-ext4-generic-mid-=
HEAD.yaml
run: /lkp/lkp/src/setup/disk
run: /lkp/lkp/src/setup/fs
2014-01-16 11:57:54 mkfs -t ext4 -q /dev/vdb
2014-01-16 11:57:54 mkfs -t ext4 -q /dev/vdc
2014-01-16 11:57:54 mkfs -t ext4 -q /dev/vdd
2014-01-16 11:57:54 mkfs -t ext4 -q /dev/vda
run: /lkp/lkp/src/monitors/event/wait pre-test
2014-01-16 11:57:55 mount -t ext4 /dev/vda /fs/vda
[   41.694050] EXT4-fs (vda): mounted filesystem with ordered data mode. Op=
ts: (null)
2014-01-16 11:57:55 mount -t ext4 /dev/vdb /fs/vdb
[   41.710324] EXT4-fs (vdb): mounted filesystem with ordered data mode. Op=
ts: (null)
2014-01-16 11:57:55 mount -t ext4 /dev/vdc /fs/vdc
[   41.727113] EXT4-fs (vdc): mounted filesystem with ordered data mode. Op=
ts: (null)
2014-01-16 11:57:55 mount -t ext4 /dev/vdd /fs/vdd
[   41.743231] EXT4-fs (vdd): mounted filesystem with ordered data mode. Op=
ts: (null)
run: pre-test
run: /lkp/lkp/src/monitors/wrapper uptime
run: /lkp/lkp/src/monitors/wrapper iostat
run: /lkp/lkp/src/monitors/wrapper vmstat
run: /lkp/lkp/src/monitors/wrapper numa-numastat
run: /lkp/lkp/src/monitors/wrapper numa-vmstat
run: /lkp/lkp/src/monitors/wrapper numa-meminfo
run: /lkp/lkp/src/monitors/wrapper proc-vmstat
run: /lkp/lkp/src/monitors/wrapper meminfo
run: /lkp/lkp/src/monitors/wrapper slabinfo
run: /lkp/lkp/src/monitors/wrapper interrupts
run: /lkp/lkp/src/monitors/wrapper lock_stat
run: /lkp/lkp/src/monitors/wrapper softirqs
run: /lkp/lkp/src/monitors/wrapper bdi_dev_mapping
run: /lkp/lkp/src/monitors/wrapper pmeter
run: /lkp/lkp/src/monitors/wrapper diskstats
run: /lkp/lkp/src/monitors/wrapper zoneinfo
run: /lkp/lkp/src/monitors/wrapper energy
run: /usr/bin/time -v -o /tmp/time /lkp/lkp/src/tests/micro/wrapper xfstests
[   43.535412] EXT4-fs (vda): mounted filesystem with ordered data mode. Op=
ts: (null)
[   44.116001] EXT4-fs (vdd): mounted filesystem with ordered data mode. Op=
ts: acl,user_xattr
[   44.565186] EXT4-fs (vda): mounted filesystem with ordered data mode. Op=
ts: acl,user_xattr
[   46.700903] EXT4-fs (vdd): mounted filesystem with ordered data mode. Op=
ts: acl,user_xattr
[   50.150273] random: nonblocking pool is initialized
[   96.887346] EXT4-fs (vdd): mounted filesystem with ordered data mode. Op=
ts: acl,user_xattr
[  100.993328] EXT4-fs (vda): mounted filesystem with ordered data mode. Op=
ts: acl,user_xattr
[  114.798775] EXT4-fs (vda): mounted filesystem with ordered data mode. Op=
ts: acl,user_xattr
[  125.282656] EXT4-fs (vdd): mounted filesystem with ordered data mode. Op=
ts: acl,user_xattr
[  153.366978] EXT4-fs (vdd): mounted filesystem with ordered data mode. Op=
ts: acl,user_xattr
[  154.667555] EXT4-fs (vda): mounted filesystem with ordered data mode. Op=
ts: acl,user_xattr
[  155.851851] EXT4-fs (vdd): mounted filesystem with ordered data mode. Op=
ts: acl,user_xattr
[  172.272371] EXT4-fs (vda): mounted filesystem with ordered data mode. Op=
ts: acl,user_xattr
[  235.817659] EXT4-fs (vda): mounted filesystem with ordered data mode. Op=
ts: acl,user_xattr
[  241.940342] EXT4-fs (vdd): mounted filesystem with ordered data mode. Op=
ts: acl,user_xattr
[  244.737884] EXT4-fs (vda): mounted filesystem with ordered data mode. Op=
ts: acl,user_xattr
[  285.140286] EXT4-fs (vda): mounted filesystem with ordered data mode. Op=
ts: (null)
[  285.575645] EXT4-fs (vda): mounted filesystem with ordered data mode. Op=
ts: acl,user_xattr
[  316.406651] EXT4-fs (vda): mounted filesystem with ordered data mode. Op=
ts: acl,user_xattr
[  317.022212] EXT4-fs (vdd): mounted filesystem with ordered data mode. Op=
ts: acl,user_xattr
[  317.572170] EXT4-fs (vdd): mounted filesystem with ordered data mode. Op=
ts: acl,user_xattr
[  318.152542] EXT4-fs (vdd): mounted filesystem with ordered data mode. Op=
ts: acl,user_xattr
[  318.764669] EXT4-fs (vdd): mounted filesystem with ordered data mode. Op=
ts: acl,user_xattr
[  319.520132] EXT4-fs (vdd): mounted filesystem with ordered data mode. Op=
ts: acl,user_xattr
[  320.509934] EXT4-fs (vda): mounted filesystem with ordered data mode. Op=
ts: acl,user_xattr
[  321.062590] EXT4-fs (vdd): mounted filesystem with ordered data mode. Op=
ts: acl,user_xattr
[  322.006691] EXT4-fs (vda): mounted filesystem with ordered data mode. Op=
ts: acl,user_xattr
[  322.264136] EXT4-fs (vdd): mounted filesystem with ordered data mode. Op=
ts: acl,user_xattr
[  323.295422] EXT4-fs (vdd): mounted filesystem with ordered data mode. Op=
ts: acl,user_xattr
[  324.241128] EXT4-fs (vda): mounted filesystem with ordered data mode. Op=
ts: acl,user_xattr
[  324.812479] EXT4-fs (vdd): mounted filesystem with ordered data mode. Op=
ts: acl,user_xattr,usrquota,grpquota
[  324.816498] EXT4-fs (vdd): re-mounted. Opts: (null)
[  324.819090] EXT4-fs (vdd): re-mounted. Opts: (null)
[  324.857303] EXT4-fs (vdd): mounted filesystem with ordered data mode. Op=
ts: acl,user_xattr,usrquota
[  333.810346] EXT4-fs (vdd): mounted filesystem with ordered data mode. Op=
ts: acl,user_xattr,grpquota
[  340.377692] EXT4-fs (vda): mounted filesystem with ordered data mode. Op=
ts: acl,user_xattr
[  413.211167] EXT4-fs (vda): mounted filesystem with ordered data mode. Op=
ts: acl,user_xattr
[  418.658611] EXT4-fs (vda): mounted filesystem with ordered data mode. Op=
ts: acl,user_xattr
[  419.649731] EXT4-fs (vdd): mounted filesystem with ordered data mode. Op=
ts: acl,user_xattr
[  445.991723] EXT4-fs (vda): mounted filesystem with ordered data mode. Op=
ts: acl,user_xattr
[  449.390196] EXT4-fs (vdd): mounted filesystem with ordered data mode. Op=
ts: acl,user_xattr
[  456.122979] EXT4-fs (vdd): Delayed block allocation failed for inode 13 =
at logical offset 367137 with max blocks 2048 with error 28
[  456.129367] EXT4-fs (vdd): This should not happen!! Data will be lost
[  456.129367]=20
[  456.130985] EXT4-fs (vdd): Total free blocks count 0
[  456.132330] EXT4-fs (vdd): Free/Dirty block details
[  456.133325] EXT4-fs (vdd): free_blocks=3D212443
[  456.137180] EXT4-fs (vdd): dirty_blocks=3D208347
[  456.138048] EXT4-fs (vdd): Block reservation details
[  456.139083] EXT4-fs (vdd): i_reserved_data_blocks=3D9222
[  456.140076] EXT4-fs (vdd): i_reserved_meta_blocks=3D1111
[  456.141047] EXT4-fs (vdd): i_allocated_meta_blocks=3D0
[  460.182192] EXT4-fs (vda): mounted filesystem with ordered data mode. Op=
ts: acl,user_xattr
[  471.635385] Unregister pv shared memory for cpu 0
[  471.635387] Unregister pv shared memory for cpu 1
[  471.635390] Unregister pv shared memory for cpu 2
[  471.638089] Unregister pv shared memory for cpu 3
[  471.642715] reboot: Restarting system
[  471.643472] reboot: machine restart
Elapsed time: 350
numactl --preferred=3D0 --physcpubind=3D16-19 qemu-system-x86_64 -cpu kvm64=
 -enable-kvm -kernel /kernel/x86_64-lkp/82fab9c8db671c048c28350ac144805a3a5=
bc89b/vmlinuz-3.13.0-rc8-next-20140115-10041-g82fab9c-dirty -append 'user=
=3Dlkp job=3D/lkp/scheduled/vpx-4/cyclic_xfstests-generic-4HDD-ext4-generic=
-mid-HEAD.yaml ARCH=3Dx86_64 BOOT_IMAGE=3D/kernel/x86_64-lkp/82fab9c8db671c=
048c28350ac144805a3a5bc89b/vmlinuz-3.13.0-rc8-next-20140115-10041-g82fab9c-=
dirty kconfig=3Dx86_64-lkp commit=3D82fab9c8db671c048c28350ac144805a3a5bc89=
b bm_initrd=3D/lkp/benchmarks/xfstests.cgz modules_initrd=3D/kernel/x86_64-=
lkp/82fab9c8db671c048c28350ac144805a3a5bc89b/modules.cgz max_uptime=3D1474 =
RESULT_ROOT=3D/lkp/result/vpx/micro/xfstests/4HDD-ext4-generic-mid/x86_64-l=
kp/82fab9c8db671c048c28350ac144805a3a5bc89b/9 initrd=3D/kernel-tests/initrd=
/lkp-rootfs.cgz root=3D/dev/ram0 ip=3D::::vpx-4::dhcp oops=3Dpanic earlypri=
ntk=3DttyS0,115200 debug apic=3Ddebug sysrq_always_enabled panic=3D10 load_=
ramdisk=3D2 prompt_ramdisk=3D0 console=3DttyS0,115200 console=3Dtty0 vga=3D=
normal'  -initrd /fs/sde1/initrd-vpx-4 -m 4G -smp 4 -net nic,vlan=3D1,model=
=3De1000 -net user,vlan=3D1,hostfwd=3Dtcp::9823-:22 -boot order=3Dnc -no-re=
boot -watchdog i6300esb -rtc base=3Dlocaltime -drive file=3D/fs/sde1/disk0-=
vpx-4,media=3Ddisk,if=3Dvirtio -drive file=3D/fs/sde1/disk1-vpx-4,media=3Dd=
isk,if=3Dvirtio -drive file=3D/fs/sde1/disk2-vpx-4,media=3Ddisk,if=3Dvirtio=
 -drive file=3D/fs/sde1/disk3-vpx-4,media=3Ddisk,if=3Dvirtio -drive file=3D=
/fs/sde1/disk4-vpx-4,media=3Ddisk,if=3Dvirtio -drive file=3D/fs/sde1/disk5-=
vpx-4,media=3Ddisk,if=3Dvirtio -pidfile /dev/shm/kboot/pid-vpx-4 -serial fi=
le:/dev/shm/kboot/serial-vpx-4 -daemonize -display none -monitor null=20

--Kj7319i9nmIyA2yE--
