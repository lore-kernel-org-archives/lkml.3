Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756153Ab3KWDWk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Nov 2013 22:22:40 -0500
Received: from mga03.intel.com ([143.182.124.21]:51123 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755577Ab3KWDWd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Nov 2013 22:22:33 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.93,756,1378882800"; 
   d="scan'208";a="432494775"
Date: Sat, 23 Nov 2013 11:22:05 +0800
From: fengguang.wu@intel.com
To: "Li, Shaohua" <shaohua.li@intel.com>
Cc: NeilBrown <neilb@suse.de>, LKML <linux-kernel@vger.kernel.org>
Subject: kernel BUG at drivers/md/raid5.c:693!
Message-ID: <20131123032205.GB20794@localhost>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="mYCpIKhGyMATD0i+"
Content-Disposition: inline
User-Agent: Heirloom mailx 12.5 6/20/10
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--mYCpIKhGyMATD0i+
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Shaohua,

FYI, we are still seeing this bug.. dmesg attached.

566c09c53455d7c4f1130928ef8071da1a24ea65 is the first bad commit
commit 566c09c53455d7c4f1130928ef8071da1a24ea65
Author: Shaohua Li <shli@kernel.org>
Date:   Thu Nov 14 15:16:17 2013 +1100

    raid5: relieve lock contention in get_active_stripe()
    
    get_active_stripe() is the last place we have lock contention. It has two
    paths. One is stripe isn't found and new stripe is allocated, the other is
    stripe is found.
    
    The first path basically calls __find_stripe and init_stripe. It accesses
    conf->generation, conf->previous_raid_disks, conf->raid_disks,
    conf->prev_chunk_sectors, conf->chunk_sectors, conf->max_degraded,
    conf->prev_algo, conf->algorithm, the stripe_hashtbl and inactive_list. Except
    stripe_hashtbl and inactive_list, other fields are changed very rarely.
    
    With this patch, we split inactive_list and add new hash locks. Each free
    stripe belongs to a specific inactive list. Which inactive list is determined
    by stripe's lock_hash. Note, even a stripe hasn't a sector assigned, it has a
    lock_hash assigned. Stripe's inactive list is protected by a hash lock, which
    is determined by it's lock_hash too. The lock_hash is derivied from current
    stripe_hashtbl hash, which guarantees any stripe_hashtbl list will be assigned
    to a specific lock_hash, so we can use new hash lock to protect stripe_hashtbl
    list too. The goal of the new hash locks introduced is we can only use the new
    locks in the first path of get_active_stripe(). Since we have several hash
    locks, lock contention is relieved significantly.
    
    The first path of get_active_stripe() accesses other fields, since they are
    changed rarely, changing them now need take conf->device_lock and all hash
    locks. For a slow path, this isn't a problem.
    
    If we need lock device_lock and hash lock, we always lock hash lock first. The
    tricky part is release_stripe and friends. We need take device_lock first.
    Neil's suggestion is we put inactive stripes to a temporary list and readd it
    to inactive_list after device_lock is released. In this way, we add stripes to
    temporary list with device_lock hold and remove stripes from the list with hash
    lock hold. So we don't allow concurrent access to the temporary list, which
    means we need allocate temporary list for all participants of release_stripe.
    
    One downside is free stripes are maintained in their inactive list, they can't
    across between the lists. By default, we have total 256 stripes and 8 lists, so
    each list will have 32 stripes. It's possible one list has free stripe but
    other list hasn't. The chance should be rare because stripes allocation are
    even distributed. And we can always allocate more stripes for cache, several
    mega bytes memory isn't a big deal.
    
    This completely removes the lock contention of the first path of
    get_active_stripe(). It slows down the second code path a little bit though
    because we now need takes two locks, but since the hash lock isn't contended,
    the overhead should be quite small (several atomic instructions). The second
    path of get_active_stripe() (basically sequential write or big request size
    randwrite) still has lock contentions.
    
    Signed-off-by: Shaohua Li <shli@fusionio.com>
    Signed-off-by: NeilBrown <neilb@suse.de>

:040000 040000 88fa28d1decc5454cf4d58421fa3eb12bc9ad524 5d1f104188f72b17d10cd569bf2924dab5d789cb M	drivers
bisect run success

# bad: [02ffe4cc90dce5a1bbee5daae98a40a431c29c6d] Merge 'yuanhan/slub-experimental' into devel-hourly-2013112217
# good: [5e01dc7b26d9f24f39abace5da98ccbd6a5ceb52] Linux 3.12
git bisect start '02ffe4cc90dce5a1bbee5daae98a40a431c29c6d' '5e01dc7b26d9f24f39abace5da98ccbd6a5ceb52' '--'
# good: [5cbb3d216e2041700231bcfc383ee5f8b7fc8b74] Merge branch 'akpm' (patches from Andrew Morton)
git bisect good 5cbb3d216e2041700231bcfc383ee5f8b7fc8b74
# good: [d5ceede8dc86278d16dcad8f916ef323b5672bd8] drivers/rtc/rtc-hid-sensor-time.c: use dev_get_platdata()
git bisect good d5ceede8dc86278d16dcad8f916ef323b5672bd8
# good: [ffd3c0260aeeb1fd4d36378d2e06e6410661dd0f] Merge branch 'for-linus' of git://git.kernel.org/pub/scm/linux/kernel/git/mason/linux-btrfs
git bisect good ffd3c0260aeeb1fd4d36378d2e06e6410661dd0f
# good: [1ee2dcc2245340cf4ac94b99c4d00efbeba61824] Merge git://git.kernel.org/pub/scm/linux/kernel/git/davem/net
git bisect good 1ee2dcc2245340cf4ac94b99c4d00efbeba61824
# bad: [a50f09550a7dd58b4514630fec1676855084ec1f] Merge 'vireshk/cpufreq-next' into devel-hourly-2013112217
git bisect bad a50f09550a7dd58b4514630fec1676855084ec1f
# bad: [af2e2f328052082f58f041d574ed50c7f21c598f] Merge tag 'squashfs-updates' of git://git.kernel.org/pub/scm/linux/kernel/git/pkl/squashfs-next
git bisect bad af2e2f328052082f58f041d574ed50c7f21c598f
# good: [df12a3178d340319b1955be6b973a4eb84aff754] Merge commit 'dmaengine-3.13-v2' of git://git.kernel.org/pub/scm/linux/kernel/git/djbw/dmaengine
git bisect good df12a3178d340319b1955be6b973a4eb84aff754
# good: [ed6a82546d2e8f6b5902269541733814d4adacc2] Merge branch 'acpi-hotplug'
git bisect good ed6a82546d2e8f6b5902269541733814d4adacc2
# bad: [6d6e352c80f22c446d933ca8103e02bac1f09129] Merge tag 'md/3.13' of git://neil.brown.name/md
git bisect bad 6d6e352c80f22c446d933ca8103e02bac1f09129
# bad: [30b8feb730f9b9b3c5de02580897da03f59b6b16] md/raid5: avoid deadlock when raid5 array has unack badblocks during md_stop_writes.
git bisect bad 30b8feb730f9b9b3c5de02580897da03f59b6b16
# bad: [566c09c53455d7c4f1130928ef8071da1a24ea65] raid5: relieve lock contention in get_active_stripe()
git bisect bad 566c09c53455d7c4f1130928ef8071da1a24ea65
# good: [02e5f5c0a0f726e66e3d8506ea1691e344277969] md: fix calculation of stacking limits on level change.
git bisect good 02e5f5c0a0f726e66e3d8506ea1691e344277969
# good: [82e06c811163c4d853ed335d56c3378088bc89cc] wait: add wait_event_cmd()
git bisect good 82e06c811163c4d853ed335d56c3378088bc89cc
# first bad commit: [566c09c53455d7c4f1130928ef8071da1a24ea65] raid5: relieve lock contention in get_active_stripe()

--mYCpIKhGyMATD0i+
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename=dmesg
Content-Transfer-Encoding: quoted-printable

[    0.000000] Initializing cgroup subsys cpuset
[    0.000000] Initializing cgroup subsys cpu
[    0.000000] Linux version 3.12.0-11088-gc710863 (kbuild@inn) (gcc versio=
n 4.8.1 (Debian 4.8.1-8) ) #1767 SMP Sat Nov 23 02:44:58 CST 2013
[    0.000000] Command line: user=3Dlkp job=3D/lkp/scheduled/kbuildx-6/cycl=
ic_dd-write-4hdd-4HDD-RAID5-cfq-btrfs-1dd-HEAD.yaml ARCH=3Dx86_64 BOOT_IMAG=
E=3D/kernel/x86_64-lkp/c71086341e2ea92d79f8685e461d46e7bc1d8c65/vmlinuz-3.1=
2.0-11088-gc710863 kconfig=3Dx86_64-lkp commit=3Dc71086341e2ea92d79f8685e46=
1d46e7bc1d8c65 modules_initrd=3D/kernel/x86_64-lkp/c71086341e2ea92d79f8685e=
461d46e7bc1d8c65/modules.cgz RESULT_ROOT=3D/lkp/result/kbuildx/micro/dd-wri=
te/4HDD-RAID5-cfq-btrfs-1dd/x86_64-lkp/c71086341e2ea92d79f8685e461d46e7bc1d=
8c65/1 initrd=3D/kernel-tests/initrd/lkp-rootfs.cgz root=3D/dev/ram0 ip=3D:=
:::kbuildx-6::dhcp oops=3Dpanic log_buf_len=3D8M ignore_loglevel debug sche=
d_debug apic=3Ddebug dynamic_printk sysrq_always_enabled panic=3D10 load_ra=
mdisk=3D2 prompt_ramdisk=3D0 console=3DttyS0,115200 console=3Dtty0 vga=3Dno=
rmal
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
[    0.000000] BIOS-e820: [mem 0x0000000100000000-0x000000041fffffff] usable
[    0.000000] debug: ignoring loglevel setting.
[    0.000000] NX (Execute Disable) protection: active
[    0.000000] SMBIOS 2.4 present.
[    0.000000] DMI: Bochs Bochs, BIOS Bochs 01/01/2011
[    0.000000] Hypervisor detected: KVM
[    0.000000] e820: update [mem 0x00000000-0x00000fff] usable =3D=3D> rese=
rved
[    0.000000] e820: remove [mem 0x000a0000-0x000fffff] usable
[    0.000000] No AGP bridge found
[    0.000000] e820: last_pfn =3D 0x420000 max_arch_pfn =3D 0x400000000
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
[    0.000000] BRK [0x02feb000, 0x02febfff] PGTABLE
[    0.000000] BRK [0x02fec000, 0x02fecfff] PGTABLE
[    0.000000] BRK [0x02fed000, 0x02fedfff] PGTABLE
[    0.000000] init_memory_mapping: [mem 0x41fe00000-0x41fffffff]
[    0.000000]  [mem 0x41fe00000-0x41fffffff] page 2M
[    0.000000] BRK [0x02fee000, 0x02feefff] PGTABLE
[    0.000000] init_memory_mapping: [mem 0x41c000000-0x41fdfffff]
[    0.000000]  [mem 0x41c000000-0x41fdfffff] page 2M
[    0.000000] init_memory_mapping: [mem 0x400000000-0x41bffffff]
[    0.000000]  [mem 0x400000000-0x41bffffff] page 2M
[    0.000000] init_memory_mapping: [mem 0x00100000-0xdfffdfff]
[    0.000000]  [mem 0x00100000-0x001fffff] page 4k
[    0.000000]  [mem 0x00200000-0xdfdfffff] page 2M
[    0.000000]  [mem 0xdfe00000-0xdfffdfff] page 4k
[    0.000000] init_memory_mapping: [mem 0x100000000-0x3ffffffff]
[    0.000000]  [mem 0x100000000-0x3ffffffff] page 2M
[    0.000000] BRK [0x02fef000, 0x02feffff] PGTABLE
[    0.000000] BRK [0x02ff0000, 0x02ff0fff] PGTABLE
[    0.000000] log_buf_len: 8388608
[    0.000000] early log buf free: 1044100(99%)
[    0.000000] RAMDISK: [mem 0x74396000-0x7fffffff]
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
[    0.000000] mapped APIC to ffffffffff5f7000 (        fee00000)
[    0.000000] No NUMA configuration found
[    0.000000] Faking a node at [mem 0x0000000000000000-0x000000041fffffff]
[    0.000000] Initmem setup node 0 [mem 0x00000000-0x41fffffff]
[    0.000000]   NODE_DATA [mem 0x41f7ed000-0x41f7f1fff]
[    0.000000] kvm-clock: Using msrs 4b564d01 and 4b564d00
[    0.000000] kvm-clock: cpu 0, msr 4:1f7e9001, boot clock
[    0.000000]  [ffffea0000000000-ffffea00107fffff] PMD -> [ffff88040ee0000=
0-ffff88041edfffff] on node 0
[    0.000000] Zone ranges:
[    0.000000]   DMA      [mem 0x00001000-0x00ffffff]
[    0.000000]   DMA32    [mem 0x01000000-0xffffffff]
[    0.000000]   Normal   [mem 0x100000000-0x41fffffff]
[    0.000000] Movable zone start for each node
[    0.000000] Early memory node ranges
[    0.000000]   node   0: [mem 0x00001000-0x0009efff]
[    0.000000]   node   0: [mem 0x00100000-0xdfffdfff]
[    0.000000]   node   0: [mem 0x100000000-0x41fffffff]
[    0.000000] On node 0 totalpages: 4194204
[    0.000000]   DMA zone: 64 pages used for memmap
[    0.000000]   DMA zone: 21 pages reserved
[    0.000000]   DMA zone: 3998 pages, LIFO batch:0
[    0.000000]   DMA32 zone: 14272 pages used for memmap
[    0.000000]   DMA32 zone: 913406 pages, LIFO batch:31
[    0.000000]   Normal zone: 51200 pages used for memmap
[    0.000000]   Normal zone: 3276800 pages, LIFO batch:31
[    0.000000] ACPI: PM-Timer IO Port: 0xb008
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] mapped APIC to ffffffffff5f7000 (        fee00000)
[    0.000000] ACPI: LAPIC (acpi_id[0x00] lapic_id[0x00] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x01] lapic_id[0x01] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x02] lapic_id[0x02] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x03] lapic_id[0x03] enabled)
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
[    0.000000] smpboot: Allowing 4 CPUs, 0 hotplug CPUs
[    0.000000] mapped IOAPIC to ffffffffff5f6000 (fec00000)
[    0.000000] nr_irqs_gsi: 40
[    0.000000] PM: Registered nosave memory: [mem 0x0009f000-0x0009ffff]
[    0.000000] PM: Registered nosave memory: [mem 0x000a0000-0x000effff]
[    0.000000] PM: Registered nosave memory: [mem 0x000f0000-0x000fffff]
[    0.000000] PM: Registered nosave memory: [mem 0xdfffe000-0xdfffffff]
[    0.000000] PM: Registered nosave memory: [mem 0xe0000000-0xfeffbfff]
[    0.000000] PM: Registered nosave memory: [mem 0xfeffc000-0xfeffffff]
[    0.000000] PM: Registered nosave memory: [mem 0xff000000-0xfffbffff]
[    0.000000] PM: Registered nosave memory: [mem 0xfffc0000-0xffffffff]
[    0.000000] e820: [mem 0xe0000000-0xfeffbfff] available for PCI devices
[    0.000000] Booting paravirtualized kernel on KVM
[    0.000000] setup_percpu: NR_CPUS:256 nr_cpumask_bits:256 nr_cpu_ids:4 n=
r_node_ids:1
[    0.000000] PERCPU: Embedded 476 pages/cpu @ffff88040e600000 s1920424 r8=
192 d21080 u2097152
[    0.000000] pcpu-alloc: s1920424 r8192 d21080 u2097152 alloc=3D1*2097152
[    0.000000] pcpu-alloc: [0] 0 [0] 1 [0] 2 [0] 3=20
[    0.000000] kvm-clock: cpu 0, msr 4:1f7e9001, primary cpu clock
[    0.000000] KVM setup async PF for cpu 0
[    0.000000] kvm-stealtime: cpu 0, msr 40e60d240
[    0.000000] Built 1 zonelists in Zone order, mobility grouping on.  Tota=
l pages: 4128647
[    0.000000] Policy zone: Normal
[    0.000000] Kernel command line: user=3Dlkp job=3D/lkp/scheduled/kbuildx=
-6/cyclic_dd-write-4hdd-4HDD-RAID5-cfq-btrfs-1dd-HEAD.yaml ARCH=3Dx86_64 BO=
OT_IMAGE=3D/kernel/x86_64-lkp/c71086341e2ea92d79f8685e461d46e7bc1d8c65/vmli=
nuz-3.12.0-11088-gc710863 kconfig=3Dx86_64-lkp commit=3Dc71086341e2ea92d79f=
8685e461d46e7bc1d8c65 modules_initrd=3D/kernel/x86_64-lkp/c71086341e2ea92d7=
9f8685e461d46e7bc1d8c65/modules.cgz RESULT_ROOT=3D/lkp/result/kbuildx/micro=
/dd-write/4HDD-RAID5-cfq-btrfs-1dd/x86_64-lkp/c71086341e2ea92d79f8685e461d4=
6e7bc1d8c65/1 initrd=3D/kernel-tests/initrd/lkp-rootfs.cgz root=3D/dev/ram0=
 ip=3D::::kbuildx-6::dhcp oops=3Dpanic log_buf_len=3D8M ignore_loglevel deb=
