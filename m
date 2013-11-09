Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758335Ab3KIDGq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Nov 2013 22:06:46 -0500
Received: from mga01.intel.com ([192.55.52.88]:64090 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757752Ab3KIDGk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Nov 2013 22:06:40 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.93,664,1378882800"; 
   d="log'?scan'208";a="424646619"
Date: Sat, 9 Nov 2013 11:06:36 +0800
From: Fengguang Wu <fengguang.wu@intel.com>
To: Al Viro <viro@zeniv.linux.org.uk>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [vfsmounts] WARNING: CPU: 1 PID: 479 at fs/dcache.c:385 d_lru_del()
Message-ID: <20131109030636.GA13464@localhost>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="vkogqOf2sHV7VnPd"
Content-Disposition: inline
User-Agent: Heirloom mailx 12.5 6/20/10
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--vkogqOf2sHV7VnPd
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Greetings,

I got the below dmesg and the first bad commit is

commit 84550b9356af50c7cbd6b6ce6e8fd06585eebf14
Author: Al Viro <viro@zeniv.linux.org.uk>
Date:   Sun Sep 29 22:06:07 2013 -0400

    RCU'd vfsmounts
    
    _very_ preliminary, barely tested.
    
    Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>

[    3.509455] power_supply test_battery: prop VOLTAGE_NOW=3300
Kernel tests: Boot OK!
[   70.923628] ------------[ cut here ]------------
[   70.928604] WARNING: CPU: 1 PID: 479 at fs/dcache.c:385 d_lru_del+0x15f/0x190()
[   70.933837] Modules linked in:
[   70.951217] CPU: 1 PID: 479 Comm: umount Not tainted 3.12.0-00649-g32a440b #89
[   70.956272] Hardware name: Bochs Bochs, BIOS Bochs 01/01/2011
[   70.960968]  ffffffff cca87e04 c1c05539 00000000 00000000 00000181 cca87e34 c1064306
[   70.966287]  c1ec447c 00000001 000001df c1ed6158 00000181 c11d221f c11d221f 00000001
[   70.971684]  cea83e80 00000001 cca87e44 c10643c2 00000009 00000000 cca87e58 c11d221f
[   70.977076] Call Trace:
[   70.981446]  [<c1c05539>] dump_stack+0x7d/0xb0
[   70.986142]  [<c1064306>] warn_slowpath_common+0x96/0xb0
[   70.990978]  [<c11d221f>] ? d_lru_del+0x15f/0x190
[   70.995755]  [<c11d221f>] ? d_lru_del+0x15f/0x190
[   71.000432]  [<c10643c2>] warn_slowpath_null+0x22/0x30
[   71.005244]  [<c11d221f>] d_lru_del+0x15f/0x190
[   71.009871]  [<c11d27ff>] umount_collect+0x14f/0x190
[   71.014502]  [<c1c139a2>] ? _raw_spin_lock+0x42/0xb0
[   71.019072]  [<c11d3847>] d_walk+0xc7/0x3d0
[   71.023599]  [<c11d26b0>] ? dentry_lru_del+0x70/0x70
[   71.028535]  [<c11d5d8b>] shrink_dcache_for_umount+0x8b/0x150
[   71.033510]  [<c11b4477>] generic_shutdown_super+0xc7/0x1a0
[   71.038858]  [<c11b480a>] kill_litter_super+0x3a/0x50
[   71.043563]  [<c11b4a95>] deactivate_locked_super+0x45/0x70
[   71.048629]  [<c11b5e16>] deactivate_super+0x96/0xb0
[   71.053511]  [<c11df6e6>] mntput_no_expire+0x1d6/0x200
[   71.058174]  [<c11e0d41>] SyS_umount+0x121/0x5e0
[   71.063860]  [<c11e121e>] SyS_oldumount+0x1e/0x20
[   71.068699]  [<c1c140ff>] syscall_call+0x7/0xb
[   71.073363] ---[ end trace 6b92dd3d08e2681d ]---
[   71.078672] ------------[ cut here ]------------

git bisect start 32a440b38c2b6f2f927b8e294e4877fe505f9653 5e01dc7b26d9f24f39abace5da98ccbd6a5ceb52 --
git bisect good 1e7a6935bccc8d16596b2f72d4162eadb0a5f2d0  # 10:35     17+      3  Merge 'tip/perf/core' into devel-roam-i386-201311072347
git bisect good 6f7dbe7290a3c2af9ccf75c7e219dfc1ee762b05  # 11:04     17+      0  Merge 'at91/nfe/at91-3.14-cleanup+test-new' into devel-roam-i386-201311072347
git bisect  bad 5d4c247511b3030ca14d7b2d12e2f206bbccb7d1  # 11:19      0-      4  locks: introduce new FL_DELEG lock flag
git bisect  bad 84550b9356af50c7cbd6b6ce6e8fd06585eebf14  # 11:37      0-      4  RCU'd vfsmounts
git bisect good 6339dab869e07a81abd22970696dde6febee094a  # 11:55     20+      0  do_remount(): pull touch_mnt_namespace() up
git bisect good 474279dc0f7745124fc76b474c8dc1294f8e87ce  # 12:10     20+      1  split __lookup_mnt() in two functions
git bisect good baa40671d3e3b590a33b2c0e022db61cbebf5c00  # 12:31     20+      0  autofs4: make freeing sbi rcu-delayed
git bisect good 1dcddd4abd2c6df7f28928ad5cafa4a1cd20030b  # 12:43     20+      0  ncpfs: rcu-delay unload_nls() and freeing ncp_server
git bisect good dd3e2c55a45fe75f3213b17b74f9a32380f4e84b  # 12:51     20+      0  fuse: rcu-delay freeing fuse_conn
git bisect good dd3e2c55a45fe75f3213b17b74f9a32380f4e84b  # 12:54     60+      0  fuse: rcu-delay freeing fuse_conn
git bisect  bad 32a440b38c2b6f2f927b8e294e4877fe505f9653  # 12:54      0-     19  Merge 'vfs/for-next' into devel-roam-i386-201311072347
git bisect good 6c86ae2928f9e4cbf0d5844f5fcfd549e3450b8c  # 13:28     60+      4  Merge tag 'ftrace-urgent-3.12-v2' of git://git.kernel.org/pub/scm/linux/kernel/git/rostedt/linux-trace

Thanks,
Fengguang

--vkogqOf2sHV7VnPd
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="dmesg-yocto-lkp-st01-6:20131108075910:i386-randconfig-r3-1107:3.12.0-00649-g32a440b:89"
Content-Transfer-Encoding: quoted-printable

[    0.000000] Initializing cgroup subsys cpu
[    0.000000] Linux version 3.12.0-00649-g32a440b (kbuild@roam) (gcc versi=
on 4.8.1 (Debian 4.8.1-8) ) #89 SMP Thu Nov 7 23:59:43 CST 2013
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
[    0.000000] found SMP MP-table at [mem 0x000fdac0-0x000fdacf] mapped at =
[c00fdac0]
[    0.000000]   mpc: fdad0-fdbec
[    0.000000] initial memory mapped: [mem 0x00000000-0x029fffff]
[    0.000000] Base memory trampoline at [c009b000] 9b000 size 16384
[    0.000000] init_memory_mapping: [mem 0x00000000-0x000fffff]
[    0.000000]  [mem 0x00000000-0x000fffff] page 4k
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
[    0.000000] BRK [0x024f9000, 0x024f9fff] PGTABLE
[    0.000000] log_buf_len: 8388608
[    0.000000] early log buf free: 128048(97%)
[    0.000000] RAMDISK: [mem 0x0fce4000-0x0ffeffff]
[    0.000000] ACPI: RSDP 000fd930 00014 (v00 BOCHS )
[    0.000000] ACPI: RSDT 0fffe450 00034 (v01 BOCHS  BXPCRSDT 00000001 BXPC=
 00000001)
[    0.000000] ACPI: FACP 0fffff80 00074 (v01 BOCHS  BXPCFACP 00000001 BXPC=
 00000001)
[    0.000000] ACPI: DSDT 0fffe490 011A9 (v01   BXPC   BXDSDT 00000001 INTL=
 20100528)
[    0.000000] ACPI: FACS 0fffff40 00040
[    0.000000] ACPI: SSDT 0ffff7a0 00796 (v01 BOCHS  BXPCSSDT 00000001 BXPC=
 00000001)
[    0.000000] ACPI: APIC 0ffff680 00080 (v01 BOCHS  BXPCAPIC 00000001 BXPC=
 00000001)
[    0.000000] ACPI: HPET 0ffff640 00038 (v01 BOCHS  BXPCHPET 00000001 BXPC=
 00000001)
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] mapped APIC to         ffffa000 (        fee00000)
[    0.000000] 0MB HIGHMEM available.
[    0.000000] 255MB LOWMEM available.
[    0.000000]   mapped low ram: 0 - 0fffe000
[    0.000000]   low ram: 0 - 0fffe000
[    0.000000] kvm-clock: Using msrs 4b564d01 and 4b564d00
[    0.000000] kvm-clock: cpu 0, msr 0:fffd001, boot clock
[    0.000000] BRK [0x024fa000, 0x024fafff] PGTABLE
[    0.000000] Zone ranges:
[    0.000000]   DMA      [mem 0x00001000-0x00ffffff]
[    0.000000]   Normal   [mem 0x01000000-0x0fffdfff]
[    0.000000]   HighMem  empty
[    0.000000] Movable zone start for each node
[    0.000000] Early memory node ranges
[    0.000000]   node   0: [mem 0x00001000-0x0009efff]
[    0.000000]   node   0: [mem 0x00100000-0x0fffdfff]
[    0.000000] On node 0 totalpages: 65436
[    0.000000] free_area_init_node: node 0, pgdat c20a2dc0, node_mem_map cf=
2e4020
[    0.000000]   DMA zone: 32 pages used for memmap
[    0.000000]   DMA zone: 0 pages reserved
[    0.000000]   DMA zone: 3998 pages, LIFO batch:0
[    0.000000]   Normal zone: 480 pages used for memmap
[    0.000000]   Normal zone: 61438 pages, LIFO batch:15
[    0.000000] Using APIC driver default
[    0.000000] ACPI: PM-Timer IO Port: 0xb008
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] mapped APIC to         ffffa000 (        fee00000)
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
[    0.000000] mapped IOAPIC to ffff9000 (fec00000)
[    0.000000] nr_irqs_gsi: 40
[    0.000000] e820: [mem 0x10000000-0xfeffbfff] available for PCI devices
[    0.000000] Booting paravirtualized kernel on KVM
[    0.000000] setup_percpu: NR_CPUS:8 nr_cpumask_bits:8 nr_cpu_ids:2 nr_no=
de_ids:1
[    0.000000] PERCPU: Embedded 13 pages/cpu @cf2ca000 s30720 r0 d22528 u53=
248
[    0.000000] pcpu-alloc: s30720 r0 d22528 u53248 alloc=3D13*4096
[    0.000000] pcpu-alloc: [0] 0 [0] 1=20
[    0.000000] kvm-clock: cpu 0, msr 0:fffd001, primary cpu clock
[    0.000000] KVM setup async PF for cpu 0
[    0.000000] kvm-stealtime: cpu 0, msr f2cc7c0
[    0.000000] Built 1 zonelists in Zone order, mobility grouping on.  Tota=
l pages: 64924
[    0.000000] Kernel command line: hung_task_panic=3D1 rcutree.rcu_cpu_sta=
ll_timeout=3D100 log_buf_len=3D8M ignore_loglevel debug sched_debug apic=3D=
debug dynamic_printk sysrq_always_enabled panic=3D10  prompt_ramdisk=3D0 co=
nsole=3DttyS0,115200 console=3Dtty0 vga=3Dnormal  root=3D/dev/ram0 rw link=
=3D/kernel-tests/run-queue/kvm/i386-randconfig-r3-1107/devel-roam-i386-2013=
11072347/.vmlinuz-32a440b38c2b6f2f927b8e294e4877fe505f9653-20131108000013-1=
-lkp-st01 branch=3Dlinux-devel/devel-roam-i386-201311072347 BOOT_IMAGE=3D/k=
ernel/i386-randconfig-r3-1107/32a440b38c2b6f2f927b8e294e4877fe505f9653/vmli=
nuz-3.12.0-00649-g32a440b
[    0.000000] sysrq: sysrq always enabled.
[    0.000000] PID hash table entries: 1024 (order: 0, 4096 bytes)
[    0.000000] Dentry cache hash table entries: 32768 (order: 5, 131072 byt=
es)
[    0.000000] Inode-cache hash table entries: 16384 (order: 4, 65536 bytes)
[    0.000000] Initializing CPU#0
[    0.000000] Initializing HighMem for node 0 (00000000:00000000)
[    0.000000] Memory: 226492K/261744K available (12410K kernel code, 3509K=
 rwdata, 3956K rodata, 916K init, 552K bss, 35252K reserved, 0K highmem)
[    0.000000] virtual kernel memory layout:
[    0.000000]     fixmap  : 0xfff14000 - 0xfffff000   ( 940 kB)
[    0.000000]     pkmap   : 0xffc00000 - 0xffe00000   (2048 kB)
[    0.000000]     vmalloc : 0xd07fe000 - 0xffbfe000   ( 756 MB)
[    0.000000]     lowmem  : 0xc0000000 - 0xcfffe000   ( 255 MB)
[    0.000000]       .init : 0xc236b000 - 0xc2450000   ( 916 kB)
[    0.000000]       .data : 0xc1c1ee87 - 0xc236a5c0   (7469 kB)
[    0.000000]       .text : 0xc1000000 - 0xc1c1ee87   (12411 kB)
[    0.000000] Checking if this processor honours the WP bit even in superv=
isor mode...Ok.
[    0.000000] SLUB: HWalign=3D128, Order=3D0-3, MinObjects=3D0, CPUs=3D2, =
Nodes=3D1
[    0.000000] Hierarchical RCU implementation.
[    0.000000]=20
[    0.000000]=20
[    0.000000]=20
[    0.000000]=20
[    0.000000] NR_IRQS:2304 nr_irqs:512 16
[    0.000000] CPU 0 irqstacks, hard=3Dcec08000 soft=3Dcec0a000
[    0.000000] Console: colour VGA+ 80x25
[    0.000000] console [tty0] enabled
[    0.000000] console [ttyS0] enabled
[    0.000000] hpet clockevent registered
[    0.000000] tsc: Detected 2660.102 MHz processor
[    0.006666] Calibrating delay loop (skipped) preset value.. 5322.87 Bogo=
MIPS (lpj=3D8867006)
[    0.010011] pid_max: default: 32768 minimum: 301
[    0.013430] Security Framework initialized
[    0.015811] AppArmor: AppArmor disabled by boot time parameter
[    0.016704] Mount-cache hash table entries: 512
[    0.021461] Initializing cgroup subsys devices
[    0.023348] Initializing cgroup subsys freezer
[    0.025743] Initializing cgroup subsys blkio
[    0.026677] Initializing cgroup subsys perf_event
[    0.030139] mce: CPU supports 10 MCE banks
[    0.033438] Last level iTLB entries: 4KB 0, 2MB 0, 4MB 0
[    0.033438] Last level dTLB entries: 4KB 0, 2MB 0, 4MB 0
[    0.033438] tlb_flushall_shift: 6
[    0.039070] Freeing SMP alternatives memory: 36K (c2450000 - c2459000)
[    0.047401] ACPI: Core revision 20130725
[    0.051217] ACPI: All ACPI Tables successfully acquired
[    0.053056] ftrace: allocating 32660 entries in 64 pages
[    0.066902] Getting VERSION: 50014
[    0.068125] Getting VERSION: 50014
[    0.069294] Getting ID: 0
[    0.070026] Getting ID: f000000
[    0.071195] Getting LVT0: 8700
[    0.072321] Getting LVT1: 8400
[    0.073354] Enabling APIC mode:  Flat.  Using 1 I/O APICs
[    0.075012] enabled ExtINT on CPU#0
[    0.078054] ENABLING IO-APIC IRQs
[    0.079200] init IO_APIC IRQs
[    0.080008]  apic 0 pin 0 not connected
[    0.081259] IOAPIC[0]: Set routing entry (0-1 -> 0x31 -> IRQ 1 Mode:0 Ac=
tive:0 Dest:1)
[    0.083369] IOAPIC[0]: Set routing entry (0-2 -> 0x30 -> IRQ 0 Mode:0 Ac=
tive:0 Dest:1)
[    0.085829] IOAPIC[0]: Set routing entry (0-3 -> 0x33 -> IRQ 3 Mode:0 Ac=
tive:0 Dest:1)
[    0.086702] IOAPIC[0]: Set routing entry (0-4 -> 0x34 -> IRQ 4 Mode:0 Ac=
tive:0 Dest:1)
[    0.090043] IOAPIC[0]: Set routing entry (0-5 -> 0x35 -> IRQ 5 Mode:1 Ac=
tive:0 Dest:1)
[    0.093365] IOAPIC[0]: Set routing entry (0-6 -> 0x36 -> IRQ 6 Mode:0 Ac=
tive:0 Dest:1)
[    0.096713] IOAPIC[0]: Set routing entry (0-7 -> 0x37 -> IRQ 7 Mode:0 Ac=
tive:0 Dest:1)
[    0.099154] IOAPIC[0]: Set routing entry (0-8 -> 0x38 -> IRQ 8 Mode:0 Ac=
tive:0 Dest:1)
[    0.100041] IOAPIC[0]: Set routing entry (0-9 -> 0x39 -> IRQ 9 Mode:1 Ac=
tive:0 Dest:1)
[    0.103374] IOAPIC[0]: Set routing entry (0-10 -> 0x3a -> IRQ 10 Mode:1 =
Active:0 Dest:1)
[    0.106705] IOAPIC[0]: Set routing entry (0-11 -> 0x3b -> IRQ 11 Mode:1 =
Active:0 Dest:1)
[    0.109191] IOAPIC[0]: Set routing entry (0-12 -> 0x3c -> IRQ 12 Mode:0 =
Active:0 Dest:1)
[    0.110036] IOAPIC[0]: Set routing entry (0-13 -> 0x3d -> IRQ 13 Mode:0 =
Active:0 Dest:1)
[    0.113368] IOAPIC[0]: Set routing entry (0-14 -> 0x3e -> IRQ 14 Mode:0 =
Active:0 Dest:1)
[    0.116710] IOAPIC[0]: Set routing entry (0-15 -> 0x3f -> IRQ 15 Mode:0 =
Active:0 Dest:1)
[    0.119183]  apic 0 pin 16 not connected
[    0.120005]  apic 0 pin 17 not connected
[    0.121247]  apic 0 pin 18 not connected
[    0.123339]  apic 0 pin 19 not connected
[    0.124579]  apic 0 pin 20 not connected
[    0.125827]  apic 0 pin 21 not connected
[    0.126673]  apic 0 pin 22 not connected
[    0.127930]  apic 0 pin 23 not connected
[    0.130167] ..TIMER: vector=3D0x30 apic1=3D0 pin1=3D2 apic2=3D-1 pin2=3D=
-1
[    0.131960] smpboot: CPU0: Intel Common KVM processor (fam: 0f, model: 0=
6, stepping: 01)
[    0.135039] Using local APIC timer interrupts.
[    0.135039] calibrating APIC timer ...
[    0.139999] ... lapic delta =3D 15209154
[    0.139999] ... PM-Timer delta =3D 871077
[    0.139999] APIC calibration not consistent with PM-Timer: 243ms instead=
 of 100ms
