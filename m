Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752523Ab3FYIgm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Jun 2013 04:36:42 -0400
Received: from mga02.intel.com ([134.134.136.20]:48107 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752254Ab3FYIga (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Jun 2013 04:36:30 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,935,1363158000"; 
   d="log'?scan'208";a="355343689"
Date: Tue, 25 Jun 2013 16:36:15 +0800
From: Fengguang Wu <fengguang.wu@intel.com>
To: fengguang.wu@intel.com, Hans Verkuil <hans.verkuil@cisco.com>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>, linux-media@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: WARNING: at drivers/media/v4l2-core/v4l2-dev.c:775
 __video_register_device()
Message-ID: <20130625083615.GA25344@localhost>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="W/nzBZO5zC0uMSeA"
Content-Disposition: inline
User-Agent: Heirloom mailx 12.5 6/20/10
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--W/nzBZO5zC0uMSeA
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Greetings,

I got the below dmesg and the first bad commit is

commit 1c1d86a1ea07506c070cfb217a009d53990bdeb0
Author: Hans Verkuil <hans.verkuil@cisco.com>
Date:   Wed Jun 12 11:15:12 2013 -0300

    [media] v4l2: always require v4l2_dev, rename parent to dev_parent
    
    The last set of drivers still using the parent field of video_device instead
    of the v4l2_dev field have been converted, so v4l2_dev is now always set.
    A proper pointer to v4l2_dev is necessary these days otherwise the advanced
    debugging ioctls will not work when addressing sub-devices. It also ensures
    that the core can always go from a video_device struct to the top-level
    v4l2_device struct.
    There is still one single use case for the parent pointer: if there are
    multiple busses, each being the parent of one or more video nodes, and if
    they all share the same v4l2_device struct. In that case one still needs a
    parent pointer since the v4l2_device struct can only refer to a single
    parent device. The cx88 driver is one such case. Unfortunately, the cx88
    failed to set the parent pointer since 3.6. The next patch will correct this.
    In order to support this use-case the parent pointer is only renamed to
    dev_parent, not removed altogether. It has been renamed to ensure that the
    compiler will catch any (possibly out-of-tree) drivers that were missed during
    the conversion.
    
    Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
    Acked-by: Sakari Ailus <sakari.ailus@iki.fi>
    Acked-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
    Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>

[    1.203580] IR MCE Keyboard/mouse protocol handler initialized
[    1.205350] ------------[ cut here ]------------
[    1.206821] WARNING: at /c/kernel-tests/src/tip/drivers/media/v4l2-core/v4l2-dev.c:775 __video_register_device+0x55/0xbc7()
[    1.210029] CPU: 0 PID: 1 Comm: swapper Not tainted 3.10.0-rc7-00478-ge90d833 #28
[    1.212515] Hardware name: Bochs Bochs, BIOS Bochs 01/01/2011
[    1.214172]  ffffffff810a5186 ffff88000d865dd8 ffffffff8172b4f7 ffff88000d865e10
[    1.217032]  ffffffff810878a9 0000000000000000 ffffffffffffffff ffff8800062f7510
[    1.219851]  0000000000000002 0000000000000000 ffff88000d865e20 ffffffff81087983
[    1.222661] Call Trace:
[    1.223677]  [<ffffffff810a5186>] ? up+0xf/0x39
[    1.225121]  [<ffffffff8172b4f7>] dump_stack+0x19/0x1b
[    1.226679]  [<ffffffff810878a9>] warn_slowpath_common+0x5b/0x73
[    1.234994]  [<ffffffff81087983>] warn_slowpath_null+0x15/0x17
[    1.236722]  [<ffffffff8151cf7c>] __video_register_device+0x55/0xbc7
[    1.238555]  [<ffffffff8171fb86>] ? klist_init+0x31/0x40
[    1.240163]  [<ffffffff8136a944>] ? device_private_init+0x39/0x5e
[    1.241917]  [<ffffffff81537c8a>] fm_v4l2_init_video_device+0x89/0x1e8
[    1.243789]  [<ffffffff81f45951>] fm_drv_init+0x72/0xba
[    1.245353]  [<ffffffff81f458df>] ? wl1273_fm_radio_driver_init+0x12/0x12
[    1.247249]  [<ffffffff81f15db5>] do_one_initcall+0x99/0x12e
[    1.248911]  [<ffffffff81f15faf>] kernel_init_freeable+0x165/0x1e6
[    1.250739]  [<ffffffff81f1570c>] ? do_early_param+0x88/0x88
[    1.252414]  [<ffffffff8172046a>] ? rest_init+0xce/0xce
[    1.253954]  [<ffffffff81720473>] kernel_init+0x9/0xd1
[    1.255510]  [<ffffffff817314ba>] ret_from_fork+0x7a/0xb0
[    1.257120]  [<ffffffff8172046a>] ? rest_init+0xce/0xce
[    1.258734] ---[ end trace b4db00f0f9ac731d ]---

git bisect start e90d833ed71ac503e3b33b7ad970fc52cb67d9ed 9e895ace5d82df8929b16f58e9f515f6d54ab82d --
git bisect good 0bde6c3e4c4d594eb66200e37d9aec6ed45a8543  # 13:59     37+  [media] bttv: fix querystd
git bisect  bad 05959be7b646e8755a9339ad13e3b87849249f90  # 14:08      0-  [media] uvc: Depend on VIDEO_V4L2
git bisect good b60f9aa1a9fcf69df963c1f06ee0594d836f6760  # 14:14     37+  [media] f_uvc: add v4l2_device and replace parent with v4l2_dev
git bisect  bad 8b0706802fede74a2ee0341499f0b4586118a7d3  # 14:15      0-  [media] soc_camera: Fix checkpatch warning in ov9640.c
git bisect  bad a76a0b338112580593af0f68327e3cc204d4d8e7  # 14:16      0-  [media] media: davinci: vpif_capture: remove unnecessary loop for IRQ resource
git bisect  bad 746cb2c31f7d88bac5453e3af45d95670a00ffe8  # 14:17      0-  [media] pvrusb2: Remove unused variable
git bisect  bad 1c1d86a1ea07506c070cfb217a009d53990bdeb0  # 14:20      0-  [media] v4l2: always require v4l2_dev, rename parent to dev_parent
git bisect good d481c581dfe43be11a17728b5c84c2d4b5beecb2  # 14:26     37+  [media] saa7134: use v4l2_dev instead of the deprecated parent field
git bisect good d481c581dfe43be11a17728b5c84c2d4b5beecb2  # 14:30    111+  [media] saa7134: use v4l2_dev instead of the deprecated parent field
git bisect  bad e90d833ed71ac503e3b33b7ad970fc52cb67d9ed  # 14:30      0-  Merge remote-tracking branch 'scsi/for-next' into devel-cairo-x86_64-201306251052
git bisect good 79981489b8b25b70e1c36d08ab86dbb1fb88f0a6  # 14:55    111+  Revert "[media] v4l2: always require v4l2_dev, rename parent to dev_parent"
git bisect good f97f7d2d27bf092b40babda9ded29cc85cf77eec  # 15:10    111+  Merge tag 'spi-v3.10-rc7' of git://git.kernel.org/pub/scm/linux/kernel/git/broonie/spi
git bisect good 34fe2f4be68a2fe90c5aaa67bc906a191799ec66  # 15:20    111+  Add linux-next specific files for 20130624

Thanks,
Fengguang

--W/nzBZO5zC0uMSeA
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename=dmesg-kvm-lkp-sbx04-1167-20130625154150--
Content-Transfer-Encoding: quoted-printable

[    0.000000] Initializing cgroup subsys cpuset
[    0.000000] Initializing cgroup subsys cpu
[    0.000000] Linux version 3.10.0-rc7-00478-ge90d833 (kbuild@cairo) (gcc =
version 4.8.1 (Debian 4.8.1-3) ) #28 Tue Jun 25 11:36:31 CST 2013
[    0.000000] Command line: hung_task_panic=3D1 rcutree.rcu_cpu_stall_time=
out=3D100 log_buf_len=3D8M ignore_loglevel debug sched_debug apic=3Ddebug d=
ynamic_printk sysrq_always_enabled panic=3D10  prompt_ramdisk=3D0 console=
=3DttyS0,115200 console=3Dtty0 vga=3Dnormal  root=3D/dev/ram0 rw link=3D/ke=
rnel-tests/run-queue/kvm/x86_64-randconfig-c14-0624/devel-cairo-x86_64-2013=
06251052/.vmlinuz-e90d833ed71ac503e3b33b7ad970fc52cb67d9ed-20130625113718-7=
-lkp-sbx04 branch=3Dlinux-devel/devel-cairo-x86_64-201306251052  BOOT_IMAGE=
=3D/kernel/x86_64-randconfig-c14-0624/e90d833ed71ac503e3b33b7ad970fc52cb67d=
9ed/vmlinuz-3.10.0-rc7-00478-ge90d833
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
[    0.000000] No AGP bridge found
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
[    0.000000] Scan for SMP in [mem 0x00000000-0x000003ff]
[    0.000000] Scan for SMP in [mem 0x0009fc00-0x0009ffff]
[    0.000000] Scan for SMP in [mem 0x000f0000-0x000fffff]
[    0.000000] found SMP MP-table at [mem 0x000fdae0-0x000fdaef] mapped at =
[ffff8800000fdae0]
[    0.000000]   mpc: fdaf0-fdbec
[    0.000000] Scanning 1 areas for low memory corruption
[    0.000000] Base memory trampoline at [ffff880000099000] 99000 size 24576
[    0.000000] Using GB pages for direct mapping
[    0.000000] init_memory_mapping: [mem 0x00000000-0x000fffff]
[    0.000000]  [mem 0x00000000-0x000fffff] page 4k
[    0.000000] BRK [0x028f6000, 0x028f6fff] PGTABLE
[    0.000000] BRK [0x028f7000, 0x028f7fff] PGTABLE
[    0.000000] BRK [0x028f8000, 0x028f8fff] PGTABLE
[    0.000000] init_memory_mapping: [mem 0x0e600000-0x0e7fffff]
[    0.000000]  [mem 0x0e600000-0x0e7fffff] page 4k
[    0.000000] BRK [0x028f9000, 0x028f9fff] PGTABLE
[    0.000000] init_memory_mapping: [mem 0x0c000000-0x0e5fffff]
[    0.000000]  [mem 0x0c000000-0x0e5fffff] page 4k
[    0.000000] BRK [0x028fa000, 0x028fafff] PGTABLE
[    0.000000] init_memory_mapping: [mem 0x00100000-0x0bffffff]
[    0.000000]  [mem 0x00100000-0x0bffffff] page 4k
[    0.000000] init_memory_mapping: [mem 0x0e800000-0x0fffdfff]
[    0.000000]  [mem 0x0e800000-0x0fffdfff] page 4k
[    0.000000] log_buf_len: 8388608
[    0.000000] early log buf free: 127176(97%)
[    0.000000] RAMDISK: [mem 0x0e8d6000-0x0ffeffff]
[    0.000000] ACPI: RSDP 00000000000fd950 00014 (v00 BOCHS )
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
[    0.000000] kvm-stealtime: cpu 0, msr 1c31740
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
=3D/kernel-tests/run-queue/kvm/x86_64-randconfig-c14-0624/devel-cairo-x86_6=
4-201306251052/.vmlinuz-e90d833ed71ac503e3b33b7ad970fc52cb67d9ed-2013062511=
3718-7-lkp-sbx04 branch=3Dlinux-devel/devel-cairo-x86_64-201306251052  BOOT=
_IMAGE=3D/kernel/x86_64-randconfig-c14-0624/e90d833ed71ac503e3b33b7ad970fc5=
2cb67d9ed/vmlinuz-3.10.0-rc7-00478-ge90d833
[    0.000000] PID hash table entries: 1024 (order: 1, 8192 bytes)
[    0.000000] Dentry cache hash table entries: 32768 (order: 6, 262144 byt=
es)
[    0.000000] Inode-cache hash table entries: 16384 (order: 5, 131072 byte=
s)
[    0.000000] xsave: enabled xstate_bv 0x7, cntxt size 0x340
[    0.000000] Checking aperture...
[    0.000000] No AGP bridge found
[    0.000000] Memory: 198484k/262136k available (7379k kernel code, 392k a=
bsent, 63260k reserved, 8056k data, 840k init)
[    0.000000] SLUB: HWalign=3D64, Order=3D0-3, MinObjects=3D0, CPUs=3D1, N=
odes=3D1
[    0.000000] NR_IRQS:4352 nr_irqs:256 16
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
[    0.000000] ODEBUG: 0 of 0 active objects replaced
[    0.000000] hpet clockevent registered
[    0.000000] tsc: Detected 2693.506 MHz processor
[    0.004000] Calibrating delay loop (skipped) preset value.. 5387.01 Bogo=
MIPS (lpj=3D2693506)
[    0.005006] pid_max: default: 32768 minimum: 301
[    0.006068] Mount-cache hash table entries: 256
[    0.007269] Initializing cgroup subsys debug
[    0.008008] Initializing cgroup subsys devices
[    0.009011] Initializing cgroup subsys freezer
[    0.010010] Initializing cgroup subsys net_cls
[    0.011007] Initializing cgroup subsys blkio
[    0.012007] Initializing cgroup subsys net_prio
[    0.013100] mce: CPU supports 10 MCE banks
[    0.014044] Last level iTLB entries: 4KB 0, 2MB 0, 4MB 0
[    0.014044] Last level dTLB entries: 4KB 0, 2MB 0, 4MB 0
[    0.014044] tlb_flushall_shift: 5
[    0.015005] CPU: Intel(R) Xeon(R) CPU E5-4650 0 @ 2.70GHz (fam: 06, mode=
l: 2d, stepping: 07)
[    0.019350] ACPI: Core revision 20130418
[    0.021931] ACPI: All ACPI Tables successfully acquired
[    0.023162] Performance Events: 16-deep LBR, SandyBridge events, Intel P=
MU driver.
[    0.026006] perf_event_intel: PEBS disabled due to CPU errata, please up=
grade microcode
[    0.027014] ... version:                2
[    0.028006] ... bit width:              48
[    0.029006] ... generic registers:      4
[    0.030006] ... value mask:             0000ffffffffffff
[    0.031006] ... max period:             000000007fffffff
[    0.032006] ... fixed-purpose events:   3
[    0.033006] ... event mask:             000000070000000f
[    0.035159] Getting VERSION: 1050014
[    0.036011] Getting VERSION: 1050014
[    0.037011] Getting ID: 0
[    0.038015] Getting ID: ff000000
[    0.038897] Getting LVT0: 8700
[    0.039009] Getting LVT1: 8400
[    0.040062] enabled ExtINT on CPU#0
[    0.042683] ENABLING IO-APIC IRQs
[    0.043013] init IO_APIC IRQs
[    0.044006]  apic 0 pin 0 not connected
[    0.045025] IOAPIC[0]: Set routing entry (0-1 -> 0x31 -> IRQ 1 Mode:0 Ac=
tive:0 Dest:1)
[    0.046024] IOAPIC[0]: Set routing entry (0-2 -> 0x30 -> IRQ 0 Mode:0 Ac=
tive:0 Dest:1)
[    0.047023] IOAPIC[0]: Set routing entry (0-3 -> 0x33 -> IRQ 3 Mode:0 Ac=
tive:0 Dest:1)
[    0.048022] IOAPIC[0]: Set routing entry (0-4 -> 0x34 -> IRQ 4 Mode:0 Ac=
tive:0 Dest:1)
[    0.049022] IOAPIC[0]: Set routing entry (0-5 -> 0x35 -> IRQ 5 Mode:1 Ac=
tive:0 Dest:1)
[    0.050022] IOAPIC[0]: Set routing entry (0-6 -> 0x36 -> IRQ 6 Mode:0 Ac=
tive:0 Dest:1)
[    0.051021] IOAPIC[0]: Set routing entry (0-7 -> 0x37 -> IRQ 7 Mode:0 Ac=
tive:0 Dest:1)
[    0.052022] IOAPIC[0]: Set routing entry (0-8 -> 0x38 -> IRQ 8 Mode:0 Ac=
tive:0 Dest:1)
[    0.053022] IOAPIC[0]: Set routing entry (0-9 -> 0x39 -> IRQ 9 Mode:1 Ac=
tive:0 Dest:1)
[    0.054022] IOAPIC[0]: Set routing entry (0-10 -> 0x3a -> IRQ 10 Mode:1 =
Active:0 Dest:1)
[    0.055021] IOAPIC[0]: Set routing entry (0-11 -> 0x3b -> IRQ 11 Mode:1 =
Active:0 Dest:1)
[    0.056022] IOAPIC[0]: Set routing entry (0-12 -> 0x3c -> IRQ 12 Mode:0 =
Active:0 Dest:1)
[    0.057022] IOAPIC[0]: Set routing entry (0-13 -> 0x3d -> IRQ 13 Mode:0 =
Active:0 Dest:1)
[    0.059021] IOAPIC[0]: Set routing entry (0-14 -> 0x3e -> IRQ 14 Mode:0 =
Active:0 Dest:1)
[    0.060021] IOAPIC[0]: Set routing entry (0-15 -> 0x3f -> IRQ 15 Mode:0 =
Active:0 Dest:1)
[    0.061019]  apic 0 pin 16 not connected
[    0.062004]  apic 0 pin 17 not connected
[    0.063004]  apic 0 pin 18 not connected
[    0.064005]  apic 0 pin 19 not connected
[    0.065004]  apic 0 pin 20 not connected
[    0.066004]  apic 0 pin 21 not connected
[    0.067005]  apic 0 pin 22 not connected
[    0.068004]  apic 0 pin 23 not connected
[    0.069152] ..TIMER: vector=3D0x30 apic1=3D0 pin1=3D2 apic2=3D-1 pin2=3D=
-1
[    0.070035] TSC deadline timer enabled
[    0.071000] devtmpfs: initialized
[    0.074285] xor: automatically using best checksumming function:
[    0.085005]    avx       : 20860.000 MB/sec
[    0.086152] regulator-dummy: no parameters
[    0.087142] NET: Registered protocol family 16
[    0.088867] ACPI: bus type PCI registered
[    0.089033] PCI: Using configuration type 1 for base access
[    0.095314] bio: create slab <bio-0> at 0
[    0.113007] raid6: sse2x1    7121 MB/s
[    0.131010] raid6: sse2x2    9148 MB/s
[    0.149007] raid6: sse2x4   10542 MB/s
[    0.150006] raid6: using algorithm sse2x4 (10542 MB/s)
[    0.151006] raid6: using ssse3x2 recovery algorithm
[    0.152198] ACPI: Added _OSI(Module Device)
[    0.153007] ACPI: Added _OSI(Processor Device)
[    0.154009] ACPI: Added _OSI(3.0 _SCP Extensions)
[    0.155009] ACPI: Added _OSI(Processor Aggregator Device)
[    0.157765] ACPI: EC: Look up EC in DSDT
[    0.161917] ACPI: Interpreter enabled
[    0.162015] ACPI: (supports S0 S5)
[    0.163006] ACPI: Using IOAPIC for interrupt routing
[    0.164032] PCI: Using host bridge windows from ACPI; if necessary, use =
"pci=3Dnocrs" and report a bug
[    0.172193] ACPI: PCI Root Bridge [PCI0] (domain 0000 [bus 00-ff])
[    0.173352] PCI host bridge to bus 0000:00
[    0.174009] pci_bus 0000:00: root bus resource [bus 00-ff]
[    0.175008] pci_bus 0000:00: root bus resource [io  0x0000-0x0cf7]
[    0.176007] pci_bus 0000:00: root bus resource [io  0x0d00-0xffff]
[    0.177007] pci_bus 0000:00: root bus resource [mem 0x000a0000-0x000bfff=
f]
[    0.178007] pci_bus 0000:00: root bus resource [mem 0x80000000-0xfebffff=
f]
[    0.179054] pci 0000:00:00.0: [8086:1237] type 00 class 0x060000
[    0.180529] pci 0000:00:01.0: [8086:7000] type 00 class 0x060100
[    0.181527] pci 0000:00:01.1: [8086:7010] type 00 class 0x010180
[    0.184518] pci 0000:00:01.1: reg 20: [io  0xc060-0xc06f]
[    0.186307] pci 0000:00:01.3: [8086:7113] type 00 class 0x068000
[    0.187426] pci 0000:00:01.3: quirk: [io  0xb000-0xb03f] claimed by PIIX=
4 ACPI
[    0.188017] pci 0000:00:01.3: quirk: [io  0xb100-0xb10f] claimed by PIIX=
4 SMB
[    0.189217] pci 0000:00:02.0: [1013:00b8] type 00 class 0x030000
[    0.191013] pci 0000:00:02.0: reg 10: [mem 0xfc000000-0xfdffffff pref]
[    0.193016] pci 0000:00:02.0: reg 14: [mem 0xfebe0000-0xfebe0fff]
[    0.199012] pci 0000:00:02.0: reg 30: [mem 0xfebc0000-0xfebcffff pref]
[    0.200200] pci 0000:00:03.0: [1af4:1000] type 00 class 0x020000
[    0.202007] pci 0000:00:03.0: reg 10: [io  0xc040-0xc05f]
[    0.204007] pci 0000:00:03.0: reg 14: [mem 0xfebe1000-0xfebe1fff]
[    0.209480] pci 0000:00:03.0: reg 30: [mem 0xfebd0000-0xfebdffff pref]
[    0.210282] pci 0000:00:04.0: [8086:100e] type 00 class 0x020000
[    0.212007] pci 0000:00:04.0: reg 10: [mem 0xfeb80000-0xfeb9ffff]
[    0.213982] pci 0000:00:04.0: reg 14: [io  0xc000-0xc03f]
[    0.218483] pci 0000:00:04.0: reg 30: [mem 0xfeba0000-0xfebbffff pref]
[    0.219188] pci 0000:00:05.0: [8086:25ab] type 00 class 0x088000
[    0.220560] pci 0000:00:05.0: reg 10: [mem 0xfebe2000-0xfebe200f]
[    0.224366] pci_bus 0000:00: on NUMA node 0
[    0.225007] acpi PNP0A03:00: Unable to request _OSC control (_OSC suppor=
t mask: 0x08)
[    0.226845] ACPI: PCI Interrupt Link [LNKA] (IRQs 5 *10 11)
[    0.228164] ACPI: PCI Interrupt Link [LNKB] (IRQs 5 *10 11)
[    0.230187] ACPI: PCI Interrupt Link [LNKC] (IRQs 5 10 *11)
[    0.232187] ACPI: PCI Interrupt Link [LNKD] (IRQs 5 10 *11)
[    0.234121] ACPI: PCI Interrupt Link [LNKS] (IRQs *9)
[    0.236301] ACPI: Enabled 16 GPEs in block 00 to 0F
[    0.237013] acpi root: \_SB_.PCI0 notify handler is installed
[    0.238096] Found 1 acpi root devices
[    0.239455] vgaarb: device added: PCI:0000:00:02.0,decodes=3Dio+mem,owns=
=3Dio+mem,locks=3Dnone
[    0.240008] vgaarb: loaded
[    0.240981] vgaarb: bridge control possible 0000:00:02.0
[    0.241076] tps65010: version 2 May 2005
[    0.264034] tps65010: no chip?
[    0.265212] SCSI subsystem initialized
[    0.266008] ACPI: bus type ATA registered
[    0.267030] libata version 3.00 loaded.
[    0.268118] Linux video capture interface: v2.00
[    0.269036] pps_core: LinuxPPS API ver. 1 registered
[    0.270006] pps_core: Software ver. 5.3.6 - Copyright 2005-2007 Rodolfo =
Giometti <giometti@linux.it>
[    0.271014] PTP clock support registered
[    0.272192] Advanced Linux Sound Architecture Driver Initialized.
[    0.273006] PCI: Using ACPI for IRQ routing
[    0.274007] PCI: pci_cache_line_size set to 64 bytes
[    0.275140] e820: reserve RAM buffer [mem 0x0009fc00-0x0009ffff]
[    0.276008] e820: reserve RAM buffer [mem 0x0fffe000-0x0fffffff]
[    0.277228] NET: Registered protocol family 23
[    0.278040] Bluetooth: Core ver 2.16
[    0.279028] NET: Registered protocol family 31
[    0.280006] Bluetooth: HCI device and connection manager initialized
[    0.281017] Bluetooth: HCI socket layer initialized
[    0.282011] Bluetooth: L2CAP socket layer initialized
[    0.283026] Bluetooth: SCO socket layer initialized
[    0.284007] NET: Registered protocol family 8
[    0.285006] NET: Registered protocol family 20
[    0.286685] Switching to clocksource kvm-clock
[    0.287108] FS-Cache: Loaded
[    0.288119] pnp: PnP ACPI init
[    0.289200] cfg80211: Calling CRDA to update world regulatory domain
[    0.290820] ACPI: bus type PNP registered
[    0.292046] IOAPIC[0]: Set routing entry (0-8 -> 0x38 -> IRQ 8 Mode:0 Ac=
tive:0 Dest:1)
[    0.294369] pnp 00:00: Plug and Play ACPI device, IDs PNP0b00 (active)
[    0.296021] IOAPIC[0]: Set routing entry (0-1 -> 0x31 -> IRQ 1 Mode:0 Ac=
tive:0 Dest:1)
[    0.298368] pnp 00:01: Plug and Play ACPI device, IDs PNP0303 (active)
[    0.299978] IOAPIC[0]: Set routing entry (0-12 -> 0x3c -> IRQ 12 Mode:0 =
Active:0 Dest:1)
[    0.302379] pnp 00:02: Plug and Play ACPI device, IDs PNP0f13 (active)
[    0.304037] IOAPIC[0]: Set routing entry (0-6 -> 0x36 -> IRQ 6 Mode:0 Ac=
tive:0 Dest:1)
[    0.306310] pnp 00:03: [dma 2]
[    0.307383] pnp 00:03: Plug and Play ACPI device, IDs PNP0700 (active)
[    0.309040] IOAPIC[0]: Set routing entry (0-7 -> 0x37 -> IRQ 7 Mode:0 Ac=
tive:0 Dest:1)
[    0.311321] pnp 00:04: Plug and Play ACPI device, IDs PNP0400 (active)
[    0.312975] IOAPIC[0]: Set routing entry (0-4 -> 0x34 -> IRQ 4 Mode:0 Ac=
tive:0 Dest:1)
[    0.315362] pnp 00:05: Plug and Play ACPI device, IDs PNP0501 (active)
[    0.317302] pnp 00:06: Plug and Play ACPI device, IDs PNP0103 (active)
[    0.319084] pnp: PnP ACPI: found 7 devices
[    0.320260] ACPI: bus type PNP unregistered
[    0.329233] pci_bus 0000:00: resource 4 [io  0x0000-0x0cf7]
[    0.330736] pci_bus 0000:00: resource 5 [io  0x0d00-0xffff]
[    0.332134] pci_bus 0000:00: resource 6 [mem 0x000a0000-0x000bffff]
[    0.333736] pci_bus 0000:00: resource 7 [mem 0x80000000-0xfebfffff]
[    0.335263] NET: Registered protocol family 1
[    0.336519] pci 0000:00:00.0: Limiting direct PCI/PCI transfers
[    0.338022] pci 0000:00:01.0: PIIX3: Enabling Passive Release
[    0.339437] pci 0000:00:01.0: Activating ISA DMA hang workarounds
[    0.340923] pci 0000:00:02.0: Boot video device
[    0.342133] PCI: CLS 0 bytes, default 64
[    0.343323] Unpacking initramfs...
[    0.971661] debug: unmapping init [mem 0xffff88000e8d6000-0xffff88000ffe=
ffff]
[    0.974394] microcode: CPU0 sig=3D0x206d7, pf=3D0x1, revision=3D0x1
[    0.975849] microcode: Microcode Update Driver: v2.00 <tigran@aivazian.f=
snet.co.uk>, Peter Oruba
[    0.978047] Scanning for low memory corruption every 60 seconds
[    0.979634] cryptomgr_test (15) used greatest stack depth: 6120 bytes le=
ft
[    0.981490] cryptomgr_test (17) used greatest stack depth: 5528 bytes le=
ft
[    0.986329] alg: No test for __gcm-aes-aesni (__driver-gcm-aes-aesni)
[    0.988517] alg: No test for crc32 (crc32-pclmul)
[    0.989801] sha256_ssse3: Using AVX optimized SHA-256 implementation
[    0.993777] AVX2 or AES-NI instructions are not detected.
[    0.995048] AVX2 instructions are not detected.
[    0.996851] Initializing RT-Tester: OK
[    0.997939] audit: initializing netlink socket (disabled)
[    0.999297] type=3D2000 audit(1372146101.999:1): initialized
[    1.005232] fuse init (API version 7.22)
[    1.006667] NILFS version 2 loaded
[    1.007950] bio: create slab <bio-1> at 1
[    1.009316] Btrfs loaded
[    1.010224] msgmni has been set to 387
[    1.014310] alg: No test for stdrng (krng)
[    1.015495] NET: Registered protocol family 38
[    1.016711] Block layer SCSI generic (bsg) driver version 0.4 loaded (ma=
jor 250)
[    1.018741] io scheduler noop registered (default)
[    1.021312] xz_dec_test: module loaded
[    1.022347] xz_dec_test: Create a device node with 'mknod xz_dec_test c =
249 0' and write .xz files to it.
[    1.025633] ipmi message handler version 39.2
[    1.026809] ipmi device interface
[    1.027840] IPMI System Interface driver.
[    1.028975] ipmi_si: Adding default-specified kcs state machine
[    1.030513] ipmi_si: Trying default-specified kcs state machine at i/o a=
ddress 0xca2, slave address 0x0, irq 0
[    1.032932] ipmi_si: Interface detection failed
[    1.034117] ipmi_si: Adding default-specified smic state machine
[    1.035555] ipmi_si: Trying default-specified smic state machine at i/o =
address 0xca9, slave address 0x0, irq 0
[    1.038484] ipmi_si: Interface detection failed
[    1.039895] ipmi_si: Adding default-specified bt state machine
[    1.041689] ipmi_si: Trying default-specified bt state machine at i/o ad=
dress 0xe4, slave address 0x0, irq 0
[    1.044624] ipmi_si: Interface detection failed
[    1.046074] ipmi_si: Unable to find any System Interface(s)
[    1.047713] IPMI Watchdog: driver initialized
[    1.049123] Copyright (C) 2004 MontaVista Software - IPMI Powerdown via =
sys_reboot.
[    1.051763] input: Power Button as /devices/LNXSYSTM:00/LNXPWRBN:00/inpu=
t/input0
[    1.054257] ACPI: Power Button [PWRF]
[    1.055867] r3964: Philips r3964 Driver $Revision: 1.10 $
[    1.057517] Serial: 8250/16550 driver, 4 ports, IRQ sharing disabled
[    1.083044] 00:05: ttyS0 at I/O 0x3f8 (irq =3D 4) is a 16550A
[    1.085527] telclk_interrupt =3D 0xf non-mcpbl0010 hw.
[    1.087083] Hangcheck: starting hangcheck timer 0.9.1 (tick is 180 secon=
ds, margin is 60 seconds).
[    1.089898] Hangcheck: Using getrawmonotonic().
[    1.091452] lkdtm: No crash points registered, enable through debugfs
[    1.093327] Silicon Labs C2 port support v. 0.51.0 - (C) 2007 Rodolfo Gi=
ometti
[    1.095832] c2port c2port0: C2 port uc added
[    1.097224] c2port c2port0: uc flash has 30 blocks x 512 bytes (15360 by=
tes total)
[    1.100130] emc: device handler registered
[    1.101473] alua: device handler registered
[    1.103051] st: Version 20101219, fixed bufsize 32768, s/g segs 256
[    1.104825] osst :I: Tape driver with OnStream support version 0.99.4
[    1.104825] osst :I: $Id: osst.c,v 1.73 2005/01/01 21:13:34 wriede Exp $
[    1.108504] SCSI Media Changer driver v0.25=20
[    1.115350] scsi_debug: host protection
[    1.116741] scsi0 : scsi_debug, version 1.82 [20100324], dev_size_mb=3D8=
, opts=3D0x0
[    1.119536] scsi 0:0:0:0: Direct-Access     Linux    scsi_debug       00=
04 PQ: 0 ANSI: 5
[    1.122337] scsi 0:0:0:0: Attached scsi generic sg0 type 0
[    1.124300] SSFDC read-only Flash Translation layer
[    1.125882] L440GX flash mapping: failed to find PIIX4 ISA bridge, canno=
t continue
[    1.128389] platform physmap-flash.0: failed to claim resource 0
[    1.130137] NetSc520 flash device: 0x100000 at 0x200000
[    1.131739] Failed to ioremap_nocache
[    1.132983] Generic platform RAM MTD, (c) 2004 Simtec Electronics
[    1.136533] ftl_cs: FTL header not found.
[    1.139515] eql: Equalizer2002: Simon Janes (simon@ncm.com) and David S.=
 Miller (davem@redhat.com)
[    1.143134] tun: Universal TUN/TAP device driver, 1.6
[    1.144707] tun: (C) 1999-2004 Max Krasnyansky <maxk@qualcomm.com>
[    1.147347] PPP generic driver version 2.4.2
[    1.148827] PPP BSD Compression module registered
[    1.150309] PPP Deflate Compression module registered
[    1.151865] hdlc: HDLC support module revision 1.22
[    1.153428] DLCI driver v0.35, 4 Jan 1997, mike.mclagan@linux.org.
[    1.155391] i8042: PNP: PS/2 Controller [PNP0303:KBD,PNP0f13:MOU] at 0x6=
0,0x64 irq 1,12
[    1.158856] serio: i8042 KBD port at 0x60,0x64 irq 1
[    1.160393] serio: i8042 AUX port at 0x60,0x64 irq 12
[    1.162331] mousedev: PS/2 mouse device common for all mice
[    1.164033] evbug: Connected device: input0 (Power Button at LNXPWRBN/bu=
tton/input0)
[    1.167055] input: AT Translated Set 2 keyboard as /devices/platform/i80=
42/serio0/input/input1
[    1.169988] evbug: Connected device: input1 (AT Translated Set 2 keyboar=
d at isa0060/serio0/input0)
[    1.173337] mk712: device not present
[    1.174772] rtc_cmos 00:00: RTC can wake from S4
[    1.178560] rtc (null): alarm rollover: day
[    1.180051] rtc rtc0: rtc_cmos: dev (254:0)
[    1.181415] rtc_cmos 00:00: rtc core: registered rtc_cmos as rtc0
[    1.183344] rtc_cmos 00:00: alarms up to one day, 114 bytes nvram, hpet =
irqs
[    1.185863] rtc rtc1: test: dev (254:1)
[    1.187191] rtc-test rtc-test.0: rtc core: registered test as rtc1
[    1.189095] rtc rtc2: test: dev (254:2)
[    1.190386] rtc-test rtc-test.1: rtc core: registered test as rtc2
[    1.192665] lirc_dev: IR Remote Control driver registered, major 243=20
[    1.194574] IR NEC protocol handler initialized
[    1.196015] IR RC5(x) protocol handler initialized
[    1.197504] IR RC6 protocol handler initialized
[    1.198928] IR JVC protocol handler initialized
[    1.200437] IR Sony protocol handler initialized
[    1.201909] IR RC5 (streamzap) protocol handler initialized
[    1.203580] IR MCE Keyboard/mouse protocol handler initialized
[    1.205350] ------------[ cut here ]------------
[    1.206821] WARNING: at /c/kernel-tests/src/tip/drivers/media/v4l2-core/=
v4l2-dev.c:775 __video_register_device+0x55/0xbc7()
[    1.210029] CPU: 0 PID: 1 Comm: swapper Not tainted 3.10.0-rc7-00478-ge9=
0d833 #28
[    1.212515] Hardware name: Bochs Bochs, BIOS Bochs 01/01/2011
[    1.214172]  ffffffff810a5186 ffff88000d865dd8 ffffffff8172b4f7 ffff8800=
0d865e10
[    1.217032]  ffffffff810878a9 0000000000000000 ffffffffffffffff ffff8800=
062f7510
[    1.219851]  0000000000000002 0000000000000000 ffff88000d865e20 ffffffff=
81087983
[    1.222661] Call Trace:
[    1.223677]  [<ffffffff810a5186>] ? up+0xf/0x39
[    1.225121]  [<ffffffff8172b4f7>] dump_stack+0x19/0x1b
[    1.226679]  [<ffffffff810878a9>] warn_slowpath_common+0x5b/0x73
[    1.234994]  [<ffffffff81087983>] warn_slowpath_null+0x15/0x17
[    1.236722]  [<ffffffff8151cf7c>] __video_register_device+0x55/0xbc7
[    1.238555]  [<ffffffff8171fb86>] ? klist_init+0x31/0x40
[    1.240163]  [<ffffffff8136a944>] ? device_private_init+0x39/0x5e
[    1.241917]  [<ffffffff81537c8a>] fm_v4l2_init_video_device+0x89/0x1e8
[    1.243789]  [<ffffffff81f45951>] fm_drv_init+0x72/0xba
[    1.245353]  [<ffffffff81f458df>] ? wl1273_fm_radio_driver_init+0x12/0x12
[    1.247249]  [<ffffffff81f15db5>] do_one_initcall+0x99/0x12e
[    1.248911]  [<ffffffff81f15faf>] kernel_init_freeable+0x165/0x1e6
[    1.250739]  [<ffffffff81f1570c>] ? do_early_param+0x88/0x88
[    1.252414]  [<ffffffff8172046a>] ? rest_init+0xce/0xce
[    1.253954]  [<ffffffff81720473>] kernel_init+0x9/0xd1
[    1.255510]  [<ffffffff817314ba>] ret_from_fork+0x7a/0xb0
[    1.257120]  [<ffffffff8172046a>] ? rest_init+0xce/0xce
[    1.258734] ---[ end trace b4db00f0f9ac731d ]---
[    1.260167] fmdrv: Could not register video device
[    1.261749] pps pps0: new PPS source ktimer
[    1.263131] pps pps0: ktimer PPS source registered
[    1.264621] pps_ldisc: PPS line discipline registered
[    1.266192] Driver for 1-wire Dallas network protocol.
[    1.267815] 1-Wire driver for the DS2760 battery monitor  chip  - (c) 20=
04-2005, Szabolcs Gyurko
[    1.270890] applesmc: supported laptop not found!
[    1.272364] applesmc: driver init failed (ret=3D-19)!
[    1.274435] pc87360: PC8736x not detected, module not inserted
[    1.276474] Bluetooth: Virtual HCI driver ver 1.3
[    1.277978] Bluetooth: HCI UART driver ver 2.2
[    1.279385] Bluetooth: HCI BCSP protocol initialized
[    1.280898] Bluetooth: HCILL protocol initialized
[    1.282358] Bluetooth: HCI Three-wire UART (H5) protocol initialized
[    1.284143] Bluetooth: Generic Bluetooth SDIO driver ver 0.1
[    1.288417] ISDN subsystem Rev: 1.1.2.3/1.1.2.2/none/1.1.2.2/1.1.2.2
[    1.290781] dss1_divert module successfully installed
[    1.292317] isdnloop: (loop0) virtual card added
[    1.293767] cpuidle: using governor ladder
[    1.295118] cpuidle: using governor menu
[    1.296745] ledtrig-cpu: registered to indicate activity on CPUs
[    1.300223] Audio Excel DSP 16 init driver Copyright (C) Riccardo Facche=
tti 1995-98
[    1.302742] aedsp16: I/O, IRQ and DMA are mandatory
[    1.304222] pss: mss_io, mss_dma, mss_irq and pss_io must be set.
[    1.305958] ad1848/cs4248 codec driver Copyright (C) by Hannu Savolainen=
 1993-1996
[    1.308427] ad1848: No ISAPnP cards found, trying standard ones...
[    1.310206] Pro Audio Spectrum driver Copyright (C) by Hannu Savolainen =
1993-1996
[    1.312647] I/O, IRQ, DMA and type are mandatory
[    1.314093] sb: Init: Starting Probe...
[    1.315392] sb: Init: Done
[    1.316485] uart6850: irq and io must be set.
[    1.317904] YM3812 and OPL-3 driver Copyright (C) by Hannu Savolainen, R=
ob Hooft 1993-1996
[    1.320536] MIDI Loopback device driver
[    1.323206] no UART detected at 0x1
[    1.325652] Motu MidiTimePiece on parallel port irq: 7 ioport: 0x378
[    1.327554] input: PC Speaker as /devices/platform/pcspkr/input/input2
[    1.329407] evbug: Connected device: input2 (PC Speaker at isa0061/input=
0)
[    1.331518] PCSP: CONFIG_DEBUG_PAGEALLOC is enabled, which may make the =
sound noisy.
[    1.334024] oprofile: using NMI interrupt.
[    1.335440] pktgen: Packet Generator for packet performance testing. Ver=
sion: 2.74
[    1.337973] NET: Registered protocol family 26
[    1.339420] GACT probability NOT on
[    1.340641] Mirror/redirect action on
[    1.341890] netem: version 1.3
[    1.343035] u32 classifier
[    1.344091]     input device check on
[    1.345325]     Actions configured
[    1.346573] NET: Registered protocol family 15
[    1.348046] NET: Registered protocol family 4
[    1.349477] NET: Registered protocol family 5
[    1.350888] NET: Registered protocol family 9
[    1.352290] X.25 for Linux Version 0.2
[    1.353648] Bluetooth: RFCOMM TTY layer initialized
[    1.355169] Bluetooth: RFCOMM socket layer initialized
[    1.356723] Bluetooth: RFCOMM ver 1.11
[    1.358010] Bluetooth: BNEP (Ethernet Emulation) ver 1.3
[    1.359599] Bluetooth: BNEP filters: protocol=20
[    1.361074] Bluetooth: BNEP socket layer initialized
[    1.362601] lec:lane_module_init: lec.c: initialized
[    1.364155] NET: Registered protocol family 35
[    1.365666] 8021q: 802.1Q VLAN Support v1.8
[    1.367082] lib80211: common routines for IEEE802.11 drivers
[    1.368778] lib80211_crypt: registered algorithm 'NULL'
[    1.370368] lib80211_crypt: registered algorithm 'WEP'
[    1.371930] lib80211_crypt: registered algorithm 'CCMP'
[    1.373505] lib80211_crypt: registered algorithm 'TKIP'
[    1.375195] batman_adv: B.A.T.M.A.N. advanced 2013.2.0 (compatibility ve=
rsion 14) loaded
[    1.379127]=20
[    1.379127] printing PIC contents
[    1.381025] ... PIC  IMR: ffff
[    1.382014] ... PIC  IRR: 1113
[    1.383290] ... PIC  ISR: 0000
[    1.384419] ... PIC ELCR: 0c00
[    1.385564] printing local APIC contents on CPU#0/0:
[    1.386554] ... APIC ID:      00000000 (0)
[    1.386554] ... APIC VERSION: 01050014
[    1.386554] ... APIC TASKPRI: 00000000 (00)
[    1.386554] ... APIC PROCPRI: 00000000
[    1.386554] ... APIC LDR: 01000000
[    1.386554] ... APIC DFR: ffffffff
[    1.386554] ... APIC SPIV: 000001ff
[    1.386554] ... APIC ISR field:
[    1.386554] 000000000000000000000000000000000000000000000000000000000000=
0000
[    1.386554] ... APIC TMR field:
[    1.386554] 000000000200000000000000000000000000000000000000000000000000=
0000
[    1.386554] ... APIC IRR field:
[    1.386554] 000000000000000000000000000000000000000000000000000000000000=
8000
[    1.386554] ... APIC ESR: 00000000
[    1.386554] ... APIC ICR: 00000831
[    1.386554] ... APIC ICR2: 01000000
[    1.386554] ... APIC LVTT: 000400ef
[    1.386554] ... APIC LVTPC: 00000400
[    1.386554] ... APIC LVT0: 00010700
[    1.386554] ... APIC LVT1: 00000400
[    1.386554] ... APIC LVTERR: 000000fe
[    1.386554] ... APIC TMICT: 00000000
[    1.386554] ... APIC TMCCT: 00000000
[    1.386554] ... APIC TDCR: 00000000
[    1.386554]=20
[    1.420764] number of MP IRQ sources: 15.
[    1.421839] number of IO-APIC #0 registers: 24.
[    1.422983] testing the IO APIC.......................
[    1.424264] IO APIC #0......
[    1.425172] .... register #00: 00000000
[    1.426232] .......    : physical APIC id: 00
[    1.427376] .......    : Delivery Type: 0
[    1.428450] .......    : LTS          : 0
[    1.429544] .... register #01: 00170011
[    1.430680] .......     : max redirection entries: 17
[    1.431990] .......     : PRQ implemented: 0
[    1.433219] .......     : IO APIC version: 11
[    1.434283] .... register #02: 00000000
[    1.435406] .......     : arbitration: 00
[    1.436558] .... IRQ redirection table:
[    1.437688] 1    0    0   0   0    0    0    00
[    1.438923] 0    0    0   0   0    1    1    31
[    1.440143] 0    0    0   0   0    1    1    30
[    1.441394] 0    0    0   0   0    1    1    33
[    1.442621] 1    0    0   0   0    1    1    34
[    1.443888] 1    1    0   0   0    1    1    35
[    1.445110] 0    0    0   0   0    1    1    36
[    1.446349] 0    0    0   0   0    1    1    37
[    1.447617] 0    0    0   0   0    1    1    38
[    1.448834] 0    1    0   0   0    1    1    39
[    1.450052] 1    1    0   0   0    1    1    3A
[    1.451305] 1    1    0   0   0    1    1    3B
[    1.452554] 0    0    0   0   0    1    1    3C
[    1.453807] 0    0    0   0   0    1    1    3D
[    1.455029] 0    0    0   0   0    1    1    3E
[    1.456269] 0    0    0   0   0    1    1    3F
[    1.457509] 1    0    0   0   0    0    0    00
[    1.458759] 1    0    0   0   0    0    0    00
[    1.460002] 1    0    0   0   0    0    0    00
[    1.461284] 1    0    0   0   0    0    0    00
[    1.462503] 1    0    0   0   0    0    0    00
[    1.463744] 1    0    0   0   0    0    0    00
[    1.464976] 1    0    0   0   0    0    0    00
[    1.466213] 1    0    0   0   0    0    0    00
[    1.467435] IRQ to pin mappings:
[    1.468497] IRQ0 -> 0:2
[    1.469548] IRQ1 -> 0:1
[    1.470640] IRQ3 -> 0:3
[    1.471686] IRQ4 -> 0:4
[    1.472833] IRQ5 -> 0:5
[    1.474067] IRQ6 -> 0:6
[    1.475130] IRQ7 -> 0:7
[    1.476151] IRQ8 -> 0:8
[    1.477201] IRQ9 -> 0:9
[    1.478283] IRQ10 -> 0:10
[    1.479327] IRQ11 -> 0:11
[    1.480435] IRQ12 -> 0:12
[    1.481502] IRQ13 -> 0:13
[    1.482572] IRQ14 -> 0:14
[    1.483691] IRQ15 -> 0:15
[    1.484742] .................................... done.
[    1.486190] registered taskstats version 1
[    1.487873] BIOS EDD facility v0.16 2004-Jun-25, 0 devices found
[    1.495869] EDD information not available.
[    1.497063] ALSA device list:
[    1.497968]   #0: Loopback 1
[    1.498864]   #1: MTPAV on parallel port at 0x378
[    1.500046]   #2: Internal PC-Speaker at port 0x61
[    1.501401] debug: unmapping init [mem 0xffffffff81f15000-0xffffffff81fe=
6fff]
[    1.503014] Write protecting the kernel read-only data: 12288k
[    1.504679] debug: unmapping init [mem 0xffff880001737000-0xffff8800017f=
ffff]
[    1.506249] debug: unmapping init [mem 0xffff880001ba3000-0xffff880001bf=
ffff]
[    1.632295] init: Failed to create pty - disabling logging for job
[    1.634094] init: Temporary process spawn error: No space left on device
[    1.695541] init: mounted-tmp main process (180) terminated with status =
32
[    1.737114] udevd[206]: starting version 175
[    1.752545] udevd (205) used greatest stack depth: 5512 bytes left
[    1.754269] init: procps (virtual-filesystems) main process (199) killed=
 by TERM signal
[    1.757198] init: upstart-udev-bridge main process ended, respawning
[    1.762765] init: udev main process (206) terminated with status 4
[    1.764290] init: udev main process ended, respawning
[    1.780263] input: ImExPS/2 Generic Explorer Mouse as /devices/platform/=
i8042/serio1/input/input3
[    1.784934] udevd[218]: starting version 175
[    1.790360] evbug: Connected device: input3 (ImExPS/2 Generic Explorer M=
ouse at isa0060/serio1/input0)
[    1.811499] init: udev main process (218) terminated with status 4
[    1.813253] init: udev main process ended, respawning
[    1.815183] init: plymouth-log main process (223) terminated with status=
 1
[    1.825441] udevd[226]: starting version 175
[    1.831875] init: udev main process (226) terminated with status 4
[    1.833361] init: udev main process ended, respawning
[    1.842038] udevd[228]: starting version 175
[    1.846942] init: udev main process (228) terminated with status 4
[    1.848512] init: udev main process ended, respawning
[    1.856963] udevd[230]: starting version 175
[    1.862689] init: udev main process (230) terminated with status 4
[    1.864201] init: udev main process ended, respawning
[    1.872524] udevd[232]: starting version 175
[    1.878435] init: udev main process (232) terminated with status 4
[    1.879963] init: udev main process ended, respawning
[    1.888397] udevd[234]: starting version 175
[    1.904196] init: udev main process (234) terminated with status 4
[    1.905718] init: udev main process ended, respawning
[    1.915686] udevd[237]: starting version 175
[    1.920340] init: udev main process (237) terminated with status 4
[    1.921850] init: udev main process ended, respawning
[    1.929245] udevd[240]: starting version 175
[    1.933852] init: udev main process (240) terminated with status 4
[    1.935368] init: udev main process ended, respawning
[    1.942544] udevd[242]: starting version 175
[    1.947154] init: udev main process (242) terminated with status 4
[    1.948637] init: udev main process ended, respawning
[    1.955908] udevd[244]: starting version 175
[    1.960580] init: udev main process (244) terminated with status 4
[    1.962105] init: udev respawning too fast, stopped
[    1.976092] tsc: Refined TSC clocksource calibration: 2693.504 MHz
[    3.101747] init: Re-executing /init
[    4.150781] Unregister pv shared memory for cpu 0
[    4.153033] Restarting system.
[    4.154030] reboot: machine restart
Elapsed time: 10
qemu-system-x86_64-cpuhost-enable-kvm-kernel/tmp//kernel/x86_64-randconfig-=
c14-0624/e90d833ed71ac503e3b33b7ad970fc52cb67d9ed/vmlinuz-3.10.0-rc7-00478-=
ge90d833-1167-append'hung_task_panic=3D1 rcutree.rcu_cpu_stall_timeout=3D10=
0 log_buf_len=3D8M ignore_loglevel debug sched_debug apic=3Ddebug dynamic_p=
rintk sysrq_always_enabled panic=3D10  prompt_ramdisk=3D0 console=3DttyS0,1=
15200 console=3Dtty0 vga=3Dnormal  root=3D/dev/ram0 rw link=3D/kernel-tests=
/run-queue/kvm/x86_64-randconfig-c14-0624/devel-cairo-x86_64-201306251052/.=
vmlinuz-e90d833ed71ac503e3b33b7ad970fc52cb67d9ed-20130625113718-7-lkp-sbx04=
 branch=3Dlinux-devel/devel-cairo-x86_64-201306251052  BOOT_IMAGE=3D/kernel=
/x86_64-randconfig-c14-0624/e90d833ed71ac503e3b33b7ad970fc52cb67d9ed/vmlinu=
z-3.10.0-rc7-00478-ge90d833'-initrd/kernel-tests/initrd/quantal-core-x86_64=
=2Ecgz-m256M-smp2-netnic,vlan=3D0,macaddr=3D00:00:00:00:00:00,model=3Dvirti=
o-netuser,vlan=3D0,hostfwd=3Dtcp::5263-:22-netnic,vlan=3D1,model=3De1000-ne=
tuser,vlan=3D1-bootorder=3Dnc-no-reboot-watchdogi6300esb-pidfile/dev/shm/kb=
oot/pid-lkp-sbx04-lkp-1167-serialfile:/dev/shm/kboot/serial-lkp-sbx04-lkp-1=
167-daemonize-displaynone-monitornull

--W/nzBZO5zC0uMSeA
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="bisect-e90d833ed71ac503e3b33b7ad970fc52cb67d9ed-x86_64-randconfig-c14-0624-fm_drv_init+-x-42751.log"

git checkout 9e895ace5d82df8929b16f58e9f515f6d54ab82d
Previous HEAD position was e90d833... Merge remote-tracking branch 'scsi/for-next' into devel-cairo-x86_64-201306251052
HEAD is now at 9e895ac... Linux 3.10-rc7
ls -a /kernel-tests/run-queue/kvm/x86_64-randconfig-c14-0624/linux-devel:devel-cairo-x86_64-201306251052:9e895ace5d82df8929b16f58e9f515f6d54ab82d:bisect-usb

2013-06-25-13:38:00 9e895ace5d82df8929b16f58e9f515f6d54ab82d reuse /kernel/x86_64-randconfig-c14-0624/9e895ace5d82df8929b16f58e9f515f6d54ab82d/vmlinuz-3.10.0-rc7

2013-06-25-13:38:00 detecting boot state 	1	3	16	24	34	35	37 SUCCESS

bisect: good commit 9e895ace5d82df8929b16f58e9f515f6d54ab82d
git bisect start e90d833ed71ac503e3b33b7ad970fc52cb67d9ed 9e895ace5d82df8929b16f58e9f515f6d54ab82d --
Previous HEAD position was 9e895ac... Linux 3.10-rc7
HEAD is now at c1be5a5... Linux 3.9
Bisecting: 238 revisions left to test after this (roughly 8 steps)
[0bde6c3e4c4d594eb66200e37d9aec6ed45a8543] [media] bttv: fix querystd
git bisect run /c/kernel-tests/bisect-test-boot-failure.sh /home/wfg/usb/obj-bisect
running /c/kernel-tests/bisect-test-boot-failure.sh /home/wfg/usb/obj-bisect
ls -a /kernel-tests/run-queue/kvm/x86_64-randconfig-c14-0624/linux-devel:devel-cairo-x86_64-201306251052:0bde6c3e4c4d594eb66200e37d9aec6ed45a8543:bisect-usb

2013-06-25-13:41:39 0bde6c3e4c4d594eb66200e37d9aec6ed45a8543 compiling
227 real  1213 user  112 sys  583.11% cpu 	x86_64-randconfig-c14-0624

2013-06-25-13:45:46 detecting boot state 3.10.0-rc1-00239-g0bde6c3.	2	6	9	10	11	12............	13.	15	18	24	26	32	37 SUCCESS

Bisecting: 129 revisions left to test after this (roughly 7 steps)
[05959be7b646e8755a9339ad13e3b87849249f90] [media] uvc: Depend on VIDEO_V4L2
running /c/kernel-tests/bisect-test-boot-failure.sh /home/wfg/usb/obj-bisect
ls -a /kernel-tests/run-queue/kvm/x86_64-randconfig-c14-0624/linux-devel:devel-cairo-x86_64-201306251052:05959be7b646e8755a9339ad13e3b87849249f90:bisect-usb

2013-06-25-13:59:22 05959be7b646e8755a9339ad13e3b87849249f90 compiling
210 real  1234 user  111 sys  640.87% cpu 	x86_64-randconfig-c14-0624

2013-06-25-14:06:16 detecting boot state 3.10.0-rc6-00682-g05959be..... TEST FAILURE
dmesg-kvm-roam-65088-20130625140707-3.10.0-rc6-00682-g05959be-88
dmesg-kvm-vp-12353-20130625140943-3.10.0-rc7-00037-g73ff093-83
dmesg-kvm-vp-16909-20130625140932-3.10.0-rc6-00682-g05959be-88
dmesg-kvm-vp-18413-20130625140948--
dmesg-kvm-vp-21717-20130625140940--
dmesg-kvm-vp-23113-20130625140946--
dmesg-kvm-lkp-sbx04-28200-20130625181214-3.10.0-rc7-00026-g7715dad-153
dmesg-kvm-inn-16326-20130625140759-3.10.0-rc7-00426-g3ec9e53-21
dmesg-kvm-inn-29062-20130625140754--
dmesg-kvm-vp-6996-20130625140943-3.10.0-rc7-01686-g67a60db-144
dmesg-kvm-lkp-sbx04-28685-20130625181215-3.10.0-rc7-00037-g73ff093-93
dmesg-kvm-inn-4641-20130625140759-3.10.0-rc6-00682-g05959be-88
dmesg-kvm-lkp-sbx04-10394-20130625181210-3.10.0-rc7-00012-g7d06645-82
dmesg-kvm-lkp-sbx04-63264-20130625181218--
dmesg-kvm-lkp-sbx04-13397-20130625181209--

Bisecting: 54 revisions left to test after this (roughly 6 steps)
[b60f9aa1a9fcf69df963c1f06ee0594d836f6760] [media] f_uvc: add v4l2_device and replace parent with v4l2_dev
running /c/kernel-tests/bisect-test-boot-failure.sh /home/wfg/usb/obj-bisect
ls -a /kernel-tests/run-queue/kvm/x86_64-randconfig-c14-0624/linux-devel:devel-cairo-x86_64-201306251052:b60f9aa1a9fcf69df963c1f06ee0594d836f6760:bisect-usb

2013-06-25-14:08:47 b60f9aa1a9fcf69df963c1f06ee0594d836f6760 compiling
33 real  65 user  8 sys  222.12% cpu 	x86_64-randconfig-c14-0624

2013-06-25-14:09:31 detecting boot state 3.10.0-rc6-00627-gb60f9aa.	23	34	36.....	37 SUCCESS

Bisecting: 27 revisions left to test after this (roughly 5 steps)
[8b0706802fede74a2ee0341499f0b4586118a7d3] [media] soc_camera: Fix checkpatch warning in ov9640.c
running /c/kernel-tests/bisect-test-boot-failure.sh /home/wfg/usb/obj-bisect
ls -a /kernel-tests/run-queue/kvm/x86_64-randconfig-c14-0624/linux-devel:devel-cairo-x86_64-201306251052:8b0706802fede74a2ee0341499f0b4586118a7d3:bisect-usb

2013-06-25-14:14:32 8b0706802fede74a2ee0341499f0b4586118a7d3 compiling
30 real  66 user  8 sys  244.30% cpu 	x86_64-randconfig-c14-0624

2013-06-25-14:15:12 detecting boot state 3.10.0-rc6-00654-g8b07068. TEST FAILURE
dmesg-kvm-lkp-sbx04-13397-20130625181938--
dmesg-kvm-lkp-sbx04-14259-20130625181936-3.10.0-rc7-00037-g73ff093-96
dmesg-kvm-lkp-sbx04-15820-20130625181938--
dmesg-kvm-lkp-sbx04-18597-20130625181937--
dmesg-kvm-lkp-sbx04-32341-20130625181933-3.10.0-rc7-00027-g9cd2e62-148
dmesg-kvm-lkp-sbx04-41496-20130625181935-3.10.0-rc7-00024-g3f61822-88
dmesg-kvm-lkp-sbx04-4605-20130625181935-3.10.0-rc7-00022-g1e3cc57-93
dmesg-kvm-lkp-sbx04-5623-20130625181946-3.10.0-rc1-00031-gd7b4771-26
dmesg-kvm-lkp-sbx04-58854-20130625181931-3.10.0-rc6-00654-g8b07068-90

Bisecting: 13 revisions left to test after this (roughly 4 steps)
[a76a0b338112580593af0f68327e3cc204d4d8e7] [media] media: davinci: vpif_capture: remove unnecessary loop for IRQ resource
running /c/kernel-tests/bisect-test-boot-failure.sh /home/wfg/usb/obj-bisect
ls -a /kernel-tests/run-queue/kvm/x86_64-randconfig-c14-0624/linux-devel:devel-cairo-x86_64-201306251052:a76a0b338112580593af0f68327e3cc204d4d8e7:bisect-usb

2013-06-25-14:15:43 a76a0b338112580593af0f68327e3cc204d4d8e7 compiling
28 real  41 user  6 sys  165.80% cpu 	x86_64-randconfig-c14-0624

2013-06-25-14:16:21 detecting boot state 3.10.0-rc6-00640-ga76a0b3. TEST FAILURE
dmesg-kvm-nhm-6663-20130625134328-3.10.0-rc6-00640-ga76a0b3-91
dmesg-kvm-bay-17419-20130625141913-3.10.0-rc6-00640-ga76a0b3-91
dmesg-kvm-nhm-6755-20130625134321--
dmesg-kvm-nhm-6755-20130625134331--
dmesg-kvm-nhm-6841-20130625134324--
dmesg-kvm-nhm-6841-20130625134332--
dmesg-kvm-nhm-6927-20130625134326--
dmesg-kvm-roam-11727-20130625141550--
dmesg-kvm-roam-16312-20130625141549-3.10.0-rc7-00037-g73ff093-86
dmesg-kvm-roam-17457-20130625141544-3.10.0-rc6-00640-ga76a0b3-91

Bisecting: 6 revisions left to test after this (roughly 3 steps)
[746cb2c31f7d88bac5453e3af45d95670a00ffe8] [media] pvrusb2: Remove unused variable
running /c/kernel-tests/bisect-test-boot-failure.sh /home/wfg/usb/obj-bisect
ls -a /kernel-tests/run-queue/kvm/x86_64-randconfig-c14-0624/linux-devel:devel-cairo-x86_64-201306251052:746cb2c31f7d88bac5453e3af45d95670a00ffe8:bisect-usb

2013-06-25-14:16:52 746cb2c31f7d88bac5453e3af45d95670a00ffe8 compiling
27 real  37 user  6 sys  156.46% cpu 	x86_64-randconfig-c14-0624

2013-06-25-14:17:28 detecting boot state 3.10.0-rc6-00633-g746cb2c. TEST FAILURE
dmesg-kvm-inn-16365-20130625141746--
dmesg-kvm-inn-36980-20130625141745-3.10.0-rc6-00633-g746cb2c-92

Bisecting: 2 revisions left to test after this (roughly 2 steps)
[1c1d86a1ea07506c070cfb217a009d53990bdeb0] [media] v4l2: always require v4l2_dev, rename parent to dev_parent
running /c/kernel-tests/bisect-test-boot-failure.sh /home/wfg/usb/obj-bisect
ls -a /kernel-tests/run-queue/kvm/x86_64-randconfig-c14-0624/linux-devel:devel-cairo-x86_64-201306251052:1c1d86a1ea07506c070cfb217a009d53990bdeb0:bisect-usb

2013-06-25-14:17:59 1c1d86a1ea07506c070cfb217a009d53990bdeb0 compiling
23 real  36 user  5 sys  174.96% cpu 	x86_64-randconfig-c14-0624

2013-06-25-14:18:33 detecting boot state 3.10.0-rc6-00630-g1c1d86a... TEST FAILURE
dmesg-kvm-lkp-sbx04-6328-20130625182310-3.10.0-rc1-00031-gd7b4771-27
dmesg-kvm-bay-17410-20130625142144-3.10.0-rc1-00265-g64e8612-61
dmesg-kvm-lkp-sbx04-8808-20130625182307-3.10.0-rc6-00630-g1c1d86a-93
dmesg-kvm-lkp-sbx04-9171-20130625182308-3.10.0-rc7-00037-g73ff093-88
dmesg-kvm-stoakley-19727-20130625141846-3.10.0-rc6-00630-g1c1d86a-93
dmesg-kvm-stoakley-29599-20130625141847-3.10.0-rc7-00711-g3344592-434
dmesg-kvm-stoakley-4146-20130625141846-3.10.0-rc7-00037-g73ff093-83
dmesg-kvm-bay-17419-20130625142139-3.10.0-rc6-00630-g1c1d86a-93
dmesg-kvm-bens-3449-20130625141818-3.10.0-rc6-00630-g1c1d86a-93
dmesg-kvm-inn-22802-20130625141843-3.10.0-rc6-00630-g1c1d86a-93
dmesg-kvm-inn-24230-20130625141901--
dmesg-kvm-inn-48387-20130625141843-3.10.0-rc6-00630-g1c1d86a-93
dmesg-kvm-lkp-sbx04-13144-20130625182308--
dmesg-kvm-lkp-sbx04-14617-20130625182309-3.10.0-rc1-00265-g64e8612-58
dmesg-kvm-lkp-sbx04-17103-20130625182310-3.10.0-rc1-00031-gd7b4771-26
dmesg-kvm-vp-12746-20130625142042--

Bisecting: 0 revisions left to test after this (roughly 1 step)
[d481c581dfe43be11a17728b5c84c2d4b5beecb2] [media] saa7134: use v4l2_dev instead of the deprecated parent field
running /c/kernel-tests/bisect-test-boot-failure.sh /home/wfg/usb/obj-bisect
ls -a /kernel-tests/run-queue/kvm/x86_64-randconfig-c14-0624/linux-devel:devel-cairo-x86_64-201306251052:d481c581dfe43be11a17728b5c84c2d4b5beecb2:bisect-usb

2013-06-25-14:20:04 d481c581dfe43be11a17728b5c84c2d4b5beecb2 compiling
27 real  63 user  7 sys  258.41% cpu 	x86_64-randconfig-c14-0624

2013-06-25-14:20:41 detecting boot state 3.10.0-rc6-00629-gd481c58..	3	5	7..	8	13	19	33	37 SUCCESS

1c1d86a1ea07506c070cfb217a009d53990bdeb0 is the first bad commit
commit 1c1d86a1ea07506c070cfb217a009d53990bdeb0
Author: Hans Verkuil <hans.verkuil@cisco.com>
Date:   Wed Jun 12 11:15:12 2013 -0300

    [media] v4l2: always require v4l2_dev, rename parent to dev_parent
    
    The last set of drivers still using the parent field of video_device instead
    of the v4l2_dev field have been converted, so v4l2_dev is now always set.
    A proper pointer to v4l2_dev is necessary these days otherwise the advanced
    debugging ioctls will not work when addressing sub-devices. It also ensures
    that the core can always go from a video_device struct to the top-level
    v4l2_device struct.
    There is still one single use case for the parent pointer: if there are
    multiple busses, each being the parent of one or more video nodes, and if
    they all share the same v4l2_device struct. In that case one still needs a
    parent pointer since the v4l2_device struct can only refer to a single
    parent device. The cx88 driver is one such case. Unfortunately, the cx88
    failed to set the parent pointer since 3.6. The next patch will correct this.
    In order to support this use-case the parent pointer is only renamed to
    dev_parent, not removed altogether. It has been renamed to ensure that the
    compiler will catch any (possibly out-of-tree) drivers that were missed during
    the conversion.
    
    Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
    Acked-by: Sakari Ailus <sakari.ailus@iki.fi>
    Acked-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
    Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>

:040000 040000 de4c3eb08b5ea52cccdd92c05c3373583ca41807 155a94cb24653181af9782e5226aa0163cb6b695 M	drivers
:040000 040000 6bcb61d29758b4e3a9d8047a6c664ecf0b9129a9 8e2c643108938304c5610d06c275b32efa0cbf9f M	include
bisect run success
ls -a /kernel-tests/run-queue/kvm/x86_64-randconfig-c14-0624/linux-devel:devel-cairo-x86_64-201306251052:d481c581dfe43be11a17728b5c84c2d4b5beecb2:bisect-usb

2013-06-25-14:26:42 d481c581dfe43be11a17728b5c84c2d4b5beecb2 reuse /kernel/x86_64-randconfig-c14-0624/d481c581dfe43be11a17728b5c84c2d4b5beecb2/vmlinuz-3.10.0-rc6-00629-gd481c58

2013-06-25-14:26:43 detecting boot state .	40..	63	79	93	111 SUCCESS

ls -a /kernel-tests/run-queue/kvm/x86_64-randconfig-c14-0624/linux-devel:devel-cairo-x86_64-201306251052:e90d833ed71ac503e3b33b7ad970fc52cb67d9ed:bisect-usb
 TEST FAILURE
/kernel/x86_64-randconfig-c14-0624/e90d833ed71ac503e3b33b7ad970fc52cb67d9ed/dmesg-kvm-lkp-sbx04-10472-20130625174116--
/kernel/x86_64-randconfig-c14-0624/e90d833ed71ac503e3b33b7ad970fc52cb67d9ed/dmesg-kvm-lkp-sbx04-1167-20130625154150--
/kernel/x86_64-randconfig-c14-0624/e90d833ed71ac503e3b33b7ad970fc52cb67d9ed/dmesg-kvm-lkp-sbx04-14617-20130625174048--
/kernel/x86_64-randconfig-c14-0624/e90d833ed71ac503e3b33b7ad970fc52cb67d9ed/dmesg-kvm-lkp-sbx04-1672-20130625174101--
/kernel/x86_64-randconfig-c14-0624/e90d833ed71ac503e3b33b7ad970fc52cb67d9ed/dmesg-kvm-lkp-sbx04-18597-20130625174108--
/kernel/x86_64-randconfig-c14-0624/e90d833ed71ac503e3b33b7ad970fc52cb67d9ed/dmesg-kvm-lkp-sbx04-21449-20130625154118--
/kernel/x86_64-randconfig-c14-0624/e90d833ed71ac503e3b33b7ad970fc52cb67d9ed/dmesg-kvm-lkp-sbx04-30430-20130625174041--
/kernel/x86_64-randconfig-c14-0624/e90d833ed71ac503e3b33b7ad970fc52cb67d9ed/dmesg-kvm-lkp-sbx04-30795-20130625154106-3.10.0-rc7-00478-ge90d833-28
/kernel/x86_64-randconfig-c14-0624/e90d833ed71ac503e3b33b7ad970fc52cb67d9ed/dmesg-kvm-lkp-sbx04-37066-20130625174115--
/kernel/x86_64-randconfig-c14-0624/e90d833ed71ac503e3b33b7ad970fc52cb67d9ed/dmesg-kvm-lkp-sbx04-40314-20130625174033--
/kernel/x86_64-randconfig-c14-0624/e90d833ed71ac503e3b33b7ad970fc52cb67d9ed/dmesg-kvm-lkp-sbx04-45963-20130625154145-3.10.0-rc7-00478-ge90d833-28
/kernel/x86_64-randconfig-c14-0624/e90d833ed71ac503e3b33b7ad970fc52cb67d9ed/dmesg-kvm-lkp-sbx04-48279-20130625174111--
/kernel/x86_64-randconfig-c14-0624/e90d833ed71ac503e3b33b7ad970fc52cb67d9ed/dmesg-kvm-lkp-sbx04-48279-20130625174125--
/kernel/x86_64-randconfig-c14-0624/e90d833ed71ac503e3b33b7ad970fc52cb67d9ed/dmesg-kvm-lkp-sbx04-48279-20130625174138--
/kernel/x86_64-randconfig-c14-0624/e90d833ed71ac503e3b33b7ad970fc52cb67d9ed/dmesg-kvm-lkp-sbx04-51786-20130625174111--
/kernel/x86_64-randconfig-c14-0624/e90d833ed71ac503e3b33b7ad970fc52cb67d9ed/dmesg-kvm-lkp-sbx04-51786-20130625174124--
/kernel/x86_64-randconfig-c14-0624/e90d833ed71ac503e3b33b7ad970fc52cb67d9ed/dmesg-kvm-lkp-sbx04-5405-20130625154114-3.10.0-rc7-00478-ge90d833-26
/kernel/x86_64-randconfig-c14-0624/e90d833ed71ac503e3b33b7ad970fc52cb67d9ed/dmesg-kvm-lkp-sbx04-60068-20130625174026-3.10.0-rc7-00478-ge90d833-28
/kernel/x86_64-randconfig-c14-0624/e90d833ed71ac503e3b33b7ad970fc52cb67d9ed/dmesg-kvm-lkp-sbx04-7632-20130625174035--
/kernel/x86_64-randconfig-c14-0624/e90d833ed71ac503e3b33b7ad970fc52cb67d9ed/dmesg-kvm-lkp-sbx04-7632-20130625174048--
/kernel/x86_64-randconfig-c14-0624/e90d833ed71ac503e3b33b7ad970fc52cb67d9ed/dmesg-kvm-lkp-sbx04-7979-20130625174031--
/kernel/x86_64-randconfig-c14-0624/e90d833ed71ac503e3b33b7ad970fc52cb67d9ed/dmesg-kvm-lkp-sbx04-8808-20130625154121-3.10.0-rc7-00478-ge90d833-26
/kernel/x86_64-randconfig-c14-0624/e90d833ed71ac503e3b33b7ad970fc52cb67d9ed/dmesg-kvm-lkp-sbx04-9007-20130625174131--
/kernel/x86_64-randconfig-c14-0624/e90d833ed71ac503e3b33b7ad970fc52cb67d9ed/dmesg-kvm-stoakley-31810-20130625113723-3.10.0-rc7-00478-ge90d833-28
/kernel/x86_64-randconfig-c14-0624/e90d833ed71ac503e3b33b7ad970fc52cb67d9ed/dmesg-kvm-vp-14538-20130625113920-3.10.0-rc7-00478-ge90d833-28
/kernel/x86_64-randconfig-c14-0624/e90d833ed71ac503e3b33b7ad970fc52cb67d9ed/dmesg-kvm-vp-15345-20130625133846--
/kernel/x86_64-randconfig-c14-0624/e90d833ed71ac503e3b33b7ad970fc52cb67d9ed/dmesg-kvm-vp-16217-20130625133825-3.10.0-rc7-00478-ge90d833-28
/kernel/x86_64-randconfig-c14-0624/e90d833ed71ac503e3b33b7ad970fc52cb67d9ed/dmesg-kvm-vp-8313-20130625113928--
/kernel/x86_64-randconfig-c14-0624/e90d833ed71ac503e3b33b7ad970fc52cb67d9ed/dmesg-kvm-waimea-8948-20130625134005-3.10.0-rc7-00478-ge90d833-28

[detached HEAD 7998148] Revert "[media] v4l2: always require v4l2_dev, rename parent to dev_parent"
 3 files changed, 27 insertions(+), 18 deletions(-)
ls -a /kernel-tests/run-queue/kvm/x86_64-randconfig-c14-0624/linux-devel:devel-cairo-x86_64-201306251052:79981489b8b25b70e1c36d08ab86dbb1fb88f0a6:bisect-usb

2013-06-25-14:30:45 79981489b8b25b70e1c36d08ab86dbb1fb88f0a6 compiling

2013-06-25-14:33:41 detecting boot state 3.10.0-rc7-00925-g7998148..	2	21	26	27	65	102	108	109...................	110.............	111 SUCCESS


========= upstream =========
Fetching linus
ls -a /kernel-tests/run-queue/kvm/x86_64-randconfig-c14-0624/linux-devel:devel-cairo-x86_64-201306251052:f97f7d2d27bf092b40babda9ded29cc85cf77eec:bisect-usb

2013-06-25-14:55:43 f97f7d2d27bf092b40babda9ded29cc85cf77eec compiling

2013-06-25-14:58:46 detecting boot state 3.10.0-rc7-00460-gf97f7d2...	1	5	10	19	23	27	28.	35	39	40	49	70	74.	91	101	104	108	110	111 SUCCESS


========= linux-next =========
Fetching next
ls -a /kernel-tests/run-queue/kvm/x86_64-randconfig-c14-0624/linux-devel:devel-cairo-x86_64-201306251052:34fe2f4be68a2fe90c5aaa67bc906a191799ec66:bisect-usb

2013-06-25-15:10:50 34fe2f4be68a2fe90c5aaa67bc906a191799ec66 compiling

2013-06-25-15:14:06 detecting boot state 3.10.0-rc7-next-20130624-08512-g34fe2f4...	14	18	44	49	56	89	101	107	111 SUCCESS


--W/nzBZO5zC0uMSeA
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename=".config-bisect"

#
# Automatically generated file; DO NOT EDIT.
# Linux/x86_64 3.10.0-rc7 Kernel Configuration
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
CONFIG_LOCALVERSION=""
CONFIG_LOCALVERSION_AUTO=y
CONFIG_HAVE_KERNEL_GZIP=y
CONFIG_HAVE_KERNEL_BZIP2=y
CONFIG_HAVE_KERNEL_LZMA=y
CONFIG_HAVE_KERNEL_XZ=y
CONFIG_HAVE_KERNEL_LZO=y
# CONFIG_KERNEL_GZIP is not set
# CONFIG_KERNEL_BZIP2 is not set
# CONFIG_KERNEL_LZMA is not set
CONFIG_KERNEL_XZ=y
# CONFIG_KERNEL_LZO is not set
CONFIG_DEFAULT_HOSTNAME="(none)"
# CONFIG_SWAP is not set
CONFIG_SYSVIPC=y
CONFIG_SYSVIPC_SYSCTL=y
# CONFIG_POSIX_MQUEUE is not set
# CONFIG_FHANDLE is not set
CONFIG_AUDIT=y
CONFIG_AUDITSYSCALL=y
CONFIG_AUDIT_WATCH=y
CONFIG_AUDIT_TREE=y
# CONFIG_AUDIT_LOGINUID_IMMUTABLE is not set
CONFIG_HAVE_GENERIC_HARDIRQS=y

#
# IRQ subsystem
#
CONFIG_GENERIC_HARDIRQS=y
CONFIG_GENERIC_IRQ_PROBE=y
CONFIG_GENERIC_IRQ_SHOW=y
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
CONFIG_NO_HZ=y
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
# CONFIG_RCU_STALL_COMMON is not set
CONFIG_CONTEXT_TRACKING=y
CONFIG_CONTEXT_TRACKING_FORCE=y
# CONFIG_TREE_RCU_TRACE is not set
CONFIG_IKCONFIG=y
CONFIG_IKCONFIG_PROC=y
CONFIG_LOG_BUF_SHIFT=17
CONFIG_HAVE_UNSTABLE_SCHED_CLOCK=y
CONFIG_ARCH_SUPPORTS_NUMA_BALANCING=y
CONFIG_ARCH_WANTS_PROT_NUMA_PROT_NONE=y
CONFIG_CGROUPS=y
CONFIG_CGROUP_DEBUG=y
CONFIG_CGROUP_FREEZER=y
CONFIG_CGROUP_DEVICE=y
CONFIG_CPUSETS=y
CONFIG_PROC_PID_CPUSET=y
# CONFIG_CGROUP_CPUACCT is not set
CONFIG_RESOURCE_COUNTERS=y
# CONFIG_MEMCG is not set
# CONFIG_CGROUP_PERF is not set
CONFIG_CGROUP_SCHED=y
CONFIG_FAIR_GROUP_SCHED=y
CONFIG_CFS_BANDWIDTH=y
CONFIG_RT_GROUP_SCHED=y
CONFIG_BLK_CGROUP=y
CONFIG_DEBUG_BLK_CGROUP=y
# CONFIG_CHECKPOINT_RESTORE is not set
CONFIG_NAMESPACES=y
# CONFIG_UTS_NS is not set
# CONFIG_IPC_NS is not set
# CONFIG_USER_NS is not set
CONFIG_PID_NS=y
# CONFIG_NET_NS is not set
CONFIG_UIDGID_CONVERTED=y
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
CONFIG_CC_OPTIMIZE_FOR_SIZE=y
CONFIG_SYSCTL=y
CONFIG_ANON_INODES=y
CONFIG_HAVE_UID16=y
CONFIG_SYSCTL_EXCEPTION_TRACE=y
CONFIG_HOTPLUG=y
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

#
# Kernel Performance Events And Counters
#
CONFIG_PERF_EVENTS=y
# CONFIG_DEBUG_PERF_USE_VMALLOC is not set
CONFIG_VM_EVENT_COUNTERS=y
CONFIG_SLUB_DEBUG=y
# CONFIG_COMPAT_BRK is not set
# CONFIG_SLAB is not set
CONFIG_SLUB=y
CONFIG_PROFILING=y
CONFIG_OPROFILE=y
CONFIG_OPROFILE_EVENT_MULTIPLEX=y
CONFIG_HAVE_OPROFILE=y
CONFIG_OPROFILE_NMI_TIMER=y
# CONFIG_JUMP_LABEL is not set
# CONFIG_HAVE_64BIT_ALIGNED_ACCESS is not set
CONFIG_HAVE_EFFICIENT_UNALIGNED_ACCESS=y
CONFIG_ARCH_USE_BUILTIN_BSWAP=y
CONFIG_USER_RETURN_NOTIFIER=y
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
CONFIG_HAVE_CONTEXT_TRACKING=y
CONFIG_HAVE_IRQ_TIME_ACCOUNTING=y
CONFIG_HAVE_ARCH_TRANSPARENT_HUGEPAGE=y
CONFIG_MODULES_USE_ELF_RELA=y
CONFIG_OLD_SIGSUSPEND3=y
CONFIG_COMPAT_OLD_SIGACTION=y

#
# GCOV-based kernel profiling
#
CONFIG_GCOV_KERNEL=y
# CONFIG_GCOV_PROFILE_ALL is not set
# CONFIG_HAVE_GENERIC_DMA_COHERENT is not set
CONFIG_SLABINFO=y
CONFIG_RT_MUTEXES=y
CONFIG_BASE_SMALL=0
# CONFIG_MODULES is not set
CONFIG_BLOCK=y
CONFIG_BLK_DEV_BSG=y
# CONFIG_BLK_DEV_BSGLIB is not set
# CONFIG_BLK_DEV_INTEGRITY is not set
CONFIG_BLK_DEV_THROTTLING=y

#
# Partition Types
#
CONFIG_PARTITION_ADVANCED=y
CONFIG_ACORN_PARTITION=y
# CONFIG_ACORN_PARTITION_CUMANA is not set
# CONFIG_ACORN_PARTITION_EESOX is not set
CONFIG_ACORN_PARTITION_ICS=y
CONFIG_ACORN_PARTITION_ADFS=y
# CONFIG_ACORN_PARTITION_POWERTEC is not set
CONFIG_ACORN_PARTITION_RISCIX=y
CONFIG_OSF_PARTITION=y
# CONFIG_AMIGA_PARTITION is not set
CONFIG_ATARI_PARTITION=y
# CONFIG_MAC_PARTITION is not set
# CONFIG_MSDOS_PARTITION is not set
# CONFIG_LDM_PARTITION is not set
# CONFIG_SGI_PARTITION is not set
CONFIG_ULTRIX_PARTITION=y
CONFIG_SUN_PARTITION=y
CONFIG_KARMA_PARTITION=y
# CONFIG_EFI_PARTITION is not set
# CONFIG_SYSV68_PARTITION is not set
CONFIG_BLOCK_COMPAT=y

#
# IO Schedulers
#
CONFIG_IOSCHED_NOOP=y
# CONFIG_IOSCHED_DEADLINE is not set
# CONFIG_IOSCHED_CFQ is not set
CONFIG_DEFAULT_NOOP=y
CONFIG_DEFAULT_IOSCHED="noop"
CONFIG_PREEMPT_NOTIFIERS=y
CONFIG_UNINLINE_SPIN_UNLOCK=y
CONFIG_FREEZER=y

#
# Processor type and features
#
CONFIG_ZONE_DMA=y
# CONFIG_SMP is not set
CONFIG_X86_MPPARSE=y
# CONFIG_X86_EXTENDED_PLATFORM is not set
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
CONFIG_CPU_SUP_INTEL=y
CONFIG_CPU_SUP_AMD=y
CONFIG_CPU_SUP_CENTAUR=y
CONFIG_HPET_TIMER=y
CONFIG_HPET_EMULATE_RTC=y
CONFIG_DMI=y
CONFIG_GART_IOMMU=y
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
CONFIG_X86_MCE=y
# CONFIG_X86_MCE_INTEL is not set
# CONFIG_X86_MCE_AMD is not set
# CONFIG_X86_MCE_INJECT is not set
# CONFIG_I8K is not set
CONFIG_MICROCODE=y
CONFIG_MICROCODE_INTEL=y
# CONFIG_MICROCODE_AMD is not set
CONFIG_MICROCODE_OLD_INTERFACE=y
CONFIG_MICROCODE_INTEL_LIB=y
CONFIG_MICROCODE_INTEL_EARLY=y
CONFIG_MICROCODE_EARLY=y
CONFIG_X86_MSR=y
# CONFIG_X86_CPUID is not set
CONFIG_ARCH_PHYS_ADDR_T_64BIT=y
CONFIG_ARCH_DMA_ADDR_T_64BIT=y
CONFIG_DIRECT_GBPAGES=y
CONFIG_ARCH_SPARSEMEM_ENABLE=y
CONFIG_ARCH_SPARSEMEM_DEFAULT=y
CONFIG_ARCH_SELECT_MEMORY_MODEL=y
CONFIG_ARCH_MEMORY_PROBE=y
CONFIG_ARCH_PROC_KCORE_TEXT=y
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
CONFIG_MEMORY_ISOLATION=y
# CONFIG_HAVE_BOOTMEM_INFO_NODE is not set
CONFIG_MEMORY_HOTPLUG=y
CONFIG_MEMORY_HOTPLUG_SPARSE=y
# CONFIG_MEMORY_HOTREMOVE is not set
CONFIG_PAGEFLAGS_EXTENDED=y
CONFIG_SPLIT_PTLOCK_CPUS=999999
CONFIG_BALLOON_COMPACTION=y
CONFIG_COMPACTION=y
CONFIG_MIGRATION=y
CONFIG_PHYS_ADDR_T_64BIT=y
CONFIG_ZONE_DMA_FLAG=1
CONFIG_BOUNCE=y
CONFIG_VIRT_TO_BUS=y
CONFIG_MMU_NOTIFIER=y
CONFIG_KSM=y
CONFIG_DEFAULT_MMAP_MIN_ADDR=4096
CONFIG_ARCH_SUPPORTS_MEMORY_FAILURE=y
CONFIG_MEMORY_FAILURE=y
CONFIG_HWPOISON_INJECT=y
CONFIG_TRANSPARENT_HUGEPAGE=y
CONFIG_TRANSPARENT_HUGEPAGE_ALWAYS=y
# CONFIG_TRANSPARENT_HUGEPAGE_MADVISE is not set
CONFIG_CROSS_MEMORY_ATTACH=y
CONFIG_NEED_PER_CPU_KM=y
# CONFIG_CLEANCACHE is not set
CONFIG_X86_CHECK_BIOS_CORRUPTION=y
CONFIG_X86_BOOTPARAM_MEMORY_CORRUPTION_CHECK=y
CONFIG_X86_RESERVE_LOW=64
CONFIG_MTRR=y
CONFIG_MTRR_SANITIZER=y
CONFIG_MTRR_SANITIZER_ENABLE_DEFAULT=0
CONFIG_MTRR_SANITIZER_SPARE_REG_NR_DEFAULT=1
CONFIG_X86_PAT=y
CONFIG_ARCH_USES_PG_UNCACHED=y
CONFIG_ARCH_RANDOM=y
CONFIG_X86_SMAP=y
# CONFIG_EFI is not set
# CONFIG_SECCOMP is not set
# CONFIG_CC_STACKPROTECTOR is not set
# CONFIG_HZ_100 is not set
# CONFIG_HZ_250 is not set
# CONFIG_HZ_300 is not set
CONFIG_HZ_1000=y
CONFIG_HZ=1000
CONFIG_SCHED_HRTICK=y
# CONFIG_KEXEC is not set
# CONFIG_CRASH_DUMP is not set
CONFIG_PHYSICAL_START=0x1000000
CONFIG_RELOCATABLE=y
CONFIG_PHYSICAL_ALIGN=0x1000000
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
CONFIG_ACPI=y
# CONFIG_ACPI_PROCFS is not set
# CONFIG_ACPI_PROCFS_POWER is not set
# CONFIG_ACPI_EC_DEBUGFS is not set
CONFIG_ACPI_PROC_EVENT=y
CONFIG_ACPI_AC=y
CONFIG_ACPI_BATTERY=y
CONFIG_ACPI_BUTTON=y
CONFIG_ACPI_FAN=y
# CONFIG_ACPI_DOCK is not set
CONFIG_ACPI_I2C=y
CONFIG_ACPI_PROCESSOR=y
# CONFIG_ACPI_IPMI is not set
# CONFIG_ACPI_PROCESSOR_AGGREGATOR is not set
CONFIG_ACPI_THERMAL=y
CONFIG_ACPI_CUSTOM_DSDT_FILE=""
# CONFIG_ACPI_CUSTOM_DSDT is not set
# CONFIG_ACPI_INITRD_TABLE_OVERRIDE is not set
CONFIG_ACPI_BLACKLIST_YEAR=0
# CONFIG_ACPI_DEBUG is not set
# CONFIG_ACPI_PCI_SLOT is not set
CONFIG_X86_PM_TIMER=y
# CONFIG_ACPI_CONTAINER is not set
# CONFIG_ACPI_HOTPLUG_MEMORY is not set
# CONFIG_ACPI_SBS is not set
# CONFIG_ACPI_HED is not set
# CONFIG_ACPI_CUSTOM_METHOD is not set
# CONFIG_ACPI_APEI is not set
CONFIG_SFI=y

#
# CPU Frequency scaling
#
# CONFIG_CPU_FREQ is not set
CONFIG_CPU_IDLE=y
# CONFIG_CPU_IDLE_MULTIPLE_DRIVERS is not set
CONFIG_CPU_IDLE_GOV_LADDER=y
CONFIG_CPU_IDLE_GOV_MENU=y
# CONFIG_ARCH_NEEDS_CPU_IDLE_COUPLED is not set
# CONFIG_INTEL_IDLE is not set

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
# CONFIG_PCIEPORTBUS is not set
CONFIG_ARCH_SUPPORTS_MSI=y
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
CONFIG_ISA_DMA_API=y
CONFIG_AMD_NB=y
# CONFIG_PCCARD is not set
# CONFIG_HOTPLUG_PCI is not set
# CONFIG_RAPIDIO is not set

#
# Executable file formats / Emulations
#
CONFIG_BINFMT_ELF=y
CONFIG_COMPAT_BINFMT_ELF=y
CONFIG_ARCH_BINFMT_ELF_RANDOMIZE_PIE=y
CONFIG_CORE_DUMP_DEFAULT_ELF_HEADERS=y
# CONFIG_BINFMT_SCRIPT is not set
# CONFIG_HAVE_AOUT is not set
# CONFIG_BINFMT_MISC is not set
CONFIG_COREDUMP=y
CONFIG_IA32_EMULATION=y
CONFIG_IA32_AOUT=y
# CONFIG_X86_X32 is not set
CONFIG_COMPAT=y
CONFIG_COMPAT_FOR_U64_ALIGNMENT=y
CONFIG_SYSVIPC_COMPAT=y
CONFIG_HAVE_TEXT_POKE_SMP=y
CONFIG_X86_DEV_DMA_OPS=y
CONFIG_NET=y
CONFIG_COMPAT_NETLINK_MESSAGES=y

#
# Networking options
#
# CONFIG_PACKET is not set
CONFIG_UNIX=y
# CONFIG_UNIX_DIAG is not set
CONFIG_XFRM=y
CONFIG_XFRM_ALGO=y
# CONFIG_XFRM_SUB_POLICY is not set
CONFIG_XFRM_MIGRATE=y
CONFIG_NET_KEY=y
# CONFIG_NET_KEY_MIGRATE is not set
# CONFIG_INET is not set
CONFIG_NETWORK_SECMARK=y
# CONFIG_NETWORK_PHY_TIMESTAMPING is not set
CONFIG_NETFILTER=y
# CONFIG_NETFILTER_DEBUG is not set
# CONFIG_NETFILTER_ADVANCED is not set
CONFIG_ATM=y
CONFIG_ATM_LANE=y
CONFIG_STP=y
CONFIG_GARP=y
CONFIG_MRP=y
# CONFIG_BRIDGE is not set
CONFIG_HAVE_NET_DSA=y
CONFIG_NET_DSA=y
CONFIG_NET_DSA_TAG_DSA=y
CONFIG_NET_DSA_TAG_EDSA=y
CONFIG_NET_DSA_TAG_TRAILER=y
CONFIG_VLAN_8021Q=y
CONFIG_VLAN_8021Q_GVRP=y
CONFIG_VLAN_8021Q_MVRP=y
# CONFIG_DECNET is not set
CONFIG_LLC=y
CONFIG_LLC2=y
CONFIG_IPX=y
CONFIG_IPX_INTERN=y
CONFIG_ATALK=y
CONFIG_DEV_APPLETALK=y
# CONFIG_IPDDP is not set
CONFIG_X25=y
CONFIG_LAPB=y
CONFIG_PHONET=y
# CONFIG_IEEE802154 is not set
CONFIG_NET_SCHED=y

#
# Queueing/Scheduling
#
# CONFIG_NET_SCH_CBQ is not set
# CONFIG_NET_SCH_HTB is not set
CONFIG_NET_SCH_HFSC=y
CONFIG_NET_SCH_ATM=y
CONFIG_NET_SCH_PRIO=y
# CONFIG_NET_SCH_MULTIQ is not set
CONFIG_NET_SCH_RED=y
CONFIG_NET_SCH_SFB=y
CONFIG_NET_SCH_SFQ=y
# CONFIG_NET_SCH_TEQL is not set
CONFIG_NET_SCH_TBF=y
CONFIG_NET_SCH_GRED=y
CONFIG_NET_SCH_DSMARK=y
CONFIG_NET_SCH_NETEM=y
# CONFIG_NET_SCH_DRR is not set
CONFIG_NET_SCH_MQPRIO=y
CONFIG_NET_SCH_CHOKE=y
CONFIG_NET_SCH_QFQ=y
# CONFIG_NET_SCH_CODEL is not set
CONFIG_NET_SCH_FQ_CODEL=y
# CONFIG_NET_SCH_INGRESS is not set
# CONFIG_NET_SCH_PLUG is not set

#
# Classification
#
CONFIG_NET_CLS=y
CONFIG_NET_CLS_BASIC=y
CONFIG_NET_CLS_TCINDEX=y
CONFIG_NET_CLS_FW=y
CONFIG_NET_CLS_U32=y
# CONFIG_CLS_U32_PERF is not set
# CONFIG_CLS_U32_MARK is not set
CONFIG_NET_CLS_RSVP=y
# CONFIG_NET_CLS_RSVP6 is not set
CONFIG_NET_CLS_FLOW=y
CONFIG_NET_CLS_CGROUP=y
CONFIG_NET_EMATCH=y
CONFIG_NET_EMATCH_STACK=32
# CONFIG_NET_EMATCH_CMP is not set
CONFIG_NET_EMATCH_NBYTE=y
CONFIG_NET_EMATCH_U32=y
CONFIG_NET_EMATCH_META=y
# CONFIG_NET_EMATCH_TEXT is not set
CONFIG_NET_CLS_ACT=y
CONFIG_NET_ACT_POLICE=y
CONFIG_NET_ACT_GACT=y
# CONFIG_GACT_PROB is not set
CONFIG_NET_ACT_MIRRED=y
# CONFIG_NET_ACT_NAT is not set
# CONFIG_NET_ACT_PEDIT is not set
# CONFIG_NET_ACT_SIMP is not set
# CONFIG_NET_ACT_SKBEDIT is not set
CONFIG_NET_CLS_IND=y
CONFIG_NET_SCH_FIFO=y
CONFIG_DCB=y
CONFIG_BATMAN_ADV=y
# CONFIG_BATMAN_ADV_NC is not set
CONFIG_BATMAN_ADV_DEBUG=y
# CONFIG_OPENVSWITCH is not set
# CONFIG_VSOCKETS is not set
CONFIG_NETLINK_MMAP=y
CONFIG_NETLINK_DIAG=y
CONFIG_NETPRIO_CGROUP=y
CONFIG_BQL=y

#
# Network testing
#
CONFIG_NET_PKTGEN=y
CONFIG_HAMRADIO=y

#
# Packet Radio protocols
#
# CONFIG_AX25 is not set
# CONFIG_CAN is not set
CONFIG_IRDA=y

#
# IrDA protocols
#
# CONFIG_IRLAN is not set
# CONFIG_IRNET is not set
# CONFIG_IRCOMM is not set
CONFIG_IRDA_ULTRA=y

#
# IrDA options
#
# CONFIG_IRDA_CACHE_LAST_LSAP is not set
CONFIG_IRDA_FAST_RR=y
# CONFIG_IRDA_DEBUG is not set

#
# Infrared-port device drivers
#

#
# SIR device drivers
#
CONFIG_IRTTY_SIR=y

#
# Dongle support
#
# CONFIG_DONGLE is not set

#
# FIR device drivers
#
CONFIG_NSC_FIR=y
CONFIG_WINBOND_FIR=y
CONFIG_SMC_IRCC_FIR=y
CONFIG_ALI_FIR=y
# CONFIG_VLSI_FIR is not set
CONFIG_VIA_FIR=y
CONFIG_BT=y
CONFIG_BT_RFCOMM=y
CONFIG_BT_RFCOMM_TTY=y
CONFIG_BT_BNEP=y
# CONFIG_BT_BNEP_MC_FILTER is not set
CONFIG_BT_BNEP_PROTO_FILTER=y
# CONFIG_BT_HIDP is not set

#
# Bluetooth device drivers
#
CONFIG_BT_HCIBTSDIO=y
CONFIG_BT_HCIUART=y
# CONFIG_BT_HCIUART_H4 is not set
CONFIG_BT_HCIUART_BCSP=y
# CONFIG_BT_HCIUART_ATH3K is not set
CONFIG_BT_HCIUART_LL=y
CONFIG_BT_HCIUART_3WIRE=y
CONFIG_BT_HCIVHCI=y
CONFIG_BT_MRVL=y
CONFIG_BT_MRVL_SDIO=y
# CONFIG_BT_WILINK is not set
CONFIG_WIRELESS=y
CONFIG_WIRELESS_EXT=y
CONFIG_WEXT_CORE=y
CONFIG_WEXT_PROC=y
CONFIG_WEXT_SPY=y
CONFIG_WEXT_PRIV=y
CONFIG_CFG80211=y
CONFIG_NL80211_TESTMODE=y
# CONFIG_CFG80211_DEVELOPER_WARNINGS is not set
# CONFIG_CFG80211_REG_DEBUG is not set
# CONFIG_CFG80211_DEFAULT_PS is not set
# CONFIG_CFG80211_DEBUGFS is not set
# CONFIG_CFG80211_INTERNAL_REGDB is not set
# CONFIG_CFG80211_WEXT is not set
CONFIG_LIB80211=y
CONFIG_LIB80211_CRYPT_WEP=y
CONFIG_LIB80211_CRYPT_CCMP=y
CONFIG_LIB80211_CRYPT_TKIP=y
CONFIG_LIB80211_DEBUG=y
# CONFIG_MAC80211 is not set
# CONFIG_WIMAX is not set
CONFIG_RFKILL=y
CONFIG_RFKILL_LEDS=y
CONFIG_RFKILL_INPUT=y
CONFIG_RFKILL_REGULATOR=y
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
CONFIG_DEVTMPFS_MOUNT=y
# CONFIG_STANDALONE is not set
CONFIG_PREVENT_FIRMWARE_BUILD=y
CONFIG_FW_LOADER=y
# CONFIG_FIRMWARE_IN_KERNEL is not set
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
# CONFIG_DMA_SHARED_BUFFER is not set

#
# Bus devices
#
CONFIG_CONNECTOR=y
# CONFIG_PROC_EVENTS is not set
CONFIG_MTD=y
CONFIG_MTD_REDBOOT_PARTS=y
CONFIG_MTD_REDBOOT_DIRECTORY_BLOCK=-1
CONFIG_MTD_REDBOOT_PARTS_UNALLOCATED=y
CONFIG_MTD_REDBOOT_PARTS_READONLY=y
CONFIG_MTD_CMDLINE_PARTS=y
CONFIG_MTD_AR7_PARTS=y

#
# User Modules And Translation Layers
#
CONFIG_MTD_BLKDEVS=y
CONFIG_MTD_BLOCK=y
CONFIG_FTL=y
CONFIG_NFTL=y
CONFIG_NFTL_RW=y
CONFIG_INFTL=y
CONFIG_RFD_FTL=y
CONFIG_SSFDC=y
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
# CONFIG_MTD_CFI_BE_BYTE_SWAP is not set
CONFIG_MTD_CFI_LE_BYTE_SWAP=y
CONFIG_MTD_CFI_GEOMETRY=y
CONFIG_MTD_MAP_BANK_WIDTH_1=y
CONFIG_MTD_MAP_BANK_WIDTH_2=y
CONFIG_MTD_MAP_BANK_WIDTH_4=y
# CONFIG_MTD_MAP_BANK_WIDTH_8 is not set
# CONFIG_MTD_MAP_BANK_WIDTH_16 is not set
CONFIG_MTD_MAP_BANK_WIDTH_32=y
# CONFIG_MTD_CFI_I1 is not set
# CONFIG_MTD_CFI_I2 is not set
CONFIG_MTD_CFI_I4=y
CONFIG_MTD_CFI_I8=y
# CONFIG_MTD_OTP is not set
CONFIG_MTD_CFI_INTELEXT=y
CONFIG_MTD_CFI_AMDSTD=y
# CONFIG_MTD_CFI_STAA is not set
CONFIG_MTD_CFI_UTIL=y
CONFIG_MTD_RAM=y
CONFIG_MTD_ROM=y
CONFIG_MTD_ABSENT=y

#
# Mapping drivers for chip access
#
CONFIG_MTD_COMPLEX_MAPPINGS=y
CONFIG_MTD_PHYSMAP=y
CONFIG_MTD_PHYSMAP_COMPAT=y
CONFIG_MTD_PHYSMAP_START=0x8000000
CONFIG_MTD_PHYSMAP_LEN=0
CONFIG_MTD_PHYSMAP_BANKWIDTH=2
# CONFIG_MTD_SC520CDP is not set
CONFIG_MTD_NETSC520=y
# CONFIG_MTD_TS5500 is not set
# CONFIG_MTD_SBC_GXX is not set
CONFIG_MTD_AMD76XROM=y
CONFIG_MTD_ICHXROM=y
# CONFIG_MTD_ESB2ROM is not set
# CONFIG_MTD_CK804XROM is not set
# CONFIG_MTD_SCB2_FLASH is not set
# CONFIG_MTD_NETtel is not set
CONFIG_MTD_L440GX=y
# CONFIG_MTD_PCI is not set
CONFIG_MTD_GPIO_ADDR=y
# CONFIG_MTD_INTEL_VR_NOR is not set
CONFIG_MTD_PLATRAM=y
CONFIG_MTD_LATCH_ADDR=y

#
# Self-contained MTD device drivers
#
# CONFIG_MTD_PMC551 is not set
CONFIG_MTD_DATAFLASH=y
# CONFIG_MTD_DATAFLASH_WRITE_VERIFY is not set
# CONFIG_MTD_DATAFLASH_OTP is not set
CONFIG_MTD_M25P80=y
CONFIG_M25PXX_USE_FAST_READ=y
CONFIG_MTD_SST25L=y
# CONFIG_MTD_SLRAM is not set
CONFIG_MTD_PHRAM=y
CONFIG_MTD_MTDRAM=y
CONFIG_MTDRAM_TOTAL_SIZE=4096
CONFIG_MTDRAM_ERASE_SIZE=128
CONFIG_MTDRAM_ABS_POS=0
CONFIG_MTD_BLOCK2MTD=y

#
# Disk-On-Chip Device Drivers
#
# CONFIG_MTD_DOCG3 is not set
CONFIG_MTD_NAND_ECC=y
CONFIG_MTD_NAND_ECC_SMC=y
# CONFIG_MTD_NAND is not set
CONFIG_MTD_ONENAND=y
# CONFIG_MTD_ONENAND_VERIFY_WRITE is not set
CONFIG_MTD_ONENAND_GENERIC=y
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
# CONFIG_MTD_UBI_FASTMAP is not set
CONFIG_MTD_UBI_GLUEBI=y
# CONFIG_PARPORT is not set
CONFIG_PNP=y
CONFIG_PNP_DEBUG_MESSAGES=y

#
# Protocols
#
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
CONFIG_AD525X_DPOT=y
# CONFIG_AD525X_DPOT_I2C is not set
# CONFIG_AD525X_DPOT_SPI is not set
# CONFIG_DUMMY_IRQ is not set
# CONFIG_IBM_ASM is not set
# CONFIG_PHANTOM is not set
# CONFIG_INTEL_MID_PTI is not set
# CONFIG_SGI_IOC4 is not set
# CONFIG_TIFM_CORE is not set
CONFIG_ICS932S401=y
# CONFIG_ATMEL_SSC is not set
CONFIG_ENCLOSURE_SERVICES=y
# CONFIG_HP_ILO is not set
CONFIG_APDS9802ALS=y
CONFIG_ISL29003=y
CONFIG_ISL29020=y
CONFIG_SENSORS_TSL2550=y
CONFIG_SENSORS_BH1780=y
CONFIG_SENSORS_BH1770=y
# CONFIG_SENSORS_APDS990X is not set
CONFIG_HMC6352=y
# CONFIG_DS1682 is not set
CONFIG_TI_DAC7512=y
# CONFIG_VMWARE_BALLOON is not set
# CONFIG_BMP085_I2C is not set
# CONFIG_BMP085_SPI is not set
# CONFIG_PCH_PHUB is not set
CONFIG_USB_SWITCH_FSA9480=y
CONFIG_LATTICE_ECP3_CONFIG=y
# CONFIG_SRAM is not set
CONFIG_C2PORT=y
CONFIG_C2PORT_DURAMAR_2150=y

#
# EEPROM support
#
# CONFIG_EEPROM_AT24 is not set
# CONFIG_EEPROM_AT25 is not set
# CONFIG_EEPROM_LEGACY is not set
CONFIG_EEPROM_MAX6875=y
# CONFIG_EEPROM_93CX6 is not set
# CONFIG_EEPROM_93XX46 is not set
# CONFIG_CB710_CORE is not set

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
# CONFIG_SCSI_PROC_FS is not set

#
# SCSI support type (disk, tape, CD-ROM)
#
# CONFIG_BLK_DEV_SD is not set
CONFIG_CHR_DEV_ST=y
CONFIG_CHR_DEV_OSST=y
CONFIG_BLK_DEV_SR=y
# CONFIG_BLK_DEV_SR_VENDOR is not set
CONFIG_CHR_DEV_SG=y
CONFIG_CHR_DEV_SCH=y
CONFIG_SCSI_ENCLOSURE=y
# CONFIG_SCSI_MULTI_LUN is not set
# CONFIG_SCSI_CONSTANTS is not set
# CONFIG_SCSI_LOGGING is not set
# CONFIG_SCSI_SCAN_ASYNC is not set

#
# SCSI Transports
#
# CONFIG_SCSI_SPI_ATTRS is not set
CONFIG_SCSI_FC_ATTRS=y
# CONFIG_SCSI_FC_TGT_ATTRS is not set
# CONFIG_SCSI_ISCSI_ATTRS is not set
CONFIG_SCSI_SAS_ATTRS=y
CONFIG_SCSI_SAS_LIBSAS=y
# CONFIG_SCSI_SAS_ATA is not set
CONFIG_SCSI_SAS_HOST_SMP=y
# CONFIG_SCSI_SRP_ATTRS is not set
CONFIG_SCSI_LOWLEVEL=y
CONFIG_ISCSI_BOOT_SYSFS=y
# CONFIG_SCSI_BNX2_ISCSI is not set
# CONFIG_SCSI_BNX2X_FCOE is not set
# CONFIG_BE2ISCSI is not set
# CONFIG_BLK_DEV_3W_XXXX_RAID is not set
# CONFIG_SCSI_HPSA is not set
# CONFIG_SCSI_3W_9XXX is not set
# CONFIG_SCSI_3W_SAS is not set
# CONFIG_SCSI_ACARD is not set
# CONFIG_SCSI_AACRAID is not set
# CONFIG_SCSI_AIC7XXX is not set
# CONFIG_SCSI_AIC7XXX_OLD is not set
# CONFIG_SCSI_AIC79XX is not set
# CONFIG_SCSI_AIC94XX is not set
# CONFIG_SCSI_MVSAS is not set
# CONFIG_SCSI_MVUMI is not set
# CONFIG_SCSI_DPT_I2O is not set
# CONFIG_SCSI_ADVANSYS is not set
# CONFIG_SCSI_ARCMSR is not set
# CONFIG_MEGARAID_NEWGEN is not set
# CONFIG_MEGARAID_LEGACY is not set
# CONFIG_MEGARAID_SAS is not set
# CONFIG_SCSI_MPT2SAS is not set
# CONFIG_SCSI_MPT3SAS is not set
CONFIG_SCSI_UFSHCD=y
# CONFIG_SCSI_UFSHCD_PCI is not set
CONFIG_SCSI_UFSHCD_PLATFORM=y
# CONFIG_SCSI_HPTIOP is not set
# CONFIG_SCSI_BUSLOGIC is not set
# CONFIG_VMWARE_PVSCSI is not set
CONFIG_LIBFC=y
CONFIG_LIBFCOE=y
# CONFIG_FCOE is not set
# CONFIG_FCOE_FNIC is not set
# CONFIG_SCSI_DMX3191D is not set
# CONFIG_SCSI_EATA is not set
# CONFIG_SCSI_FUTURE_DOMAIN is not set
# CONFIG_SCSI_GDTH is not set
# CONFIG_SCSI_ISCI is not set
# CONFIG_SCSI_IPS is not set
# CONFIG_SCSI_INITIO is not set
# CONFIG_SCSI_INIA100 is not set
# CONFIG_SCSI_STEX is not set
# CONFIG_SCSI_SYM53C8XX_2 is not set
# CONFIG_SCSI_IPR is not set
# CONFIG_SCSI_QLOGIC_1280 is not set
# CONFIG_SCSI_QLA_FC is not set
# CONFIG_SCSI_QLA_ISCSI is not set
# CONFIG_SCSI_LPFC is not set
# CONFIG_SCSI_DC395x is not set
# CONFIG_SCSI_DC390T is not set
CONFIG_SCSI_DEBUG=y
# CONFIG_SCSI_PMCRAID is not set
# CONFIG_SCSI_PM8001 is not set
# CONFIG_SCSI_SRP is not set
# CONFIG_SCSI_BFA_FC is not set
CONFIG_SCSI_VIRTIO=y
# CONFIG_SCSI_CHELSIO_FCOE is not set
CONFIG_SCSI_DH=y
# CONFIG_SCSI_DH_RDAC is not set
# CONFIG_SCSI_DH_HP_SW is not set
CONFIG_SCSI_DH_EMC=y
CONFIG_SCSI_DH_ALUA=y
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
# CONFIG_SATA_AHCI is not set
# CONFIG_SATA_AHCI_PLATFORM is not set
# CONFIG_SATA_INIC162X is not set
# CONFIG_SATA_ACARD_AHCI is not set
# CONFIG_SATA_SIL24 is not set
# CONFIG_ATA_SFF is not set
# CONFIG_MD is not set
# CONFIG_TARGET_CORE is not set
# CONFIG_FUSION is not set

#
# IEEE 1394 (FireWire) support
#
# CONFIG_FIREWIRE is not set
# CONFIG_FIREWIRE_NOSY is not set
# CONFIG_I2O is not set
# CONFIG_MACINTOSH_DRIVERS is not set
CONFIG_NETDEVICES=y
CONFIG_NET_CORE=y
CONFIG_DUMMY=y
CONFIG_EQUALIZER=y
# CONFIG_NET_FC is not set
# CONFIG_MII is not set
CONFIG_IFB=y
# CONFIG_NET_TEAM is not set
CONFIG_MACVLAN=y
CONFIG_MACVTAP=y
# CONFIG_NETCONSOLE is not set
# CONFIG_NETPOLL is not set
# CONFIG_NET_POLL_CONTROLLER is not set
CONFIG_TUN=y
CONFIG_VETH=y
CONFIG_VIRTIO_NET=y
# CONFIG_ARCNET is not set
# CONFIG_ATM_DRIVERS is not set

#
# CAIF transport drivers
#
CONFIG_VHOST_NET=y
CONFIG_VHOST_RING=y

#
# Distributed Switch Architecture drivers
#
CONFIG_NET_DSA_MV88E6XXX=y
CONFIG_NET_DSA_MV88E6060=y
CONFIG_NET_DSA_MV88E6XXX_NEED_PPU=y
CONFIG_NET_DSA_MV88E6131=y
CONFIG_NET_DSA_MV88E6123_61_65=y
# CONFIG_ETHERNET is not set
# CONFIG_FDDI is not set
# CONFIG_NET_SB1000 is not set
CONFIG_PHYLIB=y

#
# MII PHY device drivers
#
CONFIG_AT803X_PHY=y
CONFIG_AMD_PHY=y
CONFIG_MARVELL_PHY=y
CONFIG_DAVICOM_PHY=y
CONFIG_QSEMI_PHY=y
# CONFIG_LXT_PHY is not set
CONFIG_CICADA_PHY=y
# CONFIG_VITESSE_PHY is not set
# CONFIG_SMSC_PHY is not set
CONFIG_BROADCOM_PHY=y
# CONFIG_BCM87XX_PHY is not set
CONFIG_ICPLUS_PHY=y
CONFIG_REALTEK_PHY=y
# CONFIG_NATIONAL_PHY is not set
# CONFIG_STE10XP is not set
CONFIG_LSI_ET1011C_PHY=y
CONFIG_MICREL_PHY=y
# CONFIG_FIXED_PHY is not set
# CONFIG_MDIO_BITBANG is not set
# CONFIG_MICREL_KS8995MA is not set
CONFIG_PPP=y
CONFIG_PPP_BSDCOMP=y
CONFIG_PPP_DEFLATE=y
CONFIG_PPP_FILTER=y
# CONFIG_PPP_MPPE is not set
# CONFIG_PPP_MULTILINK is not set
CONFIG_PPPOATM=y
# CONFIG_PPPOE is not set
# CONFIG_PPP_ASYNC is not set
# CONFIG_PPP_SYNC_TTY is not set
# CONFIG_SLIP is not set
CONFIG_SLHC=y
CONFIG_WLAN=y
# CONFIG_AIRO is not set
# CONFIG_ATMEL is not set
# CONFIG_PRISM54 is not set
CONFIG_ATH_CARDS=y
# CONFIG_ATH_DEBUG is not set
# CONFIG_ATH5K_PCI is not set
CONFIG_ATH6KL=y
CONFIG_ATH6KL_SDIO=y
# CONFIG_ATH6KL_DEBUG is not set
# CONFIG_WIL6210 is not set
CONFIG_BRCMUTIL=y
CONFIG_BRCMFMAC=y
CONFIG_BRCMFMAC_SDIO=y
# CONFIG_BRCM_TRACING is not set
# CONFIG_BRCMDBG is not set
CONFIG_HOSTAP=y
# CONFIG_HOSTAP_FIRMWARE is not set
# CONFIG_HOSTAP_PLX is not set
# CONFIG_HOSTAP_PCI is not set
# CONFIG_IPW2100 is not set
# CONFIG_LIBERTAS is not set
# CONFIG_WL_TI is not set
CONFIG_MWIFIEX=y
CONFIG_MWIFIEX_SDIO=y
# CONFIG_MWIFIEX_PCIE is not set

#
# Enable WiMAX (Networking options) to see the WiMAX drivers
#
CONFIG_WAN=y
# CONFIG_LANMEDIA is not set
CONFIG_HDLC=y
CONFIG_HDLC_RAW=y
CONFIG_HDLC_RAW_ETH=y
# CONFIG_HDLC_CISCO is not set
# CONFIG_HDLC_FR is not set
# CONFIG_HDLC_PPP is not set
CONFIG_HDLC_X25=y
# CONFIG_PCI200SYN is not set
# CONFIG_WANXL is not set
# CONFIG_PC300TOO is not set
# CONFIG_FARSYNC is not set
CONFIG_DLCI=y
CONFIG_DLCI_MAX=8
# CONFIG_LAPBETHER is not set
# CONFIG_X25_ASY is not set
CONFIG_SBNI=y
# CONFIG_SBNI_MULTILINE is not set
CONFIG_ISDN=y
CONFIG_ISDN_I4L=y
CONFIG_ISDN_AUDIO=y
CONFIG_ISDN_TTY_FAX=y
CONFIG_ISDN_X25=y

#
# ISDN feature submodules
#
# CONFIG_ISDN_DRV_LOOP is not set
CONFIG_ISDN_DIVERSION=y

#
# ISDN4Linux hardware drivers
#

#
# Passive cards
#
# CONFIG_ISDN_DRV_HISAX is not set

#
# Active cards
#
# CONFIG_ISDN_CAPI is not set
# CONFIG_ISDN_DRV_GIGASET is not set
# CONFIG_MISDN is not set

#
# Input device support
#
CONFIG_INPUT=y
CONFIG_INPUT_FF_MEMLESS=y
CONFIG_INPUT_POLLDEV=y
# CONFIG_INPUT_SPARSEKMAP is not set
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
CONFIG_KEYBOARD_ADP5520=y
CONFIG_KEYBOARD_ADP5588=y
CONFIG_KEYBOARD_ADP5589=y
CONFIG_KEYBOARD_ATKBD=y
# CONFIG_KEYBOARD_QT1070 is not set
CONFIG_KEYBOARD_QT2160=y
# CONFIG_KEYBOARD_LKKBD is not set
# CONFIG_KEYBOARD_GPIO is not set
CONFIG_KEYBOARD_GPIO_POLLED=y
CONFIG_KEYBOARD_TCA6416=y
CONFIG_KEYBOARD_TCA8418=y
CONFIG_KEYBOARD_MATRIX=y
CONFIG_KEYBOARD_LM8323=y
CONFIG_KEYBOARD_LM8333=y
CONFIG_KEYBOARD_MAX7359=y
CONFIG_KEYBOARD_MCS=y
CONFIG_KEYBOARD_MPR121=y
# CONFIG_KEYBOARD_NEWTON is not set
# CONFIG_KEYBOARD_OPENCORES is not set
CONFIG_KEYBOARD_STOWAWAY=y
CONFIG_KEYBOARD_SUNKBD=y
CONFIG_KEYBOARD_TC3589X=y
CONFIG_KEYBOARD_TWL4030=y
CONFIG_KEYBOARD_XTKBD=y
CONFIG_INPUT_MOUSE=y
CONFIG_MOUSE_PS2=y
CONFIG_MOUSE_PS2_ALPS=y
CONFIG_MOUSE_PS2_LOGIPS2PP=y
CONFIG_MOUSE_PS2_SYNAPTICS=y
CONFIG_MOUSE_PS2_CYPRESS=y
CONFIG_MOUSE_PS2_LIFEBOOK=y
CONFIG_MOUSE_PS2_TRACKPOINT=y
# CONFIG_MOUSE_PS2_ELANTECH is not set
# CONFIG_MOUSE_PS2_SENTELIC is not set
# CONFIG_MOUSE_PS2_TOUCHKIT is not set
CONFIG_MOUSE_SERIAL=y
# CONFIG_MOUSE_APPLETOUCH is not set
# CONFIG_MOUSE_BCM5974 is not set
CONFIG_MOUSE_CYAPA=y
CONFIG_MOUSE_VSXXXAA=y
# CONFIG_MOUSE_GPIO is not set
# CONFIG_MOUSE_SYNAPTICS_I2C is not set
# CONFIG_MOUSE_SYNAPTICS_USB is not set
CONFIG_INPUT_JOYSTICK=y
CONFIG_JOYSTICK_ANALOG=y
CONFIG_JOYSTICK_A3D=y
# CONFIG_JOYSTICK_ADI is not set
# CONFIG_JOYSTICK_COBRA is not set
CONFIG_JOYSTICK_GF2K=y
CONFIG_JOYSTICK_GRIP=y
# CONFIG_JOYSTICK_GRIP_MP is not set
CONFIG_JOYSTICK_GUILLEMOT=y
CONFIG_JOYSTICK_INTERACT=y
# CONFIG_JOYSTICK_SIDEWINDER is not set
CONFIG_JOYSTICK_TMDC=y
CONFIG_JOYSTICK_IFORCE=y
# CONFIG_JOYSTICK_IFORCE_232 is not set
CONFIG_JOYSTICK_WARRIOR=y
CONFIG_JOYSTICK_MAGELLAN=y
CONFIG_JOYSTICK_SPACEORB=y
CONFIG_JOYSTICK_SPACEBALL=y
CONFIG_JOYSTICK_STINGER=y
CONFIG_JOYSTICK_TWIDJOY=y
CONFIG_JOYSTICK_ZHENHUA=y
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
CONFIG_TOUCHSCREEN_ADS7846=y
# CONFIG_TOUCHSCREEN_AD7877 is not set
# CONFIG_TOUCHSCREEN_AD7879 is not set
# CONFIG_TOUCHSCREEN_ATMEL_MXT is not set
# CONFIG_TOUCHSCREEN_AUO_PIXCIR is not set
CONFIG_TOUCHSCREEN_BU21013=y
CONFIG_TOUCHSCREEN_CY8CTMG110=y
# CONFIG_TOUCHSCREEN_CYTTSP_CORE is not set
# CONFIG_TOUCHSCREEN_DA9052 is not set
CONFIG_TOUCHSCREEN_DYNAPRO=y
# CONFIG_TOUCHSCREEN_HAMPSHIRE is not set
CONFIG_TOUCHSCREEN_EETI=y
# CONFIG_TOUCHSCREEN_FUJITSU is not set
CONFIG_TOUCHSCREEN_ILI210X=y
CONFIG_TOUCHSCREEN_GUNZE=y
CONFIG_TOUCHSCREEN_ELO=y
# CONFIG_TOUCHSCREEN_WACOM_W8001 is not set
CONFIG_TOUCHSCREEN_WACOM_I2C=y
CONFIG_TOUCHSCREEN_MAX11801=y
CONFIG_TOUCHSCREEN_MCS5000=y
CONFIG_TOUCHSCREEN_MMS114=y
# CONFIG_TOUCHSCREEN_MTOUCH is not set
CONFIG_TOUCHSCREEN_INEXIO=y
CONFIG_TOUCHSCREEN_MK712=y
CONFIG_TOUCHSCREEN_PENMOUNT=y
CONFIG_TOUCHSCREEN_EDT_FT5X06=y
CONFIG_TOUCHSCREEN_TOUCHRIGHT=y
# CONFIG_TOUCHSCREEN_TOUCHWIN is not set
# CONFIG_TOUCHSCREEN_TI_AM335X_TSC is not set
CONFIG_TOUCHSCREEN_PIXCIR=y
CONFIG_TOUCHSCREEN_WM831X=y
# CONFIG_TOUCHSCREEN_USB_COMPOSITE is not set
CONFIG_TOUCHSCREEN_MC13783=y
# CONFIG_TOUCHSCREEN_TOUCHIT213 is not set
# CONFIG_TOUCHSCREEN_TSC_SERIO is not set
CONFIG_TOUCHSCREEN_TSC2005=y
# CONFIG_TOUCHSCREEN_TSC2007 is not set
# CONFIG_TOUCHSCREEN_PCAP is not set
CONFIG_TOUCHSCREEN_ST1232=y
# CONFIG_TOUCHSCREEN_TPS6507X is not set
# CONFIG_INPUT_MISC is not set

#
# Hardware I/O ports
#
CONFIG_SERIO=y
CONFIG_SERIO_I8042=y
CONFIG_SERIO_SERPORT=y
CONFIG_SERIO_CT82C710=y
# CONFIG_SERIO_PCIPS2 is not set
CONFIG_SERIO_LIBPS2=y
# CONFIG_SERIO_RAW is not set
CONFIG_SERIO_ALTERA_PS2=y
CONFIG_SERIO_PS2MULT=y
CONFIG_SERIO_ARC_PS2=y
CONFIG_GAMEPORT=y
# CONFIG_GAMEPORT_NS558 is not set
CONFIG_GAMEPORT_L4=y
# CONFIG_GAMEPORT_EMU10K1 is not set
# CONFIG_GAMEPORT_FM801 is not set

#
# Character devices
#
CONFIG_TTY=y
CONFIG_VT=y
CONFIG_CONSOLE_TRANSLATIONS=y
CONFIG_VT_CONSOLE=y
CONFIG_HW_CONSOLE=y
CONFIG_VT_HW_CONSOLE_BINDING=y
CONFIG_UNIX98_PTYS=y
# CONFIG_DEVPTS_MULTIPLE_INSTANCES is not set
# CONFIG_LEGACY_PTYS is not set
# CONFIG_SERIAL_NONSTANDARD is not set
# CONFIG_NOZOMI is not set
CONFIG_N_GSM=y
# CONFIG_TRACE_ROUTER is not set
CONFIG_TRACE_SINK=y
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
CONFIG_SERIAL_MAX3100=y
CONFIG_SERIAL_MAX310X=y
# CONFIG_SERIAL_MFD_HSU is not set
CONFIG_SERIAL_CORE=y
CONFIG_SERIAL_CORE_CONSOLE=y
# CONFIG_SERIAL_JSM is not set
CONFIG_SERIAL_SCCNXP=y
CONFIG_SERIAL_SCCNXP_CONSOLE=y
# CONFIG_SERIAL_TIMBERDALE is not set
CONFIG_SERIAL_ALTERA_JTAGUART=y
# CONFIG_SERIAL_ALTERA_JTAGUART_CONSOLE is not set
# CONFIG_SERIAL_ALTERA_UART is not set
# CONFIG_SERIAL_IFX6X60 is not set
# CONFIG_SERIAL_PCH_UART is not set
CONFIG_SERIAL_ARC=y
# CONFIG_SERIAL_ARC_CONSOLE is not set
CONFIG_SERIAL_ARC_NR_PORTS=1
# CONFIG_SERIAL_RP2 is not set
CONFIG_HVC_DRIVER=y
CONFIG_VIRTIO_CONSOLE=y
CONFIG_IPMI_HANDLER=y
# CONFIG_IPMI_PANIC_EVENT is not set
CONFIG_IPMI_DEVICE_INTERFACE=y
CONFIG_IPMI_SI=y
CONFIG_IPMI_WATCHDOG=y
CONFIG_IPMI_POWEROFF=y
CONFIG_HW_RANDOM=y
# CONFIG_HW_RANDOM_TIMERIOMEM is not set
CONFIG_HW_RANDOM_INTEL=y
CONFIG_HW_RANDOM_AMD=y
# CONFIG_HW_RANDOM_VIA is not set
CONFIG_HW_RANDOM_VIRTIO=y
CONFIG_HW_RANDOM_TPM=y
# CONFIG_NVRAM is not set
CONFIG_R3964=y
# CONFIG_APPLICOM is not set
# CONFIG_MWAVE is not set
CONFIG_RAW_DRIVER=y
CONFIG_MAX_RAW_DEVS=256
# CONFIG_HPET is not set
CONFIG_HANGCHECK_TIMER=y
CONFIG_TCG_TPM=y
CONFIG_TCG_TIS=y
CONFIG_TCG_TIS_I2C_INFINEON=y
CONFIG_TCG_NSC=y
CONFIG_TCG_ATMEL=y
# CONFIG_TCG_INFINEON is not set
CONFIG_TCG_ST33_I2C=y
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
CONFIG_I2C_MUX_GPIO=y
# CONFIG_I2C_MUX_PCA9541 is not set
# CONFIG_I2C_MUX_PCA954x is not set
# CONFIG_I2C_HELPER_AUTO is not set
# CONFIG_I2C_SMBUS is not set

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
# CONFIG_I2C_INTEL_MID is not set
CONFIG_I2C_OCORES=y
CONFIG_I2C_PCA_PLATFORM=y
# CONFIG_I2C_PXA_PCI is not set
# CONFIG_I2C_SIMTEC is not set
# CONFIG_I2C_XILINX is not set

#
# External I2C/SMBus adapter drivers
#
# CONFIG_I2C_PARPORT_LIGHT is not set
CONFIG_I2C_TAOS_EVM=y

#
# Other I2C/SMBus bus drivers
#
# CONFIG_I2C_DEBUG_CORE is not set
# CONFIG_I2C_DEBUG_ALGO is not set
# CONFIG_I2C_DEBUG_BUS is not set
CONFIG_SPI=y
# CONFIG_SPI_DEBUG is not set
CONFIG_SPI_MASTER=y

#
# SPI Master Controller Drivers
#
CONFIG_SPI_ALTERA=y
CONFIG_SPI_BITBANG=y
CONFIG_SPI_GPIO=y
CONFIG_SPI_OC_TINY=y
# CONFIG_SPI_PXA2XX is not set
# CONFIG_SPI_PXA2XX_PCI is not set
CONFIG_SPI_SC18IS602=y
# CONFIG_SPI_TOPCLIFF_PCH is not set
CONFIG_SPI_XCOMM=y
# CONFIG_SPI_XILINX is not set
CONFIG_SPI_DESIGNWARE=y
# CONFIG_SPI_DW_PCI is not set

#
# SPI Protocol Masters
#
# CONFIG_SPI_SPIDEV is not set
CONFIG_SPI_TLE62X0=y

#
# Qualcomm MSM SSBI bus support
#
CONFIG_SSBI=y
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
CONFIG_GPIO_DEVRES=y
CONFIG_GPIOLIB=y
CONFIG_GPIO_ACPI=y
CONFIG_DEBUG_GPIO=y
CONFIG_GPIO_SYSFS=y
CONFIG_GPIO_GENERIC=y
CONFIG_GPIO_DA9052=y
CONFIG_GPIO_DA9055=y
CONFIG_GPIO_MAX730X=y

#
# Memory mapped GPIO drivers:
#
CONFIG_GPIO_GENERIC_PLATFORM=y
CONFIG_GPIO_IT8761E=y
CONFIG_GPIO_TS5500=y
# CONFIG_GPIO_SCH is not set
# CONFIG_GPIO_ICH is not set
# CONFIG_GPIO_VX855 is not set
# CONFIG_GPIO_LYNXPOINT is not set

#
# I2C GPIO expanders:
#
CONFIG_GPIO_ARIZONA=y
CONFIG_GPIO_MAX7300=y
# CONFIG_GPIO_MAX732X is not set
CONFIG_GPIO_PCA953X=y
# CONFIG_GPIO_PCA953X_IRQ is not set
CONFIG_GPIO_PCF857X=y
# CONFIG_GPIO_RC5T583 is not set
CONFIG_GPIO_SX150X=y
CONFIG_GPIO_TC3589X=y
CONFIG_GPIO_TPS65912=y
CONFIG_GPIO_TWL4030=y
# CONFIG_GPIO_TWL6040 is not set
CONFIG_GPIO_WM831X=y
# CONFIG_GPIO_WM8994 is not set
CONFIG_GPIO_ADP5520=y
CONFIG_GPIO_ADP5588=y
CONFIG_GPIO_ADP5588_IRQ=y

#
# PCI GPIO expanders:
#
# CONFIG_GPIO_BT8XX is not set
# CONFIG_GPIO_AMD8111 is not set
# CONFIG_GPIO_LANGWELL is not set
# CONFIG_GPIO_PCH is not set
# CONFIG_GPIO_ML_IOH is not set
# CONFIG_GPIO_RDC321X is not set

#
# SPI GPIO expanders:
#
# CONFIG_GPIO_MAX7301 is not set
CONFIG_GPIO_MCP23S08=y
# CONFIG_GPIO_MC33880 is not set
# CONFIG_GPIO_74X164 is not set

#
# AC97 GPIO expanders:
#

#
# MODULbus GPIO expanders:
#
CONFIG_GPIO_TPS6586X=y

#
# USB GPIO expanders:
#
CONFIG_W1=y
# CONFIG_W1_CON is not set

#
# 1-wire Bus Masters
#
# CONFIG_W1_MASTER_MATROX is not set
CONFIG_W1_MASTER_DS2482=y
# CONFIG_W1_MASTER_DS1WM is not set
# CONFIG_W1_MASTER_GPIO is not set

#
# 1-wire Slaves
#
CONFIG_W1_SLAVE_THERM=y
# CONFIG_W1_SLAVE_SMEM is not set
# CONFIG_W1_SLAVE_DS2408 is not set
CONFIG_W1_SLAVE_DS2413=y
CONFIG_W1_SLAVE_DS2423=y
CONFIG_W1_SLAVE_DS2431=y
CONFIG_W1_SLAVE_DS2433=y
# CONFIG_W1_SLAVE_DS2433_CRC is not set
CONFIG_W1_SLAVE_DS2760=y
CONFIG_W1_SLAVE_DS2780=y
CONFIG_W1_SLAVE_DS2781=y
CONFIG_W1_SLAVE_DS28E04=y
CONFIG_W1_SLAVE_BQ27000=y
CONFIG_POWER_SUPPLY=y
CONFIG_POWER_SUPPLY_DEBUG=y
CONFIG_PDA_POWER=y
CONFIG_GENERIC_ADC_BATTERY=y
CONFIG_WM831X_BACKUP=y
CONFIG_WM831X_POWER=y
# CONFIG_TEST_POWER is not set
CONFIG_BATTERY_DS2760=y
CONFIG_BATTERY_DS2780=y
CONFIG_BATTERY_DS2781=y
# CONFIG_BATTERY_DS2782 is not set
CONFIG_BATTERY_SBS=y
# CONFIG_BATTERY_BQ27x00 is not set
CONFIG_BATTERY_DA9052=y
CONFIG_BATTERY_MAX17040=y
# CONFIG_BATTERY_MAX17042 is not set
CONFIG_CHARGER_PCF50633=y
# CONFIG_CHARGER_MAX8903 is not set
CONFIG_CHARGER_TWL4030=y
CONFIG_CHARGER_LP8727=y
# CONFIG_CHARGER_GPIO is not set
# CONFIG_CHARGER_MANAGER is not set
CONFIG_CHARGER_BQ2415X=y
CONFIG_CHARGER_SMB347=y
# CONFIG_BATTERY_GOLDFISH is not set
# CONFIG_POWER_RESET is not set
CONFIG_POWER_AVS=y
CONFIG_HWMON=y
CONFIG_HWMON_VID=y
# CONFIG_HWMON_DEBUG_CHIP is not set

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
# CONFIG_SENSORS_ADM1025 is not set
# CONFIG_SENSORS_ADM1026 is not set
# CONFIG_SENSORS_ADM1029 is not set
# CONFIG_SENSORS_ADM1031 is not set
CONFIG_SENSORS_ADM9240=y
CONFIG_SENSORS_ADT7X10=y
CONFIG_SENSORS_ADT7310=y
# CONFIG_SENSORS_ADT7410 is not set
# CONFIG_SENSORS_ADT7411 is not set
CONFIG_SENSORS_ADT7462=y
# CONFIG_SENSORS_ADT7470 is not set
CONFIG_SENSORS_ADT7475=y
# CONFIG_SENSORS_ASC7621 is not set
# CONFIG_SENSORS_K8TEMP is not set
# CONFIG_SENSORS_K10TEMP is not set
# CONFIG_SENSORS_FAM15H_POWER is not set
CONFIG_SENSORS_ASB100=y
CONFIG_SENSORS_ATXP1=y
# CONFIG_SENSORS_DS620 is not set
CONFIG_SENSORS_DS1621=y
CONFIG_SENSORS_DA9052_ADC=y
# CONFIG_SENSORS_DA9055 is not set
# CONFIG_SENSORS_I5K_AMB is not set
CONFIG_SENSORS_F71805F=y
CONFIG_SENSORS_F71882FG=y
CONFIG_SENSORS_F75375S=y
# CONFIG_SENSORS_FSCHMD is not set
CONFIG_SENSORS_G760A=y
# CONFIG_SENSORS_GL518SM is not set
CONFIG_SENSORS_GL520SM=y
CONFIG_SENSORS_GPIO_FAN=y
# CONFIG_SENSORS_HIH6130 is not set
# CONFIG_SENSORS_CORETEMP is not set
CONFIG_SENSORS_IBMAEM=y
CONFIG_SENSORS_IBMPEX=y
CONFIG_SENSORS_IIO_HWMON=y
CONFIG_SENSORS_IT87=y
CONFIG_SENSORS_JC42=y
# CONFIG_SENSORS_LINEAGE is not set
CONFIG_SENSORS_LM63=y
# CONFIG_SENSORS_LM70 is not set
CONFIG_SENSORS_LM73=y
CONFIG_SENSORS_LM75=y
CONFIG_SENSORS_LM77=y
# CONFIG_SENSORS_LM78 is not set
CONFIG_SENSORS_LM80=y
# CONFIG_SENSORS_LM83 is not set
# CONFIG_SENSORS_LM85 is not set
CONFIG_SENSORS_LM87=y
CONFIG_SENSORS_LM90=y
CONFIG_SENSORS_LM92=y
# CONFIG_SENSORS_LM93 is not set
CONFIG_SENSORS_LTC4151=y
CONFIG_SENSORS_LTC4215=y
CONFIG_SENSORS_LTC4245=y
# CONFIG_SENSORS_LTC4261 is not set
CONFIG_SENSORS_LM95234=y
CONFIG_SENSORS_LM95241=y
CONFIG_SENSORS_LM95245=y
CONFIG_SENSORS_MAX1111=y
# CONFIG_SENSORS_MAX16065 is not set
CONFIG_SENSORS_MAX1619=y
CONFIG_SENSORS_MAX1668=y
CONFIG_SENSORS_MAX197=y
# CONFIG_SENSORS_MAX6639 is not set
# CONFIG_SENSORS_MAX6642 is not set
CONFIG_SENSORS_MAX6650=y
CONFIG_SENSORS_MAX6697=y
CONFIG_SENSORS_MCP3021=y
# CONFIG_SENSORS_NCT6775 is not set
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
# CONFIG_SENSORS_SHT21 is not set
# CONFIG_SENSORS_SIS5595 is not set
CONFIG_SENSORS_SMM665=y
# CONFIG_SENSORS_DME1737 is not set
# CONFIG_SENSORS_EMC1403 is not set
CONFIG_SENSORS_EMC2103=y
CONFIG_SENSORS_EMC6W201=y
# CONFIG_SENSORS_SMSC47M1 is not set
CONFIG_SENSORS_SMSC47M192=y
# CONFIG_SENSORS_SMSC47B397 is not set
# CONFIG_SENSORS_SCH56XX_COMMON is not set
CONFIG_SENSORS_ADS1015=y
# CONFIG_SENSORS_ADS7828 is not set
CONFIG_SENSORS_ADS7871=y
CONFIG_SENSORS_AMC6821=y
# CONFIG_SENSORS_INA209 is not set
CONFIG_SENSORS_INA2XX=y
CONFIG_SENSORS_THMC50=y
# CONFIG_SENSORS_TMP102 is not set
CONFIG_SENSORS_TMP401=y
# CONFIG_SENSORS_TMP421 is not set
# CONFIG_SENSORS_VIA_CPUTEMP is not set
# CONFIG_SENSORS_VIA686A is not set
CONFIG_SENSORS_VT1211=y
# CONFIG_SENSORS_VT8231 is not set
CONFIG_SENSORS_W83781D=y
CONFIG_SENSORS_W83791D=y
CONFIG_SENSORS_W83792D=y
# CONFIG_SENSORS_W83793 is not set
# CONFIG_SENSORS_W83795 is not set
CONFIG_SENSORS_W83L785TS=y
CONFIG_SENSORS_W83L786NG=y
# CONFIG_SENSORS_W83627HF is not set
CONFIG_SENSORS_W83627EHF=y
CONFIG_SENSORS_WM831X=y
CONFIG_SENSORS_APPLESMC=y
# CONFIG_SENSORS_MC13783_ADC is not set

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
CONFIG_THERMAL_EMULATION=y
CONFIG_INTEL_POWERCLAMP=y
# CONFIG_WATCHDOG is not set
CONFIG_SSB_POSSIBLE=y

#
# Sonics Silicon Backplane
#
CONFIG_SSB=y
CONFIG_SSB_SPROM=y
CONFIG_SSB_PCIHOST_POSSIBLE=y
CONFIG_SSB_PCIHOST=y
# CONFIG_SSB_B43_PCI_BRIDGE is not set
CONFIG_SSB_SDIOHOST_POSSIBLE=y
CONFIG_SSB_SDIOHOST=y
# CONFIG_SSB_DEBUG is not set
CONFIG_SSB_DRIVER_PCICORE_POSSIBLE=y
# CONFIG_SSB_DRIVER_PCICORE is not set
# CONFIG_SSB_DRIVER_GPIO is not set
CONFIG_BCMA_POSSIBLE=y

#
# Broadcom specific AMBA
#
CONFIG_BCMA=y
CONFIG_BCMA_HOST_PCI_POSSIBLE=y
# CONFIG_BCMA_HOST_PCI is not set
CONFIG_BCMA_DRIVER_GMAC_CMN=y
# CONFIG_BCMA_DRIVER_GPIO is not set
# CONFIG_BCMA_DEBUG is not set

#
# Multifunction device drivers
#
CONFIG_MFD_CORE=y
# CONFIG_MFD_CS5535 is not set
# CONFIG_MFD_AS3711 is not set
CONFIG_PMIC_ADP5520=y
# CONFIG_MFD_AAT2870_CORE is not set
# CONFIG_MFD_CROS_EC is not set
# CONFIG_PMIC_DA903X is not set
CONFIG_PMIC_DA9052=y
# CONFIG_MFD_DA9052_SPI is not set
CONFIG_MFD_DA9052_I2C=y
CONFIG_MFD_DA9055=y
CONFIG_MFD_MC13783=y
CONFIG_MFD_MC13XXX=y
# CONFIG_MFD_MC13XXX_SPI is not set
CONFIG_MFD_MC13XXX_I2C=y
CONFIG_HTC_PASIC3=y
# CONFIG_HTC_I2CPLD is not set
# CONFIG_LPC_ICH is not set
# CONFIG_LPC_SCH is not set
# CONFIG_MFD_JANZ_CMODIO is not set
# CONFIG_MFD_88PM800 is not set
CONFIG_MFD_88PM805=y
# CONFIG_MFD_88PM860X is not set
# CONFIG_MFD_MAX77686 is not set
# CONFIG_MFD_MAX77693 is not set
CONFIG_MFD_MAX8907=y
# CONFIG_MFD_MAX8925 is not set
# CONFIG_MFD_MAX8997 is not set
# CONFIG_MFD_MAX8998 is not set
CONFIG_EZX_PCAP=y
CONFIG_MFD_RETU=y
CONFIG_MFD_PCF50633=y
CONFIG_PCF50633_ADC=y
# CONFIG_PCF50633_GPIO is not set
# CONFIG_MFD_RDC321X is not set
# CONFIG_MFD_RTSX_PCI is not set
CONFIG_MFD_RC5T583=y
# CONFIG_MFD_SEC_CORE is not set
CONFIG_MFD_SI476X_CORE=y
CONFIG_MFD_SM501=y
CONFIG_MFD_SM501_GPIO=y
# CONFIG_MFD_SMSC is not set
CONFIG_ABX500_CORE=y
# CONFIG_AB3100_CORE is not set
# CONFIG_MFD_STMPE is not set
CONFIG_MFD_SYSCON=y
CONFIG_MFD_TI_AM335X_TSCADC=y
# CONFIG_MFD_LP8788 is not set
# CONFIG_MFD_PALMAS is not set
CONFIG_TPS6105X=y
CONFIG_TPS65010=y
# CONFIG_TPS6507X is not set
# CONFIG_MFD_TPS65090 is not set
# CONFIG_MFD_TPS65217 is not set
CONFIG_MFD_TPS6586X=y
# CONFIG_MFD_TPS65910 is not set
CONFIG_MFD_TPS65912=y
CONFIG_MFD_TPS65912_I2C=y
# CONFIG_MFD_TPS65912_SPI is not set
# CONFIG_MFD_TPS80031 is not set
CONFIG_TWL4030_CORE=y
# CONFIG_TWL4030_MADC is not set
CONFIG_MFD_TWL4030_AUDIO=y
CONFIG_TWL6040_CORE=y
CONFIG_MFD_WL1273_CORE=y
CONFIG_MFD_LM3533=y
# CONFIG_MFD_TIMBERDALE is not set
CONFIG_MFD_TC3589X=y
# CONFIG_MFD_TMIO is not set
# CONFIG_MFD_VX855 is not set
CONFIG_MFD_ARIZONA=y
# CONFIG_MFD_ARIZONA_I2C is not set
CONFIG_MFD_ARIZONA_SPI=y
CONFIG_MFD_WM5102=y
# CONFIG_MFD_WM5110 is not set
CONFIG_MFD_WM8400=y
CONFIG_MFD_WM831X=y
CONFIG_MFD_WM831X_I2C=y
CONFIG_MFD_WM831X_SPI=y
# CONFIG_MFD_WM8350_I2C is not set
CONFIG_MFD_WM8994=y
CONFIG_REGULATOR=y
CONFIG_REGULATOR_DEBUG=y
CONFIG_REGULATOR_DUMMY=y
CONFIG_REGULATOR_FIXED_VOLTAGE=y
CONFIG_REGULATOR_VIRTUAL_CONSUMER=y
CONFIG_REGULATOR_USERSPACE_CONSUMER=y
CONFIG_REGULATOR_GPIO=y
CONFIG_REGULATOR_AD5398=y
CONFIG_REGULATOR_DA9052=y
# CONFIG_REGULATOR_DA9055 is not set
CONFIG_REGULATOR_FAN53555=y
CONFIG_REGULATOR_ANATOP=y
CONFIG_REGULATOR_MC13XXX_CORE=y
# CONFIG_REGULATOR_MC13783 is not set
CONFIG_REGULATOR_MC13892=y
# CONFIG_REGULATOR_ISL6271A is not set
CONFIG_REGULATOR_MAX1586=y
CONFIG_REGULATOR_MAX8649=y
CONFIG_REGULATOR_MAX8660=y
CONFIG_REGULATOR_MAX8907=y
CONFIG_REGULATOR_MAX8952=y
CONFIG_REGULATOR_MAX8973=y
CONFIG_REGULATOR_PCAP=y
CONFIG_REGULATOR_LP3971=y
CONFIG_REGULATOR_LP3972=y
# CONFIG_REGULATOR_LP872X is not set
CONFIG_REGULATOR_LP8755=y
CONFIG_REGULATOR_PCF50633=y
# CONFIG_REGULATOR_RC5T583 is not set
CONFIG_REGULATOR_TPS51632=y
CONFIG_REGULATOR_TPS6105X=y
# CONFIG_REGULATOR_TPS62360 is not set
# CONFIG_REGULATOR_TPS65023 is not set
CONFIG_REGULATOR_TPS6507X=y
# CONFIG_REGULATOR_TPS6524X is not set
CONFIG_REGULATOR_TPS6586X=y
# CONFIG_REGULATOR_TPS65912 is not set
# CONFIG_REGULATOR_TWL4030 is not set
CONFIG_REGULATOR_WM831X=y
# CONFIG_REGULATOR_WM8400 is not set
CONFIG_REGULATOR_WM8994=y
CONFIG_MEDIA_SUPPORT=y

#
# Multimedia core support
#
CONFIG_MEDIA_CAMERA_SUPPORT=y
CONFIG_MEDIA_ANALOG_TV_SUPPORT=y
# CONFIG_MEDIA_DIGITAL_TV_SUPPORT is not set
CONFIG_MEDIA_RADIO_SUPPORT=y
CONFIG_MEDIA_RC_SUPPORT=y
# CONFIG_MEDIA_CONTROLLER is not set
CONFIG_VIDEO_DEV=y
CONFIG_VIDEO_V4L2=y
CONFIG_VIDEO_ADV_DEBUG=y
CONFIG_VIDEO_FIXED_MINOR_RANGES=y
# CONFIG_VIDEO_V4L2_INT_DEVICE is not set
# CONFIG_TTPCI_EEPROM is not set

#
# Media drivers
#
CONFIG_RC_CORE=y
CONFIG_RC_MAP=y
CONFIG_RC_DECODERS=y
CONFIG_LIRC=y
# CONFIG_IR_LIRC_CODEC is not set
CONFIG_IR_NEC_DECODER=y
CONFIG_IR_RC5_DECODER=y
CONFIG_IR_RC6_DECODER=y
CONFIG_IR_JVC_DECODER=y
CONFIG_IR_SONY_DECODER=y
CONFIG_IR_RC5_SZ_DECODER=y
# CONFIG_IR_SANYO_DECODER is not set
CONFIG_IR_MCE_KBD_DECODER=y
# CONFIG_RC_DEVICES is not set
# CONFIG_MEDIA_PCI_SUPPORT is not set
# CONFIG_V4L_PLATFORM_DRIVERS is not set
# CONFIG_V4L_MEM2MEM_DRIVERS is not set
CONFIG_V4L_TEST_DRIVERS=y
# CONFIG_VIDEO_MEM2MEM_TESTDEV is not set

#
# Supported MMC/SDIO adapters
#
CONFIG_RADIO_ADAPTERS=y
# CONFIG_RADIO_SI470X is not set
# CONFIG_RADIO_MAXIRADIO is not set
CONFIG_I2C_SI4713=y
CONFIG_RADIO_SI4713=y
# CONFIG_RADIO_TEA5764 is not set
# CONFIG_RADIO_SAA7706H is not set
CONFIG_RADIO_TEF6862=y
CONFIG_RADIO_WL1273=y

#
# Texas Instruments WL128x FM driver (ST based)
#
CONFIG_RADIO_WL128X=y

#
# Media ancillary drivers (tuners, sensors, i2c, frontends)
#
# CONFIG_MEDIA_SUBDRV_AUTOSELECT is not set
CONFIG_VIDEO_IR_I2C=y

#
# Encoders, decoders, sensors and other helper chips
#

#
# Audio decoders, processors and mixers
#
# CONFIG_VIDEO_TVAUDIO is not set
# CONFIG_VIDEO_TDA7432 is not set
# CONFIG_VIDEO_TDA9840 is not set
CONFIG_VIDEO_TEA6415C=y
CONFIG_VIDEO_TEA6420=y
CONFIG_VIDEO_MSP3400=y
CONFIG_VIDEO_CS5345=y
# CONFIG_VIDEO_CS53L32A is not set
CONFIG_VIDEO_TLV320AIC23B=y
# CONFIG_VIDEO_UDA1342 is not set
CONFIG_VIDEO_WM8775=y
CONFIG_VIDEO_WM8739=y
CONFIG_VIDEO_VP27SMPX=y
CONFIG_VIDEO_SONY_BTF_MPX=y

#
# RDS decoders
#
# CONFIG_VIDEO_SAA6588 is not set

#
# Video decoders
#
CONFIG_VIDEO_ADV7180=y
# CONFIG_VIDEO_ADV7183 is not set
CONFIG_VIDEO_BT819=y
CONFIG_VIDEO_BT856=y
CONFIG_VIDEO_BT866=y
# CONFIG_VIDEO_KS0127 is not set
# CONFIG_VIDEO_ML86V7667 is not set
CONFIG_VIDEO_SAA7110=y
CONFIG_VIDEO_SAA711X=y
CONFIG_VIDEO_SAA7191=y
# CONFIG_VIDEO_TVP514X is not set
CONFIG_VIDEO_TVP5150=y
CONFIG_VIDEO_TVP7002=y
# CONFIG_VIDEO_TW2804 is not set
CONFIG_VIDEO_TW9903=y
# CONFIG_VIDEO_TW9906 is not set
CONFIG_VIDEO_VPX3220=y

#
# Video and audio decoders
#
CONFIG_VIDEO_SAA717X=y
CONFIG_VIDEO_CX25840=y

#
# Video encoders
#
# CONFIG_VIDEO_SAA7127 is not set
CONFIG_VIDEO_SAA7185=y
CONFIG_VIDEO_ADV7170=y
# CONFIG_VIDEO_ADV7175 is not set
CONFIG_VIDEO_ADV7343=y
CONFIG_VIDEO_ADV7393=y
CONFIG_VIDEO_AK881X=y
# CONFIG_VIDEO_THS8200 is not set

#
# Camera sensor devices
#
CONFIG_VIDEO_OV7640=y
# CONFIG_VIDEO_OV7670 is not set
CONFIG_VIDEO_VS6624=y
# CONFIG_VIDEO_MT9V011 is not set
CONFIG_VIDEO_SR030PC30=y

#
# Flash devices
#

#
# Video improvement chips
#
# CONFIG_VIDEO_UPD64031A is not set
CONFIG_VIDEO_UPD64083=y

#
# Miscelaneous helper chips
#
CONFIG_VIDEO_THS7303=y
# CONFIG_VIDEO_M52790 is not set

#
# Sensors used on soc_camera driver
#
CONFIG_MEDIA_TUNER=y

#
# Customize TV tuners
#
CONFIG_MEDIA_TUNER_SIMPLE=y
# CONFIG_MEDIA_TUNER_TDA8290 is not set
CONFIG_MEDIA_TUNER_TDA827X=y
# CONFIG_MEDIA_TUNER_TDA18271 is not set
CONFIG_MEDIA_TUNER_TDA9887=y
CONFIG_MEDIA_TUNER_TEA5761=y
CONFIG_MEDIA_TUNER_TEA5767=y
CONFIG_MEDIA_TUNER_MT20XX=y
CONFIG_MEDIA_TUNER_MT2060=y
CONFIG_MEDIA_TUNER_MT2063=y
CONFIG_MEDIA_TUNER_MT2266=y
# CONFIG_MEDIA_TUNER_MT2131 is not set
CONFIG_MEDIA_TUNER_QT1010=y
# CONFIG_MEDIA_TUNER_XC2028 is not set
# CONFIG_MEDIA_TUNER_XC5000 is not set
# CONFIG_MEDIA_TUNER_XC4000 is not set
# CONFIG_MEDIA_TUNER_MXL5005S is not set
CONFIG_MEDIA_TUNER_MXL5007T=y
CONFIG_MEDIA_TUNER_MC44S803=y
CONFIG_MEDIA_TUNER_MAX2165=y
# CONFIG_MEDIA_TUNER_TDA18218 is not set
CONFIG_MEDIA_TUNER_FC0011=y
# CONFIG_MEDIA_TUNER_FC0012 is not set
# CONFIG_MEDIA_TUNER_FC0013 is not set
# CONFIG_MEDIA_TUNER_TDA18212 is not set
CONFIG_MEDIA_TUNER_E4000=y
# CONFIG_MEDIA_TUNER_FC2580 is not set
CONFIG_MEDIA_TUNER_TUA9001=y
# CONFIG_MEDIA_TUNER_IT913X is not set
CONFIG_MEDIA_TUNER_R820T=y

#
# Customise DVB Frontends
#
CONFIG_DVB_AU8522=y
CONFIG_DVB_AU8522_V4L=y
CONFIG_DVB_TUNER_DIB0070=y
CONFIG_DVB_TUNER_DIB0090=y

#
# Tools to develop new frontends
#
CONFIG_DVB_DUMMY_FE=y

#
# Graphics support
#
# CONFIG_AGP is not set
CONFIG_VGA_ARB=y
CONFIG_VGA_ARB_MAX_GPUS=16
# CONFIG_VGA_SWITCHEROO is not set
# CONFIG_DRM is not set
# CONFIG_VGASTATE is not set
# CONFIG_VIDEO_OUTPUT_CONTROL is not set
# CONFIG_FB is not set
# CONFIG_EXYNOS_VIDEO is not set
# CONFIG_BACKLIGHT_LCD_SUPPORT is not set

#
# Console display driver support
#
CONFIG_VGA_CONSOLE=y
CONFIG_VGACON_SOFT_SCROLLBACK=y
CONFIG_VGACON_SOFT_SCROLLBACK_SIZE=64
CONFIG_DUMMY_CONSOLE=y
CONFIG_SOUND=y
CONFIG_SOUND_OSS_CORE=y
CONFIG_SOUND_OSS_CORE_PRECLAIM=y
CONFIG_SND=y
CONFIG_SND_TIMER=y
CONFIG_SND_PCM=y
CONFIG_SND_RAWMIDI=y
# CONFIG_SND_SEQUENCER is not set
# CONFIG_SND_MIXER_OSS is not set
# CONFIG_SND_PCM_OSS is not set
# CONFIG_SND_HRTIMER is not set
CONFIG_SND_DYNAMIC_MINORS=y
CONFIG_SND_SUPPORT_OLD_API=y
CONFIG_SND_VERBOSE_PROCFS=y
# CONFIG_SND_VERBOSE_PRINTK is not set
# CONFIG_SND_DEBUG is not set
CONFIG_SND_DMA_SGBUF=y
# CONFIG_SND_RAWMIDI_SEQ is not set
# CONFIG_SND_OPL3_LIB_SEQ is not set
# CONFIG_SND_OPL4_LIB_SEQ is not set
# CONFIG_SND_SBAWE_SEQ is not set
# CONFIG_SND_EMU10K1_SEQ is not set
CONFIG_SND_DRIVERS=y
CONFIG_SND_PCSP=y
# CONFIG_SND_DUMMY is not set
CONFIG_SND_ALOOP=y
CONFIG_SND_MTPAV=y
CONFIG_SND_SERIAL_U16550=y
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
CONFIG_SND_SPI=y
# CONFIG_SND_SOC is not set
CONFIG_SOUND_PRIME=y
CONFIG_SOUND_OSS=y
CONFIG_SOUND_TRACEINIT=y
# CONFIG_SOUND_DMAP is not set
CONFIG_SOUND_VMIDI=y
# CONFIG_SOUND_TRIX is not set
CONFIG_SOUND_MSS=y
CONFIG_SOUND_MPU401=y
CONFIG_SOUND_PAS=y
# CONFIG_PAS_JOYSTICK is not set
CONFIG_SOUND_PSS=y
# CONFIG_PSS_MIXER is not set
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
# CONFIG_HID_BATTERY_STRENGTH is not set
# CONFIG_HIDRAW is not set
# CONFIG_UHID is not set
# CONFIG_HID_GENERIC is not set

#
# Special HID drivers
#
CONFIG_HID_A4TECH=y
CONFIG_HID_ACRUX=y
CONFIG_HID_ACRUX_FF=y
CONFIG_HID_APPLE=y
# CONFIG_HID_AUREAL is not set
CONFIG_HID_BELKIN=y
CONFIG_HID_CHERRY=y
CONFIG_HID_CHICONY=y
# CONFIG_HID_PRODIKEYS is not set
CONFIG_HID_CYPRESS=y
# CONFIG_HID_DRAGONRISE is not set
CONFIG_HID_EMS_FF=y
CONFIG_HID_ELECOM=y
CONFIG_HID_EZKEY=y
CONFIG_HID_KEYTOUCH=y
CONFIG_HID_KYE=y
CONFIG_HID_UCLOGIC=y
# CONFIG_HID_WALTOP is not set
# CONFIG_HID_GYRATION is not set
# CONFIG_HID_ICADE is not set
CONFIG_HID_TWINHAN=y
CONFIG_HID_KENSINGTON=y
CONFIG_HID_LCPOWER=y
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
# CONFIG_HID_PANTHERLORD is not set
CONFIG_HID_PETALYNX=y
CONFIG_HID_PICOLCD=y
CONFIG_HID_PICOLCD_LEDS=y
CONFIG_HID_PICOLCD_CIR=y
CONFIG_HID_PRIMAX=y
CONFIG_HID_PS3REMOTE=y
CONFIG_HID_SAITEK=y
CONFIG_HID_SAMSUNG=y
# CONFIG_HID_SPEEDLINK is not set
CONFIG_HID_STEELSERIES=y
CONFIG_HID_SUNPLUS=y
CONFIG_HID_GREENASIA=y
# CONFIG_GREENASIA_FF is not set
# CONFIG_HID_SMARTJOYPLUS is not set
CONFIG_HID_TIVO=y
# CONFIG_HID_TOPSEED is not set
CONFIG_HID_THINGM=y
CONFIG_HID_THRUSTMASTER=y
# CONFIG_THRUSTMASTER_FF is not set
CONFIG_HID_WACOM=y
CONFIG_HID_WIIMOTE=y
# CONFIG_HID_WIIMOTE_EXT is not set
CONFIG_HID_ZEROPLUS=y
CONFIG_ZEROPLUS_FF=y
CONFIG_HID_ZYDACRON=y
CONFIG_HID_SENSOR_HUB=y

#
# I2C HID support
#
CONFIG_I2C_HID=y
CONFIG_USB_ARCH_HAS_OHCI=y
CONFIG_USB_ARCH_HAS_EHCI=y
CONFIG_USB_ARCH_HAS_XHCI=y
CONFIG_USB_SUPPORT=y
CONFIG_USB_ARCH_HAS_HCD=y
# CONFIG_USB is not set

#
# USB port drivers
#
# CONFIG_USB_PHY is not set
# CONFIG_USB_GADGET is not set
# CONFIG_UWB is not set
CONFIG_MMC=y
CONFIG_MMC_DEBUG=y
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
# CONFIG_MMC_WBSD is not set
# CONFIG_MMC_TIFM_SD is not set
CONFIG_MMC_SPI=y
# CONFIG_MMC_CB710 is not set
# CONFIG_MMC_VIA_SDMMC is not set
CONFIG_MEMSTICK=y
# CONFIG_MEMSTICK_DEBUG is not set

#
# MemoryStick drivers
#
# CONFIG_MEMSTICK_UNSAFE_RESUME is not set
CONFIG_MSPRO_BLOCK=y

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
# CONFIG_LEDS_LM3530 is not set
CONFIG_LEDS_LM3533=y
CONFIG_LEDS_LM3642=y
# CONFIG_LEDS_PCA9532 is not set
CONFIG_LEDS_GPIO=y
CONFIG_LEDS_LP3944=y
CONFIG_LEDS_LP55XX_COMMON=y
CONFIG_LEDS_LP5521=y
# CONFIG_LEDS_LP5523 is not set
# CONFIG_LEDS_LP5562 is not set
CONFIG_LEDS_CLEVO_MAIL=y
# CONFIG_LEDS_PCA955X is not set
CONFIG_LEDS_PCA9633=y
CONFIG_LEDS_WM831X_STATUS=y
CONFIG_LEDS_DA9052=y
CONFIG_LEDS_DAC124S085=y
CONFIG_LEDS_PWM=y
# CONFIG_LEDS_REGULATOR is not set
CONFIG_LEDS_BD2802=y
# CONFIG_LEDS_INTEL_SS4200 is not set
# CONFIG_LEDS_LT3593 is not set
CONFIG_LEDS_ADP5520=y
CONFIG_LEDS_MC13783=y
CONFIG_LEDS_TCA6507=y
# CONFIG_LEDS_LM355x is not set
# CONFIG_LEDS_OT200 is not set
# CONFIG_LEDS_BLINKM is not set

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
CONFIG_LEDS_TRIGGER_DEFAULT_ON=y

#
# iptables trigger is under Netfilter config (LED target)
#
# CONFIG_LEDS_TRIGGER_TRANSIENT is not set
CONFIG_LEDS_TRIGGER_CAMERA=y
CONFIG_ACCESSIBILITY=y
# CONFIG_A11Y_BRAILLE_CONSOLE is not set
# CONFIG_INFINIBAND is not set
CONFIG_EDAC=y
# CONFIG_EDAC_LEGACY_SYSFS is not set
# CONFIG_EDAC_DEBUG is not set
# CONFIG_EDAC_MM_EDAC is not set
CONFIG_RTC_LIB=y
CONFIG_RTC_CLASS=y
# CONFIG_RTC_HCTOSYS is not set
# CONFIG_RTC_SYSTOHC is not set
CONFIG_RTC_DEBUG=y

#
# RTC interfaces
#
# CONFIG_RTC_INTF_SYSFS is not set
# CONFIG_RTC_INTF_PROC is not set
CONFIG_RTC_INTF_DEV=y
CONFIG_RTC_INTF_DEV_UIE_EMUL=y
CONFIG_RTC_DRV_TEST=y

#
# I2C RTC drivers
#
CONFIG_RTC_DRV_DS1307=y
# CONFIG_RTC_DRV_DS1374 is not set
CONFIG_RTC_DRV_DS1672=y
CONFIG_RTC_DRV_DS3232=y
# CONFIG_RTC_DRV_MAX6900 is not set
CONFIG_RTC_DRV_MAX8907=y
CONFIG_RTC_DRV_RS5C372=y
CONFIG_RTC_DRV_ISL1208=y
# CONFIG_RTC_DRV_ISL12022 is not set
CONFIG_RTC_DRV_X1205=y
CONFIG_RTC_DRV_PCF8523=y
CONFIG_RTC_DRV_PCF8563=y
CONFIG_RTC_DRV_PCF8583=y
CONFIG_RTC_DRV_M41T80=y
# CONFIG_RTC_DRV_M41T80_WDT is not set
CONFIG_RTC_DRV_BQ32K=y
# CONFIG_RTC_DRV_TWL4030 is not set
CONFIG_RTC_DRV_TPS6586X=y
CONFIG_RTC_DRV_RC5T583=y
# CONFIG_RTC_DRV_S35390A is not set
# CONFIG_RTC_DRV_FM3130 is not set
CONFIG_RTC_DRV_RX8581=y
CONFIG_RTC_DRV_RX8025=y
# CONFIG_RTC_DRV_EM3027 is not set
CONFIG_RTC_DRV_RV3029C2=y

#
# SPI RTC drivers
#
CONFIG_RTC_DRV_M41T93=y
CONFIG_RTC_DRV_M41T94=y
CONFIG_RTC_DRV_DS1305=y
CONFIG_RTC_DRV_DS1390=y
CONFIG_RTC_DRV_MAX6902=y
CONFIG_RTC_DRV_R9701=y
CONFIG_RTC_DRV_RS5C348=y
CONFIG_RTC_DRV_DS3234=y
# CONFIG_RTC_DRV_PCF2123 is not set
# CONFIG_RTC_DRV_RX4581 is not set

#
# Platform RTC drivers
#
CONFIG_RTC_DRV_CMOS=y
CONFIG_RTC_DRV_DS1286=y
CONFIG_RTC_DRV_DS1511=y
CONFIG_RTC_DRV_DS1553=y
# CONFIG_RTC_DRV_DS1742 is not set
CONFIG_RTC_DRV_DA9052=y
CONFIG_RTC_DRV_DA9055=y
CONFIG_RTC_DRV_STK17TA8=y
CONFIG_RTC_DRV_M48T86=y
# CONFIG_RTC_DRV_M48T35 is not set
CONFIG_RTC_DRV_M48T59=y
CONFIG_RTC_DRV_MSM6242=y
# CONFIG_RTC_DRV_BQ4802 is not set
CONFIG_RTC_DRV_RP5C01=y
# CONFIG_RTC_DRV_V3020 is not set
CONFIG_RTC_DRV_DS2404=y
# CONFIG_RTC_DRV_WM831X is not set
# CONFIG_RTC_DRV_PCF50633 is not set

#
# on-CPU RTC drivers
#
# CONFIG_RTC_DRV_PCAP is not set
CONFIG_RTC_DRV_MC13XXX=y

#
# HID Sensor RTC drivers
#
# CONFIG_DMADEVICES is not set
# CONFIG_AUXDISPLAY is not set
CONFIG_UIO=y
# CONFIG_UIO_CIF is not set
CONFIG_UIO_PDRV=y
CONFIG_UIO_PDRV_GENIRQ=y
CONFIG_UIO_DMEM_GENIRQ=y
# CONFIG_UIO_AEC is not set
# CONFIG_UIO_SERCOS3 is not set
# CONFIG_UIO_PCI_GENERIC is not set
# CONFIG_UIO_NETX is not set
# CONFIG_VIRT_DRIVERS is not set
CONFIG_VIRTIO=y

#
# Virtio drivers
#
# CONFIG_VIRTIO_PCI is not set
CONFIG_VIRTIO_BALLOON=y
# CONFIG_VIRTIO_MMIO is not set

#
# Microsoft Hyper-V guest support
#
# CONFIG_HYPERV is not set
# CONFIG_STAGING is not set
# CONFIG_X86_PLATFORM_DEVICES is not set

#
# Hardware Spinlock drivers
#
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
CONFIG_PM_DEVFREQ=y

#
# DEVFREQ Governors
#
# CONFIG_DEVFREQ_GOV_SIMPLE_ONDEMAND is not set
CONFIG_DEVFREQ_GOV_PERFORMANCE=y
CONFIG_DEVFREQ_GOV_POWERSAVE=y
CONFIG_DEVFREQ_GOV_USERSPACE=y

#
# DEVFREQ Drivers
#
CONFIG_EXTCON=y

#
# Extcon Device Drivers
#
# CONFIG_EXTCON_GPIO is not set
# CONFIG_EXTCON_ADC_JACK is not set
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
CONFIG_HID_SENSOR_ACCEL_3D=y
CONFIG_KXSD9=y
# CONFIG_IIO_ST_ACCEL_3AXIS is not set

#
# Analog to digital converters
#
CONFIG_AD_SIGMA_DELTA=y
CONFIG_AD7266=y
CONFIG_AD7298=y
CONFIG_AD7923=y
CONFIG_AD7791=y
CONFIG_AD7793=y
CONFIG_AD7476=y
# CONFIG_AD7887 is not set
# CONFIG_MAX1363 is not set
CONFIG_TI_ADC081C=y
# CONFIG_TI_AM335X_ADC is not set

#
# Amplifiers
#
# CONFIG_AD8366 is not set

#
# Hid Sensor IIO Common
#
CONFIG_HID_SENSOR_IIO_COMMON=y
CONFIG_HID_SENSOR_IIO_TRIGGER=y
# CONFIG_HID_SENSOR_ENUM_BASE_QUIRKS is not set
CONFIG_IIO_ST_SENSORS_I2C=y
CONFIG_IIO_ST_SENSORS_SPI=y
CONFIG_IIO_ST_SENSORS_CORE=y

#
# Digital to analog converters
#
CONFIG_AD5064=y
CONFIG_AD5360=y
CONFIG_AD5380=y
# CONFIG_AD5421 is not set
CONFIG_AD5624R_SPI=y
# CONFIG_AD5446 is not set
# CONFIG_AD5449 is not set
# CONFIG_AD5504 is not set
CONFIG_AD5755=y
# CONFIG_AD5764 is not set
# CONFIG_AD5791 is not set
CONFIG_AD5686=y
CONFIG_MAX517=y
CONFIG_MCP4725=y

#
# Frequency Synthesizers DDS/PLL
#

#
# Clock Generator/Distribution
#
# CONFIG_AD9523 is not set

#
# Phase-Locked Loop (PLL) frequency synthesizers
#
CONFIG_ADF4350=y

#
# Digital gyroscope sensors
#
CONFIG_ADIS16080=y
# CONFIG_ADIS16136 is not set
CONFIG_ADXRS450=y
# CONFIG_HID_SENSOR_GYRO_3D is not set
# CONFIG_IIO_ST_GYRO_3AXIS is not set
CONFIG_ITG3200=y

#
# Inertial measurement units
#
# CONFIG_ADIS16400 is not set
CONFIG_ADIS16480=y
CONFIG_IIO_ADIS_LIB=y
CONFIG_IIO_ADIS_LIB_BUFFER=y
# CONFIG_INV_MPU6050_IIO is not set

#
# Light sensors
#
CONFIG_ADJD_S311=y
CONFIG_SENSORS_LM3533=y
CONFIG_SENSORS_TSL2563=y
# CONFIG_VCNL4000 is not set
# CONFIG_HID_SENSOR_ALS is not set

#
# Magnetometer sensors
#
# CONFIG_AK8975 is not set
# CONFIG_HID_SENSOR_MAGNETOMETER_3D is not set
CONFIG_IIO_ST_MAGN_3AXIS=y
CONFIG_IIO_ST_MAGN_I2C_3AXIS=y
CONFIG_IIO_ST_MAGN_SPI_3AXIS=y
# CONFIG_NTB is not set
# CONFIG_VME_BUS is not set
CONFIG_PWM=y
# CONFIG_PWM_TWL is not set
# CONFIG_PWM_TWL_LED is not set
CONFIG_IPACK_BUS=y
# CONFIG_BOARD_TPCI200 is not set
CONFIG_SERIAL_IPOCTAL=y
CONFIG_RESET_CONTROLLER=y

#
# Firmware Drivers
#
CONFIG_EDD=y
# CONFIG_EDD_OFF is not set
CONFIG_FIRMWARE_MEMMAP=y
# CONFIG_DELL_RBU is not set
# CONFIG_DCDBAS is not set
# CONFIG_DMIID is not set
# CONFIG_DMI_SYSFS is not set
# CONFIG_ISCSI_IBFT_FIND is not set
# CONFIG_GOOGLE_FIRMWARE is not set

#
# File systems
#
CONFIG_DCACHE_WORD_ACCESS=y
CONFIG_EXT2_FS=y
CONFIG_EXT2_FS_XATTR=y
# CONFIG_EXT2_FS_POSIX_ACL is not set
CONFIG_EXT2_FS_SECURITY=y
CONFIG_EXT2_FS_XIP=y
CONFIG_EXT3_FS=y
CONFIG_EXT3_DEFAULTS_TO_ORDERED=y
CONFIG_EXT3_FS_XATTR=y
# CONFIG_EXT3_FS_POSIX_ACL is not set
# CONFIG_EXT3_FS_SECURITY is not set
CONFIG_EXT4_FS=y
CONFIG_EXT4_FS_POSIX_ACL=y
# CONFIG_EXT4_FS_SECURITY is not set
# CONFIG_EXT4_DEBUG is not set
CONFIG_FS_XIP=y
CONFIG_JBD=y
# CONFIG_JBD_DEBUG is not set
CONFIG_JBD2=y
# CONFIG_JBD2_DEBUG is not set
CONFIG_FS_MBCACHE=y
# CONFIG_REISERFS_FS is not set
# CONFIG_JFS_FS is not set
# CONFIG_XFS_FS is not set
# CONFIG_GFS2_FS is not set
CONFIG_BTRFS_FS=y
CONFIG_BTRFS_FS_POSIX_ACL=y
# CONFIG_BTRFS_FS_CHECK_INTEGRITY is not set
# CONFIG_BTRFS_FS_RUN_SANITY_TESTS is not set
# CONFIG_BTRFS_DEBUG is not set
CONFIG_NILFS2_FS=y
CONFIG_FS_POSIX_ACL=y
CONFIG_FILE_LOCKING=y
CONFIG_FSNOTIFY=y
# CONFIG_DNOTIFY is not set
# CONFIG_INOTIFY_USER is not set
# CONFIG_FANOTIFY is not set
# CONFIG_QUOTA is not set
# CONFIG_QUOTACTL is not set
CONFIG_AUTOFS4_FS=y
CONFIG_FUSE_FS=y
CONFIG_CUSE=y

#
# Caches
#
CONFIG_FSCACHE=y
CONFIG_FSCACHE_STATS=y
CONFIG_FSCACHE_HISTOGRAM=y
# CONFIG_FSCACHE_DEBUG is not set
CONFIG_FSCACHE_OBJECT_LIST=y
# CONFIG_CACHEFILES is not set

#
# CD-ROM/DVD Filesystems
#
CONFIG_ISO9660_FS=y
CONFIG_JOLIET=y
# CONFIG_ZISOFS is not set
# CONFIG_UDF_FS is not set

#
# DOS/FAT/NT Filesystems
#
CONFIG_FAT_FS=y
CONFIG_MSDOS_FS=y
CONFIG_VFAT_FS=y
CONFIG_FAT_DEFAULT_CODEPAGE=437
CONFIG_FAT_DEFAULT_IOCHARSET="iso8859-1"
# CONFIG_NTFS_FS is not set

#
# Pseudo filesystems
#
CONFIG_PROC_FS=y
CONFIG_PROC_KCORE=y
CONFIG_PROC_SYSCTL=y
CONFIG_PROC_PAGE_MONITOR=y
CONFIG_SYSFS=y
# CONFIG_TMPFS is not set
# CONFIG_HUGETLBFS is not set
# CONFIG_HUGETLB_PAGE is not set
# CONFIG_CONFIGFS_FS is not set
# CONFIG_MISC_FILESYSTEMS is not set
CONFIG_NETWORK_FILESYSTEMS=y
# CONFIG_NCP_FS is not set
CONFIG_NLS=y
CONFIG_NLS_DEFAULT="iso8859-1"
CONFIG_NLS_CODEPAGE_437=y
CONFIG_NLS_CODEPAGE_737=y
CONFIG_NLS_CODEPAGE_775=y
CONFIG_NLS_CODEPAGE_850=y
CONFIG_NLS_CODEPAGE_852=y
CONFIG_NLS_CODEPAGE_855=y
# CONFIG_NLS_CODEPAGE_857 is not set
CONFIG_NLS_CODEPAGE_860=y
CONFIG_NLS_CODEPAGE_861=y
# CONFIG_NLS_CODEPAGE_862 is not set
CONFIG_NLS_CODEPAGE_863=y
CONFIG_NLS_CODEPAGE_864=y
CONFIG_NLS_CODEPAGE_865=y
CONFIG_NLS_CODEPAGE_866=y
CONFIG_NLS_CODEPAGE_869=y
# CONFIG_NLS_CODEPAGE_936 is not set
CONFIG_NLS_CODEPAGE_950=y
CONFIG_NLS_CODEPAGE_932=y
CONFIG_NLS_CODEPAGE_949=y
CONFIG_NLS_CODEPAGE_874=y
# CONFIG_NLS_ISO8859_8 is not set
# CONFIG_NLS_CODEPAGE_1250 is not set
CONFIG_NLS_CODEPAGE_1251=y
# CONFIG_NLS_ASCII is not set
CONFIG_NLS_ISO8859_1=y
CONFIG_NLS_ISO8859_2=y
CONFIG_NLS_ISO8859_3=y
CONFIG_NLS_ISO8859_4=y
# CONFIG_NLS_ISO8859_5 is not set
# CONFIG_NLS_ISO8859_6 is not set
CONFIG_NLS_ISO8859_7=y
CONFIG_NLS_ISO8859_9=y
CONFIG_NLS_ISO8859_13=y
# CONFIG_NLS_ISO8859_14 is not set
# CONFIG_NLS_ISO8859_15 is not set
CONFIG_NLS_KOI8_R=y
CONFIG_NLS_KOI8_U=y
CONFIG_NLS_MAC_ROMAN=y
CONFIG_NLS_MAC_CELTIC=y
CONFIG_NLS_MAC_CENTEURO=y
CONFIG_NLS_MAC_CROATIAN=y
CONFIG_NLS_MAC_CYRILLIC=y
# CONFIG_NLS_MAC_GAELIC is not set
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
CONFIG_PRINTK_TIME=y
CONFIG_DEFAULT_MESSAGE_LOGLEVEL=4
CONFIG_ENABLE_WARN_DEPRECATED=y
# CONFIG_ENABLE_MUST_CHECK is not set
CONFIG_FRAME_WARN=2048
# CONFIG_MAGIC_SYSRQ is not set
# CONFIG_STRIP_ASM_SYMS is not set
# CONFIG_READABLE_ASM is not set
# CONFIG_UNUSED_SYMBOLS is not set
CONFIG_DEBUG_FS=y
CONFIG_HEADERS_CHECK=y
# CONFIG_DEBUG_SECTION_MISMATCH is not set
CONFIG_DEBUG_KERNEL=y
# CONFIG_DEBUG_SHIRQ is not set
# CONFIG_LOCKUP_DETECTOR is not set
# CONFIG_PANIC_ON_OOPS is not set
CONFIG_PANIC_ON_OOPS_VALUE=0
# CONFIG_DETECT_HUNG_TASK is not set
# CONFIG_SCHED_DEBUG is not set
CONFIG_SCHEDSTATS=y
# CONFIG_TIMER_STATS is not set
CONFIG_DEBUG_OBJECTS=y
# CONFIG_DEBUG_OBJECTS_SELFTEST is not set
# CONFIG_DEBUG_OBJECTS_FREE is not set
# CONFIG_DEBUG_OBJECTS_TIMERS is not set
# CONFIG_DEBUG_OBJECTS_WORK is not set
CONFIG_DEBUG_OBJECTS_RCU_HEAD=y
# CONFIG_DEBUG_OBJECTS_PERCPU_COUNTER is not set
CONFIG_DEBUG_OBJECTS_ENABLE_DEFAULT=1
# CONFIG_SLUB_DEBUG_ON is not set
# CONFIG_SLUB_STATS is not set
CONFIG_HAVE_DEBUG_KMEMLEAK=y
# CONFIG_DEBUG_KMEMLEAK is not set
CONFIG_DEBUG_RT_MUTEXES=y
CONFIG_DEBUG_PI_LIST=y
CONFIG_RT_MUTEX_TESTER=y
CONFIG_DEBUG_SPINLOCK=y
CONFIG_DEBUG_MUTEXES=y
CONFIG_DEBUG_LOCK_ALLOC=y
# CONFIG_PROVE_LOCKING is not set
CONFIG_LOCKDEP=y
CONFIG_LOCK_STAT=y
# CONFIG_DEBUG_LOCKDEP is not set
CONFIG_DEBUG_ATOMIC_SLEEP=y
# CONFIG_DEBUG_LOCKING_API_SELFTESTS is not set
CONFIG_STACKTRACE=y
CONFIG_DEBUG_STACK_USAGE=y
# CONFIG_DEBUG_KOBJECT is not set
CONFIG_DEBUG_BUGVERBOSE=y
CONFIG_DEBUG_INFO=y
CONFIG_DEBUG_VM=y
CONFIG_DEBUG_VM_RB=y
CONFIG_DEBUG_VIRTUAL=y
# CONFIG_DEBUG_WRITECOUNT is not set
CONFIG_DEBUG_MEMORY_INIT=y
# CONFIG_DEBUG_LIST is not set
# CONFIG_TEST_LIST_SORT is not set
# CONFIG_DEBUG_SG is not set
CONFIG_DEBUG_NOTIFIERS=y
# CONFIG_DEBUG_CREDENTIALS is not set
CONFIG_ARCH_WANT_FRAME_POINTERS=y
CONFIG_FRAME_POINTER=y
# CONFIG_BOOT_PRINTK_DELAY is not set

#
# RCU Debugging
#
CONFIG_SPARSE_RCU_POINTER=y
# CONFIG_RCU_TORTURE_TEST is not set
# CONFIG_RCU_TRACE is not set
# CONFIG_BACKTRACE_SELF_TEST is not set
# CONFIG_DEBUG_BLOCK_EXT_DEVT is not set
CONFIG_DEBUG_FORCE_WEAK_PER_CPU=y
CONFIG_LKDTM=y
# CONFIG_NOTIFIER_ERROR_INJECTION is not set
CONFIG_FAULT_INJECTION=y
# CONFIG_FAILSLAB is not set
# CONFIG_FAIL_PAGE_ALLOC is not set
CONFIG_FAIL_MAKE_REQUEST=y
# CONFIG_FAIL_IO_TIMEOUT is not set
CONFIG_FAIL_MMC_REQUEST=y
CONFIG_FAULT_INJECTION_DEBUG_FS=y
# CONFIG_LATENCYTOP is not set
CONFIG_ARCH_HAS_DEBUG_STRICT_USER_COPY_CHECKS=y
# CONFIG_DEBUG_STRICT_USER_COPY_CHECKS is not set
CONFIG_DEBUG_PAGEALLOC=y
CONFIG_WANT_PAGE_DEBUG_FLAGS=y
CONFIG_PAGE_GUARD=y
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
CONFIG_RING_BUFFER=y
CONFIG_RING_BUFFER_ALLOW_SWAP=y
CONFIG_TRACING_SUPPORT=y
# CONFIG_FTRACE is not set
# CONFIG_PROVIDE_OHCI1394_DMA_INIT is not set
# CONFIG_BUILD_DOCSRC is not set
CONFIG_DYNAMIC_DEBUG=y
# CONFIG_DMA_API_DEBUG is not set
# CONFIG_ATOMIC64_SELFTEST is not set
# CONFIG_SAMPLES is not set
CONFIG_HAVE_ARCH_KGDB=y
# CONFIG_KGDB is not set
CONFIG_HAVE_ARCH_KMEMCHECK=y
# CONFIG_TEST_STRING_HELPERS is not set
CONFIG_TEST_KSTRTOX=y
# CONFIG_STRICT_DEVMEM is not set
CONFIG_X86_VERBOSE_BOOTUP=y
CONFIG_EARLY_PRINTK=y
# CONFIG_EARLY_PRINTK_DBGP is not set
# CONFIG_DEBUG_STACKOVERFLOW is not set
# CONFIG_X86_PTDUMP is not set
CONFIG_DEBUG_RODATA=y
CONFIG_DEBUG_RODATA_TEST=y
# CONFIG_DEBUG_TLBFLUSH is not set
# CONFIG_IOMMU_DEBUG is not set
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
CONFIG_OPTIMIZE_INLINING=y
# CONFIG_DEBUG_NMI_SELFTEST is not set

#
# Security options
#
# CONFIG_KEYS is not set
CONFIG_SECURITY_DMESG_RESTRICT=y
# CONFIG_SECURITY is not set
CONFIG_SECURITYFS=y
CONFIG_DEFAULT_SECURITY_DAC=y
CONFIG_DEFAULT_SECURITY=""
CONFIG_XOR_BLOCKS=y
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
# CONFIG_CRYPTO_USER is not set
# CONFIG_CRYPTO_MANAGER_DISABLE_TESTS is not set
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
# CONFIG_CRYPTO_CBC is not set
CONFIG_CRYPTO_CTR=y
CONFIG_CRYPTO_CTS=y
CONFIG_CRYPTO_ECB=y
CONFIG_CRYPTO_LRW=y
CONFIG_CRYPTO_PCBC=y
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
CONFIG_CRYPTO_CRC32C_INTEL=y
# CONFIG_CRYPTO_CRC32 is not set
CONFIG_CRYPTO_CRC32_PCLMUL=y
CONFIG_CRYPTO_GHASH=y
# CONFIG_CRYPTO_MD4 is not set
CONFIG_CRYPTO_MD5=y
CONFIG_CRYPTO_MICHAEL_MIC=y
# CONFIG_CRYPTO_RMD128 is not set
# CONFIG_CRYPTO_RMD160 is not set
CONFIG_CRYPTO_RMD256=y
CONFIG_CRYPTO_RMD320=y
CONFIG_CRYPTO_SHA1=y
# CONFIG_CRYPTO_SHA1_SSSE3 is not set
CONFIG_CRYPTO_SHA256_SSSE3=y
# CONFIG_CRYPTO_SHA512_SSSE3 is not set
CONFIG_CRYPTO_SHA256=y
CONFIG_CRYPTO_SHA512=y
# CONFIG_CRYPTO_TGR192 is not set
# CONFIG_CRYPTO_WP512 is not set
CONFIG_CRYPTO_GHASH_CLMUL_NI_INTEL=y

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
# CONFIG_CRYPTO_CAST5 is not set
# CONFIG_CRYPTO_CAST5_AVX_X86_64 is not set
CONFIG_CRYPTO_CAST6=y
CONFIG_CRYPTO_CAST6_AVX_X86_64=y
# CONFIG_CRYPTO_DES is not set
# CONFIG_CRYPTO_FCRYPT is not set
CONFIG_CRYPTO_KHAZAD=y
CONFIG_CRYPTO_SALSA20=y
CONFIG_CRYPTO_SALSA20_X86_64=y
CONFIG_CRYPTO_SEED=y
CONFIG_CRYPTO_SERPENT=y
# CONFIG_CRYPTO_SERPENT_SSE2_X86_64 is not set
CONFIG_CRYPTO_SERPENT_AVX_X86_64=y
CONFIG_CRYPTO_SERPENT_AVX2_X86_64=y
# CONFIG_CRYPTO_TEA is not set
# CONFIG_CRYPTO_TWOFISH is not set
CONFIG_CRYPTO_TWOFISH_COMMON=y
CONFIG_CRYPTO_TWOFISH_X86_64=y
# CONFIG_CRYPTO_TWOFISH_X86_64_3WAY is not set
# CONFIG_CRYPTO_TWOFISH_AVX_X86_64 is not set

#
# Compression
#
CONFIG_CRYPTO_DEFLATE=y
# CONFIG_CRYPTO_ZLIB is not set
CONFIG_CRYPTO_LZO=y

#
# Random Number Generation
#
# CONFIG_CRYPTO_ANSI_CPRNG is not set
CONFIG_CRYPTO_USER_API=y
CONFIG_CRYPTO_USER_API_HASH=y
CONFIG_CRYPTO_USER_API_SKCIPHER=y
# CONFIG_CRYPTO_HW is not set
CONFIG_HAVE_KVM=y
CONFIG_HAVE_KVM_IRQCHIP=y
CONFIG_HAVE_KVM_IRQ_ROUTING=y
CONFIG_HAVE_KVM_EVENTFD=y
CONFIG_KVM_APIC_ARCHITECTURE=y
CONFIG_KVM_MMIO=y
CONFIG_KVM_ASYNC_PF=y
CONFIG_HAVE_KVM_MSI=y
CONFIG_HAVE_KVM_CPU_RELAX_INTERCEPT=y
CONFIG_VIRTUALIZATION=y
CONFIG_KVM=y
# CONFIG_KVM_INTEL is not set
# CONFIG_KVM_AMD is not set
# CONFIG_BINARY_PRINTF is not set

#
# Library routines
#
CONFIG_RAID6_PQ=y
CONFIG_BITREVERSE=y
CONFIG_GENERIC_STRNCPY_FROM_USER=y
CONFIG_GENERIC_STRNLEN_USER=y
CONFIG_GENERIC_FIND_FIRST_BIT=y
CONFIG_GENERIC_PCI_IOMAP=y
CONFIG_GENERIC_IOMAP=y
CONFIG_GENERIC_IO=y
CONFIG_CRC_CCITT=y
CONFIG_CRC16=y
CONFIG_CRC_T10DIF=y
CONFIG_CRC_ITU_T=y
CONFIG_CRC32=y
# CONFIG_CRC32_SELFTEST is not set
CONFIG_CRC32_SLICEBY8=y
# CONFIG_CRC32_SLICEBY4 is not set
# CONFIG_CRC32_SARWATE is not set
# CONFIG_CRC32_BIT is not set
CONFIG_CRC7=y
CONFIG_LIBCRC32C=y
CONFIG_CRC8=y
CONFIG_ZLIB_INFLATE=y
CONFIG_ZLIB_DEFLATE=y
CONFIG_LZO_COMPRESS=y
CONFIG_LZO_DECOMPRESS=y
CONFIG_XZ_DEC=y
CONFIG_XZ_DEC_X86=y
CONFIG_XZ_DEC_POWERPC=y
# CONFIG_XZ_DEC_IA64 is not set
# CONFIG_XZ_DEC_ARM is not set
# CONFIG_XZ_DEC_ARMTHUMB is not set
# CONFIG_XZ_DEC_SPARC is not set
CONFIG_XZ_DEC_BCJ=y
CONFIG_XZ_DEC_TEST=y
CONFIG_DECOMPRESS_GZIP=y
CONFIG_DECOMPRESS_BZIP2=y
CONFIG_DECOMPRESS_LZMA=y
CONFIG_DECOMPRESS_XZ=y
CONFIG_DECOMPRESS_LZO=y
CONFIG_HAS_IOMEM=y
CONFIG_HAS_IOPORT=y
CONFIG_HAS_DMA=y
CONFIG_DQL=y
CONFIG_NLATTR=y
CONFIG_ARCH_HAS_ATOMIC64_DEC_IF_POSITIVE=y
CONFIG_AVERAGE=y
# CONFIG_CORDIC is not set
CONFIG_DDR=y
# CONFIG_IIO_SIMPLE_DUMMY is not set
# CONFIG_DRM_TTM is not set
# CONFIG_PCI_ATS is not set

--W/nzBZO5zC0uMSeA--