ug sched_debug apic=3Ddebug dynamic_printk sysrq_always_enabled panic=3D10 =
load_ramdisk=3D2 prompt_ramdisk=3D0 console=3DttyS0,115200 console=3Dtty0 v=
ga=3Dnormal
[    0.000000] sysrq: sysrq always enabled.
[    0.000000] PID hash table entries: 4096 (order: 3, 32768 bytes)
[    0.000000] Checking aperture...
[    0.000000] No AGP bridge found
[    0.000000] Memory: 16205968K/16776816K available (10599K kernel code, 1=
393K rwdata, 5400K rodata, 3212K init, 9592K bss, 570848K reserved)
[    0.000000] SLUB: HWalign=3D64, Order=3D0-3, MinObjects=3D0, CPUs=3D4, N=
odes=3D1
[    0.000000] Hierarchical RCU implementation.
[    0.000000]=20
[    0.000000] NR_IRQS:16640 nr_irqs:712 16
[    0.000000] Console: colour VGA+ 80x25
[    0.000000] console [tty0] enabled
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
[    0.000000]  memory used by lock dependency info: 6335 kB
[    0.000000]  per task-struct memory footprint: 2688 bytes
[    0.000000] allocated 67108864 bytes of page_cgroup
[    0.000000] please try 'cgroup_disable=3Dmemory' option if you don't wan=
t memory cgroups
[    0.000000] hpet clockevent registered
[    0.000000] tsc: Detected 2693.602 MHz processor
[    0.008000] Calibrating delay loop (skipped) preset value.. 5387.20 Bogo=
MIPS (lpj=3D10774408)
[    0.010004] pid_max: default: 32768 minimum: 301
[    0.016290] Dentry cache hash table entries: 2097152 (order: 12, 1677721=
6 bytes)
[    0.039698] Inode-cache hash table entries: 1048576 (order: 11, 8388608 =
bytes)
[    0.052669] Mount-cache hash table entries: 256
[    0.055203] Initializing cgroup subsys memory
[    0.056020] Initializing cgroup subsys blkio
[    0.057615] Initializing cgroup subsys perf_event
[    0.060014] Initializing cgroup subsys hugetlb
[    0.061748] mce: CPU supports 10 MCE banks
[    0.063335] Last level iTLB entries: 4KB 0, 2MB 0, 4MB 0
[    0.063335] Last level dTLB entries: 4KB 0, 2MB 0, 4MB 0
[    0.063335] tlb_flushall_shift: 6
[    0.064186] Freeing SMP alternatives memory: 40K (ffffffff82681000 - fff=
fffff8268b000)
[    0.073093] ACPI: Core revision 20130927
[    0.077050] ACPI: All ACPI Tables successfully acquired
[    0.079078] ftrace: allocating 39967 entries in 157 pages
[    0.092521] Getting VERSION: 50014
[    0.096014] Getting VERSION: 50014
[    0.097195] Getting ID: 0
[    0.098227] Getting ID: ff000000
[    0.100018] Getting LVT0: 8700
[    0.101442] Getting LVT1: 8400
[    0.102843] enabled ExtINT on CPU#0
[    0.105359] ENABLING IO-APIC IRQs
[    0.106765] init IO_APIC IRQs
[    0.108009]  apic 0 pin 0 not connected
[    0.109543] IOAPIC[0]: Set routing entry (0-1 -> 0x31 -> IRQ 1 Mode:0 Ac=
tive:0 Dest:1)
[    0.112037] IOAPIC[0]: Set routing entry (0-2 -> 0x30 -> IRQ 0 Mode:0 Ac=
tive:0 Dest:1)
[    0.116036] IOAPIC[0]: Set routing entry (0-3 -> 0x33 -> IRQ 3 Mode:0 Ac=
tive:0 Dest:1)
[    0.118986] IOAPIC[0]: Set routing entry (0-4 -> 0x34 -> IRQ 4 Mode:0 Ac=
tive:0 Dest:1)
[    0.120034] IOAPIC[0]: Set routing entry (0-5 -> 0x35 -> IRQ 5 Mode:1 Ac=
tive:0 Dest:1)
[    0.124035] IOAPIC[0]: Set routing entry (0-6 -> 0x36 -> IRQ 6 Mode:0 Ac=
tive:0 Dest:1)
[    0.128034] IOAPIC[0]: Set routing entry (0-7 -> 0x37 -> IRQ 7 Mode:0 Ac=
tive:0 Dest:1)
[    0.130903] IOAPIC[0]: Set routing entry (0-8 -> 0x38 -> IRQ 8 Mode:0 Ac=
tive:0 Dest:1)
[    0.132035] IOAPIC[0]: Set routing entry (0-9 -> 0x39 -> IRQ 9 Mode:1 Ac=
tive:0 Dest:1)
[    0.136034] IOAPIC[0]: Set routing entry (0-10 -> 0x3a -> IRQ 10 Mode:1 =
Active:0 Dest:1)
[    0.138962] IOAPIC[0]: Set routing entry (0-11 -> 0x3b -> IRQ 11 Mode:1 =
Active:0 Dest:1)
[    0.140035] IOAPIC[0]: Set routing entry (0-12 -> 0x3c -> IRQ 12 Mode:0 =
Active:0 Dest:1)
[    0.144034] IOAPIC[0]: Set routing entry (0-13 -> 0x3d -> IRQ 13 Mode:0 =
Active:0 Dest:1)
[    0.148034] IOAPIC[0]: Set routing entry (0-14 -> 0x3e -> IRQ 14 Mode:0 =
Active:0 Dest:1)
[    0.150965] IOAPIC[0]: Set routing entry (0-15 -> 0x3f -> IRQ 15 Mode:0 =
Active:0 Dest:1)
[    0.152030]  apic 0 pin 16 not connected
[    0.156006]  apic 0 pin 17 not connected
[    0.157491]  apic 0 pin 18 not connected
[    0.158968]  apic 0 pin 19 not connected
[    0.160007]  apic 0 pin 20 not connected
[    0.161521]  apic 0 pin 21 not connected
[    0.164006]  apic 0 pin 22 not connected
[    0.165487]  apic 0 pin 23 not connected
[    0.167134] ..TIMER: vector=3D0x30 apic1=3D0 pin1=3D2 apic2=3D-1 pin2=3D=
-1
[    0.168006] smpboot: CPU0: Intel Common KVM processor (fam: 0f, model: 0=
6, stepping: 01)
[    0.172007] Using local APIC timer interrupts.
[    0.172007] calibrating APIC timer ...
[    0.180000] ... lapic delta =3D 6250587
[    0.180000] ... PM-Timer delta =3D 357997
[    0.180000] ... PM-Timer result ok
[    0.180000] ..... delta 6250587
[    0.180000] ..... mult: 268460667
[    0.180000] ..... calibration result: 4000375
[    0.180000] ..... CPU clock speed is 2693.3517 MHz.
[    0.180000] ..... host bus clock speed is 1000.0375 MHz.
[    0.180113] Performance Events: unsupported Netburst CPU model 6 no PMU =
driver, software events only.
[    0.187116] x86: Booting SMP configuration:
[    0.188006] .... node  #0, CPUs:      #1
[    0.008000] kvm-clock: cpu 1, msr 4:1f7e9041, secondary cpu clock
[    0.008000] masked ExtINT on CPU#1
[    0.204068] KVM setup async PF for cpu 1
 #2
