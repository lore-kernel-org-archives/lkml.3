Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758631AbaCTNJf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Mar 2014 09:09:35 -0400
Received: from mga01.intel.com ([192.55.52.88]:55199 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758580AbaCTNJX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Mar 2014 09:09:23 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,694,1389772800"; 
   d="log'?scan'208";a="495808171"
Date: Thu, 20 Mar 2014 20:41:43 +0800
From: Fengguang Wu <fengguang.wu@intel.com>
To: Bjorn Helgaas <bhelgaas@google.com>
Cc: linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org,
        Daniel Vetter <daniel.vetter@ffwll.ch>,
        Alex Deucher <alexander.deucher@amd.com>,
        dri-devel@lists.freedesktop.org
Subject: [pci] WARNING: CPU: 0 PID: 1 at drivers/gpu/drm/drm_crtc.c:94
 drm_warn_on_modeset_not_all_locked()
Message-ID: <20140320124143.GA10751@localhost>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="zYM0uCDKw75PZbzx"
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--zYM0uCDKw75PZbzx
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Greetings,

I got the below dmesg and the first bad commit is

git://git.kernel.org/pub/scm/linux/kernel/git/helgaas/pci.git pci/resource

commit aa11fc58dc71c27701b1f9a529a36a38d4337722
Author:     Bjorn Helgaas <bhelgaas@google.com>
AuthorDate: Fri Mar 7 13:39:01 2014 -0700
Commit:     Bjorn Helgaas <bhelgaas@google.com>
CommitDate: Wed Mar 19 15:00:16 2014 -0600

    PCI: Check all IORESOURCE_TYPE_BITS in pci_bus_alloc_from_region()
    
    When allocating space from a bus resource, i.e., from apertures leading to
    this bus, make sure the entire resource type matches.  The previous code
    assumed the IORESOURCE_TYPE_BITS field was a bitmask with only a single bit
    set, but this is not true.  IORESOURCE_TYPE_BITS is really an enumeration,
    and we have to check all the bits.
    
    See 72dcb1197228 ("resources: Add register address resource type").
    
    No functional change.  If we used this path for allocating IRQs, DMA
    channels, or bus numbers, this would fix a bug because those types are
    indistinguishable when masked by IORESOURCE_IO | IORESOURCE_MEM.  But we
    don't, so this shouldn't make any difference.
    
    Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>

+------------------------------------------------------------------------------------------------+------------+------------+
|                                                                                                | aa11fc58dc | 2d18516523 |
+------------------------------------------------------------------------------------------------+------------+------------+
| boot_successes                                                                                 | 19         | 0          |
| boot_failures                                                                                  | 1          | 19         |
| BUG:unable_to_handle_kernel_NULL_pointer_dereference                                           | 1          | 1          |
| Oops                                                                                           | 1          | 1          |
| EIP_is_at_rapl_pmu_init                                                                        | 1          | 1          |
| Kernel_panic-not_syncing:Attempted_to_kill_init_exitcode=                                      | 1          | 1          |
| backtrace:rapl_pmu_init                                                                        | 1          | 1          |
| backtrace:kernel_init_freeable                                                                 | 1          | 19         |
| WARNING:CPU:PID:at_drivers/gpu/drm/drm_crtc.c:drm_warn_on_modeset_not_all_locked()             | 0          | 18         |
| WARNING:CPU:PID:at_drivers/gpu/drm/drm_crtc_helper.c:drm_helper_encoder_in_use()               | 0          | 18         |
| WARNING:CPU:PID:at_drivers/gpu/drm/drm_crtc_helper.c:drm_helper_crtc_in_use()                  | 0          | 18         |
| WARNING:CPU:PID:at_drivers/gpu/drm/drm_crtc_helper.c:drm_helper_probe_single_connector_modes() | 0          | 18         |
| WARNING:CPU:PID:at_drivers/gpu/drm/drm_modes.c:drm_mode_probed_add()                           | 0          | 18         |
| WARNING:CPU:PID:at_drivers/gpu/drm/drm_modes.c:drm_mode_connector_list_update()                | 0          | 18         |
| backtrace:drm_helper_disable_unused_functions                                                  | 0          | 18         |
| backtrace:cirrus_fbdev_init                                                                    | 0          | 18         |
| backtrace:cirrus_modeset_init                                                                  | 0          | 18         |
| backtrace:__pci_register_driver                                                                | 0          | 18         |
| backtrace:drm_pci_init                                                                         | 0          | 18         |
| backtrace:cirrus_init                                                                          | 0          | 18         |
| backtrace:drm_fb_helper_initial_config                                                         | 0          | 18         |
+------------------------------------------------------------------------------------------------+------------+------------+

[    1.624247] [TTM] Initializing pool allocator
[    1.625248] ------------[ cut here ]------------
[    1.625248] ------------[ cut here ]------------
[    1.626136] WARNING: CPU: 0 PID: 1 at drivers/gpu/drm/drm_crtc.c:94 drm_warn_on_modeset_not_all_locked+0x61/0xc6()

git bisect start 2d1851652373730f6b8c7fa7f45eaa854f23da8f dcb99fd9b08cfe1afe426af4d8d3cbc429190f15 --
git bisect  bad 82202f95148065d7a0f5d86d4d6e39f31dbd7937  # 12:19      0-     10  Merge 'asoc/fix/cs42l51' into devel-hourly-2014032007
git bisect good 9115e0b3218bd6b97e830bc36e6e80c4890f6fe4  # 12:45     20+      0  Merge 'scsi/misc' into devel-hourly-2014032007
git bisect good 4fb88b0dc2d9b229d03a9e6555d9056888c90137  # 14:42     20+      0  Merge 'target/for-next' into devel-hourly-2014032007
git bisect  bad c5011f998a8e94c052c5aa71cf19510f2d0bf5fd  # 15:06      0-      1  Merge 'pci/pci/resource' into devel-hourly-2014032007
git bisect good daec480a6e6be6e9716a56029aafcbfb79e6b47b  # 15:41     20+      0  Merge 'netdev-next/master' into devel-hourly-2014032007
git bisect good 937441ae220fd3fae143ef394227337c969ad155  # 15:57     20+      0  Merge 'kvm/queue' into devel-hourly-2014032007
git bisect good 3cedcc3621289d41bd21c5dbe0b886d57c83a1ea  # 16:27     20+      0  PCI: Don't enable decoding if BAR hasn't been assigned an address
git bisect good d75332325389a95c4ddbfa0f0cd7e5e08a54aa43  # 16:54     20+      0  s390/PCI: Use generic pci_enable_resources()
git bisect  bad aa11fc58dc71c27701b1f9a529a36a38d4337722  # 17:11      0-      1  PCI: Check all IORESOURCE_TYPE_BITS in pci_bus_alloc_from_region()
git bisect good 6404e88e8385638123f4b18b104430480870601a  # 17:23     20+      0  resources: Set type in __request_region()
# first bad commit: [aa11fc58dc71c27701b1f9a529a36a38d4337722] PCI: Check all IORESOURCE_TYPE_BITS in pci_bus_alloc_from_region()
git bisect good 6404e88e8385638123f4b18b104430480870601a  # 17:27     60+      0  resources: Set type in __request_region()
git bisect  bad 2d1851652373730f6b8c7fa7f45eaa854f23da8f  # 17:27      0-     19  0day head guard for 'devel-hourly-2014032007'
git bisect good 887843961c4b4681ee993c36d4997bf4b4aa8253  # 19:24     60+      0  mm: fix bad rss-counter if remap_file_pages raced migration
git bisect  bad a654dc797f3ea1cb5719a71a17af35f57fddb2d8  # 20:10      0-      1  Add linux-next specific files for 20140320

Thanks,
Fengguang

--zYM0uCDKw75PZbzx
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="dmesg-yocto-ivytown2-15:20140320093715:i386-randconfig-nh0-03200538:3.14.0-rc7-wl-ath-04519-g2d18516:9"
Content-Transfer-Encoding: quoted-printable

early console in setup code
early console in decompress_kernel

Decompressing Linux... Parsing ELF... No relocation needed... done.
Booting the kernel.
[    0.000000] Initializing cgroup subsys cpu
[    0.000000] Linux version 3.14.0-rc7-wl-ath-04519-g2d18516 (kbuild@nhm4)=
 (gcc version 4.8.2 (Debian 4.8.2-16) ) #9 Thu Mar 20 09:33:14 CST 2014
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
[    0.000000] Scanning 1 areas for low memory corruption
[    0.000000] initial memory mapped: [mem 0x00000000-0x027fffff]
[    0.000000] Base memory trampoline at [8009b000] 9b000 size 16384
[    0.000000] init_memory_mapping: [mem 0x00000000-0x000fffff]
[    0.000000]  [mem 0x00000000-0x000fffff] page 4k
[    0.000000] init_memory_mapping: [mem 0x13800000-0x13bfffff]
[    0.000000]  [mem 0x13800000-0x13bfffff] page 2M
[    0.000000] init_memory_mapping: [mem 0x10000000-0x137fffff]
[    0.000000]  [mem 0x10000000-0x137fffff] page 2M
[    0.000000] init_memory_mapping: [mem 0x00100000-0x0fffffff]
[    0.000000]  [mem 0x00100000-0x003fffff] page 4k
[    0.000000]  [mem 0x00400000-0x0fffffff] page 2M
[    0.000000] init_memory_mapping: [mem 0x13c00000-0x13ffdfff]
[    0.000000]  [mem 0x13c00000-0x13ffdfff] page 4k
[    0.000000] BRK [0x02213000, 0x02213fff] PGTABLE
[    0.000000] RAMDISK: [mem 0x13cbd000-0x13feffff]
[    0.000000] ACPI: RSDP 0x000FD950 000014 (v00 BOCHS )
[    0.000000] ACPI: RSDT 0x13FFE450 000034 (v01 BOCHS  BXPCRSDT 00000001 B=
XPC 00000001)
[    0.000000] ACPI: FACP 0x13FFFF80 000074 (v01 BOCHS  BXPCFACP 00000001 B=
XPC 00000001)
[    0.000000] ACPI: DSDT 0x13FFE490 0011A9 (v01 BXPC   BXDSDT   00000001 I=
NTL 20100528)
[    0.000000] ACPI: FACS 0x13FFFF40 000040
[    0.000000] ACPI: SSDT 0x13FFF7A0 000796 (v01 BOCHS  BXPCSSDT 00000001 B=
XPC 00000001)
[    0.000000] ACPI: APIC 0x13FFF680 000080 (v01 BOCHS  BXPCAPIC 00000001 B=
XPC 00000001)
[    0.000000] ACPI: HPET 0x13FFF640 000038 (v01 BOCHS  BXPCHPET 00000001 B=
XPC 00000001)
[    0.000000] 319MB LOWMEM available.
[    0.000000]   mapped low ram: 0 - 13ffe000
[    0.000000]   low ram: 0 - 13ffe000
[    0.000000] kvm-clock: Using msrs 4b564d01 and 4b564d00
[    0.000000] kvm-clock: cpu 0, msr 0:13ffd001, primary cpu clock
[    0.000000] Zone ranges:
[    0.000000]   Normal   [mem 0x00001000-0x13ffdfff]
[    0.000000] Movable zone start for each node
[    0.000000] Early memory node ranges
[    0.000000]   node   0: [mem 0x00001000-0x0009efff]
[    0.000000]   node   0: [mem 0x00100000-0x13ffdfff]
[    0.000000] On node 0 totalpages: 81820
[    0.000000] free_area_init_node: node 0, pgdat 81c12950, node_mem_map 93=
a3d020
[    0.000000]   Normal zone: 640 pages used for memmap
[    0.000000]   Normal zone: 0 pages reserved
[    0.000000]   Normal zone: 81820 pages, LIFO batch:15
[    0.000000] ACPI: PM-Timer IO Port: 0xb008
[    0.000000] ACPI: HPET id: 0x8086a201 base: 0xfed00000
[    0.000000] KVM setup async PF for cpu 0
[    0.000000] kvm-stealtime: cpu 0, msr 1a0cc80
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
0 rw link=3D/kernel-tests/run-queue/kvm/i386-randconfig-nh0-03200538/linux-=
devel:devel-hourly-2014032007/.vmlinuz-2d1851652373730f6b8c7fa7f45eaa854f23=
da8f-20140320093404-6-ivytown2 branch=3Dlinux-devel/devel-hourly-2014032007=
 BOOT_IMAGE=3D/kernel/i386-randconfig-nh0-03200538/2d1851652373730f6b8c7fa7=
f45eaa854f23da8f/vmlinuz-3.14.0-rc7-wl-ath-04519-g2d18516 drbd.minor_count=
=3D8
[    0.000000] sysrq: sysrq always enabled.
[    0.000000] PID hash table entries: 2048 (order: 1, 8192 bytes)
[    0.000000] Dentry cache hash table entries: 65536 (order: 6, 262144 byt=
es)
[    0.000000] Inode-cache hash table entries: 32768 (order: 5, 131072 byte=
s)
[    0.000000] Initializing CPU#0
[    0.000000] Memory: 302376K/327280K available (6926K kernel code, 2350K =
rwdata, 3284K rodata, 564K init, 5332K bss, 24904K reserved)
[    0.000000] virtual kernel memory layout:
[    0.000000]     fixmap  : 0xfffe1000 - 0xfffff000   ( 120 kB)
[    0.000000]     vmalloc : 0x947fe000 - 0xfffdf000   (1719 MB)
[    0.000000]     lowmem  : 0x80000000 - 0x93ffe000   ( 319 MB)
[    0.000000]       .init : 0x81c46000 - 0x81cd3000   ( 564 kB)
[    0.000000]       .data : 0x816c3c5e - 0x81c45ac0   (5639 kB)
[    0.000000]       .text : 0x81000000 - 0x816c3c5e   (6927 kB)
[    0.000000] Checking if this processor honours the WP bit even in superv=
isor mode...Ok.
[    0.000000] NR_IRQS:16 nr_irqs:16 16
[    0.000000] CPU 0 irqstacks, hard=3D80096000 soft=3D80080000
[    0.000000] Initializing cgroup subsys cpu
[    0.000000] Linux version 3.14.0-rc7-wl-ath-04519-g2d18516 (kbuild@nhm4)=
 (gcc version 4.8.2 (Debian 4.8.2-16) ) #9 Thu Mar 20 09:33:14 CST 2014
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
[    0.000000] Scanning 1 areas for low memory corruption
[    0.000000] initial memory mapped: [mem 0x00000000-0x027fffff]
[    0.000000] Base memory trampoline at [8009b000] 9b000 size 16384
[    0.000000] init_memory_mapping: [mem 0x00000000-0x000fffff]
[    0.000000]  [mem 0x00000000-0x000fffff] page 4k
[    0.000000] init_memory_mapping: [mem 0x13800000-0x13bfffff]
[    0.000000]  [mem 0x13800000-0x13bfffff] page 2M
[    0.000000] init_memory_mapping: [mem 0x10000000-0x137fffff]
[    0.000000]  [mem 0x10000000-0x137fffff] page 2M
[    0.000000] init_memory_mapping: [mem 0x00100000-0x0fffffff]
[    0.000000]  [mem 0x00100000-0x003fffff] page 4k
[    0.000000]  [mem 0x00400000-0x0fffffff] page 2M
[    0.000000] init_memory_mapping: [mem 0x13c00000-0x13ffdfff]
[    0.000000]  [mem 0x13c00000-0x13ffdfff] page 4k
[    0.000000] BRK [0x02213000, 0x02213fff] PGTABLE
[    0.000000] RAMDISK: [mem 0x13cbd000-0x13feffff]
[    0.000000] ACPI: RSDP 0x000FD950 000014 (v00 BOCHS )
[    0.000000] ACPI: RSDT 0x13FFE450 000034 (v01 BOCHS  BXPCRSDT 00000001 B=
XPC 00000001)
[    0.000000] ACPI: FACP 0x13FFFF80 000074 (v01 BOCHS  BXPCFACP 00000001 B=
XPC 00000001)
[    0.000000] ACPI: DSDT 0x13FFE490 0011A9 (v01 BXPC   BXDSDT   00000001 I=
NTL 20100528)
[    0.000000] ACPI: FACS 0x13FFFF40 000040
[    0.000000] ACPI: SSDT 0x13FFF7A0 000796 (v01 BOCHS  BXPCSSDT 00000001 B=
XPC 00000001)
[    0.000000] ACPI: APIC 0x13FFF680 000080 (v01 BOCHS  BXPCAPIC 00000001 B=
XPC 00000001)
[    0.000000] ACPI: HPET 0x13FFF640 000038 (v01 BOCHS  BXPCHPET 00000001 B=
XPC 00000001)
[    0.000000] 319MB LOWMEM available.
[    0.000000]   mapped low ram: 0 - 13ffe000
[    0.000000]   low ram: 0 - 13ffe000
[    0.000000] kvm-clock: Using msrs 4b564d01 and 4b564d00
[    0.000000] kvm-clock: cpu 0, msr 0:13ffd001, primary cpu clock
[    0.000000] Zone ranges:
[    0.000000]   Normal   [mem 0x00001000-0x13ffdfff]
[    0.000000] Movable zone start for each node
[    0.000000] Early memory node ranges
[    0.000000]   node   0: [mem 0x00001000-0x0009efff]
[    0.000000]   node   0: [mem 0x00100000-0x13ffdfff]
[    0.000000] On node 0 totalpages: 81820
[    0.000000] free_area_init_node: node 0, pgdat 81c12950, node_mem_map 93=
a3d020
[    0.000000]   Normal zone: 640 pages used for memmap
[    0.000000]   Normal zone: 0 pages reserved
[    0.000000]   Normal zone: 81820 pages, LIFO batch:15
[    0.000000] ACPI: PM-Timer IO Port: 0xb008
[    0.000000] ACPI: HPET id: 0x8086a201 base: 0xfed00000
[    0.000000] KVM setup async PF for cpu 0
[    0.000000] kvm-stealtime: cpu 0, msr 1a0cc80
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
0 rw link=3D/kernel-tests/run-queue/kvm/i386-randconfig-nh0-03200538/linux-=
devel:devel-hourly-2014032007/.vmlinuz-2d1851652373730f6b8c7fa7f45eaa854f23=
da8f-20140320093404-6-ivytown2 branch=3Dlinux-devel/devel-hourly-2014032007=
 BOOT_IMAGE=3D/kernel/i386-randconfig-nh0-03200538/2d1851652373730f6b8c7fa7=
f45eaa854f23da8f/vmlinuz-3.14.0-rc7-wl-ath-04519-g2d18516 drbd.minor_count=
=3D8
[    0.000000] sysrq: sysrq always enabled.
[    0.000000] PID hash table entries: 2048 (order: 1, 8192 bytes)
[    0.000000] Dentry cache hash table entries: 65536 (order: 6, 262144 byt=
es)
[    0.000000] Inode-cache hash table entries: 32768 (order: 5, 131072 byte=
s)
[    0.000000] Initializing CPU#0
[    0.000000] Memory: 302376K/327280K available (6926K kernel code, 2350K =
rwdata, 3284K rodata, 564K init, 5332K bss, 24904K reserved)
[    0.000000] virtual kernel memory layout:
[    0.000000]     fixmap  : 0xfffe1000 - 0xfffff000   ( 120 kB)
[    0.000000]     vmalloc : 0x947fe000 - 0xfffdf000   (1719 MB)
[    0.000000]     lowmem  : 0x80000000 - 0x93ffe000   ( 319 MB)
[    0.000000]       .init : 0x81c46000 - 0x81cd3000   ( 564 kB)
[    0.000000]       .data : 0x816c3c5e - 0x81c45ac0   (5639 kB)
[    0.000000]       .text : 0x81000000 - 0x816c3c5e   (6927 kB)
[    0.000000] Checking if this processor honours the WP bit even in superv=
isor mode...Ok.
[    0.000000] NR_IRQS:16 nr_irqs:16 16
[    0.000000] CPU 0 irqstacks, hard=3D80096000 soft=3D80080000
[    0.000000] console [ttyS0] enabled
[    0.000000] console [ttyS0] enabled
[    0.000000] Lock dependency validator: Copyright (c) 2006 Red Hat, Inc.,=
 Ingo Molnar
[    0.000000] Lock dependency validator: Copyright (c) 2006 Red Hat, Inc.,=
 Ingo Molnar
[    0.000000] ... MAX_LOCKDEP_SUBCLASSES:  8
[    0.000000] ... MAX_LOCKDEP_SUBCLASSES:  8
[    0.000000] ... MAX_LOCK_DEPTH:          48
[    0.000000] ... MAX_LOCK_DEPTH:          48
[    0.000000] ... MAX_LOCKDEP_KEYS:        8191
[    0.000000] ... MAX_LOCKDEP_KEYS:        8191
[    0.000000] ... CLASSHASH_SIZE:          4096
[    0.000000] ... CLASSHASH_SIZE:          4096
[    0.000000] ... MAX_LOCKDEP_ENTRIES:     16384
[    0.000000] ... MAX_LOCKDEP_ENTRIES:     16384
[    0.000000] ... MAX_LOCKDEP_CHAINS:      32768
[    0.000000] ... MAX_LOCKDEP_CHAINS:      32768
[    0.000000] ... CHAINHASH_SIZE:          16384
[    0.000000] ... CHAINHASH_SIZE:          16384
[    0.000000]  memory used by lock dependency info: 3807 kB
[    0.000000]  memory used by lock dependency info: 3807 kB
[    0.000000]  per task-struct memory footprint: 1920 bytes
[    0.000000]  per task-struct memory footprint: 1920 bytes
[    0.000000] ODEBUG: 0 of 0 active objects replaced
[    0.000000] ODEBUG: 0 of 0 active objects replaced
[    0.000000] ODEBUG: selftest passed
[    0.000000] ODEBUG: selftest passed
[    0.000000] hpet clockevent registered
[    0.000000] hpet clockevent registered
[    0.000000] tsc: Detected 2493.994 MHz processor
[    0.000000] tsc: Detected 2493.994 MHz processor
[    0.020000] Calibrating delay loop (skipped) preset value..=20
[    0.020000] Calibrating delay loop (skipped) preset value.. 4987.98 Bogo=
MIPS (lpj=3D24939940)
4987.98 BogoMIPS (lpj=3D24939940)
[    0.020000] pid_max: default: 32768 minimum: 301
[    0.020000] pid_max: default: 32768 minimum: 301
[    0.020000] ACPI: Core revision 20140214
[    0.020000] ACPI: Core revision 20140214
[    0.020000] ACPI:=20
[    0.020000] ACPI: All ACPI Tables successfully acquiredAll ACPI Tables s=
uccessfully acquired

[    0.020000] ACPI: setting ELCR to 0200 (from 0c00)
[    0.020000] ACPI: setting ELCR to 0200 (from 0c00)
[    0.020000] Security Framework initialized
[    0.020000] Security Framework initialized
[    0.020010] Yama: becoming mindful.
[    0.020010] Yama: becoming mindful.
[    0.020689] Mount-cache hash table entries: 512
[    0.020689] Mount-cache hash table entries: 512
[    0.021828] Initializing cgroup subsys debug
[    0.021828] Initializing cgroup subsys debug
[    0.022712] Last level iTLB entries: 4KB 0, 2MB 0, 4MB 0
[    0.022712] Last level dTLB entries: 4KB 0, 2MB 0, 4MB 0, 1GB 0
[    0.022712] tlb_flushall_shift: 6
[    0.022712] Last level iTLB entries: 4KB 0, 2MB 0, 4MB 0
[    0.022712] Last level dTLB entries: 4KB 0, 2MB 0, 4MB 0, 1GB 0
[    0.022712] tlb_flushall_shift: 6
[    0.025390] CPU:=20
[    0.025390] CPU: Intel Intel Common KVM processorCommon KVM processor (f=
am: 0f, model: 06 (fam: 0f, model: 06, stepping: 01)
, stepping: 01)
[    0.031131] Performance Events:=20
[    0.031131] Performance Events: unsupported Netburst CPU model 6 unsuppo=
rted Netburst CPU model 6 no PMU driver, software events only.
no PMU driver, software events only.
[    0.033200] ftrace: Allocated trace_printk buffers
[    0.033200] ftrace: Allocated trace_printk buffers
[    0.034840] NMI watchdog: disabled (cpu0): hardware events not enabled
[    0.034840] NMI watchdog: disabled (cpu0): hardware events not enabled
[    0.036427] devtmpfs: initialized
[    0.036427] devtmpfs: initialized
[    0.037853] evm: security.capability
[    0.037853] evm: security.capability
[    0.039617] prandom: seed boundary self test passed
[    0.039617] prandom: seed boundary self test passed
[    0.040502] prandom: 100 self tests passed
[    0.040502] prandom: 100 self tests passed
[    0.041275] atomic64 test passed for i586+ platform with CX8 and with SSE
[    0.041275] atomic64 test passed for i586+ platform with CX8 and with SSE
[    0.042862] regulator-dummy: no parameters
[    0.042862] regulator-dummy: no parameters
[    0.043819] NET: Registered protocol family 16
[    0.043819] NET: Registered protocol family 16
[    0.045581] cpuidle: using governor ladder
[    0.045581] cpuidle: using governor ladder
[    0.046365] cpuidle: using governor menu
[    0.046365] cpuidle: using governor menu
[    0.047684] ACPI: bus type PCI registered
[    0.047684] ACPI: bus type PCI registered
[    0.048724] PCI: PCI BIOS revision 2.10 entry at 0xfc6d5, last bus=3D0
[    0.048724] PCI: PCI BIOS revision 2.10 entry at 0xfc6d5, last bus=3D0
[    0.050008] PCI: Using configuration type 1 for base access
[    0.050008] PCI: Using configuration type 1 for base access
[    0.068102] ACPI: Added _OSI(Module Device)
[    0.068102] ACPI: Added _OSI(Module Device)
[    0.068908] ACPI: Added _OSI(Processor Device)
[    0.068908] ACPI: Added _OSI(Processor Device)
[    0.069735] ACPI: Added _OSI(3.0 _SCP Extensions)
[    0.069735] ACPI: Added _OSI(3.0 _SCP Extensions)
[    0.070009] ACPI: Added _OSI(Processor Aggregator Device)
[    0.070009] ACPI: Added _OSI(Processor Aggregator Device)
[    0.080081] ACPI: Interpreter enabled
[    0.080081] ACPI: Interpreter enabled
[    0.080792] ACPI: (supports S0 S5)
[    0.080792] ACPI: (supports S0 S5)
[    0.081436] ACPI: Using PIC for interrupt routing
[    0.081436] ACPI: Using PIC for interrupt routing
[    0.082368] PCI: Using host bridge windows from ACPI; if necessary, use =
"pci=3Dnocrs" and report a bug
[    0.082368] PCI: Using host bridge windows from ACPI; if necessary, use =
"pci=3Dnocrs" and report a bug
[    0.094344] ACPI: PCI Root Bridge [PCI0] (domain 0000 [bus 00-ff])
[    0.094344] ACPI: PCI Root Bridge [PCI0] (domain 0000 [bus 00-ff])
[    0.095503] acpi PNP0A03:00: _OSC: OS supports [Segments]
[    0.095503] acpi PNP0A03:00: _OSC: OS supports [Segments]
[    0.096514] acpi PNP0A03:00: _OSC failed (AE_NOT_FOUND); disabling ASPM
[    0.096514] acpi PNP0A03:00: _OSC failed (AE_NOT_FOUND); disabling ASPM
[    0.098217] acpi PNP0A03:00: fail to add MMCONFIG information, can't acc=
ess extended PCI configuration space under this bridge.
[    0.098217] acpi PNP0A03:00: fail to add MMCONFIG information, can't acc=
ess extended PCI configuration space under this bridge.
[    0.100116] PCI host bridge to bus 0000:00
[    0.100116] PCI host bridge to bus 0000:00
[    0.100880] pci_bus 0000:00: root bus resource [bus 00-ff]
[    0.100880] pci_bus 0000:00: root bus resource [bus 00-ff]
[    0.101882] pci_bus 0000:00: root bus resource [io  0x0000-0x0cf7]
[    0.101882] pci_bus 0000:00: root bus resource [io  0x0000-0x0cf7]
[    0.103006] pci_bus 0000:00: root bus resource [io  0x0d00-0xffff]
[    0.103006] pci_bus 0000:00: root bus resource [io  0x0d00-0xffff]
[    0.104139] pci_bus 0000:00: root bus resource [mem 0x000a0000-0x000bfff=
f]
[    0.104139] pci_bus 0000:00: root bus resource [mem 0x000a0000-0x000bfff=
f]
[    0.105393] pci_bus 0000:00: root bus resource [mem 0x80000000-0xfebffff=
f]
[    0.105393] pci_bus 0000:00: root bus resource [mem 0x80000000-0xfebffff=
f]
[    0.106701] pci 0000:00:00.0: [8086:1237] type 00 class 0x060000
[    0.106701] pci 0000:00:00.0: [8086:1237] type 00 class 0x060000
[    0.108356] pci 0000:00:01.0: [8086:7000] type 00 class 0x060100
[    0.108356] pci 0000:00:01.0: [8086:7000] type 00 class 0x060100
[    0.110578] pci 0000:00:01.1: [8086:7010] type 00 class 0x010180
[    0.110578] pci 0000:00:01.1: [8086:7010] type 00 class 0x010180
[    0.114293] pci 0000:00:01.1: reg 0x20: [io  0xc040-0xc04f]
[    0.114293] pci 0000:00:01.1: reg 0x20: [io  0xc040-0xc04f]
[    0.116314] pci 0000:00:01.1: legacy IDE quirk: reg 0x10: [io  0x01f0-0x=
01f7]
[    0.116314] pci 0000:00:01.1: legacy IDE quirk: reg 0x10: [io  0x01f0-0x=
01f7]
[    0.117626] pci 0000:00:01.1: legacy IDE quirk: reg 0x14: [io  0x03f6]
[    0.117626] pci 0000:00:01.1: legacy IDE quirk: reg 0x14: [io  0x03f6]
[    0.118820] pci 0000:00:01.1: legacy IDE quirk: reg 0x18: [io  0x0170-0x=
0177]
[    0.118820] pci 0000:00:01.1: legacy IDE quirk: reg 0x18: [io  0x0170-0x=
0177]
[    0.120010] pci 0000:00:01.1: legacy IDE quirk: reg 0x1c: [io  0x0376]
[    0.120010] pci 0000:00:01.1: legacy IDE quirk: reg 0x1c: [io  0x0376]
[    0.121573] pci 0000:00:01.3: [8086:7113] type 00 class 0x068000
[    0.121573] pci 0000:00:01.3: [8086:7113] type 00 class 0x068000
[    0.123016] pci 0000:00:01.3: quirk: [io  0xb000-0xb03f] claimed by PIIX=
4 ACPI
[    0.123016] pci 0000:00:01.3: quirk: [io  0xb000-0xb03f] claimed by PIIX=
4 ACPI
[    0.124351] pci 0000:00:01.3: quirk: [io  0xb100-0xb10f] claimed by PIIX=
4 SMB
[    0.124351] pci 0000:00:01.3: quirk: [io  0xb100-0xb10f] claimed by PIIX=
4 SMB
[    0.126086] pci 0000:00:02.0: [1013:00b8] type 00 class 0x030000
[    0.126086] pci 0000:00:02.0: [1013:00b8] type 00 class 0x030000
[    0.129378] pci 0000:00:02.0: reg 0x10: [mem 0xfc000000-0xfdffffff pref]
[    0.129378] pci 0000:00:02.0: reg 0x10: [mem 0xfc000000-0xfdffffff pref]
[    0.131354] pci 0000:00:02.0: reg 0x14: [mem 0xfebf0000-0xfebf0fff]
[    0.131354] pci 0000:00:02.0: reg 0x14: [mem 0xfebf0000-0xfebf0fff]
[    0.138679] pci 0000:00:02.0: reg 0x30: [mem 0xfebe0000-0xfebeffff pref]
[    0.138679] pci 0000:00:02.0: reg 0x30: [mem 0xfebe0000-0xfebeffff pref]
[    0.140687] pci 0000:00:03.0: [8086:100e] type 00 class 0x020000
[    0.140687] pci 0000:00:03.0: [8086:100e] type 00 class 0x020000
[    0.142748] pci 0000:00:03.0: reg 0x10: [mem 0xfeba0000-0xfebbffff]
[    0.142748] pci 0000:00:03.0: reg 0x10: [mem 0xfeba0000-0xfebbffff]
[    0.144821] pci 0000:00:03.0: reg 0x14: [io  0xc000-0xc03f]
[    0.144821] pci 0000:00:03.0: reg 0x14: [io  0xc000-0xc03f]
[    0.151377] pci 0000:00:03.0: reg 0x30: [mem 0xfebc0000-0xfebdffff pref]
[    0.151377] pci 0000:00:03.0: reg 0x30: [mem 0xfebc0000-0xfebdffff pref]
[    0.153036] pci 0000:00:04.0: [8086:25ab] type 00 class 0x088000
[    0.153036] pci 0000:00:04.0: [8086:25ab] type 00 class 0x088000
[    0.154654] pci 0000:00:04.0: reg 0x10: [mem 0xfebf1000-0xfebf100f]
[    0.154654] pci 0000:00:04.0: reg 0x10: [mem 0xfebf1000-0xfebf100f]
[    0.159260] pci_bus 0000:00: on NUMA node 0
[    0.159260] pci_bus 0000:00: on NUMA node 0
[    0.161063] ACPI: PCI Interrupt Link [LNKA] (IRQs
[    0.161063] ACPI: PCI Interrupt Link [LNKA] (IRQs 5 5 *10 *10 11 11))

[    0.162433] ACPI: PCI Interrupt Link [LNKB] (IRQs
[    0.162433] ACPI: PCI Interrupt Link [LNKB] (IRQs 5 5 *10 *10 11 11))

[    0.163785] ACPI: PCI Interrupt Link [LNKC] (IRQs
[    0.163785] ACPI: PCI Interrupt Link [LNKC] (IRQs 5 5 10 10 *11 *11))

[    0.165139] ACPI: PCI Interrupt Link [LNKD] (IRQs
[    0.165139] ACPI: PCI Interrupt Link [LNKD] (IRQs 5 5 10 10 *11 *11))

[    0.166379] ACPI: PCI Interrupt Link [LNKS] (IRQs
[    0.166379] ACPI: PCI Interrupt Link [LNKS] (IRQs *9 *9))

[    0.170725] pps_core: LinuxPPS API ver. 1 registered
[    0.170725] pps_core: LinuxPPS API ver. 1 registered
[    0.171652] pps_core: Software ver. 5.3.6 - Copyright 2005-2007 Rodolfo =
Giometti <giometti@linux.it>
[    0.171652] pps_core: Software ver. 5.3.6 - Copyright 2005-2007 Rodolfo =
Giometti <giometti@linux.it>
[    0.173328] PTP clock support registered
[    0.173328] PTP clock support registered
[    0.174110] EDAC MC: Ver: 3.0.0
[    0.174110] EDAC MC: Ver: 3.0.0
[    0.175254] wmi: Mapper loaded
[    0.175254] wmi: Mapper loaded
[    0.175902] PCI: Using ACPI for IRQ routing
[    0.175902] PCI: Using ACPI for IRQ routing
[    0.176680] PCI: pci_cache_line_size set to 64 bytes
[    0.176680] PCI: pci_cache_line_size set to 64 bytes
[    0.177711] e820: reserve RAM buffer [mem 0x0009fc00-0x0009ffff]
[    0.177711] e820: reserve RAM buffer [mem 0x0009fc00-0x0009ffff]
[    0.178813] e820: reserve RAM buffer [mem 0x13ffe000-0x13ffffff]
[    0.178813] e820: reserve RAM buffer [mem 0x13ffe000-0x13ffffff]
[    0.181147] Switched to clocksource kvm-clock
[    0.181147] Switched to clocksource kvm-clock
[    0.182550] Warning: could not register annotated branches stats
[    0.182550] Warning: could not register annotated branches stats
[    0.199154] FS-Cache: Loaded
[    0.199154] FS-Cache: Loaded
[    0.199778] pnp: PnP ACPI init
[    0.199778] pnp: PnP ACPI init
[    0.200485] ACPI: bus type PNP registered
[    0.200485] ACPI: bus type PNP registered
[    0.201401] pnp 00:00: Plug and Play ACPI device, IDs PNP0b00 (active)
[    0.201401] pnp 00:00: Plug and Play ACPI device, IDs PNP0b00 (active)
[    0.202757] pnp 00:01: Plug and Play ACPI device, IDs PNP0303 (active)
[    0.202757] pnp 00:01: Plug and Play ACPI device, IDs PNP0303 (active)
[    0.204077] pnp 00:02: Plug and Play ACPI device, IDs PNP0f13 (active)
[    0.204077] pnp 00:02: Plug and Play ACPI device, IDs PNP0f13 (active)
[    0.205368] pnp 00:03: [dma 2]
[    0.205368] pnp 00:03: [dma 2]
[    0.206003] pnp 00:03: Plug and Play ACPI device, IDs PNP0700 (active)
[    0.206003] pnp 00:03: Plug and Play ACPI device, IDs PNP0700 (active)
[    0.207356] pnp 00:04: Plug and Play ACPI device, IDs PNP0400 (active)
[    0.207356] pnp 00:04: Plug and Play ACPI device, IDs PNP0400 (active)
[    0.208714] pnp 00:05: Plug and Play ACPI device, IDs PNP0501 (active)
[    0.208714] pnp 00:05: Plug and Play ACPI device, IDs PNP0501 (active)
[    0.210499] pnp 00:06: Plug and Play ACPI device, IDs PNP0103 (active)
[    0.210499] pnp 00:06: Plug and Play ACPI device, IDs PNP0103 (active)
[    0.212004] pnp: PnP ACPI: found 7 devices
[    0.212004] pnp: PnP ACPI: found 7 devices
[    0.212767] ACPI: bus type PNP unregistered
[    0.212767] ACPI: bus type PNP unregistered
[    0.249406] pci_bus 0000:00: resource 4 [io  0x0000-0x0cf7]
[    0.249406] pci_bus 0000:00: resource 4 [io  0x0000-0x0cf7]
[    0.250552] pci_bus 0000:00: resource 5 [io  0x0d00-0xffff]
[    0.250552] pci_bus 0000:00: resource 5 [io  0x0d00-0xffff]
[    0.251580] pci_bus 0000:00: resource 6 [mem 0x000a0000-0x000bffff]
[    0.251580] pci_bus 0000:00: resource 6 [mem 0x000a0000-0x000bffff]
[    0.252717] pci_bus 0000:00: resource 7 [mem 0x80000000-0xfebfffff]
[    0.252717] pci_bus 0000:00: resource 7 [mem 0x80000000-0xfebfffff]
[    0.253888] NET: Registered protocol family 1
[    0.253888] NET: Registered protocol family 1
[    0.254710] pci 0000:00:00.0: Limiting direct PCI/PCI transfers
[    0.254710] pci 0000:00:00.0: Limiting direct PCI/PCI transfers
[    0.255807] pci 0000:00:01.0: PIIX3: Enabling Passive Release
[    0.255807] pci 0000:00:01.0: PIIX3: Enabling Passive Release
[    0.256873] pci 0000:00:01.0: Activating ISA DMA hang workarounds
[    0.256873] pci 0000:00:01.0: Activating ISA DMA hang workarounds
[    0.258028] pci 0000:00:02.0: Boot video device
[    0.258028] pci 0000:00:02.0: Boot video device
[    0.258896] PCI: CLS 0 bytes, default 64
[    0.258896] PCI: CLS 0 bytes, default 64
[    0.260285] Unpacking initramfs...
[    0.260285] Unpacking initramfs...
[    0.387406] Freeing initrd memory: 3276K (93cbd000 - 93ff0000)
[    0.387406] Freeing initrd memory: 3276K (93cbd000 - 93ff0000)
[    0.389237] microcode: CPU0 sig=3D0xf61, pf=3D0x1, revision=3D0x1
[    0.389237] microcode: CPU0 sig=3D0xf61, pf=3D0x1, revision=3D0x1
[    0.390614] microcode: Microcode Update Driver: v2.00 <tigran@aivazian.f=
snet.co.uk>, Peter Oruba
[    0.390614] microcode: Microcode Update Driver: v2.00 <tigran@aivazian.f=
snet.co.uk>, Peter Oruba
[    0.392457] Scanning for low memory corruption every 60 seconds
[    0.392457] Scanning for low memory corruption every 60 seconds
[    0.393875] cryptomgr_test (15) used greatest stack depth: 7436 bytes le=
ft
[    0.393875] cryptomgr_test (15) used greatest stack depth: 7436 bytes le=
ft
[    0.395877] PCLMULQDQ-NI instructions are not detected.
[    0.395877] PCLMULQDQ-NI instructions are not detected.
[    0.396864] NatSemi SCx200 Driver
[    0.396864] NatSemi SCx200 Driver
[    0.398346] Initializing RT-Tester: OK
[    0.398346] Initializing RT-Tester: OK
[    0.399426] futex hash table entries: 256 (order: 1, 12288 bytes)
[    0.399426] futex hash table entries: 256 (order: 1, 12288 bytes)
[    0.430534] HugeTLB registered 4 MB page size, pre-allocated 0 pages
[    0.430534] HugeTLB registered 4 MB page size, pre-allocated 0 pages
[    0.432018] VFS: Disk quotas dquot_6.5.2
[    0.432018] VFS: Disk quotas dquot_6.5.2
[    0.432770] Dquot-cache hash table entries: 1024 (order 0, 4096 bytes)
[    0.432770] Dquot-cache hash table entries: 1024 (order 0, 4096 bytes)
[    0.434306] fuse init (API version 7.22)
[    0.434306] fuse init (API version 7.22)
[    0.435269] msgmni has been set to 596
[    0.435269] msgmni has been set to 596
[    0.435982] Key type big_key registered
[    0.435982] Key type big_key registered
[    0.439164] Key type asymmetric registered
[    0.439164] Key type asymmetric registered
[    0.439952] Asymmetric key parser 'x509' registered
[    0.439952] Asymmetric key parser 'x509' registered
[    0.444051] list_sort_test: start testing list_sort()
[    0.444051] list_sort_test: start testing list_sort()
[    0.445719] xz_dec_test: module loaded
[    0.445719] xz_dec_test: module loaded
[    0.446430] xz_dec_test: Create a device node with 'mknod xz_dec_test c =
250 0' and write .xz files to it.
[    0.446430] xz_dec_test: Create a device node with 'mknod xz_dec_test c =
250 0' and write .xz files to it.
[    0.448178] rbtree testing
[    0.448178] rbtree testing -> 10434 cycles
 -> 10434 cycles
[    0.923982] augmented rbtree testing
[    0.923982] augmented rbtree testing -> 12969 cycles
 -> 12969 cycles
[    1.520461] VIA Graphics Integration Chipset framebuffer 2.4 initializing
[    1.520461] VIA Graphics Integration Chipset framebuffer 2.4 initializing
[    1.522134] no IO addresses supplied
[    1.522134] no IO addresses supplied
[    1.522974] hgafb: HGA card not detected.
[    1.522974] hgafb: HGA card not detected.
[    1.523728] hgafb: probe of hgafb.0 failed with error -22
[    1.523728] hgafb: probe of hgafb.0 failed with error -22
[    1.524978] ipmi message handler version 39.2
[    1.524978] ipmi message handler version 39.2
[    1.525815] ipmi device interface
[    1.525815] ipmi device interface
[    1.526524] IPMI System Interface driver.
[    1.526524] IPMI System Interface driver.
[    1.527377] ipmi_si: Adding default-specified kcs state machine
[    1.527377] ipmi_si: Adding default-specified kcs state machine

[    1.528486] ipmi_si: Trying default-specified kcs state machine at i/o a=
ddress 0xca2, slave address 0x0, irq 0
[    1.528486] ipmi_si: Trying default-specified kcs state machine at i/o a=
ddress 0xca2, slave address 0x0, irq 0
[    1.530463] ipmi_si: Interface detection failed
[    1.530463] ipmi_si: Interface detection failed
[    1.531345] tsc: Refined TSC clocksource calibration: 2493.964 MHz
[    1.531345] tsc: Refined TSC clocksource calibration: 2493.964 MHz
[    1.532505] ipmi_si: Adding default-specified smic state machine
[    1.532505] ipmi_si: Adding default-specified smic state machine

[    1.533646] ipmi_si: Trying default-specified smic state machine at i/o =
address 0xca9, slave address 0x0, irq 0
[    1.533646] ipmi_si: Trying default-specified smic state machine at i/o =
address 0xca9, slave address 0x0, irq 0
[    1.535491] ipmi_si: Interface detection failed
[    1.535491] ipmi_si: Interface detection failed
[    1.536325] ipmi_si: Adding default-specified bt state machine
[    1.536325] ipmi_si: Adding default-specified bt state machine

[    1.537432] ipmi_si: Trying default-specified bt state machine at i/o ad=
dress 0xe4, slave address 0x0, irq 0
[    1.537432] ipmi_si: Trying default-specified bt state machine at i/o ad=
dress 0xe4, slave address 0x0, irq 0
[    1.539229] ipmi_si: Interface detection failed
[    1.539229] ipmi_si: Interface detection failed
[    1.540276] ipmi_si: Unable to find any System Interface(s)
[    1.540276] ipmi_si: Unable to find any System Interface(s)
[    1.542414] input: Power Button as /devices/LNXSYSTM:00/LNXPWRBN:00/inpu=
t/input0
[    1.542414] input: Power Button as /devices/LNXSYSTM:00/LNXPWRBN:00/inpu=
t/input0
[    1.543793] ACPI: Power Button [PWRF]
[    1.543793] ACPI: Power Button [PWRF]
[    1.544727] button: probe of LNXPWRBN:00 failed with error -22
[    1.544727] button: probe of LNXPWRBN:00 failed with error -22
[    1.580680] Serial: 8250/16550 driver, 4 ports, IRQ sharing disabled
[    1.580680] Serial: 8250/16550 driver, 4 ports, IRQ sharing disabled
[    1.603544] 00:05: ttyS0 at I/O 0x3f8 (irq =3D 4, base_baud =3D 115200) =
is a 16550A
[    1.603544] 00:05: ttyS0 at I/O 0x3f8 (irq =3D 4, base_baud =3D 115200) =
is a 16550A
[    1.605887] DoubleTalk PC - not found
[    1.605887] DoubleTalk PC - not found
[    1.606588] Applicom driver: $Id: ac.c,v 1.30 2000/03/22 16:03:57 dwmw2 =
Exp $
[    1.606588] Applicom driver: $Id: ac.c,v 1.30 2000/03/22 16:03:57 dwmw2 =
Exp $
[    1.607894] ac.o: No PCI boards found.
[    1.607894] ac.o: No PCI boards found.
[    1.608583] ac.o: For an ISA board you must supply memory and irq parame=
ters.
[    1.608583] ac.o: For an ISA board you must supply memory and irq parame=
ters.
[    1.609902] sonypi: Sony Programmable I/O Controller Driver v1.26.
[    1.609902] sonypi: Sony Programmable I/O Controller Driver v1.26.
[    1.611193] Non-volatile memory driver v1.3
[    1.611193] Non-volatile memory driver v1.3
[    1.611976] toshiba: not a supported Toshiba laptop
[    1.611976] toshiba: not a supported Toshiba laptop
[    1.613213] platform pc8736x_gpio.0: NatSemi pc8736x GPIO Driver Initial=
izing
[    1.613213] platform pc8736x_gpio.0: NatSemi pc8736x GPIO Driver Initial=
izing
[    1.614549] platform pc8736x_gpio.0: no device found
[    1.614549] platform pc8736x_gpio.0: no device found
[    1.615508] nsc_gpio initializing
[    1.615508] nsc_gpio initializing
[    1.616135] Linux agpgart interface v0.103
[    1.616135] Linux agpgart interface v0.103
[    1.617456] Hangcheck: starting hangcheck timer 0.9.1 (tick is 180 secon=
ds, margin is 60 seconds).
[    1.617456] Hangcheck: starting hangcheck timer 0.9.1 (tick is 180 secon=
ds, margin is 60 seconds).
[    1.619101] Hangcheck: Using getrawmonotonic().
[    1.619101] Hangcheck: Using getrawmonotonic().
[    1.620297] [drm] Initialized drm 1.1.0 20060810
[    1.620297] [drm] Initialized drm 1.1.0 20060810
[    1.621250] [drm] radeon kernel modesetting enabled.
[    1.621250] [drm] radeon kernel modesetting enabled.
[    1.623042] [TTM] Zone  kernel: Available graphics memory: 152826 kiB
[    1.623042] [TTM] Zone  kernel: Available graphics memory: 152826 kiB
[    1.624247] [TTM] Initializing pool allocator
[    1.624247] [TTM] Initializing pool allocator
[    1.625248] ------------[ cut here ]------------
[    1.625248] ------------[ cut here ]------------
[    1.626136] WARNING: CPU: 0 PID: 1 at drivers/gpu/drm/drm_crtc.c:94 drm_=
warn_on_modeset_not_all_locked+0x61/0xc6()
[    1.626136] WARNING: CPU: 0 PID: 1 at drivers/gpu/drm/drm_crtc.c:94 drm_=
warn_on_modeset_not_all_locked+0x61/0xc6()
[    1.628422] CPU: 0 PID: 1 Comm: swapper Not tainted 3.14.0-rc7-wl-ath-04=
519-g2d18516 #9
[    1.628422] CPU: 0 PID: 1 Comm: swapper Not tainted 3.14.0-rc7-wl-ath-04=
519-g2d18516 #9
[    1.629893] Hardware name: Bochs Bochs, BIOS Bochs 01/01/2011
[    1.629893] Hardware name: Bochs Bochs, BIOS Bochs 01/01/2011
[    1.631038]  00000000
[    1.631038]  00000000 00000000 00000000 80033cc4 80033cc4 816b7fd7 816b7=
fd7 80033cf4 80033cf4 8102fe35 8102fe35 81935ad6 81935ad6 00000000 00000000

[    1.632570]  00000001
[    1.632570]  00000001 8197195f 8197195f 0000005e 0000005e 812af746 812af=
746 812af746 812af746 92407000 92407000 802e6000 802e6000 00000001 00000001

[    1.634115]  80033d04
[    1.634115]  80033d04 8102fef5 8102fef5 00000009 00000009 00000000 00000=
000 80033d20 80033d20 812af746 812af746 802e63d4 802e63d4 01bfc000 01bfc000

[    1.635649] Call Trace:
[    1.635649] Call Trace:
[    1.636117]  [<816b7fd7>] dump_stack+0x16/0x18
[    1.636117]  [<816b7fd7>] dump_stack+0x16/0x18
[    1.636947]  [<8102fe35>] warn_slowpath_common+0x75/0x8c
[    1.636947]  [<8102fe35>] warn_slowpath_common+0x75/0x8c
[    1.637938]  [<812af746>] ? drm_warn_on_modeset_not_all_locked+0x61/0xc6
[    1.637938]  [<812af746>] ? drm_warn_on_modeset_not_all_locked+0x61/0xc6
[    1.639173]  [<812af746>] ? drm_warn_on_modeset_not_all_locked+0x61/0xc6
[    1.639173]  [<812af746>] ? drm_warn_on_modeset_not_all_locked+0x61/0xc6
[    1.640489]  [<8102fef5>] warn_slowpath_null+0x22/0x24
[    1.640489]  [<8102fef5>] warn_slowpath_null+0x22/0x24
[    1.641451]  [<812af746>] drm_warn_on_modeset_not_all_locked+0x61/0xc6
[    1.641451]  [<812af746>] drm_warn_on_modeset_not_all_locked+0x61/0xc6
[    1.642642]  [<8129fb88>] drm_helper_disable_unused_functions+0x12/0xd4
[    1.642642]  [<8129fb88>] drm_helper_disable_unused_functions+0x12/0xd4
[    1.643853]  [<813ebdc3>] cirrus_fbdev_init+0x77/0x92
[    1.643853]  [<813ebdc3>] cirrus_fbdev_init+0x77/0x92
[    1.644780]  [<813eb5f4>] cirrus_modeset_init+0x153/0x19c
[    1.644780]  [<813eb5f4>] cirrus_modeset_init+0x153/0x19c
[    1.645788]  [<813ea76b>] cirrus_driver_load+0x93/0xde
[    1.645788]  [<813ea76b>] cirrus_driver_load+0x93/0xde
[    1.646731]  [<812aba1e>] drm_dev_register+0x6e/0xd3
[    1.646731]  [<812aba1e>] drm_dev_register+0x6e/0xd3
[    1.647635]  [<812ad56a>] drm_get_pci_dev+0xdc/0x190
[    1.647635]  [<812ad56a>] drm_get_pci_dev+0xdc/0x190
[    1.648541]  [<813eb6ff>] cirrus_pci_probe+0x87/0x93
[    1.648541]  [<813eb6ff>] cirrus_pci_probe+0x87/0x93
[    1.649474]  [<811ad0d6>] pci_device_probe+0x4c/0x8d
[    1.649474]  [<811ad0d6>] pci_device_probe+0x4c/0x8d
[    1.650501]  [<811161d5>] ? sysfs_create_link+0x2c/0x35
[    1.650501]  [<811161d5>] ? sysfs_create_link+0x2c/0x35
[    1.651477]  [<8149af17>] driver_probe_device+0x99/0x1c1
[    1.651477]  [<8149af17>] driver_probe_device+0x99/0x1c1
[    1.652457]  [<811acf09>] ? pci_match_device+0x9f/0xa5
[    1.652457]  [<811acf09>] ? pci_match_device+0x9f/0xa5
[    1.653424]  [<8149b0c3>] __driver_attach+0x53/0x6f
[    1.653424]  [<8149b0c3>] __driver_attach+0x53/0x6f
[    1.654331]  [<81499b79>] bus_for_each_dev+0x3e/0x69
[    1.654331]  [<81499b79>] bus_for_each_dev+0x3e/0x69
[    1.655239]  [<8149ae35>] driver_attach+0x1c/0x1e
[    1.655239]  [<8149ae35>] driver_attach+0x1c/0x1e
[    1.656099]  [<8149b070>] ? __device_attach+0x31/0x31
[    1.656099]  [<8149b070>] ? __device_attach+0x31/0x31
[    1.657029]  [<8149a230>] bus_add_driver+0xc7/0x1a9
[    1.657029]  [<8149a230>] bus_add_driver+0xc7/0x1a9
[    1.657947]  [<8149b55f>] driver_register+0x96/0xca
[    1.657947]  [<8149b55f>] driver_register+0x96/0xca
[    1.658842]  [<810600f4>] ? __raw_spin_lock_init+0x32/0x53
[    1.658842]  [<810600f4>] ? __raw_spin_lock_init+0x32/0x53
[    1.659853]  [<811acf85>] __pci_register_driver+0x4a/0x4d
[    1.659853]  [<811acf85>] __pci_register_driver+0x4a/0x4d
[    1.660919]  [<812ad67f>] drm_pci_init+0x61/0xd8
[    1.660919]  [<812ad67f>] drm_pci_init+0x61/0xd8
[    1.661813]  [<81c70b2c>] ? tdfx_init+0x14/0x14
[    1.661813]  [<81c70b2c>] ? tdfx_init+0x14/0x14
[    1.662654]  [<81c71f2a>] ? mgag200_init+0x25/0x25
[    1.662654]  [<81c71f2a>] ? mgag200_init+0x25/0x25
[    1.663538]  [<81c71f45>] cirrus_init+0x1b/0x25
[    1.663538]  [<81c71f45>] cirrus_init+0x1b/0x25
[    1.664380]  [<81c46add>] do_one_initcall+0x8b/0x14b
[    1.664380]  [<81c46add>] do_one_initcall+0x8b/0x14b
[    1.665319]  [<8105bc23>] ? lock_release_holdtime+0xc1/0xcd
[    1.665319]  [<8105bc23>] ? lock_release_holdtime+0xc1/0xcd
[    1.666350]  [<81047ae2>] ? parameqn+0xc/0x41
[    1.666350]  [<81047ae2>] ? parameqn+0xc/0x41
[    1.667157]  [<81c46452>] ? repair_env_string+0x12/0x51
[    1.667157]  [<81c46452>] ? repair_env_string+0x12/0x51
[    1.668111]  [<81047caa>] ? parse_args+0x16e/0x231
[    1.668111]  [<81047caa>] ? parse_args+0x16e/0x231
[    1.668997]  [<81c46c6c>] kernel_init_freeable+0xcf/0x16e
[    1.668997]  [<81c46c6c>] kernel_init_freeable+0xcf/0x16e
[    1.670118]  [<81c46440>] ? do_early_param+0x7a/0x7a
[    1.670118]  [<81c46440>] ? do_early_param+0x7a/0x7a
[    1.671029]  [<816b3ed4>] kernel_init+0x10/0xcb
[    1.671029]  [<816b3ed4>] kernel_init+0x10/0xcb
[    1.671867]  [<8105280b>] ? schedule_tail+0x17/0x3e
[    1.671867]  [<8105280b>] ? schedule_tail+0x17/0x3e
[    1.672770]  [<816c2e37>] ret_from_kernel_thread+0x1b/0x28
[    1.672770]  [<816c2e37>] ret_from_kernel_thread+0x1b/0x28
[    1.673805]  [<816b3ec4>] ? rest_init+0xbc/0xbc
[    1.673805]  [<816b3ec4>] ? rest_init+0xbc/0xbc
[    1.674648] ---[ end trace a205f4c9292ec49d ]---
[    1.674648] ---[ end trace a205f4c9292ec49d ]---
[    1.675494] ------------[ cut here ]------------
[    1.675494] ------------[ cut here ]------------
[    1.676344] WARNING: CPU: 0 PID: 1 at drivers/gpu/drm/drm_crtc.c:96 drm_=
warn_on_modeset_not_all_locked+0x99/0xc6()
[    1.676344] WARNING: CPU: 0 PID: 1 at drivers/gpu/drm/drm_crtc.c:96 drm_=
warn_on_modeset_not_all_locked+0x99/0xc6()
[    1.678654] CPU: 0 PID: 1 Comm: swapper Tainted: G        W    3.14.0-rc=
7-wl-ath-04519-g2d18516 #9
[    1.678654] CPU: 0 PID: 1 Comm: swapper Tainted: G        W    3.14.0-rc=
7-wl-ath-04519-g2d18516 #9
[    1.680375] Hardware name: Bochs Bochs, BIOS Bochs 01/01/2011
[    1.680375] Hardware name: Bochs Bochs, BIOS Bochs 01/01/2011
[    1.681444]  00000000
[    1.681444]  00000000 00000000 00000000 80033cc4 80033cc4 816b7fd7 816b7=
fd7 80033cf4 80033cf4 8102fe35 8102fe35 81935ad6 81935ad6 00000000 00000000

[    1.682966]  00000001
[    1.682966]  00000001 8197195f 8197195f 00000060 00000060 812af77e 812af=
77e 812af77e 812af77e 802e6301 802e6301 00000001 00000001 00000001 00000001

[    1.684486]  80033d04
[    1.684486]  80033d04 8102fef5 8102fef5 00000009 00000009 00000000 00000=
000 80033d20 80033d20 812af77e 812af77e 802e63d4 802e63d4 01bfc000 01bfc000

[    1.686022] Call Trace:
[    1.686022] Call Trace:
[    1.686487]  [<816b7fd7>] dump_stack+0x16/0x18
[    1.686487]  [<816b7fd7>] dump_stack+0x16/0x18
[    1.687303]  [<8102fe35>] warn_slowpath_common+0x75/0x8c
[    1.687303]  [<8102fe35>] warn_slowpath_common+0x75/0x8c
[    1.688281]  [<812af77e>] ? drm_warn_on_modeset_not_all_locked+0x99/0xc6
[    1.688281]  [<812af77e>] ? drm_warn_on_modeset_not_all_locked+0x99/0xc6
[    1.689517]  [<812af77e>] ? drm_warn_on_modeset_not_all_locked+0x99/0xc6
[    1.689517]  [<812af77e>] ? drm_warn_on_modeset_not_all_locked+0x99/0xc6
[    1.690819]  [<8102fef5>] warn_slowpath_null+0x22/0x24
[    1.690819]  [<8102fef5>] warn_slowpath_null+0x22/0x24
[    1.691771]  [<812af77e>] drm_warn_on_modeset_not_all_locked+0x99/0xc6
[    1.691771]  [<812af77e>] drm_warn_on_modeset_not_all_locked+0x99/0xc6
[    1.692962]  [<8129fb88>] drm_helper_disable_unused_functions+0x12/0xd4
[    1.692962]  [<8129fb88>] drm_helper_disable_unused_functions+0x12/0xd4
[    1.694187]  [<813ebdc3>] cirrus_fbdev_init+0x77/0x92
[    1.694187]  [<813ebdc3>] cirrus_fbdev_init+0x77/0x92
[    1.695101]  [<813eb5f4>] cirrus_modeset_init+0x153/0x19c
[    1.695101]  [<813eb5f4>] cirrus_modeset_init+0x153/0x19c
[    1.696087]  [<813ea76b>] cirrus_driver_load+0x93/0xde
[    1.696087]  [<813ea76b>] cirrus_driver_load+0x93/0xde
[    1.697032]  [<812aba1e>] drm_dev_register+0x6e/0xd3
[    1.697032]  [<812aba1e>] drm_dev_register+0x6e/0xd3
[    1.697954]  [<812ad56a>] drm_get_pci_dev+0xdc/0x190
[    1.697954]  [<812ad56a>] drm_get_pci_dev+0xdc/0x190
[    1.698858]  [<813eb6ff>] cirrus_pci_probe+0x87/0x93
[    1.698858]  [<813eb6ff>] cirrus_pci_probe+0x87/0x93
[    1.699770]  [<811ad0d6>] pci_device_probe+0x4c/0x8d
[    1.699770]  [<811ad0d6>] pci_device_probe+0x4c/0x8d
[    1.700773]  [<811161d5>] ? sysfs_create_link+0x2c/0x35
[    1.700773]  [<811161d5>] ? sysfs_create_link+0x2c/0x35
[    1.701758]  [<8149af17>] driver_probe_device+0x99/0x1c1
[    1.701758]  [<8149af17>] driver_probe_device+0x99/0x1c1
[    1.702739]  [<811acf09>] ? pci_match_device+0x9f/0xa5
[    1.702739]  [<811acf09>] ? pci_match_device+0x9f/0xa5
[    1.703683]  [<8149b0c3>] __driver_attach+0x53/0x6f
[    1.703683]  [<8149b0c3>] __driver_attach+0x53/0x6f
[    1.704577]  [<81499b79>] bus_for_each_dev+0x3e/0x69
[    1.704577]  [<81499b79>] bus_for_each_dev+0x3e/0x69
[    1.705502]  [<8149ae35>] driver_attach+0x1c/0x1e
[    1.705502]  [<8149ae35>] driver_attach+0x1c/0x1e
[    1.706364]  [<8149b070>] ? __device_attach+0x31/0x31
[    1.706364]  [<8149b070>] ? __device_attach+0x31/0x31
[    1.707297]  [<8149a230>] bus_add_driver+0xc7/0x1a9
[    1.707297]  [<8149a230>] bus_add_driver+0xc7/0x1a9
[    1.708189]  [<8149b55f>] driver_register+0x96/0xca
[    1.708189]  [<8149b55f>] driver_register+0x96/0xca
[    1.709076]  [<810600f4>] ? __raw_spin_lock_init+0x32/0x53
[    1.709076]  [<810600f4>] ? __raw_spin_lock_init+0x32/0x53
[    1.710205]  [<811acf85>] __pci_register_driver+0x4a/0x4d
[    1.710205]  [<811acf85>] __pci_register_driver+0x4a/0x4d
[    1.711206]  [<812ad67f>] drm_pci_init+0x61/0xd8
[    1.711206]  [<812ad67f>] drm_pci_init+0x61/0xd8
[    1.712049]  [<81c70b2c>] ? tdfx_init+0x14/0x14
[    1.712049]  [<81c70b2c>] ? tdfx_init+0x14/0x14
[    1.712887]  [<81c71f2a>] ? mgag200_init+0x25/0x25
[    1.712887]  [<81c71f2a>] ? mgag200_init+0x25/0x25
[    1.713785]  [<81c71f45>] cirrus_init+0x1b/0x25
[    1.713785]  [<81c71f45>] cirrus_init+0x1b/0x25
[    1.714623]  [<81c46add>] do_one_initcall+0x8b/0x14b
[    1.714623]  [<81c46add>] do_one_initcall+0x8b/0x14b
[    1.715538]  [<8105bc23>] ? lock_release_holdtime+0xc1/0xcd
[    1.715538]  [<8105bc23>] ? lock_release_holdtime+0xc1/0xcd
[    1.716556]  [<81047ae2>] ? parameqn+0xc/0x41
[    1.716556]  [<81047ae2>] ? parameqn+0xc/0x41
[    1.717379]  [<81c46452>] ? repair_env_string+0x12/0x51
[    1.717379]  [<81c46452>] ? repair_env_string+0x12/0x51
[    1.718335]  [<81047caa>] ? parse_args+0x16e/0x231
[    1.718335]  [<81047caa>] ? parse_args+0x16e/0x231
[    1.719205]  [<81c46c6c>] kernel_init_freeable+0xcf/0x16e
[    1.719205]  [<81c46c6c>] kernel_init_freeable+0xcf/0x16e
[    1.720280]  [<81c46440>] ? do_early_param+0x7a/0x7a
[    1.720280]  [<81c46440>] ? do_early_param+0x7a/0x7a
[    1.721216]  [<816b3ed4>] kernel_init+0x10/0xcb
[    1.721216]  [<816b3ed4>] kernel_init+0x10/0xcb
[    1.722042]  [<8105280b>] ? schedule_tail+0x17/0x3e
[    1.722042]  [<8105280b>] ? schedule_tail+0x17/0x3e
[    1.722931]  [<816c2e37>] ret_from_kernel_thread+0x1b/0x28
[    1.722931]  [<816c2e37>] ret_from_kernel_thread+0x1b/0x28
[    1.723932]  [<816b3ec4>] ? rest_init+0xbc/0xbc
[    1.723932]  [<816b3ec4>] ? rest_init+0xbc/0xbc
[    1.724763] ---[ end trace a205f4c9292ec49e ]---
[    1.724763] ---[ end trace a205f4c9292ec49e ]---
[    1.725624] ------------[ cut here ]------------
[    1.725624] ------------[ cut here ]------------
[    1.726475] WARNING: CPU: 0 PID: 1 at drivers/gpu/drm/drm_crtc_helper.c:=
232 drm_helper_encoder_in_use+0x43/0x83()
[    1.726475] WARNING: CPU: 0 PID: 1 at drivers/gpu/drm/drm_crtc_helper.c:=
232 drm_helper_encoder_in_use+0x43/0x83()
[    1.728736] CPU: 0 PID: 1 Comm: swapper Tainted: G        W    3.14.0-rc=
7-wl-ath-04519-g2d18516 #9
[    1.728736] CPU: 0 PID: 1 Comm: swapper Tainted: G        W    3.14.0-rc=
7-wl-ath-04519-g2d18516 #9
[    1.730471] Hardware name: Bochs Bochs, BIOS Bochs 01/01/2011
[    1.730471] Hardware name: Bochs Bochs, BIOS Bochs 01/01/2011
[    1.731523]  00000000
[    1.731523]  00000000 00000000 00000000 80033cc8 80033cc8 816b7fd7 816b7=
fd7 80033cf8 80033cf8 8102fe35 8102fe35 81935ad6 81935ad6 00000000 00000000

[    1.733053]  00000001
[    1.733053]  00000001 8196f37f 8196f37f 000000e8 000000e8 8129faab 8129f=
aab 8129faab 8129faab 802e6000 802e6000 00000001 00000001 9240e480 9240e480

[    1.734602]  80033d08
[    1.734602]  80033d08 8102fef5 8102fef5 00000009 00000009 00000000 00000=
000 80033d20 80033d20 8129faab 8129faab 012e63a4 012e63a4 9240e480 9240e480

[    1.736132] Call Trace:
[    1.736132] Call Trace:
[    1.736587]  [<816b7fd7>] dump_stack+0x16/0x18
[    1.736587]  [<816b7fd7>] dump_stack+0x16/0x18
[    1.737426]  [<8102fe35>] warn_slowpath_common+0x75/0x8c
[    1.737426]  [<8102fe35>] warn_slowpath_common+0x75/0x8c
[    1.738396]  [<8129faab>] ? drm_helper_encoder_in_use+0x43/0x83
[    1.738396]  [<8129faab>] ? drm_helper_encoder_in_use+0x43/0x83
[    1.739474]  [<8129faab>] ? drm_helper_encoder_in_use+0x43/0x83
[    1.739474]  [<8129faab>] ? drm_helper_encoder_in_use+0x43/0x83
[    1.740645]  [<8102fef5>] warn_slowpath_null+0x22/0x24
[    1.740645]  [<8102fef5>] warn_slowpath_null+0x22/0x24
[    1.741617]  [<8129faab>] drm_helper_encoder_in_use+0x43/0x83
[    1.741617]  [<8129faab>] drm_helper_encoder_in_use+0x43/0x83
[    1.742669]  [<8129fbd7>] drm_helper_disable_unused_functions+0x61/0xd4
[    1.742669]  [<8129fbd7>] drm_helper_disable_unused_functions+0x61/0xd4
[    1.743875]  [<813ebdc3>] cirrus_fbdev_init+0x77/0x92
[    1.743875]  [<813ebdc3>] cirrus_fbdev_init+0x77/0x92
[    1.744804]  [<813eb5f4>] cirrus_modeset_init+0x153/0x19c
[    1.744804]  [<813eb5f4>] cirrus_modeset_init+0x153/0x19c
[    1.745814]  [<813ea76b>] cirrus_driver_load+0x93/0xde
[    1.745814]  [<813ea76b>] cirrus_driver_load+0x93/0xde
[    1.746763]  [<812aba1e>] drm_dev_register+0x6e/0xd3
[    1.746763]  [<812aba1e>] drm_dev_register+0x6e/0xd3
[    1.747675]  [<812ad56a>] drm_get_pci_dev+0xdc/0x190
[    1.747675]  [<812ad56a>] drm_get_pci_dev+0xdc/0x190
[    1.748586]  [<813eb6ff>] cirrus_pci_probe+0x87/0x93
[    1.748586]  [<813eb6ff>] cirrus_pci_probe+0x87/0x93
[    1.749521]  [<811ad0d6>] pci_device_probe+0x4c/0x8d
[    1.749521]  [<811ad0d6>] pci_device_probe+0x4c/0x8d
[    1.750523]  [<811161d5>] ? sysfs_create_link+0x2c/0x35
[    1.750523]  [<811161d5>] ? sysfs_create_link+0x2c/0x35
[    1.751498]  [<8149af17>] driver_probe_device+0x99/0x1c1
[    1.751498]  [<8149af17>] driver_probe_device+0x99/0x1c1
[    1.752480]  [<811acf09>] ? pci_match_device+0x9f/0xa5
[    1.752480]  [<811acf09>] ? pci_match_device+0x9f/0xa5
[    1.753449]  [<8149b0c3>] __driver_attach+0x53/0x6f
[    1.753449]  [<8149b0c3>] __driver_attach+0x53/0x6f
[    1.754348]  [<81499b79>] bus_for_each_dev+0x3e/0x69
[    1.754348]  [<81499b79>] bus_for_each_dev+0x3e/0x69
[    1.755264]  [<8149ae35>] driver_attach+0x1c/0x1e
[    1.755264]  [<8149ae35>] driver_attach+0x1c/0x1e
[    1.756125]  [<8149b070>] ? __device_attach+0x31/0x31
[    1.756125]  [<8149b070>] ? __device_attach+0x31/0x31
[    1.757048]  [<8149a230>] bus_add_driver+0xc7/0x1a9
[    1.757048]  [<8149a230>] bus_add_driver+0xc7/0x1a9
[    1.757964]  [<8149b55f>] driver_register+0x96/0xca
[    1.757964]  [<8149b55f>] driver_register+0x96/0xca
[    1.758868]  [<810600f4>] ? __raw_spin_lock_init+0x32/0x53
[    1.758868]  [<810600f4>] ? __raw_spin_lock_init+0x32/0x53
[    1.759870]  [<811acf85>] __pci_register_driver+0x4a/0x4d
[    1.759870]  [<811acf85>] __pci_register_driver+0x4a/0x4d
[    1.760947]  [<812ad67f>] drm_pci_init+0x61/0xd8
[    1.760947]  [<812ad67f>] drm_pci_init+0x61/0xd8
[    1.761818]  [<81c70b2c>] ? tdfx_init+0x14/0x14
[    1.761818]  [<81c70b2c>] ? tdfx_init+0x14/0x14
[    1.762645]  [<81c71f2a>] ? mgag200_init+0x25/0x25
[    1.762645]  [<81c71f2a>] ? mgag200_init+0x25/0x25
[    1.763526]  [<81c71f45>] cirrus_init+0x1b/0x25
[    1.763526]  [<81c71f45>] cirrus_init+0x1b/0x25
[    1.764362]  [<81c46add>] do_one_initcall+0x8b/0x14b
[    1.764362]  [<81c46add>] do_one_initcall+0x8b/0x14b
[    1.765294]  [<8105bc23>] ? lock_release_holdtime+0xc1/0xcd
[    1.765294]  [<8105bc23>] ? lock_release_holdtime+0xc1/0xcd
[    1.766322]  [<81047ae2>] ? parameqn+0xc/0x41
[    1.766322]  [<81047ae2>] ? parameqn+0xc/0x41
[    1.767124]  [<81c46452>] ? repair_env_string+0x12/0x51
[    1.767124]  [<81c46452>] ? repair_env_string+0x12/0x51
[    1.768087]  [<81047caa>] ? parse_args+0x16e/0x231
[    1.768087]  [<81047caa>] ? parse_args+0x16e/0x231
[    1.768975]  [<81c46c6c>] kernel_init_freeable+0xcf/0x16e
[    1.768975]  [<81c46c6c>] kernel_init_freeable+0xcf/0x16e
[    1.769987]  [<81c46440>] ? do_early_param+0x7a/0x7a
[    1.769987]  [<81c46440>] ? do_early_param+0x7a/0x7a
[    1.771006]  [<816b3ed4>] kernel_init+0x10/0xcb
[    1.771006]  [<816b3ed4>] kernel_init+0x10/0xcb
[    1.771859]  [<8105280b>] ? schedule_tail+0x17/0x3e
[    1.771859]  [<8105280b>] ? schedule_tail+0x17/0x3e
[    1.772763]  [<816c2e37>] ret_from_kernel_thread+0x1b/0x28
[    1.772763]  [<816c2e37>] ret_from_kernel_thread+0x1b/0x28
[    1.773794]  [<816b3ec4>] ? rest_init+0xbc/0xbc
[    1.773794]  [<816b3ec4>] ? rest_init+0xbc/0xbc
[    1.774635] ---[ end trace a205f4c9292ec49f ]---
[    1.774635] ---[ end trace a205f4c9292ec49f ]---
[    1.775488] ------------[ cut here ]------------
[    1.775488] ------------[ cut here ]------------
[    1.776339] WARNING: CPU: 0 PID: 1 at drivers/gpu/drm/drm_crtc_helper.c:=
256 drm_helper_crtc_in_use+0x43/0x8b()
[    1.776339] WARNING: CPU: 0 PID: 1 at drivers/gpu/drm/drm_crtc_helper.c:=
256 drm_helper_crtc_in_use+0x43/0x8b()
[    1.778571] CPU: 0 PID: 1 Comm: swapper Tainted: G        W    3.14.0-rc=
7-wl-ath-04519-g2d18516 #9
[    1.778571] CPU: 0 PID: 1 Comm: swapper Tainted: G        W    3.14.0-rc=
7-wl-ath-04519-g2d18516 #9
[    1.780304] Hardware name: Bochs Bochs, BIOS Bochs 01/01/2011
[    1.780304] Hardware name: Bochs Bochs, BIOS Bochs 01/01/2011
[    1.781383]  00000000
[    1.781383]  00000000 00000000 00000000 80033cc8 80033cc8 816b7fd7 816b7=
fd7 80033cf8 80033cf8 8102fe35 8102fe35 81935ad6 81935ad6 00000000 00000000

[    1.782914]  00000001
[    1.782914]  00000001 8196f37f 8196f37f 00000100 00000100 8129fb2e 8129f=
b2e 8129fb2e 8129fb2e 802e6000 802e6000 00000001 00000001 92407000 92407000

[    1.784447]  80033d08
[    1.784447]  80033d08 8102fef5 8102fef5 00000009 00000009 00000000 00000=
000 80033d20 80033d20 8129fb2e 8129fb2e 01000000 01000000 92407000 92407000

[    1.785991] Call Trace:
[    1.785991] Call Trace:
[    1.786456]  [<816b7fd7>] dump_stack+0x16/0x18
[    1.786456]  [<816b7fd7>] dump_stack+0x16/0x18
[    1.787279]  [<8102fe35>] warn_slowpath_common+0x75/0x8c
[    1.787279]  [<8102fe35>] warn_slowpath_common+0x75/0x8c
[    1.788263]  [<8129fb2e>] ? drm_helper_crtc_in_use+0x43/0x8b
[    1.788263]  [<8129fb2e>] ? drm_helper_crtc_in_use+0x43/0x8b
[    1.789330]  [<8129fb2e>] ? drm_helper_crtc_in_use+0x43/0x8b
[    1.789330]  [<8129fb2e>] ? drm_helper_crtc_in_use+0x43/0x8b
[    1.790470]  [<8102fef5>] warn_slowpath_null+0x22/0x24
[    1.790470]  [<8102fef5>] warn_slowpath_null+0x22/0x24
[    1.791416]  [<8129fb2e>] drm_helper_crtc_in_use+0x43/0x8b
[    1.791416]  [<8129fb2e>] drm_helper_crtc_in_use+0x43/0x8b
[    1.792415]  [<8129fc14>] drm_helper_disable_unused_functions+0x9e/0xd4
[    1.792415]  [<8129fc14>] drm_helper_disable_unused_functions+0x9e/0xd4
[    1.793642]  [<813ebdc3>] cirrus_fbdev_init+0x77/0x92
[    1.793642]  [<813ebdc3>] cirrus_fbdev_init+0x77/0x92
[    1.794578]  [<813eb5f4>] cirrus_modeset_init+0x153/0x19c
[    1.794578]  [<813eb5f4>] cirrus_modeset_init+0x153/0x19c
[    1.795576]  [<813ea76b>] cirrus_driver_load+0x93/0xde
[    1.795576]  [<813ea76b>] cirrus_driver_load+0x93/0xde
[    1.796530]  [<812aba1e>] drm_dev_register+0x6e/0xd3
[    1.796530]  [<812aba1e>] drm_dev_register+0x6e/0xd3
[    1.797467]  [<812ad56a>] drm_get_pci_dev+0xdc/0x190
[    1.797467]  [<812ad56a>] drm_get_pci_dev+0xdc/0x190
[    1.798386]  [<813eb6ff>] cirrus_pci_probe+0x87/0x93
[    1.798386]  [<813eb6ff>] cirrus_pci_probe+0x87/0x93
[    1.799299]  [<811ad0d6>] pci_device_probe+0x4c/0x8d
[    1.799299]  [<811ad0d6>] pci_device_probe+0x4c/0x8d
[    1.800304]  [<811161d5>] ? sysfs_create_link+0x2c/0x35
[    1.800304]  [<811161d5>] ? sysfs_create_link+0x2c/0x35
[    1.801285]  [<8149af17>] driver_probe_device+0x99/0x1c1
[    1.801285]  [<8149af17>] driver_probe_device+0x99/0x1c1
[    1.802261]  [<811acf09>] ? pci_match_device+0x9f/0xa5
[    1.802261]  [<811acf09>] ? pci_match_device+0x9f/0xa5
[    1.803201]  [<8149b0c3>] __driver_attach+0x53/0x6f
[    1.803201]  [<8149b0c3>] __driver_attach+0x53/0x6f
[    1.804090]  [<81499b79>] bus_for_each_dev+0x3e/0x69
[    1.804090]  [<81499b79>] bus_for_each_dev+0x3e/0x69
[    1.805003]  [<8149ae35>] driver_attach+0x1c/0x1e
[    1.805003]  [<8149ae35>] driver_attach+0x1c/0x1e
[    1.805888]  [<8149b070>] ? __device_attach+0x31/0x31
[    1.805888]  [<8149b070>] ? __device_attach+0x31/0x31
[    1.806821]  [<8149a230>] bus_add_driver+0xc7/0x1a9
[    1.806821]  [<8149a230>] bus_add_driver+0xc7/0x1a9
[    1.807729]  [<8149b55f>] driver_register+0x96/0xca
[    1.807729]  [<8149b55f>] driver_register+0x96/0xca
[    1.808690]  [<810600f4>] ? __raw_spin_lock_init+0x32/0x53
[    1.808690]  [<810600f4>] ? __raw_spin_lock_init+0x32/0x53
[    1.809722]  [<811acf85>] __pci_register_driver+0x4a/0x4d
[    1.809722]  [<811acf85>] __pci_register_driver+0x4a/0x4d
[    1.810808]  [<812ad67f>] drm_pci_init+0x61/0xd8
[    1.810808]  [<812ad67f>] drm_pci_init+0x61/0xd8
[    1.811671]  [<81c70b2c>] ? tdfx_init+0x14/0x14
[    1.811671]  [<81c70b2c>] ? tdfx_init+0x14/0x14
[    1.812510]  [<81c71f2a>] ? mgag200_init+0x25/0x25
[    1.812510]  [<81c71f2a>] ? mgag200_init+0x25/0x25
[    1.813419]  [<81c71f45>] cirrus_init+0x1b/0x25
[    1.813419]  [<81c71f45>] cirrus_init+0x1b/0x25
[    1.814257]  [<81c46add>] do_one_initcall+0x8b/0x14b
[    1.814257]  [<81c46add>] do_one_initcall+0x8b/0x14b
[    1.815176]  [<8105bc23>] ? lock_release_holdtime+0xc1/0xcd
[    1.815176]  [<8105bc23>] ? lock_release_holdtime+0xc1/0xcd
[    1.816198]  [<81047ae2>] ? parameqn+0xc/0x41
[    1.816198]  [<81047ae2>] ? parameqn+0xc/0x41
[    1.817000]  [<81c46452>] ? repair_env_string+0x12/0x51
[    1.817000]  [<81c46452>] ? repair_env_string+0x12/0x51
[    1.817979]  [<81047caa>] ? parse_args+0x16e/0x231
[    1.817979]  [<81047caa>] ? parse_args+0x16e/0x231
[    1.818868]  [<81c46c6c>] kernel_init_freeable+0xcf/0x16e
[    1.818868]  [<81c46c6c>] kernel_init_freeable+0xcf/0x16e
[    1.819862]  [<81c46440>] ? do_early_param+0x7a/0x7a
[    1.819862]  [<81c46440>] ? do_early_param+0x7a/0x7a
[    1.820878]  [<816b3ed4>] kernel_init+0x10/0xcb
[    1.820878]  [<816b3ed4>] kernel_init+0x10/0xcb
[    1.821736]  [<8105280b>] ? schedule_tail+0x17/0x3e
[    1.821736]  [<8105280b>] ? schedule_tail+0x17/0x3e
[    1.822626]  [<816c2e37>] ret_from_kernel_thread+0x1b/0x28
[    1.822626]  [<816c2e37>] ret_from_kernel_thread+0x1b/0x28
[    1.823630]  [<816b3ec4>] ? rest_init+0xbc/0xbc
[    1.823630]  [<816b3ec4>] ? rest_init+0xbc/0xbc
[    1.824464] ---[ end trace a205f4c9292ec4a0 ]---
[    1.824464] ---[ end trace a205f4c9292ec4a0 ]---
[    1.825384] ------------[ cut here ]------------
[    1.825384] ------------[ cut here ]------------
[    1.826234] WARNING: CPU: 0 PID: 1 at drivers/gpu/drm/drm_crtc_helper.c:=
131 drm_helper_probe_single_connector_modes+0x56/0x310()
[    1.826234] WARNING: CPU: 0 PID: 1 at drivers/gpu/drm/drm_crtc_helper.c:=
131 drm_helper_probe_single_connector_modes+0x56/0x310()
[    1.828732] CPU: 0 PID: 1 Comm: swapper Tainted: G        W    3.14.0-rc=
7-wl-ath-04519-g2d18516 #9
[    1.828732] CPU: 0 PID: 1 Comm: swapper Tainted: G        W    3.14.0-rc=
7-wl-ath-04519-g2d18516 #9
[    1.830482] Hardware name: Bochs Bochs, BIOS Bochs 01/01/2011
[    1.830482] Hardware name: Bochs Bochs, BIOS Bochs 01/01/2011
[    1.831541]  00000000
[    1.831541]  00000000 00000000 00000000 80033c20 80033c20 816b7fd7 816b7=
fd7 80033c50 80033c50 8102fe35 8102fe35 81935ad6 81935ad6 00000000 00000000

[    1.833068]  00000001
[    1.833068]  00000001 8196f37f 8196f37f 00000083 00000083 812a0d31 812a0=
d31 812a0d31 812a0d31 00000001 00000001 92402800 92402800 00000001 00000001

[    1.834619]  80033c60
[    1.834619]  80033c60 8102fef5 8102fef5 00000009 00000009 00000000 00000=
000 80033c9c 80033c9c 812a0d31 812a0d31 00000020 00000020 00000000 00000000

[    1.836149] Call Trace:
[    1.836149] Call Trace:
[    1.836606]  [<816b7fd7>] dump_stack+0x16/0x18
[    1.836606]  [<816b7fd7>] dump_stack+0x16/0x18
[    1.837452]  [<8102fe35>] warn_slowpath_common+0x75/0x8c
[    1.837452]  [<8102fe35>] warn_slowpath_common+0x75/0x8c
[    1.838432]  [<812a0d31>] ? drm_helper_probe_single_connector_modes+0x56=
/0x310
[    1.838432]  [<812a0d31>] ? drm_helper_probe_single_connector_modes+0x56=
/0x310
[    1.839763]  [<812a0d31>] ? drm_helper_probe_single_connector_modes+0x56=
/0x310
[    1.839763]  [<812a0d31>] ? drm_helper_probe_single_connector_modes+0x56=
/0x310
[    1.841187]  [<8102fef5>] warn_slowpath_null+0x22/0x24
[    1.841187]  [<8102fef5>] warn_slowpath_null+0x22/0x24
[    1.842143]  [<812a0d31>] drm_helper_probe_single_connector_modes+0x56/0=
x310
[    1.842143]  [<812a0d31>] drm_helper_probe_single_connector_modes+0x56/0=
x310
[    1.843426]  [<812b5127>] ? drm_mode_parse_command_line_for_connector+0x=
e/0x3de
[    1.843426]  [<812b5127>] ? drm_mode_parse_command_line_for_connector+0x=
e/0x3de
[    1.844761]  [<812a1dec>] drm_fb_helper_probe_connector_modes+0x3a/0x4e
[    1.844761]  [<812a1dec>] drm_fb_helper_probe_connector_modes+0x3a/0x4e
[    1.845988]  [<812a3714>] drm_fb_helper_initial_config+0x174/0x3eb
[    1.845988]  [<812a3714>] drm_fb_helper_initial_config+0x174/0x3eb
[    1.847116]  [<8102fe44>] ? warn_slowpath_common+0x84/0x8c
[    1.847116]  [<8102fe44>] ? warn_slowpath_common+0x84/0x8c
[    1.848131]  [<8129fb2e>] ? drm_helper_crtc_in_use+0x43/0x8b
[    1.848131]  [<8129fb2e>] ? drm_helper_crtc_in_use+0x43/0x8b
[    1.849182]  [<8129fb2e>] ? drm_helper_crtc_in_use+0x43/0x8b
[    1.849182]  [<8129fb2e>] ? drm_helper_crtc_in_use+0x43/0x8b
[    1.850330]  [<8102fef5>] ? warn_slowpath_null+0x22/0x24
[    1.850330]  [<8102fef5>] ? warn_slowpath_null+0x22/0x24
[    1.851314]  [<8129fc31>] ? drm_helper_disable_unused_functions+0xbb/0xd4
[    1.851314]  [<8129fc31>] ? drm_helper_disable_unused_functions+0xbb/0xd4
[    1.852562]  [<813ebdcf>] cirrus_fbdev_init+0x83/0x92
[    1.852562]  [<813ebdcf>] cirrus_fbdev_init+0x83/0x92
[    1.853514]  [<813eb5f4>] cirrus_modeset_init+0x153/0x19c
[    1.853514]  [<813eb5f4>] cirrus_modeset_init+0x153/0x19c
[    1.854505]  [<813ea76b>] cirrus_driver_load+0x93/0xde
[    1.854505]  [<813ea76b>] cirrus_driver_load+0x93/0xde
[    1.855449]  [<812aba1e>] drm_dev_register+0x6e/0xd3
[    1.855449]  [<812aba1e>] drm_dev_register+0x6e/0xd3
[    1.856365]  [<812ad56a>] drm_get_pci_dev+0xdc/0x190
[    1.856365]  [<812ad56a>] drm_get_pci_dev+0xdc/0x190
[    1.857294]  [<813eb6ff>] cirrus_pci_probe+0x87/0x93
[    1.857294]  [<813eb6ff>] cirrus_pci_probe+0x87/0x93
[    1.858209]  [<811ad0d6>] pci_device_probe+0x4c/0x8d
[    1.858209]  [<811ad0d6>] pci_device_probe+0x4c/0x8d
[    1.859113]  [<811161d5>] ? sysfs_create_link+0x2c/0x35
[    1.859113]  [<811161d5>] ? sysfs_create_link+0x2c/0x35
[    1.860181]  [<8149af17>] driver_probe_device+0x99/0x1c1
[    1.860181]  [<8149af17>] driver_probe_device+0x99/0x1c1
[    1.861167]  [<811acf09>] ? pci_match_device+0x9f/0xa5
[    1.861167]  [<811acf09>] ? pci_match_device+0x9f/0xa5
[    1.862126]  [<8149b0c3>] __driver_attach+0x53/0x6f
[    1.862126]  [<8149b0c3>] __driver_attach+0x53/0x6f
[    1.863019]  [<81499b79>] bus_for_each_dev+0x3e/0x69
[    1.863019]  [<81499b79>] bus_for_each_dev+0x3e/0x69
[    1.863937]  [<8149ae35>] driver_attach+0x1c/0x1e
[    1.863937]  [<8149ae35>] driver_attach+0x1c/0x1e
[    1.864801]  [<8149b070>] ? __device_attach+0x31/0x31
[    1.864801]  [<8149b070>] ? __device_attach+0x31/0x31
[    1.865745]  [<8149a230>] bus_add_driver+0xc7/0x1a9
[    1.865745]  [<8149a230>] bus_add_driver+0xc7/0x1a9
[    1.866645]  [<8149b55f>] driver_register+0x96/0xca
[    1.866645]  [<8149b55f>] driver_register+0x96/0xca
[    1.867540]  [<810600f4>] ? __raw_spin_lock_init+0x32/0x53
[    1.867540]  [<810600f4>] ? __raw_spin_lock_init+0x32/0x53
[    1.868542]  [<811acf85>] __pci_register_driver+0x4a/0x4d
[    1.868542]  [<811acf85>] __pci_register_driver+0x4a/0x4d
[    1.869563]  [<812ad67f>] drm_pci_init+0x61/0xd8
[    1.869563]  [<812ad67f>] drm_pci_init+0x61/0xd8
[    1.870510]  [<81c70b2c>] ? tdfx_init+0x14/0x14
[    1.870510]  [<81c70b2c>] ? tdfx_init+0x14/0x14
[    1.871352]  [<81c71f2a>] ? mgag200_init+0x25/0x25
[    1.871352]  [<81c71f2a>] ? mgag200_init+0x25/0x25
[    1.872238]  [<81c71f45>] cirrus_init+0x1b/0x25
[    1.872238]  [<81c71f45>] cirrus_init+0x1b/0x25
[    1.873070]  [<81c46add>] do_one_initcall+0x8b/0x14b
[    1.873070]  [<81c46add>] do_one_initcall+0x8b/0x14b
[    1.874006]  [<8105bc23>] ? lock_release_holdtime+0xc1/0xcd
[    1.874006]  [<8105bc23>] ? lock_release_holdtime+0xc1/0xcd
[    1.875041]  [<81047ae2>] ? parameqn+0xc/0x41
[    1.875041]  [<81047ae2>] ? parameqn+0xc/0x41
[    1.875852]  [<81c46452>] ? repair_env_string+0x12/0x51
[    1.875852]  [<81c46452>] ? repair_env_string+0x12/0x51
[    1.876820]  [<81047caa>] ? parse_args+0x16e/0x231
[    1.876820]  [<81047caa>] ? parse_args+0x16e/0x231
[    1.877723]  [<81c46c6c>] kernel_init_freeable+0xcf/0x16e
[    1.877723]  [<81c46c6c>] kernel_init_freeable+0xcf/0x16e
[    1.878717]  [<81c46440>] ? do_early_param+0x7a/0x7a
[    1.878717]  [<81c46440>] ? do_early_param+0x7a/0x7a
[    1.879633]  [<816b3ed4>] kernel_init+0x10/0xcb
[    1.879633]  [<816b3ed4>] kernel_init+0x10/0xcb
[    1.880556]  [<8105280b>] ? schedule_tail+0x17/0x3e
[    1.880556]  [<8105280b>] ? schedule_tail+0x17/0x3e
[    1.881487]  [<816c2e37>] ret_from_kernel_thread+0x1b/0x28
[    1.881487]  [<816c2e37>] ret_from_kernel_thread+0x1b/0x28
[    1.882499]  [<816b3ec4>] ? rest_init+0xbc/0xbc
[    1.882499]  [<816b3ec4>] ? rest_init+0xbc/0xbc
[    1.883340] ---[ end trace a205f4c9292ec4a1 ]---
[    1.883340] ---[ end trace a205f4c9292ec4a1 ]---
[    1.884200] ------------[ cut here ]------------
[    1.884200] ------------[ cut here ]------------
[    1.885052] WARNING: CPU: 0 PID: 1 at drivers/gpu/drm/drm_modes.c:119 dr=
m_mode_probed_add+0x44/0x68()
[    1.885052] WARNING: CPU: 0 PID: 1 at drivers/gpu/drm/drm_modes.c:119 dr=
m_mode_probed_add+0x44/0x68()
[    1.887136] CPU: 0 PID: 1 Comm: swapper Tainted: G        W    3.14.0-rc=
7-wl-ath-04519-g2d18516 #9
[    1.887136] CPU: 0 PID: 1 Comm: swapper Tainted: G        W    3.14.0-rc=
7-wl-ath-04519-g2d18516 #9
[    1.888763] Hardware name: Bochs Bochs, BIOS Bochs 01/01/2011
[    1.888763] Hardware name: Bochs Bochs, BIOS Bochs 01/01/2011
[    1.889835]  00000000
[    1.889835]  00000000 00000000 00000000 80033bd8 80033bd8 816b7fd7 816b7=
fd7 80033c08 80033c08 8102fe35 8102fe35 81935ad6 81935ad6 00000000 00000000

[    1.891481]  00000001
[    1.891481]  00000001 819720ae 819720ae 00000077 00000077 812b4656 812b4=
656 812b4656 812b4656 929b8580 929b8580 92402800 92402800 00000001 00000001

[    1.893023]  80033c18
[    1.893023]  80033c18 8102fef5 8102fef5 00000009 00000009 00000000 00000=
000 80033c30 80033c30 812b4656 812b4656 01000000 01000000 81786158 81786158

[    1.894586] Call Trace:
[    1.894586] Call Trace:
[    1.895043]  [<816b7fd7>] dump_stack+0x16/0x18
[    1.895043]  [<816b7fd7>] dump_stack+0x16/0x18
[    1.895864]  [<8102fe35>] warn_slowpath_common+0x75/0x8c
[    1.895864]  [<8102fe35>] warn_slowpath_common+0x75/0x8c
[    1.896834]  [<812b4656>] ? drm_mode_probed_add+0x44/0x68
[    1.896834]  [<812b4656>] ? drm_mode_probed_add+0x44/0x68
[    1.897842]  [<812b4656>] ? drm_mode_probed_add+0x44/0x68
[    1.897842]  [<812b4656>] ? drm_mode_probed_add+0x44/0x68
[    1.898835]  [<8102fef5>] warn_slowpath_null+0x22/0x24
[    1.898835]  [<8102fef5>] warn_slowpath_null+0x22/0x24
[    1.899782]  [<812b4656>] drm_mode_probed_add+0x44/0x68
[    1.899782]  [<812b4656>] drm_mode_probed_add+0x44/0x68
[    1.900821]  [<812b8100>] drm_add_modes_noedid+0x68/0x84
[    1.900821]  [<812b8100>] drm_add_modes_noedid+0x68/0x84
[    1.901825]  [<813eaa99>] cirrus_vga_get_modes+0x1b/0x34
[    1.901825]  [<813eaa99>] cirrus_vga_get_modes+0x1b/0x34
[    1.902816]  [<812a0e00>] drm_helper_probe_single_connector_modes+0x125/=
0x310
[    1.902816]  [<812a0e00>] drm_helper_probe_single_connector_modes+0x125/=
0x310
[    1.904134]  [<812a1dec>] drm_fb_helper_probe_connector_modes+0x3a/0x4e
[    1.904134]  [<812a1dec>] drm_fb_helper_probe_connector_modes+0x3a/0x4e
[    1.905393]  [<812a3714>] drm_fb_helper_initial_config+0x174/0x3eb
[    1.905393]  [<812a3714>] drm_fb_helper_initial_config+0x174/0x3eb
[    1.906529]  [<8102fe44>] ? warn_slowpath_common+0x84/0x8c
[    1.906529]  [<8102fe44>] ? warn_slowpath_common+0x84/0x8c
[    1.907534]  [<8129fb2e>] ? drm_helper_crtc_in_use+0x43/0x8b
[    1.907534]  [<8129fb2e>] ? drm_helper_crtc_in_use+0x43/0x8b
[    1.908571]  [<8129fb2e>] ? drm_helper_crtc_in_use+0x43/0x8b
[    1.908571]  [<8129fb2e>] ? drm_helper_crtc_in_use+0x43/0x8b
[    1.909624]  [<8102fef5>] ? warn_slowpath_null+0x22/0x24
[    1.909624]  [<8102fef5>] ? warn_slowpath_null+0x22/0x24
[    1.910696]  [<8129fc31>] ? drm_helper_disable_unused_functions+0xbb/0xd4
[    1.910696]  [<8129fc31>] ? drm_helper_disable_unused_functions+0xbb/0xd4
[    1.911947]  [<813ebdcf>] cirrus_fbdev_init+0x83/0x92
[    1.911947]  [<813ebdcf>] cirrus_fbdev_init+0x83/0x92
[    1.912884]  [<813eb5f4>] cirrus_modeset_init+0x153/0x19c
[    1.912884]  [<813eb5f4>] cirrus_modeset_init+0x153/0x19c
[    1.913891]  [<813ea76b>] cirrus_driver_load+0x93/0xde
[    1.913891]  [<813ea76b>] cirrus_driver_load+0x93/0xde
[    1.914830]  [<812aba1e>] drm_dev_register+0x6e/0xd3
[    1.914830]  [<812aba1e>] drm_dev_register+0x6e/0xd3
[    1.915743]  [<812ad56a>] drm_get_pci_dev+0xdc/0x190
[    1.915743]  [<812ad56a>] drm_get_pci_dev+0xdc/0x190
[    1.916652]  [<813eb6ff>] cirrus_pci_probe+0x87/0x93
[    1.916652]  [<813eb6ff>] cirrus_pci_probe+0x87/0x93
[    1.917578]  [<811ad0d6>] pci_device_probe+0x4c/0x8d
[    1.917578]  [<811ad0d6>] pci_device_probe+0x4c/0x8d
[    1.918488]  [<811161d5>] ? sysfs_create_link+0x2c/0x35
[    1.918488]  [<811161d5>] ? sysfs_create_link+0x2c/0x35
[    1.919442]  [<8149af17>] driver_probe_device+0x99/0x1c1
[    1.919442]  [<8149af17>] driver_probe_device+0x99/0x1c1
[    1.920507]  [<811acf09>] ? pci_match_device+0x9f/0xa5
[    1.920507]  [<811acf09>] ? pci_match_device+0x9f/0xa5
[    1.921477]  [<8149b0c3>] __driver_attach+0x53/0x6f
[    1.921477]  [<8149b0c3>] __driver_attach+0x53/0x6f
[    1.922379]  [<81499b79>] bus_for_each_dev+0x3e/0x69
[    1.922379]  [<81499b79>] bus_for_each_dev+0x3e/0x69
[    1.923295]  [<8149ae35>] driver_attach+0x1c/0x1e
[    1.923295]  [<8149ae35>] driver_attach+0x1c/0x1e
[    1.924156]  [<8149b070>] ? __device_attach+0x31/0x31
[    1.924156]  [<8149b070>] ? __device_attach+0x31/0x31
[    1.925076]  [<8149a230>] bus_add_driver+0xc7/0x1a9
[    1.925076]  [<8149a230>] bus_add_driver+0xc7/0x1a9
[    1.925985]  [<8149b55f>] driver_register+0x96/0xca
[    1.925985]  [<8149b55f>] driver_register+0x96/0xca
[    1.926885]  [<810600f4>] ? __raw_spin_lock_init+0x32/0x53
[    1.926885]  [<810600f4>] ? __raw_spin_lock_init+0x32/0x53
[    1.927888]  [<811acf85>] __pci_register_driver+0x4a/0x4d
[    1.927888]  [<811acf85>] __pci_register_driver+0x4a/0x4d
[    1.928876]  [<812ad67f>] drm_pci_init+0x61/0xd8
[    1.928876]  [<812ad67f>] drm_pci_init+0x61/0xd8
[    1.929745]  [<81c70b2c>] ? tdfx_init+0x14/0x14
[    1.929745]  [<81c70b2c>] ? tdfx_init+0x14/0x14
[    1.930663]  [<81c71f2a>] ? mgag200_init+0x25/0x25
[    1.930663]  [<81c71f2a>] ? mgag200_init+0x25/0x25
[    1.931554]  [<81c71f45>] cirrus_init+0x1b/0x25
[    1.931554]  [<81c71f45>] cirrus_init+0x1b/0x25
[    1.932398]  [<81c46add>] do_one_initcall+0x8b/0x14b
[    1.932398]  [<81c46add>] do_one_initcall+0x8b/0x14b
[    1.933332]  [<8105bc23>] ? lock_release_holdtime+0xc1/0xcd
[    1.933332]  [<8105bc23>] ? lock_release_holdtime+0xc1/0xcd
[    1.934358]  [<81047ae2>] ? parameqn+0xc/0x41
[    1.934358]  [<81047ae2>] ? parameqn+0xc/0x41
[    1.935165]  [<81c46452>] ? repair_env_string+0x12/0x51
[    1.935165]  [<81c46452>] ? repair_env_string+0x12/0x51
[    1.936122]  [<81047caa>] ? parse_args+0x16e/0x231
[    1.936122]  [<81047caa>] ? parse_args+0x16e/0x231
[    1.937003]  [<81c46c6c>] kernel_init_freeable+0xcf/0x16e
[    1.937003]  [<81c46c6c>] kernel_init_freeable+0xcf/0x16e
[    1.938013]  [<81c46440>] ? do_early_param+0x7a/0x7a
[    1.938013]  [<81c46440>] ? do_early_param+0x7a/0x7a
[    1.938927]  [<816b3ed4>] kernel_init+0x10/0xcb
[    1.938927]  [<816b3ed4>] kernel_init+0x10/0xcb
[    1.939760]  [<8105280b>] ? schedule_tail+0x17/0x3e
[    1.939760]  [<8105280b>] ? schedule_tail+0x17/0x3e
[    1.940746]  [<816c2e37>] ret_from_kernel_thread+0x1b/0x28
[    1.940746]  [<816c2e37>] ret_from_kernel_thread+0x1b/0x28
[    1.941784]  [<816b3ec4>] ? rest_init+0xbc/0xbc
[    1.941784]  [<816b3ec4>] ? rest_init+0xbc/0xbc
[    1.942619] ---[ end trace a205f4c9292ec4a2 ]---
[    1.942619] ---[ end trace a205f4c9292ec4a2 ]---
[    1.943469] ------------[ cut here ]------------
[    1.943469] ------------[ cut here ]------------
[    1.944313] WARNING: CPU: 0 PID: 1 at drivers/gpu/drm/drm_modes.c:119 dr=
m_mode_probed_add+0x44/0x68()
[    1.944313] WARNING: CPU: 0 PID: 1 at drivers/gpu/drm/drm_modes.c:119 dr=
m_mode_probed_add+0x44/0x68()
[    1.946401] CPU: 0 PID: 1 Comm: swapper Tainted: G        W    3.14.0-rc=
7-wl-ath-04519-g2d18516 #9
[    1.946401] CPU: 0 PID: 1 Comm: swapper Tainted: G        W    3.14.0-rc=
7-wl-ath-04519-g2d18516 #9
[    1.948024] Hardware name: Bochs Bochs, BIOS Bochs 01/01/2011
[    1.948024] Hardware name: Bochs Bochs, BIOS Bochs 01/01/2011
[    1.949074]  00000000
[    1.949074]  00000000 00000000 00000000 80033bd8 80033bd8 816b7fd7 816b7=
fd7 80033c08 80033c08 8102fe35 8102fe35 81935ad6 81935ad6 00000000 00000000

[    1.950732]  00000001
[    1.950732]  00000001 819720ae 819720ae 00000077 00000077 812b4656 812b4=
656 812b4656 812b4656 929b8480 929b8480 92402800 92402800 00000001 00000001

[    1.952278]  80033c18
[    1.952278]  80033c18 8102fef5 8102fef5 00000009 00000009 00000000 00000=
000 80033c30 80033c30 812b4656 812b4656 01000000 01000000 81786458 81786458

[    1.953838] Call Trace:
[    1.953838] Call Trace:
[    1.954299]  [<816b7fd7>] dump_stack+0x16/0x18
[    1.954299]  [<816b7fd7>] dump_stack+0x16/0x18
[    1.955120]  [<8102fe35>] warn_slowpath_common+0x75/0x8c
[    1.955120]  [<8102fe35>] warn_slowpath_common+0x75/0x8c
[    1.956083]  [<812b4656>] ? drm_mode_probed_add+0x44/0x68
[    1.956083]  [<812b4656>] ? drm_mode_probed_add+0x44/0x68
[    1.957071]  [<812b4656>] ? drm_mode_probed_add+0x44/0x68
[    1.957071]  [<812b4656>] ? drm_mode_probed_add+0x44/0x68
[    1.958079]  [<8102fef5>] warn_slowpath_null+0x22/0x24
[    1.958079]  [<8102fef5>] warn_slowpath_null+0x22/0x24
[    1.959027]  [<812b4656>] drm_mode_probed_add+0x44/0x68
[    1.959027]  [<812b4656>] drm_mode_probed_add+0x44/0x68
[    1.959988]  [<812b8100>] drm_add_modes_noedid+0x68/0x84
[    1.959988]  [<812b8100>] drm_add_modes_noedid+0x68/0x84
[    1.961038]  [<813eaa99>] cirrus_vga_get_modes+0x1b/0x34
[    1.961038]  [<813eaa99>] cirrus_vga_get_modes+0x1b/0x34
[    1.962043]  [<812a0e00>] drm_helper_probe_single_connector_modes+0x125/=
0x310
[    1.962043]  [<812a0e00>] drm_helper_probe_single_connector_modes+0x125/=
0x310
[    1.963357]  [<812a1dec>] drm_fb_helper_probe_connector_modes+0x3a/0x4e
[    1.963357]  [<812a1dec>] drm_fb_helper_probe_connector_modes+0x3a/0x4e
[    1.964575]  [<812a3714>] drm_fb_helper_initial_config+0x174/0x3eb
[    1.964575]  [<812a3714>] drm_fb_helper_initial_config+0x174/0x3eb
[    1.965729]  [<8102fe44>] ? warn_slowpath_common+0x84/0x8c
[    1.965729]  [<8102fe44>] ? warn_slowpath_common+0x84/0x8c
[    1.966732]  [<8129fb2e>] ? drm_helper_crtc_in_use+0x43/0x8b
[    1.966732]  [<8129fb2e>] ? drm_helper_crtc_in_use+0x43/0x8b
[    1.967771]  [<8129fb2e>] ? drm_helper_crtc_in_use+0x43/0x8b
[    1.967771]  [<8129fb2e>] ? drm_helper_crtc_in_use+0x43/0x8b
[    1.968806]  [<8102fef5>] ? warn_slowpath_null+0x22/0x24
[    1.968806]  [<8102fef5>] ? warn_slowpath_null+0x22/0x24
[    1.969798]  [<8129fc31>] ? drm_helper_disable_unused_functions+0xbb/0xd4
[    1.969798]  [<8129fc31>] ? drm_helper_disable_unused_functions+0xbb/0xd4
[    1.971126]  [<813ebdcf>] cirrus_fbdev_init+0x83/0x92
[    1.971126]  [<813ebdcf>] cirrus_fbdev_init+0x83/0x92
[    1.972054]  [<813eb5f4>] cirrus_modeset_init+0x153/0x19c
[    1.972054]  [<813eb5f4>] cirrus_modeset_init+0x153/0x19c
[    1.973044]  [<813ea76b>] cirrus_driver_load+0x93/0xde
[    1.973044]  [<813ea76b>] cirrus_driver_load+0x93/0xde
[    1.974012]  [<812aba1e>] drm_dev_register+0x6e/0xd3
[    1.974012]  [<812aba1e>] drm_dev_register+0x6e/0xd3
[    1.974934]  [<812ad56a>] drm_get_pci_dev+0xdc/0x190
[    1.974934]  [<812ad56a>] drm_get_pci_dev+0xdc/0x190
[    1.975850]  [<813eb6ff>] cirrus_pci_probe+0x87/0x93
[    1.975850]  [<813eb6ff>] cirrus_pci_probe+0x87/0x93
[    1.976763]  [<811ad0d6>] pci_device_probe+0x4c/0x8d
[    1.976763]  [<811ad0d6>] pci_device_probe+0x4c/0x8d
[    1.977698]  [<811161d5>] ? sysfs_create_link+0x2c/0x35
[    1.977698]  [<811161d5>] ? sysfs_create_link+0x2c/0x35
[    1.978653]  [<8149af17>] driver_probe_device+0x99/0x1c1
[    1.978653]  [<8149af17>] driver_probe_device+0x99/0x1c1
[    1.979631]  [<811acf09>] ? pci_match_device+0x9f/0xa5
[    1.979631]  [<811acf09>] ? pci_match_device+0x9f/0xa5
[    1.980668]  [<8149b0c3>] __driver_attach+0x53/0x6f
[    1.980668]  [<8149b0c3>] __driver_attach+0x53/0x6f
[    1.981589]  [<81499b79>] bus_for_each_dev+0x3e/0x69
[    1.981589]  [<81499b79>] bus_for_each_dev+0x3e/0x69
[    1.982505]  [<8149ae35>] driver_attach+0x1c/0x1e
[    1.982505]  [<8149ae35>] driver_attach+0x1c/0x1e
[    1.983373]  [<8149b070>] ? __device_attach+0x31/0x31
[    1.983373]  [<8149b070>] ? __device_attach+0x31/0x31
[    1.984305]  [<8149a230>] bus_add_driver+0xc7/0x1a9
[    1.984305]  [<8149a230>] bus_add_driver+0xc7/0x1a9
[    1.985228]  [<8149b55f>] driver_register+0x96/0xca
[    1.985228]  [<8149b55f>] driver_register+0x96/0xca
[    1.986124]  [<810600f4>] ? __raw_spin_lock_init+0x32/0x53
[    1.986124]  [<810600f4>] ? __raw_spin_lock_init+0x32/0x53
[    1.987140]  [<811acf85>] __pci_register_driver+0x4a/0x4d
[    1.987140]  [<811acf85>] __pci_register_driver+0x4a/0x4d
[    1.988139]  [<812ad67f>] drm_pci_init+0x61/0xd8
[    1.988139]  [<812ad67f>] drm_pci_init+0x61/0xd8
[    1.988990]  [<81c70b2c>] ? tdfx_init+0x14/0x14
[    1.988990]  [<81c70b2c>] ? tdfx_init+0x14/0x14
[    1.989837]  [<81c71f2a>] ? mgag200_init+0x25/0x25
[    1.989837]  [<81c71f2a>] ? mgag200_init+0x25/0x25
[    1.990806]  [<81c71f45>] cirrus_init+0x1b/0x25
[    1.990806]  [<81c71f45>] cirrus_init+0x1b/0x25
[    1.991651]  [<81c46add>] do_one_initcall+0x8b/0x14b
[    1.991651]  [<81c46add>] do_one_initcall+0x8b/0x14b
[    1.992567]  [<8105bc23>] ? lock_release_holdtime+0xc1/0xcd
[    1.992567]  [<8105bc23>] ? lock_release_holdtime+0xc1/0xcd
[    1.993613]  [<81047ae2>] ? parameqn+0xc/0x41
[    1.993613]  [<81047ae2>] ? parameqn+0xc/0x41
[    1.994421]  [<81c46452>] ? repair_env_string+0x12/0x51
[    1.994421]  [<81c46452>] ? repair_env_string+0x12/0x51
[    1.995380]  [<81047caa>] ? parse_args+0x16e/0x231
[    1.995380]  [<81047caa>] ? parse_args+0x16e/0x231
[    1.996255]  [<81c46c6c>] kernel_init_freeable+0xcf/0x16e
[    1.996255]  [<81c46c6c>] kernel_init_freeable+0xcf/0x16e
[    1.997267]  [<81c46440>] ? do_early_param+0x7a/0x7a
[    1.997267]  [<81c46440>] ? do_early_param+0x7a/0x7a
[    1.998179]  [<816b3ed4>] kernel_init+0x10/0xcb
[    1.998179]  [<816b3ed4>] kernel_init+0x10/0xcb
[    1.999004]  [<8105280b>] ? schedule_tail+0x17/0x3e
[    1.999004]  [<8105280b>] ? schedule_tail+0x17/0x3e
[    1.999898]  [<816c2e37>] ret_from_kernel_thread+0x1b/0x28
[    1.999898]  [<816c2e37>] ret_from_kernel_thread+0x1b/0x28
[    2.000990]  [<816b3ec4>] ? rest_init+0xbc/0xbc
[    2.000990]  [<816b3ec4>] ? rest_init+0xbc/0xbc
[    2.001842] ---[ end trace a205f4c9292ec4a3 ]---
[    2.001842] ---[ end trace a205f4c9292ec4a3 ]---
[    2.002696] ------------[ cut here ]------------
[    2.002696] ------------[ cut here ]------------
[    2.003551] WARNING: CPU: 0 PID: 1 at drivers/gpu/drm/drm_modes.c:119 dr=
m_mode_probed_add+0x44/0x68()
[    2.003551] WARNING: CPU: 0 PID: 1 at drivers/gpu/drm/drm_modes.c:119 dr=
m_mode_probed_add+0x44/0x68()
[    2.005637] CPU: 0 PID: 1 Comm: swapper Tainted: G        W    3.14.0-rc=
7-wl-ath-04519-g2d18516 #9
[    2.005637] CPU: 0 PID: 1 Comm: swapper Tainted: G        W    3.14.0-rc=
7-wl-ath-04519-g2d18516 #9
[    2.007262] Hardware name: Bochs Bochs, BIOS Bochs 01/01/2011
[    2.007262] Hardware name: Bochs Bochs, BIOS Bochs 01/01/2011
[    2.008310]  00000000
[    2.008310]  00000000 00000000 00000000 80033bd8 80033bd8 816b7fd7 816b7=
fd7 80033c08 80033c08 8102fe35 8102fe35 81935ad6 81935ad6 00000000 00000000

[    2.009856]  00000001
[    2.009856]  00000001 819720ae 819720ae 00000077 00000077 812b4656 812b4=
656 812b4656 812b4656 929b8380 929b8380 92402800 92402800 00000001 00000001

[    2.011504]  80033c18
[    2.011504]  80033c18 8102fef5 8102fef5 00000009 00000009 00000000 00000=
000 80033c30 80033c30 812b4656 812b4656 01000000 01000000 81786518 81786518

[    2.013037] Call Trace:
[    2.013037] Call Trace:
[    2.013521]  [<816b7fd7>] dump_stack+0x16/0x18
[    2.013521]  [<816b7fd7>] dump_stack+0x16/0x18
[    2.014345]  [<8102fe35>] warn_slowpath_common+0x75/0x8c
[    2.014345]  [<8102fe35>] warn_slowpath_common+0x75/0x8c
[    2.015325]  [<812b4656>] ? drm_mode_probed_add+0x44/0x68
[    2.015325]  [<812b4656>] ? drm_mode_probed_add+0x44/0x68
[    2.016318]  [<812b4656>] ? drm_mode_probed_add+0x44/0x68
[    2.016318]  [<812b4656>] ? drm_mode_probed_add+0x44/0x68
[    2.017333]  [<8102fef5>] warn_slowpath_null+0x22/0x24
[    2.017333]  [<8102fef5>] warn_slowpath_null+0x22/0x24
[    2.018283]  [<812b4656>] drm_mode_probed_add+0x44/0x68
[    2.018283]  [<812b4656>] drm_mode_probed_add+0x44/0x68
[    2.019243]  [<812b8100>] drm_add_modes_noedid+0x68/0x84
[    2.019243]  [<812b8100>] drm_add_modes_noedid+0x68/0x84
[    2.020320]  [<813eaa99>] cirrus_vga_get_modes+0x1b/0x34
[    2.020320]  [<813eaa99>] cirrus_vga_get_modes+0x1b/0x34
[    2.021315]  [<812a0e00>] drm_helper_probe_single_connector_modes+0x125/=
0x310
[    2.021315]  [<812a0e00>] drm_helper_probe_single_connector_modes+0x125/=
0x310
[    2.022619]  [<812a1dec>] drm_fb_helper_probe_connector_modes+0x3a/0x4e
[    2.022619]  [<812a1dec>] drm_fb_helper_probe_connector_modes+0x3a/0x4e
[    2.023831]  [<812a3714>] drm_fb_helper_initial_config+0x174/0x3eb
[    2.023831]  [<812a3714>] drm_fb_helper_initial_config+0x174/0x3eb
[    2.024962]  [<8102fe44>] ? warn_slowpath_common+0x84/0x8c
[    2.024962]  [<8102fe44>] ? warn_slowpath_common+0x84/0x8c
[    2.025980]  [<8129fb2e>] ? drm_helper_crtc_in_use+0x43/0x8b
[    2.025980]  [<8129fb2e>] ? drm_helper_crtc_in_use+0x43/0x8b
[    2.027014]  [<8129fb2e>] ? drm_helper_crtc_in_use+0x43/0x8b
[    2.027014]  [<8129fb2e>] ? drm_helper_crtc_in_use+0x43/0x8b
[    2.028042]  [<8102fef5>] ? warn_slowpath_null+0x22/0x24
[    2.028042]  [<8102fef5>] ? warn_slowpath_null+0x22/0x24
[    2.029012]  [<8129fc31>] ? drm_helper_disable_unused_functions+0xbb/0xd4
[    2.029012]  [<8129fc31>] ? drm_helper_disable_unused_functions+0xbb/0xd4
[    2.030407]  [<813ebdcf>] cirrus_fbdev_init+0x83/0x92
[    2.030407]  [<813ebdcf>] cirrus_fbdev_init+0x83/0x92
[    2.031336]  [<813eb5f4>] cirrus_modeset_init+0x153/0x19c
[    2.031336]  [<813eb5f4>] cirrus_modeset_init+0x153/0x19c
[    2.032324]  [<813ea76b>] cirrus_driver_load+0x93/0xde
[    2.032324]  [<813ea76b>] cirrus_driver_load+0x93/0xde
[    2.033288]  [<812aba1e>] drm_dev_register+0x6e/0xd3
[    2.033288]  [<812aba1e>] drm_dev_register+0x6e/0xd3
[    2.034207]  [<812ad56a>] drm_get_pci_dev+0xdc/0x190
[    2.034207]  [<812ad56a>] drm_get_pci_dev+0xdc/0x190
[    2.035125]  [<813eb6ff>] cirrus_pci_probe+0x87/0x93
[    2.035125]  [<813eb6ff>] cirrus_pci_probe+0x87/0x93
[    2.036038]  [<811ad0d6>] pci_device_probe+0x4c/0x8d
[    2.036038]  [<811ad0d6>] pci_device_probe+0x4c/0x8d
[    2.036952]  [<811161d5>] ? sysfs_create_link+0x2c/0x35
[    2.036952]  [<811161d5>] ? sysfs_create_link+0x2c/0x35
[    2.037929]  [<8149af17>] driver_probe_device+0x99/0x1c1
[    2.037929]  [<8149af17>] driver_probe_device+0x99/0x1c1
[    2.038908]  [<811acf09>] ? pci_match_device+0x9f/0xa5
[    2.038908]  [<811acf09>] ? pci_match_device+0x9f/0xa5
[    2.039851]  [<8149b0c3>] __driver_attach+0x53/0x6f
[    2.039851]  [<8149b0c3>] __driver_attach+0x53/0x6f
[    2.040861]  [<81499b79>] bus_for_each_dev+0x3e/0x69
[    2.040861]  [<81499b79>] bus_for_each_dev+0x3e/0x69
[    2.041804]  [<8149ae35>] driver_attach+0x1c/0x1e
[    2.041804]  [<8149ae35>] driver_attach+0x1c/0x1e
[    2.042669]  [<8149b070>] ? __device_attach+0x31/0x31
[    2.042669]  [<8149b070>] ? __device_attach+0x31/0x31
[    2.043602]  [<8149a230>] bus_add_driver+0xc7/0x1a9
[    2.043602]  [<8149a230>] bus_add_driver+0xc7/0x1a9
[    2.044505]  [<8149b55f>] driver_register+0x96/0xca
[    2.044505]  [<8149b55f>] driver_register+0x96/0xca
[    2.045424]  [<810600f4>] ? __raw_spin_lock_init+0x32/0x53
[    2.045424]  [<810600f4>] ? __raw_spin_lock_init+0x32/0x53
[    2.046430]  [<811acf85>] __pci_register_driver+0x4a/0x4d
[    2.046430]  [<811acf85>] __pci_register_driver+0x4a/0x4d
[    2.047420]  [<812ad67f>] drm_pci_init+0x61/0xd8
[    2.047420]  [<812ad67f>] drm_pci_init+0x61/0xd8
[    2.048270]  [<81c70b2c>] ? tdfx_init+0x14/0x14
[    2.048270]  [<81c70b2c>] ? tdfx_init+0x14/0x14
[    2.049099]  [<81c71f2a>] ? mgag200_init+0x25/0x25
[    2.049099]  [<81c71f2a>] ? mgag200_init+0x25/0x25
[    2.049997]  [<81c71f45>] cirrus_init+0x1b/0x25
[    2.049997]  [<81c71f45>] cirrus_init+0x1b/0x25
[    2.050932]  [<81c46add>] do_one_initcall+0x8b/0x14b
[    2.050932]  [<81c46add>] do_one_initcall+0x8b/0x14b
[    2.051856]  [<8105bc23>] ? lock_release_holdtime+0xc1/0xcd
[    2.051856]  [<8105bc23>] ? lock_release_holdtime+0xc1/0xcd
[    2.052885]  [<81047ae2>] ? parameqn+0xc/0x41
[    2.052885]  [<81047ae2>] ? parameqn+0xc/0x41
[    2.053710]  [<81c46452>] ? repair_env_string+0x12/0x51
[    2.053710]  [<81c46452>] ? repair_env_string+0x12/0x51
[    2.054670]  [<81047caa>] ? parse_args+0x16e/0x231
[    2.054670]  [<81047caa>] ? parse_args+0x16e/0x231
[    2.055551]  [<81c46c6c>] kernel_init_freeable+0xcf/0x16e
[    2.055551]  [<81c46c6c>] kernel_init_freeable+0xcf/0x16e
[    2.056543]  [<81c46440>] ? do_early_param+0x7a/0x7a
[    2.056543]  [<81c46440>] ? do_early_param+0x7a/0x7a
[    2.057476]  [<816b3ed4>] kernel_init+0x10/0xcb
[    2.057476]  [<816b3ed4>] kernel_init+0x10/0xcb
[    2.058315]  [<8105280b>] ? schedule_tail+0x17/0x3e
[    2.058315]  [<8105280b>] ? schedule_tail+0x17/0x3e
[    2.059211]  [<816c2e37>] ret_from_kernel_thread+0x1b/0x28
[    2.059211]  [<816c2e37>] ret_from_kernel_thread+0x1b/0x28
[    2.060322]  [<816b3ec4>] ? rest_init+0xbc/0xbc
[    2.060322]  [<816b3ec4>] ? rest_init+0xbc/0xbc
[    2.061167] ---[ end trace a205f4c9292ec4a4 ]---
[    2.061167] ---[ end trace a205f4c9292ec4a4 ]---
[    2.062028] ------------[ cut here ]------------
[    2.062028] ------------[ cut here ]------------
[    2.062884] WARNING: CPU: 0 PID: 1 at drivers/gpu/drm/drm_modes.c:119 dr=
m_mode_probed_add+0x44/0x68()
[    2.062884] WARNING: CPU: 0 PID: 1 at drivers/gpu/drm/drm_modes.c:119 dr=
m_mode_probed_add+0x44/0x68()
[    2.064945] CPU: 0 PID: 1 Comm: swapper Tainted: G        W    3.14.0-rc=
7-wl-ath-04519-g2d18516 #9
[    2.064945] CPU: 0 PID: 1 Comm: swapper Tainted: G        W    3.14.0-rc=
7-wl-ath-04519-g2d18516 #9
[    2.066589] Hardware name: Bochs Bochs, BIOS Bochs 01/01/2011
[    2.066589] Hardware name: Bochs Bochs, BIOS Bochs 01/01/2011
[    2.067638]  00000000
[    2.067638]  00000000 00000000 00000000 80033bd8 80033bd8 816b7fd7 816b7=
fd7 80033c08 80033c08 8102fe35 8102fe35 81935ad6 81935ad6 00000000 00000000

[    2.069193]  00000001
[    2.069193]  00000001 819720ae 819720ae 00000077 00000077 812b4656 812b4=
656 812b4656 812b4656 929b8280 929b8280 92402800 92402800 00000001 00000001

[    2.070846]  80033c18
[    2.070846]  80033c18 8102fef5 8102fef5 00000009 00000009 00000000 00000=
000 80033c30 80033c30 812b4656 812b4656 01000000 01000000 817868d8 817868d8

[    2.072381] Call Trace:
[    2.072381] Call Trace:
[    2.072836]  [<816b7fd7>] dump_stack+0x16/0x18
[    2.072836]  [<816b7fd7>] dump_stack+0x16/0x18
[    2.073678]  [<8102fe35>] warn_slowpath_common+0x75/0x8c
[    2.073678]  [<8102fe35>] warn_slowpath_common+0x75/0x8c
[    2.074652]  [<812b4656>] ? drm_mode_probed_add+0x44/0x68
[    2.074652]  [<812b4656>] ? drm_mode_probed_add+0x44/0x68
[    2.075653]  [<812b4656>] ? drm_mode_probed_add+0x44/0x68
[    2.075653]  [<812b4656>] ? drm_mode_probed_add+0x44/0x68
[    2.076646]  [<8102fef5>] warn_slowpath_null+0x22/0x24
[    2.076646]  [<8102fef5>] warn_slowpath_null+0x22/0x24
[    2.077612]  [<812b4656>] drm_mode_probed_add+0x44/0x68
[    2.077612]  [<812b4656>] drm_mode_probed_add+0x44/0x68
[    2.078576]  [<812b8100>] drm_add_modes_noedid+0x68/0x84
[    2.078576]  [<812b8100>] drm_add_modes_noedid+0x68/0x84
[    2.079554]  [<813eaa99>] cirrus_vga_get_modes+0x1b/0x34
[    2.079554]  [<813eaa99>] cirrus_vga_get_modes+0x1b/0x34
[    2.080634]  [<812a0e00>] drm_helper_probe_single_connector_modes+0x125/=
0x310
[    2.080634]  [<812a0e00>] drm_helper_probe_single_connector_modes+0x125/=
0x310
[    2.081962]  [<812a1dec>] drm_fb_helper_probe_connector_modes+0x3a/0x4e
[    2.081962]  [<812a1dec>] drm_fb_helper_probe_connector_modes+0x3a/0x4e
[    2.083189]  [<812a3714>] drm_fb_helper_initial_config+0x174/0x3eb
[    2.083189]  [<812a3714>] drm_fb_helper_initial_config+0x174/0x3eb
[    2.084319]  [<8102fe44>] ? warn_slowpath_common+0x84/0x8c
[    2.084319]  [<8102fe44>] ? warn_slowpath_common+0x84/0x8c
[    2.085344]  [<8129fb2e>] ? drm_helper_crtc_in_use+0x43/0x8b
[    2.085344]  [<8129fb2e>] ? drm_helper_crtc_in_use+0x43/0x8b
[    2.086386]  [<8129fb2e>] ? drm_helper_crtc_in_use+0x43/0x8b
[    2.086386]  [<8129fb2e>] ? drm_helper_crtc_in_use+0x43/0x8b
[    2.087425]  [<8102fef5>] ? warn_slowpath_null+0x22/0x24
[    2.087425]  [<8102fef5>] ? warn_slowpath_null+0x22/0x24
[    2.088400]  [<8129fc31>] ? drm_helper_disable_unused_functions+0xbb/0xd4
[    2.088400]  [<8129fc31>] ? drm_helper_disable_unused_functions+0xbb/0xd4
[    2.089650]  [<813ebdcf>] cirrus_fbdev_init+0x83/0x92
[    2.089650]  [<813ebdcf>] cirrus_fbdev_init+0x83/0x92
[    2.090676]  [<813eb5f4>] cirrus_modeset_init+0x153/0x19c
[    2.090676]  [<813eb5f4>] cirrus_modeset_init+0x153/0x19c
[    2.091676]  [<813ea76b>] cirrus_driver_load+0x93/0xde
[    2.091676]  [<813ea76b>] cirrus_driver_load+0x93/0xde
[    2.092622]  [<812aba1e>] drm_dev_register+0x6e/0xd3
[    2.092622]  [<812aba1e>] drm_dev_register+0x6e/0xd3
[    2.093554]  [<812ad56a>] drm_get_pci_dev+0xdc/0x190
[    2.093554]  [<812ad56a>] drm_get_pci_dev+0xdc/0x190
[    2.094470]  [<813eb6ff>] cirrus_pci_probe+0x87/0x93
[    2.094470]  [<813eb6ff>] cirrus_pci_probe+0x87/0x93
[    2.095386]  [<811ad0d6>] pci_device_probe+0x4c/0x8d
[    2.095386]  [<811ad0d6>] pci_device_probe+0x4c/0x8d
[    2.096297]  [<811161d5>] ? sysfs_create_link+0x2c/0x35
[    2.096297]  [<811161d5>] ? sysfs_create_link+0x2c/0x35
[    2.097278]  [<8149af17>] driver_probe_device+0x99/0x1c1
[    2.097278]  [<8149af17>] driver_probe_device+0x99/0x1c1
[    2.098260]  [<811acf09>] ? pci_match_device+0x9f/0xa5
[    2.098260]  [<811acf09>] ? pci_match_device+0x9f/0xa5
[    2.099204]  [<8149b0c3>] __driver_attach+0x53/0x6f
[    2.099204]  [<8149b0c3>] __driver_attach+0x53/0x6f
[    2.100201]  [<81499b79>] bus_for_each_dev+0x3e/0x69
[    2.100201]  [<81499b79>] bus_for_each_dev+0x3e/0x69
[    2.101103]  [<8149ae35>] driver_attach+0x1c/0x1e
[    2.101103]  [<8149ae35>] driver_attach+0x1c/0x1e
[    2.101985]  [<8149b070>] ? __device_attach+0x31/0x31
[    2.101985]  [<8149b070>] ? __device_attach+0x31/0x31
[    2.102915]  [<8149a230>] bus_add_driver+0xc7/0x1a9
[    2.102915]  [<8149a230>] bus_add_driver+0xc7/0x1a9
[    2.103815]  [<8149b55f>] driver_register+0x96/0xca
[    2.103815]  [<8149b55f>] driver_register+0x96/0xca
[    2.104714]  [<810600f4>] ? __raw_spin_lock_init+0x32/0x53
[    2.104714]  [<810600f4>] ? __raw_spin_lock_init+0x32/0x53
[    2.105738]  [<811acf85>] __pci_register_driver+0x4a/0x4d
[    2.105738]  [<811acf85>] __pci_register_driver+0x4a/0x4d
[    2.106725]  [<812ad67f>] drm_pci_init+0x61/0xd8
[    2.106725]  [<812ad67f>] drm_pci_init+0x61/0xd8
[    2.107572]  [<81c70b2c>] ? tdfx_init+0x14/0x14
[    2.107572]  [<81c70b2c>] ? tdfx_init+0x14/0x14
[    2.108406]  [<81c71f2a>] ? mgag200_init+0x25/0x25
[    2.108406]  [<81c71f2a>] ? mgag200_init+0x25/0x25
[    2.109311]  [<81c71f45>] cirrus_init+0x1b/0x25
[    2.109311]  [<81c71f45>] cirrus_init+0x1b/0x25
[    2.110244]  [<81c46add>] do_one_initcall+0x8b/0x14b
[    2.110244]  [<81c46add>] do_one_initcall+0x8b/0x14b
[    2.111167]  [<8105bc23>] ? lock_release_holdtime+0xc1/0xcd
[    2.111167]  [<8105bc23>] ? lock_release_holdtime+0xc1/0xcd
[    2.112193]  [<81047ae2>] ? parameqn+0xc/0x41
[    2.112193]  [<81047ae2>] ? parameqn+0xc/0x41
[    2.112996]  [<81c46452>] ? repair_env_string+0x12/0x51
[    2.112996]  [<81c46452>] ? repair_env_string+0x12/0x51
[    2.113985]  [<81047caa>] ? parse_args+0x16e/0x231
[    2.113985]  [<81047caa>] ? parse_args+0x16e/0x231
[    2.114876]  [<81c46c6c>] kernel_init_freeable+0xcf/0x16e
[    2.114876]  [<81c46c6c>] kernel_init_freeable+0xcf/0x16e
[    2.115874]  [<81c46440>] ? do_early_param+0x7a/0x7a
[    2.115874]  [<81c46440>] ? do_early_param+0x7a/0x7a
[    2.116792]  [<816b3ed4>] kernel_init+0x10/0xcb
[    2.116792]  [<816b3ed4>] kernel_init+0x10/0xcb
[    2.117644]  [<8105280b>] ? schedule_tail+0x17/0x3e
[    2.117644]  [<8105280b>] ? schedule_tail+0x17/0x3e
[    2.118544]  [<816c2e37>] ret_from_kernel_thread+0x1b/0x28
[    2.118544]  [<816c2e37>] ret_from_kernel_thread+0x1b/0x28
[    2.119553]  [<816b3ec4>] ? rest_init+0xbc/0xbc
[    2.119553]  [<816b3ec4>] ? rest_init+0xbc/0xbc
[    2.120479] ---[ end trace a205f4c9292ec4a5 ]---
[    2.120479] ---[ end trace a205f4c9292ec4a5 ]---
[    2.121355] ------------[ cut here ]------------
[    2.121355] ------------[ cut here ]------------
[    2.122201] WARNING: CPU: 0 PID: 1 at drivers/gpu/drm/drm_modes.c:119 dr=
m_mode_probed_add+0x44/0x68()
[    2.122201] WARNING: CPU: 0 PID: 1 at drivers/gpu/drm/drm_modes.c:119 dr=
m_mode_probed_add+0x44/0x68()
[    2.124241] CPU: 0 PID: 1 Comm: swapper Tainted: G        W    3.14.0-rc=
7-wl-ath-04519-g2d18516 #9
[    2.124241] CPU: 0 PID: 1 Comm: swapper Tainted: G        W    3.14.0-rc=
7-wl-ath-04519-g2d18516 #9
[    2.125888] Hardware name: Bochs Bochs, BIOS Bochs 01/01/2011
[    2.125888] Hardware name: Bochs Bochs, BIOS Bochs 01/01/2011
[    2.126935]  00000000
[    2.126935]  00000000 00000000 00000000 80033bd8 80033bd8 816b7fd7 816b7=
fd7 80033c08 80033c08 8102fe35 8102fe35 81935ad6 81935ad6 00000000 00000000

[    2.128466]  00000001
[    2.128466]  00000001 819720ae 819720ae 00000077 00000077 812b4656 812b4=
656 812b4656 812b4656 929b8180 929b8180 92402800 92402800 00000001 00000001

[    2.130125]  80033c18
[    2.130125]  80033c18 8102fef5 8102fef5 00000009 00000009 00000000 00000=
000 80033c30 80033c30 812b4656 812b4656 01000000 01000000 81786a58 81786a58

[    2.131663] Call Trace:
[    2.131663] Call Trace:
[    2.132124]  [<816b7fd7>] dump_stack+0x16/0x18
[    2.132124]  [<816b7fd7>] dump_stack+0x16/0x18
[    2.132940]  [<8102fe35>] warn_slowpath_common+0x75/0x8c
[    2.132940]  [<8102fe35>] warn_slowpath_common+0x75/0x8c
[    2.133935]  [<812b4656>] ? drm_mode_probed_add+0x44/0x68
[    2.133935]  [<812b4656>] ? drm_mode_probed_add+0x44/0x68
[    2.134933]  [<812b4656>] ? drm_mode_probed_add+0x44/0x68
[    2.134933]  [<812b4656>] ? drm_mode_probed_add+0x44/0x68
[    2.135932]  [<8102fef5>] warn_slowpath_null+0x22/0x24
[    2.135932]  [<8102fef5>] warn_slowpath_null+0x22/0x24
[    2.136879]  [<812b4656>] drm_mode_probed_add+0x44/0x68
[    2.136879]  [<812b4656>] drm_mode_probed_add+0x44/0x68
[    2.137857]  [<812b8100>] drm_add_modes_noedid+0x68/0x84
[    2.137857]  [<812b8100>] drm_add_modes_noedid+0x68/0x84
[    2.138834]  [<813eaa99>] cirrus_vga_get_modes+0x1b/0x34
[    2.138834]  [<813eaa99>] cirrus_vga_get_modes+0x1b/0x34
[    2.139813]  [<812a0e00>] drm_helper_probe_single_connector_modes+0x125/=
0x310
[    2.139813]  [<812a0e00>] drm_helper_probe_single_connector_modes+0x125/=
0x310
[    2.141214]  [<812a1dec>] drm_fb_helper_probe_connector_modes+0x3a/0x4e
[    2.141214]  [<812a1dec>] drm_fb_helper_probe_connector_modes+0x3a/0x4e
[    2.142453]  [<812a3714>] drm_fb_helper_initial_config+0x174/0x3eb
[    2.142453]  [<812a3714>] drm_fb_helper_initial_config+0x174/0x3eb
[    2.143601]  [<8102fe44>] ? warn_slowpath_common+0x84/0x8c
[    2.143601]  [<8102fe44>] ? warn_slowpath_common+0x84/0x8c
[    2.144610]  [<8129fb2e>] ? drm_helper_crtc_in_use+0x43/0x8b
[    2.144610]  [<8129fb2e>] ? drm_helper_crtc_in_use+0x43/0x8b
[    2.145666]  [<8129fb2e>] ? drm_helper_crtc_in_use+0x43/0x8b
[    2.145666]  [<8129fb2e>] ? drm_helper_crtc_in_use+0x43/0x8b
[    2.146705]  [<8102fef5>] ? warn_slowpath_null+0x22/0x24
[    2.146705]  [<8102fef5>] ? warn_slowpath_null+0x22/0x24
[    2.147679]  [<8129fc31>] ? drm_helper_disable_unused_functions+0xbb/0xd4
[    2.147679]  [<8129fc31>] ? drm_helper_disable_unused_functions+0xbb/0xd4
[    2.148924]  [<813ebdcf>] cirrus_fbdev_init+0x83/0x92
[    2.148924]  [<813ebdcf>] cirrus_fbdev_init+0x83/0x92
[    2.149873]  [<813eb5f4>] cirrus_modeset_init+0x153/0x19c
[    2.149873]  [<813eb5f4>] cirrus_modeset_init+0x153/0x19c
[    2.150961]  [<813ea76b>] cirrus_driver_load+0x93/0xde
[    2.150961]  [<813ea76b>] cirrus_driver_load+0x93/0xde
[    2.151914]  [<812aba1e>] drm_dev_register+0x6e/0xd3
[    2.151914]  [<812aba1e>] drm_dev_register+0x6e/0xd3
[    2.152836]  [<812ad56a>] drm_get_pci_dev+0xdc/0x190
[    2.152836]  [<812ad56a>] drm_get_pci_dev+0xdc/0x190
[    2.153777]  [<813eb6ff>] cirrus_pci_probe+0x87/0x93
[    2.153777]  [<813eb6ff>] cirrus_pci_probe+0x87/0x93
[    2.154686]  [<811ad0d6>] pci_device_probe+0x4c/0x8d
[    2.154686]  [<811ad0d6>] pci_device_probe+0x4c/0x8d
[    2.155607]  [<811161d5>] ? sysfs_create_link+0x2c/0x35
[    2.155607]  [<811161d5>] ? sysfs_create_link+0x2c/0x35
[    2.156568]  [<8149af17>] driver_probe_device+0x99/0x1c1
[    2.156568]  [<8149af17>] driver_probe_device+0x99/0x1c1
[    2.157571]  [<811acf09>] ? pci_match_device+0x9f/0xa5
[    2.157571]  [<811acf09>] ? pci_match_device+0x9f/0xa5
[    2.158523]  [<8149b0c3>] __driver_attach+0x53/0x6f
[    2.158523]  [<8149b0c3>] __driver_attach+0x53/0x6f
[    2.159426]  [<81499b79>] bus_for_each_dev+0x3e/0x69
[    2.159426]  [<81499b79>] bus_for_each_dev+0x3e/0x69
[    2.160425]  [<8149ae35>] driver_attach+0x1c/0x1e
[    2.160425]  [<8149ae35>] driver_attach+0x1c/0x1e
[    2.161323]  [<8149b070>] ? __device_attach+0x31/0x31
[    2.161323]  [<8149b070>] ? __device_attach+0x31/0x31
[    2.162257]  [<8149a230>] bus_add_driver+0xc7/0x1a9
[    2.162257]  [<8149a230>] bus_add_driver+0xc7/0x1a9
[    2.163154]  [<8149b55f>] driver_register+0x96/0xca
[    2.163154]  [<8149b55f>] driver_register+0x96/0xca
[    2.164046]  [<810600f4>] ? __raw_spin_lock_init+0x32/0x53
[    2.164046]  [<810600f4>] ? __raw_spin_lock_init+0x32/0x53
[    2.165056]  [<811acf85>] __pci_register_driver+0x4a/0x4d
[    2.165056]  [<811acf85>] __pci_register_driver+0x4a/0x4d
[    2.166064]  [<812ad67f>] drm_pci_init+0x61/0xd8
[    2.166064]  [<812ad67f>] drm_pci_init+0x61/0xd8
[    2.166917]  [<81c70b2c>] ? tdfx_init+0x14/0x14
[    2.166917]  [<81c70b2c>] ? tdfx_init+0x14/0x14
[    2.167751]  [<81c71f2a>] ? mgag200_init+0x25/0x25
[    2.167751]  [<81c71f2a>] ? mgag200_init+0x25/0x25
[    2.168631]  [<81c71f45>] cirrus_init+0x1b/0x25
[    2.168631]  [<81c71f45>] cirrus_init+0x1b/0x25
[    2.169480]  [<81c46add>] do_one_initcall+0x8b/0x14b
[    2.169480]  [<81c46add>] do_one_initcall+0x8b/0x14b
[    2.170480]  [<8105bc23>] ? lock_release_holdtime+0xc1/0xcd
[    2.170480]  [<8105bc23>] ? lock_release_holdtime+0xc1/0xcd
[    2.171513]  [<81047ae2>] ? parameqn+0xc/0x41
[    2.171513]  [<81047ae2>] ? parameqn+0xc/0x41
[    2.172325]  [<81c46452>] ? repair_env_string+0x12/0x51
[    2.172325]  [<81c46452>] ? repair_env_string+0x12/0x51
[    2.173314]  [<81047caa>] ? parse_args+0x16e/0x231
[    2.173314]  [<81047caa>] ? parse_args+0x16e/0x231
[    2.174205]  [<81c46c6c>] kernel_init_freeable+0xcf/0x16e
[    2.174205]  [<81c46c6c>] kernel_init_freeable+0xcf/0x16e
[    2.175202]  [<81c46440>] ? do_early_param+0x7a/0x7a
[    2.175202]  [<81c46440>] ? do_early_param+0x7a/0x7a
[    2.176124]  [<816b3ed4>] kernel_init+0x10/0xcb
[    2.176124]  [<816b3ed4>] kernel_init+0x10/0xcb
[    2.176963]  [<8105280b>] ? schedule_tail+0x17/0x3e
[    2.176963]  [<8105280b>] ? schedule_tail+0x17/0x3e
[    2.177878]  [<816c2e37>] ret_from_kernel_thread+0x1b/0x28
[    2.177878]  [<816c2e37>] ret_from_kernel_thread+0x1b/0x28
[    2.178883]  [<816b3ec4>] ? rest_init+0xbc/0xbc
[    2.178883]  [<816b3ec4>] ? rest_init+0xbc/0xbc
[    2.179722] ---[ end trace a205f4c9292ec4a6 ]---
[    2.179722] ---[ end trace a205f4c9292ec4a6 ]---
[    2.180673] ------------[ cut here ]------------
[    2.180673] ------------[ cut here ]------------
[    2.181552] WARNING: CPU: 0 PID: 1 at drivers/gpu/drm/drm_modes.c:119 dr=
m_mode_probed_add+0x44/0x68()
[    2.181552] WARNING: CPU: 0 PID: 1 at drivers/gpu/drm/drm_modes.c:119 dr=
m_mode_probed_add+0x44/0x68()
[    2.183632] CPU: 0 PID: 1 Comm: swapper Tainted: G        W    3.14.0-rc=
7-wl-ath-04519-g2d18516 #9
[    2.183632] CPU: 0 PID: 1 Comm: swapper Tainted: G        W    3.14.0-rc=
7-wl-ath-04519-g2d18516 #9
[    2.185292] Hardware name: Bochs Bochs, BIOS Bochs 01/01/2011
[    2.185292] Hardware name: Bochs Bochs, BIOS Bochs 01/01/2011
[    2.186345]  00000000
[    2.186345]  00000000 00000000 00000000 80033bd8 80033bd8 816b7fd7 816b7=
fd7 80033c08 80033c08 8102fe35 8102fe35 81935ad6 81935ad6 00000000 00000000

[    2.187875]  00000001
[    2.187875]  00000001 819720ae 819720ae 00000077 00000077 812b4656 812b4=
656 812b4656 812b4656 929b8080 929b8080 92402800 92402800 00000001 00000001

[    2.189431]  80033c18
[    2.189431]  80033c18 8102fef5 8102fef5 00000009 00000009 00000000 00000=
000 80033c30 80033c30 812b4656 812b4656 01000000 01000000 81786ed8 81786ed8

[    2.191058] Call Trace:
[    2.191058] Call Trace:
[    2.191524]  [<816b7fd7>] dump_stack+0x16/0x18
[    2.191524]  [<816b7fd7>] dump_stack+0x16/0x18
[    2.192351]  [<8102fe35>] warn_slowpath_common+0x75/0x8c
[    2.192351]  [<8102fe35>] warn_slowpath_common+0x75/0x8c
[    2.193352]  [<812b4656>] ? drm_mode_probed_add+0x44/0x68
[    2.193352]  [<812b4656>] ? drm_mode_probed_add+0x44/0x68
[    2.194343]  [<812b4656>] ? drm_mode_probed_add+0x44/0x68
[    2.194343]  [<812b4656>] ? drm_mode_probed_add+0x44/0x68
[    2.195339]  [<8102fef5>] warn_slowpath_null+0x22/0x24
[    2.195339]  [<8102fef5>] warn_slowpath_null+0x22/0x24
[    2.196286]  [<812b4656>] drm_mode_probed_add+0x44/0x68
[    2.196286]  [<812b4656>] drm_mode_probed_add+0x44/0x68
[    2.197264]  [<812b8100>] drm_add_modes_noedid+0x68/0x84
[    2.197264]  [<812b8100>] drm_add_modes_noedid+0x68/0x84
[    2.198246]  [<813eaa99>] cirrus_vga_get_modes+0x1b/0x34
[    2.198246]  [<813eaa99>] cirrus_vga_get_modes+0x1b/0x34
[    2.199226]  [<812a0e00>] drm_helper_probe_single_connector_modes+0x125/=
0x310
[    2.199226]  [<812a0e00>] drm_helper_probe_single_connector_modes+0x125/=
0x310
[    2.200627]  [<812a1dec>] drm_fb_helper_probe_connector_modes+0x3a/0x4e
[    2.200627]  [<812a1dec>] drm_fb_helper_probe_connector_modes+0x3a/0x4e
[    2.201858]  [<812a3714>] drm_fb_helper_initial_config+0x174/0x3eb
[    2.201858]  [<812a3714>] drm_fb_helper_initial_config+0x174/0x3eb
[    2.202990]  [<8102fe44>] ? warn_slowpath_common+0x84/0x8c
[    2.202990]  [<8102fe44>] ? warn_slowpath_common+0x84/0x8c
[    2.203996]  [<8129fb2e>] ? drm_helper_crtc_in_use+0x43/0x8b
[    2.203996]  [<8129fb2e>] ? drm_helper_crtc_in_use+0x43/0x8b
[    2.205039]  [<8129fb2e>] ? drm_helper_crtc_in_use+0x43/0x8b
[    2.205039]  [<8129fb2e>] ? drm_helper_crtc_in_use+0x43/0x8b
[    2.206097]  [<8102fef5>] ? warn_slowpath_null+0x22/0x24
[    2.206097]  [<8102fef5>] ? warn_slowpath_null+0x22/0x24
[    2.207080]  [<8129fc31>] ? drm_helper_disable_unused_functions+0xbb/0xd4
[    2.207080]  [<8129fc31>] ? drm_helper_disable_unused_functions+0xbb/0xd4
[    2.208332]  [<813ebdcf>] cirrus_fbdev_init+0x83/0x92
[    2.208332]  [<813ebdcf>] cirrus_fbdev_init+0x83/0x92
[    2.209288]  [<813eb5f4>] cirrus_modeset_init+0x153/0x19c
[    2.209288]  [<813eb5f4>] cirrus_modeset_init+0x153/0x19c
[    2.210376]  [<813ea76b>] cirrus_driver_load+0x93/0xde
[    2.210376]  [<813ea76b>] cirrus_driver_load+0x93/0xde
[    2.211335]  [<812aba1e>] drm_dev_register+0x6e/0xd3
[    2.211335]  [<812aba1e>] drm_dev_register+0x6e/0xd3
[    2.212254]  [<812ad56a>] drm_get_pci_dev+0xdc/0x190
[    2.212254]  [<812ad56a>] drm_get_pci_dev+0xdc/0x190
[    2.213211]  [<813eb6ff>] cirrus_pci_probe+0x87/0x93
[    2.213211]  [<813eb6ff>] cirrus_pci_probe+0x87/0x93
[    2.214126]  [<811ad0d6>] pci_device_probe+0x4c/0x8d
[    2.214126]  [<811ad0d6>] pci_device_probe+0x4c/0x8d
[    2.215041]  [<811161d5>] ? sysfs_create_link+0x2c/0x35
[    2.215041]  [<811161d5>] ? sysfs_create_link+0x2c/0x35
[    2.216008]  [<8149af17>] driver_probe_device+0x99/0x1c1
[    2.216008]  [<8149af17>] driver_probe_device+0x99/0x1c1
[    2.216989]  [<811acf09>] ? pci_match_device+0x9f/0xa5
[    2.216989]  [<811acf09>] ? pci_match_device+0x9f/0xa5
[    2.217950]  [<8149b0c3>] __driver_attach+0x53/0x6f
[    2.217950]  [<8149b0c3>] __driver_attach+0x53/0x6f
[    2.218854]  [<81499b79>] bus_for_each_dev+0x3e/0x69
[    2.218854]  [<81499b79>] bus_for_each_dev+0x3e/0x69
[    2.219770]  [<8149ae35>] driver_attach+0x1c/0x1e
[    2.219770]  [<8149ae35>] driver_attach+0x1c/0x1e
[    2.220734]  [<8149b070>] ? __device_attach+0x31/0x31
[    2.220734]  [<8149b070>] ? __device_attach+0x31/0x31
[    2.221688]  [<8149a230>] bus_add_driver+0xc7/0x1a9
[    2.221688]  [<8149a230>] bus_add_driver+0xc7/0x1a9
[    2.222584]  [<8149b55f>] driver_register+0x96/0xca
[    2.222584]  [<8149b55f>] driver_register+0x96/0xca
[    2.223477]  [<810600f4>] ? __raw_spin_lock_init+0x32/0x53
[    2.223477]  [<810600f4>] ? __raw_spin_lock_init+0x32/0x53
[    2.224483]  [<811acf85>] __pci_register_driver+0x4a/0x4d
[    2.224483]  [<811acf85>] __pci_register_driver+0x4a/0x4d
[    2.225488]  [<812ad67f>] drm_pci_init+0x61/0xd8
[    2.225488]  [<812ad67f>] drm_pci_init+0x61/0xd8
[    2.226347]  [<81c70b2c>] ? tdfx_init+0x14/0x14
[    2.226347]  [<81c70b2c>] ? tdfx_init+0x14/0x14
[    2.227185]  [<81c71f2a>] ? mgag200_init+0x25/0x25
[    2.227185]  [<81c71f2a>] ? mgag200_init+0x25/0x25
[    2.228062]  [<81c71f45>] cirrus_init+0x1b/0x25
[    2.228062]  [<81c71f45>] cirrus_init+0x1b/0x25
[    2.228897]  [<81c46add>] do_one_initcall+0x8b/0x14b
[    2.228897]  [<81c46add>] do_one_initcall+0x8b/0x14b
[    2.229825]  [<8105bc23>] ? lock_release_holdtime+0xc1/0xcd
[    2.229825]  [<8105bc23>] ? lock_release_holdtime+0xc1/0xcd
[    2.230928]  [<81047ae2>] ? parameqn+0xc/0x41
[    2.230928]  [<81047ae2>] ? parameqn+0xc/0x41
[    2.231737]  [<81c46452>] ? repair_env_string+0x12/0x51
[    2.231737]  [<81c46452>] ? repair_env_string+0x12/0x51
[    2.232706]  [<81047caa>] ? parse_args+0x16e/0x231
[    2.232706]  [<81047caa>] ? parse_args+0x16e/0x231
[    2.233607]  [<81c46c6c>] kernel_init_freeable+0xcf/0x16e
[    2.233607]  [<81c46c6c>] kernel_init_freeable+0xcf/0x16e
[    2.234597]  [<81c46440>] ? do_early_param+0x7a/0x7a
[    2.234597]  [<81c46440>] ? do_early_param+0x7a/0x7a
[    2.235507]  [<816b3ed4>] kernel_init+0x10/0xcb
[    2.235507]  [<816b3ed4>] kernel_init+0x10/0xcb
[    2.236341]  [<8105280b>] ? schedule_tail+0x17/0x3e
[    2.236341]  [<8105280b>] ? schedule_tail+0x17/0x3e
[    2.237262]  [<816c2e37>] ret_from_kernel_thread+0x1b/0x28
[    2.237262]  [<816c2e37>] ret_from_kernel_thread+0x1b/0x28
[    2.238266]  [<816b3ec4>] ? rest_init+0xbc/0xbc
[    2.238266]  [<816b3ec4>] ? rest_init+0xbc/0xbc
[    2.239093] ---[ end trace a205f4c9292ec4a7 ]---
[    2.239093] ---[ end trace a205f4c9292ec4a7 ]---
[    2.239964] ------------[ cut here ]------------
[    2.239964] ------------[ cut here ]------------
[    2.240898] WARNING: CPU: 0 PID: 1 at drivers/gpu/drm/drm_modes.c:119 dr=
m_mode_probed_add+0x44/0x68()
[    2.240898] WARNING: CPU: 0 PID: 1 at drivers/gpu/drm/drm_modes.c:119 dr=
m_mode_probed_add+0x44/0x68()
[    2.242982] CPU: 0 PID: 1 Comm: swapper Tainted: G        W    3.14.0-rc=
7-wl-ath-04519-g2d18516 #9
[    2.242982] CPU: 0 PID: 1 Comm: swapper Tainted: G        W    3.14.0-rc=
7-wl-ath-04519-g2d18516 #9
[    2.244609] Hardware name: Bochs Bochs, BIOS Bochs 01/01/2011
[    2.244609] Hardware name: Bochs Bochs, BIOS Bochs 01/01/2011
[    2.245674]  00000000
[    2.245674]  00000000 00000000 00000000 80033bd8 80033bd8 816b7fd7 816b7=
fd7 80033c08 80033c08 8102fe35 8102fe35 81935ad6 81935ad6 00000000 00000000

[    2.247210]  00000001
[    2.247210]  00000001 819720ae 819720ae 00000077 00000077 812b4656 812b4=
656 812b4656 812b4656 92410e80 92410e80 92402800 92402800 00000001 00000001

[    2.248732]  80033c18
[    2.248732]  80033c18 8102fef5 8102fef5 00000009 00000009 00000000 00000=
000 80033c30 80033c30 812b4656 812b4656 01000000 01000000 81786f98 81786f98

[    2.250387] Call Trace:
[    2.250387] Call Trace:
[    2.250845]  [<816b7fd7>] dump_stack+0x16/0x18
[    2.250845]  [<816b7fd7>] dump_stack+0x16/0x18
[    2.251669]  [<8102fe35>] warn_slowpath_common+0x75/0x8c
[    2.251669]  [<8102fe35>] warn_slowpath_common+0x75/0x8c
[    2.252648]  [<812b4656>] ? drm_mode_probed_add+0x44/0x68
[    2.252648]  [<812b4656>] ? drm_mode_probed_add+0x44/0x68
[    2.253664]  [<812b4656>] ? drm_mode_probed_add+0x44/0x68
[    2.253664]  [<812b4656>] ? drm_mode_probed_add+0x44/0x68
[    2.254657]  [<8102fef5>] warn_slowpath_null+0x22/0x24
[    2.254657]  [<8102fef5>] warn_slowpath_null+0x22/0x24
[    2.255599]  [<812b4656>] drm_mode_probed_add+0x44/0x68
[    2.255599]  [<812b4656>] drm_mode_probed_add+0x44/0x68
[    2.256557]  [<812b8100>] drm_add_modes_noedid+0x68/0x84
[    2.256557]  [<812b8100>] drm_add_modes_noedid+0x68/0x84
[    2.257551]  [<813eaa99>] cirrus_vga_get_modes+0x1b/0x34
[    2.257551]  [<813eaa99>] cirrus_vga_get_modes+0x1b/0x34
[    2.258524]  [<812a0e00>] drm_helper_probe_single_connector_modes+0x125/=
0x310
[    2.258524]  [<812a0e00>] drm_helper_probe_single_connector_modes+0x125/=
0x310
[    2.259824]  [<812a1dec>] drm_fb_helper_probe_connector_modes+0x3a/0x4e
[    2.259824]  [<812a1dec>] drm_fb_helper_probe_connector_modes+0x3a/0x4e
[    2.261130]  [<812a3714>] drm_fb_helper_initial_config+0x174/0x3eb
[    2.261130]  [<812a3714>] drm_fb_helper_initial_config+0x174/0x3eb
[    2.262291]  [<8102fe44>] ? warn_slowpath_common+0x84/0x8c
[    2.262291]  [<8102fe44>] ? warn_slowpath_common+0x84/0x8c
[    2.263297]  [<8129fb2e>] ? drm_helper_crtc_in_use+0x43/0x8b
[    2.263297]  [<8129fb2e>] ? drm_helper_crtc_in_use+0x43/0x8b
[    2.264337]  [<8129fb2e>] ? drm_helper_crtc_in_use+0x43/0x8b
[    2.264337]  [<8129fb2e>] ? drm_helper_crtc_in_use+0x43/0x8b
[    2.265392]  [<8102fef5>] ? warn_slowpath_null+0x22/0x24
[    2.265392]  [<8102fef5>] ? warn_slowpath_null+0x22/0x24
[    2.266367]  [<8129fc31>] ? drm_helper_disable_unused_functions+0xbb/0xd4
[    2.266367]  [<8129fc31>] ? drm_helper_disable_unused_functions+0xbb/0xd4
[    2.267606]  [<813ebdcf>] cirrus_fbdev_init+0x83/0x92
[    2.267606]  [<813ebdcf>] cirrus_fbdev_init+0x83/0x92
[    2.268536]  [<813eb5f4>] cirrus_modeset_init+0x153/0x19c
[    2.268536]  [<813eb5f4>] cirrus_modeset_init+0x153/0x19c
[    2.269556]  [<813ea76b>] cirrus_driver_load+0x93/0xde
[    2.269556]  [<813ea76b>] cirrus_driver_load+0x93/0xde
[    2.270596]  [<812aba1e>] drm_dev_register+0x6e/0xd3
[    2.270596]  [<812aba1e>] drm_dev_register+0x6e/0xd3
[    2.271529]  [<812ad56a>] drm_get_pci_dev+0xdc/0x190
[    2.271529]  [<812ad56a>] drm_get_pci_dev+0xdc/0x190
[    2.272452]  [<813eb6ff>] cirrus_pci_probe+0x87/0x93
[    2.272452]  [<813eb6ff>] cirrus_pci_probe+0x87/0x93
[    2.273393]  [<811ad0d6>] pci_device_probe+0x4c/0x8d
[    2.273393]  [<811ad0d6>] pci_device_probe+0x4c/0x8d
[    2.274314]  [<811161d5>] ? sysfs_create_link+0x2c/0x35
[    2.274314]  [<811161d5>] ? sysfs_create_link+0x2c/0x35
[    2.275273]  [<8149af17>] driver_probe_device+0x99/0x1c1
[    2.275273]  [<8149af17>] driver_probe_device+0x99/0x1c1
[    2.276249]  [<811acf09>] ? pci_match_device+0x9f/0xa5
[    2.276249]  [<811acf09>] ? pci_match_device+0x9f/0xa5
[    2.277212]  [<8149b0c3>] __driver_attach+0x53/0x6f
[    2.277212]  [<8149b0c3>] __driver_attach+0x53/0x6f
[    2.278108]  [<81499b79>] bus_for_each_dev+0x3e/0x69
[    2.278108]  [<81499b79>] bus_for_each_dev+0x3e/0x69
[    2.279019]  [<8149ae35>] driver_attach+0x1c/0x1e
[    2.279019]  [<8149ae35>] driver_attach+0x1c/0x1e
[    2.279890]  [<8149b070>] ? __device_attach+0x31/0x31
[    2.279890]  [<8149b070>] ? __device_attach+0x31/0x31
[    2.280904]  [<8149a230>] bus_add_driver+0xc7/0x1a9
[    2.280904]  [<8149a230>] bus_add_driver+0xc7/0x1a9
[    2.281829]  [<8149b55f>] driver_register+0x96/0xca
[    2.281829]  [<8149b55f>] driver_register+0x96/0xca
[    2.282728]  [<810600f4>] ? __raw_spin_lock_init+0x32/0x53
[    2.282728]  [<810600f4>] ? __raw_spin_lock_init+0x32/0x53
[    2.283734]  [<811acf85>] __pci_register_driver+0x4a/0x4d
[    2.283734]  [<811acf85>] __pci_register_driver+0x4a/0x4d
[    2.284729]  [<812ad67f>] drm_pci_init+0x61/0xd8
[    2.284729]  [<812ad67f>] drm_pci_init+0x61/0xd8
[    2.285602]  [<81c70b2c>] ? tdfx_init+0x14/0x14
[    2.285602]  [<81c70b2c>] ? tdfx_init+0x14/0x14
[    2.286445]  [<81c71f2a>] ? mgag200_init+0x25/0x25
[    2.286445]  [<81c71f2a>] ? mgag200_init+0x25/0x25
[    2.287334]  [<81c71f45>] cirrus_init+0x1b/0x25
[    2.287334]  [<81c71f45>] cirrus_init+0x1b/0x25
[    2.288171]  [<81c46add>] do_one_initcall+0x8b/0x14b
[    2.288171]  [<81c46add>] do_one_initcall+0x8b/0x14b
[    2.289082]  [<8105bc23>] ? lock_release_holdtime+0xc1/0xcd
[    2.289082]  [<8105bc23>] ? lock_release_holdtime+0xc1/0xcd
[    2.290229]  [<81047ae2>] ? parameqn+0xc/0x41
[    2.290229]  [<81047ae2>] ? parameqn+0xc/0x41
[    2.291035]  [<81c46452>] ? repair_env_string+0x12/0x51
[    2.291035]  [<81c46452>] ? repair_env_string+0x12/0x51
[    2.292002]  [<81047caa>] ? parse_args+0x16e/0x231
[    2.292002]  [<81047caa>] ? parse_args+0x16e/0x231
[    2.292887]  [<81c46c6c>] kernel_init_freeable+0xcf/0x16e
[    2.292887]  [<81c46c6c>] kernel_init_freeable+0xcf/0x16e
[    2.293893]  [<81c46440>] ? do_early_param+0x7a/0x7a
[    2.293893]  [<81c46440>] ? do_early_param+0x7a/0x7a
[    2.294806]  [<816b3ed4>] kernel_init+0x10/0xcb
[    2.294806]  [<816b3ed4>] kernel_init+0x10/0xcb
[    2.295641]  [<8105280b>] ? schedule_tail+0x17/0x3e
[    2.295641]  [<8105280b>] ? schedule_tail+0x17/0x3e
[    2.296540]  [<816c2e37>] ret_from_kernel_thread+0x1b/0x28
[    2.296540]  [<816c2e37>] ret_from_kernel_thread+0x1b/0x28
[    2.297570]  [<816b3ec4>] ? rest_init+0xbc/0xbc
[    2.297570]  [<816b3ec4>] ? rest_init+0xbc/0xbc
[    2.298408] ---[ end trace a205f4c9292ec4a8 ]---
[    2.298408] ---[ end trace a205f4c9292ec4a8 ]---
[    2.299272] ------------[ cut here ]------------
[    2.299272] ------------[ cut here ]------------
[    2.300211] WARNING: CPU: 0 PID: 1 at drivers/gpu/drm/drm_modes.c:119 dr=
m_mode_probed_add+0x44/0x68()
[    2.300211] WARNING: CPU: 0 PID: 1 at drivers/gpu/drm/drm_modes.c:119 dr=
m_mode_probed_add+0x44/0x68()
[    2.302304] CPU: 0 PID: 1 Comm: swapper Tainted: G        W    3.14.0-rc=
7-wl-ath-04519-g2d18516 #9
[    2.302304] CPU: 0 PID: 1 Comm: swapper Tainted: G        W    3.14.0-rc=
7-wl-ath-04519-g2d18516 #9
[    2.303933] Hardware name: Bochs Bochs, BIOS Bochs 01/01/2011
[    2.303933] Hardware name: Bochs Bochs, BIOS Bochs 01/01/2011
[    2.304981]  00000000
[    2.304981]  00000000 00000000 00000000 80033bd8 80033bd8 816b7fd7 816b7=
fd7 80033c08 80033c08 8102fe35 8102fe35 81935ad6 81935ad6 00000000 00000000

[    2.306528]  00000001
[    2.306528]  00000001 819720ae 819720ae 00000077 00000077 812b4656 812b4=
656 812b4656 812b4656 92410d80 92410d80 92402800 92402800 00000001 00000001

[    2.308052]  80033c18
[    2.308052]  80033c18 8102fef5 8102fef5 00000009 00000009 00000000 00000=
000 80033c30 80033c30 812b4656 812b4656 01000000 01000000 81787298 81787298

[    2.309646] Call Trace:
[    2.309646] Call Trace:
[    2.310213]  [<816b7fd7>] dump_stack+0x16/0x18
[    2.310213]  [<816b7fd7>] dump_stack+0x16/0x18
[    2.311030]  [<8102fe35>] warn_slowpath_common+0x75/0x8c
[    2.311030]  [<8102fe35>] warn_slowpath_common+0x75/0x8c
[    2.312004]  [<812b4656>] ? drm_mode_probed_add+0x44/0x68
[    2.312004]  [<812b4656>] ? drm_mode_probed_add+0x44/0x68
[    2.312994]  [<812b4656>] ? drm_mode_probed_add+0x44/0x68
[    2.312994]  [<812b4656>] ? drm_mode_probed_add+0x44/0x68
[    2.314009]  [<8102fef5>] warn_slowpath_null+0x22/0x24
[    2.314009]  [<8102fef5>] warn_slowpath_null+0x22/0x24
[    2.314959]  [<812b4656>] drm_mode_probed_add+0x44/0x68
[    2.314959]  [<812b4656>] drm_mode_probed_add+0x44/0x68
[    2.315920]  [<812b8100>] drm_add_modes_noedid+0x68/0x84
[    2.315920]  [<812b8100>] drm_add_modes_noedid+0x68/0x84
[    2.316904]  [<813eaa99>] cirrus_vga_get_modes+0x1b/0x34
[    2.316904]  [<813eaa99>] cirrus_vga_get_modes+0x1b/0x34
[    2.317897]  [<812a0e00>] drm_helper_probe_single_connector_modes+0x125/=
0x310
[    2.317897]  [<812a0e00>] drm_helper_probe_single_connector_modes+0x125/=
0x310
[    2.319211]  [<812a1dec>] drm_fb_helper_probe_connector_modes+0x3a/0x4e
[    2.319211]  [<812a1dec>] drm_fb_helper_probe_connector_modes+0x3a/0x4e
[    2.320505]  [<812a3714>] drm_fb_helper_initial_config+0x174/0x3eb
[    2.320505]  [<812a3714>] drm_fb_helper_initial_config+0x174/0x3eb
[    2.321670]  [<8102fe44>] ? warn_slowpath_common+0x84/0x8c
[    2.321670]  [<8102fe44>] ? warn_slowpath_common+0x84/0x8c
[    2.322682]  [<8129fb2e>] ? drm_helper_crtc_in_use+0x43/0x8b
[    2.322682]  [<8129fb2e>] ? drm_helper_crtc_in_use+0x43/0x8b
[    2.323721]  [<8129fb2e>] ? drm_helper_crtc_in_use+0x43/0x8b
[    2.323721]  [<8129fb2e>] ? drm_helper_crtc_in_use+0x43/0x8b
[    2.324761]  [<8102fef5>] ? warn_slowpath_null+0x22/0x24
[    2.324761]  [<8102fef5>] ? warn_slowpath_null+0x22/0x24
[    2.325756]  [<8129fc31>] ? drm_helper_disable_unused_functions+0xbb/0xd4
[    2.325756]  [<8129fc31>] ? drm_helper_disable_unused_functions+0xbb/0xd4
[    2.327001]  [<813ebdcf>] cirrus_fbdev_init+0x83/0x92
[    2.327001]  [<813ebdcf>] cirrus_fbdev_init+0x83/0x92
[    2.327929]  [<813eb5f4>] cirrus_modeset_init+0x153/0x19c
[    2.327929]  [<813eb5f4>] cirrus_modeset_init+0x153/0x19c
[    2.328926]  [<813ea76b>] cirrus_driver_load+0x93/0xde
[    2.328926]  [<813ea76b>] cirrus_driver_load+0x93/0xde
[    2.329898]  [<812aba1e>] drm_dev_register+0x6e/0xd3
[    2.329898]  [<812aba1e>] drm_dev_register+0x6e/0xd3
[    2.330885]  [<812ad56a>] drm_get_pci_dev+0xdc/0x190
[    2.330885]  [<812ad56a>] drm_get_pci_dev+0xdc/0x190
[    2.331816]  [<813eb6ff>] cirrus_pci_probe+0x87/0x93
[    2.331816]  [<813eb6ff>] cirrus_pci_probe+0x87/0x93
[    2.332746]  [<811ad0d6>] pci_device_probe+0x4c/0x8d
[    2.332746]  [<811ad0d6>] pci_device_probe+0x4c/0x8d
[    2.333689]  [<811161d5>] ? sysfs_create_link+0x2c/0x35
[    2.333689]  [<811161d5>] ? sysfs_create_link+0x2c/0x35
[    2.334656]  [<8149af17>] driver_probe_device+0x99/0x1c1
[    2.334656]  [<8149af17>] driver_probe_device+0x99/0x1c1
[    2.335637]  [<811acf09>] ? pci_match_device+0x9f/0xa5
[    2.335637]  [<811acf09>] ? pci_match_device+0x9f/0xa5
[    2.336587]  [<8149b0c3>] __driver_attach+0x53/0x6f
[    2.336587]  [<8149b0c3>] __driver_attach+0x53/0x6f
[    2.337510]  [<81499b79>] bus_for_each_dev+0x3e/0x69
[    2.337510]  [<81499b79>] bus_for_each_dev+0x3e/0x69
[    2.338426]  [<8149ae35>] driver_attach+0x1c/0x1e
[    2.338426]  [<8149ae35>] driver_attach+0x1c/0x1e
[    2.339300]  [<8149b070>] ? __device_attach+0x31/0x31
[    2.339300]  [<8149b070>] ? __device_attach+0x31/0x31
[    2.340323]  [<8149a230>] bus_add_driver+0xc7/0x1a9
[    2.340323]  [<8149a230>] bus_add_driver+0xc7/0x1a9
[    2.341251]  [<8149b55f>] driver_register+0x96/0xca
[    2.341251]  [<8149b55f>] driver_register+0x96/0xca
[    2.342152]  [<810600f4>] ? __raw_spin_lock_init+0x32/0x53
[    2.342152]  [<810600f4>] ? __raw_spin_lock_init+0x32/0x53
[    2.343156]  [<811acf85>] __pci_register_driver+0x4a/0x4d
[    2.343156]  [<811acf85>] __pci_register_driver+0x4a/0x4d
[    2.344151]  [<812ad67f>] drm_pci_init+0x61/0xd8
[    2.344151]  [<812ad67f>] drm_pci_init+0x61/0xd8
[    2.344993]  [<81c70b2c>] ? tdfx_init+0x14/0x14
[    2.344993]  [<81c70b2c>] ? tdfx_init+0x14/0x14
[    2.345848]  [<81c71f2a>] ? mgag200_init+0x25/0x25
[    2.345848]  [<81c71f2a>] ? mgag200_init+0x25/0x25
[    2.346739]  [<81c71f45>] cirrus_init+0x1b/0x25
[    2.346739]  [<81c71f45>] cirrus_init+0x1b/0x25
[    2.347576]  [<81c46add>] do_one_initcall+0x8b/0x14b
[    2.347576]  [<81c46add>] do_one_initcall+0x8b/0x14b
[    2.348495]  [<8105bc23>] ? lock_release_holdtime+0xc1/0xcd
[    2.348495]  [<8105bc23>] ? lock_release_holdtime+0xc1/0xcd
[    2.349540]  [<81047ae2>] ? parameqn+0xc/0x41
[    2.349540]  [<81047ae2>] ? parameqn+0xc/0x41
[    2.350431]  [<81c46452>] ? repair_env_string+0x12/0x51
[    2.350431]  [<81c46452>] ? repair_env_string+0x12/0x51
[    2.351398]  [<81047caa>] ? parse_args+0x16e/0x231
[    2.351398]  [<81047caa>] ? parse_args+0x16e/0x231
[    2.352280]  [<81c46c6c>] kernel_init_freeable+0xcf/0x16e
[    2.352280]  [<81c46c6c>] kernel_init_freeable+0xcf/0x16e
[    2.353293]  [<81c46440>] ? do_early_param+0x7a/0x7a
[    2.353293]  [<81c46440>] ? do_early_param+0x7a/0x7a
[    2.354214]  [<816b3ed4>] kernel_init+0x10/0xcb
[    2.354214]  [<816b3ed4>] kernel_init+0x10/0xcb
[    2.355045]  [<8105280b>] ? schedule_tail+0x17/0x3e
[    2.355045]  [<8105280b>] ? schedule_tail+0x17/0x3e
[    2.355949]  [<816c2e37>] ret_from_kernel_thread+0x1b/0x28
[    2.355949]  [<816c2e37>] ret_from_kernel_thread+0x1b/0x28
[    2.356963]  [<816b3ec4>] ? rest_init+0xbc/0xbc
[    2.356963]  [<816b3ec4>] ? rest_init+0xbc/0xbc
[    2.357814] ---[ end trace a205f4c9292ec4a9 ]---
[    2.357814] ---[ end trace a205f4c9292ec4a9 ]---
[    2.358667] ------------[ cut here ]------------
[    2.358667] ------------[ cut here ]------------
[    2.359523] WARNING: CPU: 0 PID: 1 at drivers/gpu/drm/drm_modes.c:119 dr=
m_mode_probed_add+0x44/0x68()
[    2.359523] WARNING: CPU: 0 PID: 1 at drivers/gpu/drm/drm_modes.c:119 dr=
m_mode_probed_add+0x44/0x68()
[    2.361681] CPU: 0 PID: 1 Comm: swapper Tainted: G        W    3.14.0-rc=
7-wl-ath-04519-g2d18516 #9
[    2.361681] CPU: 0 PID: 1 Comm: swapper Tainted: G        W    3.14.0-rc=
7-wl-ath-04519-g2d18516 #9
[    2.363308] Hardware name: Bochs Bochs, BIOS Bochs 01/01/2011
[    2.363308] Hardware name: Bochs Bochs, BIOS Bochs 01/01/2011
[    2.364358]  00000000
[    2.364358]  00000000 00000000 00000000 80033bd8 80033bd8 816b7fd7 816b7=
fd7 80033c08 80033c08 8102fe35 8102fe35 81935ad6 81935ad6 00000000 00000000

[    2.365897]  00000001
[    2.365897]  00000001 819720ae 819720ae 00000077 00000077 812b4656 812b4=
656 812b4656 812b4656 92410c80 92410c80 92402800 92402800 00000001 00000001

[    2.367419]  80033c18
[    2.367419]  80033c18 8102fef5 8102fef5 00000009 00000009 00000000 00000=
000 80033c30 80033c30 812b4656 812b4656 01000000 01000000 81787358 81787358

[    2.368938] Call Trace:
[    2.368938] Call Trace:
[    2.369416]  [<816b7fd7>] dump_stack+0x16/0x18
[    2.369416]  [<816b7fd7>] dump_stack+0x16/0x18
[    2.370319]  [<8102fe35>] warn_slowpath_common+0x75/0x8c
[    2.370319]  [<8102fe35>] warn_slowpath_common+0x75/0x8c
[    2.371300]  [<812b4656>] ? drm_mode_probed_add+0x44/0x68
[    2.371300]  [<812b4656>] ? drm_mode_probed_add+0x44/0x68
[    2.372292]  [<812b4656>] ? drm_mode_probed_add+0x44/0x68
[    2.372292]  [<812b4656>] ? drm_mode_probed_add+0x44/0x68
[    2.373308]  [<8102fef5>] warn_slowpath_null+0x22/0x24
[    2.373308]  [<8102fef5>] warn_slowpath_null+0x22/0x24
[    2.374244]  [<812b4656>] drm_mode_probed_add+0x44/0x68
[    2.374244]  [<812b4656>] drm_mode_probed_add+0x44/0x68
[    2.375197]  [<812b8100>] drm_add_modes_noedid+0x68/0x84
[    2.375197]  [<812b8100>] drm_add_modes_noedid+0x68/0x84
[    2.376163]  [<813eaa99>] cirrus_vga_get_modes+0x1b/0x34
[    2.376163]  [<813eaa99>] cirrus_vga_get_modes+0x1b/0x34
[    2.377137]  [<812a0e00>] drm_helper_probe_single_connector_modes+0x125/=
0x310
[    2.377137]  [<812a0e00>] drm_helper_probe_single_connector_modes+0x125/=
0x310
[    2.378451]  [<812a1dec>] drm_fb_helper_probe_connector_modes+0x3a/0x4e
[    2.378451]  [<812a1dec>] drm_fb_helper_probe_connector_modes+0x3a/0x4e
[    2.379652]  [<812a3714>] drm_fb_helper_initial_config+0x174/0x3eb
[    2.379652]  [<812a3714>] drm_fb_helper_initial_config+0x174/0x3eb
[    2.380878]  [<8102fe44>] ? warn_slowpath_common+0x84/0x8c
[    2.380878]  [<8102fe44>] ? warn_slowpath_common+0x84/0x8c
[    2.381905]  [<8129fb2e>] ? drm_helper_crtc_in_use+0x43/0x8b
[    2.381905]  [<8129fb2e>] ? drm_helper_crtc_in_use+0x43/0x8b
[    2.382941]  [<8129fb2e>] ? drm_helper_crtc_in_use+0x43/0x8b
[    2.382941]  [<8129fb2e>] ? drm_helper_crtc_in_use+0x43/0x8b
[    2.383971]  [<8102fef5>] ? warn_slowpath_null+0x22/0x24
[    2.383971]  [<8102fef5>] ? warn_slowpath_null+0x22/0x24
[    2.384938]  [<8129fc31>] ? drm_helper_disable_unused_functions+0xbb/0xd4
[    2.384938]  [<8129fc31>] ? drm_helper_disable_unused_functions+0xbb/0xd4
[    2.386200]  [<813ebdcf>] cirrus_fbdev_init+0x83/0x92
[    2.386200]  [<813ebdcf>] cirrus_fbdev_init+0x83/0x92
[    2.387117]  [<813eb5f4>] cirrus_modeset_init+0x153/0x19c
[    2.387117]  [<813eb5f4>] cirrus_modeset_init+0x153/0x19c
[    2.388101]  [<813ea76b>] cirrus_driver_load+0x93/0xde
[    2.388101]  [<813ea76b>] cirrus_driver_load+0x93/0xde
[    2.389036]  [<812aba1e>] drm_dev_register+0x6e/0xd3
[    2.389036]  [<812aba1e>] drm_dev_register+0x6e/0xd3
[    2.389958]  [<812ad56a>] drm_get_pci_dev+0xdc/0x190
[    2.389958]  [<812ad56a>] drm_get_pci_dev+0xdc/0x190
[    2.390948]  [<813eb6ff>] cirrus_pci_probe+0x87/0x93
[    2.390948]  [<813eb6ff>] cirrus_pci_probe+0x87/0x93
[    2.391869]  [<811ad0d6>] pci_device_probe+0x4c/0x8d
[    2.391869]  [<811ad0d6>] pci_device_probe+0x4c/0x8d
[    2.392781]  [<811161d5>] ? sysfs_create_link+0x2c/0x35
[    2.392781]  [<811161d5>] ? sysfs_create_link+0x2c/0x35
[    2.393759]  [<8149af17>] driver_probe_device+0x99/0x1c1
[    2.393759]  [<8149af17>] driver_probe_device+0x99/0x1c1
[    2.394738]  [<811acf09>] ? pci_match_device+0x9f/0xa5
[    2.394738]  [<811acf09>] ? pci_match_device+0x9f/0xa5
[    2.395675]  [<8149b0c3>] __driver_attach+0x53/0x6f
[    2.395675]  [<8149b0c3>] __driver_attach+0x53/0x6f
[    2.396564]  [<81499b79>] bus_for_each_dev+0x3e/0x69
[    2.396564]  [<81499b79>] bus_for_each_dev+0x3e/0x69
[    2.397493]  [<8149ae35>] driver_attach+0x1c/0x1e
[    2.397493]  [<8149ae35>] driver_attach+0x1c/0x1e
[    2.398362]  [<8149b070>] ? __device_attach+0x31/0x31
[    2.398362]  [<8149b070>] ? __device_attach+0x31/0x31
[    2.399287]  [<8149a230>] bus_add_driver+0xc7/0x1a9
[    2.399287]  [<8149a230>] bus_add_driver+0xc7/0x1a9
[    2.400280]  [<8149b55f>] driver_register+0x96/0xca
[    2.400280]  [<8149b55f>] driver_register+0x96/0xca
[    2.401212]  [<810600f4>] ? __raw_spin_lock_init+0x32/0x53
[    2.401212]  [<810600f4>] ? __raw_spin_lock_init+0x32/0x53
[    2.402221]  [<811acf85>] __pci_register_driver+0x4a/0x4d
[    2.402221]  [<811acf85>] __pci_register_driver+0x4a/0x4d
[    2.403212]  [<812ad67f>] drm_pci_init+0x61/0xd8
[    2.403212]  [<812ad67f>] drm_pci_init+0x61/0xd8
[    2.404053]  [<81c70b2c>] ? tdfx_init+0x14/0x14
[    2.404053]  [<81c70b2c>] ? tdfx_init+0x14/0x14
[    2.404883]  [<81c71f2a>] ? mgag200_init+0x25/0x25
[    2.404883]  [<81c71f2a>] ? mgag200_init+0x25/0x25
[    2.405777]  [<81c71f45>] cirrus_init+0x1b/0x25
[    2.405777]  [<81c71f45>] cirrus_init+0x1b/0x25
[    2.406612]  [<81c46add>] do_one_initcall+0x8b/0x14b
[    2.406612]  [<81c46add>] do_one_initcall+0x8b/0x14b
[    2.407521]  [<8105bc23>] ? lock_release_holdtime+0xc1/0xcd
[    2.407521]  [<8105bc23>] ? lock_release_holdtime+0xc1/0xcd
[    2.408542]  [<81047ae2>] ? parameqn+0xc/0x41
[    2.408542]  [<81047ae2>] ? parameqn+0xc/0x41
[    2.409359]  [<81c46452>] ? repair_env_string+0x12/0x51
[    2.409359]  [<81c46452>] ? repair_env_string+0x12/0x51
[    2.410402]  [<81047caa>] ? parse_args+0x16e/0x231
[    2.410402]  [<81047caa>] ? parse_args+0x16e/0x231
[    2.411290]  [<81c46c6c>] kernel_init_freeable+0xcf/0x16e
[    2.411290]  [<81c46c6c>] kernel_init_freeable+0xcf/0x16e
[    2.412282]  [<81c46440>] ? do_early_param+0x7a/0x7a
[    2.412282]  [<81c46440>] ? do_early_param+0x7a/0x7a
[    2.413217]  [<816b3ed4>] kernel_init+0x10/0xcb
[    2.413217]  [<816b3ed4>] kernel_init+0x10/0xcb
[    2.414042]  [<8105280b>] ? schedule_tail+0x17/0x3e
[    2.414042]  [<8105280b>] ? schedule_tail+0x17/0x3e
[    2.414936]  [<816c2e37>] ret_from_kernel_thread+0x1b/0x28
[    2.414936]  [<816c2e37>] ret_from_kernel_thread+0x1b/0x28
[    2.415935]  [<816b3ec4>] ? rest_init+0xbc/0xbc
[    2.415935]  [<816b3ec4>] ? rest_init+0xbc/0xbc
[    2.416760] ---[ end trace a205f4c9292ec4aa ]---
[    2.416760] ---[ end trace a205f4c9292ec4aa ]---
[    2.417629] ------------[ cut here ]------------
[    2.417629] ------------[ cut here ]------------
[    2.418486] WARNING: CPU: 0 PID: 1 at drivers/gpu/drm/drm_modes.c:119 dr=
m_mode_probed_add+0x44/0x68()
[    2.418486] WARNING: CPU: 0 PID: 1 at drivers/gpu/drm/drm_modes.c:119 dr=
m_mode_probed_add+0x44/0x68()
[    2.420650] CPU: 0 PID: 1 Comm: swapper Tainted: G        W    3.14.0-rc=
7-wl-ath-04519-g2d18516 #9
[    2.420650] CPU: 0 PID: 1 Comm: swapper Tainted: G        W    3.14.0-rc=
7-wl-ath-04519-g2d18516 #9
[    2.422313] Hardware name: Bochs Bochs, BIOS Bochs 01/01/2011
[    2.422313] Hardware name: Bochs Bochs, BIOS Bochs 01/01/2011
[    2.423368]  00000000
[    2.423368]  00000000 00000000 00000000 80033bd8 80033bd8 816b7fd7 816b7=
fd7 80033c08 80033c08 8102fe35 8102fe35 81935ad6 81935ad6 00000000 00000000

[    2.424892]  00000001
[    2.424892]  00000001 819720ae 819720ae 00000077 00000077 812b4656 812b4=
656 812b4656 812b4656 92410b80 92410b80 92402800 92402800 00000001 00000001

[    2.426440]  80033c18
[    2.426440]  80033c18 8102fef5 8102fef5 00000009 00000009 00000000 00000=
000 80033c30 80033c30 812b4656 812b4656 01000000 01000000 81787658 81787658

[    2.427959] Call Trace:
[    2.427959] Call Trace:
[    2.428418]  [<816b7fd7>] dump_stack+0x16/0x18
[    2.428418]  [<816b7fd7>] dump_stack+0x16/0x18
[    2.429249]  [<8102fe35>] warn_slowpath_common+0x75/0x8c
[    2.429249]  [<8102fe35>] warn_slowpath_common+0x75/0x8c
[    2.430315]  [<812b4656>] ? drm_mode_probed_add+0x44/0x68
[    2.430315]  [<812b4656>] ? drm_mode_probed_add+0x44/0x68
[    2.431315]  [<812b4656>] ? drm_mode_probed_add+0x44/0x68
[    2.431315]  [<812b4656>] ? drm_mode_probed_add+0x44/0x68
[    2.432307]  [<8102fef5>] warn_slowpath_null+0x22/0x24
[    2.432307]  [<8102fef5>] warn_slowpath_null+0x22/0x24
[    2.433275]  [<812b4656>] drm_mode_probed_add+0x44/0x68
[    2.433275]  [<812b4656>] drm_mode_probed_add+0x44/0x68
[    2.434234]  [<812b8100>] drm_add_modes_noedid+0x68/0x84
[    2.434234]  [<812b8100>] drm_add_modes_noedid+0x68/0x84
[    2.435214]  [<813eaa99>] cirrus_vga_get_modes+0x1b/0x34
[    2.435214]  [<813eaa99>] cirrus_vga_get_modes+0x1b/0x34
[    2.436200]  [<812a0e00>] drm_helper_probe_single_connector_modes+0x125/=
0x310
[    2.436200]  [<812a0e00>] drm_helper_probe_single_connector_modes+0x125/=
0x310
[    2.437525]  [<812a1dec>] drm_fb_helper_probe_connector_modes+0x3a/0x4e
[    2.437525]  [<812a1dec>] drm_fb_helper_probe_connector_modes+0x3a/0x4e
[    2.438739]  [<812a3714>] drm_fb_helper_initial_config+0x174/0x3eb
[    2.438739]  [<812a3714>] drm_fb_helper_initial_config+0x174/0x3eb
[    2.439869]  [<8102fe44>] ? warn_slowpath_common+0x84/0x8c
[    2.439869]  [<8102fe44>] ? warn_slowpath_common+0x84/0x8c
[    2.440949]  [<8129fb2e>] ? drm_helper_crtc_in_use+0x43/0x8b
[    2.440949]  [<8129fb2e>] ? drm_helper_crtc_in_use+0x43/0x8b
[    2.442012]  [<8129fb2e>] ? drm_helper_crtc_in_use+0x43/0x8b
[    2.442012]  [<8129fb2e>] ? drm_helper_crtc_in_use+0x43/0x8b
[    2.443057]  [<8102fef5>] ? warn_slowpath_null+0x22/0x24
[    2.443057]  [<8102fef5>] ? warn_slowpath_null+0x22/0x24
[    2.444036]  [<8129fc31>] ? drm_helper_disable_unused_functions+0xbb/0xd4
[    2.444036]  [<8129fc31>] ? drm_helper_disable_unused_functions+0xbb/0xd4
[    2.445297]  [<813ebdcf>] cirrus_fbdev_init+0x83/0x92
[    2.445297]  [<813ebdcf>] cirrus_fbdev_init+0x83/0x92
[    2.446226]  [<813eb5f4>] cirrus_modeset_init+0x153/0x19c
[    2.446226]  [<813eb5f4>] cirrus_modeset_init+0x153/0x19c
[    2.447212]  [<813ea76b>] cirrus_driver_load+0x93/0xde
[    2.447212]  [<813ea76b>] cirrus_driver_load+0x93/0xde
[    2.448163]  [<812aba1e>] drm_dev_register+0x6e/0xd3
[    2.448163]  [<812aba1e>] drm_dev_register+0x6e/0xd3
[    2.449073]  [<812ad56a>] drm_get_pci_dev+0xdc/0x190
[    2.449073]  [<812ad56a>] drm_get_pci_dev+0xdc/0x190
[    2.450001]  [<813eb6ff>] cirrus_pci_probe+0x87/0x93
[    2.450001]  [<813eb6ff>] cirrus_pci_probe+0x87/0x93
[    2.451007]  [<811ad0d6>] pci_device_probe+0x4c/0x8d
[    2.451007]  [<811ad0d6>] pci_device_probe+0x4c/0x8d
[    2.451934]  [<811161d5>] ? sysfs_create_link+0x2c/0x35
[    2.451934]  [<811161d5>] ? sysfs_create_link+0x2c/0x35
[    2.452898]  [<8149af17>] driver_probe_device+0x99/0x1c1
[    2.452898]  [<8149af17>] driver_probe_device+0x99/0x1c1
[    2.453891]  [<811acf09>] ? pci_match_device+0x9f/0xa5
[    2.453891]  [<811acf09>] ? pci_match_device+0x9f/0xa5
[    2.454835]  [<8149b0c3>] __driver_attach+0x53/0x6f
[    2.454835]  [<8149b0c3>] __driver_attach+0x53/0x6f
[    2.455735]  [<81499b79>] bus_for_each_dev+0x3e/0x69
[    2.455735]  [<81499b79>] bus_for_each_dev+0x3e/0x69
[    2.456647]  [<8149ae35>] driver_attach+0x1c/0x1e
[    2.456647]  [<8149ae35>] driver_attach+0x1c/0x1e
[    2.457533]  [<8149b070>] ? __device_attach+0x31/0x31
[    2.457533]  [<8149b070>] ? __device_attach+0x31/0x31
[    2.458468]  [<8149a230>] bus_add_driver+0xc7/0x1a9
[    2.458468]  [<8149a230>] bus_add_driver+0xc7/0x1a9
[    2.459363]  [<8149b55f>] driver_register+0x96/0xca
[    2.459363]  [<8149b55f>] driver_register+0x96/0xca
[    2.460352]  [<810600f4>] ? __raw_spin_lock_init+0x32/0x53
[    2.460352]  [<810600f4>] ? __raw_spin_lock_init+0x32/0x53
[    2.461377]  [<811acf85>] __pci_register_driver+0x4a/0x4d
[    2.461377]  [<811acf85>] __pci_register_driver+0x4a/0x4d
[    2.462367]  [<812ad67f>] drm_pci_init+0x61/0xd8
[    2.462367]  [<812ad67f>] drm_pci_init+0x61/0xd8
[    2.463216]  [<81c70b2c>] ? tdfx_init+0x14/0x14
[    2.463216]  [<81c70b2c>] ? tdfx_init+0x14/0x14
[    2.464045]  [<81c71f2a>] ? mgag200_init+0x25/0x25
[    2.464045]  [<81c71f2a>] ? mgag200_init+0x25/0x25
[    2.464916]  [<81c71f45>] cirrus_init+0x1b/0x25
[    2.464916]  [<81c71f45>] cirrus_init+0x1b/0x25
[    2.465766]  [<81c46add>] do_one_initcall+0x8b/0x14b
[    2.465766]  [<81c46add>] do_one_initcall+0x8b/0x14b
[    2.466676]  [<8105bc23>] ? lock_release_holdtime+0xc1/0xcd
[    2.466676]  [<8105bc23>] ? lock_release_holdtime+0xc1/0xcd
[    2.467698]  [<81047ae2>] ? parameqn+0xc/0x41
[    2.467698]  [<81047ae2>] ? parameqn+0xc/0x41
[    2.468499]  [<81c46452>] ? repair_env_string+0x12/0x51
[    2.468499]  [<81c46452>] ? repair_env_string+0x12/0x51
[    2.469490]  [<81047caa>] ? parse_args+0x16e/0x231
[    2.469490]  [<81047caa>] ? parse_args+0x16e/0x231
[    2.470460]  [<81c46c6c>] kernel_init_freeable+0xcf/0x16e
[    2.470460]  [<81c46c6c>] kernel_init_freeable+0xcf/0x16e
[    2.471457]  [<81c46440>] ? do_early_param+0x7a/0x7a
[    2.471457]  [<81c46440>] ? do_early_param+0x7a/0x7a
[    2.472370]  [<816b3ed4>] kernel_init+0x10/0xcb
[    2.472370]  [<816b3ed4>] kernel_init+0x10/0xcb
[    2.473227]  [<8105280b>] ? schedule_tail+0x17/0x3e
[    2.473227]  [<8105280b>] ? schedule_tail+0x17/0x3e
[    2.474119]  [<816c2e37>] ret_from_kernel_thread+0x1b/0x28
[    2.474119]  [<816c2e37>] ret_from_kernel_thread+0x1b/0x28
[    2.475117]  [<816b3ec4>] ? rest_init+0xbc/0xbc
[    2.475117]  [<816b3ec4>] ? rest_init+0xbc/0xbc
[    2.475946] ---[ end trace a205f4c9292ec4ab ]---
[    2.475946] ---[ end trace a205f4c9292ec4ab ]---
[    2.476802] ------------[ cut here ]------------
[    2.476802] ------------[ cut here ]------------
[    2.477671] WARNING: CPU: 0 PID: 1 at drivers/gpu/drm/drm_modes.c:119 dr=
m_mode_probed_add+0x44/0x68()
[    2.477671] WARNING: CPU: 0 PID: 1 at drivers/gpu/drm/drm_modes.c:119 dr=
m_mode_probed_add+0x44/0x68()
[    2.479731] CPU: 0 PID: 1 Comm: swapper Tainted: G        W    3.14.0-rc=
7-wl-ath-04519-g2d18516 #9
[    2.479731] CPU: 0 PID: 1 Comm: swapper Tainted: G        W    3.14.0-rc=
7-wl-ath-04519-g2d18516 #9
[    2.481457] Hardware name: Bochs Bochs, BIOS Bochs 01/01/2011
[    2.481457] Hardware name: Bochs Bochs, BIOS Bochs 01/01/2011
[    2.482510]  00000000
[    2.482510]  00000000 00000000 00000000 80033bd8 80033bd8 816b7fd7 816b7=
fd7 80033c08 80033c08 8102fe35 8102fe35 81935ad6 81935ad6 00000000 00000000

[    2.484033]  00000001
[    2.484033]  00000001 819720ae 819720ae 00000077 00000077 812b4656 812b4=
656 812b4656 812b4656 92410a80 92410a80 92402800 92402800 00000001 00000001

[    2.485581]  80033c18
[    2.485581]  80033c18 8102fef5 8102fef5 00000009 00000009 00000000 00000=
000 80033c30 80033c30 812b4656 812b4656 01000000 01000000 81787898 81787898

[    2.487106] Call Trace:
[    2.487106] Call Trace:
[    2.487566]  [<816b7fd7>] dump_stack+0x16/0x18
[    2.487566]  [<816b7fd7>] dump_stack+0x16/0x18
[    2.488387]  [<8102fe35>] warn_slowpath_common+0x75/0x8c
[    2.488387]  [<8102fe35>] warn_slowpath_common+0x75/0x8c
[    2.489385]  [<812b4656>] ? drm_mode_probed_add+0x44/0x68
[    2.489385]  [<812b4656>] ? drm_mode_probed_add+0x44/0x68
[    2.490468]  [<812b4656>] ? drm_mode_probed_add+0x44/0x68
[    2.490468]  [<812b4656>] ? drm_mode_probed_add+0x44/0x68
[    2.491461]  [<8102fef5>] warn_slowpath_null+0x22/0x24
[    2.491461]  [<8102fef5>] warn_slowpath_null+0x22/0x24
[    2.492405]  [<812b4656>] drm_mode_probed_add+0x44/0x68
[    2.492405]  [<812b4656>] drm_mode_probed_add+0x44/0x68
[    2.493386]  [<812b8100>] drm_add_modes_noedid+0x68/0x84
[    2.493386]  [<812b8100>] drm_add_modes_noedid+0x68/0x84
[    2.494367]  [<813eaa99>] cirrus_vga_get_modes+0x1b/0x34
[    2.494367]  [<813eaa99>] cirrus_vga_get_modes+0x1b/0x34
[    2.495338]  [<812a0e00>] drm_helper_probe_single_connector_modes+0x125/=
0x310
[    2.495338]  [<812a0e00>] drm_helper_probe_single_connector_modes+0x125/=
0x310
[    2.496635]  [<812a1dec>] drm_fb_helper_probe_connector_modes+0x3a/0x4e
[    2.496635]  [<812a1dec>] drm_fb_helper_probe_connector_modes+0x3a/0x4e
[    2.497861]  [<812a3714>] drm_fb_helper_initial_config+0x174/0x3eb
[    2.497861]  [<812a3714>] drm_fb_helper_initial_config+0x174/0x3eb
[    2.498990]  [<8102fe44>] ? warn_slowpath_common+0x84/0x8c
[    2.498990]  [<8102fe44>] ? warn_slowpath_common+0x84/0x8c
[    2.499994]  [<8129fb2e>] ? drm_helper_crtc_in_use+0x43/0x8b
[    2.499994]  [<8129fb2e>] ? drm_helper_crtc_in_use+0x43/0x8b
[    2.501117]  [<8129fb2e>] ? drm_helper_crtc_in_use+0x43/0x8b
[    2.501117]  [<8129fb2e>] ? drm_helper_crtc_in_use+0x43/0x8b
[    2.502180]  [<8102fef5>] ? warn_slowpath_null+0x22/0x24
[    2.502180]  [<8102fef5>] ? warn_slowpath_null+0x22/0x24
[    2.503157]  [<8129fc31>] ? drm_helper_disable_unused_functions+0xbb/0xd4
[    2.503157]  [<8129fc31>] ? drm_helper_disable_unused_functions+0xbb/0xd4
[    2.504393]  [<813ebdcf>] cirrus_fbdev_init+0x83/0x92
[    2.504393]  [<813ebdcf>] cirrus_fbdev_init+0x83/0x92
[    2.505344]  [<813eb5f4>] cirrus_modeset_init+0x153/0x19c
[    2.505344]  [<813eb5f4>] cirrus_modeset_init+0x153/0x19c
[    2.506326]  [<813ea76b>] cirrus_driver_load+0x93/0xde
[    2.506326]  [<813ea76b>] cirrus_driver_load+0x93/0xde
[    2.507272]  [<812aba1e>] drm_dev_register+0x6e/0xd3
[    2.507272]  [<812aba1e>] drm_dev_register+0x6e/0xd3
[    2.508183]  [<812ad56a>] drm_get_pci_dev+0xdc/0x190
[    2.508183]  [<812ad56a>] drm_get_pci_dev+0xdc/0x190
[    2.509089]  [<813eb6ff>] cirrus_pci_probe+0x87/0x93
[    2.509089]  [<813eb6ff>] cirrus_pci_probe+0x87/0x93
[    2.510124]  [<811ad0d6>] pci_device_probe+0x4c/0x8d
[    2.510124]  [<811ad0d6>] pci_device_probe+0x4c/0x8d
[    2.511042]  [<811161d5>] ? sysfs_create_link+0x2c/0x35
[    2.511042]  [<811161d5>] ? sysfs_create_link+0x2c/0x35
[    2.512005]  [<8149af17>] driver_probe_device+0x99/0x1c1
[    2.512005]  [<8149af17>] driver_probe_device+0x99/0x1c1
[    2.512978]  [<811acf09>] ? pci_match_device+0x9f/0xa5
[    2.512978]  [<811acf09>] ? pci_match_device+0x9f/0xa5
[    2.513943]  [<8149b0c3>] __driver_attach+0x53/0x6f
[    2.513943]  [<8149b0c3>] __driver_attach+0x53/0x6f
[    2.514843]  [<81499b79>] bus_for_each_dev+0x3e/0x69
[    2.514843]  [<81499b79>] bus_for_each_dev+0x3e/0x69
[    2.515758]  [<8149ae35>] driver_attach+0x1c/0x1e
[    2.515758]  [<8149ae35>] driver_attach+0x1c/0x1e
[    2.516631]  [<8149b070>] ? __device_attach+0x31/0x31
[    2.516631]  [<8149b070>] ? __device_attach+0x31/0x31
[    2.517585]  [<8149a230>] bus_add_driver+0xc7/0x1a9
[    2.517585]  [<8149a230>] bus_add_driver+0xc7/0x1a9
[    2.518487]  [<8149b55f>] driver_register+0x96/0xca
[    2.518487]  [<8149b55f>] driver_register+0x96/0xca
[    2.519386]  [<810600f4>] ? __raw_spin_lock_init+0x32/0x53
[    2.519386]  [<810600f4>] ? __raw_spin_lock_init+0x32/0x53
[    2.520531]  [<811acf85>] __pci_register_driver+0x4a/0x4d
[    2.520531]  [<811acf85>] __pci_register_driver+0x4a/0x4d
[    2.521554]  [<812ad67f>] drm_pci_init+0x61/0xd8
[    2.521554]  [<812ad67f>] drm_pci_init+0x61/0xd8
[    2.522407]  [<81c70b2c>] ? tdfx_init+0x14/0x14
[    2.522407]  [<81c70b2c>] ? tdfx_init+0x14/0x14
[    2.523249]  [<81c71f2a>] ? mgag200_init+0x25/0x25
[    2.523249]  [<81c71f2a>] ? mgag200_init+0x25/0x25
[    2.524137]  [<81c71f45>] cirrus_init+0x1b/0x25
[    2.524137]  [<81c71f45>] cirrus_init+0x1b/0x25
[    2.524966]  [<81c46add>] do_one_initcall+0x8b/0x14b
[    2.524966]  [<81c46add>] do_one_initcall+0x8b/0x14b
[    2.525898]  [<8105bc23>] ? lock_release_holdtime+0xc1/0xcd
[    2.525898]  [<8105bc23>] ? lock_release_holdtime+0xc1/0xcd
[    2.526931]  [<81047ae2>] ? parameqn+0xc/0x41
[    2.526931]  [<81047ae2>] ? parameqn+0xc/0x41
[    2.527736]  [<81c46452>] ? repair_env_string+0x12/0x51
[    2.527736]  [<81c46452>] ? repair_env_string+0x12/0x51
[    2.528699]  [<81047caa>] ? parse_args+0x16e/0x231
[    2.528699]  [<81047caa>] ? parse_args+0x16e/0x231
[    2.529598]  [<81c46c6c>] kernel_init_freeable+0xcf/0x16e
[    2.529598]  [<81c46c6c>] kernel_init_freeable+0xcf/0x16e
[    2.530687]  [<81c46440>] ? do_early_param+0x7a/0x7a
[    2.530687]  [<81c46440>] ? do_early_param+0x7a/0x7a
[    2.531607]  [<816b3ed4>] kernel_init+0x10/0xcb
[    2.531607]  [<816b3ed4>] kernel_init+0x10/0xcb
[    2.532444]  [<8105280b>] ? schedule_tail+0x17/0x3e
[    2.532444]  [<8105280b>] ? schedule_tail+0x17/0x3e
[    2.533356]  [<816c2e37>] ret_from_kernel_thread+0x1b/0x28
[    2.533356]  [<816c2e37>] ret_from_kernel_thread+0x1b/0x28
[    2.534362]  [<816b3ec4>] ? rest_init+0xbc/0xbc
[    2.534362]  [<816b3ec4>] ? rest_init+0xbc/0xbc
[    2.535198] ---[ end trace a205f4c9292ec4ac ]---
[    2.535198] ---[ end trace a205f4c9292ec4ac ]---
[    2.536040] ------------[ cut here ]------------
[    2.536040] ------------[ cut here ]------------
[    2.536893] WARNING: CPU: 0 PID: 1 at drivers/gpu/drm/drm_modes.c:1030 d=
rm_mode_connector_list_update+0x44/0xe5()
[    2.536893] WARNING: CPU: 0 PID: 1 at drivers/gpu/drm/drm_modes.c:1030 d=
rm_mode_connector_list_update+0x44/0xe5()
[    2.539177] CPU: 0 PID: 1 Comm: swapper Tainted: G        W    3.14.0-rc=
7-wl-ath-04519-g2d18516 #9
[    2.539177] CPU: 0 PID: 1 Comm: swapper Tainted: G        W    3.14.0-rc=
7-wl-ath-04519-g2d18516 #9
[    2.540901] Hardware name: Bochs Bochs, BIOS Bochs 01/01/2011
[    2.540901] Hardware name: Bochs Bochs, BIOS Bochs 01/01/2011
[    2.541972]  00000000
[    2.541972]  00000000 00000000 00000000 80033c00 80033c00 816b7fd7 816b7=
fd7 80033c30 80033c30 8102fe35 8102fe35 81935ad6 81935ad6 00000000 00000000

[    2.543507]  00000001
[    2.543507]  00000001 819720ae 819720ae 00000406 00000406 812b5078 812b5=
078 812b5078 812b5078 92402801 92402801 92402800 92402800 00000001 00000001

[    2.545031]  80033c40
[    2.545031]  80033c40 8102fef5 8102fef5 00000009 00000009 00000000 00000=
000 80033c60 80033c60 812b5078 812b5078 812b8125 812b8125 92402800 92402800

[    2.546580] Call Trace:
[    2.546580] Call Trace:
[    2.547033]  [<816b7fd7>] dump_stack+0x16/0x18
[    2.547033]  [<816b7fd7>] dump_stack+0x16/0x18
[    2.547858]  [<8102fe35>] warn_slowpath_common+0x75/0x8c
[    2.547858]  [<8102fe35>] warn_slowpath_common+0x75/0x8c
[    2.548842]  [<812b5078>] ? drm_mode_connector_list_update+0x44/0xe5
[    2.548842]  [<812b5078>] ? drm_mode_connector_list_update+0x44/0xe5
[    2.550116]  [<812b5078>] ? drm_mode_connector_list_update+0x44/0xe5
[    2.550116]  [<812b5078>] ? drm_mode_connector_list_update+0x44/0xe5
[    2.551291]  [<8102fef5>] warn_slowpath_null+0x22/0x24
[    2.551291]  [<8102fef5>] warn_slowpath_null+0x22/0x24
[    2.552240]  [<812b5078>] drm_mode_connector_list_update+0x44/0xe5
[    2.552240]  [<812b5078>] drm_mode_connector_list_update+0x44/0xe5
[    2.553399]  [<812b8125>] ? drm_set_preferred_mode+0x9/0x28
[    2.553399]  [<812b8125>] ? drm_set_preferred_mode+0x9/0x28
[    2.554427]  [<812a0e33>] drm_helper_probe_single_connector_modes+0x158/=
0x310
[    2.554427]  [<812a0e33>] drm_helper_probe_single_connector_modes+0x158/=
0x310
[    2.555739]  [<812a1dec>] drm_fb_helper_probe_connector_modes+0x3a/0x4e
[    2.555739]  [<812a1dec>] drm_fb_helper_probe_connector_modes+0x3a/0x4e
[    2.556954]  [<812a3714>] drm_fb_helper_initial_config+0x174/0x3eb
[    2.556954]  [<812a3714>] drm_fb_helper_initial_config+0x174/0x3eb
[    2.558100]  [<8102fe44>] ? warn_slowpath_common+0x84/0x8c
[    2.558100]  [<8102fe44>] ? warn_slowpath_common+0x84/0x8c
[    2.559113]  [<8129fb2e>] ? drm_helper_crtc_in_use+0x43/0x8b
[    2.559113]  [<8129fb2e>] ? drm_helper_crtc_in_use+0x43/0x8b
[    2.560244]  [<8129fb2e>] ? drm_helper_crtc_in_use+0x43/0x8b
[    2.560244]  [<8129fb2e>] ? drm_helper_crtc_in_use+0x43/0x8b
[    2.561309]  [<8102fef5>] ? warn_slowpath_null+0x22/0x24
[    2.561309]  [<8102fef5>] ? warn_slowpath_null+0x22/0x24
[    2.562283]  [<8129fc31>] ? drm_helper_disable_unused_functions+0xbb/0xd4
[    2.562283]  [<8129fc31>] ? drm_helper_disable_unused_functions+0xbb/0xd4
[    2.563525]  [<813ebdcf>] cirrus_fbdev_init+0x83/0x92
[    2.563525]  [<813ebdcf>] cirrus_fbdev_init+0x83/0x92
[    2.564457]  [<813eb5f4>] cirrus_modeset_init+0x153/0x19c
[    2.564457]  [<813eb5f4>] cirrus_modeset_init+0x153/0x19c
[    2.565459]  [<813ea76b>] cirrus_driver_load+0x93/0xde
[    2.565459]  [<813ea76b>] cirrus_driver_load+0x93/0xde
[    2.566403]  [<812aba1e>] drm_dev_register+0x6e/0xd3
[    2.566403]  [<812aba1e>] drm_dev_register+0x6e/0xd3
[    2.567315]  [<812ad56a>] drm_get_pci_dev+0xdc/0x190
[    2.567315]  [<812ad56a>] drm_get_pci_dev+0xdc/0x190
[    2.568223]  [<813eb6ff>] cirrus_pci_probe+0x87/0x93
[    2.568223]  [<813eb6ff>] cirrus_pci_probe+0x87/0x93
[    2.569137]  [<811ad0d6>] pci_device_probe+0x4c/0x8d
[    2.569137]  [<811ad0d6>] pci_device_probe+0x4c/0x8d
[    2.570174]  [<811161d5>] ? sysfs_create_link+0x2c/0x35
[    2.570174]  [<811161d5>] ? sysfs_create_link+0x2c/0x35
[    2.571135]  [<8149af17>] driver_probe_device+0x99/0x1c1
[    2.571135]  [<8149af17>] driver_probe_device+0x99/0x1c1
[    2.572115]  [<811acf09>] ? pci_match_device+0x9f/0xa5
[    2.572115]  [<811acf09>] ? pci_match_device+0x9f/0xa5
[    2.573060]  [<8149b0c3>] __driver_attach+0x53/0x6f
[    2.573060]  [<8149b0c3>] __driver_attach+0x53/0x6f
[    2.573982]  [<81499b79>] bus_for_each_dev+0x3e/0x69
[    2.573982]  [<81499b79>] bus_for_each_dev+0x3e/0x69
[    2.574902]  [<8149ae35>] driver_attach+0x1c/0x1e
[    2.574902]  [<8149ae35>] driver_attach+0x1c/0x1e
[    2.575771]  [<8149b070>] ? __device_attach+0x31/0x31
[    2.575771]  [<8149b070>] ? __device_attach+0x31/0x31
[    2.576703]  [<8149a230>] bus_add_driver+0xc7/0x1a9
[    2.576703]  [<8149a230>] bus_add_driver+0xc7/0x1a9
[    2.577630]  [<8149b55f>] driver_register+0x96/0xca
[    2.577630]  [<8149b55f>] driver_register+0x96/0xca
[    2.578531]  [<810600f4>] ? __raw_spin_lock_init+0x32/0x53
[    2.578531]  [<810600f4>] ? __raw_spin_lock_init+0x32/0x53
[    2.579543]  [<811acf85>] __pci_register_driver+0x4a/0x4d
[    2.579543]  [<811acf85>] __pci_register_driver+0x4a/0x4d
[    2.580650]  [<812ad67f>] drm_pci_init+0x61/0xd8
[    2.580650]  [<812ad67f>] drm_pci_init+0x61/0xd8
[    2.581530]  [<81c70b2c>] ? tdfx_init+0x14/0x14
[    2.581530]  [<81c70b2c>] ? tdfx_init+0x14/0x14
[    2.582361]  [<81c71f2a>] ? mgag200_init+0x25/0x25
[    2.582361]  [<81c71f2a>] ? mgag200_init+0x25/0x25
[    2.583238]  [<81c71f45>] cirrus_init+0x1b/0x25
[    2.583238]  [<81c71f45>] cirrus_init+0x1b/0x25
[    2.584066]  [<81c46add>] do_one_initcall+0x8b/0x14b
[    2.584066]  [<81c46add>] do_one_initcall+0x8b/0x14b
[    2.584980]  [<8105bc23>] ? lock_release_holdtime+0xc1/0xcd
[    2.584980]  [<8105bc23>] ? lock_release_holdtime+0xc1/0xcd
[    2.586021]  [<81047ae2>] ? parameqn+0xc/0x41
[    2.586021]  [<81047ae2>] ? parameqn+0xc/0x41
[    2.586824]  [<81c46452>] ? repair_env_string+0x12/0x51
[    2.586824]  [<81c46452>] ? repair_env_string+0x12/0x51
[    2.587788]  [<81047caa>] ? parse_args+0x16e/0x231
[    2.587788]  [<81047caa>] ? parse_args+0x16e/0x231
[    2.588668]  [<81c46c6c>] kernel_init_freeable+0xcf/0x16e
[    2.588668]  [<81c46c6c>] kernel_init_freeable+0xcf/0x16e
[    2.589672]  [<81c46440>] ? do_early_param+0x7a/0x7a
[    2.589672]  [<81c46440>] ? do_early_param+0x7a/0x7a
[    2.590672]  [<816b3ed4>] kernel_init+0x10/0xcb
[    2.590672]  [<816b3ed4>] kernel_init+0x10/0xcb
[    2.591510]  [<8105280b>] ? schedule_tail+0x17/0x3e
[    2.591510]  [<8105280b>] ? schedule_tail+0x17/0x3e
[    2.592406]  [<816c2e37>] ret_from_kernel_thread+0x1b/0x28
[    2.592406]  [<816c2e37>] ret_from_kernel_thread+0x1b/0x28
[    2.593438]  [<816b3ec4>] ? rest_init+0xbc/0xbc
[    2.593438]  [<816b3ec4>] ? rest_init+0xbc/0xbc
[    2.594278] ---[ end trace a205f4c9292ec4ad ]---
[    2.594278] ---[ end trace a205f4c9292ec4ad ]---
[    2.595465] [drm] fb mappable at 0xFC000000
[    2.595465] [drm] fb mappable at 0xFC000000
[    2.596244] [drm] vram aper at 0xFC000000
[    2.596244] [drm] vram aper at 0xFC000000
[    2.596977] [drm] size 4194304
[    2.596977] [drm] size 4194304
[    2.597558] [drm] fb depth is 24
[    2.597558] [drm] fb depth is 24
[    2.598151] [drm]    pitch is 3072
[    2.598151] [drm]    pitch is 3072
[    2.610258] cirrus 0000:00:02.0: fb0: cirrusdrmfb frame buffer device
[    2.610258] cirrus 0000:00:02.0: fb0: cirrusdrmfb frame buffer device
[    2.611448] cirrus 0000:00:02.0: registered panic notifier
[    2.611448] cirrus 0000:00:02.0: registered panic notifier
[    2.612449] [drm] Initialized cirrus 1.0.0 20110418 for 0000:00:02.0 on =
minor 0
[    2.612449] [drm] Initialized cirrus 1.0.0 20110418 for 0000:00:02.0 on =
minor 0
[    2.614629] Phantom Linux Driver, version n0.9.8, init OK
[    2.614629] Phantom Linux Driver, version n0.9.8, init OK
[    2.615913] Silicon Labs C2 port support v. 0.51.0 - (C) 2007 Rodolfo Gi=
ometti
[    2.615913] Silicon Labs C2 port support v. 0.51.0 - (C) 2007 Rodolfo Gi=
ometti
[    2.617622] Guest personality initialized and is inactive
[    2.617622] Guest personality initialized and is inactive
[    2.618723] VMCI host device registered (name=3Dvmci, major=3D10, minor=
=3D63)
[    2.618723] VMCI host device registered (name=3Dvmci, major=3D10, minor=
=3D63)
[    2.619948] Initialized host personality
[    2.619948] Initialized host personality
[    2.621668] mtdoops: mtd device (mtddev=3Dname/number) must be supplied
[    2.621668] mtdoops: mtd device (mtddev=3Dname/number) must be supplied
[    2.622881] L440GX flash mapping: failed to find PIIX4 ISA bridge, canno=
t continue
[    2.622881] L440GX flash mapping: failed to find PIIX4 ISA bridge, canno=
t continue
[    2.624461] Ramix PMC551 PCI Mezzanine Ram Driver. (C) 1999,2000 Nortel =
Networks.
[    2.624461] Ramix PMC551 PCI Mezzanine Ram Driver. (C) 1999,2000 Nortel =
Networks.
[    2.625871] pmc551: not detected
[    2.625871] pmc551: not detected
[    2.631356] No valid DiskOnChip devices found
[    2.631356] No valid DiskOnChip devices found
[    2.632220] [nandsim] warning: read_byte: unexpected data output cycle, =
state is STATE_READY return 0x0
[    2.632220] [nandsim] warning: read_byte: unexpected data output cycle, =
state is STATE_READY return 0x0
[    2.633947] [nandsim] warning: read_byte: unexpected data output cycle, =
state is STATE_READY return 0x0
[    2.633947] [nandsim] warning: read_byte: unexpected data output cycle, =
state is STATE_READY return 0x0
[    2.635666] [nandsim] warning: read_byte: unexpected data output cycle, =
state is STATE_READY return 0x0
[    2.635666] [nandsim] warning: read_byte: unexpected data output cycle, =
state is STATE_READY return 0x0
[    2.637392] [nandsim] warning: read_byte: unexpected data output cycle, =
state is STATE_READY return 0x0
[    2.637392] [nandsim] warning: read_byte: unexpected data output cycle, =
state is STATE_READY return 0x0
[    2.639087] [nandsim] warning: read_byte: unexpected data output cycle, =
state is STATE_READY return 0x0
[    2.639087] [nandsim] warning: read_byte: unexpected data output cycle, =
state is STATE_READY return 0x0
[    2.640899] [nandsim] warning: read_byte: unexpected data output cycle, =
state is STATE_READY return 0x0
[    2.640899] [nandsim] warning: read_byte: unexpected data output cycle, =
state is STATE_READY return 0x0
[    2.642644] nand: device found, Manufacturer ID: 0x98, Chip ID: 0x39
[    2.642644] nand: device found, Manufacturer ID: 0x98, Chip ID: 0x39
[    2.643806] nand: Toshiba NAND 128MiB 1,8V 8-bit
[    2.643806] nand: Toshiba NAND 128MiB 1,8V 8-bit
[    2.644657] nand: 128MiB, SLC, page size: 512, OOB size: 16
[    2.644657] nand: 128MiB, SLC, page size: 512, OOB size: 16
[    2.645821] flash size: 128 MiB
[    2.645821] flash size: 128 MiB
[    2.646410] page size: 512 bytes
[    2.646410] page size: 512 bytes
[    2.647003] OOB area size: 16 bytes
[    2.647003] OOB area size: 16 bytes
[    2.647649] sector size: 16 KiB
[    2.647649] sector size: 16 KiB
[    2.648229] pages number: 262144
[    2.648229] pages number: 262144
[    2.648822] pages per sector: 32
[    2.648822] pages per sector: 32
[    2.649441] bus width: 8
[    2.649441] bus width: 8
[    2.649908] bits in sector size: 14
[    2.649908] bits in sector size: 14
[    2.650631] bits in page size: 9
[    2.650631] bits in page size: 9
[    2.651230] bits in OOB size: 4
[    2.651230] bits in OOB size: 4
[    2.651801] flash size with OOB: 135168 KiB
[    2.651801] flash size with OOB: 135168 KiB
[    2.652567] page address bytes: 4
[    2.652567] page address bytes: 4
[    2.653191] sector address bytes: 3
[    2.653191] sector address bytes: 3
[    2.653831] options: 0x42
[    2.653831] options: 0x42
[    2.655402] Scanning device for bad blocks
[    2.655402] Scanning device for bad blocks
[    2.699735] Creating 1 MTD partitions on "NAND 128MiB 1,8V 8-bit":
[    2.699735] Creating 1 MTD partitions on "NAND 128MiB 1,8V 8-bit":
[    2.700965] 0x000000000000-0x000008000000 : "NAND simulator partition 0"
[    2.700965] 0x000000000000-0x000008000000 : "NAND simulator partition 0"
[    2.703348] HSI/SSI char device loaded
[    2.703348] HSI/SSI char device loaded
[    2.704058] I2O subsystem v1.325
[    2.704058] I2O subsystem v1.325
[    2.704659] i2o: max drivers =3D 8
[    2.704659] i2o: max drivers =3D 8
[    2.705981] Intel ISA PCIC probe:=20
[    2.705981] Intel ISA PCIC probe: not found.
not found.
[    2.707223] i8042: PNP: PS/2 Controller [PNP0303:KBD,PNP0f13:MOU] at 0x6=
0,0x64 irq 1,12
[    2.707223] i8042: PNP: PS/2 Controller [PNP0303:KBD,PNP0f13:MOU] at 0x6=
0,0x64 irq 1,12
[    2.709364] serio: i8042 KBD port at 0x60,0x64 irq 1
[    2.709364] serio: i8042 KBD port at 0x60,0x64 irq 1
[    2.710410] serio: i8042 AUX port at 0x60,0x64 irq 12
[    2.710410] serio: i8042 AUX port at 0x60,0x64 irq 12
[    2.712761] mk712: device not present
[    2.712761] mk712: device not present
[    2.714073] apanel: Fujitsu BIOS signature 'FJKEYINF' not found...
[    2.714073] apanel: Fujitsu BIOS signature 'FJKEYINF' not found...
[    2.715723] input: PC Speaker as /devices/platform/pcspkr/input/input1
[    2.715723] input: PC Speaker as /devices/platform/pcspkr/input/input1
[    2.716937] evbug: Connected device: input1 (PC Speaker at isa0061/input=
0)
[    2.716937] evbug: Connected device: input1 (PC Speaker at isa0061/input=
0)
[    2.718417] wistron_btns: System unknown
[    2.718417] wistron_btns: System unknown
[    2.719270] rtc_cmos 00:00: RTC can wake from S4
[    2.719270] rtc_cmos 00:00: RTC can wake from S4
[    2.720442] rtc (null): alarm rollover: day
[    2.720442] rtc (null): alarm rollover: day
[    2.721359] rtc_cmos 00:00: rtc core: registered rtc_cmos as rtc0
[    2.721359] rtc_cmos 00:00: rtc core: registered rtc_cmos as rtc0
[    2.722563] rtc_cmos 00:00: alarms up to one day, 114 bytes nvram, hpet =
irqs
[    2.722563] rtc_cmos 00:00: alarms up to one day, 114 bytes nvram, hpet =
irqs
[    2.725139] i2c /dev entries driver
[    2.725139] i2c /dev entries driver
[    2.726184] piix4_smbus 0000:00:01.3: SMBus Host Controller at 0xb100, r=
evision 0
[    2.726184] piix4_smbus 0000:00:01.3: SMBus Host Controller at 0xb100, r=
evision 0
[    2.728580] input: AT Translated Set 2 keyboard as /devices/platform/i80=
42/serio0/input/input2
[    2.728580] input: AT Translated Set 2 keyboard as /devices/platform/i80=
42/serio0/input/input2
[    2.730301] evbug: Connected device: input2 (AT Translated Set 2 keyboar=
d at isa0060/serio0/input0)
[    2.730301] evbug: Connected device: input2 (AT Translated Set 2 keyboar=
d at isa0060/serio0/input0)
[    3.024425] i2c-parport-light: adapter type unspecified
[    3.024425] i2c-parport-light: adapter type unspecified
[    3.030176] pps pps0: new PPS source ktimer
[    3.030176] pps pps0: new PPS source ktimer
[    3.030967] pps pps0: ktimer PPS source registered
[    3.030967] pps pps0: ktimer PPS source registered
[    3.031944] Driver for 1-wire Dallas network protocol.
[    3.031944] Driver for 1-wire Dallas network protocol.
[    3.033183] 1-Wire driver for the DS2760 battery monitor  chip  - (c) 20=
04-2005, Szabolcs Gyurko
[    3.033183] 1-Wire driver for the DS2760 battery monitor  chip  - (c) 20=
04-2005, Szabolcs Gyurko
[    3.369778] w83781d: Detection failed at step 2
[    3.369778] w83781d: Detection failed at step 2
[    3.415082] i2c i2c-0: Detection of w83781d chip failed at step 3
[    3.415082] i2c i2c-0: Detection of w83781d chip failed at step 3
[    3.455155] i2c i2c-0: Detection of w83781d chip failed at step 3
[    3.455155] i2c i2c-0: Detection of w83781d chip failed at step 3
[    3.504712] i2c i2c-0: Detection of w83781d chip failed at step 3
[    3.504712] i2c i2c-0: Detection of w83781d chip failed at step 3
[    3.554242] i2c i2c-0: Detection of w83781d chip failed at step 3
[    3.554242] i2c i2c-0: Detection of w83781d chip failed at step 3
[    3.594959] i2c i2c-0: Detection of w83781d chip failed at step 3
[    3.594959] i2c i2c-0: Detection of w83781d chip failed at step 3
[    3.645171] i2c i2c-0: Detection of w83781d chip failed at step 3
[    3.645171] i2c i2c-0: Detection of w83781d chip failed at step 3
[    3.694940] i2c i2c-0: Detection of w83781d chip failed at step 3
[    3.694940] i2c i2c-0: Detection of w83781d chip failed at step 3
[    3.735144] i2c i2c-0: Detection of w83781d chip failed at step 3
[    3.735144] i2c i2c-0: Detection of w83781d chip failed at step 3
[    5.005281] i2c i2c-0: detect fail: address match, 0x2c
[    5.005281] i2c i2c-0: detect fail: address match, 0x2c
[    5.045300] i2c i2c-0: detect fail: address match, 0x2d
[    5.045300] i2c i2c-0: detect fail: address match, 0x2d
[    5.095122] i2c i2c-0: detect fail: address match, 0x2e
[    5.095122] i2c i2c-0: detect fail: address match, 0x2e
[    5.145217] i2c i2c-0: detect fail: address match, 0x2f
[    5.145217] i2c i2c-0: detect fail: address match, 0x2f
[    5.185344]  (null): Wrong manufacturer ID. Got 255, expected 65
[    5.185344]  (null): Wrong manufacturer ID. Got 255, expected 65
[    5.235200]  (null): Wrong manufacturer ID. Got 255, expected 65
[    5.235200]  (null): Wrong manufacturer ID. Got 255, expected 65
[    5.285425]  (null): Wrong manufacturer ID. Got 255, expected 65
[    5.285425]  (null): Wrong manufacturer ID. Got 255, expected 65
[    5.605053] applesmc: supported laptop not found!
[    5.605053] applesmc: supported laptop not found!
[    5.605952] applesmc: driver init failed (ret=3D-19)!
[    5.605952] applesmc: driver init failed (ret=3D-19)!
[    6.405274] f71882fg: Not a Fintek device
[    6.405274] f71882fg: Not a Fintek device
[    6.406089] f71882fg: Not a Fintek device
[    6.406089] f71882fg: Not a Fintek device
[    6.752916]  (null): Unknown chip type, skipping
[    6.752916]  (null): Unknown chip type, skipping
[    6.795222]  (null): Unknown chip type, skipping
[    6.795222]  (null): Unknown chip type, skipping
[    7.810130] i2c i2c-0: Unsupported chip (man_id=3D0xFF, chip_id=3D0xFF)
[    7.810130] i2c i2c-0: Unsupported chip (man_id=3D0xFF, chip_id=3D0xFF)
[    7.960123] i2c i2c-0: Unsupported chip (man_id=3D0xFF, chip_id=3D0xFF)
[    7.960123] i2c i2c-0: Unsupported chip (man_id=3D0xFF, chip_id=3D0xFF)
[    8.110133] i2c i2c-0: Unsupported chip (man_id=3D0xFF, chip_id=3D0xFF)
[    8.110133] i2c i2c-0: Unsupported chip (man_id=3D0xFF, chip_id=3D0xFF)
[   22.451164] i2c i2c-0: LM83 detection failed at 0x18
[   22.451164] i2c i2c-0: LM83 detection failed at 0x18
[   22.491167] i2c i2c-0: LM83 detection failed at 0x19
[   22.491167] i2c i2c-0: LM83 detection failed at 0x19
[   22.531161] i2c i2c-0: LM83 detection failed at 0x1a
[   22.531161] i2c i2c-0: LM83 detection failed at 0x1a
[   22.571157] i2c i2c-0: LM83 detection failed at 0x29
[   22.571157] i2c i2c-0: LM83 detection failed at 0x29
[   22.611166] i2c i2c-0: LM83 detection failed at 0x2a
[   22.611166] i2c i2c-0: LM83 detection failed at 0x2a
[   22.651161] i2c i2c-0: LM83 detection failed at 0x2b
[   22.651161] i2c i2c-0: LM83 detection failed at 0x2b
[   22.691156] i2c i2c-0: LM83 detection failed at 0x4c
[   22.691156] i2c i2c-0: LM83 detection failed at 0x4c
[   22.731161] i2c i2c-0: LM83 detection failed at 0x4d
[   22.731161] i2c i2c-0: LM83 detection failed at 0x4d
[   22.771155] i2c i2c-0: LM83 detection failed at 0x4e
[   22.771155] i2c i2c-0: LM83 detection failed at 0x4e
[   22.831157] i2c i2c-0: Detecting device at 0x2c with COMPANY: 0xff and V=
ERSTEP: 0xff
[   22.831157] i2c i2c-0: Detecting device at 0x2c with COMPANY: 0xff and V=
ERSTEP: 0xff
[   22.832575] i2c i2c-0: Autodetection failed: unsupported version
[   22.832575] i2c i2c-0: Autodetection failed: unsupported version
[   22.891162] i2c i2c-0: Detecting device at 0x2d with COMPANY: 0xff and V=
ERSTEP: 0xff
[   22.891162] i2c i2c-0: Detecting device at 0x2d with COMPANY: 0xff and V=
ERSTEP: 0xff
[   22.892581] i2c i2c-0: Autodetection failed: unsupported version
[   22.892581] i2c i2c-0: Autodetection failed: unsupported version
[   22.951159] i2c i2c-0: Detecting device at 0x2e with COMPANY: 0xff and V=
ERSTEP: 0xff
[   22.951159] i2c i2c-0: Detecting device at 0x2e with COMPANY: 0xff and V=
ERSTEP: 0xff
[   22.952573] i2c i2c-0: Autodetection failed: unsupported version
[   22.952573] i2c i2c-0: Autodetection failed: unsupported version
[   23.051156] i2c i2c-0: Unsupported chip at 0x18 (man_id=3D0xFF, chip_id=
=3D0xFF)
[   23.051156] i2c i2c-0: Unsupported chip at 0x18 (man_id=3D0xFF, chip_id=
=3D0xFF)
[   23.151164] i2c i2c-0: Unsupported chip at 0x19 (man_id=3D0xFF, chip_id=
=3D0xFF)
[   23.151164] i2c i2c-0: Unsupported chip at 0x19 (man_id=3D0xFF, chip_id=
=3D0xFF)
[   23.251160] i2c i2c-0: Unsupported chip at 0x1a (man_id=3D0xFF, chip_id=
=3D0xFF)
[   23.251160] i2c i2c-0: Unsupported chip at 0x1a (man_id=3D0xFF, chip_id=
=3D0xFF)
[   23.351160] i2c i2c-0: Unsupported chip at 0x29 (man_id=3D0xFF, chip_id=
=3D0xFF)
[   23.351160] i2c i2c-0: Unsupported chip at 0x29 (man_id=3D0xFF, chip_id=
=3D0xFF)
[   23.451166] i2c i2c-0: Unsupported chip at 0x2a (man_id=3D0xFF, chip_id=
=3D0xFF)
[   23.451166] i2c i2c-0: Unsupported chip at 0x2a (man_id=3D0xFF, chip_id=
=3D0xFF)
[   23.551168] i2c i2c-0: Unsupported chip at 0x2b (man_id=3D0xFF, chip_id=
=3D0xFF)
[   23.551168] i2c i2c-0: Unsupported chip at 0x2b (man_id=3D0xFF, chip_id=
=3D0xFF)
[   23.651174] i2c i2c-0: Unsupported chip at 0x48 (man_id=3D0xFF, chip_id=
=3D0xFF)
[   23.651174] i2c i2c-0: Unsupported chip at 0x48 (man_id=3D0xFF, chip_id=
=3D0xFF)
[   23.751155] i2c i2c-0: Unsupported chip at 0x49 (man_id=3D0xFF, chip_id=
=3D0xFF)
[   23.751155] i2c i2c-0: Unsupported chip at 0x49 (man_id=3D0xFF, chip_id=
=3D0xFF)
[   23.851163] i2c i2c-0: Unsupported chip at 0x4a (man_id=3D0xFF, chip_id=
=3D0xFF)
[   23.851163] i2c i2c-0: Unsupported chip at 0x4a (man_id=3D0xFF, chip_id=
=3D0xFF)
[   23.951160] i2c i2c-0: Unsupported chip at 0x4b (man_id=3D0xFF, chip_id=
=3D0xFF)
[   23.951160] i2c i2c-0: Unsupported chip at 0x4b (man_id=3D0xFF, chip_id=
=3D0xFF)
[   24.051169] i2c i2c-0: Unsupported chip at 0x4c (man_id=3D0xFF, chip_id=
=3D0xFF)
[   24.051169] i2c i2c-0: Unsupported chip at 0x4c (man_id=3D0xFF, chip_id=
=3D0xFF)
[   24.151157] i2c i2c-0: Unsupported chip at 0x4d (man_id=3D0xFF, chip_id=
=3D0xFF)
[   24.151157] i2c i2c-0: Unsupported chip at 0x4d (man_id=3D0xFF, chip_id=
=3D0xFF)
[   24.251165] i2c i2c-0: Unsupported chip at 0x4e (man_id=3D0xFF, chip_id=
=3D0xFF)
[   24.251165] i2c i2c-0: Unsupported chip at 0x4e (man_id=3D0xFF, chip_id=
=3D0xFF)
[   24.351159] i2c i2c-0: Unsupported chip at 0x4f (man_id=3D0xFF, chip_id=
=3D0xFF)
[   24.351159] i2c i2c-0: Unsupported chip at 0x4f (man_id=3D0xFF, chip_id=
=3D0xFF)
[   24.871162] i2c i2c-0: MAX1619 detection failed at 0x18
[   24.871162] i2c i2c-0: MAX1619 detection failed at 0x18
[   24.951156] i2c i2c-0: MAX1619 detection failed at 0x19
[   24.951156] i2c i2c-0: MAX1619 detection failed at 0x19
[   25.031161] i2c i2c-0: MAX1619 detection failed at 0x1a
[   25.031161] i2c i2c-0: MAX1619 detection failed at 0x1a
[   25.111161] i2c i2c-0: MAX1619 detection failed at 0x29
[   25.111161] i2c i2c-0: MAX1619 detection failed at 0x29
[   25.191157] i2c i2c-0: MAX1619 detection failed at 0x2a
[   25.191157] i2c i2c-0: MAX1619 detection failed at 0x2a
[   25.271159] i2c i2c-0: MAX1619 detection failed at 0x2b
[   25.271159] i2c i2c-0: MAX1619 detection failed at 0x2b
[   25.351163] i2c i2c-0: MAX1619 detection failed at 0x4c
[   25.351163] i2c i2c-0: MAX1619 detection failed at 0x4c
[   25.431157] i2c i2c-0: MAX1619 detection failed at 0x4d
[   25.431157] i2c i2c-0: MAX1619 detection failed at 0x4d
[   25.511157] i2c i2c-0: MAX1619 detection failed at 0x4e
[   25.511157] i2c i2c-0: MAX1619 detection failed at 0x4e
[   26.371405] pc87360: PC8736x not detected, module not inserted
[   26.371405] pc87360: PC8736x not detected, module not inserted
[   26.372518] sch56xx_common: Unsupported device id: 0xff
[   26.372518] sch56xx_common: Unsupported device id: 0xff
[   26.373498] sch56xx_common: Unsupported device id: 0xff
[   26.373498] sch56xx_common: Unsupported device id: 0xff
[   26.431161] i2c i2c-0: SMSC47M192 detection failed at 0x2c
[   26.431161] i2c i2c-0: SMSC47M192 detection failed at 0x2c
[   26.491159] i2c i2c-0: SMSC47M192 detection failed at 0x2d
[   26.491159] i2c i2c-0: SMSC47M192 detection failed at 0x2d
[   26.511174] i2c i2c-0: amc6821_detect called.
[   26.511174] i2c i2c-0: amc6821_detect called.
[   26.551163] i2c i2c-0: amc6821: detection failed at 0x18.
[   26.551163] i2c i2c-0: amc6821: detection failed at 0x18.
[   26.571172] i2c i2c-0: amc6821_detect called.
[   26.571172] i2c i2c-0: amc6821_detect called.
[   26.611159] i2c i2c-0: amc6821: detection failed at 0x19.
[   26.611159] i2c i2c-0: amc6821: detection failed at 0x19.
[   26.631174] i2c i2c-0: amc6821_detect called.
[   26.631174] i2c i2c-0: amc6821_detect called.
[   26.671158] i2c i2c-0: amc6821: detection failed at 0x1a.
[   26.671158] i2c i2c-0: amc6821: detection failed at 0x1a.
[   26.691164] i2c i2c-0: amc6821_detect called.
[   26.691164] i2c i2c-0: amc6821_detect called.
[   26.731166] i2c i2c-0: amc6821: detection failed at 0x2c.
[   26.731166] i2c i2c-0: amc6821: detection failed at 0x2c.
[   26.751169] i2c i2c-0: amc6821_detect called.
[   26.751169] i2c i2c-0: amc6821_detect called.
[   26.791163] i2c i2c-0: amc6821: detection failed at 0x2d.
[   26.791163] i2c i2c-0: amc6821: detection failed at 0x2d.
[   26.811172] i2c i2c-0: amc6821_detect called.
[   26.811172] i2c i2c-0: amc6821_detect called.
[   26.851159] i2c i2c-0: amc6821: detection failed at 0x2e.
[   26.851159] i2c i2c-0: amc6821: detection failed at 0x2e.
[   26.871175] i2c i2c-0: amc6821_detect called.
[   26.871175] i2c i2c-0: amc6821_detect called.
[   26.911162] i2c i2c-0: amc6821: detection failed at 0x4c.
[   26.911162] i2c i2c-0: amc6821: detection failed at 0x4c.
[   26.931170] i2c i2c-0: amc6821_detect called.
[   26.931170] i2c i2c-0: amc6821_detect called.
[   26.971158] i2c i2c-0: amc6821: detection failed at 0x4d.
[   26.971158] i2c i2c-0: amc6821: detection failed at 0x4d.
[   26.991170] i2c i2c-0: amc6821_detect called.
[   26.991170] i2c i2c-0: amc6821_detect called.
[   27.031170] i2c i2c-0: amc6821: detection failed at 0x4e.
[   27.031170] i2c i2c-0: amc6821: detection failed at 0x4e.
[   27.051171] thmc50: Probing for THMC50 at 0x2C on bus 0
[   27.051171] thmc50: Probing for THMC50 at 0x2C on bus 0
[   27.131153] thmc50: Probing for THMC50 at 0x2D on bus 0
[   27.131153] thmc50: Probing for THMC50 at 0x2D on bus 0
[   27.211159] thmc50: Probing for THMC50 at 0x2E on bus 0
[   27.211159] thmc50: Probing for THMC50 at 0x2E on bus 0
[   27.391257] intel_powerclamp: Intel powerclamp does not run on family 15=
 model 6
[   27.391257] intel_powerclamp: Intel powerclamp does not run on family 15=
 model 6
[   27.392748] alim7101_wdt: Steve Hill <steve@navaho.co.uk>
[   27.392748] alim7101_wdt: Steve Hill <steve@navaho.co.uk>
[   27.393748] alim7101_wdt: ALi M7101 PMU not present - WDT not set
[   27.393748] alim7101_wdt: ALi M7101 PMU not present - WDT not set
[   27.394862] sp5100_tco: SP5100/SB800 TCO WatchDog Timer Driver v0.05
[   27.394862] sp5100_tco: SP5100/SB800 TCO WatchDog Timer Driver v0.05
[   27.396211] ib700wdt: WDT driver for IB700 single board computer initial=
ising
[   27.396211] ib700wdt: WDT driver for IB700 single board computer initial=
ising
[   27.397787] wafer5823wdt: WDT driver for Wafer 5823 single board compute=
r initialising
[   27.397787] wafer5823wdt: WDT driver for Wafer 5823 single board compute=
r initialising
[   27.399257] wafer5823wdt: I/O address 0x0443 already in use
[   27.399257] wafer5823wdt: I/O address 0x0443 already in use
[   27.400387] i6300esb: Intel 6300ESB WatchDog Timer Driver v0.05
[   27.400387] i6300esb: Intel 6300ESB WatchDog Timer Driver v0.05
[   27.401632] i6300esb: cannot register miscdev on minor=3D130 (err=3D-16)
[   27.401632] i6300esb: cannot register miscdev on minor=3D130 (err=3D-16)
[   27.402826] i6300ESB timer: probe of 0000:00:04.0 failed with error -16
[   27.402826] i6300ESB timer: probe of 0000:00:04.0 failed with error -16
[   27.404069] iTCO_wdt: Intel TCO WatchDog Timer Driver v1.10
[   27.404069] iTCO_wdt: Intel TCO WatchDog Timer Driver v1.10
[   27.405203] sc1200wdt: build 20020303
[   27.405203] sc1200wdt: build 20020303
[   27.405932] sc1200wdt: io parameter must be specified
[   27.405932] sc1200wdt: io parameter must be specified
[   27.406897] nv_tco: NV TCO WatchDog Timer Driver v0.01
[   27.406897] nv_tco: NV TCO WatchDog Timer Driver v0.01
[   27.408026] cpu5wdt: misc_register failed
[   27.408026] cpu5wdt: misc_register failed
[   27.408801] smsc37b787_wdt: SMsC 37B787 watchdog component driver 1.1 in=
itialising...
[   27.408801] smsc37b787_wdt: SMsC 37B787 watchdog component driver 1.1 in=
itialising...
[   27.411369] smsc37b787_wdt: Unable to register miscdev on minor 130
[   27.411369] smsc37b787_wdt: Unable to register miscdev on minor 130
[   27.412561] w83697ug_wdt: WDT driver for the Winbond(TM) W83697UG/UF Sup=
er I/O chip initialising
[   27.412561] w83697ug_wdt: WDT driver for the Winbond(TM) W83697UG/UF Sup=
er I/O chip initialising
[   27.414186] w83697ug_wdt: No W83697UG/UF could be found
[   27.414186] w83697ug_wdt: No W83697UG/UF could be found
[   27.415148] w83877f_wdt: I/O address 0x0443 already in use
[   27.415148] w83877f_wdt: I/O address 0x0443 already in use
[   27.416153] sbc_epx_c3: cannot register miscdev on minor=3D130 (err=3D-1=
6)
[   27.416153] sbc_epx_c3: cannot register miscdev on minor=3D130 (err=3D-1=
6)
[   27.417462] watchdog: Software Watchdog: cannot register miscdev on mino=
r=3D130 (err=3D-16).
[   27.417462] watchdog: Software Watchdog: cannot register miscdev on mino=
r=3D130 (err=3D-16).
[   27.418962] watchdog: Software Watchdog: a legacy watchdog module is pro=
bably present.
[   27.418962] watchdog: Software Watchdog: a legacy watchdog module is pro=
bably present.
[   27.420612] softdog: Software Watchdog Timer: 0.08 initialized. soft_nob=
oot=3D0 soft_margin=3D60 sec soft_panic=3D0 (nowayout=3D1)
[   27.420612] softdog: Software Watchdog Timer: 0.08 initialized. soft_nob=
oot=3D0 soft_margin=3D60 sec soft_panic=3D0 (nowayout=3D1)
[   27.423599] leds_ss4200: no LED devices found
[   27.423599] leds_ss4200: no LED devices found
[   33.450161]  (null): enodev DEV ADDR =3D 0xFF
[   33.450161]  (null): enodev DEV ADDR =3D 0xFF
[   33.451063] ledtrig-cpu: registered to indicate activity on CPUs
[   33.451063] ledtrig-cpu: registered to indicate activity on CPUs
[   33.452661] hidraw: raw HID events driver (C) Jiri Kosina
[   33.452661] hidraw: raw HID events driver (C) Jiri Kosina
[   33.456387] Loading crystalhd 0.9.27
[   33.456387] Loading crystalhd 0.9.27
[   33.457665] dell_wmi: No known WMI GUID found
[   33.457665] dell_wmi: No known WMI GUID found
[   33.458475] dell_wmi_aio: No known WMI GUID found
[   33.458475] dell_wmi_aio: No known WMI GUID found
[   33.459332] acerhdf: Acer Aspire One Fan driver, v.0.5.26
[   33.459332] acerhdf: Acer Aspire One Fan driver, v.0.5.26
[   33.460401] acerhdf: unknown (unsupported) BIOS version Bochs/Bochs/Boch=
s, please report, aborting!
[   33.460401] acerhdf: unknown (unsupported) BIOS version Bochs/Bochs/Boch=
s, please report, aborting!
[   33.462114] Initializing HPQ6001 module
[   33.462114] Initializing HPQ6001 module
[   33.462902] hdaps: supported laptop not found!
[   33.462902] hdaps: supported laptop not found!
[   33.463722] hdaps: driver init failed (ret=3D-19)!
[   33.463722] hdaps: driver init failed (ret=3D-19)!
[   33.464619] msi_wmi: This machine doesn't have neither MSI-hotkeys nor b=
acklight through WMI
[   33.464619] msi_wmi: This machine doesn't have neither MSI-hotkeys nor b=
acklight through WMI
[   33.468366] intel_rapl: driver does not support CPU family 15 model 6
[   33.468366] intel_rapl: driver does not support CPU family 15 model 6
[   33.469575] oprofile: using timer interrupt.
[   33.469575] oprofile: using timer interrupt.
[   33.471202] bootconsole [earlyser0] disabled
[   33.471202] bootconsole [earlyser0] disabled
[   33.472467] cryptomgr_probe (85) used greatest stack depth: 6912 bytes l=
eft
[   33.473190] Key type trusted registered
[   33.473698] Key type encrypted registered
[   33.475030] rtc_cmos 00:00: setting system clock to 2014-03-20 09:36:05 =
UTC (1395308165)
[   33.476929] Freeing unused kernel memory: 564K (81c46000 - 81cd3000)
mount: mounting proc on /proc failed: No such device
/etc/rcS.d/S00fbsetup: line 3: /sbin/modprobe: No such file or directory
[   33.492659] S00fbsetup (98) used greatest stack depth: 6816 bytes left

Please wait: booting...
mount: mounting proc on /proc failed: No such device
grep: /proc/filesystems: No such file or directory
Starting Bootlog daemon: bootlogd: cannot allocate pseudo tty: No such file=
 or directory
bootlogd.
mount: can't read '/proc/mounts': No such file or directory
/etc/rcS.d/S37populate-volatile.sh: line 172: /proc/cmdline: No such file o=
r directory
grep: /proc/filesystems: No such file or directory
Configuring network interfaces... ifconfig: socket: Address family not supp=
orted by protocol
ifup: can't open '/var/run/ifstate': No such file or directory
done.
hwclock: can't open '/dev/misc/rtc': No such file or directory
Running postinst /etc/rpm-postinsts/100...
[   33.582851] init (94) used greatest stack depth: 6768 bytes left
mount: no /proc/mounts
wfg: skip syslogd
Kernel tests: Boot OK!
Kernel tests: Boot OK!
mount: mounting proc on /proc failed: No such device
/etc/rc5.d/S99-rc.local: line 19: /proc/167/oom_score_adj: No such file or =
directory
sed: /lib/modules/3.14.0-rc7-wl-ath-04519-g2d18516/modules.dep: No such fil=
e or directory
xargs: modprobe: No such file or directory
run-parts: /etc/kernel-tests/01-modprobe exited with code 127
grep: /proc/cmdline: No such file or directory
grep: /proc/cmdline: No such file or directory
Trinity v1.4pre  Dave Jones <davej@redhat.com>
[   33.621989] random: trinity urandom read with 59 bits of entropy availab=
le
[init] Marking syscall get_robust_list (312) as to be disabled.
Done parsing arguments.
Marking all syscalls as enabled.
[init] Disabling syscalls marked as disabled by command line options
[init] Marked syscall get_robust_list (312) as deactivated.
[init] Enabled 350 syscalls. Disabled 1 syscalls.
DANGER: RUNNING AS ROOT.
Unless you are running in a virtual machine, this could cause serious probl=
ems such as overwriting CMOS
or similar which could potentially make this machine unbootable without a f=
irmware reset.

ctrl-c now unless you really know what you are doing.
Done parsing arguments.
Marking all syscalls as enabled.
Trinity v1.4pre  Dave Jones <davej@redhat.com>
Done parsing arguments.
## couldn't open logfile trinity.log
Trinity v1.4pre  Dave Jones <davej@redhat.com>
[init] Marking syscall get_robust_list (312) as to be disabled.
Done parsing arguments.
## couldn't open logfile trinity.log
[init] Enabled 351 syscalls. Disabled 0 syscalls.
DANGER: RUNNING AS ROOT.
Unless you are running in a virtual machine, this could cause serious probl=
ems such as overwriting CMOS
or similar which could potentially make this machine unbootable without a f=
irmware reset.

ctrl-c now unless you really know what you are doing.
Couldn't read pid_max from proc
[init] Using pid_max =3D 32768
[init] Kernel was tainted on startup. Will ignore flags that are already se=
t.
[init] Started watchdog process, PID is 185
fopen: No such file or directory
Couldn't read pid_max from proc
[init] Using pid_max =3D 32768
[init] Kernel was tainted on startup. Will ignore flags that are already se=
t.
[init] Started watchdog process, PID is 187
[main] Main thread is alive.
[main] Couldn't find socket cachefile. Regenerating.
fcntl F_SETLKW: Permission denied
[main] Main thread is alive.
fcntl F_SETLKW: Permission denied
[   89.530210] random: nonblocking pool is initialized
lsmod: can't open '/proc/modules': No such file or directory
BusyBox v1.19.4 (2012-04-22 09:22:10 PDT) multi-call binary.

Usage: rmmod [-wfa] [MODULE]...

lsmod: can't open '/proc/modules': No such file or directory
BusyBox v1.19.4 (2012-04-22 09:22:10 PDT) multi-call binary.

Usage: rmmod [-wfa] [MODULE]...

lsmod: can't open '/proc/modules': No such file or directory
BusyBox v1.19.4 (2012-04-22 09:22:10 PDT) multi-call binary.

Usage: rmmod [-wfa] [MODULE]...

run-parts: /etc/kernel-tests/99-rmmod exited with code 123
shutdown: warning: cannot open /var/run/shutdown.pid
[   93.655072] trinity (181) used greatest stack depth: 6660 bytes left
mount: no /proc/mounts
wfg: skip syslogd
sed: /proc/mounts: No such file or directory
sed: /proc/mounts: No such file or directory
sed: /proc/mounts: No such file or directory
Deconfiguring network interfaces... ifdown: interface lo not configured
done.
Sending all processes the TERM signal...
mount: mounting proc on /proc failed: No such device
Sending all processes the KILL signal...
mount: mounting proc on /proc failed: No such device
Unmounting remote filesystems...
Deactivating swap...
Unmounting local filesystems...
grep: /proc/mounts: No such file or directory
mount: can't read '/proc/mounts': No such file or directory
Rebooting...=20
[  101.733213] Unregister pv shared memory for cpu 0
[  101.735129] reboot: Restarting system
[  101.735607] reboot: machine restart
Elapsed time: 105
qemu-system-x86_64 -cpu kvm64 -enable-kvm -kernel /kernel/i386-randconfig-n=
h0-03200538/2d1851652373730f6b8c7fa7f45eaa854f23da8f/vmlinuz-3.14.0-rc7-wl-=
ath-04519-g2d18516 -append 'hung_task_panic=3D1 earlyprintk=3DttyS0,115200 =
debug apic=3Ddebug sysrq_always_enabled rcupdate.rcu_cpu_stall_timeout=3D10=
0 panic=3D10 softlockup_panic=3D1 nmi_watchdog=3Dpanic  prompt_ramdisk=3D0 =
console=3DttyS0,115200 console=3Dtty0 vga=3Dnormal  root=3D/dev/ram0 rw lin=
k=3D/kernel-tests/run-queue/kvm/i386-randconfig-nh0-03200538/linux-devel:de=
vel-hourly-2014032007/.vmlinuz-2d1851652373730f6b8c7fa7f45eaa854f23da8f-201=
40320093404-6-ivytown2 branch=3Dlinux-devel/devel-hourly-2014032007 BOOT_IM=
AGE=3D/kernel/i386-randconfig-nh0-03200538/2d1851652373730f6b8c7fa7f45eaa85=
4f23da8f/vmlinuz-3.14.0-rc7-wl-ath-04519-g2d18516 drbd.minor_count=3D8'  -i=
nitrd /kernel-tests/initrd/yocto-minimal-i386.cgz -m 320 -smp 2 -net nic,vl=
an=3D1,model=3De1000 -net user,vlan=3D1,hostfwd=3Dtcp::18629-:22 -boot orde=
r=3Dnc -no-reboot -watchdog i6300esb -rtc base=3Dlocaltime -pidfile /dev/sh=
m/kboot/pid-yocto-ivytown2-15 -serial file:/dev/shm/kboot/serial-yocto-ivyt=
own2-15 -daemonize -display none -monitor null=20

--zYM0uCDKw75PZbzx
Content-Type: application/octet-stream
Content-Disposition: attachment; filename="i386-randconfig-nh0-03200538-2d1851652373730f6b8c7fa7f45eaa854f23da8f-kernel_init_freeable+-x-74102.log"
Content-Transfer-Encoding: base64

Z2l0IGNoZWNrb3V0IGRjYjk5ZmQ5YjA4Y2ZlMWFmZTQyNmFmNGQ4ZDNjYmM0MjkxOTBmMTUK
bHMgLWEgL2tlcm5lbC10ZXN0cy9ydW4tcXVldWUva3ZtL2kzODYtcmFuZGNvbmZpZy1uaDAt
MDMyMDA1MzgvbGludXgtZGV2ZWw6ZGV2ZWwtaG91cmx5LTIwMTQwMzIwMDc6ZGNiOTlmZDli
MDhjZmUxYWZlNDI2YWY0ZDhkM2NiYzQyOTE5MGYxNTpiaXNlY3QtbGludXg3CgoyMDE0LTAz
LTIwLTExOjAwOjU0IGRjYjk5ZmQ5YjA4Y2ZlMWFmZTQyNmFmNGQ4ZDNjYmM0MjkxOTBmMTUg
Y29tcGlsaW5nClF1ZXVlZCBidWlsZCB0YXNrIHRvIC9rZXJuZWwtdGVzdHMvYnVpbGQtcXVl
dWUvaTM4Ni1yYW5kY29uZmlnLW5oMC0wMzIwMDUzOC1kY2I5OWZkOWIwOGNmZTFhZmU0MjZh
ZjRkOGQzY2JjNDI5MTkwZjE1CkNoZWNrIGZvciBrZXJuZWwgaW4gL2tlcm5lbC9pMzg2LXJh
bmRjb25maWctbmgwLTAzMjAwNTM4L2RjYjk5ZmQ5YjA4Y2ZlMWFmZTQyNmFmNGQ4ZDNjYmM0
MjkxOTBmMTUKd2FpdGluZyBmb3IgY29tcGxldGlvbiBvZiAva2VybmVsLXRlc3RzL2J1aWxk
LXF1ZXVlL2kzODYtcmFuZGNvbmZpZy1uaDAtMDMyMDA1MzgtZGNiOTlmZDliMDhjZmUxYWZl
NDI2YWY0ZDhkM2NiYzQyOTE5MGYxNQp3YWl0aW5nIGZvciBjb21wbGV0aW9uIG9mIC9rZXJu
ZWwtdGVzdHMvYnVpbGQtcXVldWUvLmkzODYtcmFuZGNvbmZpZy1uaDAtMDMyMDA1MzgtZGNi
OTlmZDliMDhjZmUxYWZlNDI2YWY0ZDhkM2NiYzQyOTE5MGYxNQprZXJuZWw6IC9rZXJuZWwv
aTM4Ni1yYW5kY29uZmlnLW5oMC0wMzIwMDUzOC9kY2I5OWZkOWIwOGNmZTFhZmU0MjZhZjRk
OGQzY2JjNDI5MTkwZjE1L3ZtbGludXotMy4xNC4wLXJjNwoKMjAxNC0wMy0yMC0xMTo0MDo1
NCBkZXRlY3RpbmcgYm9vdCBzdGF0ZSAuLgkxNAkxOCBTVUNDRVNTCgpiaXNlY3Q6IGdvb2Qg
Y29tbWl0IGRjYjk5ZmQ5YjA4Y2ZlMWFmZTQyNmFmNGQ4ZDNjYmM0MjkxOTBmMTUKZ2l0IGJp
c2VjdCBzdGFydCAyZDE4NTE2NTIzNzM3MzBmNmI4YzdmYTdmNDVlYWE4NTRmMjNkYThmIGRj
Yjk5ZmQ5YjA4Y2ZlMWFmZTQyNmFmNGQ4ZDNjYmM0MjkxOTBmMTUgLS0KL2Mva2VybmVsLXRl
c3RzL2xpbmVhci1iaXNlY3Q6IFsiLWIiLCAiMmQxODUxNjUyMzczNzMwZjZiOGM3ZmE3ZjQ1
ZWFhODU0ZjIzZGE4ZiIsICItZyIsICJkY2I5OWZkOWIwOGNmZTFhZmU0MjZhZjRkOGQzY2Jj
NDI5MTkwZjE1IiwgIi9jL2tlcm5lbC10ZXN0cy9iaXNlY3QtdGVzdC1ib290LWZhaWx1cmUu
c2giLCAiL2tlcm5lbC10ZXN0cy9saW51eDcvb2JqLWJpc2VjdCJdCkJpc2VjdGluZzogNDUx
OSByZXZpc2lvbnMgbGVmdCB0byB0ZXN0IGFmdGVyIHRoaXMgKHJvdWdobHkgMTMgc3RlcHMp
Cls4MjIwMmY5NTE0ODA2NWQ3YTBmNWQ4NmQ0ZDZlMzlmMzFkYmQ3OTM3XSBNZXJnZSAnYXNv
Yy9maXgvY3M0Mmw1MScgaW50byBkZXZlbC1ob3VybHktMjAxNDAzMjAwNwpydW5uaW5nIC9j
L2tlcm5lbC10ZXN0cy9iaXNlY3QtdGVzdC1ib290LWZhaWx1cmUuc2ggL2tlcm5lbC10ZXN0
cy9saW51eDcvb2JqLWJpc2VjdApscyAtYSAva2VybmVsLXRlc3RzL3J1bi1xdWV1ZS9rdm0v
aTM4Ni1yYW5kY29uZmlnLW5oMC0wMzIwMDUzOC9saW51eC1kZXZlbDpkZXZlbC1ob3VybHkt
MjAxNDAzMjAwNzo4MjIwMmY5NTE0ODA2NWQ3YTBmNWQ4NmQ0ZDZlMzlmMzFkYmQ3OTM3OmJp
c2VjdC1saW51eDcKCjIwMTQtMDMtMjAtMTE6NDI6NTcgODIyMDJmOTUxNDgwNjVkN2EwZjVk
ODZkNGQ2ZTM5ZjMxZGJkNzkzNyBjb21waWxpbmcKUXVldWVkIGJ1aWxkIHRhc2sgdG8gL2tl
cm5lbC10ZXN0cy9idWlsZC1xdWV1ZS9pMzg2LXJhbmRjb25maWctbmgwLTAzMjAwNTM4LTgy
MjAyZjk1MTQ4MDY1ZDdhMGY1ZDg2ZDRkNmUzOWYzMWRiZDc5MzcKQ2hlY2sgZm9yIGtlcm5l
bCBpbiAva2VybmVsL2kzODYtcmFuZGNvbmZpZy1uaDAtMDMyMDA1MzgvODIyMDJmOTUxNDgw
NjVkN2EwZjVkODZkNGQ2ZTM5ZjMxZGJkNzkzNwp3YWl0aW5nIGZvciBjb21wbGV0aW9uIG9m
IC9rZXJuZWwtdGVzdHMvYnVpbGQtcXVldWUvaTM4Ni1yYW5kY29uZmlnLW5oMC0wMzIwMDUz
OC04MjIwMmY5NTE0ODA2NWQ3YTBmNWQ4NmQ0ZDZlMzlmMzFkYmQ3OTM3CndhaXRpbmcgZm9y
IGNvbXBsZXRpb24gb2YgL2tlcm5lbC10ZXN0cy9idWlsZC1xdWV1ZS8uaTM4Ni1yYW5kY29u
ZmlnLW5oMC0wMzIwMDUzOC04MjIwMmY5NTE0ODA2NWQ3YTBmNWQ4NmQ0ZDZlMzlmMzFkYmQ3
OTM3Cmtlcm5lbDogL2tlcm5lbC9pMzg2LXJhbmRjb25maWctbmgwLTAzMjAwNTM4LzgyMjAy
Zjk1MTQ4MDY1ZDdhMGY1ZDg2ZDRkNmUzOWYzMWRiZDc5Mzcvdm1saW51ei0zLjE0LjAtcmM3
LXdsLWF0aC0wMzQxOC1nODIyMDJmOQoKMjAxNC0wMy0yMC0xMjoxNzo1NyBkZXRlY3Rpbmcg
Ym9vdCBzdGF0ZSAuLi4gVEVTVCBGQUlMVVJFClsgICAgMy4zNzgyMzJdIFtUVE1dIEluaXRp
YWxpemluZyBwb29sIGFsbG9jYXRvcgpbICAgIDMuMzc5NzE3XSAtLS0tLS0tLS0tLS1bIGN1
dCBoZXJlIF0tLS0tLS0tLS0tLS0KWyAgICAzLjM3OTcxN10gLS0tLS0tLS0tLS0tWyBjdXQg
aGVyZSBdLS0tLS0tLS0tLS0tClsgICAgMy4zODExMzZdIFdBUk5JTkc6IENQVTogMCBQSUQ6
IDEgYXQgZHJpdmVycy9ncHUvZHJtL2RybV9jcnRjLmM6OTQgZHJtX3dhcm5fb25fbW9kZXNl
dF9ub3RfYWxsX2xvY2tlZCsweDYxLzB4YzYoKQova2VybmVsL2kzODYtcmFuZGNvbmZpZy1u
aDAtMDMyMDA1MzgvODIyMDJmOTUxNDgwNjVkN2EwZjVkODZkNGQ2ZTM5ZjMxZGJkNzkzNy9k
bWVzZy1xdWFudGFsLWl2eXRvd24yLTk6MjAxNDAzMjAxMjE5MDM6aTM4Ni1yYW5kY29uZmln
LW5oMC0wMzIwMDUzODozLjE0LjAtcmM3LXdsLWF0aC0wMzQxOC1nODIyMDJmOToxCi9rZXJu
ZWwvaTM4Ni1yYW5kY29uZmlnLW5oMC0wMzIwMDUzOC84MjIwMmY5NTE0ODA2NWQ3YTBmNWQ4
NmQ0ZDZlMzlmMzFkYmQ3OTM3L2RtZXNnLXlvY3RvLXhwcy0yOjIwMTQwMzIwMTIxODU3Omkz
ODYtcmFuZGNvbmZpZy1uaDAtMDMyMDA1Mzg6My4xNC4wLXJjNy13bC1hdGgtMDM0MTgtZzgy
MjAyZjk6MQova2VybmVsL2kzODYtcmFuZGNvbmZpZy1uaDAtMDMyMDA1MzgvODIyMDJmOTUx
NDgwNjVkN2EwZjVkODZkNGQ2ZTM5ZjMxZGJkNzkzNy9kbWVzZy15b2N0by1pdnl0b3duMi0x
OjIwMTQwMzIwMTIxOTA1OmkzODYtcmFuZGNvbmZpZy1uaDAtMDMyMDA1Mzg6My4xNC4wLXJj
Ny13bC1hdGgtMDM0MTgtZzgyMjAyZjk6MQova2VybmVsL2kzODYtcmFuZGNvbmZpZy1uaDAt
MDMyMDA1MzgvODIyMDJmOTUxNDgwNjVkN2EwZjVkODZkNGQ2ZTM5ZjMxZGJkNzkzNy9kbWVz
Zy15b2N0by1pdnl0b3duMi0yNzoyMDE0MDMyMDEyMTkwNDppMzg2LXJhbmRjb25maWctbmgw
LTAzMjAwNTM4OjMuMTQuMC1yYzctd2wtYXRoLTAzNDE4LWc4MjIwMmY5OjEKL2tlcm5lbC9p
Mzg2LXJhbmRjb25maWctbmgwLTAzMjAwNTM4LzgyMjAyZjk1MTQ4MDY1ZDdhMGY1ZDg2ZDRk
NmUzOWYzMWRiZDc5MzcvZG1lc2ctcXVhbnRhbC1pdnl0b3duMi0xMzoyMDE0MDMyMDEyMTkx
NDppMzg2LXJhbmRjb25maWctbmgwLTAzMjAwNTM4OjMuMTQuMC1yYzctd2wtYXRoLTAzNDE4
LWc4MjIwMmY5OjEKL2tlcm5lbC9pMzg2LXJhbmRjb25maWctbmgwLTAzMjAwNTM4LzgyMjAy
Zjk1MTQ4MDY1ZDdhMGY1ZDg2ZDRkNmUzOWYzMWRiZDc5MzcvZG1lc2ctcXVhbnRhbC14cHMt
MToyMDE0MDMyMDEyMTkxNDppMzg2LXJhbmRjb25maWctbmgwLTAzMjAwNTM4OjMuMTQuMC1y
Yzctd2wtYXRoLTAzNDE4LWc4MjIwMmY5OjEKL2tlcm5lbC9pMzg2LXJhbmRjb25maWctbmgw
LTAzMjAwNTM4LzgyMjAyZjk1MTQ4MDY1ZDdhMGY1ZDg2ZDRkNmUzOWYzMWRiZDc5MzcvZG1l
c2cteW9jdG8taXZ5dG93bjItMTQ6MjAxNDAzMjAxMjE5MDg6aTM4Ni1yYW5kY29uZmlnLW5o
MC0wMzIwMDUzODozLjE0LjAtcmM3LXdsLWF0aC0wMzQxOC1nODIyMDJmOToxCi9rZXJuZWwv
aTM4Ni1yYW5kY29uZmlnLW5oMC0wMzIwMDUzOC84MjIwMmY5NTE0ODA2NWQ3YTBmNWQ4NmQ0
ZDZlMzlmMzFkYmQ3OTM3L2RtZXNnLXF1YW50YWwteHBzLTU6MjAxNDAzMjAxMjE5MTc6aTM4
Ni1yYW5kY29uZmlnLW5oMC0wMzIwMDUzODozLjE0LjAtcmM3LXdsLWF0aC0wMzQxOC1nODIy
MDJmOToxCi9rZXJuZWwvaTM4Ni1yYW5kY29uZmlnLW5oMC0wMzIwMDUzOC84MjIwMmY5NTE0
ODA2NWQ3YTBmNWQ4NmQ0ZDZlMzlmMzFkYmQ3OTM3L2RtZXNnLXlvY3RvLXhwcy0zOjIwMTQw
MzIwMTIxOTE3OmkzODYtcmFuZGNvbmZpZy1uaDAtMDMyMDA1Mzg6My4xNC4wLXJjNy13bC1h
dGgtMDM0MTgtZzgyMjAyZjk6MQova2VybmVsL2kzODYtcmFuZGNvbmZpZy1uaDAtMDMyMDA1
MzgvODIyMDJmOTUxNDgwNjVkN2EwZjVkODZkNGQ2ZTM5ZjMxZGJkNzkzNy9kbWVzZy1xdWFu
dGFsLWl2eXRvd24yLTE0OjIwMTQwMzIwMTIxOTE4OmkzODYtcmFuZGNvbmZpZy1uaDAtMDMy
MDA1Mzg6My4xNC4wLXJjNy13bC1hdGgtMDM0MTgtZzgyMjAyZjk6MQowOjEwOjEwIGFsbF9n
b29kOmJhZDphbGxfYmFkIGJvb3RzChtbMTszNW0yMDE0LTAzLTIwIDEyOjE5OjI4IFJFUEVB
VCBDT1VOVDogMjAgICMgL2tlcm5lbC10ZXN0cy9saW51eDcvb2JqLWJpc2VjdC8ucmVwZWF0
G1swbQoKQmlzZWN0aW5nOiAzNDE4IHJldmlzaW9ucyBsZWZ0IHRvIHRlc3QgYWZ0ZXIgdGhp
cyAocm91Z2hseSAxMiBzdGVwcykKWzkxMTVlMGIzMjE4YmQ2Yjk3ZTgzMGJjMzZlNmU4MGM0
ODkwZjZmZTRdIE1lcmdlICdzY3NpL21pc2MnIGludG8gZGV2ZWwtaG91cmx5LTIwMTQwMzIw
MDcKcnVubmluZyAvYy9rZXJuZWwtdGVzdHMvYmlzZWN0LXRlc3QtYm9vdC1mYWlsdXJlLnNo
IC9rZXJuZWwtdGVzdHMvbGludXg3L29iai1iaXNlY3QKbHMgLWEgL2tlcm5lbC10ZXN0cy9y
dW4tcXVldWUva3ZtL2kzODYtcmFuZGNvbmZpZy1uaDAtMDMyMDA1MzgvbGludXgtZGV2ZWw6
ZGV2ZWwtaG91cmx5LTIwMTQwMzIwMDc6OTExNWUwYjMyMThiZDZiOTdlODMwYmMzNmU2ZTgw
YzQ4OTBmNmZlNDpiaXNlY3QtbGludXg3CgoyMDE0LTAzLTIwLTEyOjE5OjI5IDkxMTVlMGIz
MjE4YmQ2Yjk3ZTgzMGJjMzZlNmU4MGM0ODkwZjZmZTQgY29tcGlsaW5nClF1ZXVlZCBidWls
ZCB0YXNrIHRvIC9rZXJuZWwtdGVzdHMvYnVpbGQtcXVldWUvaTM4Ni1yYW5kY29uZmlnLW5o
MC0wMzIwMDUzOC05MTE1ZTBiMzIxOGJkNmI5N2U4MzBiYzM2ZTZlODBjNDg5MGY2ZmU0CkNo
ZWNrIGZvciBrZXJuZWwgaW4gL2tlcm5lbC9pMzg2LXJhbmRjb25maWctbmgwLTAzMjAwNTM4
LzkxMTVlMGIzMjE4YmQ2Yjk3ZTgzMGJjMzZlNmU4MGM0ODkwZjZmZTQKd2FpdGluZyBmb3Ig
Y29tcGxldGlvbiBvZiAva2VybmVsLXRlc3RzL2J1aWxkLXF1ZXVlL2kzODYtcmFuZGNvbmZp
Zy1uaDAtMDMyMDA1MzgtOTExNWUwYjMyMThiZDZiOTdlODMwYmMzNmU2ZTgwYzQ4OTBmNmZl
NAp3YWl0aW5nIGZvciBjb21wbGV0aW9uIG9mIC9rZXJuZWwtdGVzdHMvYnVpbGQtcXVldWUv
LmkzODYtcmFuZGNvbmZpZy1uaDAtMDMyMDA1MzgtOTExNWUwYjMyMThiZDZiOTdlODMwYmMz
NmU2ZTgwYzQ4OTBmNmZlNAprZXJuZWw6IC9rZXJuZWwvaTM4Ni1yYW5kY29uZmlnLW5oMC0w
MzIwMDUzOC85MTE1ZTBiMzIxOGJkNmI5N2U4MzBiYzM2ZTZlODBjNDg5MGY2ZmU0L3ZtbGlu
dXotMy4xNC4wLXJjNy13bC1hdGgtMDE3NzAtZzkxMTVlMGIKCjIwMTQtMDMtMjAtMTI6NDM6
MjkgZGV0ZWN0aW5nIGJvb3Qgc3RhdGUgLi4JMTIJMjAgU1VDQ0VTUwoKQmlzZWN0aW5nOiAx
NjQ4IHJldmlzaW9ucyBsZWZ0IHRvIHRlc3QgYWZ0ZXIgdGhpcyAocm91Z2hseSAxMSBzdGVw
cykKWzRmYjg4YjBkYzJkOWIyMjlkMDNhOWU2NTU1ZDkwNTY4ODhjOTAxMzddIE1lcmdlICd0
YXJnZXQvZm9yLW5leHQnIGludG8gZGV2ZWwtaG91cmx5LTIwMTQwMzIwMDcKcnVubmluZyAv
Yy9rZXJuZWwtdGVzdHMvYmlzZWN0LXRlc3QtYm9vdC1mYWlsdXJlLnNoIC9rZXJuZWwtdGVz
dHMvbGludXg3L29iai1iaXNlY3QKbHMgLWEgL2tlcm5lbC10ZXN0cy9ydW4tcXVldWUva3Zt
L2kzODYtcmFuZGNvbmZpZy1uaDAtMDMyMDA1MzgvbGludXgtZGV2ZWw6ZGV2ZWwtaG91cmx5
LTIwMTQwMzIwMDc6NGZiODhiMGRjMmQ5YjIyOWQwM2E5ZTY1NTVkOTA1Njg4OGM5MDEzNzpi
aXNlY3QtbGludXg3CgoyMDE0LTAzLTIwLTEyOjQ1OjMwIDRmYjg4YjBkYzJkOWIyMjlkMDNh
OWU2NTU1ZDkwNTY4ODhjOTAxMzcgY29tcGlsaW5nClF1ZXVlZCBidWlsZCB0YXNrIHRvIC9r
ZXJuZWwtdGVzdHMvYnVpbGQtcXVldWUvaTM4Ni1yYW5kY29uZmlnLW5oMC0wMzIwMDUzOC00
ZmI4OGIwZGMyZDliMjI5ZDAzYTllNjU1NWQ5MDU2ODg4YzkwMTM3CkNoZWNrIGZvciBrZXJu
ZWwgaW4gL2tlcm5lbC9pMzg2LXJhbmRjb25maWctbmgwLTAzMjAwNTM4LzRmYjg4YjBkYzJk
OWIyMjlkMDNhOWU2NTU1ZDkwNTY4ODhjOTAxMzcKd2FpdGluZyBmb3IgY29tcGxldGlvbiBv
ZiAva2VybmVsLXRlc3RzL2J1aWxkLXF1ZXVlL2kzODYtcmFuZGNvbmZpZy1uaDAtMDMyMDA1
MzgtNGZiODhiMGRjMmQ5YjIyOWQwM2E5ZTY1NTVkOTA1Njg4OGM5MDEzNwp3YWl0aW5nIGZv
ciBjb21wbGV0aW9uIG9mIC9rZXJuZWwtdGVzdHMvYnVpbGQtcXVldWUvLmkzODYtcmFuZGNv
bmZpZy1uaDAtMDMyMDA1MzgtNGZiODhiMGRjMmQ5YjIyOWQwM2E5ZTY1NTVkOTA1Njg4OGM5
MDEzNwprZXJuZWw6IC9rZXJuZWwvaTM4Ni1yYW5kY29uZmlnLW5oMC0wMzIwMDUzOC80ZmI4
OGIwZGMyZDliMjI5ZDAzYTllNjU1NWQ5MDU2ODg4YzkwMTM3L3ZtbGludXotMy4xNC4wLXJj
Ny13bC1hdGgtMDE5NTUtZzRmYjg4YjAKCjIwMTQtMDMtMjAtMTM6NDU6MzEgZGV0ZWN0aW5n
IGJvb3Qgc3RhdGUgLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4u
Li4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4u
Li4uLi4uLi4uLi4uLi4uCTIwIFNVQ0NFU1MKCkJpc2VjdGluZzogMTQ2MyByZXZpc2lvbnMg
bGVmdCB0byB0ZXN0IGFmdGVyIHRoaXMgKHJvdWdobHkgMTEgc3RlcHMpCltjNTAxMWY5OThh
OGU5NGMwNTJjNWFhNzFjZjE5NTEwZjJkMGJmNWZkXSBNZXJnZSAncGNpL3BjaS9yZXNvdXJj
ZScgaW50byBkZXZlbC1ob3VybHktMjAxNDAzMjAwNwpydW5uaW5nIC9jL2tlcm5lbC10ZXN0
cy9iaXNlY3QtdGVzdC1ib290LWZhaWx1cmUuc2ggL2tlcm5lbC10ZXN0cy9saW51eDcvb2Jq
LWJpc2VjdApscyAtYSAva2VybmVsLXRlc3RzL3J1bi1xdWV1ZS9rdm0vaTM4Ni1yYW5kY29u
ZmlnLW5oMC0wMzIwMDUzOC9saW51eC1kZXZlbDpkZXZlbC1ob3VybHktMjAxNDAzMjAwNzpj
NTAxMWY5OThhOGU5NGMwNTJjNWFhNzFjZjE5NTEwZjJkMGJmNWZkOmJpc2VjdC1saW51eDcK
CjIwMTQtMDMtMjAtMTQ6NDI6MDMgYzUwMTFmOTk4YThlOTRjMDUyYzVhYTcxY2YxOTUxMGYy
ZDBiZjVmZCBjb21waWxpbmcKUXVldWVkIGJ1aWxkIHRhc2sgdG8gL2tlcm5lbC10ZXN0cy9i
dWlsZC1xdWV1ZS9pMzg2LXJhbmRjb25maWctbmgwLTAzMjAwNTM4LWM1MDExZjk5OGE4ZTk0
YzA1MmM1YWE3MWNmMTk1MTBmMmQwYmY1ZmQKQ2hlY2sgZm9yIGtlcm5lbCBpbiAva2VybmVs
L2kzODYtcmFuZGNvbmZpZy1uaDAtMDMyMDA1MzgvYzUwMTFmOTk4YThlOTRjMDUyYzVhYTcx
Y2YxOTUxMGYyZDBiZjVmZAp3YWl0aW5nIGZvciBjb21wbGV0aW9uIG9mIC9rZXJuZWwtdGVz
dHMvYnVpbGQtcXVldWUvaTM4Ni1yYW5kY29uZmlnLW5oMC0wMzIwMDUzOC1jNTAxMWY5OThh
OGU5NGMwNTJjNWFhNzFjZjE5NTEwZjJkMGJmNWZkCndhaXRpbmcgZm9yIGNvbXBsZXRpb24g
b2YgL2tlcm5lbC10ZXN0cy9idWlsZC1xdWV1ZS8uaTM4Ni1yYW5kY29uZmlnLW5oMC0wMzIw
MDUzOC1jNTAxMWY5OThhOGU5NGMwNTJjNWFhNzFjZjE5NTEwZjJkMGJmNWZkCmtlcm5lbDog
L2tlcm5lbC9pMzg2LXJhbmRjb25maWctbmgwLTAzMjAwNTM4L2M1MDExZjk5OGE4ZTk0YzA1
MmM1YWE3MWNmMTk1MTBmMmQwYmY1ZmQvdm1saW51ei0zLjE0LjAtcmM3LXdsLWF0aC0wMjg0
NS1nYzUwMTFmOQoKMjAxNC0wMy0yMC0xNTowNjowMyBkZXRlY3RpbmcgYm9vdCBzdGF0ZSAu
IFRFU1QgRkFJTFVSRQpbICAgIDIuODU3MDI4XSBVbnBhY2tpbmcgaW5pdHJhbWZzLi4uClsg
ICAgNC42NzE1NTZdIEZyZWVpbmcgaW5pdHJkIG1lbW9yeTogMzI3NksgKDkzY2JkMDAwIC0g
OTNmZjAwMDApClsgICAgNC42NzE1NTZdIEZyZWVpbmcgaW5pdHJkIG1lbW9yeTogMzI3Nksg
KDkzY2JkMDAwIC0gOTNmZjAwMDApClsgICAgNC42Nzk2NjddIEJVRzogdW5hYmxlIHRvIGhh
bmRsZSBrZXJuZWwgCi9rZXJuZWwvaTM4Ni1yYW5kY29uZmlnLW5oMC0wMzIwMDUzOC9jNTAx
MWY5OThhOGU5NGMwNTJjNWFhNzFjZjE5NTEwZjJkMGJmNWZkL2RtZXNnLXlvY3RvLXdhaW1l
YS0xOjIwMTQwMzIwMTUwNjAxOmkzODYtcmFuZGNvbmZpZy1uaDAtMDMyMDA1Mzg6My4xNC4w
LXJjNy13bC1hdGgtMDI4NDUtZ2M1MDExZjk6MQowOjE6MSBhbGxfZ29vZDpiYWQ6YWxsX2Jh
ZCBib290cwobWzE7MzVtMjAxNC0wMy0yMCAxNTowNjozNCBSRVBFQVQgQ09VTlQ6IDIwICAj
IC9rZXJuZWwtdGVzdHMvbGludXg3L29iai1iaXNlY3QvLnJlcGVhdBtbMG0KCkJpc2VjdGlu
ZzogODkwIHJldmlzaW9ucyBsZWZ0IHRvIHRlc3QgYWZ0ZXIgdGhpcyAocm91Z2hseSAxMCBz
dGVwcykKW2RhZWM0ODBhNmU2YmU2ZTk3MTZhNTYwMjlhYWZjYmZiNzllNmI0N2JdIE1lcmdl
ICduZXRkZXYtbmV4dC9tYXN0ZXInIGludG8gZGV2ZWwtaG91cmx5LTIwMTQwMzIwMDcKcnVu
bmluZyAvYy9rZXJuZWwtdGVzdHMvYmlzZWN0LXRlc3QtYm9vdC1mYWlsdXJlLnNoIC9rZXJu
ZWwtdGVzdHMvbGludXg3L29iai1iaXNlY3QKbHMgLWEgL2tlcm5lbC10ZXN0cy9ydW4tcXVl
dWUva3ZtL2kzODYtcmFuZGNvbmZpZy1uaDAtMDMyMDA1MzgvbGludXgtZGV2ZWw6ZGV2ZWwt
aG91cmx5LTIwMTQwMzIwMDc6ZGFlYzQ4MGE2ZTZiZTZlOTcxNmE1NjAyOWFhZmNiZmI3OWU2
YjQ3YjpiaXNlY3QtbGludXg3CgoyMDE0LTAzLTIwLTE1OjA2OjM1IGRhZWM0ODBhNmU2YmU2
ZTk3MTZhNTYwMjlhYWZjYmZiNzllNmI0N2IgY29tcGlsaW5nClF1ZXVlZCBidWlsZCB0YXNr
IHRvIC9rZXJuZWwtdGVzdHMvYnVpbGQtcXVldWUvaTM4Ni1yYW5kY29uZmlnLW5oMC0wMzIw
MDUzOC1kYWVjNDgwYTZlNmJlNmU5NzE2YTU2MDI5YWFmY2JmYjc5ZTZiNDdiCkNoZWNrIGZv
ciBrZXJuZWwgaW4gL2tlcm5lbC9pMzg2LXJhbmRjb25maWctbmgwLTAzMjAwNTM4L2RhZWM0
ODBhNmU2YmU2ZTk3MTZhNTYwMjlhYWZjYmZiNzllNmI0N2IKd2FpdGluZyBmb3IgY29tcGxl
dGlvbiBvZiAva2VybmVsLXRlc3RzL2J1aWxkLXF1ZXVlL2kzODYtcmFuZGNvbmZpZy1uaDAt
MDMyMDA1MzgtZGFlYzQ4MGE2ZTZiZTZlOTcxNmE1NjAyOWFhZmNiZmI3OWU2YjQ3Ygp3YWl0
aW5nIGZvciBjb21wbGV0aW9uIG9mIC9rZXJuZWwtdGVzdHMvYnVpbGQtcXVldWUvLmkzODYt
cmFuZGNvbmZpZy1uaDAtMDMyMDA1MzgtZGFlYzQ4MGE2ZTZiZTZlOTcxNmE1NjAyOWFhZmNi
ZmI3OWU2YjQ3YgprZXJuZWw6IC9rZXJuZWwvaTM4Ni1yYW5kY29uZmlnLW5oMC0wMzIwMDUz
OC9kYWVjNDgwYTZlNmJlNmU5NzE2YTU2MDI5YWFmY2JmYjc5ZTZiNDdiL3ZtbGludXotMy4x
NC4wLXJjNy13bC1hdGgtMDI3MzYtZ2RhZWM0ODAKCjIwMTQtMDMtMjAtMTU6Mzk6MzUgZGV0
ZWN0aW5nIGJvb3Qgc3RhdGUgLi4uCTIwIFNVQ0NFU1MKCkJpc2VjdGluZzogMTA5IHJldmlz
aW9ucyBsZWZ0IHRvIHRlc3QgYWZ0ZXIgdGhpcyAocm91Z2hseSA3IHN0ZXBzKQpbOTM3NDQx
YWUyMjBmZDNmYWUxNDNlZjM5NDIyNzMzN2M5NjlhZDE1NV0gTWVyZ2UgJ2t2bS9xdWV1ZScg
aW50byBkZXZlbC1ob3VybHktMjAxNDAzMjAwNwpydW5uaW5nIC9jL2tlcm5lbC10ZXN0cy9i
aXNlY3QtdGVzdC1ib290LWZhaWx1cmUuc2ggL2tlcm5lbC10ZXN0cy9saW51eDcvb2JqLWJp
c2VjdApscyAtYSAva2VybmVsLXRlc3RzL3J1bi1xdWV1ZS9rdm0vaTM4Ni1yYW5kY29uZmln
LW5oMC0wMzIwMDUzOC9saW51eC1kZXZlbDpkZXZlbC1ob3VybHktMjAxNDAzMjAwNzo5Mzc0
NDFhZTIyMGZkM2ZhZTE0M2VmMzk0MjI3MzM3Yzk2OWFkMTU1OmJpc2VjdC1saW51eDcKCjIw
MTQtMDMtMjAtMTU6NDE6MzYgOTM3NDQxYWUyMjBmZDNmYWUxNDNlZjM5NDIyNzMzN2M5Njlh
ZDE1NSBjb21waWxpbmcKUXVldWVkIGJ1aWxkIHRhc2sgdG8gL2tlcm5lbC10ZXN0cy9idWls
ZC1xdWV1ZS9pMzg2LXJhbmRjb25maWctbmgwLTAzMjAwNTM4LTkzNzQ0MWFlMjIwZmQzZmFl
MTQzZWYzOTQyMjczMzdjOTY5YWQxNTUKQ2hlY2sgZm9yIGtlcm5lbCBpbiAva2VybmVsL2kz
ODYtcmFuZGNvbmZpZy1uaDAtMDMyMDA1MzgvOTM3NDQxYWUyMjBmZDNmYWUxNDNlZjM5NDIy
NzMzN2M5NjlhZDE1NQp3YWl0aW5nIGZvciBjb21wbGV0aW9uIG9mIC9rZXJuZWwtdGVzdHMv
YnVpbGQtcXVldWUvaTM4Ni1yYW5kY29uZmlnLW5oMC0wMzIwMDUzOC05Mzc0NDFhZTIyMGZk
M2ZhZTE0M2VmMzk0MjI3MzM3Yzk2OWFkMTU1CndhaXRpbmcgZm9yIGNvbXBsZXRpb24gb2Yg
L2tlcm5lbC10ZXN0cy9idWlsZC1xdWV1ZS8uaTM4Ni1yYW5kY29uZmlnLW5oMC0wMzIwMDUz
OC05Mzc0NDFhZTIyMGZkM2ZhZTE0M2VmMzk0MjI3MzM3Yzk2OWFkMTU1Cmtlcm5lbDogL2tl
cm5lbC9pMzg2LXJhbmRjb25maWctbmgwLTAzMjAwNTM4LzkzNzQ0MWFlMjIwZmQzZmFlMTQz
ZWYzOTQyMjczMzdjOTY5YWQxNTUvdm1saW51ei0zLjE0LjAtcmM3LXdsLWF0aC0wMjgxOC1n
OTM3NDQxYQoKMjAxNC0wMy0yMC0xNTo1NTozNiBkZXRlY3RpbmcgYm9vdCBzdGF0ZSAuLi4J
MjAgU1VDQ0VTUwoKbGluZWFyLWJpc2VjdDogYmFkIGJyYW5jaCBtYXkgYmUgcGNpL3BjaS9y
ZXNvdXJjZQpsaW5lYXItYmlzZWN0OiBoYW5kbGUgb3ZlciB0byBnaXQgYmlzZWN0CmxpbmVh
ci1iaXNlY3Q6IGdpdCBiaXNlY3Qgc3RhcnQgYzUwMTFmOTk4YThlOTRjMDUyYzVhYTcxY2Yx
OTUxMGYyZDBiZjVmZCA5Mzc0NDFhZTIyMGZkM2ZhZTE0M2VmMzk0MjI3MzM3Yzk2OWFkMTU1
IC0tClByZXZpb3VzIEhFQUQgcG9zaXRpb24gd2FzIDkzNzQ0MWEuLi4gTWVyZ2UgJ2t2bS9x
dWV1ZScgaW50byBkZXZlbC1ob3VybHktMjAxNDAzMjAwNwpIRUFEIGlzIG5vdyBhdCBmNzEx
OTRhLi4uIE1lcmdlIGJyYW5jaCAneDg2L3VyZ2VudCcgb2YgZ2l0Oi8vZ2l0Lmtlcm5lbC5v
cmcvcHViL3NjbS9saW51eC9rZXJuZWwvZ2l0L3RpcC90aXAKQmlzZWN0aW5nOiAxMyByZXZp
c2lvbnMgbGVmdCB0byB0ZXN0IGFmdGVyIHRoaXMgKHJvdWdobHkgNCBzdGVwcykKWzNjZWRj
YzM2MjEyODlkNDFiZDIxYzVkYmUwYjg4NmQ1N2M4M2ExZWFdIFBDSTogRG9uJ3QgZW5hYmxl
IGRlY29kaW5nIGlmIEJBUiBoYXNuJ3QgYmVlbiBhc3NpZ25lZCBhbiBhZGRyZXNzCmxpbmVh
ci1iaXNlY3Q6IGdpdCBiaXNlY3QgcnVuIC9jL2tlcm5lbC10ZXN0cy9iaXNlY3QtdGVzdC1i
b290LWZhaWx1cmUuc2ggL2tlcm5lbC10ZXN0cy9saW51eDcvb2JqLWJpc2VjdApydW5uaW5n
IC9jL2tlcm5lbC10ZXN0cy9iaXNlY3QtdGVzdC1ib290LWZhaWx1cmUuc2ggL2tlcm5lbC10
ZXN0cy9saW51eDcvb2JqLWJpc2VjdApscyAtYSAva2VybmVsLXRlc3RzL3J1bi1xdWV1ZS9r
dm0vaTM4Ni1yYW5kY29uZmlnLW5oMC0wMzIwMDUzOC9saW51eC1kZXZlbDpkZXZlbC1ob3Vy
bHktMjAxNDAzMjAwNzozY2VkY2MzNjIxMjg5ZDQxYmQyMWM1ZGJlMGI4ODZkNTdjODNhMWVh
OmJpc2VjdC1saW51eDcKCjIwMTQtMDMtMjAtMTU6NTc6NDggM2NlZGNjMzYyMTI4OWQ0MWJk
MjFjNWRiZTBiODg2ZDU3YzgzYTFlYSBjb21waWxpbmcKUXVldWVkIGJ1aWxkIHRhc2sgdG8g
L2tlcm5lbC10ZXN0cy9idWlsZC1xdWV1ZS9pMzg2LXJhbmRjb25maWctbmgwLTAzMjAwNTM4
LTNjZWRjYzM2MjEyODlkNDFiZDIxYzVkYmUwYjg4NmQ1N2M4M2ExZWEKQ2hlY2sgZm9yIGtl
cm5lbCBpbiAva2VybmVsL2kzODYtcmFuZGNvbmZpZy1uaDAtMDMyMDA1MzgvM2NlZGNjMzYy
MTI4OWQ0MWJkMjFjNWRiZTBiODg2ZDU3YzgzYTFlYQp3YWl0aW5nIGZvciBjb21wbGV0aW9u
IG9mIC9rZXJuZWwtdGVzdHMvYnVpbGQtcXVldWUvaTM4Ni1yYW5kY29uZmlnLW5oMC0wMzIw
MDUzOC0zY2VkY2MzNjIxMjg5ZDQxYmQyMWM1ZGJlMGI4ODZkNTdjODNhMWVhCndhaXRpbmcg
Zm9yIGNvbXBsZXRpb24gb2YgL2tlcm5lbC10ZXN0cy9idWlsZC1xdWV1ZS8uaTM4Ni1yYW5k
Y29uZmlnLW5oMC0wMzIwMDUzOC0zY2VkY2MzNjIxMjg5ZDQxYmQyMWM1ZGJlMGI4ODZkNTdj
ODNhMWVhCmtlcm5lbDogL2tlcm5lbC9pMzg2LXJhbmRjb25maWctbmgwLTAzMjAwNTM4LzNj
ZWRjYzM2MjEyODlkNDFiZDIxYzVkYmUwYjg4NmQ1N2M4M2ExZWEvdm1saW51ei0zLjE0LjAt
cmMxLTAwMDEzLWczY2VkY2MzCgoyMDE0LTAzLTIwLTE2OjI0OjQ4IGRldGVjdGluZyBib290
IHN0YXRlIC4uLgkxOQkyMCBTVUNDRVNTCgpCaXNlY3Rpbmc6IDYgcmV2aXNpb25zIGxlZnQg
dG8gdGVzdCBhZnRlciB0aGlzIChyb3VnaGx5IDMgc3RlcHMpCltkNzUzMzIzMjUzODlhOTVj
NGRkYmZhMGYwY2Q3ZTVlMDhhNTRhYTQzXSBzMzkwL1BDSTogVXNlIGdlbmVyaWMgcGNpX2Vu
YWJsZV9yZXNvdXJjZXMoKQpydW5uaW5nIC9jL2tlcm5lbC10ZXN0cy9iaXNlY3QtdGVzdC1i
b290LWZhaWx1cmUuc2ggL2tlcm5lbC10ZXN0cy9saW51eDcvb2JqLWJpc2VjdApscyAtYSAv
a2VybmVsLXRlc3RzL3J1bi1xdWV1ZS9rdm0vaTM4Ni1yYW5kY29uZmlnLW5oMC0wMzIwMDUz
OC9saW51eC1kZXZlbDpkZXZlbC1ob3VybHktMjAxNDAzMjAwNzpkNzUzMzIzMjUzODlhOTVj
NGRkYmZhMGYwY2Q3ZTVlMDhhNTRhYTQzOmJpc2VjdC1saW51eDcKCjIwMTQtMDMtMjAtMTY6
Mjc6MTkgZDc1MzMyMzI1Mzg5YTk1YzRkZGJmYTBmMGNkN2U1ZTA4YTU0YWE0MyBjb21waWxp
bmcKUXVldWVkIGJ1aWxkIHRhc2sgdG8gL2tlcm5lbC10ZXN0cy9idWlsZC1xdWV1ZS9pMzg2
LXJhbmRjb25maWctbmgwLTAzMjAwNTM4LWQ3NTMzMjMyNTM4OWE5NWM0ZGRiZmEwZjBjZDdl
NWUwOGE1NGFhNDMKQ2hlY2sgZm9yIGtlcm5lbCBpbiAva2VybmVsL2kzODYtcmFuZGNvbmZp
Zy1uaDAtMDMyMDA1MzgvZDc1MzMyMzI1Mzg5YTk1YzRkZGJmYTBmMGNkN2U1ZTA4YTU0YWE0
Mwp3YWl0aW5nIGZvciBjb21wbGV0aW9uIG9mIC9rZXJuZWwtdGVzdHMvYnVpbGQtcXVldWUv
aTM4Ni1yYW5kY29uZmlnLW5oMC0wMzIwMDUzOC1kNzUzMzIzMjUzODlhOTVjNGRkYmZhMGYw
Y2Q3ZTVlMDhhNTRhYTQzCndhaXRpbmcgZm9yIGNvbXBsZXRpb24gb2YgL2tlcm5lbC10ZXN0
cy9idWlsZC1xdWV1ZS8uaTM4Ni1yYW5kY29uZmlnLW5oMC0wMzIwMDUzOC1kNzUzMzIzMjUz
ODlhOTVjNGRkYmZhMGYwY2Q3ZTVlMDhhNTRhYTQzCmtlcm5lbDogL2tlcm5lbC9pMzg2LXJh
bmRjb25maWctbmgwLTAzMjAwNTM4L2Q3NTMzMjMyNTM4OWE5NWM0ZGRiZmEwZjBjZDdlNWUw
OGE1NGFhNDMvdm1saW51ei0zLjE0LjAtcmMxLTAwMDIwLWdkNzUzMzIzCgoyMDE0LTAzLTIw
LTE2OjUyOjIwIGRldGVjdGluZyBib290IHN0YXRlIC4uCTQJMjAgU1VDQ0VTUwoKQmlzZWN0
aW5nOiAzIHJldmlzaW9ucyBsZWZ0IHRvIHRlc3QgYWZ0ZXIgdGhpcyAocm91Z2hseSAyIHN0
ZXBzKQpbYWExMWZjNThkYzcxYzI3NzAxYjFmOWE1MjlhMzZhMzhkNDMzNzcyMl0gUENJOiBD
aGVjayBhbGwgSU9SRVNPVVJDRV9UWVBFX0JJVFMgaW4gcGNpX2J1c19hbGxvY19mcm9tX3Jl
Z2lvbigpCnJ1bm5pbmcgL2Mva2VybmVsLXRlc3RzL2Jpc2VjdC10ZXN0LWJvb3QtZmFpbHVy
ZS5zaCAva2VybmVsLXRlc3RzL2xpbnV4Ny9vYmotYmlzZWN0CmxzIC1hIC9rZXJuZWwtdGVz
dHMvcnVuLXF1ZXVlL2t2bS9pMzg2LXJhbmRjb25maWctbmgwLTAzMjAwNTM4L2xpbnV4LWRl
dmVsOmRldmVsLWhvdXJseS0yMDE0MDMyMDA3OmFhMTFmYzU4ZGM3MWMyNzcwMWIxZjlhNTI5
YTM2YTM4ZDQzMzc3MjI6YmlzZWN0LWxpbnV4NwoKMjAxNC0wMy0yMC0xNjo1NDoyMSBhYTEx
ZmM1OGRjNzFjMjc3MDFiMWY5YTUyOWEzNmEzOGQ0MzM3NzIyIGNvbXBpbGluZwpRdWV1ZWQg
YnVpbGQgdGFzayB0byAva2VybmVsLXRlc3RzL2J1aWxkLXF1ZXVlL2kzODYtcmFuZGNvbmZp
Zy1uaDAtMDMyMDA1MzgtYWExMWZjNThkYzcxYzI3NzAxYjFmOWE1MjlhMzZhMzhkNDMzNzcy
MgpDaGVjayBmb3Iga2VybmVsIGluIC9rZXJuZWwvaTM4Ni1yYW5kY29uZmlnLW5oMC0wMzIw
MDUzOC9hYTExZmM1OGRjNzFjMjc3MDFiMWY5YTUyOWEzNmEzOGQ0MzM3NzIyCndhaXRpbmcg
Zm9yIGNvbXBsZXRpb24gb2YgL2tlcm5lbC10ZXN0cy9idWlsZC1xdWV1ZS9pMzg2LXJhbmRj
b25maWctbmgwLTAzMjAwNTM4LWFhMTFmYzU4ZGM3MWMyNzcwMWIxZjlhNTI5YTM2YTM4ZDQz
Mzc3MjIKd2FpdGluZyBmb3IgY29tcGxldGlvbiBvZiAva2VybmVsLXRlc3RzL2J1aWxkLXF1
ZXVlLy5pMzg2LXJhbmRjb25maWctbmgwLTAzMjAwNTM4LWFhMTFmYzU4ZGM3MWMyNzcwMWIx
ZjlhNTI5YTM2YTM4ZDQzMzc3MjIKa2VybmVsOiAva2VybmVsL2kzODYtcmFuZGNvbmZpZy1u
aDAtMDMyMDA1MzgvYWExMWZjNThkYzcxYzI3NzAxYjFmOWE1MjlhMzZhMzhkNDMzNzcyMi92
bWxpbnV6LTMuMTQuMC1yYzEtMDAwMjMtZ2FhMTFmYzUKCjIwMTQtMDMtMjAtMTc6MTA6MjEg
ZGV0ZWN0aW5nIGJvb3Qgc3RhdGUgLi4gVEVTVCBGQUlMVVJFClsgICAgMi44MTIzOTJdIFVu
cGFja2luZyBpbml0cmFtZnMuLi4KWyAgICA0LjkzNzU4Ml0gRnJlZWluZyBpbml0cmQgbWVt
b3J5OiAzMjc2SyAoOTNjYmQwMDAgLSA5M2ZmMDAwMCkKWyAgICA0LjkzNzU4Ml0gRnJlZWlu
ZyBpbml0cmQgbWVtb3J5OiAzMjc2SyAoOTNjYmQwMDAgLSA5M2ZmMDAwMCkKWyAgICA0Ljk1
MjExM10gQlVHOiB1bmFibGUgdG8gaGFuZGxlIGtlcm5lbCAKL2tlcm5lbC9pMzg2LXJhbmRj
b25maWctbmgwLTAzMjAwNTM4L2FhMTFmYzU4ZGM3MWMyNzcwMWIxZjlhNTI5YTM2YTM4ZDQz
Mzc3MjIvZG1lc2cteW9jdG8td2FpbWVhLTM6MjAxNDAzMjAxNzEwNTE6aTM4Ni1yYW5kY29u
ZmlnLW5oMC0wMzIwMDUzODozLjE0LjAtcmMxLTAwMDIzLWdhYTExZmM1OjEKMDoxOjEgYWxs
X2dvb2Q6YmFkOmFsbF9iYWQgYm9vdHMKG1sxOzM1bTIwMTQtMDMtMjAgMTc6MTE6MjIgUkVQ
RUFUIENPVU5UOiAyMCAgIyAva2VybmVsLXRlc3RzL2xpbnV4Ny9vYmotYmlzZWN0Ly5yZXBl
YXQbWzBtCgpCaXNlY3Rpbmc6IDAgcmV2aXNpb25zIGxlZnQgdG8gdGVzdCBhZnRlciB0aGlz
IChyb3VnaGx5IDEgc3RlcCkKWzY0MDRlODhlODM4NTYzODEyM2Y0YjE4YjEwNDQzMDQ4MDg3
MDYwMWFdIHJlc291cmNlczogU2V0IHR5cGUgaW4gX19yZXF1ZXN0X3JlZ2lvbigpCnJ1bm5p
bmcgL2Mva2VybmVsLXRlc3RzL2Jpc2VjdC10ZXN0LWJvb3QtZmFpbHVyZS5zaCAva2VybmVs
LXRlc3RzL2xpbnV4Ny9vYmotYmlzZWN0CmxzIC1hIC9rZXJuZWwtdGVzdHMvcnVuLXF1ZXVl
L2t2bS9pMzg2LXJhbmRjb25maWctbmgwLTAzMjAwNTM4L2xpbnV4LWRldmVsOmRldmVsLWhv
dXJseS0yMDE0MDMyMDA3OjY0MDRlODhlODM4NTYzODEyM2Y0YjE4YjEwNDQzMDQ4MDg3MDYw
MWE6YmlzZWN0LWxpbnV4NwoKMjAxNC0wMy0yMC0xNzoxMToyMiA2NDA0ZTg4ZTgzODU2Mzgx
MjNmNGIxOGIxMDQ0MzA0ODA4NzA2MDFhIGNvbXBpbGluZwpRdWV1ZWQgYnVpbGQgdGFzayB0
byAva2VybmVsLXRlc3RzL2J1aWxkLXF1ZXVlL2kzODYtcmFuZGNvbmZpZy1uaDAtMDMyMDA1
MzgtNjQwNGU4OGU4Mzg1NjM4MTIzZjRiMThiMTA0NDMwNDgwODcwNjAxYQpDaGVjayBmb3Ig
a2VybmVsIGluIC9rZXJuZWwvaTM4Ni1yYW5kY29uZmlnLW5oMC0wMzIwMDUzOC82NDA0ZTg4
ZTgzODU2MzgxMjNmNGIxOGIxMDQ0MzA0ODA4NzA2MDFhCndhaXRpbmcgZm9yIGNvbXBsZXRp
b24gb2YgL2tlcm5lbC10ZXN0cy9idWlsZC1xdWV1ZS9pMzg2LXJhbmRjb25maWctbmgwLTAz
MjAwNTM4LTY0MDRlODhlODM4NTYzODEyM2Y0YjE4YjEwNDQzMDQ4MDg3MDYwMWEKd2FpdGlu
ZyBmb3IgY29tcGxldGlvbiBvZiAva2VybmVsLXRlc3RzL2J1aWxkLXF1ZXVlLy5pMzg2LXJh
bmRjb25maWctbmgwLTAzMjAwNTM4LTY0MDRlODhlODM4NTYzODEyM2Y0YjE4YjEwNDQzMDQ4
MDg3MDYwMWEKa2VybmVsOiAva2VybmVsL2kzODYtcmFuZGNvbmZpZy1uaDAtMDMyMDA1Mzgv
NjQwNGU4OGU4Mzg1NjM4MTIzZjRiMThiMTA0NDMwNDgwODcwNjAxYS92bWxpbnV6LTMuMTQu
MC1yYzEtMDAwMjItZzY0MDRlODgKCjIwMTQtMDMtMjAtMTc6MjE6MjIgZGV0ZWN0aW5nIGJv
b3Qgc3RhdGUgLi4uCTExCTIwIFNVQ0NFU1MKCmFhMTFmYzU4ZGM3MWMyNzcwMWIxZjlhNTI5
YTM2YTM4ZDQzMzc3MjIgaXMgdGhlIGZpcnN0IGJhZCBjb21taXQKY29tbWl0IGFhMTFmYzU4
ZGM3MWMyNzcwMWIxZjlhNTI5YTM2YTM4ZDQzMzc3MjIKQXV0aG9yOiBCam9ybiBIZWxnYWFz
IDxiaGVsZ2Fhc0Bnb29nbGUuY29tPgpEYXRlOiAgIEZyaSBNYXIgNyAxMzozOTowMSAyMDE0
IC0wNzAwCgogICAgUENJOiBDaGVjayBhbGwgSU9SRVNPVVJDRV9UWVBFX0JJVFMgaW4gcGNp
X2J1c19hbGxvY19mcm9tX3JlZ2lvbigpCiAgICAKICAgIFdoZW4gYWxsb2NhdGluZyBzcGFj
ZSBmcm9tIGEgYnVzIHJlc291cmNlLCBpLmUuLCBmcm9tIGFwZXJ0dXJlcyBsZWFkaW5nIHRv
CiAgICB0aGlzIGJ1cywgbWFrZSBzdXJlIHRoZSBlbnRpcmUgcmVzb3VyY2UgdHlwZSBtYXRj
aGVzLiAgVGhlIHByZXZpb3VzIGNvZGUKICAgIGFzc3VtZWQgdGhlIElPUkVTT1VSQ0VfVFlQ
RV9CSVRTIGZpZWxkIHdhcyBhIGJpdG1hc2sgd2l0aCBvbmx5IGEgc2luZ2xlIGJpdAogICAg
c2V0LCBidXQgdGhpcyBpcyBub3QgdHJ1ZS4gIElPUkVTT1VSQ0VfVFlQRV9CSVRTIGlzIHJl
YWxseSBhbiBlbnVtZXJhdGlvbiwKICAgIGFuZCB3ZSBoYXZlIHRvIGNoZWNrIGFsbCB0aGUg
Yml0cy4KICAgIAogICAgU2VlIDcyZGNiMTE5NzIyOCAoInJlc291cmNlczogQWRkIHJlZ2lz
dGVyIGFkZHJlc3MgcmVzb3VyY2UgdHlwZSIpLgogICAgCiAgICBObyBmdW5jdGlvbmFsIGNo
YW5nZS4gIElmIHdlIHVzZWQgdGhpcyBwYXRoIGZvciBhbGxvY2F0aW5nIElSUXMsIERNQQog
ICAgY2hhbm5lbHMsIG9yIGJ1cyBudW1iZXJzLCB0aGlzIHdvdWxkIGZpeCBhIGJ1ZyBiZWNh
dXNlIHRob3NlIHR5cGVzIGFyZQogICAgaW5kaXN0aW5ndWlzaGFibGUgd2hlbiBtYXNrZWQg
YnkgSU9SRVNPVVJDRV9JTyB8IElPUkVTT1VSQ0VfTUVNLiAgQnV0IHdlCiAgICBkb24ndCwg
c28gdGhpcyBzaG91bGRuJ3QgbWFrZSBhbnkgZGlmZmVyZW5jZS4KICAgIAogICAgU2lnbmVk
LW9mZi1ieTogQmpvcm4gSGVsZ2FhcyA8YmhlbGdhYXNAZ29vZ2xlLmNvbT4KCjowNDAwMDAg
MDQwMDAwIGRiMzlhMWZmYWY4ZDA1NGI3MzhjNDVlNTIxMDI0NmExNzMzYWZjMjIgOGQ0YWVk
M2JmOGVlYmQ2MzkwMjllMjhiNjljMzA4YzczNGVjNjVhMSBNCWRyaXZlcnMKYmlzZWN0IHJ1
biBzdWNjZXNzCmxzIC1hIC9rZXJuZWwtdGVzdHMvcnVuLXF1ZXVlL2t2bS9pMzg2LXJhbmRj
b25maWctbmgwLTAzMjAwNTM4L2xpbnV4LWRldmVsOmRldmVsLWhvdXJseS0yMDE0MDMyMDA3
OjY0MDRlODhlODM4NTYzODEyM2Y0YjE4YjEwNDQzMDQ4MDg3MDYwMWE6YmlzZWN0LWxpbnV4
NwoKMjAxNC0wMy0yMC0xNzoyMzo1MyA2NDA0ZTg4ZTgzODU2MzgxMjNmNGIxOGIxMDQ0MzA0
ODA4NzA2MDFhIHJldXNlIC9rZXJuZWwvaTM4Ni1yYW5kY29uZmlnLW5oMC0wMzIwMDUzOC82
NDA0ZTg4ZTgzODU2MzgxMjNmNGIxOGIxMDQ0MzA0ODA4NzA2MDFhL3ZtbGludXotMy4xNC4w
LXJjMS0wMDAyMi1nNjQwNGU4OAoKMjAxNC0wMy0yMC0xNzoyMzo1MyBkZXRlY3RpbmcgYm9v
dCBzdGF0ZSAuLi4JMjMJMzkJNTAJNjAgU1VDQ0VTUwoKbHMgLWEgL2tlcm5lbC10ZXN0cy9y
dW4tcXVldWUva3ZtL2kzODYtcmFuZGNvbmZpZy1uaDAtMDMyMDA1MzgvbGludXgtZGV2ZWw6
ZGV2ZWwtaG91cmx5LTIwMTQwMzIwMDc6MmQxODUxNjUyMzczNzMwZjZiOGM3ZmE3ZjQ1ZWFh
ODU0ZjIzZGE4ZjpiaXNlY3QtbGludXg3CiBURVNUIEZBSUxVUkUKWyAgICA5LjAwNTQ2NF0g
W1RUTV0gSW5pdGlhbGl6aW5nIHBvb2wgYWxsb2NhdG9yClsgICAgOS4wMDkwNzRdIC0tLS0t
LS0tLS0tLVsgY3V0IGhlcmUgXS0tLS0tLS0tLS0tLQpbICAgIDkuMDA5MDc0XSAtLS0tLS0t
LS0tLS1bIGN1dCBoZXJlIF0tLS0tLS0tLS0tLS0KWyAgICA5LjAxMTQ2Nl0gV0FSTklORzog
Q1BVOiAwIFBJRDogMSBhdCBkcml2ZXJzL2dwdS9kcm0vZHJtX2NydGMuYzo5NCBkcm1fd2Fy
bl9vbl9tb2Rlc2V0X25vdF9hbGxfbG9ja2VkKzB4NjEvMHhjNigpCi9rZXJuZWwvaTM4Ni1y
YW5kY29uZmlnLW5oMC0wMzIwMDUzOC8yZDE4NTE2NTIzNzM3MzBmNmI4YzdmYTdmNDVlYWE4
NTRmMjNkYThmL2RtZXNnLXlvY3RvLWl2eXRvd24yLTE1OjIwMTQwMzIwMDkzNzE1OmkzODYt
cmFuZGNvbmZpZy1uaDAtMDMyMDA1Mzg6My4xNC4wLXJjNy13bC1hdGgtMDQ1MTktZzJkMTg1
MTY6OQova2VybmVsL2kzODYtcmFuZGNvbmZpZy1uaDAtMDMyMDA1MzgvMmQxODUxNjUyMzcz
NzMwZjZiOGM3ZmE3ZjQ1ZWFhODU0ZjIzZGE4Zi9kbWVzZy1xdWFudGFsLWl2eXRvd24yLTEy
OjIwMTQwMzIwMDkzNzE1OmkzODYtcmFuZGNvbmZpZy1uaDAtMDMyMDA1Mzg6My4xNC4wLXJj
Ny13bC1hdGgtMDQ1MTktZzJkMTg1MTY6OQova2VybmVsL2kzODYtcmFuZGNvbmZpZy1uaDAt
MDMyMDA1MzgvMmQxODUxNjUyMzczNzMwZjZiOGM3ZmE3ZjQ1ZWFhODU0ZjIzZGE4Zi9kbWVz
Zy15b2N0by1pbm4tNDg6MjAxNDAzMjAxMTAwMTM6aTM4Ni1yYW5kY29uZmlnLW5oMC0wMzIw
MDUzODo6Ci9rZXJuZWwvaTM4Ni1yYW5kY29uZmlnLW5oMC0wMzIwMDUzOC8yZDE4NTE2NTIz
NzM3MzBmNmI4YzdmYTdmNDVlYWE4NTRmMjNkYThmL2RtZXNnLXF1YW50YWwteGlhbi04OjIw
MTQwMzIwMTEwMDI4OmkzODYtcmFuZGNvbmZpZy1uaDAtMDMyMDA1Mzg6My4xNC4wLXJjNy13
bC1hdGgtMDQ1MTktZzJkMTg1MTY6OQova2VybmVsL2kzODYtcmFuZGNvbmZpZy1uaDAtMDMy
MDA1MzgvMmQxODUxNjUyMzczNzMwZjZiOGM3ZmE3ZjQ1ZWFhODU0ZjIzZGE4Zi9kbWVzZy15
b2N0by1hdGhlbnMtMjA6MjAxNDAzMjAxMTAwMjI6aTM4Ni1yYW5kY29uZmlnLW5oMC0wMzIw
MDUzODozLjE0LjAtcmM3LXdsLWF0aC0wNDUxOS1nMmQxODUxNjo5Ci9rZXJuZWwvaTM4Ni1y
YW5kY29uZmlnLW5oMC0wMzIwMDUzOC8yZDE4NTE2NTIzNzM3MzBmNmI4YzdmYTdmNDVlYWE4
NTRmMjNkYThmL2RtZXNnLXF1YW50YWwtaW5uLTM1OjIwMTQwMzIwMTEwMDE4OmkzODYtcmFu
ZGNvbmZpZy1uaDAtMDMyMDA1Mzg6Ogova2VybmVsL2kzODYtcmFuZGNvbmZpZy1uaDAtMDMy
MDA1MzgvMmQxODUxNjUyMzczNzMwZjZiOGM3ZmE3ZjQ1ZWFhODU0ZjIzZGE4Zi9kbWVzZy15
b2N0by1hdGhlbnMtNDM6MjAxNDAzMjAxMTAwMTY6aTM4Ni1yYW5kY29uZmlnLW5oMC0wMzIw
MDUzODozLjE0LjAtcmM3LXdsLWF0aC0wNDUxOS1nMmQxODUxNjo5Ci9rZXJuZWwvaTM4Ni1y
YW5kY29uZmlnLW5oMC0wMzIwMDUzOC8yZDE4NTE2NTIzNzM3MzBmNmI4YzdmYTdmNDVlYWE4
NTRmMjNkYThmL2RtZXNnLXlvY3RvLWF0aGVucy0yNToyMDE0MDMyMDExMDAxODppMzg2LXJh
bmRjb25maWctbmgwLTAzMjAwNTM4OjMuMTQuMC1yYzctd2wtYXRoLTA0NTE5LWcyZDE4NTE2
OjkKL2tlcm5lbC9pMzg2LXJhbmRjb25maWctbmgwLTAzMjAwNTM4LzJkMTg1MTY1MjM3Mzcz
MGY2YjhjN2ZhN2Y0NWVhYTg1NGYyM2RhOGYvZG1lc2ctcXVhbnRhbC13YWltZWEtNzoyMDE0
MDMyMDA5MzYxNTppMzg2LXJhbmRjb25maWctbmgwLTAzMjAwNTM4OjMuMTQuMC1yYzctd2wt
YXRoLTA0NTE5LWcyZDE4NTE2OjkKL2tlcm5lbC9pMzg2LXJhbmRjb25maWctbmgwLTAzMjAw
NTM4LzJkMTg1MTY1MjM3MzczMGY2YjhjN2ZhN2Y0NWVhYTg1NGYyM2RhOGYvZG1lc2cteW9j
dG8taXZ5dG93bjItMjoyMDE0MDMyMDA5MzcxNTppMzg2LXJhbmRjb25maWctbmgwLTAzMjAw
NTM4OjMuMTQuMC1yYzctd2wtYXRoLTA0NTE5LWcyZDE4NTE2OjkKL2tlcm5lbC9pMzg2LXJh
bmRjb25maWctbmgwLTAzMjAwNTM4LzJkMTg1MTY1MjM3MzczMGY2YjhjN2ZhN2Y0NWVhYTg1
NGYyM2RhOGYvZG1lc2ctcXVhbnRhbC1zbmItMjc6MjAxNDAzMjAwOTM3NDk6aTM4Ni1yYW5k
Y29uZmlnLW5oMC0wMzIwMDUzODo6Ci9rZXJuZWwvaTM4Ni1yYW5kY29uZmlnLW5oMC0wMzIw
MDUzOC8yZDE4NTE2NTIzNzM3MzBmNmI4YzdmYTdmNDVlYWE4NTRmMjNkYThmL2RtZXNnLXlv
Y3RvLXhpYW4tMTU6MjAxNDAzMjAxMTAwMjI6aTM4Ni1yYW5kY29uZmlnLW5oMC0wMzIwMDUz
ODozLjE0LjAtcmM3LXdsLWF0aC0wNDUxOS1nMmQxODUxNjo5Ci9rZXJuZWwvaTM4Ni1yYW5k
Y29uZmlnLW5oMC0wMzIwMDUzOC8yZDE4NTE2NTIzNzM3MzBmNmI4YzdmYTdmNDVlYWE4NTRm
MjNkYThmL2RtZXNnLXF1YW50YWwtc25iLTY6MjAxNDAzMjAwOTM3NTE6aTM4Ni1yYW5kY29u
ZmlnLW5oMC0wMzIwMDUzODo6Ci9rZXJuZWwvaTM4Ni1yYW5kY29uZmlnLW5oMC0wMzIwMDUz
OC8yZDE4NTE2NTIzNzM3MzBmNmI4YzdmYTdmNDVlYWE4NTRmMjNkYThmL2RtZXNnLXlvY3Rv
LWl2eXRvd24yLTE0OjIwMTQwMzIwMDkzNzE1OmkzODYtcmFuZGNvbmZpZy1uaDAtMDMyMDA1
Mzg6My4xNC4wLXJjNy13bC1hdGgtMDQ1MTktZzJkMTg1MTY6OQova2VybmVsL2kzODYtcmFu
ZGNvbmZpZy1uaDAtMDMyMDA1MzgvMmQxODUxNjUyMzczNzMwZjZiOGM3ZmE3ZjQ1ZWFhODU0
ZjIzZGE4Zi9kbWVzZy15b2N0by1pdnl0b3duMi0yNDoyMDE0MDMyMDA5MzcxNjppMzg2LXJh
bmRjb25maWctbmgwLTAzMjAwNTM4OjMuMTQuMC1yYzctd2wtYXRoLTA0NTE5LWcyZDE4NTE2
OjkKL2tlcm5lbC9pMzg2LXJhbmRjb25maWctbmgwLTAzMjAwNTM4LzJkMTg1MTY1MjM3Mzcz
MGY2YjhjN2ZhN2Y0NWVhYTg1NGYyM2RhOGYvZG1lc2cteW9jdG8tYXRoZW5zLTE5OjIwMTQw
MzIwMTEwMDIzOmkzODYtcmFuZGNvbmZpZy1uaDAtMDMyMDA1Mzg6My4xNC4wLXJjNy13bC1h
dGgtMDQ1MTktZzJkMTg1MTY6OQova2VybmVsL2kzODYtcmFuZGNvbmZpZy1uaDAtMDMyMDA1
MzgvMmQxODUxNjUyMzczNzMwZjZiOGM3ZmE3ZjQ1ZWFhODU0ZjIzZGE4Zi9kbWVzZy15b2N0
by1yb2FtLTU6MjAxNDAzMjAxMTAwMjQ6aTM4Ni1yYW5kY29uZmlnLW5oMC0wMzIwMDUzODoz
LjE0LjAtcmM3LXdsLWF0aC0wNDUxOS1nMmQxODUxNjo5Ci9rZXJuZWwvaTM4Ni1yYW5kY29u
ZmlnLW5oMC0wMzIwMDUzOC8yZDE4NTE2NTIzNzM3MzBmNmI4YzdmYTdmNDVlYWE4NTRmMjNk
YThmL2RtZXNnLXlvY3RvLWNhaXJvLTE0OjIwMTQwMzIwMDkzNzI5OmkzODYtcmFuZGNvbmZp
Zy1uaDAtMDMyMDA1Mzg6My4xNC4wLXJjNy13bC1hdGgtMDQ1MTktZzJkMTg1MTY6OQova2Vy
bmVsL2kzODYtcmFuZGNvbmZpZy1uaDAtMDMyMDA1MzgvMmQxODUxNjUyMzczNzMwZjZiOGM3
ZmE3ZjQ1ZWFhODU0ZjIzZGE4Zi9kbWVzZy15b2N0by1pbm4tMjE6MjAxNDAzMjAxMTAwMTM6
aTM4Ni1yYW5kY29uZmlnLW5oMC0wMzIwMDUzODo6CjA6MTk6MTkgYWxsX2dvb2Q6YmFkOmFs
bF9iYWQgYm9vdHMKCltkZXRhY2hlZCBIRUFEIDE0MjdlYzddIFJldmVydCAiUENJOiBDaGVj
ayBhbGwgSU9SRVNPVVJDRV9UWVBFX0JJVFMgaW4gcGNpX2J1c19hbGxvY19mcm9tX3JlZ2lv
bigpIgogMSBmaWxlIGNoYW5nZWQsIDEgaW5zZXJ0aW9uKCspLCAxIGRlbGV0aW9uKC0pCmxz
IC1hIC9rZXJuZWwtdGVzdHMvcnVuLXF1ZXVlL2t2bS9pMzg2LXJhbmRjb25maWctbmgwLTAz
MjAwNTM4L2xpbnV4LWRldmVsOmRldmVsLWhvdXJseS0yMDE0MDMyMDA3OjE0MjdlYzc5MWFm
MTU4ZjA1ZTI2ZDA2MTk5ZmVmZDc3OTg5NTc5ZmM6YmlzZWN0LWxpbnV4NwoKMjAxNC0wMy0y
MC0xNzoyNzozMCAxNDI3ZWM3OTFhZjE1OGYwNWUyNmQwNjE5OWZlZmQ3Nzk4OTU3OWZjIGNv
bXBpbGluZwpRdWV1ZWQgYnVpbGQgdGFzayB0byAva2VybmVsLXRlc3RzL2J1aWxkLXF1ZXVl
L2kzODYtcmFuZGNvbmZpZy1uaDAtMDMyMDA1MzgtMTQyN2VjNzkxYWYxNThmMDVlMjZkMDYx
OTlmZWZkNzc5ODk1NzlmYwpDaGVjayBmb3Iga2VybmVsIGluIC9rZXJuZWwvaTM4Ni1yYW5k
Y29uZmlnLW5oMC0wMzIwMDUzOC8xNDI3ZWM3OTFhZjE1OGYwNWUyNmQwNjE5OWZlZmQ3Nzk4
OTU3OWZjCndhaXRpbmcgZm9yIGNvbXBsZXRpb24gb2YgL2tlcm5lbC10ZXN0cy9idWlsZC1x
dWV1ZS9pMzg2LXJhbmRjb25maWctbmgwLTAzMjAwNTM4LTE0MjdlYzc5MWFmMTU4ZjA1ZTI2
ZDA2MTk5ZmVmZDc3OTg5NTc5ZmMKc3RhdHVzOiBGQUlMOiBubyBjb21taXQgMTQyN2VjNzkx
YWYxNThmMDVlMjZkMDYxOTlmZWZkNzc5ODk1NzlmYyBmb3IgYnVpbGQgdGFzayBpMzg2LXJh
bmRjb25maWctbmgwLTAzMjAwNTM4LTE0MjdlYzc5MWFmMTU4ZjA1ZTI2ZDA2MTk5ZmVmZDc3
OTg5NTc5ZmMKMjAxNC0wMy0yMC0xNzo1MzozMCAxNDI3ZWM3OTFhZjE1OGYwNWUyNmQwNjE5
OWZlZmQ3Nzk4OTU3OWZjIFNLSVAgQlJPS0VOIEJVSUxECk5vIGtlcm5lbCBpbiAva2VybmVs
L2kzODYtcmFuZGNvbmZpZy1uaDAtMDMyMDA1MzgvMTQyN2VjNzkxYWYxNThmMDVlMjZkMDYx
OTlmZWZkNzc5ODk1NzlmYwoKPT09PT09PT09IHVwc3RyZWFtID09PT09PT09PQpXYXJuaW5n
OiB5b3UgYXJlIGxlYXZpbmcgMSBjb21taXQgYmVoaW5kLCBub3QgY29ubmVjdGVkIHRvCmFu
eSBvZiB5b3VyIGJyYW5jaGVzOgoKICAxNDI3ZWM3IFJldmVydCAiUENJOiBDaGVjayBhbGwg
SU9SRVNPVVJDRV9UWVBFX0JJVFMgaW4gcGNpX2J1c19hbGxvY19mcm9tX3JlZ2lvbigpIgoK
SWYgeW91IHdhbnQgdG8ga2VlcCB0aGVtIGJ5IGNyZWF0aW5nIGEgbmV3IGJyYW5jaCwgdGhp
cyBtYXkgYmUgYSBnb29kIHRpbWUKdG8gZG8gc28gd2l0aDoKCiBnaXQgYnJhbmNoIG5ld19i
cmFuY2hfbmFtZSAxNDI3ZWM3CgpIRUFEIGlzIG5vdyBhdCA4ODc4NDM5Li4uIG1tOiBmaXgg
YmFkIHJzcy1jb3VudGVyIGlmIHJlbWFwX2ZpbGVfcGFnZXMgcmFjZWQgbWlncmF0aW9uCmxz
IC1hIC9rZXJuZWwtdGVzdHMvcnVuLXF1ZXVlL2t2bS9pMzg2LXJhbmRjb25maWctbmgwLTAz
MjAwNTM4L2xpbnV4LWRldmVsOmRldmVsLWhvdXJseS0yMDE0MDMyMDA3Ojg4Nzg0Mzk2MWM0
YjQ2ODFlZTk5M2MzNmQ0OTk3YmY0YjRhYTgyNTM6YmlzZWN0LWxpbnV4NwoKMjAxNC0wMy0y
MC0xNzo1MzozMyA4ODc4NDM5NjFjNGI0NjgxZWU5OTNjMzZkNDk5N2JmNGI0YWE4MjUzIGNv
bXBpbGluZwpRdWV1ZWQgYnVpbGQgdGFzayB0byAva2VybmVsLXRlc3RzL2J1aWxkLXF1ZXVl
L2kzODYtcmFuZGNvbmZpZy1uaDAtMDMyMDA1MzgtODg3ODQzOTYxYzRiNDY4MWVlOTkzYzM2
ZDQ5OTdiZjRiNGFhODI1MwpDaGVjayBmb3Iga2VybmVsIGluIC9rZXJuZWwvaTM4Ni1yYW5k
Y29uZmlnLW5oMC0wMzIwMDUzOC84ODc4NDM5NjFjNGI0NjgxZWU5OTNjMzZkNDk5N2JmNGI0
YWE4MjUzCndhaXRpbmcgZm9yIGNvbXBsZXRpb24gb2YgL2tlcm5lbC10ZXN0cy9idWlsZC1x
dWV1ZS9pMzg2LXJhbmRjb25maWctbmgwLTAzMjAwNTM4LTg4Nzg0Mzk2MWM0YjQ2ODFlZTk5
M2MzNmQ0OTk3YmY0YjRhYTgyNTMKd2FpdGluZyBmb3IgY29tcGxldGlvbiBvZiAva2VybmVs
LXRlc3RzL2J1aWxkLXF1ZXVlLy5pMzg2LXJhbmRjb25maWctbmgwLTAzMjAwNTM4LTg4Nzg0
Mzk2MWM0YjQ2ODFlZTk5M2MzNmQ0OTk3YmY0YjRhYTgyNTMKa2VybmVsOiAva2VybmVsL2kz
ODYtcmFuZGNvbmZpZy1uaDAtMDMyMDA1MzgvODg3ODQzOTYxYzRiNDY4MWVlOTkzYzM2ZDQ5
OTdiZjRiNGFhODI1My92bWxpbnV6LTMuMTQuMC1yYzctMDAwMzMtZzg4Nzg0MzkKCjIwMTQt
MDMtMjAtMTk6MjE6MzMgZGV0ZWN0aW5nIGJvb3Qgc3RhdGUgLi4JMTcJMzYJNjAgU1VDQ0VT
UwoKCj09PT09PT09PSBsaW51eC1uZXh0ID09PT09PT09PQpGZXRjaGluZyBuZXh0CkZyb20g
Z2l0Oi8vZ2l0bWlycm9yL25leHQKICsgNTZkZDM1Yi4uLjc1Njc4MjQgYWtwbSAgICAgICAt
PiBuZXh0L2FrcG0gIChmb3JjZWQgdXBkYXRlKQogKyA2YzAzZTkyLi4uMDE2MzE5ZCBha3Bt
LWJhc2UgIC0+IG5leHQvYWtwbS1iYXNlICAoZm9yY2VkIHVwZGF0ZSkKICsgODZjOTkwYy4u
LmE2NTRkYzcgbWFzdGVyICAgICAtPiBuZXh0L21hc3RlciAgKGZvcmNlZCB1cGRhdGUpCiAg
IDQ5MDdjZGMuLjg4Nzg0MzkgIHN0YWJsZSAgICAgLT4gbmV4dC9zdGFibGUKICogW25ldyB0
YWddICAgICAgICAgbmV4dC0yMDE0MDMyMCAtPiBuZXh0LTIwMTQwMzIwClByZXZpb3VzIEhF
QUQgcG9zaXRpb24gd2FzIDg4Nzg0MzkuLi4gbW06IGZpeCBiYWQgcnNzLWNvdW50ZXIgaWYg
cmVtYXBfZmlsZV9wYWdlcyByYWNlZCBtaWdyYXRpb24KSEVBRCBpcyBub3cgYXQgYTY1NGRj
Ny4uLiBBZGQgbGludXgtbmV4dCBzcGVjaWZpYyBmaWxlcyBmb3IgMjAxNDAzMjAKbHMgLWEg
L2tlcm5lbC10ZXN0cy9ydW4tcXVldWUva3ZtL2kzODYtcmFuZGNvbmZpZy1uaDAtMDMyMDA1
MzgvbGludXgtZGV2ZWw6ZGV2ZWwtaG91cmx5LTIwMTQwMzIwMDc6YTY1NGRjNzk3ZjNlYTFj
YjU3MTlhNzFhMTdhZjM1ZjU3ZmRkYjJkODpiaXNlY3QtbGludXg3CgoyMDE0LTAzLTIwLTE5
OjI1OjUxIGE2NTRkYzc5N2YzZWExY2I1NzE5YTcxYTE3YWYzNWY1N2ZkZGIyZDggY29tcGls
aW5nClF1ZXVlZCBidWlsZCB0YXNrIHRvIC9rZXJuZWwtdGVzdHMvYnVpbGQtcXVldWUvaTM4
Ni1yYW5kY29uZmlnLW5oMC0wMzIwMDUzOC1hNjU0ZGM3OTdmM2VhMWNiNTcxOWE3MWExN2Fm
MzVmNTdmZGRiMmQ4CkNoZWNrIGZvciBrZXJuZWwgaW4gL2tlcm5lbC9pMzg2LXJhbmRjb25m
aWctbmgwLTAzMjAwNTM4L2E2NTRkYzc5N2YzZWExY2I1NzE5YTcxYTE3YWYzNWY1N2ZkZGIy
ZDgKd2FpdGluZyBmb3IgY29tcGxldGlvbiBvZiAva2VybmVsLXRlc3RzL2J1aWxkLXF1ZXVl
L2kzODYtcmFuZGNvbmZpZy1uaDAtMDMyMDA1MzgtYTY1NGRjNzk3ZjNlYTFjYjU3MTlhNzFh
MTdhZjM1ZjU3ZmRkYjJkOAp3YWl0aW5nIGZvciBjb21wbGV0aW9uIG9mIC9rZXJuZWwtdGVz
dHMvYnVpbGQtcXVldWUvLmkzODYtcmFuZGNvbmZpZy1uaDAtMDMyMDA1MzgtYTY1NGRjNzk3
ZjNlYTFjYjU3MTlhNzFhMTdhZjM1ZjU3ZmRkYjJkOAprZXJuZWw6IC9rZXJuZWwvaTM4Ni1y
YW5kY29uZmlnLW5oMC0wMzIwMDUzOC9hNjU0ZGM3OTdmM2VhMWNiNTcxOWE3MWExN2FmMzVm
NTdmZGRiMmQ4L3ZtbGludXotMy4xNC4wLXJjNy1uZXh0LTIwMTQwMzIwCgoyMDE0LTAzLTIw
LTIwOjA4OjUyIGRldGVjdGluZyBib290IHN0YXRlIC4uLiBURVNUIEZBSUxVUkUKWyAgICAz
LjI2MzA4Nl0gW1RUTV0gSW5pdGlhbGl6aW5nIHBvb2wgYWxsb2NhdG9yClsgICAgMy4yNjM5
OThdIC0tLS0tLS0tLS0tLVsgY3V0IGhlcmUgXS0tLS0tLS0tLS0tLQpbICAgIDMuMjYzOTk4
XSAtLS0tLS0tLS0tLS1bIGN1dCBoZXJlIF0tLS0tLS0tLS0tLS0KWyAgICAzLjI2NDc5MV0g
V0FSTklORzogQ1BVOiAwIFBJRDogMSBhdCBkcml2ZXJzL2dwdS9kcm0vZHJtX2NydGMuYzo5
NCBkcm1fd2Fybl9vbl9tb2Rlc2V0X25vdF9hbGxfbG9ja2VkKzB4NjEvMHhjNigpCi9rZXJu
ZWwvaTM4Ni1yYW5kY29uZmlnLW5oMC0wMzIwMDUzOC9hNjU0ZGM3OTdmM2VhMWNiNTcxOWE3
MWExN2FmMzVmNTdmZGRiMmQ4L2RtZXNnLXF1YW50YWwteHBzLTM6MjAxNDAzMjAyMDEwMTI6
aTM4Ni1yYW5kY29uZmlnLW5oMC0wMzIwMDUzODozLjE0LjAtcmM3LW5leHQtMjAxNDAzMjA6
MQowOjE6MSBhbGxfZ29vZDpiYWQ6YWxsX2JhZCBib290cwoK

--zYM0uCDKw75PZbzx
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="config-3.14.0-rc7-wl-ath-04519-g2d18516"

#
# Automatically generated file; DO NOT EDIT.
# Linux/i386 3.14.0-rc7 Kernel Configuration
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
CONFIG_SYSVIPC=y
# CONFIG_POSIX_MQUEUE is not set
CONFIG_FHANDLE=y
# CONFIG_AUDIT is not set

#
# IRQ subsystem
#
CONFIG_GENERIC_IRQ_PROBE=y
CONFIG_GENERIC_IRQ_SHOW=y
CONFIG_GENERIC_IRQ_CHIP=y
CONFIG_IRQ_DOMAIN=y
CONFIG_IRQ_DOMAIN_DEBUG=y
CONFIG_IRQ_FORCED_THREADING=y
CONFIG_SPARSE_IRQ=y
CONFIG_CLOCKSOURCE_WATCHDOG=y
CONFIG_KTIME_SCALAR=y
CONFIG_GENERIC_CLOCKEVENTS=y
CONFIG_GENERIC_CLOCKEVENTS_BUILD=y
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
CONFIG_TICK_CPU_ACCOUNTING=y
# CONFIG_IRQ_TIME_ACCOUNTING is not set
CONFIG_BSD_PROCESS_ACCT=y
# CONFIG_BSD_PROCESS_ACCT_V3 is not set
# CONFIG_TASKSTATS is not set

#
# RCU Subsystem
#
CONFIG_TINY_RCU=y
# CONFIG_PREEMPT_RCU is not set
CONFIG_RCU_STALL_COMMON=y
# CONFIG_TREE_RCU_TRACE is not set
CONFIG_IKCONFIG=y
CONFIG_LOG_BUF_SHIFT=17
CONFIG_HAVE_UNSTABLE_SCHED_CLOCK=y
CONFIG_ARCH_SUPPORTS_NUMA_BALANCING=y
CONFIG_ARCH_WANTS_PROT_NUMA_PROT_NONE=y
CONFIG_CGROUPS=y
CONFIG_CGROUP_DEBUG=y
# CONFIG_CGROUP_FREEZER is not set
# CONFIG_CGROUP_DEVICE is not set
# CONFIG_CPUSETS is not set
# CONFIG_CGROUP_CPUACCT is not set
CONFIG_RESOURCE_COUNTERS=y
# CONFIG_MEMCG is not set
# CONFIG_CGROUP_HUGETLB is not set
# CONFIG_CGROUP_PERF is not set
CONFIG_CGROUP_SCHED=y
CONFIG_FAIR_GROUP_SCHED=y
CONFIG_CFS_BANDWIDTH=y
# CONFIG_RT_GROUP_SCHED is not set
CONFIG_CHECKPOINT_RESTORE=y
CONFIG_NAMESPACES=y
# CONFIG_UTS_NS is not set
# CONFIG_IPC_NS is not set
# CONFIG_USER_NS is not set
# CONFIG_PID_NS is not set
CONFIG_NET_NS=y
CONFIG_SCHED_AUTOGROUP=y
# CONFIG_SYSFS_DEPRECATED is not set
CONFIG_RELAY=y
CONFIG_BLK_DEV_INITRD=y
CONFIG_INITRAMFS_SOURCE=""
CONFIG_RD_GZIP=y
CONFIG_RD_BZIP2=y
# CONFIG_RD_LZMA is not set
# CONFIG_RD_XZ is not set
# CONFIG_RD_LZO is not set
CONFIG_RD_LZ4=y
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
CONFIG_BASE_FULL=y
CONFIG_FUTEX=y
# CONFIG_EPOLL is not set
# CONFIG_SIGNALFD is not set
# CONFIG_TIMERFD is not set
# CONFIG_EVENTFD is not set
CONFIG_SHMEM=y
CONFIG_AIO=y
CONFIG_PCI_QUIRKS=y
CONFIG_EMBEDDED=y
CONFIG_HAVE_PERF_EVENTS=y

#
# Kernel Performance Events And Counters
#
CONFIG_PERF_EVENTS=y
# CONFIG_DEBUG_PERF_USE_VMALLOC is not set
CONFIG_VM_EVENT_COUNTERS=y
CONFIG_COMPAT_BRK=y
CONFIG_SLAB=y
# CONFIG_SLUB is not set
# CONFIG_SLOB is not set
CONFIG_PROFILING=y
CONFIG_TRACEPOINTS=y
CONFIG_OPROFILE=y
# CONFIG_OPROFILE_EVENT_MULTIPLEX is not set
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
# CONFIG_SYSTEM_TRUSTED_KEYRING is not set
# CONFIG_MODULES is not set
# CONFIG_BLOCK is not set
CONFIG_ASN1=y
CONFIG_UNINLINE_SPIN_UNLOCK=y
# CONFIG_FREEZER is not set

#
# Processor type and features
#
# CONFIG_ZONE_DMA is not set
# CONFIG_SMP is not set
# CONFIG_X86_EXTENDED_PLATFORM is not set
# CONFIG_X86_INTEL_LPSS is not set
# CONFIG_X86_32_IRIS is not set
# CONFIG_SCHED_OMIT_FRAME_POINTER is not set
CONFIG_HYPERVISOR_GUEST=y
CONFIG_PARAVIRT=y
# CONFIG_PARAVIRT_DEBUG is not set
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
# CONFIG_PROCESSOR_SELECT is not set
CONFIG_CPU_SUP_INTEL=y
CONFIG_CPU_SUP_CYRIX_32=y
CONFIG_CPU_SUP_AMD=y
CONFIG_CPU_SUP_CENTAUR=y
CONFIG_CPU_SUP_TRANSMETA_32=y
CONFIG_CPU_SUP_UMC_32=y
CONFIG_HPET_TIMER=y
CONFIG_HPET_EMULATE_RTC=y
CONFIG_DMI=y
CONFIG_NR_CPUS=1
CONFIG_PREEMPT_NONE=y
# CONFIG_PREEMPT_VOLUNTARY is not set
# CONFIG_PREEMPT is not set
CONFIG_PREEMPT_COUNT=y
# CONFIG_X86_UP_APIC is not set
# CONFIG_X86_MCE is not set
# CONFIG_VM86 is not set
CONFIG_TOSHIBA=y
CONFIG_I8K=y
# CONFIG_X86_REBOOTFIXUPS is not set
CONFIG_MICROCODE=y
CONFIG_MICROCODE_INTEL=y
# CONFIG_MICROCODE_AMD is not set
CONFIG_MICROCODE_OLD_INTERFACE=y
CONFIG_MICROCODE_INTEL_EARLY=y
# CONFIG_MICROCODE_AMD_EARLY is not set
CONFIG_MICROCODE_EARLY=y
# CONFIG_X86_MSR is not set
CONFIG_X86_CPUID=y
CONFIG_NOHIGHMEM=y
# CONFIG_HIGHMEM4G is not set
# CONFIG_HIGHMEM64G is not set
# CONFIG_VMSPLIT_3G is not set
# CONFIG_VMSPLIT_3G_OPT is not set
CONFIG_VMSPLIT_2G=y
# CONFIG_VMSPLIT_2G_OPT is not set
# CONFIG_VMSPLIT_1G is not set
CONFIG_PAGE_OFFSET=0x80000000
# CONFIG_X86_PAE is not set
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
# CONFIG_HAVE_BOOTMEM_INFO_NODE is not set
CONFIG_PAGEFLAGS_EXTENDED=y
CONFIG_SPLIT_PTLOCK_CPUS=4
CONFIG_BALLOON_COMPACTION=y
CONFIG_COMPACTION=y
CONFIG_MIGRATION=y
# CONFIG_PHYS_ADDR_T_64BIT is not set
CONFIG_ZONE_DMA_FLAG=0
CONFIG_VIRT_TO_BUS=y
CONFIG_KSM=y
CONFIG_DEFAULT_MMAP_MIN_ADDR=4096
CONFIG_TRANSPARENT_HUGEPAGE=y
CONFIG_TRANSPARENT_HUGEPAGE_ALWAYS=y
# CONFIG_TRANSPARENT_HUGEPAGE_MADVISE is not set
CONFIG_CROSS_MEMORY_ATTACH=y
CONFIG_NEED_PER_CPU_KM=y
CONFIG_CLEANCACHE=y
# CONFIG_CMA is not set
# CONFIG_ZBUD is not set
# CONFIG_ZSMALLOC is not set
CONFIG_X86_CHECK_BIOS_CORRUPTION=y
CONFIG_X86_BOOTPARAM_MEMORY_CORRUPTION_CHECK=y
CONFIG_X86_RESERVE_LOW=64
CONFIG_MATH_EMULATION=y
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
CONFIG_SCHED_HRTICK=y
CONFIG_KEXEC=y
CONFIG_PHYSICAL_START=0x1000000
CONFIG_RELOCATABLE=y
# CONFIG_RANDOMIZE_BASE is not set
CONFIG_X86_NEED_RELOCS=y
CONFIG_PHYSICAL_ALIGN=0x200000
# CONFIG_COMPAT_VDSO is not set
# CONFIG_CMDLINE_BOOL is not set

#
# Power management and ACPI options
#
# CONFIG_SUSPEND is not set
# CONFIG_PM_RUNTIME is not set
CONFIG_ACPI=y
# CONFIG_ACPI_EC_DEBUGFS is not set
CONFIG_ACPI_AC=y
# CONFIG_ACPI_BATTERY is not set
CONFIG_ACPI_BUTTON=y
CONFIG_ACPI_VIDEO=y
CONFIG_ACPI_FAN=y
# CONFIG_ACPI_DOCK is not set
# CONFIG_ACPI_PROCESSOR is not set
CONFIG_ACPI_IPMI=y
CONFIG_ACPI_CUSTOM_DSDT_FILE=""
# CONFIG_ACPI_CUSTOM_DSDT is not set
CONFIG_ACPI_INITRD_TABLE_OVERRIDE=y
CONFIG_ACPI_DEBUG=y
# CONFIG_ACPI_PCI_SLOT is not set
CONFIG_X86_PM_TIMER=y
CONFIG_ACPI_CONTAINER=y
CONFIG_ACPI_SBS=y
CONFIG_ACPI_HED=y
CONFIG_ACPI_CUSTOM_METHOD=y
CONFIG_ACPI_REDUCED_HARDWARE_ONLY=y
# CONFIG_ACPI_APEI is not set
# CONFIG_SFI is not set

#
# CPU Frequency scaling
#
# CONFIG_CPU_FREQ is not set

#
# CPU Idle
#
CONFIG_CPU_IDLE=y
CONFIG_CPU_IDLE_MULTIPLE_DRIVERS=y
CONFIG_CPU_IDLE_GOV_LADDER=y
CONFIG_CPU_IDLE_GOV_MENU=y
# CONFIG_ARCH_NEEDS_CPU_IDLE_COUPLED is not set
CONFIG_INTEL_IDLE=y

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
CONFIG_PCI_STUB=y
CONFIG_PCI_ATS=y
CONFIG_PCI_IOV=y
CONFIG_PCI_PRI=y
# CONFIG_PCI_PASID is not set
CONFIG_PCI_LABEL=y

#
# PCI host controller drivers
#
CONFIG_ISA_DMA_API=y
CONFIG_ISA=y
# CONFIG_EISA is not set
CONFIG_SCx200=y
CONFIG_SCx200HR_TIMER=y
# CONFIG_OLPC is not set
CONFIG_ALIX=y
CONFIG_NET5501=y
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
# CONFIG_YENTA_TOSHIBA is not set
# CONFIG_PD6729 is not set
# CONFIG_I82092 is not set
CONFIG_I82365=y
# CONFIG_TCIC is not set
CONFIG_PCMCIA_PROBE=y
CONFIG_PCCARD_NONSTATIC=y
# CONFIG_HOTPLUG_PCI is not set
# CONFIG_RAPIDIO is not set
# CONFIG_X86_SYSFB is not set

#
# Executable file formats / Emulations
#
CONFIG_BINFMT_ELF=y
CONFIG_ARCH_BINFMT_ELF_RANDOMIZE_PIE=y
CONFIG_BINFMT_SCRIPT=y
CONFIG_HAVE_AOUT=y
CONFIG_BINFMT_AOUT=y
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
# CONFIG_DNS_RESOLVER is not set
# CONFIG_BATMAN_ADV is not set
# CONFIG_BATMAN_ADV_MCAST is not set
# CONFIG_OPENVSWITCH is not set
# CONFIG_VSOCKETS is not set
# CONFIG_NETLINK_MMAP is not set
# CONFIG_NETLINK_DIAG is not set
# CONFIG_NET_MPLS_GSO is not set
# CONFIG_HSR is not set
# CONFIG_CGROUP_NET_PRIO is not set
# CONFIG_CGROUP_NET_CLASSID is not set
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

#
# Bus devices
#
# CONFIG_CONNECTOR is not set
CONFIG_MTD=y
CONFIG_MTD_REDBOOT_PARTS=y
CONFIG_MTD_REDBOOT_DIRECTORY_BLOCK=-1
# CONFIG_MTD_REDBOOT_PARTS_UNALLOCATED is not set
CONFIG_MTD_REDBOOT_PARTS_READONLY=y
CONFIG_MTD_CMDLINE_PARTS=y
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
# CONFIG_MTD_CFI_ADV_OPTIONS is not set
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
CONFIG_MTD_CFI_INTELEXT=y
CONFIG_MTD_CFI_AMDSTD=y
CONFIG_MTD_CFI_STAA=y
CONFIG_MTD_CFI_UTIL=y
CONFIG_MTD_RAM=y
# CONFIG_MTD_ROM is not set
# CONFIG_MTD_ABSENT is not set

#
# Mapping drivers for chip access
#
# CONFIG_MTD_COMPLEX_MAPPINGS is not set
CONFIG_MTD_PHYSMAP=y
# CONFIG_MTD_PHYSMAP_COMPAT is not set
# CONFIG_MTD_SC520CDP is not set
# CONFIG_MTD_NETSC520 is not set
# CONFIG_MTD_TS5500 is not set
# CONFIG_MTD_SCx200_DOCFLASH is not set
CONFIG_MTD_AMD76XROM=y
CONFIG_MTD_ICHXROM=y
# CONFIG_MTD_ESB2ROM is not set
CONFIG_MTD_CK804XROM=y
CONFIG_MTD_SCB2_FLASH=y
# CONFIG_MTD_NETtel is not set
CONFIG_MTD_L440GX=y
# CONFIG_MTD_INTEL_VR_NOR is not set
# CONFIG_MTD_PLATRAM is not set

#
# Self-contained MTD device drivers
#
CONFIG_MTD_PMC551=y
CONFIG_MTD_PMC551_BUGFIX=y
# CONFIG_MTD_PMC551_DEBUG is not set
CONFIG_MTD_DATAFLASH=y
CONFIG_MTD_DATAFLASH_WRITE_VERIFY=y
# CONFIG_MTD_DATAFLASH_OTP is not set
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
CONFIG_MTD_SM_COMMON=y
CONFIG_MTD_NAND_DENALI=y
CONFIG_MTD_NAND_DENALI_PCI=y
CONFIG_MTD_NAND_DENALI_SCRATCH_REG_ADDR=0xFF108018
# CONFIG_MTD_NAND_GPIO is not set
CONFIG_MTD_NAND_IDS=y
CONFIG_MTD_NAND_RICOH=y
CONFIG_MTD_NAND_DISKONCHIP=y
CONFIG_MTD_NAND_DISKONCHIP_PROBE_ADVANCED=y
CONFIG_MTD_NAND_DISKONCHIP_PROBE_ADDRESS=0
CONFIG_MTD_NAND_DISKONCHIP_PROBE_HIGH=y
# CONFIG_MTD_NAND_DISKONCHIP_BBTWRITE is not set
# CONFIG_MTD_NAND_DOCG4 is not set
CONFIG_MTD_NAND_CAFE=y
CONFIG_MTD_NAND_CS553X=y
CONFIG_MTD_NAND_NANDSIM=y
# CONFIG_MTD_NAND_PLATFORM is not set
CONFIG_MTD_NAND_SH_FLCTL=y
CONFIG_MTD_ONENAND=y
# CONFIG_MTD_ONENAND_VERIFY_WRITE is not set
CONFIG_MTD_ONENAND_GENERIC=y
CONFIG_MTD_ONENAND_OTP=y
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
# CONFIG_PARPORT is not set
CONFIG_ARCH_MIGHT_HAVE_PC_PARPORT=y
CONFIG_PNP=y
# CONFIG_PNP_DEBUG_MESSAGES is not set

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
# CONFIG_AD525X_DPOT is not set
# CONFIG_DUMMY_IRQ is not set
# CONFIG_IBM_ASM is not set
CONFIG_PHANTOM=y
# CONFIG_INTEL_MID_PTI is not set
CONFIG_SGI_IOC4=y
# CONFIG_TIFM_CORE is not set
CONFIG_ICS932S401=y
# CONFIG_ATMEL_SSC is not set
CONFIG_ENCLOSURE_SERVICES=y
CONFIG_CS5535_MFGPT=y
CONFIG_CS5535_MFGPT_DEFAULT_IRQ=7
# CONFIG_CS5535_CLOCK_EVENT_SRC is not set
CONFIG_HP_ILO=y
CONFIG_APDS9802ALS=y
# CONFIG_ISL29003 is not set
# CONFIG_ISL29020 is not set
# CONFIG_SENSORS_TSL2550 is not set
CONFIG_SENSORS_BH1780=y
# CONFIG_SENSORS_BH1770 is not set
CONFIG_SENSORS_APDS990X=y
# CONFIG_HMC6352 is not set
# CONFIG_DS1682 is not set
CONFIG_TI_DAC7512=y
# CONFIG_VMWARE_BALLOON is not set
CONFIG_BMP085=y
CONFIG_BMP085_I2C=y
# CONFIG_BMP085_SPI is not set
CONFIG_PCH_PHUB=y
CONFIG_USB_SWITCH_FSA9480=y
# CONFIG_LATTICE_ECP3_CONFIG is not set
# CONFIG_SRAM is not set
CONFIG_C2PORT=y
# CONFIG_C2PORT_DURAMAR_2150 is not set

#
# EEPROM support
#
CONFIG_EEPROM_AT24=y
CONFIG_EEPROM_AT25=y
CONFIG_EEPROM_LEGACY=y
CONFIG_EEPROM_MAX6875=y
# CONFIG_EEPROM_93CX6 is not set
CONFIG_EEPROM_93XX46=y
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
CONFIG_INTEL_MEI=y
CONFIG_INTEL_MEI_ME=y
# CONFIG_INTEL_MEI_TXE is not set
CONFIG_VMWARE_VMCI=y

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
CONFIG_FUSION=y
CONFIG_FUSION_MAX_SGE=128
# CONFIG_FUSION_LOGGING is not set

#
# IEEE 1394 (FireWire) support
#
# CONFIG_FIREWIRE is not set
CONFIG_FIREWIRE_NOSY=y
CONFIG_I2O=y
# CONFIG_I2O_LCT_NOTIFY_ON_CHANGES is not set
CONFIG_I2O_EXT_ADAPTEC=y
# CONFIG_I2O_CONFIG is not set
# CONFIG_I2O_BUS is not set
# CONFIG_I2O_PROC is not set
# CONFIG_MACINTOSH_DRIVERS is not set
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
# CONFIG_INPUT_MOUSEDEV is not set
# CONFIG_INPUT_JOYDEV is not set
# CONFIG_INPUT_EVDEV is not set
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
# CONFIG_KEYBOARD_STMPE is not set
# CONFIG_KEYBOARD_TWL4030 is not set
# CONFIG_KEYBOARD_XTKBD is not set
# CONFIG_KEYBOARD_CROS_EC is not set
# CONFIG_INPUT_MOUSE is not set
CONFIG_INPUT_JOYSTICK=y
CONFIG_JOYSTICK_ANALOG=y
CONFIG_JOYSTICK_A3D=y
CONFIG_JOYSTICK_ADI=y
# CONFIG_JOYSTICK_COBRA is not set
CONFIG_JOYSTICK_GF2K=y
CONFIG_JOYSTICK_GRIP=y
# CONFIG_JOYSTICK_GRIP_MP is not set
# CONFIG_JOYSTICK_GUILLEMOT is not set
CONFIG_JOYSTICK_INTERACT=y
# CONFIG_JOYSTICK_SIDEWINDER is not set
CONFIG_JOYSTICK_TMDC=y
CONFIG_JOYSTICK_IFORCE=y
CONFIG_JOYSTICK_IFORCE_232=y
CONFIG_JOYSTICK_WARRIOR=y
# CONFIG_JOYSTICK_MAGELLAN is not set
CONFIG_JOYSTICK_SPACEORB=y
CONFIG_JOYSTICK_SPACEBALL=y
CONFIG_JOYSTICK_STINGER=y
# CONFIG_JOYSTICK_TWIDJOY is not set
CONFIG_JOYSTICK_ZHENHUA=y
CONFIG_JOYSTICK_AS5011=y
CONFIG_JOYSTICK_JOYDUMP=y
# CONFIG_JOYSTICK_XPAD is not set
# CONFIG_INPUT_TABLET is not set
CONFIG_INPUT_TOUCHSCREEN=y
CONFIG_TOUCHSCREEN_88PM860X=y
CONFIG_TOUCHSCREEN_ADS7846=y
CONFIG_TOUCHSCREEN_AD7877=y
CONFIG_TOUCHSCREEN_AD7879=y
CONFIG_TOUCHSCREEN_AD7879_I2C=y
# CONFIG_TOUCHSCREEN_AD7879_SPI is not set
CONFIG_TOUCHSCREEN_ATMEL_MXT=y
# CONFIG_TOUCHSCREEN_AUO_PIXCIR is not set
CONFIG_TOUCHSCREEN_BU21013=y
CONFIG_TOUCHSCREEN_CY8CTMG110=y
# CONFIG_TOUCHSCREEN_CYTTSP_CORE is not set
CONFIG_TOUCHSCREEN_CYTTSP4_CORE=y
# CONFIG_TOUCHSCREEN_CYTTSP4_I2C is not set
# CONFIG_TOUCHSCREEN_CYTTSP4_SPI is not set
CONFIG_TOUCHSCREEN_DA9052=y
# CONFIG_TOUCHSCREEN_DYNAPRO is not set
CONFIG_TOUCHSCREEN_HAMPSHIRE=y
CONFIG_TOUCHSCREEN_EETI=y
# CONFIG_TOUCHSCREEN_FUJITSU is not set
CONFIG_TOUCHSCREEN_ILI210X=y
# CONFIG_TOUCHSCREEN_GUNZE is not set
# CONFIG_TOUCHSCREEN_ELO is not set
CONFIG_TOUCHSCREEN_WACOM_W8001=y
CONFIG_TOUCHSCREEN_WACOM_I2C=y
CONFIG_TOUCHSCREEN_MAX11801=y
CONFIG_TOUCHSCREEN_MCS5000=y
# CONFIG_TOUCHSCREEN_MMS114 is not set
CONFIG_TOUCHSCREEN_MTOUCH=y
CONFIG_TOUCHSCREEN_INEXIO=y
CONFIG_TOUCHSCREEN_MK712=y
CONFIG_TOUCHSCREEN_HTCPEN=y
CONFIG_TOUCHSCREEN_PENMOUNT=y
CONFIG_TOUCHSCREEN_EDT_FT5X06=y
# CONFIG_TOUCHSCREEN_TOUCHRIGHT is not set
CONFIG_TOUCHSCREEN_TOUCHWIN=y
CONFIG_TOUCHSCREEN_TI_AM335X_TSC=y
CONFIG_TOUCHSCREEN_PIXCIR=y
CONFIG_TOUCHSCREEN_WM831X=y
# CONFIG_TOUCHSCREEN_USB_COMPOSITE is not set
CONFIG_TOUCHSCREEN_MC13783=y
CONFIG_TOUCHSCREEN_TOUCHIT213=y
CONFIG_TOUCHSCREEN_TSC_SERIO=y
CONFIG_TOUCHSCREEN_TSC2005=y
CONFIG_TOUCHSCREEN_TSC2007=y
CONFIG_TOUCHSCREEN_PCAP=y
CONFIG_TOUCHSCREEN_ST1232=y
CONFIG_TOUCHSCREEN_STMPE=y
CONFIG_TOUCHSCREEN_TPS6507X=y
# CONFIG_TOUCHSCREEN_ZFORCE is not set
CONFIG_INPUT_MISC=y
CONFIG_INPUT_88PM860X_ONKEY=y
# CONFIG_INPUT_AD714X is not set
CONFIG_INPUT_BMA150=y
CONFIG_INPUT_PCSPKR=y
# CONFIG_INPUT_MC13783_PWRBUTTON is not set
CONFIG_INPUT_MMA8450=y
CONFIG_INPUT_MPU3050=y
CONFIG_INPUT_APANEL=y
CONFIG_INPUT_GP2A=y
CONFIG_INPUT_GPIO_TILT_POLLED=y
CONFIG_INPUT_WISTRON_BTNS=y
CONFIG_INPUT_ATLAS_BTNS=y
# CONFIG_INPUT_ATI_REMOTE2 is not set
# CONFIG_INPUT_KEYSPAN_REMOTE is not set
# CONFIG_INPUT_KXTJ9 is not set
# CONFIG_INPUT_POWERMATE is not set
# CONFIG_INPUT_YEALINK is not set
# CONFIG_INPUT_CM109 is not set
CONFIG_INPUT_TWL4030_PWRBUTTON=y
# CONFIG_INPUT_TWL4030_VIBRA is not set
CONFIG_INPUT_UINPUT=y
CONFIG_INPUT_PCF8574=y
CONFIG_INPUT_GPIO_ROTARY_ENCODER=y
CONFIG_INPUT_DA9052_ONKEY=y
CONFIG_INPUT_DA9055_ONKEY=y
CONFIG_INPUT_WM831X_ON=y
CONFIG_INPUT_PCAP=y
# CONFIG_INPUT_ADXL34X is not set
# CONFIG_INPUT_CMA3000 is not set
# CONFIG_INPUT_IDEAPAD_SLIDEBAR is not set

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
CONFIG_SERIO_RAW=y
CONFIG_SERIO_ALTERA_PS2=y
CONFIG_SERIO_PS2MULT=y
CONFIG_SERIO_ARC_PS2=y
CONFIG_GAMEPORT=y
# CONFIG_GAMEPORT_NS558 is not set
CONFIG_GAMEPORT_L4=y
# CONFIG_GAMEPORT_EMU10K1 is not set
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
# CONFIG_SERIAL_8250_CS is not set
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
# CONFIG_SERIAL_UARTLITE is not set
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
# CONFIG_VIRTIO_CONSOLE is not set
CONFIG_IPMI_HANDLER=y
CONFIG_IPMI_PANIC_EVENT=y
CONFIG_IPMI_PANIC_STRING=y
CONFIG_IPMI_DEVICE_INTERFACE=y
CONFIG_IPMI_SI=y
# CONFIG_IPMI_WATCHDOG is not set
# CONFIG_IPMI_POWEROFF is not set
CONFIG_HW_RANDOM=y
CONFIG_HW_RANDOM_TIMERIOMEM=y
CONFIG_HW_RANDOM_INTEL=y
CONFIG_HW_RANDOM_AMD=y
# CONFIG_HW_RANDOM_GEODE is not set
CONFIG_HW_RANDOM_VIA=y
# CONFIG_HW_RANDOM_VIRTIO is not set
CONFIG_HW_RANDOM_TPM=y
CONFIG_NVRAM=y
CONFIG_DTLK=y
# CONFIG_R3964 is not set
CONFIG_APPLICOM=y
CONFIG_SONYPI=y

#
# PCMCIA character devices
#
# CONFIG_SYNCLINK_CS is not set
# CONFIG_CARDMAN_4000 is not set
CONFIG_CARDMAN_4040=y
# CONFIG_MWAVE is not set
# CONFIG_SCx200_GPIO is not set
CONFIG_PC8736x_GPIO=y
CONFIG_NSC_GPIO=y
# CONFIG_HPET is not set
CONFIG_HANGCHECK_TIMER=y
CONFIG_TCG_TPM=y
CONFIG_TCG_TIS=y
# CONFIG_TCG_TIS_I2C_ATMEL is not set
CONFIG_TCG_TIS_I2C_INFINEON=y
CONFIG_TCG_TIS_I2C_NUVOTON=y
CONFIG_TCG_NSC=y
CONFIG_TCG_ATMEL=y
CONFIG_TCG_INFINEON=y
# CONFIG_TCG_ST33_I2C is not set
# CONFIG_TELCLOCK is not set
CONFIG_DEVPORT=y
CONFIG_I2C=y
CONFIG_I2C_BOARDINFO=y
CONFIG_I2C_COMPAT=y
CONFIG_I2C_CHARDEV=y
CONFIG_I2C_MUX=y

#
# Multiplexer I2C Chip support
#
CONFIG_I2C_MUX_GPIO=y
CONFIG_I2C_MUX_PCA9541=y
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
CONFIG_I2C_ALI1563=y
CONFIG_I2C_ALI15X3=y
CONFIG_I2C_AMD756=y
CONFIG_I2C_AMD756_S4882=y
CONFIG_I2C_AMD8111=y
# CONFIG_I2C_I801 is not set
CONFIG_I2C_ISCH=y
# CONFIG_I2C_ISMT is not set
CONFIG_I2C_PIIX4=y
# CONFIG_I2C_NFORCE2 is not set
CONFIG_I2C_SIS5595=y
CONFIG_I2C_SIS630=y
CONFIG_I2C_SIS96X=y
CONFIG_I2C_VIA=y
CONFIG_I2C_VIAPRO=y

#
# ACPI drivers
#
CONFIG_I2C_SCMI=y

#
# I2C system bus drivers (mostly embedded / system-on-chip)
#
CONFIG_I2C_CBUS_GPIO=y
CONFIG_I2C_DESIGNWARE_CORE=y
# CONFIG_I2C_DESIGNWARE_PLATFORM is not set
CONFIG_I2C_DESIGNWARE_PCI=y
CONFIG_I2C_EG20T=y
CONFIG_I2C_GPIO=y
# CONFIG_I2C_KEMPLD is not set
CONFIG_I2C_OCORES=y
CONFIG_I2C_PCA_PLATFORM=y
# CONFIG_I2C_PXA_PCI is not set
CONFIG_I2C_RIIC=y
CONFIG_I2C_SH_MOBILE=y
# CONFIG_I2C_SIMTEC is not set
# CONFIG_I2C_XILINX is not set
CONFIG_I2C_RCAR=y

#
# External I2C/SMBus adapter drivers
#
CONFIG_I2C_PARPORT_LIGHT=y
# CONFIG_I2C_TAOS_EVM is not set

#
# Other I2C/SMBus bus drivers
#
CONFIG_I2C_ELEKTOR=y
# CONFIG_I2C_PCA_ISA is not set
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
CONFIG_SPI_ALTERA=y
CONFIG_SPI_ATMEL=y
# CONFIG_SPI_BCM2835 is not set
CONFIG_SPI_BCM63XX_HSSPI=y
CONFIG_SPI_BITBANG=y
# CONFIG_SPI_EP93XX is not set
# CONFIG_SPI_GPIO is not set
# CONFIG_SPI_IMX is not set
# CONFIG_SPI_FSL_DSPI is not set
CONFIG_SPI_OC_TINY=y
# CONFIG_SPI_TI_QSPI is not set
CONFIG_SPI_OMAP_100K=y
CONFIG_SPI_ORION=y
# CONFIG_SPI_PXA2XX is not set
# CONFIG_SPI_PXA2XX_PCI is not set
CONFIG_SPI_SC18IS602=y
CONFIG_SPI_SH=y
CONFIG_SPI_SH_HSPI=y
# CONFIG_SPI_TEGRA114 is not set
# CONFIG_SPI_TEGRA20_SFLASH is not set
CONFIG_SPI_TEGRA20_SLINK=y
# CONFIG_SPI_TOPCLIFF_PCH is not set
CONFIG_SPI_TXX9=y
CONFIG_SPI_XCOMM=y
# CONFIG_SPI_XILINX is not set
# CONFIG_SPI_DESIGNWARE is not set

#
# SPI Protocol Masters
#
CONFIG_SPI_SPIDEV=y
CONFIG_SPI_TLE62X0=y
# CONFIG_SPMI is not set
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
# CONFIG_GPIO_SYSFS is not set
CONFIG_GPIO_GENERIC=y
CONFIG_GPIO_DA9052=y
# CONFIG_GPIO_DA9055 is not set

#
# Memory mapped GPIO drivers:
#
CONFIG_GPIO_CLPS711X=y
# CONFIG_GPIO_GENERIC_PLATFORM is not set
CONFIG_GPIO_IT8761E=y
# CONFIG_GPIO_F7188X is not set
# CONFIG_GPIO_SCH311X is not set
CONFIG_GPIO_TS5500=y
# CONFIG_GPIO_SCH is not set
CONFIG_GPIO_ICH=y
# CONFIG_GPIO_VX855 is not set
CONFIG_GPIO_LYNXPOINT=y

#
# I2C GPIO expanders:
#
CONFIG_GPIO_ARIZONA=y
# CONFIG_GPIO_MAX7300 is not set
CONFIG_GPIO_MAX732X=y
# CONFIG_GPIO_MAX732X_IRQ is not set
# CONFIG_GPIO_PCA953X is not set
CONFIG_GPIO_PCF857X=y
# CONFIG_GPIO_SX150X is not set
CONFIG_GPIO_STMPE=y
CONFIG_GPIO_TPS65912=y
CONFIG_GPIO_TWL4030=y
CONFIG_GPIO_WM831X=y
CONFIG_GPIO_WM8994=y
# CONFIG_GPIO_ADP5520 is not set
CONFIG_GPIO_ADP5588=y
CONFIG_GPIO_ADP5588_IRQ=y

#
# PCI GPIO expanders:
#
# CONFIG_GPIO_CS5535 is not set
# CONFIG_GPIO_BT8XX is not set
CONFIG_GPIO_AMD8111=y
CONFIG_GPIO_INTEL_MID=y
CONFIG_GPIO_PCH=y
CONFIG_GPIO_ML_IOH=y
# CONFIG_GPIO_TIMBERDALE is not set
CONFIG_GPIO_RDC321X=y

#
# SPI GPIO expanders:
#
# CONFIG_GPIO_MAX7301 is not set
# CONFIG_GPIO_MC33880 is not set

#
# AC97 GPIO expanders:
#

#
# LPC GPIO expanders:
#
# CONFIG_GPIO_KEMPLD is not set

#
# MODULbus GPIO expanders:
#
# CONFIG_GPIO_TPS6586X is not set
CONFIG_GPIO_TPS65910=y

#
# USB GPIO expanders:
#
CONFIG_W1=y

#
# 1-wire Bus Masters
#
CONFIG_W1_MASTER_MATROX=y
CONFIG_W1_MASTER_DS2482=y
CONFIG_W1_MASTER_MXC=y
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
CONFIG_W1_SLAVE_DS2423=y
CONFIG_W1_SLAVE_DS2431=y
CONFIG_W1_SLAVE_DS2433=y
# CONFIG_W1_SLAVE_DS2433_CRC is not set
CONFIG_W1_SLAVE_DS2760=y
CONFIG_W1_SLAVE_DS2780=y
# CONFIG_W1_SLAVE_DS2781 is not set
# CONFIG_W1_SLAVE_DS28E04 is not set
CONFIG_W1_SLAVE_BQ27000=y
CONFIG_POWER_SUPPLY=y
# CONFIG_POWER_SUPPLY_DEBUG is not set
# CONFIG_PDA_POWER is not set
CONFIG_GENERIC_ADC_BATTERY=y
CONFIG_WM831X_BACKUP=y
# CONFIG_WM831X_POWER is not set
CONFIG_TEST_POWER=y
CONFIG_BATTERY_88PM860X=y
CONFIG_BATTERY_DS2760=y
CONFIG_BATTERY_DS2780=y
# CONFIG_BATTERY_DS2781 is not set
# CONFIG_BATTERY_DS2782 is not set
CONFIG_BATTERY_SBS=y
CONFIG_BATTERY_BQ27x00=y
CONFIG_BATTERY_BQ27X00_I2C=y
CONFIG_BATTERY_BQ27X00_PLATFORM=y
CONFIG_BATTERY_DA9052=y
# CONFIG_BATTERY_MAX17040 is not set
CONFIG_BATTERY_MAX17042=y
CONFIG_CHARGER_88PM860X=y
# CONFIG_CHARGER_MAX8903 is not set
CONFIG_CHARGER_TWL4030=y
CONFIG_CHARGER_LP8727=y
CONFIG_CHARGER_GPIO=y
CONFIG_CHARGER_MANAGER=y
# CONFIG_CHARGER_MAX14577 is not set
# CONFIG_CHARGER_MAX8997 is not set
# CONFIG_CHARGER_BQ2415X is not set
CONFIG_CHARGER_BQ24190=y
# CONFIG_CHARGER_BQ24735 is not set
CONFIG_CHARGER_SMB347=y
# CONFIG_BATTERY_GOLDFISH is not set
# CONFIG_POWER_RESET is not set
# CONFIG_POWER_AVS is not set
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
CONFIG_SENSORS_AD7418=y
CONFIG_SENSORS_ADCXX=y
# CONFIG_SENSORS_ADM1021 is not set
# CONFIG_SENSORS_ADM1025 is not set
# CONFIG_SENSORS_ADM1026 is not set
CONFIG_SENSORS_ADM1029=y
CONFIG_SENSORS_ADM1031=y
CONFIG_SENSORS_ADM9240=y
CONFIG_SENSORS_ADT7X10=y
# CONFIG_SENSORS_ADT7310 is not set
CONFIG_SENSORS_ADT7410=y
CONFIG_SENSORS_ADT7411=y
# CONFIG_SENSORS_ADT7462 is not set
CONFIG_SENSORS_ADT7470=y
CONFIG_SENSORS_ADT7475=y
CONFIG_SENSORS_ASC7621=y
CONFIG_SENSORS_K8TEMP=y
CONFIG_SENSORS_K10TEMP=y
CONFIG_SENSORS_FAM15H_POWER=y
CONFIG_SENSORS_ASB100=y
CONFIG_SENSORS_ATXP1=y
CONFIG_SENSORS_DS620=y
CONFIG_SENSORS_DS1621=y
CONFIG_SENSORS_DA9052_ADC=y
CONFIG_SENSORS_DA9055=y
CONFIG_SENSORS_I5K_AMB=y
CONFIG_SENSORS_F71805F=y
CONFIG_SENSORS_F71882FG=y
CONFIG_SENSORS_F75375S=y
# CONFIG_SENSORS_FSCHMD is not set
# CONFIG_SENSORS_G760A is not set
# CONFIG_SENSORS_G762 is not set
CONFIG_SENSORS_GL518SM=y
CONFIG_SENSORS_GL520SM=y
CONFIG_SENSORS_GPIO_FAN=y
# CONFIG_SENSORS_HIH6130 is not set
CONFIG_SENSORS_HTU21=y
CONFIG_SENSORS_CORETEMP=y
CONFIG_SENSORS_IBMAEM=y
CONFIG_SENSORS_IBMPEX=y
CONFIG_SENSORS_IIO_HWMON=y
# CONFIG_SENSORS_IT87 is not set
CONFIG_SENSORS_JC42=y
# CONFIG_SENSORS_LINEAGE is not set
CONFIG_SENSORS_LM63=y
# CONFIG_SENSORS_LM70 is not set
CONFIG_SENSORS_LM73=y
CONFIG_SENSORS_LM75=y
CONFIG_SENSORS_LM77=y
CONFIG_SENSORS_LM78=y
CONFIG_SENSORS_LM80=y
CONFIG_SENSORS_LM83=y
CONFIG_SENSORS_LM85=y
# CONFIG_SENSORS_LM87 is not set
CONFIG_SENSORS_LM90=y
# CONFIG_SENSORS_LM92 is not set
# CONFIG_SENSORS_LM93 is not set
CONFIG_SENSORS_LTC4151=y
CONFIG_SENSORS_LTC4215=y
# CONFIG_SENSORS_LTC4245 is not set
CONFIG_SENSORS_LTC4261=y
CONFIG_SENSORS_LM95234=y
CONFIG_SENSORS_LM95241=y
CONFIG_SENSORS_LM95245=y
CONFIG_SENSORS_MAX1111=y
CONFIG_SENSORS_MAX16065=y
CONFIG_SENSORS_MAX1619=y
CONFIG_SENSORS_MAX1668=y
# CONFIG_SENSORS_MAX197 is not set
CONFIG_SENSORS_MAX6639=y
CONFIG_SENSORS_MAX6642=y
CONFIG_SENSORS_MAX6650=y
# CONFIG_SENSORS_MAX6697 is not set
# CONFIG_SENSORS_MCP3021 is not set
CONFIG_SENSORS_NCT6775=y
CONFIG_SENSORS_PC87360=y
CONFIG_SENSORS_PC87427=y
# CONFIG_SENSORS_PCF8591 is not set
# CONFIG_PMBUS is not set
CONFIG_SENSORS_SHT15=y
# CONFIG_SENSORS_SHT21 is not set
# CONFIG_SENSORS_SIS5595 is not set
# CONFIG_SENSORS_SMM665 is not set
CONFIG_SENSORS_DME1737=y
# CONFIG_SENSORS_EMC1403 is not set
CONFIG_SENSORS_EMC2103=y
CONFIG_SENSORS_EMC6W201=y
CONFIG_SENSORS_SMSC47M1=y
CONFIG_SENSORS_SMSC47M192=y
CONFIG_SENSORS_SMSC47B397=y
CONFIG_SENSORS_SCH56XX_COMMON=y
CONFIG_SENSORS_SCH5627=y
CONFIG_SENSORS_SCH5636=y
# CONFIG_SENSORS_ADS1015 is not set
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
# CONFIG_SENSORS_W83793 is not set
# CONFIG_SENSORS_W83795 is not set
# CONFIG_SENSORS_W83L785TS is not set
# CONFIG_SENSORS_W83L786NG is not set
# CONFIG_SENSORS_W83627HF is not set
# CONFIG_SENSORS_W83627EHF is not set
# CONFIG_SENSORS_WM831X is not set
CONFIG_SENSORS_APPLESMC=y
CONFIG_SENSORS_MC13783_ADC=y

#
# ACPI drivers
#
CONFIG_SENSORS_ACPI_POWER=y
CONFIG_SENSORS_ATK0110=y
CONFIG_THERMAL=y
CONFIG_THERMAL_HWMON=y
CONFIG_THERMAL_DEFAULT_GOV_STEP_WISE=y
# CONFIG_THERMAL_DEFAULT_GOV_FAIR_SHARE is not set
# CONFIG_THERMAL_DEFAULT_GOV_USER_SPACE is not set
# CONFIG_THERMAL_GOV_FAIR_SHARE is not set
CONFIG_THERMAL_GOV_STEP_WISE=y
CONFIG_THERMAL_GOV_USER_SPACE=y
CONFIG_THERMAL_EMULATION=y
CONFIG_RCAR_THERMAL=y
CONFIG_INTEL_POWERCLAMP=y
# CONFIG_ACPI_INT3403_THERMAL is not set

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
# CONFIG_DA9055_WATCHDOG is not set
CONFIG_WM831X_WATCHDOG=y
CONFIG_DW_WATCHDOG=y
CONFIG_TWL4030_WATCHDOG=y
# CONFIG_ACQUIRE_WDT is not set
# CONFIG_ADVANTECH_WDT is not set
CONFIG_ALIM1535_WDT=y
CONFIG_ALIM7101_WDT=y
# CONFIG_F71808E_WDT is not set
CONFIG_SP5100_TCO=y
# CONFIG_GEODE_WDT is not set
# CONFIG_SC520_WDT is not set
CONFIG_SBC_FITPC2_WATCHDOG=y
# CONFIG_EUROTECH_WDT is not set
CONFIG_IB700_WDT=y
CONFIG_IBMASR=y
CONFIG_WAFER_WDT=y
CONFIG_I6300ESB_WDT=y
CONFIG_IE6XX_WDT=y
CONFIG_ITCO_WDT=y
# CONFIG_ITCO_VENDOR_SUPPORT is not set
CONFIG_IT8712F_WDT=y
# CONFIG_IT87_WDT is not set
CONFIG_HP_WATCHDOG=y
# CONFIG_KEMPLD_WDT is not set
CONFIG_HPWDT_NMI_DECODING=y
CONFIG_SC1200_WDT=y
# CONFIG_SCx200_WDT is not set
# CONFIG_PC87413_WDT is not set
CONFIG_NV_TCO=y
# CONFIG_60XX_WDT is not set
# CONFIG_SBC8360_WDT is not set
# CONFIG_SBC7240_WDT is not set
CONFIG_CPU5_WDT=y
CONFIG_SMSC_SCH311X_WDT=y
CONFIG_SMSC37B787_WDT=y
# CONFIG_VIA_WDT is not set
CONFIG_W83627HF_WDT=y
# CONFIG_W83697HF_WDT is not set
CONFIG_W83697UG_WDT=y
CONFIG_W83877F_WDT=y
# CONFIG_W83977F_WDT is not set
# CONFIG_MACHZ_WDT is not set
CONFIG_SBC_EPX_C3_WATCHDOG=y
CONFIG_MEN_A21_WDT=y

#
# ISA-based Watchdog Cards
#
# CONFIG_PCWATCHDOG is not set
# CONFIG_MIXCOMWD is not set
# CONFIG_WDT is not set

#
# PCI-based Watchdog Cards
#
CONFIG_PCIPCWATCHDOG=y
# CONFIG_WDTPCI is not set
CONFIG_SSB_POSSIBLE=y

#
# Sonics Silicon Backplane
#
CONFIG_SSB=y
CONFIG_SSB_SPROM=y
CONFIG_SSB_PCIHOST_POSSIBLE=y
CONFIG_SSB_PCIHOST=y
# CONFIG_SSB_B43_PCI_BRIDGE is not set
CONFIG_SSB_PCMCIAHOST_POSSIBLE=y
# CONFIG_SSB_PCMCIAHOST is not set
# CONFIG_SSB_SILENT is not set
# CONFIG_SSB_DEBUG is not set
CONFIG_SSB_DRIVER_PCICORE_POSSIBLE=y
# CONFIG_SSB_DRIVER_PCICORE is not set
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
CONFIG_PMIC_ADP5520=y
# CONFIG_MFD_AAT2870_CORE is not set
CONFIG_MFD_CROS_EC=y
CONFIG_MFD_CROS_EC_I2C=y
# CONFIG_PMIC_DA903X is not set
CONFIG_PMIC_DA9052=y
CONFIG_MFD_DA9052_SPI=y
# CONFIG_MFD_DA9052_I2C is not set
CONFIG_MFD_DA9055=y
CONFIG_MFD_DA9063=y
CONFIG_MFD_MC13XXX=y
# CONFIG_MFD_MC13XXX_SPI is not set
CONFIG_MFD_MC13XXX_I2C=y
# CONFIG_HTC_PASIC3 is not set
# CONFIG_HTC_I2CPLD is not set
CONFIG_LPC_ICH=y
CONFIG_LPC_SCH=y
# CONFIG_MFD_JANZ_CMODIO is not set
CONFIG_MFD_KEMPLD=y
# CONFIG_MFD_88PM800 is not set
# CONFIG_MFD_88PM805 is not set
CONFIG_MFD_88PM860X=y
CONFIG_MFD_MAX14577=y
CONFIG_MFD_MAX77686=y
# CONFIG_MFD_MAX77693 is not set
CONFIG_MFD_MAX8907=y
# CONFIG_MFD_MAX8925 is not set
CONFIG_MFD_MAX8997=y
CONFIG_MFD_MAX8998=y
CONFIG_EZX_PCAP=y
# CONFIG_MFD_RETU is not set
# CONFIG_MFD_PCF50633 is not set
CONFIG_MFD_RDC321X=y
CONFIG_MFD_RTSX_PCI=y
# CONFIG_MFD_RC5T583 is not set
# CONFIG_MFD_SEC_CORE is not set
CONFIG_MFD_SI476X_CORE=y
# CONFIG_MFD_SM501 is not set
# CONFIG_MFD_SMSC is not set
CONFIG_ABX500_CORE=y
CONFIG_AB3100_CORE=y
CONFIG_AB3100_OTP=y
CONFIG_MFD_STMPE=y

#
# STMicroelectronics STMPE Interface Drivers
#
CONFIG_STMPE_I2C=y
# CONFIG_STMPE_SPI is not set
CONFIG_MFD_SYSCON=y
CONFIG_MFD_TI_AM335X_TSCADC=y
# CONFIG_MFD_LP3943 is not set
# CONFIG_MFD_LP8788 is not set
# CONFIG_MFD_PALMAS is not set
CONFIG_TPS6105X=y
# CONFIG_TPS65010 is not set
# CONFIG_TPS6507X is not set
# CONFIG_MFD_TPS65090 is not set
CONFIG_MFD_TPS65217=y
CONFIG_MFD_TPS6586X=y
CONFIG_MFD_TPS65910=y
CONFIG_MFD_TPS65912=y
CONFIG_MFD_TPS65912_I2C=y
CONFIG_MFD_TPS65912_SPI=y
# CONFIG_MFD_TPS80031 is not set
CONFIG_TWL4030_CORE=y
# CONFIG_TWL4030_MADC is not set
CONFIG_MFD_TWL4030_AUDIO=y
# CONFIG_TWL6040_CORE is not set
CONFIG_MFD_WL1273_CORE=y
CONFIG_MFD_LM3533=y
CONFIG_MFD_TIMBERDALE=y
# CONFIG_MFD_TC3589X is not set
# CONFIG_MFD_TMIO is not set
# CONFIG_MFD_VX855 is not set
CONFIG_MFD_ARIZONA=y
# CONFIG_MFD_ARIZONA_I2C is not set
CONFIG_MFD_ARIZONA_SPI=y
# CONFIG_MFD_WM5102 is not set
CONFIG_MFD_WM5110=y
CONFIG_MFD_WM8997=y
CONFIG_MFD_WM8400=y
CONFIG_MFD_WM831X=y
CONFIG_MFD_WM831X_I2C=y
CONFIG_MFD_WM831X_SPI=y
# CONFIG_MFD_WM8350_I2C is not set
CONFIG_MFD_WM8994=y
CONFIG_REGULATOR=y
CONFIG_REGULATOR_DEBUG=y
CONFIG_REGULATOR_FIXED_VOLTAGE=y
CONFIG_REGULATOR_VIRTUAL_CONSUMER=y
CONFIG_REGULATOR_USERSPACE_CONSUMER=y
CONFIG_REGULATOR_88PM8607=y
CONFIG_REGULATOR_ACT8865=y
CONFIG_REGULATOR_AD5398=y
CONFIG_REGULATOR_ANATOP=y
CONFIG_REGULATOR_AB3100=y
# CONFIG_REGULATOR_AS3711 is not set
CONFIG_REGULATOR_DA9052=y
CONFIG_REGULATOR_DA9055=y
CONFIG_REGULATOR_DA9063=y
CONFIG_REGULATOR_DA9210=y
CONFIG_REGULATOR_FAN53555=y
# CONFIG_REGULATOR_GPIO is not set
CONFIG_REGULATOR_ISL6271A=y
CONFIG_REGULATOR_LP3971=y
CONFIG_REGULATOR_LP3972=y
# CONFIG_REGULATOR_LP872X is not set
CONFIG_REGULATOR_LP8755=y
CONFIG_REGULATOR_MAX14577=y
# CONFIG_REGULATOR_MAX1586 is not set
CONFIG_REGULATOR_MAX8649=y
CONFIG_REGULATOR_MAX8660=y
CONFIG_REGULATOR_MAX8907=y
CONFIG_REGULATOR_MAX8952=y
CONFIG_REGULATOR_MAX8973=y
CONFIG_REGULATOR_MAX8997=y
# CONFIG_REGULATOR_MAX8998 is not set
CONFIG_REGULATOR_MAX77686=y
CONFIG_REGULATOR_MC13XXX_CORE=y
# CONFIG_REGULATOR_MC13783 is not set
CONFIG_REGULATOR_MC13892=y
CONFIG_REGULATOR_PCAP=y
CONFIG_REGULATOR_PFUZE100=y
CONFIG_REGULATOR_TPS51632=y
CONFIG_REGULATOR_TPS6105X=y
CONFIG_REGULATOR_TPS62360=y
# CONFIG_REGULATOR_TPS65023 is not set
CONFIG_REGULATOR_TPS6507X=y
# CONFIG_REGULATOR_TPS65217 is not set
CONFIG_REGULATOR_TPS6524X=y
CONFIG_REGULATOR_TPS6586X=y
# CONFIG_REGULATOR_TPS65910 is not set
CONFIG_REGULATOR_TPS65912=y
# CONFIG_REGULATOR_TWL4030 is not set
CONFIG_REGULATOR_WM831X=y
CONFIG_REGULATOR_WM8400=y
CONFIG_REGULATOR_WM8994=y
# CONFIG_MEDIA_SUPPORT is not set

#
# Graphics support
#
CONFIG_AGP=y
CONFIG_AGP_ALI=y
# CONFIG_AGP_ATI is not set
# CONFIG_AGP_AMD is not set
CONFIG_AGP_AMD64=y
CONFIG_AGP_INTEL=y
CONFIG_AGP_NVIDIA=y
CONFIG_AGP_SIS=y
CONFIG_AGP_SWORKS=y
CONFIG_AGP_VIA=y
# CONFIG_AGP_EFFICEON is not set
CONFIG_INTEL_GTT=y
# CONFIG_VGA_ARB is not set
# CONFIG_VGA_SWITCHEROO is not set
CONFIG_DRM=y
CONFIG_DRM_KMS_HELPER=y
CONFIG_DRM_KMS_FB_HELPER=y
CONFIG_DRM_LOAD_EDID_FIRMWARE=y
CONFIG_DRM_TTM=y

#
# I2C encoder or helper chips
#
CONFIG_DRM_I2C_CH7006=y
# CONFIG_DRM_I2C_SIL164 is not set
CONFIG_DRM_I2C_NXP_TDA998X=y
CONFIG_DRM_TDFX=y
# CONFIG_DRM_R128 is not set
CONFIG_DRM_RADEON=y
# CONFIG_DRM_RADEON_UMS is not set
CONFIG_DRM_NOUVEAU=y
CONFIG_NOUVEAU_DEBUG=5
CONFIG_NOUVEAU_DEBUG_DEFAULT=3
CONFIG_DRM_NOUVEAU_BACKLIGHT=y
# CONFIG_DRM_I810 is not set
CONFIG_DRM_I915=y
CONFIG_DRM_I915_KMS=y
CONFIG_DRM_I915_FBDEV=y
CONFIG_DRM_I915_PRELIMINARY_HW_SUPPORT=y
# CONFIG_DRM_I915_UMS is not set
# CONFIG_DRM_MGA is not set
CONFIG_DRM_SIS=y
CONFIG_DRM_VIA=y
CONFIG_DRM_SAVAGE=y
# CONFIG_DRM_VMWGFX is not set
CONFIG_DRM_GMA500=y
# CONFIG_DRM_GMA600 is not set
# CONFIG_DRM_GMA3600 is not set
# CONFIG_DRM_UDL is not set
# CONFIG_DRM_AST is not set
CONFIG_DRM_MGAG200=y
CONFIG_DRM_CIRRUS_QEMU=y
# CONFIG_DRM_QXL is not set
# CONFIG_DRM_BOCHS is not set
# CONFIG_DRM_PTN3460 is not set
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
# CONFIG_FB_CIRRUS is not set
CONFIG_FB_PM2=y
# CONFIG_FB_PM2_FIFO_DISCONNECT is not set
# CONFIG_FB_CYBER2000 is not set
CONFIG_FB_ARC=y
CONFIG_FB_ASILIANT=y
# CONFIG_FB_IMSTT is not set
# CONFIG_FB_VGA16 is not set
# CONFIG_FB_VESA is not set
CONFIG_FB_N411=y
CONFIG_FB_HGA=y
CONFIG_FB_OPENCORES=y
CONFIG_FB_S1D13XXX=y
# CONFIG_FB_NVIDIA is not set
CONFIG_FB_RIVA=y
CONFIG_FB_RIVA_I2C=y
# CONFIG_FB_RIVA_DEBUG is not set
CONFIG_FB_RIVA_BACKLIGHT=y
CONFIG_FB_I740=y
CONFIG_FB_I810=y
# CONFIG_FB_I810_GTF is not set
# CONFIG_FB_LE80578 is not set
CONFIG_FB_MATROX=y
# CONFIG_FB_MATROX_MILLENIUM is not set
# CONFIG_FB_MATROX_MYSTIQUE is not set
# CONFIG_FB_MATROX_G is not set
CONFIG_FB_MATROX_I2C=y
# CONFIG_FB_RADEON is not set
# CONFIG_FB_ATY128 is not set
# CONFIG_FB_ATY is not set
CONFIG_FB_S3=y
# CONFIG_FB_S3_DDC is not set
CONFIG_FB_SAVAGE=y
CONFIG_FB_SAVAGE_I2C=y
CONFIG_FB_SAVAGE_ACCEL=y
CONFIG_FB_SIS=y
CONFIG_FB_SIS_300=y
CONFIG_FB_SIS_315=y
CONFIG_FB_VIA=y
# CONFIG_FB_VIA_DIRECT_PROCFS is not set
# CONFIG_FB_VIA_X_COMPATIBILITY is not set
# CONFIG_FB_NEOMAGIC is not set
CONFIG_FB_KYRO=y
CONFIG_FB_3DFX=y
CONFIG_FB_3DFX_ACCEL=y
# CONFIG_FB_3DFX_I2C is not set
CONFIG_FB_VOODOO1=y
CONFIG_FB_VT8623=y
# CONFIG_FB_TRIDENT is not set
CONFIG_FB_ARK=y
CONFIG_FB_PM3=y
# CONFIG_FB_CARMINE is not set
# CONFIG_FB_GEODE is not set
CONFIG_FB_TMIO=y
# CONFIG_FB_TMIO_ACCELL is not set
# CONFIG_FB_GOLDFISH is not set
CONFIG_FB_VIRTUAL=y
CONFIG_FB_METRONOME=y
# CONFIG_FB_MB862XX is not set
# CONFIG_FB_BROADSHEET is not set
# CONFIG_FB_AUO_K190X is not set
# CONFIG_FB_SIMPLE is not set
# CONFIG_EXYNOS_VIDEO is not set
CONFIG_BACKLIGHT_LCD_SUPPORT=y
# CONFIG_LCD_CLASS_DEVICE is not set
CONFIG_BACKLIGHT_CLASS_DEVICE=y
CONFIG_BACKLIGHT_GENERIC=y
CONFIG_BACKLIGHT_LM3533=y
CONFIG_BACKLIGHT_PWM=y
CONFIG_BACKLIGHT_DA9052=y
CONFIG_BACKLIGHT_APPLE=y
CONFIG_BACKLIGHT_SAHARA=y
CONFIG_BACKLIGHT_WM831X=y
CONFIG_BACKLIGHT_ADP5520=y
CONFIG_BACKLIGHT_ADP8860=y
CONFIG_BACKLIGHT_ADP8870=y
# CONFIG_BACKLIGHT_88PM860X is not set
# CONFIG_BACKLIGHT_LM3630A is not set
CONFIG_BACKLIGHT_LM3639=y
# CONFIG_BACKLIGHT_LP855X is not set
CONFIG_BACKLIGHT_PANDORA=y
CONFIG_BACKLIGHT_TPS65217=y
CONFIG_BACKLIGHT_AS3711=y
CONFIG_BACKLIGHT_GPIO=y
# CONFIG_BACKLIGHT_LV5207LP is not set
CONFIG_BACKLIGHT_BD6107=y
# CONFIG_LOGO is not set
# CONFIG_SOUND is not set

#
# HID support
#
CONFIG_HID=y
# CONFIG_HID_BATTERY_STRENGTH is not set
CONFIG_HIDRAW=y
# CONFIG_UHID is not set
# CONFIG_HID_GENERIC is not set

#
# Special HID drivers
#
CONFIG_HID_A4TECH=y
CONFIG_HID_ACRUX=y
CONFIG_HID_ACRUX_FF=y
CONFIG_HID_APPLE=y
CONFIG_HID_AUREAL=y
CONFIG_HID_BELKIN=y
CONFIG_HID_CHERRY=y
# CONFIG_HID_CHICONY is not set
CONFIG_HID_CYPRESS=y
CONFIG_HID_DRAGONRISE=y
CONFIG_DRAGONRISE_FF=y
CONFIG_HID_EMS_FF=y
CONFIG_HID_ELECOM=y
CONFIG_HID_EZKEY=y
CONFIG_HID_KEYTOUCH=y
CONFIG_HID_KYE=y
# CONFIG_HID_UCLOGIC is not set
CONFIG_HID_WALTOP=y
CONFIG_HID_GYRATION=y
# CONFIG_HID_ICADE is not set
CONFIG_HID_TWINHAN=y
# CONFIG_HID_KENSINGTON is not set
CONFIG_HID_LCPOWER=y
CONFIG_HID_LENOVO_TPKBD=y
CONFIG_HID_LOGITECH=y
# CONFIG_HID_LOGITECH_DJ is not set
# CONFIG_LOGITECH_FF is not set
CONFIG_LOGIRUMBLEPAD2_FF=y
# CONFIG_LOGIG940_FF is not set
# CONFIG_LOGIWHEELS_FF is not set
# CONFIG_HID_MAGICMOUSE is not set
CONFIG_HID_MICROSOFT=y
CONFIG_HID_MONTEREY=y
CONFIG_HID_MULTITOUCH=y
CONFIG_HID_ORTEK=y
CONFIG_HID_PANTHERLORD=y
CONFIG_PANTHERLORD_FF=y
# CONFIG_HID_PETALYNX is not set
CONFIG_HID_PICOLCD=y
# CONFIG_HID_PICOLCD_FB is not set
CONFIG_HID_PICOLCD_BACKLIGHT=y
CONFIG_HID_PICOLCD_LEDS=y
CONFIG_HID_PRIMAX=y
CONFIG_HID_SAITEK=y
# CONFIG_HID_SAMSUNG is not set
CONFIG_HID_SPEEDLINK=y
CONFIG_HID_STEELSERIES=y
# CONFIG_HID_SUNPLUS is not set
CONFIG_HID_GREENASIA=y
# CONFIG_GREENASIA_FF is not set
# CONFIG_HID_SMARTJOYPLUS is not set
CONFIG_HID_TIVO=y
# CONFIG_HID_TOPSEED is not set
CONFIG_HID_THINGM=y
CONFIG_HID_THRUSTMASTER=y
CONFIG_THRUSTMASTER_FF=y
CONFIG_HID_WACOM=y
CONFIG_HID_WIIMOTE=y
CONFIG_HID_XINMO=y
# CONFIG_HID_ZEROPLUS is not set
CONFIG_HID_ZYDACRON=y
CONFIG_HID_SENSOR_HUB=y

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
# CONFIG_AM335X_PHY_USB is not set
# CONFIG_SAMSUNG_USB2PHY is not set
# CONFIG_SAMSUNG_USB3PHY is not set
# CONFIG_USB_GPIO_VBUS is not set
# CONFIG_USB_RCAR_GEN2_PHY is not set
# CONFIG_USB_GADGET is not set
CONFIG_UWB=y
CONFIG_UWB_WHCI=y
# CONFIG_MMC is not set
# CONFIG_MEMSTICK is not set
CONFIG_NEW_LEDS=y
CONFIG_LEDS_CLASS=y

#
# LED drivers
#
CONFIG_LEDS_88PM860X=y
CONFIG_LEDS_LM3530=y
CONFIG_LEDS_LM3533=y
CONFIG_LEDS_LM3642=y
# CONFIG_LEDS_PCA9532 is not set
CONFIG_LEDS_GPIO=y
CONFIG_LEDS_LP3944=y
CONFIG_LEDS_LP55XX_COMMON=y
CONFIG_LEDS_LP5521=y
# CONFIG_LEDS_LP5523 is not set
# CONFIG_LEDS_LP5562 is not set
# CONFIG_LEDS_LP8501 is not set
# CONFIG_LEDS_CLEVO_MAIL is not set
CONFIG_LEDS_PCA955X=y
CONFIG_LEDS_PCA963X=y
CONFIG_LEDS_PCA9685=y
# CONFIG_LEDS_WM831X_STATUS is not set
CONFIG_LEDS_DA9052=y
CONFIG_LEDS_DAC124S085=y
CONFIG_LEDS_PWM=y
# CONFIG_LEDS_REGULATOR is not set
CONFIG_LEDS_BD2802=y
CONFIG_LEDS_INTEL_SS4200=y
CONFIG_LEDS_LT3593=y
CONFIG_LEDS_ADP5520=y
CONFIG_LEDS_DELL_NETBOOKS=y
CONFIG_LEDS_MC13783=y
CONFIG_LEDS_TCA6507=y
# CONFIG_LEDS_MAX8997 is not set
# CONFIG_LEDS_LM355x is not set
CONFIG_LEDS_OT200=y
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
# CONFIG_LEDS_TRIGGER_GPIO is not set
CONFIG_LEDS_TRIGGER_DEFAULT_ON=y

#
# iptables trigger is under Netfilter config (LED target)
#
# CONFIG_LEDS_TRIGGER_TRANSIENT is not set
CONFIG_LEDS_TRIGGER_CAMERA=y
CONFIG_ACCESSIBILITY=y
CONFIG_EDAC=y
# CONFIG_EDAC_LEGACY_SYSFS is not set
# CONFIG_EDAC_DEBUG is not set
CONFIG_EDAC_MM_EDAC=y
CONFIG_EDAC_AMD76X=y
# CONFIG_EDAC_E7XXX is not set
# CONFIG_EDAC_E752X is not set
# CONFIG_EDAC_I82875P is not set
# CONFIG_EDAC_I82975X is not set
# CONFIG_EDAC_I3000 is not set
CONFIG_EDAC_I3200=y
CONFIG_EDAC_X38=y
CONFIG_EDAC_I5400=y
CONFIG_EDAC_I82860=y
# CONFIG_EDAC_R82600 is not set
CONFIG_EDAC_I5000=y
CONFIG_EDAC_I5100=y
# CONFIG_EDAC_I7300 is not set
CONFIG_RTC_LIB=y
CONFIG_RTC_CLASS=y
CONFIG_RTC_HCTOSYS=y
# CONFIG_RTC_SYSTOHC is not set
CONFIG_RTC_HCTOSYS_DEVICE="rtc0"
CONFIG_RTC_DEBUG=y

#
# RTC interfaces
#
# CONFIG_RTC_INTF_SYSFS is not set
# CONFIG_RTC_INTF_DEV is not set
# CONFIG_RTC_DRV_TEST is not set

#
# I2C RTC drivers
#
# CONFIG_RTC_DRV_88PM860X is not set
CONFIG_RTC_DRV_DS1307=y
CONFIG_RTC_DRV_DS1374=y
CONFIG_RTC_DRV_DS1672=y
CONFIG_RTC_DRV_DS3232=y
CONFIG_RTC_DRV_MAX6900=y
CONFIG_RTC_DRV_MAX8907=y
# CONFIG_RTC_DRV_MAX8998 is not set
# CONFIG_RTC_DRV_MAX8997 is not set
CONFIG_RTC_DRV_MAX77686=y
CONFIG_RTC_DRV_RS5C372=y
CONFIG_RTC_DRV_ISL1208=y
CONFIG_RTC_DRV_ISL12022=y
CONFIG_RTC_DRV_ISL12057=y
# CONFIG_RTC_DRV_X1205 is not set
# CONFIG_RTC_DRV_PCF2127 is not set
# CONFIG_RTC_DRV_PCF8523 is not set
CONFIG_RTC_DRV_PCF8563=y
CONFIG_RTC_DRV_PCF8583=y
# CONFIG_RTC_DRV_M41T80 is not set
# CONFIG_RTC_DRV_BQ32K is not set
CONFIG_RTC_DRV_TWL4030=y
CONFIG_RTC_DRV_TPS6586X=y
# CONFIG_RTC_DRV_TPS65910 is not set
CONFIG_RTC_DRV_S35390A=y
# CONFIG_RTC_DRV_FM3130 is not set
# CONFIG_RTC_DRV_RX8581 is not set
# CONFIG_RTC_DRV_RX8025 is not set
CONFIG_RTC_DRV_EM3027=y
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
# CONFIG_RTC_DRV_RS5C348 is not set
CONFIG_RTC_DRV_DS3234=y
CONFIG_RTC_DRV_PCF2123=y
CONFIG_RTC_DRV_RX4581=y

#
# Platform RTC drivers
#
CONFIG_RTC_DRV_CMOS=y
# CONFIG_RTC_DRV_DS1286 is not set
CONFIG_RTC_DRV_DS1511=y
# CONFIG_RTC_DRV_DS1553 is not set
CONFIG_RTC_DRV_DS1742=y
CONFIG_RTC_DRV_DA9052=y
CONFIG_RTC_DRV_DA9055=y
CONFIG_RTC_DRV_STK17TA8=y
# CONFIG_RTC_DRV_M48T86 is not set
CONFIG_RTC_DRV_M48T35=y
CONFIG_RTC_DRV_M48T59=y
# CONFIG_RTC_DRV_MSM6242 is not set
# CONFIG_RTC_DRV_BQ4802 is not set
CONFIG_RTC_DRV_RP5C01=y
# CONFIG_RTC_DRV_V3020 is not set
# CONFIG_RTC_DRV_DS2404 is not set
CONFIG_RTC_DRV_WM831X=y
CONFIG_RTC_DRV_AB3100=y

#
# on-CPU RTC drivers
#
CONFIG_RTC_DRV_PCAP=y
# CONFIG_RTC_DRV_MC13XXX is not set
# CONFIG_RTC_DRV_MOXART is not set

#
# HID Sensor RTC drivers
#
CONFIG_DMADEVICES=y
# CONFIG_DMADEVICES_DEBUG is not set

#
# DMA Devices
#
CONFIG_INTEL_MID_DMAC=y
# CONFIG_INTEL_IOATDMA is not set
CONFIG_DW_DMAC_CORE=y
# CONFIG_DW_DMAC is not set
CONFIG_DW_DMAC_PCI=y
CONFIG_TIMB_DMA=y
CONFIG_PCH_DMA=y
CONFIG_DMA_ENGINE=y
CONFIG_DMA_ACPI=y

#
# DMA Clients
#
# CONFIG_ASYNC_TX_DMA is not set
CONFIG_DMATEST=y
# CONFIG_AUXDISPLAY is not set
CONFIG_UIO=y
# CONFIG_UIO_CIF is not set
# CONFIG_UIO_PDRV_GENIRQ is not set
CONFIG_UIO_DMEM_GENIRQ=y
CONFIG_UIO_AEC=y
CONFIG_UIO_SERCOS3=y
CONFIG_UIO_PCI_GENERIC=y
CONFIG_UIO_NETX=y
CONFIG_UIO_MF624=y
# CONFIG_VIRT_DRIVERS is not set
CONFIG_VIRTIO=y

#
# Virtio drivers
#
CONFIG_VIRTIO_PCI=y
CONFIG_VIRTIO_BALLOON=y
CONFIG_VIRTIO_MMIO=y
CONFIG_VIRTIO_MMIO_CMDLINE_DEVICES=y

#
# Microsoft Hyper-V guest support
#
CONFIG_STAGING=y
# CONFIG_SLICOSS is not set
CONFIG_ECHO=y
CONFIG_DX_SEP=y

#
# IIO staging drivers
#

#
# Accelerometers
#
CONFIG_ADIS16201=y
CONFIG_ADIS16203=y
# CONFIG_ADIS16204 is not set
# CONFIG_ADIS16209 is not set
CONFIG_ADIS16220=y
CONFIG_ADIS16240=y
CONFIG_LIS3L02DQ=y
# CONFIG_SCA3000 is not set

#
# Analog to digital converters
#
CONFIG_AD7291=y
CONFIG_AD7606=y
CONFIG_AD7606_IFACE_PARALLEL=y
CONFIG_AD7606_IFACE_SPI=y
CONFIG_AD799X=y
CONFIG_AD799X_RING_BUFFER=y
CONFIG_AD7780=y
# CONFIG_AD7816 is not set
# CONFIG_AD7192 is not set
CONFIG_AD7280=y
# CONFIG_LPC32XX_ADC is not set
CONFIG_MXS_LRADC=y
CONFIG_SPEAR_ADC=y

#
# Analog digital bi-direction converters
#
# CONFIG_ADT7316 is not set

#
# Capacitance to digital converters
#
# CONFIG_AD7150 is not set
CONFIG_AD7152=y
# CONFIG_AD7746 is not set

#
# Direct Digital Synthesis
#
CONFIG_AD5930=y
CONFIG_AD9832=y
# CONFIG_AD9834 is not set
CONFIG_AD9850=y
CONFIG_AD9852=y
CONFIG_AD9910=y
# CONFIG_AD9951 is not set

#
# Digital gyroscope sensors
#
CONFIG_ADIS16060=y

#
# Network Analyzer, Impedance Converters
#
# CONFIG_AD5933 is not set

#
# Light sensors
#
CONFIG_SENSORS_ISL29018=y
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
CONFIG_ADE7753=y
# CONFIG_ADE7754 is not set
CONFIG_ADE7758=y
CONFIG_ADE7759=y
CONFIG_ADE7854=y
CONFIG_ADE7854_I2C=y
# CONFIG_ADE7854_SPI is not set

#
# Resolver to digital converters
#
CONFIG_AD2S90=y
CONFIG_AD2S1200=y
CONFIG_AD2S1210=y

#
# Triggers - standalone
#
# CONFIG_IIO_PERIODIC_RTC_TRIGGER is not set
CONFIG_IIO_SIMPLE_DUMMY=y
# CONFIG_IIO_SIMPLE_DUMMY_EVENTS is not set
# CONFIG_IIO_SIMPLE_DUMMY_BUFFER is not set
# CONFIG_FB_SM7XX is not set
CONFIG_CRYSTALHD=y
CONFIG_FB_XGI=y
CONFIG_ACPI_QUICKSTART=y
# CONFIG_FT1000 is not set

#
# Speakup console speech
#
CONFIG_TOUCHSCREEN_CLEARPAD_TM1217=y
# CONFIG_TOUCHSCREEN_SYNAPTICS_I2C_RMI4 is not set
CONFIG_STAGING_MEDIA=y

#
# Android
#
# CONFIG_ANDROID is not set
# CONFIG_DGRP is not set
CONFIG_MTD_SPINAND_MT29F=y
CONFIG_MTD_SPINAND_ONDIEECC=y
# CONFIG_XILLYBUS is not set
# CONFIG_DGNC is not set
# CONFIG_DGAP is not set
CONFIG_X86_PLATFORM_DEVICES=y
# CONFIG_ACER_WMI is not set
CONFIG_ACERHDF=y
CONFIG_ASUS_LAPTOP=y
CONFIG_DELL_WMI=y
CONFIG_DELL_WMI_AIO=y
# CONFIG_FUJITSU_LAPTOP is not set
# CONFIG_FUJITSU_TABLET is not set
CONFIG_TC1100_WMI=y
CONFIG_HP_ACCEL=y
CONFIG_HP_WIRELESS=y
# CONFIG_HP_WMI is not set
CONFIG_PANASONIC_LAPTOP=y
CONFIG_THINKPAD_ACPI=y
# CONFIG_THINKPAD_ACPI_DEBUGFACILITIES is not set
CONFIG_THINKPAD_ACPI_DEBUG=y
CONFIG_THINKPAD_ACPI_UNSAFE_LEDS=y
# CONFIG_THINKPAD_ACPI_VIDEO is not set
# CONFIG_THINKPAD_ACPI_HOTKEY_POLL is not set
CONFIG_SENSORS_HDAPS=y
CONFIG_ACPI_WMI=y
CONFIG_MSI_WMI=y
# CONFIG_TOPSTAR_LAPTOP is not set
# CONFIG_ACPI_TOSHIBA is not set
CONFIG_TOSHIBA_BT_RFKILL=y
CONFIG_ACPI_CMPC=y
# CONFIG_INTEL_IPS is not set
CONFIG_IBM_RTL=y
# CONFIG_XO15_EBOOK is not set
# CONFIG_SAMSUNG_LAPTOP is not set
CONFIG_MXM_WMI=y
# CONFIG_SAMSUNG_Q10 is not set
CONFIG_APPLE_GMUX=y
CONFIG_INTEL_RST=y
CONFIG_INTEL_SMARTCONNECT=y
CONFIG_PVPANIC=y
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
CONFIG_REMOTEPROC=y
CONFIG_STE_MODEM_RPROC=y

#
# Rpmsg drivers
#
# CONFIG_PM_DEVFREQ is not set
CONFIG_EXTCON=y

#
# Extcon Device Drivers
#
# CONFIG_EXTCON_GPIO is not set
# CONFIG_EXTCON_ADC_JACK is not set
CONFIG_EXTCON_MAX14577=y
CONFIG_EXTCON_MAX8997=y
CONFIG_MEMORY=y
CONFIG_IIO=y
CONFIG_IIO_BUFFER=y
CONFIG_IIO_BUFFER_CB=y
CONFIG_IIO_KFIFO_BUF=y
CONFIG_IIO_TRIGGERED_BUFFER=y
CONFIG_IIO_TRIGGER=y
CONFIG_IIO_CONSUMERS_PER_TRIGGER=2

#
# Accelerometers
#
CONFIG_BMA180=y
# CONFIG_HID_SENSOR_ACCEL_3D is not set
CONFIG_IIO_ST_ACCEL_3AXIS=y
CONFIG_IIO_ST_ACCEL_I2C_3AXIS=y
CONFIG_IIO_ST_ACCEL_SPI_3AXIS=y
CONFIG_KXSD9=y

#
# Analog to digital converters
#
CONFIG_AD_SIGMA_DELTA=y
# CONFIG_AD7266 is not set
CONFIG_AD7298=y
# CONFIG_AD7476 is not set
# CONFIG_AD7791 is not set
CONFIG_AD7793=y
CONFIG_AD7887=y
CONFIG_AD7923=y
# CONFIG_MAX1363 is not set
# CONFIG_MCP320X is not set
# CONFIG_MCP3422 is not set
CONFIG_MEN_Z188_ADC=y
# CONFIG_NAU7802 is not set
CONFIG_TI_ADC081C=y
# CONFIG_TI_AM335X_ADC is not set
CONFIG_TWL6030_GPADC=y

#
# Amplifiers
#
CONFIG_AD8366=y

#
# Hid Sensor IIO Common
#
CONFIG_HID_SENSOR_IIO_COMMON=y
CONFIG_HID_SENSOR_IIO_TRIGGER=y
CONFIG_IIO_ST_SENSORS_I2C=y
CONFIG_IIO_ST_SENSORS_SPI=y
CONFIG_IIO_ST_SENSORS_CORE=y

#
# Digital to analog converters
#
CONFIG_AD5064=y
# CONFIG_AD5360 is not set
CONFIG_AD5380=y
CONFIG_AD5421=y
CONFIG_AD5446=y
CONFIG_AD5449=y
# CONFIG_AD5504 is not set
# CONFIG_AD5624R_SPI is not set
CONFIG_AD5686=y
CONFIG_AD5755=y
CONFIG_AD5764=y
# CONFIG_AD5791 is not set
# CONFIG_AD7303 is not set
# CONFIG_MAX517 is not set
CONFIG_MCP4725=y

#
# Frequency Synthesizers DDS/PLL
#

#
# Clock Generator/Distribution
#
CONFIG_AD9523=y

#
# Phase-Locked Loop (PLL) frequency synthesizers
#
CONFIG_ADF4350=y

#
# Digital gyroscope sensors
#
CONFIG_ADIS16080=y
CONFIG_ADIS16130=y
# CONFIG_ADIS16136 is not set
CONFIG_ADIS16260=y
# CONFIG_ADXRS450 is not set
CONFIG_HID_SENSOR_GYRO_3D=y
CONFIG_IIO_ST_GYRO_3AXIS=y
CONFIG_IIO_ST_GYRO_I2C_3AXIS=y
CONFIG_IIO_ST_GYRO_SPI_3AXIS=y
# CONFIG_ITG3200 is not set

#
# Humidity sensors
#
# CONFIG_DHT11 is not set

#
# Inertial measurement units
#
CONFIG_ADIS16400=y
# CONFIG_ADIS16480 is not set
CONFIG_IIO_ADIS_LIB=y
CONFIG_IIO_ADIS_LIB_BUFFER=y
# CONFIG_INV_MPU6050_IIO is not set

#
# Light sensors
#
# CONFIG_ADJD_S311 is not set
CONFIG_APDS9300=y
CONFIG_CM32181=y
CONFIG_CM36651=y
CONFIG_GP2AP020A00F=y
# CONFIG_HID_SENSOR_ALS is not set
CONFIG_SENSORS_LM3533=y
# CONFIG_TCS3472 is not set
# CONFIG_SENSORS_TSL2563 is not set
CONFIG_TSL4531=y
CONFIG_VCNL4000=y

#
# Magnetometer sensors
#
# CONFIG_AK8975 is not set
# CONFIG_MAG3110 is not set
# CONFIG_HID_SENSOR_MAGNETOMETER_3D is not set
CONFIG_IIO_ST_MAGN_3AXIS=y
CONFIG_IIO_ST_MAGN_I2C_3AXIS=y
CONFIG_IIO_ST_MAGN_SPI_3AXIS=y

#
# Inclinometer sensors
#
CONFIG_HID_SENSOR_INCLINOMETER_3D=y

#
# Triggers - standalone
#
CONFIG_IIO_INTERRUPT_TRIGGER=y
CONFIG_IIO_SYSFS_TRIGGER=y

#
# Pressure sensors
#
# CONFIG_MPL3115 is not set
# CONFIG_IIO_ST_PRESS is not set

#
# Temperature sensors
#
CONFIG_TMP006=y
# CONFIG_NTB is not set
# CONFIG_VME_BUS is not set
CONFIG_PWM=y
CONFIG_PWM_SYSFS=y
# CONFIG_PWM_RENESAS_TPU is not set
CONFIG_PWM_TWL=y
CONFIG_PWM_TWL_LED=y
CONFIG_IPACK_BUS=y
# CONFIG_BOARD_TPCI200 is not set
# CONFIG_SERIAL_IPOCTAL is not set
CONFIG_RESET_CONTROLLER=y
CONFIG_FMC=y
# CONFIG_FMC_FAKEDEV is not set
CONFIG_FMC_TRIVIAL=y
CONFIG_FMC_WRITE_EEPROM=y
CONFIG_FMC_CHARDEV=y

#
# PHY Subsystem
#
CONFIG_GENERIC_PHY=y
CONFIG_PHY_EXYNOS_MIPI_VIDEO=y
CONFIG_OMAP_CONTROL_PHY=y
CONFIG_BCM_KONA_USB2_PHY=y
CONFIG_PHY_SAMSUNG_USB2=y
CONFIG_POWERCAP=y
CONFIG_INTEL_RAPL=y
CONFIG_MCB=y
# CONFIG_MCB_PCI is not set

#
# Firmware Drivers
#
# CONFIG_EDD is not set
# CONFIG_FIRMWARE_MEMMAP is not set
# CONFIG_DELL_RBU is not set
# CONFIG_DCDBAS is not set
CONFIG_DMIID=y
CONFIG_DMI_SYSFS=y
CONFIG_DMI_SCAN_MACHINE_NON_EFI_FALLBACK=y
CONFIG_ISCSI_IBFT_FIND=y
# CONFIG_GOOGLE_FIRMWARE is not set

#
# File systems
#
CONFIG_DCACHE_WORD_ACCESS=y
CONFIG_FS_POSIX_ACL=y
CONFIG_EXPORTFS=y
# CONFIG_FILE_LOCKING is not set
CONFIG_FSNOTIFY=y
CONFIG_DNOTIFY=y
# CONFIG_INOTIFY_USER is not set
# CONFIG_FANOTIFY is not set
CONFIG_QUOTA=y
# CONFIG_QUOTA_NETLINK_INTERFACE is not set
# CONFIG_PRINT_QUOTA_WARNING is not set
CONFIG_QUOTA_DEBUG=y
CONFIG_QUOTA_TREE=y
CONFIG_QFMT_V1=y
CONFIG_QFMT_V2=y
CONFIG_QUOTACTL=y
CONFIG_AUTOFS4_FS=y
CONFIG_FUSE_FS=y
CONFIG_CUSE=y

#
# Caches
#
CONFIG_FSCACHE=y
CONFIG_FSCACHE_DEBUG=y

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
# CONFIG_MISC_FILESYSTEMS is not set
CONFIG_NETWORK_FILESYSTEMS=y
CONFIG_NLS=y
CONFIG_NLS_DEFAULT="iso8859-1"
CONFIG_NLS_CODEPAGE_437=y
CONFIG_NLS_CODEPAGE_737=y
CONFIG_NLS_CODEPAGE_775=y
CONFIG_NLS_CODEPAGE_850=y
CONFIG_NLS_CODEPAGE_852=y
# CONFIG_NLS_CODEPAGE_855 is not set
CONFIG_NLS_CODEPAGE_857=y
# CONFIG_NLS_CODEPAGE_860 is not set
CONFIG_NLS_CODEPAGE_861=y
CONFIG_NLS_CODEPAGE_862=y
CONFIG_NLS_CODEPAGE_863=y
# CONFIG_NLS_CODEPAGE_864 is not set
# CONFIG_NLS_CODEPAGE_865 is not set
# CONFIG_NLS_CODEPAGE_866 is not set
CONFIG_NLS_CODEPAGE_869=y
# CONFIG_NLS_CODEPAGE_936 is not set
CONFIG_NLS_CODEPAGE_950=y
# CONFIG_NLS_CODEPAGE_932 is not set
CONFIG_NLS_CODEPAGE_949=y
CONFIG_NLS_CODEPAGE_874=y
# CONFIG_NLS_ISO8859_8 is not set
CONFIG_NLS_CODEPAGE_1250=y
CONFIG_NLS_CODEPAGE_1251=y
CONFIG_NLS_ASCII=y
CONFIG_NLS_ISO8859_1=y
# CONFIG_NLS_ISO8859_2 is not set
CONFIG_NLS_ISO8859_3=y
CONFIG_NLS_ISO8859_4=y
CONFIG_NLS_ISO8859_5=y
CONFIG_NLS_ISO8859_6=y
# CONFIG_NLS_ISO8859_7 is not set
# CONFIG_NLS_ISO8859_9 is not set
CONFIG_NLS_ISO8859_13=y
CONFIG_NLS_ISO8859_14=y
# CONFIG_NLS_ISO8859_15 is not set
CONFIG_NLS_KOI8_R=y
CONFIG_NLS_KOI8_U=y
CONFIG_NLS_MAC_ROMAN=y
# CONFIG_NLS_MAC_CELTIC is not set
CONFIG_NLS_MAC_CENTEURO=y
CONFIG_NLS_MAC_CROATIAN=y
# CONFIG_NLS_MAC_CYRILLIC is not set
CONFIG_NLS_MAC_GAELIC=y
# CONFIG_NLS_MAC_GREEK is not set
CONFIG_NLS_MAC_ICELAND=y
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
# CONFIG_ENABLE_WARN_DEPRECATED is not set
# CONFIG_ENABLE_MUST_CHECK is not set
CONFIG_FRAME_WARN=1024
CONFIG_STRIP_ASM_SYMS=y
CONFIG_READABLE_ASM=y
# CONFIG_UNUSED_SYMBOLS is not set
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
# CONFIG_DEBUG_PAGEALLOC is not set
CONFIG_DEBUG_OBJECTS=y
CONFIG_DEBUG_OBJECTS_SELFTEST=y
# CONFIG_DEBUG_OBJECTS_FREE is not set
# CONFIG_DEBUG_OBJECTS_TIMERS is not set
# CONFIG_DEBUG_OBJECTS_WORK is not set
CONFIG_DEBUG_OBJECTS_RCU_HEAD=y
# CONFIG_DEBUG_OBJECTS_PERCPU_COUNTER is not set
CONFIG_DEBUG_OBJECTS_ENABLE_DEFAULT=1
CONFIG_DEBUG_SLAB=y
CONFIG_DEBUG_SLAB_LEAK=y
CONFIG_HAVE_DEBUG_KMEMLEAK=y
# CONFIG_DEBUG_KMEMLEAK is not set
CONFIG_DEBUG_STACK_USAGE=y
# CONFIG_DEBUG_VM is not set
# CONFIG_DEBUG_VIRTUAL is not set
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
# CONFIG_PANIC_ON_OOPS is not set
CONFIG_PANIC_ON_OOPS_VALUE=0
CONFIG_PANIC_TIMEOUT=0

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
CONFIG_LOCK_STAT=y
# CONFIG_DEBUG_LOCKDEP is not set
CONFIG_DEBUG_ATOMIC_SLEEP=y
# CONFIG_DEBUG_LOCKING_API_SELFTESTS is not set
# CONFIG_LOCK_TORTURE_TEST is not set
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
CONFIG_SPARSE_RCU_POINTER=y
# CONFIG_TORTURE_TEST is not set
# CONFIG_RCU_TORTURE_TEST is not set
CONFIG_RCU_CPU_STALL_TIMEOUT=21
CONFIG_RCU_TRACE=y
CONFIG_NOTIFIER_ERROR_INJECTION=y
CONFIG_FAULT_INJECTION=y
# CONFIG_FAILSLAB is not set
CONFIG_FAIL_PAGE_ALLOC=y
CONFIG_FAULT_INJECTION_DEBUG_FS=y
# CONFIG_FAULT_INJECTION_STACKTRACE_FILTER is not set
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
# CONFIG_IRQSOFF_TRACER is not set
# CONFIG_SCHED_TRACER is not set
# CONFIG_FTRACE_SYSCALLS is not set
CONFIG_TRACER_SNAPSHOT=y
# CONFIG_TRACER_SNAPSHOT_PER_CPU_SWAP is not set
CONFIG_TRACE_BRANCH_PROFILING=y
# CONFIG_BRANCH_PROFILE_NONE is not set
CONFIG_PROFILE_ANNOTATED_BRANCHES=y
# CONFIG_PROFILE_ALL_BRANCHES is not set
# CONFIG_BRANCH_TRACER is not set
# CONFIG_STACK_TRACER is not set
CONFIG_UPROBE_EVENT=y
CONFIG_PROBE_EVENTS=y
# CONFIG_DYNAMIC_FTRACE is not set
# CONFIG_FUNCTION_PROFILER is not set
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
CONFIG_ATOMIC64_SELFTEST=y
# CONFIG_TEST_STRING_HELPERS is not set
# CONFIG_TEST_KSTRTOX is not set
CONFIG_PROVIDE_OHCI1394_DMA_INIT=y
# CONFIG_BUILD_DOCSRC is not set
# CONFIG_DMA_API_DEBUG is not set
# CONFIG_SAMPLES is not set
CONFIG_HAVE_ARCH_KGDB=y
# CONFIG_KGDB is not set
# CONFIG_STRICT_DEVMEM is not set
CONFIG_X86_VERBOSE_BOOTUP=y
CONFIG_EARLY_PRINTK=y
# CONFIG_EARLY_PRINTK_DBGP is not set
CONFIG_X86_PTDUMP=y
# CONFIG_DEBUG_RODATA is not set
# CONFIG_DOUBLEFAULT is not set
# CONFIG_DEBUG_TLBFLUSH is not set
# CONFIG_IOMMU_STRESS is not set
CONFIG_HAVE_MMIOTRACE_SUPPORT=y
CONFIG_IO_DELAY_TYPE_0X80=0
CONFIG_IO_DELAY_TYPE_0XED=1
CONFIG_IO_DELAY_TYPE_UDELAY=2
CONFIG_IO_DELAY_TYPE_NONE=3
# CONFIG_IO_DELAY_0X80 is not set
CONFIG_IO_DELAY_0XED=y
# CONFIG_IO_DELAY_UDELAY is not set
# CONFIG_IO_DELAY_NONE is not set
CONFIG_DEFAULT_IO_DELAY_TYPE=1
CONFIG_DEBUG_BOOT_PARAMS=y
# CONFIG_CPA_DEBUG is not set
# CONFIG_OPTIMIZE_INLINING is not set
# CONFIG_X86_DEBUG_STATIC_CPU_HAS is not set

#
# Security options
#
CONFIG_KEYS=y
CONFIG_PERSISTENT_KEYRINGS=y
CONFIG_BIG_KEYS=y
CONFIG_TRUSTED_KEYS=y
CONFIG_ENCRYPTED_KEYS=y
CONFIG_KEYS_DEBUG_PROC_KEYS=y
CONFIG_SECURITY_DMESG_RESTRICT=y
CONFIG_SECURITY=y
CONFIG_SECURITYFS=y
CONFIG_SECURITY_NETWORK=y
CONFIG_SECURITY_PATH=y
# CONFIG_SECURITY_TOMOYO is not set
# CONFIG_SECURITY_APPARMOR is not set
CONFIG_SECURITY_YAMA=y
CONFIG_SECURITY_YAMA_STACKED=y
CONFIG_INTEGRITY=y
# CONFIG_INTEGRITY_SIGNATURE is not set
# CONFIG_IMA is not set
CONFIG_EVM=y
CONFIG_EVM_HMAC_VERSION=2
CONFIG_DEFAULT_SECURITY_YAMA=y
# CONFIG_DEFAULT_SECURITY_DAC is not set
CONFIG_DEFAULT_SECURITY="yama"
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
CONFIG_CRYPTO_WORKQUEUE=y
CONFIG_CRYPTO_CRYPTD=y
CONFIG_CRYPTO_AUTHENC=y
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
# CONFIG_CRYPTO_PCBC is not set
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
CONFIG_CRYPTO_RMD160=y
# CONFIG_CRYPTO_RMD256 is not set
CONFIG_CRYPTO_RMD320=y
CONFIG_CRYPTO_SHA1=y
CONFIG_CRYPTO_SHA256=y
# CONFIG_CRYPTO_SHA512 is not set
CONFIG_CRYPTO_TGR192=y
CONFIG_CRYPTO_WP512=y

#
# Ciphers
#
CONFIG_CRYPTO_AES=y
CONFIG_CRYPTO_AES_586=y
CONFIG_CRYPTO_AES_NI_INTEL=y
CONFIG_CRYPTO_ANUBIS=y
# CONFIG_CRYPTO_ARC4 is not set
CONFIG_CRYPTO_BLOWFISH=y
CONFIG_CRYPTO_BLOWFISH_COMMON=y
# CONFIG_CRYPTO_CAMELLIA is not set
CONFIG_CRYPTO_CAST_COMMON=y
CONFIG_CRYPTO_CAST5=y
CONFIG_CRYPTO_CAST6=y
CONFIG_CRYPTO_DES=y
CONFIG_CRYPTO_FCRYPT=y
CONFIG_CRYPTO_KHAZAD=y
CONFIG_CRYPTO_SALSA20=y
CONFIG_CRYPTO_SALSA20_586=y
CONFIG_CRYPTO_SEED=y
CONFIG_CRYPTO_SERPENT=y
CONFIG_CRYPTO_SERPENT_SSE2_586=y
# CONFIG_CRYPTO_TEA is not set
CONFIG_CRYPTO_TWOFISH=y
CONFIG_CRYPTO_TWOFISH_COMMON=y
# CONFIG_CRYPTO_TWOFISH_586 is not set

#
# Compression
#
CONFIG_CRYPTO_DEFLATE=y
CONFIG_CRYPTO_ZLIB=y
CONFIG_CRYPTO_LZO=y
CONFIG_CRYPTO_LZ4=y
# CONFIG_CRYPTO_LZ4HC is not set

#
# Random Number Generation
#
# CONFIG_CRYPTO_ANSI_CPRNG is not set
# CONFIG_CRYPTO_USER_API_HASH is not set
# CONFIG_CRYPTO_USER_API_SKCIPHER is not set
CONFIG_CRYPTO_HASH_INFO=y
# CONFIG_CRYPTO_HW is not set
CONFIG_ASYMMETRIC_KEY_TYPE=y
CONFIG_ASYMMETRIC_PUBLIC_KEY_SUBTYPE=y
CONFIG_PUBLIC_KEY_ALGO_RSA=y
CONFIG_X509_CERTIFICATE_PARSER=y
CONFIG_HAVE_KVM=y
CONFIG_VIRTUALIZATION=y
# CONFIG_KVM is not set
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
CONFIG_STMP_DEVICE=y
CONFIG_PERCPU_RWSEM=y
CONFIG_CRC_CCITT=y
CONFIG_CRC16=y
# CONFIG_CRC_T10DIF is not set
CONFIG_CRC_ITU_T=y
CONFIG_CRC32=y
# CONFIG_CRC32_SELFTEST is not set
# CONFIG_CRC32_SLICEBY8 is not set
CONFIG_CRC32_SLICEBY4=y
# CONFIG_CRC32_SARWATE is not set
# CONFIG_CRC32_BIT is not set
# CONFIG_CRC7 is not set
CONFIG_LIBCRC32C=y
CONFIG_CRC8=y
CONFIG_RANDOM32_SELFTEST=y
CONFIG_ZLIB_INFLATE=y
CONFIG_ZLIB_DEFLATE=y
CONFIG_LZO_COMPRESS=y
CONFIG_LZO_DECOMPRESS=y
CONFIG_LZ4_COMPRESS=y
CONFIG_LZ4_DECOMPRESS=y
CONFIG_XZ_DEC=y
CONFIG_XZ_DEC_X86=y
# CONFIG_XZ_DEC_POWERPC is not set
CONFIG_XZ_DEC_IA64=y
# CONFIG_XZ_DEC_ARM is not set
CONFIG_XZ_DEC_ARMTHUMB=y
# CONFIG_XZ_DEC_SPARC is not set
CONFIG_XZ_DEC_BCJ=y
CONFIG_XZ_DEC_TEST=y
CONFIG_DECOMPRESS_GZIP=y
CONFIG_DECOMPRESS_BZIP2=y
CONFIG_DECOMPRESS_LZ4=y
CONFIG_REED_SOLOMON=y
CONFIG_REED_SOLOMON_DEC16=y
CONFIG_BCH=y
CONFIG_BCH_CONST_PARAMS=y
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
CONFIG_CORDIC=y
CONFIG_DDR=y
CONFIG_MPILIB=y
CONFIG_OID_REGISTRY=y

--zYM0uCDKw75PZbzx--