[    0.139999] APIC delta adjusted to PM-Timer: 6249938 (15209154)
[    0.139999] TSC delta adjusted to PM-Timer: 266133329 (647632440)
[    0.139999] ..... delta 6249938
[    0.139999] ..... mult: 268432819
[    0.139999] ..... calibration result: 3333300
[    0.139999] ..... CPU clock speed is 2661.1997 MHz.
[    0.139999] ..... host bus clock speed is 1000.0300 MHz.
[    0.143333] Performance Events: unsupported Netburst CPU model 6 no PMU =
driver, software events only.
[    0.144692] CPU 1 irqstacks, hard=3Dcece4000 soft=3Dcece6000
[    0.146361] smpboot: Booting Node   0, Processors  #   1 OK
[    0.003333] Initializing CPU#1
[    0.006666] kvm-clock: cpu 1, msr 0:fffd041, secondary cpu clock
[    0.006666] masked ExtINT on CPU#1
[    0.193422] Brought up 2 CPUs
[    0.194519] smpboot: Total of 2 processors activated (10644.75 BogoMIPS)
[    0.193388] KVM setup async PF for cpu 1
[    0.193388] kvm-stealtime: cpu 1, msr f2d97c0
[    0.206694] CPU0 attaching sched-domain:
[    0.208025]  domain 0: span 0-1 level CPU
[    0.210008]   groups: 0 1
[    0.211385] CPU1 attaching sched-domain:
[    0.212634]  domain 0: span 0-1 level CPU
[    0.213341]   groups: 1 0
[    0.220748] EVM: security.capability
[    0.224154] regulator-dummy: no parameters
[    0.225569] NET: Registered protocol family 16
[    0.227278] cpuidle: using governor menu
[    0.233585] ACPI: bus type PCI registered
[    0.234860] acpiphp: ACPI Hot Plug PCI Controller Driver version: 0.5
[    0.236763] PCI: Using configuration type 1 for base access
[    0.260067] bio: create slab <bio-0> at 0
[    0.263855] ACPI: Added _OSI(Module Device)
[    0.265161] ACPI: Added _OSI(Processor Device)
[    0.266670] ACPI: Added _OSI(3.0 _SCP Extensions)
[    0.268048] ACPI: Added _OSI(Processor Aggregator Device)
[    0.270986] ACPI: EC: Look up EC in DSDT
[    0.276412] ACPI: Interpreter enabled
[    0.276698] ACPI Exception: AE_NOT_FOUND, While evaluating Sleep State [=
\_S1_] (20130725/hwxface-571)
[    0.284263] ACPI Exception: AE_NOT_FOUND, While evaluating Sleep State [=
\_S2_] (20130725/hwxface-571)
[    0.290040] ACPI: (supports S0 S3 S5)
[    0.291251] ACPI: Using IOAPIC for interrupt routing
[    0.293387] PCI: Using host bridge windows from ACPI; if necessary, use =
"pci=3Dnocrs" and report a bug
[    0.306778] ACPI: PCI Root Bridge [PCI0] (domain 0000 [bus 00-ff])
[    0.308487] acpi PNP0A03:00: ACPI _OSC support notification failed, disa=
bling PCIe ASPM
[    0.310014] acpi PNP0A03:00: Unable to request _OSC control (_OSC suppor=
t mask: 0x08)
[    0.313740] acpi PNP0A03:00: fail to add MMCONFIG information, can't acc=
ess extended PCI configuration space under this bridge.
[    0.317366] acpiphp: Slot [3] registered
[    0.320102] acpiphp: Slot [4] registered
[    0.321392] acpiphp: Slot [5] registered
[    0.323375] acpiphp: Slot [6] registered
[    0.324663] acpiphp: Slot [7] registered
[    0.326708] acpiphp: Slot [8] registered
[    0.327979] acpiphp: Slot [9] registered
[    0.329245] acpiphp: Slot [10] registered
[    0.330051] acpiphp: Slot [11] registered
[    0.331331] acpiphp: Slot [12] registered
[    0.332623] acpiphp: Slot [13] registered
[    0.336722] acpiphp: Slot [14] registered
[    0.338018] acpiphp: Slot [15] registered
[    0.340066] acpiphp: Slot [16] registered
[    0.343378] acpiphp: Slot [17] registered
[    0.344673] acpiphp: Slot [18] registered
[    0.350014] acpiphp: Slot [19] registered
[    0.351299] acpiphp: Slot [20] registered
[    0.353398] acpiphp: Slot [21] registered
[    0.356724] acpiphp: Slot [22] registered
[    0.358040] acpiphp: Slot [23] registered
[    0.363374] acpiphp: Slot [24] registered
[    0.364696] acpiphp: Slot [25] registered
[    0.366724] acpiphp: Slot [26] registered
[    0.370047] acpiphp: Slot [27] registered
[    0.371366] acpiphp: Slot [28] registered
[    0.373464] acpiphp: Slot [29] registered
[    0.376721] acpiphp: Slot [30] registered
[    0.378003] acpiphp: Slot [31] registered
[    0.379261] PCI host bridge to bus 0000:00
[    0.380032] pci_bus 0000:00: root bus resource [bus 00-ff]
[    0.383340] pci_bus 0000:00: root bus resource [io  0x0000-0x0cf7]
[    0.386676] pci_bus 0000:00: root bus resource [io  0x0d00-0xffff]
[    0.388343] pci_bus 0000:00: root bus resource [mem 0x000a0000-0x000bfff=
f]
[    0.390010] pci_bus 0000:00: root bus resource [mem 0x80000000-0xfebffff=
f]
[    0.393423] pci 0000:00:00.0: [8086:1237] type 00 class 0x060000
[    0.397331] pci 0000:00:01.0: [8086:7000] type 00 class 0x060100
[    0.400733] pci 0000:00:01.1: [8086:7010] type 00 class 0x010180
[    0.408261] pci 0000:00:01.1: reg 0x20: [io  0xc1c0-0xc1cf]
[    0.411585] pci 0000:00:01.3: [8086:7113] type 00 class 0x068000
[    0.413840] pci 0000:00:01.3: quirk: [io  0xb000-0xb03f] claimed by PIIX=
4 ACPI
[    0.416689] pci 0000:00:01.3: quirk: [io  0xb100-0xb10f] claimed by PIIX=
4 SMB
[    0.418907] pci 0000:00:02.0: [1013:00b8] type 00 class 0x030000
[    0.424027] pci 0000:00:02.0: reg 0x10: [mem 0xfc000000-0xfdffffff pref]
[    0.428062] pci 0000:00:02.0: reg 0x14: [mem 0xfebf0000-0xfebf0fff]
[    0.440036] pci 0000:00:02.0: reg 0x30: [mem 0xfebe0000-0xfebeffff pref]
[    0.443830] pci 0000:00:03.0: [8086:100e] type 00 class 0x020000
[    0.447898] pci 0000:00:03.0: reg 0x10: [mem 0xfeba0000-0xfebbffff]
[    0.451104] pci 0000:00:03.0: reg 0x14: [io  0xc000-0xc03f]
[    0.461126] pci 0000:00:03.0: reg 0x30: [mem 0xfebc0000-0xfebdffff pref]
[    0.463611] pci 0000:00:04.0: [1af4:1001] type 00 class 0x010000
[    0.466479] pci 0000:00:04.0: reg 0x10: [io  0xc040-0xc07f]
[    0.470535] pci 0000:00:04.0: reg 0x14: [mem 0xfebf1000-0xfebf1fff]
[    0.477762] pci 0000:00:05.0: [1af4:1001] type 00 class 0x010000
[    0.480558] pci 0000:00:05.0: reg 0x10: [io  0xc080-0xc0bf]
[    0.486681] pci 0000:00:05.0: reg 0x14: [mem 0xfebf2000-0xfebf2fff]
[    0.493925] pci 0000:00:06.0: [1af4:1001] type 00 class 0x010000
[    0.497205] pci 0000:00:06.0: reg 0x10: [io  0xc0c0-0xc0ff]
[    0.501209] pci 0000:00:06.0: reg 0x14: [mem 0xfebf3000-0xfebf3fff]
[    0.510561] pci 0000:00:07.0: [1af4:1001] type 00 class 0x010000
[    0.513343] pci 0000:00:07.0: reg 0x10: [io  0xc100-0xc13f]
[    0.517888] pci 0000:00:07.0: reg 0x14: [mem 0xfebf4000-0xfebf4fff]
[    0.526921] pci 0000:00:08.0: [1af4:1001] type 00 class 0x010000
[    0.529745] pci 0000:00:08.0: reg 0x10: [io  0xc140-0xc17f]
[    0.531126] pci 0000:00:08.0: reg 0x14: [mem 0xfebf5000-0xfebf5fff]
[    0.536805] pci 0000:00:09.0: [1af4:1001] type 00 class 0x010000
[    0.541157] pci 0000:00:09.0: reg 0x10: [io  0xc180-0xc1bf]
[    0.544510] pci 0000:00:09.0: reg 0x14: [mem 0xfebf6000-0xfebf6fff]
[    0.550279] pci 0000:00:0a.0: [8086:25ab] type 00 class 0x088000
[    0.553940] pci 0000:00:0a.0: reg 0x10: [mem 0xfebf7000-0xfebf700f]
[    0.563872] pci_bus 0000:00: on NUMA node 0
[    0.565982] ACPI: PCI Interrupt Link [LNKA] (IRQs 5 *10 11)
[    0.568042] ACPI: PCI Interrupt Link [LNKB] (IRQs 5 *10 11)
[    0.570227] ACPI: PCI Interrupt Link [LNKC] (IRQs 5 10 *11)
[    0.574785] ACPI: PCI Interrupt Link [LNKD] (IRQs 5 10 *11)
[    0.577927] ACPI: PCI Interrupt Link [LNKS] (IRQs *9)
[    0.580816] ACPI: Enabled 16 GPEs in block 00 to 0F
[    0.582496] ACPI: \_SB_.PCI0: notify handler is installed
[    0.583416] Found 1 acpi root devices
[    0.584950] vgaarb: device added: PCI:0000:00:02.0,decodes=3Dio+mem,owns=
=3Dio+mem,locks=3Dnone
[    0.590030] vgaarb: loaded
[    0.591055] vgaarb: bridge control possible 0000:00:02.0
[    0.593673] SCSI subsystem initialized
[    0.594980] wmi: Mapper loaded
[    0.596674] PCI: Using ACPI for IRQ routing
[    0.597980] PCI: pci_cache_line_size set to 64 bytes
[    0.600012] e820: reserve RAM buffer [mem 0x0009fc00-0x0009ffff]
[    0.601675] e820: reserve RAM buffer [mem 0x0fffe000-0x0fffffff]
[    0.603554] NET: Registered protocol family 8
[    0.606686] NET: Registered protocol family 20
[    0.610508] HPET: 3 timers in total, 0 timers will be used for per-cpu t=
imer
[    0.613367] hpet0: at MMIO 0xfed00000, IRQs 2, 8, 0
[    0.616675] hpet0: 3 comparators, 64-bit 100.000000 MHz counter
[    0.630583] Switched to clocksource kvm-clock
[    0.630583] Warning: could not register all branches stats
[    0.633199] Warning: could not register annotated branches stats
[    0.640088] pnp: PnP ACPI init
[    0.641254] ACPI: bus type PNP registered
[    0.642634] IOAPIC[0]: Set routing entry (0-8 -> 0x38 -> IRQ 8 Mode:0 Ac=
tive:0 Dest:3)
[    0.645104] pnp 00:00: Plug and Play ACPI device, IDs PNP0b00 (active)
[    0.646916] IOAPIC[0]: Set routing entry (0-1 -> 0x31 -> IRQ 1 Mode:0 Ac=
tive:0 Dest:3)
[    0.667565] pnp 00:01: Plug and Play ACPI device, IDs PNP0303 (active)
[    0.669435] IOAPIC[0]: Set routing entry (0-12 -> 0x3c -> IRQ 12 Mode:0 =
Active:0 Dest:3)
[    0.671943] pnp 00:02: Plug and Play ACPI device, IDs PNP0f13 (active)
[    0.673773] IOAPIC[0]: Set routing entry (0-6 -> 0x36 -> IRQ 6 Mode:0 Ac=
tive:0 Dest:3)
[    0.694292] pnp 00:03: [dma 2]
[    0.695465] pnp 00:03: Plug and Play ACPI device, IDs PNP0700 (active)
[    0.697355] IOAPIC[0]: Set routing entry (0-7 -> 0x37 -> IRQ 7 Mode:0 Ac=
tive:0 Dest:3)
[    0.699842] pnp 00:04: Plug and Play ACPI device, IDs PNP0400 (active)
[    0.701670] IOAPIC[0]: Set routing entry (0-4 -> 0x34 -> IRQ 4 Mode:0 Ac=
tive:0 Dest:3)
[    0.717318] pnp 00:05: Plug and Play ACPI device, IDs PNP0501 (active)
[    0.719423] pnp 00:06: Plug and Play ACPI device, IDs PNP0103 (active)
[    0.721402] pnp: PnP ACPI: found 7 devices
[    0.727350] ACPI: bus type PNP unregistered
[    0.764985] pci_bus 0000:00: resource 4 [io  0x0000-0x0cf7]
[    0.779689] pci_bus 0000:00: resource 5 [io  0x0d00-0xffff]
[    0.781301] pci_bus 0000:00: resource 6 [mem 0x000a0000-0x000bffff]
[    0.783008] pci_bus 0000:00: resource 7 [mem 0x80000000-0xfebfffff]
[    0.784732] NET: Registered protocol family 1
[    0.786111] pci 0000:00:00.0: Limiting direct PCI/PCI transfers
[    0.787737] pci 0000:00:01.0: PIIX3: Enabling Passive Release
[    0.789369] pci 0000:00:01.0: Activating ISA DMA hang workarounds
[    0.791071] pci 0000:00:02.0: Boot video device
[    0.805754] PCI: CLS 0 bytes, default 64
[    0.807162] Unpacking initramfs...
[    1.037377] Freeing initrd memory: 3120K (cfce4000 - cfff0000)
[    1.065330] DMA-API: preallocated 65536 debug entries
[    1.068518] DMA-API: debugging enabled by kernel config
[    1.072770] apm: BIOS not found.
[    1.074075] microcode: CPU0 sig=3D0xf61, pf=3D0x1, revision=3D0x1
[    1.075699] microcode: CPU1 sig=3D0xf61, pf=3D0x1, revision=3D0x1
[    1.077351] microcode: Microcode Update Driver: v2.00 <tigran@aivazian.f=
snet.co.uk>, Peter Oruba
[    1.096765] PCLMULQDQ-NI instructions are not detected.
[    1.098281] NatSemi SCx200 Driver
[    1.099719] audit: initializing netlink socket (disabled)
[    1.101285] type=3D2000 audit(1383868675.708:1): initialized
[    1.171942] VFS: Disk quotas dquot_6.5.2
[    1.173391] Dquot-cache hash table entries: 1024 (order 0, 4096 bytes)
[    1.175981] squashfs: version 4.0 (2009/01/31) Phillip Lougher
[    1.177672] NTFS driver 2.1.30 [Flags: R/W DEBUG].
[    1.179302] EFS: 1.0a - http://aeschi.ch.eu.org/efs/
[    1.185514] NILFS version 2 loaded
[    1.186727] BeFS version: 0.9.3
[    1.206979] alg: No test for lz4hc (lz4hc-generic)
[    1.208544] alg: No test for stdrng (krng)
[    1.209984] NET: Registered protocol family 38
[    1.211450] Block layer SCSI generic (bsg) driver version 0.4 loaded (ma=
jor 254)
[    1.214003] io scheduler noop registered
[    1.215239] io scheduler deadline registered (default)
[    1.239516] pci_hotplug: PCI Hot Plug PCI Core version: 0.5
[    1.241174] shpchp: Standard Hot Plug PCI Controller Driver version: 0.4
[    1.243166] no IO addresses supplied
[    1.244435] hgafb: HGA card not detected.
[    1.245710] hgafb: probe of hgafb.0 failed with error -22
[    1.247383] input: Power Button as /devices/LNXSYSTM:00/LNXPWRBN:00/inpu=
t/input0
[    1.258912] ACPI: Power Button [PWRF]
[    1.263840] GHES: HEST is not enabled!
[    1.265135] HDLC line discipline maxframe=3D4096
[    1.269880] N_HDLC line discipline registered.
[    1.271254] Serial: 8250/16550 driver, 4 ports, IRQ sharing disabled
[    1.312769] 00:05: ttyS0 at I/O 0x3f8 (irq =3D 4, base_baud =3D 115200) =
is a 16550A
[    1.319127] STMicroelectronics ASC driver initialized
[    1.324043] MOXA Intellio family driver version 6.0k
[    1.325548] MOXA Smartio/Industio family driver version 2.0.5
[    1.330618] Initializing Nozomi driver 2.1d
[    1.331949] SyncLink MultiPort driver $Revision: 4.38 $
[    1.339148] SyncLink MultiPort driver $Revision: 4.38 $, tty major#251
[    1.344286] SyncLink serial driver $Revision: 4.38 $
[    1.351422] SyncLink serial driver $Revision: 4.38 $, tty major#250
[    1.356679] DoubleTalk PC - not found
[    1.357916] Applicom driver: $Id: ac.c,v 1.30 2000/03/22 16:03:57 dwmw2 =
Exp $
[    1.363188] ac.o: No PCI boards found.
[    1.364427] ac.o: For an ISA board you must supply memory and irq parame=
ters.
[    1.366284] sonypi: Sony Programmable I/O Controller Driver v1.26.
[    1.371524] Linux agpgart interface v0.103
[    1.372959] Hangcheck: starting hangcheck timer 0.9.1 (tick is 180 secon=
ds, margin is 60 seconds).
[    1.379035] Hangcheck: Using getrawmonotonic().
[    1.383972] [drm] Initialized drm 1.1.0 20060810
[    1.385494] [drm] radeon kernel modesetting enabled.
[    1.396596] [TTM] Zone  kernel: Available graphics memory: 114824 kiB
[    1.398409] [TTM] Initializing pool allocator
[    1.423405] [drm] fb mappable at 0x0
[    1.424636] [drm] vram aper at 0x0
[    1.425797] [drm] size 0
[    1.426776] [drm] fb depth is 24
[    1.427876] [drm]    pitch is 3840
[    1.429109] fbcon: cirrusdrmfb (fb0) is primary device
[    1.599873] Console: switching to colour frame buffer device 160x64
[    1.658736] cirrus 0000:00:02.0: fb0: cirrusdrmfb frame buffer device
[    1.659851] cirrus 0000:00:02.0: registered panic notifier
[    1.673848] [drm] Initialized cirrus 1.0.0 20110418 for 0000:00:02.0 on =
minor 0
[    1.675335] Phantom Linux Driver, version n0.9.8, init OK
[    1.676545] Uniform Multi-Platform E-IDE driver
[    1.677520] Loading iSCSI transport class v2.0-870.
[    1.681498] rdac: device handler registered
[    1.682412] hp_sw: device handler registered
[    1.683164] emc: device handler registered
[    1.684426] Could not find PAR responsible for SC520CDP Flash Bank #1
[    1.685591] Trying default address 0x8c00000
[    1.686352] SC520 CDP flash device: 0x800000 at 0x8800000
[    1.687280] Failed to ioremap_nocache
[    1.687965] HSI/SSI char device loaded
[    1.688621] slcan: serial line CAN interface driver
[    1.689468] slcan: 10 dynamic interface channels.
[    1.690299] CAN device driver interface
[    1.690962] sja1000 CAN netdevice driver
[    1.691634] sja1000_isa: insufficient parameters supplied
[    1.692745] I2O subsystem v1.325
[    1.693303] i2o: max drivers =3D 8
[    1.706712] I2O Block Device OSM v1.325
[    1.707802] Fusion MPT base driver 3.04.20
[    1.708514] Copyright (c) 1999-2008 LSI Corporation
[    1.709387] Fusion MPT SAS Host driver 3.04.20
[    1.710207] Fusion MPT misc device (ioctl) driver 3.04.20
[    1.711180] mptctl: Registered with Fusion MPT base driver
[    1.712121] mptctl: /dev/mptctl @ (major,minor=3D10,220)
[    1.713187] i8042: PNP: PS/2 Controller [PNP0303:KBD,PNP0f13:MOU] at 0x6=
0,0x64 irq 1,12
[    1.715533] serio: i8042 KBD port at 0x60,0x64 irq 1
[    1.716421] serio: i8042 AUX port at 0x60,0x64 irq 12
[    1.717454] mousedev: PS/2 mouse device common for all mice
[    1.718423] evbug: Connected device: input0 (Power Button at LNXPWRBN/bu=
tton/input0)
[    1.737427] isa i2c-pca-isa.0: Please specify I/O base
[    1.742394] Driver for 1-wire Dallas network protocol.
[    1.760306] 1-Wire driver for the DS2760 battery monitor  chip  - (c) 20=
04-2005, Szabolcs Gyurko
[    1.765926] power_supply test_ac: uevent
[    1.770517] power_supply test_ac: POWER_SUPPLY_NAME=3Dtest_ac
[    1.788350] power_supply test_ac: prop ONLINE=3D1
[    1.795941] power_supply test_ac: power_supply_changed
[    1.800677] power_supply test_battery: uevent
[    1.805008] power_supply test_battery: POWER_SUPPLY_NAME=3Dtest_battery
[    1.822767] power_supply test_battery: prop STATUS=3DDischarging
[    1.827502] power_supply test_battery: prop CHARGE_TYPE=3DFast
[    1.831874] power_supply test_battery: prop HEALTH=3DGood
[    1.849168] power_supply test_battery: prop PRESENT=3D1
[    1.853505] power_supply test_battery: prop TECHNOLOGY=3DLi-ion
[    1.857763] power_supply test_battery: prop CHARGE_FULL_DESIGN=3D100
[    1.879185] power_supply test_battery: prop CHARGE_FULL=3D100
[    1.883564] power_supply test_battery: prop CHARGE_NOW=3D50
[    1.887763] power_supply test_battery: prop CAPACITY=3D50
[    1.904960] power_supply test_battery: prop CAPACITY_LEVEL=3DNormal
[    1.909371] power_supply test_battery: prop TIME_TO_EMPTY_AVG=3D3600
[    1.913677] power_supply test_battery: prop TIME_TO_FULL_NOW=3D3600
[    1.930949] power_supply test_battery: prop MODEL_NAME=3DTest battery
[    1.935308] power_supply test_battery: prop MANUFACTURER=3DLinux
[    1.939510] power_supply test_battery: prop SERIAL_NUMBER=3D3.12.0-00649=
-g32a440b
[    1.956964] power_supply test_battery: prop TEMP=3D26
[    1.961074] power_supply test_battery: prop VOLTAGE_NOW=3D3300
[    1.965249] power_supply test_battery: power_supply_changed
[    1.987405] power_supply test_usb: uevent
[    1.991312] power_supply test_usb: POWER_SUPPLY_NAME=3Dtest_usb
[    1.995287] power_supply test_usb: prop ONLINE=3D1
[    2.012171] power_supply test_usb: power_supply_changed
[    2.016156] w83781d: Detection failed at step 2
[    2.020282] pc87360: PC8736x not detected, module not inserted
[    2.036606] lguest: switcher text too large (4384)
[    2.040551] cpufreq-nforce2: No nForce2 chipset.
[    2.044440] leds_ss4200: no LED devices found
[    2.058626] hidraw: raw HID events driver (C) Jiri Kosina
[    2.063972] asus_wmi: Asus Management GUID not found
[    2.085604] dell_wmi_aio: No known WMI GUID found
[    2.089852] acer_wmi: Acer Laptop ACPI-WMI Extras
[    2.093944] acer_wmi: No or unsupported WMI interface, unable to load
[    2.111435] acerhdf: Acer Aspire One Fan driver, v.0.5.26
[    2.115835] acerhdf: unknown (unsupported) BIOS version Bochs/Bochs/Boch=
s, please report, aborting!
[    2.120765] hdaps: supported laptop not found!
[    2.138169] hdaps: driver init failed (ret=3D-19)!
[    2.142408] msi_wmi: This machine doesn't have neither MSI-hotkeys nor b=
acklight through WMI
[    2.147587] NET: Registered protocol family 17
[    2.165214] Ebtables v2.0 registered
[    2.172623] NET: Registered protocol family 4
[    2.189330] NET: Registered protocol family 9
[    2.193772] X.25 for Linux Version 0.2
[    2.198057] can: controller area network core (rev 20120528 abi 9)
[    2.202660] NET: Registered protocol family 29
[    2.206727] can: raw protocol (rev 20120528)
[    2.210674] lec:lane_module_init: lec.c: initialized
[    2.214957] 9pnet: Installing 9P2000 support
[    2.219321] NET: Registered protocol family 37
[    2.224300]=20
[    2.224300] printing PIC contents
[    2.231702] ... PIC  IMR: ffff
[    2.235011] ... PIC  IRR: 1013
[    2.238846] ... PIC  ISR: 0000
[    2.242553] ... PIC ELCR: 0c00
[    2.246281] printing local APIC contents on CPU#0/0:
[    2.246782] ... APIC ID:      00000000 (0)
[    2.246782] ... APIC VERSION: 00050014
[    2.246782] ... APIC TASKPRI: 00000000 (00)
[    2.246782] ... APIC PROCPRI: 00000000
[    2.246782] ... APIC LDR: 01000000
[    2.246782] ... APIC DFR: ffffffff
[    2.246782] ... APIC SPIV: 000001ff
[    2.246782] ... APIC ISR field:
[    2.246782] 000000000000000000000000000000000000000000000000000000000000=
0000
[    2.246782] ... APIC TMR field:
[    2.246782] 000000000200000000000000000000000000000000000000000000000000=
0000
[    2.246782] ... APIC IRR field:
[    2.246782] 000000000000000000000000000000000000000000000000000000000000=
8000
[    2.246782] ... APIC ESR: 00000000
[    2.246782] ... APIC ICR: 000008fd
[    2.246782] ... APIC ICR2: 02000000
[    2.246782] ... APIC LVTT: 000200ef
[    2.246782] ... APIC LVTPC: 00010000
[    2.246782] ... APIC LVT0: 00010700
[    2.246782] ... APIC LVT1: 00000400
[    2.246782] ... APIC LVTERR: 000000fe
[    2.246782] ... APIC TMICT: 00032dcb
[    2.246782] ... APIC TMCCT: 00024012
[    2.246782] ... APIC TDCR: 00000003
[    2.246782]=20
[    2.403130] number of MP IRQ sources: 15.
[    2.406980] number of IO-APIC #0 registers: 24.
[    2.410602] testing the IO APIC.......................
[    2.414185] IO APIC #0......
[    2.417440] .... register #00: 00000000
[    2.421041] .......    : physical APIC id: 00
[    2.424751] .......    : Delivery Type: 0
[    2.428379] .......    : LTS          : 0
[    2.431918] .... register #01: 00170011
[    2.438091] .......     : max redirection entries: 17
[    2.441746] .......     : PRQ implemented: 0
[    2.445456] .......     : IO APIC version: 11
[    2.449047] .... register #02: 00000000
[    2.452386] .......     : arbitration: 00
[    2.455719] .... IRQ redirection table:
[    2.458926] 1    0    0   0   0    0    0    00
[    2.462006] 0    0    0   0   0    1    1    31
[    2.465012] 0    0    0   0   0    1    1    30
[    2.467958] 0    0    0   0   0    1    1    33
[    2.470998] 1    0    0   0   0    1    1    34
[    2.474189] 1    1    0   0   0    1    1    35
[    2.477300] 0    0    0   0   0    1    1    36
[    2.480296] 0    0    0   0   0    1    1    37
[    2.483214] 0    0    0   0   0    1    1    38
[    2.486009] 0    1    0   0   0    1    1    39
[    2.488708] 1    1    0   0   0    1    1    3A
[    2.491350] 1    1    0   0   0    1    1    3B
[    2.493951] 0    0    0   0   0    1    1    3C
[    2.496562] 0    0    0   0   0    1    1    3D
[    2.499351] 0    0    0   0   0    1    1    3E
[    2.502111] 0    0    0   0   0    1    1    3F
[    2.504859] 1    0    0   0   0    0    0    00
[    2.507624] 1    0    0   0   0    0    0    00
[    2.513609] 1    0    0   0   0    0    0    00
[    2.516110] 1    0    0   0   0    0    0    00
[    2.522118] 1    0    0   0   0    0    0    00
[    2.528136] 1    0    0   0   0    0    0    00
[    2.534110] 1    0    0   0   0    0    0    00
[    2.536588] 1    0    0   0   0    0    0    00
[    2.542324] IRQ to pin mappings:
[    2.547996] IRQ0 -> 0:2
[    2.552195] IRQ1 -> 0:1
[    2.557773] IRQ3 -> 0:3
[    2.559836] IRQ4 -> 0:4
[    2.565177] IRQ5 -> 0:5
[    2.570404] IRQ6 -> 0:6
[    2.572398] IRQ7 -> 0:7
[    2.577754] IRQ8 -> 0:8
[    2.579697] IRQ9 -> 0:9
[    2.584988] IRQ10 -> 0:10
[    2.586781] IRQ11 -> 0:11
[    2.591935] IRQ12 -> 0:12
[    2.598342] IRQ13 -> 0:13
[    2.603638] IRQ14 -> 0:14
[    2.605624] IRQ15 -> 0:15
[    2.610924] .................................... done.
[    2.613267] Using IPI No-Shortcut mode
[    2.642286] input: AT Translated Set 2 keyboard as /devices/platform/i80=
42/serio0/input/input1
[    2.645682] evbug: Connected device: input1 (AT Translated Set 2 keyboar=
d at isa0060/serio0/input0)
[    2.649339] power_supply test_ac: power_supply_changed_work
[    2.683028] power_supply test_ac: power_supply_update_gen_leds 1
[    2.686055] power_supply test_ac: uevent
[    2.687533] Key type encrypted registered
[    2.687758] IMA: No TPM chip found, activating TPM-bypass!
[    2.688432] drivers/rtc/hctosys.c: unable to open rtc device (rtc0)
[    2.707916] power_supply test_ac: POWER_SUPPLY_NAME=3Dtest_ac
[    2.710824] power_supply test_ac: prop ONLINE=3D1
[    2.726537] power_supply test_battery: power_supply_changed_work
[    2.729396] power_supply test_battery: power_supply_update_bat_leds 2
[    2.732146] power_supply test_battery: uevent
[    2.734596] power_supply test_battery: POWER_SUPPLY_NAME=3Dtest_battery
[    2.737421] power_supply test_battery: prop STATUS=3DDischarging
[    2.753421] power_supply test_battery: prop CHARGE_TYPE=3DFast
[    2.756459] power_supply test_battery: prop HEALTH=3DGood
[    2.759088] power_supply test_battery: prop PRESENT=3D1
[    2.761642] power_supply test_battery: prop TECHNOLOGY=3DLi-ion
[    2.772167] Freeing unused kernel memory: 916K (c236b000 - c2450000)
[    2.780647] power_supply test_battery: prop CHARGE_FULL_DESIGN=3D100
[    2.780652] Write protecting the kernel text: 12412k
[    2.786535] power_supply test_battery: prop CHARGE_FULL=3D100
[    2.789422] power_supply test_battery: prop CHARGE_NOW=3D50
[    2.805548] Write protecting the kernel read-only data: 3960k
[    2.805562] power_supply test_battery: prop CAPACITY=3D50
[    2.805576] power_supply test_battery: prop CAPACITY_LEVEL=3DNormal
[    2.805580] power_supply test_battery: prop TIME_TO_EMPTY_AVG=3D3600
[    2.805583] power_supply test_battery: prop TIME_TO_FULL_NOW=3D3600
[    2.805586] power_supply test_battery: prop MODEL_NAME=3DTest battery
[    2.805595] power_supply test_battery: prop MANUFACTURER=3DLinux
[    2.805598] power_supply test_battery: prop SERIAL_NUMBER=3D3.12.0-00649=
-g32a440b
[    2.805601] power_supply test_battery: prop TEMP=3D26
[    2.805604] power_supply test_battery: prop VOLTAGE_NOW=3D3300
[    2.805628] power_supply test_usb: power_supply_changed_work
[    2.805634] power_supply test_usb: power_supply_update_gen_leds 1
[    2.805655] power_supply test_usb: uevent
[    2.805657] power_supply test_usb: POWER_SUPPLY_NAME=3Dtest_usb
[    2.805667] power_supply test_usb: prop ONLINE=3D1
[    2.805703] tsc: Refined TSC clocksource calibration: 2661.336 MHz
[    2.943273] NX-protecting the kernel data: 10116k
[    3.137753] power_supply test_ac: uevent
[    3.142310] power_supply test_ac: POWER_SUPPLY_NAME=3Dtest_ac
[    3.147505] power_supply test_ac: prop ONLINE=3D1
[    3.151820] power_supply test_battery: uevent
[    3.156012] power_supply test_battery: POWER_SUPPLY_NAME=3Dtest_battery
[    3.160552] power_supply test_battery: prop STATUS=3DDischarging
[    3.164496] power_supply test_battery: prop CHARGE_TYPE=3DFast
[    3.168988] power_supply test_battery: prop HEALTH=3DGood
[    3.173031] power_supply test_battery: prop PRESENT=3D1
[    3.178082] power_supply test_battery: prop TECHNOLOGY=3DLi-ion
[    3.182791] power_supply test_battery: prop CHARGE_FULL_DESIGN=3D100
[    3.187582] power_supply test_battery: prop CHARGE_FULL=3D100
[    3.191737] power_supply test_battery: prop CHARGE_NOW=3D50
[    3.195586] power_supply test_battery: prop CAPACITY=3D50
[    3.200621] power_supply test_battery: prop CAPACITY_LEVEL=3DNormal
[    3.204834] power_supply test_battery: prop TIME_TO_EMPTY_AVG=3D3600
[    3.209569] power_supply test_battery: prop TIME_TO_FULL_NOW=3D3600
[    3.213323] power_supply test_battery: prop MODEL_NAME=3DTest battery
[    3.217594] power_supply test_battery: prop MANUFACTURER=3DLinux
[    3.221211] power_supply test_battery: prop SERIAL_NUMBER=3D3.12.0-00649=
-g32a440b
[    3.225146] power_supply test_battery: prop TEMP=3D26
[    3.229489] power_supply test_battery: prop VOLTAGE_NOW=3D3300
[    3.233459] power_supply test_usb: uevent
[    3.237186] power_supply test_usb: POWER_SUPPLY_NAME=3Dtest_usb
[    3.240700] power_supply test_usb: prop ONLINE=3D1
[    3.285966] power_supply test_ac: uevent
[    3.290084] power_supply test_ac: POWER_SUPPLY_NAME=3Dtest_ac
[    3.293696] power_supply test_ac: prop ONLINE=3D1
[    3.308935] power_supply test_ac: uevent
[    3.310432] power_supply test_battery: uevent
[    3.310436] power_supply test_battery: POWER_SUPPLY_NAME=3Dtest_battery
[    3.310444] power_supply test_battery: prop STATUS=3DDischarging
[    3.310447] power_supply test_battery: prop CHARGE_TYPE=3DFast
[    3.310450] power_supply test_battery: prop HEALTH=3DGood
[    3.310453] power_supply test_battery: prop PRESENT=3D1
[    3.310455] power_supply test_battery: prop TECHNOLOGY=3DLi-ion
[    3.310458] power_supply test_battery: prop CHARGE_FULL_DESIGN=3D100
[    3.310461] power_supply test_battery: prop CHARGE_FULL=3D100
[    3.310463] power_supply test_battery: prop CHARGE_NOW=3D50
[    3.310466] power_supply test_battery: prop CAPACITY=3D50
[    3.310469] power_supply test_battery: prop CAPACITY_LEVEL=3DNormal
[    3.310471] power_supply test_battery: prop TIME_TO_EMPTY_AVG=3D3600
[    3.310474] power_supply test_battery: prop TIME_TO_FULL_NOW=3D3600
[    3.310476] power_supply test_battery: prop MODEL_NAME=3DTest battery
[    3.310479] power_supply test_battery: prop MANUFACTURER=3DLinux
[    3.310482] power_supply test_battery: prop SERIAL_NUMBER=3D3.12.0-00649=
-g32a440b
[    3.310484] power_supply test_battery: prop TEMP=3D26
[    3.310487] power_supply test_battery: prop VOLTAGE_NOW=3D3300
[    3.310886] power_supply test_usb: uevent
[    3.310888] power_supply test_usb: POWER_SUPPLY_NAME=3Dtest_usb
[    3.310892] power_supply test_usb: prop ONLINE=3D1
[    3.502225] power_supply test_ac: POWER_SUPPLY_NAME=3Dtest_ac
[    3.505798] power_supply test_ac: prop ONLINE=3D1
[    3.508722] power_supply test_usb: uevent
[    3.508725] power_supply test_usb: POWER_SUPPLY_NAME=3Dtest_usb
[    3.508732] power_supply test_usb: prop ONLINE=3D1
[    3.509402] power_supply test_battery: uevent
[    3.509405] power_supply test_battery: POWER_SUPPLY_NAME=3Dtest_battery
[    3.509409] power_supply test_battery: prop STATUS=3DDischarging
[    3.509412] power_supply test_battery: prop CHARGE_TYPE=3DFast
[    3.509415] power_supply test_battery: prop HEALTH=3DGood
[    3.509419] power_supply test_battery: prop PRESENT=3D1
[    3.509422] power_supply test_battery: prop TECHNOLOGY=3DLi-ion
[    3.509425] power_supply test_battery: prop CHARGE_FULL_DESIGN=3D100
[    3.509428] power_supply test_battery: prop CHARGE_FULL=3D100
[    3.509430] power_supply test_battery: prop CHARGE_NOW=3D50
[    3.509433] power_supply test_battery: prop CAPACITY=3D50
[    3.509436] power_supply test_battery: prop CAPACITY_LEVEL=3DNormal
[    3.509439] power_supply test_battery: prop TIME_TO_EMPTY_AVG=3D3600
[    3.509441] power_supply test_battery: prop TIME_TO_FULL_NOW=3D3600
[    3.509444] power_supply test_battery: prop MODEL_NAME=3DTest battery
[    3.509446] power_supply test_battery: prop MANUFACTURER=3DLinux
[    3.509449] power_supply test_battery: prop SERIAL_NUMBER=3D3.12.0-00649=
-g32a440b
[    3.509452] power_supply test_battery: prop TEMP=3D26
[    3.509455] power_supply test_battery: prop VOLTAGE_NOW=3D3300
Kernel tests: Boot OK!
[   70.923628] ------------[ cut here ]------------
[   70.928604] WARNING: CPU: 1 PID: 479 at fs/dcache.c:385 d_lru_del+0x15f/=
0x190()
[   70.933837] Modules linked in:
[   70.951217] CPU: 1 PID: 479 Comm: umount Not tainted 3.12.0-00649-g32a44=
0b #89
[   70.956272] Hardware name: Bochs Bochs, BIOS Bochs 01/01/2011
[   70.960968]  ffffffff cca87e04 c1c05539 00000000 00000000 00000181 cca87=
e34 c1064306
[   70.966287]  c1ec447c 00000001 000001df c1ed6158 00000181 c11d221f c11d2=
21f 00000001
[   70.971684]  cea83e80 00000001 cca87e44 c10643c2 00000009 00000000 cca87=
e58 c11d221f
[   70.977076] Call Trace:
[   70.981446]  [<c1c05539>] dump_stack+0x7d/0xb0
[   70.986142]  [<c1064306>] warn_slowpath_common+0x96/0xb0
[   70.990978]  [<c11d221f>] ? d_lru_del+0x15f/0x190
[   70.995755]  [<c11d221f>] ? d_lru_del+0x15f/0x190
[   71.000432]  [<c10643c2>] warn_slowpath_null+0x22/0x30
[   71.005244]  [<c11d221f>] d_lru_del+0x15f/0x190
[   71.009871]  [<c11d27ff>] umount_collect+0x14f/0x190
[   71.014502]  [<c1c139a2>] ? _raw_spin_lock+0x42/0xb0
[   71.019072]  [<c11d3847>] d_walk+0xc7/0x3d0
[   71.023599]  [<c11d26b0>] ? dentry_lru_del+0x70/0x70
[   71.028535]  [<c11d5d8b>] shrink_dcache_for_umount+0x8b/0x150
[   71.033510]  [<c11b4477>] generic_shutdown_super+0xc7/0x1a0
[   71.038858]  [<c11b480a>] kill_litter_super+0x3a/0x50
[   71.043563]  [<c11b4a95>] deactivate_locked_super+0x45/0x70
[   71.048629]  [<c11b5e16>] deactivate_super+0x96/0xb0
[   71.053511]  [<c11df6e6>] mntput_no_expire+0x1d6/0x200
[   71.058174]  [<c11e0d41>] SyS_umount+0x121/0x5e0
[   71.063860]  [<c11e121e>] SyS_oldumount+0x1e/0x20
[   71.068699]  [<c1c140ff>] syscall_call+0x7/0xb
[   71.073363] ---[ end trace 6b92dd3d08e2681d ]---
[   71.078672] ------------[ cut here ]------------
[   71.083249] WARNING: CPU: 1 PID: 479 at fs/dcache.c:388 d_lru_del+0x12f/=
0x190()
[   71.088956] Modules linked in:
[   71.093494] CPU: 1 PID: 479 Comm: umount Tainted: G        W    3.12.0-0=
0649-g32a440b #89
[   71.099566] Hardware name: Bochs Bochs, BIOS Bochs 01/01/2011
[   71.104606]  ffffffff cca87e04 c1c05539 00000000 00000001 00000184 cca87=
e34 c1064306
[   71.111159]  c1ec447c 00000001 000001df c1ed6158 00000184 c11d21ef c11d2=
1ef 00000001
[   71.116788]  00000001 00000001 cca87e44 c10643c2 00000009 00000000 cca87=
e58 c11d21ef
[   71.122236] Call Trace:
[   71.126906]  [<c1c05539>] dump_stack+0x7d/0xb0
[   71.131897]  [<c1064306>] warn_slowpath_common+0x96/0xb0
[   71.136835]  [<c11d21ef>] ? d_lru_del+0x12f/0x190
[   71.141789]  [<c11d21ef>] ? d_lru_del+0x12f/0x190
[   71.147358]  [<c10643c2>] warn_slowpath_null+0x22/0x30
[   71.152242]  [<c11d21ef>] d_lru_del+0x12f/0x190
[   71.157216]  [<c11d27ff>] umount_collect+0x14f/0x190
[   71.162187]  [<c1c139a2>] ? _raw_spin_lock+0x42/0xb0
[   71.166985]  [<c11d3847>] d_walk+0xc7/0x3d0
[   71.171515]  [<c11d26b0>] ? dentry_lru_del+0x70/0x70
[   71.176441]  [<c11d5d8b>] shrink_dcache_for_umount+0x8b/0x150
[   71.181559]  [<c11b4477>] generic_shutdown_super+0xc7/0x1a0
[   71.186546]  [<c11b480a>] kill_litter_super+0x3a/0x50
[   71.191238]  [<c11b4a95>] deactivate_locked_super+0x45/0x70
[   71.196200]  [<c11b5e16>] deactivate_super+0x96/0xb0
[   71.201077]  [<c11df6e6>] mntput_no_expire+0x1d6/0x200
[   71.205849]  [<c11e0d41>] SyS_umount+0x121/0x5e0
[   71.210364]  [<c11e121e>] SyS_oldumount+0x1e/0x20
[   71.215094]  [<c1c140ff>] syscall_call+0x7/0xb
[   71.219801] ---[ end trace 6b92dd3d08e2681e ]---
[   73.282501] Unregister pv shared memory for cpu 1
[   73.286864] Unregister pv shared memory for cpu 0
[   73.303815] reboot: Restarting system
[   73.308511] reboot: machine restart
Elapsed time: 80
qemu-system-x86_64 -cpu kvm64 -enable-kvm -kernel /kernel/i386-randconfig-r=
3-1107/32a440b38c2b6f2f927b8e294e4877fe505f9653/vmlinuz-3.12.0-00649-g32a44=
0b -append 'hung_task_panic=3D1 rcutree.rcu_cpu_stall_timeout=3D100 log_buf=
_len=3D8M ignore_loglevel debug sched_debug apic=3Ddebug dynamic_printk sys=
rq_always_enabled panic=3D10  prompt_ramdisk=3D0 console=3DttyS0,115200 con=
sole=3Dtty0 vga=3Dnormal  root=3D/dev/ram0 rw link=3D/kernel-tests/run-queu=
e/kvm/i386-randconfig-r3-1107/devel-roam-i386-201311072347/.vmlinuz-32a440b=
38c2b6f2f927b8e294e4877fe505f9653-20131108000013-1-lkp-st01 branch=3Dlinux-=
devel/devel-roam-i386-201311072347 BOOT_IMAGE=3D/kernel/i386-randconfig-r3-=
1107/32a440b38c2b6f2f927b8e294e4877fe505f9653/vmlinuz-3.12.0-00649-g32a440b=
'  -initrd /kernel-tests/initrd/yocto-minimal-i386.cgz -m 256M -smp 2 -net =
nic,vlan=3D1,model=3De1000 -net user,vlan=3D1 -boot order=3Dnc -no-reboot -=
watchdog i6300esb -drive file=3D/fs/LABEL=3DKVM/disk0-yocto-lkp-st01-6,medi=
a=3Ddisk,if=3Dvirtio -drive file=3D/fs/LABEL=3DKVM/disk1-yocto-lkp-st01-6,m=
edia=3Ddisk,if=3Dvirtio -drive file=3D/fs/LABEL=3DKVM/disk2-yocto-lkp-st01-=
6,media=3Ddisk,if=3Dvirtio -drive file=3D/fs/LABEL=3DKVM/disk3-yocto-lkp-st=
01-6,media=3Ddisk,if=3Dvirtio -drive file=3D/fs/LABEL=3DKVM/disk4-yocto-lkp=
-st01-6,media=3Ddisk,if=3Dvirtio -drive file=3D/fs/LABEL=3DKVM/disk5-yocto-=
lkp-st01-6,media=3Ddisk,if=3Dvirtio -pidfile /dev/shm/kboot/pid-yocto-lkp-s=
t01-6 -serial file:/dev/shm/kboot/serial-yocto-lkp-st01-6 -daemonize -displ=
ay none -monitor null=20