[    0.206435] kvm-stealtime: cpu 1, msr 40e80d240
[    0.008000] kvm-clock: cpu 2, msr 4:1f7e9081, secondary cpu clock
[    0.008000] masked ExtINT on CPU#2
[    0.220076] KVM setup async PF for cpu 2
 #3
[    0.221768] kvm-stealtime: cpu 2, msr 40ea0d240
[    0.008000] kvm-clock: cpu 3, msr 4:1f7e90c1, secondary cpu clock
[    0.008000] masked ExtINT on CPU#3

[    0.236133] x86: Booted up 1 node, 4 CPUs
[    0.236088] KVM setup async PF for cpu 3
[    0.236088] kvm-stealtime: cpu 3, msr 40ec0d240
[    0.240007] smpboot: Total of 4 processors activated (21548.81 BogoMIPS)
[    0.246222] CPU0 attaching sched-domain:
[    0.246222]  domain 0: span 0-3 level CPU
[    0.249103]   groups: 0 1 2 3
[    0.250975] CPU1 attaching sched-domain:
[    0.252023]  domain 0: span 0-3 level CPU
[    0.253649]   groups: 1 2 3 0
[    0.256025] CPU2 attaching sched-domain:
[    0.257524]  domain 0: span 0-3 level CPU
[    0.259120]   groups: 2 3 0 1
[    0.261416] CPU3 attaching sched-domain:
[    0.262864]  domain 0: span 0-3 level CPU
[    0.264020]   groups: 3 0 1 2
[    0.266172] devtmpfs: initialized
[    0.282584] xor: measuring software checksum speed
[    0.324040]    prefetch64-sse:   111.000 MB/sec
[    0.364029]    generic_sse:   109.000 MB/sec
[    0.365606] xor: using function: prefetch64-sse (111.000 MB/sec)
[    0.367471] atomic64 test passed for x86-64 platform with CX8 and with S=
SE
[    0.368257] NET: Registered protocol family 16
[    0.372366] cpuidle: using governor ladder
[    0.373547] cpuidle: using governor menu
[    0.376617] ACPI: bus type PCI registered
[    0.378113] acpiphp: ACPI Hot Plug PCI Controller Driver version: 0.5
[    0.380211] PCI: Using configuration type 1 for base access
[    0.452310] bio: create slab <bio-0> at 0
[    0.524016] raid6: sse2x1    4654 MB/s
[    0.592016] raid6: sse2x2    6705 MB/s
[    0.660011] raid6: sse2x4    7762 MB/s
[    0.661494] raid6: using algorithm sse2x4 (7762 MB/s)
[    0.663164] raid6: using intx1 recovery algorithm
[    0.664217] ACPI: Added _OSI(Module Device)
[    0.665737] ACPI: Added _OSI(Processor Device)
[    0.668006] ACPI: Added _OSI(3.0 _SCP Extensions)
[    0.669607] ACPI: Added _OSI(Processor Aggregator Device)
[    0.679604] ACPI: Interpreter enabled
[    0.680012] ACPI Exception: AE_NOT_FOUND, While evaluating Sleep State [=
\_S1_] (20130927/hwxface-580)
[    0.684009] ACPI Exception: AE_NOT_FOUND, While evaluating Sleep State [=
\_S2_] (20130927/hwxface-580)
[    0.688076] ACPI: (supports S0 S3 S4 S5)
[    0.692006] ACPI: Using IOAPIC for interrupt routing
[    0.694030] PCI: Using host bridge windows from ACPI; if necessary, use =
"pci=3Dnocrs" and report a bug
[    0.697338] ACPI: No dock devices found.
[    0.720385] ACPI: PCI Root Bridge [PCI0] (domain 0000 [bus 00-ff])
[    0.724033] acpi PNP0A03:00: _OSC: OS supports [ASPM ClockPM Segments MS=
I]
[    0.726049] acpi PNP0A03:00: _OSC failed (AE_NOT_FOUND); disabling ASPM
[    0.728396] acpi PNP0A03:00: fail to add MMCONFIG information, can't acc=
ess extended PCI configuration space under this bridge.
[    0.732463] acpiphp: Slot [3] registered
[    0.733753] acpiphp: Slot [4] registered
[    0.736187] acpiphp: Slot [5] registered
[    0.737716] acpiphp: Slot [6] registered
[    0.737733] acpiphp: Slot [7] registered
[    0.740242] acpiphp: Slot [8] registered
[    0.741724] acpiphp: Slot [9] registered
[    0.744258] acpiphp: Slot [10] registered
[    0.745725] acpiphp: Slot [11] registered
[    0.748249] acpiphp: Slot [12] registered
[    0.749751] acpiphp: Slot [13] registered
[    0.749751] acpiphp: Slot [14] registered
[    0.752235] acpiphp: Slot [15] registered
[    0.753746] acpiphp: Slot [16] registered
[    0.756250] acpiphp: Slot [17] registered
[    0.757742] acpiphp: Slot [18] registered
[    0.760241] acpiphp: Slot [19] registered
[    0.761726] acpiphp: Slot [20] registered
[    0.764055] acpiphp: Slot [21] registered
[    0.765740] acpiphp: Slot [22] registered
[    0.765740] acpiphp: Slot [23] registered
[    0.768246] acpiphp: Slot [24] registered
[    0.769731] acpiphp: Slot [25] registered
[    0.772262] acpiphp: Slot [26] registered
[    0.773827] acpiphp: Slot [27] registered
[    0.776276] acpiphp: Slot [28] registered
[    0.777800] acpiphp: Slot [29] registered
[    0.777800] acpiphp: Slot [30] registered
[    0.780245] acpiphp: Slot [31] registered
[    0.781522] PCI host bridge to bus 0000:00
[    0.784033] pci_bus 0000:00: root bus resource [bus 00-ff]
[    0.785735] pci_bus 0000:00: root bus resource [io  0x0000-0x0cf7]
[    0.788008] pci_bus 0000:00: root bus resource [io  0x0d00-0xffff]
[    0.789930] pci_bus 0000:00: root bus resource [mem 0x000a0000-0x000bfff=
f]
[    0.792007] pci_bus 0000:00: root bus resource [mem 0xe0000000-0xfebffff=
f]
[    0.794070] pci 0000:00:00.0: [8086:1237] type 00 class 0x060000
[    0.796949] pci 0000:00:01.0: [8086:7000] type 00 class 0x060100
[    0.800306] pci 0000:00:01.1: [8086:7010] type 00 class 0x010180
[    0.805775] pci 0000:00:01.1: reg 0x20: [io  0xc1c0-0xc1cf]
[    0.809630] pci 0000:00:01.3: [8086:7113] type 00 class 0x068000
[    0.812167] pci 0000:00:01.3: quirk: [io  0xb000-0xb03f] claimed by PIIX=
4 ACPI
[    0.814892] pci 0000:00:01.3: quirk: [io  0xb100-0xb10f] claimed by PIIX=
4 SMB
[    0.816594] pci 0000:00:02.0: [1013:00b8] type 00 class 0x030000
[    0.820952] pci 0000:00:02.0: reg 0x10: [mem 0xfc000000-0xfdffffff pref]
[    0.824868] pci 0000:00:02.0: reg 0x14: [mem 0xfebf0000-0xfebf0fff]
[    0.836090] pci 0000:00:02.0: reg 0x30: [mem 0xfebe0000-0xfebeffff pref]
[    0.840117] pci 0000:00:03.0: [8086:100e] type 00 class 0x020000
[    0.843416] pci 0000:00:03.0: reg 0x10: [mem 0xfeba0000-0xfebbffff]
[    0.845333] pci 0000:00:03.0: reg 0x14: [io  0xc000-0xc03f]
[    0.854620] pci 0000:00:03.0: reg 0x30: [mem 0xfebc0000-0xfebdffff pref]
[    0.856646] pci 0000:00:04.0: [1af4:1001] type 00 class 0x010000
[    0.860693] pci 0000:00:04.0: reg 0x10: [io  0xc040-0xc07f]
[    0.864012] pci 0000:00:04.0: reg 0x14: [mem 0xfebf1000-0xfebf1fff]
[    0.873517] pci 0000:00:05.0: [1af4:1001] type 00 class 0x010000
[    0.876685] pci 0000:00:05.0: reg 0x10: [io  0xc080-0xc0bf]
[    0.880007] pci 0000:00:05.0: reg 0x14: [mem 0xfebf2000-0xfebf2fff]
[    0.888812] pci 0000:00:06.0: [1af4:1001] type 00 class 0x010000
[    0.892680] pci 0000:00:06.0: reg 0x10: [io  0xc0c0-0xc0ff]
[    0.895787] pci 0000:00:06.0: reg 0x14: [mem 0xfebf3000-0xfebf3fff]
[    0.904804] pci 0000:00:07.0: [1af4:1001] type 00 class 0x010000
[    0.908009] pci 0000:00:07.0: reg 0x10: [io  0xc100-0xc13f]
[    0.911114] pci 0000:00:07.0: reg 0x14: [mem 0xfebf4000-0xfebf4fff]
[    0.920817] pci 0000:00:08.0: [1af4:1001] type 00 class 0x010000
[    0.924008] pci 0000:00:08.0: reg 0x10: [io  0xc140-0xc17f]
[    0.927125] pci 0000:00:08.0: reg 0x14: [mem 0xfebf5000-0xfebf5fff]
[    0.936869] pci 0000:00:09.0: [1af4:1001] type 00 class 0x010000
[    0.940677] pci 0000:00:09.0: reg 0x10: [io  0xc180-0xc1bf]
[    0.943773] pci 0000:00:09.0: reg 0x14: [mem 0xfebf6000-0xfebf6fff]
[    0.952793] pci 0000:00:0a.0: [8086:25ab] type 00 class 0x088000
[    0.954655] pci 0000:00:0a.0: reg 0x10: [mem 0xfebf7000-0xfebf700f]
[    0.964209] ACPI: PCI Interrupt Link [LNKA] (IRQs 5 *10 11)
[    0.966809] ACPI: PCI Interrupt Link [LNKB] (IRQs 5 *10 11)
[    0.969321] ACPI: PCI Interrupt Link [LNKC] (IRQs 5 10 *11)
[    0.971902] ACPI: PCI Interrupt Link [LNKD] (IRQs 5 10 *11)
[    0.973529] ACPI: PCI Interrupt Link [LNKS] (IRQs *9)
[    0.977396] ACPI: Enabled 16 GPEs in block 00 to 0F
[    0.980024] ACPI: \_SB_.PCI0: notify handler is installed
[    0.981869] Found 1 acpi root devices
[    0.984464] vgaarb: device added: PCI:0000:00:02.0,decodes=3Dio+mem,owns=
=3Dio+mem,locks=3Dnone
[    0.988017] vgaarb: loaded
[    0.989317] vgaarb: bridge control possible 0000:00:02.0
[    0.992218] SCSI subsystem initialized
[    0.993716] libata version 3.00 loaded.
[    0.996217] ACPI: bus type USB registered
[    0.997652] usbcore: registered new interface driver usbfs
[    1.000245] usbcore: registered new interface driver hub
[    1.001947] usbcore: registered new device driver usb
[    1.004223] pps_core: LinuxPPS API ver. 1 registered
[    1.005669] pps_core: Software ver. 5.3.6 - Copyright 2005-2007 Rodolfo =
Giometti <giometti@linux.it>
[    1.008184] PTP clock support registered
[    1.012197] EDAC MC: Ver: 3.0.0
[    1.013996] PCI: Using ACPI for IRQ routing
[    1.016016] PCI: pci_cache_line_size set to 64 bytes
[    1.018009] e820: reserve RAM buffer [mem 0x0009fc00-0x0009ffff]
[    1.020012] e820: reserve RAM buffer [mem 0xdfffe000-0xdfffffff]
[    1.024361] HPET: 3 timers in total, 0 timers will be used for per-cpu t=
imer
[    1.026422] hpet0: at MMIO 0xfed00000, IRQs 2, 8, 0
[    1.028007] hpet0: 3 comparators, 64-bit 100.000000 MHz counter
[    1.034204] Switched to clocksource kvm-clock
[    1.116631] pnp: PnP ACPI init
[    1.118072] ACPI: bus type PNP registered
[    1.119701] IOAPIC[0]: Set routing entry (0-8 -> 0x38 -> IRQ 8 Mode:0 Ac=
tive:0 Dest:15)
[    1.122878] pnp 00:00: Plug and Play ACPI device, IDs PNP0b00 (active)
[    1.124910] IOAPIC[0]: Set routing entry (0-1 -> 0x31 -> IRQ 1 Mode:0 Ac=
tive:0 Dest:15)
[    1.127969] pnp 00:01: Plug and Play ACPI device, IDs PNP0303 (active)
[    1.129978] IOAPIC[0]: Set routing entry (0-12 -> 0x3c -> IRQ 12 Mode:0 =
Active:0 Dest:15)
[    1.133072] pnp 00:02: Plug and Play ACPI device, IDs PNP0f13 (active)
[    1.135057] IOAPIC[0]: Set routing entry (0-6 -> 0x36 -> IRQ 6 Mode:0 Ac=
tive:0 Dest:15)
[    1.137971] pnp 00:03: [dma 2]
[    1.139479] pnp 00:03: Plug and Play ACPI device, IDs PNP0700 (active)
[    1.141520] IOAPIC[0]: Set routing entry (0-7 -> 0x37 -> IRQ 7 Mode:0 Ac=
tive:0 Dest:15)
[    1.144582] pnp 00:04: Plug and Play ACPI device, IDs PNP0400 (active)
[    1.146596] IOAPIC[0]: Set routing entry (0-4 -> 0x34 -> IRQ 4 Mode:0 Ac=
tive:0 Dest:15)
[    1.149667] pnp 00:05: Plug and Play ACPI device, IDs PNP0501 (active)
[    1.152192] pnp 00:06: Plug and Play ACPI device, IDs PNP0103 (active)
[    1.154388] pnp: PnP ACPI: found 7 devices
[    1.155877] ACPI: bus type PNP unregistered
[    1.186897] pci_bus 0000:00: resource 4 [io  0x0000-0x0cf7]
[    1.188865] pci_bus 0000:00: resource 5 [io  0x0d00-0xffff]
[    1.190666] pci_bus 0000:00: resource 6 [mem 0x000a0000-0x000bffff]
[    1.192411] pci_bus 0000:00: resource 7 [mem 0xe0000000-0xfebfffff]
[    1.194428] NET: Registered protocol family 2
[    1.196756] TCP established hash table entries: 131072 (order: 8, 104857=
6 bytes)
[    1.201418] TCP bind hash table entries: 65536 (order: 10, 5242880 bytes)
[    1.210892] TCP: Hash tables configured (established 131072 bind 65536)
[    1.213081] TCP: reno registered
[    1.214815] UDP hash table entries: 8192 (order: 8, 1572864 bytes)
[    1.219215] UDP-Lite hash table entries: 8192 (order: 8, 1572864 bytes)
[    1.223621] NET: Registered protocol family 1
[    1.225657] RPC: Registered named UNIX socket transport module.
[    1.227475] RPC: Registered udp transport module.
[    1.229119] RPC: Registered tcp transport module.
[    1.230710] RPC: Registered tcp NFSv4.1 backchannel transport module.
[    1.232662] pci 0000:00:00.0: Limiting direct PCI/PCI transfers
[    1.234513] pci 0000:00:01.0: PIIX3: Enabling Passive Release
[    1.236377] pci 0000:00:01.0: Activating ISA DMA hang workarounds
[    1.238268] pci 0000:00:02.0: Boot video device
[    1.239947] PCI: CLS 0 bytes, default 64
[    1.241689] Trying to unpack rootfs image as initramfs...
[    8.411962] Freeing initrd memory: 192936K (ffff880074396000 - ffff88008=
0000000)
[    8.597674] DMA-API: preallocated 65536 debug entries
[    8.599398] DMA-API: debugging enabled by kernel config
[    8.601159] PCI-DMA: Using software bounce buffering for IO (SWIOTLB)
[    8.603102] software IO TLB [mem 0xdbffe000-0xdfffe000] (64MB) mapped at=
 [ffff8800dbffe000-ffff8800dfffdfff]
