Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751889Ab3F3Oda (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Jun 2013 10:33:30 -0400
Received: from mga09.intel.com ([134.134.136.24]:5149 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751638Ab3F3OdY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Jun 2013 10:33:24 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,969,1363158000"; 
   d="log'?scan'208";a="358106862"
Date: Sun, 30 Jun 2013 22:28:10 +0800
From: Fengguang Wu <fengguang.wu@intel.com>
To: fengguang.wu@intel.com, Dave Airlie <airlied@redhat.com>
Cc: Daniel Vetter <daniel.vetter@ffwll.ch>, dri-devel@lists.freedesktop.org,
        linux-kernel@vger.kernel.org
Subject: [drm] WARNING: at kernel/workqueue.c:1432 __queue_delayed_work()
Message-ID: <20130630142810.GA10350@localhost>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="k+w/mQv8wyuph6w0"
Content-Disposition: inline
User-Agent: Heirloom mailx 12.5 6/20/10
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--k+w/mQv8wyuph6w0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Greetings,

I got the below warning and the first bad commit is

commit be37835619fce22d3f46c5a591bbf0bbcb2288e4
Author: Daniel Vetter <daniel.vetter@ffwll.ch>
Date:   Thu Jun 6 00:17:25 2013 +0200

    drm: kms_helper: don't lose hotplug event
    
    There's a race window (small for hpd, 10s large for polled outputs)
    where userspace could sneak in with an unrelated connnector probe
    ioctl call and eat the hotplug event (since neither the hpd nor the
    poll code see a state change).
    
    To avoid this, check whether the connector state changes in all other
    ->detect calls (in the current helper code that's only probe_single)
    and if that's the case, fire off a hotplug event. Note that we can't
    directly call the hotplug event handler, since that expects that no
    locks are held (due to reentrancy with the fb code to update the kms
    console).
    
    Also, this requires that drivers using the probe_single helper
    function set up the poll work. All current drivers do that already,
    and with the reworked hpd handling there'll be no downside to
    unconditionally setting up the poll work any more.
    
    Reviewed-by: Chris Wilson <chris@chris-wilson.co.uk>
    Signed-off-by: Daniel Vetter <daniel.vetter@ffwll.ch>
    Signed-off-by: Dave Airlie <airlied@redhat.com>

[    3.829957] [TTM] Initializing pool allocator
[    3.830706] ------------[ cut here ]------------
[    3.831240] WARNING: at /c/kernel-tests/src/linux/kernel/workqueue.c:1432 __queue_delayed_work+0x81/0x247()
[    3.832303] CPU: 0 PID: 1 Comm: swapper/0 Not tainted 3.10.0-rc7-wl-01596-gb53e037 #1
[    3.833158]  00000000 00000000 85429d24 798531bf 85429d3c 7906c42f 790831cf 00000201
[    3.834185]  00000001 7ea3ec14 85429d4c 7906c4d7 00000009 00000000 85429d70 790831cf
[    3.835827]  8542b770 7ea3ec34 00000020 00000001 00000246 00000000 00000020 85429d90
[    3.836829] Call Trace:
[    3.837115]  [<798531bf>] dump_stack+0x16/0x18
[    3.837597]  [<7906c42f>] warn_slowpath_common+0x48/0x5f
[    3.838154]  [<790831cf>] ? __queue_delayed_work+0x81/0x247
[    3.838740]  [<7906c4d7>] warn_slowpath_null+0x14/0x18
[    3.839278]  [<790831cf>] __queue_delayed_work+0x81/0x247
[    3.839849]  [<79084358>] queue_delayed_work_on+0x42/0x59
[    3.840437]  [<792d944c>] schedule_delayed_work+0x16/0x18
[    3.840453]  [<792da72b>] drm_helper_probe_single_connector_modes+0xf5/0x2be
[    3.840453]  [<792d7821>] drm_fb_helper_probe_connector_modes+0x3a/0x4e
[    3.840453]  [<792d8fdc>] drm_fb_helper_initial_config+0x14d/0x3ae
[    3.840453]  [<79110996>] ? __kmalloc_node+0x6a/0xd6
[    3.840453]  [<792d9641>] ? drm_helper_disable_unused_functions+0xc3/0xdc
[    3.840453]  [<7934cd7c>] cirrus_fbdev_init+0x7c/0x8d
[    3.840453]  [<7934c623>] cirrus_modeset_init+0x145/0x186
[    3.840453]  [<7934b925>] cirrus_driver_load+0x88/0xce
[    3.840453]  [<792e4321>] drm_get_pci_dev+0x136/0x214
[    3.840453]  [<7934c724>] cirrus_pci_probe+0x85/0x91
[    3.840453]  [<791fbcfa>] pci_device_probe+0x5c/0x94
[    3.840453]  [<793e4586>] driver_probe_device+0x97/0x1b1
[    3.840453]  [<793e4724>] __driver_attach+0x53/0x6f
[    3.840453]  [<793e31d4>] bus_for_each_dev+0x3e/0x69
[    3.840453]  [<793e44a6>] driver_attach+0x19/0x1b
[    3.840453]  [<793e46d1>] ? __device_attach+0x31/0x31
[    3.840453]  [<793e382e>] bus_add_driver+0xb4/0x1bd
[    3.840453]  [<793e4ef3>] driver_register+0x8c/0xe9
[    3.840453]  [<791fbb2d>] __pci_register_driver+0x4a/0x4d
[    3.840453]  [<792e4470>] drm_pci_init+0x71/0xc9
[    3.840453]  [<79df7f16>] ? ftrace_define_fields_intel_gpu_freq_change+0x1c/0x1c
[    3.840453]  [<79df7f31>] cirrus_init+0x1b/0x25
[    3.840453]  [<79dcaa28>] do_one_initcall+0x6b/0x119
[    3.840453]  [<79dcabc7>] kernel_init_freeable+0xf1/0x171
[    3.840453]  [<7984161e>] kernel_init+0xd/0xb9
[    3.840453]  [<79860cf7>] ret_from_kernel_thread+0x1b/0x28
[    3.840453]  [<79841611>] ? rest_init+0xb1/0xb1
[    3.840453] ---[ end trace 4a7136f8b8f4ca4a ]---

git bisect start b53e037930134d11fa6307162b41fb19b6c43643 9e895ace5d82df8929b16f58e9f515f6d54ab82d --
git bisect  bad 3ef6fb0acbf846ec267c86b4b7841ca7cc1fd636  # 09:34      0-  Merge remote-tracking branch 'vireshk/cpufreq-fix-notification' into devel-snb-i386-201306280352
git bisect  bad e26e8115c78ca2f7e104ad085343e37c544033ae  # 09:51      0-  alx builtin HACK
git bisect good 40ccc72b84a848e6fcbdb38fe716f0ac6939609e  # 12:39     20+  drm/i915: release cursor when crtc is destroyed
git bisect good d5cfba1b9ce6f1f4add8f3c67fde5243e5549bbd  # 12:45     20+  drm/ast: do not attempt to acquire a reservation while in an interrupt handler
git bisect  bad 395ba7ac59ac1aa4bb07c21e3211c2af04719f0a  # 12:50      0-  drm/ttm: get rid of ttm_bo_is_reserved
git bisect good 1e876e3b1a9df25bb04682b0d48aaa7e8ae1fc82  # 12:55     20+  Merge branch 'for-linus' of git://git.kernel.org/pub/scm/linux/kernel/git/s390/linux
git bisect  bad 1fb4883ad4ae880d2ef100f00624ec7660018186  # 12:59      0-  reservation: cross-device reservation support, v4
git bisect good f3cf139efa4bc0fe4f032af6ca3e49e38a5d9ae5  # 13:04     20+  mutex: Add more w/w tests to test EDEADLK path handling
git bisect good 76ceded51787729bea28ab8cf986b23ffd8e3533  # 13:08     20+  Merge branch 'core/mutexes' of git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip into drm-next
git bisect  bad 3839e7f1cf063d9bae9406e8d9a0c64645ea21b2  # 13:13      0-  Merge branch 'for-airlied-next' into for-airlied
git bisect  bad be37835619fce22d3f46c5a591bbf0bbcb2288e4  # 13:17      0-  drm: kms_helper: don't lose hotplug event
git bisect good 76ceded51787729bea28ab8cf986b23ffd8e3533  # 15:50     60+  Merge branch 'core/mutexes' of git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip into drm-next
git bisect  bad b53e037930134d11fa6307162b41fb19b6c43643  # 15:50      0-  Merge remote-tracking branch 'xlnx/zynq/clk' into devel-snb-i386-201306280352
git bisect good c13737291d08634b4e7e59862ea3ae2a7dbfb36d  # 15:56     60+  Revert "drm: kms_helper: don't lose hotplug event"
git bisect good 98b6ed0f2bf4abfb759206aa70690636372bdee7  # 15:58     60+  Merge git://git.kernel.org/pub/scm/linux/kernel/git/davem/net
git bisect  bad 4ad125f98662b3226daaea1a277a5936006c10d7  # 16:03      0-  Add linux-next specific files for 20130628

Thanks,
Fengguang

--k+w/mQv8wyuph6w0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="dmesg-kvm-vp-10423-20130628043651-3.10.0-rc7-wl-01596-gb53e037-1"
Content-Transfer-Encoding: quoted-printable

[    0.000000] Linux version 3.10.0-rc7-wl-01596-gb53e037 (kbuild@snb) (gcc=
 version 4.8.1 (Debian 4.8.1-3) ) #1 SMP Fri Jun 28 04:36:01 CST 2013
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
[    0.000000] Notice: NX (Execute Disable) protection cannot be enabled: n=
on-PAE kernel!
[    0.000000] Hypervisor detected: KVM
[    0.000000] e820: update [mem 0x00000000-0x00000fff] usable =3D=3D> rese=
rved
[    0.000000] e820: remove [mem 0x000a0000-0x000fffff] usable
[    0.000000] e820: last_pfn =3D 0xfffe max_arch_pfn =3D 0x100000
[    0.000000] initial memory mapped: [mem 0x00000000-0x027fffff]
[    0.000000] Base memory trampoline at [7809b000] 9b000 size 16384
[    0.000000] init_memory_mapping: [mem 0x00000000-0x000fffff]
[    0.000000]  [mem 0x00000000-0x000fffff] page 4k
[    0.000000] init_memory_mapping: [mem 0x0e000000-0x0e3fffff]
[    0.000000]  [mem 0x0e000000-0x0e3fffff] page 4k
[    0.000000] BRK [0x02396000, 0x02396fff] PGTABLE
[    0.000000] init_memory_mapping: [mem 0x08000000-0x0dffffff]
[    0.000000]  [mem 0x08000000-0x0dffffff] page 4k
[    0.000000] BRK [0x02397000, 0x02397fff] PGTABLE
[    0.000000] BRK [0x02398000, 0x02398fff] PGTABLE
[    0.000000] BRK [0x02399000, 0x02399fff] PGTABLE
[    0.000000] BRK [0x0239a000, 0x0239afff] PGTABLE
[    0.000000] init_memory_mapping: [mem 0x00100000-0x07ffffff]
[    0.000000]  [mem 0x00100000-0x07ffffff] page 4k
[    0.000000] init_memory_mapping: [mem 0x0e400000-0x0fffdfff]
[    0.000000]  [mem 0x0e400000-0x0fffdfff] page 4k
[    0.000000] log_buf_len: 8388608
[    0.000000] early log buf free: 128940(98%)
[    0.000000] RAMDISK: [mem 0x0e73f000-0x0ffeffff]
[    0.000000] ACPI: RSDP 000fd920 00014 (v00 BOCHS )
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
[    0.000000] Zone ranges:
[    0.000000]   DMA      [mem 0x00001000-0x00ffffff]
[    0.000000]   Normal   [mem 0x01000000-0x0fffdfff]
[    0.000000]   HighMem  empty
[    0.000000] Movable zone start for each node
[    0.000000] Early memory node ranges
[    0.000000]   node   0: [mem 0x00001000-0x0009efff]
[    0.000000]   node   0: [mem 0x00100000-0x0fffdfff]
[    0.000000] On node 0 totalpages: 65436
[    0.000000] free_area_init_node: node 0, pgdat 79d73a00, node_mem_map 86=
4ff024
[    0.000000]   DMA zone: 36 pages used for memmap
[    0.000000]   DMA zone: 0 pages reserved
[    0.000000]   DMA zone: 3998 pages, LIFO batch:0
[    0.000000]   Normal zone: 540 pages used for memmap
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
[    0.000000] setup_percpu: NR_CPUS:32 nr_cpumask_bits:2 nr_cpu_ids:2 nr_n=
ode_ids:1
[    0.000000] PERCPU: Embedded 12 pages/cpu @864e7000 s33624 r0 d15528 u49=
152
[    0.000000] pcpu-alloc: s33624 r0 d15528 u49152 alloc=3D12*4096
[    0.000000] pcpu-alloc: [0] 0 [0] 1=20
[    0.000000] kvm-clock: cpu 0, msr 0:fffd001, primary cpu clock
[    0.000000] KVM setup async PF for cpu 0
[    0.000000] kvm-stealtime: cpu 0, msr e4e9880
[    0.000000] Built 1 zonelists in Zone order, mobility grouping on.  Tota=
l pages: 64860
[    0.000000] Kernel command line: hung_task_panic=3D1 rcutree.rcu_cpu_sta=
ll_timeout=3D100 log_buf_len=3D8M ignore_loglevel debug sched_debug apic=3D=
debug dynamic_printk sysrq_always_enabled panic=3D10  prompt_ramdisk=3D0 co=
nsole=3DttyS0,115200 console=3Dtty0 vga=3Dnormal  root=3D/dev/ram0 rw link=
=3D/kernel-tests/run-queue/kvm/i386-randconfig-s07-0628/devel-snb-i386-2013=
06280352/.vmlinuz-b53e037930134d11fa6307162b41fb19b6c43643-20130628043743-2=
-vp branch=3Dlinux-devel/devel-snb-i386-201306280352  BOOT_IMAGE=3D/kernel/=
i386-randconfig-s07-0628/b53e037930134d11fa6307162b41fb19b6c43643/vmlinuz-3=
=2E10.0-rc7-wl-01596-gb53e037
[    0.000000] sysrq: sysrq always enabled.
[    0.000000] PID hash table entries: 1024 (order: 0, 4096 bytes)
[    0.000000] Dentry cache hash table entries: 32768 (order: 5, 131072 byt=
es)
[    0.000000] Inode-cache hash table entries: 16384 (order: 4, 65536 bytes)
[    0.000000] Initializing CPU#0
[    0.000000] Initializing HighMem for node 0 (00000000:00000000)
[    0.000000] Memory: 205296k/262136k available (8588k kernel code, 56448k=
 reserved, 5531k data, 680k init, 0k highmem)
[    0.000000] virtual kernel memory layout:
[    0.000000]     fixmap  : 0xffd33000 - 0xfffff000   (2864 kB)
[    0.000000]     pkmap   : 0xff800000 - 0xffc00000   (4096 kB)
[    0.000000]     vmalloc : 0x887fe000 - 0xff7fe000   (1904 MB)
[    0.000000]     lowmem  : 0x78000000 - 0x87ffe000   ( 255 MB)
[    0.000000]       .init : 0x79dca000 - 0x79e74000   ( 680 kB)
[    0.000000]       .data : 0x79863177 - 0x79dc9e00   (5531 kB)
[    0.000000]       .text : 0x79000000 - 0x79863177   (8588 kB)
[    0.000000] Checking if this processor honours the WP bit even in superv=
isor mode...Ok.
[    0.000000] Hierarchical RCU implementation.
[    0.000000]=20
[    0.000000]=20
[    0.000000]=20
[    0.000000]=20
[    0.000000] NR_IRQS:2304 nr_irqs:512 16
[    0.000000] CPU 0 irqstacks, hard=3D85404000 soft=3D85406000
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
[    0.000000] ODEBUG: 8 of 8 active objects replaced
[    0.000000] hpet clockevent registered
[    0.000000] tsc: Detected 2693.382 MHz processor
[    0.020000] Calibrating delay loop (skipped) preset value.. 5386.76 Bogo=
MIPS (lpj=3D26933820)
[    0.020000] pid_max: default: 32768 minimum: 301
[    0.020000] Security Framework initialized
[    0.020000] SELinux:  Initializing.
[    0.020000] SELinux:  Starting in permissive mode
[    0.020000] AppArmor: AppArmor disabled by boot time parameter
[    0.020000] Mount-cache hash table entries: 512
[    0.020000] mce: CPU supports 10 MCE banks
[    0.020000] Last level iTLB entries: 4KB 0, 2MB 0, 4MB 0
[    0.020000] Last level dTLB entries: 4KB 0, 2MB 0, 4MB 0
[    0.020000] tlb_flushall_shift: 6
[    0.020000] debug: unmapping init [mem 0x79e74000-0x79e77fff]
[    0.020499] ACPI: Core revision 20130517
[    0.026128] ACPI: All ACPI Tables successfully acquired
[    0.026788] ftrace: allocating 41019 entries in 81 pages
[    0.040284] Getting VERSION: 50014
[    0.040704] Getting VERSION: 50014
[    0.041087] Getting ID: 0
[    0.041400] Getting ID: f000000
[    0.041764] Getting LVT0: 8700
[    0.042105] Getting LVT1: 8400
[    0.042454] Enabling APIC mode:  Flat.  Using 1 I/O APICs
[    0.043133] enabled ExtINT on CPU#0
[    0.050983] ENABLING IO-APIC IRQs
[    0.051360] init IO_APIC IRQs
[    0.051699]  apic 0 pin 0 not connected
[    0.052140] IOAPIC[0]: Set routing entry (0-1 -> 0x31 -> IRQ 1 Mode:0 Ac=
tive:0 Dest:1)
[    0.053032] IOAPIC[0]: Set routing entry (0-2 -> 0x30 -> IRQ 0 Mode:0 Ac=
tive:0 Dest:1)
[    0.053912] IOAPIC[0]: Set routing entry (0-3 -> 0x33 -> IRQ 3 Mode:0 Ac=
tive:0 Dest:1)
[    0.054800] IOAPIC[0]: Set routing entry (0-4 -> 0x34 -> IRQ 4 Mode:0 Ac=
tive:0 Dest:1)
[    0.055691] IOAPIC[0]: Set routing entry (0-5 -> 0x35 -> IRQ 5 Mode:1 Ac=
tive:0 Dest:1)
[    0.056580] IOAPIC[0]: Set routing entry (0-6 -> 0x36 -> IRQ 6 Mode:0 Ac=
tive:0 Dest:1)
[    0.057496] IOAPIC[0]: Set routing entry (0-7 -> 0x37 -> IRQ 7 Mode:0 Ac=
tive:0 Dest:1)
[    0.058399] IOAPIC[0]: Set routing entry (0-8 -> 0x38 -> IRQ 8 Mode:0 Ac=
tive:0 Dest:1)
[    0.059294] IOAPIC[0]: Set routing entry (0-9 -> 0x39 -> IRQ 9 Mode:1 Ac=
tive:0 Dest:1)
[    0.060032] IOAPIC[0]: Set routing entry (0-10 -> 0x3a -> IRQ 10 Mode:1 =
Active:0 Dest:1)
[    0.060964] IOAPIC[0]: Set routing entry (0-11 -> 0x3b -> IRQ 11 Mode:1 =
Active:0 Dest:1)
[    0.061862] IOAPIC[0]: Set routing entry (0-12 -> 0x3c -> IRQ 12 Mode:0 =
Active:0 Dest:1)
[    0.062747] IOAPIC[0]: Set routing entry (0-13 -> 0x3d -> IRQ 13 Mode:0 =
Active:0 Dest:1)
[    0.063649] IOAPIC[0]: Set routing entry (0-14 -> 0x3e -> IRQ 14 Mode:0 =
Active:0 Dest:1)
[    0.064547] IOAPIC[0]: Set routing entry (0-15 -> 0x3f -> IRQ 15 Mode:0 =
Active:0 Dest:1)
[    0.065426]  apic 0 pin 16 not connected
[    0.065899]  apic 0 pin 17 not connected
[    0.066319]  apic 0 pin 18 not connected
[    0.066749]  apic 0 pin 19 not connected
[    0.067178]  apic 0 pin 20 not connected
[    0.067609]  apic 0 pin 21 not connected
[    0.068038]  apic 0 pin 22 not connected
[    0.068467]  apic 0 pin 23 not connected
[    0.070160] ..TIMER: vector=3D0x30 apic1=3D0 pin1=3D2 apic2=3D-1 pin2=3D=
-1
[    0.070968] smpboot: CPU0: Intel Common KVM processor (fam: 0f, model: 0=
6, stepping: 01)
[    0.072120] Using local APIC timer interrupts.
[    0.072120] calibrating APIC timer ...
[    0.080000] ... lapic delta =3D 6250169
[    0.080000] ... PM-Timer delta =3D 357942
[    0.080000] ... PM-Timer result ok
[    0.080000] ..... delta 6250169
[    0.080000] ..... mult: 268442714
[    0.080000] ..... calibration result: 10000270
[    0.080000] ..... CPU clock speed is 2693.3422 MHz.
[    0.080000] ..... host bus clock speed is 1000.0270 MHz.
[    0.080000] Performance Events: unsupported Netburst CPU model 6 no PMU =
driver, software events only.
[    0.080000] NMI watchdog: disabled (cpu0): hardware events not enabled
[    0.090014] SMP alternatives: lockdep: fixing up alternatives
[    0.091335] CPU 1 irqstacks, hard=3D854d0000 soft=3D854d2000
[    0.092505] smpboot: Booting Node   0, Processors  #1 OK
[    0.010000] Initializing CPU#1
[    0.020000] kvm-clock: cpu 1, msr 0:fffd041, secondary cpu clock
[    0.020000] masked ExtINT on CPU#1
[    0.150082] Brought up 2 CPUs
[    0.150469] smpboot: Total of 2 processors activated (10773.52 BogoMIPS)
[    0.160346] EVM: security.selinux
[    0.160713] EVM: security.SMACK64
[    0.161163] EVM: security.capability
[    0.164944] atomic64 test passed for i586+ platform with CX8 and with SSE
[    0.165852] NET: Registered protocol family 16
[    0.150038] KVM setup async PF for cpu 1
[    0.150038] kvm-stealtime: cpu 1, msr e4f5880
[    0.240847] ACPI: bus type PCI registered
[    0.241387] dca service started, version 1.12.1
[    0.242201] PCI: PCI BIOS revision 2.10 entry at 0xfc6d5, last bus=3D0
[    0.243148] PCI: Using configuration type 1 for base access
[    0.272390] ACPI: Added _OSI(Module Device)
[    0.272916] ACPI: Added _OSI(Processor Device)
[    0.273417] ACPI: Added _OSI(3.0 _SCP Extensions)
[    0.273931] ACPI: Added _OSI(Processor Aggregator Device)
[    0.277017] ACPI: EC: Look up EC in DSDT
[    0.289836] ACPI: Interpreter enabled
[    0.290010] ACPI Exception: AE_NOT_FOUND, While evaluating Sleep State [=
\_S1_] (20130517/hwxface-571)
[    0.291112] ACPI Exception: AE_NOT_FOUND, While evaluating Sleep State [=
\_S2_] (20130517/hwxface-571)
[    0.292209] ACPI: (supports S0 S3 S5)
[    0.292667] ACPI: Using IOAPIC for interrupt routing
[    0.293359] PCI: Using host bridge windows from ACPI; if necessary, use =
"pci=3Dnocrs" and report a bug
[    0.313224] ACPI: PCI Root Bridge [PCI0] (domain 0000 [bus 00-ff])
[    0.314876] acpi PNP0A03:00: fail to add MMCONFIG information, can't acc=
ess extended PCI configuration space under this bridge.
[    0.316478] PCI host bridge to bus 0000:00
[    0.317003] pci_bus 0000:00: root bus resource [bus 00-ff]
[    0.317639] pci_bus 0000:00: root bus resource [io  0x0000-0x0cf7]
[    0.318412] pci_bus 0000:00: root bus resource [io  0x0d00-0xffff]
[    0.319244] pci_bus 0000:00: root bus resource [mem 0x000a0000-0x000bfff=
f]
[    0.320009] pci_bus 0000:00: root bus resource [mem 0x80000000-0xfebffff=
f]
[    0.320875] pci 0000:00:00.0: [8086:1237] type 00 class 0x060000
[    0.322393] pci 0000:00:01.0: [8086:7000] type 00 class 0x060100
[    0.323838] pci 0000:00:01.1: [8086:7010] type 00 class 0x010180
[    0.331243] pci 0000:00:01.1: reg 20: [io  0xc1e0-0xc1ef]
[    0.334098] pci 0000:00:01.3: [8086:7113] type 00 class 0x068000
[    0.335187] pci 0000:00:01.3: quirk: [io  0xb000-0xb03f] claimed by PIIX=
4 ACPI
[    0.335980] pci 0000:00:01.3: quirk: [io  0xb100-0xb10f] claimed by PIIX=
4 SMB
[    0.337073] pci 0000:00:02.0: [1013:00b8] type 00 class 0x030000
[    0.343393] pci 0000:00:02.0: reg 10: [mem 0xfc000000-0xfdffffff pref]
[    0.346973] pci 0000:00:02.0: reg 14: [mem 0xfebe0000-0xfebe0fff]
[    0.357844] pci 0000:00:02.0: reg 30: [mem 0xfebc0000-0xfebcffff pref]
[    0.359362] pci 0000:00:03.0: [1af4:1000] type 00 class 0x020000
[    0.361683] pci 0000:00:03.0: reg 10: [io  0xc1c0-0xc1df]
[    0.363780] pci 0000:00:03.0: reg 14: [mem 0xfebe1000-0xfebe1fff]
[    0.372243] pci 0000:00:03.0: reg 30: [mem 0xfebd0000-0xfebdffff pref]
[    0.373501] pci 0000:00:04.0: [8086:100e] type 00 class 0x020000
[    0.375816] pci 0000:00:04.0: reg 10: [mem 0xfeb80000-0xfeb9ffff]
[    0.377997] pci 0000:00:04.0: reg 14: [io  0xc000-0xc03f]
[    0.386304] pci 0000:00:04.0: reg 30: [mem 0xfeba0000-0xfebbffff pref]
[    0.387497] pci 0000:00:05.0: [1af4:1001] type 00 class 0x010000
[    0.390008] pci 0000:00:05.0: reg 10: [io  0xc040-0xc07f]
[    0.392262] pci 0000:00:05.0: reg 14: [mem 0xfebe2000-0xfebe2fff]
[    0.410538] pci 0000:00:06.0: [1af4:1001] type 00 class 0x010000
[    0.412626] pci 0000:00:06.0: reg 10: [io  0xc080-0xc0bf]
[    0.414593] pci 0000:00:06.0: reg 14: [mem 0xfebe3000-0xfebe3fff]
[    0.432647] pci 0000:00:07.0: [1af4:1001] type 00 class 0x010000
[    0.434728] pci 0000:00:07.0: reg 10: [io  0xc0c0-0xc0ff]
[    0.441385] pci 0000:00:07.0: reg 14: [mem 0xfebe4000-0xfebe4fff]
[    0.450071] pci 0000:00:08.0: [1af4:1001] type 00 class 0x010000
[    0.452087] pci 0000:00:08.0: reg 10: [io  0xc100-0xc13f]
[    0.460010] pci 0000:00:08.0: reg 14: [mem 0xfebe5000-0xfebe5fff]
[    0.474553] pci 0000:00:09.0: [1af4:1001] type 00 class 0x010000
[    0.476557] pci 0000:00:09.0: reg 10: [io  0xc140-0xc17f]
[    0.478462] pci 0000:00:09.0: reg 14: [mem 0xfebe6000-0xfebe6fff]
[    0.486959] pci 0000:00:0a.0: [1af4:1001] type 00 class 0x010000
[    0.491454] pci 0000:00:0a.0: reg 10: [io  0xc180-0xc1bf]
[    0.493404] pci 0000:00:0a.0: reg 14: [mem 0xfebe7000-0xfebe7fff]
[    0.504662] pci 0000:00:0b.0: [8086:25ab] type 00 class 0x088000
[    0.506025] pci 0000:00:0b.0: reg 10: [mem 0xfebe8000-0xfebe800f]
[    0.511236] pci_bus 0000:00: on NUMA node 0
[    0.517944] acpi PNP0A03:00: ACPI _OSC support notification failed, disa=
bling PCIe ASPM
[    0.518759] acpi PNP0A03:00: Unable to request _OSC control (_OSC suppor=
t mask: 0x08)
[    0.521332] ACPI: PCI Interrupt Link [LNKA] (IRQs 5 *10 11)
[    0.522312] ACPI: PCI Interrupt Link [LNKB] (IRQs 5 *10 11)
[    0.523269] ACPI: PCI Interrupt Link [LNKC] (IRQs 5 10 *11)
[    0.524221] ACPI: PCI Interrupt Link [LNKD] (IRQs 5 10 *11)
[    0.525010] ACPI: PCI Interrupt Link [LNKS] (IRQs *9)
[    0.526773] ACPI: Enabled 16 GPEs in block 00 to 0F
[    0.527315] acpi root: \_SB_.PCI0 notify handler is installed
[    0.528005] Found 1 acpi root devices
[    0.528781] vgaarb: device added: PCI:0000:00:02.0,decodes=3Dio+mem,owns=
=3Dio+mem,locks=3Dnone
[    0.529601] vgaarb: loaded
[    0.529888] vgaarb: bridge control possible 0000:00:02.0
[    0.554408] ACPI: bus type USB registered
[    0.554958] usbcore: registered new interface driver usbfs
[    0.555547] usbcore: registered new interface driver hub
[    0.558475] usbcore: registered new device driver usb
[    0.559198] pps_core: LinuxPPS API ver. 1 registered
[    0.559706] pps_core: Software ver. 5.3.6 - Copyright 2005-2007 Rodolfo =
Giometti <giometti@linux.it>
[    0.560022] PTP clock support registered
[    0.560470] EDAC MC: Ver: 3.0.0
[    0.561500] wmi: Mapper loaded
[    0.562124] Advanced Linux Sound Architecture Driver Initialized.
[    0.562746] PCI: Using ACPI for IRQ routing
[    0.563185] PCI: pci_cache_line_size set to 64 bytes
[    0.563911] e820: reserve RAM buffer [mem 0x0009fc00-0x0009ffff]
[    0.564534] e820: reserve RAM buffer [mem 0x0fffe000-0x0fffffff]
[    0.565775] NET: Registered protocol family 23
[    0.566353] Bluetooth: Core ver 2.16
[    0.566764] NET: Registered protocol family 31
[    0.567242] Bluetooth: HCI device and connection manager initialized
[    0.567897] Bluetooth: HCI socket layer initialized
[    0.568407] Bluetooth: L2CAP socket layer initialized
[    0.568945] Bluetooth: SCO socket layer initialized
[    0.580121] NetLabel: Initializing
[    0.580493] NetLabel:  domain hash size =3D 128
[    0.580951] NetLabel:  protocols =3D UNLABELED CIPSOv4
[    0.581550] NetLabel:  unlabeled traffic allowed by default
[    0.582273] nfc: nfc_init: NFC Core ver 0.1
[    0.582785] NET: Registered protocol family 39
[    0.584148] HPET: 3 timers in total, 0 timers will be used for per-cpu t=
imer
[    0.590049] cfg80211: Calling CRDA to update world regulatory domain
[    0.591222] Switching to clocksource kvm-clock
[    0.592620] Warning: could not register annotated branches stats
[    0.722594] FS-Cache: Loaded
[    0.723174] pnp: PnP ACPI init
[    0.723630] ACPI: bus type PNP registered
[    0.724150] IOAPIC[0]: Set routing entry (0-8 -> 0x38 -> IRQ 8 Mode:0 Ac=
tive:0 Dest:3)
[    0.725077] pnp 00:00: Plug and Play ACPI device, IDs PNP0b00 (active)
[    0.725823] IOAPIC[0]: Set routing entry (0-1 -> 0x31 -> IRQ 1 Mode:0 Ac=
tive:0 Dest:3)
[    0.726759] pnp 00:01: Plug and Play ACPI device, IDs PNP0303 (active)
[    0.746653] IOAPIC[0]: Set routing entry (0-12 -> 0x3c -> IRQ 12 Mode:0 =
Active:0 Dest:3)
[    0.747743] pnp 00:02: Plug and Play ACPI device, IDs PNP0f13 (active)
[    0.748536] IOAPIC[0]: Set routing entry (0-6 -> 0x36 -> IRQ 6 Mode:0 Ac=
tive:0 Dest:3)
[    0.749394] pnp 00:03: [dma 2]
[    0.749805] pnp 00:03: Plug and Play ACPI device, IDs PNP0700 (active)
[    0.750653] IOAPIC[0]: Set routing entry (0-7 -> 0x37 -> IRQ 7 Mode:0 Ac=
tive:0 Dest:3)
[    0.751917] pnp 00:04: Plug and Play ACPI device, IDs PNP0400 (active)
[    0.752756] IOAPIC[0]: Set routing entry (0-4 -> 0x34 -> IRQ 4 Mode:0 Ac=
tive:0 Dest:3)
[    0.753684] pnp 00:05: Plug and Play ACPI device, IDs PNP0501 (active)
[    0.754928] pnp 00:06: Plug and Play ACPI device, IDs PNP0103 (active)
[    0.756522] pnp: PnP ACPI: found 7 devices
[    0.756974] ACPI: bus type PNP unregistered
[    0.757419] INFO_MDMA: LNW DMA Driver Version 1.1.0
[    0.806906] pci_bus 0000:00: resource 4 [io  0x0000-0x0cf7]
[    0.807525] pci_bus 0000:00: resource 5 [io  0x0d00-0xffff]
[    0.808099] pci_bus 0000:00: resource 6 [mem 0x000a0000-0x000bffff]
[    0.808752] pci_bus 0000:00: resource 7 [mem 0x80000000-0xfebfffff]
[    0.809553] NET: Registered protocol family 2
[    0.810584] TCP established hash table entries: 2048 (order: 2, 16384 by=
tes)
[    0.824453] TCP bind hash table entries: 2048 (order: 4, 73728 bytes)
[    0.825265] TCP: Hash tables configured (established 2048 bind 2048)
[    0.825999] TCP: reno registered
[    0.826367] UDP hash table entries: 256 (order: 2, 20480 bytes)
[    0.827021] UDP-Lite hash table entries: 256 (order: 2, 20480 bytes)
[    0.827963] NET: Registered protocol family 1
[    0.828485] pci 0000:00:00.0: Limiting direct PCI/PCI transfers
[    0.829125] pci 0000:00:01.0: PIIX3: Enabling Passive Release
[    0.829762] pci 0000:00:01.0: Activating ISA DMA hang workarounds
[    0.830479] pci 0000:00:02.0: Boot video device
[    0.831043] PCI: CLS 0 bytes, default 64
[    0.832003] Unpacking initramfs...
[    2.660756] debug: unmapping init [mem 0x8673f000-0x87feffff]
[    3.165341] DMA-API: preallocated 65536 debug entries
[    3.165898] DMA-API: debugging enabled by kernel config
[    3.167203] kvm: no hardware support
[    3.167610] has_svm: not amd
[    3.167913] kvm: no hardware support
[    3.168886] Machine check injector initialized
[    3.169779] apm: BIOS not found.
[    3.227044] PCLMULQDQ-NI instructions are not detected.
[    3.260906] Initializing RT-Tester: OK
[    3.261719] audit: initializing netlink socket (disabled)
[    3.262624] type=3D2000 audit(1372365372.260:1): initialized
[    3.303601] HugeTLB registered 4 MB page size, pre-allocated 0 pages
[    3.305166] VFS: Disk quotas dquot_6.5.2
[    3.305660] Dquot-cache hash table entries: 1024 (order 0, 4096 bytes)
[    3.307641] jffs2: version 2.2. (SUMMARY) =20
[    3.308709] ROMFS MTD (C) 2007 Red Hat, Inc.
[    3.394001] alg: No test for crc32 (crc32-table)
[    3.394686] alg: No test for stdrng (krng)
[    3.395422] NET: Registered protocol family 38
[    3.395924] Key type asymmetric registered
[    3.396365] Asymmetric key parser 'x509' registered
[    3.396875] test_string_helpers: Running tests...
[    3.398304] pci_hotplug: PCI Hot Plug PCI Core version: 0.5
[    3.398888] cpqphp: Compaq Hot Plug PCI Controller Driver version: 0.9.8
[    3.399629] ibmphpd: IBM Hot Plug PCI Controller Driver version: 0.6
[    3.408572] shpchp: Standard Hot Plug PCI Controller Driver version: 0.4
[    3.409865] rivafb_setup START
[    3.410566] nvidiafb_setup START
[    3.411367] vmlfb: initializing
[    3.411981] no IO addresses supplied
[    3.412687] usbcore: registered new interface driver smscufx
[    3.449462] uvesafb: failed to execute /sbin/v86d
[    3.449978] uvesafb: make sure that the v86d helper is installed and exe=
cutable
[    3.451925] uvesafb: Getting VBE info block failed (eax=3D0x4f00, err=3D=
-2)
[    3.452770] uvesafb: vbe_init() failed with -22
[    3.453392] uvesafb: probe of uvesafb.0 failed with error -22
[    3.454181] ipmi message handler version 39.2
[    3.454765] ipmi device interface
[    3.455271] IPMI System Interface driver.
[    3.455888] ipmi_si: Adding default-specified kcs state machine
[    3.456666] ipmi_si: Trying default-specified kcs state machine at i/o a=
ddress 0xca2, slave address 0x0, irq 0
[    3.457927] ipmi_si: Interface detection failed
[    3.492633] ipmi_si: Adding default-specified smic state machine
[    3.493299] ipmi_si: Trying default-specified smic state machine at i/o =
address 0xca9, slave address 0x0, irq 0
[    3.494329] ipmi_si: Interface detection failed
[    3.530125] ipmi_si: Adding default-specified bt state machine
[    3.530818] ipmi_si: Trying default-specified bt state machine at i/o ad=
dress 0xe4, slave address 0x0, irq 0
[    3.531884] ipmi_si: Interface detection failed
[    3.570249] ipmi_si: Unable to find any System Interface(s)
[    3.570922] IPMI Watchdog: driver initialized
[    3.571412] Copyright (C) 2004 MontaVista Software - IPMI Powerdown via =
sys_reboot.
[    3.572531] input: Power Button as /devices/LNXSYSTM:00/LNXPWRBN:00/inpu=
t/input0
[    3.573331] ACPI: Power Button [PWRF]
[    3.578411] ioatdma: Intel(R) QuickData Technology Driver 4.00
[    3.581558] ACPI: PCI Interrupt Link [LNKC] enabled at IRQ 11
[    3.582228] IOAPIC[0]: Set routing entry (0-11 -> 0x3b -> IRQ 11 Mode:1 =
Active:0 Dest:3)
[    3.583934] virtio-pci 0000:00:03.0: setting latency timer to 64
[    3.586426] ACPI: PCI Interrupt Link [LNKA] enabled at IRQ 10
[    3.587041] IOAPIC[0]: Set routing entry (0-10 -> 0x3a -> IRQ 10 Mode:1 =
Active:0 Dest:3)
[    3.588744] virtio-pci 0000:00:05.0: setting latency timer to 64
[    3.607743] ACPI: PCI Interrupt Link [LNKB] enabled at IRQ 10
[    3.609676] virtio-pci 0000:00:06.0: setting latency timer to 64
[    3.613876] virtio-pci 0000:00:07.0: setting latency timer to 64
[    3.617670] ACPI: PCI Interrupt Link [LNKD] enabled at IRQ 11
[    3.633074] virtio-pci 0000:00:08.0: setting latency timer to 64
[    3.639328] virtio-pci 0000:00:09.0: setting latency timer to 64
[    3.645201] virtio-pci 0000:00:0a.0: setting latency timer to 64
[    3.770890] Serial: 8250/16550 driver, 4 ports, IRQ sharing disabled
[    3.794965] 00:05: ttyS0 at I/O 0x3f8 (irq =3D 4) is a 16550A
[    3.797890] sonypi: Sony Programmable I/O Controller Driver v1.26.
[    3.798608] Non-volatile memory driver v1.3
[    3.799058] toshiba: not a supported Toshiba laptop
[    3.800171] platform pc8736x_gpio.0: NatSemi pc8736x GPIO Driver Initial=
izing
[    3.800974] platform pc8736x_gpio.0: no device found
[    3.801643] nsc_gpio initializing
[    3.802038] telclk_interrupt =3D 0xf non-mcpbl0010 hw.
[    3.802596] Linux agpgart interface v0.103
[    3.803915] Hangcheck: starting hangcheck timer 0.9.1 (tick is 180 secon=
ds, margin is 60 seconds).
[    3.804867] Hangcheck: Using getrawmonotonic().
[    3.805777] [drm] Initialized drm 1.1.0 20060810
[    3.829223] [TTM] Zone  kernel: Available graphics memory: 102648 kiB
[    3.829957] [TTM] Initializing pool allocator
[    3.830706] ------------[ cut here ]------------
[    3.831240] WARNING: at /c/kernel-tests/src/linux/kernel/workqueue.c:143=
2 __queue_delayed_work+0x81/0x247()
[    3.832303] CPU: 0 PID: 1 Comm: swapper/0 Not tainted 3.10.0-rc7-wl-0159=
6-gb53e037 #1
[    3.833158]  00000000 00000000 85429d24 798531bf 85429d3c 7906c42f 79083=
1cf 00000201
[    3.834185]  00000001 7ea3ec14 85429d4c 7906c4d7 00000009 00000000 85429=
d70 790831cf
[    3.835827]  8542b770 7ea3ec34 00000020 00000001 00000246 00000000 00000=
020 85429d90
[    3.836829] Call Trace:
[    3.837115]  [<798531bf>] dump_stack+0x16/0x18
[    3.837597]  [<7906c42f>] warn_slowpath_common+0x48/0x5f
[    3.838154]  [<790831cf>] ? __queue_delayed_work+0x81/0x247
[    3.838740]  [<7906c4d7>] warn_slowpath_null+0x14/0x18
[    3.839278]  [<790831cf>] __queue_delayed_work+0x81/0x247
[    3.839849]  [<79084358>] queue_delayed_work_on+0x42/0x59
[    3.840437]  [<792d944c>] schedule_delayed_work+0x16/0x18
[    3.840453]  [<792da72b>] drm_helper_probe_single_connector_modes+0xf5/0=
x2be
[    3.840453]  [<792d7821>] drm_fb_helper_probe_connector_modes+0x3a/0x4e
[    3.840453]  [<792d8fdc>] drm_fb_helper_initial_config+0x14d/0x3ae
[    3.840453]  [<79110996>] ? __kmalloc_node+0x6a/0xd6
[    3.840453]  [<792d9641>] ? drm_helper_disable_unused_functions+0xc3/0xdc
[    3.840453]  [<7934cd7c>] cirrus_fbdev_init+0x7c/0x8d
[    3.840453]  [<7934c623>] cirrus_modeset_init+0x145/0x186
[    3.840453]  [<7934b925>] cirrus_driver_load+0x88/0xce
[    3.840453]  [<792e4321>] drm_get_pci_dev+0x136/0x214
[    3.840453]  [<7934c724>] cirrus_pci_probe+0x85/0x91
[    3.840453]  [<791fbcfa>] pci_device_probe+0x5c/0x94
[    3.840453]  [<793e4586>] driver_probe_device+0x97/0x1b1
[    3.840453]  [<793e4724>] __driver_attach+0x53/0x6f
[    3.840453]  [<793e31d4>] bus_for_each_dev+0x3e/0x69
[    3.840453]  [<793e44a6>] driver_attach+0x19/0x1b
[    3.840453]  [<793e46d1>] ? __device_attach+0x31/0x31
[    3.840453]  [<793e382e>] bus_add_driver+0xb4/0x1bd
[    3.840453]  [<793e4ef3>] driver_register+0x8c/0xe9
[    3.840453]  [<791fbb2d>] __pci_register_driver+0x4a/0x4d
[    3.840453]  [<792e4470>] drm_pci_init+0x71/0xc9
[    3.840453]  [<79df7f16>] ? ftrace_define_fields_intel_gpu_freq_change+0=
x1c/0x1c
[    3.840453]  [<79df7f31>] cirrus_init+0x1b/0x25
[    3.840453]  [<79dcaa28>] do_one_initcall+0x6b/0x119
[    3.840453]  [<79dcabc7>] kernel_init_freeable+0xf1/0x171
[    3.840453]  [<7984161e>] kernel_init+0xd/0xb9
[    3.840453]  [<79860cf7>] ret_from_kernel_thread+0x1b/0x28
[    3.840453]  [<79841611>] ? rest_init+0xb1/0xb1
[    3.840453] ---[ end trace 4a7136f8b8f4ca4a ]---
[    3.840453] ------------[ cut here ]------------
[    3.840453] WARNING: at /c/kernel-tests/src/linux/kernel/workqueue.c:143=
4 __queue_delayed_work+0x105/0x247()
[    3.840453] CPU: 0 PID: 1 Comm: swapper/0 Tainted: G        W    3.10.0-=
rc7-wl-01596-gb53e037 #1
[    3.840453]  00000000 00000000 85429d24 798531bf 85429d3c 7906c42f 79083=
253 00000201
[    3.840453]  00000001 7ea3ec14 85429d4c 7906c4d7 00000009 00000000 85429=
d70 79083253
[    3.840453]  8542b770 7ea3ec34 00000020 00000001 00000246 00000000 00000=
020 85429d90
[    3.840453] Call Trace:
[    3.840453]  [<798531bf>] dump_stack+0x16/0x18
[    3.840453]  [<7906c42f>] warn_slowpath_common+0x48/0x5f
[    3.840453]  [<79083253>] ? __queue_delayed_work+0x105/0x247
[    3.840453]  [<7906c4d7>] warn_slowpath_null+0x14/0x18
[    3.840453]  [<79083253>] __queue_delayed_work+0x105/0x247
[    3.840453]  [<79084358>] queue_delayed_work_on+0x42/0x59
[    3.840453]  [<792d944c>] schedule_delayed_work+0x16/0x18
[    3.840453]  [<792da72b>] drm_helper_probe_single_connector_modes+0xf5/0=
x2be
[    3.840453]  [<792d7821>] drm_fb_helper_probe_connector_modes+0x3a/0x4e
[    3.840453]  [<792d8fdc>] drm_fb_helper_initial_config+0x14d/0x3ae
[    3.840453]  [<79110996>] ? __kmalloc_node+0x6a/0xd6
[    3.840453]  [<792d9641>] ? drm_helper_disable_unused_functions+0xc3/0xdc
[    3.840453]  [<7934cd7c>] cirrus_fbdev_init+0x7c/0x8d
[    3.840453]  [<7934c623>] cirrus_modeset_init+0x145/0x186
[    3.840453]  [<7934b925>] cirrus_driver_load+0x88/0xce
[    3.840453]  [<792e4321>] drm_get_pci_dev+0x136/0x214
[    3.840453]  [<7934c724>] cirrus_pci_probe+0x85/0x91
[    3.840453]  [<791fbcfa>] pci_device_probe+0x5c/0x94
[    3.840453]  [<793e4586>] driver_probe_device+0x97/0x1b1
[    3.840453]  [<793e4724>] __driver_attach+0x53/0x6f
[    3.840453]  [<793e31d4>] bus_for_each_dev+0x3e/0x69
[    3.840453]  [<793e44a6>] driver_attach+0x19/0x1b
[    3.840453]  [<793e46d1>] ? __device_attach+0x31/0x31
[    3.840453]  [<793e382e>] bus_add_driver+0xb4/0x1bd
[    3.840453]  [<793e4ef3>] driver_register+0x8c/0xe9
[    3.840453]  [<791fbb2d>] __pci_register_driver+0x4a/0x4d
[    3.840453]  [<792e4470>] drm_pci_init+0x71/0xc9
[    3.840453]  [<79df7f16>] ? ftrace_define_fields_intel_gpu_freq_change+0=
x1c/0x1c
[    3.840453]  [<79df7f31>] cirrus_init+0x1b/0x25
[    3.840453]  [<79dcaa28>] do_one_initcall+0x6b/0x119
[    3.840453]  [<79dcabc7>] kernel_init_freeable+0xf1/0x171
[    3.840453]  [<7984161e>] kernel_init+0xd/0xb9
[    3.840453]  [<79860cf7>] ret_from_kernel_thread+0x1b/0x28
[    3.840453]  [<79841611>] ? rest_init+0xb1/0xb1
[    3.840453] ---[ end trace 4a7136f8b8f4ca4b ]---
[    3.840453] ------------[ cut here ]------------
[    3.840453] WARNING: at /c/kernel-tests/src/linux/kernel/workqueue.c:136=
5 __queue_work+0x266/0x3a5()
[    3.840453] CPU: 0 PID: 1 Comm: swapper/0 Tainted: G        W    3.10.0-=
rc7-wl-01596-gb53e037 #1
[    3.840453]  00000000 00000000 85429d00 798531bf 85429d18 7906c42f 79082=
ff8 ffffff01
[    3.840453]  864ef600 00000001 85429d28 7906c4d7 00000009 00000000 85429=
d4c 79082ff8
[    3.840453]  00000000 00000020 00000000 7ea3ec14 00000201 00000001 7ea3e=
c14 85429d70
[    3.840453] Call Trace:
[    3.840453]  [<798531bf>] dump_stack+0x16/0x18
[    3.840453]  [<7906c42f>] warn_slowpath_common+0x48/0x5f
[    3.840453]  [<79082ff8>] ? __queue_work+0x266/0x3a5
[    3.840453]  [<7906c4d7>] warn_slowpath_null+0x14/0x18
[    3.840453]  [<79082ff8>] __queue_work+0x266/0x3a5
[    3.840453]  [<79083271>] __queue_delayed_work+0x123/0x247
[    3.840453]  [<79084358>] queue_delayed_work_on+0x42/0x59
[    3.840453]  [<792d944c>] schedule_delayed_work+0x16/0x18
[    3.840453]  [<792da72b>] drm_helper_probe_single_connector_modes+0xf5/0=
x2be
[    3.840453]  [<792d7821>] drm_fb_helper_probe_connector_modes+0x3a/0x4e
[    3.840453]  [<792d8fdc>] drm_fb_helper_initial_config+0x14d/0x3ae
[    3.840453]  [<79110996>] ? __kmalloc_node+0x6a/0xd6
[    3.840453]  [<792d9641>] ? drm_helper_disable_unused_functions+0xc3/0xdc
[    3.840453]  [<7934cd7c>] cirrus_fbdev_init+0x7c/0x8d
[    3.840453]  [<7934c623>] cirrus_modeset_init+0x145/0x186
[    3.840453]  [<7934b925>] cirrus_driver_load+0x88/0xce
[    3.840453]  [<792e4321>] drm_get_pci_dev+0x136/0x214
[    3.840453]  [<7934c724>] cirrus_pci_probe+0x85/0x91
[    3.840453]  [<791fbcfa>] pci_device_probe+0x5c/0x94
[    3.840453]  [<793e4586>] driver_probe_device+0x97/0x1b1
[    3.840453]  [<793e4724>] __driver_attach+0x53/0x6f
[    3.840453]  [<793e31d4>] bus_for_each_dev+0x3e/0x69
[    3.840453]  [<793e44a6>] driver_attach+0x19/0x1b
[    3.840453]  [<793e46d1>] ? __device_attach+0x31/0x31
[    3.840453]  [<793e382e>] bus_add_driver+0xb4/0x1bd
[    3.840453]  [<793e4ef3>] driver_register+0x8c/0xe9
[    3.840453]  [<791fbb2d>] __pci_register_driver+0x4a/0x4d
[    3.840453]  [<792e4470>] drm_pci_init+0x71/0xc9
[    3.840453]  [<79df7f16>] ? ftrace_define_fields_intel_gpu_freq_change+0=
x1c/0x1c
[    3.840453]  [<79df7f31>] cirrus_init+0x1b/0x25
[    3.840453]  [<79dcaa28>] do_one_initcall+0x6b/0x119
[    3.840453]  [<79dcabc7>] kernel_init_freeable+0xf1/0x171
[    3.840453]  [<7984161e>] kernel_init+0xd/0xb9
[    3.840453]  [<79860cf7>] ret_from_kernel_thread+0x1b/0x28
[    3.840453]  [<79841611>] ? rest_init+0xb1/0xb1
[    3.840453] ---[ end trace 4a7136f8b8f4ca4c ]---
[    3.921879] [drm] fb mappable at 0x0
[    3.922278] [drm] vram aper at 0x0
[    3.922653] [drm] size 0
[    3.922928] [drm] fb depth is 24
[    3.923270] [drm]    pitch is 3840
[    3.923640] cirrusdrmfb: enable CONFIG_FB_LITTLE_ENDIAN to support this =
framebuffer
[    3.924443] [drm] Initialized cirrus 1.0.0 20110418 for 0000:00:02.0 on =
minor 0
[    3.925437] usbcore: registered new interface driver udl
[    3.927079] ibmasm: IBM ASM Service Processor Driver version 1.0 loaded
[    3.927883] dummy-irq: no IRQ given.  Use irq=3DN
[    3.928804] Silicon Labs C2 port support v. 0.51.0 - (C) 2007 Rodolfo Gi=
ometti
[    3.929725] c2port c2port0: C2 port uc added
[    3.930240] c2port c2port0: uc flash has 30 blocks x 512 bytes (15360 by=
tes total)
[    3.931487] Guest personality initialized and is inactive
[    3.932379] VMCI host device registered (name=3Dvmci, major=3D10, minor=
=3D60)
[    3.933075] Initialized host personality
[    3.934571] usbcore: registered new interface driver viperboard
[    3.955072] mtdoops: mtd device (mtddev=3Dname/number) must be supplied
[    3.955887] SBC-GXx flash: IO:0x258-0x259 MEM:0xdc000-0xdffff
[    3.956606] Could not find PAR responsible for SC520CDP Flash Bank #1
[    3.957273] Trying default address 0x8c00000
[    3.957813] SC520 CDP flash device: 0x800000 at 0x8800000
[    3.958376] Failed to ioremap_nocache
[    3.958774] NetSc520 flash device: 0x100000 at 0x200000
[    3.959357] Failed to ioremap_nocache
[    3.959756] Failed to ioremap_nocache
[    3.961093] Generic platform RAM MTD, (c) 2004 Simtec Electronics
[    3.962611] slram: not enough parameters.
[    3.963073] Ramix PMC551 PCI Mezzanine Ram Driver. (C) 1999,2000 Nortel =
Networks.
[    3.963869] pmc551: not detected
[    3.964274] Spectra MTD driver built on Jun 28 2013 @ 04:17:42
[    4.002168] No valid DiskOnChip devices found
[    4.004001] [nandsim] warning: read_byte: unexpected data output cycle, =
state is STATE_READY return 0x0
[    4.005010] [nandsim] warning: read_byte: unexpected data output cycle, =
state is STATE_READY return 0x0
[    4.005991] [nandsim] warning: read_byte: unexpected data output cycle, =
state is STATE_READY return 0x0
[    4.006973] [nandsim] warning: read_byte: unexpected data output cycle, =
state is STATE_READY return 0x0
[    4.007990] [nandsim] warning: read_byte: unexpected data output cycle, =
state is STATE_READY return 0x0
[    4.008992] [nandsim] warning: read_byte: unexpected data output cycle, =
state is STATE_READY return 0x0
[    4.009999] NAND device: Manufacturer ID: 0x98, Chip ID: 0x39 (Toshiba N=
AND 128MiB 1,8V 8-bit), 128MiB, page size: 512, OOB size: 16
[    4.012380] flash size: 128 MiB
[    4.012823] page size: 512 bytes
[    4.013258] OOB area size: 16 bytes
[    4.013693] sector size: 16 KiB
[    4.014026] pages number: 262144
[    4.014366] pages per sector: 32
[    4.014717] bus width: 8
[    4.014990] bits in sector size: 14
[    4.015358] bits in page size: 9
[    4.015707] bits in OOB size: 4
[    4.016039] flash size with OOB: 135168 KiB
[    4.016502] page address bytes: 4
[    4.016851] sector address bytes: 3
[    4.017217] options: 0x42
[    4.019270] Scanning device for bad blocks
[    4.058186] Creating 1 MTD partitions on "NAND 128MiB 1,8V 8-bit":
[    4.058878] 0x000000000000-0x000008000000 : "NAND simulator partition 0"
[    4.061361] vcan: Virtual CAN interface driver
[    4.061865] CAN device driver interface
[    4.062303] usbcore: registered new interface driver kvaser_usb
[    4.062959] usbcore: registered new interface driver peak_usb
[    4.063666] usbcore: registered new interface driver usb_8dev
[    4.064333] sja1000 CAN netdevice driver
[    4.064807] sja1000_isa: insufficient parameters supplied
[    4.066234] cc770: CAN netdevice driver
[    4.067091] usbcore: registered new interface driver stir4200
[    4.068340] usbcore: registered new interface driver kingsun-sir
[    4.069001] usbcore: registered new interface driver ksdazzle-sir
[    4.083908] Generic UIO driver for PCI 2.3 devices version: 0.01.0
[    4.085203] usbcore: registered new interface driver hwa-rc
[    4.088381] usbcore: registered new interface driver i1480-dfu-usb
[    4.089878] ehci_hcd: USB 2.0 'Enhanced' Host Controller (EHCI) Driver
[    4.090638] ehci-pci: EHCI PCI platform driver
[    4.091154] ehci-platform: EHCI generic platform driver
[    4.103848] usbcore: registered new interface driver wusb-cbaf
[    4.104537] usbcore: registered new interface driver cdc_wdm
[    4.105933] usbcore: registered new interface driver usbtmc
[    4.106597] usbcore: registered new interface driver mdc800
[    4.107182] mdc800: v0.7.5 (30/10/2000):USB Driver for Mustek MDC800 Dig=
ital Camera
[    4.108018] usbcore: registered new interface driver adutux
[    4.108639] usbcore: registered new interface driver cypress_cy7c63
[    4.109321] usbcore: registered new interface driver emi62 - firmware lo=
ader
[    4.110095] driver ftdi-elan
[    4.111588] usbcore: registered new interface driver ftdi-elan
[    4.112236] usbcore: registered new interface driver iowarrior
[    4.113039] usbcore: registered new interface driver isight_firmware
[    4.113746] usbcore: registered new interface driver usblcd
[    4.114815] usbcore: registered new interface driver ldusb
[    4.115444] usbcore: registered new interface driver usbled
[    4.116057] usbcore: registered new interface driver legousbtower
[    4.116727] usbcore: registered new interface driver usbtest
[    4.117348] usbcore: registered new interface driver trancevibrator
[    4.118600] i8042: PNP: PS/2 Controller [PNP0303:KBD,PNP0f13:MOU] at 0x6=
0,0x64 irq 1,12
[    4.134752] serio: i8042 KBD port at 0x60,0x64 irq 1
[    4.135312] serio: i8042 AUX port at 0x60,0x64 irq 12
[    4.160106] tsc: Refined TSC clocksource calibration: 2693.510 MHz
[    4.230120] mousedev: PS/2 mouse device common for all mice
[    4.230776] evbug: Connected device: input0 (Power Button at LNXPWRBN/bu=
tton/input0)
[    4.232691] input: AT Translated Set 2 keyboard as /devices/platform/i80=
42/serio0/input/input1
[    4.233608] evbug: Connected device: input1 (AT Translated Set 2 keyboar=
d at isa0060/serio0/input0)
[    4.236624] usbcore: registered new interface driver xpad
[    4.237273] usbcore: registered new interface driver usb_acecad
[    4.237937] usbcore: registered new interface driver aiptek
[    4.238560] usbcore: registered new interface driver gtco
[    4.239484] usbcore: registered new interface driver hanwang
[    4.247601] usbcore: registered new interface driver kbtab
[    4.248283] usbcore: registered new interface driver wacom
[    4.250435] mk712: device not present
[    4.250925] usbcore: registered new interface driver usbtouchscreen
[    4.253271] piix4_smbus 0000:00:01.3: SMBus Host Controller at 0xb100, r=
evision 0
[    4.491511] i2c-parport-light: adapter type unspecified
[    4.492126] usbcore: registered new interface driver i2c-tiny-usb
[    4.492976] pps pps0: new PPS source ktimer
[    4.493443] pps pps0: ktimer PPS source registered
[    4.494393] Driver for 1-wire Dallas network protocol.
[    4.495050] usbcore: registered new interface driver DS9490R
[    4.495976] 1-Wire driver for the DS2760 battery monitor  chip  - (c) 20=
04-2005, Szabolcs Gyurko
[    4.497008] power_supply test_ac: uevent
[    4.497436] power_supply test_ac: POWER_SUPPLY_NAME=3Dtest_ac
[    4.498035] power_supply test_ac: prop ONLINE=3D1
[    4.498571] power_supply test_ac: power_supply_changed
[    4.499217] power_supply test_ac: power_supply_changed_work
[    4.499827] power_supply test_ac: power_supply_update_gen_leds 1
[    4.500510] power_supply test_ac: uevent
[    4.500931] power_supply test_ac: POWER_SUPPLY_NAME=3Dtest_ac
[    4.501533] power_supply test_ac: prop ONLINE=3D1
[    4.502726] power_supply test_battery: uevent
[    4.503201] power_supply test_battery: POWER_SUPPLY_NAME=3Dtest_battery
[    4.503892] power_supply test_battery: prop STATUS=3DDischarging
[    4.504518] power_supply test_battery: prop CHARGE_TYPE=3DFast
[    4.505113] power_supply test_battery: prop HEALTH=3DGood
[    4.505673] power_supply test_battery: prop PRESENT=3D1
[    4.506210] power_supply test_battery: prop TECHNOLOGY=3DLi-ion
[    4.506824] power_supply test_battery: prop CHARGE_FULL_DESIGN=3D100
[    4.507487] power_supply test_battery: prop CHARGE_FULL=3D100
[    4.508080] power_supply test_battery: prop CHARGE_NOW=3D50
[    4.508659] power_supply test_battery: prop CAPACITY=3D50
[    4.509213] power_supply test_battery: prop CAPACITY_LEVEL=3DNormal
[    4.509862] power_supply test_battery: prop TIME_TO_EMPTY_AVG=3D3600
[    4.510559] power_supply test_battery: prop TIME_TO_FULL_NOW=3D3600
[    4.511199] power_supply test_battery: prop MODEL_NAME=3DTest battery
[    4.511863] power_supply test_battery: prop MANUFACTURER=3DLinux
[    4.512482] power_supply test_battery: prop SERIAL_NUMBER=3D3.10.0-rc7-w=
l-01596-gb53e037
[    4.513299] power_supply test_battery: prop TEMP=3D26
[    4.513826] power_supply test_battery: prop VOLTAGE_NOW=3D3300
[    4.528473] power_supply test_battery: power_supply_changed
[    4.529110] power_supply test_battery: power_supply_changed_work
[    4.529754] power_supply test_battery: power_supply_update_bat_leds 2
[    4.530475] power_supply test_battery: uevent
[    4.530997] power_supply test_battery: POWER_SUPPLY_NAME=3Dtest_battery
[    4.531698] power_supply test_battery: prop STATUS=3DDischarging
[    4.532315] power_supply test_battery: prop CHARGE_TYPE=3DFast
[    4.532920] power_supply test_battery: prop HEALTH=3DGood
[    4.533477] power_supply test_battery: prop PRESENT=3D1
[    4.534007] power_supply test_battery: prop TECHNOLOGY=3DLi-ion
[    4.534618] power_supply test_battery: prop CHARGE_FULL_DESIGN=3D100
[    4.535267] power_supply test_battery: prop CHARGE_FULL=3D100
[    4.535866] power_supply test_battery: prop CHARGE_NOW=3D50
[    4.536442] power_supply test_battery: prop CAPACITY=3D50
[    4.536992] power_supply test_battery: prop CAPACITY_LEVEL=3DNormal
[    4.537642] power_supply test_battery: prop TIME_TO_EMPTY_AVG=3D3600
[    4.538287] power_supply test_battery: prop TIME_TO_FULL_NOW=3D3600
[    4.538931] power_supply test_battery: prop MODEL_NAME=3DTest battery
[    4.539596] power_supply test_battery: prop MANUFACTURER=3DLinux
[    4.540243] power_supply test_battery: prop SERIAL_NUMBER=3D3.10.0-rc7-w=
l-01596-gb53e037
[    4.541077] power_supply test_battery: prop TEMP=3D26
[    4.541602] power_supply test_battery: prop VOLTAGE_NOW=3D3300
[    4.542265] power_supply test_usb: uevent
[    4.542705] power_supply test_usb: POWER_SUPPLY_NAME=3Dtest_usb
[    4.543315] power_supply test_usb: prop ONLINE=3D1
[    4.556904] power_supply test_usb: power_supply_changed
[    4.557504] power_supply test_usb: power_supply_changed_work
[    4.558104] power_supply test_usb: power_supply_update_gen_leds 1
[    4.558752] power_supply test_usb: uevent
[    4.559178] power_supply test_usb: POWER_SUPPLY_NAME=3Dtest_usb
[    4.559796] power_supply test_usb: prop ONLINE=3D1
[    7.590087] i2c i2c-0: detect fail: address match, 0x2c
[    7.630101] i2c i2c-0: detect fail: address match, 0x2d
[    7.670096] i2c i2c-0: detect fail: address match, 0x2e
[    7.710103] i2c i2c-0: detect fail: address match, 0x2f
[    8.090944] applesmc: supported laptop not found!
[    8.091446] applesmc: driver init failed (ret=3D-19)!
[   27.780335] pc87360: PC8736x not detected, module not inserted
[   28.431147] intel_powerclamp: Intel powerclamp does not run on family 15=
 model 6
[   28.431943] Bluetooth: Virtual HCI driver ver 1.3
[   28.432513] usbcore: registered new interface driver bcm203x
[   28.433133] usbcore: registered new interface driver bpa10x
[   28.434033] usbcore: registered new interface driver btusb
[   28.434614] Bluetooth: Generic Bluetooth SDIO driver ver 0.1
[   28.435230] usbcore: registered new interface driver ath3k
[   28.437127] cpuidle: using governor ladder
[   28.437575] cpuidle: using governor menu
[   28.437993] sdhci: Secure Digital Host Controller Interface driver
[   28.438637] sdhci: Copyright(c) Pierre Ossman
[   28.439185] VUB300 Driver rom wait states =3D 1C irqpoll timeout =3D 0400
[   28.444572] usbcore: registered new interface driver vub300
[   28.445249] usbcore: registered new interface driver ushc
[   28.445875] sdhci-pltfm: SDHCI platform and OF driver helper
[   28.447869] ledtrig-cpu: registered to indicate activity on CPUs
[   28.451140] hidraw: raw HID events driver (C) Jiri Kosina
[   28.454250] usbcore: registered new interface driver usbhid
[   28.454857] usbhid: USB HID core driver
[   28.455335] goldfish_pdev_bus goldfish_pdev_bus: unable to reserve Goldf=
ish MMIO.
[   28.456127] goldfish_pdev_bus: probe of goldfish_pdev_bus failed with er=
ror -16
[   28.461445] no UART detected at 0x1
[   28.462605] input: PC Speaker as /devices/platform/pcspkr/input/input2
[   28.463302] evbug: Connected device: input2 (PC Speaker at isa0061/input=
0)
[   28.465419] PCSP: CONFIG_DEBUG_PAGEALLOC is enabled, which may make the =
sound noisy.
[   28.466555] usbcore: registered new interface driver snd-usb-audio
[   28.467239] usbcore: registered new interface driver snd-usb-usx2y
[   28.467926] usbcore: registered new interface driver snd-usb-us122l
[   28.468615] usbcore: registered new interface driver snd-usb-caiaq
[   28.469287] usbcore: registered new interface driver snd-usb-6fire
[   28.470308] oprofile: using NMI interrupt.
[   28.470834] pktgen: Packet Generator for packet performance testing. Ver=
sion: 2.74
[   28.472062] netem: version 1.3
[   28.472473] gre: GRE over IPv4 demultiplexor driver
[   28.473004] ip_gre: GRE over IPv4 tunneling driver
[   28.474990] TCP: bic registered
[   28.475339] TCP: cubic registered
[   28.475704] TCP: westwood registered
[   28.476084] TCP: hybla registered
[   28.476435] TCP: htcp registered
[   28.476785] TCP: vegas registered
[   28.477137] TCP: veno registered
[   28.477480] TCP: lp registered
[   28.477817] TCP: illinois registered
[   28.478252] NET: Registered protocol family 10
[   28.480173] mip6: Mobile IPv6
[   28.480521] NET: Registered protocol family 15
[   28.481058] NET: Registered protocol family 4
[   28.481570] can: controller area network core (rev 20120528 abi 9)
[   28.482263] NET: Registered protocol family 29
[   28.482745] can: broadcast manager protocol (rev 20120528 t)
[   28.484655] Bluetooth: RFCOMM socket layer initialized
[   28.485203] Bluetooth: RFCOMM ver 1.11
[   28.485607] Bluetooth: HIDP (Human Interface Emulation) ver 1.2
[   28.486233] Bluetooth: HIDP socket layer initialized
[   28.486815] NET: Registered protocol family 33
[   28.487289] Key type rxrpc registered
[   28.487683] Key type rxrpc_s registered
[   28.488094] NET4: DECnet for Linux: V.2.5.68s (C) 1995-2003 Linux DECnet=
 Project Team
[   28.489267] DECnet: Routing cache hash table of 256 buckets, 9Kbytes
[   28.489979] NET: Registered protocol family 12
[   28.491233] DCCP: Activated CCID 2 (TCP-like)
[   28.492009] sctp: Hash tables configured (established 1638 bind 1820)
[   28.493064] sctp: sctp_init_sock(sk: 7e7f6000)
[   28.493797] NET: Registered protocol family 21
[   28.494346] Registered RDS/iwarp transport
[   28.494818] Registered RDS/infiniband transport
[   28.495292] tipc: Activated (version 2.0.0)
[   28.496207] NET: Registered protocol family 30
[   28.496690] tipc: Started in single node mode
[   28.497469] NET: Registered protocol family 37
[   28.497961] NET: Registered protocol family 36
[   28.498460] Key type ceph registered
[   28.498914] libceph: loaded (mon/osd proto 15/24)
[   28.501742] batman_adv: B.A.T.M.A.N. advanced 2013.2.0 (compatibility ve=
rsion 14) loaded
[   28.502596] openvswitch: Open vSwitch switching datapath
[   28.505202]=20
[   28.505202] printing PIC contents
[   28.505728] ... PIC  IMR: ffff
[   28.506058] ... PIC  IRR: 1013
[   28.506994] ... PIC  ISR: 0000
[   28.507326] ... PIC ELCR: 0c00
[   28.507702] printing local APIC contents on CPU#0/0:
[   28.508341] ... APIC ID:      00000000 (0)
[   28.508951] ... APIC VERSION: 00050014
[   28.509391] ... APIC TASKPRI: 00000000 (00)
[   28.509843] ... APIC PROCPRI: 00000000
[   28.510281] ... APIC LDR: 01000000
[   28.510659] ... APIC DFR: ffffffff
[   28.511027] ... APIC SPIV: 000001ff
[   28.511470] ... APIC ISR field:
[   28.511591] 000000000000000000000000000000000000000000000000000000000000=
0000
[   28.511591] ... APIC TMR field:
[   28.511591] 000000000200000000000000000000000000000000000000000000000000=
0000
[   28.511591] ... APIC IRR field:
[   28.511591] 000000000000000000000000000000000000000000000000000000000000=
8000
[   28.511591] ... APIC ESR: 00000000
[   28.511591] ... APIC ICR: 000008fd
[   28.511591] ... APIC ICR2: 02000000
[   28.511591] ... APIC LVTT: 000000ef
[   28.511591] ... APIC LVTPC: 00010000
[   28.511591] ... APIC LVT0: 00010700
[   28.511591] ... APIC LVT1: 00000400
[   28.511591] ... APIC LVTERR: 000000fe
[   28.511591] ... APIC TMICT: 0008041b
[   28.511591] ... APIC TMCCT: 00000000
[   28.511591] ... APIC TDCR: 00000003
[   28.511591]=20
[   28.520488] number of MP IRQ sources: 15.
[   28.520934] number of IO-APIC #0 registers: 24.
[   28.521408] testing the IO APIC.......................
[   28.521967] IO APIC #0......
[   28.522278] .... register #00: 00000000
[   28.522687] .......    : physical APIC id: 00
[   28.523144] .......    : Delivery Type: 0
[   28.523574] .......    : LTS          : 0
[   28.523995] .... register #01: 00170011
[   28.524395] .......     : max redirection entries: 17
[   28.524927] .......     : PRQ implemented: 0
[   28.525374] .......     : IO APIC version: 11
[   28.525836] .... register #02: 00000000
[   28.526237] .......     : arbitration: 00
[   28.526663] .... IRQ redirection table:
[   28.527077] 1    0    0   0   0    0    0    00
[   28.529005] 0    0    0   0   0    1    1    31
[   28.529489] 0    0    0   0   0    1    1    30
[   28.529992] 0    0    0   0   0    1    1    33
[   28.530502] 1    0    0   0   0    1    1    34
[   28.530996] 1    1    0   0   0    1    1    35
[   28.531480] 0    0    0   0   0    1    1    36
[   28.531972] 0    0    0   0   0    1    1    37
[   28.532454] 0    0    0   0   0    1    1    38
[   28.532947] 0    1    0   0   0    1    1    39
[   28.533430] 1    1    0   0   0    1    1    3A
[   28.533920] 1    1    0   0   0    1    1    3B
[   28.534402] 0    0    0   0   0    1    1    3C
[   28.534891] 0    0    0   0   0    1    1    3D
[   28.535376] 0    0    0   0   0    1    1    3E
[   28.535868] 0    0    0   0   0    1    1    3F
[   28.536351] 1    0    0   0   0    0    0    00
[   28.536841] 1    0    0   0   0    0    0    00
[   28.537325] 1    0    0   0   0    0    0    00
[   28.537818] 1    0    0   0   0    0    0    00
[   28.538301] 1    0    0   0   0    0    0    00
[   28.538789] 1    0    0   0   0    0    0    00
[   28.539270] 1    0    0   0   0    0    0    00
[   28.539758] 1    0    0   0   0    0    0    00
[   28.540249] IRQ to pin mappings:
[   28.540602] IRQ0 -> 0:2
[   28.540894] IRQ1 -> 0:1
[   28.541760] IRQ3 -> 0:3
[   28.542054] IRQ4 -> 0:4
[   28.542347] IRQ5 -> 0:5
[   28.542649] IRQ6 -> 0:6
[   28.542941] IRQ7 -> 0:7
[   28.543235] IRQ8 -> 0:8
[   28.543528] IRQ9 -> 0:9
[   28.543826] IRQ10 -> 0:10
[   28.544137] IRQ11 -> 0:11
[   28.544448] IRQ12 -> 0:12
[   28.544764] IRQ13 -> 0:13
[   28.545073] IRQ14 -> 0:14
[   28.545382] IRQ15 -> 0:15
[   28.545699] .................................... done.
[   28.546237] Using IPI No-Shortcut mode
[   28.547660] registered taskstats version 1
[   28.552982] Key type trusted registered
[   28.554285] Key type encrypted registered
[   28.558810] dmaengine: __dma_request_channel: fail ((null))
[   28.560142] ALSA device list:
[   28.560471]   #0: Dummy 1
[   28.560762]   #1: Internal PC-Speaker at port 0x61
[   28.562110] debug: unmapping init [mem 0x79dca000-0x79e73fff]
[   28.563462] Write protecting the kernel text: 8592k
[   28.564300] Write protecting the kernel read-only data: 4304k
mountall: Event failed
 * Asking all remaining processes to terminate...      =20

 * Killing all remaining processes...      =20

udevd[2550]: inotify_init failed: Function not implemented

udevd[2550]: error initializing inotify

 * Deactivating swap...      =20

udevd[2562]: error initializing inotify


udevd[2567]: inotify_init failed: Function not implemented

udevd[2567]: error initializing inotify

udevd[2573]: inotify_init failed: Function not implemented

udevd[2573]: error initializing inotify

udevd[2576]: inotify_init failed: Function not implemented

udevd[2576]: error initializing inotify

umount: /run/lock: not mounted
udevd[2580]: error: runtime directory '/run/udev' not writable, for now fal=
ling back to '/dev/.udev'
udevd[2582]: inotify_init failed: Function not implemented

udevd[2582]: error initializing inotify

udevd[2583]: error: runtime directory '/run/udev' not writable, for now fal=
ling back to '/dev/.udev'
udevd[2586]: inotify_init failed: Function not implemented

udevd[2586]: error initializing inotify

udevd[2589]: error: runtime directory '/run/udev' not writable, for now fal=
ling back to '/dev/.udev'
udevd[2590]: inotify_init failed: Function not implemented

udevd[2590]: error initializing inotify

udevd[2592]: error: runtime directory '/run/udev' not writable, for now fal=
ling back to '/dev/.udev'
 * Will now restart
udevd[2593]: inotify_init failed: Function not implemented

udevd[2593]: error initializing inotify

udevd[2594]: error: runtime directory '/run/udev' not writable, for now fal=
ling back to '/dev/.udev'
udevd[2596]: inotify_init failed: Function not implemented

udevd[2596]: error initializing inotify

udevd[2597]: error: runtime directory '/run/udev' not writable, for now fal=
ling back to '/dev/.udev'
udevd[2598]: inotify_init failed: Function not implemented

udevd[2598]: error initializing inotify

[   40.660982] Unregister pv shared memory for cpu 1
[   40.661497] Unregister pv shared memory for cpu 0
[   40.668675] power_supply test_ac: uevent
[   40.674208] Restarting system.
[   40.674210] reboot: machine restart
Elapsed time: 45
qemu-system-x86_64 -cpu kvm64 -enable-kvm -kernel /tmp//kernel/i386-randcon=
fig-s07-0628/b53e037930134d11fa6307162b41fb19b6c43643/vmlinuz-3.10.0-rc7-wl=
-01596-gb53e037-10423 -append 'hung_task_panic=3D1 rcutree.rcu_cpu_stall_ti=
meout=3D100 log_buf_len=3D8M ignore_loglevel debug sched_debug apic=3Ddebug=
 dynamic_printk sysrq_always_enabled panic=3D10  prompt_ramdisk=3D0 console=
=3DttyS0,115200 console=3Dtty0 vga=3Dnormal  root=3D/dev/ram0 rw link=3D/ke=
rnel-tests/run-queue/kvm/i386-randconfig-s07-0628/devel-snb-i386-2013062803=
52/.vmlinuz-b53e037930134d11fa6307162b41fb19b6c43643-20130628043743-2-vp br=
anch=3Dlinux-devel/devel-snb-i386-201306280352  BOOT_IMAGE=3D/kernel/i386-r=
andconfig-s07-0628/b53e037930134d11fa6307162b41fb19b6c43643/vmlinuz-3.10.0-=
rc7-wl-01596-gb53e037'  -initrd /kernel-tests/initrd/quantal-core-i386.cgz =
-m 256M -smp 2 -net nic,vlan=3D0,macaddr=3D00:00:00:00:00:00,model=3Dvirtio=
 -net user,vlan=3D0,hostfwd=3Dtcp::14519-:22 -net nic,vlan=3D1,model=3De100=
0 -net user,vlan=3D1 -boot order=3Dnc -no-reboot -watchdog i6300esb -drive =
file=3D/fs/LABEL=3DKVM/diska-vp-10423,media=3Ddisk,if=3Dvirtio -drive file=
=3D/fs/LABEL=3DKVM/diskb-vp-10423,media=3Ddisk,if=3Dvirtio -drive file=3D/f=
s/LABEL=3DKVM/diskc-vp-10423,media=3Ddisk,if=3Dvirtio -drive file=3D/fs/LAB=
EL=3DKVM/diskd-vp-10423,media=3Ddisk,if=3Dvirtio -drive file=3D/fs/LABEL=3D=
KVM/diske-vp-10423,media=3Ddisk,if=3Dvirtio -drive file=3D/fs/LABEL=3DKVM/d=
iskf-vp-10423,media=3Ddisk,if=3Dvirtio -pidfile /dev/shm/kboot/pid-vp-lkp-1=
0423 -serial file:/dev/shm/kboot/serial-vp-lkp-10423 -daemonize -display no=
ne -monitor null=20

--k+w/mQv8wyuph6w0
Content-Type: application/octet-stream
Content-Disposition: attachment; filename="bisect-b53e037930134d11fa6307162b41fb19b6c43643-i386-randconfig-s07-0628-cirrus_init+-x-53954.log"
Content-Transfer-Encoding: base64

Z2l0IGNoZWNrb3V0IDllODk1YWNlNWQ4MmRmODkyOWIxNmY1OGU5ZjUxNWY2ZDU0YWI4MmQK
UHJldmlvdXMgSEVBRCBwb3NpdGlvbiB3YXMgYjUzZTAzNy4uLiBNZXJnZSByZW1vdGUtdHJh
Y2tpbmcgYnJhbmNoICd4bG54L3p5bnEvY2xrJyBpbnRvIGRldmVsLXNuYi1pMzg2LTIwMTMw
NjI4MDM1MgpIRUFEIGlzIG5vdyBhdCA5ZTg5NWFjLi4uIExpbnV4IDMuMTAtcmM3CmxzIC1h
IC9rZXJuZWwtdGVzdHMvcnVuLXF1ZXVlL2t2bS9pMzg2LXJhbmRjb25maWctczA3LTA2Mjgv
bGludXgtZGV2ZWw6ZGV2ZWwtc25iLWkzODYtMjAxMzA2MjgwMzUyOjllODk1YWNlNWQ4MmRm
ODkyOWIxNmY1OGU5ZjUxNWY2ZDU0YWI4MmQ6YmlzZWN0LW5ldAoKMjAxMy0wNi0yOS0wOTox
NTowMCA5ZTg5NWFjZTVkODJkZjg5MjliMTZmNThlOWY1MTVmNmQ1NGFiODJkIHJldXNlIC9r
ZXJuZWwvaTM4Ni1yYW5kY29uZmlnLXMwNy0wNjI4LzllODk1YWNlNWQ4MmRmODkyOWIxNmY1
OGU5ZjUxNWY2ZDU0YWI4MmQvdm1saW51ei0zLjEwLjAtcmM3CgoyMDEzLTA2LTI5LTA5OjE1
OjAwIGRldGVjdGluZyBib290IHN0YXRlIC4JMTAJMTMJMTQJMTcJMTguLi4uCTE5LgkyMCBT
VUNDRVNTCgpiaXNlY3Q6IGdvb2QgY29tbWl0IDllODk1YWNlNWQ4MmRmODkyOWIxNmY1OGU5
ZjUxNWY2ZDU0YWI4MmQKZ2l0IGJpc2VjdCBzdGFydCBiNTNlMDM3OTMwMTM0ZDExZmE2MzA3
MTYyYjQxZmIxOWI2YzQzNjQzIDllODk1YWNlNWQ4MmRmODkyOWIxNmY1OGU5ZjUxNWY2ZDU0
YWI4MmQgLS0KUHJldmlvdXMgSEVBRCBwb3NpdGlvbiB3YXMgOWU4OTVhYy4uLiBMaW51eCAz
LjEwLXJjNwpTd2l0Y2hlZCB0byBicmFuY2ggJ21hc3RlcicKWW91ciBicmFuY2ggaXMgYmVo
aW5kICdvcmlnaW4vbWFzdGVyJyBieSAzMDQ4IGNvbW1pdHMsIGFuZCBjYW4gYmUgZmFzdC1m
b3J3YXJkZWQuCkJpc2VjdGluZzogNzk0IHJldmlzaW9ucyBsZWZ0IHRvIHRlc3QgYWZ0ZXIg
dGhpcyAocm91Z2hseSAxMCBzdGVwcykKWzNlZjZmYjBhY2JmODQ2ZWMyNjdjODZiNGI3ODQx
Y2E3Y2MxZmQ2MzZdIE1lcmdlIHJlbW90ZS10cmFja2luZyBicmFuY2ggJ3ZpcmVzaGsvY3B1
ZnJlcS1maXgtbm90aWZpY2F0aW9uJyBpbnRvIGRldmVsLXNuYi1pMzg2LTIwMTMwNjI4MDM1
MgpnaXQgYmlzZWN0IHJ1biAvYy9rZXJuZWwtdGVzdHMvYmlzZWN0LXRlc3QtYm9vdC1mYWls
dXJlLnNoIC9ob21lL3dmZy9uZXQvb2JqLWJpc2VjdApydW5uaW5nIC9jL2tlcm5lbC10ZXN0
cy9iaXNlY3QtdGVzdC1ib290LWZhaWx1cmUuc2ggL2hvbWUvd2ZnL25ldC9vYmotYmlzZWN0
CmxzIC1hIC9rZXJuZWwtdGVzdHMvcnVuLXF1ZXVlL2t2bS9pMzg2LXJhbmRjb25maWctczA3
LTA2MjgvbGludXgtZGV2ZWw6ZGV2ZWwtc25iLWkzODYtMjAxMzA2MjgwMzUyOjNlZjZmYjBh
Y2JmODQ2ZWMyNjdjODZiNGI3ODQxY2E3Y2MxZmQ2MzY6YmlzZWN0LW5ldAoKMjAxMy0wNi0y
OS0wOToyMTo1OCAzZWY2ZmIwYWNiZjg0NmVjMjY3Yzg2YjRiNzg0MWNhN2NjMWZkNjM2IGNv
bXBpbGluZwo2MzAgcmVhbCAgMTcwNSB1c2VyICAxNDQgc3lzICAyOTMuNTclIGNwdSAJaTM4
Ni1yYW5kY29uZmlnLXMwNy0wNjI4CgoyMDEzLTA2LTI5LTA5OjMzOjU1IGRldGVjdGluZyBi
b290IHN0YXRlIDMuMTAuMC1yYzctMDA4MDEtZzNlZjZmYjAuLiBURVNUIEZBSUxVUkUKWyAg
ICAzLjQyMTA3OF0gW1RUTV0gSW5pdGlhbGl6aW5nIHBvb2wgYWxsb2NhdG9yClsgICAgMy40
MjE3NzddIC0tLS0tLS0tLS0tLVsgY3V0IGhlcmUgXS0tLS0tLS0tLS0tLQpbICAgIDMuNDIy
MjkwXSBXQVJOSU5HOiBhdCAvYy93ZmcvbmV0L2tlcm5lbC93b3JrcXVldWUuYzoxNDMyIF9f
cXVldWVfZGVsYXllZF93b3JrKzB4ODEvMHgyNDcoKQpbICAgIDMuNDIzMTcyXSBDUFU6IDAg
UElEOiAxIENvbW06IHN3YXBwZXIvMCBOb3QgdGFpbnRlZCAzLjEwLjAtcmM3LTAwODAxLWcz
ZWY2ZmIwICM5MApbICAgIDMuNDI0MTE1XSAgMDAwMDAwMDAgMDAwMDAwMDAgODU0MjlkMjQg
Nzk4NTFiNDcgODU0MjlkM2MgNzkwNmM0MmYgNzkwODMxY2YgMDAwMDAyMDEKWyAgICAzLjQy
NTA1OF0gIDAwMDAwMDAxIDdlYTRhYzE0IDg1NDI5ZDRjIDc5MDZjNGQ3IDAwMDAwMDA5IDAw
MDAwMDAwIDg1NDI5ZDcwIDc5MDgzMWNmClsgICAgMy40MjYwMzFdICA4NTQyYjc3MCA3ZWE0
YWMzNCAwMDAwMDAyMCAwMDAwMDAwMSAwMDAwMDI0NiAwMDAwMDAwMCAwMDAwMDAyMCA4NTQy
OWQ5MApbICAgIDMuNDI2OTkyXSBDYWxsIFRyYWNlOgpbICAgIDMuNDI3MjcyXSAgWzw3OTg1
MWI0Nz5dIGR1bXBfc3RhY2srMHgxNi8weDE4ClsgICAgMy40MzAzMjldICBbPDc5MDZjNDJm
Pl0gd2Fybl9zbG93cGF0aF9jb21tb24rMHg0OC8weDVmClsgICAgMy40MzAzMjldICBbPDc5
MDgzMWNmPl0gPyBfX3F1ZXVlX2RlbGF5ZWRfd29yaysweDgxLzB4MjQ3ClsgICAgMy40MzAz
MjldICBbPDc5MDZjNGQ3Pl0gd2Fybl9zbG93cGF0aF9udWxsKzB4MTQvMHgxOApbICAgIDMu
NDMwMzI5XSAgWzw3OTA4MzFjZj5dIF9fcXVldWVfZGVsYXllZF93b3JrKzB4ODEvMHgyNDcK
WyAgICAzLjQzMDMyOV0gIFs8NzkwODQzNTg+XSBxdWV1ZV9kZWxheWVkX3dvcmtfb24rMHg0
Mi8weDU5ClsgICAgMy40MzAzMjldICBbPDc5MmQ3ZDk5Pl0gc2NoZWR1bGVfZGVsYXllZF93
b3JrKzB4MTYvMHgxOApbICAgIDMuNDMwMzI5XSAgWzw3OTJkOTA3OD5dIGRybV9oZWxwZXJf
cHJvYmVfc2luZ2xlX2Nvbm5lY3Rvcl9tb2RlcysweGY1LzB4MmJlClsgICAgMy40MzAzMjld
ICBbPDc5MmQ2MTZlPl0gZHJtX2ZiX2hlbHBlcl9wcm9iZV9jb25uZWN0b3JfbW9kZXMrMHgz
YS8weDRlClsgICAgMy40MzAzMjldICBbPDc5MmQ3OTI5Pl0gZHJtX2ZiX2hlbHBlcl9pbml0
aWFsX2NvbmZpZysweDE0ZC8weDNhZQpbICAgIDMuNDMwMzI5XSAgWzw3OTExMDk5Nj5dID8g
X19rbWFsbG9jX25vZGUrMHg2YS8weGQ2ClsgICAgMy40MzAzMjldICBbPDc5MmQ3ZjhlPl0g
PyBkcm1faGVscGVyX2Rpc2FibGVfdW51c2VkX2Z1bmN0aW9ucysweGMzLzB4ZGMKWyAgICAz
LjQzMDMyOV0gIFs8NzkzNGI2Yzk+XSBjaXJydXNfZmJkZXZfaW5pdCsweDdjLzB4OGQKWyAg
ICAzLjQzMDMyOV0gIFs8NzkzNGFmNzA+XSBjaXJydXNfbW9kZXNldF9pbml0KzB4MTQ1LzB4
MTg2ClsgICAgMy40MzAzMjldICBbPDc5MzRhMjcyPl0gY2lycnVzX2RyaXZlcl9sb2FkKzB4
ODgvMHhjZQpbICAgIDMuNDMwMzI5XSAgWzw3OTJlMmM2ZT5dIGRybV9nZXRfcGNpX2Rldisw
eDEzNi8weDIxNApbICAgIDMuNDMwMzI5XSAgWzw3OTM0YjA3MT5dIGNpcnJ1c19wY2lfcHJv
YmUrMHg4NS8weDkxClsgICAgMy40MzAzMjldICBbPDc5MWZiY2JhPl0gcGNpX2RldmljZV9w
cm9iZSsweDVjLzB4OTQKWyAgICAzLjQzMDMyOV0gIFs8NzkzZTJlZDM+XSBkcml2ZXJfcHJv
YmVfZGV2aWNlKzB4OTcvMHgxYjEKWyAgICAzLjQzMDMyOV0gIFs8NzkzZTMwNzE+XSBfX2Ry
aXZlcl9hdHRhY2grMHg1My8weDZmClsgICAgMy40MzAzMjldICBbPDc5M2UxYjIxPl0gYnVz
X2Zvcl9lYWNoX2RldisweDNlLzB4NjkKWyAgICAzLjQzMDMyOV0gIFs8NzkzZTJkZjM+XSBk
cml2ZXJfYXR0YWNoKzB4MTkvMHgxYgpbICAgIDMuNDMwMzI5XSAgWzw3OTNlMzAxZT5dID8g
X19kZXZpY2VfYXR0YWNoKzB4MzEvMHgzMQpbICAgIDMuNDMwMzI5XSAgWzw3OTNlMjE3Yj5d
IGJ1c19hZGRfZHJpdmVyKzB4YjQvMHgxYmQKWyAgICAzLjQzMDMyOV0gIFs8NzkzZTM4NDA+
XSBkcml2ZXJfcmVnaXN0ZXIrMHg4Yy8weGU5ClsgICAgMy40MzAzMjldICBbPDc5MWZiYWVk
Pl0gX19wY2lfcmVnaXN0ZXJfZHJpdmVyKzB4NGEvMHg0ZApbICAgIDMuNDMwMzI5XSAgWzw3
OTJlMmRiZD5dIGRybV9wY2lfaW5pdCsweDcxLzB4YzkKWyAgICAzLjQzMDMyOV0gIFs8Nzlk
ZWZmMTY+XSA/IGZ0cmFjZV9kZWZpbmVfZmllbGRzX2ludGVsX2dwdV9mcmVxX2NoYW5nZSsw
eDFjLzB4MWMKWyAgICAzLjQzMDMyOV0gIFs8NzlkZWZmMzE+XSBjaXJydXNfaW5pdCsweDFi
LzB4MjUKWyAgICAzLjQzMDMyOV0gIFs8NzlkYzJhMjg+XSBkb19vbmVfaW5pdGNhbGwrMHg2
Yi8weDExOQpbICAgIDMuNDMwMzI5XSAgWzw3OWRjMmJjNz5dIGtlcm5lbF9pbml0X2ZyZWVh
YmxlKzB4ZjEvMHgxNzEKWyAgICAzLjQzMDMyOV0gIFs8Nzk4M2ZmOGU+XSBrZXJuZWxfaW5p
dCsweGQvMHhiOQpbICAgIDMuNDMwMzI5XSAgWzw3OTg1ZjM3Nz5dIHJldF9mcm9tX2tlcm5l
bF90aHJlYWQrMHgxYi8weDI4ClsgICAgMy40MzAzMjldICBbPDc5ODNmZjgxPl0gPyByZXN0
X2luaXQrMHhiMS8weGIxClsgICAgMy40MzAzMjldIC0tLVsgZW5kIHRyYWNlIDY0Y2I3Y2Yw
MzkzMDViZWIgXS0tLQova2VybmVsL2kzODYtcmFuZGNvbmZpZy1zMDctMDYyOC8zZWY2ZmIw
YWNiZjg0NmVjMjY3Yzg2YjRiNzg0MWNhN2NjMWZkNjM2L2RtZXNnLWt2bS12cC0yMTQ3Mi0y
MDEzMDYyOTA5MzYxMS0tCi9rZXJuZWwvaTM4Ni1yYW5kY29uZmlnLXMwNy0wNjI4LzNlZjZm
YjBhY2JmODQ2ZWMyNjdjODZiNGI3ODQxY2E3Y2MxZmQ2MzYvZG1lc2cta3ZtLXZwLTIyNjMz
LTIwMTMwNjI5MDkzNjA1LS0KL2tlcm5lbC9pMzg2LXJhbmRjb25maWctczA3LTA2MjgvM2Vm
NmZiMGFjYmY4NDZlYzI2N2M4NmI0Yjc4NDFjYTdjYzFmZDYzNi9kbWVzZy1rdm0tdnAtOTQ0
Ny0yMDEzMDYyOTA5MzYxMi0tCgpCaXNlY3Rpbmc6IDQwMCByZXZpc2lvbnMgbGVmdCB0byB0
ZXN0IGFmdGVyIHRoaXMgKHJvdWdobHkgOSBzdGVwcykKW2UyNmU4MTE1Yzc4Y2EyZjdlMTA0
YWQwODUzNDNlMzdjNTQ0MDMzYWVdIGFseCBidWlsdGluIEhBQ0sKcnVubmluZyAvYy9rZXJu
ZWwtdGVzdHMvYmlzZWN0LXRlc3QtYm9vdC1mYWlsdXJlLnNoIC9ob21lL3dmZy9uZXQvb2Jq
LWJpc2VjdApscyAtYSAva2VybmVsLXRlc3RzL3J1bi1xdWV1ZS9rdm0vaTM4Ni1yYW5kY29u
ZmlnLXMwNy0wNjI4L2xpbnV4LWRldmVsOmRldmVsLXNuYi1pMzg2LTIwMTMwNjI4MDM1Mjpl
MjZlODExNWM3OGNhMmY3ZTEwNGFkMDg1MzQzZTM3YzU0NDAzM2FlOmJpc2VjdC1uZXQKCjIw
MTMtMDYtMjktMDk6MzU6MDIgZTI2ZTgxMTVjNzhjYTJmN2UxMDRhZDA4NTM0M2UzN2M1NDQw
MzNhZSBjb21waWxpbmcKODcyIHJlYWwgIDE3MDkgdXNlciAgMTQzIHN5cyAgMjEyLjM5JSBj
cHUgCWkzODYtcmFuZGNvbmZpZy1zMDctMDYyOAoKMjAxMy0wNi0yOS0wOTo1MDowNyBkZXRl
Y3RpbmcgYm9vdCBzdGF0ZSAzLjEwLjAtcmM3LTAwNDAwLWdlMjZlODExLi4uIFRFU1QgRkFJ
TFVSRQpbICAgIDYuODM3MDU1XSBbVFRNXSBJbml0aWFsaXppbmcgcG9vbCBhbGxvY2F0b3IK
WyAgICA2LjgzODQzM10gLS0tLS0tLS0tLS0tWyBjdXQgaGVyZSBdLS0tLS0tLS0tLS0tClsg
ICAgNi44MzkwNTNdIFdBUk5JTkc6IGF0IC9jL3dmZy9uZXQva2VybmVsL3dvcmtxdWV1ZS5j
OjE0MzIgX19xdWV1ZV9kZWxheWVkX3dvcmsrMHg4MS8weDI0NygpClsgICAgNi44NDAxMDZd
IENQVTogMSBQSUQ6IDEgQ29tbTogc3dhcHBlci8wIE5vdCB0YWludGVkIDMuMTAuMC1yYzct
MDA0MDAtZ2UyNmU4MTEgIzkxClsgICAgNi44NDAxMDZdICAwMDAwMDAwMCAwMDAwMDAwMCA4
NTQyOWQyNCA3OTg0ZTJkZCA4NTQyOWQzYyA3OTA2YzMyZSA3OTA4MzA4MyAwMDAwMDIwMQpb
ICAgIDYuODQwMTA2XSAgMDAwMDAwMDEgN2VhMzI1MGMgODU0MjlkNGMgNzkwNmMzZDYgMDAw
MDAwMDkgMDAwMDAwMDAgODU0MjlkNzAgNzkwODMwODMKWyAgICA2Ljg0MDEwNl0gIDg1NDJl
NzcwIDdlYTMyNTJjIDAwMDAwMDIwIDAwMDAwMDAxIDAwMDAwMjQ2IDAwMDAwMDAwIDAwMDAw
MDIwIDg1NDI5ZDkwClsgICAgNi44NDAxMDZdIENhbGwgVHJhY2U6ClsgICAgNi44NDAxMDZd
ICBbPDc5ODRlMmRkPl0gZHVtcF9zdGFjaysweDE2LzB4MTgKWyAgICA2Ljg0MDEwNl0gIFs8
NzkwNmMzMmU+XSB3YXJuX3Nsb3dwYXRoX2NvbW1vbisweDQ4LzB4NWYKWyAgICA2Ljg0MDEw
Nl0gIFs8NzkwODMwODM+XSA/IF9fcXVldWVfZGVsYXllZF93b3JrKzB4ODEvMHgyNDcKWyAg
ICA2Ljg0MDEwNl0gIFs8NzkwNmMzZDY+XSB3YXJuX3Nsb3dwYXRoX251bGwrMHgxNC8weDE4
ClsgICAgNi44NDAxMDZdICBbPDc5MDgzMDgzPl0gX19xdWV1ZV9kZWxheWVkX3dvcmsrMHg4
MS8weDI0NwpbICAgIDYuODQwMTA2XSAgWzw3OTA4NDIwYz5dIHF1ZXVlX2RlbGF5ZWRfd29y
a19vbisweDQyLzB4NTkKWyAgICA2Ljg0MDEwNl0gIFs8NzkyZDYwY2M+XSBzY2hlZHVsZV9k
ZWxheWVkX3dvcmsrMHgxNi8weDE4ClsgICAgNi44NDAxMDZdICBbPDc5MmQ3M2FiPl0gZHJt
X2hlbHBlcl9wcm9iZV9zaW5nbGVfY29ubmVjdG9yX21vZGVzKzB4ZjUvMHgyYmUKWyAgICA2
Ljg0MDEwNl0gIFs8NzkyZDQ0YTE+XSBkcm1fZmJfaGVscGVyX3Byb2JlX2Nvbm5lY3Rvcl9t
b2RlcysweDNhLzB4NGUKWyAgICA2Ljg0MDEwNl0gIFs8NzkyZDVjNWM+XSBkcm1fZmJfaGVs
cGVyX2luaXRpYWxfY29uZmlnKzB4MTRkLzB4M2FlClsgICAgNi44NDAxMDZdICBbPDc5MTBm
NDM5Pl0gPyBfX2ttYWxsb2Nfbm9kZSsweDZhLzB4ZDYKWyAgICA2Ljg0MDEwNl0gIFs8Nzky
ZDYyYzE+XSA/IGRybV9oZWxwZXJfZGlzYWJsZV91bnVzZWRfZnVuY3Rpb25zKzB4YzMvMHhk
YwpbICAgIDYuODQwMTA2XSAgWzw3OTM0OTlmYz5dIGNpcnJ1c19mYmRldl9pbml0KzB4N2Mv
MHg4ZApbICAgIDYuODQwMTA2XSAgWzw3OTM0OTJhMz5dIGNpcnJ1c19tb2Rlc2V0X2luaXQr
MHgxNDUvMHgxODYKWyAgICA2Ljg0MDEwNl0gIFs8NzkzNDg1YTU+XSBjaXJydXNfZHJpdmVy
X2xvYWQrMHg4OC8weGNlClsgICAgNi44NDAxMDZdICBbPDc5MmUwZmExPl0gZHJtX2dldF9w
Y2lfZGV2KzB4MTM2LzB4MjE0ClsgICAgNi44NDAxMDZdICBbPDc5MzQ5M2E0Pl0gY2lycnVz
X3BjaV9wcm9iZSsweDg1LzB4OTEKWyAgICA2Ljg0MDEwNl0gIFs8NzkxZmE2NGQ+XSBwY2lf
ZGV2aWNlX3Byb2JlKzB4NWMvMHg5NApbICAgIDYuODQwMTA2XSAgWzw3OTNlMDQ2ZD5dIGRy
aXZlcl9wcm9iZV9kZXZpY2UrMHg5Ny8weDFiMQpbICAgIDYuODQwMTA2XSAgWzw3OTNlMDYw
Yj5dIF9fZHJpdmVyX2F0dGFjaCsweDUzLzB4NmYKWyAgICA2Ljg0MDEwNl0gIFs8NzkzZGYw
YmI+XSBidXNfZm9yX2VhY2hfZGV2KzB4M2UvMHg2OQpbICAgIDYuODQwMTA2XSAgWzw3OTNl
MDM4ZD5dIGRyaXZlcl9hdHRhY2grMHgxOS8weDFiClsgICAgNi44NDAxMDZdICBbPDc5M2Uw
NWI4Pl0gPyBfX2RldmljZV9hdHRhY2grMHgzMS8weDMxClsgICAgNi44NDAxMDZdICBbPDc5
M2RmNzE1Pl0gYnVzX2FkZF9kcml2ZXIrMHhiNC8weDFiZApbICAgIDYuODQwMTA2XSAgWzw3
OTNlMGRkYT5dIGRyaXZlcl9yZWdpc3RlcisweDhjLzB4ZTkKWyAgICA2Ljg0MDEwNl0gIFs8
NzkxZmE0ODA+XSBfX3BjaV9yZWdpc3Rlcl9kcml2ZXIrMHg0YS8weDRkClsgICAgNi44NDAx
MDZdICBbPDc5MmUxMGYwPl0gZHJtX3BjaV9pbml0KzB4NzEvMHhjOQpbICAgIDYuODQwMTA2
XSAgWzw3OWRlYmM0Zj5dID8gZnRyYWNlX2RlZmluZV9maWVsZHNfaW50ZWxfZ3B1X2ZyZXFf
Y2hhbmdlKzB4MWMvMHgxYwpbICAgIDYuODQwMTA2XSAgWzw3OWRlYmM2YT5dIGNpcnJ1c19p
bml0KzB4MWIvMHgyNQpbICAgIDYuODQwMTA2XSAgWzw3OWRiZWEyOD5dIGRvX29uZV9pbml0
Y2FsbCsweDZiLzB4MTE5ClsgICAgNi44NDAxMDZdICBbPDc5ZGJlYmM3Pl0ga2VybmVsX2lu
aXRfZnJlZWFibGUrMHhmMS8weDE3MQpbICAgIDYuODQwMTA2XSAgWzw3OTgzY2NhZT5dIGtl
cm5lbF9pbml0KzB4ZC8weGI5ClsgICAgNi44NDAxMDZdICBbPDc5ODViYTM3Pl0gcmV0X2Zy
b21fa2VybmVsX3RocmVhZCsweDFiLzB4MjgKWyAgICA2Ljg0MDEwNl0gIFs8Nzk4M2NjYTE+
XSA/IHJlc3RfaW5pdCsweGIxLzB4YjEKWyAgICA2Ljg0MDEwNl0gLS0tWyBlbmQgdHJhY2Ug
MTFkMDZkYjM0NjhmOTY3YiBdLS0tCi9rZXJuZWwvaTM4Ni1yYW5kY29uZmlnLXMwNy0wNjI4
L2UyNmU4MTE1Yzc4Y2EyZjdlMTA0YWQwODUzNDNlMzdjNTQ0MDMzYWUvZG1lc2cta3ZtLWJh
eS0xNDIwMS0yMDEzMDYyOTA5NTMzMi0zLjEwLjAtcmM3LTAwNDAwLWdlMjZlODExLTkxCi9r
ZXJuZWwvaTM4Ni1yYW5kY29uZmlnLXMwNy0wNjI4L2UyNmU4MTE1Yzc4Y2EyZjdlMTA0YWQw
ODUzNDNlMzdjNTQ0MDMzYWUvZG1lc2cta3ZtLXZwLTI3NTQ5LTIwMTMwNjI5MDk1MjI2LTMu
OS4wLXJjNS0wMDY1MC1nMDNhYTFiYy0xMjAKL2tlcm5lbC9pMzg2LXJhbmRjb25maWctczA3
LTA2MjgvZTI2ZTgxMTVjNzhjYTJmN2UxMDRhZDA4NTM0M2UzN2M1NDQwMzNhZS9kbWVzZy1r
dm0tcm9hbS0yMTk3Ni0yMDEzMDYyOTA5NTM0Mi0zLjEwLjAtcmM3LTAwNDAwLWdlMjZlODEx
LTkxCi9rZXJuZWwvaTM4Ni1yYW5kY29uZmlnLXMwNy0wNjI4L2UyNmU4MTE1Yzc4Y2EyZjdl
MTA0YWQwODUzNDNlMzdjNTQ0MDMzYWUvZG1lc2cta3ZtLWlubi0yNjAwNC0yMDEzMDYyOTA5
NTMzNy0zLjEwLjAtcmM3LTAwNDAwLWdlMjZlODExLTkxCi9rZXJuZWwvaTM4Ni1yYW5kY29u
ZmlnLXMwNy0wNjI4L2UyNmU4MTE1Yzc4Y2EyZjdlMTA0YWQwODUzNDNlMzdjNTQ0MDMzYWUv
ZG1lc2cta3ZtLWNhaXJvLTEwMjE2LTIwMTMwNjI5MDk1MzQ0LS0KL2tlcm5lbC9pMzg2LXJh
bmRjb25maWctczA3LTA2MjgvZTI2ZTgxMTVjNzhjYTJmN2UxMDRhZDA4NTM0M2UzN2M1NDQw
MzNhZS9kbWVzZy1rdm0taW5uLTI3NDgzLTIwMTMwNjI5MDk1MzQwLS0KL2tlcm5lbC9pMzg2
LXJhbmRjb25maWctczA3LTA2MjgvZTI2ZTgxMTVjNzhjYTJmN2UxMDRhZDA4NTM0M2UzN2M1
NDQwMzNhZS9kbWVzZy1rdm0tcm9hbS0yNTI4LTIwMTMwNjI5MDk1MzQwLS0KL2tlcm5lbC9p
Mzg2LXJhbmRjb25maWctczA3LTA2MjgvZTI2ZTgxMTVjNzhjYTJmN2UxMDRhZDA4NTM0M2Uz
N2M1NDQwMzNhZS9kbWVzZy1rdm0taW5uLTI5ODQ5LTIwMTMwNjI5MDk1MzQ0LS0KL2tlcm5l
bC9pMzg2LXJhbmRjb25maWctczA3LTA2MjgvZTI2ZTgxMTVjNzhjYTJmN2UxMDRhZDA4NTM0
M2UzN2M1NDQwMzNhZS9kbWVzZy1rdm0tY2Fpcm8tMTM4ODYtMjAxMzA2MjkwOTUzNTEtLQov
a2VybmVsL2kzODYtcmFuZGNvbmZpZy1zMDctMDYyOC9lMjZlODExNWM3OGNhMmY3ZTEwNGFk
MDg1MzQzZTM3YzU0NDAzM2FlL2RtZXNnLWt2bS12cC01Nzg1LTIwMTMwNjI5MDk1MjIyLS0K
L2tlcm5lbC9pMzg2LXJhbmRjb25maWctczA3LTA2MjgvZTI2ZTgxMTVjNzhjYTJmN2UxMDRh
ZDA4NTM0M2UzN2M1NDQwMzNhZS9kbWVzZy1rdm0tdnAtNjAzMi0yMDEzMDYyOTA5NTIyNC0t
Ci9rZXJuZWwvaTM4Ni1yYW5kY29uZmlnLXMwNy0wNjI4L2UyNmU4MTE1Yzc4Y2EyZjdlMTA0
YWQwODUzNDNlMzdjNTQ0MDMzYWUvZG1lc2cta3ZtLWNhaXJvLTE3NjY5LTIwMTMwNjI5MDk1
MzM3LTMuMTAuMC1yYzctMDA0MDAtZ2UyNmU4MTEtOTEKL2tlcm5lbC9pMzg2LXJhbmRjb25m
aWctczA3LTA2MjgvZTI2ZTgxMTVjNzhjYTJmN2UxMDRhZDA4NTM0M2UzN2M1NDQwMzNhZS9k
bWVzZy1rdm0tdnAtNjQzNi0yMDEzMDYyOTA5NTIyMy0tCi9rZXJuZWwvaTM4Ni1yYW5kY29u
ZmlnLXMwNy0wNjI4L2UyNmU4MTE1Yzc4Y2EyZjdlMTA0YWQwODUzNDNlMzdjNTQ0MDMzYWUv
ZG1lc2cta3ZtLXZwLTY1NzYtMjAxMzA2MjkwOTUyMTYtMy4xMC4wLXJjNy0wMDQwMC1nZTI2
ZTgxMS05MQova2VybmVsL2kzODYtcmFuZGNvbmZpZy1zMDctMDYyOC9lMjZlODExNWM3OGNh
MmY3ZTEwNGFkMDg1MzQzZTM3YzU0NDAzM2FlL2RtZXNnLWt2bS14Ym0tMjQ2ODUtMjAxMzA2
MjkwOTUzNDAtMy4xMC4wLXJjNy0wMDQwMC1nZTI2ZTgxMS05MQova2VybmVsL2kzODYtcmFu
ZGNvbmZpZy1zMDctMDYyOC9lMjZlODExNWM3OGNhMmY3ZTEwNGFkMDg1MzQzZTM3YzU0NDAz
M2FlL2RtZXNnLWt2bS12cC03Mzc4LTIwMTMwNjI5MDk1MjIyLS0KL2tlcm5lbC9pMzg2LXJh
bmRjb25maWctczA3LTA2MjgvZTI2ZTgxMTVjNzhjYTJmN2UxMDRhZDA4NTM0M2UzN2M1NDQw
MzNhZS9kbWVzZy1rdm0tcm9hbS03NDkzLTIwMTMwNjI5MDk1MzQzLS0KCkJpc2VjdGluZzog
MTk5IHJldmlzaW9ucyBsZWZ0IHRvIHRlc3QgYWZ0ZXIgdGhpcyAocm91Z2hseSA4IHN0ZXBz
KQpbNDBjY2M3MmI4NGE4NDhlNmZjYmRiMzhmZTcxNmYwYWM2OTM5NjA5ZV0gZHJtL2k5MTU6
IHJlbGVhc2UgY3Vyc29yIHdoZW4gY3J0YyBpcyBkZXN0cm95ZWQKcnVubmluZyAvYy9rZXJu
ZWwtdGVzdHMvYmlzZWN0LXRlc3QtYm9vdC1mYWlsdXJlLnNoIC9ob21lL3dmZy9uZXQvb2Jq
LWJpc2VjdApscyAtYSAva2VybmVsLXRlc3RzL3J1bi1xdWV1ZS9rdm0vaTM4Ni1yYW5kY29u
ZmlnLXMwNy0wNjI4L2xpbnV4LWRldmVsOmRldmVsLXNuYi1pMzg2LTIwMTMwNjI4MDM1Mjo0
MGNjYzcyYjg0YTg0OGU2ZmNiZGIzOGZlNzE2ZjBhYzY5Mzk2MDllOmJpc2VjdC1uZXQKCjIw
MTMtMDYtMjktMDk6NTE6NDQgNDBjY2M3MmI4NGE4NDhlNmZjYmRiMzhmZTcxNmYwYWM2OTM5
NjA5ZSBjb21waWxpbmcKNDE5IHJlYWwgIDE2NzYgdXNlciAgMTQxIHN5cyAgNDMzLjMwJSBj
cHUgCWkzODYtcmFuZGNvbmZpZy1zMDctMDYyOAoKMjAxMy0wNi0yOS0wOTo1OTozMyBkZXRl
Y3RpbmcgYm9vdCBzdGF0ZSAzLjEwLjAtcmMyLTAwMjAwLWc0MGNjYzcyLi4JMTIJMTUuLi4u
Li4uLi4uLi4JMTYuLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4u
Li4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4u
Li4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4u
Li4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4u
Li4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4u
Li4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uG1sxOzM1bWFkZF90
b19ydW5fcXVldWUgNBtbMG0KLgkyMCBTVUNDRVNTCgpCaXNlY3Rpbmc6IDEwMyByZXZpc2lv
bnMgbGVmdCB0byB0ZXN0IGFmdGVyIHRoaXMgKHJvdWdobHkgNyBzdGVwcykKW2Q1Y2ZiYTFi
OWNlNmYxZjRhZGQ4ZjNjNjdmZGU1MjQzZTU1NDliYmRdIGRybS9hc3Q6IGRvIG5vdCBhdHRl
bXB0IHRvIGFjcXVpcmUgYSByZXNlcnZhdGlvbiB3aGlsZSBpbiBhbiBpbnRlcnJ1cHQgaGFu
ZGxlcgpydW5uaW5nIC9jL2tlcm5lbC10ZXN0cy9iaXNlY3QtdGVzdC1ib290LWZhaWx1cmUu
c2ggL2hvbWUvd2ZnL25ldC9vYmotYmlzZWN0CmxzIC1hIC9rZXJuZWwtdGVzdHMvcnVuLXF1
ZXVlL2t2bS9pMzg2LXJhbmRjb25maWctczA3LTA2MjgvbGludXgtZGV2ZWw6ZGV2ZWwtc25i
LWkzODYtMjAxMzA2MjgwMzUyOmQ1Y2ZiYTFiOWNlNmYxZjRhZGQ4ZjNjNjdmZGU1MjQzZTU1
NDliYmQ6YmlzZWN0LW5ldAoKMjAxMy0wNi0yOS0xMjozOTo1NiBkNWNmYmExYjljZTZmMWY0
YWRkOGYzYzY3ZmRlNTI0M2U1NTQ5YmJkIGNvbXBpbGluZwoyMTYgcmVhbCAgMTY3MyB1c2Vy
ICAxNTMgc3lzICA4NDUuNTQlIGNwdSAJaTM4Ni1yYW5kY29uZmlnLXMwNy0wNjI4CgoyMDEz
LTA2LTI5LTEyOjQzOjQ2IGRldGVjdGluZyBib290IHN0YXRlIDMuMTAuMC1yYzItMDA1NDQt
Z2Q1Y2ZiYTEuCTE3CTIwIFNVQ0NFU1MKCkJpc2VjdGluZzogNTUgcmV2aXNpb25zIGxlZnQg
dG8gdGVzdCBhZnRlciB0aGlzIChyb3VnaGx5IDYgc3RlcHMpClszOTViYTdhYzU5YWMxYWE0
YmIwN2MyMWUzMjExYzJhZjA0NzE5ZjBhXSBkcm0vdHRtOiBnZXQgcmlkIG9mIHR0bV9ib19p
c19yZXNlcnZlZApydW5uaW5nIC9jL2tlcm5lbC10ZXN0cy9iaXNlY3QtdGVzdC1ib290LWZh
aWx1cmUuc2ggL2hvbWUvd2ZnL25ldC9vYmotYmlzZWN0CmxzIC1hIC9rZXJuZWwtdGVzdHMv
cnVuLXF1ZXVlL2t2bS9pMzg2LXJhbmRjb25maWctczA3LTA2MjgvbGludXgtZGV2ZWw6ZGV2
ZWwtc25iLWkzODYtMjAxMzA2MjgwMzUyOjM5NWJhN2FjNTlhYzFhYTRiYjA3YzIxZTMyMTFj
MmFmMDQ3MTlmMGE6YmlzZWN0LW5ldAoKMjAxMy0wNi0yOS0xMjo0NToxOSAzOTViYTdhYzU5
YWMxYWE0YmIwN2MyMWUzMjExYzJhZjA0NzE5ZjBhIGNvbXBpbGluZwoyNDEgcmVhbCAgMTY3
OCB1c2VyICAxNDggc3lzICA3NTcuNDIlIGNwdSAJaTM4Ni1yYW5kY29uZmlnLXMwNy0wNjI4
CgoyMDEzLTA2LTI5LTEyOjQ5OjQyIGRldGVjdGluZyBib290IHN0YXRlIDMuMTAuMC1yYzct
MDAzNDQtZzM5NWJhN2EuLiBURVNUIEZBSUxVUkUKWyAgICAxLjcwMzIwMV0gW1RUTV0gSW5p
dGlhbGl6aW5nIHBvb2wgYWxsb2NhdG9yClsgICAgMS43MDM2MTRdIC0tLS0tLS0tLS0tLVsg
Y3V0IGhlcmUgXS0tLS0tLS0tLS0tLQpbICAgIDEuNzAzOTU4XSBXQVJOSU5HOiBhdCAvYy93
ZmcvbmV0L2tlcm5lbC93b3JrcXVldWUuYzoxNDMyIF9fcXVldWVfZGVsYXllZF93b3JrKzB4
ODEvMHgyNDcoKQpbICAgIDEuNzA0NTU4XSBDUFU6IDAgUElEOiAxIENvbW06IHN3YXBwZXIv
MCBOb3QgdGFpbnRlZCAzLjEwLjAtcmM3LTAwMzQ0LWczOTViYTdhICM5NApbICAgIDEuNzA1
MTA1XSAgMDAwMDAwMDAgMDAwMDAwMDAgODU0MjlkMjQgNzk4NGI5NDUgODU0MjlkM2MgNzkw
NmMzMmUgNzkwODMwODMgMDAwMDAyMDEKWyAgICAxLjcwNTc1Ml0gIDAwMDAwMDAxIDdlYTRh
YzE0IDg1NDI5ZDRjIDc5MDZjM2Q2IDAwMDAwMDA5IDAwMDAwMDAwIDg1NDI5ZDcwIDc5MDgz
MDgzClsgICAgMS43MDYzOTddICA4NTQyZTc3MCA3ZWE0YWMzNCAwMDAwMDAyMCAwMDAwMDAw
MSAwMDAwMDI0NiAwMDAwMDAwMCAwMDAwMDAyMCA4NTQyOWQ5MApbICAgIDEuNzA3MDQxXSBD
YWxsIFRyYWNlOgpbICAgIDEuNzA3MjI2XSAgWzw3OTg0Yjk0NT5dIGR1bXBfc3RhY2srMHgx
Ni8weDE4ClsgICAgMS43MDc1NDldICBbPDc5MDZjMzJlPl0gd2Fybl9zbG93cGF0aF9jb21t
b24rMHg0OC8weDVmClsgICAgMS43MDc5MzZdICBbPDc5MDgzMDgzPl0gPyBfX3F1ZXVlX2Rl
bGF5ZWRfd29yaysweDgxLzB4MjQ3ClsgICAgMS43MDgzMzZdICBbPDc5MDZjM2Q2Pl0gd2Fy
bl9zbG93cGF0aF9udWxsKzB4MTQvMHgxOApbICAgIDEuNzA4NzA3XSAgWzw3OTA4MzA4Mz5d
IF9fcXVldWVfZGVsYXllZF93b3JrKzB4ODEvMHgyNDcKWyAgICAxLjcwOTEwNV0gIFs8Nzkw
ODQyMGM+XSBxdWV1ZV9kZWxheWVkX3dvcmtfb24rMHg0Mi8weDU5ClsgICAgMS43MDk0OTdd
ICBbPDc5MmQ1ZDQyPl0gc2NoZWR1bGVfZGVsYXllZF93b3JrKzB4MTYvMHgxOApbICAgIDEu
NzA5ODg4XSAgWzw3OTJkNzAyMT5dIGRybV9oZWxwZXJfcHJvYmVfc2luZ2xlX2Nvbm5lY3Rv
cl9tb2RlcysweGY1LzB4MmJlClsgICAgMS43MTAwMDhdICBbPDc5MmQ0MTE3Pl0gZHJtX2Zi
X2hlbHBlcl9wcm9iZV9jb25uZWN0b3JfbW9kZXMrMHgzYS8weDRlClsgICAgMS43MTAwMDhd
ICBbPDc5MmQ1OGQyPl0gZHJtX2ZiX2hlbHBlcl9pbml0aWFsX2NvbmZpZysweDE0ZC8weDNh
ZQpbICAgIDEuNzEwMDA4XSAgWzw3OTEwZjQzOT5dID8gX19rbWFsbG9jX25vZGUrMHg2YS8w
eGQ2ClsgICAgMS43MTAwMDhdICBbPDc5MmQ1ZjM3Pl0gPyBkcm1faGVscGVyX2Rpc2FibGVf
dW51c2VkX2Z1bmN0aW9ucysweGMzLzB4ZGMKWyAgICAxLjcxMDAwOF0gIFs8NzkzNDkyNDI+
XSBjaXJydXNfZmJkZXZfaW5pdCsweDdjLzB4OGQKWyAgICAxLjcxMDAwOF0gIFs8NzkzNDhh
ZWM+XSBjaXJydXNfbW9kZXNldF9pbml0KzB4MTQ1LzB4MTg2ClsgICAgMS43MTAwMDhdICBb
PDc5MzQ3ZGVlPl0gY2lycnVzX2RyaXZlcl9sb2FkKzB4ODgvMHhjZQpbICAgIDEuNzEwMDA4
XSAgWzw3OTJlMDk0Nj5dIGRybV9nZXRfcGNpX2RldisweDEzNi8weDIxNApbICAgIDEuNzEw
MDA4XSAgWzw3OTM0OGJlZD5dIGNpcnJ1c19wY2lfcHJvYmUrMHg4NS8weDkxClsgICAgMS43
MTAwMDhdICBbPDc5MWZhMmU5Pl0gcGNpX2RldmljZV9wcm9iZSsweDVjLzB4OTQKWyAgICAx
LjcxMDAwOF0gIFs8NzkzZGUxMTU+XSBkcml2ZXJfcHJvYmVfZGV2aWNlKzB4OTcvMHgxYjEK
WyAgICAxLjcxMDAwOF0gIFs8NzkzZGUyYjM+XSBfX2RyaXZlcl9hdHRhY2grMHg1My8weDZm
ClsgICAgMS43MTAwMDhdICBbPDc5M2RjZDYzPl0gYnVzX2Zvcl9lYWNoX2RldisweDNlLzB4
NjkKWyAgICAxLjcxMDAwOF0gIFs8NzkzZGUwMzU+XSBkcml2ZXJfYXR0YWNoKzB4MTkvMHgx
YgpbICAgIDEuNzEwMDA4XSAgWzw3OTNkZTI2MD5dID8gX19kZXZpY2VfYXR0YWNoKzB4MzEv
MHgzMQpbICAgIDEuNzEwMDA4XSAgWzw3OTNkZDNiZD5dIGJ1c19hZGRfZHJpdmVyKzB4YjQv
MHgxYmQKWyAgICAxLjcxMDAwOF0gIFs8NzkzZGVhODI+XSBkcml2ZXJfcmVnaXN0ZXIrMHg4
Yy8weGU5ClsgICAgMS43MTAwMDhdICBbPDc5MWZhMTFjPl0gX19wY2lfcmVnaXN0ZXJfZHJp
dmVyKzB4NGEvMHg0ZApbICAgIDEuNzEwMDA4XSAgWzw3OTJlMGE5NT5dIGRybV9wY2lfaW5p
dCsweDcxLzB4YzkKWyAgICAxLjcxMDAwOF0gIFs8NzlkZTZjMjU+XSA/IGZ0cmFjZV9kZWZp
bmVfZmllbGRzX2ludGVsX2dwdV9mcmVxX2NoYW5nZSsweDFjLzB4MWMKWyAgICAxLjcxMDAw
OF0gIFs8NzlkZTZjNDA+XSBjaXJydXNfaW5pdCsweDFiLzB4MjUKWyAgICAxLjcxMDAwOF0g
IFs8NzlkYjlhMjg+XSBkb19vbmVfaW5pdGNhbGwrMHg2Yi8weDExOQpbICAgIDEuNzEwMDA4
XSAgWzw3OWRiOWJjNz5dIGtlcm5lbF9pbml0X2ZyZWVhYmxlKzB4ZjEvMHgxNzEKWyAgICAx
LjcxMDAwOF0gIFs8Nzk4M2EzMTY+XSBrZXJuZWxfaW5pdCsweGQvMHhiOQpbICAgIDEuNzEw
MDA4XSAgWzw3OTg1OTAzNz5dIHJldF9mcm9tX2tlcm5lbF90aHJlYWQrMHgxYi8weDI4Clsg
ICAgMS43MTAwMDhdICBbPDc5ODNhMzA5Pl0gPyByZXN0X2luaXQrMHhiMS8weGIxClsgICAg
MS43MTAwMDhdIC0tLVsgZW5kIHRyYWNlIDMyNzM2Y2IzNTNiMzU1NzAgXS0tLQova2VybmVs
L2kzODYtcmFuZGNvbmZpZy1zMDctMDYyOC8zOTViYTdhYzU5YWMxYWE0YmIwN2MyMWUzMjEx
YzJhZjA0NzE5ZjBhL2RtZXNnLWt2bS14Ym0tMjIwMzQtMjAxMzA2MjkxMjUzMDAtMy4xMC4w
LXJjNy0wMDM0NC1nMzk1YmE3YS05NAova2VybmVsL2kzODYtcmFuZGNvbmZpZy1zMDctMDYy
OC8zOTViYTdhYzU5YWMxYWE0YmIwN2MyMWUzMjExYzJhZjA0NzE5ZjBhL2RtZXNnLWt2bS1p
bm4tMjk4NDktMjAxMzA2MjkxMjUzMTMtMy4xMC4wLXJjNy0wMDM0NC1nMzk1YmE3YS05NAov
a2VybmVsL2kzODYtcmFuZGNvbmZpZy1zMDctMDYyOC8zOTViYTdhYzU5YWMxYWE0YmIwN2My
MWUzMjExYzJhZjA0NzE5ZjBhL2RtZXNnLWt2bS12cC0xNzE3Mi0yMDEzMDYyOTEyNTE0NS0z
LjEwLjAtcmM3LTAwMjQzLWc0ZWIyNDQ5LTc0Ci9rZXJuZWwvaTM4Ni1yYW5kY29uZmlnLXMw
Ny0wNjI4LzM5NWJhN2FjNTlhYzFhYTRiYjA3YzIxZTMyMTFjMmFmMDQ3MTlmMGEvZG1lc2ct
a3ZtLXZwLTI0MTgwLTIwMTMwNjI5MTI1MTQ1LTMuOS4wLXJjNS0wMDY1MC1nMDNhYTFiYy0x
MjAKL2tlcm5lbC9pMzg2LXJhbmRjb25maWctczA3LTA2MjgvMzk1YmE3YWM1OWFjMWFhNGJi
MDdjMjFlMzIxMWMyYWYwNDcxOWYwYS9kbWVzZy1rdm0tdnAtMjY3NDQtMjAxMzA2MjkxMjUx
NTEtMy45LjAtcmMxLTAwMDQ1LWdlYmY0NGQxLTExNAova2VybmVsL2kzODYtcmFuZGNvbmZp
Zy1zMDctMDYyOC8zOTViYTdhYzU5YWMxYWE0YmIwN2MyMWUzMjExYzJhZjA0NzE5ZjBhL2Rt
ZXNnLWt2bS12cC00NzcyLTIwMTMwNjI5MTI1MTQ5LTMuMTAuMC1yYzctMDAzNDQtZzM5NWJh
N2EtOTQKL2tlcm5lbC9pMzg2LXJhbmRjb25maWctczA3LTA2MjgvMzk1YmE3YWM1OWFjMWFh
NGJiMDdjMjFlMzIxMWMyYWYwNDcxOWYwYS9kbWVzZy1rdm0td2FpbWVhLTIxNDE4LTIwMTMw
NjI5MTI1MzIzLTMuMTAuMC1yYzctMDAzNDQtZzM5NWJhN2EtOTQKL2tlcm5lbC9pMzg2LXJh
bmRjb25maWctczA3LTA2MjgvMzk1YmE3YWM1OWFjMWFhNGJiMDdjMjFlMzIxMWMyYWYwNDcx
OWYwYS9kbWVzZy1rdm0tdnAtMTE2OTEtMjAxMzA2MjkxMjUxNTItLQova2VybmVsL2kzODYt
cmFuZGNvbmZpZy1zMDctMDYyOC8zOTViYTdhYzU5YWMxYWE0YmIwN2MyMWUzMjExYzJhZjA0
NzE5ZjBhL2RtZXNnLWt2bS13YWltZWEtMjEzNzctMjAxMzA2MjkxMjUzMjQtMy4xLjAtcmM5
LTAwMDY1LWc1M2EwMTlhLTEwOAova2VybmVsL2kzODYtcmFuZGNvbmZpZy1zMDctMDYyOC8z
OTViYTdhYzU5YWMxYWE0YmIwN2MyMWUzMjExYzJhZjA0NzE5ZjBhL2RtZXNnLWt2bS12cC0y
NDUyMS0yMDEzMDYyOTEyNTE1My0zLjEwLjAtcmM3LTAwMTEwLWc5OGI2ZWQwLTE3Ci9rZXJu
ZWwvaTM4Ni1yYW5kY29uZmlnLXMwNy0wNjI4LzM5NWJhN2FjNTlhYzFhYTRiYjA3YzIxZTMy
MTFjMmFmMDQ3MTlmMGEvZG1lc2cta3ZtLXhibS0xNDIzOC0yMDEzMDYyOTEyNTMyMy0tCi9r
ZXJuZWwvaTM4Ni1yYW5kY29uZmlnLXMwNy0wNjI4LzM5NWJhN2FjNTlhYzFhYTRiYjA3YzIx
ZTMyMTFjMmFmMDQ3MTlmMGEvZG1lc2cta3ZtLXhibS0xNDIzOS0yMDEzMDYyOTEyNTMyNy0t
Ci9rZXJuZWwvaTM4Ni1yYW5kY29uZmlnLXMwNy0wNjI4LzM5NWJhN2FjNTlhYzFhYTRiYjA3
YzIxZTMyMTFjMmFmMDQ3MTlmMGEvZG1lc2cta3ZtLXhibS0xNDMzMS0yMDEzMDYyOTEyNTMy
Mi0tCi9rZXJuZWwvaTM4Ni1yYW5kY29uZmlnLXMwNy0wNjI4LzM5NWJhN2FjNTlhYzFhYTRi
YjA3YzIxZTMyMTFjMmFmMDQ3MTlmMGEvZG1lc2cta3ZtLXhibS0xNDM0Mi0yMDEzMDYyOTEy
NTMyNy0tCi9rZXJuZWwvaTM4Ni1yYW5kY29uZmlnLXMwNy0wNjI4LzM5NWJhN2FjNTlhYzFh
YTRiYjA3YzIxZTMyMTFjMmFmMDQ3MTlmMGEvZG1lc2cta3ZtLXhibS0yOTYxNy0yMDEzMDYy
OTEyNTMyMi0tCi9rZXJuZWwvaTM4Ni1yYW5kY29uZmlnLXMwNy0wNjI4LzM5NWJhN2FjNTlh
YzFhYTRiYjA3YzIxZTMyMTFjMmFmMDQ3MTlmMGEvZG1lc2cta3ZtLXhnd28tMTUyODMtMjAx
MzA2MjkxMjUwMDMtMy4xMC4wLXJjNy0wMDM0NC1nMzk1YmE3YS05NAova2VybmVsL2kzODYt
cmFuZGNvbmZpZy1zMDctMDYyOC8zOTViYTdhYzU5YWMxYWE0YmIwN2MyMWUzMjExYzJhZjA0
NzE5ZjBhL2RtZXNnLWt2bS14Z3dvLTYwNTEtMjAxMzA2MjkxMjUwMDQtMy4xLjAtcmM5LTAw
MDY1LWc1M2EwMTlhLTEwOAova2VybmVsL2kzODYtcmFuZGNvbmZpZy1zMDctMDYyOC8zOTVi
YTdhYzU5YWMxYWE0YmIwN2MyMWUzMjExYzJhZjA0NzE5ZjBhL2RtZXNnLWt2bS14Z3dvLTc5
NTYtMjAxMzA2MjkxMjUwMDQtMy45LjAtcmMxLTAwMDQ1LWdlYmY0NGQxLTExNAoKQmlzZWN0
aW5nOiAyMyByZXZpc2lvbnMgbGVmdCB0byB0ZXN0IGFmdGVyIHRoaXMgKHJvdWdobHkgNSBz
dGVwcykKWzFlODc2ZTNiMWE5ZGYyNWJiMDQ2ODJiMGQ0OGFhYTdlOGFlMWZjODJdIE1lcmdl
IGJyYW5jaCAnZm9yLWxpbnVzJyBvZiBnaXQ6Ly9naXQua2VybmVsLm9yZy9wdWIvc2NtL2xp
bnV4L2tlcm5lbC9naXQvczM5MC9saW51eApydW5uaW5nIC9jL2tlcm5lbC10ZXN0cy9iaXNl
Y3QtdGVzdC1ib290LWZhaWx1cmUuc2ggL2hvbWUvd2ZnL25ldC9vYmotYmlzZWN0CmxzIC1h
IC9rZXJuZWwtdGVzdHMvcnVuLXF1ZXVlL2t2bS9pMzg2LXJhbmRjb25maWctczA3LTA2Mjgv
bGludXgtZGV2ZWw6ZGV2ZWwtc25iLWkzODYtMjAxMzA2MjgwMzUyOjFlODc2ZTNiMWE5ZGYy
NWJiMDQ2ODJiMGQ0OGFhYTdlOGFlMWZjODI6YmlzZWN0LW5ldAoKMjAxMy0wNi0yOS0xMjo1
MDo0NSAxZTg3NmUzYjFhOWRmMjViYjA0NjgyYjBkNDhhYWE3ZThhZTFmYzgyIGNvbXBpbGlu
ZwoxODIgcmVhbCAgMTY3MSB1c2VyICAxNDcgc3lzICA5OTYuMDMlIGNwdSAJaTM4Ni1yYW5k
Y29uZmlnLXMwNy0wNjI4CgoyMDEzLTA2LTI5LTEyOjU0OjAxIGRldGVjdGluZyBib290IHN0
YXRlIDMuMTAuMC1yYzctMDAwMjQtZzFlODc2ZTMuCTE4CTIwIFNVQ0NFU1MKCkJpc2VjdGlu
ZzogMTEgcmV2aXNpb25zIGxlZnQgdG8gdGVzdCBhZnRlciB0aGlzIChyb3VnaGx5IDQgc3Rl
cHMpClsxZmI0ODgzYWQ0YWU4ODBkMmVmMTAwZjAwNjI0ZWM3NjYwMDE4MTg2XSByZXNlcnZh
dGlvbjogY3Jvc3MtZGV2aWNlIHJlc2VydmF0aW9uIHN1cHBvcnQsIHY0CnJ1bm5pbmcgL2Mv
a2VybmVsLXRlc3RzL2Jpc2VjdC10ZXN0LWJvb3QtZmFpbHVyZS5zaCAvaG9tZS93ZmcvbmV0
L29iai1iaXNlY3QKbHMgLWEgL2tlcm5lbC10ZXN0cy9ydW4tcXVldWUva3ZtL2kzODYtcmFu
ZGNvbmZpZy1zMDctMDYyOC9saW51eC1kZXZlbDpkZXZlbC1zbmItaTM4Ni0yMDEzMDYyODAz
NTI6MWZiNDg4M2FkNGFlODgwZDJlZjEwMGYwMDYyNGVjNzY2MDAxODE4NjpiaXNlY3QtbmV0
CgoyMDEzLTA2LTI5LTEyOjU1OjM0IDFmYjQ4ODNhZDRhZTg4MGQyZWYxMDBmMDA2MjRlYzc2
NjAwMTgxODYgY29tcGlsaW5nCjE4NiByZWFsICAxNjczIHVzZXIgIDE0NyBzeXMgIDk3NC45
NyUgY3B1IAlpMzg2LXJhbmRjb25maWctczA3LTA2MjgKCjIwMTMtMDYtMjktMTI6NTg6NTUg
ZGV0ZWN0aW5nIGJvb3Qgc3RhdGUgMy4xMC4wLXJjNy0wMDMzMi1nMWZiNDg4My4uIFRFU1Qg
RkFJTFVSRQpbICAgIDIuMTAwNDIwXSBbVFRNXSBJbml0aWFsaXppbmcgcG9vbCBhbGxvY2F0
b3IKWyAgICAyLjEwMTEwOF0gLS0tLS0tLS0tLS0tWyBjdXQgaGVyZSBdLS0tLS0tLS0tLS0t
ClsgICAgMi4xMDE2NDVdIFdBUk5JTkc6IGF0IC9jL3dmZy9uZXQva2VybmVsL3dvcmtxdWV1
ZS5jOjE0MzIgX19xdWV1ZV9kZWxheWVkX3dvcmsrMHg4MS8weDI0NygpClsgICAgMi4xMDI1
NTBdIENQVTogMCBQSUQ6IDEgQ29tbTogc3dhcHBlci8wIE5vdCB0YWludGVkIDMuMTAuMC1y
YzctMDAzMzItZzFmYjQ4ODMgIzk2ClsgICAgMi4xMDMzNzRdICAwMDAwMDAwMCAwMDAwMDAw
MCA4NTQyOWQyNCA3OTg0YWM3ZCA4NTQyOWQzYyA3OTA2YzMyZSA3OTA4MzA4MyAwMDAwMDIw
MQpbICAgIDIuMTA0MzYxXSAgMDAwMDAwMDEgN2VhNDljMTQgODU0MjlkNGMgNzkwNmMzZDYg
MDAwMDAwMDkgMDAwMDAwMDAgODU0MjlkNzAgNzkwODMwODMKWyAgICAyLjEwNTMzN10gIDg1
NDJlNzcwIDdlYTQ5YzM0IDAwMDAwMDIwIDAwMDAwMDAxIDAwMDAwMjQ2IDAwMDAwMDAwIDAw
MDAwMDIwIDg1NDI5ZDkwClsgICAgMi4xMDY0MTNdIENhbGwgVHJhY2U6ClsgICAgMi4xMDY3
MTNdICBbPDc5ODRhYzdkPl0gZHVtcF9zdGFjaysweDE2LzB4MTgKWyAgICAyLjEwNzIyMV0g
IFs8NzkwNmMzMmU+XSB3YXJuX3Nsb3dwYXRoX2NvbW1vbisweDQ4LzB4NWYKWyAgICAyLjEw
Nzc5OV0gIFs8NzkwODMwODM+XSA/IF9fcXVldWVfZGVsYXllZF93b3JrKzB4ODEvMHgyNDcK
WyAgICAyLjEwODQwOF0gIFs8NzkwNmMzZDY+XSB3YXJuX3Nsb3dwYXRoX251bGwrMHgxNC8w
eDE4ClsgICAgMi4xMDg5NzNdICBbPDc5MDgzMDgzPl0gX19xdWV1ZV9kZWxheWVkX3dvcmsr
MHg4MS8weDI0NwpbICAgIDIuMTA5NTU0XSAgWzw3OTA4NDIwYz5dIHF1ZXVlX2RlbGF5ZWRf
d29ya19vbisweDQyLzB4NTkKWyAgICAyLjExMDE2M10gIFs8NzkyZDVkNDI+XSBzY2hlZHVs
ZV9kZWxheWVkX3dvcmsrMHgxNi8weDE4ClsgICAgMi4xMTA0MDVdICBbPDc5MmQ3MDIxPl0g
ZHJtX2hlbHBlcl9wcm9iZV9zaW5nbGVfY29ubmVjdG9yX21vZGVzKzB4ZjUvMHgyYmUKWyAg
ICAyLjExMDQwNV0gIFs8NzkyZDQxMTc+XSBkcm1fZmJfaGVscGVyX3Byb2JlX2Nvbm5lY3Rv
cl9tb2RlcysweDNhLzB4NGUKWyAgICAyLjExMDQwNV0gIFs8NzkyZDU4ZDI+XSBkcm1fZmJf
aGVscGVyX2luaXRpYWxfY29uZmlnKzB4MTRkLzB4M2FlClsgICAgMi4xMTA0MDVdICBbPDc5
MTBmNDM5Pl0gPyBfX2ttYWxsb2Nfbm9kZSsweDZhLzB4ZDYKWyAgICAyLjExMDQwNV0gIFs8
NzkyZDVmMzc+XSA/IGRybV9oZWxwZXJfZGlzYWJsZV91bnVzZWRfZnVuY3Rpb25zKzB4YzMv
MHhkYwpbICAgIDIuMTEwNDA1XSAgWzw3OTM0OTBiOD5dIGNpcnJ1c19mYmRldl9pbml0KzB4
N2MvMHg4ZApbICAgIDIuMTEwNDA1XSAgWzw3OTM0OGEzOD5dIGNpcnJ1c19tb2Rlc2V0X2lu
aXQrMHgxNDUvMHgxODYKWyAgICAyLjExMDQwNV0gIFs8NzkzNDdlMWQ+XSBjaXJydXNfZHJp
dmVyX2xvYWQrMHg4OC8weGNlClsgICAgMi4xMTA0MDVdICBbPDc5MmUwOTQ2Pl0gZHJtX2dl
dF9wY2lfZGV2KzB4MTM2LzB4MjE0ClsgICAgMi4xMTA0MDVdICBbPDc5MzQ4YjM5Pl0gY2ly
cnVzX3BjaV9wcm9iZSsweDg1LzB4OTEKWyAgICAyLjExMDQwNV0gIFs8NzkxZmEyZTk+XSBw
Y2lfZGV2aWNlX3Byb2JlKzB4NWMvMHg5NApbICAgIDIuMTEwNDA1XSAgWzw3OTNkZDQ0Yz5d
IGRyaXZlcl9wcm9iZV9kZXZpY2UrMHg5Ny8weDFiMQpbICAgIDIuMTEwNDA1XSAgWzw3OTNk
ZDVlYT5dIF9fZHJpdmVyX2F0dGFjaCsweDUzLzB4NmYKWyAgICAyLjExMDQwNV0gIFs8Nzkz
ZGMwOWE+XSBidXNfZm9yX2VhY2hfZGV2KzB4M2UvMHg2OQpbICAgIDIuMTEwNDA1XSAgWzw3
OTNkZDM2Yz5dIGRyaXZlcl9hdHRhY2grMHgxOS8weDFiClsgICAgMi4xMTA0MDVdICBbPDc5
M2RkNTk3Pl0gPyBfX2RldmljZV9hdHRhY2grMHgzMS8weDMxClsgICAgMi4xMTA0MDVdICBb
PDc5M2RjNmY0Pl0gYnVzX2FkZF9kcml2ZXIrMHhiNC8weDFiZApbICAgIDIuMTEwNDA1XSAg
Wzw3OTNkZGRiOT5dIGRyaXZlcl9yZWdpc3RlcisweDhjLzB4ZTkKWyAgICAyLjExMDQwNV0g
IFs8NzkxZmExMWM+XSBfX3BjaV9yZWdpc3Rlcl9kcml2ZXIrMHg0YS8weDRkClsgICAgMi4x
MTA0MDVdICBbPDc5MmUwYTk1Pl0gZHJtX3BjaV9pbml0KzB4NzEvMHhjOQpbICAgIDIuMTEw
NDA1XSAgWzw3OWRlNGMyNT5dID8gZnRyYWNlX2RlZmluZV9maWVsZHNfaW50ZWxfZ3B1X2Zy
ZXFfY2hhbmdlKzB4MWMvMHgxYwpbICAgIDIuMTEwNDA1XSAgWzw3OWRlNGM0MD5dIGNpcnJ1
c19pbml0KzB4MWIvMHgyNQpbICAgIDIuMTEwNDA1XSAgWzw3OWRiN2EyOD5dIGRvX29uZV9p
bml0Y2FsbCsweDZiLzB4MTE5ClsgICAgMi4xMTA0MDVdICBbPDc5ZGI3YmM3Pl0ga2VybmVs
X2luaXRfZnJlZWFibGUrMHhmMS8weDE3MQpbICAgIDIuMTEwNDA1XSAgWzw3OTgzOTY0ZT5d
IGtlcm5lbF9pbml0KzB4ZC8weGI5ClsgICAgMi4xMTA0MDVdICBbPDc5ODU4Mzc3Pl0gcmV0
X2Zyb21fa2VybmVsX3RocmVhZCsweDFiLzB4MjgKWyAgICAyLjExMDQwNV0gIFs8Nzk4Mzk2
NDE+XSA/IHJlc3RfaW5pdCsweGIxLzB4YjEKWyAgICAyLjExMDQwNV0gLS0tWyBlbmQgdHJh
Y2UgYjFjODhjZjZjZDFlNTkwMCBdLS0tCi9rZXJuZWwvaTM4Ni1yYW5kY29uZmlnLXMwNy0w
NjI4LzFmYjQ4ODNhZDRhZTg4MGQyZWYxMDBmMDA2MjRlYzc2NjAwMTgxODYvZG1lc2cta3Zt
LXZwLTEwNjYwLTIwMTMwNjI5MTMwMTAwLTMuMTAuMC1yYzctMDAxMTAtZzk4YjZlZDAtMTUz
Ci9rZXJuZWwvaTM4Ni1yYW5kY29uZmlnLXMwNy0wNjI4LzFmYjQ4ODNhZDRhZTg4MGQyZWYx
MDBmMDA2MjRlYzc2NjAwMTgxODYvZG1lc2cta3ZtLXZwLTExMjY0LTIwMTMwNjI5MTMwMTAy
LTMuMTAuMC1yYzctMDAxMTAtZzk4YjZlZDAtMTcKL2tlcm5lbC9pMzg2LXJhbmRjb25maWct
czA3LTA2MjgvMWZiNDg4M2FkNGFlODgwZDJlZjEwMGYwMDYyNGVjNzY2MDAxODE4Ni9kbWVz
Zy1rdm0tdnAtMTU4ODMtMjAxMzA2MjkxMzAwNTktMy4xMC4wLXJjNy0wMDMzMi1nMWZiNDg4
My05Ngova2VybmVsL2kzODYtcmFuZGNvbmZpZy1zMDctMDYyOC8xZmI0ODgzYWQ0YWU4ODBk
MmVmMTAwZjAwNjI0ZWM3NjYwMDE4MTg2L2RtZXNnLWt2bS12cC0xOTM2OC0yMDEzMDYyOTEz
MDA1OS0zLjEwLjAtcmM3LTAwMzMyLWcxZmI0ODgzLTk2Ci9rZXJuZWwvaTM4Ni1yYW5kY29u
ZmlnLXMwNy0wNjI4LzFmYjQ4ODNhZDRhZTg4MGQyZWYxMDBmMDA2MjRlYzc2NjAwMTgxODYv
ZG1lc2cta3ZtLXZwLTIyNjMzLTIwMTMwNjI5MTMwMTAzLTMuMTAuMC1yYzctMDAxMTAtZzk4
YjZlZDAtMTcKL2tlcm5lbC9pMzg2LXJhbmRjb25maWctczA3LTA2MjgvMWZiNDg4M2FkNGFl
ODgwZDJlZjEwMGYwMDYyNGVjNzY2MDAxODE4Ni9kbWVzZy1rdm0tdnAtMjQ5NzktMjAxMzA2
MjkxMzAxMDUtLQova2VybmVsL2kzODYtcmFuZGNvbmZpZy1zMDctMDYyOC8xZmI0ODgzYWQ0
YWU4ODBkMmVmMTAwZjAwNjI0ZWM3NjYwMDE4MTg2L2RtZXNnLWt2bS12cC01MjI2LTIwMTMw
NjI5MTMwMTAzLTMuOS4wLXJjMS0wMDA4Mi1nNGMxNmJkMy0xMTkKL2tlcm5lbC9pMzg2LXJh
bmRjb25maWctczA3LTA2MjgvMWZiNDg4M2FkNGFlODgwZDJlZjEwMGYwMDYyNGVjNzY2MDAx
ODE4Ni9kbWVzZy1rdm0tdnAtNTkxMC0yMDEzMDYyOTEzMDEwMi0zLjkuMC1yYzItMDAzMzMt
Z2UyMDQzNzgtMTEwCi9rZXJuZWwvaTM4Ni1yYW5kY29uZmlnLXMwNy0wNjI4LzFmYjQ4ODNh
ZDRhZTg4MGQyZWYxMDBmMDA2MjRlYzc2NjAwMTgxODYvZG1lc2cta3ZtLXZwLTcxODQtMjAx
MzA2MjkxMzAxMDEtLQova2VybmVsL2kzODYtcmFuZGNvbmZpZy1zMDctMDYyOC8xZmI0ODgz
YWQ0YWU4ODBkMmVmMTAwZjAwNjI0ZWM3NjYwMDE4MTg2L2RtZXNnLWt2bS12cC04ODM0LTIw
MTMwNjI5MTMwMDU3LTIuNi4zOC1yYzgtMDAwMzUtZ2I1NTYyYzktMTcxCi9rZXJuZWwvaTM4
Ni1yYW5kY29uZmlnLXMwNy0wNjI4LzFmYjQ4ODNhZDRhZTg4MGQyZWYxMDBmMDA2MjRlYzc2
NjAwMTgxODYvZG1lc2cta3ZtLXZwLTkwMTItMjAxMzA2MjkxMzAxMDAtLQova2VybmVsL2kz
ODYtcmFuZGNvbmZpZy1zMDctMDYyOC8xZmI0ODgzYWQ0YWU4ODBkMmVmMTAwZjAwNjI0ZWM3
NjYwMDE4MTg2L2RtZXNnLWt2bS12cC05NDQ3LTIwMTMwNjI5MTMwMTAzLTMuMTAuMC1yYzct
MQova2VybmVsL2kzODYtcmFuZGNvbmZpZy1zMDctMDYyOC8xZmI0ODgzYWQ0YWU4ODBkMmVm
MTAwZjAwNjI0ZWM3NjYwMDE4MTg2L2RtZXNnLWt2bS13YWltZWEtMjE0MTYtMjAxMzA2Mjkx
MzAyMzItMy4xLjAtcmM5LTAwMDY1LWc1M2EwMTlhLTEwOAova2VybmVsL2kzODYtcmFuZGNv
bmZpZy1zMDctMDYyOC8xZmI0ODgzYWQ0YWU4ODBkMmVmMTAwZjAwNjI0ZWM3NjYwMDE4MTg2
L2RtZXNnLWt2bS13YWltZWEtMzcxNS0yMDEzMDYyOTEzMDIzMy0zLjEuMC1yYzktMDAwNjUt
ZzUzYTAxOWEtMTA4Ci9rZXJuZWwvaTM4Ni1yYW5kY29uZmlnLXMwNy0wNjI4LzFmYjQ4ODNh
ZDRhZTg4MGQyZWYxMDBmMDA2MjRlYzc2NjAwMTgxODYvZG1lc2cta3ZtLXdhaW1lYS00MjI3
LTIwMTMwNjI5MTMwMjM0LTMuOS4wLXJjNS0wMDY1MC1nMDNhYTFiYy0xMzgKL2tlcm5lbC9p
Mzg2LXJhbmRjb25maWctczA3LTA2MjgvMWZiNDg4M2FkNGFlODgwZDJlZjEwMGYwMDYyNGVj
NzY2MDAxODE4Ni9kbWVzZy1rdm0td2FpbWVhLTU0NzMtMjAxMzA2MjkxMzAyMzMtLQova2Vy
bmVsL2kzODYtcmFuZGNvbmZpZy1zMDctMDYyOC8xZmI0ODgzYWQ0YWU4ODBkMmVmMTAwZjAw
NjI0ZWM3NjYwMDE4MTg2L2RtZXNnLWt2bS13YWltZWEtNzAwNC0yMDEzMDYyOTEzMDIzMS0z
LjEwLjAtcmM3LTAwMzMyLWcxZmI0ODgzLTk2Ci9rZXJuZWwvaTM4Ni1yYW5kY29uZmlnLXMw
Ny0wNjI4LzFmYjQ4ODNhZDRhZTg4MGQyZWYxMDBmMDA2MjRlYzc2NjAwMTgxODYvZG1lc2ct
a3ZtLXhibS0xNzkyNi0yMDEzMDYyOTEzMDIyNy0tCi9rZXJuZWwvaTM4Ni1yYW5kY29uZmln
LXMwNy0wNjI4LzFmYjQ4ODNhZDRhZTg4MGQyZWYxMDBmMDA2MjRlYzc2NjAwMTgxODYvZG1l
c2cta3ZtLXhibS0yMjAzNC0yMDEzMDYyOTEzMDIzMC0zLjEwLjAtcmM3LTAwMzQ0LWczOTVi
YTdhLTk0Ci9rZXJuZWwvaTM4Ni1yYW5kY29uZmlnLXMwNy0wNjI4LzFmYjQ4ODNhZDRhZTg4
MGQyZWYxMDBmMDA2MjRlYzc2NjAwMTgxODYvZG1lc2cta3ZtLXhibS03NzgzLTIwMTMwNjI5
MTMwMjI2LTMuMTAuMC1yYzctMDAzMzItZzFmYjQ4ODMtOTYKCkJpc2VjdGluZzogNSByZXZp
c2lvbnMgbGVmdCB0byB0ZXN0IGFmdGVyIHRoaXMgKHJvdWdobHkgMyBzdGVwcykKW2YzY2Yx
MzllZmE0YmMwZmU0ZjAzMmFmNmNhM2U0OWUzOGE1ZDlhZTVdIG11dGV4OiBBZGQgbW9yZSB3
L3cgdGVzdHMgdG8gdGVzdCBFREVBRExLIHBhdGggaGFuZGxpbmcKcnVubmluZyAvYy9rZXJu
ZWwtdGVzdHMvYmlzZWN0LXRlc3QtYm9vdC1mYWlsdXJlLnNoIC9ob21lL3dmZy9uZXQvb2Jq
LWJpc2VjdApscyAtYSAva2VybmVsLXRlc3RzL3J1bi1xdWV1ZS9rdm0vaTM4Ni1yYW5kY29u
ZmlnLXMwNy0wNjI4L2xpbnV4LWRldmVsOmRldmVsLXNuYi1pMzg2LTIwMTMwNjI4MDM1Mjpm
M2NmMTM5ZWZhNGJjMGZlNGYwMzJhZjZjYTNlNDllMzhhNWQ5YWU1OmJpc2VjdC1uZXQKCjIw
MTMtMDYtMjktMTI6NTk6NTkgZjNjZjEzOWVmYTRiYzBmZTRmMDMyYWY2Y2EzZTQ5ZTM4YTVk
OWFlNSBjb21waWxpbmcKMTkwIHJlYWwgIDE2NjAgdXNlciAgMTQ3IHN5cyAgOTQ4LjQxJSBj
cHUgCWkzODYtcmFuZGNvbmZpZy1zMDctMDYyOAoKMjAxMy0wNi0yOS0xMzowMzoyNSBkZXRl
Y3RpbmcgYm9vdCBzdGF0ZSAzLjEwLjAtcmM3LTAwMDMwLWdmM2NmMTM5LgkyMCBTVUNDRVNT
CgpCaXNlY3Rpbmc6IDIgcmV2aXNpb25zIGxlZnQgdG8gdGVzdCBhZnRlciB0aGlzIChyb3Vn
aGx5IDIgc3RlcHMpCls3NmNlZGVkNTE3ODc3MjliZWEyOGFiOGNmOTg2YjIzZmZkOGUzNTMz
XSBNZXJnZSBicmFuY2ggJ2NvcmUvbXV0ZXhlcycgb2YgZ2l0Oi8vZ2l0Lmtlcm5lbC5vcmcv
cHViL3NjbS9saW51eC9rZXJuZWwvZ2l0L3RpcC90aXAgaW50byBkcm0tbmV4dApydW5uaW5n
IC9jL2tlcm5lbC10ZXN0cy9iaXNlY3QtdGVzdC1ib290LWZhaWx1cmUuc2ggL2hvbWUvd2Zn
L25ldC9vYmotYmlzZWN0CmxzIC1hIC9rZXJuZWwtdGVzdHMvcnVuLXF1ZXVlL2t2bS9pMzg2
LXJhbmRjb25maWctczA3LTA2MjgvbGludXgtZGV2ZWw6ZGV2ZWwtc25iLWkzODYtMjAxMzA2
MjgwMzUyOjc2Y2VkZWQ1MTc4NzcyOWJlYTI4YWI4Y2Y5ODZiMjNmZmQ4ZTM1MzM6YmlzZWN0
LW5ldAoKMjAxMy0wNi0yOS0xMzowNDoyNyA3NmNlZGVkNTE3ODc3MjliZWEyOGFiOGNmOTg2
YjIzZmZkOGUzNTMzIGNvbXBpbGluZwoxOTAgcmVhbCAgMTY2MSB1c2VyICAxNDYgc3lzICA5
NTAuODMlIGNwdSAJaTM4Ni1yYW5kY29uZmlnLXMwNy0wNjI4CgoyMDEzLTA2LTI5LTEzOjA3
OjU1IGRldGVjdGluZyBib290IHN0YXRlIDMuMTAuMC1yYzctMDAzMjAtZzc2Y2VkZWQuCTIw
IFNVQ0NFU1MKCkJpc2VjdGluZzogMCByZXZpc2lvbnMgbGVmdCB0byB0ZXN0IGFmdGVyIHRo
aXMgKHJvdWdobHkgMSBzdGVwKQpbMzgzOWU3ZjFjZjA2M2Q5YmFlOTQwNmU4ZDlhMGM2NDY0
NWVhMjFiMl0gTWVyZ2UgYnJhbmNoICdmb3ItYWlybGllZC1uZXh0JyBpbnRvIGZvci1haXJs
aWVkCnJ1bm5pbmcgL2Mva2VybmVsLXRlc3RzL2Jpc2VjdC10ZXN0LWJvb3QtZmFpbHVyZS5z
aCAvaG9tZS93ZmcvbmV0L29iai1iaXNlY3QKbHMgLWEgL2tlcm5lbC10ZXN0cy9ydW4tcXVl
dWUva3ZtL2kzODYtcmFuZGNvbmZpZy1zMDctMDYyOC9saW51eC1kZXZlbDpkZXZlbC1zbmIt
aTM4Ni0yMDEzMDYyODAzNTI6MzgzOWU3ZjFjZjA2M2Q5YmFlOTQwNmU4ZDlhMGM2NDY0NWVh
MjFiMjpiaXNlY3QtbmV0CgoyMDEzLTA2LTI5LTEzOjA4OjU4IDM4MzllN2YxY2YwNjNkOWJh
ZTk0MDZlOGQ5YTBjNjQ2NDVlYTIxYjIgY29tcGlsaW5nCjE4MCByZWFsICAxNjY3IHVzZXIg
IDE0NSBzeXMgIDEwMDUuOTYlIGNwdSAJaTM4Ni1yYW5kY29uZmlnLXMwNy0wNjI4CgoyMDEz
LTA2LTI5LTEzOjEyOjExIGRldGVjdGluZyBib290IHN0YXRlIDMuMTAuMC1yYzctMDAzMzEt
ZzM4MzllN2YuLiBURVNUIEZBSUxVUkUKWyAgICAyLjExNzc1MV0gW1RUTV0gSW5pdGlhbGl6
aW5nIHBvb2wgYWxsb2NhdG9yClsgICAgMi4xMTgyOTBdIC0tLS0tLS0tLS0tLVsgY3V0IGhl
cmUgXS0tLS0tLS0tLS0tLQpbICAgIDIuMTE4NzI2XSBXQVJOSU5HOiBhdCAvYy93ZmcvbmV0
L2tlcm5lbC93b3JrcXVldWUuYzoxNDMyIF9fcXVldWVfZGVsYXllZF93b3JrKzB4ODEvMHgy
NDcoKQpbICAgIDIuMTE5NTAzXSBDUFU6IDEgUElEOiAxIENvbW06IHN3YXBwZXIvMCBOb3Qg
dGFpbnRlZCAzLjEwLjAtcmM3LTAwMzMxLWczODM5ZTdmICM5OQpbICAgIDIuMTIwMTY5XSAg
MDAwMDAwMDAgMDAwMDAwMDAgODU0MjlkMjQgNzk4NGFjN2QgODU0MjlkM2MgNzkwNmMzMmUg
NzkwODMwODMgMDAwMDAyMDEKWyAgICAyLjEyMDE2OV0gIDAwMDAwMDAxIDdlYTJiYzE0IDg1
NDI5ZDRjIDc5MDZjM2Q2IDAwMDAwMDA5IDAwMDAwMDAwIDg1NDI5ZDcwIDc5MDgzMDgzClsg
ICAgMi4xMjAxNjldICA4NTQyZTc3MCA3ZWEyYmMzNCAwMDAwMDAyMCAwMDAwMDAwMSAwMDAw
MDI0NiAwMDAwMDAwMCAwMDAwMDAyMCA4NTQyOWQ5MApbICAgIDIuMTIwMTY5XSBDYWxsIFRy
YWNlOgpbICAgIDIuMTIwMTY5XSAgWzw3OTg0YWM3ZD5dIGR1bXBfc3RhY2srMHgxNi8weDE4
ClsgICAgMi4xMjAxNjldICBbPDc5MDZjMzJlPl0gd2Fybl9zbG93cGF0aF9jb21tb24rMHg0
OC8weDVmClsgICAgMi4xMjAxNjldICBbPDc5MDgzMDgzPl0gPyBfX3F1ZXVlX2RlbGF5ZWRf
d29yaysweDgxLzB4MjQ3ClsgICAgMi4xMjAxNjldICBbPDc5MDZjM2Q2Pl0gd2Fybl9zbG93
cGF0aF9udWxsKzB4MTQvMHgxOApbICAgIDIuMTIwMTY5XSAgWzw3OTA4MzA4Mz5dIF9fcXVl
dWVfZGVsYXllZF93b3JrKzB4ODEvMHgyNDcKWyAgICAyLjEyMDE2OV0gIFs8NzkwODQyMGM+
XSBxdWV1ZV9kZWxheWVkX3dvcmtfb24rMHg0Mi8weDU5ClsgICAgMi4xMjAxNjldICBbPDc5
MmQ1ZDQyPl0gc2NoZWR1bGVfZGVsYXllZF93b3JrKzB4MTYvMHgxOApbICAgIDIuMTIwMTY5
XSAgWzw3OTJkNzAyMT5dIGRybV9oZWxwZXJfcHJvYmVfc2luZ2xlX2Nvbm5lY3Rvcl9tb2Rl
cysweGY1LzB4MmJlClsgICAgMi4xMjAxNjldICBbPDc5MmQ0MTE3Pl0gZHJtX2ZiX2hlbHBl
cl9wcm9iZV9jb25uZWN0b3JfbW9kZXMrMHgzYS8weDRlClsgICAgMi4xMjAxNjldICBbPDc5
MmQ1OGQyPl0gZHJtX2ZiX2hlbHBlcl9pbml0aWFsX2NvbmZpZysweDE0ZC8weDNhZQpbICAg
IDIuMTIwMTY5XSAgWzw3OTEwZjQzOT5dID8gX19rbWFsbG9jX25vZGUrMHg2YS8weGQ2Clsg
ICAgMi4xMjAxNjldICBbPDc5MmQ1ZjM3Pl0gPyBkcm1faGVscGVyX2Rpc2FibGVfdW51c2Vk
X2Z1bmN0aW9ucysweGMzLzB4ZGMKWyAgICAyLjEyMDE2OV0gIFs8NzkzNDkwYjg+XSBjaXJy
dXNfZmJkZXZfaW5pdCsweDdjLzB4OGQKWyAgICAyLjEyMDE2OV0gIFs8NzkzNDhhMzg+XSBj
aXJydXNfbW9kZXNldF9pbml0KzB4MTQ1LzB4MTg2ClsgICAgMi4xMjAxNjldICBbPDc5MzQ3
ZTFkPl0gY2lycnVzX2RyaXZlcl9sb2FkKzB4ODgvMHhjZQpbICAgIDIuMTIwMTY5XSAgWzw3
OTJlMDk0Nj5dIGRybV9nZXRfcGNpX2RldisweDEzNi8weDIxNApbICAgIDIuMTIwMTY5XSAg
Wzw3OTM0OGIzOT5dIGNpcnJ1c19wY2lfcHJvYmUrMHg4NS8weDkxClsgICAgMi4xMjAxNjld
ICBbPDc5MWZhMmU5Pl0gcGNpX2RldmljZV9wcm9iZSsweDVjLzB4OTQKWyAgICAyLjEyMDE2
OV0gIFs8NzkzZGQ0NGM+XSBkcml2ZXJfcHJvYmVfZGV2aWNlKzB4OTcvMHgxYjEKWyAgICAy
LjEyMDE2OV0gIFs8NzkzZGQ1ZWE+XSBfX2RyaXZlcl9hdHRhY2grMHg1My8weDZmClsgICAg
Mi4xMjAxNjldICBbPDc5M2RjMDlhPl0gYnVzX2Zvcl9lYWNoX2RldisweDNlLzB4NjkKWyAg
ICAyLjEyMDE2OV0gIFs8NzkzZGQzNmM+XSBkcml2ZXJfYXR0YWNoKzB4MTkvMHgxYgpbICAg
IDIuMTIwMTY5XSAgWzw3OTNkZDU5Nz5dID8gX19kZXZpY2VfYXR0YWNoKzB4MzEvMHgzMQpb
ICAgIDIuMTIwMTY5XSAgWzw3OTNkYzZmND5dIGJ1c19hZGRfZHJpdmVyKzB4YjQvMHgxYmQK
WyAgICAyLjEyMDE2OV0gIFs8NzkzZGRkYjk+XSBkcml2ZXJfcmVnaXN0ZXIrMHg4Yy8weGU5
ClsgICAgMi4xMjAxNjldICBbPDc5MWZhMTFjPl0gX19wY2lfcmVnaXN0ZXJfZHJpdmVyKzB4
NGEvMHg0ZApbICAgIDIuMTIwMTY5XSAgWzw3OTJlMGE5NT5dIGRybV9wY2lfaW5pdCsweDcx
LzB4YzkKWyAgICAyLjEyMDE2OV0gIFs8NzlkZTRjMjU+XSA/IGZ0cmFjZV9kZWZpbmVfZmll
bGRzX2ludGVsX2dwdV9mcmVxX2NoYW5nZSsweDFjLzB4MWMKWyAgICAyLjEyMDE2OV0gIFs8
NzlkZTRjNDA+XSBjaXJydXNfaW5pdCsweDFiLzB4MjUKWyAgICAyLjEyMDE2OV0gIFs8Nzlk
YjdhMjg+XSBkb19vbmVfaW5pdGNhbGwrMHg2Yi8weDExOQpbICAgIDIuMTIwMTY5XSAgWzw3
OWRiN2JjNz5dIGtlcm5lbF9pbml0X2ZyZWVhYmxlKzB4ZjEvMHgxNzEKWyAgICAyLjEyMDE2
OV0gIFs8Nzk4Mzk2NGU+XSBrZXJuZWxfaW5pdCsweGQvMHhiOQpbICAgIDIuMTIwMTY5XSAg
Wzw3OTg1ODM3Nz5dIHJldF9mcm9tX2tlcm5lbF90aHJlYWQrMHgxYi8weDI4ClsgICAgMi4x
MjAxNjldICBbPDc5ODM5NjQxPl0gPyByZXN0X2luaXQrMHhiMS8weGIxClsgICAgMi4xMjAx
NjldIC0tLVsgZW5kIHRyYWNlIGIwN2RiODU4NjdkZjAxZDQgXS0tLQova2VybmVsL2kzODYt
cmFuZGNvbmZpZy1zMDctMDYyOC8zODM5ZTdmMWNmMDYzZDliYWU5NDA2ZThkOWEwYzY0NjQ1
ZWEyMWIyL2RtZXNnLWt2bS1pbm4tMzQ3ODEtMjAxMzA2MjkxMzE1NDctMy4xMC4wLXJjNy0w
MDMzMS1nMzgzOWU3Zi05OQova2VybmVsL2kzODYtcmFuZGNvbmZpZy1zMDctMDYyOC8zODM5
ZTdmMWNmMDYzZDliYWU5NDA2ZThkOWEwYzY0NjQ1ZWEyMWIyL2RtZXNnLWt2bS12cC00ODg2
LTIwMTMwNjI5MTMxNDIwLTMuMTAuMC1yYzctMDAxMTAtZzk4YjZlZDAtMTcKL2tlcm5lbC9p
Mzg2LXJhbmRjb25maWctczA3LTA2MjgvMzgzOWU3ZjFjZjA2M2Q5YmFlOTQwNmU4ZDlhMGM2
NDY0NWVhMjFiMi9kbWVzZy1rdm0tdnAtNzM3OC0yMDEzMDYyOTEzMTQyMC0tCi9rZXJuZWwv
aTM4Ni1yYW5kY29uZmlnLXMwNy0wNjI4LzM4MzllN2YxY2YwNjNkOWJhZTk0MDZlOGQ5YTBj
NjQ2NDVlYTIxYjIvZG1lc2cta3ZtLXdhaW1lYS0xNDgzMC0yMDEzMDYyOTEzMTU0NS0zLjEw
LjAtcmM3LTAwMzMxLWczODM5ZTdmLTk5Ci9rZXJuZWwvaTM4Ni1yYW5kY29uZmlnLXMwNy0w
NjI4LzM4MzllN2YxY2YwNjNkOWJhZTk0MDZlOGQ5YTBjNjQ2NDVlYTIxYjIvZG1lc2cta3Zt
LXdhaW1lYS0yMTM3Ny0yMDEzMDYyOTEzMTU1MS0zLjEuMC1yYzktMDAwNjUtZzUzYTAxOWEt
MTA4Ci9rZXJuZWwvaTM4Ni1yYW5kY29uZmlnLXMwNy0wNjI4LzM4MzllN2YxY2YwNjNkOWJh
ZTk0MDZlOGQ5YTBjNjQ2NDVlYTIxYjIvZG1lc2cta3ZtLXdhaW1lYS0zNjAyLTIwMTMwNjI5
MTMxNTU0LTMuMS4wLXJjOS0wMDA2NS1nNTNhMDE5YS0xMDgKL2tlcm5lbC9pMzg2LXJhbmRj
b25maWctczA3LTA2MjgvMzgzOWU3ZjFjZjA2M2Q5YmFlOTQwNmU4ZDlhMGM2NDY0NWVhMjFi
Mi9kbWVzZy1rdm0td2FpbWVhLTQ5OTEtMjAxMzA2MjkxMzE1NTEtLQova2VybmVsL2kzODYt
cmFuZGNvbmZpZy1zMDctMDYyOC8zODM5ZTdmMWNmMDYzZDliYWU5NDA2ZThkOWEwYzY0NjQ1
ZWEyMWIyL2RtZXNnLWt2bS13YWltZWEtNTEyMy0yMDEzMDYyOTEzMTU0Ny0zLjEuMC1yYzkt
MDAwNjUtZzUzYTAxOWEtMTA4Ci9rZXJuZWwvaTM4Ni1yYW5kY29uZmlnLXMwNy0wNjI4LzM4
MzllN2YxY2YwNjNkOWJhZTk0MDZlOGQ5YTBjNjQ2NDVlYTIxYjIvZG1lc2cta3ZtLXhibS05
OTA4LTIwMTMwNjI5MTMxNTQ2LTMuMTAuMC1yYzctMDAzMzEtZzM4MzllN2YtOTkKL2tlcm5l
bC9pMzg2LXJhbmRjb25maWctczA3LTA2MjgvMzgzOWU3ZjFjZjA2M2Q5YmFlOTQwNmU4ZDlh
MGM2NDY0NWVhMjFiMi9kbWVzZy1rdm0tdnAtMTUwMDgtMjAxMzA2MjkxMzE0MjUtLQova2Vy
bmVsL2kzODYtcmFuZGNvbmZpZy1zMDctMDYyOC8zODM5ZTdmMWNmMDYzZDliYWU5NDA2ZThk
OWEwYzY0NjQ1ZWEyMWIyL2RtZXNnLWt2bS12cC0xNTM0NS0yMDEzMDYyOTEzMTQzMS0zLjku
MC1yYzUtMDA2NTAtZzAzYWExYmMtMTc4Ci9rZXJuZWwvaTM4Ni1yYW5kY29uZmlnLXMwNy0w
NjI4LzM4MzllN2YxY2YwNjNkOWJhZTk0MDZlOGQ5YTBjNjQ2NDVlYTIxYjIvZG1lc2cta3Zt
LXZwLTIyNDIxLTIwMTMwNjI5MTMxNDI0LTMuMTAuMC1yYzctMDAzMzEtZzM4MzllN2YtOTkK
L2tlcm5lbC9pMzg2LXJhbmRjb25maWctczA3LTA2MjgvMzgzOWU3ZjFjZjA2M2Q5YmFlOTQw
NmU4ZDlhMGM2NDY0NWVhMjFiMi9kbWVzZy1rdm0tdnAtMjU3MjUtMjAxMzA2MjkxMzE0MjYt
LQova2VybmVsL2kzODYtcmFuZGNvbmZpZy1zMDctMDYyOC8zODM5ZTdmMWNmMDYzZDliYWU5
NDA2ZThkOWEwYzY0NjQ1ZWEyMWIyL2RtZXNnLWt2bS12cC00OTk2LTIwMTMwNjI5MTMxNDI3
LTMuMTAuMC1yYzctMDAyNDMtZzRlYjI0NDktNzQKL2tlcm5lbC9pMzg2LXJhbmRjb25maWct
czA3LTA2MjgvMzgzOWU3ZjFjZjA2M2Q5YmFlOTQwNmU4ZDlhMGM2NDY0NWVhMjFiMi9kbWVz
Zy1rdm0td2FpbWVhLTIxMzc4LTIwMTMwNjI5MTMxNTU5LTMuMTAuMC1yYzctMDAxMTAtZzk4
YjZlZDAtMTcKL2tlcm5lbC9pMzg2LXJhbmRjb25maWctczA3LTA2MjgvMzgzOWU3ZjFjZjA2
M2Q5YmFlOTQwNmU4ZDlhMGM2NDY0NWVhMjFiMi9kbWVzZy1rdm0td2FpbWVhLTg3NjgtMjAx
MzA2MjkxMzE1NTYtMy4xMC4wLXJjNy0wMDM5MS1nN2RhNWVhZC02Ci9rZXJuZWwvaTM4Ni1y
YW5kY29uZmlnLXMwNy0wNjI4LzM4MzllN2YxY2YwNjNkOWJhZTk0MDZlOGQ5YTBjNjQ2NDVl
YTIxYjIvZG1lc2cta3ZtLXhibS0xNzkyNi0yMDEzMDYyOTEzMTU1NC0tCi9rZXJuZWwvaTM4
Ni1yYW5kY29uZmlnLXMwNy0wNjI4LzM4MzllN2YxY2YwNjNkOWJhZTk0MDZlOGQ5YTBjNjQ2
NDVlYTIxYjIvZG1lc2cta3ZtLXhibS0xOTc5LTIwMTMwNjI5MTMxNTUyLTMuMS4wLXJjOS0w
MDA2NS1nNTNhMDE5YS0xMDgKL2tlcm5lbC9pMzg2LXJhbmRjb25maWctczA3LTA2MjgvMzgz
OWU3ZjFjZjA2M2Q5YmFlOTQwNmU4ZDlhMGM2NDY0NWVhMjFiMi9kbWVzZy1rdm0teGJtLTI5
NjE3LTIwMTMwNjI5MTMxNTU0LS0KCkJpc2VjdGluZzogMCByZXZpc2lvbnMgbGVmdCB0byB0
ZXN0IGFmdGVyIHRoaXMgKHJvdWdobHkgMCBzdGVwcykKW2JlMzc4MzU2MTlmY2UyMmQzZjQ2
YzVhNTkxYmJmMGJiY2IyMjg4ZTRdIGRybToga21zX2hlbHBlcjogZG9uJ3QgbG9zZSBob3Rw
bHVnIGV2ZW50CnJ1bm5pbmcgL2Mva2VybmVsLXRlc3RzL2Jpc2VjdC10ZXN0LWJvb3QtZmFp
bHVyZS5zaCAvaG9tZS93ZmcvbmV0L29iai1iaXNlY3QKbHMgLWEgL2tlcm5lbC10ZXN0cy9y
dW4tcXVldWUva3ZtL2kzODYtcmFuZGNvbmZpZy1zMDctMDYyOC9saW51eC1kZXZlbDpkZXZl
bC1zbmItaTM4Ni0yMDEzMDYyODAzNTI6YmUzNzgzNTYxOWZjZTIyZDNmNDZjNWE1OTFiYmYw
YmJjYjIyODhlNDpiaXNlY3QtbmV0CgoyMDEzLTA2LTI5LTEzOjEzOjE2IGJlMzc4MzU2MTlm
Y2UyMmQzZjQ2YzVhNTkxYmJmMGJiY2IyMjg4ZTQgY29tcGlsaW5nCjE4NCByZWFsICAxNjUx
IHVzZXIgIDE0NiBzeXMgIDk3My45MiUgY3B1IAlpMzg2LXJhbmRjb25maWctczA3LTA2MjgK
CjIwMTMtMDYtMjktMTM6MTY6MzcgZGV0ZWN0aW5nIGJvb3Qgc3RhdGUgMy4xMC4wLXJjNy0w
MDMyMS1nYmUzNzgzNS4uIFRFU1QgRkFJTFVSRQpbICAgIDIuNDYwMjM5XSBbVFRNXSBJbml0
aWFsaXppbmcgcG9vbCBhbGxvY2F0b3IKWyAgICAyLjQ2MTIxMF0gLS0tLS0tLS0tLS0tWyBj
dXQgaGVyZSBdLS0tLS0tLS0tLS0tClsgICAgMi40NjIwNDBdIFdBUk5JTkc6IGF0IC9jL3dm
Zy9uZXQva2VybmVsL3dvcmtxdWV1ZS5jOjE0MzIgX19xdWV1ZV9kZWxheWVkX3dvcmsrMHg4
MS8weDI0NygpClsgICAgMi40NjM0NzldIENQVTogMCBQSUQ6IDEgQ29tbTogc3dhcHBlci8w
IE5vdCB0YWludGVkIDMuMTAuMC1yYzctMDAzMjEtZ2JlMzc4MzUgIzEwMApbICAgIDIuNDY0
ODAzXSAgMDAwMDAwMDAgMDAwMDAwMDAgODU0MjlkMjQgNzk4NGFiOGQgODU0MjlkM2MgNzkw
NmMzMmUgNzkwODMwODMgMDAwMDAyMDEKWyAgICAyLjQ2NjMwM10gIDAwMDAwMDAxIDdlYTQ3
YzE0IDg1NDI5ZDRjIDc5MDZjM2Q2IDAwMDAwMDA5IDAwMDAwMDAwIDg1NDI5ZDcwIDc5MDgz
MDgzClsgICAgMi40Njc3OTVdICA4NTQyZTc3MCA3ZWE0N2MzNCAwMDAwMDAyMCAwMDAwMDAw
MSAwMDAwMDI0NiAwMDAwMDAwMCAwMDAwMDAyMCA4NTQyOWQ5MApbICAgIDIuNDY5MzAwXSBD
YWxsIFRyYWNlOgpbICAgIDIuNDY5NzUwXSAgWzw3OTg0YWI4ZD5dIGR1bXBfc3RhY2srMHgx
Ni8weDE4ClsgICAgMi40NzAyMThdICBbPDc5MDZjMzJlPl0gd2Fybl9zbG93cGF0aF9jb21t
b24rMHg0OC8weDVmClsgICAgMi40NzAyMThdICBbPDc5MDgzMDgzPl0gPyBfX3F1ZXVlX2Rl
bGF5ZWRfd29yaysweDgxLzB4MjQ3ClsgICAgMi40NzAyMThdICBbPDc5MDZjM2Q2Pl0gd2Fy
bl9zbG93cGF0aF9udWxsKzB4MTQvMHgxOApbICAgIDIuNDcwMjE4XSAgWzw3OTA4MzA4Mz5d
IF9fcXVldWVfZGVsYXllZF93b3JrKzB4ODEvMHgyNDcKWyAgICAyLjQ3MDIxOF0gIFs8Nzkw
ODQyMGM+XSBxdWV1ZV9kZWxheWVkX3dvcmtfb24rMHg0Mi8weDU5ClsgICAgMi40NzAyMThd
ICBbPDc5MmQ1ZDQyPl0gc2NoZWR1bGVfZGVsYXllZF93b3JrKzB4MTYvMHgxOApbICAgIDIu
NDcwMjE4XSAgWzw3OTJkNzAyMT5dIGRybV9oZWxwZXJfcHJvYmVfc2luZ2xlX2Nvbm5lY3Rv
cl9tb2RlcysweGY1LzB4MmJlClsgICAgMi40NzAyMThdICBbPDc5MmQ0MTE3Pl0gZHJtX2Zi
X2hlbHBlcl9wcm9iZV9jb25uZWN0b3JfbW9kZXMrMHgzYS8weDRlClsgICAgMi40NzAyMThd
ICBbPDc5MmQ1OGQyPl0gZHJtX2ZiX2hlbHBlcl9pbml0aWFsX2NvbmZpZysweDE0ZC8weDNh
ZQpbICAgIDIuNDcwMjE4XSAgWzw3OTEwZjQzOT5dID8gX19rbWFsbG9jX25vZGUrMHg2YS8w
eGQ2ClsgICAgMi40NzAyMThdICBbPDc5MmQ1ZjM3Pl0gPyBkcm1faGVscGVyX2Rpc2FibGVf
dW51c2VkX2Z1bmN0aW9ucysweGMzLzB4ZGMKWyAgICAyLjQ3MDIxOF0gIFs8NzkzNDkwOWU+
XSBjaXJydXNfZmJkZXZfaW5pdCsweDdjLzB4OGQKWyAgICAyLjQ3MDIxOF0gIFs8NzkzNDhh
Mzg+XSBjaXJydXNfbW9kZXNldF9pbml0KzB4MTQ1LzB4MTg2ClsgICAgMi40NzAyMThdICBb
PDc5MzQ3ZTFkPl0gY2lycnVzX2RyaXZlcl9sb2FkKzB4ODgvMHhjZQpbICAgIDIuNDcwMjE4
XSAgWzw3OTJlMDk0Nj5dIGRybV9nZXRfcGNpX2RldisweDEzNi8weDIxNApbICAgIDIuNDcw
MjE4XSAgWzw3OTM0OGIzOT5dIGNpcnJ1c19wY2lfcHJvYmUrMHg4NS8weDkxClsgICAgMi40
NzAyMThdICBbPDc5MWZhMmU5Pl0gcGNpX2RldmljZV9wcm9iZSsweDVjLzB4OTQKWyAgICAy
LjQ3MDIxOF0gIFs8NzkzZGQzNWQ+XSBkcml2ZXJfcHJvYmVfZGV2aWNlKzB4OTcvMHgxYjEK
WyAgICAyLjQ3MDIxOF0gIFs8NzkzZGQ0ZmI+XSBfX2RyaXZlcl9hdHRhY2grMHg1My8weDZm
ClsgICAgMi40NzAyMThdICBbPDc5M2RiZmFiPl0gYnVzX2Zvcl9lYWNoX2RldisweDNlLzB4
NjkKWyAgICAyLjQ3MDIxOF0gIFs8NzkzZGQyN2Q+XSBkcml2ZXJfYXR0YWNoKzB4MTkvMHgx
YgpbICAgIDIuNDcwMjE4XSAgWzw3OTNkZDRhOD5dID8gX19kZXZpY2VfYXR0YWNoKzB4MzEv
MHgzMQpbICAgIDIuNDcwMjE4XSAgWzw3OTNkYzYwNT5dIGJ1c19hZGRfZHJpdmVyKzB4YjQv
MHgxYmQKWyAgICAyLjQ3MDIxOF0gIFs8NzkzZGRjY2E+XSBkcml2ZXJfcmVnaXN0ZXIrMHg4
Yy8weGU5ClsgICAgMi40NzAyMThdICBbPDc5MWZhMTFjPl0gX19wY2lfcmVnaXN0ZXJfZHJp
dmVyKzB4NGEvMHg0ZApbICAgIDIuNDcwMjE4XSAgWzw3OTJlMGE5NT5dIGRybV9wY2lfaW5p
dCsweDcxLzB4YzkKWyAgICAyLjQ3MDIxOF0gIFs8NzlkZTRjMjU+XSA/IGZ0cmFjZV9kZWZp
bmVfZmllbGRzX2ludGVsX2dwdV9mcmVxX2NoYW5nZSsweDFjLzB4MWMKWyAgICAyLjQ3MDIx
OF0gIFs8NzlkZTRjNDA+XSBjaXJydXNfaW5pdCsweDFiLzB4MjUKWyAgICAyLjQ3MDIxOF0g
IFs8NzlkYjdhMjg+XSBkb19vbmVfaW5pdGNhbGwrMHg2Yi8weDExOQpbICAgIDIuNDcwMjE4
XSAgWzw3OWRiN2JjNz5dIGtlcm5lbF9pbml0X2ZyZWVhYmxlKzB4ZjEvMHgxNzEKWyAgICAy
LjQ3MDIxOF0gIFs8Nzk4Mzk1NWU+XSBrZXJuZWxfaW5pdCsweGQvMHhiOQpbICAgIDIuNDcw
MjE4XSAgWzw3OTg1ODJmNz5dIHJldF9mcm9tX2tlcm5lbF90aHJlYWQrMHgxYi8weDI4Clsg
ICAgMi40NzAyMThdICBbPDc5ODM5NTUxPl0gPyByZXN0X2luaXQrMHhiMS8weGIxClsgICAg
Mi40NzAyMThdIC0tLVsgZW5kIHRyYWNlIGI2N2MwYzc1OTA0Y2I0ZDIgXS0tLQova2VybmVs
L2kzODYtcmFuZGNvbmZpZy1zMDctMDYyOC9iZTM3ODM1NjE5ZmNlMjJkM2Y0NmM1YTU5MWJi
ZjBiYmNiMjI4OGU0L2RtZXNnLWt2bS1pbm4tMjMyMTctMjAxMzA2MjkxMzIwMDMtMy4xMC4w
LXJjNy0wMDMyMS1nYmUzNzgzNS0xMDAKL2tlcm5lbC9pMzg2LXJhbmRjb25maWctczA3LTA2
MjgvYmUzNzgzNTYxOWZjZTIyZDNmNDZjNWE1OTFiYmYwYmJjYjIyODhlNC9kbWVzZy1rdm0t
dnAtMTc1MDktMjAxMzA2MjkxMzE4MzctLQova2VybmVsL2kzODYtcmFuZGNvbmZpZy1zMDct
MDYyOC9iZTM3ODM1NjE5ZmNlMjJkM2Y0NmM1YTU5MWJiZjBiYmNiMjI4OGU0L2RtZXNnLWt2
bS14aWFuLTIzODA3LTIwMTMwNjI5MTMyMDA0LTMuMTAuMC1yYzctMDAzMjEtZ2JlMzc4MzUt
MTAwCi9rZXJuZWwvaTM4Ni1yYW5kY29uZmlnLXMwNy0wNjI4L2JlMzc4MzU2MTlmY2UyMmQz
ZjQ2YzVhNTkxYmJmMGJiY2IyMjg4ZTQvZG1lc2cta3ZtLWF0aGVucy00MzAyOC0yMDEzMDYy
OTEzMjAwNy0zLjEwLjAtcmM3LTAwMzIxLWdiZTM3ODM1LTEwMAova2VybmVsL2kzODYtcmFu
ZGNvbmZpZy1zMDctMDYyOC9iZTM3ODM1NjE5ZmNlMjJkM2Y0NmM1YTU5MWJiZjBiYmNiMjI4
OGU0L2RtZXNnLWt2bS1jYWlyby0zMDIwNy0yMDEzMDYyOTEzMjAxNS0zLjEwLjAtcmM3LTAw
MzIxLWdiZTM3ODM1LTEwMAova2VybmVsL2kzODYtcmFuZGNvbmZpZy1zMDctMDYyOC9iZTM3
ODM1NjE5ZmNlMjJkM2Y0NmM1YTU5MWJiZjBiYmNiMjI4OGU0L2RtZXNnLWt2bS1zbmItMTAy
ODQtMjAxMzA2MjkxMzIxMDMtLQova2VybmVsL2kzODYtcmFuZGNvbmZpZy1zMDctMDYyOC9i
ZTM3ODM1NjE5ZmNlMjJkM2Y0NmM1YTU5MWJiZjBiYmNiMjI4OGU0L2RtZXNnLWt2bS1zbmIt
MTU4NzItMjAxMzA2MjkxMzIxMDMtLQova2VybmVsL2kzODYtcmFuZGNvbmZpZy1zMDctMDYy
OC9iZTM3ODM1NjE5ZmNlMjJkM2Y0NmM1YTU5MWJiZjBiYmNiMjI4OGU0L2RtZXNnLWt2bS1z
bmItMjU2NDMtMjAxMzA2MjkxMzIxMDAtMy4xMC4wLXJjNy0wMDMyMS1nYmUzNzgzNS0xMDAK
L2tlcm5lbC9pMzg2LXJhbmRjb25maWctczA3LTA2MjgvYmUzNzgzNTYxOWZjZTIyZDNmNDZj
NWE1OTFiYmYwYmJjYjIyODhlNC9kbWVzZy1rdm0tc25iLTMzMzk3LTIwMTMwNjI5MTMyMTAy
LTMuMTAuMC1yYzctMDAxMTAtZzk4YjZlZDAtMTcKL2tlcm5lbC9pMzg2LXJhbmRjb25maWct
czA3LTA2MjgvYmUzNzgzNTYxOWZjZTIyZDNmNDZjNWE1OTFiYmYwYmJjYjIyODhlNC9kbWVz
Zy1rdm0tc25iLTYxNjItMjAxMzA2MjkxMzIxMDEtLQova2VybmVsL2kzODYtcmFuZGNvbmZp
Zy1zMDctMDYyOC9iZTM3ODM1NjE5ZmNlMjJkM2Y0NmM1YTU5MWJiZjBiYmNiMjI4OGU0L2Rt
ZXNnLWt2bS12cC0yMjQyMS0yMDEzMDYyOTEzMTg0MS0zLjEwLjAtcmM3LTAwMzMxLWczODM5
ZTdmLTk5Ci9rZXJuZWwvaTM4Ni1yYW5kY29uZmlnLXMwNy0wNjI4L2JlMzc4MzU2MTlmY2Uy
MmQzZjQ2YzVhNTkxYmJmMGJiY2IyMjg4ZTQvZG1lc2cta3ZtLXZwLTIzODExLTIwMTMwNjI5
MTMxODQ2LTMuMTAuMC1yYzctMDAyNDMtZzRlYjI0NDktNzQKL2tlcm5lbC9pMzg2LXJhbmRj
b25maWctczA3LTA2MjgvYmUzNzgzNTYxOWZjZTIyZDNmNDZjNWE1OTFiYmYwYmJjYjIyODhl
NC9kbWVzZy1rdm0tdnAtMjU0ODAtMjAxMzA2MjkxMzE4NDEtLQova2VybmVsL2kzODYtcmFu
ZGNvbmZpZy1zMDctMDYyOC9iZTM3ODM1NjE5ZmNlMjJkM2Y0NmM1YTU5MWJiZjBiYmNiMjI4
OGU0L2RtZXNnLWt2bS12cC03OTk5LTIwMTMwNjI5MTMxODQwLTMuMTAuMC1yYzctMDAzMjEt
Z2JlMzc4MzUtMTAwCi9rZXJuZWwvaTM4Ni1yYW5kY29uZmlnLXMwNy0wNjI4L2JlMzc4MzU2
MTlmY2UyMmQzZjQ2YzVhNTkxYmJmMGJiY2IyMjg4ZTQvZG1lc2cta3ZtLXdhaW1lYS02NjIy
LTIwMTMwNjI5MTMyMDEzLTMuMTAuMC1yYzctMDAzMjEtZ2JlMzc4MzUtMTAwCi9rZXJuZWwv
aTM4Ni1yYW5kY29uZmlnLXMwNy0wNjI4L2JlMzc4MzU2MTlmY2UyMmQzZjQ2YzVhNTkxYmJm
MGJiY2IyMjg4ZTQvZG1lc2cta3ZtLXhibS04NTczLTIwMTMwNjI5MTMyMDA5LTMuMTAuMC1y
YzctMDAzMjEtZ2JlMzc4MzUtMTAwCi9rZXJuZWwvaTM4Ni1yYW5kY29uZmlnLXMwNy0wNjI4
L2JlMzc4MzU2MTlmY2UyMmQzZjQ2YzVhNTkxYmJmMGJiY2IyMjg4ZTQvZG1lc2cta3ZtLXhp
YW4tMTA2MTAtMjAxMzA2MjkxMzIwMTUtLQova2VybmVsL2kzODYtcmFuZGNvbmZpZy1zMDct
MDYyOC9iZTM3ODM1NjE5ZmNlMjJkM2Y0NmM1YTU5MWJiZjBiYmNiMjI4OGU0L2RtZXNnLWt2
bS14aWFuLTE0MTQzLTIwMTMwNjI5MTMyMDEwLS0KCmJlMzc4MzU2MTlmY2UyMmQzZjQ2YzVh
NTkxYmJmMGJiY2IyMjg4ZTQgaXMgdGhlIGZpcnN0IGJhZCBjb21taXQKY29tbWl0IGJlMzc4
MzU2MTlmY2UyMmQzZjQ2YzVhNTkxYmJmMGJiY2IyMjg4ZTQKQXV0aG9yOiBEYW5pZWwgVmV0
dGVyIDxkYW5pZWwudmV0dGVyQGZmd2xsLmNoPgpEYXRlOiAgIFRodSBKdW4gNiAwMDoxNzoy
NSAyMDEzICswMjAwCgogICAgZHJtOiBrbXNfaGVscGVyOiBkb24ndCBsb3NlIGhvdHBsdWcg
ZXZlbnQKICAgIAogICAgVGhlcmUncyBhIHJhY2Ugd2luZG93IChzbWFsbCBmb3IgaHBkLCAx
MHMgbGFyZ2UgZm9yIHBvbGxlZCBvdXRwdXRzKQogICAgd2hlcmUgdXNlcnNwYWNlIGNvdWxk
IHNuZWFrIGluIHdpdGggYW4gdW5yZWxhdGVkIGNvbm5uZWN0b3IgcHJvYmUKICAgIGlvY3Rs
IGNhbGwgYW5kIGVhdCB0aGUgaG90cGx1ZyBldmVudCAoc2luY2UgbmVpdGhlciB0aGUgaHBk
IG5vciB0aGUKICAgIHBvbGwgY29kZSBzZWUgYSBzdGF0ZSBjaGFuZ2UpLgogICAgCiAgICBU
byBhdm9pZCB0aGlzLCBjaGVjayB3aGV0aGVyIHRoZSBjb25uZWN0b3Igc3RhdGUgY2hhbmdl
cyBpbiBhbGwgb3RoZXIKICAgIC0+ZGV0ZWN0IGNhbGxzIChpbiB0aGUgY3VycmVudCBoZWxw
ZXIgY29kZSB0aGF0J3Mgb25seSBwcm9iZV9zaW5nbGUpCiAgICBhbmQgaWYgdGhhdCdzIHRo
ZSBjYXNlLCBmaXJlIG9mZiBhIGhvdHBsdWcgZXZlbnQuIE5vdGUgdGhhdCB3ZSBjYW4ndAog
ICAgZGlyZWN0bHkgY2FsbCB0aGUgaG90cGx1ZyBldmVudCBoYW5kbGVyLCBzaW5jZSB0aGF0
IGV4cGVjdHMgdGhhdCBubwogICAgbG9ja3MgYXJlIGhlbGQgKGR1ZSB0byByZWVudHJhbmN5
IHdpdGggdGhlIGZiIGNvZGUgdG8gdXBkYXRlIHRoZSBrbXMKICAgIGNvbnNvbGUpLgogICAg
CiAgICBBbHNvLCB0aGlzIHJlcXVpcmVzIHRoYXQgZHJpdmVycyB1c2luZyB0aGUgcHJvYmVf
c2luZ2xlIGhlbHBlcgogICAgZnVuY3Rpb24gc2V0IHVwIHRoZSBwb2xsIHdvcmsuIEFsbCBj
dXJyZW50IGRyaXZlcnMgZG8gdGhhdCBhbHJlYWR5LAogICAgYW5kIHdpdGggdGhlIHJld29y
a2VkIGhwZCBoYW5kbGluZyB0aGVyZSdsbCBiZSBubyBkb3duc2lkZSB0bwogICAgdW5jb25k
aXRpb25hbGx5IHNldHRpbmcgdXAgdGhlIHBvbGwgd29yayBhbnkgbW9yZS4KICAgIAogICAg
UmV2aWV3ZWQtYnk6IENocmlzIFdpbHNvbiA8Y2hyaXNAY2hyaXMtd2lsc29uLmNvLnVrPgog
ICAgU2lnbmVkLW9mZi1ieTogRGFuaWVsIFZldHRlciA8ZGFuaWVsLnZldHRlckBmZndsbC5j
aD4KICAgIFNpZ25lZC1vZmYtYnk6IERhdmUgQWlybGllIDxhaXJsaWVkQHJlZGhhdC5jb20+
Cgo6MDQwMDAwIDA0MDAwMCA4ODU5MGViNDViM2VkMjQ0ODBkNzRkOWQ2NDdmMDRjYzU5MzE2
M2I3IGMyZjgyOGIxYjJiOGIzNzllNWIyYmNjZmFiOGY1NTcwYmUxNGVhNTYgTQlkcml2ZXJz
CjowNDAwMDAgMDQwMDAwIGVjNjZjNGQ0NjdmOWQ5ZGFjMWE0MmFiMDBmNjAxZjA4NzgwNjM2
NjAgZTg2NTc2MzIyZjIzZjA5YmIyN2M4NjRlM2M0Nzg2NGI2YjNiYjQzYSBNCWluY2x1ZGUK
YmlzZWN0IHJ1biBzdWNjZXNzCmxzIC1hIC9rZXJuZWwtdGVzdHMvcnVuLXF1ZXVlL2t2bS9p
Mzg2LXJhbmRjb25maWctczA3LTA2MjgvbGludXgtZGV2ZWw6ZGV2ZWwtc25iLWkzODYtMjAx
MzA2MjgwMzUyOjc2Y2VkZWQ1MTc4NzcyOWJlYTI4YWI4Y2Y5ODZiMjNmZmQ4ZTM1MzM6Ymlz
ZWN0LW5ldAoKMjAxMy0wNi0yOS0xMzoxNzo0NCA3NmNlZGVkNTE3ODc3MjliZWEyOGFiOGNm
OTg2YjIzZmZkOGUzNTMzIHJldXNlIC9rZXJuZWwvaTM4Ni1yYW5kY29uZmlnLXMwNy0wNjI4
Lzc2Y2VkZWQ1MTc4NzcyOWJlYTI4YWI4Y2Y5ODZiMjNmZmQ4ZTM1MzMvdm1saW51ei0zLjEw
LjAtcmM3LTAwMzIwLWc3NmNlZGVkCgoyMDEzLTA2LTI5LTEzOjE3OjQ0IGRldGVjdGluZyBi
b290IHN0YXRlIC4JNDIJNTguLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4u
Li4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4u
Li4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4u
Li4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4u
Li4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4u
Li4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uG1sxOzM1
bWFkZF90b19ydW5fcXVldWUgMhtbMG0KLgk2MCBTVUNDRVNTCgpscyAtYSAva2VybmVsLXRl
c3RzL3J1bi1xdWV1ZS9rdm0vaTM4Ni1yYW5kY29uZmlnLXMwNy0wNjI4L2xpbnV4LWRldmVs
OmRldmVsLXNuYi1pMzg2LTIwMTMwNjI4MDM1MjpiNTNlMDM3OTMwMTM0ZDExZmE2MzA3MTYy
YjQxZmIxOWI2YzQzNjQzOmJpc2VjdC1uZXQKIFRFU1QgRkFJTFVSRQpbICAgIDIuNDczOTg2
XSBbVFRNXSBJbml0aWFsaXppbmcgcG9vbCBhbGxvY2F0b3IKWyAgICAyLjQ3NDk0MF0gLS0t
LS0tLS0tLS0tWyBjdXQgaGVyZSBdLS0tLS0tLS0tLS0tClsgICAgMi40NzU3NThdIFdBUk5J
Tkc6IGF0IC9jL2tlcm5lbC10ZXN0cy9zcmMvbGludXgva2VybmVsL3dvcmtxdWV1ZS5jOjE0
MzIgX19xdWV1ZV9kZWxheWVkX3dvcmsrMHg4MS8weDI0NygpClsgICAgMi40NzczOTVdIENQ
VTogMCBQSUQ6IDEgQ29tbTogc3dhcHBlci8wIE5vdCB0YWludGVkIDMuMTAuMC1yYzctd2wt
MDE1OTYtZ2I1M2UwMzcgIzEKWyAgICAyLjQ3ODcxNl0gIDAwMDAwMDAwIDAwMDAwMDAwIDg1
NDI5ZDI0IDc5ODUzMWJmIDg1NDI5ZDNjIDc5MDZjNDJmIDc5MDgzMWNmIDAwMDAwMjAxClsg
ICAgMi40ODAxOThdICAwMDAwMDAwMSA3ZWE1MmMxNCA4NTQyOWQ0YyA3OTA2YzRkNyAwMDAw
MDAwOSAwMDAwMDAwMCA4NTQyOWQ3MCA3OTA4MzFjZgpbICAgIDIuNDgwNDI5XSAgODU0MmI3
NzAgN2VhNTJjMzQgMDAwMDAwMjAgMDAwMDAwMDEgMDAwMDAyNDYgMDAwMDAwMDAgMDAwMDAw
MjAgODU0MjlkOTAKWyAgICAyLjQ4MDQyOV0gQ2FsbCBUcmFjZToKWyAgICAyLjQ4MDQyOV0g
IFs8Nzk4NTMxYmY+XSBkdW1wX3N0YWNrKzB4MTYvMHgxOApbICAgIDIuNDgwNDI5XSAgWzw3
OTA2YzQyZj5dIHdhcm5fc2xvd3BhdGhfY29tbW9uKzB4NDgvMHg1ZgpbICAgIDIuNDgwNDI5
XSAgWzw3OTA4MzFjZj5dID8gX19xdWV1ZV9kZWxheWVkX3dvcmsrMHg4MS8weDI0NwpbICAg
IDIuNDgwNDI5XSAgWzw3OTA2YzRkNz5dIHdhcm5fc2xvd3BhdGhfbnVsbCsweDE0LzB4MTgK
WyAgICAyLjQ4MDQyOV0gIFs8NzkwODMxY2Y+XSBfX3F1ZXVlX2RlbGF5ZWRfd29yaysweDgx
LzB4MjQ3ClsgICAgMi40ODA0MjldICBbPDc5MDg0MzU4Pl0gcXVldWVfZGVsYXllZF93b3Jr
X29uKzB4NDIvMHg1OQpbICAgIDIuNDgwNDI5XSAgWzw3OTJkOTQ0Yz5dIHNjaGVkdWxlX2Rl
bGF5ZWRfd29yaysweDE2LzB4MTgKWyAgICAyLjQ4MDQyOV0gIFs8NzkyZGE3MmI+XSBkcm1f
aGVscGVyX3Byb2JlX3NpbmdsZV9jb25uZWN0b3JfbW9kZXMrMHhmNS8weDJiZQpbICAgIDIu
NDgwNDI5XSAgWzw3OTJkNzgyMT5dIGRybV9mYl9oZWxwZXJfcHJvYmVfY29ubmVjdG9yX21v
ZGVzKzB4M2EvMHg0ZQpbICAgIDIuNDgwNDI5XSAgWzw3OTJkOGZkYz5dIGRybV9mYl9oZWxw
ZXJfaW5pdGlhbF9jb25maWcrMHgxNGQvMHgzYWUKWyAgICAyLjQ4MDQyOV0gIFs8NzkxMTA5
OTY+XSA/IF9fa21hbGxvY19ub2RlKzB4NmEvMHhkNgpbICAgIDIuNDgwNDI5XSAgWzw3OTJk
OTY0MT5dID8gZHJtX2hlbHBlcl9kaXNhYmxlX3VudXNlZF9mdW5jdGlvbnMrMHhjMy8weGRj
ClsgICAgMi40ODA0MjldICBbPDc5MzRjZDdjPl0gY2lycnVzX2ZiZGV2X2luaXQrMHg3Yy8w
eDhkClsgICAgMi40ODA0MjldICBbPDc5MzRjNjIzPl0gY2lycnVzX21vZGVzZXRfaW5pdCsw
eDE0NS8weDE4NgpbICAgIDIuNDgwNDI5XSAgWzw3OTM0YjkyNT5dIGNpcnJ1c19kcml2ZXJf
bG9hZCsweDg4LzB4Y2UKWyAgICAyLjQ4MDQyOV0gIFs8NzkyZTQzMjE+XSBkcm1fZ2V0X3Bj
aV9kZXYrMHgxMzYvMHgyMTQKWyAgICAyLjQ4MDQyOV0gIFs8NzkzNGM3MjQ+XSBjaXJydXNf
cGNpX3Byb2JlKzB4ODUvMHg5MQpbICAgIDIuNDgwNDI5XSAgWzw3OTFmYmNmYT5dIHBjaV9k
ZXZpY2VfcHJvYmUrMHg1Yy8weDk0ClsgICAgMi40ODA0MjldICBbPDc5M2U0NTg2Pl0gZHJp
dmVyX3Byb2JlX2RldmljZSsweDk3LzB4MWIxClsgICAgMi40ODA0MjldICBbPDc5M2U0NzI0
Pl0gX19kcml2ZXJfYXR0YWNoKzB4NTMvMHg2ZgpbICAgIDIuNDgwNDI5XSAgWzw3OTNlMzFk
ND5dIGJ1c19mb3JfZWFjaF9kZXYrMHgzZS8weDY5ClsgICAgMi40ODA0MjldICBbPDc5M2U0
NGE2Pl0gZHJpdmVyX2F0dGFjaCsweDE5LzB4MWIKWyAgICAyLjQ4MDQyOV0gIFs8NzkzZTQ2
ZDE+XSA/IF9fZGV2aWNlX2F0dGFjaCsweDMxLzB4MzEKWyAgICAyLjQ4MDQyOV0gIFs8Nzkz
ZTM4MmU+XSBidXNfYWRkX2RyaXZlcisweGI0LzB4MWJkClsgICAgMi40ODA0MjldICBbPDc5
M2U0ZWYzPl0gZHJpdmVyX3JlZ2lzdGVyKzB4OGMvMHhlOQpbICAgIDIuNDgwNDI5XSAgWzw3
OTFmYmIyZD5dIF9fcGNpX3JlZ2lzdGVyX2RyaXZlcisweDRhLzB4NGQKWyAgICAyLjQ4MDQy
OV0gIFs8NzkyZTQ0NzA+XSBkcm1fcGNpX2luaXQrMHg3MS8weGM5ClsgICAgMi40ODA0Mjld
ICBbPDc5ZGY3ZjE2Pl0gPyBmdHJhY2VfZGVmaW5lX2ZpZWxkc19pbnRlbF9ncHVfZnJlcV9j
aGFuZ2UrMHgxYy8weDFjClsgICAgMi40ODA0MjldICBbPDc5ZGY3ZjMxPl0gY2lycnVzX2lu
aXQrMHgxYi8weDI1ClsgICAgMi40ODA0MjldICBbPDc5ZGNhYTI4Pl0gZG9fb25lX2luaXRj
YWxsKzB4NmIvMHgxMTkKWyAgICAyLjQ4MDQyOV0gIFs8NzlkY2FiYzc+XSBrZXJuZWxfaW5p
dF9mcmVlYWJsZSsweGYxLzB4MTcxClsgICAgMi40ODA0MjldICBbPDc5ODQxNjFlPl0ga2Vy
bmVsX2luaXQrMHhkLzB4YjkKWyAgICAyLjQ4MDQyOV0gIFs8Nzk4NjBjZjc+XSByZXRfZnJv
bV9rZXJuZWxfdGhyZWFkKzB4MWIvMHgyOApbICAgIDIuNDgwNDI5XSAgWzw3OTg0MTYxMT5d
ID8gcmVzdF9pbml0KzB4YjEvMHhiMQpbICAgIDIuNDgwNDI5XSAtLS1bIGVuZCB0cmFjZSA2
ODRjNTJlNmE2MjkxOTg5IF0tLS0KL2tlcm5lbC9pMzg2LXJhbmRjb25maWctczA3LTA2Mjgv
YjUzZTAzNzkzMDEzNGQxMWZhNjMwNzE2MmI0MWZiMTliNmM0MzY0My9kbWVzZy1rdm0tYXRo
ZW5zLTE3NTY5LTIwMTMwNjI5MDkxNTUwLTMuMTAuMC1yYzctd2wtMDE1OTYtZ2I1M2UwMzct
MQova2VybmVsL2kzODYtcmFuZGNvbmZpZy1zMDctMDYyOC9iNTNlMDM3OTMwMTM0ZDExZmE2
MzA3MTYyYjQxZmIxOWI2YzQzNjQzL2RtZXNnLWt2bS1hdGhlbnMtMjkyMjUtMjAxMzA2Mjkw
OTE1MjgtMy4xMC4wLXJjNy13bC0wMTU5Ni1nYjUzZTAzNy0xCi9rZXJuZWwvaTM4Ni1yYW5k
Y29uZmlnLXMwNy0wNjI4L2I1M2UwMzc5MzAxMzRkMTFmYTYzMDcxNjJiNDFmYjE5YjZjNDM2
NDMvZG1lc2cta3ZtLWF0aGVucy0zNzQ1Ny0yMDEzMDYyOTA5MTU1MS0zLjEwLjAtcmM3LXds
LTAxNTk2LWdiNTNlMDM3LTEKL2tlcm5lbC9pMzg2LXJhbmRjb25maWctczA3LTA2MjgvYjUz
ZTAzNzkzMDEzNGQxMWZhNjMwNzE2MmI0MWZiMTliNmM0MzY0My9kbWVzZy1rdm0tYXRoZW5z
LTUxNzcxLTIwMTMwNjI5MDkxNTUwLTMuMTAuMC1yYzctd2wtMDE1OTYtZ2I1M2UwMzctMQov
a2VybmVsL2kzODYtcmFuZGNvbmZpZy1zMDctMDYyOC9iNTNlMDM3OTMwMTM0ZDExZmE2MzA3
MTYyYjQxZmIxOWI2YzQzNjQzL2RtZXNnLWt2bS1jYWlyby0xMjI4Mi0yMDEzMDYyOTA5MTU1
MS0zLjEwLjAtcmM3LXdsLTAxNTk2LWdiNTNlMDM3LTEKL2tlcm5lbC9pMzg2LXJhbmRjb25m
aWctczA3LTA2MjgvYjUzZTAzNzkzMDEzNGQxMWZhNjMwNzE2MmI0MWZiMTliNmM0MzY0My9k
bWVzZy1rdm0tY2Fpcm8tMTU4MTctMjAxMzA2MjkwOTE1MzQtMy4xMC4wLXJjNy13bC0wMTU5
Ni1nYjUzZTAzNy0xCi9rZXJuZWwvaTM4Ni1yYW5kY29uZmlnLXMwNy0wNjI4L2I1M2UwMzc5
MzAxMzRkMTFmYTYzMDcxNjJiNDFmYjE5YjZjNDM2NDMvZG1lc2cta3ZtLWNhaXJvLTIzNTYx
LTIwMTMwNjI5MDkxNTUxLTMuMTAuMC1yYzctd2wtMDE1OTYtZ2I1M2UwMzctMQova2VybmVs
L2kzODYtcmFuZGNvbmZpZy1zMDctMDYyOC9iNTNlMDM3OTMwMTM0ZDExZmE2MzA3MTYyYjQx
ZmIxOWI2YzQzNjQzL2RtZXNnLWt2bS1jYWlyby0yNTEzNS0yMDEzMDYyOTA5MTUyNi0zLjEw
LjAtcmM3LXdsLTAxNTk2LWdiNTNlMDM3LTEKL2tlcm5lbC9pMzg2LXJhbmRjb25maWctczA3
LTA2MjgvYjUzZTAzNzkzMDEzNGQxMWZhNjMwNzE2MmI0MWZiMTliNmM0MzY0My9kbWVzZy1r
dm0tY2Fpcm8tMjg4MTQtMjAxMzA2MjkwOTE1NDUtMy4xMC4wLXJjNy13bC0wMTU5Ni1nYjUz
ZTAzNy0xCi9rZXJuZWwvaTM4Ni1yYW5kY29uZmlnLXMwNy0wNjI4L2I1M2UwMzc5MzAxMzRk
MTFmYTYzMDcxNjJiNDFmYjE5YjZjNDM2NDMvZG1lc2cta3ZtLWNhaXJvLTc5MDktMjAxMzA2
MjkwOTE1NTItMy4xMC4wLXJjNy13bC0wMTU5Ni1nYjUzZTAzNy0xCi9rZXJuZWwvaTM4Ni1y
YW5kY29uZmlnLXMwNy0wNjI4L2I1M2UwMzc5MzAxMzRkMTFmYTYzMDcxNjJiNDFmYjE5YjZj
NDM2NDMvZG1lc2cta3ZtLWlubi0xMDU3My0yMDEzMDYyOTA5MTUxNy0zLjEwLjAtcmM3LXds
LTAxNTk2LWdiNTNlMDM3LTEKL2tlcm5lbC9pMzg2LXJhbmRjb25maWctczA3LTA2MjgvYjUz
ZTAzNzkzMDEzNGQxMWZhNjMwNzE2MmI0MWZiMTliNmM0MzY0My9kbWVzZy1rdm0taW5uLTE1
MTc2LTIwMTMwNjI5MDkxNTM0LTMuMTAuMC1yYzctd2wtMDE1OTYtZ2I1M2UwMzctMQova2Vy
bmVsL2kzODYtcmFuZGNvbmZpZy1zMDctMDYyOC9iNTNlMDM3OTMwMTM0ZDExZmE2MzA3MTYy
YjQxZmIxOWI2YzQzNjQzL2RtZXNnLWt2bS1pbm4tMTkxNTAtMjAxMzA2MjkwOTE1NDgtMy4x
MC4wLXJjNy13bC0wMTU5Ni1nYjUzZTAzNy0xCi9rZXJuZWwvaTM4Ni1yYW5kY29uZmlnLXMw
Ny0wNjI4L2I1M2UwMzc5MzAxMzRkMTFmYTYzMDcxNjJiNDFmYjE5YjZjNDM2NDMvZG1lc2ct
a3ZtLWlubi0yMjg3Ny0yMDEzMDYyOTA5MTUyOS0zLjEwLjAtcmM3LXdsLTAxNTk2LWdiNTNl
MDM3LTEKL2tlcm5lbC9pMzg2LXJhbmRjb25maWctczA3LTA2MjgvYjUzZTAzNzkzMDEzNGQx
MWZhNjMwNzE2MmI0MWZiMTliNmM0MzY0My9kbWVzZy1rdm0taW5uLTI0MzM1LTIwMTMwNjI5
MDkxNTM5LTMuMTAuMC1yYzctd2wtMDE1OTYtZ2I1M2UwMzctMQova2VybmVsL2kzODYtcmFu
ZGNvbmZpZy1zMDctMDYyOC9iNTNlMDM3OTMwMTM0ZDExZmE2MzA3MTYyYjQxZmIxOWI2YzQz
NjQzL2RtZXNnLWt2bS1pbm4tMzI4NjctMjAxMzA2MjkwOTE1NDYtMy4xMC4wLXJjNy13bC0w
MTU5Ni1nYjUzZTAzNy0xCi9rZXJuZWwvaTM4Ni1yYW5kY29uZmlnLXMwNy0wNjI4L2I1M2Uw
Mzc5MzAxMzRkMTFmYTYzMDcxNjJiNDFmYjE5YjZjNDM2NDMvZG1lc2cta3ZtLXZwLTEwNDIz
LTIwMTMwNjI4MDQzNjUxLTMuMTAuMC1yYzctd2wtMDE1OTYtZ2I1M2UwMzctMQova2VybmVs
L2kzODYtcmFuZGNvbmZpZy1zMDctMDYyOC9iNTNlMDM3OTMwMTM0ZDExZmE2MzA3MTYyYjQx
ZmIxOWI2YzQzNjQzL2RtZXNnLWt2bS12cC0xNTAwOC0yMDEzMDYyOTA5MTQxMi0zLjEwLjAt
cmM3LXdsLTAxNTk2LWdiNTNlMDM3LTEKL2tlcm5lbC9pMzg2LXJhbmRjb25maWctczA3LTA2
MjgvYjUzZTAzNzkzMDEzNGQxMWZhNjMwNzE2MmI0MWZiMTliNmM0MzY0My9kbWVzZy1rdm0t
dnAtMTgxMDktMjAxMzA2MjgwNDM3NDUtMy4xMC4wLXJjNy0wMDE4OC1nMzI2YjlhMy0xNgov
a2VybmVsL2kzODYtcmFuZGNvbmZpZy1zMDctMDYyOC9iNTNlMDM3OTMwMTM0ZDExZmE2MzA3
MTYyYjQxZmIxOWI2YzQzNjQzL2RtZXNnLWt2bS12cC0yNDE4MC0yMDEzMDYyODA0NDA1NS0z
LjEwLjAtcmM3LXdsLTAxNTk2LWdiNTNlMDM3LTEKL2tlcm5lbC9pMzg2LXJhbmRjb25maWct
czA3LTA2MjgvYjUzZTAzNzkzMDEzNGQxMWZhNjMwNzE2MmI0MWZiMTliNmM0MzY0My9kbWVz
Zy1rdm0tdnAtNjI5NC0yMDEzMDYyOTA5MTM1Mi0zLjEwLjAtcmM3LXdsLTAxNTk2LWdiNTNl
MDM3LTEKL2tlcm5lbC9pMzg2LXJhbmRjb25maWctczA3LTA2MjgvYjUzZTAzNzkzMDEzNGQx
MWZhNjMwNzE2MmI0MWZiMTliNmM0MzY0My9kbWVzZy1rdm0td2FpbWVhLTM2MDItMjAxMzA2
MjkwOTE1NTEtMy4xMC4wLXJjNy13bC0wMTU5Ni1nYjUzZTAzNy0xCi9rZXJuZWwvaTM4Ni1y
YW5kY29uZmlnLXMwNy0wNjI4L2I1M2UwMzc5MzAxMzRkMTFmYTYzMDcxNjJiNDFmYjE5YjZj
NDM2NDMvZG1lc2cta3ZtLXdhaW1lYS0zOTAxLTIwMTMwNjI4MDQzODMyLTMuMTAuMC1yYzct
MDAxODgtZzMyNmI5YTMtMTUKL2tlcm5lbC9pMzg2LXJhbmRjb25maWctczA3LTA2MjgvYjUz
ZTAzNzkzMDEzNGQxMWZhNjMwNzE2MmI0MWZiMTliNmM0MzY0My9kbWVzZy1rdm0td2FpbWVh
LTQwMjAtMjAxMzA2MjgwNDM4MTctMy4xMC4wLXJjNy13bC0wMTU5Ni1nYjUzZTAzNy0xCi9r
ZXJuZWwvaTM4Ni1yYW5kY29uZmlnLXMwNy0wNjI4L2I1M2UwMzc5MzAxMzRkMTFmYTYzMDcx
NjJiNDFmYjE5YjZjNDM2NDMvZG1lc2cta3ZtLXhibS0zNDE3LTIwMTMwNjI4MDQ0MjI1LTMu
MTAuMC1yYzctd2wtMDE1OTYtZ2I1M2UwMzctMQova2VybmVsL2kzODYtcmFuZGNvbmZpZy1z
MDctMDYyOC9iNTNlMDM3OTMwMTM0ZDExZmE2MzA3MTYyYjQxZmIxOWI2YzQzNjQzL2RtZXNn
LWt2bS14Ym0tNDU4MS0yMDEzMDYyODA0NDE1MS0zLjEwLjAtcmM3LTAxNjk5LWczZjA1NWVk
LTQzCi9rZXJuZWwvaTM4Ni1yYW5kY29uZmlnLXMwNy0wNjI4L2I1M2UwMzc5MzAxMzRkMTFm
YTYzMDcxNjJiNDFmYjE5YjZjNDM2NDMvZG1lc2cta3ZtLXhibS03MzU2LTIwMTMwNjI5MDkx
NTIzLTMuMTAuMC1yYzctd2wtMDE1OTYtZ2I1M2UwMzctMQova2VybmVsL2kzODYtcmFuZGNv
bmZpZy1zMDctMDYyOC9iNTNlMDM3OTMwMTM0ZDExZmE2MzA3MTYyYjQxZmIxOWI2YzQzNjQz
L2RtZXNnLWt2bS14Z3dvLTMyMTktMjAxMzA2MjgwNDM4NTctMy4xMC4wLXJjNy13bC0wMTU5
Ni1nYjUzZTAzNy0xCi9rZXJuZWwvaTM4Ni1yYW5kY29uZmlnLXMwNy0wNjI4L2I1M2UwMzc5
MzAxMzRkMTFmYTYzMDcxNjJiNDFmYjE5YjZjNDM2NDMvZG1lc2cta3ZtLXhnd28tNjA1MS0y
MDEzMDYyODA0MzUxNS0zLjEwLjAtcmM3LXdsLTAxNTk2LWdiNTNlMDM3LTEKCltkZXRhY2hl
ZCBIRUFEIGMxMzczNzJdIFJldmVydCAiZHJtOiBrbXNfaGVscGVyOiBkb24ndCBsb3NlIGhv
dHBsdWcgZXZlbnQiCiAyIGZpbGVzIGNoYW5nZWQsIDEgaW5zZXJ0aW9uKCspLCAzMiBkZWxl
dGlvbnMoLSkKbHMgLWEgL2tlcm5lbC10ZXN0cy9ydW4tcXVldWUva3ZtL2kzODYtcmFuZGNv
bmZpZy1zMDctMDYyOC9saW51eC1kZXZlbDpkZXZlbC1zbmItaTM4Ni0yMDEzMDYyODAzNTI6
YzEzNzM3MjkxZDA4NjM0YjRlN2U1OTg2MmVhM2FlMmE3ZGJmYjM2ZDpiaXNlY3QtbmV0Cgoy
MDEzLTA2LTI5LTE1OjUxOjA1IGMxMzczNzI5MWQwODYzNGI0ZTdlNTk4NjJlYTNhZTJhN2Ri
ZmIzNmQgY29tcGlsaW5nCgoyMDEzLTA2LTI5LTE1OjU0OjMxIGRldGVjdGluZyBib290IHN0
YXRlIDMuMTAuMC1yYzctd2wtMDE1OTctZ2MxMzczNzIuCTI0CTU3CTYwIFNVQ0NFU1MKCgo9
PT09PT09PT0gdXBzdHJlYW0gPT09PT09PT09CkZldGNoaW5nIGxpbnVzCmxzIC1hIC9rZXJu
ZWwtdGVzdHMvcnVuLXF1ZXVlL2t2bS9pMzg2LXJhbmRjb25maWctczA3LTA2MjgvbGludXgt
ZGV2ZWw6ZGV2ZWwtc25iLWkzODYtMjAxMzA2MjgwMzUyOjk4YjZlZDBmMmJmNGFiZmI3NTky
MDZhYTcwNjkwNjM2MzcyYmRlZTc6YmlzZWN0LW5ldAoKMjAxMy0wNi0yOS0xNTo1Njo0NSA5
OGI2ZWQwZjJiZjRhYmZiNzU5MjA2YWE3MDY5MDYzNjM3MmJkZWU3IHJldXNlIC9rZXJuZWwv
aTM4Ni1yYW5kY29uZmlnLXMwNy0wNjI4Lzk4YjZlZDBmMmJmNGFiZmI3NTkyMDZhYTcwNjkw
NjM2MzcyYmRlZTcvdm1saW51ei0zLjEwLjAtcmM3LTAwMTM1LWc5OGI2ZWQwCgoyMDEzLTA2
LTI5LTE1OjU2OjQ1IGRldGVjdGluZyBib290IHN0YXRlIC4JMzQJNjAgU1VDQ0VTUwoKCj09
PT09PT09PSBsaW51eC1uZXh0ID09PT09PT09PQpGZXRjaGluZyBuZXh0CmxzIC1hIC9rZXJu
ZWwtdGVzdHMvcnVuLXF1ZXVlL2t2bS9pMzg2LXJhbmRjb25maWctczA3LTA2MjgvbGludXgt
ZGV2ZWw6ZGV2ZWwtc25iLWkzODYtMjAxMzA2MjgwMzUyOjRhZDEyNWY5ODY2MmIzMjI2ZGFh
ZWExYTI3N2E1OTM2MDA2YzEwZDc6YmlzZWN0LW5ldAoKMjAxMy0wNi0yOS0xNTo1ODoyOCA0
YWQxMjVmOTg2NjJiMzIyNmRhYWVhMWEyNzdhNTkzNjAwNmMxMGQ3IGNvbXBpbGluZwoKMjAx
My0wNi0yOS0xNjowMjowMiBkZXRlY3RpbmcgYm9vdCBzdGF0ZSAzLjEwLjAtcmM3LW5leHQt
MjAxMzA2MjgtMDk0MTMtZzRhZDEyNWYuLiBURVNUIEZBSUxVUkUKWyAgICA3Ljc1MDAyM10g
IDAwMDAwMjAxIDAwMDAwMDAxIDdlYTI4NTBjIDg1NDI5ZDBjIDc5MDc2MTEyIDAwMDAwMDA5
IDAwMDAwMDAwIDg1NDI5ZDMwClsgICAgNy43NTAwMjNdICA3OTA4Y2NhZCA4NTQyYTlmMCA3
ZWEyODUyYyAwMDAwMDAyMCAwMDAwMDAwMSAwMDAwMDI0NiAwMDAwMDAwMCAwMDAwMDAyMApb
ICAgIDcuNzUwMDIzXSBDYWxsIFRyYWNlOgpbICAgIDcuNzUwMDIzXSAgWzw3OTg1NjZkOD5d
IGR1bXBfc3RhY2srMHg0Yi8weDY2ClsgICAgNy43NTAwMjNdICBbPDc5MDc2MDZhPl0gd2Fy
bl9zbG93cGF0aF9jb21tb24rMHg2MS8weDc4ClsgICAgNy43NTAwMjNdICBbPDc5MDhjY2Fk
Pl0gPyBfX3F1ZXVlX2RlbGF5ZWRfd29yaysweDgxLzB4MjQ3ClsgICAgNy43NTAwMjNdICBb
PDc5MDc2MTEyPl0gd2Fybl9zbG93cGF0aF9udWxsKzB4MTQvMHgxOApbICAgIDcuNzUwMDIz
XSAgWzw3OTA4Y2NhZD5dIF9fcXVldWVfZGVsYXllZF93b3JrKzB4ODEvMHgyNDcKWyAgICA3
Ljc1MDAyM10gIFs8NzkwOGRlMzY+XSBxdWV1ZV9kZWxheWVkX3dvcmtfb24rMHg0Mi8weDU5
ClsgICAgNy43NTAwMjNdICBbPDc5MmU1MjM2Pl0gc2NoZWR1bGVfZGVsYXllZF93b3JrKzB4
MTYvMHgxOApbICAgIDcuNzUwMDIzXSAgWzw3OTJlNjUxNT5dIGRybV9oZWxwZXJfcHJvYmVf
c2luZ2xlX2Nvbm5lY3Rvcl9tb2RlcysweGY1LzB4MmJlClsgICAgNy43NTAwMjNdICBbPDc5
MmUzNjBhPl0gZHJtX2ZiX2hlbHBlcl9wcm9iZV9jb25uZWN0b3JfbW9kZXMrMHgzYS8weDRl
ClsgICAgNy43NTAwMjNdICBbPDc5MmU0ZGM2Pl0gZHJtX2ZiX2hlbHBlcl9pbml0aWFsX2Nv
bmZpZysweDE0ZC8weDNhZQpbICAgIDcuNzUwMDIzXSAgWzw3OTExZDM0Nz5dID8gX19rbWFs
bG9jX25vZGUrMHg2YS8weGQ2ClsgICAgNy43NTAwMjNdICBbPDc5MmU1NDJiPl0gPyBkcm1f
aGVscGVyX2Rpc2FibGVfdW51c2VkX2Z1bmN0aW9ucysweGMzLzB4ZGMKWyAgICA3Ljc1MDAy
M10gIFs8NzkzNTk4MjU+XSBjaXJydXNfZmJkZXZfaW5pdCsweDdjLzB4OGQKWyAgICA3Ljc1
MDAyM10gIFs8NzkzNTkxYmY+XSBjaXJydXNfbW9kZXNldF9pbml0KzB4MTQ1LzB4MTg2Clsg
ICAgNy43NTAwMjNdICBbPDc5MzU4NWEzPl0gY2lycnVzX2RyaXZlcl9sb2FkKzB4ODgvMHhj
ZQpbICAgIDcuNzUwMDIzXSAgWzw3OTJlZmRmMD5dIGRybV9nZXRfcGNpX2RldisweDEzNi8w
eDIxNApbICAgIDcuNzUwMDIzXSAgWzw3OTM1OTJjMD5dIGNpcnJ1c19wY2lfcHJvYmUrMHg4
NS8weDkxClsgICAgNy43NTAwMjNdICBbPDc5MjA5OTVkPl0gcGNpX2RldmljZV9wcm9iZSsw
eDVjLzB4OTQKWyAgICA3Ljc1MDAyM10gIFs8NzkzZWQ3NmQ+XSBkcml2ZXJfcHJvYmVfZGV2
aWNlKzB4OTcvMHgxYjEKWyAgICA3Ljc1MDAyM10gIFs8NzkzZWQ5MGI+XSBfX2RyaXZlcl9h
dHRhY2grMHg1My8weDZmClsgICAgNy43NTAwMjNdICBbPDc5M2VjM2QwPl0gYnVzX2Zvcl9l
YWNoX2RldisweDNlLzB4NjkKWyAgICA3Ljc1MDAyM10gIFs8NzkzZWQ2OGQ+XSBkcml2ZXJf
YXR0YWNoKzB4MTkvMHgxYgpbICAgIDcuNzUwMDIzXSAgWzw3OTNlZDhiOD5dID8gX19kZXZp
Y2VfYXR0YWNoKzB4MzEvMHgzMQpbICAgIDcuNzUwMDIzXSAgWzw3OTNlY2EyYT5dIGJ1c19h
ZGRfZHJpdmVyKzB4YjQvMHgxYmQKWyAgICA3Ljc1MDAyM10gIFs8NzkzZWUwZGE+XSBkcml2
ZXJfcmVnaXN0ZXIrMHg4Yy8weGU5ClsgICAgNy43NTAwMjNdICBbPDc5MjA5NzkwPl0gX19w
Y2lfcmVnaXN0ZXJfZHJpdmVyKzB4NGEvMHg0ZApbICAgIDcuNzUwMDIzXSAgWzw3OTJlZmYz
Zj5dIGRybV9wY2lfaW5pdCsweDcxLzB4YzkKWyAgICA3Ljc1MDAyM10gIFs8NzllMDE5MmI+
XSA/IGZ0cmFjZV9kZWZpbmVfZmllbGRzX2ludGVsX2dwdV9mcmVxX2NoYW5nZSsweDFjLzB4
MWMKWyAgICA3Ljc1MDAyM10gIFs8NzllMDE5NDY+XSBjaXJydXNfaW5pdCsweDFiLzB4MjUK
WyAgICA3Ljc4MDAzOV0gIFs8NzlkZDNhMjg+XSBkb19vbmVfaW5pdGNhbGwrMHg2Yi8weDEw
ZgpbICAgIDcuNzgwMDM5XSAgWzw3OWRkMzQwMD5dID8gZG9fZWFybHlfcGFyYW0rMHg1Ny8w
eDc1ClsgICAgNy43ODAwMzldICBbPDc5MDkyNDVmPl0gPyBwYXJzZV9hcmdzKzB4MTcyLzB4
MjEzClsgICAgNy43ODAwMzldICBbPDc5ZGQzYmJkPl0ga2VybmVsX2luaXRfZnJlZWFibGUr
MHhmMS8weDE3MQpbICAgIDcuNzgwMDM5XSAgWzw3OTg0ZmI2Mj5dIGtlcm5lbF9pbml0KzB4
ZC8weGI5ClsgICAgNy43ODAwMzldICBbPDc5ODY0NTc3Pl0gcmV0X2Zyb21fa2VybmVsX3Ro
cmVhZCsweDFiLzB4MjgKWyAgICA3Ljc4MDAzOV0gIFs8Nzk4NGZiNTU+XSA/IHJlc3RfaW5p
dCsweGIxLzB4YjEKWyAgICA3Ljc4MDAzOV0gLS0tWyBlbmQgdHJhY2UgOTE3YTYyNWIyYTY3
OGM3NSBdLS0tCi9rZXJuZWwvaTM4Ni1yYW5kY29uZmlnLXMwNy0wNjI4LzRhZDEyNWY5ODY2
MmIzMjI2ZGFhZWExYTI3N2E1OTM2MDA2YzEwZDcvZG1lc2cta3ZtLXZwLTEzMDM2LTIwMTMw
NjI5MTYwMzU4LS0KL2tlcm5lbC9pMzg2LXJhbmRjb25maWctczA3LTA2MjgvNGFkMTI1Zjk4
NjYyYjMyMjZkYWFlYTFhMjc3YTU5MzYwMDZjMTBkNy9kbWVzZy1rdm0tdnAtMTM1MzctMjAx
MzA2MjkxNjA0MDAtMy4xMC4wLXJjNy1uZXh0LTIwMTMwNjI4LTA5NDEzLWc0YWQxMjVmLTEw
Mgova2VybmVsL2kzODYtcmFuZGNvbmZpZy1zMDctMDYyOC80YWQxMjVmOTg2NjJiMzIyNmRh
YWVhMWEyNzdhNTkzNjAwNmMxMGQ3L2RtZXNnLWt2bS12cC0xNTAwOC0yMDEzMDYyOTE2MDM1
OC0tCi9rZXJuZWwvaTM4Ni1yYW5kY29uZmlnLXMwNy0wNjI4LzRhZDEyNWY5ODY2MmIzMjI2
ZGFhZWExYTI3N2E1OTM2MDA2YzEwZDcvZG1lc2cta3ZtLXZwLTIwNDk0LTIwMTMwNjI5MTYw
NDAxLTMuMTAuMC1yYzctMDAyNDMtZzRlYjI0NDktNzQKL2tlcm5lbC9pMzg2LXJhbmRjb25m
aWctczA3LTA2MjgvNGFkMTI1Zjk4NjYyYjMyMjZkYWFlYTFhMjc3YTU5MzYwMDZjMTBkNy9k
bWVzZy1rdm0tdnAtMjIwNzItMjAxMzA2MjkxNjA0MDAtMy4xMC4wLXJjNy0wMDAzMC1nZjNj
ZjEzOS05Nwova2VybmVsL2kzODYtcmFuZGNvbmZpZy1zMDctMDYyOC80YWQxMjVmOTg2NjJi
MzIyNmRhYWVhMWEyNzdhNTkzNjAwNmMxMGQ3L2RtZXNnLWt2bS12cC03NTE0LTIwMTMwNjI5
MTYwMzU5LTMuMTAuMC1yYzctMDAxMzUtZzk4YjZlZDAtMTkKL2tlcm5lbC9pMzg2LXJhbmRj
b25maWctczA3LTA2MjgvNGFkMTI1Zjk4NjYyYjMyMjZkYWFlYTFhMjc3YTU5MzYwMDZjMTBk
Ny9kbWVzZy1rdm0td2FpbWVhLTUxMjMtMjAxMzA2MjkxNjA1MzMtMy4xLjAtcmM5LTAwMDY1
LWc1M2EwMTlhLTEwOAova2VybmVsL2kzODYtcmFuZGNvbmZpZy1zMDctMDYyOC80YWQxMjVm
OTg2NjJiMzIyNmRhYWVhMWEyNzdhNTkzNjAwNmMxMGQ3L2RtZXNnLWt2bS13YWltZWEtNTQ3
My0yMDEzMDYyOTE2MDUzMy0tCi9rZXJuZWwvaTM4Ni1yYW5kY29uZmlnLXMwNy0wNjI4LzRh
ZDEyNWY5ODY2MmIzMjI2ZGFhZWExYTI3N2E1OTM2MDA2YzEwZDcvZG1lc2cta3ZtLXZwLTc5
OTktMjAxMzA2MjkxNjA0MDItMy4xMC4wLXJjNy0wMDMyMS1nYmUzNzgzNS0xMDAKL2tlcm5l
bC9pMzg2LXJhbmRjb25maWctczA3LTA2MjgvNGFkMTI1Zjk4NjYyYjMyMjZkYWFlYTFhMjc3
YTU5MzYwMDZjMTBkNy9kbWVzZy1rdm0tdnAtOTAxMi0yMDEzMDYyOTE2MDQwMy0zLjEwLjAt
cmM3LTAwMzIwLWc3NmNlZGVkLTk4Ci9rZXJuZWwvaTM4Ni1yYW5kY29uZmlnLXMwNy0wNjI4
LzRhZDEyNWY5ODY2MmIzMjI2ZGFhZWExYTI3N2E1OTM2MDA2YzEwZDcvZG1lc2cta3ZtLXhn
d28tMTE4NzAtMjAxMzA2MjkxNjAyMTAtMy4xMC4wLXJjNy1uZXh0LTIwMTMwNjI4LTA5NDEz
LWc0YWQxMjVmLTEwMgova2VybmVsL2kzODYtcmFuZGNvbmZpZy1zMDctMDYyOC80YWQxMjVm
OTg2NjJiMzIyNmRhYWVhMWEyNzdhNTkzNjAwNmMxMGQ3L2RtZXNnLWt2bS1iZW5zLTM3NjAt
MjAxMzA2MjkxNjAxNDctMy4xMC4wLXJjNy0wMDEzNS1nOThiNmVkMC0xOQova2VybmVsL2kz
ODYtcmFuZGNvbmZpZy1zMDctMDYyOC80YWQxMjVmOTg2NjJiMzIyNmRhYWVhMWEyNzdhNTkz
NjAwNmMxMGQ3L2RtZXNnLWt2bS1iZW5zLTQwOTAtMjAxMzA2MjkxNjAxNDUtMy4xMC4wLXJj
Ny1uZXh0LTIwMTMwNjI4LTA5NDEzLWc0YWQxMjVmLTEwMgova2VybmVsL2kzODYtcmFuZGNv
bmZpZy1zMDctMDYyOC80YWQxMjVmOTg2NjJiMzIyNmRhYWVhMWEyNzdhNTkzNjAwNmMxMGQ3
L2RtZXNnLWt2bS12cC0xNDIwOS0yMDEzMDYyOTE2MDQwNS0zLjEwLjAtcmM3LTAwMjQzLWc0
ZWIyNDQ5LTc0Ci9rZXJuZWwvaTM4Ni1yYW5kY29uZmlnLXMwNy0wNjI4LzRhZDEyNWY5ODY2
MmIzMjI2ZGFhZWExYTI3N2E1OTM2MDA2YzEwZDcvZG1lc2cta3ZtLXZwLTE1NjIyLTIwMTMw
NjI5MTYwNDA2LTMuMTAuMC1yYzctMDAxMTAtZzk4YjZlZDAtMTcKL2tlcm5lbC9pMzg2LXJh
bmRjb25maWctczA3LTA2MjgvNGFkMTI1Zjk4NjYyYjMyMjZkYWFlYTFhMjc3YTU5MzYwMDZj
MTBkNy9kbWVzZy1rdm0tdnAtMTYyMTctMjAxMzA2MjkxNjA0MDctMy4xMC4wLXJjNy13bC02
ODQ3My1nOGRhODNkOGItOTQKL2tlcm5lbC9pMzg2LXJhbmRjb25maWctczA3LTA2MjgvNGFk
MTI1Zjk4NjYyYjMyMjZkYWFlYTFhMjc3YTU5MzYwMDZjMTBkNy9kbWVzZy1rdm0tdnAtMTY1
MDAtMjAxMzA2MjkxNjA0MDctLQova2VybmVsL2kzODYtcmFuZGNvbmZpZy1zMDctMDYyOC80
YWQxMjVmOTg2NjJiMzIyNmRhYWVhMWEyNzdhNTkzNjAwNmMxMGQ3L2RtZXNnLWt2bS12cC0x
ODk1MC0yMDEzMDYyOTE2MDQwOC0tCi9rZXJuZWwvaTM4Ni1yYW5kY29uZmlnLXMwNy0wNjI4
LzRhZDEyNWY5ODY2MmIzMjI2ZGFhZWExYTI3N2E1OTM2MDA2YzEwZDcvZG1lc2cta3ZtLXZw
LTE5ODgzLTIwMTMwNjI5MTYwNDA3LS0KL2tlcm5lbC9pMzg2LXJhbmRjb25maWctczA3LTA2
MjgvNGFkMTI1Zjk4NjYyYjMyMjZkYWFlYTFhMjc3YTU5MzYwMDZjMTBkNy9kbWVzZy1rdm0t
dnAtMjExOTAtMjAxMzA2MjkxNjA0MDYtLQova2VybmVsL2kzODYtcmFuZGNvbmZpZy1zMDct
MDYyOC80YWQxMjVmOTg2NjJiMzIyNmRhYWVhMWEyNzdhNTkzNjAwNmMxMGQ3L2RtZXNnLWt2
bS12cC0yMTQ3Mi0yMDEzMDYyOTE2MDQwNi0tCi9rZXJuZWwvaTM4Ni1yYW5kY29uZmlnLXMw
Ny0wNjI4LzRhZDEyNWY5ODY2MmIzMjI2ZGFhZWExYTI3N2E1OTM2MDA2YzEwZDcvZG1lc2ct
a3ZtLXZwLTIzODExLTIwMTMwNjI5MTYwNDEwLTMuMTAuMC1yYzctMDAyNDMtZzRlYjI0NDkt
NzQKL2tlcm5lbC9pMzg2LXJhbmRjb25maWctczA3LTA2MjgvNGFkMTI1Zjk4NjYyYjMyMjZk
YWFlYTFhMjc3YTU5MzYwMDZjMTBkNy9kbWVzZy1rdm0tdnAtMjQxODAtMjAxMzA2MjkxNjA0
MDYtMy45LjAtcmM1LTAwNjUwLWcwM2FhMWJjLTEyMAova2VybmVsL2kzODYtcmFuZGNvbmZp
Zy1zMDctMDYyOC80YWQxMjVmOTg2NjJiMzIyNmRhYWVhMWEyNzdhNTkzNjAwNmMxMGQ3L2Rt
ZXNnLWt2bS12cC0yNDUyMS0yMDEzMDYyOTE2MDQwNC0zLjEwLjAtcmM3LTAwMTEwLWc5OGI2
ZWQwLTE3Ci9rZXJuZWwvaTM4Ni1yYW5kY29uZmlnLXMwNy0wNjI4LzRhZDEyNWY5ODY2MmIz
MjI2ZGFhZWExYTI3N2E1OTM2MDA2YzEwZDcvZG1lc2cta3ZtLXZwLTI2NzQ0LTIwMTMwNjI5
MTYwNDA3LTMuOS4wLXJjMS0wMDA0NS1nZWJmNDRkMS0xMTQKL2tlcm5lbC9pMzg2LXJhbmRj
b25maWctczA3LTA2MjgvNGFkMTI1Zjk4NjYyYjMyMjZkYWFlYTFhMjc3YTU5MzYwMDZjMTBk
Ny9kbWVzZy1rdm0tdnAtMjc4ODgtMjAxMzA2MjkxNjA0MTAtLQova2VybmVsL2kzODYtcmFu
ZGNvbmZpZy1zMDctMDYyOC80YWQxMjVmOTg2NjJiMzIyNmRhYWVhMWEyNzdhNTkzNjAwNmMx
MGQ3L2RtZXNnLWt2bS12cC0yODE2My0yMDEzMDYyOTE2MDQwNi0zLjEwLjAtcmM3LTAwMjQz
LWc0ZWIyNDQ5LTc0Ci9rZXJuZWwvaTM4Ni1yYW5kY29uZmlnLXMwNy0wNjI4LzRhZDEyNWY5
ODY2MmIzMjI2ZGFhZWExYTI3N2E1OTM2MDA2YzEwZDcvZG1lc2cta3ZtLXZwLTUyMjYtMjAx
MzA2MjkxNjA0MTAtMy45LjAtcmMxLTAwMDgyLWc0YzE2YmQzLTExOQova2VybmVsL2kzODYt
cmFuZGNvbmZpZy1zMDctMDYyOC80YWQxMjVmOTg2NjJiMzIyNmRhYWVhMWEyNzdhNTkzNjAw
NmMxMGQ3L2RtZXNnLWt2bS12cC01NTQ3LTIwMTMwNjI5MTYwNDA2LTMuMTAuMC1yYzctMDAy
NDMtZzRlYjI0NDktNzQKL2tlcm5lbC9pMzg2LXJhbmRjb25maWctczA3LTA2MjgvNGFkMTI1
Zjk4NjYyYjMyMjZkYWFlYTFhMjc3YTU5MzYwMDZjMTBkNy9kbWVzZy1rdm0tdnAtODE2NS0y
MDEzMDYyOTE2MDQwNi0tCi9rZXJuZWwvaTM4Ni1yYW5kY29uZmlnLXMwNy0wNjI4LzRhZDEy
NWY5ODY2MmIzMjI2ZGFhZWExYTI3N2E1OTM2MDA2YzEwZDcvZG1lc2cta3ZtLXZwLTg0OTct
MjAxMzA2MjkxNjA0MDQtMy4xMC4wLXJjNy0wMDEzNS1nOThiNmVkMC01OAova2VybmVsL2kz
ODYtcmFuZGNvbmZpZy1zMDctMDYyOC80YWQxMjVmOTg2NjJiMzIyNmRhYWVhMWEyNzdhNTkz
NjAwNmMxMGQ3L2RtZXNnLWt2bS13YWltZWEtMjE0MTUtMjAxMzA2MjkxNjA1MzctMy4xLjAt
cmM5LTAwMDY1LWc1M2EwMTlhLTEwOAova2VybmVsL2kzODYtcmFuZGNvbmZpZy1zMDctMDYy
OC80YWQxMjVmOTg2NjJiMzIyNmRhYWVhMWEyNzdhNTkzNjAwNmMxMGQ3L2RtZXNnLWt2bS13
YWltZWEtMjE0MTgtMjAxMzA2MjkxNjA1MzYtMy4xMC4wLXJjNy1uZXh0LTIwMTMwNjI4LTA5
NDEzLWc0YWQxMjVmLTEwMgova2VybmVsL2kzODYtcmFuZGNvbmZpZy1zMDctMDYyOC80YWQx
MjVmOTg2NjJiMzIyNmRhYWVhMWEyNzdhNTkzNjAwNmMxMGQ3L2RtZXNnLWt2bS13YWltZWEt
MjE0MjAtMjAxMzA2MjkxNjA1MzctMy4xMC4wLXJjNy0wMDEzNS1nOThiNmVkMC0xOQova2Vy
bmVsL2kzODYtcmFuZGNvbmZpZy1zMDctMDYyOC80YWQxMjVmOTg2NjJiMzIyNmRhYWVhMWEy
NzdhNTkzNjAwNmMxMGQ3L2RtZXNnLWt2bS13YWltZWEtMzcxNS0yMDEzMDYyOTE2MDUzNS0z
LjEuMC1yYzktMDAwNjUtZzUzYTAxOWEtMTA4Ci9rZXJuZWwvaTM4Ni1yYW5kY29uZmlnLXMw
Ny0wNjI4LzRhZDEyNWY5ODY2MmIzMjI2ZGFhZWExYTI3N2E1OTM2MDA2YzEwZDcvZG1lc2ct
a3ZtLXdhaW1lYS02NjIyLTIwMTMwNjI5MTYwNTM5LTMuMTAuMC1yYzctMDAzMjEtZ2JlMzc4
MzUtMTAwCi9rZXJuZWwvaTM4Ni1yYW5kY29uZmlnLXMwNy0wNjI4LzRhZDEyNWY5ODY2MmIz
MjI2ZGFhZWExYTI3N2E1OTM2MDA2YzEwZDcvZG1lc2cta3ZtLXdhaW1lYS03MDA0LTIwMTMw
NjI5MTYwNTM3LTMuMTAuMC1yYzctMDAzMzItZzFmYjQ4ODMtOTYKL2tlcm5lbC9pMzg2LXJh
bmRjb25maWctczA3LTA2MjgvNGFkMTI1Zjk4NjYyYjMyMjZkYWFlYTFhMjc3YTU5MzYwMDZj
MTBkNy9kbWVzZy1rdm0teGJtLTE3OTI2LTIwMTMwNjI5MTYwNTM3LTMuMTAuMC1yYzctd2wt
MDE1OTctZ2MxMzczNzItMTAxCi9rZXJuZWwvaTM4Ni1yYW5kY29uZmlnLXMwNy0wNjI4LzRh
ZDEyNWY5ODY2MmIzMjI2ZGFhZWExYTI3N2E1OTM2MDA2YzEwZDcvZG1lc2cta3ZtLXhibS0x
OTc5LTIwMTMwNjI5MTYwNTMxLTMuMTAuMC1yYzctbmV4dC0yMDEzMDYyOC0wOTQxMy1nNGFk
MTI1Zi0xMDIKL2tlcm5lbC9pMzg2LXJhbmRjb25maWctczA3LTA2MjgvNGFkMTI1Zjk4NjYy
YjMyMjZkYWFlYTFhMjc3YTU5MzYwMDZjMTBkNy9kbWVzZy1rdm0teGJtLTI5NjE3LTIwMTMw
NjI5MTYwNTM2LS0KL2tlcm5lbC9pMzg2LXJhbmRjb25maWctczA3LTA2MjgvNGFkMTI1Zjk4
NjYyYjMyMjZkYWFlYTFhMjc3YTU5MzYwMDZjMTBkNy9kbWVzZy1rdm0teGJtLTQ3MTUtMjAx
MzA2MjkxNjA1MzUtMy4xMC4wLXJjNy0wMDExMC1nOThiNmVkMC0xNwova2VybmVsL2kzODYt
cmFuZGNvbmZpZy1zMDctMDYyOC80YWQxMjVmOTg2NjJiMzIyNmRhYWVhMWEyNzdhNTkzNjAw
NmMxMGQ3L2RtZXNnLWt2bS14Ym0tNzc4My0yMDEzMDYyOTE2MDUzNC0zLjEwLjAtcmM3LTAw
MzMyLWcxZmI0ODgzLTk2Ci9rZXJuZWwvaTM4Ni1yYW5kY29uZmlnLXMwNy0wNjI4LzRhZDEy
NWY5ODY2MmIzMjI2ZGFhZWExYTI3N2E1OTM2MDA2YzEwZDcvZG1lc2cta3ZtLXhibS05OTA4
LTIwMTMwNjI5MTYwNTM0LTMuMTAuMC1yYzctMDAzMzEtZzM4MzllN2YtOTkKL2tlcm5lbC9p
Mzg2LXJhbmRjb25maWctczA3LTA2MjgvNGFkMTI1Zjk4NjYyYjMyMjZkYWFlYTFhMjc3YTU5
MzYwMDZjMTBkNy9kbWVzZy1rdm0tYmVucy0zNTYxLTIwMTMwNjI5MTYwMTUzLTMuMTAuMC1y
YzctMDAyNDMtZzRlYjI0NDktNzQKCg==

--k+w/mQv8wyuph6w0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="config-3.10.0-rc7-wl-01596-gb53e037"

#
# Automatically generated file; DO NOT EDIT.
# Linux/i386 3.10.0-rc7 Kernel Configuration
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
# CONFIG_ZONE_DMA32 is not set
# CONFIG_AUDIT_ARCH is not set
CONFIG_ARCH_SUPPORTS_OPTIMIZED_INLINING=y
CONFIG_ARCH_SUPPORTS_DEBUG_PAGEALLOC=y
CONFIG_X86_32_SMP=y
CONFIG_X86_HT=y
CONFIG_X86_32_LAZY_GS=y
CONFIG_ARCH_HWEIGHT_CFLAGS="-fcall-saved-ecx -fcall-saved-edx"
CONFIG_ARCH_CPU_PROBE_RELEASE=y
CONFIG_ARCH_SUPPORTS_UPROBES=y
CONFIG_DEFCONFIG_LIST="/lib/modules/$UNAME_RELEASE/.config"
CONFIG_CONSTRUCTORS=y
CONFIG_IRQ_WORK=y
CONFIG_BUILDTIME_EXTABLE_SORT=y

#
# General setup
#
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
CONFIG_KERNEL_BZIP2=y
# CONFIG_KERNEL_LZMA is not set
# CONFIG_KERNEL_XZ is not set
# CONFIG_KERNEL_LZO is not set
CONFIG_DEFAULT_HOSTNAME="(none)"
# CONFIG_SYSVIPC is not set
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
CONFIG_HZ_PERIODIC=y
# CONFIG_NO_HZ_IDLE is not set
# CONFIG_NO_HZ is not set
CONFIG_HIGH_RES_TIMERS=y

#
# CPU/Task time and stats accounting
#
# CONFIG_TICK_CPU_ACCOUNTING is not set
CONFIG_IRQ_TIME_ACCOUNTING=y
# CONFIG_BSD_PROCESS_ACCT is not set
CONFIG_TASKSTATS=y
CONFIG_TASK_DELAY_ACCT=y
# CONFIG_TASK_XACCT is not set

#
# RCU Subsystem
#
CONFIG_TREE_RCU=y
# CONFIG_PREEMPT_RCU is not set
CONFIG_RCU_STALL_COMMON=y
CONFIG_RCU_FANOUT=32
CONFIG_RCU_FANOUT_LEAF=16
# CONFIG_RCU_FANOUT_EXACT is not set
# CONFIG_TREE_RCU_TRACE is not set
CONFIG_RCU_NOCB_CPU=y
# CONFIG_RCU_NOCB_CPU_NONE is not set
# CONFIG_RCU_NOCB_CPU_ZERO is not set
CONFIG_RCU_NOCB_CPU_ALL=y
CONFIG_IKCONFIG=y
# CONFIG_IKCONFIG_PROC is not set
CONFIG_LOG_BUF_SHIFT=17
CONFIG_HAVE_UNSTABLE_SCHED_CLOCK=y
CONFIG_ARCH_SUPPORTS_NUMA_BALANCING=y
CONFIG_ARCH_WANTS_PROT_NUMA_PROT_NONE=y
# CONFIG_CGROUPS is not set
CONFIG_CHECKPOINT_RESTORE=y
# CONFIG_NAMESPACES is not set
CONFIG_UIDGID_CONVERTED=y
CONFIG_UIDGID_STRICT_TYPE_CHECKS=y
# CONFIG_SCHED_AUTOGROUP is not set
# CONFIG_SYSFS_DEPRECATED is not set
# CONFIG_RELAY is not set
CONFIG_BLK_DEV_INITRD=y
CONFIG_INITRAMFS_SOURCE=""
CONFIG_RD_GZIP=y
# CONFIG_RD_BZIP2 is not set
# CONFIG_RD_LZMA is not set
# CONFIG_RD_XZ is not set
# CONFIG_RD_LZO is not set
CONFIG_CC_OPTIMIZE_FOR_SIZE=y
CONFIG_SYSCTL=y
CONFIG_ANON_INODES=y
CONFIG_HAVE_UID16=y
CONFIG_SYSCTL_EXCEPTION_TRACE=y
CONFIG_HOTPLUG=y
CONFIG_HAVE_PCSPKR_PLATFORM=y
CONFIG_EXPERT=y
CONFIG_UID16=y
CONFIG_SYSCTL_SYSCALL=y
CONFIG_KALLSYMS=y
CONFIG_KALLSYMS_ALL=y
CONFIG_PRINTK=y
CONFIG_BUG=y
# CONFIG_ELF_CORE is not set
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
CONFIG_EMBEDDED=y
CONFIG_HAVE_PERF_EVENTS=y

#
# Kernel Performance Events And Counters
#
CONFIG_PERF_EVENTS=y
# CONFIG_DEBUG_PERF_USE_VMALLOC is not set
CONFIG_VM_EVENT_COUNTERS=y
CONFIG_COMPAT_BRK=y
# CONFIG_SLAB is not set
# CONFIG_SLUB is not set
CONFIG_SLOB=y
CONFIG_PROFILING=y
CONFIG_TRACEPOINTS=y
CONFIG_OPROFILE=y
# CONFIG_OPROFILE_EVENT_MULTIPLEX is not set
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
CONFIG_HAVE_CMPXCHG_LOCAL=y
CONFIG_HAVE_CMPXCHG_DOUBLE=y
CONFIG_ARCH_WANT_IPC_PARSE_VERSION=y
CONFIG_HAVE_ARCH_SECCOMP_FILTER=y
CONFIG_HAVE_IRQ_TIME_ACCOUNTING=y
CONFIG_HAVE_ARCH_TRANSPARENT_HUGEPAGE=y
CONFIG_MODULES_USE_ELF_REL=y
CONFIG_CLONE_BACKWARDS=y
CONFIG_OLD_SIGSUSPEND3=y
CONFIG_OLD_SIGACTION=y

#
# GCOV-based kernel profiling
#
CONFIG_GCOV_KERNEL=y
# CONFIG_GCOV_PROFILE_ALL is not set
CONFIG_HAVE_GENERIC_DMA_COHERENT=y
CONFIG_RT_MUTEXES=y
CONFIG_BASE_SMALL=0
# CONFIG_MODULES is not set
CONFIG_STOP_MACHINE=y
# CONFIG_BLOCK is not set
CONFIG_PREEMPT_NOTIFIERS=y
CONFIG_PADATA=y
CONFIG_ASN1=y
CONFIG_UNINLINE_SPIN_UNLOCK=y
CONFIG_FREEZER=y

#
# Processor type and features
#
CONFIG_ZONE_DMA=y
CONFIG_SMP=y
# CONFIG_X86_MPPARSE is not set
CONFIG_X86_BIGSMP=y
CONFIG_GOLDFISH=y
CONFIG_X86_EXTENDED_PLATFORM=y
CONFIG_X86_GOLDFISH=y
CONFIG_X86_WANT_INTEL_MID=y
CONFIG_X86_INTEL_MID=y
CONFIG_X86_MDFLD=y
# CONFIG_X86_INTEL_LPSS is not set
# CONFIG_X86_RDC321X is not set
# CONFIG_X86_32_NON_STANDARD is not set
CONFIG_X86_SUPPORTS_MEMORY_FAILURE=y
# CONFIG_X86_32_IRIS is not set
# CONFIG_SCHED_OMIT_FRAME_POINTER is not set
CONFIG_HYPERVISOR_GUEST=y
CONFIG_PARAVIRT=y
CONFIG_PARAVIRT_DEBUG=y
CONFIG_PARAVIRT_SPINLOCKS=y
# CONFIG_XEN_PRIVILEGED_GUEST is not set
CONFIG_KVM_GUEST=y
# CONFIG_LGUEST_GUEST is not set
CONFIG_PARAVIRT_TIME_ACCOUNTING=y
CONFIG_PARAVIRT_CLOCK=y
CONFIG_NO_BOOTMEM=y
CONFIG_MEMTEST=y
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
CONFIG_APB_TIMER=y
# CONFIG_DMI is not set
CONFIG_NR_CPUS=32
CONFIG_SCHED_SMT=y
# CONFIG_SCHED_MC is not set
# CONFIG_PREEMPT_NONE is not set
CONFIG_PREEMPT_VOLUNTARY=y
# CONFIG_PREEMPT is not set
CONFIG_PREEMPT_COUNT=y
CONFIG_X86_LOCAL_APIC=y
CONFIG_X86_IO_APIC=y
CONFIG_X86_REROUTE_FOR_BROKEN_BOOT_IRQS=y
CONFIG_X86_MCE=y
CONFIG_X86_MCE_INTEL=y
CONFIG_X86_MCE_AMD=y
# CONFIG_X86_ANCIENT_MCE is not set
CONFIG_X86_MCE_THRESHOLD=y
CONFIG_X86_MCE_INJECT=y
CONFIG_X86_THERMAL_VECTOR=y
# CONFIG_VM86 is not set
CONFIG_TOSHIBA=y
CONFIG_I8K=y
CONFIG_X86_REBOOTFIXUPS=y
CONFIG_MICROCODE=y
# CONFIG_MICROCODE_INTEL is not set
CONFIG_MICROCODE_AMD=y
CONFIG_MICROCODE_OLD_INTERFACE=y
# CONFIG_MICROCODE_INTEL_EARLY is not set
CONFIG_MICROCODE_AMD_EARLY=y
CONFIG_MICROCODE_EARLY=y
CONFIG_X86_MSR=y
# CONFIG_X86_CPUID is not set
# CONFIG_NOHIGHMEM is not set
CONFIG_HIGHMEM4G=y
# CONFIG_HIGHMEM64G is not set
# CONFIG_VMSPLIT_3G is not set
# CONFIG_VMSPLIT_3G_OPT is not set
# CONFIG_VMSPLIT_2G is not set
CONFIG_VMSPLIT_2G_OPT=y
# CONFIG_VMSPLIT_1G is not set
CONFIG_PAGE_OFFSET=0x78000000
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
CONFIG_SPLIT_PTLOCK_CPUS=999999
CONFIG_BALLOON_COMPACTION=y
CONFIG_COMPACTION=y
CONFIG_MIGRATION=y
# CONFIG_PHYS_ADDR_T_64BIT is not set
CONFIG_ZONE_DMA_FLAG=1
CONFIG_VIRT_TO_BUS=y
CONFIG_MMU_NOTIFIER=y
# CONFIG_KSM is not set
CONFIG_DEFAULT_MMAP_MIN_ADDR=4096
CONFIG_ARCH_SUPPORTS_MEMORY_FAILURE=y
CONFIG_MEMORY_FAILURE=y
CONFIG_HWPOISON_INJECT=y
# CONFIG_TRANSPARENT_HUGEPAGE is not set
CONFIG_CROSS_MEMORY_ATTACH=y
# CONFIG_CLEANCACHE is not set
CONFIG_HIGHPTE=y
CONFIG_X86_CHECK_BIOS_CORRUPTION=y
# CONFIG_X86_BOOTPARAM_MEMORY_CORRUPTION_CHECK is not set
CONFIG_X86_RESERVE_LOW=64
CONFIG_MATH_EMULATION=y
# CONFIG_MTRR is not set
CONFIG_ARCH_RANDOM=y
# CONFIG_X86_SMAP is not set
# CONFIG_EFI is not set
# CONFIG_SECCOMP is not set
# CONFIG_CC_STACKPROTECTOR is not set
CONFIG_HZ_100=y
# CONFIG_HZ_250 is not set
# CONFIG_HZ_300 is not set
# CONFIG_HZ_1000 is not set
CONFIG_HZ=100
CONFIG_SCHED_HRTICK=y
CONFIG_KEXEC=y
CONFIG_CRASH_DUMP=y
CONFIG_PHYSICAL_START=0x1000000
# CONFIG_RELOCATABLE is not set
CONFIG_PHYSICAL_ALIGN=0x1000000
CONFIG_HOTPLUG_CPU=y
CONFIG_BOOTPARAM_HOTPLUG_CPU0=y
# CONFIG_DEBUG_HOTPLUG_CPU0 is not set
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
# CONFIG_PM_AUTOSLEEP is not set
CONFIG_PM_WAKELOCKS=y
CONFIG_PM_WAKELOCKS_LIMIT=100
# CONFIG_PM_WAKELOCKS_GC is not set
CONFIG_PM_RUNTIME=y
CONFIG_PM=y
# CONFIG_PM_DEBUG is not set
CONFIG_ACPI=y
CONFIG_ACPI_SLEEP=y
# CONFIG_ACPI_PROCFS is not set
# CONFIG_ACPI_PROCFS_POWER is not set
# CONFIG_ACPI_EC_DEBUGFS is not set
CONFIG_ACPI_PROC_EVENT=y
CONFIG_ACPI_AC=y
CONFIG_ACPI_BATTERY=y
CONFIG_ACPI_BUTTON=y
CONFIG_ACPI_VIDEO=y
CONFIG_ACPI_FAN=y
# CONFIG_ACPI_DOCK is not set
CONFIG_ACPI_I2C=y
CONFIG_ACPI_PROCESSOR=y
# CONFIG_ACPI_IPMI is not set
CONFIG_ACPI_HOTPLUG_CPU=y
# CONFIG_ACPI_PROCESSOR_AGGREGATOR is not set
CONFIG_ACPI_THERMAL=y
# CONFIG_ACPI_CUSTOM_DSDT is not set
# CONFIG_ACPI_INITRD_TABLE_OVERRIDE is not set
CONFIG_ACPI_BLACKLIST_YEAR=0
# CONFIG_ACPI_DEBUG is not set
# CONFIG_ACPI_PCI_SLOT is not set
CONFIG_X86_PM_TIMER=y
CONFIG_ACPI_CONTAINER=y
# CONFIG_ACPI_SBS is not set
# CONFIG_ACPI_HED is not set
# CONFIG_ACPI_CUSTOM_METHOD is not set
# CONFIG_ACPI_IPMI_TEST is not set
# CONFIG_ACPI_APEI is not set
CONFIG_SFI=y
CONFIG_X86_APM_BOOT=y
CONFIG_APM=y
CONFIG_APM_IGNORE_USER_SUSPEND=y
CONFIG_APM_DO_ENABLE=y
# CONFIG_APM_CPU_IDLE is not set
CONFIG_APM_DISPLAY_BLANK=y
CONFIG_APM_ALLOW_INTS=y

#
# CPU Frequency scaling
#
# CONFIG_CPU_FREQ is not set
CONFIG_CPU_IDLE=y
# CONFIG_CPU_IDLE_MULTIPLE_DRIVERS is not set
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
CONFIG_PCI_CNB20LE_QUIRK=y
# CONFIG_PCIEPORTBUS is not set
CONFIG_ARCH_SUPPORTS_MSI=y
CONFIG_PCI_MSI=y
# CONFIG_PCI_DEBUG is not set
# CONFIG_PCI_REALLOC_ENABLE_AUTO is not set
# CONFIG_PCI_STUB is not set
CONFIG_HT_IRQ=y
CONFIG_PCI_ATS=y
CONFIG_PCI_IOV=y
# CONFIG_PCI_PRI is not set
CONFIG_PCI_PASID=y
# CONFIG_PCI_IOAPIC is not set
CONFIG_PCI_LABEL=y
CONFIG_ISA_DMA_API=y
# CONFIG_ISA is not set
# CONFIG_SCx200 is not set
# CONFIG_OLPC is not set
# CONFIG_ALIX is not set
# CONFIG_NET5501 is not set
CONFIG_AMD_NB=y
CONFIG_PCCARD=y
CONFIG_PCMCIA=y
CONFIG_PCMCIA_LOAD_CIS=y
# CONFIG_CARDBUS is not set

#
# PC-card bridges
#
CONFIG_YENTA=y
# CONFIG_YENTA_O2 is not set
# CONFIG_YENTA_RICOH is not set
CONFIG_YENTA_TI=y
CONFIG_YENTA_TOSHIBA=y
# CONFIG_PD6729 is not set
CONFIG_I82092=y
CONFIG_PCCARD_NONSTATIC=y
CONFIG_HOTPLUG_PCI=y
CONFIG_HOTPLUG_PCI_COMPAQ=y
CONFIG_HOTPLUG_PCI_COMPAQ_NVRAM=y
CONFIG_HOTPLUG_PCI_IBM=y
# CONFIG_HOTPLUG_PCI_ACPI is not set
# CONFIG_HOTPLUG_PCI_CPCI is not set
CONFIG_HOTPLUG_PCI_SHPC=y
# CONFIG_RAPIDIO is not set

#
# Executable file formats / Emulations
#
CONFIG_BINFMT_ELF=y
CONFIG_ARCH_BINFMT_ELF_RANDOMIZE_PIE=y
# CONFIG_BINFMT_SCRIPT is not set
CONFIG_HAVE_AOUT=y
CONFIG_BINFMT_AOUT=y
CONFIG_BINFMT_MISC=y
CONFIG_COREDUMP=y
CONFIG_HAVE_ATOMIC_IOMAP=y
CONFIG_HAVE_TEXT_POKE_SMP=y
CONFIG_NET=y

#
# Networking options
#
# CONFIG_PACKET is not set
CONFIG_UNIX=y
CONFIG_UNIX_DIAG=y
CONFIG_XFRM=y
CONFIG_XFRM_ALGO=y
# CONFIG_XFRM_USER is not set
# CONFIG_XFRM_SUB_POLICY is not set
CONFIG_XFRM_MIGRATE=y
# CONFIG_XFRM_STATISTICS is not set
CONFIG_XFRM_IPCOMP=y
CONFIG_NET_KEY=y
CONFIG_NET_KEY_MIGRATE=y
CONFIG_INET=y
CONFIG_IP_MULTICAST=y
CONFIG_IP_ADVANCED_ROUTER=y
CONFIG_IP_FIB_TRIE_STATS=y
CONFIG_IP_MULTIPLE_TABLES=y
# CONFIG_IP_ROUTE_MULTIPATH is not set
# CONFIG_IP_ROUTE_VERBOSE is not set
CONFIG_IP_ROUTE_CLASSID=y
CONFIG_IP_PNP=y
# CONFIG_IP_PNP_DHCP is not set
CONFIG_IP_PNP_BOOTP=y
CONFIG_IP_PNP_RARP=y
# CONFIG_NET_IPIP is not set
CONFIG_NET_IPGRE_DEMUX=y
CONFIG_NET_IP_TUNNEL=y
CONFIG_NET_IPGRE=y
CONFIG_NET_IPGRE_BROADCAST=y
# CONFIG_IP_MROUTE is not set
# CONFIG_ARPD is not set
# CONFIG_SYN_COOKIES is not set
# CONFIG_NET_IPVTI is not set
CONFIG_INET_AH=y
# CONFIG_INET_ESP is not set
CONFIG_INET_IPCOMP=y
CONFIG_INET_XFRM_TUNNEL=y
CONFIG_INET_TUNNEL=y
CONFIG_INET_XFRM_MODE_TRANSPORT=y
CONFIG_INET_XFRM_MODE_TUNNEL=y
CONFIG_INET_XFRM_MODE_BEET=y
CONFIG_INET_LRO=y
CONFIG_INET_DIAG=y
CONFIG_INET_TCP_DIAG=y
CONFIG_INET_UDP_DIAG=y
CONFIG_TCP_CONG_ADVANCED=y
CONFIG_TCP_CONG_BIC=y
CONFIG_TCP_CONG_CUBIC=y
CONFIG_TCP_CONG_WESTWOOD=y
CONFIG_TCP_CONG_HTCP=y
# CONFIG_TCP_CONG_HSTCP is not set
CONFIG_TCP_CONG_HYBLA=y
CONFIG_TCP_CONG_VEGAS=y
# CONFIG_TCP_CONG_SCALABLE is not set
CONFIG_TCP_CONG_LP=y
CONFIG_TCP_CONG_VENO=y
# CONFIG_TCP_CONG_YEAH is not set
CONFIG_TCP_CONG_ILLINOIS=y
# CONFIG_DEFAULT_BIC is not set
# CONFIG_DEFAULT_CUBIC is not set
# CONFIG_DEFAULT_HTCP is not set
CONFIG_DEFAULT_HYBLA=y
# CONFIG_DEFAULT_VEGAS is not set
# CONFIG_DEFAULT_VENO is not set
# CONFIG_DEFAULT_WESTWOOD is not set
# CONFIG_DEFAULT_RENO is not set
CONFIG_DEFAULT_TCP_CONG="hybla"
CONFIG_TCP_MD5SIG=y
CONFIG_IPV6=y
# CONFIG_IPV6_PRIVACY is not set
# CONFIG_IPV6_ROUTER_PREF is not set
CONFIG_IPV6_OPTIMISTIC_DAD=y
CONFIG_INET6_AH=y
CONFIG_INET6_ESP=y
# CONFIG_INET6_IPCOMP is not set
CONFIG_IPV6_MIP6=y
# CONFIG_INET6_XFRM_TUNNEL is not set
# CONFIG_INET6_TUNNEL is not set
CONFIG_INET6_XFRM_MODE_TRANSPORT=y
CONFIG_INET6_XFRM_MODE_TUNNEL=y
CONFIG_INET6_XFRM_MODE_BEET=y
CONFIG_INET6_XFRM_MODE_ROUTEOPTIMIZATION=y
# CONFIG_IPV6_SIT is not set
# CONFIG_IPV6_TUNNEL is not set
# CONFIG_IPV6_GRE is not set
# CONFIG_IPV6_MULTIPLE_TABLES is not set
# CONFIG_IPV6_MROUTE is not set
CONFIG_NETLABEL=y
CONFIG_NETWORK_SECMARK=y
# CONFIG_NETWORK_PHY_TIMESTAMPING is not set
# CONFIG_NETFILTER is not set
CONFIG_IP_DCCP=y
CONFIG_INET_DCCP_DIAG=y

#
# DCCP CCIDs Configuration
#
CONFIG_IP_DCCP_CCID2_DEBUG=y
# CONFIG_IP_DCCP_CCID3 is not set

#
# DCCP Kernel Hacking
#
CONFIG_IP_DCCP_DEBUG=y
CONFIG_IP_SCTP=y
CONFIG_SCTP_DBG_MSG=y
CONFIG_SCTP_DBG_OBJCNT=y
# CONFIG_SCTP_DEFAULT_COOKIE_HMAC_MD5 is not set
CONFIG_SCTP_DEFAULT_COOKIE_HMAC_SHA1=y
# CONFIG_SCTP_DEFAULT_COOKIE_HMAC_NONE is not set
CONFIG_SCTP_COOKIE_HMAC_MD5=y
CONFIG_SCTP_COOKIE_HMAC_SHA1=y
CONFIG_RDS=y
CONFIG_RDS_RDMA=y
# CONFIG_RDS_TCP is not set
# CONFIG_RDS_DEBUG is not set
CONFIG_TIPC=y
CONFIG_TIPC_PORTS=8191
# CONFIG_ATM is not set
# CONFIG_L2TP is not set
CONFIG_STP=y
CONFIG_BRIDGE=y
# CONFIG_BRIDGE_IGMP_SNOOPING is not set
# CONFIG_VLAN_8021Q is not set
CONFIG_DECNET=y
# CONFIG_DECNET_ROUTER is not set
CONFIG_LLC=y
# CONFIG_LLC2 is not set
CONFIG_IPX=y
CONFIG_IPX_INTERN=y
# CONFIG_ATALK is not set
# CONFIG_X25 is not set
CONFIG_LAPB=y
# CONFIG_PHONET is not set
CONFIG_IEEE802154=y
CONFIG_IEEE802154_6LOWPAN=y
CONFIG_MAC802154=y
CONFIG_NET_SCHED=y

#
# Queueing/Scheduling
#
# CONFIG_NET_SCH_CBQ is not set
CONFIG_NET_SCH_HTB=y
CONFIG_NET_SCH_HFSC=y
CONFIG_NET_SCH_PRIO=y
CONFIG_NET_SCH_MULTIQ=y
CONFIG_NET_SCH_RED=y
CONFIG_NET_SCH_SFB=y
CONFIG_NET_SCH_SFQ=y
# CONFIG_NET_SCH_TEQL is not set
# CONFIG_NET_SCH_TBF is not set
CONFIG_NET_SCH_GRED=y
CONFIG_NET_SCH_DSMARK=y
CONFIG_NET_SCH_NETEM=y
CONFIG_NET_SCH_DRR=y
CONFIG_NET_SCH_MQPRIO=y
CONFIG_NET_SCH_CHOKE=y
# CONFIG_NET_SCH_QFQ is not set
CONFIG_NET_SCH_CODEL=y
# CONFIG_NET_SCH_FQ_CODEL is not set
# CONFIG_NET_SCH_PLUG is not set

#
# Classification
#
CONFIG_NET_CLS=y
CONFIG_NET_CLS_BASIC=y
# CONFIG_NET_CLS_TCINDEX is not set
CONFIG_NET_CLS_ROUTE4=y
# CONFIG_NET_CLS_FW is not set
# CONFIG_NET_CLS_U32 is not set
CONFIG_NET_CLS_RSVP=y
CONFIG_NET_CLS_RSVP6=y
CONFIG_NET_CLS_FLOW=y
# CONFIG_NET_EMATCH is not set
# CONFIG_NET_CLS_ACT is not set
CONFIG_NET_SCH_FIFO=y
CONFIG_DCB=y
# CONFIG_DNS_RESOLVER is not set
CONFIG_BATMAN_ADV=y
# CONFIG_BATMAN_ADV_BLA is not set
CONFIG_BATMAN_ADV_DAT=y
# CONFIG_BATMAN_ADV_NC is not set
# CONFIG_BATMAN_ADV_DEBUG is not set
CONFIG_OPENVSWITCH=y
# CONFIG_VSOCKETS is not set
CONFIG_NETLINK_MMAP=y
CONFIG_NETLINK_DIAG=y
CONFIG_RPS=y
CONFIG_RFS_ACCEL=y
CONFIG_XPS=y
CONFIG_BQL=y

#
# Network testing
#
CONFIG_NET_PKTGEN=y
# CONFIG_NET_DROP_MONITOR is not set
# CONFIG_HAMRADIO is not set
CONFIG_CAN=y
# CONFIG_CAN_RAW is not set
CONFIG_CAN_BCM=y
# CONFIG_CAN_GW is not set

#
# CAN Device Drivers
#
CONFIG_CAN_VCAN=y
# CONFIG_CAN_SLCAN is not set
CONFIG_CAN_DEV=y
CONFIG_CAN_CALC_BITTIMING=y
CONFIG_CAN_LEDS=y
CONFIG_CAN_MCP251X=y
CONFIG_CAN_JANZ_ICAN3=y
CONFIG_PCH_CAN=y
CONFIG_CAN_SJA1000=y
CONFIG_CAN_SJA1000_ISA=y
CONFIG_CAN_SJA1000_PLATFORM=y
CONFIG_CAN_EMS_PCMCIA=y
# CONFIG_CAN_EMS_PCI is not set
CONFIG_CAN_PEAK_PCMCIA=y
CONFIG_CAN_PEAK_PCI=y
CONFIG_CAN_PEAK_PCIEC=y
# CONFIG_CAN_KVASER_PCI is not set
CONFIG_CAN_PLX_PCI=y
CONFIG_CAN_C_CAN=y
# CONFIG_CAN_C_CAN_PLATFORM is not set
# CONFIG_CAN_C_CAN_PCI is not set
CONFIG_CAN_CC770=y
# CONFIG_CAN_CC770_ISA is not set
CONFIG_CAN_CC770_PLATFORM=y

#
# CAN USB interfaces
#
# CONFIG_CAN_EMS_USB is not set
# CONFIG_CAN_ESD_USB2 is not set
CONFIG_CAN_KVASER_USB=y
CONFIG_CAN_PEAK_USB=y
CONFIG_CAN_8DEV_USB=y
# CONFIG_CAN_SOFTING is not set
# CONFIG_CAN_DEBUG_DEVICES is not set
CONFIG_IRDA=y

#
# IrDA protocols
#
CONFIG_IRLAN=y
# CONFIG_IRCOMM is not set
# CONFIG_IRDA_ULTRA is not set

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
CONFIG_KINGSUN_DONGLE=y
CONFIG_KSDAZZLE_DONGLE=y
# CONFIG_KS959_DONGLE is not set

#
# FIR device drivers
#
# CONFIG_USB_IRDA is not set
CONFIG_SIGMATEL_FIR=y
CONFIG_NSC_FIR=y
CONFIG_WINBOND_FIR=y
CONFIG_TOSHIBA_FIR=y
# CONFIG_SMC_IRCC_FIR is not set
CONFIG_ALI_FIR=y
CONFIG_VLSI_FIR=y
CONFIG_VIA_FIR=y
# CONFIG_MCS_FIR is not set
CONFIG_BT=y
CONFIG_BT_RFCOMM=y
# CONFIG_BT_RFCOMM_TTY is not set
# CONFIG_BT_BNEP is not set
CONFIG_BT_HIDP=y

#
# Bluetooth device drivers
#
CONFIG_BT_HCIBTUSB=y
CONFIG_BT_HCIBTSDIO=y
# CONFIG_BT_HCIUART is not set
CONFIG_BT_HCIBCM203X=y
CONFIG_BT_HCIBPA10X=y
# CONFIG_BT_HCIBFUSB is not set
CONFIG_BT_HCIDTL1=y
# CONFIG_BT_HCIBT3C is not set
CONFIG_BT_HCIBLUECARD=y
CONFIG_BT_HCIBTUART=y
CONFIG_BT_HCIVHCI=y
# CONFIG_BT_MRVL is not set
CONFIG_BT_ATH3K=y
CONFIG_AF_RXRPC=y
# CONFIG_AF_RXRPC_DEBUG is not set
# CONFIG_RXKAD is not set
CONFIG_FIB_RULES=y
CONFIG_WIRELESS=y
CONFIG_CFG80211=y
# CONFIG_NL80211_TESTMODE is not set
# CONFIG_CFG80211_DEVELOPER_WARNINGS is not set
# CONFIG_CFG80211_REG_DEBUG is not set
CONFIG_CFG80211_CERTIFICATION_ONUS=y
CONFIG_CFG80211_DEFAULT_PS=y
CONFIG_CFG80211_DEBUGFS=y
# CONFIG_CFG80211_INTERNAL_REGDB is not set
# CONFIG_CFG80211_WEXT is not set
# CONFIG_LIB80211 is not set
CONFIG_MAC80211=y
# CONFIG_MAC80211_RC_PID is not set
# CONFIG_MAC80211_RC_MINSTREL is not set
CONFIG_MAC80211_RC_DEFAULT=""

#
# Some wireless drivers require a rate control algorithm
#
CONFIG_MAC80211_MESH=y
# CONFIG_MAC80211_LEDS is not set
CONFIG_MAC80211_DEBUGFS=y
# CONFIG_MAC80211_MESSAGE_TRACING is not set
CONFIG_MAC80211_DEBUG_MENU=y
# CONFIG_MAC80211_NOINLINE is not set
CONFIG_MAC80211_VERBOSE_DEBUG=y
# CONFIG_MAC80211_MLME_DEBUG is not set
# CONFIG_MAC80211_STA_DEBUG is not set
# CONFIG_MAC80211_HT_DEBUG is not set
# CONFIG_MAC80211_IBSS_DEBUG is not set
# CONFIG_MAC80211_PS_DEBUG is not set
# CONFIG_MAC80211_MPL_DEBUG is not set
# CONFIG_MAC80211_MPATH_DEBUG is not set
CONFIG_MAC80211_MHWMP_DEBUG=y
# CONFIG_MAC80211_MESH_SYNC_DEBUG is not set
# CONFIG_MAC80211_MESH_PS_DEBUG is not set
# CONFIG_MAC80211_TDLS_DEBUG is not set
# CONFIG_MAC80211_DEBUG_COUNTERS is not set
# CONFIG_WIMAX is not set
CONFIG_RFKILL=y
CONFIG_RFKILL_LEDS=y
# CONFIG_RFKILL_INPUT is not set
# CONFIG_NET_9P is not set
CONFIG_CAIF=y
# CONFIG_CAIF_DEBUG is not set
CONFIG_CAIF_NETDEV=y
# CONFIG_CAIF_USB is not set
CONFIG_CEPH_LIB=y
# CONFIG_CEPH_LIB_PRETTYDEBUG is not set
# CONFIG_CEPH_LIB_USE_DNS_RESOLVER is not set
CONFIG_NFC=y
# CONFIG_NFC_NCI is not set
CONFIG_NFC_HCI=y
# CONFIG_NFC_SHDLC is not set

#
# Near Field Communication (NFC) devices
#
# CONFIG_NFC_PN533 is not set
CONFIG_NFC_SIM=y
CONFIG_NFC_PN544=y
CONFIG_NFC_MICROREAD=y

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
CONFIG_FENCE_TRACE=y
# CONFIG_CMA is not set

#
# Bus devices
#
CONFIG_CONNECTOR=y
CONFIG_PROC_EVENTS=y
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
CONFIG_MTD_OOPS=y

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
CONFIG_MTD_CFI_STAA=y
CONFIG_MTD_CFI_UTIL=y
CONFIG_MTD_RAM=y
CONFIG_MTD_ROM=y
CONFIG_MTD_ABSENT=y

#
# Mapping drivers for chip access
#
CONFIG_MTD_COMPLEX_MAPPINGS=y
# CONFIG_MTD_PHYSMAP is not set
CONFIG_MTD_SC520CDP=y
CONFIG_MTD_NETSC520=y
CONFIG_MTD_TS5500=y
CONFIG_MTD_SBC_GXX=y
CONFIG_MTD_AMD76XROM=y
CONFIG_MTD_ICHXROM=y
# CONFIG_MTD_ESB2ROM is not set
CONFIG_MTD_CK804XROM=y
CONFIG_MTD_SCB2_FLASH=y
# CONFIG_MTD_NETtel is not set
# CONFIG_MTD_L440GX is not set
CONFIG_MTD_PCI=y
# CONFIG_MTD_PCMCIA is not set
# CONFIG_MTD_INTEL_VR_NOR is not set
CONFIG_MTD_PLATRAM=y
CONFIG_MTD_LATCH_ADDR=y

#
# Self-contained MTD device drivers
#
CONFIG_MTD_PMC551=y
# CONFIG_MTD_PMC551_BUGFIX is not set
# CONFIG_MTD_PMC551_DEBUG is not set
CONFIG_MTD_DATAFLASH=y
CONFIG_MTD_DATAFLASH_WRITE_VERIFY=y
CONFIG_MTD_DATAFLASH_OTP=y
# CONFIG_MTD_M25P80 is not set
CONFIG_MTD_SST25L=y
CONFIG_MTD_SLRAM=y
CONFIG_MTD_PHRAM=y
# CONFIG_MTD_MTDRAM is not set

#
# Disk-On-Chip Device Drivers
#
CONFIG_MTD_DOCG3=y
CONFIG_BCH_CONST_M=14
CONFIG_BCH_CONST_T=4
CONFIG_MTD_NAND_ECC=y
# CONFIG_MTD_NAND_ECC_SMC is not set
CONFIG_MTD_NAND=y
# CONFIG_MTD_NAND_ECC_BCH is not set
CONFIG_MTD_SM_COMMON=y
CONFIG_MTD_NAND_DENALI=y
CONFIG_MTD_NAND_DENALI_PCI=y
CONFIG_MTD_NAND_DENALI_SCRATCH_REG_ADDR=0xFF108018
CONFIG_MTD_NAND_IDS=y
CONFIG_MTD_NAND_RICOH=y
CONFIG_MTD_NAND_DISKONCHIP=y
CONFIG_MTD_NAND_DISKONCHIP_PROBE_ADVANCED=y
CONFIG_MTD_NAND_DISKONCHIP_PROBE_ADDRESS=0
CONFIG_MTD_NAND_DISKONCHIP_PROBE_HIGH=y
# CONFIG_MTD_NAND_DISKONCHIP_BBTWRITE is not set
CONFIG_MTD_NAND_DOCG4=y
# CONFIG_MTD_NAND_CAFE is not set
CONFIG_MTD_NAND_CS553X=y
CONFIG_MTD_NAND_NANDSIM=y
CONFIG_MTD_NAND_PLATFORM=y
# CONFIG_MTD_ALAUDA is not set
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
# CONFIG_MTD_UBI is not set
# CONFIG_PARPORT is not set
CONFIG_PNP=y
CONFIG_PNP_DEBUG_MESSAGES=y

#
# Protocols
#
CONFIG_PNPACPI=y

#
# Misc devices
#
# CONFIG_SENSORS_LIS3LV02D is not set
CONFIG_AD525X_DPOT=y
CONFIG_AD525X_DPOT_I2C=y
CONFIG_AD525X_DPOT_SPI=y
CONFIG_DUMMY_IRQ=y
CONFIG_IBM_ASM=y
# CONFIG_PHANTOM is not set
# CONFIG_INTEL_MID_PTI is not set
CONFIG_SGI_IOC4=y
CONFIG_TIFM_CORE=y
CONFIG_TIFM_7XX1=y
# CONFIG_ICS932S401 is not set
CONFIG_ATMEL_SSC=y
# CONFIG_ENCLOSURE_SERVICES is not set
# CONFIG_HP_ILO is not set
# CONFIG_APDS9802ALS is not set
# CONFIG_ISL29003 is not set
# CONFIG_ISL29020 is not set
CONFIG_SENSORS_TSL2550=y
CONFIG_SENSORS_BH1780=y
# CONFIG_SENSORS_BH1770 is not set
# CONFIG_SENSORS_APDS990X is not set
CONFIG_HMC6352=y
CONFIG_DS1682=y
# CONFIG_TI_DAC7512 is not set
# CONFIG_VMWARE_BALLOON is not set
CONFIG_BMP085=y
CONFIG_BMP085_I2C=y
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
CONFIG_EEPROM_AT24=y
CONFIG_EEPROM_AT25=y
CONFIG_EEPROM_LEGACY=y
CONFIG_EEPROM_MAX6875=y
CONFIG_EEPROM_93CX6=y
CONFIG_EEPROM_93XX46=y
CONFIG_CB710_CORE=y
CONFIG_CB710_DEBUG=y
CONFIG_CB710_DEBUG_ASSUMPTIONS=y

#
# Texas Instruments shared transport line discipline
#
# CONFIG_SENSORS_LIS3_I2C is not set

#
# Altera FPGA firmware download module
#
# CONFIG_ALTERA_STAPL is not set
CONFIG_VMWARE_VMCI=y
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
CONFIG_FIREWIRE=y
# CONFIG_FIREWIRE_OHCI is not set
CONFIG_FIREWIRE_NET=y
CONFIG_FIREWIRE_NOSY=y
# CONFIG_I2O is not set
CONFIG_MACINTOSH_DRIVERS=y
CONFIG_MAC_EMUMOUSEBTN=y
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
# CONFIG_INPUT_JOYDEV is not set
# CONFIG_INPUT_EVDEV is not set
CONFIG_INPUT_EVBUG=y

#
# Input Device Drivers
#
CONFIG_INPUT_KEYBOARD=y
# CONFIG_KEYBOARD_ADP5520 is not set
# CONFIG_KEYBOARD_ADP5588 is not set
CONFIG_KEYBOARD_ADP5589=y
CONFIG_KEYBOARD_ATKBD=y
CONFIG_KEYBOARD_QT1070=y
CONFIG_KEYBOARD_QT2160=y
CONFIG_KEYBOARD_LKKBD=y
CONFIG_KEYBOARD_TCA6416=y
CONFIG_KEYBOARD_TCA8418=y
CONFIG_KEYBOARD_LM8323=y
CONFIG_KEYBOARD_LM8333=y
# CONFIG_KEYBOARD_MAX7359 is not set
# CONFIG_KEYBOARD_MCS is not set
CONFIG_KEYBOARD_MPR121=y
# CONFIG_KEYBOARD_NEWTON is not set
# CONFIG_KEYBOARD_OPENCORES is not set
CONFIG_KEYBOARD_GOLDFISH_EVENTS=y
CONFIG_KEYBOARD_STOWAWAY=y
CONFIG_KEYBOARD_SUNKBD=y
CONFIG_KEYBOARD_XTKBD=y
# CONFIG_INPUT_MOUSE is not set
CONFIG_INPUT_JOYSTICK=y
# CONFIG_JOYSTICK_ANALOG is not set
# CONFIG_JOYSTICK_A3D is not set
CONFIG_JOYSTICK_ADI=y
CONFIG_JOYSTICK_COBRA=y
CONFIG_JOYSTICK_GF2K=y
CONFIG_JOYSTICK_GRIP=y
# CONFIG_JOYSTICK_GRIP_MP is not set
CONFIG_JOYSTICK_GUILLEMOT=y
CONFIG_JOYSTICK_INTERACT=y
CONFIG_JOYSTICK_SIDEWINDER=y
CONFIG_JOYSTICK_TMDC=y
CONFIG_JOYSTICK_IFORCE=y
# CONFIG_JOYSTICK_IFORCE_USB is not set
CONFIG_JOYSTICK_IFORCE_232=y
CONFIG_JOYSTICK_WARRIOR=y
CONFIG_JOYSTICK_MAGELLAN=y
# CONFIG_JOYSTICK_SPACEORB is not set
CONFIG_JOYSTICK_SPACEBALL=y
CONFIG_JOYSTICK_STINGER=y
CONFIG_JOYSTICK_TWIDJOY=y
CONFIG_JOYSTICK_ZHENHUA=y
CONFIG_JOYSTICK_AS5011=y
CONFIG_JOYSTICK_JOYDUMP=y
CONFIG_JOYSTICK_XPAD=y
CONFIG_JOYSTICK_XPAD_FF=y
CONFIG_JOYSTICK_XPAD_LEDS=y
CONFIG_INPUT_TABLET=y
CONFIG_TABLET_USB_ACECAD=y
CONFIG_TABLET_USB_AIPTEK=y
CONFIG_TABLET_USB_GTCO=y
CONFIG_TABLET_USB_HANWANG=y
CONFIG_TABLET_USB_KBTAB=y
CONFIG_TABLET_USB_WACOM=y
CONFIG_INPUT_TOUCHSCREEN=y
CONFIG_TOUCHSCREEN_88PM860X=y
CONFIG_TOUCHSCREEN_ADS7846=y
CONFIG_TOUCHSCREEN_AD7877=y
# CONFIG_TOUCHSCREEN_AD7879 is not set
CONFIG_TOUCHSCREEN_ATMEL_MXT=y
CONFIG_TOUCHSCREEN_BU21013=y
# CONFIG_TOUCHSCREEN_CYTTSP_CORE is not set
CONFIG_TOUCHSCREEN_DA9052=y
# CONFIG_TOUCHSCREEN_DYNAPRO is not set
CONFIG_TOUCHSCREEN_HAMPSHIRE=y
CONFIG_TOUCHSCREEN_EETI=y
CONFIG_TOUCHSCREEN_FUJITSU=y
CONFIG_TOUCHSCREEN_ILI210X=y
CONFIG_TOUCHSCREEN_GUNZE=y
# CONFIG_TOUCHSCREEN_ELO is not set
# CONFIG_TOUCHSCREEN_WACOM_W8001 is not set
CONFIG_TOUCHSCREEN_WACOM_I2C=y
CONFIG_TOUCHSCREEN_MAX11801=y
CONFIG_TOUCHSCREEN_MCS5000=y
CONFIG_TOUCHSCREEN_MMS114=y
CONFIG_TOUCHSCREEN_MTOUCH=y
CONFIG_TOUCHSCREEN_INEXIO=y
# CONFIG_TOUCHSCREEN_INTEL_MID is not set
CONFIG_TOUCHSCREEN_MK712=y
CONFIG_TOUCHSCREEN_PENMOUNT=y
# CONFIG_TOUCHSCREEN_EDT_FT5X06 is not set
CONFIG_TOUCHSCREEN_TOUCHRIGHT=y
CONFIG_TOUCHSCREEN_TOUCHWIN=y
CONFIG_TOUCHSCREEN_TI_AM335X_TSC=y
CONFIG_TOUCHSCREEN_PIXCIR=y
CONFIG_TOUCHSCREEN_WM831X=y
CONFIG_TOUCHSCREEN_USB_COMPOSITE=y
CONFIG_TOUCHSCREEN_MC13783=y
# CONFIG_TOUCHSCREEN_USB_EGALAX is not set
CONFIG_TOUCHSCREEN_USB_PANJIT=y
# CONFIG_TOUCHSCREEN_USB_3M is not set
CONFIG_TOUCHSCREEN_USB_ITM=y
# CONFIG_TOUCHSCREEN_USB_ETURBO is not set
# CONFIG_TOUCHSCREEN_USB_GUNZE is not set
CONFIG_TOUCHSCREEN_USB_DMC_TSC10=y
# CONFIG_TOUCHSCREEN_USB_IRTOUCH is not set
# CONFIG_TOUCHSCREEN_USB_IDEALTEK is not set
# CONFIG_TOUCHSCREEN_USB_GENERAL_TOUCH is not set
CONFIG_TOUCHSCREEN_USB_GOTOP=y
CONFIG_TOUCHSCREEN_USB_JASTEC=y
# CONFIG_TOUCHSCREEN_USB_ELO is not set
CONFIG_TOUCHSCREEN_USB_E2I=y
# CONFIG_TOUCHSCREEN_USB_ZYTRONIC is not set
# CONFIG_TOUCHSCREEN_USB_ETT_TC45USB is not set
CONFIG_TOUCHSCREEN_USB_NEXIO=y
# CONFIG_TOUCHSCREEN_USB_EASYTOUCH is not set
# CONFIG_TOUCHSCREEN_TOUCHIT213 is not set
# CONFIG_TOUCHSCREEN_TSC_SERIO is not set
CONFIG_TOUCHSCREEN_TSC2005=y
CONFIG_TOUCHSCREEN_TSC2007=y
CONFIG_TOUCHSCREEN_ST1232=y
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
# CONFIG_SERIO_PS2MULT is not set
CONFIG_SERIO_ARC_PS2=y
CONFIG_GAMEPORT=y
CONFIG_GAMEPORT_NS558=y
# CONFIG_GAMEPORT_L4 is not set
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
# CONFIG_GOLDFISH_TTY is not set
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
# CONFIG_SERIAL_MAX3100 is not set
# CONFIG_SERIAL_MAX310X is not set
# CONFIG_SERIAL_MFD_HSU is not set
CONFIG_SERIAL_CORE=y
CONFIG_SERIAL_CORE_CONSOLE=y
# CONFIG_SERIAL_JSM is not set
# CONFIG_SERIAL_SCCNXP is not set
# CONFIG_SERIAL_TIMBERDALE is not set
# CONFIG_SERIAL_ALTERA_JTAGUART is not set
# CONFIG_SERIAL_ALTERA_UART is not set
# CONFIG_SERIAL_PCH_UART is not set
# CONFIG_SERIAL_ARC is not set
# CONFIG_SERIAL_RP2 is not set
# CONFIG_TTY_PRINTK is not set
# CONFIG_VIRTIO_CONSOLE is not set
CONFIG_IPMI_HANDLER=y
# CONFIG_IPMI_PANIC_EVENT is not set
CONFIG_IPMI_DEVICE_INTERFACE=y
CONFIG_IPMI_SI=y
CONFIG_IPMI_WATCHDOG=y
CONFIG_IPMI_POWEROFF=y
CONFIG_HW_RANDOM=y
CONFIG_HW_RANDOM_TIMERIOMEM=y
CONFIG_HW_RANDOM_INTEL=y
CONFIG_HW_RANDOM_AMD=y
CONFIG_HW_RANDOM_GEODE=y
# CONFIG_HW_RANDOM_VIA is not set
CONFIG_HW_RANDOM_VIRTIO=y
CONFIG_HW_RANDOM_TPM=y
CONFIG_NVRAM=y
# CONFIG_R3964 is not set
# CONFIG_APPLICOM is not set
CONFIG_SONYPI=y

#
# PCMCIA character devices
#
# CONFIG_SYNCLINK_CS is not set
CONFIG_CARDMAN_4000=y
# CONFIG_CARDMAN_4040 is not set
# CONFIG_MWAVE is not set
CONFIG_PC8736x_GPIO=y
CONFIG_NSC_GPIO=y
# CONFIG_HPET is not set
CONFIG_HANGCHECK_TIMER=y
CONFIG_TCG_TPM=y
# CONFIG_TCG_TIS is not set
CONFIG_TCG_TIS_I2C_INFINEON=y
CONFIG_TCG_NSC=y
# CONFIG_TCG_ATMEL is not set
# CONFIG_TCG_INFINEON is not set
CONFIG_TELCLOCK=y
CONFIG_DEVPORT=y
CONFIG_I2C=y
CONFIG_I2C_BOARDINFO=y
CONFIG_I2C_COMPAT=y
# CONFIG_I2C_CHARDEV is not set
CONFIG_I2C_MUX=y

#
# Multiplexer I2C Chip support
#
# CONFIG_I2C_MUX_PCA9541 is not set
CONFIG_I2C_MUX_PCA954x=y
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
CONFIG_I2C_ALI1535=y
CONFIG_I2C_ALI1563=y
CONFIG_I2C_ALI15X3=y
# CONFIG_I2C_AMD756 is not set
# CONFIG_I2C_AMD8111 is not set
CONFIG_I2C_I801=y
CONFIG_I2C_ISCH=y
# CONFIG_I2C_ISMT is not set
CONFIG_I2C_PIIX4=y
CONFIG_I2C_NFORCE2=y
CONFIG_I2C_NFORCE2_S4985=y
CONFIG_I2C_SIS5595=y
CONFIG_I2C_SIS630=y
CONFIG_I2C_SIS96X=y
CONFIG_I2C_VIA=y
CONFIG_I2C_VIAPRO=y

#
# ACPI drivers
#
# CONFIG_I2C_SCMI is not set

#
# I2C system bus drivers (mostly embedded / system-on-chip)
#
CONFIG_I2C_DESIGNWARE_CORE=y
CONFIG_I2C_DESIGNWARE_PCI=y
CONFIG_I2C_EG20T=y
# CONFIG_I2C_INTEL_MID is not set
CONFIG_I2C_OCORES=y
CONFIG_I2C_PCA_PLATFORM=y
# CONFIG_I2C_PXA_PCI is not set
CONFIG_I2C_SIMTEC=y
# CONFIG_I2C_XILINX is not set

#
# External I2C/SMBus adapter drivers
#
# CONFIG_I2C_DIOLAN_U2C is not set
CONFIG_I2C_PARPORT_LIGHT=y
# CONFIG_I2C_TAOS_EVM is not set
CONFIG_I2C_TINY_USB=y
CONFIG_I2C_VIPERBOARD=y

#
# Other I2C/SMBus bus drivers
#
CONFIG_SCx200_ACB=y
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
CONFIG_SPI_PXA2XX_DMA=y
CONFIG_SPI_PXA2XX=y
CONFIG_SPI_PXA2XX_PCI=y
CONFIG_SPI_SC18IS602=y
# CONFIG_SPI_TOPCLIFF_PCH is not set
# CONFIG_SPI_XCOMM is not set
CONFIG_SPI_XILINX=y
# CONFIG_SPI_DESIGNWARE is not set

#
# SPI Protocol Masters
#
CONFIG_SPI_SPIDEV=y
CONFIG_SPI_TLE62X0=y

#
# Qualcomm MSM SSBI bus support
#
# CONFIG_SSBI is not set
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
CONFIG_GPIO_DEVRES=y
# CONFIG_GPIOLIB is not set
CONFIG_W1=y
CONFIG_W1_CON=y

#
# 1-wire Bus Masters
#
CONFIG_W1_MASTER_MATROX=y
CONFIG_W1_MASTER_DS2490=y
CONFIG_W1_MASTER_DS2482=y
# CONFIG_W1_MASTER_DS1WM is not set

#
# 1-wire Slaves
#
CONFIG_W1_SLAVE_THERM=y
CONFIG_W1_SLAVE_SMEM=y
# CONFIG_W1_SLAVE_DS2408 is not set
CONFIG_W1_SLAVE_DS2413=y
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
CONFIG_MAX8925_POWER=y
CONFIG_WM831X_BACKUP=y
CONFIG_WM831X_POWER=y
CONFIG_TEST_POWER=y
CONFIG_BATTERY_88PM860X=y
CONFIG_BATTERY_DS2760=y
CONFIG_BATTERY_DS2780=y
CONFIG_BATTERY_DS2781=y
CONFIG_BATTERY_DS2782=y
# CONFIG_BATTERY_SBS is not set
# CONFIG_BATTERY_BQ27x00 is not set
# CONFIG_BATTERY_DA9052 is not set
CONFIG_BATTERY_MAX17040=y
CONFIG_BATTERY_MAX17042=y
CONFIG_CHARGER_88PM860X=y
CONFIG_BATTERY_INTEL_MID=y
CONFIG_CHARGER_MAX8903=y
CONFIG_CHARGER_LP8727=y
CONFIG_CHARGER_BQ2415X=y
CONFIG_CHARGER_SMB347=y
CONFIG_BATTERY_GOLDFISH=y
# CONFIG_POWER_RESET is not set
CONFIG_POWER_AVS=y
CONFIG_HWMON=y
CONFIG_HWMON_VID=y
# CONFIG_HWMON_DEBUG_CHIP is not set

#
# Native drivers
#
# CONFIG_SENSORS_AD7314 is not set
CONFIG_SENSORS_AD7414=y
CONFIG_SENSORS_AD7418=y
CONFIG_SENSORS_ADCXX=y
CONFIG_SENSORS_ADM1021=y
# CONFIG_SENSORS_ADM1025 is not set
CONFIG_SENSORS_ADM1026=y
CONFIG_SENSORS_ADM1029=y
CONFIG_SENSORS_ADM1031=y
CONFIG_SENSORS_ADM9240=y
CONFIG_SENSORS_ADT7X10=y
# CONFIG_SENSORS_ADT7310 is not set
CONFIG_SENSORS_ADT7410=y
CONFIG_SENSORS_ADT7411=y
CONFIG_SENSORS_ADT7462=y
# CONFIG_SENSORS_ADT7470 is not set
CONFIG_SENSORS_ADT7475=y
CONFIG_SENSORS_ASC7621=y
CONFIG_SENSORS_K8TEMP=y
CONFIG_SENSORS_K10TEMP=y
CONFIG_SENSORS_FAM15H_POWER=y
CONFIG_SENSORS_ASB100=y
# CONFIG_SENSORS_ATXP1 is not set
# CONFIG_SENSORS_DS620 is not set
# CONFIG_SENSORS_DS1621 is not set
# CONFIG_SENSORS_DA9052_ADC is not set
# CONFIG_SENSORS_I5K_AMB is not set
# CONFIG_SENSORS_F71805F is not set
CONFIG_SENSORS_F71882FG=y
CONFIG_SENSORS_F75375S=y
CONFIG_SENSORS_FSCHMD=y
CONFIG_SENSORS_G760A=y
CONFIG_SENSORS_GL518SM=y
CONFIG_SENSORS_GL520SM=y
CONFIG_SENSORS_HIH6130=y
# CONFIG_SENSORS_CORETEMP is not set
CONFIG_SENSORS_IBMAEM=y
# CONFIG_SENSORS_IBMPEX is not set
CONFIG_SENSORS_IT87=y
CONFIG_SENSORS_JC42=y
# CONFIG_SENSORS_LINEAGE is not set
CONFIG_SENSORS_LM63=y
CONFIG_SENSORS_LM70=y
CONFIG_SENSORS_LM73=y
# CONFIG_SENSORS_LM75 is not set
CONFIG_SENSORS_LM77=y
CONFIG_SENSORS_LM78=y
CONFIG_SENSORS_LM80=y
# CONFIG_SENSORS_LM83 is not set
# CONFIG_SENSORS_LM85 is not set
CONFIG_SENSORS_LM87=y
CONFIG_SENSORS_LM90=y
# CONFIG_SENSORS_LM92 is not set
CONFIG_SENSORS_LM93=y
# CONFIG_SENSORS_LTC4151 is not set
# CONFIG_SENSORS_LTC4215 is not set
CONFIG_SENSORS_LTC4245=y
CONFIG_SENSORS_LTC4261=y
CONFIG_SENSORS_LM95234=y
# CONFIG_SENSORS_LM95241 is not set
CONFIG_SENSORS_LM95245=y
# CONFIG_SENSORS_MAX1111 is not set
CONFIG_SENSORS_MAX16065=y
# CONFIG_SENSORS_MAX1619 is not set
CONFIG_SENSORS_MAX1668=y
# CONFIG_SENSORS_MAX197 is not set
CONFIG_SENSORS_MAX6639=y
CONFIG_SENSORS_MAX6642=y
CONFIG_SENSORS_MAX6650=y
# CONFIG_SENSORS_MAX6697 is not set
CONFIG_SENSORS_MCP3021=y
CONFIG_SENSORS_NCT6775=y
# CONFIG_SENSORS_NTC_THERMISTOR is not set
CONFIG_SENSORS_PC87360=y
CONFIG_SENSORS_PC87427=y
CONFIG_SENSORS_PCF8591=y
CONFIG_PMBUS=y
CONFIG_SENSORS_PMBUS=y
CONFIG_SENSORS_ADM1275=y
CONFIG_SENSORS_LM25066=y
CONFIG_SENSORS_LTC2978=y
# CONFIG_SENSORS_MAX16064 is not set
CONFIG_SENSORS_MAX34440=y
# CONFIG_SENSORS_MAX8688 is not set
CONFIG_SENSORS_UCD9000=y
CONFIG_SENSORS_UCD9200=y
CONFIG_SENSORS_ZL6100=y
CONFIG_SENSORS_SHT21=y
CONFIG_SENSORS_SIS5595=y
CONFIG_SENSORS_SMM665=y
CONFIG_SENSORS_DME1737=y
CONFIG_SENSORS_EMC1403=y
CONFIG_SENSORS_EMC2103=y
CONFIG_SENSORS_EMC6W201=y
# CONFIG_SENSORS_SMSC47M1 is not set
CONFIG_SENSORS_SMSC47M192=y
CONFIG_SENSORS_SMSC47B397=y
# CONFIG_SENSORS_SCH56XX_COMMON is not set
CONFIG_SENSORS_ADS1015=y
# CONFIG_SENSORS_ADS7828 is not set
# CONFIG_SENSORS_ADS7871 is not set
# CONFIG_SENSORS_AMC6821 is not set
CONFIG_SENSORS_INA209=y
# CONFIG_SENSORS_INA2XX is not set
CONFIG_SENSORS_THMC50=y
CONFIG_SENSORS_TMP102=y
CONFIG_SENSORS_TMP401=y
# CONFIG_SENSORS_TMP421 is not set
CONFIG_SENSORS_VIA_CPUTEMP=y
CONFIG_SENSORS_VIA686A=y
CONFIG_SENSORS_VT1211=y
CONFIG_SENSORS_VT8231=y
CONFIG_SENSORS_W83781D=y
CONFIG_SENSORS_W83791D=y
CONFIG_SENSORS_W83792D=y
CONFIG_SENSORS_W83793=y
# CONFIG_SENSORS_W83795 is not set
CONFIG_SENSORS_W83L785TS=y
CONFIG_SENSORS_W83L786NG=y
CONFIG_SENSORS_W83627HF=y
CONFIG_SENSORS_W83627EHF=y
# CONFIG_SENSORS_WM831X is not set
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
# CONFIG_THERMAL_GOV_USER_SPACE is not set
# CONFIG_THERMAL_EMULATION is not set
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
CONFIG_SSB_PCMCIAHOST_POSSIBLE=y
CONFIG_SSB_PCMCIAHOST=y
CONFIG_SSB_SDIOHOST_POSSIBLE=y
# CONFIG_SSB_SDIOHOST is not set
# CONFIG_SSB_SILENT is not set
# CONFIG_SSB_DEBUG is not set
CONFIG_SSB_DRIVER_PCICORE_POSSIBLE=y
CONFIG_SSB_DRIVER_PCICORE=y
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
CONFIG_MFD_AS3711=y
CONFIG_PMIC_ADP5520=y
# CONFIG_MFD_CROS_EC is not set
# CONFIG_PMIC_DA903X is not set
CONFIG_PMIC_DA9052=y
CONFIG_MFD_DA9052_SPI=y
CONFIG_MFD_DA9052_I2C=y
# CONFIG_MFD_DA9055 is not set
CONFIG_MFD_MC13783=y
CONFIG_MFD_MC13XXX=y
CONFIG_MFD_MC13XXX_SPI=y
CONFIG_MFD_MC13XXX_I2C=y
# CONFIG_HTC_PASIC3 is not set
CONFIG_LPC_ICH=y
CONFIG_LPC_SCH=y
CONFIG_MFD_INTEL_MSIC=y
CONFIG_MFD_JANZ_CMODIO=y
CONFIG_MFD_88PM800=y
# CONFIG_MFD_88PM805 is not set
CONFIG_MFD_88PM860X=y
# CONFIG_MFD_MAX77686 is not set
CONFIG_MFD_MAX77693=y
# CONFIG_MFD_MAX8907 is not set
CONFIG_MFD_MAX8925=y
# CONFIG_MFD_MAX8997 is not set
# CONFIG_MFD_MAX8998 is not set
# CONFIG_EZX_PCAP is not set
CONFIG_MFD_VIPERBOARD=y
CONFIG_MFD_RETU=y
# CONFIG_MFD_PCF50633 is not set
CONFIG_MFD_RDC321X=y
CONFIG_MFD_RTSX_PCI=y
# CONFIG_MFD_RC5T583 is not set
# CONFIG_MFD_SEC_CORE is not set
CONFIG_MFD_SI476X_CORE=y
CONFIG_MFD_SM501=y
CONFIG_MFD_SMSC=y
CONFIG_ABX500_CORE=y
CONFIG_AB3100_CORE=y
CONFIG_AB3100_OTP=y
# CONFIG_MFD_STMPE is not set
CONFIG_MFD_SYSCON=y
CONFIG_MFD_TI_AM335X_TSCADC=y
CONFIG_MFD_LP8788=y
# CONFIG_MFD_PALMAS is not set
# CONFIG_TPS6105X is not set
CONFIG_TPS6507X=y
# CONFIG_MFD_TPS65090 is not set
# CONFIG_MFD_TPS65217 is not set
# CONFIG_MFD_TPS6586X is not set
CONFIG_MFD_TPS80031=y
# CONFIG_TWL4030_CORE is not set
# CONFIG_TWL6040_CORE is not set
CONFIG_MFD_WL1273_CORE=y
CONFIG_MFD_LM3533=y
# CONFIG_MFD_TC3589X is not set
# CONFIG_MFD_TMIO is not set
CONFIG_MFD_VX855=y
CONFIG_MFD_ARIZONA=y
CONFIG_MFD_ARIZONA_I2C=y
CONFIG_MFD_ARIZONA_SPI=y
# CONFIG_MFD_WM5102 is not set
CONFIG_MFD_WM5110=y
# CONFIG_MFD_WM8400 is not set
CONFIG_MFD_WM831X=y
CONFIG_MFD_WM831X_I2C=y
# CONFIG_MFD_WM831X_SPI is not set
# CONFIG_MFD_WM8350_I2C is not set
CONFIG_MFD_WM8994=y
# CONFIG_REGULATOR is not set
CONFIG_MEDIA_SUPPORT=y

#
# Multimedia core support
#
# CONFIG_MEDIA_CAMERA_SUPPORT is not set
# CONFIG_MEDIA_ANALOG_TV_SUPPORT is not set
# CONFIG_MEDIA_DIGITAL_TV_SUPPORT is not set
# CONFIG_MEDIA_RADIO_SUPPORT is not set
# CONFIG_MEDIA_RC_SUPPORT is not set
# CONFIG_VIDEO_ADV_DEBUG is not set
# CONFIG_VIDEO_FIXED_MINOR_RANGES is not set
# CONFIG_TTPCI_EEPROM is not set

#
# Media drivers
#
CONFIG_MEDIA_USB_SUPPORT=y
CONFIG_MEDIA_PCI_SUPPORT=y

#
# Supported MMC/SDIO adapters
#
CONFIG_CYPRESS_FIRMWARE=y

#
# Media ancillary drivers (tuners, sensors, i2c, frontends)
#

#
# Customise DVB Frontends
#
# CONFIG_DVB_TUNER_DIB0070 is not set
CONFIG_DVB_TUNER_DIB0090=y

#
# Tools to develop new frontends
#
CONFIG_DVB_DUMMY_FE=y

#
# Graphics support
#
CONFIG_AGP=y
# CONFIG_AGP_ALI is not set
CONFIG_AGP_ATI=y
CONFIG_AGP_AMD=y
# CONFIG_AGP_AMD64 is not set
CONFIG_AGP_INTEL=y
CONFIG_AGP_NVIDIA=y
CONFIG_AGP_SIS=y
CONFIG_AGP_SWORKS=y
CONFIG_AGP_VIA=y
# CONFIG_AGP_EFFICEON is not set
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
# CONFIG_DRM_RADEON is not set
CONFIG_DRM_NOUVEAU=y
CONFIG_NOUVEAU_DEBUG=5
CONFIG_NOUVEAU_DEBUG_DEFAULT=3
CONFIG_DRM_NOUVEAU_BACKLIGHT=y
# CONFIG_DRM_I810 is not set
CONFIG_DRM_I915=y
CONFIG_DRM_I915_KMS=y
CONFIG_DRM_MGA=y
CONFIG_DRM_SIS=y
CONFIG_DRM_VIA=y
# CONFIG_DRM_SAVAGE is not set
# CONFIG_DRM_VMWGFX is not set
# CONFIG_DRM_GMA500 is not set
CONFIG_DRM_UDL=y
CONFIG_DRM_AST=y
# CONFIG_DRM_MGAG200 is not set
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
# CONFIG_FB_BOTH_ENDIAN is not set
CONFIG_FB_BIG_ENDIAN=y
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
# CONFIG_FB_PM2 is not set
# CONFIG_FB_CYBER2000 is not set
CONFIG_FB_ARC=y
# CONFIG_FB_ASILIANT is not set
CONFIG_FB_IMSTT=y
# CONFIG_FB_VGA16 is not set
CONFIG_FB_UVESA=y
# CONFIG_FB_VESA is not set
CONFIG_FB_N411=y
# CONFIG_FB_HGA is not set
# CONFIG_FB_S1D13XXX is not set
CONFIG_FB_NVIDIA=y
# CONFIG_FB_NVIDIA_I2C is not set
CONFIG_FB_NVIDIA_DEBUG=y
# CONFIG_FB_NVIDIA_BACKLIGHT is not set
CONFIG_FB_RIVA=y
# CONFIG_FB_RIVA_I2C is not set
CONFIG_FB_RIVA_DEBUG=y
# CONFIG_FB_RIVA_BACKLIGHT is not set
CONFIG_FB_I740=y
CONFIG_FB_I810=y
# CONFIG_FB_I810_GTF is not set
CONFIG_FB_LE80578=y
# CONFIG_FB_CARILLO_RANCH is not set
# CONFIG_FB_MATROX is not set
CONFIG_FB_RADEON=y
CONFIG_FB_RADEON_I2C=y
# CONFIG_FB_RADEON_BACKLIGHT is not set
# CONFIG_FB_RADEON_DEBUG is not set
CONFIG_FB_ATY128=y
CONFIG_FB_ATY128_BACKLIGHT=y
CONFIG_FB_ATY=y
CONFIG_FB_ATY_CT=y
CONFIG_FB_ATY_GENERIC_LCD=y
CONFIG_FB_ATY_GX=y
# CONFIG_FB_ATY_BACKLIGHT is not set
# CONFIG_FB_S3 is not set
# CONFIG_FB_SAVAGE is not set
CONFIG_FB_SIS=y
CONFIG_FB_SIS_300=y
# CONFIG_FB_SIS_315 is not set
# CONFIG_FB_VIA is not set
CONFIG_FB_NEOMAGIC=y
# CONFIG_FB_KYRO is not set
CONFIG_FB_3DFX=y
# CONFIG_FB_3DFX_ACCEL is not set
CONFIG_FB_3DFX_I2C=y
CONFIG_FB_VOODOO1=y
# CONFIG_FB_VT8623 is not set
CONFIG_FB_TRIDENT=y
CONFIG_FB_ARK=y
CONFIG_FB_PM3=y
# CONFIG_FB_CARMINE is not set
# CONFIG_FB_GEODE is not set
CONFIG_FB_TMIO=y
# CONFIG_FB_TMIO_ACCELL is not set
CONFIG_FB_SM501=y
CONFIG_FB_SMSCUFX=y
# CONFIG_FB_UDL is not set
CONFIG_FB_GOLDFISH=y
# CONFIG_FB_VIRTUAL is not set
CONFIG_FB_METRONOME=y
# CONFIG_FB_MB862XX is not set
CONFIG_FB_BROADSHEET=y
# CONFIG_FB_AUO_K190X is not set
# CONFIG_EXYNOS_VIDEO is not set
CONFIG_BACKLIGHT_LCD_SUPPORT=y
# CONFIG_LCD_CLASS_DEVICE is not set
CONFIG_BACKLIGHT_CLASS_DEVICE=y
CONFIG_BACKLIGHT_GENERIC=y
# CONFIG_BACKLIGHT_LM3533 is not set
# CONFIG_BACKLIGHT_DA9052 is not set
# CONFIG_BACKLIGHT_MAX8925 is not set
# CONFIG_BACKLIGHT_APPLE is not set
CONFIG_BACKLIGHT_SAHARA=y
# CONFIG_BACKLIGHT_WM831X is not set
# CONFIG_BACKLIGHT_ADP5520 is not set
CONFIG_BACKLIGHT_ADP8860=y
# CONFIG_BACKLIGHT_ADP8870 is not set
CONFIG_BACKLIGHT_88PM860X=y
# CONFIG_BACKLIGHT_LM3630 is not set
# CONFIG_BACKLIGHT_LM3639 is not set
# CONFIG_BACKLIGHT_LP855X is not set
CONFIG_BACKLIGHT_LP8788=y
# CONFIG_BACKLIGHT_AS3711 is not set
# CONFIG_LOGO is not set
CONFIG_SOUND=y
CONFIG_SOUND_OSS_CORE=y
# CONFIG_SOUND_OSS_CORE_PRECLAIM is not set
CONFIG_SND=y
CONFIG_SND_TIMER=y
CONFIG_SND_PCM=y
CONFIG_SND_HWDEP=y
CONFIG_SND_RAWMIDI=y
# CONFIG_SND_SEQUENCER is not set
CONFIG_SND_OSSEMUL=y
CONFIG_SND_MIXER_OSS=y
CONFIG_SND_PCM_OSS=y
# CONFIG_SND_PCM_OSS_PLUGINS is not set
# CONFIG_SND_HRTIMER is not set
# CONFIG_SND_DYNAMIC_MINORS is not set
CONFIG_SND_SUPPORT_OLD_API=y
CONFIG_SND_VERBOSE_PROCFS=y
# CONFIG_SND_VERBOSE_PRINTK is not set
CONFIG_SND_DEBUG=y
CONFIG_SND_DEBUG_VERBOSE=y
CONFIG_SND_PCM_XRUN_DEBUG=y
CONFIG_SND_VMASTER=y
CONFIG_SND_DMA_SGBUF=y
# CONFIG_SND_RAWMIDI_SEQ is not set
# CONFIG_SND_OPL3_LIB_SEQ is not set
# CONFIG_SND_OPL4_LIB_SEQ is not set
# CONFIG_SND_SBAWE_SEQ is not set
# CONFIG_SND_EMU10K1_SEQ is not set
CONFIG_SND_MPU401_UART=y
CONFIG_SND_DRIVERS=y
CONFIG_SND_PCSP=y
CONFIG_SND_DUMMY=y
# CONFIG_SND_ALOOP is not set
# CONFIG_SND_MTPAV is not set
CONFIG_SND_SERIAL_U16550=y
CONFIG_SND_MPU401=y
# CONFIG_SND_PCI is not set
# CONFIG_SND_SPI is not set
CONFIG_SND_USB=y
CONFIG_SND_USB_AUDIO=y
# CONFIG_SND_USB_UA101 is not set
CONFIG_SND_USB_USX2Y=y
CONFIG_SND_USB_CAIAQ=y
# CONFIG_SND_USB_CAIAQ_INPUT is not set
CONFIG_SND_USB_US122L=y
CONFIG_SND_USB_6FIRE=y
CONFIG_SND_FIREWIRE=y
CONFIG_SND_FIREWIRE_LIB=y
CONFIG_SND_FIREWIRE_SPEAKERS=y
CONFIG_SND_ISIGHT=y
CONFIG_SND_SCS1X=y
# CONFIG_SND_PCMCIA is not set
# CONFIG_SND_SOC is not set
# CONFIG_SOUND_PRIME is not set

#
# HID support
#
CONFIG_HID=y
CONFIG_HID_BATTERY_STRENGTH=y
CONFIG_HIDRAW=y
# CONFIG_UHID is not set
# CONFIG_HID_GENERIC is not set

#
# Special HID drivers
#
# CONFIG_HID_A4TECH is not set
CONFIG_HID_ACRUX=y
CONFIG_HID_ACRUX_FF=y
# CONFIG_HID_APPLE is not set
CONFIG_HID_APPLEIR=y
# CONFIG_HID_AUREAL is not set
# CONFIG_HID_BELKIN is not set
CONFIG_HID_CHERRY=y
CONFIG_HID_CHICONY=y
# CONFIG_HID_PRODIKEYS is not set
CONFIG_HID_CYPRESS=y
CONFIG_HID_DRAGONRISE=y
CONFIG_DRAGONRISE_FF=y
CONFIG_HID_EMS_FF=y
CONFIG_HID_ELECOM=y
CONFIG_HID_EZKEY=y
# CONFIG_HID_HOLTEK is not set
# CONFIG_HID_KEYTOUCH is not set
CONFIG_HID_KYE=y
CONFIG_HID_UCLOGIC=y
CONFIG_HID_WALTOP=y
CONFIG_HID_GYRATION=y
CONFIG_HID_ICADE=y
# CONFIG_HID_TWINHAN is not set
# CONFIG_HID_KENSINGTON is not set
CONFIG_HID_LCPOWER=y
CONFIG_HID_LENOVO_TPKBD=y
CONFIG_HID_LOGITECH=y
CONFIG_HID_LOGITECH_DJ=y
CONFIG_LOGITECH_FF=y
# CONFIG_LOGIRUMBLEPAD2_FF is not set
# CONFIG_LOGIG940_FF is not set
# CONFIG_LOGIWHEELS_FF is not set
CONFIG_HID_MAGICMOUSE=y
CONFIG_HID_MICROSOFT=y
CONFIG_HID_MONTEREY=y
# CONFIG_HID_MULTITOUCH is not set
CONFIG_HID_NTRIG=y
CONFIG_HID_ORTEK=y
# CONFIG_HID_PANTHERLORD is not set
CONFIG_HID_PETALYNX=y
# CONFIG_HID_PICOLCD is not set
# CONFIG_HID_PRIMAX is not set
CONFIG_HID_PS3REMOTE=y
CONFIG_HID_ROCCAT=y
CONFIG_HID_SAITEK=y
CONFIG_HID_SAMSUNG=y
CONFIG_HID_SONY=y
CONFIG_HID_SPEEDLINK=y
# CONFIG_HID_STEELSERIES is not set
# CONFIG_HID_SUNPLUS is not set
# CONFIG_HID_GREENASIA is not set
CONFIG_HID_SMARTJOYPLUS=y
# CONFIG_SMARTJOYPLUS_FF is not set
CONFIG_HID_TIVO=y
# CONFIG_HID_TOPSEED is not set
CONFIG_HID_THINGM=y
CONFIG_HID_THRUSTMASTER=y
CONFIG_THRUSTMASTER_FF=y
CONFIG_HID_WACOM=y
# CONFIG_HID_WIIMOTE is not set
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
CONFIG_I2C_HID=y
CONFIG_USB_ARCH_HAS_OHCI=y
CONFIG_USB_ARCH_HAS_EHCI=y
CONFIG_USB_ARCH_HAS_XHCI=y
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
CONFIG_USB_OTG=y
# CONFIG_USB_OTG_WHITELIST is not set
# CONFIG_USB_OTG_BLACKLIST_HUB is not set
CONFIG_USB_MON=y
CONFIG_USB_WUSB=y
CONFIG_USB_WUSB_CBAF=y
# CONFIG_USB_WUSB_CBAF_DEBUG is not set

#
# USB Host Controller Drivers
#
CONFIG_USB_C67X00_HCD=y
# CONFIG_USB_XHCI_HCD is not set
CONFIG_USB_EHCI_HCD=y
CONFIG_USB_EHCI_ROOT_HUB_TT=y
CONFIG_USB_EHCI_TT_NEWSCHED=y
CONFIG_USB_EHCI_PCI=y
CONFIG_USB_EHCI_HCD_PLATFORM=y
# CONFIG_USB_OXU210HP_HCD is not set
CONFIG_USB_ISP116X_HCD=y
CONFIG_USB_ISP1760_HCD=y
CONFIG_USB_ISP1362_HCD=y
# CONFIG_USB_OHCI_HCD is not set
# CONFIG_USB_UHCI_HCD is not set
# CONFIG_USB_U132_HCD is not set
CONFIG_USB_SL811_HCD=y
CONFIG_USB_SL811_HCD_ISO=y
CONFIG_USB_SL811_CS=y
CONFIG_USB_R8A66597_HCD=y
CONFIG_USB_WHCI_HCD=y
# CONFIG_USB_HWA_HCD is not set
CONFIG_USB_HCD_SSB=y

#
# USB Device Class drivers
#
# CONFIG_USB_ACM is not set
# CONFIG_USB_PRINTER is not set
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
CONFIG_USB_DWC3_HOST=y
# CONFIG_USB_DWC3_DEBUG is not set
CONFIG_USB_CHIPIDEA=y
# CONFIG_USB_CHIPIDEA_HOST is not set
# CONFIG_USB_CHIPIDEA_DEBUG is not set

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
# CONFIG_USB_SEVSEG is not set
# CONFIG_USB_RIO500 is not set
CONFIG_USB_LEGOTOWER=y
CONFIG_USB_LCD=y
CONFIG_USB_LED=y
CONFIG_USB_CYPRESS_CY7C63=y
# CONFIG_USB_CYTHERM is not set
# CONFIG_USB_IDMOUSE is not set
CONFIG_USB_FTDI_ELAN=y
# CONFIG_USB_APPLEDISPLAY is not set
# CONFIG_USB_SISUSBVGA is not set
CONFIG_USB_LD=y
CONFIG_USB_TRANCEVIBRATOR=y
CONFIG_USB_IOWARRIOR=y
CONFIG_USB_TEST=y
CONFIG_USB_ISIGHTFW=y
# CONFIG_USB_YUREX is not set
# CONFIG_USB_EZUSB_FX2 is not set
CONFIG_USB_HSIC_USB3503=y
# CONFIG_USB_PHY is not set
# CONFIG_USB_GADGET is not set
CONFIG_UWB=y
CONFIG_UWB_HWA=y
CONFIG_UWB_WHCI=y
CONFIG_UWB_I1480U=y
CONFIG_MMC=y
CONFIG_MMC_DEBUG=y
# CONFIG_MMC_UNSAFE_RESUME is not set
# CONFIG_MMC_CLKGATE is not set

#
# MMC/SD/SDIO Card Drivers
#
# CONFIG_SDIO_UART is not set
# CONFIG_MMC_TEST is not set

#
# MMC/SD/SDIO Host Controller Drivers
#
CONFIG_MMC_SDHCI=y
# CONFIG_MMC_SDHCI_PCI is not set
# CONFIG_MMC_SDHCI_ACPI is not set
CONFIG_MMC_SDHCI_PLTFM=y
# CONFIG_MMC_WBSD is not set
CONFIG_MMC_TIFM_SD=y
CONFIG_MMC_GOLDFISH=y
# CONFIG_MMC_SDRICOH_CS is not set
CONFIG_MMC_CB710=y
CONFIG_MMC_VIA_SDMMC=y
CONFIG_MMC_VUB300=y
CONFIG_MMC_USHC=y
CONFIG_MMC_REALTEK_PCI=y
CONFIG_MEMSTICK=y
CONFIG_MEMSTICK_DEBUG=y

#
# MemoryStick drivers
#
CONFIG_MEMSTICK_UNSAFE_RESUME=y

#
# MemoryStick Host Controller Drivers
#
CONFIG_MEMSTICK_TIFM_MS=y
CONFIG_MEMSTICK_JMICRON_38X=y
CONFIG_MEMSTICK_R592=y
CONFIG_MEMSTICK_REALTEK_PCI=y
CONFIG_NEW_LEDS=y
CONFIG_LEDS_CLASS=y

#
# LED drivers
#
CONFIG_LEDS_88PM860X=y
CONFIG_LEDS_LM3530=y
# CONFIG_LEDS_LM3533 is not set
# CONFIG_LEDS_LM3642 is not set
CONFIG_LEDS_PCA9532=y
CONFIG_LEDS_LP3944=y
CONFIG_LEDS_LP55XX_COMMON=y
CONFIG_LEDS_LP5521=y
# CONFIG_LEDS_LP5523 is not set
CONFIG_LEDS_LP5562=y
# CONFIG_LEDS_LP8788 is not set
CONFIG_LEDS_PCA955X=y
# CONFIG_LEDS_PCA9633 is not set
# CONFIG_LEDS_WM831X_STATUS is not set
# CONFIG_LEDS_DA9052 is not set
CONFIG_LEDS_DAC124S085=y
CONFIG_LEDS_BD2802=y
CONFIG_LEDS_ADP5520=y
# CONFIG_LEDS_DELL_NETBOOKS is not set
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
# CONFIG_LEDS_TRIGGER_ONESHOT is not set
CONFIG_LEDS_TRIGGER_HEARTBEAT=y
CONFIG_LEDS_TRIGGER_BACKLIGHT=y
CONFIG_LEDS_TRIGGER_CPU=y
CONFIG_LEDS_TRIGGER_DEFAULT_ON=y

#
# iptables trigger is under Netfilter config (LED target)
#
CONFIG_LEDS_TRIGGER_TRANSIENT=y
CONFIG_LEDS_TRIGGER_CAMERA=y
CONFIG_ACCESSIBILITY=y
CONFIG_INFINIBAND=y
CONFIG_INFINIBAND_USER_MAD=y
CONFIG_INFINIBAND_USER_ACCESS=y
CONFIG_INFINIBAND_USER_MEM=y
CONFIG_INFINIBAND_ADDR_TRANS=y
# CONFIG_INFINIBAND_MTHCA is not set
CONFIG_INFINIBAND_AMSO1100=y
# CONFIG_INFINIBAND_AMSO1100_DEBUG is not set
CONFIG_INFINIBAND_NES=y
CONFIG_INFINIBAND_NES_DEBUG=y
CONFIG_EDAC=y
# CONFIG_EDAC_LEGACY_SYSFS is not set
# CONFIG_EDAC_DEBUG is not set
# CONFIG_EDAC_DECODE_MCE is not set
CONFIG_EDAC_MM_EDAC=y
# CONFIG_EDAC_AMD76X is not set
# CONFIG_EDAC_E7XXX is not set
# CONFIG_EDAC_E752X is not set
CONFIG_EDAC_I82875P=y
CONFIG_EDAC_I82975X=y
# CONFIG_EDAC_I3000 is not set
CONFIG_EDAC_I3200=y
CONFIG_EDAC_X38=y
# CONFIG_EDAC_I5400 is not set
CONFIG_EDAC_I7CORE=y
# CONFIG_EDAC_I82860 is not set
CONFIG_EDAC_R82600=y
# CONFIG_EDAC_I5000 is not set
CONFIG_EDAC_I5100=y
# CONFIG_EDAC_I7300 is not set
CONFIG_RTC_LIB=y
# CONFIG_RTC_CLASS is not set
CONFIG_DMADEVICES=y
CONFIG_DMADEVICES_DEBUG=y
CONFIG_DMADEVICES_VDEBUG=y

#
# DMA Devices
#
CONFIG_INTEL_MID_DMAC=y
CONFIG_INTEL_IOATDMA=y
# CONFIG_DW_DMAC is not set
CONFIG_TIMB_DMA=y
CONFIG_PCH_DMA=y
CONFIG_DMA_ENGINE=y
CONFIG_DMA_ACPI=y

#
# DMA Clients
#
# CONFIG_NET_DMA is not set
# CONFIG_ASYNC_TX_DMA is not set
CONFIG_DMATEST=y
CONFIG_DCA=y
# CONFIG_AUXDISPLAY is not set
CONFIG_UIO=y
# CONFIG_UIO_CIF is not set
# CONFIG_UIO_PDRV is not set
CONFIG_UIO_PDRV_GENIRQ=y
CONFIG_UIO_DMEM_GENIRQ=y
CONFIG_UIO_AEC=y
CONFIG_UIO_SERCOS3=y
CONFIG_UIO_PCI_GENERIC=y
CONFIG_UIO_NETX=y
CONFIG_VIRT_DRIVERS=y
CONFIG_VIRTIO=y

#
# Virtio drivers
#
CONFIG_VIRTIO_PCI=y
CONFIG_VIRTIO_BALLOON=y
CONFIG_VIRTIO_MMIO=y
# CONFIG_VIRTIO_MMIO_CMDLINE_DEVICES is not set

#
# Microsoft Hyper-V guest support
#
# CONFIG_HYPERV is not set
# CONFIG_STAGING is not set
CONFIG_X86_PLATFORM_DEVICES=y
# CONFIG_ACER_WMI is not set
# CONFIG_ACERHDF is not set
# CONFIG_ASUS_LAPTOP is not set
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
CONFIG_INTEL_SCU_IPC=y
CONFIG_INTEL_SCU_IPC_UTIL=y
# CONFIG_INTEL_MID_POWER_BUTTON is not set
CONFIG_INTEL_MFLD_THERMAL=y
# CONFIG_INTEL_IPS is not set
CONFIG_IBM_RTL=y
# CONFIG_XO15_EBOOK is not set
CONFIG_SAMSUNG_LAPTOP=y
CONFIG_MXM_WMI=y
# CONFIG_INTEL_OAKTRAIL is not set
# CONFIG_SAMSUNG_Q10 is not set
# CONFIG_APPLE_GMUX is not set
# CONFIG_PVPANIC is not set
CONFIG_GOLDFISH_PIPE=y

#
# Hardware Spinlock drivers
#
CONFIG_CLKSRC_I8253=y
CONFIG_CLKEVT_I8253=y
CONFIG_I8253_LOCK=y
CONFIG_CLKBLD_I8253=y
CONFIG_DW_APB_TIMER=y
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
CONFIG_DEVFREQ_GOV_POWERSAVE=y
# CONFIG_DEVFREQ_GOV_USERSPACE is not set

#
# DEVFREQ Drivers
#
# CONFIG_EXTCON is not set
# CONFIG_MEMORY is not set
# CONFIG_IIO is not set
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
# CONFIG_PWM is not set
# CONFIG_IPACK_BUS is not set
CONFIG_RESET_CONTROLLER=y

#
# Firmware Drivers
#
# CONFIG_EDD is not set
# CONFIG_FIRMWARE_MEMMAP is not set
CONFIG_DELL_RBU=y
# CONFIG_DCDBAS is not set
CONFIG_ISCSI_IBFT_FIND=y
# CONFIG_GOOGLE_FIRMWARE is not set

#
# File systems
#
CONFIG_DCACHE_WORD_ACCESS=y
CONFIG_FS_POSIX_ACL=y
# CONFIG_FILE_LOCKING is not set
CONFIG_FSNOTIFY=y
CONFIG_DNOTIFY=y
# CONFIG_INOTIFY_USER is not set
CONFIG_FANOTIFY=y
# CONFIG_FANOTIFY_ACCESS_PERMISSIONS is not set
CONFIG_QUOTA=y
CONFIG_QUOTA_NETLINK_INTERFACE=y
CONFIG_PRINT_QUOTA_WARNING=y
CONFIG_QUOTA_DEBUG=y
# CONFIG_QFMT_V1 is not set
# CONFIG_QFMT_V2 is not set
CONFIG_QUOTACTL=y
CONFIG_AUTOFS4_FS=y
# CONFIG_FUSE_FS is not set
CONFIG_GENERIC_ACL=y

#
# Caches
#
CONFIG_FSCACHE=y
# CONFIG_FSCACHE_STATS is not set
CONFIG_FSCACHE_HISTOGRAM=y
# CONFIG_FSCACHE_DEBUG is not set
# CONFIG_FSCACHE_OBJECT_LIST is not set

#
# Pseudo filesystems
#
CONFIG_PROC_FS=y
CONFIG_PROC_KCORE=y
# CONFIG_PROC_VMCORE is not set
CONFIG_PROC_SYSCTL=y
CONFIG_PROC_PAGE_MONITOR=y
CONFIG_SYSFS=y
CONFIG_TMPFS=y
CONFIG_TMPFS_POSIX_ACL=y
CONFIG_TMPFS_XATTR=y
CONFIG_HUGETLBFS=y
CONFIG_HUGETLB_PAGE=y
# CONFIG_CONFIGFS_FS is not set
CONFIG_MISC_FILESYSTEMS=y
CONFIG_ECRYPT_FS=y
CONFIG_ECRYPT_FS_MESSAGING=y
CONFIG_JFFS2_FS=y
CONFIG_JFFS2_FS_DEBUG=0
# CONFIG_JFFS2_FS_WRITEBUFFER is not set
CONFIG_JFFS2_SUMMARY=y
# CONFIG_JFFS2_FS_XATTR is not set
CONFIG_JFFS2_COMPRESSION_OPTIONS=y
CONFIG_JFFS2_ZLIB=y
CONFIG_JFFS2_LZO=y
# CONFIG_JFFS2_RTIME is not set
# CONFIG_JFFS2_RUBIN is not set
# CONFIG_JFFS2_CMODE_NONE is not set
# CONFIG_JFFS2_CMODE_PRIORITY is not set
# CONFIG_JFFS2_CMODE_SIZE is not set
CONFIG_JFFS2_CMODE_FAVOURLZO=y
CONFIG_LOGFS=y
CONFIG_ROMFS_FS=y
CONFIG_ROMFS_BACKED_BY_MTD=y
CONFIG_ROMFS_ON_MTD=y
CONFIG_PSTORE=y
CONFIG_PSTORE_CONSOLE=y
# CONFIG_PSTORE_FTRACE is not set
CONFIG_PSTORE_RAM=y
# CONFIG_NETWORK_FILESYSTEMS is not set
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
# CONFIG_NLS_CODEPAGE_863 is not set
CONFIG_NLS_CODEPAGE_864=y
CONFIG_NLS_CODEPAGE_865=y
# CONFIG_NLS_CODEPAGE_866 is not set
CONFIG_NLS_CODEPAGE_869=y
# CONFIG_NLS_CODEPAGE_936 is not set
CONFIG_NLS_CODEPAGE_950=y
# CONFIG_NLS_CODEPAGE_932 is not set
CONFIG_NLS_CODEPAGE_949=y
# CONFIG_NLS_CODEPAGE_874 is not set
CONFIG_NLS_ISO8859_8=y
CONFIG_NLS_CODEPAGE_1250=y
CONFIG_NLS_CODEPAGE_1251=y
CONFIG_NLS_ASCII=y
CONFIG_NLS_ISO8859_1=y
# CONFIG_NLS_ISO8859_2 is not set
CONFIG_NLS_ISO8859_3=y
# CONFIG_NLS_ISO8859_4 is not set
CONFIG_NLS_ISO8859_5=y
CONFIG_NLS_ISO8859_6=y
CONFIG_NLS_ISO8859_7=y
CONFIG_NLS_ISO8859_9=y
CONFIG_NLS_ISO8859_13=y
CONFIG_NLS_ISO8859_14=y
CONFIG_NLS_ISO8859_15=y
CONFIG_NLS_KOI8_R=y
CONFIG_NLS_KOI8_U=y
CONFIG_NLS_MAC_ROMAN=y
CONFIG_NLS_MAC_CELTIC=y
CONFIG_NLS_MAC_CENTEURO=y
CONFIG_NLS_MAC_CROATIAN=y
# CONFIG_NLS_MAC_CYRILLIC is not set
CONFIG_NLS_MAC_GAELIC=y
CONFIG_NLS_MAC_GREEK=y
CONFIG_NLS_MAC_ICELAND=y
CONFIG_NLS_MAC_INUIT=y
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
CONFIG_FRAME_WARN=1024
CONFIG_MAGIC_SYSRQ=y
# CONFIG_STRIP_ASM_SYMS is not set
CONFIG_READABLE_ASM=y
# CONFIG_UNUSED_SYMBOLS is not set
CONFIG_DEBUG_FS=y
# CONFIG_HEADERS_CHECK is not set
# CONFIG_DEBUG_SECTION_MISMATCH is not set
CONFIG_DEBUG_KERNEL=y
# CONFIG_DEBUG_SHIRQ is not set
CONFIG_LOCKUP_DETECTOR=y
CONFIG_HARDLOCKUP_DETECTOR=y
CONFIG_BOOTPARAM_HARDLOCKUP_PANIC=y
CONFIG_BOOTPARAM_HARDLOCKUP_PANIC_VALUE=1
CONFIG_BOOTPARAM_SOFTLOCKUP_PANIC=y
CONFIG_BOOTPARAM_SOFTLOCKUP_PANIC_VALUE=1
# CONFIG_PANIC_ON_OOPS is not set
CONFIG_PANIC_ON_OOPS_VALUE=0
# CONFIG_DETECT_HUNG_TASK is not set
# CONFIG_SCHED_DEBUG is not set
# CONFIG_SCHEDSTATS is not set
# CONFIG_TIMER_STATS is not set
CONFIG_DEBUG_OBJECTS=y
# CONFIG_DEBUG_OBJECTS_SELFTEST is not set
# CONFIG_DEBUG_OBJECTS_FREE is not set
CONFIG_DEBUG_OBJECTS_TIMERS=y
# CONFIG_DEBUG_OBJECTS_WORK is not set
# CONFIG_DEBUG_OBJECTS_RCU_HEAD is not set
# CONFIG_DEBUG_OBJECTS_PERCPU_COUNTER is not set
CONFIG_DEBUG_OBJECTS_ENABLE_DEFAULT=1
CONFIG_HAVE_DEBUG_KMEMLEAK=y
# CONFIG_DEBUG_KMEMLEAK is not set
# CONFIG_DEBUG_RT_MUTEXES is not set
CONFIG_RT_MUTEX_TESTER=y
CONFIG_DEBUG_SPINLOCK=y
CONFIG_DEBUG_MUTEXES=y
CONFIG_DEBUG_WW_MUTEX_SLOWPATH=y
CONFIG_DEBUG_LOCK_ALLOC=y
# CONFIG_PROVE_LOCKING is not set
CONFIG_LOCKDEP=y
# CONFIG_LOCK_STAT is not set
# CONFIG_DEBUG_LOCKDEP is not set
CONFIG_DEBUG_ATOMIC_SLEEP=y
# CONFIG_DEBUG_LOCKING_API_SELFTESTS is not set
CONFIG_STACKTRACE=y
# CONFIG_DEBUG_STACK_USAGE is not set
# CONFIG_DEBUG_KOBJECT is not set
# CONFIG_DEBUG_HIGHMEM is not set
CONFIG_DEBUG_BUGVERBOSE=y
# CONFIG_DEBUG_INFO is not set
CONFIG_DEBUG_VM=y
# CONFIG_DEBUG_VM_RB is not set
CONFIG_DEBUG_VIRTUAL=y
# CONFIG_DEBUG_WRITECOUNT is not set
CONFIG_DEBUG_MEMORY_INIT=y
CONFIG_DEBUG_LIST=y
# CONFIG_TEST_LIST_SORT is not set
# CONFIG_DEBUG_SG is not set
# CONFIG_DEBUG_NOTIFIERS is not set
CONFIG_DEBUG_CREDENTIALS=y
CONFIG_ARCH_WANT_FRAME_POINTERS=y
CONFIG_FRAME_POINTER=y
# CONFIG_BOOT_PRINTK_DELAY is not set

#
# RCU Debugging
#
# CONFIG_SPARSE_RCU_POINTER is not set
# CONFIG_RCU_TORTURE_TEST is not set
CONFIG_RCU_CPU_STALL_TIMEOUT=21
CONFIG_RCU_CPU_STALL_INFO=y
# CONFIG_RCU_TRACE is not set
# CONFIG_BACKTRACE_SELF_TEST is not set
CONFIG_DEBUG_FORCE_WEAK_PER_CPU=y
CONFIG_DEBUG_PER_CPU_MAPS=y
CONFIG_NOTIFIER_ERROR_INJECTION=y
# CONFIG_CPU_NOTIFIER_ERROR_INJECT is not set
# CONFIG_PM_NOTIFIER_ERROR_INJECT is not set
CONFIG_FAULT_INJECTION=y
# CONFIG_FAIL_PAGE_ALLOC is not set
CONFIG_FAIL_MMC_REQUEST=y
# CONFIG_FAULT_INJECTION_DEBUG_FS is not set
# CONFIG_LATENCYTOP is not set
CONFIG_ARCH_HAS_DEBUG_STRICT_USER_COPY_CHECKS=y
CONFIG_DEBUG_PAGEALLOC=y
CONFIG_WANT_PAGE_DEBUG_FLAGS=y
CONFIG_PAGE_GUARD=y
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
CONFIG_SCHED_TRACER=y
CONFIG_FTRACE_SYSCALLS=y
CONFIG_TRACER_SNAPSHOT=y
CONFIG_TRACER_SNAPSHOT_PER_CPU_SWAP=y
CONFIG_TRACE_BRANCH_PROFILING=y
# CONFIG_BRANCH_PROFILE_NONE is not set
CONFIG_PROFILE_ANNOTATED_BRANCHES=y
# CONFIG_PROFILE_ALL_BRANCHES is not set
CONFIG_TRACING_BRANCHES=y
CONFIG_BRANCH_TRACER=y
CONFIG_STACK_TRACER=y
# CONFIG_UPROBE_EVENT is not set
# CONFIG_PROBE_EVENTS is not set
CONFIG_DYNAMIC_FTRACE=y
CONFIG_DYNAMIC_FTRACE_WITH_REGS=y
# CONFIG_FUNCTION_PROFILER is not set
CONFIG_FTRACE_MCOUNT_RECORD=y
# CONFIG_FTRACE_STARTUP_TEST is not set
# CONFIG_MMIOTRACE is not set
# CONFIG_RING_BUFFER_BENCHMARK is not set
# CONFIG_RING_BUFFER_STARTUP_TEST is not set
# CONFIG_PROVIDE_OHCI1394_DMA_INIT is not set
# CONFIG_DYNAMIC_DEBUG is not set
CONFIG_DMA_API_DEBUG=y
CONFIG_ATOMIC64_SELFTEST=y
# CONFIG_SAMPLES is not set
CONFIG_HAVE_ARCH_KGDB=y
# CONFIG_KGDB is not set
CONFIG_HAVE_ARCH_KMEMCHECK=y
CONFIG_TEST_STRING_HELPERS=y
# CONFIG_TEST_KSTRTOX is not set
# CONFIG_STRICT_DEVMEM is not set
CONFIG_X86_VERBOSE_BOOTUP=y
CONFIG_EARLY_PRINTK=y
CONFIG_EARLY_PRINTK_INTEL_MID=y
# CONFIG_EARLY_PRINTK_DBGP is not set
CONFIG_DEBUG_STACKOVERFLOW=y
# CONFIG_X86_PTDUMP is not set
CONFIG_DEBUG_RODATA=y
CONFIG_DEBUG_RODATA_TEST=y
CONFIG_DOUBLEFAULT=y
# CONFIG_DEBUG_TLBFLUSH is not set
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
# CONFIG_DEBUG_BOOT_PARAMS is not set
# CONFIG_CPA_DEBUG is not set
CONFIG_OPTIMIZE_INLINING=y
# CONFIG_DEBUG_NMI_SELFTEST is not set

#
# Security options
#
CONFIG_KEYS=y
CONFIG_TRUSTED_KEYS=y
CONFIG_ENCRYPTED_KEYS=y
# CONFIG_KEYS_DEBUG_PROC_KEYS is not set
CONFIG_SECURITY_DMESG_RESTRICT=y
CONFIG_SECURITY=y
CONFIG_SECURITYFS=y
CONFIG_SECURITY_NETWORK=y
CONFIG_SECURITY_NETWORK_XFRM=y
CONFIG_SECURITY_PATH=y
CONFIG_LSM_MMAP_MIN_ADDR=65536
CONFIG_SECURITY_SELINUX=y
CONFIG_SECURITY_SELINUX_BOOTPARAM=y
CONFIG_SECURITY_SELINUX_BOOTPARAM_VALUE=1
# CONFIG_SECURITY_SELINUX_DISABLE is not set
CONFIG_SECURITY_SELINUX_DEVELOP=y
# CONFIG_SECURITY_SELINUX_AVC_STATS is not set
CONFIG_SECURITY_SELINUX_CHECKREQPROT_VALUE=1
# CONFIG_SECURITY_SELINUX_POLICYDB_VERSION_MAX is not set
CONFIG_SECURITY_SMACK=y
# CONFIG_SECURITY_TOMOYO is not set
CONFIG_SECURITY_APPARMOR=y
CONFIG_SECURITY_APPARMOR_BOOTPARAM_VALUE=1
# CONFIG_SECURITY_YAMA is not set
CONFIG_INTEGRITY=y
# CONFIG_INTEGRITY_SIGNATURE is not set
# CONFIG_IMA is not set
CONFIG_EVM=y
CONFIG_EVM_HMAC_VERSION=2
CONFIG_DEFAULT_SECURITY_SELINUX=y
# CONFIG_DEFAULT_SECURITY_SMACK is not set
# CONFIG_DEFAULT_SECURITY_APPARMOR is not set
# CONFIG_DEFAULT_SECURITY_DAC is not set
CONFIG_DEFAULT_SECURITY="selinux"
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
# CONFIG_CRYPTO_MANAGER_DISABLE_TESTS is not set
CONFIG_CRYPTO_GF128MUL=y
CONFIG_CRYPTO_NULL=y
CONFIG_CRYPTO_PCRYPT=y
CONFIG_CRYPTO_WORKQUEUE=y
CONFIG_CRYPTO_CRYPTD=y
CONFIG_CRYPTO_AUTHENC=y
CONFIG_CRYPTO_ABLK_HELPER_X86=y
CONFIG_CRYPTO_GLUE_HELPER_X86=y

#
# Authenticated Encryption with Associated Data
#
CONFIG_CRYPTO_CCM=y
# CONFIG_CRYPTO_GCM is not set
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
# CONFIG_CRYPTO_VMAC is not set

#
# Digest
#
CONFIG_CRYPTO_CRC32C=y
CONFIG_CRYPTO_CRC32C_INTEL=y
CONFIG_CRYPTO_CRC32=y
CONFIG_CRYPTO_CRC32_PCLMUL=y
CONFIG_CRYPTO_GHASH=y
CONFIG_CRYPTO_MD4=y
CONFIG_CRYPTO_MD5=y
CONFIG_CRYPTO_MICHAEL_MIC=y
CONFIG_CRYPTO_RMD128=y
CONFIG_CRYPTO_RMD160=y
# CONFIG_CRYPTO_RMD256 is not set
# CONFIG_CRYPTO_RMD320 is not set
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
# CONFIG_CRYPTO_AES_NI_INTEL is not set
CONFIG_CRYPTO_ANUBIS=y
CONFIG_CRYPTO_ARC4=y
CONFIG_CRYPTO_BLOWFISH=y
CONFIG_CRYPTO_BLOWFISH_COMMON=y
# CONFIG_CRYPTO_CAMELLIA is not set
CONFIG_CRYPTO_CAST_COMMON=y
# CONFIG_CRYPTO_CAST5 is not set
CONFIG_CRYPTO_CAST6=y
CONFIG_CRYPTO_DES=y
# CONFIG_CRYPTO_FCRYPT is not set
CONFIG_CRYPTO_KHAZAD=y
# CONFIG_CRYPTO_SALSA20 is not set
CONFIG_CRYPTO_SALSA20_586=y
CONFIG_CRYPTO_SEED=y
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
# CONFIG_CRYPTO_LZO is not set

#
# Random Number Generation
#
# CONFIG_CRYPTO_ANSI_CPRNG is not set
CONFIG_CRYPTO_USER_API=y
CONFIG_CRYPTO_USER_API_HASH=y
CONFIG_CRYPTO_USER_API_SKCIPHER=y
# CONFIG_CRYPTO_HW is not set
CONFIG_ASYMMETRIC_KEY_TYPE=y
CONFIG_ASYMMETRIC_PUBLIC_KEY_SUBTYPE=y
CONFIG_PUBLIC_KEY_ALGO_RSA=y
CONFIG_X509_CERTIFICATE_PARSER=y
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
CONFIG_KVM_INTEL=y
CONFIG_KVM_AMD=y
CONFIG_KVM_MMU_AUDIT=y
# CONFIG_LGUEST is not set
CONFIG_BINARY_PRINTF=y

#
# Library routines
#
CONFIG_BITREVERSE=y
CONFIG_GENERIC_STRNCPY_FROM_USER=y
CONFIG_GENERIC_STRNLEN_USER=y
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
CONFIG_LIBCRC32C=y
# CONFIG_CRC8 is not set
CONFIG_AUDIT_GENERIC=y
CONFIG_ZLIB_INFLATE=y
CONFIG_ZLIB_DEFLATE=y
CONFIG_LZO_COMPRESS=y
CONFIG_LZO_DECOMPRESS=y
# CONFIG_XZ_DEC is not set
# CONFIG_XZ_DEC_BCJ is not set
CONFIG_DECOMPRESS_GZIP=y
CONFIG_REED_SOLOMON=y
CONFIG_REED_SOLOMON_ENC8=y
CONFIG_REED_SOLOMON_DEC8=y
CONFIG_REED_SOLOMON_DEC16=y
CONFIG_BCH=y
CONFIG_BCH_CONST_PARAMS=y
CONFIG_BTREE=y
CONFIG_HAS_IOMEM=y
CONFIG_HAS_IOPORT=y
CONFIG_HAS_DMA=y
CONFIG_CPUMASK_OFFSTACK=y
CONFIG_CPU_RMAP=y
CONFIG_DQL=y
CONFIG_NLATTR=y
CONFIG_ARCH_HAS_ATOMIC64_DEC_IF_POSITIVE=y
CONFIG_AVERAGE=y
CONFIG_CLZ_TAB=y
CONFIG_CORDIC=y
CONFIG_DDR=y
CONFIG_MPILIB=y
CONFIG_OID_REGISTRY=y

--k+w/mQv8wyuph6w0--