--vkogqOf2sHV7VnPd
Content-Type: application/octet-stream
Content-Disposition: attachment; filename="bisect-32a440b38c2b6f2f927b8e294e4877fe505f9653-i386-randconfig-r3-1107-WARNING:-CPU:-71808.log"
Content-Transfer-Encoding: base64

Z2l0IGNoZWNrb3V0IDVlMDFkYzdiMjZkOWYyNGYzOWFiYWNlNWRhOThjY2JkNmE1Y2ViNTIK
UHJldmlvdXMgSEVBRCBwb3NpdGlvbiB3YXMgMzJhNDQwYi4uLiBNZXJnZSAndmZzL2Zvci1u
ZXh0JyBpbnRvIGRldmVsLXJvYW0taTM4Ni0yMDEzMTEwNzIzNDcKSEVBRCBpcyBub3cgYXQg
NWUwMWRjNy4uLiBMaW51eCAzLjEyCmxzIC1hIC9rZXJuZWwtdGVzdHMvcnVuLXF1ZXVlL2t2
bS9pMzg2LXJhbmRjb25maWctcjMtMTEwNy9saW51eC1kZXZlbDpkZXZlbC1yb2FtLWkzODYt
MjAxMzExMDcyMzQ3OjVlMDFkYzdiMjZkOWYyNGYzOWFiYWNlNWRhOThjY2JkNmE1Y2ViNTI6
YmlzZWN0LXVzYgogU1VDQ0VTUwoKYmlzZWN0OiBnb29kIGNvbW1pdCA1ZTAxZGM3YjI2ZDlm
MjRmMzlhYmFjZTVkYTk4Y2NiZDZhNWNlYjUyCmdpdCBiaXNlY3Qgc3RhcnQgMzJhNDQwYjM4
YzJiNmYyZjkyN2I4ZTI5NGU0ODc3ZmU1MDVmOTY1MyA1ZTAxZGM3YjI2ZDlmMjRmMzlhYmFj
ZTVkYTk4Y2NiZDZhNWNlYjUyIC0tClByZXZpb3VzIEhFQUQgcG9zaXRpb24gd2FzIDVlMDFk
YzcuLi4gTGludXggMy4xMgpIRUFEIGlzIG5vdyBhdCA2ZTQ2NjQ1Li4uIExpbnV4IDMuMTEK
QmlzZWN0aW5nOiAzMzUgcmV2aXNpb25zIGxlZnQgdG8gdGVzdCBhZnRlciB0aGlzIChyb3Vn
aGx5IDggc3RlcHMpClsxZTdhNjkzNWJjY2M4ZDE2NTk2YjJmNzJkNDE2MmVhZGIwYTVmMmQw
XSBNZXJnZSAndGlwL3BlcmYvY29yZScgaW50byBkZXZlbC1yb2FtLWkzODYtMjAxMzExMDcy
MzQ3CmdpdCBiaXNlY3QgcnVuIC9jL2tlcm5lbC10ZXN0cy9iaXNlY3QtdGVzdC1ib290LWZh
aWx1cmUuc2ggL2hvbWUvd2ZnL3VzYi9vYmotYmlzZWN0CnJ1bm5pbmcgL2Mva2VybmVsLXRl
c3RzL2Jpc2VjdC10ZXN0LWJvb3QtZmFpbHVyZS5zaCAvaG9tZS93ZmcvdXNiL29iai1iaXNl
Y3QKbHMgLWEgL2tlcm5lbC10ZXN0cy9ydW4tcXVldWUva3ZtL2kzODYtcmFuZGNvbmZpZy1y
My0xMTA3L2xpbnV4LWRldmVsOmRldmVsLXJvYW0taTM4Ni0yMDEzMTEwNzIzNDc6MWU3YTY5
MzViY2NjOGQxNjU5NmIyZjcyZDQxNjJlYWRiMGE1ZjJkMDpiaXNlY3QtdXNiCgoyMDEzLTEx
LTA4LTEwOjIzOjU3IDFlN2E2OTM1YmNjYzhkMTY1OTZiMmY3MmQ0MTYyZWFkYjBhNWYyZDAg
Y29tcGlsaW5nCjU1NSByZWFsICAzMzAzIHVzZXIgIDI2MyBzeXMgIDY0Mi42OSUgY3B1IAlp
Mzg2LXJhbmRjb25maWctcjMtMTEwNwoKMjAxMy0xMS0wOC0xMDozMzo1MCBkZXRlY3Rpbmcg
Ym9vdCBzdGF0ZSAzLjEyLjAtMDAzMTMtZzFlN2E2OTMuCTMJNgkxNyBTVUNDRVNTCgpCaXNl
Y3Rpbmc6IDE4MiByZXZpc2lvbnMgbGVmdCB0byB0ZXN0IGFmdGVyIHRoaXMgKHJvdWdobHkg
NyBzdGVwcykKWzZmN2RiZTcyOTBhM2MyYWY5Y2NmNzVjN2UyMTlkZmMxZWU3NjJiMDVdIE1l
cmdlICdhdDkxL25mZS9hdDkxLTMuMTQtY2xlYW51cCt0ZXN0LW5ldycgaW50byBkZXZlbC1y
b2FtLWkzODYtMjAxMzExMDcyMzQ3CnJ1bm5pbmcgL2Mva2VybmVsLXRlc3RzL2Jpc2VjdC10
ZXN0LWJvb3QtZmFpbHVyZS5zaCAvaG9tZS93ZmcvdXNiL29iai1iaXNlY3QKbHMgLWEgL2tl
cm5lbC10ZXN0cy9ydW4tcXVldWUva3ZtL2kzODYtcmFuZGNvbmZpZy1yMy0xMTA3L2xpbnV4
LWRldmVsOmRldmVsLXJvYW0taTM4Ni0yMDEzMTEwNzIzNDc6NmY3ZGJlNzI5MGEzYzJhZjlj
Y2Y3NWM3ZTIxOWRmYzFlZTc2MmIwNTpiaXNlY3QtdXNiCgoyMDEzLTExLTA4LTEwOjM1OjUz
IDZmN2RiZTcyOTBhM2MyYWY5Y2NmNzVjN2UyMTlkZmMxZWU3NjJiMDUgY29tcGlsaW5nCjc2
MCByZWFsICAzMzcwIHVzZXIgIDI1MyBzeXMgIDQ3Ni4zOCUgY3B1IAlpMzg2LXJhbmRjb25m
aWctcjMtMTEwNwoKMjAxMy0xMS0wOC0xMDo1NTo0MyBkZXRlY3RpbmcgYm9vdCBzdGF0ZSAz
LjEyLjAtMDA0NjYtZzZmN2RiZTcuLgk0CTEzCTE1Li4uLi4uLi4uCTE2LgkxNyBTVUNDRVNT
CgpCaXNlY3Rpbmc6IDkxIHJldmlzaW9ucyBsZWZ0IHRvIHRlc3QgYWZ0ZXIgdGhpcyAocm91
Z2hseSA3IHN0ZXBzKQpbNWQ0YzI0NzUxMWIzMDMwY2ExNGQ3YjJkMTJlMmYyMDZiYmNjYjdk
MV0gbG9ja3M6IGludHJvZHVjZSBuZXcgRkxfREVMRUcgbG9jayBmbGFnCnJ1bm5pbmcgL2Mv
a2VybmVsLXRlc3RzL2Jpc2VjdC10ZXN0LWJvb3QtZmFpbHVyZS5zaCAvaG9tZS93ZmcvdXNi
L29iai1iaXNlY3QKbHMgLWEgL2tlcm5lbC10ZXN0cy9ydW4tcXVldWUva3ZtL2kzODYtcmFu
ZGNvbmZpZy1yMy0xMTA3L2xpbnV4LWRldmVsOmRldmVsLXJvYW0taTM4Ni0yMDEzMTEwNzIz
NDc6NWQ0YzI0NzUxMWIzMDMwY2ExNGQ3YjJkMTJlMmYyMDZiYmNjYjdkMTpiaXNlY3QtdXNi
CgoyMDEzLTExLTA4LTExOjA0OjIxIDVkNGMyNDc1MTFiMzAzMGNhMTRkN2IyZDEyZTJmMjA2
YmJjY2I3ZDEgY29tcGlsaW5nCjYzOCByZWFsICAzMzk1IHVzZXIgIDI4MiBzeXMgIDU3Ni4y
NSUgY3B1IAlpMzg2LXJhbmRjb25maWctcjMtMTEwNwoKMjAxMy0xMS0wOC0xMToxODowOCBk
ZXRlY3RpbmcgYm9vdCBzdGF0ZSAzLjEyLjAtcmM0LTAwMDkxLWc1ZDRjMjQ3Li4uIFRFU1Qg
RkFJTFVSRQpbICAgNjIuMTY0Njk2XSBpbml0OiBod2Nsb2NrLXNhdmUgbWFpbiBwcm9jZXNz
ICgyNDY0KSB0ZXJtaW5hdGVkIHdpdGggc3RhdHVzIDcwClsgICA2Mi4xNjkyOTVdIGluaXQ6
IHBseW1vdXRoLXVwc3RhcnQtYnJpZGdlIG1haW4gcHJvY2VzcyAoMjQ2NSkgdGVybWluYXRl
ZCB3aXRoIHN0YXR1cyAxClsgICA2Mi40MDAxNjJdIC0tLS0tLS0tLS0tLVsgY3V0IGhlcmUg
XS0tLS0tLS0tLS0tLQpbICAgNjIuNDA2MjcwXSBXQVJOSU5HOiBDUFU6IDAgUElEOiAyNTU3
IGF0IGZzL2RjYWNoZS5jOjM4NSBkX2xydV9kZWwrMHgxNWYvMHgxOTAoKQpbICAgNjIuNDEx
MDg1XSBNb2R1bGVzIGxpbmtlZCBpbjoKWyAgIDYyLjQxNTMxMV0gQ1BVOiAwIFBJRDogMjU1
NyBDb21tOiB1bW91bnQgTm90IHRhaW50ZWQgMy4xMi4wLXJjNC0wMDA5MS1nNWQ0YzI0NyAj
NzQ2ClsgICA2Mi40MjAxMTRdIEhhcmR3YXJlIG5hbWU6IEJvY2hzIEJvY2hzLCBCSU9TIEJv
Y2hzIDAxLzAxLzIwMTEKWyAgIDYyLjQyNDcyMF0gIGZmZmZmZmZmIGNmMDVkZTE0IGMxYzAx
ZmViIDAwMDAwMDAwIDAwMDAwMDAwIDAwMDAwMTgxIGNmMDVkZTQ0IGMxMDY0MDM2ClsgICA2
Mi40Mjk2NzVdICBjMWViZmY3OCAwMDAwMDAwMCAwMDAwMDlmZCBjMWVlYmVhZSAwMDAwMDE4
MSBjMTFkMWRiZiBjMTFkMWRiZiAwMDAwMDAwMQpbICAgNjIuNDM0Njc3XSAgYzhkNjZmODAg
MDAwMDAwMDEgY2YwNWRlNTQgYzEwNjQwZjIgMDAwMDAwMDkgMDAwMDAwMDAgY2YwNWRlNjgg
YzExZDFkYmYKWyAgIDYyLjQzOTc2M10gQ2FsbCBUcmFjZToKWyAgIDYyLjQ0NDA5MV0gIFs8
YzFjMDFmZWI+XSBkdW1wX3N0YWNrKzB4N2QvMHhiMApbICAgNjIuNDQ4Njc0XSAgWzxjMTA2
NDAzNj5dIHdhcm5fc2xvd3BhdGhfY29tbW9uKzB4OTYvMHhiMApbICAgNjIuNDUzMzgxXSAg
WzxjMTFkMWRiZj5dID8gZF9scnVfZGVsKzB4MTVmLzB4MTkwClsgICA2Mi40NTgwMTldICBb
PGMxMWQxZGJmPl0gPyBkX2xydV9kZWwrMHgxNWYvMHgxOTAKWyAgIDYyLjQ2MjYyM10gIFs8
YzEwNjQwZjI+XSB3YXJuX3Nsb3dwYXRoX251bGwrMHgyMi8weDMwClsgICA2Mi40NjcyOThd
ICBbPGMxMWQxZGJmPl0gZF9scnVfZGVsKzB4MTVmLzB4MTkwClsgICA2Mi40NzE5MzldICBb
PGMxMWQyNWVmPl0gdW1vdW50X2NvbGxlY3QrMHgxNGYvMHgxOTAKWyAgIDYyLjQ3NjYzMl0g
IFs8YzFjMTA0ODI+XSA/IF9yYXdfc3Bpbl9sb2NrKzB4NDIvMHhiMApbICAgNjIuNDgxNDEw
XSAgWzxjMTFkMzYyNz5dIGRfd2FsaysweGM3LzB4M2QwClsgICA2Mi40ODYwMjZdICBbPGMx
MWQyNGEwPl0gPyBkZW50cnlfbHJ1X2RlbCsweDcwLzB4NzAKWyAgIDYyLjQ5MDY2MF0gIFs8
YzExZDVhZWI+XSBzaHJpbmtfZGNhY2hlX2Zvcl91bW91bnQrMHg4Yi8weDE1MApbICAgNjIu
NDk1NDA1XSAgWzxjMTFiNDRhNz5dIGdlbmVyaWNfc2h1dGRvd25fc3VwZXIrMHhjNy8weDFh
MApbICAgNjIuNTAwMDgwXSAgWzxjMTFiNDgzYT5dIGtpbGxfbGl0dGVyX3N1cGVyKzB4M2Ev
MHg1MApbICAgNjIuNTA0Njg3XSAgWzxjMTFiNGFjNT5dIGRlYWN0aXZhdGVfbG9ja2VkX3N1
cGVyKzB4NDUvMHg3MApbICAgNjIuNTA5MzI0XSAgWzxjMTFiNWU0Nj5dIGRlYWN0aXZhdGVf
c3VwZXIrMHg5Ni8weGIwClsgICA2Mi41MTM4NjBdICBbPGMxMWRmMzg2Pl0gbW50cHV0X25v
X2V4cGlyZSsweDFkNi8weDIwMApbICAgNjIuNTE4MzY4XSAgWzxjMTFlMDllMT5dIFN5U191
bW91bnQrMHgxMjEvMHg1ZTAKWyAgIDYyLjUyMjg3M10gIFs8YzFjMWE3ZDk+XSBzeXNlbnRl
cl9kb19jYWxsKzB4MTIvMHgyZApbICAgNjIuNTI3MzI5XSAtLS1bIGVuZCB0cmFjZSAyMzAw
ODgyZTA1OTdjMjlmIF0tLS0KWyAgIDYyLjUzMTcxN10gLS0tLS0tLS0tLS0tWyBjdXQgaGVy
ZSBdLS0tLS0tLS0tLS0tCi9rZXJuZWwvaTM4Ni1yYW5kY29uZmlnLXIzLTExMDcvNWQ0YzI0
NzUxMWIzMDMwY2ExNGQ3YjJkMTJlMmYyMDZiYmNjYjdkMS9kbWVzZy1xdWFudGFsLXhpYW4t
MzE6MjAxMzExMDgxMTE5MjE6aTM4Ni1yYW5kY29uZmlnLXIzLTExMDc6My4xMi4wLXJjNC0w
MDA5MS1nNWQ0YzI0Nzo3NDYKL2tlcm5lbC9pMzg2LXJhbmRjb25maWctcjMtMTEwNy81ZDRj
MjQ3NTExYjMwMzBjYTE0ZDdiMmQxMmUyZjIwNmJiY2NiN2QxL2RtZXNnLXF1YW50YWwtc25i
LTQzOjIwMTMxMTA4MTExOTI4OmkzODYtcmFuZGNvbmZpZy1yMy0xMTA3OjMuMTIuMC1yYzQt
MDAwOTEtZzVkNGMyNDc6NzQ2Ci9rZXJuZWwvaTM4Ni1yYW5kY29uZmlnLXIzLTExMDcvNWQ0
YzI0NzUxMWIzMDMwY2ExNGQ3YjJkMTJlMmYyMDZiYmNjYjdkMS9kbWVzZy15b2N0by1sa3At
dHQwMi05OjIwMTMxMTA4MDIwOTM2OmkzODYtcmFuZGNvbmZpZy1yMy0xMTA3OjMuMTIuMC1y
YzQtMDAwOTEtZzVkNGMyNDc6NzQ2Ci9rZXJuZWwvaTM4Ni1yYW5kY29uZmlnLXIzLTExMDcv
NWQ0YzI0NzUxMWIzMDMwY2ExNGQ3YjJkMTJlMmYyMDZiYmNjYjdkMS9kbWVzZy15b2N0by14
cHMtMToyMDEzMTEwODE5MTgzOTppMzg2LXJhbmRjb25maWctcjMtMTEwNzozLjEyLjAtcmM0
LTAwMDkxLWc1ZDRjMjQ3Ojc0NgowOjQ6NCBhbGxfZ29vZDpiYWQ6YWxsX2JhZCBib290cwob
WzE7MzVtUkVQRUFUIENPVU5UOiAyMCAgIyAvY2Mvd2ZnL3VzYi1iaXNlY3QvLnJlcGVhdBtb
MG0KCkJpc2VjdGluZzogNDUgcmV2aXNpb25zIGxlZnQgdG8gdGVzdCBhZnRlciB0aGlzIChy
b3VnaGx5IDYgc3RlcHMpCls4NDU1MGI5MzU2YWY1MGM3Y2JkNmI2Y2U2ZThmZDA2NTg1ZWVi
ZjE0XSBSQ1UnZCB2ZnNtb3VudHMKcnVubmluZyAvYy9rZXJuZWwtdGVzdHMvYmlzZWN0LXRl
c3QtYm9vdC1mYWlsdXJlLnNoIC9ob21lL3dmZy91c2Ivb2JqLWJpc2VjdApscyAtYSAva2Vy
bmVsLXRlc3RzL3J1bi1xdWV1ZS9rdm0vaTM4Ni1yYW5kY29uZmlnLXIzLTExMDcvbGludXgt
ZGV2ZWw6ZGV2ZWwtcm9hbS1pMzg2LTIwMTMxMTA3MjM0Nzo4NDU1MGI5MzU2YWY1MGM3Y2Jk
NmI2Y2U2ZThmZDA2NTg1ZWViZjE0OmJpc2VjdC11c2IKCjIwMTMtMTEtMDgtMTE6MTk6NDgg
ODQ1NTBiOTM1NmFmNTBjN2NiZDZiNmNlNmU4ZmQwNjU4NWVlYmYxNCBjb21waWxpbmcKODYx
IHJlYWwgIDMyODQgdXNlciAgMjY5IHN5cyAgNDEyLjU5JSBjcHUgCWkzODYtcmFuZGNvbmZp
Zy1yMy0xMTA3CgoyMDEzLTExLTA4LTExOjM2OjEzIGRldGVjdGluZyBib290IHN0YXRlIDMu
MTIuMC1yYzQtMDAwNDUtZzg0NTUwYjkuLi4gVEVTVCBGQUlMVVJFClsgICA2My4zNzI0NTNd
IGluaXQ6IGh3Y2xvY2stc2F2ZSBtYWluIHByb2Nlc3MgKDI0NjApIHRlcm1pbmF0ZWQgd2l0
aCBzdGF0dXMgNzAKWyAgIDYzLjM4MDMxOF0gaW5pdDogcGx5bW91dGgtdXBzdGFydC1icmlk
Z2UgbWFpbiBwcm9jZXNzICgyNDYxKSB0ZXJtaW5hdGVkIHdpdGggc3RhdHVzIDEKWyAgIDYz
LjY1MDAyOF0gLS0tLS0tLS0tLS0tWyBjdXQgaGVyZSBdLS0tLS0tLS0tLS0tClsgICA2My42
NTc2NjBdIFdBUk5JTkc6IENQVTogMSBQSUQ6IDI1NTMgYXQgZnMvZGNhY2hlLmM6Mzg0IGRf
bHJ1X2RlbCsweDE1Zi8weDE5MCgpClsgICA2My42NjU1OTZdIE1vZHVsZXMgbGlua2VkIGlu
OgpbICAgNjMuNjczNjUyXSBDUFU6IDEgUElEOiAyNTUzIENvbW06IHVtb3VudCBOb3QgdGFp
bnRlZCAzLjEyLjAtcmM0LTAwMDQ1LWc4NDU1MGI5ICM3NDcKWyAgIDYzLjY4MTkzMl0gSGFy
ZHdhcmUgbmFtZTogQm9jaHMgQm9jaHMsIEJJT1MgQm9jaHMgMDEvMDEvMjAxMQpbICAgNjMu
Njg5OTU1XSAgZmZmZmZmZmYgY2YwNjVlMTQgYzFjMDI1OWYgMDAwMDAwMDAgMDAwMDAwMDAg
MDAwMDAxODAgY2YwNjVlNDQgYzEwNjQwMzYKWyAgIDYzLjY5OTAxM10gIGMxZWJmZmRjIDAw
MDAwMDAxIDAwMDAwOWY5IGMxZWViZWZmIDAwMDAwMTgwIGMxMWQyMmNmIGMxMWQyMmNmIDAw
MDAwMDAxClsgICA2My43MDgwNDNdICBjOTE4MjcwMCAwMDAwMDAwMSBjZjA2NWU1NCBjMTA2
NDBmMiAwMDAwMDAwOSAwMDAwMDAwMCBjZjA2NWU2OCBjMTFkMjJjZgpbICAgNjMuNzE2OTgx
XSBDYWxsIFRyYWNlOgpbICAgNjMuNzI0ODMyXSAgWzxjMWMwMjU5Zj5dIGR1bXBfc3RhY2sr
MHg3ZC8weGIwClsgICA2My43MzMxMzVdICBbPGMxMDY0MDM2Pl0gd2Fybl9zbG93cGF0aF9j
b21tb24rMHg5Ni8weGIwClsgICA2My43NDIwMzhdICBbPGMxMWQyMmNmPl0gPyBkX2xydV9k
ZWwrMHgxNWYvMHgxOTAKWyAgIDYzLjc1MDgzNF0gIFs8YzExZDIyY2Y+XSA/IGRfbHJ1X2Rl
bCsweDE1Zi8weDE5MApbICAgNjMuNzU5NTE1XSAgWzxjMTA2NDBmMj5dIHdhcm5fc2xvd3Bh
dGhfbnVsbCsweDIyLzB4MzAKWyAgIDYzLjc2ODI0OF0gIFs8YzExZDIyY2Y+XSBkX2xydV9k
ZWwrMHgxNWYvMHgxOTAKWyAgIDYzLjc3NjQyOF0gIFs8YzExZDJhZmY+XSB1bW91bnRfY29s
bGVjdCsweDE0Zi8weDE5MApbICAgNjMuNzg0NDk3XSAgWzxjMWMxMGEzMj5dID8gX3Jhd19z
cGluX2xvY2srMHg0Mi8weGIwClsgICA2My43OTI0MzFdICBbPGMxMWQzYjQ3Pl0gZF93YWxr
KzB4YzcvMHgzZDAKWyAgIDYzLjgwMDU0MV0gIFs8YzExZDI5YjA+XSA/IGRlbnRyeV9scnVf
ZGVsKzB4NzAvMHg3MApbICAgNjMuODA4ODIyXSAgWzxjMTFkNjAxYj5dIHNocmlua19kY2Fj
aGVfZm9yX3Vtb3VudCsweDhiLzB4MTUwClsgICA2My44MTcxNzVdICBbPGMxMWI0NzBmPl0g
Z2VuZXJpY19zaHV0ZG93bl9zdXBlcisweGNmLzB4MWEwClsgICA2My44MjUyOTFdICBbPGMx
MWI0YTlhPl0ga2lsbF9saXR0ZXJfc3VwZXIrMHgzYS8weDUwClsgICA2My44MzI5MDVdICBb
PGMxMWI0ZDI1Pl0gZGVhY3RpdmF0ZV9sb2NrZWRfc3VwZXIrMHg0NS8weDcwClsgICA2My44
Mzg0NDddICBbPGMxMWI2MTM2Pl0gZGVhY3RpdmF0ZV9zdXBlcisweDk2LzB4YjAKWyAgIDYz
Ljg0NjU5NF0gIFs8YzExZGY2YzY+XSBtbnRwdXRfbm9fZXhwaXJlKzB4MWQ2LzB4MjAwClsg
ICA2My44NTQ4MzldICBbPGMxMWUwZDIxPl0gU3lTX3Vtb3VudCsweDEyMS8weDVlMApbICAg
NjMuODYyOTg5XSAgWzxjMWMxYWQ5OT5dIHN5c2VudGVyX2RvX2NhbGwrMHgxMi8weDJkClsg
ICA2My44NzA4ODZdIC0tLVsgZW5kIHRyYWNlIDk3NWQ4MTg0OGI2MTE1NDUgXS0tLQpbICAg
NjMuODc4OTc3XSAtLS0tLS0tLS0tLS1bIGN1dCBoZXJlIF0tLS0tLS0tLS0tLS0KL2tlcm5l
bC9pMzg2LXJhbmRjb25maWctcjMtMTEwNy84NDU1MGI5MzU2YWY1MGM3Y2JkNmI2Y2U2ZThm
ZDA2NTg1ZWViZjE0L2RtZXNnLXF1YW50YWwtaW5uLTI5OjIwMTMxMTA4MTEzNzI5OmkzODYt
cmFuZGNvbmZpZy1yMy0xMTA3OjMuMTIuMC1yYzQtMDAwNDUtZzg0NTUwYjk6NzQ3Ci9rZXJu
ZWwvaTM4Ni1yYW5kY29uZmlnLXIzLTExMDcvODQ1NTBiOTM1NmFmNTBjN2NiZDZiNmNlNmU4
ZmQwNjU4NWVlYmYxNC9kbWVzZy1xdWFudGFsLXdhaW1lYS0yOjIwMTMxMTA4MTkzNDU5Omkz
ODYtcmFuZGNvbmZpZy1yMy0xMTA3OjMuMTIuMC1yYzQtMDAwNDUtZzg0NTUwYjk6NzQ3Ci9r
ZXJuZWwvaTM4Ni1yYW5kY29uZmlnLXIzLTExMDcvODQ1NTBiOTM1NmFmNTBjN2NiZDZiNmNl
NmU4ZmQwNjU4NWVlYmYxNC9kbWVzZy1xdWFudGFsLXdhaW1lYS05OjIwMTMxMTA4MTkzNTA1
OmkzODYtcmFuZGNvbmZpZy1yMy0xMTA3OjMuMTIuMC1yYzQtMDAwNDUtZzg0NTUwYjk6NzQ3
Ci9rZXJuZWwvaTM4Ni1yYW5kY29uZmlnLXIzLTExMDcvODQ1NTBiOTM1NmFmNTBjN2NiZDZi
NmNlNmU4ZmQwNjU4NWVlYmYxNC9kbWVzZy15b2N0by13YWltZWEtMTM6MjAxMzExMDgxOTM1
MDY6aTM4Ni1yYW5kY29uZmlnLXIzLTExMDc6My4xMi4wLXJjNC0wMDA0NS1nODQ1NTBiOTo3
NDcKMDo0OjQgYWxsX2dvb2Q6YmFkOmFsbF9iYWQgYm9vdHMKG1sxOzM1bVJFUEVBVCBDT1VO
VDogMjAgICMgL2NjL3dmZy91c2ItYmlzZWN0Ly5yZXBlYXQbWzBtCgpCaXNlY3Rpbmc6IDIy
IHJldmlzaW9ucyBsZWZ0IHRvIHRlc3QgYWZ0ZXIgdGhpcyAocm91Z2hseSA1IHN0ZXBzKQpb
NjMzOWRhYjg2OWUwN2E4MWFiZDIyOTcwNjk2ZGRlNmZlYmVlMDk0YV0gZG9fcmVtb3VudCgp
OiBwdWxsIHRvdWNoX21udF9uYW1lc3BhY2UoKSB1cApydW5uaW5nIC9jL2tlcm5lbC10ZXN0
cy9iaXNlY3QtdGVzdC1ib290LWZhaWx1cmUuc2ggL2hvbWUvd2ZnL3VzYi9vYmotYmlzZWN0
CmxzIC1hIC9rZXJuZWwtdGVzdHMvcnVuLXF1ZXVlL2t2bS9pMzg2LXJhbmRjb25maWctcjMt
MTEwNy9saW51eC1kZXZlbDpkZXZlbC1yb2FtLWkzODYtMjAxMzExMDcyMzQ3OjYzMzlkYWI4
NjllMDdhODFhYmQyMjk3MDY5NmRkZTZmZWJlZTA5NGE6YmlzZWN0LXVzYgoKMjAxMy0xMS0w
OC0xMTozNzo0OCA2MzM5ZGFiODY5ZTA3YTgxYWJkMjI5NzA2OTZkZGU2ZmViZWUwOTRhIGNv
bXBpbGluZwo4MTEgcmVhbCAgMjc5NSB1c2VyICAyMTYgc3lzICAzNzEuMTklIGNwdSAJaTM4
Ni1yYW5kY29uZmlnLXIzLTExMDcKCjIwMTMtMTEtMDgtMTE6NTI6MzYgZGV0ZWN0aW5nIGJv
b3Qgc3RhdGUgMy4xMi4wLXJjNC0wMDAyMi1nNjMzOWRhYi4uCTExCTE5CTIwIFNVQ0NFU1MK
CkJpc2VjdGluZzogMTEgcmV2aXNpb25zIGxlZnQgdG8gdGVzdCBhZnRlciB0aGlzIChyb3Vn
aGx5IDQgc3RlcHMpCls0NzQyNzlkYzBmNzc0NTEyNGZjNzZiNDc0YzhkYzEyOTRmOGU4N2Nl
XSBzcGxpdCBfX2xvb2t1cF9tbnQoKSBpbiB0d28gZnVuY3Rpb25zCnJ1bm5pbmcgL2Mva2Vy
bmVsLXRlc3RzL2Jpc2VjdC10ZXN0LWJvb3QtZmFpbHVyZS5zaCAvaG9tZS93ZmcvdXNiL29i
ai1iaXNlY3QKbHMgLWEgL2tlcm5lbC10ZXN0cy9ydW4tcXVldWUva3ZtL2kzODYtcmFuZGNv
bmZpZy1yMy0xMTA3L2xpbnV4LWRldmVsOmRldmVsLXJvYW0taTM4Ni0yMDEzMTEwNzIzNDc6
NDc0Mjc5ZGMwZjc3NDUxMjRmYzc2YjQ3NGM4ZGMxMjk0ZjhlODdjZTpiaXNlY3QtdXNiCgoy
MDEzLTExLTA4LTExOjU1OjExIDQ3NDI3OWRjMGY3NzQ1MTI0ZmM3NmI0NzRjOGRjMTI5NGY4
ZTg3Y2UgY29tcGlsaW5nCjI1NyByZWFsICAyNjggdXNlciAgMzcgc3lzICAxMTguOTIlIGNw
dSAJaTM4Ni1yYW5kY29uZmlnLXIzLTExMDcKCjIwMTMtMTEtMDgtMTI6MDE6MTMgZGV0ZWN0
aW5nIGJvb3Qgc3RhdGUgMy4xMi4wLXJjNC0wMDAzMy1nNDc0Mjc5ZC4uCTcJMTUJMTYuLgkx
Ny4uLi4uLi4uCTE5CTIwIFNVQ0NFU1MKCkJpc2VjdGluZzogNSByZXZpc2lvbnMgbGVmdCB0
byB0ZXN0IGFmdGVyIHRoaXMgKHJvdWdobHkgMyBzdGVwcykKW2JhYTQwNjcxZDNlM2I1OTBh
MzNiMmMwZTAyMmRiNjFjYmViZjVjMDBdIGF1dG9mczQ6IG1ha2UgZnJlZWluZyBzYmkgcmN1
LWRlbGF5ZWQKcnVubmluZyAvYy9rZXJuZWwtdGVzdHMvYmlzZWN0LXRlc3QtYm9vdC1mYWls
dXJlLnNoIC9ob21lL3dmZy91c2Ivb2JqLWJpc2VjdApscyAtYSAva2VybmVsLXRlc3RzL3J1
bi1xdWV1ZS9rdm0vaTM4Ni1yYW5kY29uZmlnLXIzLTExMDcvbGludXgtZGV2ZWw6ZGV2ZWwt
cm9hbS1pMzg2LTIwMTMxMTA3MjM0NzpiYWE0MDY3MWQzZTNiNTkwYTMzYjJjMGUwMjJkYjYx
Y2JlYmY1YzAwOmJpc2VjdC11c2IKCjIwMTMtMTEtMDgtMTI6MTA6MTQgYmFhNDA2NzFkM2Uz
YjU5MGEzM2IyYzBlMDIyZGI2MWNiZWJmNWMwMCBjb21waWxpbmcKOTk5IHJlYWwgIDI3ODUg
dXNlciAgMjE4IHN5cyAgMzAwLjQzJSBjcHUgCWkzODYtcmFuZGNvbmZpZy1yMy0xMTA3Cgoy
MDEzLTExLTA4LTEyOjI4OjMxIGRldGVjdGluZyBib290IHN0YXRlIDMuMTIuMC1yYzQtMDAw
MzktZ2JhYTQwNjcuLgk0CTE5LgkyMCBTVUNDRVNTCgpCaXNlY3Rpbmc6IDIgcmV2aXNpb25z
IGxlZnQgdG8gdGVzdCBhZnRlciB0aGlzIChyb3VnaGx5IDIgc3RlcHMpClsxZGNkZGQ0YWJk
MmM2ZGY3ZjI4OTI4YWQ1Y2FmYTRhMWNkMjAwMzBiXSBuY3BmczogcmN1LWRlbGF5IHVubG9h
ZF9ubHMoKSBhbmQgZnJlZWluZyBuY3Bfc2VydmVyCnJ1bm5pbmcgL2Mva2VybmVsLXRlc3Rz
L2Jpc2VjdC10ZXN0LWJvb3QtZmFpbHVyZS5zaCAvaG9tZS93ZmcvdXNiL29iai1iaXNlY3QK
bHMgLWEgL2tlcm5lbC10ZXN0cy9ydW4tcXVldWUva3ZtL2kzODYtcmFuZGNvbmZpZy1yMy0x
MTA3L2xpbnV4LWRldmVsOmRldmVsLXJvYW0taTM4Ni0yMDEzMTEwNzIzNDc6MWRjZGRkNGFi
ZDJjNmRmN2YyODkyOGFkNWNhZmE0YTFjZDIwMDMwYjpiaXNlY3QtdXNiCgoyMDEzLTExLTA4
LTEyOjMxOjMyIDFkY2RkZDRhYmQyYzZkZjdmMjg5MjhhZDVjYWZhNGExY2QyMDAzMGIgY29t
cGlsaW5nCjM0NCByZWFsICAyMzQgdXNlciAgMzUgc3lzICA3OC4zNyUgY3B1IAlpMzg2LXJh
bmRjb25maWctcjMtMTEwNwoKMjAxMy0xMS0wOC0xMjo0MTowNyBkZXRlY3RpbmcgYm9vdCBz
dGF0ZSAzLjEyLjAtcmM0LTAwMDQyLWcxZGNkZGQ0Li4JMTIJMjAgU1VDQ0VTUwoKQmlzZWN0
aW5nOiAwIHJldmlzaW9ucyBsZWZ0IHRvIHRlc3QgYWZ0ZXIgdGhpcyAocm91Z2hseSAxIHN0
ZXApCltkZDNlMmM1NWE0NWZlNzVmMzIxM2IxN2I3NGY5YTMyMzgwZjRlODRiXSBmdXNlOiBy
Y3UtZGVsYXkgZnJlZWluZyBmdXNlX2Nvbm4KcnVubmluZyAvYy9rZXJuZWwtdGVzdHMvYmlz
ZWN0LXRlc3QtYm9vdC1mYWlsdXJlLnNoIC9ob21lL3dmZy91c2Ivb2JqLWJpc2VjdApscyAt
YSAva2VybmVsLXRlc3RzL3J1bi1xdWV1ZS9rdm0vaTM4Ni1yYW5kY29uZmlnLXIzLTExMDcv
bGludXgtZGV2ZWw6ZGV2ZWwtcm9hbS1pMzg2LTIwMTMxMTA3MjM0NzpkZDNlMmM1NWE0NWZl
NzVmMzIxM2IxN2I3NGY5YTMyMzgwZjRlODRiOmJpc2VjdC11c2IKCjIwMTMtMTEtMDgtMTI6
NDM6MDggZGQzZTJjNTVhNDVmZTc1ZjMyMTNiMTdiNzRmOWEzMjM4MGY0ZTg0YiBjb21waWxp
bmcKMjI3IHJlYWwgIDUwMiB1c2VyICA0OSBzeXMgIDI0Mi40MiUgY3B1IAlpMzg2LXJhbmRj
b25maWctcjMtMTEwNwoKMjAxMy0xMS0wOC0xMjo0ODo0NiBkZXRlY3RpbmcgYm9vdCBzdGF0
ZSAzLjEyLjAtcmM0LTAwMDQ0LWdkZDNlMmM1Li4JMgkxMQkyMCBTVUNDRVNTCgo4NDU1MGI5
MzU2YWY1MGM3Y2JkNmI2Y2U2ZThmZDA2NTg1ZWViZjE0IGlzIHRoZSBmaXJzdCBiYWQgY29t
bWl0CmNvbW1pdCA4NDU1MGI5MzU2YWY1MGM3Y2JkNmI2Y2U2ZThmZDA2NTg1ZWViZjE0CkF1
dGhvcjogQWwgVmlybyA8dmlyb0B6ZW5pdi5saW51eC5vcmcudWs+CkRhdGU6ICAgU3VuIFNl
cCAyOSAyMjowNjowNyAyMDEzIC0wNDAwCgogICAgUkNVJ2QgdmZzbW91bnRzCiAgICAKICAg
IF92ZXJ5XyBwcmVsaW1pbmFyeSwgYmFyZWx5IHRlc3RlZC4KICAgIAogICAgU2lnbmVkLW9m
Zi1ieTogQWwgVmlybyA8dmlyb0B6ZW5pdi5saW51eC5vcmcudWs+Cgo6MDQwMDAwIDA0MDAw
MCA3YjAyMmNjOThlNTAzYTZhM2IwMjJhNGQ0Y2FkMWRjZTg3NTBhOTE1IGIyNTI3N2UyZGJi
ZGIzOWZlMzBhNGE1Y2Q0YTlkZTdiZDUxOTIxZTkgTQlmcwo6MDQwMDAwIDA0MDAwMCBmMjgw
YzljM2Y2ZjI0NjMwZjc0NjliM2Y2MDBiYjRjNDJlZTNiMzc4IDBlMWJkZTVjOTdjZTU2ODUw
MGRlNTQ2MDViMWYzMjE1Yjg4ZjA1NDkgTQlpbmNsdWRlCmJpc2VjdCBydW4gc3VjY2Vzcwps
cyAtYSAva2VybmVsLXRlc3RzL3J1bi1xdWV1ZS9rdm0vaTM4Ni1yYW5kY29uZmlnLXIzLTEx
MDcvbGludXgtZGV2ZWw6ZGV2ZWwtcm9hbS1pMzg2LTIwMTMxMTA3MjM0NzpkZDNlMmM1NWE0
NWZlNzVmMzIxM2IxN2I3NGY5YTMyMzgwZjRlODRiOmJpc2VjdC11c2IKCjIwMTMtMTEtMDgt
MTI6NTE6MTcgZGQzZTJjNTVhNDVmZTc1ZjMyMTNiMTdiNzRmOWEzMjM4MGY0ZTg0YiByZXVz
ZSAva2VybmVsL2kzODYtcmFuZGNvbmZpZy1yMy0xMTA3L2RkM2UyYzU1YTQ1ZmU3NWYzMjEz
YjE3Yjc0ZjlhMzIzODBmNGU4NGIvdm1saW51ei0zLjEyLjAtcmM0LTAwMDQ0LWdkZDNlMmM1
CgoyMDEzLTExLTA4LTEyOjUxOjE3IGRldGVjdGluZyBib290IHN0YXRlIC4uCTI5CTQ1CTU1
CTU5CTYwIFNVQ0NFU1MKCmxzIC1hIC9rZXJuZWwtdGVzdHMvcnVuLXF1ZXVlL2t2bS9pMzg2
LXJhbmRjb25maWctcjMtMTEwNy9saW51eC1kZXZlbDpkZXZlbC1yb2FtLWkzODYtMjAxMzEx
MDcyMzQ3OjMyYTQ0MGIzOGMyYjZmMmY5MjdiOGUyOTRlNDg3N2ZlNTA1Zjk2NTM6YmlzZWN0
LXVzYgogVEVTVCBGQUlMVVJFClsgICA2Mi45NzE0MjJdIGluaXQ6IGh3Y2xvY2stc2F2ZSBt
YWluIHByb2Nlc3MgKDI0NTYpIHRlcm1pbmF0ZWQgd2l0aCBzdGF0dXMgNzAKWyAgIDYyLjk3
NjI5OV0gaW5pdDogcGx5bW91dGgtdXBzdGFydC1icmlkZ2UgbWFpbiBwcm9jZXNzICgyNDU3
KSB0ZXJtaW5hdGVkIHdpdGggc3RhdHVzIDEKWyAgIDYzLjQxNjI4Ml0gLS0tLS0tLS0tLS0t
WyBjdXQgaGVyZSBdLS0tLS0tLS0tLS0tClsgICA2My40MjExMzBdIFdBUk5JTkc6IENQVTog
MCBQSUQ6IDI1NDkgYXQgZnMvZGNhY2hlLmM6Mzg1IGRfbHJ1X2RlbCsweDE1Zi8weDE5MCgp
ClsgICA2My40MjY0MDBdIE1vZHVsZXMgbGlua2VkIGluOgpbICAgNjMuNDMwNTM2XSBDUFU6
IDAgUElEOiAyNTQ5IENvbW06IHVtb3VudCBOb3QgdGFpbnRlZCAzLjEyLjAtMDA2NDktZzMy
YTQ0MGIgIzg5ClsgICA2My40MzUzOTNdIEhhcmR3YXJlIG5hbWU6IEJvY2hzIEJvY2hzLCBC
SU9TIEJvY2hzIDAxLzAxLzIwMTEKWyAgIDYzLjQ0MDA0NF0gIGZmZmZmZmZmIGNmMGJiZTE0
IGMxYzA1NTM5IDAwMDAwMDAwIDAwMDAwMDAwIDAwMDAwMTgxIGNmMGJiZTQ0IGMxMDY0MzA2
ClsgICA2My40NDUzMjhdICBjMWVjNDQ3YyAwMDAwMDAwMCAwMDAwMDlmNSBjMWVkNjE1OCAw
MDAwMDE4MSBjMTFkMjIxZiBjMTFkMjIxZiAwMDAwMDAwMQpbICAgNjMuNDUwNjc2XSAgYzkx
NjVjMDAgMDAwMDAwMDEgY2YwYmJlNTQgYzEwNjQzYzIgMDAwMDAwMDkgMDAwMDAwMDAgY2Yw
YmJlNjggYzExZDIyMWYKWyAgIDYzLjQ1NjA3NV0gQ2FsbCBUcmFjZToKWyAgIDYzLjQ2MDQz
NV0gIFs8YzFjMDU1Mzk+XSBkdW1wX3N0YWNrKzB4N2QvMHhiMApbICAgNjMuNDY1MTU0XSAg
WzxjMTA2NDMwNj5dIHdhcm5fc2xvd3BhdGhfY29tbW9uKzB4OTYvMHhiMApbICAgNjMuNDcw
MDE5XSAgWzxjMTFkMjIxZj5dID8gZF9scnVfZGVsKzB4MTVmLzB4MTkwClsgICA2My40NzQ4
MjFdICBbPGMxMWQyMjFmPl0gPyBkX2xydV9kZWwrMHgxNWYvMHgxOTAKWyAgIDYzLjQ3OTYw
Ml0gIFs8YzEwNjQzYzI+XSB3YXJuX3Nsb3dwYXRoX251bGwrMHgyMi8weDMwClsgICA2My40
ODQ0NzVdICBbPGMxMWQyMjFmPl0gZF9scnVfZGVsKzB4MTVmLzB4MTkwClsgICA2My40ODky
NzZdICBbPGMxMWQyN2ZmPl0gdW1vdW50X2NvbGxlY3QrMHgxNGYvMHgxOTAKWyAgIDYzLjQ5
NDE1NV0gIFs8YzFjMTM5YTI+XSA/IF9yYXdfc3Bpbl9sb2NrKzB4NDIvMHhiMApbICAgNjMu
NDk5MDM5XSAgWzxjMTFkMzg0Nz5dIGRfd2FsaysweGM3LzB4M2QwClsgICA2My41MDM3NzNd
ICBbPGMxMWQyNmIwPl0gPyBkZW50cnlfbHJ1X2RlbCsweDcwLzB4NzAKWyAgIDYzLjUwODY0
N10gIFs8YzExZDVkOGI+XSBzaHJpbmtfZGNhY2hlX2Zvcl91bW91bnQrMHg4Yi8weDE1MApb
ICAgNjMuNTEzNjMwXSAgWzxjMTFiNDQ3Nz5dIGdlbmVyaWNfc2h1dGRvd25fc3VwZXIrMHhj
Ny8weDFhMApbICAgNjMuNTE4NTUzXSAgWzxjMTFiNDgwYT5dIGtpbGxfbGl0dGVyX3N1cGVy
KzB4M2EvMHg1MApbICAgNjMuNTIzNDEwXSAgWzxjMTFiNGE5NT5dIGRlYWN0aXZhdGVfbG9j
a2VkX3N1cGVyKzB4NDUvMHg3MApbICAgNjMuNTI4Mzc3XSAgWzxjMTFiNWUxNj5dIGRlYWN0
aXZhdGVfc3VwZXIrMHg5Ni8weGIwClsgICA2My41MzMyNzBdICBbPGMxMWRmNmU2Pl0gbW50
cHV0X25vX2V4cGlyZSsweDFkNi8weDIwMApbICAgNjMuNTM4MTkxXSAgWzxjMTFlMGQ0MT5d
IFN5U191bW91bnQrMHgxMjEvMHg1ZTAKWyAgIDYzLjU0MzA1Ml0gIFs8YzFjMWRjZDk+XSBz
eXNlbnRlcl9kb19jYWxsKzB4MTIvMHgyZApbICAgNjMuNTQ3OTI5XSAtLS1bIGVuZCB0cmFj
ZSBiMzUyMjc4YmI0MWU3OGRjIF0tLS0KWyAgIDYzLjU1MjcxOF0gLS0tLS0tLS0tLS0tWyBj
dXQgaGVyZSBdLS0tLS0tLS0tLS0tCi9rZXJuZWwvaTM4Ni1yYW5kY29uZmlnLXIzLTExMDcv
MzJhNDQwYjM4YzJiNmYyZjkyN2I4ZTI5NGU0ODc3ZmU1MDVmOTY1My9kbWVzZy15b2N0by1s
a3Atc3QwMS02OjIwMTMxMTA4MDc1OTEwOmkzODYtcmFuZGNvbmZpZy1yMy0xMTA3OjMuMTIu
MC0wMDY0OS1nMzJhNDQwYjo4OQova2VybmVsL2kzODYtcmFuZGNvbmZpZy1yMy0xMTA3LzMy
YTQ0MGIzOGMyYjZmMmY5MjdiOGUyOTRlNDg3N2ZlNTA1Zjk2NTMvZG1lc2ctcXVhbnRhbC1s
a3AtdHQwMi03OjIwMTMxMTA4MDExMzA2OmkzODYtcmFuZGNvbmZpZy1yMy0xMTA3OjMuMTIu
MC0wMDY0OS1nMzJhNDQwYjo4OQova2VybmVsL2kzODYtcmFuZGNvbmZpZy1yMy0xMTA3LzMy
YTQ0MGIzOGMyYjZmMmY5MjdiOGUyOTRlNDg3N2ZlNTA1Zjk2NTMvZG1lc2ctcXVhbnRhbC14
aWFuLTIwOjIwMTMxMTA4MDAwNTUyOmkzODYtcmFuZGNvbmZpZy1yMy0xMTA3OjMuMTIuMC0w
MDY0OS1nMzJhNDQwYjo4OQova2VybmVsL2kzODYtcmFuZGNvbmZpZy1yMy0xMTA3LzMyYTQ0
MGIzOGMyYjZmMmY5MjdiOGUyOTRlNDg3N2ZlNTA1Zjk2NTMvZG1lc2ctcXVhbnRhbC13YWlt
ZWEtMTE6MjAxMzExMDgxODIwMDc6aTM4Ni1yYW5kY29uZmlnLXIzLTExMDc6My4xMi4wLTAw
NjQ5LWczMmE0NDBiOjg5Ci9rZXJuZWwvaTM4Ni1yYW5kY29uZmlnLXIzLTExMDcvMzJhNDQw
YjM4YzJiNmYyZjkyN2I4ZTI5NGU0ODc3ZmU1MDVmOTY1My9kbWVzZy15b2N0by13YWltZWEt
MTU6MjAxMzExMDgxODIwMTM6aTM4Ni1yYW5kY29uZmlnLXIzLTExMDc6My4xMi4wLTAwNjQ5
LWczMmE0NDBiOjg5Ci9rZXJuZWwvaTM4Ni1yYW5kY29uZmlnLXIzLTExMDcvMzJhNDQwYjM4
YzJiNmYyZjkyN2I4ZTI5NGU0ODc3ZmU1MDVmOTY1My9kbWVzZy1xdWFudGFsLXhwcy00OjIw
MTMxMTA4MDgwNDU0OmkzODYtcmFuZGNvbmZpZy1yMy0xMTA3OjMuMTIuMC0wMDY0OS1nMzJh
NDQwYjo4OQova2VybmVsL2kzODYtcmFuZGNvbmZpZy1yMy0xMTA3LzMyYTQ0MGIzOGMyYjZm
MmY5MjdiOGUyOTRlNDg3N2ZlNTA1Zjk2NTMvZG1lc2cteW9jdG8teHBzLTI6MjAxMzExMDgw
ODAxNDE6aTM4Ni1yYW5kY29uZmlnLXIzLTExMDc6My4xMi4wLTAwNjQ5LWczMmE0NDBiOjg5
Ci9rZXJuZWwvaTM4Ni1yYW5kY29uZmlnLXIzLTExMDcvMzJhNDQwYjM4YzJiNmYyZjkyN2I4
ZTI5NGU0ODc3ZmU1MDVmOTY1My9kbWVzZy15b2N0by1zbmItMjM6MjAxMzExMDgxMDIyMzg6
aTM4Ni1yYW5kY29uZmlnLXIzLTExMDc6My4xMi4wLTAwNjQ5LWczMmE0NDBiOjg5Ci9rZXJu
ZWwvaTM4Ni1yYW5kY29uZmlnLXIzLTExMDcvMzJhNDQwYjM4YzJiNmYyZjkyN2I4ZTI5NGU0
ODc3ZmU1MDVmOTY1My9kbWVzZy15b2N0by1yb2FtLTI6MjAxMzExMDgxMDIyMzQ6aTM4Ni1y
YW5kY29uZmlnLXIzLTExMDc6My4xMi4wLTAwNjQ5LWczMmE0NDBiOjg5Ci9rZXJuZWwvaTM4
Ni1yYW5kY29uZmlnLXIzLTExMDcvMzJhNDQwYjM4YzJiNmYyZjkyN2I4ZTI5NGU0ODc3ZmU1
MDVmOTY1My9kbWVzZy15b2N0by13YWltZWEtMTE6MjAxMzExMDgwODAwMDQ6aTM4Ni1yYW5k
Y29uZmlnLXIzLTExMDc6My4xMi4wLTAwNjQ5LWczMmE0NDBiOjg5Ci9rZXJuZWwvaTM4Ni1y
YW5kY29uZmlnLXIzLTExMDcvMzJhNDQwYjM4YzJiNmYyZjkyN2I4ZTI5NGU0ODc3ZmU1MDVm
OTY1My9kbWVzZy1xdWFudGFsLWlubi0zNToyMDEzMTEwODEwMjIyNTppMzg2LXJhbmRjb25m
aWctcjMtMTEwNzozLjEyLjAtMDA2NDktZzMyYTQ0MGI6ODkKL2tlcm5lbC9pMzg2LXJhbmRj
b25maWctcjMtMTEwNy8zMmE0NDBiMzhjMmI2ZjJmOTI3YjhlMjk0ZTQ4NzdmZTUwNWY5NjUz
L2RtZXNnLXF1YW50YWwtcm9hbS0xMzoyMDEzMTEwODEwMjIzMDppMzg2LXJhbmRjb25maWct
cjMtMTEwNzozLjEyLjAtMDA2NDktZzMyYTQ0MGI6ODkKL2tlcm5lbC9pMzg2LXJhbmRjb25m
aWctcjMtMTEwNy8zMmE0NDBiMzhjMmI2ZjJmOTI3YjhlMjk0ZTQ4NzdmZTUwNWY5NjUzL2Rt
ZXNnLXlvY3RvLXNuYi0zMjoyMDEzMTEwODEwMjIzMzppMzg2LXJhbmRjb25maWctcjMtMTEw
NzozLjEyLjAtMDA2NDktZzMyYTQ0MGI6ODkKL2tlcm5lbC9pMzg2LXJhbmRjb25maWctcjMt
MTEwNy8zMmE0NDBiMzhjMmI2ZjJmOTI3YjhlMjk0ZTQ4NzdmZTUwNWY5NjUzL2RtZXNnLXlv
Y3RvLWxrcC1zdDAxLTEyOjIwMTMxMTA4MDgwMDM2OmkzODYtcmFuZGNvbmZpZy1yMy0xMTA3
OjMuMTIuMC0wMDY0OS1nMzJhNDQwYjo4OQova2VybmVsL2kzODYtcmFuZGNvbmZpZy1yMy0x
MTA3LzMyYTQ0MGIzOGMyYjZmMmY5MjdiOGUyOTRlNDg3N2ZlNTA1Zjk2NTMvZG1lc2ctcXVh
bnRhbC1pbm4tMToyMDEzMTEwODEwMjIyNzppMzg2LXJhbmRjb25maWctcjMtMTEwNzozLjEy
LjAtMDA2NDktZzMyYTQ0MGI6ODkKL2tlcm5lbC9pMzg2LXJhbmRjb25maWctcjMtMTEwNy8z
MmE0NDBiMzhjMmI2ZjJmOTI3YjhlMjk0ZTQ4NzdmZTUwNWY5NjUzL2RtZXNnLXF1YW50YWwt
YmVucy00OjIwMTMxMTA4MDAwNjIwOmkzODYtcmFuZGNvbmZpZy1yMy0xMTA3OjMuMTIuMC0w
MDY0OS1nMzJhNDQwYjo4OQova2VybmVsL2kzODYtcmFuZGNvbmZpZy1yMy0xMTA3LzMyYTQ0
MGIzOGMyYjZmMmY5MjdiOGUyOTRlNDg3N2ZlNTA1Zjk2NTMvZG1lc2cteW9jdG8tbGtwLXN0
MDEtMTE6MjAxMzExMDgxODE4NDc6aTM4Ni1yYW5kY29uZmlnLXIzLTExMDc6My4xMi4wLTAw
NjQ5LWczMmE0NDBiOjg5Ci9rZXJuZWwvaTM4Ni1yYW5kY29uZmlnLXIzLTExMDcvMzJhNDQw
YjM4YzJiNmYyZjkyN2I4ZTI5NGU0ODc3ZmU1MDVmOTY1My9kbWVzZy1xdWFudGFsLXhpYW4t
MzI6MjAxMzExMDgwMDA2NTE6aTM4Ni1yYW5kY29uZmlnLXIzLTExMDc6My4xMi4wLTAwNjQ5
LWczMmE0NDBiOjg5Ci9rZXJuZWwvaTM4Ni1yYW5kY29uZmlnLXIzLTExMDcvMzJhNDQwYjM4
YzJiNmYyZjkyN2I4ZTI5NGU0ODc3ZmU1MDVmOTY1My9kbWVzZy1xdWFudGFsLXN0b2FrbGV5
LTM6MjAxMzExMDgwMDAzNTg6aTM4Ni1yYW5kY29uZmlnLXIzLTExMDc6My4xMi4wLTAwNjQ5
LWczMmE0NDBiOjg5CjA6MTk6MTkgYWxsX2dvb2Q6YmFkOmFsbF9iYWQgYm9vdHMKCltkZXRh
Y2hlZCBIRUFEIDUxZjdhYTVdIFJldmVydCAiUkNVJ2QgdmZzbW91bnRzIgogNiBmaWxlcyBj
aGFuZ2VkLCAyMTUgaW5zZXJ0aW9ucygrKSwgMjMxIGRlbGV0aW9ucygtKQpscyAtYSAva2Vy
bmVsLXRlc3RzL3J1bi1xdWV1ZS9rdm0vaTM4Ni1yYW5kY29uZmlnLXIzLTExMDcvbGludXgt
ZGV2ZWw6ZGV2ZWwtcm9hbS1pMzg2LTIwMTMxMTA3MjM0Nzo1MWY3YWE1YjBlYWZhMzc2MzNk
ODAzYjgxMzMxMzJjYjJjYzRlNDg3OmJpc2VjdC11c2IKCjIwMTMtMTEtMDgtMTI6NTQ6NTYg
NTFmN2FhNWIwZWFmYTM3NjMzZDgwM2I4MTMzMTMyY2IyY2M0ZTQ4NyBjb21waWxpbmcKMjAx
My0xMS0wOC0xMzowNDozNyA1MWY3YWE1YjBlYWZhMzc2MzNkODAzYjgxMzMxMzJjYjJjYzRl
NDg3IFNLSVAgQlJPS0VOIEJVSUxECkNoZWNrIGVycm9zIGluIC9jYy93ZmcvdXNiLWJpc2Vj
dCBhbmQgL3RtcC9rZXJuZWwvaTM4Ni1yYW5kY29uZmlnLXIzLTExMDcvNTFmN2FhNWIwZWFm
YTM3NjMzZDgwM2I4MTMzMTMyY2IyY2M0ZTQ4NwoKPT09PT09PT09IHVwc3RyZWFtID09PT09
PT09PQpGZXRjaGluZyBsaW51cwpscyAtYSAva2VybmVsLXRlc3RzL3J1bi1xdWV1ZS9rdm0v
aTM4Ni1yYW5kY29uZmlnLXIzLTExMDcvbGludXgtZGV2ZWw6ZGV2ZWwtcm9hbS1pMzg2LTIw
MTMxMTA3MjM0Nzo2Yzg2YWUyOTI4ZjllNGNiZjBkNTg0NGY1ZmNmZDU0OWUzNDUwYjhjOmJp
c2VjdC11c2IKCjIwMTMtMTEtMDgtMTM6MDQ6NDAgNmM4NmFlMjkyOGY5ZTRjYmYwZDU4NDRm
NWZjZmQ1NDllMzQ1MGI4YyBjb21waWxpbmcKCjIwMTMtMTEtMDgtMTM6MTM6MDggZGV0ZWN0
aW5nIGJvb3Qgc3RhdGUgMy4xMi4wLTAxOTE1LWc2Yzg2YWUyLi4uCTEJMgk2CTE0LgkyMQky
NAkyNwkyOAkzMC4uCTMxLgkzMwkzNgk0Mwk1MAk1MS4uCTUyCTU1Li4uLgk2MCBTVUNDRVNT
CgoKPT09PT09PT09IGxpbnV4LW5leHQgPT09PT09PT09CkZldGNoaW5nIG5leHQKbHMgLWEg
L2tlcm5lbC10ZXN0cy9ydW4tcXVldWUva3ZtL2kzODYtcmFuZGNvbmZpZy1yMy0xMTA3L2xp
bnV4LWRldmVsOmRldmVsLXJvYW0taTM4Ni0yMDEzMTEwNzIzNDc6NDhkYTFhMjlmNTg4M2Vm
OWQxNGM2YjgyOGU0NjlkODZiNGZjMDk4MDpiaXNlY3QtdXNiCgoyMDEzLTExLTA4LTEzOjI4
OjQzIDQ4ZGExYTI5ZjU4ODNlZjlkMTRjNmI4MjhlNDY5ZDg2YjRmYzA5ODAgY29tcGlsaW5n
CjIwMTMtMTEtMDgtMTM6MzY6NDcgNDhkYTFhMjlmNTg4M2VmOWQxNGM2YjgyOGU0NjlkODZi
NGZjMDk4MCBTS0lQIEJST0tFTiBCVUlMRApDaGVjayBlcnJvcyBpbiAvY2Mvd2ZnL3VzYi1i
aXNlY3QgYW5kIC90bXAva2VybmVsL2kzODYtcmFuZGNvbmZpZy1yMy0xMTA3LzQ4ZGExYTI5
ZjU4ODNlZjlkMTRjNmI4MjhlNDY5ZDg2YjRmYzA5ODAK