[    8.607008] kvm: no hardware support
[    8.609020] Machine check injector initialized
[    8.610931] Scanning for low memory corruption every 60 seconds
[    8.613338] camellia-x86_64: performance on this CPU would be suboptimal=
: disabling camellia-x86_64.
[    8.616425] blowfish-x86_64: performance on this CPU would be suboptimal=
: disabling blowfish-x86_64.
[    8.619645] twofish-x86_64-3way: performance on this CPU would be subopt=
imal: disabling twofish-x86_64-3way.
[    8.624401] sha1_ssse3: Neither AVX nor SSSE3 is available/usable.
[    8.626285] PCLMULQDQ-NI instructions are not detected.
[    8.627997] AVX or AES-NI instructions are not detected.
[    8.629759] AVX instructions are not detected.
[    8.631326] AVX instructions are not detected.
[    8.644469] AVX instructions are not detected.
[    8.646032] AVX instructions are not detected.
[    8.711115] HugeTLB registered 2 MB page size, pre-allocated 0 pages
[    8.734420] VFS: Disk quotas dquot_6.5.2
[    8.736319] Dquot-cache hash table entries: 512 (order 0, 4096 bytes)
[    8.744949] NFS: Registering the id_resolver key type
[    8.746711] Key type id_resolver registered
[    8.748258] Key type id_legacy registered
[    8.749735] nfs4filelayout_init: NFSv4 File Layout Driver Registering...
[    8.751756] Installing knfsd (copyright (C) 1996 okir@monad.swb.de).
[    8.755513] ROMFS MTD (C) 2007 Red Hat, Inc.
[    8.757719] fuse init (API version 7.22)
[    8.760196] SGI XFS with ACLs, security attributes, realtime, large bloc=
k/inode numbers, debug enabled
[    8.767772] bio: create slab <bio-1> at 1
[    8.771228] Btrfs loaded
[    8.772504] msgmni has been set to 32029
[    8.782435] NET: Registered protocol family 38
[    8.784063] Key type asymmetric registered
[    8.785588] Asymmetric key parser 'x509' registered
[    8.787455] Block layer SCSI generic (bsg) driver version 0.4 loaded (ma=
jor 250)
[    8.790444] io scheduler noop registered
[    8.791916] io scheduler deadline registered
[    8.793542] io scheduler cfq registered (default)
[    8.796381] pci_hotplug: PCI Hot Plug PCI Core version: 0.5
[    8.798787] pciehp: PCI Express Hot Plug Controller Driver version: 0.4
[    8.801406] input: Power Button as /devices/LNXSYSTM:00/LNXPWRBN:00/inpu=
t/input0
[    8.804316] ACPI: Power Button [PWRF]
[    8.808359] GHES: HEST is not enabled!
[    8.809813] ERST DBG: ERST support is disabled.
[    8.812832] ACPI: PCI Interrupt Link [LNKD] enabled at IRQ 11
[    8.814653] IOAPIC[0]: Set routing entry (0-11 -> 0x3b -> IRQ 11 Mode:1 =
Active:0 Dest:15)
[    8.820325] ACPI: PCI Interrupt Link [LNKA] enabled at IRQ 10
[    8.822150] IOAPIC[0]: Set routing entry (0-10 -> 0x3a -> IRQ 10 Mode:1 =
Active:0 Dest:15)
[    8.827997] ACPI: PCI Interrupt Link [LNKB] enabled at IRQ 10
[    8.833079] ACPI: PCI Interrupt Link [LNKC] enabled at IRQ 11
[    8.846319] Serial: 8250/16550 driver, 4 ports, IRQ sharing enabled
[    8.870804] 00:05: ttyS0 at I/O 0x3f8 (irq =3D 4, base_baud =3D 115200) =
is a 16550A
[    8.878070] Non-volatile memory driver v1.3
[    8.891941] brd: module loaded
[    8.899749] loop: module loaded
[    8.901437] virtio-pci 0000:00:04.0: irq 40 for MSI/MSI-X
[    8.903222] virtio-pci 0000:00:04.0: irq 41 for MSI/MSI-X
[    8.905408] blk-mq: CPU -> queue map
[    8.906817]   CPU 0 -> Queue 0
[    8.908167]   CPU 1 -> Queue 0
[    8.909474]   CPU 2 -> Queue 0
[    8.910788]   CPU 3 -> Queue 0
[    8.913621]  vda: unknown partition table
[    8.917337] virtio-pci 0000:00:05.0: irq 42 for MSI/MSI-X
[    8.919121] virtio-pci 0000:00:05.0: irq 43 for MSI/MSI-X
[    8.921199] blk-mq: CPU -> queue map
[    8.922606]   CPU 0 -> Queue 0
[    8.923914]   CPU 1 -> Queue 0
[    8.925287]   CPU 2 -> Queue 0
[    8.926597]   CPU 3 -> Queue 0
[    8.928842]  vdb: unknown partition table
[    8.932446] virtio-pci 0000:00:06.0: irq 44 for MSI/MSI-X
[    8.934229] virtio-pci 0000:00:06.0: irq 45 for MSI/MSI-X
[    8.936332] blk-mq: CPU -> queue map
[    8.937740]   CPU 0 -> Queue 0
[    8.939061]   CPU 1 -> Queue 0
[    8.940410]   CPU 2 -> Queue 0
[    8.941728]   CPU 3 -> Queue 0
[    8.944197]  vdc: unknown partition table
[    8.947750] virtio-pci 0000:00:07.0: irq 46 for MSI/MSI-X
[    8.949546] virtio-pci 0000:00:07.0: irq 47 for MSI/MSI-X
[    8.951597] blk-mq: CPU -> queue map
[    8.953074]   CPU 0 -> Queue 0
[    8.954396]   CPU 1 -> Queue 0
[    8.955717]   CPU 2 -> Queue 0
[    8.957078]   CPU 3 -> Queue 0
[    8.959543]  vdd: unknown partition table
[    8.963135] virtio-pci 0000:00:08.0: irq 48 for MSI/MSI-X
[    8.964937] virtio-pci 0000:00:08.0: irq 49 for MSI/MSI-X
[    8.966998] blk-mq: CPU -> queue map
[    8.968451]   CPU 0 -> Queue 0
[    8.969760]   CPU 1 -> Queue 0
[    8.971074]   CPU 2 -> Queue 0
[    8.972415]   CPU 3 -> Queue 0
[    8.974819]  vde: unknown partition table
[    8.978365] virtio-pci 0000:00:09.0: irq 50 for MSI/MSI-X
[    8.980191] virtio-pci 0000:00:09.0: irq 51 for MSI/MSI-X
[    8.982229] blk-mq: CPU -> queue map
[    8.983637]   CPU 0 -> Queue 0
[    8.985006]   CPU 1 -> Queue 0
[    8.986311]   CPU 2 -> Queue 0
[    8.987617]   CPU 3 -> Queue 0
[    8.990118]  vdf: unknown partition table
[    8.993863] lkdtm: No crash points registered, enable through debugfs
[    8.997551] Loading iSCSI transport class v2.0-870.
[    9.002796] Adaptec aacraid driver 1.2-0[30200]-ms
[    9.004995] aic94xx: Adaptec aic94xx SAS/SATA driver version 1.0.3 loaded
[    9.007547] qla2xxx [0000:00:00.0]-0005: : QLogic Fibre Channel HBA Driv=
er: 8.06.00.08-k.
[    9.011029] megaraid cmm: 2.20.2.7 (Release Date: Sun Jul 16 00:01:03 ES=
T 2006)
[    9.014156] megaraid: 2.20.5.1 (Release Date: Thu Nov 16 15:32:35 EST 20=
06)
[    9.016479] megasas: 06.700.06.00-rc1 Sat. Aug. 31 17:00:00 PDT 2013
[    9.018899] GDT-HA: Storage RAID Controller Driver. Version: 3.05
[    9.021065] RocketRAID 3xxx/4xxx Controller driver v1.8
[    9.033004] scsi_debug: host protection
[    9.034472] scsi0 : scsi_debug, version 1.82 [20100324], dev_size_mb=3D8=
, opts=3D0x0
[    9.038303] ata_piix 0000:00:01.1: version 2.13
[    9.038331] scsi 0:0:0:0: Direct-Access     Linux    scsi_debug       00=
04 PQ: 0 ANSI: 5
[    9.040083] sd 0:0:0:0: [sda] 16384 512-byte logical blocks: (8.38 MB/8.=
00 MiB)
[    9.044073] sd 0:0:0:0: [sda] Write Protect is off
[    9.044076] sd 0:0:0:0: [sda] Mode Sense: 73 00 10 08
[    9.049547] sd 0:0:0:0: Attached scsi generic sg0 type 0
[    9.052072] sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled,=
 supports DPO and FUA
