Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754145Ab3JDBkk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Oct 2013 21:40:40 -0400
Received: from mga01.intel.com ([192.55.52.88]:4841 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753485Ab3JDBkf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Oct 2013 21:40:35 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.90,1029,1371106800"; 
   d="log'?scan'208";a="405091090"
Date: Fri, 4 Oct 2013 09:40:17 +0800
From: Fengguang Wu <fengguang.wu@intel.com>
To: Russell King <rmk+kernel@arm.linux.org.uk>
Cc: linux-kernel@vger.kernel.org, fengguang.wu@intel.com
Subject: [DMA-API] BUG: unable to handle kernel NULL pointer dereference at
 0000000000000248
Message-ID: <20131004014016.GA4958@localhost>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="yrj/dFKFPuw6o+aM"
Content-Disposition: inline
User-Agent: Heirloom mailx 12.5 6/20/10
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--yrj/dFKFPuw6o+aM
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi Russell,

I got the below dmesg and the first bad commit is

commit 2713c99438b00d67b4bd88eaf9713c8645c8daf7
Author: Russell King <rmk+kernel@arm.linux.org.uk>
Date:   Thu Jun 27 14:14:43 2013 +0100

    DMA-API: dcdbas: update DMA mask handing
    
    dcdbas was explicitly initializing DMA masks thusly:
    	dcdbas_pdev->dev.coherent_dma_mask = DMA_BIT_MASK(32);
    	dcdbas_pdev->dev.dma_mask = &dcdbas_pdev->dev.coherent_dma_mask;
    which bypasses the architecture check.  Moreover, it is creating the
    dcdbas_pdev device itself, and using the platform_device_register_full()
    avoids some of this explicit initialization.
    
    Convert the driver to use platform_device_register_full(), and as it
    makes use of coherent DMA, also call dma_set_coherent_mask() to ensure
    that the architecture gets to check the mask.
    
    Signed-off-by: Russell King <rmk+kernel@arm.linux.org.uk>

This BUG does not show up in upstream and linux-next, so either the
commit has not been merged or has been fixed somewhere.

[  267.537083] sdhci-pltfm: SDHCI platform and OF driver helper
[  267.602219] ledtrig-cpu: registered to indicate activity on CPUs
[  267.656654] BUG: unable to handle kernel NULL pointer dereference at 0000000000000248
[  267.656689] IP: [<ffffffff810073c9>] dma_supported+0x9/0xa0
[  267.656689] PGD 0 
[  267.656689] Oops: 0000 [#1] PREEMPT 
[  267.656689] CPU: 0 PID: 1 Comm: swapper Not tainted 3.12.0-rc2-00154-g12c6060 #3
[  267.656689] Hardware name: Bochs Bochs, BIOS Bochs 01/01/2011
[  267.656689] task: ffff88000d868000 ti: ffff88000d864000 task.ti: ffff88000d864000
[  267.656689] RIP: 0010:[<ffffffff810073c9>]  [<ffffffff810073c9>] dma_supported+0x9/0xa0
[  267.656689] RSP: 0000:ffff88000d865cb0  EFLAGS: 00000202
[  267.656689] RAX: ffffffff814c0b90 RBX: 00000000fffffffb RCX: 0000000000000001
[  267.656689] RDX: 0000000000000780 RSI: 00000000ffffffff RDI: 0000000000000010
[  267.656689] RBP: ffff88000d865cb0 R08: 0000000000000001 R09: 0000000000000001
[  267.656689] R10: 0000000000000000 R11: 0000000000000000 R12: 0000000000000000
[  267.656689] R13: ffff88000f5eb400 R14: ffffffff81c85240 R15: 0000000000000000
[  267.656689] FS:  0000000000000000(0000) GS:ffffffff81a6b000(0000) knlGS:0000000000000000
[  267.656689] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[  267.656689] CR2: 0000000000000248 CR3: 0000000001a5c000 CR4: 00000000000006b0
[  267.656689] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[  267.656689] DR3: 0000000000000000 DR6: 0000000000000000 DR7: 0000000000000000
[  267.656689] Stack:
[  267.656689]  ffff88000d865cd8 ffffffff816878d6 ffff88000f5eb410 ffffffff81d00128
[  267.656689]  ffff88000f5eb400 ffff88000d865d08 ffffffff814c0bce ffffffff814bf06e
[  267.656689]  ffff88000f5eb410 ffff88000f5eb410 ffffffff81d00128 ffff88000d865d30
[  267.656689] Call Trace:
[  267.656689]  [<ffffffff816878d6>] dcdbas_probe+0x46/0xb0
[  267.656689]  [<ffffffff814c0bce>] platform_drv_probe+0x3e/0x70
[  267.656689]  [<ffffffff814bf06e>] ? driver_sysfs_add+0x6e/0xa0
[  267.656689]  [<ffffffff814bf495>] really_probe+0xc5/0x1e0
[  267.656689]  [<ffffffff814bf5d0>] ? driver_probe_device+0x20/0x20
[  267.656689]  [<ffffffff814bf625>] __device_attach+0x55/0x70
[  267.656689]  [<ffffffff814bdc6e>] bus_for_each_drv+0x5e/0xb0
[  267.656689]  [<ffffffff814bf328>] device_attach+0x78/0x90
[  267.656689]  [<ffffffff814bdee5>] bus_probe_device+0x35/0xd0
[  267.656689]  [<ffffffff814bbafd>] device_add+0x4ad/0x720
[  267.656689]  [<ffffffff814c11f0>] platform_device_add+0x180/0x210
[  267.656689]  [<ffffffff814c14a0>] platform_device_register_full+0xb0/0x110
[  267.656689]  [<ffffffff81d57880>] ? dcdrbu_init+0x15a/0x15a
[  267.656689]  [<ffffffff81d578a6>] dcdbas_init+0x26/0x51
[  267.656689]  [<ffffffff81d23e62>] do_one_initcall+0x7d/0x115
[  267.656689]  [<ffffffff81d2403d>] kernel_init_freeable+0x143/0x1cf
[  267.656689]  [<ffffffff81d23831>] ? do_early_param+0x8a/0x8a
[  267.656689]  [<ffffffff8174da90>] ? rest_init+0xc0/0xc0
[  267.656689]  [<ffffffff8174da99>] kernel_init+0x9/0x170
[  267.656689]  [<ffffffff817623ca>] ret_from_fork+0x7a/0xb0
[  267.656689]  [<ffffffff8174da90>] ? rest_init+0xc0/0xc0
[  267.656689] Code: 0c 48 0f bd c6 8d 70 01 e8 05 24 0f 00 48 8b 5d f0 4c 8b 65 f8 c9 c3 66 66 2e 0f 1f 84 00 00 00 00 00 55 48 85 ff 48 89 e5 74 0c <48> 8b 87 38 02 00 00 48 85 c0 75 0b 48 8b 05 3c e0 a5 00 0f 1f 
[  267.656689] RIP  [<ffffffff810073c9>] dma_supported+0x9/0xa0
[  267.656689]  RSP <ffff88000d865cb0>
[  267.656689] CR2: 0000000000000248
[  267.751209] ---[ end trace a1914743e6b14bdd ]---

git bisect start 12c6060d1380098bb69fad0c26200557d0763355 4a10c2ac2f368583138b774ca41fac4207911983 --
git bisect good 5dd16df0949a73a3dfd7bfb976d68d6ba2e0676e  # 07:52     60+  Merge remote-tracking branch 'rcu/rcu/fixes' into kbuild_tmp
git bisect good 8706fffa0da105de430ae2492c37348c076140fa  # 11:41     60+  DMA-API: usb: use new dma_coerce_mask_and_coherent()
git bisect good f516e2c9ecdcc717d25fe1533805a7960310c186  # 12:49     60+  Merge branch 'bnx2x'
git bisect  bad 55871ea05974c2bbd3082bbae95448eea777873a  # 12:54      0-  ARM: DMA-API: better handing of DMA masks for coherent allocations
git bisect good 067f3c33c61816c4cb34f91f1a73dbd86fe6f867  # 17:37     60+  DMA-API: crypto: remove last references to 'static struct device *dev'
git bisect good cf792a24d10b66d903549fe911084fda0cc78bb9  # 18:46     60+  DMA-API: dma: edma.c: no need to explicitly initialize DMA masks
git bisect  bad aff71e59b441bcef245d86e82903950d5581a3aa  # 18:55      0-  DMA-API: firmware/google/gsmi.c: avoid direct access to DMA masks
git bisect  bad 2713c99438b00d67b4bd88eaf9713c8645c8daf7  # 18:57      0-  DMA-API: dcdbas: update DMA mask handing
git bisect good cf792a24d10b66d903549fe911084fda0cc78bb9  # 00:20    180+  DMA-API: dma: edma.c: no need to explicitly initialize DMA masks
git bisect  bad 12c6060d1380098bb69fad0c26200557d0763355  # 00:20      0-  Merge remote-tracking branch 'arm-soc/to-build' into kbuild_tmp
git bisect good f1ee84840f837a5939f40cf07c3e6bceeb2a5432  # 05:48    180+  Revert "DMA-API: dcdbas: update DMA mask handing"
git bisect good 6d15ee492809d38bd62237b6d0f6a81d4dd12d15  # 06:22    180+  Merge git://git.kernel.org/pub/scm/virt/kvm/kvm
git bisect good a0cf1abc25ac197dd97b857c0f6341066a8cb1cf  # 09:25    180+  Add linux-next specific files for 20130927

Thanks,
Fengguang

--yrj/dFKFPuw6o+aM
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="dmesg-quantal-ant-3:20130924081102:3.12.0-rc2-00154-g12c6060:3"
Content-Transfer-Encoding: quoted-printable

[    0.000000] Initializing cgroup subsys cpuset
[    0.000000] Initializing cgroup subsys cpu
[    0.000000] Linux version 3.12.0-rc2-00154-g12c6060 (kbuild@cairo) (gcc =
version 4.8.1 (Debian 4.8.1-8) ) #3 PREEMPT Tue Sep 24 07:59:40 CST 2013
[    0.000000] Command line: hung_task_panic=3D1 rcutree.rcu_cpu_stall_time=
out=3D100 log_buf_len=3D8M ignore_loglevel debug sched_debug apic=3Ddebug d=
ynamic_printk sysrq_always_enabled panic=3D10  prompt_ramdisk=3D0 console=
=3DttyS0,115200 console=3Dtty0 vga=3Dnormal  root=3D/dev/ram0 rw link=3D/ke=
rnel-tests/run-queue/kvm/x86_64-randconfig-c8-0924/devel-cairo-x86_64-20130=
9240752/.vmlinuz-12c6060d1380098bb69fad0c26200557d0763355-20130924080006-9-=
ant branch=3Dlinux-devel/devel-cairo-x86_64-201309240752 BOOT_IMAGE=3D/kern=
el/x86_64-randconfig-c8-0924/12c6060d1380098bb69fad0c26200557d0763355/vmlin=
uz-3.12.0-rc2-00154-g12c6060 noapic nolapic nohz=3Doff
[    0.000000] e820: BIOS-provided physical RAM map:
[    0.000000] BIOS-e820: [mem 0x0000000000000000-0x000000000009fbff] usable
[    0.000000] BIOS-e820: [mem 0x000000000009fc00-0x000000000009ffff] reser=
ved
[    0.000000] BIOS-e820: [mem 0x00000000000f0000-0x00000000000fffff] reser=
ved
[    0.000000] BIOS-e820: [mem 0x0000000000100000-0x000000000fffdfff] usable
[    0.000000] BIOS-e820: [mem 0x000000000fffe000-0x000000000fffffff] reser=
ved
[    0.000000] BIOS-e820: [mem 0x00000000fffc0000-0x00000000ffffffff] reser=
ved
[    0.000000] debug: ignoring loglevel setting.
[    0.000000] NX (Execute Disable) protection: active
[    0.000000] SMBIOS 2.4 present.
[    0.000000] DMI: Bochs Bochs, BIOS Bochs 01/01/2011
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
[    0.000000] x86 PAT enabled: cpu 0, old 0x7040600070406, new 0x701060007=
0106
[    0.000000] Scan for SMP in [mem 0x00000000-0x000003ff]
[    0.000000] Scan for SMP in [mem 0x0009fc00-0x0009ffff]
[    0.000000] Scan for SMP in [mem 0x000f0000-0x000fffff]
[    0.000000] found SMP MP-table at [mem 0x000fdab0-0x000fdabf] mapped at =
[ffff8800000fdab0]
[    0.000000]   mpc: fdac0-fdbe4
[    0.000000] Base memory trampoline at [ffff880000099000] 99000 size 24576
[    0.000000] init_memory_mapping: [mem 0x00000000-0x000fffff]
[    0.000000]  [mem 0x00000000-0x000fffff] page 4k
[    0.000000] BRK [0x02892000, 0x02892fff] PGTABLE
[    0.000000] BRK [0x02893000, 0x02893fff] PGTABLE
[    0.000000] BRK [0x02894000, 0x02894fff] PGTABLE
[    0.000000] init_memory_mapping: [mem 0x0e600000-0x0e7fffff]
[    0.000000]  [mem 0x0e600000-0x0e7fffff] page 2M
[    0.000000] init_memory_mapping: [mem 0x0c000000-0x0e5fffff]
[    0.000000]  [mem 0x0c000000-0x0e5fffff] page 2M
[    0.000000] init_memory_mapping: [mem 0x00100000-0x0bffffff]
[    0.000000]  [mem 0x00100000-0x001fffff] page 4k
[    0.000000]  [mem 0x00200000-0x0bffffff] page 2M
[    0.000000] init_memory_mapping: [mem 0x0e800000-0x0fffdfff]
[    0.000000]  [mem 0x0e800000-0x0fdfffff] page 2M
[    0.000000]  [mem 0x0fe00000-0x0fffdfff] page 4k
[    0.000000] BRK [0x02895000, 0x02895fff] PGTABLE
[    0.000000] log_buf_len: 8388608
[    0.000000] early log buf free: 127328(97%)
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
[    0.000000]  [ffffea0000000000-ffffea00003fffff] PMD -> [ffff88000d40000=
0-ffff88000d7fffff] on node 0
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
[    0.000000] ACPI: HPET id: 0x8086a201 base: 0xfed00000
[    0.000000] Intel MultiProcessor Specification v1.4
[    0.000000]   mpc: fdac0-fdbe4
[    0.000000] MPTABLE: OEM ID: BOCHSCPU
[    0.000000] MPTABLE: Product ID: 0.1        =20
[    0.000000] MPTABLE: APIC at: 0xFEE00000
[    0.000000] mapped APIC to ffffffffff5fa000 (        fee00000)
[    0.000000] Processor #0 (Bootup-CPU)
[    0.000000] Processor #1
[    0.000000] ACPI: NR_CPUS/possible_cpus limit of 1 reached.  Processor 1=
/0x1 ignored.
[    0.000000] Bus #0 is PCI  =20
[    0.000000] Bus #1 is ISA  =20
[    0.000000] IOAPIC[0]: apic_id 0, version 17, address 0xfec00000, GSI 0-=
23
[    0.000000] Int: type 0, pol 1, trig 0, bus 00, IRQ 04, APIC ID 0, APIC =
INT 09
[    0.000000] Int: type 0, pol 1, trig 0, bus 00, IRQ 0c, APIC ID 0, APIC =
INT 0b
[    0.000000] Int: type 0, pol 1, trig 0, bus 00, IRQ 10, APIC ID 0, APIC =
INT 0b
[    0.000000] Int: type 0, pol 1, trig 0, bus 00, IRQ 14, APIC ID 0, APIC =
INT 0a
[    0.000000] Int: type 0, pol 1, trig 0, bus 00, IRQ 18, APIC ID 0, APIC =
INT 0a
[    0.000000] Int: type 0, pol 1, trig 0, bus 00, IRQ 1c, APIC ID 0, APIC =
INT 0b
[    0.000000] Int: type 0, pol 1, trig 0, bus 00, IRQ 20, APIC ID 0, APIC =
INT 0b
[    0.000000] Int: type 0, pol 1, trig 0, bus 00, IRQ 24, APIC ID 0, APIC =
INT 0a
[    0.000000] Int: type 0, pol 1, trig 0, bus 00, IRQ 28, APIC ID 0, APIC =
INT 0a
[    0.000000] Int: type 0, pol 0, trig 0, bus 01, IRQ 00, APIC ID 0, APIC =
INT 02
[    0.000000] Int: type 0, pol 0, trig 0, bus 01, IRQ 01, APIC ID 0, APIC =
INT 01
[    0.000000] Int: type 0, pol 0, trig 0, bus 01, IRQ 03, APIC ID 0, APIC =
INT 03
[    0.000000] Int: type 0, pol 0, trig 0, bus 01, IRQ 04, APIC ID 0, APIC =
INT 04
[    0.000000] Int: type 0, pol 0, trig 0, bus 01, IRQ 05, APIC ID 0, APIC =
INT 05
[    0.000000] Int: type 0, pol 0, trig 0, bus 01, IRQ 06, APIC ID 0, APIC =
INT 06
[    0.000000] Int: type 0, pol 0, trig 0, bus 01, IRQ 07, APIC ID 0, APIC =
INT 07
[    0.000000] Int: type 0, pol 0, trig 0, bus 01, IRQ 08, APIC ID 0, APIC =
INT 08
[    0.000000] Int: type 0, pol 0, trig 0, bus 01, IRQ 0c, APIC ID 0, APIC =
INT 0c
[    0.000000] Int: type 0, pol 0, trig 0, bus 01, IRQ 0d, APIC ID 0, APIC =
INT 0d
[    0.000000] Int: type 0, pol 0, trig 0, bus 01, IRQ 0e, APIC ID 0, APIC =
INT 0e
[    0.000000] Int: type 0, pol 0, trig 0, bus 01, IRQ 0f, APIC ID 0, APIC =
INT 0f
[    0.000000] Lint: type 3, pol 0, trig 0, bus 01, IRQ 00, APIC ID 0, APIC=
 LINT 00
[    0.000000] Lint: type 1, pol 0, trig 0, bus 01, IRQ 00, APIC ID ff, API=
C LINT 01
[    0.000000] Processors: 1
[    0.000000] mapped IOAPIC to ffffffffff5f9000 (fec00000)
[    0.000000] nr_irqs_gsi: 40
[    0.000000] PM: Registered nosave memory: [mem 0x0009f000-0x0009ffff]
[    0.000000] PM: Registered nosave memory: [mem 0x000a0000-0x000effff]
[    0.000000] PM: Registered nosave memory: [mem 0x000f0000-0x000fffff]
[    0.000000] e820: [mem 0x10000000-0xfffbffff] available for PCI devices
[    0.000000] Booting paravirtualized kernel on bare hardware
[    0.000000] pcpu-alloc: s0 r0 d32768 u32768 alloc=3D1*32768
[    0.000000] pcpu-alloc: [0] 0=20
[    0.000000] Built 1 zonelists in Zone order, mobility grouping on.  Tota=
l pages: 64391
[    0.000000] Kernel command line: hung_task_panic=3D1 rcutree.rcu_cpu_sta=
ll_timeout=3D100 log_buf_len=3D8M ignore_loglevel debug sched_debug apic=3D=
debug dynamic_printk sysrq_always_enabled panic=3D10  prompt_ramdisk=3D0 co=
nsole=3DttyS0,115200 console=3Dtty0 vga=3Dnormal  root=3D/dev/ram0 rw link=
=3D/kernel-tests/run-queue/kvm/x86_64-randconfig-c8-0924/devel-cairo-x86_64=
-201309240752/.vmlinuz-12c6060d1380098bb69fad0c26200557d0763355-20130924080=
006-9-ant branch=3Dlinux-devel/devel-cairo-x86_64-201309240752 BOOT_IMAGE=
=3D/kernel/x86_64-randconfig-c8-0924/12c6060d1380098bb69fad0c26200557d07633=
55/vmlinuz-3.12.0-rc2-00154-g12c6060 noapic nolapic nohz=3Doff
[    0.000000] sysrq: sysrq always enabled.
[    0.000000] PID hash table entries: 1024 (order: 1, 8192 bytes)
[    0.000000] Dentry cache hash table entries: 32768 (order: 6, 262144 byt=
es)
[    0.000000] Inode-cache hash table entries: 16384 (order: 5, 131072 byte=
s)
[    0.000000] Checking aperture...
[    0.000000] No AGP bridge found
[    0.000000] Memory: 199380K/261744K available (7567K kernel code, 2906K =
rwdata, 2968K rodata, 804K init, 10896K bss, 62364K reserved)
[    0.000000] SLUB: HWalign=3D64, Order=3D0-3, MinObjects=3D0, CPUs=3D1, N=
odes=3D1
[    0.000000] Preemptible hierarchical RCU implementation.
[    0.000000]=20
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
[    0.000000]  memory used by lock dependency info: 6367 kB
[    0.000000]  per task-struct memory footprint: 2688 bytes
[    0.000000] ODEBUG: 4 of 4 active objects replaced
[    0.000000] hpet clockevent registered
[    0.000000] tsc: Fast TSC calibration using PIT
[    0.000000] tsc: Detected 3191.927 MHz processor
[    0.011000] Calibrating delay loop (skipped), value calculated using tim=
er frequency.. 6383.85 BogoMIPS (lpj=3D3191927)
[    0.012426] pid_max: default: 32768 minimum: 301
[    0.029855] Mount-cache hash table entries: 256
[    0.143260] Initializing cgroup subsys debug
[    0.147443] Initializing cgroup subsys devices
[    0.150293] Initializing cgroup subsys perf_event
[    0.167436] Last level iTLB entries: 4KB 0, 2MB 0, 4MB 0
[    0.167436] Last level dTLB entries: 4KB 0, 2MB 0, 4MB 0
[    0.167436] tlb_flushall_shift: -1
[    0.168305] CPU: AMD QEMU Virtual CPU version 1.6.0 (fam: 06, model: 02,=
 stepping: 03)
[    0.245000] ACPI: Core revision 20130823
[    0.559362] ACPI: All ACPI Tables successfully acquired
[    0.562530] ACPI: setting ELCR to 0200 (from 0c00)
[    0.629805] Performance Events:=20
[    0.632379] no APIC, boot with the "lapic" boot parameter to force-enabl=
e it.
[    0.633230] no hardware sampling interrupt available.
[    0.636411] Broken PMU hardware detected, using software events only.
[    0.637255] Failed to access perfctr msr (MSR c0010004 is 0)
[    0.772435] Apic disabled
[    0.782333] NMI watchdog: disabled (cpu0): hardware events not enabled
[    1.120816] atomic64 test passed for x86-64 platform with CX8 and with S=
SE
[    1.168489] regulator-dummy: no parameters
[    1.206306] NET: Registered protocol family 16
[    1.269598] cpuidle: using governor ladder
[    1.272419] cpuidle: using governor menu
[    1.292314] ACPI: bus type PCI registered
[    1.297358] PCI: Using configuration type 1 for base access
[    4.525792] bio: create slab <bio-0> at 0
[    4.635276] ACPI: Added _OSI(Module Device)
[    4.638502] ACPI: Added _OSI(Processor Device)
[    4.639398] ACPI: Added _OSI(3.0 _SCP Extensions)
[    4.642399] ACPI: Added _OSI(Processor Aggregator Device)
[    5.672414] ACPI: EC: Look up EC in DSDT
[    8.032361] ACPI: Interpreter enabled
[    8.052334] ACPI: (supports S0 S4 S5)
[    8.055280] ACPI: Using PIC for interrupt routing
[    8.071733] PCI: Using host bridge windows from ACPI; if necessary, use =
"pci=3Dnocrs" and report a bug
[   11.827000] ACPI: PCI Root Bridge [PCI0] (domain 0000 [bus 00-ff])
[   11.829930] acpi PNP0A03:00: Unable to request _OSC control (_OSC suppor=
t mask: 0x08)
[   11.924758] PCI host bridge to bus 0000:00
[   11.927571] pci_bus 0000:00: root bus resource [bus 00-ff]
[   11.930452] pci_bus 0000:00: root bus resource [io  0x0000-0x0cf7]
[   11.932281] pci_bus 0000:00: root bus resource [io  0x0d00-0xffff]
[   11.934328] pci_bus 0000:00: root bus resource [mem 0x000a0000-0x000bfff=
f]
[   11.935189] pci_bus 0000:00: root bus resource [mem 0x80000000-0xfebffff=
f]
[   11.943482] pci 0000:00:00.0: [8086:1237] type 00 class 0x060000
[   12.038199] pci 0000:00:01.0: [8086:7000] type 00 class 0x060100
[   12.124189] pci 0000:00:01.1: [8086:7010] type 00 class 0x010180
[   12.151354] pci 0000:00:01.1: reg 0x20: [io  0xc1e0-0xc1ef]
[   12.232439] pci 0000:00:01.3: [8086:7113] type 00 class 0x068000
[   12.247830] pci 0000:00:01.3: quirk: [io  0xb000-0xb03f] claimed by PIIX=
4 ACPI
[   12.249196] pci 0000:00:01.3: quirk: [io  0xb100-0xb10f] claimed by PIIX=
4 SMB
[   12.326362] pci 0000:00:02.0: [1013:00b8] type 00 class 0x030000
[   12.333379] pci 0000:00:02.0: reg 0x10: [mem 0xfc000000-0xfdffffff pref]
[   12.337560] pci 0000:00:02.0: reg 0x14: [mem 0xfebe0000-0xfebe0fff]
[   12.356350] pci 0000:00:02.0: reg 0x30: [mem 0xfebc0000-0xfebcffff pref]
[   12.431190] pci 0000:00:03.0: [1af4:1000] type 00 class 0x020000
[   12.438252] pci 0000:00:03.0: reg 0x10: [io  0xc1c0-0xc1df]
[   12.443328] pci 0000:00:03.0: reg 0x14: [mem 0xfebe1000-0xfebe1fff]
[   12.475335] pci 0000:00:03.0: reg 0x30: [mem 0xfebd0000-0xfebdffff pref]
[   12.554215] pci 0000:00:04.0: [8086:100e] type 00 class 0x020000
[   12.561269] pci 0000:00:04.0: reg 0x10: [mem 0xfeb80000-0xfeb9ffff]
[   12.567280] pci 0000:00:04.0: reg 0x14: [io  0xc000-0xc03f]
[   12.587288] pci 0000:00:04.0: reg 0x30: [mem 0xfeba0000-0xfebbffff pref]
[   12.661682] pci 0000:00:05.0: [1af4:1001] type 00 class 0x010000
[   12.670793] pci 0000:00:05.0: reg 0x10: [io  0xc040-0xc07f]
[   12.675253] pci 0000:00:05.0: reg 0x14: [mem 0xfebe2000-0xfebe2fff]
[   12.767431] pci 0000:00:06.0: [1af4:1001] type 00 class 0x010000
[   12.774277] pci 0000:00:06.0: reg 0x10: [io  0xc080-0xc0bf]
[   12.779334] pci 0000:00:06.0: reg 0x14: [mem 0xfebe3000-0xfebe3fff]
[   12.894319] pci 0000:00:07.0: [1af4:1001] type 00 class 0x010000
[   12.902361] pci 0000:00:07.0: reg 0x10: [io  0xc0c0-0xc0ff]
[   12.916345] pci 0000:00:07.0: reg 0x14: [mem 0xfebe4000-0xfebe4fff]
[   13.080573] pci 0000:00:08.0: [1af4:1001] type 00 class 0x010000
[   13.093371] pci 0000:00:08.0: reg 0x10: [io  0xc100-0xc13f]
[   13.104319] pci 0000:00:08.0: reg 0x14: [mem 0xfebe5000-0xfebe5fff]
[   13.269746] pci 0000:00:09.0: [1af4:1001] type 00 class 0x010000
[   13.284395] pci 0000:00:09.0: reg 0x10: [io  0xc140-0xc17f]
[   13.292357] pci 0000:00:09.0: reg 0x14: [mem 0xfebe6000-0xfebe6fff]
[   13.454460] pci 0000:00:0a.0: [1af4:1001] type 00 class 0x010000
[   13.469372] pci 0000:00:0a.0: reg 0x10: [io  0xc180-0xc1bf]
[   13.483313] pci 0000:00:0a.0: reg 0x14: [mem 0xfebe7000-0xfebe7fff]
[   13.671348] pci 0000:00:0b.0: [8086:25ab] type 00 class 0x088000
[   13.683547] pci 0000:00:0b.0: reg 0x10: [mem 0xfebe8000-0xfebe800f]
[   13.860268] pci_bus 0000:00: on NUMA node 0
[   14.249382] ACPI: PCI Interrupt Link [LNKA] (IRQs 5 *10 11)
[   14.315279] ACPI: PCI Interrupt Link [LNKB] (IRQs 5 *10 11)
[   14.373401] ACPI: PCI Interrupt Link [LNKC] (IRQs 5 10 *11)
[   14.429315] ACPI: PCI Interrupt Link [LNKD] (IRQs 5 10 *11)
[   14.463301] ACPI: PCI Interrupt Link [LNKS] (IRQs *9)
[   14.677000] ACPI: Enabled 16 GPEs in block 00 to 0F
[   14.683343] ACPI: \_SB_.PCI0: notify handler is installed
[   14.737394] Found 1 acpi root devices
[   14.850000] vgaarb: device added: PCI:0000:00:02.0,decodes=3Dio+mem,owns=
=3Dio+mem,locks=3Dnone
[   14.853550] vgaarb: loaded
[   14.855381] vgaarb: bridge control possible 0000:00:02.0
[   14.911282] ACPI: bus type USB registered
[   14.925539] usbcore: registered new interface driver usbfs
[   14.934427] usbcore: registered new interface driver hub
[   14.950565] usbcore: registered new device driver usb
[   14.990300] pps_core: LinuxPPS API ver. 1 registered
[   14.992475] pps_core: Software ver. 5.3.6 - Copyright 2005-2007 Rodolfo =
Giometti <giometti@linux.it>
[   14.997405] PTP clock support registered
[   15.010221] EDAC MC: Ver: 3.0.0
[   15.045421] EDAC DEBUG: edac_mc_sysfs_init: device mc created
[   17.041811] Advanced Linux Sound Architecture Driver Initialized.
[   17.042344] PCI: Using ACPI for IRQ routing
[   17.046207] PCI: pci_cache_line_size set to 64 bytes
[   17.060875] e820: reserve RAM buffer [mem 0x0009fc00-0x0009ffff]
[   17.062645] e820: reserve RAM buffer [mem 0x0fffe000-0x0fffffff]
[   17.163353] Switched to clocksource hpet
[   17.194346] FS-Cache: Loaded
[   17.203252] CacheFiles: Loaded
[   17.214180] pnp: PnP ACPI init
[   17.219351] ACPI: bus type PNP registered
[   17.253337] pnp 00:00: Plug and Play ACPI device, IDs PNP0b00 (active)
[   17.270162] pnp 00:01: Plug and Play ACPI device, IDs PNP0303 (active)
[   17.288284] pnp 00:02: Plug and Play ACPI device, IDs PNP0f13 (active)
[   17.304155] pnp 00:03: [dma 2]
[   17.314029] pnp 00:03: Plug and Play ACPI device, IDs PNP0700 (active)
[   17.335377] pnp 00:04: Plug and Play ACPI device, IDs PNP0400 (active)
[   17.360270] pnp 00:05: Plug and Play ACPI device, IDs PNP0501 (active)
[   17.472266] pnp 00:06: Plug and Play ACPI device, IDs PNP0103 (active)
[   17.526716] pnp: PnP ACPI: found 7 devices
[   17.529228] ACPI: bus type PNP unregistered
[   17.999246] pci_bus 0000:00: resource 4 [io  0x0000-0x0cf7]
[   18.003147] pci_bus 0000:00: resource 5 [io  0x0d00-0xffff]
[   18.005142] pci_bus 0000:00: resource 6 [mem 0x000a0000-0x000bffff]
[   18.007682] pci_bus 0000:00: resource 7 [mem 0x80000000-0xfebfffff]
[   18.017384] NET: Registered protocol family 1
[   18.024521] pci 0000:00:00.0: Limiting direct PCI/PCI transfers
[   18.027298] pci 0000:00:01.0: PIIX3: Enabling Passive Release
[   18.033494] pci 0000:00:01.0: Activating ISA DMA hang workarounds
[   18.038227] pci 0000:00:02.0: Boot video device
[   18.045295] PCI: CLS 0 bytes, default 64
[   18.142364] Unpacking initramfs...
[  166.852441] Freeing initrd memory: 23656K (ffff88000e8d6000 - ffff88000f=
ff0000)
[  167.703715] PCLMULQDQ-NI instructions are not detected.
[  167.707113] sha256_ssse3: Neither AVX nor SSSE3 is available/usable.
[  167.711478] AVX or AES-NI instructions are not detected.
[  167.718356] AVX instructions are not detected.
[  167.722155] AVX instructions are not detected.
[  167.724103] AVX instructions are not detected.
[  167.725394] AVX instructions are not detected.
[  167.911182] tsc: Refined TSC clocksource calibration: 3191.889 MHz
[  167.920661] Switched to clocksource tsc
[  169.108276] zbud: loaded
[  169.285373] VFS: Disk quotas dquot_6.5.2
[  169.329288] Dquot-cache hash table entries: 512 (order 0, 4096 bytes)
[  170.052349] NTFS driver 2.1.30 [Flags: R/W].
[  170.145396] fuse init (API version 7.22)
[  170.328266] JFS: nTxBlock =3D 1742, nTxLock =3D 13939
[  170.549415] SGI XFS with security attributes, large block/inode numbers,=
 debug enabled
[  171.009441] NILFS version 2 loaded
[  171.998491] GFS2 installed
[  172.003268] msgmni has been set to 435
[  172.868281] Block layer SCSI generic (bsg) driver version 0.4 loaded (ma=
jor 250)
[  172.871099] io scheduler noop registered
[  172.872391] io scheduler deadline registered (default)
[  172.876355] io scheduler cfq registered
[  172.931132] xz_dec_test: module loaded
[  172.932384] xz_dec_test: Create a device node with 'mknod xz_dec_test c =
249 0' and write .xz files to it.
[  172.934104] rbtree testing -> 759395 cycles
[  198.225405] augmented rbtree testing -> 1198977 cycles
[  239.068233] no IO addresses supplied
[  239.138180] ipmi message handler version 39.2
[  239.152397] ipmi device interface
[  239.177113] IPMI System Interface driver.
[  239.207183] ipmi_si: Adding default-specified kcs state machine
[  239.211244] ipmi_si: Trying default-specified kcs state machine at i/o a=
ddress 0xca2, slave address 0x0, irq 0
[  239.219210] ipmi_si: Interface detection failed
[  239.240207] ipmi_si: Adding default-specified smic state machine
[  239.243352] ipmi_si: Trying default-specified smic state machine at i/o =
address 0xca9, slave address 0x0, irq 0
[  239.257283] ipmi_si: Interface detection failed
[  239.263398] ipmi_si: Adding default-specified bt state machine
[  239.267152] ipmi_si: Trying default-specified bt state machine at i/o ad=
dress 0xe4, slave address 0x0, irq 0
[  239.273295] ipmi_si: Interface detection failed
[  239.315223] ipmi_si: Unable to find any System Interface(s)
[  239.317603] Copyright (C) 2004 MontaVista Software - IPMI Powerdown via =
sys_reboot.
[  239.395171] input: Power Button as /devices/LNXSYSTM:00/LNXPWRBN:00/inpu=
t/input0
[  239.409250] ACPI: Power Button [PWRF]
[  247.970237] [sched_delayed] sched: RT throttling activated
[  254.565382] r3964: Philips r3964 Driver $Revision: 1.10 $
[  254.581353] Serial: 8250/16550 driver, 4 ports, IRQ sharing disabled
[  254.719242] 00:05: ttyS0 at I/O 0x3f8 (irq =3D 4, base_baud =3D 115200) =
is a 16550A
[  254.924572] STMicroelectronics ASC driver initialized
[  254.962139] serial: Freescale lpuart driver
[  255.023301] Non-volatile memory driver v1.3
[  255.129385] smapi::smapi_init, ERROR invalid usSmapiID
[  255.132124] mwave: tp3780i::tp3780I_InitializeBoardData: Error: SMAPI is=
 not available on this machine
[  255.137359] mwave: mwavedd::mwave_init: Error: Failed to initialize boar=
d data
[  255.143243] mwave: mwavedd::mwave_init: Error: Failed to initialize
[  255.157271] SyncLink PC Card driver $Revision: 4.34 $, tty major#244
[  255.170299] Hangcheck: starting hangcheck timer 0.9.1 (tick is 180 secon=
ds, margin is 60 seconds).
[  255.175243] Hangcheck: Using getrawmonotonic().
[  255.194593] [drm] Initialized drm 1.1.0 20060810
[  255.204093] usbcore: registered new interface driver udl
[  255.228255] dummy-irq: no IRQ given.  Use irq=3DN
[  255.335383] usbcore: registered new interface driver viperboard
[  255.406358] L440GX flash mapping: failed to find PIIX4 ISA bridge, canno=
t continue
[  255.441296] platform physmap-flash.0: failed to claim resource 0
[  255.473116] slram: not enough parameters.
[  255.618347] ftl_cs: FTL header not found.
[  255.856364] ehci_hcd: USB 2.0 'Enhanced' Host Controller (EHCI) Driver
[  255.864346] ehci-pci: EHCI PCI platform driver
[  255.887241] ohci_hcd: USB 1.1 'Open' Host Controller (OHCI) Driver
[  255.890213] ohci-pci: OHCI PCI platform driver
[  255.911343] ohci-platform: OHCI generic platform driver
[  255.958197] fusbh200_hcd: FUSBH200 Host Controller (EHCI) Driver
[  255.961135] Warning! fusbh200_hcd should always be loaded before uhci_hc=
d and ohci_hcd, not after
[  255.981553] usbcore: registered new interface driver usblp
[  255.990229] usbcore: registered new interface driver cdc_wdm
[  255.998589] usbcore: registered new interface driver usbtmc
[  256.012213] usbcore: registered new interface driver mdc800
[  256.015172] mdc800: v0.7.5 (30/10/2000):USB Driver for Mustek MDC800 Dig=
ital Camera
[  256.045346] usbcore: registered new interface driver usbserial
[  256.054345] usbcore: registered new interface driver usbserial_generic
[  256.075271] usbserial: USB Serial support registered for generic
[  256.084093] usbcore: registered new interface driver ark3116
[  256.094199] usbserial: USB Serial support registered for ark3116
[  256.102289] usbcore: registered new interface driver belkin_sa
[  256.113265] usbserial: USB Serial support registered for Belkin / Peraco=
m / GoHubs USB Serial Adapter
[  256.130583] usbcore: registered new interface driver ch341
[  256.146246] usbserial: USB Serial support registered for ch341-uart
[  256.155167] usbcore: registered new interface driver cyberjack
[  256.164098] usbserial: USB Serial support registered for Reiner SCT Cybe=
rjack USB card reader
[  256.182363] usbcore: registered new interface driver cypress_m8
[  256.199247] usbserial: USB Serial support registered for DeLorme Earthma=
te USB
[  256.231203] usbserial: USB Serial support registered for HID->COM RS232 =
Adapter
[  256.264179] usbserial: USB Serial support registered for Nokia CA-42 V2 =
Adapter
[  256.280583] usbcore: registered new interface driver usb_debug
[  256.304156] usbserial: USB Serial support registered for debug
[  256.313106] usbcore: registered new interface driver digi_acceleport
[  256.322120] usbserial: USB Serial support registered for Digi 2 port USB=
 adapter
[  256.335093] usbserial: USB Serial support registered for Digi 4 port USB=
 adapter
[  256.352380] usbcore: registered new interface driver empeg
[  256.367278] usbserial: USB Serial support registered for empeg
[  256.375553] usbcore: registered new interface driver ftdi_sio
[  256.393266] usbserial: USB Serial support registered for FTDI USB Serial=
 Device
[  256.402263] usbcore: registered new interface driver ipw
[  256.411270] usbserial: USB Serial support registered for IPWireless conv=
erter
[  256.426247] usbcore: registered new interface driver ir_usb
[  256.436196] usbserial: USB Serial support registered for IR Dongle
[  256.445155] usbcore: registered new interface driver iuu_phoenix
[  256.454198] usbserial: USB Serial support registered for iuu_phoenix
[  256.463174] usbcore: registered new interface driver keyspan
[  256.472274] usbserial: USB Serial support registered for Keyspan - (with=
out firmware)
[  256.484244] usbserial: USB Serial support registered for Keyspan 1 port =
adapter
[  256.493565] usbserial: USB Serial support registered for Keyspan 2 port =
adapter
[  256.504246] usbserial: USB Serial support registered for Keyspan 4 port =
adapter
[  256.530360] usbcore: registered new interface driver mct_u232
[  256.553115] usbserial: USB Serial support registered for MCT U232
[  256.561560] usbcore: registered new interface driver mos7720
[  256.570248] usbserial: USB Serial support registered for Moschip 2 port =
adapter
[  256.585122] usbcore: registered new interface driver mos7840
[  256.594181] usbserial: USB Serial support registered for Moschip 7840/78=
20 USB Serial Driver
[  256.605359] usbcore: registered new interface driver navman
[  256.613573] usbserial: USB Serial support registered for navman
[  256.628591] usbcore: registered new interface driver omninet
[  256.643151] usbserial: USB Serial support registered for ZyXEL - omni.ne=
t lcd plus usb
[  256.669176] usbcore: registered new interface driver option
[  256.677346] usbserial: USB Serial support registered for GSM modem (1-po=
rt)
[  256.698556] usbcore: registered new interface driver pl2303
[  256.711595] usbserial: USB Serial support registered for pl2303
[  256.725332] usbcore: registered new interface driver qcaux
[  256.734378] usbserial: USB Serial support registered for qcaux
[  256.752375] usbcore: registered new interface driver quatech2
[  256.772592] usbserial: USB Serial support registered for Quatech 2nd gen=
 USB to Serial Driver
[  256.781272] usbcore: registered new interface driver safe_serial
[  256.791332] usbserial: USB Serial support registered for safe_serial
[  256.809203] usbcore: registered new interface driver sierra
[  256.817267] usbserial: USB Serial support registered for Sierra USB modem
[  256.831558] usbcore: registered new interface driver usb_serial_simple
[  256.846122] usbserial: USB Serial support registered for zio
[  256.854569] usbserial: USB Serial support registered for funsoft
[  256.875384] usbserial: USB Serial support registered for flashloader
[  256.893357] usbserial: USB Serial support registered for vivopay
[  256.914596] usbserial: USB Serial support registered for moto_modem
[  256.929572] usbserial: USB Serial support registered for hp4x
[  256.949273] usbserial: USB Serial support registered for suunto
[  256.958357] usbserial: USB Serial support registered for siemens_mpi
[  256.975354] usbcore: registered new interface driver spcp8x5
[  256.985202] usbserial: USB Serial support registered for SPCP8x5
[  256.994591] usbcore: registered new interface driver visor
[  257.013353] usbserial: USB Serial support registered for Handspring Viso=
r / Palm OS
[  257.026221] usbserial: USB Serial support registered for Sony Clie 5.0
[  257.041189] usbserial: USB Serial support registered for Sony Clie 3.5
[  257.050220] usbcore: registered new interface driver xsens_mt
[  257.058336] usbserial: USB Serial support registered for xsens_mt
[  257.067376] usbcore: registered new interface driver zte_ev
[  257.076552] usbserial: USB Serial support registered for zte_ev
[  257.092289] usbcore: registered new interface driver adutux
[  257.101249] usbcore: registered new interface driver cypress_cy7c63
[  257.110181] usbcore: registered new interface driver cytherm
[  257.119201] usbcore: registered new interface driver emi26 - firmware lo=
ader
[  257.149587] usbcore: registered new interface driver emi62 - firmware lo=
ader
[  257.154247] driver ftdi-elan
[  257.204088] usbcore: registered new interface driver ftdi-elan
[  257.221302] usbcore: registered new interface driver idmouse
[  257.230374] usbcore: registered new interface driver usblcd
[  257.239554] usbcore: registered new interface driver usbled
[  257.255363] usbcore: registered new interface driver legousbtower
[  257.270215] usbcore: registered new interface driver rio500
[  257.280229] usbcore: registered new interface driver usb_ehset_test
[  257.290208] usbcore: registered new interface driver trancevibrator
[  257.300279] usbcore: registered new interface driver usbsevseg
[  257.477263] dummy_hcd dummy_hcd.0: USB Host+Gadget Emulator, driver 02 M=
ay 2005
[  257.490204] dummy_hcd dummy_hcd.0: Dummy host controller
[  257.512288] dummy_hcd dummy_hcd.0: new USB bus registered, assigned bus =
number 1
[  257.647195] usb usb1: New USB device found, idVendor=3D1d6b, idProduct=
=3D0002
[  257.655127] usb usb1: New USB device strings: Mfr=3D3, Product=3D2, Seri=
alNumber=3D1
[  257.666153] usb usb1: Product: Dummy host controller
[  257.669558] usb usb1: Manufacturer: Linux 3.12.0-rc2-00154-g12c6060 dumm=
y_hcd
[  257.676368] usb usb1: SerialNumber: dummy_hcd.0
[  257.896601] hub 1-0:1.0: USB hub found
[  265.380163] hub 1-0:1.0: 1 port detected
[  265.698335] udc dummy_udc.0: registering UDC driver [g_audio]
[  265.713267] g_audio gadget: adding config #1 'Linux USB Audio Gadget'/ff=
ffffff81cafa80
[  265.750597] g_audio gadget: unable to open sound control device file: /d=
ev/snd/controlC0
[  265.766217] g_audio gadget: we need at least one control device
[  265.770028] g_audio gadget: cfg 1/ffffffff81cafa80 speeds:
[  265.782278] g_audio gadget: Linux USB Audio Gadget, version: Feb 2, 2012
[  265.789182] g_audio gadget: g_audio ready
[  265.799105] dummy_udc dummy_udc.0: binding gadget driver 'g_audio'
[  265.814292] dummy_hcd dummy_hcd.0: port status 0x00010101 has changes
[  265.829337] dummy_hcd dummy_hcd.0: port status 0x00010101 has changes
[  265.897126] i8042: PNP: PS/2 Controller [PNP0303:KBD,PNP0f13:MOU] at 0x6=
0,0x64 irq 1,12
[  266.051613] serio: i8042 KBD port at 0x60,0x64 irq 1
[  266.065271] serio: i8042 AUX port at 0x60,0x64 irq 12
[  266.100796] g_audio gadget: resume
[  266.119225] dummy_hcd dummy_hcd.0: port status 0x00100503 has changes
[  266.215117] usb 1-1: new high-speed USB device number 2 using dummy_hcd
[  266.296283] mousedev: PS/2 mouse device common for all mice
[  266.310611] g_audio gadget: resume
[  266.315342] dummy_hcd dummy_hcd.0: port status 0x00100503 has changes
[  266.341208] evbug: Connected device: input0 (Power Button at LNXPWRBN/bu=
tton/input0)
[  266.390253] dummy_udc dummy_udc.0: set_address =3D 2
[  266.478500] usb 1-1: no configurations
[  266.481989] usb 1-1: can't read configurations, error -22
[  266.486113] g_audio gadget: suspend
[  266.520970] input: AT Translated Set 2 keyboard as /devices/platform/i80=
42/serio0/input/input1
[  266.537210] evbug: Connected device: input1 (AT Translated Set 2 keyboar=
d at isa0060/serio0/input0)
[  266.553203] g_audio gadget: resume
[  266.554191] dummy_hcd dummy_hcd.0: port status 0x00100503 has changes
[  266.567254] mk712: device not present
[  266.570524] usbcore: registered new interface driver usbtouchscreen
[  266.602510] rtc_cmos 00:00: RTC can wake from S4
[  266.609855] usb 1-1: new high-speed USB device number 3 using dummy_hcd
[  266.621015] rtc (null): alarm rollover: day
[  266.630096] rtc_cmos 00:00: rtc core: registered rtc_cmos as rtc0
[  266.634971] rtc_cmos 00:00: alarms up to one day, 114 bytes nvram, hpet =
irqs
[  266.665204] g_audio gadget: resume
[  266.666281] dummy_hcd dummy_hcd.0: port status 0x00100503 has changes
[  266.703053] rtc-test rtc-test.0: rtc core: registered test as rtc1
[  266.717290] rtc-test rtc-test.1: rtc core: registered test as rtc2
[  266.726903] dummy_udc dummy_udc.0: set_address =3D 3
[  266.744295] usb 1-1: no configurations
[  266.758281] usb 1-1: can't read configurations, error -22
[  266.769364] g_audio gadget: suspend
[  266.772330] i2c /dev entries driver
[  266.814400] i2c-parport-light: adapter type unspecified
[  266.823434] usbcore: registered new interface driver i2c-tiny-usb
[  266.847327] pps pps0: new PPS source ktimer
[  266.852153] pps pps0: ktimer PPS source registered
[  266.855252] Driver for 1-wire Dallas network protocol.
[  266.864243] g_audio gadget: resume
[  266.867226] dummy_hcd dummy_hcd.0: port status 0x00100503 has changes
[  266.887280] DS1WM w1 busmaster driver - (c) 2004 Szabolcs Gyurko
[  266.907205] 1-Wire driver for the DS2760 battery monitor  chip  - (c) 20=
04-2005, Szabolcs Gyurko
[  266.944390] usb 1-1: new high-speed USB device number 4 using dummy_hcd
[  266.951899] dummy_udc dummy_udc.0: set_address =3D 4
[  266.991289] usb 1-1: no configurations
[  266.994654] usb 1-1: can't read configurations, error -22
[  266.996296] g_audio gadget: suspend
[  267.067318] g_audio gadget: resume
[  267.073354] dummy_hcd dummy_hcd.0: port status 0x00100503 has changes
[  267.138290] usb 1-1: new high-speed USB device number 5 using dummy_hcd
[  267.144177] dummy_udc dummy_udc.0: set_address =3D 5
[  267.182202] f71882fg: Not a Fintek device
[  267.186206] usb 1-1: no configurations
[  267.187902] usb 1-1: can't read configurations, error -22
[  267.191198] f71882fg: Not a Fintek device
[  267.195398] g_audio gadget: suspend
[  267.205257] hub 1-0:1.0: unable to enumerate USB device on port 1
[  267.362042] sch56xx_common: Unsupported device id: 0xff
[  267.363382] sch56xx_common: Unsupported device id: 0xff
[  267.382939] usbcore: registered new interface driver pcwd_usb
[  267.384047] acquirewdt: WDT driver for Acquire single board computer ini=
tialising
[  267.396035] acquirewdt: I/O address 0x0043 already in use
[  267.397993] acquirewdt: probe of acquirewdt failed with error -5
[  267.403138] sc520_wdt: WDT driver for SC520 initialised. timeout=3D30 se=
c (nowayout=3D1)
[  267.404887] ib700wdt: WDT driver for IB700 single board computer initial=
ising
[  267.416357] ib700wdt: failed to register misc device
[  267.418254] ib700wdt: probe of ib700wdt failed with error -16
[  267.420029] wafer5823wdt: WDT driver for Wafer 5823 single board compute=
r initialising
[  267.422076] wafer5823wdt: cannot register miscdev on minor=3D130 (err=3D=
-16)
[  267.425980] sc1200wdt: build 20020303
[  267.428287] sc1200wdt: io parameter must be specified
[  267.431204] pc87413_wdt: Version 1.1 at io 0x2E
[  267.432523] pc87413_wdt: cannot register miscdev on minor=3D130 (err=3D-=
16)
[  267.435017] sbc60xxwdt: cannot register miscdev on minor=3D130 (err=3D-1=
6)
[  267.436960] sbc8360: failed to register misc device
[  267.438794] cpu5wdt: misc_register failed
[  267.439495] w83697ug_wdt: WDT driver for the Winbond(TM) W83697UG/UF Sup=
er I/O chip initialising
[  267.441021] w83697ug_wdt: No W83697UG/UF could be found
[  267.442984] w83877f_wdt: cannot register miscdev on minor=3D130 (err=3D-=
16)
[  267.444343] w83977f_wdt: driver v1.00
[  267.446068] w83977f_wdt: cannot register miscdev on minor=3D130 (err=3D-=
16)
[  267.447945] sbc_epx_c3: cannot register miscdev on minor=3D130 (err=3D-1=
6)
[  267.455906] watchdog: Software Watchdog: cannot register miscdev on mino=
r=3D130 (err=3D-16).
[  267.457356] watchdog: Software Watchdog: a legacy watchdog module is pro=
bably present.
[  267.474798] softdog: Software Watchdog Timer: 0.08 initialized. soft_nob=
oot=3D0 soft_margin=3D60 sec soft_panic=3D0 (nowayout=3D1)
[  267.494000] sdhci: Secure Digital Host Controller Interface driver
[  267.497554] sdhci: Copyright(c) Pierre Ossman
[  267.499025] VUB300 Driver rom wait states =3D 1C irqpoll timeout =3D 0400
[  267.529525] usbcore: registered new interface driver vub300
[  267.535523] usbcore: registered new interface driver ushc
[  267.537083] sdhci-pltfm: SDHCI platform and OF driver helper
[  267.602219] ledtrig-cpu: registered to indicate activity on CPUs
[  267.656654] BUG: unable to handle kernel NULL pointer dereference at 000=
0000000000248
[  267.656689] IP: [<ffffffff810073c9>] dma_supported+0x9/0xa0
[  267.656689] PGD 0=20
[  267.656689] Oops: 0000 [#1] PREEMPT=20
[  267.656689] CPU: 0 PID: 1 Comm: swapper Not tainted 3.12.0-rc2-00154-g12=
c6060 #3
[  267.656689] Hardware name: Bochs Bochs, BIOS Bochs 01/01/2011
[  267.656689] task: ffff88000d868000 ti: ffff88000d864000 task.ti: ffff880=
00d864000
[  267.656689] RIP: 0010:[<ffffffff810073c9>]  [<ffffffff810073c9>] dma_sup=
ported+0x9/0xa0
[  267.656689] RSP: 0000:ffff88000d865cb0  EFLAGS: 00000202
[  267.656689] RAX: ffffffff814c0b90 RBX: 00000000fffffffb RCX: 00000000000=
00001
[  267.656689] RDX: 0000000000000780 RSI: 00000000ffffffff RDI: 00000000000=
00010
[  267.656689] RBP: ffff88000d865cb0 R08: 0000000000000001 R09: 00000000000=
00001
[  267.656689] R10: 0000000000000000 R11: 0000000000000000 R12: 00000000000=
00000
[  267.656689] R13: ffff88000f5eb400 R14: ffffffff81c85240 R15: 00000000000=
00000
[  267.656689] FS:  0000000000000000(0000) GS:ffffffff81a6b000(0000) knlGS:=
0000000000000000
[  267.656689] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[  267.656689] CR2: 0000000000000248 CR3: 0000000001a5c000 CR4: 00000000000=
006b0
[  267.656689] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 00000000000=
00000
[  267.656689] DR3: 0000000000000000 DR6: 0000000000000000 DR7: 00000000000=
00000
[  267.656689] Stack:
[  267.656689]  ffff88000d865cd8 ffffffff816878d6 ffff88000f5eb410 ffffffff=
81d00128
[  267.656689]  ffff88000f5eb400 ffff88000d865d08 ffffffff814c0bce ffffffff=
814bf06e
[  267.656689]  ffff88000f5eb410 ffff88000f5eb410 ffffffff81d00128 ffff8800=
0d865d30
[  267.656689] Call Trace:
[  267.656689]  [<ffffffff816878d6>] dcdbas_probe+0x46/0xb0
[  267.656689]  [<ffffffff814c0bce>] platform_drv_probe+0x3e/0x70
[  267.656689]  [<ffffffff814bf06e>] ? driver_sysfs_add+0x6e/0xa0
[  267.656689]  [<ffffffff814bf495>] really_probe+0xc5/0x1e0
[  267.656689]  [<ffffffff814bf5d0>] ? driver_probe_device+0x20/0x20
[  267.656689]  [<ffffffff814bf625>] __device_attach+0x55/0x70
[  267.656689]  [<ffffffff814bdc6e>] bus_for_each_drv+0x5e/0xb0
[  267.656689]  [<ffffffff814bf328>] device_attach+0x78/0x90
[  267.656689]  [<ffffffff814bdee5>] bus_probe_device+0x35/0xd0
[  267.656689]  [<ffffffff814bbafd>] device_add+0x4ad/0x720
[  267.656689]  [<ffffffff814c11f0>] platform_device_add+0x180/0x210
[  267.656689]  [<ffffffff814c14a0>] platform_device_register_full+0xb0/0x1=
10
[  267.656689]  [<ffffffff81d57880>] ? dcdrbu_init+0x15a/0x15a
[  267.656689]  [<ffffffff81d578a6>] dcdbas_init+0x26/0x51
[  267.656689]  [<ffffffff81d23e62>] do_one_initcall+0x7d/0x115
[  267.656689]  [<ffffffff81d2403d>] kernel_init_freeable+0x143/0x1cf
[  267.656689]  [<ffffffff81d23831>] ? do_early_param+0x8a/0x8a
[  267.656689]  [<ffffffff8174da90>] ? rest_init+0xc0/0xc0
[  267.656689]  [<ffffffff8174da99>] kernel_init+0x9/0x170
[  267.656689]  [<ffffffff817623ca>] ret_from_fork+0x7a/0xb0
[  267.656689]  [<ffffffff8174da90>] ? rest_init+0xc0/0xc0
[  267.656689] Code: 0c 48 0f bd c6 8d 70 01 e8 05 24 0f 00 48 8b 5d f0 4c =
8b 65 f8 c9 c3 66 66 2e 0f 1f 84 00 00 00 00 00 55 48 85 ff 48 89 e5 74 0c =
<48> 8b 87 38 02 00 00 48 85 c0 75 0b 48 8b 05 3c e0 a5 00 0f 1f=20
[  267.656689] RIP  [<ffffffff810073c9>] dma_supported+0x9/0xa0
[  267.656689]  RSP <ffff88000d865cb0>
[  267.656689] CR2: 0000000000000248
[  267.751209] ---[ end trace a1914743e6b14bdd ]---
[  267.753573] Kernel panic - not syncing: Attempted to kill init! exitcode=
=3D0x00000009
[  267.753573]=20
[  267.753573] Rebooting in 10 seconds..
BUG: kernel boot oops
Elapsed time: 285
qemu-system-x86_64 -kernel /kernel/x86_64-randconfig-c8-0924/12c6060d138009=
8bb69fad0c26200557d0763355/vmlinuz-3.12.0-rc2-00154-g12c6060 -append 'hung_=
task_panic=3D1 rcutree.rcu_cpu_stall_timeout=3D100 log_buf_len=3D8M ignore_=
loglevel debug sched_debug apic=3Ddebug dynamic_printk sysrq_always_enabled=
 panic=3D10  prompt_ramdisk=3D0 console=3DttyS0,115200 console=3Dtty0 vga=
=3Dnormal  root=3D/dev/ram0 rw link=3D/kernel-tests/run-queue/kvm/x86_64-ra=
ndconfig-c8-0924/devel-cairo-x86_64-201309240752/.vmlinuz-12c6060d1380098bb=
69fad0c26200557d0763355-20130924080006-9-ant branch=3Dlinux-devel/devel-cai=
ro-x86_64-201309240752 BOOT_IMAGE=3D/kernel/x86_64-randconfig-c8-0924/12c60=
60d1380098bb69fad0c26200557d0763355/vmlinuz-3.12.0-rc2-00154-g12c6060 noapi=
c nolapic nohz=3Doff'  -initrd /kernel-tests/initrd/quantal-core-x86_64.cgz=
 -m 256M -smp 2 -net nic,vlan=3D0,macaddr=3D00:00:00:00:00:00,model=3Dvirti=
o -net user,vlan=3D0,hostfwd=3Dtcp::20439-:22 -net nic,vlan=3D1,model=3De10=
00 -net user,vlan=3D1 -boot order=3Dnc -no-reboot -watchdog i6300esb -drive=
 file=3D/fs/sdc1/disk0-ant-16343,media=3Ddisk,if=3Dvirtio -drive file=3D/fs=
/sdc1/disk1-ant-16343,media=3Ddisk,if=3Dvirtio -drive file=3D/fs/sdc1/disk2=
-ant-16343,media=3Ddisk,if=3Dvirtio -drive file=3D/fs/sdc1/disk3-ant-16343,=
media=3Ddisk,if=3Dvirtio -drive file=3D/fs/sdc1/disk4-ant-16343,media=3Ddis=
k,if=3Dvirtio -drive file=3D/fs/sdc1/disk5-ant-16343,media=3Ddisk,if=3Dvirt=
io -pidfile /dev/shm/kboot/pid-ant-lkp-16343 -serial file:/dev/shm/kboot/se=
rial-ant-lkp-16343 -daemonize -display none -monitor null=20

--yrj/dFKFPuw6o+aM
Content-Type: application/octet-stream
Content-Disposition: attachment; filename="bisect-12c6060d1380098bb69fad0c26200557d0763355-x86_64-randconfig-c8-0924-BUG:-unable-to-handle-kernel-NULL-pointer-dereference-at-90445.log"
Content-Transfer-Encoding: base64

Z2l0IGNoZWNrb3V0IDRhMTBjMmFjMmYzNjg1ODMxMzhiNzc0Y2E0MWZhYzQyMDc5MTE5ODMK
UHJldmlvdXMgSEVBRCBwb3NpdGlvbiB3YXMgMTJjNjA2MC4uLiBNZXJnZSByZW1vdGUtdHJh
Y2tpbmcgYnJhbmNoICdhcm0tc29jL3RvLWJ1aWxkJyBpbnRvIGtidWlsZF90bXAKSEVBRCBp
cyBub3cgYXQgNGExMGMyYS4uLiBMaW51eCAzLjEyLXJjMgpscyAtYSAva2VybmVsLXRlc3Rz
L3J1bi1xdWV1ZS9rdm0veDg2XzY0LXJhbmRjb25maWctYzgtMDkyNC9saW51eC1kZXZlbDpk
ZXZlbC1jYWlyby14ODZfNjQtMjAxMzA5MjQwNzUyOjRhMTBjMmFjMmYzNjg1ODMxMzhiNzc0
Y2E0MWZhYzQyMDc5MTE5ODM6YmlzZWN0LW5ldAoKMjAxMy0xMC0wMi0yMjoyMDozMiA0YTEw
YzJhYzJmMzY4NTgzMTM4Yjc3NGNhNDFmYWM0MjA3OTExOTgzIHJldXNlIC9rZXJuZWwveDg2
XzY0LXJhbmRjb25maWctYzgtMDkyNC80YTEwYzJhYzJmMzY4NTgzMTM4Yjc3NGNhNDFmYWM0
MjA3OTExOTgzL3ZtbGludXotMy4xMi4wLXJjMgoKMjAxMy0xMC0wMi0yMjoyMDozMiBkZXRl
Y3RpbmcgYm9vdCBzdGF0ZSAuLi4uLi4uLi4uLi4JMS4uLgkyLi4JNAk1CTYJMTIuCTE2CTIw
CTI2CTMwCTM2CTQxLi4uLi4uLi4uLi4uLi4uLgk0Mi4uLi4uCTQzLi4uLi4uLi4uLi4uLi4u
Li4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4u
Li4uLi4uCTQ0Lgk0NS4uLi4uLi4uLi4JNDcuCTQ4Lgk0OQk1MQk1NAk1Ni4uLi4uLi4uLi4u
Li4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4u
Li4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4u
Li4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4u
Li4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4u
Li4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4u
Li4uLi4uLi4uLi4uLi4uLi4uLi4bWzE7MzVtYWRkX3RvX3J1bl9xdWV1ZSA0G1swbQouCTU3
CTU4Li4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4u
Li4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4u
Li4uLi4uLi4uLi4uLgk1OS4JNjAgU1VDQ0VTUwoKYmlzZWN0OiBnb29kIGNvbW1pdCA0YTEw
YzJhYzJmMzY4NTgzMTM4Yjc3NGNhNDFmYWM0MjA3OTExOTgzCmdpdCBiaXNlY3Qgc3RhcnQg
MTJjNjA2MGQxMzgwMDk4YmI2OWZhZDBjMjYyMDA1NTdkMDc2MzM1NSA0YTEwYzJhYzJmMzY4
NTgzMTM4Yjc3NGNhNDFmYWM0MjA3OTExOTgzIC0tClByZXZpb3VzIEhFQUQgcG9zaXRpb24g
d2FzIDRhMTBjMmEuLi4gTGludXggMy4xMi1yYzIKU3dpdGNoZWQgdG8gYnJhbmNoICdtYXN0
ZXInCllvdXIgYnJhbmNoIGlzIGJlaGluZCAnb3JpZ2luL21hc3RlcicgYnkgNDEyMTMgY29t
bWl0cywgYW5kIGNhbiBiZSBmYXN0LWZvcndhcmRlZC4KICAodXNlICJnaXQgcHVsbCIgdG8g
dXBkYXRlIHlvdXIgbG9jYWwgYnJhbmNoKQpCaXNlY3Rpbmc6IDczIHJldmlzaW9ucyBsZWZ0
IHRvIHRlc3QgYWZ0ZXIgdGhpcyAocm91Z2hseSA2IHN0ZXBzKQpbNWRkMTZkZjA5NDlhNzNh
M2RmZDdiZmI5NzZkNjhkNmJhMmUwNjc2ZV0gTWVyZ2UgcmVtb3RlLXRyYWNraW5nIGJyYW5j
aCAncmN1L3JjdS9maXhlcycgaW50byBrYnVpbGRfdG1wCmdpdCBiaXNlY3QgcnVuIC9jL2tl
cm5lbC10ZXN0cy9iaXNlY3QtdGVzdC1ib290LWZhaWx1cmUuc2ggL2hvbWUvd2ZnL25ldC9v
YmotYmlzZWN0CnJ1bm5pbmcgL2Mva2VybmVsLXRlc3RzL2Jpc2VjdC10ZXN0LWJvb3QtZmFp
bHVyZS5zaCAvaG9tZS93ZmcvbmV0L29iai1iaXNlY3QKbHMgLWEgL2tlcm5lbC10ZXN0cy9y
dW4tcXVldWUva3ZtL3g4Nl82NC1yYW5kY29uZmlnLWM4LTA5MjQvbGludXgtZGV2ZWw6ZGV2
ZWwtY2Fpcm8teDg2XzY0LTIwMTMwOTI0MDc1Mjo1ZGQxNmRmMDk0OWE3M2EzZGZkN2JmYjk3
NmQ2OGQ2YmEyZTA2NzZlOmJpc2VjdC1uZXQKCjIwMTMtMTAtMDMtMDM6MDg6MjcgNWRkMTZk
ZjA5NDlhNzNhM2RmZDdiZmI5NzZkNjhkNmJhMmUwNjc2ZSBjb21waWxpbmcKMjQzIHJlYWwg
IDk5NyB1c2VyICA5NCBzeXMgIDQ0OC4zNiUgY3B1IAl4ODZfNjQtcmFuZGNvbmZpZy1jOC0w
OTI0CgoyMDEzLTEwLTAzLTAzOjEyOjQ3IGRldGVjdGluZyBib290IHN0YXRlIDMuMTIuMC1y
YzItMDAwODAtZzVkZDE2ZGYuCTEJMwk0CTgJMTAJMTEJMTMJMTQJMTkJMjMuCTI3CTMyLi4u
Li4uLi4uLi4JMzMuLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4u
Li4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLgkz
NQk0MAk0Mwk0NQk0Ni4JNDgJNTAJNTMuCTU0CTU1Li4uLi4uLi4uLi4uLi4uLi4uLi4uLi4u
Li4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4u
Li4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4u
Li4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4u
Li4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4u
Li4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4u
Li4uLi4uLhtbMTszNW1hZGRfdG9fcnVuX3F1ZXVlIDUbWzBtCi4JNTYJNTkuLi4uLi4uLi4u
Li4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4u
Li4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4u
Li4uCTYwIFNVQ0NFU1MKCkJpc2VjdGluZzogMzYgcmV2aXNpb25zIGxlZnQgdG8gdGVzdCBh
ZnRlciB0aGlzIChyb3VnaGx5IDUgc3RlcHMpCls4NzA2ZmZmYTBkYTEwNWRlNDMwYWUyNDky
YzM3MzQ4YzA3NjE0MGZhXSBETUEtQVBJOiB1c2I6IHVzZSBuZXcgZG1hX2NvZXJjZV9tYXNr
X2FuZF9jb2hlcmVudCgpCnJ1bm5pbmcgL2Mva2VybmVsLXRlc3RzL2Jpc2VjdC10ZXN0LWJv
b3QtZmFpbHVyZS5zaCAvaG9tZS93ZmcvbmV0L29iai1iaXNlY3QKbHMgLWEgL2tlcm5lbC10
ZXN0cy9ydW4tcXVldWUva3ZtL3g4Nl82NC1yYW5kY29uZmlnLWM4LTA5MjQvbGludXgtZGV2
ZWw6ZGV2ZWwtY2Fpcm8teDg2XzY0LTIwMTMwOTI0MDc1Mjo4NzA2ZmZmYTBkYTEwNWRlNDMw
YWUyNDkyYzM3MzQ4YzA3NjE0MGZhOmJpc2VjdC1uZXQKCjIwMTMtMTAtMDMtMDc6NTI6Mjkg
ODcwNmZmZmEwZGExMDVkZTQzMGFlMjQ5MmMzNzM0OGMwNzYxNDBmYSBjb21waWxpbmcKMjg5
IHJlYWwgIDEwNTAgdXNlciAgOTcgc3lzICAzOTcuMjMlIGNwdSAJeDg2XzY0LXJhbmRjb25m
aWctYzgtMDkyNAoKMjAxMy0xMC0wMy0wODowMTowMyBkZXRlY3RpbmcgYm9vdCBzdGF0ZSAz
LjEyLjAtcmMxLTAwMDM3LWc4NzA2ZmZmLgkzCTYJMTAJMTYJMjkJMzgJNDQJNDYuCTQ3Li4u
Li4uLi4uLi4uLi4JNDguLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4u
Li4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4u
Li4uLgk1MC4uLi4JNTMJNTguLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4u
Li4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4u
Li4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4u
Li4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4u
Li4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4u
Li4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uG1sxOzM1
bWFkZF90b19ydW5fcXVldWUgMhtbMG0KLi4uLi4uCTU5Lgk2MCBTVUNDRVNTCgpCaXNlY3Rp
bmc6IDE4IHJldmlzaW9ucyBsZWZ0IHRvIHRlc3QgYWZ0ZXIgdGhpcyAocm91Z2hseSA0IHN0
ZXBzKQpbZjUxNmUyYzllY2RjYzcxN2QyNWZlMTUzMzgwNWE3OTYwMzEwYzE4Nl0gTWVyZ2Ug
YnJhbmNoICdibngyeCcKcnVubmluZyAvYy9rZXJuZWwtdGVzdHMvYmlzZWN0LXRlc3QtYm9v
dC1mYWlsdXJlLnNoIC9ob21lL3dmZy9uZXQvb2JqLWJpc2VjdApscyAtYSAva2VybmVsLXRl
c3RzL3J1bi1xdWV1ZS9rdm0veDg2XzY0LXJhbmRjb25maWctYzgtMDkyNC9saW51eC1kZXZl
bDpkZXZlbC1jYWlyby14ODZfNjQtMjAxMzA5MjQwNzUyOmY1MTZlMmM5ZWNkY2M3MTdkMjVm
ZTE1MzM4MDVhNzk2MDMxMGMxODY6YmlzZWN0LW5ldAoKMjAxMy0xMC0wMy0xMTo0MTo0MyBm
NTE2ZTJjOWVjZGNjNzE3ZDI1ZmUxNTMzODA1YTc5NjAzMTBjMTg2IGNvbXBpbGluZwoxNzEg
cmVhbCAgMTA1NiB1c2VyICAxMDIgc3lzICA2NzUuMzklIGNwdSAJeDg2XzY0LXJhbmRjb25m
aWctYzgtMDkyNAoKMjAxMy0xMC0wMy0xMTo0NDo0NiBkZXRlY3RpbmcgYm9vdCBzdGF0ZSAz
LjEyLjAtcmMxLTAwMjczLWdmNTE2ZTJjLi4JNwkxNQkxOAkyMwkyNwkzMQkzNAkzNS4JMzYu
Li4uLi4uLi4uCTM4Li4uLgkzOS4uLi4uLi4uLgk0MC4uLi4uLi4uLi4uLi4uLi4uLi4uLi4u
Li4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4u
Li4uLi4uCTQxCTQ0CTQ4CTUxLgk1NAk1Ngk1OQk2MCBTVUNDRVNTCgpCaXNlY3Rpbmc6IDkg
cmV2aXNpb25zIGxlZnQgdG8gdGVzdCBhZnRlciB0aGlzIChyb3VnaGx5IDMgc3RlcHMpCls1
NTg3MWVhMDU5NzRjMmJiZDMwODJiYmFlOTU0NDhlZWE3Nzc4NzNhXSBBUk06IERNQS1BUEk6
IGJldHRlciBoYW5kaW5nIG9mIERNQSBtYXNrcyBmb3IgY29oZXJlbnQgYWxsb2NhdGlvbnMK
cnVubmluZyAvYy9rZXJuZWwtdGVzdHMvYmlzZWN0LXRlc3QtYm9vdC1mYWlsdXJlLnNoIC9o
b21lL3dmZy9uZXQvb2JqLWJpc2VjdApscyAtYSAva2VybmVsLXRlc3RzL3J1bi1xdWV1ZS9r
dm0veDg2XzY0LXJhbmRjb25maWctYzgtMDkyNC9saW51eC1kZXZlbDpkZXZlbC1jYWlyby14
ODZfNjQtMjAxMzA5MjQwNzUyOjU1ODcxZWEwNTk3NGMyYmJkMzA4MmJiYWU5NTQ0OGVlYTc3
Nzg3M2E6YmlzZWN0LW5ldAoKMjAxMy0xMC0wMy0xMjo0OTo0OCA1NTg3MWVhMDU5NzRjMmJi
ZDMwODJiYmFlOTU0NDhlZWE3Nzc4NzNhIGNvbXBpbGluZwoxNjAgcmVhbCAgMTAzNyB1c2Vy
ICA5OCBzeXMgIDcwNy4xMSUgY3B1IAl4ODZfNjQtcmFuZGNvbmZpZy1jOC0wOTI0CgoyMDEz
LTEwLTAzLTEyOjUyOjM5IGRldGVjdGluZyBib290IHN0YXRlIDMuMTIuMC1yYzEtMDAwNDYt
ZzU1ODcxZWEuLi4uIFRFU1QgRkFJTFVSRQpbICAgIDEuNjExNjkyXSBzZGhjaS1wbHRmbTog
U0RIQ0kgcGxhdGZvcm0gYW5kIE9GIGRyaXZlciBoZWxwZXIKWyAgICAxLjYxMzMxN10gbGVk
dHJpZy1jcHU6IHJlZ2lzdGVyZWQgdG8gaW5kaWNhdGUgYWN0aXZpdHkgb24gQ1BVcwpbICAg
IDEuNjE0ODYyXSBCVUc6IHVuYWJsZSB0byBoYW5kbGUga2VybmVsIE5VTEwgcG9pbnRlciBk
ZXJlZmVyZW5jZSBhdCAwMDAwMDAwMDAwMDAwMjQ4ClsgICAgMS42MTU3MDhdIElQOiBbPGZm
ZmZmZmZmODEwMDczYzk+XSBkbWFfc3VwcG9ydGVkKzB4OS8weGEwClsgICAgMS42MTU3MDhd
IFBHRCAwIApbICAgIDEuNjE1NzA4XSBPb3BzOiAwMDAwIFsjMV0gUFJFRU1QVCAKWyAgICAx
LjYxNTcwOF0gQ1BVOiAwIFBJRDogMSBDb21tOiBzd2FwcGVyIE5vdCB0YWludGVkIDMuMTIu
MC1yYzEtMDAwNDYtZzU1ODcxZWEgIzI4NApbICAgIDEuNjE1NzA4XSBIYXJkd2FyZSBuYW1l
OiBCb2NocyBCb2NocywgQklPUyBCb2NocyAwMS8wMS8yMDExClsgICAgMS42MTU3MDhdIHRh
c2s6IGZmZmY4ODAwMGVjNjgwMDAgdGk6IGZmZmY4ODAwMGVjNjQwMDAgdGFzay50aTogZmZm
Zjg4MDAwZWM2NDAwMApbICAgIDEuNjE1NzA4XSBSSVA6IDAwMTA6WzxmZmZmZmZmZjgxMDA3
M2M5Pl0gIFs8ZmZmZmZmZmY4MTAwNzNjOT5dIGRtYV9zdXBwb3J0ZWQrMHg5LzB4YTAKWyAg
ICAxLjYxNTcwOF0gUlNQOiAwMDAwOmZmZmY4ODAwMGVjNjVjYjAgIEVGTEFHUzogMDAwMTAy
MDIKWyAgICAxLjYxNTcwOF0gUkFYOiBmZmZmZmZmZjgxNGMwZWIwIFJCWDogMDAwMDAwMDBm
ZmZmZmZmYiBSQ1g6IDAwMDAwMDAwMDAwMDAwMDEKWyAgICAxLjYxNTcwOF0gUkRYOiAwMDAw
MDAwMDAwMDAwNzgwIFJTSTogMDAwMDAwMDBmZmZmZmZmZiBSREk6IDAwMDAwMDAwMDAwMDAw
MTAKWyAgICAxLjYxNTcwOF0gUkJQOiBmZmZmODgwMDBlYzY1Y2IwIFIwODogMDAwMDAwMDAw
MDAwMDAwMSBSMDk6IDAwMDAwMDAwMDAwMDAwMDEKWyAgICAxLjYxNTcwOF0gUjEwOiAwMDAw
MDAwMDAwMDAwMDAwIFIxMTogMDAwMDAwMDAwMDAwMDAwMCBSMTI6IDAwMDAwMDAwMDAwMDAw
MDAKWyAgICAxLjYxNTcwOF0gUjEzOiBmZmZmODgwMDBjOWNmNDAwIFIxNDogZmZmZmZmZmY4
MWM4MTIwMCBSMTU6IDAwMDAwMDAwMDAwMDAwMDAKWyAgICAxLjYxNTcwOF0gRlM6ICAwMDAw
MDAwMDAwMDAwMDAwKDAwMDApIEdTOmZmZmZmZmZmODFhNjcwMDAoMDAwMCkga25sR1M6MDAw
MDAwMDAwMDAwMDAwMApbICAgIDEuNjE1NzA4XSBDUzogIDAwMTAgRFM6IDAwMDAgRVM6IDAw
MDAgQ1IwOiAwMDAwMDAwMDgwMDUwMDNiClsgICAgMS42MTU3MDhdIENSMjogMDAwMDAwMDAw
MDAwMDI0OCBDUjM6IDAwMDAwMDAwMDFhNTgwMDAgQ1I0OiAwMDAwMDAwMDAwMDAwNmIwClsg
ICAgMS42MTU3MDhdIFN0YWNrOgpbICAgIDEuNjE1NzA4XSAgZmZmZjg4MDAwZWM2NWNkOCBm
ZmZmZmZmZjgxNjg4MDg2IGZmZmY4ODAwMGM5Y2Y0MTAgZmZmZmZmZmY4MWNmYzBlOApbICAg
IDEuNjE1NzA4XSAgZmZmZjg4MDAwYzljZjQwMCBmZmZmODgwMDBlYzY1ZDA4IGZmZmZmZmZm
ODE0YzBlZWUgZmZmZmZmZmY4MTRiZjM4ZQpbICAgIDEuNjE1NzA4XSAgZmZmZjg4MDAwYzlj
ZjQxMCBmZmZmODgwMDBjOWNmNDEwIGZmZmZmZmZmODFjZmMwZTggZmZmZjg4MDAwZWM2NWQz
MApbICAgIDEuNjE1NzA4XSBDYWxsIFRyYWNlOgpbICAgIDEuNjE1NzA4XSAgWzxmZmZmZmZm
ZjgxNjg4MDg2Pl0gZGNkYmFzX3Byb2JlKzB4NDYvMHhiMApbICAgIDEuNjE1NzA4XSAgWzxm
ZmZmZmZmZjgxNGMwZWVlPl0gcGxhdGZvcm1fZHJ2X3Byb2JlKzB4M2UvMHg3MApbICAgIDEu
NjE1NzA4XSAgWzxmZmZmZmZmZjgxNGJmMzhlPl0gPyBkcml2ZXJfc3lzZnNfYWRkKzB4NmUv
MHhhMApbICAgIDEuNjE1NzA4XSAgWzxmZmZmZmZmZjgxNGJmN2I1Pl0gcmVhbGx5X3Byb2Jl
KzB4YzUvMHgxZTAKWyAgICAxLjYxNTcwOF0gIFs8ZmZmZmZmZmY4MTRiZjhmMD5dID8gZHJp
dmVyX3Byb2JlX2RldmljZSsweDIwLzB4MjAKWyAgICAxLjYxNTcwOF0gIFs8ZmZmZmZmZmY4
MTRiZjk0NT5dIF9fZGV2aWNlX2F0dGFjaCsweDU1LzB4NzAKWyAgICAxLjYxNTcwOF0gIFs8
ZmZmZmZmZmY4MTRiZGY4ZT5dIGJ1c19mb3JfZWFjaF9kcnYrMHg1ZS8weGIwClsgICAgMS42
MTU3MDhdICBbPGZmZmZmZmZmODE0YmY2NDg+XSBkZXZpY2VfYXR0YWNoKzB4NzgvMHg5MApb
ICAgIDEuNjE1NzA4XSAgWzxmZmZmZmZmZjgxNGJlMjA1Pl0gYnVzX3Byb2JlX2RldmljZSsw
eDM1LzB4ZDAKWyAgICAxLjYxNTcwOF0gIFs8ZmZmZmZmZmY4MTRiYmUxZD5dIGRldmljZV9h
ZGQrMHg0YWQvMHg3MjAKWyAgICAxLjYxNTcwOF0gIFs8ZmZmZmZmZmY4MTRjMTUxMD5dIHBs
YXRmb3JtX2RldmljZV9hZGQrMHgxODAvMHgyMTAKWyAgICAxLjYxNTcwOF0gIFs8ZmZmZmZm
ZmY4MTRjMTdjMD5dIHBsYXRmb3JtX2RldmljZV9yZWdpc3Rlcl9mdWxsKzB4YjAvMHgxMTAK
WyAgICAxLjYxNTcwOF0gIFs8ZmZmZmZmZmY4MWQ1MzhiNT5dID8gZGNkcmJ1X2luaXQrMHgx
NWEvMHgxNWEKWyAgICAxLjYxNTcwOF0gIFs8ZmZmZmZmZmY4MWQ1MzhkYj5dIGRjZGJhc19p
bml0KzB4MjYvMHg1MQpbICAgIDEuNjE1NzA4XSAgWzxmZmZmZmZmZjgxZDFmZTYyPl0gZG9f
b25lX2luaXRjYWxsKzB4N2QvMHgxMTUKWyAgICAxLjYxNTcwOF0gIFs8ZmZmZmZmZmY4MTA5
OWIyZD5dID8gcGFyc2VfYXJncysweDFjZC8weDJlMApbICAgIDEuNjE1NzA4XSAgWzxmZmZm
ZmZmZjgxZDIwMDNkPl0ga2VybmVsX2luaXRfZnJlZWFibGUrMHgxNDMvMHgxY2YKWyAgICAx
LjYxNTcwOF0gIFs8ZmZmZmZmZmY4MWQxZjgzMT5dID8gZG9fZWFybHlfcGFyYW0rMHg4YS8w
eDhhClsgICAgMS42MTU3MDhdICBbPGZmZmZmZmZmODE3NGUwZTA+XSA/IHJlc3RfaW5pdCsw
eGMwLzB4YzAKWyAgICAxLjYxNTcwOF0gIFs8ZmZmZmZmZmY4MTc0ZTBlOT5dIGtlcm5lbF9p
bml0KzB4OS8weDE3MApbICAgIDEuNjE1NzA4XSAgWzxmZmZmZmZmZjgxNzYyYWJhPl0gcmV0
X2Zyb21fZm9yaysweDdhLzB4YjAKWyAgICAxLjYxNTcwOF0gIFs8ZmZmZmZmZmY4MTc0ZTBl
MD5dID8gcmVzdF9pbml0KzB4YzAvMHhjMApbICAgIDEuNjE1NzA4XSBDb2RlOiAwYyA0OCAw
ZiBiZCBjNiA4ZCA3MCAwMSBlOCA2NSAyNCAwZiAwMCA0OCA4YiA1ZCBmMCA0YyA4YiA2NSBm
OCBjOSBjMyA2NiA2NiAyZSAwZiAxZiA4NCAwMCAwMCAwMCAwMCAwMCA1NSA0OCA4NSBmZiA0
OCA4OSBlNSA3NCAwYyA8NDg+IDhiIDg3IDM4IDAyIDAwIDAwIDQ4IDg1IGMwIDc1IDBiIDQ4
IDhiIDA1IDNjIGEwIGE1IDAwIDBmIDFmIApbICAgIDEuNjE1NzA4XSBSSVAgIFs8ZmZmZmZm
ZmY4MTAwNzNjOT5dIGRtYV9zdXBwb3J0ZWQrMHg5LzB4YTAKWyAgICAxLjYxNTcwOF0gIFJT
UCA8ZmZmZjg4MDAwZWM2NWNiMD4KWyAgICAxLjYxNTcwOF0gQ1IyOiAwMDAwMDAwMDAwMDAw
MjQ4ClsgICAgMS42OTc1ODFdIC0tLVsgZW5kIHRyYWNlIDFjNmZjNWNiNjYwYjY2M2UgXS0t
LQova2VybmVsL3g4Nl82NC1yYW5kY29uZmlnLWM4LTA5MjQvNTU4NzFlYTA1OTc0YzJiYmQz
MDgyYmJhZTk1NDQ4ZWVhNzc3ODczYS9kbWVzZy15b2N0by13YWltZWEtNzoyMDEzMTAwMzIw
NTAyODozLjEyLjAtcmMxLTAwMDQ2LWc1NTg3MWVhOjI4NAoKQmlzZWN0aW5nOiA0IHJldmlz
aW9ucyBsZWZ0IHRvIHRlc3QgYWZ0ZXIgdGhpcyAocm91Z2hseSAyIHN0ZXBzKQpbMDY3ZjNj
MzNjNjE4MTZjNGNiMzRmOTFmMWE3M2RiZDg2ZmU2Zjg2N10gRE1BLUFQSTogY3J5cHRvOiBy
ZW1vdmUgbGFzdCByZWZlcmVuY2VzIHRvICdzdGF0aWMgc3RydWN0IGRldmljZSAqZGV2Jwpy
dW5uaW5nIC9jL2tlcm5lbC10ZXN0cy9iaXNlY3QtdGVzdC1ib290LWZhaWx1cmUuc2ggL2hv
bWUvd2ZnL25ldC9vYmotYmlzZWN0CmxzIC1hIC9rZXJuZWwtdGVzdHMvcnVuLXF1ZXVlL2t2
bS94ODZfNjQtcmFuZGNvbmZpZy1jOC0wOTI0L2xpbnV4LWRldmVsOmRldmVsLWNhaXJvLXg4
Nl82NC0yMDEzMDkyNDA3NTI6MDY3ZjNjMzNjNjE4MTZjNGNiMzRmOTFmMWE3M2RiZDg2ZmU2
Zjg2NzpiaXNlY3QtbmV0CgoyMDEzLTEwLTAzLTEyOjU0OjQxIDA2N2YzYzMzYzYxODE2YzRj
YjM0ZjkxZjFhNzNkYmQ4NmZlNmY4NjcgY29tcGlsaW5nCjE5IHJlYWwgIDI2IHVzZXIgIDkg
c3lzICAxODMuMjUlIGNwdSAJeDg2XzY0LXJhbmRjb25maWctYzgtMDkyNAoKMjAxMy0xMC0w
My0xMjo1NTowOCBkZXRlY3RpbmcgYm9vdCBzdGF0ZSAzLjEyLjAtcmMxLTAwMDQxLWcwNjdm
M2MzLi4uLi4JMS4uLgkyCTQJNQk3CTEwCTE0CTIxCTQwLi4uLi4uLi4uLi4uLi4uLi4uLi4u
Li4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4u
Li4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uCTQzLi4JNDQJNDcJNTAJNTMJ
NTQuLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4u
Li4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4u
Li4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4u
Li4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4u
Li4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4u
Li4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uG1sxOzM1bWFkZF90b19ydW5fcXVl
dWUgNhtbMG0KLi4uCTU2Lgk1OC4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4u
Li4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4u
Li4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4JNTkuCTYwIFNVQ0NFU1MKCkJpc2VjdGlu
ZzogMiByZXZpc2lvbnMgbGVmdCB0byB0ZXN0IGFmdGVyIHRoaXMgKHJvdWdobHkgMSBzdGVw
KQpbY2Y3OTJhMjRkMTBiNjZkOTAzNTQ5ZmU5MTEwODRmZGEwY2M3OGJiOV0gRE1BLUFQSTog
ZG1hOiBlZG1hLmM6IG5vIG5lZWQgdG8gZXhwbGljaXRseSBpbml0aWFsaXplIERNQSBtYXNr
cwpydW5uaW5nIC9jL2tlcm5lbC10ZXN0cy9iaXNlY3QtdGVzdC1ib290LWZhaWx1cmUuc2gg
L2hvbWUvd2ZnL25ldC9vYmotYmlzZWN0CmxzIC1hIC9rZXJuZWwtdGVzdHMvcnVuLXF1ZXVl
L2t2bS94ODZfNjQtcmFuZGNvbmZpZy1jOC0wOTI0L2xpbnV4LWRldmVsOmRldmVsLWNhaXJv
LXg4Nl82NC0yMDEzMDkyNDA3NTI6Y2Y3OTJhMjRkMTBiNjZkOTAzNTQ5ZmU5MTEwODRmZGEw
Y2M3OGJiOTpiaXNlY3QtbmV0CgoyMDEzLTEwLTAzLTE3OjM3OjMwIGNmNzkyYTI0ZDEwYjY2
ZDkwMzU0OWZlOTExMDg0ZmRhMGNjNzhiYjkgY29tcGlsaW5nCjkxIHJlYWwgIDI3IHVzZXIg
IDggc3lzICAzOS44NSUgY3B1IAl4ODZfNjQtcmFuZGNvbmZpZy1jOC0wOTI0CgoyMDEzLTEw
LTAzLTE3OjM5OjI1IGRldGVjdGluZyBib290IHN0YXRlIDMuMTIuMC1yYzEtMDAwNDMtZ2Nm
NzkyYTIuLgk0CTkJMjAJMjYJMzAuCTMyCTMzLgkzNS4JMzgJMzkJNDEuLi4uLi4uLi4JNDMu
CTQ1Li4uLi4uLi4uLi4uLgk0Ni4uCTQ3Li4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4u
Li4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uCTQ5Lgk1
Mwk1NAk1NQk1Ny4uLgk1OQk2MCBTVUNDRVNTCgpCaXNlY3Rpbmc6IDAgcmV2aXNpb25zIGxl
ZnQgdG8gdGVzdCBhZnRlciB0aGlzIChyb3VnaGx5IDEgc3RlcCkKW2FmZjcxZTU5YjQ0MWJj
ZWYyNDVkODZlODI5MDM5NTBkNTU4MWEzYWFdIERNQS1BUEk6IGZpcm13YXJlL2dvb2dsZS9n
c21pLmM6IGF2b2lkIGRpcmVjdCBhY2Nlc3MgdG8gRE1BIG1hc2tzCnJ1bm5pbmcgL2Mva2Vy
bmVsLXRlc3RzL2Jpc2VjdC10ZXN0LWJvb3QtZmFpbHVyZS5zaCAvaG9tZS93ZmcvbmV0L29i
ai1iaXNlY3QKbHMgLWEgL2tlcm5lbC10ZXN0cy9ydW4tcXVldWUva3ZtL3g4Nl82NC1yYW5k
Y29uZmlnLWM4LTA5MjQvbGludXgtZGV2ZWw6ZGV2ZWwtY2Fpcm8teDg2XzY0LTIwMTMwOTI0
MDc1MjphZmY3MWU1OWI0NDFiY2VmMjQ1ZDg2ZTgyOTAzOTUwZDU1ODFhM2FhOmJpc2VjdC1u
ZXQKCjIwMTMtMTAtMDMtMTg6NDY6NDIgYWZmNzFlNTliNDQxYmNlZjI0NWQ4NmU4MjkwMzk1
MGQ1NTgxYTNhYSBjb21waWxpbmcKMjc5IHJlYWwgIDI4IHVzZXIgIDcgc3lzICAxMi44MSUg
Y3B1IAl4ODZfNjQtcmFuZGNvbmZpZy1jOC0wOTI0CgoyMDEzLTEwLTAzLTE4OjU0OjQxIGRl
dGVjdGluZyBib290IHN0YXRlIDMuMTIuMC1yYzEtMDAwNDUtZ2FmZjcxZTUuLiBURVNUIEZB
SUxVUkUKWyAgICAzLjYxOTkzMV0gc2RoY2ktcGx0Zm06IFNESENJIHBsYXRmb3JtIGFuZCBP
RiBkcml2ZXIgaGVscGVyClsgICAgMy42MjI5MjldIGxlZHRyaWctY3B1OiByZWdpc3RlcmVk
IHRvIGluZGljYXRlIGFjdGl2aXR5IG9uIENQVXMKWyAgICAzLjYyNTgxOV0gQlVHOiB1bmFi
bGUgdG8gaGFuZGxlIGtlcm5lbCBOVUxMIHBvaW50ZXIgZGVyZWZlcmVuY2UgYXQgMDAwMDAw
MDAwMDAwMDI0OApbICAgIDMuNjI2NzA2XSBJUDogWzxmZmZmZmZmZjgxMDA3M2M5Pl0gZG1h
X3N1cHBvcnRlZCsweDkvMHhhMApbICAgIDMuNjI2NzA2XSBQR0QgMCAKWyAgICAzLjYyNjcw
Nl0gT29wczogMDAwMCBbIzFdIFBSRUVNUFQgClsgICAgMy42MjY3MDZdIENQVTogMCBQSUQ6
IDEgQ29tbTogc3dhcHBlciBOb3QgdGFpbnRlZCAzLjEyLjAtcmMxLTAwMDQ1LWdhZmY3MWU1
ICMyODcKWyAgICAzLjYyNjcwNl0gSGFyZHdhcmUgbmFtZTogQm9jaHMgQm9jaHMsIEJJT1Mg
Qm9jaHMgMDEvMDEvMjAxMQpbICAgIDMuNjI2NzA2XSB0YXNrOiBmZmZmODgwMDBkODY4MDAw
IHRpOiBmZmZmODgwMDBkODY0MDAwIHRhc2sudGk6IGZmZmY4ODAwMGQ4NjQwMDAKWyAgICAz
LjYyNjcwNl0gUklQOiAwMDEwOls8ZmZmZmZmZmY4MTAwNzNjOT5dICBbPGZmZmZmZmZmODEw
MDczYzk+XSBkbWFfc3VwcG9ydGVkKzB4OS8weGEwClsgICAgMy42MjY3MDZdIFJTUDogMDAw
MDpmZmZmODgwMDBkODY1Y2IwICBFRkxBR1M6IDAwMDEwMjAyClsgICAgMy42MjY3MDZdIFJB
WDogZmZmZmZmZmY4MTRjMGViMCBSQlg6IDAwMDAwMDAwZmZmZmZmZmIgUkNYOiAwMDAwMDAw
MDAwMDAwMDAxClsgICAgMy42MjY3MDZdIFJEWDogMDAwMDAwMDAwMDAwMDc4MCBSU0k6IDAw
MDAwMDAwZmZmZmZmZmYgUkRJOiAwMDAwMDAwMDAwMDAwMDEwClsgICAgMy42MjY3MDZdIFJC
UDogZmZmZjg4MDAwZDg2NWNiMCBSMDg6IDAwMDAwMDAwMDAwMDAwMDEgUjA5OiAwMDAwMDAw
MDAwMDAwMDAxClsgICAgMy42MjY3MDZdIFIxMDogMDAwMDAwMDAwMDAwMDAwMCBSMTE6IDAw
MDAwMDAwMDAwMDAwMDAgUjEyOiAwMDAwMDAwMDAwMDAwMDAwClsgICAgMy42MjY3MDZdIFIx
MzogZmZmZjg4MDAwZjYyMzQwMCBSMTQ6IGZmZmZmZmZmODFjODEyMDAgUjE1OiAwMDAwMDAw
MDAwMDAwMDAwClsgICAgMy42MjY3MDZdIEZTOiAgMDAwMDAwMDAwMDAwMDAwMCgwMDAwKSBH
UzpmZmZmZmZmZjgxYTY3MDAwKDAwMDApIGtubEdTOjAwMDAwMDAwMDAwMDAwMDAKWyAgICAz
LjYyNjcwNl0gQ1M6ICAwMDEwIERTOiAwMDAwIEVTOiAwMDAwIENSMDogMDAwMDAwMDA4MDA1
MDAzYgpbICAgIDMuNjI2NzA2XSBDUjI6IDAwMDAwMDAwMDAwMDAyNDggQ1IzOiAwMDAwMDAw
MDAxYTU4MDAwIENSNDogMDAwMDAwMDAwMDAwMDZiMApbICAgIDMuNjI2NzA2XSBTdGFjazoK
WyAgICAzLjYyNjcwNl0gIGZmZmY4ODAwMGQ4NjVjZDggZmZmZmZmZmY4MTY4ODA4NiBmZmZm
ODgwMDBmNjIzNDEwIGZmZmZmZmZmODFjZmMwZTgKWyAgICAzLjYyNjcwNl0gIGZmZmY4ODAw
MGY2MjM0MDAgZmZmZjg4MDAwZDg2NWQwOCBmZmZmZmZmZjgxNGMwZWVlIGZmZmZmZmZmODE0
YmYzOGUKWyAgICAzLjYyNjcwNl0gIGZmZmY4ODAwMGY2MjM0MTAgZmZmZjg4MDAwZjYyMzQx
MCBmZmZmZmZmZjgxY2ZjMGU4IGZmZmY4ODAwMGQ4NjVkMzAKWyAgICAzLjYyNjcwNl0gQ2Fs
bCBUcmFjZToKWyAgICAzLjYyNjcwNl0gIFs8ZmZmZmZmZmY4MTY4ODA4Nj5dIGRjZGJhc19w
cm9iZSsweDQ2LzB4YjAKWyAgICAzLjYyNjcwNl0gIFs8ZmZmZmZmZmY4MTRjMGVlZT5dIHBs
YXRmb3JtX2Rydl9wcm9iZSsweDNlLzB4NzAKWyAgICAzLjYyNjcwNl0gIFs8ZmZmZmZmZmY4
MTRiZjM4ZT5dID8gZHJpdmVyX3N5c2ZzX2FkZCsweDZlLzB4YTAKWyAgICAzLjYyNjcwNl0g
IFs8ZmZmZmZmZmY4MTRiZjdiNT5dIHJlYWxseV9wcm9iZSsweGM1LzB4MWUwClsgICAgMy42
MjY3MDZdICBbPGZmZmZmZmZmODE0YmY4ZjA+XSA/IGRyaXZlcl9wcm9iZV9kZXZpY2UrMHgy
MC8weDIwClsgICAgMy42MjY3MDZdICBbPGZmZmZmZmZmODE0YmY5NDU+XSBfX2RldmljZV9h
dHRhY2grMHg1NS8weDcwClsgICAgMy42MjY3MDZdICBbPGZmZmZmZmZmODE0YmRmOGU+XSBi
dXNfZm9yX2VhY2hfZHJ2KzB4NWUvMHhiMApbICAgIDMuNjI2NzA2XSAgWzxmZmZmZmZmZjgx
NGJmNjQ4Pl0gZGV2aWNlX2F0dGFjaCsweDc4LzB4OTAKWyAgICAzLjYyNjcwNl0gIFs8ZmZm
ZmZmZmY4MTRiZTIwNT5dIGJ1c19wcm9iZV9kZXZpY2UrMHgzNS8weGQwClsgICAgMy42MjY3
MDZdICBbPGZmZmZmZmZmODE0YmJlMWQ+XSBkZXZpY2VfYWRkKzB4NGFkLzB4NzIwClsgICAg
My42MjY3MDZdICBbPGZmZmZmZmZmODE0YzE1MTA+XSBwbGF0Zm9ybV9kZXZpY2VfYWRkKzB4
MTgwLzB4MjEwClsgICAgMy42MjY3MDZdICBbPGZmZmZmZmZmODE0YzE3YzA+XSBwbGF0Zm9y
bV9kZXZpY2VfcmVnaXN0ZXJfZnVsbCsweGIwLzB4MTEwClsgICAgMy42MjY3MDZdICBbPGZm
ZmZmZmZmODFkNTM4YjU+XSA/IGRjZHJidV9pbml0KzB4MTVhLzB4MTVhClsgICAgMy42MjY3
MDZdICBbPGZmZmZmZmZmODFkNTM4ZGI+XSBkY2RiYXNfaW5pdCsweDI2LzB4NTEKWyAgICAz
LjYyNjcwNl0gIFs8ZmZmZmZmZmY4MWQxZmU2Mj5dIGRvX29uZV9pbml0Y2FsbCsweDdkLzB4
MTE1ClsgICAgMy42MjY3MDZdICBbPGZmZmZmZmZmODEwOTliMmQ+XSA/IHBhcnNlX2FyZ3Mr
MHgxY2QvMHgyZTAKWyAgICAzLjYyNjcwNl0gIFs8ZmZmZmZmZmY4MWQyMDAzZD5dIGtlcm5l
bF9pbml0X2ZyZWVhYmxlKzB4MTQzLzB4MWNmClsgICAgMy42MjY3MDZdICBbPGZmZmZmZmZm
ODFkMWY4MzE+XSA/IGRvX2Vhcmx5X3BhcmFtKzB4OGEvMHg4YQpbICAgIDMuNjI2NzA2XSAg
WzxmZmZmZmZmZjgxNzRlMGUwPl0gPyByZXN0X2luaXQrMHhjMC8weGMwClsgICAgMy42MjY3
MDZdICBbPGZmZmZmZmZmODE3NGUwZTk+XSBrZXJuZWxfaW5pdCsweDkvMHgxNzAKWyAgICAz
LjYyNjcwNl0gIFs8ZmZmZmZmZmY4MTc2MmFiYT5dIHJldF9mcm9tX2ZvcmsrMHg3YS8weGIw
ClsgICAgMy42MjY3MDZdICBbPGZmZmZmZmZmODE3NGUwZTA+XSA/IHJlc3RfaW5pdCsweGMw
LzB4YzAKWyAgICAzLjYyNjcwNl0gQ29kZTogMGMgNDggMGYgYmQgYzYgOGQgNzAgMDEgZTgg
NjUgMjQgMGYgMDAgNDggOGIgNWQgZjAgNGMgOGIgNjUgZjggYzkgYzMgNjYgNjYgMmUgMGYg
MWYgODQgMDAgMDAgMDAgMDAgMDAgNTUgNDggODUgZmYgNDggODkgZTUgNzQgMGMgPDQ4PiA4
YiA4NyAzOCAwMiAwMCAwMCA0OCA4NSBjMCA3NSAwYiA0OCA4YiAwNSAzYyBhMCBhNSAwMCAw
ZiAxZiAKWyAgICAzLjYyNjcwNl0gUklQICBbPGZmZmZmZmZmODEwMDczYzk+XSBkbWFfc3Vw
cG9ydGVkKzB4OS8weGEwClsgICAgMy42MjY3MDZdICBSU1AgPGZmZmY4ODAwMGQ4NjVjYjA+
ClsgICAgMy42MjY3MDZdIENSMjogMDAwMDAwMDAwMDAwMDI0OApbICAgIDMuNzgyNjc5XSAt
LS1bIGVuZCB0cmFjZSBjM2E5OTA4MzM0OGQ4ZmEzIF0tLS0KL2tlcm5lbC94ODZfNjQtcmFu
ZGNvbmZpZy1jOC0wOTI0L2FmZjcxZTU5YjQ0MWJjZWYyNDVkODZlODI5MDM5NTBkNTU4MWEz
YWEvZG1lc2ctcXVhbnRhbC1jYWlyby01OjIwMTMxMDAzMTg1NTAxOjMuMTIuMC1yYzEtMDAw
NDUtZ2FmZjcxZTU6Mjg3Ci9rZXJuZWwveDg2XzY0LXJhbmRjb25maWctYzgtMDkyNC9hZmY3
MWU1OWI0NDFiY2VmMjQ1ZDg2ZTgyOTAzOTUwZDU1ODFhM2FhL2RtZXNnLXF1YW50YWwtbGtw
LXN0MDEtMTE6MjAxMzEwMDMxODU1MzM6My4xMi4wLXJjMS0wMDA0NS1nYWZmNzFlNToyODcK
CkJpc2VjdGluZzogMCByZXZpc2lvbnMgbGVmdCB0byB0ZXN0IGFmdGVyIHRoaXMgKHJvdWdo
bHkgMCBzdGVwcykKWzI3MTNjOTk0MzhiMDBkNjdiNGJkODhlYWY5NzEzYzg2NDVjOGRhZjdd
IERNQS1BUEk6IGRjZGJhczogdXBkYXRlIERNQSBtYXNrIGhhbmRpbmcKcnVubmluZyAvYy9r
ZXJuZWwtdGVzdHMvYmlzZWN0LXRlc3QtYm9vdC1mYWlsdXJlLnNoIC9ob21lL3dmZy9uZXQv
b2JqLWJpc2VjdApscyAtYSAva2VybmVsLXRlc3RzL3J1bi1xdWV1ZS9rdm0veDg2XzY0LXJh
bmRjb25maWctYzgtMDkyNC9saW51eC1kZXZlbDpkZXZlbC1jYWlyby14ODZfNjQtMjAxMzA5
MjQwNzUyOjI3MTNjOTk0MzhiMDBkNjdiNGJkODhlYWY5NzEzYzg2NDVjOGRhZjc6YmlzZWN0
LW5ldAoKMjAxMy0xMC0wMy0xODo1NTo0NSAyNzEzYzk5NDM4YjAwZDY3YjRiZDg4ZWFmOTcx
M2M4NjQ1YzhkYWY3IGNvbXBpbGluZwozOCByZWFsICAzMCB1c2VyICA3IHN5cyAgOTYuNTUl
IGNwdSAJeDg2XzY0LXJhbmRjb25maWctYzgtMDkyNAoKMjAxMy0xMC0wMy0xODo1NzowNiBk
ZXRlY3RpbmcgYm9vdCBzdGF0ZSAzLjEyLjAtcmMxLTAwMDQ0LWcyNzEzYzk5LiBURVNUIEZB
SUxVUkUKWyAgICAzLjk1MTY1NF0gc2RoY2ktcGx0Zm06IFNESENJIHBsYXRmb3JtIGFuZCBP
RiBkcml2ZXIgaGVscGVyClsgICAgMy45NTQyMDZdIGxlZHRyaWctY3B1OiByZWdpc3RlcmVk
IHRvIGluZGljYXRlIGFjdGl2aXR5IG9uIENQVXMKWyAgICAzLjk1NjY1N10gQlVHOiB1bmFi
bGUgdG8gaGFuZGxlIGtlcm5lbCBOVUxMIHBvaW50ZXIgZGVyZWZlcmVuY2UgYXQgMDAwMDAw
MDAwMDAwMDI0OApbICAgIDMuOTU3NDg4XSBJUDogWzxmZmZmZmZmZjgxMDA3M2M5Pl0gZG1h
X3N1cHBvcnRlZCsweDkvMHhhMApbICAgIDMuOTU3NDg4XSBQR0QgMCAKWyAgICAzLjk1NzQ4
OF0gT29wczogMDAwMCBbIzFdIFBSRUVNUFQgClsgICAgMy45NTc0ODhdIENQVTogMCBQSUQ6
IDEgQ29tbTogc3dhcHBlciBOb3QgdGFpbnRlZCAzLjEyLjAtcmMxLTAwMDQ0LWcyNzEzYzk5
ICMyODgKWyAgICAzLjk1NzQ4OF0gSGFyZHdhcmUgbmFtZTogQm9jaHMgQm9jaHMsIEJJT1Mg
Qm9jaHMgMDEvMDEvMjAxMQpbICAgIDMuOTU3NDg4XSB0YXNrOiBmZmZmODgwMDBkODY4MDAw
IHRpOiBmZmZmODgwMDBkODY0MDAwIHRhc2sudGk6IGZmZmY4ODAwMGQ4NjQwMDAKWyAgICAz
Ljk1NzQ4OF0gUklQOiAwMDEwOls8ZmZmZmZmZmY4MTAwNzNjOT5dICBbPGZmZmZmZmZmODEw
MDczYzk+XSBkbWFfc3VwcG9ydGVkKzB4OS8weGEwClsgICAgMy45NTc0ODhdIFJTUDogMDAw
MDpmZmZmODgwMDBkODY1Y2IwICBFRkxBR1M6IDAwMDEwMjAyClsgICAgMy45NTc0ODhdIFJB
WDogZmZmZmZmZmY4MTRjMGViMCBSQlg6IDAwMDAwMDAwZmZmZmZmZmIgUkNYOiAwMDAwMDAw
MDAwMDAwMDAxClsgICAgMy45NTc0ODhdIFJEWDogMDAwMDAwMDAwMDAwMDc4MCBSU0k6IDAw
MDAwMDAwZmZmZmZmZmYgUkRJOiAwMDAwMDAwMDAwMDAwMDEwClsgICAgMy45NTc0ODhdIFJC
UDogZmZmZjg4MDAwZDg2NWNiMCBSMDg6IDAwMDAwMDAwMDAwMDAwMDEgUjA5OiAwMDAwMDAw
MDAwMDAwMDAxClsgICAgMy45NTc0ODhdIFIxMDogMDAwMDAwMDAwMDAwMDAwMCBSMTE6IDAw
MDAwMDAwMDAwMDAwMDAgUjEyOiAwMDAwMDAwMDAwMDAwMDAwClsgICAgMy45NTc0ODhdIFIx
MzogZmZmZjg4MDAwZjYxNzQwMCBSMTQ6IGZmZmZmZmZmODFjODEyMDAgUjE1OiAwMDAwMDAw
MDAwMDAwMDAwClsgICAgMy45NTc0ODhdIEZTOiAgMDAwMDAwMDAwMDAwMDAwMCgwMDAwKSBH
UzpmZmZmZmZmZjgxYTY3MDAwKDAwMDApIGtubEdTOjAwMDAwMDAwMDAwMDAwMDAKWyAgICAz
Ljk1NzQ4OF0gQ1M6ICAwMDEwIERTOiAwMDAwIEVTOiAwMDAwIENSMDogMDAwMDAwMDA4MDA1
MDAzYgpbICAgIDMuOTU3NDg4XSBDUjI6IDAwMDAwMDAwMDAwMDAyNDggQ1IzOiAwMDAwMDAw
MDAxYTU4MDAwIENSNDogMDAwMDAwMDAwMDAwMDZiMApbICAgIDMuOTU3NDg4XSBTdGFjazoK
WyAgICAzLjk1NzQ4OF0gIGZmZmY4ODAwMGQ4NjVjZDggZmZmZmZmZmY4MTY4ODA4NiBmZmZm
ODgwMDBmNjE3NDEwIGZmZmZmZmZmODFjZmMwZTgKWyAgICAzLjk1NzQ4OF0gIGZmZmY4ODAw
MGY2MTc0MDAgZmZmZjg4MDAwZDg2NWQwOCBmZmZmZmZmZjgxNGMwZWVlIGZmZmZmZmZmODE0
YmYzOGUKWyAgICAzLjk1NzQ4OF0gIGZmZmY4ODAwMGY2MTc0MTAgZmZmZjg4MDAwZjYxNzQx
MCBmZmZmZmZmZjgxY2ZjMGU4IGZmZmY4ODAwMGQ4NjVkMzAKWyAgICAzLjk1NzQ4OF0gQ2Fs
bCBUcmFjZToKWyAgICAzLjk1NzQ4OF0gIFs8ZmZmZmZmZmY4MTY4ODA4Nj5dIGRjZGJhc19w
cm9iZSsweDQ2LzB4YjAKWyAgICAzLjk1NzQ4OF0gIFs8ZmZmZmZmZmY4MTRjMGVlZT5dIHBs
YXRmb3JtX2Rydl9wcm9iZSsweDNlLzB4NzAKWyAgICAzLjk1NzQ4OF0gIFs8ZmZmZmZmZmY4
MTRiZjM4ZT5dID8gZHJpdmVyX3N5c2ZzX2FkZCsweDZlLzB4YTAKWyAgICAzLjk1NzQ4OF0g
IFs8ZmZmZmZmZmY4MTRiZjdiNT5dIHJlYWxseV9wcm9iZSsweGM1LzB4MWUwClsgICAgMy45
NTc0ODhdICBbPGZmZmZmZmZmODE0YmY4ZjA+XSA/IGRyaXZlcl9wcm9iZV9kZXZpY2UrMHgy
MC8weDIwClsgICAgMy45NTc0ODhdICBbPGZmZmZmZmZmODE0YmY5NDU+XSBfX2RldmljZV9h
dHRhY2grMHg1NS8weDcwClsgICAgMy45NTc0ODhdICBbPGZmZmZmZmZmODE0YmRmOGU+XSBi
dXNfZm9yX2VhY2hfZHJ2KzB4NWUvMHhiMApbICAgIDMuOTU3NDg4XSAgWzxmZmZmZmZmZjgx
NGJmNjQ4Pl0gZGV2aWNlX2F0dGFjaCsweDc4LzB4OTAKWyAgICAzLjk1NzQ4OF0gIFs8ZmZm
ZmZmZmY4MTRiZTIwNT5dIGJ1c19wcm9iZV9kZXZpY2UrMHgzNS8weGQwClsgICAgMy45NTc0
ODhdICBbPGZmZmZmZmZmODE0YmJlMWQ+XSBkZXZpY2VfYWRkKzB4NGFkLzB4NzIwClsgICAg
My45NTc0ODhdICBbPGZmZmZmZmZmODE0YzE1MTA+XSBwbGF0Zm9ybV9kZXZpY2VfYWRkKzB4
MTgwLzB4MjEwClsgICAgMy45NTc0ODhdICBbPGZmZmZmZmZmODE0YzE3YzA+XSBwbGF0Zm9y
bV9kZXZpY2VfcmVnaXN0ZXJfZnVsbCsweGIwLzB4MTEwClsgICAgMy45NTc0ODhdICBbPGZm
ZmZmZmZmODFkNTM4YjU+XSA/IGRjZHJidV9pbml0KzB4MTVhLzB4MTVhClsgICAgMy45NTc0
ODhdICBbPGZmZmZmZmZmODFkNTM4ZGI+XSBkY2RiYXNfaW5pdCsweDI2LzB4NTEKWyAgICAz
Ljk1NzQ4OF0gIFs8ZmZmZmZmZmY4MWQxZmU2Mj5dIGRvX29uZV9pbml0Y2FsbCsweDdkLzB4
MTE1ClsgICAgMy45NTc0ODhdICBbPGZmZmZmZmZmODEwOTliMmQ+XSA/IHBhcnNlX2FyZ3Mr
MHgxY2QvMHgyZTAKWyAgICAzLjk1NzQ4OF0gIFs8ZmZmZmZmZmY4MWQyMDAzZD5dIGtlcm5l
bF9pbml0X2ZyZWVhYmxlKzB4MTQzLzB4MWNmClsgICAgMy45NTc0ODhdICBbPGZmZmZmZmZm
ODFkMWY4MzE+XSA/IGRvX2Vhcmx5X3BhcmFtKzB4OGEvMHg4YQpbICAgIDMuOTU3NDg4XSAg
WzxmZmZmZmZmZjgxNzRlMGUwPl0gPyByZXN0X2luaXQrMHhjMC8weGMwClsgICAgMy45NTc0
ODhdICBbPGZmZmZmZmZmODE3NGUwZTk+XSBrZXJuZWxfaW5pdCsweDkvMHgxNzAKWyAgICAz
Ljk1NzQ4OF0gIFs8ZmZmZmZmZmY4MTc2MmFiYT5dIHJldF9mcm9tX2ZvcmsrMHg3YS8weGIw
ClsgICAgMy45NTc0ODhdICBbPGZmZmZmZmZmODE3NGUwZTA+XSA/IHJlc3RfaW5pdCsweGMw
LzB4YzAKWyAgICAzLjk1NzQ4OF0gQ29kZTogMGMgNDggMGYgYmQgYzYgOGQgNzAgMDEgZTgg
NjUgMjQgMGYgMDAgNDggOGIgNWQgZjAgNGMgOGIgNjUgZjggYzkgYzMgNjYgNjYgMmUgMGYg
MWYgODQgMDAgMDAgMDAgMDAgMDAgNTUgNDggODUgZmYgNDggODkgZTUgNzQgMGMgPDQ4PiA4
YiA4NyAzOCAwMiAwMCAwMCA0OCA4NSBjMCA3NSAwYiA0OCA4YiAwNSAzYyBhMCBhNSAwMCAw
ZiAxZiAKWyAgICAzLjk1NzQ4OF0gUklQICBbPGZmZmZmZmZmODEwMDczYzk+XSBkbWFfc3Vw
cG9ydGVkKzB4OS8weGEwClsgICAgMy45NTc0ODhdICBSU1AgPGZmZmY4ODAwMGQ4NjVjYjA+
ClsgICAgMy45NTc0ODhdIENSMjogMDAwMDAwMDAwMDAwMDI0OApbICAgIDQuMDg1ODEwXSAt
LS1bIGVuZCB0cmFjZSBhNWQyYzI1OWJkOWZhN2M0IF0tLS0KL2tlcm5lbC94ODZfNjQtcmFu
ZGNvbmZpZy1jOC0wOTI0LzI3MTNjOTk0MzhiMDBkNjdiNGJkODhlYWY5NzEzYzg2NDVjOGRh
ZjcvZG1lc2ctcXVhbnRhbC1iZW5zLTQ6MjAxMzEwMDMxODU3MjU6My4xMi4wLXJjMS0wMDA0
NC1nMjcxM2M5OToyODgKL2tlcm5lbC94ODZfNjQtcmFuZGNvbmZpZy1jOC0wOTI0LzI3MTNj
OTk0MzhiMDBkNjdiNGJkODhlYWY5NzEzYzg2NDVjOGRhZjcvZG1lc2ctcXVhbnRhbC1sa3At
dHQwMi0xNzoyMDEzMTAwMzA5MjUyMzozLjEyLjAtcmMxLTAwMDQ0LWcyNzEzYzk5OjI4OAoK
MjcxM2M5OTQzOGIwMGQ2N2I0YmQ4OGVhZjk3MTNjODY0NWM4ZGFmNyBpcyB0aGUgZmlyc3Qg
YmFkIGNvbW1pdApjb21taXQgMjcxM2M5OTQzOGIwMGQ2N2I0YmQ4OGVhZjk3MTNjODY0NWM4
ZGFmNwpBdXRob3I6IFJ1c3NlbGwgS2luZyA8cm1rK2tlcm5lbEBhcm0ubGludXgub3JnLnVr
PgpEYXRlOiAgIFRodSBKdW4gMjcgMTQ6MTQ6NDMgMjAxMyArMDEwMAoKICAgIERNQS1BUEk6
IGRjZGJhczogdXBkYXRlIERNQSBtYXNrIGhhbmRpbmcKICAgIAogICAgZGNkYmFzIHdhcyBl
eHBsaWNpdGx5IGluaXRpYWxpemluZyBETUEgbWFza3MgdGh1c2x5OgogICAgCWRjZGJhc19w
ZGV2LT5kZXYuY29oZXJlbnRfZG1hX21hc2sgPSBETUFfQklUX01BU0soMzIpOwogICAgCWRj
ZGJhc19wZGV2LT5kZXYuZG1hX21hc2sgPSAmZGNkYmFzX3BkZXYtPmRldi5jb2hlcmVudF9k
bWFfbWFzazsKICAgIHdoaWNoIGJ5cGFzc2VzIHRoZSBhcmNoaXRlY3R1cmUgY2hlY2suICBN
b3Jlb3ZlciwgaXQgaXMgY3JlYXRpbmcgdGhlCiAgICBkY2RiYXNfcGRldiBkZXZpY2UgaXRz
ZWxmLCBhbmQgdXNpbmcgdGhlIHBsYXRmb3JtX2RldmljZV9yZWdpc3Rlcl9mdWxsKCkKICAg
IGF2b2lkcyBzb21lIG9mIHRoaXMgZXhwbGljaXQgaW5pdGlhbGl6YXRpb24uCiAgICAKICAg
IENvbnZlcnQgdGhlIGRyaXZlciB0byB1c2UgcGxhdGZvcm1fZGV2aWNlX3JlZ2lzdGVyX2Z1
bGwoKSwgYW5kIGFzIGl0CiAgICBtYWtlcyB1c2Ugb2YgY29oZXJlbnQgRE1BLCBhbHNvIGNh
bGwgZG1hX3NldF9jb2hlcmVudF9tYXNrKCkgdG8gZW5zdXJlCiAgICB0aGF0IHRoZSBhcmNo
aXRlY3R1cmUgZ2V0cyB0byBjaGVjayB0aGUgbWFzay4KICAgIAogICAgU2lnbmVkLW9mZi1i
eTogUnVzc2VsbCBLaW5nIDxybWsra2VybmVsQGFybS5saW51eC5vcmcudWs+Cgo6MDQwMDAw
IDA0MDAwMCAwZWI5ZTNiMTI2NTkzMTgyZGZjMTgzMGQzMzA3ZjdiN2VhMzZkMDRjIDJlY2Yz
ZDQ2ZjE1YTYzN2E5ZDJmN2ZkZGI1ZGY0MmVlYjYwN2MzN2IgTQlkcml2ZXJzCmJpc2VjdCBy
dW4gc3VjY2VzcwpscyAtYSAva2VybmVsLXRlc3RzL3J1bi1xdWV1ZS9rdm0veDg2XzY0LXJh
bmRjb25maWctYzgtMDkyNC9saW51eC1kZXZlbDpkZXZlbC1jYWlyby14ODZfNjQtMjAxMzA5
MjQwNzUyOmNmNzkyYTI0ZDEwYjY2ZDkwMzU0OWZlOTExMDg0ZmRhMGNjNzhiYjk6YmlzZWN0
LW5ldAoKMjAxMy0xMC0wMy0xODo1Nzo0MSBjZjc5MmEyNGQxMGI2NmQ5MDM1NDlmZTkxMTA4
NGZkYTBjYzc4YmI5IHJldXNlIC9rZXJuZWwveDg2XzY0LXJhbmRjb25maWctYzgtMDkyNC9j
Zjc5MmEyNGQxMGI2NmQ5MDM1NDlmZTkxMTA4NGZkYTBjYzc4YmI5L3ZtbGludXotMy4xMi4w
LXJjMS0wMDA0My1nY2Y3OTJhMgoKMjAxMy0xMC0wMy0xODo1Nzo0MSBkZXRlY3RpbmcgYm9v
dCBzdGF0ZSAJMQkyCTExCTE0CTE1CTE5CTIxCTI1CTI4CTI5CTMyCTMzCTM5CTQyCTQ0CTUw
Li4JNTIuCTUzCTU0CTU3CTU4Lgk2MAk2Nwk3NAk3NS4JNzYJNzguCTgwCTgxLgk4Mgk4NAk4
OAk5MC4JOTIJOTMuCTk1CTk2CTk5Li4JMTAwCTEwMQkxMDIuCTEwNC4uCTEwNQkxMDYuCTEw
NwkxMDkuLgkxMTAuLi4uCTExMi4JMTEzLi4uLi4JMTE1LgkxMTYJMTE3Li4JMTIwLgkxMjEJ
MTIyCTEyMy4uCTEyNS4JMTI2LgkxMjcuLgkxMjguLgkxMjkJMTMwLi4JMTMxCTEzMy4uLgkx
MzUuLgkxMzYuLi4uLi4uLgkxMzgJMTM5LgkxNDEJMTQyCTE0My4JMTQ1CTE0NgkxNDguCTE1
My4uCTE1NAkxNTYJMTYwCTE2Mi4JMTYzCTE2NC4uCTE2NS4uCTE2NwkxNjgJMTY5Li4uLi4u
Li4uLgkxNzAJMTcxLi4uLi4JMTcyLi4uLi4uLi4uLi4uCTE3My4uLi4uLi4uLi4JMTc0Li4u
Li4uLi4JMTc1Li4uLi4uLi4uLi4uLi4uLi4uLgkxNzYuLi4uLi4uLi4uLi4uLi4uLi4uLi4u
Li4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4u
Li4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4u
Li4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4u
Li4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4u
Li4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4u
Li4uLi4uLi4uG1sxOzM1bWFkZF90b19ydW5fcXVldWUgNBtbMG0KLgkxNzcuLi4uLi4uLi4u
Li4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4u
Li4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4u
CTE3OQkxODAgU1VDQ0VTUwoKbHMgLWEgL2tlcm5lbC10ZXN0cy9ydW4tcXVldWUva3ZtL3g4
Nl82NC1yYW5kY29uZmlnLWM4LTA5MjQvbGludXgtZGV2ZWw6ZGV2ZWwtY2Fpcm8teDg2XzY0
LTIwMTMwOTI0MDc1MjoxMmM2MDYwZDEzODAwOThiYjY5ZmFkMGMyNjIwMDU1N2QwNzYzMzU1
OmJpc2VjdC1uZXQKIFRFU1QgRkFJTFVSRQpbICAyNjcuNTM3MDgzXSBzZGhjaS1wbHRmbTog
U0RIQ0kgcGxhdGZvcm0gYW5kIE9GIGRyaXZlciBoZWxwZXIKWyAgMjY3LjYwMjIxOV0gbGVk
dHJpZy1jcHU6IHJlZ2lzdGVyZWQgdG8gaW5kaWNhdGUgYWN0aXZpdHkgb24gQ1BVcwpbICAy
NjcuNjU2NjU0XSBCVUc6IHVuYWJsZSB0byBoYW5kbGUga2VybmVsIE5VTEwgcG9pbnRlciBk
ZXJlZmVyZW5jZSBhdCAwMDAwMDAwMDAwMDAwMjQ4ClsgIDI2Ny42NTY2ODldIElQOiBbPGZm
ZmZmZmZmODEwMDczYzk+XSBkbWFfc3VwcG9ydGVkKzB4OS8weGEwClsgIDI2Ny42NTY2ODld
IFBHRCAwIApbICAyNjcuNjU2Njg5XSBPb3BzOiAwMDAwIFsjMV0gUFJFRU1QVCAKWyAgMjY3
LjY1NjY4OV0gQ1BVOiAwIFBJRDogMSBDb21tOiBzd2FwcGVyIE5vdCB0YWludGVkIDMuMTIu
MC1yYzItMDAxNTQtZzEyYzYwNjAgIzMKWyAgMjY3LjY1NjY4OV0gSGFyZHdhcmUgbmFtZTog
Qm9jaHMgQm9jaHMsIEJJT1MgQm9jaHMgMDEvMDEvMjAxMQpbICAyNjcuNjU2Njg5XSB0YXNr
OiBmZmZmODgwMDBkODY4MDAwIHRpOiBmZmZmODgwMDBkODY0MDAwIHRhc2sudGk6IGZmZmY4
ODAwMGQ4NjQwMDAKWyAgMjY3LjY1NjY4OV0gUklQOiAwMDEwOls8ZmZmZmZmZmY4MTAwNzNj
OT5dICBbPGZmZmZmZmZmODEwMDczYzk+XSBkbWFfc3VwcG9ydGVkKzB4OS8weGEwClsgIDI2
Ny42NTY2ODldIFJTUDogMDAwMDpmZmZmODgwMDBkODY1Y2IwICBFRkxBR1M6IDAwMDAwMjAy
ClsgIDI2Ny42NTY2ODldIFJBWDogZmZmZmZmZmY4MTRjMGI5MCBSQlg6IDAwMDAwMDAwZmZm
ZmZmZmIgUkNYOiAwMDAwMDAwMDAwMDAwMDAxClsgIDI2Ny42NTY2ODldIFJEWDogMDAwMDAw
MDAwMDAwMDc4MCBSU0k6IDAwMDAwMDAwZmZmZmZmZmYgUkRJOiAwMDAwMDAwMDAwMDAwMDEw
ClsgIDI2Ny42NTY2ODldIFJCUDogZmZmZjg4MDAwZDg2NWNiMCBSMDg6IDAwMDAwMDAwMDAw
MDAwMDEgUjA5OiAwMDAwMDAwMDAwMDAwMDAxClsgIDI2Ny42NTY2ODldIFIxMDogMDAwMDAw
MDAwMDAwMDAwMCBSMTE6IDAwMDAwMDAwMDAwMDAwMDAgUjEyOiAwMDAwMDAwMDAwMDAwMDAw
ClsgIDI2Ny42NTY2ODldIFIxMzogZmZmZjg4MDAwZjVlYjQwMCBSMTQ6IGZmZmZmZmZmODFj
ODUyNDAgUjE1OiAwMDAwMDAwMDAwMDAwMDAwClsgIDI2Ny42NTY2ODldIEZTOiAgMDAwMDAw
MDAwMDAwMDAwMCgwMDAwKSBHUzpmZmZmZmZmZjgxYTZiMDAwKDAwMDApIGtubEdTOjAwMDAw
MDAwMDAwMDAwMDAKWyAgMjY3LjY1NjY4OV0gQ1M6ICAwMDEwIERTOiAwMDAwIEVTOiAwMDAw
IENSMDogMDAwMDAwMDA4MDA1MDAzYgpbICAyNjcuNjU2Njg5XSBDUjI6IDAwMDAwMDAwMDAw
MDAyNDggQ1IzOiAwMDAwMDAwMDAxYTVjMDAwIENSNDogMDAwMDAwMDAwMDAwMDZiMApbICAy
NjcuNjU2Njg5XSBEUjA6IDAwMDAwMDAwMDAwMDAwMDAgRFIxOiAwMDAwMDAwMDAwMDAwMDAw
IERSMjogMDAwMDAwMDAwMDAwMDAwMApbICAyNjcuNjU2Njg5XSBEUjM6IDAwMDAwMDAwMDAw
MDAwMDAgRFI2OiAwMDAwMDAwMDAwMDAwMDAwIERSNzogMDAwMDAwMDAwMDAwMDAwMApbICAy
NjcuNjU2Njg5XSBTdGFjazoKWyAgMjY3LjY1NjY4OV0gIGZmZmY4ODAwMGQ4NjVjZDggZmZm
ZmZmZmY4MTY4NzhkNiBmZmZmODgwMDBmNWViNDEwIGZmZmZmZmZmODFkMDAxMjgKWyAgMjY3
LjY1NjY4OV0gIGZmZmY4ODAwMGY1ZWI0MDAgZmZmZjg4MDAwZDg2NWQwOCBmZmZmZmZmZjgx
NGMwYmNlIGZmZmZmZmZmODE0YmYwNmUKWyAgMjY3LjY1NjY4OV0gIGZmZmY4ODAwMGY1ZWI0
MTAgZmZmZjg4MDAwZjVlYjQxMCBmZmZmZmZmZjgxZDAwMTI4IGZmZmY4ODAwMGQ4NjVkMzAK
WyAgMjY3LjY1NjY4OV0gQ2FsbCBUcmFjZToKWyAgMjY3LjY1NjY4OV0gIFs8ZmZmZmZmZmY4
MTY4NzhkNj5dIGRjZGJhc19wcm9iZSsweDQ2LzB4YjAKWyAgMjY3LjY1NjY4OV0gIFs8ZmZm
ZmZmZmY4MTRjMGJjZT5dIHBsYXRmb3JtX2Rydl9wcm9iZSsweDNlLzB4NzAKWyAgMjY3LjY1
NjY4OV0gIFs8ZmZmZmZmZmY4MTRiZjA2ZT5dID8gZHJpdmVyX3N5c2ZzX2FkZCsweDZlLzB4
YTAKWyAgMjY3LjY1NjY4OV0gIFs8ZmZmZmZmZmY4MTRiZjQ5NT5dIHJlYWxseV9wcm9iZSsw
eGM1LzB4MWUwClsgIDI2Ny42NTY2ODldICBbPGZmZmZmZmZmODE0YmY1ZDA+XSA/IGRyaXZl
cl9wcm9iZV9kZXZpY2UrMHgyMC8weDIwClsgIDI2Ny42NTY2ODldICBbPGZmZmZmZmZmODE0
YmY2MjU+XSBfX2RldmljZV9hdHRhY2grMHg1NS8weDcwClsgIDI2Ny42NTY2ODldICBbPGZm
ZmZmZmZmODE0YmRjNmU+XSBidXNfZm9yX2VhY2hfZHJ2KzB4NWUvMHhiMApbICAyNjcuNjU2
Njg5XSAgWzxmZmZmZmZmZjgxNGJmMzI4Pl0gZGV2aWNlX2F0dGFjaCsweDc4LzB4OTAKWyAg
MjY3LjY1NjY4OV0gIFs8ZmZmZmZmZmY4MTRiZGVlNT5dIGJ1c19wcm9iZV9kZXZpY2UrMHgz
NS8weGQwClsgIDI2Ny42NTY2ODldICBbPGZmZmZmZmZmODE0YmJhZmQ+XSBkZXZpY2VfYWRk
KzB4NGFkLzB4NzIwClsgIDI2Ny42NTY2ODldICBbPGZmZmZmZmZmODE0YzExZjA+XSBwbGF0
Zm9ybV9kZXZpY2VfYWRkKzB4MTgwLzB4MjEwClsgIDI2Ny42NTY2ODldICBbPGZmZmZmZmZm
ODE0YzE0YTA+XSBwbGF0Zm9ybV9kZXZpY2VfcmVnaXN0ZXJfZnVsbCsweGIwLzB4MTEwClsg
IDI2Ny42NTY2ODldICBbPGZmZmZmZmZmODFkNTc4ODA+XSA/IGRjZHJidV9pbml0KzB4MTVh
LzB4MTVhClsgIDI2Ny42NTY2ODldICBbPGZmZmZmZmZmODFkNTc4YTY+XSBkY2RiYXNfaW5p
dCsweDI2LzB4NTEKWyAgMjY3LjY1NjY4OV0gIFs8ZmZmZmZmZmY4MWQyM2U2Mj5dIGRvX29u
ZV9pbml0Y2FsbCsweDdkLzB4MTE1ClsgIDI2Ny42NTY2ODldICBbPGZmZmZmZmZmODFkMjQw
M2Q+XSBrZXJuZWxfaW5pdF9mcmVlYWJsZSsweDE0My8weDFjZgpbICAyNjcuNjU2Njg5XSAg
WzxmZmZmZmZmZjgxZDIzODMxPl0gPyBkb19lYXJseV9wYXJhbSsweDhhLzB4OGEKWyAgMjY3
LjY1NjY4OV0gIFs8ZmZmZmZmZmY4MTc0ZGE5MD5dID8gcmVzdF9pbml0KzB4YzAvMHhjMApb
ICAyNjcuNjU2Njg5XSAgWzxmZmZmZmZmZjgxNzRkYTk5Pl0ga2VybmVsX2luaXQrMHg5LzB4
MTcwClsgIDI2Ny42NTY2ODldICBbPGZmZmZmZmZmODE3NjIzY2E+XSByZXRfZnJvbV9mb3Jr
KzB4N2EvMHhiMApbICAyNjcuNjU2Njg5XSAgWzxmZmZmZmZmZjgxNzRkYTkwPl0gPyByZXN0
X2luaXQrMHhjMC8weGMwClsgIDI2Ny42NTY2ODldIENvZGU6IDBjIDQ4IDBmIGJkIGM2IDhk
IDcwIDAxIGU4IDA1IDI0IDBmIDAwIDQ4IDhiIDVkIGYwIDRjIDhiIDY1IGY4IGM5IGMzIDY2
IDY2IDJlIDBmIDFmIDg0IDAwIDAwIDAwIDAwIDAwIDU1IDQ4IDg1IGZmIDQ4IDg5IGU1IDc0
IDBjIDw0OD4gOGIgODcgMzggMDIgMDAgMDAgNDggODUgYzAgNzUgMGIgNDggOGIgMDUgM2Mg
ZTAgYTUgMDAgMGYgMWYgClsgIDI2Ny42NTY2ODldIFJJUCAgWzxmZmZmZmZmZjgxMDA3M2M5
Pl0gZG1hX3N1cHBvcnRlZCsweDkvMHhhMApbICAyNjcuNjU2Njg5XSAgUlNQIDxmZmZmODgw
MDBkODY1Y2IwPgpbICAyNjcuNjU2Njg5XSBDUjI6IDAwMDAwMDAwMDAwMDAyNDgKWyAgMjY3
Ljc1MTIwOV0gLS0tWyBlbmQgdHJhY2UgYTE5MTQ3NDNlNmIxNGJkZCBdLS0tCi9rZXJuZWwv
eDg2XzY0LXJhbmRjb25maWctYzgtMDkyNC8xMmM2MDYwZDEzODAwOThiYjY5ZmFkMGMyNjIw
MDU1N2QwNzYzMzU1L2RtZXNnLXF1YW50YWwtYW50LTM6MjAxMzA5MjQwODExMDI6My4xMi4w
LXJjMi0wMDE1NC1nMTJjNjA2MDozCi9rZXJuZWwveDg2XzY0LXJhbmRjb25maWctYzgtMDky
NC8xMmM2MDYwZDEzODAwOThiYjY5ZmFkMGMyNjIwMDU1N2QwNzYzMzU1L2RtZXNnLXF1YW50
YWwtYmVucy0xOjIwMTMxMDAyMjIyODM2OjMuMTIuMC1yYzItMDAxNTQtZzEyYzYwNjA6Mwov
a2VybmVsL3g4Nl82NC1yYW5kY29uZmlnLWM4LTA5MjQvMTJjNjA2MGQxMzgwMDk4YmI2OWZh
ZDBjMjYyMDA1NTdkMDc2MzM1NS9kbWVzZy1xdWFudGFsLWNhaXJvLTIyOjIwMTMxMDAyMjIy
NzQwOjMuMTIuMC1yYzItMDAxNTQtZzEyYzYwNjA6Mwova2VybmVsL3g4Nl82NC1yYW5kY29u
ZmlnLWM4LTA5MjQvMTJjNjA2MGQxMzgwMDk4YmI2OWZhZDBjMjYyMDA1NTdkMDc2MzM1NS9k
bWVzZy1xdWFudGFsLWpha2V0b3duLTI2OjIwMTMwOTI0MDgwNDA3OjMuMTIuMC1yYzItMDAx
NTQtZzEyYzYwNjA6Mwova2VybmVsL3g4Nl82NC1yYW5kY29uZmlnLWM4LTA5MjQvMTJjNjA2
MGQxMzgwMDk4YmI2OWZhZDBjMjYyMDA1NTdkMDc2MzM1NS9kbWVzZy1xdWFudGFsLWpha2V0
b3duLTg6MjAxMzA5MjQwODEyMDk6My4xMi4wLXJjMi0wMDE1NC1nMTJjNjA2MDozCi9rZXJu
ZWwveDg2XzY0LXJhbmRjb25maWctYzgtMDkyNC8xMmM2MDYwZDEzODAwOThiYjY5ZmFkMGMy
NjIwMDU1N2QwNzYzMzU1L2RtZXNnLXF1YW50YWwtbGtwLXN0MDEtMzoyMDEzMTAwMjIyMzIy
MzozLjEyLjAtcmMyLTAwMTU0LWcxMmM2MDYwOjMKL2tlcm5lbC94ODZfNjQtcmFuZGNvbmZp
Zy1jOC0wOTI0LzEyYzYwNjBkMTM4MDA5OGJiNjlmYWQwYzI2MjAwNTU3ZDA3NjMzNTUvZG1l
c2ctcXVhbnRhbC1sa3Atc3QwMS02OjIwMTMwOTI0MDgxMDA4OjMuMTIuMC1yYzItMDAxNTQt
ZzEyYzYwNjA6Mwova2VybmVsL3g4Nl82NC1yYW5kY29uZmlnLWM4LTA5MjQvMTJjNjA2MGQx
MzgwMDk4YmI2OWZhZDBjMjYyMDA1NTdkMDc2MzM1NS9kbWVzZy1xdWFudGFsLWxrcC10dDAy
LTEwOjIwMTMwOTIzMjIzMzIyOjMuMTIuMC1yYzItMDAxNTQtZzEyYzYwNjA6Mwova2VybmVs
L3g4Nl82NC1yYW5kY29uZmlnLWM4LTA5MjQvMTJjNjA2MGQxMzgwMDk4YmI2OWZhZDBjMjYy
MDA1NTdkMDc2MzM1NS9kbWVzZy1xdWFudGFsLWxrcC10dDAyLTE0OjIwMTMxMDAyMTI1OTQ2
OjMuMTIuMC1yYzItMDAxNTQtZzEyYzYwNjA6Mwova2VybmVsL3g4Nl82NC1yYW5kY29uZmln
LWM4LTA5MjQvMTJjNjA2MGQxMzgwMDk4YmI2OWZhZDBjMjYyMDA1NTdkMDc2MzM1NS9kbWVz
Zy1xdWFudGFsLWxrcC10dDAyLTE2OjIwMTMxMDAyMTI1ODI5OjMuMTIuMC1yYzItMDAxNTQt
ZzEyYzYwNjA6Mwova2VybmVsL3g4Nl82NC1yYW5kY29uZmlnLWM4LTA5MjQvMTJjNjA2MGQx
MzgwMDk4YmI2OWZhZDBjMjYyMDA1NTdkMDc2MzM1NS9kbWVzZy1xdWFudGFsLWxrcC10dDAy
LTIwOjIwMTMwOTIzMjIyNDQ3OjMuMTIuMC1yYzItMDAxNTQtZzEyYzYwNjA6Mwova2VybmVs
L3g4Nl82NC1yYW5kY29uZmlnLWM4LTA5MjQvMTJjNjA2MGQxMzgwMDk4YmI2OWZhZDBjMjYy
MDA1NTdkMDc2MzM1NS9kbWVzZy1xdWFudGFsLWxrcC10dDAyLTIwOjIwMTMxMDAyMTI1OTQ1
OjMuMTIuMC1yYzItMDAxNTQtZzEyYzYwNjA6Mwova2VybmVsL3g4Nl82NC1yYW5kY29uZmln
LWM4LTA5MjQvMTJjNjA2MGQxMzgwMDk4YmI2OWZhZDBjMjYyMDA1NTdkMDc2MzM1NS9kbWVz
Zy1xdWFudGFsLWxrcC10dDAyLTIxOjIwMTMxMDAyMTI1NzU2OjMuMTIuMC1yYzItMDAxNTQt
ZzEyYzYwNjA6Mwova2VybmVsL3g4Nl82NC1yYW5kY29uZmlnLWM4LTA5MjQvMTJjNjA2MGQx
MzgwMDk4YmI2OWZhZDBjMjYyMDA1NTdkMDc2MzM1NS9kbWVzZy1xdWFudGFsLWxrcC10dDAy
LTc6MjAxMzA5MjQwOTI1Mzk6My4xMi4wLXJjMi0wMDE1NC1nMTJjNjA2MDozCi9rZXJuZWwv
eDg2XzY0LXJhbmRjb25maWctYzgtMDkyNC8xMmM2MDYwZDEzODAwOThiYjY5ZmFkMGMyNjIw
MDU1N2QwNzYzMzU1L2RtZXNnLXF1YW50YWwtd2FpbWVhLTEwOjIwMTMxMDAzMDYyOTAyOjMu
MTIuMC1yYzItMDAxNTQtZzEyYzYwNjA6Mwova2VybmVsL3g4Nl82NC1yYW5kY29uZmlnLWM4
LTA5MjQvMTJjNjA2MGQxMzgwMDk4YmI2OWZhZDBjMjYyMDA1NTdkMDc2MzM1NS9kbWVzZy1x
dWFudGFsLXdhaW1lYS0xMDoyMDEzMTAwMzE2NTY0NzozLjEyLjAtcmMyLTAwMTU0LWcxMmM2
MDYwOjMKL2tlcm5lbC94ODZfNjQtcmFuZGNvbmZpZy1jOC0wOTI0LzEyYzYwNjBkMTM4MDA5
OGJiNjlmYWQwYzI2MjAwNTU3ZDA3NjMzNTUvZG1lc2ctcXVhbnRhbC13YWltZWEtMTU6MjAx
MzEwMDMwNjI3MDQ6My4xMi4wLXJjMi0wMDE1NC1nMTJjNjA2MDozCi9rZXJuZWwveDg2XzY0
LXJhbmRjb25maWctYzgtMDkyNC8xMmM2MDYwZDEzODAwOThiYjY5ZmFkMGMyNjIwMDU1N2Qw
NzYzMzU1L2RtZXNnLXF1YW50YWwtd2FpbWVhLTE1OjIwMTMxMDAzMDYyNzE5OjMuMTIuMC1y
YzItMDAxNTQtZzEyYzYwNjA6Mwova2VybmVsL3g4Nl82NC1yYW5kY29uZmlnLWM4LTA5MjQv
MTJjNjA2MGQxMzgwMDk4YmI2OWZhZDBjMjYyMDA1NTdkMDc2MzM1NS9kbWVzZy1xdWFudGFs
LXdhaW1lYS02OjIwMTMxMDAzMDYyOTA4OjMuMTIuMC1yYzItMDAxNTQtZzEyYzYwNjA6Mwov
a2VybmVsL3g4Nl82NC1yYW5kY29uZmlnLWM4LTA5MjQvMTJjNjA2MGQxMzgwMDk4YmI2OWZh
ZDBjMjYyMDA1NTdkMDc2MzM1NS9kbWVzZy1xdWFudGFsLXdhaW1lYS04OjIwMTMxMDAzMDYx
NTIzOjMuMTIuMC1yYzItMDAxNTQtZzEyYzYwNjA6Mwova2VybmVsL3g4Nl82NC1yYW5kY29u
ZmlnLWM4LTA5MjQvMTJjNjA2MGQxMzgwMDk4YmI2OWZhZDBjMjYyMDA1NTdkMDc2MzM1NS9k
bWVzZy1xdWFudGFsLXhwcy01OjIwMTMxMDAzMTcwMDMzOjMuMTIuMC1yYzItMDAxNTQtZzEy
YzYwNjA6Mwova2VybmVsL3g4Nl82NC1yYW5kY29uZmlnLWM4LTA5MjQvMTJjNjA2MGQxMzgw
MDk4YmI2OWZhZDBjMjYyMDA1NTdkMDc2MzM1NS9kbWVzZy15b2N0by1iZW5zLTE6MjAxMzEw
MDIyMjI5Mjk6My4xMi4wLXJjMi0wMDE1NC1nMTJjNjA2MDozCi9rZXJuZWwveDg2XzY0LXJh
bmRjb25maWctYzgtMDkyNC8xMmM2MDYwZDEzODAwOThiYjY5ZmFkMGMyNjIwMDU1N2QwNzYz
MzU1L2RtZXNnLXlvY3RvLWpha2V0b3duLTE3OjIwMTMwOTI0MDgwOTU0OjMuMTIuMC1yYzIt
MDAxNTQtZzEyYzYwNjA6Mwova2VybmVsL3g4Nl82NC1yYW5kY29uZmlnLWM4LTA5MjQvMTJj
NjA2MGQxMzgwMDk4YmI2OWZhZDBjMjYyMDA1NTdkMDc2MzM1NS9kbWVzZy15b2N0by1qYWtl
dG93bi00MDoyMDEzMTAwMjIyMzIyODozLjEyLjAtcmMyLTAwMTU0LWcxMmM2MDYwOjMKL2tl
cm5lbC94ODZfNjQtcmFuZGNvbmZpZy1jOC0wOTI0LzEyYzYwNjBkMTM4MDA5OGJiNjlmYWQw
YzI2MjAwNTU3ZDA3NjMzNTUvZG1lc2cteW9jdG8tbGtwLXN0MDEtMTE6MjAxMzEwMDIyMjMy
MjI6My4xMi4wLXJjMi0wMDE1NC1nMTJjNjA2MDozCi9rZXJuZWwveDg2XzY0LXJhbmRjb25m
aWctYzgtMDkyNC8xMmM2MDYwZDEzODAwOThiYjY5ZmFkMGMyNjIwMDU1N2QwNzYzMzU1L2Rt
ZXNnLXlvY3RvLWxrcC10dDAyLTE2OjIwMTMwOTIzMjIyMzQ1OjMuMTIuMC1yYzItMDAxNTQt
ZzEyYzYwNjA6Mwova2VybmVsL3g4Nl82NC1yYW5kY29uZmlnLWM4LTA5MjQvMTJjNjA2MGQx
MzgwMDk4YmI2OWZhZDBjMjYyMDA1NTdkMDc2MzM1NS9kbWVzZy15b2N0by1sa3AtdHQwMi0x
OjIwMTMxMDAyMTI1NjIxOjMuMTIuMC1yYzItMDAxNTQtZzEyYzYwNjA6Mwova2VybmVsL3g4
Nl82NC1yYW5kY29uZmlnLWM4LTA5MjQvMTJjNjA2MGQxMzgwMDk4YmI2OWZhZDBjMjYyMDA1
NTdkMDc2MzM1NS9kbWVzZy15b2N0by13YWltZWEtMTM6MjAxMzEwMDMwNjI0MzY6My4xMi4w
LXJjMi0wMDE1NC1nMTJjNjA2MDozCi9rZXJuZWwveDg2XzY0LXJhbmRjb25maWctYzgtMDky
NC8xMmM2MDYwZDEzODAwOThiYjY5ZmFkMGMyNjIwMDU1N2QwNzYzMzU1L2RtZXNnLXlvY3Rv
LXhwcy01OjIwMTMxMDAyMjIzMDE3OjMuMTIuMC1yYzItMDAxNTQtZzEyYzYwNjA6MwoKW2Rl
dGFjaGVkIEhFQUQgZjFlZTg0OF0gUmV2ZXJ0ICJETUEtQVBJOiBkY2RiYXM6IHVwZGF0ZSBE
TUEgbWFzayBoYW5kaW5nIgogMSBmaWxlIGNoYW5nZWQsIDExIGluc2VydGlvbnMoKyksIDEy
IGRlbGV0aW9ucygtKQpscyAtYSAva2VybmVsLXRlc3RzL3J1bi1xdWV1ZS9rdm0veDg2XzY0
LXJhbmRjb25maWctYzgtMDkyNC9saW51eC1kZXZlbDpkZXZlbC1jYWlyby14ODZfNjQtMjAx
MzA5MjQwNzUyOmYxZWU4NDg0MGY4MzdhNTkzOWY0MGNmMDdjM2U2YmNlZWIyYTU0MzI6Ymlz
ZWN0LW5ldAoKMjAxMy0xMC0wNC0wMDoyMDoxNSBmMWVlODQ4NDBmODM3YTU5MzlmNDBjZjA3
YzNlNmJjZWViMmE1NDMyIGNvbXBpbGluZwoKMjAxMy0xMC0wNC0wMDoyNDo1MyBkZXRlY3Rp
bmcgYm9vdCBzdGF0ZSAzLjEyLjAtcmMyLTAwMTU1LWdmMWVlODQ4Li4uLgk1CTguCTIyCTI3
CTI5CTMzCTM2CTM3CTM4CTQxCTQ1CTUzCTU3CTY0CTc5CTgzLgk5OAkxMTUJMTI1CTE0NAkx
NTIJMTYwCTE2MQkxNjIJMTY1Li4JMTY5Li4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4u
Li4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4u
Li4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4u
Li4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4u
Li4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4u
Li4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4u
LhtbMTszNW1hZGRfdG9fcnVuX3F1ZXVlIDExG1swbQouLi4JMTcxCTE3OS4uLi4uLi4uLi4u
Li4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4u
Li4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4u
Li4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4u
Li4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4u
Li4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4u
Li4uLi4uLi4uLi4uLi4uLi4uLi4bWzE7MzVtYWRkX3RvX3J1bl9xdWV1ZSAxG1swbQouLi4J
MTgwIFNVQ0NFU1MKCgo9PT09PT09PT0gdXBzdHJlYW0gPT09PT09PT09CkZldGNoaW5nIGxp
bnVzCmxzIC1hIC9rZXJuZWwtdGVzdHMvcnVuLXF1ZXVlL2t2bS94ODZfNjQtcmFuZGNvbmZp
Zy1jOC0wOTI0L2xpbnV4LWRldmVsOmRldmVsLWNhaXJvLXg4Nl82NC0yMDEzMDkyNDA3NTI6
NmQxNWVlNDkyODA5ZDM4YmQ2MjIzN2I2ZDBmNmE4MWQ0ZGQxMmQxNTpiaXNlY3QtbmV0Cgoy
MDEzLTEwLTA0LTA1OjQ5OjA1IDZkMTVlZTQ5MjgwOWQzOGJkNjIyMzdiNmQwZjZhODFkNGRk
MTJkMTUgY29tcGlsaW5nCgoyMDEzLTEwLTA0LTA1OjUzOjEzIGRldGVjdGluZyBib290IHN0
YXRlIDMuMTIuMC1yYzMtMDAyNjctZzZkMTVlZTQuLi4JNgkxNQkyMgkyNgkzMQkzNQk0Mgk0
Nwk1NQk2MAk2Ngk3MS4JNzQuLgk3Ny4uCTgzCTEwMAkxMDMJMTEzCTEyMwkxMjcJMTM0CTEz
OQkxNDEJMTUxCTE1NAkxNjIJMTY0CTE2NQkxNjkJMTczCTE3NwkxNzguLi4uLi4uLi4uCTE3
OS4uLi4uLgkxODAgU1VDQ0VTUwoKCj09PT09PT09PSBsaW51eC1uZXh0ID09PT09PT09PQpG
ZXRjaGluZyBuZXh0CmxzIC1hIC9rZXJuZWwtdGVzdHMvcnVuLXF1ZXVlL2t2bS94ODZfNjQt
cmFuZGNvbmZpZy1jOC0wOTI0L2xpbnV4LWRldmVsOmRldmVsLWNhaXJvLXg4Nl82NC0yMDEz
MDkyNDA3NTI6YTBjZjFhYmMyNWFjMTk3ZGQ5N2I4NTdjMGY2MzQxMDY2YThjYjFjZjpiaXNl
Y3QtbmV0CgoyMDEzLTEwLTA0LTA2OjIyOjI0IGEwY2YxYWJjMjVhYzE5N2RkOTdiODU3YzBm
NjM0MTA2NmE4Y2IxY2YgY29tcGlsaW5nCgoyMDEzLTEwLTA0LTA2OjI2OjQ0IGRldGVjdGlu
ZyBib290IHN0YXRlIDMuMTIuMC1yYzItbmV4dC0yMDEzMDkyNy0wMzEwMC1nYTBjZjFhYi4u
CTIJMwk2CTgJOS4JMTMJMTYJMTguCTE5CTIxCTI0CTI4CTM0CTM1CTQ2CTQ5CTU3CTY2CTcw
CTczCTc3Lgk3OQk4Mwk4NQk4OQk5Mgk5NQk5Nwk5OQkxMDIJMTA3CTEwOQkxMTAJMTE1CTEx
NwkxMjEJMTI3CTEzMgkxMzYJMTQyCTE1MAkxNTQJMTYxCTE2OAkxNzEJMTczCTE3NQkxNzgu
Li4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4u
Li4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4u
Li4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4u
Li4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4u
Li4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4u
Li4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uG1sxOzM1bWFkZF90b19ydW5fcXVldWUg
MhtbMG0KLi4uCTE4MCBTVUNDRVNTCgo=

--yrj/dFKFPuw6o+aM
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="config-3.12.0-rc2-00154-g12c6060"

#
# Automatically generated file; DO NOT EDIT.
# Linux/x86_64 3.12.0-rc2 Kernel Configuration
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
CONFIG_KERNEL_GZIP=y
# CONFIG_KERNEL_BZIP2 is not set
# CONFIG_KERNEL_LZMA is not set
# CONFIG_KERNEL_XZ is not set
# CONFIG_KERNEL_LZO is not set
# CONFIG_KERNEL_LZ4 is not set
CONFIG_DEFAULT_HOSTNAME="(none)"
CONFIG_SWAP=y
CONFIG_SYSVIPC=y
CONFIG_SYSVIPC_SYSCTL=y
# CONFIG_POSIX_MQUEUE is not set
CONFIG_FHANDLE=y
# CONFIG_AUDIT is not set

#
# IRQ subsystem
#
CONFIG_GENERIC_IRQ_PROBE=y
CONFIG_GENERIC_IRQ_SHOW=y
CONFIG_IRQ_DOMAIN=y
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
CONFIG_RCU_FANOUT_EXACT=y
# CONFIG_TREE_RCU_TRACE is not set
# CONFIG_RCU_BOOST is not set
# CONFIG_RCU_NOCB_CPU is not set
CONFIG_IKCONFIG=y
CONFIG_IKCONFIG_PROC=y
CONFIG_LOG_BUF_SHIFT=17
CONFIG_HAVE_UNSTABLE_SCHED_CLOCK=y
CONFIG_ARCH_SUPPORTS_NUMA_BALANCING=y
CONFIG_ARCH_WANTS_PROT_NUMA_PROT_NONE=y
CONFIG_CGROUPS=y
CONFIG_CGROUP_DEBUG=y
# CONFIG_CGROUP_FREEZER is not set
CONFIG_CGROUP_DEVICE=y
CONFIG_CPUSETS=y
# CONFIG_PROC_PID_CPUSET is not set
# CONFIG_CGROUP_CPUACCT is not set
CONFIG_RESOURCE_COUNTERS=y
# CONFIG_MEMCG is not set
CONFIG_CGROUP_PERF=y
CONFIG_CGROUP_SCHED=y
CONFIG_FAIR_GROUP_SCHED=y
CONFIG_CFS_BANDWIDTH=y
# CONFIG_RT_GROUP_SCHED is not set
# CONFIG_BLK_CGROUP is not set
# CONFIG_CHECKPOINT_RESTORE is not set
CONFIG_NAMESPACES=y
CONFIG_UTS_NS=y
CONFIG_IPC_NS=y
# CONFIG_USER_NS is not set
CONFIG_PID_NS=y
CONFIG_NET_NS=y
# CONFIG_UIDGID_STRICT_TYPE_CHECKS is not set
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
CONFIG_SYSCTL_EXCEPTION_TRACE=y
CONFIG_HAVE_PCSPKR_PLATFORM=y
# CONFIG_EXPERT is not set
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
CONFIG_COMPAT_BRK=y
# CONFIG_SLAB is not set
CONFIG_SLUB=y
# CONFIG_PROFILING is not set
CONFIG_HAVE_OPROFILE=y
CONFIG_OPROFILE_NMI_TIMER=y
# CONFIG_JUMP_LABEL is not set
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
CONFIG_HAVE_ARCH_SECCOMP_FILTER=y
CONFIG_SECCOMP_FILTER=y
CONFIG_HAVE_CONTEXT_TRACKING=y
CONFIG_HAVE_IRQ_TIME_ACCOUNTING=y
CONFIG_HAVE_ARCH_TRANSPARENT_HUGEPAGE=y
CONFIG_HAVE_ARCH_SOFT_DIRTY=y
CONFIG_MODULES_USE_ELF_RELA=y

#
# GCOV-based kernel profiling
#
# CONFIG_HAVE_GENERIC_DMA_COHERENT is not set
CONFIG_SLABINFO=y
CONFIG_RT_MUTEXES=y
CONFIG_BASE_SMALL=0
# CONFIG_MODULES is not set
CONFIG_BLOCK=y
CONFIG_BLK_DEV_BSG=y
CONFIG_BLK_DEV_BSGLIB=y
# CONFIG_BLK_DEV_INTEGRITY is not set
CONFIG_CMDLINE_PARSER=y

#
# Partition Types
#
CONFIG_PARTITION_ADVANCED=y
CONFIG_ACORN_PARTITION=y
# CONFIG_ACORN_PARTITION_CUMANA is not set
# CONFIG_ACORN_PARTITION_EESOX is not set
CONFIG_ACORN_PARTITION_ICS=y
CONFIG_ACORN_PARTITION_ADFS=y
CONFIG_ACORN_PARTITION_POWERTEC=y
CONFIG_ACORN_PARTITION_RISCIX=y
CONFIG_AIX_PARTITION=y
# CONFIG_OSF_PARTITION is not set
CONFIG_AMIGA_PARTITION=y
# CONFIG_ATARI_PARTITION is not set
# CONFIG_MAC_PARTITION is not set
# CONFIG_MSDOS_PARTITION is not set
# CONFIG_LDM_PARTITION is not set
# CONFIG_SGI_PARTITION is not set
# CONFIG_ULTRIX_PARTITION is not set
CONFIG_SUN_PARTITION=y
CONFIG_KARMA_PARTITION=y
CONFIG_EFI_PARTITION=y
CONFIG_SYSV68_PARTITION=y
CONFIG_CMDLINE_PARTITION=y

#
# IO Schedulers
#
CONFIG_IOSCHED_NOOP=y
CONFIG_IOSCHED_DEADLINE=y
CONFIG_IOSCHED_CFQ=y
CONFIG_DEFAULT_DEADLINE=y
# CONFIG_DEFAULT_CFQ is not set
# CONFIG_DEFAULT_NOOP is not set
CONFIG_DEFAULT_IOSCHED="deadline"
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
CONFIG_MK8=y
# CONFIG_MPSC is not set
# CONFIG_MCORE2 is not set
# CONFIG_MATOM is not set
# CONFIG_GENERIC_CPU is not set
CONFIG_X86_INTERNODE_CACHE_SHIFT=6
CONFIG_X86_L1_CACHE_SHIFT=6
CONFIG_X86_INTEL_USERCOPY=y
CONFIG_X86_USE_PPRO_CHECKSUM=y
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
# CONFIG_PREEMPT_VOLUNTARY is not set
CONFIG_PREEMPT=y
CONFIG_PREEMPT_COUNT=y
CONFIG_X86_LOCAL_APIC=y
CONFIG_X86_IO_APIC=y
# CONFIG_X86_REROUTE_FOR_BROKEN_BOOT_IRQS is not set
# CONFIG_X86_MCE is not set
# CONFIG_I8K is not set
# CONFIG_MICROCODE is not set
# CONFIG_MICROCODE_INTEL_EARLY is not set
# CONFIG_MICROCODE_AMD_EARLY is not set
# CONFIG_X86_MSR is not set
CONFIG_X86_CPUID=y
CONFIG_ARCH_PHYS_ADDR_T_64BIT=y
CONFIG_ARCH_DMA_ADDR_T_64BIT=y
CONFIG_DIRECT_GBPAGES=y
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
# CONFIG_HAVE_BOOTMEM_INFO_NODE is not set
CONFIG_MEMORY_HOTPLUG=y
CONFIG_MEMORY_HOTPLUG_SPARSE=y
# CONFIG_MEMORY_HOTREMOVE is not set
CONFIG_PAGEFLAGS_EXTENDED=y
CONFIG_SPLIT_PTLOCK_CPUS=999999
# CONFIG_COMPACTION is not set
CONFIG_MIGRATION=y
CONFIG_PHYS_ADDR_T_64BIT=y
CONFIG_ZONE_DMA_FLAG=1
# CONFIG_BOUNCE is not set
CONFIG_VIRT_TO_BUS=y
# CONFIG_KSM is not set
CONFIG_DEFAULT_MMAP_MIN_ADDR=4096
# CONFIG_TRANSPARENT_HUGEPAGE is not set
CONFIG_CROSS_MEMORY_ATTACH=y
CONFIG_NEED_PER_CPU_KM=y
# CONFIG_CLEANCACHE is not set
CONFIG_FRONTSWAP=y
CONFIG_CMA=y
CONFIG_CMA_DEBUG=y
CONFIG_ZBUD=y
CONFIG_ZSWAP=y
# CONFIG_X86_CHECK_BIOS_CORRUPTION is not set
CONFIG_X86_RESERVE_LOW=64
CONFIG_MTRR=y
# CONFIG_MTRR_SANITIZER is not set
CONFIG_X86_PAT=y
CONFIG_ARCH_USES_PG_UNCACHED=y
CONFIG_ARCH_RANDOM=y
CONFIG_X86_SMAP=y
# CONFIG_EFI is not set
CONFIG_SECCOMP=y
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
CONFIG_RELOCATABLE=y
CONFIG_PHYSICAL_ALIGN=0x1000000
# CONFIG_CMDLINE_BOOL is not set
CONFIG_ARCH_ENABLE_MEMORY_HOTPLUG=y
CONFIG_ARCH_ENABLE_MEMORY_HOTREMOVE=y

#
# Power management and ACPI options
#
CONFIG_ARCH_HIBERNATION_HEADER=y
# CONFIG_SUSPEND is not set
CONFIG_HIBERNATE_CALLBACKS=y
CONFIG_HIBERNATION=y
CONFIG_PM_STD_PARTITION=""
CONFIG_PM_SLEEP=y
CONFIG_PM_AUTOSLEEP=y
CONFIG_PM_WAKELOCKS=y
CONFIG_PM_WAKELOCKS_LIMIT=100
# CONFIG_PM_WAKELOCKS_GC is not set
# CONFIG_PM_RUNTIME is not set
CONFIG_PM=y
# CONFIG_PM_DEBUG is not set
CONFIG_WQ_POWER_EFFICIENT_DEFAULT=y
CONFIG_ACPI=y
CONFIG_ACPI_SLEEP=y
# CONFIG_ACPI_PROCFS is not set
# CONFIG_ACPI_PROCFS_POWER is not set
# CONFIG_ACPI_EC_DEBUGFS is not set
CONFIG_ACPI_AC=y
CONFIG_ACPI_BATTERY=y
CONFIG_ACPI_BUTTON=y
CONFIG_ACPI_FAN=y
# CONFIG_ACPI_DOCK is not set
CONFIG_ACPI_PROCESSOR=y
# CONFIG_ACPI_IPMI is not set
# CONFIG_ACPI_PROCESSOR_AGGREGATOR is not set
CONFIG_ACPI_THERMAL=y
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
# CONFIG_ACPI_APEI is not set
# CONFIG_SFI is not set

#
# CPU Frequency scaling
#
CONFIG_CPU_FREQ=y
CONFIG_CPU_FREQ_TABLE=y
CONFIG_CPU_FREQ_GOV_COMMON=y
# CONFIG_CPU_FREQ_STAT is not set
CONFIG_CPU_FREQ_DEFAULT_GOV_PERFORMANCE=y
# CONFIG_CPU_FREQ_DEFAULT_GOV_USERSPACE is not set
# CONFIG_CPU_FREQ_DEFAULT_GOV_ONDEMAND is not set
# CONFIG_CPU_FREQ_DEFAULT_GOV_CONSERVATIVE is not set
CONFIG_CPU_FREQ_GOV_PERFORMANCE=y
# CONFIG_CPU_FREQ_GOV_POWERSAVE is not set
# CONFIG_CPU_FREQ_GOV_USERSPACE is not set
CONFIG_CPU_FREQ_GOV_ONDEMAND=y
# CONFIG_CPU_FREQ_GOV_CONSERVATIVE is not set

#
# x86 CPU frequency scaling drivers
#
CONFIG_X86_INTEL_PSTATE=y
# CONFIG_X86_PCC_CPUFREQ is not set
# CONFIG_X86_ACPI_CPUFREQ is not set
# CONFIG_X86_SPEEDSTEP_CENTRINO is not set
# CONFIG_X86_P4_CLOCKMOD is not set

#
# shared options
#
# CONFIG_X86_SPEEDSTEP_LIB is not set

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
CONFIG_PCMCIA=y
CONFIG_PCMCIA_LOAD_CIS=y
CONFIG_CARDBUS=y

#
# PC-card bridges
#
# CONFIG_YENTA is not set
# CONFIG_PD6729 is not set
# CONFIG_I82092 is not set
# CONFIG_HOTPLUG_PCI is not set
# CONFIG_RAPIDIO is not set
# CONFIG_X86_SYSFB is not set

#
# Executable file formats / Emulations
#
CONFIG_BINFMT_ELF=y
CONFIG_ARCH_BINFMT_ELF_RANDOMIZE_PIE=y
CONFIG_CORE_DUMP_DEFAULT_ELF_HEADERS=y
# CONFIG_BINFMT_SCRIPT is not set
# CONFIG_HAVE_AOUT is not set
CONFIG_BINFMT_MISC=y
CONFIG_COREDUMP=y
# CONFIG_IA32_EMULATION is not set
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
# CONFIG_DNS_RESOLVER is not set
# CONFIG_BATMAN_ADV is not set
# CONFIG_OPENVSWITCH is not set
# CONFIG_VSOCKETS is not set
# CONFIG_NETLINK_MMAP is not set
# CONFIG_NETLINK_DIAG is not set
# CONFIG_NET_MPLS_GSO is not set
# CONFIG_NETPRIO_CGROUP is not set
CONFIG_NET_RX_BUSY_POLL=y
CONFIG_BQL=y

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
# CONFIG_DEVTMPFS is not set
CONFIG_STANDALONE=y
CONFIG_PREVENT_FIRMWARE_BUILD=y
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
CONFIG_REGMAP_MMIO=y
CONFIG_REGMAP_IRQ=y
CONFIG_DMA_SHARED_BUFFER=y

#
# Bus devices
#
# CONFIG_CONNECTOR is not set
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
# CONFIG_NFTL is not set
CONFIG_INFTL=y
# CONFIG_RFD_FTL is not set
# CONFIG_SSFDC is not set
# CONFIG_SM_FTL is not set
# CONFIG_MTD_OOPS is not set
# CONFIG_MTD_SWAP is not set

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
# CONFIG_MTD_CFI_INTELEXT is not set
# CONFIG_MTD_CFI_AMDSTD is not set
# CONFIG_MTD_CFI_STAA is not set
CONFIG_MTD_CFI_UTIL=y
CONFIG_MTD_RAM=y
# CONFIG_MTD_ROM is not set
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
# CONFIG_MTD_NETSC520 is not set
# CONFIG_MTD_TS5500 is not set
CONFIG_MTD_AMD76XROM=y
CONFIG_MTD_ICHXROM=y
# CONFIG_MTD_ESB2ROM is not set
# CONFIG_MTD_CK804XROM is not set
# CONFIG_MTD_SCB2_FLASH is not set
# CONFIG_MTD_NETtel is not set
CONFIG_MTD_L440GX=y
# CONFIG_MTD_PCI is not set
CONFIG_MTD_PCMCIA=y
CONFIG_MTD_PCMCIA_ANONYMOUS=y
# CONFIG_MTD_INTEL_VR_NOR is not set
# CONFIG_MTD_PLATRAM is not set
CONFIG_MTD_LATCH_ADDR=y

#
# Self-contained MTD device drivers
#
# CONFIG_MTD_PMC551 is not set
CONFIG_MTD_SLRAM=y
CONFIG_MTD_PHRAM=y
CONFIG_MTD_MTDRAM=y
CONFIG_MTDRAM_TOTAL_SIZE=4096
CONFIG_MTDRAM_ERASE_SIZE=128
CONFIG_MTDRAM_ABS_POS=0
CONFIG_MTD_BLOCK2MTD=y

#
# Disk-On-Chip Device Drivers
#
CONFIG_MTD_DOCG3=y
CONFIG_BCH_CONST_M=14
CONFIG_BCH_CONST_T=4
# CONFIG_MTD_NAND is not set
CONFIG_MTD_ONENAND=y
CONFIG_MTD_ONENAND_VERIFY_WRITE=y
CONFIG_MTD_ONENAND_GENERIC=y
# CONFIG_MTD_ONENAND_OTP is not set
CONFIG_MTD_ONENAND_2X_PROGRAM=y

#
# LPDDR flash memory drivers
#
# CONFIG_MTD_LPDDR is not set
# CONFIG_MTD_UBI is not set
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
# CONFIG_SENSORS_LIS3LV02D is not set
CONFIG_AD525X_DPOT=y
# CONFIG_AD525X_DPOT_I2C is not set
CONFIG_DUMMY_IRQ=y
# CONFIG_IBM_ASM is not set
# CONFIG_PHANTOM is not set
# CONFIG_SGI_IOC4 is not set
# CONFIG_TIFM_CORE is not set
CONFIG_ICS932S401=y
# CONFIG_ATMEL_SSC is not set
CONFIG_ENCLOSURE_SERVICES=y
# CONFIG_HP_ILO is not set
CONFIG_APDS9802ALS=y
# CONFIG_ISL29003 is not set
# CONFIG_ISL29020 is not set
CONFIG_SENSORS_TSL2550=y
CONFIG_SENSORS_BH1780=y
# CONFIG_SENSORS_BH1770 is not set
CONFIG_SENSORS_APDS990X=y
CONFIG_HMC6352=y
CONFIG_DS1682=y
# CONFIG_VMWARE_BALLOON is not set
# CONFIG_BMP085_I2C is not set
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
CONFIG_EEPROM_93CX6=y
# CONFIG_CB710_CORE is not set

#
# Texas Instruments shared transport line discipline
#
# CONFIG_SENSORS_LIS3_I2C is not set

#
# Altera FPGA firmware download module
#
CONFIG_ALTERA_STAPL=y
# CONFIG_INTEL_MEI is not set
# CONFIG_INTEL_MEI_ME is not set
# CONFIG_VMWARE_VMCI is not set
CONFIG_HAVE_IDE=y
# CONFIG_IDE is not set

#
# SCSI device support
#
CONFIG_SCSI_MOD=y
CONFIG_RAID_ATTRS=y
# CONFIG_SCSI is not set
# CONFIG_SCSI_DMA is not set
# CONFIG_SCSI_NETLINK is not set
# CONFIG_ATA is not set
# CONFIG_MD is not set
# CONFIG_FUSION is not set

#
# IEEE 1394 (FireWire) support
#
# CONFIG_FIREWIRE is not set
# CONFIG_FIREWIRE_NOSY is not set
# CONFIG_I2O is not set
CONFIG_MACINTOSH_DRIVERS=y
# CONFIG_MAC_EMUMOUSEBTN is not set
# CONFIG_NETDEVICES is not set
# CONFIG_VHOST_NET is not set

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
CONFIG_KEYBOARD_ADP5588=y
CONFIG_KEYBOARD_ADP5589=y
CONFIG_KEYBOARD_ATKBD=y
# CONFIG_KEYBOARD_QT1070 is not set
CONFIG_KEYBOARD_QT2160=y
CONFIG_KEYBOARD_LKKBD=y
# CONFIG_KEYBOARD_TCA6416 is not set
CONFIG_KEYBOARD_TCA8418=y
CONFIG_KEYBOARD_LM8323=y
CONFIG_KEYBOARD_LM8333=y
# CONFIG_KEYBOARD_MAX7359 is not set
CONFIG_KEYBOARD_MCS=y
CONFIG_KEYBOARD_MPR121=y
# CONFIG_KEYBOARD_NEWTON is not set
CONFIG_KEYBOARD_OPENCORES=y
CONFIG_KEYBOARD_STOWAWAY=y
CONFIG_KEYBOARD_SUNKBD=y
CONFIG_KEYBOARD_STMPE=y
CONFIG_KEYBOARD_XTKBD=y
CONFIG_KEYBOARD_CROS_EC=y
# CONFIG_INPUT_MOUSE is not set
# CONFIG_INPUT_JOYSTICK is not set
# CONFIG_INPUT_TABLET is not set
CONFIG_INPUT_TOUCHSCREEN=y
CONFIG_TOUCHSCREEN_AD7879=y
CONFIG_TOUCHSCREEN_AD7879_I2C=y
CONFIG_TOUCHSCREEN_ATMEL_MXT=y
# CONFIG_TOUCHSCREEN_BU21013 is not set
CONFIG_TOUCHSCREEN_CYTTSP_CORE=y
# CONFIG_TOUCHSCREEN_CYTTSP_I2C is not set
# CONFIG_TOUCHSCREEN_CYTTSP4_CORE is not set
CONFIG_TOUCHSCREEN_DA9052=y
# CONFIG_TOUCHSCREEN_DYNAPRO is not set
CONFIG_TOUCHSCREEN_HAMPSHIRE=y
# CONFIG_TOUCHSCREEN_EETI is not set
CONFIG_TOUCHSCREEN_FUJITSU=y
# CONFIG_TOUCHSCREEN_ILI210X is not set
# CONFIG_TOUCHSCREEN_GUNZE is not set
CONFIG_TOUCHSCREEN_ELO=y
CONFIG_TOUCHSCREEN_WACOM_W8001=y
# CONFIG_TOUCHSCREEN_WACOM_I2C is not set
CONFIG_TOUCHSCREEN_MAX11801=y
CONFIG_TOUCHSCREEN_MCS5000=y
CONFIG_TOUCHSCREEN_MMS114=y
# CONFIG_TOUCHSCREEN_MTOUCH is not set
CONFIG_TOUCHSCREEN_INEXIO=y
CONFIG_TOUCHSCREEN_MK712=y
CONFIG_TOUCHSCREEN_PENMOUNT=y
CONFIG_TOUCHSCREEN_EDT_FT5X06=y
CONFIG_TOUCHSCREEN_TOUCHRIGHT=y
CONFIG_TOUCHSCREEN_TOUCHWIN=y
CONFIG_TOUCHSCREEN_TI_AM335X_TSC=y
CONFIG_TOUCHSCREEN_PIXCIR=y
CONFIG_TOUCHSCREEN_WM831X=y
CONFIG_TOUCHSCREEN_USB_COMPOSITE=y
CONFIG_TOUCHSCREEN_MC13783=y
CONFIG_TOUCHSCREEN_USB_EGALAX=y
CONFIG_TOUCHSCREEN_USB_PANJIT=y
CONFIG_TOUCHSCREEN_USB_3M=y
CONFIG_TOUCHSCREEN_USB_ITM=y
CONFIG_TOUCHSCREEN_USB_ETURBO=y
CONFIG_TOUCHSCREEN_USB_GUNZE=y
CONFIG_TOUCHSCREEN_USB_DMC_TSC10=y
CONFIG_TOUCHSCREEN_USB_IRTOUCH=y
CONFIG_TOUCHSCREEN_USB_IDEALTEK=y
CONFIG_TOUCHSCREEN_USB_GENERAL_TOUCH=y
CONFIG_TOUCHSCREEN_USB_GOTOP=y
CONFIG_TOUCHSCREEN_USB_JASTEC=y
CONFIG_TOUCHSCREEN_USB_ELO=y
CONFIG_TOUCHSCREEN_USB_E2I=y
CONFIG_TOUCHSCREEN_USB_ZYTRONIC=y
CONFIG_TOUCHSCREEN_USB_ETT_TC45USB=y
CONFIG_TOUCHSCREEN_USB_NEXIO=y
CONFIG_TOUCHSCREEN_USB_EASYTOUCH=y
# CONFIG_TOUCHSCREEN_TOUCHIT213 is not set
CONFIG_TOUCHSCREEN_TSC_SERIO=y
CONFIG_TOUCHSCREEN_TSC2007=y
CONFIG_TOUCHSCREEN_ST1232=y
# CONFIG_TOUCHSCREEN_STMPE is not set
CONFIG_TOUCHSCREEN_TPS6507X=y
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
CONFIG_SERIO_RAW=y
CONFIG_SERIO_ALTERA_PS2=y
CONFIG_SERIO_PS2MULT=y
CONFIG_SERIO_ARC_PS2=y
CONFIG_GAMEPORT=y
CONFIG_GAMEPORT_NS558=y
# CONFIG_GAMEPORT_L4 is not set
# CONFIG_GAMEPORT_EMU10K1 is not set
# CONFIG_GAMEPORT_FM801 is not set

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
CONFIG_LEGACY_PTYS=y
CONFIG_LEGACY_PTY_COUNT=256
# CONFIG_SERIAL_NONSTANDARD is not set
# CONFIG_NOZOMI is not set
# CONFIG_N_GSM is not set
# CONFIG_TRACE_ROUTER is not set
CONFIG_TRACE_SINK=y
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
# CONFIG_SERIAL_8250_CS is not set
CONFIG_SERIAL_8250_NR_UARTS=4
CONFIG_SERIAL_8250_RUNTIME_UARTS=4
CONFIG_SERIAL_8250_EXTENDED=y
# CONFIG_SERIAL_8250_MANY_PORTS is not set
# CONFIG_SERIAL_8250_SHARE_IRQ is not set
# CONFIG_SERIAL_8250_DETECT_IRQ is not set
# CONFIG_SERIAL_8250_RSA is not set
# CONFIG_SERIAL_8250_DW is not set

#
# Non-8250 serial port support
#
# CONFIG_SERIAL_MFD_HSU is not set
CONFIG_SERIAL_CORE=y
CONFIG_SERIAL_CORE_CONSOLE=y
# CONFIG_SERIAL_JSM is not set
CONFIG_SERIAL_SCCNXP=y
CONFIG_SERIAL_SCCNXP_CONSOLE=y
CONFIG_SERIAL_TIMBERDALE=y
# CONFIG_SERIAL_ALTERA_JTAGUART is not set
# CONFIG_SERIAL_ALTERA_UART is not set
# CONFIG_SERIAL_PCH_UART is not set
CONFIG_SERIAL_ARC=y
CONFIG_SERIAL_ARC_CONSOLE=y
CONFIG_SERIAL_ARC_NR_PORTS=1
# CONFIG_SERIAL_RP2 is not set
CONFIG_SERIAL_FSL_LPUART=y
CONFIG_SERIAL_FSL_LPUART_CONSOLE=y
CONFIG_SERIAL_ST_ASC=y
CONFIG_SERIAL_ST_ASC_CONSOLE=y
# CONFIG_VIRTIO_CONSOLE is not set
CONFIG_IPMI_HANDLER=y
# CONFIG_IPMI_PANIC_EVENT is not set
CONFIG_IPMI_DEVICE_INTERFACE=y
CONFIG_IPMI_SI=y
# CONFIG_IPMI_WATCHDOG is not set
CONFIG_IPMI_POWEROFF=y
CONFIG_HW_RANDOM=y
# CONFIG_HW_RANDOM_TIMERIOMEM is not set
CONFIG_HW_RANDOM_INTEL=y
CONFIG_HW_RANDOM_AMD=y
CONFIG_HW_RANDOM_VIA=y
CONFIG_HW_RANDOM_VIRTIO=y
CONFIG_NVRAM=y
CONFIG_R3964=y
# CONFIG_APPLICOM is not set

#
# PCMCIA character devices
#
CONFIG_SYNCLINK_CS=y
# CONFIG_CARDMAN_4000 is not set
CONFIG_CARDMAN_4040=y
CONFIG_MWAVE=y
CONFIG_RAW_DRIVER=y
CONFIG_MAX_RAW_DEVS=256
# CONFIG_HPET is not set
CONFIG_HANGCHECK_TIMER=y
# CONFIG_TCG_TPM is not set
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
CONFIG_I2C_MUX_PCA9541=y
# CONFIG_I2C_MUX_PCA954x is not set
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
# CONFIG_I2C_DESIGNWARE_PCI is not set
# CONFIG_I2C_EG20T is not set
CONFIG_I2C_KEMPLD=y
# CONFIG_I2C_OCORES is not set
CONFIG_I2C_PCA_PLATFORM=y
# CONFIG_I2C_PXA_PCI is not set
CONFIG_I2C_SIMTEC=y
CONFIG_I2C_XILINX=y

#
# External I2C/SMBus adapter drivers
#
# CONFIG_I2C_DIOLAN_U2C is not set
CONFIG_I2C_PARPORT_LIGHT=y
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
# CONFIG_HSI is not set

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
# CONFIG_PTP_1588_CLOCK_PCH is not set
CONFIG_ARCH_WANT_OPTIONAL_GPIOLIB=y
CONFIG_GPIO_DEVRES=y
# CONFIG_GPIOLIB is not set
CONFIG_W1=y

#
# 1-wire Bus Masters
#
# CONFIG_W1_MASTER_MATROX is not set
# CONFIG_W1_MASTER_DS2490 is not set
CONFIG_W1_MASTER_DS2482=y
CONFIG_W1_MASTER_DS1WM=y

#
# 1-wire Slaves
#
CONFIG_W1_SLAVE_THERM=y
CONFIG_W1_SLAVE_SMEM=y
CONFIG_W1_SLAVE_DS2408=y
CONFIG_W1_SLAVE_DS2408_READBACK=y
CONFIG_W1_SLAVE_DS2413=y
CONFIG_W1_SLAVE_DS2423=y
CONFIG_W1_SLAVE_DS2431=y
CONFIG_W1_SLAVE_DS2433=y
# CONFIG_W1_SLAVE_DS2433_CRC is not set
CONFIG_W1_SLAVE_DS2760=y
CONFIG_W1_SLAVE_DS2780=y
CONFIG_W1_SLAVE_DS2781=y
# CONFIG_W1_SLAVE_DS28E04 is not set
CONFIG_W1_SLAVE_BQ27000=y
CONFIG_POWER_SUPPLY=y
CONFIG_POWER_SUPPLY_DEBUG=y
# CONFIG_PDA_POWER is not set
CONFIG_GENERIC_ADC_BATTERY=y
# CONFIG_MAX8925_POWER is not set
CONFIG_WM831X_BACKUP=y
CONFIG_WM831X_POWER=y
# CONFIG_WM8350_POWER is not set
# CONFIG_TEST_POWER is not set
CONFIG_BATTERY_DS2760=y
# CONFIG_BATTERY_DS2780 is not set
CONFIG_BATTERY_DS2781=y
# CONFIG_BATTERY_DS2782 is not set
CONFIG_BATTERY_SBS=y
CONFIG_BATTERY_BQ27x00=y
CONFIG_BATTERY_BQ27X00_I2C=y
# CONFIG_BATTERY_BQ27X00_PLATFORM is not set
CONFIG_BATTERY_DA9052=y
CONFIG_BATTERY_MAX17040=y
# CONFIG_BATTERY_MAX17042 is not set
CONFIG_CHARGER_PCF50633=y
# CONFIG_CHARGER_ISP1704 is not set
CONFIG_CHARGER_MAX8903=y
# CONFIG_CHARGER_LP8727 is not set
# CONFIG_CHARGER_MANAGER is not set
CONFIG_CHARGER_MAX8998=y
CONFIG_CHARGER_BQ2415X=y
CONFIG_CHARGER_SMB347=y
CONFIG_POWER_RESET=y
CONFIG_POWER_AVS=y
CONFIG_HWMON=y
CONFIG_HWMON_VID=y
CONFIG_HWMON_DEBUG_CHIP=y

#
# Native drivers
#
CONFIG_SENSORS_ABITUGURU=y
# CONFIG_SENSORS_ABITUGURU3 is not set
# CONFIG_SENSORS_AD7414 is not set
CONFIG_SENSORS_AD7418=y
# CONFIG_SENSORS_ADM1021 is not set
# CONFIG_SENSORS_ADM1025 is not set
# CONFIG_SENSORS_ADM1026 is not set
CONFIG_SENSORS_ADM1029=y
CONFIG_SENSORS_ADM1031=y
CONFIG_SENSORS_ADM9240=y
CONFIG_SENSORS_ADT7X10=y
CONFIG_SENSORS_ADT7410=y
CONFIG_SENSORS_ADT7411=y
CONFIG_SENSORS_ADT7462=y
CONFIG_SENSORS_ADT7470=y
# CONFIG_SENSORS_ADT7475 is not set
CONFIG_SENSORS_ASC7621=y
# CONFIG_SENSORS_K8TEMP is not set
# CONFIG_SENSORS_K10TEMP is not set
# CONFIG_SENSORS_FAM15H_POWER is not set
# CONFIG_SENSORS_ASB100 is not set
CONFIG_SENSORS_ATXP1=y
CONFIG_SENSORS_DS620=y
CONFIG_SENSORS_DS1621=y
CONFIG_SENSORS_DA9052_ADC=y
CONFIG_SENSORS_DA9055=y
# CONFIG_SENSORS_I5K_AMB is not set
CONFIG_SENSORS_F71805F=y
CONFIG_SENSORS_F71882FG=y
CONFIG_SENSORS_F75375S=y
CONFIG_SENSORS_FSCHMD=y
CONFIG_SENSORS_G760A=y
CONFIG_SENSORS_G762=y
CONFIG_SENSORS_GL518SM=y
# CONFIG_SENSORS_GL520SM is not set
# CONFIG_SENSORS_HIH6130 is not set
CONFIG_SENSORS_HTU21=y
CONFIG_SENSORS_CORETEMP=y
# CONFIG_SENSORS_IBMAEM is not set
CONFIG_SENSORS_IBMPEX=y
CONFIG_SENSORS_IIO_HWMON=y
CONFIG_SENSORS_IT87=y
# CONFIG_SENSORS_JC42 is not set
CONFIG_SENSORS_LINEAGE=y
# CONFIG_SENSORS_LM63 is not set
CONFIG_SENSORS_LM73=y
# CONFIG_SENSORS_LM75 is not set
CONFIG_SENSORS_LM77=y
CONFIG_SENSORS_LM78=y
CONFIG_SENSORS_LM80=y
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
CONFIG_SENSORS_LM95241=y
CONFIG_SENSORS_LM95245=y
# CONFIG_SENSORS_MAX16065 is not set
CONFIG_SENSORS_MAX1619=y
# CONFIG_SENSORS_MAX1668 is not set
# CONFIG_SENSORS_MAX197 is not set
CONFIG_SENSORS_MAX6639=y
# CONFIG_SENSORS_MAX6642 is not set
CONFIG_SENSORS_MAX6650=y
CONFIG_SENSORS_MAX6697=y
CONFIG_SENSORS_MCP3021=y
CONFIG_SENSORS_NCT6775=y
# CONFIG_SENSORS_PC87360 is not set
CONFIG_SENSORS_PC87427=y
CONFIG_SENSORS_PCF8591=y
# CONFIG_PMBUS is not set
CONFIG_SENSORS_SHT21=y
# CONFIG_SENSORS_SIS5595 is not set
CONFIG_SENSORS_SMM665=y
# CONFIG_SENSORS_DME1737 is not set
CONFIG_SENSORS_EMC1403=y
CONFIG_SENSORS_EMC2103=y
# CONFIG_SENSORS_EMC6W201 is not set
CONFIG_SENSORS_SMSC47M1=y
CONFIG_SENSORS_SMSC47M192=y
# CONFIG_SENSORS_SMSC47B397 is not set
CONFIG_SENSORS_SCH56XX_COMMON=y
# CONFIG_SENSORS_SCH5627 is not set
CONFIG_SENSORS_SCH5636=y
CONFIG_SENSORS_ADS1015=y
# CONFIG_SENSORS_ADS7828 is not set
CONFIG_SENSORS_AMC6821=y
CONFIG_SENSORS_INA209=y
# CONFIG_SENSORS_INA2XX is not set
CONFIG_SENSORS_THMC50=y
# CONFIG_SENSORS_TMP102 is not set
CONFIG_SENSORS_TMP401=y
CONFIG_SENSORS_TMP421=y
# CONFIG_SENSORS_VIA_CPUTEMP is not set
# CONFIG_SENSORS_VIA686A is not set
# CONFIG_SENSORS_VT1211 is not set
# CONFIG_SENSORS_VT8231 is not set
CONFIG_SENSORS_W83781D=y
CONFIG_SENSORS_W83791D=y
CONFIG_SENSORS_W83792D=y
CONFIG_SENSORS_W83793=y
# CONFIG_SENSORS_W83795 is not set
CONFIG_SENSORS_W83L785TS=y
# CONFIG_SENSORS_W83L786NG is not set
CONFIG_SENSORS_W83627HF=y
CONFIG_SENSORS_W83627EHF=y
CONFIG_SENSORS_WM831X=y
# CONFIG_SENSORS_WM8350 is not set
# CONFIG_SENSORS_APPLESMC is not set
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
# CONFIG_THERMAL_GOV_USER_SPACE is not set
# CONFIG_CPU_THERMAL is not set
# CONFIG_THERMAL_EMULATION is not set
# CONFIG_INTEL_POWERCLAMP is not set

#
# Texas Instruments thermal drivers
#
CONFIG_WATCHDOG=y
CONFIG_WATCHDOG_CORE=y
CONFIG_WATCHDOG_NOWAYOUT=y

#
# Watchdog Device Drivers
#
CONFIG_SOFT_WATCHDOG=y
# CONFIG_DA9052_WATCHDOG is not set
CONFIG_DA9055_WATCHDOG=y
# CONFIG_WM831X_WATCHDOG is not set
# CONFIG_WM8350_WATCHDOG is not set
CONFIG_ACQUIRE_WDT=y
# CONFIG_ADVANTECH_WDT is not set
# CONFIG_ALIM1535_WDT is not set
# CONFIG_ALIM7101_WDT is not set
# CONFIG_F71808E_WDT is not set
# CONFIG_SP5100_TCO is not set
CONFIG_SC520_WDT=y
# CONFIG_SBC_FITPC2_WATCHDOG is not set
# CONFIG_EUROTECH_WDT is not set
CONFIG_IB700_WDT=y
CONFIG_IBMASR=y
CONFIG_WAFER_WDT=y
# CONFIG_I6300ESB_WDT is not set
# CONFIG_IE6XX_WDT is not set
# CONFIG_ITCO_WDT is not set
# CONFIG_IT8712F_WDT is not set
# CONFIG_IT87_WDT is not set
# CONFIG_HP_WATCHDOG is not set
CONFIG_KEMPLD_WDT=y
CONFIG_SC1200_WDT=y
CONFIG_PC87413_WDT=y
# CONFIG_NV_TCO is not set
CONFIG_60XX_WDT=y
CONFIG_SBC8360_WDT=y
CONFIG_CPU5_WDT=y
# CONFIG_SMSC_SCH311X_WDT is not set
# CONFIG_SMSC37B787_WDT is not set
# CONFIG_VIA_WDT is not set
# CONFIG_W83627HF_WDT is not set
# CONFIG_W83697HF_WDT is not set
CONFIG_W83697UG_WDT=y
CONFIG_W83877F_WDT=y
CONFIG_W83977F_WDT=y
# CONFIG_MACHZ_WDT is not set
CONFIG_SBC_EPX_C3_WATCHDOG=y

#
# PCI-based Watchdog Cards
#
# CONFIG_PCIPCWATCHDOG is not set
# CONFIG_WDTPCI is not set

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
# CONFIG_BCMA is not set

#
# Multifunction device drivers
#
CONFIG_MFD_CORE=y
# CONFIG_MFD_CS5535 is not set
# CONFIG_MFD_AS3711 is not set
# CONFIG_PMIC_ADP5520 is not set
CONFIG_MFD_CROS_EC=y
# CONFIG_MFD_CROS_EC_I2C is not set
# CONFIG_PMIC_DA903X is not set
CONFIG_PMIC_DA9052=y
CONFIG_MFD_DA9052_I2C=y
CONFIG_MFD_DA9055=y
# CONFIG_MFD_DA9063 is not set
CONFIG_MFD_MC13783=y
CONFIG_MFD_MC13XXX=y
CONFIG_MFD_MC13XXX_I2C=y
CONFIG_HTC_PASIC3=y
# CONFIG_LPC_ICH is not set
# CONFIG_LPC_SCH is not set
# CONFIG_MFD_JANZ_CMODIO is not set
CONFIG_MFD_KEMPLD=y
CONFIG_MFD_88PM800=y
# CONFIG_MFD_88PM805 is not set
# CONFIG_MFD_88PM860X is not set
# CONFIG_MFD_MAX77686 is not set
# CONFIG_MFD_MAX77693 is not set
CONFIG_MFD_MAX8907=y
CONFIG_MFD_MAX8925=y
# CONFIG_MFD_MAX8997 is not set
CONFIG_MFD_MAX8998=y
CONFIG_MFD_VIPERBOARD=y
# CONFIG_MFD_RETU is not set
CONFIG_MFD_PCF50633=y
CONFIG_PCF50633_ADC=y
CONFIG_PCF50633_GPIO=y
# CONFIG_MFD_RDC321X is not set
# CONFIG_MFD_RTSX_PCI is not set
# CONFIG_MFD_RC5T583 is not set
# CONFIG_MFD_SEC_CORE is not set
CONFIG_MFD_SI476X_CORE=y
# CONFIG_MFD_SM501 is not set
# CONFIG_MFD_SMSC is not set
# CONFIG_ABX500_CORE is not set
CONFIG_MFD_STMPE=y

#
# STMicroelectronics STMPE Interface Drivers
#
# CONFIG_STMPE_I2C is not set
# CONFIG_MFD_SYSCON is not set
CONFIG_MFD_TI_AM335X_TSCADC=y
# CONFIG_MFD_LP8788 is not set
# CONFIG_MFD_PALMAS is not set
# CONFIG_TPS6105X is not set
CONFIG_TPS6507X=y
# CONFIG_MFD_TPS65090 is not set
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
CONFIG_MFD_ARIZONA=y
CONFIG_MFD_ARIZONA_I2C=y
CONFIG_MFD_WM5102=y
CONFIG_MFD_WM5110=y
CONFIG_MFD_WM8997=y
# CONFIG_MFD_WM8400 is not set
CONFIG_MFD_WM831X=y
CONFIG_MFD_WM831X_I2C=y
CONFIG_MFD_WM8350=y
CONFIG_MFD_WM8350_I2C=y
# CONFIG_MFD_WM8994 is not set
CONFIG_REGULATOR=y
# CONFIG_REGULATOR_DEBUG is not set
CONFIG_REGULATOR_DUMMY=y
# CONFIG_REGULATOR_FIXED_VOLTAGE is not set
# CONFIG_REGULATOR_VIRTUAL_CONSUMER is not set
# CONFIG_REGULATOR_USERSPACE_CONSUMER is not set
# CONFIG_REGULATOR_88PM800 is not set
# CONFIG_REGULATOR_AD5398 is not set
CONFIG_REGULATOR_ARIZONA=y
CONFIG_REGULATOR_DA9052=y
# CONFIG_REGULATOR_DA9055 is not set
# CONFIG_REGULATOR_DA9210 is not set
# CONFIG_REGULATOR_FAN53555 is not set
CONFIG_REGULATOR_ISL6271A=y
CONFIG_REGULATOR_LP3971=y
CONFIG_REGULATOR_LP3972=y
# CONFIG_REGULATOR_LP872X is not set
# CONFIG_REGULATOR_LP8755 is not set
CONFIG_REGULATOR_MAX1586=y
CONFIG_REGULATOR_MAX8649=y
CONFIG_REGULATOR_MAX8660=y
CONFIG_REGULATOR_MAX8907=y
# CONFIG_REGULATOR_MAX8925 is not set
CONFIG_REGULATOR_MAX8952=y
# CONFIG_REGULATOR_MAX8973 is not set
CONFIG_REGULATOR_MAX8998=y
CONFIG_REGULATOR_MC13XXX_CORE=y
CONFIG_REGULATOR_MC13783=y
# CONFIG_REGULATOR_MC13892 is not set
CONFIG_REGULATOR_PCF50633=y
CONFIG_REGULATOR_PFUZE100=y
CONFIG_REGULATOR_TPS51632=y
# CONFIG_REGULATOR_TPS62360 is not set
CONFIG_REGULATOR_TPS65023=y
CONFIG_REGULATOR_TPS6507X=y
# CONFIG_REGULATOR_WM831X is not set
CONFIG_REGULATOR_WM8350=y
# CONFIG_MEDIA_SUPPORT is not set

#
# Graphics support
#
# CONFIG_AGP is not set
CONFIG_VGA_ARB=y
CONFIG_VGA_ARB_MAX_GPUS=16
# CONFIG_VGA_SWITCHEROO is not set
CONFIG_DRM=y
CONFIG_DRM_USB=y
CONFIG_DRM_KMS_HELPER=y
CONFIG_DRM_LOAD_EDID_FIRMWARE=y

#
# I2C encoder or helper chips
#
# CONFIG_DRM_I2C_CH7006 is not set
CONFIG_DRM_I2C_SIL164=y
CONFIG_DRM_I2C_NXP_TDA998X=y
# CONFIG_DRM_TDFX is not set
# CONFIG_DRM_R128 is not set
# CONFIG_DRM_RADEON is not set
# CONFIG_DRM_NOUVEAU is not set
# CONFIG_DRM_MGA is not set
# CONFIG_DRM_VIA is not set
# CONFIG_DRM_SAVAGE is not set
# CONFIG_DRM_VMWGFX is not set
# CONFIG_DRM_GMA500 is not set
CONFIG_DRM_UDL=y
# CONFIG_DRM_AST is not set
# CONFIG_DRM_MGAG200 is not set
# CONFIG_DRM_CIRRUS_QEMU is not set
# CONFIG_DRM_QXL is not set
# CONFIG_VGASTATE is not set
# CONFIG_VIDEO_OUTPUT_CONTROL is not set
CONFIG_HDMI=y
CONFIG_FB=y
# CONFIG_FIRMWARE_EDID is not set
# CONFIG_FB_DDC is not set
CONFIG_FB_BOOT_VESA_SUPPORT=y
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
# CONFIG_FB_MODE_HELPERS is not set
# CONFIG_FB_TILEBLITTING is not set

#
# Frame buffer hardware drivers
#
# CONFIG_FB_CIRRUS is not set
# CONFIG_FB_PM2 is not set
# CONFIG_FB_CYBER2000 is not set
CONFIG_FB_ARC=y
# CONFIG_FB_ASILIANT is not set
# CONFIG_FB_IMSTT is not set
# CONFIG_FB_VGA16 is not set
CONFIG_FB_VESA=y
CONFIG_FB_N411=y
# CONFIG_FB_HGA is not set
# CONFIG_FB_S1D13XXX is not set
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
CONFIG_FB_TMIO=y
CONFIG_FB_TMIO_ACCELL=y
# CONFIG_FB_SMSCUFX is not set
# CONFIG_FB_UDL is not set
CONFIG_FB_GOLDFISH=y
# CONFIG_FB_VIRTUAL is not set
CONFIG_FB_METRONOME=y
# CONFIG_FB_MB862XX is not set
CONFIG_FB_BROADSHEET=y
CONFIG_FB_AUO_K190X=y
CONFIG_FB_AUO_K1900=y
CONFIG_FB_AUO_K1901=y
CONFIG_FB_SIMPLE=y
CONFIG_EXYNOS_VIDEO=y
CONFIG_BACKLIGHT_LCD_SUPPORT=y
# CONFIG_LCD_CLASS_DEVICE is not set
CONFIG_BACKLIGHT_CLASS_DEVICE=y
# CONFIG_BACKLIGHT_GENERIC is not set
CONFIG_BACKLIGHT_LM3533=y
CONFIG_BACKLIGHT_DA9052=y
CONFIG_BACKLIGHT_MAX8925=y
# CONFIG_BACKLIGHT_APPLE is not set
CONFIG_BACKLIGHT_SAHARA=y
CONFIG_BACKLIGHT_WM831X=y
# CONFIG_BACKLIGHT_ADP8860 is not set
CONFIG_BACKLIGHT_ADP8870=y
# CONFIG_BACKLIGHT_PCF50633 is not set
# CONFIG_BACKLIGHT_LM3630 is not set
CONFIG_BACKLIGHT_LM3639=y
# CONFIG_BACKLIGHT_LP855X is not set
CONFIG_BACKLIGHT_LV5207LP=y
# CONFIG_BACKLIGHT_BD6107 is not set

#
# Console display driver support
#
CONFIG_VGA_CONSOLE=y
CONFIG_VGACON_SOFT_SCROLLBACK=y
CONFIG_VGACON_SOFT_SCROLLBACK_SIZE=64
CONFIG_DUMMY_CONSOLE=y
CONFIG_FRAMEBUFFER_CONSOLE=y
CONFIG_FRAMEBUFFER_CONSOLE_DETECT_PRIMARY=y
# CONFIG_FRAMEBUFFER_CONSOLE_ROTATION is not set
CONFIG_LOGO=y
CONFIG_LOGO_LINUX_MONO=y
# CONFIG_LOGO_LINUX_VGA16 is not set
# CONFIG_LOGO_LINUX_CLUT224 is not set
CONFIG_SOUND=y
CONFIG_SOUND_OSS_CORE=y
# CONFIG_SOUND_OSS_CORE_PRECLAIM is not set
CONFIG_SND=y
CONFIG_SND_TIMER=y
CONFIG_SND_PCM=y
CONFIG_SND_RAWMIDI=y
CONFIG_SND_COMPRESS_OFFLOAD=y
CONFIG_SND_JACK=y
# CONFIG_SND_SEQUENCER is not set
CONFIG_SND_OSSEMUL=y
# CONFIG_SND_MIXER_OSS is not set
CONFIG_SND_PCM_OSS=y
CONFIG_SND_PCM_OSS_PLUGINS=y
# CONFIG_SND_DYNAMIC_MINORS is not set
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
# CONFIG_SND_DRIVERS is not set
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
# CONFIG_SND_PCMCIA is not set
CONFIG_SND_SOC=y
CONFIG_SND_ATMEL_SOC=y
CONFIG_SND_SOC_I2C_AND_SPI=y
# CONFIG_SND_SIMPLE_CARD is not set
CONFIG_SOUND_PRIME=y
CONFIG_SOUND_OSS=y
# CONFIG_SOUND_TRACEINIT is not set
# CONFIG_SOUND_DMAP is not set
# CONFIG_SOUND_VMIDI is not set
CONFIG_SOUND_TRIX=y
CONFIG_SOUND_MSS=y
# CONFIG_SOUND_MPU401 is not set
CONFIG_SOUND_PAS=y
# CONFIG_PAS_JOYSTICK is not set
CONFIG_SOUND_PSS=y
CONFIG_PSS_MIXER=y
# CONFIG_SOUND_SB is not set
# CONFIG_SOUND_YM3812 is not set
CONFIG_SOUND_UART6850=y
# CONFIG_SOUND_AEDSP16 is not set

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
# CONFIG_HID_ACRUX_FF is not set
CONFIG_HID_APPLE=y
CONFIG_HID_APPLEIR=y
CONFIG_HID_AUREAL=y
CONFIG_HID_BELKIN=y
CONFIG_HID_CHERRY=y
CONFIG_HID_CHICONY=y
CONFIG_HID_PRODIKEYS=y
CONFIG_HID_CYPRESS=y
# CONFIG_HID_DRAGONRISE is not set
CONFIG_HID_EMS_FF=y
CONFIG_HID_ELECOM=y
CONFIG_HID_ELO=y
CONFIG_HID_EZKEY=y
CONFIG_HID_HOLTEK=y
CONFIG_HOLTEK_FF=y
CONFIG_HID_HUION=y
# CONFIG_HID_KEYTOUCH is not set
CONFIG_HID_KYE=y
# CONFIG_HID_UCLOGIC is not set
# CONFIG_HID_WALTOP is not set
CONFIG_HID_GYRATION=y
CONFIG_HID_ICADE=y
# CONFIG_HID_TWINHAN is not set
CONFIG_HID_KENSINGTON=y
CONFIG_HID_LCPOWER=y
# CONFIG_HID_LENOVO_TPKBD is not set
CONFIG_HID_LOGITECH=y
# CONFIG_HID_LOGITECH_DJ is not set
CONFIG_LOGITECH_FF=y
CONFIG_LOGIRUMBLEPAD2_FF=y
# CONFIG_LOGIG940_FF is not set
# CONFIG_LOGIWHEELS_FF is not set
CONFIG_HID_MAGICMOUSE=y
CONFIG_HID_MICROSOFT=y
CONFIG_HID_MONTEREY=y
CONFIG_HID_MULTITOUCH=y
CONFIG_HID_NTRIG=y
CONFIG_HID_ORTEK=y
CONFIG_HID_PANTHERLORD=y
# CONFIG_PANTHERLORD_FF is not set
CONFIG_HID_PETALYNX=y
CONFIG_HID_PICOLCD=y
CONFIG_HID_PICOLCD_FB=y
CONFIG_HID_PICOLCD_BACKLIGHT=y
CONFIG_HID_PICOLCD_LEDS=y
CONFIG_HID_PRIMAX=y
CONFIG_HID_ROCCAT=y
CONFIG_HID_SAITEK=y
CONFIG_HID_SAMSUNG=y
CONFIG_HID_SONY=y
# CONFIG_HID_SPEEDLINK is not set
# CONFIG_HID_STEELSERIES is not set
# CONFIG_HID_SUNPLUS is not set
# CONFIG_HID_GREENASIA is not set
# CONFIG_HID_SMARTJOYPLUS is not set
CONFIG_HID_TIVO=y
CONFIG_HID_TOPSEED=y
CONFIG_HID_THINGM=y
CONFIG_HID_THRUSTMASTER=y
CONFIG_THRUSTMASTER_FF=y
# CONFIG_HID_WACOM is not set
# CONFIG_HID_WIIMOTE is not set
CONFIG_HID_XINMO=y
# CONFIG_HID_ZEROPLUS is not set
CONFIG_HID_ZYDACRON=y
CONFIG_HID_SENSOR_HUB=y

#
# USB HID support
#
CONFIG_USB_HID=y
CONFIG_HID_PID=y
CONFIG_USB_HIDDEV=y

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
CONFIG_USB_DYNAMIC_MINORS=y
# CONFIG_USB_MON is not set
# CONFIG_USB_WUSB_CBAF is not set

#
# USB Host Controller Drivers
#
# CONFIG_USB_C67X00_HCD is not set
CONFIG_USB_XHCI_HCD=y
CONFIG_USB_XHCI_PLATFORM=y
CONFIG_USB_EHCI_HCD=y
CONFIG_USB_EHCI_ROOT_HUB_TT=y
CONFIG_USB_EHCI_TT_NEWSCHED=y
CONFIG_USB_EHCI_PCI=y
# CONFIG_USB_EHCI_HCD_PLATFORM is not set
# CONFIG_USB_OXU210HP_HCD is not set
CONFIG_USB_ISP116X_HCD=y
# CONFIG_USB_ISP1760_HCD is not set
# CONFIG_USB_ISP1362_HCD is not set
CONFIG_USB_FUSBH200_HCD=y
# CONFIG_USB_FOTG210_HCD is not set
CONFIG_USB_OHCI_HCD=y
CONFIG_USB_OHCI_HCD_PCI=y
CONFIG_USB_OHCI_HCD_PLATFORM=y
# CONFIG_USB_UHCI_HCD is not set
# CONFIG_USB_U132_HCD is not set
CONFIG_USB_SL811_HCD=y
CONFIG_USB_SL811_HCD_ISO=y
CONFIG_USB_SL811_CS=y
CONFIG_USB_R8A66597_HCD=y
# CONFIG_USB_RENESAS_USBHS_HCD is not set
CONFIG_USB_HCD_TEST_MODE=y
# CONFIG_USB_MUSB_HDRC is not set
CONFIG_USB_RENESAS_USBHS=y

#
# USB Device Class drivers
#
# CONFIG_USB_ACM is not set
CONFIG_USB_PRINTER=y
CONFIG_USB_WDM=y
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
CONFIG_USB_MDC800=y
CONFIG_USB_DWC3=y
# CONFIG_USB_DWC3_HOST is not set
# CONFIG_USB_DWC3_GADGET is not set
CONFIG_USB_DWC3_DUAL_ROLE=y

#
# Platform Glue Driver Support
#
# CONFIG_USB_DWC3_OMAP is not set
CONFIG_USB_DWC3_EXYNOS=y
CONFIG_USB_DWC3_PCI=y

#
# Debugging features
#
# CONFIG_USB_DWC3_DEBUG is not set
CONFIG_USB_CHIPIDEA=y
# CONFIG_USB_CHIPIDEA_UDC is not set
# CONFIG_USB_CHIPIDEA_HOST is not set
CONFIG_USB_CHIPIDEA_DEBUG=y

#
# USB port drivers
#
CONFIG_USB_SERIAL=y
CONFIG_USB_SERIAL_CONSOLE=y
CONFIG_USB_SERIAL_GENERIC=y
CONFIG_USB_SERIAL_SIMPLE=y
# CONFIG_USB_SERIAL_AIRCABLE is not set
CONFIG_USB_SERIAL_ARK3116=y
CONFIG_USB_SERIAL_BELKIN=y
CONFIG_USB_SERIAL_CH341=y
# CONFIG_USB_SERIAL_WHITEHEAT is not set
CONFIG_USB_SERIAL_DIGI_ACCELEPORT=y
# CONFIG_USB_SERIAL_CP210X is not set
CONFIG_USB_SERIAL_CYPRESS_M8=y
CONFIG_USB_SERIAL_EMPEG=y
CONFIG_USB_SERIAL_FTDI_SIO=y
CONFIG_USB_SERIAL_VISOR=y
# CONFIG_USB_SERIAL_IPAQ is not set
CONFIG_USB_SERIAL_IR=y
# CONFIG_USB_SERIAL_EDGEPORT is not set
# CONFIG_USB_SERIAL_EDGEPORT_TI is not set
# CONFIG_USB_SERIAL_F81232 is not set
# CONFIG_USB_SERIAL_GARMIN is not set
CONFIG_USB_SERIAL_IPW=y
CONFIG_USB_SERIAL_IUU=y
# CONFIG_USB_SERIAL_KEYSPAN_PDA is not set
CONFIG_USB_SERIAL_KEYSPAN=y
# CONFIG_USB_SERIAL_KLSI is not set
# CONFIG_USB_SERIAL_KOBIL_SCT is not set
CONFIG_USB_SERIAL_MCT_U232=y
# CONFIG_USB_SERIAL_METRO is not set
CONFIG_USB_SERIAL_MOS7720=y
CONFIG_USB_SERIAL_MOS7840=y
CONFIG_USB_SERIAL_NAVMAN=y
CONFIG_USB_SERIAL_PL2303=y
# CONFIG_USB_SERIAL_OTI6858 is not set
CONFIG_USB_SERIAL_QCAUX=y
# CONFIG_USB_SERIAL_QUALCOMM is not set
CONFIG_USB_SERIAL_SPCP8X5=y
CONFIG_USB_SERIAL_SAFE=y
# CONFIG_USB_SERIAL_SAFE_PADDED is not set
CONFIG_USB_SERIAL_SIERRAWIRELESS=y
# CONFIG_USB_SERIAL_SYMBOL is not set
# CONFIG_USB_SERIAL_TI is not set
CONFIG_USB_SERIAL_CYBERJACK=y
# CONFIG_USB_SERIAL_XIRCOM is not set
CONFIG_USB_SERIAL_WWAN=y
CONFIG_USB_SERIAL_OPTION=y
CONFIG_USB_SERIAL_OMNINET=y
# CONFIG_USB_SERIAL_OPTICON is not set
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
CONFIG_USB_RIO500=y
CONFIG_USB_LEGOTOWER=y
CONFIG_USB_LCD=y
CONFIG_USB_LED=y
CONFIG_USB_CYPRESS_CY7C63=y
CONFIG_USB_CYTHERM=y
CONFIG_USB_IDMOUSE=y
CONFIG_USB_FTDI_ELAN=y
# CONFIG_USB_APPLEDISPLAY is not set
# CONFIG_USB_SISUSBVGA is not set
# CONFIG_USB_LD is not set
CONFIG_USB_TRANCEVIBRATOR=y
# CONFIG_USB_IOWARRIOR is not set
# CONFIG_USB_TEST is not set
CONFIG_USB_EHSET_TEST_FIXTURE=y
# CONFIG_USB_ISIGHTFW is not set
# CONFIG_USB_YUREX is not set
CONFIG_USB_EZUSB_FX2=y
CONFIG_USB_HSIC_USB3503=y

#
# USB Physical Layer drivers
#
CONFIG_USB_PHY=y
CONFIG_NOP_USB_XCEIV=y
# CONFIG_AM335X_PHY_USB is not set
CONFIG_SAMSUNG_USBPHY=y
CONFIG_SAMSUNG_USB2PHY=y
# CONFIG_SAMSUNG_USB3PHY is not set
CONFIG_USB_ISP1301=y
CONFIG_USB_RCAR_PHY=y
CONFIG_USB_GADGET=y
CONFIG_USB_GADGET_DEBUG=y
# CONFIG_USB_GADGET_DEBUG_FILES is not set
CONFIG_USB_GADGET_VBUS_DRAW=2
CONFIG_USB_GADGET_STORAGE_NUM_BUFFERS=2

#
# USB Peripheral Controller
#
CONFIG_USB_FOTG210_UDC=y
CONFIG_USB_R8A66597=y
# CONFIG_USB_RENESAS_USBHS_UDC is not set
# CONFIG_USB_PXA27X is not set
CONFIG_USB_MV_UDC=y
CONFIG_USB_MV_U3D=y
# CONFIG_USB_M66592 is not set
# CONFIG_USB_AMD5536UDC is not set
# CONFIG_USB_NET2272 is not set
# CONFIG_USB_NET2280 is not set
# CONFIG_USB_GOKU is not set
# CONFIG_USB_EG20T is not set
CONFIG_USB_DUMMY_HCD=y
CONFIG_USB_LIBCOMPOSITE=y
# CONFIG_USB_CONFIGFS is not set
# CONFIG_USB_ZERO is not set
CONFIG_USB_AUDIO=y
CONFIG_GADGET_UAC1=y
# CONFIG_USB_ETH is not set
# CONFIG_USB_G_NCM is not set
# CONFIG_USB_GADGETFS is not set
# CONFIG_USB_FUNCTIONFS is not set
# CONFIG_USB_MASS_STORAGE is not set
# CONFIG_USB_G_SERIAL is not set
# CONFIG_USB_MIDI_GADGET is not set
# CONFIG_USB_G_PRINTER is not set
# CONFIG_USB_CDC_COMPOSITE is not set
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
# CONFIG_MMC_BLOCK_BOUNCE is not set
CONFIG_SDIO_UART=y
CONFIG_MMC_TEST=y

#
# MMC/SD/SDIO Host Controller Drivers
#
CONFIG_MMC_SDHCI=y
# CONFIG_MMC_SDHCI_PCI is not set
# CONFIG_MMC_SDHCI_ACPI is not set
CONFIG_MMC_SDHCI_PLTFM=y
# CONFIG_MMC_WBSD is not set
# CONFIG_MMC_TIFM_SD is not set
# CONFIG_MMC_SDRICOH_CS is not set
# CONFIG_MMC_CB710 is not set
# CONFIG_MMC_VIA_SDMMC is not set
CONFIG_MMC_VUB300=y
CONFIG_MMC_USHC=y
CONFIG_MEMSTICK=y
# CONFIG_MEMSTICK_DEBUG is not set

#
# MemoryStick drivers
#
CONFIG_MEMSTICK_UNSAFE_RESUME=y
# CONFIG_MSPRO_BLOCK is not set
CONFIG_MS_BLOCK=y

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
CONFIG_LEDS_LM3530=y
CONFIG_LEDS_LM3533=y
CONFIG_LEDS_LM3642=y
# CONFIG_LEDS_PCA9532 is not set
# CONFIG_LEDS_LP3944 is not set
CONFIG_LEDS_LP55XX_COMMON=y
CONFIG_LEDS_LP5521=y
# CONFIG_LEDS_LP5523 is not set
CONFIG_LEDS_LP5562=y
CONFIG_LEDS_LP8501=y
CONFIG_LEDS_CLEVO_MAIL=y
# CONFIG_LEDS_PCA955X is not set
CONFIG_LEDS_PCA963X=y
CONFIG_LEDS_WM831X_STATUS=y
CONFIG_LEDS_WM8350=y
CONFIG_LEDS_DA9052=y
# CONFIG_LEDS_REGULATOR is not set
# CONFIG_LEDS_BD2802 is not set
# CONFIG_LEDS_INTEL_SS4200 is not set
CONFIG_LEDS_MC13783=y
CONFIG_LEDS_TCA6507=y
# CONFIG_LEDS_LM355x is not set
# CONFIG_LEDS_OT200 is not set
CONFIG_LEDS_BLINKM=y

#
# LED Triggers
#
CONFIG_LEDS_TRIGGERS=y
CONFIG_LEDS_TRIGGER_TIMER=y
CONFIG_LEDS_TRIGGER_ONESHOT=y
# CONFIG_LEDS_TRIGGER_HEARTBEAT is not set
CONFIG_LEDS_TRIGGER_BACKLIGHT=y
CONFIG_LEDS_TRIGGER_CPU=y
# CONFIG_LEDS_TRIGGER_DEFAULT_ON is not set

#
# iptables trigger is under Netfilter config (LED target)
#
CONFIG_LEDS_TRIGGER_TRANSIENT=y
CONFIG_LEDS_TRIGGER_CAMERA=y
CONFIG_ACCESSIBILITY=y
CONFIG_A11Y_BRAILLE_CONSOLE=y
# CONFIG_INFINIBAND is not set
CONFIG_EDAC=y
CONFIG_EDAC_LEGACY_SYSFS=y
CONFIG_EDAC_DEBUG=y
CONFIG_EDAC_MM_EDAC=y
# CONFIG_EDAC_E752X is not set
# CONFIG_EDAC_I82975X is not set
# CONFIG_EDAC_I3000 is not set
# CONFIG_EDAC_I3200 is not set
# CONFIG_EDAC_X38 is not set
# CONFIG_EDAC_I5400 is not set
# CONFIG_EDAC_I5000 is not set
# CONFIG_EDAC_I5100 is not set
# CONFIG_EDAC_I7300 is not set
CONFIG_RTC_LIB=y
CONFIG_RTC_CLASS=y
# CONFIG_RTC_HCTOSYS is not set
# CONFIG_RTC_SYSTOHC is not set
CONFIG_RTC_DEBUG=y

#
# RTC interfaces
#
CONFIG_RTC_INTF_SYSFS=y
CONFIG_RTC_INTF_PROC=y
# CONFIG_RTC_INTF_DEV is not set
CONFIG_RTC_DRV_TEST=y

#
# I2C RTC drivers
#
CONFIG_RTC_DRV_88PM80X=y
CONFIG_RTC_DRV_DS1307=y
CONFIG_RTC_DRV_DS1374=y
CONFIG_RTC_DRV_DS1672=y
CONFIG_RTC_DRV_DS3232=y
CONFIG_RTC_DRV_MAX6900=y
CONFIG_RTC_DRV_MAX8907=y
# CONFIG_RTC_DRV_MAX8925 is not set
CONFIG_RTC_DRV_MAX8998=y
CONFIG_RTC_DRV_RS5C372=y
# CONFIG_RTC_DRV_ISL1208 is not set
CONFIG_RTC_DRV_ISL12022=y
# CONFIG_RTC_DRV_X1205 is not set
CONFIG_RTC_DRV_PCF2127=y
CONFIG_RTC_DRV_PCF8523=y
# CONFIG_RTC_DRV_PCF8563 is not set
CONFIG_RTC_DRV_PCF8583=y
# CONFIG_RTC_DRV_M41T80 is not set
CONFIG_RTC_DRV_BQ32K=y
# CONFIG_RTC_DRV_S35390A is not set
# CONFIG_RTC_DRV_FM3130 is not set
CONFIG_RTC_DRV_RX8581=y
CONFIG_RTC_DRV_RX8025=y
CONFIG_RTC_DRV_EM3027=y
# CONFIG_RTC_DRV_RV3029C2 is not set

#
# SPI RTC drivers
#

#
# Platform RTC drivers
#
CONFIG_RTC_DRV_CMOS=y
CONFIG_RTC_DRV_DS1286=y
CONFIG_RTC_DRV_DS1511=y
# CONFIG_RTC_DRV_DS1553 is not set
# CONFIG_RTC_DRV_DS1742 is not set
CONFIG_RTC_DRV_DA9052=y
CONFIG_RTC_DRV_DA9055=y
CONFIG_RTC_DRV_STK17TA8=y
CONFIG_RTC_DRV_M48T86=y
# CONFIG_RTC_DRV_M48T35 is not set
# CONFIG_RTC_DRV_M48T59 is not set
# CONFIG_RTC_DRV_MSM6242 is not set
CONFIG_RTC_DRV_BQ4802=y
CONFIG_RTC_DRV_RP5C01=y
CONFIG_RTC_DRV_V3020=y
# CONFIG_RTC_DRV_DS2404 is not set
CONFIG_RTC_DRV_WM831X=y
# CONFIG_RTC_DRV_WM8350 is not set
CONFIG_RTC_DRV_PCF50633=y

#
# on-CPU RTC drivers
#
CONFIG_RTC_DRV_MC13XXX=y
CONFIG_RTC_DRV_MOXART=y

#
# HID Sensor RTC drivers
#
CONFIG_RTC_DRV_HID_SENSOR_TIME=y
# CONFIG_DMADEVICES is not set
# CONFIG_AUXDISPLAY is not set
CONFIG_UIO=y
# CONFIG_UIO_CIF is not set
CONFIG_UIO_PDRV_GENIRQ=y
# CONFIG_UIO_DMEM_GENIRQ is not set
# CONFIG_UIO_AEC is not set
# CONFIG_UIO_SERCOS3 is not set
# CONFIG_UIO_PCI_GENERIC is not set
# CONFIG_UIO_NETX is not set
# CONFIG_UIO_MF624 is not set
# CONFIG_VIRT_DRIVERS is not set
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
# CONFIG_STAGING is not set
CONFIG_X86_PLATFORM_DEVICES=y
# CONFIG_ACERHDF is not set
# CONFIG_ASUS_LAPTOP is not set
CONFIG_CHROMEOS_LAPTOP=y
# CONFIG_DELL_LAPTOP is not set
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
CONFIG_REMOTEPROC=y
CONFIG_STE_MODEM_RPROC=y

#
# Rpmsg drivers
#
CONFIG_PM_DEVFREQ=y

#
# DEVFREQ Governors
#
CONFIG_DEVFREQ_GOV_SIMPLE_ONDEMAND=y
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
# CONFIG_EXTCON_ADC_JACK is not set
CONFIG_EXTCON_ARIZONA=y
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
CONFIG_HID_SENSOR_ACCEL_3D=y
CONFIG_IIO_ST_ACCEL_3AXIS=y
CONFIG_IIO_ST_ACCEL_I2C_3AXIS=y

#
# Analog to digital converters
#
CONFIG_MAX1363=y
# CONFIG_NAU7802 is not set
CONFIG_TI_ADC081C=y
CONFIG_TI_AM335X_ADC=y
CONFIG_VIPERBOARD_ADC=y

#
# Amplifiers
#

#
# Hid Sensor IIO Common
#
CONFIG_HID_SENSOR_IIO_COMMON=y
CONFIG_HID_SENSOR_IIO_TRIGGER=y
CONFIG_HID_SENSOR_ENUM_BASE_QUIRKS=y
CONFIG_IIO_ST_SENSORS_I2C=y
CONFIG_IIO_ST_SENSORS_CORE=y

#
# Digital to analog converters
#
# CONFIG_AD5064 is not set
# CONFIG_AD5380 is not set
# CONFIG_AD5446 is not set
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
CONFIG_ITG3200=y

#
# Inertial measurement units
#
CONFIG_INV_MPU6050_IIO=y

#
# Light sensors
#
# CONFIG_ADJD_S311 is not set
# CONFIG_APDS9300 is not set
CONFIG_HID_SENSOR_ALS=y
# CONFIG_SENSORS_LM3533 is not set
# CONFIG_SENSORS_TSL2563 is not set
CONFIG_VCNL4000=y

#
# Magnetometer sensors
#
CONFIG_HID_SENSOR_MAGNETOMETER_3D=y
CONFIG_IIO_ST_MAGN_3AXIS=y
CONFIG_IIO_ST_MAGN_I2C_3AXIS=y

#
# Triggers - standalone
#
CONFIG_IIO_INTERRUPT_TRIGGER=y
CONFIG_IIO_SYSFS_TRIGGER=y

#
# Pressure sensors
#
# CONFIG_IIO_ST_PRESS is not set

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
# CONFIG_RESET_CONTROLLER is not set
# CONFIG_FMC is not set

#
# Firmware Drivers
#
# CONFIG_EDD is not set
CONFIG_FIRMWARE_MEMMAP=y
CONFIG_DELL_RBU=y
CONFIG_DCDBAS=y
# CONFIG_DMIID is not set
# CONFIG_DMI_SYSFS is not set
CONFIG_ISCSI_IBFT_FIND=y
# CONFIG_GOOGLE_FIRMWARE is not set

#
# File systems
#
CONFIG_DCACHE_WORD_ACCESS=y
CONFIG_EXT2_FS=y
# CONFIG_EXT2_FS_XATTR is not set
CONFIG_EXT2_FS_XIP=y
CONFIG_EXT3_FS=y
CONFIG_EXT3_DEFAULTS_TO_ORDERED=y
# CONFIG_EXT3_FS_XATTR is not set
CONFIG_EXT4_FS=y
CONFIG_EXT4_FS_POSIX_ACL=y
# CONFIG_EXT4_FS_SECURITY is not set
CONFIG_EXT4_DEBUG=y
CONFIG_FS_XIP=y
CONFIG_JBD=y
CONFIG_JBD2=y
CONFIG_JBD2_DEBUG=y
CONFIG_FS_MBCACHE=y
CONFIG_REISERFS_FS=y
# CONFIG_REISERFS_CHECK is not set
CONFIG_REISERFS_PROC_INFO=y
# CONFIG_REISERFS_FS_XATTR is not set
CONFIG_JFS_FS=y
# CONFIG_JFS_POSIX_ACL is not set
CONFIG_JFS_SECURITY=y
# CONFIG_JFS_DEBUG is not set
CONFIG_JFS_STATISTICS=y
CONFIG_XFS_FS=y
# CONFIG_XFS_QUOTA is not set
# CONFIG_XFS_POSIX_ACL is not set
# CONFIG_XFS_RT is not set
CONFIG_XFS_DEBUG=y
CONFIG_GFS2_FS=y
# CONFIG_OCFS2_FS is not set
# CONFIG_BTRFS_FS is not set
CONFIG_NILFS2_FS=y
CONFIG_FS_POSIX_ACL=y
CONFIG_EXPORTFS=y
CONFIG_FILE_LOCKING=y
CONFIG_FSNOTIFY=y
CONFIG_DNOTIFY=y
# CONFIG_INOTIFY_USER is not set
CONFIG_FANOTIFY=y
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
CONFIG_FSCACHE=y
# CONFIG_FSCACHE_STATS is not set
# CONFIG_FSCACHE_HISTOGRAM is not set
# CONFIG_FSCACHE_DEBUG is not set
# CONFIG_FSCACHE_OBJECT_LIST is not set
CONFIG_CACHEFILES=y
CONFIG_CACHEFILES_DEBUG=y
# CONFIG_CACHEFILES_HISTOGRAM is not set

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
# CONFIG_VFAT_FS is not set
CONFIG_FAT_DEFAULT_CODEPAGE=437
CONFIG_NTFS_FS=y
# CONFIG_NTFS_DEBUG is not set
CONFIG_NTFS_RW=y

#
# Pseudo filesystems
#
CONFIG_PROC_FS=y
# CONFIG_PROC_KCORE is not set
CONFIG_PROC_SYSCTL=y
CONFIG_PROC_PAGE_MONITOR=y
CONFIG_SYSFS=y
# CONFIG_TMPFS is not set
# CONFIG_HUGETLBFS is not set
# CONFIG_HUGETLB_PAGE is not set
CONFIG_CONFIGFS_FS=y
# CONFIG_MISC_FILESYSTEMS is not set
CONFIG_NETWORK_FILESYSTEMS=y
CONFIG_NLS=y
CONFIG_NLS_DEFAULT="iso8859-1"
CONFIG_NLS_CODEPAGE_437=y
# CONFIG_NLS_CODEPAGE_737 is not set
CONFIG_NLS_CODEPAGE_775=y
CONFIG_NLS_CODEPAGE_850=y
CONFIG_NLS_CODEPAGE_852=y
CONFIG_NLS_CODEPAGE_855=y
CONFIG_NLS_CODEPAGE_857=y
CONFIG_NLS_CODEPAGE_860=y
# CONFIG_NLS_CODEPAGE_861 is not set
CONFIG_NLS_CODEPAGE_862=y
# CONFIG_NLS_CODEPAGE_863 is not set
# CONFIG_NLS_CODEPAGE_864 is not set
# CONFIG_NLS_CODEPAGE_865 is not set
# CONFIG_NLS_CODEPAGE_866 is not set
# CONFIG_NLS_CODEPAGE_869 is not set
CONFIG_NLS_CODEPAGE_936=y
CONFIG_NLS_CODEPAGE_950=y
CONFIG_NLS_CODEPAGE_932=y
# CONFIG_NLS_CODEPAGE_949 is not set
CONFIG_NLS_CODEPAGE_874=y
# CONFIG_NLS_ISO8859_8 is not set
CONFIG_NLS_CODEPAGE_1250=y
CONFIG_NLS_CODEPAGE_1251=y
# CONFIG_NLS_ASCII is not set
# CONFIG_NLS_ISO8859_1 is not set
CONFIG_NLS_ISO8859_2=y
CONFIG_NLS_ISO8859_3=y
CONFIG_NLS_ISO8859_4=y
# CONFIG_NLS_ISO8859_5 is not set
CONFIG_NLS_ISO8859_6=y
CONFIG_NLS_ISO8859_7=y
# CONFIG_NLS_ISO8859_9 is not set
# CONFIG_NLS_ISO8859_13 is not set
# CONFIG_NLS_ISO8859_14 is not set
# CONFIG_NLS_ISO8859_15 is not set
# CONFIG_NLS_KOI8_R is not set
# CONFIG_NLS_KOI8_U is not set
# CONFIG_NLS_MAC_ROMAN is not set
# CONFIG_NLS_MAC_CELTIC is not set
# CONFIG_NLS_MAC_CENTEURO is not set
# CONFIG_NLS_MAC_CROATIAN is not set
CONFIG_NLS_MAC_CYRILLIC=y
CONFIG_NLS_MAC_GAELIC=y
CONFIG_NLS_MAC_GREEK=y
CONFIG_NLS_MAC_ICELAND=y
CONFIG_NLS_MAC_INUIT=y
CONFIG_NLS_MAC_ROMANIAN=y
CONFIG_NLS_MAC_TURKISH=y
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

#
# Compile-time checks and compiler options
#
# CONFIG_DEBUG_INFO is not set
# CONFIG_ENABLE_WARN_DEPRECATED is not set
CONFIG_ENABLE_MUST_CHECK=y
CONFIG_FRAME_WARN=2048
CONFIG_STRIP_ASM_SYMS=y
CONFIG_READABLE_ASM=y
# CONFIG_UNUSED_SYMBOLS is not set
# CONFIG_DEBUG_FS is not set
# CONFIG_HEADERS_CHECK is not set
CONFIG_DEBUG_SECTION_MISMATCH=y
CONFIG_ARCH_WANT_FRAME_POINTERS=y
CONFIG_FRAME_POINTER=y
CONFIG_DEBUG_FORCE_WEAK_PER_CPU=y
CONFIG_MAGIC_SYSRQ=y
CONFIG_DEBUG_KERNEL=y

#
# Memory Debugging
#
# CONFIG_DEBUG_PAGEALLOC is not set
CONFIG_DEBUG_OBJECTS=y
# CONFIG_DEBUG_OBJECTS_SELFTEST is not set
# CONFIG_DEBUG_OBJECTS_FREE is not set
# CONFIG_DEBUG_OBJECTS_TIMERS is not set
CONFIG_DEBUG_OBJECTS_WORK=y
CONFIG_DEBUG_OBJECTS_RCU_HEAD=y
# CONFIG_DEBUG_OBJECTS_PERCPU_COUNTER is not set
CONFIG_DEBUG_OBJECTS_ENABLE_DEFAULT=1
# CONFIG_SLUB_DEBUG_ON is not set
CONFIG_SLUB_STATS=y
CONFIG_HAVE_DEBUG_KMEMLEAK=y
# CONFIG_DEBUG_KMEMLEAK is not set
# CONFIG_DEBUG_STACK_USAGE is not set
CONFIG_DEBUG_VM=y
CONFIG_DEBUG_VM_RB=y
CONFIG_DEBUG_VIRTUAL=y
CONFIG_DEBUG_MEMORY_INIT=y
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
# CONFIG_BOOTPARAM_HARDLOCKUP_PANIC is not set
CONFIG_BOOTPARAM_HARDLOCKUP_PANIC_VALUE=0
# CONFIG_BOOTPARAM_SOFTLOCKUP_PANIC is not set
CONFIG_BOOTPARAM_SOFTLOCKUP_PANIC_VALUE=0
# CONFIG_DETECT_HUNG_TASK is not set
# CONFIG_PANIC_ON_OOPS is not set
CONFIG_PANIC_ON_OOPS_VALUE=0
CONFIG_SCHED_DEBUG=y
CONFIG_SCHEDSTATS=y
CONFIG_TIMER_STATS=y
CONFIG_DEBUG_PREEMPT=y

#
# Lock Debugging (spinlocks, mutexes, etc...)
#
CONFIG_DEBUG_RT_MUTEXES=y
CONFIG_DEBUG_PI_LIST=y
# CONFIG_RT_MUTEX_TESTER is not set
CONFIG_DEBUG_SPINLOCK=y
CONFIG_DEBUG_MUTEXES=y
# CONFIG_DEBUG_WW_MUTEX_SLOWPATH is not set
CONFIG_DEBUG_LOCK_ALLOC=y
CONFIG_PROVE_LOCKING=y
CONFIG_LOCKDEP=y
CONFIG_LOCK_STAT=y
CONFIG_DEBUG_LOCKDEP=y
CONFIG_DEBUG_ATOMIC_SLEEP=y
# CONFIG_DEBUG_LOCKING_API_SELFTESTS is not set
CONFIG_TRACE_IRQFLAGS=y
CONFIG_STACKTRACE=y
# CONFIG_DEBUG_KOBJECT is not set
# CONFIG_DEBUG_KOBJECT_RELEASE is not set
CONFIG_DEBUG_BUGVERBOSE=y
CONFIG_DEBUG_WRITECOUNT=y
CONFIG_DEBUG_LIST=y
CONFIG_DEBUG_SG=y
CONFIG_DEBUG_NOTIFIERS=y
CONFIG_DEBUG_CREDENTIALS=y

#
# RCU Debugging
#
# CONFIG_PROVE_RCU is not set
# CONFIG_PROVE_RCU_DELAY is not set
CONFIG_SPARSE_RCU_POINTER=y
# CONFIG_RCU_TORTURE_TEST is not set
CONFIG_RCU_CPU_STALL_TIMEOUT=21
CONFIG_RCU_CPU_STALL_VERBOSE=y
# CONFIG_RCU_CPU_STALL_INFO is not set
# CONFIG_RCU_TRACE is not set
# CONFIG_DEBUG_BLOCK_EXT_DEVT is not set
# CONFIG_NOTIFIER_ERROR_INJECTION is not set
# CONFIG_FAULT_INJECTION is not set
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
CONFIG_TRACING_SUPPORT=y
# CONFIG_FTRACE is not set

#
# Runtime Testing
#
# CONFIG_TEST_LIST_SORT is not set
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
# CONFIG_STRICT_DEVMEM is not set
CONFIG_X86_VERBOSE_BOOTUP=y
CONFIG_EARLY_PRINTK=y
# CONFIG_EARLY_PRINTK_DBGP is not set
# CONFIG_X86_PTDUMP is not set
# CONFIG_DEBUG_RODATA is not set
CONFIG_DOUBLEFAULT=y
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
# CONFIG_CPA_DEBUG is not set
CONFIG_OPTIMIZE_INLINING=y
CONFIG_DEBUG_NMI_SELFTEST=y
CONFIG_X86_DEBUG_STATIC_CPU_HAS=y

#
# Security options
#
CONFIG_KEYS=y
# CONFIG_ENCRYPTED_KEYS is not set
CONFIG_KEYS_DEBUG_PROC_KEYS=y
# CONFIG_SECURITY_DMESG_RESTRICT is not set
# CONFIG_SECURITY is not set
# CONFIG_SECURITYFS is not set
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
CONFIG_CRYPTO_PCOMP2=y
CONFIG_CRYPTO_MANAGER=y
CONFIG_CRYPTO_MANAGER2=y
# CONFIG_CRYPTO_USER is not set
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
# CONFIG_CRYPTO_CBC is not set
CONFIG_CRYPTO_CTR=y
# CONFIG_CRYPTO_CTS is not set
CONFIG_CRYPTO_ECB=y
CONFIG_CRYPTO_LRW=y
# CONFIG_CRYPTO_PCBC is not set
CONFIG_CRYPTO_XTS=y

#
# Hash modes
#
CONFIG_CRYPTO_CMAC=y
CONFIG_CRYPTO_HMAC=y
CONFIG_CRYPTO_XCBC=y
# CONFIG_CRYPTO_VMAC is not set

#
# Digest
#
CONFIG_CRYPTO_CRC32C=y
# CONFIG_CRYPTO_CRC32C_INTEL is not set
# CONFIG_CRYPTO_CRC32 is not set
CONFIG_CRYPTO_CRC32_PCLMUL=y
CONFIG_CRYPTO_CRCT10DIF=y
CONFIG_CRYPTO_CRCT10DIF_PCLMUL=y
CONFIG_CRYPTO_GHASH=y
CONFIG_CRYPTO_MD4=y
CONFIG_CRYPTO_MD5=y
CONFIG_CRYPTO_MICHAEL_MIC=y
# CONFIG_CRYPTO_RMD128 is not set
CONFIG_CRYPTO_RMD160=y
CONFIG_CRYPTO_RMD256=y
# CONFIG_CRYPTO_RMD320 is not set
CONFIG_CRYPTO_SHA1=y
# CONFIG_CRYPTO_SHA1_SSSE3 is not set
CONFIG_CRYPTO_SHA256_SSSE3=y
# CONFIG_CRYPTO_SHA512_SSSE3 is not set
CONFIG_CRYPTO_SHA256=y
CONFIG_CRYPTO_SHA512=y
# CONFIG_CRYPTO_TGR192 is not set
# CONFIG_CRYPTO_WP512 is not set
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
# CONFIG_CRYPTO_BLOWFISH_X86_64 is not set
# CONFIG_CRYPTO_CAMELLIA is not set
CONFIG_CRYPTO_CAMELLIA_X86_64=y
CONFIG_CRYPTO_CAMELLIA_AESNI_AVX_X86_64=y
CONFIG_CRYPTO_CAMELLIA_AESNI_AVX2_X86_64=y
CONFIG_CRYPTO_CAST_COMMON=y
CONFIG_CRYPTO_CAST5=y
CONFIG_CRYPTO_CAST5_AVX_X86_64=y
CONFIG_CRYPTO_CAST6=y
CONFIG_CRYPTO_CAST6_AVX_X86_64=y
CONFIG_CRYPTO_DES=y
CONFIG_CRYPTO_FCRYPT=y
# CONFIG_CRYPTO_KHAZAD is not set
CONFIG_CRYPTO_SALSA20=y
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
CONFIG_CRYPTO_TWOFISH_AVX_X86_64=y

#
# Compression
#
CONFIG_CRYPTO_DEFLATE=y
# CONFIG_CRYPTO_ZLIB is not set
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
# CONFIG_ASYMMETRIC_KEY_TYPE is not set
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
# CONFIG_CRC_CCITT is not set
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
CONFIG_ZLIB_INFLATE=y
CONFIG_ZLIB_DEFLATE=y
CONFIG_LZO_COMPRESS=y
CONFIG_LZO_DECOMPRESS=y
CONFIG_LZ4_COMPRESS=y
CONFIG_LZ4HC_COMPRESS=y
CONFIG_LZ4_DECOMPRESS=y
CONFIG_XZ_DEC=y
# CONFIG_XZ_DEC_X86 is not set
CONFIG_XZ_DEC_POWERPC=y
# CONFIG_XZ_DEC_IA64 is not set
CONFIG_XZ_DEC_ARM=y
# CONFIG_XZ_DEC_ARMTHUMB is not set
CONFIG_XZ_DEC_SPARC=y
CONFIG_XZ_DEC_BCJ=y
CONFIG_XZ_DEC_TEST=y
CONFIG_DECOMPRESS_GZIP=y
CONFIG_DECOMPRESS_BZIP2=y
CONFIG_DECOMPRESS_LZMA=y
CONFIG_DECOMPRESS_XZ=y
CONFIG_DECOMPRESS_LZO=y
CONFIG_DECOMPRESS_LZ4=y
CONFIG_BCH=y
CONFIG_BCH_CONST_PARAMS=y
CONFIG_HAS_IOMEM=y
CONFIG_HAS_IOPORT=y
CONFIG_HAS_DMA=y
CONFIG_DQL=y
CONFIG_NLATTR=y
CONFIG_ARCH_HAS_ATOMIC64_DEC_IF_POSITIVE=y
CONFIG_AVERAGE=y
CONFIG_CORDIC=y
# CONFIG_DDR is not set
CONFIG_FONT_SUPPORT=y
# CONFIG_FONTS is not set
CONFIG_FONT_8x8=y
CONFIG_FONT_8x16=y

--yrj/dFKFPuw6o+aM--