--vkogqOf2sHV7VnPd
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="config-3.12.0-00649-g32a440b"

#
# Automatically generated file; DO NOT EDIT.
# Linux/i386 3.12.0 Kernel Configuration
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
CONFIG_NEED_DMA_MAP_STATE=y
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
CONFIG_ARCH_HWEIGHT_CFLAGS="-fcall-saved-ecx -fcall-saved-edx"
CONFIG_ARCH_CPU_PROBE_RELEASE=y
CONFIG_ARCH_SUPPORTS_UPROBES=y
CONFIG_DEFCONFIG_LIST="/lib/modules/$UNAME_RELEASE/.config"
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
# CONFIG_SWAP is not set
# CONFIG_SYSVIPC is not set
# CONFIG_POSIX_MQUEUE is not set
# CONFIG_FHANDLE is not set
CONFIG_AUDIT=y
CONFIG_AUDITSYSCALL=y
CONFIG_AUDIT_WATCH=y
CONFIG_AUDIT_TREE=y
CONFIG_AUDIT_LOGINUID_IMMUTABLE=y

#
# IRQ subsystem
#
CONFIG_GENERIC_IRQ_PROBE=y
CONFIG_GENERIC_IRQ_SHOW=y
CONFIG_GENERIC_PENDING_IRQ=y
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
CONFIG_HZ_PERIODIC=y
# CONFIG_NO_HZ_IDLE is not set
CONFIG_NO_HZ=y
# CONFIG_HIGH_RES_TIMERS is not set