[    9.053506] scsi1 : ata_piix
[    9.054091] scsi2 : ata_piix
[    9.054576] ata1: PATA max MWDMA2 cmd 0x1f0 ctl 0x3f6 bmdma 0xc1c0 irq 14
[    9.054577] ata2: PATA max MWDMA2 cmd 0x170 ctl 0x376 bmdma 0xc1c8 irq 15
[    9.058298] pcnet32: pcnet32.c:v1.35 21.Apr.2008 tsbogend@alpha.franken.=
de
[    9.058689] Atheros(R) L2 Ethernet Driver - version 2.2.3
[    9.058690] Copyright (c) 2007 Atheros Corporation.
[    9.059765] dmfe: Davicom DM9xxx net driver, version 1.36.4 (2002-01-17)
[    9.059976] v1.01-e (2.4 port) Sep-11-2006  Donald Becker <becker@scyld.=
com>
[    9.059976]   http://www.scyld.com/network/drivers.html
[    9.060827] uli526x: ULi M5261/M5263 net driver, version 0.9.3 (2005-7-2=
9)
[    9.061256] e100: Intel(R) PRO/100 Network Driver, 3.5.24-k2-NAPI
[    9.061257] e100: Copyright(c) 1999-2006 Intel Corporation
[    9.061480] e1000: Intel(R) PRO/1000 Network Driver - version 7.3.21-k8-=
NAPI
[    9.061481] e1000: Copyright (c) 1999-2006 Intel Corporation.
[    9.080089]  sda: unknown partition table
[    9.096149] sd 0:0:0:0: [sda] Attached SCSI disk
[    9.208631] ata2.01: NODEV after polling detection
[    9.210785] ata2.00: ATAPI: QEMU DVD-ROM, 1.6.0, max UDMA/100
[    9.213232] ata2.00: configured for MWDMA2
[    9.215857] scsi 2:0:0:0: CD-ROM            QEMU     QEMU DVD-ROM     1.=
6. PQ: 0 ANSI: 5
[    9.219945] scsi 2:0:0:0: Attached scsi generic sg1 type 5
[    9.423618] e1000 0000:00:03.0 eth0: (PCI:33MHz:32-bit) 52:54:00:12:34:56
[    9.425706] e1000 0000:00:03.0 eth0: Intel(R) PRO/1000 Network Connection
[    9.427943] e1000e: Intel(R) PRO/1000 Network Driver - 2.3.2-k
[    9.429805] e1000e: Copyright(c) 1999 - 2013 Intel Corporation.
[    9.431910] igb: Intel(R) Gigabit Ethernet Network Driver - version 5.0.=
5-k
[    9.433996] igb: Copyright (c) 2007-2013 Intel Corporation.
[    9.436023] ixgbe: Intel(R) 10 Gigabit PCI Express Network Driver - vers=
ion 3.15.1-k
[    9.438837] ixgbe: Copyright (c) 1999-2013 Intel Corporation.
[    9.440939] ixgb: Intel(R) PRO/10GbE Network Driver - version 1.0.135-k2=
-NAPI
[    9.443002] ixgb: Copyright (c) 1999-2008 Intel Corporation.
[    9.445321] sky2: driver version 1.30
[    9.449135] usbcore: registered new interface driver catc
[    9.451110] usbcore: registered new interface driver kaweth
[    9.452897] pegasus: v0.9.3 (2013/04/25), Pegasus/Pegasus II USB Etherne=
t driver
[    9.455872] usbcore: registered new interface driver pegasus
[    9.457938] usbcore: registered new interface driver rtl8150
[    9.459964] usbcore: registered new interface driver asix
[    9.462026] usbcore: registered new interface driver ax88179_178a
[    9.464372] usbcore: registered new interface driver cdc_ether
[    9.466602] usbcore: registered new interface driver r815x
[    9.468784] usbcore: registered new interface driver cdc_eem
[    9.470876] usbcore: registered new interface driver dm9601
[    9.472992] usbcore: registered new interface driver smsc75xx
[    9.475092] usbcore: registered new interface driver smsc95xx
[    9.477224] usbcore: registered new interface driver gl620a
[    9.479280] usbcore: registered new interface driver net1080
[    9.481394] usbcore: registered new interface driver plusb
[    9.483449] usbcore: registered new interface driver rndis_host
[    9.485642] usbcore: registered new interface driver cdc_subset
[    9.487780] usbcore: registered new interface driver zaurus
[    9.489899] usbcore: registered new interface driver MOSCHIP usb-etherne=
t driver
[    9.492997] usbcore: registered new interface driver int51x1
[    9.495036] usbcore: registered new interface driver ipheth
[    9.497157] usbcore: registered new interface driver sierra_net
[    9.499309] usbcore: registered new interface driver cdc_ncm
[    9.512497] Fusion MPT base driver 3.04.20
[    9.514009] Copyright (c) 1999-2008 LSI Corporation
[    9.515690] Fusion MPT SPI Host driver 3.04.20
[    9.517549] Fusion MPT FC Host driver 3.04.20
[    9.519352] Fusion MPT SAS Host driver 3.04.20
[    9.521204] Fusion MPT misc device (ioctl) driver 3.04.20
[    9.523293] mptctl: Registered with Fusion MPT base driver
[    9.525267] mptctl: /dev/mptctl @ (major,minor=3D10,220)
[    9.528380] ehci_hcd: USB 2.0 'Enhanced' Host Controller (EHCI) Driver
[    9.530767] ehci-pci: EHCI PCI platform driver
[    9.532589] ohci_hcd: USB 1.1 'Open' Host Controller (OHCI) Driver
[    9.534479] ohci-pci: OHCI PCI platform driver
[    9.536710] uhci_hcd: USB Universal Host Controller Interface driver
[    9.539574] usbcore: registered new interface driver usb-storage
[    9.541843] usbcore: registered new interface driver ums-alauda
[    9.544388] usbcore: registered new interface driver ums-datafab
[    9.546591] usbcore: registered new interface driver ums-freecom
[    9.548697] usbcore: registered new interface driver ums-isd200
[    9.550779] usbcore: registered new interface driver ums-jumpshot
[    9.552884] usbcore: registered new interface driver ums-sddr09
[    9.554937] usbcore: registered new interface driver ums-sddr55
[    9.557039] usbcore: registered new interface driver ums-usbat
[    9.559093] usbcore: registered new interface driver usbtest
[    9.561411] i8042: PNP: PS/2 Controller [PNP0303:KBD,PNP0f13:MOU] at 0x6=
0,0x64 irq 1,12
[    9.565654] serio: i8042 KBD port at 0x60,0x64 irq 1
[    9.567370] serio: i8042 AUX port at 0x60,0x64 irq 12
[    9.569816] mousedev: PS/2 mouse device common for all mice
[    9.573237] rtc_cmos 00:00: RTC can wake from S4
[    9.575256] input: AT Translated Set 2 keyboard as /devices/platform/i80=
42/serio0/input/input1
[    9.575497] rtc_cmos 00:00: rtc core: registered rtc_cmos as rtc0
[    9.575721] rtc_cmos 00:00: alarms up to one day, 114 bytes nvram, hpet =
irqs
[    9.575913] i6300esb: Intel 6300ESB WatchDog Timer Driver v0.05
[    9.576406] i6300esb: initialized (0xffffc90002966000). heartbeat=3D30 s=
ec (nowayout=3D0)
[    9.576553] iTCO_wdt: Intel TCO WatchDog Timer Driver v1.10
[    9.576699] iTCO_vendor_support: vendor-support=3D0
[    9.576726] watchdog: Software Watchdog: cannot register miscdev on mino=
r=3D130 (err=3D-16).
[    9.576727] watchdog: Software Watchdog: a legacy watchdog module is pro=
bably present.
[    9.576953] softdog: Software Watchdog Timer: 0.08 initialized. soft_nob=
oot=3D0 soft_margin=3D60 sec soft_panic=3D0 (nowayout=3D0)
[    9.576971] md: linear personality registered for level -1
[    9.576975] md: raid0 personality registered for level 0
[    9.576977] md: raid1 personality registered for level 1
[    9.576979] md: raid10 personality registered for level 10
[    9.606865] md: raid6 personality registered for level 6
[    9.608115] tsc: Refined TSC clocksource calibration: 2693.520 MHz
[    9.610549] md: raid5 personality registered for level 5
[    9.612534] md: raid4 personality registered for level 4
[    9.614345] md: multipath personality registered for level -4
[    9.616247] md: faulty personality registered for level -5
[    9.619570] device-mapper: ioctl: 4.27.0-ioctl (2013-10-30) initialised:=
 dm-devel@redhat.com
