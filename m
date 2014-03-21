Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965092AbaCUCJl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Mar 2014 22:09:41 -0400
Received: from mga02.intel.com ([134.134.136.20]:45633 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934057AbaCUCJh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Mar 2014 22:09:37 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,700,1389772800"; 
   d="scan'208";a="504257370"
Date: Fri, 21 Mar 2014 10:09:30 +0800
From: Fengguang Wu <fengguang.wu@intel.com>
To: Bjorn Helgaas <bhelgaas@google.com>
Cc: "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Daniel Vetter <daniel.vetter@ffwll.ch>,
        Alex Deucher <alexander.deucher@amd.com>,
        DRI mailing list <dri-devel@lists.freedesktop.org>,
        Stephane Eranian <eranian@google.com>
Subject: Re: [pci] WARNING: CPU: 0 PID: 1 at drivers/gpu/drm/drm_crtc.c:94
 drm_warn_on_modeset_not_all_locked()
Message-ID: <20140321020930.GA11451@localhost>
References: <20140320124143.GA10751@localhost>
 <CAErSpo7i1sD=mNd1MZ+yWrPrPJDpZx2w-L3Dj=2N+gJBqVdSzA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="fdj2RfSjLxBAspz7"
Content-Disposition: inline
In-Reply-To: <CAErSpo7i1sD=mNd1MZ+yWrPrPJDpZx2w-L3Dj=2N+gJBqVdSzA@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--fdj2RfSjLxBAspz7
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

// CC Stephane for RAPL related bug

Bjorn, sorry this bug report is mis-titled. The only new bug that show
up in aa11fc58dc is on rapl_pmu_init. And it shows up only 1 time, so
it's hard to reproduce and the bisect is likely not accurate.  I'll
retry the bisect with more repeat count. Sorry for the disturbing!

[    2.812392] Unpacking initramfs...
[    2.812392] Unpacking initramfs...
[    4.937582] Freeing initrd memory: 3276K (93cbd000 - 93ff0000)
[    4.937582] Freeing initrd memory: 3276K (93cbd000 - 93ff0000)
[    4.952113] BUG: unable to handle kernel
[    4.952113] BUG: unable to handle kernel NULL pointer dereferenceNULL pointer dereference at 0000003c
 at 0000003c
[    4.952871] IP:
[    4.952871] IP: [<81c439fb>] rapl_pmu_init+0xed/0x165
 [<81c439fb>] rapl_pmu_init+0xed/0x165
[    4.954190] *pde = 00000000
[    4.954190] *pde = 00000000

[    4.954619] Oops: 0000 [#1]
[    4.954619] Oops: 0000 [#1]

[    4.955440] CPU: 0 PID: 1 Comm: swapper Not tainted 3.14.0-rc1-00023-gaa11fc5 #1
[    4.955440] CPU: 0 PID: 1 Comm: swapper Not tainted 3.14.0-rc1-00023-gaa11fc5 #1
[    4.956050] Hardware name: Bochs Bochs, BIOS Bochs 01/01/2011                   
[    4.956050] Hardware name: Bochs Bochs, BIOS Bochs 01/01/2011
[    4.956672] task: 80030c20 ti: 80032000 task.ti: 80032000    
[    4.956672] task: 80030c20 ti: 80032000 task.ti: 80032000
[    4.957295] EIP: 0060:[<81c439fb>] EFLAGS: 00000246 CPU: 0
[    4.957295] EIP: 0060:[<81c439fb>] EFLAGS: 00000246 CPU: 0
[    4.957831] EIP is at rapl_pmu_init+0xed/0x165
[    4.957831] EIP is at rapl_pmu_init+0xed/0x165

Full dmesg attached.

Thanks,
Fengguang

On Thu, Mar 20, 2014 at 04:50:08PM -0600, Bjorn Helgaas wrote:
> On Thu, Mar 20, 2014 at 6:41 AM, Fengguang Wu <fengguang.wu@intel.com> wrote:
> > Greetings,
> >
> > I got the below dmesg and the first bad commit is
> >
> > git://git.kernel.org/pub/scm/linux/kernel/git/helgaas/pci.git pci/resource
> >
> > commit aa11fc58dc71c27701b1f9a529a36a38d4337722
> > Author:     Bjorn Helgaas <bhelgaas@google.com>
> > AuthorDate: Fri Mar 7 13:39:01 2014 -0700
> > Commit:     Bjorn Helgaas <bhelgaas@google.com>
> > CommitDate: Wed Mar 19 15:00:16 2014 -0600
> >
> >     PCI: Check all IORESOURCE_TYPE_BITS in pci_bus_alloc_from_region()
> >
> >     When allocating space from a bus resource, i.e., from apertures leading to
> >     this bus, make sure the entire resource type matches.  The previous code
> >     assumed the IORESOURCE_TYPE_BITS field was a bitmask with only a single bit
> >     set, but this is not true.  IORESOURCE_TYPE_BITS is really an enumeration,
> >     and we have to check all the bits.
> >
> >     See 72dcb1197228 ("resources: Add register address resource type").
> >
> >     No functional change.  If we used this path for allocating IRQs, DMA
> >     channels, or bus numbers, this would fix a bug because those types are
> >     indistinguishable when masked by IORESOURCE_IO | IORESOURCE_MEM.  But we
> >     don't, so this shouldn't make any difference.
> >
> >     Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
> 
> Thanks (I think).  I'm afraid I'm going to need some more help to
> debug this.  I built aa11fc58dc with the config you supplied and
> booted it on qemu with no real issues (it didn't boot all the way
> because the config doesn't include a driver for my root disk, but
> that's to be expected).
> 
> The dmesg you supplied is for some other commit 2d18516 that I don't
> have, so I'm confused about why it's not from aa11fc58dc.
> 
> I did reproduce what appears to be basically the same problem with
> a654dc797f3e, which is the 20140320 linux-next tree.  I backed up to
> 93ecdc077282, which is where pci/next was merged (this includes
> aa11fc58dc), but I could not reproduce the problem there.
> 
> So bottom line, I'm confused because your bisection doesn't match what
> I'm seeing, and I don't want to spend more time flailing around.
> 
> Bjorn
> 
> 
> > +------------------------------------------------------------------------------------------------+------------+------------+
> > |                                                                                                | aa11fc58dc | 2d18516523 |
> > +------------------------------------------------------------------------------------------------+------------+------------+
> > | boot_successes                                                                                 | 19         | 0          |
> > | boot_failures                                                                                  | 1          | 19         |
> > | BUG:unable_to_handle_kernel_NULL_pointer_dereference                                           | 1          | 1          |
> > | Oops                                                                                           | 1          | 1          |
> > | EIP_is_at_rapl_pmu_init                                                                        | 1          | 1          |
> > | Kernel_panic-not_syncing:Attempted_to_kill_init_exitcode=                                      | 1          | 1          |
> > | backtrace:rapl_pmu_init                                                                        | 1          | 1          |
> > | backtrace:kernel_init_freeable                                                                 | 1          | 19         |
> > | WARNING:CPU:PID:at_drivers/gpu/drm/drm_crtc.c:drm_warn_on_modeset_not_all_locked()             | 0          | 18         |
> > | WARNING:CPU:PID:at_drivers/gpu/drm/drm_crtc_helper.c:drm_helper_encoder_in_use()               | 0          | 18         |
> > | WARNING:CPU:PID:at_drivers/gpu/drm/drm_crtc_helper.c:drm_helper_crtc_in_use()                  | 0          | 18         |
> > | WARNING:CPU:PID:at_drivers/gpu/drm/drm_crtc_helper.c:drm_helper_probe_single_connector_modes() | 0          | 18         |
> > | WARNING:CPU:PID:at_drivers/gpu/drm/drm_modes.c:drm_mode_probed_add()                           | 0          | 18         |
> > | WARNING:CPU:PID:at_drivers/gpu/drm/drm_modes.c:drm_mode_connector_list_update()                | 0          | 18         |
> > | backtrace:drm_helper_disable_unused_functions                                                  | 0          | 18         |
> > | backtrace:cirrus_fbdev_init                                                                    | 0          | 18         |
> > | backtrace:cirrus_modeset_init                                                                  | 0          | 18         |
> > | backtrace:__pci_register_driver                                                                | 0          | 18         |
> > | backtrace:drm_pci_init                                                                         | 0          | 18         |
> > | backtrace:cirrus_init                                                                          | 0          | 18         |
> > | backtrace:drm_fb_helper_initial_config                                                         | 0          | 18         |
> > +------------------------------------------------------------------------------------------------+------------+------------+
> >
> > [    1.624247] [TTM] Initializing pool allocator
> > [    1.625248] ------------[ cut here ]------------
> > [    1.625248] ------------[ cut here ]------------
> > [    1.626136] WARNING: CPU: 0 PID: 1 at drivers/gpu/drm/drm_crtc.c:94 drm_warn_on_modeset_not_all_locked+0x61/0xc6()
> >
> > git bisect start 2d1851652373730f6b8c7fa7f45eaa854f23da8f dcb99fd9b08cfe1afe426af4d8d3cbc429190f15 --
> > git bisect  bad 82202f95148065d7a0f5d86d4d6e39f31dbd7937  # 12:19      0-     10  Merge 'asoc/fix/cs42l51' into devel-hourly-2014032007
> > git bisect good 9115e0b3218bd6b97e830bc36e6e80c4890f6fe4  # 12:45     20+      0  Merge 'scsi/misc' into devel-hourly-2014032007
> > git bisect good 4fb88b0dc2d9b229d03a9e6555d9056888c90137  # 14:42     20+      0  Merge 'target/for-next' into devel-hourly-2014032007
> > git bisect  bad c5011f998a8e94c052c5aa71cf19510f2d0bf5fd  # 15:06      0-      1  Merge 'pci/pci/resource' into devel-hourly-2014032007
> > git bisect good daec480a6e6be6e9716a56029aafcbfb79e6b47b  # 15:41     20+      0  Merge 'netdev-next/master' into devel-hourly-2014032007
> > git bisect good 937441ae220fd3fae143ef394227337c969ad155  # 15:57     20+      0  Merge 'kvm/queue' into devel-hourly-2014032007
> > git bisect good 3cedcc3621289d41bd21c5dbe0b886d57c83a1ea  # 16:27     20+      0  PCI: Don't enable decoding if BAR hasn't been assigned an address
> > git bisect good d75332325389a95c4ddbfa0f0cd7e5e08a54aa43  # 16:54     20+      0  s390/PCI: Use generic pci_enable_resources()
> > git bisect  bad aa11fc58dc71c27701b1f9a529a36a38d4337722  # 17:11      0-      1  PCI: Check all IORESOURCE_TYPE_BITS in pci_bus_alloc_from_region()
> > git bisect good 6404e88e8385638123f4b18b104430480870601a  # 17:23     20+      0  resources: Set type in __request_region()
> > # first bad commit: [aa11fc58dc71c27701b1f9a529a36a38d4337722] PCI: Check all IORESOURCE_TYPE_BITS in pci_bus_alloc_from_region()
> > git bisect good 6404e88e8385638123f4b18b104430480870601a  # 17:27     60+      0  resources: Set type in __request_region()
> > git bisect  bad 2d1851652373730f6b8c7fa7f45eaa854f23da8f  # 17:27      0-     19  0day head guard for 'devel-hourly-2014032007'
> > git bisect good 887843961c4b4681ee993c36d4997bf4b4aa8253  # 19:24     60+      0  mm: fix bad rss-counter if remap_file_pages raced migration
> > git bisect  bad a654dc797f3ea1cb5719a71a17af35f57fddb2d8  # 20:10      0-      1  Add linux-next specific files for 20140320
> >
> > Thanks,
> > Fengguang

--fdj2RfSjLxBAspz7
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="dmesg-yocto-waimea-3:20140320171051:i386-randconfig-nh0-03200538:3.14.0-rc1-00023-gaa11fc5:1"
Content-Transfer-Encoding: quoted-printable

early console in setup code
early console in decompress_kernel

Decompressing Linux... Parsing ELF... No relocation needed... done.
Booting the kernel.
[    0.000000] Initializing cgroup subsys cpu
[    0.000000] Linux version 3.14.0-rc1-00023-gaa11fc5 (kbuild@inn) (gcc ve=
rsion 4.8.2 (Debian 4.8.2-16) ) #1 Thu Mar 20 17:09:34 CST 2014
[    0.000000] e820: BIOS-provided physical RAM map:
[    0.000000] BIOS-e820: [mem 0x0000000000000000-0x000000000009fbff] usable
[    0.000000] BIOS-e820: [mem 0x000000000009fc00-0x000000000009ffff] reser=
ved
[    0.000000] BIOS-e820: [mem 0x00000000000f0000-0x00000000000fffff] reser=
ved
[    0.000000] BIOS-e820: [mem 0x0000000000100000-0x0000000013ffdfff] usable
[    0.000000] BIOS-e820: [mem 0x0000000013ffe000-0x0000000013ffffff] reser=
ved
[    0.000000] BIOS-e820: [mem 0x00000000fffc0000-0x00000000ffffffff] reser=
ved
[    0.000000] bootconsole [earlyser0] enabled
[    0.000000] Notice: NX (Execute Disable) protection cannot be enabled: n=
on-PAE kernel!
[    0.000000] SMBIOS 2.4 present.
[    0.000000] DMI: Bochs Bochs, BIOS Bochs 01/01/2011
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
[    0.000000] BRK [0x02207000, 0x02207fff] PGTABLE
[    0.000000] RAMDISK: [mem 0x13cbd000-0x13feffff]
[    0.000000] ACPI: RSDP 000fd930 000014 (v00 BOCHS )
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
[    0.000000] 319MB LOWMEM available.
[    0.000000]   mapped low ram: 0 - 13ffe000
[    0.000000]   low ram: 0 - 13ffe000
[    0.000000] Zone ranges:
[    0.000000]   Normal   [mem 0x00001000-0x13ffdfff]
[    0.000000] Movable zone start for each node
[    0.000000] Early memory node ranges
[    0.000000]   node   0: [mem 0x00001000-0x0009efff]
[    0.000000]   node   0: [mem 0x00100000-0x13ffdfff]
[    0.000000] On node 0 totalpages: 81820
[    0.000000] free_area_init_node: node 0, pgdat 81c07ffc, node_mem_map 93=
a3d020
[    0.000000]   Normal zone: 640 pages used for memmap
[    0.000000]   Normal zone: 0 pages reserved
[    0.000000]   Normal zone: 81820 pages, LIFO batch:15
[    0.000000] ACPI: PM-Timer IO Port: 0xb008
[    0.000000] ACPI: HPET id: 0x8086a201 base: 0xfed00000
[    0.000000] e820: [mem 0x14000000-0xfffbffff] available for PCI devices
[    0.000000] Booting paravirtualized kernel on bare hardware
[    0.000000] pcpu-alloc: s0 r0 d32768 u32768 alloc=3D1*32768
[    0.000000] pcpu-alloc: [0] 0=20
[    0.000000] Built 1 zonelists in Zone order, mobility grouping on.  Tota=
l pages: 81180
[    0.000000] Kernel command line: hung_task_panic=3D1 earlyprintk=3DttyS0=
,115200 debug apic=3Ddebug sysrq_always_enabled rcupdate.rcu_cpu_stall_time=
out=3D100 panic=3D10 softlockup_panic=3D1 nmi_watchdog=3Dpanic  prompt_ramd=
isk=3D0 console=3DttyS0,115200 console=3Dtty0 vga=3Dnormal  root=3D/dev/ram=
0 rw link=3D/kernel-tests/run-queue/kvm/i386-randconfig-nh0-03200538/linux-=
devel:devel-hourly-2014032007:aa11fc58dc71c27701b1f9a529a36a38d4337722:bise=
ct-linux7/.vmlinuz-aa11fc58dc71c27701b1f9a529a36a38d4337722-20140320171009-=
13-waimea branch=3Dlinux-devel/devel-hourly-2014032007 BOOT_IMAGE=3D/kernel=
/i386-randconfig-nh0-03200538/aa11fc58dc71c27701b1f9a529a36a38d4337722/vmli=
nuz-3.14.0-rc1-00023-gaa11fc5 drbd.minor_count=3D8
[    0.000000] sysrq: sysrq always enabled.
[    0.000000] PID hash table entries: 2048 (order: 1, 8192 bytes)
[    0.000000] Dentry cache hash table entries: 65536 (order: 6, 262144 byt=
es)
[    0.000000] Inode-cache hash table entries: 32768 (order: 5, 131072 byte=
s)
[    0.000000] Initializing CPU#0
[    0.000000] Memory: 302428K/327280K available (6902K kernel code, 2341K =
rwdata, 3272K rodata, 560K init, 5332K bss, 24852K reserved)
[    0.000000] virtual kernel memory layout:
[    0.000000]     fixmap  : 0xfffe1000 - 0xfffff000   ( 120 kB)
[    0.000000]     vmalloc : 0x947fe000 - 0xfffdf000   (1719 MB)
[    0.000000]     lowmem  : 0x80000000 - 0x93ffe000   ( 319 MB)
[    0.000000]       .init : 0x81c3b000 - 0x81cc7000   ( 560 kB)
[    0.000000]       .data : 0x816bde9e - 0x81c3a700   (5618 kB)
[    0.000000]       .text : 0x81000000 - 0x816bde9e   (6903 kB)
[    0.000000] Checking if this processor honours the WP bit even in superv=
isor mode...Ok.
[    0.000000] NR_IRQS:16 nr_irqs:16 16
[    0.000000] CPU 0 irqstacks, hard=3D80096000 soft=3D80080000
[    0.000000] ACPI: Core revision 20131218
[    0.000000] ACPI: All ACPI Tables successfully acquired
[    0.000000] ACPI: setting ELCR to 0200 (from 0c00)
[    0.000000] Initializing cgroup subsys cpu
[    0.000000] Linux version 3.14.0-rc1-00023-gaa11fc5 (kbuild@inn) (gcc ve=
rsion 4.8.2 (Debian 4.8.2-16) ) #1 Thu Mar 20 17:09:34 CST 2014
[    0.000000] e820: BIOS-provided physical RAM map:
[    0.000000] BIOS-e820: [mem 0x0000000000000000-0x000000000009fbff] usable
[    0.000000] BIOS-e820: [mem 0x000000000009fc00-0x000000000009ffff] reser=
ved
[    0.000000] BIOS-e820: [mem 0x00000000000f0000-0x00000000000fffff] reser=
ved
[    0.000000] BIOS-e820: [mem 0x0000000000100000-0x0000000013ffdfff] usable
[    0.000000] BIOS-e820: [mem 0x0000000013ffe000-0x0000000013ffffff] reser=
ved
[    0.000000] BIOS-e820: [mem 0x00000000fffc0000-0x00000000ffffffff] reser=
ved
[    0.000000] bootconsole [earlyser0] enabled
[    0.000000] Notice: NX (Execute Disable) protection cannot be enabled: n=
on-PAE kernel!
[    0.000000] SMBIOS 2.4 present.
[    0.000000] DMI: Bochs Bochs, BIOS Bochs 01/01/2011
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
[    0.000000] BRK [0x02207000, 0x02207fff] PGTABLE
[    0.000000] RAMDISK: [mem 0x13cbd000-0x13feffff]
[    0.000000] ACPI: RSDP 000fd930 000014 (v00 BOCHS )
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
[    0.000000] 319MB LOWMEM available.
[    0.000000]   mapped low ram: 0 - 13ffe000
[    0.000000]   low ram: 0 - 13ffe000
[    0.000000] Zone ranges:
[    0.000000]   Normal   [mem 0x00001000-0x13ffdfff]
[    0.000000] Movable zone start for each node
[    0.000000] Early memory node ranges
[    0.000000]   node   0: [mem 0x00001000-0x0009efff]
[    0.000000]   node   0: [mem 0x00100000-0x13ffdfff]
[    0.000000] On node 0 totalpages: 81820
[    0.000000] free_area_init_node: node 0, pgdat 81c07ffc, node_mem_map 93=
a3d020
[    0.000000]   Normal zone: 640 pages used for memmap
[    0.000000]   Normal zone: 0 pages reserved
[    0.000000]   Normal zone: 81820 pages, LIFO batch:15
[    0.000000] ACPI: PM-Timer IO Port: 0xb008
[    0.000000] ACPI: HPET id: 0x8086a201 base: 0xfed00000
[    0.000000] e820: [mem 0x14000000-0xfffbffff] available for PCI devices
[    0.000000] Booting paravirtualized kernel on bare hardware
[    0.000000] pcpu-alloc: s0 r0 d32768 u32768 alloc=3D1*32768
[    0.000000] pcpu-alloc: [0] 0=20
[    0.000000] Built 1 zonelists in Zone order, mobility grouping on.  Tota=
l pages: 81180
[    0.000000] Kernel command line: hung_task_panic=3D1 earlyprintk=3DttyS0=
,115200 debug apic=3Ddebug sysrq_always_enabled rcupdate.rcu_cpu_stall_time=
out=3D100 panic=3D10 softlockup_panic=3D1 nmi_watchdog=3Dpanic  prompt_ramd=
isk=3D0 console=3DttyS0,115200 console=3Dtty0 vga=3Dnormal  root=3D/dev/ram=
0 rw link=3D/kernel-tests/run-queue/kvm/i386-randconfig-nh0-03200538/linux-=
devel:devel-hourly-2014032007:aa11fc58dc71c27701b1f9a529a36a38d4337722:bise=
ct-linux7/.vmlinuz-aa11fc58dc71c27701b1f9a529a36a38d4337722-20140320171009-=
13-waimea branch=3Dlinux-devel/devel-hourly-2014032007 BOOT_IMAGE=3D/kernel=
/i386-randconfig-nh0-03200538/aa11fc58dc71c27701b1f9a529a36a38d4337722/vmli=
nuz-3.14.0-rc1-00023-gaa11fc5 drbd.minor_count=3D8
[    0.000000] sysrq: sysrq always enabled.
[    0.000000] PID hash table entries: 2048 (order: 1, 8192 bytes)
[    0.000000] Dentry cache hash table entries: 65536 (order: 6, 262144 byt=
es)
[    0.000000] Inode-cache hash table entries: 32768 (order: 5, 131072 byte=
s)
[    0.000000] Initializing CPU#0
[    0.000000] Memory: 302428K/327280K available (6902K kernel code, 2341K =
rwdata, 3272K rodata, 560K init, 5332K bss, 24852K reserved)
[    0.000000] virtual kernel memory layout:
[    0.000000]     fixmap  : 0xfffe1000 - 0xfffff000   ( 120 kB)
[    0.000000]     vmalloc : 0x947fe000 - 0xfffdf000   (1719 MB)
[    0.000000]     lowmem  : 0x80000000 - 0x93ffe000   ( 319 MB)
[    0.000000]       .init : 0x81c3b000 - 0x81cc7000   ( 560 kB)
[    0.000000]       .data : 0x816bde9e - 0x81c3a700   (5618 kB)
[    0.000000]       .text : 0x81000000 - 0x816bde9e   (6903 kB)
[    0.000000] Checking if this processor honours the WP bit even in superv=
isor mode...Ok.
[    0.000000] NR_IRQS:16 nr_irqs:16 16
[    0.000000] CPU 0 irqstacks, hard=3D80096000 soft=3D80080000
[    0.000000] ACPI: Core revision 20131218
[    0.000000] ACPI: All ACPI Tables successfully acquired
[    0.000000] ACPI: setting ELCR to 0200 (from 0c00)
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
[    0.000000] tsc: Fast TSC calibration failed
[    0.000000] tsc: Fast TSC calibration failed
[    0.000000] tsc: Unable to calibrate against PIT
[    0.000000] tsc: Unable to calibrate against PIT
[    0.000000] tsc: using HPET reference calibration
[    0.000000] tsc: using HPET reference calibration
[    0.000000] tsc: Detected 3300.126 MHz processor
[    0.000000] tsc: Detected 3300.126 MHz processor
[    0.051815] Calibrating delay loop (skipped), value calculated using tim=
er frequency..=20
[    0.051815] Calibrating delay loop (skipped), value calculated using tim=
er frequency.. 6600.25 BogoMIPS (lpj=3D33001260)
6600.25 BogoMIPS (lpj=3D33001260)
[    0.053190] pid_max: default: 32768 minimum: 301
[    0.053190] pid_max: default: 32768 minimum: 301
[    0.061877] Security Framework initialized
[    0.061877] Security Framework initialized
[    0.063789] Yama: becoming mindful.
[    0.063789] Yama: becoming mindful.
[    0.065066] Mount-cache hash table entries: 512
[    0.065066] Mount-cache hash table entries: 512
[    0.081002] Initializing cgroup subsys debug
[    0.081002] Initializing cgroup subsys debug
[    0.089201] Last level iTLB entries: 4KB 0, 2MB 0, 4MB 0
[    0.089201] Last level dTLB entries: 4KB 0, 2MB 0, 4MB 0, 1GB 0
[    0.089201] tlb_flushall_shift: 6
[    0.089201] Last level iTLB entries: 4KB 0, 2MB 0, 4MB 0
[    0.089201] Last level dTLB entries: 4KB 0, 2MB 0, 4MB 0, 1GB 0
[    0.089201] tlb_flushall_shift: 6
[    0.100235] CPU:=20
[    0.100235] CPU: Intel Core Processor (Haswell)Intel Core Processor (Has=
well) (fam: 06, model: 3c (fam: 06, model: 3c, stepping: 01)
, stepping: 01)
[    0.134638] Performance Events:=20
[    0.134638] Performance Events: unsupported p6 CPU model 60 unsupported =
p6 CPU model 60 no PMU driver, software events only.
no PMU driver, software events only.
[    0.157010] ftrace: Allocated trace_printk buffers
[    0.157010] ftrace: Allocated trace_printk buffers
[    0.177087] NMI watchdog: disabled (cpu0): hardware events not enabled
[    0.177087] NMI watchdog: disabled (cpu0): hardware events not enabled
[    0.205370] devtmpfs: initialized
[    0.205370] devtmpfs: initialized
[    0.225110] EVM: security.capability
[    0.225110] EVM: security.capability
[    0.254086] prandom: seed boundary self test passed
[    0.254086] prandom: seed boundary self test passed
[    0.263586] prandom: 100 self tests passed
[    0.263586] prandom: 100 self tests passed
[    0.265451] atomic64 test passed for i586+ platform with CX8 and with SSE
[    0.265451] atomic64 test passed for i586+ platform with CX8 and with SSE
[    0.281713] regulator-dummy: no parameters
[    0.281713] regulator-dummy: no parameters
[    0.289181] NET: Registered protocol family 16
[    0.289181] NET: Registered protocol family 16
[    0.312851] cpuidle: using governor ladder
[    0.312851] cpuidle: using governor ladder
[    0.313406] cpuidle: using governor menu
[    0.313406] cpuidle: using governor menu
[    0.325550] ACPI: bus type PCI registered
[    0.325550] ACPI: bus type PCI registered
[    0.335197] PCI: PCI BIOS revision 2.10 entry at 0xfc6d5, last bus=3D0
[    0.335197] PCI: PCI BIOS revision 2.10 entry at 0xfc6d5, last bus=3D0
[    0.335860] PCI: Using configuration type 1 for base access
[    0.335860] PCI: Using configuration type 1 for base access
[    0.865546] ACPI: Added _OSI(Module Device)
[    0.865546] ACPI: Added _OSI(Module Device)
[    0.865823] ACPI: Added _OSI(Processor Device)
[    0.865823] ACPI: Added _OSI(Processor Device)
[    0.866124] ACPI: Added _OSI(3.0 _SCP Extensions)
[    0.866124] ACPI: Added _OSI(3.0 _SCP Extensions)
[    0.866369] ACPI: Added _OSI(Processor Aggregator Device)
[    0.866369] ACPI: Added _OSI(Processor Aggregator Device)
[    1.178351] ACPI: Interpreter enabled
[    1.178351] ACPI: Interpreter enabled
[    1.180154] ACPI: (supports S0 S5)
[    1.180154] ACPI: (supports S0 S5)
[    1.180562] ACPI: Using PIC for interrupt routing
[    1.180562] ACPI: Using PIC for interrupt routing
[    1.182882] PCI: Using host bridge windows from ACPI; if necessary, use =
"pci=3Dnocrs" and report a bug
[    1.182882] PCI: Using host bridge windows from ACPI; if necessary, use =
"pci=3Dnocrs" and report a bug
[    1.638224] ACPI: PCI Root Bridge [PCI0] (domain 0000 [bus 00-ff])
[    1.638224] ACPI: PCI Root Bridge [PCI0] (domain 0000 [bus 00-ff])
[    1.639023] acpi PNP0A03:00: _OSC: OS supports [Segments]
[    1.639023] acpi PNP0A03:00: _OSC: OS supports [Segments]
[    1.640178] acpi PNP0A03:00: _OSC failed (AE_NOT_FOUND); disabling ASPM
[    1.640178] acpi PNP0A03:00: _OSC failed (AE_NOT_FOUND); disabling ASPM
[    1.652003] acpi PNP0A03:00: fail to add MMCONFIG information, can't acc=
ess extended PCI configuration space under this bridge.
[    1.652003] acpi PNP0A03:00: fail to add MMCONFIG information, can't acc=
ess extended PCI configuration space under this bridge.
[    1.654653] PCI host bridge to bus 0000:00
[    1.654653] PCI host bridge to bus 0000:00
[    1.655074] pci_bus 0000:00: root bus resource [bus 00-ff]
[    1.655074] pci_bus 0000:00: root bus resource [bus 00-ff]
[    1.655471] pci_bus 0000:00: root bus resource [io  0x0000-0x0cf7]
[    1.655471] pci_bus 0000:00: root bus resource [io  0x0000-0x0cf7]
[    1.655784] pci_bus 0000:00: root bus resource [io  0x0d00-0xffff]
[    1.655784] pci_bus 0000:00: root bus resource [io  0x0d00-0xffff]
[    1.656137] pci_bus 0000:00: root bus resource [mem 0x000a0000-0x000bfff=
f]
[    1.656137] pci_bus 0000:00: root bus resource [mem 0x000a0000-0x000bfff=
f]
[    1.656475] pci_bus 0000:00: root bus resource [mem 0x80000000-0xfebffff=
f]
[    1.656475] pci_bus 0000:00: root bus resource [mem 0x80000000-0xfebffff=
f]
[    1.657728] pci 0000:00:00.0: [8086:1237] type 00 class 0x060000
[    1.657728] pci 0000:00:00.0: [8086:1237] type 00 class 0x060000
[    1.667118] pci 0000:00:01.0: [8086:7000] type 00 class 0x060100
[    1.667118] pci 0000:00:01.0: [8086:7000] type 00 class 0x060100
[    1.675508] pci 0000:00:01.1: [8086:7010] type 00 class 0x010180
[    1.675508] pci 0000:00:01.1: [8086:7010] type 00 class 0x010180
[    1.678820] pci 0000:00:01.1: reg 0x20: [io  0xc1c0-0xc1cf]
[    1.678820] pci 0000:00:01.1: reg 0x20: [io  0xc1c0-0xc1cf]
[    1.686840] pci 0000:00:01.3: [8086:7113] type 00 class 0x068000
[    1.686840] pci 0000:00:01.3: [8086:7113] type 00 class 0x068000
[    1.688285] pci 0000:00:01.3: quirk: [io  0xb000-0xb03f] claimed by PIIX=
4 ACPI
[    1.688285] pci 0000:00:01.3: quirk: [io  0xb000-0xb03f] claimed by PIIX=
4 ACPI
[    1.688685] pci 0000:00:01.3: quirk: [io  0xb100-0xb10f] claimed by PIIX=
4 SMB
[    1.688685] pci 0000:00:01.3: quirk: [io  0xb100-0xb10f] claimed by PIIX=
4 SMB
[    1.696308] pci 0000:00:02.0: [1013:00b8] type 00 class 0x030000
[    1.696308] pci 0000:00:02.0: [1013:00b8] type 00 class 0x030000
[    1.697735] pci 0000:00:02.0: reg 0x10: [mem 0xfc000000-0xfdffffff pref]
[    1.697735] pci 0000:00:02.0: reg 0x10: [mem 0xfc000000-0xfdffffff pref]
[    1.699015] pci 0000:00:02.0: reg 0x14: [mem 0xfebf0000-0xfebf0fff]
[    1.699015] pci 0000:00:02.0: reg 0x14: [mem 0xfebf0000-0xfebf0fff]
[    1.704256] pci 0000:00:02.0: reg 0x30: [mem 0xfebe0000-0xfebeffff pref]
[    1.704256] pci 0000:00:02.0: reg 0x30: [mem 0xfebe0000-0xfebeffff pref]
[    1.711864] pci 0000:00:03.0: [8086:100e] type 00 class 0x020000
[    1.711864] pci 0000:00:03.0: [8086:100e] type 00 class 0x020000
[    1.713329] pci 0000:00:03.0: reg 0x10: [mem 0xfeba0000-0xfebbffff]
[    1.713329] pci 0000:00:03.0: reg 0x10: [mem 0xfeba0000-0xfebbffff]
[    1.714611] pci 0000:00:03.0: reg 0x14: [io  0xc000-0xc03f]
[    1.714611] pci 0000:00:03.0: reg 0x14: [io  0xc000-0xc03f]
[    1.720869] pci 0000:00:03.0: reg 0x30: [mem 0xfebc0000-0xfebdffff pref]
[    1.720869] pci 0000:00:03.0: reg 0x30: [mem 0xfebc0000-0xfebdffff pref]
[    1.733440] pci 0000:00:04.0: [1af4:1001] type 00 class 0x010000
[    1.733440] pci 0000:00:04.0: [1af4:1001] type 00 class 0x010000
[    1.735673] pci 0000:00:04.0: reg 0x10: [io  0xc040-0xc07f]
[    1.735673] pci 0000:00:04.0: reg 0x10: [io  0xc040-0xc07f]
[    1.737548] pci 0000:00:04.0: reg 0x14: [mem 0xfebf1000-0xfebf1fff]
[    1.737548] pci 0000:00:04.0: reg 0x14: [mem 0xfebf1000-0xfebf1fff]
[    1.756222] pci 0000:00:05.0: [1af4:1001] type 00 class 0x010000
[    1.756222] pci 0000:00:05.0: [1af4:1001] type 00 class 0x010000
[    1.758533] pci 0000:00:05.0: reg 0x10: [io  0xc080-0xc0bf]
[    1.758533] pci 0000:00:05.0: reg 0x10: [io  0xc080-0xc0bf]
[    1.760978] pci 0000:00:05.0: reg 0x14: [mem 0xfebf2000-0xfebf2fff]
[    1.760978] pci 0000:00:05.0: reg 0x14: [mem 0xfebf2000-0xfebf2fff]
[    1.781708] pci 0000:00:06.0: [1af4:1001] type 00 class 0x010000
[    1.781708] pci 0000:00:06.0: [1af4:1001] type 00 class 0x010000
[    1.783795] pci 0000:00:06.0: reg 0x10: [io  0xc0c0-0xc0ff]
[    1.783795] pci 0000:00:06.0: reg 0x10: [io  0xc0c0-0xc0ff]
[    1.785619] pci 0000:00:06.0: reg 0x14: [mem 0xfebf3000-0xfebf3fff]
[    1.785619] pci 0000:00:06.0: reg 0x14: [mem 0xfebf3000-0xfebf3fff]
[    1.805077] pci 0000:00:07.0: [1af4:1001] type 00 class 0x010000
[    1.805077] pci 0000:00:07.0: [1af4:1001] type 00 class 0x010000
[    1.807122] pci 0000:00:07.0: reg 0x10: [io  0xc100-0xc13f]
[    1.807122] pci 0000:00:07.0: reg 0x10: [io  0xc100-0xc13f]
[    1.808869] pci 0000:00:07.0: reg 0x14: [mem 0xfebf4000-0xfebf4fff]
[    1.808869] pci 0000:00:07.0: reg 0x14: [mem 0xfebf4000-0xfebf4fff]
[    1.827585] pci 0000:00:08.0: [1af4:1001] type 00 class 0x010000
[    1.827585] pci 0000:00:08.0: [1af4:1001] type 00 class 0x010000
[    1.829799] pci 0000:00:08.0: reg 0x10: [io  0xc140-0xc17f]
[    1.829799] pci 0000:00:08.0: reg 0x10: [io  0xc140-0xc17f]
[    1.831565] pci 0000:00:08.0: reg 0x14: [mem 0xfebf5000-0xfebf5fff]
[    1.831565] pci 0000:00:08.0: reg 0x14: [mem 0xfebf5000-0xfebf5fff]
[    1.851119] pci 0000:00:09.0: [1af4:1001] type 00 class 0x010000
[    1.851119] pci 0000:00:09.0: [1af4:1001] type 00 class 0x010000
[    1.853311] pci 0000:00:09.0: reg 0x10: [io  0xc180-0xc1bf]
[    1.853311] pci 0000:00:09.0: reg 0x10: [io  0xc180-0xc1bf]
[    1.855106] pci 0000:00:09.0: reg 0x14: [mem 0xfebf6000-0xfebf6fff]
[    1.855106] pci 0000:00:09.0: reg 0x14: [mem 0xfebf6000-0xfebf6fff]
[    1.876812] pci 0000:00:0a.0: [8086:25ab] type 00 class 0x088000
[    1.876812] pci 0000:00:0a.0: [8086:25ab] type 00 class 0x088000
[    1.878327] pci 0000:00:0a.0: reg 0x10: [mem 0xfebf7000-0xfebf700f]
[    1.878327] pci 0000:00:0a.0: reg 0x10: [mem 0xfebf7000-0xfebf700f]
[    1.895121] pci_bus 0000:00: on NUMA node 0
[    1.895121] pci_bus 0000:00: on NUMA node 0
[    1.920642] ACPI: PCI Interrupt Link [LNKA] (IRQs
[    1.920642] ACPI: PCI Interrupt Link [LNKA] (IRQs 5 5 *10 *10 11 11))

[    1.927942] ACPI: PCI Interrupt Link [LNKB] (IRQs
[    1.927942] ACPI: PCI Interrupt Link [LNKB] (IRQs 5 5 *10 *10 11 11))

[    1.935258] ACPI: PCI Interrupt Link [LNKC] (IRQs
[    1.935258] ACPI: PCI Interrupt Link [LNKC] (IRQs 5 5 10 10 *11 *11))

[    1.942698] ACPI: PCI Interrupt Link [LNKD] (IRQs
[    1.942698] ACPI: PCI Interrupt Link [LNKD] (IRQs 5 5 10 10 *11 *11))

[    1.946211] ACPI: PCI Interrupt Link [LNKS] (IRQs
[    1.946211] ACPI: PCI Interrupt Link [LNKS] (IRQs *9 *9))

[    1.970000] ACPI:=20
[    1.970000] ACPI: Enabled 16 GPEs in block 00 to 0FEnabled 16 GPEs in bl=
ock 00 to 0F

[    2.041225] pps_core: LinuxPPS API ver. 1 registered
[    2.041225] pps_core: LinuxPPS API ver. 1 registered
[    2.041653] pps_core: Software ver. 5.3.6 - Copyright 2005-2007 Rodolfo =
Giometti <giometti@linux.it>
[    2.041653] pps_core: Software ver. 5.3.6 - Copyright 2005-2007 Rodolfo =
Giometti <giometti@linux.it>
[    2.042973] PTP clock support registered
[    2.042973] PTP clock support registered
[    2.045166] EDAC MC: Ver: 3.0.0
[    2.045166] EDAC MC: Ver: 3.0.0
[    2.055544] wmi: Mapper loaded
[    2.055544] wmi: Mapper loaded
[    2.057468] PCI: Using ACPI for IRQ routing
[    2.057468] PCI: Using ACPI for IRQ routing
[    2.058102] PCI: pci_cache_line_size set to 64 bytes
[    2.058102] PCI: pci_cache_line_size set to 64 bytes
[    2.060674] e820: reserve RAM buffer [mem 0x0009fc00-0x0009ffff]
[    2.060674] e820: reserve RAM buffer [mem 0x0009fc00-0x0009ffff]
[    2.061534] e820: reserve RAM buffer [mem 0x13ffe000-0x13ffffff]
[    2.061534] e820: reserve RAM buffer [mem 0x13ffe000-0x13ffffff]
[    2.089356] Switched to clocksource hpet
[    2.089356] Switched to clocksource hpet
[    2.102339] Warning: could not register annotated branches stats
[    2.102339] Warning: could not register annotated branches stats
[    2.646702] FS-Cache: Loaded
[    2.646702] FS-Cache: Loaded
[    2.650570] pnp: PnP ACPI init
[    2.650570] pnp: PnP ACPI init
[    2.651577] ACPI: bus type PNP registered
[    2.651577] ACPI: bus type PNP registered
[    2.658357] pnp 00:00: Plug and Play ACPI device, IDs PNP0b00 (active)
[    2.658357] pnp 00:00: Plug and Play ACPI device, IDs PNP0b00 (active)
[    2.663052] pnp 00:01: Plug and Play ACPI device, IDs PNP0303 (active)
[    2.663052] pnp 00:01: Plug and Play ACPI device, IDs PNP0303 (active)
[    2.667186] pnp 00:02: Plug and Play ACPI device, IDs PNP0f13 (active)
[    2.667186] pnp 00:02: Plug and Play ACPI device, IDs PNP0f13 (active)
[    2.670981] pnp 00:03: [dma 2]
[    2.670981] pnp 00:03: [dma 2]
[    2.673244] pnp 00:03: Plug and Play ACPI device, IDs PNP0700 (active)
[    2.673244] pnp 00:03: Plug and Play ACPI device, IDs PNP0700 (active)
[    2.678177] pnp 00:04: Plug and Play ACPI device, IDs PNP0400 (active)
[    2.678177] pnp 00:04: Plug and Play ACPI device, IDs PNP0400 (active)
[    2.683667] pnp 00:05: Plug and Play ACPI device, IDs PNP0501 (active)
[    2.683667] pnp 00:05: Plug and Play ACPI device, IDs PNP0501 (active)
[    2.699617] pnp 00:06: Plug and Play ACPI device, IDs PNP0103 (active)
[    2.699617] pnp 00:06: Plug and Play ACPI device, IDs PNP0103 (active)
[    2.709153] pnp: PnP ACPI: found 7 devices
[    2.709153] pnp: PnP ACPI: found 7 devices
[    2.709649] ACPI: bus type PNP unregistered
[    2.709649] ACPI: bus type PNP unregistered
[    2.783399] pci_bus 0000:00: resource 4 [io  0x0000-0x0cf7]
[    2.783399] pci_bus 0000:00: resource 4 [io  0x0000-0x0cf7]
[    2.783985] pci_bus 0000:00: resource 5 [io  0x0d00-0xffff]
[    2.783985] pci_bus 0000:00: resource 5 [io  0x0d00-0xffff]
[    2.784468] pci_bus 0000:00: resource 6 [mem 0x000a0000-0x000bffff]
[    2.784468] pci_bus 0000:00: resource 6 [mem 0x000a0000-0x000bffff]
[    2.785042] pci_bus 0000:00: resource 7 [mem 0x80000000-0xfebfffff]
[    2.785042] pci_bus 0000:00: resource 7 [mem 0x80000000-0xfebfffff]
[    2.786129] NET: Registered protocol family 1
[    2.786129] NET: Registered protocol family 1
[    2.786744] pci 0000:00:00.0: Limiting direct PCI/PCI transfers
[    2.786744] pci 0000:00:00.0: Limiting direct PCI/PCI transfers
[    2.787457] pci 0000:00:01.0: PIIX3: Enabling Passive Release
[    2.787457] pci 0000:00:01.0: PIIX3: Enabling Passive Release
[    2.788409] pci 0000:00:01.0: Activating ISA DMA hang workarounds
[    2.788409] pci 0000:00:01.0: Activating ISA DMA hang workarounds
[    2.789268] pci 0000:00:02.0: Boot video device
[    2.789268] pci 0000:00:02.0: Boot video device
[    2.790881] PCI: CLS 0 bytes, default 64
[    2.790881] PCI: CLS 0 bytes, default 64
[    2.812392] Unpacking initramfs...
[    2.812392] Unpacking initramfs...
[    4.937582] Freeing initrd memory: 3276K (93cbd000 - 93ff0000)
[    4.937582] Freeing initrd memory: 3276K (93cbd000 - 93ff0000)
[    4.952113] BUG: unable to handle kernel=20
[    4.952113] BUG: unable to handle kernel NULL pointer dereferenceNULL po=
inter dereference at 0000003c
 at 0000003c
[    4.952871] IP:
[    4.952871] IP: [<81c439fb>] rapl_pmu_init+0xed/0x165
 [<81c439fb>] rapl_pmu_init+0xed/0x165
[    4.954190] *pde =3D 00000000=20
[    4.954190] *pde =3D 00000000=20

[    4.954619] Oops: 0000 [#1]=20
[    4.954619] Oops: 0000 [#1]=20

[    4.955440] CPU: 0 PID: 1 Comm: swapper Not tainted 3.14.0-rc1-00023-gaa=
11fc5 #1
[    4.955440] CPU: 0 PID: 1 Comm: swapper Not tainted 3.14.0-rc1-00023-gaa=
11fc5 #1
[    4.956050] Hardware name: Bochs Bochs, BIOS Bochs 01/01/2011
[    4.956050] Hardware name: Bochs Bochs, BIOS Bochs 01/01/2011
[    4.956672] task: 80030c20 ti: 80032000 task.ti: 80032000
[    4.956672] task: 80030c20 ti: 80032000 task.ti: 80032000
[    4.957295] EIP: 0060:[<81c439fb>] EFLAGS: 00000246 CPU: 0
[    4.957295] EIP: 0060:[<81c439fb>] EFLAGS: 00000246 CPU: 0
[    4.957831] EIP is at rapl_pmu_init+0xed/0x165
[    4.957831] EIP is at rapl_pmu_init+0xed/0x165
[    4.958303] EAX: 81c0e6a4 EBX: 00000000 ECX: 00000000 EDX: 00000000
[    4.958303] EAX: 81c0e6a4 EBX: 00000000 ECX: 00000000 EDX: 00000000
[    4.958846] ESI: 00000000 EDI: 00000000 EBP: 80033f00 ESP: 80033ed8
[    4.958846] ESI: 00000000 EDI: 00000000 EBP: 80033f00 ESP: 80033ed8
[    4.959397]  DS: 007b ES: 007b FS: 0000 GS: 00e0 SS: 0068
[    4.959397]  DS: 007b ES: 007b FS: 0000 GS: 00e0 SS: 0068
[    4.959975] CR0: 8005003b CR2: 0000003c CR3: 01cca000 CR4: 00300690
[    4.959975] CR0: 8005003b CR2: 0000003c CR3: 01cca000 CR4: 00300690
[    4.960361] DR0: 00000000 DR1: 00000000 DR2: 00000000 DR3: 00000000
[    4.960361] DR0: 00000000 DR1: 00000000 DR2: 00000000 DR3: 00000000
[    4.960361] DR6: 00000000 DR7: 00000000
[    4.960361] DR6: 00000000 DR7: 00000000
[    4.960361] Stack:
[    4.960361] Stack:
[    4.960361]  819fd394
[    4.960361]  819fd394 802fa800 802fa800 81927ef8 81927ef8 00000002 00000=
002 006bad04 006bad04 00000000 00000000 00000000 00000000 00000000 00000000

[    4.960361]  81c4390e
[    4.960361]  81c4390e 81cb7ae0 81cb7ae0 80033f74 80033f74 81c3bad5 81c3b=
ad5 00000010 00000010 0000007b 0000007b 81047582 81047582 00000011 00000011

[    4.960361]  93ff7b7f
[    4.960361]  93ff7b7f 00000000 00000000 93ff7b90 93ff7b90 80033f00 80033=
f00 81c3b44a 81c3b44a 93ff7b7f 93ff7b7f 819f0c30 819f0c30 80033f74 80033f74

[    4.960361] Call Trace:
[    4.960361] Call Trace:
[    4.960361]  [<81c4390e>] ? uncore_cpu_setup+0x9e/0x9e
[    4.960361]  [<81c4390e>] ? uncore_cpu_setup+0x9e/0x9e
[    4.960361]  [<81c3bad5>] do_one_initcall+0x8b/0x14b
[    4.960361]  [<81c3bad5>] do_one_initcall+0x8b/0x14b
[    4.960361]  [<81047582>] ? parameqn+0xc/0x41
[    4.960361]  [<81047582>] ? parameqn+0xc/0x41
[    4.960361]  [<81c3b44a>] ? repair_env_string+0x12/0x51
[    4.960361]  [<81c3b44a>] ? repair_env_string+0x12/0x51
[    4.960361]  [<8104774a>] ? parse_args+0x16e/0x231
[    4.960361]  [<8104774a>] ? parse_args+0x16e/0x231
[    4.960361]  [<81c3bc64>] kernel_init_freeable+0xcf/0x16e
[    4.960361]  [<81c3bc64>] kernel_init_freeable+0xcf/0x16e
[    4.960361]  [<81c3b438>] ? do_early_param+0x7a/0x7a
[    4.960361]  [<81c3b438>] ? do_early_param+0x7a/0x7a
[    4.960361]  [<816adff0>] kernel_init+0x10/0xe9
[    4.960361]  [<816adff0>] kernel_init+0x10/0xe9
[    4.960361]  [<810522ac>] ? schedule_tail+0x17/0x3e
[    4.960361]  [<810522ac>] ? schedule_tail+0x17/0x3e
[    4.960361]  [<816bd077>] ret_from_kernel_thread+0x1b/0x28
[    4.960361]  [<816bd077>] ret_from_kernel_thread+0x1b/0x28
[    4.960361]  [<816adfe0>] ? rest_init+0xbc/0xbc
[    4.960361]  [<816adfe0>] ? rest_init+0xbc/0xbc
[    4.960361] Code:
[    4.960361] Code: 93 93 02 02 00 00 00 00 b8 b8 36 36 aa aa 92 92 81 81 =
e8 e8 a1 a1 bf bf 3e 3e ff ff eb eb 74 74 89 89 7c 7c 24 24 04 04 c7 c7 04 =
04 24 24 7f 7f aa aa 92 92 81 81 e8 e8 65 65 d1 d1 a6 a6 ff ff 83 83 c8 c8 =
ff ff eb eb 76 76 8b 8b 1d 1d 00 00 44 44 a0 a0 81 81 <8b> <8b> 43 43 3c 3c=
 8b 8b 53 53 40 40 e8 e8 f6 f6 ea ea 3e 3e ff ff b9 b9 e8 e8 03 03 00 00 00=
 00 89 89 d6 d6 f7 f7 e9 e9 89 89

[    4.960361] EIP: [<81c439fb>]=20
[    4.960361] EIP: [<81c439fb>] rapl_pmu_init+0xed/0x165rapl_pmu_init+0xed=
/0x165 SS:ESP 0068:80033ed8
 SS:ESP 0068:80033ed8
[    4.960361] CR2: 000000000000003c
[    4.960361] CR2: 000000000000003c
[    4.960361] ---[ end trace c2da1f6a7ec64115 ]---
[    4.960361] ---[ end trace c2da1f6a7ec64115 ]---
[    4.979045] swapper (1) used greatest stack depth: 5472 bytes left
[    4.979045] swapper (1) used greatest stack depth: 5472 bytes left
[    4.980325] Kernel panic - not syncing: Attempted to kill init! exitcode=
=3D0x00000009
[    4.980325]=20
[    4.980325] Kernel panic - not syncing: Attempted to kill init! exitcode=
=3D0x00000009
[    4.980325]=20
[    4.980843] Kernel Offset: 0x0 from 0x81000000 (relocation range: 0x8000=
0000-0x947fdfff)
[    4.980843] Kernel Offset: 0x0 from 0x81000000 (relocation range: 0x8000=
0000-0x947fdfff)
[    4.981300] Rebooting in 10 seconds..
[    4.981300] Rebooting in 10 seconds..
Elapsed time: 15
qemu-system-x86_64 -cpu Haswell,+smep,+smap -kernel /kernel/i386-randconfig=
-nh0-03200538/aa11fc58dc71c27701b1f9a529a36a38d4337722/vmlinuz-3.14.0-rc1-0=
0023-gaa11fc5 -append 'hung_task_panic=3D1 earlyprintk=3DttyS0,115200 debug=
 apic=3Ddebug sysrq_always_enabled rcupdate.rcu_cpu_stall_timeout=3D100 pan=
ic=3D10 softlockup_panic=3D1 nmi_watchdog=3Dpanic  prompt_ramdisk=3D0 conso=
le=3DttyS0,115200 console=3Dtty0 vga=3Dnormal  root=3D/dev/ram0 rw link=3D/=
kernel-tests/run-queue/kvm/i386-randconfig-nh0-03200538/linux-devel:devel-h=
ourly-2014032007:aa11fc58dc71c27701b1f9a529a36a38d4337722:bisect-linux7/.vm=
linuz-aa11fc58dc71c27701b1f9a529a36a38d4337722-20140320171009-13-waimea bra=
nch=3Dlinux-devel/devel-hourly-2014032007 BOOT_IMAGE=3D/kernel/i386-randcon=
fig-nh0-03200538/aa11fc58dc71c27701b1f9a529a36a38d4337722/vmlinuz-3.14.0-rc=
1-00023-gaa11fc5 drbd.minor_count=3D8'  -initrd /kernel-tests/initrd/yocto-=
minimal-i386.cgz -m 320 -smp 2 -net nic,vlan=3D1,model=3De1000 -net user,vl=
an=3D1,hostfwd=3Dtcp::10952-:22 -boot order=3Dnc -no-reboot -watchdog i6300=
esb -rtc base=3Dlocaltime -drive file=3D/fs/LABEL=3DKVM/disk0-yocto-waimea-=
3,media=3Ddisk,if=3Dvirtio -drive file=3D/fs/LABEL=3DKVM/disk1-yocto-waimea=
-3,media=3Ddisk,if=3Dvirtio -drive file=3D/fs/LABEL=3DKVM/disk2-yocto-waime=
a-3,media=3Ddisk,if=3Dvirtio -drive file=3D/fs/LABEL=3DKVM/disk3-yocto-waim=
ea-3,media=3Ddisk,if=3Dvirtio -drive file=3D/fs/LABEL=3DKVM/disk4-yocto-wai=
mea-3,media=3Ddisk,if=3Dvirtio -drive file=3D/fs/LABEL=3DKVM/disk5-yocto-wa=
imea-3,media=3Ddisk,if=3Dvirtio -pidfile /dev/shm/kboot/pid-yocto-waimea-3 =
-serial file:/dev/shm/kboot/serial-yocto-waimea-3 -daemonize -display none =
-monitor null=20

--fdj2RfSjLxBAspz7--