#
# CPU/Task time and stats accounting
#
CONFIG_TICK_CPU_ACCOUNTING=y
# CONFIG_IRQ_TIME_ACCOUNTING is not set
CONFIG_BSD_PROCESS_ACCT=y
# CONFIG_BSD_PROCESS_ACCT_V3 is not set
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
# CONFIG_TREE_RCU_TRACE is not set
CONFIG_RCU_NOCB_CPU=y
# CONFIG_RCU_NOCB_CPU_NONE is not set
CONFIG_RCU_NOCB_CPU_ZERO=y
# CONFIG_RCU_NOCB_CPU_ALL is not set
CONFIG_IKCONFIG=y
# CONFIG_IKCONFIG_PROC is not set
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
# CONFIG_RESOURCE_COUNTERS is not set
CONFIG_CGROUP_PERF=y
CONFIG_CGROUP_SCHED=y
CONFIG_FAIR_GROUP_SCHED=y
CONFIG_CFS_BANDWIDTH=y
# CONFIG_RT_GROUP_SCHED is not set
CONFIG_BLK_CGROUP=y
# CONFIG_DEBUG_BLK_CGROUP is not set
# CONFIG_CHECKPOINT_RESTORE is not set
CONFIG_NAMESPACES=y
# CONFIG_UTS_NS is not set
# CONFIG_USER_NS is not set
CONFIG_PID_NS=y
CONFIG_NET_NS=y
CONFIG_UIDGID_STRICT_TYPE_CHECKS=y
CONFIG_SCHED_AUTOGROUP=y
# CONFIG_SYSFS_DEPRECATED is not set
CONFIG_RELAY=y
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
# CONFIG_KALLSYMS_ALL is not set
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

#
# Kernel Performance Events And Counters
#
CONFIG_PERF_EVENTS=y
# CONFIG_DEBUG_PERF_USE_VMALLOC is not set
CONFIG_VM_EVENT_COUNTERS=y
CONFIG_SLUB_DEBUG=y
CONFIG_COMPAT_BRK=y
# CONFIG_SLAB is not set
CONFIG_SLUB=y
# CONFIG_SLUB_CPU_PARTIAL is not set
# CONFIG_PROFILING is not set
CONFIG_TRACEPOINTS=y
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
CONFIG_HAVE_IOREMAP_PROT=y
CONFIG_HAVE_KPROBES=y
CONFIG_HAVE_KRETPROBES=y
CONFIG_HAVE_OPTPROBES=y
CONFIG_HAVE_KPROBES_ON_FTRACE=y
CONFIG_HAVE_ARCH_TRACEHOOK=y
CONFIG_HAVE_DMA_ATTRS=y
CONFIG_HAVE_DMA_CONTIGUOUS=y
CONFIG_USE_GENERIC_SMP_HELPERS=y
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
CONFIG_MODULES=y
CONFIG_MODULE_FORCE_LOAD=y
CONFIG_MODULE_UNLOAD=y
CONFIG_MODULE_FORCE_UNLOAD=y
CONFIG_MODVERSIONS=y
CONFIG_MODULE_SRCVERSION_ALL=y
# CONFIG_MODULE_SIG is not set
CONFIG_STOP_MACHINE=y
CONFIG_BLOCK=y
# CONFIG_LBDAF is not set
CONFIG_BLK_DEV_BSG=y
CONFIG_BLK_DEV_BSGLIB=y
CONFIG_BLK_DEV_INTEGRITY=y
CONFIG_BLK_DEV_THROTTLING=y
CONFIG_BLK_CMDLINE_PARSER=y

#
# Partition Types
#
# CONFIG_PARTITION_ADVANCED is not set
CONFIG_AMIGA_PARTITION=y
CONFIG_MSDOS_PARTITION=y
CONFIG_EFI_PARTITION=y

#
# IO Schedulers
#
CONFIG_IOSCHED_NOOP=y
CONFIG_IOSCHED_DEADLINE=y
CONFIG_IOSCHED_CFQ=m
CONFIG_CFQ_GROUP_IOSCHED=y
CONFIG_DEFAULT_DEADLINE=y
# CONFIG_DEFAULT_NOOP is not set
CONFIG_DEFAULT_IOSCHED="deadline"
CONFIG_PADATA=y
CONFIG_INLINE_SPIN_UNLOCK_IRQ=y
CONFIG_INLINE_READ_UNLOCK=y
CONFIG_INLINE_READ_UNLOCK_IRQ=y
CONFIG_INLINE_WRITE_UNLOCK=y
CONFIG_INLINE_WRITE_UNLOCK_IRQ=y
CONFIG_MUTEX_SPIN_ON_OWNER=y
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
CONFIG_X86_SUPPORTS_MEMORY_FAILURE=y
CONFIG_X86_32_IRIS=m
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
CONFIG_PARAVIRT_TIME_ACCOUNTING=y
CONFIG_PARAVIRT_CLOCK=y
CONFIG_NO_BOOTMEM=y
# CONFIG_MEMTEST is not set
# CONFIG_M486 is not set
# CONFIG_M586 is not set
CONFIG_M586TSC=y
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
CONFIG_X86_GENERIC=y
CONFIG_X86_INTERNODE_CACHE_SHIFT=6
CONFIG_X86_L1_CACHE_SHIFT=6
CONFIG_X86_PPRO_FENCE=y
CONFIG_X86_F00F_BUG=y
CONFIG_X86_ALIGNMENT_16=y
CONFIG_X86_INTEL_USERCOPY=y
CONFIG_X86_TSC=y
CONFIG_X86_CMPXCHG64=y
CONFIG_X86_MINIMUM_CPU_FAMILY=5
CONFIG_CPU_SUP_INTEL=y
CONFIG_CPU_SUP_CYRIX_32=y
CONFIG_CPU_SUP_AMD=y
CONFIG_CPU_SUP_CENTAUR=y
CONFIG_CPU_SUP_TRANSMETA_32=y
CONFIG_HPET_TIMER=y
CONFIG_HPET_EMULATE_RTC=y
CONFIG_DMI=y
CONFIG_NR_CPUS=8
# CONFIG_SCHED_SMT is not set
# CONFIG_SCHED_MC is not set
CONFIG_PREEMPT_NONE=y
# CONFIG_PREEMPT_VOLUNTARY is not set
# CONFIG_PREEMPT is not set
CONFIG_PREEMPT_COUNT=y
CONFIG_X86_LOCAL_APIC=y
CONFIG_X86_IO_APIC=y
# CONFIG_X86_REROUTE_FOR_BROKEN_BOOT_IRQS is not set
CONFIG_X86_MCE=y
# CONFIG_X86_MCE_INTEL is not set
# CONFIG_X86_MCE_AMD is not set
# CONFIG_X86_ANCIENT_MCE is not set
CONFIG_X86_MCE_INJECT=m
CONFIG_VM86=y
CONFIG_TOSHIBA=m
CONFIG_I8K=y
CONFIG_X86_REBOOTFIXUPS=y
CONFIG_MICROCODE=y
CONFIG_MICROCODE_INTEL=y
CONFIG_MICROCODE_AMD=y
CONFIG_MICROCODE_OLD_INTERFACE=y
CONFIG_MICROCODE_INTEL_LIB=y
CONFIG_MICROCODE_INTEL_EARLY=y
CONFIG_MICROCODE_AMD_EARLY=y
CONFIG_MICROCODE_EARLY=y
CONFIG_X86_MSR=y
# CONFIG_X86_CPUID is not set
# CONFIG_NOHIGHMEM is not set
# CONFIG_HIGHMEM4G is not set
CONFIG_HIGHMEM64G=y
CONFIG_PAGE_OFFSET=0xC0000000
CONFIG_HIGHMEM=y
CONFIG_X86_PAE=y
CONFIG_ARCH_PHYS_ADDR_T_64BIT=y
CONFIG_ARCH_DMA_ADDR_T_64BIT=y
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
CONFIG_COMPACTION=y
CONFIG_MIGRATION=y
CONFIG_PHYS_ADDR_T_64BIT=y
CONFIG_ZONE_DMA_FLAG=1
# CONFIG_BOUNCE is not set
CONFIG_NEED_BOUNCE_POOL=y
CONFIG_VIRT_TO_BUS=y
CONFIG_KSM=y
CONFIG_DEFAULT_MMAP_MIN_ADDR=4096
CONFIG_ARCH_SUPPORTS_MEMORY_FAILURE=y
CONFIG_MEMORY_FAILURE=y
# CONFIG_HWPOISON_INJECT is not set
CONFIG_TRANSPARENT_HUGEPAGE=y
CONFIG_TRANSPARENT_HUGEPAGE_ALWAYS=y
# CONFIG_TRANSPARENT_HUGEPAGE_MADVISE is not set
CONFIG_CROSS_MEMORY_ATTACH=y
# CONFIG_CLEANCACHE is not set
# CONFIG_CMA is not set
# CONFIG_ZBUD is not set
# CONFIG_HIGHPTE is not set
CONFIG_X86_CHECK_BIOS_CORRUPTION=y
# CONFIG_X86_BOOTPARAM_MEMORY_CORRUPTION_CHECK is not set
CONFIG_X86_RESERVE_LOW=64
# CONFIG_MATH_EMULATION is not set
CONFIG_MTRR=y
CONFIG_MTRR_SANITIZER=y
CONFIG_MTRR_SANITIZER_ENABLE_DEFAULT=0
CONFIG_MTRR_SANITIZER_SPARE_REG_NR_DEFAULT=1
CONFIG_X86_PAT=y
CONFIG_ARCH_USES_PG_UNCACHED=y
CONFIG_ARCH_RANDOM=y
CONFIG_X86_SMAP=y
CONFIG_EFI=y
# CONFIG_EFI_STUB is not set
# CONFIG_SECCOMP is not set
CONFIG_CC_STACKPROTECTOR=y
# CONFIG_HZ_100 is not set
# CONFIG_HZ_250 is not set
CONFIG_HZ_300=y
# CONFIG_HZ_1000 is not set
CONFIG_HZ=300
# CONFIG_SCHED_HRTICK is not set
# CONFIG_KEXEC is not set
# CONFIG_CRASH_DUMP is not set
CONFIG_PHYSICAL_START=0x1000000
# CONFIG_RELOCATABLE is not set
CONFIG_PHYSICAL_ALIGN=0x1000000
CONFIG_HOTPLUG_CPU=y
CONFIG_BOOTPARAM_HOTPLUG_CPU0=y
# CONFIG_DEBUG_HOTPLUG_CPU0 is not set
CONFIG_COMPAT_VDSO=y
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
# CONFIG_PM_DEBUG is not set
# CONFIG_WQ_POWER_EFFICIENT_DEFAULT is not set
CONFIG_ACPI=y
CONFIG_ACPI_SLEEP=y
# CONFIG_ACPI_PROCFS is not set
# CONFIG_ACPI_PROCFS_POWER is not set
# CONFIG_ACPI_EC_DEBUGFS is not set
CONFIG_ACPI_AC=m
# CONFIG_ACPI_BATTERY is not set
CONFIG_ACPI_BUTTON=y
CONFIG_ACPI_VIDEO=y
CONFIG_ACPI_FAN=m
# CONFIG_ACPI_DOCK is not set
CONFIG_ACPI_PROCESSOR=y
CONFIG_ACPI_IPMI=m
CONFIG_ACPI_HOTPLUG_CPU=y
CONFIG_ACPI_PROCESSOR_AGGREGATOR=y
# CONFIG_ACPI_THERMAL is not set
# CONFIG_ACPI_CUSTOM_DSDT is not set
# CONFIG_ACPI_INITRD_TABLE_OVERRIDE is not set
CONFIG_ACPI_BLACKLIST_YEAR=0
CONFIG_ACPI_DEBUG=y
CONFIG_ACPI_PCI_SLOT=y
CONFIG_X86_PM_TIMER=y
CONFIG_ACPI_CONTAINER=y
CONFIG_ACPI_SBS=m
CONFIG_ACPI_HED=y
# CONFIG_ACPI_CUSTOM_METHOD is not set
# CONFIG_ACPI_BGRT is not set
CONFIG_ACPI_APEI=y
CONFIG_ACPI_APEI_GHES=y
# CONFIG_ACPI_APEI_MEMORY_FAILURE is not set
CONFIG_ACPI_APEI_EINJ=m
# CONFIG_ACPI_APEI_ERST_DEBUG is not set
CONFIG_SFI=y
CONFIG_X86_APM_BOOT=y
CONFIG_APM=y
CONFIG_APM_IGNORE_USER_SUSPEND=y
CONFIG_APM_DO_ENABLE=y
# CONFIG_APM_CPU_IDLE is not set
# CONFIG_APM_DISPLAY_BLANK is not set
CONFIG_APM_ALLOW_INTS=y

#
# CPU Frequency scaling
#
CONFIG_CPU_FREQ=y
CONFIG_CPU_FREQ_TABLE=y
CONFIG_CPU_FREQ_GOV_COMMON=y
CONFIG_CPU_FREQ_STAT=y
# CONFIG_CPU_FREQ_STAT_DETAILS is not set
# CONFIG_CPU_FREQ_DEFAULT_GOV_PERFORMANCE is not set
# CONFIG_CPU_FREQ_DEFAULT_GOV_USERSPACE is not set
# CONFIG_CPU_FREQ_DEFAULT_GOV_ONDEMAND is not set
CONFIG_CPU_FREQ_DEFAULT_GOV_CONSERVATIVE=y
CONFIG_CPU_FREQ_GOV_PERFORMANCE=y
CONFIG_CPU_FREQ_GOV_POWERSAVE=m
# CONFIG_CPU_FREQ_GOV_USERSPACE is not set
CONFIG_CPU_FREQ_GOV_ONDEMAND=y
CONFIG_CPU_FREQ_GOV_CONSERVATIVE=y

#
# x86 CPU frequency scaling drivers
#
CONFIG_X86_INTEL_PSTATE=y
CONFIG_X86_PCC_CPUFREQ=y
# CONFIG_X86_ACPI_CPUFREQ is not set
# CONFIG_X86_POWERNOW_K6 is not set
# CONFIG_X86_POWERNOW_K7 is not set
# CONFIG_X86_GX_SUSPMOD is not set
# CONFIG_X86_SPEEDSTEP_CENTRINO is not set
# CONFIG_X86_SPEEDSTEP_ICH is not set
# CONFIG_X86_SPEEDSTEP_SMI is not set
CONFIG_X86_P4_CLOCKMOD=m
CONFIG_X86_CPUFREQ_NFORCE2=y
# CONFIG_X86_LONGRUN is not set
# CONFIG_X86_LONGHAUL is not set
CONFIG_X86_E_POWERSAVER=m

#
# shared options
#
CONFIG_X86_SPEEDSTEP_LIB=m

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
CONFIG_PCI_REALLOC_ENABLE_AUTO=y
CONFIG_PCI_STUB=m
# CONFIG_HT_IRQ is not set
CONFIG_PCI_ATS=y
CONFIG_PCI_IOV=y
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
# CONFIG_SCx200HR_TIMER is not set
CONFIG_ALIX=y
CONFIG_NET5501=y
CONFIG_GEOS=y
CONFIG_AMD_NB=y
CONFIG_PCCARD=m
CONFIG_PCMCIA=m
# CONFIG_PCMCIA_LOAD_CIS is not set
CONFIG_CARDBUS=y

#
# PC-card bridges
#
CONFIG_YENTA=m
CONFIG_YENTA_O2=y
CONFIG_YENTA_RICOH=y
CONFIG_YENTA_TI=y
CONFIG_YENTA_ENE_TUNE=y
CONFIG_YENTA_TOSHIBA=y
CONFIG_PD6729=m
CONFIG_I82092=m
CONFIG_I82365=m
CONFIG_TCIC=m
CONFIG_PCMCIA_PROBE=y
CONFIG_PCCARD_NONSTATIC=y
CONFIG_HOTPLUG_PCI=y
CONFIG_HOTPLUG_PCI_ACPI=y
# CONFIG_HOTPLUG_PCI_ACPI_IBM is not set
# CONFIG_HOTPLUG_PCI_CPCI is not set
CONFIG_HOTPLUG_PCI_SHPC=y
CONFIG_RAPIDIO=y
CONFIG_RAPIDIO_DISC_TIMEOUT=30
CONFIG_RAPIDIO_ENABLE_RX_TX_PORTS=y
# CONFIG_RAPIDIO_DMA_ENGINE is not set
CONFIG_RAPIDIO_DEBUG=y
CONFIG_RAPIDIO_ENUM_BASIC=m

#
# RapidIO Switch drivers
#
CONFIG_RAPIDIO_TSI57X=y
# CONFIG_RAPIDIO_CPS_XX is not set
# CONFIG_RAPIDIO_TSI568 is not set
CONFIG_RAPIDIO_CPS_GEN2=y
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
# CONFIG_BINFMT_MISC is not set
CONFIG_COREDUMP=y
CONFIG_HAVE_ATOMIC_IOMAP=y
CONFIG_NET=y

#
# Networking options
#
CONFIG_PACKET=y
CONFIG_PACKET_DIAG=y
CONFIG_UNIX=y
CONFIG_UNIX_DIAG=y
CONFIG_XFRM=y
CONFIG_XFRM_ALGO=m
# CONFIG_XFRM_SUB_POLICY is not set
CONFIG_XFRM_MIGRATE=y
CONFIG_NET_KEY=m
# CONFIG_NET_KEY_MIGRATE is not set
# CONFIG_INET is not set
CONFIG_NETWORK_SECMARK=y
CONFIG_NETWORK_PHY_TIMESTAMPING=y
CONFIG_NETFILTER=y
# CONFIG_NETFILTER_DEBUG is not set
CONFIG_NETFILTER_ADVANCED=y
CONFIG_NETFILTER_XTABLES=y
CONFIG_BRIDGE_NF_EBTABLES=y
CONFIG_BRIDGE_EBT_BROUTE=y
CONFIG_BRIDGE_EBT_T_FILTER=y
CONFIG_BRIDGE_EBT_T_NAT=y
CONFIG_BRIDGE_EBT_802_3=y
# CONFIG_BRIDGE_EBT_AMONG is not set
CONFIG_BRIDGE_EBT_ARP=y
# CONFIG_BRIDGE_EBT_IP is not set
CONFIG_BRIDGE_EBT_LIMIT=m
CONFIG_BRIDGE_EBT_MARK=m
CONFIG_BRIDGE_EBT_PKTTYPE=y
CONFIG_BRIDGE_EBT_STP=y
CONFIG_BRIDGE_EBT_VLAN=m
# CONFIG_BRIDGE_EBT_DNAT is not set
CONFIG_BRIDGE_EBT_MARK_T=y
CONFIG_BRIDGE_EBT_REDIRECT=m
CONFIG_BRIDGE_EBT_SNAT=y
CONFIG_BRIDGE_EBT_LOG=m
CONFIG_BRIDGE_EBT_ULOG=y
CONFIG_BRIDGE_EBT_NFLOG=y
CONFIG_ATM=y
CONFIG_ATM_LANE=y
CONFIG_STP=y
CONFIG_GARP=m
CONFIG_BRIDGE=y
CONFIG_BRIDGE_VLAN_FILTERING=y
CONFIG_VLAN_8021Q=m
CONFIG_VLAN_8021Q_GVRP=y
# CONFIG_VLAN_8021Q_MVRP is not set
# CONFIG_DECNET is not set
CONFIG_LLC=y
# CONFIG_LLC2 is not set
CONFIG_IPX=y
CONFIG_IPX_INTERN=y
# CONFIG_ATALK is not set
CONFIG_X25=y
CONFIG_LAPB=m
CONFIG_PHONET=m
CONFIG_IEEE802154=m
# CONFIG_MAC802154 is not set
CONFIG_NET_SCHED=y

#
# Queueing/Scheduling
#
# CONFIG_NET_SCH_CBQ is not set
CONFIG_NET_SCH_HTB=y
# CONFIG_NET_SCH_HFSC is not set
CONFIG_NET_SCH_ATM=m
CONFIG_NET_SCH_PRIO=m
# CONFIG_NET_SCH_MULTIQ is not set
CONFIG_NET_SCH_RED=m
# CONFIG_NET_SCH_SFB is not set
CONFIG_NET_SCH_SFQ=m
CONFIG_NET_SCH_TEQL=y
CONFIG_NET_SCH_TBF=y
# CONFIG_NET_SCH_GRED is not set
CONFIG_NET_SCH_DSMARK=m
CONFIG_NET_SCH_NETEM=m
CONFIG_NET_SCH_DRR=y
CONFIG_NET_SCH_MQPRIO=m
CONFIG_NET_SCH_CHOKE=m
# CONFIG_NET_SCH_QFQ is not set
CONFIG_NET_SCH_CODEL=y
CONFIG_NET_SCH_FQ_CODEL=m
CONFIG_NET_SCH_FQ=y
CONFIG_NET_SCH_PLUG=m

#
# Classification
#
CONFIG_NET_CLS=y
CONFIG_NET_CLS_BASIC=y
CONFIG_NET_CLS_TCINDEX=y
CONFIG_NET_CLS_FW=y
# CONFIG_NET_CLS_U32 is not set
# CONFIG_NET_CLS_RSVP is not set
CONFIG_NET_CLS_RSVP6=y
# CONFIG_NET_CLS_FLOW is not set
CONFIG_NET_CLS_CGROUP=m
# CONFIG_NET_EMATCH is not set
# CONFIG_NET_CLS_ACT is not set
CONFIG_NET_CLS_IND=y
CONFIG_NET_SCH_FIFO=y
# CONFIG_DCB is not set
CONFIG_DNS_RESOLVER=m
CONFIG_BATMAN_ADV=m
CONFIG_BATMAN_ADV_NC=y
# CONFIG_BATMAN_ADV_DEBUG is not set
CONFIG_OPENVSWITCH=m
# CONFIG_VSOCKETS is not set
# CONFIG_NETLINK_MMAP is not set
CONFIG_NETLINK_DIAG=y
# CONFIG_NET_MPLS_GSO is not set
CONFIG_RPS=y
CONFIG_RFS_ACCEL=y
CONFIG_XPS=y
CONFIG_NETPRIO_CGROUP=m
CONFIG_NET_RX_BUSY_POLL=y
CONFIG_BQL=y
CONFIG_NET_FLOW_LIMIT=y

#
# Network testing
#
# CONFIG_HAMRADIO is not set
CONFIG_CAN=y
CONFIG_CAN_RAW=y
# CONFIG_CAN_BCM is not set
CONFIG_CAN_GW=m

#
# CAN Device Drivers
#
# CONFIG_CAN_VCAN is not set
CONFIG_CAN_SLCAN=y
CONFIG_CAN_DEV=y
CONFIG_CAN_CALC_BITTIMING=y
CONFIG_CAN_LEDS=y
# CONFIG_PCH_CAN is not set
CONFIG_CAN_SJA1000=y
CONFIG_CAN_SJA1000_ISA=y
# CONFIG_CAN_SJA1000_PLATFORM is not set
CONFIG_CAN_EMS_PCMCIA=m
CONFIG_CAN_EMS_PCI=m
CONFIG_CAN_PEAK_PCMCIA=m
CONFIG_CAN_PEAK_PCI=y
CONFIG_CAN_PEAK_PCIEC=y
CONFIG_CAN_KVASER_PCI=m
CONFIG_CAN_PLX_PCI=y
CONFIG_CAN_TSCAN1=y
CONFIG_CAN_C_CAN=y
CONFIG_CAN_C_CAN_PLATFORM=m
CONFIG_CAN_C_CAN_PCI=y
CONFIG_CAN_CC770=m
CONFIG_CAN_CC770_ISA=m
CONFIG_CAN_CC770_PLATFORM=m

#
# CAN USB interfaces
#
# CONFIG_CAN_EMS_USB is not set
CONFIG_CAN_ESD_USB2=m
# CONFIG_CAN_KVASER_USB is not set
CONFIG_CAN_PEAK_USB=m
CONFIG_CAN_8DEV_USB=m
# CONFIG_CAN_SOFTING is not set
# CONFIG_CAN_DEBUG_DEVICES is not set
CONFIG_IRDA=m

#
# IrDA protocols
#
CONFIG_IRLAN=m
CONFIG_IRCOMM=m
# CONFIG_IRDA_ULTRA is not set

#
# IrDA options
#
CONFIG_IRDA_CACHE_LAST_LSAP=y
CONFIG_IRDA_FAST_RR=y
# CONFIG_IRDA_DEBUG is not set

#
# Infrared-port device drivers
#

#
# SIR device drivers
#
CONFIG_IRTTY_SIR=m

#
# Dongle support
#
# CONFIG_DONGLE is not set
# CONFIG_KINGSUN_DONGLE is not set
CONFIG_KSDAZZLE_DONGLE=m
CONFIG_KS959_DONGLE=m

#
# FIR device drivers
#
# CONFIG_USB_IRDA is not set
CONFIG_SIGMATEL_FIR=m
CONFIG_NSC_FIR=m
CONFIG_WINBOND_FIR=m
# CONFIG_TOSHIBA_FIR is not set
# CONFIG_SMC_IRCC_FIR is not set
# CONFIG_ALI_FIR is not set
CONFIG_VLSI_FIR=m
CONFIG_VIA_FIR=m
CONFIG_MCS_FIR=m
# CONFIG_BT is not set
CONFIG_WIRELESS=y
CONFIG_CFG80211=m
CONFIG_NL80211_TESTMODE=y
# CONFIG_CFG80211_DEVELOPER_WARNINGS is not set
CONFIG_CFG80211_REG_DEBUG=y
# CONFIG_CFG80211_DEFAULT_PS is not set
# CONFIG_CFG80211_DEBUGFS is not set
# CONFIG_CFG80211_INTERNAL_REGDB is not set
# CONFIG_CFG80211_WEXT is not set
# CONFIG_LIB80211 is not set
CONFIG_MAC80211=m
CONFIG_MAC80211_HAS_RC=y
CONFIG_MAC80211_RC_MINSTREL=y
CONFIG_MAC80211_RC_MINSTREL_HT=y
CONFIG_MAC80211_RC_DEFAULT_MINSTREL=y
CONFIG_MAC80211_RC_DEFAULT="minstrel_ht"
CONFIG_MAC80211_MESH=y
CONFIG_MAC80211_LEDS=y
# CONFIG_MAC80211_DEBUGFS is not set
# CONFIG_MAC80211_MESSAGE_TRACING is not set
# CONFIG_MAC80211_DEBUG_MENU is not set
CONFIG_WIMAX=m
CONFIG_WIMAX_DEBUG_LEVEL=8
# CONFIG_RFKILL is not set
CONFIG_RFKILL_REGULATOR=y
CONFIG_NET_9P=y
CONFIG_NET_9P_VIRTIO=m
CONFIG_NET_9P_DEBUG=y
CONFIG_CAIF=y
CONFIG_CAIF_DEBUG=y
# CONFIG_CAIF_NETDEV is not set
# CONFIG_CAIF_USB is not set
CONFIG_NFC=m
# CONFIG_NFC_NCI is not set
# CONFIG_NFC_HCI is not set

#
# Near Field Communication (NFC) devices
#
# CONFIG_NFC_PN533 is not set
# CONFIG_NFC_SIM is not set

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
CONFIG_MTD_REDBOOT_PARTS=y
CONFIG_MTD_REDBOOT_DIRECTORY_BLOCK=-1
CONFIG_MTD_REDBOOT_PARTS_UNALLOCATED=y
CONFIG_MTD_REDBOOT_PARTS_READONLY=y
CONFIG_MTD_CMDLINE_PARTS=m
CONFIG_MTD_AR7_PARTS=m

#
# User Modules And Translation Layers
#
CONFIG_MTD_BLKDEVS=y
CONFIG_MTD_BLOCK=m
CONFIG_MTD_BLOCK_RO=y
# CONFIG_FTL is not set
CONFIG_NFTL=m
CONFIG_NFTL_RW=y
CONFIG_INFTL=m
CONFIG_RFD_FTL=y
CONFIG_SSFDC=m
CONFIG_SM_FTL=y
# CONFIG_MTD_OOPS is not set

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
CONFIG_MTD_CFI_GEOMETRY=y
# CONFIG_MTD_MAP_BANK_WIDTH_1 is not set
CONFIG_MTD_MAP_BANK_WIDTH_2=y
CONFIG_MTD_MAP_BANK_WIDTH_4=y
# CONFIG_MTD_MAP_BANK_WIDTH_8 is not set
CONFIG_MTD_MAP_BANK_WIDTH_16=y
CONFIG_MTD_MAP_BANK_WIDTH_32=y
# CONFIG_MTD_CFI_I1 is not set
CONFIG_MTD_CFI_I2=y
# CONFIG_MTD_CFI_I4 is not set
# CONFIG_MTD_CFI_I8 is not set
# CONFIG_MTD_OTP is not set
# CONFIG_MTD_CFI_INTELEXT is not set
CONFIG_MTD_CFI_AMDSTD=m
CONFIG_MTD_CFI_STAA=y
CONFIG_MTD_CFI_UTIL=y
CONFIG_MTD_RAM=y
# CONFIG_MTD_ROM is not set
CONFIG_MTD_ABSENT=m

#
# Mapping drivers for chip access
#
# CONFIG_MTD_COMPLEX_MAPPINGS is not set
CONFIG_MTD_PHYSMAP=y
# CONFIG_MTD_PHYSMAP_COMPAT is not set
CONFIG_MTD_SC520CDP=y
# CONFIG_MTD_NETSC520 is not set
# CONFIG_MTD_TS5500 is not set
# CONFIG_MTD_SCx200_DOCFLASH is not set
CONFIG_MTD_AMD76XROM=m
CONFIG_MTD_ICHXROM=y
CONFIG_MTD_ESB2ROM=m
CONFIG_MTD_CK804XROM=y
CONFIG_MTD_SCB2_FLASH=m
# CONFIG_MTD_NETtel is not set
CONFIG_MTD_L440GX=m
CONFIG_MTD_INTEL_VR_NOR=y
# CONFIG_MTD_PLATRAM is not set

#
# Self-contained MTD device drivers
#
# CONFIG_MTD_PMC551 is not set
CONFIG_MTD_SLRAM=m
# CONFIG_MTD_PHRAM is not set
# CONFIG_MTD_MTDRAM is not set
CONFIG_MTD_BLOCK2MTD=y

#
# Disk-On-Chip Device Drivers
#
CONFIG_MTD_DOCG3=m
CONFIG_BCH_CONST_M=14
CONFIG_BCH_CONST_T=4
CONFIG_MTD_NAND_ECC=y
CONFIG_MTD_NAND_ECC_SMC=y
CONFIG_MTD_NAND=y
CONFIG_MTD_NAND_BCH=y
CONFIG_MTD_NAND_ECC_BCH=y
CONFIG_MTD_SM_COMMON=m
CONFIG_MTD_NAND_DENALI=y
# CONFIG_MTD_NAND_DENALI_PCI is not set
CONFIG_MTD_NAND_GPIO=y
CONFIG_MTD_NAND_IDS=y
CONFIG_MTD_NAND_RICOH=m
CONFIG_MTD_NAND_DISKONCHIP=m
CONFIG_MTD_NAND_DISKONCHIP_PROBE_ADVANCED=y
CONFIG_MTD_NAND_DISKONCHIP_PROBE_ADDRESS=0
CONFIG_MTD_NAND_DISKONCHIP_PROBE_HIGH=y
CONFIG_MTD_NAND_DISKONCHIP_BBTWRITE=y
# CONFIG_MTD_NAND_DOCG4 is not set
CONFIG_MTD_NAND_CAFE=m
# CONFIG_MTD_NAND_CS553X is not set
# CONFIG_MTD_NAND_NANDSIM is not set
CONFIG_MTD_NAND_PLATFORM=m
# CONFIG_MTD_ONENAND is not set