[    9.623537] device-mapper: multipath: version 1.6.0 loaded
[    9.625411] device-mapper: multipath round-robin: version 1.0.0 loaded
[    9.627715] device-mapper: cache-policy-mq: version 1.1.0 loaded
[    9.629573] device-mapper: cache cleaner: version 1.0.0 loaded
[    9.632153] dcdbas dcdbas: Dell Systems Management Base Driver (version =
5.6.0-3.2)
[    9.639694] usbcore: registered new interface driver usbhid
[    9.641481] usbhid: USB HID core driver
[    9.643176] oprofile: using NMI interrupt.
[    9.644829] TCP: bic registered
[    9.646163] Initializing XFRM netlink socket
[    9.648808] NET: Registered protocol family 10
[    9.651080] sit: IPv6 over IPv4 tunneling driver
[    9.653554] NET: Registered protocol family 17
[    9.655254] 8021q: 802.1Q VLAN Support v1.8
[    9.669025] sctp: Hash tables configured (established 52428 bind 52428)
[    9.671305] Key type dns_resolver registered
[    9.674616]=20
[    9.674616] printing PIC contents
[    9.676922] ... PIC  IMR: ffff
[    9.678225] ... PIC  IRR: 9113
[    9.679524] ... PIC  ISR: 0000
[    9.680862] ... PIC ELCR: 0c00
[    9.682206] printing local APIC contents on CPU#0/0:
[    9.683919] ... APIC ID:      00000000 (0)
[    9.685307] ... APIC VERSION: 00050014
[    9.686195] ... APIC TASKPRI: 00000000 (00)
[    9.686195] ... APIC PROCPRI: 00000000
[    9.686195] ... APIC LDR: 01000000
[    9.686195] ... APIC DFR: ffffffff
[    9.686195] ... APIC SPIV: 000001ff
[    9.686195] ... APIC ISR field:
[    9.686195] 000000000000000000000000000000000000000000000000000000000000=
0000
[    9.686195] ... APIC TMR field:
[    9.686195] 000000000200000000000000000000000000000000000000000000000000=
0000
[    9.686195] ... APIC IRR field:
[    9.686195] 000000000000000000000000000000000000000000000000000000000000=
0000
[    9.686195] ... APIC ESR: 00000000
[    9.686195] ... APIC ICR: 000008fd
[    9.686195] ... APIC ICR2: 04000000
[    9.686195] ... APIC LVTT: 000000ef
[    9.686195] ... APIC LVTPC: 00010000
[    9.686195] ... APIC LVT0: 00010700
[    9.686195] ... APIC LVT1: 00000400
[    9.686195] ... APIC LVTERR: 000000fe
[    9.686195] ... APIC TMICT: 01b6b05d
[    9.686195] ... APIC TMCCT: 0173b36e
[    9.686195] ... APIC TDCR: 00000003
[    9.686195]=20
[    9.722143] number of MP IRQ sources: 15.
[    9.723639] number of IO-APIC #0 registers: 24.
[    9.725295] testing the IO APIC.......................
[    9.727000] IO APIC #0......
[    9.728318] .... register #00: 00000000
[    9.729749] .......    : physical APIC id: 00
[    9.731283] .......    : Delivery Type: 0
[    9.732813] .......    : LTS          : 0
[    9.734283] .... register #01: 00170011
[    9.735713] .......     : max redirection entries: 17
[    9.737444] .......     : PRQ implemented: 0
[    9.738956] .......     : IO APIC version: 11
[    9.740553] .... register #02: 00000000
[    9.741985] .......     : arbitration: 00
[    9.743444] .... IRQ redirection table:
[    9.744963] 1    0    0   0   0    0    0    00
[    9.746542] 0    0    0   0   0    1    1    31
[    9.748192] 0    0    0   0   0    1    1    30
[    9.749766] 0    0    0   0   0    1    1    33
[    9.751345] 1    0    0   0   0    1    1    34
[    9.752979] 1    1    0   0   0    1    1    35
[    9.754552] 0    0    0   0   0    1    1    36
[    9.756206] 0    0    0   0   0    1    1    37
[    9.757789] 0    0    0   0   0    1    1    38
[    9.759363] 0    1    0   0   0    1    1    39
[    9.761008] 1    1    0   0   0    1    1    3A
[    9.762575] 1    1    0   0   0    1    1    3B
[    9.764212] 0    0    0   0   0    1    1    3C
[    9.765785] 0    0    0   0   0    1    1    3D
[    9.767359] 0    0    0   0   0    1    1    3E
[    9.768994] 0    0    0   0   0    1    1    3F
[    9.770562] 1    0    0   0   0    0    0    00
[    9.772198] 1    0    0   0   0    0    0    00
[    9.773767] 1    0    0   0   0    0    0    00
[    9.775351] 1    0    0   0   0    0    0    00
[    9.776993] 1    0    0   0   0    0    0    00
[    9.778560] 1    0    0   0   0    0    0    00
[    9.780285] 1    0    0   0   0    0    0    00
[    9.781847] 1    0    0   0   0    0    0    00
[    9.783422] IRQ to pin mappings:
[    9.784814] IRQ0 -> 0:2
[    9.786230] IRQ1 -> 0:1
[    9.787631] IRQ3 -> 0:3
[    9.789114] IRQ4 -> 0:4
[    9.790521] IRQ5 -> 0:5
[    9.791925] IRQ6 -> 0:6
[    9.793393] IRQ7 -> 0:7
[    9.794803] IRQ8 -> 0:8
[    9.796298] IRQ9 -> 0:9
[    9.797715] IRQ10 -> 0:10
[    9.799155] IRQ11 -> 0:11
[    9.800662] IRQ12 -> 0:12
[    9.802111] IRQ13 -> 0:13
[    9.803554] IRQ14 -> 0:14
[    9.805097] IRQ15 -> 0:15
[    9.806540] .................................... done.
[    9.809137] registered taskstats version 1
[    9.813070] rtc_cmos 00:00: setting system clock to 2013-11-23 09:24:53 =
UTC (1385198693)
[    9.815996] BIOS EDD facility v0.16 2004-Jun-25, 6 devices found
[    9.826945] IPv6: ADDRCONF(NETDEV_UP): eth0: link is not ready
[    9.828763] 8021q: adding VLAN 0 to HW filter on device eth0
[   10.259182] input: ImExPS/2 Generic Explorer Mouse as /devices/platform/=
i8042/serio1/input/input3
[   11.828601] e1000: eth0 NIC Link is Up 1000 Mbps Full Duplex, Flow Contr=
ol: RX
[   11.832060] IPv6: ADDRCONF(NETDEV_CHANGE): eth0: link becomes ready
[   11.848065] Sending DHCP requests ., OK
[   11.864063] IP-Config: Got DHCP answer from 10.0.2.2, my address is 10.0=
=2E2.15
[   11.866518] IP-Config: Complete:
[   11.867853]      device=3Deth0, hwaddr=3D52:54:00:12:34:56, ipaddr=3D10.=
0.2.15, mask=3D255.255.255.0, gw=3D10.0.2.2
[   11.871110]      host=3Dkbuildx-6, domain=3D, nis-domain=3D(none)
[   11.872907]      bootserver=3D10.0.2.2, rootserver=3D10.0.2.2, rootpath=
=3D
[   11.874138]      nameserver0=3D10.0.2.3
[   11.887809] PM: Hibernation image not present or could not be loaded.
[   11.907151] Freeing unused kernel memory: 3212K (ffffffff8235e000 - ffff=
ffff82681000)
[   11.910153] Write protecting the kernel read-only data: 18432k
[   11.920212] Freeing unused kernel memory: 1676K (ffff880001a5d000 - ffff=
880001c00000)
[   11.926389] Freeing unused kernel memory: 744K (ffff880002146000 - ffff8=
80002200000)
[   13.903232] random: vgscan urandom read with 43 bits of entropy available

=3D=3D> /lkp/run_log <=3D=3D
Kernel tests: Boot OK!
PATH=3D/sbin:/usr/sbin:/bin:/usr/bin

=3D=3D> /lkp/err_log <=3D=3D

=3D=3D> /lkp/run_log <=3D=3D
downloading latest lkp src code
Kernel tests: Boot OK 2!
/lkp/lkp/src/bin/run-lkp
LKP_SRC_DIR=3D/lkp/lkp/src
RESULT_ROOT=3D/lkp/result/kbuildx/micro/dd-write/4HDD-RAID5-cfq-btrfs-1dd/x=
86_64-lkp/c71086341e2ea92d79f8685e461d46e7bc1d8c65/1
job=3D/lkp/scheduled/kbuildx-6/cyclic_dd-write-4hdd-4HDD-RAID5-cfq-btrfs-1d=
d-HEAD.yaml
2013-11-23 09:25:14 mount -t debugfs none /sys/kernel/debug
run-job /lkp/scheduled/kbuildx-6/cyclic_dd-write-4hdd-4HDD-RAID5-cfq-btrfs-=
1dd-HEAD.yaml
run: /lkp/lkp/src/setup/disk
run: /lkp/lkp/src/setup/md
run: /lkp/lkp/src/monitors/wrapper perf-stat
run: /lkp/lkp/src/monitors/event/wait pre-test
run: /lkp/lkp/src/monitors/wrapper ftrace
2013-11-23 09:25:16 mdadm -q --create /dev/md0 --chunk=3D256 --level=3Draid=
5 --raid-devices=3D4 --force --assume-clean /dev/vdb /dev/vdc /dev/vdd /dev=
/vde
[   30.170586] md: bind<vdb>
[   30.172096] md: bind<vdc>
[   30.173871] md: bind<vdd>
[   30.175354] md: bind<vde>
[   30.179705] md/raid:md0: device vde operational as raid disk 3
[   30.181730] md/raid:md0: device vdd operational as raid disk 2
[   30.183695] md/raid:md0: device vdc operational as raid disk 1
[   30.185644] md/raid:md0: device vdb operational as raid disk 0
[   30.189581] md/raid:md0: allocated 0kB
[   30.191174] md/raid:md0: raid level 5 active with 4 out of 4 devices, al=
gorithm 2
[   30.194014] RAID conf printout:
[   30.195366]  --- level:5 rd:4 wd:4
[   30.196779]  disk 0, o:1, dev:vdb
[   30.198130]  disk 1, o:1, dev:vdc
[   30.199492]  disk 2, o:1, dev:vdd
[   30.200886]  disk 3, o:1, dev:vde
[   30.202360] md0: detected capacity change from 0 to 824230281216
[   30.208227]  md0: unknown partition table
run: /lkp/lkp/src/setup/iosched
run: /lkp/lkp/src/setup/fs
2013-11-23 09:25:16 mkfs -t btrfs /dev/md0

WARNING! - Btrfs v0.20-rc1-566-gd1570a0 IS EXPERIMENTAL
WARNING! - see http://btrfs.wiki.kernel.org before using

fs created label (null) on /dev/md0

