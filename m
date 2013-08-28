Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754358Ab3H1GPG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Aug 2013 02:15:06 -0400
Received: from mga01.intel.com ([192.55.52.88]:6971 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753453Ab3H1GPA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Aug 2013 02:15:00 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.89,974,1367996400"; 
   d="log'?scan'208";a="387531424"
Date: Wed, 28 Aug 2013 14:14:50 +0800
From: Fengguang Wu <fengguang.wu@intel.com>
To: fengguang.wu@intel.com, Russell King <rmk+kernel@arm.linux.org.uk>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Subject: [fourport_init] BUG: unable to handle kernel
Message-ID: <20130828061450.GA3365@localhost>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="VbJkn9YxBvnuCH5J"
Content-Disposition: inline
User-Agent: Heirloom mailx 12.5 6/20/10
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--VbJkn9YxBvnuCH5J
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Greetings,

FYI, one more bug triggered by

commit c817a67ecba7c3c2aaa104796d78f160af60920d
Author: Russell King <rmk+kernel@arm.linux.org.uk>
Date:   Thu Jun 27 15:06:14 2013 +0100

    kobject: delayed kobject release: help find buggy drivers
    
    Implement debugging for kobject release functions.  kobjects are
    reference counted, so the drop of the last reference to them is not
    predictable. However, the common case is for the last reference to be
    the kobject's removal from a subsystem, which results in the release
    function being immediately called.
    
    This can hide subtle bugs, which can occur when another thread holds a
    reference to the kobject at the same time that a kobject is removed.
    This results in the release method being delayed.
    
    In order to make these kinds of problems more visible, the following
    patch implements a delayed release; this has the effect that the
    release function will be out of order with respect to the removal of
    the kobject in the same manner that it would be if a reference was
    being held.
    
    This provides us with an easy way to allow driver writers to debug
    their drivers and fix otherwise hidden problems.
    
    Signed-off-by: Russell King <rmk+kernel@arm.linux.org.uk>
    Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

[    5.301612] WARNING: CPU: 0 PID: 1 at lib/list_debug.c:33 __list_add+0x44/0x78()
[    5.302790] list_add corruption. prev->next should be next (79a162d8), but was   (null). (prev=87b10ce8).
[    5.304127] Modules linked in:
[    5.304127] CPU: 0 PID: 1 Comm: swapper/0 Not tainted 3.11.0-rc6-next-20130822-07070-g245f086 #1
[    5.304127]  00000000 00000000 78049b7c 7951d86a 79724a8f 78049b94 79022c48 791fb32e
[    5.304127]  87b10ce8 79a162d8 87b79888 78049bac 79022c85 00000009 78049ba4 79724a8f
[    5.304127]  78049bc0 78049bd8 791fb32e 79724a65 00000021 79724a8f 79a162d8 00000000
[    5.304127] Call Trace:
[    5.304127]  [<7951d86a>] dump_stack+0x4b/0x66
[    5.304127]  [<79022c48>] warn_slowpath_common+0x5c/0x73
[    5.304127]  [<791fb32e>] ? __list_add+0x44/0x78
[    5.304127]  [<79022c85>] warn_slowpath_fmt+0x26/0x2a
[    5.304127]  [<791fb32e>] __list_add+0x44/0x78
[    5.304127]  [<79028bb8>] __internal_add_timer+0x97/0x9b
[    5.304127]  [<79028bca>] internal_add_timer+0xe/0x26
[    5.304127]  [<79028e13>] __mod_timer+0xa2/0xb7
[    5.304127]  [<79028f3b>] mod_timer+0x5d/0x6c
[    5.304127]  [<79028f5c>] add_timer+0x12/0x14
[    5.304127]  [<79030eb5>] __queue_delayed_work+0xca/0xe4
[    5.304127]  [<79032361>] queue_delayed_work_on+0x42/0x71
[    5.304127]  [<791e26db>] kobject_release+0x6a/0x72
[    5.304127]  [<791e2724>] kobject_put+0x41/0x46
[    5.304127]  [<791e278e>] kobject_del+0x25/0x2f
[    5.304127]  [<79331f66>] device_del+0x132/0x13e
[    5.304127]  [<79331f7d>] device_unregister+0xb/0x15
[    5.304127]  [<79331fd9>] device_destroy+0x2c/0x31
[    5.304127]  [<7928f4f8>] tty_unregister_device+0x1f/0x37
[    5.304127]  [<7929b9aa>] uart_remove_one_port+0x9a/0xe7
[    5.304127]  [<7929e030>] serial8250_register_8250_port+0xc1/0x235
[    5.304127]  [<7929e353>] serial8250_probe+0xfc/0x142
[    5.304127]  [<793356bc>] platform_drv_probe+0x29/0x4b
[    5.304127]  [<7933461f>] driver_probe_device+0x88/0x17b
[    5.304127]  [<7933472e>] __device_attach+0x1c/0x2c
[    5.304127]  [<79333118>] bus_for_each_drv+0x38/0x6b
[    5.304127]  [<7933455e>] device_attach+0x63/0x83
[    5.304127]  [<79334712>] ? driver_probe_device+0x17b/0x17b
[    5.304127]  [<79333cf2>] bus_probe_device+0x25/0x84
[    5.304127]  [<7933267a>] device_add+0x3ac/0x559
[    5.304127]  [<791e2be5>] ? kobject_set_name_vargs+0x3d/0x4a
[    5.304127]  [<79331676>] ? dev_set_name+0x14/0x16
[    5.304127]  [<7933551e>] platform_device_add+0x10f/0x173
[    5.304127]  [<793359d5>] platform_device_register+0x1c/0x1f
[    5.304127]  [<7989242e>] ? setup_early_serial8250_console+0x35d/0x35d
[    5.304127]  [<7989243b>] fourport_init+0xd/0xf
[    5.304127]  [<790003da>] do_one_initcall+0x6b/0xec
[    5.304127]  [<79875400>] ? do_early_param+0x62/0x75
[    5.304127]  [<790355b8>] ? parse_args+0x16a/0x20b
[    5.304127]  [<798759fc>] kernel_init_freeable+0xd8/0x15d
[    5.304127]  [<79517fd0>] kernel_init+0x8/0xb4
[    5.304127]  [<79529e77>] ret_from_kernel_thread+0x1b/0x28
[    5.304127]  [<79517fc8>] ? rest_init+0x118/0x118
[    5.304127] ---[ end trace c47ce39591a41369 ]---

git bisect start 5e8d1acd05687720cbb0b08975eacb7588fdfc42 v3.10 --
git bisect good 8cbd0eefcaf8cc32ded2bf229f0fc379b2ad69f2  # 15:38     55+  Merge branch 'next' of git://git.kernel.org/pub/scm/linux/kernel/git/rzhang/linux
git bisect good 60a2b977533c312d271563d955ef7b8e35a6aa38  # 16:37     55+  Merge remote-tracking branch 'infiniband/for-next'
git bisect  bad 4a225b466e040a70e7d12b159d2a36da1c2ef7dc  # 16:52      0-  next-20130821/driver-core
git bisect good 98246c1ae6f18fe1b710cdff687b6b7077f739c9  # 17:53     55+  Merge remote-tracking branch 'virtio/virtio-next'
git bisect good 38136c1f1471c7dcbe889beb790cc4d331e9d3ad  # 19:08     55+  Merge remote-tracking branch 'spi/for-next'
git bisect good dc098b35b56f83ae088e4291a4e389a6ff126965  # 21:55     55+  perf list: List kernel supplied event aliases
git bisect good 11d307c36abf44df12c3171692bd12e2ed47d291  # 00:56     55+  manual merge of x86/jumplabel
git bisect good 93d6294dfcdff81194086ed9bd6ceca3bc5e5863  # 04:00     55+  Merge remote-tracking branch 'kvm-ppc/kvm-ppc-next'
git bisect good c57e8c89b271af4ef914c439effffed53c39434c  # 04:39     55+  Merge remote-tracking branch 'leds/for-next'
git bisect  bad 76f411fb3a62711de7f59e0f4c56456fe356675a  # 04:48      0-  x86 / cpu topology: remove the stale macro arch_provides_topology_pointers
git bisect  bad d79fd03fd651bd91a081fc97f5f0d221557f8cbb  # 05:06      0-  video: backlight: lcd: convert class code to use dev_groups
git bisect good ac3785d5c15922c8a4c6b9e050a5bc59895a6b9b  # 05:53     55+  c2port: convert class code to use bin_attrs in groups
git bisect  bad 58b267d3e3f3ce87c3e559e4c330c8c03e905f5e  # 06:03      1-  dma: convert dma_devclass to use dev_groups
git bisect good 7c42721fe0c58a848849b43ff558cf2fb86aa35a  # 09:33     55+  char: tile-srom: fix build error
git bisect  bad c817a67ecba7c3c2aaa104796d78f160af60920d  # 09:40      0-  kobject: delayed kobject release: help find buggy drivers
git bisect good 7c42721fe0c58a848849b43ff558cf2fb86aa35a  # 10:28    165+  char: tile-srom: fix build error
git bisect  bad 245f08699d5320f021070ed8698ac89ebf2f0670  # 10:28      0-  Add linux-next specific files for 20130822
git bisect good 4bd5950280e4278c7f10726a53bdc9b6ad8dcd32  # 12:17    165+  Revert "kobject: delayed kobject release: help find buggy drivers"
git bisect good fa8218def1b1a16f0a410e2c1c767b4738cc81fa  # 13:50    165+  Merge tag 'regmap-v3.11-rc7' of git://git.kernel.org/pub/scm/linux/kernel/git/broonie/regmap
git bisect  bad e4a745f9519ef2bbb9d75212ae1cca7582d76266  # 14:02      2-  Add linux-next specific files for 20130827

Thanks,
Fengguang

--VbJkn9YxBvnuCH5J
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="dmesg-kvm-cairo-5533-20130827130110-3.11.0-rc7-00732-ge6ed952-87"
Content-Transfer-Encoding: quoted-printable

[    0.000000] Initializing cgroup subsys cpu
[    0.000000] Linux version 3.11.0-rc6-next-20130822-07070-g245f086 (kbuil=
d@jaketown) (gcc version 4.8.1 (Debian 4.8.1-8) ) #1 SMP Tue Aug 27 12:54:4=
0 CST 2013
[    0.000000] KERNEL supported cpus:
[    0.000000]   Transmeta GenuineTMx86
[    0.000000]   Transmeta TransmetaCPU
[    0.000000] CPU: vendor_id 'GenuineIntel' unknown, using generic init.
[    0.000000] CPU: Your system may be unstable.
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
[    0.000000] Scan for SMP in [mem 0x00000000-0x000003ff]
[    0.000000] Scan for SMP in [mem 0x0009fc00-0x0009ffff]
[    0.000000] Scan for SMP in [mem 0x000f0000-0x000fffff]
[    0.000000] found SMP MP-table at [mem 0x000fdab0-0x000fdabf] mapped at =
[780fdab0]
[    0.000000]   mpc: fdac0-fdbe4
[    0.000000] initial memory mapped: [mem 0x00000000-0x023fffff]
[    0.000000] Base memory trampoline at [7809b000] 9b000 size 16384
[    0.000000] init_memory_mapping: [mem 0x00000000-0x000fffff]
[    0.000000]  [mem 0x00000000-0x000fffff] page 4k
[    0.000000] init_memory_mapping: [mem 0x0e000000-0x0e3fffff]
[    0.000000]  [mem 0x0e000000-0x0e3fffff] page 2M
[    0.000000] init_memory_mapping: [mem 0x08000000-0x0dffffff]
[    0.000000]  [mem 0x08000000-0x0dffffff] page 2M
[    0.000000] init_memory_mapping: [mem 0x00100000-0x07ffffff]
[    0.000000]  [mem 0x00100000-0x003fffff] page 4k
[    0.000000]  [mem 0x00400000-0x07ffffff] page 2M
[    0.000000] init_memory_mapping: [mem 0x0e400000-0x0fffdfff]
[    0.000000]  [mem 0x0e400000-0x0fbfffff] page 2M
[    0.000000]  [mem 0x0fc00000-0x0fffdfff] page 4k
[    0.000000] BRK [0x01fa6000, 0x01fa6fff] PGTABLE
[    0.000000] cma: CMA: reserved 16 MiB at 0d400000
[    0.000000] log_buf_len: 8388608
[    0.000000] early log buf free: 128392(97%)
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
[    0.000000] BRK [0x01fa7000, 0x01fa7fff] PGTABLE
[    0.000000] Zone ranges:
[    0.000000]   Normal   [mem 0x00001000-0x0fffdfff]
[    0.000000]   HighMem  empty
[    0.000000] Movable zone start for each node
[    0.000000] Early memory node ranges
[    0.000000]   node   0: [mem 0x00001000-0x0009efff]
[    0.000000]   node   0: [mem 0x00100000-0x0fffdfff]
[    0.000000] On node 0 totalpages: 65436
[    0.000000] free_area_init_node: node 0, pgdat 7986f740, node_mem_map 86=
53f020
[    0.000000]   Normal zone: 512 pages used for memmap
[    0.000000]   Normal zone: 0 pages reserved
[    0.000000]   Normal zone: 65436 pages, LIFO batch:15
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
[    0.000000] PERCPU: Embedded 332 pages/cpu @84968000 s1338496 r0 d21376 =
u1359872
[    0.000000] pcpu-alloc: s1338496 r0 d21376 u1359872 alloc=3D332*4096
[    0.000000] pcpu-alloc: [0] 0 [0] 1=20
[    0.000000] kvm-clock: cpu 0, msr 0:fffd001, primary cpu clock
[    0.000000] KVM setup async PF for cpu 0
[    0.000000] kvm-stealtime: cpu 0, msr c96a700
[    0.000000] Built 1 zonelists in Zone order, mobility grouping on.  Tota=
l pages: 64924
[    0.000000] Kernel command line: hung_task_panic=3D1 rcutree.rcu_cpu_sta=
ll_timeout=3D100 log_buf_len=3D8M ignore_loglevel debug sched_debug apic=3D=
debug dynamic_printk sysrq_always_enabled panic=3D10  prompt_ramdisk=3D0 co=
nsole=3DttyS0,115200 console=3Dtty0 vga=3Dnormal  root=3D/dev/ram0 rw link=
=3D/kernel-tests/run-queue/kvm/i386-randconfig-j4-08271056/next:master/.vml=
inuz-245f08699d5320f021070ed8698ac89ebf2f0670-20130827125517-3-cairo branch=
=3Dnext/master  BOOT_IMAGE=3D/kernel/i386-randconfig-j4-08271056/245f08699d=
5320f021070ed8698ac89ebf2f0670/vmlinuz-3.11.0-rc6-next-20130822-07070-g245f=
086
[    0.000000] PID hash table entries: 1024 (order: 0, 4096 bytes)
[    0.000000] Dentry cache hash table entries: 32768 (order: 5, 131072 byt=
es)
[    0.000000] Inode-cache hash table entries: 16384 (order: 4, 65536 bytes)
[    0.000000] Initializing CPU#0
[    0.000000] allocated 524264 bytes of page_cgroup
[    0.000000] please try 'cgroup_disable=3Dmemory' option if you don't wan=
t memory cgroups
[    0.000000] Initializing HighMem for node 0 (00000000:00000000)
[    0.000000] Memory: 190324K/261744K available (5290K kernel code, 645K r=
wdata, 2716K rodata, 1600K init, 5716K bss, 71420K reserved, 0K highmem)
[    0.000000] virtual kernel memory layout:
[    0.000000]     fixmap  : 0xffe6c000 - 0xfffff000   (1612 kB)
[    0.000000]     pkmap   : 0xff800000 - 0xffc00000   (4096 kB)
[    0.000000]     vmalloc : 0x887fe000 - 0xff7fe000   (1904 MB)
[    0.000000]     lowmem  : 0x78000000 - 0x87ffe000   ( 255 MB)
[    0.000000]       .init : 0x79875000 - 0x79a05000   (1600 kB)
[    0.000000]       .data : 0x7952aca7 - 0x798744c0   (3366 kB)
[    0.000000]       .text : 0x79000000 - 0x7952aca7   (5291 kB)
[    0.000000] Checking if this processor honours the WP bit even in superv=
isor mode...Ok.
[    0.000000] SLUB: HWalign=3D64, Order=3D0-3, MinObjects=3D0, CPUs=3D2, N=
odes=3D1
[    0.000000] Hierarchical RCU implementation.
[    0.000000]=20
[    0.000000]=20
[    0.000000]=20
[    0.000000]=20
[    0.000000]=20
[    0.000000] NR_IRQS:2304 nr_irqs:56 16
[    0.000000] CPU 0 irqstacks, hard=3D78096000 soft=3D78080000
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
[    0.000000]  memory used by lock dependency info: 3823 kB
[    0.000000]  per task-struct memory footprint: 1920 bytes
[    0.000000] ------------------------
[    0.000000] | Locking API testsuite:
[    0.000000] ------------------------------------------------------------=
----------------
[    0.000000]                                  | spin |wlock |rlock |mutex=
 | wsem | rsem |
[    0.000000]   ----------------------------------------------------------=
----------------
[    0.000000]                      A-A deadlock:  ok  |  ok  |  ok  |  ok =
 |  ok  |  ok  |
[    0.000000]                  A-B-B-A deadlock:  ok  |  ok  |  ok  |  ok =
 |  ok  |  ok  |
[    0.000000]              A-B-B-C-C-A deadlock:  ok  |  ok  |  ok  |  ok =
 |  ok  |  ok  |
[    0.000000]              A-B-C-A-B-C deadlock:  ok  |  ok  |  ok  |  ok =
 |  ok  |  ok  |
[    0.000000]          A-B-B-C-C-D-D-A deadlock:  ok  |  ok  |  ok  |  ok =
 |  ok  |  ok  |
[    0.000000]          A-B-C-D-B-D-D-A deadlock:  ok  |  ok  |  ok  |  ok =
 |  ok  |  ok  |
[    0.000000]          A-B-C-D-B-C-D-A deadlock:  ok  |  ok  |  ok  |  ok =
 |  ok  |  ok  |
[    0.000000]                     double unlock:  ok  |  ok  |  ok  |  ok =
 |  ok  |  ok  |
[    0.000000]                   initialize held:  ok  |  ok  |  ok  |  ok =
 |  ok  |  ok  |
[    0.000000]                  bad unlock order:  ok  |  ok  |  ok  |  ok =
 |  ok  |  ok  |
[    0.000000]   ----------------------------------------------------------=
----------------
[    0.000000]               recursive read-lock:             |  ok  |     =
        |  ok  |
[    0.000000]            recursive read-lock #2:             |  ok  |     =
        |  ok  |
[    0.000000]             mixed read-write-lock:             |  ok  |     =
        |  ok  |
[    0.000000]             mixed write-read-lock:             |  ok  |     =
        |  ok  |
[    0.000000]   ----------------------------------------------------------=
----------------
[    0.000000]      hard-irqs-on + irq-safe-A/12:  ok  |  ok  |  ok  |
[    0.000000]      soft-irqs-on + irq-safe-A/12:  ok  |  ok  |  ok  |
[    0.000000]      hard-irqs-on + irq-safe-A/21:  ok  |  ok  |  ok  |
[    0.000000]      soft-irqs-on + irq-safe-A/21:  ok  |  ok  |  ok  |
[    0.000000]        sirq-safe-A =3D> hirqs-on/12:  ok  |  ok  |  ok  |
[    0.000000]        sirq-safe-A =3D> hirqs-on/21:  ok  |  ok  |  ok  |
[    0.000000]          hard-safe-A + irqs-on/12:  ok  |  ok  |  ok  |
[    0.000000]          soft-safe-A + irqs-on/12:  ok  |  ok  |  ok  |
[    0.000000]          hard-safe-A + irqs-on/21:  ok  |  ok  |  ok  |
[    0.000000]          soft-safe-A + irqs-on/21:  ok  |  ok  |  ok  |
[    0.000000]     hard-safe-A + unsafe-B #1/123:  ok  |  ok  |  ok  |
[    0.000000]     soft-safe-A + unsafe-B #1/123:  ok  |  ok  |  ok  |
[    0.000000]     hard-safe-A + unsafe-B #1/132:  ok  |  ok  |  ok  |
[    0.000000]     soft-safe-A + unsafe-B #1/132:  ok  |  ok  |  ok  |
[    0.000000]     hard-safe-A + unsafe-B #1/213:  ok  |  ok  |  ok  |
[    0.000000]     soft-safe-A + unsafe-B #1/213:  ok  |  ok  |  ok  |
[    0.000000]     hard-safe-A + unsafe-B #1/231:  ok  |  ok  |  ok  |
[    0.000000]     soft-safe-A + unsafe-B #1/231:  ok  |  ok  |  ok  |
[    0.000000]     hard-safe-A + unsafe-B #1/312:  ok  |  ok  |  ok  |
[    0.000000]     soft-safe-A + unsafe-B #1/312:  ok  |  ok  |  ok  |
[    0.000000]     hard-safe-A + unsafe-B #1/321:  ok  |  ok  |  ok  |
[    0.000000]     soft-safe-A + unsafe-B #1/321:  ok  |  ok  |  ok  |
[    0.000000]     hard-safe-A + unsafe-B #2/123:  ok  |  ok  |  ok  |
[    0.000000]     soft-safe-A + unsafe-B #2/123:  ok  |  ok  |  ok  |
[    0.000000]     hard-safe-A + unsafe-B #2/132:  ok  |  ok  |  ok  |
[    0.000000]     soft-safe-A + unsafe-B #2/132:  ok  |  ok  |  ok  |
[    0.000000]     hard-safe-A + unsafe-B #2/213:  ok  |  ok  |  ok  |
[    0.000000]     soft-safe-A + unsafe-B #2/213:  ok  |  ok  |  ok  |
[    0.000000]     hard-safe-A + unsafe-B #2/231:  ok  |  ok  |  ok  |
[    0.000000]     soft-safe-A + unsafe-B #2/231:  ok  |  ok  |  ok  |
[    0.000000]     hard-safe-A + unsafe-B #2/312:  ok  |  ok  |  ok  |
[    0.000000]     soft-safe-A + unsafe-B #2/312:  ok  |  ok  |  ok  |
[    0.000000]     hard-safe-A + unsafe-B #2/321:  ok  |  ok  |  ok  |
[    0.000000]     soft-safe-A + unsafe-B #2/321:  ok  |  ok  |  ok  |
[    0.000000]       hard-irq lock-inversion/123:  ok  |  ok  |  ok  |
[    0.000000]       soft-irq lock-inversion/123:  ok  |  ok  |  ok  |
[    0.000000]       hard-irq lock-inversion/132:  ok  |  ok  |  ok  |
[    0.000000]       soft-irq lock-inversion/132:  ok  |  ok  |  ok  |
[    0.000000]       hard-irq lock-inversion/213:  ok  |  ok  |  ok  |
[    0.000000]       soft-irq lock-inversion/213:  ok  |  ok  |  ok  |
[    0.000000]       hard-irq lock-inversion/231:  ok  |  ok  |  ok  |
[    0.000000]       soft-irq lock-inversion/231:  ok  |  ok  |  ok  |
[    0.000000]       hard-irq lock-inversion/312:  ok  |  ok  |  ok  |
[    0.000000]       soft-irq lock-inversion/312:  ok  |  ok  |  ok  |
[    0.000000]       hard-irq lock-inversion/321:  ok  |  ok  |  ok  |
[    0.000000]       soft-irq lock-inversion/321:  ok  |  ok  |  ok  |
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
[    0.000000]                ww contexts mixing:  ok  |  ok  |
[    0.000000]              finishing ww context:  ok  |  ok  |  ok  |  ok =
 |
[    0.000000]                locking mismatches:  ok  |  ok  |  ok  |
[    0.000000]                  EDEADLK handling:  ok  |  ok  |  ok  |  ok =
 |  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |
[    0.000000]            spinlock nest unlocked:  ok  |
[    0.000000]   -----------------------------------------------------
[    0.000000]                                  |block | try  |context|
[    0.000000]   -----------------------------------------------------
[    0.000000]                           context:  ok  |  ok  |  ok  |
[    0.000000]                               try:  ok  |  ok  |  ok  |
[    0.000000]                             block:  ok  |  ok  |  ok  |
[    0.000000]                          spinlock:  ok  |  ok  |  ok  |
[    0.000000] -------------------------------------------------------
[    0.000000] Good, all 253 testcases passed! |
[    0.000000] ---------------------------------
[    0.000000] hpet clockevent registered
[    0.000000] tsc: Detected 2893.116 MHz processor
[    0.000000] tsc: Marking TSC unstable due to TSCs unsynchronized
[    0.012000] Calibrating delay loop (skipped) preset value.. 5786.23 Bogo=
MIPS (lpj=3D11572464)
[    0.012000] pid_max: default: 4096 minimum: 301
[    0.012000] Mount-cache hash table entries: 512
[    0.012000] Initializing cgroup subsys memory
[    0.012047] Initializing cgroup subsys net_cls
[    0.012826] Last level iTLB entries: 4KB 0, 2MB 0, 4MB 0
[    0.012826] Last level dTLB entries: 4KB 0, 2MB 0, 4MB 0
[    0.012826] tlb_flushall_shift: -1
[    0.016147] Freeing SMP alternatives memory: 12K (79a05000 - 79a08000)
[    0.018337] ACPI: Core revision 20130725
[    0.028208] ACPI: All ACPI Tables successfully acquired
[    0.029217] Getting VERSION: 50014
[    0.029701] Getting VERSION: 50014
[    0.030319] Getting ID: 0
[    0.030824] Getting ID: f000000
[    0.031403] Getting LVT0: 8700
[    0.031918] Getting LVT1: 8400
[    0.032012] Enabling APIC mode:  Flat.  Using 1 I/O APICs
[    0.032897] enabled ExtINT on CPU#0
[    0.037442] ENABLING IO-APIC IRQs
[    0.038065] init IO_APIC IRQs
[    0.038556]  apic 0 pin 0 not connected
[    0.039130] IOAPIC[0]: Set routing entry (0-1 -> 0x31 -> IRQ 1 Mode:0 Ac=
tive:0 Dest:1)
[    0.040050] IOAPIC[0]: Set routing entry (0-2 -> 0x30 -> IRQ 0 Mode:0 Ac=
tive:0 Dest:1)
[    0.041523] IOAPIC[0]: Set routing entry (0-3 -> 0x33 -> IRQ 3 Mode:0 Ac=
tive:0 Dest:1)
[    0.042838] IOAPIC[0]: Set routing entry (0-4 -> 0x34 -> IRQ 4 Mode:0 Ac=
tive:0 Dest:1)
[    0.044043] IOAPIC[0]: Set routing entry (0-5 -> 0x35 -> IRQ 5 Mode:1 Ac=
tive:0 Dest:1)
[    0.045465] IOAPIC[0]: Set routing entry (0-6 -> 0x36 -> IRQ 6 Mode:0 Ac=
tive:0 Dest:1)
[    0.046771] IOAPIC[0]: Set routing entry (0-7 -> 0x37 -> IRQ 7 Mode:0 Ac=
tive:0 Dest:1)
[    0.048039] IOAPIC[0]: Set routing entry (0-8 -> 0x38 -> IRQ 8 Mode:0 Ac=
tive:0 Dest:1)
[    0.049451] IOAPIC[0]: Set routing entry (0-9 -> 0x39 -> IRQ 9 Mode:1 Ac=
tive:0 Dest:1)
[    0.050656] IOAPIC[0]: Set routing entry (0-10 -> 0x3a -> IRQ 10 Mode:1 =
Active:0 Dest:1)
[    0.052036] IOAPIC[0]: Set routing entry (0-11 -> 0x3b -> IRQ 11 Mode:1 =
Active:0 Dest:1)
[    0.053200] IOAPIC[0]: Set routing entry (0-12 -> 0x3c -> IRQ 12 Mode:0 =
Active:0 Dest:1)
[    0.056043] IOAPIC[0]: Set routing entry (0-13 -> 0x3d -> IRQ 13 Mode:0 =
Active:0 Dest:1)
[    0.057495] IOAPIC[0]: Set routing entry (0-14 -> 0x3e -> IRQ 14 Mode:0 =
Active:0 Dest:1)
[    0.060036] IOAPIC[0]: Set routing entry (0-15 -> 0x3f -> IRQ 15 Mode:0 =
Active:0 Dest:1)
[    0.061203]  apic 0 pin 16 not connected
[    0.061783]  apic 0 pin 17 not connected
[    0.062471]  apic 0 pin 18 not connected
[    0.063107]  apic 0 pin 19 not connected
[    0.063644]  apic 0 pin 20 not connected
[    0.064009]  apic 0 pin 21 not connected
[    0.064541]  apic 0 pin 22 not connected
[    0.065078]  apic 0 pin 23 not connected
[    0.065783] ..TIMER: vector=3D0x30 apic1=3D0 pin1=3D2 apic2=3D-1 pin2=3D=
-1
[    0.068007] smpboot: CPU0: GenuineIntel Common KVM processor (fam: 0f, m=
odel: 06, stepping: 01)
[    0.072745] Using local APIC timer interrupts.
[    0.072745] calibrating APIC timer ...
[    0.080000] ... lapic delta =3D 7262952
[    0.080000] ... PM-Timer delta =3D 465307
[    0.080000] APIC calibration not consistent with PM-Timer: 129ms instead=
 of 100ms
[    0.080000] APIC delta adjusted to PM-Timer: 5587284 (7262952)
[    0.080000] TSC delta adjusted to PM-Timer: 289309428 (376075424)
[    0.080000] ..... delta 5587284
[    0.080000] ..... mult: 239972020
[    0.080000] ..... calibration result: 3575861
[    0.080000] ..... CPU clock speed is 2893.0377 MHz.
[    0.080000] ..... host bus clock speed is 893.3861 MHz.
[    0.080121] Performance Events:=20
[    0.081886] NMI watchdog: disabled (cpu0): hardware events not enabled

[    0.084281] SMP alternatives: lockdep: fixing up alternatives
[    0.085479] CPU 1 irqstacks, hard=3D78104000 soft=3D78106000
[    0.088007] smpboot: Booting Node   0, Processors  #1 OK
[    0.008000] Initializing CPU#1
[    0.012000] kvm-clock: cpu 1, msr 0:fffd041, secondary cpu clock
[    0.012000] masked ExtINT on CPU#1
[    0.114455] Brought up 2 CPUs
[    0.114369] KVM setup async PF for cpu 1
[    0.114369] kvm-stealtime: cpu 1, msr cab6700
[    0.116013] ----------------
[    0.116384] | NMI testsuite:
[    0.116740] --------------------
[    0.117138]   remote IPI:  ok  |
[    0.120234]    local IPI:  ok  |
[    0.128030] --------------------
[    0.128441] Good, all   2 testcases passed! |
[    0.128982] ---------------------------------
[    0.129513] smpboot: Total of 2 processors activated (11572.46 BogoMIPS)
[    0.132030] devtmpfs: initialized
[    0.134409] regulator-dummy: no parameters
[    0.135323] NET: Registered protocol family 16
[    0.136779] EISA bus registered
[    0.137194] cpuidle: using governor menu
[    0.138223] ACPI: bus type PCI registered
[    0.138764] dca service started, version 1.12.1
[    0.140172] PCI: PCI BIOS revision 2.10 entry at 0xfc6d5, last bus=3D0
[    0.140938] PCI: Using configuration type 1 for base access
[    0.156354] bio: create slab <bio-0> at 0
[    0.160067] ACPI: Added _OSI(Module Device)
[    0.160596] ACPI: Added _OSI(Processor Device)
[    0.161134] ACPI: Added _OSI(3.0 _SCP Extensions)
[    0.161708] ACPI: Added _OSI(Processor Aggregator Device)
[    0.166068] ACPI: EC: Look up EC in DSDT
[    0.177829] ACPI: Interpreter enabled
[    0.178315] ACPI: (supports S0 S5)
[    0.178734] ACPI: Using IOAPIC for interrupt routing
[    0.179374] PCI: Using host bridge windows from ACPI; if necessary, use =
"pci=3Dnocrs" and report a bug
[    0.185516] ACPI: No dock devices found.
[    0.208639] ACPI: PCI Root Bridge [PCI0] (domain 0000 [bus 00-ff])
[    0.212579] acpi PNP0A03:00: fail to add MMCONFIG information, can't acc=
ess extended PCI configuration space under this bridge.
[    0.214200] PCI host bridge to bus 0000:00
[    0.214710] pci_bus 0000:00: root bus resource [bus 00-ff]
[    0.216007] pci_bus 0000:00: root bus resource [io  0x0000-0x0cf7]
[    0.216766] pci_bus 0000:00: root bus resource [io  0x0d00-0xffff]
[    0.217515] pci_bus 0000:00: root bus resource [mem 0x000a0000-0x000bfff=
f]
[    0.218338] pci_bus 0000:00: root bus resource [mem 0x80000000-0xfebffff=
f]
[    0.220092] pci 0000:00:00.0: [8086:1237] type 00 class 0x060000
[    0.221701] pci 0000:00:01.0: [8086:7000] type 00 class 0x060100
[    0.223111] pci 0000:00:01.1: [8086:7010] type 00 class 0x010180
[    0.232008] pci 0000:00:01.1: reg 0x20: [io  0xc1e0-0xc1ef]
[    0.234880] pci 0000:00:01.3: [8086:7113] type 00 class 0x068000
[    0.236489] pci 0000:00:01.3: quirk: [io  0xb000-0xb03f] claimed by PIIX=
4 ACPI
[    0.237402] pci 0000:00:01.3: quirk: [io  0xb100-0xb10f] claimed by PIIX=
4 SMB
[    0.240629] pci 0000:00:02.0: [1013:00b8] type 00 class 0x030000
[    0.244921] pci 0000:00:02.0: reg 0x10: [mem 0xfc000000-0xfdffffff pref]
[    0.248899] pci 0000:00:02.0: reg 0x14: [mem 0xfebe0000-0xfebe0fff]
[    0.258707] pci 0000:00:02.0: reg 0x30: [mem 0xfebc0000-0xfebcffff pref]
[    0.260396] pci 0000:00:03.0: [1af4:1000] type 00 class 0x020000
[    0.264008] pci 0000:00:03.0: reg 0x10: [io  0xc1c0-0xc1df]
[    0.268784] pci 0000:00:03.0: reg 0x14: [mem 0xfebe1000-0xfebe1fff]
[    0.284009] pci 0000:00:03.0: reg 0x30: [mem 0xfebd0000-0xfebdffff pref]
[    0.285537] pci 0000:00:04.0: [8086:100e] type 00 class 0x020000
[    0.288008] pci 0000:00:04.0: reg 0x10: [mem 0xfeb80000-0xfeb9ffff]
[    0.293693] pci 0000:00:04.0: reg 0x14: [io  0xc000-0xc03f]
[    0.316007] pci 0000:00:04.0: reg 0x30: [mem 0xfeba0000-0xfebbffff pref]
[    0.317447] pci 0000:00:05.0: [1af4:1001] type 00 class 0x010000
[    0.324007] pci 0000:00:05.0: reg 0x10: [io  0xc040-0xc07f]
[    0.326492] pci 0000:00:05.0: reg 0x14: [mem 0xfebe2000-0xfebe2fff]
[    0.348779] pci 0000:00:06.0: [1af4:1001] type 00 class 0x010000
[    0.356007] pci 0000:00:06.0: reg 0x10: [io  0xc080-0xc0bf]
[    0.358264] pci 0000:00:06.0: reg 0x14: [mem 0xfebe3000-0xfebe3fff]
[    0.376701] pci 0000:00:07.0: [1af4:1001] type 00 class 0x010000
[    0.384007] pci 0000:00:07.0: reg 0x10: [io  0xc0c0-0xc0ff]
[    0.389567] pci 0000:00:07.0: reg 0x14: [mem 0xfebe4000-0xfebe4fff]
[    0.400810] pci 0000:00:08.0: [1af4:1001] type 00 class 0x010000
[    0.404008] pci 0000:00:08.0: reg 0x10: [io  0xc100-0xc13f]
[    0.406740] pci 0000:00:08.0: reg 0x14: [mem 0xfebe5000-0xfebe5fff]
[    0.416725] pci 0000:00:09.0: [1af4:1001] type 00 class 0x010000
[    0.420008] pci 0000:00:09.0: reg 0x10: [io  0xc140-0xc17f]
[    0.422475] pci 0000:00:09.0: reg 0x14: [mem 0xfebe6000-0xfebe6fff]
[    0.433490] pci 0000:00:0a.0: [1af4:1001] type 00 class 0x010000
[    0.436007] pci 0000:00:0a.0: reg 0x10: [io  0xc180-0xc1bf]
[    0.438259] pci 0000:00:0a.0: reg 0x14: [mem 0xfebe7000-0xfebe7fff]
[    0.450486] pci 0000:00:0b.0: [8086:25ab] type 00 class 0x088000
[    0.452427] pci 0000:00:0b.0: reg 0x10: [mem 0xfebe8000-0xfebe800f]
[    0.459137] pci_bus 0000:00: on NUMA node 0
[    0.460011] acpi PNP0A03:00: Unable to request _OSC control (_OSC suppor=
t mask: 0x08)
[    0.462978] ACPI: PCI Interrupt Link [LNKA] (IRQs 5 *10 11)
[    0.464566] ACPI: PCI Interrupt Link [LNKB] (IRQs 5 *10 11)
[    0.465712] ACPI: PCI Interrupt Link [LNKC] (IRQs 5 10 *11)
[    0.466858] ACPI: PCI Interrupt Link [LNKD] (IRQs 5 10 *11)
[    0.468415] ACPI: PCI Interrupt Link [LNKS] (IRQs *9)
[    0.470364] ACPI: Enabled 16 GPEs in block 00 to 0F
[    0.471062] ACPI: \_SB_.PCI0: notify handler is installed
[    0.472218] Found 1 acpi root devices
[    0.476124] vgaarb: device added: PCI:0000:00:02.0,decodes=3Dio+mem,owns=
=3Dio+mem,locks=3Dnone
[    0.477148] vgaarb: loaded
[    0.477491] vgaarb: bridge control possible 0000:00:02.0
[    0.480544] media: Linux media interface: v0.10
[    0.481148] Linux video capture interface: v2.00
[    0.481762] pps_core: LinuxPPS API ver. 1 registered
[    0.484005] pps_core: Software ver. 5.3.6 - Copyright 2005-2007 Rodolfo =
Giometti <giometti@linux.it>
[    0.485177] PTP clock support registered
[    0.488053] EDAC MC: Ver: 3.0.0
[    0.492195] wmi: Mapper loaded
[    0.496033] PCI: Using ACPI for IRQ routing
[    0.496566] PCI: pci_cache_line_size set to 64 bytes
[    0.497474] e820: reserve RAM buffer [mem 0x0009fc00-0x0009ffff]
[    0.498233] e820: reserve RAM buffer [mem 0x0fffe000-0x0fffffff]
[    0.508082] cfg80211: Calling CRDA to update world regulatory domain
[    0.512221] Switched to clocksource kvm-clock
[    0.513096] FS-Cache: Loaded
[    0.513502] pnp: PnP ACPI init
[    0.513936] ACPI: bus type PNP registered
[    0.514526] IOAPIC[0]: Set routing entry (0-8 -> 0x38 -> IRQ 8 Mode:0 Ac=
tive:0 Dest:3)
[    0.515574] pnp 00:00: Plug and Play ACPI device, IDs PNP0b00 (active)
[    0.516371] IOAPIC[0]: Set routing entry (0-1 -> 0x31 -> IRQ 1 Mode:0 Ac=
tive:0 Dest:3)
[    0.517459] pnp 00:01: Plug and Play ACPI device, IDs PNP0303 (active)
[    0.518322] IOAPIC[0]: Set routing entry (0-12 -> 0x3c -> IRQ 12 Mode:0 =
Active:0 Dest:3)
[    0.519414] pnp 00:02: Plug and Play ACPI device, IDs PNP0f13 (active)
[    0.530701] IOAPIC[0]: Set routing entry (0-6 -> 0x36 -> IRQ 6 Mode:0 Ac=
tive:0 Dest:3)
[    0.531874] pnp 00:03: [dma 2]
[    0.532456] pnp 00:03: Plug and Play ACPI device, IDs PNP0700 (active)
[    0.533479] IOAPIC[0]: Set routing entry (0-7 -> 0x37 -> IRQ 7 Mode:0 Ac=
tive:0 Dest:3)
[    0.534648] pnp 00:04: Plug and Play ACPI device, IDs PNP0400 (active)
[    0.535581] IOAPIC[0]: Set routing entry (0-4 -> 0x34 -> IRQ 4 Mode:0 Ac=
tive:0 Dest:3)
[    0.536716] pnp 00:05: Plug and Play ACPI device, IDs PNP0501 (active)
[    0.538168] pnp 00:06: Plug and Play ACPI device, IDs PNP0103 (active)
[    0.539454] pnp: PnP ACPI: found 7 devices
[    0.540071] ACPI: bus type PNP unregistered
[    0.550747] PnPBIOS: Disabled
[    0.597291] pci_bus 0000:00: resource 4 [io  0x0000-0x0cf7]
[    0.598114] pci_bus 0000:00: resource 5 [io  0x0d00-0xffff]
[    0.598840] pci_bus 0000:00: resource 6 [mem 0x000a0000-0x000bffff]
[    0.599659] pci_bus 0000:00: resource 7 [mem 0x80000000-0xfebfffff]
[    0.600672] NET: Registered protocol family 2
[    0.601705] TCP established hash table entries: 2048 (order: 2, 16384 by=
tes)
[    0.602716] TCP bind hash table entries: 2048 (order: 4, 90112 bytes)
[    0.604163] TCP: Hash tables configured (established 2048 bind 2048)
[    0.605095] TCP: reno registered
[    0.605533] UDP hash table entries: 128 (order: 1, 12288 bytes)
[    0.606420] UDP-Lite hash table entries: 128 (order: 1, 12288 bytes)
[    0.607518] NET: Registered protocol family 1
[    0.608152] pci 0000:00:00.0: Limiting direct PCI/PCI transfers
[    0.608933] pci 0000:00:01.0: PIIX3: Enabling Passive Release
[    0.609706] pci 0000:00:01.0: Activating ISA DMA hang workarounds
[    0.610750] pci 0000:00:02.0: Boot video device
[    0.611497] PCI: CLS 0 bytes, default 64
[    0.612482] Unpacking initramfs...
[    2.781386] Freeing initrd memory: 25284K (8673f000 - 87ff0000)
[    2.820080] DMA-API: preallocated 65536 debug entries
[    2.820801] DMA-API: debugging enabled by kernel config
[    2.830450] cryptomgr_test (32) used greatest stack depth: 7040 bytes le=
ft
[    2.836124] modprobe (42) used greatest stack depth: 6632 bytes left
[    2.839946] cryptomgr_test (39) used greatest stack depth: 6428 bytes le=
ft
[    2.841578] PCLMULQDQ-NI instructions are not detected.
[    2.842733] audit: initializing netlink socket (disabled)
[    2.843467] type=3D2000 audit(1377579650.944:1): initialized
[    2.910478] HugeTLB registered 4 MB page size, pre-allocated 0 pages
[    2.915779] VFS: Disk quotas dquot_6.5.2
[    2.916458] Dquot-cache hash table entries: 1024 (order 0, 4096 bytes)
[    2.919103] QNX4 filesystem 0.2.3 registered.
[    2.920140] OCFS2 1.5.0
[    2.920871] ocfs2 stack glue: unable to register sysctl
[    2.921565] OCFS2 DLMFS 1.5.0
[    2.922219] OCFS2 User DLM kernel interface loaded
[    2.922854] OCFS2 Node Manager 1.5.0
[    2.923960] msgmni has been set to 453
[    2.932050] cryptomgr_test (66) used greatest stack depth: 6108 bytes le=
ft
[    2.935337] alg: No test for crc32 (crc32-table)
[    2.936177] alg: No test for lz4 (lz4-generic)
[    2.936850] alg: No test for stdrng (krng)
[    2.980506] alg: No test for fips(ansi_cprng) (fips_ansi_cprng)
[    2.982377] NET: Registered protocol family 38
[    2.983133] Block layer SCSI generic (bsg) driver version 0.4 loaded (ma=
jor 251)
[    2.984130] io scheduler noop registered (default)
[    2.986567] list_sort_test: start testing list_sort()
[    2.987686] rbtree testing -> 25192 cycles
[    3.896520] augmented rbtree testing -> 37397 cycles
[    5.236799] pci_hotplug: PCI Hot Plug PCI Core version: 0.5
[    5.237871] rivafb_setup START
[    5.239587] cirrusfb 0000:00:02.0: Cirrus Logic chipset on PCI bus, RAM =
(4096 kB) at 0xfc000000
[    5.270568] ioatdma: Intel(R) QuickData Technology Driver 4.00
[    5.272179] r3964: Philips r3964 Driver $Revision: 1.10 $
[    5.272919] Serial: 8250/16550 driver, 4 ports, IRQ sharing disabled
[    5.296332] 00:05: ttyS0 at I/O 0x3f8 (irq =3D 4, base_baud =3D 115200) =
is a 16550A
[    5.300948] ------------[ cut here ]------------
[    5.301612] WARNING: CPU: 0 PID: 1 at lib/list_debug.c:33 __list_add+0x4=
4/0x78()
[    5.302790] list_add corruption. prev->next should be next (79a162d8), b=
ut was   (null). (prev=3D87b10ce8).
[    5.304127] Modules linked in:
[    5.304127] CPU: 0 PID: 1 Comm: swapper/0 Not tainted 3.11.0-rc6-next-20=
130822-07070-g245f086 #1
[    5.304127]  00000000 00000000 78049b7c 7951d86a 79724a8f 78049b94 79022=
c48 791fb32e
[    5.304127]  87b10ce8 79a162d8 87b79888 78049bac 79022c85 00000009 78049=
ba4 79724a8f
[    5.304127]  78049bc0 78049bd8 791fb32e 79724a65 00000021 79724a8f 79a16=
2d8 00000000
[    5.304127] Call Trace:
[    5.304127]  [<7951d86a>] dump_stack+0x4b/0x66
[    5.304127]  [<79022c48>] warn_slowpath_common+0x5c/0x73
[    5.304127]  [<791fb32e>] ? __list_add+0x44/0x78
[    5.304127]  [<79022c85>] warn_slowpath_fmt+0x26/0x2a
[    5.304127]  [<791fb32e>] __list_add+0x44/0x78
[    5.304127]  [<79028bb8>] __internal_add_timer+0x97/0x9b
[    5.304127]  [<79028bca>] internal_add_timer+0xe/0x26
[    5.304127]  [<79028e13>] __mod_timer+0xa2/0xb7
[    5.304127]  [<79028f3b>] mod_timer+0x5d/0x6c
[    5.304127]  [<79028f5c>] add_timer+0x12/0x14
[    5.304127]  [<79030eb5>] __queue_delayed_work+0xca/0xe4
[    5.304127]  [<79032361>] queue_delayed_work_on+0x42/0x71
[    5.304127]  [<791e26db>] kobject_release+0x6a/0x72
[    5.304127]  [<791e2724>] kobject_put+0x41/0x46
[    5.304127]  [<791e278e>] kobject_del+0x25/0x2f
[    5.304127]  [<79331f66>] device_del+0x132/0x13e
[    5.304127]  [<79331f7d>] device_unregister+0xb/0x15
[    5.304127]  [<79331fd9>] device_destroy+0x2c/0x31
[    5.304127]  [<7928f4f8>] tty_unregister_device+0x1f/0x37
[    5.304127]  [<7929b9aa>] uart_remove_one_port+0x9a/0xe7
[    5.304127]  [<7929e030>] serial8250_register_8250_port+0xc1/0x235
[    5.304127]  [<7929e353>] serial8250_probe+0xfc/0x142
[    5.304127]  [<793356bc>] platform_drv_probe+0x29/0x4b
[    5.304127]  [<7933461f>] driver_probe_device+0x88/0x17b
[    5.304127]  [<7933472e>] __device_attach+0x1c/0x2c
[    5.304127]  [<79333118>] bus_for_each_drv+0x38/0x6b
[    5.304127]  [<7933455e>] device_attach+0x63/0x83
[    5.304127]  [<79334712>] ? driver_probe_device+0x17b/0x17b
[    5.304127]  [<79333cf2>] bus_probe_device+0x25/0x84
[    5.304127]  [<7933267a>] device_add+0x3ac/0x559
[    5.304127]  [<791e2be5>] ? kobject_set_name_vargs+0x3d/0x4a
[    5.304127]  [<79331676>] ? dev_set_name+0x14/0x16
[    5.304127]  [<7933551e>] platform_device_add+0x10f/0x173
[    5.304127]  [<793359d5>] platform_device_register+0x1c/0x1f
[    5.304127]  [<7989242e>] ? setup_early_serial8250_console+0x35d/0x35d
[    5.304127]  [<7989243b>] fourport_init+0xd/0xf
[    5.304127]  [<790003da>] do_one_initcall+0x6b/0xec
[    5.304127]  [<79875400>] ? do_early_param+0x62/0x75
[    5.304127]  [<790355b8>] ? parse_args+0x16a/0x20b
[    5.304127]  [<798759fc>] kernel_init_freeable+0xd8/0x15d
[    5.304127]  [<79517fd0>] kernel_init+0x8/0xb4
[    5.304127]  [<79529e77>] ret_from_kernel_thread+0x1b/0x28
[    5.304127]  [<79517fc8>] ? rest_init+0x118/0x118
[    5.304127] ---[ end trace c47ce39591a41369 ]---
[    5.342645] ------------[ cut here ]------------
[    5.343245] WARNING: CPU: 0 PID: 1 at include/linux/kref.h:47 kobject_ge=
t+0x30/0x3c()
[    5.344604] Modules linked in:
[    5.345057] CPU: 0 PID: 1 Comm: swapper/0 Tainted: G        W    3.11.0-=
rc6-next-20130822-07070-g245f086 #1
[    5.346487]  00000000 00000000 78049b6c 7951d86a 00000000 78049b84 79022=
c48 791e2833
[    5.348195]  87b79840 87b12800 79806684 78049b94 79022cc3 00000009 00000=
000 78049ba0
[    5.349738]  791e2833 87b12800 78049bb4 79332090 87b12800 ffffffea 00000=
000 78049bf0
[    5.351004] Call Trace:
[    5.351360]  [<7951d86a>] dump_stack+0x4b/0x66
[    5.352102]  [<79022c48>] warn_slowpath_common+0x5c/0x73
[    5.353032]  [<791e2833>] ? kobject_get+0x30/0x3c
[    5.353852]  [<79022cc3>] warn_slowpath_null+0xf/0x13
[    5.354497]  [<791e2833>] kobject_get+0x30/0x3c
[    5.355046]  [<79332090>] get_device_parent+0x82/0x134
[    5.355864]  [<79332381>] device_add+0xb3/0x559
[    5.356532]  [<79036f31>] ? __init_waitqueue_head+0x29/0x3b
[    5.357215]  [<79339a3c>] ? pm_runtime_init+0xdf/0xe6
[    5.357863]  [<79332839>] device_register+0x12/0x15
[    5.358719]  [<7928fa57>] tty_register_device_attr+0x13c/0x17c
[    5.359533]  [<7902652c>] ? free_resource+0x57/0x5a
[    5.360375]  [<790265a8>] ? __release_region+0x79/0xa7
[    5.361068]  [<7929dc05>] ? serial8250_release_std_resource+0x66/0x6a
[    5.361883]  [<792969b6>] tty_port_register_device_attr+0x20/0x27
[    5.362638]  [<7929b8a7>] uart_add_one_port+0x28b/0x2f4
[    5.363340]  [<7905592b>] ? trace_hardirqs_on_caller+0x12a/0x17e
[    5.364252]  [<79522b38>] ? __mutex_unlock_slowpath+0x11c/0x124
[    5.364989]  [<79522b48>] ? mutex_unlock+0x8/0xa
[    5.365579]  [<7929b9ed>] ? uart_remove_one_port+0xdd/0xe7
[    5.366450]  [<7929e17f>] serial8250_register_8250_port+0x210/0x235
[    5.367523]  [<7929e353>] serial8250_probe+0xfc/0x142
[    5.368375]  [<793356bc>] platform_drv_probe+0x29/0x4b
[    5.369049]  [<7933461f>] driver_probe_device+0x88/0x17b
[    5.369957]  [<7933472e>] __device_attach+0x1c/0x2c
[    5.370702]  [<79333118>] bus_for_each_drv+0x38/0x6b
[    5.371562]  [<7933455e>] device_attach+0x63/0x83
[    5.372446]  [<79334712>] ? driver_probe_device+0x17b/0x17b
[    5.373221]  [<79333cf2>] bus_probe_device+0x25/0x84
[    5.373934]  [<7933267a>] device_add+0x3ac/0x559
[    5.374546]  [<791e2be5>] ? kobject_set_name_vargs+0x3d/0x4a
[    5.375226]  [<79331676>] ? dev_set_name+0x14/0x16
[    5.375892]  [<7933551e>] platform_device_add+0x10f/0x173
[    5.376895]  [<793359d5>] platform_device_register+0x1c/0x1f
[    5.377734]  [<7989242e>] ? setup_early_serial8250_console+0x35d/0x35d
[    5.378819]  [<7989243b>] fourport_init+0xd/0xf
[    5.379670]  [<790003da>] do_one_initcall+0x6b/0xec
[    5.380567]  [<79875400>] ? do_early_param+0x62/0x75
[    5.381182]  [<790355b8>] ? parse_args+0x16a/0x20b
[    5.381773]  [<798759fc>] kernel_init_freeable+0xd8/0x15d
[    5.382503]  [<79517fd0>] kernel_init+0x8/0xb4
[    5.383092]  [<79529e77>] ret_from_kernel_thread+0x1b/0x28
[    5.383854]  [<79517fc8>] ? rest_init+0x118/0x118
[    5.384509] ---[ end trace c47ce39591a4136a ]---
[    5.385988] ------------[ cut here ]------------
[    5.386766] WARNING: CPU: 0 PID: 1 at lib/list_debug.c:33 __list_add+0x4=
4/0x78()
[    5.388166] list_add corruption. prev->next should be next (79a162e0), b=
ut was   (null). (prev=3D87b10ce8).
[    5.388497] Modules linked in:
[    5.388497] CPU: 0 PID: 1 Comm: swapper/0 Tainted: G        W    3.11.0-=
rc6-next-20130822-07070-g245f086 #1
[    5.388497]  00000000 00000000 78049b7c 7951d86a 79724a8f 78049b94 79022=
c48 791fb32e
[    5.388497]  87b10ce8 79a162e0 87b79888 78049bac 79022c85 00000009 78049=
ba4 79724a8f
[    5.388497]  78049bc0 78049bd8 791fb32e 79724a65 00000021 79724a8f 79a16=
2e0 00000000
[    5.388497] Call Trace:
[    5.388497]  [<7951d86a>] dump_stack+0x4b/0x66
[    5.388497]  [<79022c48>] warn_slowpath_common+0x5c/0x73
[    5.388497]  [<791fb32e>] ? __list_add+0x44/0x78
[    5.388497]  [<79022c85>] warn_slowpath_fmt+0x26/0x2a
[    5.388497]  [<791fb32e>] __list_add+0x44/0x78
[    5.388497]  [<79028bb8>] __internal_add_timer+0x97/0x9b
[    5.388497]  [<79028bca>] internal_add_timer+0xe/0x26
[    5.388497]  [<79028e13>] __mod_timer+0xa2/0xb7
[    5.388497]  [<79028f3b>] mod_timer+0x5d/0x6c
[    5.388497]  [<79028f5c>] add_timer+0x12/0x14
[    5.388497]  [<79030eb5>] __queue_delayed_work+0xca/0xe4
[    5.388497]  [<79032361>] queue_delayed_work_on+0x42/0x71
[    5.388497]  [<791e26db>] kobject_release+0x6a/0x72
[    5.388497]  [<791e2724>] kobject_put+0x41/0x46
[    5.388497]  [<791e278e>] kobject_del+0x25/0x2f
[    5.388497]  [<79331f66>] device_del+0x132/0x13e
[    5.388497]  [<79331f7d>] device_unregister+0xb/0x15
[    5.388497]  [<79331fd9>] device_destroy+0x2c/0x31
[    5.388497]  [<7928f4f8>] tty_unregister_device+0x1f/0x37
[    5.388497]  [<7929b9aa>] uart_remove_one_port+0x9a/0xe7
[    5.388497]  [<7929e030>] serial8250_register_8250_port+0xc1/0x235
[    5.388497]  [<7929e353>] serial8250_probe+0xfc/0x142
[    5.388497]  [<793356bc>] platform_drv_probe+0x29/0x4b
[    5.388497]  [<7933461f>] driver_probe_device+0x88/0x17b
[    5.388497]  [<7933472e>] __device_attach+0x1c/0x2c
[    5.388497]  [<79333118>] bus_for_each_drv+0x38/0x6b
[    5.388497]  [<7933455e>] device_attach+0x63/0x83
[    5.388497]  [<79334712>] ? driver_probe_device+0x17b/0x17b
[    5.388497]  [<79333cf2>] bus_probe_device+0x25/0x84
[    5.388497]  [<7933267a>] device_add+0x3ac/0x559
[    5.388497]  [<791e2be5>] ? kobject_set_name_vargs+0x3d/0x4a
[    5.388497]  [<79331676>] ? dev_set_name+0x14/0x16
[    5.388497]  [<7933551e>] platform_device_add+0x10f/0x173
[    5.388497]  [<793359d5>] platform_device_register+0x1c/0x1f
[    5.388497]  [<7989242e>] ? setup_early_serial8250_console+0x35d/0x35d
[    5.388497]  [<7989243b>] fourport_init+0xd/0xf
[    5.388497]  [<790003da>] do_one_initcall+0x6b/0xec
[    5.388497]  [<79875400>] ? do_early_param+0x62/0x75
[    5.388497]  [<790355b8>] ? parse_args+0x16a/0x20b
[    5.388497]  [<798759fc>] kernel_init_freeable+0xd8/0x15d
[    5.388497]  [<79517fd0>] kernel_init+0x8/0xb4
[    5.388497]  [<79529e77>] ret_from_kernel_thread+0x1b/0x28
[    5.388497]  [<79517fc8>] ? rest_init+0x118/0x118
[    5.388497] ---[ end trace c47ce39591a4136b ]---
[    5.429136] ------------[ cut here ]------------
[    5.429920] WARNING: CPU: 0 PID: 1 at lib/list_debug.c:33 __list_add+0x4=
4/0x78()
[    5.431517] list_add corruption. prev->next should be next (79a162e0), b=
ut was   (null). (prev=3D87b10ce8).
[    5.432684] Modules linked in:
[    5.432684] CPU: 0 PID: 1 Comm: swapper/0 Tainted: G        W    3.11.0-=
rc6-next-20130822-07070-g245f086 #1
[    5.432684]  00000000 00000000 78049b7c 7951d86a 79724a8f 78049b94 79022=
c48 791fb32e
[    5.432684]  87b10ce8 79a162e0 87b79888 78049bac 79022c85 00000009 78049=
ba4 79724a8f
[    5.432684]  78049bc0 78049bd8 791fb32e 79724a65 00000021 79724a8f 79a16=
2e0 00000000
[    5.432684] Call Trace:
[    5.432684]  [<7951d86a>] dump_stack+0x4b/0x66
[    5.432684]  [<79022c48>] warn_slowpath_common+0x5c/0x73
[    5.432684]  [<791fb32e>] ? __list_add+0x44/0x78
[    5.432684]  [<79022c85>] warn_slowpath_fmt+0x26/0x2a
[    5.432684]  [<791fb32e>] __list_add+0x44/0x78
[    5.432684]  [<79028bb8>] __internal_add_timer+0x97/0x9b
[    5.432684]  [<79028bca>] internal_add_timer+0xe/0x26
[    5.432684]  [<79028e13>] __mod_timer+0xa2/0xb7
[    5.432684]  [<79028f3b>] mod_timer+0x5d/0x6c
[    5.432684]  [<79028f5c>] add_timer+0x12/0x14
[    5.432684]  [<79030eb5>] __queue_delayed_work+0xca/0xe4
[    5.432684]  [<79032361>] queue_delayed_work_on+0x42/0x71
[    5.432684]  [<791e26db>] kobject_release+0x6a/0x72
[    5.432684]  [<791e2724>] kobject_put+0x41/0x46
[    5.432684]  [<791e278e>] kobject_del+0x25/0x2f
[    5.432684]  [<79331f66>] device_del+0x132/0x13e
[    5.432684]  [<79331f7d>] device_unregister+0xb/0x15
[    5.432684]  [<79331fd9>] device_destroy+0x2c/0x31
[    5.432684]  [<7928f4f8>] tty_unregister_device+0x1f/0x37
[    5.432684]  [<7929b9aa>] uart_remove_one_port+0x9a/0xe7
[    5.432684]  [<7929e030>] serial8250_register_8250_port+0xc1/0x235
[    5.432684]  [<7929e353>] serial8250_probe+0xfc/0x142
[    5.432684]  [<793356bc>] platform_drv_probe+0x29/0x4b
[    5.432684]  [<7933461f>] driver_probe_device+0x88/0x17b
[    5.432684]  [<7933472e>] __device_attach+0x1c/0x2c
[    5.432684]  [<79333118>] bus_for_each_drv+0x38/0x6b
[    5.432684]  [<7933455e>] device_attach+0x63/0x83
[    5.432684]  [<79334712>] ? driver_probe_device+0x17b/0x17b
[    5.432684]  [<79333cf2>] bus_probe_device+0x25/0x84
[    5.432684]  [<7933267a>] device_add+0x3ac/0x559
[    5.432684]  [<791e2be5>] ? kobject_set_name_vargs+0x3d/0x4a
[    5.432684]  [<79331676>] ? dev_set_name+0x14/0x16
[    5.432684]  [<7933551e>] platform_device_add+0x10f/0x173
[    5.432684]  [<793359d5>] platform_device_register+0x1c/0x1f
[    5.432684]  [<7989242e>] ? setup_early_serial8250_console+0x35d/0x35d
[    5.432684]  [<7989243b>] fourport_init+0xd/0xf
[    5.432684]  [<790003da>] do_one_initcall+0x6b/0xec
[    5.432684]  [<79875400>] ? do_early_param+0x62/0x75
[    5.432684]  [<790355b8>] ? parse_args+0x16a/0x20b
[    5.432684]  [<798759fc>] kernel_init_freeable+0xd8/0x15d
[    5.432684]  [<79517fd0>] kernel_init+0x8/0xb4
[    5.432684]  [<79529e77>] ret_from_kernel_thread+0x1b/0x28
[    5.432684]  [<79517fc8>] ? rest_init+0x118/0x118
[    5.432684] ---[ end trace c47ce39591a4136c ]---
[    5.473927] ------------[ cut here ]------------
[    5.474640] WARNING: CPU: 0 PID: 1 at lib/list_debug.c:33 __list_add+0x4=
4/0x78()
[    5.475920] list_add corruption. prev->next should be next (79a162e0), b=
ut was   (null). (prev=3D87b10ce8).
[    5.477200] Modules linked in:
[    5.477422] CPU: 0 PID: 1 Comm: swapper/0 Tainted: G        W    3.11.0-=
rc6-next-20130822-07070-g245f086 #1
[    5.477422]  00000000 00000000 78049b7c 7951d86a 79724a8f 78049b94 79022=
c48 791fb32e
[    5.477422]  87b10ce8 79a162e0 87b79888 78049bac 79022c85 00000009 78049=
ba4 79724a8f
[    5.477422]  78049bc0 78049bd8 791fb32e 79724a65 00000021 79724a8f 79a16=
2e0 00000000
[    5.477422] Call Trace:
[    5.477422]  [<7951d86a>] dump_stack+0x4b/0x66
[    5.477422]  [<79022c48>] warn_slowpath_common+0x5c/0x73
[    5.477422]  [<791fb32e>] ? __list_add+0x44/0x78
[    5.477422]  [<79022c85>] warn_slowpath_fmt+0x26/0x2a
[    5.477422]  [<791fb32e>] __list_add+0x44/0x78
[    5.477422]  [<79028bb8>] __internal_add_timer+0x97/0x9b
[    5.477422]  [<79028bca>] internal_add_timer+0xe/0x26
[    5.477422]  [<79028e13>] __mod_timer+0xa2/0xb7
[    5.477422]  [<79028f3b>] mod_timer+0x5d/0x6c
[    5.477422]  [<79028f5c>] add_timer+0x12/0x14
[    5.477422]  [<79030eb5>] __queue_delayed_work+0xca/0xe4
[    5.477422]  [<79032361>] queue_delayed_work_on+0x42/0x71
[    5.477422]  [<791e26db>] kobject_release+0x6a/0x72
[    5.477422]  [<791e2724>] kobject_put+0x41/0x46
[    5.477422]  [<791e278e>] kobject_del+0x25/0x2f
[    5.477422]  [<79331f66>] device_del+0x132/0x13e
[    5.477422]  [<79331f7d>] device_unregister+0xb/0x15
[    5.477422]  [<79331fd9>] device_destroy+0x2c/0x31
[    5.477422]  [<7928f4f8>] tty_unregister_device+0x1f/0x37
[    5.477422]  [<7929b9aa>] uart_remove_one_port+0x9a/0xe7
[    5.477422]  [<7929e030>] serial8250_register_8250_port+0xc1/0x235
[    5.477422]  [<7929e353>] serial8250_probe+0xfc/0x142
[    5.477422]  [<793356bc>] platform_drv_probe+0x29/0x4b
[    5.477422]  [<7933461f>] driver_probe_device+0x88/0x17b
[    5.477422]  [<7933472e>] __device_attach+0x1c/0x2c
[    5.477422]  [<79333118>] bus_for_each_drv+0x38/0x6b
[    5.477422]  [<7933455e>] device_attach+0x63/0x83
[    5.477422]  [<79334712>] ? driver_probe_device+0x17b/0x17b
[    5.477422]  [<79333cf2>] bus_probe_device+0x25/0x84
[    5.477422]  [<7933267a>] device_add+0x3ac/0x559
[    5.477422]  [<791e2be5>] ? kobject_set_name_vargs+0x3d/0x4a
[    5.477422]  [<79331676>] ? dev_set_name+0x14/0x16
[    5.477422]  [<7933551e>] platform_device_add+0x10f/0x173
[    5.477422]  [<793359d5>] platform_device_register+0x1c/0x1f
[    5.477422]  [<7989242e>] ? setup_early_serial8250_console+0x35d/0x35d
[    5.477422]  [<7989243b>] fourport_init+0xd/0xf
[    5.477422]  [<790003da>] do_one_initcall+0x6b/0xec
[    5.477422]  [<79875400>] ? do_early_param+0x62/0x75
[    5.477422]  [<790355b8>] ? parse_args+0x16a/0x20b
[    5.477422]  [<798759fc>] kernel_init_freeable+0xd8/0x15d
[    5.477422]  [<79517fd0>] kernel_init+0x8/0xb4
[    5.477422]  [<79529e77>] ret_from_kernel_thread+0x1b/0x28
[    5.477422]  [<79517fc8>] ? rest_init+0x118/0x118
[    5.477422] ---[ end trace c47ce39591a4136d ]---
[    5.526790] ------------[ cut here ]------------
[    5.527376] WARNING: CPU: 0 PID: 1 at lib/list_debug.c:33 __list_add+0x4=
4/0x78()
[    5.528800] list_add corruption. prev->next should be next (79a162e0), b=
ut was   (null). (prev=3D87b10ce8).
[    5.530014] Modules linked in:
[    5.530341] CPU: 0 PID: 1 Comm: swapper/0 Tainted: G        W    3.11.0-=
rc6-next-20130822-07070-g245f086 #1
[    5.530341]  00000000 00000000 78049b7c 7951d86a 79724a8f 78049b94 79022=
c48 791fb32e
[    5.530341]  87b10ce8 79a162e0 87b79888 78049bac 79022c85 00000009 78049=
ba4 79724a8f
[    5.530341]  78049bc0 78049bd8 791fb32e 79724a65 00000021 79724a8f 79a16=
2e0 00000000
[    5.530341] Call Trace:
[    5.530341]  [<7951d86a>] dump_stack+0x4b/0x66
[    5.530341]  [<79022c48>] warn_slowpath_common+0x5c/0x73
[    5.530341]  [<791fb32e>] ? __list_add+0x44/0x78
[    5.530341]  [<79022c85>] warn_slowpath_fmt+0x26/0x2a
[    5.530341]  [<791fb32e>] __list_add+0x44/0x78
[    5.530341]  [<79028bb8>] __internal_add_timer+0x97/0x9b
[    5.530341]  [<79028bca>] internal_add_timer+0xe/0x26
[    5.530341]  [<79028e13>] __mod_timer+0xa2/0xb7
[    5.530341]  [<79028f3b>] mod_timer+0x5d/0x6c
[    5.530341]  [<79028f5c>] add_timer+0x12/0x14
[    5.530341]  [<79030eb5>] __queue_delayed_work+0xca/0xe4
[    5.530341]  [<79032361>] queue_delayed_work_on+0x42/0x71
[    5.530341]  [<791e26db>] kobject_release+0x6a/0x72
[    5.530341]  [<791e2724>] kobject_put+0x41/0x46
[    5.530341]  [<791e278e>] kobject_del+0x25/0x2f
[    5.530341]  [<79331f66>] device_del+0x132/0x13e
[    5.530341]  [<79331f7d>] device_unregister+0xb/0x15
[    5.530341]  [<79331fd9>] device_destroy+0x2c/0x31
[    5.530341]  [<7928f4f8>] tty_unregister_device+0x1f/0x37
[    5.530341]  [<7929b9aa>] uart_remove_one_port+0x9a/0xe7
[    5.530341]  [<7929e030>] serial8250_register_8250_port+0xc1/0x235
[    5.530341]  [<7929e353>] serial8250_probe+0xfc/0x142
[    5.530341]  [<793356bc>] platform_drv_probe+0x29/0x4b
[    5.530341]  [<7933461f>] driver_probe_device+0x88/0x17b
[    5.530341]  [<7933472e>] __device_attach+0x1c/0x2c
[    5.530341]  [<79333118>] bus_for_each_drv+0x38/0x6b
[    5.530341]  [<7933455e>] device_attach+0x63/0x83
[    5.530341]  [<79334712>] ? driver_probe_device+0x17b/0x17b
[    5.530341]  [<79333cf2>] bus_probe_device+0x25/0x84
[    5.530341]  [<7933267a>] device_add+0x3ac/0x559
[    5.530341]  [<791e2be5>] ? kobject_set_name_vargs+0x3d/0x4a
[    5.530341]  [<79331676>] ? dev_set_name+0x14/0x16
[    5.530341]  [<7933551e>] platform_device_add+0x10f/0x173
[    5.530341]  [<793359d5>] platform_device_register+0x1c/0x1f
[    5.530341]  [<7989242e>] ? setup_early_serial8250_console+0x35d/0x35d
[    5.530341]  [<7989243b>] fourport_init+0xd/0xf
[    5.530341]  [<790003da>] do_one_initcall+0x6b/0xec
[    5.530341]  [<79875400>] ? do_early_param+0x62/0x75
[    5.530341]  [<790355b8>] ? parse_args+0x16a/0x20b
[    5.530341]  [<798759fc>] kernel_init_freeable+0xd8/0x15d
[    5.530341]  [<79517fd0>] kernel_init+0x8/0xb4
[    5.530341]  [<79529e77>] ret_from_kernel_thread+0x1b/0x28
[    5.530341]  [<79517fc8>] ? rest_init+0x118/0x118
[    5.530341] ---[ end trace c47ce39591a4136e ]---
[    5.605044] ------------[ cut here ]------------
[    5.605863] WARNING: CPU: 0 PID: 1 at lib/list_debug.c:33 __list_add+0x4=
4/0x78()
[    5.607242] list_add corruption. prev->next should be next (79a162e0), b=
ut was   (null). (prev=3D87b10ce8).
[    5.608576] Modules linked in:
[    5.608576] CPU: 0 PID: 1 Comm: swapper/0 Tainted: G        W    3.11.0-=
rc6-next-20130822-07070-g245f086 #1
[    5.608576]  00000000 00000000 78049b7c 7951d86a 79724a8f 78049b94 79022=
c48 791fb32e
[    5.608576]  87b10ce8 79a162e0 87b79888 78049bac 79022c85 00000009 78049=
ba4 79724a8f
[    5.608576]  78049bc0 78049bd8 791fb32e 79724a65 00000021 79724a8f 79a16=
2e0 00000000
[    5.608576] Call Trace:
[    5.608576]  [<7951d86a>] dump_stack+0x4b/0x66
[    5.608576]  [<79022c48>] warn_slowpath_common+0x5c/0x73
[    5.608576]  [<791fb32e>] ? __list_add+0x44/0x78
[    5.608576]  [<79022c85>] warn_slowpath_fmt+0x26/0x2a
[    5.608576]  [<791fb32e>] __list_add+0x44/0x78
[    5.608576]  [<79028bb8>] __internal_add_timer+0x97/0x9b
[    5.608576]  [<79028bca>] internal_add_timer+0xe/0x26
[    5.608576]  [<79028e13>] __mod_timer+0xa2/0xb7
[    5.608576]  [<79028f3b>] mod_timer+0x5d/0x6c
[    5.608576]  [<79028f5c>] add_timer+0x12/0x14
[    5.608576]  [<79030eb5>] __queue_delayed_work+0xca/0xe4
[    5.608576]  [<79032361>] queue_delayed_work_on+0x42/0x71
[    5.608576]  [<791e26db>] kobject_release+0x6a/0x72
[    5.608576]  [<791e2724>] kobject_put+0x41/0x46
[    5.608576]  [<791e278e>] kobject_del+0x25/0x2f
[    5.608576]  [<79331f66>] device_del+0x132/0x13e
[    5.608576]  [<79331f7d>] device_unregister+0xb/0x15
[    5.608576]  [<79331fd9>] device_destroy+0x2c/0x31
[    5.608576]  [<7928f4f8>] tty_unregister_device+0x1f/0x37
[    5.608576]  [<7929b9aa>] uart_remove_one_port+0x9a/0xe7
[    5.608576]  [<7929e030>] serial8250_register_8250_port+0xc1/0x235
[    5.608576]  [<7929e353>] serial8250_probe+0xfc/0x142
[    5.608576]  [<793356bc>] platform_drv_probe+0x29/0x4b
[    5.608576]  [<7933461f>] driver_probe_device+0x88/0x17b
[    5.608576]  [<7933472e>] __device_attach+0x1c/0x2c
[    5.608576]  [<79333118>] bus_for_each_drv+0x38/0x6b
[    5.608576]  [<7933455e>] device_attach+0x63/0x83
[    5.608576]  [<79334712>] ? driver_probe_device+0x17b/0x17b
[    5.608576]  [<79333cf2>] bus_probe_device+0x25/0x84
[    5.608576]  [<7933267a>] device_add+0x3ac/0x559
[    5.608576]  [<791e2be5>] ? kobject_set_name_vargs+0x3d/0x4a
[    5.608576]  [<79331676>] ? dev_set_name+0x14/0x16
[    5.608576]  [<7933551e>] platform_device_add+0x10f/0x173
[    5.608576]  [<793359d5>] platform_device_register+0x1c/0x1f
[    5.608576]  [<7989242e>] ? setup_early_serial8250_console+0x35d/0x35d
[    5.608576]  [<7989243b>] fourport_init+0xd/0xf
[    5.608576]  [<790003da>] do_one_initcall+0x6b/0xec
[    5.608576]  [<79875400>] ? do_early_param+0x62/0x75
[    5.608576]  [<790355b8>] ? parse_args+0x16a/0x20b
[    5.608576]  [<798759fc>] kernel_init_freeable+0xd8/0x15d
[    5.608576]  [<79517fd0>] kernel_init+0x8/0xb4
[    5.608576]  [<79529e77>] ret_from_kernel_thread+0x1b/0x28
[    5.608576]  [<79517fc8>] ? rest_init+0x118/0x118
[    5.608576] ---[ end trace c47ce39591a4136f ]---
[    5.687004] BUG: unable to handle kernel=20
[    5.687266] RocketPort device driver module, version 2.09, 12-June-2003
[    5.687306] No rocketport ports found; unloading driver
[    5.687332] Applicom driver: $Id: ac.c,v 1.30 2000/03/22 16:03:57 dwmw2 =
Exp $
[    5.687337] ac.o: No PCI boards found.
[    5.687338] ac.o: For an ISA board you must supply memory and irq parame=
ters.
[    5.687345] toshiba: not a supported Toshiba laptop
[    5.687425] [drm] Initialized drm 1.1.0 20060810
[    5.688098] Uniform Multi-Platform E-IDE driver
[    5.688469] ide_generic: please use "probe_mask=3D0x3f" module parameter=
 for probing all legacy ISA IDE ports
[    5.688523] bonding: Ethernet Channel Bonding Driver: v3.7.1 (April 27, =
2011)
NULL pointer dereference at 0000000c
[    5.690820] IP: [<79029456>] get_next_timer_interrupt+0xf2/0x1bf
[    5.690820] *pde =3D 00000000=20
[    5.690820] Oops: 0000 [#1] SMP=20
[    5.690820] Modules linked in:
[    5.690820] CPU: 0 PID: 0 Comm: swapper/0 Tainted: G        W    3.11.0-=
rc6-next-20130822-07070-g245f086 #1
[    5.690820] task: 797d67f0 ti: 797d4000 task.ti: 797d4000
[    5.690820] EIP: 0060:[<79029456>] EFLAGS: 00210097 CPU: 0
[    5.690820] EIP is at get_next_timer_interrupt+0xf2/0x1bf
[    5.690820] EAX: 00000004 EBX: 79a16080 ECX: 00000000 EDX: fffee130
[    5.690820] ESI: 79a162d8 EDI: 00000003 EBP: 797d5f78 ESP: 797d5f48
[    5.690820]  DS: 007b ES: 007b FS: 00d8 GS: 0000 SS: 0068
[    5.690820] CR0: 8005003b CR2: 0000000c CR3: 01a0b000 CR4: 00000690
[    5.690820] Stack:
[    5.690820]  79a162b8 fffee096 00000000 00000001 03fffb83 79a162b8 79a16=
338 79a163b8
[    5.690820]  79a16438 8496ae38 0000089e fffee096 797d5fbc 79052c1c 52f8a=
f0c 00000001
[    5.690820]  52caf500 00000001 00000000 00000001 8496a580 fffee096 00000=
000 ae154000
[    5.690820] Call Trace:
[    5.690820]  [<79052c1c>] __tick_nohz_idle_enter+0x13d/0x31f
[    5.690820]  [<79052e51>] tick_nohz_idle_enter+0x53/0x5f
[    5.690820]  [<7904c2ab>] cpu_startup_entry+0x18/0x108
[    5.690820]  [<79517fc3>] rest_init+0x113/0x118
[    5.690820]  [<7987591f>] start_kernel+0x305/0x30a
[    5.690820]  [<798752a3>] i386_start_kernel+0x79/0x7d
[    5.690820] Code: f0 c7 45 d8 00 00 00 00 8b 45 d8 8b 7d e0 8b 44 85 e4 =
83 e7 0f 89 45 d0 89 f8 8b 4d d0 89 75 dc 8b 75 d0 8b 0c c1 8d 34 c6 eb 16 =
<f6> 41 0c 01 75 0e 39 51 08 0f 48 51 08 c7 45 dc 01 00 00 00 8b
[    5.690820] EIP: [<79029456>] get_next_timer_interrupt+0xf2/0x1bf SS:ESP=
 0068:797d5f48
[    5.690820] CR2: 000000000000000c
[    5.690820] ---[ end trace c47ce39591a41370 ]---
[    5.690820] Kernel panic - not syncing: Attempted to kill the idle task!
[    5.690820] Rebooting in 10 seconds..
BUG: kernel boot crashed
Elapsed time: 25
qemu-system-x86_64 -cpu kvm64 -enable-kvm -kernel /tmp//kernel/i386-randcon=
fig-j4-08271056/245f08699d5320f021070ed8698ac89ebf2f0670/vmlinuz-3.11.0-rc6=
-next-20130822-07070-g245f086-5533 -append 'hung_task_panic=3D1 rcutree.rcu=
_cpu_stall_timeout=3D100 log_buf_len=3D8M ignore_loglevel debug sched_debug=
 apic=3Ddebug dynamic_printk sysrq_always_enabled panic=3D10  prompt_ramdis=
k=3D0 console=3DttyS0,115200 console=3Dtty0 vga=3Dnormal  root=3D/dev/ram0 =
rw link=3D/kernel-tests/run-queue/kvm/i386-randconfig-j4-08271056/next:mast=
er/.vmlinuz-245f08699d5320f021070ed8698ac89ebf2f0670-20130827125517-3-cairo=
 branch=3Dnext/master  BOOT_IMAGE=3D/kernel/i386-randconfig-j4-08271056/245=
f08699d5320f021070ed8698ac89ebf2f0670/vmlinuz-3.11.0-rc6-next-20130822-0707=
0-g245f086'  -initrd /kernel-tests/initrd/quantal-core-i386.cgz -m 256M -sm=
p 2 -net nic,vlan=3D0,macaddr=3D00:00:00:00:00:00,model=3Dvirtio -net user,=
vlan=3D0,hostfwd=3Dtcp::9629-:22 -net nic,vlan=3D1,model=3De1000 -net user,=
vlan=3D1 -boot order=3Dnc -no-reboot -watchdog i6300esb -drive file=3D/fs/L=
ABEL=3DKVM/disk0-cairo-5533,media=3Ddisk,if=3Dvirtio -drive file=3D/fs/LABE=
L=3DKVM/disk1-cairo-5533,media=3Ddisk,if=3Dvirtio -drive file=3D/fs/LABEL=
=3DKVM/disk2-cairo-5533,media=3Ddisk,if=3Dvirtio -drive file=3D/fs/LABEL=3D=
KVM/disk3-cairo-5533,media=3Ddisk,if=3Dvirtio -drive file=3D/fs/LABEL=3DKVM=
/disk4-cairo-5533,media=3Ddisk,if=3Dvirtio -drive file=3D/fs/LABEL=3DKVM/di=
sk5-cairo-5533,media=3Ddisk,if=3Dvirtio -pidfile /dev/shm/kboot/pid-cairo-l=
kp-5533 -serial file:/dev/shm/kboot/serial-cairo-lkp-5533 -daemonize -displ=
ay none -monitor null=20

--VbJkn9YxBvnuCH5J
Content-Type: application/octet-stream
Content-Disposition: attachment; filename="bisect-245f08699d5320f021070ed8698ac89ebf2f0670-i386-randconfig-j4-08271056-BUG:-unable-to-handle-kernel-28083.log"
Content-Transfer-Encoding: base64

Z2l0IGNoZWNrb3V0IDVlOGQxYWNkMDU2ODc3MjBjYmIwYjA4OTc1ZWFjYjc1ODhmZGZjNDIK
UHJldmlvdXMgSEVBRCBwb3NpdGlvbiB3YXMgMjQ1ZjA4Ni4uLiBBZGQgbGludXgtbmV4dCBz
cGVjaWZpYyBmaWxlcyBmb3IgMjAxMzA4MjIKSEVBRCBpcyBub3cgYXQgNWU4ZDFhYy4uLiBN
ZXJnZSByZW1vdGUtdHJhY2tpbmcgYnJhbmNoICdhaW8vbWFzdGVyJwpscyAtYSAva2VybmVs
LXRlc3RzL3J1bi1xdWV1ZS9rdm0vaTM4Ni1yYW5kY29uZmlnLWo0LTA4MjcxMDU2L25leHQ6
bWFzdGVyOjVlOGQxYWNkMDU2ODc3MjBjYmIwYjA4OTc1ZWFjYjc1ODhmZGZjNDI6YmlzZWN0
LXNvdW5kCgoyMDEzLTA4LTI3LTEzOjE5OjE0IDVlOGQxYWNkMDU2ODc3MjBjYmIwYjA4OTc1
ZWFjYjc1ODhmZGZjNDIgY29tcGlsaW5nCjgyOCByZWFsICAyMDQzIHVzZXIgIDI0NCBzeXMg
IDI3Ni4yOSUgY3B1IAlpMzg2LXJhbmRjb25maWctajQtMDgyNzEwNTYKCjIwMTMtMDgtMjct
MTM6MzU6MDYgZGV0ZWN0aW5nIGJvb3Qgc3RhdGUgMy4xMS4wLXJjNi0wNzQ2NC1nNWU4ZDFh
Yy4uLi4uCTEJMi4JMy4uIFRFU1QgRkFJTFVSRQpbICAgIDEuNjk3NzIxXSBXQVJOSU5HOiBD
UFU6IDEgUElEOiAxIGF0IC9jL3dmZy9zb3VuZC9saWIvbGlzdF9kZWJ1Zy5jOjMzIF9fbGlz
dF9hZGQrMHg0NC8weDc4KCkKWyAgICAxLjY5ODg4OF0gbGlzdF9hZGQgY29ycnVwdGlvbi4g
cHJldi0+bmV4dCBzaG91bGQgYmUgbmV4dCAoNzgwMjIyNjgpLCBidXQgd2FzICAgKG51bGwp
LiAocHJldj04N2I0ZGNlOCkuClsgICAgMS43MDAwMjhdIE1vZHVsZXMgbGlua2VkIGluOgpb
ICAgIDEuNzAwMDI4XSBDUFU6IDEgUElEOiAxIENvbW06IHN3YXBwZXIvMCBOb3QgdGFpbnRl
ZCAzLjExLjAtcmM2LTA3NDY0LWc1ZThkMWFjICMyNTUKWyAgICAxLjcwMDAyOF0gIDAwMDAw
MDAwIDAwMDAwMDAwIDc4MDQ5YjdjIDc5NTFjMThiIDc5NzIwOWEzIDc4MDQ5Yjk0IDc5MDIy
YzU4IDc5MWY5YWIxClsgICAgMS43MDAwMjhdICA4N2I0ZGNlOCA3ODAyMjI2OCA4N2I1ZDdj
OCA3ODA0OWJhYyA3OTAyMmM5NSAwMDAwMDAwOSA3ODA0OWJhNCA3OTcyMDlhMwpbICAgIDEu
NzAwMDI4XSAgNzgwNDliYzAgNzgwNDliZDggNzkxZjlhYjEgNzk3MjA5ODUgMDAwMDAwMjEg
Nzk3MjA5YTMgNzgwMjIyNjggMDAwMDAwMDAKWyAgICAxLjcwMDAyOF0gQ2FsbCBUcmFjZToK
WyAgICAxLjcwMDAyOF0gIFs8Nzk1MWMxOGI+XSBkdW1wX3N0YWNrKzB4NGIvMHg2NgpbICAg
IDEuNzAwMDI4XSAgWzw3OTAyMmM1OD5dIHdhcm5fc2xvd3BhdGhfY29tbW9uKzB4NWMvMHg3
MwpbICAgIDEuNzAwMDI4XSAgWzw3OTFmOWFiMT5dID8gX19saXN0X2FkZCsweDQ0LzB4NzgK
WyAgICAxLjcwMDAyOF0gIFs8NzkwMjJjOTU+XSB3YXJuX3Nsb3dwYXRoX2ZtdCsweDI2LzB4
MmEKWyAgICAxLjcwMDAyOF0gIFs8NzkxZjlhYjE+XSBfX2xpc3RfYWRkKzB4NDQvMHg3OApb
ICAgIDEuNzAwMDI4XSAgWzw3OTAyOGJhNT5dIF9faW50ZXJuYWxfYWRkX3RpbWVyKzB4OTcv
MHg5YgpbICAgIDEuNzAwMDI4XSAgWzw3OTAyOGJiNz5dIGludGVybmFsX2FkZF90aW1lcisw
eGUvMHgyNgpbICAgIDEuNzAwMDI4XSAgWzw3OTAyOGUwMD5dIF9fbW9kX3RpbWVyKzB4YTIv
MHhiNwpbICAgIDEuNzAwMDI4XSAgWzw3OTAyOGYyOD5dIG1vZF90aW1lcisweDVkLzB4NmMK
WyAgICAxLjcwMDAyOF0gIFs8NzkwMjhmNDk+XSBhZGRfdGltZXIrMHgxMi8weDE0ClsgICAg
MS43MDAwMjhdICBbPDc5MDMwZTUzPl0gX19xdWV1ZV9kZWxheWVkX3dvcmsrMHhjYS8weGU0
ClsgICAgMS43MDAwMjhdICBbPDc5MDMyMmZmPl0gcXVldWVfZGVsYXllZF93b3JrX29uKzB4
NDIvMHg3MQpbICAgIDEuNzAwMDI4XSAgWzw3OTFlMGVmYz5dIGtvYmplY3RfcmVsZWFzZSsw
eDZhLzB4NzIKWyAgICAxLjcwMDAyOF0gIFs8NzkxZTBmNDU+XSBrb2JqZWN0X3B1dCsweDQx
LzB4NDYKWyAgICAxLjcwMDAyOF0gIFs8NzkxZTBmYWY+XSBrb2JqZWN0X2RlbCsweDI1LzB4
MmYKWyAgICAxLjcwMDAyOF0gIFs8NzkzMzA1OWU+XSBkZXZpY2VfZGVsKzB4MTMyLzB4MTNl
ClsgICAgMS43MDAwMjhdICBbPDc5MzMwNWI1Pl0gZGV2aWNlX3VucmVnaXN0ZXIrMHhiLzB4
MTUKWyAgICAxLjcwMDAyOF0gIFs8NzkzMzA2MTE+XSBkZXZpY2VfZGVzdHJveSsweDJjLzB4
MzEKWyAgICAxLjcwMDAyOF0gIFs8NzkyOGQ5ZmI+XSB0dHlfdW5yZWdpc3Rlcl9kZXZpY2Ur
MHgxZi8weDM3ClsgICAgMS43MDAwMjhdICBbPDc5Mjk5ZWIzPl0gdWFydF9yZW1vdmVfb25l
X3BvcnQrMHg5YS8weGU3ClsgICAgMS43MDAwMjhdICBbPDc5MjljNTM5Pl0gc2VyaWFsODI1
MF9yZWdpc3Rlcl84MjUwX3BvcnQrMHhjMS8weDIzNQpbICAgIDEuNzAwMDI4XSAgWzw3OTI5
Yzg1Yz5dIHNlcmlhbDgyNTBfcHJvYmUrMHhmYy8weDE0MgpbICAgIDEuNzAwMDI4XSAgWzw3
OTMzM2NmND5dIHBsYXRmb3JtX2Rydl9wcm9iZSsweDI5LzB4NGIKWyAgICAxLjcwMDAyOF0g
IFs8NzkzMzJjNTc+XSBkcml2ZXJfcHJvYmVfZGV2aWNlKzB4ODgvMHgxN2IKWyAgICAxLjcw
MDAyOF0gIFs8NzkzMzJkNjY+XSBfX2RldmljZV9hdHRhY2grMHgxYy8weDJjClsgICAgMS43
MDAwMjhdICBbPDc5MzMxNzUwPl0gYnVzX2Zvcl9lYWNoX2RydisweDM4LzB4NmIKWyAgICAx
LjcwMDAyOF0gIFs8NzkzMzJiOTY+XSBkZXZpY2VfYXR0YWNoKzB4NjMvMHg4MwpbICAgIDEu
NzAwMDI4XSAgWzw3OTMzMmQ0YT5dID8gZHJpdmVyX3Byb2JlX2RldmljZSsweDE3Yi8weDE3
YgpbICAgIDEuNzAwMDI4XSAgWzw3OTMzMjMyYT5dIGJ1c19wcm9iZV9kZXZpY2UrMHgyNS8w
eDg0ClsgICAgMS43MDAwMjhdICBbPDc5MzMwY2IyPl0gZGV2aWNlX2FkZCsweDNhYy8weDU1
OQpbICAgIDEuNzAwMDI4XSAgWzw3OTFlMTQwNj5dID8ga29iamVjdF9zZXRfbmFtZV92YXJn
cysweDNkLzB4NGEKWyAgICAxLjcwMDAyOF0gIFs8NzkzMmZjYWU+XSA/IGRldl9zZXRfbmFt
ZSsweDE0LzB4MTYKWyAgICAxLjcwMDAyOF0gIFs8NzkzMzNiNTY+XSBwbGF0Zm9ybV9kZXZp
Y2VfYWRkKzB4MTBmLzB4MTczClsgICAgMS43MDAwMjhdICBbPDc5MzM0MDBkPl0gcGxhdGZv
cm1fZGV2aWNlX3JlZ2lzdGVyKzB4MWMvMHgxZgpbICAgIDEuNzAwMDI4XSAgWzw3OTg4YzA4
ND5dID8gc2V0dXBfZWFybHlfc2VyaWFsODI1MF9jb25zb2xlKzB4MzVkLzB4MzVkClsgICAg
MS43MDAwMjhdICBbPDc5ODhjMDkxPl0gZm91cnBvcnRfaW5pdCsweGQvMHhmClsgICAgMS43
MDAwMjhdICBbPDc5MDAwM2RhPl0gZG9fb25lX2luaXRjYWxsKzB4NmIvMHhlYwpbICAgIDEu
NzAwMDI4XSAgWzw3OTg2ZjQwMD5dID8gZG9fZWFybHlfcGFyYW0rMHg2Mi8weDc1ClsgICAg
MS43MDAwMjhdICBbPDc5MDM1NTU2Pl0gPyBwYXJzZV9hcmdzKzB4MTZhLzB4MjBiClsgICAg
MS43MDAwMjhdICBbPDc5ODZmOWZjPl0ga2VybmVsX2luaXRfZnJlZWFibGUrMHhkOC8weDE1
ZApbICAgIDEuNzAwMDI4XSAgWzw3OTUxNjhjYz5dIGtlcm5lbF9pbml0KzB4OC8weGI0Clsg
ICAgMS43MDAwMjhdICBbPDc5NTI4MzM3Pl0gcmV0X2Zyb21fa2VybmVsX3RocmVhZCsweDFi
LzB4MjgKWyAgICAxLjcwMDAyOF0gIFs8Nzk1MTY4YzQ+XSA/IHJlc3RfaW5pdCsweDExOC8w
eDExOApbICAgIDEuNzAwMDI4XSAtLS1bIGVuZCB0cmFjZSBmMmY3ZDA3ZTgwOTM3YzgyIF0t
LS0KL2tlcm5lbC9pMzg2LXJhbmRjb25maWctajQtMDgyNzEwNTYvNWU4ZDFhY2QwNTY4Nzcy
MGNiYjBiMDg5NzVlYWNiNzU4OGZkZmM0Mi9kbWVzZy1rdm0tY2Fpcm8tNjExNS0yMDEzMDgy
NzEzMzkyNS0zLjExLjAtcmM3LTAwMTgwLWcwMzlmMWMyLTEyNwova2VybmVsL2kzODYtcmFu
ZGNvbmZpZy1qNC0wODI3MTA1Ni81ZThkMWFjZDA1Njg3NzIwY2JiMGIwODk3NWVhY2I3NTg4
ZmRmYzQyL2RtZXNnLWt2bS1uaG00LTEzNjMxLTIwMTMwODI3MDUzNTU3LTMuMTEuMC1yYzYt
MDc0NjQtZzVlOGQxYWMtMjU1CgpiaXNlY3Q6IGJhZCBjb21taXQgNWU4ZDFhY2QwNTY4Nzcy
MGNiYjBiMDg5NzVlYWNiNzU4OGZkZmM0MgpnaXQgY2hlY2tvdXQgdjMuMTAKUHJldmlvdXMg
SEVBRCBwb3NpdGlvbiB3YXMgNWU4ZDFhYy4uLiBNZXJnZSByZW1vdGUtdHJhY2tpbmcgYnJh
bmNoICdhaW8vbWFzdGVyJwpIRUFEIGlzIG5vdyBhdCA4YmI0OTVlLi4uIExpbnV4IDMuMTAK
bHMgLWEgL2tlcm5lbC10ZXN0cy9ydW4tcXVldWUva3ZtL2kzODYtcmFuZGNvbmZpZy1qNC0w
ODI3MTA1Ni9uZXh0Om1hc3Rlcjo4YmI0OTVlM2YwMjQwMWVlNmY3NmQxYjFkNzdmM2FjOWYw
NzllMzc2OmJpc2VjdC1zb3VuZAoKMjAxMy0wOC0yNy0xMzo0MDo0MSA4YmI0OTVlM2YwMjQw
MWVlNmY3NmQxYjFkNzdmM2FjOWYwNzllMzc2IGNvbXBpbGluZwoyNzcgcmVhbCAgMjE4MiB1
c2VyICAyNTcgc3lzICA4NzguNzMlIGNwdSAJaTM4Ni1yYW5kY29uZmlnLWo0LTA4MjcxMDU2
CgoyMDEzLTA4LTI3LTEzOjQ1OjQ3IGRldGVjdGluZyBib290IHN0YXRlIDMuMTAuMC4uLgkx
CTIuCTQuLi4JOC4JOQkxMAkxMS4uCTEzLgkxNC4uCTE1Li4JMTYuCTE3LgkyMAkyMwkyNC4u
Li4uLgkyNS4uLi4uLi4JMjYuLgkyOAkyOQkzMS4JMzIuLi4uCTMzLi4uCTM2Li4JMzcJMzgJ
NDEuCTQyCTQ2CTQ5Lgk1MAk1MS4JNTMuLgk1NSBTVUNDRVNTCgpiaXNlY3Q6IGdvb2QgY29t
bWl0IHYzLjEwCmdpdCBiaXNlY3Qgc3RhcnQgNWU4ZDFhY2QwNTY4NzcyMGNiYjBiMDg5NzVl
YWNiNzU4OGZkZmM0MiB2My4xMCAtLQpQcmV2aW91cyBIRUFEIHBvc2l0aW9uIHdhcyA4YmI0
OTVlLi4uIExpbnV4IDMuMTAKSEVBRCBpcyBub3cgYXQgYzFiZTVhNS4uLiBMaW51eCAzLjkK
QmlzZWN0aW5nOiA5MTMwIHJldmlzaW9ucyBsZWZ0IHRvIHRlc3QgYWZ0ZXIgdGhpcyAocm91
Z2hseSAxMyBzdGVwcykKWzhjYmQwZWVmY2FmOGNjMzJkZWQyYmYyMjlmMGZjMzc5YjJhZDY5
ZjJdIE1lcmdlIGJyYW5jaCAnbmV4dCcgb2YgZ2l0Oi8vZ2l0Lmtlcm5lbC5vcmcvcHViL3Nj
bS9saW51eC9rZXJuZWwvZ2l0L3J6aGFuZy9saW51eApnaXQgYmlzZWN0IHJ1biAvYy9rZXJu
ZWwtdGVzdHMvYmlzZWN0LXRlc3QtYm9vdC1mYWlsdXJlLnNoIC9ob21lL3dmZy9zb3VuZC9v
YmotYmlzZWN0CnJ1bm5pbmcgL2Mva2VybmVsLXRlc3RzL2Jpc2VjdC10ZXN0LWJvb3QtZmFp
bHVyZS5zaCAvaG9tZS93Zmcvc291bmQvb2JqLWJpc2VjdApscyAtYSAva2VybmVsLXRlc3Rz
L3J1bi1xdWV1ZS9rdm0vaTM4Ni1yYW5kY29uZmlnLWo0LTA4MjcxMDU2L25leHQ6bWFzdGVy
OjhjYmQwZWVmY2FmOGNjMzJkZWQyYmYyMjlmMGZjMzc5YjJhZDY5ZjI6YmlzZWN0LXNvdW5k
CgoyMDEzLTA4LTI3LTE0OjI2OjAxIDhjYmQwZWVmY2FmOGNjMzJkZWQyYmYyMjlmMGZjMzc5
YjJhZDY5ZjIgY29tcGlsaW5nCjI4NyByZWFsICAyMjI2IHVzZXIgIDI0NiBzeXMgIDg2MS41
MiUgY3B1IAlpMzg2LXJhbmRjb25maWctajQtMDgyNzEwNTYKCjIwMTMtMDgtMjctMTQ6MzE6
MTQgZGV0ZWN0aW5nIGJvb3Qgc3RhdGUgMy4xMC4wLTA4OTQzLWc4Y2JkMGVlLi4uLi4uLi4J
MS4JMgkzLi4uCTQuCTYJNwk4LgkxMS4uLi4uLi4uLgkxMi4uCTEzLgkxNQkxNi4uLgkxNy4u
Li4uCTE5Li4uLgkyMgkyMwkyNC4JMjUJMjYJMjcuLi4uLgkyOC4JMjkuLi4uLi4JMzAuLi4u
CTMxLi4JMzIJMzMuCTM2CTM3LgkzOAkzOQk0MC4uCTQyLgk0Mwk0NC4uLi4JNDUuLi4uLi4J
NDYuLi4JNDcuCTQ5CTUwLi4uLi4uLi4uLi4JNTIJNTMuCTU0Li4uCTU1IFNVQ0NFU1MKCkJp
c2VjdGluZzogNDU3OCByZXZpc2lvbnMgbGVmdCB0byB0ZXN0IGFmdGVyIHRoaXMgKHJvdWdo
bHkgMTIgc3RlcHMpCls2MGEyYjk3NzUzM2MzMTJkMjcxNTYzZDk1NWVmN2I4ZTM1YTZhYTM4
XSBNZXJnZSByZW1vdGUtdHJhY2tpbmcgYnJhbmNoICdpbmZpbmliYW5kL2Zvci1uZXh0Jwpy
dW5uaW5nIC9jL2tlcm5lbC10ZXN0cy9iaXNlY3QtdGVzdC1ib290LWZhaWx1cmUuc2ggL2hv
bWUvd2ZnL3NvdW5kL29iai1iaXNlY3QKbHMgLWEgL2tlcm5lbC10ZXN0cy9ydW4tcXVldWUv
a3ZtL2kzODYtcmFuZGNvbmZpZy1qNC0wODI3MTA1Ni9uZXh0Om1hc3Rlcjo2MGEyYjk3NzUz
M2MzMTJkMjcxNTYzZDk1NWVmN2I4ZTM1YTZhYTM4OmJpc2VjdC1zb3VuZAoKMjAxMy0wOC0y
Ny0xNTozODoxOSA2MGEyYjk3NzUzM2MzMTJkMjcxNTYzZDk1NWVmN2I4ZTM1YTZhYTM4IGNv
bXBpbGluZwozODYgcmVhbCAgMjE1NiB1c2VyICAyNDEgc3lzICA2MTkuODUlIGNwdSAJaTM4
Ni1yYW5kY29uZmlnLWo0LTA4MjcxMDU2CgoyMDEzLTA4LTI3LTE1OjQ1OjE4IGRldGVjdGlu
ZyBib290IHN0YXRlIDMuMTEuMC1yYzYtMDI4ODUtZzYwYTJiOTcuLi4uLgkxCTIJMy4JNAk1
CTYJNwk5Li4JMTEJMTMJMTQuCTE3Li4JMTguLi4uCTE5CTIwCTIxLgkyMgkyNQkyOS4uCTMw
Li4uCTMxLi4JMzIuLi4uLi4uLgkzMy4uLi4uCTM0CTM1LgkzNi4uLi4uLgkzOC4uLi4uLgk0
Mgk0My4uCTQ0Li4JNDUuLgk0Ni4uCTQ5Li4uLgk1MAk1MQk1Mi4JNTMuCTU0Li4uCTU1IFNV
Q0NFU1MKCkJpc2VjdGluZzogMjM2MCByZXZpc2lvbnMgbGVmdCB0byB0ZXN0IGFmdGVyIHRo
aXMgKHJvdWdobHkgMTEgc3RlcHMpCls0YTIyNWI0NjZlMDQwYTcwZTdkMTJiMTU5ZDJhMzZk
YTFjMmVmN2RjXSBuZXh0LTIwMTMwODIxL2RyaXZlci1jb3JlCnJ1bm5pbmcgL2Mva2VybmVs
LXRlc3RzL2Jpc2VjdC10ZXN0LWJvb3QtZmFpbHVyZS5zaCAvaG9tZS93Zmcvc291bmQvb2Jq
LWJpc2VjdApscyAtYSAva2VybmVsLXRlc3RzL3J1bi1xdWV1ZS9rdm0vaTM4Ni1yYW5kY29u
ZmlnLWo0LTA4MjcxMDU2L25leHQ6bWFzdGVyOjRhMjI1YjQ2NmUwNDBhNzBlN2QxMmIxNTlk
MmEzNmRhMWMyZWY3ZGM6YmlzZWN0LXNvdW5kCgoyMDEzLTA4LTI3LTE2OjM3OjU0IDRhMjI1
YjQ2NmUwNDBhNzBlN2QxMmIxNTlkMmEzNmRhMWMyZWY3ZGMgY29tcGlsaW5nCjI2NiByZWFs
ICAyMjU3IHVzZXIgIDI2NSBzeXMgIDk0NS4wMCUgY3B1IAlpMzg2LXJhbmRjb25maWctajQt
MDgyNzEwNTYKCjIwMTMtMDgtMjctMTY6NDI6NDggZGV0ZWN0aW5nIGJvb3Qgc3RhdGUgMy4x
MS4wLXJjNi0wNTEwMy1nNGEyMjViNC4uLi4uLi4uLi4uLi4uLi4uLi4gVEVTVCBGQUlMVVJF
ClsgICAgMy40NTc2MjddIFdBUk5JTkc6IENQVTogMCBQSUQ6IDEgYXQgL2Mvd2ZnL3NvdW5k
L2xpYi9saXN0X2RlYnVnLmM6MzMgX19saXN0X2FkZCsweDQ0LzB4NzgoKQpbICAgIDMuNDU4
ODk4XSBsaXN0X2FkZCBjb3JydXB0aW9uLiBwcmV2LT5uZXh0IHNob3VsZCBiZSBuZXh0ICg3
OWEwZjMyMCksIGJ1dCB3YXMgICAobnVsbCkuIChwcmV2PTg3YWQ5Y2U4KS4KWyAgICAzLjQ2
MDM2NV0gTW9kdWxlcyBsaW5rZWQgaW46ClsgICAgMy40NjAzNjVdIENQVTogMCBQSUQ6IDEg
Q29tbTogc3dhcHBlci8wIE5vdCB0YWludGVkIDMuMTEuMC1yYzYtMDUxMDMtZzRhMjI1YjQg
IzI1OQpbICAgIDMuNDYwMzY1XSAgMDAwMDAwMDAgMDAwMDAwMDAgNzgwNDliN2MgNzk1MWI4
NzkgNzk3MjA0N2UgNzgwNDliOTQgNzkwMjJjNTggNzkxZjkwNjEKWyAgICAzLjQ2MDM2NV0g
IDg3YWQ5Y2U4IDc5YTBmMzIwIDg3YWQ2Yjg4IDc4MDQ5YmFjIDc5MDIyYzk1IDAwMDAwMDA5
IDc4MDQ5YmE0IDc5NzIwNDdlClsgICAgMy40NjAzNjVdICA3ODA0OWJjMCA3ODA0OWJkOCA3
OTFmOTA2MSA3OTcyMDQ2MCAwMDAwMDAyMSA3OTcyMDQ3ZSA3OWEwZjMyMCAwMDAwMDAwMApb
ICAgIDMuNDYwMzY1XSBDYWxsIFRyYWNlOgpbICAgIDMuNDYwMzY1XSAgWzw3OTUxYjg3OT5d
IGR1bXBfc3RhY2srMHg0Yi8weDY2ClsgICAgMy40NjAzNjVdICBbPDc5MDIyYzU4Pl0gd2Fy
bl9zbG93cGF0aF9jb21tb24rMHg1Yy8weDczClsgICAgMy40NjAzNjVdICBbPDc5MWY5MDYx
Pl0gPyBfX2xpc3RfYWRkKzB4NDQvMHg3OApbICAgIDMuNDYwMzY1XSAgWzw3OTAyMmM5NT5d
IHdhcm5fc2xvd3BhdGhfZm10KzB4MjYvMHgyYQpbICAgIDMuNDYwMzY1XSAgWzw3OTFmOTA2
MT5dIF9fbGlzdF9hZGQrMHg0NC8weDc4ClsgICAgMy40NjAzNjVdICBbPDc5MDI4YmE1Pl0g
X19pbnRlcm5hbF9hZGRfdGltZXIrMHg5Ny8weDliClsgICAgMy40NjAzNjVdICBbPDc5MDI4
YmI3Pl0gaW50ZXJuYWxfYWRkX3RpbWVyKzB4ZS8weDI2ClsgICAgMy40NjAzNjVdICBbPDc5
MDI4ZTAwPl0gX19tb2RfdGltZXIrMHhhMi8weGI3ClsgICAgMy40NjAzNjVdICBbPDc5MDI4
ZjI4Pl0gbW9kX3RpbWVyKzB4NWQvMHg2YwpbICAgIDMuNDYwMzY1XSAgWzw3OTAyOGY0OT5d
IGFkZF90aW1lcisweDEyLzB4MTQKWyAgICAzLjQ2MDM2NV0gIFs8NzkwMzBlNTM+XSBfX3F1
ZXVlX2RlbGF5ZWRfd29yaysweGNhLzB4ZTQKWyAgICAzLjQ2MDM2NV0gIFs8NzkwMzIyZmY+
XSBxdWV1ZV9kZWxheWVkX3dvcmtfb24rMHg0Mi8weDcxClsgICAgMy40NjAzNjVdICBbPDc5
MWUwNGE2Pl0ga29iamVjdF9yZWxlYXNlKzB4NmEvMHg3MgpbICAgIDMuNDYwMzY1XSAgWzw3
OTFlMDRlZj5dIGtvYmplY3RfcHV0KzB4NDEvMHg0NgpbICAgIDMuNDYwMzY1XSAgWzw3OTFl
MDU1OT5dIGtvYmplY3RfZGVsKzB4MjUvMHgyZgpbICAgIDMuNDYwMzY1XSAgWzw3OTMyZmJj
OD5dIGRldmljZV9kZWwrMHgxMzIvMHgxM2UKWyAgICAzLjQ2MDM2NV0gIFs8NzkzMmZiZGY+
XSBkZXZpY2VfdW5yZWdpc3RlcisweGIvMHgxNQpbICAgIDMuNDYwMzY1XSAgWzw3OTMyZmMz
Yj5dIGRldmljZV9kZXN0cm95KzB4MmMvMHgzMQpbICAgIDMuNDYwMzY1XSAgWzw3OTI4Y2Zh
Yj5dIHR0eV91bnJlZ2lzdGVyX2RldmljZSsweDFmLzB4MzcKWyAgICAzLjQ2MDM2NV0gIFs8
NzkyOTk1MWM+XSB1YXJ0X3JlbW92ZV9vbmVfcG9ydCsweDlhLzB4ZTQKWyAgICAzLjQ2MDM2
NV0gIFs8NzkyOWJiN2M+XSBzZXJpYWw4MjUwX3JlZ2lzdGVyXzgyNTBfcG9ydCsweGMxLzB4
MjM1ClsgICAgMy40NjAzNjVdICBbPDc5MjliZTlmPl0gc2VyaWFsODI1MF9wcm9iZSsweGZj
LzB4MTQyClsgICAgMy40NjAzNjVdICBbPDc5MzMzMzFlPl0gcGxhdGZvcm1fZHJ2X3Byb2Jl
KzB4MjkvMHg0YgpbICAgIDMuNDYwMzY1XSAgWzw3OTMzMjI4MT5dIGRyaXZlcl9wcm9iZV9k
ZXZpY2UrMHg4OC8weDE3YgpbICAgIDMuNDYwMzY1XSAgWzw3OTMzMjM5MD5dIF9fZGV2aWNl
X2F0dGFjaCsweDFjLzB4MmMKWyAgICAzLjQ2MDM2NV0gIFs8NzkzMzBkN2E+XSBidXNfZm9y
X2VhY2hfZHJ2KzB4MzgvMHg2YgpbICAgIDMuNDYwMzY1XSAgWzw3OTMzMjFjMD5dIGRldmlj
ZV9hdHRhY2grMHg2My8weDgzClsgICAgMy40NjAzNjVdICBbPDc5MzMyMzc0Pl0gPyBkcml2
ZXJfcHJvYmVfZGV2aWNlKzB4MTdiLzB4MTdiClsgICAgMy40NjAzNjVdICBbPDc5MzMxOTU0
Pl0gYnVzX3Byb2JlX2RldmljZSsweDI1LzB4ODQKWyAgICAzLjQ2MDM2NV0gIFs8NzkzMzAy
ZGM+XSBkZXZpY2VfYWRkKzB4M2FjLzB4NTU5ClsgICAgMy40NjAzNjVdICBbPDc5MWUwOWIw
Pl0gPyBrb2JqZWN0X3NldF9uYW1lX3ZhcmdzKzB4M2QvMHg0YQpbICAgIDMuNDYwMzY1XSAg
Wzw3OTMyZjJkOD5dID8gZGV2X3NldF9uYW1lKzB4MTQvMHgxNgpbICAgIDMuNDYwMzY1XSAg
Wzw3OTMzMzE4MD5dIHBsYXRmb3JtX2RldmljZV9hZGQrMHgxMGYvMHgxNzMKWyAgICAzLjQ2
MDM2NV0gIFs8NzkzMzM2Mzc+XSBwbGF0Zm9ybV9kZXZpY2VfcmVnaXN0ZXIrMHgxYy8weDFm
ClsgICAgMy40NjAzNjVdICBbPDc5ODhjMDg0Pl0gPyBzZXR1cF9lYXJseV9zZXJpYWw4MjUw
X2NvbnNvbGUrMHgzNWQvMHgzNWQKWyAgICAzLjQ2MDM2NV0gIFs8Nzk4OGMwOTE+XSBmb3Vy
cG9ydF9pbml0KzB4ZC8weGYKWyAgICAzLjQ2MDM2NV0gIFs8NzkwMDAzZGE+XSBkb19vbmVf
aW5pdGNhbGwrMHg2Yi8weGVjClsgICAgMy40NjAzNjVdICBbPDc5ODZmNDAwPl0gPyBkb19l
YXJseV9wYXJhbSsweDYyLzB4NzUKWyAgICAzLjQ2MDM2NV0gIFs8NzkwMzU1NTY+XSA/IHBh
cnNlX2FyZ3MrMHgxNmEvMHgyMGIKWyAgICAzLjQ2MDM2NV0gIFs8Nzk4NmY5ZmM+XSBrZXJu
ZWxfaW5pdF9mcmVlYWJsZSsweGQ4LzB4MTVkClsgICAgMy40NjAzNjVdICBbPDc5NTE1ZmMw
Pl0ga2VybmVsX2luaXQrMHg4LzB4YjQKWyAgICAzLjQ2MDM2NV0gIFs8Nzk1Mjc4Zjc+XSBy
ZXRfZnJvbV9rZXJuZWxfdGhyZWFkKzB4MWIvMHgyOApbICAgIDMuNDYwMzY1XSAgWzw3OTUx
NWZiOD5dID8gcmVzdF9pbml0KzB4MTE4LzB4MTE4ClsgICAgMy40NjAzNjVdIC0tLVsgZW5k
IHRyYWNlIGM1ZTY1ODQ1NzYzMzM2N2EgXS0tLQova2VybmVsL2kzODYtcmFuZGNvbmZpZy1q
NC0wODI3MTA1Ni80YTIyNWI0NjZlMDQwYTcwZTdkMTJiMTU5ZDJhMzZkYTFjMmVmN2RjL2Rt
ZXNnLWt2bS14Z3dvLTEyMDAyLTIwMTMwODI3MTY0NzI2LTMuMTEuMC1yYzYtMDUxMDMtZzRh
MjI1YjQtMjU5CgpCaXNlY3Rpbmc6IDExMTUgcmV2aXNpb25zIGxlZnQgdG8gdGVzdCBhZnRl
ciB0aGlzIChyb3VnaGx5IDEwIHN0ZXBzKQpbOTgyNDZjMWFlNmYxOGZlMWI3MTBjZGZmNjg3
YjZiNzA3N2Y3MzljOV0gTWVyZ2UgcmVtb3RlLXRyYWNraW5nIGJyYW5jaCAndmlydGlvL3Zp
cnRpby1uZXh0JwpydW5uaW5nIC9jL2tlcm5lbC10ZXN0cy9iaXNlY3QtdGVzdC1ib290LWZh
aWx1cmUuc2ggL2hvbWUvd2ZnL3NvdW5kL29iai1iaXNlY3QKbHMgLWEgL2tlcm5lbC10ZXN0
cy9ydW4tcXVldWUva3ZtL2kzODYtcmFuZGNvbmZpZy1qNC0wODI3MTA1Ni9uZXh0Om1hc3Rl
cjo5ODI0NmMxYWU2ZjE4ZmUxYjcxMGNkZmY2ODdiNmI3MDc3ZjczOWM5OmJpc2VjdC1zb3Vu
ZAoKMjAxMy0wOC0yNy0xNjo1MjoyMCA5ODI0NmMxYWU2ZjE4ZmUxYjcxMGNkZmY2ODdiNmI3
MDc3ZjczOWM5IGNvbXBpbGluZwoyNzYgcmVhbCAgMjIxNiB1c2VyICAyNDMgc3lzICA4OTEu
MDQlIGNwdSAJaTM4Ni1yYW5kY29uZmlnLWo0LTA4MjcxMDU2CgoyMDEzLTA4LTI3LTE2OjU3
OjIxIGRldGVjdGluZyBib290IHN0YXRlIDMuMTEuMC1yYzYtMDM5ODctZzk4MjQ2YzEuLi4u
Li4JMQkyCTMJNAk1CTYuCTcuLgk4Li4uLi4JOS4uLgkxMi4uCTE1LgkxOQkyMAkyMwkyNS4J
MjcJMjguLgkzMi4JMzMuLi4uLgkzNC4uLi4uLi4uLi4uLgkzNS4JMzYuLi4JMzcJMzkuCTQx
Lgk0Mi4uCTQ0Li4uLi4uLi4JNDYJNDcuLi4JNDkuLi4uLi4JNTAJNTEJNTIuCTU0Li4uLi4u
Li4uLgk1NSBTVUNDRVNTCgpCaXNlY3Rpbmc6IDU1NSByZXZpc2lvbnMgbGVmdCB0byB0ZXN0
IGFmdGVyIHRoaXMgKHJvdWdobHkgOSBzdGVwcykKWzM4MTM2YzFmMTQ3MWM3ZGNiZTg4OWJl
Yjc5MGNjNGQzMzFlOWQzYWRdIE1lcmdlIHJlbW90ZS10cmFja2luZyBicmFuY2ggJ3NwaS9m
b3ItbmV4dCcKcnVubmluZyAvYy9rZXJuZWwtdGVzdHMvYmlzZWN0LXRlc3QtYm9vdC1mYWls
dXJlLnNoIC9ob21lL3dmZy9zb3VuZC9vYmotYmlzZWN0CmxzIC1hIC9rZXJuZWwtdGVzdHMv
cnVuLXF1ZXVlL2t2bS9pMzg2LXJhbmRjb25maWctajQtMDgyNzEwNTYvbmV4dDptYXN0ZXI6
MzgxMzZjMWYxNDcxYzdkY2JlODg5YmViNzkwY2M0ZDMzMWU5ZDNhZDpiaXNlY3Qtc291bmQK
CjIwMTMtMDgtMjctMTc6NTM6MjcgMzgxMzZjMWYxNDcxYzdkY2JlODg5YmViNzkwY2M0ZDMz
MWU5ZDNhZCBjb21waWxpbmcKMjc5IHJlYWwgIDIyMjQgdXNlciAgMjQ3IHN5cyAgODg0LjQw
JSBjcHUgCWkzODYtcmFuZGNvbmZpZy1qNC0wODI3MTA1NgoKMjAxMy0wOC0yNy0xNzo1ODoz
OSBkZXRlY3RpbmcgYm9vdCBzdGF0ZSAzLjExLjAtcmM2LTA0NTQ3LWczODEzNmMxLi4uLi4u
Li4uLi4JNi4uCTcJOAk5LgkxMC4uCTExLi4uCTEzCTE0CTE2CTE3Li4JMjAJMjEJMjIJMjMu
LgkyNgkyNy4uLgkzMAkzMQkzMi4uLgkzNQkzNgkzNy4JMzgJNDQuCTQ3CTQ5CTUwCTUxLgk1
Mgk1My4uLi4uLi4uLi4uLi4uLi4uLi4uLgk1NC4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4u
Li4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLgk1NSBTVUNDRVNTCgpCaXNlY3Rpbmc6IDI3
NSByZXZpc2lvbnMgbGVmdCB0byB0ZXN0IGFmdGVyIHRoaXMgKHJvdWdobHkgOCBzdGVwcykK
W2YwNzc2MmJlM2I5MjIyYTc2NDljYjI5YTNmNWI5NTkyMDRkNDA0NDZdIE1lcmdlIGJyYW5j
aCAneDg2L2FzbWxpbmthZ2UnCnJ1bm5pbmcgL2Mva2VybmVsLXRlc3RzL2Jpc2VjdC10ZXN0
LWJvb3QtZmFpbHVyZS5zaCAvaG9tZS93Zmcvc291bmQvb2JqLWJpc2VjdApscyAtYSAva2Vy
bmVsLXRlc3RzL3J1bi1xdWV1ZS9rdm0vaTM4Ni1yYW5kY29uZmlnLWo0LTA4MjcxMDU2L25l
eHQ6bWFzdGVyOmYwNzc2MmJlM2I5MjIyYTc2NDljYjI5YTNmNWI5NTkyMDRkNDA0NDY6Ymlz
ZWN0LXNvdW5kCgoyMDEzLTA4LTI3LTE5OjA4OjEyIGYwNzc2MmJlM2I5MjIyYTc2NDljYjI5
YTNmNWI5NTkyMDRkNDA0NDYgY29tcGlsaW5nCjYzNiByZWFsICAyMjA3IHVzZXIgIDI0MiBz
eXMgIDM4NS4xMiUgY3B1IAlpMzg2LXJhbmRjb25maWctajQtMDgyNzEwNTYKL2Jpbi9ta2Rp
cjogY2Fubm90IGNyZWF0ZSBkaXJlY3RvcnkgJy9rZXJuZWwvaTM4Ni1yYW5kY29uZmlnLWo0
LTA4MjcxMDU2L2YwNzc2MmJlM2I5MjIyYTc2NDljYjI5YTNmNWI5NTkyMDRkNDA0NDYnOiBO
byBzcGFjZSBsZWZ0IG9uIGRldmljZQpjcDogdGFyZ2V0ICcva2VybmVsL2kzODYtcmFuZGNv
bmZpZy1qNC0wODI3MTA1Ni9mMDc3NjJiZTNiOTIyMmE3NjQ5Y2IyOWEzZjViOTU5MjA0ZDQw
NDQ2LycgaXMgbm90IGEgZGlyZWN0b3J5Ci9zYmluL2luc3RhbGxrZXJuZWw6IGxpbmUgNDI6
IC9rZXJuZWwvaTM4Ni1yYW5kY29uZmlnLWo0LTA4MjcxMDU2L2YwNzc2MmJlM2I5MjIyYTc2
NDljYjI5YTNmNWI5NTkyMDRkNDA0NDYvdm1saW51ei0zLjExLjAtcmM2LTAxMDk1LWdmMDc3
NjJiOiBObyBzdWNoIGZpbGUgb3IgZGlyZWN0b3J5Cm1rZGlyOiBjYW5ub3QgY3JlYXRlIGRp
cmVjdG9yeSAnL2tlcm5lbC9pMzg2LXJhbmRjb25maWctajQtMDgyNzEwNTYvZjA3NzYyYmUz
YjkyMjJhNzY0OWNiMjlhM2Y1Yjk1OTIwNGQ0MDQ0Nic6IE5vIHNwYWNlIGxlZnQgb24gZGV2
aWNlCm1ha2VbMV06ICoqKiBbX21vZGluc3RfXSBFcnJvciAxCm1ha2VbMV06IFRhcmdldCBg
bW9kdWxlc19pbnN0YWxsJyBub3QgcmVtYWRlIGJlY2F1c2Ugb2YgZXJyb3JzLgptYWtlOiAq
KiogW3N1Yi1tYWtlXSBFcnJvciAyChtbMTszNW1GYWlsZWQgdG8gaW5zdGFsbCBrZXJuZWw6
IG1ha2UgbW9kdWxlc19pbnN0YWxsIGZhaWxlZCB3aXRoIGNvZGUgMRtbMG0KMjAxMy0wOC0y
Ny0xOToxOToxNSBmMDc3NjJiZTNiOTIyMmE3NjQ5Y2IyOWEzZjViOTU5MjA0ZDQwNDQ2IFNL
SVAgQlJPS0VOIEJVSUxECkNoZWNrIGVycm9zIGluIC9jYy93Zmcvc291bmQtYmlzZWN0IGFu
ZCAvdG1wL2tlcm5lbC9pMzg2LXJhbmRjb25maWctajQtMDgyNzEwNTYvZjA3NzYyYmUzYjky
MjJhNzY0OWNiMjlhM2Y1Yjk1OTIwNGQ0MDQ0NgpCaXNlY3Rpbmc6IDI3NSByZXZpc2lvbnMg
bGVmdCB0byB0ZXN0IGFmdGVyIHRoaXMgKHJvdWdobHkgOCBzdGVwcykKW2FkOWRlZjdjYTAy
MGVmNWI1NDk2OGM4OTE5NGY1MmQxOGVmMWVmNDldIHBlcmYgc2NoZWQ6IFNpbXBsaWZ5IGFy
Z3VtZW50cyB0byByZWFkX2V2ZW50cwpydW5uaW5nIC9jL2tlcm5lbC10ZXN0cy9iaXNlY3Qt
dGVzdC1ib290LWZhaWx1cmUuc2ggL2hvbWUvd2ZnL3NvdW5kL29iai1iaXNlY3QKbHMgLWEg
L2tlcm5lbC10ZXN0cy9ydW4tcXVldWUva3ZtL2kzODYtcmFuZGNvbmZpZy1qNC0wODI3MTA1
Ni9uZXh0Om1hc3RlcjphZDlkZWY3Y2EwMjBlZjViNTQ5NjhjODkxOTRmNTJkMThlZjFlZjQ5
OmJpc2VjdC1zb3VuZAoKMjAxMy0wOC0yNy0xOToxOToxNyBhZDlkZWY3Y2EwMjBlZjViNTQ5
NjhjODkxOTRmNTJkMThlZjFlZjQ5IGNvbXBpbGluZwoyOTIgcmVhbCAgMjI0OSB1c2VyICAy
NDYgc3lzICA4NTMuOTglIGNwdSAJaTM4Ni1yYW5kY29uZmlnLWo0LTA4MjcxMDU2Ci9iaW4v
bWtkaXI6IGNhbm5vdCBjcmVhdGUgZGlyZWN0b3J5ICcva2VybmVsL2kzODYtcmFuZGNvbmZp
Zy1qNC0wODI3MTA1Ni9hZDlkZWY3Y2EwMjBlZjViNTQ5NjhjODkxOTRmNTJkMThlZjFlZjQ5
JzogTm8gc3BhY2UgbGVmdCBvbiBkZXZpY2UKY3A6IHRhcmdldCAnL2tlcm5lbC9pMzg2LXJh
bmRjb25maWctajQtMDgyNzEwNTYvYWQ5ZGVmN2NhMDIwZWY1YjU0OTY4Yzg5MTk0ZjUyZDE4
ZWYxZWY0OS8nIGlzIG5vdCBhIGRpcmVjdG9yeQovc2Jpbi9pbnN0YWxsa2VybmVsOiBsaW5l
IDQyOiAva2VybmVsL2kzODYtcmFuZGNvbmZpZy1qNC0wODI3MTA1Ni9hZDlkZWY3Y2EwMjBl
ZjViNTQ5NjhjODkxOTRmNTJkMThlZjFlZjQ5L3ZtbGludXotMy4xMS4wLXJjMS0wMDMyOS1n
YWQ5ZGVmNzogTm8gc3VjaCBmaWxlIG9yIGRpcmVjdG9yeQpta2RpcjogY2Fubm90IGNyZWF0
ZSBkaXJlY3RvcnkgJy9rZXJuZWwvaTM4Ni1yYW5kY29uZmlnLWo0LTA4MjcxMDU2L2FkOWRl
ZjdjYTAyMGVmNWI1NDk2OGM4OTE5NGY1MmQxOGVmMWVmNDknOiBObyBzcGFjZSBsZWZ0IG9u
IGRldmljZQptYWtlWzFdOiAqKiogW19tb2RpbnN0X10gRXJyb3IgMQptYWtlWzFdOiBUYXJn
ZXQgYG1vZHVsZXNfaW5zdGFsbCcgbm90IHJlbWFkZSBiZWNhdXNlIG9mIGVycm9ycy4KbWFr
ZTogKioqIFtzdWItbWFrZV0gRXJyb3IgMgobWzE7MzVtRmFpbGVkIHRvIGluc3RhbGwga2Vy
bmVsOiBtYWtlIG1vZHVsZXNfaW5zdGFsbCBmYWlsZWQgd2l0aCBjb2RlIDEbWzBtCjIwMTMt
MDgtMjctMTk6MjY6MjEgYWQ5ZGVmN2NhMDIwZWY1YjU0OTY4Yzg5MTk0ZjUyZDE4ZWYxZWY0
OSBTS0lQIEJST0tFTiBCVUlMRApDaGVjayBlcnJvcyBpbiAvY2Mvd2ZnL3NvdW5kLWJpc2Vj
dCBhbmQgL3RtcC9rZXJuZWwvaTM4Ni1yYW5kY29uZmlnLWo0LTA4MjcxMDU2L2FkOWRlZjdj
YTAyMGVmNWI1NDk2OGM4OTE5NGY1MmQxOGVmMWVmNDkKQmlzZWN0aW5nOiAyNzUgcmV2aXNp
b25zIGxlZnQgdG8gdGVzdCBhZnRlciB0aGlzIChyb3VnaGx5IDggc3RlcHMpClsxMDNhZjBh
OTg3ODg1OTJiNzZlZTY5YTEzOTQ4YjZiMzAzNmQ3ZTE4XSBwZXJmLCBrdm06IFN1cHBvcnQg
dGhlIGluX3R4L2luX3R4X2NwIG1vZGlmaWVycyBpbiBLVk0gYXJjaCBwZXJmbW9uIGVtdWxh
dGlvbiB2NQpydW5uaW5nIC9jL2tlcm5lbC10ZXN0cy9iaXNlY3QtdGVzdC1ib290LWZhaWx1
cmUuc2ggL2hvbWUvd2ZnL3NvdW5kL29iai1iaXNlY3QKbHMgLWEgL2tlcm5lbC10ZXN0cy9y
dW4tcXVldWUva3ZtL2kzODYtcmFuZGNvbmZpZy1qNC0wODI3MTA1Ni9uZXh0Om1hc3Rlcjox
MDNhZjBhOTg3ODg1OTJiNzZlZTY5YTEzOTQ4YjZiMzAzNmQ3ZTE4OmJpc2VjdC1zb3VuZAoK
MjAxMy0wOC0yNy0xOToyNjoyMiAxMDNhZjBhOTg3ODg1OTJiNzZlZTY5YTEzOTQ4YjZiMzAz
NmQ3ZTE4IGNvbXBpbGluZwoyNjYgcmVhbCAgMjIxMCB1c2VyICAyNDMgc3lzICA5MjAuNjUl
IGNwdSAJaTM4Ni1yYW5kY29uZmlnLWo0LTA4MjcxMDU2Ci9iaW4vbWtkaXI6IGNhbm5vdCBj
cmVhdGUgZGlyZWN0b3J5ICcva2VybmVsL2kzODYtcmFuZGNvbmZpZy1qNC0wODI3MTA1Ni8x
MDNhZjBhOTg3ODg1OTJiNzZlZTY5YTEzOTQ4YjZiMzAzNmQ3ZTE4JzogTm8gc3BhY2UgbGVm
dCBvbiBkZXZpY2UKY3A6IHRhcmdldCAnL2tlcm5lbC9pMzg2LXJhbmRjb25maWctajQtMDgy
NzEwNTYvMTAzYWYwYTk4Nzg4NTkyYjc2ZWU2OWExMzk0OGI2YjMwMzZkN2UxOC8nIGlzIG5v
dCBhIGRpcmVjdG9yeQovc2Jpbi9pbnN0YWxsa2VybmVsOiBsaW5lIDQyOiAva2VybmVsL2kz
ODYtcmFuZGNvbmZpZy1qNC0wODI3MTA1Ni8xMDNhZjBhOTg3ODg1OTJiNzZlZTY5YTEzOTQ4
YjZiMzAzNmQ3ZTE4L3ZtbGludXotMy4xMS4wLXJjMS0wMDAxMy1nMTAzYWYwYTogTm8gc3Vj
aCBmaWxlIG9yIGRpcmVjdG9yeQpta2RpcjogY2Fubm90IGNyZWF0ZSBkaXJlY3RvcnkgJy9r
ZXJuZWwvaTM4Ni1yYW5kY29uZmlnLWo0LTA4MjcxMDU2LzEwM2FmMGE5ODc4ODU5MmI3NmVl
NjlhMTM5NDhiNmIzMDM2ZDdlMTgnOiBObyBzcGFjZSBsZWZ0IG9uIGRldmljZQptYWtlWzFd
OiAqKiogW19tb2RpbnN0X10gRXJyb3IgMQptYWtlWzFdOiBUYXJnZXQgYG1vZHVsZXNfaW5z
dGFsbCcgbm90IHJlbWFkZSBiZWNhdXNlIG9mIGVycm9ycy4KbWFrZTogKioqIFtzdWItbWFr
ZV0gRXJyb3IgMgobWzE7MzVtRmFpbGVkIHRvIGluc3RhbGwga2VybmVsOiBtYWtlIG1vZHVs
ZXNfaW5zdGFsbCBmYWlsZWQgd2l0aCBjb2RlIDEbWzBtCjIwMTMtMDgtMjctMTk6MzE6MjEg
MTAzYWYwYTk4Nzg4NTkyYjc2ZWU2OWExMzk0OGI2YjMwMzZkN2UxOCBTS0lQIEJST0tFTiBC
VUlMRApDaGVjayBlcnJvcyBpbiAvY2Mvd2ZnL3NvdW5kLWJpc2VjdCBhbmQgL3RtcC9rZXJu
ZWwvaTM4Ni1yYW5kY29uZmlnLWo0LTA4MjcxMDU2LzEwM2FmMGE5ODc4ODU5MmI3NmVlNjlh
MTM5NDhiNmIzMDM2ZDdlMTgKQmlzZWN0aW5nOiAyNzUgcmV2aXNpb25zIGxlZnQgdG8gdGVz
dCBhZnRlciB0aGlzIChyb3VnaGx5IDggc3RlcHMpClszNjAzNWY3OGFlMTcxNGEwNzYyYTJi
MzhiNjQ5NDJkNmRjYjY0NzFkXSBwZXJmIHRvcDogU2V0IHRoZSBtYWNoaW5lcyBzeW1ib2wg
ZmlsdGVyCnJ1bm5pbmcgL2Mva2VybmVsLXRlc3RzL2Jpc2VjdC10ZXN0LWJvb3QtZmFpbHVy
ZS5zaCAvaG9tZS93Zmcvc291bmQvb2JqLWJpc2VjdApscyAtYSAva2VybmVsLXRlc3RzL3J1
bi1xdWV1ZS9rdm0vaTM4Ni1yYW5kY29uZmlnLWo0LTA4MjcxMDU2L25leHQ6bWFzdGVyOjM2
MDM1Zjc4YWUxNzE0YTA3NjJhMmIzOGI2NDk0MmQ2ZGNiNjQ3MWQ6YmlzZWN0LXNvdW5kCgoy
MDEzLTA4LTI3LTE5OjMxOjIyIDM2MDM1Zjc4YWUxNzE0YTA3NjJhMmIzOGI2NDk0MmQ2ZGNi
NjQ3MWQgY29tcGlsaW5nCjI4MiByZWFsICAyMTk0IHVzZXIgIDI0MyBzeXMgIDg2My4yNyUg
Y3B1IAlpMzg2LXJhbmRjb25maWctajQtMDgyNzEwNTYKL2Jpbi9ta2RpcjogY2Fubm90IGNy
ZWF0ZSBkaXJlY3RvcnkgJy9rZXJuZWwvaTM4Ni1yYW5kY29uZmlnLWo0LTA4MjcxMDU2LzM2
MDM1Zjc4YWUxNzE0YTA3NjJhMmIzOGI2NDk0MmQ2ZGNiNjQ3MWQnOiBObyBzcGFjZSBsZWZ0
IG9uIGRldmljZQpjcDogdGFyZ2V0ICcva2VybmVsL2kzODYtcmFuZGNvbmZpZy1qNC0wODI3
MTA1Ni8zNjAzNWY3OGFlMTcxNGEwNzYyYTJiMzhiNjQ5NDJkNmRjYjY0NzFkLycgaXMgbm90
IGEgZGlyZWN0b3J5Ci9zYmluL2luc3RhbGxrZXJuZWw6IGxpbmUgNDI6IC9rZXJuZWwvaTM4
Ni1yYW5kY29uZmlnLWo0LTA4MjcxMDU2LzM2MDM1Zjc4YWUxNzE0YTA3NjJhMmIzOGI2NDk0
MmQ2ZGNiNjQ3MWQvdm1saW51ei0zLjExLjAtcmMxLTAwMzM4LWczNjAzNWY3OiBObyBzdWNo
IGZpbGUgb3IgZGlyZWN0b3J5Cm1rZGlyOiBjYW5ub3QgY3JlYXRlIGRpcmVjdG9yeSAnL2tl
cm5lbC9pMzg2LXJhbmRjb25maWctajQtMDgyNzEwNTYvMzYwMzVmNzhhZTE3MTRhMDc2MmEy
YjM4YjY0OTQyZDZkY2I2NDcxZCc6IE5vIHNwYWNlIGxlZnQgb24gZGV2aWNlCm1ha2VbMV06
ICoqKiBbX21vZGluc3RfXSBFcnJvciAxCm1ha2VbMV06IFRhcmdldCBgbW9kdWxlc19pbnN0
YWxsJyBub3QgcmVtYWRlIGJlY2F1c2Ugb2YgZXJyb3JzLgptYWtlOiAqKiogW3N1Yi1tYWtl
XSBFcnJvciAyChtbMTszNW1GYWlsZWQgdG8gaW5zdGFsbCBrZXJuZWw6IG1ha2UgbW9kdWxl
c19pbnN0YWxsIGZhaWxlZCB3aXRoIGNvZGUgMRtbMG0KMjAxMy0wOC0yNy0xOTozNjo0MiAz
NjAzNWY3OGFlMTcxNGEwNzYyYTJiMzhiNjQ5NDJkNmRjYjY0NzFkIFNLSVAgQlJPS0VOIEJV
SUxECkNoZWNrIGVycm9zIGluIC9jYy93Zmcvc291bmQtYmlzZWN0IGFuZCAvdG1wL2tlcm5l
bC9pMzg2LXJhbmRjb25maWctajQtMDgyNzEwNTYvMzYwMzVmNzhhZTE3MTRhMDc2MmEyYjM4
YjY0OTQyZDZkY2I2NDcxZApCaXNlY3Rpbmc6IDI3NSByZXZpc2lvbnMgbGVmdCB0byB0ZXN0
IGFmdGVyIHRoaXMgKHJvdWdobHkgOCBzdGVwcykKWzNlZjAyOTZhMGI3N2Q3MDU4NWUyM2Jl
OTNhNTE0NGU3NjRhMjc4MWVdIHhlbi9ldmVudHM6IGRvY3VtZW50IGJlaGF2aW91ciB3aGVu
IHNjYW5uaW5nIHRoZSBzdGFydCB3b3JkIGZvciBldmVudHMKcnVubmluZyAvYy9rZXJuZWwt
dGVzdHMvYmlzZWN0LXRlc3QtYm9vdC1mYWlsdXJlLnNoIC9ob21lL3dmZy9zb3VuZC9vYmot
YmlzZWN0CmxzIC1hIC9rZXJuZWwtdGVzdHMvcnVuLXF1ZXVlL2t2bS9pMzg2LXJhbmRjb25m
aWctajQtMDgyNzEwNTYvbmV4dDptYXN0ZXI6M2VmMDI5NmEwYjc3ZDcwNTg1ZTIzYmU5M2E1
MTQ0ZTc2NGEyNzgxZTpiaXNlY3Qtc291bmQKCjIwMTMtMDgtMjctMTk6MzY6NDMgM2VmMDI5
NmEwYjc3ZDcwNTg1ZTIzYmU5M2E1MTQ0ZTc2NGEyNzgxZSBjb21waWxpbmcKMjY0IHJlYWwg
IDIyMDcgdXNlciAgMjM4IHN5cyAgOTIzLjA2JSBjcHUgCWkzODYtcmFuZGNvbmZpZy1qNC0w
ODI3MTA1NgovYmluL21rZGlyOiBjYW5ub3QgY3JlYXRlIGRpcmVjdG9yeSAnL2tlcm5lbC9p
Mzg2LXJhbmRjb25maWctajQtMDgyNzEwNTYvM2VmMDI5NmEwYjc3ZDcwNTg1ZTIzYmU5M2E1
MTQ0ZTc2NGEyNzgxZSc6IE5vIHNwYWNlIGxlZnQgb24gZGV2aWNlCmNwOiB0YXJnZXQgJy9r
ZXJuZWwvaTM4Ni1yYW5kY29uZmlnLWo0LTA4MjcxMDU2LzNlZjAyOTZhMGI3N2Q3MDU4NWUy
M2JlOTNhNTE0NGU3NjRhMjc4MWUvJyBpcyBub3QgYSBkaXJlY3RvcnkKL3NiaW4vaW5zdGFs
bGtlcm5lbDogbGluZSA0MjogL2tlcm5lbC9pMzg2LXJhbmRjb25maWctajQtMDgyNzEwNTYv
M2VmMDI5NmEwYjc3ZDcwNTg1ZTIzYmU5M2E1MTQ0ZTc2NGEyNzgxZS92bWxpbnV6LTMuMTEu
MC1yYzQtMDA0MDktZzNlZjAyOTY6IE5vIHN1Y2ggZmlsZSBvciBkaXJlY3RvcnkKbWtkaXI6
IGNhbm5vdCBjcmVhdGUgZGlyZWN0b3J5ICcva2VybmVsL2kzODYtcmFuZGNvbmZpZy1qNC0w
ODI3MTA1Ni8zZWYwMjk2YTBiNzdkNzA1ODVlMjNiZTkzYTUxNDRlNzY0YTI3ODFlJzogTm8g
c3BhY2UgbGVmdCBvbiBkZXZpY2UKbWFrZVsxXTogKioqIFtfbW9kaW5zdF9dIEVycm9yIDEK
bWFrZVsxXTogVGFyZ2V0IGBtb2R1bGVzX2luc3RhbGwnIG5vdCByZW1hZGUgYmVjYXVzZSBv
ZiBlcnJvcnMuCm1ha2U6ICoqKiBbc3ViLW1ha2VdIEVycm9yIDIKG1sxOzM1bUZhaWxlZCB0
byBpbnN0YWxsIGtlcm5lbDogbWFrZSBtb2R1bGVzX2luc3RhbGwgZmFpbGVkIHdpdGggY29k
ZSAxG1swbQoyMDEzLTA4LTI3LTE5OjQxOjQ4IDNlZjAyOTZhMGI3N2Q3MDU4NWUyM2JlOTNh
NTE0NGU3NjRhMjc4MWUgU0tJUCBCUk9LRU4gQlVJTEQKQ2hlY2sgZXJyb3MgaW4gL2NjL3dm
Zy9zb3VuZC1iaXNlY3QgYW5kIC90bXAva2VybmVsL2kzODYtcmFuZGNvbmZpZy1qNC0wODI3
MTA1Ni8zZWYwMjk2YTBiNzdkNzA1ODVlMjNiZTkzYTUxNDRlNzY0YTI3ODFlCkJpc2VjdGlu
ZzogMjc1IHJldmlzaW9ucyBsZWZ0IHRvIHRlc3QgYWZ0ZXIgdGhpcyAocm91Z2hseSA4IHN0
ZXBzKQpbMmFlM2EzMTJjMGNjZDhmZjYxNTM3MmYwMGFhYjE3MDBhYWMyNzQ3NF0gcGVyZiB0
cmFjZTogQWxsb3cgc3BlY2lmeWluZyB3aGljaCBzeXNjYWxscyB0byB0cmFjZQpydW5uaW5n
IC9jL2tlcm5lbC10ZXN0cy9iaXNlY3QtdGVzdC1ib290LWZhaWx1cmUuc2ggL2hvbWUvd2Zn
L3NvdW5kL29iai1iaXNlY3QKbHMgLWEgL2tlcm5lbC10ZXN0cy9ydW4tcXVldWUva3ZtL2kz
ODYtcmFuZGNvbmZpZy1qNC0wODI3MTA1Ni9uZXh0Om1hc3RlcjoyYWUzYTMxMmMwY2NkOGZm
NjE1MzcyZjAwYWFiMTcwMGFhYzI3NDc0OmJpc2VjdC1zb3VuZAoKMjAxMy0wOC0yNy0xOTo0
MTo1MCAyYWUzYTMxMmMwY2NkOGZmNjE1MzcyZjAwYWFiMTcwMGFhYzI3NDc0IGNvbXBpbGlu
ZwoyODggcmVhbCAgMjIyMSB1c2VyICAyNDAgc3lzICA4NTQuNjklIGNwdSAJaTM4Ni1yYW5k
Y29uZmlnLWo0LTA4MjcxMDU2Ci9iaW4vbWtkaXI6IGNhbm5vdCBjcmVhdGUgZGlyZWN0b3J5
ICcva2VybmVsL2kzODYtcmFuZGNvbmZpZy1qNC0wODI3MTA1Ni8yYWUzYTMxMmMwY2NkOGZm
NjE1MzcyZjAwYWFiMTcwMGFhYzI3NDc0JzogTm8gc3BhY2UgbGVmdCBvbiBkZXZpY2UKY3A6
IHRhcmdldCAnL2tlcm5lbC9pMzg2LXJhbmRjb25maWctajQtMDgyNzEwNTYvMmFlM2EzMTJj
MGNjZDhmZjYxNTM3MmYwMGFhYjE3MDBhYWMyNzQ3NC8nIGlzIG5vdCBhIGRpcmVjdG9yeQov
c2Jpbi9pbnN0YWxsa2VybmVsOiBsaW5lIDQyOiAva2VybmVsL2kzODYtcmFuZGNvbmZpZy1q
NC0wODI3MTA1Ni8yYWUzYTMxMmMwY2NkOGZmNjE1MzcyZjAwYWFiMTcwMGFhYzI3NDc0L3Zt
bGludXotMy4xMS4wLXJjMS0wMDM0Ny1nMmFlM2EzMTogTm8gc3VjaCBmaWxlIG9yIGRpcmVj
dG9yeQpta2RpcjogY2Fubm90IGNyZWF0ZSBkaXJlY3RvcnkgJy9rZXJuZWwvaTM4Ni1yYW5k
Y29uZmlnLWo0LTA4MjcxMDU2LzJhZTNhMzEyYzBjY2Q4ZmY2MTUzNzJmMDBhYWIxNzAwYWFj
Mjc0NzQnOiBObyBzcGFjZSBsZWZ0IG9uIGRldmljZQptYWtlWzFdOiAqKiogW19tb2RpbnN0
X10gRXJyb3IgMQptYWtlWzFdOiBUYXJnZXQgYG1vZHVsZXNfaW5zdGFsbCcgbm90IHJlbWFk
ZSBiZWNhdXNlIG9mIGVycm9ycy4KbWFrZTogKioqIFtzdWItbWFrZV0gRXJyb3IgMgobWzE7
MzVtRmFpbGVkIHRvIGluc3RhbGwga2VybmVsOiBtYWtlIG1vZHVsZXNfaW5zdGFsbCBmYWls
ZWQgd2l0aCBjb2RlIDEbWzBtCjIwMTMtMDgtMjctMTk6NDc6MTkgMmFlM2EzMTJjMGNjZDhm
ZjYxNTM3MmYwMGFhYjE3MDBhYWMyNzQ3NCBTS0lQIEJST0tFTiBCVUlMRApDaGVjayBlcnJv
cyBpbiAvY2Mvd2ZnL3NvdW5kLWJpc2VjdCBhbmQgL3RtcC9rZXJuZWwvaTM4Ni1yYW5kY29u
ZmlnLWo0LTA4MjcxMDU2LzJhZTNhMzEyYzBjY2Q4ZmY2MTUzNzJmMDBhYWIxNzAwYWFjMjc0
NzQKQmlzZWN0aW5nOiAyNzUgcmV2aXNpb25zIGxlZnQgdG8gdGVzdCBhZnRlciB0aGlzIChy
b3VnaGx5IDggc3RlcHMpCltlZTA3MjY0MDdmZWFmNTA0ZGZmMzA0ZmI2MDM2NTJmYjJkNzc4
YjQyXSB4ZW4vbTJwOiB1c2UgR05UVEFCT1BfdW5tYXBfYW5kX3JlcGxhY2UgdG8gcmVpbnN0
YXRlIHRoZSBvcmlnaW5hbCBtYXBwaW5nCnJ1bm5pbmcgL2Mva2VybmVsLXRlc3RzL2Jpc2Vj
dC10ZXN0LWJvb3QtZmFpbHVyZS5zaCAvaG9tZS93Zmcvc291bmQvb2JqLWJpc2VjdApscyAt
YSAva2VybmVsLXRlc3RzL3J1bi1xdWV1ZS9rdm0vaTM4Ni1yYW5kY29uZmlnLWo0LTA4Mjcx
MDU2L25leHQ6bWFzdGVyOmVlMDcyNjQwN2ZlYWY1MDRkZmYzMDRmYjYwMzY1MmZiMmQ3Nzhi
NDI6YmlzZWN0LXNvdW5kCgoyMDEzLTA4LTI3LTE5OjQ3OjIwIGVlMDcyNjQwN2ZlYWY1MDRk
ZmYzMDRmYjYwMzY1MmZiMmQ3NzhiNDIgY29tcGlsaW5nCjI3MSByZWFsICAyMTgwIHVzZXIg
IDI0MSBzeXMgIDg5MS41NiUgY3B1IAlpMzg2LXJhbmRjb25maWctajQtMDgyNzEwNTYKL2Jp
bi9ta2RpcjogY2Fubm90IGNyZWF0ZSBkaXJlY3RvcnkgJy9rZXJuZWwvaTM4Ni1yYW5kY29u
ZmlnLWo0LTA4MjcxMDU2L2VlMDcyNjQwN2ZlYWY1MDRkZmYzMDRmYjYwMzY1MmZiMmQ3Nzhi
NDInOiBObyBzcGFjZSBsZWZ0IG9uIGRldmljZQpjcDogdGFyZ2V0ICcva2VybmVsL2kzODYt
cmFuZGNvbmZpZy1qNC0wODI3MTA1Ni9lZTA3MjY0MDdmZWFmNTA0ZGZmMzA0ZmI2MDM2NTJm
YjJkNzc4YjQyLycgaXMgbm90IGEgZGlyZWN0b3J5Ci9zYmluL2luc3RhbGxrZXJuZWw6IGxp
bmUgNDI6IC9rZXJuZWwvaTM4Ni1yYW5kY29uZmlnLWo0LTA4MjcxMDU2L2VlMDcyNjQwN2Zl
YWY1MDRkZmYzMDRmYjYwMzY1MmZiMmQ3NzhiNDIvdm1saW51ei0zLjExLjAtcmM0LTAwNDEy
LWdlZTA3MjY0OiBObyBzdWNoIGZpbGUgb3IgZGlyZWN0b3J5Cm1rZGlyOiBjYW5ub3QgY3Jl
YXRlIGRpcmVjdG9yeSAnL2tlcm5lbC9pMzg2LXJhbmRjb25maWctajQtMDgyNzEwNTYvZWUw
NzI2NDA3ZmVhZjUwNGRmZjMwNGZiNjAzNjUyZmIyZDc3OGI0Mic6IE5vIHNwYWNlIGxlZnQg
b24gZGV2aWNlCm1ha2VbMV06ICoqKiBbX21vZGluc3RfXSBFcnJvciAxCm1ha2VbMV06IFRh
cmdldCBgbW9kdWxlc19pbnN0YWxsJyBub3QgcmVtYWRlIGJlY2F1c2Ugb2YgZXJyb3JzLgpt
YWtlOiAqKiogW3N1Yi1tYWtlXSBFcnJvciAyChtbMTszNW1GYWlsZWQgdG8gaW5zdGFsbCBr
ZXJuZWw6IG1ha2UgbW9kdWxlc19pbnN0YWxsIGZhaWxlZCB3aXRoIGNvZGUgMRtbMG0KMjAx
My0wOC0yNy0xOTo1MjoyNSBlZTA3MjY0MDdmZWFmNTA0ZGZmMzA0ZmI2MDM2NTJmYjJkNzc4
YjQyIFNLSVAgQlJPS0VOIEJVSUxECkNoZWNrIGVycm9zIGluIC9jYy93Zmcvc291bmQtYmlz
ZWN0IGFuZCAvdG1wL2tlcm5lbC9pMzg2LXJhbmRjb25maWctajQtMDgyNzEwNTYvZWUwNzI2
NDA3ZmVhZjUwNGRmZjMwNGZiNjAzNjUyZmIyZDc3OGI0MgpCaXNlY3Rpbmc6IDI3NSByZXZp
c2lvbnMgbGVmdCB0byB0ZXN0IGFmdGVyIHRoaXMgKHJvdWdobHkgOCBzdGVwcykKWzk0OGIy
NmI2ZGRkMDhhNTdjYjk1ZWJiMGRjOTZmZGUyZWRkNWMzODNdIHBlcmY6IEFjY291bnQgZnJl
cSBldmVudHMgZ2xvYmFsbHkKcnVubmluZyAvYy9rZXJuZWwtdGVzdHMvYmlzZWN0LXRlc3Qt
Ym9vdC1mYWlsdXJlLnNoIC9ob21lL3dmZy9zb3VuZC9vYmotYmlzZWN0CmxzIC1hIC9rZXJu
ZWwtdGVzdHMvcnVuLXF1ZXVlL2t2bS9pMzg2LXJhbmRjb25maWctajQtMDgyNzEwNTYvbmV4
dDptYXN0ZXI6OTQ4YjI2YjZkZGQwOGE1N2NiOTVlYmIwZGM5NmZkZTJlZGQ1YzM4MzpiaXNl
Y3Qtc291bmQKCjIwMTMtMDgtMjctMTk6NTI6MjcgOTQ4YjI2YjZkZGQwOGE1N2NiOTVlYmIw
ZGM5NmZkZTJlZGQ1YzM4MyBjb21waWxpbmcKMjg1IHJlYWwgIDIyMzEgdXNlciAgMjQ1IHN5
cyAgODY4LjA3JSBjcHUgCWkzODYtcmFuZGNvbmZpZy1qNC0wODI3MTA1NgovYmluL21rZGly
OiBjYW5ub3QgY3JlYXRlIGRpcmVjdG9yeSAnL2tlcm5lbC9pMzg2LXJhbmRjb25maWctajQt
MDgyNzEwNTYvOTQ4YjI2YjZkZGQwOGE1N2NiOTVlYmIwZGM5NmZkZTJlZGQ1YzM4Myc6IE5v
IHNwYWNlIGxlZnQgb24gZGV2aWNlCmNwOiB0YXJnZXQgJy9rZXJuZWwvaTM4Ni1yYW5kY29u
ZmlnLWo0LTA4MjcxMDU2Lzk0OGIyNmI2ZGRkMDhhNTdjYjk1ZWJiMGRjOTZmZGUyZWRkNWMz
ODMvJyBpcyBub3QgYSBkaXJlY3RvcnkKL3NiaW4vaW5zdGFsbGtlcm5lbDogbGluZSA0Mjog
L2tlcm5lbC9pMzg2LXJhbmRjb25maWctajQtMDgyNzEwNTYvOTQ4YjI2YjZkZGQwOGE1N2Ni
OTVlYmIwZGM5NmZkZTJlZGQ1YzM4My92bWxpbnV6LTMuMTEuMC1yYzUtMDA4MDktZzk0OGIy
NmI6IE5vIHN1Y2ggZmlsZSBvciBkaXJlY3RvcnkKbWtkaXI6IGNhbm5vdCBjcmVhdGUgZGly
ZWN0b3J5ICcva2VybmVsL2kzODYtcmFuZGNvbmZpZy1qNC0wODI3MTA1Ni85NDhiMjZiNmRk
ZDA4YTU3Y2I5NWViYjBkYzk2ZmRlMmVkZDVjMzgzJzogTm8gc3BhY2UgbGVmdCBvbiBkZXZp
Y2UKbWFrZVsxXTogKioqIFtfbW9kaW5zdF9dIEVycm9yIDEKbWFrZVsxXTogVGFyZ2V0IGBt
b2R1bGVzX2luc3RhbGwnIG5vdCByZW1hZGUgYmVjYXVzZSBvZiBlcnJvcnMuCm1ha2U6ICoq
KiBbc3ViLW1ha2VdIEVycm9yIDIKG1sxOzM1bUZhaWxlZCB0byBpbnN0YWxsIGtlcm5lbDog
bWFrZSBtb2R1bGVzX2luc3RhbGwgZmFpbGVkIHdpdGggY29kZSAxG1swbQoyMDEzLTA4LTI3
LTE5OjU3OjUzIDk0OGIyNmI2ZGRkMDhhNTdjYjk1ZWJiMGRjOTZmZGUyZWRkNWMzODMgU0tJ
UCBCUk9LRU4gQlVJTEQKQ2hlY2sgZXJyb3MgaW4gL2NjL3dmZy9zb3VuZC1iaXNlY3QgYW5k
IC90bXAva2VybmVsL2kzODYtcmFuZGNvbmZpZy1qNC0wODI3MTA1Ni85NDhiMjZiNmRkZDA4
YTU3Y2I5NWViYjBkYzk2ZmRlMmVkZDVjMzgzCkJpc2VjdGluZzogMjc1IHJldmlzaW9ucyBs
ZWZ0IHRvIHRlc3QgYWZ0ZXIgdGhpcyAocm91Z2hseSA4IHN0ZXBzKQpbZDk4MjU5Y2JmOWYx
Yzg2ZTkyMWNhYTEyNDFhYThkMjI5MjQ5ZTBiOF0gSVNETjogY29udmVydCBjbGFzcyBjb2Rl
IHRvIHVzZSBkZXZfZ3JvdXBzCnJ1bm5pbmcgL2Mva2VybmVsLXRlc3RzL2Jpc2VjdC10ZXN0
LWJvb3QtZmFpbHVyZS5zaCAvaG9tZS93Zmcvc291bmQvb2JqLWJpc2VjdApscyAtYSAva2Vy
bmVsLXRlc3RzL3J1bi1xdWV1ZS9rdm0vaTM4Ni1yYW5kY29uZmlnLWo0LTA4MjcxMDU2L25l
eHQ6bWFzdGVyOmQ5ODI1OWNiZjlmMWM4NmU5MjFjYWExMjQxYWE4ZDIyOTI0OWUwYjg6Ymlz
ZWN0LXNvdW5kCgoyMDEzLTA4LTI3LTE5OjU3OjU0IGQ5ODI1OWNiZjlmMWM4NmU5MjFjYWEx
MjQxYWE4ZDIyOTI0OWUwYjggY29tcGlsaW5nCjI3MSByZWFsICAyMjE2IHVzZXIgIDI0NCBz
eXMgIDkwOC4wMCUgY3B1IAlpMzg2LXJhbmRjb25maWctajQtMDgyNzEwNTYKL2Jpbi9ta2Rp
cjogY2Fubm90IGNyZWF0ZSBkaXJlY3RvcnkgJy9rZXJuZWwvaTM4Ni1yYW5kY29uZmlnLWo0
LTA4MjcxMDU2L2Q5ODI1OWNiZjlmMWM4NmU5MjFjYWExMjQxYWE4ZDIyOTI0OWUwYjgnOiBO
byBzcGFjZSBsZWZ0IG9uIGRldmljZQpjcDogdGFyZ2V0ICcva2VybmVsL2kzODYtcmFuZGNv
bmZpZy1qNC0wODI3MTA1Ni9kOTgyNTljYmY5ZjFjODZlOTIxY2FhMTI0MWFhOGQyMjkyNDll
MGI4LycgaXMgbm90IGEgZGlyZWN0b3J5Ci9zYmluL2luc3RhbGxrZXJuZWw6IGxpbmUgNDI6
IC9rZXJuZWwvaTM4Ni1yYW5kY29uZmlnLWo0LTA4MjcxMDU2L2Q5ODI1OWNiZjlmMWM4NmU5
MjFjYWExMjQxYWE4ZDIyOTI0OWUwYjgvdm1saW51ei0zLjExLjAtcmMyLTAwMDIwLWdkOTgy
NTljOiBObyBzdWNoIGZpbGUgb3IgZGlyZWN0b3J5Cm1rZGlyOiBjYW5ub3QgY3JlYXRlIGRp
cmVjdG9yeSAnL2tlcm5lbC9pMzg2LXJhbmRjb25maWctajQtMDgyNzEwNTYvZDk4MjU5Y2Jm
OWYxYzg2ZTkyMWNhYTEyNDFhYThkMjI5MjQ5ZTBiOCc6IE5vIHNwYWNlIGxlZnQgb24gZGV2
aWNlCm1ha2VbMV06ICoqKiBbX21vZGluc3RfXSBFcnJvciAxCm1ha2VbMV06IFRhcmdldCBg
bW9kdWxlc19pbnN0YWxsJyBub3QgcmVtYWRlIGJlY2F1c2Ugb2YgZXJyb3JzLgptYWtlOiAq
KiogW3N1Yi1tYWtlXSBFcnJvciAyChtbMTszNW1GYWlsZWQgdG8gaW5zdGFsbCBrZXJuZWw6
IG1ha2UgbW9kdWxlc19pbnN0YWxsIGZhaWxlZCB3aXRoIGNvZGUgMRtbMG0KMjAxMy0wOC0y
Ny0yMDowMzowMiBkOTgyNTljYmY5ZjFjODZlOTIxY2FhMTI0MWFhOGQyMjkyNDllMGI4IFNL
SVAgQlJPS0VOIEJVSUxECkNoZWNrIGVycm9zIGluIC9jYy93Zmcvc291bmQtYmlzZWN0IGFu
ZCAvdG1wL2tlcm5lbC9pMzg2LXJhbmRjb25maWctajQtMDgyNzEwNTYvZDk4MjU5Y2JmOWYx
Yzg2ZTkyMWNhYTEyNDFhYThkMjI5MjQ5ZTBiOApCaXNlY3Rpbmc6IDI3NSByZXZpc2lvbnMg
bGVmdCB0byB0ZXN0IGFmdGVyIHRoaXMgKHJvdWdobHkgOCBzdGVwcykKWzg1NGU4ZmIwOGZj
Mzg3ZmM4YTBlNWE5MjQ0OTljZmRlMzM5ZDA4NzldIE1lcmdlIGJyYW5jaCAndGltZXJzL2Nv
cmUnCnJ1bm5pbmcgL2Mva2VybmVsLXRlc3RzL2Jpc2VjdC10ZXN0LWJvb3QtZmFpbHVyZS5z
aCAvaG9tZS93Zmcvc291bmQvb2JqLWJpc2VjdApscyAtYSAva2VybmVsLXRlc3RzL3J1bi1x
dWV1ZS9rdm0vaTM4Ni1yYW5kY29uZmlnLWo0LTA4MjcxMDU2L25leHQ6bWFzdGVyOjg1NGU4
ZmIwOGZjMzg3ZmM4YTBlNWE5MjQ0OTljZmRlMzM5ZDA4Nzk6YmlzZWN0LXNvdW5kCgoyMDEz
LTA4LTI3LTIwOjAzOjA0IDg1NGU4ZmIwOGZjMzg3ZmM4YTBlNWE5MjQ0OTljZmRlMzM5ZDA4
NzkgY29tcGlsaW5nCjI4NSByZWFsICAyMjI0IHVzZXIgIDI0NCBzeXMgIDg2NC44NCUgY3B1
IAlpMzg2LXJhbmRjb25maWctajQtMDgyNzEwNTYKL2Mva2VybmVsLXRlc3RzL2NvbW1vbi5z
aDogbGluZSAyNTMzOiBlY2hvOiB3cml0ZSBlcnJvcjogTm8gc3BhY2UgbGVmdCBvbiBkZXZp
Y2UKL2Jpbi9ta2RpcjogY2Fubm90IGNyZWF0ZSBkaXJlY3RvcnkgJy9rZXJuZWwvaTM4Ni1y
YW5kY29uZmlnLWo0LTA4MjcxMDU2Lzg1NGU4ZmIwOGZjMzg3ZmM4YTBlNWE5MjQ0OTljZmRl
MzM5ZDA4NzknOiBObyBzcGFjZSBsZWZ0IG9uIGRldmljZQpjcDogdGFyZ2V0ICcva2VybmVs
L2kzODYtcmFuZGNvbmZpZy1qNC0wODI3MTA1Ni84NTRlOGZiMDhmYzM4N2ZjOGEwZTVhOTI0
NDk5Y2ZkZTMzOWQwODc5LycgaXMgbm90IGEgZGlyZWN0b3J5Ci9zYmluL2luc3RhbGxrZXJu
ZWw6IGxpbmUgNDI6IC9rZXJuZWwvaTM4Ni1yYW5kY29uZmlnLWo0LTA4MjcxMDU2Lzg1NGU4
ZmIwOGZjMzg3ZmM4YTBlNWE5MjQ0OTljZmRlMzM5ZDA4Nzkvdm1saW51ei0zLjExLjAtcmM2
LTAxMDQ1LWc4NTRlOGZiOiBObyBzdWNoIGZpbGUgb3IgZGlyZWN0b3J5Cm1rZGlyOiBjYW5u
b3QgY3JlYXRlIGRpcmVjdG9yeSAnL2tlcm5lbC9pMzg2LXJhbmRjb25maWctajQtMDgyNzEw
NTYvODU0ZThmYjA4ZmMzODdmYzhhMGU1YTkyNDQ5OWNmZGUzMzlkMDg3OSc6IE5vIHNwYWNl
IGxlZnQgb24gZGV2aWNlCm1ha2VbMV06ICoqKiBbX21vZGluc3RfXSBFcnJvciAxCm1ha2Vb
MV06IFRhcmdldCBgbW9kdWxlc19pbnN0YWxsJyBub3QgcmVtYWRlIGJlY2F1c2Ugb2YgZXJy
b3JzLgptYWtlOiAqKiogW3N1Yi1tYWtlXSBFcnJvciAyChtbMTszNW1GYWlsZWQgdG8gaW5z
dGFsbCBrZXJuZWw6IG1ha2UgbW9kdWxlc19pbnN0YWxsIGZhaWxlZCB3aXRoIGNvZGUgMRtb
MG0KMjAxMy0wOC0yNy0yMDowODoyMiA4NTRlOGZiMDhmYzM4N2ZjOGEwZTVhOTI0NDk5Y2Zk
ZTMzOWQwODc5IFNLSVAgQlJPS0VOIEJVSUxECkNoZWNrIGVycm9zIGluIC9jYy93Zmcvc291
bmQtYmlzZWN0IGFuZCAvdG1wL2tlcm5lbC9pMzg2LXJhbmRjb25maWctajQtMDgyNzEwNTYv
ODU0ZThmYjA4ZmMzODdmYzhhMGU1YTkyNDQ5OWNmZGUzMzlkMDg3OQpCaXNlY3Rpbmc6IDI3
NSByZXZpc2lvbnMgbGVmdCB0byB0ZXN0IGFmdGVyIHRoaXMgKHJvdWdobHkgOCBzdGVwcykK
WzQxODNmYjk1MDNlMTE3ZWY2ZDc1NjRhNGRiZGYwNTgyYzVkNjM4YWRdIGN1c2U6IGNvbnZl
cnQgY2xhc3MgY29kZSB0byB1c2UgZGV2X2dyb3VwcwpydW5uaW5nIC9jL2tlcm5lbC10ZXN0
cy9iaXNlY3QtdGVzdC1ib290LWZhaWx1cmUuc2ggL2hvbWUvd2ZnL3NvdW5kL29iai1iaXNl
Y3QKbHMgLWEgL2tlcm5lbC10ZXN0cy9ydW4tcXVldWUva3ZtL2kzODYtcmFuZGNvbmZpZy1q
NC0wODI3MTA1Ni9uZXh0Om1hc3Rlcjo0MTgzZmI5NTAzZTExN2VmNmQ3NTY0YTRkYmRmMDU4
MmM1ZDYzOGFkOmJpc2VjdC1zb3VuZAoKMjAxMy0wOC0yNy0yMDowODoyMyA0MTgzZmI5NTAz
ZTExN2VmNmQ3NTY0YTRkYmRmMDU4MmM1ZDYzOGFkIGNvbXBpbGluZwoyOTQgcmVhbCAgMjIz
NiB1c2VyICAyNDQgc3lzICA4NDIuMTclIGNwdSAJaTM4Ni1yYW5kY29uZmlnLWo0LTA4Mjcx
MDU2Ci9jL2tlcm5lbC10ZXN0cy9jb21tb24uc2g6IGxpbmUgMjUzMzogZWNobzogd3JpdGUg
ZXJyb3I6IE5vIHNwYWNlIGxlZnQgb24gZGV2aWNlCi9iaW4vbWtkaXI6IGNhbm5vdCBjcmVh
dGUgZGlyZWN0b3J5ICcva2VybmVsL2kzODYtcmFuZGNvbmZpZy1qNC0wODI3MTA1Ni80MTgz
ZmI5NTAzZTExN2VmNmQ3NTY0YTRkYmRmMDU4MmM1ZDYzOGFkJzogTm8gc3BhY2UgbGVmdCBv
biBkZXZpY2UKY3A6IHRhcmdldCAnL2tlcm5lbC9pMzg2LXJhbmRjb25maWctajQtMDgyNzEw
NTYvNDE4M2ZiOTUwM2UxMTdlZjZkNzU2NGE0ZGJkZjA1ODJjNWQ2MzhhZC8nIGlzIG5vdCBh
IGRpcmVjdG9yeQovc2Jpbi9pbnN0YWxsa2VybmVsOiBsaW5lIDQyOiAva2VybmVsL2kzODYt
cmFuZGNvbmZpZy1qNC0wODI3MTA1Ni80MTgzZmI5NTAzZTExN2VmNmQ3NTY0YTRkYmRmMDU4
MmM1ZDYzOGFkL3ZtbGludXotMy4xMS4wLXJjMi0wMDAyMy1nNDE4M2ZiOTogTm8gc3VjaCBm
aWxlIG9yIGRpcmVjdG9yeQpta2RpcjogY2Fubm90IGNyZWF0ZSBkaXJlY3RvcnkgJy9rZXJu
ZWwvaTM4Ni1yYW5kY29uZmlnLWo0LTA4MjcxMDU2LzQxODNmYjk1MDNlMTE3ZWY2ZDc1NjRh
NGRiZGYwNTgyYzVkNjM4YWQnOiBObyBzcGFjZSBsZWZ0IG9uIGRldmljZQptYWtlWzFdOiAq
KiogW19tb2RpbnN0X10gRXJyb3IgMQptYWtlWzFdOiBUYXJnZXQgYG1vZHVsZXNfaW5zdGFs
bCcgbm90IHJlbWFkZSBiZWNhdXNlIG9mIGVycm9ycy4KbWFrZTogKioqIFtzdWItbWFrZV0g
RXJyb3IgMgobWzE7MzVtRmFpbGVkIHRvIGluc3RhbGwga2VybmVsOiBtYWtlIG1vZHVsZXNf
aW5zdGFsbCBmYWlsZWQgd2l0aCBjb2RlIDEbWzBtCjIwMTMtMDgtMjctMjA6MTM6NDkgNDE4
M2ZiOTUwM2UxMTdlZjZkNzU2NGE0ZGJkZjA1ODJjNWQ2MzhhZCBTS0lQIEJST0tFTiBCVUlM
RApDaGVjayBlcnJvcyBpbiAvY2Mvd2ZnL3NvdW5kLWJpc2VjdCBhbmQgL3RtcC9rZXJuZWwv
aTM4Ni1yYW5kY29uZmlnLWo0LTA4MjcxMDU2LzQxODNmYjk1MDNlMTE3ZWY2ZDc1NjRhNGRi
ZGYwNTgyYzVkNjM4YWQKQmlzZWN0aW5nOiAyNzUgcmV2aXNpb25zIGxlZnQgdG8gdGVzdCBh
ZnRlciB0aGlzIChyb3VnaGx5IDggc3RlcHMpCls5N2FmNGIyMDJlYTIzMjMzNmFiZWM3OTkz
NTJmMGU0NjNkZjgwYmRjXSBNZXJnZSBicmFuY2ggJ3RpbWVycy9ub2h6JwpydW5uaW5nIC9j
L2tlcm5lbC10ZXN0cy9iaXNlY3QtdGVzdC1ib290LWZhaWx1cmUuc2ggL2hvbWUvd2ZnL3Nv
dW5kL29iai1iaXNlY3QKbHMgLWEgL2tlcm5lbC10ZXN0cy9ydW4tcXVldWUva3ZtL2kzODYt
cmFuZGNvbmZpZy1qNC0wODI3MTA1Ni9uZXh0Om1hc3Rlcjo5N2FmNGIyMDJlYTIzMjMzNmFi
ZWM3OTkzNTJmMGU0NjNkZjgwYmRjOmJpc2VjdC1zb3VuZAoKMjAxMy0wOC0yNy0yMDoxMzo1
MCA5N2FmNGIyMDJlYTIzMjMzNmFiZWM3OTkzNTJmMGU0NjNkZjgwYmRjIGNvbXBpbGluZwoy
ODIgcmVhbCAgMjIxOSB1c2VyICAyNDYgc3lzICA4NzQuMTYlIGNwdSAJaTM4Ni1yYW5kY29u
ZmlnLWo0LTA4MjcxMDU2Ci9jL2tlcm5lbC10ZXN0cy9jb21tb24uc2g6IGxpbmUgMjUzMzog
ZWNobzogd3JpdGUgZXJyb3I6IE5vIHNwYWNlIGxlZnQgb24gZGV2aWNlCi9iaW4vbWtkaXI6
IGNhbm5vdCBjcmVhdGUgZGlyZWN0b3J5ICcva2VybmVsL2kzODYtcmFuZGNvbmZpZy1qNC0w
ODI3MTA1Ni85N2FmNGIyMDJlYTIzMjMzNmFiZWM3OTkzNTJmMGU0NjNkZjgwYmRjJzogTm8g
c3BhY2UgbGVmdCBvbiBkZXZpY2UKY3A6IHRhcmdldCAnL2tlcm5lbC9pMzg2LXJhbmRjb25m
aWctajQtMDgyNzEwNTYvOTdhZjRiMjAyZWEyMzIzMzZhYmVjNzk5MzUyZjBlNDYzZGY4MGJk
Yy8nIGlzIG5vdCBhIGRpcmVjdG9yeQovc2Jpbi9pbnN0YWxsa2VybmVsOiBsaW5lIDQyOiAv
a2VybmVsL2kzODYtcmFuZGNvbmZpZy1qNC0wODI3MTA1Ni85N2FmNGIyMDJlYTIzMjMzNmFi
ZWM3OTkzNTJmMGU0NjNkZjgwYmRjL3ZtbGludXotMy4xMS4wLXJjNi0wMTA3MS1nOTdhZjRi
MjogTm8gc3VjaCBmaWxlIG9yIGRpcmVjdG9yeQpta2RpcjogY2Fubm90IGNyZWF0ZSBkaXJl
Y3RvcnkgJy9rZXJuZWwvaTM4Ni1yYW5kY29uZmlnLWo0LTA4MjcxMDU2Lzk3YWY0YjIwMmVh
MjMyMzM2YWJlYzc5OTM1MmYwZTQ2M2RmODBiZGMnOiBObyBzcGFjZSBsZWZ0IG9uIGRldmlj
ZQptYWtlWzFdOiAqKiogW19tb2RpbnN0X10gRXJyb3IgMQptYWtlWzFdOiBUYXJnZXQgYG1v
ZHVsZXNfaW5zdGFsbCcgbm90IHJlbWFkZSBiZWNhdXNlIG9mIGVycm9ycy4KbWFrZTogKioq
IFtzdWItbWFrZV0gRXJyb3IgMgobWzE7MzVtRmFpbGVkIHRvIGluc3RhbGwga2VybmVsOiBt
YWtlIG1vZHVsZXNfaW5zdGFsbCBmYWlsZWQgd2l0aCBjb2RlIDEbWzBtCjIwMTMtMDgtMjct
MjA6MTg6NTggOTdhZjRiMjAyZWEyMzIzMzZhYmVjNzk5MzUyZjBlNDYzZGY4MGJkYyBTS0lQ
IEJST0tFTiBCVUlMRApDaGVjayBlcnJvcyBpbiAvY2Mvd2ZnL3NvdW5kLWJpc2VjdCBhbmQg
L3RtcC9rZXJuZWwvaTM4Ni1yYW5kY29uZmlnLWo0LTA4MjcxMDU2Lzk3YWY0YjIwMmVhMjMy
MzM2YWJlYzc5OTM1MmYwZTQ2M2RmODBiZGMKQmlzZWN0aW5nOiAyNzUgcmV2aXNpb25zIGxl
ZnQgdG8gdGVzdCBhZnRlciB0aGlzIChyb3VnaGx5IDggc3RlcHMpClszODA3NTI3MWZhMmZj
ZjZhMzRkYTc1YjczZDQyNGM4NjAwZmJhN2M4XSBNZXJnZSBicmFuY2ggJ3N0YWJsZS9mb3It
bGludXMtMy4xMicgaW50byBsaW51eC1uZXh0CnJ1bm5pbmcgL2Mva2VybmVsLXRlc3RzL2Jp
c2VjdC10ZXN0LWJvb3QtZmFpbHVyZS5zaCAvaG9tZS93Zmcvc291bmQvb2JqLWJpc2VjdAps
cyAtYSAva2VybmVsLXRlc3RzL3J1bi1xdWV1ZS9rdm0vaTM4Ni1yYW5kY29uZmlnLWo0LTA4
MjcxMDU2L25leHQ6bWFzdGVyOjM4MDc1MjcxZmEyZmNmNmEzNGRhNzViNzNkNDI0Yzg2MDBm
YmE3Yzg6YmlzZWN0LXNvdW5kCgoyMDEzLTA4LTI3LTIwOjE4OjU5IDM4MDc1MjcxZmEyZmNm
NmEzNGRhNzViNzNkNDI0Yzg2MDBmYmE3YzggY29tcGlsaW5nCjM0MiByZWFsICAyMTk3IHVz
ZXIgIDI0MiBzeXMgIDcxMS40NCUgY3B1IAlpMzg2LXJhbmRjb25maWctajQtMDgyNzEwNTYK
L2Mva2VybmVsLXRlc3RzL2NvbW1vbi5zaDogbGluZSAyNTMzOiBlY2hvOiB3cml0ZSBlcnJv
cjogTm8gc3BhY2UgbGVmdCBvbiBkZXZpY2UKL2Jpbi9ta2RpcjogY2Fubm90IGNyZWF0ZSBk
aXJlY3RvcnkgJy9rZXJuZWwvaTM4Ni1yYW5kY29uZmlnLWo0LTA4MjcxMDU2LzM4MDc1Mjcx
ZmEyZmNmNmEzNGRhNzViNzNkNDI0Yzg2MDBmYmE3YzgnOiBObyBzcGFjZSBsZWZ0IG9uIGRl
dmljZQpjcDogdGFyZ2V0ICcva2VybmVsL2kzODYtcmFuZGNvbmZpZy1qNC0wODI3MTA1Ni8z
ODA3NTI3MWZhMmZjZjZhMzRkYTc1YjczZDQyNGM4NjAwZmJhN2M4LycgaXMgbm90IGEgZGly
ZWN0b3J5Ci9zYmluL2luc3RhbGxrZXJuZWw6IGxpbmUgNDI6IC9rZXJuZWwvaTM4Ni1yYW5k
Y29uZmlnLWo0LTA4MjcxMDU2LzM4MDc1MjcxZmEyZmNmNmEzNGRhNzViNzNkNDI0Yzg2MDBm
YmE3Yzgvdm1saW51ei0zLjExLjAtcmM2LTAwODQxLWczODA3NTI3OiBObyBzdWNoIGZpbGUg
b3IgZGlyZWN0b3J5Cm1rZGlyOiBjYW5ub3QgY3JlYXRlIGRpcmVjdG9yeSAnL2tlcm5lbC9p
Mzg2LXJhbmRjb25maWctajQtMDgyNzEwNTYvMzgwNzUyNzFmYTJmY2Y2YTM0ZGE3NWI3M2Q0
MjRjODYwMGZiYTdjOCc6IE5vIHNwYWNlIGxlZnQgb24gZGV2aWNlCm1ha2VbMV06ICoqKiBb
X21vZGluc3RfXSBFcnJvciAxCm1ha2VbMV06IFRhcmdldCBgbW9kdWxlc19pbnN0YWxsJyBu
b3QgcmVtYWRlIGJlY2F1c2Ugb2YgZXJyb3JzLgptYWtlOiAqKiogW3N1Yi1tYWtlXSBFcnJv
ciAyChtbMTszNW1GYWlsZWQgdG8gaW5zdGFsbCBrZXJuZWw6IG1ha2UgbW9kdWxlc19pbnN0
YWxsIGZhaWxlZCB3aXRoIGNvZGUgMRtbMG0KMjAxMy0wOC0yNy0yMDoyNTozMCAzODA3NTI3
MWZhMmZjZjZhMzRkYTc1YjczZDQyNGM4NjAwZmJhN2M4IFNLSVAgQlJPS0VOIEJVSUxECkNo
ZWNrIGVycm9zIGluIC9jYy93Zmcvc291bmQtYmlzZWN0IGFuZCAvdG1wL2tlcm5lbC9pMzg2
LXJhbmRjb25maWctajQtMDgyNzEwNTYvMzgwNzUyNzFmYTJmY2Y2YTM0ZGE3NWI3M2Q0MjRj
ODYwMGZiYTdjOApCaXNlY3Rpbmc6IDI3NSByZXZpc2lvbnMgbGVmdCB0byB0ZXN0IGFmdGVy
IHRoaXMgKHJvdWdobHkgOCBzdGVwcykKWzBmNTYwYWFjZDhkMjZhODcyNjk3YmMwZWRiYWE1
ODY4OGY4YmE0NWNdIE1lcmdlIGJyYW5jaCAneDg2L2NwdScKcnVubmluZyAvYy9rZXJuZWwt
dGVzdHMvYmlzZWN0LXRlc3QtYm9vdC1mYWlsdXJlLnNoIC9ob21lL3dmZy9zb3VuZC9vYmot
YmlzZWN0CmxzIC1hIC9rZXJuZWwtdGVzdHMvcnVuLXF1ZXVlL2t2bS9pMzg2LXJhbmRjb25m
aWctajQtMDgyNzEwNTYvbmV4dDptYXN0ZXI6MGY1NjBhYWNkOGQyNmE4NzI2OTdiYzBlZGJh
YTU4Njg4ZjhiYTQ1YzpiaXNlY3Qtc291bmQKCjIwMTMtMDgtMjctMjA6MjU6MzEgMGY1NjBh
YWNkOGQyNmE4NzI2OTdiYzBlZGJhYTU4Njg4ZjhiYTQ1YyBjb21waWxpbmcKMzg0IHJlYWwg
IDIyNDMgdXNlciAgMjQ2IHN5cyAgNjQ3LjI1JSBjcHUgCWkzODYtcmFuZGNvbmZpZy1qNC0w
ODI3MTA1NgovYy9rZXJuZWwtdGVzdHMvY29tbW9uLnNoOiBsaW5lIDI1MzM6IGVjaG86IHdy
aXRlIGVycm9yOiBObyBzcGFjZSBsZWZ0IG9uIGRldmljZQovYmluL21rZGlyOiBjYW5ub3Qg
Y3JlYXRlIGRpcmVjdG9yeSAnL2tlcm5lbC9pMzg2LXJhbmRjb25maWctajQtMDgyNzEwNTYv
MGY1NjBhYWNkOGQyNmE4NzI2OTdiYzBlZGJhYTU4Njg4ZjhiYTQ1Yyc6IE5vIHNwYWNlIGxl
ZnQgb24gZGV2aWNlCmNwOiB0YXJnZXQgJy9rZXJuZWwvaTM4Ni1yYW5kY29uZmlnLWo0LTA4
MjcxMDU2LzBmNTYwYWFjZDhkMjZhODcyNjk3YmMwZWRiYWE1ODY4OGY4YmE0NWMvJyBpcyBu
b3QgYSBkaXJlY3RvcnkKL3NiaW4vaW5zdGFsbGtlcm5lbDogbGluZSA0MjogL2tlcm5lbC9p
Mzg2LXJhbmRjb25maWctajQtMDgyNzEwNTYvMGY1NjBhYWNkOGQyNmE4NzI2OTdiYzBlZGJh
YTU4Njg4ZjhiYTQ1Yy92bWxpbnV6LTMuMTEuMC1yYzYtMDExMDMtZzBmNTYwYWE6IE5vIHN1
Y2ggZmlsZSBvciBkaXJlY3RvcnkKbWtkaXI6IGNhbm5vdCBjcmVhdGUgZGlyZWN0b3J5ICcv
a2VybmVsL2kzODYtcmFuZGNvbmZpZy1qNC0wODI3MTA1Ni8wZjU2MGFhY2Q4ZDI2YTg3MjY5
N2JjMGVkYmFhNTg2ODhmOGJhNDVjJzogTm8gc3BhY2UgbGVmdCBvbiBkZXZpY2UKbWFrZVsx
XTogKioqIFtfbW9kaW5zdF9dIEVycm9yIDEKbWFrZVsxXTogVGFyZ2V0IGBtb2R1bGVzX2lu
c3RhbGwnIG5vdCByZW1hZGUgYmVjYXVzZSBvZiBlcnJvcnMuCm1ha2U6ICoqKiBbc3ViLW1h
a2VdIEVycm9yIDIKG1sxOzM1bUZhaWxlZCB0byBpbnN0YWxsIGtlcm5lbDogbWFrZSBtb2R1
bGVzX2luc3RhbGwgZmFpbGVkIHdpdGggY29kZSAxG1swbQoyMDEzLTA4LTI3LTIwOjMzOjE2
IDBmNTYwYWFjZDhkMjZhODcyNjk3YmMwZWRiYWE1ODY4OGY4YmE0NWMgU0tJUCBCUk9LRU4g
QlVJTEQKQ2hlY2sgZXJyb3MgaW4gL2NjL3dmZy9zb3VuZC1iaXNlY3QgYW5kIC90bXAva2Vy
bmVsL2kzODYtcmFuZGNvbmZpZy1qNC0wODI3MTA1Ni8wZjU2MGFhY2Q4ZDI2YTg3MjY5N2Jj
MGVkYmFhNTg2ODhmOGJhNDVjCkJpc2VjdGluZzogMjc1IHJldmlzaW9ucyBsZWZ0IHRvIHRl
c3QgYWZ0ZXIgdGhpcyAocm91Z2hseSA4IHN0ZXBzKQpbZGQ5NDEzZjQzYjY5NzA2NzcyODJk
MzIyNDQxZjI3YzA4YjcxM2FkYl0gVHlwZSBmaXggb24gSE9XVE8gaW4ga29fS1IKcnVubmlu
ZyAvYy9rZXJuZWwtdGVzdHMvYmlzZWN0LXRlc3QtYm9vdC1mYWlsdXJlLnNoIC9ob21lL3dm
Zy9zb3VuZC9vYmotYmlzZWN0CmxzIC1hIC9rZXJuZWwtdGVzdHMvcnVuLXF1ZXVlL2t2bS9p
Mzg2LXJhbmRjb25maWctajQtMDgyNzEwNTYvbmV4dDptYXN0ZXI6ZGQ5NDEzZjQzYjY5NzA2
NzcyODJkMzIyNDQxZjI3YzA4YjcxM2FkYjpiaXNlY3Qtc291bmQKCjIwMTMtMDgtMjctMjA6
MzM6MTggZGQ5NDEzZjQzYjY5NzA2NzcyODJkMzIyNDQxZjI3YzA4YjcxM2FkYiBjb21waWxp
bmcKMjg5IHJlYWwgIDIyMjIgdXNlciAgMjQxIHN5cyAgODUwLjM2JSBjcHUgCWkzODYtcmFu
ZGNvbmZpZy1qNC0wODI3MTA1NgovYy9rZXJuZWwtdGVzdHMvY29tbW9uLnNoOiBsaW5lIDI1
MzM6IGVjaG86IHdyaXRlIGVycm9yOiBObyBzcGFjZSBsZWZ0IG9uIGRldmljZQovYmluL21r
ZGlyOiBjYW5ub3QgY3JlYXRlIGRpcmVjdG9yeSAnL2tlcm5lbC9pMzg2LXJhbmRjb25maWct
ajQtMDgyNzEwNTYvZGQ5NDEzZjQzYjY5NzA2NzcyODJkMzIyNDQxZjI3YzA4YjcxM2FkYic6
IE5vIHNwYWNlIGxlZnQgb24gZGV2aWNlCmNwOiB0YXJnZXQgJy9rZXJuZWwvaTM4Ni1yYW5k
Y29uZmlnLWo0LTA4MjcxMDU2L2RkOTQxM2Y0M2I2OTcwNjc3MjgyZDMyMjQ0MWYyN2MwOGI3
MTNhZGIvJyBpcyBub3QgYSBkaXJlY3RvcnkKL3NiaW4vaW5zdGFsbGtlcm5lbDogbGluZSA0
MjogL2tlcm5lbC9pMzg2LXJhbmRjb25maWctajQtMDgyNzEwNTYvZGQ5NDEzZjQzYjY5NzA2
NzcyODJkMzIyNDQxZjI3YzA4YjcxM2FkYi92bWxpbnV6LTMuMTEuMC1yYzMtMDAwMzQtZ2Rk
OTQxM2Y6IE5vIHN1Y2ggZmlsZSBvciBkaXJlY3RvcnkKbWtkaXI6IGNhbm5vdCBjcmVhdGUg
ZGlyZWN0b3J5ICcva2VybmVsL2kzODYtcmFuZGNvbmZpZy1qNC0wODI3MTA1Ni9kZDk0MTNm
NDNiNjk3MDY3NzI4MmQzMjI0NDFmMjdjMDhiNzEzYWRiJzogTm8gc3BhY2UgbGVmdCBvbiBk
ZXZpY2UKbWFrZVsxXTogKioqIFtfbW9kaW5zdF9dIEVycm9yIDEKbWFrZVsxXTogVGFyZ2V0
IGBtb2R1bGVzX2luc3RhbGwnIG5vdCByZW1hZGUgYmVjYXVzZSBvZiBlcnJvcnMuCm1ha2U6
ICoqKiBbc3ViLW1ha2VdIEVycm9yIDIKG1sxOzM1bUZhaWxlZCB0byBpbnN0YWxsIGtlcm5l
bDogbWFrZSBtb2R1bGVzX2luc3RhbGwgZmFpbGVkIHdpdGggY29kZSAxG1swbQoyMDEzLTA4
LTI3LTIwOjM4OjI3IGRkOTQxM2Y0M2I2OTcwNjc3MjgyZDMyMjQ0MWYyN2MwOGI3MTNhZGIg
U0tJUCBCUk9LRU4gQlVJTEQKQ2hlY2sgZXJyb3MgaW4gL2NjL3dmZy9zb3VuZC1iaXNlY3Qg
YW5kIC90bXAva2VybmVsL2kzODYtcmFuZGNvbmZpZy1qNC0wODI3MTA1Ni9kZDk0MTNmNDNi
Njk3MDY3NzI4MmQzMjI0NDFmMjdjMDhiNzEzYWRiCkJpc2VjdGluZzogMjc1IHJldmlzaW9u
cyBsZWZ0IHRvIHRlc3QgYWZ0ZXIgdGhpcyAocm91Z2hseSA4IHN0ZXBzKQpbZmRkNWZiMTc3
YzZhOGIxMWIzMGU1ODkyMDBhOTBlYjBmYWM4YjA3MF0gTWVyZ2UgYnJhbmNoICd4ODYvYm9v
dCcKcnVubmluZyAvYy9rZXJuZWwtdGVzdHMvYmlzZWN0LXRlc3QtYm9vdC1mYWlsdXJlLnNo
IC9ob21lL3dmZy9zb3VuZC9vYmotYmlzZWN0CmxzIC1hIC9rZXJuZWwtdGVzdHMvcnVuLXF1
ZXVlL2t2bS9pMzg2LXJhbmRjb25maWctajQtMDgyNzEwNTYvbmV4dDptYXN0ZXI6ZmRkNWZi
MTc3YzZhOGIxMWIzMGU1ODkyMDBhOTBlYjBmYWM4YjA3MDpiaXNlY3Qtc291bmQKCjIwMTMt
MDgtMjctMjA6Mzg6MjggZmRkNWZiMTc3YzZhOGIxMWIzMGU1ODkyMDBhOTBlYjBmYWM4YjA3
MCBjb21waWxpbmcKMjgxIHJlYWwgIDIyMzIgdXNlciAgMjQ0IHN5cyAgODc4LjgzJSBjcHUg
CWkzODYtcmFuZGNvbmZpZy1qNC0wODI3MTA1NgovYy9rZXJuZWwtdGVzdHMvY29tbW9uLnNo
OiBsaW5lIDI1MzM6IGVjaG86IHdyaXRlIGVycm9yOiBObyBzcGFjZSBsZWZ0IG9uIGRldmlj
ZQovYmluL21rZGlyOiBjYW5ub3QgY3JlYXRlIGRpcmVjdG9yeSAnL2tlcm5lbC9pMzg2LXJh
bmRjb25maWctajQtMDgyNzEwNTYvZmRkNWZiMTc3YzZhOGIxMWIzMGU1ODkyMDBhOTBlYjBm
YWM4YjA3MCc6IE5vIHNwYWNlIGxlZnQgb24gZGV2aWNlCmNwOiB0YXJnZXQgJy9rZXJuZWwv
aTM4Ni1yYW5kY29uZmlnLWo0LTA4MjcxMDU2L2ZkZDVmYjE3N2M2YThiMTFiMzBlNTg5MjAw
YTkwZWIwZmFjOGIwNzAvJyBpcyBub3QgYSBkaXJlY3RvcnkKL3NiaW4vaW5zdGFsbGtlcm5l
bDogbGluZSA0MjogL2tlcm5lbC9pMzg2LXJhbmRjb25maWctajQtMDgyNzEwNTYvZmRkNWZi
MTc3YzZhOGIxMWIzMGU1ODkyMDBhOTBlYjBmYWM4YjA3MC92bWxpbnV6LTMuMTEuMC1yYzYt
MDEwOTctZ2ZkZDVmYjE6IE5vIHN1Y2ggZmlsZSBvciBkaXJlY3RvcnkKbWtkaXI6IGNhbm5v
dCBjcmVhdGUgZGlyZWN0b3J5ICcva2VybmVsL2kzODYtcmFuZGNvbmZpZy1qNC0wODI3MTA1
Ni9mZGQ1ZmIxNzdjNmE4YjExYjMwZTU4OTIwMGE5MGViMGZhYzhiMDcwJzogTm8gc3BhY2Ug
bGVmdCBvbiBkZXZpY2UKbWFrZVsxXTogKioqIFtfbW9kaW5zdF9dIEVycm9yIDEKbWFrZVsx
XTogVGFyZ2V0IGBtb2R1bGVzX2luc3RhbGwnIG5vdCByZW1hZGUgYmVjYXVzZSBvZiBlcnJv
cnMuCm1ha2U6ICoqKiBbc3ViLW1ha2VdIEVycm9yIDIKG1sxOzM1bUZhaWxlZCB0byBpbnN0
YWxsIGtlcm5lbDogbWFrZSBtb2R1bGVzX2luc3RhbGwgZmFpbGVkIHdpdGggY29kZSAxG1sw
bQoyMDEzLTA4LTI3LTIwOjQzOjQ1IGZkZDVmYjE3N2M2YThiMTFiMzBlNTg5MjAwYTkwZWIw
ZmFjOGIwNzAgU0tJUCBCUk9LRU4gQlVJTEQKQ2hlY2sgZXJyb3MgaW4gL2NjL3dmZy9zb3Vu
ZC1iaXNlY3QgYW5kIC90bXAva2VybmVsL2kzODYtcmFuZGNvbmZpZy1qNC0wODI3MTA1Ni9m
ZGQ1ZmIxNzdjNmE4YjExYjMwZTU4OTIwMGE5MGViMGZhYzhiMDcwCkJpc2VjdGluZzogMjc1
IHJldmlzaW9ucyBsZWZ0IHRvIHRlc3QgYWZ0ZXIgdGhpcyAocm91Z2hseSA4IHN0ZXBzKQpb
NTY3YjIxZTk3M2NjZjViMGQxMzc3NmU0MDhkN2M2NzA5OTc0OWViOF0gbWlwczogY29udmVy
dCB2cGVfY2xhc3MgdG8gdXNlIGRldl9ncm91cHMKcnVubmluZyAvYy9rZXJuZWwtdGVzdHMv
YmlzZWN0LXRlc3QtYm9vdC1mYWlsdXJlLnNoIC9ob21lL3dmZy9zb3VuZC9vYmotYmlzZWN0
CmxzIC1hIC9rZXJuZWwtdGVzdHMvcnVuLXF1ZXVlL2t2bS9pMzg2LXJhbmRjb25maWctajQt
MDgyNzEwNTYvbmV4dDptYXN0ZXI6NTY3YjIxZTk3M2NjZjViMGQxMzc3NmU0MDhkN2M2NzA5
OTc0OWViODpiaXNlY3Qtc291bmQKCjIwMTMtMDgtMjctMjA6NDM6NDYgNTY3YjIxZTk3M2Nj
ZjViMGQxMzc3NmU0MDhkN2M2NzA5OTc0OWViOCBjb21waWxpbmcKNjEzIHJlYWwgIDIyNDYg
dXNlciAgMjQyIHN5cyAgNDA1LjY4JSBjcHUgCWkzODYtcmFuZGNvbmZpZy1qNC0wODI3MTA1
NgovYy9rZXJuZWwtdGVzdHMvY29tbW9uLnNoOiBsaW5lIDI1MzM6IGVjaG86IHdyaXRlIGVy
cm9yOiBObyBzcGFjZSBsZWZ0IG9uIGRldmljZQovYmluL21rZGlyOiBjYW5ub3QgY3JlYXRl
IGRpcmVjdG9yeSAnL2tlcm5lbC9pMzg2LXJhbmRjb25maWctajQtMDgyNzEwNTYvNTY3YjIx
ZTk3M2NjZjViMGQxMzc3NmU0MDhkN2M2NzA5OTc0OWViOCc6IE5vIHNwYWNlIGxlZnQgb24g
ZGV2aWNlCmNwOiB0YXJnZXQgJy9rZXJuZWwvaTM4Ni1yYW5kY29uZmlnLWo0LTA4MjcxMDU2
LzU2N2IyMWU5NzNjY2Y1YjBkMTM3NzZlNDA4ZDdjNjcwOTk3NDllYjgvJyBpcyBub3QgYSBk
aXJlY3RvcnkKL3NiaW4vaW5zdGFsbGtlcm5lbDogbGluZSA0MjogL2tlcm5lbC9pMzg2LXJh
bmRjb25maWctajQtMDgyNzEwNTYvNTY3YjIxZTk3M2NjZjViMGQxMzc3NmU0MDhkN2M2NzA5
OTc0OWViOC92bWxpbnV6LTMuMTEuMC1yYzMtMDAwNDEtZzU2N2IyMWU6IE5vIHN1Y2ggZmls
ZSBvciBkaXJlY3RvcnkKbWtkaXI6IGNhbm5vdCBjcmVhdGUgZGlyZWN0b3J5ICcva2VybmVs
L2kzODYtcmFuZGNvbmZpZy1qNC0wODI3MTA1Ni81NjdiMjFlOTczY2NmNWIwZDEzNzc2ZTQw
OGQ3YzY3MDk5NzQ5ZWI4JzogTm8gc3BhY2UgbGVmdCBvbiBkZXZpY2UKbWFrZVsxXTogKioq
IFtfbW9kaW5zdF9dIEVycm9yIDEKbWFrZVsxXTogVGFyZ2V0IGBtb2R1bGVzX2luc3RhbGwn
IG5vdCByZW1hZGUgYmVjYXVzZSBvZiBlcnJvcnMuCm1ha2U6ICoqKiBbc3ViLW1ha2VdIEVy
cm9yIDIKG1sxOzM1bUZhaWxlZCB0byBpbnN0YWxsIGtlcm5lbDogbWFrZSBtb2R1bGVzX2lu
c3RhbGwgZmFpbGVkIHdpdGggY29kZSAxG1swbQoyMDEzLTA4LTI3LTIwOjU1OjMxIDU2N2Iy
MWU5NzNjY2Y1YjBkMTM3NzZlNDA4ZDdjNjcwOTk3NDllYjggU0tJUCBCUk9LRU4gQlVJTEQK
Q2hlY2sgZXJyb3MgaW4gL2NjL3dmZy9zb3VuZC1iaXNlY3QgYW5kIC90bXAva2VybmVsL2kz
ODYtcmFuZGNvbmZpZy1qNC0wODI3MTA1Ni81NjdiMjFlOTczY2NmNWIwZDEzNzc2ZTQwOGQ3
YzY3MDk5NzQ5ZWI4CkJpc2VjdGluZzogMjc1IHJldmlzaW9ucyBsZWZ0IHRvIHRlc3QgYWZ0
ZXIgdGhpcyAocm91Z2hseSA4IHN0ZXBzKQpbNWI4ZmFmY2FjNjI0MmJmOTE0MzM0ZDNhZTlk
YmU5MjFhZDhkNDYzNF0geDg2L2Jvb3Q6IEZpeCBhIHNhbml0eSBjaGVjayBpbiBwcmludGYu
YwpydW5uaW5nIC9jL2tlcm5lbC10ZXN0cy9iaXNlY3QtdGVzdC1ib290LWZhaWx1cmUuc2gg
L2hvbWUvd2ZnL3NvdW5kL29iai1iaXNlY3QKbHMgLWEgL2tlcm5lbC10ZXN0cy9ydW4tcXVl
dWUva3ZtL2kzODYtcmFuZGNvbmZpZy1qNC0wODI3MTA1Ni9uZXh0Om1hc3Rlcjo1YjhmYWZj
YWM2MjQyYmY5MTQzMzRkM2FlOWRiZTkyMWFkOGQ0NjM0OmJpc2VjdC1zb3VuZAoKMjAxMy0w
OC0yNy0yMDo1NTozNSA1YjhmYWZjYWM2MjQyYmY5MTQzMzRkM2FlOWRiZTkyMWFkOGQ0NjM0
IGNvbXBpbGluZwoxNjcyIHJlYWwgIDIyODAgdXNlciAgMjMxIHN5cyAgMTUwLjE0JSBjcHUg
CWkzODYtcmFuZGNvbmZpZy1qNC0wODI3MTA1NgovYy9rZXJuZWwtdGVzdHMvY29tbW9uLnNo
OiBsaW5lIDI1MzM6IGVjaG86IHdyaXRlIGVycm9yOiBObyBzcGFjZSBsZWZ0IG9uIGRldmlj
ZQovYmluL21rZGlyOiBjYW5ub3QgY3JlYXRlIGRpcmVjdG9yeSAnL2tlcm5lbC9pMzg2LXJh
bmRjb25maWctajQtMDgyNzEwNTYvNWI4ZmFmY2FjNjI0MmJmOTE0MzM0ZDNhZTlkYmU5MjFh
ZDhkNDYzNCc6IE5vIHNwYWNlIGxlZnQgb24gZGV2aWNlCmNwOiB0YXJnZXQgJy9rZXJuZWwv
aTM4Ni1yYW5kY29uZmlnLWo0LTA4MjcxMDU2LzViOGZhZmNhYzYyNDJiZjkxNDMzNGQzYWU5
ZGJlOTIxYWQ4ZDQ2MzQvJyBpcyBub3QgYSBkaXJlY3RvcnkKL3NiaW4vaW5zdGFsbGtlcm5l
bDogbGluZSA0MjogL2tlcm5lbC9pMzg2LXJhbmRjb25maWctajQtMDgyNzEwNTYvNWI4ZmFm
Y2FjNjI0MmJmOTE0MzM0ZDNhZTlkYmU5MjFhZDhkNDYzNC92bWxpbnV6LTMuMTEuMC1yYzUt
MDA2MzgtZzViOGZhZmM6IE5vIHN1Y2ggZmlsZSBvciBkaXJlY3RvcnkKbWtkaXI6IGNhbm5v
dCBjcmVhdGUgZGlyZWN0b3J5ICcva2VybmVsL2kzODYtcmFuZGNvbmZpZy1qNC0wODI3MTA1
Ni81YjhmYWZjYWM2MjQyYmY5MTQzMzRkM2FlOWRiZTkyMWFkOGQ0NjM0JzogTm8gc3BhY2Ug
bGVmdCBvbiBkZXZpY2UKbWFrZVsxXTogKioqIFtfbW9kaW5zdF9dIEVycm9yIDEKbWFrZVsx
XTogVGFyZ2V0IGBtb2R1bGVzX2luc3RhbGwnIG5vdCByZW1hZGUgYmVjYXVzZSBvZiBlcnJv
cnMuCm1ha2U6ICoqKiBbc3ViLW1ha2VdIEVycm9yIDIKG1sxOzM1bUZhaWxlZCB0byBpbnN0
YWxsIGtlcm5lbDogbWFrZSBtb2R1bGVzX2luc3RhbGwgZmFpbGVkIHdpdGggY29kZSAxG1sw
bQoyMDEzLTA4LTI3LTIxOjI2OjAyIDViOGZhZmNhYzYyNDJiZjkxNDMzNGQzYWU5ZGJlOTIx
YWQ4ZDQ2MzQgU0tJUCBCUk9LRU4gQlVJTEQKQ2hlY2sgZXJyb3MgaW4gL2NjL3dmZy9zb3Vu
ZC1iaXNlY3QgYW5kIC90bXAva2VybmVsL2kzODYtcmFuZGNvbmZpZy1qNC0wODI3MTA1Ni81
YjhmYWZjYWM2MjQyYmY5MTQzMzRkM2FlOWRiZTkyMWFkOGQ0NjM0CkJpc2VjdGluZzogMjc1
IHJldmlzaW9ucyBsZWZ0IHRvIHRlc3QgYWZ0ZXIgdGhpcyAocm91Z2hseSA4IHN0ZXBzKQpb
ZGMwOThiMzViNTZmODNhZTA4OGU0MjkxYTRlMzg5YTZmZjEyNjk2NV0gcGVyZiBsaXN0OiBM
aXN0IGtlcm5lbCBzdXBwbGllZCBldmVudCBhbGlhc2VzCnJ1bm5pbmcgL2Mva2VybmVsLXRl
c3RzL2Jpc2VjdC10ZXN0LWJvb3QtZmFpbHVyZS5zaCAvaG9tZS93Zmcvc291bmQvb2JqLWJp
c2VjdApscyAtYSAva2VybmVsLXRlc3RzL3J1bi1xdWV1ZS9rdm0vaTM4Ni1yYW5kY29uZmln
LWo0LTA4MjcxMDU2L25leHQ6bWFzdGVyOmRjMDk4YjM1YjU2ZjgzYWUwODhlNDI5MWE0ZTM4
OWE2ZmYxMjY5NjU6YmlzZWN0LXNvdW5kCgoyMDEzLTA4LTI3LTIxOjI2OjE0IGRjMDk4YjM1
YjU2ZjgzYWUwODhlNDI5MWE0ZTM4OWE2ZmYxMjY5NjUgY29tcGlsaW5nCjQyNiByZWFsICAy
MTY2IHVzZXIgIDIzMCBzeXMgIDU2MS45OCUgY3B1IAlpMzg2LXJhbmRjb25maWctajQtMDgy
NzEwNTYKCjIwMTMtMDgtMjctMjE6MzU6MTcgZGV0ZWN0aW5nIGJvb3Qgc3RhdGUgMy4xMC4w
LTAzMjk1LWdkYzA5OGIzCTIJNwk5Li4uLi4uLi4JMTAJMTEJMTIJMTQJMTUuCTE5CTIyCTIz
CTI1LgkzOQk0MAk0NAk1MS4JNTIuLi4uCTUzCTU0Li4uLi4JNTUgU1VDQ0VTUwoKQmlzZWN0
aW5nOiAyNTMgcmV2aXNpb25zIGxlZnQgdG8gdGVzdCBhZnRlciB0aGlzIChyb3VnaGx5IDgg
c3RlcHMpClsxMWQzMDdjMzZhYmY0NGRmMTJjMzE3MTY5MmJkMTJlMmVkNDdkMjkxXSBtYW51
YWwgbWVyZ2Ugb2YgeDg2L2p1bXBsYWJlbApydW5uaW5nIC9jL2tlcm5lbC10ZXN0cy9iaXNl
Y3QtdGVzdC1ib290LWZhaWx1cmUuc2ggL2hvbWUvd2ZnL3NvdW5kL29iai1iaXNlY3QKbHMg
LWEgL2tlcm5lbC10ZXN0cy9ydW4tcXVldWUva3ZtL2kzODYtcmFuZGNvbmZpZy1qNC0wODI3
MTA1Ni9uZXh0Om1hc3RlcjoxMWQzMDdjMzZhYmY0NGRmMTJjMzE3MTY5MmJkMTJlMmVkNDdk
MjkxOmJpc2VjdC1zb3VuZAoKMjAxMy0wOC0yNy0yMTo1NToyNSAxMWQzMDdjMzZhYmY0NGRm
MTJjMzE3MTY5MmJkMTJlMmVkNDdkMjkxIGNvbXBpbGluZwozMDAgcmVhbCAgMjIyNyB1c2Vy
ICAyMzQgc3lzICA4MjAuMTclIGNwdSAJaTM4Ni1yYW5kY29uZmlnLWo0LTA4MjcxMDU2Cgoy
MDEzLTA4LTI3LTIyOjAxOjA3IGRldGVjdGluZyBib290IHN0YXRlIDMuMTEuMC1yYzYtMDEx
MTctZzExZDMwN2MJMQkyLi4uCTMJNC4JNwkxNQkyMC4JMjEJMjQJMjUJMjYJMjcJMjgJMzAJ
MzEJMzcJNDIJNDMuLi4JNDUJNDkuCTUzLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4u
Li4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4u
Li4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4u
Li4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4u
Li4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4u
Li4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4u
LhtbMTszNW1hZGRfdG9fcnVuX3F1ZXVlIDIbWzBtCi4uLi4uLi4JNTQuLi4uLi4uLi4JNTUg
U1VDQ0VTUwoKQmlzZWN0aW5nOiAxMzggcmV2aXNpb25zIGxlZnQgdG8gdGVzdCBhZnRlciB0
aGlzIChyb3VnaGx5IDcgc3RlcHMpCls5M2Q2Mjk0ZGZjZGZmODExOTQwODZlZDliZDZjZWNh
M2JjNWU1ODYzXSBNZXJnZSByZW1vdGUtdHJhY2tpbmcgYnJhbmNoICdrdm0tcHBjL2t2bS1w
cGMtbmV4dCcKcnVubmluZyAvYy9rZXJuZWwtdGVzdHMvYmlzZWN0LXRlc3QtYm9vdC1mYWls
dXJlLnNoIC9ob21lL3dmZy9zb3VuZC9vYmotYmlzZWN0CmxzIC1hIC9rZXJuZWwtdGVzdHMv
cnVuLXF1ZXVlL2t2bS9pMzg2LXJhbmRjb25maWctajQtMDgyNzEwNTYvbmV4dDptYXN0ZXI6
OTNkNjI5NGRmY2RmZjgxMTk0MDg2ZWQ5YmQ2Y2VjYTNiYzVlNTg2MzpiaXNlY3Qtc291bmQK
CjIwMTMtMDgtMjgtMDA6NTY6MTEgOTNkNjI5NGRmY2RmZjgxMTk0MDg2ZWQ5YmQ2Y2VjYTNi
YzVlNTg2MyBjb21waWxpbmcKMzUyIHJlYWwgIDIyNDUgdXNlciAgMjQwIHN5cyAgNzA2LjMx
JSBjcHUgCWkzODYtcmFuZGNvbmZpZy1qNC0wODI3MTA1NgoKMjAxMy0wOC0yOC0wMTowMzox
NCBkZXRlY3RpbmcgYm9vdCBzdGF0ZSAzLjExLjAtcmM2LTA0OTY0LWc5M2Q2Mjk0Li4uLi4u
CTEuLgk0CTUJOQkxMwkxNwkxOC4JMjUJMjkJMzEuLgkzMwkzNAkzNgkzOQk0MAk0MQk0Mi4u
Li4JNDUJNDYJNDkuLgk1Mgk1My4uLi4uLi4JNTQuLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4u
Li4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4u
Li4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4u
Li4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4u
Li4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4u
Li4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4u
Li4uLi4uG1sxOzM1bWFkZF90b19ydW5fcXVldWUgMRtbMG0KLi4uCTU1IFNVQ0NFU1MKCkJp
c2VjdGluZzogNTcgcmV2aXNpb25zIGxlZnQgdG8gdGVzdCBhZnRlciB0aGlzIChyb3VnaGx5
IDYgc3RlcHMpCltjNTdlOGM4OWIyNzFhZjRlZjkxNGM0MzllZmZmZmVkNTNjMzk0MzRjXSBN
ZXJnZSByZW1vdGUtdHJhY2tpbmcgYnJhbmNoICdsZWRzL2Zvci1uZXh0JwpydW5uaW5nIC9j
L2tlcm5lbC10ZXN0cy9iaXNlY3QtdGVzdC1ib290LWZhaWx1cmUuc2ggL2hvbWUvd2ZnL3Nv
dW5kL29iai1iaXNlY3QKbHMgLWEgL2tlcm5lbC10ZXN0cy9ydW4tcXVldWUva3ZtL2kzODYt
cmFuZGNvbmZpZy1qNC0wODI3MTA1Ni9uZXh0Om1hc3RlcjpjNTdlOGM4OWIyNzFhZjRlZjkx
NGM0MzllZmZmZmVkNTNjMzk0MzRjOmJpc2VjdC1zb3VuZAoKMjAxMy0wOC0yOC0wNDowMDoy
MSBjNTdlOGM4OWIyNzFhZjRlZjkxNGM0MzllZmZmZmVkNTNjMzk0MzRjIGNvbXBpbGluZwoz
MjIgcmVhbCAgMjI0MSB1c2VyICAyMzkgc3lzICA3NjkuMjElIGNwdSAJaTM4Ni1yYW5kY29u
ZmlnLWo0LTA4MjcxMDU2CgoyMDEzLTA4LTI4LTA0OjA2OjMxIGRldGVjdGluZyBib290IHN0
YXRlIDMuMTEuMC1yYzYtMDUwNDUtZ2M1N2U4YzguLgkxLgkyCTMuLgk0Li4uLgk1Li4uLi4J
Ni4uLgk3CTguLi4uLgk5CTEwCTExLgkxMgkxMy4JMTgJMjYJMjcJMzEJMzQJMzUJMzYJMzcu
Li4JMzkJNDEJNTAJNTIuCTUzLi4uLi4uLi4uCTU0CTU1IFNVQ0NFU1MKCkJpc2VjdGluZzog
MjggcmV2aXNpb25zIGxlZnQgdG8gdGVzdCBhZnRlciB0aGlzIChyb3VnaGx5IDUgc3RlcHMp
Cls3NmY0MTFmYjNhNjI3MTFkZTdmNTllMGY0YzU2NDU2ZmUzNTY2NzVhXSB4ODYgLyBjcHUg
dG9wb2xvZ3k6IHJlbW92ZSB0aGUgc3RhbGUgbWFjcm8gYXJjaF9wcm92aWRlc190b3BvbG9n
eV9wb2ludGVycwpydW5uaW5nIC9jL2tlcm5lbC10ZXN0cy9iaXNlY3QtdGVzdC1ib290LWZh
aWx1cmUuc2ggL2hvbWUvd2ZnL3NvdW5kL29iai1iaXNlY3QKbHMgLWEgL2tlcm5lbC10ZXN0
cy9ydW4tcXVldWUva3ZtL2kzODYtcmFuZGNvbmZpZy1qNC0wODI3MTA1Ni9uZXh0Om1hc3Rl
cjo3NmY0MTFmYjNhNjI3MTFkZTdmNTllMGY0YzU2NDU2ZmUzNTY2NzVhOmJpc2VjdC1zb3Vu
ZAoKMjAxMy0wOC0yOC0wNDozOTowOCA3NmY0MTFmYjNhNjI3MTFkZTdmNTllMGY0YzU2NDU2
ZmUzNTY2NzVhIGNvbXBpbGluZwoyOTYgcmVhbCAgMjI0MSB1c2VyICAyNDkgc3lzICA4Mzku
MTYlIGNwdSAJaTM4Ni1yYW5kY29uZmlnLWo0LTA4MjcxMDU2CgoyMDEzLTA4LTI4LTA0OjQ1
OjA1IGRldGVjdGluZyBib290IHN0YXRlIDMuMTEuMC1yYzMtMDAwMjktZzc2ZjQxMWYuLi4u
Li4uIFRFU1QgRkFJTFVSRQpbICAgIDEuODkyOTg1XSBXQVJOSU5HOiBDUFU6IDAgUElEOiAx
IGF0IC9jL3dmZy9zb3VuZC9saWIvbGlzdF9kZWJ1Zy5jOjMzIF9fbGlzdF9hZGQrMHg0NC8w
eDc4KCkKWyAgICAxLjg5Mzk2MF0gbGlzdF9hZGQgY29ycnVwdGlvbi4gcHJldi0+bmV4dCBz
aG91bGQgYmUgbmV4dCAoNzlhMjMwZjApLCBidXQgd2FzICAgKG51bGwpLiAocHJldj04N2I4
ODhlOCkuClsgICAgMS44OTUwOTBdIE1vZHVsZXMgbGlua2VkIGluOgpbICAgIDEuODk1NTE3
XSBDUFU6IDAgUElEOiAxIENvbW06IHN3YXBwZXIvMCBOb3QgdGFpbnRlZCAzLjExLjAtcmMz
LTAwMDI5LWc3NmY0MTFmICMyODQKWyAgICAxLjg5NjA1Nl0gIDAwMDAwMDAwIDAwMDAwMDAw
IDc4MDQ5YjdjIDc5NTEzMDQ2IDc5NzE0MzBhIDc4MDQ5Yjk0IDc5MDIyYjI4IDc5MWY0YTgy
ClsgICAgMS44OTYwNTZdICA4N2I4ODhlOCA3OWEyMzBmMCA4N2I1NWEwOCA3ODA0OWJhYyA3
OTAyMmI2NSAwMDAwMDAwOSA3ODA0OWJhNCA3OTcxNDMwYQpbICAgIDEuODk2MDU2XSAgNzgw
NDliYzAgNzgwNDliZDggNzkxZjRhODIgNzk3MTQyZWMgMDAwMDAwMjEgNzk3MTQzMGEgNzlh
MjMwZjAgMDAwMDAwMDAKWyAgICAxLjg5NjA1Nl0gQ2FsbCBUcmFjZToKWyAgICAxLjg5NjA1
Nl0gIFs8Nzk1MTMwNDY+XSBkdW1wX3N0YWNrKzB4NGIvMHg2NgpbICAgIDEuODk2MDU2XSAg
Wzw3OTAyMmIyOD5dIHdhcm5fc2xvd3BhdGhfY29tbW9uKzB4NWMvMHg3MwpbICAgIDEuODk2
MDU2XSAgWzw3OTFmNGE4Mj5dID8gX19saXN0X2FkZCsweDQ0LzB4NzgKWyAgICAxLjg5NjA1
Nl0gIFs8NzkwMjJiNjU+XSB3YXJuX3Nsb3dwYXRoX2ZtdCsweDI2LzB4MmEKWyAgICAxLjg5
NjA1Nl0gIFs8NzkxZjRhODI+XSBfX2xpc3RfYWRkKzB4NDQvMHg3OApbICAgIDEuODk2MDU2
XSAgWzw3OTAyYjIxND5dIF9faW50ZXJuYWxfYWRkX3RpbWVyKzB4OTcvMHg5YgpbICAgIDEu
ODk2MDU2XSAgWzw3OTAyYjIyNj5dIGludGVybmFsX2FkZF90aW1lcisweGUvMHgyNgpbICAg
IDEuODk2MDU2XSAgWzw3OTAyYjQ2Zj5dIF9fbW9kX3RpbWVyKzB4YTIvMHhiNwpbICAgIDEu
ODk2MDU2XSAgWzw3OTAyYjU5Nz5dIG1vZF90aW1lcisweDVkLzB4NmMKWyAgICAxLjg5NjA1
Nl0gIFs8NzkwMmI1Yjg+XSBhZGRfdGltZXIrMHgxMi8weDE0ClsgICAgMS44OTYwNTZdICBb
PDc5MDM1MGVmPl0gX19xdWV1ZV9kZWxheWVkX3dvcmsrMHhjYS8weGU0ClsgICAgMS44OTYw
NTZdICBbPDc5MDM1MTRiPl0gcXVldWVfZGVsYXllZF93b3JrX29uKzB4NDIvMHg3MQpbICAg
IDEuODk2MDU2XSAgWzw3OTFkYmZjZj5dIGtvYmplY3RfcmVsZWFzZSsweDZhLzB4NzIKWyAg
ICAxLjg5NjA1Nl0gIFs8NzkxZGMwMTg+XSBrb2JqZWN0X3B1dCsweDQxLzB4NDYKWyAgICAx
Ljg5NjA1Nl0gIFs8NzkxZGMwODI+XSBrb2JqZWN0X2RlbCsweDI1LzB4MmYKWyAgICAxLjg5
NjA1Nl0gIFs8NzkzMmIzZDA+XSBkZXZpY2VfZGVsKzB4MTMyLzB4MTNlClsgICAgMS44OTYw
NTZdICBbPDc5MzJiM2U3Pl0gZGV2aWNlX3VucmVnaXN0ZXIrMHhiLzB4MTUKWyAgICAxLjg5
NjA1Nl0gIFs8NzkzMmI0NDM+XSBkZXZpY2VfZGVzdHJveSsweDJjLzB4MzEKWyAgICAxLjg5
NjA1Nl0gIFs8NzkyODgxMWQ+XSB0dHlfdW5yZWdpc3Rlcl9kZXZpY2UrMHgxZi8weDM3Clsg
ICAgMS44OTYwNTZdICBbPDc5Mjk0NjhlPl0gdWFydF9yZW1vdmVfb25lX3BvcnQrMHg5YS8w
eGU0ClsgICAgMS44OTYwNTZdICBbPDc5Mjk2Y2VlPl0gc2VyaWFsODI1MF9yZWdpc3Rlcl84
MjUwX3BvcnQrMHhjMS8weDIzNQpbICAgIDEuODk2MDU2XSAgWzw3OTI5NzAxMT5dIHNlcmlh
bDgyNTBfcHJvYmUrMHhmYy8weDE0MgpbICAgIDEuODk2MDU2XSAgWzw3OTMyZWE2OD5dIHBs
YXRmb3JtX2Rydl9wcm9iZSsweDI5LzB4NGIKWyAgICAxLjg5NjA1Nl0gIFs8NzkzMmQ5ZmY+
XSBkcml2ZXJfcHJvYmVfZGV2aWNlKzB4ODgvMHgxN2IKWyAgICAxLjg5NjA1Nl0gIFs8Nzkz
MmRiMGU+XSBfX2RldmljZV9hdHRhY2grMHgxYy8weDJjClsgICAgMS44OTYwNTZdICBbPDc5
MzJjNWI5Pl0gYnVzX2Zvcl9lYWNoX2RydisweDM4LzB4NmIKWyAgICAxLjg5NjA1Nl0gIFs8
NzkzMmQ5M2U+XSBkZXZpY2VfYXR0YWNoKzB4NjMvMHg4MwpbICAgIDEuODk2MDU2XSAgWzw3
OTMyZGFmMj5dID8gZHJpdmVyX3Byb2JlX2RldmljZSsweDE3Yi8weDE3YgpbICAgIDEuODk2
MDU2XSAgWzw3OTMyZDExNT5dIGJ1c19wcm9iZV9kZXZpY2UrMHgyNS8weDg0ClsgICAgMS44
OTYwNTZdICBbPDc5MzJiYjQ0Pl0gZGV2aWNlX2FkZCsweDNhYy8weDU1OQpbICAgIDEuODk2
MDU2XSAgWzw3OTFkYzRkOT5dID8ga29iamVjdF9zZXRfbmFtZV92YXJncysweDNkLzB4NGEK
WyAgICAxLjg5NjA1Nl0gIFs8NzkzMmFiNDA+XSA/IGRldl9zZXRfbmFtZSsweDE0LzB4MTYK
WyAgICAxLjg5NjA1Nl0gIFs8NzkzMmU4Y2E+XSBwbGF0Zm9ybV9kZXZpY2VfYWRkKzB4MTBm
LzB4MTczClsgICAgMS44OTYwNTZdICBbPDc5MzJlZDgxPl0gcGxhdGZvcm1fZGV2aWNlX3Jl
Z2lzdGVyKzB4MWMvMHgxZgpbICAgIDEuODk2MDU2XSAgWzw3OTg3ZWYzMj5dID8gc2V0dXBf
ZWFybHlfc2VyaWFsODI1MF9jb25zb2xlKzB4MzVkLzB4MzVkClsgICAgMS44OTYwNTZdICBb
PDc5ODdlZjNmPl0gZm91cnBvcnRfaW5pdCsweGQvMHhmClsgICAgMS44OTYwNTZdICBbPDc5
MDAwM2RhPl0gZG9fb25lX2luaXRjYWxsKzB4NmIvMHhlYwpbICAgIDEuODk2MDU2XSAgWzw3
OTg2MjQwMD5dID8gZG9fZWFybHlfcGFyYW0rMHg2Mi8weDc1ClsgICAgMS44OTYwNTZdICBb
PDc5MDM3YjMwPl0gPyBwYXJzZV9hcmdzKzB4MTZkLzB4MjBlClsgICAgMS44OTYwNTZdICBb
PDc5ODYyOWZjPl0ga2VybmVsX2luaXRfZnJlZWFibGUrMHhkOC8weDE1ZApbICAgIDEuODk2
MDU2XSAgWzw3OTUwZDczOD5dIGtlcm5lbF9pbml0KzB4OC8weGI0ClsgICAgMS44OTYwNTZd
ICBbPDc5NTFmMjc3Pl0gcmV0X2Zyb21fa2VybmVsX3RocmVhZCsweDFiLzB4MjgKWyAgICAx
Ljg5NjA1Nl0gIFs8Nzk1MGQ3MzA+XSA/IHJlc3RfaW5pdCsweDExOC8weDExOApbICAgIDEu
ODk2MDU2XSAtLS1bIGVuZCB0cmFjZSA4MDlhMjcwYzFlYmRiMjZkIF0tLS0KL2tlcm5lbC9p
Mzg2LXJhbmRjb25maWctajQtMDgyNzEwNTYvNzZmNDExZmIzYTYyNzExZGU3ZjU5ZTBmNGM1
NjQ1NmZlMzU2Njc1YS9kbWVzZy1rdm0teGlhbi0yNjA3NC0yMDEzMDgyODA0NDgxMi0zLjEx
LjAtcmM3LTAwMjIzLWc1YzllM2M1LTEwCgpCaXNlY3Rpbmc6IDEzIHJldmlzaW9ucyBsZWZ0
IHRvIHRlc3QgYWZ0ZXIgdGhpcyAocm91Z2hseSA0IHN0ZXBzKQpbZDc5ZmQwM2ZkNjUxYmQ5
MWEwODFmYzk3ZjVmMGQyMjE1NTdmOGNiYl0gdmlkZW86IGJhY2tsaWdodDogbGNkOiBjb252
ZXJ0IGNsYXNzIGNvZGUgdG8gdXNlIGRldl9ncm91cHMKcnVubmluZyAvYy9rZXJuZWwtdGVz
dHMvYmlzZWN0LXRlc3QtYm9vdC1mYWlsdXJlLnNoIC9ob21lL3dmZy9zb3VuZC9vYmotYmlz
ZWN0CmxzIC1hIC9rZXJuZWwtdGVzdHMvcnVuLXF1ZXVlL2t2bS9pMzg2LXJhbmRjb25maWct
ajQtMDgyNzEwNTYvbmV4dDptYXN0ZXI6ZDc5ZmQwM2ZkNjUxYmQ5MWEwODFmYzk3ZjVmMGQy
MjE1NTdmOGNiYjpiaXNlY3Qtc291bmQKCjIwMTMtMDgtMjgtMDQ6NDg6MzggZDc5ZmQwM2Zk
NjUxYmQ5MWEwODFmYzk3ZjVmMGQyMjE1NTdmOGNiYiBjb21waWxpbmcKMjg4IHJlYWwgIDIy
MzUgdXNlciAgMjUwIHN5cyAgODYyLjQxJSBjcHUgCWkzODYtcmFuZGNvbmZpZy1qNC0wODI3
MTA1NgoKMjAxMy0wOC0yOC0wNDo1Mzo1MyBkZXRlY3RpbmcgYm9vdCBzdGF0ZSAzLjExLjAt
cmMyLTAwMDE1LWdkNzlmZDAzLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLiBURVNUIEZBSUxV
UkUKWyAgICA0LjMwMDM1MF0gV0FSTklORzogQ1BVOiAwIFBJRDogMSBhdCAvYy93Zmcvc291
bmQvbGliL2xpc3RfZGVidWcuYzozMyBfX2xpc3RfYWRkKzB4NDQvMHg3OCgpClsgICAgNC4z
MDE2NzldIGxpc3RfYWRkIGNvcnJ1cHRpb24uIHByZXYtPm5leHQgc2hvdWxkIGJlIG5leHQg
KDc5YTI1MGI4KSwgYnV0IHdhcyAgIChudWxsKS4gKHByZXY9NzgyMGEwZTgpLgpbICAgIDQu
MzAzMTUzXSBNb2R1bGVzIGxpbmtlZCBpbjoKWyAgICA0LjMwMzUyMl0gQ1BVOiAwIFBJRDog
MSBDb21tOiBzd2FwcGVyLzAgTm90IHRhaW50ZWQgMy4xMS4wLXJjMi0wMDAxNS1nZDc5ZmQw
MyAjMjg1ClsgICAgNC4zMDM1MjJdICAwMDAwMDAwMCAwMDAwMDAwMCA3ODA0OWI3YyA3OTUx
MzM4YSA3OTcxNTI1NiA3ODA0OWI5NCA3OTAyMmIyOCA3OTFmNGE4MgpbICAgIDQuMzAzNTIy
XSAgNzgyMGEwZTggNzlhMjUwYjggNzgxZjNjNDggNzgwNDliYWMgNzkwMjJiNjUgMDAwMDAw
MDkgNzgwNDliYTQgNzk3MTUyNTYKWyAgICA0LjMwMzUyMl0gIDc4MDQ5YmMwIDc4MDQ5YmQ4
IDc5MWY0YTgyIDc5NzE1MjM4IDAwMDAwMDIxIDc5NzE1MjU2IDc5YTI1MGI4IDAwMDAwMDAw
ClsgICAgNC4zMDM1MjJdIENhbGwgVHJhY2U6ClsgICAgNC4zMDM1MjJdICBbPDc5NTEzMzhh
Pl0gZHVtcF9zdGFjaysweDRiLzB4NjYKWyAgICA0LjMwMzUyMl0gIFs8NzkwMjJiMjg+XSB3
YXJuX3Nsb3dwYXRoX2NvbW1vbisweDVjLzB4NzMKWyAgICA0LjMwMzUyMl0gIFs8NzkxZjRh
ODI+XSA/IF9fbGlzdF9hZGQrMHg0NC8weDc4ClsgICAgNC4zMDM1MjJdICBbPDc5MDIyYjY1
Pl0gd2Fybl9zbG93cGF0aF9mbXQrMHgyNi8weDJhClsgICAgNC4zMDM1MjJdICBbPDc5MWY0
YTgyPl0gX19saXN0X2FkZCsweDQ0LzB4NzgKWyAgICA0LjMwMzUyMl0gIFs8NzkwMmIyMTQ+
XSBfX2ludGVybmFsX2FkZF90aW1lcisweDk3LzB4OWIKWyAgICA0LjMwMzUyMl0gIFs8Nzkw
MmIyMjY+XSBpbnRlcm5hbF9hZGRfdGltZXIrMHhlLzB4MjYKWyAgICA0LjMwMzUyMl0gIFs8
NzkwMmI0NmY+XSBfX21vZF90aW1lcisweGEyLzB4YjcKWyAgICA0LjMwMzUyMl0gIFs8Nzkw
MmI1OTc+XSBtb2RfdGltZXIrMHg1ZC8weDZjClsgICAgNC4zMDM1MjJdICBbPDc5MDJiNWI4
Pl0gYWRkX3RpbWVyKzB4MTIvMHgxNApbICAgIDQuMzAzNTIyXSAgWzw3OTAzNTBlZj5dIF9f
cXVldWVfZGVsYXllZF93b3JrKzB4Y2EvMHhlNApbICAgIDQuMzAzNTIyXSAgWzw3OTAzNTE0
Yj5dIHF1ZXVlX2RlbGF5ZWRfd29ya19vbisweDQyLzB4NzEKWyAgICA0LjMwMzUyMl0gIFs8
NzkxZGJmYzc+XSBrb2JqZWN0X3JlbGVhc2UrMHg2YS8weDcyClsgICAgNC4zMDM1MjJdICBb
PDc5MWRjMDEwPl0ga29iamVjdF9wdXQrMHg0MS8weDQ2ClsgICAgNC4zMDM1MjJdICBbPDc5
MWRjMDdhPl0ga29iamVjdF9kZWwrMHgyNS8weDJmClsgICAgNC4zMDM1MjJdICBbPDc5MzJi
NDA0Pl0gZGV2aWNlX2RlbCsweDEzMi8weDEzZQpbICAgIDQuMzAzNTIyXSAgWzw3OTMyYjQx
Yj5dIGRldmljZV91bnJlZ2lzdGVyKzB4Yi8weDE1ClsgICAgNC4zMDM1MjJdICBbPDc5MzJi
NDc3Pl0gZGV2aWNlX2Rlc3Ryb3krMHgyYy8weDMxClsgICAgNC4zMDM1MjJdICBbPDc5Mjg4
MjcxPl0gdHR5X3VucmVnaXN0ZXJfZGV2aWNlKzB4MWYvMHgzNwpbICAgIDQuMzAzNTIyXSAg
Wzw3OTI5NDdlMj5dIHVhcnRfcmVtb3ZlX29uZV9wb3J0KzB4OWEvMHhlNApbICAgIDQuMzAz
NTIyXSAgWzw3OTI5NmU0Mj5dIHNlcmlhbDgyNTBfcmVnaXN0ZXJfODI1MF9wb3J0KzB4YzEv
MHgyMzUKWyAgICA0LjMwMzUyMl0gIFs8NzkyOTcxNjU+XSBzZXJpYWw4MjUwX3Byb2JlKzB4
ZmMvMHgxNDIKWyAgICA0LjMwMzUyMl0gIFs8NzkzMmVhOWM+XSBwbGF0Zm9ybV9kcnZfcHJv
YmUrMHgyOS8weDRiClsgICAgNC4zMDM1MjJdICBbPDc5MzJkYTMzPl0gZHJpdmVyX3Byb2Jl
X2RldmljZSsweDg4LzB4MTdiClsgICAgNC4zMDM1MjJdICBbPDc5MzJkYjQyPl0gX19kZXZp
Y2VfYXR0YWNoKzB4MWMvMHgyYwpbICAgIDQuMzAzNTIyXSAgWzw3OTMyYzVlZD5dIGJ1c19m
b3JfZWFjaF9kcnYrMHgzOC8weDZiClsgICAgNC4zMDM1MjJdICBbPDc5MzJkOTcyPl0gZGV2
aWNlX2F0dGFjaCsweDYzLzB4ODMKWyAgICA0LjMwMzUyMl0gIFs8NzkzMmRiMjY+XSA/IGRy
aXZlcl9wcm9iZV9kZXZpY2UrMHgxN2IvMHgxN2IKWyAgICA0LjMwMzUyMl0gIFs8NzkzMmQx
NDk+XSBidXNfcHJvYmVfZGV2aWNlKzB4MjUvMHg4NApbICAgIDQuMzAzNTIyXSAgWzw3OTMy
YmI3OD5dIGRldmljZV9hZGQrMHgzYWMvMHg1NTkKWyAgICA0LjMwMzUyMl0gIFs8NzkxZGM0
ZDE+XSA/IGtvYmplY3Rfc2V0X25hbWVfdmFyZ3MrMHgzZC8weDRhClsgICAgNC4zMDM1MjJd
ICBbPDc5MzJhYjc0Pl0gPyBkZXZfc2V0X25hbWUrMHgxNC8weDE2ClsgICAgNC4zMDM1MjJd
ICBbPDc5MzJlOGZlPl0gcGxhdGZvcm1fZGV2aWNlX2FkZCsweDEwZi8weDE3MwpbICAgIDQu
MzAzNTIyXSAgWzw3OTMyZWRiNT5dIHBsYXRmb3JtX2RldmljZV9yZWdpc3RlcisweDFjLzB4
MWYKWyAgICA0LjMwMzUyMl0gIFs8Nzk4ODBmMmY+XSA/IHNldHVwX2Vhcmx5X3NlcmlhbDgy
NTBfY29uc29sZSsweDM1YS8weDM1YQpbICAgIDQuMzAzNTIyXSAgWzw3OTg4MGYzYz5dIGZv
dXJwb3J0X2luaXQrMHhkLzB4ZgpbICAgIDQuMzAzNTIyXSAgWzw3OTAwMDNkYT5dIGRvX29u
ZV9pbml0Y2FsbCsweDZiLzB4ZWMKWyAgICA0LjMwMzUyMl0gIFs8Nzk4NjQ0MDA+XSA/IGRv
X2Vhcmx5X3BhcmFtKzB4NjIvMHg3NQpbICAgIDQuMzAzNTIyXSAgWzw3OTAzN2IzMD5dID8g
cGFyc2VfYXJncysweDE2ZC8weDIwZQpbICAgIDQuMzAzNTIyXSAgWzw3OTg2NDlmYz5dIGtl
cm5lbF9pbml0X2ZyZWVhYmxlKzB4ZDgvMHgxNWQKWyAgICA0LjMwMzUyMl0gIFs8Nzk1MGRh
N2M+XSBrZXJuZWxfaW5pdCsweDgvMHhiNApbICAgIDQuMzAzNTIyXSAgWzw3OTUxZjViNz5d
IHJldF9mcm9tX2tlcm5lbF90aHJlYWQrMHgxYi8weDI4ClsgICAgNC4zMDM1MjJdICBbPDc5
NTBkYTc0Pl0gPyByZXN0X2luaXQrMHgxMTgvMHgxMTgKWyAgICA0LjMwMzUyMl0gLS0tWyBl
bmQgdHJhY2UgNWFlY2IxOTgwYzA4MWFiNSBdLS0tCi9rZXJuZWwvaTM4Ni1yYW5kY29uZmln
LWo0LTA4MjcxMDU2L2Q3OWZkMDNmZDY1MWJkOTFhMDgxZmM5N2Y1ZjBkMjIxNTU3ZjhjYmIv
ZG1lc2cta3ZtLWJlbnMtNDE5OC0yMDEzMDgyODA0NTk1MS0zLjExLjAtcmMyLTAwMDE1LWdk
NzlmZDAzLTI4NQoKQmlzZWN0aW5nOiA2IHJldmlzaW9ucyBsZWZ0IHRvIHRlc3QgYWZ0ZXIg
dGhpcyAocm91Z2hseSAzIHN0ZXBzKQpbYWMzNzg1ZDVjMTU5MjJjOGE0YzZiOWUwNTBhNWJj
NTk4OTVhNmI5Yl0gYzJwb3J0OiBjb252ZXJ0IGNsYXNzIGNvZGUgdG8gdXNlIGJpbl9hdHRy
cyBpbiBncm91cHMKcnVubmluZyAvYy9rZXJuZWwtdGVzdHMvYmlzZWN0LXRlc3QtYm9vdC1m
YWlsdXJlLnNoIC9ob21lL3dmZy9zb3VuZC9vYmotYmlzZWN0CmxzIC1hIC9rZXJuZWwtdGVz
dHMvcnVuLXF1ZXVlL2t2bS9pMzg2LXJhbmRjb25maWctajQtMDgyNzEwNTYvbmV4dDptYXN0
ZXI6YWMzNzg1ZDVjMTU5MjJjOGE0YzZiOWUwNTBhNWJjNTk4OTVhNmI5YjpiaXNlY3Qtc291
bmQKCjIwMTMtMDgtMjgtMDU6MDY6MjkgYWMzNzg1ZDVjMTU5MjJjOGE0YzZiOWUwNTBhNWJj
NTk4OTVhNmI5YiBjb21waWxpbmcKMjc3IHJlYWwgIDIxNzMgdXNlciAgMjQ0IHN5cyAgODcw
LjE2JSBjcHUgCWkzODYtcmFuZGNvbmZpZy1qNC0wODI3MTA1NgoKMjAxMy0wOC0yOC0wNTox
MTozNCBkZXRlY3RpbmcgYm9vdCBzdGF0ZSAzLjExLjAtcmMyLTAwMDA4LWdhYzM3ODVkLi4u
Li4uLi4uLi4uLi4uLi4uLgk1Lgk3Li4JOC4JOS4JMTIJMTQJMTUJMTcuLgkyMQkyMgkyNAky
NS4uCTI2LgkyNy4JMjguLi4uLi4uCTI5Li4JMzEuLi4JMzIJMzMJMzYJMzkuLgk0MAk0MS4J
NDIuCTQzLgk0NAk0Ngk0Ny4JNDgJNTAJNTMuLi4JNTUgU1VDQ0VTUwoKQmlzZWN0aW5nOiAz
IHJldmlzaW9ucyBsZWZ0IHRvIHRlc3QgYWZ0ZXIgdGhpcyAocm91Z2hseSAyIHN0ZXBzKQpb
NThiMjY3ZDNlM2YzY2U4N2MzZTU1OWU0YzMzMGM4YzAzZTkwNWY1ZV0gZG1hOiBjb252ZXJ0
IGRtYV9kZXZjbGFzcyB0byB1c2UgZGV2X2dyb3VwcwpydW5uaW5nIC9jL2tlcm5lbC10ZXN0
cy9iaXNlY3QtdGVzdC1ib290LWZhaWx1cmUuc2ggL2hvbWUvd2ZnL3NvdW5kL29iai1iaXNl
Y3QKbHMgLWEgL2tlcm5lbC10ZXN0cy9ydW4tcXVldWUva3ZtL2kzODYtcmFuZGNvbmZpZy1q
NC0wODI3MTA1Ni9uZXh0Om1hc3Rlcjo1OGIyNjdkM2UzZjNjZTg3YzNlNTU5ZTRjMzMwYzhj
MDNlOTA1ZjVlOmJpc2VjdC1zb3VuZAoKMjAxMy0wOC0yOC0wNTo1MzoxNyA1OGIyNjdkM2Uz
ZjNjZTg3YzNlNTU5ZTRjMzMwYzhjMDNlOTA1ZjVlIGNvbXBpbGluZwoyNzggcmVhbCAgMjE3
MSB1c2VyICAyMzUgc3lzICA4NjQuNTIlIGNwdSAJaTM4Ni1yYW5kY29uZmlnLWo0LTA4Mjcx
MDU2CgoyMDEzLTA4LTI4LTA1OjU5OjIxIGRldGVjdGluZyBib290IHN0YXRlIDMuMTEuMC1y
YzItMDAwMTEtZzU4YjI2N2QuLi4uLgkxLi4gVEVTVCBGQUlMVVJFClsgICAgMi40OTE3MzBd
IFdBUk5JTkc6IENQVTogMCBQSUQ6IDEgYXQgL2Mvd2ZnL3NvdW5kL2xpYi9saXN0X2RlYnVn
LmM6MzMgX19saXN0X2FkZCsweDQ0LzB4NzgoKQpbICAgIDIuNDkyMTA1XSBsaXN0X2FkZCBj
b3JydXB0aW9uLiBwcmV2LT5uZXh0IHNob3VsZCBiZSBuZXh0ICg3OWEyNTEwMCksIGJ1dCB3
YXMgICAobnVsbCkuIChwcmV2PTg3YmNjY2U4KS4KWyAgICAyLjQ5MjEwNV0gTW9kdWxlcyBs
aW5rZWQgaW46ClsgICAgMi40OTIxMDVdIENQVTogMCBQSUQ6IDEgQ29tbTogc3dhcHBlci8w
IE5vdCB0YWludGVkIDMuMTEuMC1yYzItMDAwMTEtZzU4YjI2N2QgIzI4NwpbICAgIDIuNDky
MTA1XSAgMDAwMDAwMDAgMDAwMDAwMDAgNzgwNDliN2MgNzk1MTMzOGEgNzk3MTUyMmEgNzgw
NDliOTQgNzkwMjJiMjggNzkxZjRhODIKWyAgICAyLjQ5MjEwNV0gIDg3YmNjY2U4IDc5YTI1
MTAwIDg3YjY0YTA4IDc4MDQ5YmFjIDc5MDIyYjY1IDAwMDAwMDA5IDc4MDQ5YmE0IDc5NzE1
MjJhClsgICAgMi40OTIxMDVdICA3ODA0OWJjMCA3ODA0OWJkOCA3OTFmNGE4MiA3OTcxNTIw
YyAwMDAwMDAyMSA3OTcxNTIyYSA3OWEyNTEwMCAwMDAwMDAwMApbICAgIDIuNDkyMTA1XSBD
YWxsIFRyYWNlOgpbICAgIDIuNDkyMTA1XSAgWzw3OTUxMzM4YT5dIGR1bXBfc3RhY2srMHg0
Yi8weDY2ClsgICAgMi40OTIxMDVdICBbPDc5MDIyYjI4Pl0gd2Fybl9zbG93cGF0aF9jb21t
b24rMHg1Yy8weDczClsgICAgMi40OTIxMDVdICBbPDc5MWY0YTgyPl0gPyBfX2xpc3RfYWRk
KzB4NDQvMHg3OApbICAgIDIuNDkyMTA1XSAgWzw3OTAyMmI2NT5dIHdhcm5fc2xvd3BhdGhf
Zm10KzB4MjYvMHgyYQpbICAgIDIuNDkyMTA1XSAgWzw3OTFmNGE4Mj5dIF9fbGlzdF9hZGQr
MHg0NC8weDc4ClsgICAgMi40OTIxMDVdICBbPDc5MDJiMjE0Pl0gX19pbnRlcm5hbF9hZGRf
dGltZXIrMHg5Ny8weDliClsgICAgMi40OTIxMDVdICBbPDc5MDJiMjI2Pl0gaW50ZXJuYWxf
YWRkX3RpbWVyKzB4ZS8weDI2ClsgICAgMi40OTIxMDVdICBbPDc5MDJiNDZmPl0gX19tb2Rf
dGltZXIrMHhhMi8weGI3ClsgICAgMi40OTIxMDVdICBbPDc5MDJiNTk3Pl0gbW9kX3RpbWVy
KzB4NWQvMHg2YwpbICAgIDIuNDkyMTA1XSAgWzw3OTAyYjViOD5dIGFkZF90aW1lcisweDEy
LzB4MTQKWyAgICAyLjQ5MjEwNV0gIFs8NzkwMzUwZWY+XSBfX3F1ZXVlX2RlbGF5ZWRfd29y
aysweGNhLzB4ZTQKWyAgICAyLjQ5MjEwNV0gIFs8NzkwMzUxNGI+XSBxdWV1ZV9kZWxheWVk
X3dvcmtfb24rMHg0Mi8weDcxClsgICAgMi40OTIxMDVdICBbPDc5MWRiZmM3Pl0ga29iamVj
dF9yZWxlYXNlKzB4NmEvMHg3MgpbICAgIDIuNDkyMTA1XSAgWzw3OTFkYzAxMD5dIGtvYmpl
Y3RfcHV0KzB4NDEvMHg0NgpbICAgIDIuNDkyMTA1XSAgWzw3OTFkYzA3YT5dIGtvYmplY3Rf
ZGVsKzB4MjUvMHgyZgpbICAgIDIuNDkyMTA1XSAgWzw3OTMyYjQwND5dIGRldmljZV9kZWwr
MHgxMzIvMHgxM2UKWyAgICAyLjQ5MjEwNV0gIFs8NzkzMmI0MWI+XSBkZXZpY2VfdW5yZWdp
c3RlcisweGIvMHgxNQpbICAgIDIuNDkyMTA1XSAgWzw3OTMyYjQ3Nz5dIGRldmljZV9kZXN0
cm95KzB4MmMvMHgzMQpbICAgIDIuNDkyMTA1XSAgWzw3OTI4ODI3MT5dIHR0eV91bnJlZ2lz
dGVyX2RldmljZSsweDFmLzB4MzcKWyAgICAyLjQ5MjEwNV0gIFs8NzkyOTQ3ZTI+XSB1YXJ0
X3JlbW92ZV9vbmVfcG9ydCsweDlhLzB4ZTQKWyAgICAyLjQ5MjEwNV0gIFs8NzkyOTZlNDI+
XSBzZXJpYWw4MjUwX3JlZ2lzdGVyXzgyNTBfcG9ydCsweGMxLzB4MjM1ClsgICAgMi40OTIx
MDVdICBbPDc5Mjk3MTY1Pl0gc2VyaWFsODI1MF9wcm9iZSsweGZjLzB4MTQyClsgICAgMi40
OTIxMDVdICBbPDc5MzJlYTljPl0gcGxhdGZvcm1fZHJ2X3Byb2JlKzB4MjkvMHg0YgpbICAg
IDIuNDkyMTA1XSAgWzw3OTMyZGEzMz5dIGRyaXZlcl9wcm9iZV9kZXZpY2UrMHg4OC8weDE3
YgpbICAgIDIuNDkyMTA1XSAgWzw3OTMyZGI0Mj5dIF9fZGV2aWNlX2F0dGFjaCsweDFjLzB4
MmMKWyAgICAyLjQ5MjEwNV0gIFs8NzkzMmM1ZWQ+XSBidXNfZm9yX2VhY2hfZHJ2KzB4Mzgv
MHg2YgpbICAgIDIuNDkyMTA1XSAgWzw3OTMyZDk3Mj5dIGRldmljZV9hdHRhY2grMHg2My8w
eDgzClsgICAgMi40OTIxMDVdICBbPDc5MzJkYjI2Pl0gPyBkcml2ZXJfcHJvYmVfZGV2aWNl
KzB4MTdiLzB4MTdiClsgICAgMi40OTIxMDVdICBbPDc5MzJkMTQ5Pl0gYnVzX3Byb2JlX2Rl
dmljZSsweDI1LzB4ODQKWyAgICAyLjQ5MjEwNV0gIFs8NzkzMmJiNzg+XSBkZXZpY2VfYWRk
KzB4M2FjLzB4NTU5ClsgICAgMi40OTIxMDVdICBbPDc5MWRjNGQxPl0gPyBrb2JqZWN0X3Nl
dF9uYW1lX3ZhcmdzKzB4M2QvMHg0YQpbICAgIDIuNDkyMTA1XSAgWzw3OTMyYWI3ND5dID8g
ZGV2X3NldF9uYW1lKzB4MTQvMHgxNgpbICAgIDIuNDkyMTA1XSAgWzw3OTMyZThmZT5dIHBs
YXRmb3JtX2RldmljZV9hZGQrMHgxMGYvMHgxNzMKWyAgICAyLjQ5MjEwNV0gIFs8NzkzMmVk
YjU+XSBwbGF0Zm9ybV9kZXZpY2VfcmVnaXN0ZXIrMHgxYy8weDFmClsgICAgMi40OTIxMDVd
ICBbPDc5ODgwZjJmPl0gPyBzZXR1cF9lYXJseV9zZXJpYWw4MjUwX2NvbnNvbGUrMHgzNWEv
MHgzNWEKWyAgICAyLjQ5MjEwNV0gIFs8Nzk4ODBmM2M+XSBmb3VycG9ydF9pbml0KzB4ZC8w
eGYKWyAgICAyLjQ5MjEwNV0gIFs8NzkwMDAzZGE+XSBkb19vbmVfaW5pdGNhbGwrMHg2Yi8w
eGVjClsgICAgMi40OTIxMDVdICBbPDc5ODY0NDAwPl0gPyBkb19lYXJseV9wYXJhbSsweDYy
LzB4NzUKWyAgICAyLjQ5MjEwNV0gIFs8NzkwMzdiMzA+XSA/IHBhcnNlX2FyZ3MrMHgxNmQv
MHgyMGUKWyAgICAyLjQ5MjEwNV0gIFs8Nzk4NjQ5ZmM+XSBrZXJuZWxfaW5pdF9mcmVlYWJs
ZSsweGQ4LzB4MTVkClsgICAgMi40OTIxMDVdICBbPDc5NTBkYTdjPl0ga2VybmVsX2luaXQr
MHg4LzB4YjQKWyAgICAyLjQ5MjEwNV0gIFs8Nzk1MWY1Yjc+XSByZXRfZnJvbV9rZXJuZWxf
dGhyZWFkKzB4MWIvMHgyOApbICAgIDIuNDkyMTA1XSAgWzw3OTUwZGE3ND5dID8gcmVzdF9p
bml0KzB4MTE4LzB4MTE4ClsgICAgMi40OTIxMDVdIC0tLVsgZW5kIHRyYWNlIGVlZDk2MjI0
NzllYTFmOTIgXS0tLQova2VybmVsL2kzODYtcmFuZGNvbmZpZy1qNC0wODI3MTA1Ni81OGIy
NjdkM2UzZjNjZTg3YzNlNTU5ZTRjMzMwYzhjMDNlOTA1ZjVlL2RtZXNnLWt2bS13YWltZWEt
MjEyNTMtMjAxMzA4MjgwNjAxMDMtMy4xMS4wLXJjNy0wMDkyMi1nYjgxNzhjOS00Ci9rZXJu
ZWwvaTM4Ni1yYW5kY29uZmlnLWo0LTA4MjcxMDU2LzU4YjI2N2QzZTNmM2NlODdjM2U1NTll
NGMzMzBjOGMwM2U5MDVmNWUvZG1lc2cta3ZtLXdhaW1lYS0yMTI1My0yMDEzMDgyODA2MDIy
MC0zLjExLjAtcmM3LTAwOTIyLWdiODE3OGM5LTQKL2tlcm5lbC9pMzg2LXJhbmRjb25maWct
ajQtMDgyNzEwNTYvNThiMjY3ZDNlM2YzY2U4N2MzZTU1OWU0YzMzMGM4YzAzZTkwNWY1ZS9k
bWVzZy1rdm0td2FpbWVhLTkzMzAtMjAxMzA4MjgwNjAxMTQtMy4xMS4wLXJjNy0wMDkyMi1n
YjgxNzhjOS00Ci9rZXJuZWwvaTM4Ni1yYW5kY29uZmlnLWo0LTA4MjcxMDU2LzU4YjI2N2Qz
ZTNmM2NlODdjM2U1NTllNGMzMzBjOGMwM2U5MDVmNWUvZG1lc2cta3ZtLXdhaW1lYS05MzQ2
LTIwMTMwODI4MDYwMTQwLTMuMTEuMC1yYzctMDAxMzAtZ2VhNDU1YzA0LTQ3CgpCaXNlY3Rp
bmc6IDEgcmV2aXNpb24gbGVmdCB0byB0ZXN0IGFmdGVyIHRoaXMgKHJvdWdobHkgMSBzdGVw
KQpbN2M0MjcyMWZlMGM1OGE4NDg4NDliNDNmZjU1OGNmMmZiODZhYTM1YV0gY2hhcjogdGls
ZS1zcm9tOiBmaXggYnVpbGQgZXJyb3IKcnVubmluZyAvYy9rZXJuZWwtdGVzdHMvYmlzZWN0
LXRlc3QtYm9vdC1mYWlsdXJlLnNoIC9ob21lL3dmZy9zb3VuZC9vYmotYmlzZWN0CmxzIC1h
IC9rZXJuZWwtdGVzdHMvcnVuLXF1ZXVlL2t2bS9pMzg2LXJhbmRjb25maWctajQtMDgyNzEw
NTYvbmV4dDptYXN0ZXI6N2M0MjcyMWZlMGM1OGE4NDg4NDliNDNmZjU1OGNmMmZiODZhYTM1
YTpiaXNlY3Qtc291bmQKCjIwMTMtMDgtMjgtMDY6MDM6MjQgN2M0MjcyMWZlMGM1OGE4NDg4
NDliNDNmZjU1OGNmMmZiODZhYTM1YSBjb21waWxpbmcKMjYwIHJlYWwgIDIxNzMgdXNlciAg
MjM1IHN5cyAgOTI0LjkxJSBjcHUgCWkzODYtcmFuZGNvbmZpZy1qNC0wODI3MTA1NgoKMjAx
My0wOC0yOC0wNjowODoyMyBkZXRlY3RpbmcgYm9vdCBzdGF0ZSAzLjExLjAtcmMyLTAwMDA5
LWc3YzQyNzIxLi4uLi4JMgkzCTUJNwk5LgkxMAkxMS4JMTMJMTQuCTE1Li4JMTcJMjIJMjYu
CTI4CTI5CTMwLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4u
Li4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4u
Li4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4u
Li4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4u
Li4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4u
Li4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLhtbMTszNW1hZGRfdG9f
cnVuX3F1ZXVlIDI1G1swbQouCTMzLi4uLi4JMzUuLi4uLi4uCTM3Li4uLi4uLgkzOC4uLi4J
MzkuCTQwLgk0MS4uCTQzCTQ1Li4uLgk0Ni4JNDcuLgk0OC4uLi4uLi4uLi4JNDkJNTIJNTMu
Li4uLi4uLi4uLi4uLi4uLgk1NC4JNTUgU1VDQ0VTUwoKQmlzZWN0aW5nOiAwIHJldmlzaW9u
cyBsZWZ0IHRvIHRlc3QgYWZ0ZXIgdGhpcyAocm91Z2hseSAwIHN0ZXBzKQpbYzgxN2E2N2Vj
YmE3YzNjMmFhYTEwNDc5NmQ3OGYxNjBhZjYwOTIwZF0ga29iamVjdDogZGVsYXllZCBrb2Jq
ZWN0IHJlbGVhc2U6IGhlbHAgZmluZCBidWdneSBkcml2ZXJzCnJ1bm5pbmcgL2Mva2VybmVs
LXRlc3RzL2Jpc2VjdC10ZXN0LWJvb3QtZmFpbHVyZS5zaCAvaG9tZS93Zmcvc291bmQvb2Jq
LWJpc2VjdApscyAtYSAva2VybmVsLXRlc3RzL3J1bi1xdWV1ZS9rdm0vaTM4Ni1yYW5kY29u
ZmlnLWo0LTA4MjcxMDU2L25leHQ6bWFzdGVyOmM4MTdhNjdlY2JhN2MzYzJhYWExMDQ3OTZk
NzhmMTYwYWY2MDkyMGQ6YmlzZWN0LXNvdW5kCgoyMDEzLTA4LTI4LTA5OjMzOjI0IGM4MTdh
NjdlY2JhN2MzYzJhYWExMDQ3OTZkNzhmMTYwYWY2MDkyMGQgY29tcGlsaW5nCjMyMiByZWFs
ICAyMDIwIHVzZXIgIDIyOSBzeXMgIDY5OC45NiUgY3B1IAlpMzg2LXJhbmRjb25maWctajQt
MDgyNzEwNTYKCjIwMTMtMDgtMjgtMDk6Mzk6MTEgZGV0ZWN0aW5nIGJvb3Qgc3RhdGUgMy4x
MS4wLXJjMi0wMDAxMC1nYzgxN2E2Ny4uIFRFU1QgRkFJTFVSRQpbICAgIDIuMzkxMTU4XSBX
QVJOSU5HOiBDUFU6IDAgUElEOiAxIGF0IC9jL3dmZy9zb3VuZC9saWIvbGlzdF9kZWJ1Zy5j
OjMzIF9fbGlzdF9hZGQrMHg0NC8weDc4KCkKWyAgICAyLjM5MjA2Ml0gbGlzdF9hZGQgY29y
cnVwdGlvbi4gcHJldi0+bmV4dCBzaG91bGQgYmUgbmV4dCAoNzlhMjUxMDApLCBidXQgd2Fz
ICAgKG51bGwpLiAocHJldj04N2I4NDhlOCkuClsgICAgMi4zOTIwNjJdIE1vZHVsZXMgbGlu
a2VkIGluOgpbICAgIDIuMzkyMDYyXSBDUFU6IDAgUElEOiAxIENvbW06IHN3YXBwZXIvMCBO
b3QgdGFpbnRlZCAzLjExLjAtcmMyLTAwMDEwLWdjODE3YTY3ICMyODkKWyAgICAyLjM5MjA2
Ml0gIDAwMDAwMDAwIDAwMDAwMDAwIDc4MDQ5YjdjIDc5NTEzMzhhIDc5NzE1MWUyIDc4MDQ5
Yjk0IDc5MDIyYjI4IDc5MWY0YTgyClsgICAgMi4zOTIwNjJdICA4N2I4NDhlOCA3OWEyNTEw
MCA4N2I1ZDg4OCA3ODA0OWJhYyA3OTAyMmI2NSAwMDAwMDAwOSA3ODA0OWJhNCA3OTcxNTFl
MgpbICAgIDIuMzkyMDYyXSAgNzgwNDliYzAgNzgwNDliZDggNzkxZjRhODIgNzk3MTUxYzQg
MDAwMDAwMjEgNzk3MTUxZTIgNzlhMjUxMDAgMDAwMDAwMDAKWyAgICAyLjM5MjA2Ml0gQ2Fs
bCBUcmFjZToKWyAgICAyLjM5MjA2Ml0gIFs8Nzk1MTMzOGE+XSBkdW1wX3N0YWNrKzB4NGIv
MHg2NgpbICAgIDIuMzkyMDYyXSAgWzw3OTAyMmIyOD5dIHdhcm5fc2xvd3BhdGhfY29tbW9u
KzB4NWMvMHg3MwpbICAgIDIuMzkyMDYyXSAgWzw3OTFmNGE4Mj5dID8gX19saXN0X2FkZCsw
eDQ0LzB4NzgKWyAgICAyLjM5MjA2Ml0gIFs8NzkwMjJiNjU+XSB3YXJuX3Nsb3dwYXRoX2Zt
dCsweDI2LzB4MmEKWyAgICAyLjM5MjA2Ml0gIFs8NzkxZjRhODI+XSBfX2xpc3RfYWRkKzB4
NDQvMHg3OApbICAgIDIuMzkyMDYyXSAgWzw3OTAyYjIxND5dIF9faW50ZXJuYWxfYWRkX3Rp
bWVyKzB4OTcvMHg5YgpbICAgIDIuMzkyMDYyXSAgWzw3OTAyYjIyNj5dIGludGVybmFsX2Fk
ZF90aW1lcisweGUvMHgyNgpbICAgIDIuMzkyMDYyXSAgWzw3OTAyYjQ2Zj5dIF9fbW9kX3Rp
bWVyKzB4YTIvMHhiNwpbICAgIDIuMzkyMDYyXSAgWzw3OTAyYjU5Nz5dIG1vZF90aW1lcisw
eDVkLzB4NmMKWyAgICAyLjM5MjA2Ml0gIFs8NzkwMmI1Yjg+XSBhZGRfdGltZXIrMHgxMi8w
eDE0ClsgICAgMi4zOTIwNjJdICBbPDc5MDM1MGVmPl0gX19xdWV1ZV9kZWxheWVkX3dvcmsr
MHhjYS8weGU0ClsgICAgMi4zOTIwNjJdICBbPDc5MDM1MTRiPl0gcXVldWVfZGVsYXllZF93
b3JrX29uKzB4NDIvMHg3MQpbICAgIDIuMzkyMDYyXSAgWzw3OTFkYmZjNz5dIGtvYmplY3Rf
cmVsZWFzZSsweDZhLzB4NzIKWyAgICAyLjM5MjA2Ml0gIFs8NzkxZGMwMTA+XSBrb2JqZWN0
X3B1dCsweDQxLzB4NDYKWyAgICAyLjM5MjA2Ml0gIFs8NzkxZGMwN2E+XSBrb2JqZWN0X2Rl
bCsweDI1LzB4MmYKWyAgICAyLjM5MjA2Ml0gIFs8NzkzMmI0MDQ+XSBkZXZpY2VfZGVsKzB4
MTMyLzB4MTNlClsgICAgMi4zOTIwNjJdICBbPDc5MzJiNDFiPl0gZGV2aWNlX3VucmVnaXN0
ZXIrMHhiLzB4MTUKWyAgICAyLjM5MjA2Ml0gIFs8NzkzMmI0Nzc+XSBkZXZpY2VfZGVzdHJv
eSsweDJjLzB4MzEKWyAgICAyLjM5MjA2Ml0gIFs8NzkyODgyNzE+XSB0dHlfdW5yZWdpc3Rl
cl9kZXZpY2UrMHgxZi8weDM3ClsgICAgMi4zOTIwNjJdICBbPDc5Mjk0N2UyPl0gdWFydF9y
ZW1vdmVfb25lX3BvcnQrMHg5YS8weGU0ClsgICAgMi4zOTIwNjJdICBbPDc5Mjk2ZTQyPl0g
c2VyaWFsODI1MF9yZWdpc3Rlcl84MjUwX3BvcnQrMHhjMS8weDIzNQpbICAgIDIuMzkyMDYy
XSAgWzw3OTI5NzE2NT5dIHNlcmlhbDgyNTBfcHJvYmUrMHhmYy8weDE0MgpbICAgIDIuMzky
MDYyXSAgWzw3OTMyZWE5Yz5dIHBsYXRmb3JtX2Rydl9wcm9iZSsweDI5LzB4NGIKWyAgICAy
LjM5MjA2Ml0gIFs8NzkzMmRhMzM+XSBkcml2ZXJfcHJvYmVfZGV2aWNlKzB4ODgvMHgxN2IK
WyAgICAyLjM5MjA2Ml0gIFs8NzkzMmRiNDI+XSBfX2RldmljZV9hdHRhY2grMHgxYy8weDJj
ClsgICAgMi4zOTIwNjJdICBbPDc5MzJjNWVkPl0gYnVzX2Zvcl9lYWNoX2RydisweDM4LzB4
NmIKWyAgICAyLjM5MjA2Ml0gIFs8NzkzMmQ5NzI+XSBkZXZpY2VfYXR0YWNoKzB4NjMvMHg4
MwpbICAgIDIuMzkyMDYyXSAgWzw3OTMyZGIyNj5dID8gZHJpdmVyX3Byb2JlX2RldmljZSsw
eDE3Yi8weDE3YgpbICAgIDIuMzkyMDYyXSAgWzw3OTMyZDE0OT5dIGJ1c19wcm9iZV9kZXZp
Y2UrMHgyNS8weDg0ClsgICAgMi4zOTIwNjJdICBbPDc5MzJiYjc4Pl0gZGV2aWNlX2FkZCsw
eDNhYy8weDU1OQpbICAgIDIuMzkyMDYyXSAgWzw3OTFkYzRkMT5dID8ga29iamVjdF9zZXRf
bmFtZV92YXJncysweDNkLzB4NGEKWyAgICAyLjM5MjA2Ml0gIFs8NzkzMmFiNzQ+XSA/IGRl
dl9zZXRfbmFtZSsweDE0LzB4MTYKWyAgICAyLjM5MjA2Ml0gIFs8NzkzMmU4ZmU+XSBwbGF0
Zm9ybV9kZXZpY2VfYWRkKzB4MTBmLzB4MTczClsgICAgMi4zOTIwNjJdICBbPDc5MzJlZGI1
Pl0gcGxhdGZvcm1fZGV2aWNlX3JlZ2lzdGVyKzB4MWMvMHgxZgpbICAgIDIuMzkyMDYyXSAg
Wzw3OTg4MGYyZj5dID8gc2V0dXBfZWFybHlfc2VyaWFsODI1MF9jb25zb2xlKzB4MzVhLzB4
MzVhClsgICAgMi4zOTIwNjJdICBbPDc5ODgwZjNjPl0gZm91cnBvcnRfaW5pdCsweGQvMHhm
ClsgICAgMi4zOTIwNjJdICBbPDc5MDAwM2RhPl0gZG9fb25lX2luaXRjYWxsKzB4NmIvMHhl
YwpbICAgIDIuMzkyMDYyXSAgWzw3OTg2NDQwMD5dID8gZG9fZWFybHlfcGFyYW0rMHg2Mi8w
eDc1ClsgICAgMi4zOTIwNjJdICBbPDc5MDM3YjMwPl0gPyBwYXJzZV9hcmdzKzB4MTZkLzB4
MjBlClsgICAgMi4zOTIwNjJdICBbPDc5ODY0OWZjPl0ga2VybmVsX2luaXRfZnJlZWFibGUr
MHhkOC8weDE1ZApbICAgIDIuMzkyMDYyXSAgWzw3OTUwZGE3Yz5dIGtlcm5lbF9pbml0KzB4
OC8weGI0ClsgICAgMi4zOTIwNjJdICBbPDc5NTFmNWI3Pl0gcmV0X2Zyb21fa2VybmVsX3Ro
cmVhZCsweDFiLzB4MjgKWyAgICAyLjM5MjA2Ml0gIFs8Nzk1MGRhNzQ+XSA/IHJlc3RfaW5p
dCsweDExOC8weDExOApbICAgIDIuMzkyMDYyXSAtLS1bIGVuZCB0cmFjZSBiNzQ4NThlNmRj
Yjk3MzQ3IF0tLS0KL2tlcm5lbC9pMzg2LXJhbmRjb25maWctajQtMDgyNzEwNTYvYzgxN2E2
N2VjYmE3YzNjMmFhYTEwNDc5NmQ3OGYxNjBhZjYwOTIwZC9kbWVzZy1rdm0td2FpbWVhLTI3
MjEyLTIwMTMwODI4MDkzOTQwLTMuMTEuMC1yYzItMDAwMTAtZ2M4MTdhNjctMjg5CgpjODE3
YTY3ZWNiYTdjM2MyYWFhMTA0Nzk2ZDc4ZjE2MGFmNjA5MjBkIGlzIHRoZSBmaXJzdCBiYWQg
Y29tbWl0CmNvbW1pdCBjODE3YTY3ZWNiYTdjM2MyYWFhMTA0Nzk2ZDc4ZjE2MGFmNjA5MjBk
CkF1dGhvcjogUnVzc2VsbCBLaW5nIDxybWsra2VybmVsQGFybS5saW51eC5vcmcudWs+CkRh
dGU6ICAgVGh1IEp1biAyNyAxNTowNjoxNCAyMDEzICswMTAwCgogICAga29iamVjdDogZGVs
YXllZCBrb2JqZWN0IHJlbGVhc2U6IGhlbHAgZmluZCBidWdneSBkcml2ZXJzCiAgICAKICAg
IEltcGxlbWVudCBkZWJ1Z2dpbmcgZm9yIGtvYmplY3QgcmVsZWFzZSBmdW5jdGlvbnMuICBr
b2JqZWN0cyBhcmUKICAgIHJlZmVyZW5jZSBjb3VudGVkLCBzbyB0aGUgZHJvcCBvZiB0aGUg
bGFzdCByZWZlcmVuY2UgdG8gdGhlbSBpcyBub3QKICAgIHByZWRpY3RhYmxlLiBIb3dldmVy
LCB0aGUgY29tbW9uIGNhc2UgaXMgZm9yIHRoZSBsYXN0IHJlZmVyZW5jZSB0byBiZQogICAg
dGhlIGtvYmplY3QncyByZW1vdmFsIGZyb20gYSBzdWJzeXN0ZW0sIHdoaWNoIHJlc3VsdHMg
aW4gdGhlIHJlbGVhc2UKICAgIGZ1bmN0aW9uIGJlaW5nIGltbWVkaWF0ZWx5IGNhbGxlZC4K
ICAgIAogICAgVGhpcyBjYW4gaGlkZSBzdWJ0bGUgYnVncywgd2hpY2ggY2FuIG9jY3VyIHdo
ZW4gYW5vdGhlciB0aHJlYWQgaG9sZHMgYQogICAgcmVmZXJlbmNlIHRvIHRoZSBrb2JqZWN0
IGF0IHRoZSBzYW1lIHRpbWUgdGhhdCBhIGtvYmplY3QgaXMgcmVtb3ZlZC4KICAgIFRoaXMg
cmVzdWx0cyBpbiB0aGUgcmVsZWFzZSBtZXRob2QgYmVpbmcgZGVsYXllZC4KICAgIAogICAg
SW4gb3JkZXIgdG8gbWFrZSB0aGVzZSBraW5kcyBvZiBwcm9ibGVtcyBtb3JlIHZpc2libGUs
IHRoZSBmb2xsb3dpbmcKICAgIHBhdGNoIGltcGxlbWVudHMgYSBkZWxheWVkIHJlbGVhc2U7
IHRoaXMgaGFzIHRoZSBlZmZlY3QgdGhhdCB0aGUKICAgIHJlbGVhc2UgZnVuY3Rpb24gd2ls
bCBiZSBvdXQgb2Ygb3JkZXIgd2l0aCByZXNwZWN0IHRvIHRoZSByZW1vdmFsIG9mCiAgICB0
aGUga29iamVjdCBpbiB0aGUgc2FtZSBtYW5uZXIgdGhhdCBpdCB3b3VsZCBiZSBpZiBhIHJl
ZmVyZW5jZSB3YXMKICAgIGJlaW5nIGhlbGQuCiAgICAKICAgIFRoaXMgcHJvdmlkZXMgdXMg
d2l0aCBhbiBlYXN5IHdheSB0byBhbGxvdyBkcml2ZXIgd3JpdGVycyB0byBkZWJ1ZwogICAg
dGhlaXIgZHJpdmVycyBhbmQgZml4IG90aGVyd2lzZSBoaWRkZW4gcHJvYmxlbXMuCiAgICAK
ICAgIFNpZ25lZC1vZmYtYnk6IFJ1c3NlbGwgS2luZyA8cm1rK2tlcm5lbEBhcm0ubGludXgu
b3JnLnVrPgogICAgU2lnbmVkLW9mZi1ieTogR3JlZyBLcm9haC1IYXJ0bWFuIDxncmVna2hA
bGludXhmb3VuZGF0aW9uLm9yZz4KCjowNDAwMDAgMDQwMDAwIGY2YzIzZWZhMTAyZmMyYzJl
YWQ1Yzg2YmRiNjVhYTcwNzE5YjFhYjkgMDQ5ODU5ZmE3YTNhOTUzODkyMTI3NDY3YmFiYmYw
MmY2NmE2OWI3NiBNCWluY2x1ZGUKOjA0MDAwMCAwNDAwMDAgYTQxZDIwNjY5ZjBmNjI0ZDJj
ZTljYTdlNmE1Zjk2ZTRmOTE0MzJlMCBiZjIxNjgxOTRmODI5MTFjZjJlMTg5MmQ4MmYwYzEz
ZDAwYzc3MmFlIE0JbGliCmJpc2VjdCBydW4gc3VjY2VzcwpscyAtYSAva2VybmVsLXRlc3Rz
L3J1bi1xdWV1ZS9rdm0vaTM4Ni1yYW5kY29uZmlnLWo0LTA4MjcxMDU2L25leHQ6bWFzdGVy
OjdjNDI3MjFmZTBjNThhODQ4ODQ5YjQzZmY1NThjZjJmYjg2YWEzNWE6YmlzZWN0LXNvdW5k
CgoyMDEzLTA4LTI4LTA5OjQwOjE1IDdjNDI3MjFmZTBjNThhODQ4ODQ5YjQzZmY1NThjZjJm
Yjg2YWEzNWEgcmV1c2UgL2tlcm5lbC9pMzg2LXJhbmRjb25maWctajQtMDgyNzEwNTYvN2M0
MjcyMWZlMGM1OGE4NDg4NDliNDNmZjU1OGNmMmZiODZhYTM1YS92bWxpbnV6LTMuMTEuMC1y
YzItMDAwMDktZzdjNDI3MjEKCjIwMTMtMDgtMjgtMDk6NDA6MTUgZGV0ZWN0aW5nIGJvb3Qg
c3RhdGUgLi4uLi4uLi4JNTYJNTcJNTkJNjEJNjIJNjUJNjYuCTY4Lgk3NC4uLi4uCTc2CTc3
Li4JNzgJODAJODEJODIJODYuCTg3CTg4CTg5Li4uCTkxCTkyLi4uCTkzLgk5NAk5NS4JOTYu
Li4uLi4JOTgJMTAwCTEwMQkxMDIJMTA0CTEwNQkxMDcJMTA4CTEwOS4uLi4uCTExMAkxMTEJ
MTEzCTExNAkxMTYJMTI1CTEzMQkxNDEJMTU0CTE1OAkxNjAJMTYxCTE2My4JMTY0Li4uLi4u
Li4uCTE2NSBTVUNDRVNTCgpscyAtYSAva2VybmVsLXRlc3RzL3J1bi1xdWV1ZS9rdm0vaTM4
Ni1yYW5kY29uZmlnLWo0LTA4MjcxMDU2L25leHQ6bWFzdGVyOjI0NWYwODY5OWQ1MzIwZjAy
MTA3MGVkODY5OGFjODllYmYyZjA2NzA6YmlzZWN0LXNvdW5kCiBURVNUIEZBSUxVUkUKWyAg
IDg0Ljk5MDQ1OF0gcmJ0cmVlIHRlc3RpbmcgLT4gODA0MTg4IGN5Y2xlcwpbICAxMTEuNTY1
Nzg0XSBhdWdtZW50ZWQgcmJ0cmVlIHRlc3RpbmcKWyAgMTEyLjI2ODYzNF0gSU5GTzogcmN1
X3NjaGVkIGRldGVjdGVkIHN0YWxscyBvbiBDUFVzL3Rhc2tzOgpbICAxMTIuMjY4NjM0XSAK
L2tlcm5lbC9pMzg2LXJhbmRjb25maWctajQtMDgyNzEwNTYvMjQ1ZjA4Njk5ZDUzMjBmMDIx
MDcwZWQ4Njk4YWM4OWViZjJmMDY3MC9kbWVzZy1rdm0tYmVucy0zNzczLTIwMTMwODI3MTMz
NzA2LTMuMTEuMC1yYzctMDE3NTMtZ2YzMTAxOGMtMjYwCi9rZXJuZWwvaTM4Ni1yYW5kY29u
ZmlnLWo0LTA4MjcxMDU2LzI0NWYwODY5OWQ1MzIwZjAyMTA3MGVkODY5OGFjODllYmYyZjA2
NzAvZG1lc2cta3ZtLWJlbnMtNDExNy0yMDEzMDgyNzEzMTUxNi0zLjExLjAtcmM3LTAwNzM5
LWczMDAyNTQ0LTEyMwova2VybmVsL2kzODYtcmFuZGNvbmZpZy1qNC0wODI3MTA1Ni8yNDVm
MDg2OTlkNTMyMGYwMjEwNzBlZDg2OThhYzg5ZWJmMmYwNjcwL2RtZXNnLWt2bS1iZW5zLTQx
OTgtMjAxMzA4MjcxMzMyMTItMy4xMS4wLXJjNy0wMTYzNi1nN2NhNDJkMi0yNTkKL2tlcm5l
bC9pMzg2LXJhbmRjb25maWctajQtMDgyNzEwNTYvMjQ1ZjA4Njk5ZDUzMjBmMDIxMDcwZWQ4
Njk4YWM4OWViZjJmMDY3MC9kbWVzZy1rdm0tY2Fpcm8tMTcxODUtMjAxMzA4MjcxMzM4MTgt
My4xMS4wLXJjNS0wMDAyNy1nYzQ5YTA4OS0yMTAKL2tlcm5lbC9pMzg2LXJhbmRjb25maWct
ajQtMDgyNzEwNTYvMjQ1ZjA4Njk5ZDUzMjBmMDIxMDcwZWQ4Njk4YWM4OWViZjJmMDY3MC9k
bWVzZy1rdm0tY2Fpcm8tMTczNzAtMjAxMzA4MjcxMzM5MDctMy4xMS4wLXJjNy0wMDczMi1n
ZTZlZDk1Mi04Nwova2VybmVsL2kzODYtcmFuZGNvbmZpZy1qNC0wODI3MTA1Ni8yNDVmMDg2
OTlkNTMyMGYwMjEwNzBlZDg2OThhYzg5ZWJmMmYwNjcwL2RtZXNnLWt2bS1jYWlyby0xOTAx
OC0yMDEzMDgyNzEzMzk1NC0zLjExLjAtcmM3LXdsLTAyMTA0LWc0NGQ1MmFiLTEyOAova2Vy
bmVsL2kzODYtcmFuZGNvbmZpZy1qNC0wODI3MTA1Ni8yNDVmMDg2OTlkNTMyMGYwMjEwNzBl
ZDg2OThhYzg5ZWJmMmYwNjcwL2RtZXNnLWt2bS1jYWlyby01NTMzLTIwMTMwODI3MTMwMTEw
LTMuMTEuMC1yYzctMDA3MzItZ2U2ZWQ5NTItODcKL2tlcm5lbC9pMzg2LXJhbmRjb25maWct
ajQtMDgyNzEwNTYvMjQ1ZjA4Njk5ZDUzMjBmMDIxMDcwZWQ4Njk4YWM4OWViZjJmMDY3MC9k
bWVzZy1rdm0tc3RvYWtsZXktNDA4My0yMDEzMDgyNzEzMjk1Ny0zLjExLjAtcmM3LTAxNzUz
LWdmMzEwMThjLTI4OQova2VybmVsL2kzODYtcmFuZGNvbmZpZy1qNC0wODI3MTA1Ni8yNDVm
MDg2OTlkNTMyMGYwMjEwNzBlZDg2OThhYzg5ZWJmMmYwNjcwL2RtZXNnLWt2bS13YWltZWEt
ODg5OS0yMDEzMDgyNzEzMjQ0MS0zLjExLjAtcmM3LTAxNjM2LWc3Y2E0MmQyLTI1OAova2Vy
bmVsL2kzODYtcmFuZGNvbmZpZy1qNC0wODI3MTA1Ni8yNDVmMDg2OTlkNTMyMGYwMjEwNzBl
ZDg2OThhYzg5ZWJmMmYwNjcwL2RtZXNnLWt2bS13YWltZWEtOTM0My0yMDEzMDgyNzEzMjM1
My0zLjExLjAtcmM3LXdsLTAyMTA0LWcxN2U0NDUxLTI1OAova2VybmVsL2kzODYtcmFuZGNv
bmZpZy1qNC0wODI3MTA1Ni8yNDVmMDg2OTlkNTMyMGYwMjEwNzBlZDg2OThhYzg5ZWJmMmYw
NjcwL2RtZXNnLWt2bS14aWFuLTY0NjA2LTIwMTMwODI3MTMxNTAzLTMuMTAuMC1yYzMtMDA3
MDAtZzc3NTM5OWEtNTAKCltkZXRhY2hlZCBIRUFEIDRiZDU5NTBdIFJldmVydCAia29iamVj
dDogZGVsYXllZCBrb2JqZWN0IHJlbGVhc2U6IGhlbHAgZmluZCBidWdneSBkcml2ZXJzIgog
MyBmaWxlcyBjaGFuZ2VkLCAzIGluc2VydGlvbnMoKyksIDQyIGRlbGV0aW9ucygtKQpscyAt
YSAva2VybmVsLXRlc3RzL3J1bi1xdWV1ZS9rdm0vaTM4Ni1yYW5kY29uZmlnLWo0LTA4Mjcx
MDU2L25leHQ6bWFzdGVyOjRiZDU5NTAyODBlNDI3OGM3ZjEwNzI2YTUzYmRjOWI2YWQ4ZGNk
MzI6YmlzZWN0LXNvdW5kCgoyMDEzLTA4LTI4LTEwOjI4OjI1IDRiZDU5NTAyODBlNDI3OGM3
ZjEwNzI2YTUzYmRjOWI2YWQ4ZGNkMzIgY29tcGlsaW5nCgoyMDEzLTA4LTI4LTEwOjMzOjQ4
IGRldGVjdGluZyBib290IHN0YXRlIDMuMTEuMC1yYzYtbmV4dC0yMDEzMDgyMi0wNzg1OC1n
NGJkNTk1MC4uCTUuCTgJOS4JMTAuLi4JMTEJMTIuLgkxMy4uLi4uCTE1CTE3CTE5CTIwLgky
MwkyNwkyOQkzMS4uLgkzMi4uLi4uCTMzLi4JMzUJMzYJMzcJMzgJNDAuLi4uCTQyCTQ0Li4u
CTQ3CTUwLgk1NQk1OQk2MQk2Mi4JNjMJNjQJNjUJNjkJNzAJNzIJNzYuLgk3Ny4JNzkJODAu
CTgxCTgzLi4uCTg3Lgk4OAk5MQk5NAk5NQk5Ngk5OAk5OQkxMDAJMTAzCTEwNgkxMDgJMTEw
CTExMwkxMTQJMTE1Li4uCTEyMi4uCTEyNAkxMjUuLgkxMjcJMTMwLgkxMzMuLi4uLgkxMzYJ
MTQwLi4uCTE0MgkxNDMJMTQ2CTE0OAkxNDkJMTUzCTE1OC4uLgkxNTkuLi4uLi4uLi4JMTYw
Li4uLi4uLi4JMTYxLi4uCTE2MgkxNjMJMTY0Li4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4u
Li4uLi4uLi4uLi4uLi4uLi4uLgkxNjUgU1VDQ0VTUwoKCj09PT09PT09PSB1cHN0cmVhbSA9
PT09PT09PT0KRmV0Y2hpbmcgbGludXMKbHMgLWEgL2tlcm5lbC10ZXN0cy9ydW4tcXVldWUv
a3ZtL2kzODYtcmFuZGNvbmZpZy1qNC0wODI3MTA1Ni9uZXh0Om1hc3RlcjpmYTgyMThkZWYx
YjFhMTZmMGE0MTBlMmMxYzc2N2I0NzM4Y2M4MWZhOmJpc2VjdC1zb3VuZAoKMjAxMy0wOC0y
OC0xMjoxNzoyNCBmYTgyMThkZWYxYjFhMTZmMGE0MTBlMmMxYzc2N2I0NzM4Y2M4MWZhIGNv
bXBpbGluZwoKMjAxMy0wOC0yOC0xMjoyMjozMCBkZXRlY3RpbmcgYm9vdCBzdGF0ZSAzLjEx
LjAtcmM3LTAwOTY4LWdmYTgyMThkLi4uLi4JMQkzLi4JNQk2CTExCTE0Li4uLi4uCTE1CTE2
CTE3CTE4CTE5LgkyMwkyNAkyNgkyNwkyOQkzMAkzMQkzMi4uCTMzCTM0LgkzNi4JMzkuLi4u
CTQwCTQxLi4JNDIuCTQzLgk0NAk0NS4uLgk0Ngk0OC4JNDkuCTUxCTUzLi4uLi4uLgk1NC4J
NTUuLi4JNTcuLi4JNTgJNjAuCTYyLi4uCTY4CTc2CTc5CTgyCTg3CTg5Li4JOTAJOTQJOTUJ
OTgJMTAxCTEwMwkxMTAJMTE3CTExOQkxMjAJMTIxCTEyMi4JMTIzCTEyNwkxMjguLi4uLi4u
LgkxMzMJMTM0CTEzNQkxMzYJMTQyLi4uCTE0NAkxNDYuCTE0Ny4JMTQ5CTE1MAkxNTEJMTUz
Li4uCTE1NS4uLgkxNTYJMTU4LgkxNTkJMTYxLi4uCTE2Mi4uLi4JMTYzLi4uLi4uLi4uCTE2
NC4uLi4uCTE2NSBTVUNDRVNTCgoKPT09PT09PT09IGxpbnV4LW5leHQgPT09PT09PT09CkZl
dGNoaW5nIG5leHQKbHMgLWEgL2tlcm5lbC10ZXN0cy9ydW4tcXVldWUva3ZtL2kzODYtcmFu
ZGNvbmZpZy1qNC0wODI3MTA1Ni9uZXh0Om1hc3RlcjplNGE3NDVmOTUxOWVmMmJiYjlkNzUy
MTJhZTFjY2E3NTgyZDc2MjY2OmJpc2VjdC1zb3VuZAoKMjAxMy0wOC0yOC0xMzo1MTowNCBl
NGE3NDVmOTUxOWVmMmJiYjlkNzUyMTJhZTFjY2E3NTgyZDc2MjY2IGNvbXBpbGluZwoKMjAx
My0wOC0yOC0xMzo1Njo1NyBkZXRlY3RpbmcgYm9vdCBzdGF0ZSAzLjExLjAtcmM3LW5leHQt
MjAxMzA4MjctMDg4OTQtZ2U0YTc0NWYuLi4uLi4JMS4uLgkyLiBURVNUIEZBSUxVUkUKWyAg
ICA0LjQ3MzMyN10gV0FSTklORzogQ1BVOiAxIFBJRDogMSBhdCAvYy93Zmcvc291bmQvbGli
L2xpc3RfZGVidWcuYzozMyBfX2xpc3RfYWRkKzB4NDQvMHg3OCgpClsgICAgNC40NzQ1MTNd
IGxpc3RfYWRkIGNvcnJ1cHRpb24uIHByZXYtPm5leHQgc2hvdWxkIGJlIG5leHQgKDc4MDIy
MjQwKSwgYnV0IHdhcyAgIChudWxsKS4gKHByZXY9ODdiMzljZTgpLgpbICAgIDQuNDc1OTI5
XSBNb2R1bGVzIGxpbmtlZCBpbjoKWyAgICA0LjQ3NjExMl0gQ1BVOiAxIFBJRDogMSBDb21t
OiBzd2FwcGVyLzAgTm90IHRhaW50ZWQgMy4xMS4wLXJjNy1uZXh0LTIwMTMwODI3LTA4ODk0
LWdlNGE3NDVmICMyOTIKWyAgICA0LjQ3NjExMl0gIDAwMDAwMDAwIDAwMDAwMDAwIDc4MDQ5
YjdjIDc5NTFlMmExIDc5NzI0NTUxIDc4MDQ5Yjk0IDc5MDIyYzc4IDc5MWZiODAxClsgICAg
NC40NzYxMTJdICA4N2IzOWNlOCA3ODAyMjI0MCA4N2I2MGM0OCA3ODA0OWJhYyA3OTAyMmNi
NSAwMDAwMDAwOSA3ODA0OWJhNCA3OTcyNDU1MQpbICAgIDQuNDc2MTEyXSAgNzgwNDliYzAg
NzgwNDliZDggNzkxZmI4MDEgNzk3MjQ1MzMgMDAwMDAwMjEgNzk3MjQ1NTEgNzgwMjIyNDAg
MDAwMDAwMDAKWyAgICA0LjQ3NjExMl0gQ2FsbCBUcmFjZToKWyAgICA0LjQ3NjExMl0gIFs8
Nzk1MWUyYTE+XSBkdW1wX3N0YWNrKzB4NGIvMHg2NgpbICAgIDQuNDc2MTEyXSAgWzw3OTAy
MmM3OD5dIHdhcm5fc2xvd3BhdGhfY29tbW9uKzB4NWMvMHg3MwpbICAgIDQuNDc2MTEyXSAg
Wzw3OTFmYjgwMT5dID8gX19saXN0X2FkZCsweDQ0LzB4NzgKWyAgICA0LjQ3NjExMl0gIFs8
NzkwMjJjYjU+XSB3YXJuX3Nsb3dwYXRoX2ZtdCsweDI2LzB4MmEKWyAgICA0LjQ3NjExMl0g
IFs8NzkxZmI4MDE+XSBfX2xpc3RfYWRkKzB4NDQvMHg3OApbICAgIDQuNDc2MTEyXSAgWzw3
OTAyOGJlOD5dIF9faW50ZXJuYWxfYWRkX3RpbWVyKzB4OTcvMHg5YgpbICAgIDQuNDc2MTEy
XSAgWzw3OTAyOGJmYT5dIGludGVybmFsX2FkZF90aW1lcisweGUvMHgyNgpbICAgIDQuNDc2
MTEyXSAgWzw3OTAyOGU0Mz5dIF9fbW9kX3RpbWVyKzB4YTIvMHhiNwpbICAgIDQuNDc2MTEy
XSAgWzw3OTAyOGY2Yj5dIG1vZF90aW1lcisweDVkLzB4NmMKWyAgICA0LjQ3NjExMl0gIFs8
NzkwMjhmOGM+XSBhZGRfdGltZXIrMHgxMi8weDE0ClsgICAgNC40NzYxMTJdICBbPDc5MDMw
ZWU1Pl0gX19xdWV1ZV9kZWxheWVkX3dvcmsrMHhjYS8weGU0ClsgICAgNC40NzYxMTJdICBb
PDc5MDMyMzkxPl0gcXVldWVfZGVsYXllZF93b3JrX29uKzB4NDIvMHg3MQpbICAgIDQuNDc2
MTEyXSAgWzw3OTFlMmI5Yj5dIGtvYmplY3RfcmVsZWFzZSsweDZhLzB4NzIKWyAgICA0LjQ3
NjExMl0gIFs8NzkxZTJiZTQ+XSBrb2JqZWN0X3B1dCsweDQxLzB4NDYKWyAgICA0LjQ3NjEx
Ml0gIFs8NzkxZTJjNGU+XSBrb2JqZWN0X2RlbCsweDI1LzB4MmYKWyAgICA0LjQ3NjExMl0g
IFs8NzkzMzIzYTg+XSBkZXZpY2VfZGVsKzB4MTMyLzB4MTNlClsgICAgNC40NzYxMTJdICBb
PDc5MzMyM2JmPl0gZGV2aWNlX3VucmVnaXN0ZXIrMHhiLzB4MTUKWyAgICA0LjQ3NjExMl0g
IFs8NzkzMzI0MWI+XSBkZXZpY2VfZGVzdHJveSsweDJjLzB4MzEKWyAgICA0LjQ3NjExMl0g
IFs8NzkyOGY2YTQ+XSB0dHlfdW5yZWdpc3Rlcl9kZXZpY2UrMHgxZi8weDM3ClsgICAgNC40
NzYxMTJdICBbPDc5MjliYjVjPl0gdWFydF9yZW1vdmVfb25lX3BvcnQrMHg5YS8weGU3Clsg
ICAgNC40NzYxMTJdICBbPDc5MjllMWUyPl0gc2VyaWFsODI1MF9yZWdpc3Rlcl84MjUwX3Bv
cnQrMHhjMS8weDIzNQpbICAgIDQuNDc2MTEyXSAgWzw3OTI5ZTUwNT5dIHNlcmlhbDgyNTBf
cHJvYmUrMHhmYy8weDE0MgpbICAgIDQuNDc2MTEyXSAgWzw3OTMzNWFkNj5dIHBsYXRmb3Jt
X2Rydl9wcm9iZSsweDI5LzB4NGIKWyAgICA0LjQ3NjExMl0gIFs8NzkzMzRhOTQ+XSBkcml2
ZXJfcHJvYmVfZGV2aWNlKzB4ODgvMHgxN2IKWyAgICA0LjQ3NjExMl0gIFs8NzkzMzRiYTM+
XSBfX2RldmljZV9hdHRhY2grMHgxYy8weDJjClsgICAgNC40NzYxMTJdICBbPDc5MzMzNWQ5
Pl0gYnVzX2Zvcl9lYWNoX2RydisweDM4LzB4NmIKWyAgICA0LjQ3NjExMl0gIFs8NzkzMzQ5
ZDM+XSBkZXZpY2VfYXR0YWNoKzB4NjMvMHg4MwpbICAgIDQuNDc2MTEyXSAgWzw3OTMzNGI4
Nz5dID8gZHJpdmVyX3Byb2JlX2RldmljZSsweDE3Yi8weDE3YgpbICAgIDQuNDc2MTEyXSAg
Wzw3OTMzNDE2Nz5dIGJ1c19wcm9iZV9kZXZpY2UrMHgyNS8weDg0ClsgICAgNC40NzYxMTJd
ICBbPDc5MzMyYjNhPl0gZGV2aWNlX2FkZCsweDNiMC8weDU1ZQpbICAgIDQuNDc2MTEyXSAg
Wzw3OTFlMzBhNT5dID8ga29iamVjdF9zZXRfbmFtZV92YXJncysweDNkLzB4NGEKWyAgICA0
LjQ3NjExMl0gIFs8NzkzMzFiZWI+XSA/IGRldl9zZXRfbmFtZSsweDE0LzB4MTYKWyAgICA0
LjQ3NjExMl0gIFs8NzkzMzU5Mzg+XSBwbGF0Zm9ybV9kZXZpY2VfYWRkKzB4MTBmLzB4MTcz
ClsgICAgNC40NzYxMTJdICBbPDc5MzM1ZGVmPl0gcGxhdGZvcm1fZGV2aWNlX3JlZ2lzdGVy
KzB4MWMvMHgxZgpbICAgIDQuNDc2MTEyXSAgWzw3OTg5MDA2MT5dID8gc2V0dXBfZWFybHlf
c2VyaWFsODI1MF9jb25zb2xlKzB4MzVkLzB4MzVkClsgICAgNC40NzYxMTJdICBbPDc5ODkw
MDZlPl0gZm91cnBvcnRfaW5pdCsweGQvMHhmClsgICAgNC40NzYxMTJdICBbPDc5MDAwM2Rh
Pl0gZG9fb25lX2luaXRjYWxsKzB4NmIvMHhlYwpbICAgIDQuNDc2MTEyXSAgWzw3OTg3MzQw
MD5dID8gZG9fZWFybHlfcGFyYW0rMHg2Mi8weDc1ClsgICAgNC40NzYxMTJdICBbPDc5MDM1
NWU4Pl0gPyBwYXJzZV9hcmdzKzB4MTZhLzB4MjBiClsgICAgNC40NzYxMTJdICBbPDc5ODcz
OWZjPl0ga2VybmVsX2luaXRfZnJlZWFibGUrMHhkOC8weDE1ZApbICAgIDQuNDc2MTEyXSAg
Wzw3OTUxOGEwYz5dIGtlcm5lbF9pbml0KzB4OC8weGI0ClsgICAgNC40NzYxMTJdICBbPDc5
NTJhODc3Pl0gcmV0X2Zyb21fa2VybmVsX3RocmVhZCsweDFiLzB4MjgKWyAgICA0LjQ3NjEx
Ml0gIFs8Nzk1MThhMDQ+XSA/IHJlc3RfaW5pdCsweDExOC8weDExOApbICAgIDQuNDc2MTEy
XSAtLS1bIGVuZCB0cmFjZSBhMDM4NWIzYmM5NTJmZmE0IF0tLS0KL2tlcm5lbC9pMzg2LXJh
bmRjb25maWctajQtMDgyNzEwNTYvZTRhNzQ1Zjk1MTllZjJiYmI5ZDc1MjEyYWUxY2NhNzU4
MmQ3NjI2Ni9kbWVzZy1rdm0td2FpbWVhLTI3MjEyLTIwMTMwODI4MTQwMjAyLTMuMTEuMC1y
YzItMDAyMjYtZzQzMDU0ZWMtNQoK

--VbJkn9YxBvnuCH5J
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="config-3.11.0-rc6-next-20130822-07070-g245f086"

#
# Automatically generated file; DO NOT EDIT.
# Linux/i386 3.11.0-rc6 Kernel Configuration
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
CONFIG_X86_32_LAZY_GS=y
CONFIG_ARCH_HWEIGHT_CFLAGS="-fcall-saved-ecx -fcall-saved-edx"
CONFIG_ARCH_SUPPORTS_UPROBES=y
CONFIG_DEFCONFIG_LIST="/lib/modules/$UNAME_RELEASE/.config"
CONFIG_IRQ_WORK=y
CONFIG_BUILDTIME_EXTABLE_SORT=y

#
# General setup
#
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
CONFIG_KERNEL_BZIP2=y
# CONFIG_KERNEL_LZMA is not set
# CONFIG_KERNEL_XZ is not set
# CONFIG_KERNEL_LZO is not set
# CONFIG_KERNEL_LZ4 is not set
CONFIG_DEFAULT_HOSTNAME="(none)"
# CONFIG_SWAP is not set
CONFIG_SYSVIPC=y
CONFIG_POSIX_MQUEUE=y
CONFIG_FHANDLE=y
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
CONFIG_GENERIC_IRQ_CHIP=y
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
CONFIG_NO_HZ_COMMON=y
# CONFIG_HZ_PERIODIC is not set
CONFIG_NO_HZ_IDLE=y
CONFIG_NO_HZ=y
# CONFIG_HIGH_RES_TIMERS is not set

#
# CPU/Task time and stats accounting
#
# CONFIG_TICK_CPU_ACCOUNTING is not set
CONFIG_IRQ_TIME_ACCOUNTING=y
# CONFIG_BSD_PROCESS_ACCT is not set
CONFIG_TASKSTATS=y
CONFIG_TASK_DELAY_ACCT=y
CONFIG_TASK_XACCT=y
# CONFIG_TASK_IO_ACCOUNTING is not set

#
# RCU Subsystem
#
CONFIG_TREE_RCU=y
# CONFIG_PREEMPT_RCU is not set
CONFIG_RCU_STALL_COMMON=y
CONFIG_RCU_FANOUT=32
CONFIG_RCU_FANOUT_LEAF=16
# CONFIG_RCU_FANOUT_EXACT is not set
# CONFIG_RCU_FAST_NO_HZ is not set
# CONFIG_TREE_RCU_TRACE is not set
CONFIG_RCU_NOCB_CPU=y
# CONFIG_RCU_NOCB_CPU_NONE is not set
# CONFIG_RCU_NOCB_CPU_ZERO is not set
CONFIG_RCU_NOCB_CPU_ALL=y
CONFIG_IKCONFIG=y
CONFIG_LOG_BUF_SHIFT=17
CONFIG_HAVE_UNSTABLE_SCHED_CLOCK=y
CONFIG_ARCH_SUPPORTS_NUMA_BALANCING=y
CONFIG_ARCH_WANTS_PROT_NUMA_PROT_NONE=y
CONFIG_CGROUPS=y
# CONFIG_CGROUP_DEBUG is not set
# CONFIG_CGROUP_FREEZER is not set
# CONFIG_CGROUP_DEVICE is not set
# CONFIG_CPUSETS is not set
# CONFIG_CGROUP_CPUACCT is not set
CONFIG_RESOURCE_COUNTERS=y
CONFIG_MEMCG=y
# CONFIG_MEMCG_KMEM is not set
# CONFIG_CGROUP_HUGETLB is not set
# CONFIG_CGROUP_PERF is not set
CONFIG_CGROUP_SCHED=y
CONFIG_FAIR_GROUP_SCHED=y
CONFIG_CFS_BANDWIDTH=y
CONFIG_RT_GROUP_SCHED=y
# CONFIG_BLK_CGROUP is not set
# CONFIG_CHECKPOINT_RESTORE is not set
# CONFIG_NAMESPACES is not set
CONFIG_UIDGID_STRICT_TYPE_CHECKS=y
CONFIG_SCHED_AUTOGROUP=y
CONFIG_MM_OWNER=y
# CONFIG_SYSFS_DEPRECATED is not set
# CONFIG_RELAY is not set
CONFIG_BLK_DEV_INITRD=y
CONFIG_INITRAMFS_SOURCE=""
CONFIG_RD_GZIP=y
# CONFIG_RD_BZIP2 is not set
# CONFIG_RD_LZMA is not set
# CONFIG_RD_XZ is not set
# CONFIG_RD_LZO is not set
# CONFIG_RD_LZ4 is not set
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
# CONFIG_BASE_FULL is not set
CONFIG_FUTEX=y
# CONFIG_EPOLL is not set
CONFIG_SIGNALFD=y
CONFIG_TIMERFD=y
CONFIG_EVENTFD=y
# CONFIG_SHMEM is not set
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
# CONFIG_VM_EVENT_COUNTERS is not set
CONFIG_SLUB_DEBUG=y
# CONFIG_COMPAT_BRK is not set
# CONFIG_SLAB is not set
CONFIG_SLUB=y
# CONFIG_SLOB is not set
# CONFIG_SLUB_CPU_PARTIAL is not set
CONFIG_PROFILING=y
# CONFIG_OPROFILE is not set
CONFIG_HAVE_OPROFILE=y
CONFIG_OPROFILE_NMI_TIMER=y
CONFIG_KPROBES=y
# CONFIG_JUMP_LABEL is not set
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
CONFIG_RT_MUTEXES=y
CONFIG_BASE_SMALL=1
CONFIG_MODULES=y
# CONFIG_MODULE_FORCE_LOAD is not set
CONFIG_MODULE_UNLOAD=y
# CONFIG_MODULE_FORCE_UNLOAD is not set
CONFIG_MODVERSIONS=y
CONFIG_MODULE_SRCVERSION_ALL=y
# CONFIG_MODULE_SIG is not set
CONFIG_STOP_MACHINE=y
CONFIG_BLOCK=y
# CONFIG_LBDAF is not set
CONFIG_BLK_DEV_BSG=y
CONFIG_BLK_DEV_BSGLIB=y
CONFIG_BLK_DEV_INTEGRITY=y
CONFIG_CMDLINE_PARSER=y

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
# CONFIG_IOSCHED_DEADLINE is not set
# CONFIG_IOSCHED_CFQ is not set
CONFIG_DEFAULT_NOOP=y
CONFIG_DEFAULT_IOSCHED="noop"
CONFIG_PADATA=y
CONFIG_UNINLINE_SPIN_UNLOCK=y
# CONFIG_FREEZER is not set

#
# Processor type and features
#
# CONFIG_ZONE_DMA is not set
CONFIG_SMP=y
CONFIG_X86_MPPARSE=y
# CONFIG_X86_BIGSMP is not set
# CONFIG_X86_EXTENDED_PLATFORM is not set
# CONFIG_X86_INTEL_LPSS is not set
# CONFIG_X86_32_IRIS is not set
# CONFIG_SCHED_OMIT_FRAME_POINTER is not set
CONFIG_HYPERVISOR_GUEST=y
CONFIG_PARAVIRT=y
# CONFIG_PARAVIRT_DEBUG is not set
# CONFIG_PARAVIRT_SPINLOCKS is not set
# CONFIG_XEN_PRIVILEGED_GUEST is not set
CONFIG_KVM_GUEST=y
# CONFIG_KVM_DEBUG_FS is not set
# CONFIG_LGUEST_GUEST is not set
# CONFIG_PARAVIRT_TIME_ACCOUNTING is not set
CONFIG_PARAVIRT_CLOCK=y
CONFIG_NO_BOOTMEM=y
# CONFIG_MEMTEST is not set
# CONFIG_M486 is not set
# CONFIG_M586 is not set
# CONFIG_M586TSC is not set
# CONFIG_M586MMX is not set
# CONFIG_M686 is not set
# CONFIG_MPENTIUMII is not set
# CONFIG_MPENTIUMIII is not set
# CONFIG_MPENTIUMM is not set
# CONFIG_MPENTIUM4 is not set
# CONFIG_MK6 is not set
# CONFIG_MK7 is not set
CONFIG_MK8=y
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
CONFIG_X86_CMOV=y
CONFIG_X86_MINIMUM_CPU_FAMILY=4
CONFIG_X86_DEBUGCTLMSR=y
CONFIG_PROCESSOR_SELECT=y
# CONFIG_CPU_SUP_INTEL is not set
# CONFIG_CPU_SUP_CYRIX_32 is not set
# CONFIG_CPU_SUP_AMD is not set
# CONFIG_CPU_SUP_CENTAUR is not set
CONFIG_CPU_SUP_TRANSMETA_32=y
# CONFIG_CPU_SUP_UMC_32 is not set
CONFIG_HPET_TIMER=y
# CONFIG_DMI is not set
CONFIG_NR_CPUS=8
CONFIG_SCHED_SMT=y
# CONFIG_SCHED_MC is not set
CONFIG_PREEMPT_NONE=y
# CONFIG_PREEMPT_VOLUNTARY is not set
# CONFIG_PREEMPT is not set
CONFIG_PREEMPT_COUNT=y
CONFIG_X86_LOCAL_APIC=y
CONFIG_X86_IO_APIC=y
# CONFIG_X86_REROUTE_FOR_BROKEN_BOOT_IRQS is not set
# CONFIG_X86_MCE is not set
CONFIG_VM86=y
CONFIG_TOSHIBA=y
CONFIG_I8K=y
CONFIG_X86_REBOOTFIXUPS=y
# CONFIG_MICROCODE is not set
# CONFIG_MICROCODE_INTEL_EARLY is not set
# CONFIG_MICROCODE_AMD_EARLY is not set
CONFIG_X86_MSR=m
CONFIG_X86_CPUID=m
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
# CONFIG_BALLOON_COMPACTION is not set
CONFIG_COMPACTION=y
CONFIG_MIGRATION=y
# CONFIG_PHYS_ADDR_T_64BIT is not set
CONFIG_ZONE_DMA_FLAG=0
# CONFIG_BOUNCE is not set
CONFIG_NEED_BOUNCE_POOL=y
CONFIG_VIRT_TO_BUS=y
# CONFIG_KSM is not set
CONFIG_DEFAULT_MMAP_MIN_ADDR=4096
CONFIG_TRANSPARENT_HUGEPAGE=y
CONFIG_TRANSPARENT_HUGEPAGE_ALWAYS=y
# CONFIG_TRANSPARENT_HUGEPAGE_MADVISE is not set
# CONFIG_CROSS_MEMORY_ATTACH is not set
# CONFIG_CLEANCACHE is not set
# CONFIG_ZBUD is not set
CONFIG_CMA=y
# CONFIG_CMA_DEBUG is not set
CONFIG_HIGHPTE=y
# CONFIG_X86_CHECK_BIOS_CORRUPTION is not set
CONFIG_X86_RESERVE_LOW=64
# CONFIG_MATH_EMULATION is not set
# CONFIG_MTRR is not set
CONFIG_ARCH_RANDOM=y
CONFIG_X86_SMAP=y
# CONFIG_EFI is not set
# CONFIG_SECCOMP is not set
# CONFIG_CC_STACKPROTECTOR is not set
# CONFIG_HZ_100 is not set
CONFIG_HZ_250=y
# CONFIG_HZ_300 is not set
# CONFIG_HZ_1000 is not set
CONFIG_HZ=250
# CONFIG_SCHED_HRTICK is not set
# CONFIG_KEXEC is not set
CONFIG_CRASH_DUMP=y
CONFIG_PHYSICAL_START=0x1000000
# CONFIG_RELOCATABLE is not set
CONFIG_PHYSICAL_ALIGN=0x1000000
# CONFIG_HOTPLUG_CPU is not set
# CONFIG_COMPAT_VDSO is not set
# CONFIG_CMDLINE_BOOL is not set
CONFIG_ARCH_ENABLE_MEMORY_HOTPLUG=y

#
# Power management and ACPI options
#
# CONFIG_SUSPEND is not set
CONFIG_PM_RUNTIME=y
CONFIG_PM=y
# CONFIG_PM_DEBUG is not set
# CONFIG_WQ_POWER_EFFICIENT_DEFAULT is not set
CONFIG_ACPI=y
# CONFIG_ACPI_EC_DEBUGFS is not set
CONFIG_ACPI_AC=y
# CONFIG_ACPI_BATTERY is not set
CONFIG_ACPI_BUTTON=m
CONFIG_ACPI_VIDEO=y
CONFIG_ACPI_FAN=m
CONFIG_ACPI_DOCK=y
CONFIG_ACPI_I2C=y
CONFIG_ACPI_PROCESSOR=y
CONFIG_ACPI_PROCESSOR_AGGREGATOR=y
CONFIG_ACPI_THERMAL=m
CONFIG_ACPI_CUSTOM_DSDT_FILE=""
# CONFIG_ACPI_CUSTOM_DSDT is not set
# CONFIG_ACPI_INITRD_TABLE_OVERRIDE is not set
CONFIG_ACPI_BLACKLIST_YEAR=0
# CONFIG_ACPI_DEBUG is not set
# CONFIG_ACPI_PCI_SLOT is not set
CONFIG_X86_PM_TIMER=y
# CONFIG_ACPI_CONTAINER is not set
CONFIG_ACPI_SBS=y
CONFIG_ACPI_HED=y
CONFIG_ACPI_CUSTOM_METHOD=y
CONFIG_ACPI_APEI=y
# CONFIG_ACPI_APEI_GHES is not set
# CONFIG_ACPI_APEI_EINJ is not set
# CONFIG_ACPI_APEI_ERST_DEBUG is not set
CONFIG_SFI=y

#
# CPU Frequency scaling
#
CONFIG_CPU_FREQ=y
CONFIG_CPU_FREQ_TABLE=y
CONFIG_CPU_FREQ_GOV_COMMON=y
CONFIG_CPU_FREQ_STAT=m
CONFIG_CPU_FREQ_STAT_DETAILS=y
# CONFIG_CPU_FREQ_DEFAULT_GOV_PERFORMANCE is not set
# CONFIG_CPU_FREQ_DEFAULT_GOV_POWERSAVE is not set
CONFIG_CPU_FREQ_DEFAULT_GOV_USERSPACE=y
# CONFIG_CPU_FREQ_DEFAULT_GOV_ONDEMAND is not set
# CONFIG_CPU_FREQ_DEFAULT_GOV_CONSERVATIVE is not set
# CONFIG_CPU_FREQ_GOV_PERFORMANCE is not set
# CONFIG_CPU_FREQ_GOV_POWERSAVE is not set
CONFIG_CPU_FREQ_GOV_USERSPACE=y
CONFIG_CPU_FREQ_GOV_ONDEMAND=m
# CONFIG_CPU_FREQ_GOV_CONSERVATIVE is not set

#
# x86 CPU frequency scaling drivers
#
# CONFIG_X86_INTEL_PSTATE is not set
CONFIG_X86_PCC_CPUFREQ=y
CONFIG_X86_ACPI_CPUFREQ=y
# CONFIG_X86_POWERNOW_K6 is not set
# CONFIG_X86_POWERNOW_K7 is not set
CONFIG_X86_POWERNOW_K8=m
# CONFIG_X86_GX_SUSPMOD is not set
CONFIG_X86_SPEEDSTEP_CENTRINO=m
CONFIG_X86_SPEEDSTEP_CENTRINO_TABLE=y
CONFIG_X86_SPEEDSTEP_ICH=y
CONFIG_X86_SPEEDSTEP_SMI=y
CONFIG_X86_P4_CLOCKMOD=y
CONFIG_X86_CPUFREQ_NFORCE2=m
# CONFIG_X86_LONGRUN is not set
# CONFIG_X86_LONGHAUL is not set
CONFIG_X86_E_POWERSAVER=m

#
# shared options
#
CONFIG_X86_SPEEDSTEP_LIB=y
CONFIG_X86_SPEEDSTEP_RELAXED_CAP_CHECK=y

#
# CPU Idle
#
CONFIG_CPU_IDLE=y
# CONFIG_CPU_IDLE_MULTIPLE_DRIVERS is not set
# CONFIG_CPU_IDLE_GOV_LADDER is not set
CONFIG_CPU_IDLE_GOV_MENU=y
# CONFIG_ARCH_NEEDS_CPU_IDLE_COUPLED is not set

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
CONFIG_PCI_REALLOC_ENABLE_AUTO=y
CONFIG_PCI_STUB=y
# CONFIG_HT_IRQ is not set
CONFIG_PCI_ATS=y
# CONFIG_PCI_IOV is not set
# CONFIG_PCI_PRI is not set
CONFIG_PCI_PASID=y
CONFIG_PCI_IOAPIC=m
CONFIG_PCI_LABEL=y

#
# PCI host controller drivers
#
CONFIG_ISA_DMA_API=y
CONFIG_ISA=y
CONFIG_EISA=y
# CONFIG_EISA_VLB_PRIMING is not set
# CONFIG_EISA_PCI_EISA is not set
CONFIG_EISA_VIRTUAL_ROOT=y
# CONFIG_EISA_NAMES is not set
# CONFIG_SCx200 is not set
# CONFIG_OLPC is not set
CONFIG_ALIX=y
CONFIG_NET5501=y
# CONFIG_PCCARD is not set
CONFIG_HOTPLUG_PCI=y
# CONFIG_HOTPLUG_PCI_COMPAQ is not set
# CONFIG_HOTPLUG_PCI_IBM is not set
# CONFIG_HOTPLUG_PCI_ACPI is not set
# CONFIG_HOTPLUG_PCI_CPCI is not set
# CONFIG_HOTPLUG_PCI_SHPC is not set
CONFIG_RAPIDIO=m
CONFIG_RAPIDIO_DISC_TIMEOUT=30
# CONFIG_RAPIDIO_ENABLE_RX_TX_PORTS is not set
CONFIG_RAPIDIO_DMA_ENGINE=y
CONFIG_RAPIDIO_DEBUG=y
CONFIG_RAPIDIO_ENUM_BASIC=m

#
# RapidIO Switch drivers
#
CONFIG_RAPIDIO_TSI57X=m
CONFIG_RAPIDIO_CPS_XX=m
# CONFIG_RAPIDIO_TSI568 is not set
CONFIG_RAPIDIO_CPS_GEN2=m
# CONFIG_X86_SYSFB is not set

#
# Executable file formats / Emulations
#
CONFIG_BINFMT_ELF=y
CONFIG_ARCH_BINFMT_ELF_RANDOMIZE_PIE=y
# CONFIG_BINFMT_SCRIPT is not set
CONFIG_HAVE_AOUT=y
CONFIG_BINFMT_AOUT=m
# CONFIG_BINFMT_MISC is not set
# CONFIG_COREDUMP is not set
CONFIG_HAVE_ATOMIC_IOMAP=y
CONFIG_NET=y

#
# Networking options
#
CONFIG_PACKET=m
# CONFIG_PACKET_DIAG is not set
CONFIG_UNIX=y
# CONFIG_UNIX_DIAG is not set
CONFIG_XFRM=y
CONFIG_XFRM_ALGO=y
# CONFIG_XFRM_USER is not set
CONFIG_XFRM_SUB_POLICY=y
# CONFIG_XFRM_MIGRATE is not set
CONFIG_XFRM_IPCOMP=m
CONFIG_NET_KEY=m
# CONFIG_NET_KEY_MIGRATE is not set
CONFIG_INET=y
# CONFIG_IP_MULTICAST is not set
CONFIG_IP_ADVANCED_ROUTER=y
# CONFIG_IP_FIB_TRIE_STATS is not set
# CONFIG_IP_MULTIPLE_TABLES is not set
CONFIG_IP_ROUTE_MULTIPATH=y
CONFIG_IP_ROUTE_VERBOSE=y
CONFIG_IP_ROUTE_CLASSID=y
# CONFIG_IP_PNP is not set
# CONFIG_NET_IPIP is not set
# CONFIG_NET_IPGRE_DEMUX is not set
CONFIG_NET_IP_TUNNEL=m
# CONFIG_ARPD is not set
# CONFIG_SYN_COOKIES is not set
CONFIG_NET_IPVTI=m
CONFIG_INET_AH=y
CONFIG_INET_ESP=y
CONFIG_INET_IPCOMP=m
CONFIG_INET_XFRM_TUNNEL=m
CONFIG_INET_TUNNEL=m
CONFIG_INET_XFRM_MODE_TRANSPORT=y
CONFIG_INET_XFRM_MODE_TUNNEL=y
CONFIG_INET_XFRM_MODE_BEET=y
CONFIG_INET_LRO=y
# CONFIG_INET_DIAG is not set
# CONFIG_TCP_CONG_ADVANCED is not set
CONFIG_TCP_CONG_CUBIC=y
CONFIG_DEFAULT_TCP_CONG="cubic"
# CONFIG_TCP_MD5SIG is not set
# CONFIG_IPV6 is not set
# CONFIG_NETWORK_SECMARK is not set
CONFIG_NETWORK_PHY_TIMESTAMPING=y
# CONFIG_NETFILTER is not set
# CONFIG_IP_DCCP is not set
# CONFIG_IP_SCTP is not set
CONFIG_RDS=m
CONFIG_RDS_RDMA=m
CONFIG_RDS_TCP=m
CONFIG_RDS_DEBUG=y
CONFIG_TIPC=m
CONFIG_TIPC_PORTS=8191
# CONFIG_TIPC_MEDIA_IB is not set
# CONFIG_ATM is not set
CONFIG_L2TP=m
# CONFIG_L2TP_DEBUGFS is not set
# CONFIG_L2TP_V3 is not set
CONFIG_STP=y
CONFIG_GARP=y
# CONFIG_BRIDGE is not set
CONFIG_HAVE_NET_DSA=y
CONFIG_NET_DSA=y
CONFIG_NET_DSA_TAG_DSA=y
CONFIG_NET_DSA_TAG_EDSA=y
CONFIG_NET_DSA_TAG_TRAILER=y
CONFIG_VLAN_8021Q=y
CONFIG_VLAN_8021Q_GVRP=y
# CONFIG_VLAN_8021Q_MVRP is not set
CONFIG_DECNET=y
CONFIG_DECNET_ROUTER=y
CONFIG_LLC=y
# CONFIG_LLC2 is not set
CONFIG_IPX=y
# CONFIG_IPX_INTERN is not set
# CONFIG_ATALK is not set
# CONFIG_X25 is not set
CONFIG_LAPB=y
# CONFIG_PHONET is not set
CONFIG_IEEE802154=m
# CONFIG_MAC802154 is not set
CONFIG_NET_SCHED=y

#
# Queueing/Scheduling
#
CONFIG_NET_SCH_CBQ=m
CONFIG_NET_SCH_HTB=y
CONFIG_NET_SCH_HFSC=m
CONFIG_NET_SCH_PRIO=y
CONFIG_NET_SCH_MULTIQ=y
CONFIG_NET_SCH_RED=y
CONFIG_NET_SCH_SFB=y
CONFIG_NET_SCH_SFQ=m
# CONFIG_NET_SCH_TEQL is not set
# CONFIG_NET_SCH_TBF is not set
# CONFIG_NET_SCH_GRED is not set
# CONFIG_NET_SCH_DSMARK is not set
CONFIG_NET_SCH_NETEM=y
# CONFIG_NET_SCH_DRR is not set
CONFIG_NET_SCH_MQPRIO=y
# CONFIG_NET_SCH_CHOKE is not set
CONFIG_NET_SCH_QFQ=y
CONFIG_NET_SCH_CODEL=m
CONFIG_NET_SCH_FQ_CODEL=y
CONFIG_NET_SCH_INGRESS=m
CONFIG_NET_SCH_PLUG=y

#
# Classification
#
CONFIG_NET_CLS=y
CONFIG_NET_CLS_BASIC=y
# CONFIG_NET_CLS_TCINDEX is not set
CONFIG_NET_CLS_ROUTE4=y
CONFIG_NET_CLS_FW=m
# CONFIG_NET_CLS_U32 is not set
CONFIG_NET_CLS_RSVP=y
CONFIG_NET_CLS_RSVP6=m
# CONFIG_NET_CLS_FLOW is not set
CONFIG_NET_CLS_CGROUP=y
CONFIG_NET_EMATCH=y
CONFIG_NET_EMATCH_STACK=32
# CONFIG_NET_EMATCH_CMP is not set
# CONFIG_NET_EMATCH_NBYTE is not set
CONFIG_NET_EMATCH_U32=y
CONFIG_NET_EMATCH_META=m
CONFIG_NET_EMATCH_TEXT=m
CONFIG_NET_CLS_ACT=y
CONFIG_NET_ACT_POLICE=m
CONFIG_NET_ACT_GACT=y
CONFIG_GACT_PROB=y
# CONFIG_NET_ACT_MIRRED is not set
CONFIG_NET_ACT_NAT=y
# CONFIG_NET_ACT_PEDIT is not set
CONFIG_NET_ACT_SIMP=m
CONFIG_NET_ACT_SKBEDIT=y
CONFIG_NET_ACT_CSUM=m
# CONFIG_NET_CLS_IND is not set
CONFIG_NET_SCH_FIFO=y
# CONFIG_DCB is not set
CONFIG_DNS_RESOLVER=m
# CONFIG_BATMAN_ADV is not set
# CONFIG_OPENVSWITCH is not set
CONFIG_VSOCKETS=y
# CONFIG_NETLINK_MMAP is not set
CONFIG_NETLINK_DIAG=y
CONFIG_NET_MPLS_GSO=y
CONFIG_RPS=y
CONFIG_RFS_ACCEL=y
CONFIG_XPS=y
# CONFIG_NETPRIO_CGROUP is not set
CONFIG_NET_RX_BUSY_POLL=y
CONFIG_BQL=y
CONFIG_NET_FLOW_LIMIT=y

#
# Network testing
#
CONFIG_HAMRADIO=y

#
# Packet Radio protocols
#
CONFIG_AX25=y
# CONFIG_AX25_DAMA_SLAVE is not set
# CONFIG_NETROM is not set
CONFIG_ROSE=y

#
# AX.25 network device drivers
#
CONFIG_MKISS=y
# CONFIG_6PACK is not set
# CONFIG_BPQETHER is not set
CONFIG_SCC=m
CONFIG_SCC_DELAY=y
# CONFIG_SCC_TRXECHO is not set
CONFIG_BAYCOM_SER_FDX=m
CONFIG_BAYCOM_SER_HDX=m
CONFIG_YAM=m
# CONFIG_CAN is not set
# CONFIG_IRDA is not set
# CONFIG_BT is not set
# CONFIG_AF_RXRPC is not set
CONFIG_FIB_RULES=y
CONFIG_WIRELESS=y
CONFIG_CFG80211=y
CONFIG_NL80211_TESTMODE=y
# CONFIG_CFG80211_DEVELOPER_WARNINGS is not set
# CONFIG_CFG80211_REG_DEBUG is not set
CONFIG_CFG80211_CERTIFICATION_ONUS=y
CONFIG_CFG80211_DEFAULT_PS=y
CONFIG_CFG80211_DEBUGFS=y
# CONFIG_CFG80211_INTERNAL_REGDB is not set
# CONFIG_CFG80211_WEXT is not set
# CONFIG_LIB80211 is not set
# CONFIG_MAC80211 is not set
CONFIG_WIMAX=m
CONFIG_WIMAX_DEBUG_LEVEL=8
# CONFIG_RFKILL is not set
# CONFIG_RFKILL_REGULATOR is not set
CONFIG_NET_9P=y
CONFIG_NET_9P_VIRTIO=m
# CONFIG_NET_9P_RDMA is not set
# CONFIG_NET_9P_DEBUG is not set
CONFIG_CAIF=y
# CONFIG_CAIF_DEBUG is not set
# CONFIG_CAIF_NETDEV is not set
CONFIG_CAIF_USB=m
CONFIG_CEPH_LIB=m
# CONFIG_CEPH_LIB_PRETTYDEBUG is not set
# CONFIG_CEPH_LIB_USE_DNS_RESOLVER is not set
CONFIG_NFC=m
CONFIG_NFC_NCI=m
CONFIG_NFC_NCI_SPI=y
CONFIG_NFC_HCI=m
CONFIG_NFC_SHDLC=y

#
# Near Field Communication (NFC) devices
#
CONFIG_NFC_WILINK=m
# CONFIG_NFC_SIM is not set
# CONFIG_NFC_PN544 is not set
CONFIG_NFC_MICROREAD=m
# CONFIG_NFC_MICROREAD_I2C is not set

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
# CONFIG_FW_LOADER_USER_HELPER is not set
# CONFIG_DEBUG_DRIVER is not set
CONFIG_DEBUG_DEVRES=y
# CONFIG_SYS_HYPERVISOR is not set
# CONFIG_GENERIC_CPU_DEVICES is not set
CONFIG_REGMAP=y
CONFIG_REGMAP_I2C=y
CONFIG_REGMAP_SPI=y
CONFIG_REGMAP_IRQ=y
CONFIG_DMA_SHARED_BUFFER=y
CONFIG_DMA_CMA=y

#
# Default contiguous memory area size:
#
CONFIG_CMA_SIZE_MBYTES=16
CONFIG_CMA_SIZE_SEL_MBYTES=y
# CONFIG_CMA_SIZE_SEL_PERCENTAGE is not set
# CONFIG_CMA_SIZE_SEL_MIN is not set
# CONFIG_CMA_SIZE_SEL_MAX is not set
CONFIG_CMA_ALIGNMENT=8
CONFIG_CMA_AREAS=7

#
# Bus devices
#
# CONFIG_CONNECTOR is not set
CONFIG_MTD=m
CONFIG_MTD_TESTS=m
CONFIG_MTD_REDBOOT_PARTS=m
CONFIG_MTD_REDBOOT_DIRECTORY_BLOCK=-1
# CONFIG_MTD_REDBOOT_PARTS_UNALLOCATED is not set
CONFIG_MTD_REDBOOT_PARTS_READONLY=y
# CONFIG_MTD_CMDLINE_PARTS is not set
CONFIG_MTD_AR7_PARTS=m

#
# User Modules And Translation Layers
#
CONFIG_MTD_BLKDEVS=m
# CONFIG_MTD_BLOCK is not set
# CONFIG_MTD_BLOCK_RO is not set
# CONFIG_FTL is not set
CONFIG_NFTL=m
CONFIG_NFTL_RW=y
CONFIG_INFTL=m
CONFIG_RFD_FTL=m
# CONFIG_SSFDC is not set
# CONFIG_SM_FTL is not set
CONFIG_MTD_OOPS=m

#
# RAM/ROM/Flash chip drivers
#
CONFIG_MTD_CFI=m
CONFIG_MTD_JEDECPROBE=m
CONFIG_MTD_GEN_PROBE=m
CONFIG_MTD_CFI_ADV_OPTIONS=y
# CONFIG_MTD_CFI_NOSWAP is not set
CONFIG_MTD_CFI_BE_BYTE_SWAP=y
# CONFIG_MTD_CFI_LE_BYTE_SWAP is not set
CONFIG_MTD_CFI_GEOMETRY=y
CONFIG_MTD_MAP_BANK_WIDTH_1=y
CONFIG_MTD_MAP_BANK_WIDTH_2=y
CONFIG_MTD_MAP_BANK_WIDTH_4=y
CONFIG_MTD_MAP_BANK_WIDTH_8=y
CONFIG_MTD_MAP_BANK_WIDTH_16=y
CONFIG_MTD_MAP_BANK_WIDTH_32=y
CONFIG_MTD_CFI_I1=y
# CONFIG_MTD_CFI_I2 is not set
# CONFIG_MTD_CFI_I4 is not set
# CONFIG_MTD_CFI_I8 is not set
CONFIG_MTD_OTP=y
# CONFIG_MTD_CFI_INTELEXT is not set
# CONFIG_MTD_CFI_AMDSTD is not set
# CONFIG_MTD_CFI_STAA is not set
CONFIG_MTD_CFI_UTIL=m
# CONFIG_MTD_RAM is not set
CONFIG_MTD_ROM=m
CONFIG_MTD_ABSENT=m

#
# Mapping drivers for chip access
#
CONFIG_MTD_COMPLEX_MAPPINGS=y
CONFIG_MTD_PHYSMAP=m
# CONFIG_MTD_PHYSMAP_COMPAT is not set
CONFIG_MTD_SC520CDP=m
CONFIG_MTD_NETSC520=m
# CONFIG_MTD_TS5500 is not set
CONFIG_MTD_AMD76XROM=m
CONFIG_MTD_ICHXROM=m
CONFIG_MTD_ESB2ROM=m
# CONFIG_MTD_CK804XROM is not set
CONFIG_MTD_SCB2_FLASH=m
# CONFIG_MTD_NETtel is not set
CONFIG_MTD_L440GX=m
CONFIG_MTD_PCI=m
CONFIG_MTD_GPIO_ADDR=m
CONFIG_MTD_INTEL_VR_NOR=m
# CONFIG_MTD_PLATRAM is not set
CONFIG_MTD_LATCH_ADDR=m

#
# Self-contained MTD device drivers
#
# CONFIG_MTD_PMC551 is not set
CONFIG_MTD_DATAFLASH=m
CONFIG_MTD_DATAFLASH_WRITE_VERIFY=y
# CONFIG_MTD_DATAFLASH_OTP is not set
CONFIG_MTD_M25P80=m
CONFIG_M25PXX_USE_FAST_READ=y
CONFIG_MTD_SST25L=m
# CONFIG_MTD_SLRAM is not set
CONFIG_MTD_PHRAM=m
# CONFIG_MTD_MTDRAM is not set
CONFIG_MTD_BLOCK2MTD=m

#
# Disk-On-Chip Device Drivers
#
CONFIG_MTD_DOCG3=m
CONFIG_BCH_CONST_M=14
CONFIG_BCH_CONST_T=4
CONFIG_MTD_NAND_ECC=m
# CONFIG_MTD_NAND_ECC_SMC is not set
CONFIG_MTD_NAND=m
# CONFIG_MTD_NAND_ECC_BCH is not set
CONFIG_MTD_SM_COMMON=m
CONFIG_MTD_NAND_DENALI=m
CONFIG_MTD_NAND_DENALI_PCI=m
CONFIG_MTD_NAND_DENALI_SCRATCH_REG_ADDR=0xFF108018
CONFIG_MTD_NAND_GPIO=m
CONFIG_MTD_NAND_IDS=m
CONFIG_MTD_NAND_RICOH=m
CONFIG_MTD_NAND_DISKONCHIP=m
CONFIG_MTD_NAND_DISKONCHIP_PROBE_ADVANCED=y
CONFIG_MTD_NAND_DISKONCHIP_PROBE_ADDRESS=0
CONFIG_MTD_NAND_DISKONCHIP_PROBE_HIGH=y
# CONFIG_MTD_NAND_DISKONCHIP_BBTWRITE is not set
CONFIG_MTD_NAND_DOCG4=m
CONFIG_MTD_NAND_CAFE=m
CONFIG_MTD_NAND_CS553X=m
CONFIG_MTD_NAND_NANDSIM=m
CONFIG_MTD_NAND_PLATFORM=m
CONFIG_MTD_ONENAND=m
CONFIG_MTD_ONENAND_VERIFY_WRITE=y
# CONFIG_MTD_ONENAND_GENERIC is not set
CONFIG_MTD_ONENAND_OTP=y
CONFIG_MTD_ONENAND_2X_PROGRAM=y

#
# LPDDR flash memory drivers
#
CONFIG_MTD_LPDDR=m
CONFIG_MTD_QINFO_PROBE=m
# CONFIG_MTD_UBI is not set
# CONFIG_PARPORT is not set
CONFIG_PNP=y
CONFIG_PNP_DEBUG_MESSAGES=y

#
# Protocols
#
# CONFIG_ISAPNP is not set
CONFIG_PNPBIOS=y
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
# CONFIG_BLK_DEV_RBD is not set
# CONFIG_BLK_DEV_RSXX is not set
# CONFIG_BLOCKCONSOLE is not set

#
# Misc devices
#
CONFIG_SENSORS_LIS3LV02D=m
# CONFIG_AD525X_DPOT is not set
# CONFIG_DUMMY_IRQ is not set
# CONFIG_IBM_ASM is not set
CONFIG_PHANTOM=m
CONFIG_INTEL_MID_PTI=m
# CONFIG_SGI_IOC4 is not set
CONFIG_TIFM_CORE=y
# CONFIG_TIFM_7XX1 is not set
CONFIG_ICS932S401=m
CONFIG_ATMEL_SSC=y
CONFIG_ENCLOSURE_SERVICES=m
CONFIG_HP_ILO=m
CONFIG_APDS9802ALS=y
CONFIG_ISL29003=m
CONFIG_ISL29020=m
CONFIG_SENSORS_TSL2550=m
CONFIG_SENSORS_BH1780=m
CONFIG_SENSORS_BH1770=m
# CONFIG_SENSORS_APDS990X is not set
# CONFIG_HMC6352 is not set
CONFIG_DS1682=m
CONFIG_TI_DAC7512=m
# CONFIG_VMWARE_BALLOON is not set
CONFIG_BMP085=y
CONFIG_BMP085_I2C=y
# CONFIG_BMP085_SPI is not set
CONFIG_PCH_PHUB=y
# CONFIG_USB_SWITCH_FSA9480 is not set
CONFIG_LATTICE_ECP3_CONFIG=y
# CONFIG_SRAM is not set
CONFIG_C2PORT=m
CONFIG_C2PORT_DURAMAR_2150=m

#
# EEPROM support
#
CONFIG_EEPROM_AT24=m
CONFIG_EEPROM_AT25=y
# CONFIG_EEPROM_LEGACY is not set
CONFIG_EEPROM_MAX6875=y
CONFIG_EEPROM_93CX6=m
CONFIG_EEPROM_93XX46=y
CONFIG_CB710_CORE=y
# CONFIG_CB710_DEBUG is not set
CONFIG_CB710_DEBUG_ASSUMPTIONS=y

#
# Texas Instruments shared transport line discipline
#
CONFIG_TI_ST=m
CONFIG_SENSORS_LIS3_I2C=m

#
# Altera FPGA firmware download module
#
# CONFIG_ALTERA_STAPL is not set
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
# CONFIG_BLK_DEV_IDE_SATA is not set
CONFIG_IDE_GD=m
# CONFIG_IDE_GD_ATA is not set
# CONFIG_IDE_GD_ATAPI is not set
# CONFIG_BLK_DEV_IDECD is not set
CONFIG_BLK_DEV_IDETAPE=m
CONFIG_BLK_DEV_IDEACPI=y
# CONFIG_IDE_TASK_IOCTL is not set

#
# IDE chipset support/bugfixes
#
CONFIG_IDE_GENERIC=y
CONFIG_BLK_DEV_PLATFORM=y
# CONFIG_BLK_DEV_CMD640 is not set
# CONFIG_BLK_DEV_IDEPNP is not set
CONFIG_BLK_DEV_IDEDMA_SFF=y

#
# PCI IDE chipsets support
#
CONFIG_BLK_DEV_IDEPCI=y
# CONFIG_IDEPCI_PCIBUS_ORDER is not set
CONFIG_BLK_DEV_OFFBOARD=y
CONFIG_BLK_DEV_GENERIC=y
# CONFIG_BLK_DEV_OPTI621 is not set
CONFIG_BLK_DEV_RZ1000=y
CONFIG_BLK_DEV_IDEDMA_PCI=y
CONFIG_BLK_DEV_AEC62XX=y
# CONFIG_BLK_DEV_ALI15X3 is not set
CONFIG_BLK_DEV_AMD74XX=y
# CONFIG_BLK_DEV_ATIIXP is not set
# CONFIG_BLK_DEV_CMD64X is not set
CONFIG_BLK_DEV_TRIFLEX=m
CONFIG_BLK_DEV_CS5520=m
CONFIG_BLK_DEV_CS5530=y
# CONFIG_BLK_DEV_CS5535 is not set
CONFIG_BLK_DEV_CS5536=m
CONFIG_BLK_DEV_HPT366=m
CONFIG_BLK_DEV_JMICRON=y
CONFIG_BLK_DEV_SC1200=y
CONFIG_BLK_DEV_PIIX=m
# CONFIG_BLK_DEV_IT8172 is not set
CONFIG_BLK_DEV_IT8213=y
CONFIG_BLK_DEV_IT821X=y
# CONFIG_BLK_DEV_NS87415 is not set
CONFIG_BLK_DEV_PDC202XX_OLD=m
CONFIG_BLK_DEV_PDC202XX_NEW=y
# CONFIG_BLK_DEV_SVWKS is not set
CONFIG_BLK_DEV_SIIMAGE=m
# CONFIG_BLK_DEV_SIS5513 is not set
CONFIG_BLK_DEV_SLC90E66=m
CONFIG_BLK_DEV_TRM290=y
CONFIG_BLK_DEV_VIA82CXXX=y
CONFIG_BLK_DEV_TC86C001=y

#
# Other IDE chipsets support
#

#
# Note: most of these also require special kernel boot parameters
#
CONFIG_BLK_DEV_4DRIVES=m
CONFIG_BLK_DEV_ALI14XX=y
CONFIG_BLK_DEV_DTC2278=y
CONFIG_BLK_DEV_HT6560B=m
# CONFIG_BLK_DEV_QD65XX is not set
# CONFIG_BLK_DEV_UMC8672 is not set
CONFIG_BLK_DEV_IDEDMA=y

#
# SCSI device support
#
CONFIG_SCSI_MOD=m
CONFIG_RAID_ATTRS=m
CONFIG_SCSI=m
CONFIG_SCSI_DMA=y
CONFIG_SCSI_TGT=m
CONFIG_SCSI_NETLINK=y

#
# SCSI support type (disk, tape, CD-ROM)
#
# CONFIG_BLK_DEV_SD is not set
CONFIG_CHR_DEV_ST=m
CONFIG_CHR_DEV_OSST=m
CONFIG_BLK_DEV_SR=m
# CONFIG_BLK_DEV_SR_VENDOR is not set
# CONFIG_CHR_DEV_SG is not set
# CONFIG_CHR_DEV_SCH is not set
# CONFIG_SCSI_ENCLOSURE is not set
# CONFIG_SCSI_MULTI_LUN is not set
CONFIG_SCSI_CONSTANTS=y
CONFIG_SCSI_LOGGING=y
CONFIG_SCSI_SCAN_ASYNC=y

#
# SCSI Transports
#
CONFIG_SCSI_SPI_ATTRS=m
CONFIG_SCSI_FC_ATTRS=m
CONFIG_SCSI_FC_TGT_ATTRS=y
CONFIG_SCSI_ISCSI_ATTRS=m
CONFIG_SCSI_SAS_ATTRS=m
CONFIG_SCSI_SAS_LIBSAS=m
CONFIG_SCSI_SAS_ATA=y
# CONFIG_SCSI_SAS_HOST_SMP is not set
CONFIG_SCSI_SRP_ATTRS=m
CONFIG_SCSI_SRP_TGT_ATTRS=y
# CONFIG_SCSI_LOWLEVEL is not set
CONFIG_SCSI_DH=m
CONFIG_SCSI_DH_RDAC=m
CONFIG_SCSI_DH_HP_SW=m
CONFIG_SCSI_DH_EMC=m
CONFIG_SCSI_DH_ALUA=m
CONFIG_SCSI_OSD_INITIATOR=m
# CONFIG_SCSI_OSD_ULD is not set
CONFIG_SCSI_OSD_DPRINT_SENSE=1
CONFIG_SCSI_OSD_DEBUG=y
CONFIG_ATA=m
# CONFIG_ATA_NONSTANDARD is not set
# CONFIG_ATA_VERBOSE_ERROR is not set
# CONFIG_ATA_ACPI is not set
# CONFIG_SATA_PMP is not set

#
# Controllers with non-SFF native interface
#
# CONFIG_SATA_AHCI is not set
CONFIG_SATA_AHCI_PLATFORM=m
CONFIG_SATA_INIC162X=m
# CONFIG_SATA_ACARD_AHCI is not set
# CONFIG_SATA_SIL24 is not set
# CONFIG_ATA_SFF is not set
CONFIG_MD=y
CONFIG_BLK_DEV_MD=m
CONFIG_MD_LINEAR=m
CONFIG_MD_RAID0=m
# CONFIG_MD_RAID1 is not set
# CONFIG_MD_RAID10 is not set
CONFIG_MD_RAID456=m
# CONFIG_MD_MULTIPATH is not set
# CONFIG_MD_FAULTY is not set
CONFIG_BCACHE=y
CONFIG_BCACHE_DEBUG=y
CONFIG_BCACHE_EDEBUG=y
CONFIG_BCACHE_CLOSURES_DEBUG=y
# CONFIG_BLK_DEV_DM is not set
# CONFIG_TARGET_CORE is not set
CONFIG_FUSION=y
CONFIG_FUSION_SPI=m
# CONFIG_FUSION_FC is not set
CONFIG_FUSION_SAS=m
CONFIG_FUSION_MAX_SGE=128
# CONFIG_FUSION_CTL is not set
CONFIG_FUSION_LOGGING=y

#
# IEEE 1394 (FireWire) support
#
# CONFIG_FIREWIRE is not set
CONFIG_FIREWIRE_NOSY=y
CONFIG_I2O=y
# CONFIG_I2O_LCT_NOTIFY_ON_CHANGES is not set
CONFIG_I2O_EXT_ADAPTEC=y
CONFIG_I2O_CONFIG=m
CONFIG_I2O_CONFIG_OLD_IOCTL=y
# CONFIG_I2O_BUS is not set
CONFIG_I2O_BLOCK=m
CONFIG_I2O_SCSI=m
# CONFIG_I2O_PROC is not set
# CONFIG_MACINTOSH_DRIVERS is not set
CONFIG_NETDEVICES=y
CONFIG_NET_CORE=y
CONFIG_BONDING=y
CONFIG_DUMMY=m
# CONFIG_EQUALIZER is not set
# CONFIG_NET_FC is not set
# CONFIG_IFB is not set
CONFIG_NET_TEAM=m
CONFIG_NET_TEAM_MODE_BROADCAST=m
CONFIG_NET_TEAM_MODE_ROUNDROBIN=m
# CONFIG_NET_TEAM_MODE_RANDOM is not set
# CONFIG_NET_TEAM_MODE_ACTIVEBACKUP is not set
CONFIG_NET_TEAM_MODE_LOADBALANCE=m
CONFIG_MACVLAN=y
CONFIG_MACVTAP=y
# CONFIG_VXLAN is not set
# CONFIG_NETCONSOLE is not set
# CONFIG_NETPOLL is not set
# CONFIG_NET_POLL_CONTROLLER is not set
# CONFIG_RIONET is not set
# CONFIG_TUN is not set
CONFIG_VETH=m
CONFIG_VIRTIO_NET=m
CONFIG_NLMON=m
CONFIG_ARCNET=y
# CONFIG_ARCNET_1201 is not set
CONFIG_ARCNET_1051=y
CONFIG_ARCNET_RAW=m
CONFIG_ARCNET_CAP=y
CONFIG_ARCNET_COM90xx=y
CONFIG_ARCNET_COM90xxIO=y
# CONFIG_ARCNET_RIM_I is not set
# CONFIG_ARCNET_COM20020 is not set

#
# CAIF transport drivers
#
CONFIG_CAIF_TTY=y
CONFIG_CAIF_SPI_SLAVE=m
# CONFIG_CAIF_SPI_SYNC is not set
CONFIG_CAIF_HSI=y
CONFIG_CAIF_VIRTIO=m
# CONFIG_VHOST_NET is not set
CONFIG_VHOST_RING=m

#
# Distributed Switch Architecture drivers
#
CONFIG_NET_DSA_MV88E6XXX=y
CONFIG_NET_DSA_MV88E6060=m
CONFIG_NET_DSA_MV88E6XXX_NEED_PPU=y
CONFIG_NET_DSA_MV88E6131=y
CONFIG_NET_DSA_MV88E6123_61_65=m
# CONFIG_ETHERNET is not set
# CONFIG_FDDI is not set
CONFIG_HIPPI=y
CONFIG_ROADRUNNER=m
CONFIG_ROADRUNNER_LARGE_RINGS=y
CONFIG_NET_SB1000=y
CONFIG_PHYLIB=y

#
# MII PHY device drivers
#
CONFIG_AT803X_PHY=y
CONFIG_AMD_PHY=m
CONFIG_MARVELL_PHY=m
CONFIG_DAVICOM_PHY=m
CONFIG_QSEMI_PHY=m
CONFIG_LXT_PHY=y
CONFIG_CICADA_PHY=y
# CONFIG_VITESSE_PHY is not set
# CONFIG_SMSC_PHY is not set
CONFIG_BROADCOM_PHY=m
CONFIG_BCM87XX_PHY=m
CONFIG_ICPLUS_PHY=m
CONFIG_REALTEK_PHY=m
CONFIG_NATIONAL_PHY=y
CONFIG_STE10XP=m
CONFIG_LSI_ET1011C_PHY=m
CONFIG_MICREL_PHY=y
CONFIG_FIXED_PHY=y
CONFIG_MDIO_BITBANG=m
CONFIG_MDIO_GPIO=m
CONFIG_MICREL_KS8995MA=y
CONFIG_PPP=y
CONFIG_PPP_BSDCOMP=m
CONFIG_PPP_DEFLATE=y
CONFIG_PPP_FILTER=y
CONFIG_PPP_MPPE=m
CONFIG_PPP_MULTILINK=y
CONFIG_PPPOE=y
CONFIG_PPPOL2TP=m
# CONFIG_PPP_ASYNC is not set
CONFIG_PPP_SYNC_TTY=y
# CONFIG_SLIP is not set
CONFIG_SLHC=y
# CONFIG_WLAN is not set

#
# WiMAX Wireless Broadband devices
#

#
# Enable USB support to see WiMAX USB drivers
#
CONFIG_WAN=y
# CONFIG_HDLC is not set
# CONFIG_DLCI is not set
# CONFIG_SBNI is not set
CONFIG_IEEE802154_DRIVERS=m
# CONFIG_IEEE802154_FAKEHARD is not set
CONFIG_VMXNET3=m
CONFIG_HYPERV_NET=m
CONFIG_ISDN=y
CONFIG_ISDN_I4L=m
# CONFIG_ISDN_PPP is not set
CONFIG_ISDN_AUDIO=y
CONFIG_ISDN_TTY_FAX=y

#
# ISDN feature submodules
#
CONFIG_ISDN_DIVERSION=m

#
# ISDN4Linux hardware drivers
#

#
# Passive cards
#
CONFIG_ISDN_DRV_HISAX=m

#
# D-channel protocol features
#
CONFIG_HISAX_EURO=y
# CONFIG_DE_AOC is not set
# CONFIG_HISAX_NO_SENDCOMPLETE is not set
CONFIG_HISAX_NO_LLC=y
CONFIG_HISAX_NO_KEYPAD=y
# CONFIG_HISAX_1TR6 is not set
CONFIG_HISAX_NI1=y
CONFIG_HISAX_MAX_CARDS=8

#
# HiSax supported cards
#
CONFIG_HISAX_16_0=y
CONFIG_HISAX_16_3=y
# CONFIG_HISAX_TELESPCI is not set
CONFIG_HISAX_S0BOX=y
CONFIG_HISAX_AVM_A1=y
# CONFIG_HISAX_FRITZPCI is not set
CONFIG_HISAX_AVM_A1_PCMCIA=y
# CONFIG_HISAX_ELSA is not set
# CONFIG_HISAX_IX1MICROR2 is not set
CONFIG_HISAX_DIEHLDIVA=y
CONFIG_HISAX_ASUSCOM=y
# CONFIG_HISAX_TELEINT is not set
CONFIG_HISAX_HFCS=y
CONFIG_HISAX_SEDLBAUER=y
CONFIG_HISAX_SPORTSTER=y
CONFIG_HISAX_MIC=y
# CONFIG_HISAX_NETJET is not set
# CONFIG_HISAX_NETJET_U is not set
# CONFIG_HISAX_NICCY is not set
CONFIG_HISAX_ISURF=y
CONFIG_HISAX_HSTSAPHIR=y
CONFIG_HISAX_BKM_A4T=y
CONFIG_HISAX_SCT_QUADRO=y
CONFIG_HISAX_GAZEL=y
CONFIG_HISAX_HFC_PCI=y
# CONFIG_HISAX_W6692 is not set
# CONFIG_HISAX_HFC_SX is not set
CONFIG_HISAX_DEBUG=y

#
# HiSax PCMCIA card service modules
#

#
# HiSax sub driver modules
#
CONFIG_HISAX_HFC4S8S=m
CONFIG_HISAX_FRITZ_PCIPNP=m

#
# Active cards
#
# CONFIG_ISDN_DRV_ICN is not set
# CONFIG_ISDN_DRV_PCBIT is not set
# CONFIG_ISDN_DRV_SC is not set
# CONFIG_ISDN_DRV_ACT2000 is not set
# CONFIG_ISDN_CAPI is not set
# CONFIG_ISDN_DRV_GIGASET is not set
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
CONFIG_INPUT_MOUSEDEV=m
# CONFIG_INPUT_MOUSEDEV_PSAUX is not set
CONFIG_INPUT_MOUSEDEV_SCREEN_X=1024
CONFIG_INPUT_MOUSEDEV_SCREEN_Y=768
# CONFIG_INPUT_JOYDEV is not set
CONFIG_INPUT_EVDEV=m
# CONFIG_INPUT_EVBUG is not set

#
# Input Device Drivers
#
CONFIG_INPUT_KEYBOARD=y
CONFIG_KEYBOARD_ADP5588=m
CONFIG_KEYBOARD_ADP5589=m
CONFIG_KEYBOARD_ATKBD=y
CONFIG_KEYBOARD_QT1070=y
# CONFIG_KEYBOARD_QT2160 is not set
CONFIG_KEYBOARD_LKKBD=y
CONFIG_KEYBOARD_GPIO=m
# CONFIG_KEYBOARD_GPIO_POLLED is not set
# CONFIG_KEYBOARD_TCA6416 is not set
CONFIG_KEYBOARD_TCA8418=m
# CONFIG_KEYBOARD_MATRIX is not set
# CONFIG_KEYBOARD_LM8323 is not set
CONFIG_KEYBOARD_LM8333=y
# CONFIG_KEYBOARD_MAX7359 is not set
CONFIG_KEYBOARD_MCS=y
CONFIG_KEYBOARD_MPR121=y
# CONFIG_KEYBOARD_NEWTON is not set
# CONFIG_KEYBOARD_OPENCORES is not set
CONFIG_KEYBOARD_STOWAWAY=y
# CONFIG_KEYBOARD_SUNKBD is not set
# CONFIG_KEYBOARD_TC3589X is not set
CONFIG_KEYBOARD_XTKBD=y
# CONFIG_KEYBOARD_CROS_EC is not set
# CONFIG_INPUT_MOUSE is not set
# CONFIG_INPUT_JOYSTICK is not set
CONFIG_INPUT_TABLET=y
# CONFIG_TABLET_USB_ACECAD is not set
# CONFIG_TABLET_USB_AIPTEK is not set
# CONFIG_TABLET_USB_HANWANG is not set
# CONFIG_TABLET_USB_KBTAB is not set
# CONFIG_TABLET_USB_WACOM is not set
# CONFIG_INPUT_TOUCHSCREEN is not set
CONFIG_INPUT_MISC=y
CONFIG_INPUT_88PM860X_ONKEY=m
# CONFIG_INPUT_88PM80X_ONKEY is not set
CONFIG_INPUT_AD714X=y
CONFIG_INPUT_AD714X_I2C=m
CONFIG_INPUT_AD714X_SPI=m
# CONFIG_INPUT_BMA150 is not set
CONFIG_INPUT_PCSPKR=m
CONFIG_INPUT_MAX8925_ONKEY=y
CONFIG_INPUT_MC13783_PWRBUTTON=y
CONFIG_INPUT_MMA8450=m
# CONFIG_INPUT_MPU3050 is not set
CONFIG_INPUT_APANEL=y
CONFIG_INPUT_GP2A=m
# CONFIG_INPUT_GPIO_TILT_POLLED is not set
# CONFIG_INPUT_WISTRON_BTNS is not set
CONFIG_INPUT_ATLAS_BTNS=y
# CONFIG_INPUT_ATI_REMOTE2 is not set
# CONFIG_INPUT_KEYSPAN_REMOTE is not set
CONFIG_INPUT_KXTJ9=y
CONFIG_INPUT_KXTJ9_POLLED_MODE=y
# CONFIG_INPUT_POWERMATE is not set
# CONFIG_INPUT_YEALINK is not set
# CONFIG_INPUT_CM109 is not set
# CONFIG_INPUT_RETU_PWRBUTTON is not set
# CONFIG_INPUT_UINPUT is not set
# CONFIG_INPUT_PCF50633_PMU is not set
CONFIG_INPUT_PCF8574=m
# CONFIG_INPUT_PWM_BEEPER is not set
CONFIG_INPUT_GPIO_ROTARY_ENCODER=y
CONFIG_INPUT_DA9052_ONKEY=y
CONFIG_INPUT_WM831X_ON=m
CONFIG_INPUT_PCAP=y
# CONFIG_INPUT_ADXL34X is not set
# CONFIG_INPUT_CMA3000 is not set

#
# Hardware I/O ports
#
CONFIG_SERIO=y
CONFIG_SERIO_I8042=y
# CONFIG_SERIO_SERPORT is not set
# CONFIG_SERIO_CT82C710 is not set
CONFIG_SERIO_PCIPS2=m
CONFIG_SERIO_LIBPS2=y
CONFIG_SERIO_RAW=m
CONFIG_SERIO_ALTERA_PS2=y
# CONFIG_SERIO_PS2MULT is not set
CONFIG_SERIO_ARC_PS2=m
CONFIG_GAMEPORT=m
# CONFIG_GAMEPORT_NS558 is not set
CONFIG_GAMEPORT_L4=m
# CONFIG_GAMEPORT_EMU10K1 is not set
CONFIG_GAMEPORT_FM801=m

#
# Character devices
#
CONFIG_TTY=y
# CONFIG_VT is not set
CONFIG_UNIX98_PTYS=y
CONFIG_DEVPTS_MULTIPLE_INSTANCES=y
# CONFIG_LEGACY_PTYS is not set
CONFIG_SERIAL_NONSTANDARD=y
CONFIG_ROCKETPORT=y
CONFIG_CYCLADES=m
# CONFIG_CYZ_INTR is not set
# CONFIG_MOXA_INTELLIO is not set
CONFIG_MOXA_SMARTIO=m
CONFIG_SYNCLINK=m
CONFIG_SYNCLINKMP=m
CONFIG_SYNCLINK_GT=m
CONFIG_NOZOMI=m
# CONFIG_ISI is not set
# CONFIG_N_HDLC is not set
# CONFIG_N_GSM is not set
# CONFIG_TRACE_SINK is not set
CONFIG_DEVKMEM=y

#
# Serial drivers
#
CONFIG_SERIAL_8250=y
CONFIG_SERIAL_8250_DEPRECATED_OPTIONS=y
CONFIG_SERIAL_8250_PNP=y
CONFIG_SERIAL_8250_CONSOLE=y
CONFIG_FIX_EARLYCON_MEM=y
# CONFIG_SERIAL_8250_DMA is not set
# CONFIG_SERIAL_8250_PCI is not set
CONFIG_SERIAL_8250_NR_UARTS=4
CONFIG_SERIAL_8250_RUNTIME_UARTS=4
CONFIG_SERIAL_8250_EXTENDED=y
CONFIG_SERIAL_8250_MANY_PORTS=y
CONFIG_SERIAL_8250_FOURPORT=y
# CONFIG_SERIAL_8250_ACCENT is not set
# CONFIG_SERIAL_8250_BOCA is not set
CONFIG_SERIAL_8250_EXAR_ST16C554=m
CONFIG_SERIAL_8250_HUB6=m
# CONFIG_SERIAL_8250_SHARE_IRQ is not set
# CONFIG_SERIAL_8250_DETECT_IRQ is not set
# CONFIG_SERIAL_8250_RSA is not set
CONFIG_SERIAL_8250_DW=m

#
# Non-8250 serial port support
#
CONFIG_SERIAL_MAX3100=y
# CONFIG_SERIAL_MAX310X is not set
CONFIG_SERIAL_MFD_HSU=y
CONFIG_SERIAL_MFD_HSU_CONSOLE=y
CONFIG_SERIAL_CORE=y
CONFIG_SERIAL_CORE_CONSOLE=y
# CONFIG_SERIAL_JSM is not set
CONFIG_SERIAL_SCCNXP=m
CONFIG_SERIAL_TIMBERDALE=m
CONFIG_SERIAL_ALTERA_JTAGUART=y
# CONFIG_SERIAL_ALTERA_JTAGUART_CONSOLE is not set
CONFIG_SERIAL_ALTERA_UART=m
CONFIG_SERIAL_ALTERA_UART_MAXPORTS=4
CONFIG_SERIAL_ALTERA_UART_BAUDRATE=115200
CONFIG_SERIAL_IFX6X60=m
CONFIG_SERIAL_PCH_UART=m
# CONFIG_SERIAL_ARC is not set
# CONFIG_SERIAL_RP2 is not set
CONFIG_SERIAL_FSL_LPUART=m
# CONFIG_SERIAL_ST_ASC is not set
# CONFIG_TTY_PRINTK is not set
CONFIG_HVC_DRIVER=y
CONFIG_VIRTIO_CONSOLE=m
# CONFIG_IPMI_HANDLER is not set
# CONFIG_HW_RANDOM is not set
# CONFIG_NVRAM is not set
CONFIG_DTLK=m
CONFIG_R3964=y
CONFIG_APPLICOM=y
# CONFIG_SONYPI is not set
CONFIG_MWAVE=m
# CONFIG_PC8736x_GPIO is not set
# CONFIG_NSC_GPIO is not set
CONFIG_RAW_DRIVER=m
CONFIG_MAX_RAW_DEVS=256
# CONFIG_HPET is not set
# CONFIG_HANGCHECK_TIMER is not set
CONFIG_TCG_TPM=y
CONFIG_TCG_TIS=y
CONFIG_TCG_TIS_I2C_INFINEON=y
CONFIG_TCG_NSC=m
# CONFIG_TCG_ATMEL is not set
CONFIG_TCG_INFINEON=m
CONFIG_TCG_ST33_I2C=y
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
CONFIG_I2C_MUX_GPIO=m
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
CONFIG_I2C_ALI15X3=y
CONFIG_I2C_AMD756=y
CONFIG_I2C_AMD756_S4882=m
CONFIG_I2C_AMD8111=m
CONFIG_I2C_I801=m
CONFIG_I2C_ISCH=y
# CONFIG_I2C_ISMT is not set
# CONFIG_I2C_PIIX4 is not set
CONFIG_I2C_NFORCE2=m
CONFIG_I2C_NFORCE2_S4985=m
# CONFIG_I2C_SIS5595 is not set
CONFIG_I2C_SIS630=m
# CONFIG_I2C_SIS96X is not set
# CONFIG_I2C_VIA is not set
CONFIG_I2C_VIAPRO=y

#
# ACPI drivers
#
# CONFIG_I2C_SCMI is not set

#
# I2C system bus drivers (mostly embedded / system-on-chip)
#
# CONFIG_I2C_CBUS_GPIO is not set
# CONFIG_I2C_DESIGNWARE_PCI is not set
# CONFIG_I2C_EG20T is not set
CONFIG_I2C_GPIO=m
CONFIG_I2C_KEMPLD=m
CONFIG_I2C_OCORES=m
CONFIG_I2C_PCA_PLATFORM=y
# CONFIG_I2C_PXA_PCI is not set
# CONFIG_I2C_SIMTEC is not set
CONFIG_I2C_XILINX=m

#
# External I2C/SMBus adapter drivers
#
CONFIG_I2C_PARPORT_LIGHT=y
# CONFIG_I2C_TAOS_EVM is not set

#
# Other I2C/SMBus bus drivers
#
# CONFIG_I2C_PCA_ISA is not set
CONFIG_SCx200_ACB=y
CONFIG_I2C_STUB=m
# CONFIG_I2C_DEBUG_CORE is not set
# CONFIG_I2C_DEBUG_ALGO is not set
# CONFIG_I2C_DEBUG_BUS is not set
CONFIG_SPI=y
CONFIG_SPI_DEBUG=y
CONFIG_SPI_MASTER=y

#
# SPI Master Controller Drivers
#
# CONFIG_SPI_ALTERA is not set
CONFIG_SPI_ATMEL=m
CONFIG_SPI_BCM2835=y
CONFIG_SPI_BITBANG=m
CONFIG_SPI_EP93XX=m
# CONFIG_SPI_GPIO is not set
CONFIG_SPI_IMX=m
CONFIG_SPI_OC_TINY=m
# CONFIG_SPI_OMAP24XX is not set
# CONFIG_SPI_OMAP_100K is not set
CONFIG_SPI_ORION=m
# CONFIG_SPI_PXA2XX is not set
# CONFIG_SPI_PXA2XX_PCI is not set
# CONFIG_SPI_SC18IS602 is not set
CONFIG_SPI_SH=y
CONFIG_SPI_SH_HSPI=m
CONFIG_SPI_TEGRA114=y
# CONFIG_SPI_TEGRA20_SFLASH is not set
# CONFIG_SPI_TEGRA20_SLINK is not set
CONFIG_SPI_TOPCLIFF_PCH=m
# CONFIG_SPI_TXX9 is not set
# CONFIG_SPI_XCOMM is not set
# CONFIG_SPI_XILINX is not set
# CONFIG_SPI_DESIGNWARE is not set

#
# SPI Protocol Masters
#
# CONFIG_SPI_SPIDEV is not set
# CONFIG_SPI_TLE62X0 is not set
CONFIG_HSI=m
CONFIG_HSI_BOARDINFO=y

#
# HSI clients
#
CONFIG_HSI_CHAR=m

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
CONFIG_DP83640_PHY=m
CONFIG_PTP_1588_CLOCK_PCH=m
CONFIG_ARCH_WANT_OPTIONAL_GPIOLIB=y
CONFIG_GPIO_DEVRES=y
CONFIG_GPIOLIB=y
CONFIG_GPIO_ACPI=y
CONFIG_DEBUG_GPIO=y
CONFIG_GPIO_SYSFS=y
CONFIG_GPIO_DA9052=m
CONFIG_GPIO_MAX730X=y

#
# Memory mapped GPIO drivers:
#
# CONFIG_GPIO_GENERIC_PLATFORM is not set
CONFIG_GPIO_IT8761E=m
CONFIG_GPIO_TS5500=y
CONFIG_GPIO_SCH=m
CONFIG_GPIO_ICH=y
# CONFIG_GPIO_VX855 is not set
# CONFIG_GPIO_LYNXPOINT is not set

#
# I2C GPIO expanders:
#
# CONFIG_GPIO_ARIZONA is not set
CONFIG_GPIO_MAX7300=m
# CONFIG_GPIO_MAX732X is not set
CONFIG_GPIO_PCA953X=y
CONFIG_GPIO_PCA953X_IRQ=y
# CONFIG_GPIO_PCF857X is not set
# CONFIG_GPIO_RC5T583 is not set
# CONFIG_GPIO_SX150X is not set
CONFIG_GPIO_TC3589X=y
# CONFIG_GPIO_TPS65912 is not set
# CONFIG_GPIO_WM831X is not set
CONFIG_GPIO_WM8350=m
# CONFIG_GPIO_WM8994 is not set
CONFIG_GPIO_ADP5588=m

#
# PCI GPIO expanders:
#
CONFIG_GPIO_BT8XX=m
# CONFIG_GPIO_AMD8111 is not set
# CONFIG_GPIO_LANGWELL is not set
# CONFIG_GPIO_PCH is not set
CONFIG_GPIO_ML_IOH=y
CONFIG_GPIO_RDC321X=y

#
# SPI GPIO expanders:
#
CONFIG_GPIO_MAX7301=y
CONFIG_GPIO_MCP23S08=m
CONFIG_GPIO_MC33880=y
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

#
# USB GPIO expanders:
#
CONFIG_W1=m

#
# 1-wire Bus Masters
#
# CONFIG_W1_MASTER_MATROX is not set
# CONFIG_W1_MASTER_DS2482 is not set
CONFIG_W1_MASTER_DS1WM=m
CONFIG_W1_MASTER_GPIO=m

#
# 1-wire Slaves
#
CONFIG_W1_SLAVE_THERM=m
# CONFIG_W1_SLAVE_SMEM is not set
# CONFIG_W1_SLAVE_DS2408 is not set
CONFIG_W1_SLAVE_DS2413=m
CONFIG_W1_SLAVE_DS2423=m
CONFIG_W1_SLAVE_DS2431=m
CONFIG_W1_SLAVE_DS2433=m
CONFIG_W1_SLAVE_DS2433_CRC=y
# CONFIG_W1_SLAVE_DS2760 is not set
# CONFIG_W1_SLAVE_DS2780 is not set
CONFIG_W1_SLAVE_DS2781=m
CONFIG_W1_SLAVE_DS28E04=m
CONFIG_W1_SLAVE_BQ27000=m
CONFIG_POWER_SUPPLY=y
CONFIG_POWER_SUPPLY_DEBUG=y
CONFIG_PDA_POWER=y
CONFIG_MAX8925_POWER=m
CONFIG_WM831X_BACKUP=m
CONFIG_WM831X_POWER=m
CONFIG_WM8350_POWER=y
# CONFIG_TEST_POWER is not set
CONFIG_BATTERY_88PM860X=m
# CONFIG_BATTERY_DS2780 is not set
# CONFIG_BATTERY_DS2781 is not set
# CONFIG_BATTERY_DS2782 is not set
# CONFIG_BATTERY_SBS is not set
# CONFIG_BATTERY_BQ27x00 is not set
CONFIG_BATTERY_DA9030=m
CONFIG_BATTERY_DA9052=m
CONFIG_BATTERY_MAX17040=m
CONFIG_BATTERY_MAX17042=m
CONFIG_CHARGER_88PM860X=m
CONFIG_CHARGER_PCF50633=m
CONFIG_CHARGER_MAX8903=m
# CONFIG_CHARGER_LP8727 is not set
# CONFIG_CHARGER_GPIO is not set
CONFIG_CHARGER_MAX8997=y
CONFIG_CHARGER_BQ2415X=m
CONFIG_CHARGER_SMB347=y
# CONFIG_BATTERY_GOLDFISH is not set
CONFIG_POWER_RESET=y
CONFIG_POWER_AVS=y
CONFIG_HWMON=y
CONFIG_HWMON_VID=y
# CONFIG_HWMON_DEBUG_CHIP is not set

#
# Native drivers
#
# CONFIG_SENSORS_AD7314 is not set
# CONFIG_SENSORS_AD7414 is not set
CONFIG_SENSORS_AD7418=y
CONFIG_SENSORS_ADCXX=y
CONFIG_SENSORS_ADM1021=m
CONFIG_SENSORS_ADM1025=y
CONFIG_SENSORS_ADM1026=y
CONFIG_SENSORS_ADM1029=y
# CONFIG_SENSORS_ADM1031 is not set
# CONFIG_SENSORS_ADM9240 is not set
CONFIG_SENSORS_ADT7X10=y
CONFIG_SENSORS_ADT7310=y
CONFIG_SENSORS_ADT7410=y
CONFIG_SENSORS_ADT7411=y
# CONFIG_SENSORS_ADT7462 is not set
CONFIG_SENSORS_ADT7470=y
CONFIG_SENSORS_ADT7475=m
CONFIG_SENSORS_ASC7621=y
CONFIG_SENSORS_K8TEMP=y
# CONFIG_SENSORS_K10TEMP is not set
CONFIG_SENSORS_FAM15H_POWER=y
CONFIG_SENSORS_ASB100=m
CONFIG_SENSORS_ATXP1=m
CONFIG_SENSORS_DS620=m
CONFIG_SENSORS_DS1621=m
CONFIG_SENSORS_DA9052_ADC=y
# CONFIG_SENSORS_I5K_AMB is not set
CONFIG_SENSORS_F71805F=y
# CONFIG_SENSORS_F71882FG is not set
CONFIG_SENSORS_F75375S=m
CONFIG_SENSORS_FSCHMD=y
CONFIG_SENSORS_G760A=y
CONFIG_SENSORS_G762=m
# CONFIG_SENSORS_GL518SM is not set
CONFIG_SENSORS_GL520SM=m
# CONFIG_SENSORS_GPIO_FAN is not set
CONFIG_SENSORS_HIH6130=m
# CONFIG_SENSORS_CORETEMP is not set
CONFIG_SENSORS_IT87=m
CONFIG_SENSORS_JC42=m
# CONFIG_SENSORS_LINEAGE is not set
CONFIG_SENSORS_LM63=m
# CONFIG_SENSORS_LM70 is not set
CONFIG_SENSORS_LM73=y
CONFIG_SENSORS_LM75=y
# CONFIG_SENSORS_LM77 is not set
# CONFIG_SENSORS_LM78 is not set
CONFIG_SENSORS_LM80=m
CONFIG_SENSORS_LM83=y
# CONFIG_SENSORS_LM85 is not set
# CONFIG_SENSORS_LM87 is not set
CONFIG_SENSORS_LM90=y
# CONFIG_SENSORS_LM92 is not set
CONFIG_SENSORS_LM93=m
CONFIG_SENSORS_LTC4151=y
CONFIG_SENSORS_LTC4215=m
CONFIG_SENSORS_LTC4245=m
CONFIG_SENSORS_LTC4261=y
CONFIG_SENSORS_LM95234=m
# CONFIG_SENSORS_LM95241 is not set
CONFIG_SENSORS_LM95245=y
CONFIG_SENSORS_MAX1111=y
CONFIG_SENSORS_MAX16065=m
CONFIG_SENSORS_MAX1619=y
# CONFIG_SENSORS_MAX1668 is not set
# CONFIG_SENSORS_MAX197 is not set
CONFIG_SENSORS_MAX6639=y
CONFIG_SENSORS_MAX6642=y
# CONFIG_SENSORS_MAX6650 is not set
# CONFIG_SENSORS_MAX6697 is not set
# CONFIG_SENSORS_MCP3021 is not set
CONFIG_SENSORS_NCT6775=y
# CONFIG_SENSORS_NTC_THERMISTOR is not set
# CONFIG_SENSORS_PC87360 is not set
CONFIG_SENSORS_PC87427=y
CONFIG_SENSORS_PCF8591=y
CONFIG_PMBUS=y
CONFIG_SENSORS_PMBUS=y
# CONFIG_SENSORS_ADM1275 is not set
CONFIG_SENSORS_LM25066=y
CONFIG_SENSORS_LTC2978=y
CONFIG_SENSORS_MAX16064=y
CONFIG_SENSORS_MAX34440=m
CONFIG_SENSORS_MAX8688=y
# CONFIG_SENSORS_UCD9000 is not set
CONFIG_SENSORS_UCD9200=m
CONFIG_SENSORS_ZL6100=y
CONFIG_SENSORS_SHT15=m
CONFIG_SENSORS_SHT21=y
# CONFIG_SENSORS_SIS5595 is not set
# CONFIG_SENSORS_SMM665 is not set
CONFIG_SENSORS_DME1737=m
CONFIG_SENSORS_EMC1403=y
# CONFIG_SENSORS_EMC2103 is not set
CONFIG_SENSORS_EMC6W201=y
CONFIG_SENSORS_SMSC47M1=y
CONFIG_SENSORS_SMSC47M192=m
CONFIG_SENSORS_SMSC47B397=m
# CONFIG_SENSORS_SCH56XX_COMMON is not set
CONFIG_SENSORS_ADS1015=m
CONFIG_SENSORS_ADS7828=m
CONFIG_SENSORS_ADS7871=m
CONFIG_SENSORS_AMC6821=y
CONFIG_SENSORS_INA209=y
CONFIG_SENSORS_INA2XX=m
# CONFIG_SENSORS_THMC50 is not set
CONFIG_SENSORS_TMP102=m
CONFIG_SENSORS_TMP401=y
# CONFIG_SENSORS_TMP421 is not set
CONFIG_SENSORS_VIA_CPUTEMP=m
CONFIG_SENSORS_VIA686A=m
CONFIG_SENSORS_VT1211=y
CONFIG_SENSORS_VT8231=m
CONFIG_SENSORS_W83781D=m
CONFIG_SENSORS_W83791D=y
CONFIG_SENSORS_W83792D=y
CONFIG_SENSORS_W83793=y
CONFIG_SENSORS_W83795=m
# CONFIG_SENSORS_W83795_FANCTRL is not set
# CONFIG_SENSORS_W83L785TS is not set
CONFIG_SENSORS_W83L786NG=y
# CONFIG_SENSORS_W83627HF is not set
# CONFIG_SENSORS_W83627EHF is not set
CONFIG_SENSORS_WM831X=m
CONFIG_SENSORS_WM8350=y
# CONFIG_SENSORS_APPLESMC is not set
CONFIG_SENSORS_MC13783_ADC=y

#
# ACPI drivers
#
# CONFIG_SENSORS_ACPI_POWER is not set
CONFIG_SENSORS_ATK0110=y
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

#
# Texas Instruments thermal drivers
#
# CONFIG_WATCHDOG is not set
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
# CONFIG_BCMA_HOST_PCI is not set
# CONFIG_BCMA_HOST_SOC is not set
CONFIG_BCMA_DRIVER_GMAC_CMN=y
# CONFIG_BCMA_DRIVER_GPIO is not set
# CONFIG_BCMA_DEBUG is not set

#
# Multifunction device drivers
#
CONFIG_MFD_CORE=y
# CONFIG_MFD_CS5535 is not set
CONFIG_MFD_AS3711=y
# CONFIG_PMIC_ADP5520 is not set
CONFIG_MFD_AAT2870_CORE=y
CONFIG_MFD_CROS_EC=y
CONFIG_MFD_CROS_EC_I2C=y
CONFIG_MFD_CROS_EC_SPI=y
CONFIG_PMIC_DA903X=y
CONFIG_PMIC_DA9052=y
CONFIG_MFD_DA9052_SPI=y
# CONFIG_MFD_DA9052_I2C is not set
# CONFIG_MFD_DA9055 is not set
CONFIG_MFD_DA9063=y
CONFIG_MFD_MC13783=y
CONFIG_MFD_MC13XXX=y
CONFIG_MFD_MC13XXX_SPI=y
# CONFIG_MFD_MC13XXX_I2C is not set
CONFIG_HTC_PASIC3=y
# CONFIG_HTC_I2CPLD is not set
CONFIG_LPC_ICH=y
CONFIG_LPC_SCH=y
# CONFIG_MFD_JANZ_CMODIO is not set
CONFIG_MFD_KEMPLD=y
CONFIG_MFD_88PM800=y
CONFIG_MFD_88PM805=y
CONFIG_MFD_88PM860X=y
# CONFIG_MFD_MAX77686 is not set
CONFIG_MFD_MAX77693=y
CONFIG_MFD_MAX8907=m
CONFIG_MFD_MAX8925=y
CONFIG_MFD_MAX8997=y
# CONFIG_MFD_MAX8998 is not set
CONFIG_EZX_PCAP=y
CONFIG_MFD_RETU=m
CONFIG_MFD_PCF50633=m
# CONFIG_PCF50633_ADC is not set
CONFIG_PCF50633_GPIO=m
CONFIG_MFD_RDC321X=y
# CONFIG_MFD_RTSX_PCI is not set
CONFIG_MFD_RC5T583=y
# CONFIG_MFD_SEC_CORE is not set
# CONFIG_MFD_SI476X_CORE is not set
# CONFIG_MFD_SM501 is not set
CONFIG_MFD_SMSC=y
CONFIG_ABX500_CORE=y
# CONFIG_AB3100_CORE is not set
# CONFIG_MFD_STMPE is not set
# CONFIG_MFD_SYSCON is not set
# CONFIG_MFD_TI_AM335X_TSCADC is not set
# CONFIG_MFD_LP8788 is not set
# CONFIG_MFD_PALMAS is not set
CONFIG_TPS6105X=y
CONFIG_TPS65010=m
# CONFIG_TPS6507X is not set
# CONFIG_MFD_TPS65090 is not set
CONFIG_MFD_TPS65217=y
# CONFIG_MFD_TPS6586X is not set
# CONFIG_MFD_TPS65910 is not set
CONFIG_MFD_TPS65912=y
CONFIG_MFD_TPS65912_I2C=y
CONFIG_MFD_TPS65912_SPI=y
CONFIG_MFD_TPS80031=y
# CONFIG_TWL4030_CORE is not set
# CONFIG_TWL6040_CORE is not set
CONFIG_MFD_WL1273_CORE=y
# CONFIG_MFD_LM3533 is not set
# CONFIG_MFD_TIMBERDALE is not set
CONFIG_MFD_TC3589X=y
# CONFIG_MFD_TMIO is not set
CONFIG_MFD_VX855=m
CONFIG_MFD_ARIZONA=y
CONFIG_MFD_ARIZONA_I2C=m
CONFIG_MFD_ARIZONA_SPI=y
# CONFIG_MFD_WM5102 is not set
CONFIG_MFD_WM5110=y
CONFIG_MFD_WM8997=y
# CONFIG_MFD_WM8400 is not set
CONFIG_MFD_WM831X=y
# CONFIG_MFD_WM831X_I2C is not set
CONFIG_MFD_WM831X_SPI=y
CONFIG_MFD_WM8350=y
CONFIG_MFD_WM8350_I2C=y
CONFIG_MFD_WM8994=y
CONFIG_REGULATOR=y
# CONFIG_REGULATOR_DEBUG is not set
# CONFIG_REGULATOR_DUMMY is not set
CONFIG_REGULATOR_FIXED_VOLTAGE=y
CONFIG_REGULATOR_VIRTUAL_CONSUMER=y
CONFIG_REGULATOR_USERSPACE_CONSUMER=m
# CONFIG_REGULATOR_88PM800 is not set
CONFIG_REGULATOR_88PM8607=y
CONFIG_REGULATOR_AD5398=y
# CONFIG_REGULATOR_AAT2870 is not set
CONFIG_REGULATOR_AS3711=y
# CONFIG_REGULATOR_DA903X is not set
# CONFIG_REGULATOR_DA9052 is not set
# CONFIG_REGULATOR_DA9210 is not set
CONFIG_REGULATOR_FAN53555=y
# CONFIG_REGULATOR_GPIO is not set
CONFIG_REGULATOR_ISL6271A=y
# CONFIG_REGULATOR_LP3971 is not set
CONFIG_REGULATOR_LP3972=m
# CONFIG_REGULATOR_LP872X is not set
CONFIG_REGULATOR_LP8755=m
CONFIG_REGULATOR_MAX1586=m
CONFIG_REGULATOR_MAX8649=m
# CONFIG_REGULATOR_MAX8660 is not set
CONFIG_REGULATOR_MAX8907=m
CONFIG_REGULATOR_MAX8925=m
CONFIG_REGULATOR_MAX8952=y
CONFIG_REGULATOR_MAX8973=y
CONFIG_REGULATOR_MAX8997=y
# CONFIG_REGULATOR_MAX77693 is not set
CONFIG_REGULATOR_MC13XXX_CORE=y
CONFIG_REGULATOR_MC13783=m
CONFIG_REGULATOR_MC13892=y
CONFIG_REGULATOR_PCAP=m
# CONFIG_REGULATOR_PCF50633 is not set
# CONFIG_REGULATOR_PFUZE100 is not set
CONFIG_REGULATOR_RC5T583=m
CONFIG_REGULATOR_TPS51632=m
CONFIG_REGULATOR_TPS6105X=m
CONFIG_REGULATOR_TPS62360=m
CONFIG_REGULATOR_TPS65023=y
CONFIG_REGULATOR_TPS6507X=y
CONFIG_REGULATOR_TPS65217=m
# CONFIG_REGULATOR_TPS6524X is not set
CONFIG_REGULATOR_TPS65912=y
CONFIG_REGULATOR_TPS80031=y
CONFIG_REGULATOR_WM831X=m
# CONFIG_REGULATOR_WM8350 is not set
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
CONFIG_MEDIA_CONTROLLER=y
CONFIG_VIDEO_DEV=y
CONFIG_VIDEO_V4L2_SUBDEV_API=y
CONFIG_VIDEO_V4L2=y
CONFIG_VIDEO_ADV_DEBUG=y
# CONFIG_VIDEO_FIXED_MINOR_RANGES is not set
CONFIG_VIDEO_TUNER=y
CONFIG_V4L2_MEM2MEM_DEV=y
CONFIG_VIDEOBUF_GEN=y
CONFIG_VIDEOBUF_DMA_SG=y
CONFIG_VIDEOBUF_DMA_CONTIG=m
CONFIG_VIDEOBUF2_CORE=y
CONFIG_VIDEOBUF2_MEMOPS=y
CONFIG_VIDEOBUF2_DMA_CONTIG=y
CONFIG_VIDEOBUF2_VMALLOC=m
CONFIG_VIDEO_V4L2_INT_DEVICE=y
# CONFIG_TTPCI_EEPROM is not set

#
# Media drivers
#
CONFIG_RC_CORE=y
# CONFIG_RC_MAP is not set
# CONFIG_RC_DECODERS is not set
CONFIG_RC_DEVICES=y
# CONFIG_RC_ATI_REMOTE is not set
# CONFIG_IR_ENE is not set
# CONFIG_IR_IMON is not set
# CONFIG_IR_MCEUSB is not set
# CONFIG_IR_ITE_CIR is not set
# CONFIG_IR_FINTEK is not set
# CONFIG_IR_NUVOTON is not set
# CONFIG_IR_REDRAT3 is not set
# CONFIG_IR_STREAMZAP is not set
CONFIG_IR_WINBOND_CIR=y
# CONFIG_IR_IGUANA is not set
# CONFIG_IR_TTUSBIR is not set
CONFIG_RC_LOOPBACK=y
CONFIG_IR_GPIO_CIR=m
CONFIG_MEDIA_PCI_SUPPORT=y

#
# Media capture support
#

#
# Media capture/analog TV support
#
CONFIG_VIDEO_IVTV=m
CONFIG_VIDEO_FB_IVTV=m
CONFIG_VIDEO_ZORAN=y
# CONFIG_VIDEO_ZORAN_DC30 is not set
CONFIG_VIDEO_ZORAN_ZR36060=y
CONFIG_VIDEO_ZORAN_BUZ=y
CONFIG_VIDEO_ZORAN_DC10=y
# CONFIG_VIDEO_ZORAN_LML33 is not set
CONFIG_VIDEO_ZORAN_LML33R10=m
CONFIG_VIDEO_ZORAN_AVS6EYES=y
CONFIG_VIDEO_HEXIUM_GEMINI=y
# CONFIG_VIDEO_HEXIUM_ORION is not set
CONFIG_VIDEO_MXB=m

#
# Media capture/analog/hybrid TV support
#
# CONFIG_VIDEO_CX25821 is not set
# CONFIG_VIDEO_CX88 is not set
# CONFIG_VIDEO_BT848 is not set
CONFIG_VIDEO_SAA7134=y
# CONFIG_VIDEO_SAA7134_RC is not set
CONFIG_V4L_PLATFORM_DRIVERS=y
# CONFIG_VIDEO_CAFE_CCIC is not set
CONFIG_VIDEO_VIA_CAMERA=m
CONFIG_VIDEO_TIMBERDALE=m
# CONFIG_SOC_CAMERA is not set
CONFIG_V4L_MEM2MEM_DRIVERS=y
CONFIG_VIDEO_MEM2MEM_DEINTERLACE=y
# CONFIG_VIDEO_SH_VEU is not set
CONFIG_V4L_TEST_DRIVERS=y
CONFIG_VIDEO_VIVI=m
CONFIG_VIDEO_MEM2MEM_TESTDEV=m

#
# Supported MMC/SDIO adapters
#
CONFIG_MEDIA_PARPORT_SUPPORT=y
# CONFIG_VIDEO_PMS is not set
CONFIG_RADIO_ADAPTERS=y
# CONFIG_RADIO_SI470X is not set
CONFIG_I2C_SI4713=y
CONFIG_RADIO_SI4713=y
CONFIG_RADIO_TEA5764=m
# CONFIG_RADIO_SAA7706H is not set
CONFIG_RADIO_TEF6862=y
CONFIG_RADIO_WL1273=y

#
# Texas Instruments WL128x FM driver (ST based)
#
# CONFIG_V4L_RADIO_ISA_DRIVERS is not set
CONFIG_VIDEO_CX2341X=m
CONFIG_VIDEO_TVEEPROM=y
CONFIG_VIDEO_SAA7146=y
CONFIG_VIDEO_SAA7146_VV=y

#
# Media ancillary drivers (tuners, sensors, i2c, frontends)
#
CONFIG_MEDIA_SUBDRV_AUTOSELECT=y
CONFIG_MEDIA_ATTACH=y
CONFIG_VIDEO_IR_I2C=y

#
# Audio decoders, processors and mixers
#
CONFIG_VIDEO_TDA9840=m
CONFIG_VIDEO_TEA6415C=m
CONFIG_VIDEO_TEA6420=m
CONFIG_VIDEO_MSP3400=m
CONFIG_VIDEO_CS53L32A=m
CONFIG_VIDEO_WM8775=m
CONFIG_VIDEO_WM8739=m
CONFIG_VIDEO_VP27SMPX=m

#
# RDS decoders
#
CONFIG_VIDEO_SAA6588=y

#
# Video decoders
#
CONFIG_VIDEO_ADV7180=m
CONFIG_VIDEO_BT856=y
CONFIG_VIDEO_BT866=y
CONFIG_VIDEO_KS0127=y
CONFIG_VIDEO_SAA7110=y
CONFIG_VIDEO_SAA711X=y

#
# Video and audio decoders
#
CONFIG_VIDEO_SAA717X=m
CONFIG_VIDEO_CX25840=m

#
# Video encoders
#
CONFIG_VIDEO_SAA7127=m
CONFIG_VIDEO_SAA7185=y
CONFIG_VIDEO_ADV7170=m
CONFIG_VIDEO_ADV7175=y

#
# Camera sensor devices
#
CONFIG_VIDEO_OV7670=m

#
# Flash devices
#

#
# Video improvement chips
#
CONFIG_VIDEO_UPD64031A=m
CONFIG_VIDEO_UPD64083=m

#
# Miscelaneous helper chips
#
CONFIG_VIDEO_M52790=m

#
# Sensors used on soc_camera driver
#
CONFIG_MEDIA_TUNER=y
CONFIG_MEDIA_TUNER_SIMPLE=y
CONFIG_MEDIA_TUNER_TDA8290=y
CONFIG_MEDIA_TUNER_TDA827X=y
CONFIG_MEDIA_TUNER_TDA18271=y
CONFIG_MEDIA_TUNER_TDA9887=y
CONFIG_MEDIA_TUNER_TEA5761=y
CONFIG_MEDIA_TUNER_TEA5767=y
CONFIG_MEDIA_TUNER_MT20XX=y
CONFIG_MEDIA_TUNER_XC2028=y
CONFIG_MEDIA_TUNER_XC5000=y
CONFIG_MEDIA_TUNER_XC4000=y
CONFIG_MEDIA_TUNER_MC44S803=y

#
# Tools to develop new frontends
#
# CONFIG_DVB_DUMMY_FE is not set

#
# Graphics support
#
# CONFIG_AGP is not set
CONFIG_VGA_ARB=y
CONFIG_VGA_ARB_MAX_GPUS=16
CONFIG_VGA_SWITCHEROO=y
CONFIG_DRM=y
CONFIG_DRM_KMS_HELPER=y
# CONFIG_DRM_LOAD_EDID_FIRMWARE is not set
CONFIG_DRM_TTM=y

#
# I2C encoder or helper chips
#
CONFIG_DRM_I2C_CH7006=m
# CONFIG_DRM_I2C_SIL164 is not set
# CONFIG_DRM_I2C_NXP_TDA998X is not set
CONFIG_DRM_TDFX=y
CONFIG_DRM_R128=y
CONFIG_DRM_RADEON=m
CONFIG_DRM_RADEON_UMS=y
CONFIG_DRM_NOUVEAU=y
CONFIG_NOUVEAU_DEBUG=5
CONFIG_NOUVEAU_DEBUG_DEFAULT=3
# CONFIG_DRM_NOUVEAU_BACKLIGHT is not set
# CONFIG_DRM_MGA is not set
CONFIG_DRM_VIA=y
CONFIG_DRM_SAVAGE=m
CONFIG_DRM_VMWGFX=m
# CONFIG_DRM_VMWGFX_FBCON is not set
CONFIG_DRM_GMA500=m
CONFIG_DRM_GMA600=y
# CONFIG_DRM_GMA3600 is not set
# CONFIG_DRM_UDL is not set
CONFIG_DRM_AST=m
# CONFIG_DRM_MGAG200 is not set
# CONFIG_DRM_CIRRUS_QEMU is not set
CONFIG_DRM_QXL=m
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
CONFIG_FB_SYS_FILLRECT=m
CONFIG_FB_SYS_COPYAREA=m
CONFIG_FB_SYS_IMAGEBLIT=m
CONFIG_FB_FOREIGN_ENDIAN=y
# CONFIG_FB_BOTH_ENDIAN is not set
# CONFIG_FB_BIG_ENDIAN is not set
CONFIG_FB_LITTLE_ENDIAN=y
CONFIG_FB_SYS_FOPS=m
CONFIG_FB_DEFERRED_IO=y
CONFIG_FB_HECUBA=m
CONFIG_FB_SVGALIB=m
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
CONFIG_FB_ARC=m
CONFIG_FB_ASILIANT=y
CONFIG_FB_IMSTT=y
# CONFIG_FB_VGA16 is not set
# CONFIG_FB_VESA is not set
CONFIG_FB_N411=m
CONFIG_FB_HGA=m
# CONFIG_FB_S1D13XXX is not set
CONFIG_FB_NVIDIA=m
CONFIG_FB_NVIDIA_I2C=y
CONFIG_FB_NVIDIA_DEBUG=y
# CONFIG_FB_NVIDIA_BACKLIGHT is not set
CONFIG_FB_RIVA=y
# CONFIG_FB_RIVA_I2C is not set
CONFIG_FB_RIVA_DEBUG=y
CONFIG_FB_RIVA_BACKLIGHT=y
CONFIG_FB_I740=m
# CONFIG_FB_LE80578 is not set
# CONFIG_FB_MATROX is not set
# CONFIG_FB_RADEON is not set
CONFIG_FB_ATY128=m
CONFIG_FB_ATY128_BACKLIGHT=y
CONFIG_FB_ATY=m
# CONFIG_FB_ATY_CT is not set
# CONFIG_FB_ATY_GX is not set
# CONFIG_FB_ATY_BACKLIGHT is not set
# CONFIG_FB_S3 is not set
CONFIG_FB_SAVAGE=m
# CONFIG_FB_SAVAGE_I2C is not set
# CONFIG_FB_SAVAGE_ACCEL is not set
CONFIG_FB_SIS=y
CONFIG_FB_SIS_300=y
# CONFIG_FB_SIS_315 is not set
CONFIG_FB_VIA=m
CONFIG_FB_VIA_DIRECT_PROCFS=y
CONFIG_FB_VIA_X_COMPATIBILITY=y
CONFIG_FB_NEOMAGIC=m
CONFIG_FB_KYRO=m
CONFIG_FB_3DFX=y
# CONFIG_FB_3DFX_ACCEL is not set
CONFIG_FB_3DFX_I2C=y
CONFIG_FB_VOODOO1=m
CONFIG_FB_VT8623=m
CONFIG_FB_TRIDENT=y
# CONFIG_FB_ARK is not set
CONFIG_FB_PM3=y
# CONFIG_FB_CARMINE is not set
CONFIG_FB_GEODE=y
# CONFIG_FB_GEODE_LX is not set
CONFIG_FB_GEODE_GX=y
CONFIG_FB_GEODE_GX1=m
CONFIG_FB_TMIO=y
CONFIG_FB_TMIO_ACCELL=y
CONFIG_FB_GOLDFISH=y
# CONFIG_FB_VIRTUAL is not set
CONFIG_FB_METRONOME=m
# CONFIG_FB_MB862XX is not set
CONFIG_FB_BROADSHEET=m
# CONFIG_FB_AUO_K190X is not set
CONFIG_FB_HYPERV=m
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
CONFIG_LCD_VGG2432A4=m
CONFIG_LCD_PLATFORM=m
CONFIG_LCD_S6E63M0=m
CONFIG_LCD_LD9040=m
CONFIG_LCD_AMS369FG06=m
# CONFIG_LCD_LMS501KF03 is not set
CONFIG_LCD_HX8357=m
CONFIG_BACKLIGHT_CLASS_DEVICE=y
CONFIG_BACKLIGHT_GENERIC=m
CONFIG_BACKLIGHT_PWM=m
CONFIG_BACKLIGHT_DA903X=y
CONFIG_BACKLIGHT_DA9052=m
CONFIG_BACKLIGHT_MAX8925=m
# CONFIG_BACKLIGHT_APPLE is not set
# CONFIG_BACKLIGHT_SAHARA is not set
CONFIG_BACKLIGHT_WM831X=y
CONFIG_BACKLIGHT_ADP8860=m
CONFIG_BACKLIGHT_ADP8870=m
CONFIG_BACKLIGHT_88PM860X=y
# CONFIG_BACKLIGHT_PCF50633 is not set
CONFIG_BACKLIGHT_AAT2870=y
CONFIG_BACKLIGHT_LM3630=m
CONFIG_BACKLIGHT_LM3639=y
CONFIG_BACKLIGHT_LP855X=y
CONFIG_BACKLIGHT_TPS65217=y
CONFIG_BACKLIGHT_AS3711=m
# CONFIG_BACKLIGHT_GPIO is not set
# CONFIG_BACKLIGHT_LV5207LP is not set
# CONFIG_BACKLIGHT_BD6107 is not set
# CONFIG_LOGO is not set
# CONFIG_SOUND is not set

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
# CONFIG_HID_A4TECH is not set
CONFIG_HID_ACRUX=y
# CONFIG_HID_ACRUX_FF is not set
# CONFIG_HID_APPLE is not set
CONFIG_HID_AUREAL=m
# CONFIG_HID_BELKIN is not set
CONFIG_HID_CHERRY=m
CONFIG_HID_CHICONY=y
# CONFIG_HID_CYPRESS is not set
CONFIG_HID_DRAGONRISE=m
CONFIG_DRAGONRISE_FF=y
# CONFIG_HID_EMS_FF is not set
CONFIG_HID_ELECOM=y
CONFIG_HID_EZKEY=m
CONFIG_HID_KEYTOUCH=y
CONFIG_HID_KYE=m
# CONFIG_HID_UCLOGIC is not set
CONFIG_HID_WALTOP=y
# CONFIG_HID_GYRATION is not set
CONFIG_HID_ICADE=y
CONFIG_HID_TWINHAN=m
CONFIG_HID_KENSINGTON=y
# CONFIG_HID_LCPOWER is not set
# CONFIG_HID_LOGITECH is not set
# CONFIG_HID_MAGICMOUSE is not set
# CONFIG_HID_MICROSOFT is not set
CONFIG_HID_MONTEREY=m
CONFIG_HID_MULTITOUCH=m
# CONFIG_HID_ORTEK is not set
CONFIG_HID_PANTHERLORD=y
CONFIG_PANTHERLORD_FF=y
CONFIG_HID_PETALYNX=m
# CONFIG_HID_PICOLCD is not set
CONFIG_HID_PRIMAX=y
CONFIG_HID_SAITEK=m
# CONFIG_HID_SAMSUNG is not set
CONFIG_HID_SPEEDLINK=y
CONFIG_HID_STEELSERIES=y
# CONFIG_HID_SUNPLUS is not set
CONFIG_HID_GREENASIA=y
CONFIG_GREENASIA_FF=y
CONFIG_HID_HYPERV_MOUSE=m
# CONFIG_HID_SMARTJOYPLUS is not set
# CONFIG_HID_TIVO is not set
# CONFIG_HID_TOPSEED is not set
CONFIG_HID_THINGM=y
CONFIG_HID_THRUSTMASTER=m
CONFIG_THRUSTMASTER_FF=y
# CONFIG_HID_WACOM is not set
CONFIG_HID_WIIMOTE=m
CONFIG_HID_XINMO=m
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
# CONFIG_NOP_USB_XCEIV is not set
# CONFIG_OMAP_CONTROL_USB is not set
# CONFIG_OMAP_USB3 is not set
# CONFIG_AM335X_PHY_USB is not set
# CONFIG_SAMSUNG_USB2PHY is not set
# CONFIG_SAMSUNG_USB3PHY is not set
# CONFIG_USB_GPIO_VBUS is not set
# CONFIG_USB_GADGET is not set
CONFIG_UWB=y
CONFIG_UWB_WHCI=y
CONFIG_MMC=y
CONFIG_MMC_DEBUG=y
CONFIG_MMC_UNSAFE_RESUME=y
CONFIG_MMC_CLKGATE=y

#
# MMC/SD/SDIO Card Drivers
#
CONFIG_MMC_BLOCK=m
CONFIG_MMC_BLOCK_MINORS=8
CONFIG_MMC_BLOCK_BOUNCE=y
CONFIG_SDIO_UART=y
# CONFIG_MMC_TEST is not set

#
# MMC/SD/SDIO Host Controller Drivers
#
CONFIG_MMC_SDHCI=m
CONFIG_MMC_SDHCI_PCI=m
CONFIG_MMC_RICOH_MMC=y
# CONFIG_MMC_SDHCI_ACPI is not set
CONFIG_MMC_SDHCI_PLTFM=m
CONFIG_MMC_WBSD=m
CONFIG_MMC_TIFM_SD=y
# CONFIG_MMC_CB710 is not set
CONFIG_MMC_VIA_SDMMC=m
CONFIG_MEMSTICK=y
CONFIG_MEMSTICK_DEBUG=y

#
# MemoryStick drivers
#
CONFIG_MEMSTICK_UNSAFE_RESUME=y
CONFIG_MSPRO_BLOCK=y
CONFIG_MS_BLOCK=m

#
# MemoryStick Host Controller Drivers
#
CONFIG_MEMSTICK_TIFM_MS=m
CONFIG_MEMSTICK_JMICRON_38X=m
CONFIG_MEMSTICK_R592=m
CONFIG_NEW_LEDS=y
CONFIG_LEDS_CLASS=y

#
# LED drivers
#
# CONFIG_LEDS_88PM860X is not set
CONFIG_LEDS_LM3530=y
CONFIG_LEDS_LM3642=y
# CONFIG_LEDS_PCA9532 is not set
CONFIG_LEDS_GPIO=y
# CONFIG_LEDS_LP3944 is not set
CONFIG_LEDS_LP55XX_COMMON=m
CONFIG_LEDS_LP5521=m
CONFIG_LEDS_LP5523=m
# CONFIG_LEDS_LP5562 is not set
CONFIG_LEDS_LP8501=m
CONFIG_LEDS_PCA955X=m
CONFIG_LEDS_PCA963X=m
CONFIG_LEDS_WM831X_STATUS=m
# CONFIG_LEDS_WM8350 is not set
CONFIG_LEDS_DA903X=m
# CONFIG_LEDS_DA9052 is not set
# CONFIG_LEDS_DAC124S085 is not set
CONFIG_LEDS_PWM=y
CONFIG_LEDS_REGULATOR=y
CONFIG_LEDS_BD2802=y
CONFIG_LEDS_LT3593=y
# CONFIG_LEDS_DELL_NETBOOKS is not set
CONFIG_LEDS_MC13783=m
CONFIG_LEDS_TCA6507=y
CONFIG_LEDS_MAX8997=m
# CONFIG_LEDS_LM355x is not set
CONFIG_LEDS_OT200=y
CONFIG_LEDS_BLINKM=m

#
# LED Triggers
#
CONFIG_LEDS_TRIGGERS=y
CONFIG_LEDS_TRIGGER_TIMER=m
# CONFIG_LEDS_TRIGGER_ONESHOT is not set
CONFIG_LEDS_TRIGGER_HEARTBEAT=m
CONFIG_LEDS_TRIGGER_BACKLIGHT=m
CONFIG_LEDS_TRIGGER_CPU=y
CONFIG_LEDS_TRIGGER_GPIO=m
CONFIG_LEDS_TRIGGER_DEFAULT_ON=y

#
# iptables trigger is under Netfilter config (LED target)
#
# CONFIG_LEDS_TRIGGER_TRANSIENT is not set
CONFIG_LEDS_TRIGGER_CAMERA=y
CONFIG_ACCESSIBILITY=y
CONFIG_INFINIBAND=m
CONFIG_INFINIBAND_USER_MAD=m
CONFIG_INFINIBAND_USER_ACCESS=m
CONFIG_INFINIBAND_USER_MEM=y
CONFIG_INFINIBAND_ADDR_TRANS=y
CONFIG_INFINIBAND_MTHCA=m
CONFIG_INFINIBAND_MTHCA_DEBUG=y
CONFIG_INFINIBAND_AMSO1100=m
CONFIG_INFINIBAND_AMSO1100_DEBUG=y
CONFIG_INFINIBAND_NES=m
# CONFIG_INFINIBAND_NES_DEBUG is not set
CONFIG_INFINIBAND_IPOIB=m
CONFIG_INFINIBAND_IPOIB_CM=y
# CONFIG_INFINIBAND_IPOIB_DEBUG is not set
CONFIG_INFINIBAND_SRP=m
CONFIG_INFINIBAND_ISER=m
CONFIG_EDAC=y
# CONFIG_EDAC_LEGACY_SYSFS is not set
# CONFIG_EDAC_DEBUG is not set
CONFIG_EDAC_MM_EDAC=y
# CONFIG_EDAC_AMD76X is not set
CONFIG_EDAC_E7XXX=y
CONFIG_EDAC_E752X=y
CONFIG_EDAC_I82875P=m
# CONFIG_EDAC_I82975X is not set
CONFIG_EDAC_I3000=m
CONFIG_EDAC_I3200=y
# CONFIG_EDAC_X38 is not set
CONFIG_EDAC_I5400=m
# CONFIG_EDAC_I82860 is not set
# CONFIG_EDAC_R82600 is not set
CONFIG_EDAC_I5000=y
CONFIG_EDAC_I5100=m
CONFIG_EDAC_I7300=y
CONFIG_RTC_LIB=y
# CONFIG_RTC_CLASS is not set
CONFIG_DMADEVICES=y
# CONFIG_DMADEVICES_DEBUG is not set

#
# DMA Devices
#
CONFIG_INTEL_MID_DMAC=y
CONFIG_INTEL_IOATDMA=y
CONFIG_DW_DMAC_CORE=y
CONFIG_DW_DMAC=m
# CONFIG_DW_DMAC_PCI is not set
CONFIG_TIMB_DMA=m
CONFIG_PCH_DMA=y
CONFIG_DMA_ENGINE=y
CONFIG_DMA_ACPI=y

#
# DMA Clients
#
CONFIG_NET_DMA=y
# CONFIG_ASYNC_TX_DMA is not set
CONFIG_DMATEST=y
CONFIG_DCA=y
# CONFIG_AUXDISPLAY is not set
CONFIG_UIO=y
# CONFIG_UIO_CIF is not set
# CONFIG_UIO_PDRV_GENIRQ is not set
# CONFIG_UIO_DMEM_GENIRQ is not set
CONFIG_UIO_AEC=y
# CONFIG_UIO_SERCOS3 is not set
CONFIG_UIO_PCI_GENERIC=m
CONFIG_UIO_NETX=m
# CONFIG_VIRT_DRIVERS is not set
CONFIG_VIRTIO=m

#
# Virtio drivers
#
CONFIG_VIRTIO_PCI=m
CONFIG_VIRTIO_BALLOON=m
CONFIG_VIRTIO_MMIO=m
CONFIG_VIRTIO_MMIO_CMDLINE_DEVICES=y

#
# Microsoft Hyper-V guest support
#
CONFIG_HYPERV=m
CONFIG_HYPERV_BALLOON=m
# CONFIG_STAGING is not set
CONFIG_X86_PLATFORM_DEVICES=y
# CONFIG_ACER_WMI is not set
# CONFIG_ACERHDF is not set
CONFIG_ASUS_LAPTOP=y
CONFIG_DELL_LAPTOP=m
CONFIG_DELL_WMI=m
# CONFIG_DELL_WMI_AIO is not set
CONFIG_FUJITSU_LAPTOP=y
CONFIG_FUJITSU_LAPTOP_DEBUG=y
CONFIG_FUJITSU_TABLET=y
CONFIG_TC1100_WMI=y
# CONFIG_HP_ACCEL is not set
CONFIG_HP_WMI=y
# CONFIG_PANASONIC_LAPTOP is not set
# CONFIG_THINKPAD_ACPI is not set
# CONFIG_SENSORS_HDAPS is not set
# CONFIG_INTEL_MENLOW is not set
CONFIG_EEEPC_LAPTOP=y
CONFIG_ASUS_WMI=m
CONFIG_ASUS_NB_WMI=m
CONFIG_EEEPC_WMI=m
CONFIG_ACPI_WMI=y
CONFIG_MSI_WMI=y
CONFIG_TOPSTAR_LAPTOP=y
CONFIG_ACPI_TOSHIBA=m
CONFIG_TOSHIBA_BT_RFKILL=y
CONFIG_ACPI_CMPC=m
CONFIG_INTEL_IPS=m
# CONFIG_IBM_RTL is not set
CONFIG_XO15_EBOOK=m
# CONFIG_SAMSUNG_LAPTOP is not set
CONFIG_MXM_WMI=y
CONFIG_SAMSUNG_Q10=y
CONFIG_APPLE_GMUX=m
CONFIG_INTEL_RST=y
CONFIG_INTEL_SMARTCONNECT=m
CONFIG_PVPANIC=m

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
CONFIG_REMOTEPROC=m
CONFIG_STE_MODEM_RPROC=m

#
# Rpmsg drivers
#
CONFIG_PM_DEVFREQ=y

#
# DEVFREQ Governors
#
# CONFIG_DEVFREQ_GOV_SIMPLE_ONDEMAND is not set
# CONFIG_DEVFREQ_GOV_PERFORMANCE is not set
# CONFIG_DEVFREQ_GOV_POWERSAVE is not set
CONFIG_DEVFREQ_GOV_USERSPACE=m

#
# DEVFREQ Drivers
#
CONFIG_EXTCON=m

#
# Extcon Device Drivers
#
CONFIG_EXTCON_GPIO=m
# CONFIG_EXTCON_MAX77693 is not set
# CONFIG_EXTCON_MAX8997 is not set
# CONFIG_MEMORY is not set
# CONFIG_IIO is not set
CONFIG_VME_BUS=y

#
# VME Bridge Drivers
#
CONFIG_VME_CA91CX42=y
CONFIG_VME_TSI148=m

#
# VME Board Drivers
#
# CONFIG_VMIVME_7805 is not set

#
# VME Device Drivers
#
CONFIG_PWM=y
CONFIG_PWM_SYSFS=y
CONFIG_IPACK_BUS=y
# CONFIG_BOARD_TPCI200 is not set
CONFIG_SERIAL_IPOCTAL=y
CONFIG_RESET_CONTROLLER=y
CONFIG_FMC=m
CONFIG_FMC_FAKEDEV=m
CONFIG_FMC_TRIVIAL=m
CONFIG_FMC_WRITE_EEPROM=m
CONFIG_FMC_CHARDEV=m

#
# Firmware Drivers
#
CONFIG_EDD=m
# CONFIG_EDD_OFF is not set
CONFIG_FIRMWARE_MEMMAP=y
# CONFIG_DELL_RBU is not set
CONFIG_DCDBAS=m
# CONFIG_ISCSI_IBFT_FIND is not set
CONFIG_GOOGLE_FIRMWARE=y

#
# Google Firmware Drivers
#

#
# File systems
#
CONFIG_DCACHE_WORD_ACCESS=y
# CONFIG_EXT2_FS is not set
CONFIG_EXT3_FS=y
CONFIG_EXT3_DEFAULTS_TO_ORDERED=y
CONFIG_EXT3_FS_XATTR=y
CONFIG_EXT3_FS_POSIX_ACL=y
CONFIG_EXT3_FS_SECURITY=y
# CONFIG_EXT4_FS is not set
CONFIG_JBD=y
CONFIG_JBD_DEBUG=y
CONFIG_JBD2=y
# CONFIG_JBD2_DEBUG is not set
CONFIG_FS_MBCACHE=y
CONFIG_REISERFS_FS=m
CONFIG_REISERFS_CHECK=y
# CONFIG_REISERFS_FS_XATTR is not set
CONFIG_JFS_FS=m
# CONFIG_JFS_POSIX_ACL is not set
# CONFIG_JFS_SECURITY is not set
CONFIG_JFS_DEBUG=y
CONFIG_JFS_STATISTICS=y
# CONFIG_XFS_FS is not set
CONFIG_OCFS2_FS=y
# CONFIG_OCFS2_FS_O2CB is not set
# CONFIG_OCFS2_FS_STATS is not set
# CONFIG_OCFS2_DEBUG_MASKLOG is not set
# CONFIG_OCFS2_DEBUG_FS is not set
# CONFIG_BTRFS_FS is not set
# CONFIG_NILFS2_FS is not set
CONFIG_FS_POSIX_ACL=y
CONFIG_EXPORTFS=y
# CONFIG_FILE_LOCKING is not set
CONFIG_FSNOTIFY=y
CONFIG_DNOTIFY=y
CONFIG_INOTIFY_USER=y
# CONFIG_FANOTIFY is not set
CONFIG_QUOTA=y
CONFIG_QUOTA_NETLINK_INTERFACE=y
CONFIG_PRINT_QUOTA_WARNING=y
# CONFIG_QUOTA_DEBUG is not set
CONFIG_QUOTA_TREE=y
CONFIG_QFMT_V1=m
CONFIG_QFMT_V2=y
CONFIG_QUOTACTL=y
CONFIG_AUTOFS4_FS=y
# CONFIG_FUSE_FS is not set

#
# Caches
#
CONFIG_FSCACHE=y
# CONFIG_FSCACHE_DEBUG is not set
# CONFIG_CACHEFILES is not set

#
# CD-ROM/DVD Filesystems
#
# CONFIG_ISO9660_FS is not set
CONFIG_UDF_FS=m
CONFIG_UDF_NLS=y

#
# DOS/FAT/NT Filesystems
#
# CONFIG_MSDOS_FS is not set
# CONFIG_VFAT_FS is not set
# CONFIG_NTFS_FS is not set

#
# Pseudo filesystems
#
# CONFIG_PROC_FS is not set
CONFIG_SYSFS=y
CONFIG_HUGETLBFS=y
CONFIG_HUGETLB_PAGE=y
CONFIG_CONFIGFS_FS=y
CONFIG_MISC_FILESYSTEMS=y
CONFIG_ADFS_FS=y
# CONFIG_ADFS_FS_RW is not set
CONFIG_AFFS_FS=y
CONFIG_ECRYPT_FS=m
CONFIG_ECRYPT_FS_MESSAGING=y
CONFIG_HFS_FS=m
CONFIG_HFSPLUS_FS=y
CONFIG_HFSPLUS_FS_POSIX_ACL=y
CONFIG_BEFS_FS=m
CONFIG_BEFS_DEBUG=y
CONFIG_BFS_FS=m
CONFIG_EFS_FS=m
CONFIG_JFFS2_FS=m
CONFIG_JFFS2_FS_DEBUG=0
CONFIG_JFFS2_FS_WRITEBUFFER=y
# CONFIG_JFFS2_FS_WBUF_VERIFY is not set
# CONFIG_JFFS2_SUMMARY is not set
# CONFIG_JFFS2_FS_XATTR is not set
CONFIG_JFFS2_COMPRESSION_OPTIONS=y
CONFIG_JFFS2_ZLIB=y
# CONFIG_JFFS2_LZO is not set
# CONFIG_JFFS2_RTIME is not set
# CONFIG_JFFS2_RUBIN is not set
# CONFIG_JFFS2_CMODE_NONE is not set
# CONFIG_JFFS2_CMODE_PRIORITY is not set
# CONFIG_JFFS2_CMODE_SIZE is not set
CONFIG_JFFS2_CMODE_FAVOURLZO=y
CONFIG_LOGFS=m
# CONFIG_CRAMFS is not set
# CONFIG_SQUASHFS is not set
CONFIG_VXFS_FS=y
CONFIG_MINIX_FS=y
# CONFIG_OMFS_FS is not set
# CONFIG_HPFS_FS is not set
CONFIG_QNX4FS_FS=y
CONFIG_QNX6FS_FS=m
# CONFIG_QNX6FS_DEBUG is not set
CONFIG_ROMFS_FS=m
# CONFIG_ROMFS_BACKED_BY_BLOCK is not set
# CONFIG_ROMFS_BACKED_BY_MTD is not set
CONFIG_ROMFS_BACKED_BY_BOTH=y
CONFIG_ROMFS_ON_BLOCK=y
CONFIG_ROMFS_ON_MTD=y
CONFIG_PSTORE=y
CONFIG_PSTORE_CONSOLE=y
# CONFIG_PSTORE_RAM is not set
CONFIG_SYSV_FS=m
CONFIG_UFS_FS=y
# CONFIG_UFS_FS_WRITE is not set
CONFIG_UFS_DEBUG=y
CONFIG_F2FS_FS=m
# CONFIG_F2FS_STAT_FS is not set
CONFIG_F2FS_FS_XATTR=y
# CONFIG_F2FS_FS_POSIX_ACL is not set
CONFIG_F2FS_FS_SECURITY=y
# CONFIG_NETWORK_FILESYSTEMS is not set
CONFIG_NLS=y
CONFIG_NLS_DEFAULT="iso8859-1"
# CONFIG_NLS_CODEPAGE_437 is not set
CONFIG_NLS_CODEPAGE_737=y
# CONFIG_NLS_CODEPAGE_775 is not set
CONFIG_NLS_CODEPAGE_850=y
# CONFIG_NLS_CODEPAGE_852 is not set
CONFIG_NLS_CODEPAGE_855=m
CONFIG_NLS_CODEPAGE_857=y
CONFIG_NLS_CODEPAGE_860=y
# CONFIG_NLS_CODEPAGE_861 is not set
CONFIG_NLS_CODEPAGE_862=m
CONFIG_NLS_CODEPAGE_863=y
# CONFIG_NLS_CODEPAGE_864 is not set
# CONFIG_NLS_CODEPAGE_865 is not set
# CONFIG_NLS_CODEPAGE_866 is not set
# CONFIG_NLS_CODEPAGE_869 is not set
# CONFIG_NLS_CODEPAGE_936 is not set
# CONFIG_NLS_CODEPAGE_950 is not set
CONFIG_NLS_CODEPAGE_932=y
# CONFIG_NLS_CODEPAGE_949 is not set
CONFIG_NLS_CODEPAGE_874=y
CONFIG_NLS_ISO8859_8=m
CONFIG_NLS_CODEPAGE_1250=y
CONFIG_NLS_CODEPAGE_1251=m
CONFIG_NLS_ASCII=y
CONFIG_NLS_ISO8859_1=m
CONFIG_NLS_ISO8859_2=y
CONFIG_NLS_ISO8859_3=m
CONFIG_NLS_ISO8859_4=m
# CONFIG_NLS_ISO8859_5 is not set
# CONFIG_NLS_ISO8859_6 is not set
CONFIG_NLS_ISO8859_7=y
# CONFIG_NLS_ISO8859_9 is not set
CONFIG_NLS_ISO8859_13=m
CONFIG_NLS_ISO8859_14=y
# CONFIG_NLS_ISO8859_15 is not set
CONFIG_NLS_KOI8_R=y
CONFIG_NLS_KOI8_U=m
# CONFIG_NLS_MAC_ROMAN is not set
# CONFIG_NLS_MAC_CELTIC is not set
CONFIG_NLS_MAC_CENTEURO=m
# CONFIG_NLS_MAC_CROATIAN is not set
# CONFIG_NLS_MAC_CYRILLIC is not set
# CONFIG_NLS_MAC_GAELIC is not set
# CONFIG_NLS_MAC_GREEK is not set
CONFIG_NLS_MAC_ICELAND=m
# CONFIG_NLS_MAC_INUIT is not set
CONFIG_NLS_MAC_ROMANIAN=m
# CONFIG_NLS_MAC_TURKISH is not set
CONFIG_NLS_UTF8=y
# CONFIG_DLM is not set

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
# CONFIG_DEBUG_INFO is not set
CONFIG_ENABLE_WARN_DEPRECATED=y
CONFIG_ENABLE_MUST_CHECK=y
CONFIG_FRAME_WARN=1024
CONFIG_STRIP_ASM_SYMS=y
CONFIG_READABLE_ASM=y
# CONFIG_UNUSED_SYMBOLS is not set
CONFIG_DEBUG_FS=y
CONFIG_HEADERS_CHECK=y
# CONFIG_DEBUG_SECTION_MISMATCH is not set
CONFIG_ARCH_WANT_FRAME_POINTERS=y
CONFIG_FRAME_POINTER=y
# CONFIG_DEBUG_FORCE_WEAK_PER_CPU is not set
# CONFIG_MAGIC_SYSRQ is not set
CONFIG_DEBUG_KERNEL=y

#
# Memory Debugging
#
# CONFIG_DEBUG_PAGEALLOC is not set
# CONFIG_DEBUG_OBJECTS is not set
# CONFIG_SLUB_DEBUG_ON is not set
# CONFIG_SLUB_STATS is not set
CONFIG_HAVE_DEBUG_KMEMLEAK=y
# CONFIG_DEBUG_KMEMLEAK is not set
CONFIG_DEBUG_STACK_USAGE=y
# CONFIG_DEBUG_VM is not set
# CONFIG_DEBUG_VIRTUAL is not set
# CONFIG_DEBUG_MEMORY_INIT is not set
# CONFIG_DEBUG_PER_CPU_MAPS is not set
CONFIG_DEBUG_HIGHMEM=y
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
CONFIG_DETECT_HUNG_TASK=y
CONFIG_DEFAULT_HUNG_TASK_TIMEOUT=120
# CONFIG_BOOTPARAM_HUNG_TASK_PANIC is not set
CONFIG_BOOTPARAM_HUNG_TASK_PANIC_VALUE=0
# CONFIG_PANIC_ON_OOPS is not set
CONFIG_PANIC_ON_OOPS_VALUE=0

#
# Lock Debugging (spinlocks, mutexes, etc...)
#
CONFIG_DEBUG_RT_MUTEXES=y
CONFIG_DEBUG_PI_LIST=y
# CONFIG_RT_MUTEX_TESTER is not set
CONFIG_DEBUG_SPINLOCK=y
CONFIG_DEBUG_MUTEXES=y
CONFIG_DEBUG_WW_MUTEX_SLOWPATH=y
CONFIG_DEBUG_LOCK_ALLOC=y
CONFIG_PROVE_LOCKING=y
CONFIG_LOCKDEP=y
CONFIG_LOCK_STAT=y
# CONFIG_DEBUG_LOCKDEP is not set
CONFIG_DEBUG_ATOMIC_SLEEP=y
CONFIG_DEBUG_LOCKING_API_SELFTESTS=y
CONFIG_TRACE_IRQFLAGS=y
CONFIG_STACKTRACE=y
# CONFIG_DEBUG_KOBJECT is not set
CONFIG_DEBUG_KOBJECT_RELEASE=y
CONFIG_DEBUG_BUGVERBOSE=y
CONFIG_DEBUG_WRITECOUNT=y
CONFIG_DEBUG_LIST=y
# CONFIG_DEBUG_SG is not set
CONFIG_DEBUG_NOTIFIERS=y
CONFIG_DEBUG_CREDENTIALS=y

#
# RCU Debugging
#
CONFIG_PROVE_RCU=y
# CONFIG_PROVE_RCU_REPEATEDLY is not set
CONFIG_SPARSE_RCU_POINTER=y
# CONFIG_RCU_TORTURE_TEST is not set
CONFIG_RCU_CPU_STALL_TIMEOUT=21
CONFIG_RCU_CPU_STALL_INFO=y
# CONFIG_RCU_TRACE is not set
# CONFIG_DEBUG_BLOCK_EXT_DEVT is not set
# CONFIG_NOTIFIER_ERROR_INJECTION is not set
CONFIG_FAULT_INJECTION=y
# CONFIG_FAILSLAB is not set
# CONFIG_FAIL_PAGE_ALLOC is not set
# CONFIG_FAIL_MAKE_REQUEST is not set
# CONFIG_FAIL_IO_TIMEOUT is not set
# CONFIG_FAIL_MMC_REQUEST is not set
CONFIG_FAULT_INJECTION_DEBUG_FS=y
CONFIG_FAULT_INJECTION_STACKTRACE_FILTER=y
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
CONFIG_TRACING_SUPPORT=y
# CONFIG_FTRACE is not set

#
# Runtime Testing
#
# CONFIG_LKDTM is not set
CONFIG_TEST_LIST_SORT=y
# CONFIG_KPROBES_SANITY_TEST is not set
# CONFIG_BACKTRACE_SELF_TEST is not set
CONFIG_RBTREE_TEST=y
CONFIG_INTERVAL_TREE_TEST=m
# CONFIG_ATOMIC64_SELFTEST is not set
# CONFIG_ASYNC_RAID6_TEST is not set
# CONFIG_TEST_STRING_HELPERS is not set
CONFIG_TEST_KSTRTOX=m
CONFIG_PROVIDE_OHCI1394_DMA_INIT=y
CONFIG_BUILD_DOCSRC=y
CONFIG_DMA_API_DEBUG=y
# CONFIG_SAMPLES is not set
CONFIG_HAVE_ARCH_KGDB=y
# CONFIG_KGDB is not set
CONFIG_STRICT_DEVMEM=y
# CONFIG_X86_VERBOSE_BOOTUP is not set
# CONFIG_EARLY_PRINTK is not set
CONFIG_X86_PTDUMP=y
CONFIG_DEBUG_RODATA=y
# CONFIG_DEBUG_RODATA_TEST is not set
CONFIG_DEBUG_SET_MODULE_RONX=y
CONFIG_DEBUG_NX_TEST=m
# CONFIG_DOUBLEFAULT is not set
CONFIG_DEBUG_TLBFLUSH=y
CONFIG_IOMMU_STRESS=y
CONFIG_HAVE_MMIOTRACE_SUPPORT=y
CONFIG_X86_DECODER_SELFTEST=y
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
CONFIG_DEBUG_NMI_SELFTEST=y
CONFIG_X86_DEBUG_STATIC_CPU_HAS=y

#
# Security options
#
CONFIG_KEYS=y
CONFIG_TRUSTED_KEYS=y
# CONFIG_ENCRYPTED_KEYS is not set
# CONFIG_KEYS_DEBUG_PROC_KEYS is not set
# CONFIG_SECURITY_DMESG_RESTRICT is not set
# CONFIG_SECURITY is not set
CONFIG_SECURITYFS=y
CONFIG_DEFAULT_SECURITY_DAC=y
CONFIG_DEFAULT_SECURITY=""
CONFIG_XOR_BLOCKS=m
CONFIG_ASYNC_CORE=m
CONFIG_ASYNC_MEMCPY=m
CONFIG_ASYNC_XOR=m
CONFIG_ASYNC_PQ=m
CONFIG_ASYNC_RAID6_RECOV=m
CONFIG_CRYPTO=y

#
# Crypto core or helper
#
CONFIG_CRYPTO_FIPS=y
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
CONFIG_CRYPTO_USER=m
# CONFIG_CRYPTO_MANAGER_DISABLE_TESTS is not set
CONFIG_CRYPTO_GF128MUL=y
CONFIG_CRYPTO_NULL=y
CONFIG_CRYPTO_PCRYPT=m
CONFIG_CRYPTO_WORKQUEUE=y
CONFIG_CRYPTO_CRYPTD=y
CONFIG_CRYPTO_AUTHENC=y
CONFIG_CRYPTO_TEST=m
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
CONFIG_CRYPTO_CTS=y
CONFIG_CRYPTO_ECB=m
CONFIG_CRYPTO_LRW=y
CONFIG_CRYPTO_PCBC=m
CONFIG_CRYPTO_XTS=y

#
# Hash modes
#
CONFIG_CRYPTO_CMAC=m
CONFIG_CRYPTO_HMAC=y
CONFIG_CRYPTO_XCBC=m
CONFIG_CRYPTO_VMAC=m

#
# Digest
#
CONFIG_CRYPTO_CRC32C=y
CONFIG_CRYPTO_CRC32C_INTEL=y
CONFIG_CRYPTO_CRC32=y
CONFIG_CRYPTO_CRC32_PCLMUL=y
CONFIG_CRYPTO_GHASH=y
CONFIG_CRYPTO_MD4=m
CONFIG_CRYPTO_MD5=y
CONFIG_CRYPTO_MICHAEL_MIC=y
CONFIG_CRYPTO_RMD128=m
CONFIG_CRYPTO_RMD160=m
CONFIG_CRYPTO_RMD256=y
# CONFIG_CRYPTO_RMD320 is not set
CONFIG_CRYPTO_SHA1=y
CONFIG_CRYPTO_SHA256=m
CONFIG_CRYPTO_SHA512=m
# CONFIG_CRYPTO_TGR192 is not set
CONFIG_CRYPTO_WP512=y

#
# Ciphers
#
CONFIG_CRYPTO_AES=y
CONFIG_CRYPTO_AES_586=m
CONFIG_CRYPTO_AES_NI_INTEL=m
# CONFIG_CRYPTO_ANUBIS is not set
CONFIG_CRYPTO_ARC4=y
CONFIG_CRYPTO_BLOWFISH=m
CONFIG_CRYPTO_BLOWFISH_COMMON=m
CONFIG_CRYPTO_CAMELLIA=y
CONFIG_CRYPTO_CAST_COMMON=m
# CONFIG_CRYPTO_CAST5 is not set
CONFIG_CRYPTO_CAST6=m
CONFIG_CRYPTO_DES=y
CONFIG_CRYPTO_FCRYPT=y
# CONFIG_CRYPTO_KHAZAD is not set
# CONFIG_CRYPTO_SALSA20 is not set
CONFIG_CRYPTO_SALSA20_586=y
# CONFIG_CRYPTO_SEED is not set
CONFIG_CRYPTO_SERPENT=y
CONFIG_CRYPTO_SERPENT_SSE2_586=y
CONFIG_CRYPTO_TEA=y
CONFIG_CRYPTO_TWOFISH=y
CONFIG_CRYPTO_TWOFISH_COMMON=y
CONFIG_CRYPTO_TWOFISH_586=y

#
# Compression
#
CONFIG_CRYPTO_DEFLATE=m
CONFIG_CRYPTO_ZLIB=y
CONFIG_CRYPTO_LZO=y
CONFIG_CRYPTO_LZ4=y
# CONFIG_CRYPTO_LZ4HC is not set

#
# Random Number Generation
#
CONFIG_CRYPTO_ANSI_CPRNG=y
CONFIG_CRYPTO_USER_API=y
CONFIG_CRYPTO_USER_API_HASH=m
CONFIG_CRYPTO_USER_API_SKCIPHER=y
# CONFIG_CRYPTO_HW is not set
CONFIG_ASYMMETRIC_KEY_TYPE=m
CONFIG_ASYMMETRIC_PUBLIC_KEY_SUBTYPE=m
CONFIG_PUBLIC_KEY_ALGO_RSA=m
# CONFIG_X509_CERTIFICATE_PARSER is not set
CONFIG_HAVE_KVM=y
CONFIG_VIRTUALIZATION=y
# CONFIG_LGUEST is not set
# CONFIG_BINARY_PRINTF is not set

#
# Library routines
#
CONFIG_RAID6_PQ=m
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
CONFIG_CRC_T10DIF=m
CONFIG_CRC_ITU_T=m
CONFIG_CRC32=y
# CONFIG_CRC32_SELFTEST is not set
# CONFIG_CRC32_SLICEBY8 is not set
# CONFIG_CRC32_SLICEBY4 is not set
# CONFIG_CRC32_SARWATE is not set
CONFIG_CRC32_BIT=y
CONFIG_CRC7=m
CONFIG_LIBCRC32C=y
# CONFIG_CRC8 is not set
CONFIG_CRC64_ECMA=m
CONFIG_AUDIT_GENERIC=y
CONFIG_ZLIB_INFLATE=y
CONFIG_ZLIB_DEFLATE=y
CONFIG_LZO_COMPRESS=y
CONFIG_LZO_DECOMPRESS=y
CONFIG_LZ4_COMPRESS=y
CONFIG_LZ4_DECOMPRESS=y
CONFIG_XZ_DEC=y
# CONFIG_XZ_DEC_X86 is not set
CONFIG_XZ_DEC_POWERPC=y
# CONFIG_XZ_DEC_IA64 is not set
CONFIG_XZ_DEC_ARM=y
# CONFIG_XZ_DEC_ARMTHUMB is not set
CONFIG_XZ_DEC_SPARC=y
CONFIG_XZ_DEC_BCJ=y
# CONFIG_XZ_DEC_TEST is not set
CONFIG_DECOMPRESS_GZIP=y
CONFIG_GENERIC_ALLOCATOR=y
CONFIG_REED_SOLOMON=m
CONFIG_REED_SOLOMON_DEC16=y
CONFIG_BCH=m
CONFIG_BCH_CONST_PARAMS=y
CONFIG_TEXTSEARCH=y
CONFIG_TEXTSEARCH_KMP=m
CONFIG_TEXTSEARCH_BM=m
CONFIG_TEXTSEARCH_FSM=m
CONFIG_BTREE=y
CONFIG_HAS_IOMEM=y
CONFIG_HAS_IOPORT=y
CONFIG_HAS_DMA=y
CONFIG_CHECK_SIGNATURE=y
CONFIG_CPU_RMAP=y
CONFIG_DQL=y
CONFIG_NLATTR=y
CONFIG_ARCH_HAS_ATOMIC64_DEC_IF_POSITIVE=y
CONFIG_AVERAGE=y
CONFIG_CLZ_TAB=y
# CONFIG_CORDIC is not set
# CONFIG_DDR is not set
CONFIG_MPILIB=m
CONFIG_FONT_SUPPORT=m
CONFIG_FONT_8x16=y
CONFIG_FONT_AUTOSELECT=y

--VbJkn9YxBvnuCH5J--