#
# LPDDR flash memory drivers
#
# CONFIG_MTD_LPDDR is not set
# CONFIG_MTD_UBI is not set
# CONFIG_PARPORT is not set
CONFIG_PNP=y
# CONFIG_PNP_DEBUG_MESSAGES is not set

#
# Protocols
#
# CONFIG_ISAPNP is not set
# CONFIG_PNPBIOS is not set
CONFIG_PNPACPI=y
CONFIG_BLK_DEV=y
# CONFIG_BLK_DEV_FD is not set
# CONFIG_BLK_DEV_PCIESSD_MTIP32XX is not set
# CONFIG_BLK_CPQ_DA is not set
# CONFIG_BLK_CPQ_CISS_DA is not set
# CONFIG_BLK_DEV_DAC960 is not set
# CONFIG_BLK_DEV_UMEM is not set
# CONFIG_BLK_DEV_COW_COMMON is not set
# CONFIG_BLK_DEV_LOOP is not set

#
# DRBD disabled because PROC_FS or INET not selected
#
# CONFIG_BLK_DEV_NBD is not set
# CONFIG_BLK_DEV_NVME is not set
# CONFIG_BLK_DEV_SX8 is not set
# CONFIG_BLK_DEV_RAM is not set
# CONFIG_CDROM_PKTCDVD is not set
# CONFIG_ATA_OVER_ETH is not set
# CONFIG_VIRTIO_BLK is not set
# CONFIG_BLK_DEV_HD is not set
# CONFIG_BLK_DEV_RSXX is not set

#
# Misc devices
#
CONFIG_SENSORS_LIS3LV02D=y
CONFIG_AD525X_DPOT=m
# CONFIG_AD525X_DPOT_I2C is not set
# CONFIG_DUMMY_IRQ is not set
# CONFIG_IBM_ASM is not set
CONFIG_PHANTOM=y
CONFIG_SGI_IOC4=m
CONFIG_TIFM_CORE=m
# CONFIG_TIFM_7XX1 is not set
# CONFIG_ICS932S401 is not set
CONFIG_ATMEL_SSC=m
CONFIG_ENCLOSURE_SERVICES=m
CONFIG_CS5535_MFGPT=m
CONFIG_CS5535_MFGPT_DEFAULT_IRQ=7
CONFIG_CS5535_CLOCK_EVENT_SRC=m
# CONFIG_HP_ILO is not set
CONFIG_APDS9802ALS=m
CONFIG_ISL29003=m
# CONFIG_ISL29020 is not set
CONFIG_SENSORS_TSL2550=y
CONFIG_SENSORS_BH1780=y
# CONFIG_SENSORS_BH1770 is not set
# CONFIG_SENSORS_APDS990X is not set
# CONFIG_HMC6352 is not set
CONFIG_DS1682=y
# CONFIG_VMWARE_BALLOON is not set
CONFIG_BMP085=y
CONFIG_BMP085_I2C=m
# CONFIG_PCH_PHUB is not set
# CONFIG_USB_SWITCH_FSA9480 is not set
CONFIG_SRAM=y
CONFIG_C2PORT=m
CONFIG_C2PORT_DURAMAR_2150=m

#
# EEPROM support
#
# CONFIG_EEPROM_AT24 is not set
CONFIG_EEPROM_LEGACY=y
CONFIG_EEPROM_MAX6875=m
# CONFIG_EEPROM_93CX6 is not set
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
# CONFIG_VMWARE_VMCI is not set
CONFIG_HAVE_IDE=y
CONFIG_IDE=y

#
# Please see Documentation/ide/ide.txt for help/info on IDE drives
#
CONFIG_IDE_XFER_MODE=y
CONFIG_IDE_TIMINGS=y
CONFIG_IDE_ATAPI=y
CONFIG_IDE_LEGACY=y
CONFIG_BLK_DEV_IDE_SATA=y
CONFIG_IDE_GD=m
CONFIG_IDE_GD_ATA=y
CONFIG_IDE_GD_ATAPI=y
CONFIG_BLK_DEV_IDECS=m
# CONFIG_BLK_DEV_DELKIN is not set
# CONFIG_BLK_DEV_IDECD is not set
CONFIG_BLK_DEV_IDETAPE=y
CONFIG_BLK_DEV_IDEACPI=y
# CONFIG_IDE_TASK_IOCTL is not set
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
CONFIG_IDEPCI_PCIBUS_ORDER=y
# CONFIG_BLK_DEV_OFFBOARD is not set
# CONFIG_BLK_DEV_GENERIC is not set
# CONFIG_BLK_DEV_OPTI621 is not set
# CONFIG_BLK_DEV_RZ1000 is not set
CONFIG_BLK_DEV_IDEDMA_PCI=y
# CONFIG_BLK_DEV_AEC62XX is not set
CONFIG_BLK_DEV_ALI15X3=y
CONFIG_BLK_DEV_AMD74XX=m
CONFIG_BLK_DEV_ATIIXP=m
CONFIG_BLK_DEV_CMD64X=y
# CONFIG_BLK_DEV_TRIFLEX is not set
CONFIG_BLK_DEV_CS5520=m
# CONFIG_BLK_DEV_CS5530 is not set
CONFIG_BLK_DEV_CS5535=m
# CONFIG_BLK_DEV_CS5536 is not set
CONFIG_BLK_DEV_HPT366=m
CONFIG_BLK_DEV_JMICRON=y
# CONFIG_BLK_DEV_SC1200 is not set
# CONFIG_BLK_DEV_PIIX is not set
# CONFIG_BLK_DEV_IT8172 is not set
CONFIG_BLK_DEV_IT8213=y
CONFIG_BLK_DEV_IT821X=y
CONFIG_BLK_DEV_NS87415=m
# CONFIG_BLK_DEV_PDC202XX_OLD is not set
CONFIG_BLK_DEV_PDC202XX_NEW=y
# CONFIG_BLK_DEV_SVWKS is not set
# CONFIG_BLK_DEV_SIIMAGE is not set
CONFIG_BLK_DEV_SIS5513=m
CONFIG_BLK_DEV_SLC90E66=y
# CONFIG_BLK_DEV_TRM290 is not set
# CONFIG_BLK_DEV_VIA82CXXX is not set
CONFIG_BLK_DEV_TC86C001=y

#
# Other IDE chipsets support
#

#
# Note: most of these also require special kernel boot parameters
#
# CONFIG_BLK_DEV_4DRIVES is not set
# CONFIG_BLK_DEV_ALI14XX is not set
CONFIG_BLK_DEV_DTC2278=y
CONFIG_BLK_DEV_HT6560B=y
CONFIG_BLK_DEV_QD65XX=y
# CONFIG_BLK_DEV_UMC8672 is not set
CONFIG_BLK_DEV_IDEDMA=y

#
# SCSI device support
#
CONFIG_SCSI_MOD=y
# CONFIG_RAID_ATTRS is not set
CONFIG_SCSI=y
CONFIG_SCSI_DMA=y
# CONFIG_SCSI_TGT is not set
CONFIG_SCSI_NETLINK=y
CONFIG_SCSI_PROC_FS=y

#
# SCSI support type (disk, tape, CD-ROM)
#
CONFIG_BLK_DEV_SD=m
CONFIG_CHR_DEV_ST=m
CONFIG_CHR_DEV_OSST=m
# CONFIG_BLK_DEV_SR is not set
# CONFIG_CHR_DEV_SG is not set
# CONFIG_CHR_DEV_SCH is not set
CONFIG_SCSI_ENCLOSURE=m
# CONFIG_SCSI_MULTI_LUN is not set
CONFIG_SCSI_CONSTANTS=y
# CONFIG_SCSI_LOGGING is not set
# CONFIG_SCSI_SCAN_ASYNC is not set

#
# SCSI Transports
#
CONFIG_SCSI_SPI_ATTRS=m
CONFIG_SCSI_FC_ATTRS=y
CONFIG_SCSI_ISCSI_ATTRS=y
CONFIG_SCSI_SAS_ATTRS=y
CONFIG_SCSI_SAS_LIBSAS=y
# CONFIG_SCSI_SAS_HOST_SMP is not set
CONFIG_SCSI_SRP_ATTRS=y
# CONFIG_SCSI_LOWLEVEL is not set
CONFIG_SCSI_LOWLEVEL_PCMCIA=y
CONFIG_PCMCIA_AHA152X=m
# CONFIG_PCMCIA_FDOMAIN is not set
CONFIG_PCMCIA_NINJA_SCSI=m
# CONFIG_PCMCIA_QLOGIC is not set
CONFIG_PCMCIA_SYM53C500=m
CONFIG_SCSI_DH=y
CONFIG_SCSI_DH_RDAC=y
CONFIG_SCSI_DH_HP_SW=y
CONFIG_SCSI_DH_EMC=y
# CONFIG_SCSI_DH_ALUA is not set
# CONFIG_SCSI_OSD_INITIATOR is not set
# CONFIG_ATA is not set
# CONFIG_MD is not set
# CONFIG_TARGET_CORE is not set
CONFIG_FUSION=y
# CONFIG_FUSION_SPI is not set
CONFIG_FUSION_FC=m
CONFIG_FUSION_SAS=y
CONFIG_FUSION_MAX_SGE=128
CONFIG_FUSION_CTL=y
# CONFIG_FUSION_LOGGING is not set

#
# IEEE 1394 (FireWire) support
#
CONFIG_FIREWIRE=m
CONFIG_FIREWIRE_OHCI=m
CONFIG_FIREWIRE_SBP2=m
CONFIG_FIREWIRE_NOSY=m
CONFIG_I2O=y
# CONFIG_I2O_LCT_NOTIFY_ON_CHANGES is not set
# CONFIG_I2O_EXT_ADAPTEC is not set
CONFIG_I2O_CONFIG=m
# CONFIG_I2O_CONFIG_OLD_IOCTL is not set
# CONFIG_I2O_BUS is not set
CONFIG_I2O_BLOCK=y
CONFIG_I2O_SCSI=m
# CONFIG_I2O_PROC is not set
CONFIG_MACINTOSH_DRIVERS=y
CONFIG_MAC_EMUMOUSEBTN=y
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
CONFIG_INPUT_SPARSEKMAP=y
CONFIG_INPUT_MATRIXKMAP=m

#
# Userland interfaces
#
CONFIG_INPUT_MOUSEDEV=y
CONFIG_INPUT_MOUSEDEV_PSAUX=y
CONFIG_INPUT_MOUSEDEV_SCREEN_X=1024
CONFIG_INPUT_MOUSEDEV_SCREEN_Y=768
# CONFIG_INPUT_JOYDEV is not set
# CONFIG_INPUT_EVDEV is not set
CONFIG_INPUT_EVBUG=y

#
# Input Device Drivers
#
CONFIG_INPUT_KEYBOARD=y
CONFIG_KEYBOARD_ADP5520=m
# CONFIG_KEYBOARD_ADP5588 is not set
# CONFIG_KEYBOARD_ADP5589 is not set
CONFIG_KEYBOARD_ATKBD=y
# CONFIG_KEYBOARD_QT1070 is not set
CONFIG_KEYBOARD_QT2160=m
CONFIG_KEYBOARD_LKKBD=m
# CONFIG_KEYBOARD_GPIO is not set
CONFIG_KEYBOARD_GPIO_POLLED=y
CONFIG_KEYBOARD_TCA6416=m
CONFIG_KEYBOARD_TCA8418=m
# CONFIG_KEYBOARD_MATRIX is not set
# CONFIG_KEYBOARD_LM8323 is not set
CONFIG_KEYBOARD_LM8333=m
CONFIG_KEYBOARD_MAX7359=m
CONFIG_KEYBOARD_MCS=m
# CONFIG_KEYBOARD_MPR121 is not set
# CONFIG_KEYBOARD_NEWTON is not set
# CONFIG_KEYBOARD_OPENCORES is not set
# CONFIG_KEYBOARD_STOWAWAY is not set
CONFIG_KEYBOARD_SUNKBD=m
# CONFIG_KEYBOARD_XTKBD is not set
# CONFIG_INPUT_MOUSE is not set
CONFIG_INPUT_JOYSTICK=y
CONFIG_JOYSTICK_ANALOG=y
# CONFIG_JOYSTICK_A3D is not set
# CONFIG_JOYSTICK_ADI is not set
# CONFIG_JOYSTICK_COBRA is not set
CONFIG_JOYSTICK_GF2K=m
CONFIG_JOYSTICK_GRIP=m
# CONFIG_JOYSTICK_GRIP_MP is not set
CONFIG_JOYSTICK_GUILLEMOT=m
CONFIG_JOYSTICK_INTERACT=y
# CONFIG_JOYSTICK_SIDEWINDER is not set
CONFIG_JOYSTICK_TMDC=y
# CONFIG_JOYSTICK_IFORCE is not set
CONFIG_JOYSTICK_WARRIOR=y
CONFIG_JOYSTICK_MAGELLAN=y
# CONFIG_JOYSTICK_SPACEORB is not set
CONFIG_JOYSTICK_SPACEBALL=m
CONFIG_JOYSTICK_STINGER=y
CONFIG_JOYSTICK_TWIDJOY=y
CONFIG_JOYSTICK_ZHENHUA=m
CONFIG_JOYSTICK_AS5011=y
CONFIG_JOYSTICK_JOYDUMP=m
# CONFIG_JOYSTICK_XPAD is not set
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
CONFIG_SERIO_PCIPS2=m
CONFIG_SERIO_LIBPS2=y
CONFIG_SERIO_RAW=m
CONFIG_SERIO_ALTERA_PS2=y
CONFIG_SERIO_PS2MULT=m
CONFIG_SERIO_ARC_PS2=m
CONFIG_GAMEPORT=y
CONFIG_GAMEPORT_NS558=m
CONFIG_GAMEPORT_L4=y
# CONFIG_GAMEPORT_EMU10K1 is not set
CONFIG_GAMEPORT_FM801=m

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
CONFIG_ROCKETPORT=m
CONFIG_CYCLADES=m
CONFIG_CYZ_INTR=y
CONFIG_MOXA_INTELLIO=y
CONFIG_MOXA_SMARTIO=y
CONFIG_SYNCLINK=y
CONFIG_SYNCLINKMP=y
# CONFIG_SYNCLINK_GT is not set
CONFIG_NOZOMI=y
# CONFIG_ISI is not set
CONFIG_N_HDLC=y
# CONFIG_N_GSM is not set
CONFIG_TRACE_ROUTER=m
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
CONFIG_SERIAL_MFD_HSU=m
CONFIG_SERIAL_UARTLITE=m
CONFIG_SERIAL_CORE=y
CONFIG_SERIAL_CORE_CONSOLE=y
# CONFIG_SERIAL_JSM is not set
CONFIG_SERIAL_SCCNXP=m
CONFIG_SERIAL_TIMBERDALE=m
# CONFIG_SERIAL_ALTERA_JTAGUART is not set
CONFIG_SERIAL_ALTERA_UART=m
CONFIG_SERIAL_ALTERA_UART_MAXPORTS=4
CONFIG_SERIAL_ALTERA_UART_BAUDRATE=115200
# CONFIG_SERIAL_PCH_UART is not set
CONFIG_SERIAL_ARC=m
CONFIG_SERIAL_ARC_NR_PORTS=1
CONFIG_SERIAL_RP2=m
CONFIG_SERIAL_RP2_NR_UARTS=32
# CONFIG_SERIAL_FSL_LPUART is not set
CONFIG_SERIAL_ST_ASC=y
# CONFIG_SERIAL_ST_ASC_CONSOLE is not set
CONFIG_HVC_DRIVER=y
CONFIG_VIRTIO_CONSOLE=m
CONFIG_IPMI_HANDLER=m
CONFIG_IPMI_PANIC_EVENT=y
CONFIG_IPMI_PANIC_STRING=y
CONFIG_IPMI_DEVICE_INTERFACE=m
CONFIG_IPMI_SI=m
CONFIG_IPMI_WATCHDOG=m
CONFIG_IPMI_POWEROFF=m
CONFIG_HW_RANDOM=m
CONFIG_HW_RANDOM_TIMERIOMEM=m
CONFIG_HW_RANDOM_INTEL=m
# CONFIG_HW_RANDOM_AMD is not set
CONFIG_HW_RANDOM_GEODE=m
# CONFIG_HW_RANDOM_VIA is not set
CONFIG_HW_RANDOM_VIRTIO=m
CONFIG_HW_RANDOM_TPM=m
CONFIG_NVRAM=m
CONFIG_DTLK=y
# CONFIG_R3964 is not set
CONFIG_APPLICOM=y
CONFIG_SONYPI=y

#
# PCMCIA character devices
#
CONFIG_SYNCLINK_CS=m
# CONFIG_CARDMAN_4000 is not set
# CONFIG_CARDMAN_4040 is not set
# CONFIG_MWAVE is not set
CONFIG_SCx200_GPIO=m
# CONFIG_PC8736x_GPIO is not set
CONFIG_NSC_GPIO=m
CONFIG_RAW_DRIVER=y
CONFIG_MAX_RAW_DEVS=256
CONFIG_HPET=y
CONFIG_HPET_MMAP=y
CONFIG_HANGCHECK_TIMER=y
CONFIG_TCG_TPM=y
CONFIG_TCG_TIS=y
# CONFIG_TCG_TIS_I2C_INFINEON is not set
# CONFIG_TCG_NSC is not set
CONFIG_TCG_ATMEL=y
CONFIG_TCG_INFINEON=m
CONFIG_TCG_ST33_I2C=y
CONFIG_TELCLOCK=m
CONFIG_DEVPORT=y
CONFIG_I2C=y
CONFIG_I2C_BOARDINFO=y
CONFIG_I2C_COMPAT=y
CONFIG_I2C_CHARDEV=m
# CONFIG_I2C_MUX is not set
# CONFIG_I2C_HELPER_AUTO is not set
CONFIG_I2C_SMBUS=m

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
CONFIG_I2C_ALI1535=y
CONFIG_I2C_ALI1563=m
CONFIG_I2C_ALI15X3=m
# CONFIG_I2C_AMD756 is not set
# CONFIG_I2C_AMD8111 is not set
# CONFIG_I2C_I801 is not set
CONFIG_I2C_ISCH=y
CONFIG_I2C_ISMT=y
CONFIG_I2C_PIIX4=m
CONFIG_I2C_NFORCE2=m
# CONFIG_I2C_NFORCE2_S4985 is not set
# CONFIG_I2C_SIS5595 is not set
CONFIG_I2C_SIS630=m
CONFIG_I2C_SIS96X=y
# CONFIG_I2C_VIA is not set
CONFIG_I2C_VIAPRO=y

#
# ACPI drivers
#
CONFIG_I2C_SCMI=m

#
# I2C system bus drivers (mostly embedded / system-on-chip)
#
CONFIG_I2C_CBUS_GPIO=m
CONFIG_I2C_DESIGNWARE_CORE=y
CONFIG_I2C_DESIGNWARE_PCI=y
CONFIG_I2C_EG20T=m
# CONFIG_I2C_GPIO is not set
# CONFIG_I2C_OCORES is not set
# CONFIG_I2C_PCA_PLATFORM is not set
# CONFIG_I2C_PXA_PCI is not set
CONFIG_I2C_SIMTEC=m
# CONFIG_I2C_XILINX is not set

#
# External I2C/SMBus adapter drivers
#
CONFIG_I2C_DIOLAN_U2C=m
CONFIG_I2C_PARPORT_LIGHT=m
CONFIG_I2C_TAOS_EVM=y
CONFIG_I2C_TINY_USB=m

#
# Other I2C/SMBus bus drivers
#
CONFIG_I2C_PCA_ISA=y
CONFIG_SCx200_I2C=m
CONFIG_SCx200_I2C_SCL=12
CONFIG_SCx200_I2C_SDA=13
# CONFIG_SCx200_ACB is not set
# CONFIG_I2C_STUB is not set
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
CONFIG_PPS=m
# CONFIG_PPS_DEBUG is not set

#
# PPS clients support
#
CONFIG_PPS_CLIENT_KTIMER=m
CONFIG_PPS_CLIENT_LDISC=m
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
CONFIG_GPIO_DEVRES=y
CONFIG_GPIOLIB=y
CONFIG_GPIO_ACPI=y
# CONFIG_DEBUG_GPIO is not set
# CONFIG_GPIO_SYSFS is not set
CONFIG_GPIO_GENERIC=m
# CONFIG_GPIO_DA9055 is not set

#
# Memory mapped GPIO drivers:
#
CONFIG_GPIO_GENERIC_PLATFORM=m
# CONFIG_GPIO_IT8761E is not set
CONFIG_GPIO_F7188X=y
# CONFIG_GPIO_TS5500 is not set
# CONFIG_GPIO_SCH is not set
# CONFIG_GPIO_ICH is not set
# CONFIG_GPIO_VX855 is not set
CONFIG_GPIO_LYNXPOINT=y

#
# I2C GPIO expanders:
#
CONFIG_GPIO_ARIZONA=y
# CONFIG_GPIO_MAX7300 is not set
CONFIG_GPIO_MAX732X=m
CONFIG_GPIO_PCA953X=m
CONFIG_GPIO_PCF857X=y
# CONFIG_GPIO_RC5T583 is not set
# CONFIG_GPIO_SX150X is not set
CONFIG_GPIO_WM831X=y
# CONFIG_GPIO_WM8994 is not set
CONFIG_GPIO_ADP5520=y
# CONFIG_GPIO_ADP5588 is not set

#
# PCI GPIO expanders:
#
CONFIG_GPIO_CS5535=m
# CONFIG_GPIO_BT8XX is not set
CONFIG_GPIO_AMD8111=y
CONFIG_GPIO_LANGWELL=y
# CONFIG_GPIO_PCH is not set
CONFIG_GPIO_ML_IOH=y
CONFIG_GPIO_TIMBERDALE=y
CONFIG_GPIO_RDC321X=y

#
# SPI GPIO expanders:
#
# CONFIG_GPIO_MCP23S08 is not set

#
# AC97 GPIO expanders:
#

#
# LPC GPIO expanders:
#

#
# MODULbus GPIO expanders:
#
CONFIG_GPIO_TPS6586X=y
CONFIG_GPIO_TPS65910=y

#
# USB GPIO expanders:
#
CONFIG_W1=y
CONFIG_W1_CON=y

#
# 1-wire Bus Masters
#
CONFIG_W1_MASTER_MATROX=m
CONFIG_W1_MASTER_DS2490=m
# CONFIG_W1_MASTER_DS2482 is not set
# CONFIG_W1_MASTER_DS1WM is not set
CONFIG_W1_MASTER_GPIO=y

#
# 1-wire Slaves
#
# CONFIG_W1_SLAVE_THERM is not set
CONFIG_W1_SLAVE_SMEM=y
CONFIG_W1_SLAVE_DS2408=y
CONFIG_W1_SLAVE_DS2408_READBACK=y
CONFIG_W1_SLAVE_DS2413=y
CONFIG_W1_SLAVE_DS2423=m
# CONFIG_W1_SLAVE_DS2431 is not set
CONFIG_W1_SLAVE_DS2433=y
# CONFIG_W1_SLAVE_DS2433_CRC is not set
CONFIG_W1_SLAVE_DS2760=y
CONFIG_W1_SLAVE_DS2780=y
CONFIG_W1_SLAVE_DS2781=m
CONFIG_W1_SLAVE_DS28E04=m
# CONFIG_W1_SLAVE_BQ27000 is not set
CONFIG_POWER_SUPPLY=y
CONFIG_POWER_SUPPLY_DEBUG=y
CONFIG_PDA_POWER=y
# CONFIG_GENERIC_ADC_BATTERY is not set
# CONFIG_MAX8925_POWER is not set
CONFIG_WM831X_BACKUP=y
# CONFIG_WM831X_POWER is not set
CONFIG_TEST_POWER=y
CONFIG_BATTERY_88PM860X=y
CONFIG_BATTERY_DS2760=m
# CONFIG_BATTERY_DS2780 is not set
CONFIG_BATTERY_DS2781=m
CONFIG_BATTERY_DS2782=y
# CONFIG_BATTERY_SBS is not set
# CONFIG_BATTERY_BQ27x00 is not set
# CONFIG_BATTERY_DA9030 is not set
CONFIG_BATTERY_MAX17040=m
# CONFIG_BATTERY_MAX17042 is not set
# CONFIG_CHARGER_88PM860X is not set
# CONFIG_CHARGER_PCF50633 is not set
CONFIG_CHARGER_ISP1704=m
# CONFIG_CHARGER_MAX8903 is not set
CONFIG_CHARGER_LP8727=m
# CONFIG_CHARGER_GPIO is not set
# CONFIG_CHARGER_MANAGER is not set
CONFIG_CHARGER_MAX8997=m
CONFIG_CHARGER_MAX8998=m
CONFIG_CHARGER_BQ2415X=y
# CONFIG_CHARGER_BQ24190 is not set
CONFIG_CHARGER_SMB347=y
CONFIG_CHARGER_TPS65090=m
# CONFIG_POWER_RESET is not set
# CONFIG_POWER_AVS is not set
CONFIG_HWMON=y
CONFIG_HWMON_VID=y
CONFIG_HWMON_DEBUG_CHIP=y

#
# Native drivers
#
CONFIG_SENSORS_ABITUGURU=m
CONFIG_SENSORS_ABITUGURU3=y
CONFIG_SENSORS_AD7414=m
CONFIG_SENSORS_AD7418=m
# CONFIG_SENSORS_ADM1021 is not set
# CONFIG_SENSORS_ADM1025 is not set
CONFIG_SENSORS_ADM1026=m
CONFIG_SENSORS_ADM1029=y
CONFIG_SENSORS_ADM1031=m
CONFIG_SENSORS_ADM9240=y
# CONFIG_SENSORS_ADT7410 is not set
CONFIG_SENSORS_ADT7411=y
CONFIG_SENSORS_ADT7462=m
CONFIG_SENSORS_ADT7470=m
CONFIG_SENSORS_ADT7475=m
CONFIG_SENSORS_ASC7621=m
CONFIG_SENSORS_K8TEMP=m
CONFIG_SENSORS_K10TEMP=y
CONFIG_SENSORS_FAM15H_POWER=m
CONFIG_SENSORS_ASB100=y
CONFIG_SENSORS_ATXP1=m
CONFIG_SENSORS_DS620=y
CONFIG_SENSORS_DS1621=y
CONFIG_SENSORS_DA9055=m
# CONFIG_SENSORS_I5K_AMB is not set
# CONFIG_SENSORS_F71805F is not set
# CONFIG_SENSORS_F71882FG is not set
CONFIG_SENSORS_F75375S=m
CONFIG_SENSORS_FSCHMD=y
CONFIG_SENSORS_G760A=y
# CONFIG_SENSORS_G762 is not set
CONFIG_SENSORS_GL518SM=y
CONFIG_SENSORS_GL520SM=m
# CONFIG_SENSORS_GPIO_FAN is not set
CONFIG_SENSORS_HIH6130=y
CONFIG_SENSORS_HTU21=m
CONFIG_SENSORS_CORETEMP=m
CONFIG_SENSORS_IBMAEM=m
# CONFIG_SENSORS_IBMPEX is not set
# CONFIG_SENSORS_IIO_HWMON is not set
# CONFIG_SENSORS_IT87 is not set
CONFIG_SENSORS_JC42=m
# CONFIG_SENSORS_LINEAGE is not set
CONFIG_SENSORS_LM63=m
CONFIG_SENSORS_LM73=y
# CONFIG_SENSORS_LM75 is not set
CONFIG_SENSORS_LM77=y
CONFIG_SENSORS_LM78=m
CONFIG_SENSORS_LM80=y
# CONFIG_SENSORS_LM83 is not set
# CONFIG_SENSORS_LM85 is not set
# CONFIG_SENSORS_LM87 is not set
CONFIG_SENSORS_LM90=m
CONFIG_SENSORS_LM92=y
CONFIG_SENSORS_LM93=y
CONFIG_SENSORS_LTC4151=m
CONFIG_SENSORS_LTC4215=m
CONFIG_SENSORS_LTC4245=y
CONFIG_SENSORS_LTC4261=m
CONFIG_SENSORS_LM95234=m
CONFIG_SENSORS_LM95241=m
CONFIG_SENSORS_LM95245=y
# CONFIG_SENSORS_MAX16065 is not set
CONFIG_SENSORS_MAX1619=m
CONFIG_SENSORS_MAX1668=y
CONFIG_SENSORS_MAX197=m
CONFIG_SENSORS_MAX6639=y
CONFIG_SENSORS_MAX6642=m
CONFIG_SENSORS_MAX6650=m
CONFIG_SENSORS_MAX6697=m
CONFIG_SENSORS_MCP3021=m
# CONFIG_SENSORS_NCT6775 is not set
CONFIG_SENSORS_NTC_THERMISTOR=m
CONFIG_SENSORS_PC87360=y
# CONFIG_SENSORS_PC87427 is not set
CONFIG_SENSORS_PCF8591=y
# CONFIG_PMBUS is not set
CONFIG_SENSORS_SHT15=y
# CONFIG_SENSORS_SHT21 is not set
# CONFIG_SENSORS_SIS5595 is not set
CONFIG_SENSORS_SMM665=y
CONFIG_SENSORS_DME1737=m
CONFIG_SENSORS_EMC1403=y
CONFIG_SENSORS_EMC2103=y
CONFIG_SENSORS_EMC6W201=y
CONFIG_SENSORS_SMSC47M1=m
# CONFIG_SENSORS_SMSC47M192 is not set
# CONFIG_SENSORS_SMSC47B397 is not set
# CONFIG_SENSORS_SCH56XX_COMMON is not set
# CONFIG_SENSORS_ADS1015 is not set
# CONFIG_SENSORS_ADS7828 is not set
# CONFIG_SENSORS_AMC6821 is not set
CONFIG_SENSORS_INA209=y
CONFIG_SENSORS_INA2XX=y
CONFIG_SENSORS_THMC50=m
CONFIG_SENSORS_TMP102=m
CONFIG_SENSORS_TMP401=m
CONFIG_SENSORS_TMP421=m
CONFIG_SENSORS_VIA_CPUTEMP=m
CONFIG_SENSORS_VIA686A=y
CONFIG_SENSORS_VT1211=m
CONFIG_SENSORS_VT8231=y
CONFIG_SENSORS_W83781D=y
CONFIG_SENSORS_W83791D=m
# CONFIG_SENSORS_W83792D is not set
CONFIG_SENSORS_W83793=m
CONFIG_SENSORS_W83795=m
# CONFIG_SENSORS_W83795_FANCTRL is not set
# CONFIG_SENSORS_W83L785TS is not set
CONFIG_SENSORS_W83L786NG=y
CONFIG_SENSORS_W83627HF=m
CONFIG_SENSORS_W83627EHF=y
# CONFIG_SENSORS_WM831X is not set
# CONFIG_SENSORS_APPLESMC is not set
# CONFIG_SENSORS_MC13783_ADC is not set