Btrfs v0.20-rc1-566-gd1570a0
2013-11-23 09:25:16 mount -t btrfs /dev/md0 /fs/md0
[   30.523092] btrfs: device fsid fcfa8f98-5f8e-4a2b-bea4-b5254a3ec20d devi=
d 1 transid 4 /dev/md0
[   30.527531] btrfs: device fsid fcfa8f98-5f8e-4a2b-bea4-b5254a3ec20d devi=
d 1 transid 4 /dev/md0
[   30.531240] btrfs: disk space caching is enabled
[   30.537495] btrfs: creating UUID tree
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
run: /lkp/lkp/src/monitors/wrapper buddyinfo
run: /lkp/lkp/src/monitors/wrapper pagetypeinfo
run: /lkp/lkp/src/monitors/wrapper interrupts
run: /lkp/lkp/src/monitors/wrapper lock_stat
run: /lkp/lkp/src/monitors/wrapper softirqs
run: /lkp/lkp/src/monitors/wrapper bdi_dev_mapping
run: /usr/bin/time -v -o /tmp/time /lkp/lkp/src/tests/micro/wrapper dd
[   37.880644] random: nonblocking pool is initialized
[   82.440547] BUG: spinlock lockup suspected on CPU#0, btrfs-submit-1/2938
[   82.440547]  lock: 0xffff88007f0aed20, .magic: dead4ead, .owner: md0_rai=
d5/2906, .owner_cpu: 2
[   82.440547] CPU: 0 PID: 2938 Comm: btrfs-submit-1 Not tainted 3.12.0-110=
88-gc710863 #1767
[   82.440547] Hardware name: Bochs Bochs, BIOS Bochs 01/01/2011
[   82.440547]  0000000000000001 ffff8803cd1e3a10 ffffffff81a415f8 ffff8804=
081e8000
[   82.440547]  ffff8803cd1e3a30 ffffffff81a3a102 ffff88007f0aed20 00000000=
a08d1ad0
[   82.440547]  ffff8803cd1e3a58 ffffffff811055d4 ffff88007f0aed38 ffff8800=
7f0aed20
[   82.440547] Call Trace:
[   82.440547]  [<ffffffff81a415f8>] dump_stack+0x4d/0x66
[   82.440547]  [<ffffffff81a3a102>] spin_dump+0x91/0x96
[   82.440547]  [<ffffffff811055d4>] do_raw_spin_lock+0xc9/0x10e
[   82.440547]  [<ffffffff81a4c7b3>] _raw_spin_lock+0x5b/0x6d
[   82.440547]  [<ffffffff8189569b>] ? get_active_stripe+0x605/0x6a9
[   82.440547]  [<ffffffff8189569b>] get_active_stripe+0x605/0x6a9
[   82.440547]  [<ffffffff810fc068>] ? prepare_to_wait+0x6f/0x77
[   82.440547]  [<ffffffff81898fd9>] make_request+0x69a/0xac5
[   82.440547]  [<ffffffff818b58d1>] ? md_make_request+0x18b/0x2ce
[   82.440547]  [<ffffffff810fc321>] ? __wake_up_sync+0x12/0x12
[   82.440547]  [<ffffffff818b58d1>] md_make_request+0x18b/0x2ce
[   82.440547]  [<ffffffff818b57ae>] ? md_make_request+0x68/0x2ce
[   82.440547]  [<ffffffff818906e5>] ? raid5_unplug+0x111/0x120
[   82.440547]  [<ffffffff814e68bf>] generic_make_request+0x9f/0xe0
[   82.440547]  [<ffffffff814e69ea>] submit_bio+0xea/0x12a
[   82.440547]  [<ffffffff8145a449>] run_scheduled_bios+0x26c/0x455
[   82.440547]  [<ffffffff8145a647>] pending_bios_fn+0x15/0x17
[   82.440547]  [<ffffffff81461925>] worker_loop+0x15c/0x4ee
[   82.440547]  [<ffffffff814617c9>] ? btrfs_queue_worker+0x280/0x280
[   82.440547]  [<ffffffff810e328d>] kthread+0xf9/0x101
[   82.440547]  [<ffffffff810f21ae>] ? local_clock+0x41/0x5a
[   82.440547]  [<ffffffff810e3194>] ? kthread_create_on_node+0x1a4/0x1a4
[   82.440547]  [<ffffffff81a5487c>] ret_from_fork+0x7c/0xb0
[   82.440547]  [<ffffffff810e3194>] ? kthread_create_on_node+0x1a4/0x1a4
[   82.440547] sending NMI to all CPUs:
[   82.440547] NMI backtrace for cpu 0
[   82.440547] CPU: 0 PID: 2938 Comm: btrfs-submit-1 Not tainted 3.12.0-110=
88-gc710863 #1767
[   82.440547] Hardware name: Bochs Bochs, BIOS Bochs 01/01/2011
[   82.440547] task: ffff8803cf6cc7a0 ti: ffff8803cd1e2000 task.ti: ffff880=
3cd1e2000
[   82.440547] RIP: 0010:[<ffffffff810620e1>]  [<ffffffff810620e1>] flat_se=
nd_IPI_mask+0x7e/0xac
[   82.440547] RSP: 0018:ffff8803cd1e39e8  EFLAGS: 00010046
[   82.440547] RAX: 0000000000000c00 RBX: 0000000000000046 RCX: 00000000000=
00007
[   82.440547] RDX: ffffffff82225a40 RSI: 0000000000000002 RDI: 00000000000=
00300
[   82.440547] RBP: ffff8803cd1e3a08 R08: 0000000000000001 R09: 00000000000=
00000
[   82.440547] R10: 0000000000007940 R11: ffffffff810ffa28 R12: 00000000000=
00002
[   82.440547] R13: 0000000000000c00 R14: 000000000000000f R15: ffff8803ce2=
fbb60
[   82.440547] FS:  0000000000000000(0000) GS:ffff88040e600000(0000) knlGS:=
0000000000000000
[   82.440547] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[   82.440547] CR2: 0000000000656057 CR3: 000000007ece2000 CR4: 00000000000=
006f0
[   82.440547] Stack:
[   82.440547]  0000000000002710 00000000a08d1ad0 00000000a08d1ad0 ffff8800=
7f0aec18
[   82.440547]  ffff8803cd1e3a18 ffffffff81062388 ffff8803cd1e3a30 ffffffff=
8105f631
[   82.440547]  ffff88007f0aed20 ffff8803cd1e3a58 ffffffff811055d9 ffff8800=
7f0aed38
[   82.440547] Call Trace:
[   82.440547]  [<ffffffff81062388>] flat_send_IPI_all+0x1f/0x4a
[   82.440547]  [<ffffffff8105f631>] arch_trigger_all_cpu_backtrace+0x52/0x=
84
[   82.440547]  [<ffffffff811055d9>] do_raw_spin_lock+0xce/0x10e
[   82.440547]  [<ffffffff81a4c7b3>] _raw_spin_lock+0x5b/0x6d
[   82.440547]  [<ffffffff8189569b>] ? get_active_stripe+0x605/0x6a9
[   82.440547]  [<ffffffff8189569b>] get_active_stripe+0x605/0x6a9
[   82.440547]  [<ffffffff810fc068>] ? prepare_to_wait+0x6f/0x77
[   82.440547]  [<ffffffff81898fd9>] make_request+0x69a/0xac5
[   82.440547]  [<ffffffff818b58d1>] ? md_make_request+0x18b/0x2ce
[   82.440547]  [<ffffffff810fc321>] ? __wake_up_sync+0x12/0x12
[   82.440547]  [<ffffffff818b58d1>] md_make_request+0x18b/0x2ce
[   82.440547]  [<ffffffff818b57ae>] ? md_make_request+0x68/0x2ce
[   82.440547]  [<ffffffff818906e5>] ? raid5_unplug+0x111/0x120
[   82.440547]  [<ffffffff814e68bf>] generic_make_request+0x9f/0xe0
[   82.440547]  [<ffffffff814e69ea>] submit_bio+0xea/0x12a
[   82.440547]  [<ffffffff8145a449>] run_scheduled_bios+0x26c/0x455
[   82.440547]  [<ffffffff8145a647>] pending_bios_fn+0x15/0x17
[   82.440547]  [<ffffffff81461925>] worker_loop+0x15c/0x4ee
[   82.440547]  [<ffffffff814617c9>] ? btrfs_queue_worker+0x280/0x280
[   82.440547]  [<ffffffff810e328d>] kthread+0xf9/0x101
[   82.440547]  [<ffffffff810f21ae>] ? local_clock+0x41/0x5a
[   82.440547]  [<ffffffff810e3194>] ? kthread_create_on_node+0x1a4/0x1a4
[   82.440547]  [<ffffffff81a5487c>] ret_from_fork+0x7c/0xb0
[   82.440547]  [<ffffffff810e3194>] ? kthread_create_on_node+0x1a4/0x1a4
[   82.440547] Code: eb f0 44 89 f0 c1 e0 18 89 04 25 10 73 5f ff 44 89 e0 =
44 09 e8 41 81 cd 00 04 00 00 41 83 fc 02 41 0f 44 c5 89 04 25 00 73 5f ff =
<f6> c7 02 75 11 48 89 df 57 9d 0f 1f 44 00 00 e8 ee 06 0f 00 eb=20
[   82.440547] INFO: NMI handler (arch_trigger_all_cpu_backtrace_handler) t=
ook too long to run: 99.631 msecs
[  179.676012] NMI backtrace for cpu 3
[  179.676012] CPU: 3 PID: 3061 Comm: meminfo Not tainted 3.12.0-11088-gc71=
0863 #1767
[  179.676012] Hardware name: Bochs Bochs, BIOS Bochs 01/01/2011
[  179.676012] task: ffff88007ed747a0 ti: ffff8803cced6000 task.ti: ffff880=
3cced6000
[  179.676012] RIP: 0010:[<ffffffff81126ff9>]  [<ffffffff81126ff9>] csd_loc=
k_wait.isra.3+0x10/0x14
[  179.676012] RSP: 0018:ffff8803cced7c40  EFLAGS: 00000202
[  179.676012] RAX: 00000000000008fb RBX: ffff88040ebd4b40 RCX: 00000012838=
fdc78
[  179.676012] RDX: ffffffff82225a40 RSI: 00000000000000fb RDI: ffff8803cce=
d7cb0
[  179.676012] RBP: ffff8803cced7c40 R08: 00000000be147e16 R09: 00000000000=
00000
[  179.676012] R10: ffffffff810c3336 R11: ffffffff81127040 R12: ffff8803cce=
d7c90
[  179.676012] R13: 0000000000000001 R14: 0000000000000002 R15: ffff88040eb=
d4b50
[  179.676012] FS:  00007eff5fadf700(0000) GS:ffff88040ec00000(0000) knlGS:=
0000000000000000
[  179.676012] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[  179.676012] CR2: 00000000006fd3d0 CR3: 000000007f17e000 CR4: 00000000000=
006e0
[  179.676012] Stack:
[  179.676012]  ffff8803cced7c80 ffffffff81127084 ffff88040ebd4b40 ffff8803=
cced7c90
[  179.676012]  0000000000000002 ffffffff8106e290 ffff8803cced7d60 00000000=
00000001
[  179.676012]  ffff8803cced7cf0 ffffffff811271c1 ffff88040ebd4b40 ffff8804=
0ebd4b40
[  179.676012] Call Trace:
[  179.676012]  [<ffffffff81127084>] generic_exec_single+0x87/0x93
[  179.676012]  [<ffffffff8106e290>] ? leave_mm+0x68/0x68
[  179.676012]  [<ffffffff811271c1>] smp_call_function_single+0x131/0x14f
[  179.676012]  [<ffffffff8106e290>] ? leave_mm+0x68/0x68
[  179.676012]  [<ffffffff81066a05>] ? kvm_clock_read+0x27/0x31
[  179.676012]  [<ffffffff811273a0>] smp_call_function_many+0xfc/0x24f
[  179.676012]  [<ffffffff8106e290>] ? leave_mm+0x68/0x68
[  179.676012]  [<ffffffff8106e39f>] native_flush_tlb_others+0x37/0x39
[  179.676012]  [<ffffffff8106e5f8>] flush_tlb_mm_range+0x1e3/0x1f6
[  179.676012]  [<ffffffff810c34d2>] dup_mm+0x36c/0x46d
[  179.676012]  [<ffffffff810c40df>] copy_process.part.31+0xae1/0x124b
[  179.676012]  [<ffffffff810c49e9>] do_fork+0xbd/0x2c3
[  179.676012]  [<ffffffff810d4e10>] ? __set_current_blocked+0x49/0x4e
[  179.676012]  [<ffffffff81a4cba4>] ? _raw_spin_unlock_irq+0x2c/0x3e
[  179.676012]  [<ffffffff810c4c69>] SyS_clone+0x16/0x18
[  179.676012]  [<ffffffff81a54c89>] stub_clone+0x69/0x90
[  179.676012]  [<ffffffff81a54929>] ? system_call_fastpath+0x16/0x1b
[  179.676012] Code: db 81 e3 0c 80 00 00 ff c3 eb 09 49 8b 3c 24 e8 ef 55 =
06 00 89 d8 5b 41 5c 5d c3 0f 1f 44 00 00 55 48 89 e5 f6 07 01 74 04 f3 90 =
<eb> f7 5d c3 0f 1f 44 00 00 55 48 63 c7 48 89 e5 41 57 41 56 41=20
[  179.676012] INFO: NMI handler (arch_trigger_all_cpu_backtrace_handler) t=
ook too long to run: 99.771 msecs
[   78.658626] NMI backtrace for cpu 2
[   78.658626] CPU: 2 PID: 2906 Comm: md0_raid5 Not tainted 3.12.0-11088-gc=
710863 #1767
[   78.658626] Hardware name: Bochs Bochs, BIOS Bochs 01/01/2011
[   78.658626] task: ffff8804081e8000 ti: ffff8803cd1e6000 task.ti: ffff880=
3cd1e6000
[   78.658626] RIP: 0010:[<ffffffff81067501>]  [<ffffffff81067501>] pvclock=
_clocksource_read+0x10/0xa7
[   78.658626] RSP: 0018:ffff8803cd1e7b90  EFLAGS: 00000082
[   78.658626] RAX: 0000000000000002 RBX: ffff88040ebd4ac0 RCX: ffff8803cfb=
a57d8
[   78.658626] RDX: 0000000000000001 RSI: 0000000000000004 RDI: ffff88041f7=
e9080
[   78.658626] RBP: ffff8803cd1e7ba8 R08: 0000000000000000 R09: ffff8803cfb=
a57d8
[   78.658626] R10: 0000000000000008 R11: ffffffff810fbf46 R12: 00000000000=
00000
[   78.658626] R13: 0000000000000002 R14: ffff8803cfba57a8 R15: 00000000000=
00046
[   78.658626] FS:  0000000000000000(0000) GS:ffff88040ea00000(0000) knlGS:=
0000000000000000
[   78.658626] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[   78.658626] CR2: 00000000006f86e4 CR3: 000000007f17e000 CR4: 00000000000=
006e0
[   78.658626] Stack:
[   78.658626]  ffff8803cfba57d8 ffff88040ebd4ac0 0000000000000000 ffff8803=
cd1e7bb8
[   78.658626]  ffffffff81066a05 ffff8803cd1e7bc8 ffffffff8103f9ce ffff8803=
cd1e7be8
[   78.658626]  ffffffff810f1f6d ffff88040ebd4ac0 00000000001d4ac0 ffff8803=
cd1e7c10
[   78.658626] Call Trace:
[   78.658626]  [<ffffffff81066a05>] kvm_clock_read+0x27/0x31
[   78.658626]  [<ffffffff8103f9ce>] sched_clock+0x9/0xd
[   78.658626]  [<ffffffff810f1f6d>] sched_clock_local+0x12/0x72
[   78.658626]  [<ffffffff810f20f5>] sched_clock_cpu+0xc1/0xcc
[   78.658626]  [<ffffffff810f2197>] local_clock+0x2a/0x5a
[   78.658626]  [<ffffffff81101202>] lock_release_holdtime.part.7+0xf/0xd9
[   78.658626]  [<ffffffff810fbf68>] ? __wake_up+0x44/0x4c
[   78.658626]  [<ffffffff811037b0>] lock_release+0x185/0x1ed
[   78.658626]  [<ffffffff81a4cb3e>] _raw_spin_unlock_irqrestore+0x24/0x5e
[   78.658626]  [<ffffffff810fbf68>] __wake_up+0x44/0x4c
[   78.658626]  [<ffffffff818b86f8>] md_wakeup_thread+0x55/0x58
[   78.658626]  [<ffffffff8188e8eb>] raid5_wakeup_stripe_thread+0xab/0x169
[   78.658626]  [<ffffffff81897eba>] raid5d+0x1ac/0x4a8
[   78.658626]  [<ffffffff811012bf>] ? lock_release_holdtime.part.7+0xcc/0x=
d9
[   78.658626]  [<ffffffff818b8c9c>] md_thread+0x10f/0x125
[   78.658626]  [<ffffffff810fc321>] ? __wake_up_sync+0x12/0x12
[   78.658626]  [<ffffffff818b8b8d>] ? md_register_thread+0xd5/0xd5
[   78.658626]  [<ffffffff810e328d>] kthread+0xf9/0x101
[   78.658626]  [<ffffffff810f21ae>] ? local_clock+0x41/0x5a
[   78.658626]  [<ffffffff810e3194>] ? kthread_create_on_node+0x1a4/0x1a4
[   78.658626]  [<ffffffff81a5487c>] ret_from_fork+0x7c/0xb0
[   78.658626]  [<ffffffff810e3194>] ? kthread_create_on_node+0x1a4/0x1a4
[   78.658626] Code: 47 1d 66 66 90 0f ae e8 8b 17 f6 c2 01 75 e6 39 d1 75 =
e2 22 05 ad b8 2e 01 5d c3 55 48 89 e5 41 54 53 51 8b 37 66 66 90 0f ae e8 =
<0f> 31 48 c1 e2 20 89 c0 0f be 4f 1c 48 09 c2 48 2b 57 08 44 8b=20
[   78.658626] INFO: NMI handler (arch_trigger_all_cpu_backtrace_handler) t=
ook too long to run: 99.903 msecs
[  179.676026] NMI backtrace for cpu 1
[  179.676026] CPU: 1 PID: 0 Comm: swapper/1 Not tainted 3.12.0-11088-gc710=
863 #1767
[  179.676026] Hardware name: Bochs Bochs, BIOS Bochs 01/01/2011
[  179.676026] task: ffff880408590000 ti: ffff88040858a000 task.ti: ffff880=
40858a000
[  179.676026] RIP: 0010:[<ffffffff81066bfc>]  [<ffffffff81066bfc>] native_=
safe_halt+0x6/0x8
[  179.676026] RSP: 0018:ffff88040858bec0  EFLAGS: 00000246
[  179.676026] RAX: 0000000000000000 RBX: ffff88040858bfd8 RCX: 00000000be1=
47e16
[  179.676026] RDX: 0100000000000000 RSI: 0000000000000000 RDI: 00000000000=
00046
[  179.676026] RBP: ffff88040858bec0 R08: 00000000be147e16 R09: 00000000000=
00000
[  179.676026] R10: 0000001a183bf5f4 R11: 0000000225c17d03 R12: 00000000000=
00001
[  179.676026] R13: ffff88040858bfd8 R14: ffff88040858bfd8 R15: 00000000000=
00000
[  179.676026] FS:  0000000000000000(0000) GS:ffff88040e800000(0000) knlGS:=
0000000000000000
[  179.676026] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[  179.676026] CR2: 00007f59669e93c0 CR3: 00000000d853e000 CR4: 00000000000=
006e0
[  179.676026] Stack:
[  179.676026]  ffff88040858bee0 ffffffff81040571 ffff88040858bfd8 ffff8804=
0858bfd8
[  179.676026]  ffff88040858bef0 ffffffff81040c9d ffff88040858bf30 ffffffff=
8111072a
[  179.676026]  0000000000000001 0000000000000000 0000000000000000 00000000=
00000000
[  179.676026] Call Trace:
[  179.676026]  [<ffffffff81040571>] default_idle+0x38/0xc1
[  179.676026]  [<ffffffff81040c9d>] arch_cpu_idle+0x18/0x28
[  179.676026]  [<ffffffff8111072a>] cpu_startup_entry+0x131/0x222
[  179.676026]  [<ffffffff8105c6e8>] start_secondary+0x233/0x235
[  179.676026] Code: 48 89 e5 0f 09 5d c3 55 48 89 e5 9c 58 5d c3 55 48 89 =
e5 57 9d 5d c3 55 48 89 e5 fa 5d c3 55 48 89 e5 fb 5d c3 55 48 89 e5 fb f4 =
<5d> c3 55 48 89 e5 f4 5d c3 55 49 89 ca 49 89 d1 8b 07 48 89 e5=20
[  179.676026] INFO: NMI handler (arch_trigger_all_cpu_backtrace_handler) t=
ook too long to run: 99.978 msecs