#
# ACPI drivers
#
CONFIG_SENSORS_ACPI_POWER=m
CONFIG_SENSORS_ATK0110=m
CONFIG_THERMAL=y
CONFIG_THERMAL_HWMON=y
CONFIG_THERMAL_DEFAULT_GOV_STEP_WISE=y
# CONFIG_THERMAL_DEFAULT_GOV_FAIR_SHARE is not set
# CONFIG_THERMAL_DEFAULT_GOV_USER_SPACE is not set
CONFIG_THERMAL_GOV_FAIR_SHARE=y
CONFIG_THERMAL_GOV_STEP_WISE=y
CONFIG_THERMAL_GOV_USER_SPACE=y
CONFIG_CPU_THERMAL=y
CONFIG_THERMAL_EMULATION=y
CONFIG_INTEL_POWERCLAMP=m

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
# CONFIG_SSB_PCIHOST is not set
CONFIG_SSB_PCMCIAHOST_POSSIBLE=y
CONFIG_SSB_PCMCIAHOST=y
# CONFIG_SSB_DEBUG is not set
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
# CONFIG_MFD_DA9052_I2C is not set
CONFIG_MFD_DA9055=y
# CONFIG_MFD_DA9063 is not set
CONFIG_MFD_MC13783=m
CONFIG_MFD_MC13XXX=m
CONFIG_MFD_MC13XXX_I2C=m
# CONFIG_HTC_PASIC3 is not set
# CONFIG_HTC_I2CPLD is not set
# CONFIG_LPC_ICH is not set
CONFIG_LPC_SCH=y
# CONFIG_MFD_JANZ_CMODIO is not set
# CONFIG_MFD_KEMPLD is not set
# CONFIG_MFD_88PM800 is not set
CONFIG_MFD_88PM805=y
CONFIG_MFD_88PM860X=y
# CONFIG_MFD_MAX77686 is not set
CONFIG_MFD_MAX77693=y
CONFIG_MFD_MAX8907=y
CONFIG_MFD_MAX8925=y
CONFIG_MFD_MAX8997=y
CONFIG_MFD_MAX8998=y
# CONFIG_MFD_VIPERBOARD is not set
CONFIG_MFD_RETU=y
CONFIG_MFD_PCF50633=m
# CONFIG_PCF50633_ADC is not set
# CONFIG_PCF50633_GPIO is not set
CONFIG_MFD_RDC321X=y
CONFIG_MFD_RTSX_PCI=y
CONFIG_MFD_RC5T583=y
# CONFIG_MFD_SEC_CORE is not set
CONFIG_MFD_SI476X_CORE=y
CONFIG_MFD_SM501=y
CONFIG_MFD_SM501_GPIO=y
CONFIG_MFD_SMSC=y
# CONFIG_ABX500_CORE is not set
# CONFIG_MFD_STMPE is not set
CONFIG_MFD_SYSCON=y
CONFIG_MFD_TI_AM335X_TSCADC=y
# CONFIG_MFD_LP8788 is not set
# CONFIG_MFD_PALMAS is not set
# CONFIG_TPS6105X is not set
# CONFIG_TPS65010 is not set
CONFIG_TPS6507X=m
CONFIG_MFD_TPS65090=y
CONFIG_MFD_TPS65217=m
CONFIG_MFD_TPS6586X=y
CONFIG_MFD_TPS65910=y
# CONFIG_MFD_TPS65912 is not set
# CONFIG_MFD_TPS65912_I2C is not set
# CONFIG_MFD_TPS80031 is not set
# CONFIG_TWL4030_CORE is not set
# CONFIG_TWL6040_CORE is not set
# CONFIG_MFD_WL1273_CORE is not set
# CONFIG_MFD_LM3533 is not set
CONFIG_MFD_TIMBERDALE=y
# CONFIG_MFD_TC3589X is not set
# CONFIG_MFD_TMIO is not set
CONFIG_MFD_VX855=y
CONFIG_MFD_ARIZONA=y
CONFIG_MFD_ARIZONA_I2C=y
# CONFIG_MFD_WM5102 is not set
CONFIG_MFD_WM5110=y
# CONFIG_MFD_WM8997 is not set
# CONFIG_MFD_WM8400 is not set
CONFIG_MFD_WM831X=y
CONFIG_MFD_WM831X_I2C=y
# CONFIG_MFD_WM8350_I2C is not set
CONFIG_MFD_WM8994=y
CONFIG_REGULATOR=y
# CONFIG_REGULATOR_DEBUG is not set
# CONFIG_REGULATOR_DUMMY is not set
CONFIG_REGULATOR_FIXED_VOLTAGE=y
CONFIG_REGULATOR_VIRTUAL_CONSUMER=y
CONFIG_REGULATOR_USERSPACE_CONSUMER=y
CONFIG_REGULATOR_88PM8607=y
CONFIG_REGULATOR_AD5398=m
CONFIG_REGULATOR_ANATOP=m
CONFIG_REGULATOR_AAT2870=y
# CONFIG_REGULATOR_DA903X is not set
CONFIG_REGULATOR_DA9055=y
# CONFIG_REGULATOR_DA9210 is not set
# CONFIG_REGULATOR_FAN53555 is not set
# CONFIG_REGULATOR_GPIO is not set
CONFIG_REGULATOR_ISL6271A=m
# CONFIG_REGULATOR_LP3971 is not set
# CONFIG_REGULATOR_LP3972 is not set
# CONFIG_REGULATOR_LP872X is not set
# CONFIG_REGULATOR_LP8755 is not set
CONFIG_REGULATOR_MAX1586=m
CONFIG_REGULATOR_MAX8649=m
CONFIG_REGULATOR_MAX8660=y
CONFIG_REGULATOR_MAX8907=m
CONFIG_REGULATOR_MAX8925=m
# CONFIG_REGULATOR_MAX8952 is not set
CONFIG_REGULATOR_MAX8973=y
CONFIG_REGULATOR_MAX8997=m
CONFIG_REGULATOR_MAX8998=m
CONFIG_REGULATOR_MAX77693=y
# CONFIG_REGULATOR_MC13783 is not set
# CONFIG_REGULATOR_MC13892 is not set
CONFIG_REGULATOR_PCF50633=m
CONFIG_REGULATOR_PFUZE100=y
CONFIG_REGULATOR_RC5T583=y
CONFIG_REGULATOR_TPS51632=m
CONFIG_REGULATOR_TPS62360=m
CONFIG_REGULATOR_TPS65023=y
CONFIG_REGULATOR_TPS6507X=y
# CONFIG_REGULATOR_TPS65090 is not set
# CONFIG_REGULATOR_TPS65217 is not set
# CONFIG_REGULATOR_TPS6586X is not set
CONFIG_REGULATOR_TPS65910=y
CONFIG_REGULATOR_WM831X=m
# CONFIG_REGULATOR_WM8994 is not set
# CONFIG_MEDIA_SUPPORT is not set

#
# Graphics support
#
CONFIG_AGP=y
CONFIG_AGP_ALI=y
CONFIG_AGP_ATI=m
# CONFIG_AGP_AMD is not set
CONFIG_AGP_AMD64=m
CONFIG_AGP_INTEL=y
# CONFIG_AGP_NVIDIA is not set
# CONFIG_AGP_SIS is not set
# CONFIG_AGP_SWORKS is not set
CONFIG_AGP_VIA=m
# CONFIG_AGP_EFFICEON is not set
CONFIG_VGA_ARB=y
CONFIG_VGA_ARB_MAX_GPUS=16
CONFIG_VGA_SWITCHEROO=y
CONFIG_DRM=y
CONFIG_DRM_USB=m
CONFIG_DRM_KMS_HELPER=y
# CONFIG_DRM_LOAD_EDID_FIRMWARE is not set
CONFIG_DRM_TTM=y

#
# I2C encoder or helper chips
#
CONFIG_DRM_I2C_CH7006=m
# CONFIG_DRM_I2C_SIL164 is not set
# CONFIG_DRM_I2C_NXP_TDA998X is not set
CONFIG_DRM_TDFX=m
CONFIG_DRM_R128=y
CONFIG_DRM_RADEON=y
# CONFIG_DRM_RADEON_UMS is not set
CONFIG_DRM_NOUVEAU=y
CONFIG_NOUVEAU_DEBUG=5
CONFIG_NOUVEAU_DEBUG_DEFAULT=3
CONFIG_DRM_NOUVEAU_BACKLIGHT=y
CONFIG_DRM_I810=m
CONFIG_DRM_I915=y
CONFIG_DRM_I915_KMS=y
CONFIG_DRM_I915_PRELIMINARY_HW_SUPPORT=y
CONFIG_DRM_MGA=m
CONFIG_DRM_SIS=m
# CONFIG_DRM_VIA is not set
CONFIG_DRM_SAVAGE=y
CONFIG_DRM_VMWGFX=m
CONFIG_DRM_VMWGFX_FBCON=y
CONFIG_DRM_GMA500=m
# CONFIG_DRM_GMA600 is not set
# CONFIG_DRM_GMA3600 is not set
CONFIG_DRM_UDL=m
# CONFIG_DRM_AST is not set
CONFIG_DRM_MGAG200=y
CONFIG_DRM_CIRRUS_QEMU=y
CONFIG_DRM_QXL=y
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
CONFIG_FB_BOTH_ENDIAN=y
# CONFIG_FB_BIG_ENDIAN is not set
# CONFIG_FB_LITTLE_ENDIAN is not set
CONFIG_FB_SYS_FOPS=y
CONFIG_FB_DEFERRED_IO=y
CONFIG_FB_HECUBA=y
CONFIG_FB_SVGALIB=y
# CONFIG_FB_MACMODES is not set
CONFIG_FB_BACKLIGHT=y
CONFIG_FB_MODE_HELPERS=y
CONFIG_FB_TILEBLITTING=y

#
# Frame buffer hardware drivers
#
CONFIG_FB_CIRRUS=m
CONFIG_FB_PM2=y
# CONFIG_FB_PM2_FIFO_DISCONNECT is not set
# CONFIG_FB_CYBER2000 is not set
CONFIG_FB_ARC=y
# CONFIG_FB_ASILIANT is not set
# CONFIG_FB_IMSTT is not set
# CONFIG_FB_VGA16 is not set
CONFIG_FB_UVESA=m
CONFIG_FB_VESA=y
CONFIG_FB_EFI=y
CONFIG_FB_N411=y
CONFIG_FB_HGA=y
CONFIG_FB_S1D13XXX=y
CONFIG_FB_NVIDIA=m
# CONFIG_FB_NVIDIA_I2C is not set
# CONFIG_FB_NVIDIA_DEBUG is not set
# CONFIG_FB_NVIDIA_BACKLIGHT is not set
# CONFIG_FB_RIVA is not set
CONFIG_FB_I740=m
CONFIG_FB_I810=m
# CONFIG_FB_I810_GTF is not set
# CONFIG_FB_LE80578 is not set
CONFIG_FB_MATROX=m
CONFIG_FB_MATROX_MILLENIUM=y
CONFIG_FB_MATROX_MYSTIQUE=y
CONFIG_FB_MATROX_G=y
# CONFIG_FB_MATROX_I2C is not set
# CONFIG_FB_RADEON is not set
CONFIG_FB_ATY128=m
# CONFIG_FB_ATY128_BACKLIGHT is not set
CONFIG_FB_ATY=m
# CONFIG_FB_ATY_CT is not set
CONFIG_FB_ATY_GX=y
# CONFIG_FB_ATY_BACKLIGHT is not set
CONFIG_FB_S3=m
# CONFIG_FB_S3_DDC is not set
CONFIG_FB_SAVAGE=m
CONFIG_FB_SAVAGE_I2C=y
CONFIG_FB_SAVAGE_ACCEL=y
# CONFIG_FB_SIS is not set
# CONFIG_FB_VIA is not set
CONFIG_FB_NEOMAGIC=y
CONFIG_FB_KYRO=m
CONFIG_FB_3DFX=y
# CONFIG_FB_3DFX_ACCEL is not set
CONFIG_FB_3DFX_I2C=y
# CONFIG_FB_VOODOO1 is not set
CONFIG_FB_VT8623=y
# CONFIG_FB_TRIDENT is not set
# CONFIG_FB_ARK is not set
# CONFIG_FB_PM3 is not set
CONFIG_FB_CARMINE=m
CONFIG_FB_CARMINE_DRAM_EVAL=y
# CONFIG_CARMINE_DRAM_CUSTOM is not set
CONFIG_FB_GEODE=y
CONFIG_FB_GEODE_LX=y
# CONFIG_FB_GEODE_GX is not set
CONFIG_FB_GEODE_GX1=y
CONFIG_FB_TMIO=y
# CONFIG_FB_TMIO_ACCELL is not set
CONFIG_FB_SM501=y
CONFIG_FB_SMSCUFX=m
CONFIG_FB_UDL=m
CONFIG_FB_GOLDFISH=y
# CONFIG_FB_VIRTUAL is not set
# CONFIG_FB_METRONOME is not set
# CONFIG_FB_MB862XX is not set
# CONFIG_FB_BROADSHEET is not set
CONFIG_FB_AUO_K190X=y
CONFIG_FB_AUO_K1900=y
CONFIG_FB_AUO_K1901=y
# CONFIG_FB_SIMPLE is not set
CONFIG_EXYNOS_VIDEO=y
CONFIG_BACKLIGHT_LCD_SUPPORT=y
# CONFIG_LCD_CLASS_DEVICE is not set
CONFIG_BACKLIGHT_CLASS_DEVICE=y
CONFIG_BACKLIGHT_GENERIC=y
CONFIG_BACKLIGHT_PWM=y
CONFIG_BACKLIGHT_DA903X=m
# CONFIG_BACKLIGHT_MAX8925 is not set
# CONFIG_BACKLIGHT_APPLE is not set
CONFIG_BACKLIGHT_SAHARA=m
# CONFIG_BACKLIGHT_WM831X is not set
CONFIG_BACKLIGHT_ADP5520=m
CONFIG_BACKLIGHT_ADP8860=y
# CONFIG_BACKLIGHT_ADP8870 is not set
CONFIG_BACKLIGHT_88PM860X=y
# CONFIG_BACKLIGHT_PCF50633 is not set
# CONFIG_BACKLIGHT_AAT2870 is not set
CONFIG_BACKLIGHT_LM3630=m
CONFIG_BACKLIGHT_LM3639=m
CONFIG_BACKLIGHT_LP855X=m
CONFIG_BACKLIGHT_OT200=m
# CONFIG_BACKLIGHT_TPS65217 is not set
# CONFIG_BACKLIGHT_GPIO is not set
CONFIG_BACKLIGHT_LV5207LP=y
CONFIG_BACKLIGHT_BD6107=m

#
# Console display driver support
#
CONFIG_VGA_CONSOLE=y
CONFIG_VGACON_SOFT_SCROLLBACK=y
CONFIG_VGACON_SOFT_SCROLLBACK_SIZE=64
# CONFIG_MDA_CONSOLE is not set
CONFIG_DUMMY_CONSOLE=y
CONFIG_FRAMEBUFFER_CONSOLE=y
CONFIG_FRAMEBUFFER_CONSOLE_DETECT_PRIMARY=y
# CONFIG_FRAMEBUFFER_CONSOLE_ROTATION is not set
CONFIG_LOGO=y
CONFIG_LOGO_LINUX_MONO=y
# CONFIG_LOGO_LINUX_VGA16 is not set
CONFIG_LOGO_LINUX_CLUT224=y
CONFIG_SOUND=m
CONFIG_SOUND_OSS_CORE=y
# CONFIG_SOUND_OSS_CORE_PRECLAIM is not set
# CONFIG_SND is not set
CONFIG_SOUND_PRIME=m
# CONFIG_SOUND_MSNDCLAS is not set
# CONFIG_SOUND_MSNDPIN is not set
CONFIG_SOUND_OSS=m
CONFIG_SOUND_TRACEINIT=y
CONFIG_SOUND_DMAP=y
# CONFIG_SOUND_VMIDI is not set
# CONFIG_SOUND_TRIX is not set
CONFIG_SOUND_MSS=m
# CONFIG_SOUND_MPU401 is not set
CONFIG_SOUND_PAS=m
CONFIG_SOUND_PSS=m
# CONFIG_PSS_MIXER is not set
CONFIG_SOUND_SB=m
CONFIG_SOUND_YM3812=m
CONFIG_SOUND_UART6850=m
# CONFIG_SOUND_AEDSP16 is not set
CONFIG_SOUND_KAHLUA=m

#
# HID support
#
CONFIG_HID=y
# CONFIG_HID_BATTERY_STRENGTH is not set
CONFIG_HIDRAW=y
CONFIG_UHID=y
CONFIG_HID_GENERIC=m

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
CONFIG_HID_CHICONY=y
CONFIG_HID_CYPRESS=y
# CONFIG_HID_DRAGONRISE is not set
CONFIG_HID_EMS_FF=m
CONFIG_HID_ELECOM=m
CONFIG_HID_ELO=m
CONFIG_HID_EZKEY=y
CONFIG_HID_HOLTEK=m
# CONFIG_HOLTEK_FF is not set
CONFIG_HID_HUION=m
CONFIG_HID_KEYTOUCH=m
CONFIG_HID_KYE=y
CONFIG_HID_UCLOGIC=m
# CONFIG_HID_WALTOP is not set
# CONFIG_HID_GYRATION is not set
# CONFIG_HID_ICADE is not set
# CONFIG_HID_TWINHAN is not set
CONFIG_HID_KENSINGTON=y
CONFIG_HID_LCPOWER=y
CONFIG_HID_LENOVO_TPKBD=m
CONFIG_HID_LOGITECH=y
CONFIG_HID_LOGITECH_DJ=y
# CONFIG_LOGITECH_FF is not set
# CONFIG_LOGIRUMBLEPAD2_FF is not set
# CONFIG_LOGIG940_FF is not set
CONFIG_LOGIWHEELS_FF=y
CONFIG_HID_MAGICMOUSE=m
CONFIG_HID_MICROSOFT=y
CONFIG_HID_MONTEREY=y
CONFIG_HID_MULTITOUCH=m
CONFIG_HID_NTRIG=m
CONFIG_HID_ORTEK=y
# CONFIG_HID_PANTHERLORD is not set
CONFIG_HID_PETALYNX=y
CONFIG_HID_PICOLCD=y
CONFIG_HID_PICOLCD_FB=y
CONFIG_HID_PICOLCD_BACKLIGHT=y
CONFIG_HID_PICOLCD_LEDS=y
CONFIG_HID_PRIMAX=y
CONFIG_HID_ROCCAT=m
# CONFIG_HID_SAITEK is not set
CONFIG_HID_SAMSUNG=m
# CONFIG_HID_SONY is not set
CONFIG_HID_SPEEDLINK=y
# CONFIG_HID_STEELSERIES is not set
CONFIG_HID_SUNPLUS=m
# CONFIG_HID_GREENASIA is not set
CONFIG_HID_SMARTJOYPLUS=m
CONFIG_SMARTJOYPLUS_FF=y
CONFIG_HID_TIVO=m
# CONFIG_HID_TOPSEED is not set
CONFIG_HID_THINGM=m
CONFIG_HID_THRUSTMASTER=m
# CONFIG_THRUSTMASTER_FF is not set
CONFIG_HID_WACOM=y
CONFIG_HID_WIIMOTE=y
CONFIG_HID_XINMO=m
# CONFIG_HID_ZEROPLUS is not set
# CONFIG_HID_ZYDACRON is not set
CONFIG_HID_SENSOR_HUB=m

#
# USB HID support
#
CONFIG_USB_HID=m
# CONFIG_HID_PID is not set
# CONFIG_USB_HIDDEV is not set

#
# I2C HID support
#
CONFIG_I2C_HID=y
CONFIG_USB_OHCI_LITTLE_ENDIAN=y
CONFIG_USB_SUPPORT=y
CONFIG_USB_COMMON=m
CONFIG_USB_ARCH_HAS_HCD=y
CONFIG_USB=m
# CONFIG_USB_DEBUG is not set
# CONFIG_USB_ANNOUNCE_NEW_DEVICES is not set

#
# Miscellaneous USB options
#
CONFIG_USB_DEFAULT_PERSIST=y
CONFIG_USB_DYNAMIC_MINORS=y
CONFIG_USB_OTG=y
CONFIG_USB_OTG_WHITELIST=y
# CONFIG_USB_OTG_BLACKLIST_HUB is not set
CONFIG_USB_MON=m
CONFIG_USB_WUSB=m
CONFIG_USB_WUSB_CBAF=m
CONFIG_USB_WUSB_CBAF_DEBUG=y

#
# USB Host Controller Drivers
#
CONFIG_USB_C67X00_HCD=m
CONFIG_USB_XHCI_HCD=m
CONFIG_USB_EHCI_HCD=m
CONFIG_USB_EHCI_ROOT_HUB_TT=y
# CONFIG_USB_EHCI_TT_NEWSCHED is not set
CONFIG_USB_EHCI_PCI=m
CONFIG_USB_EHCI_HCD_PLATFORM=m
# CONFIG_USB_OXU210HP_HCD is not set
CONFIG_USB_ISP116X_HCD=m
CONFIG_USB_ISP1760_HCD=m
# CONFIG_USB_ISP1362_HCD is not set
CONFIG_USB_FUSBH200_HCD=m
# CONFIG_USB_FOTG210_HCD is not set
CONFIG_USB_OHCI_HCD=m
# CONFIG_USB_OHCI_HCD_PCI is not set
# CONFIG_USB_OHCI_HCD_SSB is not set
CONFIG_USB_OHCI_HCD_PLATFORM=m
CONFIG_USB_UHCI_HCD=m
CONFIG_USB_U132_HCD=m
CONFIG_USB_SL811_HCD=m
# CONFIG_USB_SL811_HCD_ISO is not set
# CONFIG_USB_SL811_CS is not set
CONFIG_USB_R8A66597_HCD=m
# CONFIG_USB_WHCI_HCD is not set
# CONFIG_USB_HWA_HCD is not set
CONFIG_USB_HCD_SSB=m
CONFIG_USB_HCD_TEST_MODE=y
CONFIG_USB_MUSB_HDRC=m
CONFIG_USB_MUSB_HOST=y
# CONFIG_USB_MUSB_GADGET is not set
# CONFIG_USB_MUSB_DUAL_ROLE is not set
# CONFIG_USB_MUSB_TUSB6010 is not set
CONFIG_USB_MUSB_UX500=m
CONFIG_USB_UX500_DMA=y
# CONFIG_MUSB_PIO_ONLY is not set
# CONFIG_USB_RENESAS_USBHS is not set

#
# USB Device Class drivers
#
CONFIG_USB_ACM=m
# CONFIG_USB_PRINTER is not set
# CONFIG_USB_WDM is not set
CONFIG_USB_TMC=m

#
# NOTE: USB_STORAGE depends on SCSI but BLK_DEV_SD may
#

#
# also be needed; see USB_STORAGE Help for more info
#
CONFIG_USB_STORAGE=m
CONFIG_USB_STORAGE_DEBUG=y
# CONFIG_USB_STORAGE_REALTEK is not set
CONFIG_USB_STORAGE_DATAFAB=m
CONFIG_USB_STORAGE_FREECOM=m
# CONFIG_USB_STORAGE_ISD200 is not set
CONFIG_USB_STORAGE_USBAT=m
# CONFIG_USB_STORAGE_SDDR09 is not set
CONFIG_USB_STORAGE_SDDR55=m
CONFIG_USB_STORAGE_JUMPSHOT=m
CONFIG_USB_STORAGE_ALAUDA=m
# CONFIG_USB_STORAGE_ONETOUCH is not set
# CONFIG_USB_STORAGE_KARMA is not set
# CONFIG_USB_STORAGE_CYPRESS_ATACB is not set
# CONFIG_USB_STORAGE_ENE_UB6250 is not set

#
# USB Imaging devices
#
CONFIG_USB_MDC800=m
CONFIG_USB_MICROTEK=m
# CONFIG_USB_DWC3 is not set
CONFIG_USB_CHIPIDEA=m
CONFIG_USB_CHIPIDEA_UDC=y
# CONFIG_USB_CHIPIDEA_HOST is not set
# CONFIG_USB_CHIPIDEA_DEBUG is not set

#
# USB port drivers
#
# CONFIG_USB_SERIAL is not set

#
# USB Miscellaneous drivers
#
# CONFIG_USB_EMI62 is not set
CONFIG_USB_EMI26=m
CONFIG_USB_ADUTUX=m
CONFIG_USB_SEVSEG=m
CONFIG_USB_RIO500=m
# CONFIG_USB_LEGOTOWER is not set
CONFIG_USB_LCD=m
CONFIG_USB_LED=m
CONFIG_USB_CYPRESS_CY7C63=m
CONFIG_USB_CYTHERM=m
# CONFIG_USB_IDMOUSE is not set
CONFIG_USB_FTDI_ELAN=m
# CONFIG_USB_APPLEDISPLAY is not set
CONFIG_USB_SISUSBVGA=m
# CONFIG_USB_SISUSBVGA_CON is not set
CONFIG_USB_LD=m
# CONFIG_USB_TRANCEVIBRATOR is not set
# CONFIG_USB_IOWARRIOR is not set
CONFIG_USB_TEST=m
CONFIG_USB_EHSET_TEST_FIXTURE=m
# CONFIG_USB_ISIGHTFW is not set
CONFIG_USB_YUREX=m
CONFIG_USB_EZUSB_FX2=m
CONFIG_USB_HSIC_USB3503=m
# CONFIG_USB_ATM is not set

#
# USB Physical Layer drivers
#
CONFIG_USB_PHY=y
# CONFIG_NOP_USB_XCEIV is not set
# CONFIG_AM335X_PHY_USB is not set
CONFIG_SAMSUNG_USBPHY=y
CONFIG_SAMSUNG_USB2PHY=y
# CONFIG_SAMSUNG_USB3PHY is not set
# CONFIG_USB_GPIO_VBUS is not set
CONFIG_USB_ISP1301=m
# CONFIG_USB_RCAR_PHY is not set
CONFIG_USB_GADGET=m
# CONFIG_USB_GADGET_DEBUG is not set
# CONFIG_USB_GADGET_DEBUG_FILES is not set
# CONFIG_USB_GADGET_DEBUG_FS is not set
CONFIG_USB_GADGET_VBUS_DRAW=2
CONFIG_USB_GADGET_STORAGE_NUM_BUFFERS=2

#
# USB Peripheral Controller
#
CONFIG_USB_FOTG210_UDC=m
CONFIG_USB_R8A66597=m
CONFIG_USB_PXA27X=m
CONFIG_USB_MV_UDC=m
# CONFIG_USB_MV_U3D is not set
# CONFIG_USB_M66592 is not set
# CONFIG_USB_AMD5536UDC is not set
CONFIG_USB_NET2272=m
# CONFIG_USB_NET2272_DMA is not set
CONFIG_USB_NET2280=m
CONFIG_USB_GOKU=m
CONFIG_USB_EG20T=m
# CONFIG_USB_DUMMY_HCD is not set
CONFIG_USB_LIBCOMPOSITE=m
CONFIG_USB_F_ACM=m
CONFIG_USB_F_SS_LB=m
CONFIG_USB_U_SERIAL=m
CONFIG_USB_U_ETHER=m
CONFIG_USB_U_RNDIS=m
CONFIG_USB_F_SERIAL=m
CONFIG_USB_F_OBEX=m
CONFIG_USB_F_NCM=m
CONFIG_USB_F_ECM=m
CONFIG_USB_F_PHONET=m
CONFIG_USB_F_EEM=m
CONFIG_USB_F_SUBSET=m
CONFIG_USB_CONFIGFS=m
# CONFIG_USB_CONFIGFS_SERIAL is not set
# CONFIG_USB_CONFIGFS_ACM is not set
CONFIG_USB_CONFIGFS_OBEX=y
# CONFIG_USB_CONFIGFS_NCM is not set
# CONFIG_USB_CONFIGFS_ECM is not set
CONFIG_USB_CONFIGFS_ECM_SUBSET=y
# CONFIG_USB_CONFIGFS_RNDIS is not set
CONFIG_USB_CONFIGFS_EEM=y
# CONFIG_USB_CONFIGFS_PHONET is not set
CONFIG_USB_ZERO=m
CONFIG_USB_ZERO_HNPTEST=y
CONFIG_USB_ETH=m
# CONFIG_USB_ETH_RNDIS is not set
# CONFIG_USB_ETH_EEM is not set
CONFIG_USB_G_NCM=m
# CONFIG_USB_GADGETFS is not set
CONFIG_USB_FUNCTIONFS=m
# CONFIG_USB_FUNCTIONFS_ETH is not set
CONFIG_USB_FUNCTIONFS_RNDIS=y
CONFIG_USB_FUNCTIONFS_GENERIC=y
# CONFIG_USB_MASS_STORAGE is not set
CONFIG_USB_G_SERIAL=m
CONFIG_USB_G_PRINTER=m
CONFIG_USB_CDC_COMPOSITE=m
CONFIG_USB_G_NOKIA=m
CONFIG_USB_G_ACM_MS=m
CONFIG_USB_G_MULTI=m
# CONFIG_USB_G_MULTI_RNDIS is not set
CONFIG_USB_G_MULTI_CDC=y
CONFIG_USB_G_HID=m
CONFIG_USB_G_DBGP=m
CONFIG_USB_G_DBGP_PRINTK=y
# CONFIG_USB_G_DBGP_SERIAL is not set
CONFIG_UWB=y
CONFIG_UWB_HWA=m
CONFIG_UWB_WHCI=y
CONFIG_UWB_I1480U=m
# CONFIG_MMC is not set
CONFIG_MEMSTICK=m
CONFIG_MEMSTICK_DEBUG=y

#
# MemoryStick drivers
#
# CONFIG_MEMSTICK_UNSAFE_RESUME is not set
# CONFIG_MSPRO_BLOCK is not set
# CONFIG_MS_BLOCK is not set

#
# MemoryStick Host Controller Drivers
#
# CONFIG_MEMSTICK_TIFM_MS is not set
# CONFIG_MEMSTICK_JMICRON_38X is not set
CONFIG_MEMSTICK_R592=m
# CONFIG_MEMSTICK_REALTEK_PCI is not set
CONFIG_NEW_LEDS=y
CONFIG_LEDS_CLASS=y

#
# LED drivers
#
CONFIG_LEDS_88PM860X=y
CONFIG_LEDS_LM3530=y
CONFIG_LEDS_LM3642=y
CONFIG_LEDS_NET48XX=m
CONFIG_LEDS_WRAP=m
CONFIG_LEDS_PCA9532=y
CONFIG_LEDS_PCA9532_GPIO=y
# CONFIG_LEDS_GPIO is not set
# CONFIG_LEDS_LP3944 is not set
CONFIG_LEDS_LP55XX_COMMON=y
# CONFIG_LEDS_LP5521 is not set
# CONFIG_LEDS_LP5523 is not set
CONFIG_LEDS_LP5562=y
CONFIG_LEDS_LP8501=m
CONFIG_LEDS_CLEVO_MAIL=m
# CONFIG_LEDS_PCA955X is not set
CONFIG_LEDS_PCA963X=y
CONFIG_LEDS_WM831X_STATUS=m
CONFIG_LEDS_DA903X=m
CONFIG_LEDS_PWM=m
# CONFIG_LEDS_REGULATOR is not set
CONFIG_LEDS_BD2802=y
CONFIG_LEDS_INTEL_SS4200=y
# CONFIG_LEDS_LT3593 is not set
CONFIG_LEDS_ADP5520=m
CONFIG_LEDS_DELL_NETBOOKS=y
# CONFIG_LEDS_MC13783 is not set
CONFIG_LEDS_TCA6507=y
CONFIG_LEDS_MAX8997=m
CONFIG_LEDS_LM355x=y
CONFIG_LEDS_OT200=m
# CONFIG_LEDS_BLINKM is not set

#
# LED Triggers
#
CONFIG_LEDS_TRIGGERS=y
CONFIG_LEDS_TRIGGER_TIMER=y
# CONFIG_LEDS_TRIGGER_ONESHOT is not set
# CONFIG_LEDS_TRIGGER_IDE_DISK is not set
# CONFIG_LEDS_TRIGGER_HEARTBEAT is not set
CONFIG_LEDS_TRIGGER_BACKLIGHT=y
# CONFIG_LEDS_TRIGGER_CPU is not set
CONFIG_LEDS_TRIGGER_GPIO=m
# CONFIG_LEDS_TRIGGER_DEFAULT_ON is not set

#
# iptables trigger is under Netfilter config (LED target)
#
# CONFIG_LEDS_TRIGGER_TRANSIENT is not set
CONFIG_LEDS_TRIGGER_CAMERA=y
CONFIG_ACCESSIBILITY=y
# CONFIG_A11Y_BRAILLE_CONSOLE is not set
CONFIG_INFINIBAND=m
CONFIG_INFINIBAND_USER_MAD=m
CONFIG_INFINIBAND_USER_ACCESS=m
CONFIG_INFINIBAND_USER_MEM=y
CONFIG_INFINIBAND_MTHCA=m
CONFIG_INFINIBAND_MTHCA_DEBUG=y
# CONFIG_INFINIBAND_SRP is not set
# CONFIG_EDAC is not set
CONFIG_RTC_LIB=y
CONFIG_RTC_CLASS=y
CONFIG_RTC_HCTOSYS=y
CONFIG_RTC_SYSTOHC=y
CONFIG_RTC_HCTOSYS_DEVICE="rtc0"
# CONFIG_RTC_DEBUG is not set

#
# RTC interfaces
#
# CONFIG_RTC_INTF_SYSFS is not set
# CONFIG_RTC_INTF_PROC is not set
# CONFIG_RTC_INTF_DEV is not set
# CONFIG_RTC_DRV_TEST is not set

#
# I2C RTC drivers
#
CONFIG_RTC_DRV_88PM860X=m
CONFIG_RTC_DRV_DS1307=y
CONFIG_RTC_DRV_DS1374=m
CONFIG_RTC_DRV_DS1672=y
CONFIG_RTC_DRV_DS3232=y
CONFIG_RTC_DRV_MAX6900=m
CONFIG_RTC_DRV_MAX8907=y
CONFIG_RTC_DRV_MAX8925=y
# CONFIG_RTC_DRV_MAX8998 is not set
CONFIG_RTC_DRV_MAX8997=m
CONFIG_RTC_DRV_RS5C372=m
# CONFIG_RTC_DRV_ISL1208 is not set
CONFIG_RTC_DRV_ISL12022=m
CONFIG_RTC_DRV_X1205=y
CONFIG_RTC_DRV_PCF2127=y
# CONFIG_RTC_DRV_PCF8523 is not set
CONFIG_RTC_DRV_PCF8563=m
# CONFIG_RTC_DRV_PCF8583 is not set
# CONFIG_RTC_DRV_M41T80 is not set
CONFIG_RTC_DRV_BQ32K=y
CONFIG_RTC_DRV_TPS6586X=y
# CONFIG_RTC_DRV_TPS65910 is not set
CONFIG_RTC_DRV_RC5T583=y
CONFIG_RTC_DRV_S35390A=y
# CONFIG_RTC_DRV_FM3130 is not set
CONFIG_RTC_DRV_RX8581=m
CONFIG_RTC_DRV_RX8025=y
# CONFIG_RTC_DRV_EM3027 is not set
CONFIG_RTC_DRV_RV3029C2=y

#
# SPI RTC drivers
#

#
# Platform RTC drivers
#
CONFIG_RTC_DRV_CMOS=m
CONFIG_RTC_DRV_DS1286=y
# CONFIG_RTC_DRV_DS1511 is not set
CONFIG_RTC_DRV_DS1553=y
CONFIG_RTC_DRV_DS1742=y
CONFIG_RTC_DRV_DA9055=y
CONFIG_RTC_DRV_STK17TA8=m
CONFIG_RTC_DRV_M48T86=y
CONFIG_RTC_DRV_M48T35=y
CONFIG_RTC_DRV_M48T59=y
CONFIG_RTC_DRV_MSM6242=y
CONFIG_RTC_DRV_BQ4802=y
# CONFIG_RTC_DRV_RP5C01 is not set
CONFIG_RTC_DRV_V3020=m
# CONFIG_RTC_DRV_DS2404 is not set
# CONFIG_RTC_DRV_WM831X is not set
CONFIG_RTC_DRV_PCF50633=m

#
# on-CPU RTC drivers
#
CONFIG_RTC_DRV_MC13XXX=m
# CONFIG_RTC_DRV_MOXART is not set

#
# HID Sensor RTC drivers
#
# CONFIG_RTC_DRV_HID_SENSOR_TIME is not set
# CONFIG_DMADEVICES is not set
CONFIG_AUXDISPLAY=y
CONFIG_UIO=y
CONFIG_UIO_CIF=m
CONFIG_UIO_PDRV_GENIRQ=y
CONFIG_UIO_DMEM_GENIRQ=m
# CONFIG_UIO_AEC is not set
CONFIG_UIO_SERCOS3=m
CONFIG_UIO_PCI_GENERIC=m
# CONFIG_UIO_NETX is not set
CONFIG_UIO_MF624=y
# CONFIG_VIRT_DRIVERS is not set
CONFIG_VIRTIO=y

#
# Virtio drivers
#
# CONFIG_VIRTIO_PCI is not set
# CONFIG_VIRTIO_BALLOON is not set
CONFIG_VIRTIO_MMIO=m
# CONFIG_VIRTIO_MMIO_CMDLINE_DEVICES is not set

#
# Microsoft Hyper-V guest support
#
# CONFIG_HYPERV is not set
# CONFIG_STAGING is not set
CONFIG_X86_PLATFORM_DEVICES=y
CONFIG_ACER_WMI=y
CONFIG_ACERHDF=y
CONFIG_ASUS_LAPTOP=m
CONFIG_CHROMEOS_LAPTOP=y
# CONFIG_DELL_WMI is not set
CONFIG_DELL_WMI_AIO=y
# CONFIG_FUJITSU_LAPTOP is not set
# CONFIG_FUJITSU_TABLET is not set
CONFIG_TC1100_WMI=y
# CONFIG_HP_ACCEL is not set
CONFIG_HP_WMI=y
CONFIG_PANASONIC_LAPTOP=y
# CONFIG_THINKPAD_ACPI is not set
CONFIG_SENSORS_HDAPS=y
# CONFIG_EEEPC_LAPTOP is not set
CONFIG_ASUS_WMI=y
# CONFIG_ASUS_NB_WMI is not set
# CONFIG_EEEPC_WMI is not set
CONFIG_ACPI_WMI=y
CONFIG_MSI_WMI=y
# CONFIG_TOPSTAR_LAPTOP is not set
CONFIG_ACPI_TOSHIBA=m
CONFIG_TOSHIBA_BT_RFKILL=m
CONFIG_ACPI_CMPC=y
CONFIG_INTEL_IPS=m
CONFIG_IBM_RTL=m
# CONFIG_XO15_EBOOK is not set
# CONFIG_SAMSUNG_LAPTOP is not set
CONFIG_MXM_WMI=y
CONFIG_SAMSUNG_Q10=m
CONFIG_APPLE_GMUX=y
CONFIG_INTEL_RST=m
# CONFIG_INTEL_SMARTCONNECT is not set
# CONFIG_PVPANIC is not set

#
# Hardware Spinlock drivers
#
CONFIG_CLKSRC_I8253=y
CONFIG_CLKEVT_I8253=y
CONFIG_I8253_LOCK=y
CONFIG_CLKBLD_I8253=y
# CONFIG_ARM_ARCH_TIMER_EVTSTREAM is not set
CONFIG_MAILBOX=y
CONFIG_IOMMU_SUPPORT=y
# CONFIG_INTEL_IOMMU is not set

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
CONFIG_IIO_ST_ACCEL_3AXIS=m
CONFIG_IIO_ST_ACCEL_I2C_3AXIS=m

#
# Analog to digital converters
#
CONFIG_MAX1363=m
CONFIG_NAU7802=m
# CONFIG_TI_ADC081C is not set
CONFIG_TI_AM335X_ADC=m

#
# Amplifiers
#

#
# Hid Sensor IIO Common
#
CONFIG_HID_SENSOR_IIO_COMMON=m
CONFIG_HID_SENSOR_IIO_TRIGGER=m
CONFIG_HID_SENSOR_ENUM_BASE_QUIRKS=y
CONFIG_IIO_ST_SENSORS_I2C=m
CONFIG_IIO_ST_SENSORS_CORE=m

#
# Digital to analog converters
#
CONFIG_AD5064=m
CONFIG_AD5380=m
CONFIG_AD5446=m
CONFIG_MAX517=m
CONFIG_MCP4725=m

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
CONFIG_ITG3200=m

#
# Inertial measurement units
#
CONFIG_INV_MPU6050_IIO=m

#
# Light sensors
#
CONFIG_ADJD_S311=m
# CONFIG_APDS9300 is not set
CONFIG_HID_SENSOR_ALS=m
# CONFIG_SENSORS_TSL2563 is not set
CONFIG_VCNL4000=m

#
# Magnetometer sensors
#
CONFIG_AK8975=m
CONFIG_HID_SENSOR_MAGNETOMETER_3D=m
CONFIG_IIO_ST_MAGN_3AXIS=m
CONFIG_IIO_ST_MAGN_I2C_3AXIS=m

#
# Triggers - standalone
#
# CONFIG_IIO_INTERRUPT_TRIGGER is not set
CONFIG_IIO_SYSFS_TRIGGER=m

#
# Pressure sensors
#
CONFIG_IIO_ST_PRESS=m
CONFIG_IIO_ST_PRESS_I2C=m

#
# Temperature sensors
#
CONFIG_TMP006=m
# CONFIG_NTB is not set
CONFIG_VME_BUS=y

#
# VME Bridge Drivers
#
CONFIG_VME_CA91CX42=m
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
CONFIG_IPACK_BUS=y
CONFIG_BOARD_TPCI200=y
CONFIG_SERIAL_IPOCTAL=m
# CONFIG_RESET_CONTROLLER is not set
CONFIG_FMC=m
CONFIG_FMC_FAKEDEV=m
CONFIG_FMC_TRIVIAL=m
CONFIG_FMC_WRITE_EEPROM=m
# CONFIG_FMC_CHARDEV is not set

#
# Firmware Drivers
#
CONFIG_EDD=m
CONFIG_EDD_OFF=y
CONFIG_FIRMWARE_MEMMAP=y
CONFIG_DELL_RBU=m
# CONFIG_DCDBAS is not set
# CONFIG_DMIID is not set
# CONFIG_DMI_SYSFS is not set
CONFIG_ISCSI_IBFT_FIND=y
CONFIG_GOOGLE_FIRMWARE=y

#
# Google Firmware Drivers
#
CONFIG_GOOGLE_SMI=y
# CONFIG_GOOGLE_MEMCONSOLE is not set

#
# EFI (Extensible Firmware Interface) Support
#
CONFIG_EFI_VARS=y
CONFIG_EFI_VARS_PSTORE=y
CONFIG_EFI_VARS_PSTORE_DEFAULT_DISABLE=y

#
# File systems
#
CONFIG_DCACHE_WORD_ACCESS=y
CONFIG_EXT2_FS=y
CONFIG_EXT2_FS_XATTR=y
CONFIG_EXT2_FS_POSIX_ACL=y
# CONFIG_EXT2_FS_SECURITY is not set
# CONFIG_EXT2_FS_XIP is not set
CONFIG_EXT3_FS=y
CONFIG_EXT3_DEFAULTS_TO_ORDERED=y
CONFIG_EXT3_FS_XATTR=y
CONFIG_EXT3_FS_POSIX_ACL=y
CONFIG_EXT3_FS_SECURITY=y
CONFIG_EXT4_FS=y
CONFIG_EXT4_FS_POSIX_ACL=y
CONFIG_EXT4_FS_SECURITY=y
CONFIG_EXT4_DEBUG=y
CONFIG_JBD=y
# CONFIG_JBD_DEBUG is not set
CONFIG_JBD2=y
# CONFIG_JBD2_DEBUG is not set
CONFIG_FS_MBCACHE=y
# CONFIG_REISERFS_FS is not set
# CONFIG_JFS_FS is not set
CONFIG_XFS_FS=m
# CONFIG_XFS_QUOTA is not set
# CONFIG_XFS_POSIX_ACL is not set
# CONFIG_XFS_RT is not set
CONFIG_XFS_WARN=y
# CONFIG_XFS_DEBUG is not set
# CONFIG_OCFS2_FS is not set
# CONFIG_BTRFS_FS is not set
CONFIG_NILFS2_FS=y
CONFIG_FS_POSIX_ACL=y
CONFIG_EXPORTFS=m
CONFIG_FILE_LOCKING=y
CONFIG_FSNOTIFY=y
CONFIG_DNOTIFY=y
CONFIG_INOTIFY_USER=y
CONFIG_FANOTIFY=y
# CONFIG_FANOTIFY_ACCESS_PERMISSIONS is not set
CONFIG_QUOTA=y
CONFIG_QUOTA_NETLINK_INTERFACE=y
CONFIG_PRINT_QUOTA_WARNING=y
CONFIG_QUOTA_DEBUG=y
CONFIG_QUOTA_TREE=y
# CONFIG_QFMT_V1 is not set
CONFIG_QFMT_V2=y
CONFIG_QUOTACTL=y
# CONFIG_AUTOFS4_FS is not set
CONFIG_FUSE_FS=m
CONFIG_CUSE=m
CONFIG_GENERIC_ACL=y

#
# Caches
#
# CONFIG_FSCACHE is not set

#
# CD-ROM/DVD Filesystems
#
CONFIG_ISO9660_FS=m
CONFIG_JOLIET=y
CONFIG_ZISOFS=y
# CONFIG_UDF_FS is not set

#
# DOS/FAT/NT Filesystems
#
CONFIG_FAT_FS=m
CONFIG_MSDOS_FS=m
CONFIG_VFAT_FS=m
CONFIG_FAT_DEFAULT_CODEPAGE=437
CONFIG_FAT_DEFAULT_IOCHARSET="iso8859-1"
CONFIG_NTFS_FS=y
CONFIG_NTFS_DEBUG=y
CONFIG_NTFS_RW=y

#
# Pseudo filesystems
#
CONFIG_PROC_FS=y
# CONFIG_PROC_KCORE is not set
CONFIG_PROC_SYSCTL=y
CONFIG_PROC_PAGE_MONITOR=y
CONFIG_SYSFS=y
CONFIG_TMPFS=y
CONFIG_TMPFS_POSIX_ACL=y
CONFIG_TMPFS_XATTR=y
# CONFIG_HUGETLBFS is not set
# CONFIG_HUGETLB_PAGE is not set
CONFIG_CONFIGFS_FS=m
CONFIG_MISC_FILESYSTEMS=y
# CONFIG_ADFS_FS is not set
CONFIG_AFFS_FS=y
CONFIG_ECRYPT_FS=m
# CONFIG_ECRYPT_FS_MESSAGING is not set
CONFIG_HFS_FS=m
CONFIG_HFSPLUS_FS=m
CONFIG_HFSPLUS_FS_POSIX_ACL=y
CONFIG_BEFS_FS=y
# CONFIG_BEFS_DEBUG is not set
CONFIG_BFS_FS=m
CONFIG_EFS_FS=y
# CONFIG_JFFS2_FS is not set
CONFIG_LOGFS=y
CONFIG_CRAMFS=m
CONFIG_SQUASHFS=y
# CONFIG_SQUASHFS_XATTR is not set
# CONFIG_SQUASHFS_ZLIB is not set
CONFIG_SQUASHFS_LZO=y
# CONFIG_SQUASHFS_XZ is not set
# CONFIG_SQUASHFS_4K_DEVBLK_SIZE is not set
CONFIG_SQUASHFS_EMBEDDED=y
CONFIG_SQUASHFS_FRAGMENT_CACHE_SIZE=3
# CONFIG_VXFS_FS is not set
CONFIG_MINIX_FS=y
CONFIG_OMFS_FS=y
CONFIG_HPFS_FS=m
# CONFIG_QNX4FS_FS is not set
CONFIG_QNX6FS_FS=m
# CONFIG_QNX6FS_DEBUG is not set
CONFIG_ROMFS_FS=m
CONFIG_ROMFS_BACKED_BY_BLOCK=y
# CONFIG_ROMFS_BACKED_BY_MTD is not set
# CONFIG_ROMFS_BACKED_BY_BOTH is not set
CONFIG_ROMFS_ON_BLOCK=y
CONFIG_PSTORE=y
CONFIG_PSTORE_CONSOLE=y
CONFIG_PSTORE_FTRACE=y
CONFIG_PSTORE_RAM=m
CONFIG_SYSV_FS=m
CONFIG_UFS_FS=y
# CONFIG_UFS_FS_WRITE is not set
# CONFIG_UFS_DEBUG is not set
CONFIG_F2FS_FS=y
# CONFIG_F2FS_STAT_FS is not set
CONFIG_F2FS_FS_XATTR=y
# CONFIG_F2FS_FS_POSIX_ACL is not set
CONFIG_F2FS_FS_SECURITY=y
# CONFIG_EFIVAR_FS is not set
# CONFIG_NETWORK_FILESYSTEMS is not set
CONFIG_NLS=y
CONFIG_NLS_DEFAULT="iso8859-1"
# CONFIG_NLS_CODEPAGE_437 is not set
CONFIG_NLS_CODEPAGE_737=m
CONFIG_NLS_CODEPAGE_775=m
CONFIG_NLS_CODEPAGE_850=y
# CONFIG_NLS_CODEPAGE_852 is not set
# CONFIG_NLS_CODEPAGE_855 is not set
CONFIG_NLS_CODEPAGE_857=y
CONFIG_NLS_CODEPAGE_860=y
CONFIG_NLS_CODEPAGE_861=y
CONFIG_NLS_CODEPAGE_862=y
CONFIG_NLS_CODEPAGE_863=m
CONFIG_NLS_CODEPAGE_864=y
CONFIG_NLS_CODEPAGE_865=y
# CONFIG_NLS_CODEPAGE_866 is not set
# CONFIG_NLS_CODEPAGE_869 is not set
# CONFIG_NLS_CODEPAGE_936 is not set
CONFIG_NLS_CODEPAGE_950=m
CONFIG_NLS_CODEPAGE_932=m
CONFIG_NLS_CODEPAGE_949=y
CONFIG_NLS_CODEPAGE_874=m
CONFIG_NLS_ISO8859_8=y
CONFIG_NLS_CODEPAGE_1250=m
CONFIG_NLS_CODEPAGE_1251=y
CONFIG_NLS_ASCII=y
# CONFIG_NLS_ISO8859_1 is not set
CONFIG_NLS_ISO8859_2=y
CONFIG_NLS_ISO8859_3=m
CONFIG_NLS_ISO8859_4=m
CONFIG_NLS_ISO8859_5=m
# CONFIG_NLS_ISO8859_6 is not set
CONFIG_NLS_ISO8859_7=y
CONFIG_NLS_ISO8859_9=m
# CONFIG_NLS_ISO8859_13 is not set
CONFIG_NLS_ISO8859_14=m
CONFIG_NLS_ISO8859_15=y
CONFIG_NLS_KOI8_R=m
CONFIG_NLS_KOI8_U=m
# CONFIG_NLS_MAC_ROMAN is not set
# CONFIG_NLS_MAC_CELTIC is not set
# CONFIG_NLS_MAC_CENTEURO is not set
# CONFIG_NLS_MAC_CROATIAN is not set
CONFIG_NLS_MAC_CYRILLIC=y
CONFIG_NLS_MAC_GAELIC=y
# CONFIG_NLS_MAC_GREEK is not set
# CONFIG_NLS_MAC_ICELAND is not set
CONFIG_NLS_MAC_INUIT=m
# CONFIG_NLS_MAC_ROMANIAN is not set
CONFIG_NLS_MAC_TURKISH=y
CONFIG_NLS_UTF8=m

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
# CONFIG_DEBUG_FORCE_WEAK_PER_CPU is not set
CONFIG_MAGIC_SYSRQ=y
CONFIG_DEBUG_KERNEL=y

#
# Memory Debugging
#
# CONFIG_DEBUG_PAGEALLOC is not set
# CONFIG_DEBUG_OBJECTS is not set
# CONFIG_SLUB_DEBUG_ON is not set
CONFIG_SLUB_STATS=y
CONFIG_HAVE_DEBUG_KMEMLEAK=y
# CONFIG_DEBUG_KMEMLEAK is not set
# CONFIG_DEBUG_STACK_USAGE is not set
# CONFIG_DEBUG_VM is not set
# CONFIG_DEBUG_VIRTUAL is not set
CONFIG_DEBUG_MEMORY_INIT=y
# CONFIG_DEBUG_PER_CPU_MAPS is not set
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
CONFIG_SCHED_DEBUG=y
# CONFIG_SCHEDSTATS is not set
# CONFIG_TIMER_STATS is not set

#
# Lock Debugging (spinlocks, mutexes, etc...)
#
# CONFIG_DEBUG_RT_MUTEXES is not set
# CONFIG_RT_MUTEX_TESTER is not set
# CONFIG_DEBUG_SPINLOCK is not set
# CONFIG_DEBUG_MUTEXES is not set
# CONFIG_DEBUG_WW_MUTEX_SLOWPATH is not set
# CONFIG_DEBUG_LOCK_ALLOC is not set
# CONFIG_PROVE_LOCKING is not set
# CONFIG_LOCK_STAT is not set
CONFIG_DEBUG_ATOMIC_SLEEP=y
# CONFIG_DEBUG_LOCKING_API_SELFTESTS is not set
CONFIG_TRACE_IRQFLAGS=y
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
# CONFIG_RCU_CPU_STALL_INFO is not set
# CONFIG_RCU_TRACE is not set
# CONFIG_DEBUG_BLOCK_EXT_DEVT is not set
# CONFIG_NOTIFIER_ERROR_INJECTION is not set
# CONFIG_FAULT_INJECTION is not set
# CONFIG_LATENCYTOP is not set
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
# CONFIG_FUNCTION_GRAPH_TRACER is not set
CONFIG_IRQSOFF_TRACER=y
# CONFIG_SCHED_TRACER is not set
# CONFIG_FTRACE_SYSCALLS is not set
CONFIG_TRACER_SNAPSHOT=y
CONFIG_TRACER_SNAPSHOT_PER_CPU_SWAP=y
CONFIG_TRACE_BRANCH_PROFILING=y
# CONFIG_BRANCH_PROFILE_NONE is not set
# CONFIG_PROFILE_ANNOTATED_BRANCHES is not set
CONFIG_PROFILE_ALL_BRANCHES=y
CONFIG_TRACING_BRANCHES=y
CONFIG_BRANCH_TRACER=y
CONFIG_STACK_TRACER=y
CONFIG_BLK_DEV_IO_TRACE=y
# CONFIG_KPROBE_EVENT is not set
CONFIG_UPROBE_EVENT=y
CONFIG_PROBE_EVENTS=y
CONFIG_DYNAMIC_FTRACE=y
CONFIG_DYNAMIC_FTRACE_WITH_REGS=y
# CONFIG_FUNCTION_PROFILER is not set
CONFIG_FTRACE_MCOUNT_RECORD=y
# CONFIG_FTRACE_STARTUP_TEST is not set
# CONFIG_MMIOTRACE is not set
# CONFIG_RING_BUFFER_BENCHMARK is not set
# CONFIG_RING_BUFFER_STARTUP_TEST is not set

#
# Runtime Testing
#
# CONFIG_LKDTM is not set
# CONFIG_TEST_LIST_SORT is not set
# CONFIG_KPROBES_SANITY_TEST is not set
# CONFIG_BACKTRACE_SELF_TEST is not set
# CONFIG_RBTREE_TEST is not set
# CONFIG_INTERVAL_TREE_TEST is not set
# CONFIG_ATOMIC64_SELFTEST is not set
# CONFIG_TEST_STRING_HELPERS is not set
# CONFIG_TEST_KSTRTOX is not set
CONFIG_PROVIDE_OHCI1394_DMA_INIT=y
CONFIG_FIREWIRE_OHCI_REMOTE_DMA=y
CONFIG_DMA_API_DEBUG=y
# CONFIG_SAMPLES is not set
CONFIG_HAVE_ARCH_KGDB=y
# CONFIG_KGDB is not set
# CONFIG_STRICT_DEVMEM is not set
# CONFIG_X86_VERBOSE_BOOTUP is not set
CONFIG_EARLY_PRINTK=y
# CONFIG_EARLY_PRINTK_DBGP is not set
# CONFIG_X86_PTDUMP is not set
CONFIG_DEBUG_RODATA=y
CONFIG_DEBUG_RODATA_TEST=y
# CONFIG_DEBUG_SET_MODULE_RONX is not set
# CONFIG_DEBUG_NX_TEST is not set
CONFIG_DOUBLEFAULT=y
# CONFIG_DEBUG_TLBFLUSH is not set
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
# CONFIG_TRUSTED_KEYS is not set
CONFIG_ENCRYPTED_KEYS=y
# CONFIG_KEYS_DEBUG_PROC_KEYS is not set
CONFIG_SECURITY_DMESG_RESTRICT=y
CONFIG_SECURITY=y
CONFIG_SECURITYFS=y
CONFIG_SECURITY_NETWORK=y
# CONFIG_SECURITY_NETWORK_XFRM is not set
CONFIG_SECURITY_PATH=y
# CONFIG_SECURITY_TOMOYO is not set
CONFIG_SECURITY_APPARMOR=y
CONFIG_SECURITY_APPARMOR_BOOTPARAM_VALUE=1
# CONFIG_SECURITY_APPARMOR_HASH is not set
# CONFIG_SECURITY_YAMA is not set
CONFIG_INTEGRITY=y
CONFIG_INTEGRITY_SIGNATURE=y
CONFIG_INTEGRITY_AUDIT=y
# CONFIG_INTEGRITY_ASYMMETRIC_KEYS is not set
CONFIG_IMA=y
CONFIG_IMA_MEASURE_PCR_IDX=10
# CONFIG_IMA_APPRAISE is not set
CONFIG_EVM=y
CONFIG_EVM_HMAC_VERSION=2
# CONFIG_DEFAULT_SECURITY_APPARMOR is not set
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
CONFIG_CRYPTO_PCOMP=m
CONFIG_CRYPTO_PCOMP2=y
CONFIG_CRYPTO_MANAGER=y
CONFIG_CRYPTO_MANAGER2=y
CONFIG_CRYPTO_USER=y
# CONFIG_CRYPTO_MANAGER_DISABLE_TESTS is not set
CONFIG_CRYPTO_GF128MUL=y
CONFIG_CRYPTO_NULL=y
CONFIG_CRYPTO_PCRYPT=m
CONFIG_CRYPTO_WORKQUEUE=y
# CONFIG_CRYPTO_CRYPTD is not set
CONFIG_CRYPTO_AUTHENC=y
# CONFIG_CRYPTO_TEST is not set

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
CONFIG_CRYPTO_CTS=m
CONFIG_CRYPTO_ECB=y
CONFIG_CRYPTO_LRW=y
CONFIG_CRYPTO_PCBC=m
CONFIG_CRYPTO_XTS=m

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
CONFIG_CRYPTO_CRC32=m
CONFIG_CRYPTO_CRC32_PCLMUL=y
CONFIG_CRYPTO_CRCT10DIF=m
CONFIG_CRYPTO_GHASH=y
# CONFIG_CRYPTO_MD4 is not set
CONFIG_CRYPTO_MD5=y
CONFIG_CRYPTO_MICHAEL_MIC=m
CONFIG_CRYPTO_RMD128=m
CONFIG_CRYPTO_RMD160=y
CONFIG_CRYPTO_RMD256=y
# CONFIG_CRYPTO_RMD320 is not set
CONFIG_CRYPTO_SHA1=y
CONFIG_CRYPTO_SHA256=y
CONFIG_CRYPTO_SHA512=m
CONFIG_CRYPTO_TGR192=y
# CONFIG_CRYPTO_WP512 is not set

#
# Ciphers
#
CONFIG_CRYPTO_AES=y
CONFIG_CRYPTO_AES_586=m
# CONFIG_CRYPTO_AES_NI_INTEL is not set
CONFIG_CRYPTO_ANUBIS=m
CONFIG_CRYPTO_ARC4=m
CONFIG_CRYPTO_BLOWFISH=m
CONFIG_CRYPTO_BLOWFISH_COMMON=m
CONFIG_CRYPTO_CAMELLIA=m
CONFIG_CRYPTO_CAST_COMMON=y
CONFIG_CRYPTO_CAST5=y
CONFIG_CRYPTO_CAST6=m
CONFIG_CRYPTO_DES=m
# CONFIG_CRYPTO_FCRYPT is not set
CONFIG_CRYPTO_KHAZAD=y
# CONFIG_CRYPTO_SALSA20 is not set
# CONFIG_CRYPTO_SALSA20_586 is not set
CONFIG_CRYPTO_SEED=m
CONFIG_CRYPTO_SERPENT=m
# CONFIG_CRYPTO_SERPENT_SSE2_586 is not set
CONFIG_CRYPTO_TEA=m
# CONFIG_CRYPTO_TWOFISH is not set
CONFIG_CRYPTO_TWOFISH_COMMON=y
CONFIG_CRYPTO_TWOFISH_586=y

#
# Compression
#
CONFIG_CRYPTO_DEFLATE=y
CONFIG_CRYPTO_ZLIB=m
# CONFIG_CRYPTO_LZO is not set
# CONFIG_CRYPTO_LZ4 is not set
CONFIG_CRYPTO_LZ4HC=y

#
# Random Number Generation
#
# CONFIG_CRYPTO_ANSI_CPRNG is not set
CONFIG_CRYPTO_USER_API=y
CONFIG_CRYPTO_USER_API_HASH=y
# CONFIG_CRYPTO_USER_API_SKCIPHER is not set
# CONFIG_CRYPTO_HW is not set
CONFIG_ASYMMETRIC_KEY_TYPE=m
# CONFIG_ASYMMETRIC_PUBLIC_KEY_SUBTYPE is not set
CONFIG_HAVE_KVM=y
CONFIG_VIRTUALIZATION=y
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
CONFIG_PERCPU_RWSEM=y
CONFIG_CRC_CCITT=y
CONFIG_CRC16=y
CONFIG_CRC_T10DIF=m
CONFIG_CRC_ITU_T=y
CONFIG_CRC32=y
# CONFIG_CRC32_SELFTEST is not set
CONFIG_CRC32_SLICEBY8=y
# CONFIG_CRC32_SLICEBY4 is not set
# CONFIG_CRC32_SARWATE is not set
# CONFIG_CRC32_BIT is not set
CONFIG_CRC7=y
CONFIG_LIBCRC32C=m
# CONFIG_CRC8 is not set
CONFIG_AUDIT_GENERIC=y
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
# CONFIG_XZ_DEC_SPARC is not set
CONFIG_XZ_DEC_BCJ=y
# CONFIG_XZ_DEC_TEST is not set
CONFIG_DECOMPRESS_GZIP=y
CONFIG_DECOMPRESS_BZIP2=y
CONFIG_DECOMPRESS_LZMA=y
CONFIG_DECOMPRESS_XZ=y
CONFIG_DECOMPRESS_LZO=y
CONFIG_DECOMPRESS_LZ4=y
CONFIG_GENERIC_ALLOCATOR=y
CONFIG_REED_SOLOMON=m
CONFIG_REED_SOLOMON_ENC8=y
CONFIG_REED_SOLOMON_DEC8=y
CONFIG_REED_SOLOMON_DEC16=y
CONFIG_BCH=y
CONFIG_BCH_CONST_PARAMS=y
CONFIG_BTREE=y
CONFIG_HAS_IOMEM=y
CONFIG_HAS_IOPORT=y
CONFIG_HAS_DMA=y
CONFIG_CPU_RMAP=y
CONFIG_DQL=y
CONFIG_NLATTR=y
CONFIG_ARCH_HAS_ATOMIC64_DEC_IF_POSITIVE=y
CONFIG_AVERAGE=y
CONFIG_CLZ_TAB=y
CONFIG_CORDIC=y
CONFIG_DDR=y
CONFIG_MPILIB=y
CONFIG_SIGNATURE=y
CONFIG_UCS2_STRING=y
CONFIG_FONT_SUPPORT=y
CONFIG_FONTS=y
CONFIG_FONT_8x8=y
CONFIG_FONT_8x16=y
# CONFIG_FONT_6x11 is not set
# CONFIG_FONT_7x14 is not set
# CONFIG_FONT_PEARL_8x8 is not set
CONFIG_FONT_ACORN_8x8=y
CONFIG_FONT_MINI_4x6=y
CONFIG_FONT_SUN8x16=y
CONFIG_FONT_SUN12x22=y
CONFIG_FONT_10x18=y

--vkogqOf2sHV7VnPd
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

_______________________________________________
LKP mailing list
LKP@linux.intel.com

--vkogqOf2sHV7VnPd--