Elapsed time: 215
numactl --preferred=3D1 --physcpubind=3D24-27 qemu-system-x86_64 -cpu kvm64=
 -enable-kvm -kernel /kernel/x86_64-lkp/c71086341e2ea92d79f8685e461d46e7bc1=
d8c65/vmlinuz-3.12.0-11088-gc710863 -append 'user=3Dlkp job=3D/lkp/schedule=
d/kbuildx-6/cyclic_dd-write-4hdd-4HDD-RAID5-cfq-btrfs-1dd-HEAD.yaml ARCH=3D=
x86_64 BOOT_IMAGE=3D/kernel/x86_64-lkp/c71086341e2ea92d79f8685e461d46e7bc1d=
8c65/vmlinuz-3.12.0-11088-gc710863 kconfig=3Dx86_64-lkp commit=3Dc71086341e=
2ea92d79f8685e461d46e7bc1d8c65 modules_initrd=3D/kernel/x86_64-lkp/c7108634=
1e2ea92d79f8685e461d46e7bc1d8c65/modules.cgz RESULT_ROOT=3D/lkp/result/kbui=
ldx/micro/dd-write/4HDD-RAID5-cfq-btrfs-1dd/x86_64-lkp/c71086341e2ea92d79f8=
685e461d46e7bc1d8c65/1 initrd=3D/kernel-tests/initrd/lkp-rootfs.cgz root=3D=
/dev/ram0 ip=3D::::kbuildx-6::dhcp oops=3Dpanic log_buf_len=3D8M ignore_log=
level debug sched_debug apic=3Ddebug dynamic_printk sysrq_always_enabled pa=
nic=3D10 load_ramdisk=3D2 prompt_ramdisk=3D0 console=3DttyS0,115200 console=
=3Dtty0 vga=3Dnormal'  -initrd /fs/sdg1/initrd-kbuildx-6 -m 16G -smp 4 -net=
 nic,vlan=3D1,model=3De1000 -net user,vlan=3D1 -boot order=3Dnc -no-reboot =
-watchdog i6300esb -rtc base=3Dlocaltime -drive file=3D/fs/sdg1/disk0-kbuil=
dx-6,media=3Ddisk,if=3Dvirtio -drive file=3D/fs/sdg1/disk1-kbuildx-6,media=
=3Ddisk,if=3Dvirtio -drive file=3D/fs/sdg1/disk2-kbuildx-6,media=3Ddisk,if=
=3Dvirtio -drive file=3D/fs/sdg1/disk3-kbuildx-6,media=3Ddisk,if=3Dvirtio -=
drive file=3D/fs/sdg1/disk4-kbuildx-6,media=3Ddisk,if=3Dvirtio -drive file=
=3D/fs/sdg1/disk5-kbuildx-6,media=3Ddisk,if=3Dvirtio -pidfile /dev/shm/kboo=
t/pid-kbuildx-6 -serial file:/dev/shm/kboot/serial-kbuildx-6 -daemonize -di=
splay none -monitor null=20

--mYCpIKhGyMATD0i+--
